/// Modified By HZY 2012-03-08 HZY0024
/// Desc:修改函数CreateBussInfo: 新增'研究课题'的业务消息处理.
/// --------------------------------
/// Modified By HZY 2011-08-30 HZY0009
/// Description：修改函数GetMessagesExecute 以更正按时间查询时的错误.
/// -------------------------------
/// modified by zy 2011-03-03 ZY0064
/// 描述：是否处理标识
/// -------------------------------
/// 修改：JDL 2011-3-2
/// 增加对业务消息的处理
/// 增加方法CreateBussInfo
/// 修改方法SaveData
/// -------------------------------
/// 创建:zy 2010-12-29
/// 描述:消息发布
/// --------------------------------
Class web.DHCEQMessages Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:zy 2010-012-28
/// 描述:消息结果查询
/// 访问表:DHC_EQMessagesResult
/// ----------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetMessages","1")
Query GetMessages(vData As %String = "", BussTypeDR As %String = "", SendTypeDR As %String = "", MessageTypeDR As %String = "", SendBeginDate As %String = "", SendEndDate As %String = "", ReadBeginDate As %String = "", ReadEndDate As %String = "", EmergencyLevelDR As %String = "", ReadFlagDR As %String = "", CurUserID, CurLocID, CurGroupID, DealFlagDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TTitle:%String,TEquipType:%String,TManageLoc:%String,TMessageType:%String,TSendAll:%String,TSendEmailFlag:%String,TMobileMessageFlag:%String,TSendType:%String,TSendUser:%String,TSendDate:%String,TFromUser:%String,TFromLoc:%String,TFromRole:%String,TToUser:%String,TToLoc:%String,TToRole:%String,TInfo:%String,TReadUser:%String,TReadDate:%String,TDealUser:%String,TDealDate:%String,TBussType:%String,TStatus:%String,TRemark:%String,TSourceMessageDR:%String,TEmergencyLevel:%String,TInBoxInvalidFlag:%String,TInBoxDelUser:%String,TInBoxDelDate:%String,TOutBoxInvalidFlag:%String,TOutBoxDelUser:%String,TOutBoxDelDate:%String,TContactInfo:%String,TDealFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,BussID:%String,BussInfoDR:%String,BussInfo:%String")
{
}

/// Modified By HZY 2011-08-30 HZY0009
ClassMethod GetMessagesExecute(ByRef qHandle As %Binary, vData As %String = "", BussTypeDR As %String = "", SendTypeDR As %String = "", MessageTypeDR As %String = "", SendBeginDate As %String = "", SendEndDate As %String = "", ReadBeginDate As %String = "", ReadEndDate As %String = "", EmergencyLevelDR As %String = "", ReadFlagDR As %String = "", CurUserID, CurLocID, CurGroupID, DealFlagDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	if vData="" Quit $$$OK
	Set Type=##Class(web.DHCEQCommon).GetDataByName(vData,"Type")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")	
	i CurUserID="" Set CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurLocID="" Set CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i CurGroupID="" Set CurGroupID=%session.Get("LOGON.GROUPID")
	
	//Set CurUserID=718
	//Set CurLocID=153
	//Set CurGroupID=81
	// Modified By HZY 2011-08-30 HZY0009  注释下面两行。
	//if SendBeginDate'="" Set SendBeginDate=$ZDH(SendBeginDate,4)	
	//if SendEndDate'=""  Set SendEndDate=$ZDH(SendEndDate,4)
	
 	if SendBeginDate="" Set SendBeginDate=0
 	if SendEndDate="" Set SendEndDate=+$H
	;if ReadBeginDate'="" Set ReadBeginDate=$ZDH(ReadBeginDate,4)
	;if ReadEndDate'="" Set ReadEndDate=$ZDH(ReadEndDate,4)
	;日期格式统一调整
	Set ReadBeginDate=##Class(web.DHCEQCommon).TransValueFromPage(ReadBeginDate,"date")
	Set ReadEndDate=##Class(web.DHCEQCommon).TransValueFromPage(ReadEndDate,"date")
 	if ReadBeginDate="" Set ReadBeginDate=0
 	if ReadEndDate="" Set ReadEndDate=+$H
	Set index=1
	Set rowid=0
	if Status'=""
	{
		for  s rowid=$o(^DHCEQMessages(0,"Status",Status,rowid)) q:rowid=""  d
		.d ResetVariablesMessages
		.d CheckGetMessages
		.q:passed=0
		.d SetVariablesGetMessages
		.d OutputRowMessages
	}
	else
	{
		for  s rowid=$o(^DHCEQMessages(rowid)) q:rowid=""  d
		.d ResetVariablesMessages
		.d CheckGetMessages
		.q:passed=0
		.d SetVariablesGetMessages
		.d OutputRowMessages
	}
	Quit $$$OK
CheckGetMessages
	s passed=1
	s TMessageType=$p($g(^DHCEQMessages(rowid)),"^",4)
	i (MessageTypeDR'="")&&(MessageTypeDR'=TMessageType)
	{
		s passed=0
	 	q
	}
	
	//N:只发送一份，有人阅读即为阅读 Y：发送相关所有人，每人一份
	s TSendAll=$p($g(^DHCEQMessages(rowid)),"^",5)
	//0：发送到指定人 1:发送到指定科室 2：发送到指定角色  3：发送到指定科室的指定角色  9:其他
	s TSendType=$p($g(^DHCEQMessages(rowid)),"^",8)
	i (SendTypeDR'="")&&(SendTypeDR'=TSendType)
	{
		s passed=0
	 	q
	}
	
	s TSendDate=$p($g(^DHCEQMessages(rowid)),"^",10)
	i (TSendDate>SendEndDate)||(TSendDate<SendBeginDate)
	{
		s passed=0
	 	q
	}
	
	s TSendUserDR=$p($g(^DHCEQMessages(rowid)),"^",9)    //发送人
	s TToUserDR=$p($g(^DHCEQMessages(rowid)),"^",15)
	s TToLocDR=$p($g(^DHCEQMessages(rowid)),"^",16)
	s TToRoleDR=$p($g(^DHCEQMessages(rowid)),"^",17)
	s TReadUserDR=$p($g(^DHCEQMessages(rowid)),"^",19)
	s TDealFlagDR=$p($g(^DHCEQMessages(rowid)),"^",39)	//modified by zy 2011-03-03 ZY0064
	//0：新增 1:发送 2:已读 3：已处理
	s TStatus=$p($g(^DHCEQMessages(rowid)),"^",26)
	//未读ReadFlag="0",已读	ReadFlagDR="1"
	i ((ReadFlagDR="0")&&(TReadUserDR'="")||((ReadFlagDR="1")&&(TReadUserDR="")))
	{
		s passed=0
	 	q
	}
	//modified by zy 2011-03-03 ZY0064
	//0,不区分是否处理;1,未处理;2,已处理
	i (DealFlagDR'="")&&(DealFlagDR'=TDealFlagDR)
	{
		s passed=0
	 	q
	}
    
	i (Type="1")	//type=1 发信;type=2 收信
	{
		;过滤发件人已删除的信息
		s TOutBoxInvalidFlag=$p($g(^DHCEQMessages(rowid)),"^",34)
		i (TOutBoxInvalidFlag="Y")
		{
			s passed=0
		 	q
		}	
		i (Status="")&&(+TStatus=0)			//已发时Status="";待发时Status=0
		{
			s passed=0
	 		q
		}		
		i (TSendUserDR'="")&&(CurUserID'=TSendUserDR)
		{
			s passed=0
	 		q
		}
		
		/*
		i (TSendType=1)&&(TToLocDR="")
		{
			s passed=0
	 		q
		}
		i (TSendType=2)&&(TToUserDR'="")
		{
			s passed=0
	 		q
		}		
		i (TSendType=3)&&((TToRoleDR="")||(TToLocDR=""))
		{
			s passed=0
	 		q
		}
		*/
	}
	elseif Type="2"	//type=1 发信;type=2 收信
	{
		s TInBoxInvalidFlag=$p($g(^DHCEQMessages(rowid)),"^",30)
		i (TInBoxInvalidFlag="Y")
		{
			s passed=0
	 		q
		}
		i +TStatus<1
		{
			s passed=0
	 		q
		}

		i (TToUserDR'="")
		{
			if (CurUserID'=TToUserDR) //接受人不空且不是自己的
			{
				s passed=0
		 		q
			}
		}
		else
		{
			;发送相关所有人 的 原始消息，不需要收件人看到
			i (TSendAll="Y")  //N:只发送一份，有人阅读即为阅读 Y：发送相关所有人，每人一份
			{
				s passed=0
	 			q
			}
			;
			i (TToRoleDR'="") //接受人空且接受角色不是自己的
			{
				s BussTypeID=$p($g(^DHCEQMessages(rowid)),"^",25)
				s passed=##Class(web.DHCEQCUserRole).CheckUserRole(TToRoleDR,BussTypeID,CurUserID,CurGroupID)
				i passed=0 q
			}	
		}
		
		;收信时，如果非直接发送人,则需判断科室及类组是否管理权限内
		i (TToUserDR="")&&(TToLocDR'="")  d
		.s QXType=$p($g(^DHCEQMessages(rowid)),"^",40)
		.s Find=##Class(web.DHCEQCommon).LocIsInEQ(QXType,TToLocDR)
		.i Find'=0 s passed=0
		i passed=0 q		
		s TEquipTypeDR=$p($g(^DHCEQMessages(rowid)),"^",2)
		i (TToUserDR="")&&(TEquipTypeDR'="")
		.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		.i +result'=0 s passed=0
		i passed=0 q
	}
	s TReadDate=$p($g(^DHCEQMessages(rowid)),"^",20)
	i (TSendDate>ReadEndDate)||(TSendDate<ReadBeginDate)
	{
		s passed=0
	 	q
	}
	s TBussType=$p($g(^DHCEQMessages(rowid)),"^",25)
	i (BussTypeDR'="")&&(BussTypeDR'=TBussType)
	{
		s passed=0
	 	q
	}
	s TEmergencyLevelDR=$p($g(^DHCEQMessages(rowid)),"^",29)
	i (EmergencyLevelDR'="")&&(EmergencyLevelDR'=TEmergencyLevelDR)
	{
		s passed=0
	 	q
	}
	
	quit
SetVariablesGetMessages
	s TRowID=rowid
	s TTitle=$p($g(^DHCEQMessages(rowid)),"^",1)
	s TEquipTypeDR=$p($g(^DHCEQMessages(rowid)),"^",2)
	i TEquipTypeDR'="" s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	s TManageLocDR=$p($g(^DHCEQMessages(rowid)),"^",3)
	i TManageLocDR'="" s TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TEquipTypeDR)
	s TMessageType=$p($g(^DHCEQMessages(rowid)),"^",4)
	i TMessageType'="" s TMessageType=$CASE(TMessageType,"0":"普通消息","1":"业务消息","2":"系统消息",:"没有定义")
	s TSendAll=$p($g(^DHCEQMessages(rowid)),"^",5)
	;i TSendAll'="" s TSendAll=$CASE(TSendAll,"0":"只发送一份，有人阅读即为阅读","1":"发送相关所有人，每人一份")
	s TSendEmailFlag=$p($g(^DHCEQMessages(rowid)),"^",6)
	s TMobileMessageFlag=$p($g(^DHCEQMessages(rowid)),"^",7)
	s TSendType=$p($g(^DHCEQMessages(rowid)),"^",8)
	i TSendType'="" s TSendType=$CASE(TSendType,"0":"发送到指定人","1":"发送到指定科室","2":"发送到指定角色","3":"指定科室的指定角色","9":"其他")
	s TSendUserDR=$p($g(^DHCEQMessages(rowid)),"^",9)
	i TSendUserDR'="" s TSendUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TSendUserDR)
	s TSendDate=$p($g(^DHCEQMessages(rowid)),"^",10)
	s TSendTime=$p($g(^DHCEQMessages(rowid)),"^",11)
	;s TSendDate=$ZDT(TSendDate_","_TSendTime)
	;日期格式统一调整
	s TSendDate=##Class(web.DHCEQCommon).TransValueToPage(TSendDate_","_TSendTime,"datetime")
	s TFromUserDR=$p($g(^DHCEQMessages(rowid)),"^",12)
	i TFromUserDR'="" s TFromUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TFromUserDR)
	s TFromLocDR=$p($g(^DHCEQMessages(rowid)),"^",13)
	i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	s TFromRoleDR=$p($g(^DHCEQMessages(rowid)),"^",14)
	i TFromRoleDR'="" s TFromRole=##class(web.DHCEQCommon).GetTrakNameByID("role",TFromRoleDR)
	s TToUserDR=$p($g(^DHCEQMessages(rowid)),"^",15)
	i TToUserDR'="" s TToUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TToUserDR)
	s TToLocDR=$p($g(^DHCEQMessages(rowid)),"^",16)
	i TToLocDR'="" s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
	s TToRoleDR=$p($g(^DHCEQMessages(rowid)),"^",17)
	i TToRoleDR'="" s TToRole=##class(web.DHCEQCommon).GetTrakNameByID("role",TToRoleDR)
	s TInfo=$p($g(^DHCEQMessages(rowid)),"^",18)
	s TReadUserDR=$p($g(^DHCEQMessages(rowid)),"^",19)
	i TReadUserDR'="" s TReadUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TReadUserDR)
	s TReadDate=$p($g(^DHCEQMessages(rowid)),"^",20)
	s TReadTime=$p($g(^DHCEQMessages(rowid)),"^",21)
	;i (TReadDate'="")&&(TReadTime'="") s TReadDate=$ZDT(TReadDate_","_TReadTime)
	;日期格式统一调整
	s TReadDate=##Class(web.DHCEQCommon).TransValueToPage(TReadDate_","_TReadTime,"datetime")
	s TDealUserDR=$p($g(^DHCEQMessages(rowid)),"^",22)
	i TDealUserDR'="" s TDealUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TDealUserDR)
	s TDealDate=$p($g(^DHCEQMessages(rowid)),"^",23)
	s TDealTime=$p($g(^DHCEQMessages(rowid)),"^",24)
	;i (TDealDate'="")&&(TDealTime'="") s TDealDate=$ZDT(TDealDate_","_TDealTime)
	;日期格式统一调整
	s TDealDate=##Class(web.DHCEQCommon).TransValueToPage(TDealDate_","_TDealTime,"datetime")
	s TBussType=$p($g(^DHCEQMessages(rowid)),"^",25)
	i TBussType'="" s TBussType=##class(web.DHCEQFind).GetBussTypeDesc(TBussType)
	s TStatus=$p($g(^DHCEQMessages(rowid)),"^",26)
	i TStatus'=""  s TStatus=$CASE(TStatus,"0":"新增","1":"发送","2":"已读","3":"已回复")
	s TRemark=$p($g(^DHCEQMessages(rowid)),"^",27)
	s TSourceMessageDR=$p($g(^DHCEQMessages(rowid)),"^",28)
	s TEmergencyLevelDR=$p($g(^DHCEQMessages(rowid)),"^",29)
	i TEmergencyLevelDR'="" s TEmergencyLevel=$p($g(^DHCEQCCode("DHCEQCEmergencyLevel",TEmergencyLevelDR)),"^",2)
	s TInBoxInvalidFlag=$p($g(^DHCEQMessages(rowid)),"^",30)
	s TInBoxDelUserDR=$p($g(^DHCEQMessages(rowid)),"^",31)
	i TInBoxDelUserDR'="" s TInBoxDelUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TInBoxDelUserDR)
	s TInBoxDelDate=$p($g(^DHCEQMessages(rowid)),"^",32)
	s TInBoxDelTime=$p($g(^DHCEQMessages(rowid)),"^",33)
	;i (TInBoxDelDate'="")&&(TInBoxDelTime'="") s TInBoxDelDate=$ZDT(TInBoxDelDate_","_TInBoxDelTime)
	;日期格式统一调整
	s TOutBoxDelDate=##Class(web.DHCEQCommon).TransValueToPage(TInBoxDelDate_","_TInBoxDelTime,"datetime")
	s TOutBoxInvalidFlag=$p($g(^DHCEQMessages(rowid)),"^",34)
	s TOutBoxDelUserDR=$p($g(^DHCEQMessages(rowid)),"^",35)
	i TOutBoxDelUserDR'="" s TOutBoxDelUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TOutBoxDelUserDR)
	s TOutBoxDelDate=$p($g(^DHCEQMessages(rowid)),"^",36)
	s TOutBoxDelTime=$p($g(^DHCEQMessages(rowid)),"^",37)
	;i (TInBoxDelDate'="")&&(TInBoxDelTime'="") s TOutBoxDelDate=$ZDT(TOutBoxDelDate_","_TOutBoxDelTime)
	;日期格式统一调整
	s TOutBoxDelDate=##Class(web.DHCEQCommon).TransValueToPage(TOutBoxDelDate_","_TOutBoxDelTime,"datetime")
	s TContactInfo=$p($g(^DHCEQMessages(rowid)),"^",38)
	s TDealFlagDR=$p($g(^DHCEQMessages(rowid)),"^",39)
	i TDealFlagDR'="" s TDealFlag=$CASE(TDealFlagDR,"0":"","1":"未处理","2":"已处理")
	s THold1=$p($g(^DHCEQMessages(rowid)),"^",40)
	s THold2=$p($g(^DHCEQMessages(rowid)),"^",41)
	s THold3=$p($g(^DHCEQMessages(rowid)),"^",42)
	s THold4=$p($g(^DHCEQMessages(rowid)),"^",43)
	s THold5=$p($g(^DHCEQMessages(rowid)),"^",44)
	
	;Modified by JDL 2011-3-2 jdl0071
	s BussID=$p($g(^DHCEQMessages(rowid)),"^",45)
	s BussInfoDR=$p($g(^DHCEQMessages(rowid)),"^",46)
	i BussInfoDR'="" s BussInfo=$p($g(^DHCEQCCode("DHCEQCMessagesResult",BussInfoDR)),"^",3)
	quit
OutputRowMessages
	set Data=$lb(TRowID,TTitle,TEquipType,TManageLoc,TMessageType,TSendAll,TSendEmailFlag,TMobileMessageFlag,TSendType,TSendUser,TSendDate,TFromUser,TFromLoc,TFromRole,TToUser,TToLoc,TToRole,TInfo,TReadUser,TReadDate,TDealUser,TDealDate,TBussType,TStatus,TRemark,TSourceMessageDR,TEmergencyLevel,TInBoxInvalidFlag,TInBoxDelUser,TInBoxDelDate,TOutBoxInvalidFlag,TOutBoxDelUser,TOutBoxDelDate,TContactInfo,TDealFlag,THold1,THold2,THold3,THold4,THold5,BussID,BussInfoDR,BussInfo)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMessages
	s (TRowID,TTitle,TEquipType,TManageLoc,TMessageType,TSendAll,TSendEmailFlag,TMobileMessageFlag,TSendType,TSendUser,TSendDate,TFromUser,TFromLoc,TFromRole,TToUser,TToLoc,TToRole,TInfo,TReadUser,TReadDate,TDealUser,TDealDate,TBussType,TStatus,TRemark,TSourceMessageDR,TEmergencyLevel,TInBoxInvalidFlag,TInBoxDelUser,TInBoxDelDate,TOutBoxInvalidFlag,TOutBoxDelUser,TOutBoxDelDate,TContactInfo,TDealFlag,THold1,THold2,THold3,THold4,THold5)=""
	s (TEquipTypeDR,TManageLocDR,TSendUserDR,TFromUserDR,TFromLocDR,TFromRoleDR,TToUserDR,TToLocDR,TToRoleDR,TReadUserDR,TDealUserDR,TStatusDR,TEmergencyLevelDR,TInBoxDelUserDR,TOutBoxDelUserDR)=""
	
	;Modified by JDL 2011-3-2 jdl0071
	s (BussID,BussInfoDR,BussInfo)=""
	
	quit
}

ClassMethod GetMessagesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessagesExecute ]
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

ClassMethod GetMessagesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessagesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// ----------------------------------
/// 创建：zy 2010-12-29
/// 描述：消息类型
/// ----------------------------------
ClassMethod GetMessageType(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	i Type="0" w "<option value=></option>"
	w "<option value=0>普通消息</option>"
	w "<option value=1>业务消息</option>"
	;w "<option value=2>系统消息</option>"
	w "</select>",!
}

/// ----------------------------------
/// 创建：zy 2010-12-29
/// 描述：发送类型
/// ----------------------------------
ClassMethod GetSendType(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	i Type="0" w "<option value=></option>"
	w "<option value=0>发送到指定人</option>"
	;w "<option value=1>发送到指定科室</option>"
	w "<option value=2>发送到指定角色</option>"
	;w "<option value=3>发送到指定科室的指定角色</option>"
	w "<option value=9>其他</option>"
	w "</select>",!
}

/// ----------------------------------
/// 创建：zy 2010-12-29
/// 描述：阅读标识
/// ----------------------------------
ClassMethod GetReadFlag(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>未读消息</option>"
	w "<option value=1>已读消息</option>"
	w "</select>",!
}

/// 修改：JDL 2011-3-2
/// 描述：增加业务消息的处理
/// 	  增加是否事务的处理
/// 增加参数：bussInfo：业务消息
/// 		  TransFlag：是否需要事务 Y需要 N不需要		
/// ----------------------------------
/// 创建：zy 2010-12-29
/// 描述:新增、更新
/// w ##Class(web.DHCEQMessages).SaveData("^标题^^^0^false^false^false^0^^^^^^^^^^消息内容^^^^^^^^^^^^^^^")
/// ----------------------------------
ClassMethod SaveData(val, bussInfo As %String = "", TransFlag As %String = "Y", User As %String = "")
{
	new RowID
	k PLIST
	i TransFlag="Y" Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$P($H,",",2)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//s curLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	//s vgroupid=%session.Get("LOGON.GROUPID")
	s RowID = $p(val,"^",1)			;RowID
	s PLIST(2) = $p(val,"^",2)		;Title
	s PLIST(3) = $p(val,"^",3)		;MessageType
	s PLIST(4) = $p(val,"^",4)		;SendType
	s PLIST(5) = $p(val,"^",5)		;SendMode
	i $p(val,"^",6)'="" s PLIST(6) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"bool")	;SendEmailFlag
	i $p(val,"^",7)'="" s PLIST(7) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"bool")	;MobileMessageFlag
	
	s PLIST(8) = $p(val,"^",8) 	;EmergencyLevelDR
	s PLIST(9) = $p(val,"^",9)		;Content
	s PLIST(10) = $p(val,"^",10) 	;Remark
	s PLIST(11) = $p(val,"^",11) 	;BussType
	s PLIST(12) = $p(val,"^",12) 	;BussID
	s PLIST(13) = $p(val,"^",13)	;FromRoleDR
	s PLIST(14) = $p(val,"^",14) 	;SourceMessageDR
	s PLIST(15) = $p(val,"^",15)	;Status
	s PLIST(16) = User				;SendUserDR
	s PLIST(17) = Date				;SendDate
	s PLIST(18) = Time				;SendTime
	
	s PLIST(19) = ""				;RevokeUserDR
	s PLIST(20) = ""				;RevokeDate
	s PLIST(21) = ""				;RevokeTime
	i $p(val,"^",22)'="" s PLIST(22) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"bool") ;DealFlag
	s PLIST(23) = ""				;DealUserDR
	s PLIST(24) = ""				;DealDate
	s PLIST(25) = ""				;DealTime
	
	s PLIST(26) = $p(val,"^",26) 	;ContactInfo
	s PLIST(27) = $p(val,"^",27) 	;Hold1
	s PLIST(28) = $p(val,"^",28) 	;Hold2
	s PLIST(29) = $p(val,"^",29) 	;Hold3
	s PLIST(30) = $p(val,"^",30) 	;Hold4
	s PLIST(31) = $p(val,"^",31) 	;Hold5
	
	i TransFlag="Y" TSTART
	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQMessages values :PLIST())
	}
	else
	{
		&SQL(update sqluser.DHC_EQMessages values :PLIST() where M_RowID=:RowID)

	}
	i SQLCODE
	{
		i TransFlag="Y" TROLLBACK
		q SQLCODE
	}
	s RowID=$G(%ROWID)	
 	i TransFlag="Y" TCOMMIT
 	q RowID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/*
/// ----------------------------------
/// 创建：zy 2010-12-29
/// 描述:删除
/// w ##Class(web.DHCEQMessages).SaveData("")
/// ----------------------------------
ClassMethod DeleteData(rowid)
{
	new User,SendUserDR,status,Date,Time
	Set $ZT="ERRORDelete"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s SendUserDR=$p($g(^DHCEQMessages(rowid)),"^",9)    //发送人
	s status=$p($g(^DHCEQMessages(rowid)),"^",26)
	TSTART
	if status=0
	{
		&SQL(delete from  sqluser.DHC_EQMessages where M_RowID=:rowid)
	}
	else
	{
		if User=SendUserDR
		{
			&SQL(update sqluser.DHC_EQMessages Set M_OutBoxInvalidFlag='Y',M_OutBoxDelUserDR=:User ,M_OutBoxDelDate=:Date ,M_OutBoxDelTime=:Time where M_RowID=:rowid)
		}
		else
		{
			&SQL(update sqluser.DHC_EQMessages Set M_InBoxInvalidFlag='Y',M_InBoxDelUserDR=:User ,M_InBoxDelDate=:Date ,M_InBoxDelTime=:Time where M_RowID=:rowid)
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q SQLCODE
ERRORDelete 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}
*/
/// ----------------------------------
/// 创建：zy 2010-12-29
/// 描述:发送
/// w ##Class(web.DHCEQMessages).SendData(3)
/// ----------------------------------
ClassMethod SendData(rowid)
{
	new SendAll,SendType,ToRoleDR,ID,SourceType,SourceID,UserID
	k PLIST
	s Job=$j
	K ^TempDHCEQ("DHCEQMessages","SendData","ToUserID",Job)
	Set $ZT="ERRORSend"	
	s ToUserDR=$p($g(^DHCEQMessages(rowid)),"^",15)	//ToUserDR
	s ToLocDR=$p($g(^DHCEQMessages(rowid)),"^",16)	//ToLocDR
	s ToRoleDR=$p($g(^DHCEQMessages(rowid)),"^",17)	//ToRoleDR
	i (ToUserDR="")&&(ToLocDR="")&&(ToRoleDR="") q -1001
	TSTART
	&SQL(update sqluser.DHC_EQMessages Set M_Status='1' where M_RowID=:rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s SendAll=$p($g(^DHCEQMessages(rowid)),"^",5)	//N:只发送一份，有人阅读即为阅读  Y：发送相关所有人，每人一份
	s SendType=$p($g(^DHCEQMessages(rowid)),"^",8)	//0：发送到指定人 1:发送到指定科室 2：发送到指定角色  3：发送到指定科室的指定角色  9:其他
	s SendUserDR=$p($g(^DHCEQMessages(rowid)),"^",9)	//SendUserDR
	s SourceIDMessageDR=$p($g(^DHCEQMessages(rowid)),"^",28)	//源消息ID
	i (SendType=2)&&(SendAll="Y")
	{
		s PLIST(2)=$p($g(^DHCEQMessages(rowid)),"^",1)
		s PLIST(3)=$p($g(^DHCEQMessages(rowid)),"^",2)
		s PLIST(4)=$p($g(^DHCEQMessages(rowid)),"^",3)
		s PLIST(5)=$p($g(^DHCEQMessages(rowid)),"^",4)
		s PLIST(6)=$p($g(^DHCEQMessages(rowid)),"^",5)
		s PLIST(7)=$p($g(^DHCEQMessages(rowid)),"^",6)
		s PLIST(8)=$p($g(^DHCEQMessages(rowid)),"^",7)
		s PLIST(9)=$p($g(^DHCEQMessages(rowid)),"^",8)
		s PLIST(10)=$p($g(^DHCEQMessages(rowid)),"^",9)
		s PLIST(11)=$p($g(^DHCEQMessages(rowid)),"^",10)
		s PLIST(12)=$p($g(^DHCEQMessages(rowid)),"^",11)
		s PLIST(13)=$p($g(^DHCEQMessages(rowid)),"^",12)
		s PLIST(14)=$p($g(^DHCEQMessages(rowid)),"^",13)
		s PLIST(15)=$p($g(^DHCEQMessages(rowid)),"^",14)
		;;s PLIST(16)=$p($g(^DHCEQMessages(rowid)),"^",15)
		s PLIST(17)=$p($g(^DHCEQMessages(rowid)),"^",16)
		s PLIST(18)=$p($g(^DHCEQMessages(rowid)),"^",17)
		s PLIST(19)=$p($g(^DHCEQMessages(rowid)),"^",18)
		s PLIST(20)=$p($g(^DHCEQMessages(rowid)),"^",19)
		s PLIST(21)=$p($g(^DHCEQMessages(rowid)),"^",20)
		s PLIST(22)=$p($g(^DHCEQMessages(rowid)),"^",21)
		s PLIST(23)=$p($g(^DHCEQMessages(rowid)),"^",22)
		s PLIST(24)=$p($g(^DHCEQMessages(rowid)),"^",23)
		s PLIST(25)=$p($g(^DHCEQMessages(rowid)),"^",24)
		s PLIST(26)=$p($g(^DHCEQMessages(rowid)),"^",25)
		s PLIST(27)=$p($g(^DHCEQMessages(rowid)),"^",26)
		s PLIST(28)=$p($g(^DHCEQMessages(rowid)),"^",27)
		s PLIST(29)=$p($g(^DHCEQMessages(rowid)),"^",28)
		s PLIST(30)=$p($g(^DHCEQMessages(rowid)),"^",29)
		s PLIST(31)=$p($g(^DHCEQMessages(rowid)),"^",30)
		s PLIST(32)=$p($g(^DHCEQMessages(rowid)),"^",31)
		s PLIST(33)=$p($g(^DHCEQMessages(rowid)),"^",32)
		s PLIST(34)=$p($g(^DHCEQMessages(rowid)),"^",33)
		s PLIST(35)=$p($g(^DHCEQMessages(rowid)),"^",34)
		s PLIST(36)=$p($g(^DHCEQMessages(rowid)),"^",35)
		s PLIST(37)=$p($g(^DHCEQMessages(rowid)),"^",36)
		s PLIST(38)=$p($g(^DHCEQMessages(rowid)),"^",37)
		s PLIST(39)=$p($g(^DHCEQMessages(rowid)),"^",38)
		s PLIST(40)=$p($g(^DHCEQMessages(rowid)),"^",39)
		s PLIST(41)=$p($g(^DHCEQMessages(rowid)),"^",40)
		s PLIST(42)=$p($g(^DHCEQMessages(rowid)),"^",41)
		s PLIST(43)=$p($g(^DHCEQMessages(rowid)),"^",42)
		s PLIST(44)=$p($g(^DHCEQMessages(rowid)),"^",43)
		s PLIST(45)=$p($g(^DHCEQMessages(rowid)),"^",44)
		i ToRoleDR="" s SQLCODE=-1000	//ToRoleDR is null
		s ID=0
		for  set ID=$o(^DHCEQCCode("DHCEQCUserRole",0,"Role",ToRoleDR,ID)) q:(ID="")||(SQLCODE'=0)  d
		.s SourceType=$p($g(^DHCEQCCode("DHCEQCUserRole",ID)),"^",1)	//1：用户  2：安全组
		.s SourceID=$p($g(^DHCEQCCode("DHCEQCUserRole",ID)),"^",2)		//Userid  GroupID
		.i SourceType=1 d //1：用户
		..q:$d(^TempDHCEQ("DHCEQMessages","SendData","ToUserID",Job,SourceID))
		..s PLIST(16)=SourceID
		..S ^TempDHCEQ("DHCEQMessages","SendData","ToUserID",Job,SourceID)=""
		..&SQL(insert into sqluser.DHC_EQMessages values :PLIST())
		.e  d 		//2：安全组
		..s UserID=0
		..for  set UserID=$o(^SSU("SSUSR",0,"Group",SourceID,UserID)) q:(UserID="")||(SQLCODE'=0)  d
		...q:$d(^TempDHCEQ("DHCEQMessages","SendData","ToUserID",Job,UserID))
		...s PLIST(16)=UserID
		...S ^TempDHCEQ("DHCEQMessages","SendData","ToUserID",Job,UserID)=""
		...&SQL(insert into sqluser.DHC_EQMessages values :PLIST())
		..//非默认安全组的用户
		..s UserID=0
		..for  set UserID=$o(^SSU("SSUSR",UserID)) q:(UserID="")||(SQLCODE'=0)  d
		...q:$d(^TempDHCEQ("DHCEQMessages","SendData","ToUserID",Job,UserID))
		...set flag=0
		...s ChildSub=0
		...for  set ChildSub=$o(^SSU("SSUSR",UserID,"OTHLL",ChildSub)) q:(ChildSub="")||(flag=1)  d
		....set groupid=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",2)
		....if groupid=SourceID set flag=1
		...quit:flag'=1
		...s PLIST(16)=UserID
		...S ^TempDHCEQ("DHCEQMessages","SendData","ToUserID",Job,UserID)=""
		...&SQL(insert into sqluser.DHC_EQMessages values :PLIST())
		
		K ^TempDHCEQ("DHCEQMessages","SendData","ToUserID",Job)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	i SourceIDMessageDR'=""
	{
		&SQL(update sqluser.DHC_EQMessages Set M_Status='3' where M_RowID=:SourceIDMessageDR)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}	
	}
 	TCOMMIT
 	q rowid
ERRORSend 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSend"_ErrorMsg     //返回错误消息 ;
}

/// 创建:zy 2010-12-28
/// w ##Class(web.DHCEQMessages).GetOneMessages("2")
ClassMethod GetOneMessages(rowid)
{
	new (rowid)
	s (result,resultex)=""
	s result= ^DHCEQMessages(rowid)
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(result,"^",2))
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s resultex=resultex_"^"	;MessageType
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",4),"0":"普通消息","1":"业务消息","2":"系统消息",:"没有定义")
	s resultex=resultex_"^"	;SendAll
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"bool")
	s resultex=resultex_"^"	;SendEmailFlag
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"bool")
	s resultex=resultex_"^"	;MobileMessageFlag
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"bool")
	s resultex=resultex_"^"	;SendType
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",8),"0":"发送到指定人","1":"发送到指定科室","2":"发送到指定角色","3":"指定科室的指定角色","9":"其他")
	s resultex=resultex_"^"	;SendUserDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",9))
	s resultex=resultex_"^"	;SendDate
	;i $p(result,"^",10)'=""  d
	;.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")
	;日期格式统一调整
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")
	s resultex=resultex_"^"	;SendTime
	;i $p(result,"^",11)'=""  d
	;.s resultex=resultex_$ZT($p(result,"^",11),2)
	;日期格式统一调整
	s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"time")
	s resultex=resultex_"^"	;FromUserDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",12))
	s resultex=resultex_"^"	;FromLocDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",13))
	s resultex=resultex_"^"	;FromRoleDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("role",$p(result,"^",14))
	s resultex=resultex_"^"	;ToUserDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s resultex=resultex_"^"	;ToLocDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",16))
	s resultex=resultex_"^"	;ToRoleDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("role",$p(result,"^",17))
	s resultex=resultex_"^"	;ReadUserDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",19))
	s resultex=resultex_"^"	;ReadDate
	;i $p(result,"^",20)'=""  d
	;.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",20),"date")
	;日期格式统一调整
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",20),"date")
	s resultex=resultex_"^"	;ReadTime
	;i $p(result,"^",21)'=""  d
	;.s resultex=resultex_$ZT($p(result,"^",21),2)
	;日期格式统一调整
	s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"time")
	s resultex=resultex_"^"	;DealUserDR
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",22))	
	s resultex=resultex_"^"	;DealDate
	;i $p(result,"^",23)'=""  d
	;.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",23),"date")
	;日期格式统一调整
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",23),"date")
	s resultex=resultex_"^"	;DealTime
	;i $p(result,"^",24)'=""  d
	;.s resultex=resultex_$ZT($p(result,"^",24),2)
	;日期格式统一调整
	s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",24),"time")
	s resultex=resultex_"^"	;BussType
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_##class(web.DHCEQFind).GetBussTypeDesc($p(result,"^",25))
	s resultex=resultex_"^"	;Status
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",26),"0":"新增","1":"发送","2":"已读","3":"已回复")
	s resultex=resultex_"^"	;EmergencyLevelDR
	i $p(result,"^",29)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEmergencyLevel",$p(result,"^",29))),"^",2)
	s resultex=resultex_"^"	;InBoxInvalidFlag
	;i $p(result,"^",30)'=""  d
	;.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",30),"bool")
	;日期格式统一调整	
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",30),"bool")
	s resultex=resultex_"^"	;InBoxDelUserDR
	i $p(result,"^",31)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",31))
	s resultex=resultex_"^"	;InBoxDelDate
	;i $p(result,"^",32)'=""  d
	;.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",32),"date")	
	;日期格式统一调整
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",32),"date")
	s resultex=resultex_"^"	;InBoxDelTime
	;i $p(result,"^",33)'=""  d
	;.s resultex=resultex_$ZT($p(result,"^",33),2)
	;日期格式统一调整
	s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",33),"time")
	s resultex=resultex_"^"	;OutBoxInvalidFlag
	;i $p(result,"^",34)'=""  d
	;.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",34),"bool")
	;日期格式统一调整
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",34),"bool")
	s resultex=resultex_"^"	;OutBoxDelUserDR
	i $p(result,"^",35)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",35))
	s resultex=resultex_"^"	;OutBoxDelDate
	;i $p(result,"^",36)'=""  d
	;.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",36),"date")
	;日期格式统一调整
	s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",36),"date")
	s resultex=resultex_"^"	;OutBoxDelTime
	;i $p(result,"^",37)'=""  d
	;.s resultex=resultex_$ZT($p(result,"^",37),2)
	;日期格式统一调整
	s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",37),"time")
	s resultex=resultex_"^"	;DealFlag
	i $p(result,"^",39)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",39),"0":"","1":"未处理","2":"已处理")
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 修改:zy 2016-02-18
/// 阅读消息,新表结构
/// 创建:zy 2010-12-28
/// 阅读消息
/// w ##Class(web.DHCEQMessages).ReadMessage("1")
ClassMethod ReadMessage(rowid)
{
	//modified by zy 2011-02-18 ZY0055
	new User,Date,Time
	k M,MRI
	Set $ZT="ReadMessage"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s MRI(6) = 1 	;Status
	s MRI(7) = Date	;ReadDate
	s MRI(8) = Time	;ReadTime
	s MessagesID=$p($g(^DHCEQMessagesRecInfo(rowid)),"^",1)
	
	TSTART
	&SQL(update sqluser.DHC_EQMessagesRecInfo values :MRI() where MRI_RowID=:rowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s M(22) = "Y" 	;DealFlag
	s M(23) = User				;DealUserDR
	s M(24) = Date				;DealDate
	s M(25) = Time				;DealTime
	&SQL(update sqluser.DHC_EQMessages values :M() where M_RowID=:MessagesID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q rowid
ReadMessage 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ReadMessage"_ErrorMsg     //返回错误消息 ;
}

/// Add By DJ 2016-05-10
/// 增加参数:LimitActions指定人员动作, LimitUserDR限定人员
/// 			LimitLocActions指定科室动作, LimitLocDR限定科室
/// Modified By ZY 2016-02-17
/// 重新处理发给用户的消息
/// Modified By HZY 2012-03-08 HZY0024
/// Desc:新增'研究课题'的业务消息处理.
/// ------------------------------------------------------------------------------------------------
/// 生成业务消息，将消息发送给需要处理的下一个角色
/// 入参：	BussType：业务类型11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用、51设备调帐
/// 		BussID:业务ID
/// 		User：操作人
/// 		ApproveFlowInfo：下一步审批信息
/// 		RefuseFlag:是否拒绝标志
/// 		CurRole:当前角色
/// 		AuditFlag:0非审核步骤 1审核步骤
/// 返回：0：成功
/// 		其他：失败
/// w ##Class(web.DHCEQMessages).CreateBussInfo("92", 4, 1, "1"_"^"_"1", "N", "", "0")
/// w ##Class(web.DHCEQMessages).CreateBussInfo(BussType, BussID, User, ApproveFlowInfo, RefuseFlag)
ClassMethod CreateBussInfo(BussType, BussID, User, ApproveFlowInfo, RefuseFlag As %String = "N", CurRole As %String = "", AuditFlag As %String = "0", GroupID As %String = "", LimitActions As %String = "", LimitUserDR As %String = "", LimitLocActions As %String = "", LimitLocDR As %String = "")
{
	n Title,ToRoleDR,ToLocDR,QxType,LocField,SendType,SourceMessageDR
	n ListID,MessageID,DealDate,DealTime
	n val,bussInfo,FirstValue,SecondValue,ReceiveInfo,ReceiveValue,NextActionID,NextFlowID,DefActionID,SameStepReceiveInfo,RepeatUsers
	s (EquipTypeDR,Title,ToRoleDR,ToLocDR,ToUserDR,QxType,LocField,SendType,SourceMessageDR,FirstValue,SecondValue,ReceiveInfo,ReceiveValue,NextActionID,NextFlowID,DefActionID,SameStepReceiveInfo,RepeatUsers)=""
	
	s SendPlatMessage=##class(web.DHCEQCommon).GetSysInfo("990090")
	s Job=$J
	s BussTypeDesc=##Class(web.DHCEQFind).GetBussTypeDesc(BussType)
	s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussType,BussID)
	s BussNo=$p(BussInfo,"^",1)
	
	s NextStep=$p(ApproveFlowInfo,"^",2)
	s NextRole=$p(ApproveFlowInfo,"^",3)
	s QxType=$p(ApproveFlowInfo,"^",4)
	s LocField=$p(ApproveFlowInfo,"^",5)
	s ActionID=$p(ApproveFlowInfo,"^",10)  //add by zx 2017-02-24
	s DefActionID=$p(ApproveFlowInfo,"^",10) //add by zx 2017-02-24
	s UnMustFlag=$p(ApproveFlowInfo,"^",7)
	s GotoType=$p(ApproveFlowInfo,"^",8)
	s ApproveSet=$p(ApproveFlowInfo,"^",9)  //add by zx 2017-02-24
	i ApproveSet="" s ApproveSet=$p(ApproveFlowInfo,"^",11)		//南方医院发送短信
	s RepeatUsers=$p(ApproveFlowInfo,"^",12) //add by zx 2018-07-10 重复步骤已操作人
	i NextStep'="" d
	.s NextFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,NextStep,""))
	.i NextFlowID'="" s NextActionID=$p($g(^DHCEQCCode("DHCEQCApproveFlow",NextFlowID)),"^",9)
	//add by zx 2016-03-10  
	//生成消息的时候,需要传消息给可中断此步骤的角色
	s ReceiveInfo=##class(web.DHCEQCApproveSet).GetCanReceiveRoleIDs(ApproveSet,NextStep,BussID)
	i $p(ReceiveInfo,"^",1)=0 d  //无可中断,只算默认审批流
	.s ToRoleIDs=NextRole
	.s ReceiveValue=NextRole_"@"_NextActionID
	i $p(ReceiveInfo,"^",1)=1 d  //可中断,拼接默认审批流
	.s ToRoleIDs=NextRole_","_$p(ReceiveInfo,"^",2)
	.s ReceiveValue=NextRole_"@"_NextActionID_","_$p(ReceiveInfo,"^",3)
	i ((RefuseFlag="Y")&&($p(ReceiveInfo,"^",1)=1)) d           //取消提交,只算可中断		//Modify DJ 2016-05-23
	.s ToRoleIDs=$p(ReceiveInfo,"^",2)_","_NextRole
	.s ReceiveValue=$p(ReceiveInfo,"^",3)_","_NextRole_"@"_NextActionID
	s Title="待审批-"
	//0：发送到指定人 1:发送到指定科室 2：发送到指定角色  3：发送到指定科室的指定角色  9:其他
	s SendType=2
	s FirstValue=ToRoleIDs
	//取消提交到
	if RefuseFlag="Y"
	{
		s Title="被拒绝-"
		if ToRoleIDs=""
		{
			s SendType=0
		}
		else
		{
			s SendType=2
		}
	}
	
	//出库的时候,考虑接收科室的指定角色
	i LocField="ToLocDR"
	{
		s SendType=3
		s SecondValue=$p(BussInfo,"^",7)
	}
	s Title=Title_BussTypeDesc_":"_BussNo
	
	s MessageType=1
	
	s SQLCODE=0
	;处理其之前收到的 待处理 业务消息状态为处理
	s MessageID=0
	for  s MessageID=$o(^DHCEQMessages(0,"MessageType",MessageType,BussType,BussID,MessageID)) q:((MessageID="")||(SQLCODE'=0))  d
	.q:$p($g(^DHCEQMessages(MessageID)),"^",21)="Y"	;DealFlag N未处理 Y已处理
	.;q:$p($g(^DHCEQMessages(MessageID)),"^",12)'=CurRole	;FromRoleDR
	.;当申请提交时,当前角色为空,则要处理 之前被拒绝 发给建单人的信息
	.;q:((CurRole="")&&($p($g(^DHCEQMessages(MessageID)),"^",15)'=User))	;ToRoleDR
	.k MList
	.s MList(22)="Y"
	.s MList(23)=User
	.s MList(24)=+$H
	.s MList(25)=$p($H,",",2)
	.s SourceMessageDR=MessageID
	.&SQL(Update sqluser.DHC_EQMessages values :MList() Where M_RowID=:MessageID)
	.;modify by zx 2021-11-09 消息处理后修改未发送信息状态
	.q:SQLCODE'=0
	.&SQL(Update sqluser.DHC_EQMessageSendInfo set MSI_Status='4' Where MSI_MessagesDR=:MessageID and MSI_Status='0')
	i SQLCODE<0 q SQLCODE
	
	
	//Modify by zx 插入延迟时间
	i ReceiveValue'="" d
	.s DelayResult={}  //记录对应动作延时时长
	.s ContralLen=$L(ReceiveValue,",")
	.f ContralNum=1:1:ContralLen  d
	..s ContralActionID=$p($p(ReceiveValue,",",ContralNum),"@",2)
	..s CurContralTime=##Class(web.DHCEQ.Plat.LIBMessages).MessagesServerContral("","","",ContralActionID)
	..d DelayResult.%Set(ContralActionID,CurContralTime)
	
	;最后一步审核步骤不需要发消息
	i +AuditFlag=1 q 0
	
	s val=""		;RowID	1
	s val=val_"^"_Title	;Title??
	s val=val_"^"_MessageType	;MessageType 0:普通消息 1：业务消息 2:系统消息
	s val=val_"^"_SendType	;SendType0：发送到指定人 1:发送到指定科室 2：发送到指定角色  3：发送到指定科室的指定角色  9:其他
	s val=val_"^1"	;SendMode 0:只发送一份，有人阅读即为阅读  1：发送相关所有人，每人一份
	s val=val_"^0"	;SendEmailFlag
	s val=val_"^0"	;MobileMessageFlag
	s val=val_"^"	;EmergencyLevelDR
	s val=val_"^" 	;Content
	s val=val_"^" 	;Remark
	s val=val_"^"_BussType 	;BussType
	s val=val_"^"_BussID 	;BussID
	s val=val_"^"_CurRole	;FromRoleDR
	s val=val_"^"	;SourceMessageDR
	s val=val_"^1"	;Status
	s val=val_"^^^"	;SendUserDR;SendDate;SendTime
	s val=val_"^^^"	;RevokeUserDR;RevokeDate;RevokeTime
	s val=val_"^0"	;DealFlag
	s val=val_"^^^"	;DealUserDR;DealDate;DealTime
	s val=val_"^" 	;ContactInfo
	s val=val_"^"_ActionID	;Hold1
	s val=val_"^" 	;Hold2
	s val=val_"^" 	;Hold3
	s val=val_"^" 	;Hold4
	s val=val_"^" 	;Hold5
	
	s SQLCODE= ..SaveData(val,"","N",User)
	i SQLCODE<0 q SQLCODE
	//写入消息接收范围表信息
	s MessageDR=SQLCODE
	//Add By DJ 2016-11-29  为补发消息准备临时登记参数
	s ^DHCEQMessages(MessageDR,"EX","ApproveFlowInfo")=ApproveFlowInfo
	s ^DHCEQMessages(MessageDR,"EX","RefuseFlag")=RefuseFlag
	s ^DHCEQMessages(MessageDR,"EX","CurRole")=CurRole
	s ^DHCEQMessages(MessageDR,"EX","AuditFlag")=AuditFlag
	s ^DHCEQMessages(MessageDR,"EX","GroupID")=GroupID
	s ^DHCEQMessages(MessageDR,"EX","LimitActions")=LimitActions
	s ^DHCEQMessages(MessageDR,"EX","LimitUserDR")=LimitUserDR
	s ^DHCEQMessages(MessageDR,"EX","LimitLocActions")=LimitLocActions
	s ^DHCEQMessages(MessageDR,"EX","LimitLocDR")=LimitLocDR
	k MRR
	s MRR(2)=MessageDR
	s MRR(3)=FirstValue
	s MRR(4)=SecondValue
	s MRR(5)=""
	s MRR(6)=""
	s MRR(7)=""
	&SQL(insert into sqluser.DHC_EQMessagesRecRange values :MRR())
	i SQLCODE'=0 q SQLCODE
	
	//取当前业务审批信息,获取限制条件,以便后面查看用户是否有权限收消息
	s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(BussType,BussID,"")
	//EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR
	s EquipTypeDR=$p(ApproveInfo,"^",10)
	s StatCatDR=$p(ApproveInfo,"^",11)
	s EquipCatDR=$p(ApproveInfo,"^",12)
	s LocDR=$p(ApproveInfo,"^",9)
	s EquipID=$p(ApproveInfo,"^",14)
	s ItemDR=$p(ApproveInfo,"^",13)
	s CancelToUser=$p(ApproveInfo,"^",19)
	s AccessoryTypeDR=$p(ApproveInfo,"^",15)  //Modefid by zc0106 2021-7-27 配件类组过滤
	//0：发送到指定人 1:发送到指定科室 2：发送到指定角色  3：发送到指定科室的指定角色  9:其他
	//业务消息只有2和3两种状态
	if (SendType=2)||(SendType=3)
	{
		//根据消息接收范围表的内容来给用户发消息
		s Len=$L(ReceiveValue,",")
		f i=1:1:Len  d
		.s RoleID=$p($p(ReceiveValue,",",i),"@",1)
		.s ActionID=$p($p(ReceiveValue,",",i),"@",2)
		.//Modify by zx 2021-08-27 获取当前动作延时时长
		.s LimitContralTime=""
		.i ActionID'="" s LimitContralTime=DelayResult.%Get(ActionID)
		.d ##Class(web.DHCEQCommon).ReissueMessage(Job,BussType,BussID,ActionID,RoleID,"",ApproveSet)		//Add By DJ 2016-05-24
		.s GroupIDs=##Class(web.DHCEQCGroupRole).GetGroupbyRole(RoleID)
		.i (LimitContralTime="")&&(LimitUserDR'="")&&((","_LimitActions_",")[(","_ActionID_","))&&(LimitUserDR'[",")  d   //add by zx 2017-05-17 BUG ZX0038
		..i $D(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,LimitUserDR,0)) d  //特殊处理类组节点,权限判断时直接允许通过
		...i (","_^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,LimitUserDR,0,"Role")_",")'[(","_RoleID_",")  d			//Modify DJ 2019-02-02
		....s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,LimitUserDR,0,"Role")=^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,LimitUserDR,0,"Role")_","_RoleID
		....s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,LimitUserDR,0,"Action")=^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,LimitUserDR,0,"Action")_","_ActionID
		..e  d
		...s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,LimitUserDR,0,"Role")=RoleID
		...s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,LimitUserDR,0,"Action")=ActionID
		.//add by zx 2018-10-25  组内人员表遍历
		.s UserID=0
		.f  s UserID=$o(^DHCEQCCode("DHCEQCUser",UserID))  q:UserID=""  d
		..q:(RepeatUsers'="")&&((","_RepeatUsers_",")[(","_UserID_","))
		..;q:(LimitContralTime="")&&(LimitUserDR'="")&&((","_LimitUserDR_",")'[(","_UserID_","))&&((","_LimitActions_",")[(","_ActionID_","))  //Modify by zx 2021-09-14
		..q:((LimitContralTime="")&&(##Class(web.DHCEQMessages).LimitByAction(BussType, BussID, UserID, ActionID, LimitActions, LimitUserDR)'="1"))  //Modify by zx 2022-09-08 维修时可按组限定
		..s FindFlag=0
		..s UserGroup=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",15)
		..s GroupLocDR=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",14)
		..i (UserGroup'="")&&((","_GroupIDs_",")[(","_UserGroup_","))  d
		...i (SecondValue="")||(SecondValue=GroupLocDR)  d
		....q:(LimitLocDR'="")&&((","_LimitLocDR_",")'[(","_GroupLocDR_","))&&((","_LimitLocActions_",")[(","_ActionID_","))	//modified by czf 2019-09-25 多个限定科室 CZF0091
		....;q:(LimitLocDR'="")&&(LimitLocDR'=GroupLocDR)&&((","_LimitLocActions_",")[(","_ActionID_","))
		....q:(EquipTypeDR'="")&&(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,UserGroup,"","2"))  //add by zx 2021-05-07 BUG ZX0133
		....q:(AccessoryTypeDR'="")&&(##class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR,UserGroup))  //Modefid by zc0106 2021-7-27  配件类组过滤
		....d SetGroupAndRoleInfo
		....s FindFlag=1
		..s ExType=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",18)
		..i ExType="1" d
		...s SSUserID= $p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",19)
		...q:SSUserID=""
		...s UserGroup=$P($G(^SSU("SSUSR",SSUserID)),"^",5)
		...s GroupLocDR=$P($G(^SSU("SSUSR",SSUserID)),"^",4)
		...i (UserGroup'="")&&((","_GroupIDs_",")[(","_UserGroup_","))  d
		....i (SecondValue="")||(SecondValue=GroupLocDR)  d
		.....q:(LimitLocDR'="")&&((","_LimitLocDR_",")'[(","_GroupLocDR_","))&&((","_LimitLocActions_",")[(","_ActionID_","))	//modified by czf 2019-09-25 多个限定科室 CZF0091
		.....;q:(LimitLocDR'="")&&(LimitLocDR'=GroupLocDR)&&((","_LimitLocActions_",")[(","_ActionID_","))
		.....q:(EquipTypeDR'="")&&(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,UserGroup,"","2"))  //add by zx 2021-05-07 BUG ZX0133
		.....d SetGroupAndRoleInfo
		.....s FindFlag=1
		...
		...s (chl,FindFlag)=0
		...f  s chl=$O(^SSU("SSUSR",SSUserID,"OTHLL",chl)) q:(chl="")  d
		....q:(","_GroupIDs_",")'[(","_$P(^SSU("SSUSR",SSUserID,"OTHLL",chl),"^",2)_",")	//是否在指定安全组内的用户
		....q:(SecondValue'="")&(SecondValue'=$P(^SSU("SSUSR",SSUserID,"OTHLL",chl),"^",1)) //有指定科室时,判断科室
		....s UserGroup=$P(^SSU("SSUSR",SSUserID,"OTHLL",chl),"^",2)
		....q:UserGroup=""
		....s GroupLocDR=$P(^SSU("SSUSR",SSUserID,"OTHLL",chl),"^",1)
		....q:GroupLocDR=""
		....q:(EquipTypeDR'="")&&(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,UserGroup,"","2"))  //add by zx 2021-05-07 BUG ZX0133
		....q:(AccessoryTypeDR'="")&&(##class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR,UserGroup))  //Modefid by zc0106 2021-7-27  配件类组过滤
		....s GroupLocDR=$o(^DHCEQCCode("DHCEQCDepartment","0","ExID","Y","1",GroupLocDR,""))
		....;q:GroupLocDR=""  //add by zx 2021-05-07 BUG ZX0133
		....q:(LimitLocDR'="")&&((","_LimitLocDR_",")'[(","_GroupLocDR_","))&&((","_LimitLocActions_",")[(","_ActionID_","))	//modified by czf 2019-09-25 多个限定科室 CZF0091
		....;q:(LimitLocDR'="")&&(LimitLocDR'=GroupLocDR)&&((","_LimitLocActions_",")[(","_ActionID_","))
		....d SetGroupAndRoleInfo
		....s FindFlag=1
		..q:FindFlag=0
		..s RoleIDs=$g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID))
		..i RoleIDs=""  d
		...s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID)=$p(ReceiveValue,",",i)
		..e  d
		...s ReceiveRole=$p($p(ReceiveValue,",",i),"@",1)
		...s ReceiveAction=$p($p(ReceiveValue,",",i),"@",2)
		...s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID)=$p(RoleIDs,"@",1)_","_ReceiveRole_"@"_$p(RoleIDs,"@",2)_","_ReceiveAction
	}
	
	elseif SendType=0
	{
		if CancelToUser'=""  d		//Modify DJ 2016-05-23
		.s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,CancelToUser,0,"Role")=0
		.s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,CancelToUser,0,"Action")=0
	}
	k MRI
	i '$Data(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID)) q 0
	s Flag=0
	s DefineFlag=0  //add by zx 2017-02-24
	s SendInfoVal=""
	s RecInfoID=""
	s EmployeeInfo=""
	
	s UserID=0
	f  s UserID=$o(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID))  q:(UserID="")||(Flag'=0)  d
	.s ReceiveValues=$g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID))  //add by zx 2017-01-11 代码疑似无效 ZX0036
	.
	.s UserRoles=""
	.s UserGroup=""
	.f  s UserGroup=$o(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup))  q:(UserGroup="")  d
	..s ToRoleIDs=$g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Role"))
	..q:##Class(web.DHCEQCommon).CheckManageLimit(UserID,UserGroup,ToRoleIDs,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)
	..
	..i UserRoles=""  d
	...s UserRoles=$g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Role"))
	...s UserActions=$g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Action"))
	..e  d
	...s UGRolesCount=$L($g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Role")),",")
	...s UGI=0
	...s URI=0
	...f UGI=1:1:UGRolesCount  d
	....s UGRoleAction=$p($g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Role")),",",UGI)_"-"_$p($g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Action")),",",UGI)
	....s URolesFind=0
	....s URolesCount=$L(UserRoles,",")		//Modify DJ 2019-02-02
	....f URI=1:1:URolesCount  d
	.....q:URolesFind'=0
	.....s URolesAction=$p(UserRoles,",",URI)_"-"_$p(UserActions,",",URI)
	.....i URolesAction=UGRoleAction s URolesFind=1
	....i URolesFind=0  d
	.....s UserRoles=UserRoles_","_$p($g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Role")),",",UGI)
	.....s UserActions=UserActions_","_$p($g(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Action")),",",UGI)
	.q:UserRoles=""		//Modify DJ 2016-05-23
	.s ServerContralTime=0
	.i UserActions'="" d
	..//Modify by zx 2021-08-27 获取当前消息接收人最大延时时长
	..s ActionLenght=$L(UserActions,",")
	..f CurActionLenght=1:1:ActionLenght d
	...s CurServerContralTime=DelayResult.%Get($P(UserActions,",",CurActionLenght))
	...i CurServerContralTime>ServerContralTime s ServerContralTime=CurServerContralTime
	.;q:##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,ToRoleIDs,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR) //移动端session值处理 add by zx 2016-04-19 
	.//Modify by zx 2021-08-27 限定人延时时长重置为0
	.i (LimitUserDR'="")&&((","_LimitUserDR_",")[(","_UserID_",")) d
	..s ServerContralTime=0  //指定人不做延时
	.i LimitUserDR="" s ServerContralTime=0
	.s MRI(2)=MessageDR	;
	.s MRI(3)=UserID	;ReceiveUserDR
	.s MRI(4)=""		;ContractInfo
	.s MRI(5)=$p(ReceiveValues,"@",1)	;Roles
	.s MRI(5)=UserRoles
	.s MRI(6)="0"		;Status
	.s MRI(7)=+$H		;ReceiveDate
	.s MRI(8)=$p($H,",",2)	;ReceiveTime
	.s MRI(9)=""		;DelDate	
	.s MRI(10)=""		;DelTime	
	.s MRI(11)=$p(ReceiveValues,"@",2)  ;Hold1 存入Action
	.s MRI(11)=UserActions
	.s MRI(12)=""		;Hold2
	.s MRI(13)=""		;Hold3
	.s MRI(14)=ServerContralTime		;DelayFlag
	.&SQL(insert into sqluser.DHC_EQMessagesRecInfo values :MRI())
	.s RecInfoID=$G(%ROWID) //add by zx 2017-02-24
	.//modify by zx 2021-11-09 信息发送走配置表
	.i SQLCODE'=0 s Flag=SQLCODE
	.q:Flag'=0
    .i CurRole="" s CurRole=0
    .i DefActionID="" s DefActionID=0
    .s DefineFlag=##Class(web.DHCEQMessages).CheckMessageSendDefine(BussType,CurRole,DefActionID,UserRoles,UserActions,"1")
    .i DefineFlag'=0 d
    ..s SQLCODE=##Class(web.DHCEQMessages).CreatMessageSend(BussType, BussID, DefineFlag,"1", CurRole, UserID, MessageDR, RecInfoID)
	..i SQLCODE'=0 s Flag=SQLCODE
	.q:Flag'=0
	.;add by zc0112 2022-01-06 调用平台发送消息 begin
	.i SendPlatMessage="1" d	//czf 2022-09-06 2610377 系统参数控制是否启用平台消息发送
	..q:(BussType=94)&&($p($g(^DHCEQContract(BussID)),"^",39)'=1)	// MZY0126	2647787		2022-06-13	非保修合同
	..s Flag=##class(web.DHCEQCommon).MessageSend(BussType,User,UserID,$p(BussInfo,"^",1))
	..q:Flag'=0
	.;add by zc0112 2022-01-06 调用平台发送消息 end
	k ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID)
	
	q Flag
SetGroupAndRoleInfo
	s PassFlag=1
	///Modify DJ 2017-09-20
	if ((LimitUserDR'="")&&((","_LimitActions_",")[(","_ActionID_",")))
	{
		//Modify by zx 2022-09-14
	    //i (LimitContralTime="")&&((","_LimitUserDR_",")'[(","_UserID_",")) s PassFlag=0
	    i (##Class(web.DHCEQMessages).LimitByAction(BussType, BussID, UserID, ActionID, LimitActions, LimitUserDR)'="1") s PassFlag=0
		//##Class(web.DHCEQCommon).CheckManageLimit(UserID,UserGroup,RoleID,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)'=0	//Add By DJ 2016-05-24  jdl 2017-01-12
	}
	else
	{
		i ##Class(web.DHCEQCommon).CheckManageLimit(UserID,UserGroup,RoleID,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)'=0 s PassFlag=0	//Add By DJ 2016-05-24  ZX 2017-01-12 派单可指派权限外的 ZX0036
	}
	q:PassFlag'=1
	;q:(LimitUserDR'=UserID)&&((","_LimitActions_",")[(","_ActionID_","))&&##Class(web.DHCEQCommon).CheckManageLimit(UserID,UserGroup,RoleID,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)'=0	//Add By DJ 2016-05-24  ZX 2017-01-12 派单可指派权限外的 ZX0036
	i $d(^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup))  d
	.i (","_^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Role")_",")'[(","_RoleID_",")  d
	..s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Role")=^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Role")_","_RoleID
	..s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Action")=^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Action")_","_ActionID
	e  d
	.s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Role")=RoleID
	.s ^TempDHCEQ("MessagesRecieveUser",Job,BussType,BussID,UserID,UserGroup,"Action")=ActionID
	
	d ##Class(web.DHCEQCommon).ReissueMessage(Job,BussType,BussID,ActionID,RoleID,UserID,ApproveSet)		//Add By DJ 2016-05-24
}

/// ----------------------------------
/// modified by zy 2011-03-03 ZY0064
/// 描述：是否处理标识
/// ----------------------------------
ClassMethod GetDealFlag(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>不需处理</option>"
	w "<option value=1>未处理</option>"
	w "<option value=2>已处理</option>"
	w "</select>",!
}

/// add by zy 2015-11-12
/// 增加消息发送功能
/// 参数说明:CurRoles ：当前角色
/// 返回值  :""  就是没有待审核消息; 否则,
/// w ##Class(web.DHCEQMessages).GetMsgInfo("217",1)
ClassMethod GetMsgInfo(GroupID)
{
	new result,RoleIDs,browid
	new busstypedr,busscode,busstype,rrowid,flag,Num
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s RoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
	s result=""
	s browid=0
	f  s browid=$o(^DHCEQCCode("DHCEQCBussType",browid))  quit:browid=""  d
	.s (busstypedr,busscode,busstype,preBussCode)=""
	.q:($p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",4)="Y")
	.s busstypedr=browid
	.s busscode=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",1)
	.s busstype=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",2)
	.s preBussCode=$e(busscode,1)
	.q:(",1,2,3,4,5,6,7,8,9,"'[preBussCode)
	.s (rrowid,flag,Num)=0
	.f  s rrowid=$o(^DHCEQCCode("DHCEQCRoleBuss",0,"BussType",browid,rrowid))  quit:rrowid=""  d
	..i (RoleIDs'="")&&((","_RoleIDs_",")[(","_$p($g(^DHCEQCCode("DHCEQCRoleBuss",rrowid)),"^",1)_",")) s flag=1
	.q:flag=0
	.i (preBussCode="6")||(preBussCode="7")  d
	..i (busscode="71")||(busscode="72-1")||(busscode="72-2")  d
	...s Num=+##Class(web.DHCEQMessages).GetMaintAlertNum(+$j,busscode)
	..e  i (busscode="63-1")||(busscode="63-2")||(busscode="63-3")  d
	...s Num=+##Class(web.DHCEQMessages).GetCertificateAlertNum(busscode,+$H)
	..e  i (busscode="73")  d
	...s Num=+##Class(web.DHCEQMessages).GetGuaranteeAlertNum(GroupID,+$H)
	..e  i (busscode="64")  d
	...s Num=+##Class(web.DHCEQMessages).GetRentAlertNum(GroupID,+$H)
	.e  i preBussCode="8"  d
	..s Num=##Class(web.DHCEQMessages).GetMaintMonitorNum(GroupID)
	.e  d
	..s Num=+##Class(web.DHCEQMessages).GetBussAertNum(busscode,GroupID,UserID,RoleIDs)
	.q:Num<1
	.i result=""  d
	..s result=busstype_":"_Num
	.e  d
	..s result=result_","_busstype_":"_Num
	
	quit result
}

/// add by zy 2015-11-12
/// 获取当前安全组用户角色可操作的业务数量
/// 参数说明:BussCode：业务Code
/// 		 GroupID ：当前角色
/// 		 CurRoles ：当前角色
/// 返回值  :Num
/// w ##Class(web.DHCEQMessages).GetBussAertNum("11","85","1",",1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,")
/// Modify by zx 2020-09-16 移动端参数传递处理CurLocDR
ClassMethod GetBussAertNum(BussCode, GroupID, UserID, RoleIDs, CurLocDR As %String = "")
{
	new BussType,BussID,MsgID,DataList,PassFlag
 	s (Num,MsgID,PassFlag)=0
 	i CurLocDR="" s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID")) //Add By QW20200907 BUG:QW0078
 	f  s MsgID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID)) q:MsgID=""  d
 	.//判断消息的可处理角色和当前角色是否符合
 	.//q:MsgID'=7
 	.s PassFlag=0
 	.//add by zx 2017-03-01 begin
 	.;s MRIAction=""
 	.;s MRIRowID=0
 	.;f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID,MRIRowID)) q:(MRIRowID="")||(PassFlag=1)  d
 	.;.s Roles=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",4)
 	.;.q:Roles=""
 	.;.s MRIAction=","_$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",10)_","		//消息动作权限
 	.;.s Len=$L(Roles,",")
	.;.f i=1:1:Len  d
	.;..q:PassFlag=1
	.;..s Role=$p(Roles,",",i)
	.;..i (","_RoleIDs_",")'[(","_Role_",") s PassFlag=1  
	.;q:PassFlag=1
    .s PassFlag=##Class(web.DHCEQMessages).CheckMessageRoles(GroupID,UserID,MsgID,RoleIDs) //BUG ZX00045
	.q:$p(PassFlag,"^",1)=0
	.s MRIAction=","_$p(PassFlag,"^",4)
	.s Roles=$p(PassFlag,"^",4)
	.//add by zx 2017-03-01 end 
	.s DataList=$g(^DHCEQMessages(MsgID))
 	.q:$p(DataList,"^",14)'="1"
 	.q:$p(DataList,"^",21)="Y"
	.s BussType=$p(DataList,"^",10)
	.q:BussType'=BussCode
	.s BussID=$p(DataList,"^",11)
	.s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussType,BussID)
	.//modify by zx
	.;q:(($p(BussInfo,"^",29)-(+$h))>1)&&(BussType="64")    //add by lmm 355232
	.;q:($p(BussInfo,"^",12)'=2)&&(BussType="64")
	.q:($p(BussInfo,"^",12)=2)&&(BussType'="64")		//BussStatus add by zx 2016-11-17 租赁审核状态处理 ZX0036
	.q:$p(BussInfo,"^",13)="Y"		//BussInvalidFlag
	.//取当前业务审批信息,获取限制条件,以便后面查看用户是否有权限收消息
	.s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(BussType,BussID,"")
	.//EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR
	.s EquipTypeDR=$p(ApproveInfo,"^",10)
	.q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"","2")) //add by zx 2017-03-20 BUG ZX0036
	.s StatCatDR=$p(ApproveInfo,"^",11)
	.s EquipCatDR=$p(ApproveInfo,"^",12)
	.s LocDR=$p(ApproveInfo,"^",9)
	.s EquipID=$p(ApproveInfo,"^",14)
	.s ItemDR=$p(ApproveInfo,"^",13)
	.s CancelToUser=$p(ApproveInfo,"^",19)
	.s TApproveSetDR=$p(ApproveInfo,"^",3)  //add by zx 2017-06-20 BUG ZX0045 微信端approveset获取
	.s TNextStepID=$p(ApproveInfo,"^",5)	//czf 2021-09-01 begin
	.s THospitalDR=$p(BussInfo,"^",32)
	.s (AppFlowID,HospLimit)=""
	.i (TApproveSetDR'="")&&(TNextStepID'="") d
	..s AppFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",TApproveSetDR,TNextStepID,""))
	..i AppFlowID'="" s HospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AppFlowID)),"^",20)
	.q:(THospitalDR'="")&&(##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"","","",HospLimit)) //czf 2021-09-01 end
	.s AssignDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Assign",0))_","			//派单动作DR		//Add By DJ 2016-05-25 begin
	.s EvaluateDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Evaluate",0))_","		//组长审核动作DR
	.s LeaderFlag=$D(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",1,UserID))		//是否维修组长
	.s PersonelFlag=0  //add by jdl 2017-01-11
	.s AuditFlag=0 //Add By QW20200907 BUG:QW0078
	.if (","_MRIAction_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Accept",0))_",")  d
	..s PersonelFlag=1
	.else  if (","_MRIAction_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Audit",0))_",")  d
	..s PersonelFlag=1
	..s AuditFlag=1 //Add By QW20200907 BUG:QW0078
	.else  if (","_MRIAction_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Finish",0))_",")  d
	..s PersonelFlag=1
	.s CMLReturn=0
	.i '(((LeaderFlag)&&((MRIAction[AssignDR)||(MRIAction[EvaluateDR))))&&(PersonelFlag'=1)  d		//不满足既是维修组长并且消息动作权限包含派单或组长审核动作
	..s CMLReturn=##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,Roles,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)
 	.q:CMLReturn'=0
 	.;q:##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,Roles,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)		//Add By DJ 2016-05-25 end
 	.q:(AuditFlag=1)&&(##Class(web.DHCEQCommon).ISPreLoc(LocDR,CurLocDR)=0) //Modified By QW20200922 BUG:QW0081 优化访问权限
 	.i (","_MRIAction_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","Move_Receive",0))_",")  d	//czf 2021-06-03 begin
	..s AuditFlag=1
	.s ToLocDR=$p(BussInfo,"^",7)
	.q:(AuditFlag=1)&&(ToLocDR'="")&&(##Class(web.DHCEQCommon).ISPreLoc(ToLocDR,CurLocDR)=0)		//czf 2021-06-03 end
	.i (","_MRIAction_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","BuyReq_Loc",0))_",")  d	//czf 2023-04-18 begin
	..s AuditFlag=1
	.s RequestLocDR=$p(BussInfo,"^",3)
	.q:(AuditFlag=1)&&(RequestLocDR'="")&&(##Class(web.DHCEQCommon).ISPreLoc(RequestLocDR,CurLocDR)=0)		//czf 2023-04-18 end
 	.s Num=Num+1
	
	quit Num
}

/// add by zy 2015-11-12
/// 获取当前安全组用户角色需操作的计量检查保养设备数量
/// 参数说明:Node  临时数据的存贮节点
/// 		 BussType：业务Code
/// 返回值  :Num
/// 利用d ##Class(web.DHCEQMessages).SetMaintAlertData(Node,Type)方法存的预警数据来统计数量
/// w ##Class(web.DHCEQMessages).GetMaintAlertNum(UserID,"1")
ClassMethod GetMaintAlertNum(Node, BussType)
{
	new Num,EquipID,EquipData,MaintPlanID,str,Num
	d ##Class(web.DHCEQMessages).SetMaintAlertData(Node,BussType)
	s Num=0
	s EquipID=0
	f  s EquipID=$o(^TempDHCEQ("Msg","Alert",Node,BussType,EquipID)) q:EquipID=""   d
	.s EquipData=$g(^DHCEQEquip(EquipID))
	.s EQModelDR=$p(EquipData,"^",3)
	.q:$p(EquipData,"^",38)>"2"
	.q:($p(EquipData,"^",60)="0")||($p(EquipData,"^",60)>"2")
	.quit:"1"=##Class(web.DHCEQCommon).EquipTypeIsIn($p(EquipData,"^",63),GroupID)
	.//quit:("0"=##Class(web.DHCEQCManageLimit).IsInManageLimit("",GroupID,$p(EquipData,"^",63),"","",""))
	.s MaintPlanID=0
	.f  s MaintPlanID=$o(^TempDHCEQ("Msg","Alert",Node,BussType,EquipID,MaintPlanID)) quit:MaintPlanID=""  d
	..s MPModelDR=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",5)
	..q:(MPModelDR'="")&&(EQModelDR'=MPModelDR)		//Add By DJ 2017-02-18	
	..s MaintTypeDR=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",9)
	..s SourceType=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",3)
	..q:(MaintTypeDR=5)&&((SourceType=1)||(SourceType=2))&&($p(EquipData,"^",15)'="Y")   //过滤计量计划中来源为设备分类和设备项的非计量设备 modified by czf 需求号：336771
	..s str=##Class(web.DHCEQMaintPlanNew).WarnDaysNum(MaintPlanID,EquipID)
	..q:$p(str,"^",1)=0
	..q:(BussType="72-1")&&($p($g(^DHCEQMaintPlan(MaintPlanID)),"^",18)="Y")&&($p(EquipData,"^",15)'="Y")  //过滤台账中的计量设备 modified by czf 需求号：336771
	..s Num=Num+1
	k ^TempDHCEQ("Msg","Alert",Node)
	quit Num
}

/// add by zy 2015-11-12
/// 获取当前安全组用户角色要到期的证书数量
/// 参数说明:BussType：业务Code
/// 		 CurDate：与到期日期比较的日期
/// 返回值  :Num
/// 还有问题,证书对应的权限控制没有考虑
/// w ##Class(web.DHCEQMessages).GetCertificateAlertNum("63-1")
ClassMethod GetCertificateAlertNum(BussType, CurDate As %String = "")
{
	new SourceType,SourceID,rowid,DataList,Date,NextDate,Num
	if (BussType="63-1") s SourceType="5"		//modified by czf 2020-12-16 1493492 begin
	if (BussType="63-2") s SourceType="5"
	if (BussType="63-3") s SourceType="4"	;计量证书
	i CurDate="" s CurDate=+$H
	s Num=0
	s SourceID=0
	f  s SourceID=$o(^DHCEQCertificateInfo(0,"Source",SourceType,SourceID)) quit:SourceID=""  d
	.i SourceType=5 d
	..s FirmType=""
	..i BussType="63-1" s FirmType=2
	..e  i BussType="63-2" s FirmType=3
	..s FilterFlag=0
	..s FCRowid=""
	..f  s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,SourceID,FCRowid)) q:(FCRowid="")||(FilterFlag'=0)  d  d
	...q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"
	...s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",SourceID)),"^",19)
	...q:InvalidFlag="Y"
	...s FilterFlag=1
	..q:FilterFlag=0
	..d GetCertificateInfo
	.e  d
	..d GetCertificateInfo
	quit Num
	
GetCertificateInfo
	s rowid=0
	f  s rowid=$o(^DHCEQCertificateInfo(0,"Source",SourceType,SourceID,rowid)) quit:rowid=""  d
	.s DataList=$g(^DHCEQCertificateInfo(rowid))
	.q:$p(DataList,"^",10)="Y"
	.s Date=$p(DataList,"^",7)
	.s NextDate=$p(DataList,"^",8)
    .//add by ZY20230307 bug:3243684
    .i NextDate="" s NextDate=99999
	.q:+(NextDate-CurDate)>30
	.s Num=Num+1
	quit		//modified by czf 2020-12-16 1493492 end
}

/// add by zy 2015-11-12
/// 获取当前安全组用户角色要到期的证书数量
/// 参数说明:GroupID 安全组
/// 		 CurDate：与到期日期比较的日期
/// 返回值  :Num
/// 工作台保修数据改成从ContractList取，modified by czf 需求号：359853
ClassMethod GetGuaranteeAlertNum(GroupID, CurDate)
{
	new Num,Status,MonthNum,EquipID,BeginDate,EndDate,rowid,ContractDR
	s Num=0
	i CurDate="" s CurDate=+$H
	
	s rowid=0                           //add by czf 2017-04-12 begin
	f  s rowid=$o(^DHCEQContract(rowid)) q:rowid=""  d
	.s bussID=rowid
	.s Status= $p($g(^DHCEQContract(rowid)),"^",24)
	.q:Status'=2
	.s ContractType=$p($g(^DHCEQContract(rowid)),"^",39)
	.q:ContractType'=1        //0:采购合同 ； 1：保修合同
    .// MZY0138	2995501		2022-10-13
    .s BeginDate =$p($g(^DHCEQContract(rowid)),"^",49)	;Hold2
    .s EndDate=$p($g(^DHCEQContract(rowid)),"^",50)
	.q:(EndDate-CurDate)>30
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",rowid,CTLRowID)) q:CTLRowID=""  d
	..s SourceType=$p($g(^DHCEQContractList(CTLRowID)),"^",5)
	..s SourceID=$p($g(^DHCEQContractList(CTLRowID)),"^",17)
	..i SourceType=2  d        //保修合同(2：设备)，采购合同(1：计划，2：招标，3：设备项)
	...s EquipID=SourceID
	...i EquipID '="" d
	....s StockStaus=$p($g(^DHCEQEquip(EquipID)),"^",60)
	....q:(StockStaus="0")||(StockStaus>"2")
	....s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
	....q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	....s Num=Num+1                  //add by czf 2017-04-12 end
	
	quit Num
	/*
	//保修开始计算的时间点	0:验收日期  1:入库日期
	s BeginFlag=##class(web.DHCEQCommon).GetSysInfo("990039")
	s BeginFlag=1
	i CurDate="" s CurDate=+$H
	s Num=0
	s Status=""
	f  s Status=$o(^DHCEQEquip(0,"Guarantee",Status)) quit:(Status="")||(Status>2)  d
	.s MonthNum=""
	.f  s MonthNum=$o(^DHCEQEquip(0,"Guarantee",Status,MonthNum)) quit:MonthNum=""  d
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQEquip(0,"Guarantee",Status,MonthNum,EquipID)) quit:EquipID=""  d
	...s (DataList,StartDate,NextDate)=""
	...s DataList=$g(^DHCEQEquip(EquipID))
	...q:($p(DataList,"^",60)="0")||($p(DataList,"^",60)>"2")
	...quit:"1"=##Class(web.DHCEQCommon).EquipTypeIsIn($p(DataList,"^",63),GroupID)
	...//quit:("0"=##Class(web.DHCEQCManageLimit).IsInManageLimit("",GroupID,$p(EquipData,"^",63),"","",""))
	...s InvalidFlag=$p(DataList,"^",59)   //modified by czf 需求号：326945
	...q:InvalidFlag="Y"
	...s StartDate=$p(DataList,"^",12)
	...i BeginFlag=1 s StartDate=$p(DataList,"^",45)
	...s NextDate=##class(web.DHCEQCommon).DateAdd("M",MonthNum,$ZD(StartDate,4))
	...;s NextDate=$ZDH(NextDate,4)
	...;日期格式统一调整
	...s NextDate=##Class(web.DHCEQCommon).TransValueFromPage(NextDate,"date")
	...s (rowid,ContractDR,SignDate,MaxDate,MaxContractDR,SCFlag)=0
	...f  s rowid=$o(^DHCEQServiceContract(0,"Equip",EquipID,rowid))  quit:rowid=""  d
	....s ContractDR=$P($g(^DHCEQServiceContract(rowid)),"^",2)
	....s SignDate=$P($g(^DHCEQContract(ContractDR)),"^",7)
	....i SignDate>MaxDate d
	.....s MaxContractDR=ContractDR
	.....s MaxDate=SignDate
	.....s SCFlag=1
	...i MaxContractDR>0 s LastDate=$p($g(^DHCEQContract(MaxContractDR)),"^",11)
	...i MaxContractDR>0 s NextDate=$p($g(^DHCEQContract(MaxContractDR)),"^",12)
	...q:((SCFlag=0)&&(MonthNum=0))		//Add By DJ 2016-04-18
	...q:(NextDate-CurDate)>30
	...s Num=Num+1
	
	quit Num
	*/
}

/// add by zy 2015-11-12
/// 获取当前安全组用户角色要到期的租借设备
/// 参数说明:GroupID 安全组
/// 		 CurDate：与到期日期比较的日期
/// 返回值  :Num
/// w ##Class(web.DHCEQMessages).GetRentAlertNum(217)
ClassMethod GetRentAlertNum(GroupID, CurDate, CurLocDR As %String = "")
{
	new Num,rowid,DataList,EquipID,EquipTypeDR,StartDate,StartTime,PlanEndDate,PlanEndTime
	i CurLocDR="" s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s Num=0
	s rowid=""
	f  s rowid=$o(^DHCEQRent(0,"Status",2,rowid)) quit:rowid=""  d
	.s (DataList,EquipID,EquipTypeDR,StartDate,StartTime,PlanEndDate,PlanEndTime)=""
	.s DataList=$g(^DHCEQRent(rowid))
	.s EquipID=$p(DataList,"^",9)
	.s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
	.quit:"1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID)
	.s TRequestLocDR=$p(DataList,"^",2)
	.s TFromLocDR=$p(DataList,"^",3)
	.q:(TRequestLocDR'=CurLocDR)&&(TFromLocDR'=CurLocDR)
	.s StartDate=$p(DataList,"^",10)
	.s StartTime=$p(DataList,"^",11)
	.s PlanEndDate=$p(DataList,"^",12)
	.s PlanEndTime=$p(DataList,"^",13)
	.q:(PlanEndDate-CurDate)>1
	.s Num=Num+1
	
	quit Num
}

/// add by zy 2015-11-12
/// 获取当前安全组用户角色要监控的维修记录
/// 参数说明:GroupID 安全组
/// 返回值  :Num
/// w ##Class(web.DHCEQMessages).GetMaintMonitorNum(217)
ClassMethod GetMaintMonitorNum(GroupID, Busscode, CurUserID)
{
	new rowid,DataList,Num
	i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s (rowid,Num,StatusDR)=0
	f  s StatusDR=$o(^DHCEQMMaintRequest(0,"Status",StatusDR))  q:StatusDR=""  d
	.q:StatusDR'=1		//暂时默认只取提交状态单据
	.s rowid=0
	.f  s rowid=$o(^DHCEQMMaintRequest(0,"Status",StatusDR,rowid))  quit:rowid=""  d
	..s DataList=$g(^DHCEQMMaintRequest(rowid))
	..q:($p(DataList,"^",57)="Y")
	..s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(31,rowid,"")
	..s EquipTypeDR=$p(ApproveInfo,"^",10)
	..s StatCatDR=$p(ApproveInfo,"^",11)
	..s EquipCatDR=$p(ApproveInfo,"^",12)
	..s LocDR=$p(ApproveInfo,"^",9)
	..s EquipID=$p(ApproveInfo,"^",14)
	..s ItemDR=$p(ApproveInfo,"^",13)
	..s Roles=""	
	..;s EquipTypeDR=$p(DataList,"^",3)
	..;s UseLoc=$p(DataList,"^",6)
	..quit:"1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID)
	..//判断当前用户是否可以查看这个维修单据;
	..//先根据维修组看当前用户可管理的用户有哪儿些,然后看看每个用户的权限.
	..s Flag=1		//无权限操作
	..i Busscode="81"  d
	...s UserIDs=##Class(web.DHCEQMCMaintGroup).GetMemberUser(CurUserID,"1")
	...s Len=$L(UserIDs,",")
	...f i=1:1:Len  d
	....q:Flag=0
	....s UserID=$p(UserIDs,",",i)
	....s Flag=##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,Roles,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)
	..e  d
	...s Flag=0
	..q:Flag'=0
	..s Num=Num+1
	
	quit Num
}

/// add by zy 2015-11-12
/// 取当前预警设备的总数量
/// 参数说明:node：临时golable存储的节点
/// 				BussType :1,保养;2,检查
/// 返回值  :""  
///      数据存在golable中:格式如下:^TempDHCEQ("Msg","Alert",node,BussType,EquipID,MaintPlanID)=""
/// w ##Class(web.DHCEQMessages).SetMaintAlertData(UserID,"1")
ClassMethod SetMaintAlertData(node, BussType)
{
	new SourceType,sourceid,rowid,DataList,Model,EquipID
	
	if (BussType="71") s MaintType="1"
	if ((BussType="72-1")||(BussType="72-2")) s MaintType="2"
	k ^TempDHCEQ("Msg","Alert",node)
	
#;	s rowid=0
#;	f  s rowid=$o(^DHCEQMaintPlan(0,"Type",MaintType,rowid))  q:rowid=""  d
#;	.s DataList=$g(^DHCEQMaintPlan(rowid))
#;	.q:$p(DataList,"^",26)'="2"			//Add By DJ 2017-02-18
#;	.q:$p(DataList,"^",36)="Y"
#;	.s MaintTypeDR=$p(DataList,"^",9)		//Add By DJ 2015-12-28
#;	.i ((MaintType=2)&&(MaintTypeDR=5)) s BussType="72-1"
#;	.i ((MaintType=2)&&(MaintTypeDR=4)) s BussType="72-2"
#;	.s MPEquipIDs=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips(2,rowid)
#;	.s Count=$l(MPEquipIDs,",")
#;	.s i=0
#;	.f i=1:1:Count  d
#;	..s EquipID=$p(MPEquipIDs,",",i)
#;	..s ^TempDHCEQ("Msg","Alert",node,BussType,EquipID,rowid)=""
#;	quit ""
	//以下为旧版
	s SourceType=0
	f  s SourceType=$o(^DHCEQMaintPlan(0,"SourceType",MaintType,SourceType))  quit:SourceType=""  d
	.s sourceid=0
	.f  s sourceid=$o(^DHCEQMaintPlan(0,"SourceType",MaintType,SourceType,sourceid))  quit:sourceid=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQMaintPlan(0,"SourceType",MaintType,SourceType,sourceid,rowid))  quit:rowid=""  d
	...s DataList=$g(^DHCEQMaintPlan(rowid))
	...q:$p(DataList,"^",26)'="2"			//Add By DJ 2017-02-18
	...q:$p(DataList,"^",36)="Y"
	...s MaintTypeDR=$p(DataList,"^",9)		//Add By DJ 2015-12-28
	...i ((MaintType=2)&&(MaintTypeDR=5)) s BussType="72-1"
	...i ((MaintType=2)&&(MaintTypeDR=4)) s BussType="72-2"
	...s Model=$p(DataList,"^",5)
	...i SourceType=1  d
	....d SetEquipCatData
	...e  i SourceType=2  d
	....d SetItemData
	...e  i SourceType=3  d
	....d SetEquipData
	quit ""
	
SetEquipCatData
	s EquipCatStr=##Class(web.DHCEQCEquipeCat).GetChildIDsByCatID(sourceid)
	s Len=$l(EquipCatStr,"^")
	s i=0
	f i=1:1:Len  d
	.s ChildsSourceID=$p(EquipCatStr,"^",i)
	.s StoreLocID=0
	.f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID)) quit:StoreLocID=""  d
	..s EquipID=0
	..f  set EquipID=$order(^DHCEQEquip(0,"StoreLocEquipCat",StoreLocID,ChildsSourceID,EquipID))  quit:EquipID=""  d
	...s ^TempDHCEQ("Msg","Alert",node,BussType,EquipID,rowid)=""
	q 
SetItemData
	s StoreLocID=0
	f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID)) quit:StoreLocID=""  d
	.s EquipID=0
	.f  s EquipID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID,sourceid,EquipID))  quit:EquipID=""  d
	..s ^TempDHCEQ("Msg","Alert",node,BussType,EquipID,rowid)=""
	;..s TempData=$g(^TempDHCEQ("Msg","Alert",node,BussType,EquipID,rowid))
	;..s ModelFlag=$p(TempData,"^",2)
	;..q:(ModelFlag="Y")&&(Model="")	//保留原来有型号的计划ID
	;..i (ModelFlag="")&&(Model="")  d
	;...s ^TempDHCEQ("Msg","Alert",node,BussType,EquipID)=rowid	//没有型号的计划取最近的
	;..e  d
	;...s ^TempDHCEQ("Msg","Alert",node,BussType,EquipID)=rowid_"^Y"	//有型号的计划取最近的
	q 
SetEquipData
    s ^DHCEQTemp("Msg","Alert",node,BussType,sourceid,rowid)=""
	q
}

// modify by lmm 355243

/// Modified by JDL 2016-1-20 18:00 begin,重新梳理 修改中。。。。。
/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
///       RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetBussDataByCode","11","85","1","131","")
Query GetBussDataByCode(BussType As %String = "", GroupID As %String = "", UserID As %String = "", CurLocDR As %String = "", EquipDR As %String = "") As %Query(ROWSPEC = "bussType:%String,bussID:%String,msgID:%String,equipTypeDR:%String,equipType:%String,sendUser:%String,sendDate:%String,no:%String,name:%String,requestLoc:%String,date:%String,useLoc:%String,fromLoc:%String,toLoc:%String,moveType:%String,outType:%String,contractNo:%String,bStatus:%String,Row:%String,roles:%String,actionDesc:%String,actionCode:%String,lastoperate:%String,model:%String,equipNo:%String,fileNo:%String,TWaringFlag:%String,GuaranteeFlag:%String,startDate:%String,planEndDate:%String,ApproveSetDR:%String,BussTypeID:%String")
{
}

ClassMethod GetBussDataByCodeExecute(ByRef qHandle As %Binary, BussType As %String = "", GroupID As %String = "", UserID As %String = "", CurLocDR As %String = "", EquipDR As %String = "") As %Status
{
	new repid, index,rowid	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	new ApproveType,BussTypeID,ApproveInfo
 	new EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,LocDR,EquipID
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurLocDR="" s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
 	s CurRoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID) 
 	i (GroupID="")||(UserID="")||(BussType="")||(CurRoleIDs="") Quit $$$OK
 	s ApproveType=##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)  //add by zx 2016-12-28 根据业务类型获取审批类型 ZX0036
 	
 	s index=1
 	s Row=0
 	s MsgID=0
 	f  s MsgID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID)) q:MsgID=""  d
 	.d ResetVariablesRowGetBussDataByCode
 	.//判断消息的可处理角色和当前角色是否符合
 	.s PassFlag=0
 	.s ActionIDs=""
 	.//add by zx 2017-03-01 begin
 	.;s MRIRowID=0
 	.;f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID,MRIRowID)) q:(MRIRowID="")  d  //||(PassFlag=1)
 	.;.s Roles=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",4)
 	.;.q:Roles=""
 	.;.s ActionIDs=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",10)
 	.;.s Len=$L(Roles,",")
	.;.f i=1:1:Len  d
	.;..;q:PassFlag=1
	.;..s Role=$p(Roles,",",i)
	.;..q:(Role'="")&&((","_CurRoleIDs_",")'[(","_Role_","))	; s PassFlag=1 
	.;..i $p(ActionIDs,",",i)'="" d
	.;...i $p(ActionIDs,",",i)'="0"  d		//Add By DJ 2016-05-23
	.;....s ActionDesc=ActionDesc_$p($g(^DHCEQCCode("DHCEQCAction",$p(ActionIDs,",",i))),"^",2)_","
	.;....s ActionCode=ActionCode_$p($g(^DHCEQCCode("DHCEQCAction",$p(ActionIDs,",",i))),"^",1)_","
	.;...e  d
	.;....s ActionDesc=ActionDesc_"提交,"
	.;....s ActionCode=ActionCode_"Submit,"
	.;..e  d
	.;...s ActionDesc=ActionDesc_","
	.;...s ActionCode=ActionCode_","
	.;q:ActionDesc=""
	.;q:PassFlag=1
    	.s PassFlag=##Class(web.DHCEQMessages).CheckMessageRoles(GroupID,UserID,MsgID,CurRoleIDs) //Bug ZX0045
	.q:$p(PassFlag,"^",1)=0
	.s ActionDesc=$p(PassFlag,"^",3)
	.s ActionCode=$p(PassFlag,"^",2)
	.s ActionIDs=$p(PassFlag,"^",4)
	.s Roles=$p(PassFlag,"^",5)
	.//add by zx 2017-03-01 end
	.s DataList=$g(^DHCEQMessages(MsgID))
 	.q:$p(DataList,"^",14)'="1"
 	.q:$p(DataList,"^",21)="Y"
	.s BussTypeID=$p(DataList,"^",10)
    	.q:(BussType'="")&(BussTypeID'=BussType)  //BUG ZX 0045 
	.s BussID=$p(DataList,"^",11)
    	.q:(EquipDR'="")&&(##Class(web.DHCEQMessages).CheckEquipIsInBuss(BussTypeID,BussID,EquipDR)=0)  //modified by czf
    	.s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussTypeID,BussID)
	.q:(($p(BussInfo,"^",3)'=CurLocDR)&&($p(BussInfo,"^",6)'=CurLocDR))&&(BussTypeID="64")      //add by jyp 355232
	.q:(($p(BussInfo,"^",29)-(+$h))>1)&&(BussTypeID="64")    //add by lmm 355232
	.q:($p(BussInfo,"^",12)'=2)&&(BussTypeID="64")
	.q:($p(BussInfo,"^",12)=2)&&(BussTypeID'="64")		//BussStatus  add by zx 2016-11-17 租赁审核状态处理 ZX0036
	.q:$p(BussInfo,"^",13)="Y"		//BussInvalidFlag
	.
	.//取当前业务审批信息,获取限制条件,以便后面查看用户是否有权限收消息
	.s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(BussType,BussID,"")
	.//EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR
	.s EquipTypeDR=$p(ApproveInfo,"^",10)
	.q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"","2")) //add by zx 2017-03-20 BUG ZX0036
	.s StatCatDR=$p(ApproveInfo,"^",11)
	.s EquipCatDR=$p(ApproveInfo,"^",12)
	.s LocDR=$p(ApproveInfo,"^",9)
	.s EquipID=$p(ApproveInfo,"^",14)
    	.s ApproveSetDR=$p(ApproveInfo,"^",3)  //add by zx 2017-06-20 BUG ZX0045 微信端approveset获取
	.i EquipID'="" d
	..s ModelID=$p($g(^DHCEQEquip(EquipID)),"^",3)
	..i ModelID'="" s Model=$p($g(^DHCEQCCode("DHCEQCModel",ModelID)),"^",2)
	..s GuaranteeEndDate=$p($g(^DHCEQEquip(EquipID)),"^",51)  //add by zx 2017-01-05 增加保修内标志 ZX0036
	..;s ^DHCEQZX(EquipID)=GuaranteeEndDate
	..s GuaranteeFlag=0
	..i +GuaranteeEndDate>+$h s GuaranteeFlag=1  
	.s ItemDR=$p(ApproveInfo,"^",13)
	.s CancelToUser=$p(ApproveInfo,"^",19)
	.s AssignDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Assign",0))_","			//派单动作DR	//Add By DJ  2016-05-25 begin
	.s EvaluateDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Evaluate",0))_","		//组长审核动作DR
	.s LeaderFlag=$D(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",1,UserID))		//是否维修组长
	.s PersonelFlag=0  //add by jdl 2017-01-11
	.if (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Accept",0))_",")  d
	..s PersonelFlag=1
	.else  if (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Audit",0))_",")  d
	..s PersonelFlag=1
	.else  if (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Finish",0))_",")  d
	..s PersonelFlag=1
	.s CMLReturn=0
	.i ('((LeaderFlag)&&(((","_ActionIDs_",")[AssignDR)||((","_ActionIDs_",")[EvaluateDR))))&&(PersonelFlag'=1)  d		//不满足既是维修组长并且消息动作权限包含派单或组长审核动作
	..s CMLReturn=##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,Roles,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)
 	.q:CMLReturn'=0
 	.;q:##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,Roles,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)	//Add By DJ 2016-05-25 end
	.//Add by QW 2019-08-31 多方审批
	.Quit:##Class(web.DHCEQ.EM.LIBMultipleApproveInfo).ISMultipleDone(ApproveSetDR,BussID,CurRoleIDs,ApproveType,$p(ApproveInfo,"^",5))'=0
	.//End by QW 2019-08-31 多方审批
	.s No=$p(BussInfo,"^",1)
	.s Name=$p(BussInfo,"^",2)
	.s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",3))
	.//Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo
	.;s Date=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",4),"date")
	.;s Date=$zd($p(BussInfo,"^",4),3)	;Mozy	2016-11-24
	.;日期格式统一调整
	.s Date=##Class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",4),"date")	;Mozy	2016-11-24
	.s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",5))
	.s FromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",6))
	.s ToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",7))
	.s MoveType=$p(BussInfo,"^",8)
	.s OutType=$p(BussInfo,"^",9)
	.s ContractNo=$p(BussInfo,"^",10)
	.s BStatus=$p(BussInfo,"^",14)
	.s LastHandler=$p(BussInfo,"^",20)  //add by wsp 2016-3-22
	.s LastOperate=$p(BussInfo,"^",21) //add by wsp 2016-4-1 最后一次操作
	.s BStatus=LastHandler_$p(BussInfo,"^",14)  //modified by wsp 2016-3-22 状态列添加操作人信息
	.s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	.s SendUserDR=$p(DataList,"^",9)
	.
	.s SendUser= ##Class(web.DHCEQCommon).GetTrakNameByID("user",SendUserDR)
	.s SendDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",10),"date")
	.s SendTime=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",11),"time")
	.s SendDate=SendDate_" "_SendTime
	.s equipNo=$p(BussInfo,"^",23)  //add by zx 2016-12-13 获取设备编号字段 ZX0036
	.s fileNo=$p(BussInfo,"^",24)
	.s startDate=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",28),"date")  //add by lmm 355243
	.s planEndDate=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",29),"date")  //add by lmm 355243
	.s TWaringFlag=+##Class(web.DHCEQPrescription).GetPrescriptionInfo(ApproveType,BussID) //add by zx 2016-12-28  时效标志 ZX0036
	.d OutputRowGetBussDataByCode
	Quit $$$OK
ResetVariablesRowGetBussDataByCode
    s (DataList,EquipTypeDR,EquipType,SendUserDR,SendUser,SendDate,SendTime,BussInfo,No,Name,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BStatus,Roles,ActionIDs,ActionDesc,ActionCode,LastOperate,ModelID,Model,equipNo,fileNo,TWaringFlag,GuaranteeFlag,startDate,planEndDate,ApproveSetDR,BussTypeID)=""
    quit
OutputRowGetBussDataByCode
    Set Row=Row+1
    set Data=$lb(BussType,BussID,MsgID,EquipTypeDR,EquipType,SendUser,SendDate,No,Name,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BStatus,Row,Roles,ActionDesc,ActionCode,LastOperate,Model,equipNo,fileNo,TWaringFlag,GuaranteeFlag,startDate,planEndDate,ApproveSetDR,BussTypeID)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetBussDataByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussDataByCodeExecute ]
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

ClassMethod GetBussDataByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussDataByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// BussType:11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用、51设备调帐、A01配件入库、A02配件转移、A03配件退货、A04配件减少
/// w ##Class(web.DHCEQMessages).GetBussInfo("31",2,20)
ClassMethod GetBussInfo(BussType, BussID)
{
	//add by wy 2020-8-25 1453205 取设备原值串OriginalFee
	new No,BussIDList,Name,EquipID,ExObjDR,ObjLocDR,SourceTypeDR,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BussStatus,BussInvalidFlag,BStatus,LastHandlerDR,LastHandler,BussAuditDate,RequestUser,FaultCase,StartDate,planEndDate,SaveCostFee,AcceptUserDR,OriginalFee,HospDR  //Add by zc0125 2022-12-8 初始化HospDR
	s (No,BussIDList,Name,EquipID,ExObjDR,ObjLocDR,SourceTypeDR,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BussStatus,BussInvalidFlag,BStatus,LastHandlerDR,LastHandler,BussAuditDate,RequestUser,FaultCase,StartDate,planEndDate,SaveCostFee,AcceptUserDR,OriginalFee,HospDR)=""   //Add by zc0125 2022-12-8 初始化HospDR
	
	new EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,EquipNo,FileNo,EmergencyFlag,SeverityFlag,Time //add by zx 2022-09-01 增加紧急标志和申请时间
	s (EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,ApproveUser,ApproveUserDR,EquipNo,FileNo,Model,EmergencyFlag,SeverityFlag,Time)=""
	
	//Add by wsp 2016-4-1 添加最后一次动作
	s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType) //add by zx 2016-11-25 上一步审批信息获取调整 ZX0036
	s LastOperate=##Class(web.DHCEQApproveList).GetLastApproveListOpinion(ApproveType,BussID)
	s LastOperate=$p(LastOperate,"^",2)_$p(LastOperate,"^",3)_" "_$p(LastOperate,"^",4)
	/*
	s ApproveListID=$O(^DHCEQApproveList(0,"Source",ApproveType,BussID,""),-1)
	s ApproveDate=$P(^DHCEQApproveList(ApproveListID),"^",7)  ;
	i ApproveDate '="" s ApproveDate=$zd(ApproveDate,3)  ;日期
	i ApproveListID'="" s ApproveUserDR=$P(^DHCEQApproveList(ApproveListID),"^",6)  ;Add By DJ 2016-04-20
	i ApproveUserDR'="" s ApproveUser=$P($g(^SSU("SSUSR",ApproveUserDR)),"^",2)  ;操作人
	s ApproveAction=""		//Add By DJ 2016-04-05
	i ApproveListID'=""  d
	.s ApproveActionDR=$P(^DHCEQApproveList(ApproveListID),"^",11)  ;
	.i ApproveActionDR'="" s ApproveAction=$P(^DHCEQCCode("DHCEQCAction",ApproveActionDR),"^",2)  ;动作
	;s ApproveAction=$E(ApproveAction,1,2) //add by zx 2016-11-24
	i ApproveAction="" s ApproveAction="审核"
	s LastOperate=ApproveDate_","_ApproveUser_","_ApproveAction
	//end by wsp
	*/
	
	if BussType="11"
	{
		s Date=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",10)      //modified by czf 需求号：354959
		s No=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",37)
		s BussStatus=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",20)
		s BussInvalidFlag=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",45)
		s BussIDList=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",BussID,0))
		s Name=$p($g(^DHCEQOpenCheckList(BussIDList)),"^", 2)
		s UseLoc = $p($g(^DHCEQOpenCheckList(BussIDList)),"^",33)  //使用科室
		
		s EquipTypeDR=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",2)
		s StatCatDR=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",4)
		s EquipCatDR=$p($g(^DHCEQOpenCheckList(BussIDList)),"^", 6)
		s ItemDR=$p($g(^DHCEQOpenCheckList(BussIDList)),"^", 9)
		s BussAuditDate=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",26)
		s HospDR=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",38)		//czf 2021-09-02
	}
	elseif BussType="21"
	{
		s Date=$p($g(^DHCEQInStock(BussID)),"^",1)
		s No=$p($g(^DHCEQInStock(BussID)),"^",14)
		s BussStatus=$p($g(^DHCEQInStock(BussID)),"^",10)
		s BussInvalidFlag=$p($g(^DHCEQInStock(BussID)),"^",25)
		s BussIDList=$o(^DHCEQInStockList(0,"InStock",BussID,0))
		s Name=$p($g(^DHCEQInStockList(BussIDList)),"^", 5)_"..."
		
		s EquipTypeDR=$p($g(^DHCEQInStock(BussID)),"^",20)
		s StatCatDR=$p($g(^DHCEQInStock(BussID)),"^",21)
		s BussAuditDate=$p($g(^DHCEQInStock(BussID)),"^",13)
		s LocDR=$p($g(^DHCEQInStock(BussID)),"^",2)		//czf 2021-09-02
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)
		;s EquipCatDR=
		;s ItemDR=
	}
	elseif BussType="22"
	{
		//start by csj 2020-05-07 修改此处影响较大，还原为原来的程序
		s No=$p($g(^DHCEQStoreMove(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQStoreMove(BussID)),"^",13)
		s BussInvalidFlag=$p($g(^DHCEQStoreMove(BussID)),"^",27)
		s FromLoc = $p($g(^DHCEQStoreMove(BussID)),"^",2)
		s ToLoc  = $p($g(^DHCEQStoreMove(BussID)),"^",3)
		s Date=$p($g(^DHCEQStoreMove(BussID)),"^",5)
		s MoveType =$CASE($p($g(^DHCEQStoreMove(BussID)),"^",12),"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配",:"没有定义")
		s BussIDList=$o(^DHCEQStoreMoveList(0,"StoreMove",BussID,0))
		s Name=$p($g(^DHCEQStoreMoveList(BussIDList)),"^", 5)_"..."
		
		s EquipTypeDR=$p($g(^DHCEQStoreMove(BussID)),"^",16)
		s StatCatDR=$p($g(^DHCEQStoreMove(BussID)),"^",17)
		s BussAuditDate=$p($g(^DHCEQStoreMove(BussID)),"^",19)
		//end by csj 2020-05-07
		;s EquipCatDR=
		;s ItemDR=
		//Modify by zx 2020-11-25
		s LastHandlerDR=$p($g(^DHCEQStoreMove(BussID)),"^",4)
		i LastHandlerDR'="" s LastHandler=##class(web.DHCEQCommon).GetTrakNameByID("user",LastHandlerDR)
		s UseLoc=FromLoc
		//add by zx 2020-01-11
		s RequestUser=$p($g(^DHCEQStoreMove(BussID)),"^",4)	
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(ToLoc) //czf 2021-09-02
	}
	elseif BussType="23"
	{
		s No=$p($g(^DHCEQReturn(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQReturn(BussID)),"^",13)
		s BussInvalidFlag=$p($g(^DHCEQReturn(BussID)),"^",28)
		s Date=$p($g(^DHCEQReturn(BussID)),"^",4)
		s OutType=$p($g(^DHCEQCCode("DHCEQCOutType",$p($g(^DHCEQReturn(BussID)),"^",17))),"^",2)
		s BussIDList=$o(^DHCEQReturnList(0,"Return",BussID,0))
		s EquipID=$p($g(^DHCEQReturnList(BussIDList)),"^", 4)
		i EquipID'="" d
		.s Name=$p($g(^DHCEQEquip(EquipID)),"^", 1)_"..."
		e  d
		.s InStockListDR=$p($g(^DHCEQReturnList(BussIDList)),"^", 3)     //modified by czf 371062
		.i InStockListDR'="" s Name=$p($g(^DHCEQInStockList(InStockListDR)),"^", 5)_"..."
		s EquipTypeDR=$p($g(^DHCEQReturn(BussID)),"^",15)
		s StatCatDR=$p($g(^DHCEQReturn(BussID)),"^",16)
		s BussAuditDate=$p($g(^DHCEQReturn(BussID)),"^",11)
		s LocDR=$p($g(^DHCEQReturn(BussID)),"^",2)		//czf 2021-09-02
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)
		;s EquipCatDR=
		;s ItemDR=
	}
	elseif BussType="31"
	{
		s No=$p($g(^DHCEQMMaintRequest(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQMMaintRequest(BussID)),"^",41)
		s LastHandlerDR=$CASE(BussStatus,0:$p($g(^DHCEQMMaintRequest(BussID)),"^",42),1:$p($g(^DHCEQMMaintRequest(BussID)),"^",48),2:$p($g(^DHCEQMMaintRequest(BussID)),"^",51),3:$p($g(^DHCEQMMaintRequest(BussID)),"^",54),4:$p($g(^DHCEQMMaintRequest(BussID)),"^",26))  //modified by zyq 2022-12-15
		i LastHandlerDR'="" s LastHandler=##class(web.DHCEQCommon).GetTrakNameByID("user",LastHandlerDR)  //Modify by zx 2020-11-25  //$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)  //add by wsp 增加最后操作人的信息2016-3-22
		s BStatus=##Class(web.DHCEQM.DHCEQMMaintRequest).GetStatus(BussStatus)
		s BussInvalidFlag=$p($g(^DHCEQMMaintRequest(BussID)),"^",57)
		s SaceCostFee=$p($g(^DHCEQMMaintRequest(BussID)),"^",71)  //预计维修费用
		s RequestLoc=+$p($g(^DHCEQMMaintRequest(BussID)),"^",7)
		s AcceptUserDR=+$p($g(^DHCEQMMaintRequest(BussID)),"^",26) //Add By QW20200604 BUG:QW0065
		s Date=$p($g(^DHCEQMMaintRequest(BussID)),"^",18)
		s Time=$p($g(^DHCEQMMaintRequest(BussID)),"^",19)  //Modify by zx 2022-09-01
		s ExObjDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",5)
		s SourceTypeDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",63)
		i ExObjDR'="" d
		.i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)  d  //add by zx 2017-03-20 BUG ZX0036 modified by wy 2022-4-13
		..s EquipID=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
		..i EquipID'="" s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)		
		.e  d
		..s Name=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",1)   //modified by wy 2022-10-17
		s UseLoc=$p($g(^DHCEQMMaintRequest(BussID)),"^",6)
		s BussAuditDate=$p($g(^DHCEQMMaintRequest(BussID)),"^",52)
		i $p($g(^DHCEQMMaintRequest(BussID)),"^",79)'="" s Name=Name_"("_$p($g(^DHCEQAffix($p($g(^DHCEQMMaintRequest(BussID)),"^",79))),"^",4)_")"    // Add By zc2022-4-8
		//add by zx 2017-02-27
		s RequestUser=$p($g(^DHCEQMMaintRequest(BussID)),"^",20)
		i RequestUser'="" s RequestUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", RequestUser)
		s Tel=$p($g(^DHCEQMMaintRequest(BussID)),"^",21)
		i Tel'="" s RequestUser=RequestUser_"("_Tel_")"
		s FaultCase=$p($g(^DHCEQMMaintRequest(BussID)),"^",10)
		i FaultCase'="" s FaultCase=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FaultCase)),"^",2)
		s FaultCaseRemark=$p($g(^DHCEQMMaintRequest(BussID)),"^",11)
		i FaultCase'="" d
		.i FaultCaseRemark'="" s FaultCase=FaultCase_"("_FaultCaseRemark_")"
		e  d
		.s FaultCase=FaultCaseRemark
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(UseLoc)	//czf 2021-09-02
                i $p($g(^DHCEQMMaintRequest(BussID)),"^",61)="2" d   // Add By zc2022-4-8
		.s EmergencyFlag="Y"
		e  d
		.s EmergencyFlag="N"
		i $p($g(^DHCEQMMaintRequest(BussID)),"^",62)="2" d   // Add By zc2022-4-8
		.s SeverityFlag="Y"
		e  d
		.s SeverityFlag="N"
		
		i EquipID'=""  d SetEquipInfo
	}
	elseif BussType="34"
	{
		s Date=$p($g(^DHCEQDisuseRequest(BussID)),"^",4)
		s BussStatus=$p($g(^DHCEQDisuseRequest(BussID)),"^",10)
		s BussInvalidFlag=$p($g(^DHCEQDisuseRequest(BussID)),"^",53)
		s No=$p($g(^DHCEQDisuseRequest(BussID)),"^",33)
		s RequestLoc=$p($g(^DHCEQDisuseRequest(BussID)),"^",3)
		s EquipID=+##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(BussID)
		i EquipID'="" s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)_"..."	
		i EquipID'="" s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQEquip(EquipID)),"^",27),"")_"..."  //add by wy 2020-8-25 1453205 取设备原值串		
		s BussAuditDate=$p($g(^DHCEQDisuseRequest(BussID)),"^",21)
		//Modify by zx 2020-11-25
		s UseLoc=$p($g(^DHCEQDisuseRequest(BussID)),"^",34)
		s RequestUser=$p($g(^DHCEQDisuseRequest(BussID)),"^",17)
		;i RequestUser'="" s RequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",RequestUser)
		s LastHandlerDR=$p($g(^DHCEQDisuseRequest(BussID)),"^",17)
		i LastHandlerDR'="" s LastHandler=##class(web.DHCEQCommon).GetTrakNameByID("user",LastHandlerDR)
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(UseLoc)	//czf 2021-09-02
		i EquipID'=""  d SetEquipInfo
	}
	elseif BussType="91"
	{
		s Date=$p($g(^DHCEQBuyRequest(BussID)),"^",6)
		s BussStatus=$p($g(^DHCEQBuyRequest(BussID)),"^",16)
		s BussInvalidFlag=$p($g(^DHCEQBuyRequest(BussID)),"^",45)
		s No=$p($g(^DHCEQBuyRequest(BussID)),"^",35)
		s RequestLoc=$p($g(^DHCEQBuyRequest(BussID)),"^",2)
		///add 20191012 by zy 增加控制
		s EquipTypeDR=$p($g(^DHCEQBuyRequest(BussID)),"^",25)
		s BussIDList=$o(^DHCEQBuyRequestList(0,"BuyRequest",BussID,0))
		i BussIDList'="" s Name=$p($g(^DHCEQBuyRequestList(BussIDList)),"^", 2)
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(RequestLoc)	//czf 2021-09-02
		;s StatCatDR=
		;s EquipCatDR=
		;s ItemDR=
	}
	elseif BussType="92"
	{
		s Date=$p($g(^DHCEQBuyPlan(BussID)),"^",5)
		s BussStatus=$p($g(^DHCEQBuyPlan(BussID)),"^",6)
		s BussInvalidFlag=$p($g(^DHCEQBuyPlan(BussID)),"^",46)
		s No=$Piece($Get(^DHCEQBuyPlan(BussID)),"^",25)
		s BussIDList=$o(^DHCEQBuyPlanList(0,"BuyPlan",BussID,0))
		s Name=$p($g(^DHCEQBuyPlanList(BussIDList)),"^", 2)
		
		s EquipTypeDR=$p($g(^DHCEQBuyPlan(BussID)),"^",12)
		s RequestLoc=$p($g(^DHCEQBuyPlan(BussID)),"^",39)	;管理科室
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(RequestLoc)	//czf 2021-09-02
		;s StatCatDR=
		;s EquipCatDR=
		;s ItemDR=
	}
	elseif BussType="93"
	{
		s No=$p($g(^DHCEQIFB(BussID)),"^",3)
		s BussStatus=$p($g(^DHCEQIFB(BussID)),"^",43)
		s BussInvalidFlag="N"
		s Name=$p($g(^DHCEQIFB(BussID)),"^",1)
		s StartDate=$p($g(^DHCEQIFB(BussID)),"^",28)	;招标开始日期
		s planEndDate=$p($g(^DHCEQIFB(BussID)),"^",25)	;招标结束日期
		s Date=$p($g(^DHCEQIFB(BussID)),"^",38)
		s RequestLoc=$p($g(^DHCEQIFB(BussID)),"^",34)	;管理科室
		s UseLoc=$p($g(^DHCEQIFB(BussID)),"^",50)		;使用科室  czf 2021-05-22 1890577
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(RequestLoc)	//czf 2021-09-02
	}
	elseif BussType="94"
	{
		s No=$p($g(^DHCEQContract(BussID)),"^",2)
		s BussStatus=$p($g(^DHCEQContract(BussID)),"^",24)
		s BussInvalidFlag="N"
		s ContractNo=$p($g(^DHCEQContract(BussID)),"^",2)
		s Name=$p($g(^DHCEQContract(BussID)),"^",1)
		s RequestLoc=$p($g(^DHCEQContract(BussID)),"^",51)	;管理科室 czf 2021-05-22 1890577
		s Date=$p($g(^DHCEQContract(BussID)),"^",7)			;签订日期
		s SignLoc=$p($g(^DHCEQContract(BussID)),"^",8)		;签订科室
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(SignLoc)	//czf 2021-09-02
	}
	elseif BussType="61"
	{
		s No=$p($g(^DHCEQProject(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQProject(BussID)),"^",10)
		s BussInvalidFlag=$p($g(^DHCEQProject(BussID)),"^",24)
		s Name=$p($g(^DHCEQProject(BussID)),"^",2)
	}
	elseif BussType="62"
	{
		s No=$p($g(^DHCEQIssue(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQIssue(BussID)),"^",12)
		s BussInvalidFlag=$p($g(^DHCEQIssue(BussID)),"^",26)
		s Name=$p($g(^DHCEQIssue(BussID)),"^",2)
	}
	elseif BussType="A01" //配件入库
	{
		s Date=$p($g(^DHCEQAInStock(BussID)),"^",1)
		s No=$p($g(^DHCEQAInStock(BussID)),"^",6)
		s BussStatus=$p($g(^DHCEQAInStock(BussID)),"^",16)
		s BussInvalidFlag="N"
		s RequestLoc=$p($g(^DHCEQAInStock(BussID)),"^",3)
		s BussIDList=$o(^DHCEQAInStockList(0,"AInStock",BussID,0))
		s Name=$p($g(^DHCEQAInStockList(BussIDList)),"^",4)_"..."
		s LocDR=$p($g(^DHCEQAInStock(BussID)),"^",3)
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)	//czf 2021-09-02		
	}
	elseif BussType="A02" //配件转移
	{
		s Date=$p($g(^DHCEQAMoveStock(BussID)),"^",7)
		s No=$p($g(^DHCEQAMoveStock(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQAMoveStock(BussID)),"^",28)
		s BussInvalidFlag="N"
		s FromLoc=$p($g(^DHCEQAMoveStock(BussID)),"^",4)
		s ToLoc=$p($g(^DHCEQAMoveStock(BussID)),"^",5)
		s MoveType =$CASE($p($g(^DHCEQAMoveStock(BussID)),"^",14),"0":"出库","1":"库房调配","2":"退库",:"没有定义")
		s BussIDList=$o(^DHCEQAMoveStockList(0,"MoveStock",BussID,0))
		s Name=$p($g(^DHCEQAMoveStockList(BussIDList)),"^",4)_"..."
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(ToLoc)	//czf 2021-09-02
	}
	elseif BussType="A03" //配件退货
	{
		s Date=$p($g(^DHCEQAReduce(BussID)),"^",8)
		s No=$p($g(^DHCEQAReduce(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQAReduce(BussID)),"^",23)
		s BussInvalidFlag="N"
		s MoveType =$p($g(^DHCEQAReduce(BussID)),"^",3)
		q:MoveType'=1 
		s MoveType="退货"
	    s BussIDList=$o(^DHCEQAReduceList(0,"Reduce",BussID,0))
	    s ItemDR=$p($g(^DHCEQAReduceList(BussIDList)),"^",2)
		i ItemDR'="" s Name=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",2)_"..."
		s LocDR=$p($g(^DHCEQAReduce(BussID)),"^",4)
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)	//czf 2021-09-02
	}
	elseif BussType="A04" //配件减少
	{
		s Date=$p($g(^DHCEQAReduce(BussID)),"^",8)
		s No=$p($g(^DHCEQAReduce(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQAReduce(BussID)),"^",23)
		s BussInvalidFlag="N"
		s MoveType =$p($g(^DHCEQAReduce(BussID)),"^",3)
		q:MoveType=1 
		s MoveType="减少"
		s BussIDList=$o(^DHCEQAReduceList(0,"Reduce",BussID,0))
	    s ItemDR=$p($g(^DHCEQAReduceList(BussIDList)),"^",2)
		i ItemDR'="" s Name=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",2)_"..."
		s LocDR=$p($g(^DHCEQAReduce(BussID)),"^",4)
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)	//czf 2021-09-02
	}
	elseif BussType="64" //租赁 add by zx 2016-11-03 增加租赁消息读取处理 ZX0036
	{
		//Modify by zx 2020-04-29
		s RentModeFlag=##class(web.DHCEQCommon).GetSysInfo("992003")
		if RentModeFlag=2
		{
			s Date=$p($g(^DHCEQSRent(BussID)),"^",5)
			s No=$p($g(^DHCEQSRent(BussID)),"^",1)
			s BussStatus=$p($g(^DHCEQSRent(BussID)),"^",36)
			s BussInvalidFlag="N"
			//Modify by zx 2020-06-24 Bug ZX0093
			i No="" s BussInvalidFlag="Y"
			s ShareItemDR=$p($g(^DHCEQSRent(BussID)),"^",32)
			i ShareItemDR'="" d
			.s Name=$p($g(^DHCEQSCShareItem(ShareItemDR)),"^",3)
			s ItemDR=$p($g(^DHCEQSRent(BussID)),"^",7)
			i ItemDR'="" d
			.s Name=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1)
			.s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
			.s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
			s ShareResourceID=$p($g(^DHCEQSRent(BussID)),"^",9)
			i ShareResourceID'="" s EquipID=$p($g(^DHCEQSShareResource(ShareResourceID)),"^",3)
			s FromLoc=$p($g(^DHCEQSRent(BussID)),"^",3)
			s RequestLoc=$p($g(^DHCEQSRent(BussID)),"^",2)
			s StartDate=$p($g(^DHCEQSRent(BussID)),"^",10)
			s planEndDate=$p($g(^DHCEQSRent(BussID)),"^",12)
			s BussAuditDate=$p($g(^DHCEQSRent(BussID)),"^",23)
			s LastHandlerDR=$p($g(^DHCEQSRent(BussID)),"^",4)
		}
		elseif RentModeFlag=1
		{
			s Date=$p($g(^DHCEQRent(BussID)),"^",5)
			s No=$p($g(^DHCEQRent(BussID)),"^",1)
			s BussStatus=$p($g(^DHCEQRent(BussID)),"^",36)
			s BussInvalidFlag="N"
			//Modify by zx 2020-06-24 Bug ZX0093
			i No="" s BussInvalidFlag="Y"
			s ItemDR=$p($g(^DHCEQRent(BussID)),"^",7)
			i ItemDR'="" d
			.s Name=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1)
			.s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
			.s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
			s EquipID=$p($g(^DHCEQRent(BussID)),"^",9)
			s FromLoc=$p($g(^DHCEQRent(BussID)),"^",3)
			s RequestLoc=$p($g(^DHCEQRent(BussID)),"^",2)
			s StartDate=$p($g(^DHCEQRent(BussID)),"^",10)
			s planEndDate=$p($g(^DHCEQRent(BussID)),"^",12)
			s BussAuditDate=$p($g(^DHCEQRent(BussID)),"^",23)
			s LastHandlerDR=$p($g(^DHCEQRent(BussID)),"^",4)
		}
		
		i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
		
		i EquipID'=""  d SetEquipInfo
	}
	elseif BussType="65" //设备配送 add by zx 2017-02-07  Bug ZX0038
	{
		s Date=$p($g(^DHCEQMove(BussID)),"^",21)
		s No=$p($g(^DHCEQMove(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQMove(BussID)),"^",30)
		s BussInvalidFlag="N"
		s FromLoc = $p($g(^DHCEQMove(BussID)),"^",9)
		s ToLoc = $p($g(^DHCEQMove(BussID)),"^",15)
		s MoveType =$CASE($p($g(^DHCEQMove(BussID)),"^",6),"1":"送出","2":"归还",:"没有定义")
		s SourceTypeDR=$p($g(^DHCEQMove(BussID)),"^",2)
		s EquipID = $p($g(^DHCEQMove(BussID)),"^",3)
		i EquipID'="" s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)
		s LastHandlerDR=$p($g(^DHCEQMove(BussID)),"^",23)
		i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(ToLoc)	//czf 2021-09-02
		d SetEquipInfo
	}
	elseif BussType="66" //发票 add by zx 2017-07-05
	{
		s Date=$p($g(^DHCEQInvoice(BussID)),"^",3)
		s No=$p($g(^DHCEQInvoice(BussID)),"^",2)
		s BussStatus=$p($g(^DHCEQInvoice(BussID)),"^",10)
		s BussInvalidFlag="N"	
		s UseMapDR=$o(^DHCEQInvoiceUseMap(0,"Invoice",BussID,0))
		i UseMapDR'="" d
		.q:$p($g(^DHCEQInvoiceUseMap(UseMapDR)),"^",3)'="11"
		.s MaintDR=$p($g(^DHCEQInvoiceUseMap(UseMapDR)),"^",1)
		.i MaintDR'="" d
		..s MaintRequestDR=$p($g(^DHCEQMMaintPart(MaintDR)),"^",9)
		..i MaintRequestDR'="" d
		...s RequestLoc=+$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",7)
		...s Date=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",18)
		...s ExObjDR=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",5)
		...s SourceTypeDR=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",63)
		...i ExObjDR'="" d
		....i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)  d  //add by zx 2017-03-20 BUG ZX0036modified by wy 2022-4-13
		.....s EquipID=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
		.....i EquipID'="" s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)
		....e  d
		.....s Name=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
		...s UseLoc=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",6)
		
		i EquipID'=""  d SetEquipInfo
	}
	elseif BussType="82"	//报废预警鉴定	Mozy0226	2019-9-22
	{
		s EquipID=$p($g(^DHCEQAppraisalReport(BussID)),"^",2)
		s No=$p($g(^DHCEQAppraisalReport(BussID)),"^",3)
		s Name=$p($g(^DHCEQAppraisalReport(BussID)),"^",4)
		s Date=$p($g(^DHCEQAppraisalReport(BussID)),"^",17)
		s BussStatus=$p($g(^DHCEQAppraisalReport(BussID)),"^",21)
		s BussAuditDate=$p($g(^DHCEQAppraisalReport(BussID)),"^",26)
		s BussInvalidFlag=$p($g(^DHCEQAppraisalReport(BussID)),"^",35)
		
		i EquipID'="" d SetEquipInfo
	}
	elseif BussType="55"		;设备拆分 czf 2014955 2021-07-04
	{
		s Date=$p($g(^DHCEQSplit(BussID)),"^",24)
		s BussStatus=$p($g(^DHCEQSplit(BussID)),"^",22)
		s BussInvalidFlag=$p($g(^DHCEQSplit(BussID)),"^",27)
		s No=$p($g(^DHCEQSplit(BussID)),"^",1)
		s EquipID=$p($g(^DHCEQSplit(BussID)),"^",2)
		s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)	
		s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQSplit(BussID)),"^",4),"")	
		s BussAuditDate=$p($g(^DHCEQSplit(BussID)),"^",26)
		s UseLoc=$p($g(^DHCEQSplit(BussID)),"^",11)
		s RequestUser=$p($g(^DHCEQSplit(BussID)),"^",23)
		s HospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(UseLoc)	//czf 2021-09-02
		i EquipID'=""  d SetEquipInfo
	}
	
	quit No_"^"_Name_"^"_RequestLoc_"^"_Date_"^"_UseLoc_"^"_FromLoc_"^"_ToLoc_"^"_MoveType_"^"_OutType_"^"_ContractNo_"^"_EquipID_"^"_BussStatus_"^"_BussInvalidFlag_"^"_BStatus_"^"_EquipTypeDR_"^"_StatCatDR_"^"_EquipCatDR_"^"_ItemDR_"^"_LastHandlerDR_"^"_LastHandler_"^"_LastOperate_"^"_BussAuditDate_"^"_EquipNo_"^"_FileNo_"^"_Model_"^"_RequestUser_"^"_FaultCase_"^"_StartDate_"^"_planEndDate_"^"_AcceptUserDR_"^"_OriginalFee_"^"_HospDR_"^"_EmergencyFlag_"^"_SeverityFlag_"^"_Time //czf 2021-09-02// Add By zc2022-4-8
SetEquipInfo
	i EquipID="" quit
	s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
	s StatCatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)
	s EquipCatDR=$p($g(^DHCEQEquip(EquipID)),"^",4)
	s ItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
	s EquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	s FileNo=$p($g(^DHCEQEquip(EquipID)),"^",85)
	s Model=$p($g(^DHCEQEquip(EquipID)),"^",3)
	i Model'="" s Model=$Piece($Get(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	quit
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetMaintAlertData","71")
Query GetMaintAlertData(BussType As %String = "") As %Query(ROWSPEC = "bussType:%String,bussID:%String,equipID:%String,name:%String,equipNo:%String,equipTypeDR:%String,equipType:%String,useLoc:%String,lastDate:%String,nextDate:%String,mPName:%String,warningFlag:%String,MaintTypeDR:%String")
{
}

ClassMethod GetMaintAlertDataExecute(ByRef qHandle As %Binary, BussType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s GroupID=%session.Get("LOGON.GROUPID")
	//s GroupID=85
 	i (GroupID="")||(BussType="") Quit $$$OK
 	i (BussType'="71")&&(BussType'="72-1")&&(BussType'="72-2") Quit $$$OK
	s Node=$j
	s index=1
	k ^TempDHCEQ("Msg","Alert",Node)
	d ##Class(web.DHCEQMessages).SetMaintAlertData(Node,BussType)
	s EquipDR=0
	f  s EquipDR=$o(^TempDHCEQ("Msg","Alert",Node,BussType,EquipDR)) q:EquipDR=""   d
	.d ResetVariablesRowGetMaintAlertData
	.s DataList=$g(^DHCEQEquip(EquipDR))
	.s EquipID=EquipDR
	.q:$p(DataList,"^",38)>"2"
	.q:($p(DataList,"^",60)="0")||($p(DataList,"^",60)>"2")
	.s EquipTypeDR=$p(DataList,"^",63)
	.quit:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	.s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	.//quit:("0"=##Class(web.DHCEQCManageLimit).IsInManageLimit("",GroupID,EquipTypeDR,"","",""))
	.s Name=$p(DataList,"^",1)
	.s EquipNo=$p(DataList,"^",71)
	.s EQModelDR=$p(DataList,"^",3)
	.s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(DataList,"^",19))
	.s MaintPlanID=0
	.f  s MaintPlanID=$o(^TempDHCEQ("Msg","Alert",Node,BussType,EquipDR,MaintPlanID)) quit:MaintPlanID=""  d
	..s str=##Class(web.DHCEQMaintPlanNew).WarnDaysNum(MaintPlanID,EquipDR)
	..q:$p(str,"^",1)=0
	..s BussID=MaintPlanID
	..s LastDate=##class(web.DHCEQCommon).TransValueToPage($p(str,"^",2),"date")
	..s NextDate=##class(web.DHCEQCommon).TransValueToPage($p(str,"^",3),"date")
	..i (+$p(str,"^",3)<+$H) s WarningFlag=2 ;增加预警标志，用以处理前台背景色 0:不处理，1:预警 2:已到期
	..s MPName=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",1)
	..s MaintType=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",9)		//Add By DJ 2017-02-18
	..s MPModelDR=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",5)
	..q:(MPModelDR'="")&&(EQModelDR'=MPModelDR)		//Add By DJ 2017-02-18
	..s MaintTypeDR=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",9)
	..s SourceType=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",3)
	..q:(MaintTypeDR=5)&&((SourceType=1)||(SourceType=2))&&($p(DataList,"^",15)'="Y")   //过滤计量计划中来源为设备分类和设备项的非计量设备 modified by czf  需求号：336771
	..q:(BussType="72-1")&&($p($g(^DHCEQMaintPlan(MaintPlanID)),"^",18)="Y")&&($p(DataList,"^",15)'="Y")    //过滤台账中的非计量设备  modified by czf 需求号：336771
	..d OutputRowGetMaintAlertData
	k ^TempDHCEQ("Msg","Alert",Node)
	Quit $$$OK
ResetVariablesRowGetMaintAlertData
	s (DataList,BussID,EquipID,Name,EquipNo,EquipTypeDR,EquipType,UseLoc,LastDate,NextDate,MPName,MaintType)=""
	s WarningFlag=""
	quit
OutputRowGetMaintAlertData
	set Data=$lb(BussType,BussID,EquipID,Name,EquipNo,EquipTypeDR,EquipType,UseLoc,LastDate,NextDate,MPName,WarningFlag,MaintType)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetMaintAlertDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintAlertDataExecute ]
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

ClassMethod GetMaintAlertDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGetMaintAlertDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetCertificateData","63-")
Query GetCertificateData(BussType As %String = "") As %Query(ROWSPEC = "bussType:%String,bussID:%String,name:%String,certificateType:%String,certificateNo:%String,certificateDept:%String,certificateDate:%String,availableDate:%String,equipNo:%String,warningFlag:%String")
{
}

ClassMethod GetCertificateDataExecute(ByRef qHandle As %Binary, BussType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s GroupID=%session.Get("LOGON.GROUPID")
	//s GroupID=217
 	i (GroupID="")||(BussType="") Quit $$$OK
 	i (BussType'="63-1")&&(BussType'="63-2")&&(BussType'="63-3") Quit $$$OK
	s index=1
	//^DHCEQCertificateInfo(0,"Source",sourcetype,sourceid
	if (BussType="63-1") s SourceType="2"
	if (BussType="63-2") s SourceType="3"
	if (BussType="63-3") s SourceType="4"
	s SourceID=0
	f  s SourceID=$o(^DHCEQCertificateInfo(0,"Source",SourceType,SourceID)) quit:SourceID=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQCertificateInfo(0,"Source",SourceType,SourceID,rowid)) quit:rowid=""  d
	..d ResetVariablesRowGetCertificateData
	..s DataList=$g(^DHCEQCertificateInfo(rowid))
	..s BussID=rowid
	..q:$p(DataList,"^",10)="Y"
	..i SourceType="2" d
	...s Name=##Class(web.DHCEQCommon).GetTrakNameByID("prov",SourceID)	
	..e  i SourceType="3"  d
	...s Name=$p($g(^DHCEQCCode("DHCEQCManufacturer",SourceID)),"^",1)
	..e  i SourceType="4"  d
	...i SourceID'=""  d
	....s EQRowID=$p($g(^DHCEQMaint(SourceID)),"^",1)
	....i EQRowID'=""  d
	.....s Name=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	.....s EquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	..s CertificateType=$p(DataList,"^",3)
	..i CertificateType'="" s CertificateType=$p($g(^DHCEQCCode("DHCEQCCertificateType",CertificateType)),"^",2)
	..s CertificateNo=$p(DataList,"^",4)
	..s CertificateDept=$p(DataList,"^",6)
	..s CertificateDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",7),"date")
	..i (+$p(DataList,"^",8)<+$H) s WarningFlag=2 ;增加预警标志，用以处理前台背景色 0:不处理，1:预警 2:已到期
	..s NextDate=$p(DataList,"^",8)
	..s CurDate=+$H
	..q:(+(NextDate-CurDate)>30)
	..s AvailableDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",8),"date")
	..d OutputRowGetCertificateData
	Quit $$$OK
ResetVariablesRowGetCertificateData
	s (DataList,BussID,Name,CertificateType,CertificateNo,CertificateDept,CertificateDate,AvailableDate,EquipNo,WarningFlag)=""
	quit
OutputRowGetCertificateData
	set Data=$lb(BussType,BussID,Name,CertificateType,CertificateNo,CertificateDept,CertificateDate,AvailableDate,EquipNo,WarningFlag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetCertificateDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCertificateDataExecute ]
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

ClassMethod GetCertificateDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCertificateDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetGuaranteeData","73")
/// 工作台保修数据改成从ContractList取，modified by czf 需求号：359853
Query GetGuaranteeData(BussType As %String = "") As %Query(ROWSPEC = "bussType:%String,bussID:%String,equipID:%String,name:%String,equipTypeDR:%String,equipType:%String,equipNo:%String,useLoc:%String,beginDate:%String,endDate:%String,warningFlag:%String")
{
}

ClassMethod GetGuaranteeDataExecute(ByRef qHandle As %Binary, BussType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s GroupID=%session.Get("LOGON.GROUPID")
 	i (GroupID="")||(BussType'="73") Quit $$$OK
	s index=1
	s CurDate=+$H
	
	s rowid=0                     //add by czf 2017-04-12 begin
	f  s rowid=$o(^DHCEQContract(rowid)) q:rowid=""  d
	.d ResetVariablesRowGetGuaranteeData
	.s bussID=rowid
	.s Status= $p($g(^DHCEQContract(rowid)),"^",24)
	.q:Status'=2
	.s ContractType=$p($g(^DHCEQContract(rowid)),"^",39)
	.q:ContractType'=1        //0:采购合同 ； 1：保修合同
	.s BeginDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",49),"date")
	.s EndDate=$p($g(^DHCEQContract(rowid)),"^",50)
	.q:(EndDate-CurDate)>30
	.s EndDate =##Class(web.DHCEQCommon).TransValueToPage(EndDate,"date")
	.i (EndDate<+$H) s WarningFlag=2 ;增加预警标志，用以处理前台背景色 0:不处理，1:预警 2:已到期
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",rowid,CTLRowID)) q:CTLRowID=""  d
	..s SourceType=$p($g(^DHCEQContractList(CTLRowID)),"^",5)
	..s SourceID=$p($g(^DHCEQContractList(CTLRowID)),"^",17)
	..i SourceType=2  d        //保修合同(2：设备)，采购合同(1：计划，2：招标，3：设备项)
	...s EquipID=SourceID
	...i EquipID '="" d
	....s StockStaus=$p($g(^DHCEQEquip(EquipID)),"^",60)
	....;q:(StockStaus="0")||(StockStaus>"2")
	....s Name=$p($g(^DHCEQEquip(EquipID)),"^",1)
	....s EquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	....s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
	....q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	....s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	....s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EquipID)),"^",19))
	....d OutputRowGetGuaranteeData                           //add by czf 2017-04-12 end
	Quit $$$OK
ResetVariablesRowGetGuaranteeData
	s (BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,UseLoc,BeginDate,EndDate,WarningFlag)=""
	quit
OutputRowGetGuaranteeData
	set Data=$lb(BussType,BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,UseLoc,BeginDate,EndDate,WarningFlag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
	/*
	//add by zy 2015-12-01
	//保修开始计算的时间点	0:验收日期  1:入库日期
	s BeginFlag=##class(web.DHCEQCommon).GetSysInfo("990039")
	i BeginFlag="" s BeginFlag=1		//Modify MZY 2017-02-27
	s Status=""
	f  s Status=$o(^DHCEQEquip(0,"Guarantee",Status)) quit:(Status="")||(Status>2)  d
	.s MonthNum=""
	.f  s MonthNum=$o(^DHCEQEquip(0,"Guarantee",Status,MonthNum)) quit:MonthNum=""  d
	..s EquipDR=0
	..f  s EquipDR=$o(^DHCEQEquip(0,"Guarantee",Status,MonthNum,EquipDR)) quit:EquipDR=""  d
	...d ResetVariablesRowGetGuaranteeData
	...s InvalidFlag=$p($g(^DHCEQEquip(EquipDR)),"^",59)   //modified by czf 需求号：326945
	...q:InvalidFlag="Y"
	...s DataList=$g(^DHCEQEquip(EquipDR))
	...s EquipID=EquipDR
	...q:($p(DataList,"^",60)="0")||($p(DataList,"^",60)>"2")
	...s EquipTypeDR=$p(DataList,"^",63)
	...q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	...s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	...//quit:("0"=##Class(web.DHCEQCManageLimit).IsInManageLimit("",GroupID,EquipTypeDR,"","",""))
	...s Name=$p(DataList,"^",1)
	...s EquipNo=$p(DataList,"^",71)
	...s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(DataList,"^",19))
	...s BeginDate=$p(DataList,"^",12)
	...i BeginFlag=1 s BeginDate=$p(DataList,"^",45)
	...s EndDate=##class(web.DHCEQCommon).DateAdd("M",MonthNum,$ZD(BeginDate,4))
	...;s EndDate=$ZDH(EndDate,4)
	...;日期格式统一调整
	...s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	...s (rowid,ContractDR,SignDate,MaxDate,MaxContractDR,SCFlag)=0
	...f  s rowid=$o(^DHCEQServiceContract(0,"Equip",EquipID,rowid))  quit:rowid=""  d
	....s ContractDR=$P(^DHCEQServiceContract(rowid),"^",2)
	....s SignDate=$P(^DHCEQContract(ContractDR),"^",7)
	....i SignDate>MaxDate d
	.....s MaxContractDR=ContractDR
	.....s MaxDate=SignDate
	.....s SCFlag=1
	...i MaxContractDR>0 s BeginDate=$p($g(^DHCEQContract(MaxContractDR)),"^",11)
	...i MaxContractDR>0 s EndDate=$p($g(^DHCEQContract(MaxContractDR)),"^",12)
	...q:((SCFlag=0)&&(+MonthNum=0))		//Add By DJ 2016-04-18
	...q:(EndDate-CurDate)>30
	...i MaxContractDR>0 s BussID=MaxContractDR
	...s BeginDate=##class(web.DHCEQCommon).TransValueToPage(BeginDate,"date")
	...i (EndDate<+$H) s WarningFlag=2 ;增加预警标志，用以处理前台背景色 0:不处理，1:预警 2:已到期
	...s EndDate=##class(web.DHCEQCommon).TransValueToPage(EndDate,"date")
	...d OutputRowGetGuaranteeData
	Quit $$$OK
ResetVariablesRowGetGuaranteeData
	s (DataList,BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,UseLoc,BeginDate,EndDate,WarningFlag)=""
	quit
OutputRowGetGuaranteeData
	set Data=$lb(BussType,BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,UseLoc,BeginDate,EndDate,WarningFlag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
	*/
}

ClassMethod GetGuaranteeDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGuaranteeDataExecute ]
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

ClassMethod GetGuaranteeDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGuaranteeDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetRentData","73")
Query GetRentData(BussType As %String = "") As %Query(ROWSPEC = "bussType:%String,bussID:%String,equipID:%String,name:%String,equipTypeDR:%String,equipType:%String,equipNo:%String,useLoc:%String,requestLoc:%String,fromLoc:%String,startDate:%String,planEndDate:%String")
{
}

ClassMethod GetRentDataExecute(ByRef qHandle As %Binary, BussType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s GroupID=%session.Get("LOGON.GROUPID")
	s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
 	i (GroupID="")||(CurLocDR="")||(BussType'="64") Quit $$$OK
	s index=1
	s CurDate=+$H
	s rowid=""
	f  s rowid=$o(^DHCEQRent(0,"Status",2,rowid)) quit:rowid=""  d
	.d ResetVariablesRowGetRentData
	.s DataList=$g(^DHCEQRent(rowid))
	.s EquipID=$p(DataList,"^",9)
	.s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
	.quit:"1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID)
	.s TRequestLocDR=$p(DataList,"^",2)
	.s TFromLocDR=$p(DataList,"^",3)
	.q:(TRequestLocDR'=CurLocDR)&&(TFromLocDR'=CurLocDR)
	.s Name=$p($g(^DHCEQEquip(EquipID)),"^",1)
	.s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	.s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EquipID)),"^",67))
	.s EquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	.s StartDate=$p(DataList,"^",10)
	.s StartTime=$p(DataList,"^",11)
	.s PlanEndDate=$p(DataList,"^",12)
	.s PlanEndTime=$p(DataList,"^",13)
	.q:(PlanEndDate-CurDate)>1
	.s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(DataList,"^",2))
	.s FromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(DataList,"^",3))
	.s StartDate=##class(web.DHCEQCommon).TransValueToPage(StartDate,"date")
	.s StartTime=##class(web.DHCEQCommon).TransValueToPage(StartTime,"time")
	.i StartTime'="" s StartDate=StartDate_" "_StartTime
	.s PlanEndDate=##class(web.DHCEQCommon).TransValueToPage(PlanEndDate,"date")
	.s PlanEndTime=##class(web.DHCEQCommon).TransValueToPage(PlanEndTime,"time")
	.i PlanEndTime'="" s PlanEndDate=PlanEndDate_" "_PlanEndTime
	.d OutputRowGetRentData
	Quit $$$OK
ResetVariablesRowGetRentData
	s (DataList,BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,UseLoc,RequestLoc,FromLoc,StartDate,StartTime,PlanEndDate,PlanEndTime)=""
	quit
OutputRowGetRentData
	set Data=$lb(BussType,BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,UseLoc,RequestLoc,FromLoc,StartDate,PlanEndDate)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetRentDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentDataExecute ]
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

ClassMethod GetRentDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetMaintMonitorData","81")
Query GetMaintMonitorData(BussType As %String = "") As %Query(ROWSPEC = "bussType:%String,bussID:%String,equipID:%String,name:%String,equipTypeDR:%String,equipType:%String,equipNo:%String,no:%String,requestLoc:%String,useLoc:%String,requestDate:%String,startDate:%String,acceptDate:%String,acceptUser:%String,faultCase:%String,faultCaseRemark:%String")
{
}

ClassMethod GetMaintMonitorDataExecute(ByRef qHandle As %Binary, BussType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s GroupID=%session.Get("LOGON.GROUPID")
	s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	i (GroupID="")||((BussType'="81")&&(BussType'="81-1")) Quit $$$OK
	s index=1
	s StatusDR=0
	f  s StatusDR=$o(^DHCEQMMaintRequest(0,"Status",StatusDR))  q:StatusDR=""  d
	.q:StatusDR'=1		//暂时默认只取提交状态
	.s rowid=0
	.f  s rowid=$o(^DHCEQMMaintRequest(0,"Status",StatusDR,rowid))  quit:rowid=""  d
	..d ResetVGetMaintMonitorData
	..s DataList=$g(^DHCEQMMaintRequest(rowid))
	..s BussID=rowid
	..q:($p(DataList,"^",57)="Y")
	..;s EquipTypeDR=$p(DataList,"^",3)
	..;q:"1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID)
	..;s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	..;s UseLoc=$p(DataList,"^",6)
	..s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(31,rowid,"")
	..s EquipTypeDR=$p(ApproveInfo,"^",10)
	..s StatCatDR=$p(ApproveInfo,"^",11)
	..s EquipCatDR=$p(ApproveInfo,"^",12)
	..s UseLoc=$p(ApproveInfo,"^",9)
	..s EquipID=$p(ApproveInfo,"^",14)
	..s ItemDR=$p(ApproveInfo,"^",13)
	..s Roles=""
	..quit:"1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID)
	..//判断当前用户是否可以查看这个维修单据;
	..//先根据维修组看当前用户可管理的用户有哪儿些,然后看看每个用户的权限.
	..s Flag=1		//无权限操作
	..i BussType="81"  d
	...s UserIDs=##Class(web.DHCEQMCMaintGroup).GetMemberUser(CurUserID,"1")
	...s Len=$L(UserIDs,",")
	...f i=1:1:Len  d
	....q:Flag=0
	....s UserID=$p(UserIDs,",",i)
	....s Flag=##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,Roles,EquipTypeDR,StatCatDR,EquipCatDR,UseLoc,EquipID,ItemDR)
	..e  d
	...s Flag=0
	..q:Flag'=0
	..s SourceType=$p(DataList,"^",63)
	..i SourceType=1  d
	...s EquipID=$Piece($Get(^DHCEQMExObj($p(DataList,"^",5))),"^",5)	
	...s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)	
	...s EquipNo=$Piece($Get(^DHCEQEquip(EquipID)),"^",71)
	..e  d
	...s Name=$Piece($Get(^DHCEQMExObj($p(DataList,"^",5))),"^",1)
	..s No=$p(DataList,"^",1)
	..s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	..s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(DataList,"^",6))
	..s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(DataList,"^",7))
	..s RequestDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",18),"date")
	..s RequestTime=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",19),"time")
	..i RequestTime'="" s RequestDate=RequestDate_" "_RequestTime
	..s StartDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",8),"date")
	..s StartTime=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",9),"time")
	..i StartTime'="" s StartDate=StartDate_" "_StartTime
	..s AcceptDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",24),"date")
	..s AcceptTime=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",25),"time")
	..i AcceptTime'="" s AcceptDate=AcceptDate_" "_AcceptTime
	..s AcceptUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(DataList,"^",26))
	..s FaultCase=$p(DataList,"^",10)
	..i FaultCase'=""  s FaultCase=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FaultCase)),"^",2)
	..s FaultCaseRemark=$p(DataList,"^",11)
	..d OutputRowGetMaintMonitorData
	Quit $$$OK
ResetVGetMaintMonitorData
	s (DataList,BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,No,RequestLoc,UseLoc,RequestDate,StartDate,AcceptDate,AcceptUser,FaultCase,FaultCaseRemark)=""
	quit
OutputRowGetMaintMonitorData
	set Data=$lb(BussType,BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,No,RequestLoc,UseLoc,RequestDate,StartDate,AcceptDate,AcceptUser,FaultCase,FaultCaseRemark)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetMaintMonitorDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintMonitorDataExecute ]
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

ClassMethod GetMaintMonitorDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintMonitorDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add by JDL 2016-1-20
/// 根据BussType,BussID获取业务单据的审批信息
/// w ##Class(web.DHCEQMessages).GetApproveInfo("11","55") 
ClassMethod GetApproveInfo(BussType, BussID, ApproveRoleDR As %String = "")
{
	n ApproveType,AIRowID
	if (BussType="")||(BussID="") q ""
	
	s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
	if (ApproveType="") q ""
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType(ApproveType)
	s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,BussID,0))
	if (AIRowID'="")
	{	q $g(^DHCEQApproveInfo(AIRowID))	}
	else
	{	q ""	}
	
	i ApproveType="" q ""
    q ##class(web.DHCEQApproveList).GetApproveType(ApproveType)      
	q ##Class(web.DHCEQApprove).GetApproveInfoBySourceID(ApproveType,BussID,ApproveRoleDR)
}

/// Modified by czf 2014955 2021-07-04 增加设备拆分对照
/// Add by JDL 2016-1-20
/// 将BussType转换成对应的ApproveType
/// w ##Class(web.DHCEQMessages).GetApproveTypeByBussType("31") 
ClassMethod GetApproveTypeByBussType(BussType)
{
	;BussType
	;0：无 11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用、51设备调帐 52设备台帐 55设备拆分
	;61工程管理 62科研课题 63证件 63-1供应商资质 63-2生产厂商资质 63-3计量证书 64租赁 71保养预警 72检查预警 72-1计量检查 72-2巡检 73保修到期 81维修监控 91采购申请 92采购计划 93采购招标 94采购合同 95保修合同
	;以下尚无审批流：32保养、33检查、35折旧、41使用、51设备调帐 52设备台帐 62科研课题 63证件 63-1供应商资质 63-2生产厂商资质 63-3计量证书  71保养预警 72检查预警 72-1计量检查 72-2巡检 73保修到期 81维修监控 
	;A01:配件入库  A02:配件转移  A03:配件退货  A04:配件减少  //add by zx 2016-03-04 增加配件处理
	
	;ApproveType
	;1	采购申请,2	采购计划,3	设备论证,4	采购审批,5	报废申请,6	调试验收,7	开箱验收,8	采购合同,9	委外申请,
	;10	备件入库,11	备件转移,12	年度计划分配,13	设备入库,14	设备转移,15	退货,16	设备维修,17	招标审批设置,18	工程管理,19	付款审批,
	;20	研究课题,21	备件退货,22	洗涤单,23	销毁更换单,24	车辆派遣,25	新设备维修,26	综合使用评价表,27	技术评估表,28	评价调查表,29	不良事件表,30	租赁管理,36 设备拆分
	
	if (BussType="") q ""
	q $CASE(BussType,
              "11":"7","12":"6",
              "21":"13","22":"14","23":"15",
              "31":"25","32":"","33":"","34":"5",
              "55":"36",
              "61":"18","64":"30","65":"31","66":"32",
              "82":"33",
              "91":"1","92":"2","2":"","93":"17",
              "94":"8","8":"","95":"8",
              "A01":"10","A02":"11","A03":"21","A04":"21",:"")
}

/// Add by CZF 2021-06-27
/// 将ApproveType转换成对应的BussType
/// w ##Class(web.DHCEQMessages).GetBussTypeByApproveType("31") 
ClassMethod GetBussTypeByApproveType(ApproveType)
{
	;BussType
	;0：无 11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用、51设备调帐 52设备台帐 
	;61工程管理 62科研课题 63证件 63-1供应商资质 63-2生产厂商资质 63-3计量证书 64租赁 71保养预警 72检查预警 72-1计量检查 72-2巡检 73保修到期 81维修监控 91采购申请 92采购计划 93采购招标 94采购合同 95保修合同
	;以下尚无审批流：32保养、33检查、35折旧、41使用、51设备调帐 52设备台帐 62科研课题 63证件 63-1供应商资质 63-2生产厂商资质 63-3计量证书  71保养预警 72检查预警 72-1计量检查 72-2巡检 73保修到期 81维修监控 
	;A01:配件入库  A02:配件转移  A03:配件退货  A04:配件减少  //add by zx 2016-03-04 增加配件处理
	
	;ApproveType
	;1	采购申请,2	采购计划,3	设备论证,4	采购审批,5	报废申请,6	调试验收,7	开箱验收,8	采购合同,9	委外申请,
	;10	备件入库,11	备件转移,12	年度计划分配,13	设备入库,14	设备转移,15	退货,16	设备维修,17	招标审批设置,18	工程管理,19	付款审批,
	;20	研究课题,21	备件退货,22	洗涤单,23	销毁更换单,24	车辆派遣,25	新设备维修,26	综合使用评价表,27	技术评估表,28	评价调查表,29	不良事件表,30	租赁管理,
	
	if (ApproveType="") q ""
	q $CASE(ApproveType,
              "7":"11","6":"12",
              "13":"21","14":"22","15":"23",
              "25":"31","5":"34",
              "18":"61","30":"64","31":"65","32":"66",
              "33":"82","1":"91","2":"92","17":"93","8":"94","8":"95",
              "10":"A01","11":"A02","21":"A03","21":"A04",:"")
}

/// Add by wsp 2016-3-23
/// 根据业务类型和业务ID获取业务审批进度
/// d ##Class(%ResultSet).RunQuery("web.DHCEQMessages","GetApproveList",31,148)
/// GetApproveInfo名称改为GetApproveList modified by czf
Query GetApproveList(BussType, SourceID) As %Query(ROWSPEC = "TRow,TRowID,TApproveType,TApproveDate,TApproveRoleDR,TApproveRole,TApproveUserDR,TApproveUser,TOpinion,TApproveTime,TAction,TTimeInfo")
{
}

ClassMethod GetApproveListExecute(ByRef qHandle As %Binary, BussType, SourceID) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	
	s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
	s TPreDate=""
	s TPreTime=""
	s rowid=0
	f  s rowid=$O(^DHCEQApproveList(0,"Source",ApproveType,SourceID,rowid)) q:rowid=""  d
	.q:$P(^DHCEQApproveList(rowid),"^",10)="Y"
	.d ResetVariable
	.s TRowID=rowid
	.s TApproveType=$P(^DHCEQCCode("DHCEQCApproveType",ApproveType),"^",2)
	.s TApproveDate=$P(^DHCEQApproveList(rowid),"^",7) ;审批日期		//Modify DJ 2016-04-20
	.s TApproveTime=$p($g(^DHCEQApproveList(rowid)),"^",8)   //add by zx 2016-12-27  获取审批时间 ZX0036
	.i TPreDate'="" s TTimeInfo=$p(##Class(web.DHCEQCommon).TimeDiff(TPreDate,TPreTime,TApproveDate,TApproveTime),",",2) 
	.s TPreDate=TApproveDate
	.s TPreTime=TApproveTime
	.;s TApproveDate=$ZD(TApproveDate,3)
	.;日期格式统一调整
	.s TApproveDate=##Class(web.DHCEQCommon).TransValueToPage(TApproveDate,"date")
	.s TApproveRoleDR=$P(^DHCEQApproveList(rowid),"^",5)  ;审批角色
	.i TApproveRoleDR'="" s TApproveRole=$P(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)
	.s TApproveUserDR=$P(^DHCEQApproveList(rowid),"^",6)
	.i TApproveUserDR'="" s TApproveUser=$P(^SSU("SSUSR",TApproveUserDR),"^",2)
	.s TOpinion=$P(^DHCEQApproveList(rowid),"^",3)
	.s TRow=TRow+1
	.s TApproveTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(rowid)),"^",8),"time") //add by zx 2016-05-11 begin
	.s TActionDR=$p($g(^DHCEQApproveList(rowid)),"^",11)  
	.i TActionDR'="" d
	..s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
	.i TActionDR=0 s TAction="提交"   //add by zx 2016-05-11 end
	.d OutputRowGetApproveInfo
 	Set HiddenFlag=##class(web.DHCEQCommon).GetSysInfo("990059")	//add by lmm 2017-09-27 458016
 	if (HiddenFlag=1)||(HiddenFlag="") //add by lmm 2017-09-27 458016
 	{
		//add by zx 2017-09-05 BUG ZX0045 获取下一步待操作信息
		s TRow=TRow+1 //modify by lmm 2017-09-27 458016
    	s TApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,SourceID,0))
    	i TApproveInfoID'="" d
    	.d ResetVariable
    	.s TApproveSetDR=$p($g(^DHCEQApproveInfo(TApproveInfoID)),"^",3)
    	.s TNextFlowStep=$p($g(^DHCEQApproveInfo(TApproveInfoID)),"^",5)
    	.s TApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",TApproveSetDR,TNextFlowStep,0))
    	.i TApproveFlowDR'="" d
    	..s TActionDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowDR),"^",9)
    	..i TActionDR'="" s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
    	.s TApproveDate=""	//modify by lmm 2017-09-27 458016
    	.s TApproveTime=""	//modify by lmm 2017-09-27 458016
    	.s TApproveUser="下一步"
    	.s TOpinion="待处理"
    	.s TApproveType=$P(^DHCEQCCode("DHCEQCApproveType",ApproveType),"^",2)
    	.s TApproveRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowDR),"^",2)  ;审批角色
    	.i TApproveRoleDR'="" s TApproveRole=$P(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)
    	.d OutputRowGetApproveInfo
 	}
	Quit $$$OK
	
