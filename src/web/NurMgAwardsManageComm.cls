/// creator:liuning
/// createdate:2018-10-31
/// description:科研奖项管理
Class web.NurMgAwardsManageComm Extends %RegisteredObject
{

/// Creator:liuning
/// Description:查找护士
/// Date:2018-10-31
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgAwardsManageComm","FindNurses","")
Query FindNurses(input As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNursesExecute(ByRef qHandle As %Binary, ward As %String, input As %String = "", role As %String, nurseid As %String) As %Status
{
	;s ^TMP("FindNurses")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s PerID="" f  s PerID=$O(^DHCNMG.HR.MgPersonsI("PerID",PerID)) q:PerID=""  d
	.s id="" f  s id=$O(^DHCNMG.HR.MgPersonsI("PerID",PerID,id)) q:id=""  d
	..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	..s nurseName=obj.PerName
	..s nurseNo=obj.PerID
	..s ret="nurseName|"_nurseName_"^nurseNo|"_nurseNo_"^RowID|"_id
	..do OutputNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNursesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNursesExecute ]
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

ClassMethod FindNursesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNursesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: liuning
/// createDate: 20181031
/// description: 获取片区列表
/// table: DHCNMG.DB.MgWardArea
/// input: 
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgAwardsManageComm","FindWardAreaList","")
Query FindWardAreaList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardAreaListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s code="" f  s code=$O(^DHCNMG.DB.MgWardAreaI("Code",code)) q:code=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgWardAreaI("Code",code,id)) q:id=""  d
	..s obj=##class(DHCNMG.DB.MgWardArea).%OpenId(id)
	..s ret=..GetWardArea(id)
	..d OutWardArea
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardArea
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardAreaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardAreaListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardAreaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardAreaListExecute ]
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

/// creator: xbl
/// createDate: 20170817
/// description: 获取片区记录
/// table: DHCNMG.DB.MgWardArea
/// input: 
/// output:
/// other:
ClassMethod GetWardArea(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWardArea).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^AreaCode|"_obj.AreaCode
	s ret=ret_"^AreaDesc|"_obj.AreaDesc
	i obj.AreaNurHeadDR'="" d
	.s ret=ret_"^AreaNurHeadDR|"_obj.AreaNurHeadDR.%Id()
	.s ret=ret_"^NurHeadName|"_obj.AreaNurHeadDR.PerName
	i obj.AreaStDate'="" d
	.s ret=ret_"^AreaStDate|"_$zd(obj.AreaStDate,3)
	i obj.AreaEndDate'="" d
	.s ret=ret_"^AreaEndDate|"_$zd(obj.AreaEndDate,3)
	q ret
}

/// Creator:liuning
/// Description:保存科研立项奖信息
/// Date:2018年11月01日
/// Table:DHCNMG.Intern.MgAwardsManage
/// Input:
/// Output：
/// Return:
/// Others:do ##class(web.NurMgAwardsManageComm).SaveAwards("")
ClassMethod SaveAwards(parr As %String) As %String
{
	q:parr="" "传入数据为空"
	;s ^TMP("SaveAwards")=parr
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s tmp("AwardsYear")=+$zd(+$h,3)
	s isExist=$d(^DHCNMG.Work.MgAwardsManageI("NurYear"," "_tmp("AwardsYear")," "_tmp("AwardsName")," "_tmp("AwardsNurOne")))
	q:(isExist)&&($g(tmp("RowID"))="") "此护士该年度该奖项已申请"
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.Work.MgAwardsManage).%New()
	e  s obj=##class(DHCNMG.Work.MgAwardsManage).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Work.MgAwardsManage","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i (p="AwardsDate")&&(tmp("AwardsDate")'="") s tmp("AwardsDate")=$zdh(tmp("AwardsDate"),3)
	..s $ZOBJPROPERTY(obj,p)=$zcvt($tr(tmp(p),"__","||"),"U")
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q "保存失败"
}

