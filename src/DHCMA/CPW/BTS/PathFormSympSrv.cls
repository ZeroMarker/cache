/// 名称: DHCMA.CPW.BTS.PathFormSympSrv
/// 描述: 路径表单 症候+中药方剂 服务类
/// 编写者：zhufei
/// 编写日期: 2019-07-18
Class DHCMA.CPW.BTS.PathFormSympSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2019-07-18
/// Description:  获取路径表单症候+中药方剂信息
/// Table:        DHCMA.CPW.BT.PathFormSymp
/// Input：       aPathFormDr ：路径表单ID
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormSympSrv","QryPathFormSymp",9)
Query QryPathFormSymp(aPathMastDr As %String, aHospID As %String = "") As %Query(ROWSPEC = "PathFormSympDr:%String,PathFormDr:%String,FormVerDesc:%String,SympDiagIDs:%String,SympDiagnos:%String,SympTCMDr:%String,SympTCMDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String")
{
}

ClassMethod QryPathFormSympExecute(ByRef qHandle As %Binary, aPathMastDr As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aPathMastDr="" $$$OK
	
	Set xFormVer=""
	For {
		Set xFormVer=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aPathMastDr,xFormVer))
		Quit:xFormVer=""
		Continue:xFormVer<0
		Set xFormDr=0
		For {
			Set xFormDr=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",aPathMastDr,xFormVer,xFormDr))
			Quit:xFormDr=""

			Set xSympSub=0
			For {
				Set xSympSub=$o(^DHCMA.CPW.BT.PathFormD(xFormDr,"SYMP",xSympSub))
				Quit:xSympSub=""
				
				Set PathFormSympDr=xFormDr_"||"_xSympSub
				Set objFormSymp=##class(DHCMA.CPW.BT.PathFormSymp).GetObjById(PathFormSympDr)
				Continue:'$IsObject(objFormSymp)
				Set objForm=objFormSymp.Parref
				Set PathFormDr=objForm.%Id()
				Set FormVerDesc=objForm.FormVersion
		 		Set FormVerDesc="v"_FormVerDesc_".0"
		 		Set FormIsActive=objForm.FormIsActive
		 		If FormIsActive<1 {
			 		Set FormVerDesc=FormVerDesc_"(作废)"
		 		} Else {
		 			Set FormIsOpen=objForm.FormIsOpen
			 		Set:FormIsOpen>0 FormVerDesc=FormVerDesc_"(已发布)"
			 	}
		 		Set SympDiagIDs=objFormSymp.SympDiagnos
		 		Set SympDiagnos=""
		 		For indx=1:1:$l(SympDiagIDs,","){
			 		Set xSympDiagID=$p(SympDiagIDs,",",indx)
			 		Set xDiagInfo=##Class(DHCMA.CPW.IO.FromDoc).GetMRCICDDX(xSympDiagID)
					Set xSympDesc=$p(xDiagInfo,"^",3)
					Set SympDiagnos=SympDiagnos_","_xSympDesc	
			 	}
			 	Set:SympDiagnos'="" SympDiagnos=$e(SympDiagnos,2,$l(SympDiagnos))
			 	
		 		Set SympTCMDr="",SympTCMDesc=""
		 		If $IsObject(objFormSymp.SympTCMDr){
			 		Set SympTCMDr=objFormSymp.SympTCMDr.%Id()
			 		Set SympTCMDesc=objFormSymp.SympTCMDr.BTDesc
			 	}
			 	Set ActDate=objFormSymp.SympActDate
			 	Set ActTime=objFormSymp.SympActTime
			 	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWHISIODateLogicalToHtml",aHospID)
			 	Set:(ActDate'="")&(ret'=1) ActDate = $ZD(ActDate,3)
			 	Set:(ActDate'="")&(ret=1) ActDate = ##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			 	Set:ActTime'="" ActTime=$ZT(ActTime,1)
			 	Set ActUserID=objFormSymp.SympActUserID
			 	Set ActUserDesc=""
			 	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
			 	If ($IsObject(objUser)) {
			 		Set ActUserDesc=objUser.BTDesc
			 	}
			 	
			 	Set Data=$lb(PathFormSympDr,PathFormDr,FormVerDesc,SympDiagIDs,SympDiagnos,SympTCMDr,SympTCMDesc,ActDate,ActTime,ActUserID,ActUserDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryPathFormSympClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormSympExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormSympFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormSympExecute ]
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

/// Creator:	yankai
/// CreateDate:	2019-12-04
/// Desc:		查询方剂-证型信息
/// Inputs:		方剂ID,症候别称关键字,是否维护[维护：1；未维护：0]
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormSympSrv","QuerySetPattern","")
Query QuerySetPattern(aAlias As %String = "", aHospID As %String = "") As %Query(ROWSPEC = "SympDiaID:%String,SympDiaDesc:%String")
{
}

ClassMethod QuerySetPatternExecute(ByRef qHandle As %Binary, aAlias As %String = "", aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
	Set ID=""
	for{
		Set ID=$o(^MRC("ID",ID))
		Quit:ID=""
		
		If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("MRC_ICDDx",ID,aHospID)
		 	Continue:retFlg'="Y"
		}
		Set ActiveDateFrom=$p($g(^MRC("ID",+ID)),"^",6)
		Continue:(ActiveDateFrom'="")&&(+$h<+ActiveDateFrom)
		Set ActiveDateTo=$p($g(^MRC("ID",+ID)),"^",7)
		Continue:(ActiveDateTo'="")&&(+$h>+ActiveDateTo)
		
		Set BillFlag1=$p($g(^MRC("ID",+ID)),"^",13)
		Set BillFlag3=$p($g(^MRC("ID",+ID)),"^",15)
		Continue:(BillFlag3'="Y")||(BillFlag1'="Y")
		Set PatternDesc=$p($g(^MRC("ID",ID)),"^",2)			//证型描述
		continue:(aAlias'="")&&(PatternDesc'[aAlias)&&(aAlias'[PatternDesc)
		Set Data=$lb(ID,PatternDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		}
	Quit $$$OK
}

ClassMethod QuerySetPatternClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySetPatternExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QuerySetPatternFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySetPatternExecute ]
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

/// Creator:	dengshaopeng
/// CreateDate:	2019-12-07
/// Desc:		查询方剂-证型信息是否允许保存
/// Inputs:		保存字符串
/// w ##class(DHCMA.CPW.BTS.PathFormSympSrv).CheckIsSave("2^^145163^1^^^9!!1")
ClassMethod CheckIsSave(aInStr As %String, aSeparete As %String = "^") As %String
{
	New (aInStr,aSeparete)
	Set return=1
	Quit:aInStr="" return
	Set ^dsp("CheckIsSave")=$lb(aInStr)

	set:$g(aSeparete)="" aSeparete="^"
	set PathFormDr   = $p(aInStr,aSeparete,1)
	set FormSympSub  = $p(aInStr,aSeparete,2)
	set SympDiagnos  = $p(aInStr,aSeparete,3)
	set SympTCMDr    = $p(aInStr,aSeparete,4)
	set ActDate      = +$h
	set ActTime      = $p($h,",",2)
	set ActUserID    = $p(aInStr,aSeparete,7)
	
	If FormSympSub=""{
		Set:$d(^DHCMA.CPW.BT.PathFormI("SYMP","IdxofFormTCMDr",PathFormDr,SympTCMDr)) return=0
	}Else{
		If $d(^DHCMA.CPW.BT.PathFormI("SYMP","IdxofFormTCMDr",PathFormDr,SympTCMDr)){
			Set xID=""
			For {
				Set xID=$o(^DHCMA.CPW.BT.PathFormI("SYMP","IdxofFormTCMDr",PathFormDr,SympTCMDr,xID))
				Quit:xID=""
				
				Set:(return=1)&&(FormSympSub'=xID) return=0	
			}
		}
	}
	
	/*
	Set FormSympID=""
		For
		{
			Set FormSympID = $o(^DHCMA.CPW.BT.PathFormD(PathFormDr,"SYMP",FormSympID))
			Quit:FormSympID=""
			Set objFomSymp = ##class(DHCMA.CPW.BT.PathFormSymp).GetObjById(PathFormDr_"||"_FormSympID)
			Set Path = objFomSymp.Parref.%Id()
			Set SympTCM=objFomSymp.SympTCMDr.%Id()
			Set objSympDiagnos=objFomSymp.SympDiagnos
			Set:(Path=PathFormDr)&&(SympTCMDr=SympTCM)&&(objSympDiagnos=SympDiagnos) return=0
		}
	*/
	Quit return
}

}
