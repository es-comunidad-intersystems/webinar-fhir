/// Sample custom FHIR Server Interactions
Class MyCustom.FHIR.Interactions Extends HS.FHIRServer.Storage.Json.Interactions
{

Property RequestingUser As %String [ Private, Transient ];

Property RequestingUserRoles As %String [ Private, Transient ];

Method OnBeforeRequest(pFHIRService As HS.FHIRServer.API.Service, pFHIRRequest As HS.FHIRServer.API.Data.Request, pTimeout As %Integer)
{
  // extract the user and roles for this request so consent can be evaluated.
  set ..RequestingUser = pFHIRRequest.Username
  set ..RequestingUserRoles = pFHIRRequest.Roles
}

Method OnAfterRequest(pFHIRService As HS.FHIRServer.API.Service, pFHIRRequest As HS.FHIRServer.API.Data.Request, pFHIRResponse As HS.FHIRServer.API.Data.Response)
{
  // clear the user and roles between requests.
  set ..RequestingUser = ""
  set ..RequestingUserRoles = ""
}

Method PostProcessRead(pResourceObject As %DynamicObject) As %Boolean
{
  // evaluate consent based on the resource and user/roles. Returning 0 indicates
  // this resource shouldn't be displayed - a 404 Not Found will be returned to the user.
  if '##class(MyCustom.Consent).Consented(pResourceObject, ..RequestingUser, ..RequestingUserRoles) {
    return 0
  }

  // modify (anonymize) the resource being returned to the client if they don't have
  // permission to see the full record.
  if (pResourceObject.resourceType = "Patient") &&
  ##class(MyCustom.Consent).Anonymize(..RequestingUser, ..RequestingUserRoles) {
    do pResourceObject.%Remove("name")
  }
  return 1
}

Method PostProcessSearch(pRS As HS.FHIRServer.Util.SearchResult, pResourceType As %String) As %Status
{
  // iterate through each resource in the search set and evaluate consent based on the resource and user/roles.
  // each row marked as deleted and saved will be excluded from the Bundle.
  do pRS.%SetIterator(0)
  while(pRS.%Next()) {
    set resourceObject = ..Read(pRS.ResourceType, pRS.ResourceId, pRS.VersionId)
    if '##class(MyCustom.Consent).Consented(resourceObject, ..RequestingUser, ..RequestingUserRoles) {
      do pRS.MarkAsDeleted()
      do pRS.%SaveRow()
    }
  }
  do pRS.%SetIterator(0)
  quit $$$OK
}

}
