Class DHCWL.MKPIService.KpiRuleUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

//d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition("MZDocGhf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc^RegType.Des^RegTime.Desc^$D.Type,MZDocZcf:RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc",.arr)

//d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition("MZDocGhf:$D^$D.Type,MZDocZcf:$D^$D.Type^RegLoc.Loc^RegLoc.LocCode^RegDoc.Doc",.arr)

/*
解析后resovledRulePos的数据结构：
resovledRulePos("COL",kpiId)=kpiColInd
resovledRulePos("COL",kpiId,dimProColInd,proId)=kpiDimId
resovledRulePos("POS",kpiPos)=kpiId
resovledRulePos("POS",kpiPos,dimProPos)=dimProId
resovledRulePos("POS",kpiPos,dimProPos,kpiDimId)=dimProId
resovledRulePos("ID",kpiId,kpiDimId,dimProId)="pro"
*/

//d ##class(DHCWL.MKPIService.KpiRuleUtil).ResovleKpiRuleWithPosition("16",.arr)

/// Creator by lhh
/// Date:2013-08-12
ClassMethod ResovleKpiRuleWithPosition(kpiRule As %Text, ByRef resovledRulePos, mode = "")
{
	n (kpiRule,resovledRulePos,mode)
	s kpiDeli=",",kpiDimDeli=":",dimProDeli="^",proDeli="."
	k resovledRulePos
	s kpiSize=$l(kpiRule,kpiDeli)
	s mode=$zcvt(mode,"U")
	for kpiInd=1:1:kpiSize {
		s rule=$p(kpiRule,kpiDeli,kpiInd)
		s kpi=$p(rule,kpiDimDeli,1)
		s kpi=##class(DHCWL.util.StringUtil).Trim(kpi)
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi,"DHCWL.MKPI.MKPI")
		continue:kpiId=""
		s resovledRulePos("COLSEC",kpiId)=kpiInd
		if '$d(resovledRulePos("KPILIST")) s resovledRulePos("KPILIST")=kpiId
		else  s resovledRulePos("KPILIST")=resovledRulePos("KPILIST")_","_kpiId
		s dimAndPro=$p(rule,kpiDimDeli,2)
		s sign=0
		if ((dimAndPro="")||(dimAndPro=$c(0))){
			s dimAndPro=##class(DHCWL.MKPIService.SetKPIData).GetKpiDimByOrder(kpi,dimProDeli)
		}else{
			s dimAndProLen=$l(dimAndPro,"^")
			for i=1:1:dimAndProLen {
				s dimProp=$p(dimAndPro,"^",i)
				continue:dimProp=""
				s firstWord=$Extract(dimProp,1)
				if (firstWord'="$"){
					s sign=1
					q
				}
			}
			if (mode [ "E"){
			}else{
				if (sign=0){
				s dimAndProp=##class(DHCWL.MKPIService.SetKPIData).GetKpiDimByOrder(kpi,dimProDeli)
				s dimAndPro=dimAndProp_"^"_dimAndPro
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
				s secDim=$e(kpiDim,2,$l(kpiDim))
				s secDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(secDim,"DHCWL.MKPI.Section")
				continue:secDimId=""
				s secDimPro=$p(dimRule,proDeli,2)
				s secDimPro=##class(DHCWL.util.StringUtil).Trim(secDimPro)
				if secDimPro="" {
					//未给出就用默认的
					s secDimProId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimDefPro",secDimId,"Y",""))
					s:((secDimProId="")||(secDimProId=$c(0))) secDimProId=0
				}else{
					s secDimProId=##class(DHCWL.MKPI.SectionProperty).GetIdByCode(secDimId_"||"_secDimPro)
				}
				continue:secDimProId=""
				s secProNum=secProNum+1
				s resovledRulePos("KPISECDIM",kpiId,secProNum,secDimProId)=secDimId
				continue
			}
			s kpiDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi_"||"_kpiDim,"DHCWL.MKPI.MKPIDimensions")
			continue:kpiDimId=""
			s kpiDimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
			s tempKpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),7)
			s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
			s dimPro=$p(dimRule,proDeli,2)
			s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro)
			//add by wz.20-15-3-4.滤掉维度属性参数
			s dimPro=$p(dimPro,"(",1)
			if ((dimPro="")||(dimPro=$c(0))){
				s dimPro=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimId,"Y",""))
			}
			if (($d(^DHCWL.MKPI.DimPropertyD(dimPro)))){
				 s dimPro=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(dimPro,"DHCWL.MKPI.DimProperty")
				 s dimProId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimPro,"DHCWL.MKPI.DimProperty")
			}else {
				s dimProId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimId_"||"_dimPro,"DHCWL.MKPI.DimProperty")
			}
			continue:dimProId=""
			s normalProNum=normalProNum+1
			s resovledRulePos("POS",kpiInd)=kpiId
			s resovledRulePos("POS",kpiInd,normalProNum)=dimProId
			s resovledRulePos("POS",kpiInd,normalProNum,kpiDimId)=""
			s resovledRulePos("ID",kpiId,kpiDimId,dimProId)=""
			s resovledRulePos("KPIDIM",kpiId,kpiDimId,"ORDER")=kpiDimOrder
			s resovledRulePos("KPIDIM",kpiId,kpiDimId,"DELI")=tempKpiDimDeli
		}
	}
	k tempArr
	s kpiPos="",columnInd=0
	f {
		s kpiPos=$o(resovledRulePos("POS",kpiPos))
		q:kpiPos=""
		s proPos=""
		f {
			s proPos=$o(resovledRulePos("POS",kpiPos,proPos))
			q:proPos=""
			s kpiDimId=$o(resovledRulePos("POS",kpiPos,proPos,""))
			s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
			s proId=resovledRulePos("POS",kpiPos,proPos)
			s kpiId=resovledRulePos("POS",kpiPos)
			s dimAndPro=dimId_"||"_proId
			if ('$d(tempArr(dimAndPro))){
				s columnInd=columnInd+1
				s tempArr(dimAndPro)=columnInd
			}
			s kpiDimId=$o(resovledRulePos("POS",kpiPos,proPos,""))
			s resovledRulePos("COL",kpiId)=kpiPos
			s resovledRulePos("COL",kpiId,tempArr(dimAndPro),proId)=kpiDimId
		}
	}
	s resovledRulePos("MAXCOL")=columnInd
}

