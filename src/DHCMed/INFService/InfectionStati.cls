/// 名称: DHCMed.INFService.InfectionStati
/// 描述: 基于报告表的数据统计
/// 编写者：ChenJB
/// 编写日期: 2010-07-22
Class DHCMed.INFService.InfectionStati Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     陈剑波
/// CreatDate：   2010-06-17
/// Description:  统计某段时间内的某些报告情况
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfectionStati","QryRepByTypeMore","3","2010-07-01","2010-08-01","","")          
/// Return：
Query QryRepByTypeMore(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "LocDesc:%String,ctYDC:%String,ctjcr:%String,ctjcrl:%String,ctinf:%String,ctinfl:%String,ctpos:%String,ctposl:%String,pos1:%String,pos2:%String,pos3:%String,pos4:%String,pos5:%String,pos6:%String,pos7:%String,pos8:%String,pos9:%String,pos10:%String,pos11:%String,pos12:%String,pos13:%String,pos14:%String,pos15:%String,pos16:%String,pos17:%String,pos18:%String,pos19:%String,pos20:%String,pos21:%String,pos22:%String,pos23:%String")
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
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
 	..//w rowid,!
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..s ^CacheTemp("StaHDMInfecion", $j,PatLoc,"ctjcr")=+$g(^CacheTemp("StaHDMInfecion", $j,PatLoc,"ctjcr"))+1
	..s sumID=""
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	...s ^CacheTemp("StaHDMInfecion", $j,PatLoc,"ctinf")=+$g(^CacheTemp("StaHDMInfecion", $j,PatLoc,"ctinf"))+1
	...// ^DHCMed.INF.RepPosI("InfRepDr"
	...s posID=""
	...f  s posID=$o(^DHCMed.INF.RepPosI("InfRepDr",sumID,posID)) q:posID=""  d
	....s objPos=##class(DHCMed.INF.RepPos).%OpenId(posID)
	....q:'$IsObject(objPos)
	....s posRowid=objPos.InfPosCode    //是感染部位的rowid
	....s ^CacheTemp("StaHDMInfecion", $j,PatLoc,posRowid)=+$g(^CacheTemp("StaHDMInfecion", $j,PatLoc,posID))+1
    ....s ^CacheTemp("StaHDMInfecion", $j,PatLoc,"ctpos")=+$g(^CacheTemp("StaHDMInfecion", $j,PatLoc,"ctpos"))+1
    s getLoc=""
    s (sumctYDC,sumctjcr,sumctinf,sumctpos,sumpos1,sumpos2,sumpos3,sumpos4,sumpos5,sumpos6,sumpos7)=0
    s (sumpos8,sumpos9,sumpos10,sumpos11,sumpos12,sumpos13,sumpos14,sumpos15,sumpos16,sumpos17,sumpos18,sumpos19,sumpos20,sumpos21,sumpos22,sumpos23)=0
    f  s getLoc=$o(^CacheTemp("StaHDMInfecion", $j,getLoc)) q:getLoc=""  d
    .s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(getLoc)
    .q:'$IsObject(objLoc)
    .s LocDesc=objLoc.Descs
    .s ctYDC=0
    .s tmpDt=DateFrom-1
    .f  s tmpDt=$o(^DHCMed.INF.TypeLocConfigI("TypeMainIdx",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
    ..s tmpID=""
    ..f  s tmpID=$o(^DHCMed.INF.TypeLocConfigI("TypeMainIdx",TypeCodeIdx,tmpDt,tmpID)) q:tmpID=""  d
    ...s objTypeLoc=##class(DHCMed.INF.TypeLocConfig).%OpenId(tmpID)
    ...q:'$IsObject(objTypeLoc)
    ...q:getLoc'=objTypeLoc.CtLoc
    ...s ctYDC=ctYDC+objTypeLoc.SurPatiCount
    .s:ctYDC=0 ctYDC=11111111     //如果没有设置应监测人  默认值设置
    .s pos1=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,1))
    .s pos2=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,2))
    .s pos3=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,3))
    .s pos4=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,4))
    .s pos5=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,5))
    .s pos6=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,6))
    .s pos7=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,7))
    .s pos8=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,8))
    .s pos9=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,9))
    .s pos10=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,10))
    .s pos11=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,11))
    .s pos12=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,12))
    .s pos13=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,13))
    .s pos14=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,14))
    .s pos15=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,15))
    .s pos16=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,16))
    .s pos17=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,17))
    .s pos18=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,18))
    .s pos19=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,19))
    .s pos20=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,20))
    .s pos21=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,21))
    .s pos22=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,22))
    .s pos23=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,23))
    .s ctjcr=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,"ctjcr"))
    .s ctjcrl=+$fn((ctjcr*100)/ctYDC,"+",4)_"%"
    .s ctinf=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,"ctinf"))
    .s ctinfl=+$fn((ctinf*100)/ctjcr,"+",4)_"%"
    .s ctpos=+$g(^CacheTemp("StaHDMInfecion", $j,getLoc,"ctpos"))
    .s ctposl=+$fn((ctpos*100)/ctjcr,"+",4)_"%"
    .s sumctYDC=sumctYDC+ctYDC
    .s sumctjcr=sumctjcr+ctjcr
    .s sumctinf=sumctinf+ctinf
    .s sumctpos=sumctpos+ctpos
    .s sumpos1=sumpos1+pos1
    .s sumpos2=sumpos2+pos2
    .s sumpos3=sumpos3+pos3
    .s sumpos4=sumpos4+pos4
    .s sumpos5=sumpos5+pos5
    .s sumpos6=sumpos6+pos6
    .s sumpos7=sumpos7+pos7
    .s sumpos8=sumpos8+pos8
    .s sumpos9=sumpos9+pos9
    .s sumpos10=sumpos10+pos10
    .s sumpos11=sumpos11+pos11
    .s sumpos12=sumpos12+pos12
    .s sumpos13=sumpos13+pos13
    .s sumpos14=sumpos14+pos14
    .s sumpos15=sumpos15+pos15
    .s sumpos16=sumpos16+pos16
    .s sumpos17=sumpos17+pos17
    .s sumpos18=sumpos18+pos18
    .s sumpos19=sumpos19+pos19
    .s sumpos20=sumpos20+pos20
    .s sumpos21=sumpos21+pos21
    .s sumpos22=sumpos22+pos22
    .s sumpos23=sumpos23+pos23
    .s Data1=$lb(LocDesc,ctYDC,ctjcr,ctjcrl,ctinf,ctinfl,ctpos,ctposl)
    .s Data2=$lb(pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,pos10,pos11,pos12,pos13,pos14,pos15,pos16,pos17,pos18,pos19,pos20,pos21,pos22,pos23)
 	.s Data=Data1_Data2
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^CacheTemp("StaHDMInfecion",$j)
	s sumctjcrl=+$fn((sumctjcr*100)/sumctYDC,"+",4)_"%"
	s sumctinfl=+$fn((sumctinf*100)/sumctjcr,"+",4)_"%"
	s sumctposl=+$fn((sumctpos*100)/sumctjcr,"+",4)_"%"
	s Data1=$lb("合计:",sumctYDC,sumctjcr,sumctjcrl,sumctinf,sumctinfl,sumctpos,sumctposl)
    s Data2=$lb(sumpos1,sumpos2,sumpos3,sumpos4,sumpos5,sumpos6,sumpos7,sumpos8,sumpos9,sumpos10,sumpos11,sumpos12,sumpos13,sumpos14,sumpos15,sumpos16,sumpos17,sumpos18,sumpos19,sumpos20,sumpos21,sumpos22,sumpos23)
 	s Data=Data1_Data2
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

