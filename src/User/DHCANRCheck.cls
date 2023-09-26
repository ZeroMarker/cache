Class User.DHCANRCheck Extends %Persistent [ ProcedureBlock, SqlRowIdName = ANR_RowId, SqlTableName = DHC_ANR_Check, StorageStrategy = CacheStorage ]
{

Relationship ANRCParref As User.DHCANRRisk [ Cardinality = parent, Inverse = ChildDHCANRCheck, SqlFieldName = ANRC_Parref ];

Property ANRCAnrcciDr As User.DHCANRCCheckItem [ SqlColumnNumber = 2, SqlFieldName = ANRC_Anrcci_Dr ];

Property ANRCChecked As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = ANRC_Checked ];

Property ANRCResult As %String [ SqlColumnNumber = 4, SqlFieldName = ANRC_Result ];

Property ANRCNote As %String(MAXLEN = 200) [ SqlColumnNumber = 5, SqlFieldName = ANRC_Note ];

Storage CacheStorage
{
<Data name="DHCANRCheckClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANRCheckDefaultData">
<Value name="1">
<Value>ANRCAnrcciDr</Value>
</Value>
<Value name="2">
<Value>ANRCChecked</Value>
</Value>
<Value name="3">
<Value>ANRCResult</Value>
</Value>
<Value name="4">
<Value>ANRCNote</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("C")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("C")</IdLocation>
<IndexLocation>{%%PARENT}("C",0)</IndexLocation>
<SqlChildSub>ANRC_ChildSub</SqlChildSub>
<StreamLocation>^User.DHCANRCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