/// Creator by wz
/// Date:2014-11-20
ClassMethod ResovleKpiRuleWithPosition2(kpiRule As %Text, ByRef resovledRulePos)
{
	n (kpiRule,resovledRulePos)
	s kpiDeli=",",kpiDimDeli=":",dimProDeli="^",proDeli=".", aliasDeli=" As "
	k resovledRulePos
	s kpiSize=$l(kpiRule,kpiDeli)
	for kpiInd=1:1:kpiSize {
		s rule=$p(kpiRule,kpiDeli,kpiInd)
		//add  by wz 2014-11-20
		//s rule=$p(rule,aliasDeli,1)
		
		s kpi=$p(rule,kpiDimDeli,1)
		s kpi=##class(DHCWL.util.StringUtil).Trim(kpi)
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi,"DHCWL.MKPI.MKPI")
		continue:kpiId=""
		if '$d(resovledRulePos("KPILIST")) s resovledRulePos("KPILIST")=kpiId
		else  s resovledRulePos("KPILIST")=resovledRulePos("KPILIST")_","_kpiId
		s dimAndPro=$p(rule,kpiDimDeli,2)
		if ((dimAndPro="")||(dimAndPro=$c(0))){
			s dimAndPro=##class(DHCWL.MKPIService.SetKPIData).GetKpiDimByOrder(kpi,dimProDeli)
			//只有指标编码没有维度和属性的取数规则，那么指标编码后面可能就是属性别名
		}
		s proSize=$l(dimAndPro,dimProDeli)
		s normalProNum=0,secProNum=0
		for proInd=1:1:proSize {
			s dimRule=$p(dimAndPro,dimProDeli,proInd)
			s kpiDim=$p(dimRule,proDeli,1)
			s kpiDim=##class(DHCWL.util.StringUtil).Trim(kpiDim)
			if ($e(kpiDim,1)="$"){
				s secDim=$e(kpiDim,2,$l(kpiDim))
				s secDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(secDim,"DHCWL.MKPI.Section")
				continue:secDimId=""
				s secDimPro=$p(dimRule,proDeli,2)
				s secDimPro=##class(DHCWL.util.StringUtil).Trim(secDimPro)
				if secDimPro="" {
					//未给出就用默认的
					s secDimProId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimDefPro",secDimId,"Y",""))
					s:((secDimProId="")||(secDimProId=$c(0))) secDimProId=0
				}else{
					s secDimProId=##class(DHCWL.MKPI.SectionProperty).GetIdByCode(secDimId_"||"_secDimPro)
				}
				continue:secDimProId=""
				s secProNum=secProNum+1
				s resovledRulePos("KPISECDIM",kpiId,secProNum,secDimProId)=secDimId
				continue
			}
			s kpiDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi_"||"_kpiDim,"DHCWL.MKPI.MKPIDimensions")
			continue:kpiDimId=""
			s kpiDimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6)
			s tempKpiDimDeli=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),7)
			s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
			
			s tmpDimRule=dimRule
			s dimRule=$p(tmpDimRule,aliasDeli,1)
			s dimAlias=$p(tmpDimRule,aliasDeli,2)
			
			s dimPro=$p(dimRule,proDeli,2)
			s dimPro=##class(DHCWL.util.StringUtil).Trim(dimPro)
			if ((dimPro="")||(dimPro=$c(0))){
				s dimPro=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimId,"Y",""))
			}
			if (($d(^DHCWL.MKPI.DimPropertyD(dimPro)))){
				 s dimPro=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(dimPro,"DHCWL.MKPI.DimProperty")
				 s dimProId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimPro,"DHCWL.MKPI.DimProperty")
				 s pro=$p(dimPro,"||",2)
				 s kpiDimProCode=kpiDim_"."_pro
			}else {
				s dimProId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimId_"||"_dimPro,"DHCWL.MKPI.DimProperty")
				s kpiDimProCode=dimRule
			}
			continue:dimProId=""
			
			//add by wz.2014-11-20
			s dimAlias=##class(DHCWL.util.StringUtil).Trim(dimAlias)
			//s:$g(dimAlias)="" dimAlias=dimProId
			//指标维度+维度属性的code做默认的别名
			s:$g(dimAlias)="" dimAlias=kpiDimProCode
			
			s resovledRulePos("DIMPROALIAS",kpiId,kpiDimId,dimProId)=dimAlias
			
			s normalProNum=normalProNum+1
			s resovledRulePos("POS",kpiInd)=kpiId
			s resovledRulePos("POS",kpiInd,normalProNum)=dimProId
			s resovledRulePos("POS",kpiInd,normalProNum,kpiDimId)=""
			s resovledRulePos("ID",kpiId,kpiDimId,dimProId)=""
			s resovledRulePos("KPIDIM",kpiId,kpiDimId,"ORDER")=kpiDimOrder
			s resovledRulePos("KPIDIM",kpiId,kpiDimId,"DELI")=tempKpiDimDeli
		}
	}
	k tempArr
	s kpiPos="",columnInd=0
	s myDebug=1
	f {
		s kpiPos=$o(resovledRulePos("POS",kpiPos))
		q:kpiPos=""
		s proPos=""
		f {
			s proPos=$o(resovledRulePos("POS",kpiPos,proPos))
			q:proPos=""
			s kpiDimId=$o(resovledRulePos("POS",kpiPos,proPos,""))
			s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5)
			s proId=resovledRulePos("POS",kpiPos,proPos)
			s kpiId=resovledRulePos("POS",kpiPos)
			
			if myDebug=0 {
				s dimAndPro=dimId_"||"_proId
				if ('$d(tempArr(dimAndPro))){
					s columnInd=columnInd+1
					s tempArr(dimAndPro)=columnInd
				}
			}else {
				//add by wz.2014-11-20
				s dimproAlias=resovledRulePos("DIMPROALIAS",kpiId,kpiDimId,proId)
				if ('$d(tempArr(dimproAlias))){
					s columnInd=columnInd+1
					s tempArr(dimproAlias)=columnInd
				}
			}
			
			s kpiDimId=$o(resovledRulePos("POS",kpiPos,proPos,""))
			s resovledRulePos("COL",kpiId)=kpiPos
			if myDebug=0 {
				s resovledRulePos("COL",kpiId,tempArr(dimAndPro),proId)=kpiDimId
			}else{
				s resovledRulePos("COL",kpiId,tempArr(dimproAlias),proId)=kpiDimId
				s resovledRulePos("COLInx",tempArr(dimproAlias),kpiId,proId)=kpiDimId
			}
		}
	}
	s resovledRulePos("MAXCOL")=columnInd
}