/// Creator：     陈剑波
/// CreatDate：   2010-07-23
/// Description:  统计某段时间内的报告病原体
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfectionStati","QryHDMRepByPy","3","2010-07-01","2010-08-01","","")          
/// Return：
Query QryHDMRepByPy(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "PyDesc:%String,ctJZ:%String,pos1:%String,pos2:%String,pos3:%String,pos4:%String,pos5:%String,pos6:%String,pos7:%String,pos8:%String,pos9:%String,pos10:%String,pos11:%String,pos12:%String,pos13:%String,pos14:%String,pos15:%String,pos16:%String,pos17:%String,pos18:%String,pos19:%String,pos20:%String,pos21:%String,pos22:%String,pos23:%String")
{
}

ClassMethod QryHDMRepByPyExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
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
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
 	..//w rowid,!
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..//s ^CacheTemp("StaHDMPyInfection", $j,PatLoc,"ctjcr")=+$g(^CacheTemp("StaHDMPyInfection", $j,PatLoc,"ctjcr"))+1
	..s sumID=""
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	...s LabID=""
	...f  s LabID=$o(^DHCMed.INF.PathogenyI("InfRepDr",rowid,LabID)) q:LabID=""  d
	....s objLab=##class(DHCMed.INF.Pathogeny).%OpenId(LabID)
	....q:'$IsObject(objLab)
	....s Oeorid=objLab.OEORIDR
	....//可增加是否关联判断
	....s PyID=""
	....f  s PyID=$o(^DHCMed.INF.PyObjI("InfPathDr",LabID,PyID)) q:PyID=""  d
	.....s objPy=##class(DHCMed.INF.PyObj).%OpenId(PyID)
	.....q:'$IsObject(objPy)
	.....s PyDicID=objPy.Object
	.....q:PyDicID=""
	.....s ^CacheTemp("StaHDMPyInfection", $j,PyDicID)=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID))+1
	.....// ^DHCMed.INF.RepPosI("InfRepDr"
	.....s posID=""
	.....f  s posID=$o(^DHCMed.INF.RepPosI("InfRepDr",sumID,posID)) q:posID=""  d
	......s objPos=##class(DHCMed.INF.RepPos).%OpenId(posID)
	......q:'$IsObject(objPos)
	......s posRowid=objPos.InfPosCode    //是感染部位的rowid
	......s ^CacheTemp("StaHDMPyInfection", $j,PyDicID,posRowid)=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,posRowid))+1
    ......k objPos
    .....k objPy
    ....k objLab
    ...k objSum
    ..k objCls
    s PyDicID=""
    s (sumctJZ,sumpos1,sumpos2,sumpos3,sumpos4,sumpos5,sumpos6,sumpos7)=0
    s (sumpos8,sumpos9,sumpos10,sumpos11,sumpos12,sumpos13,sumpos14,sumpos15,sumpos16,sumpos17,sumpos18,sumpos19,sumpos20,sumpos21,sumpos22,sumpos23)=0
    f  s PyDicID=$o(^CacheTemp("StaHDMPyInfection", $j,PyDicID)) q:PyDicID=""  d
    .s objPyDic=##class(DHCMed.INF.InfPathogenDic).%OpenId(PyDicID)
    .q:'$IsObject(objPyDic)
    .s PyDesc=objPyDic.Description
    .//s ctJZ=0
    .s pos1=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,1))
    .s pos2=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,2))
    .s pos3=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,3))
    .s pos4=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,4))
    .s pos5=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,5))
    .s pos6=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,6))
    .s pos7=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,7))
    .s pos8=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,8))
    .s pos9=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,9))
    .s pos10=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,10))
    .s pos11=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,11))
    .s pos12=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,12))
    .s pos13=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,13))
    .s pos14=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,14))
    .s pos15=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,15))
    .s pos16=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,16))
    .s pos17=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,17))
    .s pos18=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,18))
    .s pos19=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,19))
    .s pos20=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,20))
    .s pos21=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,21))
    .s pos22=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,22))
    .s pos23=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID,23))
    .s ctJZ=+$g(^CacheTemp("StaHDMPyInfection", $j,PyDicID))
    .s sumctJZ=sumctJZ+ctJZ
    .s sumpos1=sumpos1+pos1
    .s sumpos2=sumpos2+pos2
    .s sumpos3=sumpos3+pos3
    .s sumpos4=sumpos4+pos4
    .s sumpos5=sumpos5+pos5
    .s sumpos6=sumpos6+pos6
    .s sumpos7=sumpos7+pos7
    .s sumpos8=sumpos8+pos8
    .s sumpos9=sumpos9+pos9
    .s sumpos10=sumpos10+pos10
    .s sumpos11=sumpos11+pos11
    .s sumpos12=sumpos12+pos12
    .s sumpos13=sumpos13+pos13
    .s sumpos14=sumpos14+pos14
    .s sumpos15=sumpos15+pos15
    .s sumpos16=sumpos16+pos16
    .s sumpos17=sumpos17+pos17
    .s sumpos18=sumpos18+pos18
    .s sumpos19=sumpos19+pos19
    .s sumpos20=sumpos20+pos20
    .s sumpos21=sumpos21+pos21
    .s sumpos22=sumpos22+pos22
    .s sumpos23=sumpos23+pos23
    .s Data1=$lb(PyDesc,ctJZ)
    .s Data2=$lb(pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,pos10,pos11,pos12,pos13,pos14,pos15,pos16,pos17,pos18,pos19,pos20,pos21,pos22,pos23)
 	.s Data=Data1_Data2
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^CacheTemp("StaHDMPyInfection",$j)
	s Data1=$lb("合计:",sumctJZ)
    s Data2=$lb(sumpos1,sumpos2,sumpos3,sumpos4,sumpos5,sumpos6,sumpos7,sumpos8,sumpos9,sumpos10,sumpos11,sumpos12,sumpos13,sumpos14,sumpos15,sumpos16,sumpos17,sumpos18,sumpos19,sumpos20,sumpos21,sumpos22,sumpos23)
 	s Data=Data1_Data2
 	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	Quit $$$OK
}

