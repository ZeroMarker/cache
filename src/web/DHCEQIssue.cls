/// Created By HZY 2012-02-22 
/// Desc:研究课题
/// --------------------------------------------------------
Class web.DHCEQIssue Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQIssue","GetIssue","")
Query GetIssue(val As %String = "") As %Query(ROWSPEC = "TShortName:%String,Hidden:%String,TNo:%String,TCode:%String,TMaster:%String,TDept:%String")
{
}

ClassMethod GetIssueExecute(ByRef qHandle As %Binary, val As %String = "") As %Status
{
	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s val=##Class(web.DHCEQCommon).UnEscape(val)
 	s val=$ZCONVERT(val ,"U")
	s index=1
	s rowid=0
	d BuildDataGetIssueInfo
	Quit $$$OK
BuildDataGetIssueInfo
	f  s rowid=$o(^DHCEQIssue(rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQIssue(rowid)),"^",26)="Y"		//I_InvalidFlag
	.q:$p($g(^DHCEQIssue(rowid)),"^",12)="3"		//I_Status--作废
	.d ResetVariablesGetIssueInfo
	.s TRowID = rowid								//I_RowID
	.s TCode=$p($g(^DHCEQIssue(rowid)),"^",27)		//I_Hold1 拼音码
	.s TName=$p($g(^DHCEQIssue(rowid)),"^",2)		//I_Name 名称
	.s TShortName=$p($g(^DHCEQIssue(rowid)),"^",3)	//I_ShortName 简称
	.q:(val'="")&&($ZCONVERT(TCode ,"U")'[val)&&($ZCONVERT(TShortName ,"U")'[val)&&($ZCONVERT(TName ,"U")'[val)
	.s TNo=$p($g(^DHCEQIssue(rowid)),"^",1)			//I_No 
	.s TMaster=$p($g(^DHCEQIssue(rowid)),"^",6)		//I_Master 负责人
	.s TDept=$p($g(^DHCEQIssue(rowid)),"^",9)		//I_Dept 课题单位
	.d OutputRowGetIssueInfo
	quit
OutputRowGetIssueInfo
   	s Data=$lb(TShortName,TRowID,TNo,TCode,TMaster,TDept)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetIssueInfo
	s (TRowID,TNo,TShortName,TName,TCode,TMaster,TDept)=""
	quit
}

ClassMethod GetIssueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIssueExecute ]
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

ClassMethod GetIssueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIssueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add By HZY 2012-02-24 HZY0023
/// w ##Class(web.DHCEQIssue).UpdIssue("KTE^课题二")
ClassMethod UpdIssue(data)
{
	n rowid,IssueOperMethod,Issue,code,desc
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s rowid=""
	s code=$ZCONVERT($p(data,"^",1),"U")	//拼音码
	s desc=$p(data,"^",2)
	s SQLCODE=0
	s IssueOperMethod=##class(web.DHCEQCommon).GetSysInfo("990020")
	if (IssueOperMethod=0)||(desc="") q ""
	&SQL(Select I_RowID Into:rowid from SQLUSER.DHC_EQIssue Where I_InvalidFlag='N' and I_Status<>'作废' and (I_Name=:desc or I_ShortName=:desc))
	if rowid="" //新增当前研究课题
	{
		&SQL(Insert Into SQLUSER.DHC_EQIssue(I_Hold1,I_Name,I_ShortName,I_Status,I_InvalidFlag,I_AddUserDR,I_AddDate,I_AddTime) Values(:code,:desc,:desc,0,'N',:User,:Date,:Time)) 
		if SQLCODE
		{
			q SQLCODE
		}
		s rowid=$G(%ROWID)
	}
	q rowid
}

ClassMethod GetIssueStatus(Status)
{
	q $CASE(Status,"0":"新增","1":"提交","2":"审核",:"没有定义")
}

ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	i (Type="")||(Type="0")||(Type="4") w "<option value=0>"_..GetIssueStatus(0)_"</option>"
	i Type'="2" w "<option value=1>"_..GetIssueStatus(1)_"</option>"
	w "<option value=2>"_..GetIssueStatus(2)_"</option>"
	;w "<option value=3>"_..GetInStockStatus(3)_"</option>"
	w "</select>",!
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQIssue","Issue","")
Query Issue(QXType, Status, StartDate, EndDate, Type, ApproveRole, WaitAD, IssueNo, IssueShortName, IssueDept, InvalidFlag As %String = "N") As %Query(ROWSPEC = "TRowID:%String,TNo:%String,TName:%String,TShortName:%String,TContent:%String,TPurpose:%String,TMaster:%String,TRequestDate:%String,TRequestFee:%String,TDept:%String,TStartDate:%String,TEndDate:%String,TStatus:%String,TRemark:%String,TAddUser:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TSubmitUser:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUser:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TCancelUser:%String,TCancelUserDR:%String,TCancelDate:%String,TCancelTime:%String,TInvalidFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod IssueExecute(ByRef qHandle As %Binary, QXType, Status, StartDate, EndDate, Type, ApproveRole, WaitAD, IssueNo, IssueShortName, IssueDept, InvalidFlag As %String = "N") As %Status
{
	new repid,index,rowid,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("20")
	s index=1
	s rowid=0
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	d BuildDataIssueInfo
	Quit $$$OK
BuildDataIssueInfo
	f  s rowid=$o(^DHCEQIssue(rowid))  quit:rowid=""  d
	.d ResetVariablesIssueInfo
	.s TRowID = rowid									//I_RowID
	.s TInvalidFlag=$p($g(^DHCEQIssue(rowid)),"^",26)	//I_InvalidFlag
	.i TInvalidFlag="" s TInvalidFlag="N"
	.q:(InvalidFlag'="")&&(InvalidFlag'=TInvalidFlag)
	.s TStatus=$p($g(^DHCEQIssue(rowid)),"^",12)		//I_Status 状态
	.q:(Status'="")&&(Status'=TStatus)
	.s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"审核","":"")
	.q:((Type'="0")&&(Status=""))&&(TStatus="0")
	.s TAddDate=$p($g(^DHCEQIssue(rowid)),"^",15)	//I_AddDate新增日期
	.q:(TAddDate<StartDate)||(TAddDate>EndDate)
	.s TAddDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQIssue(rowid)),"^",15),"date")	//I_AddDate新增日期
	.s TCode=$p($g(^DHCEQIssue(rowid)),"^",27)		//I_Hold1 拼音码
	.s TName=$p($g(^DHCEQIssue(rowid)),"^",2)		//I_Name 名称
	.s TShortName=$p($g(^DHCEQIssue(rowid)),"^",3)	//I_ShortName 简称
	.q:(IssueShortName'="")&&($ZCONVERT(TCode ,"U")'[$ZCONVERT(IssueShortName,"U"))&&($ZCONVERT(TShortName ,"U")'[$ZCONVERT(IssueShortName,"U"))&&($ZCONVERT(TName ,"U")'[$ZCONVERT(IssueShortName,"U"))
	.i TShortName="" s TShortName="--"
	.s TNo=$p($g(^DHCEQIssue(rowid)),"^",1)			//I_No 课题编号
	.q:(IssueNo'="")&&($ZCONVERT(TNo ,"U")'[$ZCONVERT(IssueNo,"U"))
	.s TMaster=$p($g(^DHCEQIssue(rowid)),"^",6)		//I_Master 负责人
	.s TDept=$p($g(^DHCEQIssue(rowid)),"^",9)		//I_Dept 课题单位
	.q:(IssueDept'="")&&($ZCONVERT(TDept ,"U")'[$ZCONVERT(IssueDept,"U"))
	.
	.Set AIRowID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.If AIRowID'="" Do
	..Set CurRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",4)
	..Set TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	.If TApproveRole'="" Set TApproveRole=##class(web.DHCEQCommon).GetTrakNameByID("role",TApproveRole)	
	.Quit:((WaitAD="on")&&(CurRole'=ApproveRole))
	.
	.s TStartDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQIssue(rowid)),"^",10),"date")
	.s TEndDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQIssue(rowid)),"^",11),"date")
	.s TContent=$p($g(^DHCEQIssue(rowid)),"^",4)
	.s TPurpose=$p($g(^DHCEQIssue(rowid)),"^",5)
	.s TMaster=$p($g(^DHCEQIssue(rowid)),"^",6)
	.s TRequestDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQIssue(rowid)),"^",7),"date")
	.s TRequestFee=$p($g(^DHCEQIssue(rowid)),"^",8)
	.s TRequestFee=##Class(web.DHCEQCommon).FormatNumber(TRequestFee,"",2)
	.s TRemark=$p($g(^DHCEQIssue(rowid)),"^",13)
	.s TAddUserDR=$p($g(^DHCEQIssue(rowid)),"^",14)
	.i TAddUserDR'="" s TAddUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddTime=$p($g(^DHCEQIssue(rowid)),"^",16)
	.s TSubmitUserDR=$p($g(^DHCEQIssue(rowid)),"^",17)
	.i TSubmitUserDR'="" s TSubmitUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	.s TSubmitDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQIssue(rowid)),"^",18),"date")
	.s TSubmitTime=$p($g(^DHCEQIssue(rowid)),"^",19)
	.s TAuditUserDR=$p($g(^DHCEQIssue(rowid)),"^",20)
	.i TAuditUserDR'="" s TAuditUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQIssue(rowid)),"^",21),"date")
	.s TAuditTime=$p($g(^DHCEQIssue(rowid)),"^",22)
	.s TCancelUserDR=$p($g(^DHCEQIssue(rowid)),"^",23)
	.i TCancelUserDR'="" s TCancelUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TCancelUserDR)
	.s TCancelDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQIssue(rowid)),"^",24),"date")
	.s TCancelTime=$p($g(^DHCEQIssue(rowid)),"^",25)
	.s THold1=$p($g(^DHCEQIssue(rowid)),"^",27)
	.s THold2=$p($g(^DHCEQIssue(rowid)),"^",28)
	.s THold3=$p($g(^DHCEQIssue(rowid)),"^",29)
	.s THold4=$p($g(^DHCEQIssue(rowid)),"^",30)
	.s THold5=$p($g(^DHCEQIssue(rowid)),"^",31)
	.d OutputRowIssueInfo
	quit
