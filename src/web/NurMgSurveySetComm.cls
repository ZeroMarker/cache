/// 
/// 
/// 护理调查管理公共类
Class web.NurMgSurveySetComm Extends %RegisteredObject
{

ClassMethod GetSystemParam(par As %String) As %String
{
	s RowID=$o(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt($tr(par," ",""),"U"),""))
	q:RowID="" ""
	w "["
	s n=0
	s sort="" f  s sort=$o(^DHCNMG.Set.MgSysParamSubI("Sort",RowID,sort)) q:sort=""  d
	.s Rw="" f  s Rw=$o(^DHCNMG.Set.MgSysParamSubI("Sort",RowID,sort,Rw)) q:Rw=""  d
	..s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(RowID_"||"_Rw)
	..s n=n+1
	..i n=1 w "{""desc"":"""_obj.SubDesc_""",""id"":"""_RowID_"||"_Rw_"""}"
	..e  w ",{""desc"":"""_obj.SubDesc_""",""id"":"""_RowID_"||"_Rw_"""}"
	w "]"
	q ""
}

ClassMethod SaveSurverySet(parr As %String, radios As %String, inputs As %String, user As %String) As %String
{
	s ^TMP("SaveSurverySet")=parr_"%"_radios_"%"_inputs_"%"_user
	//TypeForm|12||1^TypeStDate|2018-09-21^TypeTitle|标题^TypeExplanation|说明^RowID|
	//%测试|」选项||12ˇ选项2||12ˇ选项3||12^测试2|」选项4||2ˇ选项5||2ˇ选项6||2^测试5|」
	//%测试3|^测试4|
	//%0
	s flag=1
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	TS
	i id="" s obj=##class(DHCNMG.DB.MgNurSurveyType).%New()
	e  s obj=##class(DHCNMG.DB.MgNurSurveyType).%OpenId(id)
	s obj.TypeForm=$g(tmp("TypeForm"))
	i $g(tmp("TypeStDate"))'="" s obj.TypeStDate=$zdh($g(tmp("TypeStDate")),3)
	e  s obj.TypeStDate=""
	s obj.TypeTitle=$zcvt($tr($g(tmp("TypeTitle"))," ",""),"U")
	s obj.TypeExplanation=$zcvt($tr($g(tmp("TypeExplanation"))," ",""),"U")
	s obj.CreateUser=user
	s obj.Status="Y"
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	///清除子表数据
	s deleteSubId="" f  s deleteSubId=$o(^DHCNMG.DB.MgNurSurveyTypeSubD(obj.%Id(),deleteSubId)) q:deleteSubId=""  d
	.s deleteSubObj=##class(DHCNMG.DB.MgNurSurveyTypeSub).%OpenId(obj.%Id()_"||"_deleteSubId)
	.s deleteSubSc=deleteSubObj.%DeleteId(obj.%Id()_"||"_deleteSubId)
	.s flag=($$$ISOK(deleteSubSc)&&flag)
	.i flag=1 d
	..s CheckRw="" f  s CheckRw=$o(^DHCNMG.DB.MgNurSurveyCheck(obj.%Id(),deleteSubId,CheckRw)) q:CheckRw=""  d
	...s deleteCheckObj=##class(DHCNMG.DB.MgNurSurveyCheck).%OpenId(obj.%Id()_"||"_deleteSubId_"||"_CheckRw)
	...s deleteCheckSc=deleteCheckObj.%DeleteId(obj.%Id()_"||"_deleteSubId_"||"_CheckRw)
	...s flag=($$$ISOK(deleteCheckSc)&&flag)
	///保存子表数据
	i flag=1
	{
		s len=$l(radios,"^")
		//测试|」选项||12ˇ选项2||12ˇ选项3||12^测试2|」选项4||2ˇ选项5||2ˇ选项6||2^测试5|」
		f i=1:1:len
		{
			s itm=$p(radios,"^",i)
			i itm="" continue
			s subObj=##class(DHCNMG.DB.MgNurSurveyTypeSub).%New()
			s subObj.Parref=##class(DHCNMG.DB.MgNurSurveyType).%OpenId(obj.%Id())
			s subObj.ItemOption=$p($p(itm,"」",1),"|",1)
			s subObj.ItemType="R"
			s subSc=subObj.%Save()
			s flag=($$$ISOK(subSc)&&flag)
			i flag=1
			{
				s subLen=$l($p(itm,"」",2),"ˇ")
				f j=1:1:subLen
				{
					s subItem=$p($p(itm,"」",2),"ˇ",j)
					i subItem="" continue
					s CheckObj=##class(DHCNMG.DB.MgNurSurveyCheck).%New()
					s CheckObj.Parref=##class(DHCNMG.DB.MgNurSurveyTypeSub).%OpenId(subObj.%Id())
					s CheckObj.CheckItem=$p(subItem,"|",1)
					s CheckObj.CheckScore=$p(subItem,"|",3)
					s CheckSc=CheckObj.%Save()
					s flag=($$$ISOK(CheckSc)&&flag)
				}
			}
		}
		s inputLen=$l(inputs,"^")
		//%测试3|^测试4|
		f k=1:1:inputLen
		{
			s inputItm=$p(inputs,"^",k)
			i inputItm="" continue
			s ItmObj=##class(DHCNMG.DB.MgNurSurveyTypeSub).%New()
			s ItmObj.Parref=##class(DHCNMG.DB.MgNurSurveyType).%OpenId(obj.%Id())
			s ItmObj.ItemOption=$p(inputItm,"|",1)
			s ItmObj.ItemType="W"
			s ItmSc=ItmObj.%Save()
			s flag=($$$ISOK(ItmSc)&&flag)
		}
	}
	i flag=1
	{
		TC
	}
	else
	{
		Tro	
	}
	q flag
}

/// Creator:guozj
/// Description:
/// Date:
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgSurveySetComm","FindSurverySet","")
Query FindSurverySet(parr As %String, nurseId As %String, roles As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurverySetExecute(ByRef qHandle As %Binary, parr As %String, nurseId As %String, roles As %String) As %Status
{
	s ^TMP("FindSurverySet")=parr_"%"_nurseId_"%"_roles
	s repid=$I(^CacheTemp)
	s ind=1
	s date="" f  s date=$o(^DHCNMG.DB.MgNurSurveyTypeI("Date",date),-1) q:date=""  d
	.s rowId="" f  s rowId=$o(^DHCNMG.DB.MgNurSurveyTypeI("Date",date,rowId),-1) q:rowId=""  d
	..s obj=##class(DHCNMG.DB.MgNurSurveyType).%OpenId(rowId)
	..s TypeTile=obj.TypeTitle
	..q:((parr'="")&&(obj.TypeForm'=parr))
	..q:((nurseId'="")&&(obj.CreateUser'=nurseId))
	..s TypeForm=""
	..i obj.TypeForm'="" d
	...s ParamObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(obj.TypeForm)
	...q:'$IsObject(ParamObj)
	...s TypeForm=ParamObj.SubDesc
	..s ret="TypeTile|"_TypeTile_"^TypeForm|"_TypeForm_"^RowID|"_rowId
	..d OutputSurverySet
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSurverySet
	
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSurverySetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurverySetExecute ]
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

ClassMethod FindSurverySetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurverySetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSurverySetData(rowId As %String) As %String
{
	q:rowId="" ""
	w "["
	s obj=##class(DHCNMG.DB.MgNurSurveyType).%OpenId(rowId)
	s TypeForm=obj.TypeForm
	i obj.TypeStDate'="" s TypeStDate=$zd(obj.TypeStDate,3)
    s TypeTitle=obj.TypeTitle
    s TypeExplanation=obj.TypeExplanation
    w "{""TypeForm"":"""_TypeForm_""",""TypeStDate"":"""_TypeStDate_""",""TypeTitle"":"""_TypeTitle_""",""TypeExplanation"":"""_TypeExplanation_""",""RowID"":"""_rowId_""",""radios"":["
    s count=0,count1=0
    s Rw="" f  s Rw=$o(^DHCNMG.DB.MgNurSurveyTypeSubD(rowId,Rw)) q:Rw=""  d
    .s SubObj=##class(DHCNMG.DB.MgNurSurveyTypeSub).%OpenId(rowId_"||"_Rw)
    .q:'$IsObject(SubObj)
    .s ItemOption=SubObj.ItemOption
    .s ItemType=SubObj.ItemType
    .q:ItemType'="R"
    .s count=count+1
    .s checks=..GetItemChecks(rowId,Rw)
    .i count=1 w "{""label"":"""_ItemOption_""",""value"":"""_rowId_"__"_Rw_""",""children"":"_checks_"}"
    .e  w ",{""label"":"""_ItemOption_""",""value"":"""_rowId_"__"_Rw_""",""children"":"_checks_"}"
    w "],""inputs"":["
    s count1=0
    s Rw1="" f  s Rw1=$o(^DHCNMG.DB.MgNurSurveyTypeSubD(rowId,Rw1)) q:Rw1=""  d
    .s SubObj1=##class(DHCNMG.DB.MgNurSurveyTypeSub).%OpenId(rowId_"||"_Rw1)
    .q:'$IsObject(SubObj1)
    .s ItemOption1=SubObj1.ItemOption
    .s ItemType1=SubObj1.ItemType
    .q:ItemType1'="W"
    .s count1=count1+1
    .i count1=1 w "{""label"":"""_ItemOption1_""",""value"":"""_rowId_"__"_Rw1_"""}"
    .e  w ",{""label"":"""_ItemOption1_""",""value"":"""_rowId_"__"_Rw1_"""}"
    w "]"
    w "}]"
	q ""
}

ClassMethod GetItemChecks(par As %String, rw As %String) As %String
{
	q:((par="")!(rw="")) "[]"
	s ret=""
	s count=0
	s RowID="" f  s RowID=$o(^DHCNMG.DB.MgNurSurveyCheckD(par,rw,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgNurSurveyCheck).%OpenId(par_"||"_rw_"||"_RowID)
	.q:'$IsObject(obj)
	.s CheckItem=obj.CheckItem
	.s CheckScore=obj.CheckScore
	.s count=count+1
	.i ret="" s ret="{""label"":"""_CheckItem_""",""score"":"""_CheckScore_""",""value"":"""_par_"__"_rw_"__"_RowID_"""}"
	.e  s ret=ret_",{""label"":"""_CheckItem_""",""score"":"""_CheckScore_""",""value"":"""_par_"__"_rw_"__"_RowID_"""}"
	s ret="["_ret_"]"
	q ret
}

ClassMethod GetSurveyListStore(nurseId As %String, surveyType As %String) As %String
{
	q:nurseId="" "[]"
	w "["
	s count=0
	s rowId="" f  s rowId=$o(^DHCNMG.DB.MgNurSurveyTypeI("USER"," "_$tr(nurseId," ",""),rowId),-1) q:rowId=""  d
	.s obj=##class(DHCNMG.DB.MgNurSurveyType).%OpenId(rowId)
	.s TypeForm=obj.TypeForm
	.q:((surveyType'="")&&(TypeForm'=surveyType))
	.s SurveyTitle=obj.TypeTitle
	.s count=count+1
	.i count=1 w "{""label"":"""_SurveyTitle_""",""value"":"""_rowId_"""}"
	.e  w ",{""label"":"""_SurveyTitle_""",""value"":"""_rowId_"""}"
	w "]"
	q ""
}

/// 加载调查病区
ClassMethod GetSurveyWard() As %String
{
	w "["
	s count=0
	s sort="" f  s sort=$o(^DHCNMG.DB.MgWardI("Sort",sort)) q:sort=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgWardI("Sort",sort,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(RowID)
	..q:'$IsObject(obj)
	..s WardDesc=obj.WardDesc
	..s count=count+1
	..i count=1 w "{""WardDesc"":"""_WardDesc_""",""WardID"":"""_RowID_"""}"
	..e  w ",{""WardDesc"":"""_WardDesc_""",""WardID"":"""_RowID_"""}"
	w "]"
	q ""
}

/// 获取调查人员列表 按照病区查询
ClassMethod GetSurveyNurse(ward As %String) As %String
{
	q:ward="" "[]"
	s count=0
	s sort="" f  s sort=$o(^DHCNMG.DB.MgWardI("Sort",sort)) q:sort=""  d
	.s WardID="" f  s WardID=$o(^DHCNMG.DB.MgWardI("Sort",sort,WardID)) q:WardID=""  d
	..q:((ward'="")&&(WardID'=ward))
	..s NurseID="" f  s NurseID=$o(^DHCNMG.HR.MgPersonsI("DepID"," "_WardID,NurseID)) q:NurseID=""  d
	...s obj=##class(DHCNMG.HR.MgPersons).%OpenId(NurseID)
	...s NurseName=obj.PerName
	...s WardDesc=""
	...s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(WardID)
	...q:'$IsObject(WardObj)
	...s WardDesc=WardObj.WardDesc
	...s count=count+1
	...i count=1 w "{""WardDesc"":"""_WardDesc_""",""NurseName"":"""_NurseName_""",""NurseID"""_NurseID_"""}"
	...e  w ",{""WardDesc"":"""_WardDesc_""",""NurseName"":"""_NurseName_""",""NurseID"""_NurseID_"""}"
	w "]"
	q ""
}

}
