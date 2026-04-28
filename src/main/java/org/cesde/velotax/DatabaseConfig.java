package org.cesde.velotax;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.beans.factory.annotation.Value;

import javax.sql.DataSource;

@Configuration
public class DatabaseConfig {

    @Value("${app.database:mysql}")
    private String activeDatabase;

    // ============================================================================
    // MySQL DataSource Configuration
    // ============================================================================
    @Bean
    @Primary
    @ConditionalOnProperty(name = "app.database", havingValue = "mysql", matchIfMissing = true)
    public DataSource mysqlDataSource(
            @Value("${spring.datasource.url}") String url,
            @Value("${spring.datasource.username}") String username,
            @Value("${spring.datasource.password:}") String password,
            @Value("${spring.datasource.driver-class-name}") String driver) {
        return DataSourceBuilder.create()
                .driverClassName(driver)
                .url(url)
                .username(username)
                .password(password)
                .build();
    }

    // ============================================================================
    // SQL Server DataSource Configuration (Alternative)
    // ============================================================================
    @Bean
    @ConditionalOnProperty(name = "app.database", havingValue = "sqlserver")
    public DataSource sqlserverDataSource(
            @Value("${spring.datasource.sqlserver.url}") String url,
            @Value("${spring.datasource.sqlserver.username}") String username,
            @Value("${spring.datasource.sqlserver.password:}") String password,
            @Value("${spring.datasource.sqlserver.driver-class-name}") String driver) {
        return DataSourceBuilder.create()
                .driverClassName(driver)
                .url(url)
                .username(username)
                .password(password)
                .build();
    }
}
