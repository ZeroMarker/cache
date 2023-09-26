Class web.DHCEQEvaluate Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2015-08-27 DJ0159
/// 描述:业务评价模块
/// d ##class(%ResultSet).RunQuery("web.DHCEQEvaluate","GetEvaluateList","31","174","20","04")
Query GetEvaluateList(SourceType, SourceID, CurRole, EvaluateGroup) As %Query(ROWSPEC = "TRowID:%String,TEvaluateType:%String,TEvaluateTypeDR:%String,TScore:%String,TEvaluateGroupDR:%String,TERowID:%String,TELRowID:%String,TMaxScore:%String,TRemark:%String,TRow:%String")
{
}

ClassMethod GetEvaluateListExecute(ByRef qHandle As %Binary, SourceType, SourceID, CurRole, EvaluateGroup) As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	
 	s TRow=0
	Set index=1
	Set TRow=0
	s CheckEvaluateFlag=..CheckEvaluateFlag(SourceType,SourceID,CurRole,EvaluateGroup,"N")	//Modify DJ 2015-09-14 DJ0164
	;s ^DHCEQMozy("GetEvaluateList")=SourceType_","_ SourceID_","_ CurRole_","_ EvaluateGroup_","_CheckEvaluateFlag
	
	i $p(CheckEvaluateFlag,"^",1)<0		Quit $$$OK
	i User=""	Quit $$$OK
	s ERowID=$p(CheckEvaluateFlag,"^",2)
	i $p(CheckEvaluateFlag,"^",1)=0  d		//查看历史评价记录
	.s RowID=0
	.f  s RowID=$o(^DHCEQEvaluate(0,"SourceRoleUser",SourceType,SourceID,CurRole,User,RowID))  q:RowID=""  d
	..s ELRowID=0
	..f  s ELRowID=$o(^DHCEQEvaluateList(0,"Evaluate",RowID,ELRowID))  q:ELRowID=""  d
	...d ResetVariablesGetEvaluateList
	...s TRowID=RowID
	...s TEvaluateTypeDR=$p($g(^DHCEQEvaluateList(ELRowID)),"^",2)
	...i TEvaluateTypeDR'="" s TEvaluateType=$p($g(^DHCEQCCode("DHCEQCEvaluateType",TEvaluateTypeDR)),"^",2)
	...s TScore=$p($g(^DHCEQEvaluateList(ELRowID)),"^",3)
	...s TEvaluateGroupDR=$p($g(^DHCEQEvaluateList(ELRowID)),"^",5)
	...s TERowID=$p($g(^DHCEQEvaluate(RowID)),"^",15)
	...q:TERowID=""
	...s TELRowID=ELRowID
	...s TCELRowID=$o(^DHCEQCEvaluationList(0,"EvaluateGroupType",TERowID,TEvaluateGroupDR,TEvaluateTypeDR,0))
	...i TCELRowID'="" s TMaxScore=$p($g(^DHCEQCEvaluationList(TCELRowID)),"^",3)
	...s TRemark=$p($g(^DHCEQEvaluateList(ELRowID)),"^",4)
	...d OutputRowGetEvaluateList
#;	.s EvaluateGroupDR=##Class(web.DHCEQCEvaluateGroup).GetIDOrDescByCode(EvaluateGroup,1)
#;	.s EvaluateTypeDR=0
#;	.f  s EvaluateTypeDR=$o(^DHCEQEvaluate(0,"GetScoreID",SourceType,SourceID,ERowID,CurRole,EvaluateGroupDR,User,EvaluateTypeDR)) q:EvaluateTypeDR=""  d
#;	..s RowID=0
#;	..f  s RowID=$o(^DHCEQEvaluate(0,"GetScoreID",SourceType,SourceID,ERowID,CurRole,EvaluateGroupDR,User,EvaluateTypeDR,RowID))  q:RowID=""  d
#;	...d ResetVariablesGetEvaluateList
#;	...s TRowID=RowID
#;	...s TEvaluateTypeDR=EvaluateTypeDR
#;	...s TEvaluateType=$p($g(^DHCEQCCode("DHCEQCEvaluateType",TEvaluateTypeDR)),"^",2)
#;	...s TScore=$p($g(^DHCEQEvaluate(TRowID)),"^",4)
#;	...s TEvaluateGroupDR=EvaluateGroup
#;	...s TERowID=ERowID
#;	...s TMaxScore=$p($g(^DHCEQEvaluate(TRowID)),"^",13)
#;	...s TELRowID=""
#;	...s TRemark=$p($g(^DHCEQEvaluate(TRowID)),"^",10)
#;	...d OutputRowGetEvaluateList
	e  d
	.s ELRowID=0
	.f  s ELRowID=$o(^DHCEQCEvaluationList(0,"Evaluation",ERowID,ELRowID))  q:ELRowID=""  d
	..d ResetVariablesGetEvaluateList
	..s TELRowID=ELRowID
	..s TEvaluateGroupDR=$p($g(^DHCEQCEvaluationList(ELRowID)),"^",4)
	..s EGCode=""
	..i TEvaluateGroupDR'="" s EGCode=$p($g(^DHCEQCCode("DHCEQCEvaluateGroup",TEvaluateGroupDR)),"^",1)
	..q:EGCode'=EvaluateGroup
	..s TEvaluateTypeDR=$p($g(^DHCEQCEvaluationList(ELRowID)),"^",2)
	..i TEvaluateTypeDR'="" s TEvaluateType=$p($g(^DHCEQCCode("DHCEQCEvaluateType",TEvaluateTypeDR)),"^",2)
	..s TMaxScore=$p($g(^DHCEQCEvaluationList(ELRowID)),"^",3)
	..s TERowID=ERowID
	..s TScore=0
	..d OutputRowGetEvaluateList
	
#;	..s TRowID=$o(^DHCEQEvaluate(0,"GetScoreID",SourceType,SourceID,ERowID,CurRole,TEvaluateGroupDR,User,TEvaluateTypeDR,0))
#;	..s TScore=0
#;	..i TRowID'=""  d
#;	...s TScore=$p($g(^DHCEQEvaluate(TRowID)),"^",4)
#;	...i TScore>TMaxScore s TScore=0
#;	...s TRemark=$p($g(^DHCEQEvaluate(TRowID)),"^",10)
#;	..d OutputRowGetEvaluateList
	
	Quit $$$OK
OutputRowGetEvaluateList
	s TRow=TRow+1
	Set Data=$lb(TRowID,TEvaluateType,TEvaluateTypeDR,TScore,TEvaluateGroupDR,TERowID,TELRowID,TMaxScore,TRemark,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetEvaluateList
	Set (TRowID,TEvaluateType,TEvaluateTypeDR,TScore,TEvaluateGroupDR,TERowID,TELRowID,TMaxScore,TRemark)=""
	Quit
}

ClassMethod GetEvaluateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEvaluateListExecute ]
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

