#' Combined search
#'
#' @export
#' @param text (character) basic text search, equiavalent to `text_adv`
#' with `matchAgainst="allNames"` and `operator="similarTo"`
#' @param text_adv (list) advanced search, must specify the following three
#' elements: `searchToken`, `matchAgainst`, and `operator`. see 
#' https://explorer.natureserve.org/api-docs/#_advanced_text_search_parameter
#' @param status (character) conservation status, one of G1, G2, G3, G4,
#' G5, GH, GX, GNR, GNA, GU. case insensitive
#' @param location (list) location, country and sub-country. specify either
#' `nation` OR `nation` and `subnation`. each expects a two-letter ISO code
#' @param record_type (character) limit results by record type, one of
#' "species" or "ecosystem"
#' @param record_subtype (character) limit results by record sub-type, one of:
#' "class", "subclass", "formation", "division", "macrogroup", "group",
#' "alliance", "association", "terrestrial_ecological_system"
#' @param modified_since (character) search for records modified since a
#' given time. value must be a date and time with a UTC offset in ISO 8601
#' format. optional
#' @param page (integer) Zero-indexed page number; default: 0. optional
#' @param per_page (integer) Records per page; default: 20. optional
#' @template ns
#' @family search
#' @examples \dontrun{
#' ns_search_comb(text = "robin")
#' ns_search_comb(text_adv = list(searchToken = "western",
#'   matchAgainst="allScientificNames", operator="startsWith"))
#' ns_search_comb(status = "G1")
#' ns_search_comb(location = list(nation = "US"))
#' ns_search_comb(location = list(nation = "US", subnation = "VA"))
#' ns_search_comb(record_type = "species")
#' ns_search_comb(record_subtype = "macrogroup")
#' ns_search_comb(modified_since = "2020-04-30T00:00:00+0000")
#' ns_search_comb(page = 0, per_page = 2)
#' }
ns_search_comb <- function(text = NULL, text_adv = NULL, status = NULL,
  location = NULL, record_type = NULL, record_subtype = NULL,
  modified_since = NULL, page = NULL, per_page = NULL, ...) {

  paging <- handle_paging(page, per_page)
  text <- handle_text(text, text_adv)
  status <- handle_status(status)
  location <- handle_location(location)
  record_type <- handle_type(record_type)
  record_subtype <- handle_subtype(record_subtype)
  assert(modified_since, "character")
  res <- ns_POST(
    url = file.path(ns_base(), 'api/data/search'),
    body = list(criteriaType = "combined",
      textCriteria = list(text) %|lst|% NULL,
      statusCriteria = list(status) %|lst|% NULL,
      locationCriteria = list(location) %|lst|% NULL,
      recordTypeCriteria = list(record_type) %|lst|% NULL,
      recordSubtypeCriteria = list(record_subtype) %|lst|% NULL,
      pagingOptions = paging,
      modifiedSince = modified_since
    ),
    ...
  )
  parse_search(res)
}
