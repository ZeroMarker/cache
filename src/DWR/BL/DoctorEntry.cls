Class DWR.BL.DoctorEntry Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DWR.BL.DoctorEntry).GetOecpr(Param)
ClassMethod GetOecpr(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>doct</userCode></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	s oecprId=""
	f  s oecprId=$O(^OECPR(oecprId))  q:oecprId=""  d
	.s oecprDesc=$P(^OECPR(oecprId),"^",2)
	.q:oecprDesc=""
	.s myObj=##class(DWR.MSG.Priority).%New()
	.s myObj.oecprId=oecprId
	.s myObj.oecprDesc=oecprDesc
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml	
	q retStr
}

/// w ##Class(DWR.BL.DoctorEntry).GetFrequency(Param)
ClassMethod GetFrequency(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>doct</userCode></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
    s freqId="" 
    f  s freqId=$O(^PHCFR(freqId))  q:freqId=""  d
    .q:+freqId=0
    .s freqDesc=$P(^PHCFR(freqId),"^",1)
 	.q:freqDesc=""
 	.s medFlag=$P(^PHCFR(freqId),"^",4)
 	.q:medFlag="饮片"
	.s myObj=##class(DWR.MSG.Frequency).%New()
	.s myObj.freqId=freqId
	.s myObj.freqDesc=freqDesc
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml	
	q retStr
}

/// w ##Class(DWR.BL.DoctorEntry).GetFrequency(Param)
ClassMethod GetInstruction(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>doct</userCode></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
    s instructId="" 
    f  s instructId=$O(^PHCIN(instructId))  q:instructId=""  d
    .q:+instructId=0
    .s instructDesc=$P(^PHCIN(instructId),"^",2)
 	.q:instructDesc=""
	.s myObj=##class(DWR.MSG.Instruction).%New()
	.s myObj.instructId=instructId
	.s myObj.instructDesc=instructDesc
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml	
	q retStr
}

/// w ##Class(DWR.BL.DoctorEntry).GetSkinAction(Param)
ClassMethod GetSkinAction(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>doct</userCode></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
    s actionId="" 
    f  s actionId=$O(^OEC("ACT",actionId))  q:actionId=""  d
    .q:+actionId=0
    .s actionDesc=$P(^OEC("ACT",actionId),"^",2)
 	.q:actionDesc=""
	.s myObj=##class(DWR.MSG.SkinAction).%New()
	.s myObj.actionId=actionId
	.s myObj.actionDesc=actionDesc
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml	
	q retStr
}

