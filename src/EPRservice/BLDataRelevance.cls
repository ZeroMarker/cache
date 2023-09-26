Class EPRservice.BLDataRelevance Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 计算公式格式:if(I0353<>"",S0462=datarelevance(I0353,"GetICode"))
ClassMethod GetDataRelevance(ARowID As %String, MethodName As %String) As %String
{
	//通过诊断RowId获取诊断ICD10代码
  	if MethodName="GetICode"
  	{
	  	q ..GetICode(ARowID)
	}
	//通过城市代码(CT_City.CTCIT_Code)获取邮政编码(CT_Zip.CTZIP_Code)
	if MethodName="GetPostCodeByCityCode"
  	{
	  	q ..GetPostCodeByCityCode(ARowID)
	}
	//通过城市区县代码(CT_CityArea.CITAREA_Code)获取邮政编码(CT_Zip.CTZIP_Code)
	if MethodName="GetPostCodeByAreaCode"
  	{
	  	q ..GetPostCodeByAreaCode(ARowID)
	}
	//通过手术代码(ORC_Operation.OPER_Code)获取手术类级描述(ORC_OperationCategory.CATEG_Desc)
	if MethodName="GetOperCatByOperCode"
  	{
	  	q ..GetOperCatByOperCode(ARowID)
	}
	//通过手术RowId(ORC_Operation.OPER_RowId)获取手术类级描述(ORC_OperationCategory.CATEG_Desc)
	if MethodName="GetOperCatByOperRowId"
  	{
	  	q ..GetOperCatByOperRowId(ARowID)
	}
	//通过手术ICD10(ORC_Operation.OPER_ICD10)获取手术类级描述(ORC_OperationCategory.CATEG_Desc)
	if MethodName="GetOperCatByOperICD10"
  	{
	  	//因手术ICD10没有索引,故谨慎使用!
	  	//q ..GetOperCatByOperICD10(ARowID)
	}
}

//w ##Class(EPRservice.BLDataRelevance).GetICode("4")

//获取诊断字典单元的ICD10编码

ClassMethod GetICode(ARowID As %String) As %String
{
  q:(ARowID = "") ""
  s code=$P($g(^MRC("ID",ARowID)),"^",4)
  q code
}

/// Creator:	wangwentao
/// CreatDate:	20131101 AHSLYY Requirement 字典单元关联字符单元
/// Desc:	通过城市代码(CT_City.CTCIT_Code)获取邮政编码(CT_Zip.CTZIP_Code)
/// Debug:	w ##Class(EPRservice.BLDataRelevance).GetPostCodeByCityCode("4")
ClassMethod GetPostCodeByCityCode(ARowID As %String) As %String
{
	q:(($d(ARowID)=0)||(ARowID="")) ""
  
	s Ret=""
	s (CTCityDR,CTZipDR)=""
  
	s CTCityDR = $o(^CT("CIT",0,"Code",ARowID,CTCityDR))	//CT_City
  	q:(CTCityDR="") Ret
  	
  	s CTZipDR = $o(^CT("ZIP",0,"City",CTCityDR,CTZipDR))	 //CT_Zip
	q:(CTZipDR="") Ret
	
	s Ret = $p($g(^CT("ZIP",CTZipDR)),"^",1)
  
	q Ret
}

/// Creator:	wangwentao
/// CreatDate:	20131101 AHSLYY Requirement 字典单元关联字符单元
/// Desc:	通过城市区县代码(CT_CityArea.CITAREA_Code)获取邮政编码(CT_Zip.CTZIP_Code)
/// Debug:	w ##Class(EPRservice.BLDataRelevance).GetPostCodeByAreaCode("4")
ClassMethod GetPostCodeByAreaCode(ARowID As %String) As %String
{
	q:(($d(ARowID)=0)||(ARowID="")) ""
	
	s Ret=""
	s (CTCityAreaDR,CTZipDR)=""
  
	s CTCityAreaDR = $o(^CT("CITAREA",0,"Code",ARowID,CTCityAreaDR))	//CT_CityArea
  	q:(CTCityAreaDR="") Ret
  	
  	s CTZipDR = $o(^CT("ZIP",0,"CityArea",CTCityAreaDR,CTZipDR))	 //CT_Zip
	q:(CTZipDR="") Ret
	
	s Ret = $p($g(^CT("ZIP",CTZipDR)),"^",1)
  
	q Ret
}

