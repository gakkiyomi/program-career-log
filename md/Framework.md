# Framework

### SpringSecurity

##### 认证流程

- - 用户使用用户名和密码进行登录。
  - `Spring Security`将获取到的用户名和密码封装成一个`Authentication`接口的实现类，比如常用的`UsernamePasswordAuthenticationToken`。
  - 将上述产生的`Authentication`对象传递给`AuthenticationManager`的实现类`ProviderManager`进行认证。
  - `ProviderManager`依次调用各个`AuthenticationProvider`进行认证，认证成功后返回一个封装了用户权限等信息的`Authentication`对象。
  - 将`AuthenticationManager`返回的`Authentication`对象赋予给当前的`SecurityContext`。

实战

自定义认证实体类 使用token进行验证,不使用密码认证

~~~java
package net.skycloud.cmdb.auth.model;

import net.skycloud.common.model.DecryptedToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author: fangcong
 * @description:
 * @create: Created by work on 2020-04-28 12:02
 **/
public class UserDetailsImpl implements UserDetails {

    private DecryptedToken token;

    public UserDetailsImpl(DecryptedToken token) {
        this.token = token;
    }

    private static List<GrantedAuthority> mapToGrantedAuthorities(List<String> roles) {
        return roles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
                .collect(Collectors.toList());
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public Collection<GrantedAuthority> getAuthorities() {
        List<String> roles = token.getRoles();
        if (roles == null) {
            roles = new ArrayList<String>();
        }
        return mapToGrantedAuthorities(roles);
    }

    @Override
    public String getPassword() {
        return "";
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public String getUsername() {
        return token.getName();
    }

    public DecryptedToken getToken() {
        return token;
    }
}


~~~

自定义AuthenticationProvider进行自定义认证

~~~java
package net.skycloud.cmdb.auth.security;

import net.skycloud.cmdb.auth.model.UserDetailsImpl;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Service;


/**
 * @author: fangcong
 * @description:
 * @create: Created by work on 2020-04-29 10:25
 */
@Service
public class SecurityAuthenticationProvider implements AuthenticationProvider {


    /**
     * 认证用户信息
     *
     * @param authentication
     * @return
     * @throws AuthenticationException
     */
    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities()
        );
        return authenticationToken;
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return true;
    }
}

~~~

security 配置

~~~java
package net.skycloud.cmdb.auth.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;


@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private AuthEntryPoint authEntryPoint;

    @Autowired
    private SecurityAuthenticationProvider provider;

    @Bean
    public AuthFilter authorizationFilterBean(){
        return new AuthFilter();
    }

    @Bean
    public AuthorityFilter authorityFilterBean(){
        return new AuthorityFilter();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                // disable csrf
                .csrf().disable()
                // for unauthorized
                .exceptionHandling().authenticationEntryPoint(authEntryPoint)
                .and()
                // do not create session
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                // for CORS request
                .antMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                // login url
                .antMatchers("/auth").permitAll()
                // static
                .antMatchers("/webjars/**").permitAll()
                // management
                .antMatchers("/actuator").permitAll()
                .antMatchers("/actuator/**").permitAll()
                // websocket
                .antMatchers("/endpoint").permitAll()
                .antMatchers("/endpoint/**").permitAll()
                //.antMatchers("/users").permitAll()
                // api doc
                .antMatchers("/prometheus").permitAll()
                .antMatchers("/prometheus/**").permitAll()
                .anyRequest().authenticated();

        // add custom filter before security framework UsernamePasswordAuthenticationFilter
        http
                .addFilterBefore(authorizationFilterBean(), UsernamePasswordAuthenticationFilter.class);
        http
                .addFilterAfter(authorityFilterBean(), AuthFilter.class);


        // disable page cache
        http.headers().cacheControl();
    }

    /**
     * Disable security for swagger.
     *
     * @param web
     * @throws Exception
     */
    public void configure(WebSecurity web) throws Exception {
        web.ignoring()
                .antMatchers(
                        "/v2/api-docs",
                        "/swagger-resources/configuration/ui",
                        "/swagger-resources",
                        "/swagger-resources/configuration/security",
                        "/swagger-ui.html");
    }

    /**
     * Config authentication.
     *
     * @param amb
     * @throws Exception
     */
    @Override
    protected void configure(AuthenticationManagerBuilder amb) throws Exception {
        amb.authenticationProvider(provider);
    }

}