ClassMethod QryHDMRepByPyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHDMRepByPyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHDMRepByPyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHDMRepByPyExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-07-24
/// Description:  统计某段时间内的报告抗生素使用情况
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfectionStati","QryRepDrugByInfo","3","2010-07-01","2010-08-01","","")          
/// Return：
Query QryRepDrugByInfo(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "LocDesc:%String,ctjcr:%String,ctUsered:%String,ctUseredl:%String,ctUnUser:%String,Aim1:%String,Aim2:%String,Aim3:%String,Unite1:%String,Unite2:%String,Unite3:%String,Unite4:%String,CureMode2:%String,CureMode2l:%String,CureMode1:%String")
{
}

ClassMethod QryRepDrugByInfoExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
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
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
 	..//w rowid,!
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..s ^CacheTemp("StaHDMDrugInf", $j,PatLoc,"ctjcr")=+$g(^CacheTemp("StaHDMDrugInf", $j,PatLoc,"ctjcr"))+1
	..i $d(^DHCMed.INF.RepDrugI("InfRepDr",rowid)) d
	...s ^CacheTemp("StaHDMDrugInf", $j,PatLoc,"ctUsered")=+$g(^CacheTemp("StaHDMDrugInf", $j,PatLoc,"ctUsered"))+1
	..e  d
	...s ^CacheTemp("StaHDMDrugInf", $j,PatLoc,"ctUnUser")=+$g(^CacheTemp("StaHDMDrugInf", $j,PatLoc,"ctUnUser"))+1
	..s DurgID=""
	..f  s DurgID=$o(^DHCMed.INF.RepDrugI("InfRepDr",rowid,DurgID)) q:DurgID=""  d
	...s objDrug=##class(DHCMed.INF.RepDrug).%OpenId(DurgID)
	...q:'$IsObject(objDrug)
	...s AimCode=objDrug.Aim
	...i AimCode'="" d
	....s ^CacheTemp("StaHDMDrugInf", $j,PatLoc,"Aim",AimCode)=+$g(^CacheTemp("StaHDMDrugInf", $j,PatLoc,"Aim",AimCode))+1
	...s UniteCode=objDrug.UniteDrug
	...i UniteCode'="" d
	....s ^CacheTemp("StaHDMDrugInf", $j,PatLoc,"Unite",UniteCode)=+$g(^CacheTemp("StaHDMDrugInf", $j,PatLoc,"Unite",UniteCode))+1
	...s CureDrugMode=objDrug.CureDrugMode
	...i CureDrugMode'="" d
	....s ^CacheTemp("StaHDMDrugInf", $j,PatLoc,"CureMode",CureDrugMode)=+$g(^CacheTemp("StaHDMDrugInf", $j,PatLoc,"CureMode",CureDrugMode))+1
	...k objDrug
	..k objCls
	s getLoc=""
	//1 -治疗  2- 预防 3-治疗+预防 4 无指针 
	//1 单联   2 二两  3 三联      4 四联  5 四联以上
	//1 经验   2 药敏用药
    s (sumctjcr,sumctUsered,sumctUnUser,sumAim1,sumAim2,sumAim3,sumUnite1,sumUnite2,sumUnite3,sumUnite4)=0
    s (sumCureMode1,sumCureMode2)=0
    f  s getLoc=$o(^CacheTemp("StaHDMDrugInf", $j,getLoc)) q:getLoc=""  d
    .s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(getLoc)
    .q:'$IsObject(objLoc)
    .s LocDesc=objLoc.Descs
    .s ctjcr=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"ctjcr"))
    .s ctUsered=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"ctUsered"))
    .s ctUseredl="0%"
    .s:ctjcr'=0 ctUseredl=+$fn((ctUsered*100)/ctjcr,"+",4)_"%"
    .s ctUnUser=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"ctUnUser"))
    .s Aim1=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"Aim",1))
    .s Aim2=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"Aim",2))
    .s Aim3=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"Aim",3))
    .s Unite1=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"Unite",1))
    .s Unite2=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"Unite",2))
    .s Unite3=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"Unite",3))
    .s Unite4=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"Unite",4))+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"Unite",5))
    .s CureMode1=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"CureMode",1))
    .s CureMode2=+$g(^CacheTemp("StaHDMDrugInf", $j,getLoc,"CureMode",2))
    .s CureMode2l="0%"
    .s:(CureMode1+CureMode2)'=0 CureMode2l=+$fn((CureMode2*100)/(CureMode1+CureMode2),"+",4)_"%"
    .s sumctjcr=sumctjcr+ctjcr
    .s sumctUsered=sumctUsered+ctUsered
    .s sumctUnUser=sumctUnUser+ctUnUser
    .s sumAim1=sumAim1+Aim1
    .s sumAim2=sumAim2+Aim2
    .s sumAim3=sumAim3+Aim3
    .s sumUnite1=sumUnite1+Unite1
    .s sumUnite2=sumUnite2+Unite2
    .s sumUnite3=sumUnite3+Unite3
    .s sumUnite4=sumUnite4+Unite4
    .s sumCureMode1=sumCureMode1+CureMode1
    .s sumCureMode2=sumCureMode2+CureMode2
    .s Data1=$lb(LocDesc,ctjcr,ctUsered,ctUseredl,ctUnUser)
    .s Data2=$lb(Aim1,Aim2,Aim3,Unite1,Unite2,Unite3,Unite4,CureMode2,CureMode2l,CureMode1)
 	.s Data=Data1_Data2
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^CacheTemp("StaHDMDrugInf",$j)
	s sumctUseredl="0%"
	s:sumctjcr'=0 sumctUseredl=+$fn((sumctUsered*100)/sumctjcr,"+",4)_"%"
	s sumCureMode2l="0%"
	s:(sumCureMode1+sumCureMode2)'=0 sumCureMode2l=+$fn((sumCureMode2*100)/(sumCureMode1+sumCureMode2),"+",4)_"%"
	s Data1=$lb("合计:",sumctjcr,sumctUsered,sumctUseredl,sumctUnUser)
    s Data2=$lb(sumAim1,sumAim2,sumAim3,sumUnite1,sumUnite2,sumUnite3,sumUnite4,sumCureMode2,sumCureMode2l,sumCureMode1)
 	s Data=Data1_Data2
 	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	Quit $$$OK
}

