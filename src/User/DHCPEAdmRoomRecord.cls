Class User.DHCPEAdmRoomRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_AdmRoomRecord ]
{

Parameter ClassName = "User.DHCPEAdmRoomRecord";

Property ARRAdmDR As %String [ Required, SqlFieldName = ARR_Adm_DR ];

Property ARRRoomDR As %String [ Required, SqlFieldName = ARR_Room_DR ];

Property ARRStatus As %String [ Required, SqlFieldName = ARR_Status ];

Property ARRStatusDetail As %String [ SqlFieldName = ARR_StatusDetail ];

Property ARRDate As %Library.Date [ Required, SqlFieldName = ARR_Date ];

Property ARRCreateUserDR As SSUser [ Required, SqlFieldName = ARR_CreateUserDR ];

Property ARRCreateTime As %Library.Time [ Required, SqlFieldName = ARR_CreateTime ];

Property ARRInTime As %Library.Time [ SqlFieldName = ARR_InTime ];

Property ARROutTime As %Library.Time [ SqlFieldName = ARR_OutTime ];

Property ARRRoomSort As %Library.Integer [ SqlFieldName = ARR_RoomSort ];

Property ARRUserDR As SSUser [ SqlFieldName = ARR_UserDR ];

Property ARRCallRoom As %String [ SqlFieldName = ARR_CallRoom ];

Index StatusIndex On (ARRStatus, ARRRoomDR, ARRAdmDR);

Index StatusRoomDateIndex On (ARRStatus, ARRRoomDR, ARRDate);

Index StatusSortIndex On (ARRStatus, ARRRoomDR, ARRRoomSort, ARRAdmDR);

Index SortIndex On (ARRStatus, ARRRoomDR, ARRRoomSort);

Index AdmIndex On (ARRAdmDR, ARRStatus);

Index CreateTimeIndex On (ARRDate, ARRCreateTime, ARRStatus);

Index UserRoomIndex On (ARRDate, ARRCreateUserDR, ARRRoomDR, ARRAdmDR);

Index RoomUserIndex On (ARRDate, ARRRoomDR, ARRAdmDR As AlphaUp, ARRUserDR As AlphaUp);

Storage Default
{
<Data name="DHCPEAdmRoomRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ARRAdmDR</Value>
</Value>
<Value name="3">
<Value>ARRDate</Value>
</Value>
<Value name="4">
<Value>ARRInTime</Value>
</Value>
<Value name="5">
<Value>ARROutTime</Value>
</Value>
<Value name="6">
<Value>ARRRoomDR</Value>
</Value>
<Value name="7">
<Value>ARRStatus</Value>
</Value>
<Value name="8">
<Value>ARRCreateTime</Value>
</Value>
<Value name="9">
<Value>ARRStatusDetail</Value>
</Value>
<Value name="10">
<Value>ARRRoomSort</Value>
</Value>
<Value name="11">
<Value>ARRUserDR</Value>
</Value>
<Value name="12">
<Value>ARRCreateUser</Value>
</Value>
<Value name="13">
<Value>ARRCreateUserDR</Value>
</Value>
<Value name="14">
<Value>ARRCallRoom</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEAdmRoomRecordD</DataLocation>
<DefaultData>DHCPEAdmRoomRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEAdmRoomRecordD</IdLocation>
<IndexLocation>^User.DHCPEAdmRoomRecordI</IndexLocation>
<StreamLocation>^User.DHCPEAdmRoomRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
