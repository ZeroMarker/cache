Class User.DHCPEUpLoadResult Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_UpLoadResult ]
{

Parameter ClassName = "User.DHCPEUpLoadResult";

/// 科室 指向CT_Loc
Property URLocDR As %String [ Required, SqlFieldName = UR_LocDR ];

/// 设备代码
Property URCode As %String [ Required, SqlFieldName = UR_Code ];

/// 设备名称
Property URDesc As %String [ Required, SqlFieldName = UR_Desc ];

/// 作废标记
Property URNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = UR_NoActive ];

/// 更新日期
Property URUpdateDate As %Date [ SqlFieldName = UR_UpdateDate ];

/// 更新时间
Property URUpdateTime As %Time [ SqlFieldName = UR_UpdateTime ];

/// 更信人 指向SS_User
Property URUpdateUserDR As %String [ SqlFieldName = UR_UpdateUserDR ];

/// VIP等级代码 索引
Index IdxOfLocCode On (URLocDR, URCode) [ Unique ];

Storage Default
{
<Data name="DHCPEUpLoadResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>URLocDR</Value>
</Value>
<Value name="3">
<Value>URCode</Value>
</Value>
<Value name="4">
<Value>URDesc</Value>
</Value>
<Value name="5">
<Value>URNoActive</Value>
</Value>
<Value name="6">
<Value>URUpdateDate</Value>
</Value>
<Value name="7">
<Value>URUpdateTime</Value>
</Value>
<Value name="8">
<Value>URUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CT.PE.UpLoadResultD</DataLocation>
<DefaultData>DHCPEUpLoadResultDefaultData</DefaultData>
<IdLocation>^CT.PE.UpLoadResultD</IdLocation>
<IndexLocation>^CT.PE.UpLoadResultI</IndexLocation>
<StreamLocation>^CT.PE.UpLoadResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
