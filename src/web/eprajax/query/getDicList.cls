/// Creator:Candyxu
/// CreatDate:20120114
/// Desc: 获取字典jeson
Class web.eprajax.query.getDicList Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s DicCode = $Get(%request.Data("DicCode",1),"")
	s DicQuery = $Get(%request.Data("DicQuery",1),"")
	s type = $Get(%request.Data("Type",1),"")
	if (type = "HISUI")
	{
		s page = $g(%request.Data("page",1),"1")
		s rows = $g(%request.Data("rows",1),"12")
		s start = (page - 1) * rows
		s limit = rows
	}
	else
	{
		s start = $g(%request.Data("start",1),"0")
		s limit = $g(%request.Data("limit",1),"12")
	}
	
    d ..DicList(DicCode,DicQuery,start,limit,type)
    Quit $$$OK
}

/// d ##Class(web.eprajax.query.getDicListHIS).DicList("S07","",0,12)
/// Input:	ADicCode 	字典编码
/// 		DicQuery	查询条件
/// 		AStartRow	起始行
/// 		ARowCount	要获取的字典项行数
ClassMethod DicList(ADicCode As %String, ADicQuery As %String, AStartRow As %Integer, ARowCount As %Integer, AType As %String = "")
{
	s startRow = AStartRow + 1
	s endRow = AStartRow + ARowCount
	s TotalRowCount = 0
	
	w "{"
	if (AType = "HISUI")
	{
		w """rows"":["
	}
	else
	{
		w """data"":["
	}
    
    //查询条件中是否含有GB字符
 	s hasGB=0
 	s QryLength = $L(ADicQuery)
 	for I=1:1:QryLength 
 	{
		s GBStr= $E(ADicQuery,I)  
		if (($A(GBStr)>=19968)&& ($A(GBStr)<=40869))||(($A(GBStr)>=63744)&& ($A(GBStr)<=64045))
		{
			s hasGB=1
			q
		}
 	}
 	
	if (ADicCode = "S07")
	{
		s TotalRowCount = ..DicListS007(ADicCode,ADicQuery,startRow,endRow,"0",hasGB)
	}
	elseif (ADicCode = "S10")
	{
		s TotalRowCount = ..DicListS010(ADicCode,ADicQuery,startRow,endRow,"0",hasGB)
	}
	else
	{
		s TotalRowCount = ..DicListOther(ADicCode,ADicQuery,AStartRow,ARowCount)
	}
	
	w "]"
	if (AType = "HISUI")
	{
		w ",""total"":"""_TotalRowCount_""""
	}
	else
	{
		w ",""TotalCount"":"""_TotalRowCount_""""
	}
	w "}"
}

ClassMethod DicListS007(ADicCode As %String, ADicQuery As %String, AStartRow As %Integer, AEndRow As %Integer, AIsKeepMinus, AHasGB) As %String
{
	//结果行总数
	s totRowCount = 0
	s outputCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CTLOC(rowid))
		quit:(rowid = "")
		
		s dataactiveto = $p($g(^CTLOC(rowid)),"^",25)
		continue:((dataactiveto '= "")&&(dataactiveto < $p($h,",",1)))
		
		///共库判断///
		s hospitalId = $Get(%session.Data("LOGON.HOSPID"))
		s showShareHospital=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
		s locHospitalId = $p($g(^CTLOC(rowid)),"^",22)
		continue:((hospitalId'="")&&(hospitalId'=locHospitalId)&&(showShareHospital="N"))
		/////////////
		
		//取代码列,描述列,别名列
		s CodeValue=rowid
		s DescValue=$p($g(^CTLOC(rowid)),"^",2)
		
		s AliasValue = $p($g(^CTLOC(rowid)),"^",43)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (ADicQuery '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(ADicQuery,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(ADicQuery,"U"),AHasGB)
			if ((AliasValue '="")&&(AliasValue'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(ADicQuery,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		
		continue:(totRowCount < AStartRow)
		continue:(totRowCount > AEndRow)
		
		s outputCount = outputCount + 1
		
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s json = "{""ID"":"""_totRowCount_""","
	 	s json = json_"""DicAlias"":"""_AliasValue_""","
	 	s json = json_"""DicCode"":"""_CodeValue_""","
		s json = json_"""DicDesc"":"""_DescValue_"""}"

		//替换掉json串中的回车换行符号
		s json = $tr(json,$c(10),"")
		s json = $tr(json,$c(13),"")
		
		if (outputCount > 1) {w ","}
		w json
	}
    
	q totRowCount
}

