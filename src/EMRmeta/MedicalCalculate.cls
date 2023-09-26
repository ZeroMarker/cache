Class EMRmeta.MedicalCalculate Extends %Persistent
{

Index IdxCode On Code [ Unique ];

//公式代码，唯一索引

Property Code As %String;

//公式名称

Property Description As %String(MAXLEN = 100);

//公式变量，多个变量以^分隔

Property Variable As %String;

//公式变量名称，多个变量以^分隔

Property VarDesc As %String(MAXLEN = 1000);

//各变量类型：N-数值输入框 S-下拉选项框 C-复选框

Property VarType As %String;

//各变量单位

Property VarUnit As %String;

//变量参数，N类变量：空；S类变量：每个选项及值，格式value1#text1!value2#text2!...；C类变量：值

Property VarParam As %String(MAXLEN = 5000);

//公式表达式，js表达式，多个公式以^分隔

Property Formula As %String(MAXLEN = 1000);

//公式结果

Property Result As %String;

//公式结果名称

Property ResDesc As %String;

//结果单位

Property ResUnit As %String;

//是否开启小数位 0关闭，1开启

Property Precision;

Storage Default
{
<Data name="MedicalCalculateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Variable</Value>
</Value>
<Value name="5">
<Value>VarDesc</Value>
</Value>
<Value name="6">
<Value>VarType</Value>
</Value>
<Value name="7">
<Value>VarUnit</Value>
</Value>
<Value name="8">
<Value>VarParam</Value>
</Value>
<Value name="9">
<Value>Formula</Value>
</Value>
<Value name="10">
<Value>Result</Value>
</Value>
<Value name="11">
<Value>ResDesc</Value>
</Value>
<Value name="12">
<Value>ResUnit</Value>
</Value>
<Value name="13">
<Value>Precision</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.MedicalCalculateD</DataLocation>
<DefaultData>MedicalCalculateDefaultData</DefaultData>
<IdLocation>^DHCEMRM.MedicalCalculateD</IdLocation>
<IndexLocation>^DHCEMRM.MedicalCalculateI</IndexLocation>
<StreamLocation>^DHCEMRM.MedicalCalculateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