ClassMethod GetEvaluateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEvaluateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2015-08-27 DJ0159
/// Modify By DJ 2015-09-08 DJ0161
/// 描述:是否可以评价判断
/// w ##Class(web.DHCEQEvaluate).CheckEvaluateFlag(31,174,20,"04","N")
ClassMethod CheckEvaluateFlag(SourceType, SourceID, CurRole, EvaluateGroup, AuditFlag, EUser As %Library.String = "")
{
#;	i AuditFlag="Y"
#;	{         
#;		i EUser=""        //Modified by HHM 2016-04-20 处理移动端取session值
#;			{ s EUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	} //Modify DJ 2015-09-14 DJ0164
#;	}
	i EUser="" s EUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	n (SourceType,SourceID,CurRole,EvaluateGroup,AuditFlag,EUser)
	;s EvaluateGroupDR=##Class(web.DHCEQCEvaluateGroup).GetIDOrDescByCode(EvaluateGroup,1)
	;i EvaluateGroupDR=""  q "-1018^评价组不存在!"
	;i ((SourceType="")||(SourceID="")||(CurRole="")||(EvaluateGroup=""))	q "-1019^单据不存在!"
	i ((SourceType="")||(SourceID="")||(CurRole=""))	q "-1019^单据不存在!"
	s SourceStatus=""
	s SourceInvalidFlag=""
	s EquipTypeDR=""
	i SourceType="21"  d
	.s EquipTypeDR=$p($g(^DHCEQInStock(SourceID)),"^",20)
	.s LocDR=$p($g(^DHCEQInStock(SourceID)),"^",2)
	.s SourceStatus=$p($g(^DHCEQInStock(SourceID)),"^",10)
	.s SourceInvalidFlag=$p($g(^DHCEQInStock(SourceID)),"^",25)
	i SourceType="31"  d		//SourceType对照:web.DHCEQFind的GetBussTypeDesc
	.s EquipTypeDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",3)
	.s LocDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",7)
	.s SourceStatus=$p($g(^DHCEQMMaintRequest(SourceID)),"^",41)
	.s SourceInvalidFlag=$p($g(^DHCEQMMaintRequest(SourceID)),"^",57)
	
	i (SourceStatus=0)||(SourceStatus="") q "-1020^新增单据不可进行评价"
	i SourceInvalidFlag="Y" q "-1021^无效单据不可进行评价"
	
	s HospitalDR=0
	i +$p($g(^DHCEQCCode("DHCEQCDepartment",LocDR)),"^",7)=1 s HospitalDR=+$p($g(^DHCEQCCode("DHCEQCDepartment",LocDR)),"^",8)	;$p($g(^CTLOC(LocDR)),"^",22)
	s ERowID=$o(^DHCEQCEvaluation(0,"EvaluationHSER","N",+HospitalDR,SourceType,+EquipTypeDR,CurRole,0))
	i ERowID="" s ERowID=$o(^DHCEQCEvaluation(0,"EvaluationHSER","N",+HospitalDR,SourceType,0,CurRole,0))
	i ERowID="" s ERowID=$o(^DHCEQCEvaluation(0,"EvaluationHSER","N",0,SourceType,+EquipTypeDR,CurRole,0))
	i ERowID="" s ERowID=$o(^DHCEQCEvaluation(0,"EvaluationHSER","N",0,SourceType,0,CurRole,0))
	i ERowID="" q "-1010^未设置该业务评价"		//未设置该业务评价内容
	//s EvaluationFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",5)
	//i EvaluationFlag="N"	q "0^"_ERowID		//该评价内容未启用
	//自己已评价
	i $D(^DHCEQEvaluate(0,"SourceRoleUser",SourceType,SourceID,CurRole,EUser)) q "0^"_ERowID
	//审核单据时判断,非独立评价,即审批之前必须评价
	s EIndependentFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",9)
	s EMPEvaluationFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",8)
	i ((AuditFlag="Y")&&(EIndependentFlag="N"))||(EMPEvaluationFlag'="Y")
	{
		//是否他人已评价
		s OtherUser=$o(^DHCEQEvaluate(0,"SourceRoleUser",SourceType,SourceID,CurRole,0))
		i OtherUser'="" q "-1022^他人已评价"
	}
	
	//判断是否前面的人都已评价
	s CurSort=$p($g(^DHCEQCEvaluation(ERowID)),"^",7)
	s PreEvaluateID=0
	s SortID=CurSort
	f  s SortID=$o(^DHCEQCEvaluation(0,"SourceTypeSort","N",SourceType,SortID),-1)  q:(SortID="")||(PreEvaluateID'=0)  d
	.s PreRowID=0
	.f  s PreRowID=$o(^DHCEQCEvaluation(0,"SourceTypeSort","N",SourceType,SortID,PreRowID))  q:(PreRowID="")||(PreEvaluateID'=0)  d
	..s PreHospital=$p($g(^DHCEQCEvaluation(PreRowID)),"^",3)
	..s PreEquipType=$p($g(^DHCEQCEvaluation(PreRowID)),"^",4)
	..i ((PreEquipType=EquipTypeDR)||(+PreHospital=+HospitalDR)) s PreEvaluateID=PreRowID
	..i ((PreHospital="")&&(PreEquipType="")) s PreEvaluateID=PreRowID
	..q:PreEvaluateID=0
	..s PreRole=$p($g(^DHCEQCEvaluation(PreEvaluateID)),"^",2)
	..s IndependentFlag=$p($g(^DHCEQCEvaluation(PreEvaluateID)),"^",9)
	..i $D(^DHCEQEvaluate(0,"SourceRoleUser",SourceType,SourceID,PreRole))  s PreEvaluateID=0
	..q:PreEvaluateID=0
	..i ((IndependentFlag="Y")&&(AuditFlag="Y")) s PreEvaluateID=0	
	
	i PreEvaluateID'=0
	{
		s PreRole=$p($g(^DHCEQCEvaluation(PreEvaluateID)),"^",2)
		i PreRole'="" s PreRoleDesc=##Class(web.DHCEQCommon).GetTrakNameByID("role",PreRole)
		q "-1017^"_PreRoleDesc_"角色还未评价!"
	}
	
	i $g(^DHCEQEvaluate(0,"FinishFlag",SourceType,SourceID))="Y"		q "0^"_ERowID		//当前单据已经评价结束
	
	q "1^"_ERowID
}

/// Add By DJ 2015-08-28 DJ0159
/// 描述:存储评价信息
ClassMethod SaveEvaluation(vSourceType, vSourceID, vCurRole, vERowID, vEvaluateGroup, vEvaluationInfo)
{
	s Count=$l(vEvaluationInfo,"^")
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART
	s SQLCODE=0
	//删除历史评价信息
	i $D(^DHCEQEvaluate(0,"GetScoreID",vSourceType,vSourceID,vERowID,vCurRole,vEvaluateGroup,User))
	{
		&SQL(Delete From SQLUSER.DHC_EQEvaluate Where E_SourceType=:vSourceType and E_SourceID=:vSourceID and E_Hold1=:vERowID and E_RoleDR=:vCurRole and E_Hold2=:vEvaluateGroup and E_UserDR=:User)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	K EPLIST
	f i=1:1:Count
	{
		q:SQLCODE'=0
		s CurEvaluation=$p(vEvaluationInfo,"^",i)
		s ETypeDR=$p(CurEvaluation,"=",1)
		s EScore=$p(CurEvaluation,"=",2)
		s EMaxScore=$p(CurEvaluation,"=",3)
		s ERemark=$p(CurEvaluation,"=",4)
		s EPLIST(2)=vSourceType
		s EPLIST(3)=vSourceID
		s EPLIST(4)=ETypeDR
		s EPLIST(5)=EScore
		s EPLIST(7)=vCurRole
		s EPLIST(8)=User
		s EPLIST(9)=Date
		s EPLIST(10)=Time
		s EPLIST(11)=ERemark
		s EPLIST(12)=vERowID
		s EPLIST(13)=vEvaluateGroup
		s EPLIST(14)=EMaxScore
		s ERowID=0
		s EFind=$o(^DHCEQEvaluate(0,"GetScoreID",vSourceType,vSourceID,vERowID,vCurRole,vEvaluateGroup,User,ETypeDR,0))
		i EFind=""
		{
			&sql(Insert Into SQLUser.DHC_EQEvaluate Values :EPLIST())
		}
		else
		{
			&sql(Update sqluser.DHC_EQEvaluate Values :EPLIST() where E_RowID=:EFind)
		}
	}
	//检测是否最后评价
	s SortID=$p($g(^DHCEQCEvaluation(vERowID)),"^",7)
	s FinishFlag=$o(^DHCEQCEvaluation(0,"SourceTypeSort","Y",vSourceType,SortID))
	i FinishFlag=""  s ^DHCEQEvaluate(0,"FinishFlag",vSourceType,vSourceID)="Y"			//最后评价步骤登记
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q vSourceID
}

/*********************************************************************/
Query EvaluateDetailPC(SourceType As %String = "", SourceID As %String = "", CurRole As %String = "", EvaluateGroup As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TEvaluateType:%String,TEvaluateTypeDR:%String,TScore:%String,TUser:%String,TDate:%String,TTime:%String,TApproveRole:%String,THold2:%String,THold3:%String,TRemark:%String,TRow:%String") [ SqlProc ]
{
}

ClassMethod EvaluateDetailPCExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", CurRole As %String = "", EvaluateGroup As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	i ((SourceType="")&&(SourceID="")) Quit $$$OK
 	s CheckEvaluateFlag=..CheckEvaluateFlag(SourceType,SourceID,CurRole,EvaluateGroup,"N")		//Modify DJ 2015-09-14 DJ0164
 	
 	i $p(CheckEvaluateFlag,"^",1)<0		Quit $$$OK
 	s ERowID=$p(CheckEvaluateFlag,"^",2)
 	s EEvaluateOrder=$p($g(^DHCEQCEvaluation(ERowID)),"^",7)
 	s ECheckClass=$p($g(^DHCEQCEvaluation(ERowID)),"^",6)
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	Set TRow=0
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQEvaluate(0,"SourceID",SourceType,SourceID,rowid))  quit:rowid=""  d
	.d ResetVariablesEvaluateDetailPC
	.s TApproveRole=$p($g(^DHCEQEvaluate(rowid)),"^",4)
	.q:(CurRole'="")&&(TApproveRole'=CurRole)
	.i TApproveRole'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRole)),"^",2)
	.s TRowID=rowid
	.s TSourceType=##Class(web.DHCEQFind).GetBussTypeDesc(SourceType)
	.s TSourceID=SourceID
	.s TUser=$p($g(^DHCEQEvaluate(TRowID)),"^",5)
	.q:TUser'=CurUser
	.i TUser'="" s TUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUser)
	.s TDate=$p($g(^DHCEQEvaluate(TRowID)),"^",6)
	.s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	.s TTime=$p($g(^DHCEQEvaluate(TRowID)),"^",7)
	.s TTime=##class(web.DHCEQCommon).TransValueToPage(TTime,"time")
	.s THold1=$p($g(^DHCEQEvaluate(TRowID)),"^",15)		//评价设置ID
	.s ELRowID=0
	.f  s ELRowID=$o(^DHCEQEvaluateList(0,"Evaluate",rowid,ELRowID))  q:ELRowID=""  d
	..s TEvaluateTypeDR=$p($g(^DHCEQEvaluateList(ELRowID)),"^",2)
	..i TEvaluateTypeDR'="" s TEvaluateType=$p($g(^DHCEQCCode("DHCEQMCEvaluateType",TEvaluateTypeDR)),"^",2)
	..s TScore=$p($g(^DHCEQEvaluateList(ELRowID)),"^",3)
	..s TRemark=$p($g(^DHCEQEvaluateList(ELRowID)),"^",4)
	..s THold2=$p($g(^DHCEQEvaluateList(ELRowID)),"^",5)		//评价组
	..i THold2'="" s THold2=$p($g(^DHCEQCCode("DHCEQCEvaluateGroup",THold2)),"^",2)
	..d OutputRowEvaluateDetailPC
	Quit $$$OK
OutputRowEvaluateDetailPC
	Set TRow=TRow+1
	s Data=$lb(TRowID,TSourceType,TSourceID,TEvaluateType,TEvaluateTypeDR,TScore,TUser,TDate,TTime,TApproveRole,THold2,THold3,TRemark,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEvaluateDetailPC
	Set (TRowID,TSourceType,TSourceID,TEvaluateType,TEvaluateTypeDR,TScore,TUser,TDate,TTime,TApproveRole,THold2,THold3,TRemark)=""
	quit
}

ClassMethod EvaluateDetailPCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EvaluateDetailPCExecute ]
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

ClassMethod EvaluateDetailPCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EvaluateDetailPCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy	2015-12-11
/// ChkFlag是否过滤已评价业务	on:不过滤
/// d ##class(%ResultSet).RunQuery("web.DHCEQEvaluate","GetBusinessList","","","",20,"")
Query GetBusinessList(SourceType As %String = "", SourceID As %String = "", ProviderDR As %String = "", CurRole, ChkFlag, EvaluateGroup) As %Query(ROWSPEC = "TRowID:%String,TRow:%String,TERowID:%String,TBussType:%String,TSourceType:%String,TBussNo:%String,TProvider,TCommonName,TTotalFee,TCheckFlag")
{
}

ClassMethod GetBusinessListExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", ProviderDR As %String = "", CurRole, ChkFlag, EvaluateGroup) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("GetBusinessList")=SourceType_"^"_SourceID_"^"_ProviderDR_"^"_CurRole_"^"_ChkFlag
 	Set TRow=0
 	s index=1
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR)) quit:TEquipTypeDR=""  d
	.Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.s BillAuditDate=0
	.f  s BillAuditDate=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BillAuditDate)) quit:BillAuditDate=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BillAuditDate,rowid)) quit:rowid=""  d
	...d ResetVariablesGetBusinessList
	...Set TBussType="入库明细"
	...Set TSourceType=21
	...q:(SourceType'="")&(SourceType'=TSourceType)
	...Set TRowID=rowid
	...i ($d(^DHCEQEvaluate(0,"SourceID",TSourceType,TRowID))) Set TCheckFlag=1
	...q:(TCheckFlag'="")&(ChkFlag'="on")	;已评价
	...Set TERowID=""
	...s TEquipTypeDR=$p($g(^DHCEQInStock(TRowID)),"^",20)
	...s LocDR=$p($g(^DHCEQInStock(TRowID)),"^",2)
	...s HospitalDR=$p($g(^CTLOC(LocDR)),"^",22)
	...s TERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",+HospitalDR,TSourceType,+TEquipTypeDR,CurRole,0))
	...i TERowID="" s TERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",+HospitalDR,TSourceType,0,CurRole,0))
	...i TERowID="" s TERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",0,TSourceType,0,CurRole,0))
	...q:TERowID=""
	...Set TBussNo=$p($g(^DHCEQInStock(rowid)),"^",14)
	...Set TProviderDR=$p($g(^DHCEQInStock(rowid)),"^",17)
	...q:(ProviderDR'="")&(ProviderDR'=TProviderDR)
	...If TProviderDR '="" Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov", TProviderDR)
	...Set islrowid=0
	...f  s islrowid=$o(^DHCEQInStockList(0,"InStock",rowid,islrowid)) quit:islrowid=""  d
	....s TCommonName=$p($g(^DHCEQInStockList(islrowid)),"^",5)
	....s TTotalFee=$p($g(^DHCEQInStockList(islrowid)),"^",7)*$p($g(^DHCEQInStockList(islrowid)),"^",8)
	....
	....d OutputRowGetBusinessList
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQMMaintRequest(rowid)) Quit:rowid=""  Do
	.d ResetVariablesGetBusinessList
	.q:$p($g(^DHCEQMMaintRequest(rowid)),"^",57)="Y"
	.q:$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",41)'=2
	.s TEquipTypeDR=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",3)
	.Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.Set TBussType="维修业务"
	.Set TSourceType=31
	.q:(SourceType'="")&(SourceType'=TSourceType)
	.Set TRowID=rowid
	.i ($d(^DHCEQEvaluate(0,"SourceID",TSourceType,TRowID))) Set TCheckFlag=1
	.q:(TCheckFlag'="")&(ChkFlag'="on")	;已评价
	.Set TERowID=""
	.s TEquipTypeDR=$p($g(^DHCEQMMaintRequest(TRowID)),"^",3)
	.s LocDR=$p($g(^DHCEQMMaintRequest(TRowID)),"^",7)
	.s HospitalDR=$p($g(^CTLOC(LocDR)),"^",22)
	.;^DHCEQCEvaluation(0,"Evaluation","Y",2,21,0,21,2)
	.s TERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",+HospitalDR,TSourceType,+TEquipTypeDR,CurRole,0))
	.i TERowID="" s TERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",+HospitalDR,TSourceType,0,CurRole,0))
	.i TERowID="" s TERowID=$o(^DHCEQCEvaluation(0,"Evaluation","Y",0,TSourceType,0,CurRole,0))
	.q:TERowID=""
	.;w TERowID
	.s TBussNo=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",1)
	.s mprowid=0
	.f  s mprowid=$o(^DHCEQMMaintPart(0,"MaintRequest",rowid,mprowid)) quit:mprowid=""  d
	..Set TProviderDR=$p($g(^DHCEQMMaintPart(mprowid)),"^",16)
	..q:(ProviderDR'="")&(ProviderDR'=TProviderDR)
	..If TProviderDR '="" Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov", TProviderDR)
	..s TAccessoryDR=$p($g(^DHCEQMMaintPart(mprowid)),"^",2)
	..i TAccessoryDR'="" s TCommonName=$p($g(^DHCEQAStockDetail(TAccessoryDR)),"^",5)
	..s TTotalFee=$p($g(^DHCEQMMaintPart(mprowid)),"^",5)
	..
	..d OutputRowGetBusinessList
	
	
	Quit $$$OK