/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KpiRuleUtil","KpiQueryWithSplitColumn","2012-11-3","2012-11-3",,"MZDocGhf,MZDocZcf","MZDocGhf:([!{RegLoc.Loc} \[ (西院)] && {RegLoc.Loc}\[ 内科),MZDocZcf:([!{RegLoc.Loc} \[ (西院)] && {RegLoc.Loc} \[ 内科)",,"PP")
Query KpiQueryWithSplitColumn(startDate As %String, endDate As %String, dateType As %String, kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Query(ROWSPEC = "month:%String,kpi:%String,dimIdCol1:%String,dimIdCol2:%String,dimIdCol3:%String,dimIdCol4:%String,dimIdCol5:%String,dimIdCol6:%String,dimIdCol7:%String,dimIdCol8:%String,dimIdCol9:%String,dimIdCol10:%String,dimIdCol11:%String,dimIdCol12:%String,dimIdCol13:%String,dimIdCol14:%String,dimIdCol15:%String,dimIdCol16:%String,dimDesCol1:%String,dimDesCol2:%String,dimDesCol3:%String,dimDesCol4:%String,dimDesCol5:%String,dimDesCol6:%String,dimDesCol7:%String,dimDesCol8:%String,dimDesCol9:%String,dimDesCol10:%String,dimDesCol11:%String,dimDesCol12:%String,dimDesCol13:%String,dimDesCol14:%String,dimDesCol15:%String,dimDesCol16:%String,kpiValueCol1:%Float,kpiValueCol2:%Float,kpiValueCol3:%Float,kpiValueCol4:%Float,kpiValueCol5:%Float,kpiValueCol6:%Float,kpiValueCol7:%Float,kpiValueCol8:%Float,kpiValueCol9:%Float,kpiValueCol10:%Float,kpiValueCol11:%Float,kpiValueCol12:%Float,kpiValueCol13:%Float,kpiValueCol14:%Float,kpiValueCol15:%Float,kpiValueCol16:%Float,kpiValueCol7:%Float,kpiValueCol18:%Float,kpiValueCol19:%Float,kpiValueCol20:%Float,kpiValueCol21:%Float,kpiValueCol22:%Float,kpiValueCol23:%Float,kpiValueCol24:%Float,kpiValueCol25:%Float,kpiValueCol26:%Float,kpiValueCol27:%Float,kpiValueCol28:%Float,kpiValueCol29:%Float,kpiValueCol30:%Float") [ SqlProc ]
{
}

ClassMethod KpiQueryWithSplitColumnExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String, kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Status
{
	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	s MAXDIMDESCOL=16,MAXDIMIDCOL=16,MONDELI=";",KPIDELI=";",MAXMONTHCOL=1,MAXSTARTCOL=1
	s dimIdStartInd=MAXSTARTCOL+MAXMONTHCOL+1,dimDesStartInd=dimIdStartInd+MAXDIMDESCOL,kpiValueStartInd=dimDesStartInd+MAXDIMIDCOL
	s ^temp("lhhTestRowNums")=0
	d ##class(DHCWL.MKPIService.KpiFilter).ResovleFilterRule(filterRule,.filterTree)
	d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpiRule,mode,.resovled)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	d ..ResovleKpiRuleWithPosition(kpiRule,.resovledRuleArr)
 	i $g(endDate)="" s endDate=$g(startDate)
 	s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(dateType))
 	q:monthId="" $$$OK
 	k ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
 	s kpiIdList=$g(resovledRuleArr("KPILIST"))
 	d ##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData(monthId,kpiIdList,mode,contract) ;..GetSrcKPIData(monthId,kpiIdList,mode,contract)
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("G",$j,monId)) q:monId=""  d
 	.s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId)) q:kpiId=""  d
 	..s dimsId="" f  s dimsId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dimsId)) q:dimsId=""  d
 	...s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId)=^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dimsId)
 	k ^TEMPDHCWLKPIDATA("G",$j)
 	s startTime=$p($h,",",2)
 	s noFilterFlag=1
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId)) q:monId=""  d
 	.s dimsId="" f  s dimsId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId)) q:dimsId=""  d
 	..s kpiIdList=""
 	..s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId)) q:kpiId=""  d
 	...s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
 	...s filterFlag=$d(filterTree(kpiCode))
 	...s ^temp("lhhTestRowNums")=$g(^temp("lhhTestRowNums"))+1
 	...i (filterFlag'=0) d
 	....s noFilterFlag=0
 	....s filterInd="" f  s filterInd=$o(filterTree(kpiCode,filterInd)) q:filterInd=""  d
 	.....q:+filterInd=0
 	.....s filterResultFlag=##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,"",dimsId,filterTree(kpiCode,filterInd))
 	.....if filterResultFlag d
 	......s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
 	.......s resovledDim=##class(DHCWL.MKPIService.SetKPIData).SetDimValue(kpiId,position,dimsId,.resovled)
 	.......s ^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId,position)="",^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId))+(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId))
 	...e  d
 	....s position="" f  s position=$o(resovled("$PARAM",kpiId,position)) q:position=""  d
 	.....s resovledDim=##class(DHCWL.MKPIService.SetKPIData).SetDimValue(kpiId,position,dimsId,.resovled)
 	.....s ^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId,position)="",^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId)=$g(^TEMPDHCWLKPIDATA("G",$j,monId,resovledDim,kpiId))+(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimsId,kpiId))
 	k ^TEMPDHCWLKPIDATA("ResolvedNodeSession",$j),^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("G",$j,monId)) q:monId=""  d
 	.s monId2=$p(monId,"||",1),conType=$p(monId,"||",2)
 	.s dimsId="" f  s dimsId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,dimsId)) q:dimsId=""  d
 	..s dimCol="",dimDesCol="",kpiValCol="",excDimValue=""
 	..s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)) q:kpiId=""  d
 	...s resovledSecProList="",kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
 	...;s rowList=$LB()
 	...k needCombProValArr
 	...i (($d(resovledRuleArr("KPISECDIM",kpiId)))&&(monId2)) d
 	....s secResProValue=""
 	....s secProPos="" f  s secProPos=$o(resovledRuleArr("KPISECDIM",kpiId,secProPos)) q:secProPos=""  d
 	.....s secProId=$O(resovledRuleArr("KPISECDIM",kpiId,secProPos,""))
 	.....if secProId=0 d
 	......s secResProValue=$li(^DHCWL.MKPI.MonthsD(monId2),3)
 	.....else  d
 	......s proExcStr=$lg(^DHCWL.MKPI.SectionPropertyD(secProId),5,"")
 	......q:proExcStr=""
 	......s proExcStr="s secResProValue=$$"_proExcStr_"(monId2)"
 	......x proExcStr
 	.....i resovledSecProList="" s resovledSecProList=secResProValue
 	.....e  s resovledSecProList=resovledSecProList_MONDELI_secResProValue
 	...e  d
 	....i monId2=0 d
 	.....s resovledSecProList="0"
 	....e  d
 	.....s resovledSecProList=$li(^DHCWL.MKPI.MonthsD(monId2),3)
 	...i conType'="" d
 	....s contractTypeName=$lg(^DHCWL.MKPI.APPLibraryD(conType),4),contractTypeCode=$lg(^DHCWL.MKPI.APPLibraryD(conType),3)  ;$case(tempConType,"PP":" 上期","SL":" 同期","CM":" 本月累计","CY":" 本年累计",:"")
 	....s resovledSecProList=resovledSecProList_contractTypeName
 	...s canOutputFlag=0,colInd="" f  s colInd=$o(resovledRuleArr("COL",kpiId,colInd)) q:colInd=""  d
 	....s canOutputFlag=1
 	....s kpiPos=resovledRuleArr("COL",kpiId)
 	....s proId=$o(resovledRuleArr("COL",kpiId,colInd,""))
 	....s kpiDimId=resovledRuleArr("COL",kpiId,colInd,proId)
 	....s dimOrder=resovledRuleArr("KPIDIM",kpiId,kpiDimId,"ORDER")
 	....s dimDeli=resovledRuleArr("KPIDIM",kpiId,kpiDimId,"DELI")
 	....s needDimId=$p(dimsId,dimDeli,dimOrder)
 	....s kpiPos=resovledRuleArr("COL",kpiId)
 	....s proExcCode=$lg(^DHCWL.MKPI.DimPropertyD(proId),6)
 	....s proValueDeli=$lg(^DHCWL.MKPI.DimPropertyD(proId),8,"")
 	....s excDimValue="" ;..ExcuteCode(proExcCode,needDimId)
 	....s proExcCode="s excDimValue=$$"_proExcCode_"(needDimId)"
 	....x proExcCode
 	....i ((proValueDeli'="")&&(proValueDeli'=$c(0))) d
 	.....s needCombProValArr(colInd)=excDimValue,needCombProValArr(colInd,"Deli")=proValueDeli,needCombProValArr(colInd,"ProId")=proId,needCombProValArr(colInd,"KpiDim")=kpiDimId
 	....e  d
 	.....;s $list(rowList,dimIdStartInd+colInd)=needDimId
 	.....;s $list(rowList,dimDesStartInd+colInd)=excDimValue
 	.....s $p(dimCol,",",colInd)=needDimId
 	.....s $p(dimDesCol,",",colInd)=excDimValue
 	.....i $p(dimCol,",",MAXDIMIDCOL)="" s $p(dimCol,",",MAXDIMIDCOL)=""
 	.....i $p(dimDesCol,",",MAXDIMDESCOL)="" s $p(dimDesCol,",",MAXDIMDESCOL)=""
 	...q:(canOutputFlag=0)
 	...d ..Combine(.needCombProValArr,.needCombProValArrResult)
 	...s needComProValInd=""
 	...if $d(needCombProValArrResult) s needComProValInd=$o(needCombProValArrResult(needComProValInd))
 	...if needComProValInd  d
 	....s onlyResovledProValue=""
 	....s needComProValInd="" f  s needComProValInd=$o(needCombProValArrResult(needComProValInd)) q:needComProValInd=""  d
 	.....s needComProValColInd="" f  s needComProValColInd=$o(needCombProValArrResult(needComProValInd,needComProValColInd)) q:needComProValColInd=""  d
 	......s theDeliedProVal=needCombProValArrResult(needComProValInd,needComProValColInd)
 	......s $p(dimDesCol,",",needComProValColInd)=theDeliedProVal
 	......s columnProId=needCombProValArr(needComProValColInd,"ProId"),columnKpiDim=needCombProValArr(needComProValColInd,"KpiDim")
 	......s columnDimorder=resovledRuleArr("KPIDIM",kpiId,columnKpiDim,"ORDER"),columnDimDeli=resovledRuleArr("KPIDIM",kpiId,columnKpiDim,"DELI")
 	......s $p(onlyResovledProValue,columnDimDeli,columnDimorder)=theDeliedProVal
 	.....s filterFlag=$d(filterTree(kpiCode))
 	.....i filterFlag'=0 d
 	......s filterInd="" f  s filterInd=$o(filterTree(kpiCode,filterInd)) q:filterInd=""  d
 	.......q:+filterInd=0
 	.......if (##class(DHCWL.MKPIService.KpiFilter).PostVisitTree(kpiCode,"",onlyResovledProValue,filterTree(kpiCode,filterInd),1)) d
 	........s:resovledSecProList'="" ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,resovledSecProList,dimDesCol,kpiId,kpiPos)=dimCol
 	........s:resovledSecProList'="" ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,resovledSecProList,dimDesCol,kpiId)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,resovledSecProList,dimDesCol,kpiId))+^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)
 	........s ^temp("lhhTestRowNums")=$g(^temp("lhhTestRowNums"))+1
 	.....e  d
 	......s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,resovledSecProList,dimDesCol,kpiId,kpiPos)=dimCol
 	......s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,resovledSecProList,dimDesCol,kpiId)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,resovledSecProList,dimDesCol,kpiId))+^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)
 	......s ^temp("lhhTestRowNums")=$g(^temp("lhhTestRowNums"))+1
 	...e  d
 	....s ^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,resovledSecProList,dimDesCol,kpiId,kpiPos)=dimCol,^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,resovledSecProList,dimDesCol,kpiId)=$g(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,resovledSecProList,dimDesCol,kpiId))+^TEMPDHCWLKPIDATA("G",$j,monId,dimsId,kpiId)
 	s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId)) q:monId=""  d
 	.s dimDesCol="" f  s dimDesCol=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol)) q:dimDesCol=""  d
 	..s kpiValCol="",kpiIdList="",dimCol=""
 	..s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId)) q:kpiId=""  d
 	...i kpiIdList="" s kpiIdList=kpiId
 	...e  s kpiIdList=kpiIdList_KPIDELI_kpiId
 	...s kpiPos=$o(^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId,""))
 	...s dimCol=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId,kpiPos)
 	...s $p(kpiValCol,",",kpiPos)=^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j,monId,dimDesCol,kpiId)
 	..s tempResovleCol=monId_","_kpiIdList_","_dimCol_","_dimDesCol_","_kpiValCol
 	..;s tempResovleColList=$LFS(tempResovleCol,",")	;P5版本不支持LFS，使用下面方法代替
 	..s tempResovleColList=##class(DHCWL.util.StringUtil).ListFromString(tempResovleCol,",")	
 	..s ^CacheTemp(repid,ind)=tempResovleColList
 	..s ind=ind+1
 	s endTime=$p($h,",",2)
 	s ^temp("lhhTestTime")=(endTime-startTime)
 	k ^TEMPDHCWLKPIDATA("G",$j),^TEMPDHCWLKPIDATA("TEMPKPIDATA",$j)
	Quit $$$OK
}