ResetVariable
	s (TRowID,TApproveType,TApproveDate,TApproveRoleDR,TApproveRole,TApproveUserDR,TApproveUser,TOpinion,TApproveTime,TActionDR,TAction,TTimeInfo)=""
	quit
	
OutputRowGetApproveInfo
	set Data=$lb(TRow,TRowID,TApproveType,TApproveDate,TApproveRoleDR,TApproveRole,TApproveUserDR,TApproveUser,TOpinion,TApproveTime,TAction,TTimeInfo)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetApproveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApproveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetApproveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApproveListExecute ]
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

/// add by zx 移动端获取消息
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetBussDataForPDA","82","3831")
Query GetBussDataForPDA(GroupID As %String = "", UserID As %String = "") As %Query(ROWSPEC = "bussType:%String,bussID:%String,msgID:%String,equipTypeDR:%String,equipType:%String,sendUser:%String,sendDate:%String,no:%String,name:%String,requestLoc:%String,date:%String,useLoc:%String,fromLoc:%String,toLoc:%String,moveType:%String,outType:%String,contractNo:%String,bStatus:%String,Row:%String,roles:%String,actionDesc:%String,actionCode:%String,BussTypeDesc:%String,WChatUser:%String")
{
}

ClassMethod GetBussDataForPDAExecute(ByRef qHandle As %Binary, GroupID As %String = "", UserID As %String = "") As %Status
{
	new repid, index,rowid	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	//new UserID,GroupID,ApproveType,BussTypeID,ApproveInfo
	new ApproveType,BussTypeID,ApproveInfo
 	new EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,LocDR,EquipID
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s CurRoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID) 
 	i (GroupID="")||(UserID="")||(CurRoleIDs="") Quit $$$OK
 	s index=1
 	s Row=0
 	s MsgID=0
 	f  s MsgID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID)) q:MsgID=""  d
 	.d ResetVariablesRowGetBussDataForPDA
 	.//判断消息的可处理角色和当前角色是否符合
 	.s PassFlag=0
 	.s MRIRowID=0
 	.f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID,MRIRowID)) q:(MRIRowID="")||(PassFlag=1)  d
        ..i $p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",11)="Y" s PassFlag=1  //消息去过之后过滤 zx 2016-04-26
 	..s Roles=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",4)
 	..s ActionIDs=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",10)
 	..s Len=$L(Roles,",")
	..f i=1:1:Len  d
	...q:PassFlag=1
	...s Role=$p(Roles,",",i)
	...i (Role'="")&&((","_CurRoleIDs_",")'[(","_Role_",")) s PassFlag=1 
	...i $p(ActionIDs,",",i)'="" d
	....s ActionDesc=ActionDesc_$p($g(^DHCEQCCode("DHCEQCAction",$p(ActionIDs,",",i))),"^",2)_","
	....s ActionCode=ActionCode_$p($g(^DHCEQCCode("DHCEQCAction",$p(ActionIDs,",",i))),"^",1)_","
	...e  d
	....s ActionDesc=ActionDesc_","
	....s ActionCode=ActionCode_","
	.q:PassFlag=1
	.s DataList=$g(^DHCEQMessages(MsgID))
 	.q:$p(DataList,"^",14)'="1"
 	.q:$p(DataList,"^",21)="Y"
 	.;q:$p(DataList,"^",26)="Y" //消息去过之后过滤
	.s BussTypeID=$p(DataList,"^",10)
	.s BussTypeDesc=##class(web.DHCEQFind).GetBussTypeDesc(BussTypeID)
	.s BussID=$p(DataList,"^",11)
	.s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussTypeID,BussID)
	.
	.;q:$p(BussInfo,"^",12)=2		//BussStatus add by zx 2016-12-01 处理租赁状态被过滤问题 ZX0036
	.q:$p(BussInfo,"^",13)="Y"		//BussInvalidFlag
	.
	.//取当前业务审批信息,获取限制条件,以便后面查看用户是否有权限收消息
	.s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(BussTypeID,BussID,"")
	.//EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR
	.s EquipTypeDR=$p(ApproveInfo,"^",10)
	.q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	.s StatCatDR=$p(ApproveInfo,"^",11)
	.s EquipCatDR=$p(ApproveInfo,"^",12)
	.s LocDR=$p(ApproveInfo,"^",9)
	.s EquipID=$p(ApproveInfo,"^",14)
	.s ItemDR=$p(ApproveInfo,"^",13)
	.s CancelToUser=$p(ApproveInfo,"^",19)
 	.q:##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,Roles,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)
	.s No=$p(BussInfo,"^",1)
	.s Name=$p(BussInfo,"^",2)
	.s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",3))
	.//Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo
	.s Date=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",4),"date")
	.s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",5))
	.s FromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",6))
	.s ToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",7))
	.s MoveType=$p(BussInfo,"^",8)
	.s OutType=$p(BussInfo,"^",9)
	.s ContractNo=$p(BussInfo,"^",10)
	.s BStatus=$p(BussInfo,"^",14)
	.s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	.s SendUserDR=$p(DataList,"^",9)
	.
	.s SendUser= ##Class(web.DHCEQCommon).GetTrakNameByID("user",SendUserDR)
	.s SendDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",10),"date")
	.s SendTime=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",11),"time")
	.s SendDate=SendDate_" "_SendTime
	.s WChatID=$o(^DHCEQWChatUser(0,"UserGroup",UserID,GroupID,""))
	.i WChatID'="" s WChatUser=$p($g(^DHCEQWChatUser(WChatID)),"^",1)
	.q:"0"'=##Class(web.DHCEQMessages).UpdatePdaNatifi(MsgID,UserID) //取消息标志存入失败过滤 zx 2016-04-26
	.d OutputRowGetBussDataForPDA
	Quit $$$OK
