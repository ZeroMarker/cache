/// 名称: DHCMed.INFService.InfDataStatistic
/// 描述: 院感数据统计
/// 编写者：XQY
/// 编写日期: 2010-09-28
Class DHCMed.INFService.InfDataStatistic Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     XQY
/// CreatDate：   2010-09-30
/// Description:  统计某段时间内院感报告的感染部位的情况
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDataStatistic","QryRepByTypeMore","1","2009-07-01","2010-10-14","","")          
/// Return：
Query QryRepByTypeMore(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "LocDesc:%String,dischNum:%String,ctinf:%String,ctinfl:%String,posDesc:%String,posSum:%String,posInfl:%String")
{
}

ClassMethod QryRepByTypeMoreExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
    q:TypeCode="" $$$OK
    q:DateFrom="" $$$OK
    q:DateTo="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    q:+DateFrom>+DateTo $$$OK
    s (sumDisch,sumCtinf,sumPosinf)=0
    //获取条件时间段内报告rowid
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc		//各报告的科室号
	
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..s sumID=""	
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	
	...s ^CacheTemp("StaHDMInfection", $j,PatLoc,"ctinf")=+$g(^CacheTemp("StaHDMInfection", $j,PatLoc,"ctinf"))+1		//不同感染地点（社区、院内）某科室感染数总量
	...s posID=""
	...s disID=""
	...f  s posID=$o(^DHCMed.INF.RepPosI("InfRepDr",sumID,posID)) q:posID=""  d
	....s objPos=##class(DHCMed.INF.RepPos).%OpenId(posID)
	....q:'$IsObject(objPos)
	....s posRowid=objPos.InfPosCode    //是感染部位的rowid
	....S disID=objPos.InfDiagDR		//指向疾病字典rowid
	....s ^CacheTemp("StaHDMInfection", $j,PatLoc, "posid", posRowid)=posRowid
	....s ^CacheTemp("StaHDMInfection", $j,PatLoc, "possum", posRowid)=+$g(^CacheTemp("StaHDMInfection", $j,PatLoc, "possum", posRowid))+1		//某科室某部位感染数量
    s getLoc=""
    f  s getLoc=$o(^CacheTemp("StaHDMInfection", $j,getLoc)) q:getLoc=""  d
    .s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(getLoc)
    .q:'$IsObject(objLoc)
    .s LocDesc=objLoc.Descs
    
	.//获取某段时间内科室出院人数
    .s date1=DateFrom
    .s date2=DateTo
    .s parctloc=getLoc
    .s tmpNum=0
 	.f curdate=date1:1:date2  d
 	..s admrowid=0 f  s admrowid=$o(^PAADMi("DischDate",curdate,admrowid)) q:(admrowid="")  d
 	...q:(admrowid="")
 	...s admrowid=+admrowid
 	...s admtype=$p(^PAADM(admrowid),"^",2)
 	...s admtype=$g(admtype)
 	...q:(admtype'="I")
	...s DepCodeDR=$p($g(^PAADM(admrowid)),"^",4)
 	...q:(parctloc'="")&(parctloc'=DepCodeDR)
 	...q:(DepCodeDR="")	
	...s tmpNum=tmpNum+1		//某科室出院人数
	
 	.s ctinf=+$g(^CacheTemp("StaHDMInfection", $j,getLoc,"ctinf"))
 	.s:tmpNum=0 ctinfl=""
    .s:tmpNum'=0 ctinfl=$tr($fn((ctinf*100)/tmpNum,"+",4),"+","")_"%"	//某科室院内感染率
    .s dischNum=tmpNum
    .s sumDisch=sumDisch+tmpNum		//全院出院人数
    .s sumCtinf=sumCtinf+ctinf		//全院院内感染总人数
    .s getPos=""
    .f  s getPos=$o(^CacheTemp("StaHDMInfection", $j, getLoc, "posid", getPos)) q:getPos=""  d
    ..s posObj=##class(DHCMed.INF.InfPosition).%OpenId(getPos)
    ..q:'$IsObject(posObj)
    ..s posDesc=posObj.InfPosition		//感染部位名称
    ..s posSum=+$g(^CacheTemp("StaHDMInfection", $j, getLoc, "possum", getPos))	//某科室某部位感染人数
    ..s posInfl=$tr($fn((posSum*100)/ctinf,"+",4),"+","")_"%"		//某部位感染率
    ..s sumPosinf=sumPosinf+posSum		//全院有部位感染的人数
	..s Data=$lb(LocDesc,dischNum,ctinf,ctinfl,posDesc,posSum,posInfl)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	k ^CacheTemp("StaHDMInfection",$j)
	s sumCtinfl="0%"
	s sumPosinfl="0%"
	s:sumDisch'=0 sumCtinfl=$tr($fn((sumCtinf*100)/sumDisch,"+",4),"+","")_"%"
	s:sumCtinf'=0 sumPosinfl=$tr($fn((sumPosinf*100)/sumCtinf,"+",4),"+","")_"%"
	s Data=$lb("合计:",sumDisch,sumCtinf,sumCtinfl,"全部",sumPosinf,sumPosinfl)
 	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1 
	Quit $$$OK
}

ClassMethod QryRepByTypeMoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepByTypeMoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepByTypeMoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepByTypeMoreExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     XQY
/// CreatDate：   2010-10-13
/// Description:  返回分部位统计图表数据
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDataStatistic","GetChartData","1","2010-10-01","2010-10-18","","")          
/// Return：
Query GetChartData(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "posDesc:%String,posSum:%String,posInfl:%String")
{
}