/// w ##Class(DWR.BL.DoctorEntry).GetArcimItem(Param)
ClassMethod GetArcimItem(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>030414</userCode><itemCode>PTT</itemCode><admId>426793</admId><departmentId>336</departmentId><groupId>203</groupId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s itemCode=request.itemCode
	   s itemCode=$TR(itemCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s groupId=request.groupId
	   s groupId=$TR(groupId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(itemCode)="" "202^医嘱项目别名不能为空!"
	q:$G(admId)="" "203^就诊Id不能为空!"
	q:$G(groupId)="" "204^安全组Id不能为空!"
	q:$G(departmentId)="" "205^科室Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	
    s queryName="web.DHCDocOrderEntry:LookUpItem"
    s resSet = ##class(%ResultSet).%New(queryName)
    s columns = resSet.GetColumnCount()
    s sc = resSet.Execute(itemCode,groupId,"","","","","",admId,"","",userId,"","",departmentId,"")
    q:sc=0 "206^查询失败!"
   	s showIndex=0
   	While (resSet.Next()) {
	   	if showIndex>50  q
		s myObj=##class(DWR.MSG.ArcimItem).%New()
		s showIndex=showIndex+1
		s myObj.showIndex=showIndex
		s arcimId=resSet.GetData(2)
		s myObj.arcimId=arcimId
		//Continue:$P(arcimId,"||",2)=""  //暂时屏蔽医嘱套
		s arcimcode=resSet.GetData(30)
		s myObj.arcimcode=arcimcode
		s arcimDesc=resSet.GetData(1)
		s myObj.arcimDesc=arcimDesc
		s freqCode=resSet.GetData(3)
		s myObj.freqCode=freqCode
		s phUomDesc=resSet.GetData(12)
		s myObj.phUomDesc=phUomDesc
		s subCatDesc=resSet.GetData(18)
		s myObj.subCatDesc=subCatDesc
		s itemPrice=resSet.GetData(19)
		s myObj.itemPrice=itemPrice
		s billUom=resSet.GetData(20)
		s myObj.billUom=billUom
		s stockQty=resSet.GetData(22)
		s myObj.stockQty=stockQty
		s recLoc=resSet.GetData(29)
		s myObj.recLoc=recLoc
		s Xml=""
		s ret=myObj.XMLExportToString(.Xml)
		i ret=1 s retStr=retStr_Xml
 	}
 	q retStr
}

/// 取医嘱模板的一级页签
/// w ##Class(DWR.BL.DoctorEntry).GetOETabs(Param)
ClassMethod GetOETabs(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>030414</userCode><admId>426793</admId><departmentId>336</departmentId><groupId>203</groupId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s groupId=request.groupId
	   s groupId=$TR(groupId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(groupId)="" "203^安全组Id不能为空!"
	q:$G(departmentId)="" "204^科室Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s mainTabsId=..GetMianTabsId(userId,departmentId,groupId)
	q:mainTabsId="" "205^没有医嘱模板信息!"
	s tabObj=##class(websys.Preferences).%OpenId(mainTabsId)
	q:tabObj="" "206^医嘱模板不存在页签!"
	s prefContent = tabObj.Data
	s tabsList=$LIST(prefContent,3)
	f tabId=1:1:$LL(tabsList) d
	.s tabOne=$LIST(tabsList,tabId)
	.s tabName=$p(tabOne,$C(1),1)
	.q:tabName=""	
	.s myObj=##class(DWR.MSG.OETabs).%New()
	.s myObj.tabId=tabId
	.s myObj.tabName=tabName
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml
 	q retStr
}

/// 取医嘱模板Id
ClassMethod GetMianTabsId(userId As %String = "", locId As %String = "", groupId As %String = "") As %String
{
	s preferId=""
	s subKey="OEOrder.PrefTabs.EditList"
	s appKey="ORDERW50008"
	s objTypeOrd="ORDER"
	s objTypeUser="User.SSUser"
	s objTypeLoc="User.CTLoc"
	s objTypeGroup="User.SSGroup"
	i userId'="" d
	.&sql(select ID into:preferId from websys.Preferences where AppKey=:appKey and AppSubKey=:subKey and ObjectType=:objTypeUser and ObjectReference=:userId)
	.i (preferId="") d
	..&sql(select max(ID) into:preferId from websys.Preferences where AppSubKey=:subKey and ObjectType=:objTypeUser and ObjectReference=:userId)
	i (preferId="")&&(locId'="") d
	.&sql(select ID into:preferId from websys.Preferences where AppKey=:appKey and AppSubKey=:subKey and ObjectType=:objTypeLoc and ObjectReference=:locId)
	.i (preferId="") d
	..&sql(select max(ID) into:preferId from websys.Preferences where AppSubKey=:subKey and ObjectType=:objTypeLoc and ObjectReference=:locId)
	i (preferId="")&&(groupId'="") d
	.&sql(select ID into:preferId from websys.Preferences where AppKey=:appKey and AppSubKey=:subKey and ObjectType=:objTypeGroup and ObjectReference=:groupId)
    .i (preferId="") d
	..&sql(select max(ID) into:preferId from websys.Preferences where AppSubKey=:subKey and ObjectType=:objTypeGroup and ObjectReference=:groupId)
	q preferId
}

/// 取医嘱模板二级页签
/// w ##Class(DWR.BL.DoctorEntry).GetOESubTabs(Param)
ClassMethod GetOESubTabs(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><tabId>2</tabId><userCode>030414</userCode><admId>426793</admId><departmentId>336</departmentId><groupId>203</groupId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s groupId=request.groupId
	   s groupId=$TR(groupId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	   s tabId=request.tabId
	   s tabId=$TR(tabId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(groupId)="" "203^安全组Id不能为空!"
	q:$G(departmentId)="" "204^科室Id不能为空!"
	q:$G(tabId)="" "205^请选择查看的页签"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s mainTabsId=..GetMianTabsId(userId,departmentId,groupId)
	q:mainTabsId="" "206^没有医嘱模板信息!"
	s tabObj=##class(websys.Preferences).%OpenId(mainTabsId)
	q:tabObj="" "207^医嘱模板不存在页签!"
	s prefContent = tabObj.Data
	s tabsList=$LIST(prefContent,3)
	s tabOne=$LIST(tabsList,tabId)
	q:tabOne="" "208^医嘱模板页签内容为空!"
	f subTabIndex=2:1:$L(tabOne,$C(1)) d
	.s subTabContent=$P(tabOne,$C(1),subTabIndex)
	.//q:subTabContent'["ARCIM"
	.q:$L(subTabContent,$C(28))<2
	.s subTabName=$P(subTabContent,$C(28),1)
	.q:subTabName=""
	.s subTabId=subTabIndex-1
	.s myObj=##class(DWR.MSG.OETabs).%New()
	.s myObj.subTabId=subTabId
	.s myObj.subTabName=subTabName
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml
 	q retStr
}

/// 取医嘱模板医嘱项目
/// w ##Class(DWR.BL.DoctorEntry).GetOETabItem(Param)
ClassMethod GetOETabItem(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><subTabId>1</subTabId><tabId>1</tabId><userCode>030414</userCode><admId>426793</admId><departmentId>336</departmentId><groupId>203</groupId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s groupId=request.groupId
	   s groupId=$TR(groupId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	   s tabId=request.tabId
	   s tabId=$TR(tabId,$C(0))
	   s subTabId=request.subTabId
	   s subTabId=$TR(subTabId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(groupId)="" "203^安全组Id不能为空!"
	q:$G(departmentId)="" "204^科室Id不能为空!"
	q:$G(tabId)="" "205^请选择查看的页签"
	q:$G(subTabId)="" "206^请选择查看的二级页签"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s mainTabsId=..GetMianTabsId(userId,departmentId,groupId)
	q:mainTabsId="" "207^没有医嘱模板信息!"
	s tabObj=##class(websys.Preferences).%OpenId(mainTabsId)
	q:tabObj="" "208^医嘱模板不存在页签!"
	s prefContent = tabObj.Data
	s tabsList=$LIST(prefContent,3)
	s tabOne=$LIST(tabsList,tabId)
	q:tabOne="" "209^医嘱模板页签内容为空!"
	s subTabOne=$P(tabOne,$C(1),subTabId+1)
	s tabArcLen=$L(subTabOne,$C(28))
	f arcIndex=2:1:tabArcLen d
	.s tabArcOne=$P(subTabOne,$C(28),arcIndex)
	.s arcType=$P(tabArcOne,$C(4))
	.s arcRowId=$P(tabArcOne,$C(4),2)
	.q:arcRowId=""
	.s arcId=$P(arcRowId,"||")
	.s arcVserion=+$P(arcRowId,"||",2)
	.//q:(arcId="")||(arcVserion="")
	.s arcQty=1
	.s arcStr="",arcDesc=""
	.i (arcType="ARCIM") d
	..s arcSubCatId=$P(^ARCIM(arcId,arcVserion,1),"^",10)
	..q:arcSubCatId=""
	..s ordType=$P(^ARC("IC",arcSubCatId),"^",7)
	..i ordType="R" s arcQty=##Class(web.DHCDocOrderEntry).GetStockQty(admId,arcRowId)
	..i arcQty>0 s arcQty=1
	.i (arcType="ARCIM") d
	..q:$G(^ARCIM(arcId,arcVserion,1))=""
	..s arcDesc=$P($G(^ARCIM(arcId,arcVserion,1)),"^",2)
	.i (arcType="ARCOS") d
	..q:$G(^ARCOS(arcRowId))=""
	..s arcOSDate=##class(web.DHCDocOrderEntry).GetOrderSetDate(arcRowId)
    ..s resSet=##class(%ResultSet).%New("DWR.BL.DoctorEntry:FindOSItems")
    ..s sc=resSet.Execute(arcRowId)
    ..q:sc=0
    ..q:(resSet.Next()=0)
    ..s arcDesc=$P(^ARCOS(arcRowId),"^",2)
	.//q:(arcType="ARCOS")&&((+$G(arcOSDate))=0)
	.//q:(arcType="ARCOS") ///暂时不处理医嘱套
	.q:arcDesc=""
	.s myObj=##class(DWR.MSG.OETabs).%New()
	.s myObj.arcRowId=arcRowId
	.s myObj.arcDesc=arcDesc
	.s myObj.arcQty=arcQty
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml
 	q retStr
}

ClassMethod GetArcimRecLoc(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>030414</userCode><arcItemId>777||1</arcItemId><admId>426793</admId><departmentId>336</departmentId><groupId>203</groupId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s arcItemId=request.arcItemId
	   s arcItemId=$TR(arcItemId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(arcItemId)="" "202^医嘱项目不能为空!"
	q:$G(admId)="" "203^就诊Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	
    s queryName="web.DHCOPItemMast:AIMRecLoc"
    s resSet = ##class(%ResultSet).%New(queryName)
    s sc = resSet.Execute(admId,arcItemId)
    q:sc=0 "206^查询失败!"
   	s showIndex=0
   	While (resSet.Next()) {
	   	if showIndex>50  q
		s myObj=##class(DWR.MSG.DepartmentInfo).%New()
		s departmentId=resSet.GetData(2)
		s myObj.departmentId=departmentId
		s departmentName=resSet.GetData(1)
		i $P(departmentName,"-",2)'="" s departmentName=$P(departmentName,"-",2)
		s myObj.departmentName=departmentName
		s defaultFlag=resSet.GetData(3)
		s myObj.defaultFlag=defaultFlag
		s Xml=""
		s ret=myObj.XMLExportToString(.Xml)
		i ret=1 s retStr=retStr_Xml
 	}
 	q retStr
}

/// w ##Class(DWR.BL.DoctorEntry).InsertOSItems("DOCTOR",426803,1080)
ClassMethod InsertOSItems(userCode As %String = "", admId As %String = "", arcOSRowId As %String = "", departmentId As %String = "") As %String
{
	//s queryName="web.DHCDocOrderCommon:FindOSItems"
	s queryName="DWR.BL.DoctorEntry:FindOSItems"
    s resSet=##class(%ResultSet).%New(queryName)
    s sc = resSet.Execute(arcOSRowId)
    s startParam="<Request><userCode>"_userCode_"</userCode><admId>"_admId_"</admId>"  //"<departmentId>"_departmentId_"</departmentId>"
	s endParam="</Request>"
    q:sc=0 "206^查询医嘱套失败!"
    //q:resSet.Next()=0 "206^查询医嘱套失败!"
   	s showIndex=0
   	While (resSet.Next()) {
	   	if showIndex>50  q
		s myObj=##class(DWR.MSG.DepartmentInfo).%New()
		//s arcItemId=resSet.GetData(10)
		s arcItemId=resSet.GetDataByName("ItemRowid")
		//s itemData=resSet.GetData(9)
		s itemData=resSet.GetDataByName("ItemData")
		s priorData=$P(itemData,"^",6)
		s priorId=$P(priorData,$C(1),2)
		s doseData=$P(itemData,"^",1)
		s doseQty=$P(doseData,$C(1),1)
		s doseUomId=$P(doseData,$C(1),3)
		s freqStr=$P(itemData,"^",2)
		s freqId=$P(freqStr,$C(1),2)
		s instr=$P(itemData,"^",3)
		s instrId=$P(instr,$C(1),2)
		//s packQty=resSet.GetData(2)
		s packQty=resSet.GetDataByName("ItemQty")
		//s ordNote=resSet.GetData(14)
		s ordNote=resSet.GetDataByName("ItemRemark")
		//s osSeqNo=resSet.GetData(19)
		s osSeqNo=resSet.GetDataByName("ItemSeqNo")
		s recLocId=""
		///s arcDetail=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(admId, "", departmentId,arcItemId)
		s arcDetail=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(admId, "","",arcItemId)
		i priorId="" d
		.s ordPriorList=$P(arcDetail,"^",16)
		.i ordPriorList'="" d
		..s priorId=$p(ordPriorList,$C(1),2)
		i +priorId=0 s priorId=3
		i doseQty="" d
		.s doseQtyList=$P(arcDetail,"^",12)
		.i (doseQtyList'="") d
		..f doseQtyIndex=1:1:$L(doseQtyList,$C(2)) q:doseQty'=""  d
		...s doseQtyOne=$P(doseQtyList,$C(2),doseQtyIndex)
		...q:doseQtyOne=""
		...s doseQty=$P(doseQtyOne,$C(1),1)
		...s doseUomId=$P(doseQtyOne,$C(1),3)
		i freqId="" d
		.s ordFreqList=$P(arcDetail,"^",13)
		.q:ordFreqList=""
		.s freqId=$P(ordFreqList,$C(1),2)
		i instrId="" d
		.s ordInstrList=$P(arcDetail,"^",14)
		.q:ordInstrList=""
		.s instrId=$P(ordInstrList,$C(1),2)
		s recLocList=$P(arcDetail,"^",10)
		f recLocIndex=1:1:$L(recLocList,$C(2)) d
		.s recLocStr=$P(recLocList,$C(2),recLocIndex)
		.q:recLocStr=""
		.s locId=$P(recLocStr,$C(1),1)
		.s locDesc=$P(recLocStr,$C(1),2)
		.s defaultFlag=$P(recLocStr,$C(1),3)
		.i defaultFlag="Y" s recLocId=locId
		s ordParam="<arcItemId>"_arcItemId_"</arcItemId><priorId>"_priorId_"</priorId>"
		s ordParam=ordParam_"<recLocId>"_recLocId_"</recLocId><doseQty>"_doseQty_"</doseQty>"
		s ordParam=ordParam_"<doseUomId>"_doseUomId_"</doseUomId><freqId>"_freqId_"</freqId>"
		s ordParam=ordParam_"<instrId>"_instrId_"</instrId><packQty>"_packQty_"</packQty><ordNote>"_ordNote_"</ordNote>"
		i $L(osSeqNo,".")>1 d
		.s masterSeqNo=$G(arcOSTemp($P(osSeqNo,".")))
		.q:masterSeqNo=""
		.s ordParam=ordParam_"<masterSeqNo>"_masterSeqNo_"</masterSeqNo>"
		i ordParam'="" d
		.s saveRet=##Class(DWR.BL.DoctorEntry).SaveTempOrdItem(startParam_ordParam_endParam)
		.i +saveRet=0 d
		..s tempMastNo=$G(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId))
		..q:osSeqNo=""
		..s arcOSTemp(osSeqNo)=tempMastNo
 	}
	q ""
}

/// 获取医嘱项信息
/// w ##Class(DWR.BL.DoctorEntry).GetArcimDetail(Param)
ClassMethod GetArcimDetail(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>030414</userCode><arcItemId>10343||1</arcItemId><admId>426793</admId><departmentId>336</departmentId></Request>"
	///Lab   ///青霉素 11294||1
	i Param="" s Param="<Request><userCode>030414</userCode><arcItemId>10946||1</arcItemId><admId>426793</admId><departmentId>336</departmentId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s arcItemId=request.arcItemId
	   s arcItemId=$TR(arcItemId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(arcItemId)="" "203^医嘱项Id不能为空!"
	s mainDoctorId=$P($G(^PAADM(admId)),"^",9)
	//q:($G(^DHCDocConfig("IPNeedDoctor"))=1)&&(mainDoctorId="") "204^患者未指定主管不能开医嘱!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s isOSItem=0
	i $P(arcItemId,"||",2)="" d
	.s insertOSItem=##Class(DWR.BL.DoctorEntry).InsertOSItems(userCode,admId,arcItemId,departmentId)
	.s isOSItem=1
	q:isOSItem=1 ""
	//s arcDetail=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(admId, "", departmentId,arcItemId)
	s arcDetail=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(admId, "", "",arcItemId)
	s arcimDesc=$P(arcDetail,"^",1)
	s arcimDesc=$TR(arcimDesc,$C(1))
	s arcObj=##class(DWR.MSG.ArcimItem).%New()
	s arcObj.arcimDesc=arcimDesc
	s arcObj.arcimId=arcItemId
	s ordType=$P(arcDetail,"^",2)
	s arcObj.arcType=ordType
	s ordBillType=$P(arcDetail,"^",7)
	s ordPrice=$P(arcDetail,"^",8)
	i ordPrice'="" d
	.s ordPrice=$P(ordPrice,$C(1),1)
	.s arcObj.itemPrice=ordPrice
	s ordPriceUom=$P(arcDetail,"^",9)
	i ordPriceUom'="" d
	.s packQty=$P(ordPriceUom,$C(1),1)
	.s arcObj.packQty=packQty
	.s priceUom=$P(ordPriceUom,$C(1),2)
	.s priceUomId=$P(ordPriceUom,$C(1),3)
	.s arcObj.billUom=$G(priceUom)
	
	s recLocList=$P(arcDetail,"^",10)
	f recLocIndex=1:1:$L(recLocList,$C(2)) d
	.s recLocStr=$P(recLocList,$C(2),recLocIndex)
	.q:recLocStr=""
	.s locId=$P(recLocStr,$C(1),1)
	.s locDesc=$P(recLocStr,$C(1),2)
	.s defaultFlag=$P(recLocStr,$C(1),3)
	.s deptObj=##class(DWR.MSG.DepartmentInfo).%New()
	.s deptObj.locId=locId
	.s deptObj.locDesc=locDesc
	.s deptObj.defaultFlag=defaultFlag
	.i defaultFlag="Y" s recLocId=locId
	.d deptObj.%Close()
	.d arcObj.recLocList.Insert(deptObj)
	s phFromStr=$P(arcDetail,"^",11)
	i phFromStr'="" d
	.s phFromId=$P(phFromStr,$C(1),2)
	.s arcObj.phFromId=phFromId
	s doseQtyList=$P(arcDetail,"^",12)
	i (doseQtyList'="")&&(ordType="R") d
	.f doseQtyIndex=1:1:$L(doseQtyList,$C(2)) d
	..s doseQtyOne=$P(doseQtyList,$C(2),doseQtyIndex)
	..q:doseQtyOne=""
	..s doseQty=$P(doseQtyOne,$C(1),1)
	..s doseUomDesc=$P(doseQtyOne,$C(1),2)
	..s doseUomId=$P(doseQtyOne,$C(1),3)
	..s doseObj=##class(DWR.MSG.DoseQtyInfo).%New()
	..s doseObj.doseQty=doseQty
	..s doseObj.doseUomDesc=doseUomDesc
	..s doseObj.doseUomId=doseUomId
	..i doseQtyIndex=1 d
	...s doseObj.defaultFlag="Y"
	...s defDoseQty=doseQty
	...s defDoseUomId=doseUomId
	..e  s doseObj.defaultFlag="N"
	..d doseObj.%Close()
	..d arcObj.doseQtyList.Insert(doseObj)
	s ordFreqList=$P(arcDetail,"^",13)
	i ordFreqList'="" d
	.s ordFreq=$P(ordFreqList,$C(1),1)
	.s ordFreqId=$P(ordFreqList,$C(1),2)
	.s arcObj.freqCode=ordFreq
	.s arcObj.freqId=ordFreqId
	s ordInstrList=$P(arcDetail,"^",14)
	i ordInstrList'="" d
	.s instructDesc=$P(ordInstrList,$C(1),1)
	.s instructId=$P(ordInstrList,$C(1),2)
	.s arcObj.instrId=instructId
	.s arcObj.instrCode=instructDesc
	s ordPriorList=$P(arcDetail,"^",16)
	i ordPriorList'="" d
	.s priorDesc=$p(ordPriorList,$C(1),1)
	.s priorId=$p(ordPriorList,$C(1),2)
	.q:priorId=""
	.s arcObj.priorId=priorId
	.s arcObj.priorDesc=priorDesc
	.s priorCode=$P(^OECPR(priorId),"^",1)
	.i priorCode="STAT" d
	..s freqId=$O(^PHCFR(0,"Code","ST",""))
	..q:freqId=""
	..s freqCode=$P($G(^PHCFR(freqId)),"^",1)
	..s arcObj.freqCode=freqCode
	..s arcObj.freqId=freqId
	.i priorCode="NORM" d
	..s freqId=$O(^PHCFR(0,"Code","ONCE",""))
	..q:freqId=""
	..s freqCode=$P($G(^PHCFR(freqId)),"^",1)
	..s arcObj.freqCode=freqCode
	..s arcObj.freqId=freqId	
	s ordMsg=$P(arcDetail,"^",17)
	s ordMsg=$TR(ordMsg,$C(1))
	i ordMsg'="" s arcObj.arcMsg=ordMsg
	s labSpecList=$P(arcDetail,"^",19)
	i (ordType="L")&&(labSpecList'="") d
	.s labSpec=$P(labSpecList,$C(3),2)
	.s labSpecCode=$P(labSpecList,$C(3),1)
	.s labContCode=$P(labSpecList,$C(3),3)
	.s labCont=$P(labSpecList,$C(3),4)
	.//s labObj=##class(DWR.MSG.LabSpecInfo).%New()
	.s arcObj.labSpec=labSpec
	.s arcObj.labSpecCode=labSpecCode
	.s arcObj.labContCode=labContCode
	.s arcObj.labCont=labCont
	.//d labObj.%Close()
	.//d arcObj.labSpecList.Insert(labObj)
	s arcObj.needSkin="N"
	s needSkinStr=$P(arcDetail,"^",20)
	i needSkinStr'="" d
	.s needSkinTest=$P(needSkinStr,$C(1),1)
	.q:needSkinTest=""
	.s arcObj.needSkin=needSkinTest
	.q:needSkinTest="N"
	.s skinActId=$P(needSkinStr,$C(1),2)
	.i skinActId="" s skinActId=$O(^OEC("ACT",0))
	.s arcObj.skinActId=skinActId
	.q:skinActId=""
	.s skinAct=$P(^OEC("ACT",skinActId),"^",2)
	.s arcObj.skinAct=skinAct
	s limitList=$P(arcDetail,"^",22)
	//s arcObj.isAntib=##class(web.DHCOEOrdItem).Antibiotics(arcItemId) //1 为抗生素   治疗 1；预防 2
	s arcObj.isAntib=..Antibiotics(arcItemId) //1 为抗生素   治疗 1；预防 2
	s hospCode=""
	s hospId=$O(^CT("HOSP",0))
	i hospId'="" s hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
	i $G(priorId)'="" d
	.s oecprCode=$P(^OECPR(priorId),"^",1)
	.q:($G(oecprCode)="S")||($G(freqCode)="OMST")
	.s itemCatDr=$P($G(^ARCIM(+arcItemId,$P(arcItemId,"||",2),1)),"^",10)
	.q:itemCatDr=""
	.q:($G(recLocId)="")||($G(freqId)="")||($G(defDoseQty)="")||($G(defDoseUomId)="")
	.s isNeedBillQty=##class(web.DHCDocOrderCommon).GetNeedPackQtyFlag(recLocId,itemCatDr)
	.q:((+isNeedBillQty=0)||(isNeedBillQty="N"))&&(hospCode'="WHSDYYY")
	.s packQty=..CalPackQty(arcItemId,freqId,defDoseQty,defDoseUomId)
	.s arcObj.packQty=packQty
	
	i $G(priorId)'="" d
	.s priorCode=$P($G(^OECPR(priorId)),"^",1)
	.q:($G(priorCode)'="S")&&($G(priorCode)'="OMST")
	.q:$G(ordFreqId)=""
	.s arcObj.firstTimes=..CalFirstTimes(priorId,ordFreqId)

	d arcObj.%Close()
	s Xml=""
	s ret=arcObj.XMLExportToString(.Xml)
	i ret=1 s retStr=retStr_Xml
	q retStr
}

ClassMethod Antibiotics(ARCIMRowid As %String) As %String
{
	n (ARCIMRowid)
	s Flag=""
	s CatRowid=0 for  s CatRowid=$o(^OEC("ORCAT",CatRowid))   q:CatRowid=""  d
	s DrgFormRowid=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",12)
	i DrgFormRowid=-1 s DrgFormRowid=""
	Q:DrgFormRowid="" ""
	s DrgFormPoison=$p($G(^PHCD(+DrgFormRowid,1)),"^",4)
	s poisonCode=""
    i DrgFormPoison'="" s poisonCode=$p(^PHCPO(DrgFormPoison),"^",1)
	i poisonCode["KSS" s Flag=1
	q Flag
}

/// w ##Class(DWR.BL.DoctorEntry).SaveTempOrdItem(Param)
ClassMethod SaveTempOrdItem(Param As %String = "") As %String
{
	s retStr=""
	i Param="" d
	.s Param="<Request><userCode>030414</userCode><arcItemId>10343||1</arcItemId><admId>426793</admId><departmentId>336</departmentId>"
	.s Param=Param_"<priorId>1</priorId><recLocId>399</recLocId><doseQty>1</doseQty><doseUomId>2</doseUomId>"
	.s Param=Param_"<freqId>1</freqId><instrId>5</instrId><packQty></packQty>"
	.s Param=Param_"</Request>"
    s Param=$TR(Param,$C(10))
    /////处理 (null)
    s Param1=""
    f i=1:1:$L(Param,"(null)") d
    .s Param1=Param1_$P(Param,"(null)",i)
    s Param=Param1
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s arcItemId=request.arcItemId
	   s arcItemId=$TR(arcItemId,$C(0))
	   s masterSeqNo=request.masterSeqNo
	   s masterSeqNo=$TR(masterSeqNo,$C(0))
	   s priorId=request.priorId
	   s priorId=$TR(priorId,$C(0))
	   s ordStartDate=request.ordStartDate
	   s ordStartDate=$TR(ordStartDate,$C(0))
	   i ordStartDate'="" d
	   .s ordStartDate=$ZDH(ordStartDate,3)
	   .s ordStartDate=$ZD(ordStartDate,4)
	   e  d
	   .s ordStartDate=$ZD(+$H,4)
	   s ordStartTime=request.ordStartTime
	   s ordStartTime=$TR(ordStartTime,$C(0))
	   i ordStartTime="" s ordStartTime=$ZT($P($H,",",2))
	   s recLocId=request.recLocId
	   s recLocId=$TR(recLocId,$C(0))
	   s ordNote=request.ordNote
	   s ordNote=$TR(ordNote,$C(0))
	   s doseQty=request.doseQty
	   s doseQty=$TR(doseQty,$C(0))
	   s doseUomId=request.doseUomId
	   s doseUomId=$TR(doseUomId,$C(0))
	   s freqId=request.freqId
	   s freqId=$TR(freqId,$C(0))
	   s instrId=request.instrId
	   s instrId=$TR(instrId,$C(0))
	   s masterSeqNo=request.masterSeqNo
	   s masterSeqNo=$TR(masterSeqNo,$C(0))
	   s skinTest=request.skinTest
	   s skinTest=$TR(skinTest,$C(0))
	   s skinActId=request.skinActId
	   s skinActId=$TR(skinActId,$C(0))
	   s firstTimes=request.firstTimes
	   s firstTimes=$TR(firstTimes,$C(0))
	   s packQty=request.packQty
	   s packQty=$TR(packQty,$C(0))
	   s showIndex=request.showIndex
	   s showIndex=$TR(showIndex,$C(0))
	   s anntibId=request.anntibId
	   s anntibId=$TR(anntibId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	s bedId=$P($g(^PAADM(admId)),"^",73)
	i bedId'="" s bedCode=$P($g(^PAWARD(+bedId,"BED",$P(bedId,"||",2))),"^",1)
	e  s bedCode=""
	q:bedCode="" "203^患者未安排床位不能开医嘱!"
	s mainDoctorId=$P($G(^PAADM(admId)),"^",9)
	q:($G(^DHCDocConfig("IPNeedDoctor"))=1)&&(mainDoctorId="") "203^患者未指定主管不能开医嘱!"
	q:$G(arcItemId)="" "204^医嘱项Id不能为空!"
	q:$G(priorId)="" "205^医嘱优先级不能为空!"
	q:$G(recLocId)="" "206^接收科室Id不能为空!"
	q:(doseUomId'="")&&(+doseQty=0) "206^请输入合适的单次剂量!"
	s hospCode=""
	s hospId=$O(^CT("HOSP",0))
	i hospId'="" s hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
	s freqCode=$P($G(^OECPR(priorId)),"^",1)
	i (freqCode'="S")&&(freqCode'="OMST") s firstTimes=""
	s factor=0
	i (firstTimes'="")&&(freqId'="") d
	.s factor=+$P($G(^PHCFR(freqId)),"^",2)
	.s firstTimes=+firstTimes
	q:(firstTimes'="")&&(firstTimes>factor) "207^长期医嘱的首日次数不能大于频次!"


	q:((freqCode="S")||(freqCode="OMST"))&&(skinTest="Y") "208^长期医嘱不能皮试!"
	q:(skinTest="Y")&&(+skinActId=0) "208^皮试医嘱皮试备注不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s arcDetail=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(admId, "", "",arcItemId)
	s arcType=$P(arcDetail,"^",2)
	//医生站 药品医嘱 判断 是否有诊断
	//$G(^DHCDocConfig("IPOrderPhamacyWithDiagnos"))
	s mrAdmId=+$P($G(^PAADM(admId)),"^",61)
	q:(arcType="R")&&(mrAdmId=0) "203^药品医嘱必须先录入诊断!"
	if (mrAdmId>0)&&(arcType="R")
	{
		i ($O(^MR(mrAdmId,"DIA",0))="")&&($G(^DHCDocConfig("IPOrderPhamacyWithDiagnos"))=1) q "203^药品医嘱必须先录入诊断!"
	}
	s billTypeId=$P(arcDetail,"^",7)
	s billTypeId=""
	s ordPrice=$P($P(arcDetail,"^",8),$C(1),1)
	i +packQty=0 s packQty=$P($P(arcDetail,"^",9),$C(1),1)
	s phFromId=""
	s phFromStr=$P(arcDetail,"^",11)
	i phFromStr'="" d
	.s phFromId=$P(phFromStr,$C(1),2)
	s durId=""
	s durStr=$P(arcDetail,"^",15)
	i durStr'="" d
	.s durId=$P(durStr,$C(1),2)
	s checkRet=1
	s ordQty=doseQty
	i (arcType="R")&&(freqId'="") d
	.s freqFactor=+$P($G(^PHCFR(freqId)),"^",2)
	.q:freqFactor=0
	.s ordQty=freqFactor*ordQty
	.s checkRet=##class(web.DHCDocOrderCommon).CheckStockEnough(arcItemId,ordQty,recLocId)
	q:checkRet=0 "209^该医嘱项目接收科室库存不足!"
	s ifexitSameOrder=..IfExistSameOrder(admId,arcItemId,userId)
	q:(ifexitSameOrder=1)&&(showIndex="") "210^当天已经存在相同医嘱!"
	s itemCatDr=$P($G(^ARCIM(+arcItemId,$P(arcItemId,"||",2),1)),"^",10)
	s isNeedBillQty=##class(web.DHCDocOrderCommon).GetNeedPackQtyFlag(recLocId,itemCatDr)
	q:(hospCode="WHSDYYY")&&(freqCode'="S")&&(freqCode'="OMST")&&(+packQty=0) "211^该医嘱项总数量不能为空!"
	q:((freqCode="ONE")||(freqCode="OUT"))&&(+packQty=0) "211^取药医嘱出院带药总数量不能为空!"
	q:((isNeedBillQty="Y")||(+isNeedBillQty>0))&&((freqCode="S")||(freqCode="OMST")) "212^该医嘱项不摆药,请修改医嘱类型!"

	s labSpecList=$P(arcDetail,"^",19)
	i (arcType="L")&&(labSpecList'="") d
	.s labSpec=$P(labSpecList,$C(3),2)
	.s labSpecCode=$P(labSpecList,$C(3),1)
	.s labContCode=$P(labSpecList,$C(3),3)
	.s labCont=$P(labSpecList,$C(3),4)

	s ordItemStr=""
	///不是药品医嘱,并且医嘱子类的不在有频次疗程的医嘱子类之内的,将频次用法单次剂量置空
	s itemCatDr="^"_$P($G(^ARCIM(+arcItemId,$P(arcItemId,"||",2),1)),"^",10)_"^"
	s freqItemCat="^"_$G(^DHCDocConfig("FrequencedItemCat"))_"^"
	i (arcType'="R")&&(freqItemCat'="^^")&&(freqItemCat'[itemCatDr) d
	.s freqId=""
	.s instrId=""
	.s doseQty=""
	.s doseUomId=""
	.s packQty=""
	s $P(ordItemStr,"^",1)=arcItemId
	s $P(ordItemStr,"^",2)=arcType
	s $P(ordItemStr,"^",3)=priorId
	s $P(ordItemStr,"^",4)=ordStartDate
	s $P(ordItemStr,"^",5)=ordStartTime
	s $P(ordItemStr,"^",6)=packQty   ///整包装数量
	s $P(ordItemStr,"^",7)=ordPrice
	s $P(ordItemStr,"^",8)=recLocId
	s $P(ordItemStr,"^",9)=billTypeId
	s $P(ordItemStr,"^",10)=phFromId
	s $P(ordItemStr,"^",11)=ordNote
	s $P(ordItemStr,"^",12)=doseQty
	s $P(ordItemStr,"^",13)=doseUomId
	s ordQtySum=0
	s $P(ordItemStr,"^",14)=ordQtySum    ///医嘱数量合计  门诊用 此处设置为0
	s $P(ordItemStr,"^",15)=freqId
	s $P(ordItemStr,"^",16)=durId
	s $P(ordItemStr,"^",17)=instrId
	s prescType=""
	s $P(ordItemStr,"^",18)=prescType   ////处方类型　默认为空
	s $P(ordItemStr,"^",19)=masterSeqNo  ///关联医嘱主序号 默认为空
	s seqNo=1
	s $P(ordItemStr,"^",20)=seqNo       ///子医嘱关联序号 默认为　1
	s $P(ordItemStr,"^",21)=skinTest
	s sepecStr=""
	s $P(ordItemStr,"^",22)=sepecStr
	s $P(ordItemStr,"^",28)=$G(labSpecCode)
	s mianIns=""
	s $P(ordItemStr,"^",23)=mianIns     ////默认为空
	s $P(ordItemStr,"^",24)=skinActId
	s arcOSId=""
	s $P(ordItemStr,"^",25)=arcOSId     ///医嘱套Id　默认为空
	s firstTimes=+firstTimes
	i firstTimes=0 s firstTimes=""
	s $P(ordItemStr,"^",33)=firstTimes
	s $P(ordItemStr,"^",50)=anntibId    //抗生素用药  预防 治疗
	///w ##class(web.DHCOEOrdItem).Antibiotics("408||1") 1 为抗生素   治疗 1；预防 2
	k ^DHCMHCOrdTemp("PadOrder",+$H-1)
  	i showIndex="" d
  	.s tempRowId=$I(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId))
  	e  s tempRowId=showIndex
  	s ^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempRowId)=ordItemStr
  	s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempRowId),"^",20)=tempRowId	
  	i (+masterSeqNo>0)&&(masterSeqNo'=tempRowId) d
  	.q:$G(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,masterSeqNo))=""
    .s tempId=""
    .f  s tempId=$O(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId)) q:tempId=""  d
    ..q:($P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",19)'=masterSeqNo)&&(tempId'=masterSeqNo)
  	..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",3)=priorId
  	..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",15)=freqId
    ..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",16)=durId
    ..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",17)=instrId
    ..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",33)=firstTimes
  	.///武汉一院修改子医嘱,关联修改主医嘱
  	.q
  	.s mastPriorId=$P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,masterSeqNo),"^",3)
  	.s mastfreqId=$P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,masterSeqNo),"^",15)
  	.s mastDurId=$P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,masterSeqNo),"^",16)  	
  	.s mastInstrId=$P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,masterSeqNo),"^",17)
  	.s mastFirstTimes=$P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,masterSeqNo),"^",33)
  	.s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempRowId),"^",3)=mastPriorId
  	.s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempRowId),"^",15)=mastfreqId
    .s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempRowId),"^",16)=mastDurId
    .s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempRowId),"^",17)=mastInstrId
    .s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempRowId),"^",19)=masterSeqNo
    .s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempRowId),"^",33)=mastFirstTimes
    e  d
    .s tempId=""
    .f  s tempId=$O(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId)) q:tempId=""  d
    ..q:$P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",19)'=tempRowId
  	..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",3)=priorId
  	..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",15)=freqId
    ..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",16)=durId
    ..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",17)=instrId
    ..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",33)=firstTimes
    ..//s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",19)=tempRowId
    //增加新的临时数据,不再显示最后一次审核的医嘱信息
    k ^DHCMHCOrdTemp("PadInsertOrder",+$H,userId)
  	q "0^保存成功!"
}