ResetVariablesRowGetBussDataForPDA
	s (DataList,EquipTypeDR,EquipType,SendUserDR,SendUser,SendDate,SendTime,BussInfo,No,Name,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BStatus,Roles,ActionIDs,ActionDesc,ActionCode,BussTypeDesc,WChatID,WChatUser)=""
	quit
OutputRowGetBussDataForPDA
	Set Row=Row+1
	set Data=$lb(BussType,BussID,MsgID,EquipTypeDR,EquipType,SendUser,SendDate,No,Name,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BStatus,Row,Roles,ActionDesc,ActionCode,BussTypeDesc,WChatUser)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBussDataForPDAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussDataForPDAExecute ]
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

ClassMethod GetBussDataForPDAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussDataForPDAExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2016-04-21
/// 移动端取消息后存入已取标志在Hold1
/// w ##Class(web.DHCEQMessages).UpdatePdaNatifi("1")
ClassMethod UpdatePdaNatifi(msgID As %String = "", userID As %String = "")
{
	i (msgID="")||(userID="") q "100"
	s PDAFlag="Y"
	&SQL(Update SQLUSER.DHC_EQMessagesRecInfo (MRI_Hold2) values (:PDAFlag) where MRI_MessagesDR=:msgID and MRI_ReceiveUserDR=:userID)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetBussMReceiver","31","WX022016050006","","","N")
Query GetBussMReceiver(vBussTypeDR As %String, vBussNo As %String = "", vStartDate As %String = "", vEndDate As %String = "", vNotSendMessFlag As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "", InvalidMsgFlag As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TBussType:%String,TBussNo:%String,TApproveRole:%String,TAction:%String,TReceiveUser:%String,TReceiveDate:%String,TReceiveTime:%String,TMessDealFlag:%String,TMessDealUser:%String,TMessDealDate:%String,TMessDealTime:%String,TSendUser:%String,TSendDate:%String,TSendTime:%String,TMRowID:%String,TMRIRowID:%String,TBussOpers:%String") [ SqlProc ]
{
}

ClassMethod GetBussMReceiverExecute(ByRef qHandle As %Binary, vBussTypeDR As %String, vBussNo As %String = "", vStartDate As %String = "", vEndDate As %String = "", vNotSendMessFlag As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "", InvalidMsgFlag As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i vBussTypeDR="" Quit $$$OK
	i ((vStartDate="")&&(vEndDate=""))	Quit $$$OK
	;i InvalidMsgFlag="" s InvalidMsgFlag="N"
	;i vNotSendMessFlag="" s vNotSendMessFlag="N"
	;i ((vNotSendMessFlag="Y")&&(vStartDate="")&&(vEndDate=""))	Quit $$$OK
	;i ((vNotSendMessFlag="N")&&(vBussNo="")) Quit $$$OK
	Set vBussNo=##Class(web.DHCEQCommon).Trim(vBussNo)	;Mozy	2017-2-16	截掉两端空格
	Set vBussNo=$ZCONVERT(vBussNo,"U")
	s BeginDate=0
	s EndDate=+$H
	;i vStartDate'="" s BeginDate=$ZDH(vStartDate,3)
	;i vEndDate'="" s EndDate=$ZDH(vEndDate,3)
	s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
	i vNotSendMessFlag="N"  d
	.s BeginDate=""
	.s EndDate=""
	s ReceiveUsers=",1,2620,3913,3914,"		//Demo, Dhdev, Dhcc
	s MMType=0
	f  s MMType=$o(^DHCEQMessages(0,"MessageType",MMType))  q:MMType=""  d
	.s MBussID=0
	.f  s MBussID=$o(^DHCEQMessages(0,"MessageType",MMType,vBussTypeDR,MBussID))  q:MBussID=""  d
	..s MRowID=0
	..f  s MRowID=$o(^DHCEQMessages(0,"MessageType",MMType,vBussTypeDR,MBussID,MRowID))  q:MRowID=""  d
	...d ResetVariablesGetBussMReceiver
	...d GetBussInfo
	...;q:TBussStatus=2
	...q:TBussInvalidFlag="Y"
	...q:(vBussNo'="")&&($ZCONVERT(TBussNo,"U")'[vBussNo)		;Mozy	2017-2-16	模糊查询
	...; 需求号:273279	Mozy	2016-10-19
	...;q:(BeginDate'="")&&(TBussAuditDate<BeginDate)
	...;q:(EndDate'="")&&(TBussAuditDate>EndDate)
	...
	...s TMRowID=MRowID
	...s TApproveRole=$p($g(^DHCEQMessages(MRowID)),"^",12)
	...i TApproveRole'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRole)),"^",2)
	...i TApproveRole="" s TApproveRole="提交"
	...s TAction=$p($g(^DHCEQMessages(MRowID)),"^",26)
	...i TAction'="" s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TAction)),"^",2)
	...i TAction="" s TAction=TApproveRole_"["_MRowID_"]"
	...i TApproveRole="提交" s TAction="提交"
	...s TSendUser=$p($g(^DHCEQMessages(MRowID)),"^",15)
	...i TSendUser'="" s TSendUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TSendUser)
	...s TSendDate=$p($g(^DHCEQMessages(MRowID)),"^",16)
	...; 需求号:273279	Mozy	2016-10-19
	...q:(BeginDate'="")&&(TSendDate<BeginDate)
	...q:(EndDate'="")&&(TSendDate>EndDate)
	...;i TSendDate'="" s TSendDate=$ZD(TSendDate,3)
	...;日期格式统一调整
	...s TSendDate=##Class(web.DHCEQCommon).TransValueToPage(TSendDate,"date")
	...s TSendTime=$p($g(^DHCEQMessages(MRowID)),"^",17)
	...;i TSendTime'="" s TSendTime=$ZT(TSendTime,1)
	...;日期格式统一调整
	...s TSendTime=##Class(web.DHCEQCommon).TransValueToPage(TSendTime,"time")
	...s TMessDealFlag=$p($g(^DHCEQMessages(MRowID)),"^",21)
	...s TMessDealUser=$p($g(^DHCEQMessages(MRowID)),"^",22)
	...i TMessDealUser'="" s TMessDealUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TMessDealUser)
	...s TMessDealDate=$p($g(^DHCEQMessages(MRowID)),"^",23)
	...;i TMessDealDate'="" s TMessDealDate=$ZD(TMessDealDate,3)
	...;日期格式统一调整
	...s TMessDealDate=##Class(web.DHCEQCommon).TransValueToPage(TMessDealDate,"date")
	...s TMessDealTime=$p($g(^DHCEQMessages(MRowID)),"^",24)
	...;i TMessDealTime'="" s TMessDealTime=$ZT(TMessDealTime,1)
	...;日期格式统一调整
	...s TMessDealTime=##Class(web.DHCEQCommon).TransValueToPage(TMessDealTime,"time")
	...;无效消息处理---消息接收人不在维修组及组员内 Add By DJ 2016-12-20 begin
	...i InvalidMsgFlag="Y"  d
	....s InvalidMsgFind=0
	....s MRIRowID=0
	....f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"Message",MRowID,MRIRowID))  q:(MRIRowID="")||(InvalidMsgFind'=0)  d
	.....s TReceiveUser=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",2)
	.....i $D(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",1,TReceiveUser)) s InvalidMsgFind=1
	.....q:InvalidMsgFind'=1
	.....s MGLRowID=0
	.....f  s MGLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",TReceiveUser,MGLRowID))  q:(MGLRowID="")||(InvalidMsgFind'=0)  d
	......s MGRowID=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",1)
	......s MGGroupType=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",1)
	......i MGGroupType=1 s InvalidMsgFind=1
	...q:((InvalidMsgFlag="Y")&&(InvalidMsgFind'=0))		//Add By DJ 2016-12-20 end
	...s MRICount=0
	...s MRIRowID=0
	...f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"Message",MRowID,MRIRowID))  q:MRIRowID=""  d
	....s TReceiveUser=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",2)
	....q:(ReceiveUsers'="")&&(ReceiveUsers[(","_TReceiveUser_","))
	....s TMRIRowID=MRIRowID
	....i TReceiveUser'="" s TReceiveUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TReceiveUser)
	....s TReceiveDate=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",6)
	....q:(vNotSendMessFlag="N")&&(TReceiveDate'="")
	....;i TReceiveDate'="" s TReceiveDate=$ZD(TReceiveDate,3)
	....;日期格式统一调整
	....s TReceiveDate=##Class(web.DHCEQCommon).TransValueToPage(TReceiveDate,"date")
	....s TReceiveTime=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",7)
	....;i TReceiveTime'="" s TReceiveTime=$ZT(TReceiveTime,1)
	....;日期格式统一调整
	....s TReceiveTime=##Class(web.DHCEQCommon).TransValueToPage(TReceiveTime,"time")
	....s TBussOpersDR=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",10)
	....s TBussOpers=""
	....s Len=$L(TBussOpersDR,",")	
	....f i=1:1:Len  d
	.....i $p(TBussOpersDR,",",i)'="" d
	......i $p(TBussOpersDR,",",i)'="0"  d
	.......s TBussOpers=TBussOpers_$p($g(^DHCEQCCode("DHCEQCAction",$p(TBussOpersDR,",",i))),"^",2)_","
	......e  d
	.......s TBussOpers=TBussOpers_"提交,"
	.....e  d
	......s TBussOpers=TBussOpers_","	
	....s MRICount=1
	....d OutputRowGetBussMReceiver
	...i (MRIRowID=0)&&(vNotSendMessFlag="Y")  d
	....d OutputRowGetBussMReceiver
	
	Quit $$$OK
GetBussInfo
	/*
	i vBussTypeDR="31"  d	//Add By DJ 2016-11-29 begin
	.s TBussType="维修"
	.s TBussNo=$p($g(^DHCEQMMaintRequest(MBussID)),"^",1)
	.s TBussInvalidFlag=$p($g(^DHCEQMMaintRequest(MBussID)),"^",57)
	.s TBussStatus=$p($g(^DHCEQMMaintRequest(MBussID)),"^",41)
	.s TBussAuditDate=$p($g(^DHCEQMMaintRequest(MBussID)),"^",52)
	*/
	s TBussType=##Class(web.DHCEQFind).GetBussTypeDesc(vBussTypeDR)		
	s TBussInfo=##Class(web.DHCEQMessages).GetBussInfo(vBussTypeDR,MBussID)
	s TBussNo=$p(TBussInfo,"^",1)
	s TBussInvalidFlag=$p(TBussInfo,"^",13)
	s TBussStatus=$p(TBussInfo,"^",12)
	s TBussAuditDate=$p(TBussInfo,"^",22)	//Add By DJ 2016-11-29 end
	quit
OutputRowGetBussMReceiver
	s Data=$lb(TBussType,TBussNo,TApproveRole,TAction,TReceiveUser,TReceiveDate,TReceiveTime,TMessDealFlag,TMessDealUser,TMessDealDate,TMessDealTime,TSendUser,TSendDate,TSendTime,TMRowID,TMRIRowID,TBussOpers)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBussMReceiver
	s (TBussType,TBussNo,TApproveRole,TAction,TReceiveUser,TReceiveDate,TReceiveTime,TMessDealFlag,TMessDealUser,TMessDealDate,TMessDealTime,TSendUser,TSendDate,TSendTime,TMRowID,TMRIRowID,TBussOpers)=""
	quit
}

ClassMethod GetBussMReceiverFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussMReceiverExecute ]
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

ClassMethod GetBussMReceiverClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussMReceiverExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 移动端获取消息
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessages","GetBussDataForWChat","3831")
Query GetBussDataForWChat(User As %String = "") As %Query(ROWSPEC = "BussID:%String,MsgID:%String,No:%String,Name:%String,RequestLoc:%String,Date:%String,UseLoc:%String,FromLoc:%String,ToLoc:%String,MoveType:%String,OutType:%String,ContractNo:%String,BStatus:%String,BussTypeDesc:%String,WChatUser:%String")
{
}

ClassMethod GetBussDataForWChatExecute(ByRef qHandle As %Binary, User As %String = "") As %Status
{
	new repid, index,rowid	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s WChatUser=""
 	s UserID=0
 	f  s UserID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID)) q:UserID=""  d
 	.s WChatID=$o(^DHCEQWChatUser(0,"User",UserID,""))
 	.;q:WChatID=""
 	.;s WChatUser=$p($g(^DHCEQWChatUser(WChatID)),"^",1)
 	.s MsgID=0
 	.f  s MsgID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID)) q:MsgID=""  d
 	..s MRIRowID=0
 	..f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID,MRIRowID)) q:(MRIRowID="")  d
    ...q:$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",12)="Y" //消息取过之后过滤 zx 2016-08-22 ZX0036
 	...d ResetGetBussDataForWChat
 	...s DataList=$g(^DHCEQMessages(MsgID))
 	...q:"0"'=##Class(web.DHCEQMessages).UpdatePdaNatifiForWChat(MsgID,UserID) //取消息标志存入失败过滤 zx 2016-08-22 ZX0036
 	...q:$p(DataList,"^",14)'="1"
 	...q:$p(DataList,"^",21)="Y"
 	...
	...s BussTypeID=$p(DataList,"^",10)
	...s BussTypeDesc=##class(web.DHCEQFind).GetBussTypeDesc(BussTypeID)
	...s BussID=$p(DataList,"^",11)
	...s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussTypeID,BussID)
	...
	...q:$p(BussInfo,"^",12)=2		//BussStatus
	...q:$p(BussInfo,"^",13)="Y"		//BussInvalidFlag
 	...s No=$p(BussInfo,"^",1)
	...s Name=$p(BussInfo,"^",2)
	...s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",3))
	...s Date=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",4),"date")
	...s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",5))
	...s FromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",6))
	...s ToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",7))
	...s MoveType=$p(BussInfo,"^",8)
	...s OutType=$p(BussInfo,"^",9)
	...s ContractNo=$p(BussInfo,"^",10)
	...s BStatus=$p(BussInfo,"^",14)
	...s SendUserDR=$p(DataList,"^",9)
	...s SendUser= ##Class(web.DHCEQCommon).GetTrakNameByID("user",SendUserDR)
	...s SendDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",10),"date")
	...s SendTime=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",11),"time")
	...s SendDate=SendDate_" "_SendTime
	...d OutputBussDataForWChat
	Quit $$$OK
ResetGetBussDataForWChat
	s (DataList,SendUserDR,SendUser,SendDate,SendTime,BussInfo,No,Name,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BStatus,BussTypeDesc)=""
	quit
OutputBussDataForWChat
	set Data=$lb(BussID,MsgID,No,Name,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BStatus,BussTypeDesc,WChatUser)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBussDataForWChatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussDataForWChatExecute ]
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

ClassMethod GetBussDataForWChatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussDataForWChatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2016-04-21
/// 微信取消息后存入已取标志在Hold3
/// w ##Class(web.DHCEQMessages).UpdatePdaNatifiForWChat("1")
ClassMethod UpdatePdaNatifiForWChat(msgID As %String = "", userID As %String = "")
{
	i (msgID="")||(userID="") q "100"
	s WChatFlag="Y"
	&SQL(Update SQLUSER.DHC_EQMessagesRecInfo (MRI_Hold3) values (:WChatFlag) where MRI_MessagesDR=:msgID and MRI_ReceiveUserDR=:userID)
	q SQLCODE
}

/// add by zy 2016-09-20
/// 查看当前资产总体情况,返回首页界面,展示图表
/// w ##Class(web.DHCEQMessages).GetManagementInfo(85,393,0,4674)
ClassMethod GetManagementInfo(GroupID, LocID, QXType, UserID As %String = "")
{
	new Job,User,EquipID
	new DataList,EQStatus,EQStockStatus,StoreLocID,EquipTypeID,ABCType,MasterItem,OriginalFee,MaintInfo,MaintFlag,ActionID
	new TotalQty,TotalOriginalFee
	s (TotalQty,TotalOriginalFee)=0
	s Job=$j
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//s UserID=1
	k ^TempDHCEQ("ManagementMain",UserID)

	s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))
	
	//待办业务信息
	s RoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
	i RoleIDs'="" s RoleIDs=","_RoleIDs_","
	s browid=0
	f  s browid=$o(^DHCEQCCode("DHCEQCBussType",browid))  quit:browid=""  d
	.s (busstypedr,busscode,busstype)=""
	.q:($p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",4)="Y")
	.s busstypedr=browid
	.s busscode=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",1)
	.s preBussCode=$e(busscode,1)
	.i (",1,2,3,4,9,A,"[preBussCode) s MenuType="Buss"
	.i (",6,7,"[preBussCode) s MenuType="Warning"
	.i ("8"=preBussCode) s MenuType="Monitor"
	.i busscode=64 s MenuType="Buss"   //add by jyp 20170407
	.s busstype=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",2)
	.//s modletypedr=$p($g(^DHCEQCCode("DHCEQCBussType",browid)),"^",3)
	.//s modletype=$Case(modletypedr,"":"","1":"设备管理","2":"维修管理","3":"效益分析","4":"移动盘点","5":"移动维修")
	.s (rrowid,flag,waitnum)=0
	.f  s rrowid=$o(^DHCEQCCode("DHCEQCRoleBuss",0,"BussType",browid,rrowid))  quit:rrowid=""  d
	..i (RoleIDs'="")&&(RoleIDs[(","_$p($g(^DHCEQCCode("DHCEQCRoleBuss",rrowid)),"^",1)_",")) s flag=1
	.q:flag=0
	.i (preBussCode="6")||(preBussCode="7")  d
	..i (busscode="71")||(busscode="72-1")||(busscode="72-2")  d		//Add By DJ 2015-12-28
	...s waitnum=+##Class(web.DHCEQMessages).GetMaintAlertNum(+$j,busscode)
	..e  i (busscode="63-1")||(busscode="63-2")||(busscode="63-3")  d
	...s waitnum=+##Class(web.DHCEQMessages).GetCertificateAlertNum(busscode,+$H)
	..e  i (busscode="73")  d
	...s waitnum=+##Class(web.DHCEQMessages).GetGuaranteeAlertNum(GroupID,+$H)
	..e  i (busscode="64")  d
	...s waitnum=+##Class(web.DHCEQMessages).GetRentAlertNum(GroupID,+$H,LocID)
	.e  i preBussCode="8"  d
	..s waitnum=+##Class(web.DHCEQMessages).GetMaintMonitorNum(GroupID,busscode,UserID)			//Add By DJ 2016-05-26
	.e  d
	..s waitnum=+##Class(web.DHCEQMessages).GetBussAertNum(busscode,GroupID,UserID,RoleIDs)  //add by zx 2016-03-03 Bug ZX0035
	.s ^TempDHCEQ("ManagementMain",UserID,Job,MenuType,busstypedr)=busscode_":"_busstype_":"_waitnum
	
	//
	s MenuData=""
	s MenuType=0
	f  s MenuType=$o(^TempDHCEQ("ManagementMain",UserID,Job,MenuType)) quit:MenuType=""  d
	.s busstypedr=0
	.f  s busstypedr=$o(^TempDHCEQ("ManagementMain",UserID,Job,MenuType,busstypedr)) quit:busstypedr=""  d
	..s OneBussInfo=$g(^TempDHCEQ("ManagementMain",UserID,Job,MenuType,busstypedr))
	..
	..i MenuData=""  d
	...s MenuData=MenuType_":"_busstypedr_":"_OneBussInfo
	..e  d
	...s MenuData=MenuData_"^"_MenuType_":"_busstypedr_":"_OneBussInfo
	
	//资产信息
	s EquipID=0
	f  s EquipID=$o(^DHCEQEquip(EquipID))  quit:EquipID=""  d
	.s (DataList,EQStatus,EQStockStatus,StoreLocID,EquipTypeID,ABCType,MasterItem,OriginalFee,MaintInfo,MaintFlag,ActionID)=""
	.s DataList=$g(^DHCEQEquip(EquipID))
	.q:$p(DataList,"^", 59)="Y" 			//无效标识
	.s EQStatus=$p(DataList,"^", 38) 			//状态
	.q:EQStatus>2
	.s EQStockStatus=$p(DataList,"^", 60) 	//库房状态
	.q:EQStockStatus'=1
	.s StoreLocID=$p(DataList,"^", 67) 		//科室
	.//q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID))) //2010-10-29 DJ
	.s EquipTypeID=$p(DataList,"^", 63) 	//设备类组
	.q:(EquipTypeID'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeID,GroupID))
	.
	.//查看资产总体情况,按照ABC分类来统计
	.s MasterItem=$p(DataList,"^",7)   		//设备项
	.s OriginalFee=$p(DataList,"^", 27) 	//设备原值
	.s TotalQty=TotalQty+1					//设备总数
	.s TotalOriginalFee=TotalOriginalFee+OriginalFee			//设备总金额
	.s ABCType=$p(DataList,"^",2)   		//ABCType
	.i ABCType'="" d
	..s ^TempDHCEQ("ManagementMain",UserID,Job,"ABCTypeQty",ABCType)=$g(^TempDHCEQ("ManagementMain",UserID,Job,"ABCTypeQty",ABCType))+OriginalFee
	.
	.//查看维修情况
	.s MaintInfo=##Class(web.DHCEQMessages).GetOneObjMaintInfo(1,EquipID)
	.i MaintInfo'="" d
	..s MaintFlag=$p(MaintInfo,"^",1)
	..s ActionID=$p(MaintInfo,"^",2)
	..q:ActionID="" //add by zx 2017-02-22
	..i MaintFlag=1  d
	...//s MaintQty=MaintQty+1
	...s ^TempDHCEQ("ManagementMain",UserID,Job,"ActionQty",ActionID)=$g(^TempDHCEQ("ManagementMain",UserID,Job,"ActionQty",ActionID))+1
	...//s AvailabilityRate=##Class(web.DHCEQCommon).FormatNumber(MaintQty/TotalQty*100,"",2)_"%"	//完好率
	.
#;	.//查看急救设备情况 add by zx 2017-01-04 ZX0036 急救设备按状态统计
#;	.s RentFlag=##Class(web.DHCEQEquipRent).CheckEquipIsInRent(EquipID)
#;	.i RentFlag=0  d
#;	..s TempDate=$g(^TempDHCEQ("ManagementMain",UserID,Job,"EmergencyControl",MasterItem))
#;	..s RentTotal=+$p(TempDate,"-",1)
#;	..s RentToLoc=+$p(TempDate,"-",2)
#;	..s UnusualRent=+$p(TempDate,"-",3)
#;	..;s ^TempDHCEQ("ManagementMain",UserID,Job,"EmergencyControl",MasterItem)=$g(^TempDHCEQ("ManagementMain",UserID,Job,"EmergencyControl",MasterItem))+1
#;	..s RentTotal=RentTotal+1
#;	..//add by zx 2017-08-01 begin 需求号:401650
#;	..s UnusualStatus=+$p(DataList,"^", 93)
#;	..i UnusualStatus>0 d
#;	...s UnusualRent=UnusualRent+1
#;	..e  d
#;	...s RentStatus=$p(DataList,"^", 87)
#;	...i RentStatus=1 d
#;	....s RentToLoc=RentToLoc+1
#;	..//add by zx 2017-08-01 end
#;	..s ^TempDHCEQ("ManagementMain",UserID,Job,"EmergencyControl",MasterItem)=RentTotal_"-"_RentToLoc_"-"_UnusualRent
	
	//Add By DJ 2017-08-31  进半年内每月资产新增情况及月结情况
	s YearMonthCount=0
	s CurYear=""
	f  s CurYear=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear),-1)  q:(CurYear="")||(YearMonthCount>=6)  d
	.s CurMonth=""
	.f  s CurMonth=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear,CurMonth),-1)  q:(CurMonth="")||(YearMonthCount>=6)  d
	..s YearMonthCount=YearMonthCount+1
	..s BeginTotalFee=0
	..s EndTotalFee=0
	..s InStockFee=0
	..s EquipTypeDR=0
	..f  s EquipTypeDR=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear,CurMonth,EquipTypeDR))  q:EquipTypeDR=""  d
	...s MRLRowID=0
	...f  s MRLRowID=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear,CurMonth,EquipTypeDR,MRLRowID))  q:MRLRowID=""  d
	....s BeginTotalFee=BeginTotalFee+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",6)+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",13)
	....s EndTotalFee=EndTotalFee+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",12)+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",19)
	....s InStockFee=InStockFee+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",7)
	..s ^TempDHCEQ("ManagementMain",UserID,Job,"EmergencyControl",CurYear_"-"_CurMonth)=BeginTotalFee_"-"_InStockFee_"-"_EndTotalFee
	
	//维修监控信息
	s MaintMonitorData=""
	s ActionID=0
	f  s ActionID=$o(^TempDHCEQ("ManagementMain",UserID,Job,"ActionQty",ActionID)) quit:ActionID=""  d
	.s ActionQty=+$g(^TempDHCEQ("ManagementMain",UserID,Job,"ActionQty",ActionID))
	.s ActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",2)
	.//Modify by zx 2022-07-21 
	.s ActionCode=$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",1)
	.i MaintMonitorData=""  d
	..s MaintMonitorData=ActionDesc_":"_ActionQty_":"_ActionCode
	.e  d
	..s MaintMonitorData=MaintMonitorData_"^"_ActionDesc_":"_ActionQty_":"_ActionCode
	
