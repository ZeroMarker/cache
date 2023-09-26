/// 名称:EMRservice.BOStdDictionary
/// 描述:系统参数配置服务BO
/// 修改：yejian
/// 编写日期: 2014-2-11
Class EMRservice.BOStdDictionary Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "StdDictionaryService";

ClassMethod GetStdDicitonaryByID(AID As %String) As EMRservice.entity.EStdDictionary [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLStdDictionary).GetStdDicitonaryByID(AID)
}

ClassMethod CreateStdDictionary(AEStdDictionary As EMRservice.entity.EStdDictionary) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLStdDictionary).CreateStdDictionary(AEStdDictionary)
}

/// Desc: 保存顺序号
/// Creator: Candyxu 20120607
ClassMethod SaveSequence(AID As %String)
{
	d ##Class(EMRservice.BL.BLStdDictionary).SaveSequence(AID)
}

ClassMethod DeleteStdDictionary(AID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLStdDictionary).DeleteStdDictionary(AID)
}

ClassMethod GetStdDicList(ADicCode As %String, AAias As %String, Acode As %String, ADesc As %String, APageNum As %Integer, ARowCount As %Integer) As %XML.DataSet [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLStdDictionary).GetStdDicList(ADicCode,AAias,Acode,ADesc,APageNum,ARowCount)
}

/// Desc:	标准字典单元查询
/// Input:	ADicCode 字典表代码；AItem 查询条件；APageNum 要取的页码；ARowCount 每页的行数；CountFlag ？？；AResultCount 结果总页数；SessionId 与这次字典查询对应的ID
/// Output:	EMRservice.dataset.EStdDicOrListDataset			
ClassMethod GetStdDicOrList(ADicCode As %String, AItem As %String, APageNum As %Integer, ARowCount As %Integer, CountFlag As %String, ByRef AResultCount As %String, ByRef SessionId As %String, AConditionCode As %String = "", ACondition As %String = "") As EMRservice.dataset.EStdDicOrListDataset [ WebMethod ]
{
	//s ^GetStdDicOrList("321") = ADicCode_","_AItem_","_APageNum_","_ARowCount_","_CountFlag_","_AResultCount_","_SessionId_","_AConditionCode_","_ACondition
	s:(ADicCode = $C(0)) ADicCode = ""
 	s:(AItem = $C(0)) AItem = ""
 	s:(APageNum = $C(0)) APageNum = 0
 	s:(ARowCount = $C(0)) ARowCount = 0

	s ASessionId = $I(^CacheTempStdQuery)
	s SessionId = ASessionId
	K ^CacheTempStdQuery(ASessionId)
 	
	//生成字典查询结果集，并存储在临时global中
	s PageCount= ##Class(EMRservice.BL.BLStdDictionary).SelectNewStdDicPageCount(ADicCode,AItem,APageNum,ARowCount,SessionId,AConditionCode,ACondition)
	s AResultCount = PageCount
	
	s resultSet=##class(EMRservice.dataset.EStdDicOrListDataset).%New()
	//取相应页码的结果
	if (PageCount '= 0)
	{ 
		d resultSet.SetArgs(ADicCode,AItem,APageNum,ARowCount,SessionId)
	}

	q resultSet
}

ClassMethod DeleteStdQueryTempGlobal(ASessionID As %String) [ WebMethod ]
{
	d ##Class(EMRservice.BL.BLStdDictionary).DeleteStdQueryTempGlobal(ASessionID)
}

ClassMethod GetStdDicPageCount(ADicCode As %String, AAias As %String, ACode As %String, ADesc As %String, ARowCount As %Integer) As %String [ WebMethod ]
{
	
	q ##Class(EMRservice.BL.BLStdDictionary).GetStdDicPageCount(ADicCode,AAias,ACode,ADesc,ARowCount)
}

ClassMethod SelectALLStdDic() As EMRservice.dataset.EStdDictionaryDataset [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLStdDictionary).SelectALLStdDic()
}

ClassMethod UpdateStdDictionary(AEStdDictionary As EMRservice.entity.EStdDictionary) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLStdDictionary).UpdateStdDictionary(AEStdDictionary)
}

ClassMethod SelectStdDicByRuleTypeTag(argRuleTypeTag As %String) As EMRservice.dataset.EStdDicByRuleTypeTagDataset [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLStdDictionary).SelectStdDicByRuleTypeTag(argRuleTypeTag)
}