ClassMethod GetChartDataExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
    q:TypeCode="" $$$OK
    q:DateFrom="" $$$OK
    q:DateTo="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    q:+DateFrom>+DateTo $$$OK
    
    //获取条件时间段内报告rowid
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc		//各报告的科室号
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..s sumID=""	
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	
	...s posID=""
	...f  s posID=$o(^DHCMed.INF.RepPosI("InfRepDr",sumID,posID)) q:posID=""  d
	....s objPos=##class(DHCMed.INF.RepPos).%OpenId(posID)
	....q:'$IsObject(objPos)
	....s posRowid=objPos.InfPosCode    //是感染部位的rowid
	....s ^CacheTemp("StaHDMInfection", $j, "infSum")=+$g(^CacheTemp("StaHDMInfection", $j, "infSum"))+1		//（社区、院内）感染总人数
	....s ^CacheTemp("PosData", $j, posRowid)=posRowid
	....s ^CacheTemp("PosSum", $j, posRowid, "posCount")=+$g(^CacheTemp("PosSum", $j, posRowid, "posCount"))+1		//记录某个部位的感染总人数
	
 	s ctinf=+$g(^CacheTemp("StaHDMInfection", $j, "infSum"))		
    s getPos=""
    f  s getPos=$o(^CacheTemp("PosData", $j, getPos)) q:getPos=""  d
    .s posObj=##class(DHCMed.INF.InfPosition).%OpenId(getPos)
    .q:'$IsObject(posObj)
    .s posDesc=posObj.InfPosition		//感染部位名称
    .s posSum=""
    .s posSum=+$g(^CacheTemp("PosSum", $j, getPos, "posCount"))		//某部位感染总数
    .//s posInfl=$tr($fn((posSum*100)/ctinf,"+",4),"+","")_"%"		//某部位感染率（全院）
	.s posInfl=$tr($fn((posSum)/ctinf,"+",4),"+","")		//某部位感染率（全院）
	.s Data=$lb(posDesc, posSum, posInfl)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	k ^CacheTemp("PosSum", $j)
	k ^CacheTemp("PosData", $j)
	k ^CacheTemp("StaHDMInfection",$j)
	Quit $$$OK
}

ClassMethod GetChartDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChartDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetChartDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChartDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     XQY
/// CreatDate：   2010-10-18
/// Description:  统计某段时间内不同感染部位的各种疾病感染率
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDataStatistic","QryDisease","1","2009-07-01","2010-10-19","","")          
/// Return：
Query QryDisease(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "LocDesc:%String,posDesc:%String,posSum:%String,disDesc:%String,disCount:%String,disInfl:%String")
{
}

ClassMethod QryDiseaseExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
    q:TypeCode="" $$$OK
    q:DateFrom="" $$$OK
    q:DateTo="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    q:+DateFrom>+DateTo $$$OK
    
    s (sumPosinf,sumDise)=0
    //获取条件时间段内报告rowid
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc		//各报告的科室号
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..s sumID=""	
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	...s posID=""
	...s disRowid=""
	...f  s posID=$o(^DHCMed.INF.RepPosI("InfRepDr",sumID,posID)) q:posID=""  d
	....s objPos=##class(DHCMed.INF.RepPos).%OpenId(posID)
	....q:'$IsObject(objPos)
	....s posRowid=objPos.InfPosCode    //是感染部位的rowid
	....s ^CacheTemp("StaHDMInfection", $j,PatLoc, "posid", posRowid)=posRowid
	....s ^CacheTemp("StaHDMInfection", $j,PatLoc, "possum", posRowid)=+$g(^CacheTemp("StaHDMInfection", $j,PatLoc, "possum", posRowid))+1		//某科室某部位感染数量
    ....s disRowid=objPos.InfDiagDR
    ....q:disRowid=""			//取得感染诊断id
	....s ^CacheTemp("DiseaseData", $j, PatLoc, posRowid, "disid", disRowid)=disRowid
	....s ^CacheTemp("DiseaseData", $j, PatLoc, posRowid, "disCount", disRowid)=+$g(^CacheTemp("DiseaseData", $j, PatLoc, posRowid, "disCount", disRowid))+1	//该部位该疾病感染人数
    
    s getLoc=""
    f  s getLoc=$o(^CacheTemp("StaHDMInfection", $j,getLoc)) q:getLoc=""  d
    .s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(getLoc)
    .q:'$IsObject(objLoc)
    .s LocDesc=objLoc.Descs
    .s getPos=""
    .f  s getPos=$o(^CacheTemp("StaHDMInfection", $j, getLoc, "posid", getPos)) q:getPos=""  d
    ..s posObj=##class(DHCMed.INF.InfPosition).%OpenId(getPos)
    ..q:'$IsObject(posObj)
    ..s posDesc=posObj.InfPosition		//感染部位名称
    ..s posSum=+$g(^CacheTemp("StaHDMInfection", $j, getLoc, "possum", getPos))	//某科室某部位感染人数
    
    ..s sumPosinf=sumPosinf+posSum		//全院有部位感染的人数
    
    ..s getDis=""
    ..f  s getDis=$o(^CacheTemp("DiseaseData", $j, getLoc, getPos, "disid", getDis)) q:getDis=""  d
    ...s disObj=##class(DHCMed.INF.InfDiagnose).%OpenId(getDis)
	...q:'$IsObject(disObj)
	...s disDesc=disObj.DiseaseName
	...s disCount=+$g(^CacheTemp("DiseaseData", $j, getLoc, getPos, "disCount", getDis))
	...s disInfl=$tr($fn((disCount*100)/posSum,"+",4),"+","")_"%"		//该部位中该疾病感染率
	
	...s sumDise=sumDise+disCount		//全院感染疾病人数
	
	...s Data=$lb(LocDesc,posDesc,posSum,disDesc,disCount,disInfl)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	k ^CacheTemp("DiseaseData", $j)
	k ^CacheTemp("StaHDMInfection",$j)
	s sumDisinfl="0%"
	s:sumPosinf'=0 sumDisinfl=$tr($fn((sumDise*100)/sumPosinf,"+",4),"+","")_"%"
	s Data=$lb("合计:","全部",sumPosinf,"全部",sumDise,sumDisinfl)
 	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1 
	
	Quit $$$OK
}

