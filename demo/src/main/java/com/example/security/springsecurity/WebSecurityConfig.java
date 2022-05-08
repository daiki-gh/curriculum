package com.example.security.springsecurity;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.example.security.springsecurity.account.AccountService;

@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private AccountService userService;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
        .authorizeRequests()                                        //アクセスを制限（URL毎の権限管理の設定）
        .antMatchers("/login", "/login-error").permitAll()          ///login,/login-errorへのアクセスは誰でもOK（premitAll）
        .antMatchers("/**").hasRole("USER")                         //それ以外のアクセスはUSERのみ
        .and()                                                      //authorizeRequestsの設定を終了させて、別の設定を続ける(メソッドチェーンを終わらせずに)
        .formLogin()                                                //formでログイン認証
        .loginPage("/login").failureUrl("/login-error");
    }


    //変更点 ロード時に、「admin」ユーザを登録する。
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth
        .userDetailsService(userService)                            //userServiceを認証
        .passwordEncoder(passwordEncoder());

        if (userService.findAllList().isEmpty()) {
            userService.registerAdmin("admin", "secret", "admin@localhost");
            userService.registerManager("manager", "secret", "manager@localhost");
            userService.registerUser("user", "secret", "user@localhost");
        }
    }
    //変更点 PasswordEncoder(BCryptPasswordEncoder)メソッド
    @Bean
    public PasswordEncoder passwordEncoder() {
        //
        return new BCryptPasswordEncoder();
    }

}