Import SQLUser

/// 创建人:Mozy 2021-11-26
/// 设备情况登记记录
Class web.DHCEQ.BA.BUSStateInfo Extends %Library.RegisteredObject [ ClassType = "" ]
{

/// Mozy 2021-11-26
/// 保存
/// 入参:
/// 			data-设备运行情况信息
/// 			EquipDRStr-设备ID串(逗号分隔)
/// 			SIRowIDStr-登记记录ID串(逗号分隔)
/// 			TMPFileNo-临时设备登记标识
/// 			User-处置人
/// w ##Class(web.DHCEQ.BA.BUSStateInfo).SaveData("","4",1,12214)
ClassMethod SaveData(data, EquipDRStr As %String = "", SIRowIDStr As %String = "", TMPFileNo As %String = "", User As %String = "")
{
	// MZY0116	2475924,2493291		2022-03-14
	i (data="")||((EquipDRStr="")&&(SIRowIDStr="")&&(TMPFileNo="")) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9201", "不能为空!")
	;s ^DHCEQMozy("web.DHCEQ.BA.BUSStateInfo.SaveData")=data_","_EquipDRStr_","_SIRowIDStr_","_TMPFileNo_","_User
	s $ZT="ERRORSaveData"
	k PLIST
	s SQLCODE=0
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQStateInfo", JsonData, .PLIST)
	
	Set PLIST(4)=Date				; SI_RecordDate
	Set TotalTime=0
	If JsonData.%Get("SIEndDate")>=JsonData.%Get("SIStartDate")
	{
		Set TotalTime=(PLIST(7)-PLIST(5))*24*3600+PLIST(8)-PLIST(6)
		If TotalTime<0 Set TotalTime=0
		Set TotalTime=##Class(web.DHCEQCommon).FormatNumber(TotalTime/3600,0,0)
	}
	Set PLIST(9)=TotalTime					; SI_TotalTime
	If (JsonData.%Get("SIStartState")="")||(JsonData.%Get("SIStartState")="正常") Do
	.Set PLIST(11)="正常"
	.Set PLIST(12)=""
	Else  Do
	.Set PLIST(11)="异常"
	.Set PLIST(12)=JsonData.%Get("SIStartState")	; SI_StartStateInfo
	If (JsonData.%Get("SIEndState")="")||(JsonData.%Get("SIEndState")="正常") Do
	.Set PLIST(13)="正常"
	.Set PLIST(14)=""
	Else  Do
	.Set PLIST(13)="异常"
	.Set PLIST(14)=JsonData.%Get("SIEndState")  	; SI_EndStateInfo
	Set PLIST(18)=0  						; SI_Status	",新增,提交,审核,作废"	",0,1,2,3"
	Set PLIST(19)="N"          				; SI_InvalidFlag 无效标志
	Set PLIST(23)=User   					; SI_UpdateUserDR
	Set PLIST(24)=Date  					; SI_UpdateDate
	Set PLIST(25)=Time  					; SI_UpdateTime
	Set PLIST(43)=""          					; SI_Sex ; add by cjt 20220918 需求号2887750
	If (JsonData.%Get("SISex")="男") Set PLIST(43)=1
	If (JsonData.%Get("SISex")="女") Set PLIST(43)=2
	
 	TSTART
 	
 	; 优先更新记录
	if SIRowIDStr'=""
	{
		Set quantity=$L(SIRowIDStr,",")
		for i=1:1:quantity
		{
			Set RowID=$Piece(SIRowIDStr,",",i)  ; SI_RowID
			&SQL(update sqluser.DHC_EQStateInfo values :PLIST() where SI_RowID=:RowID and SI_Status=0)
			q:SQLCODE
		}
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	if EquipDRStr'=""
	{
		Set PLIST(20)=User  			; SI_AddUserDR
		Set PLIST(21)=Date  			; SI_AddDate
		Set PLIST(22)=Time  			; SI_AddTime
		Kill PLIST(32)					; 删除临时码
		Set quantity=$L(EquipDRStr,",")
		for i=1:1:quantity
		{
			Set PLIST(3)=$Piece(EquipDRStr,",",i)  ; SI_EquipDR
			&SQL(insert into sqluser.DHC_EQStateInfo values :PLIST())
			q:SQLCODE
		}
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	if TMPFileNo'=""
	{
		Kill PLIST(3)					; 删除设备DR
		Set PLIST(32)=TMPFileNo
		&SQL(insert into sqluser.DHC_EQStateInfo values :PLIST())
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, SQLCODE)
	
ERRORSaveData
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000", ErrorMsg)
}

/// Mozy 2021-11-26
/// 删除
/// 入参:
/// 			DRStr-记录ID串
/// 			User-处置人
/// w ##Class(web.DHCEQ.BA.BUSStateInfo).DeleteStateInfo("1,2,3,4","")
ClassMethod DeleteStateInfo(DRStr As %String = "", User As %String = "")
{
	i (DRStr="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9201", "不能为空!")
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	Set $ZT="ERRORDeleteData"
	TSTART
	s Date=+$H
	s Time=$P($H,",",2)
	Set quantity=$L(DRStr,",")
	for i=1:1:quantity
	{
		Set RowID=$Piece(DRStr,",",i)  		; SI_RowID
		i $p($g(^DHCEQStateInfo(RowID)),"^",17)=0 &SQL(Update SQLUSER.DHC_EQStateInfo Set SI_InvalidFlag='Y',SI_UpdateUserDR=:User,SI_UpdateDate=:Date,SI_UpdateTime=:Time where SI_RowID=:RowID)
		q:SQLCODE
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
 	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORDeleteData
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000", ErrorMsg)
}

/// Mozy 2021-12-22
/// 提交审核
/// 入参:
/// 			DRStr-记录ID串
/// 			User-处置人
/// w ##Class(web.DHCEQ.BA.BUSStateInfo).AuditStateInfo("1","1")
ClassMethod AuditStateInfo(DRStr As %String = "", User As %String = "")
{
	i (DRStr="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9201", "不能为空!")
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	Set $ZT="ERRORAuditStateInfo"
	TSTART
	s Date=+$H
	s Time=$P($H,",",2)
	s SQLCODE=0
	Set quantity=$L(DRStr,",")
	for i=1:1:quantity
	{
		Set RowID=$Piece(DRStr,",",i)  		; SI_RowID
		i $p($g(^DHCEQStateInfo(RowID)),"^",17)=0 &SQL(Update SQLUSER.DHC_EQStateInfo Set SI_Status=2, SI_SubmitUserDR=:User,SI_SubmitDate=:Date, SI_SubmitTime=:Time, SI_AuditUserDR=:User, SI_AuditDate=:Date, SI_AuditTime=:Time where SI_RowID=:RowID)
		q:SQLCODE'=0
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
 	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORAuditStateInfo
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000", ErrorMsg)
}

/// RecordFlag:查询记录标志(非空:仅用于查询)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSStateInfo","GetStateInfo","","1","","","","","","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSStateInfo","GetStateInfo","","1","","","1","","","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSStateInfo","GetStateInfo","","","","","","78","","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSStateInfo","GetStateInfo","","","电视机","","1","","","","","")
Query GetStateInfo(PFileNo As %String = "", PNo As %String = "", PName As %String = "", PRecordDate As %String = "", PRecordFlag As %String = "", TMPFileNo As %String = "", PLoc As %String = "", PUser As %String = "", PStartDate As %String = "", PEndDate As %String = "", PGroup As %String = "") As %Query(ROWSPEC = "TRow:%String,SIRowID:%String,SIType:%String,SIEquipDR:%String,SIEquip_Name:%String,SIEquip_FileNo:%String,SIEquip_No:%String,SIEquip_Model:%String,SILeaveFactoryNo:%String,SIEquip_StoreLoc:%String,SIEquip_EquipType:%String,SIRecordDate:%String,SIStartDate:%String,SIStartTime:%String,SIEndDate:%String,SIEndTime:%String,SITotalTime:%String,SIUseContent:%String,SIStartState:%String,SIStartStateInfo:%String,SIEndState:%String,SIEndStateInfo:%String,SIUserDR:%String,SIUserDR_SSUSRName:%String,SIPatientID:%String,SIRemark:%String,SIStatus:%String,SIInvalidFlag:%String,SIAddUser:%String,SIAddDate:%String,SIAddTime:%String,SIUpdateUser:%String,SIUpdateDate:%String,SIUpdateTime:%String,SISubmitUser:%String,SISubmitDate:%String,SISubmitTime:%String,SIAuditUser:%String,SIAuditDate:%String,SIAuditTime:%String,SITMPFileNo:%String,SIEQName:%String,SIModelDR:%String,SIModelDR_MDesc:%String,SISnNumber:%String,SIStoreLocDR:%String,SIStoreLoc:%String,SIWardCode:%String,SIWardName:%String,SIBedNo:%String,SIUseLocDR:%String,SIUseLocDR_CTLOCDesc:%String,SIOrigin:%String,SIPatientName:%String,SISex:%String,SIAgeYr:%String,SIAgeMth:%String,SIAgeDay:%String,SITemperature:%String,SIHumidity:%String,SINoType:%String,SINo:%String,SILocation:%String,SINurse:%String,SIDisinfectFlag:%String,SIDisinfector:%String,SIHold1:%String,SIHold2:%String,SIHold3:%String,SIHold4:%String,SIHold5:%String")
{
}

ClassMethod GetStateInfoExecute(ByRef qHandle As %Binary, PFileNo As %String = "", PNo As %String = "", PName As %String = "", PRecordDate As %String = "", PRecordFlag As %String = "", TMPFileNo As %String = "", PLoc As %String = "", PUser As %String = "", PStartDate As %String = "", PEndDate As %String = "", PGroup As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	If (PFileNo="")&&(PNo="")&&(PName="")&&(PRecordFlag="")&&(TMPFileNo="") Quit $$$OK
 	
	Set Row=1
	Set index=1
	;Set ^DHCEQMozy("GetStateInfo")=PFileNo_","_PNo_","_PName_","_PRecordDate_","_PRecordFlag_","_TMPFileNo_","_PLoc_","_PUser_","_PStartDate_","_PEndDate
 	Set PFileNo=$ZCONVERT(PFileNo ,"U")
 	Set PNo=$ZCONVERT(PNo ,"U")
 	Set PName=$ZCONVERT(PName ,"U")
 	If PStartDate'="" Set PStartDate=##Class(web.DHCEQCommon).TransValueFromPage(PStartDate,"date")
 	If PEndDate'="" Set PEndDate=##Class(web.DHCEQCommon).TransValueFromPage(PEndDate,"date")
 	Set ShowLines=3	;设置默认每台设备显示记录数
 	
 	i (TMPFileNo="")&&(PRecordFlag="")
 	{
		s rowid=0
		f  s rowid=$o(^DHCEQEquip(rowid)) quit:rowid=""  d
		.d ResetVariablesGetStateInfo
		.s SIEquipDR = rowid
		.d GetDataEquip
		.s passed=1	// MZY0116	2475924,2493291		2022-03-14
		.d CheckDataEquip
		.q:passed=0
		.// MZY0116	2475924,2493291		2022-03-14
		.;s SIEquipModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model", $p($g(^DHCEQEquip(SIEquipDR)),"^",3))
		.;s SILeaveFactoryNo = $p($g(^DHCEQEquip(SIEquipDR)),"^",10)
		.;s SIEquipStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", StoreLocDR)
		.;s SIEquipEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", EquipTypeDR)
		.
		.;^DHCEQStateInfo(0,"Equip","N",0,170,1)
		.s count=1
		.s rrid=""
		.f  s rrid=$o(^DHCEQStateInfo(0,"Equip","N",0,SIEquipDR,rrid),-1) quit:rrid=""  d
		..q:$p($g(^DHCEQStateInfo(rrid)),"^",17)>1
		..q:(count>ShowLines)
		..s SIRowID=rrid
		..;w SIRowID,!
		..d OutputStateInfo
		.
		.i (count=1)&&(PRecordFlag="") d OutputRowGetStateInfo		;登记操作记录如果没有使用记录的设备应该输出空的使用记录行
 	}
 	else
 	{
	 	s count=1
	 	s rrid=""
		f  s rrid=$o(^DHCEQStateInfo(rrid),-1) quit:rrid=""  d
		.q:(count>ShowLines)&&(PRecordFlag="")
		.// MZY0116	2475924,2493291		2022-03-14
		.d ResetVariablesGetStateInfo
		.s passed=1
		.s SIRowID=rrid
		.s SIEquipDR = $p($g(^DHCEQStateInfo(rrid)),"^",2)
		.i SIEquipDR="" d
		..i (PFileNo'="")||(PNo'="") s passed=0
		..i (TMPFileNo'="")&&($ZCONVERT($p($g(^DHCEQStateInfo(rrid)),"^",31),"U")'[$ZCONVERT(TMPFileNo,"U")) s passed=0
		..i (PName'="")&&($p($g(^DHCEQStateInfo(rrid)),"^",32)'[PName) s passed=0
		..i (PLoc'="")&&($p($g(^DHCEQStateInfo(rrid)),"^",35)'=PLoc) s passed=0
		.e  d
		..i (TMPFileNo'="") s passed=0
		..d GetDataEquip
		..d CheckDataEquip
		.
		.q:passed=0
		.d OutputStateInfo
 	}
	Quit $$$OK
OutputRowGetStateInfo
	Set count=count+1	;累加器
	Set Data=$lb(Row,SIRowID,SIType,SIEquipDR,SIEquipName,SIEquipFileNo,SIEquipNo,SIEquipModel,SILeaveFactoryNo,SIEquipStoreLoc,SIEquipEquipType,SIRecordDate,SIStartDate,SIStartTime,SIEndDate,SIEndTime,SITotalTime,SIUseContent,SIStartState,SIStartStateInfo,SIEndState,SIEndStateInfo,SIUserDR,SIUserDRSSUSRName,SIPatientID,SIRemark,SIStatus,SIInvalidFlag,SIAddUser,SIAddDate,SIAddTime,SIUpdateUser,SIUpdateDate,SIUpdateTime,SISubmitUser,SISubmitDate,SISubmitTime,SIAuditUser,SIAuditDate,SIAuditTime,SITMPFileNo,SIEQName,SIModelDR,SIModelDRMDesc,SISnNumber,SIStoreLocDR,SIStoreLocDRCTLOCDesc,SIWardCode,SIWardName,SIBedNo,SIUseLocDR,SIUseLocDRCTLOCDesc,SIOrigin,SIPatientName,SISex,SIAgeYr,SIAgeMth,SIAgeDay,SITemperature,SIHumidity,SINoType,SINo,SILocation,SINurse,SIDisinfectFlag,SIDisinfector,SIHold1,SIHold2,SIHold3,SIHold4,SIHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set Row=Row+1
	Quit
ResetVariablesGetStateInfo
	Set (SIRowID,SIType,SIEquipDR,SIEquipName,SIEquipFileNo,SIEquipNo,SIEquipModel,SILeaveFactoryNo,SIEquipStoreLoc,SIEquipEquipType,SIRecordDate,SIStartDate,SIStartTime,SIEndDate,SIEndTime,SITotalTime,SIUseContent,SIStartState,SIStartStateInfo,SIEndState,SIEndStateInfo,SIUserDR,SIUserDRSSUSRName,SIPatientID,SIRemark,SIStatus,SIInvalidFlag,SIAddUser,SIAddDate,SIAddTime,SIUpdateUser,SIUpdateDate,SIUpdateTime,SISubmitUser,SISubmitDate,SISubmitTime,SIAuditUser,SIAuditDate,SIAuditTime,SITMPFileNo,SIEQName,SIModelDR,SIModelDRMDesc,SISnNumber,SIStoreLocDR,SIStoreLocDRCTLOCDesc,SIWardCode,SIWardName,SIBedNo,SIUseLocDR,SIUseLocDRCTLOCDesc,SIOrigin,SIPatientName,SISex,SIAgeYr,SIAgeMth,SIAgeDay,SITemperature,SIHumidity,SINoType,SINo,SILocation,SINurse,SIDisinfectFlag,SIDisinfector,SIHold1,SIHold2,SIHold3,SIHold4,SIHold5)=""
	Quit
GetDataEquip
	s EquipTypeDR=$p($g(^DHCEQEquip(SIEquipDR)),"^",63)
	s SIEquipNo = $p($g(^DHCEQEquip(SIEquipDR)),"^",71)
	s SIEquipName = $p($g(^DHCEQEquip(SIEquipDR)),"^",1)
	s SIEquipFileNo=$p($g(^DHCEQEquip(SIEquipDR)),"^",85)
	s EQStatus = $p($g(^DHCEQEquip(SIEquipDR)),"^",38)
	s StoreLocDR = $p($g(^DHCEQEquip(SIEquipDR)),"^",67)
	s StockStatus = $p($g(^DHCEQEquip(SIEquipDR)),"^",60)
	// MZY0116	2475924,2493291		2022-03-14
	s SIEquipModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model", $p($g(^DHCEQEquip(SIEquipDR)),"^",3))
	s SILeaveFactoryNo = $p($g(^DHCEQEquip(SIEquipDR)),"^",10)
	s SIEquipStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", StoreLocDR)
	s SIEquipEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", EquipTypeDR)
	
	Quit
CheckDataEquip
	;s passed=1	// MZY0116	2475924,2493291		2022-03-14
	;i (##Class(web.DHCEQCommon).CheckManageLimit("","","","","","","",SIEquipDR)) s passed=0
	i $p($g(^DHCEQEquip(SIEquipDR)),"^",59)'="N" s passed=0
	i (EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,PGroup)) s passed=0
	i (PNo'="")&&($ZCONVERT(SIEquipNo,"U")'[PNo) s passed=0
	i (PRecordFlag="")&&(PName'="")&&($ZCONVERT(SIEquipName ,"U")'[PName) s passed=0
	i (PFileNo'="")&&($ZCONVERT(SIEquipFileNo,"U")'[PFileNo) s passed=0
	i ((EQStatus="3")||(EQStatus="4")) s passed=0
	;i (StoreLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR))) s passed=0
	i (PLoc'="")&&(StoreLocDR'=PLoc) s passed=0
	i ((StockStatus="0")||(StockStatus="3")) s passed=0
	i (PRecordFlag'="")&&(PName'="")&&($ZCONVERT(SIEquipName ,"U")'[PName) s passed=0	// MZY0116	2475924,2493291		2022-03-14
	Quit
OutputStateInfo
	q:($p($g(^DHCEQStateInfo(SIRowID)),"^",17)>1)&&(PRecordFlag="")
	q:$p($g(^DHCEQStateInfo(SIRowID)),"^",18)'="N"
	q:(PRecordDate'="")&&(PRecordDate'=$p($g(^DHCEQStateInfo(SIRowID)),"^",2))
	s SIType=##Class(web.DHCEQ.BA.BUSStateInfo).GetTypeDisplay($p($g(^DHCEQStateInfo(SIRowID)),"^",1))
	s SIRecordDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStateInfo(SIRowID)),"^",3),"date")
	q:(PStartDate'="")&&($p($g(^DHCEQStateInfo(SIRowID)),"^",4)<PStartDate)
	s SIStartDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStateInfo(SIRowID)),"^",4),"date")
	s SIStartTime=$ZTIME($p($g(^DHCEQStateInfo(SIRowID)),"^",5),1)
	q:(PEndDate'="")&&($p($g(^DHCEQStateInfo(SIRowID)),"^",6)>PEndDate)
	s SIEndDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStateInfo(SIRowID)),"^",6),"date")
	i $p($g(^DHCEQStateInfo(SIRowID)),"^",7)'="" s SIEndTime=$ZTIME($p($g(^DHCEQStateInfo(SIRowID)),"^",7),1)
	s SITotalTime=$p($g(^DHCEQStateInfo(SIRowID)),"^",8)
	s SIUseContent=$p($g(^DHCEQStateInfo(SIRowID)),"^",9)
	s SIStartState=$p($g(^DHCEQStateInfo(SIRowID)),"^",10)
	s SIStartStateInfo=$p($g(^DHCEQStateInfo(SIRowID)),"^",11)
	i SIStartStateInfo="" s SIStartStateInfo=SIStartState
	s SIEndState=$p($g(^DHCEQStateInfo(SIRowID)),"^",12)
	s SIEndStateInfo=$p($g(^DHCEQStateInfo(SIRowID)),"^",13)
	i SIEndStateInfo="" s SIEndStateInfo=SIEndState
	s SIUserDR=$p($g(^DHCEQStateInfo(SIRowID)),"^",14)
	q:(PUser'="")&&(SIUserDR'=PUser)
	s SIUserDRSSUSRName=##Class(web.DHCEQCommon).GetTrakNameByID("user", SIUserDR)
	s SIPatientID=$p($g(^DHCEQStateInfo(SIRowID)),"^",15)
	s SIRemark=$p($g(^DHCEQStateInfo(SIRowID)),"^",16)
	s SIStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay($p($g(^DHCEQStateInfo(SIRowID)),"^",17))
	s SIInvalidFlag=$p($g(^DHCEQStateInfo(SIRowID)),"^",18)
	s SIAddUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQStateInfo(SIRowID)),"^",19))
	s SIAddDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStateInfo(SIRowID)),"^",20),"date")
	s SIAddTime=$ZTIME($p($g(^DHCEQStateInfo(SIRowID)),"^",21),1)
	s SIUpdateUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQStateInfo(SIRowID)),"^",22))
	s SIUpdateDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStateInfo(SIRowID)),"^",23),"date")
	s SIUpdateTime=$ZTIME($p($g(^DHCEQStateInfo(SIRowID)),"^",24),1)
	s SISubmitUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQStateInfo(SIRowID)),"^",25))
	s SISubmitDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStateInfo(SIRowID)),"^",26),"date")
	s SISubmitTime=$ZTIME($p($g(^DHCEQStateInfo(SIRowID)),"^",27),1)
	s SIAuditUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQStateInfo(SIRowID)),"^",28))
	s SIAuditDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStateInfo(SIRowID)),"^",29),"date")
	s SIAuditTime=$ZTIME($p($g(^DHCEQStateInfo(SIRowID)),"^",30),1)
	s SITMPFileNo=$p($g(^DHCEQStateInfo(SIRowID)),"^",31)
	s SIEQName=$p($g(^DHCEQStateInfo(SIRowID)),"^",32)
	;q:(PRecordFlag'="")&&(PName'="")&&($ZCONVERT(SIEQName ,"U")'[PName)	 MZY0116	2475924,2493291		2022-03-14
	s SIModelDR=$p($g(^DHCEQStateInfo(SIRowID)),"^",33)
	s SIModelDRMDesc=$p=##Class(web.DHCEQCommon).GetTrakNameByID("model", SIModelDR)
	s SISnNumber=$p($g(^DHCEQStateInfo(SIRowID)),"^",34)
	s SIStoreLocDR=$p($g(^DHCEQStateInfo(SIRowID)),"^",35)
	s SIStoreLocDRCTLOCDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", SIStoreLocDR)
	s SIWardCode=$p($g(^DHCEQStateInfo(SIRowID)),"^",36)
	s SIWardName=$p($g(^DHCEQStateInfo(SIRowID)),"^",37)
	s SIBedNo=$p($g(^DHCEQStateInfo(SIRowID)),"^",38)
	s SIUseLocDR=$p($g(^DHCEQStateInfo(SIRowID)),"^",39)
	s SIUseLocDRCTLOCDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", SIUseLocDR)
	s SIOrigin=$p($g(^DHCEQStateInfo(SIRowID)),"^",40)
	i SIOrigin'="" s SIOrigin=$CASE(SIOrigin,"0":"DHC_PC","1":"DHC_PDA","2":"DHC_WChat","3":"GreatWall_PDA")
	s SIPatientName=$p($g(^DHCEQStateInfo(SIRowID)),"^",41)
	s SISex="未知性别"
	i $p($g(^DHCEQStateInfo(SIRowID)),"^",42)=1 s SISex="男"
	i $p($g(^DHCEQStateInfo(SIRowID)),"^",42)=2 s SISex="女"
	s SIAgeYr=$p($g(^DHCEQStateInfo(SIRowID)),"^",43)
	s SIAgeMth=$p($g(^DHCEQStateInfo(SIRowID)),"^",44)
	s SIAgeDay=$p($g(^DHCEQStateInfo(SIRowID)),"^",45)
	s SITemperature=$p($g(^DHCEQStateInfo(SIRowID)),"^",46)
	s SIHumidity=$p($g(^DHCEQStateInfo(SIRowID)),"^",47)
	s SINoType=$p($g(^DHCEQStateInfo(SIRowID)),"^",48)
	i SINoType'="" s SINoType=$CASE(SINoType,"0":"登记号","1":"就诊号","2":"病案号","3":"住院号","4":"门诊号","5":"标本号","6":"医技号")
	s SINo=$p($g(^DHCEQStateInfo(SIRowID)),"^",49)
	s SILocation=$p($g(^DHCEQStateInfo(SIRowID)),"^",50)
	s SINurse=$p($g(^DHCEQStateInfo(SIRowID)),"^",51)
	s SIDisinfectFlag=$p($g(^DHCEQStateInfo(SIRowID)),"^",52)
	s SIDisinfector=$p($g(^DHCEQStateInfo(SIRowID)),"^",53)
	s SIHold1=$p($g(^DHCEQStateInfo(SIRowID)),"^",54)
	s SIHold2=$p($g(^DHCEQStateInfo(SIRowID)),"^",55)
	s SIHold3=$p($g(^DHCEQStateInfo(SIRowID)),"^",56)
	s SIHold4=$p($g(^DHCEQStateInfo(SIRowID)),"^",57)
	s SIHold5=$p($g(^DHCEQStateInfo(SIRowID)),"^",58)
	d OutputRowGetStateInfo
	
	Quit
}

