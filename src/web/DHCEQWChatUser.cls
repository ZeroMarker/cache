Class web.DHCEQWChatUser Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/*
*微信绑定切换方法
*记录绑定信息及绑定记录 新增解除绑定
*-4:已有绑定;-3:绑定次数已超;-2:绑定失败
*QW2016921
*insert into DHC_EQCSysSet (SS_Code,SS_Value,SS_Desc,SS_Remark,SS_Hidden)values('990047','3','身份验证失败限制次数','','N')
* // Modify by zx 2021-09-02 增加访问类型 BUG ZX0140
* // AccessType:0:PDA端;1:企业号;2:公众号;3:PC端
*/

// w ##class(web.DHCEQWChatUser).BindChatID("","","","WuYue","0","","1")

ClassMethod BindChatID(GroupID, UserID, TLocDR, ChatID, Type, Password, AccessType, UserTel)
{
	k PLIST,BLPLIST
	s (rowid ,count,date,syscount,pass,chatid)=""  ////Modified By QW20200904 Begin
	s syscount=3 ;##class(web.DHCEQCommon).GetSysInfo("990047")
	
	//s ChatID=UserID //add by zx 2020-07-08 公众号chatid获取不到时特殊处理
	i (ChatID="")||(UserID="") q -2_"^"_"无效用户" //add by zx 2016-11-24 用户信息都为空时不出来
	s BLPLIST(2) = ChatID	;微信帐户id
	s BLPLIST(3) = UserID	;用户id
	s BLPLIST(4) = GroupID ;安全组id
	s BLPLIST(5) = TLocDR	;科室id
	s BLPLIST(6) = +$H	;验证日期
	s BLPLIST(7) = $P($H,",",2)	;验证日期
 	s BLPLIST(8) = Type ;0:绑定 1:切换
 	s BLPLIST(9) = AccessType ;0:PDA端;1:企业号;2:公众号;3:PC端  Modify by zx 2021-09-02
	&SQL(Insert Into SQLUSER.DHC_EQWChatBindLog Values :BLPLIST()) ;插入日志
	;保存用户信息
	&SQL(Select WCU_RowID,WCU_Password,WCU_ChatID into :rowid,:pass,:chatid from SQLUSER.DHC_EQWChatUser where WCU_UserDR=:UserID and WCU_AccessType=:AccessType) //Modify by zx 2021-09-02 增加访问类型判断
	i ((Type="0")&&(rowid'="")&&(pass'=""))  //Modified by QW20210907
	{
		if (AccessType="0") q 0_"^"_rowid   //pda 端不判断绑定，因为要经常登录
		else  q -4_"^"_"" //Modified By ZX 2020-12-31 BUG ZX0126 已绑定校验
	}
	s PLIST(2) = ChatID	;微信帐户id
	s PLIST(3) = UserID	;用户id
	s PLIST(4) = GroupID ;安全组id
	s PLIST(5) = TLocDR	;科室id
	s PLIST(6) = +$H	;验证日期
	s PLIST(7) = $P($H,",",2)	;验证日期
	s PLIST(9) = Password
	s PLIST(10) = AccessType ;0:PDA端;1:企业号;2:公众号;3:PC端  Modify by zx 2021-09-02
 	s PLIST(11) = UserTel  //Modify by zx 2022-08-25
	if (Type'="2")
	{
		&SQL(Select WCU_RowID,WCU_BindCount,WCU_Date into :rowid,:count,:date from SQLUSER.DHC_EQWChatUser where WCU_ChatID=:ChatID and WCU_AccessType=:AccessType) //Modify by zx 2021-09-02 增加访问类型判断
		if (count'=""){
			if (date<PLIST(6)) {
				s count=0
			}
			if (Type="0") s PLIST(8) = count+1	;绑定次数
		}else{
			s PLIST(8) = 1	;绑定次数
		}
		if ((Type="0")&&(PLIST(8)>syscount)) q -3_"^"_"" ;绑定次数超过限制
		i (rowid="") //新增记录
		{
			&SQL(Insert Into SQLUSER.DHC_EQWChatUser Values :PLIST())
		}
		else  //更新按钮操作
		{
			&SQL(Update SQLUSER.DHC_EQWChatUser Values :PLIST() where WCU_RowID = :rowid)
		}
	}else
	{
		&SQL(delete from SQLUSER.DHC_EQWChatUser where WCU_ChatID=:ChatID and WCU_UserDR=:UserID and WCU_AccessType=:AccessType) //Modify by zx 2021-09-02 增加访问类型判断
		if SQLCODE  q -2_"^"_SQLCODE
		q -5_"^"_""
	}
	if SQLCODE  q -2_"^"_SQLCODE
	Set ID=$g(%ROWID)
	q 0_"^"_ID
}

/// w ##Class(web.DHCEQWChatUser).CheckoutChatID("0800276521ae","0")
/// Modify by zx 2021-09-02 增加访问类型 BUG ZX0140
/// AccessType:0:PDA端;1:企业号;2:公众号;3:PC端
ClassMethod CheckoutChatID(ChatID, AccessType)
{
	s (GroupID,UserID,LocID,Group,User,Loc,UserTel,Password,HospitalID,LogProcess,UserTel)=""   //Modified By QW20200108 BUG:QW0035 增加HospitalID
	if ChatID=""  q "^^^^^^^^"
	s rowid=0
	f  s rowid=$o(^DHCEQWChatUser(0,"WChat",ChatID,rowid)) q:rowid=""  d
	.s WCAccessType=$p($g(^DHCEQWChatUser(rowid)),"^",9)
	.q:(AccessType'="")&&(AccessType'=WCAccessType)
	.s UserID=$p($g(^DHCEQWChatUser(rowid)),"^",2)
	.i UserID'=""  s User=##class(web.DHCEQCommon).GetTrakNameByID("user",UserID)
	.i UserID'=""  s UserTel=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",6)
	.s GroupID=$p($g(^DHCEQWChatUser(rowid)),"^",3)
	.i GroupID'=""  s Group=##class(web.DHCEQCommon).GetTrakNameByID("grp",GroupID)
	.s LocID=$p($g(^DHCEQWChatUser(rowid)),"^",4)
	.i LocID'=""  s Loc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)
	.if LocID'="" s HospitalID=$p($g(^CTLOC(LocID)),"^",22) ; //Add By QW20200108 BUG:QW0035 增加HospitalID
	.s Password=$p($g(^DHCEQWChatUser(rowid)),"^",8)
	.s UserTel=$p($g(^DHCEQWChatUser(rowid)),"^",10) //Modify by zx 2022-08-25
	// Modify by zx 2021-09-02 调整为获取session时校验密码并处理解绑 BUG ZX0140
	s ResultStr=UserID_"^"_GroupID_"^"_LocID_"^"_User_"^"_Group_"^"_Loc_"^"_UserTel_"^"_Password_"^"_HospitalID_"^"_UserTel //Modify by zx 2022-08-25
	if UserID'=""
	{
		s LogonName=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",1)
		s result=##Class(web.DHCEQCommon).InnerLogon(LogonName,Password)
		s result=$p(result,"@",1)
		if +result<0
		{
			&SQL(delete from SQLUSER.DHC_EQWChatUser where WCU_UserDR=:UserID and WCU_AccessType=:AccessType)
			q "^^^^^^^^"
		}
		k LOGPLIST
		s LOGPLIST(2) = ChatID
		s LOGPLIST(3) = UserID
		s LOGPLIST(4) = AccessType
		s LOGPLIST(5) = "1"
		s LOGPLIST(6) = +$H
		s LOGPLIST(7) = $P($H,",",2)
		s LOGPLIST(10) = "Y"
		&SQL(Insert Into SQLUSER.DHC_EQWChatAccessRecord Values :LOGPLIST())
		if SQLCODE  q "^^^^^^^^"
		Set LogProcess=$g(%ROWID)
	}
	q ResultStr_"^"_LogProcess   //Modified By ZX 2021-09-02 增加LogProcess
}

/// w ##Class(web.DHCEQWChatUser).CallPermission("^^^^^0^^PDA201")
/// QW20160920 判断用户调用权限及记录调用日志
/// Modify by zx 2021-09-02 增加访问类型 BUG ZX0140
/// AccessType:0:PDA端;1:企业号;2:公众号;3:PC端
ClassMethod CallPermission(vData)
{
	k PLIST
	s (GRPID,LocID,UserID,rowid,Password,result,TUser,ActionCode)=""
	s UserID=$P(vData,"^",2)
	s GRPID=$P(vData,"^",3)
	s LocID=$P(vData,"^",4)
	s Password=$P(vData,"^",5)
	s AccessType=$P(vData,"^",6)
	s LogProcess=$P(vData,"^",7)
	s ActionCode=$P(vData,"^",8)
	s Permission=0
	;if UserID="" s Permission=0

	//Modify by zx 2020-11-24 消息发送无权限限制
	if ((ActionCode="0046")||(ActionCode="0045")||(ActionCode="0044")||(ActionCode="0042")||(ActionCode="0047")||(ActionCode="0043")||(ActionCode="0090")||(ActionCode="0999")||(ActionCode="0059")||(ActionCode="msg101"))
	{ s Permission=1}
	if (ActionCode="PDA201")
	{ s Permission=1}
	else{
		if (UserID'="")
		{
			;s TUser=$p($g(^SSU("SSUSR",UserID)),"^",1)
			;s result=##Class(web.DHCEQCommon).Logon(TUser,Password)
			s TUser=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",1)
			s result=##Class(web.DHCEQCommon).InnerLogon(TUser,Password)
		    s result=$p(result,"@",1)
		    if result>0  s Permission=1
		}
	}
	;&SQL(Select SSUSR_RowId into :rowid from SQLUSER.SS_User where SSUSR_DefaultDept_DR=:LocID and SSUSR_Group=:GRPID)
	;if rowid="" s Permission=0
	;if rowid'=$P(vData,"^",2) s Permission=0
	/*if (UserID'="")
	{
		&SQL(Select SSUSR_RowId into :rowid from SQLUSER.SS_User where SSUSR_DefaultDept_DR=:UserID)
		if rowid="" s Permission=0
	}*/
	s PLIST(2) = $P(vData,"^",1)	;微信帐户id
	s PLIST(3) = UserID	;用户id
	s PLIST(4) = GRPID ;安全组id
	s PLIST(5) = LocID	;科室id
	s PLIST(6) = +$H	;调用日期
	s PLIST(7) = $P($H,",",2)	;调用时间
	s PLIST(8) = ActionCode	;方法code
	s PLIST(9) = "Y" 	;访问是否合法
	s PLIST(10) = AccessType
	s PLIST(13) = LogProcess
	if Permission=0
	{
		s PLIST(9) = "N"
		// Modify by zx 2021-09-02 调整为获取session时校验密码并处理解绑 BUG ZX0140
		;&SQL(delete from SQLUSER.DHC_EQWChatUser where WCU_UserDR=:UserID)  //add by zx 20171116 Bug ZX0050 HIS用户密码改变后自动解绑
		;if SQLCODE  q 0_"^"_SQLCODE
	}
	s SQLCODE=0
	s ID=""
	if (ActionCode'="0090")
	{
		&SQL(Insert Into SQLUSER.DHC_EQWChatLog Values :PLIST())
		if SQLCODE  q Permission_"^"_SQLCODE
		Set ID=$g(%ROWID)
	}
	q Permission_"^"_ID
}

/// add by lmm 2016-12-09
/// 微信操作日志查询 
/// do ##Class(%ResultSet).RunQuery("web.DHCEQWChatUser","GetWChatOperationLog","","","","","","0001")
Query GetWChatOperationLog(LogType, ChatID, User, StartDate, EndDate, MethodDesc) As %Query(ROWSPEC = "TRow,TRowID,TLogType,TChatID,TUserDR,TUser,TGroupDR,TGroup,TLocDR,TLoc,TLogDate,TLogTime,TBindType,TMethodCode,TPermission,TMethodDescC,TMethodDescE")
{
}

ClassMethod GetWChatOperationLogExecute(ByRef qHandle As %Binary, LogType, ChatID, User, StartDate, EndDate, MethodDesc) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	s TRow=0
 	s rowid=0
	i StartDate'="" s StartDate=$ZDH(StartDate,3)
	i EndDate'="" s EndDate=$ZDH(EndDate,3)
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	i StartDate>EndDate q

 	if (LogType="1")||(LogType="")  d
 	.f  s rowid=$O(^DHCEQWChatBindLog(rowid)) q:rowid=""  d
 	..d ResetVariableGetWChatOperationLog
 	..q:(MethodDesc'="")
 	..s TLogType="绑定日志"
 	..s TRowID=rowid
 	..S TChatID=$P(^DHCEQWChatBindLog(rowid),"^",1)  ;微信id
 	..q:(ChatID'="")&&(ChatID'=TChatID)
 	..s TUserDR=$P(^DHCEQWChatBindLog(rowid),"^",2)  ;用户
	..i TUserDR '="" s TUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
 	..q:(User'="")&&(User'=TUserDR)
 	..s TGroupDR=$P(^DHCEQWChatBindLog(rowid),"^",3)  ;安全组
	..i TGroupDR '="" s TGroup = ##class(web.DHCEQCommon).GetTrakNameByID("grp",TGroupDR)
 	..s TLocDR=$P(^DHCEQWChatBindLog(rowid),"^",4)  ;科室
	..i TLocDR '="" s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
 	..s TLogDate1=$P(^DHCEQWChatBindLog(rowid),"^",5)  ;日志日期
	..s TLogDate=$zd($p($g(^DHCEQWChatBindLog(rowid)),"^",5),3)
	..q:(TLogDate1>EndDate)||(TLogDate1<StartDate)
	..s TLogTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQWChatBindLog(rowid)),"^",6),"time")
	..//s TBindType = $CASE($p(EquipData,"^",87),"1":"租借中",:"待租")  ;租借状态
 	..s TBindType=$CASE($P(^DHCEQWChatBindLog(rowid),"^",7),"0":"绑定","1":"切换","2":"解绑",:"")  ;绑定类型
 	..s TRow=TRow+1
	..d OutputRowGetWChatOperationLog

	if (LogType="2")||(LogType="")  d 
 	.f  s rowid=$O(^DHCEQWChatLog(rowid)) q:rowid=""  d
 	..d ResetVariableGetWChatOperationLog
 	..s TLogType="调用日志"
 	..s TRowID=rowid
 	..q:TRowID=0
 	..S TChatID=$P(^DHCEQWChatLog(rowid),"^",1)  ;微信id
 	..q:(ChatID'="")&&(TChatID'=ChatID)
 	..s TUserDR=$P(^DHCEQWChatLog(rowid),"^",2)  ;用户
	..i TUserDR '="" s TUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
 	..q:(User'="")&&(User'=TUserDR)
 	..s TGroupDR=$P(^DHCEQWChatLog(rowid),"^",3)  ;安全组
	..i TGroupDR '="" s TGroup = ##class(web.DHCEQCommon).GetTrakNameByID("grp",TGroupDR)
 	..s TLocDR=$P(^DHCEQWChatLog(rowid),"^",4)  ;科室
	..i TLocDR '="" s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
 	..s TLogDate1=$P(^DHCEQWChatLog(rowid),"^",5)  ;日志日期
	..s TLogDate=$zd($p($g(^DHCEQWChatLog(rowid)),"^",5),3)
	..q:(TLogDate1>EndDate)||(TLogDate1<StartDate)
	..s TLogTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQWChatLog(rowid)),"^",6),"time")
 	..s TMethodCode=$P(^DHCEQWChatLog(rowid),"^",7)  ;方法代码
 	..i TMethodCode'="" s TMethodDescC=..GetMethodDescByCode(TMethodCode,0)
 	..i TMethodCode'="" s TMethodDescE=..GetMethodDescByCode(TMethodCode,1)
 	..q:(MethodDesc'="")&&(TMethodCode'[MethodDesc)
 	..s TPermission=$CASE($P(^DHCEQWChatLog(rowid),"^",8),"Y":"成功调用","N":"失败调用",:"")  ;许可
 	..s TRow=TRow+1
	..d OutputRowGetWChatOperationLog
 	
	Quit $$$OK
	
ResetVariableGetWChatOperationLog
	s (TRow,TRowID,TLogType,TChatID,TUserDR,TUser,TGroupDR,TGroup,TLocDR,TLoc,TLogDate,TLogTime,TBindType,TMethodCode,TPermission,TMethodDescC,TMethodDescE)=""
	quit
	
OutputRowGetWChatOperationLog
	s Data=$lb(TRow,TRowID,TLogType,TChatID,TUserDR,TUser,TGroupDR,TGroup,TLocDR,TLoc,TLogDate,TLogTime,TBindType,TMethodCode,TPermission,TMethodDescC,TMethodDescE)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetWChatOperationLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWChatOperationLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWChatOperationLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWChatOperationLogExecute ]
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