///  creator: liuning
///  createdate: 20181101
///  description: 查询科研成果奖列表
///  table: DHCNMG.Work.MgAwardsManage
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgAwardsManageComm","FindAwards","^2018-11-01^2018-11-30","0","0")
Query FindAwards(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

// 57^2018-09-01^2018-10-31

ClassMethod FindAwardsExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	;s ^TMP("arglist")=parr_"%"_input
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s AwardsNur=$P(parr,"^",4)
	s tmpWard=""
	s ret=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s listno="" f  s listno=$O(^DHCNMG.Work.MgAwardsManageI("Nur",listno),-1) q:listno=""  d
	.s id="" f  s id=$O(^DHCNMG.Work.MgAwardsManageI("Nur",listno,id),-1) q:id=""  d
	..s obj=##class(DHCNMG.Work.MgAwardsManage).%OpenId(id)
	..q:(ward'="")&&(ward'=obj.AwardsStaAreaOne)
	..q:(AwardsNur'="")&&(AwardsNur'=obj.AwardsNurOne)
	..q:(isAll=0)&&((obj.AwardsStaAreaOne="")||('$d(tmpWard(obj.AwardsStaAreaOne))))
	..q:((stdate'="")&&(stdate>obj.AwardsDate))||((enddate'="")&&(enddate<obj.AwardsDate))
	..q:'$IsObject(obj)
	..s ret="RowID|"_obj.%Id()
	..s ret=ret_"^AwardsSource|"_obj.AwardsSource
	..s AwardsSourceName=""
	..s SourceObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsSource)
	..i $IsObject(SourceObj) s AwardsSourceName=SourceObj.SubDesc
	.. s ret=ret_"^AwardsSourceName|"_AwardsSourceName_"^AwardsName|"_obj.AwardsName
	..s Date=$zd(obj.AwardsDate,3)
	..s ret=ret_"^AwardsDate|"_Date
	..s ret=ret_"^AwardsGrade|"_obj.AwardsGrade
	..s AwardsGradeName=""
	..s GradeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsGrade)
	..i $IsObject(GradeObj) s AwardsGradeName=GradeObj.SubDesc
	..s ret=ret_"^AwardsGradeName|"_AwardsGradeName_"^AwardsAmount|"_obj.AwardsAmount
	..s ret=ret_"^AwardsType|"_obj.AwardsType
	..s AwardsTypeName=""
	..s TypeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsType)
	..i $IsObject(TypeObj) s AwardsTypeName=TypeObj.SubDesc
	..s ret=ret_"^AwardsTypeName|"_AwardsTypeName
	..s ret=ret_"^AwardsNurOne|"_obj.AwardsNurOne
	..s AwardsNurOneName=""
	..s NurOneObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.AwardsNurOne)
	..i $IsObject(NurOneObj) s AwardsNurOneName=NurOneObj.PerName
	..s ret=ret_"^AwardsNurOneName|"_AwardsNurOneName
	..s ret=ret_"^AwardsDutyOne|"_obj.AwardsDutyOne
	..s AwardsDutyOneName=""
	..s DutyOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsDutyOne)
	..i $IsObject(DutyOneObj) s AwardsDutyOneName=DutyOneObj.SubDesc
	..s ret=ret_"^AwardsDutyOneName|"_AwardsDutyOneName
	..s ret=ret_"^AwardsTitleOne|"_obj.AwardsTitleOne
	..s AwardsTitleOneName=""
	..s TitleOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsTitleOne)
	..i $IsObject(TitleOneObj) s AwardsTitleOneName=TitleOneObj.SubDesc
	..s ret=ret_"^AwardsTitleOneName|"_AwardsTitleOneName
	..s ret=ret_"^AwardsHierarchyOne|"_obj.AwardsHierarchyOne
	..s AwardsHierarchyOneName=""
	..s HierarchyOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsHierarchyOne)
	..i $IsObject(HierarchyOneObj) s AwardsHierarchyOneName=HierarchyOneObj.SubDesc
	..s ret=ret_"^AwardsHierarchyOneName|"_AwardsHierarchyOneName
	..s ret=ret_"^AwardsAreaOne|"_obj.AwardsAreaOne
	..s AwardsAreaOneName=""
	..s AreaOneObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.AwardsAreaOne)
	..i $IsObject(AreaOneObj) s AwardsAreaOneName=AreaOneObj.AreaDesc
	..s ret=ret_"^AwardsAreaOneName|"_AwardsAreaOneName
	..s ret=ret_"^AwardsStaAreaOne|"_obj.AwardsStaAreaOne
	..s AwardsStaAreaOneName=""
	..s StaAreaOneObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.AwardsStaAreaOne)
	..i $IsObject(StaAreaOneObj) s AwardsStaAreaOneName=StaAreaOneObj.WardDesc
	..s ret=ret_"^AwardsStaAreaOneName|"_AwardsStaAreaOneName
	..s ret=ret_"^AwardsNurTwo|"_obj.AwardsNurTwo
	..s AwardsNurTwoName=""
	..s NurTwoObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.AwardsNurTwo)
	..i $IsObject(NurTwoObj) s AwardsNurTwoName=NurTwoObj.PerName
	..s ret=ret_"^AwardsNurTwoName|"_AwardsNurTwoName
	..s ret=ret_"^AwardsDutyTwo|"_obj.AwardsDutyTwo
	..s AwardsDutyTwoName=""
	..s DutyTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsDutyTwo)
	..i $IsObject(DutyTwoObj) s AwardsDutyTwoName=DutyTwoObj.SubDesc
	..s ret=ret_"^AwardsDutyTwoName|"_AwardsDutyTwoName
	..s ret=ret_"^AwardsTitleTwo|"_obj.AwardsTitleTwo
	..s AwardsTitleTwoName=""
	..s TitleTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsTitleTwo)
	..i $IsObject(TitleTwoObj) s AwardsTitleTwoName=TitleTwoObj.SubDesc
	..s ret=ret_"^AwardsTitleTwoName|"_AwardsTitleTwoName
	..s ret=ret_"^AwardsHierarchyTwo|"_obj.AwardsHierarchyTwo
	..s AwardsHierarchyTwoName=""
	..s HierarchyTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsHierarchyTwo)
	..i $IsObject(HierarchyTwoObj) s AwardsHierarchyTwoName=HierarchyTwoObj.SubDesc
	..s ret=ret_"^AwardsHierarchyTwoName|"_AwardsHierarchyTwoName
	..s ret=ret_"^AwardsAreaTwo|"_obj.AwardsAreaTwo
	..s AwardsAreaTwoName=""
	..s AreaTwoObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.AwardsAreaTwo)
	..i $IsObject(AreaTwoObj) s AwardsAreaTwoName=AreaTwoObj.AreaDesc
	..s ret=ret_"^AwardsAreaTwoName|"_AwardsAreaTwoName
	..s ret=ret_"^AwardsStaAreaTwo|"_obj.AwardsStaAreaTwo
	..s AwardsStaAreaTwoName=""
	..s StaAreaTwoObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.AwardsStaAreaTwo)
	..i $IsObject(StaAreaTwoObj) s AwardsStaAreaTwoName=StaAreaTwoObj.WardDesc
	..s ret=ret_"^AwardsStaAreaTwoName|"_AwardsStaAreaTwoName
	..s ret=ret_"^AwardsNurThree|"_obj.AwardsNurThree
	..s AwardsNurThreeName=""
	..s NurThreeObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.AwardsNurThree)
	..i $IsObject(NurThreeObj) s AwardsNurThreeName=NurThreeObj.PerName
	..s ret=ret_"^AwardsNurThreeName|"_AwardsNurThreeName
	..s ret=ret_"^AwardsDutyThree|"_obj.AwardsDutyThree
	..s AwardsDutyThreeName=""
	..s DutyThreeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsDutyThree)
	..i $IsObject(DutyThreeObj) s AwardsDutyThreeName=DutyThreeObj.SubDesc
	..s ret=ret_"^AwardsDutyThreeName|"_AwardsDutyThreeName
	..s ret=ret_"^AwardsTitleThree|"_obj.AwardsTitleThree
	..s AwardsTitleThreeName=""
	..s TitleThreeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsTitleThree)
	..i $IsObject(TitleThreeObj) s AwardsTitleThreeName=TitleThreeObj.SubDesc
	..s ret=ret_"^AwardsTitleThreeName|"_AwardsTitleThreeName
	..s ret=ret_"^AwardsHierarchyThree|"_obj.AwardsHierarchyThree
	..s AwardsHierarchyThreeName=""
	..s HierarchyThreeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsHierarchyThree)
	..i $IsObject(HierarchyThreeObj) s AwardsHierarchyThreeName=HierarchyThreeObj.SubDesc
	..s ret=ret_"^AwardsHierarchyThreeName|"_AwardsHierarchyThreeName
	..s ret=ret_"^AwardsAreaThree|"_obj.AwardsAreaThree
	..s AwardsAreaThreeName=""
	..s AreaThreeObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.AwardsAreaThree)
	..i $IsObject(AreaThreeObj) s AwardsAreaThreeName=AreaThreeObj.AreaDesc
	..s ret=ret_"^AwardsAreaThreeName|"_AwardsAreaThreeName
	..s ret=ret_"^AwardsStaAreaThree|"_obj.AwardsStaAreaThree
	..s AwardsStaAreaThreeName=""
	..s StaAreaThreeObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.AwardsStaAreaThree)
	..i $IsObject(StaAreaThreeObj) s AwardsStaAreaThreeName=StaAreaThreeObj.WardDesc
	..s ret=ret_"^AwardsStaAreaThreeName|"_AwardsStaAreaThreeName
	..s ret=ret_"^AwardsNurOther|"_obj.AwardsNurOther
	..s AwardsNurOtherName=""
	..s NurOtherObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.AwardsNurOther)
	..i $IsObject(NurOtherObj) s AwardsNurOtherName=NurOtherObj.PerName
	..s ret=ret_"^AwardsNurOtherName|"_AwardsNurOtherName
	..d OutQuarterTest
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuarterTest
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAwardsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAwardsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAwardsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAwardsExecute ]
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