/// /判断当日是否有相同的医嘱
ClassMethod IfExistSameOrder(admId As %String, arcRowId As %String, userId As %String = "") As %String
{
  n (admId,arcRowId,userId)
  s ifExist=0
  q 0
  q:(admId="")||(arcRowId="") ifExist
  s orderId=$O(^OEORD(0,"Adm",admId,""))
  q:orderId="" ifExist
  s ordSubId=$O(^OEORDi(0,"ARCIM",orderId,arcRowId,+$H,""))
  i ordSubId'="" d
  .s ordStatId=$P($G(^OEORD(orderId,"I",ordSubId,1)),"^",13)
  .s ordStatCode=$P($G(^OEC("OSTAT",ordStatId)),"^",1)
  .i (ordStatCode="V")||(ordStatCode="E") s ifExist=1
  //i $O(^OEORDi(0,"ARCIM",orderId,arcRowId,+$H,""))'="" s ifExist=1
  q:ifExist ifExist
  i userId'="" d
  .s tempId="" f tempId=$O(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId)) q:tempId=""  d
  ..i $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId),"^",1)=arcRowId s ifExist=1
  q ifExist
}

/// 加载当前已经保存未审核的医嘱信息
/// w ##Class(DWR.BL.DoctorEntry).GetCurrOrdDetail(Param)
ClassMethod GetCurrOrdDetail(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>030414</userCode><admId>426793</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	
	///最后一次审核的数据
	s orderRowId=""
	f  s orderRowId=$O(^DHCMHCOrdTemp("PadInsertOrder",+$H,userId,admId,orderRowId)) q:orderRowId=""  d
	.s orderObj=##Class(User.OEOrdItem).%OpenId(orderRowId)
	.s arcObj=##class(DWR.MSG.ArcimItem).%New()
	.s seqNo=orderObj.OEORISeqNo
	.s arcObj.showIndex=seqNo
	.s arcimDesc=orderObj.OEORIItmMastDR.ARCIMDesc
	.s orderStat=orderObj.OEORIItemStatDR.OSTATDesc
	.s arcObj.ordState=orderStat
	.s arcimDesc=arcimDesc
	.s arcObj.arcimDesc=arcimDesc
	.s priorDesc=orderObj.OEORIPriorityDR.OECPRDesc
	.s arcObj.priorDesc=priorDesc
	.s freqCode=orderObj.OEORIPHFreqDR.PHCFRCode
	.s arcObj.freqCode=freqCode
	.s doseQty=orderObj.OEORIPhQtyOrd
	.i doseQty'="" d
	..i +doseQty<1 s doseQty="0"_doseQty
	..s arcObj.doseQty=doseQty
	..s doseUom=orderObj.OEORIUnitDR.CTUOMDesc
	..s arcObj.doseUom=doseUom
	.s instrCode=orderObj.OEORIInstrDR.PHCINCode
	.s arcObj.instrCode=instrCode
	.s recLoc=orderObj.OEORIRecDepDR.CTLOCDesc
	.i $P(recLoc,"-",2)'="" s recLoc=$P(recLoc,"-",2)
	.s arcObj.recLoc=recLoc
	.s skinAct=orderObj.OEORIActionDR.ACTDesc
	.s arcObj.skinAct=skinAct
	.s ordType=orderObj.OEORIItmMastDR.ARCIMItemCatDR.ARCICOrderType
	.i skinAct'="" s arcimDesc=arcimDesc_"("_skinAct_")"
	.s orderType=orderObj.OEORIItmMastDR.ARCIMItemCatDR.ARCICOrderType
	.i orderType="R" d
	..s arcimDesc=arcimDesc_" "_$G(doseQty)_$G(doseUom)_" "_$G(freqCode)_" "_$G(instrCode)_" "_recLoc
	.e  d
	..s arcimDesc=arcimDesc_" "_$G(freqCode)_" "_$G(instrCode)_" "_recLoc
	.s arcObj.arcimDesc=arcimDesc
	.d orderObj.%Close()
	.d arcObj.%Close()
	.s Xml=""
	.s ret=arcObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml
	////已经保存未审核的医嘱信息
	s showIndex="" f  s showIndex=$O(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,showIndex)) q:showIndex=""  d
	.s ordItemStr=$G(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,showIndex))
	.q:ordItemStr=""
	.s arcObj=##class(DWR.MSG.ArcimItem).%New()
	.s arcObj.showIndex=showIndex
	.s arcItemId=$P(ordItemStr,"^",1)
	.s arcimDesc=$P($G(^ARCIM($P(arcItemId,"||"),$P(arcItemId,"||",2),1)),"^",2)
	.s masterSeqNo=+$P(ordItemStr,"^",19)
	.i masterSeqNo>0 s arcimDesc="_"_masterSeqNo_arcimDesc
	.s arcObj.arcimDesc=arcimDesc
	.s priorId=$P(ordItemStr,"^",3)
	.q:priorId=""
	.s priorDesc=$P($G(^OECPR(priorId)),"^",2)
	.s arcObj.priorDesc=priorDesc
	.s freqId=$P(ordItemStr,"^",15)
	.i freqId'="" d
	..s freqCode=$P($G(^PHCFR(freqId)),"^",1)
	..s arcObj.freqCode=freqCode
	.s doseQty=$P(ordItemStr,"^",12)
	.i doseQty'="" d
	..s arcObj.doseQty=doseQty
	..s doseUomId=$P(ordItemStr,"^",13)
	..i doseUomId'="" d
	...s doseUom=$P($G(^CT("UOM",doseUomId)),"^",2)
	...s arcObj.doseUom=doseUom
	.s instrId=$P(ordItemStr,"^",17)
	.i instrId'="" d
	..s instrCode=$P($G(^PHCIN(instrId)),"^",2)
	..s arcObj.instrCode=instrCode
	.s recLocId=$P(ordItemStr,"^",8)
	.i recLocId'="" d
	..s recLoc=$P($G(^CTLOC(recLocId)),"^",2)
	..i $P(recLoc,"-",2)'="" s recLoc=$P(recLoc,"-",2)
	..s arcObj.recLoc=recLoc
	.s skinActId=$P(ordItemStr,"^",24)
	.i skinActId'="" d
	..s skinAct=$P($G(^OEC("ACT",skinActId)),"^",2)
	..s arcObj.skinAct=skinAct	
	.d arcObj.%Close()
	.s Xml=""
	.s ret=arcObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml
	q retStr
}

