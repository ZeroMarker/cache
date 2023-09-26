/// 用于生成监控结果树
/// 创建者：李阳
/// 创建日期：2011-01-27
Class web.DHCCPW.MR.CtrDetailTree Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/*
ClassMethod GenerateTree(PathVerID)
{
	n (PathVerID)
	s ret=-1
	
	s objVer=##class(User.DHCMRCClinPathWays).%OpenId(VersionID)
	q:objVer="" ret //没有找到指定的路径
	w "[",!
	w "   {",!
	w "      id:'root-0',",!
	w "      ItemName:'临床路径表单', ",!
	w "      icon:'../images/websys/zreports.gif',",!
	w "      expanded: true,",!
    w "      children:[",!
	s EpID="" f  s EpID=$o(^DHCMRC("CPW",objVer.%Id(),"EP",EpID)) q:EpID=""  d
	.s objEp=##class(User.DHCMRCClinPathWaysEp).%OpenId(objVer.%Id()_"||"_EpID)
	.d objEp.%Close()
	.s StepID="" f  s StepID=$o(^DHCMRC("CPW",objVer.%Id(),"EP",EpID,"STEP",StepID)) q:StepID=""  d
	..s objStep=##class(User.DHCMRCClinPathWaysEpStep).%OpenId(objVer.%Id()_"||"_EpID_"||"_StepID)
	..d objStep.%Close()
	..s ToDate=FromDate+objStep.CPWSDay
	..s itemID="" f  s itemID=$o(^DHCMRC("CPW",objVer.%Id(),"EP",EpID,"STEP",StepID,"ITEM",itemID)) q:itemID=""  d
	...s itemRowid=objVer.%Id()_"||"_EpID_"||"_StepID_"||"_itemID
	...s objItm=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(itemRowid)
	...d objItm.%Close()
	...f intCounter=1:1:objItm.CPWSIARCIM.Count()  d
	....s objCPWArcim=objItm.CPWSIARCIM.GetAt(intCounter)
	....s objArcim=##class(web.DHCCPW.Base.Arcim).GetObjById(objCPWArcim.ITMARCIMDR)
	..k objStep
	.k objEp
	w "      ]",!
	w "   }",!
	w "]",!
	q 1
}

/// 查询科室
ClassMethod QueryLoc(repid)
{
	n (repid)
	s ind=1
	s tmpLoc="" f  s tmpLoc=$o(^DHCMRCi("DEPCPW",0,"IndexLoc",tmpLoc)) q:tmpLoc=""  d
	.s locID=$tr(tmpLoc," ","")
	.s loc=$g(^CTLOC(locID))
	.s locName=$p(loc,"^",2)
	.s:locName["-" locName=$p(locName,"-",2)
	.s data=$lb("")
	.s $li(data,1)=locID_"-dep"
	.s $li(data,2)=locName
	.s $li(data,3)="../images/websys/zreports.gif"
	.s $li(data,4)="false"
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	q ind
}

//按科室查询常用临床路径

ClassMethod QueryPathByDep(repid, argLocID)
{
	n (repid,argLocID)
	s ind=1
	Quit:argLocID="" ind
	Quit:'$d(^DHCMRCi("DEPCPW",0,"IndexLoc"," "_argLocID)) ind
	Set ID=0 f  Set ID=$o(^DHCMRCi("DEPCPW",0,"IndexLoc"," "_argLocID,ID)) q:ID=""  d
	.Set objLocPathWay=##Class(User.DHCMRCDeptClinicalPathWays).%OpenId(ID)
	.Do:objLocPathWay'="" objLocPathWay.%Close()
	.i $IsObject(objLocPathWay)  d
	..i $IsObject(objLocPathWay.DCPWCPWDR)  d
	...Set PathWayID=objLocPathWay.DCPWCPWDR.%Id()
	...Set PathWayDesc=objLocPathWay.DCPWCPWDR.CPWDDesc
	...Set IsActive=objLocPathWay.DCPWCPWDR.CPWDActive
	...Set DateFrom=objLocPathWay.DCPWCPWDR.CPWDDateFrom
	...Set DateTo=objLocPathWay.DCPWCPWDR.CPWDDateTo
	...q:IsActive'["Y"
	...q:(IsActive["Y")&&(DateFrom'="")&&(DateFrom>+$h)
	...q:(IsActive["Y")&&(DateTo'="")&&(DateTo<+$h)
	...Set data=$lb("")
	...s $li(data,1)=PathWayID_"-path"
	...s $li(data,2)=PathWayDesc
	...s $li(data,3)="../images/websys/home.gif"
	...s $li(data,4)="false"
	...Set ^CacheTemp(repid,ind)=data
	...Set ind=ind+1
	q ind
}

ClassMethod QueryVerByPathDic(repid, pathDicID)
{
	n (repid,pathDicID)
	s ind=1
	Quit:pathDicID="" ind
	Quit:'$d(^DHCMRC("CPW",0,"IndexPathWayDic",pathDicID)) ind
	s isActive="" f  s isActive=$o(^DHCMRC("CPW",0,"IndexPathWayDic",pathDicID,isActive)) q:isActive=""  d
	.q:isActive="N"
	.s publishDate="" f  s publishDate=$o(^DHCMRC("CPW",0,"IndexPathWayDic",pathDicID,isActive,publishDate),-1) q:publishDate=""  d
	..s publishTime="" f  s publishTime=$o(^DHCMRC("CPW",0,"IndexPathWayDic",pathDicID,isActive,publishDate,publishTime),-1) q:publishTime=""  d
	...s ID="" f  Set ID=$o(^DHCMRC("CPW",0,"IndexPathWayDic",pathDicID,isActive,publishDate,publishTime,ID),-1) q:ID=""  d
	....Set objVer=##Class(User.DHCMRCClinPathWays).%OpenId(ID)
	....Do:objVer'="" objVer.%Close()
	....i $IsObject(objVer)  d
	.....s version=objVer.CPWVersion
	....S DateFrom=objVer.CPWDateFrom
	....S DateTo=objVer.CPWDateTo
	....s desc="ver."_version_"  "
	....s imgPath="../images/websys/edit_green.gif"
	....i publishDate<0   d
	.....s desc=desc_"未发布"
	.....s imgPath="../images/websys/edit_orange.gif"
	....e  d
	.....s desc=desc_" "_$zd(publishDate,3)
	....i isActive="N"
	.....s imgPath="../images/websys/delete_large.gif"
	....i objVer.CPWCPWDicDR.CPWDVersion=objVer.%Id()  d
	.....s imgPath="../images/websys/lookup_1.gif"
	....Set data=$lb("")
	....s $li(data,1)=objVer.%Id()_"-ver-"_(publishDate>0)
	....s $li(data,2)=desc
	....s $li(data,3)=imgPath
	....s $li(data,4)="true"
	....Set ^CacheTemp(repid,ind)=data
	....Set ind=ind+1
	q ind
}

ClassMethod QueryCate(repid, id)
{
	n (repid,id)
	s ind=1
	s rowid="" f  s rowid=$o(^DHCMRC("SIC",rowid)) q:rowid=""  d
	.s objCate=##class(User.DHCMRCStepItemCategory).%OpenId(rowid)
	.i $IsObject(objCate)  d
	..d objCate.%Close()
	..s desc=objCate.SICDesc
	..s data=$lb("")
	..s $li(data,1)=id_"-Cate-"_rowid
	..s $li(data,2)=desc
	..s $li(data,3)="../images/websys/edit.gif"
	..s $li(data,4)="false"
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1	
	..s objCate=""
	..k objCate
	q ind
}

ClassMethod QueryContentByPath(repid, PathID)
{
	n (repid,PathID)
	s ind=1
	s rowid="" f  s rowid=$o(^DHCMRC("CPW",PathID,"EP",rowid)) q:rowid=""  d
	.s objEP=##class(User.DHCMRCClinPathWaysEp).%OpenId(PathID_"||"_rowid)
	.Do:objEP'="" objEP.%Close()
	.i $IsObject(objEP)  d
	..s desc=objEP.EPDesc
	..s imgPath="../images/websys/zreports.gif"
	..s data=$lb("")
	..s $li(data,1)=PathID_"||"_rowid_"-EP"
	..s $li(data,2)=desc
	..s $li(data,3)=imgPath
	..s $li(data,4)="false"
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1
	..d objEP.%Close()
	..k objEP
	q ind
}

ClassMethod QueryStepByEP(repid, ParentID)
{
	n (repid,ParentID)
	s ind=1
	s PathID=$p(ParentID,"||",1)
	s EpID=$p(ParentID,"||",2)
	s rowid="" f  s rowid=$o(^DHCMRC("CPW",PathID,"EP",EpID,"STEP",rowid)) q:rowid=""  d
	.s objStep=##class(User.DHCMRCClinPathWaysEpStep).%OpenId(ParentID_"||"_rowid)
	.Do:objStep'="" objStep.%Close()
	.i $IsObject(objStep)  d
	..s desc=objStep.CPWSDesc
	..s imgPath="../images/websys/report.gif"
	..s data=$lb("")
	..s $li(data,1)=ParentID_"||"_rowid_"-STEP"
	..s $li(data,2)=desc
	..s $li(data,3)=imgPath
	..s $li(data,4)="false"
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1
	..d objStep.%Close()
	..k objStep
	q ind
}

ClassMethod QueryStepItemByStep(repid, ParentID, CateID)
{
	n (repid,ParentID,CateID)
	s ind=1
	s PathID=$p(ParentID,"||",1)
	s EpID=$p(ParentID,"||",2)
	s StepID=$p(ParentID,"||",3)
	s rowid="" f  s rowid=$o(^DHCMRC("CPW",PathID,"EP",EpID,"STEP",StepID,"ITEM",rowid)) q:rowid=""  d
	.s objItem=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(ParentID_"||"_rowid)
	.Do:objItem'="" objItem.%Close()
	.i $IsObject(objItem)  d
	..i objItem.CPWSISubCategory.SISCParRef.%Id()=CateID  d
	...s desc=objItem.CPWSIDesc
	...s imgPath="../images/websys/new.gif"
	...s data=$lb("")
	...s $li(data,1)=ParentID_"||"_rowid_"-ITEM"
	...s $li(data,2)=objItem.%Id()_" "_desc
	...s $li(data,3)=imgPath
	...s $li(data,4)="true"
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1
	...d objItem.%Close()
	...k objItem
	q ind
}

/// 处理科室、常用临床路径、版本的三级查询
Query QryLocPathVer(ID As %String, Loc As %String, GroupID As %String) As %Query(ROWSPEC = "id:%String,text:%String,icon:%String,leaf:%String")
{
}

ClassMethod QryLocPathVerExecute(ByRef qHandle As %Binary, ID As %String, Loc As %String, GroupID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	s type=$p(ID,"-",2)
	s:type="root" ind=..QueryLoc(repid)
	s:type="dep" ind=..QueryPathByDep(repid,+ID)
	;s:type="path" ind=..QueryVerByPathDic(repid,+ID)
	Quit $$$OK
}

ClassMethod QryLocPathVerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocPathVerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocPathVerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocPathVerExecute ]
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

/// 查询临床路径内容
Query QryPathContent(ID As %String) As %Query(ROWSPEC = "id:%String,text:%String,icon:%String,leaf:%String")
{
}

ClassMethod QryPathContentExecute(ByRef qHandle As %Binary, ID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	s type=$p(ID,"-",2)
	s:type="ver" ind=..QueryContentByPath(repid,$p(ID,"-",1))
	s:type="EP" ind=..QueryStepByEP(repid,$p(ID,"-",1))
	s:type="STEP" ind=..QueryCate(repid,$p(ID,"-",1))
	s:type="Cate" ind=..QueryStepItemByStep(repid,$p(ID,"-",1),$p(ID,"-",3))
	Quit $$$OK
}

ClassMethod QryPathContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathContentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathContentExecute ]
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

Query QueryStepItem(StepID As %String) As %Query(ROWSPEC = "TypeCode:%String,TypeName:%String:类别,StepItemID:%String,StepItemName:%String:步骤名称,OrderRuleIndex:%String,OrderRuleName:%String:医嘱名称,OrderRuleNumber:%String:要求数量,ActualNumber:%String:实际完成数量,IsComplete:%String:是否完成,IsDateCorrect:%String:是否时间准确,IsNumberCorrect:%String:数量是否合适")
{
}

ClassMethod QueryStepItemExecute(ByRef qHandle As %Binary, StepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	s verID=$p(StepID,"||",1)
	s EpID=$p(StepID,"||",2)
	s StepID=$p(StepID,"||",3)
	s itemID="" f  s itemID=$o(^DHCMRC("CPW",verID,"EP",EpID,"STEP",StepID,"ITEM",itemID)) q:itemID=""  d
	.s itemRowid=objVer.%Id()_"||"_EpID_"||"_StepID_"||"_itemID
	.s objItm=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(itemRowid)
	.d objItm.%Close()
	.f intCounter=1:1:objItm.CPWSIARCIM.Count()  d
	..s objCPWArcim=objItm.CPWSIARCIM.GetAt(intCounter)
	..s objArcim=##class(web.DHCCPW.Base.Arcim).GetObjById(objCPWArcim.ITMARCIMDR)
		
	Quit $$$OK
BuildQueryStepItemExecute(param)
	s data=$lb("")
	s $li(data,1)=TypeCode //TypeCode:%String
	s $li(data,2)=TypeName //:%String:类别
	s $li(data,3)=objItm.%Id() //StepItemID:%String
	s $li(data,4)=objItm.CPWSIDesc_"  "_StepItem.CPWSICheckDesc  //StepItemName:%String:步骤名称
	s $li(data,5)=intCounter //OrderRuleIndex:%String
	s $li(data,6)=objArcim.ARCIMDesc  //OrderRuleName:%String:医嘱名称
	//s $li(data,7)=objCPWArcim. ///OrderRuleNumber:%String:要求数量
	//ActualNumber:%String:实际完成数量
	//IsComplete:%String:是否完成
	//IsDateCorrect:%String:是否时间准确
	//IsNumberCorrect:%String:数量是否合适
	q data
}

ClassMethod QueryStepItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStepItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryStepItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStepItemExecute ]
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
*/
}
