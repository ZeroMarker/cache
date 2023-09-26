Class web.Util.DHCPlatformSQLParser Extends %RegisteredObject
{

Property SQLStatement As %String;

Property UpdateSet As %String;

/// UPDATE PA_ADM SET PAADM_ADMNo = :p1 , PAADM_DepCode_DR= :p2 WHERE PAADM_ROWID = :p3 AND PAADM_PAPMI_DR = :p4
Property StatementPreparsed As %String;

/// $lb("c","IP0000000001","c",9,"c",1,"c",2)
Property StatementArgs As %String;

/// $lb("SQLUSER.PA_ADM")
Property StatementTables As %String;

/// SEL/INS/UPD/DEL/CREATE and so on
Property FirstToken As %String;

/// S obj = ##class(web.Util.DHCPlatformSQLParser).%New("update PA_ADM   SET PAADM_ADMNo='IP0000000001',PAADM_DepCode_DR=9 Where PAADM_PAPMI_DR=1")
Method Parse()
{
}

Method GetCount(Namespace = "")
{
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
}

Parameter SQLKeyword = "SELECT,UPDATE,WHERE,INSERT,INTO,VALUES,FROM,SET,DELETE,ORDER BY";

Method GetSqlHtml()
{
}

ClassMethod GetSqlHtmlBySql(sqlStatement)
{
}

}
