/// 修改:zy 2009-12-02  No ZY0018
/// 方法:GetApproveSet
/// 描述:增加入库审批设置
Class web.DHCEQApproveList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetApproveType(Code)
{
	s ATID=""
	&SQL(select AT_RowID into :ATID from sqluser.DHC_EQCApproveType where AT_Code=:Code and AT_InvalidFlag='N')
	q ATID
}

/// 2015-09-28 ZY0144   增加一个审批标记:统一/拒绝
ClassMethod UpdateData(ApproveType, Source, Opinion, Remark, Role, Step, UserID As %String = "", OperateType As %String = "0")
{
	i UserID=""
	{
		s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	}
	else
	{
		s User=UserID
	}
	s Date=+$H
	s Time=$P($H,",",2)
	//2015-09-28 ZY0144   原来的审核信息保留，新的审核记录新写入.这样对业务没有影响.
	//s HasFlag=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, Source, Step, Role)
	s HasFlag=0
	s Action=""  //modify by mwz 20210521 MWZ0049
	k APPL
	s APPL(2)=ApproveType
	s APPL(3)=Source
	s APPL(4)=Opinion
	s APPL(5)=Remark
	s APPL(6)=Role
	s APPL(7)=User
	s APPL(8)=Date
	s APPL(9)=Time
	s APPL(10)=Step
	;DJ0140
	s APPL(11)="N"
	s APCode=$p($g(^DHCEQCCode("DHCEQCApproveType",ApproveType)),"^",1)
	s APSetDR=..GetApproveSet(APCode,Source)
	s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",APSetDR,Step,0))
	i AFRowID'="" s Action=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",9)  //modify by mwz 20210521 MWZ0049
	s APPL(12)=Action
	s APPL(13)=OperateType  //2015-09-28 ZY0144   增加一个审批标记:统一/拒绝
	
	if HasFlag>0
	{
		&SQL(update sqluser.DHC_EQApproveList values :APPL() where AL_RowID=:HasFlag)
	}
	else
	{
		&SQL(insert into sqluser.DHC_EQApproveList values :APPL())
	}
	i SQLCODE q SQLOCDE
	;取消提交时处理
	i OperateType=1
	{
		s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,Source,0))
		i AIRowID'=""
		{
			s AINextFlowStep=$p($g(^DHCEQApproveInfo(AIRowID)),"^",5)
			s AIStatus=$p($g(^DHCEQApproveInfo(AIRowID)),"^",8)
			i AIStatus=1
			{
				s CALRowID=0
				f  s CALRowID=$o(^DHCEQApproveList(0,"Source",ApproveType,Source,CALRowID))  q:(CALRowID="")||(SQLCODE'=0)  d
				.s CALInvalidFlag=$p($g(^DHCEQApproveList(CALRowID)),"^",10)
				.q:CALInvalidFlag="Y"
				.s CALOperateType=$p($g(^DHCEQApproveList(CALRowID)),"^",12)
				.q:CALOperateType=1
				.s CALFlowStep=$p($g(^DHCEQApproveList(CALRowID)),"^",9)
				.q:CALFlowStep<AINextFlowStep
				.&SQL(Update SQLUSER.DHC_EQApproveList set AL_InvalidFlag='Y' Where AL_RowID=:CALRowID)
			}
		}
	}
	i SQLCODE q SQLOCDE
	//增加时效信息表
	i Action="" q 0
	K PI
	s ALRowID=$Get(%ROWID)
	s ApproveCode=$p($g(^DHCEQCCode("DHCEQCApproveType",ApproveType)),"^",1)
	s EquipTypeDR=""
	s LocDR=""
	i ApproveCode="25"
	{
		
		s EquipTypeDR=$p($g(^DHCEQMMaintRequest(Source)),"^",3)
		s LocDR=$p($g(^DHCEQMMaintRequest(Source)),"^",7)		//RequestLocDR
	}
	s HospitalDR=""
	;i LocDR'="" s HospitalDR=+$p($g(^CTLOC(LocDR)),"^",22)    //modify by jyp 2019-10-18 CTLOC调整
	i LocDR'="" s HospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)    //modify by jyp 2019-10-18 CTLOC调整
	s PIRowID=""
	&SQL(Select PI_RowID Into :PIRowID From SQLUSER.DHC_EQPrescriptionInfo Where PI_ApproveListDR=:ALRowID)
	s PRowID=$o(^DHCEQPrescription(0,"Prescription",+HospitalDR,ApproveType,+EquipTypeDR,+Action,0))
	i PRowID="" s PRowID=$o(^DHCEQPrescription(0,"Prescription",+HospitalDR,ApproveType,0,+Action,0))
	i PRowID="" s PRowID=$o(^DHCEQPrescription(0,"Prescription",0,ApproveType,0,+Action,0))
	s (PLRowID,FromAction,TimeNum,TimeUnitDR,FromActionDate,FromActionTime)=""
	i PRowID'="" s PLRowID=$o(^DHCEQPrescriptionList(0,"Prescription",PRowID,0))
	i PLRowID'=""
	{
		s FromAction=+$p($g(^DHCEQPrescriptionList(PLRowID)),"^",2)
		s TimeNum=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",3)
		s TimeUnitDR=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",4)
	}
	i FromAction="" q 0
	&SQL(Select AL_ApproveDate,AL_ApproveTime Into :FromActionDate,:FromActionTime From SQLUSER.DHC_EQApproveList where AL_ApproveTypeDR=:ApproveType and AL_SourceID=:Source and AL_InvalidFlag='N' and AL_Action=:FromAction)
	s PI(2)=ALRowID		//ApproveListDR
	s PI(3)=FromActionDate			//FromActionDate
	s PI(4)=FromActionTime			//FromActionTime
	s PI(5)=Date		//ToActionDate
	s PI(6)=Time		//ToActionTime
	s PI(7)=TimeNum			//TimeNum
	s PI(8)=TimeUnitDR			//TimeUnitDR
	;s PI(9)=(Date-FromActionDate)*($CASE(TimeUnitDR,"1":"0.365","2":"0.3","3":"1"))			//TimeAount
	s PI(9)=+##Class(web.DHCEQCommon).TimeDiff(FromActionDate,FromActionTime,Date,Time,0)
	s UnitNum=+$CASE(TimeUnitDR,1:"31536000",2:"2592000",3:"86400",4:"3600",5:"60",6:"1",:"0")
	s PassTime=+$p($g(^DHCEQPrescriptionList(PLRowID)),"^",3)*UnitNum
	s WaringTime=+$p($g(^DHCEQPrescriptionList(PLRowID)),"^",5)*UnitNum
	s PI(12)=0
	i (WaringTime<=PI(9))&&(PI(9)<PassTime) s PI(12)=1
	i (PI(9)>=PassTime) s PI(12)=2
	s PI(10)=FromAction		//FromAction
	s PI(11)=Action		//ToAction
	i PIRowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQPrescriptionInfo values :PI())
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQPrescriptionInfo values :PI() Where PI_RowID=:PIRowID)
	}
	
	q SQLCODE
}