#;	//add by zx 2017-04-01 需求号 357255 begin
#;	//急救设备信息 add by zx 2017-01-04 急救设备按状态统计 ZX0036
#;	s EmergencyControlData=""
#;	s MasterItem=0
#;	f  s MasterItem=$o(^TempDHCEQ("ManagementMain",UserID,Job,"EmergencyControl",MasterItem)) quit:MasterItem=""  d
#;	.s MasterItemQty=$g(^TempDHCEQ("ManagementMain",UserID,Job,"EmergencyControl",MasterItem))
#;	.s StockRent=$p(MasterItemQty,"-",1)-$p(MasterItemQty,"-",2)-$p(MasterItemQty,"-",3)
#;	.i +StockRent<1 s StockRent=0
#;	.s MasterItemQty=(+$p(MasterItemQty,"-",2))_"-"_(+$p(MasterItemQty,"-",3))_"-"_StockRent
#;	.i EmergencyControlData'="" s EmergencyControlData=EmergencyControlData_"^"
#;	.s EmergencyControlData=EmergencyControlData_$p($g(^DHCEQCCode("DHCEQCMasterItem",MasterItem)),"^",1)_":"_MasterItemQty
#;	.s ^TempDHCEQ("EmergencyControlData",MasterItem)=$p($g(^DHCEQCCode("DHCEQCMasterItem",MasterItem)),"^",1)_":"_MasterItemQty
	
	s EmergencyControlData=""
	s YearMonth=""
	f  s YearMonth=$o(^TempDHCEQ("ManagementMain",UserID,Job,"EmergencyControl",YearMonth)) quit:YearMonth=""  d
	.s YearMonthInfo=$g(^TempDHCEQ("ManagementMain",UserID,Job,"EmergencyControl",YearMonth))
	.i EmergencyControlData'="" s EmergencyControlData=EmergencyControlData_"^"
	.s EmergencyControlData=EmergencyControlData_YearMonth_":"_YearMonthInfo
	
	/*
	.i EmergencyControlData=""  d
	..s StockRent=$p(MasterItemQty,"-",1)-$p(MasterItemQty,"-",2)-$p(MasterItemQty,"-",3)
	..s MasterItemQty=$p(MasterItemQty,"-",2)_"-"_$p(MasterItemQty,"-",3)_"-"_StockRent
	..s EmergencyControlData=$p($g(^DHCEQCCode("DHCEQCMasterItem",MasterItem)),"^",1)_":"_MasterItemQty
	.e  d
	..s StockRent=$p(MasterItemQty,"-",1)-$p(MasterItemQty,"-",2)-$p(MasterItemQty,"-",3)
	..s MasterItemQty=$p(MasterItemQty,"-",2)_"-"_$p(MasterItemQty,"-",3)_"-"_StockRent
	..s EmergencyControlData=EmergencyControlData_"^"_$p($g(^DHCEQCCode("DHCEQCMasterItem",MasterItem)),"^",1)_":"_MasterItemQty
	*/
	//s EmergencyControlData="电脑:10^空调:20^空调2:30^空调3:40^空调4:50^空调5:60^空调6:120^空调7:170^空调8:190^空调9:330^空调10:330^空调11:3030"
	//add by zx 2017-04-01 需求号 357255 end
	
	//abc分类信息
	s ABCTypeData=""
	s ABCType=0
	f  s ABCType=$o(^TempDHCEQ("ManagementMain",UserID,Job,"ABCTypeQty",ABCType)) quit:ABCType=""  d
	.s ABCTypeQty=$g(^TempDHCEQ("ManagementMain",UserID,Job,"ABCTypeQty",ABCType))
	.i ABCTypeData=""  d
	..s ABCTypeData=ABCType_"类:"_ABCTypeQty
	.e  d
	..s ABCTypeData=ABCTypeData_"^"_ABCType_"类:"_ABCTypeQty
	
	k ^TempDHCEQ("ManagementMain",UserID)
	s ManagementData=TotalQty_":"_TotalOriginalFee_"&"_MaintMonitorData_"&"_EmergencyControlData_"&"_ABCTypeData_"&"_MenuData
	q ManagementData
}