ClassMethod QryDiseaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiseaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiseaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiseaseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     XQY
/// CreatDate：   2010-10-19
/// Description:  返回疾病感染率图表数据
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDataStatistic","DisChartData","1","2009-07-01","2010-10-19","","")          
/// Return：
Query DisChartData(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "posDesc:%String,disDesc:%String,disCount:%String,disInfl:%String")
{
}

ClassMethod DisChartDataExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
    q:TypeCode="" $$$OK
    q:DateFrom="" $$$OK
    q:DateTo="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    q:+DateFrom>+DateTo $$$OK
    
    //获取条件时间段内报告rowid
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc		//各报告的科室号
	
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..s sumID=""	
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	
	...s posID=""
	...s disRowid=""
	...f  s posID=$o(^DHCMed.INF.RepPosI("InfRepDr",sumID,posID)) q:posID=""  d
	....s objPos=##class(DHCMed.INF.RepPos).%OpenId(posID)
	....q:'$IsObject(objPos)
	....s posRowid=objPos.InfPosCode    //是感染部位的rowid
	....s ^CacheTemp("StaHDMInfection", $j, "posid", posRowid)=posRowid
	....s ^CacheTemp("StaHDMInfection", $j, "possum", posRowid)=+$g(^CacheTemp("StaHDMInfection", $j, "possum", posRowid))+1		//某科室某部位感染数量
    ....s disRowid=objPos.InfDiagDR			//取得感染诊断id
    ....q:disRowid=""
    ....s ^CacheTemp("DiseaseData", $j, posRowid, "disid", disRowid)=disRowid
	....s ^CacheTemp("DiseaseData", $j, posRowid, "disCount", disRowid)=+$g(^CacheTemp("DiseaseData", $j, posRowid, "disCount", disRowid))+1	//该部位该疾病感染人数

    s getPos=""
    f  s getPos=$o(^CacheTemp("StaHDMInfection", $j, "posid", getPos)) q:getPos=""  d
    .s posObj=##class(DHCMed.INF.InfPosition).%OpenId(getPos)
    .q:'$IsObject(posObj)
    .s posDesc=posObj.InfPosition		//感染部位名称
    .s posSum=+$g(^CacheTemp("StaHDMInfection", $j, "possum", getPos))	//某部位感染人数
    .s getDis=""
    .f  s getDis=$o(^CacheTemp("DiseaseData", $j, getPos, "disid", getDis)) q:getDis=""  d
    ..s disObj=##class(DHCMed.INF.InfDiagnose).%OpenId(getDis)
	..q:'$IsObject(disObj)
	..s disDesc=disObj.DiseaseName
	..s disCount=+$g(^CacheTemp("DiseaseData", $j, getPos, "disCount", getDis))
	
	..s disInfl=$tr($fn(disCount/posSum,"+",4),"+","")		//该部位中该疾病感染率
	
	..s Data=$lb(posDesc,disDesc,disCount,disInfl)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	k ^CacheTemp("DiseaseData", $j)
	k ^CacheTemp("StaHDMInfection",$j)
	Quit $$$OK
}

ClassMethod DisChartDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisChartDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DisChartDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisChartDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     XQY
/// CreatDate：   2010-10-19
/// Description:  统计某段时间内院内感染病原体
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDataStatistic","QryPathogens","1","2009-07-01","2010-10-19","","")          
/// Return：
Query QryPathogens(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "LocDesc:%String,posDesc:%String,pyDesc:%String,pyCount:%String,pyInfl:%String")
{
}