~~~



认证之前将token放入Authentication中,再将`Authentication`对象赋予给当前的`SecurityContext`。

~~~java
package net.skycloud.cmdb.auth.security;

import net.skycloud.cmdb.auth.model.UserDetailsImpl;
import net.skycloud.cmdb.common.model.Common;
import net.skycloud.common.exception.JwtTokenErrorException;
import net.skycloud.common.model.DecryptedToken;
import net.skycloud.common.util.JwtUtils;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;
import java.util.stream.Stream;

/**
 * @author: fangcong
 * @description:
 * @create: Created by work on 2020-07-01 10:29
 **/
@Component
public class AuthFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws ServletException, IOException {
        if (request.getRequestURI().contains("/swagger-ui.html")
                || request.getRequestURI().contains("swagger-resources")
                || request.getRequestURI().contains("springfox-swagger-ui")
                || request.getRequestURI().contains("v2/api-docs")
                || request.getRequestURI().endsWith(".css")
                || request.getRequestURI().contains("actuator")
                || request.getRequestURI().contains("endpoint")
                || request.getRequestURI().contains("prometheus")
                || request.getRequestURI().contains("auth")
                || request.getRequestURI().endsWith(".js")
                || request.getMethod().equals(HttpMethod.OPTIONS.name())) {
            chain.doFilter(request, response);
            return;
        }
        Cookie[] cookies = request.getCookies();
        String token = null;
        DecryptedToken decryptedToken = null;
        if (cookies == null || cookies.length == 0) {
            chain.doFilter(request, response);
            return;
        } else {
            Optional<Cookie> optional = Stream.of(cookies).filter(x -> x.getName().equals(Common.ACCESS_TOKEN)).findAny();
            if (optional.isPresent()) {
                Cookie cookie = optional.get();
                token = cookie.getValue();
            } else {
                chain.doFilter(request, response);
                return;
            }
        }
        try {
            decryptedToken = JwtUtils.parseToken(token);
        } catch (JwtTokenErrorException e) {
            logger.error("token parse error ,this is not valid JWT Token");
            response.sendError(HttpStatus.UNAUTHORIZED.value(), HttpStatus.UNAUTHORIZED.getReasonPhrase());
            return;
        }
        UserDetails userDetails = new UserDetailsImpl(decryptedToken);
        // create authentication
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities()
        );
        // set authentication
        authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        // put authentication into context holder
        SecurityContextHolder.getContext().setAuthentication(authenticationToken);

        chain.doFilter(request, response);
    }
}

~~~

在调用auth模块rpc方法自定义token判断逻辑

~~~java
package net.skycloud.cmdb.auth.security;

import net.skycloud.cmdb.auth.model.UserDetailsImpl;
import net.skycloud.cmdb.rpc.client.RpcClient;
import net.skycloud.common.model.DecryptedToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author: fangcong
 * @description:
 * @create: Created by work on 2020-07-01 15:10
 **/
@Component
public class AuthorityFilter extends OncePerRequestFilter {

    @Autowired
    private RpcClient rpcClient;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws ServletException, IOException {
        //进行角色认证
        if (request.getRequestURI().contains("/swagger-ui.html")
                || request.getRequestURI().contains("swagger-resources")
                || request.getRequestURI().contains("springfox-swagger-ui")
                || request.getRequestURI().contains("v2/api-docs")
                || request.getRequestURI().endsWith(".css")
                || request.getRequestURI().contains("actuator")
                || request.getRequestURI().contains("endpoint")
                || request.getRequestURI().contains("prometheus")
                || request.getRequestURI().contains("auth")
                || request.getRequestURI().endsWith(".js")
                || request.getMethod().equals(HttpMethod.OPTIONS.name())) {
            chain.doFilter(request, response);
            return;
        } else {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null) {
                response.sendError(HttpStatus.UNAUTHORIZED.value(), HttpStatus.UNAUTHORIZED.getReasonPhrase());
                return;
            }
            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            DecryptedToken token = userDetails.getToken();
            String tokenStr = token.getToken();
            boolean perm = rpcClient.pathCheck(request, tokenStr);
            if (perm) {
                chain.doFilter(request, response);
                return;
            } else {
                response.sendError(HttpStatus.FORBIDDEN.value(), HttpStatus.FORBIDDEN.getReasonPhrase());
                return;
            }
        }
    }
}

~~~