/// 入参：
///     MethodCode	方法代码
///     DescType	方法描述类型 0:汉字 1:调用具体方法名
/// 返回：返回方法描述类型对应的描述
/// w ##Class(web.DHCEQWChatUser).GetMethodDescByCode("0001",0)
ClassMethod GetMethodDescByCode(MethodCode As %String = "", DescType)
{
	n MethodDesc
	s MethodDesc="未定义"
	if (DescType=1)
	{
		s MethodDesc=$CASE(MethodCode,
			              "0001":"web.DHCEQCommon:OutputToXml",
			              "0002":"web.DHCEQCommon:doFormatToXML",
			              "0003":"web.DHCEQM.DHCEQMMaintRequest:UpdateMaintRequest",
			              "0004":"web.DHCEQM.DHCEQMExObj:AutoSaveExObj",
						  "0005":"web.DHCEQM.DHCEQMMaintRequest:GetMaintRequest",
						  "0006":"web.DHCEQM.DHCEQMMaintRequest:SubmitMaintRequest",
						  "0007":"web.DHCEQM.DHCEQMMaintRequest:AuditData",
						  "0008":"未调用",
						  "0010":"web.DHCEQM.DHCEQMMaintRequest:GetOneMaintRequest",
						  "0011":"web.DHCEQYJSRunQian:GetEvaluateType",
						  "0012":"web.DHCEQYJSRunQian:EvaluateDetail",
						  "0013":"web.DHCEQCommon:GetLocByUserID",
						  "0014":"web.DHCEQM.DHCEQ34MMaintRequest:SaveEvaluation",
						  "0015":"web.DHCEQCommon:GetSysInfo",
						  "0018":"web.DHCEQM.DHCEQMMaintRequest:GetOneEquipMaint",
						  "0019":"web.DHCEQM.DHCEQMMaintRequest:SaveMaintProgress",
						  "0020":"web.DHCEQM.DHCEQMMaintRequest:GetMaintProgress",
						  "0021":"web.DHCEQM.DHCEQMMaintRequest:GetOneEvaluate",
						  "0022":"web.DHCEQ.Process.DHCEQPicture:SaveData",
						  "0023":"web.DHCEQ.Process.DHCEQPictureList:GetPictureListInfo",
						  "0024":"web.DHCEQCSysMenus:GetAllowMenus",
						  "0025":"web.DHCEQMessages:GetBussDataByCode",
						  "0026":"web.DHCEQM.DHCEQMCEmergencyLevel:EmergencyLevel",
						  "0027":"web.DHCEQFind:EQUser",
						  "0028":"web.DHCEQM.DHCEQMCFaultType:FaultType",
						  "0029":"web.DHCEQM.DHCEQMCFaultReason:Faultreason",
						  "0030":"web.DHCEQM.DHCEQMCDealMethod:DealMethod",
						  "0031":"web.DHCEQM.DHCEQMCMaintMode:MaintMode",
						  "0032":"web.DHCEQCRoleBuss:GetBussByRole",
						  "0033":"web.DHCEQM.DHCEQMCFaultCase:FaultCase",
						  "0034":"web.DHCEQApprove:GetRequiredFields",
						  "0035":"web.DHCEQCApproveFlow:GetApproveFlowType",
						  "0036":"web.DHCEQCApproveFlow:GetUserApprovesForPDA",
						  "0037":"web.DHCEQApprove:GetApproveInfoBySourceID",
						  "0038":"web.DHCEQM.DHCEQMCSeverityLevel:SeverityLevel",
						  "0039":"web.DHCEQM.DHCEQMMaintRequest:GetMaintRequestDetail",
						  "0040":"web.DHCEQCService:LookUp",
						  "0041":"web.DHCEQM.DHCEQMCMaintResults:LookUp",
						  "0042":"web.DHCEQCommon:Logon",
						  "0043":"web.DHCEQCommon:LogonLocGrp",
						  "0044":"web.DHCEQCommon:CheckFunction",
						  "0045":"web.DHCEQWChatUser:BindChatID",
						  "0046":"web.DHCEQCommon:OutputToXml",
						  "0047":"web.DHCEQMessages:GetBussDataForWChat",
						  "0048":"未调用",
						  "0049":"web.DHCEQMCMaintGroupList:GetMaintGroupList",
						  "0050":"web.DHCEQM.DHCEQMMaintPart:SaveData",
						  "0051":"web.DHCEQM.DHCEQMMaintPart:SubmitManage",
						  "0052":"web.DHCEQM.DHCEQMMaintPart:CancelManage",
						  "0053":"web.DHCEQM.DHCEQMMaintPart:MaintPart",
						  "0054":"web.DHCEQCManufacturer:LookUp",
						  "0055":"web.DHCEQCVendor:GetVendor",
						  "0056":"web.DHCEQFind:GetAccessoryType",
						  "0057":"web.DHCEQM.DHCEQMaintForService:GetAStockDetail",
						  "0058":"web.DHCEQM.DHCEQMMaintPart:GetOneMaintPart",
						  "0059":"web.DHCEQMessages:GetManagementInfo",
						  "0060":"web.DHCEQM.DHCEQMMaintPart:GetOneMaintPart",
						  "0061":"web.DHCEQEquipRent:GetEquipRentByEquipForWechat",
						  "0062":"web.DHCEQEquipRent:GetEquipRentByItemForWechat",
						  "0063":"web.DHCEQCommon:GetFirstIDByLocType",
						  "0064":"web.DHCEQRent:SaveData",
						  "0065":"web.DHCEQRent:GetRentByID",
						  "0066":"web.DHCEQEquip:GetEquipByID",
						  "0067":"web.DHCEQRent:GetRentList",
						  "0068":"web.DHCEQEquipRent:GetEquipUsedInfo",
						  "0069":"web.DHCEQCSysGroupMenu:GetGroupMenus",
						  "0070":"web.DHCEQMessages:GetApproveInfo",
						  "0071":"web.DHCEQM.DHCEQMExObj:ShortExObj",
						  :"未定义"
						  )
	}
	else
	{
		s MethodDesc=$CASE(MethodCode,
			              "0001":"获取单台设备信息",
			              "0002":"获取维修基础数据",
			              "0003":"保存维修单",
			              "0004":"自动保存维修对象",
						  "0005":"待操作维修单据查询",
						  "0006":"提交维修单",
						  "0007":"维修受理,完成操作",
						  "0008":"获取维修图片",
						  "0010":"获取一个维修单据",
						  "0011":"获取维修评价项目",
						  "0012":"获取评价列表",
						  "0013":"根据用户获取科室",
						  "0014":"保存维修评价信息",
						  "0015":"远程获取FTP信息",
						  "0018":"获取单个设备维修单",
						  "0019":"保存维修进度报告",
						  "0020":"获取维修进度报告信息",
						  "0021":"获取一个评价信息",
						  "0022":"保存维修图片信息",
						  "0024":"获取安全组可访问菜单代码",
						  "0025":"维修待办列表",
						  "0026":"紧急程度",
						  "0027":"人员列表",
						  "0028":"故障类型",
						  "0029":"故障原因",
						  "0030":"解决方法",
						  "0031":"维修方式",
						  "0032":"待办业务列表",
						  "0033":"故障现象",
						  "0034":"获取可编辑字段",
						  "0035":"获取审批流类型",
						  "0036":"获取可转向步骤",
						  "0037":"获取审批流信息",
						  "0038":"严重程度",
						  "0039":"维修个人列表",
						  "0040":"服务商",
						  "0041":"维修结果",
						  "0042":"验证登陆信息是否正确",
						  "0043":"获取安全组登陆科室",
						  "0044":"验证安全组是否正确",
						  "0045":"绑定id",
						  "0046":"检验用户微信是否绑定",
						  "0047":"消息获取",
						  "0048":"FTP服务器下载",
						  "0049":"维修人员信息",
						  "0050":"维修配件增删改",
						  "0051":"配件明细提交审核",
						  "0052":"配件明细取消提交审核",
						  "0053":"维修单配件列表信息",
						  "0054":"生产厂商",
						  "0055":"供应商",
						  "0056":"配件类组",
						  "0057":"配件项列表信息",
						  "0058":"更新图片上传标志",
						  "0059":"报表统计",
						  "0060":"单条配件信息",
						  "0061":"租赁设备信息",
						  "0062":"租赁设备项",
						  "0063":"获取租赁中心科室ID",
						  "0064":"租赁调用SavaData方法",
						  "0065":"根据ID获取租赁明细",
						  "0066":"获取台账表设备信息",
						  "0067":"租赁单据列表",
						  "0068":"过滤已租赁未归还设备",
						  "0069":"获取主界面菜单信息",
						  "0070":"获取审批进度信息",
						  "0071":"获取维修对象列表",
						  "0072":"获取业务单据预警统计",
						  "0073":"获取业务单据预警明细",
						  "0074":"获取维修进程基础数据",
						  "0075":"检测设备是否处于维修",
						  "0076":"获取通知信息",
						  :"未定义"
						  )
	}
	q MethodDesc
}

