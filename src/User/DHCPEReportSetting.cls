Class User.DHCPEReportSetting Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_ReportSetting ]
{

Parameter ClassName = "User.DHCPEReportSetting";

/// 编码
Property RSCode As %String [ Required, SqlFieldName = RS_Code ];

/// 描述
Property RSDesc As %String [ Required, SqlFieldName = RS_Desc ];

/// 提示
Property RSTitle As %String(MAXLEN = 200) [ SqlFieldName = RS_Title ];

/// 科室
Property RSLocDR As %String [ SqlFieldName = RS_LocDR ];

/// 对照ID 字符为基础代码  数值为DHC_PE_ReportSetting表RowID
Property RSBeseDR As %String [ Required, SqlFieldName = RS_BeseDR ];

/// 参数类型  C 自定义  E 扩展(多行数据)  T 文本
Property RSParamType As %String [ SqlFieldName = RS_ParamType ];

/// 参数值
Property RSValue As %String [ SqlFieldName = RS_Value ];

/// 备注
Property RSRemark As %String(MAXLEN = 200) [ SqlFieldName = RS_Remark ];

/// 图片 base64 字符串
Property RSBase64Img As %String(COLLATION = "Exact", MAXLEN = 4194303, TRUNCATE = 1) [ SqlFieldName = RS_Base64Img ];

/// 编码 索引
Index IdxLocCode On (RSLocDR, RSCode);

/// 对照ID 索引
Index IdxLocBeseDR On (RSLocDR, RSBeseDR);

/// 对照ID 编码 索引
Index IdxLocBeseDRCode On (RSLocDR, RSBeseDR, RSCode);

Storage Default
{
<Data name="DHCPEReportSettingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RSCode</Value>
</Value>
<Value name="3">
<Value>RSDesc</Value>
</Value>
<Value name="4">
<Value>RSTitle</Value>
</Value>
<Value name="5">
<Value>RSLocDR</Value>
</Value>
<Value name="6">
<Value>RSBeseDR</Value>
</Value>
<Value name="7">
<Value>RSParamType</Value>
</Value>
<Value name="8">
<Value>RSValue</Value>
</Value>
<Value name="9">
<Value>RSRemark</Value>
</Value>
<Value name="10">
<Value>RSBase64Img</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEReportSettingD</DataLocation>
<DefaultData>DHCPEReportSettingDefaultData</DefaultData>
<IdLocation>^User.DHCPEReportSettingD</IdLocation>
<IndexLocation>^User.DHCPEReportSettingI</IndexLocation>
<StreamLocation>^User.DHCPEReportSettingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