/// Creator:	wangwentao
/// CreatDate:	20131105 AHSLYY Requirement 字典单元关联单选单元
/// Desc:	通过手术代码(ORC_Operation.OPER_Code)获取手术类级描述(ORC_OperationCategory.CATEG_Desc)
/// 		
/// Debug:	w ##Class(EPRservice.BLDataRelevance).GetOperCatByOperCode("4")
ClassMethod GetOperCatByOperCode(ARowID As %String) As %String
{
	q:(($d(ARowID)=0)||(ARowID="")) ""
	
	s Ret=""
	s (rowid,OPERRowId,OPERDefaultCategoryDR,CATEGDesc)=""

	for {
		s rowid = $o(^ORC("OPER",0,"Code",ARowID,rowid))	//ORC_Operation
		q:(rowid="")||(OPERRowId'="")
		
		//判断起止日期
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^ORC("OPER",rowid)),"^",5)
		s dateTo=$p($g(^ORC("OPER",rowid)),"^",6)
		s currentDate=$p($h,",",1)
		continue:(((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		
		s OPERRowId = rowid
	}
  	q:(OPERRowId="") Ret
  	
  	s OPERDefaultCategoryDR = $p($g(^ORC("OPER",OPERRowId)),"^",7)	 //OPER_DefaultCategory_DR
	q:(OPERDefaultCategoryDR="") Ret
	
	s CATEGDesc = $p($g(^ORC("CATEG",OPERDefaultCategoryDR)),"^",2)	//ORC_OperationCategory.CATEG_Desc
  	
  	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
  	
  	if Hospital = "AHSLYY"	//安徽省立医院
  	{
	  	s Ret = $s(CATEGDesc="1A手术":"一级手术",CATEGDesc="2A手术":"二级手术",CATEGDesc="3A手术":"三级手术",CATEGDesc="4A手术":"四级手术",1:"")
  	}
  	
	q Ret
}

/// Creator:	wangwentao
/// CreatDate:	20131105 AHSLYY Requirement 字典单元关联单选单元
/// Desc:	通过手术RowId(ORC_Operation.OPER_RowId)获取手术类级描述(ORC_OperationCategory.CATEG_Desc)
/// 		
/// Debug:	w ##Class(EPRservice.BLDataRelevance).GetOperCatByOperRowId("4")
ClassMethod GetOperCatByOperRowId(ARowID As %String) As %String
{
	q:(($d(ARowID)=0)||(ARowID="")) ""
	
	s Ret=""
	s (OPERRowId,OPERDefaultCategoryDR)=""
  
	s OPERRowId = ARowID	//ORC_Operation
  	
  	s OPERDefaultCategoryDR = $p($g(^ORC("OPER",OPERRowId)),"^",7)	 //OPER_DefaultCategory_DR
	q:(OPERDefaultCategoryDR="") Ret
	
	s Ret = $p($g(^ORC("CATEG",OPERDefaultCategoryDR)),"^",2)	//ORC_OperationCategory.CATEG_Desc
  
	q Ret
}

/// Creator:	wangwentao
/// CreatDate:	20131105 AHSLYY Requirement 字典单元关联单选单元
/// Desc:	通过手术ICD10(ORC_Operation.OPER_ICD10)获取手术类级描述(ORC_OperationCategory.CATEG_Desc)
/// 		
/// Debug:	w ##Class(EPRservice.BLDataRelevance).GetOperCatByOperICD10("4")
ClassMethod GetOperCatByOperICD10(ARowID As %String) As %String
{
	q:(($d(ARowID)=0)||(ARowID="")) ""
	
	s Ret=""
	s (OPERRowId,OPERDefaultCategoryDR)=""
  
	s OPERRowId = $$GetOperRowIdByOperICD10(ARowID)	//ORC_Operation
  	q:(OPERRowId="") Ret
  	
  	s OPERDefaultCategoryDR = $p($g(^ORC("OPER",OPERRowId)),"^",7)	 //OPER_DefaultCategory_DR
	q:(OPERDefaultCategoryDR="") Ret
	
	s Ret = $p($g(^ORC("CATEG",OPERDefaultCategoryDR)),"^",2)	//ORC_OperationCategory.CATEG_Desc
  
	q Ret
	
GetOperRowIdByOperICD10(AOperICD10)
	
	q:(AOperICD10="") ""
	s rowid = 0,OperRowId=""
	for {
		s rowid=$o(^ORC("OPER",rowid))
		quit:(rowid = "")||(OperRowId'="")
		
		//判断起止日期
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^ORC("OPER",rowid)),"^",5)
		s dateTo=$p($g(^ORC("OPER",rowid)),"^",6)
		s currentDate=$p($h,",",1)
		continue:(((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		
		//判断ICD10编码	
		s CodeValue =  $p($g(^ORC("OPER",rowid)),"^",14)
		continue:(CodeValue'=AOperICD10)
		
		//获取手术RowId
		s OperRowId = rowid
	}

	q OperRowId
}

ClassMethod GetServerData(AMethodName, AParam1 As %String, AParam2 As %String, AParam3 As %String, AParam4 As %String, AParam5 As %String, AParam6 As %String, AParam7 As %String, AParam8 As %String, AParam9 As %String, AParam10 As %String) As %String [ WebMethod ]
{
	s result = ""
	q result
}

}
