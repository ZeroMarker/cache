Class web.DHCEQCPackType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 12;

Parameter SQLCODE = "PT_Code";

Parameter SQLDATEFROM;

Parameter SQLFILTER = "(PT_InvalidFlag = 'N')";

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "PT_Desc";

Parameter SQLROWID = "PT_RowID";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT PT_Desc,
	   PT_RowID,
	   PT_Code
FROM sqluser.DHC_EQCPackType
where PT_InvalidFlag = 'N' and PT_Desc like nvl(:para,'')||'%'
}

Storage Default
{
<Data name="DHCEQCPackTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQCPackTypeD</DataLocation>
<DefaultData>DHCEQCPackTypeDefaultData</DefaultData>
<IdLocation>^web.DHCEQCPackTypeD</IdLocation>
<IndexLocation>^web.DHCEQCPackTypeI</IndexLocation>
<StreamLocation>^web.DHCEQCPackTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