/// Add By QW20200108 BUG:QW0035
/// 描述:微信query通过类名+qury名+参数json字符串来统一执行方法。
/// 入参:ClassName-类名;QueryName-Query名;Queryparas-参数json字符串:"{""0"":""a"",""1"":""b""}" 按照参数顺序
/// 访问表：  不定
/// 出参：    rtn-query输出json对象
/// w ##Class(web.DHCEQWChatUser).GetQueryResult("web.DHCEQOpenCheckRequest","GetOpenCheckRequest","{""3"":""2021-06-10"",""5"":""0""}")
ClassMethod GetQueryResult(ClassName As %String = "", QueryName As %String = "", Queryparas As %String = "")
{
	s rtn=""
	s TMPString=""
	Set result=##class(%XML.DataSet).%New(ClassName_":"_QueryName)
	s cmd="Do result.SetArgs("
	if Queryparas'=""
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Queryparas)
		s queryParams = $g(^oddCOM(ClassName, "q", QueryName, 34))	//czf 2021-06-10 begin
		s paramNums = $ll(queryParams)
		f i=1:1:paramNums
		{
			s PerParams=$lg(queryParams,i)
			s ParamName=$lg(PerParams,1)
			s val=JsonData.%Get(i-1)
			i val="" s val=JsonData.%Get(ParamName)		//先按照参数顺序取值,若值为空，按照参数名称取
			i ($IsObject(val)){		//将JSON对象转换为JSON字符串 czf 20210628
				s DataType=val.%ClassName()
				i ((DataType="JsonObject")||(DataType="%DynamicObject")||(DataType="%DynamicArray")) s val=val.%ToJSON()
				e  i (DataType="%ArrayOfDataTypes") s val=##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr(val)
			}
			i TMPString'="" s TMPString=TMPString_","
		    s val=""""_val_""""
		    s TMPString=TMPString_val
		}		   			//czf 2021-06-10 end
	}
	s cmd=cmd_TMPString_")  QUIT result"
	SET rtn=$XECUTE(cmd)
    Quit rtn
}