/// creator: liuning
/// createdate: 2018-11-02
/// description: 删除科研奖项记录
/// table: DHCNMG.Work.MgAwardsManage
/// input:
/// output:
/// other:do ##class(web.NurMgAwardsManageComm).DeleteAwards("1")
ClassMethod DeleteAwards(id As %String) As %String
{
	q:id="" "传入ID为空"
	s obj=##class(DHCNMG.Work.MgAwardsManage).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q sc
}

/// Creator:liuning
/// Description:修改科研奖项信息
/// Date:2018年11月02日
/// Table:DHCNMG.Work.MgAwardsManage
/// Input:
/// Output：
/// Return:
/// Others:zw ##class(web.NurMgAwardsManageComm).GetAwards("1847")
ClassMethod GetAwards(parr As %String = "") As %String
{
	q:parr="" ""
	s staid=$o(^DHCNMG.Work.MgAwardsManageI("Awards"," "_parr,""))
	s obj=##class(DHCNMG.Work.MgAwardsManage).%OpenId(staid)
	q:'$IsObject(obj) ""
    s AwardsSource=obj.AwardsSource
    s AwardsName=obj.AwardsName
    s AwardsDateOld=obj.AwardsDate
    s AwardsDate=$zd(AwardsDateOld,3)
    s AwardsGrade=obj.AwardsGrade
    s AwardsAmount=obj.AwardsAmount
    s AwardsType=obj.AwardsType
    s AwardsNurOne=obj.AwardsNurOne
    s AwardsDutyOne=obj.AwardsDutyOne
    s AwardsTitleOne=obj.AwardsTitleOne
    s AwardsHierarchyOne=obj.AwardsHierarchyOne
    s AwardsAreaOne=obj.AwardsAreaOne    
    s AwardsStaAreaOne=obj.AwardsStaAreaOne
    s AwardsNurTwo=obj.AwardsNurTwo
    s AwardsDutyTwo=obj.AwardsDutyTwo
    s AwardsTitleTwo=obj.AwardsTitleTwo
    s AwardsHierarchyTwo=obj.AwardsHierarchyTwo
    s AwardsAreaTwo=obj.AwardsAreaTwo
    s AwardsStaAreaTwo=obj.AwardsStaAreaTwo 
    s AwardsNurThree=obj.AwardsNurThree
    s AwardsDutyThree=obj.AwardsDutyThree
    s AwardsTitleThree=obj.AwardsTitleThree
    s AwardsHierarchyThree=obj.AwardsHierarchyThree
    s AwardsAreaThree=obj.AwardsAreaThree
    s AwardsStaAreaThree=obj.AwardsStaAreaThree
    s AwardsNurOther=obj.AwardsNurOther
    s RowID=staid
    s ret="AwardsSource|+"_AwardsSource_"^AwardsName|+"_AwardsName_"^AwardsDate|+"_AwardsDate_"^AwardsGrade|+"_ AwardsGrade_"^AwardsAmount|+"_AwardsAmount_"^AwardsType|+"_AwardsType_"^AwardsNurOne|+"_AwardsNurOne_"^AwardsDutyOne|+"_AwardsDutyOne_"^AwardsTitleOne|+"_AwardsTitleOne_"^AwardsHierarchyOne|+"_ AwardsHierarchyOne_"^AwardsAreaOne|+"_AwardsAreaOne_"^AwardsStaAreaOne|+"_AwardsStaAreaOne_"^AwardsNurTwo|+"_AwardsNurTwo_"^AwardsDutyTwo|+"_AwardsDutyTwo_"^AwardsTitleTwo|+"_AwardsTitleTwo_"^AwardsHierarchyTwo|+"_ AwardsHierarchyTwo_"^AwardsAreaTwo|+"_AwardsAreaTwo_"^AwardsStaAreaTwo|+"_AwardsStaAreaTwo_"^AwardsNurThree|+"_AwardsNurThree_"^AwardsDutyThree|+"_AwardsDutyThree_"^AwardsTitleThree|+"_AwardsTitleThree_"^AwardsHierarchyThree|+"_ AwardsHierarchyThree_"^AwardsAreaThree|+"_AwardsAreaThree_"^AwardsStaAreaThree|+"_AwardsStaAreaThree_"^AwardsNurOther|+"_AwardsNurOther_"^RowID|+"_RowID
    q ret
}