/// Desc:	根据字典代码获取字典默认查询条件
/// Debug：	w ##Class(EMRservice.BOStdDictionary).SelectConditionByStdCode("S06")
ClassMethod SelectConditionByStdCode(AStdDicCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLStdDictionary).SelectConditionByStdCode(AStdDicCode)
}

/// Desc:改变记录顺序
/// Creator: Candyxu
/// Date: 2012-06-07
/// input: RowID1 交换记录的第一条记录ID，RowID2 交换记录的第二条记录ID
/// Result:0失败，1成功
/// do ##class(EMRservice.BOStdDictionary).SwapSequence("3","4")
ClassMethod SwapSequence(RowID1 As %String, RowID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLStdDictionary).SwapSequence(RowID1,RowID2)
}

/*
ClassMethod Testordlst()
{
  D ##class(EMRservice.BOStdDictionary).GetStdDicOrList("2","jxw","2","12","True",8,2581)
}

ClassMethod icdtest(argTarget As %String) As %String [ WebMethod ]
{
	s hasGB=0
  S ComLength = $L(argTarget)
  for I=1:1:ComLength {
	S GBStr= $E(argTarget,I)  
	if (($A(GBStr)>=19968)&& ($A(GBStr)<=40869))||(($A(GBStr)>=63744)&& ($A(GBStr)<=64045))
	{s hasGB=1}
	q:(hasGB=1)
	}
	
	s rowid="",ttt=""
	for {
		s rowid=$o(^MRC("ID",rowid))
		q:(rowid="")
		s code=$p($g(^MRC("ID",rowid)),"^",4)
		s desc=$p($g(^MRC("ID",rowid)),"^",2)
		s aliasRowid=0,alias=""
		for {
			s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
			q:(aliasRowid="")
			s alias=alias_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		}
		;w code_"^"_desc_"^"_alias,!
		if (hasGB=1) {
			if $$CheckContain(desc,argTarget,hasGB) {s ttt=ttt_code_"^"_desc_$c(10)}
		}
		else {
			if $$CheckContain(desc,argTarget,hasGB)||$$CheckContain(code,argTarget,hasGB)||$$CheckContain(alias,argTarget,hasGB) {s ttt=ttt_code_"^"_desc_$c(10)}
		}
	}
	q ttt
	
CheckContain(AVesselStr,ACompStr,isGB)
  S Result = 0
  S ComLength = $L(ACompStr)
  
  if 'isGB
  {
		if (AVesselStr [ ACompStr)
		{ s Result = 1}
	}
  Elseif isGB
  {s HasConFlag= "True"
	 for I=1:1:ComLength 
     { S GBStr= $E(ACompStr,I)  
	   s GBConFlag= "False"
	   if (I=1)
	   { S ANewVesselStr = AVesselStr  }
        if (ANewVesselStr [GBStr)
        { s GBConFlag= "True"
	      S ANewVesselStr = $E(ANewVesselStr, $F(ANewVesselStr,GBStr),$L(ANewVesselStr))
	      }
			if (GBConFlag="False")
			{ s HasConFlag= "False"	}
    }
	 if (HasConFlag="True")
	 { S Result =1 	 }
	} 	
  Quit Result
}
*/
/// Debug:	d ##Class(EMRservice.BOStdDictionary).TestStdDic()
ClassMethod TestStdDic()
{
    s objStdDictionary = ##Class(EMRservice.entity.EStdDictionary).%New()
	set objStdDictionary.Code ="HQL6"
	set objStdDictionary.Description = "LSJDJ"
	set objStdDictionary.DicAliasCol = "SDF"
	set objStdDictionary.DicCodeCol = "SDF"
	set objStdDictionary.DicDescCol ="SDF"
	set objStdDictionary.Name = "SDF"
	set objStdDictionary.TableName ="SDFS"
	set objStdDictionary.IsRuleType = "N"
	set objStdDictionary.RuleTypeTag = "CS"
	set objStdDictionary.Condition ="1234"
	set objStdDictionary.ConditionCode = "SOS"
	set objStdDictionary.IsDiagnosRuleType = "CS"
    s obj = ..CreateStdDictionary(objStdDictionary)
}

}
