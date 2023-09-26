/// Creator:lulin
/// Descriptions:护理教学模块
/// Date:2020-06-30
Class web.INMTeaComm Extends %RegisteredObject
{

/// ----公共方法---
/// 根据考试时间，确定考试状态
ClassMethod GetTimeStatus(TimeList) As %String
{
	s nowDate=+$H,realTimeSt="",realTimeEnd="",ExamStep=2
	f i=1:1:$LL(TimeList)  d
	.s rowData=$LG(TimeList,i)
	.q:rowData=""
	.s timeSt=$zdh($P(rowData,"」",1),3)
	.s timeEnd=$zdh($P(rowData,"」",2),3)
	.s:((realTimeSt="")||(realTimeSt>timeSt)) realTimeSt=timeSt
	.s:((realTimeEnd="")||(realTimeEnd<timeEnd)) realTimeEnd=timeEnd
	i ((realTimeSt'="")&&(realTimeEnd'="")) d
	.i ((nowDate>=realTimeSt)&&(nowDate<=realTimeEnd)) d
	..s ExamStep=1
	.e  i nowDate>realTimeEnd d
	..s ExamStep=3	
	q ExamStep
}

/// 答案是否正确
/// Output:0≤x≤1得分权重，2：需要手动阅卷,
ClassMethod IsCurrect(result, SubObj As CF.DHCINM.DB.TeaTheorySub) As %String
{
	s subAnswer=SubObj.SubAnswer
	if (SubObj.SubMode="S") {
		q result=subAnswer	
	}elseIf(SubObj.SubMode="M") {
		s ret=1
		s resultLB=$LFS(result,"」")
		f i=1:1:$L(SubObj.SubAnswer,"」") q:ret'=1  d
		.s:$LF(resultLB,$P(SubObj.SubAnswer,"」",i))<1 ret=0
		q ret
	}elseIf (SubObj.SubMode="A"){
		q 2
	}elseIf (SubObj.SubMode="B"){
		s SubAnsOrderFlag=SubObj.SubAnsOrderFlag ;不区分先后顺序
		s SubAnsCaseFlag=SubObj.SubAnsCaseFlag ;包含即可得分
		s SubAnsConFlag=SubObj.SubAnsConFlag ;不区分大小写
		s Length=$L(subAnswer,"」")
		s:SubAnsConFlag'=1 subAnswer=$zcvt(subAnswer,"U"),result=$zcvt(result,"U") ;不区分大小写--默认
		s subAnswerLB=$LFS(subAnswer,"」")
		s resultLB=$LFS(result,"」")
		s resultNum=0
		f i=1:1:Length d
		.s tResult=$LG(resultLB,i)
		.s tFlag=0
		.i SubAnsOrderFlag=1 d
		..f j=1:1:Length q:tFlag=1  d
		...s tSubAnswer=$LG(subAnswerLB,j)
		...d CaseFlag
		.e  d
		..s tSubAnswer=$LG(subAnswerLB,i)
		..d CaseFlag
		.s:tFlag=1 resultNum=resultNum+1
		q resultNum/Length
	}
CaseFlag
	f z=1:1:$L(tSubAnswer,"|") q:tFlag=1  d
	.s ttAnswer=$P(tSubAnswer,"|",z)
	.q:ttAnswer=""
	.i SubAnsCaseFlag=1 d ;包含即可得分
	..s:tResult[ttAnswer tFlag=1
	.e  d
	..s:tResult=ttAnswer tFlag=1
	q
}

/// Creator:lulin
/// Createdate:2020-12-08
/// Description:获根据不同的条件获取人员信息，用于单类多条件筛选
/// Input:
/// Output:
/// Other:w ##class(%ResultSet).RunQuery("web.INMTeaComm","FindPersonForMoreList","护士层级^","","0")
Query FindPersonForMoreList(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindPersonForMoreListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s type=$P(parr,"^",1)
	s typeId=$P(parr,"^",2)
	s input=$zcvt(input,"U") ;输入
	s nowDate=+$H
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	s perDR="" f  s perDR=$o(^CF.DHCINM.HR.PersonsD(perDR))  q:perDR=""  d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perDR)
	.q:'$IsObject(perObj)
	.s isWorNur=##class(web.INMHRComm).IsFormalWorkNur(perDR,+$H,"")
	.q:isWorNur=0 ;只要在职
	.s wardId=perObj.PerDepDR
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
	.q:((isAll=0)&&('$D(tmpWard(wardId)))) ;不在所辖范围
	.q:'$IsObject(wardObj)
	.q:((type="Ward")&&((","_typeId_",")'[(","_wardId_",")))  ;病区过滤
	.s PerID=perObj.PerID
	.s PerName=perObj.PerName
	.s UserNameShell=##class(web.INMVueComm).ToChineseSpell(PerName)
	.q:((input'="")&&((PerID_PerName_UserNameShell)'[input)) ;条件过滤
	.s wardDesc=wardObj.WardDesc
	.s defaultId=""
	.s exitFlag=0
	.i typeId'=""  d
	..i type="护士层级" d
	...s defaultInfo=##class(web.INMHRComm).GetNurseLevel(perDR,nowDate) ;层级
	...s defaultId=$P(defaultInfo,"^",1)
	...d fiterCode
	..e  i type="聘任职称"  d
	...s defaultInfo=##class(web.INMHRComm).GetNurseHireDuty(perDR,nowDate) ;职称
	...s defaultId=$P(defaultInfo,"^",1)
	...d fiterCode
	..e  i type="职务" d
	...s defaultInfo=##class(web.INMHRComm).GetNurseDuty(perDR,nowDate) ;职务
	...s defaultId=$P(defaultInfo,"^",1)
	...d fiterCode
	..e  i type="专科护士" d
	...s defaultId=##class(web.INMHRComm).GetNurseSpecial(perDR,nowDate) ;专科护士
	...d fiterCodeMore
	.q:exitFlag'=0
	.s ret="PerID|"_PerID_"^PerName|"_PerName_"^wardDesc|"_wardDesc_"^rw|"_perDR
	.s ret=ret
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
fiterCode
	s exitFlag=1
	f i=1:1:$L(typeId,",") d
	.s tTypeId=$P(typeId,",",i)
	.q:tTypeId=""
	.q:defaultId'=tTypeId 
	.s exitFlag=0
	q
fiterCodeMore
	s exitFlag=1
	f i=1:1:$L(typeId,",") d
	.s tTypeId=$P(typeId,",",i)
	.q:tTypeId=""
	.f j=1:1:$L(defaultId,",")  d
	..s tDefaultId=$P(defaultId,",",i)
	..q:tDefaultId=""
	..q:tDefaultId'=tTypeId 
	..s exitFlag=0
	q
}

ClassMethod FindPersonForMoreListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonForMoreListExecute ]
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

ClassMethod FindPersonForMoreListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonForMoreListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-11
/// Description:获取考官备选项
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindExaminer",0)
Query FindExaminer(loginID As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindExaminerExecute(ByRef qHandle As %Binary, loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmpWard="",nowDate=+$H,tmpUser=""
	s roleFlag=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	//获取所辖病区护士长、大科护士长、病区护士长、后续补齐
	s roleCodes=$LB("NURHEAD","ZNURHEAD","HLB")
	f i=1:1:$LL(roleCodes) d
	.s roleRw="" f  s roleRw=$O(^CT.DHCINM.Set.MgRolesI("code"," Y"," "_$LG(roleCodes,i),roleRw))  q:roleRw=""  d
	..s userRw="" f  s userRw=$O(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleRw,userRw)) q:userRw=""  d
	...s userObjLB=$G(^CF.DHCINM.DB.MgUserD(userRw))
	...q:userObjLB=""
	...s userStartDate=$LG(userObjLB,7)
	...s userEndDate=$LG(userObjLB,8)
	...q:((userStartDate'="")&&(userStartDate>nowDate))
	...q:((userEndDate'="")&&(userEndDate<nowDate))
	...s userName=$LG(userObjLB,2)
	...q:$d(tmpUser(userRw))
	...s validFlag=0 ;判断用户是否具有以上角色
	...s userRoleRw="" f  s userRoleRw=$O(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleRw,userRw,userRoleRw)) q:((userRoleRw="")||(validFlag=1))  d
	....s userRoleObjLB=$G(^CF.DHCINM.DB.MgUserRoleD(userRw,userRoleRw))
	....q:userRoleObjLB=""
	....s startDate=$LG(userRoleObjLB,3)
	....s endDate=$LG(userRoleObjLB,4)
	....q:((startDate'="")&&(startDate>nowDate))
	....q:((endDate'="")&&(endDate<nowDate))
	....s validFlag=1
	...q:validFlag=0
	...s userObjLB=$G(^CF.DHCINM.DB.MgUserD(userRw))
	...q:userObjLB=""
	...i roleFlag=1  d
	....s ret="rw|"_userRw_"^desc|"_userName
	....d OutputData
	...q:roleFlag=1
	...s PerDR=$LG(userObjLB,5)
	...q:PerDR=""
	...s perObj=$G(^CF.DHCINM.HR.PersonsD(PerDR))
	...q:perObj=""
	...s perWardId=$LG(perObj,10)
	...q:'$d(tmpWard(perWardId))
	...s ret="rw|"_userRw_"^desc|"_userName
	...d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	s tmpUser(userRw)=1
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExaminerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExaminerExecute ]
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

ClassMethod FindExaminerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExaminerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-06-30
/// Description:获取某人某题解答次数
/// Input:用户id,CF.DHCINM.DB.TeaTheorySub得id
/// Output:
/// Other:
ClassMethod GetLearnTheoryTestAnswerNum(userId, rw) As %String
{
	s retNum=0,correctFlag=1
	i $O(^DHCINM.Tea.LearnTheoryTestI("PerTheory",userId,rw,""))'="" d
	.s testId="" f  s testId=$O(^DHCINM.Tea.LearnTheoryTestI("PerTheory",userId,rw,testId)) q:testId=""  d
	..s objLB=$G(^DHCINM.Tea.LearnTheoryTestD(testId))
	..q:objLB=""
	..s AnswerTimes=$LG(objLB,8)
	..s Answer=$LG(objLB,5)
	..i AnswerTimes>retNum d
	...s retNum=AnswerTimes
	...s realAnswer=$LG($G(^CF.DHCINM.DB.TeaTheorySub($P(rw,"||",1),$P(rw,"||",2))),6)
	...s:realAnswer=Answer correctFlag=0
	
	q retNum_"^"_correctFlag
}

/// Creator:lulin
/// Createdate:2020-06-30
/// Description:获取章节练习
/// Input:用户id,0
/// Output:
/// Other:
ClassMethod FindLearnTheoryTest(userId, par) As %String
{
	s nowDate=+$H
	w "["
	s SingleNumPar=0,MultipleNumPar=0,AllNumPar=0,AnswerNumPar=0,ErrorNumPar=0,BlankNumPar=0
	s startFlag=0
	s MaxAnswerTimes=0
	
	s id="" f  s id=$O(^CF.DHCINM.DB.TeaTheoryI("par"," "_par,id)) q:id=""  d
	.s objLB=$g(^CF.DHCINM.DB.TeaTheoryD(id))
	.q:objLB=""
	.s sort=$LG(objLB,4)
	.q:sort=""
	.s TheoryDesc=$LG(objLB,2)
	.s startDate=$LG(objLB,5)
	.s endDate=$LG(objLB,6)
	.s stopFlag=0
	.s:((startDate'="")&&(startDate>nowDate)) stopFlag=1
	.s:((endDate'="" )&&(endDate<nowDate)) stopFlag=1
	.q:stopFlag=1
	.s LearnStDate=$lg(objLB,11)
	.q:((LearnStDate'="")&&(LearnStDate>nowDate))
	.s SingleNum=0,MultipleNum=0,AllNum=0,AnswerNum=0,ErrorNum=0,BlankNum=0
	.w:startFlag=1 ","
	.w "{""rw"":"""_id_""",""TheoryDesc"":"""_TheoryDesc_""","
	.s isEndFlag=0
	.i $O(^CF.DHCINM.DB.TeaTheoryI("par"," "_id,""))="" d ;末端节点获取数据
	..k tmp
	..s tmp=""
	..d ..SetTheoryTmp(.tmp,userId,id,.MaxAnswerTimes)
	..s subId="" f  s subId=$O(^CF.DHCINM.DB.TeaTheorySubD(id,subId)) q:subId=""  d
	...s subObjLB=$G(^CF.DHCINM.DB.TeaTheorySubD(id,subId))
	...q:subObjLB=""
	...s SubMode=$LG(subObjLB,4)
	...s SubStatus=$LG(subObjLB,12)
	...q:SubStatus'="Y"
	...q:((SubMode'="S")&&(SubMode'="M")&&(SubMode'="B"))
	...s:SubMode="S" SingleNum=SingleNum+1
	...s:SubMode="M" MultipleNum=MultipleNum+1
	...s:SubMode="B" BlankNum=BlankNum+1
	...s AllNum=AllNum+1
	...s AnswerNumRet=..GetLearnTheoryTestAnswerNum(userId,id_"||"_subId)
	...s AnswerTimes=$P(AnswerNumRet,"^",1)
	...s correctFlag=$P(AnswerNumRet,"^",2)
	...q:AnswerTimes=0
	...q:AnswerTimes<MaxAnswerTimes 
	...s AnswerNum=AnswerNum+1
	...s:correctFlag'=1 ErrorNum=ErrorNum+1
	.e  d
	..w """children"":"
	..s subResult=..FindLearnTheoryTest(userId,id)
	..w ","
	..s SingleNum=$P(subResult,"^",1),MultipleNum=$P(subResult,"^",2),AllNum=$P(subResult,"^",3),AnswerNum=$P(subResult,"^",4)
	..s ErrorNum=$P(subResult,"",5),BlankNum=$P(subResult,"^",6)
	.w """SingleNum"":"""_SingleNum_""",""MultipleNum"":"""_MultipleNum_""",""BlankNum"":"""_BlankNum_""""
	.w ",""AllNum"":"""_AllNum_""",""AnswerNum"":"""_AnswerNum_""""
	.w ",""ErrorNum"":"""_ErrorNum_""""
	.w "}"
	.s SingleNumPar=SingleNumPar+SingleNum,MultipleNumPar=MultipleNumPar+MultipleNum,BlankNumPar=BlankNumPar+BlankNum
	.s AllNumPar=AllNumPar+AllNum,AnswerNumPar=AnswerNumPar+AnswerNum,ErrorNumPar=ErrorNumPar+ErrorNum
	.s startFlag=1
	w "]"
	i par=0{
		q ""
	}else{
		q SingleNumPar_"^"_MultipleNumPar_"^"_AllNumPar_"^"_AnswerNumPar_"^"_ErrorNumPar_"^"_BlankNumPar
	}
}

/// Creator:lulin
/// Createdate:2020-07-03
/// Description:回调循环检索除所有题目即已解答次数
/// Input:临时数组，用户id，理论项目类别id
/// Output:
/// Other:
ClassMethod SetTheoryTmp(tmp, userId, id, MaxAnswerTimes)
{
	s childId=$O(^CF.DHCINM.DB.TeaTheoryI("par"," "_id,""))
	i childId="" {
		s subId="" f  s subId=$O(^CF.DHCINM.DB.TeaTheorySubD(id,subId)) q:subId=""  d
		.s objLB=$G(^CF.DHCINM.DB.TeaTheorySubD(id,subId))
		.q:objLB=""
		.s SubStatus=$LG(objLB,12)
		.q:SubStatus'="Y"
		.s SubMode=$LG(objLB,4)
		.q:((SubMode'="S")&&(SubMode'="M")&&(SubMode'="B"))
		.s AnswerNumRet=..GetLearnTheoryTestAnswerNum(userId,id_"||"_subId)
		.s AnswerTimes=$P(AnswerNumRet,"^",1)
		.s correctFlag=$P(AnswerNumRet,"^",2)
		.s:AnswerTimes>MaxAnswerTimes MaxAnswerTimes=AnswerTimes
		.s tmp(id,subId)=AnswerTimes
	}else{
		s nextChildId="" f  s nextChildId=$O(^CF.DHCINM.DB.TeaTheoryI("par"," "_id,nextChildId))  q:nextChildId=""  d
		.d ..SetTheoryTmp(.tmp,userId,nextChildId,.MaxAnswerTimes)
	}
}

/// Creator:lulin
/// Createdate:2020-06-30
/// Description:根据章节id获取所有需要解答的题目
/// Input:CF.DHCINM.DB.TeaTheorySub,已解答次数
/// Output:
/// Other:
ClassMethod GetTheoryProblem(rw, times) As %String
{
	s objLB=$G(^CF.DHCINM.DB.TeaTheorySubD($P(rw,"||",1),$P(rw,"||",2)))
	s SubDesc=$LG(objLB,2)
	s SubMode=$LG(objLB,4)
	s SubUrl=""
	s SubUrlLB=$LG(objLB,3)
	f i=1:1:$LL(SubUrlLB)  d
	.s tSubUrl=$LG(SubUrlLB,i)
	.q:tSubUrl=""
	.i SubUrl="" s SubUrl=tSubUrl
	.e  d
	..s SubUrl=SubUrl_","_tSubUrl
	s SubSource=$LG(objLB,8)
	s SubAnalysis=$LG(objLB,9)
	s SubOption=""
	s SubOptionLB=$LG(objLB,6)
	f i=1:1:$LL(SubOptionLB) d
	.s tSubOption=$LG(SubOptionLB,i)
	.q:tSubOption=""
	.i SubOption="" s SubOption=tSubOption
	.e  d
	..s SubOption=SubOption_"」"_tSubOption
	s SubAnswer=$LG(objLB,7)
	s Result=""
	i SubMode="B" d
	.f i=1:1:($L(SubAnswer,"」")-1) d
	..s Result=Result_"」"
	s SubAnsConFlag=$LG(objLB,14)
	s SubAnsCaseFlag=$LG(objLB,15)
	s SubAnsOrderFlag=$LG(objLB,16)
	s SubRefAnswer=$lg(objLB,13)
	s ret="SubRw|"_rw_"^SubDesc|"_SubDesc_"^SubMode|"_SubMode_"^SubSource|"_SubSource_"^SubAnalysis|"_SubAnalysis
	_"^SubUrl|"_SubUrl_"^SubOption|"_SubOption_"^AnswerTimes|"_times_"^SubAnswer|"_SubAnswer      
	_"^Result|"_Result_"^UsedTime|0^rw|"
	_"^SubAnsConFlag|"_SubAnsConFlag_"^SubAnsCaseFlag|"_SubAnsCaseFlag_"^SubAnsOrderFlag|"_SubAnsOrderFlag
	_"^CorrectFlag|"_"^SubRefAnswer|"_SubRefAnswer
	q ret
}

/// Creator:lulin
/// Createdate:2020-06-30
/// Description:根据章节id获取所有需要解答的题目
/// Input:用户id,理论题类别id
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindAllProblem",0,2)
Query FindAllProblem(userId, rw) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllProblemExecute(ByRef qHandle As %Binary, userId, rw) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp=""
	;1、循环所有题目找出每个题目解答次数
	s MaxAnswerTimes=0
	d ..SetTheoryTmp(.tmp,userId,rw,.MaxAnswerTimes)
	;2、取练习次数最多的题目为准，小于此题目数的都取出来
	s retTmp=""
	;s firstAnswerTimes=0,num=0
	s isAllFlag=0
	i MaxAnswerTimes'=0 d
	.s retParId=""  f  s retParId=$O(tmp(retParId)) q:((retParId="")||(isAllFlag=1))  d
	..s retSubId="" f  s retSubId=$O(tmp(retParId,retSubId)) q:((retSubId="")||(isAllFlag=1))  d
	...s AnswerTimes=$g(tmp(retParId,retSubId))
	...q:AnswerTimes=""
	...;s:((num=0)&&(AnswerTimes=0)) isAllFlag=1
	...;s:num=0 firstAnswerTimes=AnswerTimes
	...;s num=num+1
	...;q:isAllFlag=1
	...q:AnswerTimes>=MaxAnswerTimes ;大于第一次解答题目的都不要
	...s retTmp(retParId,retSubId)=AnswerTimes
	s:$O(retTmp(""))="" isAllFlag=1
	i isAllFlag {
		s retParId=""  f  s retParId=$O(tmp(retParId)) q:retParId=""  d
		.s retSubId="" f  s retSubId=$O(tmp(retParId,retSubId)) q:retSubId=""  d
		..s AnswerTimes=$g(tmp(retParId,retSubId))+1
		..s ret=..GetTheoryProblem(retParId_"||"_retSubId,AnswerTimes)
		..d OutputRowData
	}else{
		s retParId=""  f  s retParId=$O(retTmp(retParId)) q:retParId=""  d
		.s retSubId="" f  s retSubId=$O(retTmp(retParId,retSubId)) q:retSubId=""  d
		..s AnswerTimes=$g(retTmp(retParId,retSubId))+1
		..s ret=..GetTheoryProblem(retParId_"||"_retSubId,AnswerTimes)
		..d OutputRowData
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllProblemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllProblemExecute ]
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

ClassMethod FindAllProblemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllProblemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-06-30
/// Description:保存章节练习
/// Input:
/// Output:
/// Other:
ClassMethod SaveLearnTheoryTest(parr As %String) As %String
{
	s ^TMP("SaveLearnTheoryTest")=parr
	//"rw|"+rw+"^subRw|"+subRw+"^Result|"+Result+"^UsedTime|"+UsedTime+"^UserDR|"+UserDR+"^AnswerTimes|"+AnswerTimes
	q:parr="" "0^入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s subRw=$g(tmp("subRw"))
	s subObj=##class(CF.DHCINM.DB.TeaTheorySub).%OpenId(subRw)
	q:'$IsObject(subObj) "0^获取题型数据失败"
	i rw="" d
	.s obj=##class(DHCINM.Tea.LearnTheoryTest).%New()
	e  d
	.s obj=##class(DHCINM.Tea.LearnTheoryTest).%OpenId(rw)
	s obj.UserDR=$g(tmp("UserDR"))
	s obj.TeaTheorySubDR=subObj
	s obj.UsedTime=$g(tmp("UsedTime"))
	s obj.Result=$g(tmp("Result"))
	s obj.AnswerDate=+$H
	s obj.AnswerTime=$P($H,",",2)
	s obj.AnswerTimes=$g(tmp("AnswerTimes"))
	s obj.CorrectFlag=..IsCurrect(obj.Result,subObj)
	d obj.%Save()
	q "1^"_obj.%Id()_"^"_obj.CorrectFlag
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存考核发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveExamRelease(^TMP("SaveExamRelease"))
ClassMethod SaveExamRelease(parr As %String) As %String
{
	s ^TMP("SaveExamRelease")=parr
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	i rw="" d
	.s obj=##class(DHCINM.Tea.ExamRelease).%New()
	.s obj.CreatDate=+$H
	.s obj.CreatTime=$P($H,",",2)
	e  s obj=##class(DHCINM.Tea.ExamRelease).%OpenId(rw)
	q:(obj.Status="Y") "已审核不可修改"
	s className="DHCINM.Tea.ExamRelease"
	s customKey=$LB("Examiner","ReleaseTrain","ExamineeList","ExamineeList","TimeList","QuestRange","QuestRangeEmr")
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.i $D(tmp(p)) d
	..s value=tmp(p)
	..s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	..i ((ptype="date")&&(value'="")) d
	...s value=$zdh(value,3)
	..i p="ReleaseType" d
	...s value=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(value)
	..s $ZOBJPROPERTY(obj,p)=value
	;考官
	s listData=$G(tmp("Examiner"))
	d obj.Examiner.Clear()
	f i=1:1:$L(listData,",") d
	.s rowData=$P(listData,",",i)
	.q:rowData=""
	.d obj.Examiner.Insert(rowData)
	;考核人群
	s listData=$G(tmp("ExamineeList"))
	d obj.ExamineeList.Clear()
	f i=1:1:$L(listData,",") d
	.s rowData=$P(listData,",",i)
	.q:rowData=""
	.d obj.ExamineeList.Insert(rowData)
	;应急预案考核范围
	s listData=$G(tmp("QuestRangeEmr"))
	d obj.QuestRangeEmr.Clear()
	f i=1:1:$L(listData,",") d
	.s rowData=$P(listData,",",i)
	.q:rowData=""
	.d obj.QuestRangeEmr.Insert(rowData)
	;考试批次
	s listData=$G(tmp("TimeList"))
	d obj.TimeList.Clear()
	f i=1:1:$L(listData,"「") d
	.s rowData=$P(listData,"「",i)
	.q:rowData=""
	.d obj.TimeList.Insert(rowData)
	
	;理论、应急预案、技操考核范围
	s listData=$G(tmp("QuestRange"))
	d obj.QuestRange.Clear()
	f i=1:1:$L(listData,"「") d
	.s rowData=$P(listData,"「",i)
	.q:rowData=""
	.d obj.QuestRange.Insert(rowData)
	;理论/应急预案，智能-固定组卷,提前选好题目
	d obj.QuestRangeI.Clear()
	s error=""
	i ((obj.ReleaseMode'="O")&&(obj.RealPaperType="I")&&(obj.ReleaseDraw="Y")) d
	.d obj.QuestRangeI.Clear()
	.k retTmp
	.s retTmp=""
	.s error=..SetIntellectExamTheoryTmp(.retTmp,obj.QuestRange)
	.s problemId="" f  s problemId=$O(retTmp(problemId)) q:problemId=""  d
	..s score=retTmp(problemId)
	..s rowData=problemId_"」"_score
	..d obj.QuestRangeI.Insert(rowData)
	q:error'="" error
	TS
	s sc=$$$ISOK(obj.%Save())
	if sc{
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:获取考核发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).GetExamRelease(1)
ClassMethod GetExamRelease(rw) As %String
{
	s obj=##class(DHCINM.Tea.ExamRelease).%OpenId(rw)
	s nowDate=+$H
	q:'$IsObject(obj) ""
	s ret="rw|"_rw
	s className="DHCINM.Tea.ExamRelease"
	s customKey=$LB("ReleaseType","Examiner","ReleaseTrain","ExamineeList","ExamineeList","TimeList","QuestRange","QuestRangeEmr")
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.s value=$ZOBJPROPERTY(obj,p)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.i ((ptype="time")&&(value'="")) d
	..s value=$zt(value)
	.s ret=ret_"^"_p_"|"_value
	s ReleaseType="",ReleaseTypeDesc=""
	i $IsObject(obj.ReleaseType) d
	.s ReleaseType=obj.ReleaseType.%Id()
	.s ReleaseTypeDesc=obj.ReleaseType.SubDesc
	s ret=ret_"^ReleaseType|"_ReleaseType_"^ReleaseTypeDesc|"_ReleaseTypeDesc
	;考官
	s Examiner="",ExaminerDesc=""
	f i=1:1:obj.Examiner.Count()  d
	.s rowData=obj.Examiner.GetAt(i)
	.q:rowData=""
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(rowData)
	.q:'$IsObject(userObj)
	.i Examiner="" d
	..s Examiner=rowData,ExaminerDesc=userObj.UserName
	.e  d
	..s Examiner=Examiner_","_rowData,ExaminerDesc=ExaminerDesc_","_userObj.UserName
	s ret=ret_"^Examiner|"_Examiner_"^ExaminerDesc|"_ExaminerDesc
	;考核人群
	s ExamineeList="",ExamineeListDesc=""
	f i=1:1:obj.ExamineeList.Count()  d
	.s rowData=obj.ExamineeList.GetAt(i)
	.q:rowData=""
	.s tRowDataDesc=""
	.i obj.Examinee="病区" d
	..s tRowDataDesc=$lg($g(^CF.DHCINM.DB.MgWardD(rowData)),4)
	.e  d
	..s tRowDataDesc=##class(web.INMDBComm).GetCommCode(rowData)
	.i ExamineeList="" d
	..s ExamineeList=rowData,ExamineeListDesc=tRowDataDesc 
	.e  d
	..s ExamineeList=ExamineeList_","_rowData,ExamineeListDesc=ExamineeListDesc_","_tRowDataDesc
	s ret=ret_"^ExamineeList|"_ExamineeList_"^ExamineeListDesc|"_obj.Examinee_":"_ExamineeListDesc
	;技操考核范围
	s QuestRangeEmr=""
	f i=1:1:obj.QuestRangeEmr.Count()  d
	.s rowData=obj.QuestRangeEmr.GetAt(i)
	.q:rowData=""
	.i QuestRangeEmr="" d
	..s QuestRangeEmr=rowData
	.e  d
	..s QuestRangeEmr=QuestRangeEmr_","_rowData
	s ret=ret_"^QuestRangeEmr|"_QuestRangeEmr
	;考试批次
	s TimeList=""
	s ExamStep=..GetTimeStatus($LG($g(^DHCINM.Tea.ExamReleaseD(rw)),14))
	f i=1:1:obj.TimeList.Count()  d
	.s rowData=obj.TimeList.GetAt(i)
	.q:rowData=""
	.i TimeList="" d
	..s TimeList=rowData
	.e  d
	..s TimeList=TimeList_"「"_rowData
	s ret=ret_"^TimeList|"_TimeList_"^ExamStep|"_ExamStep
	;理论、应急预案考核范围
	;考试批次
	s QuestRange=""
	f i=1:1:obj.QuestRange.Count()  d
	.s rowData=obj.QuestRange.GetAt(i)
	.q:rowData=""
	.i QuestRange="" d
	..s QuestRange=rowData
	.e  d
	..s QuestRange=QuestRange_"「"_rowData
	s ret=ret_"^QuestRange|"_QuestRange
	s StatusDesc=$case(obj.Status,"Y":"已发布","N":"未发布",:obj.Status)
	s ret=ret_"^StatusDesc|"_StatusDesc
	s wardDesc=""
	f i=1:1:$L(obj.ExamineeWard,",") d
	.s wardID=$P(obj.ExamineeWard,",",i)
	.q:wardID=""
	.s tWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(wardID)),4)
	.i wardDesc="" s wardDesc=tWardDesc
	.e  s wardDesc=wardDesc_","_tWardDesc
	s ret=ret_"^ExamineeWardDesc|"_wardDesc
	q ret
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存考生并且发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveReleaseExaminee("2|1^3|1^4|1","2")
ClassMethod SaveReleaseExaminee(parr, rw) As %String
{
	s obj=##class(DHCINM.Tea.ExamRelease).%OpenId(rw)
	q:'$IsObject(obj) "无此记录信息,请刷新重试"
	s oldStatus=obj.Status
	s obj.Status="Y"
	d obj.%Save()
	s tmpUser=""
	f i=1:1:$L(parr,"^") d
	.s user=$P(parr,"^",i)
	.q:user=""
	.s userId=$P(user,"|",1)
	.s wardDR=$P(user,"|",2)
	.q:userId=""
	.s tmpUser(userId)=wardDR
	.s subId=$O(^DHCINM.Tea.ExamReleaseSubI("User",rw,userId,""))
	.i subId="" d
	..s subObj=##class(DHCINM.Tea.ExamReleaseSub).%New()
	..s subObj.Parref=obj
	..s subObj.UserDR=userId
	..s subObj.WardDR=wardDR
	..d subObj.%Save()
	s subId="" f  s subId=$O(^DHCINM.Tea.ExamReleaseSubD(rw,subId)) q:subId=""  d
	.s subObj=##class(DHCINM.Tea.ExamReleaseSub).%OpenId(rw_"||"_subId)
	.q:'$IsObject(subObj)
	.q:$d(tmpUser(subObj.UserDR))
	.q:subObj.ExceptionDR'=""  ;已置异常不可删除
	.i obj.ReleaseMode="O" d
	..s isUsed=$D(^DHCINM.Tea.ExamOperaI("releaseUser",rw,userId))
	.e  d
	..s isUsed=$D(^DHCINM.Tea.ExamTheoryI("releaseUser",rw,userId))
	.q:isUsed'=0 ;已考核不可删除
	.d subObj.%DeleteId(rw_"||"_subId)
	q 1
}

/// Creator:lulin
/// Createdate:2020-08-07
/// Description:获取已选考生
/// Input:
/// Output:
/// Other:w ##class(%ResultSet).RunQuery("web.INMTeaComm","FindSelectExamineeList","2","")
Query FindSelectExamineeList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindSelectExamineeListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	//循环所辖病区获取人员
	//获取已经配置的人员信息
	s releaseId=$P(parr,"^",1)
	s UserType=$P(parr,"^",2)
	i UserType="D"{
		s objLB=$g(^DHCINM.Tea.DrillReleaseD(releaseId))
	}else{
		s objLB=$g(^DHCINM.Tea.ExamReleaseD(releaseId))
	}
	
	if objLB="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s input=$zcvt(input,"U")
	s nowDate=+$H
	s retTmp="",isExitFlag=0
	s ReleaseMode=""
	i UserType="D"{
		s loginID=$lg(objLB,56)
		s Examinee=$lg(objLB,12)
		s ExamineeList=$lg(objLB,13)
		s ExamineeList=$LFS(ExamineeList,",")
		s ExamineeWard=$lg(objLB,14)
		s Status=$lg(objLB,55)
		s subId="" f  s subId=$O(^DHCINM.Tea.DrillReleaseSubD(releaseId,subId)) q:subId=""  d
		.s subObj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(releaseId_"||"_subId)
		.q:'$IsObject(subObj)
		.s retTmp(subObj.UserDR)=1_"^"_subObj.WardDR
		.s isExitFlag=1
	}else{
		s loginID=$lg(objLB,23)
		s Examinee=$lg(objLB,12)
		s ExamineeList=$lg(objLB,13)
		s ReleaseMode=$lg(objLB,2)
		s Status=$lg(objLB,22)
		s ExamineeWard=$lg(objLB,29)
		s subId="" f  s subId=$O(^DHCINM.Tea.ExamReleaseSubD(releaseId,subId)) q:subId=""  d
		.s subObj=##class(DHCINM.Tea.ExamReleaseSub).%OpenId(releaseId_"||"_subId)
		.q:'$IsObject(subObj)
		.s retTmp(subObj.UserDR)=1_"^"_subObj.WardDR
		.s isExitFlag=1
	}
	b ;001
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	
	i (Status'="Y")&&(isExitFlag=0)  d
	.s perDR="" f  s perDR=$o(^CF.DHCINM.HR.PersonsD(perDR))  q:perDR=""  d
	..s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perDR)
	..q:'$IsObject(perObj)
	..s isWorNur=##class(web.INMHRComm).IsFormalWorkNur(perDR,nowDate,"") ;是否在职
	..q:isWorNur=0
	..s wardId=perObj.PerDepDR
	..
	..s wardLB=$LFS(ExamineeWard,",")
	..q:((ExamineeWard'="")&&((wardId="")||($LF(wardLB,wardId)<1)))
	..s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
	..q:((isAll=0)&&('$D(tmpWard(wardId)))) ;不在所辖范围,后期可能需要修改
	..q:'$IsObject(wardObj)
	..s userId=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perDR,""))
	..q:userId="" ;无对应用户
	..q:$D(retTmp(userId)) ;已经选入的过滤掉
	..s retTmp(userId)=0_"^"_wardId
	
	s userId="" f  s userId=$O(retTmp(userId)) q:userId=""  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(userId)
	.q:'$IsObject(userObj)
	.s UserCode=userObj.UserID
	.s UserName=userObj.UserName
	.s UserNameShell=##class(web.INMVueComm).ToChineseSpell(UserName)
	.b ;002
	.q:((input'="")&&((UserCode_UserName_UserNameShell)'[input)) ;条件过滤
	.s wardId=$P($G(retTmp(userId)),"^",2),wardDesc=""
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
	.s:$IsObject(wardObj) wardDesc=wardObj.WardDesc
	.s isSelect=$P($G(retTmp(userId)),"^",1)
	.s perDR=userObj.PerDR
	.s defaultDesc="",defaultId=""
	.s:$LL(ExamineeList)<1 isSelect=1
	.i ((perDR'="")&&($LL(ExamineeList)>0))  d
	..i Examinee="护士层级" d
	...s defaultInfo=##class(web.INMHRComm).GetNurseLevel(perDR,nowDate) ;层级
	...s defaultDesc=$P(defaultInfo,"^",2)
	...s defaultId=$P(defaultInfo,"^",1)
	..e  i Examinee="聘任职称"  d
	...s defaultInfo=##class(web.INMHRComm).GetNurseDuty(perDR,nowDate) ;职称
	...s defaultDesc=$P(defaultInfo,"^",2)
	...s defaultId=$P(defaultInfo,"^",1)
	..e  i Examinee="职务" d
	...s defaultInfo=##class(web.INMHRComm).GetNurseHireDuty(perDR,nowDate) ;职务
	...s defaultDesc=$P(defaultInfo,"^",2)
	...s defaultId=$P(defaultInfo,"^",1)
	..s:((Status'="Y")&&(isExitFlag=0)&&($LF(ExamineeList,defaultId)>0)) isSelect=1 ;发布进行管理时默认选择条件已已选择
	.s isUsed=0
	.i UserType="D" d
	.e  d
	..i ReleaseMode="O" d
	...s isUsed=$D(^DHCINM.Tea.ExamOperaI("releaseUser",releaseId,userId))
	..e  d
	...s isUsed=$D(^DHCINM.Tea.ExamTheoryI("releaseUser",releaseId,userId))
	.s:isUsed'=0 isUsed=1
	.s ret="UserId|"_userId_"^UserCode|"_UserCode_"^UserName|"_UserName_"^UserSehll|"_UserNameShell
	.s ret=ret_"^wardDesc|"_wardDesc_"^wardId|"_wardId
	.s ret=ret_"^defaultDesc|"_defaultDesc_"^isSelect|"_isSelect_"^isUsed|"_isUsed
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSelectExamineeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSelectExamineeListExecute ]
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

ClassMethod FindSelectExamineeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSelectExamineeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-08-07
/// Description:获取备考生
/// Input:
/// Output:
/// Other:w ##class(%ResultSet).RunQuery("web.INMTeaComm","FindExamineeList","2","","0")
Query FindExamineeList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindExamineeListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	//循环所辖病区获取人员
	//获取已经配置的人员信息
	s releaseId=$P(parr,"^",1)
	s UserType=$P(parr,"^",2)
	i UserType="D"{
		s objLB=$g(^DHCINM.Tea.DrillReleaseD(releaseId))
	}else{
		s objLB=$g(^DHCINM.Tea.ExamReleaseD(releaseId))
	}
	
	if objLB="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s input=$zcvt(input,"U")
	
	s nowDate=+$H
	s retTmp="",isExitFlag=0
	s ReleaseMode=""
	i UserType="D"{
		s loginID=$lg(objLB,56)
		s Examinee=$lg(objLB,12)
		s ExamineeList=$lg(objLB,13)
		s ExamineeList=$LFS(ExamineeList,",")
		s Status=$lg(objLB,55)
		s subId="" f  s subId=$O(^DHCINM.Tea.DrillReleaseSubD(releaseId,subId)) q:subId=""  d
		.s subObj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(releaseId_"||"_subId)
		.q:'$IsObject(subObj)
		.s retTmp(subObj.UserDR)=1_"^"_subObj.WardDR
		.s isExitFlag=1
	}else{
		s loginID=$lg(objLB,23)
		s Examinee=$lg(objLB,12)
		s ExamineeList=$lg(objLB,13)
		s ReleaseMode=$lg(objLB,2)
		s Status=$lg(objLB,22)
		s subId="" f  s subId=$O(^DHCINM.Tea.ExamReleaseSubD(releaseId,subId)) q:subId=""  d
		.s subObj=##class(DHCINM.Tea.ExamReleaseSub).%OpenId(releaseId_"||"_subId)
		.q:'$IsObject(subObj)
		.s retTmp(subObj.UserDR)=1_"^"_subObj.WardDR
		.s isExitFlag=1
	}
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	
	
	
	s perDR="" f  s perDR=$o(^CF.DHCINM.HR.PersonsD(perDR))  q:perDR=""  d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perDR)
	.q:'$IsObject(perObj)
	.s isWorNur=##class(web.INMHRComm).IsFormalWorkNur(perDR,nowDate,"") ;是否在职
	.q:isWorNur=0
	.s wardId=perObj.PerDepDR
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
	.q:((isAll=0)&&('$D(tmpWard(wardId)))) ;不在所辖范围
	.q:'$IsObject(wardObj)
	.s userId=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perDR,""))
	.q:userId="" ;无对应用户
	.q:$D(retTmp(userId)) ;已经选入的过滤掉
	.s retTmp(userId)=0_"^"_wardId
	
	
	s userId="" f  s userId=$O(retTmp(userId)) q:userId=""  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(userId)
	.q:'$IsObject(userObj)
	.s UserCode=userObj.UserID
	.s UserName=userObj.UserName
	.s UserNameShell=##class(web.INMVueComm).ToChineseSpell(UserName)
	.q:((input'="")&&((UserCode_UserName_UserNameShell)'[input)) ;条件过滤
	.s wardId=$P($G(retTmp(userId)),"^",2),wardDesc=""
	.s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(wardId)
	.s:$IsObject(wardObj) wardDesc=wardObj.WardDesc
	.s isSelect=$P($G(retTmp(userId)),"^",1)
	.s perDR=userObj.PerDR
	.s defaultDesc="",defaultId=""
	.i perDR'=""  d
	..i Examinee="护士层级" d
	...s defaultInfo=##class(web.INMHRComm).GetNurseLevel(perDR,nowDate) ;层级
	...s defaultDesc=$P(defaultInfo,"^",2)
	...s defaultId=$P(defaultInfo,"^",1)
	..e  i Examinee="聘任职称"  d
	...s defaultInfo=##class(web.INMHRComm).GetNurseDuty(perDR,nowDate) ;职称
	...s defaultDesc=$P(defaultInfo,"^",2)
	...s defaultId=$P(defaultInfo,"^",1)
	..e  i Examinee="职务" d
	...s defaultInfo=##class(web.INMHRComm).GetNurseHireDuty(perDR,nowDate) ;职务
	...s defaultDesc=$P(defaultInfo,"^",2)
	...s defaultId=$P(defaultInfo,"^",1)
	..s:((Status'="Y")&&(isExitFlag=0)&&($LF(ExamineeList,defaultId)>0)) isSelect=1 ;发布进行管理时默认选择条件已已选择
	.s isUsed=0
	.i UserType="D" d
	.e  d
	..i ReleaseMode="O" d
	...s isUsed=$D(^DHCINM.Tea.ExamOperaI("releaseUser",releaseId,userId))
	..e  d
	...s isUsed=$D(^DHCINM.Tea.ExamTheoryI("releaseUser",releaseId,userId))
	.s:isUsed'=0 isUsed=1
	.s ret="UserId|"_userId_"^UserCode|"_UserCode_"^UserName|"_UserName_"^UserSehll|"_UserNameShell
	.s ret=ret_"^wardDesc|"_wardDesc_"^wardId|"_wardId
	.s ret=ret_"^defaultDesc|"_defaultDesc_"^isSelect|"_isSelect_"^isUsed|"_isUsed
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExamineeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExamineeListExecute ]
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

ClassMethod FindExamineeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExamineeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:考核发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).CanselReleasePublish(6,0)
ClassMethod CanselReleasePublish(rw, loginID) As %String
{
	s obj=##class(DHCINM.Tea.ExamRelease).%OpenId(rw)
	q:'$IsObject(obj) "无此记录信息"
	s oldStatus=obj.Status
	q:obj.Creator'=loginID "非创建者不可撤销发布"
	q:((oldStatus'="Y")) "非已发布,不可撤销"
	s isUsed=0
	s isUsed=$D(^DHCINM.Tea.ExamOperaI("release",rw))
	s:isUsed=0 isUsed=$D(^DHCINM.Tea.ExamTheoryI("release",rw))
	q:isUsed'=0 "已进行考核,不可撤销"
	s obj.Status="N"
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:删除考核发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).DeleteExamRelease(rw,loginID)
ClassMethod DeleteExamRelease(rw, loginID) As %String
{
	s obj=##class(DHCINM.Tea.ExamRelease).%OpenId(rw)
	q:'$IsObject(obj) "无此记录信息"
	s oldStatus=obj.Status
	q:(oldStatus'="N") "非已保存信息,不可删除"
	q:obj.Creator'=loginID "非创建者不可删除"
	d obj.%DeleteId(rw)
	q 1
}

/// Creator:lulin
/// Createdate:2020-07-14
/// Description:查询任务发布
/// Input:parr:startDate^endDate^type,type:用途："":查询，"Y":考核，"N":引用,input,loginID
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindReleaseList","^^1^T^","测","0")
Query FindReleaseList(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindReleaseListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s startDate=$P(parr,"^",1)
	i startDate["-" d
	.s startDate=$zdh(startDate,3)
	e  d
	.s startDate=""
	s endDate=$P(parr,"^",2)
	i endDate["-" d
	.s endDate=$zdh(endDate,3)
	e  d
	.s endDate=""
	s selecttype=$P(parr,"^",3) ;查询条件类型1:考核主题，2：考核类型，3：考核级别，4：状态
	;考核发布界面缺少对登陆者、层级的验证
	s selectMode=$P(parr,"^",4) ;T：理论，O:技操，E:应急预案。存在则是检查时获取任务
	s selectStep=$P(parr,"^",5) ;考核状态
	s input=$zcvt(input,"U")
	s ret="",nowDate=+$H
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"hlb,hlbzr,manager,admin",+$H)
	s isZurHead=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"znurhead",+$H)
	s isNurhead=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"nurhead",+$H)
	s id="" f  s id=$O(^DHCINM.Tea.ExamReleaseD(id)) q:id=""  d
	.s objLB=$g(^DHCINM.Tea.ExamReleaseD(id))
	.q:objLB=""
	.s ReleaseMode=$LG(objLB,2)
	.s status=$LG(objLB,22)
	.q:((selectMode'="")&&(selectMode'=ReleaseMode))
	.q:((selectMode'="")&&(status'="Y")) ;类型不为空只取已发布
	.s CreateDate=$LG(objLB,24)
	.q:((startDate'="")&&(startDate>CreateDate))
	.q:((endDate'="")&&(endDate<CreateDate))
	.s TimeList="",ExamStep="",realTimeSt="",realTimeEnd=""
	.s TimeList=$LG(objLB,14)
	.s ExamStep=..GetTimeStatus(TimeList)
	.q:((selectStep'="")&&(selectStep'=ExamStep))
	.s showFlag=0
	.s ReleaseLevel=$LG(objLB,4)
	.s:selectMode="" showFlag=1
	.s Creator=$LG(objLB,23),OrderNum=""
	.s subID=$O(^DHCINM.Tea.ExamReleaseSubI("User",id,loginID,""))
	.i subID'="" d
	..s OrderNum=$lg($g(^DHCINM.Tea.ExamReleaseSubD(id,subID)),7)
	.i selectMode'=""  d ;考核显示
	..i isHLB=1 s showFlag=1 ;护理部全部可看
	..e  d
	..;i selectMode'="O" d ;理论、技操考官、考生可看
	..s:$D(^DHCINM.Tea.ExamReleaseSubI("User",id,loginID)) showFlag=1 ;考生可见
	..s Examiner=$LG(objLB,10) ;考官可看
	..s:$LF(Examiner,loginID) showFlag=1
	.e  d ;任务发布界面控制
	..s:((ReleaseLevel="H")&&(isHLB=1)) showFlag=1
	..s:((ReleaseLevel="L")&&((isZurHead=1)||(isHLB=1))) showFlag=1 ;科室级别所有科护士长可见？
	..s:((ReleaseLevel="W")&&((isZurHead=1)||(isHLB=1)||(isNurhead=1))) showFlag=1 ;病区级别所有护士长可见？
	.q:showFlag=0
	.s statusDesc=$case(status,"Y":"已发布","N":"未发布,保存",:status)
	.q:((status'="Y")&&(Creator'=loginID))
	.s existFlag=1
	.s:selecttype="" existFlag=0
	.s:input="" existFlag=0
	.i ((selecttype'="")&&(input'="")) d
	..i selecttype=1 d
	...s desc=$zcvt($LG(objLB,5),"U") ;主题
	...s:desc[input existFlag=0
	..i selecttype=2 d
	...s mode=$LG(objLB,2)
	...s modeDesc=$case(mode,"T":"理论","T":"技操","O":"应急预案",:mode)  ;类型
	...s:modeDesc[input existFlag=0
	..i selecttype=3 d
	...s levelDesc=$case(ReleaseLevel,"H":"院级","L":"科级","W":"病区",:mode) ;层级
	...s:levelDesc[input existFlag=0
	..i selecttype=4 d
	...s:statusDesc[input existFlag=0 ;状态
	.q:existFlag=1
	.s ret=..GetExamRelease(id)_"^OrderNum|"_OrderNum
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindReleaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReleaseListExecute ]
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

ClassMethod FindReleaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReleaseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-08-11
/// Description:查询已完成考核任务
/// Input:parr:mode^type
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindSubmitReleaseList","T^54||1","")
Query FindSubmitReleaseList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindSubmitReleaseListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s Mode=$P(parr,"^",1)
	s Type=$P(parr,"^",2)
	s ret="",nowDate=+$H
	s id="" f  s id=$O(^DHCINM.Tea.ExamReleaseD(id)) q:id=""  d
	.s objLB=$g(^DHCINM.Tea.ExamReleaseD(id))
	.q:objLB=""
	.s tMode=$LG(objLB,2)
	.q:((Mode'="")&&(Mode'=tMode))
	.s tType=$LG(objLB,3)
	.q:((Type'="")&&(Type'=tType))
	.s status=$LG(objLB,22)
	.q:(status'="Y") ;未发布过滤
	.s ReleaseDesc=$LG(objLB,2)
	.q:((input'="")&&(ReleaseDesc'[input))
	.s existFlag=0
	.s TimeList=$LG(objLB,14)
	.f i=1:1:$LL(TimeList)  d
	..s rowData=$LG(TimeList,i)
	..q:rowData=""
	..s timeSt=$zdh($P(rowData,"」",1),3)
	..s timeEnd=$zdh($P(rowData,"」",2),3)
	..s:nowDate<timeEnd existFlag=1
	.q:existFlag=1 ;未完成考核过滤
	.s ret=..GetExamRelease(id)
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSubmitReleaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSubmitReleaseListExecute ]
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

ClassMethod FindSubmitReleaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSubmitReleaseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-17
/// Description:查询考试明细
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindExamList","1^","",0)
Query FindExamList(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindExamListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",nowDate=+$H
	s realeaseRW=$P(parr,"^",1)
	s type=$P(parr,"^",2) ;1:考核人、2:病区、3:状态
	//type=3,input---A:通过、B:不通过、C:重考通过、D:待考核、E:缺考
	//考官、护理部可以查询全部
	//考生仅能看到个人
	//技操考核
	s obj=##class(DHCINM.Tea.ExamRelease).%OpenId(realeaseRW)
	i '$IsObject(obj){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ReleaseMode=obj.ReleaseMode ;类论:T、技操:O、应急预案:E
	s Examinee=obj.Examinee
	s ReleaseDesc=obj.ReleaseDesc
	i ((ReleaseMode="")||(Examinee="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ExamStep=..GetTimeStatus($LG($g(^DHCINM.Tea.ExamReleaseD(realeaseRW)),14))
	//护理部可查看全部
	s showAll=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"hlb",+$H)
	s:showAll'=1 showAll=(obj.Examiner.Find(loginID)>0)
	s subId="" f  s subId=$O(^DHCINM.Tea.ExamReleaseSubD(realeaseRW,subId)) q:subId=""  d
	.s subObj=##class(DHCINM.Tea.ExamReleaseSub).%OpenId(realeaseRW_"||"_subId)
	.q:'$IsObject(subObj)
	.s userId=subObj.UserDR
	.q:userId=""
	.q:((showAll'=1)&&(userId'=loginID)) ;非考官、护理部、考生不可见
	.s userObj=$G(^CF.DHCINM.DB.MgUserD(userId))
	.q:userObj=""
	.s userName=$LG(userObj,2)
	.s perDR=$LG(userObj,5)
	.s wardId=subObj.WardDR,wardDesc=""
	.q:((type=1)&&(input'="")&&($zcvt(userName,"U")'[$zcvt(input,"U")))
	.q:((type=4)&&(subObj.OrderNum'=input))
	.s ExceptionDR="",ExceptionDesc=""
	.s:$IsObject(subObj.ExceptionDR) ExceptionDR=subObj.ExceptionDR.%Id(),ExceptionDesc=subObj.ExceptionDR.SubDesc
	.i ReleaseMode'="O" d //获取考核日期、成绩、考核id、依靠和病区
	..;缺已考核数据信息
	..s ExamDate="",ExamScore="",ExamId="",ExamStatus="D",editFlag=1,AnswerTimes=1,AnslyFlag=""
	..s ExamTimesFlag="Y"
	..s ExamId=$O(^DHCINM.Tea.ExamTheoryI("releaseUser",realeaseRW,userId,""),-1)
	..i ExamId'="" d
	...s examObj=$G(^DHCINM.Tea.ExamTheoryD(ExamId))
	...i examObj'="" d
	....s ExamScore=$LG(examObj,7)
	....s ExamDate=$LG(examObj,5)
	....s:ExamDate'="" ExamDate=$zd(ExamDate,3)
	....s AnswerTimes=$LG(examObj,10)
	....s wardId=$LG(examObj,4)
	....s AnslyFlag=$LG(examObj,11)
	....s:$Lg(examObj,6)'="" ExamTimesFlag="N" ;无总计时长，考试无效
	..;判断状态、编辑状态
	..i ExamStep=2 d ;未开始考核
	...s editFlag="考核未开始",ExamStatus="D"
	..e  i ExamStep=3  d ;考核结束
	...i ExamId="" s editFlag="考核已结束,不可作答",ExamStatus="E"
	...e  d
	....s editFlag="考核已结束,不可查看"
	....i ExamScore<obj.ReleasePass s ExamStatus="B"
	....e  d
	.....i AnswerTimes=1 s ExamStatus="A"
	.....e  d
	......s ExamStatus="C"
	..e  d ;考核中
	...i ExamId="" s editFlag=1,ExamStatus="D"
	...e  d
	....i ExamScore<obj.ReleasePass d
	.....s ExamStatus="B" 
	.....i obj.ReleaseResit'="Y" s editFlag="不可重考" ;判断是否可重考
	.....e  i ((obj.ReleaseResitNum="N")||(AnswerTimes<obj.ReleaseResitNum)) d
	......s editFlag=1
	....e  d
	.....s editFlag="考核已通过,不可查看"
	.....i AnswerTimes=1 s ExamStatus="A"
	.....e  d
	......s ExamStatus="C"
	..i wardId'="" d
	...s wardObj=$g(^CF.DHCINM.DB.MgWardD(wardId))
	...s:wardObj'="" wardDesc=$LG(wardObj,4)
	..s:AnslyFlag="Y" ExamStatus="G",ExamScore=""
	..;s:ExamTimesFlag="N" ExamStatus="H",ExamScore="" ;无效考试是否校验？等待确认
	..q:((type=2)&&(input'="")&&(wardDesc'[input))
	..q:((type=3)&&(input'="")&&(input'=ExamStatus))
	..s:((editFlag=1)&&(ExceptionDR'="")) editFlag="已置异常不可考核"
	..s ret="userName|"_userName_"^userId|"_userId_"^wardId|"_wardId_"^wardDesc|"_wardDesc_"^editFlag|"_editFlag
	..s ret=ret_"^releaseId|"_realeaseRW_"^ReleaseMode|"_ReleaseMode_"^ReleaseDesc|"_ReleaseDesc
	..s ret=ret_"^operaDesc|^operaId|^ExamId|"_ExamId
	..s ret=ret_"^ExamDate|"_ExamDate_"^ExamScore|"_ExamScore_"^ExamStatus|"_ExamStatus_"^Creator|"_obj.Creator
	..s ret=ret_"^ExceptionDesc|"_ExceptionDesc
	..d OutputRowData
	.e  d
	..f rangeIndex=1:1:obj.QuestRange.Count()  d
	...s operaId=obj.QuestRange.GetAt(rangeIndex)
	...q:operaId=""
	...s operaObj=$G(^CF.DHCINM.DB.TeaOperaD(operaId))
	...q:operaObj=""
	...s operaDesc=$LG(operaObj,3)
	...s OperaPass=$LG(operaObj,9)
	...s ExamDate="",ExamScore="",ExamId="",ExamStatus="D",editFlag=1,AnswerTimes=1
	...s ExamId=$O(^DHCINM.Tea.ExamOperaI("User",realeaseRW,operaId,userId,""),-1)
	...i ExamId'="" d
	....s examObj=$G(^DHCINM.Tea.ExamOperaD(ExamId))
	....i examObj'="" d
	.....s ExamScore=$LG(examObj,6)
	.....s ExamDate=$LG(examObj,23)
	.....s:ExamDate'="" ExamDate=$zd(ExamDate,3)
	.....s AnswerTimes=$LG(examObj,22)
	.....s wardId=$LG(examObj,5)
	.....s OperaPass=$LG(examObj,16)
	...s realScore=$tr(ExamScore,"%","")
	...;判断状态、编辑状态
	...i ExamStep=2 d ;未开始考核
	....s editFlag="考核未开始",ExamStatus="D"
	...e  i ExamStep=3  d ;考核结束
	....i ExamId="" s editFlag="考核已结束,不可作答",ExamStatus="E"
	....e  d
	.....s editFlag=1
	.....i realScore<OperaPass s ExamStatus="B"
	.....e  d
	......i AnswerTimes<=1 s ExamStatus="A"
	......e  d
	.......s ExamStatus="C"
	...e  d ;考核中
	....i ExamId="" d ;未考核
	.....s editFlag=1,ExamStatus="D"
	.....i obj.Examiner.Find(loginID)<1 s editFlag="非考官不可评分"
	....e  d
	.....i realScore<OperaPass d ;未通过
	......s ExamStatus="B" 
	......i ((obj.ReleaseResit'="Y")||(AnswerTimes>obj.ReleaseResitNum)) s editFlag="不可重考" ;判断是否可重考
	......e  d ;重考
	.......s editFlag=1
	.......i obj.Examiner.Find(loginID)<1 s editFlag=1
	.....e  d
	......s editFlag=1
	......i AnswerTimes<=1 s ExamStatus="A"
	......e  d
	.......s ExamStatus="C"
	...i wardId'="" d
	....s wardObj=$g(^CF.DHCINM.DB.MgWardD(wardId))
	....s:wardObj'="" wardDesc=$LG(wardObj,4)
	...q:((type=2)&&(input'="")&&(wardDesc'[input))
	...q:((type=3)&&(input'="")&&(input'=ExamStatus))
	...s:((editFlag=1)&&(ExceptionDR'="")) editFlag="已置异常不可考核"
	...s ret="userName|"_userName_"^userId|"_userId_"^wardId|"_wardId_"^wardDesc|"_wardDesc_"^editFlag|"_editFlag
	...s ret=ret_"^releaseId|"_realeaseRW_"^ReleaseMode|"_ReleaseMode_"^ReleaseDesc|"_ReleaseDesc
	...s ret=ret_"^operaDesc|"_operaDesc_"^operaId|"_operaId
	...s ret=ret_"^ExamDate|"_ExamDate_"^ExamScore|"_ExamScore_"^ExamStatus|"_ExamStatus_"^Creator|"_obj.Creator
	...s ret=ret_"^ExceptionDesc|"_ExceptionDesc
	...d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExamListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExamListExecute ]
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

ClassMethod FindExamListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExamListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-19
/// Description:智能选题
/// Input:
/// Output:
/// Other:
ClassMethod SetRandomTmp(size, all, retIdTmp) As %String
{
	s index=1
	if size>=all{
		f i=1:1:all d
		.s retIdTmp(i)=i
	}else{
		do{
			s num=$R(all)+1
			i $O(retIdTmp(""))="" d
			.s retIdTmp(num)=1
			e  i '$d(retIdTmp(num))  d ;不存在此数
			.s retIdTmp(num)=index+1
			.s index=index+1
		}while(index<size)
	}
}

/// Creator:lulin
/// Createdate:2020-07-19
/// Description:智能选题
/// Input:
/// Output:
/// Other:
ClassMethod SetIntellectExamTheoryTmp(retTmp, QuesRange) As %String
{
	k bankTmp,bankNumTmp
	s bankTmp="",bankNumTmp=""
	;答题方式、题型、抽题数、分值、汇总、类型
	f i=1:1:QuesRange.Count() d
	.s rowData=QuesRange.GetAt(i)
	.q:rowData=""
	.s mode=$P(rowData,"」",1)
	.s parID=$P(rowData,"」",6)
	.s parID=$P(parID,",",$l(parID,","))
	.q:((mode="")||(parID=""))
	.s selectNum=+$P(rowData,"」",3) ;抽题数
	.q:selectNum<=0
	.s ExamScore=$P(rowData,"」",4) ;分值
	.s bankNumTmp("S",mode,parID,ExamScore)=$G(bankNumTmp("S",mode,parID,ExamScore))+selectNum ;某一分数多少题
	.s bankNumTmp("N",mode,parID)=$G(bankNumTmp("N",mode,parID))+selectNum ;某一类别多少个
	.s bankNumTmp("T",parID)=parID
	;设置备选题目
	s parID="" f  s parID=$O(bankNumTmp("T",parID)) q:parID=""  d 
	.d SetBackTmp
	s error=""
	s mode="" f  s mode=$O(bankNumTmp("N",mode)) q:((mode="")||(error'=""))  d
	.s parID="" f  s parID=$O(bankNumTmp("N",mode,parID)) q:((parID="")||(error'=""))  d
	..s size=$G(bankNumTmp("N",mode,parID))
	..q:size=0
	..s all=$O(bankTmp(mode,parID,""),-1) ;一共多少备选题
	..s:size>all error="选题总数大于备选数"
	..q:size>all
	..k retIdTmp
	..s retIdTmp=""
	..;选取题目的id数组
	..d ..SetRandomTmp(size,all,.retIdTmp) ;设置随机数数组
	..s tmpIdIndex="",index=0
	..s score="" f  s score=$O(bankNumTmp("S",mode,parID,score))  q:score=""  d
	...s scoreNum=$G(bankNumTmp("S",mode,parID,score))
	...q:scoreNum=""
	...s endNum=index+scoreNum
	...f  s tmpIdIndex=$O(retIdTmp(tmpIdIndex)) q:((tmpIdIndex="")||(index>=endNum))  d
	....s id=$G(bankTmp(mode,parID,tmpIdIndex))
	....s retTmp(id)=score
	....s index=index+1
	q error
SetBackTmp
	s subIndex=0
	s subId="" f  s subId=$O(^CF.DHCINM.DB.TeaTheorySubD(parID,subId)) q:subId=""  d
	.s subObj=$G(^CF.DHCINM.DB.TeaTheorySubD(parID,subId))
	.q:subObj=""
	.s SubStatus=$LG(subObj,12)
	.s subMode=$LG(subObj,4)
	.q:SubStatus'="Y"
	.q:subMode=""
	.s index=$O(bankTmp(subMode,parID,""),-1)
	.s index=index+1
	.s bankTmp(subMode,parID,index)=parID_"||"_subId
	q
}

/// Creator:lulin
/// Createdate:2020-07-17
/// Description:获取理论考试所有题目
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindExamProblemList","2",1)
Query FindExamProblemList(parr As %String = "", UserId As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindExamProblemListExecute(ByRef qHandle As %Binary, parr As %String = "", UserId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",nowDate=+$H
	s releaseRw=$P(parr,"^",1)
	s obj=##class(DHCINM.Tea.ExamRelease).%OpenId(releaseRw)
	i '$IsObject(obj){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s examId=$O(^DHCINM.Tea.ExamTheoryI("releaseUser",releaseRw,UserId,""))
	s AnswerTimes=1
	i examId'="" d
	.s examObj=##class(DHCINM.Tea.ExamTheory).%OpenId(examId)
	.s AnswerTimes=examObj.AnswerTimes+1
	s ReleaseMode=obj.ReleaseMode ;类论:T、应急预案:E
	s ReleaseType=obj.ReleaseType.%Id() ;类型
	s RealPaperType=obj.RealPaperType
	//复考如果是智能非固定考试会再来一份新的试卷
	i RealPaperType="H" d //手动
	.f i=1:1:obj.QuestRange.Count() d
	..s rowData=obj.QuestRange.GetAt(i)
	..q:rowData=""
	..s theorySubId=$P(rowData,"」",2)
	..s theorySubScore=$P(rowData,"」",3)
	..s ret=..GetTheoryProblem(theorySubId,1)
	..s ret=ret_"^GetScore|0"_"^ExamScore|"_theorySubScore_"^ProblemType|T"_"^AnswerTimes|"_AnswerTimes ;problemType:T:理论，E:应急预案
	..d OutputRowData
	e  i obj.ReleaseDraw="Y"  d
	.f i=1:1:obj.QuestRangeI.Count() d
	..s rowData=obj.QuestRangeI.GetAt(i)
	..q:rowData=""
	..s theorySubId=$P(rowData,"」",1)
	..s theorySubScore=$P(rowData,"」",2)
	..s ret=..GetTheoryProblem(theorySubId,1)
	..s ret=ret_"^GetScore|0"_"^ExamScore|"_theorySubScore_"^ProblemType|T"_"^AnswerTimes|"_AnswerTimes
	..d OutputRowData
	e  d //智能
	.s retTmp=""
	.d ..SetIntellectExamTheoryTmp(.retTmp,obj.QuestRange)
	.s id="" f  s id=$O(retTmp(id)) q:id=""  d
	..s ret=..GetTheoryProblem(id,1)
	..s ret=ret_"^GetScore|0"_"^ExamScore|"_retTmp(id)_"^ProblemType|T"_"^AnswerTimes|"_AnswerTimes
	..d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExamProblemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExamProblemListExecute ]
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

ClassMethod FindExamProblemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExamProblemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:更新理论/应急--理论考核用时总分
/// Input:
/// Output:
/// Other:
ClassMethod UpdateExamTheoryTimeScore(rw, ExamTime) As %String
{
	s obj=##class(DHCINM.Tea.ExamTheory).%OpenId(rw)
	s ExamScore=0 
	s subId="" f  s subId=$O(^DHCINM.Tea.ExamTheorySubD(rw,subId)) q:subId=""  d
	.s subObj=##class(DHCINM.Tea.ExamTheorySub).%OpenId(rw_"||"_subId)
	.q:'$IsObject(subObj)
	.s:obj.AnswerTimes=subObj.AnswerTimes ExamScore=ExamScore+subObj.GetScore
	s emrId="" f  s emrId=$O(^DHCINM.Tea.ExamTheoryEmrD(rw,emrId)) q:emrId=""  d
	.s emrObj=##class(DHCINM.Tea.ExamTheoryEmr).%OpenId(rw_"||"_emrId)
	.q:'$IsObject(emrObj)
	.s ExamScore=ExamScore+emrObj.GetScore
	s obj.ExamScore=$fn(ExamScore,"",2)
	s obj.ExamAutoScore=$fn(ExamScore,"",2)
	s obj.ExamTime=ExamTime
	i ((obj.Anslyor'="")&&(obj.ReleaseDR.Markor'="")) d
	.s Marktor=obj.ReleaseDR.Markor
	.s allNum=0,index=0,tUserFlag=0
	.s releaseSubID="" f  s releaseSubID=$O(^DHCINM.Tea.ExamReleaseSubD(obj.ReleaseDR.%Id(),releaseSubID)) q:releaseSubID=""  d
	..s releaseSubObj=$g(^DHCINM.Tea.ExamReleaseSubD(obj.ReleaseDR.%Id(),releaseSubID))
	..q:releaseSubObj=""
	..s userId=$lg(releaseSubObj,2)
	..i userId=obj.UserDR.%Id() d
	....s tUserFlag=1
	..s:tUserFlag'=1 index=index+1
	..s allNum=allNum+1
	.s:allNum=0 allNum=1
	.s weight=index/allNum
	.s startWeight=0,Anslyor=""
	.f i=1:1:$L(Marktor,"「") q:Anslyor'=""  d
	..s marktorObj=$P(Marktor,"「",i)
	..s marktorRW=$P(marktorObj,"」",1)
	..s marktorWeight=$P(marktorObj,"」",2)
	..q:marktorWeight=""
	..s tWeight=startWeight+marktorWeight
	..i ((weight>=startWeight)&&(weight<=tWeight)) d
	...s Anslyor=marktorRW
	.s obj.Anslyor=Anslyor
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存理论/应急--理论考核--应急考核也可以考虑写在这里
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveExamTheory("rw|1||1^subRw|7||1^Result|0^ExamTime|14^UserDR|1^ReleaseDR|4^WardDR|1^ExamScore|5^ProblemType|T")
ClassMethod SaveExamTheory(parr As %String) As %String
{
	q:parr="" "0^入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s subRw=$g(tmp("subRw"))
	s subObj=##class(CF.DHCINM.DB.TeaTheorySub).%OpenId(subRw)
	q:'$IsObject(subObj) "0^获取题型数据失败"
	s ReleaseDR=$g(tmp("ReleaseDR"))
	s ReleaseObj=##class(DHCINM.Tea.ExamRelease).%OpenId(ReleaseDR)
	q:'$IsObject(ReleaseObj) "0^获取考核发布数据失败"
	s UserDR=$g(tmp("UserDR"))
	s UserObj=##class(CF.DHCINM.DB.MgUser).%OpenId(UserDR)
	q:'$IsObject(UserObj) "0^获取考生信息失败"
	s examId=$O(^DHCINM.Tea.ExamTheoryI("releaseUser",ReleaseDR,UserDR,""))
	i examId="" d
	.s examObj=##class(DHCINM.Tea.ExamTheory).%New()
	.s examObj.ReleaseDR=ReleaseObj
	.s examObj.UserDR=UserObj
	.s examObj.WardDR=$G(tmp("WardDR"))
	.s examObj.ReleaseMode=ReleaseObj.ReleaseMode
	.s examObj.ReleaseType=ReleaseObj.ReleaseType
	e  d
	.s examObj=##class(DHCINM.Tea.ExamTheory).%OpenId(examId)
	s examObj.ExamDate=+$H
	s examObj.AnswerTimes=$g(tmp("AnswerTimes"))
	s:subObj.SubMode="A" examObj.AnslyFlag="Y" ;问答题未阅卷
	TS
	s flag=$$$ISOK(examObj.%Save())
	i flag'=1{
		TRO
		q "0^保存考核主表失败"	
	}
	i rw="" d
	.s obj=##class(DHCINM.Tea.ExamTheorySub).%New()
	.s obj.Parref=examObj
	.s obj.AnswerTimes=$g(tmp("AnswerTimes"))
	e  d
	.s obj=##class(DHCINM.Tea.ExamTheorySub).%OpenId(rw)
	s obj.ExamSubDR=subObj
	s obj.SubDesc=subObj.SubDesc
	s obj.SubUrl=subObj.SubUrl
	s obj.SubMode=subObj.SubMode
	s obj.ExamTime=$G(tmp("ExamTime"))
	s obj.SubTypeDR=subObj.SubTypeDR
	s obj.SubOption=subObj.SubOption
	s obj.SubAnswer=subObj.SubAnswer
	s obj.SubSource=subObj.SubSource
	s obj.SubAnalysis=subObj.SubAnalysis
	s obj.Result=$g(tmp("Result"))
	s obj.ExamScore=$g(tmp("ExamScore"))
	s obj.AnslyFlag="Y"
	i obj.SubMode'="A" d
	.s obj.CorrectFlag=..IsCurrect(obj.Result,subObj)
	.s obj.GetScore=obj.ExamScore*obj.CorrectFlag
	s flag=flag&&$$$ISOK(obj.%Save())
	i flag {
		TC
		q "1^"_obj.%Id()_"^"_obj.CorrectFlag
	}else{
		q "0^保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:获取技操打分明细
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).GetOperationCheck(6,2,1)
ClassMethod GetOperationCheck(releaseId As %String = "", operaId As %String = "", UserID As %String = "") As %String
{
	s ^tmp("LL")=releaseId_"%"_operaId_"%"_UserID
	q:(releaseId="")||(operaId="")||(UserID="") ""
	s now=+$h
	s releaseObj=##class(DHCINM.Tea.ExamRelease).%OpenId(releaseId)
	q:'$IsObject(releaseObj) ""
	s operaObj=##class(CF.DHCINM.DB.TeaOpera).%OpenId(operaId)
	q:'$IsObject(operaObj) ""
	s Remark=""
	s examId=$O(^DHCINM.Tea.ExamOperaI("User",releaseId,operaId,UserID,""),-1)
	s examOpera=##class(DHCINM.Tea.ExamOpera).%OpenId(examId)
	s CheckStatus="未保存"
	w "{"
	i '$IsObject(examOpera) d
	.k @"tmp",tmpLeaf,tmpAll
	.;循环所有子表赋值到临时数组
	.s subId="" f  s subId=$o(^CF.DHCINM.DB.TeaOperaSubD(operaId,subId)) q:subId=""  d
	..s subObj=$g(^CF.DHCINM.DB.TeaOperaSubD(operaId,subId))
	..q:subObj=""
	..s startDate=$lg(subObj,7)
	..s endDate=$lg(subObj,8)
	..q:(startDate>now)||((endDate'="")&&(endDate<now))
	..s subSort=$lg(subObj,6)
	..q:subSort=""
	..s @("tmpAll("_$tr(subSort,".",",")_")")=operaId_"||"_subId
	..s:'$d(^CF.DHCINM.DB.TeaOperaSubI("par",operaId," "_operaId_"||"_subId)) tmpLeaf(subSort)=operaId_"||"_subId ;叶子节点
	.s deepth=1
	.s subId="" f  s subId=$o(^CF.DHCINM.DB.TeaOperaSubD(operaId,subId)) q:subId=""  d
	..s subObj=$g(^CF.DHCINM.DB.TeaOperaSubD(operaId,subId))
	..s startDate=$lg(subObj,7)
	..s endDate=$lg(subObj,8)
	..q:(startDate>now)||((endDate'="")&&(endDate<now))
	..s subSort=$lg(subObj,6)
	..q:subSort=""
	..s:$l(subSort,".")>deepth deepth=$l(subSort,".")
	..s flag=1
	..s subPar=$lg(subObj,5) 
	..i subPar'="" d ;存在父节点，但父节点信息不符合则抛出
	...s subParId1=$p(subPar,"||")
	...s subParId2=$p(subPar,"||",2)
	...s subParObj=$g(^CF.DHCINM.DB.TeaOperaSubD(subParId1,subParId2))
	...i subParObj="" s flag=0
	...e  d
	....s parStartDate=$lg(subParObj,7)
	....s parEndDate=$lg(subParObj,8)
	....s parSubSort=$lg(subParObj,6)
	....s:((parStartDate>now)||((parEndDate'="")&&(parEndDate<now))||(parSubSort="")) flag=0
	..q:flag'=1
	..s hasChild=0
	..i $d(^CF.DHCINM.DB.TeaOperaSubI("par",operaId," "_operaId_"||"_subId)) d
	...s hasChild=1
	..s score=""
	..s:((operaObj.OperaMode'="A")&&(operaObj.OperaMode'="B")) score=$lg(subObj,4)
	..s ItemScore=score
	..s:operaObj.OperaMode="F" ItemScore=""
	..s SubStand=""
	..i operaObj.OperaMode="A" s SubStand="是」√」el-icon-circle-check「否」×」el-icon-circle-close「不适用」-」el-icon-warning-outline"
	..e  i operaObj.OperaMode="B" s SubStand="符合」」el-icon-circle-check「部分符合」」el-icon-remove-outline「不符合」」el-icon-circle-close「不适用」-」el-icon-warning-outline"
	..e  i (operaObj.OperaMode="E")&&(operaObj.OperaStandType="A") d
	...s SubStand=""
	...f standIndex=1:1:operaObj.OperaStand.Count() d
	....s rowData=operaObj.OperaStand.GetAt(standIndex)
	....q:rowData=""
	....i SubStand="" s SubStand=rowData
	....e  s SubStand=SubStand_"「"_rowData
	..e  i (((operaObj.OperaMode="E")&&(operaObj.OperaStandType'="A"))||(operaObj.OperaMode="F")) d
	...s SubStandLB=$lg(subObj,9),SubStand=""
	...f standIndex=1:1:$LL(SubStandLB) d
	....s rowData=$LG(SubStandLB,standIndex)
	....q:rowData=""
	....i SubStand="" s SubStand=rowData
	....e  s SubStand=SubStand_"「"_rowData
	..i hasChild=0 s rowSpan=1 ;无叶子
	..e  d
	...s rowSpan=0,tmpLeafSort="" f  s tmpLeafSort=$o(tmpLeaf(tmpLeafSort)) q:tmpLeafSort=""  d ;合并多少行
	....s:$e(tmpLeafSort,1,$l(subSort))=subSort rowSpan=rowSpan+1
	..s tmpRoot="",rootLen=$l(subSort,".") ;第一层节点至叶子节点路径数组
	..i rootLen>1 d
	...f rootIndex=1:1:rootLen d
	....i tmpRoot="" s tmpRoot=""""_$p(subSort,".",1,rootIndex)_""""
	....e  s tmpRoot=tmpRoot_","""_$p(subSort,".",1,rootIndex)_""""
	..s roots="["_tmpRoot_"]"
	..i (subPar'="")&&($o(@("tmpAll("_$tr(parSubSort,".",",")_")")@(""))=$p(subSort,".",$L(subSort,"."))) s fatherShow=1
	..e  s fatherShow=0
	..s ret="{""SubItem"":"""_$lg(subObj,2)_""",""HasChild"":"""_hasChild_""",""SubId"":"""_operaId_"||"_subId_""",""SubSort"":"""_subSort_""""
	..s ret=ret_",""SubScore"":"""_score_""",""CheckMenu"":"""_SubStand_""",""ResultSubId"":"""",""RowSpan"":"""_rowSpan_""""
	..s ret=ret_",""FatherId"":"""_subPar_""",""Roots"":"_roots_",""FatherShow"":"""_fatherShow_""",""ItemScore"":"""_ItemScore_""",""Remark"":""""},"
	..s @("tmp("_$tr(subSort,".",",")_")")=ret
	.w """operaId"":"""_operaId_""",""OperaMode"":"""_operaObj.OperaMode_""",""ExamId"":"""""
	.w ",""CheckStatus"":"""_CheckStatus_""",""Remark"":"""_Remark_""""
	.w ",""OperaStandType"":"""_operaObj.OperaStandType_""",""Deepth"":"""_deepth_""",""SubItems"":["
	.s queryString=$q(@"tmp"@("")) ;遍历到第一个节点 
	.s:$q(@"tmp"@(""),-1)=queryString @queryString=$e(@queryString,1,*-1) ;最后一行将最后一个,去掉
	.w @queryString ;输出第一个节点数据
	.f  s queryString=$q(@queryString) q:queryString=""  d ;遍历循环数组输出
	..s:$q(@"tmp"@(""),-1)=queryString @queryString=$e(@queryString,1,*-1) ;最后一行将最后一个,去掉
	..w @queryString
	.w "]"
	e  d
	.s CheckStatus=$case(examOpera.CheckStatus,"S":"已提交","N":"未提交",:"未保存")
	.s Remark=examOpera.CheckRemark
	.k @"tmp",tmpLeaf,tmpAll
	.;循环所有子表赋值到临时数组
	.s subId="" f  s subId=$o(^DHCINM.Tea.ExamOperaSubD(examId,subId)) q:subId=""  d
	..s subObj=$g(^DHCINM.Tea.ExamOperaSubD(examId,subId))
	..q:subObj=""
	..s subSort=$lg(subObj,9)
	..q:subSort=""
	..s @("tmpAll("_$tr(subSort,".",",")_")")=examId_"||"_subId
	..s:'$d(^DHCINM.Tea.ExamOperaSubI("Par",examId_"||"_subId,examId)) tmpLeaf(subSort)=examId_"||"_subId ;叶子节点
	.s deepth=1
	.s subId="" f  s subId=$o(^DHCINM.Tea.ExamOperaSubD(examId,subId)) q:subId=""  d
	..s subObj=$g(^DHCINM.Tea.ExamOperaSubD(examId,subId))
	..s subSort=$lg(subObj,9)
	..q:subSort=""
	..s:$l(subSort,".")>deepth deepth=$l(subSort,".")
	..s flag=1
	..s subPar=$lg(subObj,8) 
	..i subPar'="" d ;存在父节点，但父节点信息不符合则抛出
	...s subParId1=$p(subPar,"||")
	...s subParId2=$p(subPar,"||",2)
	...s subParObj=$g(^DHCINM.Tea.ExamOperaSubD(subParId1,subParId2))
	...i subParObj="" s flag=0
	...e  d
	....s parSubSort=$lg(subParObj,9)
	....s:(parSubSort="") flag=0
	..q:flag'=1
	..s hasChild=0
	..i $d(^DHCINM.Tea.ExamOperaSubI("Par",examId_"||"_subId,examId)) d
	...s hasChild=1
	..s score=""
	..s:((examOpera.OperaMode'="A")&&(examOpera.OperaMode'="B")) score=$lg(subObj,5)
	..s ItemScore=$LG(subObj,3)
	..s SubStand=""
	..i examOpera.OperaMode="A" s SubStand="是」√」el-icon-circle-check「否」×」el-icon-circle-close「不适用」-」el-icon-warning-outline"
	..e  i examOpera.OperaMode="B" s SubStand="符合」」el-icon-circle-check「部分符合」」el-icon-remove-outline「不符合」」el-icon-circle-close「不适用」-」el-icon-warning-outline"
	..e  i (examOpera.OperaMode="E")&&(examOpera.OperaStandType="A") d
	...s SubStand=""
	...f standIndex=1:1:examOpera.OperaStand.Count() d
	....s rowData=examOpera.OperaStand.GetAt(standIndex)
	....q:rowData=""
	....i SubStand="" s SubStand=rowData
	....e  s SubStand=SubStand_"「"_rowData
	..e  i (((examOpera.OperaMode="E")&&(examOpera.OperaStandType'="A"))||(examOpera.OperaMode="F")) d
	...s SubStandLB=$lg(subObj,10),SubStand=""
	...f standIndex=1:1:$LL(SubStandLB) d
	....s rowData=$LG(SubStandLB,standIndex)
	....q:rowData=""
	....i SubStand="" s SubStand=rowData
	....e  s SubStand=SubStand_"「"_rowData
	..i hasChild=0 s rowSpan=1 ;无叶子
	..e  d
	...s rowSpan=0,tmpLeafSort="" f  s tmpLeafSort=$o(tmpLeaf(tmpLeafSort)) q:tmpLeafSort=""  d ;合并多少行
	....s:$e(tmpLeafSort,1,$l(subSort))=subSort rowSpan=rowSpan+1
	..s tmpRoot="",rootLen=$l(subSort,".") ;第一层节点至叶子节点路径数组
	..i rootLen>1 d
	...f rootIndex=1:1:rootLen d
	....i tmpRoot="" s tmpRoot=""""_$p(subSort,".",1,rootIndex)_""""
	....e  s tmpRoot=tmpRoot_","""_$p(subSort,".",1,rootIndex)_""""
	..s roots="["_tmpRoot_"]"
	..i (subPar'="")&&($o(@("tmpAll("_$tr(parSubSort,".",",")_")")@(""))=$p(subSort,".",$L(subSort,"."))) s fatherShow=1
	..e  s fatherShow=0
	..s ret="{""SubItem"":"""_$lg(subObj,2)_""",""HasChild"":"""_hasChild_""",""SubId"":"""_$lg(subObj,7)_""",""SubSort"":"""_subSort_""""
	..s ret=ret_",""SubScore"":"""_score_""",""CheckMenu"":"""_SubStand_""",""ResultSubId"":"""_examId_"||"_subId_""",""RowSpan"":"""_rowSpan_""""
	..s ret=ret_",""FatherId"":"""_subPar_""",""Roots"":"_roots_",""FatherShow"":"""_fatherShow_""",""ItemScore"":"""_ItemScore
	..s ret=ret_""",""Remark"":"""_$lg(subObj,6)_"""},"
	..s @("tmp("_$tr(subSort,".",",")_")")=ret
	.w """operaId"":"""_operaId_""",""OperaMode"":"""_operaObj.OperaMode_""",""ExamId"":"""_examId_""""
	.w ",""CheckStatus"":"""_CheckStatus_""",""Remark"":"""_Remark_""""
	.w ",""OperaStandType"":"""_examOpera.OperaStandType_""",""Deepth"":"""_deepth_""",""SubItems"":["
	.s queryString=$q(@"tmp"@("")) ;遍历到第一个节点 
	.s:$q(@"tmp"@(""),-1)=queryString @queryString=$e(@queryString,1,*-1) ;最后一行将最后一个,去掉
	.w @queryString ;输出第一个节点数据
	.f  s queryString=$q(@queryString) q:queryString=""  d ;遍历循环数组输出
	..s:$q(@"tmp"@(""),-1)=queryString @queryString=$e(@queryString,1,*-1) ;最后一行将最后一个,去掉
	..w @queryString
	.w "]"
	
	w "}"
	q ""
}

/// Creator:lulin
/// Createdate:2020-07-23
/// Description:保存技操打分明细
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveOperationCheck(^TMP("SaveOperationCheck","parr"),^TMP("SaveOperationCheck","table"),0)
ClassMethod SaveOperationCheck(parr As %String = "", table As %String = "", loginID As %String = "") As %String
{
	s ^TMP("SaveOperationCheck","parr")=parr
	s ^TMP("SaveOperationCheck","table")=table
	q:(parr="")||(table="")||(loginID="") 0
	q:(loginID'=0)&&('$d(^CF.DHCINM.DB.MgUserD(loginID))) 0
	//this.userId+'^'+this.releaseId+'^'+this.operaId+'^'+this.WardDR+'^'+this.CheckInfo.CheckDate.Format('YYYY-MM-dd');
	//parr+'^'+this.CheckInfo.CheckScore+'^'+status+'^'+this.CheckInfo.Remark+'^'+this.ExamId;
	s userId=$p(parr,"^",1)
	s releaseId=$p(parr,"^",2)
	s operaId=$p(parr,"^",3)
	s WardDR=$p(parr,"^",4)
	s CheckDate=$p(parr,"^",5)
	s:CheckDate["-" CheckDate=$zdh(CheckDate,3)
	s CheckScore=$p(parr,"^",6)
	s status=$p(parr,"^",7)
	s Remark=$p(parr,"^",8)
	s ExamId=$p(parr,"^",9)
	s AnswerTimes=1
	s releaseObj=##class(DHCINM.Tea.ExamRelease).%OpenId(releaseId)
	q:'$IsObject(releaseObj) "未获取考核发布信息,请刷新重试"
	s operaObj=##class(CF.DHCINM.DB.TeaOpera).%OpenId(operaId)
	q:'$IsObject(operaObj) "未获取技操项目维护信息,请刷新重试"
	s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(userId)
	q:'$IsObject(operaObj) "未获取考生信息,请刷新重试"
	s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(WardDR)
	q:'$IsObject(operaObj) "未获取病区信息,请刷新重试"
	s flag=1,now=$h
	i ExamId="" d
	.s beforId=$O(^DHCINM.Tea.ExamOperaI("User",releaseId,operaId,userId,""),-1)
	.i beforId'="" d
	..s beforObj=##class(DHCINM.Tea.ExamOpera).%OpenId(beforId)
	..s:$IsObject(beforObj) AnswerTimes=beforObj.AnswerTimes+1
	.s obj=##class(DHCINM.Tea.ExamOpera).%New()
	.s obj.UserDR=userObj
	.s obj.ReleaseDR=releaseObj
	.s obj.CheckItem=operaObj
	.s obj.CheckWard=wardObj
	.s obj.OperaType=operaObj.OperaType
	.s obj.OperaDesc=operaObj.OperaDesc
	.s obj.OperaMode=operaObj.OperaMode
	.s obj.OperaStandType=operaObj.OperaStandType
	.s obj.OperaStand=operaObj.OperaStand
	.s obj.OperaResult=operaObj.OperaResult
	.s obj.OperaScore=operaObj.OperaScore
	.s obj.OperaPass=operaObj.OperaPass
	.s obj.CreateUser=loginID
	.s obj.CreateDate=+$H
	.s obj.CreateTime=$P($H,",",1)
	.s obj.AnswerTimes=AnswerTimes
	e  s obj=##class(DHCINM.Tea.ExamOpera).%OpenId(ExamId)
	s obj.CheckScore=CheckScore
	s obj.CheckStatus=status
	s obj.CheckUser=loginID
	s obj.CheckRemark=Remark
	s:status="S" obj.SubmitDate=+now,obj.SubmitTime=$p(now,",",2)
	s obj.CheckDate=CheckDate
	TS
	s flag=1
	s flag=flag&&$$$ISOK(obj.%Save())
	i flag'=1{
		TRO
		q "保存失败"	
	}
	s len=$l(table,"ˇ")
	f i=1:1:len q:flag'=1  d
	.s tparr=$p(table,"ˇ",i)
	.q:tparr=""
	.s SubId=$p(tparr,"^",1)
	.s score=$p(tparr,"^",2)
	.s ResultSubId=$p(tparr,"^",3)
	.s subId1=$p(SubId,"||")
	.s subId2=$p(SubId,"||",2)
	.s subObj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(SubId)
	.q:'$IsObject(subObj)
	.s Remark=$p(tparr,"^",4)
	.s subParObj="",subFlag=1
	.i $l(subObj.SubSort,".")>=2 d
	..s parSort=$e(subObj.SubSort,1,$L(subObj.SubSort,".")-$l($p(subObj.SubSort,".",$L(subObj.SubSort,"."))))
	..s parId=$o(^DHCINM.Tea.ExamOperaSubI("Sort",obj.%Id()," "_parSort,""))
	..s subParObj=##class(DHCINM.Tea.ExamOperaSub).%OpenId(obj.%Id()_"||"_parId)
	..s:'$IsObject(subParObj) subFlag=0
	.q:subFlag=0
	.i ResultSubId="" d
	..s resultSubObj=##class(DHCINM.Tea.ExamOperaSub).%New()
	..s resultSubObj.Parref=obj
	..s resultSubObj.SubDesc=subObj.SubDesc
	..s resultSubObj.SubStandardScore=subObj.SubScore
	..s resultSubObj.SubStandard=subObj.SubStandard
	..s resultSubObj.SubReference=subObj
	..s resultSubObj.SubSort=subObj.SubSort
	..s resultSubObj.SubStand=subObj.SubStand
	..s resultSubObj.SubPar=subParObj
	.e  d
	..s resultSubObj=##class(DHCINM.Tea.ExamOperaSub).%OpenId(ResultSubId)
	.q:'$IsObject(resultSubObj)
	.s resultSubObj.SubScore=score
	.s resultSubObj.SubRemark=Remark
	.s sc=resultSubObj.%Save()
	.s:$$$ISERR(sc) flag=0
	if flag=1 {
		TC
		q obj.%Id()	
	}else{
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-07-24
/// Description:保存应急预案演练列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","EmrplanTest",0)
ClassMethod SaveEmrplanTest(parr, loginID) As %String
{
	s ^TMP("SaveEmrplanTest")=parr
	q:parr="" "入参为空"
	k tmp
	s tmp=""
	s nowDate=+$H,nowTime=$P($H,",",2)
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	i rw="" d
	.s obj=##class(DHCINM.Tea.EmrPlanTest).%New()
	.s obj.CreatDate=nowDate
	.s obj.Creator=loginID
	e  s obj=##class(DHCINM.Tea.EmrPlanTest).%OpenId(rw)
	s Status=$G(tmp("Status"))
	s oldStatus=obj.Status
	s isNurHead=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"nurhead",+$H)
	s isZNurHead=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"znurhead",+$H)
	s errorRet=""
	i Status="N" d
	.i ((oldStatus'="N")&&(oldStatus'="")) s errorRet="已提交,不可修改"
	.i (loginID'=obj.Creator) s errorRet="非本人不可修改"
	e  i Status="S" d
	.s:((oldStatus'="N")&&(oldStatus'="")) errorRet="不可重复提交"
	.s:(loginID'=obj.Creator) errorRet="非本人不可提交"
	e  i Status="H" d
	.s:(oldStatus'="S") errorRet="非已提交状态,不可评价"
	.s:(isNurHead'=1) errorRet="非护士长不可进行评价"
	e  i Status="L" d
	.s:(oldStatus'="H") errorRet="非护士长已评价，不可评价"
	.s:(isZNurHead'=1) errorRet="非大科护士长不可进行评价"
	q:errorRet'="" errorRet
	//根据状态判断是否可保存
	s className="DHCINM.Tea.EmrPlanTest"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:((Status="H")&&(p'="HeadEvaluate")) ;护士长评价只保存评价
	.q:((Status="L")&&(p'="Shortage")&&(p'="TestImprove")) ;护士长评价只保存评价
	.i $D(tmp(p)) d
	..s value=tmp(p)
	..s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	..i ((ptype="date")&&(value'="")) d
	...s value=$zdh(value,3)
	..s $ZOBJPROPERTY(obj,p)=value
	s obj.Status=Status
	s:Status="S" obj.SubmitDate=nowDate,obj.SubmitTime=nowTime
	s:Status="H" obj.HeadDate=nowDate,obj.HeadTime=nowTime,obj.HeadNurse=loginID
	s:Status="L" obj.ZHeadDate=nowDate,obj.ZHeadTime=nowTime,obj.ZHeadNurse=loginID
	s sc=obj.%Save()
	try{
		i (obj.Status="L") d
		.s Status=$case(obj.Status,"L":"科护士长评价") ;状态描述
		.s TestDate=obj.TestDate
		.s:TestDate'="" TestDate=$zd(TestDate,3)
		.s TestPlace=obj.TestPlace
		.s TestDesc=obj.TestDesc
		.s userID=obj.Creator
		.s ret="【教学/应急预案演练】"_Status_" "_TestDate_" "_TestPlace_" "_TestDesc
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.Tea.EmrPlanTest",rw)
	}catch{
		}
	q:$$$ISOK(sc) obj.%Id()
    q:$$$ISERR(sc) 0
}

/// Creator:lulin
/// Createdate:2020-07-24
/// Description:删除应急预案演练
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","DeleteEmrplanTest",1,0)
ClassMethod DeleteEmrplanTest(rw, loginID) As %String
{
	s obj=##class(DHCINM.Tea.EmrPlanTest).%OpenId(rw)
	q:'$IsObject(obj) "未发现记录信息,请刷新重试"
	q:obj.Status'="N" "非未提交状态不可删除"
	q:obj.Creator'=loginID "非创建者不可删除"
	d obj.%DeleteId(rw)
	q 1
}

/// Creator:lulin
/// Createdate:2020-07-24
/// Description:获取应急预案演练
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","GetEmrplanTest",0)
ClassMethod GetEmrplanTest(rw) As %String
{
	s obj=##class(DHCINM.Tea.EmrPlanTest).%OpenId(rw)
	s Status=obj.Status
	s ret="rw|"_rw
	s className="DHCINM.Tea.EmrPlanTest"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.s value=$ZOBJPROPERTY(obj,p)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.i ((ptype="time")&&(value'="")) d
	..s value=$zt(value)
	.s ret=ret_"^"_p_"|"_value
	s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.TestWard)
	s wardDesc=""
	i $IsObject(wardObj) d
	.s wardDesc=wardObj.WardDesc
	s userDesc="",HeadNurseDesc="",ZHeadNurseDesc=""
	;负责人
	i obj.Creator=0 s userDesc="管理员"
	e  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.Creator)
	.s:$IsObject(userObj) userDesc=userObj.UserName 
	;护士长
	i obj.HeadNurse=0 s userDesc="管理员"
	e  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.HeadNurse)
	.s:$IsObject(userObj) HeadNurseDesc=userObj.UserName 
	;科护士长
	i obj.ZHeadNurse=0 s ZHeadNurseDesc="管理员"
	e  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.ZHeadNurse)
	.s:$IsObject(userObj) ZHeadNurseDesc=userObj.UserName 
	s ret=ret_"^wardDesc|"_wardDesc_"^userDesc|"_userDesc_"^HeadNurseDesc|"_HeadNurseDesc_"^ZHeadNurseDesc|"_ZHeadNurseDesc
	s StatusDesc=$case(obj.Status,"N":"未提交","S":"已提交","H":"护士长已评价","L":"科护士长已评价",:obj.Status)
	s activeStep=$case(obj.Status,"N":1,"S":1,"H":2,"L":3,:1)
	s ret=ret_"^StatusDesc|"_StatusDesc_"^activeStep|"_activeStep
	q ret
}

/// Creator:lulin
/// Createdate:2020-07-24
/// Description:获取应急预案演练列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindEmrplanTest","",0)
Query FindEmrplanTest(parr As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindEmrplanTestExecute(ByRef qHandle As %Binary, parr As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s Ward=$P(parr,"^",1)
	s StartDate=$P(parr,"^",2)
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s EndDate=$P(parr,"^",3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	//护士长看已提交&科护士长已评&自己创建
	//科护士长看护士长已评&科护士长已评&自己创建
	s isNurHead=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"nurhead",+$H)
	s isZNurHead=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"znurhead",+$H)
	s date="" f  s date=$O(^DHCINM.Tea.EmrPlanTestI("Ward",date)) q:date=""  d
	.q:((StartDate'="")&&(StartDate>date))
	.q:((EndDate'="")&&(EndDate<date))
	.s wardDR="" f  s wardDR=$O(^DHCINM.Tea.EmrPlanTestI("Ward",date,wardDR)) q:wardDR=""  d
	..q:((Ward'="")&&(Ward'=wardDR))
	..s rw="" f  s rw=$O(^DHCINM.Tea.EmrPlanTestI("Ward",date,wardDR,rw)) q:rw=""  d
	...s objLB=$G(^DHCINM.Tea.EmrPlanTestD(rw))
	...q:objLB=""
	...s Status=$LG(objLB,14)
	...s creator=$LG(objLB,10)
	...q:((Status="N")&&(loginID'=creator))
	...q:((isNurHead=1)&&(loginID'=creator)&&(Status'="S")&&(Status'="L"))
	...q:((isZNurHead=1)&&(loginID'=creator)&&(Status'="H")&&(Status'="L"))
	...s ret=..GetEmrplanTest(rw)
	...d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEmrplanTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEmrplanTestExecute ]
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

ClassMethod FindEmrplanTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEmrplanTestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-28
/// Description:保存学习资料库信息
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveLearnData(^TMP("SaveLearnData"),0)
ClassMethod SaveLearnData(parr, loginID) As %String
{
	s ^TMP("SaveLearnData")=parr
	q:parr="" "入参为空"
	k tmp
	s tmp=""
	s nowDate=+$H,nowTime=$P($H,",",2)
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	i rw="" d
	.s obj=##class(DHCINM.Tea.LearnData).%New()
	.s obj.CreateDate=nowDate
	.s obj.Creator=loginID
	.s obj.CreateTime=nowTime
	e  s obj=##class(DHCINM.Tea.LearnData).%OpenId(rw)
	s Status=$G(tmp("Status"))
	s oldStatus=obj.Status
	s errorRet=""
	i Status="N" d
	.i ((oldStatus'="N")&&(oldStatus'="")) s errorRet="已提交,不可修改"
	.i (loginID'=obj.Creator) s errorRet="非本人不可修改"
	e  i Status="S" d
	.s:((oldStatus'="N")&&(oldStatus'="")) errorRet="不可重复提交"
	.s:(loginID'=obj.Creator) errorRet="非本人不可提交"
	//根据状态判断是否可保存
	s className="DHCINM.Tea.LearnData"
	s customKey=$LB("MaterialType")
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.i $D(tmp(p)) d
	..s value=tmp(p)
	..s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	..i ((ptype="date")&&(value'="")) d
	...s value=$zdh(value,3)
	..s $ZOBJPROPERTY(obj,p)=value
	s codeSubobj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId($g(tmp("MaterialType")))
	s obj.MaterialType=codeSubobj
	s obj.Status=Status
	s obj.UploadNum=0
	d obj.%Save()
	q obj.%Id()
}

/// Creator:lulin
/// Createdate:2020-07-28
/// Description:审核学习资料库
/// Input:
/// Output:
/// Other:
ClassMethod ApplyLearnData(rws, loginID) As %String
{
	s nowDate=+$H,nowTime=$P($H,",",2)
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"hlb",+$H)
	q:isHLB'=1 "非护理部不可审核"
	f i=1:1:$L(rws,"^") d
	.s rw=$P(rws,"^",i)
	.s obj=##class(DHCINM.Tea.LearnData).%OpenId(rw)
	.q:'$IsObject(obj)
	.q:obj.Status'="S"
	.s obj.Status="Y"
	.s obj.SubmitDate=nowDate
	.s obj.Submitor=loginID
	.s obj.SubmitTime=nowTime
	.d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2020-06-18
/// Description:保存教学资料库文件
/// Input:
/// Output:
/// Other:
ClassMethod SaveLearnDataUrl(parr As %String) As %String
{
	
	s rw=$P(parr,"^",1)
	s url=$tr($p(parr,"^",2)," ","")
	s obj=##class(DHCINM.Tea.LearnData).%OpenId(rw)
	q:'$IsObject(obj) "0"
#;	f i=1:1:$L(url,",") d
#;	.s itm=$P(url,",",i)
#;	.q:itm=""
	d obj.MaterialUrl.Insert(url)
	s sc=obj.%Save()
	i $$$ISOK(sc){
		q 1	
	}else{
		q 0
	}
}

/// Creator:lulin
/// Createdate:2020-07-28
/// Description:删除教学资料库文件
/// Input:
/// Output:
/// Other:
ClassMethod DeleteLearnDataUrl(parr As %String) As %String
{
	s id=$p(parr,"^")
	s url=$tr($p(parr,"^",2)," ","")
	s obj=##class(DHCINM.Tea.LearnData).%OpenId(id)
	q:'$IsObject(obj) "0"
	s newRefer=""
	d obj.MaterialUrl.RemoveAt(obj.MaterialUrl.Find(url))
	s sc=obj.%Save()
	i $$$ISOK(sc){
		q 1	
	}else{
		q 0
	}
}

/// Creator:lulin
/// Createdate:2020-07-28
/// Description:删除学习资料库信息
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","DeleteLearnData","1^3^4^5^6",0)
ClassMethod DeleteLearnData(rws, loginID) As %String
{
	s ret=""
	f i=1:1:$L(rws,"^") d
	.s rw=$P(rws,"^",i)
	.s obj=##class(DHCINM.Tea.LearnData).%OpenId(rw)
	.q:'$IsObject(obj)
	.q:obj.Status'="N"
	.d obj.%DeleteId(rw)
	.i ret="" s ret=rw
	.e  d
	..s ret=ret_"^"_rw
	q ret
}

/// Creator:lulin
/// Createdate:2020-07-28
/// Description:获取学习资料库信息
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","GetLearnData",0)
ClassMethod GetLearnData(rw) As %String
{
	s obj=##class(DHCINM.Tea.LearnData).%OpenId(rw)
	s Status=obj.Status
	s ret="rw|"_rw
	s className="DHCINM.Tea.LearnData"
	s customKey=$LB("MaterialType","MaterialUrl")
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.s value=$ZOBJPROPERTY(obj,p)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.i ((ptype="time")&&(value'="")) d
	..s value=$zt(value)
	.s ret=ret_"^"_p_"|"_value
	s CreatorDesc=""
	;负责人
	i obj.Creator=0 s CreatorDesc="管理员"
	e  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.Creator)
	.s:$IsObject(userObj) CreatorDesc=userObj.UserName 
	s ret=ret_"^CreatorDesc|"_CreatorDesc
	s StatusDesc=$case(obj.Status,"N":"未提交","S":"已提交","Y":"已发布",:obj.Status)
	s ret=ret_"^StatusDesc|"_StatusDesc
	s MaterialType="",MaterialTypeDesc=""
	i $IsObject(obj.MaterialType) d
	.s MaterialType=obj.MaterialType.%Id()
	.s MaterialTypeDesc=obj.MaterialType.SubDesc
	s ret=ret_"^MaterialType|"_MaterialType_"^MaterialTypeDesc|"_MaterialTypeDesc
	s MaterialUrl=""
	f i=1:1:obj.MaterialUrl.Count()  d
	.s tData=obj.MaterialUrl.GetAt(i)
	.q:tData=""
	.i MaterialUrl="" s MaterialUrl=tData
	.e  d
	..s MaterialUrl=MaterialUrl_","_tData
	s ret=ret_"^MaterialUrl|"_MaterialUrl
	q ret
}

/// Creator:lulin
/// Createdate:2020-07-24
/// Description:获取学习资料库列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindEmrplanTest","",0)
Query FindLearnData(parr As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindLearnDataExecute(ByRef qHandle As %Binary, parr As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s StartDate=$P(parr,"^",1)
	s EndDate=$P(parr,"^",2)
	s SelectType=$P(parr,"^",3)
	s SelectStatus=$P(parr,"^",4)
	s input=$P(parr,"^",5)
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"HLB",+$H)
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	s rw="" f  s rw=$O(^DHCINM.Tea.LearnDataD(rw)) q:rw=""  d
	.s objLB=$G(^DHCINM.Tea.LearnDataD(rw))
	.q:objLB=""
	.s creatDate=$LG(objLB,9)
	.q:((StartDate'="")&&(StartDate>creatDate))
	.q:((EndDate'="")&&(EndDate<creatDate))
	.s Status=$LG(objLB,7)
	.s creator=$LG(objLB,8)
	.q:((Status="N")&&(loginID'=creator))
	.s type=$LG(objLB,2)
	.q:((SelectStatus'="")&&(SelectStatus'=Status))
	.q:((SelectType'="")&&(SelectType'=type))
	.s desc=$LG(objLB,3)
	.q:((input'="")&&(desc'[input))
	.s MaterialWard=$LG(objLB,5)
	.s MaterialNoWard=$LG(objLB,6)
	.s exitFlag=0
	.i (isAll'=1)  d
	..i MaterialWard'="" d
	...s exitFlag=1
	...f i=1:1:$L(MaterialWard,",") q:exitFlag=0  d
	....s ward=$P(MaterialWard,",",i)
	....q:ward=""
	....s:$D(tmpWard(ward)) exitFlag=0
	..i (MaterialNoWard'="")&&(exitFlag=0) d  ;包含所有所辖病区不可见
	...s ExistFlag=1
	...s ward="" f  s ward=$O(tmpWard(ward)) q:((ward="")||(ExistFlag=0))  d
	....s:(","_MaterialNoWard_",")'[(","_ward_",") ExistFlag=0
	...s:ExistFlag=1 exitFlag=1
	.q:exitFlag=1
	.s ret=..GetLearnData(rw)
	.d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLearnDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLearnDataExecute ]
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

ClassMethod FindLearnDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLearnDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-08-10
/// Description:获取考核异常
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).GetTakeException(2,2)
ClassMethod GetTakeException(userId As %String, releaseId As %String) As %String
{
	s subId=$O(^DHCINM.Tea.ExamReleaseSubI("User",releaseId,userId,""))
	s obj=##class(DHCINM.Tea.ExamReleaseSub).%OpenId(releaseId_"||"_subId)
	s ReleaseId=releaseId
	s UserDR=obj.UserDR
	s WardDR=obj.WardDR
	s ExceptionDR=""
	s:$IsObject(obj.ExceptionDR) ExceptionDR=obj.ExceptionDR.%Id()
	s Remark=obj.Remark
	s ScoreUsedFlag=obj.ScoreUsedFlag
	s:ScoreUsedFlag="" ScoreUsedFlag="N"
	s ret="ReleaseId|"_ReleaseId_"^UserDR|"_UserDR_"^WardDR|"_WardDR
	_"^ExceptionDR|"_ExceptionDR_"^Remark|"_Remark_"^ScoreUsedFlag|"_ScoreUsedFlag
	q ret
}

/// Creator:lulin
/// Createdate:2020-08-10
/// Description:保存考核异常
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveTakeException("ExceptionDR|75||1^Remark|ddd^ScoreUsedFlag|N^WardDR|2^UserDR|28^ReleaseId|1^userName|^")
ClassMethod SaveTakeException(parr) As %String
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s ReleaseId=$G(tmp("ReleaseId"))
	s UserDR=$G(tmp("UserDR"))
	s subId=$O(^DHCINM.Tea.ExamReleaseSubI("User",ReleaseId,UserDR,""))
	s obj=##class(DHCINM.Tea.ExamReleaseSub).%OpenId(ReleaseId_"||"_subId)
	q:'$IsObject(obj) "获取考核人员信息失败"
	s obj.ExceptionDR=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId($G(tmp("ExceptionDR")))
	s obj.Remark=$G(tmp("Remark"))
	s obj.ScoreUsedFlag=$G(tmp("ScoreUsedFlag"))
	TS
	s sc=$$$ISOK(obj.%Save())
	if sc{
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-12-07
/// Description:保存护士培训
/// Input:
/// Output:
/// Other:
ClassMethod SaveNurseTrain(parr As %String, loginId As %String) As %String
{
	s ^TMP("SaveNurseTrain")=parr
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	i rw="" d
	.s obj=##class(DHCINM.Tea.NurseTrain).%New()
	.s obj.TranCreatDate=+$H
	.s obj.TranCrator=loginId
	e  s obj=##class(DHCINM.Tea.NurseTrain).%OpenId(rw)
	q:(obj.TranStatus="Y") "已发布不可修改"
	q:((obj.TranCrator'=loginId)) "非创建者不可修改"
	
	s className="DHCINM.Tea.NurseTrain"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.i $D(tmp(p)) d
	..s value=tmp(p)
	..s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	..i ((ptype="date")&&(value'="")) d
	...s value=$zdh(value,3)
	..s $ZOBJPROPERTY(obj,p)=value
	TS
	s sc=$$$ISOK(obj.%Save())
	if sc{
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-12-07
/// Description:保存护士培训完成信息
/// Input:
/// Output:
/// Other:
ClassMethod SaveNurseTrainFinish(parr As %String, seletParr As %String, loginId As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s TranDate=$g(tmp("TranDate"))
	i TranDate["-"  s TranDate=$zdh(TranDate,3)
	e  s TranDate=""
	
	TS
	s sc=1
	f i=1:1:$L(seletParr,",") q:'sc  d
	.s id=$P(seletParr,",",i)
	.q:id=""
	.s obj=##class(DHCINM.Tea.NurseTrain).%OpenId(id)
	.q:'$IsObject(obj)
	.q:obj.TranStatus'="Y" ;未发布不可置完成
	.q:obj.TranCrator'=loginId ;非创建者不可置完成
	.q:obj.TranIsFinish="Y" ;已置完成不可重复
	.s obj.TranIsFinish="Y"
	.s obj.TranDate=TranDate
	.s obj.TranRangeType=$g(tmp("TranRangeType"))
	.s obj.TranRange=$g(tmp("TranRange"))
	.s obj.TranPerson=$g(tmp("TranPerson"))
	.s sc=$$$ISOK(obj.%Save())
	if sc{
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-12-07
/// Description:删除护士培训
/// Input:
/// Output:
/// Other:
ClassMethod DeleteNurseTrain(parr As %String, loginId As %String) As %String
{
	s sc=1
	f i=1:1:$L(parr,",") d
	.s id=$p(parr,",",i)
	.q:id=""
	.s obj=##class(DHCINM.Tea.NurseTrain).%OpenId(id)
	.q:'$IsObject(obj)
	.q:(obj.TranCrator'=loginId)
	.q:(obj.TranStatus="Y")
	.d obj.%DeleteId(id)
	q 1
}

/// Creator:lulin
/// Createdate:2020-12-07
/// Description:发布护士培训
/// Input:
/// Output:
/// Other:
ClassMethod PublishNurseTrain(parr As %String, loginId As %String) As %String
{
	s sc=1
	f i=1:1:$L(parr,",") d
	.s id=$p(parr,",",i)
	.q:id=""
	.s obj=##class(DHCINM.Tea.NurseTrain).%OpenId(id)
	.q:'$IsObject(obj)
	.q:(obj.TranCrator'=loginId)
	.q:(obj.TranStatus="Y")
	.s obj.TranStatus="Y"
	.d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2020-07-28
/// Description:获取护士培训
/// Input:
/// Output:
/// Other:
ClassMethod GetNurseTrain(rw) As %String
{
	s obj=##class(DHCINM.Tea.NurseTrain).%OpenId(rw)
	s Status=obj.TranStatus
	s ret="rw|"_rw
	s className="DHCINM.Tea.NurseTrain"
	s codekKey=$LB("TranProject","TranType","TranProfession","TranMode")
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.s value=$ZOBJPROPERTY(obj,p)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.s ret=ret_"^"_p_"|"_value
	.i ($LF(codekKey,p)>0) d
	..s codeDesc=##class(web.INMDBComm).GetCommCode(value)
	..s ret=ret_"^"_p_"Desc|"_codeDesc
	
	s TranChargeDesc="",TranNurseDesc="",TranCratorDesc=""
	;创建者
	i obj.TranCrator=0 s TranCratorDesc="管理员"
	e  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.TranCrator)
	.s:$IsObject(userObj) TranCratorDesc=userObj.UserName 
	s ret=ret_"^TranCratorDesc|"_TranCratorDesc
	;培训人
	i obj.TranNurse=0 s TranNurseDesc="管理员"
	e  d
	.s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.TranNurse)
	.s:$IsObject(userObj) TranNurseDesc=userObj.UserName 
	s ret=ret_"^TranNurseDesc|"_TranNurseDesc
	;负责人
	i obj.TranCharge=0 s TranChargeDesc="管理员"
	e  d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(obj.TranCharge)
	.s:$IsObject(perObj) TranChargeDesc=perObj.PerName 
	s ret=ret_"^TranChargeDesc|"_TranChargeDesc
	
	s StatusDesc=$case(obj.TranStatus,"N":"未发布","Y":"已发布",:obj.Status)
	s ret=ret_"^StatusDesc|"_StatusDesc
	s TranIsFinishDesc=$case(obj.TranIsFinish,"Y":"已完成",:"未完成")
	s ret=ret_"^TranIsFinishDesc|"_TranIsFinishDesc
	q ret
}

/// Creator:lulin
/// Createdate:2020-07-24
/// Description:获取学习资料库列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindNurseTrain","2020-11-08^2021-01-07",0)
Query FindNurseTrain(parr As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseTrainExecute(ByRef qHandle As %Binary, parr As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s StartDate=$P(parr,"^",1)
	s EndDate=$P(parr,"^",2)
	i StartDate["-" d
	.s StartDate=$zdh(StartDate,3)
	e  s StartDate=""
	i EndDate["-" d
	.s EndDate=$zdh(EndDate,3)
	e  s EndDate=""
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	s rw="" f  s rw=$O(^DHCINM.Tea.NurseTrainD(rw)) q:rw=""  d
	.s objLB=$G(^DHCINM.Tea.NurseTrainD(rw))
	.q:objLB=""
	.s stDate=$LG(objLB,11),endDate=$LG(objLB,12),status=$LG(objLB,15),TranCrator=$LG(objLB,14)
	.q:((status'="Y")&&(TranCrator'=loginID))
	.q:((StartDate'="")&&(endDate'="")&&(StartDate>endDate))
	.q:((EndDate'="")&&(stDate'="")&&(EndDate<stDate))
	.s ret=..GetNurseTrain(rw)
	.d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseTrainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseTrainExecute ]
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

ClassMethod FindNurseTrainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存真题模考
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveLearnDryRun("2|1^3|1^4|1","2")
ClassMethod SaveLearnDryRun(parr As %String) As %String
{
	s ^TMP("SaveLearnDryRun")=parr
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	i rw="" d
	.s obj=##class(DHCINM.Tea.LearnDryRun).%New()
	.s obj.CreatDate=+$H
	.s obj.CreatTime=$P($H,",",2)
	e  s obj=##class(DHCINM.Tea.LearnDryRun).%OpenId(rw)
	q:((obj.Status'="")&&(obj.Status'="N")) "已做不可修改"
	s className="DHCINM.Tea.LearnDryRun"
	s customKey=$LB("QuestRange")
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.i $D(tmp(p)) d
	..s value=tmp(p)
	..s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	..i ((ptype="date")&&(value'="")) d
	...s value=$zdh(value,3)
	..i p="ReleaseType" d
	...s value=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(value)
	..s $ZOBJPROPERTY(obj,p)=value
	
	;考核范围
	s listData=$G(tmp("QuestRange"))
	d obj.QuestRange.Clear()
	
	k retSubData
	s retSubData=""
	f i=1:1:$L(listData,"「") d
	.s rowData=$P(listData,"「",i)
	.q:rowData=""
	.d obj.QuestRange.Insert(rowData)
	.i obj.RealPaperType="H" d
	..s subjectId=$P(rowData,"」",2)
	..s subScore=$P(rowData,"」",3)
	..i ((subjectId'="")&&(subScore'="")) d
	...s retSubData(i)=subjectId_"」"_subScore
	
	.
	.;手动1,3」3||1」2  ,2,3,,id和分值
	;理论/应急预案，智能-固定组卷
	i (obj.RealPaperType="I") d
	.k retTmp
	.s retTmp=""
	.d ..SetIntellectExamTheoryTmp(.retTmp,obj.QuestRange)
	.s subIndex=1
	.s problemId="" f  s problemId=$O(retTmp(problemId)) q:problemId=""  d
	..s score=retTmp(problemId)
	..s rowData=problemId_"」"_score
	..s retSubData(subIndex)=rowData
	..s subIndex=subIndex+1
	TS
	s sc=$$$ISOK(obj.%Save())
	if 'sc{
		TRO
		q "保存失败"	
	}
	//删除子表
	s subId="" f  s subId=$O(^DHCINM.Tea.LearnDryRunSubD(obj.%Id(),subId)) q:((subId="")||('sc))  d
	.s subObj=##class(DHCINM.Tea.LearnDryRunSub).%OpenId(obj.%Id()_"||"_subId)
	.q:'$IsObject(subObj)
	.s sc=sc&&$$$ISOK(subObj.%DeleteId(obj.%Id()_"||"_subId))
	if 'sc{
		TRO
		q "删除原有子表数据失败"	
	}
	//创建子表题库
	s subIndex="" f  s subIndex=$O(retSubData(subIndex)) q:((subIndex="")||('sc))  d
	.s rowData=$g(retSubData(subIndex))
	.q:rowData=""
	.s subjectId=$P(rowData,"」",1)
	.s subScore=$P(rowData,"」",2)
	.q:subjectId=""
	.q:subScore=""
	.s TeaTheorySubObj=##class(CF.DHCINM.DB.TeaTheorySub).%OpenId(subjectId)
	.q:'$IsObject(TeaTheorySubObj)
	.s subObj=##class(DHCINM.Tea.LearnDryRunSub).%New()
	.s subObj.Parref=obj
	.s subObj.ExamSubDR=TeaTheorySubObj
	.s subObj.ExamScore=subScore
	.s subObj.SubDesc=TeaTheorySubObj.SubDesc
	.s subObj.SubUrl=TeaTheorySubObj.SubUrl
	.s subObj.SubMode=TeaTheorySubObj.SubMode
	.s subObj.SubTypeDR=TeaTheorySubObj.SubTypeDR
	.s subObj.SubOption=TeaTheorySubObj.SubOption
	.s subObj.SubAnswer=TeaTheorySubObj.SubAnswer
	.s subObj.SubSource=TeaTheorySubObj.SubSource
	.s subObj.SubAnalysis=TeaTheorySubObj.SubAnalysis
	.s sc=sc&&$$$ISOK(subObj.%Save())
	if sc{
		TC
		q 1	
	}else{
		TRO
		q "保存子表数据失败"	
	}
}

/// Creator:lulin
/// Createdate:2021-01-06
/// Description:获取真题模考
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).GetLearnDryRun(4)
ClassMethod GetLearnDryRun(rw) As %String
{
	s obj=##class(DHCINM.Tea.LearnDryRun).%OpenId(rw)
	s nowDate=+$H
	q:'$IsObject(obj) ""
	s ret="rw|"_rw
	s className="DHCINM.Tea.LearnDryRun"
	s customKey=$LB("ReleaseType","QuestRange")
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.s value=$ZOBJPROPERTY(obj,p)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.i ((ptype="time")&&(value'="")) d
	..s value=$zt(value,2)
	.s ret=ret_"^"_p_"|"_value
	s ReleaseType="",ReleaseTypeDesc=""
	i $IsObject(obj.ReleaseType) d
	.s ReleaseType=obj.ReleaseType.%Id()
	.s ReleaseTypeDesc=obj.ReleaseType.SubDesc
	s ret=ret_"^ReleaseType|"_ReleaseType_"^ReleaseTypeDesc|"_ReleaseTypeDesc
	;考试范围
	s QuestRange=""
	f i=1:1:obj.QuestRange.Count()  d
	.s rowData=obj.QuestRange.GetAt(i)
	.q:rowData=""
	.i QuestRange="" d
	..s QuestRange=rowData
	.e  d
	..s QuestRange=QuestRange_"「"_rowData
	s ret=ret_"^QuestRange|"_QuestRange
	s Status=obj.Status
	s:Status="" Status="N"
	s StatusDesc=$case(Status,"Y":"已完成","N":"未答题",:obj.Status)
	s ret=ret_"^StatusDesc|"_StatusDesc
	s createDate=obj.CreatDate,createTime=obj.CreatTime
	s createDateTime=""
	q ret
}

/// Creator:lulin
/// Createdate:2021-01-06
/// Description:查询真题模考
/// Input:parr:startDate^endDate,input,loginID
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindLearnDryRunList","^^","","0")
Query FindLearnDryRunList(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindLearnDryRunListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s startDate=$P(parr,"^",1)
	i startDate["-" d
	.s startDate=$zdh(startDate,3)
	e  d
	.s startDate=""
	s endDate=$P(parr,"^",2)
	i endDate["-" d
	.s endDate=$zdh(endDate,3)
	e  d
	.s endDate=""
	s input=$zcvt(input,"U")
	s ret="",nowDate=+$H
	if loginID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s id="" f  s id=$O(^DHCINM.Tea.LearnDryRunI("Creator"," "_loginID,id)) q:id=""  d
	.s objLB=$g(^DHCINM.Tea.LearnDryRunD(id))
	.q:objLB=""
	.s CreateDate=$LG(objLB,13)
	.q:((startDate'="")&&(startDate>CreateDate))
	.q:((endDate'="")&&(endDate<CreateDate))
	.s desc=$LG(objLB,3)
	.s Status=$LG(objLB,11)
	.q:((input'="")&&(desc'[input))
	.s ret=..GetLearnDryRun(id)
	.s SubSum=0
	.k subTypeTmp
	.s subTypeTmp=""
	.s subId="" f  s subId=$O(^DHCINM.Tea.LearnDryRunSubD(id,subId)) q:subId=""  d
	..s subObjLG=$G(^DHCINM.Tea.LearnDryRunSubD(id,subId))
	..q:subObjLG=""
	..s SubSum=SubSum+1
	..s SubTypeDR=$LG(subObjLG,10)
	..s:SubTypeDR'="" subTypeTmp(SubTypeDR)=$G(subTypeTmp(SubTypeDR))+1
	.s ret=ret_"^SubSum|"_SubSum
	.s SubTypeDR="" f  s SubTypeDR=$O(subTypeTmp(SubTypeDR)) q:SubTypeDR=""  d
	..s ret=ret_"^"_$TR(SubTypeDR,"||","__")_"|"_$G(subTypeTmp(SubTypeDR))
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLearnDryRunListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLearnDryRunListExecute ]
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

ClassMethod FindLearnDryRunListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLearnDryRunListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:删除考核发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).DeleteLearnDryRun(rw,loginID)
ClassMethod DeleteLearnDryRun(rw, loginID) As %String
{
	s obj=##class(DHCINM.Tea.LearnDryRun).%OpenId(rw)
	q:'$IsObject(obj) "无此记录信息"
	s oldStatus=obj.Status
	q:((oldStatus'="N")&&((oldStatus'=""))) "已答题,不可删除"
	q:obj.Creator'=loginID "非创建者不可删除"
	d obj.%DeleteId(rw)
	q 1
}

/// Creator:lulin
/// Createdate:2021-01-06
/// Description:获取真题模考所有题目
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindLearnDryRunSubList","2")
Query FindLearnDryRunSubList(parr As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindLearnDryRunSubListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",nowDate=+$H
	s id=parr
	i id=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s subid="" f  s subid=$O(^DHCINM.Tea.LearnDryRunSubD(id,subid)) q:subid=""  d
	.s subObjLG=$G(^DHCINM.Tea.LearnDryRunSubD(id,subid))
	.q:subObjLG=""
	.s ret=..GetLearnDryRunSub(id,subid)
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLearnDryRunSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLearnDryRunSubListExecute ]
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

ClassMethod FindLearnDryRunSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLearnDryRunSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2021-01-06
/// Description:获取真题模考题目
/// Input:
/// Output:
/// Other:
ClassMethod GetLearnDryRunSub(id, subid) As %String
{
	s objLB=$G(^DHCINM.Tea.LearnDryRunSubD(id,subid))
	s SubDesc=$LG(objLB,7)
	s SubMode=$LG(objLB,9)
	s SubUrl=""
	s SubUrlLB=$LG(objLB,8)
	f i=1:1:$LL(SubUrlLB)  d
	.s tSubUrl=$LG(SubUrlLB,i)
	.q:tSubUrl=""
	.i SubUrl="" s SubUrl=tSubUrl
	.e  d
	..s SubUrl=SubUrl_","_tSubUrl
	s SubSource=$LG(objLB,13)
	s SubAnalysis=$LG(objLB,14)
	s SubOption=""
	s SubOptionLB=$LG(objLB,11)
	f i=1:1:$LL(SubOptionLB) d
	.s tSubOption=$LG(SubOptionLB,i)
	.q:tSubOption=""
	.i SubOption="" s SubOption=tSubOption
	.e  d
	..s SubOption=SubOption_"」"_tSubOption
	s SubAnswer=$LG(objLB,12)
	s Result=$LG(objLB,3)
	i Result="" d
	.i SubMode="B" d
	..f i=1:1:($L(SubAnswer,"」")-1) d
	...s Result=Result_"」"
	s GetScore=$LG(objLB,4)
	s ExamScore=$LG(objLB,5)
	s ExamTime=$LG(objLB,6)
	s SubTypeDR=$LG(objLB,10)
	s:ExamTime="" ExamTime=0
	s ret="SubRw|"_id_"||"_subid_"^SubDesc|"_SubDesc_"^SubMode|"_SubMode_"^SubSource|"_SubSource_"^SubAnalysis|"_SubAnalysis
	_"^SubUrl|"_SubUrl_"^SubOption|"_SubOption_"^SubAnswer|"_SubAnswer_"^Result|"_Result_"^GetScore|"_GetScore
	_"^ExamScore|"_ExamScore_"^ExamScore|"_ExamScore_"^ExamTime|"_ExamTime
	_"^SubTypeDR|"_SubTypeDR_"^CorrectFlag|"
	q ret
}

/// Creator:lulin
/// Createdate:2021-01-07
/// Description:保存真题模考考试数据
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveLearnDryRunSub("2||1「367「」2||2「1「」2||3「0「」2||4「1「」2||5「0「」2||6「0「」2||7「1「")
ClassMethod SaveLearnDryRunSub(parr As %String, rw As %String, ExamTime) As %String
{
	s ^TMP("SaveLearnDryRunSub")=parr
	q:parr="" "0^入参为空"
	s obj=##class(DHCINM.Tea.LearnDryRun).%OpenId(rw)
	q:'$IsObject(obj) "0^未获取对象，请刷新重试"
	s ExamScore=0 
	s curret=""
	TS
	s sc=1
	f i=1:1:$L(parr,"」") q:'sc  d
	.s rowData=$P(parr,"」",i)
	.q:rowData=""
	.s subRw=$P(rowData,"「",1)
	.s subExamTime=$P(rowData,"「",2)
	.s Result=$P(rowData,"「",3)
	.q:subRw=""
	.s subObj=##class(DHCINM.Tea.LearnDryRunSub).%OpenId(subRw)
	.q:'$IsObject(subObj)
	.s subObj.ExamTime=subExamTime
	.s subObj.Result=Result
	.i subObj.SubMode'="A" d
	..s subObj.CorrectFlag=..IsCurrect(subObj.Result,subObj.ExamSubDR)
	..s subObj.GetScore=subObj.ExamScore*subObj.CorrectFlag
	.e  d
	..s subObj.GetScore=0
	.s ExamScore=ExamScore+subObj.GetScore
	.i curret="" d
	..s curret=subObj.CorrectFlag
	.e  s curret=curret_","_subObj.CorrectFlag
	.s sc=sc&&$$$ISOK(subObj.%Save())
	i 'sc{
		TRO
		q "0^保存子表数据失败"
	}
	s obj.Status="Y"
	s obj.ExamTime=ExamTime
	s obj.ExamScore=ExamScore
	s obj.AnswerDate=+$H
	s obj.AnswerTime=$P($H,",",2)
	s sc=sc&&$$$ISOK(obj.%Save())
	i sc {
		TC
		q "1^"_curret
	}else{
		TRO
		q "0^保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2021-01-08
/// Description:获取教学情况汇总-综合汇总
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindCountTeaAll","^2021",0)
Query FindCountTeaAll(parr As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindCountTeaAllExecute(ByRef qHandle As %Binary, parr As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",retTmp=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	//培训、理论、技操、应急预案、应急预案演练次数/人次
	//NurseTran、ExamTheory、ExamOperation、ExamEmergency、EmergencyTest、EmergencyTestPer
	s ward=$P(parr,"^",1)
	s year=$P(parr,"^",2)
	if year=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s startDate=$zdh(year_"-01-01",3)
	s endDate=$zdh(year_"-12-31",3)
	s TranDate=startDate-1 f  s TranDate=$O(^DHCINM.Tea.NurseTrainI("TranDate",TranDate)) q:((TranDate="")||(TranDate>endDate))  d
	.s month=+$P($zd(TranDate,3),"-",2)
	.s tranId="" f  s tranId=$O(^DHCINM.Tea.NurseTrainI("TranDate",TranDate,tranId)) q:(tranId="")  d
	..s tranObjLB=$G(^DHCINM.Tea.NurseTrainD(tranId))
	..q:tranObjLB=""
	..s persons=$LG(tranObjLB,20)
	..q:persons=""
	..f i=1:1:$L(persons,",")  d
	...s perId=$P(persons,",",i)
	...q:perId=""
	...s currentWard=##class(web.INMHRComm).GetCurrentWard(perId,TranDate)
	...q:((isAll=0)&&('$D(tmpWard(currentWard))))
	...q:((ward'="")&&(ward'=currentWard))
	...s retTmp(month,"NurseTran")=$g(retTmp(month,"NurseTran"))+1
	;理论/应急预案考核
	s ExamDate=startDate-1 f  s ExamDate=$O(^DHCINM.Tea.ExamTheoryI("DateWard",ExamDate)) q:((ExamDate="")||(ExamDate>endDate))  d
	.s month=+$P($zd(ExamDate,3),"-",2)
	.s wardId="" f  s wardId=$O(^DHCINM.Tea.ExamTheoryI("DateWard",ExamDate,wardId)) q:(wardId="")  d
	..q:((isAll=0)&&('$D(tmpWard($tr(wardId," ","")))))
	..q:((ward'="")&&(ward'=$tr(wardId," ","")))
	..s examId="" f  s examId=$O(^DHCINM.Tea.ExamTheoryI("DateWard",ExamDate,wardId,examId)) q:(examId="")  d
	...s objLB=$G(^DHCINM.Tea.ExamTheoryD(examId))
	...q:objLB=""
	...s ReleaseMode=$LG(objLB,8)
	...i ReleaseMode="E" d
	....s retTmp(month,"ExamEmergency")=$g(retTmp(month,"ExamEmergency"))+1
	...e  d
	....s retTmp(month,"ExamTheory")=$g(retTmp(month,"ExamTheory"))+1
	;技操考核
	s ExamDate=startDate-1 f  s ExamDate=$O(^DHCINM.Tea.ExamOperaI("DateWard",ExamDate)) q:((ExamDate="")||(ExamDate>endDate))  d
	.s month=+$P($zd(ExamDate,3),"-",2)
	.s wardId="" f  s wardId=$O(^DHCINM.Tea.ExamOperaI("DateWard",ExamDate,wardId)) q:(wardId="")  d
	..q:((isAll=0)&&('$D(tmpWard(wardId))))
	..q:((ward'="")&&(ward'=wardId))
	..s examId="" f  s examId=$O(^DHCINM.Tea.ExamOperaI("DateWard",ExamDate,wardId,examId)) q:(examId="")  d
	...s objLB=$G(^DHCINM.Tea.ExamOperaD(examId))
	...q:objLB=""
	...s retTmp(month,"ExamOperation")=$g(retTmp(month,"ExamOperation"))+1
	;应急预案演练
	s TestDate=startDate-1 f  s TestDate=$O(^DHCINM.Tea.EmrPlanTestI("Ward",TestDate)) q:((TestDate="")||(ExamDate>endDate))  d
	.s month=+$P($zd(TestDate,3),"-",2)
	.s wardId="" f  s wardId=$O(^DHCINM.Tea.EmrPlanTestI("Ward",TestDate,wardId)) q:(wardId="")  d
	..q:((isAll=0)&&('$D(tmpWard(wardId))))
	..q:((ward'="")&&(ward'=wardId))
	..s examId="" f  s examId=$O(^DHCINM.Tea.EmrPlanTestI("Ward",TestDate,wardId,examId)) q:(examId="")  d
	...s objLB=$G(^DHCINM.Tea.EmrPlanTestD(examId))
	...q:objLB=""
	...s Status=$LG(objLB,14)
	...q:((Status="")||(Status="N"))
	...s retTmp(month,"EmergencyTest")=$g(retTmp(month,"EmergencyTest"))+1
	...s TestTrainer=$LG(objLB,7)
	...f i=1:1:$L(TestTrainer,",") d
	....s perId=$P(TestTrainer,",",i)
	....q:perId=""
	....s retTmp(month,"EmergencyTestPer")=$g(retTmp(month,"EmergencyTestPer"))+1
	s column=$LB("NurseTran","ExamTheory","ExamOperation","ExamEmergency","EmergencyTest","EmergencyTestPer")
	s retTotal=""
	f month=1:1:12  d
	.s monthDesc=month_"月"
	.s ret="Month|"_monthDesc
	.f j=1:1:$LL(column)  d
	..s columnProp=$LG(column,j)
	..s num=$G(retTmp(month,columnProp))
	..s ret=ret_"^"_columnProp_"|"_num
	..s retTotal(columnProp)=$G(retTotal(columnProp))+num
	.d OutputRowData
	s ret="Month|合计"
	f j=1:1:$LL(column)  d
	.s columnProp=$LG(column,j)
	.s ret=ret_"^"_columnProp_"|"_$g(retTotal(columnProp))
	d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCountTeaAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCountTeaAllExecute ]
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

ClassMethod FindCountTeaAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCountTeaAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2021-01-08
/// Description:获取教学情况汇总-培训汇总
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindCountTeaTest","^2021",0)
Query FindCountTeaTest(parr As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindCountTeaTestExecute(ByRef qHandle As %Binary, parr As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",retTmp=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	s ward=$P(parr,"^",1)
	s year=$P(parr,"^",2)
	if year=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s startDate=$zdh(year_"-01-01",3)
	s endDate=$zdh(year_"-12-31",3)
	s TranDate=startDate-1 f  s TranDate=$O(^DHCINM.Tea.NurseTrainI("TranDate",TranDate)) q:((TranDate="")||(TranDate>endDate))  d
	.s month=+$P($zd(TranDate,3),"-",2)
	.s tranId="" f  s tranId=$O(^DHCINM.Tea.NurseTrainI("TranDate",TranDate,tranId)) q:(tranId="")  d
	..s tranObjLB=$G(^DHCINM.Tea.NurseTrainD(tranId))
	..q:tranObjLB=""
	..s persons=$LG(tranObjLB,20)
	..q:persons=""
	..s TranProject=$tr($LG(tranObjLB,3),"||","__")
	..q:TranProject=""
	..f i=1:1:$L(persons,",")  d
	...s perId=$P(persons,",",i)
	...q:perId=""
	...s currentWard=##class(web.INMHRComm).GetCurrentWard(perId,TranDate)
	...q:((isAll=0)&&('$D(tmpWard(currentWard))))
	...q:((ward'="")&&(ward'=currentWard))
	...s retTmp(month,TranProject)=$g(retTmp(month,TranProject))+1
	
	s retTotal=""
	f month=1:1:12  d
	.s monthDesc=month_"月"
	.s ret="Month|"_monthDesc
	.s TranProject="" f  s TranProject=$O(retTmp(month,TranProject)) q:TranProject=""  d
	..s num=$G(retTmp(month,TranProject))
	..s ret=ret_"^"_TranProject_"|"_num
	..s retTotal(TranProject)=$G(retTotal(TranProject))+num
	.d OutputRowData
	s ret="Month|合计"
	s TranProject="" f  s TranProject=$O(retTotal(TranProject)) q:TranProject=""  d
	.s ret=ret_"^"_TranProject_"|"_$g(retTotal(TranProject))
	d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCountTeaTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCountTeaTestExecute ]
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

ClassMethod FindCountTeaTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCountTeaTestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2021-01-08
/// Description:获取教学情况汇总-考核汇总
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindCountTeaExam","^2021",0)
Query FindCountTeaExam(parr As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindCountTeaExamExecute(ByRef qHandle As %Binary, parr As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",retTmp=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	//培训、理论、技操、应急预案、应急预案演练次数/人次
	//NurseTran、ExamTheory、ExamOperation、ExamEmergency、EmergencyTest、EmergencyTestPer
	s ward=$P(parr,"^",1)
	s year=$P(parr,"^",2)
	if year=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s startDate=$zdh(year_"-01-01",3)
	s endDate=$zdh(year_"-12-31",3)
	;理论/应急预案考核
	s ExamDate=startDate-1 f  s ExamDate=$O(^DHCINM.Tea.ExamTheoryI("DateWard",ExamDate)) q:((ExamDate="")||(ExamDate>endDate))  d
	.s month=+$P($zd(ExamDate,3),"-",2)
	.s wardId="" f  s wardId=$O(^DHCINM.Tea.ExamTheoryI("DateWard",ExamDate,wardId)) q:(wardId="")  d
	..q:((isAll=0)&&('$D(tmpWard($tr(wardId," ","")))))
	..q:((ward'="")&&(ward'=$tr(wardId," ","")))
	..s examId="" f  s examId=$O(^DHCINM.Tea.ExamTheoryI("DateWard",ExamDate,wardId,examId)) q:(examId="")  d
	...s objLB=$G(^DHCINM.Tea.ExamTheoryD(examId))
	...q:objLB=""
	...s ReleaseMode=$LG(objLB,8)
	...s releaseId=$LG(objLB,2)
	...q:releaseId=""
	...s releaeObj=$g(^DHCINM.Tea.ExamReleaseD(releaseId))
	...q:releaeObj=""
	...s ReleaseType=$TR($LG(releaeObj,3),"||","__")
	...q:ReleaseType=""
	...i ReleaseMode="E" d
	....s ReleaseType="E"_ReleaseType
	...e  d
	....s ReleaseType="T"_ReleaseType
	...s retTmp(month,ReleaseType)=$g(retTmp(month,ReleaseType))+1
	;技操考核
	s ExamDate=startDate-1 f  s ExamDate=$O(^DHCINM.Tea.ExamOperaI("DateWard",ExamDate)) q:((ExamDate="")||(ExamDate>endDate))  d
	.s month=+$P($zd(ExamDate,3),"-",2)
	.s wardId="" f  s wardId=$O(^DHCINM.Tea.ExamOperaI("DateWard",ExamDate,wardId)) q:(wardId="")  d
	..q:((isAll=0)&&('$D(tmpWard(wardId))))
	..q:((ward'="")&&(ward'=wardId))
	..s examId="" f  s examId=$O(^DHCINM.Tea.ExamOperaI("DateWard",ExamDate,wardId,examId)) q:(examId="")  d
	...s objLB=$G(^DHCINM.Tea.ExamOperaD(examId))
	...q:objLB=""
	...s releaseId=$LG(objLB,3)
	...q:releaseId=""
	...s releaeObj=$g(^DHCINM.Tea.ExamReleaseD(releaseId))
	...q:releaeObj=""
	...s ReleaseType=$TR($LG(releaeObj,3),"||","__")
	...q:ReleaseType=""
	...s ReleaseType="O"_ReleaseType
	...s retTmp(month,ReleaseType)=$g(retTmp(month,ReleaseType))+1
	
	s retTotal=""
	f month=1:1:12  d
	.s monthDesc=month_"月"
	.s ret="Month|"_monthDesc
	.s subType="" f  s subType=$O(retTmp(month,subType)) q:subType=""  d
	..s num=$G(retTmp(month,subType))
	..s ret=ret_"^"_subType_"|"_num
	..s retTotal(subType)=$G(retTotal(subType))+num
	.d OutputRowData
	s ret="Month|合计"
	s subType="" f  s subType=$O(retTotal(subType)) q:subType=""  d
	.s ret=ret_"^"_subType_"|"_$g(retTotal(subType))
	d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCountTeaExamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCountTeaExamExecute ]
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

ClassMethod FindCountTeaExamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCountTeaExamExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2022-05-17
/// Description:获取预约信息
/// Input:
/// Output:
/// Other:
ClassMethod GetOrderOpera(rw, loginID) As %String
{
	s obj=##class(DHCINM.Tea.ExamRelease).%OpenId(rw)
	q:'$IsObject(obj) "msgCode|0^msg|未找到考试对象,请刷新重试"
	q:$d(^DHCINM.Tea.ExamOperaI("releaseUser",rw,loginID)) "msgCode|0^msg|已考核不可预约"
	s subID=$O(^DHCINM.Tea.ExamReleaseSubI("User",rw,loginID,""))
	q:subID="" "msgCode|0^msg|非规定考生,不可预约"
	s subObj=##class(DHCINM.Tea.ExamReleaseSub).%OpenId(rw_"||"_subID)
	q:'$IsObject(subObj) "msgCode|0^msg|未找到人员信息对象,请刷新重试"
	s endDate="",endTime=""
	;2022-05-12」2022-05-15」2022-05-04 08:00」八点」一楼」99
	s OrdeNumList=""
	f i=1:1:obj.TimeList.Count() d
	.s timeObj=obj.TimeList.GetAt(i)
	.q:timeObj=""
	.s tEndDate=$P(timeObj,"」",1)
	.s orderDate=$P(timeObj,"」",3)
	.i OrdeNumList="" s OrdeNumList=0
	.e  s OrdeNumList=OrdeNumList_",0"
	.s tEndTime=""
	.i orderDate'="" d
	..s tEndDate=$P(orderDate," ",1)
	..s tEndTime=$P(orderDate," ",2)
	.s:tEndDate'="" tEndDate=$zdh(tEndDate,3)
	.s:tEndTime'="" tEndTime=$zth(tEndTime,2)
	.s:((tEndDate'="")&&(tEndDate>endDate)) endDate=tEndDate,endTime=tEndTime
	.s:((tEndTime'="")&&(tEndDate=endDate)&&(tEndTime>endTime)) endTime=tEndTime
	q:((endDate'="")&&(endDate<+$H)) "msgCode|0^msg|已超过预约日期,不可预约"
	q:((endDate'="")&&(endTime'="")&&(endDate=+$H)&&(endTime<$P($H,",",2))) "msgCode|0^msg|已超过预约时间,不可预约"
	s OrdeNumList=$LFS(OrdeNumList,",")
	s oSubID="" f  s oSubID=$O(^DHCINM.Tea.ExamReleaseSubD(rw,oSubID)) q:oSubID=""  d
	.s tOrderNum=$lg($g(^DHCINM.Tea.ExamReleaseSubD(rw,oSubID)),7)
	.s:tOrderNum'="" $li(OrdeNumList,tOrderNum)=$lg(OrdeNumList,tOrderNum)+1
	s ret="msgCode|1^msg|^rw|"_rw_"||"_subID_"^OrderNum|"_subObj.OrderNum_"^OrdeNumList|"_$lts(OrdeNumList,",")
	q ret
}

/// Creator:lulin
/// Createdate:2022-05-17
/// Description:保存预约信息
/// Input:
/// Output:
/// Other:
ClassMethod SaveOrderOpera(rw, OrderNum) As %String
{
	q:rw="" "入参为空,请刷新重试"
	q:OrderNum="" "请选择预约批次"
	s par=$P(rw,"||",1)
	s subObj=##class(DHCINM.Tea.ExamReleaseSub).%OpenId(rw)
	q:'$IsObject(subObj) "未找到对象请刷新重试"
	q:(subObj.OrderNum=OrderNum) "已预约此批次,请选择其他批次" ;已预约批次不可修改
	s timeOrderNum=0 ;已预约人次
	s oSubID="" f  s oSubID=$O(^DHCINM.Tea.ExamReleaseSubD(rw,oSubID)) q:oSubID=""  d
	.s tOrderNum=$lg($g(^DHCINM.Tea.ExamReleaseSubD(rw,oSubID)),7)
	.s:tOrderNum'=OrderNum timeOrderNum=timeOrderNum+1
	s OrderPass="",EndDate="",endTime=""
	f i=1:1:subObj.Parref.TimeList.Count() d
	.s timeObj=subObj.Parref.TimeList.GetAt(i)
	.q:timeObj=""
	.q:i'=OrderNum
	.s tEndDate=$P(timeObj,"」",1)
	.s orderDate=$P(timeObj,"」",3)
	.s OrderPass=$P(timeObj,"」",6)
	.s tEndTime=""
	.i orderDate'="" d
	..s tEndDate=$P(orderDate," ",1)
	..s tEndTime=$P(orderDate," ",2)
	.s:tEndDate'="" tEndDate=$zdh(tEndDate,3)
	.s:tEndTime'="" tEndTime=$zth(tEndTime,2)
	.s endDate=tEndDate,endTime=tEndTime
	q:((endDate'="")&&(endDate<+$H)) "已超过预约日期,不可预约" 
	q:((endDate'="")&&(endTime'="")&&(endDate=+$H)&&(endTime<$P($H,",",2))) "已超过预约时间,不可预约"
	q:((OrderPass'="")&&(timeOrderNum>OrderPass)) "超过预约人次上线,请预约其他批次"
	s subObj.OrderNum=OrderNum
	d subObj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2020-07-14
/// Description:查询阅卷数据
/// Input:,input,loginID
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindAnslyList","","","0")
Query FindAnslyList(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindAnslyListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s input=$zcvt(input,"U")
	s ret="",nowDate=+$H
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"hlb,hlbzr,manager,admin",+$H)
	s id="" f  s id=$O(^DHCINM.Tea.ExamReleaseD(id)) q:id=""  d
	.s objLB=$g(^DHCINM.Tea.ExamReleaseD(id))
	.q:objLB=""
	.s ReleaseMode=$LG(objLB,2)
	.q:ReleaseMode'="T"
	.s status=$LG(objLB,22)
	.q:(status'="Y")
	.s Marktor=$lg(objLB,27)
	.q:Marktor=""
	.s markFlag=0 ;是否为阅卷人
	.s ExamID="" f  s ExamID=$O(^DHCINM.Tea.ExamTheoryI("release",id,ExamID)) q:((ExamID="")||(markFlag'=0))  d
	..s tAnslyor=$lg($g(^DHCINM.Tea.ExamTheoryD(ExamID)),12)
	..s:tAnslyor=loginID markFlag=1
	.q:((markFlag=0)&&(loginID'=0))
	.s ret=..GetExamRelease(id)
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAnslyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnslyListExecute ]
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

ClassMethod FindAnslyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnslyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-17
/// Description:获取阅卷人要阅卷试卷
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindExamAnalysList","1^","",0)
Query FindExamAnalysList(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindExamAnalysListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",nowDate=+$H
	s realeaseRW=$P(parr,"^",1)
	s type=$P(parr,"^",2) ;1:考核人、2:病区、3:状态
	s obj=$g(^DHCINM.Tea.ExamReleaseD(realeaseRW))
	i obj=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ReleaseMode=$lg(obj,2) ;类论:T、技操:O、应急预案:E
	s ReleaseDesc=$lg(obj,5)
	s Marktor=$lg(obj,27),markFlag=0
	;判断是否为阅卷人,即是否需阅卷
	s showAll=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"hlb",+$H)
	s weight=100
	f i=1:1:$L(Marktor,"「") q:markFlag'=0  d
	.s marktorObj=$P(Marktor,"「",i)
	.s marktorRW=$P(marktorObj,"」",1)
	.s:marktorRW=loginID markFlag=1,weight=$P(marktorObj,"」",2)
	i ((ReleaseMode'="T")||((markFlag=0)&&(loginID'=0))){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s MarkShowFlag=$lg(obj,28)
	s id="" f  s id=$O(^DHCINM.Tea.ExamTheoryI("release",realeaseRW,id)) q:id=""  d
	.s examObj=$g(^DHCINM.Tea.ExamTheoryD(id))
	.q:examObj=""
	.s userID=$lg(examObj,3)
	.q:userID=""
	.s userObj=$G(^CF.DHCINM.DB.MgUserD(userID))
	.q:userObj=""
	.s userName=$LG(userObj,2)
	.s wardId=$lg(examObj,4),wardDesc=""
	.s:wardId'="" wardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(wardId)),4)
	.s:MarkShowFlag'="Y" userName="",wardDesc=""
	.s Anslyor=$lg(examObj,12)
	.q:((type=1)&&(input'="")&&($zcvt(userName,"U")'[$zcvt(input,"U")))
	.q:((type=2)&&(input'="")&&($zcvt(wardDesc,"U")'[$zcvt(input,"U")))
	.q:((loginID'=0)&&(Anslyor'=loginID)) ;非阅卷人不可见
	.s AnslyFlag=$lg(examObj,11),AnslyFlagDesc=""
	.s AnslyFlagDesc=$case(AnslyFlag,"Y":"未阅卷","":"已阅卷",:"")
	.s ExamDate=$lg(examObj,5)
	.s:ExamDate'="" ExamDate=$zd(ExamDate,3)
	.s ExamAnslyScore=$lg(examObj,16)
	.s EditFlag="Y"
	.s:((AnslyFlag'="Y")||((Anslyor'=loginID)&&(loginID'=0))) EditFlag="N"
	.s ret="userName|"_userName_"^userId|"_userID_"^wardId|"_wardId_"^wardDesc|"_wardDesc
	.s ret=ret_"^releaseId|"_realeaseRW_"^ReleaseDesc|"_ReleaseDesc
	.s ret=ret_"^ExamDate|"_ExamDate_"^rw|"_id_"^AnslyFlag|"_AnslyFlag_"^AnslyFlagDesc|"_AnslyFlagDesc
	.s ret=ret_"^ExamAnslyScore|"_ExamAnslyScore_"^Anslyor|"_Anslyor_"^EditFlag|"_EditFlag
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExamAnalysListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExamAnalysListExecute ]
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

ClassMethod FindExamAnalysListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExamAnalysListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-17
/// Description:获取阅卷题
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindExamAnlysSubList","1",0)
Query FindExamAnlysSubList(rw As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindExamAnlysSubListExecute(ByRef qHandle As %Binary, rw As %String = "", loginID As %String = "") As %Status
{
	s ^TMP("FindExamAnlysSubList")=rw_"%"_loginID
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",nowDate=+$H
	s obj=$g(^DHCINM.Tea.ExamTheoryD(rw))
	if obj="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s AnslyFlag=$lg(obj,11)
	s Anslyor=$lg(obj,12)
	s AnswerTimes=$lg(obj,10)
	s subid="" f  s subid=$O(^DHCINM.Tea.ExamTheorySubD(rw,subid)) q:subid=""  d
	.s subObj=$g(^DHCINM.Tea.ExamTheorySubD(rw,subid))
	.q:subObj=""
	.s subAnswerTimes=$lg(subObj,16)
	.q:subAnswerTimes'=AnswerTimes
	.s SubMode=$lg(subObj,9)
	.q:SubMode'="A"
	.s SubDesc=$lg(subObj,7)
	.s ExamScore=$lg(subObj,5)
	.s Result=$lg(subObj,3)
	.s SubAnswer=$lg(subObj,12)
	.s AnalyContext=$lg(subObj,18)
	.s GetScore=$lg(subObj,4)
	.s ret="SubDesc|"_SubDesc_"^ExamScore|"_ExamScore_"^Result|"_Result_"^SubAnswer|"_SubAnswer
	.s ret=ret_"^AnalyContext|"_AnalyContext_"^GetScore|"_GetScore_"^rw|"_rw_"||"_subid_"^AnslyFlag|"_AnslyFlag
	.s ret=ret_"^Anslyor|"_Anslyor
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExamAnlysSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExamAnlysSubListExecute ]
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

ClassMethod FindExamAnlysSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExamAnlysSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2022-05-17
/// Description:保存阅卷
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveExamAnlys("1||3」2」测啊手动阀",1,0)
ClassMethod SaveExamAnlys(parr, par, APPLoginID) As %String
{
	s obj=##class(DHCINM.Tea.ExamTheory).%OpenId(par)
	q:'$IsObject(obj) "未获取数据,请刷新重试"
	q:obj.AnslyFlag'="Y" "已阅卷,不可重复批阅"
	q:obj.Anslyor'=APPLoginID "非阅卷人,不可阅卷"
	s obj.AnslyFlag="N"
	s obj.AnslyDate=+$H
	s obj.AnslyTime=$P($H,",",2)
	s ExamAnslyScore=0
	s sc=1
	TS
	f i=1:1:$L(parr,"「") q:sc'=1  d
	.s rowData=$P(parr,"「",i)
	.q:rowData=""
	.s rw=$P(rowData,"」",1)
	.q:rw=""
	.s subObj=##class(DHCINM.Tea.ExamTheorySub).%OpenId(rw)
	.q:'$IsObject(subObj)
	.s score=$P(rowData,"」",2)
	.s AnalyContext=$P(rowData,"」",3)
	.s subObj.GetScore=score
	.s subObj.AnalyContext=AnalyContext
	.s subObj.AnslyFlag="N"
	.s sc=$$$ISOK(subObj.%Save())
	.s ExamAnslyScore=ExamAnslyScore+score
	i sc'=1 {
		TRO
		q "保存答题失败"	
	}
	s obj.ExamAnslyScore=ExamAnslyScore
	s obj.ExamScore=ExamAnslyScore+obj.ExamAutoScore
	s sc=$$$ISOK(obj.%Save())
	if sc=1{
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-07-17
/// Description:查看答题
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindExamViewList","24",0)
Query FindExamViewList(rw As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindExamViewListExecute(ByRef qHandle As %Binary, rw As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",nowDate=+$H
	s obj=$g(^DHCINM.Tea.ExamTheoryD(rw))
	if obj="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s AnslyFlag=$lg(obj,11)
	s Anslyor=$lg(obj,12)
	s AnswerTimes=$lg(obj,10)
	s subid="" f  s subid=$O(^DHCINM.Tea.ExamTheorySubD(rw,subid)) q:subid=""  d
	.s subObj=$g(^DHCINM.Tea.ExamTheorySubD(rw,subid))
	.q:subObj=""
	.s subAnswerTimes=$lg(subObj,16)
	.q:subAnswerTimes'=AnswerTimes
	.s SubMode=$lg(subObj,9)
	.s SubDesc=$lg(subObj,7)
	.s ExamScore=$lg(subObj,5)
	.s Result=$lg(subObj,3)
	.s SubAnswer=$lg(subObj,12)
	.s AnalyContext=$lg(subObj,18)
	.s GetScore=$lg(subObj,4)
	.s SubOptionLB=$LG(subObj,11),SubOption=""
	.s SubUrl=""
	.s SubUrlLB=$LG(subObj,8)
	.f i=1:1:$LL(SubUrlLB)  d
	..s tSubUrl=$LG(SubUrlLB,i)
	..q:tSubUrl=""
	..i SubUrl="" s SubUrl=tSubUrl
	..e  d
	...s SubUrl=SubUrl_","_tSubUrl
	.f i=1:1:$LL(SubOptionLB) d
	..s tSubOption=$LG(SubOptionLB,i)
	..q:tSubOption=""
	..i SubOption="" s SubOption=tSubOption
	..e  d
	...s SubOption=SubOption_"」"_tSubOption
	.s CorrectFlag=$lg(subObj,15)
	.s ret="SubDesc|"_SubDesc_"^ExamScore|"_ExamScore_"^Result|"_Result_"^SubAnswer|"_SubAnswer
	.s ret=ret_"^AnalyContext|"_AnalyContext_"^GetScore|"_GetScore_"^rw|"_rw_"||"_subid_"^AnslyFlag|"_AnslyFlag
	.s ret=ret_"^Anslyor|"_Anslyor_"^SubOption|"_SubOption_"^SubMode|"_SubMode_"^SubUrl|"_SubUrl_"^CorrectFlag|"_CorrectFlag
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExamViewListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExamViewListExecute ]
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

ClassMethod FindExamViewListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExamViewListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: ChenPeng
/// Createdate:2023-03-06
/// Description: 保存应急预案演练附件
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveEmgPlanRefer("RowID|5^Refer|Fileupdate/images/teach/emgplan/1/test.png")
ClassMethod SaveEmgPlanRefer(parr As %String)
{
    s gParam=""
    s nFlag=##class(web.INMVueComm).SplitStr(parr,"^","|",.gParam)
    s rowId=$g(gParam("RowID"))
    s pRefer=$g(gParam("Refer"))
    
    s obj=##class(DHCINM.Tea.EmrPlanTest).%OpenId(rowId)
    s lbRefer=$lfs(obj.Refer)
    s idx=$lf(lbRefer,pRefer)
    i idx>0 d
    .s $list(lbRefer,idx,idx)=""
    s $list(lbRefer,*+1)=pRefer
    
    s obj.Refer=$lts(lbRefer)
    s sc=obj.%Save()
    q:$$$ISOK(sc) obj.%Id()
    q:$$$ISERR(sc) 0
}

/// Creator: ChenPeng
/// Createdate:2023-03-06
/// Description: 删除应急预案演练附件
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","DeleteEmgPlanRefer","RowID|5^Refer|Fileupdate/images/teach/emgplan/1/test.png")
ClassMethod DeleteEmgPlanRefer(parr As %String)
{
    s gParam=""
    s nFlag=##class(web.INMVueComm).SplitStr(parr,"^","|",.gParam)
    s rowId=$g(gParam("RowID"))
    s pRefer=$g(gParam("Refer"))
    
    s obj=##class(DHCINM.Tea.EmrPlanTest).%OpenId(rowId)
    s lbRefer=$lfs(obj.Refer)
    s idx=$lf(lbRefer,pRefer)
    i idx>0 d
    .s $list(lbRefer,idx,idx)=""
    
    s obj.Refer=$lts(lbRefer)
    s sc=obj.%Save()
    q:$$$ISOK(sc) obj.%Id()
    q:$$$ISERR(sc) 0
}

/// Creator:lulin
/// Createdate:2023-03-20
/// Description:保存题库文件夹
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveDrillFile("ParentDR|0^FileDesc|测试^Ward|6^Status|Y^rw|","0")
ClassMethod SaveDrillFile(parr As %String, APPLoginID As %String = "") As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s parID=$g(tmp("ParentDR"))
	q:$d(^DHCINM.Tea.DrillFileSubI("FileDR",parID)) "此节点已上传课件,不可新建子节点"
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(APPLoginID,"hlb,hlbzr",+$H)
	//父节点已上传文件不可新建子节点
	//非护理部、创建者，不可修改
	//
	i rw="" d
	.s obj=##class(DHCINM.Tea.DrillFile).%New()
	.s obj.CreateDate=+$H
	.s obj.Creator=APPLoginID
	e  s obj=##class(DHCINM.Tea.DrillFile).%OpenId(rw)
	q:((obj.Creator'=APPLoginID)&&(isHLB'=1)) "非创建者或者护理部人员不可修改"
	s className="DHCINM.Tea.DrillFile"
	s customKey=$LB("AuditorList","Ward","CreateDate","Creator")
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.i $D(tmp(p)) d
	..s value=tmp(p)
	..s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	..s $ZOBJPROPERTY(obj,p)=value
	d obj.Ward.Clear()
	s wards=$g(tmp("Ward"))
	f i=1:1:$l(wards,",") d
	.s wardID=$P(wards,",",i)
	.q:wardID=""
	.d obj.Ward.Insert(wardID)
	d obj.%Save()
	q 1
}

ClassMethod setLookTmp(id, lookTmp) As %String
{
	q:id="" ""
	s objLB=$g(^DHCINM.Tea.DrillFileD(id))
	q:objLB="" ""
	s lookTmp(id)=id
	s parID=$lg(objLB,2)
	d ..setLookTmp(parID,.lookTmp)
	q ""
}

ClassMethod writeDrillFile(par, isHLB, APPLoginID, lookTmp, noStop) As %String
{
	w "["
	s isFirst=1
	s id="" f  s id=$O(^DHCINM.Tea.DrillFileI("par"," "_par,id)) q:id=""  d
	.q:'$d(lookTmp(id))
	.s objLB=$G(^DHCINM.Tea.DrillFileD(id))
	.q:objLB=""
	.s label=$lg(objLB,3)
	.s Status=$lg(objLB,5)
	.s creator=$lg(objLB,6)
	.s auditorList=$lg(objLB,8)
	.s stopFlag=0
	.q:((noStop=1)&&(Status="N"))
	.s:Status="N" stopFlag=1
	.s editFlag=0
	.s:((isHLB=1)||(creator=APPLoginID)) editFlag=1
	.s auditFlag=0
	.s:((editFlag=1)||($lf(auditorList,APPLoginID)>0)) auditFlag=1
	.w:isFirst'=1 ","
	.w "{"_"""id"""_":"""_id_""",""label"":"""_label_""",""stopFlag"":"""_stopFlag_""",""editFlag"":"""_editFlag_""""
	.w ",""value"":"""_id_""",""auditFlag"":"""_auditFlag_""""
	.s childId=$O(^DHCINM.Tea.DrillFileI("par"," "_id,""))
	.i childId'="" d
	..w ",""children"":"
	..d ..writeDrillFile(id,isHLB,APPLoginID,.lookTmp, noStop)
	.w "}"
	.s isFirst=0
	w "]"
	q ""
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:获取培训课件
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).FindDrillFile(0)
ClassMethod FindDrillFile(APPLoginID As %String = "", noStop As %String = "") As %Text
{
	s nowDate=+$H
	s tmp=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(APPLoginID,.tmpWard)
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(APPLoginID,"hlb,hlbzr",+$H)
	k lookTmp
	s lookTmp=""
	
	//先循环，看有那些文件夹预览权限，
	//循环输出树形结构
	s id="" f  s id=$O(^DHCINM.Tea.DrillFileD(id)) q:id=""  d
	.q:$d(^DHCINM.Tea.DrillFileI("par"," "_id))
	.s objLB=$g(^DHCINM.Tea.DrillFileD(id))
	.q:objLB=""
	.s Status=$lg(objLB,5)
	.s wardList=$lg(objLB,4)
	.s flag=0
	.i wardList="" d
	..s flag=1
	.e  i wardList'="" d
	..f wardIndex=1:1:$LL(wardList) q:flag=1  d
	...s wardID=$lg(wardList,wardIndex)
	...q:wardID=""
	...s:((isAll=1)||$d(tmpWard(wardID))) flag=1
	.q:flag=0
	.s lookTmp(id)=id
	.s parID=$lg(objLB,2)
	.d ..setLookTmp(parID,.lookTmp)
	d ..writeDrillFile(0,isHLB,APPLoginID,.lookTmp,noStop)
	q ""
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:获取培训课件文件夹
/// Input:
/// Output:
/// Other:
ClassMethod GetDrillFile(id) As %String
{
	s obj=##class(DHCINM.Tea.DrillFile).%OpenId(id)
	s className="DHCINM.Tea.DrillFile"
	s customKey=$LB("AuditorList","Ward","CreateDate","Creator")
	s ret="rw|"_id
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.s value=$ZOBJPROPERTY(obj,p)
	.s ret=ret_"^"_p_"|"_value
	s wardList=""
	f i=1:1:obj.Ward.Count()  d
	.s wardID=obj.Ward.GetAt(i)
	.q:wardID=""
	.s:wardList'="" wardList=wardList_","
	.s wardList=wardList_wardID
	s ret=ret_"^Ward|"_wardList
	q ret
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:停用培训课件文件夹
/// Input:
/// Output:
/// Other:
ClassMethod StopDrillFile(id) As %String
{
	s obj=##class(DHCINM.Tea.DrillFile).%OpenId(id)
	s obj.Status="N"
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:删除培训课件文件夹
/// Input:
/// Output:
/// Other:
ClassMethod DelDrillFile(id, APPLoginID As %String = "") As %String
{
	q:id="" "0^入参不能为空"
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(APPLoginID,"hlb,hlbzr",+$H)
	s obj=##class(DHCINM.Tea.DrillFile).%OpenId(id)
	q:'$IsObject(obj) "0^未找到相关数据,请刷新重试"
	q:((obj.Creator'=APPLoginID)&&(isHLB'=1)) "0^非创建者或护理部人员不可删除"
	s usedFlag=0
	q:$d(^DHCINM.Tea.DrillFileI("par"," "_id)) "0^存在子节点不可删除"
	s FileUrlList=""
	k delFileSubTmp
	s delFileSubTmp=""
	s subID="" f  s subID=$O(^DHCINM.Tea.DrillFileSubI("file",id,subID)) q:((subID="")||(usedFlag=1))  d
	.s subObjLB=$g(^DHCINM.Tea.DrillFileSubD(subID))
	.q:subObjLB=""
	.s usedFlag=..IsUsedDrillSub(subID)
	.q:usedFlag'=0
	.s tFileUrl=$lg(subObjLB,10)
	.q:tFileUrl=""
	.s:FileUrlList'="" FileUrlList=FileUrlList_","
	.s FileUrlList=FileUrlList_tFileUrl
	.s delFileSubTmp(subID)=subID
	q:usedFlag=1 "0^文件加下存在课件已被使用，不可删除"
	s sc=1
	TS
	s subID="" f  s subID=$O(delFileSubTmp(subID)) q:((subID="")||(sc=""))  d
	.s sc=$$$ISOK(##class(DHCINM.Tea.DrillFileSub).%DeleteId(subID))
	if sc'=1{
		TRO
		q "0^删除文件夹下文件失败"
	}
	s sc=$$$ISOK(##class(DHCINM.Tea.DrillFile).%DeleteId(id))
	if sc '=1{
		TRO
		q "0^删除文件夹失败"
	}
	TC
	q "1^"_FileUrlList
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:添加审批人
/// Input:
/// Output:
/// Other:
ClassMethod insertDrillAuditor(parr As %String = "", APPLoginID As %String = "")
{
	s id=$P(parr,"^",1)
	s perDR=$P(parr,"^",2)
	q:((id="")||(perDR="")) "入参不能为空"
	s obj=##class(DHCINM.Tea.DrillFile).%OpenId(id)
	q:'$IsObject(obj) "未找到对应文件夹信息，请刷新重试"
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(APPLoginID,"hlb,hlbzr",+$H)
	q:((isHLB'=1)&&(obj.Creator'=APPLoginID)) "非创建人、护理部不可授权"
	i obj.AuditorList.Find(perDR)<1 d
	.d obj.AuditorList.Insert(perDR)
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:添加审批人
/// Input:
/// Output:
/// Other:
ClassMethod DelDrillAuditor(parr As %String = "", APPLoginID As %String = "")
{
	s id=$P(parr,"^",1)
	s perDR=$P(parr,"^",2)
	q:((id="")||(perDR="")) "入参不能为空"
	s obj=##class(DHCINM.Tea.DrillFile).%OpenId(id)
	q:'$IsObject(obj) "未找到对应文件夹信息，请刷新重试"
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(APPLoginID,"hlb,hlbzr",+$H)
	q:((isHLB'=1)&&(obj.Creator'=APPLoginID)) "非创建人、护理部不可删除授权"
	s index=obj.AuditorList.Find(perDR)
	d:index>0 obj.AuditorList.RemoveAt(index)
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:查询培训课件审批人
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindDrillFileAuditorList","3^",0)
Query FindDrillFileAuditorList(parr As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindDrillFileAuditorListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id=$P(parr,"^",1)
	if ((id="")||(id=0)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s obj=##class(DHCINM.Tea.DrillFile).%OpenId(id)
	if ('$IsObject(obj)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	f i=1:1:obj.AuditorList.Count() d
	.s perID=obj.AuditorList.GetAt(i)
	.q:perID=""
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perID)
	.q:'$IsObject(perObj)
	.s perDepDR=perObj.PerDepDR
	.s WardDesc=""
	.s:perDepDR'="" WardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(perDepDR)),4)
	.s ret="perDR|"_perID_"^perName|"_perObj.PerName_"^WardDesc|"_WardDesc_"^id|"_id
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDrillFileAuditorListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDrillFileAuditorListExecute ]
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

ClassMethod FindDrillFileAuditorListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDrillFileAuditorListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:保存培训课件
/// Input:
/// Output:
/// Other:
ClassMethod SaveDrillFileSub(parr As %String = "", APPLoginID As %String = "") As %String
{
	s ^TMP("SaveDrillFileSub")=parr_"%"_APPLoginID
	s FileDR=$P(parr,"||",1)
	s SubDesc=$P(parr,"||",2)
	s SubFile=$P(parr,"||",3)
	q:((SubFile="")||(FileDR="")||(SubDesc="")) "入参不能为空"
	s obj=##class(DHCINM.Tea.DrillFileSub).%New()
	s obj.FileUrl=SubFile
	d obj.FileDRSetObjectId(FileDR)
	s obj.CreatDate=+$H
	s obj.Creator=APPLoginID
	s obj.StartStatus="Y"
	s obj.Status="N"
	s obj.SubDesc=SubDesc
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:更新培训课件
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).UpdateDrillFileSub("rw|1^StartStatus|Y^FileDR|3",0)
ClassMethod UpdateDrillFileSub(parr As %String = "", APPLoginID As %String = "") As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	q:rw="" "入参为空"
	s obj=##class(DHCINM.Tea.DrillFileSub).%OpenId(rw)
	q:'$IsObject(obj) "未找到对象"
	d obj.FileDRSetObjectId($g(tmp("FileDR")))
	s obj.StartStatus=$g(tmp("StartStatus"))
	d obj.%Save()
	q 1
}

ClassMethod GetFillFullUrl(id) As %String
{
	q:id=0 0
	s obj=$g(^DHCINM.Tea.DrillFileD(id))
	q:obj="" ""
	s parID=$lg(obj,2)
	s parUrl=""
	s:parID'="" parUrl=..GetFillFullUrl(parID)
	q parUrl_","_id
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:获取培训课件
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).GetDrillFileSub(1)
ClassMethod GetDrillFileSub(id) As %String
{
	
	s obj=##class(DHCINM.Tea.DrillFileSub).%OpenId(id)
	s className="DHCINM.Tea.DrillFileSub"
	s customKey=$LB("FileDR")
	s ret="rw|"_id
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.s value=$ZOBJPROPERTY(obj,p)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.s ret=ret_"^"_p_"|"_value
	.i ((p="Creator")||(p="Auditor")) d
	..s userName=""
	..i value=0 d
	...s userName="超级管理员"
	..e  i value'=""  d
	...s userName=$lg($g(^CF.DHCINM.DB.MgUserD(value)),2)
	..s ret=ret_"^"_p_"Name|"_userName
	s FileDR=""
	s:$IsObject(obj.FileDR) FileDR=obj.FileDR.%Id()
	s ret=ret_"^FileDR|"_FileDR
	s FilrFullUrl=""
	s:FileDR'="" FilrFullUrl=..GetFillFullUrl(obj.FileDR.%Id())
	s ret=ret_"^FilrFullUrl|"_FilrFullUrl
	q ret
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:获取培训课件
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).GetDrillFileSub(1)
ClassMethod DelDrillFileSub(rw, APPLoginID As %String = "") As %String
{
	q:rw="" "入参不能为空"
	s obj=##class(DHCINM.Tea.DrillFileSub).%OpenId(rw)
	q:'$IsObject(obj) "未找到删除文件,请刷新重试"
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(APPLoginID,"hlb,hlbzr",+$H)
	q:((obj.Creator'=APPLoginID)&&(isHLB'=1)) "非创建者或护理部人员不可删除"
	q:..IsUsedDrillSub(rw)'=0 "课件已被使用，不可删除"
	d obj.%DeleteId(rw)
	q 1
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:审核培训课件
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).AuditDrillFileSub(4)
ClassMethod AuditDrillFileSub(ids, APPLoginID As %String = "") As %String
{
	q:ids="" "入参不能为空"
	f i=1:1:$L(ids,",") d
	.s rw=$P(ids,",",i)
	.q:rw=""
	.s obj=##class(DHCINM.Tea.DrillFileSub).%OpenId(rw)
	.q:'$IsObject(obj)
	.s obj.Status="Y"
	.s obj.Auditor=APPLoginID
	.d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2023-03-21
/// Description:查询培训课件
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindDrillFileSubList","3^",0)
Query FindDrillFileSubList(parr As %String = "", APPLoginID As %String = "", noStop As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindDrillFileSubListExecute(ByRef qHandle As %Binary, parr As %String = "", APPLoginID As %String = "", noStop As %String = "") As %Status
{
	s ^TMP("FindDrillFileSubList")=parr_"%"_APPLoginID_"%"_noStop
	s repid=$I(^CacheTemp)
	s ind=1
	s fileDR=$P(parr,"^",1)
	if ((fileDR="")||(fileDR=0)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s fileObj=$g(^DHCINM.Tea.DrillFileD(fileDR))
	if (fileObj="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(APPLoginID,"hlb,hlbzr",+$H)
	s AuditorList=$lg(fileObj,8)
	s filesCreator=$lg(fileObj,6)
	s id="" f  s id=$O(^DHCINM.Tea.DrillFileSubI("file",fileDR,id)) q:id=""  d
	.s objLB=$g(^DHCINM.Tea.DrillFileSubD(id))
	.q:objLB=""
	.s Status=$lg(objLB,8)
	.s StartStatus=$lg(objLB,9)
	.q:((noStop=1)&&(StartStatus="N"))
	.q:((noStop=1)&&(Status="N"))
	.s Creator=$lg(objLB,4)
	.b ;02
	.q:((Status="N")&&(Creator'=APPLoginID)&&(filesCreator'=APPLoginID)&&($lf(AuditorList,APPLoginID)<1))
	.s ret=..GetDrillFileSub(id)
	.s editFlag=0
	.i ((isHLB=1)||(APPLoginID=Creator)) d
	..s editFlag=1
	.s ret=ret_"^editFlag|"_editFlag
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDrillFileSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDrillFileSubListExecute ]
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

ClassMethod FindDrillFileSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDrillFileSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 课件是否被使用
ClassMethod IsUsedDrillSub(id) As %String
{
	q $d(^DHCINM.Tea.DrillReleaseI("dirllFileSubDR"," "_id))
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存考核培训发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveDrillRelease(^TMP("SaveDrillRelease"))
ClassMethod SaveDrillRelease(parr As %String) As %String
{
	s ^TMP("SaveDrillRelease")=parr
	
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	i rw="" d
	.s obj=##class(DHCINM.Tea.DrillRelease).%New()
	.s obj.CreatDate=+$H
	.s obj.CreatTime=$P($H,",",2)
	e  s obj=##class(DHCINM.Tea.DrillRelease).%OpenId(rw)
	q:(obj.Status="Y") "已发布不可修改"
	s className="DHCINM.Tea.DrillRelease"
	s customKey=$LB()
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i $D(tmp(p)) d
	..s value=tmp(p)
	..s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	..i ((ptype="date")&&(value'="")) d
	...s value=$zdh(value,3)
	..e  d
	...s classData=^oddCOM(className,"a",p,40)
	...i classData="%Collection.ListOfDT" d
	....i value'="" d
	.....d:p="videoQuestion" obj.videoQuestion.Clear()
	.....d:p="TimeList" obj.TimeList.Clear()
	.....d:p="ClassQuesRange" obj.ClassQuesRange.Clear()
	.....d:p="ResultTimeList" obj.ResultTimeList.Clear()
	.....d:p="ResultQuesRange" obj.ResultQuesRange.Clear()
	.....f i=1:1:$L(value,"「") d
	......s rowData=$P(value,"「",i)
	......q:rowData=""
	......d:p="videoQuestion" obj.videoQuestion.Insert(rowData)
	......d:p="TimeList" obj.TimeList.Insert(rowData)
	......d:p="ClassQuesRange" obj.ClassQuesRange.Insert(rowData)
	......d:p="ResultTimeList" obj.ResultTimeList.Insert(rowData)
	......d:p="ResultQuesRange" obj.ResultQuesRange.Insert(rowData)
	....s:value'="" value=$LFS(value,"「")
	..s $ZOBJPROPERTY(obj,p)=value
	d obj.ClassQuesRangeI.Clear()
	s error=""
	i ((obj.ClassPaperType="I")&&(obj.ClassDraw="Y")) d
	.d obj.ClassQuesRangeI.Clear()
	.k retTmp
	.s retTmp=""
	.s error=..SetIntellectExamTheoryTmp(.retTmp,obj.ClassQuesRange)
	.s problemId="" f  s problemId=$O(retTmp(problemId)) q:problemId=""  d
	..s score=retTmp(problemId)
	..s rowData=problemId_"」"_score
	..d obj.ClassQuesRangeI.Insert(rowData)
	q:error'="" error
	
	d obj.ResultQuesRangeI.Clear()
	s error=""
	i ((obj.ResultMode="T")&&(obj.ResultPaperType="I")&&(obj.ResultDraw="Y")) d
	.d obj.ResultQuesRangeI.Clear()
	.k retTmp
	.s retTmp=""
	.s error=..SetIntellectExamTheoryTmp(.retTmp,obj.ResultQuesRange)
	.s problemId="" f  s problemId=$O(retTmp(problemId)) q:problemId=""  d
	..s score=retTmp(problemId)
	..s rowData=problemId_"」"_score
	..d obj.ResultQuesRangeI.Insert(rowData)
	
	q:error'="" error
	s sc=$$$ISOK(obj.%Save())
	if sc{
		q obj.%Id()	
	}else{
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:获取培训发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).GetDrillRelease(1)
ClassMethod GetDrillRelease(rw) As %String
{
	q:rw="" "入参为空"
	s obj=##class(DHCINM.Tea.DrillRelease).%OpenId(rw)
	s className="DHCINM.Tea.DrillRelease"
	s customKey=$LB()
	s listGlobalIndex("videoQuestion")=23
	s listGlobalIndex("TimeList")=24
	s listGlobalIndex("ClassQuesRange")=34
	s listGlobalIndex("ResultTimeList")=42
	s listGlobalIndex("ResultQuesRange")=45
	s listGlobalIndex("ClassQuesRangeI")=59
	s listGlobalIndex("ResultQuesRangeI")=60
	s ret="rw|"_rw
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.s value=$ZOBJPROPERTY(obj,p)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=$zd(value,3)
	.e  d
	..s classData=^oddCOM(className,"a",p,40)
	..i classData="%Collection.ListOfDT" d
	...s valueLB=$LG(^DHCINM.Tea.DrillReleaseD(rw),listGlobalIndex(p))
	...i valueLB'="" d
	....s valueString=""
	....f i=1:1:$LL(valueLB) d
	.....s rowData=$LG(valueLB,i)
	.....q:rowData=""
	.....s:valueString'="" valueString=valueString_"「"
	.....s valueString=valueString_rowData
	....s value=valueString
	...e  s value=""
	.s ret=ret_"^"_p_"|"_value


	;考核人群
	s ExamineeList="",ExamineeListDesc=""
	f i=1:1:$L(obj.ExamineeList,",")  d
	.s rowData=$P(obj.ExamineeList,",",i)
	.q:rowData=""
	.s tRowDataDesc=##class(web.INMDBComm).GetCommCode(rowData)
	.i ExamineeList="" d
	..s ExamineeList=rowData,ExamineeListDesc=tRowDataDesc 
	.e  d
	..s ExamineeList=ExamineeList_","_rowData,ExamineeListDesc=ExamineeListDesc_","_tRowDataDesc
	s ret=ret_"^ExamineeListDesc|"_obj.Examinee_":"_ExamineeListDesc
	s wardDesc=""
	f i=1:1:$L(obj.ExamineeWard,",") d
	.s wardID=$P(obj.ExamineeWard,",",i)
	.q:wardID=""
	.s tWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(wardID)),4)
	.i wardDesc="" s wardDesc=tWardDesc
	.e  s wardDesc=wardDesc_","_tWardDesc
	s ret=ret_"^ExamineeWardDesc|"_wardDesc
	q ret
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:撤销培训发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).CanselDrillReleasePublish(1,0)
ClassMethod CanselDrillReleasePublish(rw, loginID) As %String
{
	s obj=##class(DHCINM.Tea.DrillRelease).%OpenId(rw)
	q:'$IsObject(obj) "无此记录信息"
	s oldStatus=obj.Status
	q:obj.Creator'=loginID "非创建者不可撤销发布"
	q:((oldStatus'="Y")) "非已发布,不可撤销"
	s isUsed=0
	s subID="" f  s subID=$O(^DHCINM.Tea.DrillReleaseSubD(rw,subID)) q:((subID="")||(isUsed'=0))  d
	.s subObjLB=$g(^DHCINM.Tea.DrillReleaseSubD(rw,subID))
	.q:subObjLB=""
	.s DrillStep=$lg(subObjLB,9)
	.;s:OrderFlag="Y" isUsed=1
	.s:DrillStep>0 isUsed=1
	
	q:isUsed'=0 "已考核,不可撤销"
	s obj.Status="N"
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2023-04-23
/// Description:删除培训发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).DeleteExamRelease(rw,loginID)
ClassMethod DeleteDrillRelease(rw, loginID) As %String
{
	s obj=##class(DHCINM.Tea.DrillRelease).%OpenId(rw)
	q:'$IsObject(obj) "无此记录信息"
	s oldStatus=obj.Status
	q:(oldStatus'="N") "非未发布信息,不可删除"
	q:obj.Creator'=loginID "非创建者不可删除"
	d obj.%DeleteId(rw)
	q 1
}

/// Creator:lulin
/// Createdate:2023-04-23
/// Description:获取调查信息
/// Input:
/// Output:
/// Other:
ClassMethod GetDrillSurvey(rw, type) As %String
{
	s id=$O(^DHCINM.Survey.MgFormI("evaluateDR"," "_type," "_rw,""))
	s Status="A",SubmitDate="",StatusDesc="未评价",TotalScore=""
	i id'="" d
	.s obj=##class(DHCINM.Survey.MgForm).%OpenId(id)
	.s Status=obj.Status
	.s StatusDesc="已保存"
	.s:Status="Y" StatusDesc="已提交"
	.s SubmitDate=obj.SubmitDate
	.s:SubmitDate'="" SubmitDate=$zd(SubmitDate,3)
	.s TotalScore=obj.TotalScore
	s ret="EvaluateDR|"_rw_"^Type|"_type_"^Status|"_Status_"^RowId|"_id_"^SubmitDate|"_SubmitDate
	_"^StatusDesc|"_StatusDesc_"^TotalScore|"_TotalScore
	q ret
}

ClassMethod GetDrillSurveyStatus(rw, type) As %String
{
	s id=$O(^DHCINM.Survey.MgFormI("evaluateDR"," "_type," "_rw,""))
	s Status="A"
	i id'="" d
	.s obj=##class(DHCINM.Survey.MgForm).%OpenId(id)
	.s Status=obj.Status
	q Status
}

/// Creator:lulin
/// Createdate:2023-04-23
/// Description:获取培训人员明细信息
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).getDrillReleaseSub("1||1")
ClassMethod getDrillReleaseSub(rw) As %String
{
	s obj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(rw)
	s ret="subID|"_rw
	s className="DHCINM.Tea.DrillReleaseSub"
	s customKey=$LB("HomeworkUrl","ExceptionDR")
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.b:p="HomeworkUrl"
	.s value=$ZOBJPROPERTY(obj,p)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=$zd(value,3)
	.s ret=ret_"^"_p_"|"_value
	s ExceptionDR=""
	s:obj.ExceptionDR'="" ExceptionDR=obj.ExceptionDR.%Id()
	s ret=ret_"^ExceptionDR|"_ExceptionDR
	s HomeworkUrl=""
	f i=1:1:obj.HomeworkUrl.Count() d
	.q:obj.HomeworkUrl.GetAt(i)=""
	.s:HomeworkUrl'="" HomeworkUrl=HomeworkUrl_","
	.s HomeworkUrl=HomeworkUrl_obj.HomeworkUrl.GetAt(i)
	s ret=ret_"^HomeworkUrl|"_HomeworkUrl
	s perNo="",perName=""
	i obj.UserDR'="" d
	.s userObj=$g(^CF.DHCINM.DB.MgUserD(obj.UserDR))
	.i userObj'="" d
	..s perNo=$lg(userObj,3)
	..s perName=$lg(userObj,2)
	s ret=ret_"^perNo|"_perNo_"^perName|"_perName
	s wardDesc=""
	s:obj.WardDR'="" wardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(obj.WardDR)),4)
	s ret=ret_"^wardDesc|"_wardDesc
	;签到
	s SignData="",UseStatusDesc1="未完成"
	i obj.SignStartTime'="" d
	.s SignData="签到"
	i obj.SignEndTime'="" d
	.s:SignData'="" SignData=SignData_","
	.s SignData=SignData_"签退"
	s:((obj.SignStartTime'="")&&(obj.SignEndTime'="")) UseStatusDesc1="已通过"
	s ret=ret_"^SignData|"_SignData_"^UseStatusDesc1|"_UseStatusDesc1
	
	;视频进度
	s videoTimeRate=0,UseStatusDesc2="未完成"
	i obj.videoCurrentTime'="" d
	.s videoTimeRate=$fn(obj.UseHomeworkScore/obj.videoCurrentTime*100,0)
	s:videoTimeRate>=90 UseStatusDesc2="已完成"
	s:videoTimeRate>=95 UseStatusDesc2="已通过"
	s ret=ret_"^videoTimeRate|"_videoTimeRate_"%"_"^UseStatusDesc2|"_UseStatusDesc2
	;视频插题
	s UseStatusDesc3="未完成"
	i obj.videoAnswerNum>=obj.Parref.videoQuestion.Count() d
	.s UseStatusDesc3="已完成"
	s:obj.videoRightNum>=obj.Parref.videoPass UseStatusDesc3="已通过"
	s ret=ret_"^UseStatusDesc3|"_UseStatusDesc3
	;随堂练习
	s UseStatusDesc4="未完成"
	i obj.classDate'="" d
	.s UseStatusDesc4="已完成"
	.s:obj.UseClassScore>=obj.Parref.videoPass UseStatusDesc4="已通过"
	s ret=ret_"^UseStatusDesc4|"_UseStatusDesc4
	;问卷调查
	s DrillUseSurveyStatus="提交"
	i obj.Parref.StudentClassDR'="" d 
	.s tStatus=..GetDrillSurveyStatus(rw,"DC")
	.s:tStatus'="Y" DrillUseSurveyStatus="未提交"
	i obj.Parref.StudentTeacherDR'="" d 
	.s tStatus=..GetDrillSurveyStatus(rw,"DT")
	.s:tStatus'="Y" DrillUseSurveyStatus="未提交"
	s UseStatusDesc5="未完成"
	s:DrillUseSurveyStatus="提交" UseStatusDesc5="已通过"
	s ret=ret_"^DrillUseSurveyStatus|"_DrillUseSurveyStatus_"^UseStatusDesc5|"_UseStatusDesc5
	;结课考核
	s UseStatusDesc6="未完成"
	i obj.ResultOpeUseDate'="" d
	.s UseStatusDesc6="已完成"
	.s:obj.UseResultScore>=obj.Parref.ResultPass UseStatusDesc6="已通过"
	s ret=ret_"^UseStatusDesc6|"_UseStatusDesc6
	;课后作业
	s UseStatusDesc7="未完成"
	i obj.HomeworkUrl'="" d
	.s UseStatusDesc7="已完成"
	.s:obj.UseHomeworkScore>=obj.Parref.HomeworkPass UseStatusDesc7="已通过"
	s ret=ret_"^UseStatusDesc7|"_UseStatusDesc7
	s reusltTmp(1)=UseStatusDesc1
	s reusltTmp(2)=UseStatusDesc2
	s reusltTmp(3)=UseStatusDesc3
	s reusltTmp(4)=UseStatusDesc4
	s reusltTmp(5)=UseStatusDesc5
	s reusltTmp(6)=UseStatusDesc6
	s reusltTmp(7)=UseStatusDesc7
	
	s DrillResultDesc="已通过"
	f i=1:1:$L(obj.Parref.passStand,",") q:DrillResultDesc'="已通过"  d
	.s resultIndex=$P(obj.Parref.passStand,",",i)
	.q:resultIndex=""
	.s:reusltTmp(resultIndex)'="已通过" DrillResultDesc="已完成"
	f i=1:1:$L(obj.Parref.finishStand,",") d
	.s resultIndex=$P(obj.Parref.finishStand,",",i)
	.q:resultIndex=""
	.s:reusltTmp(resultIndex)="未完成" DrillResultDesc="未完成"
	s ret=ret_"^DrillResultDesc|"_DrillResultDesc
	
	q ret
}

/// Creator:lulin
/// Createdate:2023-04-23
/// Description:查询培训任务发布
/// Input:parr:startDate^endDate^type,type:用途："":查询，"Y":考核，"N":引用,input,loginID
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindDrillReleaseList","^2023-06-01^^Y,N^S","","5")
Query FindDrillReleaseList(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindDrillReleaseListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s startDate=$P(parr,"^",1)
	i startDate["-" d
	.s startDate=$zdh(startDate,3)
	e  d
	.s startDate=""
	s endDate=$P(parr,"^",2)
	i endDate["-" d
	.s endDate=$zdh(endDate,3)
	e  d
	.s endDate=""
	s selecttype=$P(parr,"^",3) ;查询条件类型1:主题，2：类型，3：级别，4：状态
	s input=$zcvt(input,"U")
	s SelCoursesType=$P(parr,"^",4)
	s SelType=$P(parr,"^",5) //"",O:预约，S:"学员培训"，T:"讲师培训"
	s ret="",nowDate=+$H
	s isHLB=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"hlb,hlbzr,manager,admin",+$H)
	s isZurHead=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"znurhead",+$H)
	s isNurhead=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"nurhead",+$H)
	s loginPerID=""
	i loginID=0 d
	.s loginPerID=0
	e  d
	.s:$d(^CF.DHCINM.DB.MgUserD(loginID)) loginPerID=$lg($g(^CF.DHCINM.DB.MgUserD(loginID)),5)
	s id="" f  s id=$O(^DHCINM.Tea.DrillReleaseD(id),-1) q:id=""  d
	.s objLB=$g(^DHCINM.Tea.DrillReleaseD(id))
	.q:objLB=""
	.s ReleaseWay=$lg(objLB,2)
	.s status=$LG(objLB,55)
	.s tStartDate=$lg(objLB,5)
	.s tEndDate=$lg(objLB,6)
	.s Examiner=$lg(objLB,7)
	.q:((startDate'="")&&(startDate>tEndDate))
	.q:((endDate'="")&&(endDate<tStartDate))
	.s ReleaseLevel=$LG(objLB,4)
	.s statusDesc=$case(status,"Y":"已发布","N":"未发布,保存",:status)
	.s Creator=$LG(objLB,56)
	.q:((status'="Y")&&(Creator'=loginID))
	.q:((isHLB'=1)&&(Creator'=loginID)&&((SelType'="O")&&(SelType'="S")&&(SelType'="T")))
	.q:(((SelType="O")||(SelType="S"))&&('$d(^DHCINM.Tea.DrillReleaseSubI("User",id,loginID))))
	.q:((SelType="T")&&(Examiner'=loginPerID)&&loginID'=0) ;讲师培训仅讲师可见
	.q:((SelType="T")&&(status'="Y"))
	.;如果是预约，仅预约人可见
	.s CoursesType=$lg(objLB,15)
	.q:((SelCoursesType'="")&&(SelCoursesType'[CoursesType))
	.s existFlag=1
	.s:selecttype="" existFlag=0
	.s:input="" existFlag=0
	.i ((selecttype'="")&&(input'="")) d
	..i selecttype=1 d
	...s desc=$zcvt($LG(objLB,11),"U") ;主题
	...s:desc[input existFlag=0
	..i selecttype=2 d
	...s modeDesc=$case(ReleaseWay,"O":"线上","D":"线下",:mode) 
	...s:modeDesc[input existFlag=0
	..i selecttype=3 d
	...s levelDesc=$case(ReleaseLevel,"H":"院级","L":"科级","W":"病区",:mode) ;层级
	...s:levelDesc[input existFlag=0
	..i selecttype=4 d
	...s:statusDesc[input existFlag=0 ;状态
	.q:existFlag=1
	.s ret=..GetDrillRelease(id)
	.s TimeList=$lg(objLB,24)
	.s orderList=..GetOrderNum(id,TimeList)
	.s ret=ret_"^orderList|"_orderList ;预约人数
	.;预约
	.d:((SelType'="O")&&(SelType'="S")) OutputRowData
	.q:((SelType'="O")&&(SelType'="S")) ;学员培训
	.s startStatus="N"
	.s:tStartDate<=+$H startStatus="Y"
	.s:tEndDate<+$H startStatus="E"
	.s orderStatus="N" ;报名
	.s subID=$O(^DHCINM.Tea.DrillReleaseSubI("User",id,loginID,""))
	.q:subID=""
	.s subObj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(id_"||"_subID)
	.q:'$IsObject(subObj)
	.s OrderFlag=subObj.OrderFlag
	.q:OrderFlag'="Y"
	.s ret=ret_"^startStatus|"_startStatus_"^OrderFlag|"_OrderFlag
	.s ret=ret_"^"_..getDrillReleaseSub(id_"||"_subID)
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDrillReleaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDrillReleaseListExecute ]
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

ClassMethod FindDrillReleaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDrillReleaseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存考生并且发布
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveReleaseExaminee("2|1^3|1^4|1","2")
ClassMethod SaveDrillReleaseExaminee(parr, rw) As %String
{
	s obj=##class(DHCINM.Tea.DrillRelease).%OpenId(rw)
	q:'$IsObject(obj) "无此记录信息,请刷新重试"
	s oldStatus=obj.Status
	s obj.Status="Y"
	d obj.%Save()
	s tmpUser=""
	f i=1:1:$L(parr,"^") d
	.s user=$P(parr,"^",i)
	.q:user=""
	.s userId=$P(user,"|",1)
	.s wardDR=$P(user,"|",2)
	.q:userId=""
	.s tmpUser(userId)=wardDR
	.s subId=$O(^DHCINM.Tea.DrillReleaseSubI("User",rw,userId,""))
	.i subId="" d
	..s subObj=##class(DHCINM.Tea.DrillReleaseSub).%New()
	..s subObj.Parref=obj
	.e  d
	..s subObj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(rw_"||"_subId)
	.s subObj.UserDR=userId
	.s subObj.WardDR=wardDR
	.s:((obj.ReleaseWay="O")&&(obj.CoursesType="Y")) subObj.OrderFlag="Y",subObj.OrderNum=1
	.d subObj.%Save()
	s subId="" f  s subId=$O(^DHCINM.Tea.DrillReleaseSubD(rw,subId)) q:subId=""  d
	.s subObj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(rw_"||"_subId)
	.q:'$IsObject(subObj)
	.q:$d(tmpUser(subObj.UserDR))
	.q:subObj.ExceptionDR'=""  ;已置异常不可删除
	.s isUsed=0
	.s DrillStep=subObj.DrillStep
	.s:DrillStep>0 isUsed=1
	.q:isUsed'=0 ;已考核不可删除
	.d subObj.%DeleteId(rw_"||"_subId)
	q 1
}

ClassMethod GetOrderNum(rw, TimeList) As %String
{
	q:rw=""
	s timeNum=1
	s:TimeList'="" timeNum=$LL(TimeList)
	s num=$LB()
	f i=1:1:timeNum d
	.s $li(num,i)=0
	s subID="" f  s subID=$O(^DHCINM.Tea.DrillReleaseSubD(rw,subID)) q:subID=""  d
	.s objLB=$g(^DHCINM.Tea.DrillReleaseSubD(rw,subID))
	.q:objLB=""
	.s OrderFlag=$lg(objLB,8)
	.s OrderNum=$lg(objLB,7)
	.i ((OrderFlag="Y")&&(OrderNum'="")) d
	..s $li(num,OrderNum)=$lg(num,OrderNum)+1
	q $LTS(num,",")
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存培训报名
/// Input:
/// Output:
/// Other:
ClassMethod SaveDrillOrder(parr) As %String
{
	s subID=$P(parr,"^",1)
	s OrderFlag=$P(parr,"^",2)
	s OrderNum=$P(parr,"^",3)
	q:subID="" "未获取有效数据"
	s obj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId($tr(subID,"__","||"))
	q:'$IsObject(obj) "未获取有效数据"
	s obj.OrderFlag=OrderFlag
	s obj.OrderNum=OrderNum
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存培训报名
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveDrillSign("id^type")
ClassMethod SaveDrillSign(parr) As %String
{
	s id=$P(parr,"^",1)
	s type=$P(parr,"^",2)
	q:((id="")||(type="")) "入参为空,请刷新重试"
	s obj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId($tr(id,"__","||"))
	i type="S" d
	.s obj.SignStartTime=$zd(+$H,3)_" "_$zt($P($H,",",2),1)
	.s obj.DrillStep=1
	e  s obj.SignEndTime=$zd(+$H,3)_" "_$zt($P($H,",",2),1)
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存相关评论、提问\提问
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveDrillVideoInfo("id^type")
ClassMethod SaveDrillVideoInfo(parr, info) As %String
{
	s subID=$P(parr,"^",1)
	s type=$P(parr,"^",2)
	q:((subID="")||(type="")) "入参为空,请刷新重试"
	s subID=$tr(subID,"__","||")
	s parObj=##class(DHCINM.Tea.DrillRelease).%OpenId($P(subID,"||",1))
	s obj=##class(DHCINM.Tea.DrillVideoInfo).%New()
	s obj.Parref=parObj
	s obj.SubDR=subID
	s obj.context=info
	s obj.Type=type
	s obj.infoTime=$zd(+$H,3)_" "_$zt($P($H,",",2),1)
	d obj.%Save()
	q 1
}

/// Creator:lulin
/// Createdate:2023-04-23
/// Description:查询视频相关评论、提问\提问
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","LoadDrillVideoInfo","1__1^C")
Query LoadDrillVideoInfo(parr As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod LoadDrillVideoInfoExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s subID=$tr($P(parr,"^",1),"__","||")
	s type=$P(parr,"^",2)
	i ((subID="")||(type="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s parID=$P(subID,"||",1)
	s subDR="" f  s subDR=$O(^DHCINM.Tea.DrillVideoInfoI("Type",parID," "_type,subDR)) q:subDR=""  d
	.s tSubDR=$tr(subDR," ","")
	.q:((type="N")&&(tSubDR'=subID))
	.s subObj=$g(^DHCINM.Tea.DrillReleaseSubD($p(tSubDR,"||",1),$p(tSubDR,"||",2)))
	.q:subObj=""
	.s UserDR=$lg(subObj,2)
	.q:UserDR=""
	.s userObj=$g(^CF.DHCINM.DB.MgUserD(UserDR))
	.q:userObj=""
	.s userName=$lg(userObj,2)
	.s PerPic=..GetNursePic($lg(userObj,5))
	.s id="" f  s id=$O(^DHCINM.Tea.DrillVideoInfoI("Type",parID," "_type,subDR,id)) q:id=""  d
	..s objLB=$g(^DHCINM.Tea.DrillVideoInfoD(parID,id))
	..q:objLB=""
	..s ret="userName|"_userName_"^context|"_$lg(objLB,3)_"^infoTime|"_$lg(objLB,4)_"^Answer|"_$lg(objLB,5)_"^PerPic|"_PerPic
	..d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LoadDrillVideoInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadDrillVideoInfoExecute ]
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

ClassMethod LoadDrillVideoInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadDrillVideoInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description:获取人员档案的照片链接
/// Date:20230515
/// Creator:gzj
ClassMethod GetNursePic(RowID As %String) As %String
{
	q:RowID="" ""
	s PerList = $lg(^CF.DHCINM.HR.PersonsD(RowID),34)
	q PerList
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存培训进展
/// Input:
/// Output:
/// Other:
ClassMethod SaveDrillStep(parr As %String = "")
{
	s subID=$P(parr,"^",1)
	s step=$P(parr,"^",2)
	q:((subID="")||(step="")) "入参为空,请刷新重试"
	s obj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId($tr(subID,"__","||"))
	s obj.DrillStep=step
	s:step=0 obj.videoDuration=$P(parr,"^",3),obj.videoCurrentTime=$P(parr,"^",4)
	s:step=5 obj.DrillResult="Y"
	d obj.%Save()
	q step
}

/// Creator:lulin
/// Createdate:2020-07-17
/// Description:获取视频插题题目
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindVideoProblems","2__339")
Query FindVideoProblems(parr As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindVideoProblemsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",nowDate=+$H
	s subID=$tr($P(parr,"^",1),"__","||")
	s realeaseID=$P(subID,"||",1)
	s obj=##class(DHCINM.Tea.DrillRelease).%OpenId(realeaseID)
	s subObj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(subID)
	i (('$IsObject(obj))||('$IsObject(subObj))){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s videoQuestion=obj.videoQuestion
	f i=1:1:obj.videoQuestion.Count() d
	.s question=obj.videoQuestion.GetAt(i)
	.q:question=""
	.s time=$P(question,"」",1)
	.s theorySubID=$P(question,"」",3)
	.q:$d(^DHCINM.Tea.DrillTheoryI("typeSubTime",realeaseID,$P(subID,"||","2")," V",theorySubID," "_time)) ;已做完插题不继续答题
	.s ret=..GetTheoryProblem(theorySubID,1)
	.s ret=ret_"^videoTime|"_time
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindVideoProblemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVideoProblemsExecute ]
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

ClassMethod FindVideoProblemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVideoProblemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-17
/// Description:获取视频插题、理论考试所有题目
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","FindDrillProblemList","1__1^R")
Query FindDrillProblemList(parr As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindDrillProblemListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret="",nowDate=+$H
	s subID=$tr($P(parr,"^",1),"__","||")
	s type=$P(parr,"^",2)
	s realeaseID=$P(subID,"||",1)
	s obj=##class(DHCINM.Tea.DrillRelease).%OpenId(realeaseID)
	s subObj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(subID)
	i (('$IsObject(obj))||('$IsObject(subObj))){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s RealPaperType=obj.ClassPaperType
	s QuestRange=obj.ClassQuesRange
	s QuestRangeI=obj.ClassQuesRangeI
	s ReleaseDraw=obj.ClassDraw
	i type="R" d
	.s RealPaperType=obj.ResultPaperType
	.s QuestRange=obj.ResultQuesRange
	.s QuestRangeI=obj.ResultQuesRangeI
	.s ReleaseDraw=obj.ResultDraw
	//复考如果是智能非固定考试会再来一份新的试卷
	i RealPaperType="H" d //手动
	.f i=1:1:QuestRange.Count() d
	..s rowData=QuestRange.GetAt(i)
	..q:rowData=""
	..s theorySubId=$P(rowData,"」",2)
	..s theorySubScore=$P(rowData,"」",3)
	..s ret=..GetTheoryProblem(theorySubId,1)
	..s ret=ret_"^GetScore|0"_"^ExamScore|"_theorySubScore
	..d OutputRowData
	e  i ReleaseDraw="Y"  d
	.f i=1:1:QuestRangeI.Count() d
	..s rowData=QuestRangeI.GetAt(i)
	..q:rowData=""
	..s theorySubId=$P(rowData,"」",1)
	..s theorySubScore=$P(rowData,"」",2)
	..s ret=..GetTheoryProblem(theorySubId,1)
	..s ret=ret_"^GetScore|0"_"^ExamScore|"_theorySubScore
	..d OutputRowData
	e  d //智能
	.s retTmp=""
	.d ..SetIntellectExamTheoryTmp(.retTmp,QuestRange)
	.s id="" f  s id=$O(retTmp(id)) q:id=""  d
	..s ret=..GetTheoryProblem(id,1)
	..s ret=ret_"^GetScore|0"_"^ExamScore|"_retTmp(id)
	..d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDrillProblemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDrillProblemListExecute ]
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

ClassMethod FindDrillProblemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDrillProblemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-07-17
/// Description:保存培训视频插题、随堂练习、理论结课考核
/// Input:
/// Output:
/// Other:w ##class(web.INMTeaComm).SaveDrillTheory("^3||10^0^4「^3||2^^4「^3||5^^4「^3||6^^4「^3||7^^4","C^1||1^00:00:11^")
ClassMethod SaveDrillTheory(subParr As %String = "", parr As %String = "") As %String
{
	s ^TMP("SaveDrillTheory")=parr
	s theoryType=$P(parr,"^",1) ;类型
	s subID=$P(parr,"^",2)
	s ExamTime=$P(parr,"^",3) ;用时
	s quesVideoTime=$P(parr,"^",4) ;视频插题时间
	s obj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(subID)
	
	//随堂练习、结课考核，删除考试题
	s sc=1
	TS
	i ((theoryType="C")||(theoryType="R")) d
	.s theoryID="" f  s theoryID=$O(^DHCINM.Tea.DrillTheoryI("type",$P(subID,"||",1),$P(subID,"||",2)," "_theoryType,theoryID)) q:((theoryID="")||(sc'=1))  d
	..s sc=$$$ISOK(##class(DHCINM.Tea.DrillTheory).%DeleteId(subID_"||"_theoryID))
	if 'sc{
		TRO
		q "error^删除子类失败"	
	}
	s score=0,videoRightNum=0
	s scRet=""
	f i=1:1:$L(subParr,"「") q:'sc  d
	.s rowData=$P(subParr,"「",i)
	.q:rowData=""
	.s theoryRW=$P(rowData,"^",2)
	.s theoryReuslt=$P(rowData,"^",3)
	.s theoryScore=$P(rowData,"^",4)
	.s TeaTheorySubObj=##class(CF.DHCINM.DB.TeaTheorySub).%OpenId(theoryRW)
	.q:'$IsObject(TeaTheorySubObj)
	.s subObj=##class(DHCINM.Tea.DrillTheory).%New()
	.s subObj.Parref=obj
	.s subObj.type=theoryType
	.s subObj.videoTime=quesVideoTime
	.s subObj.ExamSubDR=TeaTheorySubObj
	.s subObj.Result=theoryReuslt
	.s subObj.SubDesc=TeaTheorySubObj.SubDesc
	.s subObj.SubUrl=TeaTheorySubObj.SubUrl
	.s subObj.SubMode=TeaTheorySubObj.SubMode
	.;s subObj.ExamTime=""
	.s subObj.SubTypeDR=TeaTheorySubObj.SubTypeDR
	.s subObj.SubOption=TeaTheorySubObj.SubOption
	.s subObj.SubAnswer=TeaTheorySubObj.SubAnswer
	.s subObj.SubSource=TeaTheorySubObj.SubSource
	.s subObj.SubAnalysis=TeaTheorySubObj.SubAnalysis
	.s subObj.Result=theoryReuslt
	.s subObj.ExamScore=theoryScore
	.;s subObj.AnslyFlag="Y"
	.;i subObj.SubMode'="A" d 
	.s subObj.CorrectFlag=..IsCurrect(subObj.Result,TeaTheorySubObj)
	.s:subObj.CorrectFlag=1 videoRightNum=videoRightNum+1
	.s subObj.GetScore=subObj.ExamScore*subObj.CorrectFlag
	.s score=score+subObj.GetScore
	.s sc=$$$ISOK(subObj.%Save())
	.q:'sc
	.s:scRet'="" scRet=scRet_"「"
	.s scRet=scRet_theoryRW_","_subObj.%Id()_","_subObj.CorrectFlag
	if 'sc{
		TRO
		q "error^保存子类失败"	
	}
	s:theoryType="V" obj.videoRightNum=videoRightNum,obj.videoAnswerNum=obj.videoAnswerNum+1
	i theoryType="C" d
	.s obj.classDate=+$H
	.s obj.classUseResitNum=obj.classUseResitNum+1
	.s obj.classUseTime=ExamTime
	.s obj.UseClassScore=score
	e  i theoryType="R" d
	.s obj.ResultUseDate=+$H
	.s obj.ResultUseResitNum=obj.ResultUseResitNum+1
	.s obj.ResultUseTime=ExamTime
	.s obj.UseResultScore=score
	s sc=$$$ISOK(obj.%Save())
	if sc {
		TC
		q "success^"_scRet
	}else{
		TRO
		q "error^保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-07-13
/// Description:保存结课考核预约
/// Input:
/// Output:
/// Other:
ClassMethod SaveReusltOrderNum(parr As %String = "")
{
	s subID=$P(parr,"^",1)
	s index=$P(parr,"^",2)
	q:((subID="")||(index="")) "入参为空,请刷新重试"
	s obj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId($tr(subID,"__","||"))
	s obj.ResultOpeUseOrderTime=index
	d obj.%Save()
	q 1
}

/// Description: 保存课后作业
/// Date: 2023-05-03
/// Creator: lulin
/// Table: 
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMTeaComm).SaveDrillHomeWork("1||1","安贞需求补.txt")
ClassMethod SaveDrillHomeWork(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(id)
	q:'$IsObject(obj) 0
	d obj.HomeworkUrl.Insert(name)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除课后作业
/// Date: 2023-05-03
/// Creator: lulin
/// Table: 
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMTeaComm).DeleteDrillHomeWork("1||1","安贞需求补.txt")
ClassMethod DeleteDrillHomeWork(id As %String = "", name As %String = "") As %String
{
	q:(id="") 0
	
	s obj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(id)
	q:'$IsObject(obj) 0
	s index=obj.HomeworkUrl.Find(name)
	d obj.HomeworkUrl.RemoveAt(index)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lulin
/// Createdate:2023-04-23
/// Description:查询考试明细
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","LoadDrillReleaseSubList","1^A,N,Y^N","",3)
Query LoadDrillReleaseSubList(parr As %String = "", input As %String = "", activeName As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod LoadDrillReleaseSubListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", activeName As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id=$P(parr,"^",1)
	i ((id="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s SurveyFlag=$P(parr,"^",2)
	s ScoreFlag=$P(parr,"^",3)
	s subID="" f  s subID=$O(^DHCINM.Tea.DrillReleaseSubD(id,subID)) q:subID=""  d
	.s subObj=$g(^DHCINM.Tea.DrillReleaseSubD(id,subID))
	.q:subObj=""
	.s OrderFlag=$lg(subObj,8)
	.q:OrderFlag'="Y"
	.s perName=""
	.s UserDR=$lg(subObj,2)
	.i UserDR'="" d
	..s userObj=$g(^CF.DHCINM.DB.MgUserD(UserDR))
	..s:userObj'="" perName=$lg(userObj,2)
	.q:((input'="")&&(perName'[input))
	.s tStatus=..GetDrillSurveyStatus(id_"||"_subID,"DS")
	.q:((activeName=1)&&(SurveyFlag'[tStatus))
	.s UseDrillScoreStatus=$lg(subObj,33)
	.s:UseDrillScoreStatus="" UseDrillScoreStatus="N"
	.q:((activeName=3)&&(ScoreFlag'[UseDrillScoreStatus))
	.s ret=..getDrillReleaseSub(id_"||"_subID)
	.s TSSStatusDesc=$case(tStatus,"A":"未评价","N":"已评价","Y":"已提交",:tStatus)
	.s ret=ret_"^dataIndex|"_ind_"^TSSStatusDesc|"_TSSStatusDesc
	.d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LoadDrillReleaseSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadDrillReleaseSubListExecute ]
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

ClassMethod LoadDrillReleaseSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadDrillReleaseSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2023-04-23
/// Description:查询视频相关评论、提问\提问
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMTeaComm","LoadVideoInfoList","1","")
Query LoadVideoInfoList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "ret")
{
}

ClassMethod LoadVideoInfoListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id=$P(parr,"^",1)
	i ((id="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s SubDR="" f  s SubDR=$O(^DHCINM.Tea.DrillVideoInfoI("Type",id," Q",SubDR))  q:SubDR=""  d
	.s subObj=$g(^DHCINM.Tea.DrillReleaseSubD(id,$P(SubDR,"||",2)))
	.q:subObj=""
	.s UserDR=$lg(subObj,2)
	.q:UserDR=""
	.s userObj=$g(^CF.DHCINM.DB.MgUserD(UserDR))
	.q:userObj=""
	.;s perNo=$lg(userObj,3)
	.s perName=$lg(userObj,2)
	.q:((input'="")&&(perName'[input))
	.s infoID="" f  s infoID=$O(^DHCINM.Tea.DrillVideoInfoI("Type",id," Q",SubDR,infoID))  q:infoID=""  d
	..s obj=$g(^DHCINM.Tea.DrillVideoInfoD(id,infoID))
	..q:obj=""
	..s infoTime=$lg(obj,4)
	..s context=$lg(obj,3)
	..s Answer=$lg(obj,5)
	..s AnswerStatus=$lg(obj,7)
	..s ret="rw|"_id_"||"_infoID_"^infoTime|"_infoTime_"^perName|"_perName_"^context|"_context_"^Answer|"_Answer
	..s ret=ret_"^AnswerStatus|"_AnswerStatus_"^dataIndex|"_ind
	..d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LoadVideoInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadVideoInfoListExecute ]
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

ClassMethod LoadVideoInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadVideoInfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 讲师培训右侧保存
/// Date: 2023-05-04
/// Creator: lulin
/// Table: 
/// Input: id
/// Output: 0：失败 1：成功
/// Other: 
ClassMethod SaveTeachSub(parr As %String = "", activeName As %String = "") As %String
{
	q:((parr="")||(activeName="")) "入参不能为空"
	s sc=1
	TS
	f i=1:1:$L(parr,"」") q:'sc  d
	.s rowData=$P(parr,"」",i)
	.q:rowData=""
	.s rw=$P(rowData,"「",1)
	.s info=$P(rowData,"「",2)
	.s Status=$P(rowData,"「",3)
	.i activeName=4 d
	..s videoInfoObj=##class(DHCINM.Tea.DrillVideoInfo).%OpenId(rw)
	..q:'$IsObject(videoInfoObj)
	..q:videoInfoObj.AnswerStatus="Y"
	..s videoInfoObj.AnswerStatus=Status
	..s videoInfoObj.Answer=info
	..s sc=$$$ISOK(videoInfoObj.%Save())
	.e  d
	..s subObj=##class(DHCINM.Tea.DrillReleaseSub).%OpenId(rw)
	..q:'$IsObject(subObj)
	..i activeName=2 d
	...q:subObj.UseHomeworkScoreStatus="Y"
	...s subObj.UseHomeworkScoreStatus=Status
	...s subObj.UseHomeworkScore=info
	..e  d
	...q:subObj.UseDrillScoreStatus="Y"
	...s subObj.UseDrillScoreStatus=Status
	...s subObj.UseDrillScore=info
	..s sc=$$$ISOK(subObj.%Save())
	if sc{
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:ChenPeng
/// Createdate:2023-5-14
/// Description:批量增加文件下载次数字段值
/// Input: {rowIds:"1,2,3,4"}
/// Output: {-1:传入id为空,0:操作失败,1:操作成功}
/// Other:w ##class(web.INMTeaComm).UpdateDownloadNum("2")
ClassMethod UpdateDownloadNum(rowIds As %String) As %String
{
    s lbRowIds=$lfs(rowIds,"^")
    q:$ll(lbRowIds)=0 -1
    s sc=$$$OK,ptr=0
    ts
    while $ListNext(lbRowIds,ptr,rowId) {
        s obj=##class(DHCINM.Tea.LearnData).%OpenId(rowId,0)
        continue:'$IsObject(obj)
        s:obj.UploadNum="" obj.UploadNum=0
        s obj.UploadNum=obj.UploadNum+1
        s sc=sc&&obj.%Save()
        quit:$$$ISERR(sc)
    }
    tc:$$$ISOK(sc)
    tro:$$$ISERR(sc)
    q $$$ISOK(sc)
}

}
