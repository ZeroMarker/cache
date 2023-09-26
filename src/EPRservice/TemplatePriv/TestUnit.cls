Class EPRservice.TemplatePriv.TestUnit Extends %RegisteredObject
{

//d ##class(EPRservice.TemplatePriv.TestUnit).TestResultSet("134","90")

ClassMethod TestResultSet(parAdmId As %String)
{
 Set rset = ##class(%ResultSet).%New("EPRmeta.TemplatePriv.TemplatesInGroup:SelectAll")
 Set columns = rset.GetColumnCount()

 Set sc = rset.Execute(parAdmId)

 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------",!
 }
 Do rset.Close()
}

}
