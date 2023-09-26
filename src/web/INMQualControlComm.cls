/// Creator:wangpf
/// Desctiptions:质控模块方法类
/// Date:2020-06-02
Class web.INMQualControlComm Extends %RegisteredObject
{

/// Description：查询系统质控类型
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CT.DHCINM.Set.MgSysParam CT.DHCINM.Set.MgSysParamSub
/// Input: Q：非夜查房类型 N：夜查房类型 空：全部类型
/// Output:系统质控类型
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQualTypeList","")
Query FindQualTypeList(type As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQualTypeListExecute(ByRef qHandle As %Binary, type As %String = "") As %Status
{
 	s repid=$I(^CacheTemp)
 	s ind=1
 	
 	s now=+$h
 	s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALTYPE",""))
 	i parId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubD(parId,subId)) q:subId=""  d
 	.s subGlo=^CT.DHCINM.Set.MgSysParamSubD(parId,subId)
 	.s stDate=$lg(subGlo,8)
 	.s endDate=$lg(subGlo,9)
 	.q:((stDate="")||(stDate>now))||((endDate'="")&&(endDate<now))
 	.s code=$lg(subGlo,2)
 	.s desc=$lg(subGlo,3)
 	.s ZCODE=$ZCVT(code,"U")
 	.s remark=$lg(subGlo,7)
 	.s tRemark=$tr($zcvt(remark,"U"),"YN,")
 	.i (remark'="")&&(tRemark="") d
 	..s remark=$zcvt(remark,"U")
 	..s isNightCheck=$case($p(remark,","),"Y":"Y",:"N")
 	..s isNeedSign=$case($p(remark,",",2),"Y":"Y",:"N")
 	..s isNeedPass=$case($p(remark,",",3),"Y":"Y",:"N")
 	..s isNeedDiff=$case($p(remark,",",4),"Y":"Y",:"N")
 	.e  i (ZCODE="NIGHTCHECK")||(ZCODE="WEEKCHECK")||(ZCODE="HOLIDAYCHECK") d
 	..s isNightCheck="Y",isNeedSign="Y",isNeedPass="Y",isNeedDiff="Y"
 	.e  d
 	..s isNightCheck="N",isNeedSign="N",isNeedPass="N",isNeedDiff="N"
 	.q:(type="Q")&&(isNightCheck="Y")
 	.q:(type="N")&&(isNightCheck="N")
 	.s ret=##class(web.INMSetComm).GetParamSub(parId_"||"_subId)
 	.s ret=ret_"^IsNightCheck|"_isNightCheck_"^IsNeedSign|"_isNeedSign_"^IsNeedPass|"_isNeedPass_"^IsNeedDiff|"_isNeedDiff
 	.d:ret'="" OutQualTypeList
 	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutQualTypeList
 	set Data=$lb(ret)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
  	q
}

ClassMethod FindQualTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQualTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualTypeListExecute ]
{
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

/// Description：查询巡查计划列表
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckPlan
/// Input:
/// Output:巡查计划列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckPlanList","2020","")
Query FindCheckPlanList(year As %String = "", type As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPlanListExecute(ByRef qHandle As %Binary, year As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s type=$tr(type,"_","|")
	s Year="" f  s Year=$o(^CF.DHCINM.CHK.CheckPlanI("Type",Year)) q:Year=""  d
	.s Type="" f  s Type=$o(^CF.DHCINM.CHK.CheckPlanI("Type",Year,Type)) q:Type=""  d
	..s RowID="" f  s RowID=$o(^CF.DHCINM.CHK.CheckPlanI("Type",Year,Type,RowID)) q:RowID=""  d
	...q:$d(^CF.DHCINM.CHK.CheckPlanD(RowID))#2'=1
	...s ObjGlo=^CF.DHCINM.CHK.CheckPlanD(RowID)
	...s ObjYear=$lg(ObjGlo,2)
	...s ObjType=$lg(ObjGlo,3)
	...s SysParId=$p(ObjType,"||")
	...s SysSubId=$p(ObjType,"||",2)
	...q:(ObjType="")||($d(^CT.DHCINM.Set.MgSysParamSubD(SysParId,SysSubId))'=1)
	...q:((year'="")&&(ObjYear'=year))
	...q:((type'="")&&(ObjType'=type))
	...s ObjTypeDesc=$lg(^CT.DHCINM.Set.MgSysParamSubD(SysParId,SysSubId),3)
	...s ret="PlanYear|"_ObjYear_"^PlanType|"_$tr(ObjType,"|","_")_"^PlanTypeDesc|"_ObjTypeDesc_"^rw|"_RowID
	...d OutPlanList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPlanListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 查询是否存在同年同类型巡查计划
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: CF.DHCINM.CHK.CheckPlan
/// Input: 年份 质控类型
/// Output: 0：不存在 1：存在
/// Other: w ##class(web.INMQualControlComm).IsExistCheckPlan("2020^5__2")
ClassMethod IsExistCheckPlan(parr) As %String
{
	s type=$tr($p(parr,"^"),"_","|")
	s year=$p(parr,"^",2)
	i $d(^CF.DHCINM.CHK.CheckPlanI("Type",year,type)) q 1
	q 0
}

/// Description：查询巡查计划
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckPlan CF.DHCINM.CHK.CheckPlanSub CT.DHCINM.DB.MgQualItem
/// Input:
/// Output:巡查计划详情列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckPlanDetailList","2020","5__2")
Query FindCheckPlanDetailList(year As %String = "", type As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPlanDetailListExecute(ByRef qHandle As %Binary, year As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (year="")||(type="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$tr(type,"_","|")
	s qualType="" f  s qualType=$o(^CT.DHCINM.DB.MgQualItemI("Type",year,qualType)) q:qualType=""  d
	.s filterType=$lfs($tr(qualType," ",""),",")
	.s index=$lf(filterType,type)
	.q:index=0
	.s qualId="" f  s qualId=$o(^CT.DHCINM.DB.MgQualItemI("Type",year,qualType,qualId)) q:qualId=""  d
	..q:$d(^CT.DHCINM.DB.MgQualItemD(qualId))#2'=1
	..s qualGlo=^CT.DHCINM.DB.MgQualItemD(qualId)
	..s QualItemDesc=$lg(qualGlo,4)
	..s Jan="false",Feb="false",Mar="false",Apr="false",May="false",Jun="false",Jul="false"
	..s Aug="false",Sep="false",Oct="false",Nov="false",Dece="false"
	..s stDate=$lg(qualGlo,14)
	..s endDate=$lg(qualGlo,15)
	..i stDate="" s stIndex=0
	..e  i +$zd(stDate,3)>year s stIndex=0
	..e  i +$zd(stDate,3)<year s stIndex=1
	..e  s stIndex=+$zd(stDate,1)
	..i endDate="" s endIndex=12
	..e  i +$zd(endDate,3)>year s endIndex=12
	..e  i +$zd(endDate,3)<year s endIndex=0
	..e  s endIndex=+$zd(endDate,1)
	..s JanFlag="false",FebFlag="false",MarFlag="false",AprFlag="false",MayFlag="false",JunFlag="false"
	..s JulFlag="false",AugFlag="false",SepFlag="false",OctFlag="false",NovFlag="false",DeceFlag="false"
	..;启用日期到停用日期得可设置,启用日期大于当前年或者停用日期小于当前年都不可设置
	..i (stIndex>0)&&(endIndex>0)&&(endIndex>=stIndex) d
	...f tIndex=stIndex:1:endIndex d
	....i tIndex=1 s JanFlag="true"
	....e  i tIndex=2 s FebFlag="true"
	....e  i tIndex=3 s MarFlag="true"
	....e  i tIndex=4 s AprFlag="true"
	....e  i tIndex=5 s MayFlag="true"
	....e  i tIndex=6 s JunFlag="true"
	....e  i tIndex=7 s JulFlag="true"
	....e  i tIndex=8 s AugFlag="true"
	....e  i tIndex=9 s SepFlag="true"
	....e  i tIndex=10 s OctFlag="true"
	....e  i tIndex=11 s NovFlag="true"
	....e  i tIndex=12 s DeceFlag="true"
	..s planId=$o(^CF.DHCINM.CHK.CheckPlanI("Type",year,type,""))
	..s planSubId="",rw=""
	..s:planId'="" planSubId=$o(^CF.DHCINM.CHK.CheckPlanSubI("QualItem",planId,qualId,""))
	..i planSubId'="" d
	...q:$d(^CF.DHCINM.CHK.CheckPlanSubD(planId,planSubId))'=1
	...s planSubGlo=^CF.DHCINM.CHK.CheckPlanSubD(planId,planSubId)
	...s Jan=$lg(planSubGlo,3)
	...s Feb=$lg(planSubGlo,4)
	...s Mar=$lg(planSubGlo,5)
	...s Apr=$lg(planSubGlo,6)
	...s May=$lg(planSubGlo,7)
	...s Jun=$lg(planSubGlo,8)
	...s Jul=$lg(planSubGlo,9)
	...s Aug=$lg(planSubGlo,10)
	...s Sep=$lg(planSubGlo,11)
	...s Oct=$lg(planSubGlo,12)
	...s Nov=$lg(planSubGlo,13)
	...s Dece=$lg(planSubGlo,14)
	...s rw=planId_"__"_planSubId
	..s ret="QualItem|"_qualId_"^QualItemDesc|"_QualItemDesc_"^Jan|"_Jan_"^Feb|"_Feb_"^Mar|"_Mar_"^Apr|"_Apr_"^May|"_May_"^Jun|"_Jun_"^Jul|"_Jul
	..s ret=ret_"^Aug|"_Aug_"^Sep|"_Sep_"^Oct|"_Oct_"^Nov|"_Nov_"^Dece|"_Dece_"^JanFlag|"_JanFlag_"^FebFlag|"_FebFlag_"^MarFlag|"_MarFlag_"^AprFlag|"_AprFlag
	..s ret=ret_"^MayFlag|"_MayFlag_"^JunFlag|"_JunFlag_"^JulFlag|"_JulFlag_"^AugFlag|"_AugFlag_"^SepFlag|"_SepFlag_"^OctFlag|"_OctFlag_"^NovFlag|"_NovFlag
	..s ret=ret_"^DeceFlag|"_DeceFlag_"^rw|"_rw
	..d OutPlanDetailList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanDetailList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPlanDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPlanDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPlanDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPlanDetailListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description：保存巡查计划
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckPlan CF.DHCINM.CHK.CheckPlanSub CT.DHCINM.DB.MgQualItem
/// Input:
/// Output:0：失败 1：成功
/// Other:w ##class(web.INMQualControlComm).RemoveCheckWard("2020","5__2","")
ClassMethod SavePlanItems(year As %String = "", type As %String = "", parr As %String = "") As %String
{
	q:(year="")||(type="")||(parr="") 0
	
	s type=$tr(type,"_","|")
	s flag=1
	s rowid=$o(^CF.DHCINM.CHK.CheckPlanI("Type",year,type,""))
	i rowid="" d
	.i $d(^CT.DHCINM.Set.MgSysParamSubD($p(type,"||"),$p(type,"||",2)))'=1 s flag=0 q
	.s planObj=##class(CF.DHCINM.CHK.CheckPlan).%New()
	.s planObj.CheckYear=year
	.d planObj.CheckTypeSetObjectId(type)
	e  d
	.i $d(^CF.DHCINM.CHK.CheckPlanD(rowid))#2'=1 s flag=0 q
	.s planObj=##class(CF.DHCINM.CHK.CheckPlan).%OpenId(rowid)
	q:flag'=1 0
	ts
	s sc=planObj.%Save()
	s:$$$ISERR(sc) flag=0
	i flag=1
	{
		s len=$l(parr,"「")
		f i=1:1:len
		{
			q:flag'=1
			s str=$p(parr,"「",i)
			continue:str=""
			k tmp
			d ##class(web.INMVueComm).SplitStr(str,"^","|",.tmp)
			s RowID=$tr($g(tmp("rw")),"_","|")
			s id=$p(RowID,"||",2)
			i id=""
			{
				s qual=$g(tmp("QualItem"))
				continue:(qual="")||($d(^CT.DHCINM.DB.MgQualItemD(qual))#2'=1)
				s planSubObj=##class(CF.DHCINM.CHK.CheckPlanSub).%New()
				s planSubObj.Parref=planObj
				d planSubObj.QualItemSetObjectId(qual)
			}
			else
			{
				continue:$d(^CF.DHCINM.CHK.CheckPlanSubD(planObj.%Id(),id))'=1
				s planSubObj=##class(CF.DHCINM.CHK.CheckPlanSub).%OpenId(planObj.%Id()_"||"_id)
			}
			i $g(tmp("Jan"))'="" s planSubObj.Jan=tmp("Jan")
			e  s planSubObj.Jan=""
			i $g(tmp("Feb"))'="" s planSubObj.Feb=tmp("Feb")
			e  s planSubObj.Feb=""
			i $g(tmp("Mar"))'="" s planSubObj.Mar=tmp("Mar")
			e  s planSubObj.Mar=""
			i $g(tmp("Apr"))'="" s planSubObj.Apr=tmp("Apr")
			e  s planSubObj.Apr=""
			i $g(tmp("May"))'="" s planSubObj.May=tmp("May")
			e  s planSubObj.May=""
			i $g(tmp("Jun"))'="" s planSubObj.Jun=tmp("Jun")
			e  s planSubObj.Jun=""
			i $g(tmp("Jul"))'="" s planSubObj.Jul=tmp("Jul")
			e  s planSubObj.Jul=""
			i $g(tmp("Aug"))'="" s planSubObj.Aug=tmp("Aug")
			e  s planSubObj.Aug=""
			i $g(tmp("Sep"))'="" s planSubObj.Sep=tmp("Sep")
			e  s planSubObj.Sep=""
			i $g(tmp("Oct"))'="" s planSubObj.Oct=tmp("Oct")
			e  s planSubObj.Oct=""
			i $g(tmp("Nov"))'="" s planSubObj.Nov=tmp("Nov")
			e  s planSubObj.Nov=""
			i $g(tmp("Dece"))'="" s planSubObj.Dece=tmp("Dece")
			e  s planSubObj.Dece=""
			s sc=planSubObj.%Save()
			s:$$$ISERR(sc) flag=0
		}
	}
	i flag=1 tc  q 1
	e  tro  q 0
}

/// Description：查询全部病区列表
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.DB.MgWard CF.DHCINM.CHK.CheckWard
/// Input:质控类型 片区ID 病区描述
/// Output:全部病区列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindSysWardForTypeList","5__2","","")
Query FindSysWardForTypeList(type As %String = "", area As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSysWardForTypeListExecute(ByRef qHandle As %Binary, type As %String = "", area As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s type=$tr(type,"_","|")
	k tmpWard
	i area'="" d
	.s locId="" f  s locId=$o(^CF.DHCINM.DB.MgWardLocI("Area",area,locId)) q:locId=""  d
	..s ward="" f  s ward=$o(^CF.DHCINM.DB.MgWardLocUnitI("Loc",locId,ward)) q:ward=""  d
	...s tmpWard(ward)=1
	
	k tmp
	s Sort="" f  s Sort=$O(^CF.DHCINM.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s RowID="" f  s RowID=$O(^CF.DHCINM.DB.MgWardI("Sort",Sort,RowID)) q:RowID=""  d
	..q:'$d(^CF.DHCINM.DB.MgWardD(RowID))
	..q:(area'="")&&('$d(tmpWard(RowID)))
	..s glo=^CF.DHCINM.DB.MgWardD(RowID)
	..s wardCode=$lg(glo,3)
	..s wardDesc=$lg(glo,4)
	..s wardSpell=$lg(glo,7)
	..q:(input'="")&&(wardCode_wardDesc_wardSpell'[$zcvt(input,"U"))
	..s stDate=$lg(glo,11)
	..s endDate=$lg(glo,12)
	..q:((stDate'="")&&(stDate>+$H))
	..q:((endDate'="")&&(endDate<+$H))
	..i (type'="")&&($d(^CF.DHCINM.CHK.CheckWardI("Type",type,RowID))) d
	...s tmp(2,Sort,RowID)="warddesc|"_wardDesc_"^wardid|"_RowID_"^flag|0"
	..e  s tmp(1,Sort,RowID)="warddesc|"_wardDesc_"^wardid|"_RowID_"^flag|1"
	
	s flag="" f  s flag=$o(tmp(flag)) q:flag=""  d
	.s Sort="" f  s Sort=$o(tmp(flag,Sort)) q:Sort=""  d
	..s RowID="" f  s RowID=$o(tmp(flag,Sort,RowID)) q:RowID=""  d
	...s ret=tmp(flag,Sort,RowID)
	...d OutSysWard
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSysWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSysWardForTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSysWardForTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSysWardForTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSysWardForTypeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description：查询检查病区列表
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckWard
/// Input:质控类型 片区ID 病区描述
/// Output:检查病区列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckWardForTypeList","5__2")
Query FindCheckWardForTypeList(type As %String = "", area As %String = "", input As %String = "", group As %String = "", flag As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckWardForTypeListExecute(ByRef qHandle As %Binary, type As %String = "", area As %String = "", input As %String = "", group As %String = "", flag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s type=$tr(type,"_","|")
	k tmpWard
	i area'="" d
	.s locId="" f  s locId=$o(^CF.DHCINM.DB.MgWardLocI("Area",area,locId)) q:locId=""  d
	..s ward="" f  s ward=$o(^CF.DHCINM.DB.MgWardLocUnitI("Loc",locId,ward)) q:ward=""  d
	...s tmpWard(ward)=1
	
	k tmp
	s Typ="" f  s Typ=$o(^CF.DHCINM.CHK.CheckWardI("Sort",Typ)) q:Typ=""  d
	.q:(type'="")&&(type'=Typ)
	.s paramParId=$p(type,"||")
	.s paramSubId=$p(type,"||",2)
	.q:'$d(^CT.DHCINM.Set.MgSysParamSubD(paramParId,paramSubId))
	.s paramGlo=^CT.DHCINM.Set.MgSysParamSubD(paramParId,paramSubId)
	.s typeDesc=$lg(paramGlo,3)
	.s sort="" f  s sort=$o(^CF.DHCINM.CHK.CheckWardI("Sort",Typ,sort)) q:sort=""  d
	..s RowID="" f  s RowID=$o(^CF.DHCINM.CHK.CheckWardI("Sort",Typ,sort,RowID)) q:RowID=""  d
	...q:'$d(^CF.DHCINM.CHK.CheckWardD(RowID))
	...s glo=^CF.DHCINM.CHK.CheckWardD(RowID)
	...s checkWard=$lg(glo,3)
	...q:'$d(^CF.DHCINM.DB.MgWardD(checkWard))
	...q:(area'="")&&('$d(tmpWard(checkWard)))
	...s wardGlo=^CF.DHCINM.DB.MgWardD(checkWard)
	...s wardCode=$lg(wardGlo,3)
	...s wardDesc=$lg(wardGlo,4)
	...s wardSpell=$lg(wardGlo,7)
	...s stDate=$lg(wardGlo,11)
	...s endDate=$lg(wardGlo,12)
	...q:((stDate'="")&&(stDate>+$H))
	...q:((endDate'="")&&(endDate<+$H))
	...q:(input'="")&&(wardCode_wardDesc_wardSpell'[$zcvt(input,"U"))
	...s checkGroup=$lg(glo,5)
	...q:(flag=2)&&(group'="")&&(group'=checkGroup)
	...s checkGroupSort=$lg(glo,6)
	...s ableSelect=0
	...s:checkGroup="" ableSelect=1
	...s ret="WardID|"_checkWard_"^WardDesc|"_wardDesc_"^RowID|"_RowID_"^WardType|"_Typ_"^WardTypeDesc|"_typeDesc_"^WardSort|"_sort
	...s ret=ret_"^WardGroup|"_checkGroup_"^WardGroupSort|"_checkGroupSort_"^ableSelect|"_ableSelect
	...i flag=1 d
	....i checkGroup="" s tmp(1,sort)=ret
	....e  s tmp(2,sort)=ret
	...e  i flag=2 d
	....s tmp(2,checkGroupSort)=ret
	...e  d OutCheckWardList
	i (flag=1)||(flag=2) d
	.s tgroup="" f  s tgroup=$o(tmp(tgroup)) q:tgroup=""  d
	..s Sort="" f  s Sort=$o(tmp(tgroup,Sort)) q:Sort=""  d
	...s ret=tmp(tgroup,Sort)
	...d OutCheckWardList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckWardList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckWardForTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckWardForTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckWardForTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckWardForTypeListExecute ]
{
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

/// Description: 删除检查病区
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: CF.DHCINM.CHK.CheckWard
/// Input: 质控类型 检查病区ID
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMQualControlComm).RemoveCheckWard("5__2","1^2^3")
ClassMethod RemoveCheckWard(type As %String = "", parr As %String = "") As %String
{
	q:type="" 0
	s type=$tr(type,"_","|")
	q:'$d(^CF.DHCINM.CHK.CheckWardI("Type",type)) 0
	
	s flag=1
	s len=$l(parr,"^")
	Ts
	f i=1:1:len
	{
		q:flag'=1
		s id=$p(parr,"^",i)
		s obj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(id)
		continue:'$IsObject(obj)
		s sc=obj.%DeleteId(id)
		s:$$$ISERR(sc) flag=0
	}
	i flag=1 d
	.k tmp
	.s sort="" f  s sort=$o(^CF.DHCINM.CHK.CheckWardI("Sort",type,sort)) q:sort=""  d
	..s RowID="" f  s RowID=$o(^CF.DHCINM.CHK.CheckWardI("Sort",type,sort,RowID)) q:RowID=""  d
	...q:'$d(^CF.DHCINM.CHK.CheckWardD(RowID))
	...s tmp(sort,RowID)=1
	.s index=1
	.s sort="" f  s sort=$o(tmp(sort)) q:(sort="")||(flag'=1)  d
	..s id="" f  s id=$o(tmp(sort,id)) q:(id="")||(flag'=1)  d
	...s obj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(id)
	...q:'$IsObject(obj)
	...s obj.WardSort=index
	...s sc=obj.%Save()
	...s index=index+1
	...s:$$$ISERR(sc) flag=0
	
	if flag=1{
		TC
	}else{
		TRO	
	}
	q flag
}

/// Description: 添加检查病区
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: CF.DHCINM.CHK.CheckWard
/// Input: 质控类型 病区ID
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMQualControlComm).RemoveCheckWard("5__2","1^2^3")
ClassMethod AddCheckWard(type As %String = "", parr As %String = "") As %String
{
	q:type="" 0
	s type=$tr(type,"_","|")
	q:'$d(^CT.DHCINM.Set.MgSysParamSubD($p(type,"||"),$p(type,"||",2))) 0
	
	s len=$l(parr,"^")
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		s RowID=$o(^CF.DHCINM.CHK.CheckWardI("Type",type,itm,""))
		i RowID=""
		{
			s obj=##class(CF.DHCINM.CHK.CheckWard).%New()
			continue:'$d(^CF.DHCINM.DB.MgWardD(itm))
			d obj.QualTypeSetObjectId(type)
			d obj.WardSetObjectId(itm)
			s sort=$o(^CF.DHCINM.CHK.CheckWardI("Sort",type,""),-1)
			s sort=sort+1
			s obj.WardSort=sort
			d obj.%Save()
		}
	}
	q 1
}

/// Description: 移动检查病区顺序
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: CF.DHCINM.CHK.CheckWard
/// Input: 移动类型：U向上D向下 CheckWardID
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMQualControlComm).MoveCheckWard("D","1,2,3")
ClassMethod MoveCheckWard(type As %String = "", parr As %String = "") As %String
{
	q:(type="")||(parr="") 0
	s checkWardList=$lfs(parr,",")
	s ptr=0 f  s status=$listnext(checkWardList,ptr,id) q:status'=1  d
	.s obj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(id)
	.q:'$IsObject(obj)
	.s typ=obj.QualType.%Id()
	.s sort=obj.WardSort
	.i type="U" s direction=-1
	.e  s direction=1
	.s flag=1
	.s nextSort=sort f  s nextSort=$o(^CF.DHCINM.CHK.CheckWardI("Sort",typ,nextSort),direction) q:(flag'=1)||(nextSort="")  d
	..s nextId="" f  s nextId=$o(^CF.DHCINM.CHK.CheckWardI("Sort",typ,nextSort,nextId)) q:(flag'=1)||(nextId="")  d
	...s nextobj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(nextId)
	...q:'$IsObject(nextobj)
	...s flag=0
	.q:flag=1
	.s obj.WardSort=nextobj.WardSort
	.s nextobj.WardSort=sort
	.d obj.%Save()
	.d nextobj.%Save()
	q 1
}

/// Description：查询检查病区分组
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckWard
/// Input:
/// Output:检查病区分组
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindWardGroupList","5__1")
Query FindWardGroupList(type As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardGroupListExecute(ByRef qHandle As %Binary, type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s type=$tr(type,"_","|")
	s group="" f  s group=$O(^CF.DHCINM.CHK.CheckWardI("Group",type,group)) q:group=""  d
	.s tGroup=$tr(group," ","")
	.q:tGroup=""
	.s ret="rw|"_tGroup_"^desc|"_tGroup
	.d OutWardGroup
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardGroup
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 添加分组及分组病区
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: CF.DHCINM.CHK.CheckWard
/// Input: 分组 检查病区ID
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMQualControlComm).AddGroupWard("5__1","测试一组","1^2^3^4")
ClassMethod AddGroupWard(type As %String = "", group As %String = "", checkid As %String = "") As %String
{
	q:(type="")||(group="")||(checkid="") 0
	s type=$tr(type,"_","|")
	q:'$d(^CT.DHCINM.Set.MgSysParamSubD($p(type,"||"),$p(type,"||",2))) 0
	
	s len=$l(checkid,"^")
	f i=1:1:len
	{
		s rw=$p(checkid,"^",i)
		i rw="" continue
		s obj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(rw)
		continue:'$IsObject(obj)
		s obj.WardGroup=group
		s sort=$o(^CF.DHCINM.CHK.CheckWardI("Group",type," "_group,""),-1)
		s sort=sort+1
		s obj.WardGroupSort=sort
		d obj.%Save()
	}
	q 1
}

/// Description: 删除分组及分组病区
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: CF.DHCINM.CHK.CheckWard
/// Input: 质控类型 分组名称
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMQualControlComm).RemoveCheckGroup("5__1","测试一组")
ClassMethod RemoveCheckGroup(type As %String = "", group As %String = "", checkid As %String = "") As %String
{
	q:(type="")||(group="") 0
	s type=$tr(type,"_","|")
	q:'$d(^CF.DHCINM.CHK.CheckWardI("Type",type)) 0
	q:'$d(^CF.DHCINM.CHK.CheckWardI("Group",type," "_group)) 0
	
	s checkFilter=$lfs(checkid,"^")
	ts
	s flag=1
	s sort="" f  s sort=$o(^CF.DHCINM.CHK.CheckWardI("Group",type," "_group,sort)) q:(sort="")||(flag'=1)  d
	.s id="" f  s id=$o(^CF.DHCINM.CHK.CheckWardI("Group",type," "_group,sort,id)) q:(id="")||(flag'=1)  d
	..s obj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(checkid'="")&&($lf(checkFilter,id)=0)
	..s obj.WardGroup=""
	..s obj.WardGroupSort=""
	..s sc=obj.%Save()
	..s:$$$ISERR(sc) flag=0
	if flag'=1{
		tro
	}else {
		tc
	}
	q flag
}

/// Description: 移动检查病区顺序
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: CF.DHCINM.CHK.CheckWard
/// Input: 移动类型：U向上D向下 CheckWardID
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMQualControlComm).MoveGroupWard("D","2")
ClassMethod MoveGroupWard(type As %String = "", parr As %String = "") As %String
{
	q:(type="")||(parr="") 0
	
	s checkWardList=$lfs(parr,",")
	s typ="",group="",flag=1,index=1
	s ptr=0 f  s status=$listnext(checkWardList,ptr,id) q:(status'=1)||(flag'=1)  d
	.s obj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(id)
	.s:index=1 group=obj.WardGroup,typ=obj.QualType.%Id()
	.s index=index+1
	.s:(group'=obj.WardGroup)||(typ'=obj.QualType.%Id()) flag=0
	
	ts
	i flag=1 d
	.s ptr=0 f  s status=$listnext(checkWardList,ptr,id) q:(status'=1)||(flag'=1)  d
	..s obj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(id)
	..q:'$IsObject(obj)
	..s sort=obj.WardGroupSort
	..i type="U" s direction=-1
	..e  s direction=1
	..s flag2=1
	..s nextSort=sort f  s nextSort=$o(^CF.DHCINM.CHK.CheckWardI("Group",typ," "_group,nextSort),direction) q:(flag2'=1)||(nextSort="")  d
	...s nextId="" f  s nextId=$o(^CF.DHCINM.CHK.CheckWardI("Group",typ," "_group,nextSort,nextId)) q:(flag2'=1)||(nextId="")  d
	....s nextobj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(nextId)
	....q:'$IsObject(nextobj)
	....s flag2=0
	..q:flag2=1
	..s obj.WardGroupSort=nextobj.WardGroupSort
	..s nextobj.WardGroupSort=sort
	..s sc=obj.%Save()
	..s:$$$ISOK(sc) sc=nextobj.%Save()
	..s:$$$ISERR(sc) flag=0
	
	i flag'=1 tro  q 0
	e  tc  q 1
}

/// Description：查询护士长质控分组组别
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckGroup
/// Input: 质控类型
/// Output:护士长质控分组组别
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindNurCheckGroupList","5__2")
Query FindNurCheckGroupList(type As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurCheckGroupListExecute(ByRef qHandle As %Binary, type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$tr(type,"_","|")
	
	s category="" f  s category=$o(^CF.DHCINM.CHK.CheckGroupI("TypeSort",type,category)) q:category=""  d
	.s categoryCode=$tr(category," ","")
	.s ret="GroupDesc|"_categoryCode_"^GroupType|"_$tr(type,"|","_")
	.d OutCheckGroupList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckGroupList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurCheckGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurCheckGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurCheckGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurCheckGroupListExecute ]
{
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

/// Description：根据职务类型查询人员名单
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.HR.PostDuty CF.DHCINM.CHK.CheckGroup
/// Input: 职务名称
/// Output:指定职位人员
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindNurseForType","5__2","护士长!科护士长!副护士长","")
Query FindNurseForType(type As %String = "", post As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurseForTypeExecute(ByRef qHandle As %Binary, type As %String = "", post As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (type="")||(post="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$tr(type,"_","|")
	s parId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 职务",""))
	i parId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s postList=$lfs(post,"!")
	s postFilter=$lb(),couter=1
	s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)) q:subId=""  d
	.s codeGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s codeCode=$lg(codeGlo,2)
	.q:$lf(postList,codeCode)=0
	.s $li(postFilter,couter)=parId_"||"_subId
	.s couter=couter+1
	
	s repeatable=0
 	s sysParId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALSETTING",""))
 	i sysParId'="" d
 	.s sysSubId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," CHECKERREPEAT",sysParId,""))
 	.q:sysSubId=""
 	.q:'$d(^CT.DHCINM.Set.MgSysParamSubD(sysParId,sysSubId))
 	.s glo=^CT.DHCINM.Set.MgSysParamSubD(sysParId,sysSubId)
 	.s repeatable=$lg(glo,4)

	k tmp,tmpPer
	s now=+$h,tmpPer=""
	s postId="" f  s postId=$o(^CF.DHCINM.HR.PostDutyD(postId)) q:postId=""  d
	.s postGlo=^CF.DHCINM.HR.PostDutyD(postId)
	.s postStatus=$lg(postGlo,7)
	.q:postStatus'="A"
	.s postDuty=$lg(postGlo,3)
	.q:$lf(postFilter,postDuty)=0
	.s postStDate=$lg(postGlo,4)
	.s postEndDate=$lg(postGlo,5)
	.q:(postStDate>now)||((postEndDate'="")&&(postEndDate<now))
	.s per=$lg(postGlo,2)
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.q:$d(tmpPer(per))
	.s perGlo=^CF.DHCINM.HR.PersonsD(per)
	.q:perGlo=""
	.q:##class(web.INMHRComm).IsFormalWorkNur(per,+$h,"")'=1
	.s perName=$lg(perGlo,2)
	.s perNamePY=##class(web.INMVueComm).ToChineseSpell(perName)
	.s perNo=$lg(perGlo,3)
	.q:(input'="")&&($zcvt(perName_perNamePY_perNo,"U")'[$zcvt(input,"U"))
	.s ward=$lg(perGlo,10)
	.q:'$d(^CF.DHCINM.DB.MgWardD(ward))
	.s wardGlo=^CF.DHCINM.DB.MgWardD(ward)
	.s wardDesc=$lg(wardGlo,4)
	.i '$d(^CF.DHCINM.CHK.CheckGroupI("Per",type,per)) d
	..s ret="Per|"_per_"^PerName|"_perName_"^Ward|"_ward_"^WardDesc|"_wardDesc_"^Group|^Flag|1"
	..d OutNurseList
	.e  d
 	..s tgroup=""
 	..s group="" f  s group=$o(^CF.DHCINM.CHK.CheckGroupI("Per",type,per,group)) q:group=""  d
 	...s tgroup=tgroup_$case(tgroup,"":"",:",")_$tr(group," ","")
 	..s tmp(per)="Per|"_per_"^PerName|"_perName_"^Ward|"_ward_"^WardDesc|"_wardDesc_"^Group|"_tgroup_"^Flag|"_$case(repeatable,"Y":1,:0)
	.s tmpPer(per)=per
	
	s per="" f  s per=$o(tmp(per)) q:per=""  d
	.s ret=tmp(per)
	.d OutNurseList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseForTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseForTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurseForTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseForTypeExecute ]
{
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

/// Description:更新质控组管理模式
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CT.DHCINM.Set.MgSysParamSub
/// Input:质控类型 mode
/// Output：0:失败 1:成功
/// Others: d ##class(web.INMQualControlComm).ChangeNurCheckGroupMode("5__2","TRUE")
ClassMethod ChangeNurCheckGroupMode(type As %String = "", mode As %String = "") As %String
{
	q:(type="")||(mode="") 0
	s type=$tr(type,"_","|")
	s obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(type)
	q:'$IsObject(obj) 0
	s obj.SubValue=$case($zcvt(mode,"U"),"TRUE":"TRUE","FALSE":"FALSE",:"FALSE")
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description:删除质控组组别
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckGroup
/// Input:质控类型 组名称
/// Return: 0 失败 1 成功
/// Others: w ##class(web.INMQualControlComm).DeleteNurCheckGroup("5__2","测试二")
ClassMethod DeleteNurCheckGroup(type As %String = "", group As %String = "") As %String
{
	q:(type="")||(group="") 0
	s type=$tr(type,"_","|")
	
	s flag=1
	ts
	s sort="" f  s sort=$o(^CF.DHCINM.CHK.CheckGroupI("TypeSort",type," "_group,sort)) q:(sort="")||(flag'=1)  d
	.s id="" f  s id=$o(^CF.DHCINM.CHK.CheckGroupI("TypeSort",type," "_group,sort,id)) q:(id="")||(flag'=1)  d
	..s sc=##class(CF.DHCINM.CHK.CheckGroup).%DeleteId(id)
	..s:$$$ISERR(sc) flag=0
	i flag=1 tc  q 1
	e  tro  q 0
}

/// Description：查询夜查房分组人员
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckGroup
/// Input: 质控类型 组名 人员名称、简拼、工号
/// Output:夜查房分组人员
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindGroupPersonList","5__2","测试一组","")
Query FindGroupPersonList(type As %String = "", group As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindGroupPersonListExecute(ByRef qHandle As %Binary, type As %String = "", group As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (type="")||(group="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$tr(type,"_","|")
	
	s sort="" f  s sort=$O(^CF.DHCINM.CHK.CheckGroupI("TypeSort",type," "_group,sort)) q:sort=""  d
	.s rowid="" f  s rowid=$O(^CF.DHCINM.CHK.CheckGroupI("TypeSort",type," "_group,sort,rowid)) q:rowid=""  d
	..q:'$d(^CF.DHCINM.CHK.CheckGroupD(rowid))
	..s groupGlo=^CF.DHCINM.CHK.CheckGroupD(rowid)
	..s per=$lg(groupGlo,4)
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	..s perName=$lg(perGlo,2)
	..s perNamePY=##class(web.INMVueComm).ToChineseSpell(perName)
	..s perNo=$lg(perGlo,3)
	..q:(input'="")&&($zcvt(perName_perNamePY_perNo,"U")'[$zcvt(input,"U"))
	..s ward=$lg(perGlo,10)
	..s wardGlo=$g(^CF.DHCINM.DB.MgWardD(ward))
	..s wardDesc=$lg(wardGlo,4)
 	..s ret="Per|"_per_"^PerName|"_perName_"^Ward|"_ward_"^WardDesc|"_wardDesc_"^GroupSort|"_sort_"^rw|"_rowid
 	..d OutGroupPersonList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGroupPersonList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindGroupPersonListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupPersonListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindGroupPersonListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupPersonListExecute ]
{
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

/// Description:添加质控组成员
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckGroup
/// Input:质控类型 组名 人员id
/// Return: 0 失败 1 成功
/// Others: d ##class(web.INMQualControlComm).AddNurGroupPerson("5__2","测试一组","1^2^3")
ClassMethod AddNurGroupPerson(type As %String = "", group As %String = "", parr As %String = "") As %String
{
	q:(type="")||(group="")||(parr="") 0
	s type=$tr(type,"_","|")
	q:'$d(^CT.DHCINM.Set.MgSysParamSubD($p(type,"||"),$p(type,"||",2))) 0
	
	s flag=1
	s len=$l(parr,"^")
	f i=1:1:len
	{
		q:flag'=1
		s per=$p(parr,"^",i)
		continue:'$d(^CF.DHCINM.HR.PersonsD(per))
		i '$d(^CF.DHCINM.CHK.CheckGroupI("Nur",type," "_group,per))
		{
			s obj=##class(CF.DHCINM.CHK.CheckGroup).%New()
			d obj.GroupTypeSetObjectId(type)
			s obj.GroupCategory=group
			d obj.GroupPersonSetObjectId(per)
			s Sort=$O(^CF.DHCINM.CHK.CheckGroupI("TypeSort",type," "_group,""),-1)
			i Sort'="" s Sort=Sort+1
			e  s Sort=1
			s obj.GroupSort=Sort
			s sc=obj.%Save()
			s:$$$ISERR(sc) flag=0
		}
	}
	q flag
}

/// Description:删除质控组成员
/// Date:2020-06-05
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckGroup
/// Input:质控类型 组名 id
/// Return: 0 失败 1 成功
/// Others: d ##class(web.INMQualControlComm).RemoveNurGroupPerson("5__2","测试一组","1^2^3")
ClassMethod RemoveNurGroupPerson(type As %String = "", group As %String = "", parr As %String = "") As %String
{
	q:(type="")||(group="")||(parr="") 0
	s type=$tr(type,"_","|")
	
	s flag=1
	s len=$l(parr,"^")
	ts
	f i=1:1:len
	{
		q:flag'=1
		s id=$p(parr,"^",i)
		continue:'$d(^CF.DHCINM.CHK.CheckGroupD(id))
		s sc=##class(CF.DHCINM.CHK.CheckGroup).%DeleteId(id)
		s:$$$ISERR(sc) flag=0
	}
	i flag=1 d
	.k tmp
	.s sort="" f  s sort=$o(^CF.DHCINM.CHK.CheckGroupI("TypeSort",type," "_group,sort)) q:sort=""  d
	..s id="" f  s id=$o(^CF.DHCINM.CHK.CheckGroupI("TypeSort",type," "_group,sort,id)) q:id=""  d
	...q:'$d(^CF.DHCINM.CHK.CheckGroupD(id))
	...s tmp(sort,id)=1
	.s index=1
	.s sort="" f  s sort=$o(tmp(sort)) q:(sort="")||(flag'=1)  d
	..s id="" f  s id=$o(tmp(sort,id)) q:(id="")||(flag'=1)  d
	...s obj=##class(CF.DHCINM.CHK.CheckGroup).%OpenId(id)
	...q:'$IsObject(obj)
	...s obj.GroupSort=index
	...s sc=obj.%Save()
	...s index=index+1
	...s:$$$ISERR(sc) flag=0
	i flag=1 tc  q 1
	e  tro  q 0
}

/// Description: 移动检查人员顺序
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: CF.DHCINM.CHK.CheckGroup
/// Input: 移动类型：U向上D向下 id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMQualControlComm).MoveCheckNur("D","1,2,3")
ClassMethod MoveCheckNur(type As %String = "", parr As %String = "") As %String
{
	q:(type="")||(parr="") 0
	s checkNurList=$lfs(parr,",")
	
	s typ="",group="",flag=1,index=1
	s ptr=0 f  s status=$listnext(checkNurList,ptr,id) q:(status'=1)||(flag'=1)  d
	.s obj=##class(CF.DHCINM.CHK.CheckGroup).%OpenId(id)
	.s:index=1 group=obj.GroupCategory,typ=obj.GroupType.%Id()
	.s index=index+1
	.s:(group'=obj.GroupCategory)||(typ'=obj.GroupType.%Id()) flag=0
	
	ts
	i flag=1 d
	.s ptr=0 f  s status=$listnext(checkNurList,ptr,id) q:(status'=1)||(flag'=1)  d
	..s obj=##class(CF.DHCINM.CHK.CheckGroup).%OpenId(id)
	..q:'$IsObject(obj)
	..s typ=obj.GroupType.%Id()
	..s sort=obj.GroupSort
	..i type="U" s direction=-1
	..e  s direction=1
	..s flag2=1
	..s nextSort=sort f  s nextSort=$o(^CF.DHCINM.CHK.CheckGroupI("TypeSort",typ," "_group,nextSort),direction) q:(flag2'=1)||(nextSort="")  d
	...s nextId="" f  s nextId=$o(^CF.DHCINM.CHK.CheckGroupI("TypeSort",typ," "_group,nextSort,nextId)) q:(flag2'=1)||(nextId="")  d
	....s nextobj=##class(CF.DHCINM.CHK.CheckGroup).%OpenId(nextId)
	....q:'$IsObject(nextobj)
	....s flag2=0
	..q:flag2=1
	..s obj.GroupSort=nextobj.GroupSort
	..s nextobj.GroupSort=sort
	..s sc=obj.%Save()
	..s:$$$ISOK(sc) sc=nextobj.%Save()
	..s:$$$ISERR(sc) flag=0
	
	i flag'=1 tro  q 0
	e  tc  q 1
}

/// Description：查询夜查房下个月是否有排班
/// Date:2020-06-12
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:质控类型
/// Return: 1:有 0:无
/// Others: w ##class(web.INMQualControlComm).IsExistCheckNextMonth("5__2","2020-06-01")
ClassMethod IsExistCheckNextMonth(type As %String = "", date As %String = "") As %String
{
	q:(type="")||(date="") 0
	s type=$tr(type,"_","|")
	s:date["-" date=$zdh(date,3)
	
	s flag=0,typeList=$lfs(type,"^"),stDate=date-1,endDate=$SYSTEM.SQL.LASTDAY(date)
	s ptr=0 f  s status=$listnext(typeList,ptr,typ) q:(status'=1)||(flag'=0)  d
	.s tDate=stDate f  s tDate=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate"," N",typ,tDate)) q:(tDate="")||(tDate>endDate)||(flag'=0)  d
	..s flag=1
	q flag
}

/// Description：查询夜查房排班表
/// Date:2020-06-05
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input: 质控类型 开始日期 角色 人员id
/// Output:夜查房排班表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindSchduleList","5__2^5__4","2020-06-01",0,0)
Query FindSchduleList(type As %String = "", date As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSchduleListExecute(ByRef qHandle As %Binary, type As %String = "", date As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (type="")||(date="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s typeFilter=$lfs($tr(type,"_","|"),"^")
	s:date["-" date=$zdh(date,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s startdate=date,enddate=startdate+42-1
	s startyear=$p($zd(date,3),"-",1),endYear=$p($zd(enddate,3),"-")
	k tmpHoliday
	f year=startyear:1:endYear d
	.s code="" f  s code=$O(^CF.DHCINM.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	..s rowid="" f  s rowid=$O(^CF.DHCINM.DB.MgHolidaySetI("code",year,code,rowid)) q:rowid=""  d
	...s holidayObj=##class(CF.DHCINM.DB.MgHolidaySet).%OpenId(rowid)
	...q:'$IsObject(holidayObj)
	...q:'$IsObject(holidayObj.HolidayID)
	...q:holidayObj.HolidayDate=""
	...s hstdate=$zdh($p(holidayObj.HolidayDate,",",1),3)
	...s henddate=$zdh($p(holidayObj.HolidayDate,",",2),3)
	...f hdate=hstdate:1:henddate d
	....i '$d(tmpHoliday(hdate)) s tmpHoliday(hdate)=holidayObj.HolidayID.SubDesc
	....e  s tmpHoliday(hdate)=tmpHoliday(hdate)_","_holidayObj.HolidayID.SubDesc
	k tmpQualType
	s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALTYPE",""))
	i parId'="" d
	.s subId="" f  s subId=$o(^CT.DHCINM.Set.MgSysParamSubD(parId,subId)) q:subId=""  d
	..s subGlo=^CT.DHCINM.Set.MgSysParamSubD(parId,subId)
	..s code=$zcvt($lg(subGlo,2),"U")
	..s tmpQualType(parId_"||"_subId)=code
	k tmp
	f outdate=startdate:1:enddate d
	.s exist=0
	.s ptr=0 f  s status=$listnext(typeFilter,ptr,qualType) q:(status'=1)||(exist'=0)  d
	..s:$d(^DHCINM.CHK.MgQualCheckTaskI("TypeDate"," N",qualType,outdate)) exist=1
	.q:exist=0
	.s id="" f  s id=$o(^DHCINM.CHK.MgQualCheckTaskI("Date"," N",outdate,id)) q:id=""  d
	..q:'$d(^DHCINM.CHK.MgQualCheckTaskD(id))
	..s glo=^DHCINM.CHK.MgQualCheckTaskD(id)
	..s taskType=$lg(glo,3)
	..q:$lf(typeFilter,taskType)=0
	..s taskPerson=$lg(glo,4)
	..s isChecker=0
	..i nurseid=0 s isChecker=1
	..e  i nurseid'="" d
	...s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	...s userPerId=$lg(userGlo,5)
	...s:$lf(taskPerson,userPerId)'=0 isChecker=1
	..s taskWard=$lg(glo,6)
	..s wardFlag=0
	..s ptr=0 f  s status=$listnext(taskWard,ptr,ward) q:(status'=1)||(wardFlag'=0)||((isAll=1))  d
	...s:$d(tmpWard(ward)) wardFlag=1
	..q:(isAll'=1)&&(isChecker=0) ;&&(wardFlag=0)
	..s taskTypeCode=$g(tmpQualType(taskType))
	..s taskItem=$lg(glo,2)
	..s personGroup=$lg(glo,5)
	..s wardGroup=$lg(glo,7)
	..s taskItemId=$lts(taskItem,"」")
	..s taskItemDesc=""
	..s ptr=0,index=0 f  s status=$listnext(taskItem,ptr,qual) q:status'=1  d
	...s qualDesc=$p(qual,"「")
	...i index=0 s taskItemDesc=qualDesc,index=1
	...e  s taskItemDesc=taskItemDesc_","_qualDesc
	..s taskPersonId=$lts(taskPerson,"」")
	..s taskPersonName=""
	..s ptr=0,index=0 f  s status=$listnext(taskPerson,ptr,per) q:status'=1  d
	...i $d(^CF.DHCINM.HR.PersonsD(per)) d
	....s perGlo=^CF.DHCINM.HR.PersonsD(per)
	....s perName=$lg(perGlo,2)
	....i index=0 s taskPersonName=perName,index=1
	....e  s taskPersonName=taskPersonName_","_perName
	...e  d
	....i index=0 s taskPersonName="",index=1
	....e  s taskPersonName=taskPersonName_","
	..s taskWardId=$lts(taskWard,"」")
	..s taskWardDesc=""
	..s ptr=0,index=0 f  s status=$listnext(taskWard,ptr,ward) q:status'=1  d
	...i $d(^CF.DHCINM.DB.MgWardD(ward)) d
	....s wardGlo=^CF.DHCINM.DB.MgWardD(ward)
	....s wardDesc=$lg(wardGlo,4)
	....i index=0 s taskWardDesc=wardDesc,index=1
	....e  s taskWardDesc=taskWardDesc_","_wardDesc
	...e  d
	....i index=0 s taskWardDesc="",index=1
	....e  s taskWardDesc=taskWardDesc_","
	..i (isAll=1)||(isChecker=1) s editAble=1
	..e  s editAble=0
	..i $d(^DHCINM.CHK.MgCheckResultI("Qual",id)) d
	...s isChecked=1
	...s tmpQualId=$o(^DHCINM.CHK.MgCheckResultI("Qual",id,""))
	...s resultId=$o(^DHCINM.CHK.MgCheckResultI("Qual",id,tmpQualId,""))
	...s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	...s recorder=$lg(resultGlo,19)
	...s recorderName=""
	...i recorder=0 s recorderName="管理员"
	...e  i recorder'="" s recorderName=$lg($g(^CF.DHCINM.DB.MgUserD(recorder)),2)
	...s signUser=$lg(resultGlo,11)
	...i signUser=0 s signUserName="管理员"
	...e  i signUser'="" s signUserName=$lg($g(^CF.DHCINM.DB.MgUserD(signUser)),2)
	..e  d
	...s isChecked=0,recorder="",recorderName="",signUser="",signUserName=""
	..s remark=$lg(glo,17)
	..i signUser'="" s recorder=recorder_","_signUser,recorderName=recorderName_","_signUserName
	..s ret="TaskItem|"_taskItemId_"^TaskItemDesc|"_taskItemDesc_"^TaskPerson|"_taskPersonId_"^TaskPersonDesc|"_taskPersonName_"^PersonGroup|"_personGroup_"^TaskWard|"_taskWardId
	..s ret=ret_"^TaskWardDesc|"_taskWardDesc_"^WardGroup|"_wardGroup_"^TaskType|"_$tr(taskType,"|","_")_"^TaskTypeCode|"_taskTypeCode_"^EditAble|"_editAble_"^rw|"_id_"^IsChecked|"_isChecked
	..s ret=ret_"^RecorderId|"_recorder_"^RecorderName|"_recorderName_"^IsChecker|"_isChecker_"^TaskRemark|"_remark
	..s tmp(outdate,id)=ret
	
	f outdate=startdate:1:enddate d
	.s isHoliday=""
	.s:$d(tmpHoliday(outdate)) isHoliday=tmpHoliday(outdate)
	.i '$d(tmp(outdate)) d
	..s ret="IsHoliday|"_isHoliday_"^TaskRemark|^TaskItem|^TaskItemDesc|^TaskPerson|^TaskPersonDesc|^PersonGroup|^TaskWard|^TaskWardDesc|^WardGroup|^TaskType|^TaskTypeCode|^EditAble|^rw|^IsChecked|0^RecorderId|^RecorderName|"
	.e  d
	..s tmpIsHoliday="",tmpTaskItem="",tmpTaskItemDesc="",tmpTaskPerson="",tmpTaskPersonDesc="",tmpPersonGroup="",tmpTaskWard="",tmpTaskWardDesc="",tmpWardGroup=""
	..s tmpTaskType="",tmpTaskTypeCode="",tmpEditAble="",tmpRw="",tmpTaskRemark=""
	..s firstFlag=1
	..s id="" f  s id=$o(tmp(outdate,id)) q:id=""  d
	...i firstFlag=1 d
	....s tmpTaskItem=$p($p(tmp(outdate,id),"^",1),"|",2)
	....s tmpTaskItemDesc=$p($p(tmp(outdate,id),"^",2),"|",2)
	....s tmpTaskPerson=$p($p(tmp(outdate,id),"^",3),"|",2)
	....s tmpTaskPersonDesc=$p($p(tmp(outdate,id),"^",4),"|",2)
	....s tmpPersonGroup=$p($p(tmp(outdate,id),"^",5),"|",2)
	....s tmpTaskWard=$p($p(tmp(outdate,id),"^",6),"|",2)
	....s tmpTaskWardDesc=$p($p(tmp(outdate,id),"^",7),"|",2)
	....s tmpWardGroup=$p($p(tmp(outdate,id),"^",8),"|",2)
	....s tmpTaskType=$p($p(tmp(outdate,id),"^",9),"|",2)
	....s tmpTaskTypeCode=$p($p(tmp(outdate,id),"^",10),"|",2)
	....s tmpEditAble=$p($p(tmp(outdate,id),"^",11),"|",2)
	....s tmpRw=$p($p(tmp(outdate,id),"^",12),"|",2)
	....s tmpIsChecked=$p($p(tmp(outdate,id),"^",13),"|",2)
	....s tmpRecorderId=$p($p(tmp(outdate,id),"^",14),"|",2)
	....s tmpRecorderName=$p($p(tmp(outdate,id),"^",15),"|",2)
	....s tmpIsChecker=$p($p(tmp(outdate,id),"^",16),"|",2)
	....s tmpTaskRemark=$p($p(tmp(outdate,id),"^",17),"|",2)
	....s firstFlag=0
	...e  d
	....s tmpTaskItem=tmpTaskItem_"ˇ"_$p($p(tmp(outdate,id),"^",1),"|",2)
	....s tmpTaskItemDesc=tmpTaskItemDesc_"ˇ"_$p($p(tmp(outdate,id),"^",2),"|",2)
	....s tmpTaskPerson=tmpTaskPerson_"ˇ"_$p($p(tmp(outdate,id),"^",3),"|",2)
	....s tmpTaskPersonDesc=tmpTaskPersonDesc_"ˇ"_$p($p(tmp(outdate,id),"^",4),"|",2)
	....s tmpPersonGroup=tmpPersonGroup_"ˇ"_$p($p(tmp(outdate,id),"^",5),"|",2)
	....s tmpTaskWard=tmpTaskWard_"ˇ"_$p($p(tmp(outdate,id),"^",6),"|",2)
	....s tmpTaskWardDesc=tmpTaskWardDesc_"ˇ"_$p($p(tmp(outdate,id),"^",7),"|",2)
	....s tmpWardGroup=tmpWardGroup_"ˇ"_$p($p(tmp(outdate,id),"^",8),"|",2)
	....s tmpTaskType=tmpTaskType_"ˇ"_$p($p(tmp(outdate,id),"^",9),"|",2)
	....s tmpTaskTypeCode=tmpTaskTypeCode_"ˇ"_$p($p(tmp(outdate,id),"^",10),"|",2)
	....s tmpEditAble=tmpEditAble_"ˇ"_$p($p(tmp(outdate,id),"^",11),"|",2)
	....s tmpRw=tmpRw_"ˇ"_$p($p(tmp(outdate,id),"^",12),"|",2)
	....s tmpIsChecked=tmpIsChecked_"ˇ"_$p($p(tmp(outdate,id),"^",13),"|",2)
	....s tmpRecorderId=tmpRecorderId_"ˇ"_$p($p(tmp(outdate,id),"^",14),"|",2)
	....s tmpRecorderName=tmpRecorderName_"ˇ"_$p($p(tmp(outdate,id),"^",15),"|",2)
	....s tmpIsChecker=tmpIsChecker_"ˇ"_$p($p(tmp(outdate,id),"^",16),"|",2)
	....s tmpTaskRemark=tmpTaskRemark_"ˇ"_$p($p(tmp(outdate,id),"^",17),"|",2)
	...s ret="IsHoliday|"_isHoliday_"^TaskItem|"_tmpTaskItem_"^TaskItemDesc|"_tmpTaskItemDesc_"^TaskPerson|"_tmpTaskPerson_"^TaskPersonDesc|"_tmpTaskPersonDesc
	...s ret=ret_"^PersonGroup|"_tmpPersonGroup_"^TaskWard|"_tmpTaskWard_"^TaskWardDesc|"_tmpTaskWardDesc_"^WardGroup|"_tmpWardGroup_"^TaskType|"_tmpTaskType
	...s ret=ret_"^TaskTypeCode|"_tmpTaskTypeCode_"^EditAble|"_tmpEditAble_"^rw|"_tmpRw_"^IsChecked|"_tmpIsChecked_"^RecorderId|"_tmpRecorderId_"^RecorderName|"_tmpRecorderName_"^IsChecker|"_tmpIsChecker
	...s ret=ret_"^TaskRemark|"_tmpTaskRemark
	.d OutSchdule
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSchdule
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSchduleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSchduleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSchduleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSchduleListExecute ]
{
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

/// Description：获取某人某年夜查房次数
/// Date:2020-05-08
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input: 质控类型 年份 人员Id
/// Output:查房次数
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindPerCheckNumList","5__2^5__4^5__5","2020","363」75」79")
Query FindPerCheckNumList(type As %String = "", year As %String = "", nurse As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPerCheckNumListExecute(ByRef qHandle As %Binary, type As %String = "", year As %String = "", nurse As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (type="")||(year="")||(nurse="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$tr(type,"_","|")
	s typeFilter=$lfs(type,"^")
	s stDate=$zdh(year-1_"-12-31",3)
	s endDate=$zdh(year_"-12-31",3)
	s perFilter=$lfs(nurse,"」")
	
	k tmp
	s date=stDate f  s date=$o(^DHCINM.CHK.MgQualCheckTaskI("Date"," N",date)) q:(date="")||(date>endDate)  d
	.s id="" f  s id=$o(^DHCINM.CHK.MgQualCheckTaskI("Date"," N",date,id)) q:id=""  d
	..q:'$d(^DHCINM.CHK.MgQualCheckTaskD(id))
	..s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(id)
	..s taskType=$lg(taskGlo,3)
	..q:$lf(typeFilter,taskType)=0
	..s taskPerson=$lg(taskGlo,4)
	..s ptr=0 f  s status=$listnext(taskPerson,ptr,checker) q:status'=1  d
	...s:$lf(perFilter,checker) tmp(checker,taskType)=$g(tmp(checker,taskType))+1
	
	s ptr=0 f  s status=$listnext(perFilter,ptr,per) q:status'=1  d
	.s ret="Per|"_per
	.s ptr2=0 f  s status2=$listnext(typeFilter,ptr2,typ) q:status2'=1  d
	..s ret=ret_"^"_$tr(typ,"|","_")_"|"_$fn($g(tmp(per,typ)),"",0)
	.d OutNurseList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPerCheckNumListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPerCheckNumListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPerCheckNumListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPerCheckNumListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 获取检查任务
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: CF.DHCINM.CHK.CheckPlan
/// Input: 质控类型 检查日期
/// Output: 检查任务
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindPlanItemList","")
Query FindPlanItemList(type As %String = "", date As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPlanItemListExecute(ByRef qHandle As %Binary, type As %String = "", date As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (type="")||(date="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$tr(type,"_","|")
	s dateh=$zdh(date,3)
	s year=$p(date,"-")
	s month=$p(date,"-",2)
	s parId="" f  s parId=$o(^CF.DHCINM.CHK.CheckPlanI("Type",year,type,parId)) q:parId=""  d
	.s subId="" f  s subId=$o(^CF.DHCINM.CHK.CheckPlanSubD(parId,subId)) q:subId=""  d
	..q:'$d(^CF.DHCINM.CHK.CheckPlanSubD(parId,subId))
	..s glo=^CF.DHCINM.CHK.CheckPlanSubD(parId,subId)
	..q:(month="01")&&($lg(glo,3)'="true")
	..q:(month="02")&&($lg(glo,4)'="true")
	..q:(month="03")&&($lg(glo,5)'="true")
	..q:(month="04")&&($lg(glo,6)'="true")
	..q:(month="05")&&($lg(glo,7)'="true")
	..q:(month="06")&&($lg(glo,8)'="true")
	..q:(month="07")&&($lg(glo,9)'="true")
	..q:(month="08")&&($lg(glo,10)'="true")
	..q:(month="09")&&($lg(glo,11)'="true")
	..q:(month="10")&&($lg(glo,12)'="true")
	..q:(month="11")&&($lg(glo,13)'="true")
	..q:(month="12")&&($lg(glo,14)'="true")
	..s qual=$lg(glo,2)
	..q:$d(^CT.DHCINM.DB.MgQualItemD(qual))#2'=1
	..s qualGlo=^CT.DHCINM.DB.MgQualItemD(qual)
	..s stDate=$lg(qualGlo,14)
	..s endDate=$lg(qualGlo,15)
	..q:(dateh<stDate)||((endDate'="")&&(dateh>endDate))
	..s qualDesc=$lg(qualGlo,4)
	..s ret="QualDesc|"_qualDesc_"^rw|"_qual
	..d OutPlanItemList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanItemList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPlanItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPlanItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPlanItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPlanItemListExecute ]
{
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

/// Description:查询某类型护士长分组是否启用
/// Date:2020-03-26
/// Creator:wangpf
/// Table:CT.DHCINM.Set.MgSysParamSub
/// Input:质控类型
/// Return: True启用 Fasle停用
/// Others: d ##class(web.INMQualControlComm).IsNurHeadGroupUsed("5__1")
ClassMethod IsNurHeadGroupUsed(qual As %String = "") As %String
{
	q:qual="" "False"
	s qual=$tr(qual,"_","|")
	
	s obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(qual)
	q:'$IsObject(obj) "False"
	i $zcvt(obj.SubValue,"U")="TRUE"  q "True"
	e  q "False"
}

/// Description：获取夜查房检查人
/// Date:2020-06-07
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckWard
/// Input: 质控类型 病区分组名称
/// Output:检查人
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindNightCheckPerList","5__4","周末一组","护士长!科护士长","2020-06-28")
Query FindNightCheckPerList(type As %String = "", wardgroup As %String = "", post As %String = "", date As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNightCheckPerListExecute(ByRef qHandle As %Binary, type As %String = "", wardgroup As %String = "", post As %String = "", date As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (type="")||(wardgroup="")||(post="")||(date="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$tr(type,"_","|")
	s:date["-" date=$zdh(date,3)
	
	s norParId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 在职状态",""))
	i norParId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s norSubId=$o(^CT.DHCINM.DB.MgSetCodeSubI("Code",norParId," 在职",""))
	s norStatus=norParId_"||"_norSubId
	
	s parId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 职务",""))
	i parId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s postList=$lfs(post,"!")
	k postFilter
	s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)) q:subId=""  d
	.s codeGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s codeDesc=$lg(codeGlo,3)
	.q:$lf(postList,codeDesc)=0
	.s postFilter(parId_"||"_subId)=1
	
	k wardFilter
	s sort="" f  s sort=$o(^CF.DHCINM.CHK.CheckWardI("Group",type," "_wardgroup,sort)) q:sort=""  d
	.s checkId="" f  s checkId=$o(^CF.DHCINM.CHK.CheckWardI("Group",type," "_wardgroup,sort,checkId)) q:checkId=""  d
	..q:'$d(^CF.DHCINM.CHK.CheckWardD(checkId))
	..s checkGlo=^CF.DHCINM.CHK.CheckWardD(checkId)
	..s ward=$lg(checkGlo,3)
	..s wardFilter(ward)=1
	
	k tmp,tmpPer
	s tmpPer=""
	s postId="" f  s postId=$o(^CF.DHCINM.HR.PostDutyD(postId)) q:postId=""  d
	.s postGlo=^CF.DHCINM.HR.PostDutyD(postId)
	.s postStatus=$lg(postGlo,7)
	.q:postStatus'="A"
	.s postDuty=$lg(postGlo,3)
	.q:'$d(postFilter(postDuty))
	.s postStDate=$lg(postGlo,4)
	.s postEndDate=$lg(postGlo,5)
	.q:(postStDate>date)||((postEndDate'="")&&(postEndDate<date))
	.s per=$lg(postGlo,2)
	.s ward=##class(web.INMHRComm).GetCurrentWard(per,date)
	.q:ward=""
	.q:$d(wardFilter(ward))
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.q:$d(tmpPer(per))
	.s perGlo=^CF.DHCINM.HR.PersonsD(per)
	.s perSatus=$lg(perGlo,42)
	.s perSatusDate=$lg(perGlo,43)
	.q:((perSatus'=norStatus)&&(perSatusDate'="")&&(perSatusDate<=date))
	.s perName=$lg(perGlo,2)
	.s ret="PerName|"_perName_"^PerDR|"_per
	.s tmpPer(per)=per
	.d OutNurseList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNightCheckPerListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNightCheckPerListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNightCheckPerListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNightCheckPerListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description：获取夜查房检查组
/// Date:2020-05-27
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckGroup
/// Input:质控类型 夜查房病区分组
/// Output:检查组
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindNightCheckGroupList","5__2","夜查房一组")
Query FindNightCheckGroupList(type As %String = "", wardgroup As %String = "", date As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNightCheckGroupListExecute(ByRef qHandle As %Binary, type As %String = "", wardgroup As %String = "", date As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (type="")||(wardgroup="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$tr(type,"_","|")
	
	k wardFilter
	s sort="" f  s sort=$o(^CF.DHCINM.CHK.CheckWardI("Group",type," "_wardgroup,sort)) q:sort=""  d
	.s checkId="" f  s checkId=$o(^CF.DHCINM.CHK.CheckWardI("Group",type," "_wardgroup,sort,checkId)) q:checkId=""  d
	..q:'$d(^CF.DHCINM.CHK.CheckWardD(checkId))
	..s checkGlo=^CF.DHCINM.CHK.CheckWardD(checkId)
	..s ward=$lg(checkGlo,3)
	..s wardFilter(ward)=1
	
	k groupFilter
	s category="" f  s category=$o(^CF.DHCINM.CHK.CheckGroupI("Type",type,category)) q:category=""  d
	.s groupId="" f  s groupId=$o(^CF.DHCINM.CHK.CheckGroupI("Type",type,category,groupId)) q:groupId=""  d
	..q:'$d(^CF.DHCINM.CHK.CheckGroupD(groupId))
	..s groupGlo=^CF.DHCINM.CHK.CheckGroupD(groupId)
	..s per=$lg(groupGlo,4)
	..q:'$d(^CF.DHCINM.HR.PersonsD(per))
	..s perGlo=^CF.DHCINM.HR.PersonsD(per)
	..s ward=##class(web.INMHRComm).GetCurrentWard(per,date)
	..q:ward=""
	..s:$d(wardFilter(ward)) groupFilter($tr(category," ",""))=1
	
	s category="" f  s category=$o(^CF.DHCINM.CHK.CheckGroupI("Type",type,category)) q:category=""  d
	.s categoryCode=$tr(category," ","")
	.q:categoryCode=""
	.q:$d(groupFilter(categoryCode))
	.s ret="GroupCode|"_categoryCode_"^GroupDesc|"_categoryCode_"^GroupType|"_$tr(type,"|","_")
	.d OutCheckGrpData
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckGrpData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNightCheckGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNightCheckGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNightCheckGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNightCheckGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description：某人所在病区是否在检查病区组
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod IsPerWardInGroup(perid, date, group, type) As %String
{
	q:(perid="")||(date="")||(group="")||(type="") 0
	s flag=0
	i date["-" s date=$zdh(date,3)
	s currward=##class(web.INMHRComm).GetCurrentWard(perid,date)
	q:currward="" 0
	s id="" f  s id=$o(^CF.DHCINM.CHK.CheckWardI("Type",type,currward,id)) q:(id="")||(flag=1)  d
	.q:$d(^CF.DHCINM.CHK.CheckWardD(id))
	.s glo=^CF.DHCINM.CHK.CheckWardD(id)
	.s grp=$lg(glo,3)
	.s:grp=group flag=1
	q flag
}

/// Description：检测是否可以保存
/// Date:2018-10-18
/// Creator:lulin
/// Table:
/// Input:perdrs^group^type^date
/// Output:
/// Other:"46,16^测试三^N^2018-10-10"
ClassMethod IsAbleSave(parr As %String = "") As %String
{
	s perdrs=$p(parr,"^")
	s checkgroup=$p(parr,"^",2)
	s wardgroup=$p(parr,"^",3)
	s type=$tr($p(parr,"^",4),"_","|")
	s date=$p(parr,"^",5)
	s:date["-" date=$zdh(date,3)
	q:((perdrs="")&&(checkgroup=""))||(wardgroup="")||(type="")||(date="") "参数有空值，请刷新界面"
	
	i perdrs="" d
	.s checkGroupId="" f  s checkGroupId=$o(^CF.DHCINM.CHK.CheckGroupI("Type",type," "_checkgroup,checkGroupId)) q:checkGroupId=""  d
	..q:'$d(^CF.DHCINM.CHK.CheckGroupD(checkGroupId))
	..s groupGlo=^CF.DHCINM.CHK.CheckGroupD(checkGroupId)
	..s per=$lg(groupGlo,4)
	..q:'$d(^CF.DHCINM.HR.PersonsD(per))
	..i perdrs="" s perdrs=per
	..e  s perdrs=perdrs_","_per
	
	s flag=0,ret=1
	f i=1:1:$l(perdrs,",") q:flag=1  d
	.s id=$p(perdrs,",",i)
	.q:id=""
	.i '$d(^CF.DHCINM.HR.PersonsD(id)) s flag=1,ret="无检查人信息，请刷新界面重试" q
	.s flag=..IsPerWardInGroup(id,date,wardgroup,type)
	.s perGlo=^CF.DHCINM.HR.PersonsD(id)
	.s perName=$lg(perGlo,2)
	.i flag=1 s ret=perName_"所在病区与检查病区冲突" q
	.s flag=##class(web.INMArgComm).IsPerAskLeavel2(id_"^"_date) ;是否请假
	.i flag=1 s ret=perName_"已请假" q
	q ret
}

/// Description:保存夜查房任务
/// Date:2020-06-07
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:
/// Output：0：失败 1：成功
/// Others: w ##class(web.INMQualControlComm).SaveNightTask("GroupType|夜查房一组^CheckTask|87^CheckGroup|测试二组^CheckDate|2020-06-29^CreateUser|0","5__2")
ClassMethod SaveNightTask(parr As %String = "", checktype As %String = "") As %String
{
	q:(parr="")||(checktype="") 0
	s checktype=$tr(checktype,"_","|")
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	q:($g(tmp("GroupType"))="")||(($g(tmp("CheckPerson"))="")&&($g(tmp("CheckGroup"))="")) 0
	q:($g(tmp("CheckDate"))="")||($g(tmp("CreateUser"))="")||($g(tmp("CheckTask"))="") 0
	q:'$d(^CT.DHCINM.Set.MgSysParamSubD($p(checktype,"||"),$p(checktype,"||",2))) 0
	s id=$g(tmp("RowID"))
	i id="" d
	.s obj=##class(DHCINM.CHK.MgQualCheckTask).%New()
	.s obj.CreateUser=tmp("CreateUser")
	.s obj.TaskIsRandom="N"
	e  s obj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(id)
	d obj.TaskTypeSetObjectId(checktype)
	s CheckTask=tmp("CheckTask")
	d obj.TaskItem.Clear()
	f i=1:1:$l(CheckTask,",") d
	.s itm=$p(CheckTask,",",i)
	.s CheckTaskObj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(itm)
	.q:'$IsObject(CheckTaskObj)
	.d obj.TaskItem.Insert(CheckTaskObj.QualDesc_"「"_itm)
	s GroupType=tmp("GroupType")
	q:'$d(^CF.DHCINM.CHK.CheckWardI("Group",checktype," "_GroupType)) 0
	s obj.TaskWardGroup=GroupType
	d obj.TaskCheckWard.Clear()
	s sort="" f  s sort=$o(^CF.DHCINM.CHK.CheckWardI("Group",checktype," "_GroupType,sort)) q:sort=""  d
	.s checkWardId="" f  s checkWardId=$o(^CF.DHCINM.CHK.CheckWardI("Group",checktype," "_GroupType,sort,checkWardId)) q:checkWardId=""  d
	..s checkWardObj=##class(CF.DHCINM.CHK.CheckWard).%OpenId(checkWardId)
	..q:'$IsObject(checkWardObj)
	..q:'$IsObject(checkWardObj.Ward)
	..d obj.TaskCheckWard.Insert(checkWardObj.Ward.%Id())
	s flag=0
	i $g(tmp("CheckPerson"))'="" d
	.d obj.TaskCheckPerson.Clear()
	.f i=1:1:$l(tmp("CheckPerson"),",") d
	..s per=$p(tmp("CheckPerson"),",",i)
	..q:'$d(^CF.DHCINM.HR.PersonsD(per))
	..d obj.TaskCheckPerson.Insert(per)
	e  d
	.d obj.TaskCheckPerson.Clear()
	.s CheckGroup=tmp("CheckGroup")
	.i '$d(^CF.DHCINM.CHK.CheckGroupI("Type",checktype," "_CheckGroup)) s flag=1 q
	.s obj.TaskPersonGroup=CheckGroup
	.s groupId="" f  s groupId=$o(^CF.DHCINM.CHK.CheckGroupI("Type",checktype," "_CheckGroup,groupId)) q:groupId=""  d
	..s groupObj=##class(CF.DHCINM.CHK.CheckGroup).%OpenId(groupId)
	..q:'$IsObject(groupObj)
	..q:'$IsObject(groupObj.GroupPerson)
	..d obj.TaskCheckPerson.Insert(groupObj.GroupPerson.%Id())
	q:flag=1 0
	s obj.TaskStatus="Y"
	s obj.TaskStDate=$zdh(tmp("CheckDate"),3)
	s obj.TaskEndDate=$zdh(tmp("CheckDate"),3)
	s obj.TaskRemark=$g(tmp("Remark"))
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	q flag
}

ClassMethod Show(ref As %String = "", index As %String = "")
{
	i ($d(@ref)=1)||($d(@ref)=11) w @ref
	f  s index=$o(@ref@(index)) q:index=""  d ..Show($name(@ref@(index)),"")
}

/// Description: 获取夜查房任务详情
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: DHCINM.CHK.MgQualCheckTask
/// Input: 质控类型 任务ID
/// Output: 夜查房任务详情
/// Other: w ##class(web.INMQualControlComm).GetCheckPanes("1")
ClassMethod GetCheckPanes(taskid As %String = "") As %String
{
	q:taskid="" ""
	q:'$d(^DHCINM.CHK.MgQualCheckTaskD(taskid)) ""
	
	s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(taskid)
	s taskItem=$lg(taskGlo,2)
	s taskWard=$lg(taskGlo,6)
	s wardLen=$ll(taskWard)
	k tmpWard
	w "{""CheckWard"":["
	f i=1:1:wardLen
	{
		s ward=$li(taskWard,i)
		s wardGlo=$g(^CF.DHCINM.DB.MgWardD(ward))
		s wardDesc=$lg(wardGlo,4)
		w "{"""_"WardId"_""":"""_ward_""",""WardDesc"":"""_wardDesc_"""}"
		w:i<wardLen ","
		s tmpWard(i)=ward
	}
	
	w "],""CheckBasic"":["
 	s sysParId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," NIGHTCHECKBASIC",""))
 	i sysParId'="" d
 	.s now=+$h,tmpBasicData=""
 	.s sort="" f  s sort=$o(^CT.DHCINM.Set.MgSysParamSubI("Sort",sysParId,sort)) q:sort=""  d
 	..s sysSubId="" f  s sysSubId=$o(^CT.DHCINM.Set.MgSysParamSubI("Sort",sysParId,sort,sysSubId)) q:sysSubId=""  d
 	...q:'$d(^CT.DHCINM.Set.MgSysParamSubD(sysParId,sysSubId))
 	...s sysSubGlo=^CT.DHCINM.Set.MgSysParamSubD(sysParId,sysSubId)
 	...s sysCode=$lg(sysSubGlo,2)
 	...q:'$d(^oddCOM("DHCINM.CHK.MgNurNightBasic","a",sysCode))
 	...s sysSubStDate=$lg(sysSubGlo,8)
 	...s sysSubEndDate=$lg(sysSubGlo,9)
 	...q:(sysSubStDate="")||(sysSubStDate>now)||((sysSubEndDate'="")&&(sysSubEndDate<now))
 	...s tmpBasicData=tmpBasicData_$case(tmpBasicData,"":"",:"」")_$lg(sysSubGlo,3)_"^"_sysCode_"^"_$case($lg(sysSubGlo,4),"N":"N",:"Y")_"^"_$lg(sysSubGlo,7)
 	e  s tmpBasicData="病人总数^CheckPat^Y^」重病人数^CheckSerPat^Y^」抢救人数急诊手术^CheckResPat^Y^」值班护士^CheckNightNur^Y^"
 	s basicLen=$l(tmpBasicData,"」")
 	s:tmpBasicData="" basicLen=0
 	f i=1:1:basicLen
 	{
 		s item=$p(tmpBasicData,"」",i)
 		s desc=$p(item,"^")
 		s code=$p(item,"^",2)
 		s editable=$p(item,"^",3)
 		s remark=$p(item,"^",4)
 		w "{""Item"":"""_desc_""",""Code"":"""_code_""",""Editable"":"""_editable_""""
 		s sort="" f  s sort=$o(tmpWard(sort)) q:sort=""  d
 		.s wardId=tmpWard(sort)
 		.w ",""b"_wardId_""":"""
 		.s value=""
 		.s basicId=$o(^DHCINM.CHK.MgNurNightBasicI("Ward",taskid,wardId,""))
 		.i basicId'="" d
 		..s obj=##class(DHCINM.CHK.MgNurNightBasic).%OpenId(basicId)
 		..q:'$IsObject(obj)
 		..s value=$ZOBJPROPERTY(obj,code)
 		.e  i remark["##class" d
 		..s order=$replace(remark,"#date",$lg(taskGlo,9))
 		..s order=$replace(order,"#ward",wardId)
 		..s order="(value)s value="_order
 		..x (order,.value)
 		.w value_""""
 		i i<basicLen w "},"
 		e  w "}"
 	}
	
	s taskItemLen=$ll(taskItem)
	w "],""TaskPanel"":["
	s now=+$h,isChecked=0,resultStatus=""
	f i=1:1:taskItemLen
	{
		s itm=$li(taskItem,i)
		s qualPar=$p(itm,"「",2)
		
		///TODO:基础数据设置父节点停用时间自动停用子节点
		i '$d(^DHCINM.CHK.MgCheckResultI("Qual",taskid,qualPar)) d
		.k @"tmp",tmpQualItemInfo
		.q:$d(^CT.DHCINM.DB.MgQualItemD(qualPar))#2'=1
		.s qualGlo=^CT.DHCINM.DB.MgQualItemD(qualPar)
		.s qualStDate=$lg(qualGlo,14)
		.s qualEndDate=$lg(qualGlo,15)
		.q:(qualStDate>now)||((qualEndDate'="")&&(qualEndDate<now))
		.k tmpQualItemInfo
		.s tmpQualItemInfo=##class(web.INMDBComm).GetQualItem(qualPar)
		.d ##class(web.INMVueComm).SplitStr(tmpQualItemInfo,"^","|",.tmpQualItemInfo)
		.s qualScoreType=$g(tmpQualItemInfo("QualScoreType"))
		.s qualScoreTypeSub=$g(tmpQualItemInfo("QualScoreTypeSub"))
		.s qualStandardMode=$g(tmpQualItemInfo("QualStandardMode"))
		.s CheckScoreFlag=$g(tmpQualItemInfo("QualScoreFlag"))
		.k tmpLeaf,@"tmpAll"
		.s subId="" f  s subId=$o(^CT.DHCINM.DB.MgQualItemSubI("parr",qualPar,subId)) q:subId=""  d
		..q:'$d(^CT.DHCINM.DB.MgQualItemSubD(qualPar,subId))
		..s qualSubGlo=^CT.DHCINM.DB.MgQualItemSubD(qualPar,subId)
		..s qualSubStDate=$lg(qualSubGlo,7)
		..s qualSubEndDate=$lg(qualSubGlo,8)
		..q:(qualSubStDate>now)||((qualSubEndDate'="")&&(qualSubEndDate<now))
		..s qualSubSort=$lg(qualSubGlo,6)
		..q:qualSubSort=""
		..s @("tmpAll("_$tr(qualSubSort,".",",")_")")=qualPar_"||"_subId
		..s:'$d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_qualPar_"||"_subId)) tmpLeaf(qualSubSort)=qualPar_"||"_subId
		.s deepth=1
		.s subId="" f  s subId=$o(^CT.DHCINM.DB.MgQualItemSubI("parr",qualPar,subId)) q:subId=""  d
		..q:'$d(^CT.DHCINM.DB.MgQualItemSubD(qualPar,subId))
		..s qualSubGlo=^CT.DHCINM.DB.MgQualItemSubD(qualPar,subId)
		..s qualSubStDate=$lg(qualSubGlo,7)
		..s qualSubEndDate=$lg(qualSubGlo,8)
		..q:(qualSubStDate>now)||((qualSubEndDate'="")&&(qualSubEndDate<now))
		..s qualSubSort=$lg(qualSubGlo,6)
		..q:qualSubSort=""
		..s:$l(qualSubSort,".")-1>deepth deepth=$l(qualSubSort,".")-1
		..s flag=1
		..s qualSubPar=$lg(qualSubGlo,5)
		..i qualSubPar'="" d
		...s qualSubParId1=$p(qualSubPar,"||")
		...s qualSubParId2=$p(qualSubPar,"||",2)
		...i '$d(^CT.DHCINM.DB.MgQualItemSubD(qualSubParId1,qualSubParId2)) s flag=0 q
		...s qualSubParGlo=^CT.DHCINM.DB.MgQualItemSubD(qualSubParId1,qualSubParId2)
		...s qualSubParStDate=$lg(qualSubParGlo,7)
		...s qualSubParEndDate=$lg(qualSubParGlo,8)
		...i (qualSubParStDate>now)||((qualSubParEndDate'="")&&(qualSubParEndDate<now)) s flag=0 q
		...s qualSubParSort=$lg(qualSubParGlo,6)
		...i qualSubParSort="" s flag=0 q
		..q:flag'=1
		..s hasChild=0
		..s:$d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_qualPar_"||"_subId)) hasChild=1
		..s score=$lg(qualSubGlo,4)
		..s:qualScoreType'=2 score=""
		..s:(qualScoreType'=2)&&(qualScoreTypeSub=1) score="√"
		..s:((qualScoreTypeSub=2)&&(CheckScoreFlag="Y")) score=$lg(qualSubGlo,4)
		..s holdScore=""
      	..i qualScoreTypeSub=4 d
      	...s sysParId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALSETTING",""))
      	...q:sysParId=""
      	...s sysSubId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," DEDUCTZERO",sysParId,""))
     	...q:sysSubId=""
     	...q:'$d(^CT.DHCINM.Set.MgSysParamSubD(sysParId,sysSubId))
      	...s sysGlo=^CT.DHCINM.Set.MgSysParamSubD(sysParId,sysSubId)
     	...s hold=$lg(sysGlo,4)
      	...q:(hold'=0)&&(hold'="")
      	...s holdScore=hold
		..s qualStandardList=""
		..i (qualScoreType'=2)&&(qualScoreTypeSub=1) s qualStandardList="是@√@el-icon-circle-check,否@×@el-icon-circle-close,不适用@-@el-icon-warning-outline"
		..e  i (qualScoreType'=2)&&(qualScoreTypeSub=2) s qualStandardList="符合@@el-icon-circle-check,部分符合@@el-icon-remove-outline,不符合@@el-icon-circle-close,不适用@-@el-icon-warning-outline"
		..e  i (qualScoreType=2)&&(qualScoreTypeSub=5)&&(qualStandardMode=1) s qualStandardList=$lg(qualGlo,10)
		..e  i (qualScoreType=2)&&(((qualScoreTypeSub=5)&&(qualStandardMode=2))||(qualScoreTypeSub=6)) s qualStandardList=$lg(qualSubGlo,9)
		..i hasChild=0 s rowSpan=1
		..e  d
		...s rowSpan=0,tmpLeafSort="" f  s tmpLeafSort=$o(tmpLeaf(tmpLeafSort)) q:tmpLeafSort=""  d
		....s:($e(tmpLeafSort,1,$l(qualSubSort))=qualSubSort)&&($e(tmpLeafSort,$l(qualSubSort)+1,$l(qualSubSort)+1)=".") rowSpan=rowSpan+1
		..s tmpRoot="",rootLen=$l(qualSubSort,".")
		..f rootIndex=3:1:rootLen d
		...i tmpRoot="" s tmpRoot=""""_$p(qualSubSort,".",1,rootIndex)_""""
		...e  s tmpRoot=tmpRoot_","""_$p(qualSubSort,".",1,rootIndex)_""""
		..s roots="["_tmpRoot_"]"
		..i (qualSubPar'="")&&($o(@("tmpAll("_$tr(qualSubParSort,".",",")_")")@(""))=$p(qualSubSort,".",$L(qualSubSort,"."))) s fatherShow=1
		..e  s fatherShow=0
		..s ret="{""SubItem"":"""_##class(web.INMVueComm).FilterSpecialSymbols($lg(qualSubGlo,2))_""",""HasChild"":"""_hasChild_""",""QualSubId"":"""_qualPar_"||"_subId_""",""SubSort"":"""_qualSubSort_""""
		..s ret=ret_",""SubScore"":"""_score_""",""CheckMenu"":"""_qualStandardList_""",""RowSpan"":"""_rowSpan_""""
		..s ret=ret_",""FatherId"":"""_qualSubPar_""",""Roots"":"_roots_",""FatherShow"":"""_fatherShow_""""
		..s ward="" f  s ward=$o(tmpWard(ward)) q:ward=""  d
		...s wardId=tmpWard(ward)
		...s ret=ret_",""c"_wardId_""":"""_$case(qualScoreTypeSub,2:"",4:holdScore,5:"",6:"",:score)_""",""r"_wardId_""":"""",""a"_wardId_""":"""""
		..s ret=ret_"},"
		..s @("tmp("_$tr(qualSubSort,".",",")_")")=ret
		.w "{""Title"":"""_$p(itm,"「",1)_""",""Name"":"""_(i-1)_""",""QualId"":"""_qualPar_""",""ScoreType"":"""_qualScoreType_""",""CheckScoreFlag"":"""_CheckScoreFlag_""""
		.w ",""ScoreTypeSub"":"""_qualScoreTypeSub_""",""StandardMode"":"""_qualStandardMode_""",""Deepth"":"""_deepth_""",""CheckDate"":"""",""CheckPerson"":"""""
		.w ",""QualSubItems"":["
		.d ..Show("tmp","")
		.s nurSignRet=""
		.s wardsort="" f  s wardsort=$o(tmpWard(wardsort)) q:wardsort=""  d
		..s wardId=tmpWard(wardsort)
		..i nurSignRet="" s nurSignRet="""c"_wardId_""":"""",""r"_wardId_""":"""""
		..e  s nurSignRet=nurSignRet_",""c"_wardId_""":"""",""r"_wardId_""":"""""
		.s:nurSignRet'="" nurSignRet=","_nurSignRet
		.w "{""SubItem"":""护士签名"",""HasChild"":""0"",""QualSubId"":""headnur"",""SubSort"":""."",""SubScore"":"""",""CheckMenu"":"""""
		.w ",""RowSpan"":""1"",""FatherId"":"""",""Roots"":[],""FatherShow"":""0"""_nurSignRet_"}"
		.i i<taskItemLen w "]},"
		.e  w "]}"
		e  d
		.s:isChecked=0 isChecked=1
		.k @"tmp",tmpResult
		.s nurSignRet="",checkDate="",checkPerson=""
		.s wardId="" f  s wardId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskid,qualPar,wardId)) q:wardId=""  d
		..s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskid,qualPar,wardId,resultId)) q:resultId=""  d
		...q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
		...s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
		...s resultNur=$lg(resultGlo,12)
		...s:resultStatus'="S" resultStatus=$lg(resultGlo,7)
		...s tmpResult(wardId)=resultId
		...i nurSignRet="" s nurSignRet="""c"_wardId_""":"""_resultNur_""",""r"_wardId_""":"""",""a"_wardId_""":"""""
		...e  s nurSignRet=nurSignRet_",""c"_wardId_""":"""_resultNur_""",""r"_wardId_""":"""",""a"_wardId_""":"""""
		.s flag=0,tmpResultId=""
		.s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Qual",taskid,qualPar,resultId)) q:(resultId="")||(flag=1)  d
		..q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
		..s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
		..s resultScoreType=$lg(resultGlo,13)
		..s resultScoreTypeSub=$lg(resultGlo,14)
		..s resultStandardMode=$lg(resultGlo,15)
		..s CheckScoreFlag=$lg(resultGlo,29)
		..s tmpResultId=resultId
		..s flag=1
		.q:flag'=1
		.s resultId=tmpResultId
		.s checkPerson=$lg(resultGlo,19)
		.i checkPerson=0 s checkPerson="管理员"
		.e  i checkPerson'="" s checkPerson=$lg($g(^CF.DHCINM.DB.MgUserD(checkPerson)),2)
		.s checkDate=$lg(resultGlo,24)
		.s:checkDate'="" checkDate=$zd(checkDate,3)
		.k tmpLeaf,@"tmpAll"
		.s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
		..q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
		..s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
		..s resultSubSort=$lg(resultSubGlo,9)
		..q:resultSubSort=""
		..s @("tmpAll("_$tr(resultSubSort,".",",")_")")=resultId_"||"_resultSubId
		..s:'$d(^DHCINM.CHK.MgCheckResultSubI("Par",resultId_"||"_resultSubId)) tmpLeaf(resultSubSort)=resultId_"||"_resultSubId
		.s deepth=1
		.s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
		..q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
		..s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
		..s resultSubSort=$lg(resultSubGlo,9)
		..q:resultSubSort=""
		..s:$l(resultSubSort,".")-1>deepth deepth=$l(resultSubSort,".")-1
		..s resultSubParId=$lg(resultSubGlo,8)
		..s flag=1
		..i resultSubParId'="" d
		...s resultSubParId1=$p(resultSubParId,"||")
		...s resultSubParId2=$p(resultSubParId,"||",2)
		...i '$d(^DHCINM.CHK.MgCheckResultSubD(resultSubParId1,resultSubParId2)) s flag=0 q
		...s resultSubParGlo=^DHCINM.CHK.MgCheckResultSubD(resultSubParId1,resultSubParId2)
		...s resultSubParSort=$lg(resultSubParGlo,9)
		...i resultSubParSort="" s flag=0 q
		..q:flag'=1
		..s hasChild=0
		..s:$d(^DHCINM.CHK.MgCheckResultSubI("Par",resultId_"||"_resultSubId)) hasChild=1
		..s resultStandardList=""
		..i (resultScoreType'=2)&&(resultScoreTypeSub=1) s resultStandardList="是@√@el-icon-circle-check,否@×@el-icon-circle-close,不适用@-@el-icon-warning-outline"
		..e  i (resultScoreType'=2)&&(resultScoreTypeSub=2) s resultStandardList="符合@@el-icon-circle-check,部分符合@@el-icon-remove-outline,不符合@@el-icon-circle-close,不适用@-@el-icon-warning-outline"
		..e  i (resultScoreType=2)&&(resultScoreTypeSub=5)&&(resultStandardMode=1) s resultStandardList=$lg(resultGlo,16)
		..e  i (resultScoreType=2)&&(((resultScoreTypeSub=5)&&(resultStandardMode=2))||(resultScoreTypeSub=6)) s resultStandardList=$lg(resultSubGlo,10)
		..i hasChild=0 s rowSpan=1
		..e  d
		...s rowSpan=0,tmpLeafSort="" f  s tmpLeafSort=$o(tmpLeaf(tmpLeafSort)) q:tmpLeafSort=""  d
		....s:($e(tmpLeafSort,1,$l(resultSubSort))=resultSubSort)&&($e(tmpLeafSort,$l(resultSubSort)+1,$l(resultSubSort)+1)=".") rowSpan=rowSpan+1
		..s tmpRoot="",rootLen=$l(resultSubSort,".")
		..f rootIndex=3:1:rootLen d
		...i tmpRoot="" s tmpRoot=""""_$p(resultSubSort,".",1,rootIndex)_""""
		...e  s tmpRoot=tmpRoot_","""_$p(resultSubSort,".",1,rootIndex)_""""
		..s roots="["_tmpRoot_"]"
		..i (resultSubParId'="")&&($o(@("tmpAll("_$tr(resultSubParSort,".",",")_")")@(""))=$p(resultSubSort,".",$L(resultSubSort,"."))) s fatherShow=1
		..e  s fatherShow=0
		..s ret="{""SubItem"":"""_##class(web.INMVueComm).FilterSpecialSymbols($lg(resultSubGlo,2))_""",""HasChild"":"""_hasChild_""",""QualSubId"":"""_$lg(resultSubGlo,7)_""",""SubSort"":"""_resultSubSort_""""
		..s ret=ret_",""SubScore"":"""_$lg(resultSubGlo,5)_""",""CheckMenu"":"""_resultStandardList_""",""RowSpan"":"""_rowSpan_""",""FatherId"":"""_resultSubParId_""""
		..s ret=ret_",""Roots"":"_roots_",""FatherShow"":"""_fatherShow_""""
		..s ward="" f  s ward=$o(tmpWard(ward)) q:ward=""  d
		...s wardId=tmpWard(ward)
		...q:'$d(tmpResult(wardId))
		...s oResultId=tmpResult(wardId)
		...q:oResultId=""
		...s oResultSubId=$o(^DHCINM.CHK.MgCheckResultSubI("Sort",oResultId," "_resultSubSort,""))
		...q:'$d(^DHCINM.CHK.MgCheckResultSubD(oResultId,oResultSubId))
		...s oResultSubGlo=^DHCINM.CHK.MgCheckResultSubD(oResultId,oResultSubId)
		...s ret=ret_",""c"_wardId_""":"""_$lg(oResultSubGlo,3)_""",""r"_wardId_""":"""_$lg(oResultSubGlo,6)_""",""a"_wardId_""":"""_$lg(oResultSubGlo,15)_""""
		..s ret=ret_"},"
		..s @("tmp("_$tr(resultSubSort,".",",")_")")=ret
		.w "{""Title"":"""_$p(itm,"「",1)_""",""Name"":"""_(i-1)_""",""QualId"":"""_qualPar_""",""ScoreType"":"""_resultScoreType_""",""CheckScoreFlag"":"""_CheckScoreFlag_""""
		.w ",""ScoreTypeSub"":"""_resultScoreTypeSub_""",""StandardMode"":"""_resultStandardMode_""",""Deepth"":"""_deepth_""",""CheckDate"":"""_checkDate_""",""CheckPerson"":"""_checkPerson_""""
		.w ",""QualSubItems"":["
		.d ..Show("tmp","")
		.s:nurSignRet'="" nurSignRet=","_nurSignRet
		.w "{""SubItem"":""护士签名"",""HasChild"":""0"",""QualSubId"":""headnur"",""SubSort"":""."",""SubScore"":"""",""CheckMenu"":"""""
		.w ",""RowSpan"":""1"",""FatherId"":"""",""Roots"":[],""FatherShow"":""0"""_nurSignRet_"}"
		.i i<taskItemLen w "]},"
		.e  w "]}"
	}
	w "],""IsChecked"":"""_isChecked_""",""Status"":"""_resultStatus_"""}"
	q ""
}

/// Description: 保存夜查房检查基本信息
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: DHCINM.CHK.MgNurNightBasic DHCINM.CHK.MgQualCheckTask
/// Input: 基本表信息 病区ID 任务ID 登录人ID
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMQualControlComm).SaveCheckBasic("CheckPat|CheckSerPat|CheckResPat|CheckNightNur|」CheckPat|CheckSerPat|CheckResPat|CheckNightNur|","1^2","1")
ClassMethod SaveCheckBasic(parr As %String = "", wardparr As %String = "", taskid As %String = "") As %String
{
	q:(parr="")||(wardparr="")||(taskid="") 0
	s now=+$h
	
	s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskid)
	q:'$IsObject(taskObj)="" 0
	
	s $zt="error"
	ts
	s wardLen=$l(wardparr,"^"),flag=1
	f i=1:1:wardLen q:flag'=1  d
	.s ward=$p(wardparr,"^",i)
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	.q:'$IsObject(wardObj)
	.s basciId=$o(^DHCINM.CHK.MgNurNightBasicI("Ward",taskid,ward,""))
	.i basciId="" d
	..s obj=##class(DHCINM.CHK.MgNurNightBasic).%New()
	..s obj.CheckTask=taskObj
	..s obj.CheckTaskDate=taskObj.TaskStDate
	..s obj.CheckWard=wardObj
	.e  s obj=##class(DHCINM.CHK.MgNurNightBasic).%OpenId(basciId)
	.i '$IsObject(obj) s flag=0 q
	.s obj.CheckDate=now
	.s tmpBasicData=$p(parr,"」",i)
	.s len=$l(tmpBasicData,"^")
	.f j=1:1:len d
	..s data=$p(tmpBasicData,"^",j)
	..s p=$p(data,"|")
	..s value=$p(data,"|",2)
	..s $ZOBJPROPERTY(obj,p)=value
	.s sc=obj.%Save()
	.i $$$ISERR(sc) s flag=0
	
	i flag=1 tc  q 1
	e  tro  q 0
error
	tro
	q 0
}

/// Description: 保存夜查房检查打分信息
/// Date: 2020-06-05
/// Creator: wangpf
/// Table: DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckResultSub
/// Input: 基本表信息 病区ID 任务ID 登录人ID
/// Output: success error
/// Other: w ##class(web.INMQualControlComm).SaveCheckScore(^tmp("SaveCheckScoreparr"),^tmp("SaveCheckScorewardid"),^tmp("SaveCheckScoretaskid"),^tmp("SaveCheckScorequalid"),^tmp("SaveCheckScorescore"),^tmp("SaveCheckScorenurseid"))
ClassMethod SaveCheckScore(parr As %String = "", wardid As %String = "", taskid As %String = "", qualid As %String = "", score As %String = "", nurseid As %String = "", status As %String = "") As %String
{
	s ^tmp("SaveCheckScoreparr")=parr
	s ^tmp("SaveCheckScorewardid")=wardid
	s ^tmp("SaveCheckScoretaskid")=taskid
	s ^tmp("SaveCheckScorequalid")=qualid
	s ^tmp("SaveCheckScorescore")=score
	s ^tmp("SaveCheckScorenurseid")=nurseid
	s ^tmp("status")=status
	s success="{""code"":""1"",""ward"":"""_wardid_""",""qual"":"""_qualid_"""}"
	s error="{""code"":""-1"",""ward"":"""_wardid_""",""qual"":"""_qualid_"""}"
	q:(parr="")||(wardid="")||(taskid="")||(qualid="")||(nurseid="")||(status="") error
	
	s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardid)
	q:'$IsObject(wardObj) error
	s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskid)
	q:'$IsObject(taskObj) error
	s flag=0
	s key="" f  s item=taskObj.TaskItem.GetNext(.key) q:key=""  d
	.s qualId=$p(item,"「",2)
	.s:qualId=qualid flag=1
	q:flag'=1 error
	s qualObj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(qualid)
	q:'$IsObject(qualObj) error
	s checker=$p(nurseid,",")
	s signer=$p(nurseid,",",2)
	i checker'=0 d
	.s checkerObj=##class(CF.DHCINM.DB.MgUser).%OpenId(checker)
	.s:'$IsObject(checkerObj) flag=0
	q:flag'=1 error
	i (signer'="")&&(signer'=0) d
	.s signerObj=##class(CF.DHCINM.DB.MgUser).%OpenId(signer)
	.s:'$IsObject(signerObj) flag=0
	q:flag'=1 error
	
	s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskid,qualid,wardid,""))
	i resultId="" d
	.k tmpQualItemInfo
	.s tmpQualItemInfo=##class(web.INMDBComm).GetQualItem(qualid)
	.d ##class(web.INMVueComm).SplitStr(tmpQualItemInfo,"^","|",.tmpQualItemInfo)
	.s qualScoreType=$g(tmpQualItemInfo("QualScoreType"))
	.s qualScoreTypeSub=$g(tmpQualItemInfo("QualScoreTypeSub"))
	.s qualStandardMode=$g(tmpQualItemInfo("QualStandardMode"))
	.s qualStandardList=$g(tmpQualItemInfo("QualStandardList"))
	.s qualInsert=$g(tmpQualItemInfo("QualInsert"))
	.s qualInsertCount=$g(tmpQualItemInfo("QualInsertCount"))
	.s resultObj=##class(DHCINM.CHK.MgCheckResult).%New()
	.s resultObj.CheckWard=wardObj
	.s resultObj.CheckTask=taskObj
	.s resultObj.CheckType=taskObj.TaskType
	.s resultObj.CheckItem=qualObj
	.s resultObj.CheckScoreType=qualScoreType
	.s resultObj.CheckScoreTypeSub=qualScoreTypeSub
	.s resultObj.CheckStandardMode=qualStandardMode
	.s resultObj.CheckStandardList=qualStandardList
	.s resultObj.CheckInsert=qualInsert
	.s resultObj.CheckInsertCount=qualInsertCount
	.s resultObj.CreateUser=checker
	.s resultObj.CheckDate=taskObj.TaskStDate
	.s resultObj.CheckPass=qualObj.QualPass
	.s resultObj.CheckAccordScoreSum=$P(score,",",2)
	.s resultObj.CheckScoreFlag=qualObj.QualScoreFlag
	e  s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	i '$IsObject(resultObj) q error
	s resultObj.CheckScore=$P(score,",",1)
	s resultObj.CheckAccordScore=$P(score,",",3)
	s resultObj.CheckStatus=status
	;s resultObj.CheckStatus="S"
	s resultObj.CheckUser=checker
	s resultObj.SignUser=signer
	s resultObj.CheckNurse=$p($p(parr,"ˇ",$L(parr,"ˇ")),"^")
	s now=$h
	s resultObj.SubmitDate=$p(now,",")
	s resultObj.SubmitTime=$p(now,",",2)
	TS
	s sc=resultObj.%Save()
	s flag=$$$ISOK(sc)
	i flag=1
	{
		s len=$l(parr,"ˇ")-1
		f i=1:1:len
		{
			s itm=$p(parr,"ˇ",i)
			i itm="" continue
			s value=$p(itm,"^")
			s remark=$p(itm,"^",2)
			s qualSubId=$p(itm,"^",3)
			s SubAccordScore=$P(itm,"^",4)
			s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubI("Qual",resultObj.%Id(),qualSubId,""))
			i resultSubId="" d
			.s qualSubObj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(qualSubId)
			.i '$IsObject(qualSubObj) s flag=0 q
			.s resultSubObj=##class(DHCINM.CHK.MgCheckResultSub).%New()
			.s resultSubObj.Parref=resultObj
			.s resultSubObj.SubItem=qualSubObj.SubDesc
			.s resultSubObj.SubStandard=qualSubObj.SubStandard
			.s resultSubObj.SubStandardScore=qualSubObj.SubScore
			.s resultSubObj.SubReference=qualSubObj
			.s resultSubObj.SubSort=qualSubObj.SubSort
			.i $l(resultSubObj.SubSort,".")>2 d
			..s sortLen=$L(resultSubObj.SubSort,".")
			..s resultSubParSort=$e(resultSubObj.SubSort,1,*-$l($p(resultSubObj.SubSort,".",sortLen))-1)
			..s resultSubParId=$o(^DHCINM.CHK.MgCheckResultSubI("Sort",resultObj.%Id()," "_resultSubParSort,""))
			..s resultSubParObj=##class(DHCINM.CHK.MgCheckResultSub).%OpenId(resultObj.%Id()_"||"_resultSubParId)
			..i '$IsObject(resultSubParObj) s flag=0 q
			..s resultSubObj.SubParent=resultSubParObj
			.s resultSubObj.SubStandardList=qualSubObj.SubStandardList
			e  s resultSubObj=##class(DHCINM.CHK.MgCheckResultSub).%OpenId(resultObj.%Id()_"||"_resultSubId)
			q:flag'=1
			i '$IsObject(resultSubObj) s flag=0 q
			s resultSubObj.SubScore=value
			s resultSubObj.SubRemark=remark
			s resultSubObj.SubAccordScore=SubAccordScore
			s sc=resultSubObj.%Save()
			s flag=$$$ISOK(sc)
			q:flag'=1
		}
	}
	i flag=1
	{
		TC
		w success
	}
	else
	{
		TRo
		w error
	}
	q ""
}

/// Description:查询夜查房计划检查人员
/// Creator:wangpf
/// Date:2020-06-13
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:TaskId 登录人Id flag
/// Output：夜查房计划检查人员
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckPersonsList",418,0)
Query FindCheckPersonsList(id As %String = "", perid As %String = "", flag As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPersonsListExecute(ByRef qHandle As %Binary, id As %String = "", perid As %String = "", flag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (id="")||(perid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i '$d(^DHCINM.CHK.MgQualCheckTaskD(id)) Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(id)
	s checkers=$lg(taskGlo,4)
	s ptr=0 f  s status=$listnext(checkers,ptr,checker) q:status'=1  d
	.q:(perid'=0)&&(flag'=1)&&(perid=checker) ;换班人员不能是自己
	.q:(perid'=0)&&(flag=1)&&(perid'=checker) ;交换人员只能是自己
	.q:'$d(^CF.DHCINM.HR.PersonsD(checker))
	.s perGlo=^CF.DHCINM.HR.PersonsD(checker)
	.s perName=$lg(perGlo,2)
	.s ret="PerDR|"_checker_"^PerName|"_perName
	.d OutNurseList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPersonsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPersonsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPersonsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPersonsListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:获取某天夜查房未检查任务
/// Date:2020-06-13
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:日期 质控类型
/// Output：
/// Others: w ##class(web.INMQualControlComm).GetTaskByDate("5__2^5__4^5__5","2020-06-29")
ClassMethod GetTaskByDate(type As %String = "", date As %String = "") As %String
{
	q:(type="")||(date="") "[]"
	s type=$tr(type,"_","|")
	s:date["-" date=$zdh(date,3)
	
	w "["
	s typeList=$lfs(type,"^")
	s first=1
	s ptr=0 f  s status=$listnext(typeList,ptr,typ) q:status'=1  d
	.s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate"," N",typ,date,taskId)) q:taskId=""  d
	..q:$d(^DHCINM.CHK.MgCheckResultI("Qual",taskId))
	..q:'$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	..s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(taskId)
	..s taskItem=$lg(taskGlo,2)
	..s firstQual=$lg(taskItem,1)
	..s qualDesc=$p(firstQual,"「")
	..s:$ll(taskItem)>1 qualDesc=qualDesc_"..."
	..w:first'=1 ","
	..w "{""rw"":"""_taskId_""",""title"":"""_qualDesc_"""}"
	..s first=0
	w "]"
	q ""
}

/// Description:任务是否可删除
/// Date:2020-06-13
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:TaskId
/// Output: 1：可删除
/// Other:w ##class(web.INMQualControlComm).IsAbleDelete(5)
ClassMethod IsAbleDelete(id As %String = "") As %String
{
	q:id="" "传值不能为空"
	q:'$d(^DHCINM.CHK.MgQualCheckTaskD(id)) "未找到排班"
	s ret=1
	i $d(^DHCINM.CHK.MgNurNightBasicI("Ward",id)) s ret="已进行巡查，不可删除"
	i $d(^DHCINM.CHK.MgCheckResultI("Qual",id)) s ret="已进行巡查，不可删除"
	q ret
}

/// Description:删除夜查房任务
/// Date:2020-06-13
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:TaskId 登录人角色
/// Output：0：失败 1：成功
/// Other:w ##class(web.INMQualControlComm).DeleteNightTask(4,0)
ClassMethod DeleteNightTask(schduleid As %String = "", nurseid As %String = "") As %String
{
	q:(schduleid="")||(nurseid="") "入参错误,请刷新重试"
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) "获取登录人员失败,请刷新重试"
	
	s role=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	s isHLB=0
	f i=1:1:$l(role,"^") q:isHLB=1  d
	.s tRole=$p(role,"^",i)
	.q:tRole=""
	.i tRole=0 s isHLB=1
	.e  d
	..s RoleObj=##class(CT.DHCINM.Set.MgRoles).%OpenId(tRole)
	..i $IsObject(RoleObj) d
	...s rolecode=$zcvt(RoleObj.RoleCode,"U")
	...s:(rolecode="ADMIN")||(rolecode="MANAGER")||(rolecode="HLB") isHLB=1
	q:isHLB=0 "非护理部不可删除"
	
	s flag=1
	TS
	s sc=##class(DHCINM.CHK.MgQualCheckTask).%DeleteId(schduleid)
	i $$$ISERR(sc) s flag=0
	i flag=1
	{
		s shiftIndex=$lb("ShiftPer","ShiftToPer")
		s ptr=0 f  s status=$listnext(shiftIndex,ptr,index) q:(status'=1)||(flag'=1)  d
		.s shiftId="" f  s shiftId=$O(^DHCINM.CHK.MgNurCheckShiftI(index,schduleid,shiftId)) q:(shiftId="")||(flag'=1)  d
		..s shiftObj=##class(DHCINM.CHK.MgNurCheckShift).%OpenId(shiftId)
		..q:'$IsObject(shiftObj)
		..q:(shiftObj.ShiftStatus="HA")||(shiftObj.ShiftStatus="C")
		..s shiftObj.ShiftStatus="C"
		..s sc=shiftObj.%Save()
		..s:$$$ISERR(sc) flag=0
	}
	
	i flag=1
	{
		TC
		q 1
	}else{
		TRO
		q "修改换班信息失败"
	}
}

/// Description:保存夜查房换班数据
/// Date:2020-06-13
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:TaskId 登录人Id flag
/// Output：1：成功
/// Other:w ##class(web.INMQualControlComm).SaveCheckShift()
ClassMethod SaveCheckShift(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") "传参错误，请刷新界面重试"
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) "获取登录人信息失败"
	
	s toDate=$p(parr,"^",1)
	s:toDate["-" toDate=$zdh(toDate,3)
	s toTask=$p(parr,"^",2)
	s toPer=$p(parr,"^",3)
	s fromDate=$p(parr,"^",4)
	s:fromDate["-" fromDate=$zdh(fromDate,3)
	s fromTask=$p(parr,"^",5)
	s fromPer=$p(parr,"^",6)
	s remark=$p(parr,"^",7)
	s status=$p(parr,"^",8)
	s RowID=$p(parr,"^",9)
	q:(fromDate="")||(fromTask="")||(fromPer="")||(toDate="")||(toTask="")||(toPer="")||(status="")||(nurseid="") "传参错误，请刷新界面重试"
	q:(fromPer=toPer) "换班人不能相同"
	q:(fromTask=toTask) "换班班次不能相同"
	s toTaskObjLB=$g(^DHCINM.CHK.MgQualCheckTaskD(toTask))
	q:toTaskObjLB="" "获取换班信息错误"
	s toTaskCheckWard=$LG(toTaskObjLB,6)
	s fromTaskObjLB=$g(^DHCINM.CHK.MgQualCheckTaskD(fromTask))
	q:fromTaskObjLB="" "获取交换信息错误"
	s fromTaskCheckWard=$LG(fromTaskObjLB,6)
	s flag=1
	i RowID="" d
	.i $d(^DHCINM.CHK.MgNurCheckShiftI("ShiftPer",fromTask,fromPer)) s flag="交换人员存在换班申请" q
	.i $d(^DHCINM.CHK.MgNurCheckShiftI("ShiftToPer",toTask,toPer)) s flag="换班人员存在换班申请" q
	.s obj=##class(DHCINM.CHK.MgNurCheckShift).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.CHK.MgNurCheckShift).%OpenId(RowID)
	q:(flag'=1) flag
	q:'$IsObject(obj) 0
	s obj.ShiftStatus=status
	s obj.ShiftDate=fromDate
	s obj.ShiftToDate=toDate
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(fromPer)
	q:'$IsObject(perObj) "获取交换人员信息失败"
	s fromPerwardIntoDate=##class(web.INMHRComm).GetCurrentWard(fromPer,toDate)
	q:$LF(toTaskCheckWard,fromPerwardIntoDate)>0 "换班人员在交换班次病区"
	s obj.ShiftPer=perObj
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(toPer)
	q:'$IsObject(perObj) "获取换班人员信息失败"
	s toPerwardInFromDate=##class(web.INMHRComm).GetCurrentWard(fromPer,fromDate)
	q:$LF(fromTaskCheckWard,toPerwardInFromDate)>0 "换班人员在交换班次病区"
	s obj.ShiftToPer=perObj
	s schObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(fromTask)
	q:'$IsObject(schObj) "获取交换班次信息失败"
	s obj.ShiftPost=schObj
	s schObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(toTask)
	q:'$IsObject(schObj) "获取换班班次信息失败"
	s obj.ShiftToPost=schObj
	s obj.ShiftRemark=remark
	s obj.Updator=nurseid
	s now=$h
	s obj.UpdateDate=+now
	s obj.UpdateTime=$p(now,",",2)
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description:查询换班数据
/// Date:2020-06-15
/// Creator:wangpf
/// Table:DHCINM.CHK.MgNurCheckShift
/// Input:Id
/// Output：换班数据
/// Other:w ##class(web.INMQualControlComm).GetCheckShift(1)
ClassMethod GetCheckShift(id As %String = "") As %String
{
	q:id="" ""
	q:'$d(^DHCINM.CHK.MgNurCheckShiftD(id)) ""
	s shiftGlo=^DHCINM.CHK.MgNurCheckShiftD(id)
	s shiftFromDate=$lg(shiftGlo,3)
	s:shiftFromDate'="" shiftFromDate=$zd(shiftFromDate,3)
	s shiftToDate=$lg(shiftGlo,4)
	s:shiftToDate'="" shiftToDate=$zd(shiftToDate,3)
	s shiftFromPer=$lg(shiftGlo,5)
	s shiftFromPerName=""
	i shiftFromPer'="" d
	.q:'$d(^CF.DHCINM.HR.PersonsD(shiftFromPer))
	.s perGlo=^CF.DHCINM.HR.PersonsD(shiftFromPer)
	.s shiftFromPerName=$lg(perGlo,2)
	s shiftToPer=$lg(shiftGlo,6)
	s shiftToPerName=""
	i shiftToPer'="" d
	.q:'$d(^CF.DHCINM.HR.PersonsD(shiftToPer))
	.s perGlo=^CF.DHCINM.HR.PersonsD(shiftToPer)
	.s shiftToPerName=$lg(perGlo,2)
	s shiftPost=$lg(shiftGlo,7)
	s shiftToPost=$lg(shiftGlo,8)
	s shiftRemark=$lg(shiftGlo,9)
	s shiftCreator=$lg(shiftGlo,10)
	s shiftCreatorName=""
	i shiftCreator=0 s shiftCreatorName="管理员"
	e  i shiftCreator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(shiftCreator))
	.s shiftCreatorName=$lg(perGlo,2)
	s shiftUpdater=$lg(shiftGlo,13)
	s shiftUpdaterName=""
	i shiftUpdater=0 s shiftUpdaterName="管理员"
	e  i shiftUpdater'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(shiftUpdater))
	.s shiftUpdaterName=$lg(perGlo,2)
	s shiftStatus=$lg(shiftGlo,2)
	s:((shiftPost="")||(shiftToPost="")||($g(^DHCINM.CHK.MgQualCheckTaskD(shiftPost))="")||($g(^DHCINM.CHK.MgQualCheckTaskD(shiftToPost))="")) shiftStatus="C"
	s shiftStatusDesc=$case(shiftStatus,"C":"作废","N":"保存","S":"提交","NA":"护士长已审核","HA":"护理部已审核","B":"驳回","":"")
	s ret="ShiftStatus|"_shiftStatus_"^ShiftStatusDesc|"_shiftStatusDesc_"^ShiftDate|"_shiftFromDate_"^ShiftPer|"_shiftFromPer_"^ShiftPerName|"_shiftFromPerName
	s ret=ret_"^ShiftToDate|"_shiftToDate_"^ShiftToPer|"_shiftToPer_"^ShiftToPerName|"_shiftToPerName_"^Creator|"_shiftCreator_"^CreatorName|"_shiftCreatorName
	s ret=ret_"^Updater|"_shiftUpdater_"^UpdaterName|"_shiftUpdaterName_"^ShiftPost|"_shiftPost_"^ShiftToPost|"_shiftToPost_"^rw|"_id
	q ret
}

/// Description:查询换班列表数据
/// Date:2020-06-15
/// Creator:wangpf
/// Table:DHCINM.CHK.MgNurCheckShift
/// Input:TaskId 登录人角色 登录人Id
/// Output：换班列表数据
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckShiftList","^",47,0)
Query FindCheckShiftList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckShiftListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i ((parr="")||(nurseid="")) {
		Set qHandle=$lb(0,repid,0) Quit $$$OK
	}
	
	s fromDate=$p(parr,"^")
	i fromDate["-" s fromDate=$zdh(fromDate,3)
	.e  s fromDate=""
	s toDate=$p(parr,"^",2)
	i toDate["-" s toDate=$zdh(toDate,3)
	.e  s toDate=""
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id="" f  s id=$o(^DHCINM.CHK.MgNurCheckShiftD(id)) q:id=""  d
	.q:'$d(^DHCINM.CHK.MgNurCheckShiftD(id))
	.s shiftGlo=^DHCINM.CHK.MgNurCheckShiftD(id)
	.s shiftFromDate=$lg(shiftGlo,3)
	.s shiftToDate=$lg(shiftGlo,4)
	.q:(fromDate'="")&&(shiftFromDate<fromDate)&&(shiftToDate<fromDate)
	.q:(toDate'="")&&(shiftFromDate>toDate)&&(shiftToDate>toDate)
	.s shiftFromPer=$lg(shiftGlo,5)
	.s shiftToPer=$lg(shiftGlo,6)
	.s currward1=##class(web.INMHRComm).GetCurrentWard(shiftFromPer,shiftFromDate)
	.s currward2=##class(web.INMHRComm).GetCurrentWard(shiftToPer,shiftToDate)
	.s userPerId=""
	.i nurseid'=0 d
	..s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	..s userPerId=$lg(userGlo,5)
	.q:((isAll'=1)&&((currward1="")||(currward2="")))
	.q:(isAll'=1)&&(userPerId'=shiftFromPer)&&(userPerId'=shiftToPer)&&('$d(tmpWard(currward1)))&&('$d(tmpWard(currward2)))
	.s ret=..GetCheckShift(id)
 	.d OutCheckShiftList
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckShiftList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckShiftListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckShiftListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckShiftListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckShiftListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:更新夜查房换班申请状态
/// Date:2020-06-15
/// Creator:wangpf
/// Table:DHCINM.CHK.MgNurCheckShift
/// Input:Id^状态 
/// Output：1：成功 0：失败
/// Other:w ##class(web.INMQualControlComm).SaveShiftStatus("1,2^S",0,0)
ClassMethod SaveShiftStatus(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ids=$p(parr,"^")
	s status=$p(parr,"^",2)
	q:(ids="")||(status="") 0
	
	s role=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	
	s isHLB=0
	f i=1:1:$l(role,"^") q:isHLB=1  d
	.s trole=$p(role,"^",i)
	.q:trole=""
	.i trole'=0 d
	..s roleObj=##class(CT.DHCINM.Set.MgRoles).%OpenId(trole)
	..i $IsObject(roleObj) d
	...s code=$zcvt(roleObj.RoleCode,"U")
	...i ((code="ADMIN")||(code="MANAGER")||(code="HLBZR")||(code="HLB")) s isHLB=1
	.e  s isHLB=1
	s:(isHLB=0)&&(status="A") status="NA"
	s:(isHLB=1)&&(status="A") status="HA"
	s perId=$LG($g(^CF.DHCINM.DB.MgUserD(nurseid)),5)
	q:((isHLB=0)&&(perId="")) 0
	s now=$h
	TS
	s flag=1
	k trackMessage
	s trackMessage=""
	f i=1:1:$l(ids,",") q:flag'=1  d
	.s id=$p(ids,",",i)
	.s obj=##class(DHCINM.CHK.MgNurCheckShift).%OpenId(id)
	.q:'$IsObject(obj)
	.i (status="NA")&&((","_obj.ShiftToPer.%Id()_",")'[(","_perId_",")) s flag="须交换者先审批" q ;交换者先审批
	.i (obj.ShiftStatus="B")||(obj.ShiftStatus="HA")||(obj.ShiftStatus="C") s flag="该状态不可操作" q ;已驳回/护理部已审核/作废，不可驳回，不可审核
	.i (nurseid'=0)&&(obj.ShiftStatus="NA")&&(status="NA") s flag="护士长已审核，不可继续护士长审核" q ;护士长已审核，不可继续护士长审核
	.i (nurseid'=0)&&(obj.ShiftStatus'="NA")&&(status="HA") s flag="护士长未审核，护理部不可审核" q ;护士长未审核，护理部不可审核
	.q:'$IsObject(obj.ShiftPost)
	.q:'$IsObject(obj.ShiftToPost)
	.s obj.ShiftStatus=status
	.s obj.UpdateDate=+now
	.s obj.UpdateTime=$p(now,",",2)
	.s obj.Updator=nurseid
	.s sc=obj.%Save()
	.i $$$ISERR(sc) s flag=0 q
	.q:status'="HA"
	.s fromPerList=obj.ShiftPost.TaskCheckPerson
	.s fromIndex=fromPerList.Find(obj.ShiftPer.%Id())
	.s toPerList=obj.ShiftToPost.TaskCheckPerson
	.s toIndex=toPerList.Find(obj.ShiftToPer.%Id())
	.q:(fromIndex="")||(toIndex="")
	.s sc1=obj.ShiftPost.TaskCheckPerson.SetAt(obj.ShiftToPer.%Id(),fromIndex)
	.s sc2=obj.ShiftToPost.TaskCheckPerson.SetAt(obj.ShiftPer.%Id(),toIndex)
	.i $$$ISERR(sc1)||$$$ISERR(sc2) s flag=0 q
	.s sc1=obj.ShiftPost.%Save()
	.s sc2=obj.ShiftToPost.%Save()
	.i $$$ISERR(sc1)||$$$ISERR(sc2) s flag=0 q
	.i ((obj.ShiftStatus="NA")||(obj.ShiftStatus="B")||(obj.ShiftStatus="HA")) d
	..s ShiftStatus=$case(obj.ShiftStatus,"NA":"交换护士长审核","HA":"护理部审核","B":"驳回")
	..s ShiftDate=obj.ShiftDate
	..s:ShiftDate'="" ShiftDate=$zd(ShiftDate,3)
	..s ShiftToDate=obj.ShiftToDate
	..s:ShiftToDate'="" ShiftToDate=$zd(ShiftToDate,3)
	..s ShfitPer=obj.ShiftPer.PerName
	..s ShiftToPer=obj.ShiftToPer.PerName
	..s ShiftPerId=obj.ShiftPer
	..s userShiftId=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_ShiftPerId,""))
	..s ShfitPerToId=obj.ShiftToPer
	..s userShiftToId=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_ShfitPerToId,""))
	..s ret="【质量管理/换班申请】"_ShiftStatus_" "_ShiftDate_" "_ShfitPer_"->"_ShiftToDate_" "_ShiftToPer
	..s:userShiftId'="" trackMessage(id,userShiftId)=ret
	..s:userShiftToId'="" trackMessage(id,userShiftToId)=ret
	i flag=1{
		TC
		try{
			s id="" f  s id=$O(trackMessage(id)) q:id=""  d
			.s userId="" f  s userId=$O(trackMessage(id,userId)) q:userId=""  d
			..s ret=$g(trackMessage(id,userId))
			..q:ret=""
			..d ##class(web.INMPlatform).SaveTrackMessage(userId,+$H,ret,"","DHCINM.CHK.MgNurCheckShift",id)
		}catch{
			}
		q 1	
	}else {
		TRO
		q flag	
	}
}

/// Description:保存质控检查组
/// Date:2020-06-16
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualGroup
/// Input:登录ID
/// Output：1：成功 0：失败
/// Other:w ##class(web.INMQualControlComm).SaveCheckGroup("H^测试^1,2,3,4^测试^",0,0)
ClassMethod SaveCheckGroup(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	s level=$p(parr,"^")
	s desc=$p(parr,"^",2)
	s member=$p(parr,"^",3)
	s remark=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	q:level="" 0
	
	i rw="" d
	.s obj=##class(DHCINM.CHK.MgQualGroup).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.CHK.MgQualGroup).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.GroupDesc=desc
	s obj.GroupLevel=level
	s obj.GroupRemark=remark
	d obj.GroupMember.Clear()
	f i=1:1:$l(member,",") d
	.s perdr=$p(member,",",i)
	.q:'$d(^CF.DHCINM.HR.PersonsD(perdr))
	.d obj.GroupMember.Insert(perdr)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description：获取角色拥有的质控检查组级别
/// Date:2020-06-15
/// Creator:wangpf
/// Table:CT.DHCINM.Set.MgRoles
/// Input: 角色ID
/// Output:质控检查组级别
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckGroupLevels","0")
Query FindCheckGroupLevels(role As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckGroupLevelsExecute(ByRef qHandle As %Binary, role As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i role="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s roleList=$lfs(role,"^")
	
	k tmp
	s ptr=0 f  s status=$listnext(roleList,ptr,roleId) q:status'=1  d
	.i roleId=0 s tmp("W")="病区自查",tmp("L")="科室督查",tmp("H")="护理部" q
	.q:'$d(^CT.DHCINM.Set.MgRolesD(roleId))
	.s roleGlo=^CT.DHCINM.Set.MgRolesD(roleId)
	.s roleCode=$zcvt($lg(roleGlo,2),"U")
	.i (roleCode="ADMIN")||(roleCode="MANAGER") s tmp("W")="病区自查",tmp("L")="科室督查",tmp("H")="护理部"
	.e  i roleCode="NURHEAD" s tmp("W")="病区自查"
	.e  i roleCode="ZNURHEAD" s tmp("L")="科室督查"
	.e  i (roleCode="HLB")||(roleCode="HLBZR") s tmp("H")="护理部"
	
	s i="" f  s i=$o(tmp(i)) q:i=""  d
	.s ret="LevelCode|"_i_"^LevelName|"_tmp(i)
	.d OutCheckGroupLevelsData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckGroupLevelsData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckGroupLevelsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckGroupLevelsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckGroupLevelsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckGroupLevelsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:获取质控检查组
/// Date:2020-06-16
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualGroup
/// Input:id
/// Output：质控检查组
/// Other:w ##class(web.INMQualControlComm).GetQualGroup(1)
ClassMethod GetQualGroup(id As %String = "") As %String
{
	q:id="" ""
	q:'$d(^DHCINM.CHK.MgQualGroupD(id)) ""
	s groupGlo=^DHCINM.CHK.MgQualGroupD(id)
	s groupDesc=$lg(groupGlo,2)
	s groupMember=$lg(groupGlo,3)
	s groupMemberId=$lts(groupMember)
	s groupMemberDesc=""
	s counter=0,ptr=0 f  s status=$listnext(groupMember,ptr,per) q:status'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.i counter=0 s groupMemberDesc=$lg(perGlo,2)
	.e  s groupMemberDesc=groupMemberDesc_","_$lg(perGlo,2)
	.s counter=counter+1
	s groupLevel=$lg(groupGlo,4)
	s groupLevelDesc=$case(groupLevel,"W":"病区自查","L":"科室督查","H":"护理部","":"")
	s groupRemark=$lg(groupGlo,5)
	s ret="GroupDesc|"_groupDesc_"^GroupMember|"_groupMemberId_"^GroupMemberDesc|"_groupMemberDesc_"^GroupLevel|"_groupLevel
	s ret=ret_"^GroupLevelDesc|"_groupLevelDesc_"^GroupRemark|"_groupRemark_"^rw|"_id
	q ret
}

/// creator:lulin
/// createdate:2018-05-25
/// description:获取质控检查组列表
/// input:登录ID^登录角色
/// output:质控检查组列表
/// other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQualGroup",0)
Query FindQualGroup(nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQualGroupExecute(ByRef qHandle As %Binary, nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s role=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	s roleList=$lfs(role,"^")
	k tmp
	s ptr=0 f  s status=$listnext(roleList,ptr,roleId) q:status'=1  d
	.q:roleId=""
	.s roleCode=""
	.i roleId=0 s roleCode="ADMIN"
	.e  d
	..s roleGlo=$g(^CT.DHCINM.Set.MgRolesD(roleId))
	..s roleCode=$zcvt($lg(roleGlo,2),"U") 
	.q:roleCode=""
	.i (roleCode="ADMIN")||(roleCode="MANAGER") d
	..s groupId="" f  s groupId=$o(^DHCINM.CHK.MgQualGroupD(groupId)) q:groupId=""  d
	...s tmp(groupId)=..GetQualGroup(groupId)
	.e  i roleCode="NURHEAD"  d
	..s groupId="" f  s groupId=$o(^DHCINM.CHK.MgQualGroupI("Level"," W",groupId)) q:groupId=""  d
	...s tmp(groupId)=..GetQualGroup(groupId)
	.e  i (roleCode="ZNURHEAD") d
	..s groupId="" f  s groupId=$o(^DHCINM.CHK.MgQualGroupI("Level"," L",groupId)) q:groupId=""  d
	...s tmp(groupId)=..GetQualGroup(groupId)
	.e  i (roleCode="HLB")||(roleCode="HLBZR") d
	..s groupId="" f  s groupId=$o(^DHCINM.CHK.MgQualGroupI("Level"," H",groupId)) q:groupId=""  d
	...s tmp(groupId)=..GetQualGroup(groupId)
	
	s i="" f  s i=$o(tmp(i)) q:i=""  d
	.s ret=tmp(i)
	.d OutCheckGroupData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckGroupData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQualGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualGroupExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:获取所辖病区可分质控检查组成员信息
/// Creator:wangpf
/// Date:2020-06-16
/// Table:CT.DHCINM.Set.MgRoles CF.DHCINM.HR.Persons
/// Input:登录ID^登录角色^临时数组
/// Output：
/// Other:w ##class(web.INMQualControlComm).GetCheckPersons(0,0,"L",.tmp)
ClassMethod GetCheckPersons(nurseid As %String = "", groupLevel As %String = "", tmp)
{
#;	q:(groupLevel="")||(nurseid="")
#;	
#;	s nurHeadId=$o(^CT.DHCINM.Set.MgRolesI("code"," Y"," NURHEAD",""))
#;	s znurHeadId=$o(^CT.DHCINM.Set.MgRolesI("code"," Y"," ZNURHEAD",""))
#;	s codeList=$lb(nurHeadId,znurHeadId)
#;	k tmpWard
#;	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
#;	
#;	s flag=0,nowDate=+$h
#;	i groupLevel="W" d
#;	.s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsD(perId)) q:perId=""  d
#;	..q:'$d(^CF.DHCINM.HR.PersonsD(perId))
#;	..s perGlo=^CF.DHCINM.HR.PersonsD(perId)
#;	..s perWard=$lg(perGlo,10)
#;	..q:(isAll'=1)&&('$d(tmpWard(perWard)))
#;	..s tmp(perId)="rw|"_perId_"^PerName|"_$lg(perGlo,2)_"("_$lg(perGlo,3)_")"
#;	e  i (groupLevel="L")||(groupLevel="H") d
#;	.s ptr=0 f  s status=$listnext(codeList,ptr,roleId) q:status'=1  d
#;	..s userId="" f  s userId=$o(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userId)) q:userId=""  d
#;	...s roleId="" f  s roleId=$o(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userId,roleId)) q:roleId=""  d
#;	....q:'$d(^CF.DHCINM.DB.MgUserRoleD(roleId))
#;	....s nurRoleGlo=^CF.DHCINM.DB.MgUserRoleD(roleId)
#;	....s nurRoleStDate=$lg(nurRoleGlo,3)
#;	....s nurRoleEndDate=$lg(nurRoleGlo,4)
#;	....q:(nowDate<nurRoleStDate)||((nurRoleEndDate'="")&&(nurRoleEndDate<nowDate))
#;	....s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(userId)
#;	....q:'$IsObject(userObj)
#;	....s perId=userObj.PerDR
#;	....q:perId=""
#;	....s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
#;	....q:'$IsObject(perObj)
#;	....s perWard=perObj.PerDepDR
#;	....q:(isAll'=1)&&('$d(tmpWard(perWard)))
#;	....s tmp(perId)="rw|"_perId_"^PerName|"_$lg(perGlo,2)_"("_$lg(perGlo,3)_")"

	q:(groupLevel="")||(nurseid="")
	
	s nurHeadId=$o(^CT.DHCINM.Set.MgRolesI("code"," Y"," NURHEAD",""))
	s znurHeadId=$o(^CT.DHCINM.Set.MgRolesI("code"," Y"," ZNURHEAD",""))
	s codeList=$lb(nurHeadId,znurHeadId)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s flag=0,nowDate=+$h
	i groupLevel="W" d
	.s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsD(perId)) q:perId=""  d
	..q:'$d(^CF.DHCINM.HR.PersonsD(perId))
	..s perGlo=^CF.DHCINM.HR.PersonsD(perId)
	..s perWard=$lg(perGlo,10)
	..q:perWard=""
	..s perStatus=##class(web.INMPersonComm).GetCommCode($lg(perGlo,42))
	..q:(perStatus'="在职") ;过滤掉离职/退休
	..q:(isAll'=1)&&('$d(tmpWard(perWard)))
	..s perID=$lg(perGlo,3)
	..s:perID'="" perID="("_$lg(perGlo,3)_")"
	..s tmp(perId)="rw|"_perId_"^PerName|"_$lg(perGlo,2)_perID
	e  i (groupLevel="L")||(groupLevel="H") d
	.s ptr=0 f  s status=$listnext(codeList,ptr,roleId) q:status'=1  d
	..s userId="" f  s userId=$o(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userId)) q:userId=""  d
	...s userRoleId="" f  s userRoleId=$o(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userId,userRoleId)) q:userRoleId=""  d
	....q:'$d(^CF.DHCINM.DB.MgUserRoleD(userId,userRoleId))
	....s nurRoleGlo=^CF.DHCINM.DB.MgUserRoleD(userId,userRoleId)
	....s nurRoleStDate=$lg(nurRoleGlo,3)
	....s nurRoleEndDate=$lg(nurRoleGlo,4)
	....q:(nowDate<nurRoleStDate)||((nurRoleEndDate'="")&&(nurRoleEndDate<nowDate))
	....s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(userId)
	....q:'$IsObject(userObj)
	....s perId=userObj.PerDR
	....q:perId=""
	....s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	....q:'$IsObject(perObj)
	....s perStatus=##class(web.INMPersonComm).GetCommCode(perObj.PerStatus)
	....q:(perStatus'="在职") ;过滤掉离职/退休
	....s perWard=perObj.PerDepDR
	....q:perWard=""
	....q:(isAll'=1)&&('$d(tmpWard(perWard)))
	....s PerID=perObj.PerID
	....s:PerID'="" PerID="("_perObj.PerID_")"
	....s tmp(perId)="rw|"_perId_"^PerName|"_perObj.PerName_PerID
}

/// creator:lulin
/// createdate:2018-05-24
/// description:获取所辖可分质控检查组成员的人员信息
/// input:登录ID^登录病区^登录角色
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckPersons","W",18)
Query FindCheckPersons(level As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPersonsExecute(ByRef qHandle As %Binary, level As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (level="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	k tmp
	d ..GetCheckPersons(nurseid,level,.tmp)
	
	s i="" f  s i=$o(tmp(i)) q:i=""  d
	.s ret=tmp(i)
	.d OutCheckPerson
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckPerson
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPersonsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPersonsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPersonsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPersonsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:删除质控检查组
/// Date:2020-06-16
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualGroup
/// Input:id
/// Output：1：成功 0：失败
/// Other:w ##class(web.INMQualControlComm).DeleteCheckGroup(1)
ClassMethod DeleteCheckGroup(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.CHK.MgQualGroup).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description：根据角色查询人员名单
/// Date:2020-06-16
/// Creator:wangpf
/// Table:CT.DHCINM.Set.MgRoles DHCINM.HR.MgNurRole
/// Input: 角色
/// Output:指定角色类型人员
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckerForType","NURHEAD!ZNURHEAD",0,0)
Query FindCheckerForType(code As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckerForTypeExecute(ByRef qHandle As %Binary, code As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s roleList=$lfs(code,"!")
	k roleFilter
	s roleId="" f  s roleId=$o(^CT.DHCINM.Set.MgRolesD(roleId)) q:roleId=""  d
	.q:'$d(^CT.DHCINM.Set.MgRolesD(roleId))
	.s roleGlo=^CT.DHCINM.Set.MgRolesD(roleId)
	.s roleCode=$zcvt($lg(roleGlo,2),"U")
	.q:$lf(roleList,roleCode)=0
	.s roleFilter(roleId)=1
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
#;	k tmp
#;	s now=+$h
#;	s nurRoleId="" f  s nurRoleId=$o(^DHCINM.HR.MgNurRoleD(nurRoleId)) q:nurRoleId=""  d
#;	.q:'$d(^DHCINM.HR.MgNurRoleD(nurRoleId))
#;	.s nurRoleGlo=^DHCINM.HR.MgNurRoleD(nurRoleId)
#;	.s nurRoleRole=$lg(nurRoleGlo,3)
#;	.q:'$d(roleFilter(nurRoleRole))
#;	.s nurRoleStDate=$lg(nurRoleGlo,4)
#;	.s nurRoleEndDate=$lg(nurRoleGlo,5)
#;	.q:(nurRoleStDate>now)||((nurRoleEndDate'="")&&(nurRoleEndDate<now))
#;	.s per=$lg(nurRoleGlo,2)
#;	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
#;	.s perGlo=^CF.DHCINM.HR.PersonsD(per)
#;	.s ward=$lg(perGlo,10)
#;	.q:(isAll'=1)&&('$d(tmpWard(ward)))
#;	.s perName=$lg(perGlo,2)
#;	.s perNo=$lg(perGlo,4)
#;	.s ret="PerName|"_perName_"^PerNo|"_perNo_"^rw|"_per
#;	.d OutCheckerList
	
	k tmp
	s nowDate=+$h
	s roleId="" f  s roleId=$o(roleFilter(roleId)) q:roleId=""  d
	.s userId="" f  s userId=$o(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userId)) q:userId=""  d
	..s userRoleId="" f  s userRoleId=$o(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userId,userRoleId)) q:userRoleId=""  d
	...q:'$d(^CF.DHCINM.DB.MgUserRoleD(userId,userRoleId))
	...s nurRoleGlo=^CF.DHCINM.DB.MgUserRoleD(userId,userRoleId)
	...s nurRoleStDate=$lg(nurRoleGlo,3)
	...s nurRoleEndDate=$lg(nurRoleGlo,4)
	...q:(nowDate<nurRoleStDate)||((nurRoleEndDate'="")&&(nurRoleEndDate<nowDate))
	...s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(userId)
	...q:'$IsObject(userObj)
	...s perId=userObj.PerDR
	...q:perId=""
	...s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	...q:'$IsObject(perObj)
	...s perWard=perObj.PerDepDR
	...q:(isAll'=1)&&('$d(tmpWard(perWard)))
	...s tmp(perId)="PerName|"_perObj.PerName_"^PerNo|"_perObj.PerID_"^rw|"_perId
	
	s perId=""  f  s perId=$o(tmp(perId)) q:perId=""  d
	.s ret=tmp(perId)
	.d OutCheckerList

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckerList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckerForTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckerForTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckerForTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckerForTypeExecute ]
{
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

/// Description:根据人员角色获取检查级别
/// Date:2020-06-16
/// Creator:wangpf
/// Table:CT.DHCINM.Set.MgRoles
/// Input:登录人ID 登录人角色
/// Output：检查级别
/// Other:w ##class(web.INMQualControlComm).GetCheckLevel(1)
ClassMethod GetCheckLevel(nurseid As %String = "") As %String
{
	q:(nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid)))) "[]"
	s role=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	s roleList=$lfs(role,"^")
	
	k tmp
	s ptr=0 f  s status=$listnext(roleList,ptr,roleId) q:status'=1  d
	.q:roleId=""
	.s roleCode=""
	.i roleId=0 s roleCode="ADMIN"
	.e  d
	..q:'$d(^CT.DHCINM.Set.MgRolesD(roleId))
	..s roleGlo=^CT.DHCINM.Set.MgRolesD(roleId)
	..s roleCode=$zcvt($lg(roleGlo,2),"U")
	.q:roleCode=""
	.i (roleCode="ADMIN")||(roleCode="MANAGER") s tmp(1)="W^病区",tmp(2)="L^科室",tmp(3)="H^护理部"
	.e  i roleCode="NURHEAD" s tmp(1)="W^病区"
	.e  i (roleCode="ZNURHEAD") s tmp(1)="W^病区",tmp(2)="L^科室"
	.e  i (roleCode="HLB")||(roleCode="HLBZR") s tmp(1)="W^病区",tmp(2)="L^科室",tmp(3)="H^护理部"
	
	w "["
	s i="" f  s i=$o(tmp(i)) q:i=""  d
	.w "{""Code"":"""_$p(tmp(i),"^")_""",""Desc"":"""_$p(tmp(i),"^",2)_"""}"
	.w:i'=$o(tmp(""),-1) ","
	w "]"
	q ""
}

/// Description：查询检查病区列表
/// Date:2020-06-16
/// Creator:wangpf
/// Table:CF.DHCINM.CHK.CheckWard
/// Input:质控类型 片区ID 病区描述
/// Output:检查病区列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckWardForTypeList","5__2","","",0,0)
Query FindCheckWardsForType(type As %String = "", area As %String = "", input As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckWardsForTypeExecute(ByRef qHandle As %Binary, type As %String = "", area As %String = "", input As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (type="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$tr(type,"_","|")
	k tmpAreaWard
	i area'="" d
	.s locId="" f  s locId=$o(^CF.DHCINM.DB.MgWardLocI("Area",area,locId)) q:locId=""  d
	..s ward="" f  s ward=$o(^CF.DHCINM.DB.MgWardLocUnitI("Loc",locId,ward)) q:ward=""  d
	...s tmpAreaWard(ward)=1
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s sort="" f  s sort=$o(^CF.DHCINM.CHK.CheckWardI("Sort",type,sort)) q:sort=""  d
	.s id="" f  s id=$o(^CF.DHCINM.CHK.CheckWardI("Sort",type,sort,id)) q:id=""  d
	..q:'$d(^CF.DHCINM.CHK.CheckWardD(id))
	..s glo=^CF.DHCINM.CHK.CheckWardD(id)
	..s checkWard=$lg(glo,3)
	..q:'$d(^CF.DHCINM.DB.MgWardD(checkWard))
	..q:(area'="")&&('$d(tmpAreaWard(checkWard)))
	..q:(isAll'=1)&&('$d(tmpWard(checkWard)))
	..s wardGlo=^CF.DHCINM.DB.MgWardD(checkWard)
	..s wardCode=$lg(wardGlo,3)
	..s wardDesc=$lg(wardGlo,4)
	..s wardSpell=$lg(wardGlo,7)
	..q:(input'="")&&(wardCode_wardDesc_wardSpell'[$zcvt(input,"U"))
	..s ret="Ward|"_checkWard_"^WardDesc|"_wardDesc
	..d OutCheckWardList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCheckWardList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckWardsForTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckWardsForTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckWardsForTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckWardsForTypeExecute ]
{
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

/// Description：根据年份、类型查询质控项目
/// Date:2020-06-16
/// Creator:wangpf
/// Table:CT.DHCINM.DB.MgQualItem
/// Input:年份 质控类型
/// Output:质控项目
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQualForType","2021","5__1","1")
Query FindQualForType(year As %String = "", type As %String = "", flag As %String = "", parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQualForTypeExecute(ByRef qHandle As %Binary, year As %String = "", type As %String = "", flag As %String = "", parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s type=$tr(type,"_","|")
	s typeList=$lfs(type,"^")
	s qualClass=$P(parr,"^",1)
	s retTmp=""
	s qualYear="" f  s qualYear=$o(^CT.DHCINM.DB.MgQualItemI("Type",qualYear)) q:qualYear=""  d
	.q:(year'="")&&(year'[qualYear)
	.s qualType="" f  s qualType=$o(^CT.DHCINM.DB.MgQualItemI("Type",qualYear,qualType)) q:qualType=""  d
	..s typeList=$lfs($tr(qualType," ",""),",")
	..q:(type'="")&&($lf(typeList,type)=0)
	..s qualId="" f  s qualId=$o(^CT.DHCINM.DB.MgQualItemI("Type",qualYear,qualType,qualId)) q:qualId=""  d
	...q:($d(retTmp(qualId)))
	...q:$d(^CT.DHCINM.DB.MgQualItemD(qualId))#2'=1
	...s qualGlo=^CT.DHCINM.DB.MgQualItemD(qualId)
	...q:qualGlo=""
	...s tQualClass=$lg(qualGlo,18)
	...q:((qualClass'="")&&(qualClass'=tQualClass))
	...s startDate=$lg(qualGlo,14)
	...s endDate=$lg(qualGlo,15)
	...q:((flag=1)&&(startDate'="")&&(startDate>+$H))
	...q:((flag=1)&&(endDate'="")&&(endDate<+$H))
	...s qualItemDesc=$lg(qualGlo,4)
	...s ret="QualDesc|"_qualItemDesc_"^Qual|"_qualId
	...s retTmp(qualId)=qualId
	...d OutPlanDetailList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanDetailList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualForTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualForTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQualForTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualForTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:获取质控任务状态
/// Date:2020-06-16
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:id
/// Output：1：已发布 2：未发布
/// Other:w ##class(web.INMQualControlComm).IsQualTaskRelease(1)
ClassMethod IsQualTaskRelease(id As %String = "") As %String
{
	q:id="" 0
	q:'$d(^DHCINM.CHK.MgQualCheckTaskD(id)) 0
	s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(id)
	s taskStatus=$lg(taskGlo,11)
	s flag="N"
    s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALSETTING",""))
    i parId'="" d
    .s subId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," QUALTASKUPDATE",parId,""))
    .q:subId=""
    .s glo=^CT.DHCINM.Set.MgSysParamSubD(parId,subId)
    .s flag=$lg(glo,4)
    i ((taskStatus="Y")&&(flag'="Y"))||($d(^DHCINM.CHK.MgCheckResultI("Qual",id))) q 1
	e  q 0
}

/// Description:获取质控任务
/// Date:2020-06-16
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:id
/// Output：质控任务
/// Other:w ##class(web.INMQualControlComm).GetQualTask(1)
ClassMethod GetQualTask(id As %String = "") As %String
{
	q:id="" ""
	q:'$d(^DHCINM.CHK.MgQualCheckTaskD(id)) ""
	s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(id)
	s taskItem=$lg(taskGlo,2)
	s taskItemId="",taskItemDesc=""
	s counter=0,ptr=0 f  s status=$listnext(taskItem,ptr,qual) q:status'=1  d
	.s qualId=$p(qual,"「",2)
	.s qualDesc=$p(qual,"「")
	.i counter=0 s taskItemId=qualId,taskItemDesc=qualDesc
	.e  s taskItemId=taskItemId_","_qualId,taskItemDesc=taskItemDesc_","_qualDesc
	.s counter=counter+1
	s taskType=$lg(taskGlo,3)
	s typePar=$p(taskType,"||")
	s typeSub=$p(taskType,"||",2)
	s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	s taskTypeDesc=$lg(typeGlo,3)
	s taskChecker=$lg(taskGlo,4)
	s taskCheckerId=$lts(taskChecker)
	s taskCheckerName=""
	s counter=0,ptr=0 f  s status=$listnext(taskChecker,ptr,checker) q:status'=1  d
	.s checkerGlo=$g(^CF.DHCINM.HR.PersonsD(checker))
	.s checkerName=$lg(checkerGlo,2)
	.i counter=0 s taskCheckerName=checkerName
	.e  s taskCheckerName=taskCheckerName_","_checkerName
	.s counter=counter+1
	s taskCheckerGroup=$lg(taskGlo,5)
	s taskCheckWard=$lg(taskGlo,6)
	s taskCheckWardId=$lts(taskCheckWard)
	s taskCheckWardDesc=""
	s counter=0,ptr=0 f  s status=$listnext(taskCheckWard,ptr,ward) q:status'=1  d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(ward))
	.s wardDesc=$lg(wardGlo,4)
	.i counter=0 s taskCheckWardDesc=wardDesc
	.e  s taskCheckWardDesc=taskCheckWardDesc_","_wardDesc
	.s counter=counter+1
	s taskWardGroup=$lg(taskGlo,7)
	s taskLevel=$lg(taskGlo,8)
	s taskLevelDesc=$case(taskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	s taskStDate=$lg(taskGlo,9)
	s:taskStDate'="" taskStDate=$zd(taskStDate,3)
	s taskEndDate=$lg(taskGlo,10)
	s:taskEndDate'="" taskEndDate=$zd(taskEndDate,3)
	s taskStatus=$lg(taskGlo,11)
	s taskStatusDesc=$case(taskStatus,"N":"保存","Y":"发布",:"")
	s creator=$lg(taskGlo,12)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s creatorGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(creatorGlo,2)
	s createDate=$lg(taskGlo,13)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(taskGlo,14)
	s:createTime'="" createTime=$zt(createTime)
	s TaskQualClass=$lg(taskGlo,16)
	s ret="TaskItem|"_taskItemId_"^TaskItemDesc|"_taskItemDesc_"^TaskType|"_$tr(taskType,"|","_")_"^TaskTypeDesc|"_taskTypeDesc_"^TaskCheckPerson|"_taskCheckerId
	s ret=ret_"^TaskCheckPersonName|"_taskCheckerName_"^TaskPersonGroup|"_taskCheckerGroup_"^TaskCheckWard|"_taskCheckWardId
	s ret=ret_"^TaskCheckWardDesc|"_taskCheckWardDesc_"^TaskWardGroup|"_taskWardGroup_"^TaskLevel|"_taskLevel_"^TaskLevelDesc|"_taskLevelDesc
	s ret=ret_"^TaskStatus|"_taskStatus_"^TaskStatusDesc|"_taskStatusDesc_"^TaskStDate|"_taskStDate_"^TaskEndDate|"_taskEndDate_"^CreateUser|"_creator
	s ret=ret_"^CreateUserName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	s ret=ret_"^TaskQualClass|"_TaskQualClass
	q ret
}

/// Description：查询质控任务列表
/// Date:2020-06-16
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:质控类型^任务开始日期^任务结束日期 登录人Id 登录角色
/// Output:质控任务列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQualTaskList","5__1,5__3,5__6,5__7,5__8^^",0,0)
Query FindQualTaskList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQualTaskListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (parr="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s type=$p(parr,"^")
	s type=$tr(type,"_","|")
	s typeList=$lfs(type,",")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s wardIn=$p(parr,"^",4)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s typePtr=0 f  s typeStatus=$listnext(typeList,typePtr,taskType) q:typeStatus'=1  d
	.s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Type"," N",taskType,taskId)) q:taskId=""  d
	..q:'$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	..s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(taskId)
	..s taskWard=$lg(taskGlo,6)
	..s flag=0
	..s ptr=0 f  s status=$listnext(taskWard,ptr,ward) q:(status'=1)||(flag=1)  d
	...i ((isAll=1)||$d(tmpWard(ward)))&&((wardIn="")||((wardIn'="")&&(wardIn=ward))) s flag=1
	..q:flag'=1
	..s taskStDate=$lg(taskGlo,9)
	..s taskEndDate=$lg(taskGlo,10)
	..q:((stDate'="")&&(taskEndDate'="")&&(taskEndDate<stDate))||((endDate'="")&&(taskStDate'="")&&(taskStDate>endDate))
	..s ret=..GetQualTask(taskId)
	..d:ret'="" OutputTaskList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTaskList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualTaskListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualTaskListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQualTaskListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualTaskListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:保存质控任务
/// Date:2020-06-17
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:parr 状态
/// Output：0：失败 1：成功
/// Other:w ##class(web.INMQualControlComm).SaveQualTask()
ClassMethod SaveQualTask(parr As %String = "", status As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(status="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	s taskType=$p(parr,"^")
	s taskType=$tr(taskType,"_","|")
	s typePar=$p(taskType,"||")
	s typeSub=$p(taskType,"||",2)
	q:'$d(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	s taskStDate=$p(parr,"^",2)
	s:taskStDate["-" taskStDate=$zdh(taskStDate,3)
	s taskEndDate=$p(parr,"^",3)
	s:taskEndDate["-" taskEndDate=$zdh(taskEndDate,3)
	s taskLevel=$p(parr,"^",4)
	s taskPersonGroup=$p(parr,"^",5)
	q:(taskPersonGroup'="")&&('$d(^DHCINM.CHK.MgQualGroupD(taskPersonGroup))) 0
	s taskPerson=$p(parr,"^",6)
	s taskPersonList=$lfs(taskPerson,",")
	s taskWard=$p(parr,"^",7)
	s taskWardList=$lfs(taskWard,",")
	s taskItem=$p(parr,"^",8)
	s taskItemList=$lfs(taskItem,",")
	s taskId=$p(parr,"^",9)
	q:(taskId'="")&&('$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))) 0
	
	i taskId="" d
	.s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%New()
	.s taskObj.CreateUser=nurseid
	.s taskObj.TaskIsRandom="N"
	e  s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(taskId)
	q:'$IsObject(taskObj) 0
	d taskObj.TaskItem.Clear()
	s ptr=0 f  s stat=$listnext(taskItemList,ptr,qual) q:stat'=1  d
	.q:$d(^CT.DHCINM.DB.MgQualItemD(qual))#2'=1
	.s qualGlo=^CT.DHCINM.DB.MgQualItemD(qual)
	.s qualDesc=$lg(qualGlo,4)
	.d taskObj.TaskItem.Insert(qualDesc_"「"_qual)
	d taskObj.TaskTypeSetObjectId(taskType)
	d taskObj.TaskCheckPerson.Clear()
	s ptr=0 f  s stat=$listnext(taskPersonList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d taskObj.TaskCheckPerson.Insert(per)
	s taskObj.TaskPersonGroup=taskPersonGroup
	d taskObj.TaskCheckWard.Clear()
	s ptr=0 f  s stat=$listnext(taskWardList,ptr,ward) q:stat'=1  d
	.q:'$d(^CF.DHCINM.DB.MgWardD(ward))
	.d taskObj.TaskCheckWard.Insert(ward)
	s taskObj.TaskLevel=taskLevel
	s taskObj.TaskStDate=taskStDate
	s taskObj.TaskEndDate=taskEndDate
	s taskObj.TaskStatus=status
	s sc=taskObj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description:删除质控任务
/// Date:2020-06-17
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:id
/// Output：0：失败 1：成功
/// Other:w ##class(web.INMQualControlComm).DeleteQualTask(1)
ClassMethod DeleteQualTask(id As %String = "") As %String
{
	q:id="" "入参为空,请刷新重试"
	s obj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(id)
	q:'$IsObject(obj) "无删除数据,请刷新重试"
	;q:obj.TaskStatus="Y" "已发布不可删除"
	q:$d(^DHCINM.CHK.MgCheckResultI("Qual",id)) "已检查不可删除"

	s sc=obj.%DeleteId(id)
	if $$$ISOK(sc){
		q 1	
	}else{
		q "删除失败"	
	}
}

/// Description:查询已发布的质控任务
/// Date:2020-06-17
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:状态^质控类型^病区^开始时间^结束时间 登录人Id 登录人角色
/// Output：已发布的质控任务
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindTaskReleaseList","^5__1,5__3,5__6,5__7,5__8^^^",0,0)
Query FindTaskReleaseList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTaskReleaseListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s status=$p(parr,"^")
	s type=$tr($p(parr,"^",2),"_","|")
	s typeList=$lfs(type,",")
	s ward=$p(parr,"^",3)
	s stDate=$p(parr,"^",4)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	s qual=$p(parr,"^",6)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("Status"," N"," Y",taskType)) q:taskType=""  d
	.q:$lf(typeList,taskType)=0
	.s typePar=$p(taskType,"||")
	.s typeSub=$p(taskType,"||",2)
	.s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	.s typeDesc=$lg(typeGlo,3)
	.s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Status"," N"," Y",taskType,taskId)) q:taskId=""  d
	..q:'$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	..s taskGlobal=^DHCINM.CHK.MgQualCheckTaskD(taskId)
	..s taskStDate=$lg(taskGlobal,9)
	..s taskEndDate=$lg(taskGlobal,10)
	..q:((stDate'="")&&(taskEndDate'="")&&(taskEndDate<stDate))||((endDate'="")&&(taskStDate'="")&&(endDate<taskStDate))
	..s:taskStDate'="" taskStDate=$zd(taskStDate,3)
	..s:taskEndDate'="" taskEndDate=$zd(taskEndDate,3)
	..s taskCheckers=$lg(taskGlobal,4)
	..s taskCheckerId=$lts(taskCheckers,",")
	..s taskCheckerName=""
	..s counter=0,checkerPtr=0 f  s taskCheckerStatus=$listnext(taskCheckers,checkerPtr,taskChecker) q:taskCheckerStatus'=1  d
	...s checkerGlo=$g(^CF.DHCINM.HR.PersonsD(taskChecker))
	...s checkerName=$lg(checkerGlo,2)
	...i counter=0 s taskCheckerName=checkerName
	...e  s taskCheckerName=taskCheckerName_","_checkerName
	...s counter=counter+1
	..s taskWards=$lg(taskGlobal,6)
	..s wardPtr=0 f  s taskWardStatus=$listnext(taskWards,wardPtr,taskWard) q:taskWardStatus'=1  d
	...q:(ward'="")&&(taskWard'=ward)
	...s userPerId=""
	...i (nurseid'=0)&&(nurseid'="") d
	....s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	....s userPerId=$lg(userGlo,5)
	...q:(isAll'=1)&&('$d(tmpWard(taskWard)))&&($lf(taskCheckers,userPerId)=0)
	...s wardGlo=$g(^CF.DHCINM.DB.MgWardD(taskWard))
	...s taskWardDesc=$lg(wardGlo,4)
	...s taskItems=$lg(taskGlobal,2)
	...s qualPtr=0 f  s taskItemStatus=$listnext(taskItems,qualPtr,taskItem) q:taskItemStatus'=1  d
	....s taskItemId=$p(taskItem,"「",2)
	....q:(qual'="")&&(taskItemId'=qual)
	....s taskItemDesc=$p(taskItem,"「")
	....s resultId=""
	....s exits=$d(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWard))
	....i exits=0 s checkStatus="T"
	....e  d
	.....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWard,""))
	.....s resultGlo=$g(^DHCINM.CHK.MgCheckResultD(resultId))
	.....s checkStatus=$lg(resultGlo,7)
	....q:(status'="")&&(checkStatus'=status)
	....s checkStatusDesc=$case(checkStatus,"T":"未考核","N":"已保存","S":"已提交","Y":"已驳回",:"")
	....s taskCreator=$lg(taskGlobal,12)
	....s taskCreatorName=""
	....i taskCreator=0 s taskCreatorName="管理员"
	....e  i taskCreator'="" d
	.....s perGlo=$g(^CF.DHCINM.DB.MgUserD(taskCreator))
	.....s taskCreatorName=$lg(perGlo,2)
	....s taskScore="",taskRemark="",taskSubmitter="",taskSubmitterName="",taskSubDate="",taskCheckDate=""
	....i resultId'="" d
	.....s taskScore=$lg(resultGlo,6)
	.....s taskRemark=$lg(resultGlo,9)
	.....s taskSubmitter=$lg(resultGlo,19)
	.....s taskSubmitterName=""
	.....i taskSubmitter=0 s taskSubmitterName="管理员"
	.....e  i taskSubmitter'="" d
	......s perGlo=$g(^CF.DHCINM.DB.MgUserD(taskSubmitter))
	......s taskSubmitterName=$lg(perGlo,2)
	.....s taskSubDate=$lg(resultGlo,22)
	.....s:taskSubDate'="" taskSubDate=$zd(taskSubDate,3)
	.....s taskCheckDate=$lg(resultGlo,24)
	.....s:taskCheckDate'="" taskCheckDate=$zd(taskCheckDate,3)
	....s taskLevel=$lg(taskGlobal,8)
	....s taskLevelDesc=$case(taskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	....s ret="TaskItem|"_taskItemId_"^TaskItemDesc|"_taskItemDesc_"^TaskWard|"_taskWard_"^TaskWardDesc|"_taskWardDesc_"^TaskStDate|"_taskStDate
	....s ret=ret_"^TaskEndDate|"_taskEndDate_"^TaskType|"_$tr(taskType,"|","_")_"^TaskTypeDesc|"_typeDesc_"^TaskChecker|"_taskCheckerId
	....s ret=ret_"^TaskCheckerName|"_taskCheckerName_"^TaskStatus|"_checkStatus_"^TaskStatusDesc|"_checkStatusDesc_"^TaskCreator|"_taskCreator
	....s ret=ret_"^TaskCreatorName|"_taskCreatorName_"^TaskScore|"_taskScore_"^TaskSubmitter|"_taskSubmitter_"^TaskSubmitterName|"_taskSubmitterName
	....s ret=ret_"^TaskCheckDate|"_taskCheckDate_"^TaskSubDate|"_taskSubDate_"^TaskRemark|"_taskRemark_"^ResultId|"_resultId_"^TaskId|"_taskId
	....s ret=ret_"^TaskLevel|"_taskLevel_"^TaskLevelDesc|"_taskLevelDesc
	....d OutQualCheckList
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQualCheckList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTaskReleaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTaskReleaseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTaskReleaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTaskReleaseListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:获取质控检查单详情
/// Date:2020-06-18
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:质控任务Id 质控项目Id 病区Id
/// Output：质控检查单详情
/// Other:w ##class(web.INMQualControlComm).GetQualCheck(11,11,5)
ClassMethod GetQualCheck(task As %String = "", qualpar As %String = "", ward As %String = "") As %String
{
	q:(task="")||(qualpar="")||(ward="") ""
	q:'$d(^DHCINM.CHK.MgQualCheckTaskD(task))
	q:'$d(^CF.DHCINM.DB.MgWardD(ward))
	s now=+$h
	
	s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(task)
	s wardGlo=^CF.DHCINM.DB.MgWardD(ward)
	s wardDesc=$lg(wardGlo,4)
	w "{""WardId"":"""_ward_""",""WardDesc"":"""_wardDesc_""""
	i '$d(^DHCINM.CHK.MgCheckResultI("Ward",task,qualpar,ward)) d
	.k @"tmp"
	.s tmp=""
	.q:$d(^CT.DHCINM.DB.MgQualItemD(qualpar))#2'=1
	.s qualGlo=^CT.DHCINM.DB.MgQualItemD(qualpar)
	.s qualStDate=$lg(qualGlo,14)
	.s qualEndDate=$lg(qualGlo,15)
	.q:((qualStDate'="")&&(qualStDate>now))
	.q:((qualEndDate'="")&&(qualEndDate<now))
	.k tmpQualItemInfo //获取评分模式、插入列数、列头
	.s tmpQualItemInfo=##class(web.INMDBComm).GetQualItem(qualpar)
	.d ##class(web.INMVueComm).SplitStr(tmpQualItemInfo,"^","|",.tmpQualItemInfo)
	.s qualScoreType=$g(tmpQualItemInfo("QualScoreType"))
	.s qualScoreTypeSub=$g(tmpQualItemInfo("QualScoreTypeSub"))
	.s qualStandardMode=$g(tmpQualItemInfo("QualStandardMode"))
	.s qualInsertCount=$g(tmpQualItemInfo("QualInsertCount"))
	.s qualInsert=$g(tmpQualItemInfo("QualInsert"))
	.s qualScoreFlag=$g(tmpQualItemInfo("QualScoreFlag"))
	.i qualInsert="" s qualInsert="[]",qualInsertPat="[]",qualInsertNur="[]",qualInsertInput="[]"
	.e  d
	..s qualInsertList=$lfs(qualInsert)
	..s qualInsert="["_qualInsert_"]"
	..s tmpString=""
	..f tmpI=1:1:qualInsertCount d
	...i tmpString="" s tmpString=""""""
	...e  s tmpString=tmpString_","""""
	..i $lf(qualInsertList,1)>0 s qualInsertPat="["_tmpString_"]"
	..e  s qualInsertPat="[]"
	..i $lf(qualInsertList,2)>0 s qualInsertNur="["_tmpString_"]"
	..e  s qualInsertNur="[]"
	..i $lf(qualInsertList,3)>0 s qualInsertInput="["_tmpString_"]"
	..e  s qualInsertInput="[]"
	.k tmpLeaf,tmpAll //获取叶子节点、所有节点
	.s subId="" f  s subId=$o(^CT.DHCINM.DB.MgQualItemSubI("parr",qualpar,subId)) q:subId=""  d
	..q:'$d(^CT.DHCINM.DB.MgQualItemSubD(qualpar,subId))
	..s qualSubGlo=^CT.DHCINM.DB.MgQualItemSubD(qualpar,subId)
	..s qualSubStDate=$lg(qualSubGlo,7)
	..s qualSubEndDate=$lg(qualSubGlo,8)
	..q:((qualSubStDate'="")&&(qualSubStDate>now))
	..q:((qualSubEndDate'="")&&(qualSubEndDate<now))
	..s qualSubSort=$lg(qualSubGlo,6)
	..q:qualSubSort=""
	..s @("tmpAll("_$tr(qualSubSort,".",",")_")")=qualpar_"||"_subId
	..s:'$d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_qualpar_"||"_subId)) tmpLeaf(qualSubSort)=qualpar_"||"_subId
	.s deepth=1 //最大深度(前端合并行、列使用)
	.s subId="" f  s subId=$o(^CT.DHCINM.DB.MgQualItemSubI("parr",qualpar,subId)) q:subId=""  d
	..s qualSubGlo=^CT.DHCINM.DB.MgQualItemSubD(qualpar,subId)
	..s qualSubStDate=$lg(qualSubGlo,7)
	..s qualSubEndDate=$lg(qualSubGlo,8)
	..q:(qualSubStDate>now)||((qualSubEndDate'="")&&(qualSubEndDate<now))
	..s qualSubSort=$lg(qualSubGlo,6)
	..q:qualSubSort=""
	..s:$l(qualSubSort,".")-1>deepth deepth=$l(qualSubSort,".")-1
	..s flag=1 //过滤停用的节点(父节点停用,子节点自动停用)
	..s qualSubPar=$lg(qualSubGlo,5)
	..i qualSubPar'="" d
	...s qualSubParId1=$p(qualSubPar,"||")
	...s qualSubParId2=$p(qualSubPar,"||",2)
	...i '$d(^CT.DHCINM.DB.MgQualItemSubD(qualSubParId1,qualSubParId2)) s flag=0 q
	...s qualSubParGlo=^CT.DHCINM.DB.MgQualItemSubD(qualSubParId1,qualSubParId2)
	...s qualSubParStDate=$lg(qualSubParGlo,7)
	...s qualSubParEndDate=$lg(qualSubParGlo,8)
	...i (qualSubParStDate>now)||((qualSubParEndDate'="")&&(qualSubParEndDate<now)) s flag=0 q
	...s qualSubParSort=$lg(qualSubParGlo,6)
	...i qualSubParSort="" s flag=0 q
	..q:flag'=1
	..s hasChild=0 //当前节点是否为叶子节点
	..s:$d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_qualpar_"||"_subId)) hasChild=1
	..s score="" //得分模式默认满分 其他为空
	..s:(qualScoreType=2)&&(qualScoreTypeSub=3) score=$lg(qualSubGlo,4)
	..s:(qualScoreType'=2)&&(qualScoreTypeSub=1) score="√"
	..s:(qualScoreType=2)&&(qualScoreTypeSub=5) score=$lg(qualSubGlo,4)
	..i qualScoreTypeSub=4 d
   	...s sysParId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALSETTING",""))
   	...q:sysParId=""
   	...s sysSubId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," DEDUCTZERO",sysParId,""))
   	...q:sysSubId=""
   	...q:'$d(^CT.DHCINM.Set.MgSysParamSubD(sysParId,sysSubId))
   	...s sysGlo=^CT.DHCINM.Set.MgSysParamSubD(sysParId,sysSubId)
   	...s hold=$lg(sysGlo,4)
   	...q:(hold'=0)&&(hold'="")
   	...s score=hold
	..f tmpI=1:1:qualInsertCount d
	...s $P(tmpScore,",",tmpI)=score
	..s score=tmpScore
	..s qualStandardList="" //当前节点打分选项
	..i (qualScoreType'=2)&&(qualScoreTypeSub=1) s qualStandardList="是@√@el-icon-circle-check,否@×@el-icon-circle-close,不适用@-@el-icon-warning-outline"
	..e  i (qualScoreType'=2)&&(qualScoreTypeSub=2) s qualStandardList="符合@@el-icon-circle-check,部分符合@@el-icon-remove-outline,不符合@@el-icon-circle-close,不适用@-@el-icon-warning-outline"
	..e  i (qualScoreType=2)&&(qualScoreTypeSub=5)&&(qualStandardMode=1) s qualStandardList=$lg(qualGlo,10)
	..e  i (qualScoreType=2)&&(((qualScoreTypeSub=5)&&(qualStandardMode=2))||(qualScoreTypeSub=6)) s qualStandardList=$lg(qualSubGlo,9)
	..i hasChild=0 s rowSpan=1 //当前节点合并行数(子节点数目,叶子节点合并数为1)
	..e  d
	...s rowSpan=0,tmpLeafSort="" f  s tmpLeafSort=$o(tmpLeaf(tmpLeafSort)) q:tmpLeafSort=""  d
	....s:($e(tmpLeafSort,1,$l(qualSubSort))=qualSubSort)&&($e(tmpLeafSort,$l(qualSubSort)+1,$l(qualSubSort)+1)=".") rowSpan=rowSpan+1
#;	..s tmpRoot="",rootLen=$l(qualSubSort,".") //一级节点到当前节点的路径
#;	..f rootIndex=3:1:rootLen d
#;	...i tmpRoot="" s tmpRoot=""""_$p(qualSubSort,".",1,rootIndex)_""""
#;	...e  s tmpRoot=tmpRoot_","""_$p(qualSubSort,".",1,rootIndex)_""""
#;	..s roots="["_tmpRoot_"]"
	..s tmpRoot="",rootLen=$l(qualSubSort,"."),faShow=1 //可显示的父节点到当前节点的路径
	..f rootIndex=rootLen:-1:3 q:faShow'=1  d
	...s curSubSort=$p(qualSubSort,".",1,rootIndex)
	...s curSubParSort=$p(qualSubSort,".",1,rootIndex-1)
	...i $o(@("tmpAll("_$tr(curSubParSort,".",",")_")")@(""))=$p(curSubSort,".",$L(curSubSort,".")) s faShow=1
	...e  s faShow=0
	...q:faShow'=1
	...i tmpRoot="" s tmpRoot=""""_curSubSort_""""
	...e  s tmpRoot=""""_curSubSort_""","_tmpRoot
	..s roots="["_tmpRoot_"]"
	..i (qualSubPar'="")&&($o(@("tmpAll("_$tr(qualSubParSort,".",",")_")")@(""))=$p(qualSubSort,".",$L(qualSubSort,"."))) s fatherShow=1 //是否显示父节点(父节点的第一个子节点为1,其他子节点为0)
	..e  s fatherShow=0
	..s ret="{""SubItem"":"""_##class(web.INMVueComm).FilterSpecialSymbols($lg(qualSubGlo,2))_""",""HasChild"":"""_hasChild_""",""QualSubId"":"""_qualpar_"||"_subId_""",""SubSort"":"""_qualSubSort_""",""SubAccordScore"":"""""
	..s ret=ret_",""SubScore"":"""_$lg(qualSubGlo,4)_""",""CheckMenu"":"""_qualStandardList_""",""ResultSubId"":"""",""RowSpan"":"""_rowSpan_""""
	..s ret=ret_",""FatherId"":"""_qualSubPar_""",""Roots"":"_roots_",""FatherShow"":"""_fatherShow_""",""ItemScore"":"""_score_""",""Remark"":"""""
	..s ret=ret_",""Review"":"""",""ReviewDesc"":"""",""ReviewPer"":"""",""ReviewPerName"":"""",""ReviewDate"":"""",""ReviewTime"":"""",""ReviewMenu"":[],""NeedReview"":""N""},"
	..s @("tmp("_$tr(qualSubSort,".",",")_")")=ret
	.w ",""QualId"":"""_qualpar_""",""InsertCount"":"""_qualInsertCount_""",""ScoreType"":"""_qualScoreType_""",""ScoreTypeSub"":"""_qualScoreTypeSub_""",""CheckScoreFlag"":"""_qualScoreFlag
	.w """,""StandardMode"":"""_qualStandardMode_""",""Deepth"":"""_deepth_""",""QualInsert"":"_qualInsert_",""QualInsertPat"":"_qualInsertPat
	.w ",""QualInsertNur"":"_qualInsertNur_",""QualInsertInput"":"_qualInsertInput
	.w ",""QualSubItems"":["
	.s queryString=$q(@"tmp"@("")) //只有一条数据时,去掉多余的逗号
	.s:(queryString'="")&&($q(@"tmp"@(""),-1)=queryString) @queryString=$e(@queryString,1,*-1)
	.i queryString'="" d
	..w @queryString
	..f  s queryString=$q(@queryString) q:queryString=""  d //输出质控项目
	...s:$q(@"tmp"@(""),-1)=queryString @queryString=$e(@queryString,1,*-1)
	...w @queryString
	.w "]"
	e  d
	.k @"tmp"
	.s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",task,qualpar,ward,""))
	.q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	.s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	.s resultScoreType=$lg(resultGlo,13)
	.s resultScoreTypeSub=$lg(resultGlo,14)
	.s resultStandardMode=$lg(resultGlo,15)
	.s CheckScoreFlag=$lg(resultGlo,29)
	.s resultInsertCount=0
	.s resultInsert=$lg(resultGlo,17)
	.k tmpAll,tmpLeaf
	.s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	..q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	..s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	..s resultSubSort=$lg(resultSubGlo,9)
	..q:resultSubSort=""
	..s @("tmpAll("_$tr(resultSubSort,".",",")_")")=resultId_"||"_resultSubId
	..s:'$d(^DHCINM.CHK.MgCheckResultSubI("Par",resultId_"||"_resultSubId)) tmpLeaf(resultSubSort)=resultId_"||"_resultSubId
	.s deepth=1
	.s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	..q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	..s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	..s resultSubSort=$lg(resultSubGlo,9)
	..q:resultSubSort=""
	..s:$l(resultSubSort,".")-1>deepth deepth=$l(resultSubSort,".")-1
	..s resultSubParId=$lg(resultSubGlo,8)
	..s flag=1
	..i resultSubParId'="" d
	...s resultSubParId1=$p(resultSubParId,"||")
	...s resultSubParId2=$p(resultSubParId,"||",2)
	...i '$d(^DHCINM.CHK.MgCheckResultSubD(resultSubParId1,resultSubParId2)) s flag=0 q
	...s resultSubParGlo=^DHCINM.CHK.MgCheckResultSubD(resultSubParId1,resultSubParId2)
	...s resultSubParSort=$lg(resultSubParGlo,9)
	...i resultSubParSort="" s flag=0 q
	..q:flag'=1
	..s hasChild=0 
	..s:$d(^DHCINM.CHK.MgCheckResultSubI("Par",resultId_"||"_resultSubId)) hasChild=1
	..s resultStandardList=""
	..i (resultScoreType'=2)&&(resultScoreTypeSub=1) s resultStandardList="是@√@el-icon-circle-check,否@×@el-icon-circle-close,不适用@-@el-icon-warning-outline"
	..e  i (resultScoreType'=2)&&(resultScoreTypeSub=2) s resultStandardList="符合@@el-icon-circle-check,部分符合@@el-icon-remove-outline,不符合@@el-icon-circle-close,不适用@-@el-icon-warning-outline"
	..e  i (resultScoreType=2)&&(resultScoreTypeSub=5)&&(resultStandardMode=1) s resultStandardList=$lg(resultGlo,16)
	..e  i (resultScoreType=2)&&(((resultScoreTypeSub=5)&&(resultStandardMode=2))||(resultScoreTypeSub=6)) s resultStandardList=$lg(resultSubGlo,10)
	..i hasChild=0 s rowSpan=1
	..e  d
	...s rowSpan=0,tmpLeafSort="" f  s tmpLeafSort=$o(tmpLeaf(tmpLeafSort)) q:tmpLeafSort=""  d
	....s:($e(tmpLeafSort,1,$l(resultSubSort))=resultSubSort)&&($e(tmpLeafSort,$l(resultSubSort)+1,$l(resultSubSort)+1)=".") rowSpan=rowSpan+1
#;	..s tmpRoot="",rootLen=$l(resultSubSort,".")
#;	..f rootIndex=3:1:rootLen d
#;	...i tmpRoot="" s tmpRoot=""""_$p(resultSubSort,".",1,rootIndex)_""""
#;	...e  s tmpRoot=tmpRoot_","""_$p(resultSubSort,".",1,rootIndex)_""""
#;	..s roots="["_tmpRoot_"]"
	..s tmpRoot="",rootLen=$l(resultSubSort,"."),faShow=1
	..f rootIndex=rootLen:-1:3 q:faShow'=1  d
	...s curSubSort=$p(resultSubSort,".",1,rootIndex)
	...s curSubParSort=$p(resultSubSort,".",1,rootIndex-1)
	...i $o(@("tmpAll("_$tr(curSubParSort,".",",")_")")@(""))=$p(curSubSort,".",$L(curSubSort,".")) s faShow=1
	...e  s faShow=0
	...q:faShow'=1
	...i tmpRoot="" s tmpRoot=""""_curSubSort_""""
	...e  s tmpRoot=""""_curSubSort_""","_tmpRoot
	..s roots="["_tmpRoot_"]"
	..i (resultSubParId'="")&&($o(@("tmpAll("_$tr(resultSubParSort,".",",")_")")@(""))=$p(resultSubSort,".",$L(resultSubSort,"."))) s fatherShow=1
	..e  s fatherShow=0
	..s resultSubScore=$lg(resultSubGlo,3)
	..s subStandardScore=$lg(resultSubGlo,5)
	..s reviewFlag="N"
	..s subScoreList=$lfs(resultSubScore,",")
	..s scorePtr=0 f  s scoreStat=$listnext(subScoreList,scorePtr,subScoreI) q:(scoreStat'=1)||(reviewFlag="Y")  d
	...i (resultScoreType=1)&&(resultScoreTypeSub=1)&&(subScoreI="×") s reviewFlag="Y" q
	...e  i (resultScoreType=1)&&(resultScoreTypeSub=2)&&(($fn($p(subScoreI,"@",2),"",0)>0)||($fn($p(subScoreI,"@",3),"",0)>0)) s reviewFlag="Y" q
	...e  i (resultScoreType=2)&&((resultScoreTypeSub=3)||(resultScoreTypeSub=5))&&($fn(subScoreI,"",2)<subStandardScore) s reviewFlag="Y" q
	...e  i (resultScoreType=2)&&(resultScoreTypeSub=4)&&(subScoreI'="")&&($fn($SYSTEM.SQL.ABS(subScoreI),"",2)>0) s reviewFlag="Y" q
	...e  i (resultScoreType=2)&&(resultScoreTypeSub=6)&&(subScoreI'="") s reviewFlag="Y" q
	..s review=$lg(resultSubGlo,11)
	..s reviewDesc=$case(review,"Y":"复查通过","N":"复查未通过",:"")
	..s reviewPer=$lg(resultSubGlo,12)
	..s reviewPerName=""
	..i reviewPer=0 s reviewPerName="管理员"
	..e  i reviewPer'="" d
	...s userGlo=$g(^CF.DHCINM.DB.MgUserD(reviewPer))
	...s reviewPerName=$lg(userGlo,2)
	..s reviewDate=$lg(resultSubGlo,13)
	..s:reviewDate'="" reviewDate=$zd(reviewDate,3)
	..s reviewTime=$lg(resultSubGlo,14)
	..s:reviewTime'="" reviewTime=$zt(reviewTime,1)
	..s ret="{""SubItem"":"""_##class(web.INMVueComm).FilterSpecialSymbols($lg(resultSubGlo,2))_""",""HasChild"":"""_hasChild_""",""QualSubId"":"""_$lg(resultSubGlo,7)_""",""SubSort"":"""_resultSubSort_""",""SubAccordScore"":"""_$lg(resultSubGlo,15)_""""
	..s ret=ret_",""SubScore"":"""_subStandardScore_""",""CheckMenu"":"""_resultStandardList_""",""ResultSubId"":"""_resultId_"||"_resultSubId_""""
	..s ret=ret_",""RowSpan"":"""_rowSpan_""",""FatherId"":"""_resultSubParId_""",""Roots"":"_roots_",""FatherShow"":"""_fatherShow_""""
	..s ret=ret_",""ItemScore"":"""_resultSubScore_""",""Remark"":"""_$lg(resultSubGlo,6)_""",""Review"":"""_review_""",""ReviewDesc"":"""_reviewDesc_""""
	..s ret=ret_",""ReviewPer"":"""_reviewPer_""",""ReviewPerName"":"""_reviewPerName_""",""ReviewDate"":"""_reviewDate_""",""ReviewTime"":"""_reviewTime_""""
	..s ret=ret_",""ReviewMenu"":[{""value"":""Y"",""label"":""通过""},{""value"":""N"",""label"":""未通过""}],""NeedReview"":"""_reviewFlag_"""},"
	..s @("tmp("_$tr(resultSubSort,".",",")_")")=ret
	..s:$l(resultSubScore,",")>resultInsertCount resultInsertCount=$l(resultSubScore,",")
	.i resultInsert="" s resultInsert="[]",resultInsertPat="[]",resultInsertNur="[]",resultInsertInput="[]"
	.e  d
	..s resultInsertList=$lfs(resultInsert)
	..s resultInsert="["_resultInsert_"]"
	..i $lf(resultInsertList,1)>0 d
	...s resultInsertPatList=$lg(resultGlo,26)
	...s tmpString=""
	...s ptr=0 f  s stat=$listnext(resultInsertPatList,ptr,tmpPat) q:stat'=1  d
	....i tmpString="" s tmpString=""""_tmpPat_""""
	....e  s tmpString=tmpString_","""_tmpPat_""""
	...s resultInsertPat="["_tmpString_"]"
	..e  s resultInsertPat="[]"
	..i $lf(resultInsertList,2)>0 d
	...s resultInsertNurList=$lg(resultGlo,27)
	...s tmpString=""
	...s ptr=0 f  s stat=$listnext(resultInsertNurList,ptr,tmpNur) q:stat'=1  d
	....i tmpString="" s tmpString=""""_tmpNur_""""
	....e  s tmpString=tmpString_","""_tmpNur_""""
	...s resultInsertNur="["_tmpString_"]"
	..e  s resultInsertNur="[]"
	..i $lf(resultInsertList,3)>0 d
	...s resultInsertInpList=$lg(resultGlo,28)
	...s tmpString=""
	...s ptr=0 f  s stat=$listnext(resultInsertInpList,ptr,tmpInput) q:stat'=1  d
	....i tmpString="" s tmpString=""""_tmpInput_""""
	....e  s tmpString=tmpString_","""_tmpInput_""""
	...s resultInsertInput="["_tmpString_"]"
	..e  s resultInsertInput="[]"
	.w ",""QualId"":"""_qualpar_""",""InsertCount"":"""_resultInsertCount_""",""ScoreType"":"""_resultScoreType_""",""ScoreTypeSub"":"""_resultScoreTypeSub_""",""CheckScoreFlag"":"""_CheckScoreFlag
	.w """,""StandardMode"":"""_resultStandardMode_""",""Deepth"":"""_deepth_""",""QualInsert"":"_resultInsert_",""QualInsertPat"":"_resultInsertPat
	.w ",""QualInsertNur"":"_resultInsertNur_",""QualInsertInput"":"_resultInsertInput
	.w ",""QualSubItems"":["
	.s queryString=$q(@"tmp"@(""))
	.s:(queryString'="")&&($q(@"tmp"@(""),-1)=queryString) @queryString=$e(@queryString,1,*-1)
	.i queryString'="" d
	..w @queryString
	..f  s queryString=$q(@queryString) q:queryString=""  d
	...s:$q(@"tmp"@(""),-1)=queryString @queryString=$e(@queryString,1,*-1)
	...w @queryString
	.w "]"
	
	w "}"
	q ""
}

/// Description:保存质控检查数据
/// Date:2020-06-18
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input:表头数据 质控检查数据 登录人Id
/// Output：0：失败 其他：成功
/// Other:w ##class(web.INMQualControlComm).SaveQualCheck()
ClassMethod SaveQualCheck(parr As %String = "", insert As %String = "", table As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(table="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s task=$p(parr,"^")
	s qual=$p(parr,"^",2)
	s ward=$p(parr,"^",3)
	s type=$p(parr,"^",4)
	s:type'="" type=$tr(type,"_","|")
	s date=$p(parr,"^",5)
	s:date["-" date=$zdh(date,3)
	s score=$p(parr,"^",6)
	s status=$p(parr,"^",7)
	s remark=$p(parr,"^",8)
	s result=$p(parr,"^",9)
	s CheckAccordScore=$P(parr,"^",10)
	s CheckAccordScoreSum=$P(parr,"^",11)
	s CheckScoreFlag=$P(parr,"^",12)
	s flag=1,now=$h
	i result="" d
	.s obj=##class(DHCINM.CHK.MgCheckResult).%New()
	.i '$d(^CF.DHCINM.DB.MgWardD(ward)) s flag=0 q
	.i '$d(^DHCINM.CHK.MgQualCheckTaskD(task)) s flag=0 q
	.s typePar=$p(type,"||")
	.s typeSub=$p(type,"||",2)
	.i '$d(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub)) s flag=0 q
	.i $d(^CT.DHCINM.DB.MgQualItemD(qual))#2'=1 s flag=0 q
	.s qualGlo=^CT.DHCINM.DB.MgQualItemD(qual)
	.d obj.CheckWardSetObjectId(ward)
	.d obj.CheckTaskSetObjectId(task)
	.d obj.CheckTypeSetObjectId(type)
	.d obj.CheckItemSetObjectId(qual)
	.k tmpQualItemInfo
	.s tmpQualItemInfo=##class(web.INMDBComm).GetQualItem(qual)
	.d ##class(web.INMVueComm).SplitStr(tmpQualItemInfo,"^","|",.tmpQualItemInfo)
	.s qualScoreType=$g(tmpQualItemInfo("QualScoreType"))
	.s qualScoreTypeSub=$g(tmpQualItemInfo("QualScoreTypeSub"))
	.s qualStandardMode=$g(tmpQualItemInfo("QualStandardMode"))
	.s qualInsertCount=$g(tmpQualItemInfo("QualInsertCount"))
	.s obj.CheckScoreType=qualScoreType
	.s obj.CheckScoreTypeSub=qualScoreTypeSub
	.s obj.CheckStandardMode=qualStandardMode
	.s obj.CheckStandardList=$lg(qualGlo,10)
	.s obj.CheckInsert=$lg(qualGlo,11)
	.s obj.CheckInsertCount=$lg(qualGlo,12)
	.s obj.CreateUser=nurseid
	.s obj.CheckPass=$lg(qualGlo,13)
	e  s obj=##class(DHCINM.CHK.MgCheckResult).%OpenId(result)
	q:flag'=1 0
	s obj.CheckScore=score
	s obj.CheckStatus=status
	s obj.CheckUser=nurseid
	s obj.CheckRemark=remark
	s:status="S" obj.SubmitDate=+now,obj.SubmitTime=$p(now,",",2)
	s obj.CheckDate=date
	s obj.CheckAccordScore=CheckAccordScore
	s obj.CheckAccordScoreSum=CheckAccordScoreSum
	s obj.CheckScoreFlag=CheckScoreFlag
	i obj.CheckInsert'="" d
	.s inserList=$lfs(obj.CheckInsert)
	.s insertPat=$p(insert,"ˇ")
	.s insertNur=$p(insert,"ˇ",2)
	.s insertInput=$p(insert,"ˇ",3)
	.s checkInsertCount=$l(insertPat,"^")
	.s:$l(insertNur,"^")>checkInsertCount checkInsertCount=$l(insertNur,"^")
	.s:$l(insertInput,"^")>checkInsertCount checkInsertCount=$l(insertInput,"^")
	.i $lf(inserList,1)>0 d
	..d obj.InsertHeadPat.Clear()
	..f i=1:1:checkInsertCount d
	...s tmpValue=$p(insertPat,"^",i)
	...d obj.InsertHeadPat.Insert(tmpValue)
	.i $lf(inserList,2)>0 d
	..d obj.InsertHeadNur.Clear()
	..f i=1:1:checkInsertCount d
	...s tmpValue=$p(insertNur,"^",i)
	...d obj.InsertHeadNur.Insert(tmpValue)
	.i $lf(inserList,3)>0 d
	..d obj.InsertHeadInput.Clear()
	..f i=1:1:checkInsertCount d
	...s tmpValue=$p(insertInput,"^",i)
	...d obj.InsertHeadInput.Insert(tmpValue)
	ts
	s sc=obj.%Save()
	s:$$$ISERR(sc) flag=0
	i flag=1 d
	.s len=$l(table,"ˇ")
	.f i=1:1:len q:flag'=1  d
	..s tparr=$p(table,"ˇ",i)
	..i tparr="" s flag=0 q
	..s qualSub=$p(tparr,"^")
	..s score=$p(tparr,"^",2)
	..s resultSub=$p(tparr,"^",3)
	..s subRemark=$p(tparr,"^",4)
	..s subAccordScore=$P(tparr,"^",5)
	..i resultSub="" d
	...s resultSubObj=##class(DHCINM.CHK.MgCheckResultSub).%New()
	...s resultSubObj.Parref=obj
	...s qualSubId1=$p(qualSub,"||")
	...s qualSubId2=$p(qualSub,"||",2)
	...i (qualSub="")||('$d(^CT.DHCINM.DB.MgQualItemSubD(qualSubId1,qualSubId2))) s flag=0 q
	...s qualSubGlo=^CT.DHCINM.DB.MgQualItemSubD(qualSubId1,qualSubId2)
	...s resultSubObj.SubItem=$lg(qualSubGlo,2)
	...s resultSubObj.SubStandard=$lg(qualSubGlo,3)
	...s resultSubObj.SubStandardScore=$lg(qualSubGlo,4)
	...d resultSubObj.SubReferenceSetObjectId(qualSub)
	...s resultSubObj.SubSort=$lg(qualSubGlo,6)
	...i $l(resultSubObj.SubSort,".")>2 d
	....s sortLen=$L(resultSubObj.SubSort,".")
	....s parSort=$e(resultSubObj.SubSort,1,*-$l($p(resultSubObj.SubSort,".",sortLen))-1)
	....s parId=$o(^DHCINM.CHK.MgCheckResultSubI("Sort",obj.%Id()," "_parSort,""))
	....i '$d(^DHCINM.CHK.MgCheckResultSubD(obj.%Id(),parId)) s flag=0 q
	....d resultSubObj.SubParentSetObjectId(obj.%Id()_"||"_parId)
	...s resultSubObj.SubStandardList=$lg(qualSubGlo,9)
	..e  s resultSubObj=##class(DHCINM.CHK.MgCheckResultSub).%OpenId(resultSub)
	..q:(flag'=1)||('$IsObject(resultSubObj))
	..s resultSubObj.SubScore=score
	..s resultSubObj.SubRemark=subRemark
	..s resultSubObj.SubAccordScore=subAccordScore
	..s sc=resultSubObj.%Save()
	..s:$$$ISERR(sc) flag=0
	i flag=1 tc  q obj.%Id()
	e  tro  q 0
}

/// Description:判断质控子项是否扣分
/// Date:2020-08-14
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input:评分类型 评分子类型 项目得分 项目标准分
/// Output:质控问题汇总
/// Other:w ##class(web.INMQualControlComm).IsQualSubDeduct("2","3","4,1,4,3","4")
ClassMethod IsQualSubDeduct(scoreType As %String = "", scoreTypeSub As %String = "", resultSubScore As %String = "", subStandardScore As %String = "") As %String
{
	s deductFlag=0
	s subScoreList=$lfs(resultSubScore,",")
	s scorePtr=0 f  s scoreStat=$listnext(subScoreList,scorePtr,subScoreI) q:(scoreStat'=1)||(deductFlag=1)  d
	.i (scoreType=1)&&(scoreTypeSub=1)&&(subScoreI="×") s deductFlag=1 q
	.e  i (scoreType=1)&&(scoreTypeSub=2)&&(($fn($p(subScoreI,"@",2),"",0)>0)||($fn($p(subScoreI,"@",3),"",0)>0)) s deductFlag=1 q
	.e  i (scoreType=2)&&((scoreTypeSub=3)||(scoreTypeSub=5))&&($fn(subScoreI,"",2)<subStandardScore) s deductFlag=1 q
	.e  i (scoreType=2)&&(scoreTypeSub=4)&&(subScoreI'="")&&($fn($SYSTEM.SQL.ABS(subScoreI),"",2)>0) s deductFlag=1 q
	.e  i (scoreType=2)&&(scoreTypeSub=6)&&(subScoreI'="") s deductFlag=1 q
	q deductFlag
}

/// Description：质控问题汇总
/// Date:2020-06-19
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input: 开始日期^结束日期^状态^质控类型^质控项目^病区^重点关注 登录人Id 登录人角色
/// Output:质控问题汇总
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckQuesList","^2020-06-30^^^^^",0,0)
Query FindCheckQuesList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckQuesListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s stDate=$p(parr,"^")
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",2)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",3)
	s statusList=$lfs(status,",")
	s qual=$p(parr,"^",4)
	s ward=$p(parr,"^",5)
	s type=$tr($p(parr,"^",6),"_","|")
	s focus=$p(parr,"^",7)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s quesId=$o(^DHCINM.CHK.MgCheckQuesI("Result",resultId,""))
	....i (quesId="")||('$d(^DHCINM.CHK.MgCheckQuesD(quesId))) s quesStatus="N"
	....e  d
	.....s quesGlo=^DHCINM.CHK.MgCheckQuesD(quesId)
	.....s quesStatus=$lg(quesGlo,12)
	....q:(status'="")&&($lf(statusList,quesStatus)=0)
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s resultTypeDesc=""
	....i resultType'="" d
	.....s typePar=$p(resultType,"||")
	.....s typeSub=$p(resultType,"||",2)
	.....s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	.....s resultTypeDesc=$lg(typeGlo,3)
	....s resultFocus=$lg(resultGlo,10)
	....s:resultFocus="" resultFocus=0
	....q:(focus'="")&&(focus'=resultFocus)
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s quesDesc="",mistakeFlag=0,counter=0
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:((resultSubScore="")||((resultSubScore=0)&&($lg(checkItemGlo,8)=4)))
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s mistakeFlag=1
	.....s resultSubItem=$lg(resultSubGlo,2)
	.....s resultSubRemark=$lg(resultSubGlo,6)
	.....i counter=0 d
	......s quesDesc=resultSubItem
	......s:resultSubRemark'="" quesDesc=quesDesc_"【"_resultSubRemark_"】"
	.....e  d
	......s quesDesc=quesDesc_";"_resultSubItem
	......s:resultSubRemark'="" quesDesc=quesDesc_"【"_resultSubRemark_"】"
	.....s counter=counter+1
	....q:mistakeFlag'=1
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskSourceDesc=""
	....i taskGlo'="" d
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....s quesStatusDesc=$case(quesStatus,"N":"待处理","S":"已处理","A":"已解决","Q":"问题上诉","B":"驳回","I":"忽略",:"")
	....s quesAnalyze="",quesNurRea="",quesPatRea="",quesDeviceRea="",quesWorkRea=""
	....s quesGoodsRea="",quesOtherRea="",quesStep="",quesGoal="",quesHLBView=""
	....i quesStatus'="N" d
	.....s quesGlo=^DHCINM.CHK.MgCheckQuesD(quesId)
	.....s quesAnalyze=$lg(quesGlo,16)
	.....s quesNurRea=$lg(quesGlo,17)
	.....s quesPatRea=$lg(quesGlo,18)
	.....s quesDeviceRea=$lg(quesGlo,19)
	.....s quesWorkRea=$lg(quesGlo,20)
	.....s quesGoodsRea=$lg(quesGlo,21)
	.....s quesOtherRea=$lg(quesGlo,22)
	.....s quesStep=$lg(quesGlo,23)
	.....s quesGoal=$lg(quesGlo,24)
	.....s quesHLBView=$lg(quesGlo,25)
	....s ret="QuesDate|"_$zd(checkDate,3)_"^QuesWard|"_checkWard_"^QuesWardDesc|"_checkWardDesc_"^QuesItem|"_checkItem_"^QuesItemDesc|"_checkItemDesc_"^QuesType|"_$tr(resultType,"|","_")
	....s ret=ret_"^QuesTypeDesc|"_resultTypeDesc_"^QuesDesc|"_quesDesc_"^QuesFocus|"_resultFocus_"^QuesStatus|"_quesStatus_"^QuesStatusDesc|"_quesStatusDesc_"^ResultId|"_resultId
	....s ret=ret_"^QuesAnalyze|"_quesAnalyze_"^QuesNurRea|"_quesNurRea_"^QuesPatRea|"_quesPatRea_"^QuesDeviceRea|"_quesDeviceRea_"^QuesWorkRea|"_quesWorkRea
	....s ret=ret_"^QuesGoodsRea|"_quesGoodsRea_"^QuesOtherRea|"_quesOtherRea_"^QuesStep|"_quesStep_"^QuesGoal|"_quesGoal_"^QuesHLBView|"_quesHLBView
	....s ret=ret_"^TaskId|"_taskId_"^TaskSourceDesc|"_taskSourceDesc_"^quesId|"_quesId
	....d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckQuesListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckQuesListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckQuesListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckQuesListExecute ]
{
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

/// Description:更新重点关注状态
/// Date:2020-06-19
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input:状态 质控检查Id
/// Output：0：失败 1：成功
/// Other:w ##class(web.INMQualControlComm).SaveQualCheck(1,1)
ClassMethod UpdateResultFocus(focus As %String = "", resultid As %String = "") As %String
{
	q:(focus="")||(resultid="") 0
	
	s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultid)
	q:'$IsObject(resultObj)
	i focus=1 s resultObj.IfFocus=1
	e  s resultObj.IfFocus=0
	s sc=resultObj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description:获取质控问题反馈详情
/// Date:2020-06-19
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckQues
/// Input:质控问题Id 登录人Id
/// Output：质控问题反馈详情
/// Other:w ##class(web.INMQualControlComm).GetQuesBack(1,0)
ClassMethod GetQuesBack(resultid As %String = "", nurseid As %String = "") As %String
{
	q:(resultid="")||(nurseid="") ""
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) ""
	
	s resultGlo=$g(^DHCINM.CHK.MgCheckResultD(resultid))
	s picture=$lg(resultGlo,32)
	s:picture'="" picture=$lts(picture,",")
	s quesId=$o(^DHCINM.CHK.MgCheckQuesI("Result",resultid,""))
	s quesRelatedPer="",quesStatus="",quesProcessPerName="",quesProcessDate="",quesAnalyze="",quesNurRea=""
	s quesPatRea="",quesDeviceRea="",quesWorkRea="",quesGoodsRea="",quesOtherRea="",quesStep="",quesGoal=""
	s quesHLBView="",quesHLBPerName="",quesHLBDate=""
	i (quesId'="")&&($d(^DHCINM.CHK.MgCheckQuesD(quesId))) d
	.s quesGlo=^DHCINM.CHK.MgCheckQuesD(quesId)
	.s quesRelatedPer=$lg(quesGlo,10)
	.s quesRelatedPer=$lts(quesRelatedPer)
	.s quesStatus=$lg(quesGlo,12)
	.s quesProcessPer=$lg(quesGlo,14)
	.s quesProcessPerName=""
	.i quesProcessPer=0 s quesProcessPerName="管理员"
	.e  i quesProcessPer'="" d
	..s perGlo=$g(^CF.DHCINM.DB.MgUserD(quesProcessPer))
	..s quesProcessPerName=$lg(perGlo,2)
	.s quesProcessDate=$lg(quesGlo,15)
	.s:quesProcessDate'="" quesProcessDate=$zd(quesProcessDate,3)
	.s quesAnalyze=$lg(quesGlo,16)
	.s quesNurRea=$lg(quesGlo,17)
	.s quesPatRea=$lg(quesGlo,18)
	.s quesDeviceRea=$lg(quesGlo,19)
	.s quesWorkRea=$lg(quesGlo,20)
	.s quesGoodsRea=$lg(quesGlo,21)
	.s quesOtherRea=$lg(quesGlo,22)
	.s quesStep=$lg(quesGlo,23)
	.s quesGoal=$lg(quesGlo,24)
	.s quesHLBView=$lg(quesGlo,25)
	.s quesHLBPer=$lg(quesGlo,26)
	.s quesHLBPerName=""
	.i quesHLBPer=0 s quesHLBPerName="管理员"
	.e  i quesHLBPer'="" d
	..s perGlo=$g(^CF.DHCINM.DB.MgUserD(quesHLBPer))
	..s quesHLBPerName=$lg(perGlo,2)
	.s quesHLBDate=$lg(quesGlo,27)
	.s:quesHLBDate'="" quesHLBDate=$zd(quesHLBDate,3)
	
	s isNurHead=0,isHLB=0
	i nurseid=0 s isNurHead=1,isHLB=1
	e  d
	.s roleId=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	.s roleIdList=$lfs(roleId,"^")
	.s ptr=0 f  s stat=$listnext(roleIdList,ptr,role) q:stat'=1  d
	..q:role=""
	..s roleGlo=$g(^CT.DHCINM.Set.MgRolesD(role))
	..s roleCode=$zcvt($lg(roleGlo,2),"U")
	..i (roleCode="NURHEAD")||(roleCode="ZNURHEAD") s isNurHead=1
	..e  i roleCode="HLB" s isHLB=1
	..e  i (roleCode="MANAGER")||(roleCode="ADMIN") s isNurHead=1,isHLB=1
	
	w "{""QuesRelatedPer"":["_quesRelatedPer_"],""QuesStatus"":"""_quesStatus_""",""QuesProcessPerName"":"""_quesProcessPerName_""""
	w ",""QuesProcessDate"":"""_quesProcessDate_""",""QuesAnalyze"":"""_quesAnalyze_""",""QuesNurRea"":"""_quesNurRea_""""
	w ",""QuesPatRea"":"""_quesPatRea_""",""QuesDeviceRea"":"""_quesDeviceRea_""",""QuesWorkRea"":"""_quesWorkRea_""""
	w ",""QuesGoodsRea"":"""_quesGoodsRea_""",""QuesOtherRea"":"""_quesOtherRea_""",""QuesStep"":"""_quesStep_""""
	w ",""QuesGoal"":"""_quesGoal_""",""QuesHLBView"":"""_quesHLBView_""",""QuesHLBPerName"":"""_quesHLBPerName_""""
	w ",""QuesHLBDate"":"""_quesHLBDate_""",""rw"":"""_quesId_""",""IsNurHead"":"""_isNurHead_""",""IsHLB"":"""_isHLB_""",""Picture"":"""_picture_"""}"
	q ""
}

/// Description:保存质控问题反馈详情
/// Date:2020-06-20
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckQues
/// Input:paarr 登录人Id
/// Output：0：失败 1：成功
/// Other:w ##class(web.INMQualControlComm).SaveQuesBack()
ClassMethod SaveQuesBack(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s quesDesc=$p(parr,"^")
	s quesAnalyze=$p(parr,"^",2)
	s quesRelatedPer=$p(parr,"^",3)
	s quesProcessStatus=$p(parr,"^",4)
	s quesNurRea=$p(parr,"^",5)
	s quesPatRea=$p(parr,"^",6)
	s quesDeviceRea=$p(parr,"^",7)
	s quesWorkRea=$p(parr,"^",8)
	s quesGoodsRea=$p(parr,"^",9)
	s quesOtherRea=$p(parr,"^",10)
	s quesStep=$p(parr,"^",11)
	s quesGoal=$p(parr,"^",12)
	s quesHLBView=$p(parr,"^",13)
	s resultId=$p(parr,"^",14)
	s rw=$p(parr,"^",15)
	
	s flag=1
	i rw="" d
	.s resultObj=##class(DHCINM.CHK.MgCheckResult).%OpenId(resultId)
	.i '$IsObject(resultObj) s flag=0 q
	.s obj=##class(DHCINM.CHK.MgCheckQues).%New()
	.s obj.QuesTask=resultObj.CheckTask
	.s obj.QuesType=resultObj.CheckType
	.s obj.QuesQual=resultObj.CheckItem
	.s obj.QuesWard=resultObj.CheckWard
	.s obj.QuesResult=resultObj
	.s obj.QuesDate=resultObj.CheckDate
	.s obj.QuesDesc=quesDesc
	.s obj.QuesLevel=resultObj.CheckTask.TaskLevel
	e  s obj=##class(DHCINM.CHK.MgCheckQues).%OpenId(rw)
	q:(flag'=1)||('$IsObject(obj)) 0
	i (quesProcessStatus="S")||(quesProcessStatus="Q") d
	.s obj.QuesAnalyze=quesAnalyze
	.s quesRelatedPerList=$lfs(quesRelatedPer,",")
	.d obj.QuesRelatedPer.Clear()
	.s ptr=0 f  s status=$listnext(quesRelatedPerList,ptr,per) q:status'=1  d
	..q:'$d(^CF.DHCINM.HR.PersonsD(per))
	..d obj.QuesRelatedPer.Insert(per)
	.s obj.QuesNurRea=quesNurRea
	.s obj.QuesPatRea=quesPatRea
	.s obj.QuesDeviceRea=quesDeviceRea
	.s obj.QuesWorkRea=quesWorkRea
	.s obj.QuesGoodsRea=quesGoodsRea
	.s obj.QuesOtherRea=quesOtherRea
	.s obj.QuesStep=quesStep
	.s obj.QuesGoal=quesGoal
	.s obj.QuesProcessPer=nurseid
	.s obj.QuesProcessDate=+$h
	e  i (quesProcessStatus="A")||(quesProcessStatus="B")||(quesProcessStatus="I") d
	.s obj.QuesHLBView=quesHLBView
	.s obj.QuesHLBPer=nurseid
	.s obj.QuesHLBDate=+$h
	s obj.QuesStatus=quesProcessStatus
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description:保存随机检查任务
/// Date:2020-07-14
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:parr userid
/// Output：0：失败 1：成功
/// Other:w ##class(web.INMQualControlComm).SaveRandomTask()
ClassMethod SaveRandomTask(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s type=$p(parr,"^")
	s type=$tr(type,"_","|")
	s typePar=$p(type,"||")
	s typeSub=$p(type,"||",2)
	q:'$d(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub)) 0
	s level=$p(parr,"^",2)
	s item=$p(parr,"^",3)
	s itemList=$lfs(item,",")
	s checker=$p(parr,"^",4)
	s checkerList=$lfs(checker,",")
	s ward=$p(parr,"^",5)
	s wardList=$lfs(ward,",")
	s status=$p(parr,"^",6)
	s rw=$p(parr,"^",7)
	s TaskQualClass=$P(parr,"^",8)
	
	i rw="" d
	.s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%New()
	.s taskObj.CreateUser=nurseid
	.s taskObj.TaskIsRandom="Y"
	e  s taskObj=##class(DHCINM.CHK.MgQualCheckTask).%OpenId(rw)
	q:'$IsObject(taskObj) 0
	d taskObj.TaskItem.Clear()
	s ptr=0 f  s stat=$listnext(itemList,ptr,qual) q:stat'=1  d
	.q:$d(^CT.DHCINM.DB.MgQualItemD(qual))#2'=1
	.s qualGlo=^CT.DHCINM.DB.MgQualItemD(qual)
	.s qualDesc=$lg(qualGlo,4)
	.d taskObj.TaskItem.Insert(qualDesc_"「"_qual)
	d taskObj.TaskTypeSetObjectId(type)
	d taskObj.TaskCheckPerson.Clear()
	s ptr=0 f  s stat=$listnext(checkerList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d taskObj.TaskCheckPerson.Insert(per)
	d taskObj.TaskCheckWard.Clear()
	s ptr=0 f  s stat=$listnext(wardList,ptr,ward) q:stat'=1  d
	.q:'$d(^CF.DHCINM.DB.MgWardD(ward))
	.d taskObj.TaskCheckWard.Insert(ward)
	s taskObj.TaskLevel=level
	s taskObj.TaskStatus=status
	s taskObj.TaskQualClass=TaskQualClass
	s sc=taskObj.%Save()
	i $$$ISOK(sc) q taskObj.%Id()
	e  q 0
}

/// Description：获取随机检查任务列表
/// Date:2020-07-14
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input: 病区^开始日期^结束日期^状态 登录人Id
/// Output:随机检查任务列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindLocGoodRecList","^^^",0,0)
Query FindRandomList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRandomListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s status=$p(parr,"^")
	s type=$p(parr,"^",2)
	s type=$tr(type,"_","|")
	s ward=$p(parr,"^",3)
	s stDate=$p(parr,"^",4)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Random"," Y",taskId)) q:taskId=""  d
	.q:'$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	.s taskGlobal=^DHCINM.CHK.MgQualCheckTaskD(taskId)
	.s taskType=$lg(taskGlobal,3)
	.q:(type'="")&&(type'=taskType)
	.s typePar=$p(taskType,"||")
	.s typeSub=$p(taskType,"||",2)
	.s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	.s typeDesc=$lg(typeGlo,3)
	.s taskCheckers=$lg(taskGlobal,4)
	.s taskCheckerId=$lts(taskCheckers,",")
	.s taskCheckerName=""
	.s counter=0,checkerPtr=0 f  s taskCheckerStatus=$listnext(taskCheckers,checkerPtr,taskChecker) q:taskCheckerStatus'=1  d
	..s checkerGlo=$g(^CF.DHCINM.HR.PersonsD(taskChecker))
	..s checkerName=$lg(checkerGlo,2)
	..i counter=0 s taskCheckerName=checkerName
	..e  s taskCheckerName=taskCheckerName_","_checkerName
	..s counter=counter+1
	.s taskLevel=$lg(taskGlobal,8)
	.s taskLevelDesc=$case(taskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	.s taskStatus=$lg(taskGlobal,11)
	.s taskWards=$lg(taskGlobal,6)
	.s wardPtr=0 f  s taskWardStatus=$listnext(taskWards,wardPtr,taskWard) q:taskWardStatus'=1  d
	..q:(ward'="")&&(taskWard'=ward)
	..s userPerId=""
	..i (nurseid'=0)&&(nurseid'="") d
	...s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	...s userPerId=$lg(userGlo,5)
	..q:(isAll'=1)&&('$d(tmpWard(taskWard)))&&($lf(taskCheckers,userPerId)=0)
	..s wardGlo=$g(^CF.DHCINM.DB.MgWardD(taskWard))
	..s taskWardDesc=$lg(wardGlo,4)
	..s taskItems=$lg(taskGlobal,2)
	..s qualPtr=0 f  s taskItemStatus=$listnext(taskItems,qualPtr,taskItem) q:taskItemStatus'=1  d
	...s taskItemId=$p(taskItem,"「",2)
	...s taskItemDesc=$p(taskItem,"「")
	...s resultId="",checkDate=""
	...s exits=$d(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWard))
	...q:(exits=0)&&((stDate'="")||(endDate'=""))
	...i exits=0 s resultStatus=""
	...e  d
	....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWard,""))
	....s resultGlo=$g(^DHCINM.CHK.MgCheckResultD(resultId))
	....s resultStatus=$lg(resultGlo,7)
	....s checkDate=$lg(resultGlo,24)
	...i exits=0 s tmpStatus="T"_taskStatus
	...e  s tmpStatus="R"_resultStatus
	...q:(status'="")&&(status'=tmpStatus)
	...q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(checkDate>endDate))
	...s tmpStatusDesc=$case(tmpStatus,"TN":"保存","TY":"发布","RN":"检查","RS":"提交",:"")
	...s:checkDate'="" checkDate=$zd(checkDate,3)
	...s taskCreator=$lg(taskGlobal,12)
	...s taskCreatorName=""
	...i taskCreator=0 s taskCreatorName="管理员"
	...e  i taskCreator'="" d
	....s perGlo=$g(^CF.DHCINM.DB.MgUserD(taskCreator))
	....s taskCreatorName=$lg(perGlo,2)
	...s taskScore="",taskRemark="",taskSubmitter="",taskSubmitterName="",taskSubDate="",taskCheckDate=""
	...i resultId'="" d
	....s taskScore=$lg(resultGlo,6)
	....s taskRemark=$lg(resultGlo,9)
	....s taskSubmitter=$lg(resultGlo,19)
	....s taskSubmitterName=""
	....i taskSubmitter=0 s taskSubmitterName="管理员"
	....e  i taskSubmitter'="" d
	.....s perGlo=$g(^CF.DHCINM.DB.MgUserD(taskSubmitter))
	.....s taskSubmitterName=$lg(perGlo,2)
	....s taskSubDate=$lg(resultGlo,22)
	....s:taskSubDate'="" taskSubDate=$zd(taskSubDate,3)
	....s taskCheckDate=$lg(resultGlo,24)
	....s:taskCheckDate'="" taskCheckDate=$zd(taskCheckDate,3)
	...s ret="TaskItem|"_taskItemId_"^TaskItemDesc|"_taskItemDesc_"^TaskWard|"_taskWard_"^TaskWardDesc|"_taskWardDesc_"^TaskCheckDate|"_checkDate
	...s ret=ret_"^TaskLevel|"_taskLevel_"^TaskLevelDesc|"_taskLevelDesc_"^TaskType|"_$tr(taskType,"|","_")_"^TaskTypeDesc|"_typeDesc
	...s ret=ret_"^TaskChecker|"_taskCheckerId_"^TaskCheckerName|"_taskCheckerName_"^TaskStatus|"_tmpStatus_"^TaskStatusDesc|"_tmpStatusDesc
	...s ret=ret_"^TaskCreator|"_taskCreator_"^TaskCreatorName|"_taskCreatorName_"^TaskScore|"_taskScore_"^TaskSubmitter|"_taskSubmitter
	...s ret=ret_"^TaskSubmitterName|"_taskSubmitterName_"^TaskCheckDate|"_taskCheckDate_"^TaskSubDate|"_taskSubDate_"^TaskRemark|"_taskRemark
	...s ret=ret_"^ResultId|"_resultId_"^TaskId|"_taskId
	...d OutRandomList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRandomList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRandomListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRandomListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRandomListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRandomListExecute ]
{
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

/// Description：查询随机检查质控问题
/// Date:2020-07-15
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input: 病区^级别^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:随机检查质控问题
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindRandomQuesList","^^^^^",0)
Query FindRandomQuesList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRandomQuesListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ward=$p(parr,"^")
	s level=$p(parr,"^",2)
	s type=$p(parr,"^",3)
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmp
	;s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("Random"," Y",taskId)) q:taskId=""  d
	s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskD(taskId)) q:taskId=""  d
	.q:'$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	.s taskGlobal=^DHCINM.CHK.MgQualCheckTaskD(taskId)
	.s taskStatus=$lg(taskGlobal,11)
	.q:taskStatus'="Y"
	.s taskType=$lg(taskGlobal,3)
	.q:(type'="")&&(type'=$tr(taskType,"||","__"))
	.s typePar=$p(taskType,"||")
	.s typeSub=$p(taskType,"||",2)
	.s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	.s typeDesc=$lg(typeGlo,3)
	.s taskLevel=$lg(taskGlobal,8)
	.q:(level'="")&&(level'=taskLevel)
	.s taskLevelDesc=$case(taskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	.s taskWards=$lg(taskGlobal,6)
	.s wardPtr=0 f  s taskWardStat=$listnext(taskWards,wardPtr,taskWard) q:taskWardStat'=1  d
	..q:(ward'="")&&(ward'=taskWard)
	..s wardGlo=$g(^CF.DHCINM.DB.MgWardD(taskWard))
	..s taskWardDesc=$lg(wardGlo,4)
	..s taskItems=$lg(taskGlobal,2)
	..s qualPtr=0 f  s taskItemStat=$listnext(taskItems,qualPtr,taskItem) q:taskItemStat'=1  d
	...s taskItemId=$p(taskItem,"「",2)
	...s taskItemDesc=$p(taskItem,"「")
	...q:(qual'="")&&(qual'=taskItemId)
	...s exits=$d(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWard))
	...q:(exits=0)&&((stDate'="")||(endDate'=""))
	...s resultId="",checkDate=""
	...i exits'=0 d
	....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWard,""))
	....s resultGlo=$g(^DHCINM.CHK.MgCheckResultD(resultId))
	....s checkDate=$lg(resultGlo,24)
	...q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(checkDate>endDate))
	...s:'$d(tmp(taskItemId)) tmp(taskItemId)="QualItem|"_taskItemId_"^QualItemDesc|"_taskItemDesc
	...s tmp(taskItemId,"count")=$g(tmp(taskItemId,"count"))+1
	...i $d(tmp(taskItemId,"task")) s tmp(taskItemId,"task")=tmp(taskItemId,"task")_","_taskId
	...e  s tmp(taskItemId,"task")=taskId
	...i resultId'="" d
	....q:'$d(^DHCINM.CHK.MgCheckResultD(resultId))
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s quesDesc=""
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:resultSubScore=""
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s resultSubItem=$lg(resultSubGlo,2)
	.....s resultSubRemark=$lg(resultSubGlo,6)
	.....s resultSubQualSub=$lg(resultSubGlo,7)
	.....s resultSubQualSubId=$p(resultSubQualSub,"||",2)
	.....s:$d(tmp(taskItemId,resultSubQualSubId))#2'=1 tmp(taskItemId,resultSubQualSubId)=resultSubItem
	.....s tmp(taskItemId,resultSubQualSubId,"miscount")=$g(tmp(taskItemId,resultSubQualSubId,"miscount"))+1
	....s resultScore=$lg(resultGlo,6)
	....s resultPass=$lg(resultGlo,25)
	....q:(+resultScore)>=(+resultPass)
	....s tmp(taskItemId,"miscount")=$g(tmp(taskItemId,"miscount"))+1
	
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s ret=tmp(id)_"^CheckCount|"_$fn($g(tmp(id,"count")),"")_"^MisCount|"_$fn($g(tmp(id,"miscount")),"")
	.s mis="",misCount=""
	.s index=0,subId="" f  s subId=$o(tmp(id,subId)) q:subId=""  d
	..q:$fn(subId,"")=0
	..i index=0 s mis=tmp(id,subId),misCount=tmp(id,subId,"miscount")
	..e  s mis=mis_"「"_tmp(id,subId),misCount=misCount_"「"_tmp(id,subId,"miscount")
	..s index=index+1
	.s ret=ret_"^QuesDesc|"_mis_"^QuesCount|"_misCount_"^CheckTask|"_$g(tmp(id,"task"))
	.d OutRandomList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRandomList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRandomQuesListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRandomQuesListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRandomQuesListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRandomQuesListExecute ]
{
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

/// Description：根据任务ID查询质控问题
/// Date:2020-07-16
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input: taskId
/// Output:任务质控问题
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQuesByIdList","1,2,3")
Query FindQuesByIdList(id As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQuesByIdListExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s idList=$lfs(id,",")
	
	s ptr=0 f  s status=$listnext(idList,ptr,taskId) q:status'=1  d
	.q:taskId=""
	.q:'$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	.s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(taskId)
	.s taskLevel=$lg(taskGlo,8)
	.s taskLevelDesc=$case(taskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	.s taskStatus=$lg(taskGlo,11)
	.q:taskStatus'="Y"
	.s taskItems=$lg(taskGlo,2)
	.s taskPtr=0 f  s taskStat=$listnext(taskItems,taskPtr,taskItem) q:taskStat'=1  d
	..s taskItemId=$p(taskItem,"「",2)
	..s taskItemDesc=$p(taskItem,"「")
	..i '$d(^DHCINM.CHK.MgCheckResultI("Ward",taskId)) d
	...s ret="QualItem|"_taskItemId_"^QualItemDesc|"_taskItemDesc_"^TaskLevel|"_taskLevel_"^TaskLevelDesc|"_taskLevelDesc
	...s ret=ret_"^ResultCheckDate|未检查^ResultScore|^QuesDesc|^QuesRemark|"
	...d OutQuesList
	..e  d
	...s wardId="" f  s wardId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,wardId)) q:wardId=""  d
	....s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,wardId,resultId)) q:resultId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultD(resultId))
	.....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	.....s resultStatus=$lg(resultGlo,7)
	.....i resultStatus="S" d
	......s resultScore=$lg(resultGlo,6)
	......s resultDate=$lg(resultGlo,24)
	......s:resultDate'="" resultDate=$zd(resultDate,3)
	......s resultQues="",resultQuesReamrk=""
	......s scoreType=$lg(resultGlo,13)
	......s scoreTypeSub=$lg(resultGlo,14)
	......s scoreTypeMode=$lg(resultGlo,15)
	......s scoreStandardList=$lg(resultGlo,16)
	......s index=0,resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.......q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.......s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.......s resultSubScore=$lg(resultSubGlo,3)
	.......q:resultSubScore=""
	.......s subStandardScore=$lg(resultSubGlo,5)
	.......q:(scoreType=2)&&(subStandardScore="")
	.......s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.......q:deductFlag'=1
	.......s resultSubItem=$lg(resultSubGlo,2)
	.......s resultSubRemark=$lg(resultSubGlo,6)
	.......i index=0 s resultQues=resultSubItem,resultQuesReamrk=resultSubRemark
	.......e  s resultQues=resultQues_"「"_resultSubItem,resultQuesReamrk=resultQuesReamrk_"「"_resultSubRemark
	.......s index=index+1
	......s resultScore=$lg(resultGlo,6)
	......s resultPass=$lg(resultGlo,25)
	......i (+resultScore)<(+resultPass) s resultPass=0
	......e  s resultPass=1
	......s ret="QualItem|"_taskItemId_"^QualItemDesc|"_taskItemDesc_"^TaskLevel|"_taskLevel_"^TaskLevelDesc|"_taskLevelDesc
	......s ret=ret_"^ResultCheckDate|"_resultDate_"^ResultScore|"_resultScore_"^QuesDesc|"_resultQues_"^QuesRemark|"_resultQuesReamrk
	......s ret=ret_"^ResultPass|"_resultPass
	......d OutQuesList
	.....e  d
	......s ret="QualItem|"_taskItemId_"^QualItemDesc|"_taskItemDesc_"^TaskLevel|"_taskLevel_"^TaskLevelDesc|"_taskLevelDesc
	......s ret=ret_"^ResultCheckDate|未提交^ResultScore|^QuesDesc|^QuesRemark|^ResultPass|"
	......d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQuesByIdListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuesByIdListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQuesByIdListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuesByIdListExecute ]
{
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

/// Description：获取待复查列表
/// Date:2020-08-06
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input: 开始日期^结束日期^状态^质控类型^质控项目^病区 登录人Id 登录人角色
/// Output:待复查列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindReviewList","^^^^",0)
Query FindReviewList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindReviewListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ward=$p(parr,"^")
	s type=$tr($p(parr,"^",2),"_","|")
	s qual=$p(parr,"^",3)
	s stDate=$p(parr,"^",4)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s resultTypeDesc=""
	....i resultType'="" d
	.....s typePar=$p(resultType,"||")
	.....s typeSub=$p(resultType,"||",2)
	.....s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	.....s resultTypeDesc=$lg(typeGlo,3)
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s counter=0
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s resultSubReview=$lg(resultSubGlo,11)
	.....q:resultSubReview'=""
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:resultSubScore=""
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s counter=counter+1
	....q:counter=0
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskCheckerId="",taskSourceDesc=""
	....i taskGlo'="" d
	.....s taskCheckers=$lg(taskGlo,4)
	.....s taskCheckerId=$lts(taskCheckers,",")
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....s resultScore=$lg(resultGlo,6)
	....s resultRemark=$lg(resultGlo,9)
	....s resultSubmitter=$lg(resultGlo,19)
	....s resultSubmitterName=""
	....i resultSubmitter=0 s resultSubmitterName="管理员"
	....e  i resultSubmitter'="" d
	.....s perGlo=$g(^CF.DHCINM.DB.MgUserD(resultSubmitter))
	.....s resultSubmitterName=$lg(perGlo,2)
	....s resultSubDate=$lg(resultGlo,22)
	....s:resultSubDate'="" resultSubDate=$zd(resultSubDate,3)
	....s resultCheckDate=$lg(resultGlo,24)
	....s:resultCheckDate'="" resultCheckDate=$zd(resultCheckDate,3)
	....s ret="QuesDate|"_$zd(checkDate,3)_"^QuesWard|"_checkWard_"^QuesWardDesc|"_checkWardDesc_"^QuesItem|"_checkItem_"^QuesItemDesc|"_checkItemDesc
	....s ret=ret_"^QuesType|"_$tr(resultType,"|","_")_"^QuesTypeDesc|"_resultTypeDesc_"^QuesReviewCounter|"_counter_"^ResultScore|"_resultScore
	....s ret=ret_"^ResultSubmitter|"_resultSubmitter_"^ResultSubmitterName|"_resultSubmitterName_"^ResultCheckDate|"_resultCheckDate
	....s ret=ret_"^ResultSubDate|"_resultSubDate_"^ResultRemark|"_resultRemark_"^TaskChecker|"_taskCheckerId_"^TaskSourceDesc|"_taskSourceDesc_"^TaskId|"_taskId_"^ResultId|"_resultId
	....d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindReviewListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReviewListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindReviewListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReviewListExecute ]
{
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

/// Description：获取复查记录列表
/// Date:2020-08-06
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input: 开始日期^结束日期^状态^质控类型^质控项目^病区 登录人Id 登录人角色
/// Output:复查记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindReviewRecList","^^^2021-03-01^2021-03-31",42)
Query FindReviewRecList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindReviewRecListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ward=$p(parr,"^")
	s type=$tr($p(parr,"^",2),"_","|")
	s qual=$p(parr,"^",3)
	s stDate=$p(parr,"^",4)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))
	..q:((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s resultTypeDesc=""
	....i resultType'="" d
	.....s typePar=$p(resultType,"||")
	.....s typeSub=$p(resultType,"||",2)
	.....s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	.....s resultTypeDesc=$lg(typeGlo,3)
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s quesDesc="",quesReviewResult="",quesReviewChecker="",quesReviewCheckerName="",quesReviewCheckDate="",quesReviewCheckTime="",counter=0
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s resultSubReview=$lg(resultSubGlo,11)
	.....q:resultSubReview=""
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:resultSubScore=""
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s resultSubItem=$lg(resultSubGlo,2)
	.....s resultSubRemark=$lg(resultSubGlo,6)
	.....s resultSubChecker=$lg(resultSubGlo,12)
	.....s resultSubCheckerName=""
	.....i resultSubChecker=0 s resultSubCheckerName="管理员"
	.....e  i resultSubChecker'="" d
	......s userGlo=$g(^CF.DHCINM.DB.MgUserD(resultSubChecker))
	......s resultSubCheckerName=$lg(userGlo,2)
	.....s resultSubCheckDate=$lg(resultSubGlo,13)
	.....s:resultSubCheckDate'="" resultSubCheckDate=$zd(resultSubCheckDate,3)
	.....s resultSubCheckTime=$lg(resultSubGlo,14)
	.....s:resultSubCheckTime'="" resultSubCheckTime=$zt(resultSubCheckTime,1)
	.....i counter=0 d
	......s quesDesc=resultSubItem,quesReviewResult=resultSubReview,quesReviewChecker=resultSubChecker,quesReviewCheckerName=resultSubCheckerName
	......s quesReviewCheckDate=resultSubCheckDate,quesReviewCheckTime=resultSubCheckTime
	......s:resultSubRemark'="" quesDesc=quesDesc_"【"_resultSubRemark_"】"
	.....e  d
	......s quesDesc=quesDesc_"」"_resultSubItem,quesReviewResult=quesReviewResult_"」"_resultSubReview,quesReviewChecker=quesReviewChecker_"」"_resultSubChecker
	......s quesReviewCheckerName=quesReviewCheckerName_"」"_resultSubCheckerName,quesReviewCheckDate=quesReviewCheckDate_"」"_resultSubCheckDate
	......s quesReviewCheckTime=quesReviewCheckTime_"」"_resultSubCheckTime
	......s:resultSubRemark'="" quesDesc=quesDesc_"【"_resultSubRemark_"】"
	.....s counter=counter+1
	....q:counter=0
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskCheckerId="",taskSourceDesc=""
	....i taskGlo'="" d
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....s ret="QuesDate|"_$zd(checkDate,3)_"^QuesWard|"_checkWard_"^QuesWardDesc|"_checkWardDesc_"^QuesItem|"_checkItem_"^QuesItemDesc|"_checkItemDesc
	....s ret=ret_"^QuesType|"_$tr(resultType,"|","_")_"^QuesTypeDesc|"_resultTypeDesc_"^QuesDesc|"_quesDesc_"^QuesReviewResult|"_quesReviewResult_"^QuesReviewChecker|"_quesReviewChecker
	....s ret=ret_"^QuesReviewCheckerName|"_quesReviewCheckerName_"^QuesReviewCheckDate|"_quesReviewCheckDate_"^QuesReviewCheckTime|"_quesReviewCheckTime_"^TaskSourceDesc|"_taskSourceDesc_"^ResultId|"_resultId
	....d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindReviewRecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReviewRecListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindReviewRecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReviewRecListExecute ]
{
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

/// Description:保存复查结果
/// Date:2020-08-07
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResultSub
/// Input:parr userid
/// Output：0：失败 1：成功
/// Other:w ##class(web.INMQualControlComm).SaveReview("",0)
ClassMethod SaveReview(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s now=$h
	s nowDate=+now
	s nowTime=$p(now,",",2)
	s reviewList=$lfs(parr,"^")
	s ptr=0 f  s status=$listnext(reviewList,ptr,result) q:status'=1  d
	.s subId=$p(result,",")
	.s reviewResult=$p(result,",",2)
	.q:reviewResult=""
	.s subObj=##class(DHCINM.CHK.MgCheckResultSub).%OpenId(subId)
	.q:'$IsObject(subObj)
	.i ((subObj.SubReview="")||(subObj.SubReview'=reviewResult)) d
	..s subObj.SubReviewUser=nurseid
	..s subObj.SubReview=reviewResult
	.;s subObj.SubReview=reviewResult
	.;s subObj.SubReviewUser=nurseid 
	.s subObj.SubReviewDate=nowDate
	.s subObj.SubReviewTime=nowTime
	.d subObj.%Save()
	
	q 1
}

/// Description：获取考核结果列表
/// Date:2020-09-04
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:考核结果列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckResultAvg","^^^^^",0)
Query FindCheckResultAvg(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckResultAvgExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmpScore,tmpItem,tmpWardDesc
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskSourceDesc=""
	....i taskGlo'="" d
	.....i checkItemDesc="" d
	......s taskQualItemList=$lg(taskGlo,2)
	......s flag=0
	......s ptr=0 f  s status=$listnext(taskQualItemList,ptr,taskQualItem) q:(status'=1)||(flag=1)  d
	.......s taskQualItemDesc=$p(taskQualItem,"「")
	.......s taskQualItemId=$p(taskQualItem,"「",2)
	.......q:checkItem'=taskQualItemId
	.......s checkItemDesc=taskQualItemDesc
	.......s flag=1
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	....s resultScore=$lg(resultGlo,6)
	....s scoreType=$lg(resultGlo,13)
	....s:'$d(tmpItem(checkItem)) tmpItem(checkItem)=checkItemDesc
	....s tmpItem(checkItem,"type")=scoreType
	....s tmpWardDesc(checkWard)=checkWardDesc
	....s tmpScore(checkWard,checkItem)=$fn($g(tmpScore(checkWard,checkItem)),"")+$fn(resultScore,"")
	....s tmpScore(checkWard,checkItem,"counter")=$g(tmpScore(checkWard,checkItem,"counter"))+1
	
	s wardId="" f  s wardId=$o(tmpScore(wardId)) q:wardId=""  d
	.s ret="Ward|"_wardId_"^WardDesc|"_tmpWardDesc(wardId)
	.s resultItem="" f  s resultItem=$o(tmpItem(resultItem)) q:resultItem=""  d
	..s ret=ret_"^Desc"_resultItem_"|"_tmpItem(resultItem)
	..i $d(tmpScore(wardId,resultItem)) d
	...s ret=ret_"^Score"_resultItem_"|"_$fn(tmpScore(wardId,resultItem)/tmpScore(wardId,resultItem,"counter"),"",2)_$case(tmpItem(resultItem,"type"),1:"%",2:"",:"%")
	..e  s ret=ret_"^Score"_resultItem_"|"
	.d OutScoreList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutScoreList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckResultAvgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckResultAvgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckResultAvgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckResultAvgExecute ]
{
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

/// Description：获取考核结果列表
/// Date:2020-09-04
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:考核结果列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckResultDtl","^^^^^",0)
Query FindCheckResultDtl(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckResultDtlExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmpScore,tmpItem,tmpWardDesc
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s resultTypeDesc=""
	....i resultType'="" d
	.....s typePar=$p(resultType,"||")
	.....s typeSub=$p(resultType,"||",2)
	.....s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	.....s resultTypeDesc=$lg(typeGlo,3)
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskCheckerId="",taskCheckerName="",taskLevel="",taskLevelDesc="",taskSourceDesc=""
	....i taskGlo'="" d
	.....i checkItemDesc="" d
	......s taskQualItemList=$lg(taskGlo,2)
	......s flag=0
	......s ptr=0 f  s status=$listnext(taskQualItemList,ptr,taskQualItem) q:(status'=1)||(flag=1)  d
	.......s taskQualItemDesc=$p(taskQualItem,"「")
	.......s taskQualItemId=$p(taskQualItem,"「",2)
	.......q:checkItem'=taskQualItemId
	.......s checkItemDesc=taskQualItemDesc
	.......s flag=1
	.....s taskCheckers=$lg(taskGlo,4)
	.....s taskCheckerId=$lts(taskCheckers,",")
	.....s taskCheckerName=""
	.....s counter=0,checkerPtr=0 f  s taskCheckerStatus=$listnext(taskCheckers,checkerPtr,taskChecker) q:taskCheckerStatus'=1  d
	......s checkerGlo=$g(^CF.DHCINM.HR.PersonsD(taskChecker))
	......s checkerName=$lg(checkerGlo,2)
	......i counter=0 s taskCheckerName=checkerName
	......e  s taskCheckerName=taskCheckerName_","_checkerName
	.....s taskLevel=$lg(taskGlo,8)
	.....s taskLevelDesc=$case(taskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	....s resultScore=$lg(resultGlo,6)
	....s resultPass=$lg(resultGlo,25)
	....i (+resultScore)<(+resultPass) s resultPass=0
	....e  s resultPass=1
	....s ret="CheckDate|"_$zd(checkDate,3)_"^CheckWayDesc|"_taskSourceDesc_"^QualType|"_$tr(resultType,"|","_")_"^QualTypeDesc|"_resultTypeDesc_"^TaskLevel|"_taskLevel
	....s ret=ret_"^TaskLevelDesc|"_taskLevelDesc_"^QualItem|"_checkItem_"^QualItemDesc|"_checkItemDesc_"^Ward|"_checkWard_"^WardDesc|"_checkWardDesc
	....s ret=ret_"^ResultScore|"_resultScore_"^ResultPass|"_resultPass_"^Checker|"_taskCheckerId_"^CheckerName|"_taskCheckerName_"^ResultId|"_resultId
	....d OutScoreList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutScoreList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckResultDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckResultDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckResultDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckResultDtlExecute ]
{
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

/// Description：获取考核结果级别列表
/// Date:2020-09-07
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:考核结果级别列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckResultLv","^^^^^","-999「60「E,60「70「D,70「80「C,80「90「B,90「999「A",0)
Query FindCheckResultLv(parr As %String = "", level As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckResultLvExecute(ByRef qHandle As %Binary, parr As %String = "", level As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))||(level="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	s levelList=$lfs(level,",")
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmp,tmpItem
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskSourceDesc=""
	....i taskGlo'="" d
	.....i checkItemDesc="" d
	......s taskQualItemList=$lg(taskGlo,2)
	......s flag=0
	......s ptr=0 f  s status=$listnext(taskQualItemList,ptr,taskQualItem) q:(status'=1)||(flag=1)  d
	.......s taskQualItemDesc=$p(taskQualItem,"「")
	.......s taskQualItemId=$p(taskQualItem,"「",2)
	.......q:checkItem'=taskQualItemId
	.......s checkItemDesc=taskQualItemDesc
	.......s flag=1
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	....s resultScore=+$lg(resultGlo,6)
	....s tmpItem(checkItem)=checkItemDesc
	....s tmpItem(checkItem,"Count")=$g(tmpItem(checkItem,"Count"))+1
	....s flag=0
	....s ptr=0 f  s status=$listnext(levelList,ptr,value) q:(status'=1)||(flag=1)  d
	.....s min=$p(value,"「")
	.....s max=$p(value,"「",2)
	.....s key=$p(value,"「",3)
	.....q:key=""
	.....s:(resultScore>=min)&&(resultScore<max) tmp(checkItem,key)=$g(tmp(checkItem,key))+1,flag=1
	
	s qualId="" f  s qualId=$o(tmpItem(qualId)) q:qualId=""  d
	.s ret="QualItem|"_qualId_"^QualItemDesc|"_tmpItem(qualId)
	.s ptr=0 f  s status=$listnext(levelList,ptr,value) q:status'=1  d
	..s key=$p(value,"「",3)
	..q:key=""
	..s ret=ret_"^"_key_"|"_$fn($g(tmp(qualId,key))/tmpItem(qualId,"Count")*100,"",2)_"%"
	.d OutScoreList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutScoreList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckResultLvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckResultLvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckResultLvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckResultLvExecute ]
{
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

/// Description：按月份获取一项目考核结果
/// Date:2020-09-08
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:考核结果级别列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindResultByMonth","^^^2^2020-01^2020-08",0)
Query FindResultByMonth(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindResultByMonthExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s endDate=$p(parr,"^",6)
	
	i (qual="")||(stDate="")||(endDate="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s stDate=$zdh(stDate_"-01",3)
	s endDate=$SYSTEM.SQL.LASTDAY(endDate_"-01")
	
	k tmpMonth
	f date=stDate:1:endDate d
	.s month=$e($zd(date,8),1,6)
	.q:$d(tmpMonth(month))
	.s tmpMonth(month)=""
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmpScore,tmpItem,tmpWardDesc
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkMonth=$e($zd(checkDate,8),1,6)
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,qual,resultId)) q:resultId=""  d
	...q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	...s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	...s resultType=$lg(resultGlo,4)
	...q:(type'="")&&(type'=resultType)
	...s taskId=$lg(resultGlo,3)
	...s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	...s taskSourceDesc=""
	...i taskGlo'="" d
	....s taskIsRandom=$lg(taskGlo,15)
	....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	....e  d
	.....s taskType=$lg(taskGlo,3)
	.....q:(taskType="")
	.....s taskTypePar=$p(taskType,"||")
	.....s taskTypeSub=$p(taskType,"||",2)
	.....q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	.....s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	.....s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	.....i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	.....e  s taskSourceDesc="质控任务"
	...q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	...s resultScore=$lg(resultGlo,6)
	...s scoreType=$lg(resultGlo,13)
	...s tmpItem(qual,"type")=scoreType
	...s tmpWardDesc(checkWard)=checkWardDesc
	...s tmpScore(checkWard,checkMonth)=$fn($g(tmpScore(checkWard,checkMonth)),"")+$fn(resultScore,"")
	...s tmpScore(checkWard,checkMonth,"counter")=$g(tmpScore(checkWard,checkMonth,"counter"))+1
	
	s wardId="" f  s wardId=$o(tmpScore(wardId)) q:wardId=""  d
	.s ret="Ward|"_wardId_"^WardDesc|"_tmpWardDesc(wardId)
	.s month="" f  s month=$o(tmpMonth(month)) q:month=""  d
	..i $d(tmpScore(wardId,month)) d
	...s ret=ret_"^"_month_"|"_$fn(tmpScore(wardId,month)/tmpScore(wardId,month,"counter"),"",2)_$case(tmpItem(qual,"type"),1:"%",2:"",:"%")
	..e  s ret=ret_"^"_month_"|"
	.d OutScoreList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutScoreList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindResultByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindResultByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindResultByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindResultByMonthExecute ]
{
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

/// Description：质控问题统计
/// Date:2020-09-08
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:质控问题统计
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQuesCount","^^^44^^2022-03-31^^",0)
Query FindQuesCount(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQuesCountExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	s level=$p(parr,"^",7)
	s qualLevel=$p(parr,"^",8)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmpItem,tmpCheck,tmpError,tmpErrorWard,tmpErrorRea
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskCheckLevel="",taskSourceDesc=""
	....i taskGlo'="" d
	.....s taskCheckLevel=$lg(taskGlo,8)
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....q:(level'="")&&(level'=taskCheckLevel)
	....q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....q:$d(^DHCINM.CHK.MgCheckResultSubI("Par",resultId_"||"_resultSubId))
	.....s checkItemSubId=$p($lg(resultSubGlo,7),"||",2)
	.....s targetResultSubGlo=resultSubGlo
	.....s resultSubSort=$lg(resultSubGlo,9)
	.....i (qualLevel'="")&&(qualLevel+1'=$l(resultSubSort,".")) d
	......s checkItemSubId=""
	......q:qualLevel+1>$l(resultSubSort,".")
	......s targetResultSort=$p(resultSubSort,".",1,qualLevel+1)
	......q:targetResultSort=""
	......s targetResultSubId=$o(^DHCINM.CHK.MgCheckResultSubI("Sort",resultId," "_targetResultSort,""))
	......q:targetResultSubId=""
	......s targetResultSubGlo=$g(^DHCINM.CHK.MgCheckResultSubD(resultId,targetResultSubId))
	......s checkItemSubId=$p($lg(targetResultSubGlo,7),"||",2)
	.....q:checkItemSubId=""
	.....s tmpCheck(checkItem,checkItemSubId)=$g(tmpCheck(checkItem,checkItemSubId))+1
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:resultSubScore=""
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s resultSubItem=$lg(targetResultSubGlo,2)
	.....s:'$d(tmpItem(checkItem,checkItemSubId)) tmpItem(checkItem,checkItemSubId)=resultSubItem
	.....s tmpError(checkItem)=$g(tmpError(checkItem))+1
	.....s tmpError(checkItem,checkItemSubId)=$g(tmpError(checkItem,checkItemSubId))+1
	.....s remark=$lg(resultSubGlo,6)
	.....s:remark="" remark=" "
	.....i '$d(tmpErrorRea(checkItem,checkItemSubId,remark,checkWard)) d
	......s tmpRemark=$g(tmpErrorRea(checkItem,checkItemSubId,remark))
	......s tmpErrorRea(checkItem,checkItemSubId,remark)=tmpRemark_$case(tmpRemark,"":"",:",")_checkWardDesc
	......s tmpErrorRea(checkItem,checkItemSubId,remark,checkWard)=1
	.....e  s tmpErrorRea(checkItem,checkItemSubId,remark,checkWard)=tmpErrorRea(checkItem,checkItemSubId,remark,checkWard)+1
	.....i '$d(tmpErrorWard(checkItem,checkItemSubId,checkWard)) d
	......s tmpErrorWard(checkItem,checkItemSubId,checkWard)=checkWardDesc
	......s tmpErrorWard(checkItem,checkItemSubId,"WardCount")=$g(tmpErrorWard(checkItem,checkItemSubId,"WardCount"))+1
	......s tmpErrorWard(checkItem,checkItemSubId,checkWard,"WardErrorCount")=1
	.....e  s tmpErrorWard(checkItem,checkItemSubId,checkWard,"WardErrorCount")=tmpErrorWard(checkItem,checkItemSubId,checkWard,"WardErrorCount")+1

	
	k tmpSort
	s qualId="" f  s qualId=$o(tmpError(qualId)) q:qualId=""  d
	.s subId="" f  s subId=$o(tmpError(qualId,subId)) q:subId=""  d
	..s subCount=tmpError(qualId,subId)
	..s tmpSort(qualId,subCount,subId)=1
	k target
	s qualId="" f  s qualId=$o(tmpSort(qualId)) q:qualId=""  d
	.s total=tmpError(qualId)
	.s count=0,flag=1,ratioLast=0,subIdLast="",targetSubId=""
	.s subCount="" f  s subCount=$o(tmpSort(qualId,subCount),-1) q:(subCount="")||(flag'=1)  d
	..s subId="" f  s subId=$o(tmpSort(qualId,subCount,subId)) q:(subId="")||(flag'=1)  d
	...s count=count+subCount
	...s ratio=$fn(count/total,"",2)
	...i ratio>=0.8 d
	....s diff=ratio-0.8
	....s diffLast=0.8-ratioLast
	....s:diff<=diffLast target(qualId,subId)=1
	....s flag=0
	...e  s target(qualId,subId)=1
	...q:flag'=1
	...s ratioLast=ratio
	...s subIdLast=subId
	s qualId="" f  s qualId=$o(tmpError(qualId)) q:qualId=""  d
	.s subId="" f  s subId=$o(tmpError(qualId,subId)) q:subId=""  d
	..s ret="QualSub|"_qualId_"__"_subId_"^QualSubDesc|"_tmpItem(qualId,subId)_"^Count|"_tmpError(qualId,subId)
	..s ret=ret_"^WardCount|"_(+tmpErrorWard(qualId,subId,"WardCount"))_"^Ratio|"_$fn(tmpError(qualId,subId)/tmpCheck(qualId,subId)*100,"",2)_"%"
	..s ret=ret_"^QuesMain|"_$select($d(target(qualId,subId)):"Y",1:"N")
	..s quesWardDesc="",quesWardCountDesc=""
	..s wardId="" f  s wardId=$o(tmpErrorWard(qualId,subId,wardId)) q:wardId=""  d
	...q:'(+wardId)
	...s quesWardDesc=quesWardDesc_$case(quesWardDesc,"":"",:",")_tmpErrorWard(qualId,subId,wardId)
	...s quesWardCountDesc=quesWardCountDesc_$case(quesWardCountDesc,"":"",:",")_tmpErrorWard(qualId,subId,wardId)_":"_tmpErrorWard(qualId,subId,wardId,"WardErrorCount")
	..s ret=ret_"^QuesWardDesc|"_quesWardDesc_"^QuesWardCountDesc|"_quesWardCountDesc
	..s ret=ret_"^QuesWardDetail|"_(+tmpErrorWard(qualId,subId,"WardCount"))_"("_quesWardDesc_")"
	..s quesReason=""
	..s rea="" f  s rea=$o(tmpErrorRea(qualId,subId,rea)) q:rea=""  d
	...s quesReason=quesReason_$case(quesReason,"":"",:"」")_rea_"「"_tmpErrorRea(qualId,subId,rea)
	..s ret=ret_"^QuesReasonWard|"_quesReason
	..d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQuesCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuesCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQuesCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuesCountExecute ]
{
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

/// Description：获取某一质控问题扣分详情列表
/// Date:2020-09-09
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:扣分详情列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQuesDtl","^^^2^^^2__3",0)
Query FindQuesDtl(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQuesDtlExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	s item=$tr($p(parr,"^",7),"_","|")
	s nurse=$p(parr,"^",8)
	
	i (qual="")||(item="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s qualGlo=$g(^CT.DHCINM.DB.MgQualItemD(qual))
	s qualDesc=$lg(qualGlo,4)
	
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,qual,resultId)) q:resultId=""  d
	...q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	...s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	...s insertNurList=$lg(resultGlo,27)
	...q:(nurse'="")&&($lf(insertNurList,nurse)=0)
	...s resultType=$lg(resultGlo,4)
	...q:(type'="")&&(type'=resultType)
	...s resultTypeDesc=""
	...i resultType'="" d
	....s typePar=$p(resultType,"||")
	....s typeSub=$p(resultType,"||",2)
	....s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	....s resultTypeDesc=$lg(typeGlo,3)
	...s taskId=$lg(resultGlo,3)
	...s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	...s taskCheckerId="",taskCheckerName="",taskLevel="",taskLevelDesc="",taskSourceDesc=""
	...i taskGlo'="" d
	....i qualDesc="" d
	.....s taskQualItemList=$lg(taskGlo,2)
	.....s flag=0
	.....s ptr=0 f  s status=$listnext(taskQualItemList,ptr,taskQualItem) q:(status'=1)||(flag=1)  d
	......s taskQualItemDesc=$p(taskQualItem,"「")
	......s taskQualItemId=$p(taskQualItem,"「",2)
	......q:qual'=taskQualItemId
	......s qualDesc=taskQualItemDesc
	......s flag=1
	....s taskCheckers=$lg(taskGlo,4)
	....s taskCheckerId=$lts(taskCheckers,",")
	....s taskCheckerName=""
	....s counter=0,checkerPtr=0 f  s taskCheckerStatus=$listnext(taskCheckers,checkerPtr,taskChecker) q:taskCheckerStatus'=1  d
	.....s checkerGlo=$g(^CF.DHCINM.HR.PersonsD(taskChecker))
	.....s checkerName=$lg(checkerGlo,2)
	.....i counter=0 s taskCheckerName=checkerName
	.....e  s taskCheckerName=taskCheckerName_","_checkerName
	....s taskLevel=$lg(taskGlo,8)
	....s taskLevelDesc=$case(taskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	....s taskIsRandom=$lg(taskGlo,15)
	....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	....e  d
	.....s taskType=$lg(taskGlo,3)
	.....q:taskType=""
	.....s taskTypePar=$p(taskType,"||")
	.....s taskTypeSub=$p(taskType,"||",2)
	.....q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	.....s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	.....s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	.....i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	.....e  s taskSourceDesc="质控任务"
	...q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	...s scoreType=$lg(resultGlo,13)
	...s scoreTypeSub=$lg(resultGlo,14)
	...s scoreTypeMode=$lg(resultGlo,15)
	...s scoreStandardList=$lg(resultGlo,16)
	...s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubI("Qual",resultId,item,""))
	...q:resultSubId=""
	...q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	...s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	...s resultSubScore=$lg(resultSubGlo,3)
	...q:resultSubScore=""
	...s subStandardScore=$lg(resultSubGlo,5)
	...q:(scoreType=2)&&(subStandardScore="")
	...s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	...q:deductFlag'=1
	...s resultItemSubDesc=$lg(resultSubGlo,2)
	...s subReview=$lg(resultSubGlo,11)
	...s subReviewDesc=$case(subReview,"Y":"复查通过","N":"复查未通过","":"待复查",:"")
	...s ret="CheckDate|"_$zd(checkDate,3)_"^CheckWayDesc|"_taskSourceDesc_"^QualType|"_$tr(resultType,"|","_")_"^QualTypeDesc|"_resultTypeDesc_"^TaskLevel|"_taskLevel
	...s ret=ret_"^TaskLevelDesc|"_taskLevelDesc_"^QualItem|"_qual_"^QualItemDesc|"_qualDesc_"^QualItemSub|"_$tr(item,"|","_")_"^QualItemSubDesc|"_resultItemSubDesc
	...s ret=ret_"^Ward|"_checkWard_"^WardDesc|"_checkWardDesc_"^Checker|"_taskCheckerId_"^CheckerName|"_taskCheckerName_"^ReviewStatus|"_subReview
	...s ret=ret_"^ReviewStatusDesc|"_subReviewDesc_"^ResultId|"_resultId
	...d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQuesDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuesDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQuesDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuesDtlExecute ]
{
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

/// Description：获取某一质控问题整改率列表
/// Date:2020-09-09
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:质控问题整改率列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQuesChgRat","^^^^^",0)
Query FindQuesChgRat(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQuesChgRatExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmpItem,tmpError,tmpToSolve,tmpUnSolve,tmpSolve
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskSourceDesc=""
	....i taskGlo'="" d
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:taskType=""
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:resultSubScore=""
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s resultSubItem=$lg(resultSubGlo,2)
	.....s checkItemSubId=$p($lg(resultSubGlo,7),"||",2)
	.....s:'$d(tmpItem(checkItem,checkItemSubId)) tmpItem(checkItem,checkItemSubId)=resultSubItem
	.....s tmpError(checkItem,checkItemSubId)=$g(tmpError(checkItem,checkItemSubId))+1
	.....s checkItemSubReview=$lg(resultSubGlo,11)
	.....i checkItemSubReview="" s tmpToSolve(checkItem,checkItemSubId)=$g(tmpToSolve(checkItem,checkItemSubId))+1
	.....e  i checkItemSubReview="N" s tmpUnSolve(checkItem,checkItemSubId)=$g(tmpUnSolve(checkItem,checkItemSubId))+1
	.....e  i checkItemSubReview="Y" s tmpSolve(checkItem,checkItemSubId)=$g(tmpSolve(checkItem,checkItemSubId))+1
	
	s qualId="" f  s qualId=$o(tmpError(qualId)) q:qualId=""  d
	.s subId="" f  s subId=$o(tmpError(qualId,subId)) q:subId=""  d
	..s ret="QualSub|"_qualId_"__"_subId_"^QualSubDesc|"_tmpItem(qualId,subId)_"^ToSolve|"_$fn($g(tmpToSolve(qualId,subId))/tmpError(qualId,subId)*100,"",2)_"%"
	..s ret=ret_"^UnSolve|"_$fn($g(tmpUnSolve(qualId,subId))/tmpError(qualId,subId)*100,"",2)_"%"
	..s ret=ret_"^Solve|"_$fn($g(tmpSolve(qualId,subId))/tmpError(qualId,subId)*100,"",2)_"%"
	..d OutChangeList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutChangeList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQuesChgRatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuesChgRatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQuesChgRatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuesChgRatExecute ]
{
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

/// Description：质控问题频次统计
/// Date:2020-09-08
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:质控问题频次统计
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQuesFrequency","^^^^^",0)
Query FindQuesFrequency(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQuesFrequencyExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmpItem,tmpWardDesc,tmpWardItem
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskSourceDesc=""
	....i taskGlo'="" d
	.....i checkItemDesc="" d
	......s taskQualItemList=$lg(taskGlo,2)
	......s flag=0
	......s ptr=0 f  s status=$listnext(taskQualItemList,ptr,taskQualItem) q:(status'=1)||(flag=1)  d
	.......s taskQualItemDesc=$p(taskQualItem,"「")
	.......s taskQualItemId=$p(taskQualItem,"「",2)
	.......q:checkItem'=taskQualItemId
	.......s checkItemDesc=taskQualItemDesc
	.......s flag=1
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:resultSubScore=""
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s resultSubItem=$lg(resultSubGlo,2)
	.....s checkItemSubId=$p($lg(resultSubGlo,7),"||",2)
	.....s:'$d(tmpItem(checkItem)) tmpItem(checkItem)=checkItemDesc
	.....s:'$d(tmpItem(checkItem,checkItemSubId)) tmpItem(checkItem,checkItemSubId)=resultSubItem
	.....s:'$d(tmpWardDesc(checkWard)) tmpWardDesc(checkWard)=checkWardDesc
	.....s tmpWardItem(checkWard,checkItem,checkItemSubId)=$g(tmpWardItem(checkWard,checkItem,checkItemSubId))+1
	
	s wardId="" f  s wardId=$o(tmpWardItem(wardId)) q:wardId=""  d
	.s qualId="" f  s qualId=$o(tmpWardItem(wardId,qualId)) q:qualId=""  d
	..s subId="" f  s subId=$o(tmpWardItem(wardId,qualId,subId)) q:subId=""  d
	...s ret="Ward|"_wardId_"^WardDesc|"_tmpWardDesc(wardId)_"^Qual|"_qualId_"^QualDesc|"_tmpItem(qualId)_"^QualSub|"_qualId_"__"_subId
	...s ret=ret_"^QualSubDesc|"_tmpItem(qualId,subId)_"^Count|"_tmpWardItem(wardId,qualId,subId)
	...d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQuesFrequencyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuesFrequencyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQuesFrequencyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuesFrequencyExecute ]
{
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

/// Description：护士质控问题频次统计
/// Date:2020-09-08
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult DHCINM.CHK.MgCheckQues
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:护士质控问题频次统计
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindNurQuesFreq","^^^^^",0)
Query FindNurQuesFreq(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurQuesFreqExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmpItem,tmpNurse,tmpNurseItem
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:((stDate'="")&&(checkDate<stDate))||((endDate'="")&&(endDate<checkDate))
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s insertNurList=$lg(resultGlo,27)
	....q:$ll(insertNurList)=0
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskSourceDesc=""
	....i taskGlo'="" d
	.....i checkItemDesc="" d
	......s taskQualItemList=$lg(taskGlo,2)
	......s flag=0
	......s ptr=0 f  s status=$listnext(taskQualItemList,ptr,taskQualItem) q:(status'=1)||(flag=1)  d
	.......s taskQualItemDesc=$p(taskQualItem,"「")
	.......s taskQualItemId=$p(taskQualItem,"「",2)
	.......q:checkItem'=taskQualItemId
	.......s checkItemDesc=taskQualItemDesc
	.......s flag=1
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:resultSubScore=""
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s subScoreList=$lfs(resultSubScore,",")
	.....s scoreIndex=0
	.....s ptr=0 f  s status=$listnext(subScoreList,ptr,score) q:status'=1  d
	......s scoreIndex=scoreIndex+1
	......q:score=""
	......s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,score,subStandardScore)
	......q:deductFlag'=1
	......s resultSubItem=$lg(resultSubGlo,2)
	......s checkItemSubId=$p($lg(resultSubGlo,7),"||",2)
	......s nurseId=$lg(insertNurList,scoreIndex)
	......q:nurseId=""
	......s:'$d(tmpItem(checkItem)) tmpItem(checkItem)=checkItemDesc
	......s:'$d(tmpItem(checkItem,checkItemSubId)) tmpItem(checkItem,checkItemSubId)=resultSubItem
	......i '$d(tmpNurse(nurseId)) d
	.......s perGlo=$g(^CF.DHCINM.HR.PersonsD(nurseId))
	.......s perName=$lg(perGlo,2)
	.......s tmpNurse(nurseId)=perName
	......s tmpNurseItem(nurseId,checkItem,checkItemSubId)=$g(tmpNurseItem(nurseId,checkItem,checkItemSubId))+1
	
	s nurseId="" f  s nurseId=$o(tmpNurseItem(nurseId)) q:nurseId=""  d
	.s qualId="" f  s qualId=$o(tmpNurseItem(nurseId,qualId)) q:qualId=""  d
	..s subId="" f  s subId=$o(tmpNurseItem(nurseId,qualId,subId)) q:subId=""  d
	...s ret="Nurse|"_nurseId_"^NurseName|"_tmpNurse(nurseId)_"^Qual|"_qualId_"^QualDesc|"_tmpItem(qualId)_"^QualSub|"_qualId_"__"_subId
	...s ret=ret_"^QualSubDesc|"_tmpItem(qualId,subId)_"^Count|"_tmpNurseItem(nurseId,qualId,subId)
	...d OutQuesList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuesList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurQuesFreqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurQuesFreqExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurQuesFreqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurQuesFreqExecute ]
{
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

/// Description：质控任务完成率统计
/// Date:2020-09-14
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:质控任务完成率统计
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQualFinish","^^^^^",0)
Query FindQualFinish(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQualFinishExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom)) q:isRandom=""  d
	.s isRandomTrip=$tr(isRandom," ","")
	.q:isRandomTrip="Y"
	.s taskType="" f  s taskType=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType)) q:taskType=""  d
	..q:(type'="")&&(type'=taskType)
	..s typePar=$p(taskType,"||")
	..s typeSub=$p(taskType,"||",2)
	..s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	..s taskTypeDesc=$lg(typeGlo,3)
	..s taskTypeCode=$zcvt($lg(typeGlo,2),"U")
	..i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	..e  s taskSourceDesc="质控任务"
	..q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))
	..s taskPublish=0,taskInTime=0,taskOutTime=0,taskUnCheck=0
	..s taskStDate="" f  s taskStDate=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate)) q:taskStDate=""  d
	...q:(endDate'="")&&(endDate<taskStDate)
	...s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,taskType,taskStDate,taskId)) q:taskId=""  d
	....q:'$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(taskId)
	....s taskStatus=$lg(taskGlo,11)
	....q:taskStatus'="Y"
	....s taskEndDate=$lg(taskGlo,10)
	....q:(stDate'="")&&(stDate>taskEndDate)
	....s taskItemList=$lg(taskGlo,2)
	....s taskWardList=$lg(taskGlo,6)
	....s itemPtr=0 f  s itemStatus=$listnext(taskItemList,itemPtr,taskItem) q:itemStatus'=1  d
	.....s taskItemDesc=$p(taskItem,"「")
	.....s taskItemId=$p(taskItem,"「",2)
	.....q:(qual'="")&&(qual'=taskItemId)
	.....s wardPtr=0 f  s wardStatus=$listnext(taskWardList,wardPtr,taskWard) q:wardStatus'=1  d
	......q:(ward'="")&&(ward'=taskWard)
	......s taskPublish=taskPublish+1
	......s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWard,""))
	......i (resultId="")||($d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1) s taskUnCheck=taskUnCheck+1
	......e  d
	.......s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	.......s resultStatus=$lg(resultGlo,7)
	.......s:resultStatus'="S" taskUnCheck=taskUnCheck+1
	.......q:resultStatus'="S"
	.......s resultCheckDate=$lg(resultGlo,24)
	.......i resultCheckDate>taskEndDate s taskOutTime=taskOutTime+1
	.......e  s taskInTime=taskInTime+1
	..q:taskPublish=0
	..s ret="TaskType|"_$tr(taskType,"|","_")_"^TaskTypeDesc|"_taskTypeDesc_"^TaskPublish|"_taskPublish
	..s ret=ret_"^TaskWayDesc|"_taskSourceDesc
	..s ret=ret_"^TaskInTime|"_taskInTime
	..s ret=ret_"^TaskInTimeRat|"_$fn(taskInTime/taskPublish*100,"",2)_"%"
	..s ret=ret_"^TaskOutTime|"_taskOutTime
	..s ret=ret_"^TaskOutTimeRat|"_$fn(taskOutTime/taskPublish*100,"",2)_"%"
	..s ret=ret_"^TaskUnCheck|"_taskUnCheck
	..s ret=ret_"^TaskUnCheckRat|"_$fn(taskUnCheck/taskPublish*100,"",2)_"%"
	..d OutFinishRatList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutFinishRatList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualFinishClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualFinishExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQualFinishFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualFinishExecute ]
{
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

/// Description：质控任务完成率详情
/// Date:2020-09-14
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask DHCINM.CHK.MgCheckResult
/// Input: 病区^检查方式^质控类型^质控项目^开始日期^结束日期 登录人Id
/// Output:质控任务完成率详情
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindQualFinDtl","^^5__1^^^",0)
Query FindQualFinDtl(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQualFinDtlExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	i type=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s typePar=$p(type,"||")
	s typeSub=$p(type,"||",2)
	s typeGlo=$g(^CT.DHCINM.Set.MgSysParamSubD(typePar,typeSub))
	s taskTypeDesc=$lg(typeGlo,3)
	s taskTypeCode=$zcvt($lg(typeGlo,2),"U")
	i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	e  s taskSourceDesc="质控任务"
	i ((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s isRandom="" f  s isRandom=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom)) q:isRandom=""  d
	.s isRandomTrip=$tr(isRandom," ","")
	.q:isRandomTrip="Y"
	.s taskStDate="" f  s taskStDate=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,type,taskStDate)) q:taskStDate=""  d
	..q:(endDate'="")&&(endDate<taskStDate)
	..s taskId="" f  s taskId=$o(^DHCINM.CHK.MgQualCheckTaskI("TypeDate",isRandom,type,taskStDate,taskId)) q:taskId=""  d
	...q:'$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	...s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(taskId)
	...s taskStatus=$lg(taskGlo,11)
	...q:taskStatus'="Y"
	...s taskEndDate=$lg(taskGlo,10)
	...q:(stDate'="")&&(stDate>taskEndDate)
	...s taskCheckers=$lg(taskGlo,4)
	...s taskCheckerId=$lts(taskCheckers,",")
	...s taskCheckerName=""
	...s counter=0,checkerPtr=0 f  s taskCheckerStatus=$listnext(taskCheckers,checkerPtr,taskChecker) q:taskCheckerStatus'=1  d
	....s checkerGlo=$g(^CF.DHCINM.HR.PersonsD(taskChecker))
	....s checkerName=$lg(checkerGlo,2)
	....i counter=0 s taskCheckerName=checkerName
	....e  s taskCheckerName=taskCheckerName_","_checkerName
	...s taskLevel=$lg(taskGlo,8)
	...s taskLevelDesc=$case(taskLevel,"W":"病区","L":"科室","H":"护理部",:"")
	...s taskItemList=$lg(taskGlo,2)
	...s taskWardList=$lg(taskGlo,6)
	...s itemPtr=0 f  s itemStatus=$listnext(taskItemList,itemPtr,taskItem) q:itemStatus'=1  d
	....s taskItemDesc=$p(taskItem,"「")
	....s taskItemId=$p(taskItem,"「",2)
	....q:(qual'="")&&(qual'=taskItemId)
	....s wardPtr=0 f  s wardStatus=$listnext(taskWardList,wardPtr,taskWard) q:wardStatus'=1  d
	.....q:(ward'="")&&(ward'=taskWard)
	.....s wardGlo=$g(^CF.DHCINM.DB.MgWardD(taskWard))
	.....s taskWardDesc=$lg(wardGlo,4)
	.....s resultId=$o(^DHCINM.CHK.MgCheckResultI("Ward",taskId,taskItemId,taskWard,""))
	.....s checkStatusDesc="",checkDate=""
	.....i (resultId="")||($d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1) s checkStatusDesc="未检查"
	.....e  d
	......s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	......s resultStatus=$lg(resultGlo,7)
	......s:resultStatus'="S" checkStatusDesc="已保存"
	......s checkDate=$lg(resultGlo,24)
	......q:resultStatus'="S"
	......i checkDate>taskEndDate s checkStatusDesc="超期检查"
	......e  s checkStatusDesc="已检查"
	.....s ret="TaskStDate|"_$zd(taskStDate,3)_"^TaskEndDate|"_$zd(taskEndDate,3)_"^CheckDate|"_$select(checkDate>0:$zd(checkDate,3),1:"")_"^TaskWayDesc|"_taskSourceDesc_"^QualType|"_$tr(type,"|","_")
	.....s ret=ret_"^QualTypeDesc|"_taskTypeDesc_"^TaskLevel|"_taskLevel_"^TaskLevelDesc|"_taskLevelDesc_"^QualItem|"_taskItemId_"^QualItemDesc|"_taskItemDesc_"^Ward|"_taskWard
	.....s ret=ret_"^WardDesc|"_taskWardDesc_"^Checker|"_taskCheckerId_"^CheckerName|"_taskCheckerName_"^CheckStatusDesc|"_checkStatusDesc_"^TaskId|"_taskId
	.....d OutFinishList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutFinishList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualFinDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualFinDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQualFinDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualFinDtlExecute ]
{
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

/// Creator: wangpf
/// Createdate: 2021-04-13
/// Description: 获取鱼骨图节点
/// Table: DHCINM.CHK.MgFishBone
/// Input：结果Id 根节点描述
/// Output:
/// Other: w ##class(web.INMQualControlComm).GetFishData(46,"ceshi")
ClassMethod GetFishData(resultId As %String = "", ques As %String = "") As %String
{
	q:resultId="" "[]"
	s par=$o(^DHCINM.CHK.MgFishBoneI("Result",resultId,""))
	i par=""{
		s flag=1
		ts
		s fishObj=##class(DHCINM.CHK.MgFishBone).%New()
		d fishObj.ResultSetObjectId(resultId)
		s fishObj.QuesDesc=ques
		s sc=fishObj.%Save()
		i $$$ISOK(sc){
			k tmp
			s tmp(1,"Desc1")="护理人员原因"
			s tmp(2,"Desc1")="病人情况原因"
			s tmp(3,"Desc1")="设备原因"
			s tmp(4,"Desc1")="工作环境原因"
			s tmp(5,"Desc1")="物品原因"
			s tmp(6,"Desc1")="其他原因"
			s quesId=$o(^DHCINM.CHK.MgCheckQuesI("Result",resultId,""))
			s quesObj=##class(DHCINM.CHK.MgCheckQues).%OpenId(quesId)
			i $IsObject(quesObj){
				s tmp(1,"Desc2")=quesObj.QuesNurRea
				s tmp(2,"Desc2")=quesObj.QuesPatRea
				s tmp(3,"Desc2")=quesObj.QuesDeviceRea
				s tmp(4,"Desc2")=quesObj.QuesWorkRea
				s tmp(5,"Desc2")=quesObj.QuesGoodsRea
				s tmp(6,"Desc2")=quesObj.QuesOtherRea
			}
			s id="" f  s id=$o(tmp(id)) q:(id="")||(flag'=1)  d
			.s subObj=##class(DHCINM.CHK.MgFishBoneSub).%New()
			.s subObj.Parref=fishObj
			.s subObj.SubDesc=tmp(id,"Desc1")
			.s subObj.SubSort=id_".0"
			.s subObj.SubPrimary="N"
			.s sc=subObj.%Save()
			.i $$$ISERR(sc) s flag=0 q
			.q:'$d(tmp(id,"Desc2"))
			.s desc=$tr(tmp(id,"Desc2"),";","；")
	        .s len=$l(desc,"；")
	        .s k=1
	        .f j=1:1:len q:flag'=1  d
	        ..s tDesc=$p(desc,"；",j)
	        ..q:tDesc=""
	        ..s subObj2=##class(DHCINM.CHK.MgFishBoneSub).%New()
	        ..s subObj2.Parref=fishObj
	        ..s subObj2.SubDesc=tDesc
	        ..s subObj2.SubParent=subObj
	        ..s subObj2.SubSort=id_".0."_k
	        ..s k=k+1
	        ..s subObj.SubPrimary="N"
	        ..s sc=subObj2.%Save()
	        ..i $$$ISERR(sc) s flag=0

		}else {
			s flag=0
		}
		i flag=1{
			s par=fishObj.%Id()
			tc
		}else {
			tro
			q "[]"
		}
	}
	
	k @"tmp"
	s fishObj=##class(DHCINM.CHK.MgFishBone).%OpenId(par)
	q:'$IsObject(fishObj) "[]"
	s @"tmp(0)"="{""id"":"""_par_""",""k"":""0"",""name"":"""_fishObj.QuesDesc_""",""path"":""."",""rate"":""N""}"
	s rowid="" f  s rowid=$O(^DHCINM.CHK.MgFishBoneSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCINM.CHK.MgFishBoneSub).%OpenId(par_"||"_rowid)
	.q:'$IsObject(obj)
	.s subDesc=obj.SubDesc
	.s subPar=obj.SubParent
	.s subSort=obj.SubSort
	.q:subSort=""
	.s path="./0"
	.i $l(subSort,".")>2 d
	..f i=2:1:($l(subSort,".")-1) d
	...s path=path_"/"_$p(subSort,".",1,i)
	.s subPrimary=obj.SubPrimary
	.s @("tmp("_$tr(subSort,".",",")_")")="{""id"":"""_par_"||"_rowid_""",""k"":"""_subSort_""",""name"":"""_subDesc_""",""path"":"""_path_""",""rate"":"""_subPrimary_"""}"
	
	w "["
	s string="tmp("""")" f  s string=$q(@string) q:string=""  d
	.w @string
	.w:$q(@string)'="" ","
	w "]"
	q ""
}

/// Creator: wangpf
/// Createdate: 2021-04-13
/// Description: 保存鱼骨图节点
/// Table: DHCINM.CHK.MgFishBoneSub
/// Input：父节点Id^父节点Sort^描述 update Flag
/// Output:
/// Other: w ##class(web.INMQualControlComm).SaveFishSub("2||1^1.0^ccccc",0)
ClassMethod SaveFishSub(parr As %String = "", update As %String = "") As %String
{
	q:parr="" 0
	s parId=$p(parr,"^")
	s parSort=$p(parr,"^",2)
	s desc=$p(parr,"^",3)
	s primary=$p(parr,"^",4)
	q:(parId="")||(parSort="") 0
	q:'$d(^DHCINM.CHK.MgFishBoneD(+parId)) 0
	
	i update=1 {
		s subObj=##class(DHCINM.CHK.MgFishBoneSub).%OpenId(parId)
		q:'$IsObject(subObj) 0
		s subObj.SubDesc=desc
		s subObj.SubPrimary=primary
		s sc=subObj.%Save()
		q:$$$ISERR(sc) 0
		q 1
	}
	
	k @"tmp"
	s rowid="" f  s rowid=$O(^DHCINM.CHK.MgFishBoneSubD(+parId,rowid)) q:rowid=""  d
	.s obj=##class(DHCINM.CHK.MgFishBoneSub).%OpenId(+parId_"||"_rowid)
	.q:'$IsObject(obj)
	.s subSort=obj.SubSort
	.q:subSort=""
	.s @("tmp("_$tr(subSort,".",",")_")")=+parId_"||"_rowid
	
	s flag=1
	i parSort=0 {
		s subSort=+$replace($q(@"tmp("""")",-1),"tmp(","")
		q:subSort=0 0
		s subSort=subSort+1_".0"
		s subObj=##class(DHCINM.CHK.MgFishBoneSub).%New()
		d subObj.ParrefSetObjectId(+parId)
		s subObj.SubSort=subSort
		s subObj.SubDesc=desc
		s subObj.SubPrimary=primary
		s flag=subObj.%Save()
	}else {
		s subSort=$o(@("tmp("_$tr(parSort,".",",")_","""")"),-1)
		s subSort=parSort_"."_(subSort+1)
		s subObj=##class(DHCINM.CHK.MgFishBoneSub).%New()
		d subObj.ParrefSetObjectId(+parId)
		d subObj.SubParentSetObjectId(parId)
		s subObj.SubSort=subSort
		s subObj.SubDesc=desc
		s subObj.SubPrimary=primary
		s flag=subObj.%Save()
	}
	i $$$ISOK(flag){
		q 1
	}else {
		q 0
	}
}

/// Creator: wangpf
/// Createdate: 2021-04-13
/// Description: 删除鱼骨图节点
/// Table: DHCINM.CHK.MgFishBoneSub
/// Input：id
/// Output:
/// Other: w ##class(web.INMQualControlComm).DelFishSub("2||1")
ClassMethod DelFishSub(id As %String = "") As %String
{
	q:id="" 0
	s flag=1
	ts
	s sc=##class(DHCINM.CHK.MgFishBoneSub).%DeleteId(id)
	s flag=$$$ISOK(sc)
	s rowid="" f  s rowid=$O(^DHCINM.CHK.MgFishBoneSubD("Par",id,+id,rowid)) q:(rowid="")||(flag'=1)  d
	.s sc=##class(DHCINM.CHK.MgFishBoneSub).%DeleteId(+id_"||"_rowid)
	.s flag=$$$ISOK(sc)
	i flag=1{
		tc
		q 1
	}else {
		tro
		q 0
	}
}

/// Description：获取考核结果合格率列表
/// Date:2021-06-18
/// Creator:wangpf
/// Table:DHCINM.CHK.MgCheckResult
/// Input: 病区^检查方式^质控类型^质控项目^频率^开始日期^季度/半年^结束日期^季度/半年 详情Flag 登录人Id
/// Output:考核结果合格率列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindCheckPass","^^^^Q^2021-01-01^1^2022-01-01^4",0,0)
Query FindCheckPass(parr As %String = "", flag As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckPassExecute(ByRef qHandle As %Binary, parr As %String = "", flag As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s type=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s freq=$p(parr,"^",5)
	s stDate=$p(parr,"^",6)
	s stDateSec=$p(parr,"^",7)
	s endDate=$p(parr,"^",8)
	s endDateSec=$p(parr,"^",9)
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))||(freq="")||(stDate="")||(endDate="")||(((freq="Q")||(freq="H"))&&((stDateSec="")||(endDateSec="")))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i stDate'="" d
	.i freq="D" s stDate=$zdh(stDate,3)
	.e  i freq="M" s stDate=$zdh($e(stDate,1,7)_"-01",3)
	.e  i freq="Q" d
	..i stDateSec=1 s stDate=$zdh(+stDate_"-01-01",3)
	..e  i stDateSec=2 s stDate=$zdh(+stDate_"-04-01",3)
	..e  i stDateSec=3 s stDate=$zdh(+stDate_"-07-01",3)
	..e  i stDateSec=4 s stDate=$zdh(+stDate_"-10-01",3)
	.e  i freq="H" d
	..i stDateSec=1 s stDate=$zdh(+stDate_"-01-01",3)
	..e  i stDateSec=2 s stDate=$zdh(+stDate_"-07-01",3)
	.e  s stDate=$zdh(+stDate_"-01-01",3)
	i endDate'="" d
	.i freq="D" s endDate=$zdh(endDate,3)
	.e  i freq="M" s endDate=$SYSTEM.SQL.LASTDAY($e(endDate,1,7)_"-01")
	.e  i freq="Q" d
	..i endDateSec=1 s endDate=$SYSTEM.SQL.LASTDAY(+endDate_"-01-01")
	..e  i endDateSec=2 s endDate=$SYSTEM.SQL.LASTDAY(+endDate_"-04-01")
	..e  i endDateSec=3 s endDate=$SYSTEM.SQL.LASTDAY(+endDate_"-07-01")
	..e  i endDateSec=4 s endDate=$SYSTEM.SQL.LASTDAY(+endDate_"-10-01")
	.e  i freq="H" d
	..i endDateSec=1 s endDate=$SYSTEM.SQL.LASTDAY(+endDate_"-01-01")
	..e  i endDateSec=2 s endDate=$SYSTEM.SQL.LASTDAY(+endDate_"-07-01")
	.e  s endDate=$SYSTEM.SQL.LASTDAY(+endDate_"-12-01")
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmpDate
	s date=stDate
	while(date<=endDate){
		i freq="D" s tmpDate($zd(date,3))=""
		e  s tmpDate($e($zd(date,3),1,7))=""
		i freq="D" s date=date+1
		e  i freq="M" s date=$SYSTEM.SQL.DATE($SYSTEM.SQL.DATEADD("m",1,date))
		e  i freq="Q" s date=$SYSTEM.SQL.DATE($SYSTEM.SQL.DATEADD("q",1,date))
		e  i freq="H" s date=$SYSTEM.SQL.DATE($SYSTEM.SQL.DATEADD("m",6,date))
		e  s date=$SYSTEM.SQL.DATE($SYSTEM.SQL.DATEADD("yyyy",1,date))
	}
	
	k tmpScore,tmpItem,tmpWardDesc,tmpScoreDtl
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.q:(stDate>checkDate)||(endDate<checkDate)
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))||((ward'="")&&(ward'=checkWard))
	..s checkWardGlo=$g(^CF.DHCINM.DB.MgWardD(checkWard))
	..s checkWardDesc=$lg(checkWardGlo,4)
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...q:(qual'="")&&(checkItem'=qual)
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s checkItemDesc=$lg(checkItemGlo,4)
	...s checkItemPass=$lg(checkItemGlo,13)
	...q:+checkItemPass=0
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultD(resultId))#2'=1
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s resultType=$lg(resultGlo,4)
	....q:(type'="")&&(type'=resultType)
	....s taskId=$lg(resultGlo,3)
	....s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	....s taskSourceDesc=""
	....i taskGlo'="" d
	.....i checkItemDesc="" d
	......s taskQualItemList=$lg(taskGlo,2)
	......s flag=0
	......s ptr=0 f  s status=$listnext(taskQualItemList,ptr,taskQualItem) q:(status'=1)||(flag=1)  d
	.......s taskQualItemDesc=$p(taskQualItem,"「")
	.......s taskQualItemId=$p(taskQualItem,"「",2)
	.......q:checkItem'=taskQualItemId
	.......s checkItemDesc=taskQualItemDesc
	.......s flag=1
	.....s taskIsRandom=$lg(taskGlo,15)
	.....i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.....e  d
	......s taskType=$lg(taskGlo,3)
	......q:(taskType="")
	......s taskTypePar=$p(taskType,"||")
	......s taskTypeSub=$p(taskType,"||",2)
	......q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	......s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	......s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	......i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	......e  s taskSourceDesc="质控任务"
	....q:((way=1)&&(taskSourceDesc'="质控任务"))||((way=2)&&(taskSourceDesc'="质控排班"))||((way=3)&&(taskSourceDesc'="随机检查"))
	....s resultScore=$lg(resultGlo,6)
	....s scoreType=$lg(resultGlo,13)
	....s:'$d(tmpItem(checkItem)) tmpItem(checkItem)=checkItemDesc
	....s tmpItem(checkItem,"type")=scoreType
	....s tmpWardDesc(checkWard)=checkWardDesc
	....i freq="D" s targetDate=$zd(checkDate,3)
	....e  i freq="M" s targetDate=$e($zd(checkDate,3),1,7)
	....e  i freq="Q" d
	.....s checkYear=+$zd(checkDate,3)_"-01-01"
	.....s quarter=$SYSTEM.SQL.QUARTER(checkDate)
	.....s targetDate=$e($SYSTEM.SQL.DATEADD("q",quarter-1,checkYear),1,7)
	....e  i freq="H" d
	.....s checkYear=+$zd(checkDate,3)_"-01-01"
	.....s quarter=$SYSTEM.SQL.QUARTER(checkDate)
	.....s quarter=$select(quarter<3:0,1:2)
	.....s targetDate=$e($SYSTEM.SQL.DATEADD("q",quarter,checkYear),1,7)
	....e  s targetDate=$e($zd(checkDate,3),1,4)_"-01"
	....s tmpScore(checkItem,targetDate,"counter")=$g(tmpScore(checkItem,targetDate,"counter"))+1
	....s tmpScoreDtl(checkItem,targetDate,checkWard,"counter")=$g(tmpScoreDtl(checkItem,targetDate,checkWard,"counter"))+1
	....q:$fn(resultScore,"")<checkItemPass
	....s tmpScore(checkItem,targetDate)=$g(tmpScore(checkItem,targetDate))+1
	....s tmpScoreDtl(checkItem,targetDate,checkWard)=$g(tmpScoreDtl(checkItem,targetDate,checkWard))+1
	
	i flag=1 {
		s resultItem="" f  s resultItem=$o(tmpScoreDtl(resultItem)) q:resultItem=""  d
		.s qualItemDesc=tmpItem(resultItem)
		.s targetDate="" f  s targetDate=$o(tmpScoreDtl(resultItem,targetDate)) q:targetDate=""  d
		..i freq="D" s targetDateDesc=targetDate
		..e  i freq="M" s targetDateDesc=$e(targetDate,1,7)
		..e  i freq="Q" s targetDateDesc=+targetDate_"年第"_$SYSTEM.SQL.QUARTER(targetDate)_"季度"
		..e  i freq="H" s targetDateDesc=+targetDate_"年"_$select($SYSTEM.SQL.QUARTER(targetDate)<3:"上半年",1:"下半年")
		..e  s targetDateDesc=+targetDate_"年"
		..s resultWard="" f  s resultWard=$o(tmpScoreDtl(resultItem,targetDate,resultWard)) q:resultWard=""  d
		...s ret="QualItem|"_resultItem_"^QualItemDesc|"_qualItemDesc_"^Date|"_targetDateDesc_"^Ward|"_resultWard
		...s ret=ret_"^WardDesc|"_tmpWardDesc(resultWard)_"^CheckCount|"_tmpScoreDtl(resultItem,targetDate,resultWard,"counter")
		...s ret=ret_"^PassCount|"_+$g(tmpScoreDtl(resultItem,targetDate,resultWard))
		...s ret=ret_"^PassRatio|"_($fn((+$g(tmpScoreDtl(resultItem,targetDate,resultWard)))/tmpScoreDtl(resultItem,targetDate,resultWard,"counter"),"",4)*100)_"%"
		...d OutList
	}else {
		s resultItem="" f  s resultItem=$o(tmpItem(resultItem)) q:resultItem=""  d
		.s ret="QualItem|"_resultItem_"^QualItemDesc|"_tmpItem(resultItem)
		.s targetDate="" f  s targetDate=$o(tmpDate(targetDate)) q:targetDate=""  d
		..i $d(tmpScore(resultItem,targetDate)) d
		...s ret=ret_"^"_targetDate_"|"_($fn($g(tmpScore(resultItem,targetDate))/tmpScore(resultItem,targetDate,"counter"),"",4)*100)_"%"
		..e  d
		...s ret=ret_"^"_targetDate_"|"
		.d OutList
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckPassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckPassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPassExecute ]
{
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

/// Description：查询质控项目层级
/// Date:2021-10-19
/// Creator:wangpf
/// Table: CT.DHCINM.DB.MgQualItem
/// Input:id
/// Output:质控项目层级
/// Other:d ##class(web.INMQualControlComm).GetQualLevel(97)
ClassMethod GetQualLevel(id As %String = "") As %String
{
	q:id="" ""
	
	s level=0
	s subId="" f  s subId=$o(^CT.DHCINM.DB.MgQualItemSubD(id,subId)) q:subId=""  d
	.q:$d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_id_"||"_subId))
	.s subGlo=^CT.DHCINM.DB.MgQualItemSubD(id,subId)
	.s subSort=$lg(subGlo,6)
	.s subLevel=$l(subSort,".")-1
	.s:subLevel>level level=subLevel
	
	w "["
	f i=1:1:level d
	.w "{""Level"":"""_i_""",""LevelDesc"":"""_i_"级""}"_$case(i,level:"",:",")
	w "]"
	q ""
}

/// Description：保存重点问题列表
/// Date:2022-06-23
/// Creator:lulin
/// Table:
/// Input: 
/// Output:
/// Other:w ##class(web.INMQualControlComm).SaveFocusQues("44^2^2022-06-01^2022-06-30^N^^测试^0",0)
ClassMethod SaveFocusQues(parr As %String = "", nurseid As %String = "") As %String
{
	s Qual=$P(parr,"^",1)
	s KeyQuesWard=$P(parr,"^",2)
	s KeyQuesStDate=$P(parr,"^",3)
	s KeyQuesEndDate=$P(parr,"^",4)
	s status=$P(parr,"^",5)
	s rw=$P(parr,"^",6)
	s KeyQuesDesc=$P(parr,"^",7)
	s KeyQuesRate=$P(parr,"^",8)
	i KeyQuesStDate'="" d
	.s KeyQuesStDate=$zdh(KeyQuesStDate,3)
	e  s KeyQuesStDate=""
	i KeyQuesEndDate'="" d
	.s KeyQuesEndDate=$zdh(KeyQuesEndDate,3)
	e  s KeyQuesEndDate=""
	q:((KeyQuesStDate="")||(KeyQuesEndDate="")) "日期不能为空"
	q:(KeyQuesStDate>KeyQuesEndDate) "开始日期不能大于结束日期"
	q:Qual="" "请选择质控项目"
	s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(Qual))
	q:checkItemGlo="" "未找到对应质控项目"
	k tmpSub
	s tmpSub=""
	//Date On (CheckDate, CheckStatus, CheckWard, CheckItem);
	f date=KeyQuesStDate:1:KeyQuesEndDate  d
	.f wardIndex=1:1:$L(KeyQuesWard,",") d
	..s wardID=$P(KeyQuesWard,",",wardIndex)
	..q:wardID=""
	..s resultID="" f  s resultID=$O(^DHCINM.CHK.MgCheckResultI("Date",date," S",wardID,Qual,resultID)) q:resultID=""  d
	...s resultGlo=^DHCINM.CHK.MgCheckResultD(resultID)
	...s resultType=$lg(resultGlo,4)
	...s scoreType=$lg(resultGlo,13)
	...s scoreTypeSub=$lg(resultGlo,14)
	...s resultSubID="" f  s resultSubID=$O(^DHCINM.CHK.MgCheckResultSubD(resultID,resultSubID)) q:resultSubID=""  d
	....q:$d(^DHCINM.CHK.MgCheckResultSubI("Par",resultID_"||"_resultSubID)) ;只要末端节点
	....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultID,resultSubID))
	....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultID,resultSubID)
	....s SubReference=$lg(resultSubGlo,7)
	....q:SubReference=""
	....s tmpSub("count",SubReference)=$g(tmpSub("count",SubReference))+1
	....s resultSubScore=$lg(resultSubGlo,3)
	....q:((resultSubScore="")||((resultSubScore=0)&&($lg(checkItemGlo,8)=4)))
	....s subStandardScore=$lg(resultSubGlo,5)
	....q:(scoreType=2)&&(subStandardScore="")
	....s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	....q:deductFlag'=1
	....s tmpSub("err",SubReference)=$g(tmpSub("err",SubReference))+1
	s errorRet=""
	s exitFlag=0
	s qualSubID="" f  s qualSubID=$O(tmpSub("err",qualSubID)) q:qualSubID=""  d
	.s count=$g(tmpSub("count",qualSubID))
	.s err=$g(tmpSub("err",qualSubID))
	.s tRate=$fn(err/count*100,"",2)
	.q:tRate<KeyQuesRate
	.s tmpSub("rate",qualSubID)=tRate
	.s exitFlag=1
	q:exitFlag=0 "无此错误率之上数据"
	TS
	i rw="" d
	.s obj=##class(DHCINM.CHK.MgFocusQues).%New()
	.s obj.Creator=nurseid
	e  d
	.s obj=##class(DHCINM.CHK.MgFocusQues).%OpenId(rw)
	.s:obj.Creator'=nurseid errorRet= "非本人不可修改"
	.s:obj.KeyQuesStatus'="N" errorRet="非保存状态,不可修改"
	s obj.KeyQuesDesc=KeyQuesDesc
	s obj.Qual=Qual
	s obj.KeyQuesWard=KeyQuesWard
	s obj.KeyQuesStDate=KeyQuesStDate
	s obj.KeyQuesEndDate=KeyQuesEndDate
	s obj.KeyQuesStatus=status
	s obj.KeyQuesRate=KeyQuesRate
	s sc=$$$ISOK(obj.%Save())
	if 'sc{
		TRO
		q "保存失败"	
	}
	s subId="" f  s subId=$O(^DHCINM.CHK.MgFocusQuesSubD(obj.%Id(),subId)) q:((subId="")||('sc))  d
	.s sc=$$$ISOK(##class(DHCINM.CHK.MgFocusQuesSub).%DeleteId(obj.%Id(),subId))
	if 'sc{
		TRO
		q "删除老数据失败"	
	}
	s qualSubID="" f  s qualSubID=$O(tmpSub("rate",qualSubID)) q:((qualSubID="")||('sc))  d
	.s CheckNum=$g(tmpSub("count",qualSubID))
	.s ErrNum=$g(tmpSub("err",qualSubID))
	.s rate=$g(tmpSub("rate",qualSubID))
	.s subObj=##class(DHCINM.CHK.MgFocusQuesSub).%New()
	.s QuesDesc=$lg($g(^CT.DHCINM.DB.MgQualItemSubD($P(qualSubID,"||",1),$P(qualSubID,"||",2))),2)
	.s subObj.QuesDesc=QuesDesc
	.s subObj.Parref=obj
	.s subObj.QualSubID=qualSubID
	.s subObj.CheckNum=CheckNum
	.s subObj.ErrNum=ErrNum
	.s subObj.ErrRate=rate
	.s sc=$$$ISOK(subObj.%Save())
	if 'sc{
		TRO
		q "保存子数据失败"	
	}
	TC
	q 1
}

/// Description：获取重点问题列表
/// Date:2022-06-23
/// Creator:lulin
/// Table:
/// Input: 
/// Output:
/// Other:w ##class(web.INMQualControlComm)GetFocusQues(1)
ClassMethod GetFocusQues(rw) As %String
{
	s objLB=$g(^DHCINM.CHK.MgFocusQuesD(rw))
	s KeyQuesDesc=$lg(objLB,2)
	s Qual=$lg(objLB,3)
	s QualDesc=""
	s:Qual'="" QualDesc=$lg($g(^CT.DHCINM.DB.MgQualItemD(Qual)),4)
	s KeyQuesWard=$lg(objLB,4),KeyQuesWardDesc=""
	f i=1:1:$L(KeyQuesWard,",") d
	.s wardID=$P(KeyQuesWard,",",i)
	.q:wardID=""
	.s wardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(wardID)),4)
	.i KeyQuesWardDesc="" s KeyQuesWardDesc=wardDesc
	.e  s KeyQuesWardDesc=KeyQuesWardDesc_","_wardDesc 
	
	s KeyQuesStDate=$lg(objLB,5)
	s KeyQuesStDate=$zd(KeyQuesStDate,3)
	s KeyQuesEndDate=$lg(objLB,6)
	s KeyQuesEndDate=$zd(KeyQuesEndDate,3)
	s KeyQuesStatus=$lg(objLB,7)
	s KeyQuesStatusDesc=$case(KeyQuesStatus,"N":"保存","Y":"已提交","B":"驳回","S":"已审核",:"")
	s Creator=$lg(objLB,8),CreatorDesc=""
	i Creator=0 d
	.s CreatorDesc="系统管理员"
	e  d
	.s CreatorDesc=$lg($g(^CF.DHCINM.DB.MgUserD(Creator)),2)
	s RejectInfo=$lg(objLB,9)
	s RejectInfo=$LTS(RejectInfo,"」")
	s RejectUser=$lg(objLB,10),RejectUserDesc=""
	i RejectUser'="" d
	.i RejectUser=0 d
	..s RejectUserDesc="系统管理员"
	.e  d
	..s RejectUserDesc=$lg($g(^CF.DHCINM.DB.MgUserD(RejectUser)),2)
	s KeyQuesRate=$lg(objLB,11)
	s ret="rw|"_rw_"^KeyQuesDesc|"_KeyQuesDesc_"^Qual|"_Qual_"^QualDesc|"_QualDesc
	_"^KeyQuesWard|"_KeyQuesWard_"^KeyQuesWardDesc|"_KeyQuesWardDesc_"^KeyQuesStDate|"_KeyQuesStDate
	_"^KeyQuesEndDate|"_KeyQuesEndDate_"^KeyQuesStatus|"_KeyQuesStatus_"^KeyQuesStatusDesc|"_KeyQuesStatusDesc
	_"^Creator|"_Creator_"^CreatorDesc|"_CreatorDesc_"^RejectInfo|"_RejectInfo_"^RejectUser|"_RejectUser
	_"^RejectUserDesc|"_RejectUserDesc_"^KeyQuesRate|"_KeyQuesRate
	q ret
}

/// Description：删除重点问题列表
/// Date:2022-06-23
/// Creator:lulin
/// Table:
/// Input: 
/// Output:
/// Other:
ClassMethod DelFocusQues(rw As %String = "", nurseid As %String = "") As %String
{
	q:rw="" "入参为空,请刷新重试"
	s obj=##class(DHCINM.CHK.MgFocusQues).%OpenId(rw)
	q:'$IsObject(obj) "未找到对象,请刷新重试"
	q:obj.Creator'=nurseid "非创建者不可删除"
	q:obj.KeyQuesStatus'="N" "非保存状态不可删除"
	d obj.%DeleteId(rw)
	
	q 1
}

/// Description：获取重点问题列表
/// Date:2022-06-23
/// Creator:lulin
/// Table:
/// Input: 状态 开始日期  结束日期
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindFocusQues","^^",0)
Query FindFocusQues(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindFocusQuesExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmpWard=""
	s status=$P(parr,"^",1)
	s stDate=$P(parr,"^",2)
	s endDate=$P(parr,"^",2)
	s:stDate'="" stDate=$zdh(stDate,3)
	s:endDate'="" endDate=$zdh(endDate,3)
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s KeyQuesStDate="" f  s KeyQuesStDate=$O(^DHCINM.CHK.MgFocusQuesI("date",KeyQuesStDate)) q:(KeyQuesStDate="")  d
	.q:((endDate'="")&&(KeyQuesStDate>endDate))
	.s id="" f  s id=$O(^DHCINM.CHK.MgFocusQuesI("date",KeyQuesStDate,id)) q:((KeyQuesStDate="")||(id=""))  d
	..s objLB=$g(^DHCINM.CHK.MgFocusQuesD(id))
	..q:objLB=""
	..s Creator=$lg(objLB,8)
	..s KeyQuesStatus=$lg(objLB,7)
	..s KeyQuesEndDate=$lg(objLB,6)
	..q:((status'="")&&(status'=KeyQuesStatus))
	..q:((stDate'="")&&(KeyQuesEndDate>stDate))
	..q:((KeyQuesStatus="N")&&(Creator'=nurseid))
	..s isAllInWard=1
	..i ((isAll'=1)&&(Creator'=nurseid)) d
	...s KeyQuesWard=$lg(objLB,4)
	...f wardIndex=1:1:$L(KeyQuesWard,",") q:isAllInWard'=1  d
	....s wardID=$P(KeyQuesWard,",",wardIndex)
	....q:wardID=""
	....s:'$d(tmpWard(wardID)) isAllInWard=0
	..q:isAllInWard'=1
	..s ret=..GetFocusQues(id)
	..d OutList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindFocusQuesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFocusQuesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFocusQuesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFocusQuesExecute ]
{
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

/// Description：获取重点问题列表
/// Date:2022-06-23
/// Creator:lulin
/// Table:
/// Input: 状态 开始日期  结束日期
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindFocusQues","^^",0)
Query LoadFocusQuesByID(id As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod LoadFocusQuesByIDExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmpWard=""
	if id=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s subID="" f  s subID=$O(^DHCINM.CHK.MgFocusQuesSubD(id,subID)) q:subID=""  d
	.s subObj=$g(^DHCINM.CHK.MgFocusQuesSubD(id,subID))
	.q:subObj=""
	.s QuesDesc=$lg(subObj,2)
	.s QualSubID=$lg(subObj,3)
	.s Result=$lg(subObj,4)
	.s Remark=$lg(subObj,5)
	.s CheckNum=$lg(subObj,6)
	.s ErrNum=$lg(subObj,7)
	.s ErrRate=$lg(subObj,8)
	.s ret="rw|"_id_"||"_subID_"^QuesDesc|"_QuesDesc_"^QualSubID|"_QualSubID_"^Result|"_Result_"^Remark|"_Remark
	.s ret=ret_"^CheckNum|"_CheckNum_"^ErrNum|"_ErrNum_"^ErrRate|"_ErrRate_"%"
	.d OutList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LoadFocusQuesByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadFocusQuesByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LoadFocusQuesByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadFocusQuesByIDExecute ]
{
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

/// Description:删除重点问题
/// Date:2021-12-26
/// Creator:lulin
/// Table:
/// Input:parr userid
/// Output
/// Other:w ##class(web.INMQualControlComm).SaveKeyQues()
ClassMethod DelFocusQuesSub(id As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") "入参不能为空"
	s obj=##class(DHCINM.CHK.MgFocusQuesSub).%OpenId(id)
	q:('$IsObject(obj)) "未找到对应数据,请刷新重试"
	q:(obj.Parref.Creator'=nurseid) "非创建者不可删除"
	d obj.%DeleteId(id)
	q 1
}

/// Description：提交，审核、驳回、重点问题
/// Date:2021-12-24
/// Creator:lulin
/// Table:
/// Input: 
/// Output:
/// Other:
ClassMethod AuditKeyQues(parr As %String = "", id As %String = "", nurseid As %String = "")
{
	s status=$P(parr,"「",1)
	s parr=$P(parr,"「",2,$L(parr,"「"))
	q:status="" "入参状态为空，请刷新重试"
	q:id="" "未找到操作对象,请刷新重试"
	s obj=##class(DHCINM.CHK.MgFocusQues).%OpenId(id)
	q:'$IsObject(obj) "未找到操作对象,请刷新重试"
	s statusDesc=$case(status,"B":"驳回","S":"审核","Y":"提交")
	q:(((status="B")||(status="C"))&&(obj.KeyQuesStatus'="Y")) "非已提交状态,不可"_statusDesc
	q:((status="Y")&&(obj.KeyQuesStatus'="N")&&(obj.KeyQuesStatus'="B")) "非保存状态,不可"_statusDesc
	q:((status="Y")&&(obj.Creator'=nurseid)) "非本人不可提交"
	s obj.KeyQuesStatus=status
	i ((status="B")||(status="S")){
		d obj.RejectInfo.Insert(parr)
		s obj.RejectUser=nurseid	
	}
	d obj.%Save()
	q obj.%Id()
}

/// Description：保存题目
/// Date:2021-12-24
/// Creator:lulin
/// Table:
/// Input: 
/// Output:
/// Other:
ClassMethod SaveFocusQuesItem(parr As %String = "", rw As %String = "")
{
	q:parr="" "入参不能为空"
	s obj=##class(DHCINM.CHK.MgFocusQuesSub).%OpenId(rw)
	q:'$IsObject(obj) "获取指标内容失败,请刷新重试"
	s obj.Result=$P(parr,"「",1)
	s obj.Remark=$P(parr,"「",2)
	d obj.%Save()
	q 1
}

/// Description:根据日期获取当天质控排班的质控类型
/// Date:2022-05-12
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:id
/// Output：1：是 0：否
/// Other:w ##class(web.INMQualControlComm).GetDateQaulType("2022-05-12")
ClassMethod GetDateQaulType(date As %String = "") As %String
{
 	q:date="" ""
 	s:date["-" date=$zdh(date,3)
 	
 	s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code"," QUALTYPE",""))
 	q:parId="" ""
 	
 	s weekday=$zd(date,10)
 	s year=+$zd(date,3)
 	i '$d(^CT.DHCINM.Set.MgNightSetD) {
 		k holidayTmp,workdayTmp
 		d ##class(web.INMArgComm).setHolidayTmp(year,.holidayTmp,0)
 		d ##class(web.INMArgComm).setHolidayTmp(year,.workdayTmp,1)
 		i $d(holidayTmp(date)){
 			s typeCode="HOLIDAYCHECK"
 		}elseif(((weekday=6)||(weekday=0))&&('$d(workdayTmp(date)))) {
 			s typeCode="WEEKCHECK"
 		}else {
 			s typeCode="NIGHTCHECK"
 		}
 		s subId=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," "_typeCode,parId,""))
 		q parId_"__"_subId
 	}else {
 		k holidayTmp
 		s code="" f  s code=$o(^CF.DHCINM.DB.MgHolidaySetI("code",year,code)) q:code=""  d
 		.s holId="" f  s holId=$o(^CF.DHCINM.DB.MgHolidaySetI("code",year,code,holId)) q:holId=""  d
 		..q:'$d(^CF.DHCINM.DB.MgHolidaySetD(holId))
 		..s holGlo=^CF.DHCINM.DB.MgHolidaySetD(holId)
 		..s codeId=$lg(holGlo,3)
 		..q:codeId=""
 		..s holDate=$lg(holGlo,4)
 		..s hstdate=$zdh($p(holDate,",",1),3)
 		..s henddate=$zdh($p(holDate,",",2),3)
 		..f hdate=hstdate:1:henddate d
 		...i '$d(holidayTmp(hdate)) s holidayTmp(hdate)=codeId
 		...e  s holidayTmp(hdate)=holidayTmp(hdate)_","_codeId
 		
 		s dateHoliday=$g(holidayTmp(date))
 		
 		s qual=""
 		s sort="" f  s sort=$o(^CT.DHCINM.Set.MgNightSetI("Sort",sort)) q:(qual'="")||(sort="")  d
 		.s setId="" f  s setId=$o(^CT.DHCINM.Set.MgNightSetI("Sort",sort,setId)) q:(qual'="")||(setId="")  d
 		..q:'$d(^CT.DHCINM.Set.MgNightSetD(setId))
 		..s setGlo=^CT.DHCINM.Set.MgNightSetD(setId)
 		..s holiday=$lg(setGlo,3)
 		..s week=$lg(setGlo,4)
 		..s exclude=$lg(setGlo,6)
 		..s excludeHoliday=$lf(exclude,"holiday")
 		..q:(holiday'="")&&excludeHoliday&&$lf(holiday,dateHoliday)
 		..q:(holiday'="")&&('excludeHoliday)&&('$lf(holiday,dateHoliday))
 		..s excludeWeek=$lf(exclude,"week")
 		..q:(week'="")&&excludeWeek&&$lf(week,weekday)
 		..q:(week'="")&&('excludeWeek)&&('$lf(week,weekday))
 		..s qual=$lg(setGlo,2)
 		
 		q $tr(qual,"|","_")
 	}
}

/// Description:根据工号获取是否是检查人
/// Date:2022-05-10
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:id
/// Output：1：是 0：否
/// Other:w ##class(web.INMQualControlComm).IsPerInChecker("demo")
ClassMethod IsPerInChecker(code As %String = "", taskId As %String = "") As %String
{
 	q:(code="")||(taskId="")||('$d(^DHCINM.CHK.MgQualCheckTaskD(taskId))) 0
 	s code=$zcvt(code,"U")
 	q:code="DEMO" 1_"^"_0
 	s perId=$O(^CF.DHCINM.HR.PersonsI("PerID"," "_code,""))
 	q:perId="" 0
 	s user=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
 	q:user="" 0
 	s flag=##class(web.INMLoginComm).IsNurInRoleForCode(user,"HLBZR,HLB",+$h)
 	q:flag=1 1_"^"_perId
 	s taskGlo=^DHCINM.CHK.MgQualCheckTaskD(taskId)
 	s checker=$lg(taskGlo,4)
 	q ($lf(checker,perId)>0)_"^"_perId
}

/// Description:驳回提交质控
/// Date:2022-05-10
/// Creator:wangpf
/// Table:DHCINM.CHK.MgQualCheckTask
/// Input:id
/// Output：
/// Other:
ClassMethod BackQualCheck(id As %String = "") As %String
{
 	q:id="" 0
 	q:$d(^DHCINM.CHK.MgCheckQuesI("Result",id)) "已填写质控问题汇总相关记录,不可驳回"
 	s obj=##class(DHCINM.CHK.MgCheckResult).%OpenId(id)
 	q:'$IsObject(obj) 0
 	s obj.CheckStatus="Y"
 	s sc=obj.%Save()
 	q $$$ISOK(sc)
}

/// Creator:liwenzhen
/// Createdate:2022-02-08 14:30:54
/// Description:
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMQualControlComm","FindPassRate","^^^234^2022-01^2022-03^1^234||1^L",0)
Query FindPassRate(parr As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindPassRateExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ward=$p(parr,"^")
	s way=$p(parr,"^",2)
	s checkType=$tr($p(parr,"^",3),"_","|")
	s qual=$p(parr,"^",4)
	s stDate=$p(parr,"^",5)
	s endDate=$p(parr,"^",6)
	s qualLevel=$p(parr,"^",7)
	s qualSub=$p(parr,"^",8)
	s findType=$p(parr,"^",9)
	s:findType="L" qualLevel=qualLevel+1
	i (qual="")||(stDate="")||(endDate="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s stQuarter=$SYSTEM.SQL.QUARTER(stDate_"-01") //开始月所在季度
	i stQuarter=1 d
	.s lastStdate=$zdh((+stDate-1)_"-10-01",3)
	.s lastEndDate=$zdh((+stDate-1)_"-12-31",3)
	e  d
	.s lastStMonth=3*stQuarter-2
	.s lastStdate=$zdh(+stDate_"-"_lastStMonth_"-01",3)
	.s lastEndDate=$SYSTEM.SQL.LASTDAY(+stDate_"-"_(lastStMonth+2)_"-01")
	s stDate=$zdh(stDate_"-01",3)
	s endDate=$SYSTEM.SQL.LASTDAY(endDate_"-01")
	
	s qualItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(qual))
	
	k tmpWard,tmp,tmpTotal,tmpSort
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s parref="" f  s parref=$o(^DHCINM.CHK.MgCheckResultSubI("Qual",parref)) q:parref=""  d
	.s checkGlo=$g(^DHCINM.CHK.MgCheckResultD(parref))
	.s wardDR=$lg(checkGlo,2)
	.q:(ward'="")&&(ward'=wardDR)
	.q:(isAll'=1)&&('$d(tmpWard(wardDR)))
	.q:$lg(checkGlo,5)'=qual
	.s checkDate=$lg(checkGlo,24)
	.q:(checkDate<lastStdate)||(checkDate>endDate)
	.s qualType=$lg(checkGlo,4)
	.q:(checkType'="")&&(checkType'=qualType)
	.s checkWay=""
	.s checkWay=..GetCheckWay($lg(checkGlo,3))
	.q:(way'="")&&(way'=checkWay)
	.s wardDesc=$lg(^CF.DHCINM.DB.MgWardD(wardDR),4)
	.s qualTypeDesc=$lg(^CT.DHCINM.Set.MgSysParamSubD($p(qualType,"||",1),$p(qualType,"||",2)),3)
	.s checkWayDesc=$case(checkWay,1:"质控任务",2:"质控排班",3:"随机检查",:"")
	.s type="pass"
	.s:(checkDate>=lastStdate)&&(checkDate<=lastEndDate) type="lastPass"
	.s qualItemSub="" f  s qualItemSub=$o(^DHCINM.CHK.MgCheckResultSubI("Qual",parref,qualItemSub)) q:qualItemSub=""  d
	..s checkSub="" f  s checkSub=$o(^DHCINM.CHK.MgCheckResultSubI("Qual",parref,qualItemSub,checkSub)) q:checkSub=""  d
	...s checkSubGlo=$g(^DHCINM.CHK.MgCheckResultSubD(parref,checkSub))
	...q:$o(^DHCINM.CHK.MgCheckResultSubI("Par",(parref_"||"_checkSub),""))'="" //只统计最后一级节点
	...s scoreType=$lg(checkGlo,13) // 按分值、按比例
	...s scoreTypeSub=$lg(checkGlo,14) // 打分类型
	...s subScore=$lg(checkSubGlo,3)
	...s subStandardScore=$lg(checkSubGlo,5) //标准分值
	...q:(scoreType=2)&&(subStandardScore="")
	...q:(scoreTypeSub=1)&&(subScore="-") //去除是否模式下未涉及质控条目
	...s sort=$lg(checkSubGlo,9)
	...s deductFlag=..IsQualSubDeduct(scoreType,scoreTypeSub,subScore,subStandardScore)
	...s targetQualItemSub=qualItemSub
	...s targetSort=sort
	...i qualLevel'=$l(sort,".") d
	....s targetSort=$p(sort,".",1)
	....s targetQualItemSub=""
	....f i=2:1:qualLevel+1 d
	.....s targetSort=targetSort_"."_$p(sort,".",i)
	....s targetCheckSubId=$o(^DHCINM.CHK.MgCheckResultSubI("Sort",parref," "_targetSort,""))
	....q:targetCheckSubId=""
	....s targetQualItemSub=$lg(^DHCINM.CHK.MgCheckResultSubD(parref,targetCheckSubId),7)
	...q:targetQualItemSub=""
	...i (qualSub'="")&&(findType="D") d
	....q:((qualSub'="")&&((qualSub'=targetQualItemSub)))||(type'="pass")||(deductFlag'="1")
	....;s tmpSort(sort,parref_"||"_checkSub,"QualItemSubDesc")=$lg(checkSubGlo,2)
	....;s tmpSort(sort,parref_"||"_checkSub,"CheckDate")=$zd(checkDate,3)
	....;s tmpSort(sort,parref_"||"_checkSub,"WardDesc")=wardDesc
	....;s tmpSort(sort,parref_"||"_checkSub,"CheckWayDesc")=checkWayDesc
	....;s tmpSort(sort,parref_"||"_checkSub,"QualTypeDesc")=qualTypeDesc
	....//合并问题项
	....s wardDescTmp=$g(tmpSort(sort,qualItemSub,"WardDesc"))
    ....s:wardDescTmp'="" tmpSort(sort,qualItemSub,"WardDesc")=wardDescTmp_","_wardDesc
	....s:wardDescTmp="" tmpSort(sort,qualItemSub,"WardDesc")=wardDesc
	....s tmpSort(sort,qualItemSub,"QualItemSubDesc")=$lg(checkSubGlo,2)
	....s tmpSort(sort,qualItemSub,"QuesWardNum")=$l($g(tmpSort(sort,qualItemSub,"WardDesc")),",")
	...q:(qualSub'="")&&(findType="D")
	...s targetQualPar=$lg(^CT.DHCINM.DB.MgQualItemSubD($p(targetQualItemSub,"||",1),$p(targetQualItemSub,"||",2)),5)
	...q:(qualSub'="")&&(qualSub'=targetQualPar)&&(findType="L") //层级分析下只统计对应条目
	...s:findType="L" targetQualItemSub=targetQualItemSub //层级分析统计下一级
	...s tmp(targetQualItemSub)=targetQualItemSub
	...s:deductFlag=0 tmp(targetQualItemSub,type)=$g(tmp(targetQualItemSub,type))+1
	...s tmp(targetQualItemSub,type_"Total")=$g(tmp(targetQualItemSub,type_"Total"))+1
	...s:deductFlag=0 tmpTotal(type)=$g(tmpTotal(type))+1
	...s tmpTotal(type_"Total")=$g(tmpTotal(type_"Total"))+1
	
	i (qualSub'="")&&(findType="D") d OutList Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s qualItemSub="" f  s qualItemSub=$o(tmp(qualItemSub)) q:qualItemSub=""  d
	.s curPass=$g(tmp(qualItemSub,"pass"),0),curPassTotal=$g(tmp(qualItemSub,"passTotal"),0) //当前检查例数
	.s questionNum=curPassTotal-curPass
	.q:(findType="L")&&(questionNum=0)
	.s curPassRate=""
	.s:curPassTotal'="" curPassRate=$fn(curPass/curPassTotal*100,"",2)
	.s lastPass=$g(tmp(qualItemSub,"lastPass"),0),lastPassTotal=$g(tmp(qualItemSub,"lastPassTotal")) //上季度检查例数
	.s lastPassRate=""
	.s:lastPassTotal'="" lastPassRate=$fn(lastPass/lastPassTotal*100,"",2)
	.s isDown=0
	.s:(curPassRate'="")&&(lastPassRate'="")&&(curPassRate<lastPassRate) isDown=1 //合格率是否下降
	.s qualItemSubGlo=$g(^CT.DHCINM.DB.MgQualItemSubD($p(qualItemSub,"||",1),$p(qualItemSub,"||",2)))
	.q:qualItemSubGlo=""
	.s qualItemSubDesc=$lg(qualItemSubGlo,2)
	.;s qualItemSort=$lg(qualItemSubGlo,6)
	.s tmpSort(questionNum,qualItemSub,"QualItemSub")=qualItemSub
	.s tmpSort(questionNum,qualItemSub,"QualItemSubDesc")=qualItemSubDesc
	.s tmpSort(questionNum,qualItemSub,"LastPass")=lastPass
	.s tmpSort(questionNum,qualItemSub,"LastPassTotal")=lastPassTotal
	.s tmpSort(questionNum,qualItemSub,"LastPassRate")=lastPassRate
	.s tmpSort(questionNum,qualItemSub,"Pass")=curPass
	.s tmpSort(questionNum,qualItemSub,"PassTotal")=curPassTotal
	.s tmpSort(questionNum,qualItemSub,"PassRate")=curPassRate
	.s tmpSort(questionNum,qualItemSub,"IsDown")=isDown
	
	s quetionTotal=$g(tmpTotal("passTotal"))-$g(tmpTotal("pass"))
	s count=0,ratioLast=0
	s questionNum="" f  s questionNum=$o(tmpSort(questionNum),-1) q:questionNum=""  d
	.s sub="" f  s sub=$o(tmpSort(questionNum,sub)) q:sub=""  d
	..s:quetionTotal=0 tmpSort(questionNum,sub,"QuesMain")="N"
	..q:quetionTotal=0
	..s count=count+questionNum
	..s ratio=$fn(count/quetionTotal,"",2)
	..i ratio>=0.8 d
	...s diff=ratio-0.8
	...s diffLast=0.8-ratioLast
	...s:diff<=diffLast tmpSort(questionNum,sub,"QuesMain")="Y" //设置是否主要问题
	...s:diff>diffLast tmpSort(questionNum,sub,"QuesMain")="N"
	..e  s tmpSort(questionNum,sub,"QuesMain")="Y"
	..s ratioLast=ratio
	
	d OutList
	d:findType="" OutTotal
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutList
	s sortType=1
	s:findType'="D" sortType=-1
	s questionNum="" f  s questionNum=$o(tmpSort(questionNum),sortType) q:questionNum=""  d
	.s sub="" f  s sub=$o(tmpSort(questionNum,sub)) q:sub=""  d
	..s ret=""
	..s:sortType=-1 ret="QuestionNum|"_questionNum
	..s prop="" f  s prop=$o(tmpSort(questionNum,sub,prop)) q:prop=""  d
	...s ret=ret_"^"_prop_"|"_$g(tmpSort(questionNum,sub,prop))
	..s Data=$lb(ret)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	q
OutTotal
	s ret="QualItemSubDesc|总计"
	s passTotal=$g(tmpTotal("passTotal"),0),pass=$g(tmpTotal("pass"),0)
	s lastPassTotal=$g(tmpTotal("lastPassTotal")),lastPass=$g(tmpTotal("lastPass"))
	s ret=ret_"^PassTotal|"_passTotal_"^Pass|"_pass
	s ret=ret_"^QuestionNum|"_(passTotal-pass)
	s passTotalRate="",lastPassTotalRate=""
	s:(passTotal'="")&&(passTotal'=0) passTotalRate=$fn(pass/passTotal*100,"",2)
	s:(lastPassTotal'="")&&(lastPassTotal'=0) lastPassTotalRate=$fn(lastPass/lastPassTotal*100,"",2)
	s isDown=0
	s:(passTotalRate'="")&&(lastPassTotalRate'="")&&(passTotalRate<lastPassTotalRate) isDown=1
	s ret=ret_"^PassRate|"_passTotalRate_"^LastPassRate|"_lastPassTotalRate_"^IsDown|"_isDown
	s Data=$lb(ret)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

/// Creator: liwenzhen
/// Createdate: 2022-03-03
/// Description: 根据任务id获取检查方式
/// Table: DHCINM.CHK.MgQualCheckTask
/// Input：id
/// Output:
/// Other: w ##class(web.INMQualControlComm).GetCheckWay("235")
ClassMethod GetCheckWay(taskId As %String = "") As %String
{
	s taskGlo=$g(^DHCINM.CHK.MgQualCheckTaskD(taskId))
	s taskSourceDesc=""
	i taskGlo'="" d
	.s taskIsRandom=$lg(taskGlo,15)
	.i taskIsRandom="Y" s taskSourceDesc="随机检查"
	.e  d
	..s taskType=$lg(taskGlo,3)
	..q:(taskType="")
	..s taskTypePar=$p(taskType,"||")
	..s taskTypeSub=$p(taskType,"||",2)
	..q:'$d(^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub))
	..s taskTypeGlo=^CT.DHCINM.Set.MgSysParamSubD(taskTypePar,taskTypeSub)
	..s taskTypeCode=$zcvt($lg(taskTypeGlo,2),"U")
	..i (taskTypeCode="NIGHTCHECK")||(taskTypeCode="WEEKCHECK")||(taskTypeCode="HOLIDAYCHECK") s taskSourceDesc="质控排班"
	..e  s taskSourceDesc="质控任务"
	s checkWay=$case(taskSourceDesc,"质控任务":1,"质控排班":2,"随机检查":3)
	q checkWay
}

/// Description:获取病区护士列表
/// Date:2020-09-28
/// Creator:wangpf
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output:病区护士列表
/// Other:w ##class(web.INMQualControlComm).FindWardNurseListForQual(1)
ClassMethod FindWardNurseListForQual(ward As %String = "", padFlag As %String = "") As %String [ WebMethod ]
{
	s dataKey="rows"
	s:padFlag=1 dataKey="data"
	s ret="{"""_dataKey_""":[],""total"":""0""}"
	i ward="" {
		i padFlag=1{
			q ret	
		}else{
			w ret
			q ""
		}
	}
	s wardLB=$LB()
	s locIndex=1
	s locID="" f  s locID=$O(^CF.DHCINM.DB.MgWardLocUnitI("Ward",ward,locID)) q:locID=""  d
	.q:locID=""
	.s locWardID="" f  s locWardID=$O(^CF.DHCINM.DB.MgWardLocUnitI("Loc",locID,locWardID)) q:locWardID=""  d
	..q:locWardID=""
	..s $li(wardLB,locIndex)=locWardID
	..s locIndex=locIndex+1
 	s ret="{"""_dataKey_""":[",count=0
 	s wardId="" f  s wardId=$o(^CF.DHCINM.HR.PersonsI("DepID",wardId)) q:wardId=""  d
 	.s tmpWard=$tr(wardId," ","")
 	.q:((tmpWard'=ward)&&($lf(wardLB,wardId)<1))
 	.k tmp
 	.s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsI("DepID",wardId,perId)) q:perId=""  d
 	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
 	..q:'$IsObject(obj)
 	..s perID=obj.PerID
 	..s PerName=obj.PerName
 	..s:perID'="" PerName=PerName_"("_perID_")"
 	..s:perID="" perID=" "
 	..s tmp(perID,perId)="{""Per"":"""_perId_""",""PerName"":"""_obj.PerName_"""}"
 	.s perID="" f  s perID=$o(tmp(perID)) q:perID=""  d
 	..s perId="" f  s perId=$o(tmp(perID,perId)) q:perId=""  d
 	...s ret=ret_$case(count,0:"",:",")_tmp(perID,perId)
 	...s count=count+1
 	
 	s ret=ret_"],""total"":"""_count_"""}"
 	i padFlag=1{
		q ret	
	}else{
		w ret
		q ""
	}
}

/// Description:护理部置批量完成
/// Date:2022年6月30日
/// Creator:lulin
/// Table:
/// Input:
/// Output
/// Other:
ClassMethod FinishQuesData(rws As %String = "", parr As %String = "", APPLoginID) As %String
{
	q:rws="" "入参不能为空"
	s sc=1
	f i=1:1:$L(rws,",")	q:'sc  d
	.s rw=$P(rws,",",i)
	.q:rw=""
	.s obj=##class(DHCINM.CHK.MgCheckQues).%OpenId(rw)
	.q:'$IsObject(obj)
	.s obj.QuesStatus="A"
	.s obj.QuesHLBView=parr
	.s obj.QuesHLBPer=APPLoginID
	.s obj.QuesHLBDate=+$H
	.d obj.%Save()
	q 1
}

}
