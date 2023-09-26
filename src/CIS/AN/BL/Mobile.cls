/// PAD、pda业务代码
Class CIS.AN.BL.Mobile Extends %RegisteredObject
{

/// Creator: 唐潇
/// CreatDate: 2020-05-08
/// Description: 用户登录
/// Table：SS_User
/// Input：userName, password, locId
/// Return：用户信息
/// w ##class(CIS.AN.BL.Mobile).LogOn("demo","1")
ClassMethod LogOn(userName, password, locId As %String = "")
{
	s ^tmpdebug("xx")=userName_" "_password_"uuu"
	s rowId=""
	
	s rowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userName,rowId))
	i rowId="" s rowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userName),rowId))
	i rowId="" s response="-1:UnknowUser"
	q:rowId="" response
	s userObj=##class(User.SSUser).%OpenId(rowId)
	s response=""
	s json={}
	;s password=$$ENCR^SSUTIL2(password)
	set userid=##class(web.SSUser).IsValidUser(userName,password)
	;i (userObj.SSUSRPassword=password) d
	i userid=rowId d
	.d Add(rowId)
	.d Add(userObj.SSUSRName)
	.d Add(userObj.SSUSREMailName)
	.d Add(userName)
	.d Add(userObj.SSUSRDefaultDeptDR.CTLOCDesc)
	.d Add(userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTDesc)
	.s json.RowId=rowId
	.s json.UserName=userName
	.s json.DefaultLoction=userObj.SSUSRDefaultDeptDR.CTLOCDesc
	.s json.Name=userObj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTDesc
	.s json.CareProvDR=$p(^SSU("SSUSR",rowId),"^",14)
	.s json.Tag=$h
	.s json.LocId=locId
	.i userObj.SSUSRIsThisDoctor="Y" d Add("Doctor") s json.Role="Doctor"
	.e  i userObj.SSUSRNurseFlag="Y" d Add("Nurse") s json.Role="Nurse"
	e  s response="-2"
	q:response="-2" "-2"
	s ^TempANMLogInfo("Session",json.Tag,"UserName")=json.UserName
	s ^TempANMLogInfo("Session",json.Tag,"LogInfo")=json.%ToJSON()
	s ^tmpdebug("response")=json.%ToJSON()
	B
	q json.%ToJSON()
Add(item)
	i response="" s response=item
	e  s response=response_"^"_item
	q response
}