ClassMethod GetApproveByRource(ApproveTypeCode, Source)
{
	new ApproveList,ApproveType
	s (ApproveList,ApproveType)=""
	s ApproveType=..GetApproveType(ApproveTypeCode)
	s rowid=0
	s i=0
	f  s rowid=$o(^DHCEQApproveList(0,"Source",ApproveType,Source,rowid))  q:rowid=""  d
	.i i>0 s ApproveList=ApproveList_"^"
	.s i=i+1
	.s Role=$p(^DHCEQApproveList(rowid),"^",5)
	.s Step=$p(^DHCEQApproveList(rowid),"^",9)
	.s Opinion=$p(^DHCEQApproveList(rowid),"^",3)
	.s ApproveList=ApproveList_Role_","_Step_","_Opinion
	s ApproveList=##class(web.DHCEQCommon).Replace(ApproveList,$C(13,10),"\n")
	q ApproveList
}

// 2015-09-28 ZY0144   增加一个审批标记:统一/拒绝 

// 原来的审核信息保留，新的审核记录新写入.这样对业务没有影响.在取消提交的时候可以不用调用这个方法.

/// 删除已经审批过的意见在"提交"得到ApproveSet后调用方法##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,Source,ApproveTypeCode)
ClassMethod DeleteApproveList(ApproveSet, Source, ApproveTypeCode, ALUser As %String = "")
{
	new ApproveType,OldApproveSet
	/*
	s OldApproveSet=..GetApproveSet(ApproveTypeCode,Source)
	i OldApproveSet="" q 0
	i ApproveSet=OldApproveSet q 0
	&SQL(delete from sqluser.DHC_EQApproveList where AL_ApproveTypeDR=:ApproveType and AL_SourceID=:Source)
	*/
	s ApproveType=..GetApproveType(ApproveTypeCode)
	&SQL(Select Count(*) Into :ALCount From SQLUSER.DHC_EQApproveList Where AL_ApproveTypeDR=:ApproveType and AL_SourceID=:Source)
	i +ALCount'=0
	{
		&SQL(Update SQLUSER.DHC_EQApproveList Set AL_InvalidFlag='Y' where AL_ApproveTypeDR=:ApproveType and AL_SourceID=:Source)
		i SQLCODE q SQLCODE
	}
	//提交后写入提交ApproveList
	i ALUser="" s ALUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s ALDate=+$H
	s ALTime=$p($H,",",2)
	// 增加一个审批标记:统一/拒绝 
	&SQL(Insert Into SQLUSER.DHC_EQApproveList(AL_ApproveTypeDR,AL_SourceID,AL_Opinion,AL_ApproveUserDR,AL_ApproveDate,AL_ApproveTime,AL_FlowStep,AL_InvalidFlag,AL_Action,AL_OperateType) values(:ApproveType,:Source,'提交',:ALUser,:ALDate,:ALTime,0,'N','0','0'))
	q SQLCODE
}

