/// 名称: DHCMed.INFService.BorthWeightSrv
/// 描述: ICU病情等级人数
/// 编写者：liuyh
/// 编写日期: 2011-03-21
Class DHCMed.INFService.BorthWeightSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     lyh
/// CreatDate：   2011-03-21
/// Description:  查询ICU病情等级人数
/// Input：      
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.BorthWeightSrv","QueryICUGradeInfo","","")
Query QueryICUGradeInfo(ctloc As %String, ReportDate As %String) As %Query(ROWSPEC = "rowid:%String,CtlocDr:%String,ReportDate:%String,Month:%String,WeekOneA:%String,WeekTwoA:%String,WeekThreeA:%String,WeekFourA:%String,WeekOneB:%String,WeekTwoB:%String,WeekThreeB:%String,WeekFourB:%String,WeekOneC:%String,WeekTwoC:%String,WeekThreeC:%String,WeekFourC:%String,WeekOneD:%String,WeekTwoD:%String,WeekThreeD:%String,WeekFourD:%String,WeekOneE:%String,WeekTwoE:%String,WeekThreeE:%String,WeekFourE:%String,RepUser:%String,RepDate:%String,CtlocDesc:%String,YearStr:%String,MonthStr:%String")
{
}

ClassMethod QueryICUGradeInfoExecute(ByRef qHandle As %Binary, ctloc As %String, ReportDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	s:ReportDate["-" ReportDate=$zdh(ReportDate,3)
	f  s rowid=$o(^DHCMed.INF.BorthWeightD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.BorthWeight).%OpenId(rowid)
	.s (CtlocDesc,YearStr,MonthStr)=""
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.CtlocDr
	.s $li(data,3)=obj.ReportDate
	.q:((ctloc'="")&(ctloc'=obj.CtlocDr))
	.q:((ReportDate'="")&(ReportDate'=obj.ReportDate))
	.s:obj.ReportDate'="" $li(data,3)=$zd(obj.ReportDate,3)
	.s $li(data,5)=obj.WeekOneA
	.s $li(data,6)=obj.WeekTwoA
	.s $li(data,7)=obj.WeekThreeA
	.s $li(data,8)=obj.WeekFourA
	.s $li(data,9)=obj.WeekOneB
	.s $li(data,10)=obj.WeekTwoB
	.s $li(data,11)=obj.WeekThreeB
	.s $li(data,12)=obj.WeekFourB
	.s $li(data,13)=obj.WeekOneC
	.s $li(data,14)=obj.WeekTwoC
	.s $li(data,15)=obj.WeekThreeC
	.s $li(data,16)=obj.WeekFourC
	.s $li(data,17)=obj.WeekOneD
	.s $li(data,18)=obj.WeekTwoD
	.s $li(data,19)=obj.WeekThreeD
	.s $li(data,20)=obj.WeekFourD
	.s $li(data,21)=obj.WeekOneE
	.s $li(data,22)=obj.WeekTwoE
	.s $li(data,23)=obj.WeekThreeE
	.s $li(data,24)=obj.WeekFourE
	.s $li(data,25)=obj.RepUser
	.s $li(data,26)=obj.RepDate
	.s:$d(^CTLOC(obj.CtlocDr)) CtlocDesc=$p($g(^CTLOC(obj.CtlocDr)),"^",2)
	.s YearStr=""
	.s MonthStr=""
	.s $li(data,27)=CtlocDesc
	.s $li(data,28)=YearStr
	.s $li(data,29)=MonthStr
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryICUGradeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICUGradeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryICUGradeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICUGradeInfoExecute ]
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

/// Creator：     lyh
/// CreatDate：   2011-03-25
/// Description:  根据时间、科室查询ICU等级
/// Input：      
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.BorthWeightSrv","QueryICUGradeByDate","2011","1","2013","1","")
Query QueryICUGradeByDate(strYear As %String, strMonth As %String, toYear As %String, toMonth As %String, ctloc As %String) As %Query(ROWSPEC = "ctloc:%String,grade:%String")
{
}

ClassMethod QueryICUGradeByDateExecute(ByRef qHandle As %Binary, strYear As %String, strMonth As %String, toYear As %String, toMonth As %String, ctloc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	q:strYear="" $$$OK
	q:strMonth="" $$$OK
	q:toYear="" $$$OK
	q:toMonth="" $$$OK
	s sDate=$zdh(strYear_"-"_strMonth_"-"_28,3)
	s eDate=$zdh(toYear_"-"_toMonth_"-"_28,3)
	
	s rowid=""

	f  s rowid=$o(^DHCMed.INF.BorthWeightD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.BorthWeight).%OpenId(rowid)
	.s (CtlocDesc,YearStr,MonthStr)=""
	.q:((ctloc'="")&(ctloc'=obj.CtlocDr))
	.q:sDate>$zdh(obj.Year_"-"_obj.Month_"-"_28,3)
	.q:eDate<$zdh(obj.Year_"-"_obj.Month_"-"_28,3)
	.s ^TMP("DHCMedICU",obj.CtlocDr,rowid)=""
	
	s TotalScore=""
	s TotalNum=""
	s AvgGrade=""
	s ctlocID=""
	f  s ctlocID=$o(^TMP("DHCMedICU",ctlocID)) q:ctlocID=""  d
	.s (rowid,grade,gradeA,gradeB,gradeC,gradeD,gradeE,CtlocDesc)=""
	.f  s rowid=$o(^TMP("DHCMedICU",ctlocID,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.INF.BorthWeight).%OpenId(rowid)
	..q:'$IsObject(obj)
	..s gradeA=gradeA+(obj.WeekOneA+obj.WeekTwoA+obj.WeekThreeA+obj.WeekFourA)
	..s gradeB=gradeB+(obj.WeekOneB+obj.WeekTwoB+obj.WeekThreeB+obj.WeekFourB)
	..s gradeC=gradeC+(obj.WeekOneC+obj.WeekTwoC+obj.WeekThreeC+obj.WeekFourC)
	..s gradeD=gradeD+(obj.WeekOneD+obj.WeekTwoD+obj.WeekThreeD+obj.WeekFourD)
	..s gradeE=gradeE+(obj.WeekOneE+obj.WeekTwoE+obj.WeekThreeE+obj.WeekFourE)
	.s:(gradeA+gradeB+gradeC+gradeD+gradeE)>0 grade=(gradeA + (2*gradeB) + (3*gradeC) + (4*gradeD) + (5*gradeE))/(gradeA+gradeB+gradeC+gradeD+gradeE)
	.s TotalScore=TotalScore+(gradeA + (2*gradeB) + (3*gradeC) + (4*gradeD) + (5*gradeE))
	.s TotalNum=TotalNum+(gradeA+gradeB+gradeC+gradeD+gradeE)
	.s:$d(^CTLOC(ctlocID)) CtlocDesc=$p($g(^CTLOC(ctlocID)),"^",2)
	.s $li(data,1)=CtlocDesc
	.s $li(data,2)=$e(grade,1,4)
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	
	s:TotalNum>0 AvgGrade=TotalScore/TotalNum
	s $li(data,1)="全院"
	s $li(data,2)=$e(AvgGrade,1,4)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	k ^TMP("DHCMedICU")
	q $$$OK
}

ClassMethod QueryICUGradeByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICUGradeByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryICUGradeByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICUGradeByDateExecute ]
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

/// Creator：     lyh
/// CreatDate：   2011-07-28
/// Description:  根据时间、科室查询新生儿目标监测数据
/// Input：      
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.BorthWeightSrv","QryICUBorthWeightInfo","28","2011","7")
Query QryICUBorthWeightInfo(LocID As %String, Year As %String, Month As %String) As %Query(ROWSPEC = "ind:%String,OneA:%String,OneB:%String,OneC:%String,OneD:%String,TwoA:%String,TwoB:%String,TwoC:%String,TwoD:%String,ThreeA:%String,ThreeB:%String,ThreeC:%String,ThreeD:%String,FourA:%String,FourB:%String,FourC:%String,FourD:%String")
{
}

ClassMethod QryICUBorthWeightInfoExecute(ByRef qHandle As %Binary, LocID As %String, Year As %String, Month As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:(LocID="")||(Year="")||(Month="") $$$OK
	
	i Month<12 d
	.s sMonth=Month+1
	.s LastDate=$zdh(+Year_"-"_sMonth_"-"_1,3)-1
	.s days=$p($zd(LastDate,3),"-",3)
	i Month>11 d
	.s Month=12
	.s days=31
	
	f i=1:1:days d
	.s (OneA,OneB,OneC,OneD,TwoA,TwoB,TwoC,TwoD,ThreeA,ThreeB,ThreeC,ThreeD,FourA,FourB,FourC,FourD)=""
	.s ReportDate=+$zdh(+Year_"-"_Month_"-"_i,3)
	.s rowid=$o(^DHCMed.INF.BorthWeightI("YearIndex"," "_ReportDate," "_LocID,""))
	.i rowid'="" d
	..s obj=##Class(DHCMed.INF.BorthWeight).GetObjById(rowid)
	..q:'$IsObject(obj)
	..s OneA=obj.WeekOneA
	..s OneB=obj.WeekOneB
	..s OneC=obj.WeekOneC
	..s OneD=obj.WeekOneD
	..s TwoA=obj.WeekTwoA
	..s TwoB=obj.WeekTwoB
	..s TwoC=obj.WeekTwoC
	..s TwoD=obj.WeekTwoD
	..s ThreeA=obj.WeekThreeA
	..s ThreeB=obj.WeekThreeB
	..s ThreeC=obj.WeekThreeC
	..s ThreeD=obj.WeekThreeD
	..s FourA=obj.WeekFourA
	..s FourB=obj.WeekFourB
	..s FourC=obj.WeekFourC
	..s FourD=obj.WeekFourD
	.s Data=$lb(ind,OneA,OneB,OneC,OneD,TwoA,TwoB,TwoC,TwoD,ThreeA,ThreeB,ThreeC,ThreeD,FourA,FourB,FourC,FourD)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryICUBorthWeightInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUBorthWeightInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUBorthWeightInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUBorthWeightInfoExecute ]
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

/// Creator：     lyh
/// CreatDate：   2011-07-28
/// Description:  根据时间、科室查询新生儿目标监测数据
/// Input：      
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.BorthWeightSrv","QryICUBWeightMonthInfo","28","2011","7")
Query QryICUBWeightMonthInfo(LocID As %String, Year As %String, Month As %String) As %Query(ROWSPEC = "ind:%String,OneA:%String,OneB:%String,OneC:%String,OneD:%String,TwoA:%String,TwoB:%String,TwoC:%String,TwoD:%String,ThreeA:%String,ThreeB:%String,ThreeC:%String,ThreeD:%String,FourA:%String,FourB:%String,FourC:%String,FourD:%String")
{
}

ClassMethod QryICUBWeightMonthInfoExecute(ByRef qHandle As %Binary, LocID As %String, Year As %String, Month As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:(LocID="")||(Year="")||(Month="") $$$OK
	
	s (TOneA,TOneB,TOneC,TOneD,TTwoA,TTwoB,TTwoC,TTwoD,TThreeA,TThreeB,TThreeC,TThreeD,TFourA,TFourB,TFourC,TFourD)=0
	f i=1:1:31 d
	.s (OneA,OneB,OneC,OneD,TwoA,TwoB,TwoC,TwoD,ThreeA,ThreeB,ThreeC,ThreeD,FourA,FourB,FourC,FourD)=0
	.s ReportDate=+$zdh(+Year_"-"_+Month_"-"_i,3)
	.s rowid=$o(^DHCMed.INF.BorthWeightI("YearIndex"," "_ReportDate," "_LocID,""))
	.i rowid'="" d
	..s obj=##Class(DHCMed.INF.BorthWeight).GetObjById(rowid)
	..q:'$IsObject(obj)
	..s OneA=obj.WeekOneA
	..s OneB=obj.WeekOneB
	..s OneC=obj.WeekOneC
	..s OneD=obj.WeekOneD
	..s TwoA=obj.WeekTwoA
	..s TwoB=obj.WeekTwoB
	..s TwoC=obj.WeekTwoC
	..s TwoD=obj.WeekTwoD
	..s ThreeA=obj.WeekThreeA
	..s ThreeB=obj.WeekThreeB
	..s ThreeC=obj.WeekThreeC
	..s ThreeD=obj.WeekThreeD
	..s FourA=obj.WeekFourA
	..s FourB=obj.WeekFourB
	..s FourC=obj.WeekFourC
	..s FourD=obj.WeekFourD
	.s TOneA=TOneA+OneA
	.s TOneB=TOneB+OneB
	.s TOneC=TOneC+OneC
	.s TOneD=TOneD+OneD
	.s TTwoA=TTwoA+TwoA
	.s TTwoB=TTwoB+TwoB
	.s TTwoC=TTwoC+TwoC
	.s TTwoD=TTwoD+TwoD
	.s TThreeA=TThreeA+ThreeA
	.s TThreeB=TThreeB+ThreeB
	.s TThreeC=TThreeC+ThreeC
	.s TThreeD=TThreeD+ThreeD
	.s TFourA=TFourA+FourA
	.s TFourB=TFourB+FourB
	.s TFourC=TFourC+FourC
	.s TFourD=TFourD+FourD
	
	s Data=$lb(ind,TOneA,TOneB,TOneC,TOneD,TTwoA,TTwoB,TTwoC,TTwoD,TThreeA,TThreeB,TThreeC,TThreeD,TFourA,TFourB,TFourC,TFourD)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryICUBWeightMonthInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUBWeightMonthInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUBWeightMonthInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUBWeightMonthInfoExecute ]
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

/// w ##Class(DHCMed.INFService.BorthWeightSrv).ICUBWeightMonthInfo("fillxlSheet","28^2011^7")
ClassMethod ICUBWeightMonthInfo(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	s LocID=$p(strArguments,"^",1)
	s year=$p(strArguments,"^",2)
	s month=$p(strArguments,"^",3)
	
	q:(LocID="")||(year="")||(month="") ""
	s ds = ##class(%Library.ResultSet).%New("DHCMed.INFService.BorthWeightSrv:QryICUBWeightMonthInfo")
	d ds.Execute(LocID,year,month)
	while(ds.Next())
	{
	
	s OneA=ds.Data("OneA")
	s OneB=ds.Data("OneB")
	s OneC=ds.Data("OneC")
	s OneD=ds.Data("OneD")
	s TwoA=ds.Data("TwoA")
	s TwoB=ds.Data("TwoB")
	s TwoC=ds.Data("TwoC")
	s TwoD=ds.Data("TwoD")
	s ThreeA=ds.Data("ThreeA")
	s ThreeB=ds.Data("ThreeB")
	s ThreeC=ds.Data("ThreeC")
	s ThreeD=ds.Data("ThreeD")
	s FourA=ds.Data("FourA")
	s FourB=ds.Data("FourB")
	s FourC=ds.Data("FourC")
	s FourD=ds.Data("FourD")
	
	s StartRow=4
	s valCells=OneA_$c(1)_TwoA_$c(1)_ThreeA_$c(1)_FourA_$c(1)
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",2);"
	&javascript<#(retval)#>
	
	s StartRow=5
	s valCells=OneB_$c(1)_TwoB_$c(1)_ThreeB_$c(1)_FourB_$c(1)
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",2);"
	&javascript<#(retval)#>
	
	s StartRow=6
	s valCells=OneC_$c(1)_TwoC_$c(1)_ThreeC_$c(1)_FourC_$c(1)
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",2);"
	&javascript<#(retval)#>
	
	s StartRow=7
	s valCells=OneD_$c(1)_TwoD_$c(1)_ThreeD_$c(1)_FourD_$c(1)
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",2);"
	&javascript<#(retval)#>
	
	s StartRow=2
	s valCells=year_" 年 "_month_" 月"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",5);"
	&javascript<#(retval)#>
	
	d ds.Close()
	
	}
	q Count
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// 	w ##Class(DHCMed.INFService.BorthWeightSrv).GetServerInfo()
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

}