OutputRowGetBusinessList
	Set TRow=TRow+1
	If TTotalFee'="" Set TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s Data=$lb(TRowID,TRow,TERowID,TBussType,TSourceType,TBussNo,TProvider,TCommonName,TTotalFee,TCheckFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBusinessList
	Set (TRowID,TBussType,TSourceType,TBussNo,TProvider,TCommonName,TTotalFee,TCheckFlag)=""
	quit
}

ClassMethod GetBusinessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBusinessListExecute ]
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

ClassMethod GetBusinessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBusinessListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// //////////////////////////////////////////////////////////////////////////////////////
/// Add By DJ 2017-01-08
/// 描述:获取各业务评价情况
/// d ##class(%ResultSet).RunQuery("web.DHCEQEvaluate","GetBussEvaluatePC","25","","","85","1")
Query GetBussEvaluatePC(vBussType As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", CurUserDR As %String = "", IsOperFlag As %String = "", HeaderFlag As %String = "") As %Query(ROWSPEC = "TBussNo:%String,TEquip:%String,TBussRowID:%String,TFileNo:%String,TEquipNo:%String,TEFlag:%String,TEInfo:%String,TERoleDR:%String,TERowID:%String,TBussType:%String")
{
}

ClassMethod GetBussEvaluatePCExecute(ByRef qHandle As %Binary, vBussType As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", CurUserDR As %String = "", IsOperFlag As %String = "", HeaderFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i CurGroupDR="" Quit $$$OK
	s index=1
	s ApproveTypeDR=0
	f  s ApproveTypeDR=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR))  q:ApproveTypeDR=""  d
	.q:(vBussType'="")&&(ApproveTypeDR'=##Class(web.DHCEQApproveList).GetApproveType(vBussType))
	.s ALSourceID=0
	.f  s ALSourceID=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR,ALSourceID))  q:ALSourceID=""  d
	..d ResetVariablesGetBussEvaluatePC
	..s MsgTypeCode=##Class(web.DHCEQMessages).GetMsgTypeByApproveType(ApproveTypeDR)
	..q:MsgTypeCode=""
	..s GetBussEvaluateFlag=..GetBussEvaluateFlagPC(ApproveTypeDR,ALSourceID,CurGroupDR,CurUserDR,"",CurLocDR)
	..q:(HeaderFlag="")&&(+GetBussEvaluateFlag<0)
	..q:GetBussEvaluateFlag=""
	..s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(MsgTypeCode,ALSourceID)
	..s TBussType=ApproveTypeDR
	..s TBussNo=$p(BussInfo,"^",1)
	..s TEquip=$p(BussInfo,"^",2)
	..s TBussRowID=ALSourceID
	..s TEquipNo=$p(BussInfo,"^",23)
	..s TFileNo=$p(BussInfo,"^",24)
	..s GBECount=$L(GetBussEvaluateFlag,"&")
	..s GBECurRow=1
	..f GBECurRow=1:1:GBECount  d
	...s GBECurRowInfo=$p(GetBussEvaluateFlag,"&",GBECurRow)
	...s TEFlag=$p(GBECurRowInfo,"^",1)			//0:表示未评价, 1:表示已评价
	...q:(HeaderFlag="")&&(IsOperFlag=0)&&(TEFlag'=0)
	...q:(HeaderFlag="")&&(IsOperFlag=1)&&(TEFlag'=1)
	...s TEInfo=$p(GBECurRowInfo,"^",2)			//1:表示自己评价, 2:表示其他人评价
	...q:(HeaderFlag="")&&(IsOperFlag=1)&&(TEInfo'=1)
	...s TERoleDR=$p(GBECurRowInfo,"^",3)
	...s TERowID=$p(GBECurRowInfo,"^",4)		//评价定义RowID
	...d OutputRowGetBussEvaluatePC
	
	Quit $$$OK
OutputRowGetBussEvaluatePC
	s Data=$lb(TBussNo,TEquip,TBussRowID,TFileNo,TEquipNo,TEFlag,TEInfo,TERoleDR,TERowID,TBussType)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBussEvaluatePC
	s (TBussNo,TEquip,TBussRowID,TFileNo,TEquipNo,TEFlag,TEInfo,TERoleDR,TERowID,TBussType)=""
	quit
}

ClassMethod GetBussEvaluatePCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussEvaluatePCExecute ]
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

ClassMethod GetBussEvaluatePCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussEvaluatePCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// /////////////////////////////////////////////////////////////////////////////////////////
/// Add By DJ 2017-01-09
/// 描述:获取业务单据是否评价
/// 返回值:"Flag^Error^Info"
/// Flag:-1表示错误，0标志未评价，1表示已评价
ClassMethod GetBussEvaluateFlagPC(ApproveTypeDR, ALSourceID, CurGroupDR, CurUserDR, CurRoleDR, CurLocDR)
{
	n MsgTypeCode,BussInfo,TBussStatus,TBussInvalidFlag,TEquipTypeDR,TUseLocDR,THosptialDR
	n TUseLoc,FindEvaluateFlag,EDFlag,EDetailInfo,PreEvalateFlag,EOrder,EInvalidFlag
	n EHosptialDR,EEquipTypeDR,ERoleDR,EMPEvaluationFlag,EDRowID,EDHold1,EDUserDR,ECount,EDFind,CurRow
	n EDCurRowInfo,EDCurRoleDR,EDRole
	
	s MsgTypeCode=##Class(web.DHCEQMessages).GetMsgTypeByApproveType(ApproveTypeDR)
	i MsgTypeCode="" q "-1^无此业务代码!"
	i '$D(^DHCEQCEvaluation(0,"SourceTypeSort","Y",MsgTypeCode))  q "-1^无此业务评价定义"		//无业务评价定义
	s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(MsgTypeCode,ALSourceID)
	s TBussStatus=$p(BussInfo,"^",12)
	i TBussStatus=0	q "-1^新增单据不能进行评价"
	s TBussInvalidFlag=$p(BussInfo,"^",13)
	i TBussInvalidFlag="Y"	q "-1^无效单据不能进行评价"
	s TEquipTypeDR=$p(BussInfo,"^",15)
	i ##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupDR)=1		q "-1^此单据不在管理范围内"
	s TUseLocDR=$p(BussInfo,"^",5)
	s THosptialDR=""
	i TUseLocDR'=""  d
	.s THosptialDR=$p($g(^CTLOC(TUseLocDR)),"^",22)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	i CurRoleDR'=""
	{
		i '$D(^DHCEQCEvaluation(0,"Evaluation","Y",+THosptialDR,MsgTypeCode,+TEquipTypeDR,CurRoleDR))
		{
			i '$D(^DHCEQCEvaluation(0,"Evaluation","Y",+THosptialDR,MsgTypeCode,0,CurRoleDR))
			{
				i '$D(^DHCEQCEvaluation(0,"Evaluation","Y",0,MsgTypeCode,+TEquipTypeDR,CurRoleDR))
				{
					i '$D(^DHCEQCEvaluation(0,"Evaluation","Y",0,MsgTypeCode,0,CurRoleDR))
					{
						q "-1^此角色无评价权限!"
					}
				}
			}
		}
	}
	;业务评价定义
	s FindEvaluateFlag=""
	s EDFlag=""
	s EDetailInfo=""
	s PreEvalateFlag="Y"
	s EOrder=0
	f  s EOrder=$o(^DHCEQCEvaluation(0,"SourceTypeSort","Y",MsgTypeCode,EOrder))  q:(EOrder="")||(PreEvalateFlag'="Y")||(EDFlag'="")  d
	.s ERowID=0
	.f  s ERowID=$o(^DHCEQCEvaluation(0,"SourceTypeSort","Y",MsgTypeCode,EOrder,ERowID))  q:(ERowID="")||(PreEvalateFlag'="Y")||(EDFlag'="")  d
	..s EInvalidFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",15)
	..q:EInvalidFlag="Y"
	..s EHosptialDR=$p($g(^DHCEQCEvaluation(ERowID)),"^",3)
	..s EEquipTypeDR=$p($g(^DHCEQCEvaluation(ERowID)),"^",4)
	..s ERoleDR=$p($g(^DHCEQCEvaluation(ERowID)),"^",2)
	..q:$D(^DHCEQCEvaluation(0,"Evaluation","Y",+THosptialDR,MsgTypeCode,+TEquipTypeDR,ERoleDR))&&(EHosptialDR="")&&(EEquipTypeDR="")
	..q:(EHosptialDR'="")&&(EHosptialDR'=THosptialDR)	
	..q:(EEquipTypeDR'="")&&(EEquipTypeDR'=TEquipTypeDR)
	..s FindEvaluateFlag="1"
	..;安全组访问角色权限，角色访问业务
	..q:(CurRoleDR="")&&('$D(^DHCEQCCode("DHCEQCGroupRole",0,"GroupRole",CurGroupDR,ERoleDR)))
	..q:(CurRoleDR="")&&('$D(^DHCEQCCode("DHCEQCRoleBuss",0,"RoleBuss",ERoleDR,MsgTypeCode)))
	..;角色管理范围控制
	..s OpeFlag=..GetOpeFlagByBussRole(MsgTypeCode,ALSourceID,ERoleDR,CurLocDR,CurUserDR)
	..q:OpeFlag'=1
	..s FindEvaluateFlag="2"
	..;检测是否已评价
	..s EMPEvaluationFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",8)		//多人评价标志
	..s EDRowID=0
	..f  s EDRowID=$o(^DHCEQEvaluate(0,"SourceID",MsgTypeCode,ALSourceID,EDRowID))  q:(EDRowID="")||(EDFlag'="")  d
	...s EDHold1=$p($g(^DHCEQEvaluate(EDRowID)),"^",11)
	...q:EDHold1'=ERowID
	...s EDUserDR=$p($g(^DHCEQEvaluate(EDRowID)),"^",7)
	...i EMPEvaluationFlag'="Y" s EDFlag=2			//非多人评价时任意用户评价过则此单据评价结束
	...q:EDFlag'=""
	...i EDUserDR=CurUserDR s EDFlag=1			//可多人评价,且当前用户已评价
	..i EDetailInfo'="" s EDetailInfo=EDetailInfo_"&"
	..i EDFlag'=""  d
	...s EDetailInfo=EDetailInfo_"1^"_EDFlag_"^"_ERoleDR_"^"_ERowID
	...s EDFlag=""
	...s FindEvaluateFlag=""
	..e  d
	...s PreEvalateFlag="N"				//未评价记录,则后序评价不再检测
	...s EDetailInfo=EDetailInfo_"0^^"_ERoleDR_"^"_ERowID
	
	i CurRoleDR'=""
	{
		//检测已评价记录中是否有当前角色
		s ECount=$L(EDetailInfo,"&")
		s EDFind=""
		s CurRow=1
		f EDCurRow=1:1:ECount  d
		.q:EFind'=""
		.s EDCurRowInfo=$p(EDetailInfo,"&",EDCurRow)
		.q:EDCurRowInfo=""
		.s EDCurRoleDR=$p(EDCurRowInfo,"^",3)
		.i EDCurRoleDR=CurRoleDR s EDFind=EDCurRowInfo
		i EDFind=""
		{
			s EDCurRowInfo=$p(EDetailInfo,"&",ECount)
			s EDRole=$p(EDCurRowInfo,"^",3)
			i EDRole'="" s EDRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",EDRole)),"^",2)
			q "-1^["_EDRole_"]还未完成评价!不能操作."
		}
		q EDFind
	}
	q EDetailInfo
}

/// Add By DJ 2017-02-23
/// 描述:根据角色管理范围获取业务访问权限
/// 返回值:0表示无权限  1表示有权限
ClassMethod GetOpeFlagByBussRole(vBussCode, vBussID, vRoleDR, vLocDR, vUserDR)
{
	n ManageLocFlag,ReturnFlag
	n UseLocDR,AcceptUserDR
	s (UseLocDR,AcceptUserDR,RequestUserDR,MGRowID,MGInvalidFlag,MGLRowID,MGLInvalidFlag,MGLMemberDR,MGLManager,MGLRowID2)=""
	s ReturnFlag=0
	//获取角色管理范围(本科，本组，本人)【"0":"所有","1":"根据权限","2":"本科","3":"本院","4":"本组","5":"本人"】
	s ManageLocFlag=$p($g(^DHCEQCCode("DHCEQCApproveRole",vRoleDR)),"^",5)
	i (ManageLocFlag="")||(ManageLocFlag="1")||(ManageLocFlag="3") q 1
	i vBussCode="31"
	{
		s UseLocDR=$p($g(^DHCEQMMaintRequest(vBussID)),"^",6)
		s AcceptUserDR=$p($g(^DHCEQMMaintRequest(vBussID)),"^",26)
		s RequestUserDR=$p($g(^DHCEQMMaintRequest(vBussID)),"^",20)
	}
	i (ManageLocFlag=2)&&(UseLocDR=vLocDR) s ReturnFlag=1
	i (ManageLocFlag=4)&&(vBussCode="31")
	{
		i AcceptUserDR'=vUserDR		//受理人为当前用户
		{
			//维修业务检测当前用户是否维修组长
			s MGRowID=0
			f  s MGRowID=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",1,vUserDR,MGRowID))  q:(MGRowID="")||(ReturnFlag'=0)  d
			.s MGInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)
			.q:MGInvalidFlag="Y"
			.s MGLRowID=0
			.f  s MGLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",MGRowID,MGLRowID))  q:(MGLRowID="")||(ReturnFlag'=0)  d
			..s MGLInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",6)
			..q:MGLInvalidFlag="Y"
			..s MGLMemberDR=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",2)
			..i MGLMemberDR=AcceptUserDR s ReturnFlag=1
			s MGLRowID=0
			f  s MGLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",vUserDR,MGLRowID))  q:(MGLRowID="")||(ReturnFlag'=0)  d
			.s MGLManager=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",5)
			.q:MGLManager'="Y"
			.s MGRowID=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",1)
			.s MGLRowID2=0
			.f  s MGLRowID2=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",MGRowID,MGLRowID2))  q:(MGLRowID2="")||(ReturnFlag'=0)  d
			..s MGLInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID2)),"^",6)
			..q:MGLInvalidFlag="Y"
			..s MGLMemberDR=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID2)),"^",2)
			..i MGLMemberDR=AcceptUserDR s ReturnFlag=1
		}
		else
		{
			s ReturnFlag=1
		}
	}
	i (ManageLocFlag=5)&&((AcceptUserDR=vUserDR)||(RequestUserDR=vUserDR)) s ReturnFlag=1
	
	q ReturnFlag
}

