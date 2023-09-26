Class CHSSWeb.HISInterface.PersonInfoTest Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPersonInfo(IDCard As %String) As %String
{
	
	s export =##class(CHSSWeb.HISntrfc.PrsnnfWb.CHSSWeb.HISInterface.PersonInfoWebSoap).%New()	
	s rt = export.GetPersonInfo(IDCard)
	q rt
}

}
