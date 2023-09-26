Class DHCWL.MKPIService.MKPIDataFormatUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

/**
 * 
 * @author lihaihong
 * @date  2015/6/24
 s xmlStr="<Request><endDate>2015-06-1</endDate><queryRule>KD0017</queryRule><requestCode>30101</requestCode><startDate>2015-06-1</startDate></Request>"
 d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).resolveXmlParameter(xmlStr,.pro)
 
 d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).resolveXmlParameter("",.pro)
 */
ClassMethod resolveXmlParameter(xmlParameter As %String, ByRef property) As %String
{
	n (xmlParameter,property)
	;s xmlParameter="<Request><Code>30101</Code><dateType>freeDateChoce</dateType><endDate>2015-06-26</endDate><filterRule>undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined</filterRule><queryModel>S</queryModel><queryRule>RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc</queryRule><requestCode>30101</requestCode><rnumber>8164</rnumber><startDate>2015-06-01</startDate></Request>"
	s speciCharMap("&")="&amp;",speciCharMap("<")="&lt;",speciCharMap(">")="&gt;"
	s speciCharMap("""")="&quot;",speciCharMap("'")="&apos;"
	s rootNode="Request"
	Set sc =##class(%XML.TextReader).ParseString(xmlParameter,.reader)
    If $$$ISERR(sc){ 
		q $system.OBJ.DisplayError(sc) 
	}
	if ('reader.ReadStartElement(rootNode)){
		d reader.Rewind()
		q:'(reader.ReadStartElement(rootNode)) "不存在该节点："_rootNode
	}
	while(reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
		}
		if (reader.NodeType="chars") {
			s firstChar=$e(reader.Value,1)
			if ($d(speciCharMap(firstChar))) {
				s nodeValue=$g(nodeValue,"")_reader.Value
			}else {
				s nodeValue=reader.Value
			}
			
			s property(nodeName)=nodeValue
			
		}
		if ((reader.NodeType="endelement")&&(reader.Name=rootNode)){
			q
		}
	}
	q "ok"
}

// d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).SaveNewWechat()

ClassMethod SaveNewWechat(str As %String = "", seperate As %String = "")
{
	n (str,seperate)
	s result="ok"
	if seperate="" s seperate="@"
	if str="" d
	.s str="ActionCode|30101^ActionName|指标统一接口^ClassName|DHCWL.web.chat.KpiConfigService^MethodName|formatJsonConfigAppKpiDataString"
	.s str="ActionCode|30102^ActionName|获取配置的应用指标^ClassName|DHCWL.web.chat.KpiConfigService^MethodName|getConfigKpiJsonString"
	
	
	s strlength=$l(str,"@")
	;b ;;
	for i=1:1:strlength  d
	.s subStr=$p(str,"@",i)
	.s result=##class(MHC.Store.ServiceAction).Save("",subStr)
	
	
	q result
}

// w ##class(DHCWL.MKPIService.MKPIDataFormatUtil).formatJsonKpiDataString("<Request><endDate>2015-06-1</endDate><queryRule>KD0017</queryRule><startDate>2015-06-1</startDate></Request>")

ClassMethod formatJsonKpiDataString(xmlParameter As %String) As %String
{
	n (xmlParameter)
	;s start=$p($h,",",2)
	;s xmlParameter="<Request><Code>30101</Code><dateType>freeDateChoce</dateType><endDate>2015-06-26</endDate><filterRule>undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined</filterRule><queryModel>S</queryModel><queryRule>RegLocHpNums:Doc,RegLocHpNums:Doc,RegLocHpNums:Doc,RegLocHpNums:Doc,RegLocHpNums:Doc,RegLocHpNums:Doc,RegLocHpNums:Doc,RegLocHpNums:Doc,RegLocHpNums:Doc,RegLocHpNums:Doc,RegLocHpNums:Doc</queryRule><requestCode>30101</requestCode><rnumber>8454</rnumber><startDate>2015-06</startDate></Request>"
	;s ^test("lhhtest")=xmlParameter
	s sc= ..resolveXmlParameter(xmlParameter,.parameters)
	if sc'="ok" q sc
	s stream=..formatJsonKpiData(.parameters)
	;s end=$p($h,",",2)
	;s ^test("lhhtest","Time")=(end-start)
	q stream.ReadLine()
}

// w ##class(DHCWL.MKPIService.MKPIDataFormatUtil).GetJsonKpiDataString("2015-06-25","2015-06-25",,"lhcs0617","","C","PP",)

ClassMethod GetJsonKpiDataString(startDate As %String, endDate As %String, dateType As %String = "", queryRule As %Text, filterRule As %Text = "", queryModel = "H", contract As %String = "", originalDimFlag As %Integer = 0, execParam As %Text = "") As %String
{
	n (startDate, endDate, dateType, queryRule, filterRule, queryModel, contract, originalDimFlag,execParam)
	s flag=##class(DHCWL.MKPIService.MKPIDataFormatUtil).GetErrorInfor(dateType,startDate,endDate,contract,queryRule)
	i flag=1{
		q "查询规则有错误，请检查后查询"
	}
	s parameters("startDate")=startDate
	s parameters("endDate")=endDate
	s parameters("dateType")=dateType
	s parameters("queryRule")=queryRule
	s parameters("filterRule")=filterRule
	s parameters("queryModel")=queryModel
	s parameters("contract")=contract
	s parameters("originalDimFlag")=originalDimFlag
	s stream=..formatJsonKpiData(.parameters)
	q stream.ReadLine()
}

ClassMethod GetErrorInfor(dateType, startDate, endDate, contract, queryRule, queryModle)
{
	n (dateType,startDate,endDate,contract,queryRule,queryModle)
	/*s sign=0
	s sign1=0
	s sign2=0
	s proFlag=0
	k sectionDimList
	k kpiIdSaveList
	s conTypeLen=$l(contract,",")
	f i=1:1:conTypeLen {
		s type=$p(contract,",",i)
		continue:type=""
		if (type="PP")||(type="SL"){
			s sign=1
			q
		}
	}
	if (queryModle["C"){
		s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(dateType))
		s queryRuleLen=$l(queryRule,",")
		for i=1:1:queryRuleLen{
			s query=$p(queryRule,",",i)
			continue:query=""
			s kpiCode=$p(query,":",1)
			continue:kpiCode=""
			s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
			continue:kpiId=""
			s kpiIdSaveList(kpiId)=""
			s monIdStr2=##class(DHCWL.MKPIService.DateUtil).ConvertMaxSectionByKpi(monthId,kpiId)
			if (monIdStr2'=monthId){
				s proFlag=1
				q
			}
		}
	}
	s flag=0
	if (sign=1)||(proFlag=1){
		s queryRuleLen=$l(queryRule,",")
		for i=1:1:queryRuleLen{
			s query=$p(queryRule,",",i)
			continue:query=""
			s kpiCode=$p(query,":",1)
			continue:kpiCode=""
			s queryInfor=$p(query,":",2)
			continue:queryInfor=""
			s queryInforLen=$l(queryInfor,"^")
			for j=1:1:queryInforLen{
				s queryMInfor=$p(queryInfor,"^",j)
				continue:queryMInfor=""
				s sectionDim=$p(queryMInfor,"$",2)
				continue:sectionDim=""
				s sectionDimList(sectionDim)=""
			}
			s fullCode=""
			s flag1=0
			s flag2=0
			for{
			s fullCode=$o(sectionDimList(fullCode))
			q:fullCode=""
			if (proFlag=1){
				s flag=1
			}
			s code=$p(fullCode,".",2)
			if code=""{
				s flag1=1
			}else{
				s flag2=1
			}
			}
			if (flag1=0)&&(flag2=1)&&(sign=1){
				s flag=1
			}
			k sectionDimList
			if (flag=1){
				q
			}
		}
	}
	q flag*/
	s sign=0
	k sectionDimList
	k sectionCodeList
	if ((queryModle["S")=1){
		s sectionId=""
		for{
			s sectionId=$o(^DHCWL.MKPI.SectionD(sectionId))
			q:sectionId=""
			s sectionCode=""
			s sectionCode=$lg(^DHCWL.MKPI.SectionD(sectionId),2,"")
			s sectionCodeList(sectionCode)=""
		}
		s queryRuleLen=$l(queryRule,",")
		for i=1:1:queryRuleLen{
			s query=$p(queryRule,",",i)
			continue:query=""
			s kpiCode=$p(query,":",1)
			continue:kpiCode=""
			s queryInfor=$p(query,":",2)
			continue:queryInfor=""
			s queryInforLen=$l(queryInfor,"^")
			for j=1:1:queryInforLen{
				s queryMInfor=$p(queryInfor,"^",j)
				continue:queryMInfor=""
				s sectionDim=$p(queryMInfor,"$",2)
				continue:sectionDim=""
				;s sectionDimList(sectionDim)=""
				if ($d(sectionCodeList(sectionDim))=0){
					s sign=1
					q
				}
			}
			if (sign=1){
				q
			}
		}
	}
	q sign
}

ClassMethod formatJsonKpiData(ByRef parameters) As %Library.GlobalCharacterStream
{
	n (parameters)
	;s parameters("startDate")="2015-06-1"
 	;s parameters("endDate")="2015-06-1"
 	;s parameters("queryRule")="RegLocHpNums:Loc^Doc,RegLocLgNums:Loc^Doc"
 	;s parameters("filterRule")="RegLocHpNums:( {Loc} <10)"
 	;s parameters("queryModel")="SR"
	s kpiRule=$g(parameters("queryRule"))
	//d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).ResovleKpiRuleWithPosition(kpiRule,.kpiRuleMap)
	d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).majorKpiDimGlobalData(.parameters)
	
	q ##class(DHCWL.MKPIServicee.MKPIDataFormatUtil).formatJsonMajorKpiData()
}

// d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).formatJsonMajorKpiData()

ClassMethod formatJsonMajorKpiData(ByRef parameters) As %Library.GlobalCharacterStream
{
	n (parameters)
	
	s stream=##class(%Library.GlobalCharacterStream).%New()
	d stream.Write( "{")
	s kpiCode="" f  s kpiCode=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode)) q:kpiCode=""  d
	.d stream.Write( """"_kpiCode_""""_":{list:[" )
	.if $d(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR")) d
	..s sourceDim=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR")
	..s sourceDimLength=$ll(sourceDim)
	..s dimValueList="" f  s dimValueList=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimValueList)) q:dimValueList=""  d
	...d stream.Write( "{" )
	...s value=^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimValueList)
	...s sourceDimIndex=0
	...f sourceDimIndex=1:1:sourceDimLength d
	....s dimCode=$li(sourceDim,sourceDimIndex)
	....s dimValue=$li(dimValueList,sourceDimIndex)
	....d stream.Write( """"_dimCode_""""_":"""_dimValue_"""," )
	...d stream.Write( "value:"_value )
	...d stream.Write( "}" )
	...s dimValueList=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimValueList))
	...if dimValueList'="" d stream.Write( "," )
	...s dimValueList=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimValueList),-1)
	
	.d stream.Write( "],value:"_^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SUMVALUE")_"}" )
	.s kpiCode=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode))
	.if kpiCode'="" d stream.Write( "," )
	.s kpiCode=$o(^||TEMPDHCWLMKPI("SUM",$j,kpiCode),-1)
	.d stream.Flush()
	d stream.Write( "}")
	;b ;001
	k ^||TEMPDHCWLMKPI("SUM",$j)
	k ^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
	q stream
}

/*
 s parameters("startDate")="2012-01-01"
 s parameters("endDate")="2012-01-01"
 s parameters("queryRule")="5"
 s parameters("kpiFilter")=""
 s parameters("queryModel")=""
 s parameters("originalDimFlag")=1
 d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).majorKpiDimGlobalData(.parameters)
 
 */
ClassMethod majorKpiDimGlobalData(ByRef parameters, execParam As %Text = "")
{
	n (parameters,execParam)
	s startTime=$p($h,",",2)
	;s parameters("startDate")="2013-01-1"
 	;s parameters("endDate")="2013-01-1"
 	;s parameters("queryRule")="6"
 	
	s startDate=$g(parameters("startDate"))
	s endDate=$g(parameters("endDate"))
	s dateType=$g(parameters("dateType"))
	s kpiRule=$g(parameters("queryRule"))
	s kpiFilter=$g(parameters("filterRule"))
	s queryModle=$g(parameters("queryModel"))
	s contract=$g(parameters("contract"))
	s originalDimFlag=$g(parameters("originalDimFlag"),0)
	s flag=##class(DHCWL.MKPIService.MKPIDataFormatUtil).GetErrorInfor(dateType,startDate,endDate,contract,kpiRule,queryModle)
	i flag=1{
		q "查询规则有错误，请检查后查询"
	}
	s queryModle=queryModle_"E"
	i $g(endDate)="" s endDate=$g(startDate)
 	//s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(dateType))
 	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByModePName($g(startDate)_":"_$g(endDate),":",$g(dateType),$g(queryModle)) ;实际日期转换成连续的MonthId
 	q:monthId="" $$$OK
	k kpiFilterMap,queryModleMap,kpiRuleMap
	d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).ResovleKpiRuleWithPosition(kpiRule,.kpiRuleMap)
	;s kpiRule=##class(DHCWL.MKPIService.MKPIQuery).HandleKpiRule(.kpiRuleMap,kpiRule,contract,queryModle)
	k kpiRuleMap
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(kpiFilter,.kpiFilterMap)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiRule,queryModle,.queryModleMap)
	d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).ResovleKpiRuleWithPosition(kpiRule,.kpiRuleMap)
	//d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth(monthId,contract,.resovledMon)
	//d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth2(.queryModleMap, monthId,contract,.resovledMon)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleMulMonth(.queryModleMap, monthId,contract,.resovledMon,queryModle)
	;s kpi=##class(DHCWL.MKPIService.MKPIQuery).HandleKpiRule(.kpiRuleMap,kpi,contractType,queryModle)
	s isReal=queryModleMap("$RealFlag")
	s sumFlag=queryModleMap("$SumFlag")
	s convertFlag=queryModleMap("$ConMaxFlag")
	s kpiIdStr=queryModleMap("$PARAMKPI")
	s kpiIdLen=$l(kpiIdStr,",")
	s gblFlag="TEMPKPIDATA"
	k ^||TEMPDHCWLKPIDATA(gblFlag,$j)
	k ^||TEMPDHCWL($j,"allRelKpiID")
	d ##class(DHCWL.MKPIService.SetKPIData).GetCalKPIData2(gblFlag,.resovledMon,.queryModleMap,.kpiFilterMap)
	//n (kpiFilterMap,queryModleMap,kpiRuleMap,resovledMon,originalDimFlag)
	//d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth(monthId,contract,.resovledMon)
	//d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth2(.queryModleMap, monthId,contract,.resovledMon)
	k resolvedSecMap
	k numList
	k ^||TEMPDHCWLMKPI("SUM",$j)
	s resolver=##class(DHCWL.MKPIService.Base.KpiRuleResolver).%New(1)
	s dimResolver=##class(DHCWL.MKPIService.Base.DimRuleResolver).%New()
	d dimResolver.setCache(1)
	
	s kpiCode="" f  s kpiCode=$o(kpiRuleMap(kpiCode)) q:kpiCode=""  d
	.;s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
	.s tempLb=$lb()
	.s hasSecProFlag=0
	.s index="" f  s index=$o(kpiRuleMap(kpiCode,"AllDim",index)) q:index=""  d
	..s num=index
	..s fullCode=$o(kpiRuleMap(kpiCode,"AllDim",index,""))
	..s type=$o(kpiRuleMap(kpiCode,"AllDim",index,fullCode,""))
	..;i (type="Sec")&(queryModleMap("$SumFlag")=1) d
	..;q:(type="Sec")&(queryModleMap("$SumFlag")=1)
	..i (type="Sec") s hasSecProFlag=1
	..s $li(tempLb,index)=fullCode
	.i hasSecProFlag=0 s resolvedSecMap(kpiCode,"noSec")=$ll(tempLb)+1
	.s resolvedSecMap(kpiCode)=tempLb
	.s numList(kpiCode)=num
	
	i $d(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j))'=0 d
	.s calKpiIdStr=""
	.s calKpiIdLen=""
	.f kpiIdIndex=1:1:kpiIdLen d
	..s kpiId=$p(kpiIdStr,",",kpiIdIndex)
	..q:kpiId=""
	..s getValueType=$lg(^DHCWL.MKPI.MKPID(kpiId),14,"1")
	..q:getValueType="1"
	..i calKpiIdStr="" d
	...s calKpiIdStr=kpiId
	..else  d
	...s calKpiIdStr=calKpiIdStr_","_kpiId
	.s calKpiIdLen=$l(calKpiIdStr,",")
	.f kpiIdIndex=1:1:calKpiIdLen d
	..s kpiId=$p(calKpiIdStr,",",kpiIdIndex)
	..q:kpiId=""
	..s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	..s sourceSecDimList=$lb()
	..q:'$d(resolvedSecMap(kpiCode))
	..s sourceNorDimList=resolvedSecMap(kpiCode)  ;$lb()
	..s kpiSumValue=0
	..s contractFlag="" 
	..for  s contractFlag=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag)) q:(contractFlag="")  d
	...s monId="" for  s monId=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,monId)) q:(monId="")  d
	....s dim=""  for  s dim=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,monId,kpiId,dim)) q:(dim="")  d
	.....d ResolveSec(monId)
	.....s secDimProperty="" f  s secDimProperty=$o(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,monId,kpiId,dim,secDimProperty)) q:(secDimProperty="")  d
	......s value=$g(^||TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,contractFlag,monId,kpiId,dim,secDimProperty),0)
	......s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	......d ResolveKpiDataRecorde(kpiCode,dim,value)
	..s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SUMVALUE")=kpiSumValue
	.k ^||TEMPREALKPIDATA("TEMP",$j)
	k ^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	
	s tmpKpiIdSave=""
	f kpiIdIndex=1:1:kpiIdLen d
	.s kpiId=$p(kpiIdStr,",",kpiIdIndex)
	.q:kpiId=""
	.s getValueType=$lg(^DHCWL.MKPI.MKPID(kpiId),14,"1")
	.q:getValueType="2"
	.i tmpKpiIdSave="" d
	..s tmpKpiIdSave=kpiId
	.else  d
	..s tmpKpiIdSave=tmpKpiIdSave_","_kpiId
	s kpiIdStr=tmpKpiIdSave
	s kpiIdLen=$l(kpiIdStr,",")
	
	i isReal=0 d	//is history?
	.f kpiIdIndex=1:1:kpiIdLen d
	..s kpiId=$p(kpiIdStr,",",kpiIdIndex)
	..q:kpiId=""
	..s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	..s sourceSecDimList=$lb()
	..q:'$d(resolvedSecMap(kpiCode))
	..s sourceNorDimList=resolvedSecMap(kpiCode)  ;$lb()

	..s kpiSumValue=0
	..;i convertFlag=1 d   //提升日期区间
	...;s monIdStr1=monthId,convertOk=0
	...;f needConNum=1:1:4 d
	....;q:convertOk=1
	....;s monIdStr2=##class(DHCWL.MKPIService.DateUtil).ConvertMaxSectionByKpi(monthId,kpiId)
	....;i monIdStr1=monIdStr2 s convertOk=1
	....;s monIdStr1=monIdStr2
	...;s monIdStr=monIdStr1
	...;s monIdLen=$l(monIdStr,",")
	...;d ##class(DHCWL.MKPIService.SetKPIData).ResovleMonth(monIdStr,contractType,.resovledMon)
	..s dimProValueList=$lb()
	..s dimProSourceValueList=$lb()
	..;s kpiId="" f  s kpiId=$o(resovledMon(kpiId)) q:kpiId=""  d
	..s contractFlag="" f  s contractFlag=$o(resovledMon(kpiId,contractFlag)) q:(contractFlag="")  d
	...s monId="" f  s monId=$o(resovledMon(kpiId,contractFlag,monId)) q:(monId="")  d
	....d ResolveSec(monId)
	....s monKPIId=0 f  s monKPIId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",monId,kpiId,monKPIId)) q:(monKPIId="")  d
	.....s deptKPIId=0 f  s deptKPIId=$o(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",monKPIId,deptKPIId)) q:(deptKPIId="")  d
	......q:('$d(^DHCWL.MKPI.DeptKPIDataD(deptKPIId)))
	......s dim=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),2)
	......s filterFlag=$d(kpiFilterMap(kpiCode)),filterResultFlag=1   //过滤开始
	......i filterFlag d
	.......s filterInd="" f  s filterInd=$o(kpiFilterMap(kpiCode,filterInd)) q:((filterInd="")||(filterResultFlag=0))  d
	........q:+filterInd=0
	........s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,"",dim,kpiFilterMap(kpiCode,filterInd),,monId)
	......q:((filterFlag)&&(filterResultFlag=0))     //过滤结束
	......s value=$lg(^DHCWL.MKPI.DeptKPIDataD(deptKPIId),4)
	......d ResolveKpiDataRecorde(kpiCode,dim,value)
	..s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SUMVALUE")=kpiSumValue
	
	else  d
	.k ^||TEMPREALKPIDATA("TEMP",$j)
	.d ..createRealMKPIData(.queryModleMap,.resovledMon,execParam)
	.f kpiIdIndex=1:1:kpiIdLen d
	..s kpiId=$p(kpiIdStr,",",kpiIdIndex)
	..q:kpiId=""
	..s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	..s sourceSecDimList=$lb()
	..q:'$d(resolvedSecMap(kpiCode))
	..s sourceNorDimList=resolvedSecMap(kpiCode)  ;$lb()
	..s kpiSumValue=0
	..;s kpiId="" f  s kpiId=$o(resovledMon(kpiId)) q:kpiId=""  d
	..s contractFlag="" f  s contractFlag=$o(resovledMon(kpiId,contractFlag)) q:(contractFlag="")  d
	...s monId="" f  s monId=$o(resovledMon(kpiId,contractFlag,monId)) q:(monId="")  d
	....d ResolveSec(monId)
	....s dim="" f  s dim=$o(^||TEMPREALKPIDATA("TEMP",$j,kpiId,monId,dim)) q:(dim="")  d
	.....s filterFlag=$d(kpiFilterMap(kpiCode)),filterResultFlag=1   //过滤开始
	.....i filterFlag d
	......s filterInd="" f  s filterInd=$o(kpiFilterMap(kpiCode,filterInd)) q:((filterInd="")||(filterResultFlag=0))  d
	.......q:+filterInd=0
	.......s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,"",dim,kpiFilterMap(kpiCode,filterInd),,monId)
	.....q:((filterFlag)&&(filterResultFlag=0))     //过滤结束
	.....s value=$g(^||TEMPREALKPIDATA("TEMP",$j,kpiId,monId,dim),0)
	.....d ResolveKpiDataRecorde(kpiCode,dim,value)
	..s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SUMVALUE")=kpiSumValue
	.k ^||TEMPREALKPIDATA("TEMP",$j)
	k ^||TEMPDHCWLKPIDATA("ResolvedNodeSession",$j)
	
ResolveSec(monId)
	s monthObj=##class(DHCWL.MKPI.Months).%OpenId(monId)
	s sectionType="D"
	k dimProValueList,dimProSourceValueList
	if monthObj'="" s sectionType=monthObj.KPIMSectionFlag.SecCode
    if (queryModleMap("$SumFlag")=1)&&($d(kpiRuleMap(kpiCode,"DimPro-Sec"))=0)  d
    .s monId=0
	.;s secResProValue="" 
	//else  d
	i monId=0 d
	.s secResProValue=""
	else  d
	.s secResProValue=$li(^DHCWL.MKPI.MonthsD(monId),3)
	s dimErrorFlag=0
	if (($d(kpiRuleMap(kpiCode,"DimPro-Sec")))) d
	.s hasSecProFlag=1
	.s secIndex="" f  s secIndex=$o(kpiRuleMap(kpiCode,"DimPro-Sec",secIndex)) q:(secIndex="")  d
	..s secCode=$o(kpiRuleMap(kpiCode,"DimPro-Sec",secIndex,""))
	..s secId=kpiRuleMap(kpiCode,"DimPro-Sec",secIndex,secCode)
	..s secProId=$p(secId,"^",2)
	..i originalDimFlag d
	...s secResProValue=monId
	..e  d
	...s monId1=monId
	...;i queryModle["S" d
	....;s secResProValue=0
	...;else  d
	...i (secProId=0)&(contractFlag="STDT")  d
	....i (queryModleMap("$SumFlag")=1) d
	.....s secResProValue=""
	....else  d
	.....s secResProValue=$li(^DHCWL.MKPI.MonthsD(monId),3)
	...i (secProId=0)&(contractFlag'="STDT") d
	....i (queryModleMap("$SumFlag")=1) d
	.....s secResProValue=""
	....else  d
	.....s monId1=resovledMon(kpiId,contractFlag,monId)
	.....i monId1'="" d
	......s secResProValue=$li(^DHCWL.MKPI.MonthsD(monId1),3)
	.....else  d
	......s febMonDesc=$lg(^DHCWL.MKPI.MonthsD(monId),5)
	......s febMonDesc=$p(febMonDesc,"-",2,$l(febMonDesc,"-"))
	......if (febMonDesc="02-29") s secResProValue=$lg(^DHCWL.MKPI.MonthsD(monId),3)_"-"
	....s contractInfor=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),4)
	....;s contractCode=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),3)
	....s secResProValue=secResProValue_contractInfor
	....;s monId1=monId_contractCode
	...if (secProId'=0)  d
	....s secCode="$"_secCode
	....s secResProValue=dimResolver.GetPropertyValue(secCode,monId1)
	....;s secResProValue=resolver.GetPropertyValue(kpiCode,secCode,monId)
	...;.s proExcStr=$lg(^DHCWL.MKPI.SectionPropertyD(secProId),5,"")
	...;.q:proExcStr=""
	...;.s proExcStr="s secResProValue=$$"_proExcStr_"(monId)"
	...;.x proExcStr
	..s monId1=monId
	..if (queryModleMap("$SumFlag")=1) d
	...s monId1=0
	..s $li(dimProValueList,secIndex)=secResProValue
	..s $li(dimProSourceValueList,secIndex)=monId1
	.s number=numList(kpiCode)+1
	.i (contractFlag'="STDT") d
	..s contractCode=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),3)
	.else  d
	..s contractCode=contractFlag
	.s $li(dimProValueList,number)=contractCode
	.s $li(dimProSourceValueList,number)=contractFlag
	.s $li(sourceNorDimList,number)="contract"
	else  d
	.s noSecProIndex=$g(resolvedSecMap(kpiCode,"noSec"))
	.s excDimValue=secResProValue
	.i originalDimFlag d
	..s excDimValue=monId
	.else  d
	..s excDimValue=secResProValue
	.s monId1=monId
	.i (contractFlag'="STDT")&(originalDimFlag=0)&(monId'=0)/*&(resovledMon(kpiId)'=1)*/ d
	..s monId1=resovledMon(kpiId,contractFlag,monId)
	..if (monId1'="") d
	...s excDimValue=$li(^DHCWL.MKPI.MonthsD(monId1),3)
	..else  d
	...s febMonDesc=$lg(^DHCWL.MKPI.MonthsD(monId),5)
	...s febMonDesc=$p(febMonDesc,"-",2,$l(febMonDesc,"-"))
	...if (febMonDesc="02-29") s excDimValue=$lg(^DHCWL.MKPI.MonthsD(monId),3)_"-"
	..s contractInfor=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),4)
	..;s contractCode=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),3)
	..;s monId1=monId1
	..s excDimValue=excDimValue_contractInfor
	.i (contractFlag'="STDT")&(monId=0) d
	..s contractInfor=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),4)
	..;s contractCode=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),3)
	..;s monId1=monId_contractCode
	..s excDimValue=contractInfor
	.s $li(dimProValueList,noSecProIndex)=excDimValue
	.s $li(dimProSourceValueList,noSecProIndex)=monId
	.s $li(sourceNorDimList,noSecProIndex)=sectionType
	.s number=noSecProIndex+1
	.i (contractFlag'="STDT") d
	..s contractCode=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),3)
	.else  d
	..s contractCode=contractFlag
	.s $li(dimProValueList,number)=contractCode
	.s $li(dimProSourceValueList,number)=contractFlag
	.s $li(sourceNorDimList,number)="contract"
	.;i monId'=0 d
	..;s monthObj=##class(DHCWL.MKPI.Months).%OpenId(monId1)
	..;s sectionType="D"
	..;if monthObj'="" s sectionType=monthObj.KPIMSectionFlag.SecCode
	..;s $li(sourceNorDimList,noSecProIndex)=sectionType
	q
ResolveKpiDataRecorde(kpiCode,dim,value)
    
	;s kpiSumValue=kpiSumValue+value
	s dimErrorFlag=0
	s splitProFlag=0
	k needCombProValArr
	k needCombProValArrResult
	s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
	s pos=""
	s pos=$o(queryModleMap("$PARAM",kpiId,pos))
	s dimProIndex=""  f  s dimProIndex=$o(kpiRuleMap(kpiCode,"DimPro",dimProIndex)) q:(dimProIndex="")||(dimErrorFlag=1)  d
	.s dimProFullCode=$o(kpiRuleMap(kpiCode,"DimPro",dimProIndex,""))
	.s dimProFullId=kpiRuleMap(kpiCode,"DimPro",dimProIndex,dimProFullCode)
	.s kpiDimId=$p(dimProFullId,"^",1)
	.s dimProId=$p(dimProFullId,"^",2)
	.s proExcCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),6)
	.s dimOrder=$p(dimProFullId,"^",3)
	.s dimDeli=kpiRuleMap(kpiCode,"DimDeli")
	.s needDimId=$p(dim,dimDeli,dimOrder)
	.s dimId=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),2,"")
	.i ($g(queryModleMap("$PARAM",kpiId,pos,dimOrder,dimId,dimProId,"dimProArg"))'="") d
	..s dimProArg=queryModleMap("$PARAM",kpiId,pos,dimOrder,dimId,dimProId,"dimProArg")
	..s needDimId=needDimId_"~"_dimProArg
	.s proValueDeli=$lg(^DHCWL.MKPI.DimPropertyD(dimProId),8,"")
	.i originalDimFlag d
	..s excDimValue=needDimId
	.else  d
	..i ((proValueDeli'="")&&(proValueDeli'=$c(0))) d
	...s $li(dimProSourceValueList,dimProIndex)=needDimId
	...s splitProFlag=1
	...s excDimValue=resolver.GetPropertyValue(kpiCode,dimProFullCode,needDimId)
	...s needCombProValArr(dimProIndex)=excDimValue
	...s needCombProValArr(dimProIndex,"Deli")=proValueDeli
	...s needCombProValArr(dimProIndex,"ProId")=dimProId
	...s needCombProValArr(dimProIndex,"KpiDim")=kpiDimId
	..else  d
	...s excDimValue=resolver.GetPropertyValue(kpiCode,dimProFullCode,needDimId)
	...;.s proExcCode="s excDimValue=$$"_proExcCode_"(needDimId)"
	...;.x proExcCode
	...s $li(dimProValueList,dimProIndex)=excDimValue
	...s $li(dimProSourceValueList,dimProIndex)=needDimId
	if contractFlag="STDT" d
    .s contractCode=contractFlag
    else  d
    .s contractCode=$lg(^DHCWL.MKPI.APPLibraryD(contractFlag),3)
	if (splitProFlag=1) d
	.d ##class(DHCWL.MKPIService.KpiRuleUtil).Combine(.needCombProValArr,.needCombProValArrResult)
	.s needComProValInd=""
	.f  s needComProValInd=$o(needCombProValArrResult(needComProValInd)) q:needComProValInd=""  d
	..s needComProValColInd="" 
	..f  s needComProValColInd=$o(needCombProValArrResult(needComProValInd,needComProValColInd)) q:needComProValColInd=""  d
	...s kpiSumValue=kpiSumValue+value
	...s theDeliedProVal=needCombProValArrResult(needComProValInd,needComProValColInd)
	...s $li(dimProValueList,needComProValColInd)=theDeliedProVal
	...s icr=$I( ^||TEMPDHCWLMKPI("SUM",$j,kpiCode))
	...//modify by wk~20170321~数据按照ID区分
	...//s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList)=$g(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList),0)+value
	...;s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList,dimProSourceValueList)=contractCode
	...//s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList,"IDS")=dimProSourceValueList
	...//s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList,"ISC")=contractCode
	...s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProSourceValueList)=$g(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProSourceValueList),0)+value
	...s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProSourceValueList,"IDS")=dimProValueList
	...s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProSourceValueList,"ISC")=contractCode
	...s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR")=sourceNorDimList
	if (splitProFlag=0) d
	.s kpiSumValue=kpiSumValue+value
	.s icr=$I(^||TEMPDHCWLMKPI("SUM",$j,kpiCode))
	.//modify by wk~20170321~数据按照ID区分
	.//s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList)=$g(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList),0)+value
    .;s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList,dimProSourceValueList)=contractCode
    .//s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList,"IDS")=dimProSourceValueList
	.//s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProValueList,"ISC")=contractCode
    .//s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR")=sourceNorDimList
    .s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProSourceValueList)=$g(^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProSourceValueList),0)+value
    .s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProSourceValueList,"IDS")=dimProValueList
    .s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"LIST",dimProSourceValueList,"ISC")=contractCode
    .s ^||TEMPDHCWLMKPI("SUM",$j,kpiCode,"SOUR")=sourceNorDimList
    q
}

ClassMethod createRealMKPIData(ByRef kpiRullMap, ByRef resovledMonMap, execParam As %Text = "")
{
	n (kpiRullMap,resovledMonMap,execParam)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleExecParam(execParam,.aryExecParam)
	s KPIIdStr=kpiRullMap("$PARAMKPI")
	k exData
	k ^||TEMPREALKPIDATA("TEMP",$j)
	s kpiId2="" f  s kpiId2=$o(resovledMonMap(kpiId2)) q:(kpiId2="")  d
	.s contractFlag="" f  s contractFlag=$o(resovledMonMap(kpiId2,contractFlag)) q:(contractFlag="")  d
	..s monId="" f  s monId=$o(resovledMonMap(kpiId2,contractFlag,monId)) q:(monId="")  d
	...s kpiIdLen=$l(KPIIdStr,",")
	...f lenK=1:1:kpiIdLen  d
	....s kpiId=$p(KPIIdStr,",",lenK)
	....q:kpiId=""
	....s execCode=$listget(^DHCWL.MKPI.MKPID(kpiId),4,"")
	....q:execCode=""
	....s exData(execCode,kpiId)=""
	...s startDate=$li(^DHCWL.MKPI.MonthsD(monId),7)
	...s endDate=$li(^DHCWL.MKPI.MonthsD(monId),4)
	...i startDate'="" s startDate=$zd(startDate,3)
	...i endDate'="" s endDate=$zd(endDate,3)
	...s execCode="" f  s execCode=$o(exData(execCode)) q:(execCode="")  d
	....s runFlag=1    //only run once
	....s kpiId="" f  s kpiId=$o(exData(execCode,kpiId)) q:(kpiId="")  d
	.....s globalFlag=$listget(^DHCWL.MKPI.MKPID(kpiId),13,"N")
	.....s tempKpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	.....i ($d(aryExecParam(execCode))=1) d
	......s execParam=aryExecParam(execCode)
	.....i (execCode["^")  d
	......i ($g(execParam)'="") d
	.......i globalFlag="Y" s execStr="s sc=$$"_execCode_"(startDate,endDate,execParam)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""")"
	.......e  s execStr="s sc=$$"_execCode_"(startDate,endDate,.dataG,execParam)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""","_".dataG)"
	......else  d
	.......i globalFlag="Y" s execStr="s sc=$$"_execCode_"(startDate,endDate)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""")"
	.......e  s execStr="s sc=$$"_execCode_"(startDate,endDate,.dataG)"  ;"d "_execCode_"("""_startDate_""","""_endDate_""","_".dataG)"
	.....e  d
	......i ($g(execParam)'="") d
	.......i globalFlag="Y" s execStr="s sc=##"_execCode_"(startDate,endDate,execParam)" 
	.......e  s execStr="s sc=##"_execCode_"(startDate,endDate,.dataG,execParam)"  
	......else  d
	.......i globalFlag="Y" s execStr="s sc=##"_execCode_"(startDate,endDate)"  
	.......e  s execStr="s sc=##"_execCode_"(startDate,endDate,.dataG)"
	.....i runFlag d
	......i globalFlag="Y" d 
	.......k ^||TEMPDHCWLKPIDATA("S",$j)
	.......k ^TEMPDHCWLKPIDATA("S",$j)
	......e  k dataG
	......s ^||TEMPDHCWL("kpiError",$j,"exeStr")=$g(execStr)
	......x execStr
	......s runFlag=0
	.....s dataNode=$listget(^DHCWL.MKPI.MKPID(kpiId),12,"")
	.....s nodeFlag=1
	.....i (dataNode="")||(dataNode=$c(0)) s nodeFlag=0
	.....i globalFlag="Y" d
	......if ($d(^TEMPDHCWLKPIDATA("S",$j))) d
	.......Merge ^||TEMPDHCWLKPIDATA("S",$j)=^TEMPDHCWLKPIDATA("S",$j)
	.......k ^TEMPDHCWLKPIDATA("S",$j)
	......s dim="" f  s dim=$o(^||TEMPDHCWLKPIDATA("S",$j,dim)) q:dim=""  d
	.......i ((nodeFlag=0)&&(($d(^||TEMPDHCWLKPIDATA("S",$j,dim)))=1)) d   //modify by wk~2018-07-11
	........s ^||TEMPREALKPIDATA("TEMP",$j,kpiId,monId,dim)=$g(^||TEMPDHCWLKPIDATA("S",$j,dim))
	.......i ((nodeFlag=1)&&(($d(^||TEMPDHCWLKPIDATA("S",$j,dim,dataNode)))=1)) d  //modify by wk~2018-07-11
	........s ^||TEMPREALKPIDATA("TEMP",$j,kpiId,monId,dim)=$g(^||TEMPDHCWLKPIDATA("S",$j,dim,dataNode))
	.....e  d
	......s dim="" f  s dim=$o(dataG(dim)) q:dim=""  d
	.......i ((nodeFlag=0)&&(($d(dataG(dim)))=1)) d   //modify by wk~2018-07-11
	........s ^||TEMPREALKPIDATA("TEMP",$j,kpiId,monId,dim)=$g(dataG(dim))
	.......i ((nodeFlag=1)&&(($d(dataG(dim,dataNode)))=1)) d   //modify by wk~2018-07-11
	........s ^||TEMPREALKPIDATA("TEMP",$j,kpiId,monId,dim)=$g(dataG(dim,dataNode))
	.....i globalFlag="Y" k ^||TEMPDHCWLKPIDATA("S",$j)
}

// d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).ResovleKpiRuleWithPosition("RegLocHpNums:$D^Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc,RegLocHpNums:Doc^Loc",.par)

// d ##class(DHCWL.MKPIService.MKPIDataFormatUtil).ResovleKpiRuleWithPosition("RegLocStOpNums",.par)

ClassMethod ResovleKpiRuleWithPosition(kpiRule As %Text, ByRef resovledRulePos)
{
	n (kpiRule,resovledRulePos)
	s kpiDeli=",",kpiDimDeli=":",dimProDeli="^",proDeli="."
	k resovledRulePos
	k tempResovledRulePos
	s kpiSize=$l(kpiRule,kpiDeli)
	for kpiInd=1:1:kpiSize {
		s rule=$p(kpiRule,kpiDeli,kpiInd)
		s kpi=$p(rule,kpiDimDeli,1)
		s kpi=##class(DHCWL.util.StringUtil).Trim(kpi)
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi,"DHCWL.MKPI.MKPI")
		continue:kpiId=""
		s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiId,"DHCWL.MKPI.MKPI")
		s sign=0
		s dimAndPro=$p(rule,kpiDimDeli,2)
		if ((dimAndPro="")||(dimAndPro=$c(0))){
			s dimAndPro=##class(DHCWL.MKPIService.SetKPIData).GetKpiDimByOrder(kpi,dimProDeli)
		}else{
			s dimAndProLen=$l(dimAndPro,"^")
			for i=1:1:dimAndProLen{
				s dimProp=$p(dimAndPro,"^",i)
				continue:dimProp=""
				s firstWord=$Extract(dimProp,1)
				if (firstWord'="$"){
					s sign=1
					q
				}
			}
			//if (sign=0){
				//s dimAndProp=##class(DHCWL.MKPIService.SetKPIData).GetKpiDimByOrder(kpi,dimProDeli)
				//s dimAndPro=dimAndProp_"^"_dimAndPro
			//}
		}
		s proSize=$l(dimAndPro,dimProDeli)
		s normalProNum=0,secProNum=0
		
		for proInd=1:1:proSize {
			s dimRule=$p(dimAndPro,dimProDeli,proInd)
			s kpiDim=$p(dimRule,proDeli,1)
			s kpiDim=##class(DHCWL.util.StringUtil).Trim(kpiDim)
			if ($e(kpiDim,1)="$"){
				s secDimProId=""
				s secDim=$e(kpiDim,2,$l(kpiDim))
				s secDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(secDim,"DHCWL.MKPI.Section")
				continue:secDimId=""
				s secDimObj=##class(DHCWL.MKPI.Section).%OpenId(secDimId)  ;##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(secDimId,"DHCWL.MKPI.Section")
				continue:secDimObj=""
				s secDimCode=secDimObj.SecCode
				s secDimPro=$p(dimRule,proDeli,2)
				s secDimPro=##class(DHCWL.util.StringUtil).Trim(secDimPro)
				if secDimPro="" {
					//未给出就用默认的
					s secDimProId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimDefPro",secDimId,"Y",""))
					if ((secDimProId="")||(secDimProId=$c(0))) {
						s secDimProId=0
					}
				}else{
					s secDimProId=##class(DHCWL.MKPI.SectionProperty).GetIdByCode(secDimId_"||"_secDimPro)
				}
				continue:secDimProId=""
				s secDimProObj=##class(DHCWL.MKPI.SectionProperty).%OpenId(secDimProId)
				if secDimProId=0 {
					s secDimProCode=""
					s secFullCode=secDimCode
				}else {
					continue:secDimProObj=""
					s secDimProCode=secDimProObj.Code    ;##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(secDimProId,"DHCWL.MKPI.SectionProperty")
					s secFullCode=secDimCode_"."_secDimProCode
				}
				q:$d(tempResovledRulePos(kpiCode,secFullCode))
				s resovledRulePos(kpiCode,"DimProCount")=$g(resovledRulePos(kpiCode,"DimProCount"),0)+1
				s showOrder=resovledRulePos(kpiCode,"DimProCount")
				s resovledRulePos(kpiCode,"DimPro-Sec",showOrder,secFullCode)=secDimId_"^"_secDimProId
				s resovledRulePos(kpiCode,"AllDim",showOrder,secFullCode,"Sec")=secDimId_"^"_secDimProId
				//modify by wk.2016-02-23
				;s resovledRulePos(kpiCode,"DimDeli")=","
				s newKpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
				s kpiDimDimId=""
				s kpiDimDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",newKpiId,kpiDimDimId))
				s tempKpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",newKpiId,kpiDimDimId,""))
				q:tempKpiDimId=""
				s kpiDimDeli1=$lg(^DHCWL.MKPI.MKPIDimensionsD(tempKpiDimId),7,",")
				s resovledRulePos(kpiCode,"DimDeli")=kpiDimDeli1
				s tempResovledRulePos(kpiCode,secFullCode)=""
				continue
			}
			s kpiDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi_"||"_kpiDim,"DHCWL.MKPI.MKPIDimensions")
			continue:kpiDimId=""
			s kpiDimObj=##class(DHCWL.MKPI.MKPIDimensions).%OpenId(kpiDimId)  ;##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiDimId,"DHCWL.MKPI.MKPIDimensions")
			continue:kpiDimObj=""
			s kpiDimCode=kpiDimObj.MKPIDimCode
			s kpiDimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
			s tempKpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),7)
			s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
			continue:dimId=""
			s dimPro=$p(dimRule,proDeli,2)
			s dimPro=$p(dimPro,"(",1)
			s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro)
			
			if ((dimPro="")||(dimPro=$c(0))){
				s dimPro=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimId,"Y",""))
			}
			if ((dimPro'="")&&($d(^DHCWL.MKPI.DimPropertyD(dimPro)))){
				 s dimPro=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(dimPro,"DHCWL.MKPI.DimProperty")
				 s dimProId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimPro,"DHCWL.MKPI.DimProperty")
			}else {
				s dimProId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimId_"||"_dimPro,"DHCWL.MKPI.DimProperty")
			}
			continue:dimProId=""
			s dimProObj=##class(DHCWL.MKPI.DimProperty).%OpenId(dimProId)
			continue:dimProObj=""
			s dimProCode=dimProObj.Code  ;##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(dimProId,"DHCWL.MKPI.DimProperty")
			
			s dimFullCode=kpiDimCode_"."_dimProCode
			q:$d(tempResovledRulePos(kpiCode,dimFullCode))
			s resovledRulePos(kpiCode,"DimProCount")=$g(resovledRulePos(kpiCode,"DimProCount"),0)+1
			s showOrder=resovledRulePos(kpiCode,"DimProCount")
			s resovledRulePos(kpiCode,"DimPro",showOrder,dimFullCode)=kpiDimId_"^"_dimProId_"^"_kpiDimOrder
			s resovledRulePos(kpiCode,"AllDim",showOrder,dimFullCode,"Dim")=kpiDimId_"^"_dimProId_"^"_kpiDimOrder
			s resovledRulePos(kpiCode,"DimDeli")=tempKpiDimDeli
			s tempResovledRulePos(kpiCode,dimFullCode)=""
		}
	}
}

}