/// add by zy 2016-09-20
/// 查看维修对象当前的维修单状态,下一步的动作是什么
/// w ##Class(web.DHCEQMessages).GetOneObjMaintInfo(1,14)
ClassMethod GetOneObjMaintInfo(SourceType, SourceID)
{
	new MaintFlag,ActionID
	new MExObjID,MMRowID,MMDataList,ApproveInfoID,ApproveSetDR,NextFlowStep,ApproveFlowDR
	s (MaintFlag,ActionID)=""
	s MExObjID=$o(^DHCEQMExObj(0,"ExID",SourceType,SourceID,0))
	
	i MExObjID'="" d
	.s MMRowID=0
	.f  s MMRowID=$o(^DHCEQMMaintRequest(0,"Source",SourceType,MExObjID,MMRowID)) q:MMRowID=""  d
	..s MMDataList=$g(^DHCEQMMaintRequest(MMRowID))
	..q:($p(MMDataList,"^",57)="Y")	//无效标记
	..q:($p(MMDataList,"^",41)'=1)		//状态,监控提交的单据
	..s MaintFlag=1
	..s ActionDesc="提交"
	..s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",25,MMRowID,0))
	..q:ApproveInfoID=""
	..s ApproveSetDR=$p($g(^DHCEQApproveInfo(ApproveInfoID)),"^",3)
	..s NextFlowStep=$p($g(^DHCEQApproveInfo(ApproveInfoID)),"^",5)
	..s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,NextFlowStep,0))
	..q:ApproveFlowDR=""
	..s ActionID=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR),"^",9)
	..//i ActionID'=""  d
	..//.s ActionDesc=$p(^DHCEQCCode("DHCEQCAction",ActionID),"^",2)
	
	i MaintFlag=1 q MaintFlag_"^"_ActionID
	q ""
}