ClassMethod ExcuteCode(excStr, para) As %String
{
	n (excStr,para)
	q:excStr="" ""
	s temp22=""
	s exeStr="s temp22=$$"_excStr_"("""_para_""")"
	x exeStr
	q temp22
}

ClassMethod KpiQueryWithSplitColumnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = KpiQueryWithSplitColumnExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod KpiQueryWithSplitColumnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = KpiQueryWithSplitColumnExecute ]
{
	n (AtEnd,qHandle,Row)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*
s src(1)="a,b,c",src(1,"Deli")=",",src(2)="e,f",src(2,"Deli")=",",src(3)="g,h,i",src(3,"Deli")=","
d ##class(DHCWL.MKPIService.KpiRuleUtil).Combine(.src,.result)
*/
ClassMethod Combine(ByRef srcArr, ByRef result)
{
	n (srcArr,result)
	;s srcArr(1)="a,b,c",srcArr(1,"Deli")=",",srcArr(2)="e,f",srcArr(2,"Deli")=",",srcArr(3)="g,h,i",srcArr(3,"Deli")=","
	k firstCombArrResult,srcInd
	s colInd="",num=0
	f {
		s colInd=$o(srcArr(colInd))
		q:colInd=""
		s srcInd(colInd)="",num=num+1
		s srcStr=srcArr(colInd),deli=srcArr(colInd,"Deli")
		k eleStrArr,tempFlagArr,eleResult
		f j=$l(srcStr,deli):-1:1 {
			s eleStrArr(j)=$p(srcStr,deli,j)
		}
		s curResultNum=0
		d ..CombinePri(.eleStrArr,$l(srcStr,deli),1,1,1,.eleResult,.tempFlagArr,.curResultNum)
		m firstCombArrResult(colInd)=eleResult
	}
	s resultNum=0
	d ..CombineBacker(.firstCombArrResult,.srcInd,1,num,1,0,.result,.flagArr,.resultNum)
}

//对没一个组必须选定一个元素，计算一共有多少种组合情况

ClassMethod CombineBacker(ByRef src, ByRef srcInd, perBackerNeedChoice As %Integer, needChoiceNum As %Integer, curChoiceNum As %Integer, curInd As %Integer, ByRef result, ByRef tempFlag, ByRef resultNums As %Integer)
{
	n (src,srcInd,needChoiceNum,perBackerNeedChoice,curChoiceNum,curInd,result,tempFlag,resultNums)
	if (curChoiceNum<=needChoiceNum){
		s ind=curInd
		f {
			s ind=$o(srcInd(ind))
			q:ind=""
			if ('$d(tempFlag(ind))) s start=1
			else  s start=tempFlag(ind)
			s end=$o(src(ind,""),-1)
			s tempNum=0
			f i=1:1:end {
				if (($d(tempFlag(ind,i)))&&(tempFlag(ind,i))){
					continue
				}
				s tempFlag(ind,i)=1
				if (needChoiceNum=curChoiceNum){
					s tempInd="",resultNums=resultNums+1
					f {
						s tempInd=$o(srcInd(tempInd))
						q:tempInd=""
						s tempInd2=""
						f {
							s tempInd2=$o(tempFlag(tempInd,tempInd2))
							q:tempInd2=""
							continue:tempFlag(tempInd,tempInd2)=0
							s result(resultNums,tempInd)=src(tempInd,tempInd2)
						}
					}
				}
				s tempFlag(ind)=i+1
				d ..CombineBacker(.src,.srcInd,perBackerNeedChoice,needChoiceNum,curChoiceNum+1,ind,.result,.tempFlag,.resultNums)
				s tempFlag(ind,i)=0
			}
			
		}
	}
}

/*
给定一组数据，共N个，在这组数据中选中K，计算出所有的组合结果
s arr(1)="a",arr(2)="b",arr(3)="c",arr(4)="d",arr(5)="e"
d ##class(DHCWL.MKPIService.KpiRuleUtil).CombinePri(.arr,6,3,1,1,.result,.tempFlagArr)
*/
ClassMethod CombinePri(ByRef arr, arrLen As %Integer, choiceNums As %Integer, curInd As %Integer, curChoices As %Integer, ByRef result, ByRef tempFlagArr, ByRef curResultNum As %Integer)
{
	n (arr,arrLen,choiceNums,curInd,curChoices,result,tempFlagArr,curResultNum)
	;s arr(1)="a",arr(2)="b",arr(3)="c",arr(4)="d",arr(5)="e",arr(6)="f"
	if (curChoices<=choiceNums){
		for i=curInd:1:arrLen {
			continue:(($d(tempFlagArr(i)))&&(tempFlagArr(i)))
			s tempFlagArr(i)=1
			if (curChoices=choiceNums){
				s tempResult=""
				s curResultNum=curResultNum+1
				s ele="" 
				f j=1:1:arrLen {
					q:'$d(tempFlagArr(j))
					 continue:(tempFlagArr(j)=0)
					 if tempResult="" s tempResult=arr(j)
					 else  s tempResult=tempResult_","_arr(j)
				}
				s result(curResultNum)=tempResult
			}
			d ..CombinePri(.arr,arrLen,choiceNums,i,curChoices+1,.result,.tempFlagArr,.curResultNum)
			s tempFlagArr(i)=0
		}
	}
	q
}

/*
	resovledRuleArr("COL",kpiId)=kpiColInd
	resovledRuleArr("COL",kpiId,dimProColInd,proId)=kpiDimId
	resovledRuleArr("POS",kpiPos)=kpiId
	resovledRuleArr("POS",kpiPos,dimProPos)=dimProId
	resovledRuleArr("POS",kpiPos,dimProPos,kpiDimId)=""					
	resovledRuleArr("ID", kpiId,kpiDimId,dimProId)="pro"
	
	mapRuleArr("PROPOS",kpiID,kpiDimId,dimProId)=dimProPos
	mapRuleArr("DIMPOS",kpiID,kpiDimId)=dimPos
*/
/// Creator：     	WZ
/// CreatDate：    	2015-04-08
/// Description: 	根据取数规则计算维度及维度属性的输出顺序
/// Table：       
/// Input：       	resovledRuleArr：见下面数组的注解
/// 					
/// Output：      	mapRuleArr:保存维度及维度属性的输出顺序
/// Return：      
ClassMethod ResovleKpiRuleMap(ByRef resovledRuleArr, ByRef mapRuleArr)
{
	n (resovledRuleArr,mapRuleArr)
	s kpiPos=""
	f {
		s kpiPos=$o(resovledRuleArr("POS",kpiPos))
		q:kpiPos=""
		s kpiID=resovledRuleArr("POS",kpiPos)
		S dimPos=1
		s dimProPos=""
		f {

			s dimProPos=$o(resovledRuleArr("POS",kpiPos,dimProPos))
			q:dimProPos=""
			s dimProId=resovledRuleArr("POS",kpiPos,dimProPos)
			s kpiDimId=""
			f {
				s kpiDimId=$o(resovledRuleArr("POS",kpiPos,dimProPos,kpiDimId))	
				q:kpiDimId=""
				
				s mapRuleArr("PROPOS",kpiID,kpiDimId,dimProId)=dimProPos
				if '$d(mapRuleArr("DIMPOS",kpiID,kpiDimId)) {
					S mapRuleArr("DIMPOS",kpiID,kpiDimId)=dimPos
					s dimPos=dimPos+1
				}
			}
			
		}	
	}
}

/*
	resolve("$PARAM",kpiId,kpiPos)=1
	resolve("$PARAM",kpiId,kpiPos,kpiDimOrder,baseDimID)=1							
	resolve("$PARAM",kpiId,kpiPos,kpiDimOrder,baseDimID,dimProId)=""	

	mapRuleArr("DIMPOS",kpiId,kpiDimId)=dimPos
	mapRuleArr("PROPOS",kpiId,kpiDimId,dimProId)=dimProPos
*/
/// Creator：     	WZ
/// CreatDate：    	2015-04-08
/// Description: 	转换维度及维度属性的输出顺序
/// Table：       
/// Input：       	kpiId：			KPIID
/// 					dimList:		要转换的维度ID
/// 					resolvedDimList:要转换的维度描述
/// 					kpiPos:			指标的序号
/// 					resolve：		见下面数组的注解
/// 					mapRuleArr:		维度及维度属性的输出顺序
/// 					dimIDList:		转换后的维度ID
/// 					dimDescList:	转换后的维度描述
/// Output：      	
/// Return： 
ClassMethod transDimPos(kpiId As %String, dimList As %String, resolvedDimList As %String, kpiPos As %Integer, ByRef resolve, ByRef mapRuleArr, ByRef dimIDList, ByRef dimDescList)
{
	n (kpiId,dimList,resolvedDimList,kpiPos,resolve,mapRuleArr,dimIDList,dimDescList)
	s $zt="transError"
	s dimIDList=""
	s dimDescList=""
	
	s oldProPos=1
	s kpiDimOrder=""
	f {
		s kpiDimOrder=$o(resolve("$PARAM",kpiId,kpiPos,kpiDimOrder))
		q:kpiDimOrder=""
		s baseDimID="" 
		f {
			s baseDimID=$o(resolve("$PARAM",kpiId,kpiPos,kpiDimOrder,baseDimID))
			q:baseDimID=""
			continue:resolve("$PARAM",kpiId,kpiPos,kpiDimOrder,baseDimID)'=1	//add by wz.2015-11-27
			//s MKPIDimCode=$p(resolve("$DEF",kpiId),"^",kpiDimOrder)
			s kpiDimId="" 
			f {
				s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,baseDimID,kpiDimId))
				q:kpiDimId=""
				s MKPIDimOrder=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),6,1)
				q:kpiDimOrder=MKPIDimOrder
			}
			if kpiDimId="" goto transError
			//s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,MKPIDimCode,""))
			s newDimPos=mapRuleArr("DIMPOS",kpiId,kpiDimId)
			
			s dimValue=$p(dimList,",",kpiDimOrder)
			s $p(dimIDList,",",newDimPos)=dimValue
			
			s dimProId=""
			f {
				s dimProId=$o(resolve("$PARAM",kpiId,kpiPos,kpiDimOrder,baseDimID,dimProId))
				q:dimProId=""
				s newDimProPos=mapRuleArr("PROPOS",kpiId,kpiDimId,dimProId)
				s dimDesc=$p(resolvedDimList,",",oldProPos)
				s $p(dimDescList,",",newDimProPos)=dimDesc
				s oldProPos=oldProPos+1
			}
		}
	}
	q
	
transError
	s dimIDList=""
	s dimDescList=""
	q
}

}
