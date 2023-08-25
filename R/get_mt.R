#' Get a machine tag
#'
#' @param machineTagNamespace namespace
#' @param machineTagValue value
#' @param machineTagName name
#' @param api gbif or uat
#'
#' @return
#' `tibble` of machine tag data. 
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' get_mt(machineTagNamespace="testMachineTag.jwaller.gbif.org",api="uat")
#'
#' }
get_mt <- function(machineTagNamespace=NULL,
                   machineTagValue=NULL,
                   machineTagName=NULL,
                   api="gbif") {

  if(api == "uat") base <- "http://api.gbif-uat.org/v1/dataset/"
  if(api == "gbif") base <- "http://api.gbif.org/v1/dataset/"

  query <- list(machineTagNamespace=machineTagNamespace,
                machineTagValue=machineTagValue,
                machineTagName=machineTagName) %>%
           purrr::compact()

  url <- base

  L <- httr2::request(url) %>%
  httr2::req_url_query(!!!query) %>%
  httr2::req_perform() %>%
  httr2::resp_body_json() %>%
  purrr::pluck("results")

  # Start processing maching tags
  datasetkey = L %>%
    map_chr(~ .x$key)

  machineTags <- L %>%
    map(~ .x$machineTags)

  # get nested data
  key <- machineTags %>%
    map(~ .x %>% map(~ .x$key))

  namespace_source <- machineTags %>%
    map(~ .x %>% map(~ .x$namespace))

  value <- machineTags %>%
    map(~ .x %>% map(~ .x$value))

  name <- machineTags %>%
    map(~ .x %>% map(~ .x$name))

  createdBy <- machineTags %>%
    map(~ .x %>% map(~ .x$createdBy))

  created <- machineTags %>%
    map(~ .x %>% map(~ .x$created))

  # put list columns into a tibble
  tibble(datasetkey,key,namespace = namespace_source,name,value,createdBy,created) %>%
    tidyr::unnest(cols = c(key,namespace,name,value,createdBy,created)) %>% # unnest data twice
    tidyr::unnest(cols = c(key,namespace,name,value,createdBy,created)) %>%
    filter(namespace == !!machineTagNamespace) # get only the machineTag namespace you are intersted in

}
