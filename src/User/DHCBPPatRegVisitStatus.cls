Class User.DHCBPPatRegVisitStatus Extends %Persistent [ ProcedureBlock, SqlRowIdName = BPPRVS_RowId, SqlTableName = DHC_BP_PatRegVisitStatus, StorageStrategy = CacheStorage ]
{

Relationship BPPRVSParref As User.DHCBPPatRegister [ Cardinality = parent, Inverse = ChildDHCBPPatRegVisitStatus, SqlFieldName = BPPRVS_Parref ];

Property BPPRVSBPCVisitStatusDr As User.DHCBPCVisitStatus [ SqlColumnNumber = 2, SqlFieldName = BPPRVS_BPCVisitStatus_Dr ];

Property BPPRVSDate As %Date [ SqlColumnNumber = 3, SqlFieldName = BPPRVS_Date ];

Property BPPRVSTime As %Time [ SqlColumnNumber = 4, SqlFieldName = BPPRVS_Time ];

Property BPPRVSIsActive As %Boolean [ SqlColumnNumber = 5, SqlFieldName = BPPRVS_IsActive ];

Property BPPRVSUpdateUserDr As %String [ SqlColumnNumber = 6, SqlFieldName = BPPRVS_UpdateUser_Dr ];

Property BPPRVSUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BPPRVS_UpdateDate ];

Property BPPRVSUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = BPPRVS_UpdateTime ];

Storage CacheStorage
{
<Data name="BPPatRegVisitStatusClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPPatRegVisitStatusDefaultData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPPRVSBPCVisitStatusDr</Value>
</Value>
<Value name="2">
<Value>BPPRVSDate</Value>
</Value>
<Value name="3">
<Value>BPPRVSTime</Value>
</Value>
<Value name="4">
<Value>BPPRVSIsActive</Value>
</Value>
<Value name="5">
<Value>BPPRVSUpdateUserDr</Value>
</Value>
<Value name="6">
<Value>BPPRVSUpdateDate</Value>
</Value>
<Value name="7">
<Value>BPPRVSUpdateTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("VS")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("VS")</IdLocation>
<IndexLocation>{%%PARENT}("VS",0)</IndexLocation>
<StreamLocation>^User.DHCBPPatRegVisitStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
