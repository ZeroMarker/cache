/// Creator:gzj
/// Date:2019-04-10
/// Description:质控统计类
Class web.NurMgQualStaticComm Extends %RegisteredObject
{

/// Creator:gzj
/// Description:获取质控项目
/// Date:2019-04-10
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualStaticComm","FindCheckStore","")
Query FindCheckStore(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckStoreExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s RowID="" f  s RowID=$o(^DHCNMG.DB.MgQualItemD(RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(RowID)
	.q:'$IsObject(obj)
	.s year=obj.QualYear
	.s desc=obj.QualDesc_year
	.s ItemSpell=##class(ext.util.String).ToChineseSpell(desc) //获取首字母拼写
	.s ret="ItemDesc|"_desc_"^ItemID|"_RowID_"^ItemSpell|"_ItemSpell
	.do OutputCheckStore
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheckStore
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckStoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckStoreExecute ]
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

ClassMethod FindCheckStoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckStoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取片区
/// Date:2019-04-10
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualStaticComm","FindAreaStore","")
Query FindAreaStore(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAreaStoreExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s code="" f  s code=$o(^DHCNMG.DB.MgWardAreaI("Code",code)) q:code=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgWardAreaI("Code",code,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgWardArea).%OpenId(RowID)
	..q:'$IsObject(obj)
	..s desc=obj.AreaDesc
	..s ret="AreaDesc|"_desc_"^AreaID|"_RowID
	..do OutputAreaStore
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputAreaStore
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAreaStoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAreaStoreExecute ]
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

ClassMethod FindAreaStoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAreaStoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:科室获取
/// Date:2019-04-10
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualStaticComm","FindLocStore","12")
Query FindLocStore(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindLocStoreExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s code="" f  s code=$o(^DHCNMG.DB.MgWardLocI("Code",code)) q:code=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgWardLocI("Code",code,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(RowID)
	..q:'$IsObject(obj)
	..s locCode=obj.LocCode
	..s locDesc=obj.LocDesc
	..s areaID=obj.LocAreaDR
	..q:((parr'="")&&($IsObject(areaID))&&(areaID.%Id()'=parr))
	..q:((parr'="")&&('$IsObject(areaID))&&(areaID'=parr))
	..s LocSpell=##class(ext.util.String).ToChineseSpell(locDesc) //获取科室名称首字母
	..s ret="LocDesc|"_locDesc_"^LocID|"_RowID_"^LocSpell|"_LocSpell
	..do OutputLocStore
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLocStore
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocStoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocStoreExecute ]
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

ClassMethod FindLocStoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocStoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:统计科室问题
/// Date:2019-04-10
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualStaticComm","FindScoreList","^^^^")
Query FindScoreList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindScoreListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s checkArea=$p(parr,"^",1) //片区
	s checkLoc=$p(parr,"^",2) //科室
	s checkItem=$p(parr,"^",3) //质控项目ID
	s checkStDate=$p(parr,"^",4) //开始日期
	i checkStDate'="" s checkStDate=$zdh(checkStDate,3)
	s checkEndDate=$p(parr,"^",5) //结束日期
	i checkEndDate'="" s checkEndDate=$zdh(checkEndDate,3)
	s ret=""
	s tmp=""
	//先查询质控检查 根据任务日期进行筛查
	//只统计提交状态的
	s TaskType="" f  s TaskType=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType)) q:TaskType=""  d
	.s QcDate="" f  s QcDate=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType,QcDate)) q:QcDate=""  d
	..q:((checkStDate'="")&&(QcDate<checkStDate))
	..q:((checkEndDate'="")&&(QcDate>checkEndDate))
	..s TaskID="" f  s TaskID=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType,QcDate,TaskID)) q:TaskID=""  d
	...s CheckDR="" f  s CheckDR=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_TaskID,1,CheckDR)) q:CheckDR=""  d
	....s ScoreWard="" f  s ScoreWard=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_TaskID,1,CheckDR,ScoreWard)) q:ScoreWard=""  d
	.....s QcCheckID="" f  s QcCheckID=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_TaskID,1,CheckDR,ScoreWard,QcCheckID)) q:QcCheckID=""  d
	......s QcObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(QcCheckID)
	......q:'$IsObject(QcObj)
	......s score=QcObj.CheckScore
	......s qualID=QcObj.CheckDR
	......q:((checkItem'="")&&(qualID'=checkItem))
	......s ward=QcObj.ScoreWard
	......s QLoc=..GetLocForWard(ward)
	......s isLocForArea=..IsLocForArea(QLoc,checkArea)
	......q:((checkArea'="")&&(isLocForArea=0))
	......s isWardForLoc=..IsWardForLoc(checkLoc,ward)
	......q:((checkLoc'="")&&(isWardForLoc=0))
	......s questions="",remark=""
	......i $fn(score,"")<100 d
	.......s questions=..GetQualScoreItem(QcCheckID)
	.......s remark=..GetQualRemark(QcCheckID)
	......s tmp(QLoc,qualID,TaskID,"Q",score)=questions
	......s tmp(QLoc,qualID,TaskID,"Q",score,"remark")=remark
	
	//再查询夜查房
	s NDate="" f  s NDate=$o(^DHCNMG.CHK.MgNurNightCheckI("date",NDate)) q:NDate=""  d
	.q:((checkStDate'="")&&(NDate<checkStDate))
	.q:((checkEndDate'="")&&(NDate>checkEndDate))
	.s NTaskID="" f  s NTaskID=$o(^DHCNMG.CHK.MgNurNightCheckI("date",NDate,NTaskID)) q:NTaskID=""  d
	..s NRw="" f  s NRw=$o(^DHCNMG.CHK.MgNurNightCheckI("date",NDate,NTaskID,NRw)) q:NRw=""  d
	...s Nobj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(NRw)
	...q:'$IsObject(Nobj)
	...s NQualID=Nobj.TaskQualID //检查项目
	...q:((checkItem'="")&&(NQualID'=checkItem))
	...s NWard=Nobj.TaskWard //检查病区
	...s NLoc=..GetLocForWard(NWard) //获取病区所在科室
	...s isLocForArea=..IsLocForArea(NLoc,checkArea)
	...q:((checkArea'="")&&(isLocForArea=0))
	...s isWardForLoc=..IsWardForLoc(checkLoc,NWard)
	...q:((checkLoc'="")&&(isWardForLoc=0))
	...s questions=$p(..ComputeNCheckScore(NRw),"^",2)
	...s score=$p(..ComputeNCheckScore(NRw),"^",1)
	...s remark=""
	...s tmp(NLoc,NQualID,NTaskID,"N",score)=questions
	...s tmp(NLoc,NQualID,NTaskID,"N",score,"remark")=..GetNCheckRemark(NRw)
	
	s TMPRESULT=""
	s tmpLoc="" f  s tmpLoc=$o(tmp(tmpLoc)) q:tmpLoc=""  d
	.s tmpQualID="" f  s tmpQualID=$o(tmp(tmpLoc,tmpQualID)) q:tmpQualID=""  d
	..s n=0
	..s tmpTaskID="" f  s tmpTaskID=$o(tmp(tmpLoc,tmpQualID,tmpTaskID)) q:tmpTaskID=""  d
	...s tmpType="" f  s tmpType=$o(tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType)) q:tmpType=""  d
	....s tmpScore="" f  s tmpScore=$o(tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore)) q:tmpScore=""  d
	.....s n=n+1
	.....i $g(TMPRESULT(tmpLoc,tmpQualID,"score"))="" d
	......s TMPRESULT(tmpLoc,tmpQualID,"score")=$fn(tmpScore,"",2)
	......i $g(TMPRESULT(tmpLoc,tmpQualID,"question"))="" d
	.......s TMPRESULT(tmpLoc,tmpQualID,"question")=tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore)
	.......s TMPRESULT(tmpLoc,tmpQualID,"remark")=tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore,"remark")
	......e  d
	.......i TMPRESULT(tmpLoc,tmpQualID,"question")'[tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore) d
	........s TMPRESULT(tmpLoc,tmpQualID,"question")=TMPRESULT(tmpLoc,tmpQualID,"question")_";"_tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore)
	........s TMPRESULT(tmpLoc,tmpQualID,"remark")=TMPRESULT(tmpLoc,tmpQualID,"remark")_";"_tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore,"remark")
	.....e  d
	......s TMPRESULT(tmpLoc,tmpQualID,"score")=$fn($fn(TMPRESULT(tmpLoc,tmpQualID,"score"),"")+$fn(tmpScore,""),"")
	......i $g(TMPRESULT(tmpLoc,tmpQualID,"question"))="" d
	.......s TMPRESULT(tmpLoc,tmpQualID,"question")=tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore)
	.......s TMPRESULT(tmpLoc,tmpQualID,"remark")=tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore,"remark")
	......e  d
	.......i TMPRESULT(tmpLoc,tmpQualID,"question")'[tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore) d
	........s TMPRESULT(tmpLoc,tmpQualID,"question")=TMPRESULT(tmpLoc,tmpQualID,"question")_";"_tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore)
	........s TMPRESULT(tmpLoc,tmpQualID,"remark")=TMPRESULT(tmpLoc,tmpQualID,"remark")_";"_tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType,tmpScore,"remark")
	..i (n'=0)&&($g(TMPRESULT(tmpLoc,tmpQualID,"score"))'="") s TMPRESULT(tmpLoc,tmpQualID,"score")=$fn(TMPRESULT(tmpLoc,tmpQualID,"score")/n,"",2)
	
	s TLoc="" f  s TLoc=$o(TMPRESULT(TLoc)) q:TLoc=""  d
	.s TQualID="" f  s TQualID=$o(TMPRESULT(TLoc,TQualID)) q:TQualID=""  d
	..s TType="" f  s TType=$o(TMPRESULT(TLoc,TQualID,TType)) q:TType=""  d
	...q:TType'="score"
	...s LocDesc="",QualDesc="",QuestionTail="",QuestionScore=""
	...s TLocObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(TLoc)
	...q:'$IsObject(TLocObj)
	...s LocDesc=TLocObj.LocDesc
	...s TQualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(TQualID)
	...q:'$IsObject(TQualObj)
	...s QualDesc=TQualObj.QualDesc_TQualObj.QualYear
	...s QuestionTail=TMPRESULT(TLoc,TQualID,"question")
	...s QuestionTail=$g(TMPRESULT(TLoc,TQualID,"remark"))
	...s QuestionScore=TMPRESULT(TLoc,TQualID,TType)
	...s ret="LocDesc|"_LocDesc_"^QualDesc|"_QualDesc_"^QuestionTail|"_QuestionTail_"^QuestionScore|"_QuestionScore
	...do OutputScoreList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindScoreListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreListExecute ]
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

ClassMethod FindScoreListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2019-04-11
/// Description:计算夜查房检查的得分
/// Table：
/// Input:检查父表ID
ClassMethod ComputeNCheckScore(par As %String) As %String
{
	q:par="" 0
	s questions=""
	s score=0
	s rw="" f  s rw=$o(^DHCNMG.CHK.MgNurNightCheckSubD(par,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(obj)
	.q:obj.TaskPar=""
	.s score=$fn($fn(score,"")+$fn(obj.TaskResult,""),"")
	.i ($fn(obj.TaskResult,"")<$fn(obj.TaskValue,"")) d
	..i questions="" s questions=obj.TaskItems
	..e  s questions=questions_";"_obj.TaskItems
	q score_"^"_questions
}

ClassMethod GetNCheckRemark(par As %String) As %String
{
	q:par="" 0
	s questions=""
	s score=0
	s rw="" f  s rw=$o(^DHCNMG.CHK.MgNurNightCheckSubD(par,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(obj)
	.q:obj.TaskPar=""
	.s score=$fn($fn(score,"")+$fn(obj.TaskResult,""),"")
	.i ($fn(obj.TaskResult,"")<$fn(obj.TaskValue,"")) d
	..i questions="" s questions=obj.TaskItems_"【"_obj.TaskRemark_"】"
	..e  s questions=questions_";"_obj.TaskItems_"【"_obj.TaskRemark_"】"
	q questions
}

/// Creator:gzj
/// Date:2019-04-11
/// Description:获取病区所在科室
ClassMethod GetLocForWard(ward As %String) As %String
{
	q:ward="" 100000
	s loc=100000
	s loc=$o(^DHCNMG.DB.MgWardLocUnitI("Ward",ward,""))
	q:loc="" 100000
	;s obj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	;q:'$IsObject(obj) 100000
	;q:'$IsObject(obj.WardLocDR) 100000
	;s loc=obj.WardLocDR.%Id()
	q loc
}

/// Creator:gzj
/// Date:2019-04-11
/// Descritption:检查病区是否属于该科室
ClassMethod IsWardForLoc(loc As %String, ward As %String) As %String
{
	s flag=0
	q:((loc="")!(ward="")) 0
	s rw=$O(^DHCNMG.DB.MgWardLocUnitI("Loc",loc,ward,""))
	i rw'="" s flag=1
	;s obj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	;q:'$IsObject(obj) 0
	;q:'$IsObject(obj.WardLocDR) 0
	;s LocDr=obj.WardLocDR.%Id()
	;i LocDr=loc s flag=1
	q flag
}

/// Creator:gzj
/// Date:2019-04-11
/// Description:判断科室是否属于改片区
/// 
ClassMethod IsLocForArea(loc As %String, area As %String) As %String
{
	s flag=0
	s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(loc)
	q:'$IsObject(obj) 0
	q:'$IsObject(obj.LocAreaDR) 0
	s areaId=obj.LocAreaDR.%Id()
	i areaId=area s flag=1
	q flag
}

/// Creator:gzj
/// Date:2019-04-11
/// Description:获取质控打分扣分问题
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod GetQualScoreItem(par As %String) As %String
{
	s ret=""
	s sort="" f  s sort=$o(^DHCNMG.CHK.MgCheckRoomSubI("Sort",par,sort)) q:sort=""  d
	.s Rw="" f  s Rw=$o(^DHCNMG.CHK.MgCheckRoomSubI("Sort",par,sort,Rw)) q:Rw=""  d
	..s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_Rw)
	..q:'$IsObject(obj)
	..s standScore=obj.StandardScore //标准分值
	..s score=obj.CheckItemScore //得分
	..i ($fn(score,"")<$fn(standScore,"")) d
	...i ret="" s ret=obj.CheckItem
	...e  s ret=ret_";"_obj.CheckItem
	q ret
}

ClassMethod GetQualRemark(par As %String) As %String
{
	s ret=""
	s sort="" f  s sort=$o(^DHCNMG.CHK.MgCheckRoomSubI("Sort",par,sort)) q:sort=""  d
	.s Rw="" f  s Rw=$o(^DHCNMG.CHK.MgCheckRoomSubI("Sort",par,sort,Rw)) q:Rw=""  d
	..s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_Rw)
	..q:'$IsObject(obj)
	..s standScore=obj.StandardScore //标准分值
	..s score=obj.CheckItemScore //得分
	..i ($fn(score,"")<$fn(standScore,"")) d
	...i ret="" s ret=obj.CheckItem_"【"_obj.CheckItemRemark_"】"
	...e  s ret=ret_";"_obj.CheckItem_"【"_obj.CheckItemRemark_"】"
	q ret
}

/// Creator:gzj
/// Descrption:根据质控类型和日期获取所有的质控检查项目
/// 
ClassMethod GetTableColumn(type As %String, stDate As %String, endDate As %String) As %String
{
	q:(type=""!stDate=""!endDate="") "[]"
	i type="Q" s label="质控查房"
    e  i type="N" s label="夜查房"
    e  i type="D" s label="病区自查"
    e  i type="M" s label="科护士长督查"
    e  i type="S" s label="特殊科室检查"
    e  i type="J" s label="季度质控检查"
    s stDate=$zdh(stDate,3)
    s endDate=$zdh(endDate,3)
    s checkType=""
    s Rw="" f  s Rw=$o(^DHCNMG.Set.MgSysParamSubD(8,Rw)) q:Rw=""  d
    .s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(8_"||"_Rw)
    .q:'$IsObject(obj)
    .s desc=obj.SubDesc
    .i label=desc s checkType=8_"||"_Rw
    q:checkType="" "[]"
    s tmp=""
    //根据质控任务来获取检查的类型
    s QualID="" f  s QualID=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",QualID)) q:QualID=""  d
    .s date="" f  s date=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",QualID,date)) q:date=""  d
    ..q:((date<stDate)!(date>endDate))
    ..s QTaskRw="" f  s QTaskRw=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",QualID,date,QTaskRw)) q:QTaskRw=""  d
    ...s QObj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(QTaskRw)
    ...q:'$IsObject(QObj)
    ...q:(QObj.TaskType'=checkType)
    ...s QualItems=QObj.TaskQuals
    ...f i=1:1:QObj.TaskQuals.Count() d
    ....s item=QObj.TaskQuals.GetAt(i)
    ....q:item=""
    ....s QualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(item)
    ....q:'$IsObject(QualObj)
    ....i $g(tmp(item))="" s tmp(item)=QualObj.QualDesc_QualObj.QualYear
    
    //夜查房排班中的都属于夜查房
    //CheckDate
    s NDate="" f  s NDate=$o(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate)) q:NDate=""  d
    .s NRw="" f  s NRw=$o(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate,NRw)) q:NRw=""  d
    ..q:type'="N"
    ..s NObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(NRw)
    ..q:'$IsObject(NObj)
    ..s CheckWork=NObj.CheckWork
    ..s len=$l(CheckWork,",")
    ..f j=1:1:len d
    ...s item=$p(CheckWork,",",j)
    ...q:item=""
    ...s itemId=$p(item,"^",2)
    ...q:itemId=""
    ...s QualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(itemId)
    ...q:'$IsObject(QualObj)
    ...i $g(tmp(itemId))="" s tmp(itemId)=QualObj.QualDesc_QualObj.QualYear
	w "["
	s n=1
    s tmpID="" f  s tmpID=$o(tmp(tmpID)) q:tmpID=""  d
    .s columnIndex="Column"_$tr(tmpID," ","")
    .s label=tmp(tmpID)
    .i n=1 w "{""label"":"""_label_""",""columnIndex"":"""_columnIndex_"""}"
    .e  w ",{""label"":"""_label_""",""columnIndex"":"""_columnIndex_"""}"
    .s n=n+1
    w "]"
	q ""
}

/// Creator:gzj
/// Description:统计科室分数
/// Date:2019-04-10
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualStaticComm","FindLocScoreList","^^^2019-01-01^2019-04-30^Q")
Query FindLocScoreList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindLocScoreListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s checkArea=$p(parr,"^",1) //片区
	s checkLoc=$p(parr,"^",2) //科室
	s checkItem=$p(parr,"^",3) //质控项目ID
	s checkStDate=$p(parr,"^",4) //开始日期
	i checkStDate'="" s checkStDate=$zdh(checkStDate,3)
	s checkEndDate=$p(parr,"^",5) //结束日期
	i checkEndDate'="" s checkEndDate=$zdh(checkEndDate,3)
	s checkType=$p(parr,"^",6)
	
	i checkType="Q" s label="质控查房"
    e  i checkType="N" s label="夜查房"
    e  i checkType="D" s label="病区自查"
    e  i checkType="M" s label="科护士长督查"
    e  i checkType="S" s label="特殊科室检查"
    e  i checkType="J" s label="季度质控检查"
    ;s checkStDate=$zdh(checkStDate,3)
    ;s checkEndDate=$zdh(checkEndDate,3)
    s ParamID=""
    s Rw="" f  s Rw=$o(^DHCNMG.Set.MgSysParamSubD(8,Rw)) q:Rw=""  d
    .s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(8_"||"_Rw)
    .q:'$IsObject(obj)
    .s desc=obj.SubDesc
    .i label=desc s ParamID=8_"||"_Rw
    i ParamID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    
	//查询质控检查
	s date="" f  s date=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y"," "_ParamID,date)) q:date=""  d
	.q:((date<checkStDate)!(date>checkEndDate))
	.s QRw="" f  s QRw=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y"," "_ParamID,date,QRw)) q:QRw=""  d
	..s TaskObj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(QRw)
	..q:'$IsObject(TaskObj)
	..q:(TaskObj.TaskType'=ParamID)
	..s CheckDR="" f  s CheckDR=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_QRw,1,CheckDR)) q:CheckDR=""  d
	...s scoreWard="" f  s scoreWard=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_QRw,1,CheckDR,scoreWard)) q:scoreWard=""  d
	....s QualRw="" f  s QualRw=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_QRw,1,CheckDR,scoreWard,QualRw)) q:QualRw=""  d
	.....s QualObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(QualRw)
	.....q:'$IsObject(QualObj)
	.....s score=QualObj.CheckScore
	.....s qualID=QualObj.CheckDR
	.....q:((checkItem'="")&&(qualID'=checkItem))
	.....s ward=QualObj.ScoreWard
	.....
	.....s QLoc=..GetLocForWard(ward)
	.....q:QLoc=100000
	.....s isLocForArea=..IsLocForArea(QLoc,checkArea)
	.....q:((checkArea'="")&&(isLocForArea=0))
	.....s isWardForLoc=..IsWardForLoc(checkLoc,ward)
	.....q:((checkLoc'="")&&(isWardForLoc=0))
	.....s tmp(QLoc,qualID,QRw,"Q")=score
	//查询夜查房
	s NDate="" f  s NDate=$o(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate)) q:NDate=""  d
	.q:checkType'="N"
	.q:((NDate<checkStDate)!(NDate>checkEndDate))
	.s NRw="" f  s NRw=$o(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate,NRw)) q:NRw=""  d
	..s CheckID="" f  s CheckID=$o(^DHCNMG.CHK.MgNurNightCheckI("TaskID",NRw,CheckID)) q:CheckID=""  d
	...s NObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(CheckID)
	...q:'$IsObject(NObj)
	...s score=..ComputeNCheckScore(CheckID)
	...s TaskQualID=NObj.TaskQualID
	...q:((checkItem'="")&&(TaskQualID'=checkItem))
	...s NWard=NObj.TaskWard
	...s QLoc=..GetLocForWard(NWard)
	...s isLocForArea=..IsLocForArea(QLoc,checkArea)
	...q:((checkArea'="")&&(isLocForArea=0))
	...s isWardForLoc=..IsWardForLoc(checkLoc,NWard)
	...q:((checkLoc'="")&&(isWardForLoc=0))
	...s tmp(QLoc,TaskQualID,NRw,"N")=score
	s tmpLoc="" f  s tmpLoc=$o(tmp(tmpLoc)) q:tmpLoc=""  d
	.s ret="",LocDesc="",tmpQualDesc="",columnSum=""
	.s tmpQualID="" f  s tmpQualID=$o(tmp(tmpLoc,tmpQualID)) q:tmpQualID=""  d
	..s n=0,tmpScore=""
	..s tmpTaskID="" f  s tmpTaskID=$o(tmp(tmpLoc,tmpQualID,tmpTaskID)) q:tmpTaskID=""  d
	...
	...s tmpType="" f  s tmpType=$o(tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType)) q:tmpType=""  d
	....s LocObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(tmpLoc)
	....q:'$IsObject(LocObj)
	....s LocDesc=LocObj.LocDesc
	....s n=n+1
	....i $g(tmpScore)="" s tmpScore=tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType)
	....e  s tmpScore=$fn($fn(($fn(tmpScore,"",2)+$fn(tmp(tmpLoc,tmpQualID,tmpTaskID,tmpType),"",2)),"",2)/n,"",2)
	....s tmpQualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(tmpQualID)
	....q:'$IsObject(tmpQualObj)
	....s tmpQualDesc=tmpQualObj.QualDesc
	....s columnID="Column"_tmpQualID
	....i columnSum="" s columnSum=columnID_"|"_tmpScore
	....e  s columnSum=columnSum_"^"_columnID_"|"_tmpScore
	.s ret="LocDesc|"_LocDesc_"^"_columnSum
	.do OutputLocScoreList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLocScoreList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocScoreListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocScoreListExecute ]
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

ClassMethod FindLocScoreListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocScoreListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:按照项目统计存在问题的科室及个数
/// Date:2019-04-13
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualStaticComm","FindLocQuesNums","^^^2019-04-01^2019-04-30")
Query FindLocQuesNums(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindLocQuesNumsExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s checkArea=$p(parr,"^",1) //片区
	s checkLoc=$p(parr,"^",2) //科室
	s checkItem=$p(parr,"^",3) //质控项目ID
	s checkStDate=$p(parr,"^",4) //开始日期
	i checkStDate'="" s checkStDate=$zdh(checkStDate,3)
	s checkEndDate=$p(parr,"^",5) //结束日期
	i checkEndDate'="" s checkEndDate=$zdh(checkEndDate,3)
	s tmp=""
	//查询质控检查
	s TaskType="" f  s TaskType=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType)) q:TaskType=""  d
	.s QcDate="" f  s QcDate=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType,QcDate)) q:QcDate=""  d
	..q:((checkStDate'="")&&(QcDate<checkStDate))
	..q:((checkEndDate'="")&&(QcDate>checkEndDate))
	..s TaskID="" f  s TaskID=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType,QcDate,TaskID)) q:TaskID=""  d
	...s CheckDR="" f  s CheckDR=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_TaskID,1,CheckDR)) q:CheckDR=""  d
	....s ScoreWard="" f  s ScoreWard=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_TaskID,1,CheckDR,ScoreWard)) q:ScoreWard=""  d
	.....s QcCheckID="" f  s QcCheckID=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_TaskID,1,CheckDR,ScoreWard,QcCheckID)) q:QcCheckID=""  d
	......s QcObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(QcCheckID)
	......q:'$IsObject(QcObj)
	......s qualID=QcObj.CheckDR
	......q:((checkItem'="")&&(qualID'=checkItem))
	......s ward=QcObj.ScoreWard
	......s QLoc=..GetLocForWard(ward)
	......s isLocForArea=..IsLocForArea(QLoc,checkArea)
	......q:((checkArea'="")&&(isLocForArea=0))
	......s isWardForLoc=..IsWardForLoc(checkLoc,ward)
	......q:((checkLoc'="")&&(isWardForLoc=0))
	......s QcCheckRw="" f  s QcCheckRw=$o(^DHCNMG.CHK.MgCheckRoomSubD(QcCheckID,QcCheckRw)) q:QcCheckRw=""  d
	.......s QcSubObj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(QcCheckID_"||"_QcCheckRw)
	.......q:'$IsObject(QcSubObj)
	.......s SubID=QcSubObj.CheckModelDR //标准质控项目子表ID
	.......s itemScore=QcSubObj.CheckItemScore //条目得分
	.......s itemStandScore=QcSubObj.StandardScore //条目标准分值
	.......i $fn(itemScore,"",2)<$fn(itemStandScore,"",2) d
	........s tmp(qualID,SubID,QLoc,TaskID)=1
	//查询夜查房
	s NDate="" f  s NDate=$o(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate)) q:NDate=""  d
	.q:((NDate<checkStDate)!(NDate>checkEndDate))
	.s NTaskID="" f  s NTaskID=$o(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate,NTaskID)) q:NTaskID=""  d
	..s CheckID="" f  s CheckID=$o(^DHCNMG.CHK.MgNurNightCheckI("TaskID",NTaskID,CheckID)) q:CheckID=""  d
	...s NObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(CheckID)
	...q:'$IsObject(NObj)
	...s score=..ComputeNCheckScore(CheckID)
	...s TaskQualID=NObj.TaskQualID //检查项目ID
	...q:((checkItem'="")&&(TaskQualID'=checkItem))
	...s NWard=NObj.TaskWard //检查病区
	...s QLoc=..GetLocForWard(NWard) //获取病区所在科室
	...s isLocForArea=..IsLocForArea(QLoc,checkArea)
	...q:((checkArea'="")&&(isLocForArea=0))
	...s isWardForLoc=..IsWardForLoc(checkLoc,NWard)
	...q:((checkLoc'="")&&(isWardForLoc=0))
	...s NSubRw="" f  s NSubRw=$o(^DHCNMG.CHK.MgNurNightCheckSubD(CheckID,NSubRw)) q:NSubRw=""  d
	....s NSubObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(CheckID_"||"_NSubRw)
	....q:'$IsObject(NSubObj)
	....s SubID=NSubObj.TaskQual //标准质控项目子表ID
	....s itemScore=NSubObj.TaskResult //条目得分
	....s itemStandScore=NSubObj.TaskValue //条目标准分值
	....i $fn(itemScore,"",2)<$fn(itemStandScore,"",2) d
	.....s tmp(TaskQualID,SubID,QLoc,NTaskID)=1
	.....
	
	s tmpArr=""
	s tmpQualID="" f  s tmpQualID=$o(tmp(tmpQualID)) q:tmpQualID=""  d
	.s tmpSubID="" f  s tmpSubID=$o(tmp(tmpQualID,tmpSubID)) q:tmpSubID=""  d
	..s tmpLoc="" f  s tmpLoc=$o(tmp(tmpQualID,tmpSubID,tmpLoc)) q:tmpLoc=""  d
	...i $g(tmpArr(tmpQualID,tmpSubID))="" d
	....s tmpArr(tmpQualID,tmpSubID)=tmpLoc
	...e  d
	....s len=$l(tmpArr(tmpQualID,tmpSubID),"^")
	....s flag=0
	....f i=1:1:len d
	.....s itemlist=$p(tmpArr(tmpQualID,tmpSubID),"^",i)
	.....q:itemlist="" 
	.....i itemlist=tmpLoc s flag=1
	....i flag=0 s tmpArr(tmpQualID,tmpSubID)=tmpArr(tmpQualID,tmpSubID)_"^"_tmpLoc
	
	s ret=""
	s arrQual="" f  s arrQual=$o(tmpArr(arrQual)) q:arrQual=""  d
	.s arrSubRw="" f  s arrSubRw=$o(tmpArr(arrQual,arrSubRw)) q:arrSubRw=""  d
	..s arrLoc=tmpArr(arrQual,arrSubRw)
	..s len=$l(arrLoc,"^")
	..s LocDesc="",num=0,QualDesc="",QualSubDesc=""
	..f j=1:1:len d
	...s LocID=$p(arrLoc,"^",j)
	...q:LocID=""
	...s LocObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(LocID)
	...q:'$IsObject(LocObj)
	...i LocDesc="" s LocDesc=LocObj.LocDesc
	...e  s LocDesc=LocDesc_","_LocObj.LocDesc
	...s num=num+1
	..s QualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(arrQual)
	..q:'$IsObject(QualObj)
	..s QualDesc=QualObj.QualDesc_QualObj.QualYear
	..s QualSubObj=##class(DHCNMG.DB.MgQualItemSub).%OpenId(arrSubRw)
	..q:'$IsObject(QualSubObj)
	..s QualSubDesc=QualSubObj.SubDesc
	..s ret="QualDesc|"_QualDesc_"^QualSubDesc|"_QualSubDesc_"^LocDesc|"_LocDesc_"^LocNum|"_num
	..do OutputLocQuesNums
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLocQuesNums
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocQuesNumsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocQuesNumsExecute ]
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

ClassMethod FindLocQuesNumsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocQuesNumsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:王聪
/// Description:编辑时显示护理问题
/// Date:2019-08-20
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.NurMgQualStaticComm).GetWardProblem(1)
ClassMethod GetWardProblem(id)
{
	q:id="" ""
	s obj=##class(DHCNMG.CHK.MgWardImprove).%OpenId(id)
	if ($ISObject(obj))
	{
		s ret="rw|"_id
		s ret=ret_"^ProbType|"_obj.ProbType
		s ret=ret_"^ProbWard|"_obj.ProbWardDr.%Id()
		s ret=ret_"^ProbWardLoc|"_obj.ProbWardLocDr.%Id()
		s ret=ret_"^ProbDuty|"_obj.ProbDutyPerson.%Id()
		s ProbFind=""
		i obj.ProbFindPerson'=0 d
		.s FindObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProbFindPerson)
		.q:'$IsObject(FindObj)
		.s ProbFind=FindObj.PerName
		e  s ProbFind="管理员"
		s ret=ret_"^ProbFind|"_ProbFind
		s ret=ret_"^ProbDesc|"_obj.ProbDesc
		s ret=ret_"^ProbDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ProbDate)
		q ret
	}
}

/// Creator:王聪
/// Description:审核时显示护理问题
/// Date:2019-08-20
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.NurMgQualStaticComm).GetWardProblem1(1)
ClassMethod GetWardProblem1(id)
{
	q:id="" ""
	s obj=##class(DHCNMG.CHK.MgWardImprove).%OpenId(id)
	if ($ISObject(obj))
	{
		;s ProbType=obj.ProbType
		s ProbType=##class(web.NurMgDBComm).GetSystemParamId(obj.ProbType,"ProblemType")
		s ProbDesc=obj.ProbDesc
		s ProbDate=$zd(obj.ProbDate,3)
		s ProbSubmitDate=""
		s:obj.ProbSubmitDate'="" ProbSubmitDate=$zd(obj.ProbSubmitDate,3)
		s ProbCheckDate=""
		s:obj.ProbCheckDate'="" ProbCheckDate=$zd(obj.ProbCheckDate,3)
		s ProbWardLoc="",ProbWard="",ProbWardId=""
		s:obj.ProbWardLocDr'="" ProbWardLoc=obj.ProbWardLocDr.LocDesc
		s:obj.ProbWardDr'="" ProbWard=obj.ProbWardDr.WardDesc
		s:obj.ProbWardDr'="" ProbWardId=obj.ProbWardDr.%Id()
		s ProbFindWard=""
		s:obj.ProbFindWardDr'="" ProbFindWard=obj.ProbFindWardDr.%Id()
		s ProbWatch=obj.ProbWatch
		s ProbDuty=obj.ProbDutyPerson.PerName
		s ProbFind=""
		i obj.ProbFindPerson'=0 d
		.s FindObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProbFindPerson)
		.q:'$IsObject(FindObj)
		.s ProbFind=FindObj.PerName
		e  s ProbFind="管理员"
		s ProbReason=obj.ProbReason
		s ProbStatus=$case(obj.ProbStatus,"NS":"未提交","YS":"已提交","YC":"已审核","FBH":"驳回","PBH":"驳回","YJ":"已接收","YA":"已确认")
		s ret="ProbType|"_ProbType_"^ProbDesc|"_ProbDesc_"^ProbFindWard|"_ProbFindWard_"^ProbWatch|"_ProbWatch
		s ret=ret_"^ProbDate|"_ProbDate_"^ProbSubmitDate|"_ProbSubmitDate_"^ProbCheckDate|"_ProbCheckDate
		s ret=ret_"^ProbWardId|"_ProbWardId_"^ProbStatus|"_ProbStatus_"^ProbReason|"_ProbReason_"^ProbWard|"_ProbWard
		s ret=ret_"^rw|"_id_"^ProbWardLoc|"_ProbWardLoc_"^ProbDuty|"_ProbDuty_"^ProbFind|"_ProbFind_"^ProbFindPerson|"_obj.ProbFindPerson
		q ret
	}
}

/// Creator:王聪
/// Description:护士保存护理问题
/// Date:2019-08-20
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.NurMgQualStaticComm).SaveWardProblem("rw|^ProbType|X^ProbWard|1^ProbWardLoc|7^ProbDuty|3^ProbFind|护士02^ProbDesc|耗时长^ProbDate|2019-08-05")
ClassMethod SaveWardProblem(parr As %String, flag) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.CHK.MgWardImprove).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.CHK.MgWardImprove).%New()
	s obj.ProbType=$g(tmp("ProbType"))
	s obj.ProbDesc=$g(tmp("ProbDesc"))
	d obj.ProbWardDrSetObjectId(tmp("ProbWard"))
	d obj.ProbWardLocDrSetObjectId(tmp("ProbWardLoc"))
	d obj.ProbDutyPersonSetObjectId(tmp("ProbDuty"))
	s obj.ProbFindPerson=$g(tmp("ProbFind"))
	d obj.ProbFindWardDrSetObjectId($g(tmp("findward")))
	s locid=$O(^DHCNMG.DB.MgWardLocUnit("Ward",+$g(tmp("findward")),""))
	d obj.ProbFindWardLocDrSetObjectId(locid)
	s obj.ProbDate=+$h
    s obj.ProbStatus=flag
    i flag="YS" d
    .s obj.ProbSubmitDate=+$h
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:王聪
/// Description: 审核本病区问题
/// Date:2019-08-20
/// other: d ##class(web.NurMgQualStaticComm).CheckWardProblem("1^YC^^")
ClassMethod CheckWardProblem(parr)
{
	q:parr="" 0
	s id=$p($g(parr),"^",1)
	s ProbCheckResult=$p($g(parr),"^",2)
	s ProbReason=$p($g(parr),"^",3)
	s ProbWatch=$p($g(parr),"^",4)
	s obj=##class(DHCNMG.CHK.MgWardImprove).%OpenId(id)
	q:('$IsObject(obj)) 0
	i ProbCheckResult="BH" d
	.i obj.ProbStatus="YS" s ProbCheckResult="FBH"
	.e  s ProbCheckResult="PBH"
	s obj.ProbStatus=ProbCheckResult
	s obj.ProbCheckDate=+$h
	s obj.ProbReason=ProbReason
	s obj.ProbWatch=ProbWatch
	d obj.%Save()
	q 1
}

/// Creator:王聪
/// Description:护士删除护理问题
/// Date:2019-08-20
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.NurMgQualStaticComm).DeleteWardProblem(2)
ClassMethod DeleteWardProblem(parr)
{
	q:parr="" 0
	f i=1,1,$l(parr,"^") d
	.s id=$p(parr,"^",i)
	.s obj=##class(DHCNMG.CHK.MgWardImprove).%OpenId(id)
	.q:'$IsObject(obj)
	.d obj.%DeleteId(id)
	d obj.%Close()
	q 1
}

/// Creator:王聪
/// Description:护士查询护理问题
/// Date:2019-08-20
/// Input: parr : 查询条件, ward ：查询者所在病区, role：查询者的权限, find：查询者的id
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualStaticComm","FindWardProblem","2019-08-01^2019-08-31^")
Query FindWardProblem(parr, role, loginid) As %Query(ROWSPEC = "aa")
{
}

/// 执行query
ClassMethod FindWardProblemExecute(ByRef qhandle As %Binary, parr, role, loginid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s currydate=$zd(+$h,3)
	s stdate=$p($g(parr),"^",1)
	i stdate'["-" s stdate=+currydate_"-01-01"
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$p($g(parr),"^",2)
	i enddate'["-" s enddate=+currydate_"-12-31"
	s:enddate["-" enddate=$zdh(enddate,3)
	s type=$p($g(parr),"^",3)
	s status=$p($g(parr),"^",4)
	s:loginid=0 loginid=""
	s RowId=""
	s temward=""
	s roleflag=##class(web.NurMgSetComm).setLoginWard(role,loginid,0,.temward)
	s min=100
	f i=1:1:$l(role,",")  d
	.s:min>$p(role,",",i) min=$p(role,",",i) 						//最高角色  6 护士长
	s ProbWard="",ProbFindWard=""
	f  s RowId=$O(^DHCNMG.CHK.MgWardImproveD(RowId)) q:RowId=""  d
	.s obj=##class(DHCNMG.CHK.MgWardImprove).%OpenId(RowId)
	.q:'$IsObject(obj)
	.q:'((obj.ProbDate>=stdate)&&(obj.ProbDate<=enddate))
	.s:obj.ProbWardDr'="" ProbWard=obj.ProbWardDr.%Id()				/// 问题病区
	.s:obj.ProbFindWardDr ProbFindWard=obj.ProbFindWardDr.%Id()   ///发现病区
	.s ProbStatus=obj.ProbStatus								///状态  NS  YS  YC YJ YA
	.s ProbType=obj.ProbType
	.s ProbDuty=obj.ProbDutyPerson.%Id()                             ///责任人
	.q:(status'="")&&(ProbStatus'[status)
	.q:(type'="")&&(ProbType'=type)
	.q:(roleflag'=1)&&('$d(temward(ProbWard))&&('$d(temward(ProbFindWard))))
	.q:(ProbStatus="NS")&&(loginid'=obj.ProbFindPerson)
	.q:((ProbStatus="YS")||(ProbStatus="FBH"))&&'((loginid=obj.ProbFindPerson)||((role[6)&&($d(temward(ProbFindWard)))))
	.q:((ProbStatus="YC")||(ProbStatus="PBH"))&&'((loginid=obj.ProbFindPerson)||((role[6)&&($d(temward(ProbFindWard))))||((role[6)&&($d(temward(ProbWard)))))
	.q:(ProbStatus="YJ")&&'((loginid=obj.ProbFindPerson)||((role[6)&&($d(temward(ProbFindWard))))||((role[6)&&($d(temward(ProbWard))))||(loginid=ProbDuty))
	.s ret=##class(web.NurMgQualStaticComm).GetWardProblem1(RowId)
	.d ProbOutputRow
	s qhandle=$lb(0,repid,0)
	q $$$OK
ProbOutputRow
	s Data=$lb(ret)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindWardProblemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardProblemExecute ]
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

ClassMethod FindWardProblemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardProblemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gyg
/// Description:统计科室在特定时间犯错的总数
/// Date:2019-10-16
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualStaticComm","FindLocQuesCounts","Project|12^CheckSttime|2019-10-01^CheckEndtime|2019-10-31")
Query FindLocQuesCounts(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindLocQuesCountsExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	k tmp
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s projectid=$g(tmp("Project")) //质控检查项目id
	s startime=$g(tmp("CheckSttime")) //开始日期
	i startime'="" s startime=$zdh(startime,3)
	s endtime=$g(tmp("CheckEndtime")) //截止日期
	i endtime'="" s endtime=$zdh(endtime,3)
	s tmp=""
	//质控查房
	s TaskType="" f  s TaskType=$O(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType)) q:TaskType=""   d
	.s QcDate="" f  s QcDate=$O(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType,QcDate))  q:QcDate=""  d
	..q:((startime'="")&&(QcDate<startime))
	..q:((endtime'="")&&(QcDate>endtime))
	..s Taskid="" f  s Taskid=$O(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType,QcDate,Taskid))  q:Taskid=""  d
	...s CheckDR="" f  s CheckDR=$O(^DHCNMG.CHK.MgCheckRoomI("task"," "_Taskid,1,CheckDR))  q:CheckDR=""  d
	....s ScoreWard="" f  s ScoreWard=$O(^DHCNMG.CHK.MgCheckRoomI("task"," "_Taskid,1,CheckDR,ScoreWard)) q:ScoreWard=""  d
	.....;s tmp(ScoreWard)=0
	.....s QcCheckid="" f  s QcCheckid=$O(^DHCNMG.CHK.MgCheckRoomI("task"," "_Taskid,1,CheckDR,ScoreWard,QcCheckid)) q:QcCheckid=""  d
	......s QcObject=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(QcCheckid)
	......q:'$IsObject(QcObject)
	......s qualID=QcObject.CheckDR
	......q:((projectid'="")&&(qualID'=projectid)) //如果不属于此项目跳出
	......s ward=QcObject.ScoreWard
	......s QLoc=..GetLocForWard(ward) //根据病区获得科室id
	......s QcCheckRw="" f  s QcCheckRw=$O(^DHCNMG.CHK.MgCheckRoomSubD(QcCheckid,QcCheckRw)) q:QcCheckRw=""  d
	.......s QcObj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(QcCheckid_"||"_QcCheckRw)
	.......q:'$IsObject(QcObj)
	.......s Subid=QcObj.CheckModelDR  //质控项目子表id
	.......s itemScore=QcObj.CheckItemScore //实际得分
	.......s itemStandScore=QcObj.StandardScore //标准分数
	.......i $fn(itemScore,"",2)<$fn(itemStandScore,"",2)  d
	........s tmp(QLoc)=$G(tmp(QLoc))+1
	//夜查房
	s NDate="" f  s NDate=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate)) q:NDate=""  d
	.q:((NDate<startime)!(NDate>endtime))
	.s NTaskid="" f  s NTaskid=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate,NTaskid)) q:NTaskid=""  d
	..s Checkid="" f  s Checkid=$O(^DHCNMG.CHK.MgNurNightCheckI("TaskID",NTaskid,Checkid)) q:Checkid=""  d
	...s NightObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(Checkid)
	...q:'$IsObject(NightObj)
	...s TaskQuid=NightObj.TaskQualID //检查项目
	...q:((projectid'="")&&(TaskQuid'=projectid))
	...s Nward=NightObj.TaskWard //检查病区
	...s QLoc=..GetLocForWard(Nward) //获取科室
	...s NightRw="" f  s NightRw=$O(^DHCNMG.CHK.MgNurNightCheckSubD(Checkid,NightRw)) q:NightRw=""  d
	....s NightSubObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(Checkid_"||"_NightRw)
	....q:'$IsObject(NightSubObj)
	....s Subid=NightSubObj.TaskQual //质控项目子表id
	....s itemScore=NightSubObj.TaskResult //实际得分
	....s itemStandScore=NightSubObj.TaskValue //标准分
	....i $fn(itemScore,"",2)<$fn(itemStandScore,"",2)  d
	.....s tmp(QLoc)=$G(tmp(QLoc))+1
	//取出来
	s loc="" f  s loc=$o(tmp(loc)) q:loc=""  d
	.s locObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(loc)
	.q:'$IsObject(locObj)
	.s locname=locObj.LocDesc
	.s ret="value|"_tmp(loc)_"^name|"_locname
	.do OutputLocQuesNums
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLocQuesNums
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocQuesCountsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocQuesCountsExecute ]
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

ClassMethod FindLocQuesCountsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocQuesCountsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据质控项目id获取质控名字
/// d ##class(web.NurMgQualStaticComm).GetProjectName("18")
ClassMethod GetProjectName(proid) As %String
{
	q:proid=""
	s proObj=##class(DHCNMG.DB.MgQualItem).%OpenId(proid)
	q:'$IsObject(proObj)
	s proname=proObj.QualDesc
	q "name|"_proname
}

/// Creator:gyg
/// Description:统计科室在特定时间犯错的总数(按年份进行区分)
/// Date:2019-11-12
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(web.NurMgQualStaticComm).FindLocYearQuesCounts("Project|^CheckSttime|2015-06-16^CheckEndtime|2019-11-30")
ClassMethod FindLocYearQuesCounts(parr As %String) As %String
{
	s ret=""
	k tmp,tmps,tmpy
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s projectid=$g(tmp("Project")) //质控检查项目id
	s startime=$g(tmp("CheckSttime")) //开始日期
	s starttimeyear=$p(startime,"-",1)
	s endtime=$g(tmp("CheckEndtime")) //截止日期
	s endtimeyear=$p(endtime,"-",1)
	s endtime=endtimeyear_"-12-31"
	;i ((endtimeyear-starttimeyear)'=2)  q 0   //所选日期不是三年的
	;s tmps(starttimeyear)=0
	;s tmps((starttimeyear+1))=0
	;s tmps((endtimeyear))=0
	i startime'="" s startime=$zdh(startime,3)
	i endtime'="" s endtime=$zdh(endtime,3)
	//质控查房
	s TaskType="" f  s TaskType=$O(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType)) q:TaskType=""   d
	.s QcDate="" f  s QcDate=$O(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType,QcDate))  q:QcDate=""  d
	..q:((startime'="")&&(QcDate<startime))
	..q:((endtime'="")&&(QcDate>endtime))
	..s year=$p($zd(QcDate,3),"-",1)
	..s Taskid="" f  s Taskid=$O(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",TaskType,QcDate,Taskid))  q:Taskid=""  d
	...s CheckDR="" f  s CheckDR=$O(^DHCNMG.CHK.MgCheckRoomI("task"," "_Taskid,1,CheckDR))  q:CheckDR=""  d
	....s ScoreWard="" f  s ScoreWard=$O(^DHCNMG.CHK.MgCheckRoomI("task"," "_Taskid,1,CheckDR,ScoreWard)) q:ScoreWard=""  d
	.....;s tmp(ScoreWard)=0
	.....s QcCheckid="" f  s QcCheckid=$O(^DHCNMG.CHK.MgCheckRoomI("task"," "_Taskid,1,CheckDR,ScoreWard,QcCheckid)) q:QcCheckid=""  d
	......s QcObject=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(QcCheckid)
	......q:'$IsObject(QcObject)
	......s qualID=QcObject.CheckDR
	......q:((projectid'="")&&(qualID'=projectid)) //如果不属于此项目跳出
	......s ward=QcObject.ScoreWard
	......s QLoc=..GetLocForWard(ward) //根据病区获得科室id
	......q:QLoc=100000
	......s QcCheckRw="" f  s QcCheckRw=$O(^DHCNMG.CHK.MgCheckRoomSubD(QcCheckid,QcCheckRw)) q:QcCheckRw=""  d
	.......s QcObj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(QcCheckid_"||"_QcCheckRw)
	.......q:'$IsObject(QcObj)
	.......s Subid=QcObj.CheckModelDR  //质控项目子表id
	.......s itemScore=QcObj.CheckItemScore //实际得分
	.......s itemStandScore=QcObj.StandardScore //标准分数
	.......i $fn(itemScore,"",2)<$fn(itemStandScore,"",2)  d
	........s tmps(year,QLoc)=$G(tmps(year,QLoc))+1  //建立一个临时global存储哪一年哪个科室所犯的错误
	........s tmpy(QLoc,year)=$G(tmpy(QLoc,year))+1
	........;s tmp(QLoc)=$G(tmp(QLoc))+1
	//夜查房
	s NDate="" f  s NDate=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate)) q:NDate=""  d
	.q:((NDate<startime)!(NDate>endtime))
	.s year=$p($zd(NDate,3),"-",1) //取夜查房年份
	.s NTaskid="" f  s NTaskid=$O(^DHCNMG.CHK.MgNurHeadSchduleI("date",NDate,NTaskid)) q:NTaskid=""  d
	..s Checkid="" f  s Checkid=$O(^DHCNMG.CHK.MgNurNightCheckI("TaskID",NTaskid,Checkid)) q:Checkid=""  d
	...s NightObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(Checkid)
	...q:'$IsObject(NightObj)
	...s TaskQuid=NightObj.TaskQualID //检查项目
	...q:((projectid'="")&&(TaskQuid'=projectid))
	...s Nward=NightObj.TaskWard //检查病区
	...s QLoc=..GetLocForWard(Nward) //获取科室
	...q:QLoc=100000
	...s NightRw="" f  s NightRw=$O(^DHCNMG.CHK.MgNurNightCheckSubD(Checkid,NightRw)) q:NightRw=""  d
	....s NightSubObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(Checkid_"||"_NightRw)
	....q:'$IsObject(NightSubObj)
	....s Subid=NightSubObj.TaskQual //质控项目子表id
	....s itemScore=NightSubObj.TaskResult //实际得分
	....s itemStandScore=NightSubObj.TaskValue //标准分
	....i $fn(itemScore,"",2)<$fn(itemStandScore,"",2)  d
	.....s tmps(year,QLoc)=$G(tmps(year,QLoc))+1
	.....s tmpy(QLoc,year)=$G(tmpy(QLoc,year))+1
	.....;s tmp(QLoc)=$G(tmp(QLoc))+1
	//取出来
	;f i=starttimeyear:1:endtimeyear  d
	;.s loc="" f  s loc=$o(tmpy(loc)) q:loc=""  d
	;..s:'$d(tmpy(loc,i)) tmpy(loc,i)=0
	s flagloc=""
	w "["
	s n=0
	s loc="" f  s loc=$O(tmpy(loc)) q:loc=""  d
	.i (loc'=flagloc)  d
	..s locObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(loc)
	..q:'$IsObject(locObj)
	..s locname=locObj.LocDesc
	..s n=n+1
	..i n=1  s ret="{""product"":"""_locname_""""
	..e  s ret=",{""product"":"""_locname_""""
	.s year="" f  s year=$O(tmpy(loc,year)) q:year=""  d
	..s ret=ret_","_""""_year_""":"""_tmpy(loc,year)_""""
	..s flagloc=loc
	.s ret=ret_"}"
	.w ret
	w "]"
	q ""
}

}