ClassMethod QryRepDrugByInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepDrugByInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepDrugByInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepDrugByInfoExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-07-24
/// Description:  统计某段时间内的报告科室手术情况
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfectionStati","QryRepOprByInfo","5","2010-07-01","2010-08-01","","")          
/// Return：
Query QryRepOprByInfo(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "LocDesc:%String,ctOpr:%String,QKCount:%String,ctInf:%String,ctInfl:%String")
{
}

ClassMethod QryRepOprByInfoExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
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
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
 	..//w rowid,!
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..//s ^CacheTemp("StaWKSSInf", $j,PatLoc,"ctjcr")=+$g(^CacheTemp("StaWKSSInf", $j,PatLoc,"ctjcr"))+1
	..i $d(^DHCMed.INF.RepOPRI("InfRepDr",rowid)) d
	...s ^CacheTemp("StaWKSSInf", $j,PatLoc,"ctOpr")=+$g(^CacheTemp("StaWKSSInf", $j,PatLoc,"ctOpr"))+1
	..s QKCount=0
	..s InfFlag=0
	..s OPRID=""
	..f  s OPRID=$o(^DHCMed.INF.RepOPRI("InfRepDr",rowid,OPRID)) q:OPRID=""  d
	...s objOPR=##class(DHCMed.INF.RepOPR).%OpenId(OPRID)
	...q:'$IsObject(objOPR)
	...s QKCount=QKCount+objOPR.ResumeText
	...s:(objOPR.InfectionFlag=1)!(objOPR.InfectionFlag="Y") InfFlag=1
	...k objOPR
	..s ^CacheTemp("StaWKSSInf", $j,PatLoc,"QKCount")=+$g(^CacheTemp("StaWKSSInf", $j,PatLoc,"QKCount"))+QKCount
	..s:InfFlag=1 ^CacheTemp("StaWKSSInf", $j,PatLoc,"ctInf")=+$g(^CacheTemp("StaWKSSInf", $j,PatLoc,"ctInf"))+1
	..k objCls
	s getLoc=""
    s (sumctOpr,sumQKCount,sumctInf)=0
    f  s getLoc=$o(^CacheTemp("StaWKSSInf", $j,getLoc)) q:getLoc=""  d
    .s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(getLoc)
    .q:'$IsObject(objLoc)
    .s LocDesc=objLoc.Descs
    .s ctOpr=+$g(^CacheTemp("StaWKSSInf", $j,getLoc,"ctOpr"))
    .s QKCount=+$g(^CacheTemp("StaWKSSInf", $j,getLoc,"QKCount"))
    .s ctInf=+$g(^CacheTemp("StaWKSSInf", $j,getLoc,"ctInf"))
    .s ctInfl="0%"
    .s:ctOpr'=0 ctInfl=+$fn((ctInf*100)/ctOpr,"+",4)_"%"
    .s sumctOpr=sumctOpr+ctOpr
    .s sumQKCount=sumQKCount+QKCount
    .s sumctInf=sumctInf+ctInf
    .s Data1=$lb(LocDesc,ctOpr,QKCount,ctInf)
    .s Data2=$lb(ctInfl)
 	.s Data=Data1_Data2
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^CacheTemp("StaWKSSInf",$j)
	s sumctInfl="0%"
	s:sumctOpr'=0 sumctInfl=+$fn((sumctInf*100)/sumctOpr,"+",4)_"%"
	s Data1=$lb("合计:",sumctOpr,sumQKCount,sumctInf)
    s Data2=$lb(sumctInfl)
 	s Data=Data1_Data2
 	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	Quit $$$OK
}