ClassMethod QryPathogensExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
    q:TypeCode="" $$$OK
    q:DateFrom="" $$$OK
    q:DateTo="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    q:+DateFrom>+DateTo $$$OK
    
    s (sumPyinf,sumPosinf)=0
    
    //获取条件时间段内报告rowid
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc		//各报告的科室号
	
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..s sumID=""	
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	
	...s posID=""
	...f  s posID=$o(^DHCMed.INF.RepPosI("InfRepDr",sumID,posID)) q:posID=""  d
	....s objPos=##class(DHCMed.INF.RepPos).%OpenId(posID)
	....q:'$IsObject(objPos)
	....s posRowid=objPos.InfPosCode    //是感染部位的rowid
	....s ^CacheTemp("StaHDMInfection", $j,PatLoc, "posid", posRowid)=posRowid
	....s ^CacheTemp("StaHDMInfection", $j,PatLoc, "possum", posRowid)=+$g(^CacheTemp("StaHDMInfection", $j,PatLoc, "possum", posRowid))+1		//某科室某部位感染数量
    
    ...s patID=""
    ...f  s patID=$o(^DHCMed.INF.PathogenyI("InfRepDr",rowid,patID)) q:patID=""  d

    ....s pyobjID=""
    ....f  s pyobjID=$o( ^DHCMed.INF.PyObjI("InfPathDr",patID,pyobjID)) q:pyobjID=""  d
    .....s objPy=##class(DHCMed.INF.PyObj).%OpenId(pyobjID)
    .....s pyRowid=objPy.Object		//病原体id
    .....q:pyRowid=""
    .....s ^CacheTemp("Pathogeny", $j, PatLoc, posRowid, "pyid", pyRowid)=pyRowid
    .....s ^CacheTemp("Pathogeny", $j, PatLoc, posRowid, "pyCount", pyRowid)=+$g(^CacheTemp("Pathogeny", $j, PatLoc, posRowid, "pyCount", pyRowid))+1		//该病原体感染总数
    
    s getLoc=""
    f  s getLoc=$o(^CacheTemp("StaHDMInfection", $j,getLoc)) q:getLoc=""  d
    .s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(getLoc)
    .q:'$IsObject(objLoc)
    .s LocDesc=objLoc.Descs
    .s getPos=""
    .f  s getPos=$o(^CacheTemp("StaHDMInfection", $j, getLoc, "posid", getPos)) q:getPos=""  d
    ..s posObj=##class(DHCMed.INF.InfPosition).%OpenId(getPos)
    ..q:'$IsObject(posObj)
    ..s posDesc=posObj.InfPosition		//感染部位名称
    ..s posSum=+$g(^CacheTemp("StaHDMInfection", $j, getLoc, "possum", getPos))	//某科室某部位感染人数
    
    ..s sumPosinf=sumPosinf+posSum		//全院部位感染总数
    ..s getPy=""
    ..f  s getPy=$o(^CacheTemp("Pathogeny", $j, getLoc, getPos, "pyid", getPy)) q:getPy=""  d
    ...s pyObj=##class(DHCMed.INF.InfPathogenDic).%OpenId(getPy)
	...q:'$IsObject(pyObj)
	...s pyDesc=pyObj.Description
	...s pyCount=+$g(^CacheTemp("Pathogeny", $j, getLoc, getPos, "pyCount", getPy))
	...s pyInfl=$tr($fn((pyCount*100)/posSum,"+",4),"+","")_"%"		//该部位中该病原体感染率
	...s sumPyinf=sumPyinf+pyCount		//全院病原体感染总数
	...s Data=$lb(LocDesc,posDesc,pyDesc,pyCount,pyInfl)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	k ^CacheTemp("Pathogeny", $j)
	k ^CacheTemp("StaHDMInfection",$j)
	s sumPyinfl="0%"
	s:sumPosinf'=0 sumPyinfl=$tr($fn((sumPyinf*100)/sumPosinf,"+",4),"+","")_"%"
	s Data=$lb("总计:","全部","全部",sumPyinf,sumPyinfl)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	Quit $$$OK
}

ClassMethod QryPathogensClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathogensExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathogensFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathogensExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     XQY
/// CreatDate：   2010-10-20
/// Description:  统计某段时间内院内感染药敏情况
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDataStatistic","QryDrugSensitivity","1","2009-07-01","2010-10-21","","")          
/// Return：
Query QryDrugSensitivity(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "LocDesc:%String,pyDesc:%String,drugDesc:%String,sensNum:%String,unsensNum:%String,sensRate:%String")
{
}

ClassMethod QryDrugSensitivityExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
    q:TypeCode="" $$$OK
    q:DateFrom="" $$$OK
    q:DateTo="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    q:+DateFrom>+DateTo $$$OK
    
    s (sumSens,sumUnsens,sumDrug)=0
    //获取条件时间段内报告rowid
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc		//各报告的科室号
	
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..s sumID=""	
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	
    ...s patID=""
    ...f  s patID=$o(^DHCMed.INF.PathogenyI("InfRepDr",rowid,patID)) q:patID=""  d
	....s pyobjID=""
    ....f  s pyobjID=$o(^DHCMed.INF.PyObjI("InfPathDr",patID,pyobjID)) q:pyobjID=""  d
    .....s objPy=##class(DHCMed.INF.PyObj).%OpenId(pyobjID)
    .....q:'$IsObject(objPy)
    .....s pyRowid=objPy.Object		//病原体id
    .....q:pyRowid=""
    .....s ^CacheTemp("Drugsense", $j, PatLoc, pyRowid)=pyRowid
    
    .....s drugID=""
    .....f  s drugID=$o(^DHCMed.INF.PyObjDrugI("InfPyObjDr",pyobjID,drugID)) q:drugID=""  d
    ......s objDrug=##class(DHCMed.INF.PyObjDrug).%OpenId(drugID)
    ......S drugRowid=objDrug.DrugDR			//抗生素id
    ......q:drugRowid=""
    ......s drugFlag=objDrug.Flag			//药敏结果
    ......s ^CacheTemp("Drugsense", $j, PatLoc, pyRowid, "drugid", drugRowid)=drugRowid
    ......s ^CacheTemp("Drugsense", $j, PatLoc, pyRowid, "drugSum")=+$g(^CacheTemp("Drugsense", $j, PatLoc, pyRowid, "drugSum"))+1			//该抗生素使用总数
    ......s:drugFlag="Y" ^CacheTemp("Drugsense", $j, PatLoc, pyRowid, "senseNum")=+$g(^CacheTemp("Drugsense", $j, PatLoc, pyRowid, "senseNum"))+1			//结果为敏感的总数
    
    //取得结果集的各字段数据，生成结果集
    s getLoc=""
    f  s getLoc=$o(^CacheTemp("Drugsense", $j,getLoc)) q:getLoc=""  d
    .s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(getLoc)
    .q:'$IsObject(objLoc)
    .s LocDesc=objLoc.Descs
    .s getPy=""
    .f  s getPy=$o(^CacheTemp("Drugsense", $j, getLoc, getPy)) q:getPy=""  d
    ..s pyObj=##class(DHCMed.INF.InfPathogenDic).%OpenId(getPy)
	..q:'$IsObject(pyObj)
	..s pyDesc=pyObj.Description
	..s getDrug=""
	..s drugSum=0
	..f  s getDrug=$o(^CacheTemp("Drugsense", $j, getLoc, getPy, "drugid", getDrug)) q:getDrug=""  d
	...s drugObj=##class(DHCMed.INF.InfAntiDic).%OpenId(getDrug)
	...q:'$IsObject(drugObj)
	...s drugDesc=drugObj.Description
	...s drugSum=+$g(^CacheTemp("Drugsense", $j, getLoc, getPy, "drugSum"))		
	...s sensNum=+$g(^CacheTemp("Drugsense", $j, getLoc, getPy, "senseNum"))		//敏感数量
	...s unsensNum=drugSum-sensNum			//不敏感数量
	
	...s sumDrug=sumDrug+drugSum		//全院抗菌药物检测量
	...s sumSens=sumSens+sensNum		//全院敏感数量
	...s sumUnsens=sumUnsens+unsensNum		//全院不敏感数量
	
	...s sensRate=$tr($fn((sensNum*100)/drugSum,"+",4),"+","")_"%"
	...s Data=$lb(LocDesc,pyDesc,drugDesc,sensNum,unsensNum,sensRate)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	k ^CacheTemp("Drugsense", $j)
	s sumSensl="0%"
	s:sumDrug'=0 sumSensl=$tr($fn((sumSens*100)/sumDrug,"+",4),"+","")_"%"
	s Data=$lb("总计:","全部","全部",sumSens,sumUnsens,sumSensl)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	Quit $$$OK
}

