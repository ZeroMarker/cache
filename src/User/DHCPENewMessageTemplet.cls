/// 科室短信模板
Class User.DHCPENewMessageTemplet Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, DHCCPM.BLL.DHCXMLReader, User.Abstract) [ SqlTableName = DHC_PE_NewMessageTemplet ]
{

Parameter ClassName = "User.DHCPENewMessageTemplet";

/// 短信类型
Property NMTType As %String [ Required, SqlFieldName = NMT_Type ];

/// 是否使用标志 1:使用  0:不用
Property NMTActive As %String(DISPLAYLIST = ",使用,不用", TRUNCATE = 1, VALUELIST = ",1,0") [ Required, SqlFieldName = NMT_Active ];

/// 默认标志 1:默认  0不默认
Property NMTDefault As %String(DISPLAYLIST = ",默认,不默认", TRUNCATE = 1, VALUELIST = ",1,0") [ Required, SqlFieldName = NMT_Default ];

/// 模板内容
Property NMTTemplet As %String(MAXLEN = 900) [ Required, SqlFieldName = NMT_Templet ];

/// VIP
Property NMTVIPLevel As %String [ Required, SqlFieldName = NMT_VIPLevel ];

/// 科室
Property NMTLocDR As %String [ SqlFieldName = NMT_LocDR ];

/// 更新日期
Property NMTUpdateDate As %Date [ SqlFieldName = NMT_UpdateDate ];

/// 更新时间
Property NMTUpdateTime As %Time [ SqlFieldName = NMT_UpdateTime ];

/// 更信人 指向SS_User
Property NMTUpdateUserDR As %String [ SqlFieldName = NMT_UpdateUserDR ];

/// Property EDCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EDC_Desc ];
Index TypeDefaultIndex On (NMTType As AlphaUp, NMTDefault As AlphaUp);

Index IdxOfLocTypeVIP On (NMTLocDR As AlphaUp, NMTType As AlphaUp, NMTVIPLevel As AlphaUp);

Storage Default
{
<Data name="DHCPENewMessageTempletDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NMTType</Value>
</Value>
<Value name="3">
<Value>NMTDefault</Value>
</Value>
<Value name="4">
<Value>NMTTemplet</Value>
</Value>
<Value name="5">
<Value>NMTActive</Value>
</Value>
<Value name="6">
<Value>NMTVIPLevel</Value>
</Value>
<Value name="7">
<Value>NMTLocDR</Value>
</Value>
<Value name="8">
<Value>NMTUpdateDate</Value>
</Value>
<Value name="9">
<Value>NMTUpdateTime</Value>
</Value>
<Value name="10">
<Value>NMTUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPENewMessageTempletD</DataLocation>
<DefaultData>DHCPENewMessageTempletDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENewMessageTempletD</IdLocation>
<IndexLocation>^User.DHCPENewMessageTempletI</IndexLocation>
<StreamLocation>^User.DHCPENewMessageTempletS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