ClassMethod QryRepOprByInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepOprByInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepOprByInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepOprByInfoExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-07-24
/// Description:  统计某段时间内的报告科室手术名称情况
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfectionStati","QryRepOprNameByInfo","5","2010-07-01","2010-08-01","","")          
/// Return：
Query QryRepOprNameByInfo(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "OprDesc:%String,WXDJCode:%String,count:%String,InfCount:%String,InfCountl:%String")
{
}

ClassMethod QryRepOprNameByInfoExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
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
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
 	..//w rowid,!
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..//s ^CacheTemp("StaWKSSDocInf", $j,PatLoc,"ctjcr")=+$g(^CacheTemp("StaWKSSDocInf", $j,PatLoc,"ctjcr"))+1
	..s OPRID=""
	..f  s OPRID=$o(^DHCMed.INF.RepOPRI("InfRepDr",rowid,OPRID)) q:OPRID=""  d
	...s objOPR=##class(DHCMed.INF.RepOPR).%OpenId(OPRID)
	...q:'$IsObject(objOPR)
	...s OprDesc=objOPR.OperationDesc
	...s WXDJ=objOPR.OprDangerCls
	...s:(objOPR.InfectionFlag=1)!(objOPR.InfectionFlag="Y") ^CacheTemp("StaWKSSDocInf", $j,OprDesc,"InfCount")=+$g(^CacheTemp("StaWKSSDocInf", $j,OprDesc,"InfCount"))+1
	...s ^CacheTemp("StaWKSSDocInf", $j,OprDesc,"Count")=+$g(^CacheTemp("StaWKSSDocInf", $j,OprDesc,"Count"))+1
	...s:WXDJ'="" ^CacheTemp("StaWKSSDocInf", $j,OprDesc,"WXDJ",WXDJ)=""
	...k objOPR
	..k objCls
	s OprDesc=""
    s (sumctOpr,sumQKCount,sumctInf)=0
    f  s OprDesc=$o(^CacheTemp("StaWKSSDocInf", $j,OprDesc)) q:OprDesc=""  d
    .//s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(getLoc)
    .//q:'$IsObject(objLoc)
    .//s LocDesc=objLoc.Descs
    .s count=+$g(^CacheTemp("StaWKSSDocInf", $j,OprDesc,"Count"))
    .s InfCount=+$g(^CacheTemp("StaWKSSDocInf", $j,OprDesc,"InfCount"))
    .s WXDJCode=""
    .s tmpCode=""
    .f  s tmpCode=$o(^CacheTemp("StaWKSSDocInf", $j,OprDesc,"WXDJ",tmpCode)) q:tmpCode=""  d
    ..i tmpCode'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(tmpCode,"OprDangerCls")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s:WXDJCode'="" WXDJCode=WXDJCode_","_objDic.Description
    ...s:WXDJCode="" WXDJCode=objDic.Description
    ...k objDic
    .s InfCountl="0%"
    .s:count'=0 InfCountl=+$fn((InfCount*100)/count,"+",4)_"%"
    .s Data1=$lb(OprDesc,WXDJCode,count,InfCount)
    .s Data2=$lb(InfCountl)
 	.s Data=Data1_Data2
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^CacheTemp("StaWKSSDocInf",$j)
	Quit $$$OK
}

