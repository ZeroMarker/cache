/// 会诊费收费设置
Class User.DHCPEOthPatToHPBase Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_OthPatToHPBase ]
{

Parameter ClassName = "User.DHCPEOthPatToHPBase";

/// 科室(体检医生所属科室) 指向CT_Loc
Property HPBLocDR As %String [ Required, SqlFieldName = HPB_LocDR ];

/// 体检会诊-站点
Property HPBStationDR As User.DHCPEStation [ SqlFieldName = HPB_StationDR ];

/// 体检会诊-接收科室 指向CT_Loc
Property HPBRecLocDR As %String [ SqlFieldName = HPB_RecLocDR ];

/// 体检会诊-默认医生 指向SS_User
Property HPBRecDocDR As %String [ SqlFieldName = HPB_RecDocDR ];

/// 总检会诊费人员 指向SS_User
Property HPBHPBUserDR As %String [ SqlFieldName = HPB_HPBUserDR ];

/// 总检会诊项目（医嘱项） 指向ARC_ItmMast
Property HPBHPBItemDR As %String [ SqlFieldName = HPB_HPBItemDR ];

/// 医护人员类型
Property HPBCarPrvTpDR As %String [ SqlFieldName = HPB_CarPrvTpDR ];

/// 作废标记
Property HPBNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = HPB_NoActive ];

/// 更新日期
Property HPBUpdateDate As %Date [ SqlFieldName = HPB_UpdateDate ];

/// 更新时间
Property HPBUpdateTime As %Time [ SqlFieldName = HPB_UpdateTime ];

/// 更新人 指向SS_User
Property HPBUpdateUserDR As %String [ SqlFieldName = HPB_UpdateUserDR ];

/// 科室+站点 索引
Index IdxOfLocStation On (HPBLocDR, HPBStationDR) [ Unique ];

/// 科室+总检会诊费人员 索引
Index IdxOfLocHPBUser On (HPBLocDR, HPBHPBUserDR) [ Unique ];

/// 科室+医护人员类型 索引
Index IdxOfLocCarPrvTp On (HPBLocDR, HPBCarPrvTpDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HPBLocDR</Value>
</Value>
<Value name="3">
<Value>HPBStationDR</Value>
</Value>
<Value name="4">
<Value>HPBRecLocDR</Value>
</Value>
<Value name="5">
<Value>HPBRecDocDR</Value>
</Value>
<Value name="6">
<Value>HPBHPBUserDR</Value>
</Value>
<Value name="7">
<Value>HPBHPBItemDR</Value>
</Value>
<Value name="8">
<Value>HPBNoActive</Value>
</Value>
<Value name="9">
<Value>HPBUpdateDate</Value>
</Value>
<Value name="10">
<Value>HPBUpdateTime</Value>
</Value>
<Value name="11">
<Value>HPBUpdateUserDR</Value>
</Value>
<Value name="12">
<Value>HPBCarPrvTpDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.OthPatToHPBaseD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.OthPatToHPBaseD</IdLocation>
<IndexLocation>^CF.PE.OthPatToHPBaseI</IndexLocation>
<StreamLocation>^User.DHCPEOthPatToHPBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
