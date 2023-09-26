/// 科室VIP等级维护
Class User.DHCPELocVIPLevel Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_LocVIPLevel ]
{

Parameter ClassName = "User.DHCPELocVIPLevel";

/// 科室 指向CT_Loc
Property LVLLocDR As %String [ Required, SqlFieldName = LVL_LocDR ];

/// VIP等级
Property LVLVIPLevelDR As User.DHCPEVIPLevel [ Required, SqlFieldName = LVL_VIPLevelDR ];

/// 保密
Property LVLSecret As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = LVL_Secret ];

/// 默认
Property LVLDefale As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = LVL_Defale ];

/// 模板名称
Property LVLTemplate As %String [ SqlFieldName = LVL_Template ];

/// 体检类别 指向PAC_EpisodeSubType （普通病人、特殊病人）
Property LVLFeeTypeDR As %String [ SqlFieldName = LVL_FeeTypeDR ];

/// 体检号编码
Property LVLHPCode As %String [ SqlFieldName = LVL_HPCode ];

/// 默认套餐 指向ARC_OrdSets
Property LVLOrdSetsDR As %String [ SqlFieldName = LVL_OrdSetsDR ];

/// 指引单指示
Property LVLZYDInfo As %String [ SqlFieldName = LVL_ZYDInfo ];

/// 指引单模板
Property LVLZYDTemplate As %String [ SqlFieldName = LVL_ZYDTemplate ];

/// 问卷服务级别
Property LVLHMServiceDR As User.DHCHMCServiceClass [ SqlFieldName = LVL_HMServiceDR ];

/// 是否插队
Property LVLCutInLine As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = LVL_CutInLine ];

/// 总检类型（JKTJ健康体检、RZTJ入职体检、GWY公务员、ZYJK职业健康、JKZ健康证、OTHER其他）
Property LVLGeneralType As %String [ SqlFieldName = LVL_GeneralType ];

/// 作废标记
Property LVLNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = LVL_NoActive ];

/// 更新日期
Property LVLUpdateDate As %Date [ SqlFieldName = LVL_UpdateDate ];

/// 更新时间
Property LVLUpdateTime As %Time [ SqlFieldName = LVL_UpdateTime ];

/// 更新人 指向SS_User
Property LVLUpdateUserDR As %String [ SqlFieldName = LVL_UpdateUserDR ];

/// 套餐编码（现不用）
Property LVLOSCode As %String [ SqlFieldName = LVL_OSCode ];

/// csp模板（现不用）
Property LVLCSPTemplate As %String [ SqlFieldName = LVL_CSPTemplate ];

/// 限额类型 A：所有 I：个人 G：团体  N：不限
Property LVLGIFlag As %String(TRUNCATE = 1, VALUELIST = ",A,I,G,N") [ SqlFieldName = LVL_GIFlag ];

/// 科室+VIP等级 索引
Index IdxOfLocVIP On (LVLLocDR, LVLVIPLevelDR) [ Unique ];

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LVLLocDR</Value>
</Value>
<Value name="3">
<Value>LVLVIPLevelDR</Value>
</Value>
<Value name="4">
<Value>LVLSecret</Value>
</Value>
<Value name="5">
<Value>LVLDefale</Value>
</Value>
<Value name="6">
<Value>LVLTemplate</Value>
</Value>
<Value name="7">
<Value>LVLFeeTypeDR</Value>
</Value>
<Value name="8">
<Value>LVLHPCode</Value>
</Value>
<Value name="9">
<Value>LVLOrdSetsDR</Value>
</Value>
<Value name="10">
<Value>LVLZYDInfo</Value>
</Value>
<Value name="11">
<Value>LVLZYDTemplate</Value>
</Value>
<Value name="12">
<Value>LVLHMServiceDR</Value>
</Value>
<Value name="13">
<Value>LVLCutInLine</Value>
</Value>
<Value name="14">
<Value>LVLGeneralType</Value>
</Value>
<Value name="15">
<Value>LVLNoActive</Value>
</Value>
<Value name="16">
<Value>LVLUpdateDate</Value>
</Value>
<Value name="17">
<Value>LVLUpdateTime</Value>
</Value>
<Value name="18">
<Value>LVLUpdateUserDR</Value>
</Value>
<Value name="19">
<Value>LVLOSCode</Value>
</Value>
<Value name="20">
<Value>LVLCSPTemplate</Value>
</Value>
<Value name="21">
<Value>LVLGIFlag</Value>
</Value>
</Data>
<DataLocation>^CF.PE.LocVIPLevelD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.LocVIPLevelD</IdLocation>
<IndexLocation>^CF.PE.LocVIPLevelI</IndexLocation>
<StreamLocation>^User.DHCPELocVIPLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
