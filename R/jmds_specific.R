
#' A Function to Automate the Pushing of an Analysis HTML file to the JMDS estate
#'
#' @param file The local analysis file
#' @param destination_file The destination file within the storage account, no filepath

jmds_push_analysis_storage <- function(file, destination_file) {

        vault_name <- "kvjmds"
        secret <- "stkey"
        endpoint <- "https://storjmds.dfs.core.windows.net/"
        container <- "jmds"
        file <- file
        destination_file <- paste0("jmdsplatform/analyses/", destination_file)

        push_blob_dl_azurekey(
                vault_name,
                secret,
                endpoint,
                container,
                file,
                destination_file
        )

}


#' A Function to Automate the Pushing of an Analysis HTML record to the JMDS estate
#'
#' @param destination_file The destination file within the storage account, no filepath
#' @param analysis_name The unique name of the analysis for record-keeping in the database
#' @param analysis_desc The description of the analysis for the database

jmds_push_analysis_record <- function(destination_file, analysis_name, analysis_desc) {

        vault_name <- "kvjmds"
        uid_secret <- "sqlwriteruid"
        pwd_secret <- "sqlwriterpass"
        server <- "jmds.database.windows.net"
        database <- "jmds"
        table_name <- "mdp.Analyses"
        data_frame <- data.frame(
                CompanyID = 1,
                AnalysisName = analysis_name,
                Description = analysis_desc,
                SensitivityLevel = 0,
                isTest = 0,
                APICall = gsub(".html", "", destination_file),
                Location = paste0("jmdsplatform/analyses/", destination_file)
        )

        push_data_db_azurekv(
                vault_name = vault_name,
                uid_secret = uid_secret,
                pwd_secret = pwd_secret,
                server = server,
                database = database,
                table_name = table_name,
                data_frame = data_frame
        )

}


#' A Function to Automate the Pushing of an Analysis to the JMDS estate
#'
#' @param input_filename The locally held Rmd file for analysis
#' @param output_filename The file name of the HTML analysis output
#' @param analysis_name The unique name of the analysis within the database
#' @param analysis_desc The description of the analysis for the database

jmds_push_analysis <- function(input_filename, output_filename, analysis_name, analysis_desc) {

        ip <- input_filename
        op <- output_filename
        an <- analysis_name
        ad <- analysis_desc

        rmarkdown::render(
                input = ip,
                output_file = op
        )

        jmds_push_analysis_storage(
                file = op,
                destination_file = op
        )

        jmds_push_analysis_record(
                destination_file = op,
                analysis_name = an,
                analysis_desc = ad
        )

}