ClassMethod QryDrugSensitivityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDrugSensitivityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDrugSensitivityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDrugSensitivityExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     XQY
/// CreatDate：   2010-10-21
/// Description:  统计某段时间内院内感染率（感染人数/出院人数）
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDataStatistic","QryInfRate","1","2008-07-01","2010-10-25","day","")          
/// Return：
Query QryInfRate(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", DateType As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "ResultDate:%String,loc1:%String,loc2:%String,loc3:%String,loc4:%String,loc5:%String,loc6:%String,loc7:%String,loc8:%String,loc9:%String,loc10:%String,loc11:%String,loc12:%String,loc13:%String,loc14:%String,loc15:%String,loc16:%String,loc17:%String,loc18:%String,loc19:%String")
{
}

ClassMethod QryInfRateExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", DateType As %String = "", cInfPlace As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
    q:TypeCode="" $$$OK
    q:DateFrom="" $$$OK
    q:DateTo="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    //
    s tmpDS=DateFrom
    //
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    q:+DateFrom>+DateTo $$$OK
    
    s tmpCt=""
    f  s tmpCt=$o(^CTLOC(tmpCt)) q:tmpCt="20"  d
    .q:tmpCt="20"
    .s ^CacheTemp("StaHDMInfection", $j, tmpCt, "ctinf")=0 
    
    //获取条件时间段内报告rowid
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc		//各报告的科室号
	
	..s sumID=""	
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	...s ^CacheTemp("StaHDMInfection", $j,tmpDt,PatLoc)=+$g(^CacheTemp("StaHDMInfection", $j,tmpDt,PatLoc))+1		//不同感染地点（社区、院内）某科室感染数总量
    
	//获取某段时间内科室出院人数
	//按月分组
	i DateType="month"  d
	.s tmpd=tmpDS					//查询开始日期
	.s sign1=DateFrom				//设置循环条件1为查询起始日期
	.s sign2=DateTo					//设置循环条件2为查询结束日期
	.s date1=0
	.s date2=0
	.f sign=sign1:1:sign2  d
	..//判断是否到达一个月的最后一天
	..//是，则重新设置下一个月的起始日期和结束日期
	..i sign>date2  d
	...s ds=tmpd
	...s tmpMonth=+$p(ds,"-",2)
	...//判断是否到达一年的最后一个月
	...i tmpMonth<12  d
	....s nextMonth=tmpMonth+1
	....i nextMonth<10  d
	.....s nextMonth="0"_nextMonth				//月份小于10在前面补0以符合日期格式0000-00-00
	
	....s $p(tmpd,"-",2)=nextMonth
	....s $p(tmpd,"-",3)="01"
	
	...//到达最后一个月，则设置下一个月为下一年一月
	...e  d
	....s tmpYear=+$p(ds,"-",1)
	....s nextYear=tmpYear+1				//年份加1
	....s $p(tmpd,"-",1)=nextYear
	....s $p(tmpd,"-",2)="01"				//设置月份设为1月
	....s $p(tmpd,"-",3)="01"				//设置日期为1号，所以新起始日期为新一年01月01日
	
	...s datefrom=$zdh(ds,3)
	...s dateto=$zdh(tmpd,3)
	...//判断是否到达查询结束日期
	...//是，则设置新一个月的结束日期为查询结束日期
	...i dateto>DateTo  d
	....s dateto=DateTo
	....s date1=datefrom
	....s date2=dateto
	
	...e  d
	....s date1=datefrom
	....s date2=dateto-1
	
	...s sign3=0
	...//初始化临时global，确保生成结果集时所需数据都不为空
    ...f curloc=1:1:19  d
    ....s ^CacheTemp("Result", $j, date1, curloc)=0
	....s ^CacheTemp("MonthGroup", $j, date1, curloc)=0
	
	..q:sign3'=0
 	..f curdate=date1:1:date2  d
 	...s sign3=1
 	...s admrowid=0 f  s admrowid=$o(^PAADMi("DischDate",curdate,admrowid)) q:(admrowid="")  d
 	....q:(admrowid="")
 	....s admrowid=+admrowid
 	....s admtype=$p(^PAADM(admrowid),"^",2)
 	....s admtype=$g(admtype)
 	....q:(admtype'="I")
	....s parctloc=$p($g(^PAADM(admrowid)),"^",4)
 	....q:(parctloc="")
	....s ^CacheTemp("Result", $j, date1, parctloc)=+$g(^CacheTemp("Result", $j, date1, parctloc))+1
	
	...//获取该月各执行科室感染报告数量
	...f curloc=1:1:19  d
	....s ^CacheTemp("MonthGroup", $j, date1, curloc)=+$g(^CacheTemp("MonthGroup", $j, date1, curloc))+(+$g(^CacheTemp("StaHDMInfection", $j,curdate,curloc)))
	
	//获取出院人数
	//按日分组
	e  d
    .s date1=DateFrom
    .s date2=DateTo
    .f curdate=date1:1:date2  d
    ..f curloc=1:1:19  d
    ...s ^CacheTemp("Result", $j, curdate, curloc)=0
 	.f curdate=date1:1:date2  d
 	..s admrowid=0 f  s admrowid=$o(^PAADMi("DischDate",curdate,admrowid)) q:(admrowid="")  d
 	...q:(admrowid="")
 	...s admrowid=+admrowid
 	...s admtype=$p(^PAADM(admrowid),"^",2)
 	...s admtype=$g(admtype)
 	...q:(admtype'="I")
	...s parctloc=$p($g(^PAADM(admrowid)),"^",4)
 	...q:(parctloc="")
	...s ^CacheTemp("Result", $j, curdate, parctloc)=+$g(^CacheTemp("Result", $j, curdate, parctloc))+1

	s (allLoc1,allLoc2,allLoc3,allLoc4,allLoc5,allLoc6,allLoc7,allLoc8,allLoc9,allLoc10,allLoc11,allLoc12,allLoc13,allLoc14,allLoc15,allLoc16,allLoc17,allLoc18,allLoc19)=0
	s (allInf1,allInf2,allInf3,allInf4,allInf5,allInf6,allInf7,allInf8,allInf9,allInf10,allInf11,allInf12,allInf13,allInf14,allInf15,allInf16,allInf17,allInf18,allInf19)=0
	
	//按月输出结果集
	i DateType="month"  d
	.s date=DateFrom-1
	.f  s date=$o(^CacheTemp("Result", $j, date)) q:date=""  d
	..s loc1=+$g(^CacheTemp("Result", $j, date, 1))
	..s loc2=+$g(^CacheTemp("Result", $j, date, 2))
	..s loc3=+$g(^CacheTemp("Result", $j, date, 3))
	..s loc4=+$g(^CacheTemp("Result", $j, date, 4))
	..s loc5=+$g(^CacheTemp("Result", $j, date, 5))
	..s loc6=+$g(^CacheTemp("Result", $j, date, 6))
	..s loc7=+$g(^CacheTemp("Result", $j, date, 7))
	..s loc8=+$g(^CacheTemp("Result", $j, date, 8))
	..s loc9=+$g(^CacheTemp("Result", $j, date, 9))
	..s loc10=+$g(^CacheTemp("Result", $j, date, 10))
	..s loc11=+$g(^CacheTemp("Result", $j, date, 11))
	..s loc12=+$g(^CacheTemp("Result", $j, date, 12))
	..s loc13=+$g(^CacheTemp("Result", $j, date, 13))
	..s loc14=+$g(^CacheTemp("Result", $j, date, 14))
	..s loc15=+$g(^CacheTemp("Result", $j, date, 15))
	..s loc16=+$g(^CacheTemp("Result", $j, date, 16))
	..s loc17=+$g(^CacheTemp("Result", $j, date, 17))
	..s loc18=+$g(^CacheTemp("Result", $j, date, 18))
	..s loc19=+$g(^CacheTemp("Result", $j, date, 19))
	
	..s allLoc1=allLoc1+loc1
	..s allLoc2=allLoc2+loc2
	..s allLoc3=allLoc3+loc3
	..s allLoc4=allLoc4+loc4
	..s allLoc5=allLoc5+loc5
	..s allLoc6=allLoc6+loc6
	..s allLoc7=allLoc7+loc7
	..s allLoc8=allLoc8+loc8
	..s allLoc9=allLoc9+loc9
	..s allLoc10=allLoc10+loc10
	..s allLoc11=allLoc11+loc11
	..s allLoc12=allLoc12+loc12
	..s allLoc13=allLoc13+loc13
	..s allLoc14=allLoc14+loc14
	..s allLoc15=allLoc15+loc15
	..s allLoc16=allLoc16+loc16
	..s allLoc17=allLoc17+loc17
	..s allLoc18=allLoc18+loc18
	..s allLoc19=allLoc19+loc19
	
	..s sumInf1=+$g(^CacheTemp("MonthGroup", $j, date, 1))
	..s sumInf2=+$g(^CacheTemp("MonthGroup", $j, date, 2))
	..s sumInf3=+$g(^CacheTemp("MonthGroup", $j, date, 3))
	..s sumInf4=+$g(^CacheTemp("MonthGroup", $j, date, 4))
	..s sumInf5=+$g(^CacheTemp("MonthGroup", $j, date, 5))
	..s sumInf6=+$g(^CacheTemp("MonthGroup", $j, date, 6))
	..s sumInf7=+$g(^CacheTemp("MonthGroup", $j, date, 7))
	..s sumInf8=+$g(^CacheTemp("MonthGroup", $j, date, 8))
	..s sumInf9=+$g(^CacheTemp("MonthGroup", $j, date, 9))
	..s sumInf10=+$g(^CacheTemp("MonthGroup", $j, date, 10))
	..s sumInf11=+$g(^CacheTemp("MonthGroup", $j, date, 11))
	..s sumInf12=+$g(^CacheTemp("MonthGroup", $j, date, 12))
	..s sumInf13=+$g(^CacheTemp("MonthGroup", $j, date, 13))
	..s sumInf14=+$g(^CacheTemp("MonthGroup", $j, date, 14))
	..s sumInf15=+$g(^CacheTemp("MonthGroup", $j, date, 15))
	..s sumInf16=+$g(^CacheTemp("MonthGroup", $j, date, 16))
	..s sumInf17=+$g(^CacheTemp("MonthGroup", $j, date, 17))
	..s sumInf18=+$g(^CacheTemp("MonthGroup", $j, date, 18))
	..s sumInf19=+$g(^CacheTemp("MonthGroup", $j, date, 19))
	
	..s allInf1=allInf1+sumInf1
	..s allInf2=allInf2+sumInf2
	..s allInf3=allInf3+sumInf3
	..s allInf4=allInf4+sumInf4
	..s allInf5=allInf5+sumInf5
	..s allInf6=allInf6+sumInf6
	..s allInf7=allInf7+sumInf7
	..s allInf8=allInf8+sumInf8
	..s allInf9=allInf9+sumInf9
	..s allInf10=allInf10+sumInf10
	..s allInf11=allInf11+sumInf11
	..s allInf12=allInf12+sumInf12
	..s allInf13=allInf13+sumInf13
	..s allInf14=allInf14+sumInf14
	..s allInf15=allInf15+sumInf15
	..s allInf16=allInf16+sumInf16
	..s allInf17=allInf17+sumInf17
	..s allInf18=allInf18+sumInf18
	..s allInf19=allInf19+sumInf19
	
	..//前台输出格式为:感染人数/出院人数
	..s loc1=sumInf1_"/"_loc1
	..s loc2=sumInf2_"/"_loc2
	..s loc3=sumInf3_"/"_loc3
	..s loc4=sumInf4_"/"_loc4
	..s loc5=sumInf5_"/"_loc5
	..s loc6=sumInf6_"/"_loc6
	..s loc7=sumInf7_"/"_loc7
	..s loc8=sumInf8_"/"_loc8
	..s loc9=sumInf9_"/"_loc9
	..s loc10=sumInf10_"/"_loc10
	..s loc11=sumInf11_"/"_loc11
	..s loc12=sumInf12_"/"_loc12
	..s loc13=sumInf13_"/"_loc13
	..s loc14=sumInf14_"/"_loc14
	..s loc15=sumInf15_"/"_loc15
	..s loc16=sumInf16_"/"_loc16
	..s loc17=sumInf17_"/"_loc17
	..s loc18=sumInf18_"/"_loc18
	..s loc19=sumInf19_"/"_loc19

	..s tmp=$ZDate(date,3)
	..s year=$p(tmp,"-",1)
	..s month=$p(tmp,"-",2)
	..s ResultDate=year_"-"_month
	..s Data=$lb(ResultDate,loc1,loc2,loc3,loc4,loc5,loc6,loc7,loc8,loc9,loc10,loc11,loc12,loc13,loc14,loc15,loc16,loc17,loc18,loc19)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	//按日输出结果集
	e  d
	.s date=DateFrom-1
	.f  s date=$o(^CacheTemp("Result", $j, date)) q:date=""  d
	..s loc1=+$g(^CacheTemp("Result", $j, date, 1))
	..s loc2=+$g(^CacheTemp("Result", $j, date, 2))
	..s loc3=+$g(^CacheTemp("Result", $j, date, 3))
	..s loc4=+$g(^CacheTemp("Result", $j, date, 4))
	..s loc5=+$g(^CacheTemp("Result", $j, date, 5))
	..s loc6=+$g(^CacheTemp("Result", $j, date, 6))
	..s loc7=+$g(^CacheTemp("Result", $j, date, 7))
	..s loc8=+$g(^CacheTemp("Result", $j, date, 8))
	..s loc9=+$g(^CacheTemp("Result", $j, date, 9))
	..s loc10=+$g(^CacheTemp("Result", $j, date, 10))
	..s loc11=+$g(^CacheTemp("Result", $j, date, 11))
	..s loc12=+$g(^CacheTemp("Result", $j, date, 12))
	..s loc13=+$g(^CacheTemp("Result", $j, date, 13))
	..s loc14=+$g(^CacheTemp("Result", $j, date, 14))
	..s loc15=+$g(^CacheTemp("Result", $j, date, 15))
	..s loc16=+$g(^CacheTemp("Result", $j, date, 16))
	..s loc17=+$g(^CacheTemp("Result", $j, date, 17))
	..s loc18=+$g(^CacheTemp("Result", $j, date, 18))
	..s loc19=+$g(^CacheTemp("Result", $j, date, 19))
	
	..s allLoc1=allLoc1+loc1
	..s allLoc2=allLoc2+loc2
	..s allLoc3=allLoc3+loc3
	..s allLoc4=allLoc4+loc4
	..s allLoc5=allLoc5+loc5
	..s allLoc6=allLoc6+loc6
	..s allLoc7=allLoc7+loc7
	..s allLoc8=allLoc8+loc8
	..s allLoc9=allLoc9+loc9
	..s allLoc10=allLoc10+loc10
	..s allLoc11=allLoc11+loc11
	..s allLoc12=allLoc12+loc12
	..s allLoc13=allLoc13+loc13
	..s allLoc14=allLoc14+loc14
	..s allLoc15=allLoc15+loc15
	..s allLoc16=allLoc16+loc16
	..s allLoc17=allLoc17+loc17
	..s allLoc18=allLoc18+loc18
	..s allLoc19=allLoc19+loc19
	
	..s sumInf1=+$g(^CacheTemp("StaHDMInfection", $j,date,1))
	..s sumInf2=+$g(^CacheTemp("StaHDMInfection", $j,date,2))
	..s sumInf3=+$g(^CacheTemp("StaHDMInfection", $j,date,3))
	..s sumInf4=+$g(^CacheTemp("StaHDMInfection", $j,date,4))
	..s sumInf5=+$g(^CacheTemp("StaHDMInfection", $j,date,5))
	..s sumInf6=+$g(^CacheTemp("StaHDMInfection", $j,date,6))
	..s sumInf7=+$g(^CacheTemp("StaHDMInfection", $j,date,7))
	..s sumInf8=+$g(^CacheTemp("StaHDMInfection", $j,date,8))
	..s sumInf9=+$g(^CacheTemp("StaHDMInfection", $j,date,9))
	..s sumInf10=+$g(^CacheTemp("StaHDMInfection", $j,date,10))
	..s sumInf11=+$g(^CacheTemp("StaHDMInfection", $j,date,11))
	..s sumInf12=+$g(^CacheTemp("StaHDMInfection", $j,date,12))
	..s sumInf13=+$g(^CacheTemp("StaHDMInfection", $j,date,13))
	..s sumInf14=+$g(^CacheTemp("StaHDMInfection", $j,date,14))
	..s sumInf15=+$g(^CacheTemp("StaHDMInfection", $j,date,15))
	..s sumInf16=+$g(^CacheTemp("StaHDMInfection", $j,date,16))
	..s sumInf17=+$g(^CacheTemp("StaHDMInfection", $j,date,17))
	..s sumInf18=+$g(^CacheTemp("StaHDMInfection", $j,date,18))
	..s sumInf19=+$g(^CacheTemp("StaHDMInfection", $j,date,19))
	
	..s allInf1=allInf1+sumInf1
	..s allInf2=allInf2+sumInf2
	..s allInf3=allInf3+sumInf3
	..s allInf4=allInf4+sumInf4
	..s allInf5=allInf5+sumInf5
	..s allInf6=allInf6+sumInf6
	..s allInf7=allInf7+sumInf7
	..s allInf8=allInf8+sumInf8
	..s allInf9=allInf9+sumInf9
	..s allInf10=allInf10+sumInf10
	..s allInf11=allInf11+sumInf11
	..s allInf12=allInf12+sumInf12
	..s allInf13=allInf13+sumInf13
	..s allInf14=allInf14+sumInf14
	..s allInf15=allInf15+sumInf15
	..s allInf16=allInf16+sumInf16
	..s allInf17=allInf17+sumInf17
	..s allInf18=allInf18+sumInf18
	..s allInf19=allInf19+sumInf19

	..s loc1=sumInf1_"/"_loc1
	..s loc2=sumInf2_"/"_loc2
	..s loc3=sumInf3_"/"_loc3
	..s loc4=sumInf4_"/"_loc4
	..s loc5=sumInf5_"/"_loc5
	..s loc6=sumInf6_"/"_loc6
	..s loc7=sumInf7_"/"_loc7
	..s loc8=sumInf8_"/"_loc8
	..s loc9=sumInf9_"/"_loc9
	..s loc10=sumInf10_"/"_loc10
	..s loc11=sumInf11_"/"_loc11
	..s loc12=sumInf12_"/"_loc12
	..s loc13=sumInf13_"/"_loc13
	..s loc14=sumInf14_"/"_loc14
	..s loc15=sumInf15_"/"_loc15
	..s loc16=sumInf16_"/"_loc16
	..s loc17=sumInf17_"/"_loc17
	..s loc18=sumInf18_"/"_loc18
	..s loc19=sumInf19_"/"_loc19
	..s ResultDate=$ZDate(date,3)
	..s Data=$lb(ResultDate,loc1,loc2,loc3,loc4,loc5,loc6,loc7,loc8,loc9,loc10,loc11,loc12,loc13,loc14,loc15,loc16,loc17,loc18,loc19)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1	
	
	k ^CacheTemp("StaHDMInfection",$j)
	k ^CacheTemp("Result",$j)
	k ^CacheTemp("MonthGroup", $j)
	//总计结果
	s allLoc1=allInf1_"/"_allLoc1
	s allLoc2=allInf2_"/"_allLoc2
	s allLoc3=allInf3_"/"_allLoc3
	s allLoc4=allInf4_"/"_allLoc4
	s allLoc5=allInf5_"/"_allLoc5
	s allLoc6=allInf6_"/"_allLoc6
	s allLoc7=allInf7_"/"_allLoc7
	s allLoc8=allInf8_"/"_allLoc8
	s allLoc9=allInf9_"/"_allLoc9
	s allLoc10=allInf10_"/"_allLoc10
	s allLoc11=allInf11_"/"_allLoc11
	s allLoc12=allInf12_"/"_allLoc12
	s allLoc13=allInf13_"/"_allLoc13
	s allLoc14=allInf14_"/"_allLoc14
	s allLoc15=allInf15_"/"_allLoc15
	s allLoc16=allInf16_"/"_allLoc16
	s allLoc17=allInf17_"/"_allLoc17
	s allLoc18=allInf18_"/"_allLoc18
	s allLoc19=allInf19_"/"_allLoc19
	s Data=$lb("总计:",allLoc1,allLoc2,allLoc3,allLoc4,allLoc5,allLoc6,allLoc7,allLoc8,allLoc9,allLoc10,allLoc11,allLoc12,allLoc13,allLoc14,allLoc15,allLoc16,allLoc17,allLoc18,allLoc19)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1	

	Quit $$$OK
}

ClassMethod QryInfRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfRateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
