-- =====================================================
-- Projeto: COVID-19 Analytics
-- Arquivo: 01_create_tables.sql
-- Objetivo: Criar tabelas auxiliares a partir da base owid_covid_data
-- Observação: Script conforme utilizado no projeto (queries originais)
-- =====================================================

-- =====================================================
-- 1) TOTAL POR PAÍS (country_totals)
-- Descrição: consolida totais acumulados por país.
-- =====================================================
CREATE TABLE country_totals AS
SELECT
    location AS country,
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths
FROM owid_covid_data
WHERE continent IS NOT NULL
GROUP BY location;

-- =====================================================
-- 2) DIÁRIO POR PAÍS (daily_country)
-- Descrição: base diária por país (novos e acumulados).
-- =====================================================
CREATE TABLE daily_country AS
SELECT
    location AS country,
    date,
    total_cases,
    new_cases,
    total_deaths,
    new_deaths
FROM owid_covid_data
WHERE continent IS NOT NULL;

-- =====================================================
-- 3) MENSAL POR PAÍS (monthly_country)
-- Descrição: agregação mensal por país (novos casos e novas mortes).
-- =====================================================
CREATE TABLE monthly_country AS
SELECT
    location AS country,
    strftime('%Y-%m', date) AS year_month,
    SUM(new_cases) AS monthly_new_cases,
    SUM(new_deaths) AS monthly_new_deaths
FROM owid_covid_data
WHERE continent IS NOT NULL
GROUP BY country, year_month;

-- =====================================================
-- 4) BRASIL vs MUNDO (br_vs_world)
-- Descrição: comparação diária Brasil vs Mundo.
-- =====================================================
CREATE TABLE br_vs_world AS
SELECT
    date,
    SUM(CASE WHEN location = 'Brazil' THEN new_cases ELSE 0 END) AS br_new_cases,
    SUM(new_cases) AS world_new_cases,
    SUM(CASE WHEN location = 'Brazil' THEN total_cases ELSE 0 END) AS br_total_cases,
    SUM(total_cases) AS world_total_cases
FROM owid_covid_data
GROUP BY date;