/// ----------------------------------
/// 修改:zy 2010-02-28  No ZY0018
/// 描述:增加入库审批设置
/// ----------------------------------
/// 根据审批类型以及单据号得到对应的审批设置
ClassMethod GetApproveSet(ApproveTypeCode, Source)
{
	;n (ApproveTypeCode, Source)
	;new ApproveSetDR,ApproveTypeDR,AIRowID
	s ApproveSetDR=""
	i Source="" q ApproveSetDR
	
	;采购申请，采购计划，采购合同 调整用新的ApproveInfo
	;采购论证 审批工作流取消，与采购申请合并。
	;i ApproveTypeCode="1" d
	;.s ApproveSetDR=$p(^DHCEQBuyRequest(Source),"^",20)
	;e  i ApproveTypeCode="3" d
	;.s ApproveSetDR=$p(^DHCEQArgumentation(Source),"^",11)	
	;i ApproveTypeCode="2" d
	;.s ApproveSetDR=$p(^DHCEQBuyPlan(Source),"^",7)	
	;e  i ApproveTypeCode="4" d
	;.s ApproveSetDR=$p(^DHCEQBuyPlan(Source),"^",41)
	;e  i ApproveTypeCode="8" d
	;.s ApproveSetDR=$p(^DHCEQContract(Source),"^",42)
	;e  i ApproveTypeCode="12" d
	;.s ApproveSetDR=$p(^DHCEQBuyPlan(Source),"^",7)
	
	i ApproveTypeCode="5" d
	.s ApproveSetDR=$p(^DHCEQDisuseRequest(Source),"^",27)
	e  i ApproveTypeCode="6" d
	.s ApproveSetDR=$p(^DHCEQCheck(Source),"^",17)
	e  i ApproveTypeCode="7" d
	.i ##class(web.DHCEQCommon).GetSysInfo("201003")="1"  d
	..s ApproveSetDR=$p(^DHCEQOpenCheckRequest(Source),"^",32)
	.e  d
	..s ApproveSetDR=$p(^DHCEQOpenCheck(Source),"^",26)
	e  i ApproveTypeCode="9" d
	.s ApproveSetDR=$p(^DHCEQOuterMaintRequest(Source),"^",15)
	e  d
	.s ApproveSetDR=..GetApproveSetNew(ApproveTypeCode, Source)
	q ApproveSetDR
}

