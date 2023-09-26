/// Creator:wangpf
/// Desctiptions:护士长手册方法类
/// Date:2020-07-01
Class web.INMHBComm Extends %RegisteredObject
{

/// Description: 保存护士长手册说明
/// Date: 2020-07-01
/// Creator: wangpf
/// Table: CF.DHCINM.HB.HbDirections
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveDirections("测试^测试^2020-07-01^^",0)
ClassMethod SaveDirections(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) "获取编辑人员信息失败,请刷新重试"
	
	s code=$p(parr,"^")
	s desc=$p(parr,"^",2)
	s stDate=$p(parr,"^",3)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate["-" endDate=$zdh(endDate,3)
	s rw=$p(parr,"^",5)
	s codeRW=$O(^CF.DHCINM.HB.HbDirectionsI("Code"," "_$zcvt(code,"U"),""))
	q:((codeRW'="")&&((rw="")||(rw'=codeRW))) "代码重复"
	i rw="" d
	.s obj=##class(CF.DHCINM.HB.HbDirections).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(CF.DHCINM.HB.HbDirections).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.ItemCode=code
	s obj.ItemDesc=desc
	s obj.ItemStDate=stDate
	s obj.ItemEndDate=endDate
	s obj.Updator=nurseid
	s now=$h
	s obj.UpdateDate=+now
	s obj.UpdateTime=$p(now,",",2)
	s sc=obj.%Save()
	if $$$ISOK(sc){
		q 1	
	}else{
		q "保存失败"	
	}
}

/// Description: 保存护士长手册说明内容
/// Date: 2020-07-01
/// Creator: wangpf
/// Table: CF.DHCINM.HB.HbDirections
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveDirectionsContent("",1,0)
ClassMethod SaveDirectionsContent(parr As %String = "", rw As %String = "", nurseid As %String = "") As %String
{
	q:(rw="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	s ^TMP("dddddd")=parr_"%"_rw
	s obj=##class(CF.DHCINM.HB.HbDirections).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.Updator=nurseid
	s now=$h
	s obj.UpdateDate=+now
	s obj.UpdateTime=$p(now,",",2)
	i $CLASSNAME(parr)["CSP.CharacterStream" {
		d obj.ItemContentExt.CopyFromAndSave(parr)
	}
	else {
		d obj.ItemContentExt.Write(parr)
	}
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取护士长手册说明内容
/// Date: 2020-07-01
/// Creator: wangpf
/// Table: CF.DHCINM.HB.HbDirections
/// Input: id flag:是否返回计划内容
/// Output: 护士长手册说明内容
/// Other: w ##class(web.INMHBComm).GetDirections(1)
ClassMethod GetDirections(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^CF.DHCINM.HB.HbDirectionsD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s dirGlo=^CF.DHCINM.HB.HbDirectionsD(id)
	s itemCode=$lg(dirGlo,2)
	s itemDesc=$lg(dirGlo,3)
	s itemContent=""
	;s:flag=1 itemContent=$lg(dirGlo,4)
	s itemStDate=$lg(dirGlo,5)
	s itemEndDate=$lg(dirGlo,6)
	s now=+$h
	i (itemStDate="")||(now<itemStDate)||((itemEndDate'="")&&(itemEndDate<now)) s status="停用"
	e  s status="启用"
	s:itemStDate'="" itemStDate=$zd(itemStDate,3)
	s:itemEndDate'="" itemEndDate=$zd(itemEndDate,3)
	s creator=$lg(dirGlo,7)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(dirGlo,8)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(dirGlo,9)
	s:createTime'="" createTime=$zt(createTime,1)
	s updator=$lg(dirGlo,10)
	s updatorName=""
	i updator=0 s updatorName="管理员"
	e  i updator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(updator))
	.s updatorName=$lg(perGlo,2)
	s updateDate=$lg(dirGlo,11)
	s:updateDate'="" updateDate=$zd(updateDate,3)
	s updateTime=$lg(dirGlo,12)
	s:updateTime'="" updateTime=$zt(updateTime)
	i flag=1{
		w "{""ItemCode"":"""_itemCode_""",""ItemDesc"":"""_itemDesc_""",""ItemContent"":"""
		s obj=##class(CF.DHCINM.HB.HbDirections).%OpenId(id)
		while ('obj.ItemContentExt.AtEnd){
			w $replace($zcvt($tr(obj.ItemContentExt.Read(),$c(10,13)),"O","JS"),"\'","\\'")
		}
		w """,""ItemStDate"":"""_itemStDate_""",""ItemEndDate"":"""_itemEndDate_""",""Creator"":"""_creator_""",""CreatorName"":"""_creatorName
		w """,""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime_""",""Updator"":"""_updator_""",""UpdatorName"":"""_updatorName
		w """,""UpdateDate"":"""_updateDate_""",""UpdateTime"":"""_updateTime_""",""Status"":"""_status_""",""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="ItemCode|"_itemCode_"^ItemDesc|"_itemDesc_"^ItemContent|"_itemContent_"^ItemStDate|"_itemStDate_"^ItemEndDate|"_itemEndDate
		s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^Updator|"_updator
		s ret=ret_"^UpdatorName|"_updatorName_"^UpdateDate|"_updateDate_"^UpdateTime|"_updateTime_"^Status|"_status_"^rw|"_id
		q ret
	}
}

/// Description：获取护士长手册说明列表
/// Date:2020-07-01
/// Creator:wangpf
/// Table:CF.DHCINM.HB.HbDirections
/// Input: parr
/// Output:护士长手册说明列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindDirectionsList","")
Query FindDirectionsList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDirectionsListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s id="" f  s id=$o(^CF.DHCINM.HB.HbDirectionsD(id)) q:id=""  d
	.s dirGlo=^CF.DHCINM.HB.HbDirectionsD(id)
	.s itemCode=$lg(dirGlo,2)
	.s itemDesc=$lg(dirGlo,3)
	.q:itemCode_itemDesc'[parr
	.s ret=..GetDirections(id)
	.d:ret'="" OutDirectionsList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutDirectionsList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDirectionsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDirectionsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDirectionsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDirectionsListExecute ]
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

/// Description: 通过Code获取护士长手册说明内容
/// Date: 2020-07-01
/// Creator: wangpf
/// Table: CF.DHCINM.HB.HbDirections
/// Input: id
/// Output: 护士长手册说明内容
/// Other: w ##class(web.INMHBComm).GetDirectionsByCode(FillDirections)
ClassMethod GetDirectionsByCode(code As %String = "") As %String
{
	s id=""
	s tId="" f  s tId=$o(^CF.DHCINM.HB.HbDirectionsI("Code"," "_$zcvt(code,"U"),tId)) q:((tId="")||(id'=""))  d
	.s obj=$g(^CF.DHCINM.HB.HbDirectionsD(tId))
	.q:obj=""
	.s startDate=$LG(obj,5)
	.s endDate=$lg(obj,6)
	.q:(startDate>+$H)
	.q:((endDate'="")&&(endDate<+$H))
	.s id=tId
	q:id="" "{}"
	q ..GetDirections(id,1)
}

/// Description: 保存科室护管分工
/// Date: 2020-07-01
/// Creator: wangpf
/// Table: DHCINM.HB.MgDivision
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveDivision("1^51||1^52||1^1^")
ClassMethod SaveDivision(parr As %String = "") As %String
{
	q:parr="" 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s work=$p(parr,"^",2)
	s workPar=$p(work,"||")
	s workSub=$p(work,"||",2)
	q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(workPar,workSub)) 0
	s post=$p(parr,"^",3)
	s postPar=$p(post,"||")
	s postSub=$p(post,"||",2)
	q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(postPar,postSub)) 0
	s per=$p(parr,"^",4)
	q:'$d(^CF.DHCINM.HR.PersonsD(per)) 0
	s rw=$p(parr,"^",5)
	
	s id=$o(^DHCINM.HB.MgDivisionI("Per",per,ward,work,post,""))
	q:(id'="")&&(id'=rw) -1
	
	i rw="" s obj=##class(DHCINM.HB.MgDivision).%New()
	e  s obj=##class(DHCINM.HB.MgDivision).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.DivisionWardSetObjectId(ward)
	d obj.DivisionWorkSetObjectId(work)
	d obj.DivisionPostSetObjectId(post)
	d obj.DivisionPerSetObjectId(per)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取科室护管分工
/// Date: 2020-07-01
/// Creator: wangpf
/// Table: DHCINM.HB.MgDivision
/// Input: id
/// Output: 科室护管分工
/// Other: w ##class(web.INMHBComm).GetDivision(1)
ClassMethod GetDivision(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgDivisionD(id))) ""
	
	s divGlo=^DHCINM.HB.MgDivisionD(id)
	s divWard=$lg(divGlo,2)
	s wardDesc=""
	i divWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(divWard))
	.s wardDesc=$lg(wardGlo,4)
	s divWork=$lg(divGlo,3)
	s workDesc=""
	i divWork'="" d
	.s workPar=$p(divWork,"||")
	.s workSub=$p(divWork,"||",2)
	.s workGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(workPar,workSub))
	.s workDesc=$lg(workGlo,3)
	s divPost=$lg(divGlo,4)
	s postDesc=""
	i divPost'="" d
	.s postPar=$p(divPost,"||")
	.s postSub=$p(divPost,"||",2)
	.s postGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(postPar,postSub))
	.s postDesc=$lg(postGlo,3)
	s divPer=$lg(divGlo,5)
	s perName=""
	i divPer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(divPer))
	.s perName=$lg(perGlo,2)
	s ret="DivisionWard|"_divWard_"^DivisionWardDesc|"_wardDesc_"^DivisionWork|"_$tr(divWork,"|","_")_"^DivisionWorkDesc|"_workDesc
	s ret=ret_"^DivisionPost|"_$tr(divPost,"|","_")_"^DivisionPostDesc|"_postDesc_"^DivisionPer|"_divPer_"^DivisionPerName|"_perName
	s ret=ret_"^rw|"_id
	q ret
}

/// Description：获取科室护管分工列表
/// Date:2020-07-01
/// Creator:wangpf
/// Table:DHCINM.HB.MgDivision
/// Input: 病区Id^类型^内容 登录人Id 登录人角色
/// Output:科室护管分工列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindDivisionList","1^^",0,0)
Query FindDivisionList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDivisionListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$p(parr,"^")
	s type=$p(parr,"^",2)
	s input=$p(parr,"^",3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s wardId="" f  s wardId=$o(^DHCINM.HB.MgDivisionI("Ward",wardId)) q:wardId=""  d
	.q:((ward'="")&&(ward'=wardId))||((isAll'=1)&&('$d(tmpWard(wardId))))
	.s id="" f  s id=$o(^DHCINM.HB.MgDivisionI("Ward",wardId,id)) q:id=""  d
	..q:'$d(^DHCINM.HB.MgDivisionD(id))
	..s divGlo=^DHCINM.HB.MgDivisionD(id)
	..s flag=1
	..i type="Work" d
	...s divWork=$lg(divGlo,3)
	...i divWork="" s flag=0 q
	...s workPar=$p(divWork,"||")
	...s workSub=$p(divWork,"||",2)
	...s workGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(workPar,workSub))
	...s workDesc=$lg(workGlo,3)
	...s:workDesc'[input flag=0
	..e  i type="Name" d
	...s divPer=$lg(divGlo,5)
	...i divPer="" s flag=0 q
	...s perGlo=$g(^CF.DHCINM.HR.PersonsD(divPer))
	...s perName=$lg(perGlo,2)
	...s:perName'[input flag=0
	..q:flag'=1
	..s ret=..GetDivision(id)
	..d:ret'="" OutDivisionList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutDivisionList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDivisionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDivisionListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDivisionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDivisionListExecute ]
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

/// Description: 删除科室护管分工
/// Date: 2020-07-02
/// Creator: wangpf
/// Table: DHCINM.HB.MgDivision
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteDivision(1)
ClassMethod DeleteDivision(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgDivision).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存科室护管分工制度
/// Date: 2020-07-02
/// Creator: wangpf
/// Table: DHCINM.HB.MgDivisionRule
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveDivisionRule("1^51||1^测试制度^")
ClassMethod SaveDivisionRule(parr As %String = "") As %String
{
	q:parr="" 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s work=$p(parr,"^",2)
	s workPar=$p(work,"||")
	s workSub=$p(work,"||",2)
	q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(workPar,workSub)) 0
	s desc=$p(parr,"^",3)
	s rw=$p(parr,"^",4)
	
	i rw="" s obj=##class(DHCINM.HB.MgDivisionRule).%New()
	e  s obj=##class(DHCINM.HB.MgDivisionRule).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.RuleWardSetObjectId(ward)
	d obj.RuleDivisionSetObjectId(work)
	s obj.RuleDesc=desc
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 保存科室护管分工制度内容
/// Date: 2020-07-02
/// Creator: wangpf
/// Table: DHCINM.HB.MgDivisionRule
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveRuleContent("测试^1")
ClassMethod SaveRuleContent(rw As %String = "", content As %String = "") As %String
{
	q:rw="" 0
	
	s obj=##class(DHCINM.HB.MgDivisionRule).%OpenId(rw)
	q:'$IsObject(obj) 0
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.RuleContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.RuleContentExt.Write(content)
	}
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取科室护管分工制度
/// Date: 2020-07-02
/// Creator: wangpf
/// Table: DHCINM.HB.MgDivisionRule
/// Input: id
/// Output: 科室护管分工制度
/// Other: w ##class(web.INMHBComm).GetDivisionRule(1)
ClassMethod GetDivisionRule(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.HB.MgDivisionRuleD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s ruleGlo=^DHCINM.HB.MgDivisionRuleD(id)
	s ruleWard=$lg(ruleGlo,2)
	s wardDesc=""
	i ruleWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(ruleWard))
	.s wardDesc=$lg(wardGlo,4)
	s ruleWork=$lg(ruleGlo,3)
	s workDesc=""
	i ruleWork'="" d
	.s workPar=$p(ruleWork,"||")
	.s workSub=$p(ruleWork,"||",2)
	.s workGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(workPar,workSub))
	.s workDesc=$lg(workGlo,3)
	s ruleDesc=$lg(ruleGlo,4)
	s ruleContent=""
	;s:flag=1 ruleContent=$lg(ruleGlo,5)
	
	i flag=1{
		w "{""RuleWard"":"""_ruleWard_""",""RuleWardDesc"":"""_wardDesc_""",""RuleDivision"":"""_$tr(ruleWork,"|","_")_""",""RuleDivisionDesc"":"""_workDesc
		w """,""RuleDesc"":"""_ruleDesc_""",""RuleContent"":"""
		s obj=##class(DHCINM.HB.MgDivisionRule).%OpenId(id)
		while ('obj.RuleContentExt.AtEnd){
			w $tr(obj.RuleContentExt.Read(),$c(10,13))
		}
		w """,""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="RuleWard|"_ruleWard_"^RuleWardDesc|"_wardDesc_"^RuleDivision|"_$tr(ruleWork,"|","_")_"^RuleDivisionDesc|"_workDesc
		s ret=ret_"^RuleDesc|"_ruleDesc_"^RuleContent|"_ruleContent_"^rw|"_id
		q ret
	}
}

/// Description：获取科室护管分工制度列表
/// Date:2020-07-02
/// Creator:wangpf
/// Table:DHCINM.HB.MgDivisionRule
/// Input: 病区Id^类型^内容 登录人Id 登录人角色
/// Output:科室护管分工制度列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindDivisionRuleList","1^^",0,0)
Query FindDivisionRuleList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDivisionRuleListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ward=$p(parr,"^")
	s type=$p(parr,"^",2)
	s input=$p(parr,"^",3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s wardId="" f  s wardId=$o(^DHCINM.HB.MgDivisionRuleI("Ward",wardId)) q:wardId=""  d
	.q:((ward'="")&&(ward'=wardId))||((isAll'=1)&&('$d(tmpWard(wardId))))
	.s id="" f  s id=$o(^DHCINM.HB.MgDivisionRuleI("Ward",wardId,id)) q:id=""  d
	..q:'$d(^DHCINM.HB.MgDivisionRuleD(id))
	..s ruleGlo=^DHCINM.HB.MgDivisionRuleD(id)
	..s flag=1
	..i (type="Work")&&(input'="") d
	...s ruleWork=$lg(ruleGlo,3)
	...i ruleWork="" s flag=0 q
	...s workPar=$p(ruleWork,"||")
	...s workSub=$p(ruleWork,"||",2)
	...s workGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(workPar,workSub))
	...s workDesc=$lg(workGlo,3)
	...s:workDesc'[input flag=0
	..e  i (type="Rule")&&(input'="") d
	...s ruleDesc=$lg(ruleGlo,4)
	...s:ruleDesc'[input flag=0
	..q:flag'=1
	..s ret=..GetDivisionRule(id)
	..d:ret'="" OutRuleList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRuleList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDivisionRuleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDivisionRuleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDivisionRuleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDivisionRuleListExecute ]
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

/// Description: 删除科室护管分工制度
/// Date: 2020-07-02
/// Creator: wangpf
/// Table: DHCINM.HB.MgDivisionRule
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteDivisionRule(1)
ClassMethod DeleteDivisionRule(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgDivisionRule).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存带教老师
/// Date: 2020-07-02
/// Creator: wangpf
/// Table: DHCINM.HB.MgNurTeacher
/// Input: parr
/// Output: -1：重复 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveNurTeacher("2020^1^1^测试^")
ClassMethod SaveNurTeacher(parr As %String = "") As %String
{
	q:parr="" 0
	
	s year=$p(parr,"^")
	s ward=$p(parr,"^",2)
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s per=$p(parr,"^",3)
	q:'$d(^CF.DHCINM.HR.PersonsD(per)) 0
	s remark=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	
	s id=$o(^DHCINM.HB.MgNurTeacherI("Per",per,year,ward,""))
	q:(id'="")&&(id'=rw) -1
	
	i rw="" s obj=##class(DHCINM.HB.MgNurTeacher).%New()
	e  s obj=##class(DHCINM.HB.MgNurTeacher).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.TeacherYear=year
	d obj.TeacherWardSetObjectId(ward)
	d obj.TeacherPerSetObjectId(per)
	s obj.TeacherRemark=remark
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取带教老师信息
/// Date: 2020-07-02
/// Creator: wangpf
/// Table: DHCINM.HB.MgNurTeacher
/// Input: id
/// Output: 带教老师信息
/// Other: w ##class(web.INMHBComm).GetNurTeacher(1)
ClassMethod GetNurTeacher(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgNurTeacherD(id))) ""
	
	s teacherGlo=^DHCINM.HB.MgNurTeacherD(id)
	s teacherYear=$lg(teacherGlo,2)
	s teacherWard=$lg(teacherGlo,3)
	s wardDesc=""
	i teacherWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(teacherWard))
	.s wardDesc=$lg(wardGlo,4)
	s teacherPer=$lg(teacherGlo,4)
	s perName="",perDepDate="",perWorkDate=""
	i teacherPer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(teacherPer))
	.s perName=$lg(perGlo,2)
	.s perDepDate=$lg(perGlo,11)
	.s:perDepDate'="" perDepDate=$zd(perDepDate,3)
	.s perWorkDate=$lg(perGlo,14)
	.s:perWorkDate'="" perWorkDate=$zd(perWorkDate,3)
	s teacherRemark=$lg(teacherGlo,5)
	s teacherLevel=$p(##class(web.INMHRComm).GetNurseLevel(teacherPer,+$h),"^",2)
	s teacherAcadamic=$p(##class(web.INMHRComm).GetNurseEdu(teacherPer,+$h),"^",2)
	s teacherHireDuty=$p(##class(web.INMHRComm).GetNurseHireDuty(teacherPer,+$h),"^",2)
	
	s ret="TeacherYear|"_teacherYear_"^TeacherWard|"_teacherWard_"^TeacherWardDesc|"_wardDesc_"^TeacherPer|"_teacherPer
	s ret=ret_"^TeacherPerName|"_perName_"^TeacherRemark|"_teacherRemark_"^TeacherLevel|"_teacherLevel_"^TeacherAcadamic|"_teacherAcadamic
	s ret=ret_"^TeacherHireDuty|"_teacherHireDuty_"^TeacherDepDate|"_perDepDate_"^TeacherWorkDate|"_perWorkDate_"^rw|"_id
	q ret
}

/// Description：获取病区带教老师列表
/// Date:2020-07-02
/// Creator:wangpf
/// Table:DHCINM.HB.MgNurTeacher
/// Input: 年度^病区Id 登录人Id 登录人角色
/// Output:病区带教老师列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindNurTeacherList","2020^1",0,0)
Query FindNurTeacherList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurTeacherListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s year=$p(parr,"^")
	s ward=$p(parr,"^",2)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s teacherYear="" f  s teacherYear=$o(^DHCINM.HB.MgNurTeacherI("YearWard",teacherYear)) q:teacherYear=""  d
	.q:(year'="")&&(year'=teacherYear)
	.s teacherWard="" f  s teacherWard=$o(^DHCINM.HB.MgNurTeacherI("YearWard",teacherYear,teacherWard)) q:teacherWard=""  d
	..q:((ward'="")&&(ward'=teacherWard))||((isAll'=1)&&('$d(tmpWard(teacherWard))))
	..s id="" f  s id=$o(^DHCINM.HB.MgNurTeacherI("YearWard",teacherYear,teacherWard,id)) q:id=""  d
	...s ret=..GetNurTeacher(id)
	...d:ret'="" OutTeacherList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTeacherList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurTeacherListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurTeacherListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurTeacherListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurTeacherListExecute ]
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

/// Description: 删除带教老师
/// Date: 2020-07-02
/// Creator: wangpf
/// Table: DHCINM.HB.MgNurTeacher
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteNurTeacher(1)
ClassMethod DeleteNurTeacher(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgNurTeacher).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存护理查房
/// Date: 2020-07-03
/// Creator: wangpf
/// Table: DHCINM.HB.MgRoomCheck
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveRoomCheck("1^H^1^604^2021-03-22^ddd^^604,868^0000000002^2^undefined^undefined^undefined^undefined^undefined^^N^1","",0)
ClassMethod SaveRoomCheck(parr As %String = "", record As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s type=$p(parr,"^")
	s level=$p(parr,"^",2)
	s mainChecker=$p(parr,"^",3)
	q:'$d(^CF.DHCINM.HR.PersonsD(mainChecker)) 0
	s reporter=$p(parr,"^",4)
	q:'$d(^CF.DHCINM.HR.PersonsD(reporter)) 0
	s checkDate=$p(parr,"^",5)
	s:checkDate["-" checkDate=$zdh(checkDate,3)
	s topic=$p(parr,"^",6)
	s file=$p(parr,"^",7)
	s checker=$p(parr,"^",8)
	s checkerList=$lfs(checker,",")
	s regNo=$p(parr,"^",9)
	s patMas=$p(parr,"^",10)
	s patientName=$p(parr,"^",11)
	s patientSex=$p(parr,"^",12)
	s patientAge=$p(parr,"^",13)
	s ctloc=$p(parr,"^",14)
	s ctlocId=$p(parr,"^",15)
	s situation=$p(parr,"^",16)
	s status=$p(parr,"^",17)
	s rw=$p(parr,"^",18)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgRoomCheck).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgRoomCheck).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.CheckType=type
	s obj.CheckLevel=level
	d obj.CheckMainCheckerSetObjectId(mainChecker)
	d obj.CheckReporterSetObjectId(reporter)
	s obj.CheckDate=checkDate
	s obj.CheckTopic=topic
	s obj.CheckFile=file
	b ;001
	d obj.CheckChecker.Clear()
	s ptr=0 f  s stat=$listnext(checkerList,ptr,per) q:stat'=1  d
	.q:(per="")||('$d(^CF.DHCINM.HR.PersonsD(per)))
	.d obj.CheckChecker.Insert(per)
	s obj.CheckRegNo=regNo
	d obj.CheckPAPatMasSetObjectId(patMas)
	s obj.CheckPatientName=patientName
	s obj.CheckPatientSex=patientSex
	s obj.CheckPatientAge=patientAge
	d obj.CheckCTLocSetObjectId(ctlocId)
	s obj.CheckCTLocDesc=ctloc
	s obj.CheckSituation=situation
	i $CLASSNAME(record)["CSP.CharacterStream" {
		d obj.CheckContentExt.CopyFromAndSave(record)
	}
	else {
		d obj.CheckContentExt.Write(record)
	}
	s obj.CheckStatus=status
	s sc=obj.%Save()
	b ;004
	q $$$ISOK(sc)
}

/// Description: 获取护理查房内容
/// Date: 2020-07-03
/// Creator: wangpf
/// Table: DHCINM.HB.MgRoomCheck
/// Input: id flag:是否返回计划内容
/// Output: 护理查房内容
/// Other: w ##class(web.INMHBComm).GetRoomCheck(1)
ClassMethod GetRoomCheck(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.HB.MgRoomCheckD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s checkGlo=^DHCINM.HB.MgRoomCheckD(id)
	s checkType=$lg(checkGlo,2)
	s checkTypeDesc=$case(checkType,1:"业务查房",2:"行政查房",3:"教学查房",4:"专科查房",5:"循证查房",:"")
	s checkLevel=$lg(checkGlo,3)
	s checkLevelDesc=$case(checkLevel,"H":"全院","L":"科室","W":"病区",:"")
	s mainChecker=$lg(checkGlo,4)
	s mainCheckerName=""
	i mainChecker'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(mainChecker))
	.s mainCheckerName=$lg(perGlo,2)
	s reporter=$lg(checkGlo,5)
	s reporterName=""
	i reporter'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(reporter))
	.s reporterName=$lg(perGlo,2)
	s checkDate=$lg(checkGlo,6)
	s:checkDate'="" checkDate=$zd(checkDate,3)
	s checkTopic=$lg(checkGlo,7)
	s checkFile=$lg(checkGlo,8)
	s checker=$lg(checkGlo,9)
	s checkerId=$lts(checker,",")
	s checkerName=""
	s index=0,ptr=0 f  s stat=$listnext(checker,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=0 s checkerName=perName
	.e  s checkerName=checkerName_","_perName
	.s index=index+1
	s patMas=$lg(checkGlo,10)
	s checkRegNo=$lg(checkGlo,11)
	s patientName=$lg(checkGlo,12)
	s patientSex=$lg(checkGlo,13)
	s patientAge=$lg(checkGlo,14)
	s checkCtLoc=$lg(checkGlo,15)
	s checkCtLocDesc=$lg(checkGlo,16)
	s checkSituation=$lg(checkGlo,17)
	s checkRecord=""
	;s:flag=1 checkRecord=$lg(checkGlo,18)
	s checkStatus=$lg(checkGlo,19)
	s checkStatusDesc=$case(checkStatus,"N":"保存","Y":"提交","B":"驳回",:"")
	s creator=$lg(checkGlo,20)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(checkGlo,21)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(checkGlo,22)
	s:createTime'="" createTime=$zt(createTime,1)
	
	i flag=1{
		w "{""CheckType"":"""_checkType_""",""CheckTypeDesc"":"""_checkTypeDesc_""",""CheckLevel"":"""_checkLevel_""",""CheckLevelDesc"":"""_checkLevelDesc
		w """,""CheckMainChecker"":"""_mainChecker_""",""CheckMainCheckerName"":"""_mainCheckerName_""",""CheckReporter"":"""_reporter_""",""CheckReporterName"":"""_reporterName
		w """,""CheckDate"":"""_checkDate_""",""CheckTopic"":"""_checkTopic_""",""CheckFile"":"""_checkFile_""",""CheckChecker"":"""_checkerId_""",""CheckCheckerName"":"""_checkerName
		w """,""CheckPAPatMas"":"""_patMas_""",""CheckRegNo"":"""_checkRegNo
		w """,""CheckPatientName"":"""_patientName_""",""CheckPatientSex"":"""_patientSex_""",""CheckPatientAge"":"""_patientAge
		w """,""CheckCTLoc"":"""_checkCtLoc_""",""CheckCTLocDesc"":"""_checkCtLocDesc
		w """,""CheckSituation"":"""_checkSituation_""",""CheckStatus"":"""_checkStatus_""",""CheckStatusDesc"":"""_checkStatusDesc
		w """,""CheckRecord"":"""
		s obj=##class(DHCINM.HB.MgRoomCheck).%OpenId(id)
		while ('obj.CheckContentExt.AtEnd){
			w $zcvt($tr(obj.CheckContentExt.Read(),$c(10,13)),"O","JS")
		}
		w """,""Creator"":"""_creator_""",""CreatorName"":"""_creatorName_""",""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime
		w """,""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="CheckType|"_checkType_"^CheckTypeDesc|"_checkTypeDesc_"^CheckLevel|"_checkLevel_"^CheckLevelDesc|"_checkLevelDesc_"^CheckMainChecker|"_mainChecker
		s ret=ret_"^CheckMainCheckerName|"_mainCheckerName_"^CheckReporter|"_reporter_"^CheckReporterName|"_reporterName_"^CheckDate|"_checkDate_"^CheckTopic|"_checkTopic
		s ret=ret_"^CheckFile|"_checkFile_"^CheckChecker|"_checkerId_"^CheckCheckerName|"_checkerName_"^CheckPAPatMas|"_patMas_"^CheckRegNo|"_checkRegNo
		s ret=ret_"^CheckPatientName|"_patientName_"^CheckPatientSex|"_patientSex_"^CheckPatientAge|"_patientAge_"^CheckCTLoc|"_checkCtLoc_"^CheckCTLocDesc|"_checkCtLocDesc
		s ret=ret_"^CheckSituation|"_checkSituation_"^CheckStatus|"_checkStatus_"^CheckStatusDesc|"_checkStatusDesc_"^CheckRecord|"_checkRecord_"^Creator|"_creator
		s ret=ret_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
		q ret
	}
}