/// add by zx 2017-01-11
/// 根据安全组和科室获取相关操作人员
/// 返回值 "userid1^userid2^userid3"
/// w ##Class(web.DHCEQEvaluate).GetUserIDByGroup("86", "111")
ClassMethod GetUserIDByGroup(CurGroupDR, CurLocDR)
{
	new SSUSRID,UserID,CHL
	s UserID=""
	s SSUSRID=0
	f  s SSUSRID=$o(^SSU("SSUSR",SSUSRID)) q:SSUSRID=""  d
	.i $p($g(^SSU("SSUSR",SSUSRID)),"^",4)=CurLocDR d
	..i UserID="" d
	...s UserID=SSUSRID
	..e  d
	...s UserID=UserID_"^"_SSUSRID
	.s CHL=0
	.f  s CHL=$O(^SSU("SSUSR",SSUSRID,"OTHLL",CHL)) q:(CHL="")  d
	..q:$P(^SSU("SSUSR",SSUSRID,"OTHLL",CHL),"^",2)'=CurGroupDR	//是否在指定安全组内的用户
	..q:$P(^SSU("SSUSR",SSUSRID,"OTHLL",CHL),"^",1)'=CurLocDR //有指定科室时,判断科室
	..i UserID="" d
	...s UserID=SSUSRID
	..e  d
	...s UserID=UserID_"^"_SSUSRID
	
	q UserID
}

