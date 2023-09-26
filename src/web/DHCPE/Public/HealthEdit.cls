Class web.DHCPE.Public.HealthEdit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Get(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
 Set rset=##class(%ResultSet).%New()
 Set out="",i=0
 Do rset.Prepare("SELECT Name,DisplayType,Hidden FROM websys.ComponentItems WHERE ParRef='50921' ORDER BY ID")

 Do rset.Execute()

 While (rset.Next()) 
     {
        Set out=out_"^"_rset.Data("Name")_"^"_rset.Data("DisplayType")_"^"_rset.Data("Hidden")
        Set i=i+3
     } 
 Set out=i_"^"_out  
 Quit out
}

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
}

}