/// Description：获取护理查房列表
/// Date:2020-07-03
/// Creator:wangpf
/// Table:DHCINM.HB.MgRoomCheck
/// Input: 病区Id^开始日期^结束日期 登录人Id 登录人角色
/// Output:护理查房列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindRoomCheckList","1^^",0)
Query FindRoomCheckList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoomCheckListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ctloc=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s perId=$p(parr,"^",4)
	s type=$p(parr,"^",5)
	s typeList=$lfs(type,",")
	s level=$p(parr,"^",6)
	s levelList=$lfs(level,",")
	s status=$p(parr,"^",7)
	
	s ctlocId="" f  s ctlocId=$o(^DHCINM.HB.MgRoomCheckI("CTLoc",ctlocId)) q:ctlocId=""  d
	.q:(ctloc'="")&&(ctloc'=ctlocId)
	.s id="" f  s id=$o(^DHCINM.HB.MgRoomCheckI("CTLoc",ctlocId,id)) q:id=""  d
	..q:'$d(^DHCINM.HB.MgRoomCheckD(id))
	..s checkGlo=^DHCINM.HB.MgRoomCheckD(id)
	..s checkDate=$lg(checkGlo,6)
	..q:((stDate'="")&&(stDate>checkDate))||((endDate'="")&&(endDate<checkDate))
	..s mainChecker=$lg(checkGlo,4)
	..s reporter=$lg(checkGlo,5)
	..s checker=$lg(checkGlo,9)
	..s tmpString=""
	..i mainChecker'="" s tmpString=mainChecker
	..i reporter'="" d
	...i tmpString'="" s tmpString=tmpString_","_reporter
	...e  s tmpString=reporter
	..s perIdList=$lfs(tmpString,",")_checker
	..q:(perId'="")&&($lf(perIdList,perId)=0)
	..s checkType=$lg(checkGlo,2)
	..q:(type'="")&&($lf(typeList,checkType)=0)
	..s checkLevel=$lg(checkGlo,3)
	..q:(level'="")&&($lf(levelList,checkLevel)=0)
	..s checkStatus=$lg(checkGlo,19)
	..q:(status'="")&&(status'=checkStatus)
	..s ret=..GetRoomCheck(id)
	..d:ret'="" OutRoomCheckList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRoomCheckList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoomCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoomCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRoomCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoomCheckListExecute ]
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

/// Description: 删除护理查房
/// Date: 2020-07-03
/// Creator: wangpf
/// Table: DHCINM.HB.MgRoomCheck
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteRoomCheck(1)
ClassMethod DeleteRoomCheck(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgRoomCheck).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存病例讨论
/// Date: 2020-07-04
/// Creator: wangpf
/// Table: DHCINM.HB.MgCaseDiscuss
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveDiscuss("",0)
ClassMethod SaveDiscuss(parr As %String = "", record As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s type=$p(parr,"^")
	s host=$p(parr,"^",2)
	q:'$d(^CF.DHCINM.HR.PersonsD(host)) 0
	s discussDate=$p(parr,"^",3)
	s:discussDate["-" discussDate=$zdh(discussDate,3)
	s participant=$p(parr,"^",4)
	s partiList=$lfs(participant,",")
	s regNo=$p(parr,"^",5)
	s patMas=$p(parr,"^",6)
	s patientName=$p(parr,"^",7)
	s patientSex=$p(parr,"^",8)
	s patientAge=$p(parr,"^",9)
	s ctloc=$p(parr,"^",10)
	s ctlocId=$p(parr,"^",11)
	s situation=$p(parr,"^",12)
	s status=$p(parr,"^",13)
	s rw=$p(parr,"^",14)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgCaseDiscuss).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgCaseDiscuss).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.DiscussType=type
	d obj.DiscussHostSetObjectId(host)
	s obj.DiscussDate=discussDate
	d obj.DiscussParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:(per="")||('$d(^CF.DHCINM.HR.PersonsD(per)))
	.d obj.DiscussParticipant.Insert(per)
	s obj.DiscussRegNo=regNo
	d obj.DiscussPAPatMasSetObjectId(patMas)
	s obj.DiscussPatientName=patientName
	s obj.DiscussPatientSex=patientSex
	s obj.DiscussPatientAge=patientAge
	d obj.DiscussCTLocSetObjectId(ctlocId)
	s obj.DiscussCTLocDesc=ctloc
	s obj.DiscussSituation=situation
	i $CLASSNAME(record)["CSP.CharacterStream" {
		d obj.DiscussRecordExt.CopyFromAndSave(record)
	}
	else {
		d obj.DiscussRecordExt.Write(record)
	}
	s obj.DiscussStatus=status
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取病例讨论内容
/// Date: 2020-07-04
/// Creator: wangpf
/// Table: DHCINM.HB.MgCaseDiscuss
/// Input: id flag:是否返回计划内容
/// Output: 病例讨论内容
/// Other: w ##class(web.INMHBComm).GetDiscuss(1)
ClassMethod GetDiscuss(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.HB.MgCaseDiscussD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s discussGlo=^DHCINM.HB.MgCaseDiscussD(id)
	s discussType=$lg(discussGlo,2)
	s discussTypeDesc=$case(discussType,1:"疑难病例",2:"危重病例",3:"抢救病例",4:"死亡病例",:"")
	s host=$lg(discussGlo,3)
	s hostName=""
	i host'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(host))
	.s hostName=$lg(perGlo,2)
	s discussDate=$lg(discussGlo,4)
	s:discussDate'="" discussDate=$zd(discussDate,3)
	s participant=$lg(discussGlo,5)
	s participantId=$lts(participant,",")
	s participantName=""
	s index=0,ptr=0 f  s stat=$listnext(participant,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=0 s participantName=perName
	.e  s participantName=participantName_","_perName
	.s index=index+1
	s patMas=$lg(discussGlo,6)
	s discussRegNo=$lg(discussGlo,7)
	s patientName=$lg(discussGlo,8)
	s patientSex=$lg(discussGlo,9)
	s patientAge=$lg(discussGlo,10)
	s discussCtLoc=$lg(discussGlo,11)
	s discussCtLocDesc=$lg(discussGlo,12)
	s discussSituation=$lg(discussGlo,13)
	s discussRecord=""
	;s:flag=1 discussRecord=$lg(discussGlo,14)
	s discussStatus=$lg(discussGlo,15)
	s discussStatusDesc=$case(discussStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(discussGlo,16)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(discussGlo,17)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(discussGlo,18)
	s:createTime'="" createTime=$zt(createTime,1)
	
	i flag=1{
		w "{""DiscussType"":"""_discussType_""",""DiscussTypeDesc"":"""_discussTypeDesc_""",""DiscussHost"":"""_host_""",""DiscussHostName"":"""_hostName
		w """,""DiscussDate"":"""_discussDate_""",""DiscussParticipant"":"""_participantId_""",""DiscussParticipantName"":"""_participantName_""",""DiscussPAPatMas"":"""_patMas
		w """,""DiscussRegNo"":"""_discussRegNo_""",""DiscussPatientName"":"""_patientName_""",""DiscussPatientSex"":"""_patientSex_""",""DiscussPatientAge"":"""_patientAge
		w """,""DiscussCTLoc"":"""_discussCtLoc_""",""DiscussCTLocDesc"":"""_discussCtLocDesc_""",""DiscussSituation"":"""_discussSituation_""",""DiscussRecord"":"""
		s obj=##class(DHCINM.HB.MgCaseDiscuss).%OpenId(id)
		while ('obj.DiscussRecordExt.AtEnd){
			w $zcvt($tr(obj.DiscussRecordExt.Read(),$c(10,13)),"O","JS")
		}
		w """,""DiscussStatus"":"""_discussStatus_""",""DiscussStatusDesc"":"""_discussStatusDesc_""",""Creator"":"""_creator_""",""CreatorName"":"""_creatorName
		w """,""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime_""",""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="DiscussType|"_discussType_"^DiscussTypeDesc|"_discussTypeDesc_"^DiscussHost|"_host_"^DiscussHostName|"_hostName_"^DiscussDate|"_discussDate
		s ret=ret_"^DiscussParticipant|"_participantId_"^DiscussParticipantName|"_participantName_"^DiscussPAPatMas|"_patMas_"^DiscussRegNo|"_discussRegNo
		s ret=ret_"^DiscussPatientName|"_patientName_"^DiscussPatientSex|"_patientSex_"^DiscussPatientAge|"_patientAge_"^DiscussCTLoc|"_discussCtLoc
		s ret=ret_"^DiscussCTLocDesc|"_discussCtLocDesc_"^DiscussSituation|"_discussSituation_"^DiscussRecord|"_discussRecord_"^DiscussStatus|"_discussStatus
		s ret=ret_"^DiscussStatusDesc|"_discussStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
		q ret
	}
}

/// Description：获取病例讨论列表
/// Date:2020-07-04
/// Creator:wangpf
/// Table:DHCINM.HB.MgCaseDiscuss
/// Input: 病区Id^开始日期^结束日期 登录人Id 登录人角色
/// Output:病例讨论列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindDiscussList","1^^",0)
Query FindDiscussList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDiscussListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ctloc=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	;s perId=$p(parr,"^",4)
	s ward=$p(parr,"^",4)
	s type=$p(parr,"^",5)
	s typeList=$lfs(type,",")
	s status=$p(parr,"^",6)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s ctlocId="" f  s ctlocId=$o(^DHCINM.HB.MgCaseDiscussI("CTLoc",ctlocId)) q:ctlocId=""  d
	.q:(ctloc'="")&&(ctloc'=ctlocId)
	.s id="" f  s id=$o(^DHCINM.HB.MgCaseDiscussI("CTLoc",ctlocId,id)) q:id=""  d
	..q:'$d(^DHCINM.HB.MgCaseDiscussD(id))
	..s discussGlo=^DHCINM.HB.MgCaseDiscussD(id)
	..s creator=$lg(discussGlo,16)
	..q:creator=""
	..s discussDate=$lg(discussGlo,4)
	..q:((stDate'="")&&(stDate>discussDate))||((endDate'="")&&(endDate<discussDate))
	..s host=$lg(discussGlo,3)
	..s participant=$lg(discussGlo,5)
	..s perIdList=$lfs(host)_participant
	..;q:(perId'="")&&($lf(perIdList,perId)=0)
	..s discussType=$lg(discussGlo,2)
	..q:(type'="")&&($lf(typeList,discussType)=0)
	..s discussStatus=$lg(discussGlo,15)
	..q:(status'="")&&(status'=discussStatus)
	..s checkward=""
	..q:(creator=0)&&(nurseid'=0)
	..s uesrGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	..s perDR=$lg(uesrGlo,5)
	..s creatDate=$lg(discussGlo,17)
	..;s curWard=##class(web.INMHRComm).GetCurrentWard(perDR,$select(creatDate'="":creatDate,1:+$h))
	..s curWard=##class(web.INMHRComm).GetCurrentWard(perDR,$select(creatDate'="":creatDate,1:+$h),0)
	..q:((ward'="")&&(ward'=curWard))||((isAll'=1)&&(curWard'="")&&('$d(tmpWard(curWard))))
	..s ret=..GetDiscuss(id)
	..s wardDesc="" 
	..s:curWard'="" wardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(curWard)),4)
	..s:ret'="" ret=ret_"^WardDesc|"_wardDesc
	..d:ret'="" OutDiscussList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutDiscussList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDiscussListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDiscussListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDiscussListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDiscussListExecute ]
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

/// Description: 删除病例讨论
/// Date: 2020-07-04
/// Creator: wangpf
/// Table: DHCINM.HB.MgCaseDiscuss
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteDiscuss(1)
ClassMethod DeleteDiscuss(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgCaseDiscuss).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存计划
/// Date: 2020-07-06
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlan
/// Input: parr
/// Output: 0：失败 其他：成功
/// Other: w ##class(web.INMHBComm).SavePlan(^TMP("SavePlan"),0)
ClassMethod SavePlan(parr As %String = "", content As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	s ^TMP("SavePlan")=parr
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s type=$p(parr,"^",2)
	s date=$p(parr,"^",3)
	s status=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	s:rw="" rw=$o(^DHCINM.HB.MgPlanI("WardDate"," "_type,ward," "_date,""))
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgPlan).%New()
	.d obj.PlanWardSetObjectId(ward)
	.s obj.PlanType=type
	.s obj.PlanDate=date
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgPlan).%OpenId(rw)
	q:'$IsObject(obj) 0
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.PlanContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.PlanContentExt.Write(content)
	}
	s obj.PlanStatus=status
	i status="Y" d
	.s now=$h
	.s obj.SubmitDate=+now
	.s obj.SubmitTime=$p(now,",",2)
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 获取计划
/// Date: 2020-07-06
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlan
/// Input: id flag:是否返回计划内容
/// Output: 计划
/// Other: w ##class(web.INMHBComm).GetPlan(1)
ClassMethod GetPlan(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.HB.MgPlanD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s planGlo=^DHCINM.HB.MgPlanD(id)
	s planWard=$lg(planGlo,2)
	s planWardDesc=""
	i planWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(planWard))
	.s planWardDesc=$lg(wardGlo,4)
	s planType=$lg(planGlo,3)
	s planTypeDesc=$case(planType,"Y":"年度","H":"半年度","S":"季度","M":"月度",:"")
	s planDate=$lg(planGlo,4)
	s planDateDesc=""
	i planType="Y" s planDateDesc=planDate
	e  d
	.s last=$e(planDate,*-1,*)
	.i planType="H" d
	..i last="01" s planDateDesc="上半年"
	..e  i last="02" s planDateDesc="下半年"
	.e  i planType="S" d
	..i last="01" s planDateDesc="第一季度"
	..e  i last="02" s planDateDesc="第二季度"
	..e  i last="03" s planDateDesc="第三季度"
	..e  i last="04" s planDateDesc="第四季度"
	.e  i planType="M"  s planDateDesc=$fn(last,"",0)_"月"
	s planContent=""
	;s:flag=1 planContent=$lg(planGlo,5)
	s planStatus=$lg(planGlo,6)
	s planStatusDesc=$case(planStatus,"N":"保存","Y":"提交","A":"审核","B":"驳回",:"")
	s creator=$lg(planGlo,7)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(planGlo,8)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(planGlo,9)
	s:createTime'="" createTime=$zt(createTime,1)
	s submitDate=$lg(planGlo,10)
	s:submitDate'="" submitDate=$zd(submitDate,3)
	s submitTime=$lg(planGlo,11)
	s:submitTime'="" submitTime=$zt(submitTime,1)
	
	i flag=1{
		w "{""PlanWard"":"""_planWard_""",""PlanWardDesc"":"""_planWardDesc_""",""PlanType"":"""_planType_""",""PlanTypeDesc"":"""_planTypeDesc_""",""PlanDate"":"""_planDate
		w """,""PlanDateDesc"":"""_planDateDesc_""",""PlanContent"":"""
		s obj=##class(DHCINM.HB.MgPlan).%OpenId(id)
		while ('obj.PlanContentExt.AtEnd){
			w $zcvt($tr(obj.PlanContentExt.Read(),$c(10,13)),"O","JS")
		}
		w """,""PlanStatus"":"""_planStatus_""",""PlanStatusDesc"":"""_planStatusDesc_""",""Creator"":"""_creator_""",""CreatorName"":"""_creatorName
		w """,""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime_""",""SubmitDate"":"""_submitDate_""",""SubmitTime"":"""_submitTime
		w """,""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="PlanWard|"_planWard_"^PlanWardDesc|"_planWardDesc_"^PlanType|"_planType_"^PlanTypeDesc|"_planTypeDesc_"^PlanDate|"_planDate
		s ret=ret_"^PlanDateDesc|"_planDateDesc_"^PlanContent|"_planContent_"^PlanStatus|"_planStatus_"^PlanStatusDesc|"_planStatusDesc
		s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^SubmitDate|"_submitDate
		s ret=ret_"^SubmitTime|"_submitTime_"^rw|"_id
		q ret
	}
}

/// Description: 获取护理部计划
/// Date: 2020-07-06
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlan
/// Input: id
/// Output: 护理部计划
/// Other: w ##class(web.INMHBComm).GetHLBPlan()
ClassMethod GetHLBPlan() As %String
{
	s planId="",content=0
	s date=$zdh(+$zd(+$h,3)_"-01-01",3)
	s planId=$o(^DHCINM.OrgManage.WorkPlanI("YearType",date," 年度",""),-1)
	i planId'="" {
	s glo=$g(^DHCINM.OrgManage.WorkPlanD(planId))
	s status=$lg(glo,6)
	q:status'="N" 0
	s obj=##class(DHCINM.OrgManage.WorkPlan).%OpenId(planId)
	q:'$IsObject(obj) 0
	while ('obj.ContentExt.AtEnd){
		s content=$tr(obj.ContentExt.Read(),$c(10,13))
	}
	i content=0 s content="无内容"
	}
	w content
	q ""
}

/// Description：获取计划列表
/// Date:2020-07-06
/// Creator:wangpf
/// Table:DHCINM.HB.MgPlan
/// Input: 年度^病区Id^类型^日期^状态 登录人Id 登录人角色
/// Output:计划列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindPlanList","2020^1^Y^^",0,0)
Query FindPlanList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPlanListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s year=$p(parr,"^")
	s ward=$p(parr,"^",2)
	s type=$p(parr,"^",3)
	s typeSub=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	i (year="")||(ward="")||(type="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s wardGlo=$g(^CF.DHCINM.DB.MgWardD(ward))
	s wardDesc=$lg(wardGlo,4)
	s typeDesc=$case(type,"Y":"年度","H":"半年度","S":"季度","M":"月度",:"")
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	i type="Y" s dateList=$lb(year)
	e  i type="H" s dateList=$lb(year_"01",year_"02")
	e  i type="S" s dateList=$lb(year_"01",year_"02",year_"03",year_"04")
	e  i type="M" d
	.s dateList=$lb()
	.f i=1:1:12 d
	..s month=$tr($justify(i,2)," ",0)
	..s $list(dateList,i)=year_month
	
	s ptr=0 f  s stat=$listnext(dateList,ptr,date) q:stat'=1  d
	.s id=$o(^DHCINM.HB.MgPlanI("WardDate"," "_type,ward," "_date,""))
	.q:(status="U")&&(id'="")
	.q:(status'="")&&(status'="U")&&(id="")
	.q:(typeSub'="")&&(($l(date)'=6)||(typeSub'=$e(date,*-1,*)))
	.i id="" d
	..s dateDesc=""
	..i type="Y" s dateDesc=date
	..e  d
	...s last=$e(date,*-1,*)
	...i type="H" d
	....i last="01" s dateDesc="上半年"
	....e  i last="02" s dateDesc="下半年"
	...e  i type="S" d
	....i last="01" s dateDesc="第一季度"
	....e  i last="02" s dateDesc="第二季度"
	....e  i last="03" s dateDesc="第三季度"
	....e  i last="04" s dateDesc="第四季度"
	...e  i type="M"  s dateDesc=$fn(last,"",0)_"月"
	..s ret="PlanWard|"_ward_"^PlanWardDesc|"_wardDesc_"^PlanType|"_type_"^PlanTypeDesc|"_typeDesc_"^PlanDate|"_date_"^PlanDateDesc|"_dateDesc
	..s ret=ret_"^PlanContent|^PlanStatus|U^PlanStatusDesc|未保存^Creator|^CreatorName|^CreateDate|^CreateTime|^SubmitDate|^SubmitTime|^rw|"
	..d OutPlanList
	.e  d
	..s planGlo=$g(^DHCINM.HB.MgPlanD(id))
	..s planStatus=$lg(planGlo,6)
	..q:(status'="")&&(status'=planStatus)
	..s ret=..GetPlan(id)
	..d:ret'="" OutPlanList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPlanListExecute ]
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

/// Description: 审核计划
/// Date: 2020-07-06
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlan
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).AuditPlan(1,"A")
ClassMethod AuditPlan(id As %String = "", status As %String = "") As %String
{
	q:(id="")||(status="") 0
	
	s obj=##class(DHCINM.HB.MgPlan).%OpenId(id)
	q:'$IsObject(obj)
	s obj.PlanStatus=status
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.PlanStatus="A")||(obj.PlanStatus="B"))) d
		.s PlanStatus=$case(obj.PlanStatus,"A":"审核","B":"驳回") ;状态描述
		.s PlanWardID=$lg($g(^DHCINM.HB.MgPlanD(id)),2) 
		.s WardDesc=""
		.s:PlanWardID'="" WardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(PlanWardID)),4) ;病区描述
		.s PlanDateDesc=""	                            ;计划日期描述
		.s PlanDate=$lg($g(^DHCINM.HB.MgPlanD(id)),4)
		.s PlanType=$lg($g(^DHCINM.HB.MgPlanD(id)),3)
		.i PlanType="Y" s PlanDateDesc=PlanDate
		.e  d	
		..s last=$e(PlanDate,*-1,*)
		..i PlanType="H" d
		...i last="01" s PlanDateDesc="上半年"
		...e  i last="02" s PlanDateDesc="下半年"
		..e  i PlanType="S" d
		...i last="01" s PlanDateDesc="第一季度"
		...e  i last="02" s PlanDateDesc="第二季度"
		...e  i last="03" s PlanDateDesc="第三季度"
		...e  i last="04" s PlanDateDesc="第四季度"
		..e  i PlanType="M" s PlanDateDesc=$fn(last,"",0)_"月"
		.s ret="【护长手册/计划总结/计划重点】"_PlanStatus_" "_WardDesc_" "_PlanDateDesc
		.s Creator=$lg($g(^DHCINM.HB.MgPlanD(id)),7)
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.HB.MgPlan",id)
	}catch{
		
	}
	
	q $$$ISOK(sc)
}

/// Description: 删除计划
/// Date: 2020-07-06
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlan
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeletePlan(1)
ClassMethod DeletePlan(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgPlan).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存计划重点
/// Date: 2020-07-07
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlanKey
/// Input: parr 登录人Id
/// Output: 0：失败 其他：成功
/// Other: w ##class(web.INMHBComm).SavePlanKey("",0)
ClassMethod SavePlanKey(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s type=$p(parr,"^",2)
	s date=$p(parr,"^",3)
	s:date["-" date=$zdh(date,3)
	s content=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	q:(ward="")||(type="")||(date="") 0
	s:rw="" rw=$o(^DHCINM.HB.MgPlanKeyI("WardDate"," "_type,ward,date,""))
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgPlanKey).%New()
	.d obj.KeyWardSetObjectId(ward)
	.s obj.KeyType=type
	.s obj.KeyDate=date
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgPlanKey).%OpenId(rw)
	
	q:'$IsObject(obj) 0
	s obj.KeyContent=content
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 获取计划重点
/// Date: 2020-07-07
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlanKey
/// Input: id
/// Output: 计划重点
/// Other: w ##class(web.INMHBComm).GetPlanKey(1)
ClassMethod GetPlanKey(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgPlanKeyD(id))) ""
	
	s keyGlo=^DHCINM.HB.MgPlanKeyD(id)
	s keyWard=$lg(keyGlo,2)
	s keyWardDesc=""
	i keyWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(keyWard))
	.s keyWardDesc=$lg(wardGlo,4)
	s keyType=$lg(keyGlo,3)
	s keyTypeDesc=$case(keyType,"W":"周重点","D":"日重点",:"")
	s keyDate=$lg(keyGlo,4)
	s keyDateDesc=""
	i keyDate'="" d
	.i keyType="D" s keyDateDesc=$zd(keyDate,3)
	.e  i keyType="W" d
	..s dayOfMonth=$SYSTEM.SQL.DAYOFMONTH(keyDate)
	..s firstDayOfMonth=keyDate-dayOfMonth+1
	..s firstDayOfWeek=$SYSTEM.SQL.DAYOFWEEK(firstDayOfMonth)
	..s firstMonday=9-firstDayOfWeek#7+firstDayOfMonth
	..s index=keyDate-firstMonday/7+1
	..s keyDateDesc="第"_index_"周"_$zd(keyDate,3)_"~"_$zd(keyDate+6,3)
	s:keyDate'="" keyDate=$zd(keyDate,3)
	s keyContent=$lg(keyGlo,5)
	s creator=$lg(keyGlo,6)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(keyGlo,7)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(keyGlo,8)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="KeyWard|"_keyWard_"^KeyWardDesc|"_keyWardDesc_"^KeyType|"_keyType_"^KeyTypeDesc|"_keyTypeDesc_"^KeyDate|"_keyDate
	s ret=ret_"^KeyDateDesc|"_keyDateDesc_"^KeyContent|"_keyContent_"^Creator|"_creator_"^CreatorName|"_creatorName
	s ret=ret_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description：获取计划重点列表
/// Date:2020-07-07
/// Creator:wangpf
/// Table:DHCINM.HB.MgPlan
/// Input: 病区Id^类型^日期 登录人Id 登录人角色
/// Output:计划重点列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindPlanKeyList","1^W^2021-03-01",0)
Query FindPlanKeyList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPlanKeyListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s type=$p(parr,"^",2)
	s month=$p(parr,"^",3)
	s:month["-" date=$zdh(month,3)
	i (ward="")||(type="")||(date="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	i (isAll'=1)&&('$d(tmpWard(ward))) Set qHandle=$lb(0,repid,0) Quit $$$OK
	i type="D" s stDate=date-1,endDate=$SYSTEM.SQL.LASTDAY(month)
	e  i type="W" d
	.s stDate=date-1
	.s nextMonth=$SYSTEM.SQL.LASTDAY(month)+1
	.s nextMonthDay=$SYSTEM.SQL.DAYOFWEEK(nextMonth)
	.s nextMonthMonday=9-nextMonthDay#7+nextMonth
	.s endDate=nextMonthMonday-7
	
	s date=stDate f  s date=$o(^DHCINM.HB.MgPlanKeyI("WardDate"," "_type,ward,date)) q:(date="")||(date>endDate)  d
	.s id="" f  s id=$o(^DHCINM.HB.MgPlanKeyI("WardDate"," "_type,ward,date,id)) q:id=""  d
	..s ret=..GetPlanKey(id)
	..d:ret'="" OutPlanKeyList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanKeyList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPlanKeyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPlanKeyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPlanKeyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPlanKeyListExecute ]
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

/// Description: 删除计划重点
/// Date: 2020-07-07
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlanKey
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeletePlanKey(1^2^3)
ClassMethod DeletePlanKey(id As %String = "") As %String
{
	q:id="" 0
	s idList=$lfs(id,"^")
	s flag=1
	ts
	s ptr=0 f  s status=$listnext(idList,ptr,keyId) q:(status'=1)||(flag'=1)  d
	.q:keyId=""
	.s obj=##class(DHCINM.HB.MgPlanKey).%OpenId(keyId)
	.q:'$IsObject(obj)
	.s sc=##class(DHCINM.HB.MgPlanKey).%DeleteId(keyId)
	.s flag=$$$ISOK(sc)
	i flag=1 tc  q 1
	e  tro  q 0
}

/// Description: 保存计划、重点追踪
/// Date: 2020-07-07
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlanTracking
/// Input: parr 登录人Id
/// Output: 0：失败 其他：成功
/// Other: w ##class(web.INMHBComm).SaveTracking("",0)
ClassMethod SaveTracking(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s source=$p(parr,"^")
	s type=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s status=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	q:(source="")||(type="") 0
	s:rw="" rw=$o(^DHCINM.HB.MgPlanTrackingI("Source"," "_type," "_source,""))
	i rw="" d
	.s obj=##class(DHCINM.HB.MgPlanTracking).%New()
	.s obj.TrackingSource=source
	.s obj.TrackingType=type
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgPlanTracking).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.TrackingReason=reason
	s obj.TrackingStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description：获取计划、重点追踪列表
/// Date:2020-07-07
/// Creator:wangpf
/// Table:DHCINM.HB.MgPlan
/// Input: 年度^病区Id^类型^日期^状态 登录人Id 登录人角色
/// Output:计划重点追踪列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindTrackingList","2021^^W^2021-03^",0)
Query FindTrackingList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTrackingListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s year=$p(parr,"^")
	s ward=$p(parr,"^",2)
	s type=$p(parr,"^",3)
	s month=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s weekNum=$P(parr,"^",6)
	i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s typeDesc=$case(type,"M":"月计划","W":"周重点",:"")
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	i type="M" d
	.s tmpMonth=$tr(month,"-","")
	.s PlanWard="" f  s PlanWard=$o(^DHCINM.HB.MgPlanI("WardDate"," M",PlanWard)) q:PlanWard=""  d
	..s PlanDate="" f  s PlanDate=$o(^DHCINM.HB.MgPlanI("WardDate"," M",PlanWard,PlanDate)) q:PlanDate=""  d
	...s id="" f  s id=$o(^DHCINM.HB.MgPlanI("WardDate"," M",PlanWard,PlanDate,id)) q:id=""  d
	....q:'$d(^DHCINM.HB.MgPlanD(id))
	....s planGlo=^DHCINM.HB.MgPlanD(id)
	....s planWard=$lg(planGlo,2)
	....q:((ward'="")&&(ward'=planWard))||((isAll'=1)&&('$d(tmpWard(planWard))))
	....s planWardDesc=""
	....i planWard'="" d
	.....s wardGlo=$g(^CF.DHCINM.DB.MgWardD(planWard))
	.....s planWardDesc=$lg(wardGlo,4)
	....s planDate=$lg(planGlo,4)
	....s planDateDesc=$e(planDate,1,4)_"-"_$e(planDate,5,*)
	....q:(tmpMonth'="")&&(tmpMonth'=planDate)
	....s planYear=$e(planDate,1,4)
	....q:(year'="")&&(year'=planYear)
	....s trackingStatus="N",trackingReason="",creator="",creatorName="",createDate="",createTime=""
	....s trackingId=$o(^DHCINM.HB.MgPlanTrackingI("Source"," M"," "_id,""))
	....i trackingId'="" d
	.....s trackingGlo=$g(^DHCINM.HB.MgPlanTrackingD(trackingId))
	.....s trackingStatus=$lg(trackingGlo,5)
	.....s trackingReason=$lg(trackingGlo,4)
	....q:(status'="")&&(status'=trackingStatus)
	....s trackingStatusDesc=$case(trackingStatus,"N":"未完成","Y":"已完成",:"")
	....s ret="TrackingWard|"_planWard_"^TrackingWardDesc|"_planWardDesc_"^TrackingSource|"_id_"^TrackingType|"_type_"^TrackingTypeDesc|"_typeDesc
	....s ret=ret_"^TrackingDate|"_planDateDesc_"^TrackingContent|^TrackingStatus|"_trackingStatus_"^TrackingStatusDesc|"_trackingStatusDesc_"^TrackingReason|"_trackingReason
	....s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_trackingId
	....d OutTrackingList
	e  i type="W" d
	.s KeyWard="" f  s KeyWard=$O(^DHCINM.HB.MgPlanKeyI("WardDate"," W",KeyWard)) q:KeyWard=""  d
	..q:((ward'="")&&(ward'=KeyWard))||((isAll'=1)&&('$d(tmpWard(KeyWard))))
	..s KeyDate="" f  s KeyDate=$O(^DHCINM.HB.MgPlanKeyI("WardDate"," W",KeyWard,KeyDate)) q:KeyDate=""  d 
	...s id="" f  s id=$o(^DHCINM.HB.MgPlanKeyI("WardDate"," W",KeyWard,KeyDate,id)) q:id=""  d
	....q:'$d(^DHCINM.HB.MgPlanKeyD(id))
	....s keyGlo=^DHCINM.HB.MgPlanKeyD(id)
	....s keyWardDesc=""
	....s wardGlo=$g(^CF.DHCINM.DB.MgWardD(KeyWard))
	....s keyWardDesc=$lg(wardGlo,4)
	....s keyDate=$lg(keyGlo,4)
	....s keyDateDesc=""
	....s index=""
	....i keyDate'="" d
	.....s dayOfMonth=$SYSTEM.SQL.DAYOFMONTH(keyDate)
	.....s firstDayOfMonth=keyDate-dayOfMonth+1
	.....s firstDayOfWeek=$SYSTEM.SQL.DAYOFWEEK(firstDayOfMonth)
	.....s firstMonday=9-firstDayOfWeek#7+firstDayOfMonth
	.....s index=keyDate-firstMonday/7+1
	.....s keyDateDesc="第"_index_"周"_$zd(keyDate,3)_"~"_$zd(keyDate+6,3)
	....s:keyDate'="" keyDate=$zd(keyDate,3)
	....q:(month'="")&&(month'=$e(keyDate,1,7))
	....q:((weekNum'="")&&(index'=weekNum))
	....s keyContent=$lg(keyGlo,5)
	....s trackingStatus="N",trackingReason="",creator="",creatorName="",createDate="",createTime=""
	....s trackingId=$o(^DHCINM.HB.MgPlanTrackingI("Source"," W"," "_id,""))
	....i trackingId'="" d
	.....s trackingGlo=$g(^DHCINM.HB.MgPlanTrackingD(trackingId))
	.....s trackingReason=$lg(trackingGlo,4)
	.....s trackingStatus=$lg(trackingGlo,5)
	....q:(status'="")&&(status'=trackingStatus)
	....s trackingStatusDesc=$case(trackingStatus,"N":"未完成","Y":"已完成",:"")
	....s ret="TrackingWard|"_KeyWard_"^TrackingWardDesc|"_keyWardDesc_"^TrackingSource|"_id_"^TrackingType|"_type_"^TrackingTypeDesc|"_typeDesc
	....s ret=ret_"^TrackingDate|"_keyDateDesc_"^TrackingContent|"_keyContent_"^TrackingStatus|"_trackingStatus_"^TrackingStatusDesc|"_trackingStatusDesc
	....s ret=ret_"^TrackingReason|"_trackingReason_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_trackingId
	....d OutTrackingList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTrackingList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTrackingListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrackingListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTrackingListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrackingListExecute ]
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

/// Description: 保存计划总结
/// Date: 2020-07-08
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlanConclusion
/// Input: parr 登录人Id
/// Output: 0：失败 其他：成功
/// Other: w ##class(web.INMHBComm).SaveConclusion("",0)
ClassMethod SaveConclusion(parr As %String = "", content As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s type=$p(parr,"^",2)
	s date=$p(parr,"^",3)
	s status=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	s:rw="" rw=$o(^DHCINM.HB.MgPlanConclusionI("WardDate"," "_type,ward," "_date,""))
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgPlanConclusion).%New()
	.d obj.ConcWardSetObjectId(ward)
	.s obj.ConcType=type
	.s obj.ConcDate=date
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgPlanConclusion).%OpenId(rw)
	q:'$IsObject(obj) 0
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.ConcContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.ConcContentExt.Write(content)
	}
	s obj.ConcStatus=status
	i status="Y" d
	.s now=$h
	.s obj.SubmitDate=+now
	.s obj.SubmitTime=$p(now,",",2)
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 获取计划总结
/// Date: 2020-07-08
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlanConclusion
/// Input: id flag:是否返回计划总结内容
/// Output: 计划总结
/// Other: w ##class(web.INMHBComm).GetConclusion(1)
ClassMethod GetConclusion(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.HB.MgPlanConclusionD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s concGlo=^DHCINM.HB.MgPlanConclusionD(id)
	s concWard=$lg(concGlo,2)
	s concWardDesc=""
	i concWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(concWard))
	.s concWardDesc=$lg(wardGlo,4)
	s concType=$lg(concGlo,3)
	s concTypeDesc=$case(concType,"Y":"年度","H":"半年度","S":"季度","M":"月度",:"")
	s concDate=$lg(concGlo,4)
	s concDateDesc=""
	i concType="Y" s concDateDesc=concDate
	e  d
	.s last=$e(concDate,*-1,*)
	.i concType="H" d
	..i last="01" s concDateDesc="上半年"
	..e  i last="02" s concDateDesc="下半年"
	.e  i concType="S" d
	..i last="01" s concDateDesc="第一季度"
	..e  i last="02" s concDateDesc="第二季度"
	..e  i last="03" s concDateDesc="第三季度"
	..e  i last="04" s concDateDesc="第四季度"
	.e  i concType="M"  s concDateDesc=$fn(last,"",0)_"月"
	s concContent=""
	;s:flag=1 concContent=$lg(concGlo,5)
	s concStatus=$lg(concGlo,6)
	s concStatusDesc=$case(concStatus,"N":"保存","Y":"提交","A":"审核","B":"驳回",:"")
	s creator=$lg(concGlo,7)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(concGlo,8)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(concGlo,9)
	s:createTime'="" createTime=$zt(createTime,1)
	s submitDate=$lg(concGlo,10)
	s:submitDate'="" submitDate=$zd(submitDate,3)
	s submitTime=$lg(concGlo,11)
	s:submitTime'="" submitTime=$zt(submitTime,1)
	
	i flag=1{
		w "{""ConcWard"":"""_concWard_""",""ConcWardDesc"":"""_concWardDesc_""",""ConcType"":"""_concType_""",""ConcTypeDesc"":"""_concTypeDesc_""",""ConcDate"":"""_concDate
		w """,""ConcDateDesc"":"""_concDateDesc_""",""ConcContent"":"""
		s obj=##class(DHCINM.HB.MgPlanConclusion).%OpenId(id)
		while ('obj.ConcContentExt.AtEnd){
			w $tr(obj.ConcContentExt.Read(),$c(10,13))
		}
		w """,""ConcStatus"":"""_concStatus_""",""ConcStatusDesc"":"""_concStatusDesc_""",""Creator"":"""_creator_""",""CreatorName"":"""_creatorName
		w """,""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime_""",""SubmitDate"":"""_submitDate_""",""SubmitTime"":"""_submitTime
		w """,""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="ConcWard|"_concWard_"^ConcWardDesc|"_concWardDesc_"^ConcType|"_concType_"^ConcTypeDesc|"_concTypeDesc_"^ConcDate|"_concDate
		s ret=ret_"^ConcDateDesc|"_concDateDesc_"^ConcContent|"_concContent_"^ConcStatus|"_concStatus_"^ConcStatusDesc|"_concStatusDesc
		s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^SubmitDate|"_submitDate
		s ret=ret_"^SubmitTime|"_submitTime_"^rw|"_id
		q ret
	}
}

/// Description：获取计划总结列表
/// Date:2020-07-08
/// Creator:wangpf
/// Table:DHCINM.HB.MgPlanConclusion
/// Input: 年度^病区Id^类型^日期^状态 登录人Id 登录人角色
/// Output:计划总结列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindConcList","2020^1^Y^^",0,0)
Query FindConcList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindConcListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s year=$p(parr,"^")
	s ward=$p(parr,"^",2)
	s type=$p(parr,"^",3)
	s typeSub=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	i (year="")||(ward="")||(type="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s wardGlo=$g(^CF.DHCINM.DB.MgWardD(ward))
	s wardDesc=$lg(wardGlo,4)
	s typeDesc=$case(type,"Y":"年度","H":"半年度","S":"季度","M":"月度",:"")
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	i type="Y" s dateList=$lb(year)
	e  i type="H" s dateList=$lb(year_"01",year_"02")
	e  i type="S" s dateList=$lb(year_"01",year_"02",year_"03",year_"04")
	e  i type="M" d
	.s dateList=$lb()
	.f i=1:1:12 d
	..s month=$tr($justify(i,2)," ",0)
	..s $list(dateList,i)=year_month
	
	s ptr=0 f  s stat=$listnext(dateList,ptr,date) q:stat'=1  d
	.s id=$o(^DHCINM.HB.MgPlanConclusionI("WardDate"," "_type,ward," "_date,""))
	.q:(status="U")&&(id'="")
	.q:(status'="")&&(status'="U")&&(id="")
	.q:(typeSub'="")&&(($l(date)'=6)||(typeSub'=$e(date,*-1,*)))
	.i id="" d
	..s dateDesc=""
	..i type="Y" s dateDesc=date
	..e  d
	...s last=$e(date,*-1,*)
	...i type="H" d
	....i last="01" s dateDesc="上半年"
	....e  i last="02" s dateDesc="下半年"
	...e  i type="S" d
	....i last="01" s dateDesc="第一季度"
	....e  i last="02" s dateDesc="第二季度"
	....e  i last="03" s dateDesc="第三季度"
	....e  i last="04" s dateDesc="第四季度"
	...e  i type="M"  s dateDesc=$fn(last,"",0)_"月"
	..s ret="ConcWard|"_ward_"^ConcWardDesc|"_wardDesc_"^ConcType|"_type_"^ConcTypeDesc|"_typeDesc_"^ConcDate|"_date_"^ConcDateDesc|"_dateDesc
	..s ret=ret_"^ConcContent|^ConcStatus|U^ConcStatusDesc|未保存^Creator|^CreatorName|^CreateDate|^CreateTime|^SubmitDate|^SubmitTime|^rw|"
	..d OutConcList
	.e  d
	..b ;01
	..s concGlo=$g(^DHCINM.HB.MgPlanConclusionD(id))
	..s concStatus=$lg(concGlo,6)
	..q:(status'="")&&(status'=concStatus)
	..s ret=..GetConclusion(id)
	..d:ret'="" OutConcList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutConcList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindConcListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindConcListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindConcListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindConcListExecute ]
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

/// Description: 审核计划总结
/// Date: 2020-07-08
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlanConclusion
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).AuditConclusion(4,"B")
ClassMethod AuditConclusion(id As %String = "", status As %String = "") As %String
{
	q:(id="")||(status="") 0
	
	s obj=##class(DHCINM.HB.MgPlanConclusion).%OpenId(id)
	q:'$IsObject(obj)
	s obj.ConcStatus=status
	s sc=obj.%Save()
	
	i (($$$ISOK(sc))&&((obj.ConcStatus="A")||(obj.ConcStatus="B"))) d
	.s ConcStatus=$case(obj.ConcStatus,"A":"审核","B":"驳回") ;状态描述
	.s WardDesc=""
	.s ConcWard=$lg($g(^DHCINM.HB.MgPlanConclusionD(id)),2)  
	.s:ConcWard'="" WardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(ConcWard)),4) ;病区
	.s SubmitDate=""
	.s SubmitDate1=$lg($g(^DHCINM.HB.MgPlanConclusionD(id)),10)
	.s:SubmitDate1'="" SubmitDate=$zd(SubmitDate1,3) ;提交日期
	.s Creator=$lg($g(^DHCINM.HB.MgPlanConclusionD(id)),7)
	.s ret="【护长手册/计划总结/小结总结】 "_ConcStatus_" "_WardDesc_" "_SubmitDate
	.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.HB.MgPlanConclusion",id)
	
	q $$$ISOK(sc)
}

/// Description: 删除计划总结
/// Date: 2020-07-08
/// Creator: wangpf
/// Table: DHCINM.HB.MgPlanConclusion
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteConclusion(1)
ClassMethod DeleteConclusion(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgPlanConclusion).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description：根据职务类型查询人员名单
/// Date:2020-07-08
/// Creator:wangpf
/// Table:CF.DHCINM.HR.PostDuty
/// Input: 职务名称
/// Output:指定职位人员
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindNurseHead","护士长!科护士长")
Query FindNurseHead(post As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurseHeadExecute(ByRef qHandle As %Binary, post As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i post="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s parId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 职务",""))
	i parId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s postList=$lfs(post,"!")
	s postFilter=$lb(),couter=1
	s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)) q:subId=""  d
	.s codeGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s codeDesc=$lg(codeGlo,3)
	.q:$lf(postList,codeDesc)=0
	.s $li(postFilter,couter)=parId_"||"_subId
	.s couter=couter+1
	
	s now=+$h
	s tmpPer=""
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
	.s perName=$lg(perGlo,2)
	.s perNamePY=##class(web.INMVueComm).ToChineseSpell(perName)
	.s perNo=$lg(perGlo,3)
	.q:(input'="")&&($zcvt(perName_perNamePY_perNo,"U")'[$zcvt(input,"U"))
	.s ward=$lg(perGlo,10)
	.q:'$d(^CF.DHCINM.DB.MgWardD(ward))
	.s wardGlo=^CF.DHCINM.DB.MgWardD(ward)
	.s wardDesc=$lg(wardGlo,4)
	.s ret="Per|"_per_"^PerName|"_perName_"^Ward|"_ward_"^WardDesc|"_wardDesc
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

ClassMethod FindNurseHeadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseForTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurseHeadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseHeadExecute ]
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

/// Description: 保存手册审阅
/// Date: 2020-07-08
/// Creator: wangpf
/// Table: DHCINM.HB.MgBookCheck
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveBookCheck("",0)
ClassMethod SaveBookCheck(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s year=$p(parr,"^")
	s per=$p(parr,"^",2)
	q:'$d(^CF.DHCINM.HR.PersonsD(per)) 0
	s item=$p(parr,"^",3)
	s itemList=$lfs(item,",")
	s reason=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgBookCheck).%New()
	.s obj.CheckYear=year
	.d obj.CheckPersonSetObjectId(per)
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgBookCheck).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.CheckItem.Clear()
	s ptr=0 f  s status=$listnext(itemList,ptr,itm) q:status'=1  d
	.s parId=$p(itm,"||")
	.s subId=$p(itm,"||",2)
	.q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId))
	.d obj.CheckItem.Insert(itm)
	s obj.CheckReason=reason
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取手册审阅
/// Date: 2020-07-08
/// Creator: wangpf
/// Table: DHCINM.HB.MgBookCheck
/// Input: id
/// Output: 手册审阅
/// Other: w ##class(web.INMHBComm).GetBookCheck(1)
ClassMethod GetBookCheck(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgBookCheckD(id))) ""
	
	s checkGlo=^DHCINM.HB.MgBookCheckD(id)
	s checkYear=$lg(checkGlo,2)
	s checkPer=$lg(checkGlo,3)
	s checkPerName=""
	i checkPer=0 s checkPerName="管理员"
	e  i checkPer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(checkPer))
	.s checkPerName=$lg(perGlo,2)
	s checkItem=$lg(checkGlo,4)
	s checkItemId=$lts(checkItem,",")
	s checkItemId=$tr(checkItemId,"|","_")
	s checkItemDesc=""
	s index=0,ptr=0 f  s status=$listnext(checkItem,ptr,item) q:status'=1  d
	.s parId=$p(item,"||")
	.s subId=$p(item,"||",2)
	.s itemGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId))
	.s itemDesc=$lg(itemGlo,3)
	.i index=0 s checkItemDesc=itemDesc
	.e  s checkItemDesc=checkItemDesc_","_itemDesc
	.s index=index+1
	s checkReason=$lg(checkGlo,5)
	s creator=$lg(checkGlo,6)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(checkGlo,7)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(checkGlo,8)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="CheckYear|"_checkYear_"^CheckPerson|"_checkPer_"^CheckPersonName|"_checkPerName_"^CheckItem|"_checkItemId
	s ret=ret_"^CheckItemDesc|"_checkItemDesc_"^CheckReason|"_checkReason_"^Creator|"_creator_"^CreatorName|"_creatorName
	s ret=ret_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description:获取手册审阅列表