/// add by zx 2017-04-28 
/// 评价信息新增、更新
/// w ##Class(web.DHCEQEvaluate).SaveData("^31^698^^20","1^^1^5^^4^^^*2^^2^5^^4^^^*3^^3^5^^4^^^","2620")
ClassMethod SaveData(val, valList, UserDR As %String = "", TransFlag As %String = "")
{
    new RowID,Date,Time,RoleDR,RoleInfo,ActionID
    k PLIST
    i UserDR="" s UserDR=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s Date=+$H
    s Time=$P($H,",",2)
    //add by zx 2017-09-06 微信端无角色处理
    s RoleDR=$p(val,"^",5)
    i ($p(val,"^",12)'="")&&($p(val,"^",13)'="") d
    .s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction($p(val,"^",13),$p(val,"^",12))
    .s RoleDR=$p(RoleInfo,"^",1)
    s RowID = $p(val,"^",1)
    s PLIST(2) = $p(val,"^",2)  //SourceType
    s PLIST(3) = $p(val,"^",3)  //SourceID
    s PLIST(4) = $p(val,"^",4)  //Content
    s PLIST(5) = RoleDR
    s PLIST(6) = UserDR  //UserDR
    s PLIST(7) = Date  //EvaluationDate
    s PLIST(8) = Time  //EvaluationTime
    s PLIST(9) = $p(val,"^",6)  //Remark
    s PLIST(10) = $p(val,"^",7)  //Hold1
    s PLIST(11) = $p(val,"^",8)  //Hold2
    s PLIST(12) = $p(val,"^",9)  //Hold3
    s PLIST(13) = $p(val,"^",10)  //Hold4
    s PLIST(14) = $p(val,"^",11)  //Hold5
    //ActionID add by zx 2017-11-22 Bug ZX0052
    s ActionID=""  //Modify DJ 2018-03-05
    i $p(val,"^",12)'="" s ActionID=$o(^DHCEQCCode("DHCEQCAction",0,"Code",$p(val,"^",12),0))
    s PLIST(15) = ActionID
    s PLIST(16) = $p(val,"^",14)
    TSTART
    if RowID=""
    {
        &SQL(insert into sqluser.DHC_EQEvaluate values :PLIST())
    }
    else
    {
        &SQL(update sqluser.DHC_EQEvaluate values :PLIST() where E_RowID=:RowID)
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    s RowID=$G(%ROWID)
    
    s SQLCODE=..SaveEvaluateList(RowID,valList)
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    
    TCOMMIT
    q RowID
ERRORSave 
    Set ErrorMsg=$ZE         //得到系统返回的错误消息
    TROLLBACK                //回滚事务
    Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// add by zx 2017-04-28 
/// 评价明细信息新增、更新
ClassMethod SaveEvaluateList(ERowID, val)
{
    new (ERowID, val)
    k PLISTMX
    i ERowID="" q -1
    i val="" q 0
    s Flag=0
    s PLISTMX(2)=ERowID  //EvaluateDR
    s Length=$l(val,"*")
    for i=1:1:Length
    {
        q:Flag'=0
        s valList=  $p(val,"*",i)
        s index= $p(valList,"^",1)          ;index
        s ELRowID= $p(valList,"^",2)        ;ELRowID
        s PLISTMX(3)=$p(valList,"^",3)      ;EvaluateTypeDR
        s PLISTMX(4)=$p(valList,"^",4)      ;Score
        s PLISTMX(5)=$p(valList,"^",5)      ;Content
        s PLISTMX(6)=$p(valList,"^",6)      ;EvaluateGroupDR
        s PLISTMX(7)=$p(valList,"^",7)      ;Hold1
        s PLISTMX(8)=$p(valList,"^",8)      ;Hold2
        s PLISTMX(9)=$p(valList,"^",9)      ;Hold3
        
        if (ELRowID="")
        {
            &SQL(Insert Into SQLUSER.DHC_EQEvaluateList Values :PLISTMX())
        }
        else
        {
            &SQL(update sqluser.DHC_EQEvaluateList values :PLISTMX() where EL_RowID=:ELRowID)
        }
        i SQLCODE s Flag=index_"^更新明细记录失败!"
    }
    q Flag
}

/// //////////////////////////////////////////////////////////////////////////////////////
/// Add By DJ 2017-01-08
/// 描述:获取各业务评价情况
/// d ##class(%ResultSet).RunQuery("web.DHCEQEvaluate","GetBussEvaluate","31","","126","84","3828","","")
Query GetBussEvaluate(vBussType As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", CurUserDR As %String = "", IsOperFlag As %String = "", HeaderFlag As %String = "") As %Query(ROWSPEC = "TBussNo:%String,TEquip:%String,TBussRowID:%String,TFileNo:%String,TEquipNo:%String,TRole:%String,TEvaluate:%String")
{
}

ClassMethod GetBussEvaluateExecute(ByRef qHandle As %Binary, vBussType As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", CurUserDR As %String = "", IsOperFlag As %String = "", HeaderFlag As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i CurGroupDR="" Quit $$$OK
    // add by zx 2017-05-04 获取安全组角色
    s CurRoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(CurGroupDR) 
    s index=1
    s ApproveTypeDR=##Class(web.DHCEQMessages).GetApproveTypeByBussType(vBussType) 
    s ALSourceID=0
    f  s ALSourceID=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR,ALSourceID))  q:ALSourceID=""  d
    .d ResetVariablesGetBussEvaluate
    .s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(vBussType,ALSourceID)
    .s TBussInvalidFlag=$p(BussInfo,"^",13)
    .q:TBussInvalidFlag="Y"  //删除不可评价
    .s TEquipTypeDR=$p(BussInfo,"^",15)
    .q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupDR)=1  //范围外不可评价
    .s BussEvaluateFlag=-1  //可评价标志,默认为0
    .s CheckValue=-1 //游标,用于比较获取最大值
    .s ALRowID=0
    .f  s ALRowID=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR,ALSourceID,ALRowID))  q:(ALRowID="")||(BussEvaluateFlag>0)  d
    ..s ALApproveRoleDR=$p($g(^DHCEQApproveList(ALRowID)),"^",5)
    ..q:(","_CurRoleIDs_",")'[(","_ALApproveRoleDR_",")
    ..s TRole=ALApproveRoleDR
    ..s CheckValue=..GetBussEvaluateFlag(vBussType,ALSourceID,CurGroupDR,CurUserDR,ALApproveRoleDR,CurLocDR)
    ..i CheckValue>BussEvaluateFlag s BussEvaluateFlag=CheckValue
    .q:BussEvaluateFlag=-1
    .s TBussType=ApproveTypeDR
    .s TBussNo=$p(BussInfo,"^",1)
    .s TEquip=$p(BussInfo,"^",2)
    .s TBussRowID=ALSourceID
    .s TEquipNo=$p(BussInfo,"^",23)
    .s TFileNo=$p(BussInfo,"^",24)
    .s TEvaluate=BussEvaluateFlag
    .d OutputRowGetBussEvaluate
    
    Quit $$$OK
