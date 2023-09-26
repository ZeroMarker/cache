Import SQLUser

Class web.DHCEQDispatchVehicle Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 业务单填写审核操作
/// d ##class(%ResultSet).RunQuery("web.DHCEQDispatchVehicle","GetDispatchVehicleList", 9)
Query GetDispatchVehicleList(RowID As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TEquipDR:%String,TEquip:%String,TEquipNo:%String,TVehicleNo:%String,TModel:%String,TColor:%String,TDisplacemint:%String,TMileage:%String,TDriverDR:%String,TDriver:%String,TCardNo:%String,TRunDate:%String,TRunTime:%String,TEndDate:%String,TEndTime:%String,TStartMileage:%String,TEndMileage:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetDispatchVehicleListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
 	new repid, index
 	new rowid,TRow,EquipData,TotalQty
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=2
	Set TotalQty=0
	
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	If TotalFlag="1" Set index=2
	Set TRow=0
	Set TDispatchVehicleDR=RowID
	
	if RowID'=""
	{
		Set rowid=0 
		For  Set rowid=$Order(^DHCEQDispatchVehicleList(0,"DispatchVehicle",RowID,rowid)) Quit:rowid=""  Do
		.Do ResetVariablesGetDVList
		.Set TRowID = rowid
		.Set TDispatchVehicleDR = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",1)
		.Set TInvalidFlag = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",25)
		.Quit:TInvalidFlag'="N"
		.Set TEquipDR = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",2)
		.If TEquipDR'="" Do
		..Set EquipData=$Get(^DHCEQEquip(TEquipDR))
		..Set TEquip = $ZCONVERT($Piece(EquipData,"^",1),"U")
		..Set TEquipNo = $ZCONVERT($Piece(EquipData,"^",71),"U")
		..Set VDR = $Order(^DHCEQVehicle(0,"EquipDR",TEquipDR,""))
		..If VDR'="" Do
		...Set TVehicleNo = $ZCONVERT($Piece($Get(^DHCEQVehicle(VDR)),"^",2),"U")
		...Set TDisplacemint = $Piece($Get(^DHCEQVehicle(VDR)),"^",5)
		...Set TMileage = $Piece($Get(^DHCEQVehicle(VDR)),"^",6)
		...Set TColor = $Piece($Get(^DHCEQVehicle(VDR)),"^",7)
		..Set TModel = $Piece(EquipData,"^",3)
		..If TModel'="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
		.Set TDriverDR = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",3)	;证件表记录
		.If TDriverDR'="" Do
		..Set TDriver = $Piece($Get(^DHCEQCertificateInfo(TDriverDR)),"^",2)
		..Set TDriver = ##class(web.DHCEQCommon).GetTrakNameByID("user",TDriver)
		.Set TCardNo = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",4)
		.Set TRunDate = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",5)
		.If TRunDate'="" Set TRunDate = ##class(web.DHCEQCommon).TransValueToPage(TRunDate,"date")
		.Set TRunTime = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",6)
		.If TRunTime'="" Set TRunTime = ##Class(web.DHCEQCommon).TransValueToPage(TRunTime,"time")
		.Set TEndDate = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",7)
		.If TEndDate'="" Set TEndDate = ##class(web.DHCEQCommon).TransValueToPage(TEndDate,"date")
		.Set TEndTime = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",8)
		.If TEndTime'="" Set TEndTime = ##Class(web.DHCEQCommon).TransValueToPage(TEndTime,"time")
		.Set TStartMileage = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",9)
		.Set TEndMileage = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",10)
		.Set TRemark = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",11)
		.Set THold1=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",12)
		.Set THold2=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",13)
		.Set THold3=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",14)
		.Set THold4=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",15)
		.Set THold5=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",16)
		.Set TRow=TRow+1
		.Set TotalQty=TotalQty+1 ;TQuantityNum
		.Do OutputRowGetDispatchVehicleList
	}
	
	;没有数据时,也返回一个空行,用于编辑
	If TRow=0 Do
	.Do ResetVariablesGetDVList
	.Set TRow=1
	.Do OutputRowGetDispatchVehicleList
	
	;处理合计行
	If TotalFlag>0  Do
	.Do ResetVariablesGetDVList
	.Set TRowID=-1
	.Set TEquip=TotalQty_" 台/辆"
	.If TotalFlag="1" Do
	..Set index=1
	.Else  Do
	..Set index=index+1
	.Do OutputRowGetDispatchVehicleList
	Quit $$$OK
	
OutputRowGetDispatchVehicleList
	Set Data=$lb(TRow,TRowID,TEquipDR,TEquip,TEquipNo,TVehicleNo,TModel,TColor,TDisplacemint,TMileage,TDriverDR,TDriver,TCardNo,TRunDate,TRunTime,TEndDate,TEndTime,TStartMileage,TEndMileage,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetDVList
	Set (TRowID,TEquipDR,TEquip,TEquipNo,TVehicleNo,TModel,TColor,TDisplacemint,TMileage,TDriverDR,TDriver,TCardNo,TRunDate,TRunTime,TEndDate,TEndTime,TStartMileage,TEndMileage,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetDispatchVehicleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispatchVehicleListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetDispatchVehicleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispatchVehicleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 业务查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQDispatchVehicle","GetDispatchVehicle")
Query GetDispatchVehicle(DispatchVehicleNo As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", Arrive As %String = "", RequestUserDR As %String = "", ApproveRole As %String = "", WaitAD As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDispatchVehicleNo:%String,TRequestDate:%String,TStatus:%String,TRequestUser:%String,TUserName:%String,TRequestReason:%String,TArrive:%String,TRemark:%String,TApproveStep:%String,TApproveRole:%String,TVehicleNos:%String")
{
}

ClassMethod GetDispatchVehicleExecute(ByRef qHandle As %Binary, DispatchVehicleNo As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", Arrive As %String = "", RequestUserDR As %String = "", ApproveRole As %String = "", WaitAD As %String = "") As %Status
{
	new repid, index
 	new rowid,TRow,TotalFlag,TotalQty,Total,InStockDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("24")
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQDispatchVehicle(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetDispatchVehicle
	.Set TRowID = rowid
	.Set TInvalidFlag = $Piece($Get(^DHCEQDispatchVehicle(TRowID)),"^",25)
	.Quit:TInvalidFlag'="N"
	.Set TDispatchVehicleNo = $Piece($Get(^DHCEQDispatchVehicle(TRowID)),"^",1)
	.Quit:TDispatchVehicleNo=""
	.Quit:(DispatchVehicleNo'="")&(TDispatchVehicleNo'[DispatchVehicleNo)
	.If StartDate="" Set StartDate=0
	.If EndDate="" Set EndDate=+$h
	.Set TRequestDate = $Piece($Get(^DHCEQDispatchVehicle(TRowID)),"^",2)
	.Quit:(TRequestDate>EndDate)||(TRequestDate<StartDate)
	.Set TRequestDate = ##class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	.Set TStatus = $Piece($Get(^DHCEQDispatchVehicle(TRowID)),"^",3)
	.Quit:(WaitAD="on")&(TStatus="0")
	.Quit:(Status'="")&(Status'=TStatus)
	.Set TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.Set TRequestUserDR = $Piece($Get(^DHCEQDispatchVehicle(TRowID)),"^",13)
	.Quit:(RequestUserDR'="")&(RequestUserDR'=TRequestUserDR)
	.If TRequestUserDR '="" Set TRequestUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	.Set TUserName = $Piece($Get(^DHCEQDispatchVehicle(TRowID)),"^",14)
	.Set TRequestReason = $Piece($Get(^DHCEQDispatchVehicle(TRowID)),"^",15)
	.Set TArrive = $Piece($Get(^DHCEQDispatchVehicle(TRowID)),"^",16)
	.Quit:(Arrive'="")&(TArrive'[Arrive)
	.Set TRemark = $Piece($Get(^DHCEQDispatchVehicle(TRowID)),"^",21)
	.
	.; 车牌号信息
	.Set DVLRowid=0
	.For  Set DVLRowid=$Order(^DHCEQDispatchVehicleList(0,"DispatchVehicle",TRowID,DVLRowid)) Quit:DVLRowid=""  Do
	..Set TEquipDR = $Piece($Get(^DHCEQDispatchVehicleList(DVLRowid)),"^",2)
	..If TEquipDR'="" Do
	...;Set EquipData=$Get(^DHCEQEquip(TEquipDR))
	...;Set TEquip = $ZCONVERT($Piece(EquipData,"^",1),"U")
	...;Set TEquipNo = $ZCONVERT($Piece(EquipData,"^",71),"U")
	...Set VDR = $Order(^DHCEQVehicle(0,"EquipDR",TEquipDR,""))
	...If VDR'="" Do
	....;Set TVehicleNo = $ZCONVERT($Piece($Get(^DHCEQVehicle(VDR)),"^",2),"U")
	....If TVehicleNos'="" Set TVehicleNos=TVehicleNos_","
	....Set TVehicleNos=TVehicleNos_$ZCONVERT($Piece($Get(^DHCEQVehicle(VDR)),"^",2),"U")
	.
	.Set AIRowID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,TRowID,0))
	.If AIRowID'="" Set CurRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",4)
	.If ((WaitAD="on")&&(CurRole'="")) Quit:CurRole'=ApproveRole
	.Set ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("24",TRowID)
	.If ApproveInfo'="" Do
	..Set TApproveRole=$Piece(ApproveInfo,"^",9)
	..Set TApproveStep=$Piece(ApproveInfo,"^",5)
	.
	.Do OutputRowGetDispatchVehicle
	
	Quit $$$OK
OutputRowGetDispatchVehicle
	Set Data=$lb(TRowID,TDispatchVehicleNo,TRequestDate,TStatus,TRequestUser,TUserName,TRequestReason,TArrive,TRemark,TApproveStep,TApproveRole,TVehicleNos)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetDispatchVehicle
	Set (TRowID,TDispatchVehicleNo,TRequestDate,TStatus,TRequestUser,TUserName,TRequestReason,TArrive,TRemark,TApproveStep,TApproveRole,TVehicleNos)=""
	Quit
}

ClassMethod GetDispatchVehicleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispatchVehicleExecute ]
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

ClassMethod GetDispatchVehicleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispatchVehicleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQDispatchVehicle).SaveData("7^20140126000007^26/01/2014^28^QQQ^EEETTT^WWW^26/01/2014^09:00^26/01/2014^18:00^^^^^^","1^7^938^^ ^ ^ ^ ^ ^^^^^^^^",",3,0,0,-1")
ClassMethod SaveData(val, valList, DelRowid)
{
	Set $ZT="ERRORSave"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set RowID=$Piece(val,"^",1)
	
	Set PLIST(2) = $Piece(val,"^",2)		;DispatchVehicleNo
	Set PLIST(3) = $Piece(val,"^",3)		;RequestDate
	If $Piece(val,"^",3)'=""  Set PLIST(3) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",3),"date")
 	Set PLIST(8) = User		;UpdateUserDR
 	Set PLIST(9) = Date		;UpdateDate 
 	Set PLIST(10) = Time	;UpdateTime
 	;Set PLIST(11) = User	;SubmitUserDR
 	;Set PLIST(12) = Date	;SubmitDate 
 	;Set PLIST(13) = Time	;SubmitTime
 	Set PLIST(14) = $Piece(val,"^",4)		;RequestUserDR
 	Set PLIST(15) = $Piece(val,"^",5)		;UserName
 	Set PLIST(16) = $Piece(val,"^",6)		;RequestReason
 	Set PLIST(17) = $Piece(val,"^",7)		;Arrive
 	Set PLIST(18) = $Piece(val,"^",8)		;DispatchDate
 	If $Piece(val,"^",8)'=""  Set PLIST(18) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",8),"date")
 	Set PLIST(19) = $Piece(val,"^",9)		;DispatchTime
 	If $Piece(val,"^",9)'=""  Set PLIST(19) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",9),"time")
 	Set PLIST(20) = $Piece(val,"^",10)		;PatchDate
 	If $Piece(val,"^",10)'=""  Set PLIST(20) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",10),"date")
 	Set PLIST(21) = $Piece(val,"^",11)		;PatchTime
 	If $Piece(val,"^",11)'=""  Set PLIST(21) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",11),"time")
 	Set PLIST(22) = $Piece(val,"^",12)		;Remark
 	;Set PLIST(23) = User					;CancelUser
 	;Set PLIST(24) = Date					;CancelDate
 	;Set PLIST(25) = Time					;CancelTime
 	;Set PLIST(26) = "N"					;InvalidFlag
 	Set PLIST(27) = $Piece(val,"^",13)		;Hold1
 	Set PLIST(28) = $Piece(val,"^",14)		;Hold2
 	Set PLIST(29) = $Piece(val,"^",15)		;Hold3
 	Set PLIST(30) = $Piece(val,"^",16)		;Hold4
 	Set PLIST(31) = $Piece(val,"^",17)		;Hold5
 	
	TSTART	
 	if RowID=""
 	{
		If PLIST(2)="" Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQDispatchVehicle",Date)
		Set PLIST(4) = 0		;Status
		Set PLIST(5) = User		;AddUserDR
		Set PLIST(6) = Date		;AddDate
		Set PLIST(7) = Time		;AddTime
		Set PLIST(26) = "N"		;InvalidFlag
		&SQL(insert into sqluser.DHC_EQDispatchVehicle values :PLIST())
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		Set RowID=$Get(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQDispatchVehicle values :PLIST() where DV_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
 	}
 	
 	Set SQLCODE=##Class(web.DHCEQDispatchVehicle).DeleteDispatchVehicleList(DelRowid)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
 	Set SQLCODE=##Class(web.DHCEQDispatchVehicle).SaveDispatchVehicleList(RowID,valList,User)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	TCOMMIT
 	Set ID=RowID
 	Quit ID
ERRORSave
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQDispatchVehicle).SaveDispatchVehicleList(7,"1^^938^^^^^^^^^^^^^^",1)
ClassMethod SaveDispatchVehicleList(DVRowID As %String = "", val As %String = "", User As %String = "")
{
	Quit:DVRowID="" -1
	Quit:val="" 0
	
	new Length,DVLRowID,Flag,i
	Kill PLIST
	
	Set Length=$l(val,"&")
	Set PLIST(2)=DVRowID
	Set Flag=0
	For i=1:1:Length
	{
		Quit:Flag'=0
		;TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+TEquipTypeDR+"^"+TProviderDR+"^"+TManuFactory+"^"+TEquipName+"^"+TTotalNum+"^"+TTotalFee+"^"+TRemark;
		; DVL_RowID DVL_DispatchVehicleDR DVL_EquipDR DVL_DriverDR DVL_CardNo DVL_RunDate DVL_RunTime DVL_EndDate DVL_EndTime DVL_StartMileage DVL_EndMileage DVL_Remark DVL_Hold1 DVL_Hold2 DVL_Hold3 DVL_Hold4 DVL_Hold5 
		Set valList=$Piece(val,"&",i)
		Set DVLRowID=$Piece(valList,"^",2)
		;Set PLIST(2)=$Piece(valList,"^",2)		;DVL_DispatchVehicleDR
		Set PLIST(3)=$Piece(valList,"^",3)  	;DVL_EquipDR
		Set PLIST(4)=$Piece(valList,"^",4)		;DVL_DriverDR
		Set PLIST(5)=$Piece(valList,"^",5)		;DVL_CardNo
		Set PLIST(6)=$Piece(valList,"^",6)  	;DVL_RunDate
		If $Piece(valList,"^",6)'=""  Set PLIST(6) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(valList,"^",6),"date")
		Set PLIST(7)=$Piece(valList,"^",7)  	;DVL_RunTime
		If $Piece(valList,"^",7)'=""  Set PLIST(7) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(valList,"^",7),"time")
		Set PLIST(8)=$Piece(valList,"^",8)  	;DVL_EndDate
		If $Piece(valList,"^",8)'=""  Set PLIST(8) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(valList,"^",8),"date")
		Set PLIST(9)=$Piece(valList,"^",9)  	;DVL_EndTime
		If $Piece(valList,"^",9)'=""  Set PLIST(9) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(valList,"^",9),"time")
		Set PLIST(10)=$Piece(valList,"^",10)  	;DVL_StartMileage
		Set PLIST(11)=$Piece(valList,"^",11)  	;DVL_EndMileage
		Set PLIST(12)=$Piece(valList,"^",12)	;DVL_Remark
		Set PLIST(13)=$Piece(valList,"^",13)	;DVL_Hold1
 		Set PLIST(14)=$Piece(valList,"^",14)	;DVL_Hold2
 		Set PLIST(15)=$Piece(valList,"^",15)	;DVL_Hold3
 		Set PLIST(16)=$Piece(valList,"^",16)	;DVL_Hold4
 		Set PLIST(17)=$Piece(valList,"^",17)	;DVL_Hold5
 		
		if (DVLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQDispatchVehicleList Values :PLIST())
			;Set DVLRowID=$Get(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQDispatchVehicleList Values :PLIST() where DVL_RowID=:DVLRowID)
		}
		i SQLCODE
 		{
			Set Flag=SQLCODE
 		}
 		Quit:Flag'=0
	}
	
	Quit Flag
}

/// w ##Class(web.DHCEQAccountNo).DeleteDispatchVehicleList(",2,0,-1")
ClassMethod DeleteDispatchVehicleList(DelRowIDs As %String = "")
{
	Quit:DelRowIDs="" 0
	new Length,DVLRowID,i
	
	Set SQLCODE=0
	Set Length=$l(DelRowIDs,",")
	For i=1:1:Length
	{
		Set DVLRowID=+$Piece(DelRowIDs,",",i)
		If (DVLRowID>0)
		{
			&SQL(Delete from sqluser.DHC_EQDispatchVehicleList where DVL_RowID=:DVLRowID)
		}
		Quit:SQLCODE
	}
	Quit SQLCODE
}

/// w ##Class(web.DHCEQDispatchVehicle).GetOneDispatchVehicle(2)
ClassMethod GetOneDispatchVehicle(rowid)
{
	new result,resultex,LocCode,AppInfo,Total
	Set (result,resultex,LocCode,AppInfo,Total)=""
	
	Set result= ^DHCEQDispatchVehicle(rowid)
	Set $Piece(result,"^",2)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",2),"date")	;RequestDate
	Set resultex="^"		;RequestUserDR
	If $Piece(result,"^",13)'="" Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",13))
	If $Piece(result,"^",17)'="" Set $Piece(result,"^",17)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",17),"date")	;DispatchDate
	If $Piece(result,"^",18)'="" Set $Piece(result,"^",18)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",18),"time")	;DispatchTime
	If $Piece(result,"^",19)'="" Set $Piece(result,"^",19)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",19),"date")	;PatchDate
	If $Piece(result,"^",20)'="" Set $Piece(result,"^",20)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",20),"time")	;PatchTime
	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("24",rowid)
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit result_resultex_"^"_AppInfo
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQDispatchVehicle","GetVehicleInfo","鲁")
Query GetVehicleInfo(Vehicle As %String = "", DVListDR As %String = "", EquipTypeDR As %String = "") As %Query(ROWSPEC = "TEquip:%String,Hidden:%String,TEquipNo:%String,TVehicleNo:%String,TModel:%String,TColor:%String,TDisplacemint:%String,TMileage:%String")
{
}

ClassMethod GetVehicleInfoExecute(ByRef qHandle As %Binary, Vehicle As %String = "", DVListDR As %String = "", EquipTypeDR As %String = "") As %Status
{
 	new repid, index, EquipData
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set EquipTypeIDS=##class(web.DHCEQCommon).GetSysInfo("401005")
	;未定义交通工具类组 //20140228  Mozy0120
	If EquipTypeIDS="" Quit $$$OK
	Set EquipTypeIDS=","_EquipTypeIDS_","
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQEquip(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetVehicleInfo
	.Set TRowID = rowid
	.Quit:##Class(web.DHCEQDispatchVehicle).CheckSoueceIsInvalid("Equip",TRowID,DVListDR)
	.Set EquipData=$Get(^DHCEQEquip(rowid))
	.Set TEquipTypeDR=$Piece(EquipData,"^",63)
	.Quit:((","_TEquipTypeDR_",")'[EquipTypeIDS)
	.Quit:(EquipTypeDR'="")&(EquipTypeDR'=TEquipTypeDR)
	.Quit:(##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	.Set TStatus = $Piece(EquipData,"^",38)
	.Quit:(TStatus'=1)
	.Set TInvalidFlag = $Piece(EquipData,"^",59)
	.Quit:(TInvalidFlag'="N")
	.Set TEquip = $ZCONVERT($Piece(EquipData,"^",1),"U")
	.Set TEquipNo = $ZCONVERT($Piece(EquipData,"^",71),"U")
	.Set VDR = $Order(^DHCEQVehicle(0,"EquipDR",TRowID,""))
	.If VDR'="" Do
	..Set TVehicleNo = $ZCONVERT($Piece($Get(^DHCEQVehicle(VDR)),"^",2),"U")
	..Set TDisplacemint = $Piece($Get(^DHCEQVehicle(VDR)),"^",5)
	..Set TMileage = $Piece($Get(^DHCEQVehicle(VDR)),"^",6)
	..Set TColor = $Piece($Get(^DHCEQVehicle(VDR)),"^",7)
	..
	.Quit:((TEquip'[Vehicle)&(TEquipNo'[Vehicle)&(TVehicleNo'[Vehicle))
	.Set TModel = $Piece(EquipData,"^",3)
	.If TModel'="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.
	.Do OutputRowGetVehicleInfo
	
	Quit $$$OK
	
OutputRowGetVehicleInfo
	Set Data=$lb(TEquip,TRowID,TEquipNo,TVehicleNo,TModel,TColor,TDisplacemint,TMileage)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetVehicleInfo
	Set (TEquip,TRowID,TEquipNo,TVehicleNo,VDR,TModel,TColor,TDisplacemint,TMileage)=""
	Quit
}

ClassMethod GetVehicleInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVehicleInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetVehicleInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVehicleInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Type为空是明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQDispatchVehicle","GetDriverInfo")
Query GetDriverInfo(Driver As %String = "", DVListDR As %String = "", Type As %String = "") As %Query(ROWSPEC = "TSourceDesc:%String,Hidden:%String,TCertificateType:%String,TNo:%String,TLevel:%String,TCertificateDept:%String,TCertificateDate:%String,TAvailableDate:%String,TRemark:%String")
{
}

ClassMethod GetDriverInfoExecute(ByRef qHandle As %Binary, Driver As %String = "", DVListDR As %String = "", Type As %String = "") As %Status
{
 	new repid, index, SourceID, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	Set SourceID=0
	For  Set SourceID=$Order(^DHCEQCertificateInfo(0,"Source",0,SourceID)) Quit:SourceID=""  Do
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQCertificateInfo(0,"Source",0,SourceID,rowid)) Quit:rowid=""  Do
	..Do ResetVariablesGetDriverInfo
	..Set TRowID = rowid
	..Quit:(Type'="")&(##Class(web.DHCEQDispatchVehicle).CheckSoueceIsInvalid("Driver",TRowID,DVListDR))
	..Set TSourceDesc=##class(web.DHCEQCommon).GetTrakNameByID("user",SourceID)
	..Quit:(Driver'="")&(TSourceDesc'[Driver)
	..;Set TSourceType = $CASE(TSourceType,"0":"人员","1":"供应商","2":"生产厂商","3":"其他",:"没有定义")
	..Set TCertificateTypeDR = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",3)
	..Set TCertificateType = $Piece($Get(^DHCEQCCode("DHCEQCCertificateType",TCertificateTypeDR)),"^",2)
	..Set TNo = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",4)
	..Set TLevel = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",5)
	..Set TLevel = $CASE(TLevel,"1":"初级","2":"中级","3":"高级","4":"其他",:"")
	..Set TCertificateDept = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",6)
	..Set TCertificateDate = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",7)
	..If TCertificateDate '="" Set TCertificateDate = ##class(web.DHCEQCommon).TransValueToPage(TCertificateDate,"date")
	..Set TAvailableDate = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",8)
	..If TAvailableDate '="" Set TAvailableDate = ##class(web.DHCEQCommon).TransValueToPage(TAvailableDate,"date")
	..Set TRemark = $Piece($Get(^DHCEQCertificateInfo(rowid)),"^",9)
	..Do OutputRowGetDriverInfo
	
	Quit $$$OK
	
OutputRowGetDriverInfo
	Set Data=$lb(TSourceDesc,TRowID,TCertificateType,TNo,TLevel,TCertificateDept,TCertificateDate,TAvailableDate,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetDriverInfo
	Set (TSourceDesc,TRowID,TCertificateType,TNo,TLevel,TCertificateDept,TCertificateDate,TAvailableDate,TRemark)=""
	Quit
}

ClassMethod GetDriverInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDriverInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetDriverInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDriverInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQDispatchVehicle).DeleteData("2")
ClassMethod DeleteData(RowID As %String = "")
{
	Set $ZT="ERRORDelete"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	Set SQLCODE=0
	TSTART
	&SQL(Update SQLUSER.DHC_EQDispatchVehicle Set DV_InvalidFlag='Y',DV_CancelUser=:User,DV_CancelDate=:Date,DV_CancelTime=:Time where DV_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
 	Quit SQLCODE
ERRORDelete
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQDispatchVehicle).SubmitData(2)
ClassMethod SubmitData(RowID As %String = "")
{
	Quit:RowID="" ""
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new (RowID, User)
	Set InvalidFlag = $Piece($Get(^DHCEQDispatchVehicle(RowID)),"^",25)
	Quit:InvalidFlag="Y" -1015
	Set $ZT="ERRORSubmit"
	
	;20140422  Mozy0128	获取第一条明细记录的设备类组
	Set DVLRowID=$Order(^DHCEQDispatchVehicleList(0,"DispatchVehicle",RowID,""))
	Set EquipDR = $Piece($Get(^DHCEQDispatchVehicleList(DVLRowID)),"^",2)
	Set EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("24")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "","")
	Quit:ApproveSet="" -4007
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfo(2)=ApproveType
	Set AppInfo(3)=RowID
	Set AppInfo(4)=ApproveSet
	Set AppInfo(5)=NextRole
	Set AppInfo(6)=NextStep
	Set AppInfo(7)=""			;ApproveStatus  当前审核步骤
	Set AppInfo(8)=""			;ApproveRoleDR	
	Set AppInfo(9)="1"			;Status
	
	Set AuditFlag=0
	If (AutoAuditFlag="Y")&&(NextStep="")
	{
		Set AuditFlag=1
		Set PLIST(4)="2"		;Status
		Set AppInfo(9)="2"		;Status
	}
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))	
	
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"24",User)
	If SQLCODE
	{
		TROLLBACK
	 	Quit SQLCODE
	}

	If ApproveInfoID=""
 	{
	 	&SQL(insert into sqluser.DHC_EQApproveInfo values :AppInfo())		
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)		
 	}
 	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	Set PLIST(4) = "1"		;Status
	Set PLIST(11) = User	;SubmitUserDR
 	Set PLIST(12) = +$H		;SubmitDate
	Set PLIST(13) = $Piece($H,",",2)	;SubmitTime
	&SQL(update sqluser.DHC_EQDispatchVehicle values :PLIST() where DV_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQDispatchVehicle).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}		
	}
	/*
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("21", RowID, User, ApproveFlow, "N","",AuditFlag)	;生成业务消息
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	*/
	TCOMMIT
 	Quit RowID
ERRORSubmit
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQDispatchVehicle).LastAuditAction(52)
ClassMethod LastAuditAction(RowID)
{
	//20140228  Mozy0120
	Set SQLCODE=##class(web.DHCEQDispatchVehicle).UpdateMileageToVehicle(RowID)
	q SQLCODE
}

/// 描述:审核
/// w ##Class(web.DHCEQDispatchVehicle).AuditData("10","17","1","")
ClassMethod AuditData(RowID As %String = "", CurRole, RoleStep, editFieldsInfo)
{
	Quit:RowID="" ""
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new (RowID,CurRole,RoleStep,editFieldsInfo,User)
	new ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,AuditFlag
	Set $ZT="ERRORAudit"
	Set Date=+$H
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("24")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("24", RowID)	
	Quit:ApproveSet="" -4007	
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfo(5)=NextRole
	Set AppInfo(6)=NextStep
	Set AppInfo(7)=RoleStep		;ApproveStatus
	Set AppInfo(8)=CurRole		;ApproveRoleDR
	Set AppInfo(9)="1"			;Status	
	
	TSTART
	Set AuditFlag=0
	If ((NextStep="")||(LastFlag="Y"))
	{
		If ($Piece($Get(^DHCEQDispatchVehicle(RowID)),"^",3)=2)
		{
			TROLLBACK
			Quit -1010
		}
		Set AuditFlag=1
		Set PLIST(4)="2"
		Set AppInfo(9)="2"	;Status
		&SQL(update sqluser.DHC_EQDispatchVehicle values :PLIST() where DV_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;记录单据当前审批状态
	Set ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}	
	If editFieldsInfo'=""
	{
		Set SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	If Actions'=""
	{
		//执行当前角色要执行的动作
		Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		//20140228  Mozy0120
		Set SQLCODE=##Class(web.DHCEQDispatchVehicle).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}		
	}
	/*;Modified by jdl 2011-3-2  jdl0071
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("21", RowID, User, ApproveFlow, "N", CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}*/
	TCOMMIT
 	Quit RowID
ERRORAudit
	TRollBack
	Set ErrorMsg=$ZE				//得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg		//返回错误消息
}

/// w ##Class(web.DHCEQDispatchVehicle).CancelSubmitData("10",2)
ClassMethod CancelSubmitData(RowID As %String = "", CurRole, CancelToFlowDR)
{
	Quit:RowID="" ""
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new (RowID,CurRole,CancelToFlowDR,ApproveSetDR,User)
	Set $ZT="ERRORCancel"
	Set Date=+$H
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	If (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
	}
	
	TSTART
	Set AppInfo(5)=ApproveRoleDR
	Set AppInfo(6)=Step
	Set AppInfo(7)=""		;ApproveStatus
	Set AppInfo(8)=""		;ApproveRoleDR
	Set AppInfo(9)=Status	;Status	
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("24")
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set PLIST(4)=Status
	&SQL(update sqluser.DHC_EQDispatchVehicle values :PLIST() where DV_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
 	Quit RowID
ERRORCancel
	TRollBack
	Set ErrorMsg=$ZE				//得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息
}

/// 检测车辆,司机是否有效(未在别的有效派车单里)
/// SourceType:"Equip","Driver"
/// DVListDR	过滤当前明细(该明细的车辆,司机信息允许显示)
/// 返回	0:有效	其他:无效
/// w ##Class(web.DHCEQDispatchVehicle).CheckSoueceIsInvalid("Equip",765)
ClassMethod CheckSoueceIsInvalid(SourceType As %String = "", SourceID As %String = "", DVListDR As %String = "")
{
	new Flag,rowid
	Set Flag=0
	Quit:(SourceType="")||(SourceID="") Flag
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQDispatchVehicleList(0,SourceType,SourceID,rowid)) Quit:(rowid="")||(Flag'=0)  Do
	.Quit:(DVListDR'="")&(DVListDR=rowid)
	.Set TDispatchVehicleDR = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",1)
	.Set TInvalidFlag = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",25)
	.Quit:TInvalidFlag'="N"
	.Set TStatus = +$Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",3)
	.If TStatus'=2 Set Flag=1
	
	Quit Flag
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQDispatchVehicle","GetDispatchVehicleDetail","^StartDate=19/01/2014^EndDate=^DispatchVehicleNo=12^Arrive=^Status=^RequestUserDR=^VehicleNo=^DriverDR=^EquipNo=^InvalidFlag=")
Query GetDispatchVehicleDetail(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TJob:%String,TRowID:%String,TDispatchVehicleDR:%String,TDispatchVehicleNo:%String,TRequestDate:%String,TStatus:%String,TRequestUser:%String,TArrive:%String,TEquip:%String,TVehicleNo:%String,TDriver:%String")
{
}

ClassMethod GetDispatchVehicleDetailExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
 	new repid, index
 	new rowid,TotalQty,PNum,TotalFlag
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Quit:vData="" $$$OK
 	
 	Do ##Class(web.DHCEQCommon).KillTempGlobal("DispatchVehicleDetail")
 	
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
	Set DispatchVehicleNo=##Class(web.DHCEQCommon).GetDataByName(vData,"DispatchVehicleNo")
	Set Arrive=##Class(web.DHCEQCommon).GetDataByName(vData,"Arrive")
	Set Arrive=$ZCONVERT(Arrive,"U")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")
	Set RequestUserDR=##Class(web.DHCEQCommon).GetDataByName(vData,"RequestUserDR")
	Set VehicleNo=##Class(web.DHCEQCommon).GetDataByName(vData,"VehicleNo")
	Set VehicleNo=$ZCONVERT(VehicleNo,"U")
	Set DriverDR=##Class(web.DHCEQCommon).GetDataByName(vData,"DriverDR")
	Set EquipNo=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipNo")
	Set EquipNo=$ZCONVERT(EquipNo,"U")
	If ##Class(web.DHCEQCommon).ExistsElement(vData,"InvalidFlag")
	{
		Set InvalidFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"InvalidFlag")
	}
	Else
	{
		Set InvalidFlag="N"
	}
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set StartDate= ##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EndDate= ##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	If StartDate="" Set StartDate=0
 	If EndDate="" Set EndDate=+$H
	Set index=2
	Set PNum=1
	Set TJob=$Job
	Set TotalQty=0
	
	Set rowid=0 
	For  Set rowid=$Order(^DHCEQDispatchVehicleList(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetInStockDetail
	.Set TRowID = rowid
	.Set TDispatchVehicleDR = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",1)
	.Set TInvalidFlag = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",25)
	.Quit:TInvalidFlag'="N"
	.;Quit:(InvalidFlag'="")&&(InvalidFlag'=TInvalidFlag)
	.Set TDispatchVehicleNo = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",1)
	.Quit:TDispatchVehicleNo=""
	.Quit:(DispatchVehicleNo'="")&(TDispatchVehicleNo'[DispatchVehicleNo)
	.Set TRequestDate = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",2)
	.Quit:(TRequestDate>EndDate)||(TRequestDate<StartDate)
	.Set TRequestDate = ##class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	.Set TStatus = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",3)
	.Quit:(Status'="")&(Status'=TStatus)
	.Set TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.Set TRequestUserDR = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",13)
	.Quit:(RequestUserDR'="")&(RequestUserDR'=TRequestUserDR)
	.If TRequestUserDR '="" Set TRequestUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	.;Set TUserName = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",14)
	.;Set TRequestReason = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",15)
	.Set TArrive = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",16)
	.Set TArrive = $ZCONVERT(TArrive,"U")
	.Quit:(Arrive'="")&(TArrive'[Arrive)
	.;Set TRemark = $Piece($Get(^DHCEQDispatchVehicle(TDispatchVehicleDR)),"^",21)
	.
	.Set TEquipDR = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",2)
	.If TEquipDR'="" Do
	..Set EquipData=$Get(^DHCEQEquip(TEquipDR))
	..Set TEquip = $ZCONVERT($Piece(EquipData,"^",1),"U")
	..Set TEquipNo = $ZCONVERT($Piece(EquipData,"^",71),"U")
	..Set VDR = $Order(^DHCEQVehicle(0,"EquipDR",TEquipDR,""))
	..If VDR'="" Do
	...Set TVehicleNo = $ZCONVERT($Piece($Get(^DHCEQVehicle(VDR)),"^",2),"U")
	...Set TDisplacemint = $Piece($Get(^DHCEQVehicle(VDR)),"^",5)
	...Set TMileage = $Piece($Get(^DHCEQVehicle(VDR)),"^",6)
	...Set TColor = $Piece($Get(^DHCEQVehicle(VDR)),"^",7)
	..Set TModel = $Piece(EquipData,"^",3)
	..If TModel'="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.Quit:(VehicleNo'="")&(TVehicleNo'[VehicleNo)
	.Set TDriverDR=""
	.Set DVLDR = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",3)	;证件表记录
	.Quit:(DriverDR'="")&(DVLDR'=DriverDR)
	.If DVLDR'="" Do
	..Set TDriverDR = $Piece($Get(^DHCEQCertificateInfo(DVLDR)),"^",2)
	..Set TDriver = ##class(web.DHCEQCommon).GetTrakNameByID("user",TDriverDR)
	.Set TCardNo = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",4)
	.Set TRunDate = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",5)
	.Set TRunTime = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",6)
	.Set TEndDate = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",7)
	.Set TEndTime = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",8)
	.Set TStartMileage = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",9)
	.Set TEndMileage = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",10)
	.Set TRemark = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",11)
	.Set THold1=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",12)
	.Set THold2=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",13)
	.Set THold3=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",14)
	.Set THold4=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",15)
	.Set THold5=$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",16)
	.Set TotalQty=TotalQty+1 ;TQuantityNum
	.Do OutputRowGetInStockDetail
	
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	If (TotalFlag'="")&&(TotalFlag'="0")
	{
		If TotalFlag="1" Set index=1
		If TotalFlag="2" Set index=index+1
		If TotalFlag="3" Set index=0
		Do ResetVariablesGetInStockDetail
		Set TRequestDate="合计:"
		Set TEquip=TotalQty_" 台/辆"
		Set Data=$lb(TJob,TRowID,TDispatchVehicleDR,TDispatchVehicleNo,TRequestDate,TStatus,TRequestUser,TArrive,TEquip,TVehicleNo,TDriver)
		Set ^CacheTemp(repid,index)=Data
		Set ^DHCEQTemp("DispatchVehicleDetail",+$H,TJob,PNum)=TRowID_"^"_TDispatchVehicleNo_"^"_TRequestDate_"^"_TStatus_"^"_TRequestUser_"^"_TArrive_"^"_TEquip_"^"_TVehicleNo_"^"_TDriver
	}
	Quit $$$OK
	
OutputRowGetInStockDetail
	Set Data=$lb(TJob,TRowID,TDispatchVehicleDR,TDispatchVehicleNo,TRequestDate,TStatus,TRequestUser,TArrive,TEquip,TVehicleNo,TDriver)
	Set ^CacheTemp(repid,index)=Data
	Set ^DHCEQTemp("DispatchVehicleDetail",+$H,TJob,PNum)=TRowID_"^"_TDispatchVehicleNo_"^"_TRequestDate_"^"_TStatus_"^"_TRequestUser_"^"_TArrive_"^"_TEquip_"^"_TVehicleNo_"^"_TDriver
	Set PNum=PNum+1
	Set index=index+1
	Quit
ResetVariablesGetInStockDetail
	Set (TRowID,TDispatchVehicleDR,TDispatchVehicleNo,TRequestDate,TStatus,TRequestUser,TArrive,TEquip,TVehicleNo,TDriver)=""
	Quit
}

ClassMethod GetDispatchVehicleDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispatchVehicleDetailExecute ]
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

ClassMethod GetDispatchVehicleDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispatchVehicleDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//20140228  Mozy0120

ClassMethod GetOneDispatchVehicleDetail(PNum, job)
{
	If PNum=0 Quit $Order(^DHCEQTemp("DispatchVehicleDetail",+$H,job,""),-1)
	Quit $Get(^DHCEQTemp("DispatchVehicleDetail",+$H,job,PNum))
}

//20140228  Mozy0120

/// w ##class(web.DHCEQDispatchVehicle).UpdateMileageToVehicle(14)
ClassMethod UpdateMileageToVehicle(RowID)
{
	new rowid,EquipDR,VDR,DVLEndMileage
	Set SQLCODE=0
	Set rowid=0 
	For  Set rowid=$Order(^DHCEQDispatchVehicleList(0,"DispatchVehicle",RowID,rowid)) Quit:(rowid="")||(SQLCODE)  Do
	.Set EquipDR = $Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",2)
	.If EquipDR'="" Do
	..//更新及新增车辆信息	20140331  Mozy0124
	..Set DVLEndMileage = +$Piece($Get(^DHCEQDispatchVehicleList(rowid)),"^",10)
	..Set VDR = $Order(^DHCEQVehicle(0,"EquipDR",EquipDR,""))
	..If VDR'="" Do
	...&SQL(update SQLUSER.DHC_EQVehicle set V_Mileage=:DVLEndMileage where V_RowID = :VDR)
	..Else  Do
	...Kill vinfo
	...Set vinfo(2) = EquipDR
	...Set vinfo(7) = DVLEndMileage
	...&SQL(insert into SQLUSER.DHC_EQVehicle values :vinfo())
	Quit SQLCODE
}

}
