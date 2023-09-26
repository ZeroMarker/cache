Class dhc.qm.data.QMSchemDetail Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = QMSchemDetail_rowid, SqlTableName = QMSchemDetail ]
{

/// QMSchemDetail_parRef
Property QMSchemDetailparRef As dhc.qm.data.QMSchem [ SqlColumnNumber = 2, SqlFieldName = QMSchemDetail_parRef ];

/// QMSchemDetail_CheckDr
Property QMSchemDetailCheckDr As dhc.qm.data.Check [ SqlColumnNumber = 3, SqlFieldName = QMSchemDetail_CheckDr ];

/// QMSchemDetail_order
Property QMSchemDetailorder As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = QMSchemDetail_order ];

/// QMSchemDetail_rate
Property QMSchemDetailrate As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = QMSchemDetail_rate ];

/// QMSchemDetail_parent
Property QMSchemDetailparent As %Library.Integer [ SqlColumnNumber = 6, SqlFieldName = QMSchemDetail_parent ];

/// QMSchemDetail_disqua 
Property QMSchemDetaildisqua As %Library.Integer [ SqlColumnNumber = 7, SqlFieldName = QMSchemDetail_disqua ];

Index CheckDr On QMSchemDetailCheckDr;

Index QMSchemDr On QMSchemDetailparRef;

Index QMSchemDrCheckDr On (QMSchemDetailparRef, QMSchemDetailCheckDr);

Storage Default
{
<Data name="QMSchemDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QMSchemDetailparRef</Value>
</Value>
<Value name="3">
<Value>QMSchemDetailCheckDr</Value>
</Value>
<Value name="4">
<Value>QMSchemDetailorder</Value>
</Value>
<Value name="5">
<Value>QMSchemDetailrate</Value>
</Value>
<Value name="6">
<Value>QMSchemDetailparent</Value>
</Value>
<Value name="7">
<Value>QMSchemDetaildisqua</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMQMSchemDetailD</DataLocation>
<DefaultData>QMSchemDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMQMSchemDetailD</IdLocation>
<IndexLocation>^DHCCJXQMQMSchemDetailI</IndexLocation>
<StreamLocation>^DHCCJXQMQMSchemDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
