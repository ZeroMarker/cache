Class EMRmeta.CT.BloodTransfusionReaction Extends %Persistent
{

/// 扩种首页标准数据管理表20220117
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
/// d ##class(EMRmeta.CT.BloodTransfusionReaction).Init()
ClassMethod Init()
{
	s Source=""
	s InitalData = "1^有$2^无"
	for i=1:1:$l(InitalData,"$")
	{
		s tmpCode=$p($p(InitalData,"$",i),"^",1)
		s tmpValue=$p($p(InitalData,"$",i),"^",2)
		s objCur = ##class(EMRmeta.CT.BloodTransfusionReaction).%New()
		s objCur.Code=tmpCode
		s objCur.Value = tmpValue
		s objCur.FromDate = +$h
		s objCur.Sequence=i
		s objCur.Source =Source
		
		d objCur.%Save()
	}
	//判断是否已经初始化字典，如果已经初始
	s stdDictId=""
	s stdDictCode="S68"
	s StdDictName="[MR]输血反应"
	s StdDictTableName="EMRmeta_CT.BloodTransfusionReaction"
	
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
<Data name="BloodTransfusionReactionDefaultData">
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
<DataLocation>^DHCEMRM.CT.BloodTransReactionD</DataLocation>
<DefaultData>BloodTransfusionReactionDefaultData</DefaultData>
<IdLocation>^DHCEMRM.CT.BloodTransReactionD</IdLocation>
<IndexLocation>^DHCEMRM.CT.BloodTransReactionI</IndexLocation>
<StreamLocation>^DHCEMRM.CT.BloodTransReactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