/// 单击已保存未审核医嘱加载当前信息
/// w ##Class(DWR.BL.DoctorEntry).GetCurrArcimDetail(Param)
ClassMethod GetCurrArcimDetail(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>030414</userCode><admId>426793</admId><showIndex>1</showIndex></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s showIndex=request.showIndex
	   s showIndex=$TR(showIndex,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(showIndex)="" "203^查询项Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s ordDetail=$G(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,showIndex))
	q:ordDetail="" "204^可修改数据不存在!"
	s arcItemId=$P(ordDetail,"^",1)
	s ordPriorId=$P(ordDetail,"^",3)
	s ordStartDate=$P(ordDetail,"^",4)
	s ordStartTime=$P(ordDetail,"^",5)
	s packQty=$P(ordDetail,"^",6)
	s recLocId=$P(ordDetail,"^",8)
	s ordNote=$P(ordDetail,"^",11)
	s ordDoseQty=$P(ordDetail,"^",12)
	s ordDoseUomId=$P(ordDetail,"^",13)
	s freqId=$P(ordDetail,"^",15)
	s instrId=$P(ordDetail,"^",17)
	s masterSeqNo=$P(ordDetail,"^",19)
	s skinTest=$P(ordDetail,"^",21)
	s skinActId=$P(ordDetail,"^",24)
	s firstTimes=$P(ordDetail,"^",33)
	s anntibId=$P(ordDetail,"^",50)
	//s arcDetail=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(admId, "", departmentId,arcItemId)	
	s arcDetail=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(admId, "", "",arcItemId)	
	s arcimDesc=$P(arcDetail,"^",1)
	s arcimDesc=$TR(arcimDesc,$C(1))
	s arcObj=##class(DWR.MSG.ArcimItem).%New()
	i ordStartDate'="" d
	.s ordStartDate=$ZDH(ordStartDate,4)
	.s ordStartDate=$ZD(ordStartDate,3)
	e  s ordStartDate=$ZD(+$H,3)
	s arcObj.ordStartDate=ordStartDate
	i ordStartTime="" s ordStartTime=$ZT($P($H,",",2))
	s arcObj.ordStartTime=ordStartTime
	s arcObj.arcimDesc=arcimDesc
	s arcObj.arcimId=arcItemId
	s ordType=$P(arcDetail,"^",2)
	s arcObj.arcType=ordType
	s ordBillType=$P(arcDetail,"^",7)
	s ordPrice=$P(arcDetail,"^",8)
	i ordPrice'="" d
	.s ordPrice=$P(ordPrice,$C(1),1)
	.s arcObj.itemPrice=ordPrice
	s arcObj.packQty=packQty
	s ordPriceUom=$P(arcDetail,"^",9)
	i ordPriceUom'="" d
	.i packQty="" s packQty=$P(ordPriceUom,$C(1),1)
	.s arcObj.packQty=packQty
	.s priceUom=$P(ordPriceUom,$C(1),2)
	.s priceUomId=$P(ordPriceUom,$C(1),3)
	.s arcObj.billUom=$G(priceUom)
	s recLocList=$P(arcDetail,"^",10)
	s itemSubCatId=$p($G(^ARCIM(+arcItemId,$p(arcItemId,"||",2),1)),"^",10)
	i itemSubCatId'="" d
	.s oecprCode=$P($G(^OECPR(ordPriorId)),"^",1)
	.s instrRelocStr=""
	.i oecprCode="ONE" d
	..s instrRelocStr=..GetOneRecLoc(admId,departmentId,arcItemId)
	.i oecprCode="OUT" d
	..s instrRelocStr=..GetOutRecLoc(admId,departmentId,arcItemId)
	.i instrRelocStr="" s instrRelocStr=##class(web.DHCDocOrderCommon).GetInstrRecLocStr(admId,instrId,departmentId,itemSubCatId,ordPriorId)
	.i instrRelocStr="" s instrRelocStr=##class(web.DHCDocOrderCommon).GetHolidaysRecLoc(admId,departmentId,arcItemId)
	.i instrRelocStr="" s instrRelocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(departmentId,arcItemId)
	.i instrRelocStr="" s instrRelocStr=##class(web.DHCDocOrderCommon).GetRecloc(admId,arcItemId)
	.i instrRelocStr'="" s recLocList=instrRelocStr
	f recLocIndex=1:1:$L(recLocList,$C(2)) d
	.s recLocStr=$P(recLocList,$C(2),recLocIndex)
	.q:recLocStr=""
	.s locId=$P(recLocStr,$C(1),1)
	.s locDesc=$P(recLocStr,$C(1),2)
	.i ($C(2)_recLocList)'[($C(2)_recLocId_$C(1)) d
	..s recLocId=locId
	..s $P(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,showIndex),"^",8)=recLocId
	.s defaultFlag=$P(recLocStr,$C(1),3)
	.i (recLocId'="") s defaultFlag="N"
	.i (locId=recLocId) s defaultFlag="Y"
	.s deptObj=##class(DWR.MSG.DepartmentInfo).%New()
	.s deptObj.locId=locId
	.s deptObj.locDesc=locDesc
	.s deptObj.defaultFlag=defaultFlag
	.d deptObj.%Close()
	.d arcObj.recLocList.Insert(deptObj)
	s phFromStr=$P(arcDetail,"^",11)
	i phFromStr'="" d
	.s phFromId=$P(phFromStr,$C(1),2)
	.s arcObj.phFromId=phFromId
	s doseQtyList=$P(arcDetail,"^",12)
	i (doseQtyList'="")&&(ordType="R") d
	.f doseQtyIndex=1:1:$L(doseQtyList,$C(2)) d
	..s doseQtyOne=$P(doseQtyList,$C(2),doseQtyIndex)
	..q:doseQtyOne=""
	..s doseQty=$P(doseQtyOne,$C(1),1)
	..s doseUomDesc=$P(doseQtyOne,$C(1),2)
	..s doseUomId=$P(doseQtyOne,$C(1),3)
	..s doseObj=##class(DWR.MSG.DoseQtyInfo).%New()
	..s doseObj.doseQty=doseQty
	..s doseObj.doseUomDesc=doseUomDesc
	..s doseObj.doseUomId=doseUomId
	..i doseQtyIndex=1 s doseObj.defaultFlag="Y"
	..e  s doseObj.defaultFlag="N"
	..i (ordDoseQty'="")&&(ordDoseUomId=doseUomId) d
	...s doseObj.defaultFlag="Y"
	...s doseObj.doseQty=ordDoseQty
	..i (ordDoseQty'="")&&(ordDoseUomId'=doseUomId) s doseObj.defaultFlag="N"
	..d doseObj.%Close()
	..d arcObj.doseQtyList.Insert(doseObj)
	s ordFreqList=$P(arcDetail,"^",13)
	i ordFreqList'="" d
	.s ordFreq=$P(ordFreqList,$C(1),1)
	.s ordFreqId=$P(ordFreqList,$C(1),2)
	.s arcObj.freqCode=ordFreq
	.s arcObj.freqId=ordFreqId
	.i freqId'="" d
	..s arcObj.freqId=freqId
	..s freqCode=$P($G(^PHCFR(freqId)),"^",1)
	..s arcObj.freqCode=freqCode
	s ordInstrList=$P(arcDetail,"^",14)
	i ordInstrList'="" d
	.s instructDesc=$P(ordInstrList,$C(1),1)
	.s instructId=$P(ordInstrList,$C(1),2)
	.s arcObj.instrId=instructId
	.s arcObj.instrCode=instructDesc
	.i instrId'="" d
	..s arcObj.instrId=instrId
	..s instructDesc=$P($G(^PHCIN(instrId)),"^",2)
	..s arcObj.instrCode=instructDesc
	s ordPriorList=$P(arcDetail,"^",16)
	i ordPriorList'="" d
	.s priorDesc=$p(ordPriorList,$C(1),1)
	.s priorId=$p(ordPriorList,$C(1),2)
	.s arcObj.priorId=priorId
	.s arcObj.priorDesc=priorDesc
	i ordPriorId'="" d
	.s priorDesc=$P($G(^OECPR(ordPriorId)),"^",2)
	.s arcObj.priorId=ordPriorId
	.s arcObj.priorDesc=priorDesc	
	s ordMsg=$P(arcDetail,"^",17)
	s ordMsg=$TR(ordMsg,$C(1))
	///加载过的数据不再提示
	///i ordMsg'="" s arcObj.arcMsg=ordMsg
	s labSpecList=$P(arcDetail,"^",19)
	i (ordType="L")&&(labSpecList'="") d
	.s labSpec=$P(labSpecList,$C(3),2)
	.s labSpecCode=$P(labSpecList,$C(3),1)
	.s labContCode=$P(labSpecList,$C(3),3)
	.s labCont=$P(labSpecList,$C(3),4)
	.//s labObj=##class(DWR.MSG.LabSpecInfo).%New()
	.s arcObj.labSpec=labSpec
	.s arcObj.labSpecCode=labSpecCode
	.s arcObj.labContCode=labContCode
	.s arcObj.labCont=labCont
	.//d labObj.%Close()
	.//d arcObj.labSpecList.Insert(labObj)
	s needSkinStr=$P(arcDetail,"^",20)
	i skinTest'="" d
	.s arcObj.needSkin=skinTest
	.//q:skinTest="N"
	.s arcObj.skinActId=skinActId
	.q:skinActId=""
	.s skinAct=$P(^OEC("ACT",skinActId),"^",2)
	.s arcObj.skinAct=skinAct
	e  d
	.q:needSkinStr=""
	.s needSkinTest=$P(needSkinStr,$C(1),1)
	.s arcObj.needSkin=needSkinTest
	.//q:needSkinTest="N"
	.s skinActId=$P(needSkinStr,$C(1),2)
	.s arcObj.skinActId=skinActId
	.q:skinActId=""
	.s skinAct=$P(^OEC("ACT",skinActId),"^",2)
	.s arcObj.skinAct=skinAct
	s limitList=$P(arcDetail,"^",22)
	s arcObj.masterSeqNo=masterSeqNo
	s arcObj.firstTimes=firstTimes
	s arcObj.ordNote=ordNote
	s arcObj.isAntib=..Antibiotics(arcItemId) //1 为抗生素   治疗 1；预防 2
	s arcObj.anntibId=$G(anntibId)
	d arcObj.%Close()
	s Xml=""
	s ret=arcObj.XMLExportToString(.Xml)
	i ret=1 s retStr=retStr_Xml
	q retStr
}

/// 删除临时数据
/// w ##Class(DWR.BL.DoctorEntry).DeleteTempData(Param)
ClassMethod DeleteTempData(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>030414</userCode><admId>426793</admId><showIndex>1</showIndex></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s showIndex=request.showIndex
	   s showIndex=$TR(showIndex,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	q:(showIndex'="")&&($G(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,showIndex))="") "203^没有可删除的数据!"
	i showIndex'="" d
	.k ^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,showIndex)
	.i showIndex=^DHCMHCOrdTemp("PadOrder",+$H,userId,admId) s ^DHCMHCOrdTemp("PadOrder",+$H,userId,admId)=showIndex-1
	.i $D(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId))=1 k ^DHCMHCOrdTemp("PadOrder",+$H,userId,admId)
	e  d
	.k ^DHCMHCOrdTemp("PadOrder",+$H,userId,admId)
	.k ^DHCMHCOrdTemp("PadInsertOrder",+$H,userId,admId)
	q "0^删除成功!"
}

/// 审核医嘱
/// w ##Class(DWR.BL.DoctorEntry).InserOrdItems(Param)
ClassMethod InserOrdItems(Param As %String = "") As %String
{
	//q "100^此模块暂时不开放!"
	s retStr=""
	i Param="" s Param="<Request><userCode>030414</userCode><admId>426793</admId><departmentId>336</departmentId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(departmentId)="" "203^登陆科室Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s docId=$p(^SSU("SSUSR",userId),"^",14) //SSUSR_CareProv_DR
    q:docId="" "204^不是医生,不能开医嘱!"
	s configObj=##Class(websys.Configuration).%OpenId(1)
	s MEDDATA=configObj.DataNamespace
	s LABDATA=configObj.LabDataNamespace
	s CurrentNS=$ZNSPACE
	s ordItemStr=..GetTempOrdStr(admId,userId)
	s hospCode=""
	s hospId=$O(^CT("HOSP",0))
	i hospId'="" s hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
	i (hospCode="WHSDYYY")||(hospCode="ZDSY") d
	.i (hospCode="ZDSY") d
	..zn MEDDATA
	..s insertFlag=$$InsertMultiple^DHCDocOrderCommon(admId,ordItemStr,userId,departmentId,docId,LABDATA,"")
	..zn CurrentNS
	..i insertFlag'=0 d
	...s ordItemList=""
	...s statusCode=""
	...i $E(insertFlag,$L(insertFlag))="^" s insertFlag=$E(insertFlag,0,$L(insertFlag)-1)
	...f ordIndex=1:1:$L(insertFlag,"^") d
	....s ordItem=$P(insertFlag,"^",ordIndex)
	....s ordItem=$P(ordItem,"*",2)
	....q:ordItem=""
	....s ^DHCMHCOrdTemp("PadInsertOrder",+$H,userId,admId,ordItem)=ordItem
	.e  d
	..zn MEDDATA
	..s insertFlag=$$InsertMultiple^DHCDocOrderCommon(admId,ordItemStr,userId,departmentId,docId,LABDATA)
	..zn CurrentNS
	..i insertFlag'=0 d
	...s ordItemList=""
	...s statusCode=""
	...i $E(insertFlag,$L(insertFlag))="^" s insertFlag=$E(insertFlag,0,$L(insertFlag)-1)
	...f ordIndex=1:1:$L(insertFlag,"^") d
	....s ordItem=$P(insertFlag,"^",ordIndex)
	....s ordItem=$P(ordItem,"*",2)
	....q:ordItem=""
	....s ^DHCMHCOrdTemp("PadInsertOrder",+$H,userId,admId,ordItem)=ordItem
	e  d
	.s insertFlag=$$InsertMultiple^DHCDocOrderCommonNew(admId,ordItemStr,userId,departmentId,docId,LABDATA)
	.///山东省立医院先保存后审核
	.i insertFlag'=0 d
	..s ordItemList=""
	..s statusCode=""
	..i $E(insertFlag,$L(insertFlag))="^" s insertFlag=$E(insertFlag,0,$L(insertFlag)-1)
	..f ordIndex=1:1:$L(insertFlag,"^") d
	...s ordItem=$P(insertFlag,"^",ordIndex)
	...s ordItem=$P(ordItem,"*",2)
	...q:ordItem=""
	...s ^DHCMHCOrdTemp("PadInsertOrder",+$H,userId,admId,ordItem)=ordItem
	...s statusId=$P($G(^OEORD(+ordItem,"I",$P(ordItem,"||",2),1)),"^",13)
	...s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
	..q:statusCode="V"
	..d verifypresno3^DHCaOET1(admId,userId,insertFlag,departmentId)
	///web.DHCOEOrdItem  InsertOrderItem
	///$$InsertMultiple^DHCDocOrderCommonNew(Adm,OrdItemStr,User,Loc,Doc,LABDATA)
	//zn CurrentNS
	i insertFlag'=0 k ^DHCMHCOrdTemp("PadOrder",+$H,userId,admId)
	q:insertFlag'=0 "0^医嘱审核成功!"
	q "205^医嘱审核失败,错误代码:"_insertFlag
}

/// GetInstrRecLocStr(EpisodeID As %String, FormInstrRowid As %String, OrdDepRowId As %String, OrdSubCatRowid As %String, PriorRowid As %String) As %String
/// w ##Class(DWR.BL.DoctorEntry).GetOecpr(Param)
ClassMethod GetInstrRecLocStr(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>doct</userCode></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s instrId=request.instrId
	   s instrId=$TR(instrId,$C(0))
	   s arcItemId=request.arcItemId
	   s arcItemId=$TR(arcItemId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	   s priorId=request.priorId
	   s priorId=$TR(priorId,$C(0))
	}
	q:$G(userCode)="" ""
	q:$G(admId)="" ""
	q:$G(instrId)="" ""
	q:$G(arcItemId)="" ""
	q:$G(departmentId)="" ""
	q:$G(priorId)="" ""
	q:+arcItemId=0 ""
	s itemSubCatId=$p($G(^ARCIM(+arcItemId,$p(arcItemId,"||",2),1)),"^",10)
	q:itemSubCatId="" ""
	s instrRelocStr=""
	s oecprCode=$P($G(^OECPR(priorId)),"^",1)
	i oecprCode="ONE" d
	.s instrRelocStr=..GetOneRecLoc(admId,departmentId,arcItemId)
	i oecprCode="OUT" d
	.s instrRelocStr=..GetOutRecLoc(admId,departmentId,arcItemId)
	i instrRelocStr="" s instrRelocStr=##class(web.DHCDocOrderCommon).GetInstrRecLocStr(admId,instrId,departmentId,itemSubCatId,priorId)
	i instrRelocStr="" s instrRelocStr=##class(web.DHCDocOrderCommon).GetHolidaysRecLoc(admId,departmentId,arcItemId)
	i instrRelocStr="" s instrRelocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(departmentId,arcItemId)
	i instrRelocStr="" s instrRelocStr=##class(web.DHCDocOrderCommon).GetRecloc(admId,arcItemId)
	i instrRelocStr'="" d
	.f recLocIndex=1:1:$L(instrRelocStr,$C(2)) d
	..s recLocStr=$P(instrRelocStr,$C(2),recLocIndex)
	..q:recLocStr=""
	..s locId=$P(recLocStr,$C(1),1)
	..s locDesc=$P(recLocStr,$C(1),2)
	..s defaultFlag=$P(recLocStr,$C(1),3)
	..s deptObj=##class(DWR.MSG.DepartmentInfo).%New()
	..s deptObj.locId=locId
	..s deptObj.locDesc=locDesc
	..s deptObj.defaultFlag=defaultFlag
	..d deptObj.%Close()
	..s Xml=""
	..s ret=deptObj.XMLExportToString(.Xml)
	..i ret=1 s retStr=retStr_Xml
	q retStr
}

/// 取药医嘱接收科室
ClassMethod GetOneRecLoc(admId As %String = "", ordLocId As %String = "", arcId As %String = "") As %String
{
	n (admId,ordLocId,arcId)
	s oneRecLocStr=""
	i ordLocId'="" d
	.s recLocStr=$G(^DHCDocConfig("OneOrderRecLoc",ordLocId))
	.i recLocStr="" d
	..s recLocStr=$G(^DHCDocConfig("OneOrderDefaultRecLoc"))
	.q:recLocStr=""
	.f locIndex=1:1:$l(recLocStr,"^") d
	..s recLocId=$P(recLocStr,"^",locIndex)
	..q:recLocId=""
	..s recLoc=$P($G(^CTLOC(recLocId)),"^",2)
	..q:recLoc=""
	..i oneRecLocStr="" s oneRecLocStr=recLocId_$C(1)_recLoc_$C(1)_"Y"
	..e  s oneRecLocStr=oneRecLocStr_$C(2)_recLocId_$C(1)_recLoc_$C(1)_"N"
	q oneRecLocStr
	//^DHCDocConfig("OutAndOneDefaultPackQty")=0
	//^DHCDocConfig("OutOrderNeedPackQty")=1
}

/// 出院带药医嘱接收科室
ClassMethod GetOutRecLoc(admId As %String = "", ordLocId As %String = "", arcId As %String = "") As %String
{
	n (admId,ordLocId,arcId)
	s outRecLocStr=""
	i ordLocId'="" d
	.s recLocStr=$G(^DHCDocConfig("OutOrderRecLoc",ordLocId))
	.i recLocStr="" d
	..s recLocStr=$G(^DHCDocConfig("OutOrderDefaultRecLoc"))
	.q:recLocStr=""
	.f locIndex=1:1:$l(recLocStr,"^") d
	..s recLocId=$P(recLocStr,"^",locIndex)
	..q:recLocId=""
	..s recLoc=$P($G(^CTLOC(recLocId)),"^",2)
	..q:recLoc=""
	..i outRecLocStr="" s outRecLocStr=recLocId_$C(1)_recLoc_$C(1)_"Y"
	..e  s outRecLocStr=outRecLocStr_$C(2)_recLocId_$C(1)_recLoc_$C(1)_"N"
	q outRecLocStr
}

/// 取配置参数,计算长期医嘱首日次数、取默认优先级、计算整包装数量
/// w ##Class(DWR.BL.DoctorEntry).GetConfigParam(Param)
ClassMethod GetConfigParam(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>doct</userCode></Request>"
    s Param=$TR(Param,$C(10))
    s Param1=""
    f i=1:1:$L(Param,"(null)") d
    .s Param1=Param1_$P(Param,"(null)",i)
    s Param=Param1
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s arcItemId=request.arcItemId
	   s arcItemId=$TR(arcItemId,$C(0))
	   s priorId=request.priorId
	   s priorId=$TR(priorId,$C(0))
	   s freqId=request.freqId
	   s freqId=$TR(freqId,$C(0))
	   s ordStartDate=request.ordStartDate
	   s ordStartDate=$TR(ordStartDate,$C(0))
	   s ordStartTime=request.ordStartTime
	   s ordStartTime=$TR(ordStartTime,$C(0))
	   s doseQty=request.doseQty
	   s doseQty=$TR(doseQty,$C(0))
	   s doseUomId=request.doseUomId
	   s doseUomId=$TR(doseUomId,$C(0))
	   s recLocId=request.recLocId
	   s recLocId=$TR(recLocId,$C(0))
	   s eventSource=request.eventSource
	   s eventSource=$TR(eventSource,$C(0))
	}
	q:$G(userCode)="" retStr
	q:$G(admId)="" retStr
	q:$G(arcItemId)="" retStr
	q:$G(freqId)="" retStr
	q:$G(priorId)="" retStr
	s isNeedBillQty=""
	s itemCatDr=$P($G(^ARCIM(+arcItemId,$P(arcItemId,"||",2),1)),"^",10)
	i recLocId'="" s isNeedBillQty=##class(web.DHCDocOrderCommon).GetNeedPackQtyFlag(recLocId,itemCatDr)
	s hospCode=""
	s hospId=$O(^CT("HOSP",0))
	i hospId'="" s hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
	s oecprCode=$P(^OECPR(priorId),"^",1)
	///freqId  priorId
	i eventSource="freqId" d
	.i freqId=$O(^PHCFR(0,"Code","ST","")) d
	..s priorId=$O(^OECPR(0,"Code","STAT",""))
	..q:priorId=""
	..s priorDesc=$P($G(^OECPR(priorId)),"^",2)
	..s retStr="<priorId>"_priorId_"</priorId>"
	..s retStr=retStr_"<priorDesc>"_priorDesc_"</priorDesc>"
	.i freqId=$O(^PHCFR(0,"Code","ONCE","")) d
	..s priorId=$O(^OECPR(0,"Code","STAT",""))
	..q:priorId=""
	..s priorDesc=$P($G(^OECPR(priorId)),"^",2)
	..s retStr="<priorId>"_priorId_"</priorId>"
	..s retStr=retStr_"<priorDesc>"_priorDesc_"</priorDesc>"
	e  d
	.i oecprCode="STAT" d
	..s:$O(^PHCFR(0,"Code","ST",""))'="" freqId=$O(^PHCFR(0,"Code","ST",""))
	..i freqId'="" d
	...s freqCode=$P($G(^PHCFR(freqId)),"^",1)
	...q:freqCode=""
	...s retStr="<freqId>"_freqId_"</freqId>"
	...s retStr=retStr_"<freqCode>"_freqCode_"</freqCode>"
	.i oecprCode="NORM" d
	..s:$O(^PHCFR(0,"Code","ONCE",""))'="" freqId=$O(^PHCFR(0,"Code","ONCE",""))
	..i freqId'="" d
	...s freqCode=$P($G(^PHCFR(freqId)),"^",1)
	...q:freqCode=""
	...s retStr="<freqId>"_freqId_"</freqId>"
	...s retStr=retStr_"<freqCode>"_freqCode_"</freqCode>"
	i (($G(oecprCode)'="S")&&($G(freqCode)'="OMST")&&((isNeedBillQty="Y")||(+isNeedBillQty>0)||(hospCode="WHSDYYY")))||($G(oecprCode)="ONE")||($G(oecprCode)="OUT") d
	.i (doseQty'="")&&(doseUomId'="") d
	..s packQtyStr=..GetPackQty(arcItemId,freqId,doseQty,doseUomId)
	..i packQtyStr'="" s retStr=retStr_packQtyStr
	q:($G(oecprCode)'="S")&&($G(freqCode)'="OMST") retStr
	s firstTimes=..CalFirstTimes(priorId,freqId)
	s retStr="<firstTimes>"_firstTimes_"</firstTimes>"
	q retStr
}

ClassMethod CalFirstTimes(priorId As %String = "", freqId As %String = "", ordStartDate As %String = "", ordStartTime As %String = "") As %String
{
	s firstTimes=""
	s oecprCode=$P($G(^OECPR(priorId)),"^",1)
	q:($G(oecprCode)'="S")&&($G(freqCode)'="OMST") firstTimes
	s frFactor=+$P($G(^PHCFR(freqId)),"^",2)
	q:frFactor=0 firstTimes
	s firstSet=$G(^DHCDocConfig("FirstTimes"))
	i (firstSet="")||(firstSet="Non") q firstTimes
	//根据时间计算首日长期次数暂时未实现
	i (firstSet="All")||(firstSet="CalcBySttTime") d
	.s firstTimes=frFactor
	q firstTimes
}

/// w ##Class(DWR.BL.DoctorEntry).GetFirstTimes(Param)
ClassMethod GetFirstTimes(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><userCode>doct</userCode></Request>"
    s Param=$TR(Param,$C(10))
    s Param1=""
    f i=1:1:$L(Param,"(null)") d
    .s Param1=Param1_$P(Param,"(null)",i)
    s Param=Param1
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","DWR.MSG.Request")
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s arcItemId=request.arcItemId
	   s arcItemId=$TR(arcItemId,$C(0))
	   s priorId=request.priorId
	   s priorId=$TR(priorId,$C(0))
	   s freqId=request.freqId
	   s freqId=$TR(freqId,$C(0))
	   s ordStartDate=request.ordStartDate
	   s ordStartDate=$TR(ordStartDate,$C(0))
	   s ordStartTime=request.ordStartTime
	   s ordStartTime=$TR(ordStartTime,$C(0))
	   s doseQty=request.doseQty
	   s doseQty=$TR(doseQty,$C(0))
	   s doseUomId=request.doseUomId
	   s doseUomId=$TR(doseUomId,$C(0))
	   s recLocId=request.recLocId
	   s recLocId=$TR(recLocId,$C(0))
	}
	q:$G(userCode)="" retStr
	q:$G(admId)="" retStr
	q:$G(arcItemId)="" retStr
	q:$G(freqId)="" retStr
	q:$G(priorId)="" retStr
	s isNeedBillQty=""
	s itemCatDr=$P($G(^ARCIM(+arcItemId,$P(arcItemId,"||",2),1)),"^",10)
	i recLocId'="" s isNeedBillQty=##class(web.DHCDocOrderCommon).GetNeedPackQtyFlag(recLocId,itemCatDr)
	s hospCode=""
	s hospId=$O(^CT("HOSP",0))
	i hospId'="" s hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
	//hospCode="WHSDYYY"
	s oecprCode=$P(^OECPR(priorId),"^",1)
	i oecprCode="STAT" d
	.s:$O(^PHCFR(0,"Code","ST",""))'="" freqId=$O(^PHCFR(0,"Code","ST",""))
	.i freqId'="" d
	..s freqCode=$P($G(^PHCFR(freqId)),"^",1)
	..q:freqCode=""
	..s retStr="<freqId>"_freqId_"</freqId>"
	..s retStr=retStr_"<freqCode>"_freqCode_"</freqCode>"
	i oecprCode="NORM" d
	.s:$O(^PHCFR(0,"Code","ONCE",""))'="" freqId=$O(^PHCFR(0,"Code","ONCE",""))
	.i freqId'="" d
	..s freqCode=$P($G(^PHCFR(freqId)),"^",1)
	..q:freqCode=""
	..s retStr="<freqId>"_freqId_"</freqId>"
	..s retStr=retStr_"<freqCode>"_freqCode_"</freqCode>"
	i (($G(oecprCode)'="S")&&($G(freqCode)'="OMST")&&((isNeedBillQty="Y")||(+isNeedBillQty>0)||(hospCode="WHSDYYY")))||($G(oecprCode)="ONE")||($G(oecprCode)="OUT") d
	.i (doseQty'="")&&(doseUomId'="") d
	..s packQtyStr=..GetPackQty(arcItemId,freqId,doseQty,doseUomId)
	..i packQtyStr'="" s retStr=retStr_packQtyStr
	q:($G(oecprCode)'="S")&&($G(freqCode)'="OMST") retStr
	s oecprDesc=$P(^OECPR(priorId),"^",2)
	s factor=+$P($G(^PHCFR(freqId)),"^",2)
	s retStr="<firstTimes>"_factor_"</firstTimes>"
	s retStr=retStr_"<packQty></packQty>"
	s packUomId=$p(^ARCIM(+arcItemId,$P(arcItemId,"||",2),8),"^",14)
	i packUomId'="" d
	.s billUom=$p(^CT("UOM",packUomId),"^",2)
	.s retStr=retStr_"<billUom>"_billUom_"</billUom>"
	q retStr
}

ClassMethod GetPackQty(arcItemId As %String, freqId As %String, doseQty As %String = "", doseUomId As %String = "") As %String
{
	q:(+freqId=0)||(+doseQty=0)||(+doseUomId=0) ""
	s factor=+$P($G(^PHCFR(freqId)),"^",2)
	q:factor=0 ""
	s arcId=+arcItemId
	s arcSubId=+$p(arcItemId,"||",2)
	q:(arcId=0)||(arcSubId=0) ""	
	s packUomId=$p(^ARCIM(arcId,arcSubId,8),"^",14)
	q:packUomId="" ""
	s billUom=$p(^CT("UOM",packUomId),"^",2)
	q:billUom="" ""
	s phcDfId=$p($g(^ARCIM(arcId,arcSubId,1)),"^",12)
	q:phcDfId="" ""
	s phcDfSub=$p(phcDfId,"||",2)
	q:phcDfSub="" ""
	s phcDfId=+phcDfId
	s baseUomId=$p($g(^PHCD(phcDfId,"DF",phcDfSub,2)),"^",4)
	i doseUomId'=baseUomId d
    .s eqId=0,eqQty=1
    .f  s eqId=$o(^PHCD(phcDfId,"DF",phcDfSub,"EQ",eqId)) q:eqId=""  d
    ..s eqUomId=+^PHCD(phcDfId,"DF",phcDfSub,"EQ",eqId)
    ..i eqUomId=doseUomId s eqQty=$p(^PHCD(phcDfId,"DF",phcDfSub,"EQ",eqId),"^",2)
    ..s doseQty=doseQty/eqQty
    i baseUomId'=packUomId d
    .s ctCId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
	.i ctCId'="" s cFactor=$p(^CT("CTCF",ctCId),"^",3)
	e  s cFactor=1
	s sumQty=doseQty*factor
	s packQty=sumQty\cFactor
	i sumQty#cFactor>0 s packQty=packQty+1
	s packQtyStr="<packQty>"_packQty_"</packQty><billUom>"_billUom_"</billUom>"
	q packQtyStr
}

ClassMethod CalPackQty(arcItemId As %String, freqId As %String, doseQty As %String = "", doseUomId As %String = "") As %String
{
	q:(+freqId=0)||(+doseQty=0)||(+doseUomId=0) 0
	s factor=+$P($G(^PHCFR(freqId)),"^",2)
	q:factor=0 0
	s arcId=+arcItemId
	s arcSubId=+$p(arcItemId,"||",2)
	q:(arcId=0)||(arcSubId=0) 0	
	s packUomId=$p(^ARCIM(arcId,arcSubId,8),"^",14)
	q:packUomId="" 0
	s billUom=$p(^CT("UOM",packUomId),"^",2)
	q:billUom="" 0
	s phcDfId=$p($g(^ARCIM(arcId,arcSubId,1)),"^",12)
	q:phcDfId="" 0
	s phcDfSub=$p(phcDfId,"||",2)
	q:phcDfSub="" 0
	s phcDfId=+phcDfId
	s baseUomId=$p($g(^PHCD(phcDfId,"DF",phcDfSub,2)),"^",4)
	i doseUomId'=baseUomId d
    .s eqId=0,eqQty=1
    .f  s eqId=$o(^PHCD(phcDfId,"DF",phcDfSub,"EQ",eqId)) q:eqId=""  d
    ..s eqUomId=+^PHCD(phcDfId,"DF",phcDfSub,"EQ",eqId)
    ..i eqUomId=doseUomId s eqQty=$p(^PHCD(phcDfId,"DF",phcDfSub,"EQ",eqId),"^",2)
    ..s doseQty=doseQty/eqQty
    i baseUomId'=packUomId d
    .s ctCId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
	.i ctCId'="" s cFactor=$p(^CT("CTCF",ctCId),"^",3)
	e  s cFactor=1
	s sumQty=doseQty*factor
	s packQty=sumQty\cFactor
	i sumQty#cFactor>0 s packQty=packQty+1
	q packQty
}

ClassMethod GetTempOrdStr(admId As %String, userId As %String = "") As %String
{
	n (admId,userId)
	s retStr=""
	s tempId="" f  s tempId=$O(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId)) q:tempId=""  d
	.s ordItemStr=$G(^DHCMHCOrdTemp("PadOrder",+$H,userId,admId,tempId))
	.q:ordItemStr=""
	.i retStr="" s retStr=ordItemStr
	.e  s retStr=retStr_$c(1)_ordItemStr
    q retStr
}

Query FindOSItems(ARCOSRowid As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Item:%String,ItemQty:%String,ItemBillUOM:%String,ItemDoseQty:%String,ItemDoseUOM:%String,ItemFreq:%String,ItemInstr:%String,ItemDur:%String,ItemData:%String,ItemRowid:%String,ItemOrderType:%String,ItemPrice:%String,ItemStatus:%String,ItemRemark:%String,DHCDocOrderType:%String,DHCDocOrderTypeID:%String,ItemSpec:%String,ItemSpecCode:%String,ItemSeqNo:%String")
{
}

ClassMethod FindOSItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOSItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

//d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","FindOSItems","6200")

ClassMethod FindOSItemsExecute(ByRef qHandle As %Binary, ARCOSRowid As %String) As %Status
{
	s ljtp=0 
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^Temp("DHCOSItem",$j)
	;set PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice="",LabEpisodeNo=""
	;set ARCOSDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(ARCOSRowid)
	;Q:ARCOSDateRowid=""
	
	d GetAllOrderSetItem(ARCOSRowid)
	d Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOrderSetItem(ARCOSRowid,ARCOSDateRowid)
	s item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.do ResetVariables1
	.//添加备注项//医嘱类型项
	.s ljtp=item  ;20120629 liujian
    .s ItemRemark=$g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"NOTES",1))
    .s DHCDocOrderTypeID=$P($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",1)
    .i (DHCDocOrderTypeID'="") s DHCDocOrderType=$P($G(^OECPR(DHCDocOrderTypeID)),"^",2) 
    .i (DHCDocOrderTypeID="") s DHCDocOrderType=""
    .s ItemSpec=""
    .s ItemSpecCode=$P($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",2)
    .i ItemSpecCode'="" s ItemSpec=$p($G(^TTAB("SPEC",ItemSpecCode)),"\",1)
	.s ARCIMRowid=$p(s,"^",1)
	.q:##class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	.s ItemFreqInterval="",ItemFreqFactor="1",ItemDurFactor="1"
	.s Item=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	.s ItemQty=$p(s,"^",2)
	.s ItemDurRowid=$p(s,"^",7)
	.s ItemFreqRowid=$p(s,"^",8)
	.s ItemInstrRowid=$p(s,"^",9)
	.s ItemDoseUOMRowid=$p(s,"^",10)
	.s ItemDoseQty=$p(s,"^",13)
	.s ItemLinkDoctor=$p(s,"^",14)
	.s ItemNO=$p(s,"^",20) //---------------------------------------------------------加入NO用于排序
	.i ItemNO="" s ItemNO=$I(^Temp("DHCOSItem",$j))
	.s ItemBillUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
	.;if ItemQty="" s ItemQty=1
	.if ItemDurRowid'="" d 
	..s ItemDur=$P($G(^PHCDU(ItemDurRowid)),"^",3)
	..s ItemDurFactor=$P($g(^PHCDU(ItemDurRowid)),"^",2)
	.;
	.if ItemFreqRowid'="" d
	..s ItemFreq=$P($G(^PHCFR(ItemFreqRowid)),"^",3)
	..s ItemFreqFactor=$P($g(^PHCFR(ItemFreqRowid)),"^",2)
	..s ItemFreqInterval=$P($g(^PHCFR(ItemFreqRowid)),"^",5)
	.;
	.if ItemInstrRowid'="" s ItemInstr=$P($G(^PHCIN(ItemInstrRowid)),"^",2)
	.if ItemDoseUOMRowid'="" s ItemDoseUOM=$P($G(^CT("UOM",ItemDoseUOMRowid)),"^",2)
	.if ItemBillUOMRowid'="" s ItemBillUOM=$P($G(^CT("UOM",ItemBillUOMRowid)),"^",2)
	.s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	.s ItemOrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	.i ItemOrderType="R" d
	..s PHPrescType=..GetPHPrescType(ItemCatDR)
	..i PHPrescType="3" d
	...s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	...s ItemQty=##class(web.DHCDocOrderEntry).GetPackqty(ARCIMRowid,DrgformRowid,ItemFreqRowid,"",ItemDurRowid,ItemDoseQty,ItemDoseUOMRowid)
	.s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ARCIMRowid, +$H, "", "", "", "")
	.s ItemPrice=$P(retPrice,"^",1)
	.s ARCOSSubCatRowid=$p($g(^ARCOS(ARCOSRowid)),"^",9)
	.s ItemData=ItemDoseQty_$C(1)_ItemDoseUOM_$C(1)_ItemDoseUOMRowid
	.s ItemData=ItemData_"^"_ItemFreq_$C(1)_ItemFreqRowid_$C(1)_ItemFreqFactor_$C(1)_ItemFreqInterval
	.s ItemData=ItemData_"^"_ItemInstr_$C(1)_ItemInstrRowid
	.s ItemData=ItemData_"^"_ItemDur_$C(1)_ItemDurRowid_$C(1)_ItemDurFactor
	.s ItemData=ItemData_"^"_ItemQty_$C(1)_ItemBillUOM_$C(1)_ItemBillUOMRowid
	.s ItemData=ItemData_"^"_DHCDocOrderType_$C(1)_DHCDocOrderTypeID_$C(1)_""
	.s ItemData=ItemData_"^"_ARCOSRowid
	.s ItemData=ItemData_"^^"_ARCOSSubCatRowid_"^"_ItemRemark_"^"_ItemSpecCode
	.;
	.s ItemStatus=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	.i ItemStatus=1 s ItemStatus="停用"
	.e  s ItemStatus=""
	.;do OutputRow1
	.do SetTempGlobe
	;Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetAllOrderSetItem(ARCOSRowid)
	n (ARCOSRowid)
	s ARCOSDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(ARCOSRowid) 
	q:'ARCOSDateRowid  
	d GetOrderSetItem(ARCOSRowid,ARCOSDateRowid)
	;下面是调出医嘱套里的医嘱套,属于嵌套调用
	s it=0 f  s it=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""  s s=^(it) d
	.d GetAllOrderSetItem(+s)
	Q 0
SetTempGlobe
	if ItemLinkDoctor="" s ItemLinkDoctor=ljtp  ;20120629 liujian
	set Data=$lb(Item,ItemQty,ItemBillUOM,ItemDoseQty,ItemDoseUOM,ItemFreq,ItemInstr,ItemDur,ItemData,ARCIMRowid,ItemOrderType,ItemPrice,ItemStatus,ItemRemark,DHCDocOrderType,DHCDocOrderTypeID,ItemSpec,ItemSpecCode)
	if $d(^Temp("DHCOSItem",$j,ItemLinkDoctor)) 
	{
		Set m=$O(^Temp("DHCOSItem",$j,ItemLinkDoctor,""),-1)
		if m="" s m=0
		Set m=m+1
		Set ^Temp("DHCOSItem",$j,ItemLinkDoctor,m)=Data
		Set ^Temp("DHCOSItem",$j,ItemLinkDoctor,m,"Sub")=ItemNO
	}else{
		Set ^Temp("DHCOSItem",$j,ItemLinkDoctor,1)=Data
		Set ^Temp("DHCOSItem",$j,ItemLinkDoctor,1,"Sub")=ItemNO
	}
	quit
Output
	 //先在ItemLinkDoctor节点下将数据按照医嘱项维护好的顺序进行排序，
	s ItemLinkDoctor=""  f  s ItemLinkDoctor=$O(^Temp("DHCOSItem",$j,ItemLinkDoctor)) Q:ItemLinkDoctor=""  d
	.s m=0 f  s m=$O(^Temp("DHCOSItem",$j,ItemLinkDoctor,m)) Q:m=""  d
	..s ItemNO1=$G(^Temp("DHCOSItem",$j,ItemLinkDoctor,m,"Sub"))
	..q:ItemNO1=""
	..s NO=m f  s NO=$O(^Temp("DHCOSItem",$j,ItemLinkDoctor,NO)) Q:NO=""  d
	...s ItemNO2=$G(^Temp("DHCOSItem",$j,ItemLinkDoctor,NO,"Sub"))
	...q:ItemNO2=""
	...i (ItemNO1>ItemNO2)  d
	....s TempDHCOSItem=$G(^Temp("DHCOSItem",$j,ItemLinkDoctor,m))
	....s ^Temp("DHCOSItem",$j,ItemLinkDoctor,m)=^Temp("DHCOSItem",$j,ItemLinkDoctor,NO)
	....s ^Temp("DHCOSItem",$j,ItemLinkDoctor,NO)=TempDHCOSItem
	....s TempNod=$G(^Temp("DHCOSItem",$j,ItemLinkDoctor,m,"Sub"))
	....s ^Temp("DHCOSItem",$j,ItemLinkDoctor,m,"Sub")=^Temp("DHCOSItem",$j,ItemLinkDoctor,NO,"Sub")
	....s ^Temp("DHCOSItem",$j,ItemLinkDoctor,NO,"Sub")=TempNod
	....s ItemNO1=ItemNO2
	
	s ItemLinkDoctor=""  f  s ItemLinkDoctor=$O(^Temp("DHCOSItem",$j,ItemLinkDoctor)) Q:ItemLinkDoctor=""  d
	.s m=0 f  s m=$O(^Temp("DHCOSItem",$j,ItemLinkDoctor,m)) Q:m=""  d
	..q:$G(^Temp("DHCOSItem",$j,ItemLinkDoctor,m,"Sub"))=""
	..s Data=$G(^Temp("DHCOSItem",$j,ItemLinkDoctor,m))
	..i ItemLinkDoctor=0 s SeqNo=""
	..e  d
	...i m=1 s SeqNo=ItemLinkDoctor
	...e  s SeqNo=ItemLinkDoctor_"."_(m-1)
	..s NewLength=$LISTLENGTH(Data)+1
	..s $LIST(Data,NewLength)=SeqNo
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	s ItemLinkDoctor=""  f  s ItemLinkDoctor=$O(^Temp("DHCOSItem",$j,ItemLinkDoctor)) Q:ItemLinkDoctor=""  d
	.s m=0 f  s m=$O(^Temp("DHCOSItem",$j,ItemLinkDoctor,m)) Q:m=""  d
	..q:$G(^Temp("DHCOSItem",$j,ItemLinkDoctor,m,"Sub"))'=""
	..s Data=$G(^Temp("DHCOSItem",$j,ItemLinkDoctor,m))
	..i ItemLinkDoctor=0 s SeqNo=""
	..e  d
	...i m=1 s SeqNo=ItemLinkDoctor
	...e  s SeqNo=ItemLinkDoctor_"."_(m-1)
	..s NewLength=$LISTLENGTH(Data)+1
	..s $LIST(Data,NewLength)=SeqNo
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	Quit
OutputRow1
	set Data=$lb(Item,ItemQty,ItemBillUOM,ItemDoseQty,ItemDoseUOM,ItemFreq,ItemInstr,ItemDur,ItemData,ARCIMRowid,ItemOrderType,ItemPrice,ItemStatus,ItemRemark,DHCDocOrderType,DHCDocOrderTypeID,ItemSpec,ItemSpecCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables1
	set (Item,ItemQty,ItemBillUOM,ItemDoseQty,ItemDoseUOM,ItemFreq,ItemInstr,ItemDur,ItemData,ARCIMRowid,ItemOrderType,ItemData,ItemStatus,ItemRemark,DHCDocOrderType,DHCDocOrderTypeID,ItemSpec,ItemSpecCode)=""
	Quit
}

ClassMethod FindOSItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOSItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetPHPrescType(ItemCatRowid As %String) As %String
{
	Q:ItemCatRowid="" ""
	s ItemType=""
	;草药
	s CNMedItemCat=##Class(web.DHCDocConfig).GetConfigNode("CNMedItemCat")
	i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="3"
	;西药
	s MedItemCat=##Class(web.DHCDocConfig).GetConfigNode("MedItemCat")
	i "^"_MedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="1"
	;中成药
	s CPMedItemCat=##Class(web.DHCDocConfig).GetConfigNode("CPMedItemCat")
	i "^"_CPMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="2"
	s FreqItemCat=##Class(web.DHCDocConfig).GetConfigNode("FrequencedItemCat")
	i "^"_FreqItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="4"
	;精神二类药
	s CNMedItemCat=##Class(web.DHCDocConfig).GetConfigNode("LimitMedItemCat")
	i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="5"
	Q ItemType
}

}
