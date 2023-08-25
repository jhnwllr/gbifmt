#' Delete a machine tag
#'
#' @param datasetkey uuid
#' @param key key of machine tag
#' @param api gbif or uat
#'
#' @return
#' Status message
#'
#' @export
#'
#' @examples
#' \dontrun{
#' delete_mt("38b4c89f-584c-41bb-bd8f-cd1def33e92f",6229107,api="uat")
#' }
delete_mt = function(datasetkey,
                     key,
                     api="gbif") {

  if(api == "uat") base <- "http://api.gbif-uat.org/v1/dataset/"
  if(api == "gbif") base <- "http://api.gbif.org/v1/dataset/"

  url <- paste0(base,datasetkey,"/machineTag/",key)

  httr2::request(url) %>%
    req_method("DELETE") %>%
    httr2::req_auth_basic(Sys.getenv("GBIF_USER", ""),
                          Sys.getenv("GBIF_PWD", "")) %>%
    httr2::req_perform() %>%
    httr2::resp_status_desc()
  }

