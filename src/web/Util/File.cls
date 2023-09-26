Include %sySystem

Class web.Util.File Extends %RegisteredObject
{

/// The name of this file.
Property Name As %String(MAXLEN = 5000);

Method WriteList(ByRef ary) As %Status
{
		Quit:..Name="" ""
		Set $ZTRAP="WriteListError"		
		Open ..Name:("NWR":100)
		Use ..Name 
		Set ary="" For  s ary=$o(ary(ary)) Quit:ary=""  Write ary(ary),!		
		Close ..Name
		Quit $$$OK
		
WriteListError	Set $ZTRAP=""
		Close ..Name
		Quit $$$ERROR($$$CacheError,$ze)
}

/// This callback method is invoked by the <METHOD>%New</METHOD> method to 
/// provide notification that a new instance of an object is being created.
/// 
/// <P>If this method returns an error then the object will not be created.
/// <p>It is passed the arguments provided in the %New call.
/// When customizing this method, override the arguments with whatever variables and types you expect to receive from %New().
/// For example, if you're going to call %New, passing 2 arguments, %OnNew's signature could be:
/// <p>Method %OnNew(dob as %Date = "", name as %Name = "") as %Status
Method %OnNew(initvalue As %CacheString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	set ..Name = initvalue
	Quit $$$OK
}

}
