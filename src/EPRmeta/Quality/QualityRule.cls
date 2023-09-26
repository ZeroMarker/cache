/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityRule
/// * Description:	质控标准，用于保存病案质控评估标准
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityRule Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCode On Code [ Unique ];

/// 子：质控评估项目
/// Relationship ChildQualityItem As QualityItem [ Cardinality = children, Inverse = ParRef ];
/// 质控标准代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 描述
Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 病历目录结构
Property StructDR As %Integer [ SqlColumnNumber = 4 ];

/// 是否有效
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// 备注
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// Debug:d ##class(%ResultSet).RunQuery("EPRmeta.Quality.QualityRule","SELECTALL")
Query SELECTALL() As %Query(ROWSPEC = "ID,Code,Name,IsActive,ResumeText")
{
}

ClassMethod SELECTALLExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	k ^CacheTemp("EPRQuality","AllRules",repid)
	
	s (RowID,Code,Name,IsActive,ResumeText) = ""
	
	s RowID = $o(^DHCEPRM.QualityRuleD(0))
	While(RowID '= "")
	{
		s rule = $g(^DHCEPRM.QualityRuleD(RowID))
		
		s ID = RowID
		s Code = $list(rule,1)
		s Name = $list(rule,2)
		s IsActive = $list(rule,4)
		s ResumeText = $list(rule,5)

		s ^CacheTemp("EPRQuality","AllRules",repid,Code) = $lb(ID,Code,Name,IsActive,ResumeText)
		
		s RowID = $o(^DHCEPRM.QualityRuleD(RowID))
	}
	
	s RuleCode = ""
	for {
		s RuleCode = $o(^CacheTemp("EPRQuality","AllRules",repid,RuleCode))
		q:(RuleCode = "")
		
		s Data = $g(^CacheTemp("EPRQuality","AllRules",repid,RuleCode))
		s ^CacheTemp(repid,ind) = Data
		s ind = ind+1	
	}
	
	k ^CacheTemp("EPRQuality","AllRules",repid)
		
	q $$$OK
}

ClassMethod SELECTALLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SELECTALLExecute ]
{
	s AtEnd=$LIST(qHandle,1)
 	s repid=$LIST(qHandle,2)
 	s ind=$LIST(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SELECTALLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SELECTALLExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod CheckCodeUnique(ACode As %String) As %Integer
{
	s Result = 0
 	&sql(SELECT COUNT(Code) INTO:Result FROM EPRmeta_Quality.QualityRule WHERE Code = :ACode)
 	q Result
}

Storage Default
{
<Data name="QualityRuleDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>StructDR</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityRuleD</DataLocation>
<DefaultData>QualityRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityRuleD</IdLocation>
<IndexLocation>^DHCEPRM.QualityRuleI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
