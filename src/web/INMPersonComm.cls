/// Creator：gzj
/// Description：Vue版人力资源公共类 
/// Date：2020-07-08
Class web.INMPersonComm Extends %RegisteredObject
{

/// Creator:wangcc
/// Description:查询人员列表
/// Date:2019-10-08
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindPersons","!!PerComeYear|7!0!0")
Query FindPersons(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",rettmp=""
	s tmp=""
	s tmpWard=""
	s tmpSearch=""
	s searchLoc=$P(parr,"!",1)
	s searchWard=$P(parr,"!",2)
	s values=$P(parr,"!",3)
	s role=$P(parr,"!",4)
	s nurseid=$P(parr,"!",5)
	d ##class(web.INMVueComm).SplitStr(values,"^","|",.tmpSearch)
	s menuId=$O(^CT.DHCINM.Set.MgMenuI("Code"," PERSONLIST",""))
	;s quitKey=$LB("PerComeYear","PerAge","PerSpeciNurse","PerLevel","PerHireDuty","PerPostDuty","PerCurrentAcade")
	s oneFlag=0
	; 根据当前登录用户所属最高级别角色, 角色级别4是分水岭
	s:..GetMaxRoleLevel(nurseid)>4 oneFlag=1
	s isAll=0
	s:oneFlag=1 perId=$lg(^CF.DHCINM.DB.MgUserD(nurseid),5)
	; 获取当前登陆用户的所辖病区
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s tmpProperty=""
	; 这个是查询出Persons的Storage里面所有属性列表
	s keyIndex="" f  s keyIndex=$O(^oddCOM("CF.DHCINM.HR.Persons","s","Default","D","PersonsDefaultData","V",keyIndex)) q:keyIndex=""  d
	.s property=$g(^oddCOM("CF.DHCINM.HR.Persons","s","Default","D","PersonsDefaultData","V",keyIndex,21))
	.q:property=""
	.q:property["%"
	.s tmpProperty(property)=keyIndex
	
	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgWardI("Sort",sort)) q:sort=""  d
	.s wardId="" f  s wardId=$O(^CF.DHCINM.DB.MgWardI("Sort",sort,wardId)) q:wardId=""  d
	..q:(searchWard'="")&&(searchWard'=wardId)
	..q:(isAll'=1)&&('$d(tmpWard(wardId)))
	..s rowId="" f  s rowId=$O(^CF.DHCINM.HR.PersonsI("DepID"," "_wardId,rowId)) q:rowId=""  d
	...q:(oneFlag=1)&&(perId'=rowId)
	...;s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	...s objLB=$G(^CF.DHCINM.HR.PersonsD(rowId))
	...q:objLB=""
	...s PerTypeDR=$LG(objLB,25)
	...q:(PerTypeDR'="N")
	...q:##class(web.INMHRComm).IsFormalWorkNur(rowId,+$h,"")'=1
	...s PerLocDR=$LG(objLB,49)
	...q:(searchLoc'="")&&(PerLocDR'=searchLoc)
	...k tmpRet
	...s tmpRet=""
	...s flag=0
	...s menuSort="" f  s menuSort=$O(^CT.DHCINM.Set.MgFieldSetI("sort"," "_menuId,menuSort)) q:(menuSort="")||(flag=1)  d
	....s fieldId=""
	....s fieldId=$o(^CT.DHCINM.Set.MgFieldSetI("sort", " "_menuId, menuSort, fieldId))
	....q:fieldId=""
	....s fieldObj=$g(^CT.DHCINM.Set.MgFieldSetD(fieldId))
	....s fieldDisplay=$lg(fieldObj,8) //是否显示
	....s fieldSearch=$lg(fieldObj,11) //是否搜索
	....; 这个有啥用了，fieldDisplay="false"恒等于0，global位置8是LockPos取值是-1/0/1---chenpeng
	....q:(fieldDisplay="false")&&(fieldSearch="false") 
	....s fieldCode=$lg(fieldObj,4) //列表配置代码
	....q:$O(^oddCOM("CF.DHCINM.HR.Persons","a",fieldCode,""))=""
	....q:fieldCode["PerDepDR"
	....s searchValue=$g(tmpSearch(fieldCode))
	....s propertyIndex=$g(tmpProperty(fieldCode))
	....q:propertyIndex=""
	....s realValue=$LG(objLB,propertyIndex) // 字段值
	....s tmpRet(fieldCode)=realValue
	....s fieldType=$lg($g(^CT.DHCINM.Set.MgFieldSetD(fieldId)),10) //字段类型--其实表单组件类型
	....i fieldType="select" d
	.....s:(searchValue'="")&&((","_searchValue_",")'[(","_realValue_",")) flag=1
	.....s tmpRet(fieldCode)=..GetCommCode(realValue)
	....e  i fieldType="input" d
	.....s spell=##class(web.INMVueComm).ToChineseSpell(realValue)
	.....s:(searchValue'="")&&((realValue_","_spell)'[($zcvt(searchValue,"U"))) flag=1
	....e  i fieldType="yesno" d
	.....s:(searchValue'="")&&(searchValue'=realValue) flag=1
	.....s tmpRet(fieldCode)=$case(realValue,"1":"是","0":"否",:"")
	....e  i fieldType="date" d
	.....s:(searchValue'="")&&((realValue>$zdh($p(searchValue,",",2),3))||(realValue<$zdh($p(searchValue,",",1),3))) flag=1
	.....s tmpRet(fieldCode)=##class(web.INMHISComm).DateLogicalToHtmlNew(realValue)
	...q:flag=1
	...s tmpRet("PerDepDR")=$lg(^CF.DHCINM.DB.MgWardD(wardId),4) //病区
	...s PerAuditFlag=$LG(objLB,35)
	...s tmpRet("PerAuditFlag")=$case(PerAuditFlag,"Y":"已审核","B":"已驳回","N":"已保存",:"") //审核状态
	...s PerComeYear="" //年资
	...s PerComeDate=$LG(objLB,12)
	...i PerComeDate'="" d
	....s comeyear=##class(web.INMVueComm).CalAge($zd(PerComeDate,3),$zd(+$H,3))
	....s PerComeYear=$p(comeyear,"Y",1)
	...q:..GetPersonFlag($g(tmpSearch("PerComeYear")),PerComeYear)=1
	...s tmpRet("PerComeYear")=PerComeYear
	...s PerAge="" //年龄
	...s PerBirthday=$LG(objLB,6)
	...i PerBirthday'="" d
	....s age=##class(web.INMVueComm).CalAge($zd(PerBirthday,3),$zd(+$H,3))
	....s PerAge=$p(age,"Y",1)
	...s tmpRet("PerAge")=PerAge
	...s tmpRet("PerSpeciNurse")="" //专科护士
	...s specialId="" f  s specialId=$o(^DHCINM.Special.SpecialNurseI("Person",rowId,specialId)) q:specialId=""  d
	....s status=$lg(^DHCINM.Special.SpecialNurseD(specialId),7)
	....q:status'="A"
	....s tmpRet("PerIsSpeciNurse")=1
	....s:tmpRet("PerSpeciNurse")'="" tmpRet("PerSpeciNurse")=tmpRet("PerSpeciNurse")_","_$lg(^DHCINM.Special.SpecialNurseD(specialId),15) //专科类型
	....s:tmpRet("PerSpeciNurse")="" tmpRet("PerSpeciNurse")=$lg(^DHCINM.Special.SpecialNurseD(specialId),15) //专科类型
	...q:($g(tmpSearch("PerIsSpeciNurse"))'="")&&($g(tmpSearch("PerIsSpeciNurse"))'=tmpRet("PerIsSpeciNurse"))
	...q:($g(tmpSearch("PerSpeciNurse"))'="")&&($g(tmpRet("PerSpeciNurse"))'[tmpSearch("PerSpeciNurse"))
	...s Level=##class(web.INMHRComm).GetNurseLevel(rowId,+$h) //层级 
	...s PerLevel=$p(Level,"^",1)
	...q:..GetPersonFlag($g(tmpSearch("PerLevel")),PerLevel)=1
	...s tmpRet("PerLevel")=..GetCommCode(PerLevel)
	...s HireDuty=##class(web.INMHRComm).GetNurseHireDuty(rowId,+$h) //职称
	...s PerHireDuty=$p(HireDuty,"^",1)
	...q:..GetPersonFlag($g(tmpSearch("PerHireDuty")),PerHireDuty)=1
	...s PerHireDutyStDate=$p(HireDuty,"^",3)
	...q:..GetDateRangeFlag($g(tmpSearch("PerHireDutyStDate")),PerHireDutyStDate)=1  //职称取得日期
	...s tmpRet("PerHireDuty")=..GetCommCode(PerHireDuty)
	...s tmpRet("PerHireDutyStDate")=##class(web.INMHISComm).DateLogicalToHtmlNew(PerHireDutyStDate)
	...s MajorDuty=$p(HireDuty,"^",4)
	...s MajorDutyDate=$p(HireDuty,"^",6)
	...;专业技术职称的暂时不写
	...q:..GetPersonFlag($g(tmpSearch("MajorDuty")),MajorDuty)=1
	...q:..GetDateRangeFlag($g(tmpSearch("MajorDutyDate")),MajorDutyDate)=1
	...s tmpRet("MajorDuty")=..GetCommCode(MajorDuty)
	...s tmpRet("MajorDutyDate")=##class(web.INMHISComm).DateLogicalToHtmlNew(MajorDutyDate)
	...s PostDuty=##class(web.INMHRComm).GetNurseDuty(rowId,+$h) //职务
	...s PerPostDuty=$p(PostDuty,"^",1)
	...q:..GetPersonFlag($g(tmpSearch("PerPostDuty")),PerPostDuty)=1
	...s tmpRet("PerPostDuty")=..GetCommCode(PerPostDuty)
	...s Acade=##class(web.INMHRComm).GetNurseEdu(rowId,+$h) //当前学历
	...s PerCurrentAcade=$p(Acade,"^",1)
	...q:..GetPersonFlag($g(tmpSearch("PerCurrentAcade")),PerCurrentAcade)=1
	...s tmpRet("PerCurrentAcade")=..GetCommCode(PerCurrentAcade)
	...s Acade = ##class(web.INMHRComm).GetFirstNurseEdu(rowId) //最初学历
	...s PerFirstAcade=$P(Acade,"^",1)
	...q:..GetPersonFlag($g(tmpSearch("PerFirstAcade")),PerFirstAcade)=1
	...s tmpRet("PerFirstAcade")=..GetCommCode(PerFirstAcade)
	...s FirstEduDegreeDate=$P(Acade,"^",3) ;第一学历取得时间
	...s searchFirstEduDegreeDate=$g(tmpSearch("FirstEduDegreeDate"))
	...q:(searchFirstEduDegreeDate'="")&&(FirstEduDegreeDate="")
	...q:(searchFirstEduDegreeDate'="")&&((FirstEduDegreeDate>$zdh($p(searchFirstEduDegreeDate,",",2),3))||(FirstEduDegreeDate<$zdh($p(searchFirstEduDegreeDate,",",1),3)))
	...s tmpRet("FirstEduDegreeDate")=##class(web.INMHISComm).DateLogicalToHtmlNew(FirstEduDegreeDate)
	...s tmpRet("PerNativePlace")=$LG(objLB,116)
	...s NativeProvince=$lg(objLB,111)
	...s NativeCity=$lg(objLB,112)
	...s NativeArea=$lg(objLB,123)
	...s NativeAddress=$lg(objLB,113)
	...s:NativeProvince["请选择" NativeProvince=""
	...s:NativeCity["请选择" NativeCity=""
	...s:NativeArea["请选择" NativeArea=""
	...s:NativeProvince=NativeCity NativeProvince=""
	...s tmpRet("NativeAddress")=NativeProvince_NativeCity_NativeArea_NativeAddress
	...s ret="rowid|"_rowId
	...s desc="" f  s desc=$O(tmpRet(desc)) q:desc=""  d
	....s ret=ret_"^"_desc_"|"_tmpRet(desc)
	...s ret=ret_"^PerPic|"_$LG(objLB,34)
	...d OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonsExecute ]
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

ClassMethod FindPersonsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckHireDuty(id, duty) As %String
{
	s flag=0
	s rw="" f  s rw=$O(^CF.DHCINM.HR.HireDutyI("ssid",id,rw)) q:rw=""  d
	.i rw'="" d
	..s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(rw)
	..;i ((duty'="")&&(obj.HireDuty=duty)) s flag=1
	..i ((duty'="")&&(duty[obj.HireDuty)) s flag=1
	q flag
}

ClassMethod CheckPost(id, post) As %String
{
	s flag=0
	s rw="" f  s rw=$O(^CF.DHCINM.HR.PostDutyI("ssid",id,rw)) q:rw=""  d
	.i rw'="" d
	..s obj=##class(CF.DHCINM.HR.PostDuty).%OpenId(rw)
	..;i ((post'="")&&(obj.PostDuty=post)) s flag=1
	..i ((post'="")&&(post[obj.PostDuty)) s flag=1
	q flag
}

ClassMethod CheckLevel(id, level) As %String
{
	s flag=0
	s rw="" f  s rw=$O(^CF.DHCINM.HR.MgLevelI("ssid",id,rw)) q:rw=""  d
	.i rw'="" d
	..s obj=##class(CF.DHCINM.HR.MgLevel).%OpenId(rw)
	..;i ((level'="")&&(obj.NurLevel=level)) s flag=1
	..i ((level'="")&&(level[obj.NurLevel)) s flag=1
	q flag
}

ClassMethod CheckEdu(id, eduVal, radio) As %String
{
	s flag=0
	s rw="" f  s rw=$O(^CF.DHCINM.HR.EducateI("ssid",id,rw)) q:rw=""  d
	.i rw'="" d
	..s obj=##class(CF.DHCINM.HR.Educate).%OpenId(rw)
	..;i ((eduVal'="")&&(obj.EduAcademic=eduVal)&&(obj.EduRadio=radio)) s flag=1
	..i ((eduVal'="")&&(eduVal[obj.EduAcademic)&&(obj.EduRadio=radio)) s flag=1
	q flag
}

/// Creator:guozj
/// Description:获取人员信息
/// Date:2017-07-10
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetPerson(id As %String) As %String
{
	s ^TMP("sid")=id
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	s ret="",tmp=""
	// 护理档案基本信息的字典编码属性列表--chenpeng
	s dictProps = $ListBuild("PerSexDR", "PerNation", "PerPolitical", "PerMarriage", "PerClothesNo",
		"PerTrouserNo", "PerShoesNo", "Relationship",  "PerForeignLevel", "PerSource", "PerAttriDepart",
		"PerInNursePost", "PerPostName", "PerPostType", "PerPostCategory")
	s exclusionList=$ListBuild("PerOperate")
	// 以下属性是不在Persons持久类里面的，这将在后面重复调用GetCommCode进行处理
	// "PerNurseLevel" "PerInitialAcade", "PerInitialSchool", "PerInitialDegree",
	// "PerCurrentAcade", "PerCurrentSchool", "PerCurrentDegree", "PerHireDuty", "PerPostDuty"
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.Persons","a",p)) q:p=""  d
	.q:p["%"
	.i p="PerSpeciNurse" d
	..s specinurses=obj.PerSpeciNurse
	..s len=obj.PerSpeciNurse.Count()
	..s ret=""
	..f l=1:1:len d
	...s itm=obj.PerSpeciNurse.GetAt(l)
	...q:itm=""
	...i ret="" s ret=itm
	...e  s ret=ret_","_itm
	..s tmp(p)=ret
	.e  s tmp(p)=$ZOBJPROPERTY(obj,p)
	.q:$lf(exclusionList,p)>0
	.s ptype=^oddCOM("CF.DHCINM.HR.Persons","a",p,"P","XSDTYPE")
	.i ((ptype="date")&&(tmp(p)'="")) d
	..s tmp(p)=##class(web.INMHISComm).DateLogicalToHtml(tmp(p))
	.i $lf(dictProps, p)>0 d
	..s tmp(p_"Desc")=..GetCommCode($ZOBJPROPERTY(obj, p))
	s k=""
	f {
		s k=$O(tmp(k))
		q:k=""
		i k="PerPassword" continue
		s ret=ret_k_"|"_tmp(k)_"^"
	}
	s PerAge="",ResignDate="",PerNurTime=""
	s PerNurTime=+$h-obj.PerComeDate
	i obj.PerBirthday'="" d
	.s age=##class(web.INMVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
	.s PerAge=$p(age,"Y",1)
	.s ResignDate=$zd((obj.PerBirthday)+(55*365),3)
	//获取层级信息
	s Level=##class(web.INMHRComm).GetNurseLevel(id,+$h) //层级 
	s PerLevel=$p(Level,"^",1)
	s PerNurseLevelDesc=..GetCommCode(PerLevel)
	s ret=ret_"^PerNurseLevel|"_PerLevel
	//获取职称信息
	s HireDuty=##class(web.INMHRComm).GetNurseHireDuty(id,+$h) //职称
	s PerHireDuty=$p(HireDuty,"^",1),PerHireDutyDate=$p(HireDuty,"^",3)
	s:PerHireDutyDate'="" PerHireDutyDate=$zd(PerHireDutyDate,3)
	s PerHireDutyDesc=..GetCommCode(PerHireDuty)
	//获取职务信息
	s PostDuty=##class(web.INMHRComm).GetNurseDuty(id,+$h) //职务
	s PerPostDuty=$p(PostDuty,"^",1),PerPostDutyDate=$p(PostDuty,"^",3)
	s:PerPostDutyDate'="" PerPostDutyDate=$zd(PerPostDutyDate,3)
	s PerPostDutyDesc=..GetCommCode(PerPostDuty)
	//获取当前学历
	s PerCurrentAcade="",PerCurrentSchool="",PerCurrentDegree="",EduFlag=0
	s PerCurrentAcadeDesc="", PerCurrentSchoolDesc="", PerCurrentDegreeDesc=""
	s PerHighAcade="" 
	s EduDate="" f  s EduDate=$O(^CF.DHCINM.HR.EducateI("flag",id,EduDate),-1) q:(EduDate="")||(EduFlag=1)  d
	.s EduRowID=$O(^CF.DHCINM.HR.EducateI("flag",id,EduDate,""))
	.s EduObj=##class(CF.DHCINM.HR.Educate).%OpenId(EduRowID)
	.q:'$IsObject(EduObj)
	.q:EduObj.EduStatus'="A"
	.s PerCurrentAcade=EduObj.EduAcademic
	.s PerCurrentSchool=EduObj.EduSchool
	.s PerCurrentDegree=EduObj.EduDegree
	.s PerCurrentAcadeDesc=..GetCommCode(PerCurrentAcade)
	.s PerCurrentSchoolDesc=..GetCommCode(PerCurrentSchool)
	.s PerCurrentDegreeDesc=..GetCommCode(PerCurrentDegree)
	.s EduFlag=1
	//获取最初学历
	s PerInitailAcade="",PerInitailSchool="",PerInitailDegree="",EduFlag=0
	s PerInitialAcadeDesc="", PerInitialSchoolDesc="", PerInitialDegreeDesc=""
	s EduDate="" f  s EduDate=$O(^CF.DHCINM.HR.EducateI("flag",id,EduDate),1) q:(EduDate="")||(EduFlag=1)  d
	.s EduRowID=$O(^CF.DHCINM.HR.EducateI("flag",id,EduDate,""))
	.s EduObj=##class(CF.DHCINM.HR.Educate).%OpenId(EduRowID)
	.q:'$IsObject(EduObj)
	.q:EduObj.EduStatus'="A"
	.s PerInitailAcade=EduObj.EduAcademic
	.s PerInitailSchool=EduObj.EduSchool
	.s PerInitailDegree=EduObj.EduDegree
	.s PerInitialAcadeDesc=..GetCommCode(PerInitailAcade)
	.s PerInitialSchoolDesc=..GetCommCode(PerInitailSchool)
	.s PerInitialDegreeDesc=..GetCommCode(PerInitailDegree)
	.s EduFlag=1
	// 获取专科护士
	s speDesc=""
	s speid="" f  s speid=$o(^DHCINM.Special.SpecialNurseI("Person",id,speid))  q:speid=""  d
	.s speObj=##class(DHCINM.Special.SpecialNurse).%OpenId(speid)
	.q:'$IsObject(speObj)
	.q:speObj.SpecialStatus'="A"
	.q:speObj.SpecialNurType=""
	.s speDesc=speDesc_","_..GetCommCode(speObj.SpecialNurType.%Id())
	// 获取执业资格证注册日期
	s regDate="",endDate=""
	s regId="" f  s regId=$o(^DHCINM.HR.MgQualRegistedI("Assid"," "_id," A",regId))  q:regId=""  d
	.s regObj=##class(DHCINM.HR.MgQualRegisted).%OpenId(regId)
	.q:'$IsObject(regObj)
	.s regDate=$zd(regObj.RegistedDate,3)
	.s endDate=regObj.RegistedValidDate
	.i (endDate="")&&(regDate'="") d
	..s endDate=##class(web.INMCommon).GetAfterNYearDate(regObj.RegistedDate,5)
	.s:endDate'="" endDate=$zd(endDate,3)
	s PerSocialWork="", PerSocialWorkDesc="", PerSocialWorkType=""
	s socialWorkId="" f  s socialWorkId=$O(^DHCINM.HR.MgNurSocialWorkI("ssid"," "_id,socialWorkId)) q:socialWorkId=""  d
	.s socialWorkObj=##class(DHCINM.HR.MgNurSocialWork).%OpenId(socialWorkId)
	.q:'$IsObject(socialWorkObj)
	.q:socialWorkObj.WorkStatus'="A"
	.q:((socialWorkObj.WorkStDate'="")&&(socialWorkObj.WorkStDate>+$H))
	.q:((socialWorkObj.WorkEndDate'="")&&(socialWorkObj.WorkEndDate<+$H))
	.s PerSocialWork=socialWorkObj.WorkUnit
	.s PerSocialWorkType=socialWorkObj.WorkType
	.; issue:2793905:要先判断是否为院内兼职(65||1)，若是就将其翻译为科室名称，否则直接返回
	.; 院内兼职的字典值目前是65||1，如果配置的不是65||1，需要修改下面第二行代码中的判断值
	.i PerSocialWork'=""  d
	..i ..GetCommCode(PerSocialWorkType)="院内兼职" d
	...s gPerPartTimeLoc=$g(^DHCINM.HR.MgPartTimeLocD(PerSocialWork))
	...q:gPerPartTimeLoc=""
	...s PerPartTimeLoc=$lg(gPerPartTimeLoc,2)
	...s PerSocialWorkDesc=$lg($g(^CF.DHCINM.DB.MgWardLocD(PerPartTimeLoc)),3)
	..e  s PerSocialWorkDesc=PerSocialWork
	// 获取当前病区描述
	s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.PerDepDR)
	i '$IsObject(wardObj) d
	.s PerDepDRDesc=""
	e  d
	.s PerDepDRDesc=wardObj.WardDesc
	
	s ret=ret_"^RowID|"_id_"^PerAge|"_PerAge_"^PerHireDuty|"_PerHireDuty_"^PerHireDutyDate|"_PerHireDutyDate
	_"^PerPostDuty|"_PerPostDuty_"^PerPostDutyDate|"_PerPostDutyDate_"^PerCurrentAcade|"
	_PerCurrentAcade_"^PerCurrentSchool|"_PerCurrentSchool_"^PerCurrentDegree|"_PerCurrentDegree
	_"^PerInitialAcade|"_PerInitailAcade_"^PerInitialSchool|"_PerInitailSchool
	_"^PerInitialDegree|"_PerInitailDegree_"^PerIsSpeciNurse|"_$e(speDesc,2,*)
	_"^PerRegRegiDate|"_regDate_"^PerRegValidDate|"_endDate_"^PerLRetireDate|"_ResignDate
	_"^PerNurTime|"_PerNurTime_"^PerSocialWork|"_PerSocialWork_"^PerSocialWorkDesc|"_PerSocialWorkDesc
	_"^PerNurseLevelDesc|"_PerNurseLevelDesc_"^PerHireDutyDesc|"_PerHireDutyDesc
	_"^PerPostDutyDesc|"_PerPostDutyDesc_"^PerCurrentAcadeDesc|"_PerCurrentAcadeDesc
	_"^PerCurrentSchoolDesc|"_PerCurrentSchoolDesc_"^PerCurrentDegreeDesc|"_PerCurrentDegreeDesc
	_"^PerInitialAcadeDesc|"_PerInitialAcadeDesc_"^PerInitialSchoolDesc|"_PerInitialSchoolDesc
	_"^PerInitialDegreeDesc|"_PerInitialDegreeDesc_"^PerDepDRDesc|"_PerDepDRDesc
	q ret
}

/// Creator		ChenPeng
/// CreateDate	2022-01-25
/// Functions	查询护理档案操作记录列表
/// Input		id	护理档案主键
/// Output		操作记录列表
/// Table		CF.DHCINM.HR.Persons档案表 & CF.DHCINM.HR.PerOperate操作记录表
/// d ##class(%ResultSet).RunQuery("web.INMPersonComm","ListPerOperate",11)
Query ListPerOperate(id As %String) As %Query(ROWSPEC = "ret")
{
}

ClassMethod ListPerOperateExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	d PreExecuteHandler
	s perOpId="",personId=id,count=0,MAXCOUNT=10,ICONPREFIX="el-icon-"
	;只查询出最新的十条操作记录
	f  s perOpId=$o(^DHCINM.HR.MgPerOperateD(personId,perOpId),-1) q:(perOpId="")||(count>=MAXCOUNT)  d
	.s perOp=##class(DHCINM.HR.MgPerOperate).%OpenId(personId_"||"_perOpId)
	.k node
	.s node("opTime")=$zd(perOp.OpDate,3)_" "_$zt(perOp.OpTime,1)
	.i perOp.Operator="0" d
	..;这条语句是固定的，根据INMLoginComm.GetUserInfo方法里面的逻辑
	..s node("operator")="超级管理员"
	.e  d
	..s node("operator")=$lg($g(^CF.DHCINM.DB.MgUserD(perOp.Operator)),2)
	.s node("opType")=perOp.Type
	.s node("opTypeDesc")=##class(DHCINM.HR.MgPerOperate).TypeLogicalToDisplay(perOp.Type)
	.s node("comment")=perOp.Comment
	.s node("opId")=perOpId
	.;这里的图标类型配置是固定的
	.s node("vType")=$case(perOp.Type,"N":"info","U":"primary","P":"success","B":"danger","R":"warning")
	.s IconSuffix=$case(perOp.Type,"N":"plus","U":"position","P":"check","B":"close","R":"refresh")
	.s node("vIcon")=ICONPREFIX_IconSuffix
	.s ret=..PackageResp(.node)
	.s count=count+1
	.d PostProcessor
	d PostExecuteHandler
	q $$$OK
PreExecuteHandler
	s repid=$i(^CacheTemp)
	s ind=1,ret=""
	q
PostProcessor
	s ^CacheTemp(repid,ind)=$lb(ret)
	s ind=ind+1
	q
PostExecuteHandler
	s qHandle=$lb(0,repid,0)
	q
}

ClassMethod ListPerOperateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListPerOperateExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	if ind="" {
		s AtEnd=1
		s Row=""
	} else {
		s Row=$g(^CacheTemp(repid,ind))
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod ListPerOperateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListPerOperateExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator:guozj
/// Description:获取人员信息
/// Date:2017-07-10
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod GetPersonTmp(id As %String) As %String
{
	s ^TMP("persontmp")=id
	q:id="" ""
	s rowid=$O(^CF.DHCINM.HR.PersonsTmpI("PersonID"," "_id,""))
	q:rowid="" ""
	s ExclusionList=$lb("PerAuditLog")
	s obj=##class(CF.DHCINM.HR.PersonsTmp).%OpenId(rowid)
	s ret="",tmp=""
	i obj.PerAuditFlag="Y"
	{
		s pobj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
		s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.Persons","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(pobj,p)
		.q:$lf(ExclusionList,p)
		.s ptype=^oddCOM("CF.DHCINM.HR.Persons","a",p,"P","XSDTYPE")
		.i ((ptype="date")&&(tmp(p)'="")) d
		..s tmp(p)=##class(web.INMHISComm).DateLogicalToHtml(tmp(p))
		s k="" 
		f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"
		}
		;s ret=ret_"^AuditFlag|"_obj.PerAuditFlag
		
	}
	elseif ((obj.PerAuditFlag="")||(obj.PerAuditFlag="N"))
	{
		s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.PersonsTmp","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(obj,p)
		.s ptype=^oddCOM("CF.DHCINM.HR.PersonsTmp","a",p,"P","XSDTYPE")
		.i ((ptype="date")&&(tmp(p)'="")) d
		..s tmp(p)=##class(web.INMHISComm).DateLogicalToHtml(tmp(p))
		s k="" 
		f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"	
		}
	}
	else
	{
		s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.PersonsTmp","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(obj,p)
		.s ptype=^oddCOM("CF.DHCINM.HR.PersonsTmp","a",p,"P","XSDTYPE")
		.i ((ptype="date")&&(tmp(p)'="")) d
		..s tmp(p)=##class(web.INMHISComm).DateLogicalToHtml(tmp(p))
		s k="" 
		f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"	
		}
	}
	s ret=ret_"^RowID|"_rowid
	q ret
}

/// Creator:guozj
/// Description:保存人员临时信息
/// Date:2017-12-07
/// Table:CF.DHCINM.HR.PersonsTmp
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveTmp(parr As %String) As %String
{
	;s ^TMP("saveparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s nurseNo=$g(tmp("PerID"))
	s flag=-1
	i id="" d
	.i nurseNo'="" d
	..s flag=$P(..IsExistTmp(nurseNo),"^",1)
	e  d
	.i nurseNo'="" d
	..s rowid=$P(..IsExistTmp(nurseNo),"^",2)
	..i rowid'=id d
	...s flag=$P(..IsExistTmp(nurseNo),"^",1)
	q:flag=0 "此工号已经存在"
	i id="" s obj=##class(CF.DHCINM.HR.PersonsTmp).%New()
	e  s obj=##class(CF.DHCINM.HR.PersonsTmp).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.PersonsTmp","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("CF.DHCINM.HR.PersonsTmp","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..i p="PerID" s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..s tmp("PerTypeDR")="N" //人员类型（正式N  进修S 实习P 护理员W）
	..s tmp("PerCareType")="N" //医护类型（医生D 护士N）
	..s tmp("PerStatus")=##class(web.INMImportDBData).GetSetCode("在职状态","在职")
	..;i p="PerComeDate" s tmp("PerDepDate")=tmp("PerComeDate")
	..s $ZOBJPROPERTY(obj,p)=$tr(tmp(p),"__","||")
	s obj.PerDepDate=obj.PerComeDate
	s sc=obj.%Save()
	;q obj.%Id()
	q obj.PersonID
}

/// Creator:guozj
/// Description:判断人员是否存在
/// Date:2017-07-17
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod IsExistTmp(nurseno) As %String
{
	s flag=-1
	s rowid=$O(^CF.DHCINM.HR.PersonsTmpI("PerID"," "_$zcvt(nurseno,"U"),""))
	i rowid'="" d
	.s flag=0
	q flag_"^"_rowid
}

/// Creator:gzj
/// Description:保存人员信息
/// Date:2017-07-17
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod Save(parr As %String, type As %String) As %String
{
	s NoAssignProps=$lb("PerOperate")
	;在这个列表中的字段名将不会进行新旧值对比
	s NoCompareProps=$lb("RowID","PerAuditType","PerAuditDate","AuditTime","AuditReason","PerSpeciNurse",
		"PerOperate","PerPassword","RecUser","RecDate","RecTime","ImportDate","ImportUser")
	s ^TMP("g0718")=parr_"%"_type
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s nurseNo=$g(tmp("PerID"))
	s flag=-1
	i id="" d
	.i nurseNo'="" d
	..s flag=$P(..IsExist(nurseNo),"^",1)
	e  d
	.i nurseNo'="" d
	..s rowid=$P(..IsExist(nurseNo),"^",2)
	..i rowid'=id d
	...s flag=$P(..IsExist(nurseNo),"^",1)
	q:flag=0 "此工号已经存在"
	s cardId=$g(tmp("PerCardId"))
	s cardFlag=0
	s tmpRw=$o(^CF.DHCINM.HR.PersonsI("card"," "_$zcvt($tr(cardId," ",""),"U"),""))
	i id="" d
	.i tmpRw'="" s cardFlag=1
	e  d
	.i tmpRw="" s cardFlag=0
	.e  d
	..i tmpRw=id s cardFlag=0
	..e  s cardFlag=1
	q:cardFlag=1 "此身份证号已经存在"
	i id="" d
	.s obj=##class(CF.DHCINM.HR.Persons).%New()
	.s:$g(tmp("PerDepDate"))="" tmp("PerDepDate")=$g(tmp("PerComeDate"))
	.s:$g(tmp("PerDepDate"))="" tmp("PerDepDate")=$zd(+$H,3)
	e  d  
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	.;把obj转换成多维数组，作为旧值和传进来的新值进行对比++<20220118><ChenPeng>
	.s flag=##class(web.INMPersonComm).Obj2Node(obj,.oldTmp)
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.Persons","a",p)) q:p=""  d
	.q:p["%"
	.q:$lf(NoAssignProps,p)
	.i $d(tmp(p)) d
	..s ptype=^oddCOM("CF.DHCINM.HR.Persons","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..i p="PerID" s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..s tmp("PerTypeDR")="N" //人员类型（正式N  进修S 实习P 护理员W）
	..s tmp("PerCareType")="N" //医护类型（医生D 护士N）
	..s tmp("PerStatus")=##class(web.INMImportDBData).GetSetCode("在职状态","在职")
	..s tmp("PerAuditFlag")=type
	..i p="PerSpeciNurse" d
	...d obj.PerSpeciNurse.Clear()
	...f j=1:1:$l(tmp(p),",") d
	....s itm=$p(tmp(p),",",j)
	....i itm'="" d obj.PerSpeciNurse.Insert(itm)
	..e  s $ZOBJPROPERTY(obj,p)=$tr(tmp(p),"__","||")
	i obj.PerPassword="" s obj.PerPassword="UUUUUU&&&&&&"
	TS
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	// ====================以下<20220118><ChenPeng><处理档案修改记录和属性变更记录>========================
	s personId=obj.%Id()
	s perOperate=##class(DHCINM.HR.MgPerOperate).%New()
	;如果id是空的，说明操作类型是新增(N)，此时档案的状态处于初始化(I)
	;否则操作类型是编辑更新(U)，档案处于编辑中(U)
	i id="" d
	.s perOperate.Status="I"
	.s perOperate.Type="N"
	e  d
	.s perOperate.Status="U"
	.s perOperate.Type="U"
	;需要前端传个当前操作用户的id
	s perOperate.Operator=$g(tmp("Operator"))
	s perOperate.OpDate=+$h
	s perOperate.OpTime=$p($h,",",2)
	d perOperate.PersonSetObjectId(personId)
	;新增一条档案操作记录
	s sc=perOperate.%Save()
	s perOperateId=perOperate.%Id()
	s flag=flag&&$$$ISOK(sc)
	;如果id是空的就不用新增档案属性变更列表了
	if (id'="") {
		s PropList=..GetDeclaredProps(obj.%ClassName(1))
		s ptr=0
		while $ListNext(PropList,ptr,prop) {
			if ($g(tmp(prop))'=$g(oldTmp(prop))) {
				continue:$lf(NoCompareProps,prop)
				continue:'($d(tmp(prop))&&$d(oldTmp(prop)))
				s perPropItem=##class(DHCINM.HR.MgPerPropItem).%New()
				s perPropItem.Prop=prop
				s perPropItem.Type=$g(^oddCOM("CF.DHCINM.HR.Persons","a",prop,"P","XSDTYPE"))
				s perPropItem.NewVal=$g(tmp(prop))
				s perPropItem.OldVal=$g(oldTmp(prop))
				d perPropItem.PerOperateSetObjectId(perOperateId)
				s sc=perPropItem.%Save()
				s flag=flag&&$$$ISOK(sc)
			}
		}
	}
	;如果保存出错就进行回滚并返回
	if ('flag) {
		TROLLBACK
		q flag
	}
	// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^以上处理档案修改记录和属性变更记录^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;更新转科信息
	s oldTransID=$o(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_obj.%Id(),""))
	i oldTransID="" d
	.s newObj=##class(CF.DHCINM.Trans.TransDep).%New()
	.s newObj.PerDr=obj.%Id()
	.s newObj.PerDepart=obj.PerDepDR
	.s newObj.PerTranStDate=obj.PerDepDate
	.s newObj.PerTranCurrent="Y"
	.s newObjSc=newObj.%Save()
	.s flag=flag&&$$$ISOK(newObjSc)
#;	e  d
#;	.s oldObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(oldTransID)
#;	.s oldObj.PerTranEndDate=+$h
#;	.s oldObj.PerTranCurrent="N"
#;	.s oldObjSc=oldObj.%Save()
#;	.s flag=(flag&&$$$ISOK(oldObjSc))
#;	.i flag=1 d
#;	..s newObj=##class(CF.DHCINM.Trans.TransDep).%New()
#;	..s newObj.PerDr=obj.%Id()
#;	..s newObj.PerDepart=obj.PerDepDR
#;	..s newObj.PerTranStDate=obj.PerDepDate
#;	..s newObj.PerTranCurrent="Y"
#;	..s newObjSc=newObj.%Save()
#;	..s flag=(flag&&$$$ISOK(newObjSc))
	i flag'=1
	{
		Tro
		q 0
	}
	;更新用户表信息
	s rw=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_obj.%Id(),""))
	s SSUserErrorRet=""
	s SSUserCode=$g(tmp("HISNO"))
	s SSUserId=""
	i SSUserCode'="" d
	.s SSUserId=##class(web.INMHISComm).GetUserIdByCode(SSUserCode)
	.s:SSUserId="" SSUserErrorRet="无此HIS用户"
	q:SSUserErrorRet'="" SSUserErrorRet
	s userObj=##class(CF.DHCINM.DB.MgUser).%New()
	s:rw'="" userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(rw)
	s userObj.Password="UUUUUU&&&&&&"
	s userObj.UserDR=SSUserId
	s userObj.PerDR=obj.%Id()
	s userObj.UserID=nurseNo
	s userObj.UserName=obj.PerName
	s userObj.StartDate=+$h
	s userObj.PerDepDR=obj.PerDepDR
	s userSc=userObj.%Save()
	s flag=flag&&$$$ISOK(userSc)
	i flag'=1
	{
		tro
		q 0
	}
	;更新注册证书相关信息
	i (($g(tmp("PerRegRegiDate"))'="")&&($l($g(tmp("PerRegRegiDate")),"-")=3))
	{
		s regObj=##class(DHCINM.HR.MgQualRegisted).%New()
		s regObj.RegistedDate=$zdh($tr($g(tmp("PerRegRegiDate"))," ",""),3) ;证书注册日期
		s regsc=regObj.%Save()
		s flag=flag&&$$$ISOK(regsc)
		i flag'=1
		{
			tro
			q 0
		}
		else  
		{
			tc
		}
	}
	else
	{
		tc	
	}
	;如果都ok，那么返回档案Id
	q:flag=1 obj.%Id()
	q:flag=0 flag
}

/// Creator		ChenPeng
/// CreateDate	2022-01-20
/// Description	将对象节点数据转换为指定分割的字符串 node(prop)=value -> prop1|val1^prop2|val2
/// Input		node	属性节点多维数组
/// 			KTV		key与value之间连接符，默认是|
/// 			ETE		key-value(Element)之间连接符，默认是^
/// Output		返回拼接的字符串
/// Table		NULL
/// Others		w ##class(web.INMPersonComm).PackageResp(.node)
ClassMethod PackageResp(node, KTV As %String = "|", ETE As %String = "^") As %String
{
	s key="",arr=$lb(),idx=1
	f  s key=$o(node(key)) q:key=""  d
	.s value=$g(node(key))
	.s ele=key_KTV_value
	.s $li(arr,idx)=ele
	.s idx=idx+1
	q $lts(arr,ETE)
}

/// Creator		ChenPeng
/// CreateDate	2022-01-18
/// Function	根据类名字符串从^oddCOM获取对象的属性列表
/// Input		类全限定名字符串
/// Output		类Property定义的属性名列表
/// Table 		NULL
/// Return		NULL
/// Others		w ##class(web.INMPersonComm).GetDeclaredProps("CF.DHCINM.HR.Persons")
ClassMethod GetDeclaredProps(classname As %String)
{
	s PropList=$lb()
	s PropName=""
	;这个查找的是Class定义的Property列表
	f  s PropName=$o(^oddCOM(classname,"a",PropName)) q:PropName=""  d
	.q:PropName["%"
	.i $ld(PropList,1)=0 d
	..s KeyIdx=1
	.e  s KeyIdx=$ll(PropList)+1
	.s PropList=$lu(PropList,KeyIdx,PropName)
	q PropList
}

/// Creator		ChenPeng
/// CreateDate	2022-01-19
/// Description	回退护理档案至最近一次审核操作(审核、撤销审核)的数据
/// Input		id:			护理档案主键ID
/// 			node:		储存原数据的节点变量
/// Output		NULL
/// Table		NULL
/// Return 		%Status
/// Others		w ##class(web.INMPersonComm).RollbackToLastAudit(11)
ClassMethod RollbackToLastAudit(id As %String) As %String
{
	s perOpId="",perOpItemId="",UpdateOps=$ListBuild("U"),OldData=""
	;从后往前递推出减量
	f {
		;s perOpId=$o(^CF.DHCINM.HR.PersonsD(id,"PerOperate",perOpId),-1)
		s perOpId=$o(^DHCINM.HR.MgPerOperateD(id,perOpId),-1)
		q:perOpId=""
		k:$d(OneBackData) OneBackData
		s operateData=$g(^DHCINM.HR.MgPerOperateD(id,perOpId))
		q:operateData=""
		;如果不是保存更新的操作是没有数据修改的
		q:'$lf(UpdateOps,$lg(operateData,3))
		f {
			;s perOpItemId=$o(^CF.DHCINM.HR.PersonsD(id,"PerOperate",perOpId,"PerPropItem",perOpItemId))
			s perOpItemId=$o(^DHCINM.HR.MgPerPropItemD(id,perOpId,perOpItemId))
			q:perOpItemId=""
			s perPropData=$g(^DHCINM.HR.MgPerPropItemD(id,perOpId,perOpItemId))
			;s perPropData=$g(^CF.DHCINM.HR.PersonsD(id,"PerOperate",perOpId,"PerPropItem",perOpItemId))
			q:perPropData=""
			s OneBackData($lg(perPropData,2))=$lg(perPropData,5)
		}
		;逐步累积向前合并数据减量,最终会合并到上次审核(通过审核/驳回审核/撤销审核)或直至新建时数据变化量
		;根据当前数据和两次审核之间累积的数据变化量即可推出上次审核时的数据(即原护士注册信息)
		merge:$d(OneBackData) RollbackData=OneBackData
	}
	s person=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	s flag=..Obj2Node(person,.NewData)
	m OldData=NewData
	m:$d(RollbackData) OldData=RollbackData
	;===============以下将结果转换为json返回给前端======================
	s oldData=..ArchiveNode2JSONArray(id,.OldData)
	s newData=..ArchiveNode2JSONArray(id,.NewData)
	;将有变更的属性名返回给前端，以便前端标示出来
	s ChangedProps=[]
	s changedProp="" f  s changedProp=$o(RollbackData(changedProp)) q:changedProp=""  d
	.d ChangedProps.%Push(changedProp)
	s ret={}.%Set("NewData",newData).%Set("OldData",oldData).%Set("ChangedProps",ChangedProps)
	w ret.%ToJSON()
	q ""
}

/// Creator			ChenPeng
/// CreateDate		2022-01-24
/// Description		将档案转换为JSON数组
/// Input 			personId	护理档案ID
/// 				node		节点多维数组
/// Others	w ##class(web.INMPersonComm).ArchiveNode2JSONArray(11,.NewData)
ClassMethod ArchiveNode2JSONArray(personId, node) As %DynamicArray
{
	;前端需要显示的属性列表
	s ViewProps=$ListBuild("Email","HISNO","PerRemark","PerAge","PerAttriDepart","PerBirthday","PerCardId",
		"PerClothesNo","PerContact","PerContactPhone","PerCurrentAcade","PerCurrentDegree","PerCurrentSchool",
		"PerDepDR","PerDepDate","PerEspecially","PerForeignLevel","PerHeight","PerHireDuty","PerID",
		"PerInNursePost","PerMarriage","PerName","PerNation","PerNurTime","PerNurseLevel","PerPhone",
		"PerPolitical","PerPostCategory","PerPostDuty","PerPostName","PerPostType","PerRegNo","PerRegRegiDate",
		"PerRegValidDate","PerSexDR","PerShoesNo","PerSource","PerTrouserNo","PerWorkDate","Relationship")
	;需要转换为描述文本的属性列表
	s DictProps = $ListBuild("PerSexDR", "PerNation", "PerPolitical", "PerMarriage", "PerClothesNo",
		"PerTrouserNo", "PerShoesNo", "Relationship",  "PerForeignLevel", "PerSource", "PerAttriDepart",
		"PerInNursePost", "PerPostName", "PerPostType", "PerPostCategory","PerAttriDepart","Relationship")
	s dynArr = [],key=""
	for {
		s key=$o(node(key))
		q:key=""
		continue:'$lf(ViewProps,key)
		s tempObj = {}.%Set("prop",key).%Set("desc",$g(node(key)))
		;处理字典属性需要转换为描述文本
		if $lf(DictProps,key) {
			d tempObj.%Set("desc",..GetCommCode(node(key)))
		}
		;处理日期类型的属性
		if ((^oddCOM("CF.DHCINM.HR.Persons","a",key,"P","XSDTYPE")="date")&&($g(node(key))'="")) {
			d tempObj.%Set("desc",##class(web.INMHISComm).DateLogicalToHtml(node(key)))
		}
		;如果是病区字段需要额外处理
		if (key="PerDepDR") {
			d tempObj.%Set("desc",$lg(^CF.DHCINM.DB.MgWardD(node(key)),4))
		}
		d dynArr.%Push(tempObj)
	}
	;年龄
	s tempAge=##class(web.INMVueComm).CalAge($zd(node("PerBirthday"),3),$zd(+$h,3))
	s age=$p(tempAge,"Y",1)
	s PerAgeJson={}.%Set("prop","PerAge").%Set("desc",age)
	d dynArr.%Push(PerAgeJson)
	;护龄/天
	s PerNurTimeJson={}.%Set("prop","PerNurTime").%Set("desc",+$h-node("PerComeDate"))
	d dynArr.%Push(PerNurTimeJson)
	;获取层级信息
	s Level=##class(web.INMHRComm).GetNurseLevel(personId,+$h)
	s PerLevel=$p(Level,"^",1)
	s PerNurseLevelDesc=..GetCommCode(PerLevel)
	s PerNurseLevelJson={}.%Set("prop","PerNurseLevel").%Set("desc",PerNurseLevelDesc)
	d dynArr.%Push(PerNurseLevelJson)
	;获取职称信息
	s HireDuty=##class(web.INMHRComm).GetNurseHireDuty(personId,+$h)
	s PerHireDuty=$p(HireDuty,"^",1)
	s PerHireDutyDesc=..GetCommCode(PerHireDuty)
	s PerHireDutyJson={}.%Set("prop","PerHireDuty").%Set("desc",PerHireDutyDesc)
	d dynArr.%Push(PerHireDutyJson)
	;获取职务信息
	s PostDuty=##class(web.INMHRComm).GetNurseDuty(personId,+$h)
	s PerPostDuty=$p(PostDuty,"^",1)
	s PerPostDutyDesc=..GetCommCode(PerPostDuty)
	s PerPostDutyJson={}.%Set("prop","PerPostDuty").%Set("desc",PerPostDutyDesc)
	d dynArr.%Push(PerPostDutyJson)
	;获取证书注册日期和有效期
	s RegId="",RegDate="",ExpireDate=""
	s RegId=$o(^DHCINM.HR.MgQualRegistedI("Assid"," "_personId," A",RegId),-1)
	if (RegId'="") {
		s RegData=$g(^DHCINM.HR.MgQualRegistedD(RegId))
		s RegDate=$zd($lg(RegData,3),3)
		;s ExpireDate=$zd($lg(RegData,3)+(5*365),3)
		s ExpireDate=$lg(RegData,6)
		s:ExpireDate'="" ExpireDate=$zd(ExpireDate,3)
	}
	s RegDateJSON={}.%Set("prop","PerRegRegiDate").%Set("desc",RegDate)
	s ExpireDateJSON={}.%Set("prop","PerRegValidDate").%Set("desc",ExpireDate)
	d dynArr.%Push(RegDateJSON).%Push(ExpireDateJSON)
	;当前学历信息
	;EduFlag是表示是否查询到当前学历的标识
	s PerCurrentAcade="",PerCurrentSchool="",PerCurrentDegree="",EduFlag=0
	s PerCurrentAcadeDesc="", PerCurrentSchoolDesc="", PerCurrentDegreeDesc=""
	s EduDate=""
	f  s EduDate=$o(^CF.DHCINM.HR.EducateI("flag",personId,EduDate),-1) q:(EduDate="")||(EduFlag=1)  d
	.s EduRowID=$o(^CF.DHCINM.HR.EducateI("flag",personId,EduDate,""))
	.s EduObj=##class(CF.DHCINM.HR.Educate).%OpenId(EduRowID)
	.q:'$IsObject(EduObj)
	.;不是审核状态就退出，这个表明只查询审核状态的学历信息
	.q:EduObj.EduStatus'="A"
	.s PerCurrentAcade=EduObj.EduAcademic
	.s PerCurrentSchool=EduObj.EduSchool
	.s PerCurrentDegree=EduObj.EduDegree
	.s PerCurrentAcadeDesc=..GetCommCode(PerCurrentAcade)
	.s PerCurrentSchoolDesc=..GetCommCode(PerCurrentSchool)
	.s PerCurrentDegreeDesc=..GetCommCode(PerCurrentDegree)
	.s EduFlag=1
	s CurrentAcadeJson={}.%Set("prop","PerCurrentAcade").%Set("desc",PerCurrentAcadeDesc)
	s CurrentSchoolJson={}.%Set("prop","PerCurrentDegree").%Set("desc",PerCurrentDegreeDesc)
	s CurrentDegreeJson={}.%Set("prop","PerCurrentSchool").%Set("desc",PerCurrentSchoolDesc)
	d dynArr.%Push(CurrentAcadeJson).%Push(CurrentDegreeJson).%Push(CurrentSchoolJson)
	q dynArr
}

/// Creator		ChenPeng
/// CreateDate	2022-01-18
/// Description	obj.prop=value -> node(prop)=value，没有处理对象嵌套的问题
/// Input		obj:某个类的实例
/// 			node:传入的多维数组
/// Output		NULL
/// Table		NULL
/// Return		
/// Others		d ##class(web.INMPersonComm).Obj2Node(person,.tmp)
ClassMethod Obj2Node(obj, node)
{
	;这里并没处理属性是引用类型的情况
	s ClassName=obj.%ClassName(1)
	s Id=obj.%Id()
	s PropList=..GetDeclaredProps(ClassName)
	s ptr=0,flag=1
	while $ListNext(PropList,ptr,PropName) {
		try {
			;这样处理好像也不行
			s node(PropName)=$Property(obj,PropName)		
		} catch ex {
			s flag=0
			continue
		}
	}
	q flag
}

/// Creator:guozj
/// Description:保存在职状态信息
/// Date:2017-08-25
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:"context|17__2^contextdate|2017-08-01^RowID|2"
ClassMethod SaveRtireLeave(parr As %String) As %String
{
	;s ^TMP("retireparr")=parr
	s PerStatus=$tr($P($P(parr,"^",1),"|",2),"__","||")
	s StateDate=$P($P(parr,"^",2),"|",2)
	i StateDate'="" s PerStateDate=$zdh(StateDate,3)
	e  s PerStateDate=+$H
	s RowID=$P($P(parr,"^",3),"|",2)
	q:RowID="" ""
	s flag=..IsRetireLeaState(PerStatus,RowID)
	q:flag="-1" flag
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(RowID)
	q:'$IsObject(obj) ""
	s obj.PerStatus=PerStatus
	i obj.PerStatus'="" d
	.s cobj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(obj.PerStatus)
	.q:'$IsObject(cobj)
	.i ((cobj.SubDesc="在职")!(cobj.SubDesc="在院")) s obj.PerStateDate=""
	.e  s obj.PerStateDate=PerStateDate
	d obj.%Save()
	q obj.%Id()
}

ClassMethod IsRetireLeaState(PerStatus, RowID) As %String
{
	s ret=0
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(RowID)
	q:'$IsObject(obj) ""
	i (PerStatus'="")&&(obj.PerStatus=PerStatus) s ret=-1
	q ret
}

/// Creator:guozj
/// Description:判断人员是否存在
/// Date:2017-07-17
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod IsExist(nurseno) As %String
{
	s flag=-1
	s rowid=$O(^CF.DHCINM.HR.PersonsI("PerID"," "_$zcvt(nurseno,"U"),""))
	i rowid'="" d
	.s flag=0
	q flag_"^"_rowid
}

/// Creator:guozj
/// Description:保存调科记录数据
/// Date:2017-07-24
/// Table:CF.DHCINM.Trans.TransDep
/// Input:"^人员表id^科室id^开始日期^开始时间^Y^原因"
/// Output：
/// Return:
/// Others:
ClassMethod SaveTransData(parr As %String) As %String
{
	//s parm=$P($P(parr,"^",2),"|",2)_"^"_$P($P(parr,"^",8),"|",2)_"^^"_pid_"^"_$P($P(parr,"^",24),"|",2)
	//_"^"_$P($P(parr,"^",40),"|",2)_"^^Y^1"
	//"^"_obj.%Id()_"^"_obj.PerDepDR_"^"_$zd(obj.PerDepDate,3)_"^"_$zt($P($H,",",2),1)_"^Y^^^L"
	s ^TMP("transdepparr")=parr
   	s id=$P(parr,"^",1)
   	s per=$P(parr,"^",2) //人员表id
   	s dep=$P(parr,"^",3) //科室id
   	s stdate=$P(parr,"^",4) //开始日期
   	s sttime=$P(parr,"^",5) //开始时间
   	s curr=$P(parr,"^",6) //当前状态
   	s stdate=$ZDH(stdate,3)
   	if sttime'="" s sttime=$ZTH(sttime)
   	e  s sttime=$P($H,",",2)
   	s id="",upid=""
   	s rw=""  f  s rw=$O(^CF.DHCINM.Trans.TransDepI("ssdr"," "_per,rw)) q:rw=""  d
   	.s loc=$List(^CF.DHCINM.Trans.TransDepD(rw),3)
   	.s enddate=$List(^CF.DHCINM.Trans.TransDepD(rw),6)
   	.if (loc=dep)&(enddate="") s id=rw
   	.e  d
   	..s id="",upid=rw
   	if id'="" s a=##class(CF.DHCINM.Trans.TransDep).%OpenId(id)
   	e  s a=##class(CF.DHCINM.Trans.TransDep).%New()
   	s a.PerDr=per
   	s a.PerDepart=dep
   	s a.PerTranStDate=stdate
   	s a.PerTranStTime=sttime
   	s a.PerTranCurrent=curr
   	d a.%Save()
   	if upid'="" 
   	{
	   	s aa=##class(CF.DHCINM.Trans.TransDep).%OpenId(upid)
      	s aa.PerTranEndDate=stdate
      	s aa.PerTranEndTime=sttime
      	s aa.PerTranCurrent="N"
      	d aa.%Save()      
  	}
  	q 0
}

/// Creator:guozj
/// Description:检查（判断）调科日期
/// Date:2017-08-26
/// Table:CF.DHCINM.Trans.TransDep
/// Input:""
/// Output：
/// Return:
/// Others:
ClassMethod CheckTransDate(date As %String, rowid As %String) As %String
{
	s ret="true"
	;s ^TMP("transdate")=date_"%"_rowid
	s rw="" f  s rw=$O(^CF.DHCINM.Trans.TransDepI("ssdr"," "_rowid,rw),-1) q:rw=""  d
	.s obj=##class(CF.DHCINM.Trans.TransDep).%OpenId(rw)
	.q:obj.PerTranCurrent="Y"
	.s dateVal=obj.PerTranStDate
	.i ((date'="")&&($zdh(date,3)<dateVal)) d
	..s ret="false"
	
	q ret
}

/// Creator:
/// Date:2019-05-10
/// Description:检查护士是否已经在同一天有过调科记录
ClassMethod CheckNurseTrans(parr As %String) As %String
{
	/*
	TransDate|2019-05-13^TransInDep|1^TransType|13__2
	^TransNurseInfo|TransOutDep「25 ~TransNurse「4」TransOutDep「25~TransNurse「5
	^TransReason|^CreateUser|0^TransStatus|N^TransEndDate|^RowID|6^TranSpecy|L
	*/ //^TransNurseInfo|TransOutDep「25 ~TransNurse「4」TransOutDep「25~TransNurse「5
	s TransDate=$p($p(parr,"^",1),"|",2)
	s TransNurseInfo=$p($p(parr,"^",4),"|",2)
	s TransInDep=$p($p(parr,"^",2),"|",2)
	s len=$l(TransNurseInfo,"」")
	s ret=""
	f i=1:1:len 
	{
		s item=$p(TransNurseInfo,"」",i)
		i item="" continue
		s ward=$p($p(item,"~",1),"「",2)
		s nurse=$p($p(item,"~",2),"「",2)
		
	}
}

ClassMethod GetAppNo() As %String
{
	s ret=""
	s InitNo=$zd(+$H,8)
	s AppNo=$O(^DHCINM.Trans.MgTransAppI("appno",""),-1)
	s No=$tr(AppNo," ","")
	i No="" s ret=$zd(+$H,8)_"0001" 
	e  d
	.i $E(No,1,8)=InitNo d
	..s ret=No+1
	.e  d
	..s ret=InitNo_"0001"
	q ret
}

ClassMethod GetNurse(parr As %String) As %String
{
	//TransOutDep「1~TransNurse「1@TransOutDep「1~TransNurse「5@TransOutDep「1~TransNurse「6
	s ret=""
	s len=$l(parr,"@")
	f i=1:1:len
	{
		s itm=$P(parr,"@",i)
		i itm'="" 
		{
			;s ret=ret_"^"_$P($P(itm,"~",2),"「",2)
			s dep=$P($p(itm,"~",1),"「",2)
			s nurse=$P($P(itm,"~",2),"「",2)
			i ret'="" s ret=ret_"^"_dep_"|"_nurse
			e  s ret=dep_"|"_nurse
		}
	}
	q ret
}

ClassMethod GetNurseOutDep(list) As %String
{
	s ret=""
	i list.GetAt(1)'="" s itm=list.GetAt(1)
	e  s itm=list.GetAt(2)
	s dep=$p(itm,"|",1)
	s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(dep)
	q:'$IsObject(obj) ""
	s ret=obj.WardDesc
	q ret
}

ClassMethod GetAppNurse(obj) As %String
{
	s ret=""
	s len=obj.Count()
	f i=1:1:len
	{
		s itm=obj.GetAt(i)
		i ret="" s ret=..GetNurseInfo($P(itm,"|",2))
		e  s ret=ret_","_..GetNurseInfo($P(itm,"|",2))
	}
	q ret
}

ClassMethod GetNurseInfo(id As %String) As %String
{
	s list=""
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	q:'$IsObject(obj)
	s list=obj.PerName
	q list
}

ClassMethod GetUserInfo(id As %String) As %String
{
	s list=""
	s obj=##class(CF.DHCINM.DB.MgUser).%OpenId(id)
	q:'$IsObject(obj)
	s list=obj.UserName
	q list
}

ClassMethod GetTransNurse(obj) As %String
{
	s len=obj.Count()
	s ret="["
	f i=1:1:len
	{
		s itm=obj.GetAt(i)
		s dep=$P(itm,"|",1)
		s nurse=$P(itm,"|",2)
		s depstr=##class(web.INMDBComm).GetWard(dep)
		s nursedep=$P($P(depstr,"^",3),"|",2)
		s nurseobj=##class(CF.DHCINM.HR.Persons).%OpenId(nurse)
		s nursename=nurseobj.PerName
		s nurseid=nurseobj.PerID
		s ret=ret_"{'nurseid':'"_nurseid_"','nursename':'"_nursename_"','nursedep':'"_nursedep_"','nursedepcode':'"_dep_"','rowid':'"_nurse_"'"
		s ret=ret_"},"
	}
	i ret'="[" s ret=$E(ret,1,$L(ret)-1)
	s ret=ret_"]"
	q ret
}

ClassMethod IsValidTransRec(id As %String) As %String
{
	s ret=0
	s obj=##class(DHCINM.Trans.MgTransApp).%OpenId(id)
	q:'$IsObject(obj)
	i obj.TransStatus="N" s ret=1 //未提交
	e  i obj.TransStatus="Y" s ret=2 //已提交
	e  i obj.TransStatus="A" s ret=3 //已审核
	e  i obj.TransStatus="B" s ret=4 //驳回
	q ret
}

/// 
/// Creator:guozj
/// Description:提交审核状态
/// Date:2017-08-30
/// Table:DHCINM.Trans.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SubmitSatus(parr As %String, id As %String) As %String
{
	s obj=##class(DHCINM.Trans.MgTransApp).%OpenId(id)
	q:'$IsObject(obj)
	s obj.TransStatus=parr
	d obj.%Save()
	q 0
}

ClassMethod GetTransCheckRec(id As %String) As %String
{
	s ^TMP("transcheckrecid")=id
	s ret=""
	s obj=##class(DHCINM.Trans.MgTransApp).%OpenId(id)
	q:'$IsObject(obj)
	i obj.TransDate'="" s CheckTranDate=##class(web.INMHISComm).DateLogicalToHtml(obj.TransDate)
	e  s CheckTranDate=""
	s CheckTranInDep=obj.TransInDep
	i obj.TransNurse'="" d
	.s CheckTranNurse=..GetTransNurse(obj.TransNurse)
	e  s CheckTranNurse=""
	s CheckTranReason=obj.TransReason
	s RowID=id
	s TransRadio=obj.TransRadio
	i TransRadio="" s TransRadio=1
	s ret="CheckTranDate|"_CheckTranDate_"^CheckTranInDep|"_CheckTranInDep_"^CheckTranReason|"_CheckTranReason_"^RowID|"_id_"^CheckTranNurse|"_CheckTranNurse_"^TransRadio|"_TransRadio
	q ret
}

/// Creator:gzj
/// Date:2019-05-13
/// Description:审核调科时检测调科人员是否存在排班数据
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod CheckIsHasArg(id As %String) As %String
{
	s ^TMP("CheckIsHasArg")=id
	q:id="" 0
	s ret=""
	s obj=##class(DHCINM.Trans.MgTransApp).%OpenId(id)
	q:'$IsObject(obj) 0
	s TransDate=obj.TransDate
	s len=obj.TransNurse.Count()
	f i=1:1:len
	{
		
		s itm=obj.TransNurse.GetAt(i)
		i itm="" continue
		s ward=$p(itm,"|",1)
		s nurse=$p(itm,"|",2)
		i ((nurse="")!(ward="")) continue
		s date=TransDate-1 f  s date=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",nurse,date)) q:date=""  d
		.s rw="" f  s rw=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",nurse,date,rw)) q:rw=""  d
		..s argObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(rw)
		..q:'$IsObject(argObj)
		..i ret="" s ret=argObj.ArgPerDR.PerName
		..e  s ret=ret_";"_argObj.ArgPerDR.PerName
	}
	q ret
}

/// Creator:guozj
/// Description:保存职称信息
/// Date:2017-08-22
/// Table:CF.DHCINM.HR.HireDuty
/// Input:
/// Output：
/// Return:
/// Others: HireDuty|14__2^HireStDate|2017-08-22^HireEndDate|^HireRemark|^RowID|^HirePerDR|1
ClassMethod SaveDuty(parr As %String, type As %String) As %String
{
	;s ^TMP("dutyparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(CF.DHCINM.HR.HireDuty).%New()
	e  s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.HireDuty","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="HirePerDR" d
	...s ptype=^oddCOM("CF.DHCINM.HR.HireDuty","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="HirePerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..;s tmp("HireStatus")="N"
	..s tmp("HireStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

/// 获取聘任职称记录状态
ClassMethod GetDutyStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.HireStatus
	q flag
}

/// Creator:guozj
/// Description:查询职称列表
/// Date:2017-08-22
/// Table:CF.DHCINM.HR.HireDuty
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindDutyList","")
Query FindDutyList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindDutyListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	;s ^TMP("parrduty")=parr
	s par="" f  s par=$O(^CF.DHCINM.HR.HireDutyI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^CF.DHCINM.HR.HireDutyI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(rw)
	..i obj.HireDuty'="" s HireDuty=..GetCommCode(obj.HireDuty)
	..e  s HireDuty=""
	..i obj.HireStDate'="" s HireStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.HireStDate)
	..e  s HireStDate=""
	..i obj.HireEndDate'="" s HireEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.HireEndDate)
	..e  s HireEndDate=""
	..s HireRemark=obj.HireRemark
	..s status=""
	..i obj.HireStatus="N" s status="保存"
	..e  i obj.HireStatus="Y" s status="提交"
	..e  i obj.HireStatus="A" s status="审核"
	..e  i obj.HireStatus="B" s status="驳回"
	..i obj.MajorDuty'="" s MajorDuty=..GetCommCode(obj.MajorDuty)
	..e  s MajorDuty=""
	..i obj.MajorDutyDate'="" s MajorDutyDate=##class(web.INMHISComm).DateLogicalToHtml(obj.MajorDutyDate)
	..e  s MajorDutyDate=""
	..s ret="hireDuty|"_HireDuty_"^hireStDate|"_HireStDate_"^hireEndDate|"_HireEndDate_"^hireRemark|"_HireRemark
	..s ret=ret_"^hireRowID|"_rw_"^status|"_status
	..s ret=ret_"^MajorDuty|"_MajorDuty_"^MajorDutyDate|"_MajorDutyDate
	..do OutputDutyData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDutyData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDutyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDutyListExecute ]
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

ClassMethod FindDutyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDutyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AuditDutyRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.HireStatus=type
	s sc=obj.%Save()
	i (($$$ISOK(sc)&&((obj.HireStatus="A")||(obj.HireStatus="B"))&&$IsObject(obj.HirePerDR))) d
	.s perID=obj.HirePerDR.%Id()
	.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perID,""))
	.i userID'="" d
	..s wardId=obj.HirePerDR.PerDepDR
	..s wardDesc=""
	..s:wardId'="" wardDesc=$LG($g(^CF.DHCINM.DB.MgWardD(wardId)),4)
	..s HireStatusDesc=$case(obj.HireStatus,"A":"审核","B":"驳回")
	..s MajorDuty=##class(web.INMPersonComm).GetCommCode(obj.MajorDuty)
	..s MajorDutyDate=""
	..s:obj.MajorDutyDate'="" MajorDutyDate=$zd(obj.MajorDutyDate,3)
	..s ret="【护士档案/职称】 "_HireStatusDesc_" "_MajorDuty_" "_MajorDutyDate
	..d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,ret,"CF.DHCINM.HR.HireDuty",id)
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询职称、职务
/// Date:2017-08-22
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetCommCode(id As %String) As %String
{
	q:id'["||" ""
	s objLB=$G(^CT.DHCINM.DB.MgSetCodeSubD($P(id,"||",1),$P(id,"||",2)))
	q:objLB="" ""
	q $LG(objLB,3)
}

/// Creator:guozj
/// Description:获取职称记录
/// Date:2017-08-23
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetDutyItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(id)
	s HireDuty=obj.HireDuty
	i obj.HireStDate'="" s HireStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.HireStDate)
	e  s HireStDate=""
	i obj.HireEndDate'="" s HireEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.HireEndDate)
	e  s HireEndDate=""
	s HireRemark=obj.HireRemark
	s MajorDuty=obj.MajorDuty
	i obj.MajorDutyDate'="" s MajorDutyDate=##class(web.INMHISComm).DateLogicalToHtml(obj.MajorDutyDate)
	e  s MajorDutyDate=""
	s ret="HireDuty|"_HireDuty_"^HireStDate|"_HireStDate_"^HireEndDate|"_HireEndDate
	_"^HireRemark|"_HireRemark_"^MajorDuty|"_MajorDuty_"^MajorDutyDate|"_MajorDutyDate
	_"^RowID|"_id
	q ret
}

/// Creator:guozj
/// Description:保存职务信息
/// Date:2017-08-23
/// Table:CF.DHCINM.HR.PostDuty
/// Input:
/// Output：
/// Return:
/// Others: PostDuty|14__2^PostStDate|2017-08-22^PostEndDate|^PostRemark|^RowID|^PostPerDR|1
ClassMethod SavePost(parr As %String, type As %String) As %String
{
	;s ^TMP("postparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(CF.DHCINM.HR.PostDuty).%New()
	e  s obj=##class(CF.DHCINM.HR.PostDuty).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.PostDuty","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="PostPerDR" d
	...s ptype=^oddCOM("CF.DHCINM.HR.PostDuty","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="PostPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..;s tmp("PostStatus")="N"
	..s tmp("PostStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

/// Creator:guozj
/// Description:查询职务列表
/// Date:2017-08-23
/// Table:CF.DHCINM.HR.PostDuty
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindPostList","")
Query FindPostList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPostListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	;s ^TMP("parrpost")=parr
	s par="" f  s par=$O(^CF.DHCINM.HR.PostDutyI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^CF.DHCINM.HR.PostDutyI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(CF.DHCINM.HR.PostDuty).%OpenId(rw)
	..i obj.PostDuty'="" s PostDuty=..GetCommCode(obj.PostDuty)
	..e  s PostDuty=""
	..i obj.PostStDate'="" s PostStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PostStDate)
	..e  s PostStDate=""
	..i obj.PostEndDate'="" s PostEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PostEndDate)
	..e  s PostEndDate=""
	..s PostRemark=obj.PostRemark
	..s status=""
	..i obj.PostStatus="N" s status="保存"
	..e  i obj.PostStatus="Y" s status="提交"
	..e  i obj.PostStatus="A" s status="审核"
	..e  i obj.PostStatus="B" s status="驳回"
	..s ret="postDuty|"_PostDuty_"^postStDate|"_PostStDate_"^postEndDate|"_PostEndDate_"^postRemark|"_PostRemark_"^postRowID|"_rw_"^status|"_status
	..do OutputPostData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPostData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostListExecute ]
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

ClassMethod FindPostListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPostStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(CF.DHCINM.HR.PostDuty).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.PostStatus
	q flag
}

ClassMethod AuditPostRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.HR.PostDuty).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.PostStatus=type
	s sc=obj.%Save()
	i ($$$ISOK(sc)&&((obj.PostStatus="A")||(obj.PostStatus="B"))&&$IsObject(obj.PostPerDR)) d
	.s perID=obj.PostPerDR.%Id()
	.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perID,""))
	.i userID'="" d
	..s PostStatusDesc=$case(obj.PostStatus,"A":"审核","B":"驳回")
	..s PositionNameId=$LG($g(^CF.DHCINM.HR.PostDutyD(id)),3)
	..s PositionName=""
	..s:PositionNameId'="" PositionName=##class(web.INMPersonComm).GetCommCode(PositionNameId)
	..s PostStDate1=$LG($g(^CF.DHCINM.HR.PostDutyD(id)),4)
	..s PostStDate=""
	..s:PostStDate1'="" PostStDate=$zd(PostStDate1,3)
	..s ret="【护士档案/职务】 "_PostStatusDesc_" "_PositionName_" "_PostStDate
	..d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","CF.DHCINM.HR.PostDuty",id)
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:获取职务记录
/// Date:2017-08-23
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetPostItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(CF.DHCINM.HR.PostDuty).%OpenId(id)
	s PostDuty=obj.PostDuty
	i obj.PostStDate'="" s PostStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PostStDate)
	e  s PostStDate=""
	i obj.PostEndDate'="" s PostEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PostEndDate)
	e  s PostEndDate=""
	s PostRemark=obj.PostRemark
	s ret="PostDuty|"_PostDuty_"^PostStDate|"_PostStDate_"^PostEndDate|"_PostEndDate_"^PostRemark|"_PostRemark_"^RowID|"_id
	q ret
}

/// Creator:guozj
/// Description:保存教育经历信息
/// Date:2017-08-30
/// Table:CF.DHCINM.HR.Educate
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveEducate(parr As %String, type As %String) As %String
{
	;s ^TMP("eduparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(CF.DHCINM.HR.Educate).%New()
	e  s obj=##class(CF.DHCINM.HR.Educate).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.Educate","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="EduPerDR" d
	...s ptype=^oddCOM("CF.DHCINM.HR.Educate","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="EduPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("EduStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod GetEducateStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(CF.DHCINM.HR.Educate).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.EduStatus
	q flag
}

ClassMethod AuditEducateRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.HR.Educate).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.EduStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.EduStatus="A")||(obj.EduStatus="B"))) d
		.s EduStatus=$case(obj.EduStatus,"A":"审核","B":"驳回")
		.s EduStDate1=$lg($g(^CF.DHCINM.HR.EducateD(id)),3)
		.s EduStDate=""
		.s:EduStDate1'="" EduStDate=$zd(EduStDate1,3)
		.s EduRadio=##class(web.INMPersonComm).GetCommCode(obj.EduRadio)
		.s EduSchool=##class(web.INMPersonComm).GetCommCode(obj.EduSchool)	
		.s EduAcademic=##class(web.INMPersonComm).GetCommCode(obj.EduAcademic)
		.s EduPerDR=$lg($g(^CF.DHCINM.HR.EducateD(id)),2)
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_EduPerDR,""))
		.s ret="【护士档案/教育信息】"_EduStatus_" "_EduStDate_" "_EduRadio_" "_EduSchool_" "_EduAcademic
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","CF.DHCINM.HR.Educate",id)
	}catch{
	}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询教育经历列表
/// Date:2017-08-30
/// Table: CF.DHCINM.HR.Educate
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindEduList","3")
Query FindEduList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindEduListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	;s ^TMP("parredu")=parr
	s n=1
	s flag="false"
	s par="" f  s par=$O(^CF.DHCINM.HR.EducateI("flag",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s date="" f  s date=$O(^CF.DHCINM.HR.EducateI("flag",par,date)) q:date=""  d
	..s rw="" f  s rw=$O(^CF.DHCINM.HR.EducateI("flag",par,date,rw)) q:rw=""  d
	...s obj=##class(CF.DHCINM.HR.Educate).%OpenId(rw)
	...;q:obj.EduStatus'="A"
	...i obj.EduStDate'="" s EduStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.EduStDate)
	...e  s EduStDate=""
	...i obj.EduEndDate'="" s EduEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.EduEndDate)
	...e  s EduEndDate=""
	...i obj.EduSchool'="" s EduSchool=..GetCommCode(obj.EduSchool)
	...e  s EduSchool=""
	...i obj.EduAcademic'="" s EduAcademic=..GetCommCode(obj.EduAcademic)
	...e  s EduAcademic=""
	...i obj.EduDegree'="" s EduDegree=..GetCommCode(obj.EduDegree)
	...e  s EduDegree=""
	...i obj.EduProfession'="" s EduProfession=..GetCommCode(obj.EduProfession)
	...e  s EduProfession=""
	...s EduRadio=""
	...i obj.EduRadio'="" d
	....s eduobj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(obj.EduRadio)
	....q:'$IsObject(eduobj)
	....s EduRadio=eduobj.SubDesc
	...i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.INMHISComm).DateLogicalToHtml(obj.EduDegreeDate)
	...e  s EduDegreeDate=""
	...s eduAcadeType=""
	...i EduRadio="全日制" d
	....i flag="false" d
	.....s eduAcadeType="第一学历"
	.....s flag="true"
	...s count=..GetCountAcade(par)
	...b ;01
	...i ((n=count)&&(n>1)) d
	....b ;02
	....s eduAcadeType="最高学历"
	...s n=n+1
	...s status=""
	...i obj.EduStatus="N" s status="保存"
	...e  i obj.EduStatus="Y" s status="提交"
	...e  i obj.EduStatus="A" s status="审核"
	...e  i obj.EduStatus="B" s status="驳回"
	...s ret="eduStDate|"_EduStDate_"^eduEndDate|"_EduEndDate_"^eduSchool|"_EduSchool_"^eduAcademic|"_EduAcademic_"^eduDegree|"_EduDegree_"^eduRowID|"_rw_"^eduProfession|"_EduProfession_"^eduRadio|"_EduRadio_"^eduDegreeDate|"_EduDegreeDate_"^eduAcadeType|"_eduAcadeType_"^status|"_status
	...do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEduListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEduListExecute ]
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

ClassMethod FindEduListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEduListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取学历的数量
ClassMethod GetCountAcade(par) As %String
{
	s n=0
	s date="" f  s date=$O(^CF.DHCINM.HR.EducateI("flag",par,date)) q:date=""  d
	.s rw="" f  s rw=$O(^CF.DHCINM.HR.EducateI("flag",par,date,rw)) q:rw=""  d
	..s n=n+1
	q n
}

ClassMethod GetSortAcade(par As %String, rw As %String) As %String
{
	s firstAcadeType="",lastAcadeType="",n=0
	s date="" f  s date=$O(^CF.DHCINM.HR.EducateI("flag",par,date)) q:date=""  d
	.s row="" f  s row=$O(^CF.DHCINM.HR.EducateI("flag",par,date,row)) q:row=""  d
	..q:(row'=rw)
	..s obj=##class(CF.DHCINM.HR.Educate).%OpenId(row)
	..i obj.EduRadio'="" d
	...s subobj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(obj.EduRadio)
	...q:'$IsObject(subobj)
	...q:(n>1)
	...i subobj.SubDesc="全日制" d
	....s firstAcadeType="第一学历"
	....s n=n+1
	q firstAcadeType
}

/// Creator:guozj
/// Description:获取教育经历记录
/// Date:2017-08-30
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetEduItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(CF.DHCINM.HR.Educate).%OpenId(id)
	i obj.EduStDate'="" s EduStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.EduStDate)
	e  s EduStDate=""
	i obj.EduEndDate'="" s EduEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.EduEndDate)
	e  s EduEndDate=""
	s EduSchool=obj.EduSchool
	s EduAcademic=obj.EduAcademic
	s EduDegree=obj.EduDegree
	s EduRadio=obj.EduRadio
	s EduProfession=obj.EduProfession
	i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.INMHISComm).DateLogicalToHtml(obj.EduDegreeDate)
	e  s EduDegreeDate=""
	s ret="EduStDate|"_EduStDate_"^EduEndDate|"_EduEndDate_"^EduSchool|"_EduSchool_"^EduAcademic|"_EduAcademic_"^EduDegree|"_EduDegree_"^RowID|"_id_"^EduRadio|"_EduRadio_"^EduProfession|"_EduProfession_"^EduDegreeDate|"_EduDegreeDate
	q ret
}

/// Creator:guozj
/// Description:保存工作经历信息
/// Date:2017-08-30
/// Table:DHCINM.HR.MgWork
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveWork(parr As %String, type As %String) As %String
{
	;s ^TMP("workparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgWork).%New()
	e  s obj=##class(DHCINM.HR.MgWork).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgWork","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="WorkPerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgWork","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="WorkPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("WorkStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod GetWorkStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCINM.HR.MgWork).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.WorkStatus
	q flag
}

ClassMethod AuditWorkRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgWork).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.WorkStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.WorkStatus="A")||(obj.WorkStatus="B"))) d
		.s WorkStatus=$case(obj.WorkStatus,"A":"审核","B":"驳回") ;状态描述
		.s WorkUnit=$lg($g(^DHCINM.HR.MgWorkD(id)),5)
		.s WorkStDate1=$lg($g(^DHCINM.HR.MgWorkD(id)),3) 
		.s WorkStDate=""
		.s:WorkStDate1'="" WorkStDate=$zd(WorkStDate1,3)
		.s perId=$lg($g(^DHCINM.HR.MgWorkD(id)),2) 
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/工作经历】"_WorkStatus_" "_WorkUnit_" "_WorkStDate
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgWork",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询工作经历列表
/// Date:2017-08-30
/// Table: CF.DHCINM.HR.Educate
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindWorkList","")
Query FindWorkList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWorkListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	;s ^TMP("parrwork")=parr
	s par="" f  s par=$O(^DHCINM.HR.MgWorkI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgWorkI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgWork).%OpenId(rw)
	..i obj.WorkStDate'="" s WorkStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.WorkStDate)
	..e  s WorkStDate=""
	..i obj.WorkEndDate'="" s WorkEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.WorkEndDate)
	..e  s WorkEndDate=""
	..s WorkUnit=obj.WorkUnit
	..i obj.WorkPost'="" s WorkPost=..GetCommCode(obj.WorkPost)
	..e  s WorkPost=""
	..i obj.WorkDuty'="" s WorkDuty=..GetCommCode(obj.WorkDuty)
	..e  s WorkDuty=""
	..s WorkRemark=obj.WorkRemark
	..s worktype=""
	..i obj.WorkStatus="N" s workStatus="保存"
	..e  i obj.WorkStatus="Y" s workStatus="提交"
	..e  i obj.WorkStatus="A" s workStatus="审核"
	..e  i obj.WorkStatus="B" s workStatus="驳回"
	..s statusCode=obj.WorkStatus
	..s ret="workStDate|"_WorkStDate_"^workEndDate|"_WorkEndDate_"^workUnit|"_WorkUnit_"^workPost|"_WorkPost_"^workDuty|"_WorkDuty_"^workRemark|"_WorkRemark_"^workRowID|"_rw_"^worktype|"_worktype_"^workStatus|"_workStatus_"^statusCode|"_statusCode  
	..do OutputEduData
	s ret=""
	s transrw="" f  s transrw=$O(^CF.DHCINM.Trans.TransDepI("ssdr"," "_parr,transrw)) q:transrw=""  d
	.s transobj=##class(CF.DHCINM.Trans.TransDep).%OpenId(transrw)
	.q:transobj.PerTranCurrent="P"
	.s WorkStDate=""
	.i transobj.PerTranStDate'="" s WorkStDate=##class(web.INMHISComm).DateLogicalToHtml(transobj.PerTranStDate)
	.e  s WorkStDate=""
	.s WorkEndDate=""
	.i transobj.PerTranEndDate'="" s WorkEndDate=##class(web.INMHISComm).DateLogicalToHtml(transobj.PerTranEndDate)
	.e  s WorkEndDate=""
	.s WorkUnit=""
	.i transobj.PerDepart'="" d
	..s unitObj=##class(CF.DHCINM.DB.MgWard).%OpenId(transobj.PerDepart)
	..s WorkUnit=unitObj.WardDesc
	.;s workPost=""
	.;s postrowid="" f  s postrowid=$O(^CF.DHCINM.HR.PostDutyI("ssid",par,postrowid)) q:postrowid=""  d
	.s worktype="T"
	.s statusCode="A"
	.s ret="workStDate|"_WorkStDate_"^workEndDate|"_WorkEndDate_"^workUnit|"_WorkUnit_"^workPost|"_""_"^workDuty|"_""_"^workRemark|"_""_"^workRowID|"_transrw_"^worktype|"_worktype_"^statusCode|"_statusCode
	.do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkListExecute ]
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

ClassMethod FindWorkListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取工作经历记录
/// Date:2017-08-30
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetWorkItem(id As %String) As %String
{
	;s ^TMP("workitm")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgWork).%OpenId(id)
	i obj.WorkStDate'="" s WorkStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.WorkStDate)
	e  s WorkStDate=""
	i obj.WorkEndDate'="" s WorkEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.WorkEndDate)
	e  s WorkEndDate=""
	s WorkUnit=obj.WorkUnit
	s WorkDuty=obj.WorkDuty
	s WorkPost=obj.WorkPost
	s WorkRemark=obj.WorkRemark
	s ret="WorkStDate|"_WorkStDate_"^WorkEndDate|"_WorkEndDate_"^WorkUnit|"_WorkUnit_"^WorkPost|"_WorkPost_"^WorkDuty|"_WorkDuty_"^WorkRemark|"_WorkRemark_"^RowID|"_id
	q ret
}

/// Creator:guozj
/// Description:保存护士层级信息
/// Date:2017-08-30
/// Table: CF.DHCINM.HR.MgLevel
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveLevel(parr As %String, type As %String) As %String
{
	;s ^TMP("levelparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(CF.DHCINM.HR.MgLevel).%New()
	e  s obj=##class(CF.DHCINM.HR.MgLevel).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.HR.MgLevel","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="LevelPerDR" d
	...s ptype=^oddCOM("CF.DHCINM.HR.MgLevel","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="LevelPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("LevelStatus")=type
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod GetLevelStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(CF.DHCINM.HR.MgLevel).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.LevelStatus
	q flag
}

ClassMethod AuditLevelRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.HR.MgLevel).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.LevelStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.LevelStatus="A")||(obj.LevelStatus="B"))) d
		.s LevelStatus=$case(obj.LevelStatus,"A":"审核","B":"驳回") ;状态描述
		.s NurLevel=##class(web.INMPersonComm).GetCommCode(obj.NurLevel)
		.s LevelDate1=$lg($g(^CF.DHCINM.HR.MgLevelD(id)),4) 
		.s LevelDate=""
		.s:LevelDate1'="" LevelDate=$zd(LevelDate1,3)
		.s LevelFactor=$lg($g(^CF.DHCINM.HR.MgLevelD(id)),7) 
		.s perId=$lg($g(^CF.DHCINM.HR.MgLevelD(id)),2) 
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/护理层级】"_LevelStatus_" "_NurLevel_" "_LevelDate_" "_LevelFactor
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","CF.DHCINM.HR.MgLevel",id)
	}catch{
	}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询护士层级列表
/// Date:2017-08-30
/// Table: CF.DHCINM.HR.MgLevel
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindLevelList","1")
Query FindLevelList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindLevelListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	;s ^TMP("parrlevel")=parr
	s par="" f  s par=$O(^CF.DHCINM.HR.MgLevelI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^CF.DHCINM.HR.MgLevelI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(CF.DHCINM.HR.MgLevel).%OpenId(rw)
	..i obj.LevelDate'="" s LevelDate=##class(web.INMHISComm).DateLogicalToHtml(obj.LevelDate)
	..e  s LevelDate=""
	..i obj.NurLevel'="" s NurLevel=..GetCommCode(obj.NurLevel)
	..e  s NurLevel=""
	..s LevelRemark=obj.LevelRemark
	..s status=""
	..i obj.LevelStatus="N" s status="保存"
	..e  i obj.LevelStatus="Y" s status="提交"
	..e  i obj.LevelStatus="A" s status="审核"
	..e  i obj.LevelStatus="B" s status="驳回"
	..s levelFactor=obj.LevelFactor
	..s ret="levelDate|"_LevelDate_"^nurLevel|"_NurLevel_"^levelRemark|"_LevelRemark_"^levelRowID|"_rw_"^status|"_status_"^levelFactor|"_levelFactor    
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLevelListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLevelListExecute ]
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

ClassMethod FindLevelListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLevelListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取护士层级记录
/// Date:2017-08-30
/// Table: CF.DHCINM.HR.MgLevel
/// Input:
/// Output：
/// Return:
ClassMethod GetLevelItem(id As %String) As %String
{
	;s ^TMP("levelitm")=id
	s ret=""
	q:id="" ""
	s obj=##class(CF.DHCINM.HR.MgLevel).%OpenId(id)
	i obj.LevelDate'="" s LevelDate=##class(web.INMHISComm).DateLogicalToHtml(obj.LevelDate)
	e  s LevelDate=""
	s NurLevel=obj.NurLevel
	s LevelRemark=obj.LevelRemark
	s LevelFactor=obj.LevelFactor
	s ret="LevelDate|"_LevelDate_"^NurLevel|"_NurLevel_"^LevelRemark|"_LevelRemark_"^RowID|"_id_"^LevelFactor|"_LevelFactor
	q ret
}

/// Creator:guozj
/// Description:按照病区取护士信息
/// Date:2017-08-31
/// Table: CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindNurInfoOfWard","1","0","0")
Query FindNurInfoOfWard(parr As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurInfoOfWardExecute(ByRef qHandle As %Binary, parr As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("parrnurse")=parr_"%"_role_"%"_nurseid
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s dep="" f  s dep=$O(^CF.DHCINM.HR.PersonsI("DepID",dep)) q:dep=""  d
	.s rowid="" f  s rowid=$O(^CF.DHCINM.HR.PersonsI("DepID",dep,rowid)) q:rowid=""  d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowid)
	..s curward=##class(web.INMHRComm).GetCurrentWard(rowid,+$h)
	..q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	..q:((parr'="")&&(curward'=parr))
	..q:obj.PerTypeDR'="N"
	..s nursename=obj.PerName
	..s nurseno=obj.PerID
	..s ret="nursename|"_nursename_"^nurseno|"_nurseno_"^nurserow|"_rowid_"^nursedep|"_obj.PerDepDR
	..do OutputNurData

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurInfoOfWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurInfoOfWardExecute ]
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

ClassMethod FindNurInfoOfWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurInfoOfWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:保存技术能手、服务之星数据
/// Date:2017-08-31
/// Table: DHCINM.HR.MgTechService
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveElectes(parr As %String) As %String
{
	;s ^TMP("electeparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgTechService).%New()
	e  s obj=##class(DHCINM.HR.MgTechService).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgTechService","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("DHCINM.HR.MgTechService","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

/// Creator:guozj
/// Description:查询技术能手、服务之星数据列表
/// Date:2017-08-31
/// Table: DHCINM.HR.MgTechService
/// Input:parr:2017-08-01^2017-08-31^2^N
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindElecteList","")
Query FindElecteList(parr As %String = "", type As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindElecteListExecute(ByRef qHandle As %Binary, parr As %String = "", type As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	;s ^TMP("parrelecter")=parr_"&"_type_"&"_role_"&"_nurseid
	s stmonth=$p(parr,"^",1)
	i stmonth'="" s stdate=$zdh(stmonth,3)
	e  s stdate=""
	s endmonth=$p(parr,"^",2)
	i endmonth'="" s enddate=$zdh(endmonth,3)
	e  s enddate=""
	s ward=$p(parr,"^",3)
	s statu=$p(parr,"^",4)
	k tmpWard
	s tmpWard="",isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s date="" f  s date=$O(^DHCINM.HR.MgTechServiceI("type"," "_type,date)) q:date=""  d
	.s rowid="" f  s rowid=$O(^DHCINM.HR.MgTechServiceI("type"," "_type,date,rowid)) q:rowid=""  d
	..s obj=##class(DHCINM.HR.MgTechService).%OpenId(rowid)
	..q:((stdate'="")&&(obj.ElecteDate<stdate))
	..q:((enddate'="")&&(obj.ElecteDate>enddate))
	..q:(isAll=0)&&((obj.ElecteWard="")||('$d(tmpWard(obj.ElecteWard))))
	..q:((ward'="")&&(obj.ElecteWard'=ward))
	..q:((statu'="")&&(obj.ElecteStatus'=statu))
	..i obj.ElecteNurse'="" s ElecteNurse=..GetNurseInfo(obj.ElecteNurse)
	..e  s ElecteNurse=""
	..i obj.ElecteDate'="" s ElecteDate=$E($zd(obj.ElecteDate,8),1,4)_"-"_$E($zd(obj.ElecteDate,8),5,6)
	..e  s ElecteDate=""
	..i obj.ElecteWard'="" d
	...s rec=##class(web.INMDBComm).GetWard(obj.ElecteWard)
	...s ElecteWard=$p($p(rec,"^",3),"|",2)
	..e  s ElecteWard=""
	..i obj.ElecteUser=0 s ElecteUser="管理员"
	..e  i (obj.ElecteUser'="")&&(obj.ElecteUser'=0) s ElecteUser=..GetUserInfo(obj.ElecteUser)
	..e  s ElecteUser=""
	..s RecDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RecDate)
	..i obj.ElecteStatus="N" s ElecteStatus="未提交"
	..e  i obj.ElecteStatus="Y" s ElecteStatus="已提交"
	..s ret="electeNurse|"_ElecteNurse_"^electeDate|"_ElecteDate_"^electeWard|"_ElecteWard_"^electeUser|"_ElecteUser_"^recDate|"_RecDate_"^electeStatus|"_ElecteStatus_"^rowid|"_rowid
	..s ret=ret_"^electeUserId|"_obj.ElecteUser
	..do OutputElecterData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputElecterData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindElecteListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindElecteListExecute ]
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

ClassMethod FindElecteListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindElecteListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取技术能手 服务之星数据
/// Date:2017-08-31
/// Table: DHCINM.HR.MgTechService
/// Input:
/// Output：
/// Return:
ClassMethod GetElecteItem(id As %String) As %String
{
	;s ^TMP("electeritm")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgTechService).%OpenId(id)
	s ElecteNurse=obj.ElecteNurse
	i obj.ElecteDate'="" s ElecteDate=##class(web.INMHISComm).DateLogicalToHtml(obj.ElecteDate)
	.e  s ElecteDate=""
	s ElecteWard=obj.ElecteWard
	s ret="ElecteNurse|"_ElecteNurse_"^ElecteDate|"_ElecteDate_"^ElecteWard|"_ElecteWard_"^RowID|"_id
	q ret
}

/// Creator:guozj
/// Description:获取技术能手 服务之星记录状态
/// Date:2017-08-31
/// Table: DHCINM.HR.MgTechService
/// Input:
/// Output：
/// Return:
ClassMethod JudgeRec(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCINM.HR.MgTechService).%OpenId(id)
	q:'$IsObject(obj)
	s ret=obj.ElecteStatus
	q ret
}

/// Creator:guozj
/// Description:保存奖惩情况数据
/// Date:2017-09-05
/// Table: DHCINM.HR.MgNurReward
/// Input:
/// Output：
/// Return:
ClassMethod SaveReward(parr As %String) As %String
{
	;s ^TMP("rewardparr")=parr
	s tmp="",oPerson=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgNurReward).%New()
	e  s obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgNurReward","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p="RewardNurse" d
	...s oPerson=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	...s tmp(p)=oPerson
	..e  d
	...s ptype=^oddCOM("DHCINM.HR.MgNurReward","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	; 如果RewardWard是空的，那么就把护士的病区赋之
	s:$ZOBJPROPERTY(obj,"RewardWard")="" $ZOBJPROPERTY(obj,"RewardWard")=oPerson.PerDepDR
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

ClassMethod AuditReward(id, type)
{
	s ^TMP("AuditReward")=id_"##"_type
	s obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
	q:'$IsObject(obj)
	s obj.RewardStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.RewardStatus="A")||(obj.RewardStatus="B"))) d
		.s RewardStatus=$case(obj.RewardStatus,"A":"审核","B":"驳回") ;状态描述
		.s RewardContent=$lg($g(^DHCINM.HR.MgNurRewardD(id)),4)
		.s RewardDate1=$lg($g(^DHCINM.HR.MgNurRewardD(id)),8) 
		.s RewardDate=""
		.s:RewardDate1'="" RewardDate=$zd(RewardDate1,3)
		.s perId=$lg($g(^DHCINM.HR.MgNurRewardD(id)),2)	
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/获奖情况】"_RewardStatus_" "_RewardContent_" "_RewardDate
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgNurReward",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询奖惩情况信息
/// Date:2017-09-05
/// Table:DHCINM.HR.MgNurReward
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRewardList","^^2020-06-01^2020-08-02",0,0)
Query FindRewardList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRewardListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	;s ^TMP("rewardlist")=parr_"%"_role_"%"_nurseid //10001^2^2017-09-01^2017-09-06
	s nurno=$tr($p(parr,"^",1)," ","")
	s nurdep=$p(parr,"^",2)
	s stdate=$p(parr,"^",3)
	s enddate=$p(parr,"^",4)
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s date="" f  s date=$O(^DHCINM.HR.MgNurRewardI("ssid",date)) q:date=""  d
	.s nurse="" f  s nurse=$O(^DHCINM.HR.MgNurRewardI("ssid",date,nurse)) q:nurse=""  d
	..s rowid="" f  s rowid=$O(^DHCINM.HR.MgNurRewardI("ssid",date,nurse,rowid)) q:rowid=""  d
	...s obj=##class(DHCINM.HR.MgNurReward).%OpenId(rowid)
	...q:(isAll=0)&&((obj.RewardWard="")||('$d(tmpWard(obj.RewardWard))))
	...s nurseID=obj.RewardNurse.PerID
	...s nurseName=obj.RewardNurse.PerName
	...s nurseShell=##class(web.INMVueComm).ToChineseSpell(nurseName)
	...q:((nurno'="")&&(nurseID_nurseName_nurseShell'[$zcvt(nurno,"U")))
	...q:((nurdep'="")&&(obj.RewardWard'=nurdep))
	...q:((stdate'="")&&(obj.RewardDate<stdate))
	...q:((enddate'="")&&(obj.RewardDate>enddate))
	...;s WardStr=##class(web.INMDBComm).GetWard(obj.RewardWard)
	...;s rewardWard=$p($p(WardStr,"^",3),"|",2)
	...i obj.RewardWard'="" d
	....s WardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.RewardWard)
	....s rewardWard=WardObj.WardDesc
	...e  s rewardWard=""
	...s rewardContent=obj.RewardContent
	...s rewardResult=obj.RewardResult
	...i obj.RewardLevel'="" s rewardLevel=..GetCommCode(obj.RewardLevel)
	...e  s rewardLevel=""
	...i obj.RewardDate'="" s rewardDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RewardDate)
	...e  s rewardDate=""
	...s Status=$case(obj.RewardStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	...s ret="^nurseID|"_nurseID_"^rewardStatus|"_Status_"^nurseName|"_nurseName_"^rewardWard|"_rewardWard_"^rewardContent|"_rewardContent_"^rewardResult|"_rewardResult_"^rewardLevel|"_rewardLevel_"^rewardDate|"_rewardDate_"^rowid|"_rowid
	...do OutputRewardData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRewardData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRewardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRewardListExecute ]
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

ClassMethod FindRewardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRewardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:查询奖惩情况记录
/// Date:2017-09-05
/// Table: DHCINM.HR.MgNurReward
/// Input:
/// Output：
/// Return:
ClassMethod GetRewardRec(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
	s RewardNurse=obj.RewardNurse.%Id()
	s RewardWard=obj.RewardWard
	s RewardContent=obj.RewardContent
	s RewardUnit=obj.RewardUnit
	s RewardResult=obj.RewardResult
	s RewardLevel=obj.RewardLevel
	i obj.RewardDate'="" s RewardDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RewardDate)
	e  s RewardDate=""
	s RewardTeacher=obj.RewardTeacher
	s Certifier=obj.Certifier
	s RewardMark=obj.RewardMark
	s RewardRecorder=obj.RewardRecorder
	s RewardRecordDate=$zd(obj.RewardRecordDate,3)
	s ret="RewardNurse|"_RewardNurse_"^RewardWard|"_RewardWard_"^RewardContent|"_RewardContent_"^RewardUnit|"_RewardUnit_"^RewardResult|"_RewardResult_"^RewardLevel|"_RewardLevel_"^RewardDate|"_RewardDate_"^RewardTeacher|"_RewardTeacher_"^Certifier|"_Certifier_"^RewardMark|"_RewardMark_"^RowID|"_id
	s ret=ret_"^RewardRecorder|"_RewardRecorder_"^RewardRecordDate|"_RewardRecordDate
	q ret
}

ClassMethod GetRoleItem(id As %String) As %String
{
	;s ^TMP("roleitm")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgNurRole).%OpenId(id)
	s RoleID=obj.RoleID
	i obj.RoleStDate'="" s RoleStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RoleStDate)
	e  s RoleStDate=""
	i obj.RoleEndDate'="" s RoleEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RoleEndDate)
	e  s RoleEndDate=""
	s ret="RoleID|"_RoleID_"^RoleStDate|"_RoleStDate_"^RoleEndDate|"_RoleEndDate_"^RowID|"_id
	q ret
}

/// Creator:guozj
/// Description:保存护士角色信息
/// Date:2017-10-09
/// Table: DHCINM.HR.MgNurRole
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveRole(parr As %String) As %String
{
	;s ^TMP("roleparr")=parr //RoleID|5^RoleStDate|2018-03-14^RoleEndDate|^RowID|3045^RolePerDR|514
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s PerDR=$tr($g(tmp("RolePerDR"))," ","")
	s id=$g(tmp("RowID"))
	TS
	i id="" s obj=##class(DHCINM.HR.MgNurRole).%New()
	e  s obj=##class(DHCINM.HR.MgNurRole).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgNurRole","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p'="RolePerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgNurRole","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="RolePerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	i $$$ISOK(sc) d
	.s RoleRaw=$O(^DHCINM.Set.MgRoleNurseI("nurse",$tr($g(tmp("RoleID"))," ","")," "_$tr($g(PerDR)," ",""),""))
	.i RoleRaw="" d
	..i $g(tmp("RoleEndDate"))="" d
	...s RoleObj=##class(DHCINM.Set.MgRoleNurse).%New()
	...s RoleObj.Parref=##class(CT.DHCINM.Set.MgRoles).%OpenId($tr($g(tmp("RoleID"))," ",""))
	...s RoleObj.RoleNurse=PerDR
	...i $g(tmp("RoleStDate"))'="" s RoleObj.RoleStDate=$tr($g(tmp("RoleStDate"))," ","")
	...e  s RoleObj.RoleStDate=""
	...s rolesc=RoleObj.%Save()
	...i $$$ISOK(rolesc) d
	....TCOMMIT
	...e  d
	....TROLLBACK
	..e  d
	...TCOMMIT
	.e  d
	..i $g(tmp("RoleEndDate"))'="" d
	...s RoleObj=##class(DHCINM.Set.MgRoleNurse).%OpenId($tr($g(tmp("RoleID"))," ","")_"||"_RoleRaw)
	...s rolesc=RoleObj.%DeleteId($tr($g(tmp("RoleID"))," ","")_"||"_RoleRaw)
	...i $$$ISOK(rolesc) d
	....TCOMMIT
	...e  d
	....TROLLBACK
	..e  d
	...TCOMMIT
	e  d
	.TROLLBACK
	
	q 0
}

/// Creator:guozj
/// Description:查询角色列表
/// Date:2017-10-09
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindNurRoleList")
Query FindNurRoleList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurRoleListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s perid="" f  s perid=$O(^DHCINM.HR.MgNurRoleI("ssid",perid),-1) q:perid=""  d
	.q:((parr'="")&&(perid'=parr))
	.s rowid="" f  s rowid=$O(^DHCINM.HR.MgNurRoleI("ssid",perid,rowid),-1) q:rowid=""  d
	..s obj=##class(DHCINM.HR.MgNurRole).%OpenId(rowid)
	..s roleid=obj.RoleID
	..s roleCode="",roleName=""
	..i roleid'="" d
	...s roleobj=##class(CT.DHCINM.Set.MgRoles).%OpenId(roleid)
	...s roleCode=roleobj.RoleCode
	...s roleName=roleobj.RoleDesc
	..i obj.RoleStDate'="" s rolestdate=##class(web.INMHISComm).DateLogicalToHtml(obj.RoleStDate)
	..e  s rolestdate=""
	..i obj.RoleEndDate'="" s roleenddate=##class(web.INMHISComm).DateLogicalToHtml(obj.RoleEndDate)
	..e  s roleenddate=""
	..s ret="roleCode|"_roleCode_"^roleName|"_roleName_"^rolestdate|"_rolestdate_"^roleenddate|"_roleenddate_"^roleRowID|"_rowid
	..do OutputRoleList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoleList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurRoleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurRoleListExecute ]
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

ClassMethod FindNurRoleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurRoleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:高级查询：病区列表
/// Date:2017-10-25
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindAdvWardList")
Query FindAdvWardList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAdvWardListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	
	do OutputRoleList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoleList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdvWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdvWardListExecute ]
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

ClassMethod FindAdvWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdvWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:批量审核调科申请
/// Date:2017-11-06
/// Table:DHCINM.Trans.MgTransApp
/// Input:
/// Output：
/// Return:
ClassMethod MultipleAudit(id As %String, user As %String) As %String
{
	;s ^TMP("MultipleAudit")=id_"%"_user
	s obj=##class(DHCINM.Trans.MgTransApp).%OpenId(id)
	q:'$IsObject(obj) "审核失败"
	q:obj.TransStatus'="Y" "非提交状态不可审核"
	s obj.TransOpinion="批量审核"
	s obj.TransStatus="A"
	s len=obj.TransNurse.Count()
	f i=1:1:len
	{
		s itm=obj.TransNurse.GetAt(i)
		s nurseid=$P(itm,"|",2)
		s nursedep=obj.TransInDep
		s stdate=$zd(obj.TransDate,3)
		i obj.TransDate<=(+$H)
		{
			s parr="^"_nurseid_"^"_nursedep_"^"_stdate_"^0^Y^^"_obj.%Id()_"^"_obj.TranSpecy
			d ..SaveTransData(parr)
			d ##class(web.INMSysTaskComm).ChangePerDepInfo(nurseid,nursedep,obj.TransDate)
		}
		else
		{
			s parr="^"_nurseid_"^"_nursedep_"^"_stdate_"^0^P^^"_obj.%Id()_"^"_obj.TranSpecy
			;d ..SaveTransData(parr)
			s objNew=##class(CF.DHCINM.Trans.TransDep).%New()
			s objNew.PerDr=nurseid
			s objNew.PerDepart=nursedep
			s objNew.PerTranStDate=$zdh(stdate,3)
			s objNew.PerTranStTime=$p($H,",",2)
			s objNew.PerTranCurrent="P"
			s objNew.PerAppID=obj.%Id()
			s objNew.PerTransType=obj.TranSpecy
			d objNew.%Save()
		}
		
	}
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Description:上传附件
/// Date:2017-11-18
/// Table:CF.DHCINM.HR.HireDuty\CF.DHCINM.HR.Educate
/// Input:记录表ID||记录表||文件保存路径
/// Output：
/// Return:
/// Others: d ##Class(web.INMPersonComm).InsertPic("3||0||Fileupdate/images/cert/2/Hydrangeas.jpg")
ClassMethod InsertPic(parr As %String) As %String
{
	k tmp
	s id=$p(parr,"||")
	s type=$p(parr,"||",2)
	s Certs=$p(parr,"||",3)
	i type="2"
	{
		s sc=##class(web.INMSpecialComm).SaveSpecialNurFile(id,Certs)
	}
	else
	{
		s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(id)
		if type="1"{//学历表
			s obj=##class(CF.DHCINM.HR.Educate).%OpenId(id)
		}
		s:type="3" obj=##class(DHCINM.HR.MgQualRegisted).%OpenId(id)
		s:type="4" obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
		s:type="5" obj=##class(DHCINM.HR.MgNurPraise).%OpenId(id)
		s:type="6" obj=##class(DHCINM.HR.MgNurCritic).%OpenId(id)
		s len=obj.CertPic.Count()
		f i=1:1:len d
		.s tmp(obj.CertPic.GetAt(i))=obj.CertPic.GetAt(i)
		s l=$l(Certs,"^")
		f i=1:1:l d
		.s Cert=$p(Certs,"^",i)
		.i $d(tmp(Cert))=0 d obj.CertPic.Insert(Cert)
		s sc=obj.%Save()
		k tmp
	}
	q $$$ISOK(sc)
}

/// 
/// 保存奖励惩罚证书
ClassMethod InsertRewardCard(parr As %String) As %String
{
	s ^TMP("InsertRewardCard")=parr
	s id=$p(parr,"^")
	s Certs=$p(parr,"^",2)
	b ;01
	s obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
	q:'$IsObject(obj) ""
	
	d obj.CertPic.Insert(Certs)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:获取奖惩证书
/// Date:2017-11-18
/// Table:
/// Input:记录表ID
/// Output：
/// Return:
/// Others: w ##class(web.INMPersonComm).FindCert("3||0")
ClassMethod GetRewardCert(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
	s len=obj.CertPic.Count()
	s ret=""
	f i=1:1:len d
	.s itm=obj.CertPic.GetAt(i)
	.i i=1 s ret=itm
	.e  s ret=ret_"^"_itm
	
	q id_"|"_ret
}

ClassMethod DeleteRewardCert(parr As %String) As %String
{
	s ^TMP("DeleteRewardCert")=parr
	s id=$p(parr,"|")
	s cert=$p(parr,"|",2)
	s tmp=""
	s obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
	s len=obj.CertPic.Count()
	f i=1:1:len
	{
		s itm=obj.CertPic.GetAt(i)
		i itm="" continue
		i itm'=cert s tmp(i)=itm
	}
	d obj.CertPic.Clear()
	s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
	.d obj.CertPic.Insert(tmp(rw))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lulin
/// Description:删除证书
/// Date:2017-11-18
/// Table:CF.DHCINM.HR.HireDuty、CF.DHCINM.HR.Educate
/// Input:记录表ID||记录表||删除文件的路径
/// Output：
/// Return:
/// Others: autoplay
ClassMethod DeleteCert(parr As %String) As %String
{
	s id=$p(parr,"||")
	s type=$p(parr,"||",2)
	s cert=$p(parr,"||",3)
	;默认存储到职称表
	s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(id)
	s:type="1" obj=##class(CF.DHCINM.HR.Educate).%OpenId(id)
	; 专科发展图片删除与其他子模块不同
	if type="2" {
		q ##class(web.INMSpecialComm).DeleteSpecialNurFile(id, cert, 0)
	}
	s:type="3" obj=##class(DHCINM.HR.MgQualRegisted).%OpenId(id)
	s:type="4" obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
	s:type="5" obj=##class(DHCINM.HR.MgNurPraise).%OpenId(id)
	s:type="6" obj=##class(DHCINM.HR.MgNurCritic).%OpenId(id)
	s len=obj.CertPic.Count()
	f i=1:1:len d
	.s itm=obj.CertPic.GetAt(i)
	.i itm'=cert s tem(i)=itm
	d obj.CertPic.Clear()
	s i=0
	f  s i=$o(tem(i)) q:i=""  d
	.d obj.CertPic.Insert(tem(i))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lulin
/// Description:获取证书
/// Date:2017-11-18
/// Table:CF.DHCINM.HR.HireDuty、CF.DHCINM.HR.Educate
/// Input:记录表ID||记录表
/// Output：
/// Return:
/// Others: w ##class(web.INMPersonComm).FindCert("3||0")
ClassMethod FindCert(parr As %String) As %String
{
	s id=$p(parr,"||")
	s type=$p(parr,"||",2)
	;默认存储到职称表
	s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(id)
	if type="1"{//学历表
		s obj=##class(CF.DHCINM.HR.Educate).%OpenId(id)
	}
	if type="2"{//专科发展表
		s obj=##class(DHCINM.Special.SpecialNurse).%OpenId(id)
		s ret=""
		f i=1:1:$l(obj.SpecialCertificate,"」") d
		.s itm=$p(obj.SpecialCertificate,"」",i)
		.i i=1 s ret=itm
		.e  s ret=ret_"^"_itm
		q id_"||"_type_"||"_ret
	}
	if type="3"{//资格注册表
		s obj=##class(DHCINM.HR.MgQualRegisted).%OpenId(id)
	}
	if type="4"{//奖惩表
		s obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
	}
	if type="5"{//表扬表
		s obj=##class(DHCINM.HR.MgNurPraise).%OpenId(id)
	}
	if type="6"{//批评表
		s obj=##class(DHCINM.HR.MgNurCritic).%OpenId(id)
	}
	s len=obj.CertPic.Count()
	s ret=""
	f i=1:1:len d
	.s itm=obj.CertPic.GetAt(i)
	.i i=1 s ret=itm
	.e  s ret=ret_"^"_itm
	q id_"||"_type_"||"_ret
}

/// Creator:lulin
/// Description:获取所有证书
/// Date:2017-11-21
/// Table:CF.DHCINM.HR.HireDuty、CF.DHCINM.HR.Educate、DHCINM.HR.MgSpecialDevelop、DHCINM.HR.MgQualRegisted
/// Input:记录表ID||记录表
/// Output：
/// Return:
/// Others: w ##class(web.INMPersonComm).FindAllCert("15")
ClassMethod FindAllCert(parr As %String) As %String
{
	q:parr="" ""
	s ret=""
	s par="" f  s par=$O(^CF.DHCINM.HR.HireDutyI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^CF.DHCINM.HR.HireDutyI("ssid",par,rw)) q:rw=""  d
	..s r=..FindCert(rw_"||"_0)
	..i ($l($p(r,"||",3))'=0) d
	...i ret="" s ret=r
	...e  s ret=ret_"@"_r
	s par="" f  s par=$O(^CF.DHCINM.HR.EducateI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^CF.DHCINM.HR.EducateI("ssid",par,rw)) q:rw=""  d
	..s r=..FindCert(rw_"||"_1)
	..i ($l($p(r,"||",3))'=0) d
	...i ret="" s ret=r
	...e  s ret=ret_"@"_r
	s rw="" f  s rw=$O(^DHCINM.Special.SpecialNurseI("Person",parr,rw)) q:rw=""  d
	.s r=..FindCert(rw_"||"_2)
	.b ;debug
	.i ($l($p(r,"||",3))'=0) d
	..i ret="" s ret=r
	..e  s ret=ret_"@"_r
	q ret
}

ClassMethod AuditSure(type As %String, reason As %String, id As %String, audituser As %String) As %String
{
	//Y%%1%483
	s flag=1
	s ^TMP("type")=type_"%"_reason_"%"_id_"%"_audituser
	q:id="" "0"
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	q:'$IsObject(obj) "0"
	s obj.PerAuditFlag=type
	s obj.AuditReason=$tr(reason," ","")
	s obj.PerAuditor=audituser
	s obj.PerAuditDate=+$H
	s obj.AuditTime=+$p($H,",",2)
	i type="Y" d
	.s auditType="P"
	.s opStatus="A"
	e  d
	.s auditType="B"
	.s opStatus="U"
	TSTART
	s sc=obj.%Save()
	s flag=flag&&$$$ISOK(sc)
	;以下审核时同时新增一条操作记录--20220117--chenpeng
	s operate=##class(DHCINM.HR.MgPerOperate).%New()
	s operate.Status=opStatus
	s operate.Type=auditType	
	s operate.Operator=audituser
	s operate.Comment=reason
	s operate.OpDate=+$h
	s operate.OpTime=$p($h,",",2)
	s operate.Person=obj
	s sc=operate.%Save()
	s flag=flag&&$$$ISOK(sc)
	if (flag) {
		TCOMMIT
	} else {
		TROLLBACK
	}
	q flag
}

/// Creator:lulin
/// Description:判断人员是否存在
/// Date:2017-12-12
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:zw ##class(web.INMPersonComm).IsExistbycard(622201199309188132)
ClassMethod IsExistbycard(cardid) As %String
{
	s flag=-1
	s rowid=$O(^CF.DHCINM.HR.PersonsI("card"," "_$zcvt(cardid,"U"),""))
	i rowid'="" d
	.s flag=0
	q flag_"^"_rowid
}

/// Creator:lulin
/// Description:判断人员是否存在
/// Date:2017-12-12
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:zw ##class(web.INMPersonComm).IsExistbyWardAndName("57^谢立平")
ClassMethod IsExistbyWardAndName(realname) As %String
{
	s flag=-1
	s wardid=$p(realname,"^")
	s name=$zcvt($p(realname,"^",2),"U")
	s perflag=0
	s rowid=""
	s perid="" f  s perid=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_wardid,perid)) q:(perid="")||(perflag'=0)  d
	.s per=##class(CF.DHCINM.HR.Persons).%OpenId(perid)
	.i $zcvt(per.PerName,"U")=name d
	..s flag=0,rowid=perid
	..s perflag=-1
	q flag_"^"_rowid
}

/// Creator:lulin
/// Description:判断人员工号是否存在
/// Date:2017-12-12
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:zw ##class(web.INMPersonComm).IsExistbyWardAndName("57^谢立平")
ClassMethod IsExistByHISNo(realname) As %String
{
	s flag=-1
	s HISID=$p(realname,"^")
	s name=$zcvt($p(realname,"^",2),"U")
	s rowid=$O(^CF.DHCINM.HR.PersonsI("hisno"," "_HISID,""))
	s:rowid'="" flag=0
	q flag_"^"_rowid
}

/// Creator:lulin
/// Description:批量上传时保存头像
/// Date:2017-12-12
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod saveperpic(parr As %String = "") As %String
{
	q:parr="" ""
	s perid=$p(parr,"^")
	s pic=$p(parr,"^",2)
	q:perid="" ""
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(perid)
	s obj.PerPic=pic
	d obj.%Save()
	q obj.%Id()
}

ClassMethod SysncPersonData() As %String
{
}

ClassMethod GetAuditStatus(id) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	s inpostStatus=..GetCommCode(obj.PerStatus)
	i inpostStatus="在职" d
	.s status=obj.PerAuditFlag
	e  i inpostStatus="离职" d
	.s status="R"
	e  i inpostStatus="退休" d
	.s status="T"
	q status
}

/// Creator:gzj
/// Description:优化查询人员列表
/// Date:2018-09-17
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindNurseList","1")
Query FindNurseList(parr As %String = "", column As %String = "", order As %String = "", advflag As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseListExecute(ByRef qHandle As %Binary, parr As %String = "", column As %String = "", order As %String = "", advflag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",rettmp=""
	s tmp=""
	// !!!6^7^17!5&&&0
	s ^TMP("FindNurseList")=parr_"&"_column_"&"_order_"&"_advflag
	i advflag="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i advflag=0
	{
		s wardVal=$P(parr,"!",2)
		s nameVal=$P(parr,"!",3)
		;s noVal=$P(parr,"!",4)
		;s status=$P(parr,"!",4)
		s roleid=$P(parr,"!",4) //角色id 
		s nurseid=$p(parr,"!",5) // 人员id
	}
	i advflag=1
	{
		s wardVal=$p(parr,"!",1) //病区
		s hireVal=$p(parr,"!",2)  //职称
		s postVal=$p(parr,"!",3) //职务
		s levelVal=$p(parr,"!",4) //层级
		s sourceVal=$p(parr,"!",5) //护士来源
		s politVal=$p(parr,"!",6) //政治面貌
		s firEduVal=$p(parr,"!",7) //第一学历
		s maxEduVal=$p(parr,"!",8) //最高学历
		s roleid=$P(parr,"!",9) //角色id 
		s nurseid=$p(parr,"!",10) // 人员id
	}
	i roleid=0
	{
		s spell="" f  s spell=$O(^CF.DHCINM.DB.MgWardI("Spell",spell)) q:spell=""  d
		.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardI("Spell",spell,id)) q:id=""  d
		..s RowID="" f  s RowID=$O(^CF.DHCINM.HR.PersonsI("DepID"," "_id,RowID)) q:RowID=""  d
		...s obj=##class(CF.DHCINM.HR.Persons).%OpenId(RowID)
		...q:(obj.PerTypeDR'="N")
		...q:((advflag=0)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
		...q:((advflag=0)&&(nameVal'="")&&((obj.PerName_obj.PerID)'[nameVal))
		...q:((advflag=1)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
		...q:((advflag=1)&&(sourceVal'="")&&(sourceVal'[obj.PerSource))
		...q:((advflag=1)&&(politVal'="")&&(politVal'[obj.PerPolitical))
		...q:((advflag=1)&&(hireVal'="")&&(..CheckHireDuty(RowID,hireVal)=0))
		...q:((advflag=1)&&(postVal'="")&&(..CheckPost(RowID,postVal)=0))
		...q:((advflag=1)&&(levelVal'="")&&(..CheckLevel(RowID,levelVal)=0))
		...q:((advflag=1)&&(firEduVal'="")&&(..CheckEdu(RowID,firEduVal,"0")=0))
		...q:((advflag=1)&&(maxEduVal'="")&&(..CheckEdu(RowID,maxEduVal,"1")=0))
		...s NurseName=obj.PerName
		...s NurseID=obj.PerID
		...s NurseDep=$P($P($g(^CTLOC(obj.PerDepDR)),"^",2),"-",2)
		...s NurseDep=$list($g(^CF.DHCINM.DB.MgWardD(obj.PerDepDR)),3)
		...i obj.PerBirthday'="" s PerBirthday=##class(web.INMHISComm).DateLogicalToHtml(obj.PerBirthday)
		...e  s PerBirthday=""
		...s PerCardId=obj.PerCardId
		...s PerAge=""
		...i obj.PerBirthday'="" d
		....s age=##class(web.INMVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
		....s PerAge=$p(age,"Y",1)
		...i obj.PerComeDate'="" s PerComeDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerComeDate)
		...e  s PerComeDate=""
		...s PerComeYear=""
		...i PerComeDate'="" d
		....s comeyear=##class(web.INMVueComm).CalAge(PerComeDate,$zd(+$H,3))
		....s PerComeYear=$p(comeyear,"Y",1)
		...i obj.PerDepDate'="" s PerDepDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerDepDate)
		...e  s PerDepDate=""
		...i obj.PerWorkDate'="" s PerWorkDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerWorkDate)
		...e  s PerWorkDate=""
		...s PerRegNo=obj.PerRegNo
		...i obj.PerStatus'="" s PerStatus=..GetCommCode(obj.PerStatus)
		...e  s PerStatus=""
		...i obj.PerMarriage'="" s PerMarriage=..GetCommCode(obj.PerMarriage)
		...e  s PerMarriage=""
		...i obj.PerSource'="" s PerSource=..GetCommCode(obj.PerSource)
		...e  s PerSource=""
		...i obj.PerPolitical'="" s PerPolitical=..GetCommCode(obj.PerPolitical)
		...e  s PerPolitical=""
		...i obj.PerNation'="" s PerNation=..GetCommCode(obj.PerNation)
		...e  s PerNation=""
		...i obj.PerClothesNo'="" s PerClothesNo=..GetCommCode(obj.PerClothesNo)
		...e  s PerClothesNo=""
		...i obj.PerTrouserNo'="" s PerTrouserNo=..GetCommCode(obj.PerTrouserNo)
		...e  s PerTrouserNo=""
		...i obj.PerShoesNo'="" s PerShoesNo=..GetCommCode(obj.PerShoesNo)
		...e  s PerShoesNo=""
		...i obj.PerWordType'="" s PerWordType=..GetCommCode(obj.PerWordType)
		...e  s PerWordType=""
		...s HISNO=obj.HISNO
		...s PerNativePlace=obj.PerNativePlace
		...s PerAddress=obj.PerAddress
		...i obj.PerCadreDate'="" s PerCadreDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerCadreDate)
		...e  s PerCadreDate=""
		...q:obj.PerStatus'=##class(web.INMImportDBData).GetSetCode("在职状态","在职")
		...s PerAuditFlag=""
		...i obj.PerAuditFlag="Y" s PerAuditFlag="已审核"
		...e  i obj.PerAuditFlag="B" s PerAuditFlag="已驳回" 
		...s rettmp="PerName|"_NurseName_"^PerID|"_NurseID_"^PerDepDR|"_NurseDep_"^PerBirthday|"_PerBirthday_"^PerCardId|"_PerCardId_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerWorkDate|"_PerWorkDate_"^PerRegNo|"_PerRegNo_"^rowid|"_RowID_"^PerStatus|"_PerStatus_"^PerMarriage|"_PerMarriage_"^PerSource|"_PerSource_"^PerPolitical|"_PerPolitical_"^PerNation|"_PerNation_"^PerClothesNo|"_PerClothesNo_"^PerTrouserNo|"_PerTrouserNo_"^PerShoesNo|"_PerShoesNo_"^PerWordType|"_PerWordType_"^PerAge|"_PerAge_"^PerComeYear|"_PerComeYear_"^HISNO|"_HISNO_"^PerNativePlace|"_PerNativePlace_"^PerAddress|"_PerAddress_"^PerCadreDate|"_PerCadreDate_"^PerAuditFlag|"_PerAuditFlag
		...s tmp(NurseDep,RowID)=rettmp
	}
	else
	{
		f j=1:1:$l(roleid,"^")
		{
			s roleitm=$p(roleid,"^",j)
			i roleitm="" continue
			s rolecode=##class(web.INMLoginComm).GetLoginRoleCode(roleitm)
			i ((rolecode="hlbzr")||(rolecode="hlb")||(rolecode="znurhead")||(rolecode="nurhead")||(rolecode="manager"))
			{
				s rolerw="" f  s rolerw=$O(^DHCINM.DB.MgDataLimitI("Role"," "_roleitm," "_nurseid,rolerw)) q:rolerw=""  d
				.s roledeprw="" f  s roledeprw=$O(^DHCINM.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
				..s roledepobj=##class(DHCINM.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
				..s spell="" f  s spell=$O(^CF.DHCINM.DB.MgWardI("Spell",spell)) q:spell=""  d
				...s id="" f  s id=$O(^CF.DHCINM.DB.MgWardI("Spell",spell,id)) q:id=""  d
				....q:(id'=roledepobj.SubWard)
				....s RowID="" f  s RowID=$O(^CF.DHCINM.HR.PersonsI("DepID"," "_id,RowID)) q:RowID=""  d
				.....s obj=##class(CF.DHCINM.HR.Persons).%OpenId(RowID)
				.....q:(obj.PerTypeDR'="N")
				.....q:((rolecode="nurse")&&(nurseid'="")&&(RowID'=nurseid))
				.....q:((advflag=0)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				.....q:((advflag=0)&&(nameVal'="")&&((obj.PerName_obj.PerID)'[nameVal))
				.....q:((advflag=1)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				.....q:((advflag=1)&&(sourceVal'="")&&(obj.PerSource'=sourceVal))
				.....q:((advflag=1)&&(politVal'="")&&(obj.PerPolitical'=politVal))
				.....q:((advflag=1)&&(hireVal'="")&&(..CheckHireDuty(RowID,hireVal)=0))
				.....q:((advflag=1)&&(postVal'="")&&(..CheckPost(RowID,postVal)=0))
				.....q:((advflag=1)&&(levelVal'="")&&(..CheckLevel(RowID,levelVal)=0))
				.....q:((advflag=1)&&(firEduVal'="")&&(..CheckEdu(RowID,firEduVal,"0")=0))
				.....q:((advflag=1)&&(maxEduVal'="")&&(..CheckEdu(RowID,maxEduVal,"1")=0))
				.....s NurseName=obj.PerName
				.....s NurseID=obj.PerID
				.....s NurseDep=$P($P($g(^CTLOC(obj.PerDepDR)),"^",2),"-",2)
				.....s NurseDep=$list($g(^CF.DHCINM.DB.MgWardD(obj.PerDepDR)),4)
				.....i obj.PerBirthday'="" s PerBirthday=##class(web.INMHISComm).DateLogicalToHtml(obj.PerBirthday)
				.....e  s PerBirthday=""
				.....s PerCardId=obj.PerCardId
				.....s PerAge=""
				.....i obj.PerBirthday'="" d
				......s age=##class(web.INMVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
				......s PerAge=$p(age,"Y",1)
				.....i obj.PerDepDate'="" s PerDepDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerDepDate)
				.....e  s PerDepDate=""
				.....i obj.PerComeDate'="" s PerComeDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerComeDate)
				.....e  s PerComeDate=""
				.....s PerComeYear=""
				.....i PerComeDate'="" d
				......s comeyear=##class(web.INMVueComm).CalAge(PerComeDate,$zd(+$H,3))
				......s PerComeYear=$p(comeyear,"Y",1)
				.....i obj.PerWorkDate'="" s PerWorkDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerWorkDate)
				.....e  s PerWorkDate=""
				.....s PerRegNo=obj.PerRegNo
				.....i obj.PerStatus'="" s PerStatus=..GetCommCode(obj.PerStatus)
				.....e  s PerStatus=""
				.....i obj.PerMarriage'="" s PerMarriage=..GetCommCode(obj.PerMarriage)
				.....e  s PerMarriage=""
				.....i obj.PerSource'="" s PerSource=..GetCommCode(obj.PerSource)
				.....e  s PerSource=""
				.....i obj.PerPolitical'="" s PerPolitical=..GetCommCode(obj.PerPolitical)
				.....e  s PerPolitical=""
				.....i obj.PerNation'="" s PerNation=..GetCommCode(obj.PerNation)
				.....e  s PerNation=""
				.....i obj.PerClothesNo'="" s PerClothesNo=..GetCommCode(obj.PerClothesNo)
				.....e  s PerClothesNo=""
				.....i obj.PerTrouserNo'="" s PerTrouserNo=..GetCommCode(obj.PerTrouserNo)
				.....e  s PerTrouserNo=""
				.....i obj.PerShoesNo'="" s PerShoesNo=..GetCommCode(obj.PerShoesNo)
				.....e  s PerShoesNo=""
				.....i obj.PerWordType'="" s PerWordType=..GetCommCode(obj.PerWordType)
				.....e  s PerWordType=""
				.....s HISNO=obj.HISNO
				.....s PerNativePlace=obj.PerNativePlace
				.....s PerAddress=obj.PerAddress
				.....i obj.PerCadreDate'="" s PerCadreDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerCadreDate)
				.....e  s PerCadreDate=""
				.....q:obj.PerStatus'=##class(web.INMImportDBData).GetSetCode("在职状态","在职")
				.....s PerAuditFlag=""
				.....i obj.PerAuditFlag="Y" s PerAuditFlag="已审核"
				.....e  i obj.PerAuditFlag="B" s PerAuditFlag="已驳回"
				.....s rettmp="PerName|"_NurseName_"^PerID|"_NurseID_"^PerDepDR|"_NurseDep_"^PerBirthday|"_PerBirthday_"^PerCardId|"_PerCardId_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerWorkDate|"_PerWorkDate_"^PerRegNo|"_PerRegNo_"^rowid|"_RowID_"^PerStatus|"_PerStatus_"^PerMarriage|"_PerMarriage_"^PerSource|"_PerSource_"^PerPolitical|"_PerPolitical_"^PerNation|"_PerNation_"^PerClothesNo|"_PerClothesNo_"^PerTrouserNo|"_PerTrouserNo_"^PerShoesNo|"_PerShoesNo_"^PerWordType|"_PerWordType_"^PerAge|"_PerAge_"^PerComeYear|"_PerComeYear_"^HISNO|"_HISNO_"^PerNativePlace|"_PerNativePlace_"^PerAddress|"_PerAddress_"^PerCadreDate|"_PerCadreDate_"^PerAuditFlag|"_PerAuditFlag
				.....s tmp(NurseDep,RowID)=rettmp
			}
			else
			{
				s obj=##class(CF.DHCINM.HR.Persons).%OpenId(nurseid)
				q:(obj.PerTypeDR'="N")
				;q:((rolecode="nurse")&&(nurseid'="")&&(RowID'=nurseid))
				q:((advflag=0)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				q:((advflag=0)&&(nameVal'="")&&(obj.PerName'[nameVal))
				q:((advflag=1)&&(wardVal'="")&&(obj.PerDepDR'=wardVal))
				q:((advflag=1)&&(sourceVal'="")&&(obj.PerSource'=sourceVal))
				q:((advflag=1)&&(politVal'="")&&(obj.PerPolitical'=politVal))
				q:((advflag=1)&&(hireVal'="")&&(..CheckHireDuty(RowID,hireVal)=0))
				q:((advflag=1)&&(postVal'="")&&(..CheckPost(RowID,postVal)=0))
				q:((advflag=1)&&(levelVal'="")&&(..CheckLevel(RowID,levelVal)=0))
				q:((advflag=1)&&(firEduVal'="")&&(..CheckEdu(RowID,firEduVal,"0")=0))
				q:((advflag=1)&&(maxEduVal'="")&&(..CheckEdu(RowID,maxEduVal,"1")=0))
				s NurseName=obj.PerName
				s NurseID=obj.PerID
				s NurseDep=$P($P($g(^CTLOC(obj.PerDepDR)),"^",2),"-",2)
				s NurseDep=$list($g(^CF.DHCINM.DB.MgWardD(obj.PerDepDR)),4)
				i obj.PerBirthday'="" s PerBirthday=##class(web.INMHISComm).DateLogicalToHtml(obj.PerBirthday)
				e  s PerBirthday=""
				s PerCardId=obj.PerCardId
				s PerAge=""
				i obj.PerBirthday'="" d
				.s age=##class(web.INMVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
				.s PerAge=$p(age,"Y",1)
				i obj.PerDepDate'="" s PerDepDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerDepDate)
				e  s PerDepDate=""
				i obj.PerComeDate'="" s PerComeDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerComeDate)
				e  s PerComeDate=""
				s PerComeYear=""
				i PerComeDate'="" d
				.s comeyear=##class(web.INMVueComm).CalAge(PerComeDate,$zd(+$H,3))
				.s PerComeYear=$p(comeyear,"Y",1)
				i obj.PerWorkDate'="" s PerWorkDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerWorkDate)
				e  s PerWorkDate=""
				s PerRegNo=obj.PerRegNo
				i obj.PerStatus'="" s PerStatus=..GetCommCode(obj.PerStatus)
				e  s PerStatus=""
				i obj.PerMarriage'="" s PerMarriage=..GetCommCode(obj.PerMarriage)
				e  s PerMarriage=""
				i obj.PerSource'="" s PerSource=..GetCommCode(obj.PerSource)
				e  s PerSource=""
				i obj.PerPolitical'="" s PerPolitical=..GetCommCode(obj.PerPolitical)
				e  s PerPolitical=""
				i obj.PerNation'="" s PerNation=..GetCommCode(obj.PerNation)
				e  s PerNation=""
				i obj.PerClothesNo'="" s PerClothesNo=..GetCommCode(obj.PerClothesNo)
				e  s PerClothesNo=""
				i obj.PerTrouserNo'="" s PerTrouserNo=..GetCommCode(obj.PerTrouserNo)
				e  s PerTrouserNo=""
				i obj.PerShoesNo'="" s PerShoesNo=..GetCommCode(obj.PerShoesNo)
				e  s PerShoesNo=""
				i obj.PerWordType'="" s PerWordType=..GetCommCode(obj.PerWordType)
				e  s PerWordType=""
				s HISNO=obj.HISNO
				s PerNativePlace=obj.PerNativePlace
				s PerAddress=obj.PerAddress
				i obj.PerCadreDate'="" s PerCadreDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerCadreDate)
				e  s PerCadreDate=""
				q:obj.PerStatus'=##class(web.INMImportDBData).GetSetCode("在职状态","在职")
				s PerAuditFlag=""
				i obj.PerAuditFlag="Y" s PerAuditFlag="已审核"
				e  i obj.PerAuditFlag="B" s PerAuditFlag="已驳回"
				s rettmp="PerName|"_NurseName_"^PerID|"_NurseID_"^PerDepDR|"_NurseDep_"^PerBirthday|"_PerBirthday_"^PerCardId|"_PerCardId_"^PerDepDate|"_PerDepDate_"^PerComeDate|"_PerComeDate_"^PerWorkDate|"_PerWorkDate_"^PerRegNo|"_PerRegNo_"^rowid|"_nurseid_"^PerStatus|"_PerStatus_"^PerMarriage|"_PerMarriage_"^PerSource|"_PerSource_"^PerPolitical|"_PerPolitical_"^PerNation|"_PerNation_"^PerClothesNo|"_PerClothesNo_"^PerTrouserNo|"_PerTrouserNo_"^PerShoesNo|"_PerShoesNo_"^PerWordType|"_PerWordType_"^PerAge|"_PerAge_"^PerComeYear|"_PerComeYear_"^HISNO|"_HISNO_"^PerNativePlace|"_PerNativePlace_"^PerAddress|"_PerAddress_"^PerCadreDate|"_PerCadreDate_"^PerAuditFlag|"_PerAuditFlag
				s tmp(NurseDep,nurseid)=rettmp
			}
		}
	}
	
	;i column'="" d
	;.s ret=""
	;.i order="ascending" d
	;..s desc="" f  s desc=$O(tmp(desc)) q:desc=""  d
	;...s rw="" f  s rw=$O(tmp(desc,rw)) q:rw=""  d
	;....s ret=tmp(desc,rw)
	;....do OutputPerData
	;.e  i order="descending" d
	;..s desc="" f  s desc=$O(tmp(desc),-1) q:desc=""  d
	;...s rw="" f  s rw=$O(tmp(desc,rw),-1) q:rw=""  d
	;....s ret=tmp(desc,rw)
	;....do OutputPerData
	;e  d OutputPerData
	s tmpward="" f  s tmpward=$O(tmp(tmpward)) q:tmpward=""  d
	.s tmpid="" f  s tmpid=$O(tmp(tmpward,tmpid)) q:tmpid=""  d
	..s ret=tmp(tmpward,tmpid)
	..d OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseListExecute ]
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

ClassMethod FindNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UndoRecData(id As %String, operator As %String) As %String
{
	q:id="" 0
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.PerAuditFlag="N"
	s obj.PerAuditor=operator
	s obj.PerAuditDate=+$h
	;以下撤销审核时同时新增一条操作记录--20220117--chenpeng
	TSTART
	s sc=obj.%Save()
	if ($$$ISOK(sc)) {
		s perOperate=##class(DHCINM.HR.MgPerOperate).%New()
		s perOperate.Type="R"
		s perOperate.OpDate=+$h
		s perOperate.OpTime=$p($h,",",2)
		s perOperate.Operator=operator
		s perOperate.Status="U"
		s perOperate.Person=obj
		s sc=perOperate.%Save()
	}
	if ($$$ISOK(sc)) {
		TCOMMIT
	} else {
		TROLLBACK
	}
	q $$$ISOK(sc)
}

/// Creator:liuning
/// Description:保存科室护士考核情况
/// Date:2019-09-05
/// Table: DHCINM.HR.NurAssessment
/// Input:
/// Output：
/// Return:
/// Others: zw ##class(web.INMPersonComm).SaveNurAssess("ElecteWard|13^ElecteNurse|88^ElecteDate|2019-09-01^ElecteTheory|11^ElecteTechnical|22^ElecteUser|0^RowID|^ElecteStatus|N")
ClassMethod SaveNurAssess(parr As %String) As %String
{
	;s ^TMP("electeparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s tmp("ElecteYear")=$p($zdate(+$h,3),"-",1)
	i id="" s obj=##class(DHCINM.HR.NurAssessment).%New()
	e  s obj=##class(DHCINM.HR.NurAssessment).%OpenId(id)
	s electdate=$zdh(tmp("ElecteDate"),3)
	s isExist=$d(^DHCINM.HR.NurAssessmentI("dep",electdate," "_tmp("ElecteNurse")," "_tmp("ElecteWard")))
	q:(isExist)&&($g(tmp("RowID"))="") "该护士该月份成绩已存在！"
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.NurAssessment","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("DHCINM.HR.NurAssessment","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q 1
}

/// Creator:liuning
/// Description:查询科室护士考核情况
/// Date:2019-09-05
/// Table: DHCINM.HR.NurAssessment
/// Input:
/// Output：
/// Return:
/// Others:w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindNurAssessList","2019-09-01^2019-09-30^^","0","0")
Query FindNurAssessList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurAssessListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s stmonth=$p(parr,"^",1)
	i stmonth'="" s stdate=$zdh(stmonth,3)
	e  s stdate=""
	s endmonth=$p(parr,"^",2)
	i endmonth'="" s enddate=$zdh(endmonth,3)
	e  s enddate=""
	s ward=$p(parr,"^",3)
	s statu=$p(parr,"^",4)
	k tmpWard
	s tmpWard="",isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s date="" f  s date=$O(^DHCINM.HR.NurAssessmentI("type",date)) q:date=""  d
	.s rowid="" f  s rowid=$O(^DHCINM.HR.NurAssessmentI("type",date,rowid)) q:rowid=""  d
	..s obj=##class(DHCINM.HR.NurAssessment).%OpenId(rowid)
	..q:((stdate'="")&&(obj.ElecteDate<stdate))
	..q:((enddate'="")&&(obj.ElecteDate>enddate))
	..q:(isAll=0)&&((obj.ElecteWard="")||('$d(tmpWard(obj.ElecteWard))))
	..q:((ward'="")&&(obj.ElecteWard'=ward))
	..q:((statu'="")&&(obj.ElecteStatus'=statu))
	..i obj.ElecteNurse'="" s ElecteNurse=..GetNurseInfo(obj.ElecteNurse)
	..e  s ElecteNurse=""
	..i obj.ElecteDate'="" s ElecteDate=$E($zd(obj.ElecteDate,8),1,4)_"-"_$E($zd(obj.ElecteDate,8),5,6)
	..e  s ElecteDate=""
	..i obj.ElecteWard'="" d
	...s rec=##class(web.INMDBComm).GetWard(obj.ElecteWard)
	...s ElecteWard=$p($p(rec,"^",3),"|",2)
	..e  s ElecteWard=""
	..i obj.ElecteUser=0 s ElecteUser="管理员"
	..e  i (obj.ElecteUser'="")&&(obj.ElecteUser'=0) s ElecteUser=..GetNurseInfo(obj.ElecteUser)
	..e  s ElecteUser=""
	..s RecDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RecDate)
	..i obj.ElecteStatus="N" s ElecteStatus="未提交"
	..e  i obj.ElecteStatus="Y" s ElecteStatus="已提交"
	..s ret="electeNurse|"_ElecteNurse_"^electeDate|"_ElecteDate_"^electeWard|"_ElecteWard_"^electeUser|"_ElecteUser_"^recDate|"_RecDate_"^electeStatus|"_ElecteStatus_"^rowid|"_rowid_"^electeTheory|"_obj.ElecteTheory_"^electeTechnical|"_obj.ElecteTechnical
	..do OutputElecterData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputElecterData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurAssessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurAssessListExecute ]
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

ClassMethod FindNurAssessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurAssessListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:liuning
/// Description:获取考核数据
/// Date:2019-09-05
/// Table: DHCINM.HR.NurAssessment
/// Input:
/// Output：
/// Return:
ClassMethod GetNurAssessItem(id As %String) As %String
{
	;s ^TMP("electeritm")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.NurAssessment).%OpenId(id)
	s ElecteNurse=obj.ElecteNurse
	i obj.ElecteDate'="" s ElecteDate=##class(web.INMHISComm).DateLogicalToHtml(obj.ElecteDate)
	.e  s ElecteDate=""
	s ElecteWard=obj.ElecteWard
	s ret="ElecteNurse|"_ElecteNurse_"^ElecteDate|"_ElecteDate_"^ElecteWard|"_ElecteWard_"^RowID|"_id_"^ElecteTheory|"_obj.ElecteTheory_"^ElecteTechnical|"_obj.ElecteTechnical
	q ret
}

/// Creator:liuning
/// Description:获取考核状态
/// Date:2019-09-05
/// Table: DHCINM.HR.NurAssessment
/// Input:
/// Output：
/// Return:
ClassMethod NurAssess(id As %String) As %String
{
	s ret=""
	s obj=##class(DHCINM.HR.NurAssessment).%OpenId(id)
	q:'$IsObject(obj)
	s ret=obj.ElecteStatus
	q ret
}

/// Creator:liuning
/// Description:查询科室护士考核情况汇总
/// Date:2019-09-23
/// Table: DHCINM.HR.NurAssessment
/// Input:
/// Output：
/// Return:
/// Others:w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindAssessSumList","2019-01-01^","0","0")
Query FindAssessSumList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAssessSumListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s findyear=$p(parr,"^",1)
	s ward=$p(parr,"^",2)
	k tmpWard
	s tmpWard="",isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s nur="" f  s nur=$O(^DHCINM.HR.NurAssessmentI("sum",nur)) q:nur=""  d
	.s year="" f  s year=$O(^DHCINM.HR.NurAssessmentI("sum",nur,year)) q:year=""  d
	..s checkyear=" "_$p(findyear,"-",1)
	..q:((findyear'="")&&(year'=checkyear))
	..s nurid=$p(nur," ",2)
	..s checkward=##class(CF.DHCINM.HR.Persons).%OpenId(nurid).PerDepDR
	..q:((ward'="")&&(ward'=checkward))
	..s ElecteTheory="",ElecteTechnical=""
	..s ElecteTheory2="",ElecteTechnical2=""
	..s ElecteTheory3="",ElecteTechnical3=""
	..s ElecteTheory4="",ElecteTechnical4=""
	..s ElecteTheory5="",ElecteTechnical5=""
	..s ElecteTheory6="",ElecteTechnical6=""
	..s ElecteTheory7="",ElecteTechnical7=""
	..s ElecteTheory8="",ElecteTechnical8=""
	..s ElecteTheory9="",ElecteTechnical9=""
	..s ElecteTheory10="",ElecteTechnical10=""
	..s ElecteTheory11="",ElecteTechnical11=""
	..s ElecteTheory12="",ElecteTechnical12=""
	..s rowid="" f  s rowid=$O(^DHCINM.HR.NurAssessmentI("sum",nur,year,rowid)) q:rowid=""  d
	...s obj=##class(DHCINM.HR.NurAssessment).%OpenId(rowid)	
	...s month=$p($zdate(obj.ElecteDate,3),"-","2")
	...i month="01" d
	....s ElecteTheory=obj.ElecteTheory
	....s ElecteTechnical=obj.ElecteTechnical
	...i month="02" d
	....s ElecteTheory2=obj.ElecteTheory
	....s ElecteTechnical2=obj.ElecteTechnical
	...i month="03" d
	....s ElecteTheory3=obj.ElecteTheory
	....s ElecteTechnical3=obj.ElecteTechnical
	...i month="04" d
	....s ElecteTheory4=obj.ElecteTheory
	....s ElecteTechnical4=obj.ElecteTechnical
	...i month="05" d
	....s ElecteTheory5=obj.ElecteTheory
	....s ElecteTechnical5=obj.ElecteTechnical
	...i month="06" d
	....s ElecteTheory6=obj.ElecteTheory
	....s ElecteTechnical6=obj.ElecteTechnical
	...i month="07" d
	....s ElecteTheory7=obj.ElecteTheory
	....s ElecteTechnical7=obj.ElecteTechnical
	...i month="08" d
	....s ElecteTheory8=obj.ElecteTheory
	....s ElecteTechnical8=obj.ElecteTechnical
	...i month="09" d
	....s ElecteTheory9=obj.ElecteTheory
	....s ElecteTechnical9=obj.ElecteTechnical
	...i month="10" d
	....s ElecteTheory10=obj.ElecteTheory
	....s ElecteTechnical10=obj.ElecteTechnical
	...i month="11" d
	....s ElecteTheory11=obj.ElecteTheory
	....s ElecteTechnical11=obj.ElecteTechnical
	...i month="12" d
	....s ElecteTheory12=obj.ElecteTheory
	....s ElecteTechnical12=obj.ElecteTechnical
	...i obj.ElecteNurse'="" s ElecteNurse=..GetNurseInfo(obj.ElecteNurse)
	...e  s ElecteNurse=""
	...i obj.ElecteWard'="" d
	....s rec=##class(web.INMDBComm).GetWard(obj.ElecteWard)
	....s ElecteWard=$p($p(rec,"^",3),"|",2)
	...e  s ElecteWard=""
	...s ElecteYear=obj.ElecteYear
	..s ret="ElecteNurse|"_ElecteNurse_"^ElecteWard|"_ElecteWard_"^ElecteTheory|"_ElecteTheory_"^ElecteTechnical|"_ElecteTechnical
	..s ret=ret_"^ElecteTheory2|"_ElecteTheory2_"^ElecteTechnical2|"_ElecteTechnical2_"^ElecteTheory3|"_ElecteTheory3_"^ElecteTechnical3|"_ElecteTechnical3
	..s ret=ret_"^ElecteTheory4|"_ElecteTheory4_"^ElecteTechnical4|"_ElecteTechnical4_"^ElecteTheory5|"_ElecteTheory5_"^ElecteTechnical5|"_ElecteTechnical5
	..s ret=ret_"^ElecteTheory6|"_ElecteTheory6_"^ElecteTechnical6|"_ElecteTechnical6_"^ElecteTheory7|"_ElecteTheory7_"^ElecteTechnical7|"_ElecteTechnical7
	..s ret=ret_"^ElecteTheory8|"_ElecteTheory8_"^ElecteTechnical8|"_ElecteTechnical8_"^ElecteTheory9|"_ElecteTheory9_"^ElecteTechnical9|"_ElecteTechnical9
	..s ret=ret_"^ElecteTheory10|"_ElecteTheory10_"^ElecteTechnical10|"_ElecteTechnical10_"^ElecteTheory11|"_ElecteTheory11_"^ElecteTechnical11|"_ElecteTechnical11
	..s ret=ret_"^ElecteTheory12|"_ElecteTheory12_"^ElecteTechnical12|"_ElecteTechnical12_"^ElecteYear|"_ElecteYear	
	..do OutputElecterData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputElecterData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAssessSumListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAssessSumListExecute ]
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

ClassMethod FindAssessSumListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAssessSumListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:王聪聪
/// Date：2019-10-18
/// Desc：获取人员的病区id,病区,姓名
ClassMethod GetWardAndIdOfPerson(id, loginid)
{
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	q:'$IsObject(obj)
	s NameDesc=obj.PerName
	s rw=obj.PerDepDR
	s Wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(rw)
	q:'$IsObject(Wardobj)
	s WardDesc=Wardobj.WardDesc
	s ret="ResignWard|"_rw_"^ResignName|"_id_"^WardDesc|"_WardDesc_"^NameDesc|"_NameDesc
	q ret
}

/// Creator:wangcc
/// Description:保存组内职称信息
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupDuty
/// Input:
/// Output：
/// Return:
/// Others: HireDuty|14__2^HireStDate|2017-08-22^HireEndDate|^HireRemark|^RowID|^HirePerDR|1
ClassMethod SaveGroupDuty(parr As %String, type As %String) As %String
{
	s ^TMP("groupdutyparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s obj=""
	i id="" s obj=##class(DHCINM.HR.MgGroupDuty).%New()
	e  s obj=##class(DHCINM.HR.MgGroupDuty).%OpenId(id)
	s obj.GroupPerDR=$g(tmp("GroupPerDR"))
	s obj.GroupDuty=tmp("GroupDuty")
	s obj.GroupStDate=$zdh(tmp("GroupStDate"),3)
	s obj.GroupEndDate=$zdh(tmp("GroupEndDate"),3)
	s obj.GroupName=tmp("GroupName")
	s obj.GroupRemark=$g(tmp("GroupRemark"))
	s obj.GroupStatus=type
	d obj.%Save()
	q obj.%Id()
}

/// Creator:wangcc
/// Description:查询组内职务列表
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupDuty
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindGroupDutyList","")
Query FindGroupDutyList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindGroupDutyListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	;s ^TMP("parrpost")=parr
	s par="" f  s par=$O(^DHCINM.HR.MgGroupDutyI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgGroupDutyI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgGroupDuty).%OpenId(rw)
	..i obj.GroupDuty'="" s PostDuty=..GetCommCode(obj.GroupDuty)
	..e  s PostDuty=""
	..i obj.GroupStDate'="" s PostStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.GroupStDate)
	..e  s PostStDate=""
	..i obj.GroupEndDate'="" s PostEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.GroupEndDate)
	..e  s PostEndDate=""
	..s PostRemark=obj.GroupRemark
	..s PostGroup=..GetCommCode(obj.GroupName)
	..s status=""
	..i obj.GroupStatus="N" s status="保存"
	..e  i obj.GroupStatus="Y" s status="提交"
	..e  i obj.GroupStatus="A" s status="审核"
	..e  i obj.GroupStatus="B" s status="驳回"
	..s ret="GroupDuty|"_PostDuty_"^GroupName|"_PostGroup_"^GroupStDate|"_PostStDate_"^GroupEndDate|"_PostEndDate_"^GroupRemark|"_PostRemark_"^RowID|"_rw_"^status|"_status
	..do OutputPostData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPostData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindGroupDutyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupDutyListExecute ]
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

ClassMethod FindGroupDutyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupDutyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPostGroupStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCINM.HR.MgGroupDuty).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.GroupStatus
	q flag
}

/// Creator:wangcc
/// Description:获取组内职务记录
/// Date:2019-12-10
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetPostGroupItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgGroupDuty).%OpenId(id)
	s PostDuty=obj.GroupDuty
	i obj.GroupStDate'="" s PostStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.GroupStDate)
	e  s PostStDate=""
	i (obj.GroupEndDate'="")&&(obj.GroupEndDate<+$h) s PostEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.GroupEndDate)
	e  s PostEndDate=""
	s PostRemark=obj.GroupRemark
	s PostGroup=obj.GroupName
	s ret="GroupDuty|"_PostDuty_"^GroupName|"_PostGroup_"^GroupStDate|"_PostStDate_"^GroupEndDate|"_PostEndDate_"^GroupRemark|"_PostRemark_"^RowID|"_id
	q ret
}

ClassMethod AuditPostGroupRec(id As %String, type As %String) As %String
{
	q:id="" ""  
	s obj=##class(DHCINM.HR.MgGroupDuty).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.GroupStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:查询轮转计划列表
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupDuty
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRotationPlanList","")
Query FindRotationPlanList(parr) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRotationPlanListExecute(ByRef qHandle As %Binary, parr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s year=$p(parr,"^",1)
	s state=$p(parr,"^",2)
	s par="" f  s par=$O(^DHCINM.Trans.MgRotationPlanD(par)) q:par=""  d
	.s obj=##class(DHCINM.Trans.MgRotationPlan).%OpenId(par)
	.q:'$IsObject(obj)
	.s PlanYear=obj.PlanYear
	.q:(year'="")&&(year'=PlanYear)
	.s PlanName=obj.PlanName
	.s num=0
	.s detail="" f  s detail=$o(^DHCINM.Trans.MgRotationDetailI("plan"," "_par,detail)) q:detail=""  d
	..s num=num+1
	.s PlanPerNum=obj.PlanPerNum
	.q:(state'="")&&(state'=obj.PlanStatus)
	.s status=$case(obj.PlanStatus,"N":"已保存","P":"已发布")
	.s ret="PlanYear|"_PlanYear_"^PlanName|"_PlanName_"^PlanPerNum|"_num_"^PlanStatus|"_status_"^RowID|"_par
	.do OutputPostData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPostData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRotationPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRotationPlanListExecute ]
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

ClassMethod FindRotationPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRotationPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:查询轮转详情列表
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupDuty
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRotationDetailList","5","Ward","一病区")
Query FindRotationDetailList(id, type, value) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRotationDetailListExecute(ByRef qHandle As %Binary, id, type, value) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s did=""
	s sort="" f  s sort=$O(^DHCINM.Trans.MgRotationDetailI("sort"," "_id,sort)) q:sort=""  d
	.s did=$o(^DHCINM.Trans.MgRotationDetailI("sort"," "_id,sort,""))
	.s dObj=##class(DHCINM.Trans.MgRotationDetail).%OpenId(did)
	.q:'$IsObject(dObj)
	.s pobj=##class(CF.DHCINM.HR.Persons).%OpenId(dObj.RotationPerDR)
	.q:'$IsObject(pobj)
	.s PerID=pobj.PerID
	.s:PerID="" PerID=pobj.PerNo
	.s PerName=pobj.PerName
	.s PerInPostState=..GetCommCode(pobj.PerInNursePost)
	.q:(type'="")&&(value'="")&&(type="Nurse")&&(PerName'[value)
	.s currentEduca=$p(##class(web.INMHRComm).GetNurseEdu(dObj.RotationPerDR,+$h),"^",2)
	.q:(type'="")&&(value'="")&&(type="CurrentEduca")&&(currentEduca'[value)
	.s RotHour=..GetRotHour(pobj.%Id())
	.s ret="PerID|"_PerID_"^PerName|"_PerName_"^PerEduca|"_currentEduca_"^RowID|"_did_"^PerDR|"_pobj.%Id()_"^PerInPostState|"_PerInPostState
	.s exitFlag=0
	.s cycle="" f  s cycle=$o(^DHCINM.Trans.MgRotationCycleI("plan"," "_id,cycle))  q:((cycle="")||(exitFlag'=0))  d
	..s depId="",opret="",status="",ward="",teacher=""
	..f  s depId=$o(^DHCINM.Trans.MgRotationDepI("detaildr",did,cycle,depId)) q:((depId="")||(exitFlag'=0))  d
	...s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	...q:'$IsObject(depObj)
	...s:depObj.Teacher'="" teacher=$lg($g(^CF.DHCINM.HR.PersonsD(depObj.Teacher)),2)
	...s:(teacher'="")&&(type'="")&&(value'="")&&(type="Teacher")&&(teacher'[value) exitFlag=1
	...q:depObj.Ward=""
	...s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(depObj.Ward)
	...q:'$IsObject(wardobj)
	...s ward=wardobj.WardDesc
	...s:(type'="")&&(value'="")&&(type="Ward")&&($zcvt(ward,"U")'[$zcvt(value,"U")) exitFlag=1
	...i "RETEDEOETR"[depObj.Status  d
	....s opret=..GetRotOperate(depId)
	....s status=$case(depObj.Status,"RE":"离职终止","TE":"调岗终止","DE":"定科终止","OE":"其他情况终止","TR":"借调","":"")
	...s:status'="" status="("_status_")"
	..s ret=ret_"^"_cycle_"|"_ward_"!"_status_"^"_cycle_"his|"_opret
	.q:exitFlag'=0
	.s ret=ret_"^PerRotationHour|"_RotHour
	.do OutputRotDetailData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotDetailData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRotationDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRotationDetailListExecute ]
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

ClassMethod FindRotationDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRotationDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:获取轮转计划单条记录
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupPlan
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.INMPersonComm).GetRotationPlan(1)
ClassMethod GetRotationPlan(id)
{
	s obj=##class(DHCINM.Trans.MgRotationPlan).%OpenId(id)
	q:'$IsObject(obj)
	s PlanYear=obj.PlanYear
	s PlanName=obj.PlanName
	s ret="Year|"_PlanYear_"^PlanName|"_PlanName
	q ret
}

/// Creator:wangcc
/// Description:删除轮转计划记录
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupPlan
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod DeleteRotationPlan(id)
{
	s obj=##class(DHCINM.Trans.MgRotationPlan).%OpenId(id)
	q:'$IsObject(obj)
	s detail="" f  s detail=$o(^DHCINM.Trans.MgRotationDetailI("plan"," "_id,detail))  q:detail=""  d
	.d ##class(DHCINM.Trans.MgRotationDetail).%DeleteId(detail)
	s dep="" f  s dep=$o(^DHCINM.Trans.MgRotationDepI("planid"," "_id,dep))  q:dep=""  d
	.s his="" f  s his=$o(^DHCINM.Trans.MgRotationHistoryI("dep",dep,his))  q:his=""  d
	..d ##class(DHCINM.Trans.MgRotationHistory).%DeleteId(his)
	.d ##class(DHCINM.Trans.MgRotationDep).%DeleteId(dep)
	s cycle="" f  s cycle=$o(^DHCINM.Trans.MgRotationCycleI("plan"," "_id,cycle))  q:cycle=""  d
	.d ##class(DHCINM.Trans.MgRotationCycle).%DeleteId(cycle)
	s sc=obj.%DeleteId(id)
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Creator:wangcc
/// Description:保存轮转计划
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupPlan
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.INMPersonComm).SaveRotationPlan(2020!123!!N)
ClassMethod SaveRotationPlan(parr)
{
	s year=$p(parr,"!",1)
	s name=$p(parr,"!",2)
	s id=$p(parr,"!",3)
	s flag=$p(parr,"!",4)
	s flag1=1,first=1
	ts
	s obj=##class(DHCINM.Trans.MgRotationPlan).%New()
	s:id'="" obj=##class(DHCINM.Trans.MgRotationPlan).%OpenId(id),first=0
	q:'$IsObject(obj)
	s obj.PlanYear=year
	s obj.PlanName=name
	s obj.PlanStatus=flag
	s sc=obj.%Save()
	i '$$$ISOK(sc){
		tro
		q 0	
	}
	s:first=1 flag1=flag1&&..SaveRotCycle(obj.%Id())
	tro:flag1=0
#;	i first=1  d
#;	s rotcode=##class(web.INMImportDBData).GetSetCode("在岗状态","轮转")
#;	.s pid=""  f  s pid=$o(^CF.DHCINM.HR.PersonsI("PerInPost"," "_rotcode,pid)) q:pid=""  d
#;	..q:##class(web.INMHRComm).IsFormalWorkNur(pid,+$h,"")=0
#;	..s hour=0,rhour=0
#;	..s hour=+(..GetRotHour(pid))
#;	..s currentEduca=$p(##class(web.INMHRComm).GetNurseEdu(pid,+$h),"^",2)
#;	..i currentEduca'=""  d
#;	...s parref=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," "_currentEduca,""))
#;	...q:parref=""
#;	...s subid=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," "_currentEduca,parref,""))
#;	...s robj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(parref_"||"_subid)
#;	...q:'$IsObject(robj)
#;	...s rhour=robj.SubValue*30 
#;	..i (rhour>0)&&((hour=0)||((currentEduca'="")&&(hour<rhour)))  d
#;	...s dobj=##class(DHCINM.Trans.MgRotationDetail).%New()
#;	...s dobj.PlanDR=obj.%Id()
#;	...s dobj.RotationHour=hour
#;	...s dobj.RotationPerDR=pid
#;	...s dobj.FieldSort=$tr($o(^DHCINM.Trans.MgRotationDetailI("sort"," "_obj.%Id(),""),-1)," ","")+1
#;	...s sc=dobj.%Save()
#;	...s flag1=flag1&&($$$ISOK(sc))
#;	i flag1=0 {
#;		tro
#;		q flag1
#;	}
	tc:flag1=1
	q flag1
}

/// Creator:wangcc
/// Description:发布轮转计划,检测所有时段是否有交叉
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupPlan
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod IsHaveTransDep(id)
{
	s ret=""
	s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("planid"," "_id,depId)) q:depId=""  d
	.s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	.q:'$IsObject(depObj)
	.s stdate=depObj.CycleDR.StDate
	.s enddate=depObj.CycleDR.EndDate
	.s nurseid=depObj.DetailDR.RotationPerDR
	.s inward=depObj.Ward
	.s pername=$lg(^CF.DHCINM.HR.PersonsD(nurseid),2)
	.;检测轮转时段和弹性调配时段是否重叠
	.s:ret'="" ret=ret_","_..IsHasRepeatTransDep(nurseid,stdate,enddate)
	.s:ret="" ret=..IsHasRepeatTransDep(nurseid,stdate,enddate)
	q ret
}

/// Creator:wangcc
/// Description:发布轮转计划
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupPlan
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod CheckRotationPlan(id, flag, parr)
{
	s ret=..IsHasArgInRotation(parr)
	s ret1=..IsHaveTransDep(id)
	q:(ret'=0)&&(ret1'="") ret_"内存在排班,"_ret1_"和调配或其他轮转存在时段交叉，请修改轮转时段"
	q:(ret'=0)&&(ret1="") ret_"内存在排班"
	q:(ret=0)&&(ret1'="") ret1_"和调配或其他轮转存在时段交叉，请修改轮转时段"
	ts
	s obj=##class(DHCINM.Trans.MgRotationPlan).%OpenId(id)
	q:'$IsObject(obj)
	s obj.PlanStatus=flag	
	s sc=obj.%Save()
	i '$$$ISOK(sc) 
	{
		tro
		q 0
	}
	s depId="",sc=1
	f  s depId=$o(^DHCINM.Trans.MgRotationDepI("planid"," "_id,depId)) q:((depId="")||(sc=0))  d
	.s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	.q:'$IsObject(depObj)
	.s stdate=depObj.CycleDR.StDate
	.s enddate=depObj.CycleDR.EndDate
	.s nurseid=depObj.DetailDR.RotationPerDR
	.s inward=depObj.Ward
	.q:inward=""
	.s curryward=##class(web.INMHRComm).GetCurrentWard(nurseid,stdate)
	.s transParr="TransStDate|"_stdate_"^TransEndDate|"_enddate_"^NurseId|"_nurseid_"^WardId|"_curryward_"^InWard|"_inward
	.s sc=sc&&(..SaveTransDep(transParr,"","",depId,""))
	i sc'=0 
	{
		tc
	}else{
		tro
	}
	q sc
}

/// Creator:wangcc
/// Description:删除轮转详情记录
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupDetail、Dep
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.INMPersonComm).DeleteRotationDetail(1)
ClassMethod DeleteRotationDetail(ids)
{
	s flag=0
	ts
	f i=1:1:$l(ids,"「") q:flag=1  d
	.s id=$p(ids,"「",i)
	.s obj=##class(DHCINM.Trans.MgRotationDetail).%OpenId(id)
	.q:'$IsObject(obj)
	.s sc=obj.%DeleteId(id)
	.i $$$ISOK(sc) d
	..s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("detail",id,depId)) q:(depId="")||(flag=1)  d
	...s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	...q:'$IsObject(depObj)
	...s sc2=depObj.%DeleteId(depId)
	...i '$$$ISOK(sc2) s flag=1
	.e  s flag=1
	 i flag=1
	 {
		 tro
		 q 0
	 }  
	 tc
	 q 1
}

/// Creator:wangcc
/// Description:查询轮转时段
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRotationCycleList","6")
Query FindRotationCycleList(id) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRotationCycleListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s cid=""
	f  s cid=$o(^DHCINM.Trans.MgRotationCycleI("plan"," "_id,cid))  q:cid=""  d
	.s cobj=##class(DHCINM.Trans.MgRotationCycle).%OpenId(cid)
	.q:'$IsObject(cobj)
	.s disabled="false"
	.s stDate=$zd(cobj.StDate,3)
	.s endDate=$zd(cobj.EndDate,3)
	.s flag=$lg(^DHCINM.Trans.MgRotationPlanD(id),5)
	.s:flag="P" disabled="true"
	.s ret="Cycle|"_stDate_"至"_endDate_"^RowID|"_cid_"^PlanStDate|"_stDate_"^PlanEndDate|"_endDate_"^disabled|"_disabled
	.do OutputRotCycleData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotCycleData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRotationCycleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRotationCycleListExecute ]
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

ClassMethod FindRotationCycleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRotationCycleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:保存默认轮转时段
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: w ##class(DHCINM.HR.MgGroupCycle).SaveRotCycle(6)
ClassMethod SaveRotCycle(id)
{
	s flag=1
	s setObj=##class(CT.DHCINM.Set.MgArgParamSet).%OpenId(1)
	q:'$IsObject(setObj)
	q:((setObj.InsertColumn="")||(setObj.RotCycle="")||(setObj.RotStDate="")) 1
	s column=setObj.InsertColumn
	s rotStDate=setObj.RotStDate
	s cycle=setObj.RotCycle
	f i=1:1:column  d
	.s cstdate=rotStDate+(cycle*(i-1))
	.s cenddate=rotStDate+(cycle*i)
	.q:cenddate<=+$h
	.s:cstdate<+$h cstdate=+$h
	.s rotObj=##class(DHCINM.Trans.MgRotationCycle).%New()
	.s rotObj.StDate=cstdate
	.s rotObj.EndDate=cenddate
	.s rotObj.PlanDR=id
	.s sc=rotObj.%Save()
	.s flag=flag&&sc
	q flag
}

/// Creator:wangcc
/// Description:检查轮转时段是否有排班
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle/plan/dep
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod IsRotPerHasArg(plan, cycle)
{
	s ^TMP("IsRotPerHasArg")=plan_"##"_cycle
	s ret=""
	s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("plan",plan,cycle,depId))  q:depId=""  d
	.s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	.q:'$IsObject(depObj)
	.s ward=depObj.Ward
	.s perDr=depObj.DetailDR.RotationPerDR
	.s stDate=depObj.CycleDR.StDate
	.s endDate=depObj.CycleDR.EndDate
	.s date=stDate-1 f  s date=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",ward,perDr,date))  q:(date="")||(date>endDate)  d
	..s rw="" f  s rw=$o(^DHCINM.Arg.MgArrangeSubI("WardPerDate",ward,perDr,date,rw))  q:(rw="")  d
	...s argsub=##class(DHCINM.Arg.MgArrangeSub).%OpenId(rw)
	...q:'$IsObject(argsub)
	...s:ret'[argsub.ArgPerDR.PerName ret=ret_";"_argsub.ArgPerDR.PerName
	s:ret'="" ret=$e(ret,2,*)
	q ret
}

/// Creator:wangcc
/// Description:删除轮转时段
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod DeleteRotationCycle(id)
{
	s obj=##class(DHCINM.Trans.MgRotationCycle).%OpenId(id)
	q:'$IsObject(obj)	
	s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("plan"," "_obj.PlanDR,id,depId)) q:depId=""  d
	.d ##class(DHCINM.Trans.MgRotationDep).%DeleteId(depId)
	s sc=obj.%DeleteId(id)
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Creator:wangcc
/// Description:保存轮转时段
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveRotationCycle(parr)
{
	s ^TMP("SaveRotationCycle")=parr
	s sc=1,flag=1
	ts
	f i=1:1:$l(parr,"「") q:flag=0  d
	.s sub=$p(parr,"「",i)
	.s planId=$p(sub,"!",1)
	.s stDate=$zdh($p(sub,"!",2),3)
	.s endDate=$zdh($p(sub,"!",3),3)
	.s cId=$p(sub,"!",4)
	.s cObj=##class(DHCINM.Trans.MgRotationCycle).%New()
	.s:cId'="" cObj=##class(DHCINM.Trans.MgRotationCycle).%OpenId(cId)
	.q:'$IsObject(cObj)
	.s cObj.PlanDR=planId
	.s cObj.StDate=stDate
	.s cObj.EndDate=endDate
	.s sc=cObj.%Save()
	.i '$$$ISOK(sc)  s flag=0
	i flag=0{
		tro
		q 0
	}
	tc
	q 1
}

/// Creator:wangcc
/// Description:轮转人员维护
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRotPerList",24)
Query FindRotPerList(id) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRotPerListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s rotcode=##class(web.INMImportDBData).GetSetCode("在岗状态","轮转")
	s pid=""  f  s pid=$o(^CF.DHCINM.HR.PersonsI("PerInPost"," "_rotcode,pid)) q:pid=""  d
	.q:##class(web.INMHRComm).IsFormalWorkNur(pid,+$h,"")=0
	.s hour=0,rhour=0,ret=""
	.s did=$O(^DHCINM.Trans.MgRotationDetailI("ppid"," "_pid," "_id,""))
	.q:did'=""
	.s hour=+(..GetRotHour(pid))
	.s currentEducaID=$p(##class(web.INMHRComm).GetNurseEdu(pid,+$h),"^",1)
	.s currentEducaDesc=$p(##class(web.INMHRComm).GetNurseEdu(pid,+$h),"^",2)
	.s currentEducaCode=""
	.s:currentEducaID'="" currentEducaCode=$lg($G(^CT.DHCINM.DB.MgSetCodeSubD($P(currentEducaID,"||",1),$P(currentEducaID,"||",2))),2)
	.i currentEducaCode'=""  d
	..s parref=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," "_currentEducaCode,""))
	..q:parref=""
	..s subid=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," "_currentEducaCode,parref,""))
	..s robj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(parref_"||"_subid)
	..q:'$IsObject(robj)
	..s rhour=robj.SubValue*30
	.q:((rhour=0)||((hour'=0)&&(hour>=rhour)))  ;轮转时长总时长已大于等于学历轮转时长（系统参数设置-轮转周期）
	.s ward=$lg(^CF.DHCINM.DB.MgWardD($lg(^CF.DHCINM.HR.PersonsD(pid),10)),4)
	.s ret="PerID|"_$lg(^CF.DHCINM.HR.PersonsD(pid),3)_"^PerName|"_$lg(^CF.DHCINM.HR.PersonsD(pid),2)_"^PerEduca|"_currentEducaDesc_"^PerRotHour|"_hour_"^PerDR|"_pid_"^Ward|"_ward
	.do OutputRotPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRotPerListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRotPerListExecute ]
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

ClassMethod FindRotPerListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRotPerListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:保存轮转护士
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
ClassMethod SaveRotPer(parr)
{
	s ^TMP("SaveRotPer")=parr
	s perid=$p(parr,"!",1)
	s hour=$p(parr,"!",2)
	s planid=$p(parr,"!",3)
	s index=$P(parr,"!",4)
	s dobj=##class(DHCINM.Trans.MgRotationDetail).%New()
	s dobj.PlanDR=planid
	s dobj.RotationHour=hour
	s dobj.RotationPerDR=perid
	s dobj.FieldSort=$o(^DHCINM.Trans.MgRotationDetailI("sort"," "_planid,""),-1)+1
	s sc=dobj.%Save()
	q index
}

/// Creator:wangcc
/// Description:上下移轮转护士
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return: w ##class(web.INMPersonComm).ChangeField(1,"down")
ClassMethod ChangeField(id, type)
{
	i type="up" s flag=-1
	e  s flag=1
	ts
	s dobj=##class(DHCINM.Trans.MgRotationDetail).%OpenId(id)
	q:'$IsObject(dobj)
	q:(type="up")&&(dobj.FieldSort=1) 0
	q:(type="down")&&(dobj.FieldSort=$tr($o(^DHCINM.Trans.MgRotationDetailI("sort"," "_dobj.PlanDR,""),-1)," ","")) 0
	s lastid=$o(^DHCINM.Trans.MgRotationDetailI("sort"," "_dobj.PlanDR,(dobj.FieldSort+flag),""))
	s lastobj=##class(DHCINM.Trans.MgRotationDetail).%OpenId(lastid)
	q:'$IsObject(lastobj) -1
	s lastfield=lastobj.FieldSort
	s lastobj.FieldSort=dobj.FieldSort
	s sc1=lastobj.%Save()
	i '$$$ISOK(sc1){
		tro
		q -1	
	}
	s dobj.FieldSort=lastfield
	s sc=dobj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q -1
	}
	tc
	q 1
}

/// Creator:wangcc
/// Description:查询轮转记录
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRotationDepList","1")
Query FindRotationDepList(plan, detail) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRotationDepListExecute(ByRef qHandle As %Binary, plan, detail) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s depId=""
	s cycleId="" f  s cycleId=$o(^DHCINM.Trans.MgRotationCycleI("plan"," "_plan,cycleId))  q:cycleId=""  d
	.s cycleObj=##class(DHCINM.Trans.MgRotationCycle).%OpenId(cycleId)
	.q:'$IsObject(cycleObj)
	.s cycle=$zd(cycleObj.StDate,3)_"至"_$zd(cycleObj.EndDate,3)
	.s ward="",remark="",status="",disable="false",depId="",flag=0
	.f  s depId=$o(^DHCINM.Trans.MgRotationDepI("detaildr",detail,cycleId,depId)) q:depId=""  d
	..s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	..q:'$isObject(depObj)
	..s flag=1
	..s cycle=$zd(depObj.CycleDR.StDate,3)_"至"_$zd(depObj.CycleDR.EndDate,3)
	..s ward=depObj.Ward
	..s remark=depObj.Remark
	..s status=""
	..i $lg(^DHCINM.Trans.MgRotationPlanD(depObj.PlanDR),5)="P"  d
	...i depObj.Status="" d
	....i depObj.CycleDR.StDate>+$h s status="NR"
	....e  i depObj.CycleDR.EndDate>+$h  s status="YR"
	....e  s status="AR"
	...e  s status=depObj.Status
	...s disable="true"
	..s status=$case(status,"NR":"待轮转","YR":"轮转中","AR":"轮转完成","RE":"离职终止","TE":"调岗终止","DE":"定科终止","OE":"其他情况终止","":"")
	..s ret="RotCycle|"_cycle_"^CycleID|"_cycleId_"^RotWard|"_ward_"^Remark|"_remark_"^RotStatus|"_status_"^RowID|"_depId_"^disable|"_disable
	..do OutputRotPerData
	.i flag=0  d
	..s ret="RotCycle|"_cycle_"^CycleID|"_cycleId_"^RotWard|"_ward_"^Remark|"_remark_"^RotStatus|"_status_"^RowID|"_depId_"^disable|"_disable
	..do OutputRotPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRotationDepListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRotationDepListExecute ]
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

ClassMethod FindRotationDepListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRotationDepListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:轮转科室维护
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupDep
/// Input:
/// Output：
/// Return: w ##class(web.INMPersonComm).SaveRotDep("9!1!!3!2!5")
ClassMethod SaveRotDep(parr)
{
	s ^TMP("SaveRotDep")=parr
	s flag=1,ret=""
	ts
	f i=1:1:$l(parr,"「") q:flag=0  d
	.s item=$p(parr,"「",i)
	.s id=$p(item,"!",1)
	.s ward=$p(item,"!",2)
	.s remark=$p(item,"!",3)
	.s cid=$p(item,"!",4)
	.s pid=$p(item,"!",5)
	.s did=$p(item,"!",6)
	.i ward'="" d
	..s cycleObj=##class(DHCINM.Trans.MgRotationCycle).%OpenId(cid)
	..s detailObj=##class(DHCINM.Trans.MgRotationDetail).%OpenId(did)
	..s nurseid=detailObj.RotationPerDR
	..s stdate=cycleObj.StDate
	..s enddate=cycleObj.EndDate
	..s ret=..IsHasRepeatTransDep(nurseid,stdate,enddate)
	..s:ret'="" flag=0
	..q:flag=0
	..s depObj=##class(DHCINM.Trans.MgRotationDep).%New()
	..s:id'="" depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(id)
	..d depObj.CycleDRSetObjectId(cid)
	..d depObj.DetailDRSetObjectId(did)
	..s depObj.PlanDR=pid
	..s depObj.Remark=remark
	..s depObj.Ward=ward
	..s sc=depObj.%Save()
	..s:'$$$ISOK(sc) flag=0
	.e  d
	..s depid=$o(^DHCINM.Trans.MgRotationDepI("detaildr",did,cid,""))
	..i depid'=""  d
	...s sc=##class(DHCINM.Trans.MgRotationDep).%DeleteId(depid)
	...s:'$$$ISOK(sc) flag=0
	tro:flag=0
	q:ret'="" ret_"和调配或其他轮转存在时段交叉，请修改轮转时段"
	q:flag=0 0
	tc
	q 1
}

/// Creator:wangcc
/// Description:查询科室轮转人数
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindWardRotByDate","2020-06-01!2020-07-01","7")
Query FindWardRotByDate(parr, id) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardRotByDateExecute(ByRef qHandle As %Binary, parr, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s stDate=$zdh($p(parr,"!",1),3)
	s endDate=$zdh($p(parr,"!",2),3)
	s tmp=""
	s planId="" f  s planId=$o(^DHCINM.Trans.MgRotationDepI("planid",planId))  q:planId=""  d
	.q:(id'="")&&($tr(planId," ","")'=id)
	.s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("planid",planId,depId))  q:depId=""  d
	..s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	..q:'$IsObject(depObj)
	..s rotStDate=depObj.CycleDR.StDate
	..s rotendDate=depObj.CycleDR.EndDate
	..q:((stDate'="")&&(rotendDate<=stDate))||((endDate'="")&&(rotStDate>=endDate))
	..s ward=depObj.Ward
	..q:ward=""
	..s tmp(ward)=$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	..i rotStDate<=stDate  d
	...s stMonth=+$p($zd(stDate,3),"-",2)
	..e  d
	...s stMonth=+$p($zd(rotStDate,3),"-",2)
	..i rotendDate<=endDate  d
	...s endMonth=+$p($zd(rotendDate-1,3),"-",2)
	..e  d
	...s endMonth=+$p($zd(endDate,3),"-",2)
	..f i=stMonth:1:endMonth  d
	...s tmp(ward,i)=$g(tmp(ward,i))+1
	s wardid="" f  s wardid=$o(tmp(wardid))  q:wardid=""  d
	.s ret="Ward|"_$g(tmp(wardid))
	.s num="" f  s num=$o(tmp(wardid,num)) q:num=""  d
	..s ret=ret_"^"_num_"月|"_tmp(wardid,num)
	.do OutputRotPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardRotByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardRotByDateExecute ]
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

ClassMethod FindWardRotByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardRotByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:查询科室轮转人数
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRotByName","2020-06-01!2020-07-11","")
Query FindRotByName(parr, id) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRotByNameExecute(ByRef qHandle As %Binary, parr, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp=""
	s planId="" f  s planId=$o(^DHCINM.Trans.MgRotationDepI("planid",planId))  q:planId=""  d
	.q:(id'="")&&($tr(planId," ","")'=id)
	.s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("planid",planId,depId))  q:depId=""  d
	..s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	..q:'$IsObject(depObj)
	..s rotStDate=$zd(depObj.CycleDR.StDate,3)
	..s rotendDate=$zd(depObj.CycleDR.EndDate,3)
	..s perdr=depObj.DetailDR.RotationPerDR
	..s perName=$lg(^CF.DHCINM.HR.PersonsD(perdr),2)
	..q:(parr'="")&&(perName'[parr)
	..q:(depObj.Status="NR")||(depObj.Status="YR")
	..s ward=$lg(^CF.DHCINM.DB.MgWardD(depObj.Ward),4)
	..s ret="Ward|"_ward_"^StDate|"_rotStDate_"^EndDate|"_rotendDate
	..do OutputRotPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRotByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRotByNameExecute ]
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

ClassMethod FindRotByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRotByNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:终止轮转
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// w ##class(web.INMPersonComm).SaveStopData("1!6","","2020-10-26","DE")
ClassMethod SaveStopData(parr, reason, enddate, flag)
{
	s ^TMP("SaveStopData")=parr_"#"_reason_"#"_enddate_"#"_flag
	s detailId=$p(parr,"!",1)
	s cycleId=$p(parr,"!",2)
	s detatilObj=##class(DHCINM.Trans.MgRotationDetail).%OpenId(detailId)
	s:enddate["-" enddate=$zdh(enddate,3)
	q:'$IsObject(detatilObj) 0
	s ret=..IsHasArgInRotation("!"_cycleId_"!"_detatilObj.RotationPerDR)
	q:(ret'=0) ret_"内存在排班"
	ts
	s flag1=1
	s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("detail",detailId,depId)) q:(depId="")||(flag1=0)  d
	.s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	.q:'$IsObject(depObj)
	.q:depObj.CycleDR.EndDate<enddate
	.s depObj.Status=flag
	.s sc1=depObj.%Save()
	.s:'$$$ISOK(sc1) flag1=0
	.q:flag1=0
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(depObj.DetailDR.RotationPerDR)
	.i flag="DE" s perObj.PerInNursePost=##class(web.INMImportDBData).GetSetCode("在岗状态","定科")
	.s sc2=perObj.%Save()
	.s:'$$$ISOK(sc2) flag1=0
	.q:flag1=0
	.if ($o(^DHCINM.Trans.MgRotationHistoryI("dep",depId,""))="") d
	..s hisObj=##class(DHCINM.Trans.MgRotationHistory).%New()
	..s hisObj.Operate=$lg(^CF.DHCINM.DB.MgWardD(depObj.Ward),4)
	..s hisObj.StopDate=depObj.CycleDR.StDate
	..s hisObj.DepDR=depObj
	..s sc3=hisObj.%Save()
	..s:'$$$ISOK(sc3) flag1=0
	.q:flag1=0
	.s hisObj=##class(DHCINM.Trans.MgRotationHistory).%New()
	.s hisObj.Operate=flag
	.s hisObj.Reason=$g(reason)
	.s hisObj.StopDate=enddate
	.s hisObj.DepDR=depObj
	.s sc4=hisObj.%Save()
	.s:'$$$ISOK(sc4) flag1=0
	.q:flag1=0
	.s rotward=""
	.f  s rotward=$o(^CF.DHCINM.Trans.TransDepI("flag"," P"," "_depObj.DetailDR.RotationPerDR,rotward)) q:(rotward="")||(flag1=0)  d
	..s transDep=""
	..f  s transDep=$o(^CF.DHCINM.Trans.TransDepI("flag"," P"," "_depObj.DetailDR.RotationPerDR,rotward,transDep)) q:(transDep="")||(flag1=0)  d
	...s transDepObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(transDep)
	...q:'$IsObject(transDepObj)
	...q:transDepObj.RotDepId=""
	...q:transDepObj.PerTranStDate<enddate
	...s sc5=transDepObj.%DeleteId(transDep)
	...s:'$$$ISOK(sc5) flag1=0
	i flag1=0 tro
	e  tc
	q flag1
}

/// Creator:wangcc
/// Description:查询轮转历史
/// Date:2020-03-15
/// Table:DHCINM.Trans.MgRotationHistory
/// Input:
/// Output：
/// Return:
/// other: w ##class(web.INMPersonComm).GetRotOperate(2)
ClassMethod GetRotOperate(depid)
{
	s ret="",tmp=""
	s hisId="" f  s hisId=$o(^DHCINM.Trans.MgRotationHistoryI("dep",depid,hisId))  q:hisId=""  d
	.s endDate=$lg(^DHCINM.Trans.MgRotationHistoryD(hisId),4)
	.s operate=$lg(^DHCINM.Trans.MgRotationHistoryD(hisId),5)
	.s tmp(hisId,endDate)=$case(operate,"RE":"离职终止","TE":"调岗终止","DE":"定科终止","OE":"其他情况终止","TR":"借调","Back":"撤销终止",:operate)
	s his="" f  s his=$o(tmp(his)) q:his=""  d
	.s date="" f  s date=$o(tmp(his,date)) q:date=""  d
	..s opDate=$zd(date,3)
	..s ret=ret_opDate_"!"_tmp(his,date)_"#"
	s ret=$e(ret,1,*-1)
	q ret
}

/// Creator:wangcc
/// Description:计算轮转时长
/// Date:2020-03-15
/// Table:DHCINM.Trans.MgRotationHistory
/// Input:
/// Output：
/// Return:
/// other: w ##class(web.INMPersonComm).GetRotHour(2)
ClassMethod GetRotHour(perdr)
{
	s ret=0
	s detail="" f  s detail=$o(^DHCINM.Trans.MgRotationDetailI("ssid"," "_perdr,detail)) q:detail=""  d
	.s detailObj=##class(DHCINM.Trans.MgRotationDetail).%OpenId(detail)
	.q:'$IsObject(detailObj)
	.q:$lg(^DHCINM.Trans.MgRotationPlanD(detailObj.PlanDR),5)'="P"
	.s depid="" f  s depid=$o(^DHCINM.Trans.MgRotationDepI("detail",detail,depid)) q:depid=""  d
	..s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depid)
	..q:'$IsObject(depObj)
	..q:depObj.Ward=""
	..;q:depObj.CycleDR.StDate>+$h
	..s ret1=0
	..s hisId="" f  s hisId=$o(^DHCINM.Trans.MgRotationHistoryI("dep",depid,hisId))  q:hisId=""  d
	...s operate=$lg(^DHCINM.Trans.MgRotationHistoryD(hisId),5)
	...q:("TEDEOERE")'[operate
	...s endDate=$lg(^DHCINM.Trans.MgRotationHistoryD(hisId),4)
	...s cycleSt=depObj.CycleDR.StDate
	...s ret1=endDate-cycleSt
	..i ret1=0  s ret=ret+depObj.CycleDR.EndDate-depObj.CycleDR.StDate
   	..e  s ret=ret+ret1
   	q:ret<0 0
   	q ret
}

/// Creator:wangcc
/// Description:撤销终止
/// Date:2020-03-15
/// Table:DHCINM.Trans.MgRotationHistory
/// Input:
/// Output：
/// Return:
/// other: w ##class(web.INMPersonComm).BackStopRot("1!1!2021-01-31")
ClassMethod BackStopRot(parr)
{
	s ^TMP("BackStopRot")=parr
	s detailId=$p(parr,"!",1)
	s cycleId=$p(parr,"!",2)
	s stopDate=$p(parr,"!",3)
	;如果终止日期大于今天，撤销日期=终止日期；否则撤销日期=今天
	s backDate=$zdh(stopDate,3)
	s:backDate<+$h backDate=+$h
	ts
	s depId=$o(^DHCINM.Trans.MgRotationDepI("detaildr",detailId,cycleId,"")) 
	s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	q:'$IsObject(depObj) 0
	;定科撤销为轮转状态
	i (depObj.Status="DE")
	{
		s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(depObj.DetailDR.RotationPerDR)
		s perObj.PerInNursePost=##class(web.INMImportDBData).GetSetCode("在岗状态","轮转")
		s sc1=perObj.%Save()
		i '$$$ISOK(sc1) {
			tro
			q 0
		}
	}
	s sc5=1,ret=0,ret1=""
	s cycle=cycleId-1 f  s cycle=$o(^DHCINM.Trans.MgRotationDepI("detaildr",detailId,cycle)) q:(cycle="")||(ret'=0)||(ret1'="")  d
	.s cycleObj=##class(DHCINM.Trans.MgRotationCycle).%OpenId(cycle)
	.q:'$IsObject(cycleObj)
	.s stdate=cycleObj.StDate
	.s enddate=cycleObj.EndDate
	.q:enddate<backDate
	.;如果撤销后的轮转时段和弹性调配时段重叠，则此轮转记录不撤销
	.s ret1=(..IsHasRepeatTransDep(depObj.DetailDR.RotationPerDR,stdate,enddate))
	.q:ret1'=""
	.s dep=$o(^DHCINM.Trans.MgRotationDepI("detaildr",detailId,cycle,""))
	.s obj=##class(DHCINM.Trans.MgRotationDep).%OpenId(dep)
	.q:'$IsObject(obj)
	.;检测轮转时段后是否存在排班,
	.s ret=..IsHasArgInRotation(obj.Ward_"!"_cycle_"!"_depObj.DetailDR.RotationPerDR)
	.q:ret'=0
	.;修改终止状态
	.s obj.Status=""
	.s sc5=sc5&&(obj.%Save())
	.;保存撤销终止操作日志
	.s hisObj=##class(DHCINM.Trans.MgRotationHistory).%New()
	.s hisObj.Operate="Back"
	.s hisObj.StopDate=backDate
	.s hisObj.DepDR=obj
	.s sc5=sc5&&(hisObj.%Save())
	.s inward=obj.Ward
	.q:inward=""
	.s currentward=##class(web.INMHRComm).GetCurrentWard(depObj.DetailDR.RotationPerDR,stdate)
	.s input="TransStDate|"_stdate_"^TransEndDate|"_enddate_"^NurseId|"_depObj.DetailDR.RotationPerDR_"^WardId|"_currentward_"^InWard|"_inward
	.s sc5=sc5&&(..SaveTransDep(input,"","",dep,""))
	i (sc5=0)
	{
		tro
		q 0
	}
	i (ret1'="")
	{
		tro
		q ret1_"和调配或其他轮转存在时段交叉，请修改轮转时段"
	}
	i (ret'=0)
	{
		tro
		q ret_"内存在排班"
	}
	tc
	q 1
}

/// Creator:wangcc
/// Description:查询调配护士
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindTransNurseList","StDate|2020-09-01^EndDate|2020-09-30^Person|^InWard|^OutWard|","Random","",0)
Query FindTransNurseList(parr, type, app) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransNurseListExecute(ByRef qHandle As %Binary, parr, type, app) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s transNur="",retTmp=""
	f  s transNur=$o(^DHCINM.Trans.MgTransNurseI("type"," "_$zcvt(type,"U")," "_app,transNur))  q:transNur=""  d
	.s transNurObj=##class(DHCINM.Trans.MgTransNurse).%OpenId(transNur)
	.q:'$IsObject(transNurObj)
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(transNurObj.NurseId)
	.q:'$IsObject(perObj)
	.s TransNurName=perObj.PerName
	.s PerID=perObj.PerID
	.s shellName=##class(web.INMVueComm).ToChineseSpell(TransNurName)
	.s personSelectInfo=$zcvt(PerID_TransNurName_shellName,"U")
	.q:($g(tmp("Person"))'="")&&(personSelectInfo'[($zcvt($g(tmp("Person")),"U")))
	.s TransNurId=transNurObj.NurseId
	.s NurType=##class(web.INMPersonComm).GetCommCode(perObj.PerInNursePost)
	.s NurLevel=$p(##class(web.INMHRComm).GetNurseLevel(transNurObj.NurseId,+$h),"^",2)
	.s NurWard=$lg(^CF.DHCINM.DB.MgWardD(transNurObj.OutWard),4)
	.s InWardDesc=$lg(^CF.DHCINM.DB.MgWardD(transNurObj.InWard),4)
	.q:($g(tmp("OutWard"))'="")&&($g(tmp("OutWard"))'=transNurObj.OutWard)
	.q:($g(tmp("InWard"))'="")&&($g(tmp("InWard"))'=transNurObj.InWard)
	.s transstdate=transNurObj.TransStDate
	.s transenddate=transNurObj.TransEndDate
	.s TransStDate=$zd(transstdate,3)
	.s TransEndDate=""
	.s:transNurObj.TransEndDate'="" TransEndDate=$zd(transenddate,3)
	.s enddate=""
	.s:$g(tmp("EndDate"))'="" enddate=$zdh(tmp("EndDate"),3)
	.s stdate=""
	.s:$g(tmp("StDate"))'="" stdate=$zdh(tmp("StDate"),3)
	.q:((stdate'="")&&(transenddate'="")&&(stdate>transenddate))
	.q:((enddate'="")&&(transstdate'="")&&(enddate<transstdate))
	.s TransDays=transNurObj.TransDays
	.s CreateUser="管理员"
	.i transNurObj.ActionPer'=0 d
	..s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(transNurObj.ActionPer)
	..i $IsObject(userObj) d
	...s CreateUser=userObj.UserName
	.s CreateDate=$zd(transNurObj.CreateDate,3)
	.s status=$case(transNurObj.NurseStatus,"N":"已保存","Y":"已提交")
	.s ret="TransNurName|"_TransNurName_"("_PerID_")"_"^NurType|"_NurType_"^NurLevel|"_NurLevel_"^NurWard|"_NurWard_"^TransStDate|"_TransStDate
	.s ret=ret_"^TransEndDate|"_TransEndDate_"^TransDays|"_TransDays_"^TransNurId|"_TransNurId_"^TransNur|"_transNur_"^WardId|"_transNurObj.OutWard
	.s ret=ret_"^InWard|"_InWardDesc_"^InWardId|"_transNurObj.InWard_"^TransReason|"_transNurObj.TransReason_"^CreateUser|"_CreateUser
	.s ret=ret_"^CreateDate|"_CreateDate_"^CreateUserId|"_transNurObj.ActionPer_"^Status|"_status
	.s:transstdate="" transstdate="#"
	.s retTmp(transstdate,transNur)=ret
	s transstdate="" f  s transstdate=$O(retTmp(transstdate),-1) q:transstdate=""  d
	.s transNur="" f  s transNur=$O(retTmp(transstdate,transNur)) q:transNur=""  d
	..s ret=$g(retTmp(transstdate,transNur))
	..d OutputRotPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransNurseListExecute ]
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

ClassMethod FindTransNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RejectApp(app, id, reason)
{
	q:(app="")||(id="") 0
	ts
	s appObj=##class(DHCINM.Trans.MgTransApp).%OpenId(app)
	q:'$IsObject(appObj)
	s appObj.TransStatus="B"
	s sc=appObj.%Save()
	i '$$$ISOK(sc){
		tro
		q 0
	}
	s checkObj=##class(DHCINM.Trans.MgTransCheck).%New()
	s checkObj.ActionId=id
	s checkObj.AppId=app
	s checkObj.Date=+$h
	s checkObj.Status="B"
	s checkObj.Suggestion=reason
	s checkObj.Time=$p($h,",",2)
	s checkObj.IsCheck="Y"
	s sc1=checkObj.%Save()
	i '$$$ISOK(sc1){
		tro
		q 0
	}
	tc
	q 1
}

/// creater:wangcc
/// date:2020-07-22
/// desc:保存或提交调配审核信息
/// w ##class(web.INMPersonComm).SaveTransNurse("「^NurseId|3^WardId|2^TransStDate|2021-01-27^TransEndDate|^InWard|3^TransDays|^TransType|Random^TransNur|^TransReason|","N","",0)
ClassMethod SaveTransNurse(parr, flag, app, nurseid)
{
	s ^TMP("SaveTransNurse")=parr_"#"_flag_"#"_app_"#"_nurseid
	s isHasArg=..IsHasArg(parr)
	q:isHasArg'=0 isHasArg_"存在调配开始日期之后的排班"
	s isWorkable=..TransDateIsWorkable(parr)
	q:isWorkable'="" isWorkable_"和调配或其他轮转存在时段交叉"
	ts
	i app'=""  d
	.s transnurse="" f  s transnurse=$o(^DHCINM.Trans.MgTransNurseI("app"," "_app,transnurse))  q:transnurse=""  d
	..d ##class(DHCINM.Trans.MgTransNurse).%DeleteId(transnurse)
	s tmp1=""
	d ##class(web.INMVueComm).SplitStr($p(parr,"「",1),"^","|",.tmp1)
	s flag1=0
	if (flag="Y")&&(app'="")
	{
		s appObj=##class(DHCINM.Trans.MgTransApp).%OpenId(app)
		q:'$IsObject(appObj)
		s appObj.TransStatus=tmp1("Status")
		s sc=appObj.%Save()
		i '$$$ISOK(sc){
			tro
			q 0	
		}
		s checkId=$o(^DHCINM.Trans.MgTransCheckI("app"," "_app," "_tmp1("Status"),""))
		i checkId=""  s checkObj=##class(DHCINM.Trans.MgTransCheck).%New()
		e  s checkObj=##class(DHCINM.Trans.MgTransCheck).%OpenId(checkId)
		s checkObj.ActionId=nurseid
		s checkObj.AppId=app
		s checkObj.Date=+$h
		s checkObj.Time=$p($h,",",2)
		s checkObj.Status=tmp1("Status")
		s checkObj.Suggestion=tmp1("CheckSuggestion")
		s checkObj.IsCheck=flag
		s sc1=checkObj.%Save()
		if '$$$ISOK(sc1){
			tro
			q 0
		}
	}
	f i=2:1:$l(parr,"「") q:flag1=-1  d
	.k tmp
	.s tmp=""
	.d ##class(web.INMVueComm).SplitStr($p(parr,"「",i),"^","|",.tmp)
	.s detatilId=""
	.f  s detatilId=$o(^DHCINM.Trans.MgRotationDetailI("ssid"," "_tmp("NurseId"),detatilId)) q:(detatilId="")||(flag1=-1)  d
	..q:'$d(^DHCINM.Trans.MgRotationDetailD(detatilId))
	..s planId=$lg(^DHCINM.Trans.MgRotationDetailD(detatilId),2)
	..q:'$d(^DHCINM.Trans.MgRotationPlanD(planId))
	..s planStatus=$lg(^DHCINM.Trans.MgRotationPlanD(planId),5)
	..q:planStatus'="P"
	..s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("detail",detatilId,depId)) q:(depId="")||(flag1=-1)  d
	...s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	...q:'$isObject(depObj)
	...q:depObj.Status["E"
	...q:(depObj.CycleDR.EndDate<$zdh(tmp("TransStDate"),3))
	...q:($g(tmp("TransEndDate"))'="")&&((depObj.CycleDR.StDate>$zdh(tmp("TransEndDate"),3)))
	...s depObj.Status="TR"
	...s depsc=depObj.%Save()
	...s:'$$$ISOK(depsc) flag1=-1
	...q:flag1=-1
	...s rotationHisObj=##class(DHCINM.Trans.MgRotationHistory).%New()
	...s rotationHisObj.DepDR=depObj
	...s rotationHisObj.Operate="TR"
	...s rotationHisObj.StopDate=+$h
	...s rotHisSc=rotationHisObj.%Save()
	...i '$$$ISOK(rotHisSc) s flag1=-1,i=$l(parr,"「")+1
	.q:flag1=-1
	.s:app'="" indep=$lg(^DHCINM.Trans.MgTransAppD(app),4)
	.s:app="" indep=tmp("InWard")
	.s type=##class(web.INMPersonComm).GetCommCode($lg(^CF.DHCINM.HR.PersonsD(tmp("NurseId")),76))
	.s:tmp("TransEndDate")'="" currentward=##class(web.INMHRComm).GetCurrentWard(tmp("NurseId"),$zdh(tmp("TransEndDate"),3))
	.s:tmp("TransEndDate")="" currentward=tmp("WardId")
	.s nurObj=##class(DHCINM.Trans.MgTransNurse).%New()
	.i (tmp("TransNur")'="")&&(app="")  s nurObj=##class(DHCINM.Trans.MgTransNurse).%OpenId(tmp("TransNur"))
	.s nurObj.ActionPer=nurseid
	.s nurObj.AppId=app
	.s nurObj.InWard=indep
	.s nurObj.NurseId=tmp("NurseId")
	.s nurObj.NurseStatus=flag
	.s nurObj.OutWard=currentward
	.s nurObj.TransDays=tmp("TransDays")
	.s nurObj.TransStDate=$zdh(tmp("TransStDate"),3)
	.i (tmp("TransEndDate"))'="" s nurObj.TransEndDate=$zdh(tmp("TransEndDate"),3)
	.e  s nurObj.TransEndDate=""
	.s nurObj.TransReason=$g(tmp("TransReason"))
	.s nurObj.TransType=tmp("TransType")
	.s sc2=nurObj.%Save()
	.s:'$$$ISOK(sc2) flag1=-1
	.q:flag1=-1
	.if ((($g(tmp1("Status"))="A")||($p(parr,"「",1)=""))&&(flag="Y"))  d
	..s sc4=0
	..i type="轮转" d
	...s sc4=..SaveRotationDepInTrans($zdh(tmp("TransStDate"),3),$zdh(tmp("TransEndDate"),3),tmp("NurseId"))
	...s:sc4=0 flag1=-1
	..i flag1'=-1 d
	...s sc3=..SaveTransDep($p(parr,"「",i),nurObj.%Id(),app,"","")
	...s:sc3=0 flag1=-1
	.q:flag1=-1
	i flag1=-1 tro
	q:flag1=-1 0
	tc
	q 1
}

/// creater:wangcc
/// date:2020-07-22
/// desc:检测调配日期是否合法
/// w ##class(web.INMPersonComm).TransDateIsWorkable("「^NurseId|18^WardId|2^TransStDate|2021-04-01^TransEndDate|2021-05-01^InWard|7^TransDays|30^TransType|Random^TransNur|3^TransReason|")
ClassMethod TransDateIsWorkable(parr)
{
	s ^TMP("TransDateIsWorkable")=parr
	s tmp=""
	s desc=""
	f i=2:1:$l(parr,"「") q:desc'=""  d
	.k tmp
	.d ##class(web.INMVueComm).SplitStr($p(parr,"「",i),"^","|",.tmp)
	.s nurse=tmp("NurseId")
	.s stdate="",enddate=""
	.s:$g(tmp("TransStDate"))'="" stdate=$zdh(tmp("TransStDate"),3)
	.s:$g(tmp("TransEndDate"))'="" enddate=$zdh(tmp("TransEndDate"),3)
	.s desc=..IsHasRepeatTransDepNew(nurse,stdate,enddate,"")
	q desc
}

/// Creator:wangcc
/// Description:生成调科记录
/// Date:2020-03-15
/// Table:CF.DHCINM.Trans.TransDep
/// Input: parr:调配人 开始、结束日期 转入病区 转出病区  nurid:调配详情表id   app:计划性调配的申请表id   rotation:是否是轮转生成的调科记录
/// Output：
/// Return:
/// w ##class(web.INMPersonComm).SaveStopData("2!2","","2020-08-14","DE")
ClassMethod SaveTransDep(parr, nurid, app, rotation As %String = "", intern As %String = "")
{
	s ^TMP("SaveTransDep")=parr
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s stdate=tmp("TransStDate")
	s enddate=tmp("TransEndDate")
	s:stdate["-" stdate=$zdh(tmp("TransStDate"),3)
	s:enddate["-" enddate=$zdh(tmp("TransEndDate"),3)
	s nurseid=tmp("NurseId")
	s type=$lg(^CF.DHCINM.HR.PersonsD(tmp("NurseId")),25)
	s transNur=nurid
	s:enddate'="" outdep=##class(web.INMHRComm).GetCurrentWard(tmp("NurseId"),enddate)
	i nurid'="" d
	.s transNurGlo=$g(^DHCINM.Trans.MgTransNurseD(nurid))
	.q:transNurGlo=""
	.s outdep=$lg(transNurGlo,4)
	s:app'="" indep=$lg(^DHCINM.Trans.MgTransAppD(app),4)
	s:app="" indep=tmp("InWard")
	s flag=1
	///调配开始日期小于今天（审核日期）
	i (stdate<=(+$H))
	{
		s transRw=$o(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_nurseid,""))
		i transRw=""
		{
			///某人调科记录不存在 则插入一条新的
			s TransObj=##class(CF.DHCINM.Trans.TransDep).%New()
			s TransObj.PerDr=nurseid
			s TransObj.PerDepart=indep
			s TransObj.PerTranStDate=stdate
			s TransObj.PerTranCurrent="Y"
			s TransObj.TransNur=transNur
			s TransObj.RotDepId=rotation
			s TransObj.InternPlanSub=intern
			s TransSc=TransObj.%Save()
			s flag=flag&&($$$ISOK(TransSc))
			i flag
			{
			s PerObj=##class(CF.DHCINM.HR.Persons).%OpenId(nurseid)
			s PerObj.PerDepDR=indep
			s PerObj.PerDepDate=stdate
			s PerSc=PerObj.%Save()
			s flas=flag&&($$$ISOK(PerSc))
			if 'flag
			{
				q 0
			}
			}
		}
		else
		{
			///将当前的调科记录作废，置结束日期为当前审核记录的调配开始日期
			s TransObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(transRw)
			s TransObj.PerTranEndDate=stdate
			s TransObj.PerTranCurrent="N"
			s TransSc=TransObj.%Save()
			s flag=flag&&($$$ISOK(TransSc))
			i flag
			{
				///生成一条新的有效的（Y状态）的调科记录
				s NewTransObj=##class(CF.DHCINM.Trans.TransDep).%New()
				s NewTransObj.PerDr=nurseid
				s NewTransObj.PerDepart=indep
				s NewTransObj.PerTranStDate=stdate
				s NewTransObj.PerTranCurrent="Y"
				s NewTransObj.TransNur=transNur
				s NewTransObj.RotDepId=rotation
				s NewTransObj.InternPlanSub=intern
				s NewTransSc=NewTransObj.%Save()
				s flag=flag&&($$$ISOK(NewTransSc))
				i flag
				{
					///如果审核记录有结束日期，则新增一条待走任务（P状态）的返科记录
					i (enddate'="")&&(intern="")&&(rotation'="Adj")&&(rotation="") ///实习生不加返科记录
					{
						s BackTransObj=##class(CF.DHCINM.Trans.TransDep).%New()
						s BackTransObj.PerDr=nurseid
						s BackTransObj.PerDepart=outdep
						s BackTransObj.PerTranStDate=enddate
						s BackTransObj.PerTranCurrent="P"
						s BackTransObj.TransNur=transNur
						s BackTransObj.RotDepId=rotation
						s BackTransObj.InternPlanSub=intern
						s BackTransSc=BackTransObj.%Save()
						s flag=flag&&($$$ISOK(BackTransSc))
						i 'flag
						{
							q 0	
						}	
					}
					s PerObj=##class(CF.DHCINM.HR.Persons).%OpenId(nurseid)
					s PerObj.PerDepDR=indep
					s PerObj.PerDepDate=stdate
					s PerSc=PerObj.%Save()
					s flag=flag&&($$$ISOK(PerSc))
					i 'flag
					{
						q 0
					}
				}
			}
		}
	}
	///审核 调配日期在今天之后的记录
	else
	{
		s objNew=##class(CF.DHCINM.Trans.TransDep).%New()
		s objNew.PerDr=nurseid
		s objNew.PerDepart=indep
		s objNew.PerTranStDate=stdate
		s objNew.PerTranCurrent="P"
		s objNew.TransNur=transNur
		s objNew.RotDepId=rotation
		s objNew.InternPlanSub=intern
		s objNewSc=objNew.%Save()
		s flag=flag&&($$$ISOK(objNewSc))
		i flag
		{
			i (enddate'="")&&(intern="")&&(rotation'="Adj")&&(rotation="") ///实习生不加返科记录
			{
				s BackTransObj=##class(CF.DHCINM.Trans.TransDep).%New()
				s BackTransObj.PerDr=nurseid
				s BackTransObj.PerDepart=outdep
				s BackTransObj.PerTranStDate=enddate
				s BackTransObj.PerTranCurrent="P"
				s BackTransObj.TransNur=transNur
				s BackTransObj.RotDepId=rotation
				s BackTransObj.InternPlanSub=intern
				s BackTransSc=BackTransObj.%Save()
				s flag=flag&&($$$ISOK(BackTransSc))
				i 'flag
				{
					q 0	
				}	
			}
		}
	}
	q 1
}

/// Creator:wangcc
/// Description:轮转护士调配后将调配周期内的轮转记录作废
/// Date:2020-08-01
/// Table:DHCINM.Trans.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.INMPersonComm).SaveRotationDepInTrans(,,,)
ClassMethod SaveRotationDepInTrans(stdate, enddate, perdr)
{
	s sc=1
	s end=enddate+1 f  s end=$o(^CF.DHCINM.Trans.TransDepI("pertime"," "_perdr,end),-1) q:(end="")||(end<stdate)  d
	.s transid=$o(^CF.DHCINM.Trans.TransDepI("pertime"," "_perdr,end,""))
	.s transobj=##class(CF.DHCINM.Trans.TransDep).%OpenId(transid)
	.q:'$IsObject(transobj)
	.q:transobj.RotDepId=""
	.s sc=sc&&($$$ISOK(transobj.%DeleteId(transid)))
	q sc
}

/// Creator:wangcc
/// Description:查询调科申请表
/// Date:2017-06-26
/// Table:DHCINM.Trans.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindTransApp","StDate|^EndDate|^Person|^Ward|^Status|",0,0)
Query FindTransApp(parr As %String = "", id As %String = "", roles As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransAppExecute(ByRef qHandle As %Binary, parr As %String = "", id As %String = "", roles As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("transappparr")=parr_"%"_id_"%"_roles
	s ret=""
	s tmp="",tmpWard=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i tmp("StDate")'=""  s stdate=$zdh(tmp("StDate"),3)
	e  s stdate=""
	i tmp("EndDate")'=""  s enddate=$zdh(tmp("EndDate"),3)
	e  s enddate=""
	s SelPerson=$g(tmp("Person"))
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(id,.tmpWard)
	s appId="" f  s appId=$O(^DHCINM.Trans.MgTransAppD(appId)) q:appId=""  d
	.s obj=##class(DHCINM.Trans.MgTransApp).%OpenId(appId)
	.q:'$IsObject(obj)
	.s isExist=1
	.i isAll=1 s isExist=0
	.e  d
	..i ((obj.TransInDep'="")&&($d(tmpWard(obj.TransInDep)))) s isExist=0
	.q:isExist=1
	.s str=##class(web.INMDBComm).GetWard(obj.TransInDep)
	.s TransInDep=$P($P(str,"^",3),"|",2)
	.q:((tmp("Ward")'="")&&(obj.TransInDep'=tmp("Ward")))
	.s status=""
	.i obj.TransStatus="N" s TransStatus="未提交",status="N"
	.e  d
	..s status=obj.TransStatus
	..;s checkId=$o(^DHCINM.Trans.MgTransCheckI("ischeck"," "_appId," Y",""),-1)
	..;s status=$lg(^DHCINM.Trans.MgTransCheckD(checkId),3)
	..i status="Y" s TransStatus="待审核"
	..e  i status="A"  s TransStatus="审核通过"
	..e  i status="HA" s TransStatus="提请护理部审核"
	..e  i status="B" s TransStatus="驳回"
	.q:((tmp("Status")'="")&&(status'=tmp("Status")))
	.q:((stdate'="")&&(stdate>obj.AppDate))
	.q:((enddate'="")&&(enddate<obj.AppDate))
	.i obj.AppDate'="" s CreateDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AppDate)
	.e  s CreateDate=""
	.i obj.CreateUser="0" s CreateUser="管理员"
	.e  d
	..s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.CreateUser)
	..i $IsObject(userObj) d
	...s CreateUser=userObj.UserName
	.s CreateUserShell=##class(web.INMVueComm).ToChineseSpell(CreateUser)
	.q:((SelPerson'="")&&(CreateUser'[SelPerson)&&(CreateUserShell'[$zcvt(SelPerson,"U")))
	.s transNum=obj.TransCount
	.s condition=obj.TransNurCondition
	.s salary=obj.TransNurSalary
	.s remark=obj.Remark
	.s planStDate=$zd(obj.PlanStDate,3)
	.s planEndDate=$zd(obj.PlanEndDate,3)
	.s planDays=obj.PlanDays
	.s ret="AppWard|"_TransInDep_"^TransStatus|"_TransStatus_"^AppDate|"_CreateDate_"^AppNur|"_CreateUser_"^RowID|"_appId_"^AppWardId|"_obj.TransInDep
	.s ret=ret_"^CreateUserPr|"_obj.CreateUser_"^AppDays|"_obj.PlanDays_"^AppCount|"_transNum_"^PlanStDate|"_planStDate_"^PlanEndDate|"_planEndDate_"^PlanDays|"_planDays
	.do OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransAppExecute ]
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

ClassMethod FindTransAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransAppExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.INMPersonComm).GetTransRec(1)
ClassMethod GetTransRec(id As %String) As %String
{
	s ^TMP("GetTransRec")=id
	s ret=""
	s obj=##class(DHCINM.Trans.MgTransApp).%OpenId(id)
	q:'$IsObject(obj)
	s TransInDep=$lg(^CF.DHCINM.DB.MgWardD(obj.TransInDep),4)
	s PlanStDate=$zd(obj.PlanStDate,3)
	s PlanEndDate=$zd(obj.PlanEndDate,3)
	s AppDate=$zd(obj.AppDate,3)
	s CreateUser=""
	s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.CreateUser)
	i $IsObject(userObj) d
	.s CreateUser=userObj.UserName
	s TransReason=obj.TransReason
	s NoCheckStatus="",NoCheckReason="",status=""
	i obj.TransStatus="N" s TransStatus="未提交"
	e  d
	.s checkId=$o(^DHCINM.Trans.MgTransCheckI("ischeck"," "_id," Y",""),-1)
	.s status=$lg(^DHCINM.Trans.MgTransCheckD(checkId),3)
	.s reason=$lg(^DHCINM.Trans.MgTransCheckD(checkId),5)
	.i status="Y"  d
	..s TransStatus="待审核"
	.e  d
	..s NoCheckStatus=status
	..s NoCheckReason=reason
	..i status="A"  s TransStatus="审核通过"
	..e  i status="HA" s TransStatus="提请护理部审核"
	..e  i status="B" s TransStatus="驳回"

	s AppSalary=obj.TransNurSalary
	s AppNurCondition=obj.TransNurCondition
	s AppRemark=obj.Remark
	s PlanDays=obj.PlanDays
	s AppNurCount=obj.TransCount
	s ret="PlanStDate|"_PlanStDate_"^PlanEndDate|"_PlanEndDate_"^AppWard|"_TransInDep_"^AppReason|"_TransReason_"^RowID|"_id
	s ret=ret_"^AppRemark|"_AppRemark_"^PlanDays|"_PlanDays_"^AppNurCount|"_AppNurCount_"^AppNur|"_CreateUser_"^AppDate|"_AppDate_"^AppNurCondition|"_AppNurCondition
	s ret=ret_"^AppSalary|"_AppSalary_"^AppStatus|"_TransStatus_"^NoCheck|"_NoCheckStatus_"^NoCheckReason|"_NoCheckReason
	q ret
}

/// Writter:gzj
/// Date:2019-05-11
/// Description:判断护士是否在此时间后存在排班
/// Input:
/// Output:
/// Return:w ##class(web.INMPersonComm).IsHasArg("「^NurseId|5^WardId|7^TransStDate|2021-01-05^TransEndDate|^InWard|4^TransDays|^TransType|Random^TransNur|^TransReason|")
ClassMethod IsHasArg(parr As %String) As %String
{
	s ^TMP("IsHasArg")=parr
	s len=$l(parr,"「")
	s ret=""
	k tmpRet
	s tmpRet=""
	f i=2:1:len
	{
		s tmp=""
		s aa=##class(web.INMVueComm).SplitStr($p(parr,"「",i),"^","|",.tmp)
		s nurse=tmp("NurseId")
		s TransDate=$zdh(tmp("TransStDate"),3)
		s date=TransDate-1 f  s date=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",nurse,date)) q:date=""  d
		.s rw="" f  s rw=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",nurse,date,rw)) q:rw=""  d
		..s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(rw)
		..q:'$IsObject(obj)
		..q:$d(tmpRet(obj.ArgPerDR.%Id()))
		..s tmpRet(obj.ArgPerDR.%Id())=1
		..i ret="" s ret=obj.ArgPerDR.PerName
		..e  s ret=ret_";"_obj.ArgPerDR.PerName
	}
	i ret="" q 0
	e  q ret
}

/// wangcc
/// Description:查询调科申请审批明细表
/// Date:2017-06-26
/// Table:DHCINM.Trans.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindCheckHistory",3)
Query FindCheckHistory(id As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckHistoryExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s checkId=""
	f  s checkId=$o(^DHCINM.Trans.MgTransCheckI("ischeck"," "_id," Y",checkId),-1) q:checkId=""  d
	.s checkObj=##class(DHCINM.Trans.MgTransCheck).%OpenId(checkId)
	.q:'$IsObject(checkObj)
	.s status=checkObj.Status
	.s do="审核"
	.i status="Y" s Status="待审核",do="申请"
	.e  i status="A"  s Status="审核通过"
	.e  i status="HA" s Status="提请护理部审核"
	.e  i status="B" s Status="驳回"
	.s perName=""
	.b
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(checkObj.ActionId)
	.i $IsObject(userObj) d
	..s perName=userObj.UserName
	.s date=$zd(checkObj.Date,3)
	.s time=$zt(checkObj.Time,1)
	.s reason=checkObj.Suggestion
	.b
	.s ret="status|"_Status_"^pername|"_perName_"^do|"_do_"^date|"_date_"^time|"_time_"^reason|"_reason
	.do OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckHistoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckHistoryExecute ]
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

ClassMethod FindCheckHistoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckHistoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 调科记录是否可以提前返科
ClassMethod IsBack(id)
{
	s flag="1"
	s dep="" 
	f  s dep=$o(^CF.DHCINM.Trans.TransDepI("transnur"," "_id,dep)) q:(dep="")||(flag'="1")  d
	.s depObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(dep)
	.q:'$IsObject(depObj)
	.s stdate=depObj.PerTranStDate 
	.s transNurId=depObj.TransNur
	.if (transNurId'="")  d
	..s currentEnddate=$lg(^DHCINM.Trans.MgTransNurseD(transNurId),8)
	..i stdate'=currentEnddate d
	...s status=depObj.PerTranCurrent
	...i status="N" d
	....s flag="已返科，不能重复返科"
	...i status="P" d
	....s flag="该记录还未执行任务，不可返科"
	q flag
}

/// 提前返科
/// w ##class(web.INMPersonComm).BackDep(7,"2020-07-11")
ClassMethod BackDep(id, date, type, nurseid)
{
	s flag=1
	s backdate=$zdh(date,3)
	s dep=""
	s obj=##class(DHCINM.Trans.MgTransNurse).%OpenId(id)
	s isWorkable=..IsHasRepeatTransDepNew(obj.NurseId,obj.TransStDate,backdate,id)
	q:isWorkable'="" isWorkable_"和调配或其他轮转存在时段交叉"
	ts
	i type'="定科" {
		s flag=..RejectSubmit(id,type)
		s transDay=backdate-obj.TransStDate
		s WardId=##class(web.INMHRComm).GetCurrentWard(obj.NurseId,backdate)
		s parr="「^NurseId|"_obj.NurseId_"^WardId|"_WardId_"^TransStDate|"_$zd(obj.TransStDate,3)_"^InWard|"_obj.InWard_"^TransEndDate|"_$zd(backdate,3)_"^TransDays|"_transDay_"^TransType|Random^TransNur|"_id_"^TransReason|提前返科"
		b ;1
		s flag=flag&&..SaveTransNurse(parr,"Y","",nurseid)
		i flag=1{
			tc
		}else{
			tro
		}
		q flag
	}
	f{
		s dep=$o(^CF.DHCINM.Trans.TransDepI("transnur"," "_id,dep))
		q:(dep="")||(flag=0)
		s depObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(dep)
		q:'$IsObject(depObj)
		s status=depObj.PerTranCurrent
		i ((status="Y")&&(backdate<=(+$h))){            ///如果提前返科的日期早于今天，那就把转入病区为其他科室的记录作废，反之不作废
			s depObj.PerTranEndDate=backdate
			s depObj.PerTranCurrent="N"
			s sc=depObj.%Save()
			i '$$$ISOK(sc){
				tro
				s flag=0
			}
		}
		i status="P"{
			s depObj.PerTranStDate=backdate
			i backdate<=(+$h){							///如果提前返科的日期早于今天，把返科的待 走系统任务的记录置为Y状态，并改人员的当前病区
				s depObj.PerTranCurrent="Y"
				s sc1=depObj.%Save()
				i '$$$ISOK(sc1){
					tro
					s flag=0
				}
				d ##class(web.INMSysTaskComm).ChangePerDepInfo(depObj.PerDr,depObj.PerDepart,backdate)
			}else{										///如果提前返科的日期晚于今天，把表里返科记录的返科日期改为申请的返科日期
				s sc2=depObj.%Save()
				i '$$$ISOK(sc2){
					tro
					s flag=0
				}
			}	
		}
	}
	s nurObj=##class(DHCINM.Trans.MgTransNurse).%OpenId(id)
	s nurObj.TransEndDate=backdate
	s nurObj.TransDays=backdate-nurObj.TransStDate
	s nursc=nurObj.%Save()
	i '$$$ISOK(nursc){
		tro
		s flag=0
	}
	i flag=1{
		tc
	}
	q flag
}

/// Creator:wangcc
/// Description:保存调科申请
/// Date:2017-08-28
/// Table:DHCINM.Trans.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others:w ##class(web.INMPersonComm).SaveTransApp("AppWard|CT中心^AppNur|张小拿^AppDate|^AppStatus|未提交^AppNurCount|3^PlanStDate|^PlanEndDate|^PlanDays|21^AppReason|^AppNurCondition|355^AppSalary|45^AppRemark|55^RowID|1","Y",2)
ClassMethod SaveTransApp(parr As %String, flag, id) As %String
{
	s ^TMP("SaveTransApp")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s nurseInfo=$P($P(parr,"^",4),"|",2)
	s appid=$g(tmp("RowID"))
	q:id="" 0
	s appPer=$lg($g(^CF.DHCINM.DB.MgUserD(id)),5)
	q:appPer="" 0
	s appWard=$lg($g(^CF.DHCINM.HR.PersonsD(appPer)),10)
	q:appWard="" 0
	
	ts
	i appid="" s obj=##class(DHCINM.Trans.MgTransApp).%New()
	e  s obj=##class(DHCINM.Trans.MgTransApp).%OpenId(appid)
	s obj.TransInDep=appWard
	s obj.TransInDep=$o(^CF.DHCINM.DB.MgWardI("Desc"," "_$g(tmp("AppWard")),""))
	s obj.PlanStDate=$zdh($g(tmp("PlanStDate")),3)
	s obj.PlanEndDate=$zdh($g(tmp("PlanEndDate")),3)
	s obj.AppDate=+$H
	s obj.CreateUser=id
	s obj.TransReason=$g(tmp("AppReason"))
	s obj.TransStatus=flag
	s obj.TransNurSalary=$g(tmp("AppSalary"))
	s obj.TransNurCondition=$g(tmp("AppNurCondition"))
	s obj.Remark=$g(tmp("AppRemark"))
	s obj.PlanDays=$g(tmp("PlanDays"))
	s obj.TransCount=$g(tmp("AppNurCount"))
	s sc=obj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q 0
	}
	i flag="Y"{
		s checkObj=##class(DHCINM.Trans.MgTransCheck).%New()
		s checkObj.ActionId=id
		s checkObj.AppId=obj.%Id()
		s checkObj.Date=+$h
		s checkObj.Status=flag
		s checkObj.Time=$p($h,",",2)
		s checkObj.IsCheck="Y"
		s sc1=checkObj.%Save()
		i '$$$ISOK(sc1){
			tro
			q 0
		}
		tc
		q 1
	}
	tc
	q 1
}

/// Creator:lulin
/// Description:删除未提交调配申请表
/// Date:2018-09-17
/// Table:DHCINM.Trans.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod DeletePerTran(parr As %String) As %String
{
	q:parr="" 0
	f i=1:1:$L(parr,"^") d
	.s id=$P(parr,"^",i)
	.s obj=##class(DHCINM.Trans.MgTransApp).%OpenId(id)
	.q:'$IsObject(obj)
	.d obj.%DeleteId(id)
}

/// Creator:lulin
/// Description:批量删除未提交调配申请表
/// Date:2018-09-17
/// Table:DHCINM.Trans.MgTransNur
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod DeleteTransNur(parr As %String) As %String
{
	q:parr="" 0
	f i=1:1:$L(parr,"^") d
	.s id=$P(parr,"^",i)
	.s obj=##class(DHCINM.Trans.MgTransNurse).%OpenId(id)
	.q:'$IsObject(obj)
	.d obj.%DeleteId(id)
}

/// Creator:wangcc
/// Description:查看某个调配护士
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindTransNurseList","1")
ClassMethod GetTransNurItem(id) As %Status
{
	s ret=""
	s transNurObj=##class(DHCINM.Trans.MgTransNurse).%OpenId(id)
	q:'$IsObject(transNurObj)
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(transNurObj.NurseId)
	q:'$IsObject(perObj)
	s TransNurName=perObj.PerName
	s TransNurId=transNurObj.NurseId
	s NurType=##class(web.INMPersonComm).GetCommCode(perObj.PerInNursePost)
	s NurLevel=$p(##class(web.INMHRComm).GetNurseLevel(transNurObj.NurseId,+$h),"^",2)
	s NurWard=$lg(^CF.DHCINM.DB.MgWardD(transNurObj.OutWard),4)
	s InWardDesc=$lg(^CF.DHCINM.DB.MgWardD(transNurObj.InWard),4)
	s TransStDate=$zd(transNurObj.TransStDate,3)
	s TransEndDate=$zd(transNurObj.TransEndDate,3)
	s TransDays=transNurObj.TransDays
	s CreateUser=""
	s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(transNurObj.ActionPer)
	i $IsObject(userObj) d
	.s CreateUser=userObj.UserName
	s CreateDate=$zd(transNurObj.CreateDate,3)
	s status=$case(transNurObj.NurseStatus,"N":"已保存","Y":"已提交")
	s ret="TransNurName|"_TransNurName_"^NurType|"_NurType_"^NurLevel|"_NurLevel_"^NurWard|"_NurWard_"^TransStDate|"_TransStDate
	s ret=ret_"^TransEndDate|"_TransEndDate_"^TransDays|"_TransDays_"^TransNurId|"_TransNurId_"^TransNur|"_id_"^WardId|"_transNurObj.OutWard
	s ret=ret_"^InWard|"_InWardDesc_"^InWardId|"_transNurObj.InWard_"^TransReason|"_transNurObj.TransReason_"^CreateUser|"_CreateUser
	s ret=ret_"^CreateDate|"_CreateDate_"^CreateUserId|"_transNurObj.ActionPer_"^Status|"_status
	q ret
}

/// wangcc
/// Description:查询轮转进程
/// Date:2020-06-26
/// Table:DHCINM.Trans.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRotProcessData","StDate|2021-05-01^EndDate|2021-05-31^Person|^Ward|^Status|^Teacher|^Academic|",0)
Query FindRotProcessData(parr As %String, nurseid) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRotProcessDataExecute(ByRef qHandle As %Binary, parr, nurseid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp="",tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s nurPerDR=0
	s:nurseid'=0 nurPerDR=$lg(^CF.DHCINM.DB.MgUserD(nurseid),5)
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s wardId="" f  s wardId=$o(^DHCINM.Trans.MgRotationDepI("ward",wardId)) q:wardId=""  d
	.q:wardId=" "
	.q:(tmp("Ward")'="")&&($tr(wardId," ","")'=tmp("Ward"))
	.s warddesc=$lg(^CF.DHCINM.DB.MgWardD($tr(wardId," ","")),4)
	.s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("ward",wardId,depId)) q:depId=""  d
	..s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	..q:'$IsObject(depObj)
	..s perId=depObj.DetailDR.RotationPerDR
	..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	..q:'$IsObject(perObj)
	..s rotationPlanLB=$g(^DHCINM.Trans.MgRotationPlanD(depObj.PlanDR))
	..q:rotationPlanLB=""
	..s PlanStatus=$lg(rotationPlanLB,5)
	..q:PlanStatus'="P"
	..s perID=perObj.PerID
	..s perName=perObj.PerName
	..q:(tmp("Person")'="")&&(perName'[tmp("Person"))
	..q:(perId'=nurPerDR)&&((depObj.Teacher'="")&&(depObj.Teacher'=nurPerDR))&&((isAll=0)&&('$d(tmpWard($tr(wardId," ","")))))
	..s currentAcademic=##class(web.INMHRComm).GetNurseEdu(perId,+$h)
	..s academic=$p(currentAcademic,"^",2)
	..q:(tmp("Academic")'="")&&($p(currentAcademic,"^",1)'=tmp("Academic"))
	..s teacher="",disable=1
	..i depObj.Teacher'="" s teacher=$lg(^CF.DHCINM.HR.PersonsD(depObj.Teacher),2)
	..q:(tmp("Teacher")'="")&&(teacher'[tmp("Teacher"))
	..s stdate=depObj.CycleDR.StDate
	..s enddate=depObj.CycleDR.EndDate
	..q:(((tmp("StDate")'="")&&(enddate<$zdh(tmp("StDate"),3)))||((tmp("EndDate")'="")&&(stdate>$zdh(tmp("EndDate"),3))))
	..s status=depObj.Status,statusdesc="",planstdate="",planenddate="",realenddate="",realstdate=""
	..q:(tmp("Status")'="")&&("TEDEOETR"[tmp("Status"))&&(status'=tmp("Status"))
	..q:(tmp("Status")="NR")&&(stdate>+$h)
	..q:(tmp("Status")="YR")&&(enddate<+$h)
	..q:(tmp("Status")="AR")&&(enddate>+$h)
	..i (status'="")&&("RETEDEOETR"[status)  d
	...s statusdesc=$case(status,"RE":"离职终止","TE":"调岗终止","DE":"定科终止","OE":"其他情况终止","TR":"借调","":"")
	...s planstdate=stdate
	...s realstdate=stdate
	...s planenddate=enddate
	...s hisId=$o(^DHCINM.Trans.MgRotationHistoryI("dep",depId,""),-1)
	...s realenddate=$lg(^DHCINM.Trans.MgRotationHistoryD(hisId),4)
	..i status=""  d
	...i (stdate>+$h) s statusdesc="待轮转"
	...e  i (enddate>=+$h)  s statusdesc="轮转中"
	...e  i (enddate<=+$h) s statusdesc="轮转完成"
	...s planstdate=stdate
	...s realstdate=stdate
	...s planenddate=enddate
	...s realenddate=enddate
	..q:(($g(tmp("Status"))'="")&&(statusdesc'=$g(tmp("Status"))))
	..s:planstdate'="" planstdate=$zd(planstdate,3)
	..s:planenddate'="" planenddate=$zd(planenddate,3)
	..s:realstdate'="" realstdate=$zd(realstdate,3)
	..s:realenddate'="" realenddate=$zd(realenddate,3)
	..s planName=$lg(^DHCINM.Trans.MgRotationPlanD(depObj.PlanDR),3)
	..s ret="PerID|"_perID_"^PerName|"_perName_"^Academic|"_academic_"^wardId|"_$tr(wardId," ","")_"^Ward|"_warddesc_"^Teacher|"_depObj.Teacher
	..s ret=ret_"^PlanSt|"_planstdate_"^PlanEnd|"_planenddate_"^RealSt|"_realstdate_"^RealEnd|"_realenddate
	..s ret=ret_"^Status|"_statusdesc_"^RowID|"_depId_"^disabled|"_disable_"^PlanName|"_planName
	..do OutputRotData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRotProcessDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRotProcessDataExecute ]
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

ClassMethod FindRotProcessDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRotProcessDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 保存护士轮转带教老师
/// w ##class(web.INMPersonComm).SaveTeacher(1,8)
ClassMethod SaveTeacher(id, teacher)
{
	q:id="" 0
	s obj=##class(DHCINM.Trans.MgRotationDep).%OpenId(id)
	q:'$IsObject(obj)
	s obj.Teacher=teacher
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// wangcc
/// Description:查询调岗申请表
/// Date:2017-06-26
/// Table:DHCINM.Trans.MgTransPositionApp
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindTransPositionApp","StDate|2021-03-01^EndDate|2021-03-31^Person|^Ward|^Status|",0)
Query FindTransPositionApp(parr As %String = "", id As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransPositionAppExecute(ByRef qHandle As %Binary, parr As %String = "", id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp="",tmpWard=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i tmp("StDate")'=""  s stdate=$zdh(tmp("StDate"),3)
	e  s stdate=""
	i tmp("EndDate")'=""  s enddate=$zdh(tmp("EndDate"),3)
	e  s enddate=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(id,.tmpWard)
	s ward="" f  s ward=$O(^DHCINM.Trans.MgTransPosiI("ward",ward)) q:ward=""  d
	.s realWard=$tr(ward," ","")
	.q:realWard=""
	.q:(isAll=0)&&('$d(tmpWard(realWard)))
	.q:((tmp("Ward")'="")&&($tr(ward," ","")'=tmp("Ward")))
	.s appId="" f  s appId=$O(^DHCINM.Trans.MgTransPosiI("ward",ward,appId)) q:appId=""  d
	..s obj=##class(DHCINM.Trans.MgTransPositionApp).%OpenId(appId)
	..q:'$IsObject(obj)
	..s str=##class(web.INMDBComm).GetWard($tr(ward," ",""))
	..s warddesc=$P($P(str,"^",3),"|",2)
	..s status=obj.AppStatus
	..i status="N" s TransStatus="已保存"
	..e  i status="Y" s TransStatus="已提交"
	..e  i status="HZ"  s TransStatus="护士长审核"
	..e  i status="KH" s TransStatus="科护士长审核"
	..e  i status="B" s TransStatus="驳回"
	..e  s TransStatus="审核通过"
	..q:((tmp("Status")'="")&&(status'=tmp("Status")))
	..q:((stdate'="")&&(obj.AppDate<stdate))||((enddate'="")&&(obj.AppDate>enddate))
	..i obj.AppDate'="" s CreateDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AppDate)
	..e  s CreateDate=""
	..s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.CreateUser)
	..q:'$IsObject(userObj)
	..s CreateUser=userObj.UserName
	..q:((tmp("Person")'="")&&(CreateUser'[tmp("Person")))
	..s leveldesc="",dutydesc="",edudesc=""
	..s level=##class(web.INMHRComm).GetNurseLevel(userObj.PerDR,obj.AppDate)
	..s:level'="" leveldesc=$p(level,"^",2)
	..s duty=##class(web.INMHRComm).GetNurseHireDuty(userObj.PerDR,obj.AppDate)
	..s:duty'="" dutydesc=$p(duty,"^",2)
	..s academic=##class(web.INMHRComm).GetNurseEdu(userObj.PerDR,obj.AppDate)
	..s:academic'="" edudesc=$p(academic,"^",2)
	..s ret="AppWard|"_warddesc_"^TransStatus|"_TransStatus_"^AppDate|"_CreateDate_"^AppNur|"_CreateUser_"^RowID|"_appId
	..s ret=ret_"^AppNurLevel|"_leveldesc_"^AppDuty|"_dutydesc_"^AppNurAcademic|"_edudesc_"^CreateUserPr|"_obj.CreateUser
	..do OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransPositionAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransPositionAppExecute ]
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

ClassMethod FindTransPositionAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransPositionAppExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckTransApp(reason, id, nurseid, flag)
{
	s roles=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	s sc=1,endRotationSc="-1"
	ts
	s appObj=##class(DHCINM.Trans.MgTransPositionApp).%OpenId(id)
	q:'$IsObject(appObj)
	i flag="Y"  d
	.s:roles["6" appObj.AppStatus="HZ"
	.s:roles["5" appObj.AppStatus="KH"
	.i roles["4" d
	..s appObj.AppStatus="A"
	..s perId=$lg(^CF.DHCINM.DB.MgUserD(appObj.CreateUser),5)
	..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	..s perObj.PerStatus=##class(web.INMImportDBData).GetSetCode("在职状态","转岗")
	..s perObj.PerStateDate=+appObj.AppDate
	..s perObj.PerPostName=appObj.AppPosition
	..;轮转护士需要终止轮转计划
	..s inPostState=..GetCommCode(perObj.PerInNursePost)
	..s:inPostState="轮转" endRotationSc=..EndRotationPlan(perId,+appObj.AppDate,"TE")
	..s:(endRotationSc'=-1)&&(endRotationSc'=1) sc=0
	..s sc=sc&&(perObj.%Save())
	e  d
	.s appObj.AppStatus="B"
	.;s perId=$lg(^CF.DHCINM.DB.MgUserD(appObj.CreateUser),5)
	.;s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	.;s perObj.PerStatus="17||1"
	.;s perObj.PerStateDate=""
	.;s perObj.PerPostName=""
	.;s sc=sc&&(perObj.%Save())
	s sc=sc&&(appObj.%Save())
	s hisObj=##class(DHCINM.Trans.MgTransPositionHis).%New()
	s hisObj.OperDate=+$h
	s hisObj.DepDR=appObj
	s hisObj.Perdr=nurseid
	s hisObj.Reason=$g(reason)
	s hisObj.Status=appObj.AppStatus
	s sc=sc&&(hisObj.%Save())
	i '$$$ISOK(sc)
	{
		tro
		q:(flag="Y")&&(endRotationSc=0) "轮转计划终止失败"
		q:(flag="Y")&&(endRotationSc'=-1)&&(endRotationSc'=0)&&(endRotationSc'=1) endRotationSc
		q:flag="Y" "审核失败"
		q:flag="N" "驳回失败"
	}
	tc
	q:flag="Y" "审核成功"
	q:flag="N" "驳回成功"
}

/// w ##class(web.INMPersonComm).SavePositionApp("AppWard|护理部^AppNur|高学琴^AppDate|2020-09-17^AppStatus|^AppNurLevel|^AppNurAge|52^AppReason|123132^AppNurDuty|12||6^AppNurAcade|3||2^AppPosition|^AppWPosition|24||1^RowID|","N",1883)
ClassMethod SavePositionApp(parr, flag, nurseid)
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	q:nurseid="" "申请人不能为空"
	s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(nurseid)
	q:'$IsObject(userObj) "未找到申请人"
	q:userObj.PerDR="" "未找到申请人"
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(userObj.PerDR)
	q:'$IsObject(perObj) "未找到申请人"
	q:perObj.PerDepDR="" "申请人科室为空"
	s exitFlag=0
	s id="" f  s id=$O(^DHCINM.Trans.MgTransPositionAppD(id)) q:id=""  d
	.s creater=$lg($g(^DHCINM.Trans.MgTransPositionAppD(id)),4)
	.q:creater'=nurseid
	.s status=$lg($g(^DHCINM.Trans.MgTransPositionAppD(id)),3)
	.q:status="A"
	.s exitFlag=1
	q:exitFlag=1 "存在未审核通过申请,不可重复申请"
	ts
	s:$g(tmp("RowID"))'="" obj=##class(DHCINM.Trans.MgTransPositionApp).%OpenId(tmp("RowID"))
	s:$g(tmp("RowID"))="" obj=##class(DHCINM.Trans.MgTransPositionApp).%New()
	s obj.AppDate=$zdh($g(tmp("AppDate")),3)
	s obj.AppReason=$g(tmp("AppReason"))
	s obj.AppStatus=flag
	s obj.AppWard=perObj.PerDepDR
	s obj.CreateUser=nurseid
	s obj.AppPosition=$g(tmp("AppWPosition"))
	s sc=obj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q "保存失败"
	}
	i flag="Y"
	{
		s hisObj=##class(DHCINM.Trans.MgTransPositionHis).%New()
		s hisObj.OperDate=+$h
		s hisObj.DepDR=obj
		s hisObj.Perdr=nurseid
		s hisObj.Status=obj.AppStatus
		s sc1=hisObj.%Save()
		i '$$$ISOK(sc1)
		{
			tro
			q "保存记录失败"
		}
	}
	tc
	q 1
}

/// w ##class(web.INMPersonComm).GetTransPosition(1)
ClassMethod GetTransPosition(id)
{
	s obj=##class(DHCINM.Trans.MgTransPositionApp).%OpenId(id)
	q:'$IsObject(obj)
	s warddesc=$lg(^CF.DHCINM.DB.MgWardD(obj.AppWard),4)
	s status=obj.AppStatus
	i status="N" s TransStatus="已保存"
	e  i status="Y" s TransStatus="已提交"
	e  i status="HZ"  s TransStatus="护士长审核"
	e  i status="HL" s TransStatus="护理部审核"
	e  i status="KH" s TransStatus="科护士长审核"
	e  i status="B" s TransStatus="驳回"
	e  s TransStatus="审核通过"
	s CreateDate="",CreateUser=""
	i obj.AppDate'="" s CreateDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AppDate)
	e  s CreateDate=""
	i obj.CreateUser="0" s CreateUser="管理员"
	e  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.CreateUser)
	.i $IsObject(userObj) d
	..s CreateUser=userObj.UserName
	s leveldesc="",dutydesc="",edudesc=""
	s level=##class(web.INMHRComm).GetNurseLevel(userObj.PerDR,obj.AppDate)
	s:level'="" leveldesc=$p(level,"^",2)
	s duty=##class(web.INMHRComm).GetNurseHireDuty(userObj.PerDR,obj.AppDate)
	s:duty'="" dutydesc=$p(duty,"^",2)
	s academic=##class(web.INMHRComm).GetNurseEdu(userObj.PerDR,obj.AppDate)
	s:academic'="" edudesc=$p(academic,"^",2)
	s reason=obj.AppReason
	s currentPosi=$lg(^CF.DHCINM.HR.PersonsD(userObj.PerDR),77)
	s appPosition=obj.AppPosition
	s birthday=$lg(^CF.DHCINM.HR.PersonsD(userObj.PerDR),6)
	s age=##class(web.INMVueComm).CalAge($zd(birthday,3),$zd(+$H,3))
	s PerAge=$p(age,"Y",1)
	s ret="AppWard|"_warddesc_"^AppStatus|"_TransStatus_"^AppDate|"_CreateDate_"^AppNur|"_CreateUser_"^RowID|"_id
	s ret=ret_"^AppNurLevel|"_leveldesc_"^AppNurDuty|"_dutydesc_"^AppNurAcade|"_edudesc_"^AppReason|"_reason_"^AppPosition|"_currentPosi
	s ret=ret_"^AppWPosition|"_appPosition_"^AppNurAge|"_PerAge_"^AppNurID|"_obj.CreateUser
	q ret
}

/// wangcc
/// desc:审批明细
/// Date:2017-06-26
/// Table:DHCINM.Trans.MgTransPositionHis
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindPosiHistory",3)
Query FindPosiHistory(id As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPosiHistoryExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s checkId=""
	f  s checkId=$o(^DHCINM.Trans.MgTransPosiHisI("dep",id,checkId),-1) q:checkId=""  d
	.s checkObj=##class(DHCINM.Trans.MgTransPositionHis).%OpenId(checkId)
	.q:'$IsObject(checkObj)
	.s status=checkObj.Status
	.s do="审核"
	.i status="Y" s Status="已提交",do="申请"
	.e  i status="A"  s Status="审核通过"
	.e  i status="HL" s Status="护理部审核"
	.e  i status="HZ" s Status="护士长审核"
	.e  i status="KH" s Status="科护士长审核"
	.e  i status="B" s Status="驳回",do="驳回"
	.s perName=""
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(checkObj.Perdr)
	.i $IsObject(userObj) d
	..s perName=userObj.UserName
	.s date=$zd(checkObj.OperDate,3)
	.s reason=checkObj.Reason
	.s ret="status|"_Status_"^pername|"_perName_"^do|"_do_"^date|"_date_"^reason|"_reason
	.do OutputPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPosiHistoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPosiHistoryExecute ]
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

ClassMethod FindPosiHistoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPosiHistoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DeletePositionApp(parr)
{
	q:parr="" 0
	f i=1:1:$L(parr,"^") d
	.s id=$P(parr,"^",i)
	.s obj=##class(DHCINM.Trans.MgTransPositionApp).%OpenId(id)
	.q:'$IsObject(obj)
	.d obj.%DeleteId(id)
}

/// Creator:guozj
/// Description:查询奖惩情况信息
/// Date:2017-09-05
/// Table:DHCINM.HR.MgNurReward
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRewardList","10001^2^2017-09-01^2017-09-06")
Query FindNurRewardList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurRewardListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	;s ^TMP("rewardlist")=parr_"%"_role_"%"_nurseid //10001^2^2017-09-01^2017-09-06
	s nurno=$tr($p(parr,"^",1)," ","")
	s nurdep=$p(parr,"^",2)
	s stdate=$p(parr,"^",3)
	s enddate=$p(parr,"^",4)
	s perId=$P(parr,"^",5)
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s date="" f  s date=$O(^DHCINM.HR.MgRewardI("ssid",date),-1) q:date=""  d
	.s nurse="" f  s nurse=$O(^DHCINM.HR.MgRewardI("ssid",date,nurse)) q:nurse=""  d
	..q:((perId'="")&&(perId'=nurse))
	..s rowid="" f  s rowid=$O(^DHCINM.HR.MgRewardI("ssid",date,nurse,rowid)) q:rowid=""  d
	...s obj=##class(DHCINM.HR.MgReward).%OpenId(rowid)
	...q:(isAll=0)&&((obj.RewardWard="")||('$d(tmpWard(obj.RewardWard))))
	...s nurseID=obj.RewardNurse.PerID
	...s nurseName=obj.RewardNurse.PerName
	...s nurseShell=##class(web.INMVueComm).ToChineseSpell(nurseName)
	...q:((nurno'="")&&(nurseID_nurseName_nurseShell'[$zcvt(nurno,"U")))
	...q:((nurdep'="")&&(obj.RewardWard'=nurdep))
	...q:((stdate'="")&&(obj.RewardDate<stdate))
	...q:((enddate'="")&&(obj.RewardDate>enddate))
	...;s WardStr=##class(web.INMDBComm).GetWard(obj.RewardWard)
	...;s rewardWard=$p($p(WardStr,"^",3),"|",2)
	...i obj.RewardWard'="" d
	....s WardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.RewardWard)
	....s rewardWard=WardObj.WardDesc
	...e  s rewardWard=""
	...s rewardContent=obj.RewardContent
	...s rewardResult=obj.RewardResult
	...i obj.RewardLevel'="" s rewardLevel=..GetCommCode(obj.RewardLevel)
	...e  s rewardLevel=""
	...i obj.RewardDate'="" s rewardDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RewardDate)
	...e  s rewardDate=""
	...s ret="^nurseID|"_nurseID_"^nurseName|"_nurseName_"^rewardWard|"_rewardWard_"^rewardContent|"_rewardContent_"^rewardResult|"_rewardResult_"^rewardLevel|"_rewardLevel_"^rewardDate|"_rewardDate_"^rowid|"_rowid
	...do OutputRewardData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRewardData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurRewardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurRewardListExecute ]
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

ClassMethod FindNurRewardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurRewardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:查询奖惩情况记录
/// Date:2017-09-05
/// Table: DHCINM.HR.MgNurReward
/// Input:
/// Output：
/// Return:
ClassMethod GetNurRewardRec(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgReward).%OpenId(id)
	s RewardNurse=obj.RewardNurse.%Id()
	s RewardWard=obj.RewardWard
	s RewardContent=obj.RewardContent
	s RewardUnit=obj.RewardUnit
	s RewardResult=obj.RewardResult
	s RewardLevel=obj.RewardLevel
	i obj.RewardDate'="" s RewardDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RewardDate)
	e  s RewardDate=""
	s RewardTeacher=obj.RewardTeacher
	s Certifier=obj.Certifier
	s RewardMark=obj.RewardMark
	s ret="RewardNurse|"_RewardNurse_"^RewardWard|"_RewardWard_"^RewardContent|"_RewardContent_"^RewardUnit|"_RewardUnit_"^RewardResult|"_RewardResult_"^RewardLevel|"_RewardLevel_"^RewardDate|"_RewardDate_"^RewardTeacher|"_RewardTeacher_"^Certifier|"_Certifier_"^RewardMark|"_RewardMark_"^RowID|"_id
	q ret
}

/// Creator:guozj
/// Description:保存奖惩情况数据
/// Date:2017-09-05
/// Table: DHCINM.HR.MgNurReward
/// Input:
/// Output：
/// Return:
ClassMethod SaveNurReward(parr As %String) As %String
{
	;s ^TMP("rewardparr")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgReward).%New()
	e  s obj=##class(DHCINM.HR.MgReward).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgReward","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p="RewardNurse" d
	...s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..e  d
	...s ptype=^oddCOM("DHCINM.HR.MgReward","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// Creator:liwenzhen
/// Description:获取最高角色的级别
/// Date:2020-08-13
/// Input: 护士档案id
/// Return: 
/// Others: w ##class(web.INMPersonComm).GetMaxRoleLevel("64")
ClassMethod GetMaxRoleLevel(nurseId As %String) As %String
{
	q:nurseId=0 0
	s maxRoleId=##class(web.INMLoginComm).GetTopRoleByLoginId(nurseId)
	s roleObj=##class(CT.DHCINM.Set.MgRoles).%OpenId($P(maxRoleId,"^",1))
	q:'$IsObject(roleObj) 0
	s maxLevel=roleObj.RoleLevel
	q maxLevel
}

/// Creator:liwenzhen
/// Description:判断是否符合条件
/// Date:2020-08-13
/// Input: searchValue：搜索条件 realValue：实际值
/// Return: 1：不符合 0：符合
/// Others: w ##class(web.INMPersonComm).GetPersonFlag()
ClassMethod GetPersonFlag(searchValue As %String, realValue As %String) As %String
{
	q (searchValue'="")&&((","_searchValue_",")'[(","_realValue_","))
}

/// Creator:wangcc
/// Description:判断是否在日期范围内
/// Date:2020-08-13
/// Input: searchValue：搜索条件 realValue：实际值
/// Return: 1：不符合 0：符合
/// Others: w ##class(web.INMPersonComm).GetPersonFlag()
ClassMethod GetDateRangeFlag(searchValue As %String, realValue As %String) As %String
{
	q (searchValue'="")&&((realValue>$zdh($p(searchValue,",",2),3))||(realValue<$zdh($p(searchValue,",",1),3)))
}

/// Creator:gyg
/// Description:根据人员工号取信息
/// Date:2019-09-9
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:w ##class(web.INMPersonComm).GetNurseMessage("SS04")
ClassMethod GetNurseMessage(nurseno) As %String
{
	s flags=-1
	s rowid=$O(^CF.DHCINM.HR.PersonsI("PerID"," "_$zcvt(nurseno,"U"),""))
	i rowid'="" d
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowid)
	if ('$IsObject(obj)){
			q "^flags|"_flags
		}
	i $d(^DHCINM.HR.MgNurseResignI("ssid",rowid)) q "^flags|"_"0"
	s nurname=obj.PerName
	s nurward=obj.PerDepDR
	s flags=1
	q "^flags|"_flags_"^id|"_rowid_"^name|"_nurname_"^nurward|"_nurward
}

/// Creator:wangcc
/// Description:调配菜单的人力分布
/// Date:2020-10-19
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindWardNurData","",0)
Query FindWardNurData(ward As %String = "", nurseid) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardNurDataExecute(ByRef qHandle As %Binary, ward As %String = "", nurseid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmpWard=""
	s isAll=0,nowDate=+$H
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s tmpLevel=""
	s Sort="" f  s Sort=$O(^CF.DHCINM.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s RowID="" f  s RowID=$O(^CF.DHCINM.DB.MgWardI("Sort",Sort,RowID)) q:RowID=""  d
	..;过滤没有权限的病区
	..q:(isAll=0)&&('$d(tmpWard(RowID)))
	..s objLB=$g(^CF.DHCINM.DB.MgWardD(RowID))
	..q:objLB=""
	..s WardStDate=$lg(objLB,11)
	..s WardEndDate=$lg(objLB,12)
	..q:((WardStDate'="")&&(WardStDate>nowDate))
	..q:((WardEndDate'="")&&(WardEndDate<nowDate))
	..i $lg(objLB,8)'="" s WardDesc=$lg(objLB,8)
	..e  s WardDesc=$lg(objLB,4)
	..s NurseNum=0 //护士人数
	..s inHospitalPatNum=0 //在院患者人数
	..s NurPat="" //护患比
	..s DangeNum=0,EmergeNum=0 //病危 病重
	..s par="" f  s par=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 护士层级",par)) q:par=""  d
	...s subid="" f  s subid=$o(^CT.DHCINM.DB.MgSetCodeSubD(par,subid)) q:subid=""  d
	....s tmpLevel(par_"__"_subid)=0
	..s Rw="" f  s Rw=$O(^CF.DHCINM.HR.PersonsI("DepID"," "_RowID,Rw)) q:Rw=""  d
	...s PerObjLB=$g(^CF.DHCINM.HR.PersonsD(Rw))
	...q:PerObjLB=""
	...q:$lg(PerObjLB,25)'="N"
	...q:$lg(PerObjLB,42)'=##class(web.INMImportDBData).GetSetCode("在职状态","在职")
	...s level=##class(web.INMHRComm).GetNurseLevel(Rw,+$h)
	...i level'="" d
	....s nurlevel=$tr($p(level,"^",1),"|","_")
	....s tmpLevel(nurlevel)=tmpLevel(nurlevel)+1
	...s NurseNum=NurseNum+1
	..i $lg(objLB,2)'="" d
	...s CtLocId=$lg(objLB,2)
	...s wardID=$o(^PAWARD(0,"WARD_LocationDR",CtLocId,""))
	...q:wardID=""
	...s roomID=0 f  s roomID=$o(^PAADMi("CurrWard",wardID,roomID)) q:roomID=""  d
	....s episodeID=0 f  s episodeID=$o(^PAADMi("CurrWard",wardID,roomID,episodeID)) q:episodeID=""  d
    .....s padmType=$p($g(^PAADM(episodeID)),"^",2) //就诊类型
    .....q:padmType'="I"
    .....s patVisit=$p($g(^PAADM(episodeID)),"^",20) //获取在院状态
    .....q:patVisit'="A" //过滤掉不是在院状态的记录
    .....s inHospitalPatNum=inHospitalPatNum+1
    .....s sickflag=##class(web.INMDBComm).IfOrddailyExist(episodeID,"病危",+$H) //病危
	.....i sickflag="1" s DangeNum=DangeNum+1
	.....s sickflag=##class(web.INMDBComm).IfOrddailyExist(episodeID,"病重",+$H)  //病重
	.....i sickflag="1" s EmergeNum=EmergeNum+1
    ...s waitNum=##class(web.INMSensComm).GetWardWaitNum(wardID) //获取等待区的人数
    ...s inHospitalPatNum=inHospitalPatNum+waitNum
    ..s NurPat=""
    ..s:NurseNum'=0 NurPat="1:"_($fn(inHospitalPatNum/NurseNum,"",2))
    ..s ret="Ward|"_WardDesc_"^PatCount|"_inHospitalPatNum_"^NurCount|"_NurseNum_"^NurPat|"_NurPat_"^Dange|"_DangeNum_"^Emerge|"_EmergeNum
	..s perlevel="" f  s perlevel=$o(tmpLevel(perlevel)) q:perlevel=""  d
	...s ret=ret_"^"_perlevel_"|"_tmpLevel(perlevel)
	..do Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardNurDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardNurDataExecute ]
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

ClassMethod FindWardNurDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardNurDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Writter:wangcc
/// Date:2019-05-11
/// Description:判断轮转护士是否在轮转时段内存在其他病区的排班
/// Input:
/// Output:
/// Return:w ##class(web.INMPersonComm).IsHasArgInRotation("3","29","2")
ClassMethod IsHasArgInRotation(parr) As %String
{
	s ret=""
	s hasargTmp=""
	f i=1:1:$l(parr,"「") d
	.s item=$p(parr,"「",i)
	.s cycle=$p(item,"!",2)
	.s ward=$p(item,"!",1)
	.s nurseid=$p(item,"!",3)
	.s stdate=$lg(^DHCINM.Trans.MgRotationCycleD(cycle),3)
	.s enddate=$lg(^DHCINM.Trans.MgRotationCycleD(cycle),4)
	.s flag=0
	.s date=stdate-1 f  s date=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",nurseid,date)) q:(date="")||(date>enddate)||(flag=1)  d
	..s rw="" f  s rw=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",nurseid,date,rw)) q:rw=""  d
	...s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(rw)
	...q:'$IsObject(obj)
	...q:(ward'="")&&((obj.ArgWardDR.%Id()=ward)||(obj.ArgWardDR.WardDesc=ward))
	...s flag=1
	.s:flag=1 hasargTmp(nurseid)=stdate
	i $d(hasargTmp) d
	.s per="" f  s per=$o(hasargTmp(per))  q:per=""  d
	..s perName=$lg(^CF.DHCINM.HR.PersonsD(per),2)
	..i ret="" s ret=perName
	..e  s ret=ret_","_perName
	q:ret="" 0
	q ret_"在"_$zd(stdate,3)_"~"_$zd(enddate,3)
}

/// desc：由于调科记录表里的字段（RotDepId）存值更改，需要重新获取
/// w ##class(web.INMPersonComm).SaveRotDepId()
ClassMethod SaveRotDepId()
{
	s rotDep=" " f  s rotDep=$o(^CF.DHCINM.Trans.TransDepI("rot",rotDep)) q:rotDep=""  d
	.s id="" f  s id=$o(^CF.DHCINM.Trans.TransDepI("rot",rotDep,id)) q:id=""  d
	..s dep=""
	..s depObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(id)
	..s nurseid=depObj.PerDr
	..s st=depObj.PerTranStDate
	..s detailid="" f  s detailid=$o(^DHCINM.Trans.MgRotationDetailI("ssid"," "_nurseid,detailid)) q:detailid=""  d
	...s detailObj=##class(DHCINM.Trans.MgRotationDetail).%OpenId(detailid)
	...q:$lg(^DHCINM.Trans.MgRotationPlanD(detailObj.PlanDR),5)'="P"
	...s cycle="" f  s cycle=$o(^DHCINM.Trans.MgRotationDepI("detaildr",detailid,cycle)) q:cycle=""  d
	....s stdate=$lg(^DHCINM.Trans.MgRotationCycleD(cycle),3)
	....s enddate=$lg(^DHCINM.Trans.MgRotationCycleD(cycle),4)
	....q:(stdate'=st)&&(enddate'=st)
	....s dep=$o(^DHCINM.Trans.MgRotationDepI("detaildr",detailid,cycle,""))
	..i dep'="" d
	...s depObj.RotDepId=dep
	...d depObj.%Save()
	q 1
}

/// Writter:wangcc
/// Date:2019-05-11
/// Description:判断护士在这个时段内是否有时段交叉的调配记录
/// Input:
/// Output:
/// Return:w ##class(web.INMPersonComm).IsHasRepeatTransDep(18,65760,65776)
ClassMethod IsHasRepeatTransDep(nurseid, stdate, enddate)
{
	s ret=""
	s pername=$lg(^CF.DHCINM.HR.PersonsD(nurseid),2)
	;时段和本人弹性调配时段重叠
	s transNur=" " f  s transNur=$o(^CF.DHCINM.Trans.TransDepI("pernur"," "_nurseid,transNur)) q:(transNur="")||(ret'="")  d
	.s transNurObj=##class(DHCINM.Trans.MgTransNurse).%OpenId($tr(transNur," ",""))
	.q:'$IsObject(transNurObj)
	.i enddate'="" d
	..i transNurObj.TransEndDate'="" d
	...s:((transNurObj.TransStDate<=stdate)&&(transNurObj.TransEndDate>stdate))||((transNurObj.TransStDate<=enddate)&&(transNurObj.TransEndDate>=enddate)) ret=pername
	..e  d
	...s:((transNurObj.TransStDate<=enddate)&&(transNurObj.TransStDate>=stdate)) ret=pername
	.e  d
	..i transNurObj.TransEndDate'="" d
	...s:((transNurObj.TransStDate<=stdate)&&(transNurObj.TransEndDate>stdate)) ret=pername	
	;时段和本人其他生效轮转的时段重叠
	s rot=" " f  s rot=$o(^CF.DHCINM.Trans.TransDepI("perrot"," "_nurseid,rot)) q:(rot="")||(ret'="")  d
	.s stRotDep=$o(^CF.DHCINM.Trans.TransDepI("perrot"," "_nurseid,rot,""))
	.s endRotDep=$o(^CF.DHCINM.Trans.TransDepI("perrot"," "_nurseid,rot,stRotDep))
	.s rotObj=##class(DHCINM.Trans.MgRotationDep).%OpenId($tr(rot," ",""))
	.q:'$IsObject(rotObj)
	.i endRotDep'="" d
	..i enddate'="" d
	...s:((rotObj.CycleDR.StDate<=stdate)&&(rotObj.CycleDR.EndDate>stdate))||((rotObj.CycleDR.StDate<=enddate)&&(rotObj.CycleDR.EndDate>=enddate)) ret=pername
	..e  d
	...s:((rotObj.CycleDR.StDate<=stdate)&&(rotObj.CycleDR.EndDate>stdate)) ret=pername
	.e  d
	..i enddate'="" d
	...s:((rotObj.CycleDR.StDate<=enddate)&&(rotObj.CycleDR.StDate>=stdate)) ret=pername
	q:ret'="" ret_"在"_$zd(stdate,3)_"~"_$zd(enddate,3)
	q ret
}

/// Writter:wangcc
/// Date:2019-05-11
/// Description:判断护士在这个时段内是否有时段交叉的调配记录
/// Input:
/// Output:
/// Return:w ##class(web.INMPersonComm).IsHasRepeatTransDep(18,65760,65776)
ClassMethod IsHasRepeatTransDepNew(nurseid, stdate, enddate, transNurID As %String = "")
{
	s ret=""
	s pername=$lg(^CF.DHCINM.HR.PersonsD(nurseid),2)
	;时段和本人弹性调配时段重叠
	s transNur=" " f  s transNur=$o(^CF.DHCINM.Trans.TransDepI("pernur"," "_nurseid,transNur)) q:(transNur="")||(ret'="")  d
	.q:((transNurID'="")&&(transNurID=$tr(transNur," ","")))
	.s transNurObj=##class(DHCINM.Trans.MgTransNurse).%OpenId($tr(transNur," ",""))
	.q:'$IsObject(transNurObj)
	.i enddate'="" d
	..i transNurObj.TransEndDate'="" d
	...s:((transNurObj.TransStDate<=stdate)&&(transNurObj.TransEndDate>stdate))||((transNurObj.TransStDate<=enddate)&&(transNurObj.TransEndDate>=enddate)) ret=pername
	..e  d
	...s:((transNurObj.TransStDate<=enddate)&&(transNurObj.TransStDate>=stdate)) ret=pername
	.e  d
	..i transNurObj.TransEndDate'="" d
	...s:((transNurObj.TransStDate<=stdate)&&(transNurObj.TransEndDate>stdate)) ret=pername	
	q:ret'="" ret_"在"_$zd(stdate,3)_"~"_$zd(enddate,3)
	;时段和本人其他生效轮转的时段重叠
	;s ret=pername
	;s rot=" " f s rot=$o(^CF.DHCINM.Trans.TransDepI("perrot"," "_nurseid,rot)) q:(rot="")||(ret'="") d
	s rot=" " f  s rot=$o(^CF.DHCINM.Trans.TransDepI("perrot"," "_nurseid,rot)) q:(rot="")  d
	.s stRotDep=$o(^CF.DHCINM.Trans.TransDepI("perrot"," "_nurseid,rot,""))
	.s endRotDep=$o(^CF.DHCINM.Trans.TransDepI("perrot"," "_nurseid,rot,stRotDep))
	.s rotObj=##class(DHCINM.Trans.MgRotationDep).%OpenId($tr(rot," ",""))
	.q:'$IsObject(rotObj)
	.i endRotDep'="" d
	..i enddate'="" d
	...;s:((rotObj.CycleDR.StDate<=stdate)&&(rotObj.CycleDR.EndDate>stdate))||((rotObj.CycleDR.StDate<=enddate)&&(rotObj.CycleDR.EndDate>=enddate)) ret=pername
	...s:(rotObj.CycleDR.StDate<=stdate)&&(rotObj.CycleDR.EndDate>=enddate) ret=""
	..;e d
	..;.s:((rotObj.CycleDR.StDate<=stdate)&&(rotObj.CycleDR.EndDate>stdate)) ret=pername
	..;.s:(rotObj.CycleDR.StDate<=stdate)&&(rotObj.CycleDR.EndDate>=enddate) ret=""
	.e  d
	..i enddate'="" d
	...;s:((rotObj.CycleDR.StDate<=enddate)&&(rotObj.CycleDR.StDate>=stdate)) ret=pername
	...s:(rotObj.CycleDR.StDate<=stdate)&&(rotObj.CycleDR.EndDate>=enddate) ret=""
	q:ret'="" ret_"在"_$zd(stdate,3)_"~"_$zd(enddate,3)
	q ret
}

/// Creator:wangcc
/// Description:生成护士调配时段内的轮转计划
/// Date:2020-03-15
/// Table: DHCINM.Trans.MgRotationDetail  DHCINM.Trans.MgRotationPlan  DHCINM.Trans.MgRotationCycle DHCINM.Trans.MgRotationDep
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod ResetRepeatRotation(nurseid, stdate, enddate)
{
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s flag=1
	ts
	s plan="" f  s plan=$o(^DHCINM.Trans.MgRotationDetailI("ppid"," "_nurseid,plan)) q:(plan="")  d
	.s planStatus=$lg(^DHCINM.Trans.MgRotationPlanD($tr(plan," ","")),5)
	.q:planStatus'="P"
	.s detailDr=$o(^DHCINM.Trans.MgRotationDetailI("ppid"," "_nurseid,plan,""))
	.s cycle="" f  s cycle=$o(^DHCINM.Trans.MgRotationDepI("detaildr",detailDr,cycle)) q:(cycle="")  d
	..s stDate=$lg(^DHCINM.Trans.MgRotationCycleD(cycle),3)
	..s endDate=$lg(^DHCINM.Trans.MgRotationCycleD(cycle),4)
	..s depId=$o(^DHCINM.Trans.MgRotationDepI("detaildr",detailDr,cycle,""))
	..s inWard=$lg(^DHCINM.Trans.MgRotationDepD(depId),10)
	..s currentWard=##class(web.INMHRComm).GetCurrentWard(nurseid,stDate-1)
	..i (stDate>stdate)&&(stDate<enddate) d
	...s parr="TransStDate|"_stDate_"^TransEndDate|^NurseId|"_nurseid_"^InWard|"_inWard
	...d Reset
	..i (endDate>stdate)&&(endDate<enddate) d
	...;s parr="TransStDate|"_endDate_"^TransEndDate|^NurseId|"_nurseid_"^InWard|"_currentWard
	...s parr=""
	...d Reset
	..i (stDate>stdate)&&(endDate<enddate) d
	...s parr="TransStDate|"_stDate_"^TransEndDate|"_endDate_"^NurseId|"_nurseid_"^InWard|"_inWard
	...d Reset
	tro:flag=0
	tc:flag=1
	q flag
Reset
	s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	s depObj.Status=""
	s flag=flag&&$$$ISOK(depObj.%Save())
	s historyId="" f  s historyId=$o(^DHCINM.Trans.MgRotationHistoryI("dep",depId,historyId)) q:historyId=""  d
	.d ##class(DHCINM.Trans.MgRotationHistory).%DeleteId(historyId)
	s:parr'="" flag=flag&&(..SaveTransDep(parr,"","",depId,""))
	q
}

/// Creator:wangcc
/// Description:检查时段内是否有排班
/// Date:2020-03-15
/// Table:DHCINM.Arg.MgArrangeSub
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod IsHasArgInTimes(nurseid, stdate, enddate)
{
	s ret=""
	s date=stdate-1 f  s date=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",nurseid,date))  q:(date="")||((enddate'="")&&(date>enddate))||(ret'="")  d
	.s rw="" f  s rw=$o(^DHCINM.Arg.MgArrangeSubI("PerDate",nurseid,date,rw))  q:(rw="")||(ret'="")  d
	..s argsub=##class(DHCINM.Arg.MgArrangeSub).%OpenId(rw)
	..q:'$IsObject(argsub)
	..s ret=argsub.ArgPerDR.PerName
	q ret
}

/// Creator:wangcc
/// Description:撤销随机性调配提交
/// Date:2020-03-15
/// Table:DHCINM.Trans.MgTransNurse  CF.DHCINM.Trans.TransDep
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod RejectSubmit(transnur, type)
{
	s warning=""
	s transnurObj=##class(DHCINM.Trans.MgTransNurse).%OpenId(transnur)
	q:'$IsObject(transnurObj) -1
	s nurseid=transnurObj.NurseId
	s stdate=transnurObj.TransStDate
	s enddate=transnurObj.TransEndDate
	s warning=..IsHasArgInTimes(nurseid,stdate,enddate)
	q:warning'="" warning_"在调配开始日期后存在排班，不可撤销"	
	s Ntime=0,Ytime=0
	s depId="" f  s depId=$o(^CF.DHCINM.Trans.TransDepI("pernur"," "_nurseid," "_transnur,depId)) q:depId=""  d
	.s current=$lg(^CF.DHCINM.Trans.TransDepD(depId),8)
	.s:current="N" Ntime=Ntime+1
	.s:current="Y" Ytime=Ytime+1
	;影响后面生成的调科记录(用人申请)的返回科室
	q:((enddate="")&&(Ntime=1))||((enddate'="")&&(Ntime=2)) "该调配记录后存在新的调配记录，不可撤销"
	ts
	;修改调配申请记录transnur状态为已保存
	s transnurObj.NurseStatus="N"
	s sc=transnurObj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q -1
	}
	;如果记录已走任务，将上一条调配记录dep生效
	i (Ytime>0)
	{
		s dep=$o(^CF.DHCINM.Trans.TransDepI("pernur"," "_nurseid," "_transnur,""))
		s lastDep=$o(^CF.DHCINM.Trans.TransDepI("ssdr"," "_nurseid,dep),-1)
		s lastDepObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(lastDep)
		s lastDepObj.PerTranEndDate=""
		s lastDepObj.PerTranCurrent="Y"
		s sc=lastDepObj.%Save()
		i '$$$ISOK(sc)
		{
			tro
			q -1
		}
		;修改当前所在病区
		s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(nurseid)
		s perObj.PerDepDR=lastDepObj.PerDepart
		s perObj.PerDepDate=lastDepObj.PerTranStDate
		s sc=perObj.%Save()
		i '$$$ISOK(sc)
		{
			tro
			q -1
		}
	}
	;删除当前调配记录dep
	s deleteSc=1
	s depDr="" f  s depDr=$o(^CF.DHCINM.Trans.TransDepI("pernur"," "_nurseid," "_transnur,depDr)) q:(depDr="")||(deleteSc'=1)  d
	.s deleteSc=deleteSc&&(##class(CF.DHCINM.Trans.TransDep).%DeleteId(depDr))
	i deleteSc'=1
	{
		tro
		q -1
	}
	s flag=1
	;轮转护士恢复调配时段内的轮转计划
	i type'="定科" d
	.s flag=..ResetRepeatRotation(nurseid,stdate,enddate)
	i flag=0
	{
		tro
		q -1
	}
	tc
	q 1
}

/// Creator:wangcc
/// Createdate:2021-02-23
/// Description:定科操作
/// Input:
/// Output:
/// Other:w ##class(web.INMPersonComm).ConfirmWard(30,"2021-02-26",4)
ClassMethod ConfirmWard(nurseid, date, ward)
{
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(nurseid)
	q:'$IsObject(perObj) "护士不存在！"
	s inPostState=..GetCommCode(perObj.PerInNursePost)
	q:inPostState'="轮转" "非轮转护士不能定科！"
	ts
	s perObj.PerInNursePost=##class(web.INMImportDBData).GetSetCode("在岗状态","定科")
	s sc=perObj.%Save()
	;轮转计划终止操作
	s endRotationSc=..EndRotationPlan(nurseid,date,"DE")
	s:(endRotationSc'=1) sc=0
	s currentWard=##class(web.INMHRComm).GetCurrentWard(nurseid,date)
	s transSc=-1
	;定科调配操作
	s:currentWard'=ward transSc=(..SaveTransNurse("「^NurseId|"_nurseid_"^WardId|"_currentWard_"^TransStDate|"_date_"^InWard|"_ward_"^TransEndDate|^TransDays|^TransType|Random^TransNur|^TransReason|定科调配","Y","",0))
	i 'sc{
		tro
		q:(endRotationSc=0) "轮转计划终止失败！"
		q:(endRotationSc'=0)&&(endRotationSc'=1) endRotationSc
		q:(transSc'=-1)&&(transSc=0) "定科调配失败！"
		q:(transSc'=-1)&&(transSc'=0)&&(transSc'=1) transSc
		q "定科失败！"
	}
	tc
	q 1
}

/// /Creator:wangcc
/// /Date:2021-02-23
/// /Desc:离职RE、定科DE和调岗TE操作终止轮转计划
ClassMethod EndRotationPlan(nurseid, date, type)
{
	s:date["-" date=$zdh(date,3)
	s typeDesc=$case(type,"DE":"定科终止","TE":"调岗终止","RE":"离职终止")
	s ret=1
	s detailId="" f  s detailId=$o(^DHCINM.Trans.MgRotationDetailI("ssid"," "_nurseid,detailId)) q:detailId=""  d
	.s planId=$lg(^DHCINM.Trans.MgRotationDetailD(detailId),2)
	.s planData=$g(^DHCINM.Trans.MgRotationPlanD(planId))
	.q:planData=""
	.s status=$lg(planData,5)
	.q:status="N"
	.s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("detail",detailId,depId)) q:depId=""  d
	..s depData=$g(^DHCINM.Trans.MgRotationDepD(depId))
	..q:depData=""
	..s cycleId=$lg(depData,4)
	..s cycleData=$g(^DHCINM.Trans.MgRotationCycleD(cycleId))
	..q:cycleData=""
	..s stdate=$lg(cycleData,3)
	..s enddate=$lg(cycleData,4)
	..s:(date<=enddate) ret=..SaveStopData(detailId_"!"_cycleId,typeDesc,date,type)
	q ret
}

/// wangcc
/// Description:查询轮转评价记录
/// Date:2020-06-26
/// Table:DHCINM.Trans.MgTransApp
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRotAssessData","StDate|2021-02-01^EndDate|2021-02-28^Person|^Ward|^Status|^Teacher|^Academic|",0)
Query FindRotAssessData(parr As %String, nurseid) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRotAssessDataExecute(ByRef qHandle As %Binary, parr, nurseid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp="",tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s nurPerDR=0
	s:nurseid'=0 nurPerDR=$lg(^CF.DHCINM.DB.MgUserD(nurseid),5)
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s wardId="" f  s wardId=$o(^DHCINM.Trans.MgRotationDepI("ward",wardId)) q:wardId=""  d
	.q:wardId=" "
	.q:(tmp("Ward")'="")&&($tr(wardId," ","")'=tmp("Ward"))
	.s warddesc=$lg(^CF.DHCINM.DB.MgWardD($tr(wardId," ","")),4)
	.s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("ward",wardId,depId)) q:depId=""  d
	..s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	..q:'$IsObject(depObj)
	..s perId=depObj.DetailDR.RotationPerDR
	..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perId)
	..q:'$IsObject(perObj)
	..s perID=perObj.PerID
	..s perName=perObj.PerName
	..q:(tmp("Person")'="")&&(perName'[tmp("Person"))
	..q:(perId'=nurPerDR)&&((depObj.Teacher'="")&&(depObj.Teacher'=nurPerDR))&&((isAll=0)&&('$d(tmpWard($tr(wardId," ","")))))
	..s currentAcademic=##class(web.INMHRComm).GetNurseEdu(perId,+$h)
	..s academic=$p(currentAcademic,"^",2)
	..q:(tmp("Academic")'="")&&($p(currentAcademic,"^",1)'=tmp("Academic"))
	..s teacher=""
	..i depObj.Teacher'="" s teacher=$lg(^CF.DHCINM.HR.PersonsD(depObj.Teacher),2)
	..q:(tmp("Teacher")'="")&&(teacher'[tmp("Teacher"))
	..s stdate=depObj.CycleDR.StDate
	..s enddate=depObj.CycleDR.EndDate
	..s status=depObj.Status,realenddate="",realstdate=""
	..s realstdate=stdate
	..s realenddate=enddate
	..i status["E" d
	...s hisId=$o(^DHCINM.Trans.MgRotationHistoryI("dep",depId,""),-1)
	...s realenddate=$lg(^DHCINM.Trans.MgRotationHistoryD(hisId),4)
	..q:(realenddate>+$h)
	..q:(((tmp("StDate")'="")&&(realenddate<$zdh(tmp("StDate"),3)))||((tmp("EndDate")'="")&&(realstdate>$zdh(tmp("EndDate"),3))))
	..s:realstdate'="" realstdate=$zd(realstdate,3)
	..s:realenddate'="" realenddate=$zd(realenddate,3)
	..s planName=$lg(^DHCINM.Trans.MgRotationPlanD(depObj.PlanDR),3)
	..s parDr="",nAssessDate=$zd(+$h,3),wAssessDate=$zd(+$h,3),nAssess="未评价",wAssess="未评价",nStatus="A",wStatus="A"
	..s nParDr=..GetParIdByTrans("R",depId,"RotNurseAssess")
	..s wParDr=..GetParIdByTrans("R",depId,"WardAssess")
	..i nParDr'=""  d
	...s nStatus=$lg(^DHCINM.Survey.MgFormD(nParDr),12)
	...s nAssessDate=$zd($lg(^DHCINM.Survey.MgFormD(nParDr),3),3)
	...s nAssess=$case(nStatus,"N":"已保存","Y":"已提交")
	..i wParDr'=""  d
	...s wStatus=$lg(^DHCINM.Survey.MgFormD(wParDr),12)
	...s wAssessDate=$zd($lg(^DHCINM.Survey.MgFormD(wParDr),3),3)
	...s wAssess=$case(wStatus,"N":"已保存","Y":"已提交")
	..q:($g(tmp("Status"))'="")&&(nAssess'=$g(tmp("Status")))&&(wAssess'=$g(tmp("Status")))
	..s ret="PerID|"_perID_"^PerDr|"_perId_"^PerName|"_perName_"^Academic|"_academic_"^wardId|"_wardId_"^WardDesc|"_warddesc_"^Teacher|"_teacher_"^RealSt|"_realstdate
	..s ret=ret_"^RealEnd|"_realenddate_"^RowID|"_depId_"^PlanName|"_planName_"^NurseAssess|"_nAssess_"^WardAssess|"_wAssess
	..s ret=ret_"^NParDr|"_nParDr_"^WParDr|"_wParDr_"^NAssessDate|"_nAssessDate_"^WAssessDate|"_wAssessDate_"^TeacherDr|"_depObj.Teacher
	..s ret=ret_"^NStatus|"_nStatus_"^WStatus|"_wStatus_"^RowId|^ValuatorName|^SurveyTitle|^StatusDesc^SurveyDR|^AssessDate|"
	..do OutputRotData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRotAssessDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRotAssessDataExecute ]
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

ClassMethod FindRotAssessDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRotAssessDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:查询审核通过和已提交的(计划性和随机性)调配的护士
/// Date:2020-03-15
/// Table:DHCINM.HR.MgGroupCycle
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindAllTransNurseList","StDate|2021-02-01^EndDate|2021-02-28^Person|^InWard|^OutWard|^TransType|",0)
Query FindAllTransNurseList(parr, nurseid) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllTransNurseListExecute(ByRef qHandle As %Binary, parr, nurseid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp="",tmpWard="",nurPerDR=0
	s:nurseid'=0 nurPerDR=$lg(^CF.DHCINM.DB.MgUserD(nurseid),5)
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s transNur="",retTmp=""
	f  s transNur=$o(^DHCINM.Trans.MgTransNurseD(transNur))  q:transNur=""  d
	.s transNurObj=##class(DHCINM.Trans.MgTransNurse).%OpenId(transNur)
	.q:'$IsObject(transNurObj)
	.q:($g(tmp("TransType"))'="")&&(transNurObj.TransType'=$g(tmp("TransType")))
	.q:transNurObj.NurseStatus'="Y"
	.s transType=$case(transNurObj.TransType,"Plan":"计划性调配","Random":"随机性调配")
	.s TransNurId=transNurObj.NurseId
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(TransNurId)
	.q:'$IsObject(perObj)
	.s TransNurName=perObj.PerName
	.s PerID=perObj.PerID
	.s shellName=##class(web.INMVueComm).ToChineseSpell(TransNurName)
	.s personSelectInfo=$zcvt(PerID_TransNurName_shellName,"U")
	.q:($g(tmp("Person"))'="")&&(personSelectInfo'[($zcvt($g(tmp("Person")),"U")))
	.q:(TransNurId'=nurPerDR)&&((isAll=0)&&('$d(tmpWard($tr(transNurObj.InWard," ","")))))
	.s NurType=##class(web.INMPersonComm).GetCommCode(perObj.PerInNursePost)
	.s NurLevel=$p(##class(web.INMHRComm).GetNurseLevel(transNurObj.NurseId,+$h),"^",2)
	.s OutWardDesc=$lg(^CF.DHCINM.DB.MgWardD(transNurObj.OutWard),4)
	.s InWardDesc=$lg(^CF.DHCINM.DB.MgWardD(transNurObj.InWard),4)
	.q:($g(tmp("OutWard"))'="")&&($g(tmp("OutWard"))'=transNurObj.OutWard)
	.q:($g(tmp("InWard"))'="")&&($g(tmp("InWard"))'=transNurObj.InWard)
	.s transstdate=transNurObj.TransStDate
	.s transenddate=transNurObj.TransEndDate
	.s TransStDate=$zd(transstdate,3)
	.s TransEndDate=""
	.s:transNurObj.TransEndDate'="" TransEndDate=$zd(transenddate,3)
	.s enddate=""
	.s:$g(tmp("EndDate"))'="" enddate=$zdh(tmp("EndDate"),3)
	.s stdate=""
	.s:$g(tmp("StDate"))'="" stdate=$zdh(tmp("StDate"),3)
	.q:((stdate'="")&&(transenddate'="")&&(stdate>transenddate))
	.q:((enddate'="")&&(transstdate'="")&&(enddate<transstdate))
	.s TransDays=transNurObj.TransDays
	.s AssessDate=$zd(+$h,3),StatusDesc="未评价",Status="A"
	.s ParDr=..GetParIdByTrans("T",transNur,"TransFeedBack")
	.i ParDr'=""  d
	..s Status=$lg(^DHCINM.Survey.MgFormD(ParDr),12)
	..s AssessDate=$zd($lg(^DHCINM.Survey.MgFormD(ParDr),3),3)
	..s StatusDesc=$case(Status,"N":"已保存","Y":"已提交")
	.s Reason=""
	.i transNurObj.TransType="Plan" d
	..s appReason=$lg(^DHCINM.Trans.MgTransAppD(transNurObj.AppId),10)
	.e  s Reason=transNurObj.TransReason
	.s ret="TransNurName|"_TransNurName_"^NurType|"_NurType_"^NurLevel|"_NurLevel_"^OutWardDesc|"_OutWardDesc_"^InWardDesc|"_InWardDesc_"^TransStDate|"_TransStDate
	.s ret=ret_"^TransEndDate|"_TransEndDate_"^TransDays|"_TransDays_"^TransNurId|"_TransNurId_"^RowID|"_transNur_"^TransType|"_transType
	.s ret=ret_"^Status|"_Status_"^AssessDate|"_AssessDate_"^StatusDesc|"_StatusDesc_"^Reason|"_Reason_"^ParDr|"_ParDr
	.s:transstdate="" transstdate="#"
	.s retTmp(transstdate,transNur)=ret
	s transstdate="" f  s transstdate=$O(retTmp(transstdate),-1) q:transstdate=""  d
	.s transNur="" f  s transNur=$O(retTmp(transstdate,transNur)) q:transNur=""  d
	..s ret=$g(retTmp(transstdate,transNur))
	..d OutputRotPerData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllTransNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllTransNurseListExecute ]
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

ClassMethod FindAllTransNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllTransNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// /Creator:wangcc
/// /Date:2021-02-23
/// /Desc:通过类型 表ID 评价维度获取问卷填写父表ID
/// /w ##class(web.INMPersonComm).GetParIdByTable("R",3,"WardAssess")
ClassMethod GetParIdByTrans(type, tableID, evaluationType)
{
	s flag=0,ret=""
	s nAssessParamDr=$tr(##class(web.INMSetComm).GetParamSubByCode("EvaluationType",evaluationType,"rw"),"__","||")
	s parId=""  f  s parId=$O(^DHCINM.Survey.MgFormI("evaluateDR"," "_$zcvt(type,"U")," "_tableID,parId)) q:(parId="")||(flag=1)  d
	.s parObj=$g(^DHCINM.Survey.MgFormD(parId))
	.q:parObj="" 
	.s formObj=$g(^CF.DHCINM.DB.SurveyFormD($lg(parObj,6)))
	.q:formObj=""
	.s:($lf($lg(formObj,5),nAssessParamDr)'=0) flag=1,ret=parId
	q ret
}

/// Creator:wangcc
/// Date:2021/2/7
/// Table:DHCINM.HR.MgPartTimeLoc
/// Desc:保存兼职科室
/// Other：w ##class(web.INMPersonComm).SavePartTimeWard("Loc|1^ContactPerson|1^ContactPhone|21313131^RowID|1^StartDate|2021-04-05^StopDate|2021-04-13",0,"Y")
ClassMethod SavePartTimeLoc(parr, nurseid, isStop)
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	q:('$g(tmp("RowID")))&&($o(^DHCINM.HR.MgPartTimeLocI("loc"," "_$g(tmp("Loc")),""))) "不能重复创建兼职科室"
	ts
	i '$g(tmp("RowID")) s obj=##class(DHCINM.HR.MgPartTimeLoc).%New()
	e  s obj=##class(DHCINM.HR.MgPartTimeLoc).%OpenId($g(tmp("RowID")))
	s className="DHCINM.HR.MgPartTimeLoc"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:p="Creator"
	.q:p="CreateDate"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$tr(tmp(p)," ","")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	s obj.Creator=nurseid
	s sc=obj.%Save()
	if ('$$$ISOK(sc))
	{
		tro
		q "保存失败"
	}
	;停用关联的兼职岗位
	i isStop="Y" d
	.s sc=1
	.s postDr="" f  s postDr=$o(^DHCINM.HR.MgPartTimePostD(obj.%Id(),postDr)) q:(postDr="")||(sc=0)  d
	..b
	..s sc=..DeletePTApply(obj.%Id()_"__"_postDr,$g(tmp("StopDate")))
	if ('$$$ISOK(sc))
	{
		tro
		q "保存失败"
	}
	tc
	q "1"
}

/// Creator:wangcc
/// Date:2021/2/7
/// Table:DHCINM.HR.MgPartTimeLoc
/// Desc:获取兼职科室单条记录
/// Other：
ClassMethod GetPartTimeLoc(id)
{
	s obj=##class(DHCINM.HR.MgPartTimeLoc).%OpenId(id)
	q:'$IsObject(obj) ""
	s locId=obj.Loc
	s locDesc=$lg(^CF.DHCINM.DB.MgWardLocD(obj.Loc),3)
	s contactPerdr=obj.ContactPerson
	s contactPerName=$lg($g(^CF.DHCINM.HR.PersonsD(obj.ContactPerson)),2)
	s phone=obj.ContactPhone
	s startDate=$zd(obj.StartDate,3)
	s stopDate=""
	s:obj.StopDate'="" stopDate=$zd(obj.StopDate,3)
	s ret="Loc|"_locId_"^LocDesc|"_locDesc_"^ContactPerson|"_contactPerdr_"^PerName|"_contactPerName_"^ContactPhone|"_phone_"^RowID|"_id
	s ret=ret_"^StartDate|"_startDate_"^StopDate|"_stopDate
	q ret
}

/// Creator:wangcc
/// Date:2021/2/7
/// Table:DHCINM.HR.MgPartTimeLoc
/// Desc:删除兼职科室单条记录
/// Other：
ClassMethod DeletePartTimeLoc(id)
{
	s postId=$o(^DHCINM.HR.MgPartTimeApplyI("Ward"," "_id,""))
	q:postId'="" "存在兼职岗位被认领，删除失败"
	s sc=##class(DHCINM.HR.MgPartTimeLoc).%DeleteId(id)
	i $$$ISOK(sc) q 1
	e  q "保存失败"
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:查询兼职科室
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindPartTimeLocList","N^^^^","",0,2)
Query FindPartTimeLocList(parr As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindPartTimeLocListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s loc=$p(parr,"「",1)
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id="" f  s id=$o(^DHCINM.HR.MgPartTimeLocD(id)) q:id=""  d
	.s obj=$g(^DHCINM.HR.MgPartTimeLocD(id))
	.q:obj=""
	.s PTLoc=$lg(obj,2)
	.s per=$lg(obj,4)
	.; 为了防止兼职表科室id不在科室表时方法报错
	.q:((PTLoc="")&&($g(^CF.DHCINM.DB.MgWardLocD(PTLoc))=""))
	.q:(loc'="")&&(loc'=PTLoc)
	.s ret=..GetPartTimeLoc(id)
	.d OutPartTimeWard
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPartTimeWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:wangcc
/// Date:2021/2/7
/// Table:DHCINM.HR.MgPartTimePost
/// Desc:保存兼职岗位
/// Other：w ##class(web.INMPersonComm).SavePartTimePost("PostCode|输液上午^PostDesc|输液上午^Salary|33^MaxSalary|322^PersonCount|3^StTime|14:00^EndTime|16:30^StartDate|2021-03-08^StopDate|^Cycle|3,4,5,6,7,1,2^Remark|^RowID|",1,0)
ClassMethod SavePartTimePost(parr, parid, nurseid)
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s post=$o(^DHCINM.HR.MgPartTimePostI("Code"," "_tmp("PostCode"),""))
	q:($g(tmp("RowID"))="")&&(post'="") "岗位代码已存在"
	s locObj=##class(DHCINM.HR.MgPartTimeLoc).%OpenId(parid)
	q:'$IsObject(locObj) "兼职科室不存在"
	s stopDate=locObj.StopDate
	q:(stopDate'="")&&(stopDate<=+$h) "兼职科室已停用不可编辑"
	i '$g(tmp("RowID")) s obj=##class(DHCINM.HR.MgPartTimePost).%New()
	e  s obj=##class(DHCINM.HR.MgPartTimePost).%OpenId($tr(tmp("RowID"),"__","||"))
	s className="DHCINM.HR.MgPartTimePost"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:p="Creator"
	.q:p="CreateDate"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$tr(tmp(p)," ","")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	s:tmp("Cycle")="" obj.Cycle="1,2,3,4,5,6,7"
	s obj.Creator=nurseid
	s obj.Parref=locObj
	s sc=obj.%Save()
	q:$$$ISOK(sc) "1"
	q:'$$$ISOK(sc) "保存失败"
}

/// Creator:wangcc
/// Date:2021/2/7
/// Table:DHCINM.HR.MgPartTimePost
/// Desc:获取兼职岗位单条记录
/// Other：
ClassMethod GetPartTimePost(id)
{
	s obj=##class(DHCINM.HR.MgPartTimePost).%OpenId($tr(id,"__","||"))
	q:'$IsObject(obj) ""
	s ret=""
	s className="DHCINM.HR.MgPartTimePost"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:p="Creator"
	.q:p="CreateDate"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.s value=$ZOBJPROPERTY(obj,p)
	.i ((ptype="date")&&(value'="")) d
	..s value=$zd(value,3)
	.i ret="" s ret=p_"|"_value
	.e  s ret=ret_"^"_p_"|"_value
	s cycleDesc=""
	f i=1:1:$l(obj.Cycle,",") d
	.s item="周"_$p(obj.Cycle,",",i)
	.i cycleDesc="" s cycleDesc=item
	.e  s cycleDesc=cycleDesc_","_item
	s ret=ret_"^CycleDesc|"_cycleDesc_"^RowID|"_$tr(id,"||","__")
	s loc=$p(id,"__",1)
	s post=$p(id,"__",2)
	s Id=$o(^DHCINM.HR.MgPartTimeApplyI("date"," "_loc," "_post,""))
	s:Id'="" ret=ret_"^IsClaim|Y"
	s:Id="" ret=ret_"^IsClaim|N"
	q ret
}

/// Creator:wangcc
/// Date:2021/2/7
/// Table:DHCINM.HR.MgPartTimePost
/// Desc:停用兼职岗位认领
/// Other：
ClassMethod DeletePTApply(id, enddate)
{
	s loc=$p(id,"__",1)
	s post=$p(id,"__",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	ts
	s flag=0
	s date=enddate f  s date=$o(^DHCINM.HR.MgPartTimeApplyI("date"," "_loc," "_post,date)) q:date=""  d
	.s app="" f  s app=$o(^DHCINM.HR.MgPartTimeApplyI("date"," "_loc," "_post,date,app)) q:app=""  d
	..s sc=##class(DHCINM.HR.MgPartTimeApply).%DeleteId(app)
	..s:'$$$ISOK(sc) flag=1
	if (flag=1){
		tro
		q 0
	}
	s obj=##class(DHCINM.HR.MgPartTimePost).%OpenId($tr(id,"__","||"))
	i '$IsObject(obj){
		tro
		q 0
	}
	s obj.StopDate=enddate
	s sc=obj.%Save()
	i ('$$$ISOK(sc)){
		tro
		q 0
	}
	tc
	q 1
}

/// Creator:wangcc
/// Date:2021/2/7
/// Table:DHCINM.HR.MgPartTimePost
/// Desc:删除兼职岗位单条记录
/// Other：
ClassMethod DeletePartTimePost(id)
{
	s loc=$p(id,"__",1)
	s post=$p(id,"__",2)
	s Id=$o(^DHCINM.HR.MgPartTimeApplyI("date"," "_loc," "_post,""))
	q:Id'="" "存在兼职岗位被认领，删除失败"
	s sc=##class(DHCINM.HR.MgPartTimePost).%DeleteId($tr(id,"__","||"))
	i $$$ISOK(sc) q 1
	e  q "保存失败"
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:查询兼职岗位
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindPartTimePostList","N^^^^","",0,2)
Query FindPartTimePostList(parr As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindPartTimePostListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s input=$p(parr,"「",1)
	s parid=$p(parr,"「",2)
	s id="" f  s id=$o(^DHCINM.HR.MgPartTimePostD(parid,id)) q:id=""  d
	.s obj=$g(^DHCINM.HR.MgPartTimePostD(parid,id))
	.q:obj=""
	.s code=$lg(obj,2)
	.s desc=$lg(obj,3)
	.q:(input'="")&&(code_desc'[input)
	.s ret=..GetPartTimePost(parid_"||"_id)
	.d OutPartTimePost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPartTimePost
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:wangcc
/// Description:查询兼职护士
/// Date:2020-03-22
/// Table: DHCINM.HR.MgNurSocialWork
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindPartTimeNurseList","",0)
Query FindPartTimeNurseList(parr As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPartTimeNurseListExecute(ByRef qHandle As %Binary, parr As %String, nurseid As %String) As %Status
{
	s ^TMP("FindSocialWorkList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s loc=$p(parr,"^",1)
	s ward=$p(parr,"^",2)
	s name=$p(parr,"^",3)
	s status=$p(parr,"^",4)
	s ret=""
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s setCodeId=##class(web.INMImportDBData).GetSetCode("兼职类型","院内兼职")
	s rw="" f  s rw=$O(^DHCINM.HR.MgNurSocialWorkI("type"," "_setCodeId,rw)) q:rw=""  d
	.s obj=##class(DHCINM.HR.MgNurSocialWork).%OpenId(rw)
	.q:'$IsObject(obj)
	.q:(obj.WorkStatus'="Y")&&(obj.WorkStatus'="A")
	.q:(status'="")&&(status'=obj.WorkStatus)
	.s workUnit=obj.WorkUnit
	.q:(loc'="")&&(workUnit'=loc)
	.s locId=$lg(^DHCINM.HR.MgPartTimeLocD(workUnit),2)
	.s locDesc=$lg(^CF.DHCINM.DB.MgWardLocD(locId),3)
	.s perData=$g(^CF.DHCINM.HR.PersonsD(obj.WorkPerDR))
	.q:perData=""
	.s perName=$lg(perData,2)
	.s perID=$lg(perData,3)
	.s workDate=$lg(perData,14)
	.q:(name'="")&&(perName'[name)
	.s wardId=$lg(perData,10)
	.q:(ward'="")&&(ward'=wardId)
	.q:(ward="")&&(isAll=0)&&('$d(tmpWard(wardId)))
	.s wardData=$g(^CF.DHCINM.DB.MgWardD(wardId))
	.q:wardData=""
	.s wardDesc=$lg(wardData,4)
	.s Status=$case(obj.WorkStatus,"Y":"已提交","A":"已审核")
	.s workYear=+##class(web.INMVueComm).CalAge($zd(workDate,3),$zd(+$H,3))
	.s ret="Status|"_Status_"^LocDesc|"_locDesc_"^WardDesc|"_wardDesc_"^PerName|"_perName_"^PerID|"_perID_"^WorkYear|"_workYear_"^RowID|"_rw
	.do OutputPartTimeNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPartTimeNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPartTimeNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPartTimeNurseListExecute ]
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

ClassMethod FindPartTimeNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPartTimeNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:查询兼职岗位认领详情
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindPartTimeApplyDetail","1","2021-03-22")
Query FindPartTimeApplyDetail(loc As %String, stdate As %String) As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindPartTimeApplyDetailExecute(ByRef qHandle As %Binary, loc As %String, stdate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	if (loc="")||(stdate="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s:stdate["-" stdate=$zdh(stdate,3)
	s post="" f  s post=$o(^DHCINM.HR.MgPartTimePostD(loc,post)) q:post=""  d
	.s ret=""
	.s ptPostObj=$g(^DHCINM.HR.MgPartTimePostD(loc,post))
	.q:ptPostObj=""
	.s allCount=$lg(ptPostObj,6)
	.s postName=$lg(ptPostObj,3)
	.s stTime=$lg(ptPostObj,7)
	.s endTime=$lg(ptPostObj,8)
	.s stDate=$lg(ptPostObj,9)
	.s endDate=$lg(ptPostObj,10)
	.s cycle=$lg(ptPostObj,11)
	.s rowRemark=$o(^DHCINM.HR.MgPartTimeRowI("remark"," "_loc," "_post,stdate,""))
	.f date=stdate:1:(stdate+6) d
	..s count=0,cellDesc="",nameDesc=""
	..i $o(^DHCINM.HR.MgPartTimeApplyI("date"," "_loc," "_post,date,""))'=""  d
	...s id="" f  s id=$o(^DHCINM.HR.MgPartTimeApplyI("date"," "_loc," "_post,date,id)) q:id=""  d
	....s ptAppObj=$g(^DHCINM.HR.MgPartTimeApplyD(id))
	....q:ptAppObj=""
	....s count=count+1
	....s nurseId=$lg(ptAppObj,5)
	....s:nurseId'=0 perName=$lg(^CF.DHCINM.DB.MgUserD(nurseId),2)
	....s:nurseId=0 perName="管理员"
	....s remark=$lg(ptAppObj,7)
	....s isOnPost=$lg(ptAppObj,6)
	....s fontColor=$case(isOnPost,"Y":"#DD001B","N":"#606266")
	....i nameDesc="" d
	.....s:remark="" nameDesc=perName_"~"_fontColor
	.....s:remark'="" nameDesc=perName_"("_remark_")"_"~"_fontColor
	....e  d
	.....s:remark="" nameDesc=nameDesc_"」"_perName_"~"_fontColor
	.....s:remark'="" nameDesc=nameDesc_"」"_perName_"("_remark_")"_"~"_fontColor
	..s cellColor=..GetCellColor(stDate,endDate,date,allCount,count,cycle)
	..s:count=allCount cellDesc="已认领("_count_"/"_allCount_")「"_nameDesc_"「"_cellColor
	..s:((cellColor'="#CFCFB9")&&(count'=allCount)) cellDesc="待认领("_count_"/"_allCount_")「"_nameDesc_"「"_cellColor
	..s:(cellColor="#CFCFB9") cellDesc="「「"_cellColor
	..i ret="" s ret="PTPost|"_postName_"("_stTime_"-"_endTime_")^PostDr|"_$tr(post," ","")_"^Remark|"_rowRemark_"^Date"_$zd(date,3)_"|"_cellDesc
	..e  s ret=ret_"^Date"_$zd(date,3)_"|"_cellDesc
	.d OutPartTimeApply
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPartTimeApply
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:判断是否可申请
/// Input:
/// Output: -1:浅灰 1:深灰  2：绿色  3：白色
/// Other:
ClassMethod GetCellColor(stdate, enddate, date, allCount, applyCount, cycle)
{
	q:(date<stdate)||((enddate'="")&&(date>=enddate)) "#CFCFB9"
	s weekDay=$zd(date,10)
	s:weekDay=0 weekDay=7
	q:(","_cycle_",")'[(","_weekDay_",") "#CFCFB9"
	q:date<=+$h "#C6C6C6"
	q:date>((+$H)+14) "#C5C6C6"
	q:(applyCount=allCount) "#AAE3A2"
	q "#FFFFFF"
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:认领或作废兼职岗位
/// Input:
/// Output: 
/// Other:w ##class(web.INMPersonComm).ClaimPost("Do",1,1,"2021-04-16",0)
ClassMethod ClaimPost(flag, loc, post, date, nurseid)
{
	s:date["-" date=$zdh(date,3)
	s id=$o(^DHCINM.HR.MgPartTimeApplyI("ssid"," "_loc," "_post,date," "_nurseid,""))
	q:(flag="Cancel")&&(id="") "未认领无法作废"
	q:(flag="Cancel")&&((date-(+$H))<=2) "兼职开始时间前48小时内不可作废"
	q:(flag="Do")&&(id'="") "不能重复认领"
	q:(flag="Do")&&(nurseid=0) "超级管理员不可认领"
	q:..CanClaimPost(nurseid,loc,date)=0 "没有兼职科室的权限"
	s postObj=$g(^DHCINM.HR.MgPartTimePostD(loc,post))
	q:postObj="" "岗位不存在"
	s stTime=$lg(postObj,7)
	s endTime=$lg(postObj,8)
	s allCount=$lg(postObj,6)
	q:(flag="Do")&&(..CheckRepeat(loc_"||"_post,stTime,endTime,date,nurseid)=1) "兼职时间有交叉"
	q:(flag="Do")&&(..GetCountByDateAndPost(loc,post,date)=allCount) "名额已满"
	i flag="Cancel" {
		s sc=##class(DHCINM.HR.MgPartTimeApply).%DeleteId(id)
		q:$$$ISOK(sc) "作废成功"
		q:'$$$ISOK(sc) "作废失败"
	}
	else
	{
		s obj=##class(DHCINM.HR.MgPartTimeApply).%New()
		s obj.AppDate=date
		s obj.IsOnPost="N"
		s obj.NurseId=nurseid
		s obj.PostDr=post
		s obj.WardDr=loc
		s sc=obj.%Save()
		q:$$$ISOK(sc) "认领成功"
		q:'$$$ISOK(sc) "认领失败"
	}
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:是否有兼职科室的权限
/// Input:
/// Output: 1 有  0  无 
/// Other:w ##class(web.INMPersonComm).CanClaimPost(6,1,+$h-1)
ClassMethod CanClaimPost(nurseid, loc, date)
{
	s perdr=$lg(^CF.DHCINM.DB.MgUserD(nurseid),5)
	s PTTypeCodeDr=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 兼职类型",""))
	q:PTTypeCodeDr="" 0
	s PTTypeSubCodeDr=$o(^CT.DHCINM.DB.MgSetCodeSubI("Code",PTTypeCodeDr," 院内兼职",""))
	q:PTTypeSubCodeDr="" 0
	s flag=0
	s id="" f  s id=$o(^DHCINM.HR.MgNurSocialWorkI("ssid"," "_perdr,id)) q:((id="")||(flag=1))  d
	.s socialObj=$g(^DHCINM.HR.MgNurSocialWorkD(id))
	.q:socialObj=""
	.s type=$lg(socialObj,9)
	.q:type'=(PTTypeCodeDr_"||"_PTTypeSubCodeDr)
	.s status=$lg(socialObj,8)
	.q:status'="A"
	.s stdate=$lg(socialObj,3)
	.s enddate=$lg(socialObj,4)
	.q:(date<stdate)||((enddate'="")&&(date>=enddate))
	.s part=$lg(socialObj,5)
	.q:part'=loc
	.s:part=loc flag=1
	q flag
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:检测同一天兼职岗位时间有无交叉
/// Input:
/// Output: 1 有  0 无 
/// Other:
ClassMethod CheckRepeat(postId, stTime, endTime, date, nurseid)
{
	s:date["-" date=$zdh(date,3)
	s flag=0
	s id="" f  s id=$o(^DHCINM.HR.MgPartTimeApplyI("perDate"," "_nurseid,date,id)) q:((id="")||(flag=1))  d
	.s appObj=$g(^DHCINM.HR.MgPartTimeApplyD(id))
	.q:appObj=""
	.s loc=$lg(appObj,2)
	.s post=$lg(appObj,3)
	.q:postId=(loc_"||"_appObj)
	.s postObj=$g(^DHCINM.HR.MgPartTimePostD(loc,post))
	.q:postObj=""
	.s sttime=$lg(postObj,7)
	.s endtime=$lg(postObj,8)
	.s:'((stTime>=endtime)||(endTime<sttime)) flag=1
	q flag
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:同一天兼职岗位已认领人数
/// Input:
/// Output:
/// Other:
ClassMethod GetCountByDateAndPost(loc, post, date)
{
	s:date["-" date=$zdh(date,3)
	s count=0
	s id="" f  s id=$o(^DHCINM.HR.MgPartTimeApplyI("date"," "_loc," "_post,date,id)) q:id=""  d
	.s appObj=$g(^DHCINM.HR.MgPartTimeApplyD(id))
	.q:appObj=""
	.s count=count+1
	q count
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:保存兼职岗位周记录的备注
/// Input:
/// Output: 1 有  0  无 
/// Other:
ClassMethod SaveRowRemark(loc, post, date, remark, nurseid)
{
	s:date["-" date=$zdh(date,3)
	s rowRemark=$o(^DHCINM.HR.MgPartTimeRowI("remark"," "_loc," "_post,date,""))
	s rowId=$o(^DHCINM.HR.MgPartTimeRowI("remark"," "_loc," "_post,date," "_rowRemark,""))
	s:rowId="" obj=##class(DHCINM.HR.MgPartTimeRow).%New()
	s:rowId'="" obj=##class(DHCINM.HR.MgPartTimeRow).%OpenId(rowId)
	s obj.Creator=nurseid
	s obj.MonDay=date
	s obj.PostDr=post
	s obj.Remark=remark
	s obj.WardDr=loc
	s sc=obj.%Save()
	q:$$$ISOK(sc) 1
	q:'$$$ISOK(sc) "保存失败"
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:查询某日兼职岗位认领人员列表
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindClaimNurseList","1",1,"2021-03-24")
Query FindClaimNurseList(loc As %String, post As %String, date) As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindClaimNurseListExecute(ByRef qHandle As %Binary, loc As %String, post As %String, date) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s:date["-" date=$zdh(date,3)
	s per="" f  s per=$o(^DHCINM.HR.MgPartTimeApplyI("ssid"," "_loc," "_post,date,per)) q:per=""  d
	.s userObj=$g(^CF.DHCINM.DB.MgUserD($tr(per," ","")))
	.q:userObj=""
	.s id=$o(^DHCINM.HR.MgPartTimeApplyI("ssid"," "_loc," "_post,date,per,""))
	.s perName=$lg(userObj,2)
	.s ret="Id|"_id_"^PerName|"_perName
	.d OutClaimNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutClaimNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:缺勤登记
/// Input:
/// Output:
/// Other:
ClassMethod SaveAbsenceForm(remark, id)
{
	s obj=##class(DHCINM.HR.MgPartTimeApply).%OpenId(id)
	s obj.IsOnPost="Y"
	s obj.Remark=remark
	s sc=obj.%Save()
	q:$$$ISOK(sc) 1
	q:'$$$ISOK(sc) "保存失败"
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:获取缺勤登记备注
/// Input:
/// Output:
/// Other:
ClassMethod GetAbsenceInfor(id)
{
	s obj=##class(DHCINM.HR.MgPartTimeApply).%OpenId(id)
	q obj.Remark_"~"_obj.IsOnPost
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:撤销缺勤登记
/// Input:
/// Output:
/// Other:
ClassMethod DeleteAbsence(id)
{
	s obj=##class(DHCINM.HR.MgPartTimeApply).%OpenId(id)
	q:'$IsObject(obj) "删除失败"
	s obj.IsOnPost="N"
	s obj.Remark=""
	s sc=obj.%Save()
	q:$$$ISOK(sc) 1
	q:'$$$ISOK(sc) "删除失败"
}

/// Creator:wangcc
/// Createdate:2020-07-16
/// Description:查询兼职岗位统计信息
/// Input:
/// Output:
/// Other:
/// Test:w ##class(web.INMPersonComm).FindPartTimeData("1","","","2021-03-01","2021-03-31","0")
ClassMethod FindPartTimeData(loc As %String, workLoc As %String, input As %String, stDate As %String, endDate As %String, nurseid)
{
	s ret=""
	s:stDate["-" stDate=$zdh(stDate,3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s tmpWard=""
	s tmpNurse=""
	s count=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s locId="" f  s locId=$o(^DHCINM.HR.MgPartTimeApplyI("isOnPost"," N",locId)) q:locId=""  d
	.q:(loc'="")&&(loc'=$tr(locId," ",""))
	.s PTloc=$G(^DHCINM.HR.MgPartTimeLocD($tr(locId," ","")))
	.q:PTloc=""
	.s locDr=$lg(PTloc,2)
	.s sum=0
	.s sumTimes=0
	.s sumHours=0
	.s locName=$lg(^CF.DHCINM.DB.MgWardLocD(locDr),3)
	.s post="" f  s post=$o(^DHCINM.HR.MgPartTimeApplyI("isOnPost"," N",locId,post)) q:post=""  d
	..s postObj=$g(^DHCINM.HR.MgPartTimePostD($tr(locId," ",""),$tr(post," ","")))
	..q:postObj=""
	..s postName=$lg(postObj,3)
	..s price=$lg(postObj,4)
	..s maxSalary=$lg(postObj,5)
	..s stTime=$lg(postObj,7)
	..s endTime=$lg(postObj,8)
	..s hour=$fn(($zth(endTime,2)-$zth(stTime,2))/3600,"",1)
	..s date="" f  s date=$o(^DHCINM.HR.MgPartTimeApplyI("isOnPost"," N",locId,post,date)) q:date=""  d
	...q:((stDate'="")&&(date<stDate))||((endDate'="")&&(date>endDate))
	...s perdr="" f  s perdr=$o(^DHCINM.HR.MgPartTimeApplyI("isOnPost"," N",locId,post,date,perdr)) q:perdr=""  d
	....s userid=$tr(perdr," ","")
	....s userObj=$g(^CF.DHCINM.DB.MgUserD(userid))
	....q:userObj=""
	....s perName=$lg(userObj,2)
	....s perId=$lg(userObj,3)
	....s per=$lg(userObj,5)
	....q:(input'="")&&((perName_perId)'[input)
	....s ward=$lg($g(^CF.DHCINM.HR.PersonsD(per)),10)
	....s wardLoc=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",ward,""))
	....q:(wardLoc="")||('$d(^CF.DHCINM.DB.MgWardLocD(wardLoc)))
	....q:(workLoc'="")&&(workLoc'=wardLoc)
	....s workLocName=$lg(^CF.DHCINM.DB.MgWardLocD(wardLoc),3)
	....s onceSalary=$fn(hour*price,"",1)
	....s:(maxSalary'="")&&(onceSalary>maxSalary) onceSalary=maxSalary
	....s count=count+1
	....i $g(tmpNurse(userid,$tr(locId," ",""),"SubRet"))="" s tmpNurse(userid,$tr(locId," ",""),"SubRet")=""",""Detail"":["_"{""PostName"":"""_postName_""",""Date"":"""_$zd(date,3)_""",""Hour"":"""_hour_""",""Salary"":"""_onceSalary_"""}"
	....e  s tmpNurse(userid,$tr(locId," ",""),"SubRet")=tmpNurse(userid,$tr(locId," ",""),"SubRet")_","_"{""PostName"":"""_postName_""",""Date"":"""_$zd(date,3)_""",""Hour"":"""_hour_""",""Salary"":"""_onceSalary_"""}"
	....s tmpNurse(userid,$tr(locId," ",""),"Ret")="{""PerName"":"""_perName_""",""PerId"":"""_perId_""",""Loc"":"""_locName_""",""WorkLoc"":"""_workLocName
	....s tmpNurse(userid,$tr(locId," ",""))=$g(tmpNurse(userid,$tr(locId," ","")))+1
	....s tmpNurse(userid,$tr(locId," ",""),$tr(post," ",""))=$g(tmpNurse(userid,$tr(locId," ",""),$tr(post," ","")))+1
	q:count=0 "{""rows"":[],""results"":""0""}"
	s ret="{""rows"":["
	s tCount=0
	s perDR="" f  s perDR=$o(tmpNurse(perDR)) q:perDR=""  d
	.s locDR="" f  s locDR=$o(tmpNurse(perDR,locDR)) q:locDR=""  d
	..s times=0
	..s sumHours=0
	..s sumTimes=0
	..s sum=0
	..i $o(tmpNurse(perDR,locDR,""))'="" d
	...s post="" f  s post=$o(tmpNurse(perDR,locDR,post)) q:post=""  d
	....q:(post="Ret")||(post="SubRet")
	....s times=$g(tmpNurse(perDR,locDR,post))
	....s postObj=$g(^DHCINM.HR.MgPartTimePostD(locDR,post))
	....q:postObj=""
	....s price=$lg(postObj,4)
	....s maxSalary=$lg(postObj,5)
	....s hours=$fn(hour*times,"",1)
	....s salary=$fn(price*hours,"",1)
	....s:(maxSalary'="")&&(salary>maxSalary) salary=maxSalary
	....s sum=sum+salary
	....s sumHours=sumHours+hours
	....s sumTimes=sumTimes+times
	..s tmpNurse(perDR,locDR,"Ret")=tmpNurse(perDR,locDR,"Ret")_""",""Times"":"""_sumTimes_""",""Salary"":"""_sum_""",""Hours"":"""_sumHours
	..s ret=ret_$case(tCount,0:"",:",")_tmpNurse(perDR,locDR,"Ret")_tmpNurse(perDR,locDR,"SubRet")_"],""results"":"""_tmpNurse(perDR,locDR)_"""}"
	..s tCount=tCount+1
	s ret=ret_"],""results"":"""_tCount_"""}"
 	w ret
 	q ""
}

/// Creator:liwenzhen
/// Createdate:2022-03-16
/// Description:导入轮转动态
/// Input:
/// Output:
/// Other:w ##class(web.INMPersonComm).ImportRotation("Cycle|17「CCU,29「产房^PerID|I155^","17")
ClassMethod ImportRotation(parr As %String = "", planId As %String = "")
{
	s ret=1
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s perID=$tr($g(tmp("PerID")),$c(9,10,13,32),"")
	s perName=$tr($g(tmp("PerName")),$c(9,10,13,32),"")
	s cycle=$tr($g(tmp("Cycle")),$c(9,10,13,32),"")
	s perDR=$o(^CF.DHCINM.HR.PersonsI("PerID"," "_$ZCVT(perID,"U"),""))
	q:perDR="" "工号"_perID_"不存在"
	s hour=+(..GetRotHour(perDR))
	s detailDR=$o(^DHCINM.Trans.MgRotationDetailI("ppid"," "_perDR," "_planId,""))
	d:detailDR="" ..SaveRotPer(perDR_"!"_hour_"!"_planId_"!1")
	s detailDR=$o(^DHCINM.Trans.MgRotationDetailI("ppid"," "_perDR," "_planId,""))
	
	s rotDepParr=""
	f i=1:1:$l(cycle,",") d
	.s cycleId=$tr($p($p(cycle,",",i),"「",1),$c(9,10,13,32),"")
	.s wardDesc=$tr($p($p(cycle,",",i),"「",2),$c(9,10,13,32),"")
	.s wardDR=$o(^CF.DHCINM.DB.MgWardI("Desc"," "_$ZCVT(wardDesc,"U"),""))
	.;s:wardDR="" ret=wardDesc_"病区不存在"
	.q:wardDR="" 
	.s id=$o(^DHCINM.Trans.MgRotationDepI("detaildr",perDR,cycleId,""))
	.s:rotDepParr'="" rotDepParr=rotDepParr_"「"_id_"!"_wardDR_"!!"_cycleId_"!"_planId_"!"_detailDR
	.s:rotDepParr="" rotDepParr=id_"!"_wardDR_"!!"_cycleId_"!"_planId_"!"_detailDR
	s ret=..SaveRotDep(rotDepParr)
	q ret
}

/// Creator:ChenPeng
/// Createdate:2022-05-09
/// Description:增加护士档案子项页签的配置
/// Input: 传入CF.DHCINM.HR.PerItemSet实体数据
/// Output: 返回处理结果
/// Table: CF.DHCINM.HR.PerItemSet
/// Other:
/// Debug: w ##class(web.INMPersonComm).SavePerItemTab("ItemCode|personJob^ItemDesc|职称信息^SortIdx|1^ShowFlag|Y")
ClassMethod SavePerItemTab(parr As %Binary) As %Status
{
	q:parr="" "传入数据不能为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.node)
	s rwId=$g(node("rw"))
	if (rwId'=""){
		s perItemSet=##class(CT.DHCINM.Set.MgPerItemSet).%OpenId(rwId)
		s sortRw=$o(^CT.DHCINM.Set.MgPerItemSetI("Sort",node("SortIdx"),""))
		q:((sortRw'="")&&(sortRw'=rwId)) "该次序位置已经存在了，请选择其他顺序"
	}
	else {
		s perItemSet=##class(CT.DHCINM.Set.MgPerItemSet).%New()
		// 需要判断ItemCode/SortIdx是否唯一
		s codeId=$o(^CT.DHCINM.Set.MgPerItemSetI("Code", node("ItemCode"), ""))
		q:codeId'="" "项目编码已经存在，请不要重复添加"
		s sortId=$o(^CT.DHCINM.Set.MgPerItemSetI("Sort", node("SortIdx"), ""))
		q:sortId'="" "显示序号已经存在，请更改为未设置的序号"
	}
	s perItemSet.ItemCode=node("ItemCode")
	s perItemSet.ItemDesc=node("ItemDesc")
	s perItemSet.SortIdx=node("SortIdx")
	s perItemSet.ShowFlag=node("ShowFlag")
	s sc=perItemSet.%Save()
	q sc
}

/// Creator:ChenPeng
/// Createdate:2022-05-09
/// Description:获取最大顺序号的下一个次序
/// Input: 
/// Output: 返回处理结果
/// Table: CF.DHCINM.HR.PerItemSet
/// Other:
/// Debug: w ##class(web.INMPersonComm).GetNextSortIdx()
ClassMethod GetNextSortIdx() As %String
{
	s sort=""
	s maxSort=$o(^CT.DHCINM.Set.MgPerItemSetI("Sort", sort), -1)
	s nextSort=maxSort+1
	q "NextSort|"_nextSort
}

/// Creator:ChenPeng
/// CreateDate:2022-05-09
/// Description:批量更新护士档案子项显示顺序
/// Input: 
/// Output: 返回处理结果
/// Table: CF.DHCINM.HR.PerItemSet
/// Other:
/// Debug: w ##class(web.INMPersonComm).SortBatchPerItemTab("rw@SortIdx^1@2|2@y1")
ClassMethod SortBatchPerItemTab(parr As %String = "") As %Status
{
	q:parr="" $$$OK
	s sc=$$$OK
	// 解析传入的参数字符串的
	s flag=..ParseStr2Node(parr, "^", "|", "@", .node)
	q:flag=0 1
	ts
	s idx="" f  s idx=$o(node(idx)) q:((idx="")||$$$ISERR(sc))  d
	.s rw=$g(node(idx,"rw"))
	.s perItem=##class(CT.DHCINM.Set.MgPerItemSet).%OpenId(rw)
	.s perItem.SortIdx=$g(node(idx,"SortIdx"))
	.s sc=perItem.%Save()
	if ($$$ISOK(sc)) {
		tc
	} else {
		tro
	}
	q $$$ISOK(sc)
}

/// Creator:ChenPeng
/// CreateDate:2022-05-09
/// Description:解析前端传的数组拼接字符串
/// Input: 前端[{key1:val1,key2:val2},{key1:val3,key2:va4},{key1:val5,key2:val6}] -> 拼字符串key1@key2^val1@val2|val3@val4|val5@val6
/// --> 解析字符串 node(1,key1)=val1,node(1,key2)=val2,node(2,key1)=val3,node(2,key2)=val4,node(3,key1)=val5,node(3,key2)=val6
/// Output: 返回处理结果
/// Table: CF.DHCINM.HR.PerItemSet
/// Other:
/// Debug: d ##class(web.INMPersonComm).ParseStr2Node("rw@SortIdx^x1@y1|x2@y2")
ClassMethod ParseStr2Node(parr As %String, k As %String = "^", t As %String = "|", v As %String = "@", node As %String) As %String
{
	q:parr="" 0
	s fieldStr=$p(parr, k)
	s fieldArr=$lfs(fieldStr, v)
	s fieldLen=$ll(fieldArr)
	s valStr=$p(parr, k, 2)
	s len = $l(valStr, t)
	f i=1:1:len {
		s valueStr=$p(valStr, t, i)
		f j=1:1:fieldLen {
			s val=$p(valueStr, v, j)
			s node(i, $lg(fieldArr, j))=val
		}
	}
	q $d(node)
}

/// Creator:ChenPeng
/// Createdate:2022-05-09
/// Description:查询全部护士档案子项页签的配置
/// Input:
/// Output:
/// Table: CF.DHCINM.HR.PerItemSet
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMPersonComm","FindPerItemTab")
Query FindPerItemTab(parr As %String = "") As websys.Query(ROWSPEC = "ret")
{
}

ClassMethod FindPerItemTabExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	d PreExecuteHandler
	// 按照顺序字段输出结果SortIdx
	s sort="" f  s sort=$o(^CT.DHCINM.Set.MgPerItemSetI("Sort",sort)) q:sort=""  d
	.s rowId=$o(^CT.DHCINM.Set.MgPerItemSetI("Sort",sort,""))
	.s perItemSet=##class(CT.DHCINM.Set.MgPerItemSet).%OpenId(rowId)
	.k node
	.s node("ShowFlag")=perItemSet.ShowFlag
	.s node("rw")=perItemSet.%Id()
	.s node("ItemCode")=perItemSet.ItemCode
	.s node("ItemDesc")=perItemSet.ItemDesc
	.s node("SortIdx")=perItemSet.SortIdx
	.s node("ShowFlagDesc")=$case(perItemSet.ShowFlag, "Y":"显示","N":"隐藏",:"未知状态")
	.s node("CreateTime")=$zd(perItemSet.CreateDate,3)_" "_$zt(perItemSet.CreateTime,1)
	.s ret=..PackageResp(.node)
	.d PostProcessor
	d PostExecuteHandler
	q $$$OK
PreExecuteHandler
	s repid=$i(^CacheTemp)
	s ind=1,ret=""
	q
PostProcessor
	s ^CacheTemp(repid,ind)=$lb(ret)
	s ind=ind+1
	q
PostExecuteHandler
	s qHandle=$lb(0,repid,0)
	q
}

}
