/// 医保下载功能通用配置
Class User.InsuDLConfig Extends %Persistent
{

Property InsuType As %String(CAPTION = "医保类型");

Property TableClsName As %String(CAPTION = "业务类名称");

Property ColProCode As %String(CAPTION = "列属性编码");

Property ColProName As %String(CAPTION = "列属性名称");

Property NotUpateFlg As %String(CAPTION = "不能更新标志");

Property CompareFlg As %String(CAPTION = "差异比较标志");

Property NullCheckFlg As %String(CAPTION = "为空验证标志");

Property ShowIndex As %String(CAPTION = "显示顺序");

Property DataType As %String(CAPTION = "数据类型");

// 各个可选值之间用逗号分隔

Property OptionVales As %String(CAPTION = "可选值");

Property ExtStr1 As %String(CAPTION = "备用1");

Property ExtStr2 As %String(CAPTION = "备用2");

Property ExtStr3 As %String(CAPTION = "备用3");

Property ExtStr4 As %String(CAPTION = "备用4");

Property ExtStr5 As %String(CAPTION = "备用5");

/// 医院编码或者DR
Property HospitalCD As %String(CAPTION = "医院编码");

Property UpdateUserDr As %String(CAPTION = "添加人");

Property UpdateDate As %Date(CAPTION = "添加日期");

Property UpdateTime As %Time(CAPTION = "添加时间");

/// 数据的逻辑主键(数据批次,医保类型,项目编码)
Index IDataKey On (InsuType As Exact, TableClsName As Exact, ColProCode As Exact);

Index idxColCodeOfHospital On (HospitalCD As Exact, InsuType As Exact, TableClsName As Exact, ColProCode As Exact);

Storage Default
{
<Data name="InsuDLConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InsuType</Value>
</Value>
<Value name="3">
<Value>TableClsName</Value>
</Value>
<Value name="4">
<Value>ColProCode</Value>
</Value>
<Value name="5">
<Value>ColProName</Value>
</Value>
<Value name="6">
<Value>NotUpateFlg</Value>
</Value>
<Value name="7">
<Value>CompareFlg</Value>
</Value>
<Value name="8">
<Value>NullCheckFlg</Value>
</Value>
<Value name="9">
<Value>ShowIndex</Value>
</Value>
<Value name="10">
<Value>DataType</Value>
</Value>
<Value name="11">
<Value>OptionVales</Value>
</Value>
<Value name="12">
<Value>ExtStr1</Value>
</Value>
<Value name="13">
<Value>ExtStr2</Value>
</Value>
<Value name="14">
<Value>ExtStr3</Value>
</Value>
<Value name="15">
<Value>ExtStr4</Value>
</Value>
<Value name="16">
<Value>ExtStr5</Value>
</Value>
<Value name="17">
<Value>HospitalCD</Value>
</Value>
<Value name="18">
<Value>UpdateUserDr</Value>
</Value>
<Value name="19">
<Value>UpdateDate</Value>
</Value>
<Value name="20">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.InsuDLConfigD</DataLocation>
<DefaultData>InsuDLConfigDefaultData</DefaultData>
<IdLocation>^User.InsuDLConfigD</IdLocation>
<IndexLocation>^User.InsuDLConfigI</IndexLocation>
<StreamLocation>^User.InsuDLConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
