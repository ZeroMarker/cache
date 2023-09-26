Class User.DHCPELocUpLoadResult Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_LocUpLoadResult ]
{

Parameter ClassName = "User.DHCPELocUpLoadResult";

/// 设备
Property LURUpLoadResultDR As User.DHCPEUpLoadResult [ Required, SqlFieldName = LUR_UpLoadResultDR ];

/// 医嘱项
Property LURARCIM As %String [ Required, SqlFieldName = LUR_ARCIM ];

/// 图片文件路径
Property LURImgPath As %String [ SqlFieldName = LUR_ImgPath ];

/// 是否读取文本
Property LURTextInfo As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = LUR_TextInfo ];

/// 获取体检号分隔符前
Property LURPENoSepB As %String [ SqlFieldName = LUR_PENoSepB ];

/// 获取体检号分隔符后
Property LURPENoSepA As %String [ SqlFieldName = LUR_PENoSepA ];

/// 获取检查所见分隔符前
Property LURJCSJSepB As %String [ SqlFieldName = LUR_JCSJSepB ];

/// 获取检查所见分隔符后
Property LURJCSJSepA As %String [ SqlFieldName = LUR_JCSJSepA ];

/// 获取诊断意见分隔符前
Property LURZDYJSepB As %String [ SqlFieldName = LUR_ZDYJSepB ];

/// 获取诊断意见分隔符前
Property LURZDYJSepA As %String [ SqlFieldName = LUR_ZDYJSepA ];

/// 更新日期
Property LURUpdateDate As %Date [ SqlFieldName = LUR_UpdateDate ];

/// 更新时间
Property LURUpdateTime As %Time [ SqlFieldName = LUR_UpdateTime ];

/// 更新人 指向SS_User
Property LURUpdateUserDR As %String [ SqlFieldName = LUR_UpdateUserDR ];

/// 设备 索引
Index IdxOfLURDR On LURUpLoadResultDR;

/// 设备医嘱 索引
Index IdxOfLURARCIMDR On (LURUpLoadResultDR, LURARCIM);

Storage Default
{
<Data name="DHCPELocUpLoadResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LURUpLoadResultDR</Value>
</Value>
<Value name="3">
<Value>LURARCIM</Value>
</Value>
<Value name="4">
<Value>LURImgPath</Value>
</Value>
<Value name="5">
<Value>LURTextInfo</Value>
</Value>
<Value name="6">
<Value>LURPENoSepB</Value>
</Value>
<Value name="7">
<Value>LURPENoSepA</Value>
</Value>
<Value name="8">
<Value>LURJCSJSepB</Value>
</Value>
<Value name="9">
<Value>LURJCSJSepA</Value>
</Value>
<Value name="10">
<Value>LURZDYJSepB</Value>
</Value>
<Value name="11">
<Value>LURZDYJSepA</Value>
</Value>
<Value name="12">
<Value>LURUpdateDate</Value>
</Value>
<Value name="13">
<Value>LURUpdateTime</Value>
</Value>
<Value name="14">
<Value>LURUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.LocUpLoadResultD</DataLocation>
<DefaultData>DHCPELocUpLoadResultDefaultData</DefaultData>
<IdLocation>^CF.PE.LocUpLoadResultD</IdLocation>
<IndexLocation>^CF.PE.LocUpLoadResultI</IndexLocation>
<StreamLocation>^User.DHCPELocUpLoadResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