OutputRowGetBussEvaluate
    s Data=$lb(TBussNo,TEquip,TBussRowID,TFileNo,TEquipNo,TRole,TEvaluate)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetBussEvaluate
    s (TBussNo,TEquip,TBussRowID,TFileNo,TEquipNo,TRole,TEvaluate)=""
    quit
}

ClassMethod GetBussEvaluateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussEvaluateExecute ]
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

ClassMethod GetBussEvaluateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussEvaluateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 返回值:-1,无权限 0,可评价 其他,可查看
ClassMethod GetBussEvaluateFlag(BussCode, ALSourceID, CurGroupDR, CurUserDR, CurRoleDR, CurLocDR)
{
    n ReturnFlag,EOrder,ERowID,EInvalidFlag,EMPEvaluationFlag,ERoleDR,OpeFlag,EDFlag,EDUserDR
    
    s EDFlag=-1 
    s EOrder=0
    f  s EOrder=$o(^DHCEQCEvaluation(0,"SourceTypeSort","Y",BussCode,EOrder)) q:EOrder=""  d
    .s ERowID=0
    .f  s ERowID=$o(^DHCEQCEvaluation(0,"SourceTypeSort","Y",BussCode,EOrder,ERowID)) q:(ERowID="")||(EDFlag'=-1)  d
    ..s EInvalidFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",15)
    ..q:EInvalidFlag="Y"
    ..s EMPEvaluationFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",8)       //多人评价标志
    ..s EIndependentFlag=$p($g(^DHCEQCEvaluation(ERowID)),"^",9)        //独立评价标志
    ..s ERoleDR=$p($g(^DHCEQCEvaluation(ERowID)),"^",2)
    ..s OpeFlag=..GetOpeFlagByBussRole(BussCode,ALSourceID,CurRoleDR,CurLocDR,CurUserDR)
    ..q:OpeFlag'=1
    ..s EDFlag=-1 
    ..i ERoleDR'=CurRoleDR d //权限内,显示已评单据供查看
    ...s EDRowID=0
    ...f  s EDRowID=$o(^DHCEQEvaluate(0,"SourceRole",BussCode,ALSourceID,CurRoleDR,EDRowID))  q:(EDRowID="")||(EDFlag'=0)  d
    ....s EDFlag=EDRowID
    ..e  d //当前角色,是否可见已在权限范围处过滤,显示已评或未评
    ...s EDRowID=0
    ...s EDFlag=0 //默认科评价
    ...f  s EDRowID=$o(^DHCEQEvaluate(0,"SourceRole",BussCode,ALSourceID,CurRoleDR,EDRowID))  q:(EDRowID="")||(EDFlag'=0)  d
    ....i EMPEvaluationFlag'="Y" s EDFlag=EDRowID
    ....q:EDFlag'=0
    ....s EDUserDR=$p($g(^DHCEQEvaluate(EDRowID)),"^",7)
    ....i EDUserDR=CurUserDR s EDFlag=EDRowID   
    
    q EDFlag
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQEvaluate","EvaluateDetail","","31","572","","WX_Audit")
Query EvaluateDetail(EvaluateDR As %String = "", SourceType As %String = "", SourceID As %String = "", CurRole As %String = "", ActionCode As %String = "", ApproveSetDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TContent:%String,TEvaluationDate:%String,TRemark:%String,TEvaluateListDR:%String,TEvaluateTypeDR:%String,TEvaluateType:%String,TEvaluateTypeDesc:%String,TScore:%String,TLContent:%String,TEvaluateGroupDR:%String") [ SqlProc ]
{
}

ClassMethod EvaluateDetailExecute(ByRef qHandle As %Binary, EvaluateDR As %String = "", SourceType As %String = "", SourceID As %String = "", CurRole As %String = "", ActionCode As %String = "", ApproveSetDR As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    
    i ActionCode'="" d
    .s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSetDR,ActionCode)
    .s CurRole=$p(RoleInfo,"^",1)
    
    Set index=1
    i ((SourceType="")&&(SourceID="")) Quit $$$OK
    
    i EvaluateDR="" d
    .s EvaluateDR=$o(^DHCEQEvaluate(0,"SourceRole","31",SourceID,CurRole,0))
    
    i EvaluateDR'="" d
    .d ResetVariablesEvaluateDetail
    .s TRowID=EvaluateDR
    .s TSourceType=$p($g(^DHCEQEvaluate(EvaluateDR)),"^",1)
    .s TSourceID=$p($g(^DHCEQEvaluate(EvaluateDR)),"^",2)
    .s TContent=$p($g(^DHCEQEvaluate(EvaluateDR)),"^",3)
    .s TEvaluationDate=$p($g(^DHCEQEvaluate(EvaluateDR)),"^",6)
    .s TRemark=$p($g(^DHCEQEvaluate(EvaluateDR)),"^",8)
    .s TEvaluateListDR=0
    .f  s TEvaluateListDR=$o(^DHCEQEvaluateList(0,"Evaluate",EvaluateDR,TEvaluateListDR)) q:TEvaluateListDR=""  d
    ..s TEvaluateTypeDR=$p($g(^DHCEQEvaluateList(TEvaluateListDR)),"^",2)
    ..i TEvaluateTypeDR'="" d
    ...s TEvaluateType=$p($g(^DHCEQCCode("DHCEQCEvaluateType",TEvaluateTypeDR)),"^",1)
    ...s TEvaluateTypeDesc=$p($g(^DHCEQCCode("DHCEQCEvaluateType",TEvaluateTypeDR)),"^",2)
    ..s TScore=$p($g(^DHCEQEvaluateList(TEvaluateListDR)),"^",3)
    ..s TLContent=$p($g(^DHCEQEvaluateList(TEvaluateListDR)),"^",4)
    ..s TEvaluateGroupDR=$p($g(^DHCEQEvaluateList(TEvaluateListDR)),"^",5)
    ..d OutputRowEvaluateDetail
    e  d
    .d ResetVariablesEvaluateDetail
    .s TEvaluationDR=0
    .f  s TEvaluationDR=$o(^DHCEQCEvaluation(0,"Evaluation","N",2,SourceType,"0",CurRole,TEvaluationDR)) q:TEvaluationDR=""  d
    ..s ActionID=$p($g(^DHCEQCEvaluation(TEvaluationDR)),"^",16) //add by zx 2017-11-22 Bug ZX0052
    ..q:(ActionCode'="")&&($o(^DHCEQCCode("DHCEQCAction",0,"Code",ActionCode,0))'=ActionID)
    ..s TEvaluationListDR=0
    ..f  s TEvaluationListDR=$o(^DHCEQCEvaluationList(0,"Evaluation",TEvaluationDR,TEvaluationListDR)) q:TEvaluationListDR=""  d
    ...s TEvaluateTypeDR=$p($g(^DHCEQCEvaluationList(TEvaluationListDR)),"^",2)
    ...i TEvaluateTypeDR'="" d
    ....s TEvaluateType=$p($g(^DHCEQCCode("DHCEQCEvaluateType",TEvaluateTypeDR)),"^",1)
    ....s TEvaluateTypeDesc=$p($g(^DHCEQCCode("DHCEQCEvaluateType",TEvaluateTypeDR)),"^",2)
    ...s TEvaluateGroupDR=$p($g(^DHCEQCEvaluationList(TEvaluationListDR)),"^",4)
    ...d OutputRowEvaluateDetail
    
    Quit $$$OK
OutputRowEvaluateDetail
    s Data=$lb(TRowID,TSourceType,TSourceID,TContent,TEvaluationDate,TRemark,TEvaluateListDR,TEvaluateTypeDR,TEvaluateType,TEvaluateTypeDesc,TScore,TLContent,TEvaluateGroupDR)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesEvaluateDetail
    Set (TRowID,TSourceType,TSourceID,TContent,TEvaluationDate,TRemark,TEvaluateListDR,TEvaluateTypeDR,TEvaluateType,TEvaluateTypeDesc,TScore,TLContent,TEvaluateGroupDR,TEvaluationDR,TEvaluationListDR)=""
    quit
}

ClassMethod EvaluateDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EvaluateDetailExecute ]
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

ClassMethod EvaluateDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EvaluateDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
