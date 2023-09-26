/// 标准检验信息服务类
Class DHCMA.CPW.SD.StandSrv.LabStandSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.StandSrv.LabStandSrv","QryLisItem","1","104||338","","")
Query QryLisItem(aSYSDr As %String = "1", aDicID As %String, aOrderAlias As %String, aMatchFlg As %String = "") As %Query(ROWSPEC = "RowID,Code,Desc,ArcDesc,IsActive,checked")
{
}

ClassMethod QryLisItemExecute(ByRef qHandle As %Binary, aSYSDr As %String = "1", aDicID As %String, aOrderAlias As %String, aMatchFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aDicID="") $$$OK
 	Set ^tmpzgz423=$lb(aSYSDr,aDicID,aOrderAlias,aMatchFlg)
 	Set Parref=$p(aDicID,"||",1)
 	//获取检验字典绑定的医嘱
 	Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(Parref)
 	Quit:LinkOrder="" "-1^请先对照检验医嘱，再进行检验项目对照"
 	Set LinkCodeId=..GetLinkCode(aDicID)
 	Set CodeIDArr=""
 	For OrdInd=1:1:$l(LinkOrder,"^") {
	 	Set ArcId=$p(LinkOrder,"^",OrdInd)
	 	Continue:ArcId=""
	 	Set objArc=##class(DHCMA.Util.EPx.OrdMast).GetObjById(ArcId)
	 	Set ArcCode=objArc.BTCode
	 	Set ArcDesc=objArc.BTDesc
	 	Continue:ArcCode=""
	 	Set TestId=$o(^DHCMA.Util.EPx.TestSetI("IdxARCIMCode",aSYSDr,ArcCode,0))
	 	Continue:TestId=""
	 	Set objTest=##class(DHCMA.Util.EPx.TestSet).GetObjById(TestId)
	 	Set TestDesc=objTest.BTDesc
	 	Set xRowID=""
	 	For {
	 		Set xRowID=$o(^DHCMA.Util.EPx.TestSetTCI("IdxOfTestSetTC",TestId,xRowID))
	 		Quit:xRowID=""
	 		Set objCode=##class(DHCMA.Util.EPx.TestCode).GetObjById(xRowID)
	 		//取对照医嘱
		 	Continue:(aMatchFlg="Y")&&(("^"_LinkCodeId_"^")'[("^"_xRowID_"^"))
		 	//取未对照医嘱
		 	Continue:(aMatchFlg="N")&&(("^"_LinkCodeId_"^")[("^"_xRowID_"^"))
		 	Set checked=""
		 	Set:("^"_LinkCodeId_"^")[("^"_xRowID_"^") checked=1
		 	Set Code       = objCode.BTCode
		 	Set Desc       = objCode.BTDesc
		 	Set IsActive   = objCode.BTIsActive 
		 	Continue:(aOrderAlias'="")&&(Desc'[aOrderAlias) 
		 	Continue:$d(CodeIDArr(xRowID))
		 	Set CodeIDArr(xRowID)=""
			Set Data=$lb(xRowID,Code,Desc,TestDesc,IsActive,checked)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}	
 	}
	Quit $$$OK
}

ClassMethod QryLisItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLisItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLisItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLisItemExecute ]
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

/// 根据字典子项ID获取关联的检验项目信息
/// w ##class(DHCMA.CPW.SD.StandSrv.LabStandSrv).GetLinkCode("100||332")
ClassMethod GetLinkCode(aDicID) As %String
{
	New (aDicID)
	Set return=""
	Quit:(aDicID="") return
	Set CodeId=""
	For {
		Set CodeId=$o(^DHCMA.CPW.SD.Stand.TCLI("IdxDicSub",aDicID,CodeId))
		Quit:CodeId=""
		Set objLinkCode=##class(DHCMA.CPW.SD.Stand.TestCodeLink).GetObjById(CodeId)
		Continue:objLinkCode.TestCodeDr=""
		Set TestCodeId=objLinkCode.TestCodeDr.%Id()
		Continue:TestCodeId=""
		Set return=return_TestCodeId_"^"
	}
	Quit return
}

/// 对照字典子项与检验项目
/// w ##class(DHCMA.CPW.SD.StandSrv.LabStandSrv).LinkDicTCode("104||338","506^")
ClassMethod LinkDicTCode(aDicID As %String, aTCodeID As %String = "") As %String
{
	New (aDicID,aTCodeID)
	Set return=""
	Quit:(aDicID'["||") ret
	Set ^tmpzgz421=$lb(aDicID,aTCodeID)
 	Set Count=0
 	//将对照关系清除  再对照
 	Set CRet=..ClearDicLink(aDicID)
 	Quit:+CRet<0 CRet
 	For xTInd=1:1:$l(aTCodeID,"^") {
		Set xTCodeDr=$p(aTCodeID,"^",xTInd)
		Continue:xTCodeDr=""
		Set RowID=""
		If $d(^DHCMA.CPW.SD.Stand.TCLI("IdxDicTC",aDicID,xTCodeDr)) {
			Set RowID=$o(^DHCMA.CPW.SD.Stand.TCLI("IdxDicTC",aDicID,xTCodeDr,0))
		}
		Set InputStr=RowID_$c(1)_aDicID_$c(1)_xTCodeDr
		Set ret=##class(DHCMA.CPW.SD.Stand.TestCodeLink).Update(InputStr,$c(1))
		Set:ret>0 Count=Count+1
 	}
	Quit 1
}

ClassMethod ClearDicLink(aDicID As %String) As %String
{
	New (aDicID)
	Quit:aDicID="" ""
	Set xLinkId="",ret=""
	For {
		Set xLinkId=$o(^DHCMA.CPW.SD.Stand.TCLI("IdxDicSub",aDicID,xLinkId))
		Quit:xLinkId=""
		Set ret=##class(DHCMA.CPW.SD.Stand.TestCodeLink).DeleteById(xLinkId)	
		Quit:+ret<0  
	}
	Quit ret
}

}