/// Date:2020-07-08
/// Creator:wangpf
/// Table:DHCINM.HB.MgBookCheck
/// Input: 年度^人员id
/// Output:手册审阅列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindCheckList","2020^1")
Query FindCheckList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCheckListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s year=$p(parr,"^")
	s nurse=$p(parr,"^",2)
	
	s checkYear="" f  s checkYear=$o(^DHCINM.HB.MgBookCheckI("YearPer",checkYear)) q:checkYear=""  d
	.q:(year'="")&&(year'=checkYear)
	.s per="" f  s per=$o(^DHCINM.HB.MgBookCheckI("YearPer",checkYear,per)) q:per=""  d
	..q:(nurse'="")&&(nurse'=per)
	..s id="" f  s id=$o(^DHCINM.HB.MgBookCheckI("YearPer",checkYear,per,id)) q:id=""  d
	...q:'$d(^DHCINM.HB.MgBookCheckD(id))
	...s ret=..GetBookCheck(id)
	...d:ret'="" OutNurseList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckListExecute ]
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

/// Description: 删除手册审阅
/// Date: 2020-07-08
/// Creator: wangpf
/// Table: DHCINM.HB.MgBookCheck
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteBookCheck(1)
ClassMethod DeleteBookCheck(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgBookCheck).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存公休会记录
/// Date: 2020-07-09
/// Creator: wangpf
/// Table: DHCINM.HB.MgRecessRecord
/// Input: parr 登录人Id
/// Output: 0：失败 其他：成功
/// Other: w ##class(web.INMHBComm).SaveRecess("",0)
ClassMethod SaveRecess(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s level=$p(parr,"^")
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s time=$p(parr,"^",3)
	s:time[":" time=$zth(time)
	s location=$p(parr,"^",4)
	s department=$p(parr,"^",5)
	s ward=$p(parr,"^",6)
	s wardList=$lfs(ward,",")
	s participant=$p(parr,"^",7)
	s partiList=$lfs(participant,",")
	s hoster=$p(parr,"^",8)
	q:(hoster="")||('$d(^CF.DHCINM.HR.PersonsD(hoster))) 0
	s hosterPost=$p(parr,"^",9)
	s parId=$p(hosterPost,"||")
	s subId=$p(hosterPost,"||",2)
	q:(hosterPost'="")&&('$d(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId))) 0
	s recorder=$p(parr,"^",10)
	q:(recorder="")||('$d(^CF.DHCINM.HR.PersonsD(recorder))) 0
	s topic=$p(parr,"^",11)
	s content=$p(parr,"^",12)
	s question=$p(parr,"^",13)
	s step=$p(parr,"^",14)
	s app=$p(parr,"^",15)
	s status=$p(parr,"^",16)
	s rw=$p(parr,"^",17)
	s participantInput=$p(parr,"^",18)
	i rw="" d
	.s obj=##class(DHCINM.HB.MgRecessRecord).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgRecessRecord).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.RecessParticipantInput=participantInput
	s obj.RecessLevel=level
	s obj.RecessDate=date
	s obj.RecessTime=time
	s obj.RecessLocation=location
	s obj.RecessDepartment=department
	d obj.RecessWard.Clear()
	s ptr=0 f  s stat=$listnext(wardList,ptr,item) q:stat'=1  d
	.s wardId=$p(item,"「")
	.s wardNumber=$p(item,"「",2)
	.q:'$d(^CF.DHCINM.DB.MgWardD(wardId))
	.d obj.RecessWard.Insert(item)
	d obj.RecessParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.RecessParticipant.Insert(per)
	d obj.RecessHosterSetObjectId(hoster)
	d:hosterPost'="" obj.RecessHosterPostSetObjectId(hosterPost)
	d obj.RecessRecorderSetObjectId(recorder)
	s obj.RecessTopic=topic
	s obj.RecessContent=content
	s obj.RecessQuestion=question
	s obj.RecessStep=step
	s obj.RecessApp=app
	i status="YY" d
	.s obj.RecessStatus="Y"
	.s obj.RecessCurStep="NY"
	e  i status="Y" d
	.s obj.RecessStatus="Y"
	.s obj.RecessCurStep="A"
	e  s obj.RecessStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 获取公休会记录
/// Date: 2020-07-09
/// Creator: wangpf
/// Table: DHCINM.HB.MgRecessRecord
/// Input: id 是否返回内容
/// Output: 公休会记录
/// Other: w ##class(web.INMHBComm).GetRecess(1)
ClassMethod GetRecess(id As %String = "", flag As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgRecessRecordD(id))) ""
	
	s recessGlo=^DHCINM.HB.MgRecessRecordD(id)
	s recessLevel=$lg(recessGlo,2)
	s recessLevelDesc=$case(recessLevel,"W":"病区","L":"科室","H":"护理部",:"")
	s recessDate=$lg(recessGlo,3)
	s:recessDate'="" recessDate=$zd(recessDate,3)
	s recessTime=$lg(recessGlo,4)
	s:recessTime'="" recessTime=$zt(recessTime)
	s recessLocation=$lg(recessGlo,5)
	s recessDepart=$lg(recessGlo,6)
	s recessWard=$lg(recessGlo,7)
	s recessWardNum=0
	s ptr=0 f  s status=$listnext(recessWard,ptr,item) q:status'=1  d
	.s wardId=$p(item,"「")
	.s wardNumber=$p(item,"「",2)
	.s recessWardNum=recessWardNum+$fn(wardNumber,"",0)
	s recessWard=$lts(recessWard,",")
	s recessParti=$lg(recessGlo,8)
	s recessPartiId=$lts(recessParti,",")
	s recessPartiName=""
	s index=1,ptr=0 f  s stat=$listnext(recessParti,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s recessPartiName=perName
	.e  s recessPartiName=recessPartiName_","_perName
	.s index=index+1
	s recessParticipantInput=$lg(recessGlo,34)
	s:(recessParticipantInput'="")&&(recessPartiName="") recessPartiName=recessParticipantInput
	s recessHoster=$lg(recessGlo,9)
	s recessHosterName=""
	i recessHoster'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(recessHoster))
	.s recessHosterName=$lg(perGlo,2)
	s recessPost=$lg(recessGlo,10)
	s recessPost=$tr(recessPost,"|","_")
	s recessPostDesc=""
	i recessPost'="" d
	.s parId=$p(recessPost,"__")
	.s subId=$p(recessPost,"__",2)
	.q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId))
	.s postGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s recessPostDesc=$lg(postGlo,3)
	s recessRecorder=$lg(recessGlo,11)
	s recessRecorderName=""
	i recessRecorder'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(recessRecorder))
	.s recessRecorderName=$lg(perGlo,2)
	s recessTopic=$lg(recessGlo,12)
	s recessContent=""
	s:flag=1 recessContent=$lg(recessGlo,13)
	s recessQuestion=""
	s:flag=1 recessQuestion=$lg(recessGlo,15)
	s recessStep=""
	s:flag=1 recessStep=$lg(recessGlo,16)
	s recessApp=""
	s:flag=1 recessApp=$lg(recessGlo,17)
	s recessAcess=$lg(recessGlo,18)
	s recessAcessDesc=$case(recessAcess,"N":"未落实","P":"部分落实","Y":"落实",:"")
	s recessReason=""
	s:flag=1 recessReason=$lg(recessGlo,19)
	s recessAcessDate=$lg(recessGlo,20)
	s:recessAcessDate'="" recessAcessDate=$zd(recessAcessDate,3)
	s recessLStatus=$lg(recessGlo,21)
	s recessLStatusDesc=$case(recessLStatus,"N":"未通过","P":"部分通过","Y":"通过",:"")
	s recessLAuditor=$lg(recessGlo,22)
	s recessLAuditorName=""
	i recessLAuditor=0 s recessLAuditorName="管理员"
	e  i recessLAuditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(recessLAuditor))
	.s recessLAuditorName=$lg(perGlo,2)
	s recessLAuditeDate=$lg(recessGlo,23)
	s:recessLAuditeDate'="" recessLAuditeDate=$zd(recessLAuditeDate,3)
	s recessLReason=""
	s:flag=1 recessLReason=$lg(recessGlo,24)
	s recessHStatus=$lg(recessGlo,25)
	s recessHStatusDesc=$case(recessHStatus,"N":"未通过","P":"部分通过","Y":"通过",:"")
	s recessHAuditor=$lg(recessGlo,26)
	s recessHAuditorName=""
	i recessHAuditor=0 s recessHAuditorName="管理员"
	e  i recessHAuditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(recessHAuditor))
	.s recessHAuditorName=$lg(perGlo,2)
	s recessHAuditeDate=$lg(recessGlo,27)
	s:recessHAuditeDate'="" recessHAuditeDate=$zd(recessHAuditeDate,3)
	s recessHReason=""
	s:flag=1 recessHReason=$lg(recessGlo,28)
	s recessStatus=$lg(recessGlo,29)
	s recessStatusDesc=$case(recessStatus,"N":"保存","Y":"提交","A":"完成",:"")
	s recessCurStep=$lg(recessGlo,30)
	;s recessCurStepDesc=$case(recessCurStep,"NY":"提请科护士长审核","LY":"提请护理部审核","A":"完成",:"")
	s recessCurStepDesc=""
	i recessCurStep="NY" s recessCurStepDesc="提请科护士长审核"
	e  i recessCurStep="LY" s recessCurStepDesc="提请护理部审核"
	e  i recessCurStep="A" d
	.i recessHStatus'="" s recessCurStepDesc=recessHStatusDesc
	.e  s recessCurStepDesc=recessLStatusDesc
	s creator=$lg(recessGlo,31)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(recessGlo,32)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(recessGlo,33)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="RecessLevel|"_recessLevel_"^RecessLevelDesc|"_recessLevelDesc_"^RecessDate|"_recessDate_"^RecessTime|"_recessTime_"^RecessLocation|"_recessLocation
	s ret=ret_"^RecessDepartment|"_recessDepart_"^RecessWard|"_recessWard_"^RecessWardNum|"_recessWardNum_"^RecessParticipant|"_recessPartiId
	s ret=ret_"^RecessParticipantName|"_recessPartiName_"^RecessHoster|"_recessHoster_"^RecessHosterName|"_recessHosterName_"^RecessHosterPost|"_recessPost
	s ret=ret_"^RecessHosterPostDesc|"_recessPostDesc_"^RecessRecorder|"_recessRecorder_"^RecessRecorderName|"_recessRecorderName_"^RecessTopic|"_recessTopic
	s ret=ret_"^RecessContent|"_recessContent_"^RecessQuestion|"_recessQuestion_"^RecessStep|"_recessStep_"^RecessApp|"_recessApp_"^RecessAssess|"_recessAcess
	s ret=ret_"^RecessAssessDesc|"_recessAcessDesc_"^RecessReason|"_recessReason_"^RecessAssessDate|"_recessAcessDate_"^RecessLStatus|"_recessLStatus
	s ret=ret_"^RecessLStatusDesc|"_recessLStatusDesc_"^RecessLAuditor|"_recessLAuditor_"^RecessLAuditorName|"_recessLAuditorName_"^RecessLAuditeDate|"_recessLAuditeDate
	s ret=ret_"^RecessLReason|"_recessLReason_"^RecessHStatus|"_recessHStatus_"^RecessHStatusDesc|"_recessHStatusDesc_"^RecessHAuditor|"_recessHAuditor
	s ret=ret_"^RecessHAuditorName|"_recessHAuditorName_"^RecessHAuditeDate|"_recessHAuditeDate_"^RecessHReason|"_recessHReason_"^RecessStatus|"_recessStatus
	s ret=ret_"^RecessStatusDesc|"_recessStatusDesc_"^RecessCurStep|"_recessCurStep_"^RecessCurStepDesc|"_recessCurStepDesc_"^Creator|"_creator
	s ret=ret_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id_"^RecessParticipantInput|"_recessParticipantInput
	q ret
}