ClassMethod GetStateInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStateInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetStateInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStateInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.BA.BUSStateInfo).GetTypeDisplay(2)
ClassMethod GetTypeDisplay(Type As %Library.String) As %Status
{
	i Type=""  q ""
	i +Type=0  q "运行"
	i +Type=1  q "故障"
	
	q "未定义"
}

/// w ##Class(web.DHCEQ.BA.BUSStateInfo).GetOneStateInfo(6)
ClassMethod GetOneStateInfo(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneStateInfo"
	if (RowID="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-4100", ErrorMsg)
	
	s ObjStateInfo=##Class(User.DHCEQStateInfo).%OpenId(RowID)
	s StateInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjStateInfo)
	
	d StateInfo.%Set("SIUserDR_SSUSRName",ObjStateInfo.SIUserDR.UName)
	d StateInfo.%Set("SIModelDR_MDesc",ObjStateInfo.SIModelDR.MDesc)   //Modefined by 2022-3-23 ZC0116 修正机型取值错误的问题 
	d StateInfo.%Set("SIStoreLocDR_CTLOCDesc",ObjStateInfo.SIStoreLocDR.DeptDesc)
	d StateInfo.%Set("SIUseLocDR_CTLOCDesc",ObjStateInfo.SIUseLocDR.DeptDesc)
	// MZY0126	2641894		2022-06-13
	d StateInfo.%Set("SISex","未知性别")
	i ObjStateInfo.SISex=1 d StateInfo.%Set("SISex","男")
	i ObjStateInfo.SISex=2 d StateInfo.%Set("SISex","女")
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,StateInfo)
ERRORGetOneStateInfo
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述: 根据条码获取设备信息记录
/// 入参:
/// 		RowID:信息记录ID
/// 			BarCode:设备条码
/// 返回值:
/// 		StateInfo对象
/// w ##class(web.DHCEQ.BA.BUSStateInfo).GetDeviceStateInfo(7)
/// w ##class(web.DHCEQ.BA.BUSStateInfo).GetDeviceStateInfo("","3220401000007")
/// w ##class(web.DHCEQ.BA.BUSStateInfo).GetDeviceStateInfo("","fileno:N26859,no:3220401000002")
/// w ##class(web.DHCEQ.BA.BUSStateInfo).GetDeviceStateInfo("","no:3220401000002")
/// w ##class(web.DHCEQ.BA.BUSStateInfo).GetDeviceStateInfo("","tempno:LS01")
/// w ##class(web.DHCEQ.BA.BUSStateInfo).GetDeviceStateInfo("","tempno:LS02")
ClassMethod GetDeviceStateInfo(RowID As %String = "", BarCode As %String = "")
{
	if (RowID="")&&(BarCode="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-4100", ErrorMsg)
	s $ZT="ERRORGetDeviceStateInfo"
	
	i RowID'=""
	{
		d SetStateInfo
	}
	else
	{
		s tmpBarCode=$ZCONVERT(BarCode,"U")
		i tmpBarCode["TEMPNO:"
		{
			;临时码
			s TempFnNumber=$p(tmpBarCode,"TEMPNO:",2)
			s GetEQInfo=""			; 设置获取设备信息ID(的DHCEQStateInfo表)
			
			s rowid=""
			f  s rowid=$o(^DHCEQStateInfo(rowid),-1) q:(rowid="")||(RowID'="")  d
			.q:$Piece($Get(^DHCEQStateInfo(rowid)),"^",1)'=0		;SI_Type 0:运行|1:故障
			.q:$Piece($Get(^DHCEQStateInfo(rowid)),"^",17)=3		;SI_Status 0:新增|1:提交|2:审核|3:作废
			.q:$Piece($Get(^DHCEQStateInfo(rowid)),"^",18)'="N"		;SI_InvalidFlag
			.q:$ZCONVERT($Piece($Get(^DHCEQStateInfo(rowid)),"^",31),"U")'=TempFnNumber
			.s GetEQInfo=rowid
			.i $Piece($Get(^DHCEQStateInfo(rowid)),"^",6)="" d		;SI_EndDate
			..s RowID=rowid
			..d SetStateInfo
			if GetEQInfo="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-4100", "设备传入编码异常!")
			
			; 设置设备信息
			i RowID=""
			{
				s StateInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
				s ObjStateInfo=##Class(User.DHCEQStateInfo).%OpenId(GetEQInfo)
				i ObjStateInfo.SIEquipDR'=""
				{
					d StateInfo.%Set("SIEquipDR", ObjStateInfo.SIEquipDR)
					d StateInfo.%Set("DeviceName", ObjStateInfo.SIEquipDR.EQName)
					d StateInfo.%Set("DeviceModel", ##Class(web.DHCEQCommon).GetTrakNameByID("model", ObjStateInfo.SIEquipDR.EQModelDR))
					i ObjStateInfo.SIEquipDR.EQStartDate'="" d StateInfo.%Set("StartDate", $ZD(ObjStateInfo.SIEquipDR.EQStartDate,3))
					d StateInfo.%Set("SnNumber", ObjStateInfo.SIEquipDR.EQLeaveFactoryNo)
					d StateInfo.%Set("FnNumber", ObjStateInfo.SIEquipDR.EQFileNo)
					d StateInfo.%Set("StoreLoc", ##class(web.DHCEQCommon).GetTrakNameByID("dept", ObjStateInfo.SIEquipDR.EQStoreLocDR))
				}
				else
				{
					;临时码
					d StateInfo.%Set("DeviceName", ObjStateInfo.SIEQName)
					d StateInfo.%Set("DeviceModel", ##Class(web.DHCEQCommon).GetTrakNameByID("model", ObjStateInfo.SIModelDR.MDesc))
					d StateInfo.%Set("StartDate", "")
					d StateInfo.%Set("SnNumber", ObjStateInfo.SISnNumber)
					d StateInfo.%Set("FnNumber", ObjStateInfo.SITMPFileNo)
					d StateInfo.%Set("StoreLoc", ##class(web.DHCEQCommon).GetTrakNameByID("dept", ObjStateInfo.SIStoreLocDR))
				}
			}
		}
		else
		{
			; "fileno:N26859,no:3220401000002" "no:3220401000002" "3220401000002"
			s BarCodeLen=$l(tmpBarCode,",")
			i BarCodeLen>1
			{
				s EquipNo=""
				s FileNo=""
				f i=1:1:BarCodeLen
				{
					q:EquipNo'=""
					s BarCodeStr=$p(tmpBarCode,",",i)
					i BarCodeStr["FILENO:" s FileNo=$p(BarCodeStr,"FILENO:",2)
					i BarCodeStr["NO:"
					{
						i $p(BarCodeStr,"NO:",1)="" s EquipNo=$p(BarCodeStr,"NO:",2)	; 确保NO:没有前缀
					}
				}
				;;;;i FileNo'="" s EquipNo=FileNo	 优先档案号
			}
			else
			{
				s EquipNo=$p(tmpBarCode,"NO:",2)
				i EquipNo="" s EquipNo=tmpBarCode
			}
			if EquipNo="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-4100", "设备传入编码异常!")
			s EquipDR=+##class(web.DHCEQM.DHCEQMaintForService).GetEquipByEquipNo(EquipNo)		;取到设备ID
			if EquipDR<1 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-4100", "设备传入编码异常!")
			
			; ^DHCEQStateInfo(0,"Equip","N",0,8,5)
			s rowid=""
			f  s rowid=$o(^DHCEQStateInfo(0,"Equip","N",0,EquipDR,rowid),-1) q:(rowid="")||(RowID'="")  d
			.i $Piece($Get(^DHCEQStateInfo(rowid)),"^",6)="" d		;SI_EndDate
			..s RowID=rowid
			..d SetStateInfo
			
			; 设置设备信息
			i RowID=""
			{
				s StateInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
				s ObjEquipInfo=##Class(User.DHCEQEquip).%OpenId(EquipDR)
				d StateInfo.%Set("DeviceName", ObjEquipInfo.EQName)
				d StateInfo.%Set("DeviceModel", ##Class(web.DHCEQCommon).GetTrakNameByID("model", ObjEquipInfo.EQModelDR))
				i ObjEquipInfo.EQStartDate'="" d StateInfo.%Set("StartDate", $ZD(ObjEquipInfo.EQStartDate,3))
				d StateInfo.%Set("SnNumber", ObjEquipInfo.EQLeaveFactoryNo)
				d StateInfo.%Set("FnNumber", ObjEquipInfo.EQFileNo)
				d StateInfo.%Set("StoreLoc", ##class(web.DHCEQCommon).GetTrakNameByID("dept", ObjEquipInfo.EQStoreLocDR))
			}
		}
	}
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, StateInfo)
SetStateInfo
	s ObjStateInfo=##Class(User.DHCEQStateInfo).%OpenId(RowID)
	s StateInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjStateInfo)
	
	d StateInfo.%Set("SIRowID", RowID)
	d StateInfo.%Set("SIUserDR_SSUSRName", ##class(web.DHCEQCommon).GetTrakNameByID("user", ObjStateInfo.SIUserDR))
	d StateInfo.%Set("SIModelDR_MDesc", ##class(web.DHCEQCommon).GetTrakNameByID("model", ObjStateInfo.SIModelDR))
	d StateInfo.%Set("SIStoreLocDR_CTLOCDesc", ##class(web.DHCEQCommon).GetTrakNameByID("dept", ObjStateInfo.SIStoreLocDR))
	d StateInfo.%Set("SIUseLocDR_CTLOCDesc", ##class(web.DHCEQCommon).GetTrakNameByID("dept", ObjStateInfo.SIUseLocDR))
	; 设置设备信息
	i ObjStateInfo.SIEquipDR'=""
	{
		d StateInfo.%Set("DeviceName", ObjStateInfo.SIEquipDR.EQName)
		d StateInfo.%Set("DeviceModel", ##Class(web.DHCEQCommon).GetTrakNameByID("model", ObjStateInfo.SIEquipDR.EQModelDR))
		i ObjStateInfo.SIEquipDR.EQStartDate'="" d StateInfo.%Set("StartDate", $ZD(ObjStateInfo.SIEquipDR.EQStartDate,3))
		d StateInfo.%Set("SnNumber", ObjStateInfo.SIEquipDR.EQLeaveFactoryNo)
		d StateInfo.%Set("FnNumber", ObjStateInfo.SIEquipDR.EQFileNo)
		d StateInfo.%Set("StoreLoc", ##class(web.DHCEQCommon).GetTrakNameByID("dept", ObjStateInfo.SIEquipDR.EQStoreLocDR))
	}
	else
	{
		; 临时码
		d StateInfo.%Set("DeviceName", ObjStateInfo.SIEQName)
		d StateInfo.%Set("DeviceModel", ##Class(web.DHCEQCommon).GetTrakNameByID("model", ObjStateInfo.SIModelDR.MDesc))
		d StateInfo.%Set("StartDate", "")
		d StateInfo.%Set("SnNumber", ObjStateInfo.SISnNumber)
		d StateInfo.%Set("FnNumber", ObjStateInfo.SITMPFileNo)
		d StateInfo.%Set("StoreLoc", ##class(web.DHCEQCommon).GetTrakNameByID("dept", ObjStateInfo.SIStoreLocDR))
	}
	
	q
	
ERRORGetDeviceStateInfo
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000", ErrorMsg)
}

/// Creator: 		JYW
/// CreatDate: 		2018-08-13
/// Description: 	扫描腕带获取病人信息
/// Input：			regNo 登记号(腕带),wardId 病区Id
/// Return：		{}
/// Other           w ##class(web.DHCEQ.BA.BUSStateInfo).getPatWristInfo("0000000047")
ClassMethod getPatWristInfo(regNo As %String, wardId As %String)
{
	s $zt="errGetPatWristInfo"
	s Msg="成功",msgcode="999999",Status="0" //定义初始值
	s json=##class(%ArrayOfDataTypes).%New()
	s episodeId=..getPatAdm(regNo)
	i episodeId=""
	{
		s Msg="未找到腕带对应的患者,请确认",msgcode="100322",Status="-1"
		d json.SetAt($g(Msg),"msg")
		d json.SetAt($g(msgcode),"msgcode")
		d json.SetAt($g(Status),"status")
   	    q ##class(Nur.PDA.JSON).Encode(json)
	}
	// MZY0117	2528299,2528299		2022-03-21
	s currLocID=$p($g(^PAADM(episodeId)),"^",4)
	s patWardId=$p($g(^PAADM(episodeId)),"^",70)
	s WardCode=""
	&SQL(select WARD_Code into :WardCode from SQLUser.PAC_Ward where WARD_RowID=:patWardId)
	d json.SetAt(WardCode,"WardCode")
	d json.SetAt(##Class(web.DHCEQCommon).getMapIDBySource("dept",currLocID),"CTDepartmentID")
	s patInfo=##class(Nur.CommonInterface.Patient).getPatient(episodeId)
	d json.SetAt(patInfo,"patInfo")
	
	d json.SetAt($g(Msg),"msg")
	d json.SetAt($g(msgcode),"msgcode")
	d json.SetAt($g(Status),"status")
	
    q ##class(Nur.PDA.JSON).Encode(json)
	
errGetPatWristInfo
	s Msg=$ze
	q ##class(Nur.PDA.Common).ReturnMsgJson(Msg,"100221","-1")
}

/// Creator: 		JYW
/// CreatDate: 		2018-08-14
/// Description: 	根据登记号取当前在院住院就诊号
/// Input：			regNo 登记号
/// Return：		{}
/// Other           w ##class(web.DHCEQ.BA.BUSStateInfo).getPatAdm("0000000047")
ClassMethod getPatAdm(regNo)
{
	s regNo=$replace(regNo,"REG","")
	s episodeId=""
	s papmi=""
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",regNo,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) q:Adm=""  d
	..s patVisit=$p($g(^PAADM(Adm)),"^",20)
	..q:patVisit'="A"
	..s Typ=$p(^PAADM(Adm),"^",2)
	..q:Typ'="I"
	..if Adm>episodeId  s episodeId=Adm
	q episodeId
}

}