ClassMethod DicListS010(ADicCode As %String, ADicQuery As %String, AStartRow As %Integer, AEndRow As %Integer, AIsKeepMinus, AHasGB) As %String
{
	//结果行总数
	s totRowCount = 0
	s outputCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^PAWARD(rowid))
		quit:(rowid = "")
		
		s dataactiveto = $p($g(^PAWARD(rowid)),"^",9)
		continue:((dataactiveto '= "")&&(dataactiveto < $p($h,",",1)))
		
		///共库判断///
		s hospitalId = $Get(%session.Data("LOGON.HOSPID"))
		if (hospitalId '= "")
		{
			s locRowId = $p($g(^PAWARD(rowid)),"^",5)
			continue:(locRowId="")
			s showShareHospital=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
			s locHospitalId = $p($g(^CTLOC(locRowId)),"^",22)
			continue:((hospitalId'=locHospitalId)&&(showShareHospital="N"))
		}
		/////////////
		
		//取代码列,描述列,别名列
		s AliasValue=""
		s CodeValue=rowid
		s DescValue=$p($g(^PAWARD(rowid)),"^",2)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (ADicQuery '= "")
		{	
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(ADicQuery,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(ADicQuery,"U"),AHasGB)
			if ((AliasValue '="")&&(AliasValue'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(ADicQuery,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		
		continue:(totRowCount < AStartRow)
		continue:(totRowCount > AEndRow)
		
		s outputCount = outputCount + 1
		
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s json = "{""ID"":"""_totRowCount_""","
	 	s json = json_"""DicAlias"":"""_AliasValue_""","
	 	s json = json_"""DicCode"":"""_CodeValue_""","
		s json = json_"""DicDesc"":"""_DescValue_"""}"

		//替换掉json串中的回车换行符号
		s json = $tr(json,$c(10),"")
		s json = $tr(json,$c(13),"")
		
		if (outputCount > 1) {w ","}
		w json
	}
    
	q totRowCount
}

/// d ##Class(web.eprajax.query.getDicList).DicList("S07","",0,12,"True",0,"","","")
/// modify by ncc 2012-08-09
ClassMethod DicListOther(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer) As %String
{
    //检查参数有效性
 	if (ADicCode=$C(0)) { s ADicCode= "" Quit ""}
 	if (AItem=$C(0)){ s AItem= ""}
 	if (AStartRow=$C(0)){ s AStartRow = 0 Quit ""}
 	if (ARowCount=$C(0)){ s ARowCount = 0 Quit ""} 
 	
 	s CountFlag = "True",  AResultCount = "", SessionId = "", AConditionCode = "", ACondition = ""
 	
   	S ASessionId=$I(^CacheTemp)
   	s SessionId=ASessionId
   	K ^CacheTempStdQuery(ASessionId)
   
   	//生成字典查询结果集，并存储在临时global中
   	s PageCount= ##class(EPRmeta.StdDictionary).SelectNewStdDicPageCount(ADicCode,AItem,AStartRow,ARowCount,ASessionId,AConditionCode,ACondition)
   	s AResultCount =PageCount
   	s TotalRowCount =  $G(^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount"))
   	//取相应页码的结果
  	if (PageCount'=0)
  	{ 
  		//以AStartRow开始，查询ARowCount个数据到Result中，与下面的按页查询相区别
  		s Result = ##class(%ResultSet).%New("EPRservice.DAL.Query.DAGetDicInTurn:GetDicInTurn")
  		//s Result = ##class(%ResultSet).%New("EPRmeta.StdDictionary:GetStdDicOrList")
    	d Result.Execute(ADicCode,AItem,AStartRow,ARowCount,ASessionId)
  	}
  	else
  	{
		s SessionId=0
		s Result = "" 
	}
 	
 	q:(TotalRowCount < "1") TotalRowCount
 	
 	
 	
 	//构造json数据
 	s json = ""
 	while(Result.Next())
 	{
	 	s json = json_"{""ID"":"""_$g(Result.Data("ID"))_""","
	 	s json = json_"""DicAlias"":"""_$g(Result.Data("DicAlias"))_""","
	 	s json = json_"""DicCode"":"""_$g(Result.Data("DicCode"))_""","
		s json = json_"""DicDesc"":"""_$g(Result.Data("DicDesc"))_"""},"	
	}
    s json = $e(json, 1, $l(json)-1)
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	w json
	
	q TotalRowCount
}

}