ClassMethod GetOpinionByRole(ApproveTypeCode, Source, curRole)
{
	n (ApproveTypeCode, Source, curRole)
	;new ApproveList,ApproveType,Opinion
	s (ApproveList,ApproveType,Opinion)=""
	s ApproveType=..GetApproveType(ApproveTypeCode)
	s rowid=0
	f  s rowid=$o(^DHCEQApproveList(0,"Source",ApproveType,Source,rowid))  q:rowid=""  d
	.s Role=$p(^DHCEQApproveList(rowid),"^",5)
	.i curRole=Role s Opinion=$p(^DHCEQApproveList(rowid),"^",3)
	s Opinion=##class(web.DHCEQCommon).Replace(Opinion,$C(13,10),"\n")
	q Opinion
}

/// Add by JDL 2010-8-3
/// 根据新的结构获取审批设置,对于ApproveTypeCode大于13,采用此种方法获取
ClassMethod GetApproveSetNew(ApproveTypeCode, Source)
{
	;n (ApproveTypeCode, Source)
	new ApproveSetDR, ApproveTypeDR, AIRowID
	s ApproveSetDR=""
	s ApproveTypeDR=..GetApproveType(ApproveTypeCode)
	i ApproveTypeDR'=""  d
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveTypeDR,Source,0))
	.i AIRowID'="" s ApproveSetDR=$p(^DHCEQApproveInfo(AIRowID),"^",3)
	q ApproveSetDR
}

/// Add By ZY 2011-03-09
/// 获取一个单据的所有审批信息
/// w ##Class(web.DHCEQApproveList).GetApproveListOpinion(1,8)
/// ----------------------------------
ClassMethod GetApproveListOpinion(approvetype, sourceid)
{
	i sourceid="" q ""
	new id,str,role,user,date,Opinion
	set (str,role,user,date,Opinion)=""
	Set id=0
	For  Set id=$Order(^DHCEQApproveList(0,"Source",approvetype,sourceid,id))  Quit:(id="")  Do
	.Set str=$Piece($Get(^DHCEQApproveList(id)),"^",3)
	.Set role=##class(web.DHCEQCommon).GetTrakNameByID("role",$Piece($Get(^DHCEQApproveList(id)),"^",5))
	.Set user=##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece($Get(^DHCEQApproveList(id)),"^",6))
	.Set date=##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQApproveList(id)),"^",7)_","_$Piece($Get(^DHCEQApproveList(id)),"^",8),"datetime")	//增加审核时间的显示
	.If Opinion'="" Set Opinion=Opinion_$c(13)
	.Set Opinion=Opinion_str_"  "_user_"  "_date
	q Opinion
}

