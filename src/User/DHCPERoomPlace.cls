/// Creator:      sunxintao
/// CreatDate:    2021.08.08
/// Description:: 诊室位置字典表
Class User.DHCPERoomPlace Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ Inheritance = right, SqlTableName = DHC_PE_RoomPlace ]
{

Parameter ClassName = "User.DHCPERoomPlace";

/// 代码
Property RPCode As %String [ Required, SqlFieldName = RP_Code ];

/// 描述
Property RPDesc As %String [ Required, SqlFieldName = RP_Desc ];

/// VIP等级
Property RPVIPLevelDR As User.DHCPEVIPLevel [ SqlFieldName = RP_VIPLevelDR ];

/// 是否团体
Property RPIsGroup As %String(DISPLAYLIST = ",个人,团体,不限", TRUNCATE = 1, VALUELIST = ",I,G,N") [ SqlFieldName = RP_IsGroup ];

/// 不打印条码
Property RPNoPrintBar As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = RP_NoPrintBar ];

/// 体检科室
Property RPLocDR As %String [ Required, SqlFieldName = RP_LocDR ];

/// 作废标记
Property RPNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = RP_NoActive ];

/// 更新日期
Property RPUpdateDate As %Library.Date [ SqlFieldName = RP_UpdateDate ];

/// 更新时间
Property RPUpdateTime As %Library.Time [ SqlFieldName = RP_UpdateTime ];

/// 更新人
Property RPUpdateUserDR As %String [ SqlFieldName = RP_UpdateUserDR ];

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RPCode</Value>
</Value>
<Value name="3">
<Value>RPDesc</Value>
</Value>
<Value name="4">
<Value>RPVIPLevelDR</Value>
</Value>
<Value name="5">
<Value>RPIsGroup</Value>
</Value>
<Value name="6">
<Value>RPNoPrintBar</Value>
</Value>
<Value name="7">
<Value>RPLocDR</Value>
</Value>
<Value name="8">
<Value>RPNoActive</Value>
</Value>
<Value name="9">
<Value>RPUpdateDate</Value>
</Value>
<Value name="10">
<Value>RPUpdateTime</Value>
</Value>
<Value name="11">
<Value>RPUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.RoomPlaceD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.RoomPlaceD</IdLocation>
<IndexLocation>^CF.PE.RoomPlaceI</IndexLocation>
<StreamLocation>^User.DHCPERoomPlaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
