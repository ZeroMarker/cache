Class web.DHCEQCDocType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 6;

Parameter SQLCODE = "DT_Code";

Parameter SQLDATEFROM;

Parameter SQLFILTER = " (DT_InvalidFlag = 'N') ";

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "DT_Desc";

Parameter SQLROWID = "DT_RowID";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT DT_Desc,
	   DT_RowID,
	   DT_Code
FROM sqluser.DHC_EQCDocType
where DT_InvalidFlag = 'N' and DT_Desc like nvl(:para,'')||'%'
}

Storage Default
{
<Data name="DHCEQCDocTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQCDocTypeD</DataLocation>
<DefaultData>DHCEQCDocTypeDefaultData</DefaultData>
<IdLocation>^web.DHCEQCDocTypeD</IdLocation>
<IndexLocation>^web.DHCEQCDocTypeI</IndexLocation>
<StreamLocation>^web.DHCEQCDocTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
