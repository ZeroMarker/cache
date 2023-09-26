Class User.DHCANMessageDetail Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANMD_RowId, SqlTableName = DHC_AN_MessageDetail, StorageStrategy = CacheStorage ]
{

Property ANMDOpaDr As DHCANOPArrange [ SqlColumnNumber = 2, SqlFieldName = ANMD_Opa_Dr ];

Property ANMDMsgDr As DHCANCMessage [ SqlColumnNumber = 3, SqlFieldName = ANMD_Msg_Dr ];

Property ANMDDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ANMD_Date ];

Property ANMDTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ANMD_Time ];

Property ANMDIntervalTime As %String [ SqlColumnNumber = 6, SqlFieldName = ANMD_IntervalTime ];

Property ANMDCtloc As %String [ SqlColumnNumber = 7, SqlFieldName = ANMD_Ctloc ];

Property ANMDGroupDr As %String [ SqlColumnNumber = 8, SqlFieldName = ANMD_Group_Dr ];

Property ANMDUserDr As %String [ SqlColumnNumber = 9, SqlFieldName = ANMD_User_Dr ];

Property ANMDNote As %String(MAXLEN = 500) [ SqlColumnNumber = 10, SqlFieldName = ANMD_Note ];

Index Message On ANMDMsgDr As Exact;

Index Date On ANMDDate As Exact;

Property ANMDStatus As %String(DISPLAYLIST = ",Read,Unread", SELECTIVITY = "33.30000%", VALUELIST = ",R,U") [ SqlColumnNumber = 11, SqlFieldName = ANMD_Status ];

Storage CacheStorage
{
<Data name="DHCANMessageDetailCLASSNAME">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANMessageDetailDefaultData">
<Value name="1">
<Value>ANMDOpaDr</Value>
</Value>
<Value name="2">
<Value>ANMDMsgDr</Value>
</Value>
<Value name="3">
<Value>ANMDDate</Value>
</Value>
<Value name="4">
<Value>ANMDTime</Value>
</Value>
<Value name="5">
<Value>ANMDIntervalTime</Value>
</Value>
<Value name="6">
<Value>ANMDCtloc</Value>
</Value>
<Value name="7">
<Value>ANMDGroupDr</Value>
</Value>
<Value name="8">
<Value>ANMDUserDr</Value>
</Value>
<Value name="9">
<Value>ANMDNote</Value>
</Value>
<Value name="10">
<Value>ANMDStatus</Value>
</Value>
</Data>
<DataLocation>^DHCANMessage</DataLocation>
<DefaultData>DHCANMessageDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANMessage</IdLocation>
<IndexLocation>^DHCANMessage(0)</IndexLocation>
<StreamLocation>^User.DHCANMessageDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
