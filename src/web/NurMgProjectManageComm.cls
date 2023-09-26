/// creator:liuning
/// createdate:2018-11-05
/// description:科研立项管理
Class web.NurMgProjectManageComm Extends %RegisteredObject
{

/// Creator:liuning
/// Description:查找护士
/// Date:2018-11-05
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgProjectManageComm","FindNurses","")
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
/// createDate: 2018-11-05
/// description: 获取片区列表
/// table: DHCNMG.DB.MgWardArea
/// input: 
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgProjectManageComm","FindWardAreaList","")
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
/// Date:2018-11-05
/// Table:DHCNMG.Intern.MgProjectManage
/// Input:
/// Output：
/// Return:
/// Others:do ##class(web.NurMgProjectManageComm).SaveProject("")
ClassMethod SaveProject(parr As %String) As %String
{
	q:parr="" "传入数据为空"
	;s ^TMP("SaveProject")=parr
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s tmp("ProjectYear")=+$zd(+$h,3)
	s isExist=$d(^DHCNMG.Work.MgProjectManageI("NurYear"," "_tmp("ProjectYear")," "_tmp("ProjectName")," "_tmp("ProjectNurOne")))
	q:(isExist)&&($g(tmp("RowID"))="") "此护士该年度该立项已申请"
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.Work.MgProjectManage).%New()
	e  s obj=##class(DHCNMG.Work.MgProjectManage).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Work.MgProjectManage","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i (p="ProjectSetDate")&&(tmp("ProjectSetDate")'="") s tmp("ProjectSetDate")=$zdh(tmp("ProjectSetDate"),3)
	..i (p="ProjectEndDate")&&(tmp("ProjectEndDate")'="") s tmp("ProjectEndDate")=$zdh(tmp("ProjectEndDate"),3)
	..i (p="ProjectOverDate")&&(tmp("ProjectOverDate")'="") s tmp("ProjectOverDate")=$zdh(tmp("ProjectOverDate"),3)
	..s $ZOBJPROPERTY(obj,p)=$zcvt($tr(tmp(p),"__","||"),"U")
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q "保存失败"
}

///  creator: liuning
///  createdate: 2018-11-05
///  description: 查询科研立项列表
///  table: DHCNMG.Work.MgProjectManage
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgProjectManageComm","FindProject","^2018-11-01^2018-11-30","0","0")
Query FindProject(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

// 57^2018-09-01^2018-10-31

ClassMethod FindProjectExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	;s ^TMP("arglist")=parr_"%"_input
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s ProjectNur=$P(parr,"^",4)
	s tmpWard=""
	s ret=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s listno="" f  s listno=$O(^DHCNMG.Work.MgProjectManageI("Nur",listno),-1) q:listno=""  d
	.s id="" f  s id=$O(^DHCNMG.Work.MgProjectManageI("Nur",listno,id),-1) q:id=""  d
	..s obj=##class(DHCNMG.Work.MgProjectManage).%OpenId(id)
	..q:(ward'="")&&(ward'=obj.ProjectStaAreaOne)
	..q:(ProjectNur'="")&&(ProjectNur'=obj.ProjectNurOne)
	..q:(isAll=0)&&((obj.ProjectStaAreaOne="")||('$d(tmpWard(obj.ProjectStaAreaOne))))
	..q:((stdate'="")&&(stdate>obj.ProjectSetDate))||((enddate'="")&&(enddate<obj.ProjectSetDate))
	..q:'$IsObject(obj)
	..s ret="RowID|"_obj.%Id()
	..s SetDate=$zd(obj.ProjectSetDate,3)
	..s ret=ret_"^ProjectSetDate|"_SetDate
	..s ret=ret_"^ProjectGrade|"_obj.ProjectGrade
	..s ProjectGradeName=""
	..s GradeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectGrade)
	..i $IsObject(GradeObj) s ProjectGradeName=GradeObj.SubDesc
	..s ret=ret_"^ProjectGradeName|"_ProjectGradeName_"^ProjectName|"_obj.ProjectName
	..i obj.ProjectEndDate'=""  s EndDate=$zd(obj.ProjectEndDate,3)
	..e  s EndDate=""
	..s ret=ret_"^ProjectEndDate|"_EndDate	
	..s ret=ret_"^ProjectType|"_obj.ProjectType
	..s ProjectTypeName=""
	..s TypeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectType)
	..i $IsObject(TypeObj) s ProjectTypeName=TypeObj.SubDesc
	..s ret=ret_"^ProjectTypeName|"_ProjectTypeName_"^ProjectMoney|"_obj.ProjectMoney
	..s ret=ret_"^ProjectNurOne|"_obj.ProjectNurOne
	..s ProjectNurOneName=""
	..s NurOneObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProjectNurOne)
	..i $IsObject(NurOneObj) s ProjectNurOneName=NurOneObj.PerName
	..s ret=ret_"^ProjectNurOneName|"_ProjectNurOneName
	..s ret=ret_"^ProjectDutyOne|"_obj.ProjectDutyOne
	..s ProjectDutyOneName=""
	..s DutyOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectDutyOne)
	..i $IsObject(DutyOneObj) s ProjectDutyOneName=DutyOneObj.SubDesc
	..s ret=ret_"^ProjectDutyOneName|"_ProjectDutyOneName
	..s ret=ret_"^ProjectTitleOne|"_obj.ProjectTitleOne
	..s ProjectTitleOneName=""
	..s TitleOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectTitleOne)
	..i $IsObject(TitleOneObj) s ProjectTitleOneName=TitleOneObj.SubDesc
	..s ret=ret_"^ProjectTitleOneName|"_ProjectTitleOneName
	..s ret=ret_"^ProjectHierarchyOne|"_obj.ProjectHierarchyOne
	..s ProjectHierarchyOneName=""
	..s HierarchyOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectHierarchyOne)
	..i $IsObject(HierarchyOneObj) s ProjectHierarchyOneName=HierarchyOneObj.SubDesc
	..s ret=ret_"^ProjectHierarchyOneName|"_ProjectHierarchyOneName
	..s ret=ret_"^ProjectAreaOne|"_obj.ProjectAreaOne
	..s ProjectAreaOneName=""
	..s AreaOneObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.ProjectAreaOne)
	..i $IsObject(AreaOneObj) s ProjectAreaOneName=AreaOneObj.AreaDesc
	..s ret=ret_"^ProjectAreaOneName|"_ProjectAreaOneName
	..s ret=ret_"^ProjectStaAreaOne|"_obj.ProjectStaAreaOne
	..s ProjectStaAreaOneName=""
	..s StaAreaOneObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ProjectStaAreaOne)
	..i $IsObject(StaAreaOneObj) s ProjectStaAreaOneName=StaAreaOneObj.WardDesc
	..s ret=ret_"^ProjectStaAreaOneName|"_ProjectStaAreaOneName
	..s ret=ret_"^ProjectNurTwo|"_obj.ProjectNurTwo
	..s ProjectNurTwoName=""
	..s NurTwoObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProjectNurTwo)
	..i $IsObject(NurTwoObj) s ProjectNurTwoName=NurTwoObj.PerName
	..s ret=ret_"^ProjectNurTwoName|"_ProjectNurTwoName
	..s ret=ret_"^ProjectDutyTwo|"_obj.ProjectDutyTwo
	..s ProjectDutyTwoName=""
	..s DutyTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectDutyTwo)
	..i $IsObject(DutyTwoObj) s ProjectDutyTwoName=DutyTwoObj.SubDesc
	..s ret=ret_"^ProjectDutyTwoName|"_ProjectDutyTwoName
	..s ret=ret_"^ProjectTitleTwo|"_obj.ProjectTitleTwo
	..s ProjectTitleTwoName=""
	..s TitleTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectTitleTwo)
	..i $IsObject(TitleTwoObj) s ProjectTitleTwoName=TitleTwoObj.SubDesc
	..s ret=ret_"^ProjectTitleTwoName|"_ProjectTitleTwoName
	..s ret=ret_"^ProjectHierarchyTwo|"_obj.ProjectHierarchyTwo
	..s ProjectHierarchyTwoName=""
	..s HierarchyTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectHierarchyTwo)
	..i $IsObject(HierarchyTwoObj) s ProjectHierarchyTwoName=HierarchyTwoObj.SubDesc
	..s ret=ret_"^ProjectHierarchyTwoName|"_ProjectHierarchyTwoName
	..s ret=ret_"^ProjectAreaTwo|"_obj.ProjectAreaTwo
	..s ProjectAreaTwoName=""
	..s AreaTwoObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.ProjectAreaTwo)
	..i $IsObject(AreaTwoObj) s ProjectAreaTwoName=AreaTwoObj.AreaDesc
	..s ret=ret_"^ProjectAreaTwoName|"_ProjectAreaTwoName
	..s ret=ret_"^ProjectStaAreaTwo|"_obj.ProjectStaAreaTwo
	..s ProjectStaAreaTwoName=""
	..s StaAreaTwoObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ProjectStaAreaTwo)
	..i $IsObject(StaAreaTwoObj) s ProjectStaAreaTwoName=StaAreaTwoObj.WardDesc
	..s ret=ret_"^ProjectStaAreaTwoName|"_ProjectStaAreaTwoName
	..s ret=ret_"^ProjectNurThree|"_obj.ProjectNurThree
	..s ProjectNurThreeName=""
	..s NurThreeObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProjectNurThree)
	..i $IsObject(NurThreeObj) s ProjectNurThreeName=NurThreeObj.PerName
	..s ret=ret_"^ProjectNurThreeName|"_ProjectNurThreeName
	..s ret=ret_"^ProjectNurOther|"_obj.ProjectNurOther
	..s ProjectNurOtherName=""
	..s NurOtherObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProjectNurOther)
	..i $IsObject(NurOtherObj) s ProjectNurOtherName=NurOtherObj.PerName
	..s ret=ret_"^ProjectNurOtherName|"_ProjectNurOtherName
	..i (obj.ProjectEndDate'="") s OverDate=$zd(obj.ProjectOverDate,3)
	..e  s OverDate=""
	..s ret=ret_"^ProjectOverDate|"_OverDate_"^ProjectComment|"_obj.ProjectComment
	..d OutProject
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutProject
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindProjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindProjectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindProjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProjectExecute ]
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
/// createdate: 2018-11-05
/// description: 删除科研立项记录
/// table: DHCNMG.Work.MgProjectManage
/// input:
/// output:
/// other:do ##class(web.NurMgProjectManageComm).DeleteProject("1")
ClassMethod DeleteProject(id As %String) As %String
{
	q:id="" "传入ID为空"
	s obj=##class(DHCNMG.Work.MgProjectManage).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q sc
}

