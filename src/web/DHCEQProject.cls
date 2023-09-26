Class web.DHCEQProject Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQProject","GetProject")
Query GetProject(Type, ProviderDR, No, StatusDR, StartDate, EndDate, MinFee, MaxFee, WaitAD, ApproveRole) As %Query(ROWSPEC = "TRowID:%String,TNo:%String,TName:%String,TShortName:%String,TContent:%String,TType:%String,TProviderDR:%String,TProvider:%String,TTotalFee:%String,TStartDate:%String,TEndDate:%String,TStatus:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TCancelUserDR:%String,TCancelDate:%String,TCancelTime:%String,TInvalidFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod GetProjectExecute(ByRef qHandle As %Binary, Type, ProviderDR, No, StatusDR, StartDate, EndDate, MinFee, MaxFee, WaitAD, ApproveRole) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set TRow=0
	s index=1
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("18")
	s typeid=0
	f  s typeid=$o(^DHCEQProject(0,"Type",typeid))  quit:typeid=""  d
	.q:(Type'="")&&(Type'=typeid)
	.s rowid=0
	.f  s rowid=$o(^DHCEQProject(0,"Type",typeid,rowid))  quit:rowid=""  d
	..d ResetVariablesGetProject
	..s TRowID = rowid
	..s TNo=$p($g(^DHCEQProject(rowid)),"^",1)
	..q:(No'="")&&(No'=TNo)
	..s TName=$p($g(^DHCEQProject(rowid)),"^",2)
	..s TShortName=$p($g(^DHCEQProject(rowid)),"^",3)
	..s TContent=$p($g(^DHCEQProject(rowid)),"^",4)
	..s TType=$p($g(^DHCEQProject(rowid)),"^",5)
	..s TProviderDR=$p($g(^DHCEQProject(rowid)),"^",6)
	..q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	..i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)  //供应商解析
	..s TTotalFee=$p($g(^DHCEQProject(rowid)),"^",7)
	..q:(MaxFee'="")&&(MaxFee<TTotalFee)
	..q:(MinFee'="")&&(MinFee>TTotalFee)
	..s TStartDate=$p($g(^DHCEQProject(rowid)),"^",8)
	..s TEndDate=$p($g(^DHCEQProject(rowid)),"^",9)
	..q:(StartDate'="")&&(StartDate>TStartDate)
	..q:(EndDate'="")&&(EndDate<TEndDate)
	..s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	..s TEndDate=##class(web.DHCEQCommon).TransValueToPage(TEndDate,"date")
	..s TStatus=$p($g(^DHCEQProject(rowid)),"^",10)
	..q:(StatusDR'="")&&(TStatus'=StatusDR)
	..s TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus) //状态解析
	..s TRemark=$p($g(^DHCEQProject(rowid)),"^",11)
	..s TAddUserDR=$p($g(^DHCEQProject(rowid)),"^",12)
	..s TAddDate=$p($g(^DHCEQProject(rowid)),"^",13)
	..s TAddDate=##class(web.DHCEQCommon).TransValueToPage(TAddDate,"date")
	..s TAddTime=$p($g(^DHCEQProject(rowid)),"^",14)
	..s TSubmitUserDR=$p($g(^DHCEQProject(rowid)),"^",15)
	..s TSubmitDate=$p($g(^DHCEQProject(rowid)),"^",16)
	..s TSubmitDate=##class(web.DHCEQCommon).TransValueToPage(TSubmitDate,"date")
	..s TSubmitTime=$p($g(^DHCEQProject(rowid)),"^",17)
	..s TAuditUserDR=$p($g(^DHCEQProject(rowid)),"^",18)
	..s TAuditDate=$p($g(^DHCEQProject(rowid)),"^",19)
	..s TAuditDate=##class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	..s TAuditTime=$p($g(^DHCEQProject(rowid)),"^",20)
	..s TCancelUserDR=$p($g(^DHCEQProject(rowid)),"^",21)
	..s TCancelDate=$p($g(^DHCEQProject(rowid)),"^",22)
	..s TCancelDate=##class(web.DHCEQCommon).TransValueToPage(TCancelDate,"date")
	..s TCancelTime=$p($g(^DHCEQProject(rowid)),"^",23)
	..s TInvalidFlag=$p($g(^DHCEQProject(rowid)),"^",24)
	..q:TInvalidFlag="Y"
	..s TInvalidFlag=##class(web.DHCEQCommon).TransValueToPage(TInvalidFlag,"bool")
	..s THold1=$p($g(^DHCEQProject(rowid)),"^",25)
	..s THold2=$p($g(^DHCEQProject(rowid)),"^",26)
	..s THold3=$p($g(^DHCEQProject(rowid)),"^",27)
	..s THold4=$p($g(^DHCEQProject(rowid)),"^",28)
	..s THold5=$p($g(^DHCEQProject(rowid)),"^",29)
	..
	..s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	..i AIRowID'="" s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	..i ((WaitAD="on")&&(CurRole'="")) q:CurRole'=ApproveRole
	..s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("18",rowid)
	..i ApproveInfo'=""  d
	...s TApproveRole=$p(ApproveInfo,"^",9)
	...s TApproveStep=$p(ApproveInfo,"^",5)
	..d OutputRowGetProject
	Quit $$$OK
OutputRowGetProject
	Set TRow=TRow+1
	s Data=$lb(TRowID,TNo,TName,TShortName,TContent,TType,TProviderDR,TProvider,TTotalFee,TStartDate,TEndDate,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TCancelUserDR,TCancelDate,TCancelTime,TInvalidFlag,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetProject
	s (TRowID,TNo,TName,TShortName,TContent,TType,TProviderDR,TProvider,TTotalFee,TStartDate,TEndDate,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TCancelUserDR,TCancelDate,TCancelTime,TInvalidFlag,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetProjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProjectExecute ]
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

ClassMethod GetProjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProjectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneProject(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQProject(rowid)
	s resultex=resultex_"^"	;providerdr
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",6))  //供应商解析
	s $p(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")	;StartDate
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;EndDate
	s resultex=resultex_"^"	;Status
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",10),"0":"新增","1":"提交","2":"审核",:"")
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",12))
	s $p(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;AddDate	
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s $p(result,"^",16)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;SubmitDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s $p(result,"^",19)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;AuditDate
	s resultex=resultex_"^"	;CancelUserDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",21))
	s $p(result,"^",22)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",22),"date")	;CancelDate
	s $p(result,"^",24)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",24),"bool")	;InvalidFlag
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("18",rowid)
	s result=rowid_"^"_result_resultex_"^"_AppInfo
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

ClassMethod SaveData(val)
{
	new RowID,User,Date,Time,InvalidFlag
	s (RowID,User,Date,Time,InvalidFlag)=""
	k PLIST
	Set $ZT="ERRORSave"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID=$P(val,"^",1)
	i RowID'=""
	{
		s InvalidFlag=$p($g(^DHCEQProject(RowID)),"^",24)
		i InvalidFlag="Y" q -1015
	}
	s PLIST(2) = $p(val,"^",2)	;No
	s PLIST(3) = $p(val,"^",3)	;Name
	s PLIST(4) = $p(val,"^",4)	;ShortName
	s PLIST(5) = $p(val,"^",5)	;Content
	s PLIST(6) = $p(val,"^",6)	;Type
	s PLIST(7) = $p(val,"^",7)	;ProviderDR
	s PLIST(8) = $p(val,"^",8)	;TotalFee
	s PLIST(9) = $p(val,"^",9)	;StartDate
	i PLIST(9)'="" s PLIST(9)=##class(web.DHCEQCommon).TransValueFromPage(PLIST(9),"date")	;StartDate
	s PLIST(10) = $p(val,"^",10)	;EndDate
	i PLIST(10)'="" s PLIST(10)=##class(web.DHCEQCommon).TransValueFromPage(PLIST(10),"date")	;EndDate
	s PLIST(11) = "0"	;Status
	s PLIST(12) = $p(val,"^",12)	;Remark
	
	s PLIST(13) = User	;
	s PLIST(14) = Date	;
	s PLIST(15) = Time	;
	//s PLIST(16) = 	;
	//s PLIST(17) = 	;
	//s PLIST(18) = 	;
	//s PLIST(19) = 	;
	//s PLIST(20) = 	;
	//s PLIST(21) = 	;
	//s PLIST(22) = 	;
	//s PLIST(23) = 	;
	//s PLIST(24) = 	;
	//s PLIST(25) = 	;
	
	s PLIST(26) = $p(val,"^",13)	;Hold1
	s PLIST(27) = $p(val,"^",14)	;Hold2
	s PLIST(28) = $p(val,"^",15)	;Hold3
	s PLIST(29) = $p(val,"^",16)	;Hold4
	s PLIST(30) = $p(val,"^",17)	;Hold5

	TSTART	
 	if RowID=""
 	{
		&SQL(insert into sqluser.DHC_EQProject values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s RowID=$G(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQProject values :PLIST() where P_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
 	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

ClassMethod DeleteData(rowid)
{
	new RowID,User,Date,Time,InvalidFlag
	s (RowID,User,Date,Time,InvalidFlag)=""
	k PLIST
	s RowID=rowid
	Set $ZT="ERRORDelete"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)	
	s PLIST(22) =User 	;
	s PLIST(23) =Date 	;
	s PLIST(24) =Time 	;
	s PLIST(25) ="Y" 	;	
	TSTART
	&SQL(update sqluser.DHC_EQProject values :PLIST() where P_RowID=:RowID)
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

/// 创建:zy 2009-12-02  No ZY0018
/// 描述:提交
/// w ##Class(web.DHCEQInStockNew).SubmitData("174^^1^^9^2")
ClassMethod SubmitData(val)
{
	new RowID,InvalidFlag,User,Date,Time
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)	
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s InvalidFlag=$p($g(^DHCEQProject(RowID)),"^",24) //2011-10-31 DJ DJ0098
	i InvalidFlag="Y" q -1015 //2011-10-31 DJ DJ0098
	
	Set $ZT="ERRORSubmit"
	s PLIST(11) = "1"	;Status
	s PLIST(16) =User 	;
	s PLIST(17) =Date 	;
	s PLIST(18) =Time 	;
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("18")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "","")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfo(2)=ApproveType
	s AppInfo(3)=RowID
	s AppInfo(4)=ApproveSet
	s AppInfo(5)=NextRole
	s AppInfo(6)=NextStep
	s AppInfo(7)=""			;ApproveStatus  当前审核步骤
	s AppInfo(8)=""			;ApproveRoleDR	
	s AppInfo(9)="1"		;Status
	
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s PLIST(11)="2"		;Status
		s PLIST(19) =User 	;
		s PLIST(20) =Date 	;
		s PLIST(21) =Time 	;
		s AppInfo(9)="2"		;Status
	}
	
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"18",User)
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}

	if ApproveInfoID=""
 	{
	 	&SQL(insert into sqluser.DHC_EQApproveInfo values :AppInfo())		
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)		
 	}
 	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQProject values :PLIST() where P_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("61", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)  ///modify by lmm 2017-03-26 352514
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// 创建:zy 2009-12-02  No ZY0018
/// 描述:反提交
/// w ##Class(web.DHCEQInStockNew).CancelSubmitData("202^^1^^5^1^112^28")
ClassMethod CancelSubmitData(val, CurRole)
{
	new RowID,User,Date,Time
	k AppInfo,PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)	
	Set $ZT="ERRORCancel"
	
	s RowID=$P(val,"^",1)
	q:RowID=""
	s CancelToFlowDR=$P(val,"^",2)
	s ApproveSet=$P(val,"^",3)
	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}
	TSTART
	s AppInfo(5)=ApproveRoleDR
	s AppInfo(6)=Step
	s AppInfo(7)=""		;ApproveStatus
	s AppInfo(8)=""		;ApproveRoleDR
	s AppInfo(9)=Status	;Status	

	s PLIST(11)=Status		;Status
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("18")
	//add by zy 2011-03-16 
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))		
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(update sqluser.DHC_EQProject values :PLIST() where P_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	else
	{
		;Modified by jdl 2011-3-2  jdl0071
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("61", RowID, User, ApproveFlow, "Y",CurRole)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// 创建:zy 2009-12-02  No ZY0018
/// 描述:审核
/// w ##Class(web.DHCEQInStockNew).AuditData("202^^1^^5^1^^28","13","2","202^,3^,4@455^1111113434,1^11111343434,2")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo)
{
	n EquipType,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	n User,Date,RowID,AuditFlag
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)	
	
	s AppInfo(7)=RoleStep	;ApproveStatus
	s AppInfo(8)=CurRole	;ApproveRoleDR
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("18")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("18", RowID)	
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfo(5)=NextRole
	s AppInfo(6)=NextStep	
	s AppInfo(9)="1"	;Status	
	
	TSTART
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		s AuditFlag=1
		s PLIST(11)="2"
		s PLIST(19) =User 	;
		s PLIST(20) =Date 	;
		s PLIST(21) =Time 	;
		&SQL(update sqluser.DHC_EQProject values :PLIST() where P_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		s AppInfo(9)="2"	;Status
	}
	
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;记录单据当前审批状态
	//add by zy 2011-03-16 
	s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))		
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	;Modified by jdl 2011-3-2  jdl0071		
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("61", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

}
