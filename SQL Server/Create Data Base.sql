
CREATE DATABASE sales_opportunity;

USE sales_opportunity;

CREATE TABLE [sales_teams] (
    [agent_id] INT  NOT NULL ,
    [sales_agent] VARCHAR(100)  NOT NULL ,
    [manager] VARCHAR(100) ,
    [regional_office] VARCHAR(20) ,
    CONSTRAINT [PK_sales_teams] PRIMARY KEY CLUSTERED (
        [agent_id] ASC
    )
)

CREATE TABLE [products] (
    [product_id] INT  NOT NULL ,
    [product_name] VARCHAR(25)  NOT NULL ,
    [series] VARCHAR(10)  NOT NULL ,
    [sales_price] INT  NOT NULL ,
    CONSTRAINT [PK_products] PRIMARY KEY CLUSTERED (
        [product_id] ASC
    )
)

CREATE TABLE [accounts] (
    [account_id] INT  NOT NULL ,
    [account_name] VARCHAR(255)  NOT NULL ,
    [sector] VARCHAR(100)  NOT NULL ,
	[year_established] INT ,
    [revenue] FLOAT ,
    [employees] INT ,
    [office_location] VARCHAR(100) ,
    [subsidiary_of] VARCHAR(255) ,
    CONSTRAINT [PK_accounts] PRIMARY KEY CLUSTERED (
        [account_id] ASC
    )
)

CREATE TABLE [sales] (
    [opportunity_id] VARCHAR(8)  NOT NULL ,
    [agent_id] INT ,
    [product_id] INT ,
    [account_id] INT ,
    [deal_stage] VARCHAR(50) ,
    [engage_date] DATE ,
    [close_date] DATE ,
    [close_value] FLOAT ,
    CONSTRAINT [PK_sales] PRIMARY KEY CLUSTERED (
        [opportunity_id] ASC
    )
)

ALTER TABLE [sales] WITH CHECK ADD CONSTRAINT [FK_sales_agent_id] FOREIGN KEY([agent_id])
REFERENCES [sales_teams] ([agent_id])

ALTER TABLE [sales] CHECK CONSTRAINT [FK_sales_agent_id]

ALTER TABLE [sales] WITH CHECK ADD CONSTRAINT [FK_sales_product_id] FOREIGN KEY([product_id])
REFERENCES [products] ([product_id])

ALTER TABLE [sales] CHECK CONSTRAINT [FK_sales_product_id]

ALTER TABLE [sales] WITH CHECK ADD CONSTRAINT [FK_sales_account_id] FOREIGN KEY([account_id])
REFERENCES [accounts] ([account_id])

ALTER TABLE [sales] CHECK CONSTRAINT [FK_sales_account_id]