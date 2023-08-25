#' create a machine tag
#'
#' @param datasetkey uuid
#' @param namespace the name of the machinetag in general
#' @param name the name of the machineTag often similar to namespace
#' @param value the value of the machine tag
#' @param embedValueList use this to embed json into a string
#' @param api "gbif" or "uat"
#'
#' @return
#' Status message.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' create_mt(
#' datasetkey="38b4c89f-584c-41bb-bd8f-cd1def33e92f",
#' namespace="testMachineTag.jwaller.gbif.org",
#' name="testMachineTag",
#' value=1,
#' api="uat")
#' }
#'
create_mt <- function(datasetkey,
                      namespace,
                      name,
                      value,
                      embedValueList=FALSE,
                      api="gbif") {

  if(embedValueList) value <- value %>% jsonlite::toJSON(auto_unbox=TRUE) # use this to embed json into a string

  if(api == "uat") base <- "http://api.gbif-uat.org/v1/dataset/"
  if(api == "gbif") base <- "http://api.gbif.org/v1/dataset/"

  url <- paste0(base,datasetkey,"/machineTag")

  body <- list(namespace=namespace,
               name=name,
               value=value) # create list for machine tag

  # post request to gbif api
  httr2::request(url) %>%
  httr2::req_auth_basic(Sys.getenv("GBIF_USER", ""),
                        Sys.getenv("GBIF_PWD", "")) %>%
  httr2::req_body_json(body) %>%
  httr2::req_perform() %>%
  httr2::resp_status_desc()
}