/// Mozy	2016-11-24
/// 获取一个单据的当前最后一步审批信息
/// w ##Class(web.DHCEQApproveList).GetLastApproveListOpinion(25,260)
ClassMethod GetLastApproveListOpinion(approvetype, sourceid)
{
	i sourceid="" q ""
	new id,role,user,date,action,actionDR,Opinion  
	set (role,user,date,action,Opinion)=""   //add by zx ZX0036 2016-12-29 参数混乱优化
	Set id=$Order(^DHCEQApproveList(0,"Source",approvetype,sourceid,""),-1)
	i id="" q ""
	Set Opinion=$Piece($Get(^DHCEQApproveList(id)),"^",3)
	;Set role=##class(web.DHCEQCommon).GetTrakNameByID("role",$Piece($Get(^DHCEQApproveList(id)),"^",5))
	Set user=##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece($Get(^DHCEQApproveList(id)),"^",6))
	Set date=##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQApproveList(id)),"^",7)_","_$Piece($Get(^DHCEQApproveList(id)),"^",8),"datetime")	//增加审核时间的显示
	s actionDR=$p($g(^DHCEQApproveList(id)),"^",11)
	i actionDR'="" s action=$p($g(^DHCEQCCode("DHCEQCAction",actionDR)),"^",2)
	i actionDR=0 s action="提交" 
	i Opinion'="" s action=Opinion  //add by zx ZX0036 2016-12-19 维修进程替换维修动作
	
	q Opinion_"^"_user_"^"_action_"^"_date
}

/// add by czf 2020-07-21
/// 获取拒绝原因列表
/// w ##class(web.DHCEQApproveList).GetRejectReasonList("7",19)
ClassMethod GetRejectReasonList(ApproveTypeCode, Source)
{
	new ApproveList,ApproveType,ALRowid
	s (ApproveList,ApproveType,ReasonList)=""
	s ApproveType=..GetApproveType(ApproveTypeCode)
	s ALRowid=0
	f  s ALRowid=$o(^DHCEQApproveList(0,"Source",ApproveType,Source,ALRowid))  q:ALRowid=""  d
	.q:$p(^DHCEQApproveList(ALRowid),"^",12)'=1
	.s Role=$p(^DHCEQApproveList(ALRowid),"^",5)
	.s Step=$p(^DHCEQApproveList(ALRowid),"^",9)
	.s Opinion=$p(^DHCEQApproveList(ALRowid),"^",3)
	.s RoleDesc=""
	.i Role'="" s RoleDesc=$p(^DHCEQCCode("DHCEQCApproveRole",Role),"^",2)
	.i ReasonList'="" s ReasonList=ReasonList_","_RoleDesc_":"_Opinion
	.e  s ReasonList=RoleDesc_":"_Opinion
	s ReasonList=##class(web.DHCEQCommon).Replace(ReasonList,$C(13,10),"\n")
	q ReasonList
}

// add by ZY20230228 bug:3295367

/// w ##class(web.DHCEQApproveList).GetApproveInfoByActionCode("25",20,0)
ClassMethod GetApproveInfoByActionCode(ApproveTypeCode, Source, ActionCode, step As %String = "")
{
    n ActionDR,ApproveList,ApproveType,ApproveInfo,rowid,DataList
    s (ActionDR,ApproveList,ApproveType,ApproveInfo)=""
    i ActionCode="" q ""
    i ActionCode'=0  d
    .s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code",ActionCode,0))
    e  d
    .s ActionDR=0
    
    s ApproveType=..GetApproveType(ApproveTypeCode)
    s rowid=""
    f  s rowid=$o(^DHCEQApproveList(0,"Source",ApproveType,Source,rowid),-1)  q:(rowid="")||(ApproveInfo'="")  d
    .s DataList=$g(^DHCEQApproveList(rowid))
    .///modified by ZY20230414 bug:3431217
    .s DataList=DataList_"^"_##Class(web.DHCEQCommon).TransValueToPage(($p(DataList,"^",7)_","_$p(DataList,"^",8)),"datetime")
    .q:($p(DataList,"^",10)="Y")
    .q:(step'="")&&(step'=$p(DataList,"^",9))
    .i ($p(DataList,"^",11)=ActionDR) s ApproveInfo=DataList
    s ApproveInfo=##class(web.DHCEQCommon).Replace(ApproveInfo,$C(13,10),"\n")
    q ApproveInfo
}

}
