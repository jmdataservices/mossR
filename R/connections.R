
#' A Function to Gain Rapid Access to an Azure SQL Database
#'
#' @param server The server name for access
#' @param database The database name
#' @param uid The user ID, provided as the email added if authenticating via Azure AD or the SQL username if authenticating via SQL login
#' @param pwd The password, only necessary for SQL login
#' @param auth Either "sql" or "ad", defaults as SQL - alternative is for Azure Active Directory login
#' @param query The query to be run

get_data_db_azurecreds <- function(server, database, uid, pwd, auth = "sql", query = "SELECT 'No query given.';") {

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
        gc()
        return(raw)

}