/// Add By QW20200108 BUG:QW0035
/// 描述:微信方法通过传递类名,方法名及参数json字符串来统一执行
/// 入参:ClassName-类名;methodname-方法名;methodparas-参数json字符串:"{""0"":""a"",""1"":""b""}" 按照参数顺序
/// 访问表：  不定
/// 出参：    rtn-方法返回值
/// w ##class(web.DHCEQWChatUser).GetMethodResult("web.DHCEQ.EM.LIBMultipleApproveInfo","SaveData","{""0"":""{MABusID:1492"",""1"":""ApproveType:5"",""2"":""Action:Disuse_Audit"",""3"":""MASourceID_UserName:姜春梅"",""4"":""MASourceID:53"",""5"":""MARowID:"",""6"":""Session_UserID:77"",""7"":""Session_GroupID:85"",""8"":""Session_LocID:202"",""9"":""Session_User:77"",""10"":""Session_Group:设备资产(管理员)"",""11"":""Session_Loc:医疗设备科"",""12"":""Session_Password:1"",""13"":""Session_HospitalID:2"",""14"":""Session_UserTel:18696166761"",""15"":""Session_appId:wx095cb776a15d8fb0"",""16"":""Session_timestamp:1631088105"",""17"":""Session_nonceStr:CEBvazjbjAti0Olw"",""18"":""Session_signature:840d1811bfd4181c2f8bbf28357e78b1c62d7fba"",""19"":""Session_domainName:http://sbgly.jiankangle.com:60981/"",""20"":""Session_project:DHCEQWechat"",""21"":""Session_ChatUserID:005"",""22"":""Session_isCP:null"",""23"":""Session_AccessType:1}"",""24"":""0""}")
ClassMethod GetMethodResult(classname As %String = "", methodname As %String = "", methodparas As %String = "")
{
	s rtn=""
	s TMPString=""
	s cmd="s val=##Class("_classname_")."_methodname_"("
	if methodparas'=""
	{
		s JsonData = ##class(web.DHCEQWChatUser).StringToJsonString(methodparas)
		s MethodParams = $g(^oddCOM(classname, "m", methodname, 60))	//czf 2021-08-26 begin
		s MethodNums = $ll(MethodParams)
		f i=1:1:MethodNums
		{
			s PerParams=$lg(MethodParams,i)
			s ParamName=$lg(PerParams,1)
			s val=JsonData.%Get(i-1)
			i val="" s val=JsonData.%Get(ParamName)		//先按照参数顺序取值,若值为空，按照参数名称取
			i ($IsObject(val)){		//将JSON对象转换为JSON字符串 czf 20210628
				//s DataType=val.%ClassName()
				//i ((DataType="JsonObject")||(DataType="%DynamicObject")||(DataType="%DynamicArray")) s val=val.%ToJSON()
				//e  i (DataType="%ArrayOfDataTypes") s val=##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr(val)
				s newval="""{"
				s key=""
				For
				{
					s value=val.GetNext(.key)
					q:key=""
					s perElement=""""""_key_""""""_":"_""""""_value_""""""
					i newval="""{" s newval=newval_perElement
					e  s newval=newval_","_perElement
				}
				s val=newval_"}"""
			}
			else
			{
				s val=""""_val_""""		
			}
			i TMPString'="" s TMPString=TMPString_","
		    s TMPString=TMPString_val
		}		   			//czf 2021-08-26 end
	}
	s cmd=cmd_TMPString_")  QUIT val"
	SET rtn=$XECUTE(cmd)
	Quit rtn
}