/// Creator:liuning
/// Description:修改科研奖项信息
/// Date:2018-11-05
/// Table:DHCNMG.Work.MgProjectManage
/// Input:
/// Output：
/// Return:
/// Others:zw ##class(web.NurMgProjectManageComm).GetProject("1847")
ClassMethod GetProject(parr As %String = "") As %String
{
   q:parr="" ""
   s staid=$o(^DHCNMG.Work.MgProjectManageI("Nur"," "_parr,""))
   s obj=##class(DHCNMG.Work.MgProjectManage).%OpenId(staid)
   q:'$IsObject(obj) ""
   s ProjectSetDateOld=obj.ProjectSetDate
   s ProjectSetDate=$zd(ProjectSetDateOld,3)
   s ProjectGrade=obj.ProjectGrade
   s ProjectName=obj.ProjectName
   s ProjectEndDateOld=obj.ProjectEndDate
   s ProjectEndDate=$zd(ProjectEndDateOld,3)
   s ProjectType=obj.ProjectType
   s ProjectMoney=obj.ProjectMoney
   s ProjectNurOne=obj.ProjectNurOne
   s ProjectDutyOne=obj.ProjectDutyOne
   s ProjectTitleOne=obj.ProjectTitleOne
   s ProjectHierarchyOne=obj.ProjectHierarchyOne
   s ProjectAreaOne=obj.ProjectAreaOne    
   s ProjectStaAreaOne=obj.ProjectStaAreaOne
   s ProjectNurTwo=obj.ProjectNurTwo
   s ProjectDutyTwo=obj.ProjectDutyTwo
   s ProjectTitleTwo=obj.ProjectTitleTwo
   s ProjectHierarchyTwo=obj.ProjectHierarchyTwo
   s ProjectAreaTwo=obj.ProjectAreaTwo
   s ProjectStaAreaTwo=obj.ProjectStaAreaTwo 
   s ProjectNurThree=obj.ProjectNurThree
   s ProjectNurOther=obj.ProjectNurOther
   s ProjectOverDateOld=obj.ProjectOverDate
   s ProjectOverDate=$zd(ProjectOverDateOld,3)
   s ProjectComment=obj.ProjectComment
   s RowID=staid
   s ret="ProjectSetDate|+"_ProjectSetDate_"^ProjectGrade|+"_ProjectGrade_"^ProjectName|+"_ProjectName_"^ProjectEndDate|+"_ ProjectEndDate_"^ProjectType|+"_ProjectType_"^ProjectMoney|+"_ProjectMoney_"^ProjectNurOne|+"_ProjectNurOne_"^ProjectDutyOne|+"_ProjectDutyOne_"^ProjectTitleOne|+"_ProjectTitleOne_"^ProjectHierarchyOne|+"_ ProjectHierarchyOne_"^ProjectAreaOne|+"_ProjectAreaOne_"^ProjectStaAreaOne|+"_ProjectStaAreaOne_"^ProjectNurTwo|+"_ProjectNurTwo_"^ProjectDutyTwo|+"_ProjectDutyTwo_"^ProjectTitleTwo|+"_ProjectTitleTwo_"^ProjectHierarchyTwo|+"_ ProjectHierarchyTwo_"^ProjectAreaTwo|+"_ProjectAreaTwo_"^ProjectStaAreaTwo|+"_ProjectStaAreaTwo_"^ProjectNurThree|+"_ProjectNurThree_"^ProjectNurOther|+"_ProjectNurOther_"^ProjectOverDate|+"_ProjectOverDate_"^ProjectComment|+"_ProjectComment_"^RowID|+"_RowID
   q ret
}