OutputRowIssueInfo
   	s Data=$lb(TRowID,TNo,TName,TShortName,TContent,TPurpose,TMaster,TRequestDate,TRequestFee,TDept,TStartDate,TEndDate,TStatus,TRemark,TAddUser,TAddUserDR,TAddDate,TAddTime,TSubmitUser,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUser,TAuditUserDR,TAuditDate,TAuditTime,TCancelUser,TCancelUserDR,TCancelDate,TCancelTime,TInvalidFlag,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesIssueInfo
	s (TRowID,TNo,TName,TShortName,TContent,TPurpose,TMaster,TRequestDate,TRequestFee,TDept,TStartDate,TEndDate,TStatus,TRemark,TAddUser,TAddUserDR,TAddDate,TAddTime,TSubmitUser,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUser,TAuditUserDR,TAuditDate,TAuditTime,TCancelUser,TCancelUserDR,TCancelDate,TCancelTime,TInvalidFlag,THold1,THold2,THold3,THold4,THold5,CurRole,TApproveRole)=""
	quit
}

ClassMethod IssueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IssueExecute ]
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

ClassMethod IssueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IssueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCEQIssue).SaveData("^^"001"^^^^^^^^^^^^^^^^^^^","")
ClassMethod SaveData(RequestValue As %Library.String = "", OperateType As %Library.String = "")
{
	Kill PLIST,LIST,PL,rowid,id,No
	Set $ZT="ERRORSaveData"
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set rowid=$Piece(RequestValue,"^",1)
	If (+OperateType=1)	//删除
	{
		TStart
	 	&SQL(Update SQLUSER.DHC_EQIssue set I_InvalidFlag='Y',I_CancelUserDR=:User,I_CancelDate=:updDate,I_CancelTime=:updDate Where I_RowID=:rowid)
	 	If (SQLCODE)
		{
			TROLLBACK
			Quit rowid_"^"_SQLCODE
		}
	 	TCOMMIT
	 	Quit rowid_"^"_SQLCODE
 	}
 	i rowid'="" 
 	{
	 	s InvalidFlag=$Piece($G(^DHCEQIssue(rowid)),"^",26)
	 	i InvalidFlag="Y" q "^无效单据"
 	}
	
 	If (+OperateType=0) //新增,更新
 	{
	 	Set LIST(2)=$Piece(RequestValue,"^",2)	//	IssueNo
		Set LIST(3)=$Piece(RequestValue,"^",3)	//	IssueName
		Set LIST(4)=$Piece(RequestValue,"^",4)	//	ShortName
		Set LIST(5)=$Piece(RequestValue,"^",5)	//	Content
		Set LIST(6)=$Piece(RequestValue,"^",6)	//	Purpose
		Set LIST(7)=$Piece(RequestValue,"^",7)	//	Master
		Set LIST(8)=$Piece(RequestValue,"^",8)	//	RequestDate 
		i LIST(8)'="" Set LIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage(LIST(8),"date")
		Set LIST(9)=$Piece(RequestValue,"^",9)		//	RequestFee
		Set LIST(10)=$Piece(RequestValue,"^",10)	//	Dept
		Set LIST(11)=$Piece(RequestValue,"^",11)	//	StartDate
		i LIST(11)'="" Set LIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage(LIST(11),"date")
		Set LIST(12)=$Piece(RequestValue,"^",12)	//	EndDate
		i LIST(12)'="" Set LIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage(LIST(12),"date")
		Set LIST(13)=$Piece(RequestValue,"^",13)	//	Status
		Set LIST(14)=$Piece(RequestValue,"^",14)	//	Remark
		Set LIST(15)=$Piece(RequestValue,"^",15)	//	AddUserDR

		Set LIST(27)="N" 							//	InvalidFlag 
		Set LIST(28)=$Piece(RequestValue,"^",16)	//  Hold1(拼音码)  		
		s LIST(28)=$ZCONVERT(LIST(28),"U")
		Set LIST(29)=$Piece(RequestValue,"^",17)	//  Hold2
		Set LIST(30)=$Piece(RequestValue,"^",18)	//  Hold3
		Set LIST(31)=$Piece(RequestValue,"^",19)	//  Hold4
		Set LIST(32)=$Piece(RequestValue,"^",20)	//  Hold5
		
		TStart
	 	If (rowid="")  //新增按钮操作
	 	{
		 	Set LIST(13)=0			// Status
		 	Set LIST(15)=User		// AddUserDR
			Set LIST(16)=updDate	// AddDate
			Set LIST(17)=updTime	// AddTime
		 	&SQL(Insert Into SQLUSER.DHC_EQIssue Values :LIST())
		 	Set rowid=$Get(%ROWID)
		 	If SQLCODE
			{
				TROLLBACK
				Quit rowid_"^"_SQLCODE
			}
	 	}
	 	Else  //更新按钮操作
	 	{
			&SQL(Update SQLUSER.DHC_EQIssue Values :LIST() where I_RowID =:rowid)
			If SQLCODE
			{
				TROLLBACK
				Quit rowid_"^"_SQLCODE
			}
		}

	 	TCOMMIT
	 	Quit rowid_"^"_SQLCODE
 	}
 	
ERRORSaveData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORSaveData"_ErrorMsg     	//返回错误消息
}