/// Description:获取公休会列表
/// Date:2020-07-09
/// Creator:wangpf
/// Table:DHCINM.HB.MgRecessRecord
/// Input: 级别^病区^开始日期^结束日期^状态
/// Output:公休会列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindRecessList","W^^^^",0,0)
Query FindRecessList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRecessListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s level=$p(parr,"^")
	s ward=$p(parr,"^",2)
	s stDate=$p(parr,"^",3)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",5)
	
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s id="" f  s id=$o(^DHCINM.HB.MgRecessRecordD(id),-1) q:id=""  d
	.s recGlo=^DHCINM.HB.MgRecessRecordD(id)
	.s recLevel=$lg(recGlo,2)
	.q:(level'="")&&(level'=recLevel)
	.s flag=0
	.s:isAll=1 flag=1
	.s recWard=$lg(recGlo,7)
	.s wardList=$lb(),index=1
	.s ptr=0 f  s stat=$listnext(recWard,ptr,item) q:(stat'=1)||((flag=1)&&(ward=""))  d
	..s wardId=$p(item,"「")
	..s $li(wardList,index)=wardId
	..s index=index+1
	..s:$d(tmpWard(wardId)) flag=1
	.s hoster=$lg(recGlo,9)
	.s recorder=$lg(recGlo,11)
	.s creator=$lg(recGlo,31)
	.s:hoster=userPerId flag=1
	.s:recorder=userPerId flag=1
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&($lf(wardList,ward)=0)
	.s recDate=$lg(recGlo,3)
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s recStatus=$lg(recGlo,29)
	.q:(status'="")&&(status'=recStatus)
	.s ret=..GetRecess(id)
	.d:ret'="" OutRecessList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRecessList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRecessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecessListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRecessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecessListExecute ]
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

/// Description: 审核公休会
/// Date: 2020-07-09
/// Creator: wangpf
/// Table: DHCINM.HB.MgRecessRecord
/// Input: 操作类型^状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).AuditRecess("",0)
ClassMethod AuditRecess(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s type=$p(parr,"^")
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s rw=$p(parr,"^",4)
	
	s obj=##class(DHCINM.HB.MgRecessRecord).%OpenId(rw)
	q:'$IsObject(obj)
	i (type="LY")||(type="LA") d
	.s obj.RecessLStatus=status
	.s obj.RecessLReason=reason
	.s obj.RecessLAuditor=nurseid
	.s obj.RecessLAuditeDate=+$h
	.i type="LY" s obj.RecessCurStep="LY"
	.e  s obj.RecessCurStep="A"
	e  i type="HA" d
	.s obj.RecessHStatus=status
	.s obj.RecessHReason=reason
	.s obj.RecessHAuditor=nurseid
	.s obj.RecessHAuditeDate=+$h
	.s obj.RecessCurStep="A"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 保存公休会落实评价
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgRecessRecord
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveRecessAssess("",0)
ClassMethod SaveRecessAssess(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	
	s obj=##class(DHCINM.HB.MgRecessRecord).%OpenId(rw)
	q:'$IsObject(obj)
	s obj.RecessAssess=status
	s obj.RecessAssessDate=+$h
	s obj.RecessReason=reason
	s obj.RecessStatus="A"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除公休会记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgRecessRecord
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteRecess(1)
ClassMethod DeleteRecess(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgRecessRecord).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存科务会记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocMeetingRec
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveLocMeeting("",0)
ClassMethod SaveLocMeeting(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s loc=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardLocD(loc)) 0
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s time=$p(parr,"^",3)
	s:time[":" time=$zth(time)
	s location=$p(parr,"^",4)
	s hoster=$p(parr,"^",5)
	q:(hoster="")||('$d(^CF.DHCINM.HR.PersonsD(hoster))) 0
	s participant=$p(parr,"^",6)
	s partiList=$lfs(participant,",")
	s recorder=$p(parr,"^",7)
	q:(recorder="")||('$d(^CF.DHCINM.HR.PersonsD(recorder))) 0
	s topic=$p(parr,"^",8)
	s status=$p(parr,"^",9)
	s rw=$p(parr,"^",10)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgLocMeetingRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgLocMeetingRec).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.MeetingLocSetObjectId(loc)
	s obj.MeetingDate=date
	s obj.MeetingTime=time
	s obj.MeetingLocation=location
	d obj.MeetingHosterSetObjectId(hoster)
	d obj.MeetingParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.MeetingParticipant.Insert(per)
	d obj.MeetingRecorderSetObjectId(recorder)
	s obj.MeetingTopic=topic
	s obj.MeetingStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 保存科务会记录内容
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocMeetingRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveLocMeetingCont("",1)
ClassMethod SaveLocMeetingCont(content As %String = "", id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgLocMeetingRec).%OpenId(id)
	q:'$IsObject(obj) 0
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.MeetingContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.MeetingContentExt.Write(content)
	}
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取科务会记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocMeetingRec
/// Input: id flag:是否返回计划总结内容
/// Output: 科务会记录
/// Other: w ##class(web.INMHBComm).GetLocMeeting(1)
ClassMethod GetLocMeeting(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.HB.MgLocMeetingRecD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s meetingGlo=^DHCINM.HB.MgLocMeetingRecD(id)
	
	s meetingLoc=$lg(meetingGlo,2)
	s meetingLocDesc=""
	i meetingLoc'="" d
	.s locGlo=$g(^CF.DHCINM.DB.MgWardLocD(meetingLoc))
	.s meetingLocDesc=$lg(locGlo,3)
	s meetingDate=$lg(meetingGlo,3)
	s:meetingDate'="" meetingDate=$zd(meetingDate,3)
	s meetingTime=$lg(meetingGlo,4)
	s:meetingTime'="" meetingTime=$zt(meetingTime)
	s meetingLocation=$lg(meetingGlo,5)
	s meetingHoster=$lg(meetingGlo,6)
	s meetingHosterName=""
	i meetingHoster'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(meetingHoster))
	.s meetingHosterName=$lg(perGlo,2)
	s meetingRecorder=$lg(meetingGlo,7)
	s meetingRecorderName=""
	i meetingRecorder'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(meetingRecorder))
	.s meetingRecorderName=$lg(perGlo,2)
	s meetingParti=$lg(meetingGlo,8)
	s meetingPartiId=$lts(meetingParti,",")
	s meetingPartiName=""
	s index=1,ptr=0 f  s stat=$listnext(meetingParti,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s meetingPartiName=perName
	.e  s meetingPartiName=meetingPartiName_","_perName
	.s index=index+1
	s meetingTopic=$lg(meetingGlo,9)
	s meetingContent=""
	;s:flag=1 meetingContent=$lg(meetingGlo,10)
	s meetingStatus=$lg(meetingGlo,11)
	s meetingStatusDesc=$case(meetingStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(meetingGlo,12)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(meetingGlo,13)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(meetingGlo,14)
	s:createTime'="" createTime=$zt(createTime,1)
	
	i flag=1{
		w "{""MeetingLoc"":"""_meetingLoc_""",""MeetingLocDesc"":"""_meetingLocDesc_""",""MeetingDate"":"""_meetingDate_""",""MeetingTime"":"""_meetingTime_""",""MeetingLocation"":"""_meetingLocation
		w """,""MeetingHoster"":"""_meetingHoster_""",""MeetingHosterName"":"""_meetingHosterName_""",""MeetingRecorder"":"""_meetingRecorder_""",""MeetingRecorderName"":"""_meetingRecorderName
		w """,""MeetingParticipant"":"""_meetingPartiId_""",""MeetingParticipantName"":"""_meetingPartiName_""",""MeetingTopic"":"""_meetingTopic_""",""MeetingContent"":"""
		s obj=##class(DHCINM.HB.MgLocMeetingRec).%OpenId(id)
		while ('obj.MeetingContentExt.AtEnd){
			w $tr(obj.MeetingContentExt.Read(),$c(10,13))
		}
		w """,""MeetingStatus"":"""_meetingStatus_""",""MeetingStatusDesc"":"""_meetingStatusDesc_""",""Creator"":"""_creator_""",""CreatorName"":"""_creatorName
		w """,""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime_""",""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="MeetingLoc|"_meetingLoc_"^MeetingLocDesc|"_meetingLocDesc_"^MeetingDate|"_meetingDate_"^MeetingTime|"_meetingTime_"^MeetingLocation|"_meetingLocation
		s ret=ret_"^MeetingHoster|"_meetingHoster_"^MeetingHosterName|"_meetingHosterName_"^MeetingRecorder|"_meetingRecorder_"^MeetingRecorderName|"_meetingRecorderName
		s ret=ret_"^MeetingParticipant|"_meetingPartiId_"^MeetingParticipantName|"_meetingPartiName_"^MeetingTopic|"_meetingTopic_"^MeetingContent|"_meetingContent
		s ret=ret_"^MeetingStatus|"_meetingStatus_"^MeetingStatusDesc|"_meetingStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate
		s ret=ret_"^CreateTime|"_createTime_"^rw|"_id
		q ret
	}
}

/// Description：获取科务会记录列表
/// Date:2020-07-10
/// Creator:wangpf
/// Table:DHCINM.HB.MgLocMeetingRec
/// Input: 开始日期^结束日期^状态 登录人Id 登录人角色
/// Output:科务会记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindLocMeetingList","^^",0,0)
Query FindLocMeetingList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocMeetingListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s loc=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",4)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	k tmpLoc
	i isAll'=1 d
	.s wardId="" f  s wardId=$o(tmpWard(wardId)) q:wardId=""  d
	..s locId="" f  s locId=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",wardId,locId)) q:locId=""  d
	...s tmpLoc(locId)=locId
	
	s meetDate="" f  s meetDate=$o(^DHCINM.HB.MgLocMeetingRecI("ToolIndex",meetDate),-1) q:meetDate=""  d
	.q:((stDate'="")&&(meetDate<stDate))||((endDate'="")&&(meetDate>endDate))
	.s meetLoc="" f  s meetLoc=$o(^DHCINM.HB.MgLocMeetingRecI("ToolIndex",meetDate,meetLoc)) q:meetLoc=""  d
	..q:((loc'="")&&(loc'=meetLoc))||((isAll'=1)&&('$d(tmpLoc(meetLoc))))
	..s meetStatus="" f  s meetStatus=$o(^DHCINM.HB.MgLocMeetingRecI("ToolIndex",meetDate,meetLoc,meetStatus)) q:meetStatus=""  d
	...q:(status'="")&&(status'=$tr(meetStatus," ",""))
	...s id="" f  s id=$o(^DHCINM.HB.MgLocMeetingRecI("ToolIndex",meetDate,meetLoc,meetStatus,id),-1) q:id=""  d
	....q:'$d(^DHCINM.HB.MgLocMeetingRecD(id))
	....s ret=..GetLocMeeting(id)
	....d:ret'="" OutMeetingList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMeetingList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocMeetingListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocMeetingListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocMeetingListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocMeetingListExecute ]
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

/// Description: 提交科务会记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocMeetingRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SubmitLocMeeting("",1)
ClassMethod SubmitLocMeeting(content As %String = "", id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgLocMeetingRec).%OpenId(id)
	q:'$IsObject(obj) 0
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.MeetingContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.MeetingContentExt.Write(content)
	}
	s obj.MeetingStatus="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除科务会记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocMeetingRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteLocMeeting(1)
ClassMethod DeleteLocMeeting(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgLocMeetingRec).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存护士长会议记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgHeadMeetingRec
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveHeadMeeting("",0)
ClassMethod SaveHeadMeeting(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s level=$p(parr,"^")
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s time=$p(parr,"^",3)
	s:time[":" time=$zth(time)
	s location=$p(parr,"^",4)
	s hoster=$p(parr,"^",5)
	q:(hoster="")||('$d(^CF.DHCINM.HR.PersonsD(hoster))) 0
	s participant=$p(parr,"^",6)
	s partiList=$lfs(participant,",")
	s recorder=$p(parr,"^",7)
	q:(recorder="")||('$d(^CF.DHCINM.HR.PersonsD(recorder))) 0
	s topic=$p(parr,"^",8)
	s status=$p(parr,"^",9)
	s rw=$p(parr,"^",10)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgHeadMeetingRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgHeadMeetingRec).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.MeetingLevel=level
	s obj.MeetingDate=date
	s obj.MeetingTime=time
	s obj.MeetingLocation=location
	d obj.MeetingHosterSetObjectId(hoster)
	d obj.MeetingParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.MeetingParticipant.Insert(per)
	d obj.MeetingRecorderSetObjectId(recorder)
	s obj.MeetingTopic=topic
	s obj.MeetingStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 保存护士长会议记录内容
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgHeadMeetingRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveHeadMeetingCont("",1)
ClassMethod SaveHeadMeetingCont(content As %String = "", id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgHeadMeetingRec).%OpenId(id)
	q:'$IsObject(obj) 0
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.MeetingContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.MeetingContentExt.Write(content)
	}
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取护士长会议记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgHeadMeetingRec
/// Input: id flag:是否返回计划总结内容
/// Output: 护士长会议记录
/// Other: w ##class(web.INMHBComm).GetHeadMeeting(1)
ClassMethod GetHeadMeeting(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.HB.MgHeadMeetingRecD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s meetingGlo=^DHCINM.HB.MgHeadMeetingRecD(id)
	
	s meetingLevel=$lg(meetingGlo,2)
	s meetingLevelDesc=$case(meetingLevel,"W":"病区","L":"科室","H":"护理部",:"")
	s meetingDate=$lg(meetingGlo,3)
	s:meetingDate'="" meetingDate=$zd(meetingDate,3)
	s meetingTime=$lg(meetingGlo,4)
	s:meetingTime'="" meetingTime=$zt(meetingTime)
	s meetingLocation=$lg(meetingGlo,5)
	
	s meetingHoster=$lg(meetingGlo,6)
	s meetingHosterName=""
	i meetingHoster'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(meetingHoster))
	.s meetingHosterName=$lg(perGlo,2)
	s meetingRecorder=$lg(meetingGlo,7)
	s meetingRecorderName=""
	i meetingRecorder'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(meetingRecorder))
	.s meetingRecorderName=$lg(perGlo,2)
	s meetingParti=$lg(meetingGlo,8)
	s meetingPartiId=$lts(meetingParti,",")
	s meetingPartiName=""
	s index=1,ptr=0 f  s stat=$listnext(meetingParti,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s meetingPartiName=perName
	.e  s meetingPartiName=meetingPartiName_","_perName
	.s index=index+1
	s meetingTopic=$lg(meetingGlo,9)
	s meetingContent=""
	;s:flag=1 meetingContent=$lg(meetingGlo,10)
	s meetingStatus=$lg(meetingGlo,11)
	s meetingStatusDesc=$case(meetingStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(meetingGlo,12)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(meetingGlo,13)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(meetingGlo,14)
	s:createTime'="" createTime=$zt(createTime,1)
	
	i flag=1{
		w "{""MeetingLevel"":"""_meetingLevel_""",""MeetingLevelDesc"":"""_meetingLevelDesc_""",""MeetingDate"":"""_meetingDate_""",""MeetingTime"":"""_meetingTime
		w """,""MeetingLocation"":"""_meetingLocation_""",""MeetingHoster"":"""_meetingHoster_""",""MeetingHosterName"":"""_meetingHosterName_""",""MeetingRecorder"":"""_meetingRecorder
		w """,""MeetingRecorderName"":"""_meetingRecorderName_""",""MeetingParticipant"":"""_meetingPartiId_""",""MeetingParticipantName"":"""_meetingPartiName_""",""MeetingTopic"":"""_meetingTopic
		w """,""MeetingContent"":"""
		s obj=##class(DHCINM.HB.MgHeadMeetingRec).%OpenId(id)
		while ('obj.MeetingContentExt.AtEnd){
			w $zcvt($tr(obj.MeetingContentExt.Read(),$c(10,13)),"O","JS")
		}
		w """,""MeetingStatus"":"""_meetingStatus_""",""MeetingStatusDesc"":"""_meetingStatusDesc_""",""Creator"":"""_creator_""",""CreatorName"":"""_creatorName
		w """,""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime_""",""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="MeetingLevel|"_meetingLevel_"^MeetingLevelDesc|"_meetingLevelDesc_"^MeetingDate|"_meetingDate_"^MeetingTime|"_meetingTime_"^MeetingLocation|"_meetingLocation
		s ret=ret_"^MeetingHoster|"_meetingHoster_"^MeetingHosterName|"_meetingHosterName_"^MeetingRecorder|"_meetingRecorder_"^MeetingRecorderName|"_meetingRecorderName
		s ret=ret_"^MeetingParticipant|"_meetingPartiId_"^MeetingParticipantName|"_meetingPartiName_"^MeetingTopic|"_meetingTopic_"^MeetingContent|"_meetingContent
		s ret=ret_"^MeetingStatus|"_meetingStatus_"^MeetingStatusDesc|"_meetingStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"
		s ret=ret_createDate_"^CreateTime|"_createTime_"^rw|"_id
		q ret
	}
}

/// Description：获取护士长会议记录列表
/// Date:2020-07-10
/// Creator:wangpf
/// Table:DHCINM.HB.MgHeadMeetingRec
/// Input: 级别^开始日期^结束日期^状态 登录人Id 登录人角色
/// Output:护士长会议记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindHeadMeetingList","^^^",0,0)
Query FindHeadMeetingList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindHeadMeetingListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s level=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",4)
	
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	
	s meetDate="" f  s meetDate=$o(^DHCINM.HB.MgHeadMeetingRecI("DateStatus",meetDate),-1) q:meetDate=""  d
	.q:((stDate'="")&&(meetDate<stDate))||((endDate'="")&&(meetDate>endDate))
	.s meetStatus="" f  s meetStatus=$o(^DHCINM.HB.MgHeadMeetingRecI("DateStatus",meetDate,meetStatus),-1) q:meetStatus=""  d
	..q:(status'="")&&(status'=$tr(meetStatus," ",""))
	..s id="" f  s id=$o(^DHCINM.HB.MgHeadMeetingRecI("DateStatus",meetDate,meetStatus,id),-1) q:id=""  d
	...q:'$d(^DHCINM.HB.MgHeadMeetingRecD(id))
	...s meetingGlo=^DHCINM.HB.MgHeadMeetingRecD(id)
	...s meetingLevel=$lg(meetingGlo,2)
	...q:(level'="")&&(level'=meetingLevel)
	...s flag=0
	...s meetingParti=$lg(meetingGlo,8)
	...s ptr=0 f  s stat=$listnext(meetingParti,ptr,per) q:(stat'=1)||(flag=1)  d
	....s:per=userPerId flag=1
	...s hoster=$lg(meetingGlo,6)
	...s recorder=$lg(meetingGlo,7)
	...s creator=$lg(meetingGlo,12)
	...s:hoster=userPerId flag=1
	...s:recorder=userPerId flag=1
	...s:creator=nurseid flag=1
	...q:flag'=1
	...s ret=..GetHeadMeeting(id)
	...d:ret'="" OutMeetingList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMeetingList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHeadMeetingListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHeadMeetingListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHeadMeetingListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHeadMeetingListExecute ]
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

/// Description: 提交护士长会议记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgHeadMeetingRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SubmitHeadMeeting("",1)
ClassMethod SubmitHeadMeeting(content As %String = "", id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgHeadMeetingRec).%OpenId(id)
	q:'$IsObject(obj) 0
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.MeetingContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.MeetingContentExt.Write(content)
	}
	s obj.MeetingStatus="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除护士长会议记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgHeadMeetingRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteHeadMeeting(1)
ClassMethod DeleteHeadMeeting(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgHeadMeetingRec).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存医患座谈会记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatMeetingRec
/// Input: parr 登录人Id
/// Output: 0：失败 其他：成功
/// Other: w ##class(web.INMHBComm).SavePatMeetingRec("",0)
ClassMethod SavePatMeetingRec(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s level=$p(parr,"^")
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s time=$p(parr,"^",3)
	s:time[":" time=$zth(time)
	s location=$p(parr,"^",4)
	s department=$p(parr,"^",5)
	s ward=$p(parr,"^",6)
	s wardList=$lfs(ward,",")
	s participant=$p(parr,"^",7)
	s partiList=$lfs(participant,",")
	s hoster=$p(parr,"^",8)
	q:(hoster="")||('$d(^CF.DHCINM.HR.PersonsD(hoster))) 0
	s hosterPost=$p(parr,"^",9)
	s parId=$p(hosterPost,"||")
	s subId=$p(hosterPost,"||",2)
	q:(hosterPost'="")&&('$d(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId))) 0
	s recorder=$p(parr,"^",10)
	q:(recorder="")||('$d(^CF.DHCINM.HR.PersonsD(recorder))) 0
	s topic=$p(parr,"^",11)
	s content=$p(parr,"^",12)
	s question=$p(parr,"^",13)
	s step=$p(parr,"^",14)
	s app=$p(parr,"^",15)
	s status=$p(parr,"^",16)
	s rw=$p(parr,"^",17)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgPatMeetingRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgPatMeetingRec).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.MeetingLevel=level
	s obj.MeetingDate=date
	s obj.MeetingTime=time
	s obj.MeetingLocation=location
	s obj.MeetingDepartment=department
	d obj.MeetingWard.Clear()
	s ptr=0 f  s stat=$listnext(wardList,ptr,item) q:stat'=1  d
	.s wardId=$p(item,"「")
	.s wardNumber=$p(item,"「",2)
	.q:'$d(^CF.DHCINM.DB.MgWardD(wardId))
	.d obj.MeetingWard.Insert(item)
	d obj.MeetingParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.MeetingParticipant.Insert(per)
	d obj.MeetingHosterSetObjectId(hoster)
	d obj.MeetingHosterPostSetObjectId(hosterPost)
	d obj.MeetingRecorderSetObjectId(recorder)
	s obj.MeetingTopic=topic
	s obj.MeetingContent=content
	s obj.MeetingQuestion=question
	s obj.MeetingStep=step
	s obj.MeetingApp=app
	i status="YY" d
	.s obj.MeetingStatus="Y"
	.s obj.MeetingCurStep="NY"
	e  i status="Y" d
	.s obj.MeetingStatus="Y"
	.s obj.MeetingCurStep="A"
	e  s obj.MeetingStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 获取医患座谈会记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatMeetingRec
/// Input: id 是否返回内容
/// Output: 医患座谈会记录
/// Other: w ##class(web.INMHBComm).GetPatMeetingRec(1)
ClassMethod GetPatMeetingRec(id As %String = "", flag As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgPatMeetingRecD(id))) ""
	
	s meetingGlo=^DHCINM.HB.MgPatMeetingRecD(id)
	s meetingLevel=$lg(meetingGlo,2)
	s meetingLevelDesc=$case(meetingLevel,"W":"病区","L":"科室","H":"护理部",:"")
	s meetingDate=$lg(meetingGlo,3)
	s:meetingDate'="" meetingDate=$zd(meetingDate,3)
	s meetingTime=$lg(meetingGlo,4)
	s:meetingTime'="" meetingTime=$zt(meetingTime)
	s meetingLocation=$lg(meetingGlo,5)
	s meetingDepart=$lg(meetingGlo,6)
	s meetingWard=$lg(meetingGlo,7)
	s meetingWardNum=0
	s ptr=0 f  s status=$listnext(meetingWard,ptr,item) q:status'=1  d
	.s wardId=$p(item,"「")
	.s wardNumber=$p(item,"「",2)
	.s meetingWardNum=meetingWardNum+$fn(wardNumber,"",0)
	s meetingWard=$lts(meetingWard,",")
	s meetingParti=$lg(meetingGlo,8)
	s meetingPartiId=$lts(meetingParti,",")
	s meetingPartiName=""
	s index=1,ptr=0 f  s stat=$listnext(meetingParti,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s meetingPartiName=perName
	.e  s meetingPartiName=meetingPartiName_","_perName
	.s index=index+1
	s meetingHoster=$lg(meetingGlo,9)
	s meetingHosterName=""
	i meetingHoster'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(meetingHoster))
	.s meetingHosterName=$lg(perGlo,2)
	s meetingPost=$lg(meetingGlo,10)
	s meetingPost=$tr(meetingPost,"|","_")
	s meetingPostDesc=""
	i meetingPost'="" d
	.s parId=$p(meetingPost,"__")
	.s subId=$p(meetingPost,"__",2)
	.q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId))
	.s postGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s meetingPostDesc=$lg(postGlo,3)
	s meetingRecorder=$lg(meetingGlo,11)
	s meetingRecorderName=""
	i meetingRecorder'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(meetingRecorder))
	.s meetingRecorderName=$lg(perGlo,2)
	s meetingTopic=$lg(meetingGlo,12)
	s meetingContent=""
	s:flag=1 meetingContent=$lg(meetingGlo,13)
	s meetingQuestion=""
	s:flag=1 meetingQuestion=$lg(meetingGlo,15)
	s meetingStep=""
	s:flag=1 meetingStep=$lg(meetingGlo,16)
	s meetingApp=""
	s:flag=1 meetingApp=$lg(meetingGlo,17)
	s meetingAcess=$lg(meetingGlo,18)
	s meetingAcessDesc=$case(meetingAcess,"N":"未落实","P":"部分落实","Y":"落实",:"")
	s meetingReason=""
	s:flag=1 meetingReason=$lg(meetingGlo,19)
	s meetingAcessDate=$lg(meetingGlo,20)
	s:meetingAcessDate'="" meetingAcessDate=$zd(meetingAcessDate,3)
	s meetingLStatus=$lg(meetingGlo,21)
	s meetingLStatusDesc=$case(meetingLStatus,"N":"未通过","P":"部分通过","Y":"通过",:"")
	s meetingLAuditor=$lg(meetingGlo,22)
	s meetingLAuditorName=""
	i meetingLAuditor=0 s meetingLAuditorName="管理员"
	e  i meetingLAuditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(meetingLAuditor))
	.s meetingLAuditorName=$lg(perGlo,2)
	s meetingLAuditeDate=$lg(meetingGlo,23)
	s:meetingLAuditeDate'="" meetingLAuditeDate=$zd(meetingLAuditeDate,3)
	s meetingLReason=""
	s:flag=1 meetingLReason=$lg(meetingGlo,24)
	s meetingHStatus=$lg(meetingGlo,25)
	s meetingHStatusDesc=$case(meetingHStatus,"N":"未通过","P":"部分通过","Y":"通过",:"")
	s meetingHAuditor=$lg(meetingGlo,26)
	s meetingHAuditorName=""
	i meetingHAuditor=0 s meetingHAuditorName="管理员"
	e  i meetingHAuditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(meetingHAuditor))
	.s meetingHAuditorName=$lg(perGlo,2)
	s meetingHAuditeDate=$lg(meetingGlo,27)
	s:meetingHAuditeDate'="" meetingHAuditeDate=$zd(meetingHAuditeDate,3)
	s meetingHReason=""
	s:flag=1 meetingHReason=$lg(meetingGlo,28)
	s meetingStatus=$lg(meetingGlo,29)
	s meetingStatusDesc=$case(meetingStatus,"N":"保存","Y":"提交","A":"完成",:"")
	s meetingCurStep=$lg(meetingGlo,30)
	;s meetingCurStepDesc=$case(meetingCurStep,"NY":"提请科护士长审核","LY":"提请护理部审核","A":"完成",:"")
	s meetingCurStepDesc=""
	i meetingCurStep="NY" s meetingCurStepDesc="提请科护士长审核"
	e  i meetingCurStep="LY" s meetingCurStepDesc="提请护理部审核"
	e  i meetingCurStep="A" d
	.i meetingHStatus'="" s meetingCurStepDesc=meetingHStatusDesc
	.e  s meetingCurStepDesc=meetingLStatusDesc
	s creator=$lg(meetingGlo,31)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(meetingGlo,32)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(meetingGlo,33)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="MeetingLevel|"_meetingLevel_"^MeetingLevelDesc|"_meetingLevelDesc_"^MeetingDate|"_meetingDate_"^MeetingTime|"_meetingTime_"^MeetingLocation|"_meetingLocation
	s ret=ret_"^MeetingDepartment|"_meetingDepart_"^MeetingWard|"_meetingWard_"^MeetingWardNum|"_meetingWardNum_"^MeetingParticipant|"_meetingPartiId
	s ret=ret_"^MeetingParticipantName|"_meetingPartiName_"^MeetingHoster|"_meetingHoster_"^MeetingHosterName|"_meetingHosterName_"^MeetingHosterPost|"_meetingPost
	s ret=ret_"^MeetingHosterPostDesc|"_meetingPostDesc_"^MeetingRecorder|"_meetingRecorder_"^MeetingRecorderName|"_meetingRecorderName_"^MeetingTopic|"_meetingTopic
	s ret=ret_"^MeetingContent|"_meetingContent_"^MeetingQuestion|"_meetingQuestion_"^MeetingStep|"_meetingStep_"^MeetingApp|"_meetingApp_"^MeetingAssess|"_meetingAcess
	s ret=ret_"^MeetingAssessDesc|"_meetingAcessDesc_"^MeetingReason|"_meetingReason_"^MeetingAssessDate|"_meetingAcessDate_"^MeetingLStatus|"_meetingLStatus
	s ret=ret_"^MeetingLStatusDesc|"_meetingLStatusDesc_"^MeetingLAuditor|"_meetingLAuditor_"^MeetingLAuditorName|"_meetingLAuditorName_"^MeetingLAuditeDate|"_meetingLAuditeDate
	s ret=ret_"^MeetingLReason|"_meetingLReason_"^MeetingHStatus|"_meetingHStatus_"^MeetingHStatusDesc|"_meetingHStatusDesc_"^MeetingHAuditor|"_meetingHAuditor
	s ret=ret_"^MeetingHAuditorName|"_meetingHAuditorName_"^MeetingHAuditeDate|"_meetingHAuditeDate_"^MeetingHReason|"_meetingHReason_"^MeetingStatus|"_meetingStatus
	s ret=ret_"^MeetingStatusDesc|"_meetingStatusDesc_"^MeetingCurStep|"_meetingCurStep_"^MeetingCurStepDesc|"_meetingCurStepDesc_"^Creator|"_creator
	s ret=ret_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description:获取医患座谈会记录列表
/// Date:2020-07-10
/// Creator:wangpf
/// Table:DHCINM.HB.MgPatMeetingRec
/// Input: 级别^病区^开始日期^结束日期^状态
/// Output:医患座谈会记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindPatMeetingList","W^^^^",0,0)
Query FindPatMeetingList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPatMeetingListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s level=$p(parr,"^")
	s ward=$p(parr,"^",2)
	s stDate=$p(parr,"^",3)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",5)
	
	s userPerId=""
	i nurseid'="" d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s id="" f  s id=$o(^DHCINM.HB.MgPatMeetingRecD(id),-1) q:id=""  d
	.s patGlo=^DHCINM.HB.MgPatMeetingRecD(id)
	.s patLevel=$lg(patGlo,2)
	.q:(level'="")&&(level'=patLevel)
	.s flag=0
	.s:isAll=1 flag=1
	.s patWard=$lg(patGlo,7)
	.s wardList=$lb(),index=1
	.s ptr=0 f  s stat=$listnext(patWard,ptr,item) q:(stat'=1)||((flag=1)&&(ward=""))  d
	..s wardId=$p(item,"「")
	..s $li(wardList,index)=wardId
	..s index=index+1
	..s:$d(tmpWard(wardId)) flag=1
	.s hoster=$lg(patGlo,9)
	.s recorder=$lg(patGlo,11)
	.s creator=$lg(patGlo,31)
	.s:hoster=userPerId flag=1
	.s:recorder=userPerId flag=1
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&($lf(wardList,ward)=0)
	.s patDate=$lg(patGlo,3)
	.q:((stDate'="")&&(patDate<stDate))||((endDate'="")&&(patDate>endDate))
	.s patStatus=$lg(patGlo,29)
	.q:(status'="")&&(status'=patStatus)
	.s ret=..GetPatMeetingRec(id)
	.d:ret'="" OutMeetingList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMeetingList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPatMeetingListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatMeetingListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPatMeetingListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatMeetingListExecute ]
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

/// Description: 审核医患座谈会记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatMeetingRec
/// Input: 操作类型^状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).AuditRecess("",0)
ClassMethod AuditPatMeetingRec(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s type=$p(parr,"^")
	s status=$p(parr,"^",2)
	s reason=$p(parr,"^",3)
	s rw=$p(parr,"^",4)
	
	s obj=##class(DHCINM.HB.MgPatMeetingRec).%OpenId(rw)
	q:'$IsObject(obj)
	i (type="LY")||(type="LA") d
	.s obj.MeetingLStatus=status
	.s obj.MeetingLReason=reason
	.s obj.MeetingLAuditor=nurseid
	.s obj.MeetingLAuditeDate=+$h
	.i type="LY" s obj.MeetingCurStep="LY"
	.e  s obj.MeetingCurStep="A"
	e  i type="HA" d
	.s obj.MeetingHStatus=status
	.s obj.MeetingHReason=reason
	.s obj.MeetingHAuditor=nurseid
	.s obj.MeetingHAuditeDate=+$h
	.s obj.MeetingCurStep="A"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 保存医患座谈会记录落实评价
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatMeetingRec
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SavePatAssess("",0)
ClassMethod SavePatAssess(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	
	s obj=##class(DHCINM.HB.MgPatMeetingRec).%OpenId(rw)
	q:'$IsObject(obj)
	s obj.MeetingAssess=status
	s obj.MeetingAssessDate=+$h
	s obj.MeetingReason=reason
	s obj.MeetingStatus="A"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除医患座谈会记录
/// Date: 2020-07-10
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatMeetingRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeletePatMeetingRec(1)
ClassMethod DeletePatMeetingRec(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgPatMeetingRec).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存病区常规会议记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgWardMeetingRec
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveWardMeeting("",0)
ClassMethod SaveWardMeeting(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s type=$p(parr,"^",2)
	s date=$p(parr,"^",3)
	s:date["-" date=$zdh(date,3)
	s time=$p(parr,"^",4)
	s:time[":" time=$zth(time)
	s location=$p(parr,"^",5)
	s hoster=$p(parr,"^",6)
	q:(hoster="")||('$d(^CF.DHCINM.HR.PersonsD(hoster))) 0
	s participant=$p(parr,"^",7)
	s partiList=$lfs(participant,",")
	s content=$p(parr,"^",8)
	s status=$p(parr,"^",9)
	s rw=$p(parr,"^",10)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgWardMeetingRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgWardMeetingRec).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.MeetingWardSetObjectId(ward)
	s obj.MeetingType=type
	s obj.MeetingDate=date
	s obj.MeetingTime=time
	s obj.MeetingLocation=location
	d obj.MeetingHosterSetObjectId(hoster)
	d obj.MeetingParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.MeetingParticipant.Insert(per)
	s obj.MeetingContent=content
	s obj.MeetingStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 病区常规会议护士签到
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgWardMeetingRec
/// Input: id 登录人Id
/// Output: -2：重复签到 -1：不在参会人员中 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SignWardMeeting("",0)
ClassMethod SignWardMeeting(id As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.HR.PersonsD(nurseid))) 0
	
	s obj=##class(DHCINM.HB.MgWardMeetingRec).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=obj.MeetingHoster.%Id())&&(obj.MeetingParticipant.Find(nurseid)="") -1
	q:obj.MeetingSign.Find(nurseid)'="" -2
	d obj.MeetingSign.Insert(nurseid)
	s:obj.MeetingSign.Count()=(obj.MeetingParticipant.Count()+1) obj.MeetingStatus="A"
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 获取病区常规会议记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgWardMeetingRec
/// Input: id flag:是否返回会议内容
/// Output: 病区常规会议记录
/// Other: w ##class(web.INMHBComm).GetWardMeeting(1)
ClassMethod GetWardMeeting(id As %String = "", flag As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgWardMeetingRecD(id))) ""
	
	s meetingGlo=^DHCINM.HB.MgWardMeetingRecD(id)
	s meetingWard=$lg(meetingGlo,2)
	s meetingWardDesc=""
	i meetingWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(meetingWard))
	.s meetingWardDesc=$lg(wardGlo,4)
	s meetingType=$lg(meetingGlo,3)
	s meetingTypeDesc=$case(meetingType,"M":"月例会","W":"周例会","D":"晨例会",:"")
	s meetingDate=$lg(meetingGlo,4)
	s:meetingDate'="" meetingDate=$zd(meetingDate,3)
	s meetingTime=$lg(meetingGlo,5)
	s:meetingTime'="" meetingTime=$zt(meetingTime)
	s meetingLocation=$lg(meetingGlo,6)
	s meetingHoster=$lg(meetingGlo,7)
	s meetingHosterName=""
	i meetingHoster'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(meetingHoster))
	.s meetingHosterName=$lg(perGlo,2)
	s meetingParti=$lg(meetingGlo,8)
	s meetingPartiId=$lts(meetingParti,",")
	s meetingPartiName=""
	s index=1,ptr=0 f  s stat=$listnext(meetingParti,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s meetingPartiName=perName
	.e  s meetingPartiName=meetingPartiName_","_perName
	.s index=index+1
	s meetingSign=$lg(meetingGlo,9)
	s meetingSignId=$lts(meetingSign,",")
	s meetingSignName=""
	s index=1,ptr=0 f  s stat=$listnext(meetingSign,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s meetingSignName=perName
	.e  s meetingSignName=meetingSignName_","_perName
	.s index=index+1
	s meetingNumber=$ll(meetingParti)
	s:((meetingHoster'="")&&($LF(meetingParti,meetingHoster)=0)) meetingNumber=meetingNumber+1
	s meetingSignNumber=$ll(meetingSign)
	s meetingContent=""
	s:flag=1 meetingContent=$lg(meetingGlo,10)
	s meetingStatus=$lg(meetingGlo,11)
	s meetingStatusDesc=$case(meetingStatus,"N":"保存","Y":"发布","A":"完成",:"")
	s creator=$lg(meetingGlo,12)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(meetingGlo,13)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(meetingGlo,14)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="MeetingWard|"_meetingWard_"^MeetingWardDesc|"_meetingWardDesc_"^MeetingType|"_meetingType_"^MeetingTypeDesc|"_meetingTypeDesc_"^MeetingDate|"_meetingDate
	s ret=ret_"^MeetingTime|"_meetingTime_"^MeetingLocation|"_meetingLocation_"^MeetingHoster|"_meetingHoster_"^MeetingHosterName|"_meetingHosterName
	s ret=ret_"^MeetingParticipant|"_meetingPartiId_"^MeetingParticipantName|"_meetingPartiName_"^MeetingSign|"_meetingSignId_"^MeetingSignName|"_meetingSignName
	s ret=ret_"^MeetingContent|"_meetingContent_"^MeetingStatus|"_meetingStatus_"^MeetingStatusDesc|"_meetingStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName
	s ret=ret_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^MeetingNumber|"_meetingNumber_"^MeetingSignNumber|"_meetingSignNumber_"^rw|"_id
	q ret
}

/// Description：获取病区常规会议记录列表
/// Date:2020-07-11
/// Creator:wangpf
/// Table:DHCINM.HB.MgWardMeetingRec
/// Input: 开始日期^结束日期^状态 登录人Id 登录人角色
/// Output:科务会记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindWardMeetingList","^^",0,0)
Query FindWardMeetingList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardMeetingListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s type=$p(parr,"^",2)
	s stDate=$p(parr,"^",3)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",5)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s meetDate="" f  s meetDate=$o(^DHCINM.HB.MgWardMeetingRecI("ToolIndex",meetDate),-1) q:meetDate=""  d
	.q:((stDate'="")&&(meetDate<stDate))||((endDate'="")&&(meetDate>endDate))
	.s meetingWard="" f  s meetingWard=$o(^DHCINM.HB.MgWardMeetingRecI("ToolIndex",meetDate,meetingWard)) q:meetingWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(meetingWard))))||((ward'="")&&(ward'=meetingWard))
	..s meetingType="" f  s meetingType=$o(^DHCINM.HB.MgWardMeetingRecI("ToolIndex",meetDate,meetingWard,meetingType)) q:meetingType=""  d
	...q:(type'="")&&(type'=$tr(meetingType," ",""))
	...s meetingStatus="" f  s meetingStatus=$o(^DHCINM.HB.MgWardMeetingRecI("ToolIndex",meetDate,meetingWard,meetingType,meetingStatus)) q:meetingStatus=""  d
	....q:(status'="")&&(status'=$tr(meetingStatus," ",""))
	....s id="" f  s id=$o(^DHCINM.HB.MgWardMeetingRecI("ToolIndex",meetDate,meetingWard,meetingType,meetingStatus,id)) q:id=""  d
	.....q:'$d(^DHCINM.HB.MgWardMeetingRecD(id))
	.....s ret=..GetWardMeeting(id)
	.....d:ret'="" OutMeetingList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMeetingList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardMeetingListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardMeetingListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardMeetingListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardMeetingListExecute ]
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

/// Description: 发布病区常规会议记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgWardMeetingRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SubmitWardMeeting("",1)
ClassMethod SubmitWardMeeting(id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgWardMeetingRec).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.MeetingStatus="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除病区常规会议记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgWardMeetingRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteWardMeeting(1)
ClassMethod DeleteWardMeeting(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgWardMeetingRec).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存科室大记事记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocEventRec
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveLocEvent("",0)
ClassMethod SaveLocEvent(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s topic=$p(parr,"^",3)
	s status=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgLocEventRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgLocEventRec).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.EventWardSetObjectId(ward)
	s obj.EventDate=date
	s obj.EventTopic=topic
	s obj.EventStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 保存科室大记事记录内容
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocEventRec
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveLocEventContent("",0)
ClassMethod SaveLocEventContent(content As %String = "", id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgLocEventRec).%OpenId(id)
	q:'$IsObject(obj) 0
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.EventContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.EventContentExt.Write(content)
	}
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取科室大记事记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocEventRec
/// Input: id flag:是否返回记录内容
/// Output: 科室大记事记录
/// Other: w ##class(web.INMHBComm).GetLocEvent(1)
ClassMethod GetLocEvent(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.HB.MgLocEventRecD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s eventGlo=^DHCINM.HB.MgLocEventRecD(id)
	s eventWard=$lg(eventGlo,2)
	s eventWardDesc=""
	i eventWard'="" d
	.s locGlo=$g(^CF.DHCINM.DB.MgWardD(eventWard))
	.s eventWardDesc=$lg(locGlo,4)
	s eventDate=$lg(eventGlo,3)
	s:eventDate'="" eventDate=$zd(eventDate,3)
	s eventTopic=$lg(eventGlo,4)
	s eventContent=""
	;s:flag=1 eventContent=$lg(eventGlo,5)
	s eventStatus=$lg(eventGlo,6)
	s eventStatusDesc=$case(eventStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(eventGlo,7)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(eventGlo,8)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(eventGlo,9)
	s:createTime'="" createTime=$zt(createTime,1)
	
	i flag=1{
		w "{""EventWard"":"""_eventWard_""",""EventWardDesc"":"""_eventWardDesc_""",""EventDate"":"""_eventDate_""",""EventTopic"":"""_eventTopic_""",""EventContent"":"""
		s obj=##class(DHCINM.HB.MgLocEventRec).%OpenId(id)
		while ('obj.EventContentExt.AtEnd){
			w $zcvt($tr(obj.EventContentExt.Read(),$c(10,13)),"O","JS")
		}
		w """,""EventStatus"":"""_eventStatus_""",""EventStatusDesc"":"""_eventStatusDesc_""",""Creator"":"""_creator_""",""CreatorName"":"""_creatorName
		w """,""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime_""",""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="EventWard|"_eventWard_"^EventWardDesc|"_eventWardDesc_"^EventDate|"_eventDate_"^EventTopic|"_eventTopic_"^EventContent|"_eventContent
		s ret=ret_"^EventStatus|"_eventStatus_"^EventStatusDesc|"_eventStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName
		s ret=ret_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
		q ret
	}
}

/// Description：获取科室大记事记录列表
/// Date:2020-07-11
/// Creator:wangpf
/// Table:DHCINM.HB.MgLocEventRec
/// Input: 病区^开始日期^结束日期^状态 登录人Id 登录人角色
/// Output:科室大记事记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindLocEventList","^^",0,0)
Query FindLocEventList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocEventListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",4)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s eventDate="" f  s eventDate=$o(^DHCINM.HB.MgLocEventRecI("ToolIndex",eventDate),-1) q:eventDate=""  d
	.q:((stDate'="")&&(eventDate<stDate))||((endDate'="")&&(eventDate>endDate))
	.s eventWard="" f  s eventWard=$o(^DHCINM.HB.MgLocEventRecI("ToolIndex",eventDate,eventWard)) q:eventWard=""  d
	..q:((ward'="")&&(ward'=eventWard))||((isAll'=1)&&('$d(tmpWard(eventWard))))
	..s eventStatus="" f  s eventStatus=$o(^DHCINM.HB.MgLocEventRecI("ToolIndex",eventDate,eventWard,eventStatus)) q:eventStatus=""  d
	...q:(status'="")&&(status'=$tr(eventStatus," ",""))
	...s id="" f  s id=$o(^DHCINM.HB.MgLocEventRecI("ToolIndex",eventDate,eventWard,eventStatus,id)) q:id=""  d
	....q:'$d(^DHCINM.HB.MgLocEventRecD(id))
	....s ret=..GetLocEvent(id)
	....d:ret'="" OutEventList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutEventList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocEventListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocEventListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocEventListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocEventListExecute ]
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

/// Description: 提交科室大记事记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocEventRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SubmitLocEvent("",1)
ClassMethod SubmitLocEvent(content As %String = "", id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgLocEventRec).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.EventContent=content
	s obj.EventStatus="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除科室大记事记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocEventRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteLocEvent(1)
ClassMethod DeleteLocEvent(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgLocEventRec).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存科室好人好事记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocGoodRec
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveLocGoodRec("",0)
ClassMethod SaveLocGoodRec(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s time=$p(parr,"^",3)
	s:time[":" time=$zth(time)
	s location=$p(parr,"^",4)
	s participant=$p(parr,"^",5)
	s partiList=$lfs(participant,",")
	s content=$p(parr,"^",6)
	s status=$p(parr,"^",7)
	s rw=$p(parr,"^",8)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgLocGoodRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgLocGoodRec).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.GoodWardSetObjectId(ward)
	s obj.GoodDate=date
	s obj.GoodTime=time
	s obj.GoodLocation=location
	d obj.GoodParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.GoodParticipant.Insert(per)
	s obj.GoodContent=content
	s obj.GoodStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 获取科室好人好事记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocGoodRec
/// Input: id flag:是否返回记录内容
/// Output: 科室好人好事记录
/// Other: w ##class(web.INMHBComm).GetLocGoodRec(1)
ClassMethod GetLocGoodRec(id As %String = "", flag As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgLocGoodRecD(id))) ""
	
	s goodGlo=^DHCINM.HB.MgLocGoodRecD(id)
	s goodWard=$lg(goodGlo,2)
	s goodWardDesc=""
	i goodWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(goodWard))
	.s goodWardDesc=$lg(wardGlo,4)
	s goodDate=$lg(goodGlo,3)
	s:goodDate'="" goodDate=$zd(goodDate,3)
	s goodTime=$lg(goodGlo,4)
	s:goodTime'="" goodTime=$zt(goodTime)
	s goodLocation=$lg(goodGlo,5)
	s goodParti=$lg(goodGlo,6)
	s goodPartiId=$lts(goodParti,",")
	s goodPartiName=""
	s index=1,ptr=0 f  s stat=$listnext(goodParti,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s goodPartiName=perName
	.e  s goodPartiName=goodPartiName_","_perName
	.s index=index+1
	s goodContent=""
	s:flag=1 goodContent=$lg(goodGlo,7)
	s goodStatus=$lg(goodGlo,8)
	s goodStatusDesc=$case(goodStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(goodGlo,9)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(goodGlo,10)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(goodGlo,11)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="GoodWard|"_goodWard_"^GoodWardDesc|"_goodWardDesc_"^GoodDate|"_goodDate_"^GoodTime|"_goodTime_"^GoodLocation|"_goodLocation
	s ret=ret_"^GoodParticipant|"_goodPartiId_"^GoodParticipantName|"_goodPartiName_"^GoodContent|"_goodContent_"^GoodStatus|"_goodStatus
	s ret=ret_"^GoodStatusDesc|"_goodStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate
	s ret=ret_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description：获取科室好人好事记录列表
/// Date:2020-07-11
/// Creator:wangpf
/// Table:DHCINM.HB.MgLocGoodRecD
/// Input: 病区^开始日期^结束日期^状态 登录人Id 登录人角色
/// Output:科室好人好事记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindLocGoodRecList","^^^",0,0)
Query FindLocGoodRecList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocGoodRecListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",4)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s goodDate="" f  s goodDate=$o(^DHCINM.HB.MgLocGoodRecI("ToolIndex",goodDate),-1) q:goodDate=""  d
	.q:((stDate'="")&&(goodDate<stDate))||((endDate'="")&&(goodDate>endDate))
	.s goodWard="" f  s goodWard=$o(^DHCINM.HB.MgLocGoodRecI("ToolIndex",goodDate,goodWard)) q:goodWard=""  d
	..q:((ward'="")&&(ward'=goodWard))||((isAll'=1)&&('$d(tmpWard(goodWard))))
	..s goodStatus="" f  s goodStatus=$o(^DHCINM.HB.MgLocGoodRecI("ToolIndex",goodDate,goodWard,goodStatus)) q:goodStatus=""  d
	...q:(status'="")&&(status'=$tr(goodStatus," ",""))
	...s id="" f  s id=$o(^DHCINM.HB.MgLocGoodRecI("ToolIndex",goodDate,goodWard,goodStatus,id)) q:id=""  d
	....q:'$d(^DHCINM.HB.MgLocGoodRecD(id))
	....s ret=..GetLocGoodRec(id)
	....d:ret'="" OutGoodList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGoodList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocGoodRecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocGoodRecListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocGoodRecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocGoodRecListExecute ]
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

/// Description: 提交科室好人好事记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocGoodRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SubmitLocGoodRec(1)
ClassMethod SubmitLocGoodRec(id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgLocGoodRec).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.GoodStatus="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除科室好人好事记录
/// Date: 2020-07-11
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocGoodRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteLocGoodRec(1)
ClassMethod DeleteLocGoodRec(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgLocGoodRec).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存抢救危重病人记录
/// Date: 2020-07-12
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatRescueRec
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SavePatResRec("",0)
ClassMethod SavePatResRec(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s stTime=$p(parr,"^",3)
	s:stTime[":" stTime=$zth(stTime)
	s endTime=$p(parr,"^",4)
	s:endTime[":" endTime=$zth(endTime)
	s adm=$p(parr,"^",5)
	s sex=$p(parr,"^",6)
	s age=$p(parr,"^",7)
	s bed=$p(parr,"^",8)
	s reg=$p(parr,"^",9)
	s diag=$p(parr,"^",10)
	s result=$p(parr,"^",11)
	s status=$p(parr,"^",12)
	s rw=$p(parr,"^",13)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgPatRescueRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgPatRescueRec).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.RescueWardSetObjectId(ward)
	s obj.RescueDate=date
	s obj.RescueStTime=stTime
	s obj.RescueEndTime=endTime
	d obj.RescuePatAdmSetObjectId(adm)
	s obj.RescuePatSex=sex
	s obj.RescuePatAge=age
	s obj.RescuePatBed=bed
	s obj.RescuePatNo=reg
	s obj.RescuePatDiag=diag
	s obj.RescueResult=result
	s obj.RescueStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 获取抢救危重病人记录
/// Date: 2020-07-12
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatRescueRec
/// Input: id
/// Output: 科室好人好事记录
/// Other: w ##class(web.INMHBComm).GetPatResRec(1)
ClassMethod GetPatResRec(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgPatRescueRecD(id))) ""
	
	s resGlo=^DHCINM.HB.MgPatRescueRecD(id)
	s resWard=$lg(resGlo,2)
	s resWardDesc=""
	i resWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(resWard))
	.s resWardDesc=$lg(wardGlo,4)
	s resDate=$lg(resGlo,3)
	s:resDate'="" resDate=$zd(resDate,3)
	s resStTime=$lg(resGlo,4)
	s:resStTime'="" resStTime=$zt(resStTime)
	s resEndTime=$lg(resGlo,5)
	s:resEndTime'="" resEndTime=$zt(resEndTime)
	s resAdm=$lg(resGlo,6)
	s resPatSex=$lg(resGlo,7)
	s resPatAge=$lg(resGlo,8)
	s resPatBed=$lg(resGlo,9)
	s resPatRegNo=$lg(resGlo,10)
	s resPatName=""
	s regId=$o(^PAPERi("PAPMI_PatNo",resPatRegNo,""))
	s:regId'="" resPatName=$p(^PAPER(regId,"ALL"),"^",1)
	s resPatDiag=$lg(resGlo,11)
	s resResult=$lg(resGlo,12)
	s resResultDesc=$case(resResult,"N":"失败","Y":"成功",:"")
	s resStatus=$lg(resGlo,13)
	s resStatusDesc=$case(resStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(resGlo,14)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(resGlo,15)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(resGlo,16)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="RescueWard|"_resWard_"^RescueWardDesc|"_resWardDesc_"^RescueDate|"_resDate_"^RescueStTime|"_resStTime_"^RescueEndTime|"_resEndTime
	s ret=ret_"^RescuePatAdm|"_resAdm_"^RescuePatName|"_resPatName_"^RescuePatSex|"_resPatSex_"^RescuePatAge|"_resPatAge_"^RescuePatBed|"_resPatBed
	s ret=ret_"^RescuePatNo|"_resPatRegNo_"^RescuePatDiag|"_resPatDiag_"^RescueResult|"_resResult_"^RescueResultDesc|"_resResultDesc_"^RescueStatus|"_resStatus
	s ret=ret_"^RescueStatusDesc|"_resStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description：获取抢救危重病人记录列表
/// Date:2020-07-12
/// Creator:wangpf
/// Table:DHCINM.HB.MgPatRescueRec
/// Input: 病区^开始日期^结束日期^状态 登录人Id 登录人角色
/// Output:抢救危重病人记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindPatResRecList","^^^",0,0)
Query FindPatResRecList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPatResRecListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",4)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s resDate="" f  s resDate=$o(^DHCINM.HB.MgPatRescueRecI("ToolIndex",resDate),-1) q:resDate=""  d
	.q:((stDate'="")&&(resDate<stDate))||((endDate'="")&&(resDate>endDate))
	.s resWard="" f  s resWard=$o(^DHCINM.HB.MgPatRescueRecI("ToolIndex",resDate,resWard)) q:resWard=""  d
	..q:((ward'="")&&(ward'=resWard))||((isAll'=1)&&('$d(tmpWard(resWard))))
	..s resStatus="" f  s resStatus=$o(^DHCINM.HB.MgPatRescueRecI("ToolIndex",resDate,resWard,resStatus)) q:resStatus=""  d
	...q:(status'="")&&(status'=$tr(resStatus," ",""))
	...s id="" f  s id=$o(^DHCINM.HB.MgPatRescueRecI("ToolIndex",resDate,resWard,resStatus,id)) q:id=""  d
	....q:'$d(^DHCINM.HB.MgPatRescueRecD(id))
	....s ret=..GetPatResRec(id)
	....d:ret'="" OutResList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutResList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPatResRecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatResRecListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPatResRecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatResRecListExecute ]
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

/// Description: 提交抢救危重病人记录
/// Date: 2020-07-12
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatRescueRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SubmitPatResRec(1)
ClassMethod SubmitPatResRec(id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgPatRescueRec).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.RescueStatus="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除抢救危重病人记录
/// Date: 2020-07-12
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatRescueRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeletePatResRec(1)
ClassMethod DeletePatResRec(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgPatRescueRec).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存奖罚事例记录
/// Date: 2020-07-14
/// Creator: wangpf
/// Table: DHCINM.HB.MgRePuRec
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveRePuRec("",0)
ClassMethod SaveRePuRec(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s time=$p(parr,"^",3)
	s:time[":" time=$zth(time)
	s type=$p(parr,"^",4)
	s typeSub=$p(parr,"^",5)
	s typeSubPar=$p(typeSub,"||")
	s typeSubSub=$p(typeSub,"||",2)
	q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(typeSubPar,typeSubSub)) 0
	s participant=$p(parr,"^",6)
	s partiList=$lfs(participant,",")
	s reason=$p(parr,"^",7)
	s status=$p(parr,"^",8)
	s rw=$p(parr,"^",9)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgRePuRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgRePuRec).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.RecWardSetObjectId(ward)
	s obj.RecDate=date
	s obj.RecTime=time
	s obj.RecType=type
	d obj.RecTypeSubSetObjectId(typeSub)
	d obj.RecParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.RecParticipant.Insert(per)
	s obj.RecReason=reason
	s obj.RecStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 获取奖罚事例记录
/// Date: 2020-07-14
/// Creator: wangpf
/// Table: DHCINM.HB.MgRePuRec
/// Input: id flag:是否返回奖罚原因
/// Output: 奖罚事例记录
/// Other: w ##class(web.INMHBComm).GetRePuRec(1)
ClassMethod GetRePuRec(id As %String = "", flag As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgRePuRecD(id))) ""
	
	s recGlo=^DHCINM.HB.MgRePuRecD(id)
	s recWard=$lg(recGlo,2)
	s recWardDesc=""
	i recWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(recWard))
	.s recWardDesc=$lg(wardGlo,4)
	s recDate=$lg(recGlo,3)
	s:recDate'="" recDate=$zd(recDate,3)
	s recTime=$lg(recGlo,4)
	s:recTime'="" recTime=$zt(recTime)
	s recType=$lg(recGlo,5)
	s recTypeDesc=$case(recType,"R":"奖励","P":"处罚",:"")
	s recTypeSub=$lg(recGlo,6)
	s recTypeSubDesc=""
	i recTypeSub'="" d
	.s par=$p(recTypeSub,"||")
	.s sub=$p(recTypeSub,"||",2)
	.s typeGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(par,sub))
	.s recTypeSubDesc=$lg(typeGlo,3)
	s recParti=$lg(recGlo,7)
	s recPartiId=$lts(recParti,",")
	s recPartiName=""
	s index=1,ptr=0 f  s stat=$listnext(recParti,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s recPartiName=perName
	.e  s recPartiName=recPartiName_","_perName
	.s index=index+1
	s recReason=""
	s:flag=1 recReason=$lg(recGlo,8)
	s recStatus=$lg(recGlo,9)
	s recStatusDesc=$case(recStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(recGlo,10)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(recGlo,11)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(recGlo,12)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="RecWard|"_recWard_"^RecWardDesc|"_recWardDesc_"^RecDate|"_recDate_"^RecTime|"_recTime_"^RecType|"_recType_"^RecTypeDesc|"_recTypeDesc
	s ret=ret_"^RecTypeSub|"_recTypeSub_"^RecTypeSubDesc|"_recTypeSubDesc_"^RecParticipant|"_recPartiId_"^RecParticipantName|"_recPartiName
	s ret=ret_"^RecReason|"_recReason_"^RecStatus|"_recStatus_"^RecStatusDesc|"_recStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName
	s ret=ret_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description：获取奖罚事例记录列表
/// Date:2020-07-14
/// Creator:wangpf
/// Table:DHCINM.HB.MgRePuRec
/// Input: 病区^开始日期^结束日期^状态 登录人Id
/// Output:科室好人好事记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindLocGoodRecList","^^^",0,0)
Query FindRePuRecList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRePuRecListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s type=$p(parr,"^",4)
	s typeSub=$p(parr,"^",5)
	s typeSubList=$lfs(typeSub,",")
	s status=$p(parr,"^",6)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s recDate="" f  s recDate=$o(^DHCINM.HB.MgRePuRecI("ToolIndex",recDate),-1) q:recDate=""  d
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s recWard="" f  s recWard=$o(^DHCINM.HB.MgRePuRecI("ToolIndex",recDate,recWard)) q:recWard=""  d
	..q:((ward'="")&&(ward'=recWard))||((isAll'=1)&&('$d(tmpWard(recWard))))
	..s recType="" f  s recType=$o(^DHCINM.HB.MgRePuRecI("ToolIndex",recDate,recWard,recType)) q:recType=""  d
	...q:(type'="")&&(type'=$tr(recType," ",""))
	...s recTypeSub="" f  s recTypeSub=$o(^DHCINM.HB.MgRePuRecI("ToolIndex",recDate,recWard,recType,recTypeSub)) q:recTypeSub=""  d
	....q:(typeSub'="")&&($lf(typeSubList,recTypeSub)=0)
	....s recStatus="" f  s recStatus=$o(^DHCINM.HB.MgRePuRecI("ToolIndex",recDate,recWard,recType,recTypeSub,recStatus)) q:recStatus=""  d
	.....q:(status'="")&&(status'=$tr(recStatus," ",""))
	.....s id="" f  s id=$o(^DHCINM.HB.MgRePuRecI("ToolIndex",recDate,recWard,recType,recTypeSub,recStatus,id)) q:id=""  d
	......q:'$d(^DHCINM.HB.MgRePuRecD(id))
	......s ret=..GetRePuRec(id,1)
	......d:ret'="" OutRecList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRecList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRePuRecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRePuRecListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRePuRecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRePuRecListExecute ]
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

/// Description: 提交奖罚事例记录
/// Date: 2020-07-14
/// Creator: wangpf
/// Table: DHCINM.HB.MgRePuRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SubmitRePuRec(1)
ClassMethod SubmitRePuRec(id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgRePuRec).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.RecStatus="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除奖罚事例记录
/// Date: 2020-07-14
/// Creator: wangpf
/// Table: DHCINM.HB.MgRePuRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteRePuRec(1)
ClassMethod DeleteRePuRec(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgRePuRec).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存质控活动记录
/// Date: 2020-07-16
/// Creator: wangpf
/// Table: DHCINM.HB.MgQualActivity
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveActivity("",0)
ClassMethod SaveActivity(parr As %String = "", content As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward))
	s date=$p(parr,"^",2)
	s:date'="" date=$zdh(date,3)
	s type=$p(parr,"^",3)
	s host=$p(parr,"^",4)
	q:'$d(^CF.DHCINM.HR.PersonsD(host)) 0
	s recorder=$p(parr,"^",5)
	q:'$d(^CF.DHCINM.HR.PersonsD(recorder)) 0
	s participant=$p(parr,"^",6)
	s partiList=$lfs(participant,",")
	s topic=$p(parr,"^",7)
	s status=$p(parr,"^",8)
	s rw=$p(parr,"^",9)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgQualActivity).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgQualActivity).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.ActivityWardSetObjectId(ward)
	s obj.ActivityDate=date
	s obj.ActivityType=type
	d obj.ActivityHostSetObjectId(host)
	d obj.ActivityRecorderSetObjectId(recorder)
	d obj.ActivityParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:(per="")||('$d(^CF.DHCINM.HR.PersonsD(per)))
	.d obj.ActivityParticipant.Insert(per)
	s obj.ActivityTopic=topic
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.ActivityContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.ActivityContentExt.Write(content)
	}
	s obj.ActivityStatus=status
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取质控活动记录
/// Date: 2020-07-16
/// Creator: wangpf
/// Table: DHCINM.HB.MgQualActivity
/// Input: id flag:是否返回活动内容
/// Output: 护理查房内容
/// Other: w ##class(web.INMHBComm).GetActivity(1)
ClassMethod GetActivity(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.HB.MgQualActivityD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	
	s actGlo=^DHCINM.HB.MgQualActivityD(id)
	
	s actWard=$lg(actGlo,2)
	s actWardDesc=""
	i actWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(actWard))
	.s actWardDesc=$lg(wardGlo,4)
	s actType=$lg(actGlo,3)
	s actTypeDesc=$case(actType,1:"质控会议",2:"质量讲评",:"")
	s actDate=$lg(actGlo,4)
	s:actDate'="" actDate=$zd(actDate,3)
	s actHoster=$lg(actGlo,5)
	s actHosterName=""
	i actHoster'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(actHoster))
	.s actHosterName=$lg(perGlo,2)
	s actRecorder=$lg(actGlo,6)
	s actRecorderName=""
	i actRecorder'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(actRecorder))
	.s actRecorderName=$lg(perGlo,2)
	s actParti=$lg(actGlo,7)
	s actPartiId=$lts(actParti,",")
	s actPartiName=""
	s index=0,ptr=0 f  s stat=$listnext(actParti,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=0 s actPartiName=perName
	.e  s actPartiName=actPartiName_","_perName
	.s index=index+1
	s actTopic=$lg(actGlo,8)
	s actContent=""
	;s:flag=1 actContent=$lg(actGlo,9)
	s actStatus=$lg(actGlo,10)
	s actStatusDesc=$case(actStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(actGlo,11)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(actGlo,12)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(actGlo,13)
	s:createTime'="" createTime=$zt(createTime,1)
	
	i flag=1{
		w "{""ActivityWard"":"""_actWard_""",""ActivityWardDesc"":"""_actWardDesc_""",""ActivityType"":"""_actType_""",""ActivityTypeDesc"":"""_actTypeDesc
		w """,""ActivityDate"":"""_actDate_""",""ActivityHost"":"""_actHoster_""",""ActivityHostName"":"""_actHosterName_""",""ActivityRecorder"":"""_actRecorder
		w """,""ActivityRecorderName"":"""_actRecorderName_""",""ActivityParticipant"":"""_actPartiId_""",""ActivityParticipantName"":"""_actPartiName
		w """,""ActivityTopic"":"""_actTopic_""",""ActivityContent"":"""
		s obj=##class(DHCINM.HB.MgQualActivity).%OpenId(id)
		while ('obj.ActivityContentExt.AtEnd){
			w $tr(obj.ActivityContentExt.Read(),$c(10,13))
		}
		w """,""ActivityStatus"":"""_actStatus_""",""ActivityStatusDesc"":"""_actStatusDesc_""",""Creator"":"""_creator_""",""CreatorName"":"""_creatorName
		w """,""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime_""",""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="ActivityWard|"_actWard_"^ActivityWardDesc|"_actWardDesc_"^ActivityType|"_actType_"^ActivityTypeDesc|"_actTypeDesc_"^ActivityDate|"_actDate
		s ret=ret_"^ActivityHost|"_actHoster_"^ActivityHostName|"_actHosterName_"^ActivityRecorder|"_actRecorder_"^ActivityRecorderName|"_actRecorderName
		s ret=ret_"^ActivityParticipant|"_actPartiId_"^ActivityParticipantName|"_actPartiName_"^ActivityTopic|"_actTopic_"^ActivityContent|"_actContent
		s ret=ret_"^ActivityStatus|"_actStatus_"^ActivityStatusDesc|"_actStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate
		s ret=ret_"^CreateTime|"_createTime_"^rw|"_id
		q ret
	}
}

/// Description：获取质控活动记录列表
/// Date:2020-07-16
/// Creator:wangpf
/// Table:DHCINM.HB.MgQualActivity
/// Input: 病区Id^开始日期^结束日期 登录人Id 登录人角色
/// Output:质控活动记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindActivityList","1^^",0,0)
Query FindActivityList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindActivityListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s type=$p(parr,"^",2)
	s stDate=$p(parr,"^",3)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",5)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s actDate="" f  s actDate=$o(^DHCINM.HB.MgQualActivityI("ToolIndex",actDate),-1) q:actDate=""  d
	.q:((stDate'="")&&(stDate>actDate))||((endDate'="")&&(endDate<actDate))
	.s actWard="" f  s actWard=$o(^DHCINM.HB.MgQualActivityI("ToolIndex",actDate,actWard)) q:actWard=""  d
	..q:((ward'="")&&(ward'=actWard))||((isAll'=1)&&('$d(tmpWard(actWard))))
	..s actType="" f  s actType=$o(^DHCINM.HB.MgQualActivityI("ToolIndex",actDate,actWard,actType)) q:actType=""  d
	...q:(type'="")&&(type'=actType)
	...s actStatus="" f  s actStatus=$o(^DHCINM.HB.MgQualActivityI("ToolIndex",actDate,actWard,actType,actStatus)) q:actStatus=""  d
	....q:(status'="")&&(status'=$tr(actStatus," ",""))
	....s id="" f  s id=$o(^DHCINM.HB.MgQualActivityI("ToolIndex",actDate,actWard,actType,actStatus,id)) q:id=""  d
	.....s ret=..GetActivity(id)
	.....d:ret'="" OutActivityList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutActivityList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindActivityListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindActivityListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindActivityListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindActivityListExecute ]
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

/// Description: 删除质控活动记录
/// Date: 2020-07-16
/// Creator: wangpf
/// Table: DHCINM.HB.MgQualActivity
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteActivity(1)
ClassMethod DeleteActivity(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgQualActivity).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存质控整改分析记录
/// Date: 2020-07-17
/// Creator: wangpf
/// Table: DHCINM.HB.MgQualChange
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveQualChange("",0)
ClassMethod SaveQualChange(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward))
	s qual=$p(parr,"^",2)
	q:'$d(^CT.DHCINM.DB.MgQualItemD(qual))
	s ques=$p(parr,"^",3)
	s reason=$p(parr,"^",4)
	s reasonList=$lfs(reason,",")
	s nurReaason=$p(parr,"^",5)
	s patReason=$p(parr,"^",6)
	s devReason=$p(parr,"^",7)
	s workReason=$p(parr,"^",8)
	s goodReason=$p(parr,"^",9)
	s otherReason=$p(parr,"^",10)
	s step=$p(parr,"^",11)
	s goal=$p(parr,"^",12)
	s hlbView=$p(parr,"^",13)
	s status=$p(parr,"^",14)
	s source=$p(parr,"^",15)
	s result=$p(parr,"^",16)
	q:(source="A")&&(result="") 0
	q:(result'="")&&('$d(^DHCINM.CHK.MgCheckResultD(result))) 0
	s rw=$p(parr,"^",17)
	i rw="" d
	.s obj=##class(DHCINM.HB.MgQualChange).%New()
	.s obj.ChangeSource=source
	.s obj.Creator=nurseid
	.i result'="" d obj.ChangeResultSetObjectId(result)
	e  s obj=##class(DHCINM.HB.MgQualChange).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.ChangeWardSetObjectId(ward)
	d obj.ChangeQualSetObjectId(qual)
	s obj.ChangeQues=ques
	d obj.ChangeReason.Clear()
	s ptr=0 f  s stat=$listnext(reasonList,ptr,rea) q:stat'=1  d
	.d obj.ChangeReason.Insert(rea)
	s obj.ChangeNurRea=nurReaason
	s obj.ChangePatRea=patReason
	s obj.ChangeDeviceRea=devReason
	s obj.ChangeWorkRea=workReason
	s obj.ChangeGoodsRea=goodReason
	s obj.ChangeOtherRea=otherReason
	s obj.ChangeStep=step
	s obj.ChangeGoal=goal
	s obj.ChangeHLBView=hlbView
	s obj.ChangeStatus=status
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 批量保存质控整改分析记录
/// Date: 2020-07-17
/// Creator: wangpf
/// Table: DHCINM.HB.MgQualChange
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveQualChangePatch("",0)
ClassMethod SaveQualChangePatch(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s dataList=$lfs(parr,"ˇ")
	s ptr=0 f  s status=$listnext(dataList,ptr,dataString) q:status'=1  d
	.d ..SaveQualChange(dataString,nurseid)
	q 1
}

/// Description: 获取质控整改分析记录
/// Date: 2020-07-17
/// Creator: wangpf
/// Table: DHCINM.HB.MgQualChange
/// Input: id
/// Output: 获取质控整改分析记录
/// Other: w ##class(web.INMHBComm).GetQualChange(1)
ClassMethod GetQualChange(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgQualChangeD(id))) ""
	
	s changeGlo=^DHCINM.HB.MgQualChangeD(id)
	s changeWard=$lg(changeGlo,2)
	s changeWardDesc=""
	i changeWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(changeWard))
	.s changeWardDesc=$lg(wardGlo,4)
	s changeSource=$lg(changeGlo,3)
	s changeSourceDesc=$case(changeSource,1:"质控会议",2:"质量讲评",:"")
	s changeQual=$lg(changeGlo,4)
	s changeQualDesc=""
	i changeQual'="" d
	.s qualGlo=$g(^CT.DHCINM.DB.MgQualItemD(changeQual))
	.s changeQualDesc=$lg(qualGlo,4)
	s changeQues=$lg(changeGlo,5)
	s changeReason=$lg(changeGlo,6)
	s changeReason=$lts(changeReason,",")
	s changeNurRea=$lg(changeGlo,7)
	s changePatRea=$lg(changeGlo,8)
	s changeDeviceRea=$lg(changeGlo,9)
	s changeWorkRea=$lg(changeGlo,10)
	s changeGoodsRea=$lg(changeGlo,11)
	s changeOtherRea=$lg(changeGlo,12)
	s changeStep=$lg(changeGlo,13)
	s changeGoal=$lg(changeGlo,14)
	s changeHLBView=$lg(changeGlo,15)
	s changeStatus=$lg(changeGlo,16)
	s changeStatusDesc=$case(changeStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(changeGlo,17)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(changeGlo,18)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(changeGlo,19)
	s:createTime'="" createTime=$zt(createTime,1)
	s changeResult=$lg(changeGlo,20)
	s ret="ChangeWard|"_changeWard_"^ChangeWardDesc|"_changeWardDesc_"^ChangeSource|"_changeSource_"^ChangeSourceDesc|"_changeSourceDesc_"^ChangeQual|"_changeQual
	s ret=ret_"^ChangeQualDesc|"_changeQualDesc_"^ChangeQues|"_changeQues_"^ChangeReason|"_changeReason_"^ChangeNurRea|"_changeNurRea_"^ChangePatRea|"_changePatRea
	s ret=ret_"^ChangeDeviceRea|"_changeDeviceRea_"^ChangeWorkRea|"_changeWorkRea_"^ChangeGoodsRea|"_changeGoodsRea_"^ChangeOtherRea|"_changeOtherRea
	s ret=ret_"^ChangeStep|"_changeStep_"^ChangeGoal|"_changeGoal_"^ChangeHLBView|"_changeHLBView_"^ChangeStatus|"_changeStatus_"^ChangeStatusDesc|"_changeStatusDesc
	s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^ChangeResult|"_changeResult_"^rw|"_id
	s changeReasonDesc="护理人员原因:"_changeNurRea_";患者原因:"_changePatRea_";设备原因:"_changeDeviceRea_";工作环境原因:"_changeWorkRea_";物品原因:"_changeGoodsRea_";其他原因:"_changeOtherRea
	s ret=ret_"^ChangeReasonDesc|"_changeReasonDesc
	q ret
}

/// Description：获取质控整改分析记录列表
/// Date:2020-07-17
/// Creator:wangpf
/// Table:DHCINM.HB.MgQualChange
/// Input: wardId^qualId^sourceType^开始日期^结束日期 登录人Id
/// Output:质控活动记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindQualChangeList","^^^2020-07-01^2020-07-31",0)
Query FindQualChangeList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQualChangeListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s qual=$p(parr,"^",2)
	s source=$p(parr,"^",3)
	s stDate=$p(parr,"^",4)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s changeDate="" f  s changeDate=$o(^DHCINM.HB.MgQualChangeI("ToolIndex",changeDate),-1) q:changeDate=""  d
	.q:((stDate'="")&&(stDate>changeDate))||((endDate'="")&&(endDate<changeDate))
	.s changeWard="" f  s changeWard=$o(^DHCINM.HB.MgQualChangeI("ToolIndex",changeDate,changeWard)) q:changeWard=""  d
	..q:((ward'="")&&(ward'=changeWard))||((isAll'=1)&&('$d(tmpWard(changeWard))))
	..s changeQual="" f  s changeQual=$o(^DHCINM.HB.MgQualChangeI("ToolIndex",changeDate,changeWard,changeQual)) q:changeQual=""  d
	...q:(qual'="")&&(qual'=changeQual)
	...s changeSource="" f  s changeSource=$o(^DHCINM.HB.MgQualChangeI("ToolIndex",changeDate,changeWard,changeQual,changeSource)) q:changeSource=""  d
	....q:(source'="")&&(source'=$tr(changeSource," ",""))
	....s id="" f  s id=$o(^DHCINM.HB.MgQualChangeI("ToolIndex",changeDate,changeWard,changeQual,changeSource,id)) q:id=""  d
	.....s ret=..GetQualChange(id)
	.....d:ret'="" OutChangeList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutChangeList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualChangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualChangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQualChangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualChangeListExecute ]
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

/// Description: 删除质控整改分析记录
/// Date: 2020-07-17
/// Creator: wangpf
/// Table: DHCINM.HB.MgQualChange
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteQualChange(1)
ClassMethod DeleteQualChange(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgQualChange).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 查询质控结果是否已关联质控整改分析记录
/// Date: 2020-07-17
/// Creator: wangpf
/// Table: DHCINM.HB.MgQualChange
/// Input: id
/// Output: 已关联id的index
/// Other: w ##class(web.INMHBComm).ConfirmConected("27,38")
ClassMethod ConfirmConected(id As %String = "") As %String
{
	w "["
	s idList=$lfs(id,",")
	s index=0,ptr=0,first=0 f  s status=$listnext(idList,ptr,resultId) q:status'=1  d
	.s index=index+1
	.q:'$d(^DHCINM.HB.MgQualChangeI("Result",resultId))
	.i first=0 w index-1
	.e  w ","_(index-1)
	.s first=first+1
	w "]"
	q ""
}

/// Description: 保存科室业务学习记录
/// Date: 2020-08-18
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocBusStudy
/// Input: parr userid
/// Output: 0：失败 >0：成功
/// Other: w ##class(web.INMHBComm).SaveLocBusStudy("",0)
ClassMethod SaveLocBusStudy(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s loc=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardLocD(loc)) 0
	s date=$p(parr,"^",2)
	s:date'="" date=$zdh(date,3)
	s level=$p(parr,"^",3)
	s topic=$p(parr,"^",4)
	s host=$p(parr,"^",5)
	q:(host="")&&('$d(^CF.DHCINM.HR.PersonsD(host))) 0
	s target=$p(parr,"^",6)
	s supNum=$p(parr,"^",7)
	s nurse=$p(parr,"^",8)
	s nurseList=$lfs(nurse,",")
	s remark=$p(parr,"^",9)
	s content=$p(parr,"^",10)
	s rw=$p(parr,"^",11)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgLocBusStudy).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgLocBusStudy).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.BusLocSetObjectId(loc)
	s obj.BusDate=date
	s obj.BusLevel=level
	s obj.BusTopic=topic
	d obj.BusHostSetObjectId(host)
	s obj.BusTarget=target
	s obj.BusSupNum=supNum
	d obj.BusNurse.Clear()
	s ptr=0 f  s stat=$listnext(nurseList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.BusNurse.Insert(per)
	s obj.BusRemark=remark
	s obj.BusContent=content
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存科室业务学习文件
/// Date: 2020-08-18
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocBusStudy
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveLocBusFile(3,"D:/dhcinm/SpecialActivity/3/安贞需求补.txt")
ClassMethod SaveLocBusFile(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.HB.MgLocBusStudy).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.BusFile="" s obj.BusFile=name
	e  s obj.BusFile=obj.BusFile_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除科室业务学习文件
/// Date: 2020-08-18
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocBusStudy
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteLocBusFile(3,"D:/dhcinm/SpecialActivity/3/安贞需求补.txt",0)
ClassMethod DeleteLocBusFile(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.HB.MgLocBusStudy).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.BusFile,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.BusFile,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.BusFile=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取科室业务学习
/// Date: 2020-08-18
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocBusStudy
/// Input: id
/// Output: 科室业务学习
/// Other: w ##class(web.INMHBComm).GetLocBusStudy(1)
ClassMethod GetLocBusStudy(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgLocBusStudyD(id))) ""
	
	s busGlo=^DHCINM.HB.MgLocBusStudyD(id)
	s busLoc=$lg(busGlo,2)
	s busLocDesc=""
	i busLoc'="" d
	.s locGlo=$g(^CF.DHCINM.DB.MgWardLocD(busLoc))
	.s busLocDesc=$lg(locGlo,3)
	s busDate=$lg(busGlo,3)
	s:busDate'="" busDate=$zd(busDate,3)
	s busLevel=$lg(busGlo,4)
	s busLevelDesc=##class(DHCINM.HB.MgLocBusStudy).BusLevelLogicalToDisplay(busLevel)
	s busTopic=$lg(busGlo,5)
	s busHost=$lg(busGlo,6)
	s busHostName="",BusNurseNum=0
	i busHost'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(busHost))
	.s busHostName=$lg(perGlo,2),BusNurseNum=1
	s busTarget=$lg(busGlo,7)
	s busSupNum=$lg(busGlo,8)
	s busNurse=$lg(busGlo,9)
	s busNurseId=$lts(busNurse,",")
	s busNurseName=""
	s index=1,ptr=0 f  s stat=$listnext(busNurse,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s busNurseName=perName
	.e  s busNurseName=busNurseName_","_perName
	.s index=index+1
	.s:per'=busHost BusNurseNum=BusNurseNum+1
	s busRemark=$lg(busGlo,10)
	s busContent=$lg(busGlo,11)
	s busFile=$lg(busGlo,12)
	s creator=$lg(busGlo,13)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(busGlo,14)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(busGlo,15)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="BusLoc|"_busLoc_"^BusLocDesc|"_busLocDesc_"^BusDate|"_busDate_"^BusLevel|"_busLevel_"^BusLevelDesc|"_busLevelDesc
	s ret=ret_"^BusTopic|"_busTopic_"^BusHost|"_busHost_"^BusHostName|"_busHostName_"^BusTarget|"_busTarget_"^BusSupNum|"_busSupNum
	s ret=ret_"^BusNurse|"_busNurseId_"^BusNurseName|"_busNurseName_"^BusRemark|"_busRemark_"^BusContent|"_busContent_"^BusFile|"_busFile
	s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	_"^BusNurseNum|"_BusNurseNum
	q ret
}

/// Description：获取科室业务学习列表
/// Date:2020-08-18
/// Creator:wangpf
/// Table:DHCINM.HB.MgLocBusStudy
/// Input: 科室^级别^开始日期^结束日期 登录人Id
/// Output:科室业务学习列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindLocBusList","^^^",0)
Query FindLocBusList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocBusListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s loc=$p(parr,"^")
	s level=$p(parr,"^",2)
	s levelList=$lfs(level,",")
	s stDate=$p(parr,"^",3)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate["-" endDate=$zdh(endDate,3)
	s perId=$p(parr,"^",5)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	k tmpLoc
	s ward="" f  s ward=$o(^CF.DHCINM.DB.MgWardD(ward)) q:ward=""  d
	.q:(isAll'=1)&&('$d(tmpWard(ward)))
	.s locId=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",ward,""))
	.q:(locId="")||('$d(^CF.DHCINM.DB.MgWardLocD(locId)))
	.s tmpLoc(locId)=1
	
	s busDate="" f  s busDate=$o(^DHCINM.HB.MgLocBusStudyI("ToolIndex",busDate),-1) q:busDate=""  d
	.q:((stDate'="")&&(stDate>busDate))||((endDate'="")&&(endDate<busDate))
	.s busLoc="" f  s busLoc=$o(^DHCINM.HB.MgLocBusStudyI("ToolIndex",busDate,busLoc)) q:busLoc=""  d
	..q:((loc'="")&&(loc'=busLoc))||((isAll'=1)&&('$d(tmpLoc(busLoc))))
	..s busLevel="" f  s busLevel=$o(^DHCINM.HB.MgLocBusStudyI("ToolIndex",busDate,busLoc,busLevel)) q:busLevel=""  d
	...q:(level'="")&&($lf(levelList,$tr(busLevel," ",""))=0)
	...s id="" f  s id=$o(^DHCINM.HB.MgLocBusStudyI("ToolIndex",busDate,busLoc,busLevel,id)) q:id=""  d
	....q:'$d(^DHCINM.HB.MgLocBusStudyD(id))
	....s busGlo=^DHCINM.HB.MgLocBusStudyD(id)
	....s busHost=$lg(busGlo,6)
	....s tmpList=$lb(busHost)
	....s busNurse=$lg(busGlo,9)
	....s tmpList=tmpList_busNurse
	....q:(perId'="")&&($lf(tmpList,perId)=0)
	....s ret=..GetLocBusStudy(id)
	....d:ret'="" OutStudyList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutStudyList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocBusListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocBusListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocBusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocBusListExecute ]
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

/// Description: 删除科室业务学习记录
/// Date: 2020-08-18
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocBusStudy
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteLocBusStudy(1)
ClassMethod DeleteLocBusStudy(id As %String = "") As %String
{
	q:id="" 0
	
	s sc=##class(DHCINM.HB.MgLocBusStudy).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存科室技能学习记录
/// Date: 2020-08-19
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocSkillStudy
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveLocSkillStudy("",0)
ClassMethod SaveLocSkillStudy(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s loc=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardLocD(loc)) 0
	s date=$p(parr,"^",2)
	s:date'="" date=$zdh(date,3)
	s topic=$p(parr,"^",3)
	s host=$p(parr,"^",4)
	q:(host="")&&('$d(^CF.DHCINM.HR.PersonsD(host))) 0
	s nurse=$p(parr,"^",5)
	s nurseList=$lfs(nurse,",")
	s remark=$p(parr,"^",6)
	s rw=$p(parr,"^",7)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgLocSkillStudy).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgLocSkillStudy).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.SkillLocSetObjectId(loc)
	s obj.SkillDate=date
	s obj.SkillTopic=topic
	d obj.SkillHostSetObjectId(host)
	d obj.SkillNurse.Clear()
	s ptr=0 f  s stat=$listnext(nurseList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.SkillNurse.Insert(per)
	s obj.SkillRemark=remark
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取科室技能学习
/// Date: 2020-08-19
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocSkillStudy
/// Input: id
/// Output: 科室技能学习
/// Other: w ##class(web.INMHBComm).GetLocSkillStudy(1)
ClassMethod GetLocSkillStudy(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgLocSkillStudyD(id))) ""
	
	s skillGlo=^DHCINM.HB.MgLocSkillStudyD(id)
	s skillLoc=$lg(skillGlo,2)
	s skillLocDesc=""
	i skillLoc'="" d
	.s locGlo=$g(^CF.DHCINM.DB.MgWardLocD(skillLoc))
	.s skillLocDesc=$lg(locGlo,3)
	s skillDate=$lg(skillGlo,3)
	s:skillDate'="" skillDate=$zd(skillDate,3)
	s skillTopic=$lg(skillGlo,4)
	s skillHost=$lg(skillGlo,5)
	s skillHostName="",SkillNurseNum=0
	i skillHost'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(skillHost))
	.s skillHostName=$lg(perGlo,2)
	.s SkillNurseNum=1
	s skillNurse=$lg(skillGlo,6)
	s skillNurseId=$lts(skillNurse,",")
	s skillNurseName=""
	s index=1,ptr=0 f  s stat=$listnext(skillNurse,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s skillNurseName=perName
	.e  s skillNurseName=skillNurseName_","_perName
	.s index=index+1
	.s:per'=skillHost SkillNurseNum=SkillNurseNum+1
	s skillRemark=$lg(skillGlo,7)
	s creator=$lg(skillGlo,8)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(skillGlo,9)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(skillGlo,10)
	s:createTime'="" createTime=$zt(createTime,1)
	
	s ret="SkillLoc|"_skillLoc_"^SkillLocDesc|"_skillLocDesc_"^SkillDate|"_skillDate_"^SkillTopic|"_skillTopic_"^SkillHost|"_skillHost
	s ret=ret_"^SkillHostName|"_skillHostName_"^SkillNurse|"_skillNurseId_"^SkillNurseName|"_skillNurseName_"^SkillRemark|"_skillRemark
	s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	_"^SkillNurseNum|"_SkillNurseNum
	q ret
}

/// Description：获取科室技能学习列表
/// Date:2020-08-19
/// Creator:wangpf
/// Table:DHCINM.HB.MgLocSkillStudy
/// Input: 科室^开始日期^结束日期 登录人Id
/// Output:科室技能学习列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindLocSkillList","^^",0)
Query FindLocSkillList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocSkillListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s loc=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s perId=$p(parr,"^",4)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	k tmpLoc
	s ward="" f  s ward=$o(^CF.DHCINM.DB.MgWardD(ward)) q:ward=""  d
	.q:(isAll'=1)&&('$d(tmpWard(ward)))
	.s locId=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",ward,""))
	.q:(locId="")||('$d(^CF.DHCINM.DB.MgWardLocD(locId)))
	.s tmpLoc(locId)=1
	
	s skillDate="" f  s skillDate=$o(^DHCINM.HB.MgLocSkillStudyI("ToolIndex",skillDate),-1) q:skillDate=""  d
	.q:((stDate'="")&&(stDate>skillDate))||((endDate'="")&&(endDate<skillDate))
	.s skillLoc="" f  s skillLoc=$o(^DHCINM.HB.MgLocSkillStudyI("ToolIndex",skillDate,skillLoc)) q:skillLoc=""  d
	..q:((loc'="")&&(loc'=skillLoc))||((isAll'=1)&&('$d(tmpLoc(skillLoc))))
	..s id="" f  s id=$o(^DHCINM.HB.MgLocSkillStudyI("ToolIndex",skillDate,skillLoc,id)) q:id=""  d
	...q:'$d(^DHCINM.HB.MgLocSkillStudyD(id))
	...s skillGlo=^DHCINM.HB.MgLocSkillStudyD(id)
	...s skillHost=$lg(skillGlo,5)
	...s tmpList=$lb(skillHost)
	...s skillNurse=$lg(skillGlo,6)
	...s tmpList=tmpList_skillNurse
	...q:(perId'="")&&($lf(tmpList,perId)=0)
	...s ret=..GetLocSkillStudy(id)
	...d:ret'="" OutStudyList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutStudyList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocSkillListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocSkillListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocSkillListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocSkillListExecute ]
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

/// Description: 删除科室技能学习记录
/// Date: 2020-08-19
/// Creator: wangpf
/// Table: DHCINM.HB.MgLocSkillStudy
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteLocSkillStudy(1)
ClassMethod DeleteLocSkillStudy(id As %String = "") As %String
{
	q:id="" 0
	
	s sc=##class(DHCINM.HB.MgLocSkillStudy).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存外出学习记录
/// Date: 2020-08-19
/// Creator: wangpf
/// Table: DHCINM.HB.MgOutStudyRec
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SaveOutStudy("1^2^2020-11-06^2020-11-06^76||1^77||1^1^52||1^大师傅^阿斯弗^^0^暗室逢灯^0^",0)
ClassMethod SaveOutStudy(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:(ward="")||('$d(^CF.DHCINM.DB.MgWardD(ward))) 0
	s nurse=$p(parr,"^",2)
	q:(nurse="")&&('$d(^CF.DHCINM.HR.PersonsD(nurse))) 0
	s stDate=$p(parr,"^",3)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate'="" endDate=$zdh(endDate,3)
	s level=$p(parr,"^",5)
	s levelPar=$p(level,"||")
	s levelSub=$p(level,"||",2)
	q:(level="")||('$d(^CT.DHCINM.DB.MgSetCodeSubD(levelPar,levelSub))) 0
	s type=$p(parr,"^",6)
	s typePar=$p(type,"||")
	s typeSub=$p(type,"||",2)
	q:(type="")||('$d(^CT.DHCINM.DB.MgSetCodeSubD(typePar,typeSub))) 0
	s isSpecial=$p(parr,"^",7)
	s specialGroup=$p(parr,"^",8)
	s groupPar=$p(specialGroup,"||")
	s groupSub=$p(specialGroup,"||",2)
	q:(specialGroup'="")&&('$d(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))) 0
	s content=$p(parr,"^",9)
	s location=$p(parr,"^",10)
	s scoreType=$p(parr,"^",11)
	s scoreTypePar=$p(scoreType,"||")
	s scoreTypeSub=$p(scoreType,"||",2)
	q:(scoreType'="")&&('$d(^CT.DHCINM.DB.MgSetCodeSubD(scoreTypePar,scoreTypeSub))) 0
	s score=$p(parr,"^",12)
	s unit=$p(parr,"^",13)
	s cost=$p(parr,"^",14)
	s rw=$p(parr,"^",15)
	
	i rw="" d
	.s obj=##class(DHCINM.HB.MgOutStudyRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgOutStudyRec).%OpenId(rw)
	b ;003
	q:'$IsObject(obj) 0
	d obj.OutWardSetObjectId(ward)
	d obj.OutNurseSetObjectId(nurse)
	s obj.OutStDate=stDate
	s obj.OutEndDate=endDate
	d obj.OutLevelSetObjectId(level)
	d obj.OutTypeSetObjectId(type)
	s obj.OutIsSpecial=isSpecial
	d:specialGroup'="" obj.OutSpecialGroupSetObjectId(specialGroup)
	s obj.OutContent=content
	s obj.OutLocation=location
	d obj.OutScoreTypeSetObjectId(scoreType)
	s obj.OutScore=score
	s obj.OutUnit=unit
	s obj.OutCost=cost
	s sc=obj.%Save()
	b ;001
	q $$$ISOK(sc)
}

/// Description: 获取外出学习记录
/// Date: 2020-08-19
/// Creator: wangpf
/// Table: DHCINM.HB.MgOutStudyRec
/// Input: id
/// Output: 外出学习记录
/// Other: w ##class(web.INMHBComm).GetOutStudy(1)
ClassMethod GetOutStudy(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgOutStudyRecD(id))) ""
	
	s outGlo=^DHCINM.HB.MgOutStudyRecD(id)
	s outWard=$lg(outGlo,2)
	s outWardDesc=""
	i outWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardLocD(outWard))
	.s outWardDesc=$lg(wardGlo,3)
	s outNurse=$lg(outGlo,3)
	s outNurseName=""
	i outNurse'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(outNurse))
	.s outNurseName=$lg(perGlo,2)
	s outStDate=$lg(outGlo,4)
	s:outStDate'="" outStDate=$zd(outStDate,3)
	s outEndDate=$lg(outGlo,5)
	s:outEndDate'="" outEndDate=$zd(outEndDate,3)
	s outLevel=$lg(outGlo,6)
	s outLevelDesc=""
	i outLevel'="" d
	.s outLevelPar=$p(outLevel,"||")
	.s outLevelSub=$p(outLevel,"||",2)
	.s outLevelGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(outLevelPar,outLevelSub))
	.s outLevelDesc=$lg(outLevelGlo,3)
	s outType=$lg(outGlo,7)
	s outTypeDesc=""
	i outType'="" d
	.s outTypePar=$p(outType,"||")
	.s outTypeSub=$p(outType,"||",2)
	.s outTypeGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(outTypePar,outTypeSub))
	.s outTypeDesc=$lg(outTypeGlo,3)
	s outIsSpecial=$lg(outGlo,8)
	s outIsSpecialDesc=$case(outIsSpecial,0:"否",1:"是",:"")
	s outSpecialGroup=$lg(outGlo,9)
	s outSpecialGroupDesc=""
	i outSpecialGroup'="" d
	.s groupPar=$p(outSpecialGroup,"||")
	.s groupSub=$p(outSpecialGroup,"||",2)
	.s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	.s outSpecialGroupDesc=$lg(groupGlo,3)
	s outContent=$lg(outGlo,10)
	s outLocation=$lg(outGlo,11)
	s outScoreType=$lg(outGlo,12)
	s outScoreTypeDesc=""
	i outScoreType'="" d
	.s scoreTypePar=$p(outScoreType,"||")
	.s scoreTypeSub=$p(outScoreType,"||",2)
	.s scoreTypeGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(scoreTypePar,scoreTypeSub))
	.s outScoreTypeDesc=$lg(scoreTypeGlo,3)
	s outScore=$lg(outGlo,13)
	s outUnit=$lg(outGlo,14)
	s outCost=$lg(outGlo,15)
	s creator=$lg(outGlo,16)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(outGlo,17)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(outGlo,18)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="OutWard|"_outWard_"^OutWardDesc|"_outWardDesc_"^OutNurse|"_outNurse_"^OutNurseName|"_outNurseName_"^OutStDate|"_outStDate
	s ret=ret_"^OutEndDate|"_outEndDate_"^OutLevel|"_$tr(outLevel,"|","_")_"^OutLevelDesc|"_outLevelDesc_"^OutType|"_$tr(outType,"|","_")
	s ret=ret_"^OutTypeDesc|"_outTypeDesc_"^OutIsSpecial|"_outIsSpecial_"^OutIsSpecialDesc|"_outIsSpecialDesc_"^OutSpecialGroup|"_$tr(outSpecialGroup,"|","_")
	s ret=ret_"^OutSpecialGroupDesc|"_outSpecialGroupDesc_"^OutContent|"_outContent_"^OutLocation|"_outLocation
	s ret=ret_"^OutScoreType|"_$tr(outScoreType,"|","_")_"^OutScoreTypeDesc|"_outScoreTypeDesc_"^OutScore|"_outScore_"^OutUnit|"_outUnit
	s ret=ret_"^OutCost|"_outCost_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description：获取外出学习列表
/// Date:2020-08-19
/// Creator:wangpf
/// Table:DHCINM.HB.MgOutStudyRec
/// Input: 病区^姓名或工号 登录人Id
/// Output:外出学习列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindOutStudyList","^",0)
Query FindOutStudyList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindOutStudyListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s name=$p(parr,"^",2)
	s level=$p(parr,"^",3)
	s levelList=$lfs(level,",")
	s type=$p(parr,"^",4)
	s typeList=$lfs(type,",")
	s isSpecial=$p(parr,"^",5)
	s isSpecialList=$lfs(isSpecial,",")
	s scoreType=$p(parr,"^",6)
	s scoreTypeList=$lfs(scoreType,",")
	s perId=$p(parr,"^",7)
	s stDate=$p(parr,"^",8)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",9)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s outStDate="" f  s outStDate=$o(^DHCINM.HB.MgOutStudyRecI("ToolIndex",outStDate),-1) q:outStDate=""  d
	.s outWard="" f  s outWard=$o(^DHCINM.HB.MgOutStudyRecI("ToolIndex",outStDate,outWard)) q:outWard=""  d
	..q:((ward'="")&&(ward'=outWard))||((isAll'=1)&&('$d(tmpWard(outWard))))
	..s outLevel="" f  s outLevel=$o(^DHCINM.HB.MgOutStudyRecI("ToolIndex",outStDate,outWard,outLevel)) q:outLevel=""  d
	...s id="" f  s id=$o(^DHCINM.HB.MgOutStudyRecI("ToolIndex",outStDate,outWard,outLevel,id)) q:id=""  d
	....q:'$d(^DHCINM.HB.MgOutStudyRecD(id))
	....s outGlo=^DHCINM.HB.MgOutStudyRecD(id)
	....s outNurse=$lg(outGlo,3)
	....q:(perId'="")&&(perId'=outNurse)
	....s perGlo=$g(^CF.DHCINM.HR.PersonsD(outNurse))
	....s perNameCode=""
	....s:perGlo'="" perNameCode=$zcvt($lg(perGlo,2)_$lg(perGlo,3),"U")
	....q:((name'="")&&(perNameCode'[$zcvt(name,"U")))
	....s outEndDate=$lg(outGlo,5)
	....q:((stDate'="")&&(stDate>outEndDate))||((endDate'="")&&(endDate<outStDate))
	....s outLevel=$lg(outGlo,6)
	....q:(level'="")&&($lf(levelList,outLevel)=0)
	....s outType=$lg(outGlo,7)
	....q:(type'="")&&($lf(typeList,outType)=0)
	....s outIsSpecial=$tr($lg(outGlo,9),"||","__")
	....q:(isSpecial'="")&&($lf(isSpecialList,outIsSpecial)=0)
	....s outScoreType=$lg(outGlo,12)
	....q:(scoreType'="")&&($lf(scoreTypeList,outScoreType)=0)
	....s ret=..GetOutStudy(id)
	....d:ret'="" OutStudyList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutStudyList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOutStudyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOutStudyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOutStudyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOutStudyListExecute ]
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

/// Description: 删除外出学习记录
/// Date: 2020-08-19
/// Creator: wangpf
/// Table: DHCINM.HB.MgOutStudyRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteOutStudy(1)
ClassMethod DeleteOutStudy(id As %String = "") As %String
{
	q:id="" 0
	
	s sc=##class(DHCINM.HB.MgOutStudyRec).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 发布护士长手册说明
/// Date: 2021-10-09
/// Creator: wangpf
/// Table: CT.DHCINM.Set.MgMenu
/// Input: bookid nurseid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).ReleaseDirections(2,0)
ClassMethod ReleaseDirections(id As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) "获取编辑人员信息失败,请刷新重试"
	
	s moduleId=$o(^CT.DHCINM.Set.MgModuleI("Code"," MGNURMANUAL",""))
	q:moduleId="" 0
	s parId=$o(^CT.DHCINM.Set.MgMenuI("Code"," HANDBOOK",""))
	q:parId="" 0
	s obj=##class(CF.DHCINM.HB.HbDirections).%OpenId(id)
	q:'$IsObject(obj) 0
	s code=obj.ItemCode
	s menuId=$o(^CT.DHCINM.Set.MgMenuI("Code"," "_$zcvt(code,"U"),""))
	i menuId="" d
	.s menuObj=##class(CT.DHCINM.Set.MgMenu).%New()
	.s menuObj.MenuCode=code
	.s menuObj.MenuDesc=obj.ItemDesc
	.d menuObj.MenuModuleDRSetObjectId(moduleId)
	.d menuObj.MenuParentDRSetObjectId(parId)
	.s menuObj.MenuRouter=$zcvt(code,"L")
	.s menuObj.MenuParams="type="_code
	.s lastSort=$o(^CT.DHCINM.Set.MgMenuI("ParentSort",parId,""),-1)
	.s menuObj.MenuSort=lastSort+1
	.s menuObj.MenuPath="handbook/BookDirections"
	.s menuObj.IsAdvanced="N"
	e  s menuObj=##class(CT.DHCINM.Set.MgMenu).%OpenId(menuId)
	q:'$IsObject(menuObj) 0
	q:($zcvt(menuObj.MenuModuleDR.ModuleCode,"U")'="MGNURMANUAL")||($zcvt(menuObj.MenuParentDR.MenuCode,"U")'="HANDBOOK") "关联菜单不正确"
	s menuObj.MenuStDate=+$h
	s menuObj.MenuEndDate=""
	s sc=menuObj.%Save()
	q $$$ISOK(sc)
}

/// Creator: LCY
/// CreateDate: 2022-05-30
/// Description: 审核
/// Table: DHCINM.HB.MgRoomCheck
/// Input:
/// Output: 审核成功：1；审核失败：0
/// Return:
/// Other: W ##class(web.INMHBComm).AuditMethod()
ClassMethod AuditMethod(id As %String)
{
	q:'$d(^DHCINM.HB.MgRoomCheckD(id))
	s obj=##class(DHCINM.HB.MgRoomCheck).%OpenId(id,0)
	s obj.CheckStatus="B"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 保存抢救危重病人记录
/// Date: 2020-07-12
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatDangerRec
/// Input: parr 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SavePatDangerRec("1^2021-08-25^17:34:30^17:34:33^4514^男^65岁^15^0000007631^1.脑出血后遗症 确诊 2.继发性癫痫 确诊 3.手术后颅骨缺失 确诊 4.气管造口状态 确诊 5.颅内动脉瘤术后状态 确诊 6.高血压3级 确诊 7.坠积性肺炎 确诊 8.尿道炎 确诊 9.静脉血栓形成 确诊 10.乙肝表面抗原携带者 确诊 11.脑出血后遗症 确诊 12.继发性癫痫 确诊 13.手术后颅骨缺失 确诊 14.气管造口状态 确诊 15.颅内动脉瘤术后状态 确诊 16.高血压3级 确诊 17.坠积性肺炎 确诊 18.尿道炎 确诊 19.静脉血栓形成 确诊 20.乙肝表面抗原携带者 确诊 21.高脂血症 确诊 22.肝功能不全 确诊 23.应激性溃疡 确诊^^N^^W^2021-08-25",4)
ClassMethod SavePatDangerRec(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s date=$p(parr,"^",2)
	s:date["-" date=$zdh(date,3)
	s stTime=$p(parr,"^",3)
	s:stTime[":" stTime=$zth(stTime)
	s endTime=$p(parr,"^",4)
	s:endTime[":" endTime=$zth(endTime)
	s adm=$p(parr,"^",5)
	s sex=$p(parr,"^",6)
	s age=$p(parr,"^",7)
	s bed=$p(parr,"^",8)
	s reg=$p(parr,"^",9)
	s diag=$p(parr,"^",10)
	s result=$p(parr,"^",11)
	s status=$p(parr,"^",12)
	s rw=$p(parr,"^",13)
	s rectype=$p(parr,"^",14)
	s enddate=$p(parr,"^",15)
	s:enddate["-" enddate=$zdh(enddate,3)
	s outadm=$p(parr,"^",16)
	i rw="" d
	.s obj=##class(DHCINM.HB.MgPatDangerRec).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.HB.MgPatDangerRec).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.RescueWardSetObjectId(ward)
	s obj.RescueDate=date
	s obj.RescueStTime=stTime
	s obj.RescueEndTime=endTime
	d obj.RescuePatAdmSetObjectId(adm)
	s obj.RescuePatSex=sex
	s obj.RescuePatAge=age
	s obj.RescuePatBed=bed
	s obj.RescuePatNo=reg
	s obj.RescuePatDiag=diag
	s obj.RescueResult=result
	s obj.RescueStatus=status
	s obj.RescueType=rectype
	s obj.RescueEndDate=enddate
	s obj.RescueOutPatAdm=outadm
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 获取抢救危重病人记录
/// Date: 2020-07-12
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatDangerRec
/// Input: id
/// Output: 科室好人好事记录
/// Other: w ##class(web.INMHBComm).GetPatResRec(1)
ClassMethod GetPatDangerRec(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.HB.MgPatDangerRecD(id))) ""
	
	s resGlo=^DHCINM.HB.MgPatDangerRecD(id)
	s resWard=$lg(resGlo,2)
	s resWardDesc=""
	i resWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(resWard))
	.s resWardDesc=$lg(wardGlo,4)
	s resDate=$lg(resGlo,3)
	s:resDate'="" resDate=$zd(resDate,3)
	s resStTime=$lg(resGlo,4)
	s:resStTime'="" resStTime=$zt(resStTime)
	s resEndTime=$lg(resGlo,5)
	s:resEndTime'="" resEndTime=$zt(resEndTime)
	s resAdm=$lg(resGlo,6)
	s resPatSex=$lg(resGlo,7)
	s resPatAge=$lg(resGlo,8)
	s resPatBed=$lg(resGlo,9)
	s resPatRegNo=$lg(resGlo,10)
	s resPatName=""
	s regId=""
	i resPatRegNo'="" s regId=$o(^PAPERi("PAPMI_PatNo",resPatRegNo,""))
	
	s:regId'="" resPatName=$p(^PAPER(regId,"ALL"),"^",1)
	
	;s regId=$p(^PAADM(resPatRegNo),"^",1)

	;s resPatName=$p(^PAPER(regId,"ALL"),"^",1)
	
	
	s resPatDiag=$lg(resGlo,11)
	s resResult=$lg(resGlo,12)
	s resResultDesc=$case(resResult,"N":"失败","Y":"成功",:"")
	s resStatus=$lg(resGlo,13)
	s resStatusDesc=$case(resStatus,"N":"保存","Y":"提交",:"")
	s creator=$lg(resGlo,14)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(resGlo,15)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(resGlo,16)
	s:createTime'="" createTime=$zt(createTime,1)
	s resType=$lg(resGlo,17)
	s resEndDate=$lg(resGlo,18)
	s:resEndDate'="" resEndDate=$zd(resEndDate,3)
	s resTypeDesc=$case(resType,"Q":"抢救","Z":"病重","W":"病危",:"")
	s resoutAdm=$lg(resGlo,19)
	s ret="RescueWard|"_resWard_"^RescueWardDesc|"_resWardDesc_"^RescueDate|"_resDate_"^RescueStTime|"_resStTime_"^RescueEndTime|"_resEndTime
	s ret=ret_"^RescuePatAdm|"_resAdm_"^RescuePatName|"_resPatName_"^RescuePatSex|"_resPatSex_"^RescuePatAge|"_resPatAge_"^RescuePatBed|"_resPatBed
	s ret=ret_"^RescuePatNo|"_resPatRegNo_"^RescuePatDiag|"_resPatDiag_"^RescueResult|"_resResult_"^RescueResultDesc|"_resResultDesc_"^RescueStatus|"_resStatus
	s ret=ret_"^RescueStatusDesc|"_resStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	s ret=ret_"^RescueOutPatName|"_resoutAdm
	s ret=ret_"^Type|"_resType_"^RescueTypeDesc|"_resTypeDesc_"^RescueEndDate|"_resEndDate
	q ret
}

/// Description：获取抢救危重病人记录列表
/// Date:2020-07-12
/// Creator:wangpf
/// Table:DHCINM.HB.MgPatDangerRec
/// Input: 病区^开始日期^结束日期^状态 登录人Id 登录人角色
/// Output:抢救危重病人记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHBComm","FindPatDangerRecList","^^^",194)
Query FindPatDangerRecList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPatDangerRecListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",4)
	s findtype=$p(parr,"^",5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s resDate="" f  s resDate=$o(^DHCINM.HB.MgPatDangerRecI("ToolIndex",resDate),-1) q:resDate=""  d
	.q:((stDate'="")&&(resDate<stDate))||((endDate'="")&&(resDate>endDate))
	.s resWard="" f  s resWard=$o(^DHCINM.HB.MgPatDangerRecI("ToolIndex",resDate,resWard)) q:resWard=""  d
	..q:((ward'="")&&(ward'=resWard))||((isAll'=1)&&('$d(tmpWard(resWard))))
	..s resStatus="" f  s resStatus=$o(^DHCINM.HB.MgPatDangerRecI("ToolIndex",resDate,resWard,resStatus)) q:resStatus=""  d
	...q:(status'="")&&(status'=$tr(resStatus," ",""))
	...s id="" f  s id=$o(^DHCINM.HB.MgPatDangerRecI("ToolIndex",resDate,resWard,resStatus,id)) q:id=""  d
	....q:'$d(^DHCINM.HB.MgPatDangerRecD(id))
	....s resGlo=^DHCINM.HB.MgPatDangerRecD(id)
	....s restype=$lg(resGlo,17)
	....q:(findtype'="")&&(findtype'=restype)
	....s ret=..GetPatDangerRec(id)
	....d:ret'="" OutResList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutResList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPatDangerRecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatDangerRecListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPatDangerRecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatDangerRecListExecute ]
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

/// Description: 提交抢救危重病人记录
/// Date: 2020-07-12
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatDangerRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).SubmitPatResRec(1)
ClassMethod SubmitPatDangerRec(id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCINM.HB.MgPatDangerRec).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.RescueStatus="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除抢救危重病人记录
/// Date: 2020-07-12
/// Creator: wangpf
/// Table: DHCINM.HB.MgPatDangerRec
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeletePatResRec(1)
ClassMethod DeletePatDangerRec(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.HB.MgPatDangerRec).%DeleteId(id)
	q $$$ISOK(sc)
}

}
