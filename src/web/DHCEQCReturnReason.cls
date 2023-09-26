Class web.DHCEQCReturnReason Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 6;

Parameter SQLCODE = "RR_Code";

Parameter SQLDATEFROM;

Parameter SQLFILTER = " (RR_InvalidFlag = 'N') ";

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "RR_Desc";

Parameter SQLROWID = "RR_RowID";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:描述,HIDDEN:%String,Code:%String:编码")
{
SELECT RR_Desc,
	   RR_RowID,
	   RR_Code
FROM sqluser.DHC_EQCReturnReason
where RR_InvalidFlag = 'N' and RR_Desc like nvl(:para,'')||'%'
}

Storage Default
{
<Data name="DHCEQCReturnReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQCReturnReasonD</DataLocation>
<DefaultData>DHCEQCReturnReasonDefaultData</DefaultData>
<IdLocation>^web.DHCEQCReturnReasonD</IdLocation>
<IndexLocation>^web.DHCEQCReturnReasonI</IndexLocation>
<StreamLocation>^web.DHCEQCReturnReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
