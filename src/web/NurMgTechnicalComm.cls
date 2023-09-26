/// Creator：guozj
/// Description：Vue版护理管理护理工作量管理季度考试
/// Date：2018-10-24
Class web.NurMgTechnicalComm Extends %RegisteredObject
{

/// Creator:liuning
/// Description:查找病区对应的护士
/// Date:2018-10-20
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgTechnicalComm","FindWardNurses","")
Query FindWardNurses(ward As %String, input As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardNursesExecute(ByRef qHandle As %Binary, ward As %String, input As %String = "", role As %String, nurseid As %String) As %Status
{
	;s ^TMP("FindWardNurses")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_ward,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	.s nurseName=obj.PerName
	.s nurseNo=obj.PerID
	.s ret="nurseName|"_nurseName_"^nurseNo|"_nurseNo_"^RowID|"_RowID
	.do OutputNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardNursesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardNursesExecute ]
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

ClassMethod FindWardNursesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardNursesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:liuning
/// Description:保存护士季度考试成绩
/// Date:2018年10月24日
/// Table:DHCNMG.Intern.MgQuarterExam
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveScoreSta(parr As %String) As %String
{
	q:parr="" "传入数据为空"
	s ^TMP("SaveScoreSta")=parr
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s tmp("TestYear")=+$zd(+$h,3)
	s isExist=$d(^DHCNMG.Work.MgQuarterExamI("NurYear"," "_tmp("TestYear")," "_tmp("TestQuarter")," "_tmp("TestNur")))
	q:(isExist)&&($g(tmp("RowID"))="") "此护士该年度该项目已打分"
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.Work.MgQuarterExam).%New()
	e  s obj=##class(DHCNMG.Work.MgQuarterExam).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.Work.MgQuarterExam","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p="TestDate" s tmp("TestDate")=$zdh(tmp("TestDate"),3)
	..s $ZOBJPROPERTY(obj,p)=$zcvt($tr(tmp(p),"__","||"),"U")
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q "保存失败"
}

///  creator: liuning
///  createdate: 20181025
///  description: 查询季度考试成绩列表
///  table: DHCNMG.Work.MgQuarterExam
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgTechnicalComm","FindQuarterTest","^2018-10-01^2018-10-31","0","0")
Query FindQuarterTest(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

// 57^2018-09-01^2018-10-31

ClassMethod FindQuarterTestExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindQuarterTest")=parr_"%"_input
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	///s creator=$P(parr,"^",4)
	s tmpWard=""
	s ret=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s listno="" f  s listno=$O(^DHCNMG.Work.MgQuarterExamI("Nur",listno),-1) q:listno=""  d
	.s id="" f  s id=$O(^DHCNMG.Work.MgQuarterExamI("Nur",listno,id),-1) q:id=""  d
	..s obj=##class(DHCNMG.Work.MgQuarterExam).%OpenId(id)
	..q:(ward'="")&&(ward'=obj.ScoreStaArea)
	..q:(isAll=0)&&((obj.ScoreStaArea="")||('$d(tmpWard(obj.ScoreStaArea))))
	..q:((stdate'="")&&(stdate>obj.TestDate))||((enddate'="")&&(enddate<obj.TestDate))
	..q:'$IsObject(obj)
	..s ret="RowID|"_obj.%Id()
	..s ret=ret_"^ScoreStaArea|"_obj.ScoreStaArea
	..s ScoreStaAreaName=""
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ScoreStaArea)
	..i $IsObject(wardObj) s ScoreStaAreaName=wardObj.WardDesc
	..s ret=ret_"^ScoreStaAreaName|"_ScoreStaAreaName
	..s ret=ret_"^TestNur|"_obj.TestNur
	..s TestNurName=""
	..s NurObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.TestNur)
	..i $IsObject(NurObj) s TestNurName=NurObj.PerName
	..s ret=ret_"^TestNurName|"_TestNurName
	..s Date=$zd(obj.TestDate,3)
	..s ret=ret_"^TestDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TestDate)
	..s ret=ret_"^TestQuarter|"_obj.TestQuarter
	..s ret=ret_"^TestQuarter|"_obj.TestQuarter
	..s TestQuarterName=""
	..s TestQuarterObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.TestQuarter)
	..i $IsObject(TestQuarterObj) s TestQuarterName=TestQuarterObj.SubDesc
	..s ret=ret_"^TestQuarterName|"_TestQuarterName
	..s ret=ret_"^TestValue|"_obj.TestValue
	..s TestValueName=""
	..s TestValueObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.TestValue)
	..i $IsObject(TestValueObj) s TestValueName=TestValueObj.SubDesc
	..s ret=ret_"^TestValueName|"_TestValueName
	..s ret=ret_"^Reason|"_obj.Reason
	..s ReasonName=""
	..s ReasonObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.Reason)
	..i $IsObject(ReasonObj) s ReasonName=ReasonObj.SubDesc
	..s ret=ret_"^ReasonName|"_ReasonName_"^TestScore|"_obj.TestScore
	..d OutQuarterTest
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuarterTest
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQuarterTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuarterTestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQuarterTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuarterTestExecute ]
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
/// createdate: 2018-10-26
/// description: 删除护士季度考试成绩
/// table: DHCNMG.Intern.MgTransPlan
/// input:
/// output:
/// other:do ##class(web.NurMgTechnicalComm).DeleteTransPlan(arg1,...)
ClassMethod DeleteTransPlan(id As %String) As %String
{
	q:id="" "传入ID为空"
	s obj=##class(DHCNMG.Work.MgQuarterExam).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: liuning
/// createdate: 2018-10-26
/// description: 导出护士季度考试成绩
/// table: DHCNMG.Intern.MgTransPlan
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.NurMgTechnicalComm","FindOutputQuarterTestData","2018-09-01^2018-10-31","0","0")
Query FindOutputQuarterTestData(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOutputQuarterTestDataExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindOutputQuarterTestData")=parr_"%"_input
	s stdate=$p(parr,"^",1)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	s tmpWard=""
	s ret=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s listno="" f  s listno=$O(^DHCNMG.Work.MgQuarterExamI("Nur",listno),-1) q:listno=""  d
	.s id="" f  s id=$O(^DHCNMG.Work.MgQuarterExamI("Nur",listno,id),-1) q:id=""  d
	..s obj=##class(DHCNMG.Work.MgQuarterExam).%OpenId(id)
	..q:((stdate'="")&&(stdate>obj.TestDate))||((enddate'="")&&(enddate<obj.TestDate))
	..q:'$IsObject(obj)
	..s ret="RowID|"_obj.%Id()
	..s ret=ret_"^ScoreStaArea|"_obj.ScoreStaArea
	..s ScoreStaAreaName=""
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ScoreStaArea)
	..i $IsObject(wardObj) s ScoreStaAreaName=wardObj.WardDesc
	..s ret=ret_"^ScoreStaAreaName|"_ScoreStaAreaName
	..s ret=ret_"^TestNur|"_obj.TestNur
	..s TestNurName=""
	..s NurObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.TestNur)
	..i $IsObject(NurObj) s TestNurName=NurObj.PerName
	..s ret=ret_"^TestNurName|"_TestNurName
	..s Date=$zd(obj.TestDate,3)
	..s ret=ret_"^TestDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.TestDate)
	..s ret=ret_"^TestQuarter|"_obj.TestQuarter
	..s TestQuarterName=""
	..s TestQuarterObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.TestQuarter)
	..i $IsObject(TestQuarterObj) s TestQuarterName=TestQuarterObj.SubDesc
	..s ret=ret_"^TestQuarterName|"_TestQuarterName
	..s ret=ret_"^TestValue|"_obj.TestValue
	..s TestValueName=""
	..s TestValueObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.TestValue)
	..i $IsObject(TestValueObj) s TestValueName=TestValueObj.SubDesc
	..s ret=ret_"^TestValueName|"_TestValueName
	..s ret=ret_"^Reason|"_obj.Reason
	..s ReasonName=""
	..s ReasonObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.Reason)
	..i $IsObject(ReasonObj) s ReasonName=ReasonObj.SubDesc
	..s ret=ret_"^ReasonName|"_ReasonName_"^TestScore|"_obj.TestScore
	..d OutQuarterTest
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuarterTest
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOutputQuarterTestDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutputQuarterTestDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOutputQuarterTestDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutputQuarterTestDataExecute ]
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

