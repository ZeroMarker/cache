Class User.DHCBPVascularAccess Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BP_VascularAccess, StorageStrategy = CacheStorage ]
{

Property BPVBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPV_BPPatRegister_Dr ];

Property BPVVascularAccessDr As User.DHCBPCVascularAccess [ SqlColumnNumber = 3, SqlFieldName = BPV_VascularAccess_Dr ];

Property BPVBodySiteDr As %String [ SqlColumnNumber = 4, SqlFieldName = BPV_BodySite_Dr ];

Property BPVBuildingDate As %Date [ SqlColumnNumber = 5, SqlFieldName = BPV_BuildingDate ];

Property BPVBuildingTime As %Time [ SqlColumnNumber = 6, SqlFieldName = BPV_BuildingTime ];

Property BPVStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BPV_StartDate ];

Property BPVStartTime As %Time [ SqlColumnNumber = 8, SqlFieldName = BPV_StartTime ];

Property BPVEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = BPV_EndDate ];

Property BPVEndTime As %Time [ SqlColumnNumber = 10, SqlFieldName = BPV_EndTime ];

Property BPVEndReason As %String [ SqlColumnNumber = 11, SqlFieldName = BPV_EndReason ];

Property BPVStatus As %String(DISPLAYLIST = ",Inactive,Normal,Disabled", MAXLEN = 7, SELECTIVITY = "25%", VALUELIST = ",I,N,D") [ SqlColumnNumber = 12, SqlFieldName = BPV_Status ];

Property BPVUpdateUserDr As %String [ SqlColumnNumber = 13, SqlFieldName = BPV_UpdateUser_Dr ];

Property BPVUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = BPV_UpdateDate ];

Property BPVUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = BPV_UpdateTime ];

Index Register On BPVBPPatRegisterDr As Exact;

Storage CacheStorage
{
<Data name="DHCBPVascularAccessClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPVascularAccessDefaultData">
<Value name="1">
<Value>BPVBPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPVVascularAccessDr</Value>
</Value>
<Value name="3">
<Value>BPVBodySiteDr</Value>
</Value>
<Value name="4">
<Value>BPVBuildingDate</Value>
</Value>
<Value name="5">
<Value>BPVBuildingTime</Value>
</Value>
<Value name="6">
<Value>BPVStartDate</Value>
</Value>
<Value name="7">
<Value>BPVStartTime</Value>
</Value>
<Value name="8">
<Value>BPVEndDate</Value>
</Value>
<Value name="9">
<Value>BPVEndTime</Value>
</Value>
<Value name="10">
<Value>BPVEndReason</Value>
</Value>
<Value name="11">
<Value>BPVStatus</Value>
</Value>
<Value name="12">
<Value>BPVUpdateUserDr</Value>
</Value>
<Value name="13">
<Value>BPVUpdateDate</Value>
</Value>
<Value name="14">
<Value>BPVUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPVascularAccess</DataLocation>
<DefaultData>DHCBPVascularAccessDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPVascularAccess</IdLocation>
<IndexLocation>^DHCBPVascularAccess(0)</IndexLocation>
<StreamLocation>^User.DHCBPVascularAccessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