ClassMethod QryRepOprNameByInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepOprNameByInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepOprNameByInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepOprNameByInfoExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-07-25
/// Description:  统计某段时间内的报告科室手术术者情况
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfectionStati","QryRepOprDocByInfo","5","2010-07-01","2010-08-01","","")          
/// Return：
Query QryRepOprDocByInfo(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "DocDesc:%String,count:%String,InfCount:%String,InfCountl:%String,TZl:%String,AvWXDJ:%String")
{
}

ClassMethod QryRepOprDocByInfoExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
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
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
 	..//w rowid,!
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..//s ^CacheTemp("StaWKSSDocInfection", $j,PatLoc,"ctjcr")=+$g(^CacheTemp("StaWKSSDocInf", $j,PatLoc,"ctjcr"))+1
	..s OPRID=""
	..f  s OPRID=$o(^DHCMed.INF.RepOPRI("InfRepDr",rowid,OPRID)) q:OPRID=""  d
	...s objOPR=##class(DHCMed.INF.RepOPR).%OpenId(OPRID)
	...q:'$IsObject(objOPR)
	...s OprDoc=objOPR.OprDoc
	...s:OprDoc'="" ^CacheTemp("StaWKSSDocInfection", $j,OprDoc,"Paadm",rowid)=""
	...s WXDJ=objOPR.OprDangerCls
	...s:(objOPR.InfectionFlag=1)!(objOPR.InfectionFlag="Y") ^CacheTemp("StaWKSSDocInfection", $j,OprDoc,"InfCount",rowid)=""
	...s:WXDJ'="" ^CacheTemp("StaWKSSDocInfection", $j,OprDoc,"WXDJ",WXDJ)=""
	...k objOPR
	..k objCls
	s DocID=""
    f  s DocID=$o(^CacheTemp("StaWKSSDocInfection", $j,DocID)) q:DocID=""  d
    .s objDoc=##class(DHCMed.Base.SSUser).GetObjById(DocID)
    .q:'$IsObject(objDoc)
    .s DocDesc=objDoc.Name
    .s tmpRowid=""
    .s count=0
    .f  s tmpRowid=$o(^CacheTemp("StaWKSSDocInfection", $j,DocID,"Paadm",tmpRowid)) q:tmpRowid=""  d
    ..s count=count+1
    .s InfCount=0
    .s tmpRowid=""
    .f  s tmpRowid=$o(^CacheTemp("StaWKSSDocInfection", $j,DocID,"InfCount",tmpRowid)) q:tmpRowid=""  d
    ..s InfCount=InfCount+1
    .s WXDJ=0
    .s WXDJCt=0
    .s tmpCode=""
    .f  s tmpCode=$o(^CacheTemp("StaWKSSDocInfection", $j,DocID,"WXDJ",tmpCode)) q:tmpCode=""  d
    ..i tmpCode'="" d
    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(tmpCode,"OprDangerCls")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ...q:'$IsObject(objDic)
    ...s WXDJ=WXDJ+objDic.Description
    ...s WXDJCt=WXDJCt+1
    ...k objDic
    .s AvWXDJ=0
    .s:WXDJCt'=0 AvWXDJ=WXDJ/WXDJCt
    .s InfCountl="0%"
    .s:count'=0 InfCountl=+$fn((InfCount*100)/count,"+",4)_"%"
    .s Data1=$lb(DocDesc,count,InfCount,InfCountl)
    .s Data2=$lb("0.0%",AvWXDJ)
 	.s Data=Data1_Data2
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^CacheTemp("StaWKSSDocInfection",$j)
	Quit $$$OK
}

