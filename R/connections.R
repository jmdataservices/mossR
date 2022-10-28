
#' A Function to Gain Rapid Access to an Azure SQL Database
#'
#' @param server The server name for access
#' @param database The database name
#' @param uid The user ID, provided as the email added if authenticating via Azure AD or the SQL username if authenticating via SQL login
#' @param pwd The password, only necessary for SQL login
#' @param auth Either "sql" or "ad", defaults as SQL - alternative is for Azure Active Directory login
#' @param query The query to be run

get_data_db_azurecreds <- function(server, database, uid, pwd = "pwd_not_set", auth = "sql", query = "SELECT 'No query given.';") {

        driver <- "driver={ODBC Driver 17 for SQL Server};"
        server <- paste0("server=", server, ";")
        database <- paste0("database=", database, ";")
        uid <- paste0("uid=", uid, ";")
        pwd <- paste0("pwd=", pwd, ";")

        if (auth == "ad") {

                auth <- "authentication=ActiveDirectoryInteractive;"

                con_str <- paste0(
                        driver,
                        server,
                        database,
                        uid,
                        auth
                )

                con <- DBI::dbConnect(
                        odbc::odbc(),
                        .connection_string = con_str,
                        timeout = 5
                )

        } else if (auth == "sql") {

                con_str <- paste0(
                        driver,
                        server,
                        database,
                        uid,
                        pwd
                )

                con <- DBI::dbConnect(
                        odbc::odbc(),
                        .connection_string = con_str,
                        timeout = 5
                )

        } else {

                print("Auth does not have an appropriate value (either 'sql' or 'ad' should be given)")

        }

        raw <- DBI::dbGetQuery(
                conn = con,
                statement = query
        )

        dbDisconnect(con)

        rm(con, con_str, pwd, uid, auth, database, server, driver)

        return(raw)

}


#' A Function to Gain Rapid Access to an Azure Gen2 Data Lake
#'
#' @param endpoint The endpoint of the data lake being accessed
#' @param key The access key for the endpoint
#' @param container The container being accesses
#' @param directory The directory for which we would like to collect the metadata

get_data_dl_azurekey <- function(endpoint, key, container, directory) {

        st_ep <- AzureStor::adls_endpoint(
                endpoint = endpoint,
                key = key
        )

        st_cont <- AzureStor::adls_filesystem(
                st_ep,
                container
        )

        st_files <- AzureStor::list_adls_files(
                st_cont,
                dir = directory
        )

        return(st_files)

}


#' A Function to Rapidly Push a File to an Azure Gen2 Data Lake
#'
#' @param vault_name The name of the vault (not including the full URL), just the name
#' @param secret The name of the secret behind which the storage account key is held
#' @param endpoint The endpoint of the data lake being accessed
#' @param container The container into which we'll push a file
#' @param file The name of the local file that will be published
#' @param destination_file The full file path of the file as it will appear in storage

push_blob_dl_azurekey <- function(vault_name, secret, endpoint, container, file, destination_file) {

        vault <- paste0("https://", vault_name, ".vault.azure.net")

        vlt <- AzureKeyVault::key_vault(
                url = vault
        )

        seckey <- vlt$secrets$get(secret)
        seckey <- seckey$value

        st_ep <- AzureStor::adls_endpoint(
                endpoint = endpoint,
                key = seckey
        )

        st_cont <- AzureStor::adls_filesystem(
                st_ep,
                container
        )

        AzureStor::storage_upload(
                container = st_cont,
                src = file,
                dest = destination_file
        )

}


#' A Function to Publish a Record to an Azure SQL Database
#'
#' @param vault_name The name of the vault (not including the full URL), just the name
#' @param uid_secret The name of the secret behind which the database user ID is held
#' @param pwd_secret The name of the secret behind which the database password is held
#' @param driver This parameter defaults to 'ODBC Driver 17 for SQL Server' but can be changed
#' @param server The Azure SQL Server into which we're depositing data
#' @param database The Azure SQL Database into which we're depositing data
#' @param table_name The name of the table into which we're depositing data
#' @param data_frame The data packet being passed into the table - presented as a data frame

push_data_db_azurekv <- function(vault_name, uid_secret, pwd_secret, driver = "ODBC Driver 17 for SQL Server", server, database, table_name, data_frame) {

        vault <- paste0("https://", vault_name, ".vault.azure.net")

        vlt <- AzureKeyVault::key_vault(
                url = vault
        )

        secuid <- vlt$secrets$get(uid_secret)
        secuid <- secuid$value
        secpwd <- vlt$secrets$get(pwd_secret)
        secpwd <- secpwd$value

        con <- DBI::dbConnect(
                odbc::odbc(),
                driver = driver,
                server = server,
                database = database,
                uid = secuid,
                pwd = secpwd,
                timeout = 5
        )

        DBI::dbAppendTable(
                conn = con,
                name = DBI::SQL(table_name),
                value = data_frame
        )

        DBI::dbDisconnect(con)

}