/// Creator: 唐潇
/// CreatDate: 2020-05-08
/// Description: 根据工号找科室
/// Table：CT_Loc
/// Input：userName
/// Return：科室列表
/// D ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","FindLocList","doctor")
Query FindLocList(userName As %String) As %Query(ROWSPEC = "UserId,LocDr,LocCode,LocDesc,GroupDr,GroupDesc,HospitalId,WardId")
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, userName As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s userId=""
	&sql(SELECT SSUSR_RowId into:userId FROM SQLUSER.SS_User WHERE SSUSR_Initials=:userName)
	if (userId="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s defLocDr=$p(^SSU("SSUSR",userId),"^",4)
	s defGroupDr=$p(^SSU("SSUSR",userId),"^",5)
	s defLocDesc="",defLocCode="",defGroupDesc="",HospitalId="",WardId=""
	s:defLocDr'="" defLocCode=$p(^CTLOC(defLocDr),"^",1)
	s:defLocDr'="" defLocDesc=$p(^CTLOC(defLocDr),"^",2)
	s:defLocDr'="" HospitalId=$p(^CTLOC(defLocDr),"^",22)
	s:defLocDr'="" WardId=$O(^PAWARD(0,"WARD_LocationDR",defLocDr,0))
	s:defGroupDr'="" defGroupDesc=$p(^SSU("SSGRP",defGroupDr),"^",1)
	Set ^CacheTemp(repid,ind)=$lb(userId,defLocDr,defLocCode,defLocDesc,defGroupDr,defGroupDesc,HospitalId,WardId)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=ind+1
 	i $d(^SSU("SSUSR",userId,"OTHLL"))>0 d
	.s otherChild=0
	.f  s otherChild=$o(^SSU("SSUSR",userId,"OTHLL",otherChild)) q:otherChild=""  d
	..s curLocDr=$p(^SSU("SSUSR",userId,"OTHLL",otherChild),"^",1)
	..s curGroupDr=$p(^SSU("SSUSR",userId,"OTHLL",otherChild),"^",2)
	..s curLocDesc="",curLocCode="",curGroupDesc="",HospitalId=""
	..s:curLocDr'="" curLocCode=$p(^CTLOC(curLocDr),"^",1)
	..s:curLocDr'="" curLocDesc=$p(^CTLOC(curLocDr),"^",2)
	..s:curLocDr'="" HospitalId=$p(^CTLOC(curLocDr),"^",22)
	..s:curLocDr'="" WardId=$O(^PAWARD(0,"WARD_LocationDR",curLocDr,0))
	..s:curGroupDr'="" curGroupDesc=$p(^SSU("SSGRP",curGroupDr),"^",1)
	..Set ^CacheTemp(repid,ind)=$lb(userId,curLocDr,curLocCode,curLocDesc,curGroupDr,curGroupDesc,HospitalId,WardId)
 	..Set qHandle=$lb(0,repid,0)
 	..Set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: 唐潇
/// CreatDate: 2020-05-08
/// Description: 查手术数据表数据
/// Table：CIS.AN.OperData
/// Input：opsId,moduleCode
/// Return：科室列表
/// Debug:d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","FindOperData", "21", "AN_ANS_004")
Query FindOperData(opsId As %String, moduleCode As %String) As %Query(ROWSPEC = "RowId,RecordSheet,DataItem,DataValue,UpdateUserID,UpdateUserDesc,DataScore,DataNote") [ SqlProc ]
{
}

ClassMethod FindOperDataExecute(ByRef qHandle As %Binary, opsId As %String, moduleCode As %String) As %Status
{
	s opsId=$g(opsId),moduleCode=$g(moduleCode)
	s dataCount=0
	&sql(select count(*) into :dataCount from CIS_AN.OperData where RecordSheet->OperSchedule=:opsId and RecordSheet->DataModule->Code=:moduleCode)
	;b ;test
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (dataCount=0) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s recordSheetID=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	s operDataId=0
	f  s operDataId=$o(^CIS.AN.OperDataI("ISheet",recordSheetID,operDataId)) q:operDataId=""  d
	.;b ;002
	.s operData=^CIS.AN.OperDataD(operDataId)
	.s RecordSheet=$lg(operData,1)
	.s DataItem=$lg(operData,2)
	.s DataValue=$lg(operData,3)
	.s DataValue=$tr(DataValue,$C(9),"")
	.s UpdateUserID=$lg(operData,6)
	.s UpdateUserDesc=""
	.s:UpdateUserID'="" UpdateUserDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",UpdateUserID)
	.s DataScore=$lg(operData,9)
	.s DataNote=$lg(operData,10)
	.s ^CacheTemp(repid,ind)=$lb(operDataId,RecordSheet,DataItem,DataValue,UpdateUserID,UpdateUserDesc,DataScore,DataNote)
	.s qHandle=$lb(0,repid,0)
	.s ind=ind+1
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindOperDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod FindOperDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug: w ##class(CIS.AN.BL.Mobile).SaveOperData("1","PatientHandOver","PosDrugwatename","钠钾镁钙葡萄糖注射液250ml","12378")
ClassMethod SaveOperData(opsId, moduleCode, dataItem, dataValue, userId)
{
	s $zt="Error"
	s opsId=$g(opsId),moduleCode=$g(moduleCode),dataItem=$g(dataItem),dataValue=$g(dataValue),userId=$g(userId)
	s dataValue=$tr(dataValue,$c(9),"")
	q:opsId="" "E^opsId不能为空"
	q:dataItem="" "E^dataItem不能为空"
	q:userId="" "E^userId不能为空"
	
	q:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) "E^opsId不存在"
	q:'##class(User.SSUser).%ExistsId(userId) "E^userId不存在"
	s recordSheetID=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,userId)
	i $d(^CIS.AN.OperDataI("ICode",recordSheetID," "_$System.SQL.UPPER(dataItem)))=0 d 
	.b ;1
	.s operData=##class(CIS.AN.OperData).%New()
	.d operData.RecordSheetSetObjectId(recordSheetID)
	.s operData.DataItem=dataItem
	.s operData.DataValue=dataValue
	.s operData.UpdateDate=+$h
	.s operData.UpdateTime=$p($h,",",2)
	.s operData.UpdateUserID=userId
	.d operData.%Save()
	e  d
	.s operDataId=$o(^CIS.AN.OperDataI("ICode",recordSheetID," "_$System.SQL.UPPER(dataItem),""))
	.s:operDataId="" operData=##class(CIS.AN.OperData).%New()
	.s:operDataId'="" operData=##class(CIS.AN.OperData).%OpenId(operDataId)
	.s operData.DataItem=dataItem
	.s operData.DataValue=dataValue
	.s operData.UpdateDate=+$h
	.s operData.UpdateTime=$p($h,",",2)
	.s operData.UpdateUserID=userId
	.d operData.%Save()
	q "S^"
Error
	q "E^"_$ze
}

/// Debug: w ##class(CIS.AN.BL.Mobile).SaveOperDatas("1","","12378","PatientHandOver")
ClassMethod SaveOperDatas(opsId, itemInfoStr, userId, moduleCode)
{
	s opsId=$g(opsId),itemInfoStr=$g(itemInfoStr),userId=$g(userId),moduleCode=$g(moduleCode)
	q:opsId="" "E^opsId is null"
	q:itemInfoStr="" "E^itemInfoStr is null"
	q:userId="" "E^userId is null"
	q:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) "E^opsId不存在"
	q:'##class(User.SSUser).%ExistsId(userId) "E^userId不存在"
	TSTART
	s strLen=$l(itemInfoStr,$C(2)),errorInfo=""
	f i=1:1:strLen d
	.q:errorInfo'=""
	.s curInfo=$p(itemInfoStr,$C(2),i)
	.i curInfo'="" d
	..s dataItem=$p(curInfo,$C(1),1)
	..s dataValue=$p(curInfo,$C(1),2)
	..s dataValue=$tr(dataValue,$c(9),"")
	..s curRet=..SaveOperData(opsId,moduleCode,dataItem,dataValue,userId)
	..s:$p(curRet,"^",1)="E" errorInfo=curRet
	i errorInfo'="" TRollBack  q errorInfo
	TCOMMIT
	q "S^操作完毕"
}

