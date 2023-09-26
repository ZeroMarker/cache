Class User.DHCMDTDiagRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTDiagRecord ]
{

Property MDAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = MD_Adm_Dr ];

Property MDPatDr As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = MD_Pat_Dr ];

Property MDType As %String [ SqlColumnNumber = 4, SqlFieldName = MD_Type ];

Property MDDiagons As User.MRCICDDx [ SqlColumnNumber = 5, SqlFieldName = MD_Diagons ];

Property MDDate As %Date [ SqlColumnNumber = 6, SqlFieldName = MD_Date ];

Property MDTime As %Time [ SqlColumnNumber = 7, SqlFieldName = MD_Time ];

Property MDFlag As %String [ SqlColumnNumber = 8, SqlFieldName = MD_Flag ];

Property MDRefReason As %String(MAXLEN = 900) [ SqlColumnNumber = 9, SqlFieldName = MD_RefReason ];

Index MDPat On MDPatDr;

Index Date On MDDate;

Storage Default
{
<Data name="DHCMDTDiagRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MDAdmDr</Value>
</Value>
<Value name="3">
<Value>MDPatDr</Value>
</Value>
<Value name="4">
<Value>MDType</Value>
</Value>
<Value name="5">
<Value>MDDiagons</Value>
</Value>
<Value name="6">
<Value>MDDate</Value>
</Value>
<Value name="7">
<Value>MDTime</Value>
</Value>
<Value name="8">
<Value>MDFlag</Value>
</Value>
<Value name="9">
<Value>MDRefReason</Value>
</Value>
</Data>
<DataLocation>^User.DHCMDTDiagRecordD</DataLocation>
<DefaultData>DHCMDTDiagRecordDefaultData</DefaultData>
<IdLocation>^User.DHCMDTDiagRecordD</IdLocation>
<IndexLocation>^User.DHCMDTDiagRecordI</IndexLocation>
<StreamLocation>^User.DHCMDTDiagRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
