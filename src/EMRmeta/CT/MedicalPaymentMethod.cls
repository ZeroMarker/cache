Class EMRmeta.CT.MedicalPaymentMethod Extends %Persistent
{

Index IdxSeq On Sequence;

Index IdxCode On Code [ Unique ];

// 首页标准值域Code

Property Code As %String [ SqlColumnNumber = 2 ];

// 首页标准值域Value

Property Value As %String [ SqlColumnNumber = 3 ];

// 首页标准值域数据效性起始时间 

Property FromDate As %Date [ SqlColumnNumber = 4 ];

// 首页标准值域数据有效性终止时间   

Property ToDate As %Date [ SqlColumnNumber = 5 ];

// 首页标准值域数据来源  

Property Source As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

// 首页标准值域数据显示顺序     

Property Sequence As %Integer [ SqlColumnNumber = 7 ];

// 首页标准值域数据，数据治理中，应的数据编码（如BI、医保等可扩展MappingCodeN属性 MCode2、MCode3）

Property MCode1 As %String [ SqlColumnNumber = 8 ];

/// 初始化函数
/// lifengbo
/// 20230117
/// d ##class(EMRmeta.CT.MedicalPaymentMethod).Init()
ClassMethod Init()
{
	s Source="卫医政发[2021]84号卫生部关于修订病案首页的通知"
	s InitalData = "1^城镇职工基本医疗保险$2^城镇居民基本医疗保险$3^新型农村合作医疗$4^贫困救助$5^商业医疗保险$6^全公费$7^全自费$8^其他社会保险$9^其他"
	for i=1:1:$l(InitalData,"$")
	{
		s tmpCode=$p($p(InitalData,"$",i),"^",1)
		s tmpValue=$p($p(InitalData,"$",i),"^",2)
		s objCur = ##class(EMRmeta.CT.MedicalPaymentMethod).%New()
		s objCur.Code=tmpCode
		s objCur.Value = tmpValue
		s objCur.FromDate = +$h
		s objCur.Sequence= i
		s objCur.Source =Source
		
		d objCur.%Save()
	}
	//判断是否已经初始化字典，如果已经初始
	s stdDictId=""
	s stdDictCode="S56"
	s StdDictName="[MR]医疗付费方式"
	s StdDictTableName="EMRmeta_CT.MedicalPaymentMethod"
	
	s stdDictId= $o(^DHCEMRM.StdDictionaryI("IdxCode"," "_stdDictCode,stdDictId))
	if stdDictId=""
	{
		s objStdDict = ##class(EMRmeta.StdDictionary).%New()
		s objStdDict.Code=stdDictCode
		s objStdDict.Condition=$c(0)
		s objStdDict.ConditionCode=$c(0)
		s objStdDict.Description=StdDictName
		s objStdDict.DicAliasCol=$c(0)
		s objStdDict.DicCodeCol="Code"
		s objStdDict.DicDescCol="Value"
		s objStdDict.IsDiagnosRuleType="N"
		s objStdDict.IsRuleType="N"
		s objStdDict.Name=StdDictName
		s objStdDict.RuleTypeTag = " "
		s objStdDict.Sequence=$i(^DHCEMRM.StdDictionaryD)
		s objStdDict.TableName=StdDictTableName
		
		d objStdDict.%Save()
	}
}

Storage Default
{
<Data name="MedicalPaymentMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
<Value name="4">
<Value>FromDate</Value>
</Value>
<Value name="5">
<Value>ToDate</Value>
</Value>
<Value name="6">
<Value>Source</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>MCode1</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CT.MedicalPayMethodD</DataLocation>
<DefaultData>MedicalPaymentMethodDefaultData</DefaultData>
<IdLocation>^DHCEMRM.CT.MedicalPayMethodD</IdLocation>
<IndexLocation>^DHCEMRM.CT.MedicalPayMethodI</IndexLocation>
<StreamLocation>^DHCEMRM.CT.MedicalPayMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
