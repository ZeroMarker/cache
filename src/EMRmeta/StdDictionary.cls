/// 名称:EMRmeta.StdDictionary
/// 描述:字典表维护
/// 编写者：Guozongtao
/// 编写日期: 2014-1-7
Class EMRmeta.StdDictionary Extends %Persistent
{

Property Code As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property DicAliasCol As %String(TRUNCATE = 1);

Property DicCodeCol As %String(TRUNCATE = 1);

Property DicDescCol As %String(TRUNCATE = 1);

Property IsRuleType As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property RuleTypeTag As %String(TRUNCATE = 1);

Property TableName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 默认查询条件编码
Property ConditionCode As %String(TRUNCATE = 1);

/// 默认查询条件内容
Property Condition As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否病种规则类别
Property IsDiagnosRuleType As %String(TRUNCATE = 1);

/// 顺序号 add by Candyxu20120607 为排序
Property Sequence As %Integer;

Index IdxCode On Code;

//以下方法都移动到EMRservice.BL.BLStdDictionary中

/*
ClassMethod CheckCodeUnique(ACode As %String) As %Integer
{
 new Result
 &sql(SELECT Count(Code)
 into :Result 
 FROM EMRmeta.StdDictionary
 WHERE Code = :ACode)
 if Result=""
 {s Result=0 }
 QUIT Result
}
*/

/* bak
	q:((parOldFromTable="SQLUser.MRC_ICDDx")&&(parOldWhere="")) " where MRCID_ICD9CM_Code is NOT null AND ALIAS_ParRef=MRCID_Rowid "
	q:(parOldFromTable="SQLUser.MRC_ICDDx") parOldWhere_" and ALIAS_ParRef=MRCID_Rowid and MRCID_ICD9CM_Code is NOT null "
	;Operation
	q:((parOldFromTable="SQLUser.ORC_Operation")&&(parOldWhere="")) " where OPER_Code is NOT null AND ALIAS_ParRef=OPER_Rowid "
	q:(parOldFromTable="SQLUser.ORC_Operation") parOldWhere_" and ALIAS_ParRef=OPER_Rowid and OPER_Code is NOT null "

*/
/// Create:	2011-12-29 HouJ
/// Desc:	查询【省市】字典内容：SQLUser.CT_CityArea
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTCityArea(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("CITAREA",rowid))
		quit:(rowid = "")
		
		//20131101 wangwentao add
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^CT("CITAREA",rowid)),"^",4)
		s dateTo=$p($g(^CT("CITAREA",rowid)),"^",5)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}

		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("CITAREA",rowid)),"^",1)
		s DescValue=$p($g(^CT("CITAREA",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

ClassMethod CheckGBContain(AVesselStr As %String, ACompStr As %String) As %String
{
  s Result = 0
  if ((AVesselStr="")||(AVesselStr=$C(0)))
  {
	s Result = 0 
	  }
  Elseif ((AVesselStr="")||(AVesselStr=$C(0)))
  {
	s Result = 0 
	  }
   else
   {
	 s ReCom =##class(EMRservice.Utility).CheckGBContain(AVesselStr,ACompStr) 
	 if (ReCom="True")
	 {
	   s Result = 1 	 
		 }
		 
	   }	  
  	  
  Q:Result
}

/// d ##Class(%ResultSet).RunQuery("EMRmeta.StdDictionary","SELECTALLByRuleTypeTag","PATDEPT")
Query SELECTALLByRuleTypeTag(RuleTypeTag As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Description:%String,TableName:%String,DicCodeCol:%String,DicDescCol:%String,DicAliasCol:%String,IsRuleType:%String,RuleTypeTag:%String,Condition:%String,ConditionCode:%String,IsDiagnosRuleType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_StdDictionary_SELECTALLByRuleTypeTag, SqlProc ]
{
 SELECT %ID,Code,Name,Description,TableName,DicCodeCol,DicDescCol,DicAliasCol,IsRuleType,RuleTypeTag,Condition,ConditionCode,IsDiagnosRuleType
 FROM EMRmeta.StdDictionary
 WHERE RuleTypeTag=:RuleTypeTag
}

Storage Default
{
<Data name="StdDictionaryDefaultData">
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
<Value>DicAliasCol</Value>
</Value>
<Value name="5">
<Value>DicCodeCol</Value>
</Value>
<Value name="6">
<Value>DicDescCol</Value>
</Value>
<Value name="7">
<Value>IsRuleType</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>RuleTypeTag</Value>
</Value>
<Value name="10">
<Value>TableName</Value>
</Value>
<Value name="11">
<Value>ConditionCode</Value>
</Value>
<Value name="12">
<Value>Condition</Value>
</Value>
<Value name="13">
<Value>IsDiagnosRuleType</Value>
</Value>
<Value name="14">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.StdDictionaryD</DataLocation>
<DefaultData>StdDictionaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.StdDictionaryD</IdLocation>
<IndexLocation>^DHCEMRM.StdDictionaryI</IndexLocation>
<StreamLocation>^DHCEMRM.StdDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