/// Add By QW20200108 BUG:QW0035
/// 描述:微信传过来的json字符串转换为json对象,主要针对多层json
/// 入参:methodparas-参数json字符串:"{""0"":""a"",""1"":""b""}"
/// 访问表：  不定
/// 出参：    jobj-json对象
/// w ##class(web.DHCEQWChatUser).SplitJsonString(methodparas)
ClassMethod StringToJsonString(methodparas)
{
	s methodparas=##Class(web.DHCEQ.Plat.LIBCommon).Replace(methodparas,"""{","{")
	s methodparas=##Class(web.DHCEQ.Plat.LIBCommon).Replace(methodparas,"}""","}")
  	s jobj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
  	s jobj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(methodparas)
  	q jobj
}

/// Add By ZX 2020-08-14
/// 描述:移动端设备信息获取
/// 入参: Equip:设备编号或设备id  Type:0,设备编号 1,设备id 2,档案编号 BussType:业务类型,如为64时查看可租借设备\31时可查看简易设备
/// 输出：台账信息
/// w ##class(web.DHCEQWChatUser).OneEquipInfo("3229900000001","0","52","0","202","85")
ClassMethod OneEquipInfo(Equip, Type, BussType, QXType As %String = "", LocID As %String = "", GroupID As %String = "")
{
	//设备入参信息为空
	i Equip="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1500")  //Modify by zx 2020-08-31 未定义信息bug
	i Type="" s Type="0"
	i BussType="" s BussType="52"
	
	i Type="0" d
	.s rowid = $Order(^DHCEQEquip(0,"No",Equip,""))
	.s EquipNo = Equip
	.s Equip = rowid
	.i Equip="" d
	..&SQL(select EQ_RowID into :Equip from SQLUSER.DHC_EQEquip where EQ_OldNo=:EquipNo)
	else  if Type="2" d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(rowid)) q:rowid=""  d
	..s FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)
	..q:FileNo'=Equip
	...s Equip = rowid
	//设备信息不存在
	i Equip="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1501") //Modify by zx 2020-08-31 未定义信息bug
	
	
	//Modify by zx 2020-09-17 增加类组权限处理
	s DeEquipFlag="0"  //只看在账
	i BussType="31" s DeEquipFlag="2"  //包含简易类组
	s EquipType=$p($g(^DHCEQEquip(Equip)),"^",63)
	i "1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,GroupID,"",DeEquipFlag) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1503")
	
	//Modify by zx 2020-09-17 增加科室权限处理
	s StoreLocDR=$p($g(^DHCEQEquip(Equip)),"^",67)
	s ClassFlag=$p($g(^DHCEQEquip(Equip)),"^",83)  //add by wy 2021-9-22 泛类标记
	i (1=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR,LocID,GroupID)&&(ClassFlag'="Y")) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1502")
	
	//Modify by zx 2020-09-17 维修,报废检索时过滤预报废
	i ((BussType="31")||(BussType="34"))&&($p($g(^DHCEQEquip(Equip)),"^",93)="2") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1504")
	
	s EquipInfo=##Class(web.DHCEQ.EM.BUSEquip).GetOneEquip(Equip)
	s EquipInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(EquipInfo)
	d EquipInfo.%Set("EQRowID",Equip)
	
	//Modify by zx 2020-09-17 BUG ZX0111
	s CurBussCode=##class(web.DHCEQWChatUser).GetBussCodeByGroup(GroupID)
	d EquipInfo.%Set("BussCodes",CurBussCode)
	
	q EquipInfo.%ToJSON()
}