/// creator: liuning
/// createdate: 2018-11-05
/// description: 导出科研立项列表
/// table: DHCNMG.Work.MgProjectManage
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgProjectManageComm","FindOutputProjectData","2018-09-01^2018-10-31","0","0")
Query FindOutputProjectData(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOutputProjectDataExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	;s ^TMP("arglist")=parr_"%"_input
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s ProjectNur=$P(parr,"^",4)
	s tmpWard=""
	s ret=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s listno="" f  s listno=$O(^DHCNMG.Work.MgProjectManageI("Nur",listno),-1) q:listno=""  d
	.s id="" f  s id=$O(^DHCNMG.Work.MgProjectManageI("Nur",listno,id),-1) q:id=""  d
	..s obj=##class(DHCNMG.Work.MgProjectManage).%OpenId(id)
	..q:(ward'="")&&(ward'=obj.ProjectStaAreaOne)
	..q:(ProjectNur'="")&&(ProjectNur'=obj.ProjectNurOne)
	..q:(isAll=0)&&((obj.ProjectStaAreaOne="")||('$d(tmpWard(obj.ProjectStaAreaOne))))
	..q:((stdate'="")&&(stdate>obj.ProjectSetDate))||((enddate'="")&&(enddate<obj.ProjectSetDate))
	..q:'$IsObject(obj)
	..s ret="RowID|"_obj.%Id()
	..s SetDate=$zd(obj.ProjectSetDate,3)
	..s ret=ret_"^ProjectSetDate|"_SetDate
	..s ret=ret_"^ProjectGrade|"_obj.ProjectGrade
	..s ProjectGradeName=""
	..s GradeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectGrade)
	..i $IsObject(GradeObj) s ProjectGradeName=GradeObj.SubDesc
	..s ret=ret_"^ProjectGradeName|"_ProjectGradeName_"^ProjectName|"_obj.ProjectName
	..i obj.ProjectEndDate'=""  s EndDate=$zd(obj.ProjectEndDate,3)
	..e  s EndDate=""
	..s ret=ret_"^ProjectEndDate|"_EndDate	
	..s ret=ret_"^ProjectType|"_obj.ProjectType
	..s ProjectTypeName=""
	..s TypeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectType)
	..i $IsObject(TypeObj) s ProjectTypeName=TypeObj.SubDesc
	..s ret=ret_"^ProjectTypeName|"_ProjectTypeName_"^ProjectMoney|"_obj.ProjectMoney
	..s ret=ret_"^ProjectNurOne|"_obj.ProjectNurOne
	..s ProjectNurOneName=""
	..s NurOneObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProjectNurOne)
	..i $IsObject(NurOneObj) s ProjectNurOneName=NurOneObj.PerName
	..s ret=ret_"^ProjectNurOneName|"_ProjectNurOneName
	..s ret=ret_"^ProjectDutyOne|"_obj.ProjectDutyOne
	..s ProjectDutyOneName=""
	..s DutyOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectDutyOne)
	..i $IsObject(DutyOneObj) s ProjectDutyOneName=DutyOneObj.SubDesc
	..s ret=ret_"^ProjectDutyOneName|"_ProjectDutyOneName
	..s ret=ret_"^ProjectTitleOne|"_obj.ProjectTitleOne
	..s ProjectTitleOneName=""
	..s TitleOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectTitleOne)
	..i $IsObject(TitleOneObj) s ProjectTitleOneName=TitleOneObj.SubDesc
	..s ret=ret_"^ProjectTitleOneName|"_ProjectTitleOneName
	..s ret=ret_"^ProjectHierarchyOne|"_obj.ProjectHierarchyOne
	..s ProjectHierarchyOneName=""
	..s HierarchyOneObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectHierarchyOne)
	..i $IsObject(HierarchyOneObj) s ProjectHierarchyOneName=HierarchyOneObj.SubDesc
	..s ret=ret_"^ProjectHierarchyOneName|"_ProjectHierarchyOneName
	..s ret=ret_"^ProjectAreaOne|"_obj.ProjectAreaOne
	..s ProjectAreaOneName=""
	..s AreaOneObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.ProjectAreaOne)
	..i $IsObject(AreaOneObj) s ProjectAreaOneName=AreaOneObj.AreaDesc
	..s ret=ret_"^ProjectAreaOneName|"_ProjectAreaOneName
	..s ret=ret_"^ProjectStaAreaOne|"_obj.ProjectStaAreaOne
	..s ProjectStaAreaOneName=""
	..s StaAreaOneObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ProjectStaAreaOne)
	..i $IsObject(StaAreaOneObj) s ProjectStaAreaOneName=StaAreaOneObj.WardDesc
	..s ret=ret_"^ProjectStaAreaOneName|"_ProjectStaAreaOneName
	..s ret=ret_"^ProjectNurTwo|"_obj.ProjectNurTwo
	..s ProjectNurTwoName=""
	..s NurTwoObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProjectNurTwo)
	..i $IsObject(NurTwoObj) s ProjectNurTwoName=NurTwoObj.PerName
	..s ret=ret_"^ProjectNurTwoName|"_ProjectNurTwoName
	..s ret=ret_"^ProjectDutyTwo|"_obj.ProjectDutyTwo
	..s ProjectDutyTwoName=""
	..s DutyTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectDutyTwo)
	..i $IsObject(DutyTwoObj) s ProjectDutyTwoName=DutyTwoObj.SubDesc
	..s ret=ret_"^ProjectDutyTwoName|"_ProjectDutyTwoName
	..s ret=ret_"^ProjectTitleTwo|"_obj.ProjectTitleTwo
	..s ProjectTitleTwoName=""
	..s TitleTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectTitleTwo)
	..i $IsObject(TitleTwoObj) s ProjectTitleTwoName=TitleTwoObj.SubDesc
	..s ret=ret_"^ProjectTitleTwoName|"_ProjectTitleTwoName
	..s ret=ret_"^ProjectHierarchyTwo|"_obj.ProjectHierarchyTwo
	..s ProjectHierarchyTwoName=""
	..s HierarchyTwoObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.ProjectHierarchyTwo)
	..i $IsObject(HierarchyTwoObj) s ProjectHierarchyTwoName=HierarchyTwoObj.SubDesc
	..s ret=ret_"^ProjectHierarchyTwoName|"_ProjectHierarchyTwoName
	..s ret=ret_"^ProjectAreaTwo|"_obj.ProjectAreaTwo
	..s ProjectAreaTwoName=""
	..s AreaTwoObj=##class(DHCNMG.DB.MgWardArea).%OpenId(obj.ProjectAreaTwo)
	..i $IsObject(AreaTwoObj) s ProjectAreaTwoName=AreaTwoObj.AreaDesc
	..s ret=ret_"^ProjectAreaTwoName|"_ProjectAreaTwoName
	..s ret=ret_"^ProjectStaAreaTwo|"_obj.ProjectStaAreaTwo
	..s ProjectStaAreaTwoName=""
	..s StaAreaTwoObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ProjectStaAreaTwo)
	..i $IsObject(StaAreaTwoObj) s ProjectStaAreaTwoName=StaAreaTwoObj.WardDesc
	..s ret=ret_"^ProjectStaAreaTwoName|"_ProjectStaAreaTwoName
	..s ret=ret_"^ProjectNurThree|"_obj.ProjectNurThree
	..s ProjectNurThreeName=""
	..s NurThreeObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProjectNurThree)
	..i $IsObject(NurThreeObj) s ProjectNurThreeName=NurThreeObj.PerName
	..s ret=ret_"^ProjectNurThreeName|"_ProjectNurThreeName
	..s ret=ret_"^ProjectNurOther|"_obj.ProjectNurOther
	..s ProjectNurOtherName=""
	..s NurOtherObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.ProjectNurOther)
	..i $IsObject(NurOtherObj) s ProjectNurOtherName=NurOtherObj.PerName
	..s ret=ret_"^ProjectNurOtherName|"_ProjectNurOtherName
	..i (obj.ProjectEndDate'="") s OverDate=$zd(obj.ProjectOverDate,3)
	..e  s OverDate=""
	..s ret=ret_"^ProjectOverDate|"_OverDate_"^ProjectComment|"_obj.ProjectComment
	..d OutProject
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutProject
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOutputProjectDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutputProjectDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOutputProjectDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutputProjectDataExecute ]
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

/// Creator:lcy
/// Description:查找护士
/// Date:2019-10-09
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgProjectManageComm","FindNursesA","")
Query FindNursesA(input As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNursesAExecute(ByRef qHandle As %Binary, ward As %String, input As %String = "", role As %String, nurseid As %String) As %Status
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
	..s ret="nurseName|"_nurseNo_nurseName_"^nurseNo|"_nurseNo_"^RowID|"_id
	..do OutputNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNursesAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNursesExecute ]
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

ClassMethod FindNursesAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNursesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lcy
/// Description:查找护士
/// Date:2019-10-10
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgProjectManageComm","FindNursesAll","")
Query FindNursesAll(input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNursesAllExecute(ByRef qHandle As %Binary, input As %String = "") As %Status
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
	..s ret="nurseName|"_nurseNo_nurseName_"^nurseNo|"_nurseNo_"^RowID|"_id
	..do OutputNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNursesAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNursesExecute ]
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

ClassMethod FindNursesAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNursesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
