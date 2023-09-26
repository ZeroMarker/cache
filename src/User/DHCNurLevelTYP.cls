Class User.DHCNurLevelTYP Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCNurLe_RowID, SqlTableName = DHC_NurLevelTYP ]
{

Parameter EXTENTSIZE = 250;

//护理级别Code

/// DHCNur_LeCode
Property DHCNurLeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCNur_LeCode ];

//护理级别描述 

/// DHCNur_LeDesc
Property DHCNurLeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCNur_LeDesc ];

//护理级别医嘱项Rowid组串

/// DHCNur_LeArcimRowidStr
Property DHCNurLeArcimRowidStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCNur_LeArcimRowidStr ];

Storage Default
{
<Data name="DHCNurLevelTYPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DHCNurLeCode</Value>
</Value>
<Value name="3">
<Value>DHCNurLeDesc</Value>
</Value>
<Value name="4">
<Value>DHCNurLeArcimRowidStr</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurLevelTYPD</DataLocation>
<DefaultData>DHCNurLevelTYPDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCNurLevelTYPD</IdLocation>
<IndexLocation>^User.DHCNurLevelTYPI</IndexLocation>
<StreamLocation>^User.DHCNurLevelTYPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