ClassMethod GetAppVersion()
{
	s ret="{""version"":"""_"3.0"_""",""url"":"""_"https://172.18.18.151:1443/imedical/web/addins/apk/cl/ANMobile.apk"_"""}"
	q ret
}

/// Creator：      	唐潇
/// CreatDate：    	2020-05-08
/// Description： 	签名
/// Table：        	SS_User
/// Input:			rowId 
/// Return：        操作成功与否
/// w ##class(CIS.AN.BL.Mobile).Signature("0713","pWA23%")
ClassMethod Signature(userCode As %String, password As %String, opsId As %String = "", moduleCode As %String = "", signCode As %String = "")
{
 s ret=""
 set userId=##class(web.SSUser).IsValidUser(userCode,password)
 quit:+userId<0 ret
 s ret=$p($G(^SSU("SSUSR",userId)),"^",2)
 s signRet=""
 i (opsId'="")&&(moduleCode'="")&&(signCode'="") d
 .s recordSheetID=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,userId)
 .s signRet=##class(CIS.AN.CA.SignatureService).AccountSign(recordSheetID,signCode,userCode,password)
 q:(signRet'="")&&($p(signRet,"^",1)="E") signRet
 q ret_"^"_$zd(+$h,3)_"^"_$zt($p($h,",",2))_"^"_userId
}

/// w ##class(CIS.AN.BL.Mobile).GetPassword("0713")
ClassMethod GetPassword(userCode As %String)
{
 s ok="",aa="",okk=""
 s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
 q:userId="" "" 
 s pin=$p($G(^SSU("SSUSR",userId)),"^",3)
 s leng=$l(pin)
 q:(leng>12) ""  
 f pp=1:1:leng q:okk="1"  d  
 .s ppp=..Passco(aa,pp,pin) 
 .s aa=$p(ppp,$c(3),1)
 .s pp=$p(ppp,$c(3),2)
 .s okk=$p(ppp,$c(3),3)
 q aa
}

/// usrCode_$c(3)_usrPassword_$c(3)_usrName_$c(2)
ClassMethod Passco(aa As %String, pp As %String, pin As %String)
{
 s ok="",okk=""
 s p=42
 f d=p:1:126 q:ok="1"  d 
 .s h=$c(d)
 .;b
 .i aa="" s ppp=h
 .e  s ppp=aa_""_h 
 .s len=$l(ppp)
 .s pass=$$ENCR^SSUTIL2(ppp)
 .i pass=pin s ok="1",okk="1" 
 .i $e(pass,1,len)=$e(pin,1,len) s ok="1"
 .i ok'="1" s ppp=aa q
 .i aa="" s aa=h
 .e  s aa=aa_""_h
 q aa_$c(3)_pp_$c(3)_okk
}

/// Creator：      	唐潇
/// CreatDate：    	2020-05-08
/// Description： 	获取用户信息
/// Table：        	User.SSUser
/// Input:			用户信息
/// Return：       usrCode_$c(3)_usrPassword_$c(3)_usrName_$c(3)_userId...
/// w ##class(CIS.AN.BL.Mobile).GetUserInfo()
ClassMethod GetUserInfo()
{
 set userId=0,ret=""
 for
 {
 	set userId=$order(^SSU("SSUSR",userId))
 	quit:userId=""
 	set usrDateTo=$p(^SSU("SSUSR",userId),"^",97)
 	continue:((usrDateTo'="")&&(usrDateTo<(+$h)))
 	set usrCode=$p(^SSU("SSUSR",userId),"^",1)
 	set usrName=$p(^SSU("SSUSR",userId),"^",2)
 	set usrPassword=..GetPassword(usrCode)
 	set reti=usrCode_$c(3)_usrPassword_$c(3)_usrName_$c(3)_userId
 	i ret'="" s ret=ret_$c(2)
 	s ret=ret_reti
 }
 quit ret
}

ClassMethod GetServerDateTime()
{
	q $zdt($h)
}

/// Creator: 唐潇
/// CreatDate: 2020-05-08
/// Description: 获取手术清点记录
/// Table：CIS.AN.SurgicalInventoryD
/// Input：opsId, moduleCode, userId
/// Return：RowId,RecordSheetID,SurInventory,SurgicalMaterials,MaterialNote,PreopCount,PreCloseCount,PostCloseCount,PostSewCount,OperAddCount,BarCode,AddCountDesc
/// Debug:d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","GetOperCountData","617", "AN_OPS_006", "10850")
Query GetOperCountData(opsId, moduleCode, userId) As %Query(ROWSPEC = "RowId,RecordSheetID,SurgicalMaterial,MaterialNote,PreopCount,PreCloseCount,PostCloseCount,PostSewCount,OperAddCount,InventoryType,InventoryTypeDesc,AddCountDesc,SterilityPack,SterilityPackDesc") [ SqlProc ]
{
}

ClassMethod GetOperCountDataExecute(ByRef qHandle As %Binary, opsId, moduleCode, userId) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i ('##class(CIS.AN.OperSchedule).%ExistsId(opsId)) Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s recordSheetID=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,userId)
	b ;003
	;i ($d(^CIS.AN.SurgicalInventoryI("ISheet",recordSheetID))=0) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s SurInventoryID=""
	f  s SurInventoryID=$o(^CIS.AN.SurgicalInventoryI("ISheet",recordSheetID,SurInventoryID)) q:SurInventoryID=""  d
	.s SurInventory=^CIS.AN.SurgicalInventoryD(SurInventoryID)
	.s SurgicalMaterial=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),2)
	.s MaterialNote=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),3)
	.s:SurgicalMaterial'="" MaterialNote=$lg(^CT.AN.SurgicalMaterialD(SurgicalMaterial),2)
	.s PreopCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),4)
	.s PreCloseCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),5)
	.s PostCloseCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),6)
	.s PostSewCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),7)
	.s OperAddCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),8)
	.s AddCountDesc=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),9)
	.s InventoryType=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),10)
	.s SterilityPack=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),12)
	.s SterilityPackDesc=""
	.i SterilityPack'="" s SterilityPackDesc=$lg(^CT.AN.SurgicalKitD(SterilityPack),2)
	.s InventoryTypeDesc=InventoryType
	.q:(InventoryType="ZYS")||(InventoryType="ZZS")
	.s:InventoryType="I" InventoryTypeDesc="器械"
	.s:InventoryType="D" InventoryTypeDesc="敷料"
	.s Data=$lb(SurInventoryID,recordSheetID,SurgicalMaterial,MaterialNote,PreopCount,PreCloseCount,PostCloseCount,PostSewCount,OperAddCount,InventoryType,InventoryTypeDesc,AddCountDesc,SterilityPack,SterilityPackDesc)
	.s ^CacheTemp(repid,ind)=Data
	.s qHandle=$lb(0,repid,0)
	.s ind=ind+1
	b ;001
	s SurInventoryID="",ifExit=0
	f  s SurInventoryID=$o(^CIS.AN.SurgicalInventoryI("ISheet",recordSheetID,SurInventoryID)) q:SurInventoryID=""  d
	.s InventoryType=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),10)
	.q:(InventoryType'="ZYS")&&(InventoryType'="ZZS")
	.s SurInventory=^CIS.AN.SurgicalInventoryD(SurInventoryID)
	.s SurgicalMaterial=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),2)
	.s MaterialNote=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),3)
	.s:SurgicalMaterial'="" MaterialNote=$lg(^CT.AN.SurgicalMaterialD(SurgicalMaterial),2)
	.s PreopCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),4)
	.s PreCloseCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),5)
	.s PostCloseCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),6)
	.s PostSewCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),7)
	.s OperAddCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),8)
	.s AddCountDesc=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),9)
	.s SterilityPack=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),12)
	.s SterilityPackDesc=""
	.i SterilityPack'="" s SterilityPackDesc=$lg(^CT.AN.SurgicalKitD(SterilityPack),2)
	.s InventoryTypeDesc=InventoryType
	.s ifExit=1
	.s Data=$lb(SurInventoryID,recordSheetID,SurgicalMaterial,MaterialNote,PreopCount,PreCloseCount,PostCloseCount,PostSewCount,OperAddCount,InventoryType,InventoryTypeDesc,AddCountDesc,SterilityPack,SterilityPackDesc)
	.s ^CacheTemp(repid,ind)=Data
	.s qHandle=$lb(0,repid,0)
	.s ind=ind+1
	/*
	if (ifExit=0)
	{
		set ret1=..SaveOPCountQDZ(recordSheetID,"清点者1","ZYS")
		s Data=$lb(ret1,recordSheetID,"","清点者1","","","","","","ZYS","","")
		s ^CacheTemp(repid,ind)=Data
		s qHandle=$lb(0,repid,0)
		s ind=ind+1
		set ret2=..SaveOPCountQDZ(recordSheetID,"清点者2","ZZS")
		s Data=$lb(ret2,recordSheetID,"","清点者2","","","","","","ZZS","","")
		s ^CacheTemp(repid,ind)=Data
		s qHandle=$lb(0,repid,0)
		s ind=ind+1
	}*/
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetOperCountDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod GetOperCountDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      	唐潇
/// CreatDate：    	2018-05-16
/// Description： 	保存手术清点数据
/// Table：        	DHCAN.Model.SurInventory
/// Input:			opsId , moduleCode , userId , para 
/// Return：        操作成功与否
/// w ##class(CIS.AN.BL.Mobile).SaveSurInventory("1","OperCount","12378","")
ClassMethod SaveSurInventory(opsId As %String, moduleCode As %String, userId As %String, para As %String)
{
	s ^TMPYGB("SaveSurInventory")=$lb(opsId,moduleCode,userId,para)
	s RecordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,userId)
	s savePara=""
	s len=$l(para,$c(2))
	for i=1:1:len
	{
		s surData=$p(para,$c(2),i)
		s surData=surData_$c(1)_"RecordSheet"_$c(0)_RecordSheetId
		;s surData=surData_$c(1)_"ClassName"_$c(0)_"CIS.AN.SurgicalInventory"
		set len2=$l(surData,$c(1))
		for k=1:1:len2
		{
			s surDataItem=$p(surData,$c(1),k)
			if surDataItem["OperAddCount" {
				set addCountItem=$p(surDataItem,"OperAddCount",1)_"AddCountDesc"_$p(surDataItem,"OperAddCount",2)
				set surData=surData_$c(1)_addCountItem
				b ;1
			}
		}
		s:savePara'="" savePara=savePara_$c(2)
		s savePara=savePara_surData
	}
	s ret=##class(CIS.AN.COM.DataService).SaveDataList(savePara)
	q ret
}

/// Creator：      	唐潇
/// CreatDate：    	2018-05-16
/// Description： 	保存通过手术包ID保存手术清点数据
/// Table：        	DHCAN.Model.SurInventory
/// Input:			opsId , moduleCode , userId , surgicalKits, RecordSheet
/// Return：        操作成功与否
/// w ##class(CIS.AN.BL.Mobile).SaveSurInventoryBySurkit("1559","operCount","533","9")
ClassMethod SaveSurInventoryBySurkit(opsId As %String, moduleCode As %String, userId As %String, surgicalKits As %String, itemType As %String = "")
{
	s ^TMPYGB("SaveSurInventoryBySurkit")=surgicalKits
	s surgicalKits=$g(surgicalKits)
	s RecordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,userId)
	s saveInfo=""
	s kitMateId=0
	f  s kitMateId=$o(^CT.AN.SurgicalKitMatI("IKit",surgicalKits,kitMateId)) q:kitMateId=""  d
	.s kitMate=##class(CT.AN.SurgicalKitMat).%OpenId(kitMateId)
	.s SurgicalMaterials=kitMate.SurgicalMaterial ;手术物品
	.q:(##class(CT.AN.SurgicalMaterial).%ExistsId(SurgicalMaterials.%Id())=0)
	.s DefaultQty=kitMate.DefaultQty ;默认数量
	.s curInfo="RecordSheet"_$c(0)_RecordSheetId
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"SurgicalMaterial"_$c(0)_SurgicalMaterials.%Id()
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"MaterialNote"_$c(0)_SurgicalMaterials.Note
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"PreopCount"_$c(0)_DefaultQty
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"PreCloseCount"_$c(0)_""
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"PostCloseCount"_$c(0)_""
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"PostSewCount"_$c(0)_""
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"OperAddCount"_$c(0)_""
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"InventoryType"_$c(0)_itemType
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"ClassName"_$c(0)_"CIS.AN.SurgicalInventory"
	.s:saveInfo'="" saveInfo=saveInfo_$c(2)
	.s saveInfo=saveInfo_curInfo
	s ^TMPYGB("SaveSurInventoryBySurkit",1)=saveInfo
	s ret=##class(CIS.AN.COM.DataService).SaveDataList(saveInfo)
	
	q ret
}

/// Creator：      	唐潇
/// CreatDate：    	2018-05-16
/// Description： 	删除清点数据
/// Table：        	DHCAN.Model.SurInventory
/// Input:			rowId
/// Return：        操作成功与否
/// w ##class(CIS.AN.BL.Mobile).DeleteSurInventory("1")
ClassMethod DeleteSurInventory(rowId As %String)
{
	q:rowId="" "rowId为空"
	q:'##class(CIS.AN.SurgicalInventory).%ExistsId(rowId) "^E:rowId不存在"
	s sc =	##class(CIS.AN.SurgicalInventory).%DeleteId(rowId)
	i $$$ISERR(sc){
		q "E^删除失败" 
	}else{
		q "S^删除成功"
	}
}

/// Creator：      	唐潇
/// CreatDate：    	2019-11-20
/// Description： 	查询手术物品
/// Table：        	DHCAN.Code.SurMaterials
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","FindSurMaterials","直")
Query FindSurMaterials(descFilter As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT *
	from CT_AN.SurgicalMaterial 
	where (UPPER(Description) like UPPER('%'_:descFilter_'%')) or (UPPER(Code) like UPPER('%'_:descFilter_'%')) or (:descFilter is null)
}

/// Creator：      	唐潇
/// CreatDate：    	2019-11-20
/// Description： 	查询手术包
/// Table：        	DHCAN_Code.SurgicalKits
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","FindSurgicalKits")
Query FindSurgicalKits(descFilter As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT *
	from CT_AN.SurgicalKit
	where (UPPER(Description) like UPPER('%'_:descFilter_'%')) or (UPPER(Code) like UPPER('%'_:descFilter_'%')) or (:descFilter is null)
	and (Active='Y') and (not MainKit is null)
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","FindDepartments","")
Query FindDepartments(filterDesc As %String, deptId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT CTLOC_RowId As RowId,
	CTLOC_Desc As DeptDesc,
	CTLOC_Code As DeptCode
	from SQLUser.CT_Loc 
	where (CTLOC_RowId=:deptId or :deptId is null)
	and (CTLOC_DateActiveFrom<=+$h)
	and ((CTLOC_DateActiveTo>=+$h) or (CTLOC_DateActiveTo is null))
	and ((UPPER(CTLOC_Desc) [ UPPER(:filterDesc)) or (UPPER(CTLOC_ContactName) [ UPPER(:filterDesc)) or :filterDesc is null )
}

/// Creator：      	唐潇
/// CreatDate：    	2020-5-7
/// Description： 	保存通过消毒包条码保存手术清点数据
/// Table：        	DHCAN.Model.SurInventory
/// Input:			opsId , moduleCode , userId , scanCode
/// Return：        操作成功与否
/// w ##class(DHCAN.BLL.ANMobileNew).SaveSurInventoryBySurkit("5","operCount","533","2")
ClassMethod SaveSurInventoryBySterPack(opsId As %String, moduleCode As %String, userId As %String, scanCode As %String, itemType As %String = "") As %String
{
	s $zt="Error"
	s opsId=$g(opsId),moduleCode=$g(moduleCode),userId=$g(userId),scanCode=$g(scanCode)
	q:opsId="" "E^opsId is null"
	q:moduleCode="" "E^moduleCode is null"
	q:userId="" "E^userId is null"
	q:scanCode="" "E^scanCode is null"
	s RecordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,userId)
	q:$d(^CIS.AN.SterilityPackI("BarCode"," "_scanCode)) "E^消毒包已使用"
	//调用供应室接口往CIS,AN.SterilityPack表插入数据
	//s interfaceRet=##class(web.DHCANImportDataNMGZL).GetSterilityPackage(RecordSheetId,scanCode)
	//q:interfaceRet'=0 "E^"_$p(interfaceRet,"^",2)
	q:$d(^CIS.AN.SterilityPackI("IBarCode"," "_scanCode))=0 "E^无法找到条码对应的消毒包"
	s packId=$o(^CIS.AN.SterilityPackI("IBarCode"," "_scanCode,0))
	s sterilityItemId=0,saveInfo=""
	f  s sterilityItemId=$o(^CIS.AN.SterilityItemI("ISterilityPack",packId,sterilityItemId)) q:sterilityItemId=""  d
	.s sterilityItem=##class(CIS.AN.SterilityItem).%OpenId(sterilityItemId)
	.s curInfo="RecordSheet"_$c(0)_RecordSheetId
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"MaterialNote"_$c(0)_sterilityItem.ItemDesc
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"PreopCount"_$c(0)_sterilityItem.Qty
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"PreCloseCount"_$c(0)_""
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"PostCloseCount"_$c(0)_""
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"PostSewCount"_$c(0)_""
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"OperAddCount"_$c(0)_""
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"InventoryType"_$c(0)_itemType
	.s curInfo=curInfo_$c(1)
	.s curInfo=curInfo_"ClassName"_$c(0)_"CIS.AN.SurgicalInventory"
	.s:saveInfo'="" saveInfo=saveInfo_$c(2)
	.s saveInfo=saveInfo_curInfo
	s ret=##class(CIS.AN.COM.DataService).SaveDataList(saveInfo)
	//回传给消毒供应室
	q ret
Error
	q "E^"_$ze
}

/// Creator：      	杨国宾
/// CreatDate：    	2020-10-21
/// Description： 	保存扫码时间(入手术室、入手术间)
/// Table：        	CIS.AN.SurgicalProcedure,CIS.AN.Anaesthesia
/// Input:			opsId , userId ,
/// Return：        操作成功与否
/// w ##class(DHCAN.BLL.ANMobileNew).SaveSurInventoryBySurkit("5","operCount","533","2")
ClassMethod SaveSurgicalProcedure(opsId As %String, PatLocation As %String, userId As %String) As %String
{
	set $zt="Error"
	set result="S^"
	if PatLocation="入手术室" set PatLocation="AI"
	if PatLocation="入手术间" set PatLocation="RI"
	if PatLocation="出手术室" set PatLocation="AO"
	if PatLocation="出手术间" set PatLocation="RO"
	set opsId=$g(opsId),userId=$g(userId)
	quit:opsId="" "E^opsId is null"
	set result=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,PatLocation,userId,+$h,$P($h,",",2),"PI")
	quit:($p(result,"^",1)'="S") result
	///同步到麻醉单数据
	
	set Anaesthesia=""
	&sql(select RowId into :Anaesthesia from CIS_AN.Anaesthesia where OperSchedule=:opsId)
	if (##class(CIS.AN.Anaesthesia).%ExistsId(Anaesthesia))
	{
		set OBJAnaest=##class(CIS.AN.Anaesthesia).%OpenId(Anaesthesia)	
	}	
	else
	{
		set OBJAnaest=##class(CIS.AN.Anaesthesia).%New() 	
	}
	if PatLocation="AI" set OBJAnaest.AreaInDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,$P($h,",",2))
	if PatLocation="RI" set OBJAnaest.TheatreInDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,$P($h,",",2))
	if PatLocation="AO" set OBJAnaest.AreaOutDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,$P($h,",",2))
	if PatLocation="RO" set OBJAnaest.TheatreOutDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,$P($h,",",2))
	set sc=OBJAnaest.%Save()		
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
Error
	q "E^"_$ze
}

/// w ##class(CIS.AN.BL.Mobile).GetLastProcedureId(869)
ClassMethod GetLastProcedureId(opsId As %String, ActionWay As %String = "PI") As %String
{
	set procedureCode=""
	&sql(select %External(ProcedureCode) into :procedureCode from CIS_AN.SurgicalProcedure where OperSchedule=:opsId and ActionWay=:ActionWay order by UpdateDate DESC , UpdateTime DESC)
	quit procedureCode
}

/// Creator: 杨国宾
/// CreatDate: 2020-10-30
/// Description: 获取手术清点记录清点者(深圳南山)
/// Table：CIS.AN.SurgicalInventory
/// Input：opsId, moduleCode, userId
/// Return：RowId,RecordSheetID,SurInventory,SurgicalMaterials,MaterialNote,PreopCount,PreCloseCount,PostCloseCount,PostSewCount,OperAddCount,BarCode,AddCountDesc
/// Debug:d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","GetOperCountData","35", "AN_OPS_006", "10211")
Query GetOperCountQDZData(opsId, moduleCode, userId) As %Query(ROWSPEC = "RowId,RecordSheetID,SurgicalMaterial,MaterialNote,PreopCount,PreCloseCount,PostCloseCount,PostSewCount,OperAddCount,InventoryType,InventoryTypeDesc,AddCountDesc") [ SqlProc ]
{
}

ClassMethod GetOperCountQDZDataExecute(ByRef qHandle As %Binary, opsId, moduleCode, userId) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i ('##class(CIS.AN.OperSchedule).%ExistsId(opsId)) Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s recordSheetID=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,userId)
	i ($d(^CIS.AN.SurgicalInventoryI("ISheet",recordSheetID))=0) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s SurInventoryID="",ifExit=0
	f  s SurInventoryID=$o(^CIS.AN.SurgicalInventoryI("ISheet",recordSheetID,SurInventoryID)) q:SurInventoryID=""  d
	.s InventoryType=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),10)
	.q:(InventoryType'="ZYS")&&(InventoryType'="ZZS")
	.s SurInventory=^CIS.AN.SurgicalInventoryD(SurInventoryID)
	.s SurgicalMaterial=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),2)
	.s MaterialNote=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),3)
	.s:SurgicalMaterial'="" MaterialNote=$lg(^CT.AN.SurgicalMaterialD(SurgicalMaterial),2)
	.s PreopCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),4)
	.s PreCloseCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),5)
	.s PostCloseCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),6)
	.s PostSewCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),7)
	.s OperAddCount=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),8)
	.s AddCountDesc=$lg(^CIS.AN.SurgicalInventoryD(SurInventoryID),9)
	.s InventoryTypeDesc=InventoryType
	.s ifExit=1
	.s Data=$lb(SurInventoryID,recordSheetID,SurgicalMaterials,MaterialNote,PreopCount,PreCloseCount,PostCloseCount,PostSewCount,OperAddCount,InventoryType,InventoryTypeDesc,AddCountDesc)
	.s ^CacheTemp(repid,ind)=Data
	.s qHandle=$lb(0,repid,0)
	.s ind=ind+1
	if (ifExit=0)
	{
		set ret1=..SaveOPCountQDZ(recordSheetID,"清点者1","ZYS")
		s Data=$lb(ret1,recordSheetID,"","清点者1","","","","","","ZYS","","")
		s ^CacheTemp(repid,ind)=Data
		s qHandle=$lb(0,repid,0)
		s ind=ind+1
		set ret2=..SaveOPCountQDZ(recordSheetID,"清点者1","ZYS")
		s Data=$lb(ret2,recordSheetID,"","清点者2","","","","","","ZZS","","")
		s ^CacheTemp(repid,ind)=Data
		s qHandle=$lb(0,repid,0)
		s ind=ind+1
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetOperCountQDZDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperCountQDZDataExecute ]
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

ClassMethod GetOperCountQDZDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperCountQDZDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveOPCountQDZ(recordSheetID, note, Type)
{
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetID)
	set SurgicalInventory=##class(CIS.AN.SurgicalInventory).%New()
	set SurgicalInventory.RecordSheet=recordSheet
	set SurgicalInventory.MaterialNote=note
	set SurgicalInventory.InventoryType=Type
	set sc=SurgicalInventory.%Save()
	set SurgicalInventoryId=""
	b ;007
	if ($System.Status.IsError(sc))
	{
		set SurgicalInventoryId="E^"_$System.Status.GetErrorText(sc)	
	}	
	else
	{
		set SurgicalInventoryId=SurgicalInventory.%Id()	
	}
	quit SurgicalInventoryId
}

/// w ##class(CIS.AN.BL.Mobile).GetSheetEditFlag(628,"AN_OPS_006",10850,51)
ClassMethod GetSheetEditFlag(opsId, moduleCode, userId, groupId)
{
	s recordSheetID=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,userId)
	s ret=##class(CIS.AN.BL.RecordSheet).GetSheetEditFlag(recordSheetID,userId,groupId)
	q ret
}

/// w ##class(CIS.AN.BL.Mobile).GetPadSheets(51)
ClassMethod GetPadSheets(GroupId)
{
	set GroupSettingQuery=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindGroupSetting")
	set sc=GroupSettingQuery.Execute(GroupId)
	set moduleStrId=""
	while(GroupSettingQuery.Next())
	{
		set moduleStrId=GroupSettingQuery.Get("PadSheet")	
	}
	quit:moduleStrId="" ""
	set moduleCodeStr=""
	for i=1:1:$l(moduleStrId,",")
	{
		set moduleId=$p(moduleStrId,",",i)
		continue:'##class(CT.AN.DataModule).%ExistsId(moduleId)
		set DataModule=##class(CT.AN.DataModule).%OpenId(moduleId)
		set moduleCode=DataModule.Code
		continue:moduleCode=""
		if moduleCodeStr'="" set moduleCodeStr=moduleCodeStr_"," 
		set moduleCodeStr=moduleCodeStr_moduleCode
	}
	quit moduleCodeStr
}

/// Creator: 余夕
/// CreatDate: 2021-06-21
/// Description: 获取检查目录
/// Input：AEpisodeID
/// Return：
/// Debug:d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","GetPathologyAppList","77","")
Query GetPathologyAppList(opsId, AEpisodeID = "") As %Query(ROWSPEC = "No,testName,testAppDT,url") [ SqlProc ]
{
}

ClassMethod GetPathologyAppListExecute(ByRef qHandle As %Binary, opsId, AEpisodeID) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	 
	s testName="术中冰冻检查与诊断"
	s testAppDT="2021-05-26 19:28:01"
	s url="http://10.17.2.110/upload/pdf/FS2100032_first_20210526195323.pdf@http://10.17.2.110/upload/pdf/FS2100032_first_20210526195323.pdf@http://10.17.2.110/upload/pdf/FS2100032_first_20210526195323.pdf"
	s No="FLIV2021052600001"
	s Data=$lb(No,testName,testAppDT,url)
	s ^CacheTemp(repid,ind)=Data
	

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetPathologyAppListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod GetPathologyAppListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 余夕
/// CreatDate: 2021-06-21
/// Description: 获取病历目录
/// Input：AEpisodeID
/// Return：EMRName,EMRInstanceID
/// Debug:d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","GetEMRList","77")
Query GetEMRList(opsId, AEpisodeID = "") As %Query(ROWSPEC = "EMRName,EMRInstanceID,url") [ SqlProc ]
{
}

ClassMethod GetEMRListExecute(ByRef qHandle As %Binary, opsId, AEpisodeID) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s EMRName="输血血液制品治疗知情同意书"
	s EMRInstanceID="3174||2"
	s url="http://10.17.0.1/imedical/web/form.htm?TPSID=APP0001"
	s Data=$lb(EMRName,EMRInstanceID,url)
	s ^CacheTemp(repid,ind)=Data
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetEMRListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod GetEMRListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 余夕
/// CreatDate: 2021-06-21
/// Description: 获取检验目录
/// Input：RegNo：登记号
/// Return：TSRowId：检验报告id,TSName：检验描述
/// Debug:d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","GetLISReportList","0000000680")
Query GetLISReportList(RegNo) As %Query(ROWSPEC = "TSRowId,TSName,TestResult") [ SqlProc ]
{
}

ClassMethod GetLISReportListExecute(ByRef qHandle As %Binary, RegNo) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	

	;s rest=##class(%ResultSet).%New("LISService.Business.LISReport:QryTestSet")
	;do rest.Execute(RegNo,"","","","0")
	
	
	set TSRowId="2098"
	set TSName="ABO血型+Rh(D)血型鉴定"
	
	s rest=##class(%ResultSet).%New("CIS.AN.BL.Mobile:GetLISResultList")
	do rest.Execute(TSRowId)
	set TestResult=""
	while (rest.Next())  //TestName,Result,TextRes
	{
		set TestName=rest.Get("TestName")
		set Result=rest.Get("Result")
		set AbFlag=rest.Get("AbFlag")
		set RefRanges=rest.Get("RefRanges")
		if TestResult="" set TestResult=TestName_"$"_Result_"$"_AbFlag_"$"_RefRanges
		else  set TestResult=TestResult_"^"_TestName_"$"_Result_"$"_AbFlag_"$"_RefRanges
	}
	
	s Data=$lb(TSRowId,TSName,TestResult)
	s ^CacheTemp(repid,ind)=Data

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetLISReportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod GetLISReportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: 余夕
/// CreatDate: 2021-08-24
/// Description: 获取检验结果目录
/// Input：TSRowId：登记号
/// Return：TSRowId：检验报告id,TSName：检验描述
/// Debug:d ##class(%ResultSet).RunQuery("CIS.AN.BL.Mobile","GetLISResultList","2098")
Query GetLISResultList(TSRowId) As %Query(ROWSPEC = "TestName,Result,AbFlag,RefRanges") [ SqlProc ]
{
}

ClassMethod GetLISResultListExecute(ByRef qHandle As %Binary, TSRowId) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	set dataArr(1,"TestName")="ABO血型鉴定"
	set dataArr(1,"Result")="A型"
	set dataArr(1,"AbFlag")="H"
	set dataArr(1,"RefRanges")="1.0-2.0"
	set dataArr(2,"TestName")="Rh（D）血型鉴定"
	set dataArr(2,"Result")="阳性(+)"
	set dataArr(2,"AbFlag")=""
	set dataArr(2,"RefRanges")=""
	
	for i=1:1:2{
		set TestName=dataArr(i,"TestName")
		set Result=dataArr(i,"Result")
		set AbFlag=dataArr(i,"AbFlag")
		set RefRanges=dataArr(i,"RefRanges")
		s Data=$lb(TestName,Result,AbFlag,RefRanges)
		s ^CacheTemp(repid,ind)=Data
		s qHandle=$lb(0,repid,0)
		s ind=ind+1
	}
	

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetLISResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod GetLISResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindFLBSurgicalKitMat() As %SQLQuery(CONTAINID = 1)
{
    select RowId,
           SurgicalKit,
           SurgicalKit->Description As SurgicalKitDesc,
           SurgicalMaterial,
           SurgicalMaterial->Description As SurgicalMaterialDesc,
           SurgicalMaterial->Unit As Unit,
           DefaultQty,
           PericardialCut,
           Seq
           from CT_AN.SurgicalKitMat
           where (SurgicalKit='2')
           order by Seq
}

}
