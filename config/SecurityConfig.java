package com.book.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 允许所有跨域请求
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                // 禁用CSRF防护
                .csrf(csrf -> csrf.disable())
                // 配置权限规则
                .authorizeRequests(auth -> {
                    auth.anyRequest().permitAll();  // 所有请求允许匿名访问
                    System.out.println("Security config loaded: All requests permitted"); // 调试日志
                })
                // 禁用表单登录（可选）
                .formLogin().disable()
                // 禁用HTTP Basic认证（可选）
                .httpBasic().disable();

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        // 开发环境允许所有来源（生产环境应指定具体域名）
        config.setAllowedOriginPatterns(Arrays.asList("*"));
        config.setAllowedMethods(Arrays.asList("*"));
        config.setAllowedHeaders(Arrays.asList("*"));
        config.setAllowCredentials(false); // 使用通配符时必须禁用凭证

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }


}