ClassMethod QryRepOprDocByInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepOprDocByInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepOprDocByInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepOprDocByInfoExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-07-23
/// Description:  统计某段时间内的多重耐药菌统计
/// Table：       All
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfectionStati","QryDCNYRepByPy","4","2010-07-01","2010-08-01","","")          
/// Return：
Query QryDCNYRepByPy(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Query(ROWSPEC = "LocDesc:%String,MDRAB:%String,MDRPA:%String,MRSA:%String,VER:%String,ESBLs:%String,ESBLsFK:%String,Tmp:%String")
{
}

ClassMethod QryDCNYRepByPyExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", cInfPlace As %String = "") As %Status
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
    s tmpDt=DateFrom-1
 	f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
 	..//w rowid,!
	..q:'$IsObject(objCls)
	..s PatLoc=objCls.CtLoc
	..q:(cLoc'="")&(cLoc'=PatLoc)
	..//s ^CacheTemp("StaHDMPyInfection", $j,PatLoc,"ctjcr")=+$g(^CacheTemp("StaHDMPyInfection", $j,PatLoc,"ctjcr"))+1
	..s sumID=""
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s objSum=##class(DHCMed.INF.Summary).%OpenId(sumID)
	...q:'$IsObject(objSum)
	...s tmpInfPlace=objSum.InfPlace
	...q:(cInfPlace'="")&(cInfPlace'=tmpInfPlace)
	...s LabID=""
	...f  s LabID=$o(^DHCMed.INF.PathogenyI("InfRepDr",rowid,LabID)) q:LabID=""  d
	....s objLab=##class(DHCMed.INF.Pathogeny).%OpenId(LabID)
	....q:'$IsObject(objLab)
	....s Oeorid=objLab.OEORIDR
	....//可增加是否关联判断
	....s PyID=""
	....f  s PyID=$o(^DHCMed.INF.PyObjI("InfPathDr",LabID,PyID)) q:PyID=""  d
	.....s objPy=##class(DHCMed.INF.PyObj).%OpenId(PyID)
	.....q:'$IsObject(objPy)
	.....s PyDicID=objPy.Object
	.....q:PyDicID=""
	.....s ^CacheTemp("StaDCNYPyInfection", $j,PatLoc,PyDicID)=+$g(^CacheTemp("StaDCNYPyInfection", $j,PatLoc,PyDicID))+1
    .....k objPy
    ....k objLab
    ...k objSum
    ..k objCls
    s getLoc=""
    s (sumMDRAB,sumMDRPA,sumMRSA,sumVER,sumESBLs,sumESBLsFK,sumTmp)=0
    //s (sumpos8,sumpos9,sumpos10,sumpos11,sumpos12,sumpos13,sumpos14,sumpos15,sumpos16,sumpos17,sumpos18,sumpos19,sumpos20,sumpos21,sumpos22,sumpos23)=0
    f  s getLoc=$o(^CacheTemp("StaDCNYPyInfection", $j,getLoc)) q:getLoc=""  d
    .s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(getLoc)
    .q:'$IsObject(objLoc)
    .s LocDesc=objLoc.Descs
    .//s ctJZ=0
    .s MDRAB=+$g(^CacheTemp("StaDCNYPyInfection", $j,getLoc,126))   // 鲍曼不动杆菌
    .s MDRPA=+$g(^CacheTemp("StaDCNYPyInfection", $j,getLoc,116))   // 铜绿假单胞菌
    .s MRSA=+$g(^CacheTemp("StaDCNYPyInfection", $j,getLoc,8))      //耐甲氧西林金黄色葡萄球菌
    .s VER=+$g(^CacheTemp("StaDCNYPyInfection", $j,getLoc,23))      
    .s ESBLs=+$g(^CacheTemp("StaDCNYPyInfection", $j,getLoc,79))  // 超广谱β-内酰胺酶
    .s ESBLsFK=+$g(^CacheTemp("StaDCNYPyInfection", $j,getLoc,72))  //超广谱β-内酰胺酶肺克
    .s Tmp=+$g(^CacheTemp("StaDCNYPyInfection", $j,getLoc,1))     // 待用
    .s sumMDRAB=sumMDRAB+MDRAB
    .s sumMDRPA=sumMDRPA+MDRPA
    .s sumMRSA=sumMRSA+MRSA
    .s sumVER=sumVER+VER
    .s sumESBLs=sumESBLs+ESBLs
    .s sumESBLsFK=sumESBLsFK+ESBLsFK
    .s sumTmp=sumTmp+Tmp
    .s Data1=$lb(LocDesc,MDRAB)
    .s Data2=$lb(MDRPA,MRSA,VER,ESBLs,ESBLsFK,Tmp)
 	.s Data=Data1_Data2
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^CacheTemp("StaDCNYPyInfection",$j)
	s Data1=$lb("合计:",sumMDRAB)
    s Data2=$lb(sumMDRPA,sumMRSA,sumVER,sumESBLs,sumESBLsFK,sumTmp)
 	s Data=Data1_Data2
 	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	Quit $$$OK
}

ClassMethod QryDCNYRepByPyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDCNYRepByPyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDCNYRepByPyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDCNYRepByPyExecute ]
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