ClassMethod GetOneIssue(rowid, CurRole As %Library.String = "")
{
	new result,id,AppInfo,Opinion,role,flag
	Set (result,id,AppInfo,Opinion,role)=""
	Set result=^DHCEQIssue(rowid)
	s result=rowid_"^"_result

	s RequestDate=$Piece(result,"^",8)
	i RequestDate'="" s RequestDate=##Class(web.DHCEQCommon).TransValueToPage(RequestDate,"date")
	s $Piece(result,"^",8)=RequestDate
	s StartDate=$Piece(result,"^",11)
	i StartDate'="" s StartDate=##Class(web.DHCEQCommon).TransValueToPage(StartDate,"date")
	s $Piece(result,"^",11)=StartDate
	s EndDate=$Piece(result,"^",12)
	i EndDate'="" s EndDate=##Class(web.DHCEQCommon).TransValueToPage(EndDate,"date")
	s $Piece(result,"^",12)=EndDate
	
	//AIRowID_"^"_ApproveSetDR_"^"_NextRoleDR_"^"_NextFlowStep_"^"_ApproveStatu_"^"_ApproveRoleDR_"^"_CancelFlag_"^"_CancelToFlowDR_"^"_ApproveRole_"^"_NextRole	
	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("20",rowid)
	Set result=result_"^"_AppInfo
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("20")
	//Set NextFlowStep=+$Piece(AppInfo,"^",4)
	//Set ApproveRoleDR=+$Piece(AppInfo,"^",6)
	//Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Set Opinion=##Class(web.DHCEQApproveList).GetApproveListOpinion(ApproveType, rowid)
	s result=result_"^"_Opinion
	
	Quit result
}