/// creator: liuning
/// createdate: 2018-11-02
/// description: 导出科研成果奖列表
/// table: DHCNMG.Work.MgAwardsManage
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgAwardsManageComm","FindOutputAwardsData","2018-09-01^2018-10-31","0","0")
Query FindOutputAwardsData(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOutputAwardsDataExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	;s ^TMP("arglist")=parr_"%"_input
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s AwardsNur=$P(parr,"^",4)
	s tmpWard=""
	s ret=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s listno="" f  s listno=$O(^DHCNMG.Work.MgAwardsManageI("Nur",listno),-1) q:listno=""  d
	.s id="" f  s id=$O(^DHCNMG.Work.MgAwardsManageI("Nur",listno,id),-1) q:id=""  d
	..s obj=##class(DHCNMG.Work.MgAwardsManage).%OpenId(id)
	..q:(ward'="")&&(ward'=obj.AwardsStaAreaOne)
	..q:(AwardsNur'="")&&(AwardsNur'=obj.AwardsNurOne)
	..q:(isAll=0)&&((obj.AwardsStaAreaOne="")||('$d(tmpWard(obj.AwardsStaAreaOne))))
	..q:((stdate'="")&&(stdate>obj.AwardsDate))||((enddate'="")&&(enddate<obj.AwardsDate))
	..q:'$IsObject(obj)
	..s ret="RowID|"_obj.%Id()
	..s ret=ret_"^AwardsSource|"_obj.AwardsSource
	..s AwardsSourceName=""
	..s SourceObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsSource)
	..i $IsObject(SourceObj) s AwardsSourceName=SourceObj.SubDesc
	.. s ret=ret_"^AwardsSourceName|"_AwardsSourceName_"^AwardsName|"_obj.AwardsName
	..s Date=$zd(obj.AwardsDate,3)
	..s ret=ret_"^AwardsDate|"_Date
	..s ret=ret_"^AwardsGrade|"_obj.AwardsGrade
	..s AwardsGradeName=""
	..s GradeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsGrade)
	..i $IsObject(GradeObj) s AwardsGradeName=GradeObj.SubDesc
	..s ret=ret_"^AwardsGradeName|"_AwardsGradeName_"^AwardsAmount|"_obj.AwardsAmount
	..s ret=ret_"^AwardsType|"_obj.AwardsType
	..s AwardsTypeName=""
	..s TypeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsType)
	..i $IsObject(TypeObj) s AwardsTypeName=TypeObj.SubDesc
	..s ret=ret_"^AwardsTypeName|"_AwardsTypeName
	..s ret=ret_"^AwardsNurOne|"_obj.AwardsNurOne
	..s AwardsNurOneName=""
	..s NurOneObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.AwardsNurOne)
	..i $IsObject(NurOneObj) s AwardsNurOneName=NurOneObj.PerName
	..s ret=ret_"^AwardsNurOneName|"_AwardsNurOneName
	..s ret=ret_"^AwardsDutyOne|"_obj.AwardsDutyOne
	..s AwardsDutyOneName=""
	..s DutyOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsDutyOne)
	..i $IsObject(DutyOneObj) s AwardsDutyOneName=DutyOneObj.SubDesc
	..s ret=ret_"^AwardsDutyOneName|"_AwardsDutyOneName
	..s ret=ret_"^AwardsTitleOne|"_obj.AwardsTitleOne
	..s AwardsTitleOneName=""
	..s TitleOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsTitleOne)
	..i $IsObject(TitleOneObj) s AwardsTitleOneName=TitleOneObj.SubDesc
	..s ret=ret_"^AwardsTitleOneName|"_AwardsTitleOneName
	..s ret=ret_"^AwardsHierarchyOne|"_obj.AwardsHierarchyOne
	..s AwardsHierarchyOneName=""
	..s HierarchyOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsHierarchyOne)
	..i $IsObject(HierarchyOneObj) s AwardsHierarchyOneName=HierarchyOneObj.SubDesc
	..s ret=ret_"^AwardsHierarchyOneName|"_AwardsHierarchyOneName
	..s ret=ret_"^AwardsAreaOne|"_obj.AwardsAreaOne
	..s AwardsAreaOneName=""
	..s AreaOneObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.AwardsAreaOne)
	..i $IsObject(AreaOneObj) s AwardsAreaOneName=AreaOneObj.AreaDesc
	..s ret=ret_"^AwardsAreaOneName|"_AwardsAreaOneName
	..s ret=ret_"^AwardsStaAreaOne|"_obj.AwardsStaAreaOne
	..s AwardsStaAreaOneName=""
	..s StaAreaOneObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.AwardsStaAreaOne)
	..i $IsObject(StaAreaOneObj) s AwardsStaAreaOneName=StaAreaOneObj.WardDesc
	..s ret=ret_"^AwardsStaAreaOneName|"_AwardsStaAreaOneName
	..s ret=ret_"^AwardsNurTwo|"_obj.AwardsNurTwo
	..s AwardsNurTwoName=""
	..s NurTwoObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.AwardsNurTwo)
	..i $IsObject(NurTwoObj) s AwardsNurTwoName=NurTwoObj.PerName
	..s ret=ret_"^AwardsNurTwoName|"_AwardsNurTwoName
	..s ret=ret_"^AwardsDutyTwo|"_obj.AwardsDutyTwo
	..s AwardsDutyTwoName=""
	..s DutyTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsDutyTwo)
	..i $IsObject(DutyTwoObj) s AwardsDutyTwoName=DutyTwoObj.SubDesc
	..s ret=ret_"^AwardsDutyTwoName|"_AwardsDutyTwoName
	..s ret=ret_"^AwardsTitleTwo|"_obj.AwardsTitleTwo
	..s AwardsTitleTwoName=""
	..s TitleTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsTitleTwo)
	..i $IsObject(TitleTwoObj) s AwardsTitleTwoName=TitleTwoObj.SubDesc
	..s ret=ret_"^AwardsTitleTwoName|"_AwardsTitleTwoName
	..s ret=ret_"^AwardsHierarchyTwo|"_obj.AwardsHierarchyTwo
	..s AwardsHierarchyTwoName=""
	..s HierarchyTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsHierarchyTwo)
	..i $IsObject(HierarchyTwoObj) s AwardsHierarchyTwoName=HierarchyTwoObj.SubDesc
	..s ret=ret_"^AwardsHierarchyTwoName|"_AwardsHierarchyTwoName
	..s ret=ret_"^AwardsAreaTwo|"_obj.AwardsAreaTwo
	..s AwardsAreaTwoName=""
	..s AreaTwoObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.AwardsAreaTwo)
	..i $IsObject(AreaTwoObj) s AwardsAreaTwoName=AreaTwoObj.AreaDesc
	..s ret=ret_"^AwardsAreaTwoName|"_AwardsAreaTwoName
	..s ret=ret_"^AwardsStaAreaTwo|"_obj.AwardsStaAreaTwo
	..s AwardsStaAreaTwoName=""
	..s StaAreaTwoObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.AwardsStaAreaTwo)
	..i $IsObject(StaAreaTwoObj) s AwardsStaAreaTwoName=StaAreaTwoObj.WardDesc
	..s ret=ret_"^AwardsStaAreaTwoName|"_AwardsStaAreaTwoName
	..s ret=ret_"^AwardsNurThree|"_obj.AwardsNurThree
	..s AwardsNurThreeName=""
	..s NurThreeObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.AwardsNurThree)
	..i $IsObject(NurThreeObj) s AwardsNurThreeName=NurThreeObj.PerName
	..s ret=ret_"^AwardsNurThreeName|"_AwardsNurThreeName
	..s ret=ret_"^AwardsDutyThree|"_obj.AwardsDutyThree
	..s AwardsDutyThreeName=""
	..s DutyThreeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsDutyThree)
	..i $IsObject(DutyThreeObj) s AwardsDutyThreeName=DutyThreeObj.SubDesc
	..s ret=ret_"^AwardsDutyThreeName|"_AwardsDutyThreeName
	..s ret=ret_"^AwardsTitleThree|"_obj.AwardsTitleThree
	..s AwardsTitleThreeName=""
	..s TitleThreeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsTitleThree)
	..i $IsObject(TitleThreeObj) s AwardsTitleThreeName=TitleThreeObj.SubDesc
	..s ret=ret_"^AwardsTitleThreeName|"_AwardsTitleThreeName
	..s ret=ret_"^AwardsHierarchyThree|"_obj.AwardsHierarchyThree
	..s AwardsHierarchyThreeName=""
	..s HierarchyThreeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.AwardsHierarchyThree)
	..i $IsObject(HierarchyThreeObj) s AwardsHierarchyThreeName=HierarchyThreeObj.SubDesc
	..s ret=ret_"^AwardsHierarchyThreeName|"_AwardsHierarchyThreeName
	..s ret=ret_"^AwardsAreaThree|"_obj.AwardsAreaThree
	..s AwardsAreaThreeName=""
	..s AreaThreeObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.AwardsAreaThree)
	..i $IsObject(AreaThreeObj) s AwardsAreaThreeName=AreaThreeObj.AreaDesc
	..s ret=ret_"^AwardsAreaThreeName|"_AwardsAreaThreeName
	..s ret=ret_"^AwardsStaAreaThree|"_obj.AwardsStaAreaThree
	..s AwardsStaAreaThreeName=""
	..s StaAreaThreeObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.AwardsStaAreaThree)
	..i $IsObject(StaAreaThreeObj) s AwardsStaAreaThreeName=StaAreaThreeObj.WardDesc
	..s ret=ret_"^AwardsStaAreaThreeName|"_AwardsStaAreaThreeName
	..s ret=ret_"^AwardsNurOther|"_obj.AwardsNurOther
	..s AwardsNurOtherName=""
	..s NurOtherObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.AwardsNurOther)
	..i $IsObject(NurOtherObj) s AwardsNurOtherName=NurOtherObj.PerName
	..s ret=ret_"^AwardsNurOtherName|"_AwardsNurOtherName
	..d OutAwards
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAwards
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOutputAwardsDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutputAwardsDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOutputAwardsDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutputAwardsDataExecute ]
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
