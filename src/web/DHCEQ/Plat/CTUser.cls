/// 名称: web.DHCEQ.Plat.CTUser
/// 描述: CTUser表单的相关操作
/// 编写者：JYP
/// 编写日期: 2018-10-09
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTUser Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
/// w ##class(web.DHCEQ.Plat.CTUser).SaveUserData("^JYP^123456^JYP^贾云鹏^1^15926443381^2318860^942564281@QQ.com^2318860^942564281^lonely9392^1^1^1^1^^1^1^1^Y^2018-01-01^2018-12-31","")
ClassMethod SaveUserData(val As %String = "", DelRowid As %String = "")
{
	new RowID
	i DelRowid'=""  
	{
		&SQL(update sqluser.DHC_EQCUser set U_Hold1="Y" where U_RowID=:DelRowid)
		If SQLCODE
		{
			Quit SQLCODE
		}
		s RowID=DelRowid
	}
	else
	{
		i val="" q 0
		Kill PLIST
		Set RowID=$Piece(val,"^",1)
		Set PLIST(2) = $Piece(val,"^",2)	;U_LoginName
 		Set PLIST(3) = $Piece(val,"^",3)	;U_LogoinPassword
 		Set PLIST(4) = $Piece(val,"^",4)	;U_Code
 		Set PLIST(5) = $Piece(val,"^",5)	;U_Name
 		Set PLIST(6) = $Piece(val,"^",6)	;U_Sex
 		Set PLIST(7) = $Piece(val,"^",7)	;U_MobilePhone
 		Set PLIST(8) = $Piece(val,"^",8)	;U_OfficePhone
 		Set PLIST(9) = $Piece(val,"^",9)	;U_Email
 		Set PLIST(10) = $Piece(val,"^",10)	;U_Fax
 		Set PLIST(11) = $Piece(val,"^",11)	;U_QQ
 		Set PLIST(12) = $Piece(val,"^",12)	;U_WeChat
 		Set PLIST(13) = $Piece(val,"^",13)	;U_OrganizeType
 		Set PLIST(14) = $Piece(val,"^",14)	;U_OrganizeID
 		Set PLIST(15) = $Piece(val,"^",15)	;U_DefaultLocDR
 		Set PLIST(16) = $Piece(val,"^",16)	;U_GroupDR
 		Set PLIST(17) = $Piece(val,"^",17)	;U_LeaderDR
 		Set PLIST(18) = $Piece(val,"^",18)	;U_UserType
 		Set PLIST(19) = $Piece(val,"^",19)	;U_ExType
 		Set PLIST(20) = $Piece(val,"^",20)	;U_ExID
		Set PLIST(21) = $Piece(val,"^",21)	;U_ActiveFlag
		;Set PLIST(25) = ""					;U_DateLastLogin
		;Set PLIST(26) = ""					;U_TimeLastLogin
		Set PLIST(27) = "N"					;U_PasswordChanged
		;Set PLIST(28) = ""					;U_LastUpdateDate	密码最后更新日期
		;Set PLIST(29) = ""					;U_LastUpdateTime	密码最后更新时间
		Set PLIST(30) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",22),"date")	;U_DateFrom
		Set PLIST(31) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",23),"date")	;U_DateTo
		Set PLIST(32) = "N"
 		;Set PLIST(33) = ""	;U_Hold2
 		;Set PLIST(34) = ""	;U_Hold3
 		;Set PLIST(35) = ""	;U_Hold4
 		;Set PLIST(36) = ""	;U_Hold5
 		
 		If RowID=""
 		{
	 		Set PLIST(22) =##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	;U_CreateUserDR
	 		Set PLIST(23) = +$H					;U_CreateDate
	 		Set PLIST(24) = $Piece($H,",",2)	;U_CreateTime
			&SQL(insert into sqluser.DHC_EQCUser values :PLIST())
			If SQLCODE
			{
				Quit SQLCODE
			}
			Set RowID=$Get(%ROWID)
 		}
 		Else
 		{
			&SQL(update sqluser.DHC_EQCUser values :PLIST() where U_RowID=:RowID)
			If SQLCODE
			{
				Quit SQLCODE
			}
 		}
	}
	Quit SQLCODE_"^"_RowID
}
*/
/// Creator：      JYP
/// CreatDate：    2018-10-09
/// Description:   数据保存
/// Input：        data:前台获取字符串 field:value,filed:vale  Type:操作类型：（1：删除）,（2：新增）,（其他:保存）
/// Return：       ID或SQLCODE
/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
/// w ##class(web.DHCEQ.Plat.CTUser).SaveData("{""ULoginName"":""yf06"",""ULogoinPassword"":""112"",""UCode"":"""",""UName"":""yf06"",""USexDesc"":"""",""UMobilePhone"":"""",""UOfficePhone"":"""",""UEmail"":"""",""UFax"":"""",""UQQ"":"""",""UWeChat"":"""",""UActiveFlagDesc"":"""",""ULeaderDR_UName"":"""",""UUserTypeDesc"":"""",""UGroupDR_SSGRPDesc"":"""",""UDefaultLocDR_CTLOCDesc"":"""",""UOrganizeTypeDesc"":""医院"",""UOrganizeDesc"":""东华标准版数字化医院[总院]"",""UExTypeDesc"":""DHC-HIS"",""UExIDDesc"":""yf06"",""UDateFrom"":"""",""UDateTo"":"""",""URowID"":"""",""UGroupDR"":"""",""UActiveFlag"":"""",""UDefaultLocDR"":"""",""UOrganizeType"":""1"",""UOrganizeID"":""2"",""UExType"":""1"",""UExID"":""13850"",""UUserType"":"""",""ULeaderDR"":"""",""USex"":""""}","2")
ClassMethod SaveData(Data, Type As %String = "")
{
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
    s Result=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCUser",JsonData,.PLIST)
	s RowID = JsonData.URowID
	
	s $zt="ErrorSave"
	s TableName="DHC_EQCUser"
	s ClassName="User.DHCEQCUser"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	s BussID=RowID	
 	s DCRRowID=""
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s OperateType="U"
 	TSTART
	
	if (Type="1")
	{
		s OldObject=##Class(User.DHCEQCUser).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		&SQL(update sqluser.DHC_EQCUser set U_Hold1='Y' where U_RowID=:RowID)

		If SQLCODE
		{
			TRollback
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SQLCODE)
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""UHold1"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
		TCommit
	 	Quit RowID
	}
	ELSE
	{
		Set PLIST(27) = "N"					;U_PasswordChanged
		Set PLIST(32) = "N"                 ;U_Hold1
		i PLIST(21) = "" s PLIST(21)="Y"	;U_ActiveFlag		//add by czf 2020-11-13 1613089
    	//if Type="2" s RowID="" //modified by csj 2020-03-16 直接根据是否存在RowID判断新增或保存
    	if RowID'=""
    	{
	    	// MZY0021	1304171		2020-05-06 修正重复数据判断处理
	    	&SQL(select U_RowID into :tmpid from SQLUSER.DHC_EQCUser where :PLIST(13)=1 and U_OrganizeType=:PLIST(13) and U_OrganizeID=:PLIST(14) and U_ExType=:PLIST(19) and U_ExID=:PLIST(20) and U_RowID<>:RowID and U_Hold1<>'Y')
			if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该类型(医院)的关联人员已经存在!")
			&SQL(select U_RowID into :tmpid from SQLUSER.DHC_EQCUser where :PLIST(13)=2 and U_OrganizeType=:PLIST(13) and U_OrganizeID=:PLIST(14) and U_RowID<>:RowID and U_Hold1<>'Y')
			if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该类型的供应商已经存在!")
			Set BussID=RowID,OperateType="U"
			s OldObject=##Class(User.DHCEQCUser).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(Update SQLUSER.DHC_EQCUser Values :PLIST() where U_RowID = :RowID)
			if SQLCODE
			{
				TRollback
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SQLCODE) //modified by csj 2020-03-16
			}
		}
		else
		{
			// MZY0021	1304171		2020-05-06	修正重复数据判断处理
			Set PLIST(22) = CurUser				;U_CreateUserDR
	 		Set PLIST(23) = +$H					;U_CreateDate
	 		Set PLIST(24) = $Piece($H,",",2)	;U_CreateTime
	 		Set PLIST(32) = "N"                 ;U_Hold1		//add by czf 2020-11-13 1613089 begin
	 		i PLIST(21) = "" s PLIST(21)="Y"	;U_ActiveFlag
	 		&SQL(select U_RowID into :tmpid from sqluser.DHC_EQCUser where U_LoginName=:PLIST(2))
		 	i tmpid'=""	
			{
				if ($p($g(^DHCEQCCode("DHCEQCUser",tmpid)),"^",31)="Y")
				{
					&SQL(Update SQLUSER.DHC_EQCUser Values :PLIST() where U_RowID = :tmpid)
					Set OperateType="U"
				}
				else
				{
					Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该登陆名已经存在!  "_PLIST(2))
				}
			}
			else
			{
				&SQL(select U_RowID into :tmpid from SQLUSER.DHC_EQCUser where :PLIST(13)=1 and U_OrganizeType=:PLIST(13) and U_OrganizeID=:PLIST(14) and U_ExType=:PLIST(19) and U_ExID=:PLIST(20))
				if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该类型(医院)的关联人员已经存在!")
				&SQL(select U_RowID into :tmpid from SQLUSER.DHC_EQCUser where :PLIST(13)=2 and U_OrganizeType=:PLIST(13) and U_OrganizeID=:PLIST(14))
				if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210", "该类型的供应商已经存在!")
				
		 		&SQL(insert into sqluser.DHC_EQCUser values :PLIST())
				Set OperateType="A"
			}
			
			if SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SQLCODE)
			}
		 	s RowID=$Get(%ROWID)		
		}
		s BussID=RowID		//add by czf 2020-11-13 1613089 end
		i RowID'=""	//更新数据获取更新字段Json串
		{
			s key=""
			For
			{
			      s value=JsonData.GetNext(.key)
			      q:key=""
			      i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
			}
		}
		else			//插入数据
		{
			s NewObj=JsonData
		}
	
		i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
		{
			s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
			If Rtn
	 		{
		 		TRollback
		 		q Rtn
			}
		}
		
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ErrorSave
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// Creator：      JYP
/// CreatDate：    2018-10-09
/// Description:   查询人员记录
/// Input：        vData 查询条件^LoginName=aa^Code=aa
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTUser","GetUserData","")
Query GetUserData(vData As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TLoginName:%String,TLogoinPassword:%String,TCode:%String,TName:%String,TSex:%String,TSexDesc:%String,TMobilePhone:%String,TOfficePhone:%String,TEmail:%String,TFax:%String,TQQ:%String,TWeChat:%String,TOrganizeType:%String,TOrganizeTypeDesc:%String,TOrganizeID:%String,TOrganizeDesc:%String,TDefaultLocDR:%String,TDefaultLocDR_CTLOCDesc:%String,TGroupDR:%String,TGroupDR_SSGRPDesc:%String,TLeaderDR:%String,TLeaderDR_UName:%String,TUserType:%String,TUserTypeDesc:%String,TExType:%String,TExTypeDesc:%String,TExID:%String,TExIDDesc:%String,TActiveFlag:%String,TActiveFlagDesc:%String,TDateLastLogin:%String,TTimeLastLogin:%String,TPasswordChanged:%String,TDateFrom:%String,TDateTo:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetUserDataExecute(ByRef qHandle As %Binary, vData As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	
	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set LoginName=##class(web.DHCEQCommon).GetDataByName(vData,"LoginName")
 	Set Name=##class(web.DHCEQCommon).GetDataByName(vData,"Name")
 	Set DefaultLocDR =##class(web.DHCEQCommon).GetDataByName(vData,"DefaultLocDR")
 	Set GroupDR =##class(web.DHCEQCommon).GetDataByName(vData,"GroupDR")
 	Set Code=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"Code"),"U")
 	Set Sex =##class(web.DHCEQCommon).GetDataByName(vData,"Sex")
 	Set MobilePhone =##class(web.DHCEQCommon).GetDataByName(vData,"MobilePhone")
 	Set OfficePhone =##class(web.DHCEQCommon).GetDataByName(vData,"OfficePhone")
 	Set Email =##class(web.DHCEQCommon).GetDataByName(vData,"Email")
 	Set Fax =##class(web.DHCEQCommon).GetDataByName(vData,"Fax")
 	Set QQ =##class(web.DHCEQCommon).GetDataByName(vData,"QQ")
 	Set WeChat =##class(web.DHCEQCommon).GetDataByName(vData,"WeChat")
 	Set OrganizeType =##class(web.DHCEQCommon).GetDataByName(vData,"OrganizeType")
 	Set OrganizeID =##class(web.DHCEQCommon).GetDataByName(vData,"OrganizeID")
 	Set LeaderDR =##class(web.DHCEQCommon).GetDataByName(vData,"LeaderDR")
 	Set UserType =##class(web.DHCEQCommon).GetDataByName(vData,"UserType")
 	Set ExType =##class(web.DHCEQCommon).GetDataByName(vData,"ExType")
 	Set ExID =##class(web.DHCEQCommon).GetDataByName(vData,"ExID")
 	Set ActiveFlag =##class(web.DHCEQCommon).GetDataByName(vData,"ActiveFlag")
 	Set DateFrom =##class(web.DHCEQCommon).GetDataByName(vData,"DateFrom")
 	Set DateTo =##class(web.DHCEQCommon).GetDataByName(vData,"DateTo")
	Set DateFrom=##class(web.DHCEQCommon).TransValueFromPage(DateFrom,"date")
	Set DateTo=##class(web.DHCEQCommon).TransValueFromPage(DateTo,"date")
	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",31)="Y")
	.d ResetVariablesGetUserData
	.s URowID = rowid
	.s ULoginName = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",1)
	.q:(LoginName'="")&&(ULoginName'[LoginName)
	.s ULogoinPassword = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",2)
	.s UCode = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",3)
	.q:(Code'="")&&(UCode'[Code)
	.s UName = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",4)
	.q:(Name'="")&&(UName'[Name)
	.s USex = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",5)
	.q:(Sex'="")&&(USex'=Sex)
	.s USexDesc=$CASE(USex,"1":"男","2":"女","":"")
	.s UMobilePhone = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",6)
	.q:(MobilePhone'="")&&(UMobilePhone'[MobilePhone)
	.s UOfficePhone = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",7)
	.q:(OfficePhone'="")&&(UOfficePhone'[OfficePhone)
	.s UEmail = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",8)
	.q:(Email'="")&&(UEmail'[Email)
	.s UFax = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",9)
	.q:(Fax'="")&&(UFax'[Fax)
	.s UQQ = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",10)
	.q:(QQ'="")&&(UQQ'[QQ)
	.s UWeChat = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",11)
	.q:(WeChat'="")&&(UWeChat'[WeChat)
	.s UOrganizeType = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",12)
	.s UOrganizeID = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",13)
	.q:(OrganizeType'="")&&(UOrganizeType'=OrganizeType)   //modified by myl 1969938 20210918
	.q:(OrganizeID'="")&&(UOrganizeID'=OrganizeID)    //modified by myl 1969938 20210918
	.q:(UOrganizeType=1)&&(sHospID'="")&&(UOrganizeID'=sHospID)		//当前登录人是否有权限查看表数据 CZF0138 
	.i UOrganizeType=1  d
	..s UOrganizeTypeDesc="医院"
	..s UOrganizeDesc=$p($g(^CT("HOSP", +UOrganizeID)),"^",2)
	.else  if UOrganizeType=2  d
	..s UOrganizeTypeDesc="供应商"
	..s UOrganizeDesc=##class(web.DHCEQCommon).GetTrakNameByID("prov", UOrganizeID)
	.s UDefaultLocDR = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",14)
	.q:(DefaultLocDR'="")&&(UDefaultLocDR'=DefaultLocDR)
	.s UDefaultLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept", UDefaultLocDR)
	.s UGroupDR = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",15)
	.q:(GroupDR'="")&&(UGroupDR'=GroupDR)
	.s UGroup=$p($g(^SSU("SSGRP", +UGroupDR)),"^",1)
	.s ULeaderDR = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",16)
	.if ULeaderDR'="" s ULeader = $p($g(^DHCEQCCode("DHCEQCUser",ULeaderDR)),"^",4)
	.q:(LeaderDR'="")&&(ULeaderDR'=LeaderDR)
	.s UUserType = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",17)
	.q:(UserType'="")&&(UUserType'=UserType)
	.s UUserTypeDesc = $CASE(UUserType,"1":"正式","2":"试用","3":"实习","":"")
	.s UExType = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",18)
	.q:(ExType'="")&&(UExType'=ExType)
	.s UExTypeDesc = $CASE(UExType,"1":"DHC-HIS","":"")
	.s UExID = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",19)
	.q:(ExID'="")&&(UExID'=ExID)
	.if UExID'="" s UExIDDesc = $p($g(^SSU("SSUSR",UExID)),"^",2)   //modify hly 20190806   ##class(web.DHCEQCommon).GetTrakNameByID("user",UExID)
	.s UActiveFlag = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",20)
	.q:(ActiveFlag'="")&&(UActiveFlag'=ActiveFlag)
	.s UActiveFlagDesc = $CASE(UActiveFlag,"Y":"是","N":"否","":"")
	.s UDateLastLogin = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",24)
	.s UDateLastLogin=##class(web.DHCEQCommon).TransValueToPage(UDateLastLogin,"date")
	.s UTimeLastLogin = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",25)
	.s UTimeLastLogin=##class(web.DHCEQCommon).TransValueToPage(UTimeLastLogin,"time")
	.s UPasswordChanged = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",26)
	.s UDateFrom = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",29)
	.s UDateFrom=##class(web.DHCEQCommon).TransValueToPage(UDateFrom,"date")
	.s UDateTo = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",30)
	.s UDateTo=##class(web.DHCEQCommon).TransValueToPage(UDateTo,"date")
	.s UHold1 = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",31)
	.s UHold2 = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",32)
	.s UHold3 = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",33)
	.s UHold4 = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",34)
	.s UHold5 = $p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",35)
	.d OutputRowGetUserData
	
	Quit $$$OK
OutputRowGetUserData
	Set TRow=TRow+1
	Set Data=$lb(TRow,URowID,ULoginName,ULogoinPassword,UCode,UName,USex,USexDesc,UMobilePhone,UOfficePhone,UEmail,UFax,UQQ,UWeChat,UOrganizeType,UOrganizeTypeDesc,UOrganizeID,UOrganizeDesc,UDefaultLocDR,UDefaultLoc,UGroupDR,UGroup,ULeaderDR,ULeader,UUserType,UUserTypeDesc,UExType,UExTypeDesc,UExID,UExIDDesc,UActiveFlag,UActiveFlagDesc,UDateLastLogin,UTimeLastLogin,UPasswordChanged,UDateFrom,UDateTo,UHold1,UHold2,UHold3,UHold4,UHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetUserData
	Set (URowID,ULoginName,ULogoinPassword,UCode,UName,USex,USexDesc,UMobilePhone,UOfficePhone,UEmail,UFax,UQQ,UWeChat,UOrganizeType,UOrganizeTypeDesc,UOrganizeID,UOrganizeDesc,UDefaultLocDR,UDefaultLoc,UGroupDR,UGroup,ULeaderDR,ULeader,UUserType,UUserTypeDesc,UExType,UExTypeDesc,UExID,UExIDDesc,UActiveFlag,UActiveFlagDesc,UDateLastLogin,UTimeLastLogin,UPasswordChanged,UDateFrom,UDateTo,UHold1,UHold2,UHold3,UHold4,UHold5)=""
	quit
}

ClassMethod GetUserDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserDataExecute ]
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

ClassMethod GetUserDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQTraining).GetOneUserData(2)
ClassMethod GetOneUserData(rowid As %String = "")
{
	i rowid="" q ""
	new result,resultex
	
	s result= $G(^DHCEQCCode("DHCEQCUser",rowid))
	
	s $p(result,"^",22)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",2),"date")	;CreateDate
	s $p(result,"^",23)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",23),"time")	;CreateTime
	s $p(result,"^",24)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",24),"date")	;DateLastLogin
	s $p(result,"^",25)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",25),"time")	;TimeLastLogin
	s $p(result,"^",27)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",27),"date")	;LastUpdateDate
	s $p(result,"^",28)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",28),"time")	;LastUpdateTime
	s $p(result,"^",29)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",29),"date")	;DateFrom
	s $p(result,"^",30)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",30),"date")	;DateTo
	
	s resultex="^"
	i $p(result,"^",12)=1 d
	.s resultex=resultex_"医院^"_$p($g(^CT("HOSP", +$p(result,"^",13))),"^",2)
	else  if $p(result,"^",12)=2 d
	.s resultex=resultex_"供应商^"_##class(web.DHCEQCommon).GetTrakNameByID("prov", $p(result,"^",13))
	else  d
	.s resultex=resultex_"^"
	s resultex="^"
	s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov", $p(result,"^",14))	;DefaultLoc
	s resultex="^"
	s resultex=resultex_$p($g(^SSU("SSGRP", +$p(result,"^",15))),"^",1)						;Group
	s resultex="^"
	s resultex=resultex_$CASE($p(result,"^",17),"1":"正式","2":"试用","3":"实习","":"")
	
	s result=result_"^"_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 用户登录更新信息
/// w ##Class(web.DHCEQTraining).AddLoginData(2)
ClassMethod AddLoginData(RowID As %String = "")
{
	i RowID="" q -1
	n Date,Time
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(update sqluser.DHC_EQCUser set U_DateLastLogin=:Date,U_TimeLastLogin=:Time where U_RowID=:RowID)
	q SQLCODE_"^"_RowID
}

/// 更新用户密码信息
/// w ##Class(web.DHCEQTraining).UpdatePSW(2,"123456")
ClassMethod UpdatePSW(RowID As %String = "", PSW As %String = "")
{
	i (RowID="")||(PSW="") q -1
	n Date,Time
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(update sqluser.DHC_EQCUser set U_LogoinPassword=:PSW,U_LastUpdateDate=:Date,U_LastUpdateTime=:Time where U_RowID=:RowID)
	q SQLCODE_"^"_RowID
}

/// 查询课程培训登记记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTUser","GetUserType","")
Query GetUserType(name As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetUserTypeExecute(ByRef qHandle As %Binary, name As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s length=3
	f id=1:1:length d
	.S desc=$CASE(id,"1":"实习","2":"试用","3":"正式")
	.q:(name'="")&&(desc'[name)
	.d OutputRowGetUserType

	
	Quit $$$OK
OutputRowGetUserType
	Set Data=$lb(id,desc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetUserTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserDataExecute ]
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

ClassMethod GetUserTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 组织类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTUser","GetOrganizeType","")
Query GetOrganizeType(name As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetOrganizeTypeExecute(ByRef qHandle As %Binary, name As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s length=2
	f id=1:1:length d
	.S desc=$CASE(id,"1":"医院","2":"供应商")
	.q:(name'="")&&(desc'[name)
	.d OutputRowGetOrganizeType

	
	Quit $$$OK
OutputRowGetOrganizeType
	Set Data=$lb(id,desc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetOrganizeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserDataExecute ]
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

ClassMethod GetOrganizeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrganizeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询课程培训登记记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTUser","GetFlag","")
Query GetFlag(name As %String = "") As %Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

ClassMethod GetFlagExecute(ByRef qHandle As %Binary, name As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s length=3
	f id=1:1:length d
	.S desc=$CASE(id,"1":"是","2":"否","3":"全部")
	.q:(name'="")&&(desc'[name)
	.d OutputRowGetFlag
	
	Quit $$$OK
OutputRowGetFlag
	Set Data=$lb(id,desc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserDataExecute ]
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

ClassMethod GetFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add  by csj 2020-03-13 
/// 描述：批量同步人员
/// 返回：JSON字符串:{SQLCODE:"0",Data:Count} Count:更新数量
/// d ##class("web.DHCEQ.Plat.CTUser").SyncUserBatch()
ClassMethod SyncUserBatch()
{
	s (SSUID,Count)=0
	f  s SSUID = $o(^SSU("SSUSR",SSUID)) q:SSUID=""  d
	.s Rtn =  ##class(%DynamicAbstractObject).%FromJSON(##class("web.DHCEQ.Plat.CTUser").SyncUserSingle(SSUID))
	.i Rtn.SQLCODE=0 s Count=Count+1
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("0",Count)
}

/// add  by csj 2020-03-13 
/// 描述：同步单个人员
/// 入参: SSUID HIS人员ID
/// 返回：保存结果JSON字符串
/// d ##class("web.DHCEQ.Plat.CTUser").SyncUserSingle()
ClassMethod SyncUserSingle(SSUID)
{
	s SSInfo = $g(^SSU("SSUSR",SSUID))
	s EQUserObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s EQUID=$o(^DHCEQCCode("DHCEQCUser",0,"ExID","Y",SSUID,0))
	i EQUID'="" s EQUserObj.URowID=EQUID
	s EQUserObj.ULoginName=$p(SSInfo,"^",1)
	s EQUserObj.UName=$p(SSInfo,"^",2)
	s EQUserObj.ULogoinPassword=$p(SSInfo,"^",3)
	s ExType=""
	&SQL(select TD_Value into:ExType from sqluser.DHC_EQCTypeDefine where TD_Name='ExType' and TD_Desc='DHC-HIS')
	s SSDefaultLocDR=$p(SSInfo,"^",4)
	i SSDefaultLocDR'=""  d
	.s EQUserObj.UDefaultLocDR=$o(^DHCEQCCode("DHCEQCDepartment",0,"ExID","Y",ExType,SSDefaultLocDR,0))
	s EQUserObj.UGroupDR=$p(SSInfo,"^",5)
	s EQUserObj.UActiveFlag=$p(SSInfo,"^",19)
	s (OrganizeType,ExType)=""
	&SQL(select TD_Value into:OrganizeType from sqluser.DHC_EQCTypeDefine where TD_Name='OrganizeType' and TD_Desc='医院')
	s EQUserObj.UOrganizeType=OrganizeType	;$p(SSInfo,"^",1)
	s EQUserObj.UOrganizeID=$p(SSInfo,"^",98)         //%session.Get("LOGON.HOSPID") add by wy 2020-8-26 1491676 多院区同步人员，取值院区ID错误问题
	&SQL(select TD_Value into:ExType from sqluser.DHC_EQCTypeDefine where TD_Name='ExType' and TD_Desc='DHC-HIS')
	s EQUserObj.UExType=ExType
	s EQUserObj.UExID=SSUID
	q ##class(web.DHCEQ.Plat.CTUser).SaveData(EQUserObj.%ToJSON())
}

}