/// w ##Class(web.DHCEQIssue).SubmitData("2^1^")
ClassMethod SubmitData(val)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($G(^DHCEQIssue(RowID)),"^",12)
	if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	
	s InvalidFlag=$Piece($G(^DHCEQIssue(RowID)),"^",26) 
	if InvalidFlag="Y" q -1015  
	
	Set $ZT="ERRORSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	
 	Set MaxPrice=0
 	If +$p(^DHCEQIssue(RowID),"^",8)>MaxPrice  Do
 	.Set MaxPrice=+$p(^DHCEQIssue(RowID),"^",8)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("20")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", MaxPrice, "", "")
	If ApproveSet="" Quit -4007
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
	If (AutoAuditFlag="Y")&&(NextStep="") Set AuditFlag=1
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
	
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"20",User)
	If SQLCODE
	{
		TROLLBACK
	 	Quit SQLCODE
	}
	If ApproveInfoID=""
	{
		&SQL(insert into sqluser.DHC_EQApproveInfo values :AppInfo())
	}
	Else
	{
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
 	}
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set PLIST(13)=	1					// I_Status
 	Set PLIST(18)=	User				// I_SubmitUserDR
	Set PLIST(19)=	updDate				// I_SubmitDate
	Set PLIST(20)=	updTime				// I_SubmitTime
	If AuditFlag=1 Set PLIST(13)=2		// I_Status
	&SQL(Update SQLUSER.DHC_EQIssue Values :PLIST() where I_RowID=:RowID)
	if SQLCODE
	{
	 	TROLLBACK
		Quit SQLCODE
	}
	
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("62", RowID, User, ApproveFlow, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	Quit RowID
	
ERRORSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORSubmitData"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQIssue).CancelSubmitData("13^1^116^^^拒绝原因0^3^2^^",3)
ClassMethod CancelSubmitData(val As %Library.String = "", CurRole)
{
	//val=RowID^USERID^CancelToFlowDR^EditOpinion^OpinionRemark^RejectReason^CurRole^RoleStep^RefuseRecordDR^RefuseRemark
	n RowID
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	
	Set $ZT="ERRORCancelSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("20")
	s ^Temp("HZY",1)=RowID
	if (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
	}
	Set AppInfo(5)=ApproveRoleDR
	Set AppInfo(6)=Step
	Set AppInfo(7)=""		;ApproveStatus
	Set AppInfo(8)=""		;ApproveRoleDR
	Set AppInfo(9)=Status	;Status	
	//s ^Temp("HZY",41)=RowID_"@"_ApproveType
	
	TSTART
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:RowID and AI_ApproveTypeDR=:ApproveType)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set PLIST(13)=	Status		// I_Status
	Set PLIST(24)=	User		// I_CancelUserDR
	Set PLIST(25)=	updDate		// I_CancelDate
	Set PLIST(26)=	updTime		// I_CancelTime
	&SQL(Update SQLUSER.DHC_EQIssue Values :PLIST() where I_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)
	}
	
	//生成消息记录
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("62", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}

	//break Messages
	//生成拒绝记录
	s RefuseReason=$p(val,"^",6)
	s CurRole=$p(val,"^",7)
	s RoleStep=$p(val,"^",8)
	s RefuseRecordDR=$p(val,"^",9)
	s RefuseRemark=$p(val,"^",10)
	s refuseData=RefuseRecordDR_"^"_RefuseReason_"^"_RefuseRemark_"^"_CurRole_"^"_RoleStep
	s ^Temp("HZY",5)=RowID_"@"_refuseData	//Test
	//b "Before UpdateRefuseRecord"
	s result=##Class(web.DHCEQRefuseRecord).UpdateRefuseRecord("1",RowID,refuseData)
	//b "After UpdateRefuseRecord"
	//break RefuseRecord
	s SQLCODE=$p(result,"^",1)
	i SQLCODE 
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
	Quit RowID
ERRORCancelSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit "ERRORCancelSubmitData"_ErrorMsg   //返回错误消息
}

/// w ##Class(web.DHCEQIssue).AuditData("3^1^",2,0)
ClassMethod AuditData(val As %Library.String = "", CurRole As %Library.String = "", RoleStep As %Library.String = "", editFieldsInfo As %Library.String = "")
{
	//val=RowID^USERID^CancelToFlowDR^EditOpinion^OpinionRemark^RejectReason^CurRole^RoleStep
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($G(^DHCEQIssue(RowID)),"^",12)
	if Status'="1" q -2015   //该记录状态不符合,不能执行操作!
	
	Set $ZT="ERRORAuditData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set Opinion=$Piece(val,"^",4)
	Set Remark=$Piece(val,"^",5)
	
	Set AppInfo(7)=RoleStep	;ApproveStatus
	Set AppInfo(8)=CurRole	;ApproveRoleDR
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("20")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("20", RowID)	
	If ApproveSet="" Quit -4007	
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	Set AppInfo(5)=NextRole
	Set AppInfo(6)=NextStep	
	Set AppInfo(9)="1"	;Status	
	
	TSTART
	Set AuditFlag=0
	If ((NextStep="")||(LastFlag="Y"))
	{
		Set AuditFlag=1
		
		Set PLIST(21)=	User		// I_AuditUserDR
		Set PLIST(22)=	updDate		// I_AuditDate
		Set PLIST(23)=	updTime		// I_AuditTime
		Set PLIST(13)=	2			// I_Status
		&sql(Update SQLUSER.DHC_EQIssue Values :PLIST() where I_RowID=:RowID)
		If SQLCODE
		{
		 	TROLLBACK
			Quit SQLCODE
		}
		Set AppInfo(9)="2"	;Status
	}
	
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,Remark,CurRole,RoleStep)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;记录单据当前审批状态
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:RowID and  AI_ApproveSetDR=:ApproveSet)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;编辑要修改的字段
	If editFieldsInfo'=""
	{
		Set SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("62", RowID, User, ApproveFlow, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
	
	Quit RowID
ERRORAuditData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORAuditData"_ErrorMsg		//返回错误消息
}

}
