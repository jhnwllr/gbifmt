#' Get a machine tag
#'
#' @param machineTagNamespace namespace
#' @param machineTagValue value
#' @param machineTagName name
#' @param api gbif or uat
#' @param type "organization", "dataset", "installation"
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
                   limit=500,
                   api="gbif",
                   type="dataset") {
  
    if(api == "uat") base <- paste0("http://api.gbif-uat.org/v1/",type,"/")
    if(api == "gbif") base <- paste0("http://api.gbif.org/v1/",type,"/")

  query <- list(machineTagNamespace=machineTagNamespace,
                machineTagValue=machineTagValue,
                machineTagName=machineTagName,
                limit=limit) %>%
           purrr::compact()

  url <- base

  L <- httr2::request(url) %>%
  httr2::req_url_query(!!!query) %>%
  httr2::req_perform() %>%
  httr2::resp_body_json() %>%
  purrr::pluck("results")

  # Start processing maching tags
  uuid = L %>%
    purrr::map_chr(~ .x$key)

  machineTags <- L %>%
    purrr::map(~ .x$machineTags)

  # get nested data
  key <- machineTags %>%
    purrr::map(~ .x %>% purrr::map(~ .x$key))

  namespace_source <- machineTags %>%
    purrr::map(~ .x %>% purrr::map(~ .x$namespace))

  value <- machineTags %>%
    purrr::map(~ .x %>% purrr::map(~ .x$value))

  name <- machineTags %>%
    purrr::map(~ .x %>% purrr::map(~ .x$name))

  createdBy <- machineTags %>%
    purrr::map(~ .x %>% purrr::map(~ .x$createdBy))

  created <- machineTags %>%
    purrr::map(~ .x %>% purrr::map(~ .x$created))

  # put list columns into a tibble
  tibble::tibble(uuid,key,namespace = namespace_source,name,value,createdBy,created) %>%
    tidyr::unnest(cols = c(key,namespace,name,value,createdBy,created)) %>% # unnest data twice
    tidyr::unnest(cols = c(key,namespace,name,value,createdBy,created)) %>%
    dplyr::filter(namespace == !!machineTagNamespace) # get only the machineTag namespace you are intersted in

}
