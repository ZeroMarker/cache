/// 重症病人身高体重头围信息
Class User.DHCICUPatWeightInfo Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_PatWeightInfo ]
{

Property ICUArrange As User.DHCICUArrange [ Required, SqlColumnNumber = 2 ];

/// 填写日期
Property StartDate As %Date [ SqlColumnNumber = 3 ];

/// 填写时间
Property StartTime As %Time [ SqlColumnNumber = 4 ];

/// 体重
Property Weight As %String [ SqlColumnNumber = 5 ];

/// 身高
Property Height As %String [ SqlColumnNumber = 6 ];

/// 身高
Property HeadCircumference As %String [ SqlColumnNumber = 7 ];

/// 修改人
Property UpdateUser As %String [ SqlColumnNumber = 8 ];

/// 修改日期
Property UpdateDate As %Date [ SqlColumnNumber = 9 ];

/// 修改时间
Property UpdateTime As %Time [ SqlColumnNumber = 10 ];

/// 状态
Property Status As %String(DISPLAYLIST = ",新建,删除", VALUELIST = ",N,D") [ SqlColumnNumber = 11 ];

/// icua索引
Index ICUA On ICUArrange;

/// 数据项外键约束
ForeignKey FKICUArrange(ICUArrange) References User.DHCICUArrange() [ OnDelete = cascade ];

Storage Default
{
<Data name="DHCICUPatWeightInfoDefaultData">
<Value name="1">
<Value>ICUArrange</Value>
</Value>
<Value name="2">
<Value>StartDate</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>Weight</Value>
</Value>
<Value name="5">
<Value>Height</Value>
</Value>
<Value name="6">
<Value>HeadCircumference</Value>
</Value>
<Value name="7">
<Value>UpdateUser</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUPatWeightInfoD</DataLocation>
<DefaultData>DHCICUPatWeightInfoDefaultData</DefaultData>
<IdLocation>^User.DHCICUPatWeightInfoD</IdLocation>
<IndexLocation>^User.DHCICUPatWeightInfoI</IndexLocation>
<StreamLocation>^User.DHCICUPatWeightInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