/// Creator:liuning
/// Description:修改护士季度考试成绩
/// Date:2018年10月29日
/// Table:DHCNMG.Work.MgQuarterExam
/// Input:
/// Output：
/// Return:
/// Others:zw ##class(web.NurMgTechnicalComm).GetTestSta("1847")
ClassMethod GetTestSta(parr As %String = "") As %String
{
	q:parr="" ""
	s staid=$o(^DHCNMG.Work.MgQuarterExamI("Nur"," "_parr,""))
	s obj=##class(DHCNMG.Work.MgQuarterExam).%OpenId(staid)
	q:'$IsObject(obj) ""
	s ScoreStaArea=obj.ScoreStaArea
	s TestQuarter=obj.TestQuarter
	s TestNur=obj.TestNur
	s TestDateOld=obj.TestDate
	s TestScore=obj.TestScore
    s TestValue=obj.TestValue
    s Reason=obj.Reason
    s TestDate=##class(web.NurMgHISComm).DateLogicalToHtml(TestDateOld)
    s RowID=staid
    s ret="ScoreStaArea|+"_ScoreStaArea_"^TestQuarter|+"_TestQuarter_"^TestNur|+"_TestNur_"^TestValue|+"_TestValue_"^TestDate|+"_TestDate_"^TestScore|+"_TestScore_"^Reason|+"_Reason_"^RowID|+"_RowID
    q ret
}

}