/// Add By ZX 2020-09-17
/// 描述:移动端获取可访问业务代码
/// 入参: 安全组
/// 输出: 业务代码串,逗号分隔  "11,21,22"
/// w ##class(web.DHCEQWChatUser).GetBussCodeByGroup("85")
ClassMethod GetBussCodeByGroup(GroupID)
{
	i GroupID="" q ""
	s RoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
	s BussCodes=""
	s BRowID=0
	f  s BRowID=$o(^DHCEQCCode("DHCEQCBussType",BRowID))  quit:BRowID=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",4)="Y")
	.s BussCode=$p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",1)
	.s RRowID=0
	.f  s RRowID=$o(^DHCEQCCode("DHCEQCRoleBuss",0,"BussType",BRowID,RRowID))  quit:RRowID=""  d
	..q:(RoleIDs'="")&&((","_RoleIDs_",")'[(","_$p($g(^DHCEQCCode("DHCEQCRoleBuss",RRowID)),"^",1)_",")) //Modify by zx 2020-12-31 BUG ZX0126
	..i (","_BussCodes_",")'[(","_BussCode_",") d
	...i BussCodes'="" s BussCodes=BussCodes_","
	...s BussCodes=BussCodes_BussCode
	
	q BussCodes
}

/// add by zc0107 2021-11-14
/// 微信绑定用户查询 
/// do ##Class(%ResultSet).RunQuery("web.DHCEQWChatUser","GetWChatUser","")
Query GetWChatUser(User) As %Query(ROWSPEC = "TRowID,TChatID,TUserDR,TUser,TGroupDR,TGroup,TLocDR,TLoc,TWcDate,TPassWord")
{
}

ClassMethod GetWChatUserExecute(ByRef qHandle As %Binary, User) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set index=1
    s rowid=0

    f  s rowid=$O(^DHCEQWChatUser(rowid)) q:rowid=""  d
    .d ResetVariableGetWChatUser
    .s TUserDR = $p($g(^DHCEQWChatUser(rowid)),"^",2)
    .q:(User'="")&&(User'=TUserDR)
    .s TUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
    .s TGroupDR=$p($g(^DHCEQWChatUser(rowid)),"^",3)  ;安全组
    .i TGroupDR '="" s TGroup = ##class(web.DHCEQCommon).GetTrakNameByID("grp",TGroupDR)
    .s TLocDR=$p($g(^DHCEQWChatUser(rowid)),"^",4)  ;科室
    .i TLocDR '="" s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
    .s TChatID=$p($g(^DHCEQWChatUser(rowid)),"^",1)
    .s TWcDate=$p($g(^DHCEQWChatUser(rowid)),"^",5)  ;日志日期
    .s TWcDate=$zd(TWcDate,3)
    .s TPassWord=$p($g(^DHCEQWChatUser(rowid)),"^",8)
    .s TRowID=rowid
    .d OutputRowGetWChatUser
    
    Quit $$$OK
    
ResetVariableGetWChatUser
    s (TRowID,TChatID,TUserDR,TUser,TGroupDR,TGroup,TLocDR,TLoc,TWcDate,TPassWord)=""
    quit
    
OutputRowGetWChatUser
    s Data=$lb(TRowID,TChatID,TUserDR,TUser,TGroupDR,TGroup,TLocDR,TLoc,TWcDate,TPassWord)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetWChatUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWChatUserExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetWChatUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWChatUserExecute ]
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

/// add by zc0107 2021-11-14
ClassMethod DeleteBind(RowID)
{
    s SQLCODE=0
    i (RowID'="") 
    {
        &SQL(delete from  sqluser.DHC_EQWChatUser where WCU_RowID = :RowID)
    }
    Q SQLCODE
}

}