/// Add By DJ 2016-11-29
/// 描述:补发消息
/// 入参:vBussType业务类型, vBussID业务RowID
ClassMethod MessageSendAgain(vBussType As %String = "", vBussID As %String = "")
{
	i ((vBussType="")||(vBussID="")) q "业务类型代码及业务ID不能为空!"
	s BussInfo=""
	i vBussType="31" s BussInfo="维修单号:【"_$p($g(^DHCEQMMaintRequest(vBussID)),"^",1)_"】"
	i vBussType="64" s BussInfo="租赁单号:【"_$p($g(^DHCEQRent(vBussID)),"^",1)_"】"
	
	i BussInfo="" q "处理业务单据不存在!请检查!"	
	s MRowID=$o(^DHCEQMessages(0,"MessageType",1,vBussType,vBussID,""),-1)
	i '$D(^DHCEQMessages(MRowID,"EX")) q "该业务单无法进行补发消息处理!"
	w BussInfo,!
	w "请确认是否补发消息?是则输入g,取消则输入q,然后回车!"
	b
	s User=$p($g(^DHCEQMessages(MRowID)),"^",15)		//SendUserDR
	s ApproveFlowInfo=$g(^DHCEQMessages(MRowID,"EX","ApproveFlowInfo"))
	s RefuseFlag=$g(^DHCEQMessages(MRowID,"EX","RefuseFlag"))
	s CurRole=$g(^DHCEQMessages(MRowID,"EX","CurRole"))
	s AuditFlag=$g(^DHCEQMessages(MRowID,"EX","AuditFlag"))
	s GroupID=$g(^DHCEQMessages(MRowID,"EX","GroupID"))
	s LimitActions=$g(^DHCEQMessages(MRowID,"EX","LimitActions"))
	s LimitUserDR=$g(^DHCEQMessages(MRowID,"EX","LimitUserDR"))
	s LimitLocActions=$g(^DHCEQMessages(MRowID,"EX","LimitLocActions"))
	s LimitLocDR=$g(^DHCEQMessages(MRowID,"EX","LimitLocDR"))
	TSTART
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo(vBussType, vBussID, User, ApproveFlowInfo, "N",CurRole,AuditFlag,GroupID,LimitActions,LimitUserDR,LimitLocActions,LimitLocDR)
	i SQLCODE
	{
		TROLLBACK
		q "补发消息失败:"_SQLCODE
	}
	TCOMMIT
	q "补发成功!"
}

/// Add by DJ 2016-12-27
/// 将ApproveType转换成对应的BussType
/// w ##Class(web.DHCEQMessages).GetMsgTypeByApproveType("25") 
ClassMethod GetMsgTypeByApproveType(ApproveType)
{
	;MsgType
	;0：无 11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用、51设备调帐 52设备台帐 
	;61工程管理 62科研课题 63证件 63-1供应商资质 63-2生产厂商资质 63-3计量证书 64租赁 71保养预警 72检查预警 72-1计量检查 72-2巡检 73保修到期 81维修监控 82设备鉴定报告 91采购申请 92采购计划 93采购招标 94采购合同 95保修合同
	;以下尚无审批流：32保养、33检查、35折旧、41使用、51设备调帐 52设备台帐 62科研课题 63证件 63-1供应商资质 63-2生产厂商资质 63-3计量证书  71保养预警 72检查预警 72-1计量检查 72-2巡检 73保修到期 81维修监控 
	;A01:配件入库  A02:配件转移  A03:配件退货  A04:配件减少  //add by zx 2016-03-04 增加配件处理
	
	;ApproveType
	;1	采购申请,2	采购计划,3	设备论证,4	采购审批,5	报废申请,6	调试验收,7	开箱验收,8	采购合同,9	委外申请,
	;10	备件入库,11	备件转移,12	年度计划分配,13	设备入库,14	设备转移,15	退货,16	设备维修,17	招标审批设置,18	工程管理,19	付款审批,
	;20	研究课题,21	备件退货,22	洗涤单,23	销毁更换单,24	车辆派遣,25	新设备维修,26	综合使用评价表,27	技术评估表,28	评价调查表,29	不良事件表,30	租赁管理,
	;31 设备配送,32 发票审批处理,33 设备鉴定报告
	if (ApproveType="") q ""
	q $CASE(ApproveType,
			  "1":"91","2":"92","5":"34","8":"94",
			  "13":"21","14":"22","15":"23",
              "25":"31","18":"61","30":"64","33":"82",:"")
}

/// add by zx 2017-02-24
/// 通过消息发送定义表判断消息生成时是否生成消息发送信息
/// 返回值为0是表示允许 为1时表示拒绝 
/// 入参 业务类型：BussType, 来源角色：FromRole, 来源动作：FromAction, 指向角色：ToRole, 指向动作ToAction
/// add by zx 2021-05-07 BUG ZX0133 增加Type参数 判断是否按照审批流发消息 0 不按照审批流 1 按照审批流
/// w ##Class(web.DHCEQMessages).CheckMessageSendDefine("31","","","19","2","1")
ClassMethod CheckMessageSendDefine(BussType, FromRole As %String = "", FromAction As %String = "", ToRole As %String = "", ToAction As %String = "", Type As %String = "")
{
    n DefineResult,SendDefine,DefineFromRole,DefineFromAction,DefineToRole,DefineToAction
    s (DefineFromRole,DefineFromAction,DefineToRole,DefineToAction)=""
    s DefineResult=0
    s SendDefineID=0
    f  s SendDefineID=$o(^DHCEQMessageSendDefine(0,"DefineType","1",BussType,SendDefineID)) q:(SendDefineID="")||(DefineResult'=0)  d
    .s DefineFromRole=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",5)
    .q:(FromRole'="")&&(FromRole'=DefineFromRole)
    .s DefineFromAction=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",6)
    .q:(FromAction'="")&&(FromAction'=DefineFromAction) 
    .s DefineToRole=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",7)
    .q:(ToRole'="")&&((","_ToRole_",")'[(","_DefineToRole_","))
    .s DefineToAction=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",8)
    .q:(Type="0")&&(DefineToAction'="")
    .q:(Type="1")&&(ToAction'="")&&((","_ToAction_",")'[(","_DefineToAction_","))
    .s DefineResult=SendDefineID
    
    q DefineResult
}

/// add by zx 2017-02-24
/// 获取人员电话
/// w ##Class(web.DHCEQMessages).GetTypeEmployeeTel(3934)
ClassMethod GetTypeEmployeeTel(Employee)
{
	n TypeEmployeeID,TEmployee,Tel
	s Tel=""
	s TypeEmployeeID=0
	f  s TypeEmployeeID=$o(^DHCEQCCode("DHCEQCTypeEmployee",TypeEmployeeID)) q:TypeEmployeeID=""  d
	.s TEmployee=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",TypeEmployeeID)),"^",2)
	.q:Employee'=TEmployee
	.s Tel=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",TypeEmployeeID)),"^",5)
	q Tel
}

/// add by zx 2017-03-01
/// 根据安全组分配角色，判断消息发送角色是否符合
/// 返回权限值_"^"_动作代码串_"^"_动作描述串  权限值为1表示符合 为0表示不符合
/// w ##Class(web.DHCEQMessages).CheckMessageRoles(84,3802,4181)
/// add by zx 2017-08-24 BUG ZX0045 加入GroupRoles参数优化速率
ClassMethod CheckMessageRoles(GroupID, UserID, MsgID, GroupRoles As %String = "")
{
    new resultFlag,MRIRowID,MRIRoles,MRIRole,MRIActionIDs,MRIActionDesc,MRIActionCode,MRIActionID,MRIActionRole,ResActionCode,ResActionDesc,ResActionID,ResActionRole
    s (MRIRoles,MRIRole,MRIActionIDs,MRIActionDesc,MRIActionCode,MRIActionID,MRIActionRole,ResActionCode,ResActionDesc,ResActionID,ResActionRole)=""
    i GroupRoles="" s GroupRoles=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
    i GroupRoles="" q "0^^^^"
    s resultFlag=0
    //add by zx 2017-08-24 优化代码 同一消息只给同一人发送一次
    s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID,"")) 
    i MRIRowID="" q "0^^^^"
    ;f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID,MRIRowID)) q:(MRIRowID="")  d
    s MRIRoles=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",4)
    s MRIActionIDs=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",10)
    i (MRIRoles="")&&(MRIActionIDs="") q "0^^^^"		//Modify DJ 2017-09-20
    
    s RoleLen=$L(MRIRoles,",")	//add by zx 2017-09-20 BUG ZX0046
    f i=1:1:RoleLen  d
    .s MRIActionRole=$p(MRIRoles,",",i)
    .q:(MRIActionRole'="")&&(MRIActionRole'="0")&&((","_GroupRoles_",")'[(","_MRIActionRole_","))  //消息中包含动作需再一次根据角色权限过滤 //modify by zyq 2022-11-20 不过滤被退回的
    .s resultFlag=1
    .i MRIActionIDs'=""  d
    ..s MRIActionID=$p(MRIActionIDs,",",i)
    ..i MRIActionID="0" d
    ...s MRIActionDesc="提交"
    ...s MRIActionCode="Submit"
    ..e  d 
    ...s MRIActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",MRIActionID)),"^",2)
    ...s MRIActionCode=$p($g(^DHCEQCCode("DHCEQCAction",MRIActionID)),"^",1)
    .s ResActionCode=ResActionCode_","_MRIActionCode
    .s ResActionDesc=ResActionDesc_","_MRIActionDesc
    .s ResActionID=ResActionID_","_MRIActionID
    .s ResActionRole=ResActionRole_","_MRIActionRole
    
    q resultFlag_"^"_ResActionCode_"^"_ResActionDesc_"^"_ResActionID_"^"_ResActionRole
}

/// BussType:11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用、51设备调帐、A01配件入库、A02配件转移、A03配件退货、A04配件减少
/// w ##Class(web.DHCEQMessages).CheckEquipIsInBuss("64",1,2)
/// EquipID是否在业务单据中，0：不是，1：是
ClassMethod CheckEquipIsInBuss(BussType, BussID, EquipID)
{
    n OpenCheckListDR,OpenCheckDR,InStockListDR,InStockDR,SMLDR,RowIDs,EquipDR,ReturnListDR,ExObjDR,SourceTypeDR,ItemID,MasterItemDR,ContractListDR,ContractDR
    s (OpenCheckListDR,OpenCheckDR,InStockListDR,InStockDR,SMLDR,RowIDs,EquipDR,ReturnListDR,ExObjDR,SourceTypeDR,ItemID,MasterItemDR,ContractListDR,ContractDR)=""
    
    s Flag=0
    if BussType="11"
    {
        s OpenCheckListDR=$p($g(^DHCEQEquip(EquipID)),"^",77)
        .i OpenCheckListDR'="" d
        ..s OpenCheckDR=$p($g(^DHCEQOpenCheckList(OpenCheckListDR)),"^",1)
        ..i OpenCheckDR=BussID  s Flag=1
    } 
    elseif BussType="21"
    {
        s OpenCheckListDR=$p($g(^DHCEQEquip(EquipID)),"^",77)
        i OpenCheckListDR'="" d
        .s InStockListDR=$o(^DHCEQInStockList(0,"Source",2,OpenCheckListDR,0))
        .i InStockListDR'="" d
        ..s InStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
        ..i InStockDR=BussID  s Flag=1
    }
    elseif BussType="22"
    {
        s SMLDR=0
        f  s SMLDR=$o(^DHCEQStoreMoveList(0,"StoreMove",BussID,SMLDR)) q:SMLDR=""  d
        .s RowIDs=$g(^DHCEQStoreMoveList(SMLDR,"EX","RowIDs"))
        .s len=$l(RowIDs,",")
        .f i=1:1:len d
        ..s EquipDR=$p(RowIDs,",",i)
        ..i EquipDR=EquipID s Flag=1
    }
    elseif BussType="23"
    {
        s ReturnListDR=0
        f  s ReturnListDR=$o(^DHCEQReturnList(0,"Return",BussID,ReturnListDR)) q:ReturnListDR=""  d
        .s RowIDs=$g(^DHCEQReturnList(ReturnListDR,"EX","RowIDs"))
        .s len=$l(RowIDs,",")
        .f i=1:1:len d
        ..s EquipDR=$p(RowIDs,",",i)
        ..i EquipDR=EquipID s Flag=1
        
    }
    elseif BussType="31"
    {
        s ExObjDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",5)
        s SourceTypeDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",63)
        i ExObjDR'="" d
        .i SourceTypeDR=1  d
        ..s EquipDR=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
        ..i EquipDR=EquipID s Flag=1
        .e  i SourceTypeDR=2  d
        ..s ItemID=ExObjDR
        ..s MasterItemDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",7)
        ..i ItemID=MasterItemDR s Flag=1
        .;modified by wy 2022-4-13
        .e  i SourceTypeDR=3  d
        ..s ItemID=ExObjDR
        ..s MasterItemDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",7)
        ..i ItemID=MasterItemDR s Flag=1
    }
    elseif BussType="34"
    {
        s RowIDs=+##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(BussID)
        i RowIDs'="" d
        .s len=$l(RowIDs,",")
        .f i=1:1:len d
        ..s EquipDR=$p(RowIDs,",",i)
        ..i EquipDR=EquipID s Flag=1
    }
    elseif BussType="64"
    {
        
        s EquipDR=$p($g(^DHCEQRent(BussID)),"^",9)
        i EquipDR=EquipID s Flag=1
    }
    elseif BussType="94"
    {
        s ContractListDR=0
        f  s ContractListDR=$o(^DHCEQContactList(0,"SourceID",2,EquipID,ContractListDR)) q:ContractListDR=""  d
        .s ContractDR=$p($g(^DHCEQContractList(ContractListDR)),"^",1)
        .i ContractDR=BussID s Flag=1
    }
    else
    {
        q 0
    }
    
    quit Flag
}

/// BussType:11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用、51设备调帐、A01配件入库、A02配件转移、A03配件退货、A04配件减少
/// w ##Class(web.DHCEQMessages).GetBussInfoByEquip("64",1,2)
ClassMethod GetBussInfoByEquip(BussType, BussID, EquipID)
{
    new No,BussIDList,Name,EquipDR,ExObjDR,ObjLocDR,SourceTypeDR,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BussStatus,BussInvalidFlag,BStatus,LastHandlerDR,LastHandler,BussAuditDate,RequestUser,FaultCase,StartDate,planEndDate  //modify by lmm 355243
    s (No,BussIDList,Name,EquipDR,ExObjDR,ObjLocDR,SourceTypeDR,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BussStatus,BussInvalidFlag,BStatus,LastHandlerDR,LastHandler,BussAuditDate,RequestUser,FaultCase,StartDate,planEndDate)=""   //modify by lmm 355243
    
    new EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,EquipNo,FileNo //add by zx 2016-12-13 增加设备编号和档案号输出 ZX0036
    s (EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,ApproveUser,ApproveUserDR,EquipNo,FileNo,Model)=""
    
    //Add by wsp 2016-4-1 添加最后一次动作
    s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType) //add by zx 2016-11-25 上一步审批信息获取调整 ZX0036
    s LastOperate=##Class(web.DHCEQApproveList).GetLastApproveListOpinion(ApproveType,BussID)
    s LastOperate=$p(LastOperate,"^",2)_$p(LastOperate,"^",3)_" "_$p(LastOperate,"^",4)
    
    ;s ^CZF("rent")=BussType_"^"_BussID_"^"_EquipID
    if BussType="21"
    {
        s OpenCheckListDR=$p($g(^DHCEQEquip(EquipID)),"^",77)
        i OpenCheckListDR'="" d
        .s InStockListDR=$o(^DHCEQInStockList(0,"Source",2,OpenCheckListDR,0))
        .i InStockListDR'="" d
        ..s InStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
        ..q:InStockDR'=BussID
        ..i InStockDR'="" d
        ...s Date=$p($g(^DHCEQInStock(InStockDR)),"^",1)
        ...s No=$p($g(^DHCEQInStock(InStockDR)),"^",14)
        ...s BussStatus=$p($g(^DHCEQInStock(InStockDR)),"^",10)
        ...s BussInvalidFlag=$p($g(^DHCEQInStock(InStockDR)),"^",25)
        ...s EquipTypeDR=$p($g(^DHCEQInStock(InStockDR)),"^",20)
        ...s StatCatDR=$p($g(^DHCEQInStock(InStockDR)),"^",21)
        ...s BussAuditDate=$p($g(^DHCEQInStock(InStockDR)),"^",13)
        ...s Name=$p($g(^DHCEQInStockList(InStockListDR)),"^", 5)
        ...s LastHandlerDR=$p($g(^DHCEQInStock(BussID)),"^",4)
        ...i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
        ...d GetEquipInfo
    }
    elseif BussType="22"
    {
        s SMLDR=0
        f  s SMLDR=$o(^DHCEQStoreMoveList(0,"StoreMove",BussID,SMLDR)) q:SMLDR=""  d
        .s RowIDs=$g(^DHCEQStoreMoveList(SMLDR,"EX","RowIDs"))
        .s len=$l(RowIDs,",")
        .f i=1:1:len d
        ..s EquipDR=$p(RowIDs,",",i)
        ..q:EquipDR'=EquipID
        ..s Date=$p($g(^DHCEQStoreMove(BussID)),"^",5)
        ..s No=$p($g(^DHCEQStoreMove(BussID)),"^",1)
        ..s BussStatus=$p($g(^DHCEQStoreMove(BussID)),"^",13)
        ..s BussInvalidFlag=$p($g(^DHCEQStoreMove(BussID)),"^",27)
        ..s FromLoc = $p($g(^DHCEQStoreMove(BussID)),"^",2)
        ..s ToLoc  = $p($g(^DHCEQStoreMove(BussID)),"^",3)
        ..s MoveType =$CASE($p($g(^DHCEQStoreMove(BussID)),"^",12),"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配",:"没有定义")    
        ..s EquipTypeDR=$p($g(^DHCEQStoreMove(BussID)),"^",16)
        ..s StatCatDR=$p($g(^DHCEQStoreMove(BussID)),"^",17)
        ..s BussAuditDate=$p($g(^DHCEQStoreMove(BussID)),"^",19)
        ..s Name=$p($g(^DHCEQStoreMoveList(SMLDR)),"^", 5)
        ..s LastHandlerDR=$p($g(^DHCEQStoreMove(BussID)),"^",4)
        ..i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
        ..d GetEquipInfo
    }
    elseif BussType="23"
    {
        s ReturnListDR=0
        f  s ReturnListDR=$o(^DHCEQReturnList(0,"Return",BussID,ReturnListDR)) q:ReturnListDR=""  d
        .s RowIDs=$g(^DHCEQReturnList(ReturnListDR,"EX","RowIDs"))
        .s len=$l(RowIDs,",")
        .f i=1:1:len d
        ..s EquipDR=$p(RowIDs,",",i)
        ..q:EquipDR'=EquipID
        ..s Date=$p($g(^DHCEQReturn(BussID)),"^",4)
        ..s No=$p($g(^DHCEQReturn(BussID)),"^",1)
        ..s BussStatus=$p($g(^DHCEQReturn(BussID)),"^",13)
        ..s BussInvalidFlag=$p($g(^DHCEQReturn(BussID)),"^",28)
        ..s OutType=$p($g(^DHCEQCCode("DHCEQCOutType",$p($g(^DHCEQReturn(BussID)),"^",17))),"^",2)
        ..s EquipTypeDR=$p($g(^DHCEQReturn(BussID)),"^",15)
        ..s StatCatDR=$p($g(^DHCEQReturn(BussID)),"^",16)
        ..s BussAuditDate=$p($g(^DHCEQReturn(BussID)),"^",11)
        ..s Name=$p($g(^DHCEQEquip(EquipID)),"^", 1)
        ..s LastHandlerDR=$p($g(^DHCEQReturn(BussID)),"^",5)
        ..i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
        ..d GetEquipInfo
        
    }
    elseif BussType="31"
    {
        s ExObjDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",5)
        s SourceTypeDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",63)
        i ExObjDR'="" d
        .i SourceTypeDR=1  d
        ..s EquipDR=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
        ..q:EquipDR'=EquipID
        ..;s Name=$Piece($Get(^DHCEQEquip(EquipDR)),"^",1)
        ..d GetMMaintRequestInfo
        ..d GetEquipInfo
        .e  i SourceTypeDR=2  d  //add by zx 2016-06-15
        ..s ItemID=ExObjDR
        ..s MasterItemDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",7)
        ..q:ItemID'=MasterItemDR
        ..;s Name=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",1)
        ..d GetMMaintRequestInfo
        ..d GetEquipInfo        
        .e  i SourceTypeDR=3  d  //add by zx 2016-06-15 modified by wy 2022-4-13
        ..s ItemID=ExObjDR
        ..s MasterItemDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",7)
        ..q:ItemID'=MasterItemDR
        ..;s Name=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",1)
        ..d GetMMaintRequestInfo
        ..d GetEquipInfo

    }
    elseif BussType="34"
    {
        s RowIDs=+##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(BussID)
        i RowIDs'="" d
        .s len=$l(RowIDs,",")
        .f i=1:1:len d
        ..s EquipDR=$p(RowIDs,",",i)
        ..q:EquipDR'=EquipID
        ..s Date=$p($g(^DHCEQDisuseRequest(BussID)),"^",4)
        ..s BussStatus=$p($g(^DHCEQDisuseRequest(BussID)),"^",10)
        ..s BussInvalidFlag=$p($g(^DHCEQDisuseRequest(BussID)),"^",53)
        ..s No=$p($g(^DHCEQDisuseRequest(BussID)),"^",33)
        ..s RequestLoc=$p($g(^DHCEQDisuseRequest(BussID)),"^",3)
        ..s Name=$Piece($Get(^DHCEQEquip(EquipDR)),"^",1)       
        ..s BussAuditDate=$p($g(^DHCEQDisuseRequest(BussID)),"^",21)
        ..s LastHandlerDR=$p($g(^DHCEQDisuseRequest(BussID)),"^",17)
        ..i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
        ..d GetEquipInfo
    }
    elseif BussType="94"
    {
        s ContractListDR=0
        f  s ContractListDR=$o(^DHCEQContactList(0,"SourceID",2,EquipID,ContractListDR)) q:ContractListDR=""  d
        .s ContractDR=$p($g(^DHCEQContractList(ContractListDR)),"^",1)
        .q:ContractDR'=BussID
        .s No=$p($g(^DHCEQContract(BussID)),"^",2)
        .s Name=$p($g(^DHCEQContract(BussID)),"^",1)
        .s BussInvalidFlag="N"
        .s BussStatus=$p($g(^DHCEQContract(BussID)),"^",24)
        .s Date=$p($g(^DHCEQContract(BussID)),"^",27)
        .s LastHandlerDR=$p($g(^DHCEQContract(BussID)),"^",26)
        .i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
        .d GetEquipInfo
    }
    elseif BussType="64" //租赁 add by zx 2016-11-03 增加租赁消息读取处理 ZX0036
    {
        
        s EquipDR=$p($g(^DHCEQRent(BussID)),"^",9)
        i EquipDR'="" d
        .q:EquipDR'=EquipID
        .s Date=$p($g(^DHCEQRent(BussID)),"^",5)
        .s No=$p($g(^DHCEQRent(BussID)),"^",1)
        .s BussStatus=$p($g(^DHCEQRent(BussID)),"^",36)
        .;i BussStatus="2" s BussStatus="1" //已借出
        .;i BussStatus="3" s BussStatus="2" //已归还
        .s BussInvalidFlag="N"
        .s ItemDR=$p($g(^DHCEQRent(BussID)),"^",7)
        .i ItemDR'="" d
        ..s Name=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1)
        ..s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
        ..s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
        .s FromLoc=$p($g(^DHCEQRent(BussID)),"^",3)
        .s RequestLoc=$p($g(^DHCEQRent(BussID)),"^",2)
        .s StartDate=$p($g(^DHCEQRent(BussID)),"^",10)    ///add by lmm 355243
        .s planEndDate=$p($g(^DHCEQRent(BussID)),"^",12)    ///add by lmm 355243
        .s BussAuditDate=$p($g(^DHCEQRent(BussID)),"^",23)
        .s LastHandlerDR=$p($g(^DHCEQRent(BussID)),"^",4)
        .i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
        .d GetEquipInfo
    }
    quit No_"^"_Name_"^"_RequestLoc_"^"_Date_"^"_UseLoc_"^"_FromLoc_"^"_ToLoc_"^"_MoveType_"^"_OutType_"^"_ContractNo_"^"_EquipID_"^"_BussStatus_"^"_BussInvalidFlag_"^"_BStatus_"^"_EquipTypeDR_"^"_StatCatDR_"^"_EquipCatDR_"^"_ItemDR_"^"_LastHandlerDR_"^"_LastHandler_"^"_LastOperate_"^"_BussAuditDate_"^"_EquipNo_"^"_FileNo_"^"_Model_"^"_RequestUser_"^"_FaultCase_"^"_StartDate_"^"_planEndDate  //modify by lmm 355243
    
GetMMaintRequestInfo
        s No=$p($g(^DHCEQMMaintRequest(BussID)),"^",1)
        s Name=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",1)
        s BussStatus=$p($g(^DHCEQMMaintRequest(BussID)),"^",41)
        s LastHandlerDR=$CASE(BussStatus,0:$p($g(^DHCEQMMaintRequest(BussID)),"^",42),1:$p($g(^DHCEQMMaintRequest(BussID)),"^",48),2:$p($g(^DHCEQMMaintRequest(BussID)),"^",51))  //add by wsp 2016-3-22
        i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)  //add by wsp 增加最后操作人的信息2016-3-22
        s BussInvalidFlag=$p($g(^DHCEQMMaintRequest(BussID)),"^",57)
        s RequestLoc=+$p($g(^DHCEQMMaintRequest(BussID)),"^",7)
        s Date=$p($g(^DHCEQMMaintRequest(BussID)),"^",18)
        s UseLoc=$p($g(^DHCEQMMaintRequest(BussID)),"^",6)
        s BussAuditDate=$p($g(^DHCEQMMaintRequest(BussID)),"^",52)
        s RequestUser=$p($g(^DHCEQMMaintRequest(BussID)),"^",20)
        i RequestUser'="" s RequestUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", RequestUser)
        s Tel=$p($g(^DHCEQMMaintRequest(BussID)),"^",21)
        i Tel'="" s RequestUser=RequestUser_"("_Tel_")"
        s FaultCase=$p($g(^DHCEQMMaintRequest(BussID)),"^",10)
        i FaultCase'="" s FaultCase=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FaultCase)),"^",2)
        s FaultCaseRemark=$p($g(^DHCEQMMaintRequest(BussID)),"^",11)
        i FaultCase'="" d
        .i FaultCaseRemark'="" s FaultCase=FaultCase_"("_FaultCaseRemark_")"
        e  d
        .s FaultCase=FaultCaseRemark
        quit
        
GetEquipInfo
    i EquipID="" quit
    s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
    s StatCatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)
    s EquipCatDR=$p($g(^DHCEQEquip(EquipID)),"^",4)
    s ItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
    s EquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
    s FileNo=$p($g(^DHCEQEquip(EquipID)),"^",85)
    s Model=$p($g(^DHCEQEquip(EquipID)),"^",3)
    i Model'="" s Model=$Piece($Get(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
    s BStatus=##Class(web.DHCEQM.DHCEQMMaintRequest).GetStatus(BussStatus)
    quit
}

/// add by czf 20171120 CZF0014
/// 描述：用于微信业务单预览界面生成，根据业务类型,ID,action取得业务信息
/// 业务信息格式：单个变量格式为英文名称#中文名称#输出值,不同变量以^分隔,不同模块以$分隔
/// w ##Class(web.DHCEQMessages).GetBussInfoBySourceID("31","1","WX_Assign")
ClassMethod GetBussInfoBySourceID(BussType, BussID, Action As %String = "")
{
	n BussInfo,MaintInfo,requestinfo,assigninfo,acceptinfo,LoanInfo,rentinfo,returninfo
	s (BussInfo,MaintInfo,requestinfo,assigninfo,acceptinfo,LoanInfo,rentinfo,returninfo)=""
	
	if BussType="11"     //验收
	{
		s BussInfo=##Class(web.DHCEQOpenCheckRequest).GetOneOpenCheckRequest(BussID)
	}
	elseif BussType="21"    //入库
	{
		s BussInfo=##Class(web.DHCEQInStockNew).GetOneInStock(BussID)
	}
	elseif BussType="22"    //转移
	{
		s BussInfo=##Class(web.DHCEQStoreMoveNew).GetOneStoreMove(BussID)
	}
	elseif BussType="23"    //退货减少
	{
		s BussInfo=##Class(web.DHCEQReturnNew).GetOneReturn(BussID)
	}
	elseif BussType="31"    //维修
	{
		s MaintInfo=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneMaintRequest("","",BussID,"",Action,"")
		i MaintInfo'="" d
		.s requestno="RequestNo#申请单号#"_$p(MaintInfo,"^",1)
		.s requestloc="RequestLoc#申请科室#"_$p(MaintInfo,"^",82)
		.s requestdate=$p(MaintInfo,"^",18)
		.i requestdate'="" s requestdate=$zd($zdh(requestdate,4),3)
		.s requestdate="RequestDate#申请日期#"_requestdate
		.s requestuser="RequestUser#申请人#"_$p(MaintInfo,"^",86)
		.s faultcase=$p(MaintInfo,"^",83)
		.s faultcaseremark=$p(MaintInfo,"^",11)
		.i (faultcase="")&&(faultcaseremark'="") s faultcase=faultcaseremark
    	.e  i (faultcase'="")&&(faultcaseremark="") s faultcase=faultcase
    	.e  i (faultcase'="")&&(faultcaseremark'="") s faultcase=faultcase_"("_faultcaseremark_")"
    	.s faultcase="FaultCase#故障现象#"_faultcase
		.s assign="Assign#派单人#"_$p(MaintInfo,"^",89)
    	.s assigndate=$p(MaintInfo,"^",64)
		.i assigndate'="" s assigndate=$zd($zdh(assigndate,4),3)
    	.s assigndate="AssignDate#派单日期#"_assigndate
    	.s acceptuser="AcceptUser#维修负责人#维修负责人:"_$p(MaintInfo,"^",88)
    	.s estimateworkhour="EstimateWorkHour#分配时长#分配时长:"_$p(MaintInfo,"^",38)
    	.s acceptdate=$p(MaintInfo,"^",24)
    	.i acceptdate'="" s acceptdate=$zd($zdh(acceptdate,4),3)
    	.s acceptdate="AcceptDate#受理日期#"_acceptdate
    	.s maintmode="MaintMode#维修方式#"_$p(MaintInfo,"^",90)
    	.s service="Service#服务商#"_$p(MaintInfo,"^",93)
    	.s maintfee="MaintFee#维修费#维修费:"_$p(MaintInfo,"^",58)
    	.s otherfee="OtherFee#配件费#配件费:"_$p(MaintInfo,"^",59)
    	.s totalfee="TotalFee#总费用#总费用:"_$p(MaintInfo,"^",60)
    	.s savecostfee="SaveCostFee#节省费用#节省费用:"_$p(MaintInfo,"^",71)
    	.s maintresult="MaintResult#维修结果#"_$p(MaintInfo,"^",104)
    	.s dealmethod=$p(MaintInfo,"^",85)
    	.s dealmeathodremark=$p(MaintInfo,"^",15)
    	.i (dealmethod="")&&(dealmeathodremark'="") s dealmethod=dealmeathodremark
    	.e  i (dealmethod'="")&&(dealmeathodremark="") s dealmethod=dealmeathod
    	.e  i (dealmethod'="")&&(dealmeathodremark'="") s dealmethod=dealmeathod_"("_dealmeathodremark_")"
    	.s dealmethod="DealMethod#解决方法#"_dealmethod
    	.s enddate=$p(MaintInfo,"^",16)				//完成日期
    	.i enddate'="" s enddate=$zd($zdh(enddate,4),3)
    	.s enddate="EndDate#完成日期#"_enddate
    	.s maintprocess="MaintProcess#维修进度#"_$p(MaintInfo,"^",123)
    	.s status=$p(MaintInfo,"^",41)
    	.s faulttype="FaultType#故障类型#"_$p(MaintInfo,"^",87)
    	.s faultreason=$p(MaintInfo,"^",84)
    	.s faultreasonremark=$p(MaintInfo,"^",13)
    	.i (faultreason="")&&(faultreasonremark'="") s faultreason=faultreasonremark
    	.e  i (faultreason'="")&&(faultreasonremark="") s faultreason=faultreason
    	.e  i (faultreason'="")&&(faultreasonremark'="") s faultreason=faultreason_"("_faultreasonremark_")"
    	.s faultreason="FaultReason#故障原因#"_faultreason
    	.s requestinfo="申请信息"_"^"_requestno_"^"_requestloc_"^"_requestdate_"^"_faultcase_"^"_requestuser
    	.s assigninfo="派单信息"_"^"_assign_"^"_assigndate_"^"_acceptuser_"^"_estimateworkhour
    	.s acceptinfo="受理信息"_"^"_acceptdate
    	.i (Action="")&&(status'=2) d
    	..s maintinfo="维修信息"_"^"_"MaintInfo#维修信息#维修还未完成,请耐心等待!"
    	.e  d
    	..s maintinfo="维修信息"_"^"_maintmode_"^"_service_"^"_maintfee_"^"_otherfee_"^"_totalfee_"^"_maintresult_"^"_dealmethod_"^"_enddate_"^"_maintprocess_"^"_faulttype_"^"_faultreason
    	.i Action="WX_Assign" d
    	..s BussInfo=requestinfo
    	.e  i Action="WX_Accept" d
    	..s BussInfo=requestinfo_"$"_assigninfo
    	.e  i (Action="WX_Maint")||(Action="WX_Finish")||(Action="WX_Audit")  d
    	..s BussInfo=requestinfo_"$"_assigninfo_"$"_acceptinfo
    	.e  d
    	..s BussInfo=requestinfo_"$"_assigninfo_"$"_acceptinfo_"$"_maintinfo
	}
	elseif BussType="34"    //报废
	{
		s BussInfo=##Class(web.DHCEQBatchDisuseRequest).GetOneDisuseRequest("","",BussID)
	}
	elseif BussType="61"    //项目管理
	{
		s BussInfo=##class(web.DHCEQProject).GetOneProject(BussID)
	}
	elseif BussType="62"
	{
		s BussInfo=##class(web.DHCEQIssue).GetOneIssue(BussID,"")
	}
	elseif BussType="64"    //租赁
	{
		s LoanInfo=##Class(web.DHCEQRent).GetRentByID(BussID,"")
		i LoanInfo'="" d
		.s requestno="RequestNo#申请单号#"_$p(LoanInfo,"^",1)
		.s requestloc="RequestLoc#申请科室#"_$p(LoanInfo,"^",51)
		.s requestuser="RequestUser#申请人#"_$p(LoanInfo,"^",53)
		.s requestdate=$p(LoanInfo,"^",54)
		.i requestdate'="" s requestdate=$zd($zdh(requestdate,4),3)
		.s requestdate="RequestDate#申请日期#"_requestdate
		.s equip="EquipName#设备名称#"_$p(LoanInfo,"^",58)
		.s equipno="EquipNo#设备编号#"_$p(LoanInfo,"^",81)
		.s model="Model#规格型号#"_$p(LoanInfo,"^",57)
		.s planbegindate=$p(LoanInfo,"^",79)
		.i planbegindate'="" s planbegindate=$zd($zdh(planbegindate,4),3)
		.s planenddate=$p(LoanInfo,"^",61)
		.i planenddate'="" s planenddate=$zd($zdh(planenddate,4),3)
		.s plandate="PlanDate#计划日期#"_planbegindate_"~"_planenddate
		.s rentmanager="RentManager#借出管理人#借出管理人:"_$p(LoanInfo,"^",63)
		.s locreceiver="LocReceiver#科室接收人#科室接收人:"_$p(LoanInfo,"^",64)
		.s startdate=$p(LoanInfo,"^",59)
		.i startdate'="" s startdate=$zd($zdh(startdate,4),3)
		.s startdate="StartDate#开始日期#开始日期:"_startdate
		.s rentstatus=$p(LoanInfo,"^",16)
		.s rentstatusremark=$p(LoanInfo,"^",17)
		.i (rentstatus'="")&&(rentstatusremark'="") s rentstatus=rentstatus_"("_rentstatusremark_")"
		.e  i (rentstatus'="")&&(rentstatusremark="")  s rentstatus=rentstatus
		.e  i (rentstatus="")&&(rentstatusremark'="")  s rentstatus=rentstatusremark
		.s rentstatus="RentStatus#借出状态#借出状态:"_rentstatus
		.s returnmanager="ReturnManager#归还管理人#归还管理人:"_$p(LoanInfo,"^",69)
		.s locreturn="LocReturn#科室归还人#科室归还人:"_$p(LoanInfo,"^",70)
		.s returndate=$p(LoanInfo,"^",71)
		.i returndate'="" s returndate=$zd($zdh(returndate,4),3)
		.s returndate="ReturnDate#归还日期#归还日期:"_returndate
		.s returnstatus=$p(LoanInfo,"^",25)
		.s returnstatusremark=$p(LoanInfo,"^",26)
		.i (returnstatus="")&&(returnstatusremark'="")  s returnstatus=returnstatusremark
		.e  i (returnstatus'="")&&(returnstatusremark="")  s returnstatus=returnstatus
		.e  i (returnstatus'="")&&(returnstatusremark'="") s returnstatus=returnstatus_"("_returnstatusremark_")"
		.s returnstatus="ReturnStatus#归还状态#归还状态:"_returnstatus
		.s workload="WorkLoad#工作量#工作量:"_$p(LoanInfo,"^",31)
		.s price="Price#价格#价格:"_$p(LoanInfo,"^",82)
		.s totalfee="TotalFee#总费用#总费用:"_$p(LoanInfo,"^",35)
		.s requestinfo="申请信息"_"^"_requestno_"^"_equip_"^"_equipno_"^"_model_"^"_requestloc_"^"_requestuser_"^"_plandate
		.s rentinfo="借出信息"_"^"_rentmanager_"^"_locreceiver_"^"_startdate_"^"_rentstatus
		.s returninfo="归还信息"_"^"_returnmanager_"^"_locreturn_"^"_returndate_"^"_workload_"^"_totalfee_"^"_returnstatus
		.i (Action="ZL_Loan") d
		..s BussInfo=requestinfo
		.e  i (Action="ZL_Renewal")||(Action="ZL_RenewalOK") d
		..s BussInfo=requestinfo_"$"_rentinfo
		.e  i (Action="ZL_Return")||(Action="ZL_LocReturn") d
		..s BussInfo=requestinfo_"$"_rentinfo
		.e  d
		..s BussInfo=requestinfo_"$"_rentinfo_"$"_returninfo
	}
	elseif BussType="73"    //保修合同
	{
		s BussInfo=##Class(web.DHCEQContractNew).GetOneContract(BussID)
	}
	elseif BussType="91"    //采购申请
	{
		s BussInfo=##Class(web.DHCEQBuyRequestNew).GetOneBuyRequest(BussID)
	}
	elseif BussType="92"    //采购计划
	{
		s BussInfo=##Class(web.DHCEQBuyPlanNew).GetOneBuyPlan(BussID)
	}
	elseif BussType="93"    //招标
	{
		s BussInfo=##class(web.DHCEQIFB).GetIFBByID(BussID)
	}
	elseif BussType="94"    //采购合同
	{
		s BussInfo=##Class(web.DHCEQContractNew).GetOneContract(BussID)
	}
	elseif BussType="A01" //配件入库
	{
		s BussInfo=##class(web.DHCEQAInStockList).GetOneAInStock(BussID)
	}
	elseif BussType="A02" //配件转移
	{
		s BussInfo=##class(web.DHCEQAMoveStock).GetOneMoveStock(BussID)
	}
	elseif BussType="A03" //配件退货
	{
		s BussInfo=##class(web.DHCEQAReduce).GetReturnList(BussID)
	}
	elseif BussType="A04" //配件减少
	{
		s BussInfo=##class(web.DHCEQAReduce).GetReturnList(BussID)
	}
	else
	{
		s BussInfo=""
	}
	
	quit BussInfo
}

/// add by zx 2021-05-07 BUG ZX0133 
/// 微信、短信等消息发送处理
/// 31^664^^0^20^^12955^^4
/// w ##Class(web.DHCEQMessages).CreatMessageSend("31", "3", "", "0", "19", "", "15387", "","2")
ClassMethod CreatMessageSend(BussType, BussID, SendDefineID As %String = "", Type As %String = "", ApproveRole As %String = "", UserID As %String = "", MessageDR As %String = "", RecInfoID As %String = "", MAction As %String = "")
{
    i (BussType="")||(BussID="")  q "-1002"
    s (Templet,EquipName,RentAffixTotalFee)=""
    s SendResult=0
    i SendDefineID'="" d
    .d CreateSendMessages
    e  d
    .s SendDefineID=0
    .f  s SendDefineID=$o(^DHCEQMessageSendDefine(0,"DefineType","1",BussType,SendDefineID)) q:SendDefineID=""  d
    ..s DefineFromRole=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",5)
    ..q:(ApproveRole'="")&&(ApproveRole'=DefineFromRole)
    ..s DefineFromAction=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",6)
    ..q:(MAction'="")&&(MAction'=DefineFromAction)
    ..s DefineToAction=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",8)
    ..q:DefineToAction'=""
    ..d CreateSendMessages

    q SendResult
CreateSendMessages
	//Modify by zx 2021-07-30 消息发送增加重复发生处理
	s RepeatFlag=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",10)
	s RepeatLength=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",11)
	s MaxLength=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",12)
	
    s Templet=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",9)
    s SendApproveRole=$p($g(^DHCEQMessageSendDefine(SendDefineID)),"^",7)
    i BussType="64" d
    .s EquipID=$p($g(^DHCEQRent(BussID)),"^",9)
    .i EquipID'="" s EquipName=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)_"("_$Piece($Get(^DHCEQEquip(EquipID)),"^",71)_")"
    .i EquipID="" d
    ..s Item=$p($g(^DHCEQRent(BussID)),"^",7)
    ..i Item'="" s EquipName=$p($g(^DHCEQCCode("DHCEQCMasterItem",Item)),"^",1)
    .s RequestLoc=$p($g(^DHCEQRent(BussID)),"^",2)
    .i RequestLoc'="" s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", RequestLoc)
    .s LoanUser=$p($g(^DHCEQRent(BussID)),"^",14)
    .i LoanUser'="" s LoanUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", LoanUser)
    .s RequestUser=$p($g(^DHCEQRent(BussID)),"^",4)
    .i RequestUser'="" s RequestUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", RequestUser)
    .s SendContent=##class(web.DHCEQCommon).Replace(Templet,"{EquipInfo}",EquipName)
    .s SendContent=##class(web.DHCEQCommon).Replace(SendContent,"{RequestLoc}",RequestLoc)
    .s SendContent=##class(web.DHCEQCommon).Replace(SendContent,"{LoanUser}",LoanUser)
    .s SendContent=##class(web.DHCEQCommon).Replace(SendContent,"{RequestUser}",RequestUser)
    .i UserID'="" d
    ..d SavaMessageSend
    .i (Type="0")&&(SendApproveRole="2") d
    ..s UserID=""
    ..s RequestLocDR=$p($g(^DHCEQRent(BussID)),"^",2)
    ..d SendByApproveRole
    e  i BussType="31" d
    .s RequestLoc=$p($g(^DHCEQMMaintRequest(BussID)),"^",7)
    .i RequestLoc'="" s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", RequestLoc)
    .s RequestUser=$p($g(^DHCEQMMaintRequest(BussID)),"^",20)
    .i RequestUser'="" s RequestUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", RequestUser)
    .s Engineer=$p($g(^DHCEQMMaintRequest(BussID)),"^",26)
    .i Engineer'="" s Engineer=##Class(web.DHCEQCommon).GetTrakNameByID("user", Engineer)
    .s FaultCase=$p($g(^DHCEQMMaintRequest(BussID)),"^",11)
    .;i FaultCase'="" s FaultCase=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FaultCase)),"^",2)
    .s ExObjDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",5)
    .s SourceTypeDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",63)
    .i ExObjDR'="" d
    ..i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)  d  //modified by wy 2022-4-13
    ...s EquipID=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
    ...i EquipID'="" d
    ....s EquipName=(##Class(web.DHCEQCommon).GetTrakNameByID("dept",$Piece($Get(^DHCEQEquip(EquipID)),"^",67)))_$Piece($Get(^DHCEQEquip(EquipID)),"^",1)_"("_$Piece($Get(^DHCEQEquip(EquipID)),"^",71)_")"
    .e  d
    ..s EquipName=(##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQMMaintRequest(BussID)),"^",6)))_$p($g(^DHCEQMMaintRequest(BussID)),"^",74)_"("_$p($g(^DHCEQMMaintRequest(BussID)),"^",75)_")"
    .s MaintProcess=$p($g(^DHCEQMMaintRequest(BussID)),"^",69)
    .i MaintProcess'="" s MaintProcess=$p($g(^DHCEQCCode("DHCEQMCMaintProcess",MaintProcess)),"^",2)
    .s SendContent=##class(web.DHCEQCommon).Replace(Templet,"{EquipInfo}",EquipName)
    .s SendContent=##class(web.DHCEQCommon).Replace(SendContent,"{Engineer}",Engineer)
    .s SendContent=##class(web.DHCEQCommon).Replace(SendContent,"{FaultCase}",FaultCase)
    .s SendContent=##class(web.DHCEQCommon).Replace(SendContent,"{RequestUser}",RequestUser)
    .s SendContent=##class(web.DHCEQCommon).Replace(SendContent,"{RequestLoc}",RequestLoc)
    .s SendContent=##class(web.DHCEQCommon).Replace(SendContent,"{Process}",MaintProcess)
    .i UserID'="" d
    ..d SavaMessageSend
    .i (Type="0")&&(SendApproveRole="2") d
    ..s UserID=""
    ..s RequestLocDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",6)
    ..i RequestLocDR="" s RequestLocDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",7)  //Modefied by zc0132 2023-3-29 如果维修对象科室为空取报修科室
    ..d SendByApproveRole
    .e  i (Type="0")&&(SendApproveRole="21") d
    ..s UserID=""
    ..s MaintGroupDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",70)
    ..q:MaintGroupDR="" 
    ..s MLRowID=0
    ..f  s MLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",MaintGroupDR,MLRowID)) q:MLRowID=""  d
    ...q:$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MLRowID)),"^",5)'="Y"
    ...s UserID=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MLRowID)),"^",2)
    ...i UserID'="" d
    ....d SavaMessageSend
    e  i BussType="34" d
    .s No=$p($g(^DHCEQDisuseRequest(BussID)),"^",33)
	.s EquipID=+##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(BussID)
	.s Name=""
	.i EquipID'="" s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)	
	.s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQDisuseRequest(BussID)),"^",34))
	.s LastHandler=##class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQDisuseRequest(BussID)),"^",17))
    .s SendContent=UseLoc_LastHandler_"申请报废设备"_Name_",申请单号:"_No_",需要您审核"
    .i UserID'="" d
    ..d SavaMessageSend
    e  i BussType="22" d
    .s No=$p($g(^DHCEQStoreMove(BussID)),"^",1)
    .s FromLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQStoreMove(BussID)),"^",2))
	.s ToLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQStoreMove(BussID)),"^",3))
	.s BussListID=$o(^DHCEQStoreMoveList(0,"StoreMove",BussID,0))
	.s Name=""
	.i BussListID'="" d
	..s Name=$p($g(^DHCEQStoreMoveList(BussListID)),"^", 5)
	.s SendContent="从"_FromLoc_"转到"_ToLoc_"的设备"_Name_",需要您审核,申请单号:"_No
    .i UserID'="" d
    ..d SavaMessageSend
    quit 
    
SendByApproveRole
	s HisLocDR=$p($g(^DHCEQCCode("DHCEQCDepartment",RequestLocDR)),"^",11)
    s GroupIDs=##Class(web.DHCEQCGroupRole).GetGroupbyRole(SendApproveRole)
    s rowid=0
    f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
    .;s UserID=rowid
    .i (","_GroupIDs_",")[(","_$p($g(^SSU("SSUSR",rowid)),"^",5)_",")  d
    ..i $p($g(^SSU("SSUSR",rowid)),"^",4)=HisLocDR d
    ...s UserID=$o(^DHCEQCCode("DHCEQCUser",0,"ExID","Y",rowid,""))
    ...q:UserID=""
    ...d SavaMessageSend
    .;s UserID=rowid
    .s chl=0
    .f  s chl=$O(^SSU("SSUSR",rowid,"OTHLL",chl)) q:(chl="")  d
    ..q:(","_GroupIDs_",")'[(","_$P(^SSU("SSUSR",rowid,"OTHLL",chl),"^",2)_",")    //是否在指定安全组内的用户
    ..q:$P(^SSU("SSUSR",rowid,"OTHLL",chl),"^",1)'=HisLocDR //有指定科室时,判断科室
    ..s UserID=$o(^DHCEQCCode("DHCEQCUser",0,"ExID","Y",rowid,""))
    ..q:UserID=""
    ..d SavaMessageSend
    
    quit
    
SavaMessageSend
    s SendUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", UserID)
    s SendInfoVal="1"
    s SendInfoVal=SendInfoVal_"^"_MessageDR
    s SendInfoVal=SendInfoVal_"^"_RecInfoID
    s SendInfoVal=SendInfoVal_"^"_SendUser
    s SendInfoVal=SendInfoVal_"^"_SendContent
    s SendInfoVal=SendInfoVal_"^"_##Class(web.DHCEQMessages).GetWChatUserID(UserID)
    s SendInfoVal=SendInfoVal_"^"_""
    //Modify by zx 2021-07-30 消息发送增加重复发生处理
    s SendInfoVal=SendInfoVal_"^"_RepeatFlag
    s SendInfoVal=SendInfoVal_"^"_RepeatLength
    s SendInfoVal=SendInfoVal_"^"_MaxLength
    s SendResult=##Class(web.DHCEQMessageSendInfo).AddData(SendInfoVal)
    
    quit
}

/// add by zx 2021-05-07 BUG ZX0133 
/// 根据HIS用户ID获取微信ID
/// w ##Class(web.DHCEQMessages).GetWChatUserID("2873")
ClassMethod GetWChatUserID(ToUserID)
{
    new result,WChatUserID
    i ToUserID="" q ""
    s result=""
    s WChatUserID=0
    f  s WChatUserID=$o(^DHCEQWChatUser(0,"User",ToUserID,WChatUserID)) q:(WChatUserID="")||(result'="")  d
    .s result=$p($g(^DHCEQWChatUser(WChatUserID)),"^",1)
    
    q result
}

/// ApproveType:
/// 			1	采购申请,2	采购计划,3	设备论证,4	采购审批,5	报废申请,6	调试验收,7	开箱验收,8	采购合同,9	委外申请,
/// 			10	备件入库,11	备件转移,12	年度计划分配,13	设备入库,14	设备转移,15	退货,16	设备维修,17	招标审批设置,18	工程管理,19	付款审批,
/// 		20	研究课题,21	备件退货,22	洗涤单,23	销毁更换单,24	车辆派遣,25	新设备维修,26	综合使用评价表,27	技术评估表,28	评价调查表,29	不良事件表,30	租赁管理,
/// w ##Class(web.DHCEQMessages).GetBussInfoByBussID("31",2)
ClassMethod GetBussInfoByBussID(ApproveType, BussID)
{
	new No,BussIDList,Name,EquipID,ExObjDR,ObjLocDR,SourceTypeDR,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BussStatus,BussInvalidFlag,BStatus,LastHandlerDR,LastHandler,BussAuditDate,RequestUser,FaultCase,StartDate,planEndDate,SaveCostFee,AcceptUserDR,OriginalFee  //modify By QW20200604 BUG:QW0065
	s (No,BussIDList,Name,EquipID,ExObjDR,ObjLocDR,SourceTypeDR,RequestLoc,Date,UseLoc,FromLoc,ToLoc,MoveType,OutType,ContractNo,BussStatus,BussInvalidFlag,BStatus,LastHandlerDR,LastHandler,BussAuditDate,RequestUser,FaultCase,StartDate,planEndDate,SaveCostFee,AcceptUserDR,OriginalFee,BussType)=""   //modify By QW20200604 BUG:QW0065
	
	new EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,EquipNo,FileNo,KindFlag
	s (EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,ApproveUser,ApproveUserDR,EquipNo,FileNo,Model,BussType,KindFlag)=""
	i (ApproveType="")||(BussID="")="" q ""
	//s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType) 
	s LastOperate=##Class(web.DHCEQApproveList).GetLastApproveListOpinion(ApproveType,BussID)
	s LastOperate=$p(LastOperate,"^",2)_$p(LastOperate,"^",3)_" "_$p(LastOperate,"^",4)
	
	if ApproveType="7"
	{
		s Date=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",10)      //modified by czf 需求号：354959
		s No=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",37)
		s BussStatus=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",20)
		s BussInvalidFlag=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",45)
		s BussIDList=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",BussID,0))
		s Name=$p($g(^DHCEQOpenCheckList(BussIDList)),"^", 2)
		s UseLoc = $p($g(^DHCEQOpenCheckList(BussIDList)),"^",33)  //使用科室
		
		s EquipTypeDR=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",2)
		s StatCatDR=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",4)
		s EquipCatDR=$p($g(^DHCEQOpenCheckList(BussIDList)),"^", 6)
		s ItemDR=$p($g(^DHCEQOpenCheckList(BussIDList)),"^", 9)
		s BussAuditDate=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",26)
		s BussType=11
	}
	elseif ApproveType="13"
	{
		s Date=$p($g(^DHCEQInStock(BussID)),"^",1)
		s No=$p($g(^DHCEQInStock(BussID)),"^",14)
		s BussStatus=$p($g(^DHCEQInStock(BussID)),"^",10)
		s BussInvalidFlag=$p($g(^DHCEQInStock(BussID)),"^",25)
		s BussIDList=$o(^DHCEQInStockList(0,"InStock",BussID,0))
		s Name=$p($g(^DHCEQInStockList(BussIDList)),"^", 5)_"..."
		s Name=##class(web.DHCEQCommon).GetEquipNos(21,BussID,"Y","EquipName")
		s EquipTypeDR=$p($g(^DHCEQInStock(BussID)),"^",20)
		s StatCatDR=$p($g(^DHCEQInStock(BussID)),"^",21)
		s BussAuditDate=$p($g(^DHCEQInStock(BussID)),"^",13)
		;s EquipCatDR=
		;s ItemDR=
		s BussType=21
	}
	elseif ApproveType="14"
	{
		s No=$p($g(^DHCEQStoreMove(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQStoreMove(BussID)),"^",13)
		s BussInvalidFlag=$p($g(^DHCEQStoreMove(BussID)),"^",27)
		s FromLoc = $p($g(^DHCEQStoreMove(BussID)),"^",2)
		s ToLoc  = $p($g(^DHCEQStoreMove(BussID)),"^",3)
		s Date=$p($g(^DHCEQStoreMove(BussID)),"^",5)
		s MoveType =$CASE($p($g(^DHCEQStoreMove(BussID)),"^",12),"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配",:"没有定义")
		s BussIDList=$o(^DHCEQStoreMoveList(0,"StoreMove",BussID,0))
		s Name=$p($g(^DHCEQStoreMoveList(BussIDList)),"^", 5)_"..."
		s Name=##class(web.DHCEQCommon).GetEquipNos(22,BussID,"Y","EquipName")
		s EquipTypeDR=$p($g(^DHCEQStoreMove(BussID)),"^",16)
		s StatCatDR=$p($g(^DHCEQStoreMove(BussID)),"^",17)
		s BussAuditDate=$p($g(^DHCEQStoreMove(BussID)),"^",19)
		s LastHandlerDR=$p($g(^DHCEQStoreMove(BussID)),"^",4)
		i LastHandlerDR'="" s LastHandler=##class(web.DHCEQCommon).GetTrakNameByID("user",LastHandlerDR)
		s UseLoc=FromLoc
		s RequestUser=$p($g(^DHCEQStoreMove(BussID)),"^",4)
		s BussType=22
	}
	elseif ApproveType="15"
	{
		s No=$p($g(^DHCEQReturn(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQReturn(BussID)),"^",13)
		s BussInvalidFlag=$p($g(^DHCEQReturn(BussID)),"^",28)
		s Date=$p($g(^DHCEQReturn(BussID)),"^",4)
		s OutType=$p($g(^DHCEQCCode("DHCEQCOutType",$p($g(^DHCEQReturn(BussID)),"^",17))),"^",2)
		s BussIDList=$o(^DHCEQReturnList(0,"Return",BussID,0))
		s EquipID=$p($g(^DHCEQReturnList(BussIDList)),"^", 4)
		i EquipID'="" d
		.s Name=$p($g(^DHCEQEquip(EquipID)),"^", 1)_"..."
		e  d
		.s InStockListDR=$p($g(^DHCEQReturnList(BussIDList)),"^", 3)     //modified by czf 371062
		.i InStockListDR'="" s Name=$p($g(^DHCEQInStockList(InStockListDR)),"^", 5)_"..."
		s EquipTypeDR=$p($g(^DHCEQReturn(BussID)),"^",15)
		s StatCatDR=$p($g(^DHCEQReturn(BussID)),"^",16)
		s BussAuditDate=$p($g(^DHCEQReturn(BussID)),"^",11)
		;s EquipCatDR=
		;s ItemDR=
		s BussType=23
	}
	elseif ApproveType="25"
	{
		s No=$p($g(^DHCEQMMaintRequest(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQMMaintRequest(BussID)),"^",41)
		s LastHandlerDR=$CASE(BussStatus,0:$p($g(^DHCEQMMaintRequest(BussID)),"^",42),1:$p($g(^DHCEQMMaintRequest(BussID)),"^",48),2:$p($g(^DHCEQMMaintRequest(BussID)),"^",51))  //add by wsp 2016-3-22
		i LastHandlerDR'="" s LastHandler=##class(web.DHCEQCommon).GetTrakNameByID("user",LastHandlerDR)  //Modify by zx 2020-11-25  //$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)  //add by wsp 增加最后操作人的信息2016-3-22
		s BStatus=##Class(web.DHCEQM.DHCEQMMaintRequest).GetStatus(BussStatus)
		s BussInvalidFlag=$p($g(^DHCEQMMaintRequest(BussID)),"^",57)
		s SaceCostFee=$p($g(^DHCEQMMaintRequest(BussID)),"^",71)  //预计维修费用
		s RequestLoc=+$p($g(^DHCEQMMaintRequest(BussID)),"^",7)
		s AcceptUserDR=+$p($g(^DHCEQMMaintRequest(BussID)),"^",26) //Add By QW20200604 BUG:QW0065
		s Date=$p($g(^DHCEQMMaintRequest(BussID)),"^",18)
		s ExObjDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",5)
		s SourceTypeDR=$p($g(^DHCEQMMaintRequest(BussID)),"^",63)
		i ExObjDR'="" d
		.i (SourceTypeDR=1)||(SourceTypeDR=2)  d  //add by zx 2017-03-20 BUG ZX0036
		..s EquipID=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
		..i EquipID'="" s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)		
		.e  d
		..s Name=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
		s UseLoc=$p($g(^DHCEQMMaintRequest(BussID)),"^",6)
		s BussAuditDate=$p($g(^DHCEQMMaintRequest(BussID)),"^",52)
		//add by zx 2017-02-27
		s RequestUser=$p($g(^DHCEQMMaintRequest(BussID)),"^",20)
		i RequestUser'="" s RequestUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", RequestUser)
		s Tel=$p($g(^DHCEQMMaintRequest(BussID)),"^",21)
		i Tel'="" s RequestUser=RequestUser_"("_Tel_")"
		s FaultCase=$p($g(^DHCEQMMaintRequest(BussID)),"^",10)
		i FaultCase'="" s FaultCase=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FaultCase)),"^",2)
		s FaultCaseRemark=$p($g(^DHCEQMMaintRequest(BussID)),"^",11)
		i FaultCase'="" d
		.i FaultCaseRemark'="" s FaultCase=FaultCase_"("_FaultCaseRemark_")"
		e  d
		.s FaultCase=FaultCaseRemark
		
		i EquipID'=""  d SetBussEquipInfo
		s BussType=31
	}
	elseif ApproveType="5"
	{
		s Date=$p($g(^DHCEQDisuseRequest(BussID)),"^",4)
		s BussStatus=$p($g(^DHCEQDisuseRequest(BussID)),"^",10)
		s BussInvalidFlag=$p($g(^DHCEQDisuseRequest(BussID)),"^",53)
		s No=$p($g(^DHCEQDisuseRequest(BussID)),"^",33)
		s RequestLoc=$p($g(^DHCEQDisuseRequest(BussID)),"^",3)
		s EquipID=+##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(BussID)
		i EquipID'="" s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)_"..."	
		i EquipID'="" s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQEquip(EquipID)),"^",27),"")_"..."  //add by wy 2020-8-25 1453205 取设备原值串		
		s BussAuditDate=$p($g(^DHCEQDisuseRequest(BussID)),"^",21)
		//Modify by zx 2020-11-25
		s UseLoc=$p($g(^DHCEQDisuseRequest(BussID)),"^",34)
		s RequestUser=$p($g(^DHCEQDisuseRequest(BussID)),"^",17)
		;i RequestUser'="" s RequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",RequestUser)
		s LastHandlerDR=$p($g(^DHCEQDisuseRequest(BussID)),"^",17)
		i LastHandlerDR'="" s LastHandler=##class(web.DHCEQCommon).GetTrakNameByID("user",LastHandlerDR)
		i EquipID'=""  d SetBussEquipInfo
		s KindFlag=$p($g(^DHCEQDisuseRequest(BussID)),"^",44)
		s BussType=34
	}
	elseif ApproveType="1"
	{
		s Date=$p($g(^DHCEQBuyRequest(BussID)),"^",6)
		s BussStatus=$p($g(^DHCEQBuyRequest(BussID)),"^",16)
		s BussInvalidFlag=$p($g(^DHCEQBuyRequest(BussID)),"^",45)
		s No=$p($g(^DHCEQBuyRequest(BussID)),"^",35)
		s RequestLoc=$p($g(^DHCEQBuyRequest(BussID)),"^",2)
		///add 20191012 by zy 增加控制
		s EquipTypeDR=$p($g(^DHCEQBuyRequest(BussID)),"^",25)
		s BussIDList=$o(^DHCEQBuyRequestList(0,"BuyRequest",BussID,0))
		i BussIDList'="" s Name=$p($g(^DHCEQBuyRequestList(BussIDList)),"^", 2)
		
		;s StatCatDR=
		;s EquipCatDR=
		;s ItemDR=
		s BussType=91
	}
	elseif ApproveType="2"
	{
		s Date=$p($g(^DHCEQBuyPlan(BussID)),"^",5)
		s BussStatus=$p($g(^DHCEQBuyPlan(BussID)),"^",6)
		s BussInvalidFlag=$p($g(^DHCEQBuyPlan(BussID)),"^",46)
		s No=$Piece($Get(^DHCEQBuyPlan(BussID)),"^",25)
		s BussIDList=$o(^DHCEQBuyPlanList(0,"BuyPlan",BussID,0))
		s Name=$p($g(^DHCEQBuyPlanList(BussIDList)),"^", 2)
		
		s EquipTypeDR=$p($g(^DHCEQBuyPlan(BussID)),"^",12)
		;s StatCatDR=
		;s EquipCatDR=
		;s ItemDR=
		s BussType=92
	}
	elseif ApproveType="17"
	{
		s No=$p($g(^DHCEQIFB(BussID)),"^",3)
		s BussStatus=$p($g(^DHCEQIFB(BussID)),"^",43)
		s BussInvalidFlag="N"
		s Name=$p($g(^DHCEQIFB(BussID)),"^",1)
		s StartDate=$p($g(^DHCEQIFB(BussID)),"^",28)	;招标开始日期
		s planEndDate=$p($g(^DHCEQIFB(BussID)),"^",25)	;招标结束日期
		s Date=$p($g(^DHCEQIFB(BussID)),"^",38)
		s RequestLoc=$p($g(^DHCEQIFB(BussID)),"^",34)	;管理科室
		s UseLoc=$p($g(^DHCEQIFB(BussID)),"^",50)		;使用科室  czf 2021-05-22 1890577
		s BussType=93
	}
	elseif ApproveType="8"
	{
		s No=$p($g(^DHCEQContract(BussID)),"^",2)
		s BussStatus=$p($g(^DHCEQContract(BussID)),"^",24)
		s BussInvalidFlag="N"
		s ContractNo=$p($g(^DHCEQContract(BussID)),"^",2)
		s Name=$p($g(^DHCEQContract(BussID)),"^",1)
		s RequestLoc=$p($g(^DHCEQContract(BussID)),"^",51)	;管理科室 czf 2021-05-22 1890577
		s Date=$p($g(^DHCEQContract(BussID)),"^",7)			;签订日期
		s BussType=94
	}
	elseif ApproveType="12"
	{
		s No=$p($g(^DHCEQProject(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQProject(BussID)),"^",10)
		s BussInvalidFlag=$p($g(^DHCEQProject(BussID)),"^",24)
		s Name=$p($g(^DHCEQProject(BussID)),"^",2)
		s BussType=61
	}
	elseif ApproveType="20"
	{
		s No=$p($g(^DHCEQIssue(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQIssue(BussID)),"^",12)
		s BussInvalidFlag=$p($g(^DHCEQIssue(BussID)),"^",26)
		s Name=$p($g(^DHCEQIssue(BussID)),"^",2)
		s BussType=62
	}
	elseif ApproveType="10" //配件入库
	{
		s Date=$p($g(^DHCEQAInStock(BussID)),"^",1)
		s No=$p($g(^DHCEQAInStock(BussID)),"^",6)
		s BussStatus=$p($g(^DHCEQAInStock(BussID)),"^",16)
		s BussInvalidFlag="N"
		s RequestLoc=$p($g(^DHCEQAInStock(BussID)),"^",3)
		s BussIDList=$o(^DHCEQAInStockList(0,"AInStock",BussID,0))
		s Name=$p($g(^DHCEQAInStockList(BussIDList)),"^",4)_"..."
		s BussType="A01"
	}
	elseif ApproveType="11" //配件转移
	{
		s Date=$p($g(^DHCEQAMoveStock(BussID)),"^",7)
		s No=$p($g(^DHCEQAMoveStock(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQAMoveStock(BussID)),"^",28)
		s BussInvalidFlag="N"
		s FromLoc=$p($g(^DHCEQAMoveStock(BussID)),"^",4)
		s ToLoc=$p($g(^DHCEQAMoveStock(BussID)),"^",5)
		s MoveType =$CASE($p($g(^DHCEQAMoveStock(BussID)),"^",14),"0":"出库","1":"库房调配","2":"退库",:"没有定义")
		s BussIDList=$o(^DHCEQAMoveStockList(0,"MoveStock",BussID,0))
		s Name=$p($g(^DHCEQAMoveStockList(BussIDList)),"^",4)_"..."
		s BussType="A02"
	}
	elseif ApproveType="21" //配件退货
	{
		s Date=$p($g(^DHCEQAReduce(BussID)),"^",8)
		s No=$p($g(^DHCEQAReduce(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQAReduce(BussID)),"^",23)
		s BussInvalidFlag="N"
		s MoveType =$p($g(^DHCEQAReduce(BussID)),"^",3)
	    s BussIDList=$o(^DHCEQAReduceList(0,"Reduce",BussID,0))
	    s ItemDR=$p($g(^DHCEQAReduceList(BussIDList)),"^",2)
		i ItemDR'="" s Name=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",2)_"..."
		s BussType=$case(MoveType,"1":"A03",:"A04")
		s MoveType=$case(MoveType,"1":"退货",:"减少")
	}
	elseif ApproveType="30" //租赁 add by zx 2016-11-03 增加租赁消息读取处理 ZX0036
	{
		//Modify by zx 2020-04-29
		s RentModeFlag=##class(web.DHCEQCommon).GetSysInfo("992003")
		if RentModeFlag=2
		{
			s Date=$p($g(^DHCEQSRent(BussID)),"^",5)
			s No=$p($g(^DHCEQSRent(BussID)),"^",1)
			s BussStatus=$p($g(^DHCEQSRent(BussID)),"^",36)
			s BussInvalidFlag="N"
			//Modify by zx 2020-06-24 Bug ZX0093
			i No="" s BussInvalidFlag="Y"
			s ShareItemDR=$p($g(^DHCEQSRent(BussID)),"^",32)
			i ShareItemDR'="" d
			.s Name=$p($g(^DHCEQSCShareItem(ShareItemDR)),"^",3)
			s ItemDR=$p($g(^DHCEQSRent(BussID)),"^",7)
			i ItemDR'="" d
			.s Name=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1)
			.s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
			.s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
			s ShareResourceID=$p($g(^DHCEQSRent(BussID)),"^",9)
			i ShareResourceID'="" s EquipID=$p($g(^DHCEQSShareResource(ShareResourceID)),"^",3)
			s FromLoc=$p($g(^DHCEQSRent(BussID)),"^",3)
			s RequestLoc=$p($g(^DHCEQSRent(BussID)),"^",2)
			s StartDate=$p($g(^DHCEQSRent(BussID)),"^",10)
			s planEndDate=$p($g(^DHCEQSRent(BussID)),"^",12)
			s BussAuditDate=$p($g(^DHCEQSRent(BussID)),"^",23)
			s LastHandlerDR=$p($g(^DHCEQSRent(BussID)),"^",4)
		}
		elseif RentModeFlag=1
		{
			s Date=$p($g(^DHCEQRent(BussID)),"^",5)
			s No=$p($g(^DHCEQRent(BussID)),"^",1)
			s BussStatus=$p($g(^DHCEQRent(BussID)),"^",36)
			s BussInvalidFlag="N"
			//Modify by zx 2020-06-24 Bug ZX0093
			i No="" s BussInvalidFlag="Y"
			s ItemDR=$p($g(^DHCEQRent(BussID)),"^",7)
			i ItemDR'="" d
			.s Name=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1)
			.s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
			.s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
			s EquipID=$p($g(^DHCEQRent(BussID)),"^",9)
			s FromLoc=$p($g(^DHCEQRent(BussID)),"^",3)
			s RequestLoc=$p($g(^DHCEQRent(BussID)),"^",2)
			s StartDate=$p($g(^DHCEQRent(BussID)),"^",10)
			s planEndDate=$p($g(^DHCEQRent(BussID)),"^",12)
			s BussAuditDate=$p($g(^DHCEQRent(BussID)),"^",23)
			s LastHandlerDR=$p($g(^DHCEQRent(BussID)),"^",4)
		}
		
		i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
		
		i EquipID'=""  d SetBussEquipInfo
		s BussType=64
	}
	elseif ApproveType="31" //设备配送 add by zx 2017-02-07  Bug ZX0038
	{
		s Date=$p($g(^DHCEQMove(BussID)),"^",21)
		s No=$p($g(^DHCEQMove(BussID)),"^",1)
		s BussStatus=$p($g(^DHCEQMove(BussID)),"^",30)
		s BussInvalidFlag="N"
		s FromLoc = $p($g(^DHCEQMove(BussID)),"^",9)
		s ToLoc = $p($g(^DHCEQMove(BussID)),"^",15)
		s MoveType =$CASE($p($g(^DHCEQMove(BussID)),"^",6),"1":"送出","2":"归还",:"没有定义")
		s SourceTypeDR=$p($g(^DHCEQMove(BussID)),"^",2)
		s EquipID = $p($g(^DHCEQMove(BussID)),"^",3)
		i EquipID'="" s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)
		s LastHandlerDR=$p($g(^DHCEQMove(BussID)),"^",23)
		i LastHandlerDR'="" s LastHandler=$P($g(^SSU("SSUSR",LastHandlerDR)),"^",2)
		d SetBussEquipInfo
		s BussType=65
	}
	elseif ApproveType="32" //发票 add by zx 2017-07-05
	{
		s Date=$p($g(^DHCEQInvoice(BussID)),"^",3)
		s No=$p($g(^DHCEQInvoice(BussID)),"^",2)
		s BussStatus=$p($g(^DHCEQInvoice(BussID)),"^",10)
		s BussInvalidFlag="N"	
		s UseMapDR=$o(^DHCEQInvoiceUseMap(0,"Invoice",BussID,0))
		i UseMapDR'="" d
		.q:$p($g(^DHCEQInvoiceUseMap(UseMapDR)),"^",3)'="11"
		.s MaintDR=$p($g(^DHCEQInvoiceUseMap(UseMapDR)),"^",1)
		.i MaintDR'="" d
		..s MaintRequestDR=$p($g(^DHCEQMMaintPart(MaintDR)),"^",9)
		..i MaintRequestDR'="" d
		...s RequestLoc=+$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",7)
		...s Date=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",18)
		...s ExObjDR=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",5)
		...s SourceTypeDR=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",63)
		...i ExObjDR'="" d
		....i (SourceTypeDR=1)||(SourceTypeDR=2)  d  //add by zx 2017-03-20 BUG ZX0036
		.....s EquipID=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
		.....i EquipID'="" s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)
		....e  d
		.....s Name=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
		...s UseLoc=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",6)
		
		i EquipID'=""  d SetBussEquipInfo
		s BussType=66
	}
	elseif ApproveType="36"		;设备拆分 czf 20210706
	{
		s Date=$p($g(^DHCEQSplit(BussID)),"^",24)
		s BussStatus=$p($g(^DHCEQSplit(BussID)),"^",22)
		s BussInvalidFlag=$p($g(^DHCEQSplit(BussID)),"^",27)
		s No=$p($g(^DHCEQSplit(BussID)),"^",1)
		s EquipID=$p($g(^DHCEQSplit(BussID)),"^",2)
		i EquipID'="" d
		.s Name=$Piece($Get(^DHCEQEquip(EquipID)),"^",1)	
		s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQSplit(BussID)),"^",4),"")	
		s BussAuditDate=$p($g(^DHCEQSplit(BussID)),"^",26)
		s UseLoc=$p($g(^DHCEQSplit(BussID)),"^",11)
		s RequestUser=$p($g(^DHCEQSplit(BussID)),"^",23)
		i EquipID'=""  d SetEquipInfo
		s BussType=55
	}
	
	quit No_"^"_Name_"^"_RequestLoc_"^"_Date_"^"_UseLoc_"^"_FromLoc_"^"_ToLoc_"^"_MoveType_"^"_OutType_"^"_ContractNo_"^"_EquipID_"^"_BussStatus_"^"_BussInvalidFlag_"^"_BStatus_"^"_EquipTypeDR_"^"_StatCatDR_"^"_EquipCatDR_"^"_ItemDR_"^"_LastHandlerDR_"^"_LastHandler_"^"_LastOperate_"^"_BussAuditDate_"^"_EquipNo_"^"_FileNo_"^"_Model_"^"_RequestUser_"^"_FaultCase_"^"_StartDate_"^"_planEndDate_"^"_AcceptUserDR_"^"_OriginalFee_"^"_BussType_"^"_KindFlag //modify By QW20200604 BUG:QW0065
SetBussEquipInfo
	i EquipID="" quit
	s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
	s StatCatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)
	s EquipCatDR=$p($g(^DHCEQEquip(EquipID)),"^",4)
	s ItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
	s EquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	s FileNo=$p($g(^DHCEQEquip(EquipID)),"^",85)
	s Model=$p($g(^DHCEQEquip(EquipID)),"^",3)
	i Model'="" s Model=$Piece($Get(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	quit
}

/// 通过限定动作限定人公共处理,针对维修时可能是组限定
/// w ##Class(web.DHCEQMessages).LimitByAction("31", "482", "77", "2", "2,4,5", "73")
ClassMethod LimitByAction(LBGBussType, LBGBussID, LBGUserID, LBGActionID, LBGLimitActions, LBGLimitUserID)
{
	n LBGResult,LBGGroupID,LBGGroupFlag
	s LBGResult=1
	i (LBGBussType="")||(LBGBussID="")||(LBGUserID="")  q LBGResult
	
	i LBGBussType="31" d
	.s LBGGroupID=$p($g(^DHCEQMMaintRequest(LBGBussID)),"^",70)
	.i LBGGroupID'="" d
	..s LBGGroupFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",LBGGroupID)),"^",13)
	..i LBGGroupFlag'="Y" d
	...i (LBGLimitUserID'="")&&((","_LBGLimitUserID_",")'[(","_LBGUserID_","))&&((","_LBGLimitActions_",")[(","_LBGActionID_",")) s LBGResult=0
	..e  d
	...s LBGGroupListID=0
	...s LBGGroupListUsers=""
	...f  s LBGGroupListID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",LBGGroupID,LBGGroupListID)) q:(LBGGroupListID="")  d
	....s LBGGroupListUser=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",LBGGroupListID)),"^",2)
	....i LBGGroupListUsers'="" s LBGGroupListUsers=LBGGroupListUsers_","
	....s LBGGroupListUsers=LBGGroupListUsers_LBGGroupListUser
	...i ((","_LBGGroupListUsers_",")'[(","_LBGUserID_","))&&((","_LBGLimitActions_",")[(","_LBGActionID_",")) s LBGResult=0
	e  d
	.i (LBGLimitUserID'="")&&((","_LBGLimitUserID_",")'[(","_LBGUserID_","))&&((","_LBGLimitActions_",")[(","_LBGActionID_",")) s LBGResult=0
	
	q LBGResult
}

}
