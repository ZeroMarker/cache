/// 名称: web.DHCEQ.RM.BUSRent
/// 描述: 设备租赁
/// 编写者：ZX
/// 编写日期: 2019-12-31
/// 产品组：设备管理
Class web.DHCEQ.RM.BUSRent Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(Data, DelIs, User As %String = "")
{
	s $ZT="ERRORRent"
	k PLIST,RowID
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	
	TSTART
	if DelIs=1
	{
		s RowID=Data
		&SQL(Delete From SQLUSER.DHC_EQSRent where R_RowID=:RowID)
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
		s RowID = JsonData.RRowID
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSRent",JsonData,.PLIST)
		s RowID = JsonData.RRowID
	 	//s PLIST(5) = User	;RequestUserDR
	 	s PLIST(6) = Date	;RequestDate
	 	s PLIST(7) = Time	;RequestTime
		s PLIST(37) = "0"	;Status
		//s PLIST(41) = $p(^DHCEQCCode("DHCEQCMasterItem",PLIST(8)),"^",3) ;EquipType
		s PLIST(41)=##Class(web.DHCEQ.RM.BUSRent).GetEquipTypeByShare(PLIST(10),PLIST(33))  //Modefied by zc0079 2020-07-10 取资源项对应第一个设备项的类组ID
		s PLIST(42) = "0"   ;ApproveStatus
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQSRent Values :PLIST() where R_RowID = :RowID)
		}
		else
		{
			s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQSRent",+$H,PLIST(4),"")
			&SQL(insert into SQLUSER.DHC_EQSRent Values :PLIST())
			s RowID=$g(%ROWID)
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		//Modify by zc 2020-06-11
		if PLIST(10)'=""
		{
			//预约中资源处理
			&SQL(Update SQLUSER.DHC_EQSShareResource Set RE_RentStatus='2' Where RE_RowID=:PLIST(10))
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORRent
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.RM.BUSRent).GetOneRent("11","ZL_Loan","")
ClassMethod GetOneRent(RowID As %Library.String = "", Action As %Library.String = "", Step As %Library.String = "")
{
	s $ZT="ERRORGetOneRent"
	s ObjRent=##Class(User.DHCEQSRent).%OpenId(RowID)
	s RentInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjRent)
	d RentInfo.%Set("RRequestLocDR_DeptDesc",##Class(web.DHCEQCommon).GetTrakNameByID("dept",ObjRent.RRequestLocDR))
	d RentInfo.%Set("RFromLocDR_DeptDesc",##Class(web.DHCEQCommon).GetTrakNameByID("dept",ObjRent.RFromLocDR))
	d RentInfo.%Set("RFromLocDR_DeptDesc",##Class(web.DHCEQCommon).GetTrakNameByID("dept",ObjRent.RFromLocDR))
	d RentInfo.%Set("RRequestUserDR_UName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjRent.RRequestUserDR))
	d RentInfo.%Set("RItemDR_MIDesc",ObjRent.RItemDR.MIDesc)
	d RentInfo.%Set("RModelDR_MDesc",ObjRent.RModelDR.MDesc)
	d RentInfo.%Set("RShareResourceDR_REEquipName",ObjRent.RShareResourceDR.REEquipName)
	d RentInfo.%Set("REquipNo",ObjRent.RShareResourceDR.REEquipNo)
	d RentInfo.%Set("RLeaveFactoryNo",ObjRent.RShareResourceDR.RELeaveFactoryNo)
	d RentInfo.%Set("RRentManagerDR_UName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjRent.RRentManagerDR))
	d RentInfo.%Set("RLocReceiverDR_UName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjRent.RLocReceiverDR))
	d RentInfo.%Set("RRentOperatorDR_UName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjRent.RRentOperatorDR))
	d RentInfo.%Set("RReturnManagerDR_UName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjRent.RReturnManagerDR))
	d RentInfo.%Set("RLocReturnDR_UName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjRent.RLocReturnDR))
	d RentInfo.%Set("RReturnOperatorDR_UName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjRent.RReturnOperatorDR))
	d RentInfo.%Set("RWorkLoadUOMDR_UOMDesc",ObjRent.RWorkLoadUOMDR.UOMDesc)
	d RentInfo.%Set("RShareItemDR_SIDesc",ObjRent.RShareItemDR.SIDesc)
	;Modify by zc0079 2020-7-10 begin
	i ObjRent.RRentStatus="" d
	.d RentInfo.%Set("RRentStatus",0)
	i ObjRent.RReturnStatus="" d
	.d RentInfo.%Set("RReturnStatus",0)
	;Modify by zc0079 2020-7-10 end
        //QW20200628 begin
	S RRentStatusDesc=$CASE(ObjRent.RRentStatus,"0":"完好","1":"有缺陷","":"")
	d RentInfo.%Set("RRentStatus_Desc",RRentStatusDesc)
	S RReturnStatusDesc=$CASE(ObjRent.RReturnStatus,"0":"完好","1":"有缺陷","":"")
	d RentInfo.%Set("RReturnStatus_Desc",RReturnStatusDesc)
	d RentInfo.%Set("Status",ObjRent.RStatus)
	//QW20200628 end
	;Modify by zc 2020-05-20 ZC0073
	s PriceInfo=##Class(web.DHCEQ.RM.BUSRent).RentFeeCount(RowID)
	i Action="ZL_Return" d
	.;计价方式ID^计价方式^价格^单位ID^单位^工作量^总金额
	.d RentInfo.%Set("RPrice",$p(PriceInfo,"^",3))
	.d RentInfo.%Set("RUOMDR_UOMDesc",$p(PriceInfo,"^",5))
	.d RentInfo.%Set("RWorkLoad",$p(PriceInfo,"^",6))
	.d RentInfo.%Set("RTotalFee",$p(PriceInfo,"^",7))
	i ObjRent.RStatus="3" d
	.d RentInfo.%Set("RUOMDR_UOMDesc",$p(PriceInfo,"^",5))
	;Modify by zc 2020-05-20 ZC0073 begin
	s FMoveDR=##Class(web.DHCEQMoveNew).GetMoveIDBySourceType(64,RowID,1)
	s TMoveDR=##Class(web.DHCEQMoveNew).GetMoveIDBySourceType(64,RowID,2)
	i FMoveDR'="" d
	.s FMoveInfo=##Class(web.DHCEQMoveNew).GetMoveUserInfo(FMoveDR)
	.d RentInfo.%Set("FromMoveUserDR",$p(FMoveInfo,"^",1))
	.d RentInfo.%Set("FromMoveUser",$p(FMoveInfo,"^",2))
	i TMoveDR'="" d
	.s TMoveInfo=##Class(web.DHCEQMoveNew).GetMoveUserInfo(TMoveDR)
	.d RentInfo.%Set("ToMoveUserDR",$p(TMoveInfo,"^",1))
	.d RentInfo.%Set("ToMoveUser",$p(TMoveInfo,"^",2))
	i ObjRent.RResourcePriceDR'="" d RentInfo.%Set("RPrice",ObjRent.RResourcePriceDR.RHPPrice)  //Modefied by zc0079 2020-07-10 添加成本价格显示
	Set AppInfo=##class(web.DHCEQ.Plat.BUSApprove).GetApproveInfoBySourceID("30",RowID,"",RentInfo)
	//中断步骤处理
	s CanChangeValue=""
	i Action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("30",Action,RowID,2)
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_Step_",")) d
	.s MultipleRoleFlag=1
	
	d RentInfo.%Set("MultipleRoleFlag",MultipleRoleFlag)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,RentInfo)
ERRORGetOneRent
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.RM.BUSRent).SubmitData("8","71","85")
ClassMethod SubmitData(RowID, User, GroupID)
{
    Set $ZT="ERRORSubmit"
    s Date=+$H
    s Time=$P($H,",",2)
    i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
    i RowID="" q ""
    s ApproveType=##class(web.DHCEQApproveList).GetApproveType("30")
    s vStatus=$p($g(^DHCEQSRent(RowID)),"^",36)
    if vStatus'="0" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002)
    s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "","")
    i ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9020)
    
    TSTART
    s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"30",User)
    i SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
    s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
    s LastFlag=$P(ApproveFlow,"^",1)
    s NextStep=$P(ApproveFlow,"^",2)
    s NextRole=$P(ApproveFlow,"^",3)
    s AppInfoStatus="1"

    &SQL(update sqluser.DHC_EQSRent set R_Status='1',R_ApproveStatus='1' where R_RowID=:RowID)
    if SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    Set AuditFlag=0         
    i AutoAuditFlag="Y"
    {
        i (NextStep="")||(LastFlag="Y")
        {
            s AuditFlag=1
            //最后一步审核
            i ($p($g(^DHCEQSRent(RowID)),"^",37)=3)
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
            s PLIST(37)="3" 
            s PLIST(42)="2"
            &SQL(update sqluser.DHC_EQSRent values :PLIST() where R_RowID=:RowID)
            i SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
        }
    }
    s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    
    //租赁消息
    s ApproveFlow=ApproveFlow_"^"_ApproveSet
    s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","ZL_Loan",0))
    s vLimitLocDR=$Piece($Get(^DHCEQSRent(RowID)),"^",3)
    s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("64", RowID, User, ApproveFlow, "N","",AuditFlag,GroupID,"","",vLimitLocActions,vLimitLocDR)
    i SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    TCOMMIT
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
    
ERRORSubmit 
    TRollBack   
    Set ErrorMsg=$ZT         //得到系统返回的错误消息
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)    //返回错误消息 ;
}

ClassMethod AuditData(Val, ActionCode, EditFieldsInfo, AffixInfo As %Library.String = "")
{
    n EquipType,ApproveType,ApproveSet,RoleStep,Step,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,EquipDR,ShareResourceDR
    Set $ZT="ERRORAudit"
    s RowID=$P(Val,"^",1)
    i RowID="" q ""
    s User=$P(Val,"^",2)
    s GroupID=$P(Val,"^",4)
	s MoveUser=$P(Val,"^",5)  //Modify by zc 2020-05-20 ZC0073
    s Date=+$H
    s ApproveType=##class(web.DHCEQApproveList).GetApproveType("30")
    s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("30", RowID)
    i ApproveSet="" q -4007
    s RoleStep=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,ActionCode)
    s Role=$p(RoleStep,"^",1)
    s Step=$p(RoleStep,"^",2)
    s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, Step, Role)
    
    s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
    s LastFlag=$P(ApproveFlow,"^",1)
    s NextStep=$P(ApproveFlow,"^",2)
    s NextRole=$P(ApproveFlow,"^",3)
    Set AppInfoStatus="1"
    s AuditFlag=0
    TSTART
    if EditFieldsInfo'=""
    {
        s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(EditFieldsInfo)       //编辑要修改的字段
        i SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)  //错误码
        }
    }
    s EquipDR=""
    s ShareResourceDR=$p($g(^DHCEQSRent(RowID)),"^",9)
    i ShareResourceDR'="" s EquipDR=$p($g(^DHCEQSShareResource(ShareResourceDR)),"^",3)
    
    if (ActionCode="ZL_Loan")
    {
        &SQL(Update SQLUSER.DHC_EQSRent Set R_Status=2 Where R_RowID=:RowID)
        if SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
        s RequestLocDR=$p($g(^DHCEQSRent(RowID)),"^",2)
        i (ShareResourceDR'="")
        {
	        &SQL(Update SQLUSER.DHC_EQSShareResource Set RE_RentLocDR=:RequestLocDR,RE_RentStatus=1 Where RE_RowID=:ShareResourceDR)
            if SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
	    }
        if (EquipDR'="")
        {
            &SQL(Update SQLUSER.DHC_EQEquip Set EQ_RentLocDR=:RequestLocDR,EQ_RentStatus=1 Where EQ_RowID=:EquipDR)
            if SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
        }
	//Modify by zc 2020-06-12
	s SQLCODE=##Class(web.DHCEQMoveNew).CreatMoveByBuss("64",RowID,"1",User ,GroupID, AffixInfo,"",MoveUser)  //Modify by zc 2020-05-20 ZC0073 begin
	if SQLCODE<0
        {
             TROLLBACK
             Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
    }
    //Modify by zc 2020-05-20 ZC0073 begin
    if (ActionCode="ZL_LocReturn")
    {
    	&SQL(Update SQLUSER.DHC_EQSRent Set R_LocReturnDR=:User Where R_RowID=:RowID)
        if SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
    }
    //Modify by zc 2020-05-20 ZC0073 end 
    //Modify by zc 2020-06-12
    if (ActionCode="ZL_Return")
    {
    	s ReturnMoveFlag=##Class(web.DHCEQMoveNew).CheckMoveReturn("64",RowID)
        i ReturnMoveFlag>0
        {
	        s SQLCODE=##Class(web.DHCEQMoveNew).CreatMoveByBuss("65",ReturnMoveFlag,"2",User ,GroupID, AffixInfo,"",MoveUser)  //Modify by zc 2020-05-20 ZC0073 begin
	        if SQLCODE<0
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }  
	    }
	}
    
    i ((NextStep="")||(LastFlag="Y"))
    {
        i ($p($g(^DHCEQSRent(RowID)),"^",37)=3)
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-3001")
        }
        k SPLIST
        s SPLIST(37)="3" 
        s SPLIST(42)="2"
        &SQL(update sqluser.DHC_EQSRent values :SPLIST() where R_RowID=:RowID)
        i SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
        i (ShareResourceDR'="")
        {
	        &SQL(Update SQLUSER.DHC_EQSShareResource Set RE_RentLocDR=null,RE_RentStatus=0 Where RE_RowID=:ShareResourceDR)
	        if SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
	        s PutOnSetDR=$p($g(^DHCEQSShareResource(ShareResourceDR)),"^",1)
	        i PutOnSetDR'=""
	        {
	        	s ShareItemDR=$p($g(^DHCEQSPutOnSet(PutOnSetDR)),"^",22)
		        i ShareItemDR'=""
		        {
			        s WashFlag=$p($g(^DHCEQSCShareItem(ShareItemDR)),"^",6)
	        		s InspectFlag=$p($g(^DHCEQSCShareItem(ShareItemDR)),"^",7)
	        		s (REWashFlag,REInspectFlag)="Y"
	        		i WashFlag="Y" s REWashFlag="N"
	        		i InspectFlag="Y" s REInspectFlag="N"
	        		&SQL(Update SQLUSER.DHC_EQSShareResource Set RE_WashFlag=:REWashFlag,RE_InspectFlag=:REInspectFlag Where RE_RowID=:ShareResourceDR)
		            if SQLCODE
		            {
		                TROLLBACK
		                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		            }
			    }
		    }
	    }
        if (EquipDR'="")
        {
            &SQL(Update SQLUSER.DHC_EQEquip Set EQ_RentLocDR=null,EQ_RentStatus=0 Where EQ_RowID=:EquipDR)
            i SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)  //错误码
            }
        }
        
        s AppInfoStatus="2"
        s AuditFlag=1
    }
    ;生成审批记录
    s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",Role,Step,User)
    if SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)  //错误码
    }
    
    ;记录单据当前审批状态
    s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,Step,Role,AppInfoStatus)
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)  //错误码
    }
    //申请归还限定人,暂时不考虑续借操作
    s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","ZL_LocReturn",0))
	s vLimitUserDR=$Piece($Get(^DHCEQSRent(RowID)),"^",4)
	//归还限定科室
    s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","ZL_Return",0))
    s vLimitLocDR=$Piece($Get(^DHCEQSRent(RowID)),"^",3)
    s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("64", RowID, User, ApproveFlow_"^"_ApproveSet, "N",Role,AuditFlag,GroupID,vLimitActions,vLimitUserDR,vLimitLocActions,vLimitLocDR)
    i SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)  //错误码
    }
    TCOMMIT
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORAudit
    TRollBack   
    Set ErrorMsg=$ZE         //得到系统返回的错误消息
    Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

ClassMethod CancelSubmitData(Val, CurRole, ActionCode As %Library.String = "")
{
	s $ZT="ERRORCancel"
	s RowID=$p(Val,"^",1)
	s User=$p(Val,"^",2)
	s CancelToFlowDR=$p(Val,"^",3)
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("30",RowID)
	;获取取消到上一步的信息
	s Status="0"
	s RStatus="0"
	s ApproveRoleDR=""
	s Step=""
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("30")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("30", RowID)
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
		if (Step=1)
		{
			s RStatus="1"
		}
		else
		{
			s RStatus="2"
		}
	}
	TSTART
	;生成审批记录
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//Modify by zx 2020-08-28 BUG ZX0105 根据状态处理取消时信息
	if (RStatus="0")
	{
	s ShareResourceDR=$p($g(^DHCEQSRent(RowID)),"^",9)
        i (ShareResourceDR'="")
        {
	        &SQL(Update SQLUSER.DHC_EQSShareResource Set RE_RentLocDR=NULL,RE_RentStatus=0 Where RE_RowID=:ShareResourceDR)
            if SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
	    }
		///借出取消时应该将借出信息清空
		&SQL(update sqluser.DHC_EQSRent set R_RentManagerDR=NULL,R_LocReceiverDR=NULL,R_StartDate=NULL,R_StartTime=NULL,R_RentStatus=NULL,R_ShareResourceDR=NULL,R_RentStatusRemark=NULL,R_ItemDR=NULL,R_ResourcePriceDR=NULL where R_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	//Modify by zx 2020-08-28 BUG ZX0105 根据状态处理取消时信息
	if (RStatus<3)
    {
	    //Modify By zx 2020-05-22 BUG ZX0089 取消操作时,无效配送单
	    s CancelMoveID=##Class(web.DHCEQMoveNew).CheckMoveReturn("64",RowID)
	    i CancelMoveID>0
        {
	        s InvalidDate=+$h
	        &SQL(update sqluser.DHC_EQMove set M_InvalidFlag='Y',M_InvalidUserDR=:User,M_InvalidDate=:InvalidDate where M_RowID=:CancelMoveID)
	        if SQLCODE<0
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }  
	    }
    }
	&SQL(update sqluser.DHC_EQSRent set R_ApproveStatus=:Status,R_Status=:RStatus where R_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	else
	{
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
		}
		else
		{
			s ApproveFlow="^^^^^^^^"_ApproveSet
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("64", RowID, User, ApproveFlow, "Y", CurRole)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	 TCOMMIT
	 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
 	
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)     //返回错误消息
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetEquipByShareResource","","","","")
Query GetEquipByShareResource(Desc As %String = "", StoreLocDR As %String = "", ShareItemDR As %String = "", ModelDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquipName:%String,TEquipNo:%String,TItemDR:%String,TItem:%String,TModelDR:%String,TModel:%String,TLeaveFactoryNo:%String,TUnitDR:%String,TUnit:%String")
{
}

ClassMethod GetEquipByShareResourceExecute(ByRef qHandle As %Binary, Desc As %String = "", StoreLocDR As %String = "", ShareItemDR As %String = "", ModelDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s rowid=0
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	i StoreLocDR'="" d
	.f  s rowid=$o(^DHCEQSShareResource(0,"Loc",StoreLocDR,rowid))  quit:rowid=""  d
	..d BuildEquipByShareResource
	e  d
	.f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	..d BuildEquipByShareResource
	Quit $$$OK

BuildEquipByShareResource
	q:+$p($g(^DHCEQSShareResource(rowid)),"^",15)'="0" //过滤租赁中设备
	q:$p($g(^DHCEQSShareResource(rowid)),"^",16)'="Y" //过滤不完好设备
	q:$p($g(^DHCEQSShareResource(rowid)),"^",18)'="0" //过滤未消毒清洗设备
	q:$p($g(^DHCEQSShareResource(rowid)),"^",19)'="Y" //过滤未上架设备
	d ResetVariablesEquipByShareResource
	s TRowID = rowid
	s TPutOnSetDR=$p($g(^DHCEQSShareResource(rowid)),"^",1)
	i TPutOnSetDR'="" s TShareItemDR=$p($g(^DHCEQSPutOnSet(TPutOnSetDR)),"^",22)
	q:(ShareItemDR'="")&&(ShareItemDR'=TShareItemDR)
	s TEquipDR=$p($g(^DHCEQSShareResource(rowid)),"^",3)
	i TEquipDR'="" d
	.s TItemDR=$p($g(^DHCEQEquip(TEquipDR)),"^",7)
	.i TItemDR'="" s TItem=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem", TItemDR)
	.s TCode=$p($g(^DHCEQEquip(TEquipDR)),"^",6)
	.s TUnitDR=$p($g(^DHCEQEquip(TEquipDR)),"^",5)
	.i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom", TUnitDR)
	s TEquipName=$p($g(^DHCEQSShareResource(rowid)),"^",10)
	s TEquipNo=$p($g(^DHCEQSShareResource(rowid)),"^",11)
	s TModelDR=$p($g(^DHCEQSShareResource(rowid)),"^",12)
	q:(ModelDR'="")&&(ModelDR'=TModelDR)
	s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model", TModelDR)
	s TLeaveFactoryNo=$p($g(^DHCEQSShareResource(rowid)),"^",13)
	q:(Desc'="")&($ZCONVERT(TEquipName,"U")'[Desc)&($ZCONVERT(TCode,"U")'[Desc)&($ZCONVERT(TEquipNo,"U")'[Desc)
	d OutputRowEquipByShareResource
	quit
OutputRowEquipByShareResource
	s Data=$lb(TRowID,TEquipDR,TEquipName,TEquipNo,TItemDR,TItem,TModelDR,TModel,TLeaveFactoryNo,TUnitDR,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEquipByShareResource
	s (TRowID,TEquipDR,TCode,TEquipName,TEquipNo,TItemDR,TItem,TModelDR,TModel,TLeaveFactoryNo,TUnitDR,TUnit,TPutOnSetDR,TShareItemDR)=""
	quit
}

ClassMethod GetEquipByShareResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipByShareResourceExecute ]
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

ClassMethod GetEquipByShareResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipByShareResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetItemByShareResource")
/// modified by csj 2020-07-01 添加资源可用设备的总数量输出列 需求号：1396148
Query GetItemByShareResource(Desc As %String = "", StoreLocDR As %String = "", UserID As %String = "", LocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TSourceCount:%String")
{
}

ClassMethod GetItemByShareResourceExecute(ByRef qHandle As %Binary, Desc As %String = "", StoreLocDR As %String = "", UserID As %String = "", LocID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	
	s Job=$J
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i LocID="" s LocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	k ^DHCEQTemp("ItemByShareResource",UserID)
	
	i StoreLocDR'="" d
	.f  s rowid=$o(^DHCEQSShareResource(0,"Loc",StoreLocDR,rowid))  quit:rowid=""  d
	..d GetItemByShareResource
	e  d
	.f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	..d GetItemByShareResource
	
	s TSourceItemDR=0
	f  s TSourceItemDR=$o(^DHCEQTemp("ItemByShareResource",UserID,Job,TSourceItemDR)) q:TSourceItemDR=""  d
	.d ResetVariablesItemByShareResource
	.s SourceCount=0
	.s TRowID=TSourceItemDR
	.s TDesc=$Piece($Get(^DHCEQSCShareItem(TRowID)),"^",3)
	.q:(Desc'="")&&($ZCONVERT(TDesc,"U")'[Desc)   //Modefied by zc0079 2020-07-10  描述过滤
	.//Modify by zx 2020-12-10 BUG ZX0121 优化数量输出
	.;f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	.;.//Modify by zx 2020-12-10 BUG ZX0121 修正过滤处理
	.;.q:+$p($g(^DHCEQSShareResource(rowid)),"^",15)'="0" //过滤租赁中设备
	.;.q:$p($g(^DHCEQSShareResource(rowid)),"^",16)'="Y" //过滤未清洗消毒设备
	.;.q:$p($g(^DHCEQSShareResource(rowid)),"^",18)'="0" //过滤不完好设备
	.;.q:$p($g(^DHCEQSShareResource(rowid)),"^",19)'="Y" //过滤未上架设备
	.;.s TPutOnSetDR=$p($g(^DHCEQSShareResource(rowid)),"^",1)
	.;.i TPutOnSetDR'="" s TShareItemDR=$p($g(^DHCEQSPutOnSet(TPutOnSetDR)),"^",22)
	.;.q:TRowID'=TShareItemDR
	.;.s SourceCount=SourceCount+1
	.s TSourceCount=+$g(^DHCEQTemp("ItemByShareResource",UserID,Job,TSourceItemDR))
	.d OutputRowItemByShareResource
	
	k ^DHCEQTemp("ItemByShareResource",UserID)
	
	Quit $$$OK
	
GetItemByShareResource
	//Modify by zx 2020-12-10 BUG ZX0121 修正过滤处理
	q:+$p($g(^DHCEQSShareResource(rowid)),"^",15)'="0" //过滤租赁中设备
	q:$p($g(^DHCEQSShareResource(rowid)),"^",16)'="Y" //过滤未清洗消毒设备
	q:$p($g(^DHCEQSShareResource(rowid)),"^",17)'="Y" //过滤未检测设备
	q:$p($g(^DHCEQSShareResource(rowid)),"^",18)'="0" //过滤不完好设备
	q:$p($g(^DHCEQSShareResource(rowid)),"^",19)'="Y" //过滤未上架设备
	s TOuterType=$p($g(^DHCEQSShareResource(rowid)),"^",9)
	s THospitalDR=$p($g(^DHCEQSShareResource(rowid)),"^",6)
	q:(TOuterType="0")&&(THospitalDR'=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocID)) //院内共享
	s TPutOnSetDR=$p($g(^DHCEQSShareResource(rowid)),"^",1)
	i TPutOnSetDR'="" d
	.s SourceItemDR=$p($g(^DHCEQSPutOnSet(TPutOnSetDR)),"^",22)
	.q:SourceItemDR=""
	.//Modify by zx 2020-12-10 BUG ZX0121 优化数量输出
	.i $d(^DHCEQTemp("ItemByShareResource",UserID,Job,SourceItemDR)) d
	..s ^DHCEQTemp("ItemByShareResource",UserID,Job,SourceItemDR)=+$g(^DHCEQTemp("ItemByShareResource",UserID,Job,SourceItemDR))+1
	.e  d
	..s ^DHCEQTemp("ItemByShareResource",UserID,Job,SourceItemDR)=1
	quit
OutputRowItemByShareResource
	s Data=$lb(TRowID,TDesc,TSourceCount)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesItemByShareResource
	s (TRowID,TDesc)=""
	quit
}

ClassMethod GetItemByShareResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemByShareResourceExecute ]
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

ClassMethod GetItemByShareResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemByShareResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add  by CSJ 2020-02-11
/// modified by csj 2020-07-01 添加科室调配明细查看与科室关联的调配记录 需求号：1396150
/// 描述:租赁申请单查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetRentList")
Query GetRentList(RequestLocDR As %String = "", FromLocDR As %String = "", ItemDR As %String = "", BeginDate As %String = "", EndDate As %String = "", RequestNo As %String = "", StatusDR As %String = "", CurUser As %String = "", Name As %String = "", CurLocDR As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRequestNo:%String,TRequestLoc:%String,TRequestLocDR:%String,TFromLocDR:%String,TFromLoc:%String,TRequestUser:%String,TRequestUserDR:%String,TRequestDate:%String,TRequestTime:%String,TItem:%String,TItemDR:%String,TModel:%String,TModelDR:%String,TEquip:%String,TEquipDR:%String,TStartDate:%String,TStartTime:%String,TPlanEndDate:%String,TPlanEndTime:%String,TRentManager:%String,TRentManagerDR:%String,TLocReceiver:%String,TLocReceiverDR:%String,TRentStatus:%String,TRentStatusRemark:%String,TRentOperatorDR:%String,TRentOperateDate:%String,TRentOperateTime:%String,TReturnManager:%String,TReturnManagerDR:%String,TLocReturn:%String,TLocReturnDR:%String,TReturnDate:%String,TReturnTime:%String,TReturnStatus:%String,TReturnStatusRemark:%String,TReturnOperatorDR:%String,TReturnOperateDate:%String,TReturnOperateTime:%String,TWorkLoad:%String,TWorkLoadUOM:%String,TWorkLoadUOMDR:%String,TRentFee:%String,TLucreFee:%String,TLosingFee:%String,TTotalFee:%String,TStatus:%String,TPlanBeginDate:%String,TPlanBeginTime:%String,TNo:%String,TPrice:%String,TMode:%String,TQuantity:%String,TRequestTel:%String,TApproveInfo:%String,TApproveDate:%String,TWaringFlag:%String,TLeaveFactoryNo:%String,THold2:%String,THold4:%String,TQuantityUom:%String")
{
}

ClassMethod GetRentListExecute(ByRef qHandle As %Binary, RequestLocDR As %String = "", FromLocDR As %String = "", ItemDR As %String = "", BeginDate As %String = "", EndDate As %String = "", RequestNo As %String = "", StatusDR As %String = "", CurUser As %String = "", Name As %String = "", CurLocDR As %String = "", QXType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	//start by csj 2002-07-01 需求号：1396150
	i CurLocDR="" s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s LocType=##class("web.DHCEQ.RM.BUSShareResource").CheckLocType(CurLocDR)  //判断当前登录科室是否是租赁中心
	//end by csj 2002-07-01
	s Date=##class(web.DHCEQCommon).TransValueToPage($h,"date")
	i BeginDate'="" s BeginDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")
	i EndDate'="" s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	s rowid=0
	if RequestNo'=""  d
	.s FindRequestNo=$Order(^DHCEQSRent(0,"RequestNo"," "_RequestNo),-1)
	.For  Set FindRequestNo=$Order(^DHCEQSRent(0,"RequestNo",FindRequestNo))  Quit:((FindRequestNo="")||(FindRequestNo'[RequestNo))  Do
	..Set rowid=0	 
	..For  Set rowid=$Order(^DHCEQSRent(0,"RequestNo",FindRequestNo,rowid))  Quit:rowid=""  Do
	...d BuildDataGetGetRentList
	e  d
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQSRent(rowid))  Quit:rowid=""  Do
	..d BuildDataGetGetRentList
	Quit $$$OK

BuildDataGetGetRentList
	//Modify by zx BUG ZX0089
	s TPriceInfo=##Class(web.DHCEQ.RM.BUSRent).RentFeeCount(rowid)
	d ResetVariablesEquipRent
	s TRowID = rowid	//rowid
	s TStatus=$p($g(^DHCEQSRent(rowid)),"^",36)
	q:(StatusDR'="")&(TStatus'=StatusDR)
	i TStatus'="" s TStatus=$CASE(TStatus,"0":"新增", "1":"申请","2":"借出","3":"归还","4":"其他")
	s TRequestLocDR=$p($g(^DHCEQSRent(rowid)),"^",2)
	q:((TRequestLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR)))	//czf 2021-11-18 2221492
	q:(RequestLocDR'="")&(TRequestLocDR'=RequestLocDR)
	s TFromLocDR=$p($g(^DHCEQSRent(rowid)),"^",3)
	q:(FromLocDR'="")&(TFromLocDR'=FromLocDR)
	q:(CurLocDR'="")&&(CurLocDR'=TFromLocDR)&&(CurLocDR'=TRequestLocDR)&&(LocType'="1")	//add by csj 2020-07-01 需求号：1396150
	s TItemDR=$p($g(^DHCEQSRent(rowid)),"^",7)
	q:(ItemDR'="")&(TItemDR'=ItemDR)
	s TStartDate=$p($g(^DHCEQSRent(rowid)),"^",10)
	q:(BeginDate'="")&&(TStartDate<BeginDate)
	s TReturnDate=$p($g(^DHCEQSRent(rowid)),"^",23)
	q:(EndDate'="")&&(TStartDate>EndDate)
	s TRequestNo=$p($g(^DHCEQSRent(rowid)),"^",1) 
	i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	s TRequestUserDR=$p($g(^DHCEQSRent(rowid)),"^",4)
	i TRequestUserDR'="" s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	s TRequestDate=$p($g(^DHCEQSRent(rowid)),"^",5)
	i TRequestDate'="" s TRequestDate=##class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	s TRequestTime=$p($g(^DHCEQSRent(rowid)),"^",6)
 	s TRequestTime=##class(web.DHCEQCommon).TransValueToPage(TRequestTime,"time")
	i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	s TModelDR=$p($g(^DHCEQSRent(rowid)),"^",8)
	i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TShareResourceDR=$p($g(^DHCEQSRent(rowid)),"^",9)
	s TQuantity=$p($g(^DHCEQSRent(rowid)),"^",39)
	
	i CurUser'=""  d
	.s CurUserID="^"_CurUser_"^"
	.s CurUserIDs="^"_$Piece($Get(^DHCEQSRent(rowid)),"^",4)_"^"_$Piece($Get(^DHCEQSRent(rowid)),"^",14)_"^"_$Piece($Get(^DHCEQSRent(rowid)),"^",15)_"^"_$Piece($Get(^DHCEQSRent(rowid)),"^",18)_"^"_$Piece($Get(^DHCEQSRent(rowid)),"^",21)_"^"_$Piece($Get(^DHCEQSRent(rowid)),"^",22)_"^"_$Piece($Get(^DHCEQSRent(rowid)),"^",27)_"^"
	q:(CurUser'="")&&(CurUserIDs'[CurUserID)

	i TShareResourceDR'=""  d
	.s TEquip=$p($g(^DHCEQSShareResource(TShareResourceDR)),"^",10)
	.s TNo=$p($g(^DHCEQSShareResource(TShareResourceDR)),"^",11)
	.s TLeaveFactoryNo=$p($g(^DHCEQSShareResource(TShareResourceDR)),"^",13) //Modify by zx 2020-05-21 BUG ZX0089
	//Modify by zc 2020-06-12
	i TEquip="" d
	.;Modify by zx 2020-06-24 Bug ZX0093
	.s TShareItemDR=$p($g(^DHCEQSRent(rowid)),"^",32)
	.i TShareItemDR'="" s TEquip=$p($g(^DHCEQSCShareItem(TShareItemDR)),"^",3)
	q:(Name'="")&&((TEquip'[Name)&&(TItem'[Name))
	i TStartDate'="" s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	s TStartTime=$p($g(^DHCEQSRent(rowid)),"^",11)
 	s TStartTime=##class(web.DHCEQCommon).TransValueToPage(TStartTime,"time")
	s TPlanEndDate=$p($g(^DHCEQSRent(rowid)),"^",12)
	i TPlanEndDate'="" s TPlanEndDate=##class(web.DHCEQCommon).TransValueToPage(TPlanEndDate,"date")
	s TPlanEndTime=$p($g(^DHCEQSRent(rowid)),"^",13)
	s TPlanEndTime=##class(web.DHCEQCommon).TransValueToPage(TPlanEndTime,"time")
	s TRentManagerDR=$p($g(^DHCEQSRent(rowid)),"^",14)
	i TRentManagerDR'="" s TRentManager=##class(web.DHCEQCommon).GetTrakNameByID("user",TRentManagerDR)
	s TLocReceiverDR=$p($g(^DHCEQSRent(rowid)),"^",15)
	i TLocReceiverDR'="" s TLocReceiver=##class(web.DHCEQCommon).GetTrakNameByID("user",TLocReceiverDR)
	s TRentStatus=$p($g(^DHCEQSRent(rowid)),"^",16)
	i TRentStatus'="" s TRentStatus=$CASE(TRentStatus,"0":"完好", "1":"有缺陷")
	s TRentStatusRemark=$p($g(^DHCEQSRent(rowid)),"^",17)
	s TReturnManagerDR=$p($g(^DHCEQSRent(rowid)),"^",21)
	i TReturnManagerDR'="" s TReturnManager=##class(web.DHCEQCommon).GetTrakNameByID("user",TReturnManagerDR)
	s TLocReturnDR=$p($g(^DHCEQSRent(rowid)),"^",22)
	i TLocReturnDR'="" s TLocReturn=##class(web.DHCEQCommon).GetTrakNameByID("user",TLocReturnDR)
	i TReturnDate'="" s TReturnDate=##class(web.DHCEQCommon).TransValueToPage(TReturnDate,"date")
	s TReturnTime=$p($g(^DHCEQSRent(rowid)),"^",24)
 	s TReturnTime=##class(web.DHCEQCommon).TransValueToPage(TReturnTime,"time")
	s TReturnStatus=$p($g(^DHCEQSRent(rowid)),"^",25)
	i TReturnStatus'="" s TReturnStatus=$CASE(TReturnStatus,"0":"完好", "1":"有缺陷", "2":"故障")
	s TReturnStatusRemark=$p($g(^DHCEQSRent(rowid)),"^",26)
	s TWorkLoad=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",30),"") //Modify by zc 2020-06-12
	s TWorkLoadUOMDR=$p($g(^DHCEQSRent(rowid)),"^",31)
	i TWorkLoadUOMDR'="" s TWorkLoadUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUOMDR)
	s TRentFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",32),"")
	s TLucreFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",33),"")
	s TLosingFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",34),"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",35),"")
	s TPlanBeginDate=$p($g(^DHCEQSRent(rowid)),"^",37)
	i TPlanBeginDate'="" s TPlanBeginDate=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginDate,"date")
	s TPlanBeginTime=$p($g(^DHCEQSRent(rowid)),"^",38)
 	s TPlanBeginTime=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginTime,"time")
	//取价格
	s TFeeInfo=##Class(web.DHCEQ.RM.BUSRent).RentFeeCount(rowid)
	s TPrice=$p(TFeeInfo,"^",3)
	s TMode=$p(TFeeInfo,"^",2)		//计价方式
	s TRequestTel=$p($g(^DHCEQSRent(rowid)),"^",47)
	//Modify by zc 2020-06-12
	i +$p($g(^DHCEQSRent(rowid)),"^",36)<2 d
	.s TWorkLoad=""
	.s TTotalFee=""
	s LastOperate=##Class(web.DHCEQApproveList).GetLastApproveListOpinion("30",rowid)
	s TApproveInfo=$p(LastOperate,"^",2)_$p(LastOperate,"^",3)
	s TApproveDate=$p(LastOperate,"^",4)
	s TWaringFlag=+##Class(web.DHCEQPrescription).GetPrescriptionInfo("30",rowid)
	//Modify by zx BUG ZX0089
	s THold2=$p($g(^DHCEQSRent(rowid)),"^",46)
	s THold4=$p($g(^DHCEQSRent(rowid)),"^",48)
	s TQuantityUom=$p(TPriceInfo,"^",8)_$p(TPriceInfo,"^",5)
	
	d OutputRowEquipRent
	quit
OutputRowEquipRent
    s Data=$lb(TRowID,TRequestNo,TRequestLoc,TRequestLocDR,TFromLocDR,TFromLoc,TRequestUser,TRequestUserDR,TRequestDate,TRequestTime,TItem,TItemDR,TModel,TModelDR,TEquip,TEquipDR,TStartDate,TStartTime,TPlanEndDate,TPlanEndTime,TRentManager,TRentManagerDR,TLocReceiver,TLocReceiverDR,TRentStatus,TRentStatusRemark,TRentOperatorDR,TRentOperateDate,TRentOperateTime,TReturnManager,TReturnManagerDR,TLocReturn,TLocReturnDR,TReturnDate,TReturnTime,TReturnStatus,TReturnStatusRemark,TReturnOperatorDR,TReturnOperateDate,TReturnOperateTime,TWorkLoad,TWorkLoadUOM,TWorkLoadUOMDR,TRentFee,TLucreFee,TLosingFee,TTotalFee,TStatus,TPlanBeginDate,TPlanBeginTime,TNo,TPrice,TMode,TQuantity,TRequestTel,TApproveInfo,TApproveDate,TWaringFlag,TLeaveFactoryNo,THold2,THold4,TQuantityUom)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEquipRent
	s (TRowID,TRequestNo,TRequestLoc,TRequestLocDR,TFromLocDR,TFromLoc,TRequestUser,TRequestUserDR,TRequestDate,TRequestTime,TItem,TItemDR,TModel,TModelDR,TEquip,TEquipDR,TStartDate,TStartTime,TPlanEndDate,TPlanEndTime,TRentManager,TRentManagerDR,TLocReceiver,TLocReceiverDR,TRentStatus,TRentStatusRemark,TRentOperatorDR,TRentOperateDate,TRentOperateTime,TReturnManager,TReturnManagerDR,TLocReturn,TLocReturnDR,TReturnDate,TReturnTime,TReturnStatus,TReturnStatusRemark,TReturnOperatorDR,TReturnOperateDate,TReturnOperateTime,TWorkLoad,TWorkLoadUOM,TWorkLoadUOMDR,TRentFee,TLucreFee,TLosingFee,TTotalFee,TStatus,TPlanBeginDate,TPlanBeginTime,TNo,TPrice,TMode,TQuantity,TRequestTel,TFileNo,LastOperate,TApproveInfo,TApproveDate,TWaringFlag,TLeaveFactoryNo,THold2,THold4,TQuantityUom,TShareItemDR)=""
	quit
}

ClassMethod GetRentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentListExecute ]
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

ClassMethod GetRentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Add By zx 2020-03-13
/// 描述:某一时间到目前的小时差
/// 入参：Date:日期 Time:时间
/// 返回：小时差值
/// w ##Class(web.DHCEQ.RM.BUSRent).GetDiffHour("2020-03-12","")
/// Modefied by zc0084 2020-10-14 修改日期参数错误
ClassMethod GetDiffHour(PreDate, PreTime, CurDate As %String = "", CurTime As %String = "")
{
	n DiffValue
	i PreDate="" q 0
	i CurDate="" s CurDate=$p($h,",",1)
	i CurTime="" s CurTime=$p($h,",",2)
	///Modefied by zc0084 2020-10-14 传入日期参数格式已转换成数值
	;s PreDate=##Class(web.DHCEQCommon).TransValueFromPage(PreDate,"date")
	i PreTime="" d
	.s PreTime=CurTime
	///Modefied by zc0084 2020-10-14 传入时间参数格式已转换成数值 begin
	;e  d
	;.s PreTime=##Class(web.DHCEQCommon).TransValueFromPage(PreTime,"date")
	///Modefied by zc0084 2020-10-14 传入时间参数格式已转换成数值 end
	s DiffDate=CurDate-PreDate
	s DiffTime=CurTime-PreTime
	s DiffValue=(DiffDate*86400)+DiffTime
	s DiffValue=$fn(DiffValue/3600,"",2)
	
	q DiffValue
}

/// 添加:zx 2020-03-16
/// 描述:检查设备是否被借出
/// 入参:EquipDR 设备id
/// 返回值:ResultStr 0,未被占用 其他,租赁单id
/// w ##Class(web.DHCEQ.RM.BUSRent).CheckEquipRentStatus("1")
/// ----------------------------------
ClassMethod CheckEquipRentStatus(ShareResourceDR As %String = "")
{
	new ResultStr,RentStatus,RentDR
	s ResultStr=""
	s RentStatus=$p($g(^DHCEQSShareResource(ShareResourceDR)),"^",15)
	i +RentStatus="0" q "0"
	s RentDR=""
	f  s RentDR=$o(^DHCEQSRent(0,"ShareResource",ShareResourceDR,RentDR)) q:(RentDR="")||(ResultStr'="")  d
	.q:$p($g(^DHCEQSRent(RentDR)),"^",36)="3"
	.s ResultStr=RentDR
	
	q ResultStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetRentStatistics","1312","","","3")
Query GetRentStatistics(ItemDR As %String = "", BeginDate As %String = "", EndDate As %String = "", FromLocDR As %String = "", RequestLocDR As %String = "", Status As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStatus:%String,TRequestLoc:%String,TFromLoc:%String,TRequestDate:%String,TRequestTime:%String,TItem:%String,TModel:%String,TQuantity,TEquip:%String,TNo:%String,TFileNo:%String,TStartDate:%String,TStartTime:%String,TRentStatus:%String,TRentStatusRemark:%String,TLocReturn:%String,TReturnDate:%String,TReturnTime:%String,TReturnStatus:%String,TReturnStatusRemark:%String,TWorkLoad:%String,TWorkLoadUOM:%String,TRentFee:%String,TTotalFee:%String,TEquipDR:%String,TItemDR:%String") [ SqlProc ]
{
}

ClassMethod GetRentStatisticsExecute(ByRef qHandle As %Binary, ItemDR As %String = "", BeginDate As %String = "", EndDate As %String = "", FromLocDR As %String = "", RequestLocDR As %String = "", Status As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
	n repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s Date=##class(web.DHCEQCommon).TransValueToPage($h,"date")
	i BeginDate'="" s BeginDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")
	i EndDate'="" s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	s rowid=0
	f  s rowid=$Order(^DHCEQSRent(rowid))  q:rowid=""  d
	.d BuildDataGetRentStatistics
	Quit $$$OK

BuildDataGetRentStatistics	
	d ResetVariablesGetRentStatistics
	s TRowID = rowid	//rowid
	s TStatus=$p($g(^DHCEQSRent(rowid)),"^",36)
	q:(Status'="")&&(TStatus'=Status)  
	i TStatus'="" s TStatus=$CASE(TStatus,"0":"新增", "1":"申请","2":"借出","3":"归还","4":"其他")
	s TRequestLocDR=$p($g(^DHCEQSRent(rowid)),"^",2)
	s TFromLocDR=$p($g(^DHCEQSRent(rowid)),"^",3)
	s TItemDR=$p($g(^DHCEQSRent(rowid)),"^",7)
	q:(ItemDR'="")&(TItemDR'=ItemDR)
	s TStartDate=$p($g(^DHCEQSRent(rowid)),"^",10)
	q:(BeginDate'="")&&(TStartDate<BeginDate)
	s TReturnDate=$p($g(^DHCEQSRent(rowid)),"^",23)
	q:(EndDate'="")&&(TStartDate>EndDate) 
	s TRequestNo=$p($g(^DHCEQSRent(rowid)),"^",1) 
	i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	s TRequestDate=$p($g(^DHCEQSRent(rowid)),"^",5)
	i TRequestDate'="" s TRequestDate=##class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	s TRequestTime=$p($g(^DHCEQSRent(rowid)),"^",6)
 	s TRequestTime=##class(web.DHCEQCommon).TransValueToPage(TRequestTime,"time")
	i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	s TModelDR=$p($g(^DHCEQSRent(rowid)),"^",8)
	i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	//Modefied by zc0093 2021-01-07 设备ID取值错误问题修改 begin
	;s TEquipDR=$p($g(^DHCEQSRent(rowid)),"^",9)
	s TShareResourceDR=""
	s TShareResourceDR=$p($g(^DHCEQSRent(rowid)),"^",9)
	i TShareResourceDR'="" s TEquipDR=$p($g(^DHCEQSShareResource(TShareResourceDR)),"^",3)
	//Modefied by zc0093 2021-01-07 设备ID取值错误问题修改 begin
	s TQuantity=$p($g(^DHCEQSRent(rowid)),"^",39)
	i TEquipDR'=""  d
	.s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)
	i TStartDate'="" s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	s TStartTime=$p($g(^DHCEQSRent(rowid)),"^",11)
 	s TStartTime=##class(web.DHCEQCommon).TransValueToPage(TStartTime,"time")
	s TPlanEndDate=$p($g(^DHCEQSRent(rowid)),"^",12)
	i TPlanEndDate'="" s TPlanEndDate=##class(web.DHCEQCommon).TransValueToPage(TPlanEndDate,"date")
	s TPlanEndTime=$p($g(^DHCEQSRent(rowid)),"^",13)
	s TPlanEndTime=##class(web.DHCEQCommon).TransValueToPage(TPlanEndTime,"time")
	s TRentStatus=$p($g(^DHCEQSRent(rowid)),"^",16)
	i TRentStatus'="" s TRentStatus=$CASE(TRentStatus,"0":"完好", "1":"有缺陷")
	s TRentStatusRemark=$p($g(^DHCEQSRent(rowid)),"^",17)
	s TRentOperatorDR=$p($g(^DHCEQSRent(rowid)),"^",18)
	s TRentOperateDate=$p($g(^DHCEQSRent(rowid)),"^",19)
	s TRentOperateTime=$p($g(^DHCEQSRent(rowid)),"^",20)
	s TLocReturnDR=$p($g(^DHCEQSRent(rowid)),"^",22)
	i TLocReturnDR'="" s TLocReturn=##class(web.DHCEQCommon).GetTrakNameByID("user",TLocReturnDR)
	i TReturnDate'="" s TReturnDate=##class(web.DHCEQCommon).TransValueToPage(TReturnDate,"date")
	s TReturnTime=$p($g(^DHCEQSRent(rowid)),"^",24)
 	s TReturnTime=##class(web.DHCEQCommon).TransValueToPage(TReturnTime,"time")
	s TReturnStatus=$p($g(^DHCEQSRent(rowid)),"^",25)
	i TReturnStatus'="" s TReturnStatus=$CASE(TReturnStatus,"0":"完好", "1":"有缺陷", "2":"故障")
	s TReturnStatusRemark=$p($g(^DHCEQSRent(rowid)),"^",26)
	s TReturnOperatorDR=$p($g(^DHCEQSRent(rowid)),"^",27)
	s TReturnOperateDate=$p($g(^DHCEQSRent(rowid)),"^",28)
	s TReturnOperateTime=$p($g(^DHCEQSRent(rowid)),"^",29)
	s TWorkLoad=$p($g(^DHCEQSRent(rowid)),"^",30)
	s TWorkLoadUOMDR=$p($g(^DHCEQSRent(rowid)),"^",31)
	i TWorkLoadUOMDR'="" s TWorkLoadUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUOMDR)
	s TRentFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",32),"")
	s TLucreFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",33),"")
	s TLosingFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",34),"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",35),"")
	s TPlanBeginDate=$p($g(^DHCEQSRent(rowid)),"^",37)
	i TPlanBeginDate'="" s TPlanBeginDate=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginDate,"date")
	s TPlanBeginTime=$p($g(^DHCEQSRent(rowid)),"^",38)
 	s TPlanBeginTime=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginTime,"time")
 	S TQuantity=1
	d OutputRowGetRentStatistics
	
	Quit $$$OK
OutputRowGetRentStatistics
	s Data=$lb(TRowID,TStatus,TRequestLoc,TFromLoc,TRequestDate,TRequestTime,TItem,TModel,TQuantity,TEquip,TNo,TFileNo,TStartDate,TStartTime,TRentStatus,TRentStatusRemark,TLocReturn,TReturnDate,TReturnTime,TReturnStatus,TReturnStatusRemark,TWorkLoad,TWorkLoadUOM,TRentFee,TTotalFee,TEquipDR,TItemDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRentStatistics
	s (TRowID,TStatus,TRequestLoc,TFromLoc,TRequestDate,TRequestTime,TItem,TModel,TQuantity,TEquip,TNo,TFileNo,TStartDate,TStartTime,TRentStatus,TRentStatusRemark,TLocReturn,TReturnDate,TReturnTime,TReturnStatus,TReturnStatusRemark,TWorkLoad,TWorkLoadUOM,TRentFee,TTotalFee,TEquipDR,TItemDR)=""
	quit
}

ClassMethod GetRentStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentStatisticsExecute ]
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

ClassMethod GetRentStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetShareResourceRQ","电","","","","")
/// Modefied by zc0095 2021-1-19 添加入参ShareItemCatDR
Query GetShareResourceRQ(Desc As %String = "", StoreLocDR As %String = "", ItemDR As %String = "", ModelDR As %String = "", ShareItemCatDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquipName:%String,TEquipNo:%String,TItemDR:%String,TItem:%String,TModelDR:%String,TModel:%String,LeaveFactoryNo:%String,TQuantity:%String,TRentStatus:%String,TWashFlag:%String,TInspectFlag:%String,TErrorFlag:%String") [ SqlProc ]
{
}

ClassMethod GetShareResourceRQExecute(ByRef qHandle As %Binary, Desc As %String = "", StoreLocDR As %String = "", ItemDR As %String = "", ModelDR As %String = "", ShareItemCatDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TErrorFlag=0
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	s rowid=0
	f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	.d ResetVariablesShareResourceRQ
	.s TRentStatus=$p($g(^DHCEQSShareResource(rowid)),"^",15)    //'="0" //过滤租赁中设备    0,1,2 在库,租赁中,预约租赁
	.s TWashFlag=$p($g(^DHCEQSShareResource(rowid)),"^",16)      //'="Y" //过滤未消毒清洗设备
	.;s TInspectFlag=$p($g(^DHCEQSShareResource(rowid)),"^",17)   //'="Y" //检查标志
	.s TEquipStatus=$p($g(^DHCEQSShareResource(rowid)),"^",18)   //'="0" //设备状态
	.s TErrorFlag=0
	.i (TWashFlag'="Y")||(TEquipStatus=1) s TErrorFlag=1   //未消毒和故障设备为异常状态设备
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",18)="2"  //过滤报废设备
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",19)'="Y" //过滤未上架设备
	.s TRowID = rowid
	.s TEquipDR=$p($g(^DHCEQSShareResource(rowid)),"^",3)
	.i TEquipDR'="" d
	..s TItemDR=$p($g(^DHCEQEquip(TEquipDR)),"^",7)
	..s TItem= ##Class(web.DHCEQCommon).GetTrakNameByID("masteritem", TItemDR)
	..s TCode=$p($g(^DHCEQEquip(TEquipDR)),"^",6)
	.s TEquipName=$p($g(^DHCEQSShareResource(rowid)),"^",10)
	.q:(Desc'="")&&($ZCONVERT(TEquipName,"U")'[Desc)  /// Modefied by zc0095 2021-1-19 添加设备名称检索
	.q:(StoreLocDR'="")&&($p($g(^DHCEQSShareResource(rowid)),"^",7)'=StoreLocDR)  /// Modefied by zc0095 2021-1-19 添加科室检索
	.s TEquipNo=$p($g(^DHCEQSShareResource(rowid)),"^",11)
	.s TModelDR=$p($g(^DHCEQSShareResource(rowid)),"^",12)
	.q:(ModelDR'="")&&(TModelDR'=ModelDR)   /// Modefied by zc0095 2021-1-19 添加规格型号检索
	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model", TModelDR)
	./// Modefied by zc0095 2021-1-19 begin 
	.s TPutOnSetDR=$p($g(^DHCEQSShareResource(rowid)),"^",1)
	.i TPutOnSetDR'="" s TShareItemDR=$p($g(^DHCEQSPutOnSet(TPutOnSetDR)),"^",22)
	.i TShareItemDR'="" s TShareItemCatDR=$p($g(^DHCEQSCShareItem(TShareItemDR)),"^",4)
	.q:(ShareItemCatDR'="")&&(TShareItemCatDR'=ShareItemCatDR)
	./// Modefied by zc0095 2021-1-19 end 
	.s TQuantity=##Class(web.DHCEQCommon).FormatNumber(1,"",0)
	.s LeaveFactoryNo=$p($g(^DHCEQSShareResource(rowid)),"^",13)
	.d OutputRowShareResourceRQ
	Quit $$$OK
OutputRowShareResourceRQ
	s Data=$lb(TRowID,TEquipDR,TEquipName,TEquipNo,TItemDR,TItem,TModelDR,TModel,LeaveFactoryNo,TQuantity,TRentStatus,TWashFlag,TInspectFlag,TErrorFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesShareResourceRQ
	s (TRowID,TEquipDR,TCode,TEquipName,TEquipNo,TItemDR,TItem,TModelDR,TModel,LeaveFactoryNo,TQuantity,TRentStatus,TWashFlag,TInspectFlag,TErrorFlag,TPutOnSetDR,TShareItemDR,TShareItemCatDR)=""   	/// Modefied by zc0095 2021-1-19 初始化TPutOnSetDR,TShareItemDR,TShareItemCatDR
	quit
}

ClassMethod GetShareResourceRQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShareResourceRQExecute ]
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

ClassMethod GetShareResourceRQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShareResourceRQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      ZX
/// CreatDate：    2020-04-24
/// Description:   获取机型
/// Input：        Desc,机型描述 ShareItemDR:资源项目ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetModelByShareItem","","8")
Query GetModelByShareItem(Desc As %String = "", ShareItemDR As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetModelByShareItemExecute(ByRef qHandle As %Binary, Desc As %String = "", ShareItemDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s rowid=0
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	i ShareItemDR="" q $$$OK

	s ShareItemListDR=0
	f  s ShareItemListDR=$o(^DHCEQSCShareItemList(0,"ShareItem",ShareItemDR,ShareItemListDR)) q:ShareItemListDR=""  d
	.q:$p($g(^DHCEQSCShareItemList(ShareItemListDR)),"^",5)="Y"
	.d ResetVariablesModelByShareItem
	.s TRowID=$p($g(^DHCEQSCShareItemList(ShareItemListDR)),"^",4)
	.q:TRowID=""
	.s TName=##Class(web.DHCEQCommon).GetTrakNameByID("model", TRowID)
	.q:(Desc'="")&&(TName'[Desc)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCModel",TRowID)),"^",2)
	.d OutputRowModelByShareItem
	
	Quit $$$OK
OutputRowModelByShareItem
	s Data=$lb(TName,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesModelByShareItem
	s (TName,TRowID,TCode)=""
	quit
}

ClassMethod GetModelByShareItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModelByShareItemExecute ]
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

ClassMethod GetModelByShareItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModelByShareItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      ZX
/// CreatDate：    2020-04-24
/// Description:   获取可租借科室
/// Input：        Desc,科室描述 ShareItemDR:资源项目ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetLocByShareItem","","")
Query GetLocByShareItem(Desc As %String = "", ShareItemDR As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetLocByShareItemExecute(ByRef qHandle As %Binary, Desc As %String = "", ShareItemDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s rowid=0
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	
	s SRLocDR=0
	f  s SRLocDR=$o(^DHCEQSShareResource(0,"Loc",SRLocDR)) q:SRLocDR=""  d
	.s Flag=0
	.s SRRowID=0
	.f  s SRRowID=$o(^DHCEQSShareResource(0,"Loc",SRLocDR,SRRowID)) q:(SRRowID="")||(Flag=1)  d
	..s SRPutOnSetDR=$p($g(^DHCEQSShareResource(SRRowID)),"^",1)
	..q:SRPutOnSetDR=""
	..q:(ShareItemDR'="")&&(ShareItemDR'=$p($g(^DHCEQSPutOnSet(SRPutOnSetDR)),"^",22))
	..q:+$p($g(^DHCEQSShareResource(SRRowID)),"^",15)'="0" //过滤租赁中设备
	..q:$p($g(^DHCEQSShareResource(SRRowID)),"^",16)'="Y" //过滤不完好设备
	..q:$p($g(^DHCEQSShareResource(SRRowID)),"^",18)'="0" //过滤未消毒清洗设备
	..q:$p($g(^DHCEQSShareResource(SRRowID)),"^",19)'="Y" //过滤未上架设备
	..s OuterType=$p($g(^DHCEQSShareResource(SRRowID)),"^",9)
	..s HospitalDR=$p($g(^DHCEQSShareResource(SRRowID)),"^",6)
	..q:(OuterType="0")&&(HospitalDR'=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(SRLocDR)) //院内共享
	..s Flag=1
	.q:Flag=0
	.d ResetVariablesLocByShareItem
	.s TRowID=SRLocDR
	.//Modify by zc 2020-06-12
	.s TCode=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode", SRLocDR)
	.s TName=##Class(web.DHCEQCommon).GetTrakNameByID("dept", SRLocDR)
	.q:(Desc'="")&&(TName'[Desc)&&(##class(web.DHCEQCHanZiEncoding).GetEncoding(TName,4,"","U")'[Desc)
	.d OutputRowLocByShareItem
	Quit $$$OK
OutputRowLocByShareItem
	s Data=$lb(TName,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesLocByShareItem
	s (TName,TRowID,TCode)=""
	quit
}

ClassMethod GetLocByShareItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocByShareItemExecute ]
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

ClassMethod GetLocByShareItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocByShareItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by csj 2020-04-22
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetRentHistory","13")
Query GetRentHistory(ShareRSDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStatus:%String,TRequestLoc:%String,TFromLoc:%String,TRequestDate:%String,TRequestTime:%String,TItem:%String,TModel:%String,TQuantity,TEquip:%String,TNo:%String,TFileNo:%String,TStartDate:%String,TStartTime:%String,TRentStatus:%String,TRentStatusRemark:%String,TLocReturn:%String,TReturnDate:%String,TReturnTime:%String,TReturnStatus:%String,TReturnStatusRemark:%String,TWorkLoad:%String,TWorkLoadUOM:%String,TRentFee:%String,TTotalFee:%String,TEquipDR:%String,TItemDR:%String,TRequestNo") [ SqlProc ]
{
}

ClassMethod GetRentHistoryExecute(ByRef qHandle As %Binary, ShareRSDR As %String = "") As %Status
{
	n repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s rowid=0
	f  s rowid=$Order(^DHCEQSRent(rowid))  q:rowid=""  d
	.d BuildDataGetRentHistory
	Quit $$$OK

BuildDataGetRentHistory	
	d ResetVariablesGetRentHistory
	s TRowID = rowid	//rowid
	s TShareRSDR=$p($g(^DHCEQSRent(rowid)),"^",9)
	q:(ShareRSDR'="")&&(ShareRSDR'=TShareRSDR)  
	s TStatus=$p($g(^DHCEQSRent(rowid)),"^",36)
	q:TStatus'=3
	i TStatus'="" s TStatus=$CASE(TStatus,"0":"新增", "1":"申请","2":"借出","3":"归还","4":"其他")
	s TRequestLocDR=$p($g(^DHCEQSRent(rowid)),"^",2)
	s TFromLocDR=$p($g(^DHCEQSRent(rowid)),"^",3)
	s TItemDR=$p($g(^DHCEQSRent(rowid)),"^",7)
	s TStartDate=$p($g(^DHCEQSRent(rowid)),"^",10)
	s TReturnDate=$p($g(^DHCEQSRent(rowid)),"^",23)
	s TRequestNo=$p($g(^DHCEQSRent(rowid)),"^",1) 
	i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	s TRequestDate=$p($g(^DHCEQSRent(rowid)),"^",5)
	i TRequestDate'="" s TRequestDate=##class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	s TRequestTime=$p($g(^DHCEQSRent(rowid)),"^",6)
 	s TRequestTime=##class(web.DHCEQCommon).TransValueToPage(TRequestTime,"time")
	i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	s TModelDR=$p($g(^DHCEQSRent(rowid)),"^",8)
	i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	i TShareRSDR'="" s TEquipDR=$p($g(^DHCEQSShareResource(TShareRSDR)),"^",3)
	s TQuantity=$p($g(^DHCEQSRent(rowid)),"^",39)
	i TEquipDR'=""  d
	.s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)
	i TStartDate'="" s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	s TStartTime=$p($g(^DHCEQSRent(rowid)),"^",11)
 	s TStartTime=##class(web.DHCEQCommon).TransValueToPage(TStartTime,"time")
	s TPlanEndDate=$p($g(^DHCEQSRent(rowid)),"^",12)
	i TPlanEndDate'="" s TPlanEndDate=##class(web.DHCEQCommon).TransValueToPage(TPlanEndDate,"date")
	s TPlanEndTime=$p($g(^DHCEQSRent(rowid)),"^",13)
	s TPlanEndTime=##class(web.DHCEQCommon).TransValueToPage(TPlanEndTime,"time")
	s TRentStatus=$p($g(^DHCEQSRent(rowid)),"^",16)
	i TRentStatus'="" s TRentStatus=$CASE(TRentStatus,"0":"完好", "1":"有缺陷")
	s TRentStatusRemark=$p($g(^DHCEQSRent(rowid)),"^",17)
	s TRentOperatorDR=$p($g(^DHCEQSRent(rowid)),"^",18)
	s TRentOperateDate=$p($g(^DHCEQSRent(rowid)),"^",19)
	s TRentOperateTime=$p($g(^DHCEQSRent(rowid)),"^",20)
	s TLocReturnDR=$p($g(^DHCEQSRent(rowid)),"^",22)
	i TLocReturnDR'="" s TLocReturn=##class(web.DHCEQCommon).GetTrakNameByID("user",TLocReturnDR)
	i TReturnDate'="" s TReturnDate=##class(web.DHCEQCommon).TransValueToPage(TReturnDate,"date")
	s TReturnTime=$p($g(^DHCEQSRent(rowid)),"^",24)
 	s TReturnTime=##class(web.DHCEQCommon).TransValueToPage(TReturnTime,"time")
	s TReturnStatus=$p($g(^DHCEQSRent(rowid)),"^",25)
	i TReturnStatus'="" s TReturnStatus=$CASE(TReturnStatus,"0":"完好", "1":"有缺陷", "2":"故障")
	s TReturnStatusRemark=$p($g(^DHCEQSRent(rowid)),"^",26)
	s TReturnOperatorDR=$p($g(^DHCEQSRent(rowid)),"^",27)
	s TReturnOperateDate=$p($g(^DHCEQSRent(rowid)),"^",28)
	s TReturnOperateTime=$p($g(^DHCEQSRent(rowid)),"^",29)
	s TWorkLoad=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",30),"")   //Modefied by zc0098 2021-1-28 显示问题修改
	//Modify by zx 2020-05-18 BUG ZX0088
	s TPriceInfo=##Class(web.DHCEQ.RM.BUSRent).RentFeeCount(rowid)
	s TWorkLoadUOM=$p(TPriceInfo,"^",5)
	s TRentFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",32),"")
	s TLucreFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",33),"")
	s TLosingFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",34),"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",35),"")
	s TPlanBeginDate=$p($g(^DHCEQSRent(rowid)),"^",37)
	i TPlanBeginDate'="" s TPlanBeginDate=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginDate,"date")
	s TPlanBeginTime=$p($g(^DHCEQSRent(rowid)),"^",38)
 	s TPlanBeginTime=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginTime,"time")
 	S TQuantity=1
 	//Modify by zx BUG ZX0089
	s THold2=$p($g(^DHCEQSRent(rowid)),"^",46)
	s THold4=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",48),"")
	d OutputRowGetRentHistory
	
	Quit $$$OK
OutputRowGetRentHistory
	s Data=$lb(TRowID,TStatus,TRequestLoc,TFromLoc,TRequestDate,TRequestTime,TItem,TModel,TQuantity,TEquip,TNo,TFileNo,TStartDate,TStartTime,TRentStatus,TRentStatusRemark,TLocReturn,TReturnDate,TReturnTime,TReturnStatus,TReturnStatusRemark,TWorkLoad,TWorkLoadUOM,TRentFee,TTotalFee,TEquipDR,TItemDR,TRequestNo,THold2,THold4)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRentHistory
	s (TRowID,TStatus,TRequestLoc,TFromLoc,TRequestDate,TRequestTime,TItem,TModel,TQuantity,TEquip,TNo,TFileNo,TStartDate,TStartTime,TRentStatus,TRentStatusRemark,TLocReturn,TReturnDate,TReturnTime,TReturnStatus,TReturnStatusRemark,TWorkLoad,TWorkLoadUOM,TRentFee,TTotalFee,TEquipDR,TItemDR,TRequestNo,TPriceInfo,THold2,THold4)=""
	quit
}

ClassMethod GetRentHistoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentHistoryExecute ]
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

ClassMethod GetRentHistoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentHistoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By zx 2020-05-09
/// 描述:取租赁设备定价信息
/// 入参：ShareResourceDR 资源ID
/// 返回：未找到对应的租赁价格定义,则返回""
/// 	  否则返回相应信息串
/// w ##Class(web.DHCEQ.RM.BUSRent).RentPriceInfo("1")
ClassMethod RentPriceInfo(SRDR)
{
	s Result=""
	i SRDR="" q ""
	s SPRowID=##Class(web.DHCEQ.RM.CTResourcePrice).GetResourcePriceInfo(SRDR)
	i SPRowID="" q ""
	s SHPRowID=0
	f  s SHPRowID=$o(^DHCEQSResourceHistoryPrice(0,"ResourcePrice",SPRowID,SHPRowID)) q:(SHPRowID="")||(Result'="")  d
	.q:$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",9)="N"
	.s TMode=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",3)
	.s TMode =$CASE(TMode,"1":"租赁时长", "2":"工作量","":"")
	.s TUomQuantity=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",4)
	.s TUOMDR=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",5)
	.s TUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUOMDR)
	.s TPrice=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",6)
	.s Result="当前资源按"_TMode_"，价格为"_TPrice_"元/"_TUomQuantity_TUOM_"^"_SHPRowID  //Modefied by zc0084 2020-10-14 添加SHPRowID
	
	q Result
}

/// Add By zx 2020-05-09
/// 描述:取租赁设备定价信息
/// 入参：CurRentDR 租赁单ID
/// 返回：未找到对应的租赁价格定义,则返回""
/// 	  否则返回相应费用信息 计价方式ID^计价方式^价格^单位ID^单位^工作量^总金额
/// w ##Class(web.DHCEQ.RM.BUSRent).RentFeeCount("1")
ClassMethod RentFeeCount(CurRentDR)
{
	//Modify by zc 2020-06-12
	s (vWorkHours,vUomQuantity,vPrice,vTotalFee,vWorkLoad)=0
	s Result="^^^^^^^"
	i CurRentDR="" q Result
	s SRDR=$p($g(^DHCEQSRent(CurRentDR)),"^",9)
	i SRDR="" q Result
	s SPRowID=##Class(web.DHCEQ.RM.CTResourcePrice).GetResourcePriceInfo(SRDR)
	i SPRowID="" q Result
	s SStartDate=$p($g(^DHCEQSRent(CurRentDR)),"^",10)
	s SStartTime=$p($g(^DHCEQSRent(CurRentDR)),"^",11)
	//Modefied by zc0084 2020-10-14 归还日期取值问题 begin
	s SEndDate=$p($g(^DHCEQSRent(CurRentDR)),"^",23)
	s SEndTime=$p($g(^DHCEQSRent(CurRentDR)),"^",24)
	s vWorkHours=##Class(web.DHCEQ.RM.BUSRent).GetDiffHour(SStartDate,SStartTime,SEndDate,SEndTime)
	//Modefied by zc0084 2020-10-14 归还日期取值问题 end
	s CurFlag=0
	s SHPRowID=0
	f  s SHPRowID=$o(^DHCEQSResourceHistoryPrice(0,"ResourcePrice",SPRowID,SHPRowID)) q:(SHPRowID="")||(CurFlag'=0)  d
	.q:$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",9)="N"
	.s CurFlag=1
	.s vModeDR=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",3)
	.s vMode =$CASE(vModeDR,"1":"租赁时长", "2":"工作量","":"")
	.s vUomQuantity=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",4)
	.s vUOMDR=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",5)
	.s vUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",vUOMDR)
	.s vPrice=+$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",6)  //Modify by zc 2020-06-24 ZC0077 将字符串转换成数字
	.i vModeDR="1" d
	..i vUOM="小时" d
	...s vWorkLoad=vWorkHours
	...s vTotalFee=##Class(web.DHCEQCommon).FormatNumber((vPrice*vWorkHours)/vUomQuantity,2)
	..i vUOM="天" d
	...s vWorkLoad=##Class(web.DHCEQCommon).FormatNumber(vWorkHours/24,2)   //Modefied by zc0084 2020-10-14 一天24小时不是60小时
	...s vTotalFee=##Class(web.DHCEQCommon).FormatNumber((vPrice*vWorkLoad)/vUomQuantity,2)
	.s Result=vModeDR_"^"_vMode_"^"_vPrice_"^"_vUOMDR_"^"_vUOM_"^"_vWorkLoad_"^"_vTotalFee_"^"_vUomQuantity
	
	q Result
}

/// 入参:Eventype 0,提交 1,借出 2,归还
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetMoveAffix","40","0")
Query GetMoveAffix(RentID, EventType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TMoveDR:%String,TAffixDR:%String,TAffix:%String,TModel:%String,TQuantity:%String,TStatusDR:%String,TStatus:%String,TLeaveFactoryNo:%String,TRemark:%String,TBackRowID:%String,TBackMoveDR:%String,TBackQuantity:%String,TBackStatusDR:%String,TBackStatus:%String,TBackRemark:%String,TCanUseNum:%String")
{
}

ClassMethod GetMoveAffixExecute(ByRef qHandle As %Binary, RentID, EventType As %String = "") As %Status
{
    new repid, index
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set index=1
    i RentID="" Quit $$$OK
    
    //无配送信息,取资源项目附件
    i (EventType=1)||(EventType="")
    {
    	s ShareItemDR=$p($g(^DHCEQSRent(RentID)),"^",32)
    	i ShareItemDR="" Quit $$$OK //QW20200628 begin
    	s ItemAffixDR=0
    	f  s ItemAffixDR=$o(^DHCEQSCItemAffix(0,"IAShareItemDR",ShareItemDR,ItemAffixDR)) q:ItemAffixDR=""  d
    	.d ResetVariablesGetMoveAffix
    	.q:$p($g(^DHCEQSCItemAffix(ItemAffixDR)),"^",7)="Y"
    	.s TAffixDR=$p($g(^DHCEQSCItemAffix(ItemAffixDR)),"^",2)
	    .s TAffix=$p($g(^DHCEQCCode("DHCEQCAffix",TAffixDR)),"^",2)
		.s TModel=$p($g(^DHCEQSCItemAffix(ItemAffixDR)),"^",3)
		.s TQuantity=$p($g(^DHCEQSCItemAffix(ItemAffixDR)),"^",4)
		.s TPrice=$p($g(^DHCEQSCItemAffix(ItemAffixDR)),"^",6)
		.s TStatusDR="0"
		.s TStatus="完好"
		.s TCanUseNum=TQuantity
    	.d OutputRowGetMoveAffix
	}
    elseif EventType=2
    {
	    s TMoveID=0
    	f  s TMoveID=$o(^DHCEQMove(0,"Source","64",RentID,TMoveID)) q:TMoveID=""  d
    	.s TRowID=""
	    .f  s TRowID=$o(^DHCEQMoveAffix(0,"Move",TMoveID,TRowID)) q:TRowID=""  d
	    ..d ResetVariablesGetMoveAffix
	    ..q:$p($g(^DHCEQMove(TMoveID)),"^",6)'="1"
	    ..q:$p($g(^DHCEQMove(TMoveID)),"^",31)="Y"
	    ..s TMoveDR=TMoveID
	    ..s TAffixDR=$p($g(^DHCEQMoveAffix(TRowID)),"^",2)
	    ..s TModel=$p($g(^DHCEQMoveAffix(TRowID)),"^",3)
	    ..s TQuantity=$p($g(^DHCEQMoveAffix(TRowID)),"^",4)
	    ..s TRemark=$p($g(^DHCEQMoveAffix(TRowID)),"^",6)
	    ..s TStatusDR=$p($g(^DHCEQMoveAffix(TRowID)),"^",5)
	    ..s TStatus=$CASE(TStatusDR,"":"","0":"完好","1":"故障","2":"丢失","3":"其他")
	    ..s TLeaveFactoryNo=$p($g(^DHCEQMoveAffix(TRowID)),"^",7)
	    ..s TAffix=$p($g(^DHCEQCCode("DHCEQCAffix",TAffixDR)),"^",2)
	    ..s TBackQuantity=TQuantity
	    ..s TBackStatusDR=TStatusDR
	    ..s TBackStatus=TStatus
	    ..s TCanUseNum=TQuantity
	    ..d OutputRowGetMoveAffix
	}
	elseif EventType=3
    {
	    s TMoveID=0
    	f  s TMoveID=$o(^DHCEQMove(0,"Source","64",RentID,TMoveID)) q:TMoveID=""  d
    	.s TRowID=""
	    .f  s TRowID=$o(^DHCEQMoveAffix(0,"Move",TMoveID,TRowID)) q:TRowID=""  d
	    ..d ResetVariablesGetMoveAffix
	    ..q:$p($g(^DHCEQMove(TMoveID)),"^",6)'="1"
	    ..q:$p($g(^DHCEQMove(TMoveID)),"^",31)="Y"
	    ..s TMoveDR=TMoveID
	    ..s TAffixDR=$p($g(^DHCEQMoveAffix(TRowID)),"^",2)
	    ..s TModel=$p($g(^DHCEQMoveAffix(TRowID)),"^",3)
	    ..s TQuantity=$p($g(^DHCEQMoveAffix(TRowID)),"^",4)
	    ..s TRemark=$p($g(^DHCEQMoveAffix(TRowID)),"^",6)
	    ..s TStatusDR=$p($g(^DHCEQMoveAffix(TRowID)),"^",5)
	    ..s TStatus=$CASE(TStatusDR,"":"","0":"完好","1":"故障","2":"丢失","3":"其他")
	    ..s TLeaveFactoryNo=$p($g(^DHCEQMoveAffix(TRowID)),"^",7)
	    ..s TAffix=$p($g(^DHCEQCCode("DHCEQCAffix",TAffixDR)),"^",2)
	    ..s TBackRowID=0
	    ..f  s TBackRowID=$o(^DHCEQMoveAffix(0,"Affix",TAffixDR,TBackRowID)) q:TBackRowID=""  d
	    ...s TBackMoveDR=$p($g(^DHCEQMoveAffix(TBackRowID)),"^",1)
	    ...q:TBackMoveDR=""
	    ...q:$p($g(^DHCEQMove(TBackMoveDR)),"^",6)'="2"
	    ...q:$p($g(^DHCEQMove(TBackMoveDR)),"^",31)="Y"
	    ...q:($p($g(^DHCEQMove(TBackMoveDR)),"^",4)'="64")||($p($g(^DHCEQMove(TBackMoveDR)),"^",5)'=RentID)
	    ...s TBackQuantity=$p($g(^DHCEQMoveAffix(TBackRowID)),"^",4)
	    ...s TBackStatusDR=$p($g(^DHCEQMoveAffix(TBackRowID)),"^",5)
	    ...s TBackStatus=$CASE(TBackStatusDR,"":"","0":"完好","1":"故障","2":"丢失","3":"其他")
	    ...s TBackRemark=$p($g(^DHCEQMoveAffix(TBackRowID)),"^",6)
	    ...s TCanUseNum=TQuantity
	    ...d OutputRowGetMoveAffix
	}
    Quit $$$OK

ResetVariablesGetMoveAffix
    Set (TMoveDR,TAffixDR,TAffix,TModel,TQuantity,TStatusDR,TStatus,TLeaveFactoryNo,TRemark,TBackRowID,TBackMoveDR,TBackQuantity,TBackStatusDR,TBackStatus,TBackRemark,TCanUseNum)=""
    Quit    
OutputRowGetMoveAffix
    Set Data=$lb(TRowID,TMoveDR,TAffixDR,TAffix,TModel,TQuantity,TStatusDR,TStatus,TLeaveFactoryNo,TRemark,TBackRowID,TBackMoveDR,TBackQuantity,TBackStatusDR,TBackStatus,TBackRemark,TCanUseNum)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetMoveAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoveAffixExecute ]
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

ClassMethod GetMoveAffixClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoveAffixExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 转移类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetAffixStatus","")
Query GetAffixStatus(Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetAffixStatusExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Length=3
	f ID=0:1:Length d
	.S TDesc=$CASE(ID,"0":"完好","1":"故障","2":"丢失","3":"其他")
	.q:(Desc'="")&&(TDesc'[Desc)
	.d OutputRowGetAffixStatus
	
	Quit $$$OK
OutputRowGetAffixStatus
	Set Data=$lb(ID,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetAffixStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAffixStatusExecute ]
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

ClassMethod GetAffixStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAffixStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 调配费用统计
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetRentFeeStat","","","","","71")
/// Modefied by zc0094 2021-01-13 修正入参错误，将StarDate改成StartDate
Query GetRentFeeStat(LocDR As %String = "", StartDate As %String = "", EndDate As %String = "", Job As %String = "", CurUser As %String = "") As %Query(ROWSPEC = "TLoc:%String,TAllPay:%String,TAllCut:%String,TAllCost:%String,TAllProfit:%String,TAllHosProfit:%String,TAllShProfit:%String,TAllNum:%String,TAllLocProfit:%String")
{
}

ClassMethod GetRentFeeStatExecute(ByRef qHandle As %Binary, LocDR As %String = "", StartDate As %String = "", EndDate As %String = "", Job As %String = "", CurUser As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s nodestr="web.DHCEQ.RM.BUSRent_GetRentFeeStat"
	s Date=+$H
	i CurUser=""  s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))  //%session.Get("LOGON.USERID")
	i Job=""      s Job=$J
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")   /// Modefied by zc0094 2021-01-13 修正入参错误，将StarDate改成StartDate
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date") 
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr,Job) //modified by csj 2020-06-28 需求号：1387689
	s RShareResourceDR=0
	f  s RShareResourceDR=$o(^DHCEQSRent(0,"ShareResource",RShareResourceDR)) q:RShareResourceDR=""  d
	.s REPutOnSetDR=$p($g(^DHCEQSShareResource(RShareResourceDR)),"^",3)
	.s TRentDR=0
	.f  s TRentDR=$o(^DHCEQSRent(0,"ShareResource",RShareResourceDR,TRentDR)) q:TRentDR=""  d
	..s TRequestLocDR=$p($g(^DHCEQSRent(TRentDR)),"^",2)
	..q:(StartDate'="")&&(StartDate>$p($g(^DHCEQSRent(TRentDR)),"^",23))  /// Modefied by zc0094 2021-01-13 修正入参错误，将StarDate改成StartDate
	..q:(EndDate'="")&&(EndDate<$p($g(^DHCEQSRent(TRentDR)),"^",10))
	..s TFromLocDR=$p($g(^DHCEQSRent(TRentDR)),"^",3)
	..q:(LocDR'="")&&((TRequestLocDR'=LocDR)&&(TFromLocDR'=LocDR))
	..s TPayFee=$p($g(^DHCEQSRent(TRentDR)),"^",35)  ;TRequestLocDR支出 
	..s TCutFee=$p($g(^DHCEQSRent(TRentDR)),"^",48)  ;TFromLocDR 减免  //Modefied by zc0096 2021-1-21 修正减免费用从申请科室来统计
	..s TCost=TPayFee-TCutFee
	..i $Data(^DHCEQTemp(nodestr,Date,Job,CurUser,TRequestLocDR)) d
	...s ReqValueStr=$g(^DHCEQTemp(nodestr,Date,Job,CurUser,TRequestLocDR))
	...s PayFee=$p(ReqValueStr,"^",1)+TPayFee
	...s CutFee=$p(ReqValueStr,"^",2)+TCutFee  //Modefied by zc0096 2021-1-21 修正减免费用从申请科室来统计
	...s Cost=$p(ReqValueStr,"^",3)+TCost  ;总成本
	...s HosProfitFee=$p(ReqValueStr,"^",5)+##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(REPutOnSetDR,"0","",TCost) ;医院利润
	...s ShProfitFee=$p(ReqValueStr,"^",6)+##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(REPutOnSetDR,"1","",TCost)  ;调配中心利润
	...s Num=$p(ReqValueStr,"^",7)+1                 ;统计调配单数
	...Set $Piece(ReqValueStr,"^",1)=PayFee
	...Set $Piece(ReqValueStr,"^",2)=CutFee   //Modefied by zc0096 2021-1-21 修正减免费用从申请科室来统计
	...Set $Piece(ReqValueStr,"^",3)=Cost
	...Set $Piece(ReqValueStr,"^",5)=HosProfitFee
	...Set $Piece(ReqValueStr,"^",6)=ShProfitFee
	...Set $Piece(ReqValueStr,"^",7)=Num
	...s ^DHCEQTemp(nodestr,Date,Job,CurUser,TRequestLocDR)=ReqValueStr
	..e  d
	...s PayFee=TPayFee
	...s CutFee=+TCutFee  //Modefied by zc0097 2021-1-26 错误修正
	...s Cost=TCost  ;总成本
	...s HosProfitFee=##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(REPutOnSetDR,"0","",TCost) ;医院利润
	...s ShProfitFee=##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(REPutOnSetDR,"1","",TCost)  ;调配中心利润
	...s Num=1                 ;统计调配单数
	...s ^DHCEQTemp(nodestr,Date,Job,CurUser,TRequestLocDR)=PayFee_"^"_CutFee_"^"_Cost_"^"_"0"_"^"_HosProfitFee_"^"_ShProfitFee_"^"_Num    //Modefied by zc0096 2021-1-21 修正减免费用从申请科室来统计
	..i $Data(^DHCEQTemp(nodestr,Date,Job,CurUser,TFromLocDR)) d
	...s FroValueStr=$g(^DHCEQTemp(nodestr,Date,Job,CurUser,TFromLocDR))
	...;s CutFee=$p(FroValueStr,"^",2)+TCutFee    //Modefied by zc0096 2021-1-21 修正减免费用从申请科室来统计
	...s ProfitFee=$p(FroValueStr,"^",4)+##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(REPutOnSetDR,"2",TFromLocDR,TCost) ;总利润=总成本*分摊比例
	...;Set $Piece(FroValueStr,"^",2)=CutFee  //Modefied by zc0096 2021-1-21 修正减免费用从申请科室来统计
	...Set $Piece(FroValueStr,"^",4)=ProfitFee
	...s ^DHCEQTemp(nodestr,Date,Job,CurUser,TFromLocDR)=FroValueStr
	..e  d
	...;s CutFee=+TCutFee  //Modefied by zc0097 2021-1-26 错误修正
	...s ProfitFee=##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(REPutOnSetDR,"2",TFromLocDR,TCost) ;总利润=总成本*分摊比例
	...s ^DHCEQTemp(nodestr,Date,Job,CurUser,TFromLocDR)="0"_"^"_"0"_"^"_"0"_"^"_ProfitFee_"^"_"0"_"^"_"0"_"^"_"0"   //Modefied by zc0096 2021-1-21 修正减免费用从申请科室来统计

	s LocID=0
	f  s LocID=$o(^DHCEQTemp(nodestr,Date,Job,CurUser,LocID)) q:LocID=""  d
	.s resultinfo=$g(^DHCEQTemp(nodestr,Date,Job,CurUser,LocID))
	.q:(LocDR'="")&&(LocID'=LocDR)
	.d ResetVariablesGetRentFeeStat
	.s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)
	.s TAllPay=+$p(resultinfo,"^",1)    	//Modefied by zc017 20211115 将字符串转换成数字 begin
	.s TAllCut=+$p(resultinfo,"^",2)
	.s TAllCost=+$p(resultinfo,"^",3)
	.s TAllProfit=+$p(resultinfo,"^",4)
	.s TAllHosProfit=+$p(resultinfo,"^",5)
	.s TAllShProfit=+$p(resultinfo,"^",6)
	.s TAllNum=+$Piece(resultinfo,"^",7)	//Modefied by zc017 20211115 将字符串转换成数字 end
	.s TAllLocProfit=TAllProfit-TAllCost
	.d OutputRowGetRentFeeStat

	
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr,Job)	//modified by csj 2020-06-28 需求号：1387689
	Quit $$$OK
	
OutputRowGetRentFeeStat
	Set Data=$lb(TLoc,TAllPay,TAllCut,TAllCost,TAllProfit,TAllHosProfit,TAllShProfit,TAllNum,TAllLocProfit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRentFeeStat
    Set (TLoc,TAllPay,TAllCut,TAllCost,TAllProfit,TAllHosProfit,TAllShProfit,TAllNum,TAllLocProfit)=""
    Quit
}

ClassMethod GetRentFeeStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentFeeStatExecute ]
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

ClassMethod GetRentFeeStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentFeeStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCostAllotFee(SetDR, AllotType, AllotSourceDR, Fee)
{
	if (SetDR="" || AllotType="") q 0
	s find=0
	s CostAllotFee=0
	s CARowID=0
	f  s CARowID=$o(^DHCEQSRentCostAllot(0,"PutOnSet",SetDR,CARowID)) q:CARowID=""
	.s TAllotType = $p($g(^DHCEQSRentCostAllot(CARowID)),"^",2)
	.s TAllotSourceDR=$p($g(^DHCEQSRentCostAllot(CARowID)),"^",3)
	.q:TAllotType'=AllotType
	.q:(AllotSourceDR'="")&&(AllotSourceDR'=TAllotSourceDR)
	.s TAllotPercentNum = $p($g(^DHCEQSRentCostAllot(CARowID)),"^",4)
	.s CostAllotFee=CostAllotFee+(Fee*TAllotPercentNum/100)
	.s find=find+1
	i (AllotType="2"&&find=0) q Fee
	q CostAllotFee
}

/// / 设备状态
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetEquipStatus","")
Query GetEquipStatus() As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetEquipStatusExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Length=1
	f ID=0:1:Length d
	.;"0":"完好","1":"有缺陷"
	.S TDesc=$CASE(ID,"0":"完好","1":"有缺陷")
	.d OutputRowGetEquipStatus
	
	Quit $$$OK
OutputRowGetEquipStatus
	Set Data=$lb(ID,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetEquipStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipStatusExecute ]
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

ClassMethod GetEquipStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by czf 2020-06-11
/// 租赁收入成本时长统计图表
/// w ##Class(web.DHCEQ.RM.BUSRent).GetShareResourceFeeSummary()
ClassMethod GetShareResourceFeeSummary(CurUserID As %String = "", CurLocID As %String = "")
{
	s RentShareInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s nodestr="web.DHCEQ.RM.BUSRent_GetShareResourceFeeSummary"
	s Date=+$H
	s Job=$J
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
	
	i CurUserID="" s CurUserID=%session.Get("LOGON.USERID")
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
	
	i CurLocID="" s CurLocID=%session.Get("LOGON.CTLOCID")
	s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",CurLocID)
	
	s (PayFee,Cost,HosProfitFee,ShProfitFee,Num)=0
	s rowid=0
	f  s rowid=$Order(^DHCEQSRent(rowid))  q:rowid=""  d
	.s TRowID = rowid	//rowid
	.s TStatus=$p($g(^DHCEQSRent(rowid)),"^",36)
	.q:+TStatus<2
	.i TStatus'="" s TStatus=$CASE(TStatus,"0":"新增", "1":"申请","2":"借出","3":"归还","4":"其他")
	.s TPutOnSetDR=""
	.s TShareResourceDR=$p($g(^DHCEQSShareResource(rowid)),"^",9)
	.i TShareResourceDR'="" s TPutOnSetDR=$p($g(^DHCEQSShareResource(TShareResourceDR)),"^",1)
	.q:TPutOnSetDR=""
	.s TRequestLocDR=$p($g(^DHCEQSRent(rowid)),"^",2)
	.s TFromLocDR=$p($g(^DHCEQSRent(rowid)),"^",3)
	.q:(CurLocDR'="")&&((TRequestLocDR'=CurLocDR)&&(TFromLocDR'=CurLocDR))
	.s TItemDR=$p($g(^DHCEQSRent(rowid)),"^",7)
	.s TStartDate=$p($g(^DHCEQSRent(rowid)),"^",10)
	.s YearMonth=$p($zd(TStartDate,3),"-",1,2)
	.s TReturnDate=$p($g(^DHCEQSRent(rowid)),"^",23)
	.s TRequestNo=$p($g(^DHCEQSRent(rowid)),"^",1) 
	.i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	.s TRequestDate=$p($g(^DHCEQSRent(rowid)),"^",5)
	.i TRequestDate'="" s TRequestDate=##class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	.s TRequestTime=$p($g(^DHCEQSRent(rowid)),"^",6)
 	.s TRequestTime=##class(web.DHCEQCommon).TransValueToPage(TRequestTime,"time")
	.i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.s TModelDR=$p($g(^DHCEQSRent(rowid)),"^",8)
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TEquipDR=$p($g(^DHCEQSRent(rowid)),"^",9)
	.s TQuantity=$p($g(^DHCEQSRent(rowid)),"^",39)
	.i TEquipDR'=""  d
	..s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	..s TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)
	.i TStartDate'="" s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	.s TStartTime=$p($g(^DHCEQSRent(rowid)),"^",11)
 	.s TStartTime=##class(web.DHCEQCommon).TransValueToPage(TStartTime,"time")
	.s TPlanEndDate=$p($g(^DHCEQSRent(rowid)),"^",12)
	.i TPlanEndDate'="" s TPlanEndDate=##class(web.DHCEQCommon).TransValueToPage(TPlanEndDate,"date")
	.s TPlanEndTime=$p($g(^DHCEQSRent(rowid)),"^",13)
	.s TPlanEndTime=##class(web.DHCEQCommon).TransValueToPage(TPlanEndTime,"time")
	.s TLocReturnDR=$p($g(^DHCEQSRent(rowid)),"^",22)
	.i TLocReturnDR'="" s TLocReturn=##class(web.DHCEQCommon).GetTrakNameByID("user",TLocReturnDR)
	.i TReturnDate'="" s TReturnDate=##class(web.DHCEQCommon).TransValueToPage(TReturnDate,"date")
	.s TReturnTime=$p($g(^DHCEQSRent(rowid)),"^",24)
 	.s TReturnTime=##class(web.DHCEQCommon).TransValueToPage(TReturnTime,"time")
	.s TReturnStatusRemark=$p($g(^DHCEQSRent(rowid)),"^",26)
	.s TReturnOperatorDR=$p($g(^DHCEQSRent(rowid)),"^",27)
	.s TReturnOperateDate=$p($g(^DHCEQSRent(rowid)),"^",28)
	.s TReturnOperateTime=$p($g(^DHCEQSRent(rowid)),"^",29)
	.s TWorkLoad=$p($g(^DHCEQSRent(rowid)),"^",30)
	.s TWorkLoadUOMDR=$p($g(^DHCEQSRent(rowid)),"^",31)
	.i TWorkLoadUOMDR'="" s TWorkLoadUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUOMDR)
	.s TRentFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",32),"")
	.s TLucreFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",33),"")
	.s TLosingFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",34),"")
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",35),"")		//TrequestLoc支出
	.s TCutHour=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",46),"")		//TFromLoc减免时长
	.s TCutFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(rowid)),"^",47),"")		//TFromLoc减免费用
	.s TPlanBeginDate=$p($g(^DHCEQSRent(rowid)),"^",37)
	.i TPlanBeginDate'="" s TPlanBeginDate=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginDate,"date")
	.s TPlanBeginTime=$p($g(^DHCEQSRent(rowid)),"^",38)
 	.s TPlanBeginTime=##class(web.DHCEQCommon).TransValueToPage(TPlanBeginTime,"time")
 	.S TQuantity=1
	.s TCost=TTotalFee-TCutFee		//TrequestLoc总成本
	.s TWorkHour=TWorkLoad-TCutHour		//TrequestLoc 使用时长
	.//申请科室成本
	.i $Data(^DHCEQTemp(nodestr,Date,Job,CurUser,TRequestLocDR,YearMonth)) d
	..s ReqValueStr=$g(^DHCEQTemp(nodestr,Date,Job,CurUser,TRequestLocDR,YearMonth))
	..s PayFee=$p(ReqValueStr,"^",1)+TTotalFee
	..s Cost=$p(ReqValueStr,"^",3)+TCost  ;总成本
	..s HosProfitFee=$p(ReqValueStr,"^",5)+##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(TPutOnSetDR,"0","",TCost) ;医院利润
	..s ShProfitFee=$p(ReqValueStr,"^",6)+##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(TPutOnSetDR,"1","",TCost)  ;调配中心利润
	..s Num=$p(ReqValueStr,"^",7)+1                 ;统计调配单数
	..s WorkLoad=$p(ReqValueStr,"^",9)+TWorkLoad
	..s WorkHour=$p(ReqValueStr,"^",10)+TWorkHour
	..s $p(ReqValueStr,"^",1)=PayFee
	..s $p(ReqValueStr,"^",3)=Cost
	..s $p(ReqValueStr,"^",5)=HosProfitFee
	..s $p(ReqValueStr,"^",6)=ShProfitFee
	..s $p(ReqValueStr,"^",7)=Num
	..s $p(ReqValueStr,"^",9)=WorkLoad 
	..s $p(ReqValueStr,"^",10)=WorkHour
	..s ^DHCEQTemp(nodestr,Date,Job,CurUser,TRequestLocDR,YearMonth)=ReqValueStr
	.e  d
	..s PayFee=TTotalFee	;申请科室总支出
	..s Cost=TCost  ;总成本
	..s HosProfitFee=##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(TPutOnSetDR,"0","",TCost) ;医院利润
	..s ShProfitFee=##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(TPutOnSetDR,"1","",TCost)  ;调配中心利润
	..s Num=1                 ;统计调配单数
	..s WorkLoad=TWorkLoad		;申请科室工作量
	..s WorkHour=TWorkHour		;总使用时长
	..s ^DHCEQTemp(nodestr,Date,Job,CurUser,TRequestLocDR,YearMonth)=PayFee_"^0^"_Cost_"^0^"_HosProfitFee_"^"_ShProfitFee_"^"_Num_"^0^"_WorkLoad_"^"_WorkHour
	.//借出科室收益
	.i $Data(^DHCEQTemp(nodestr,Date,Job,CurUser,TFromLocDR,YearMonth)) d
	..s FroValueStr=$g(^DHCEQTemp(nodestr,Date,Job,CurUser,TFromLocDR,YearMonth))
	..s CutFee=$p(FroValueStr,"^",2)+TCutFee
	..s ProfitFee=$p(FroValueStr,"^",4)+##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(TPutOnSetDR,"2",TFromLocDR,TCost) ;总利润=总成本*分摊比例
	..s CutHour=$p(FroValueStr,"^",8)+TCutHour
	..s $p(FroValueStr,"^",2)=CutFee
	..s $p(FroValueStr,"^",4)=ProfitFee
	..s $p(FroValueStr,"^",8)=CutHour
	..s ^DHCEQTemp(nodestr,Date,Job,CurUser,TFromLocDR,YearMonth)=FroValueStr
	.e  d
	..s CutFee=+TCutFee	;减免费用
	..s ProfitFee=##Class(web.DHCEQ.RM.BUSRent).GetCostAllotFee(TPutOnSetDR,"2",TFromLocDR,TCost) ;总利润=总成本*分摊比例
	..s CutHour=+TCutHour	;减免时长
	..s ^DHCEQTemp(nodestr,Date,Job,CurUser,TFromLocDR,YearMonth)="0^"_CutFee_"^0^"_ProfitFee_"^0^0^0^"_CutHour_"^0^0"
	
	s (OneCostInfo,OneIncomeInfo,OneWorkHourInfo,OneProfitInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (YearMonths,counts)=""
	s (AllCost,AllProfit,AllWorHour,countNum)=0
	
	s YearMonth=""
	f  s YearMonth=$o(^DHCEQTemp(nodestr,Date,Job,CurUser,CurLocDR,YearMonth)) q:YearMonth=""  d
	.s resultinfo=$g(^DHCEQTemp(nodestr,Date,Job,CurUser,CurLocDR,YearMonth))
	.s countNum=countNum+1
	.q:countNum>12	//统计近12个月
	.s TAllCost=$p(resultinfo,"^",3)
	.s TAllProfit=$p(resultinfo,"^",4)
	.s TAllWorHour=$p(resultinfo,"^",10)
	.s AllCost=AllCost+TAllCost
	.s AllProfit=AllProfit+TAllProfit
	.s AllWorHour=AllWorHour+TAllWorHour
	.i counts'="" s counts=counts_"^"
	.s counts=counts_countNum
	.i YearMonths'="" s YearMonths=YearMonths_"^"
	.s YearMonths=YearMonths_YearMonth
	.d OneCostInfo.%Set("1-"_countNum,AllCost)		//CurLengedDR_"-"_CurXYDR
	.d OneIncomeInfo.%Set("2-"_countNum,AllProfit)
	.d OneProfitInfo.%Set("1-"_countNum,AllCost)
	.d OneProfitInfo.%Set("2-"_countNum,AllProfit)
	.d OneWorkHourInfo.%Set("3-"_countNum,AllWorHour)
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("RentCostAnaly","1","调配支出",counts,YearMonths,OneCostInfo,RentShareInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("RentIncomeAnaly","2","调配收入",counts,YearMonths,OneIncomeInfo,RentShareInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("RentProfitAnaly","1^2","调配支出^调配收入",counts,YearMonths,OneProfitInfo,RentShareInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("RentWorkHourAnaly","3","总时长",counts,YearMonths,OneWorkHourInfo,RentShareInfo)
	
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
	q RentShareInfo
}

/// add by czf 2020-06-11
/// 租赁资源状态统计图表
/// w ##Class(web.DHCEQ.RM.BUSRent).GetShareResourceStatistics(10248,327)
ClassMethod GetShareResourceStatistics(CurUserID As %String = "", CurLocID As %String = "")
{
	s RentShareInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s nodestr="web.DHCEQ.RM.BUSRent_GetShareResourceStatistics"
	s Date=+$H
	s Job=$J
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
	
	i CurUserID="" s CurUserID=%session.Get("LOGON.USERID")
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
	
	i CurLocID="" s CurLocID=%session.Get("LOGON.CTLOCID")
	s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",CurLocID)
	
	s LocIDType=##class("web.DHCEQ.RM.BUSShareResource").CheckLocType(CurLocDR)  //判断当前登录科室是否是租赁中心
	
	s (TotalStockNum,TotalLoanNum,TotalRentNum,FaultNum,TotalNum,FaultCost)=0
	s rowid=0
	f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",19)'="Y" //过滤未上架设备
	.;q:$p($g(^DHCEQSShareResource(rowid)),"^",18)="2"  //过滤报废设备
	.s TRentStatus=$p($g(^DHCEQSShareResource(rowid)),"^",15)    //过滤租赁中设备    0,1,2 在库,租赁中,预约租赁
	.s TWashFlag=$p($g(^DHCEQSShareResource(rowid)),"^",16)      //消毒清洗设备
	.s TInspectFlag=$p($g(^DHCEQSShareResource(rowid)),"^",17)   //检查标志
	.s TEquipDR=$p($g(^DHCEQSShareResource(rowid)),"^",3)
	.s TEquipName=$p($g(^DHCEQSShareResource(rowid)),"^",10)
	.s TLocDR=$p($g(^DHCEQSShareResource(rowid)),"^",7)		//所属科室
	.s TRentLocDR=$p($g(^DHCEQSShareResource(rowid)),"^",14)		//申请科室
	.q:(LocIDType'="1")&&((TLocDR'=CurLocDR)&&(TRentLocDR'=CurLocDR)) //非租赁中心只显示当科室共享设设备或租赁设备	
	.s TPutOnSetDR=$p($g(^DHCEQSShareResource(rowid)),"^",1)
	.s (TPOSShareItemDR,TPOSShareItem)=""
	.i TPutOnSetDR'=""  s TPOSShareItemDR = $p($g(^DHCEQSPutOnSet(TPutOnSetDR)),"^",22)
	.i TPOSShareItemDR'="" s TPOSShareItem = $Piece($Get(^DHCEQSCShareItem(TPOSShareItemDR)),"^",3)	;资源项
	.q:TPOSShareItemDR=""
	.;i TPOSShareItemDR="" s TPOSShareItemDR=0
	.s TotalNum=TotalNum+1	//总数量
	.i $Data(^DHCEQTemp(nodestr,Date,Job,CurUser,TPOSShareItemDR,TRentStatus)) d
	..s FroValueStr=$g(^DHCEQTemp(nodestr,Date,Job,CurUser,TPOSShareItemDR,TRentStatus))
	..;在库
	..i TRentStatus=0 d
	...s TotalStockNum=$p(FroValueStr,"^",1)+1
	...s $p(FroValueStr,"^",1)=TotalStockNum
	..;借出
	..i TRentStatus=1 d
	...i TRentLocDR=CurLocDR d
	....s TotalLoanNum=$p(FroValueStr,"^",2)+1		//调入数量
	....s $p(FroValueStr,"^",2)=TotalLoanNum			
	...i TLocDR=CurLocDR d
	....s TotalRentNum=$p(FroValueStr,"^",3)+1		//调出数量
	....s $p(FroValueStr,"^",3)=TotalRentNum
	..s ^DHCEQTemp(nodestr,Date,Job,CurUser,TPOSShareItemDR,TRentStatus)=FroValueStr
	.e  d
	..i TRentStatus=0 s ^DHCEQTemp(nodestr,Date,Job,CurUser,TPOSShareItemDR,TRentStatus)="1^0^0"
	..i TRentStatus=1 d
	...i TRentLocDR=CurLocDR s ^DHCEQTemp(nodestr,Date,Job,CurUser,TPOSShareItemDR,TRentStatus)="0^1^0"
	...i TLocDR=CurLocDR s ^DHCEQTemp(nodestr,Date,Job,CurUser,TPOSShareItemDR,TRentStatus)="0^0^1"
	.s TEquipStatus=$p($g(^DHCEQSShareResource(rowid)),"^",18)   //设备状态 0,1,2 完好,故障,报废
	.;故障设备使用成本与台次统计
	.i TEquipStatus="1" d
	..s TAllCost=0
	..s RentID=0
	..f  s RentID=$o(^DHCEQSRent(0,"ShareResource",rowid,RentID)) q:RentID=""  d
	...s TStatus=$p($g(^DHCEQSRent(RentID)),"^",36)
	...q:+TStatus<2		//"0":"新增", "1":"申请","2":"借出","3":"归还","4":"其他"
	...s TRequestLocDR=$p($g(^DHCEQSRent(RentID)),"^",2)
	...s TFromLocDR=$p($g(^DHCEQSRent(RentID)),"^",3)
	...q:(CurLocDR'="")&&((TRequestLocDR'=CurLocDR)&&(TFromLocDR'=CurLocDR))
	...s TTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(RentID)),"^",35),"")		//TrequestLoc支出
	...s TCutHour=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRent(RentID)),"^",46),"")		//TFromLoc减免时长
	...s TCost=TTotalFee-TCutFee		//TrequestLoc总成本
	...s TAllCost=TAllCost+TCost
	..i $Data(^DHCEQTemp(nodestr,"FaultAnalysis",Date,Job,CurUser,TPOSShareItemDR)) d
	...s FroValueStr=$g(^DHCEQTemp(nodestr,"FaultAnalysis",Date,Job,CurUser,TPOSShareItemDR))
	...s FaultNum=$p(FroValueStr,"^",1)+1		//台次
	...s FaultCost=$p(FroValueStr,"^",2)+TAllCost		//使用成本
	...s $p(FroValueStr,"^",1)=FaultNum
	...s $p(FroValueStr,"^",2)=FaultCost
	...s ^DHCEQTemp(nodestr,"FaultAnalysis",Date,Job,CurUser,TPOSShareItemDR)=FroValueStr
	..e  s ^DHCEQTemp(nodestr,"FaultAnalysis",Date,Job,CurUser,TPOSShareItemDR)="1"_"^"_TAllCost
	
	s (OneStockInfo,OneLoanInfo,OneRentInfo,OneStoRentInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (Status,TPOSShareItem,TStatus,POSShareItemDRs,POSShareItems)=""
	s (countNum,StockNum,LoanNum,RentNum)=0
	s POSShareItemDR=""
	f  s POSShareItemDR=$o(^DHCEQTemp(nodestr,Date,Job,CurUser,POSShareItemDR)) q:POSShareItemDR=""  d
	.s countNum=countNum+1
	.q:countNum>10		//统计近10
	.s POSShareItem = $Piece($Get(^DHCEQSCShareItem(POSShareItemDR)),"^",3)	;资源项
	.s Status=""
	.f  s Status=$o(^DHCEQTemp(nodestr,Date,Job,CurUser,POSShareItemDR,Status)) q:Status=""  d
	..s resultinfo=$g(^DHCEQTemp(nodestr,Date,Job,CurUser,POSShareItemDR,Status))
	..s TStatus=$case(Status,0:"在库",1:"借出",2:"预约租赁")
	..s StockNum=$p(resultinfo,"^",1)
	..s LoanNum=$p(resultinfo,"^",2)
	..s RentNum=$p(resultinfo,"^",3)
	..d OneStockInfo.%Set("0-"_POSShareItemDR,StockNum)		//在库   //CurLengedDR_"-"_CurXYDR
	..d OneLoanInfo.%Set("1-"_POSShareItemDR,LoanNum)		//调入
	..d OneRentInfo.%Set("2-"_POSShareItemDR,RentNum)		//调出
	..d OneStoRentInfo.%Set("0-"_POSShareItemDR,StockNum)
	..d OneStoRentInfo.%Set("1-"_POSShareItemDR,LoanNum)
	..d OneStoRentInfo.%Set("2-"_POSShareItemDR,RentNum)
	.i POSShareItemDRs'="" s POSShareItemDRs=POSShareItemDRs_"^"
	.s POSShareItemDRs=POSShareItemDRs_POSShareItemDR
	.i POSShareItems'="" s POSShareItems=POSShareItems
	.s POSShareItems=POSShareItems_POSShareItem
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ShareResourceInStock","0","在库",POSShareItemDRs,POSShareItems,OneStockInfo,RentShareInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ShareResourceRent","1","调出",POSShareItemDRs,POSShareItems,OneRentInfo,RentShareInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ShareResourceStoRent","0^1^2","在库^调入^调出",POSShareItemDRs,POSShareItems,OneStoRentInfo,RentShareInfo)
	
	s (OneShareFaultNum,OneShareFaultCost)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (countNum,FaultNum,FaultCost)=0
	s (POSShareItemDRs,POSShareItems)=""
	s POSShareItemDR=""
	f  s POSShareItemDR=$o(^DHCEQTemp(nodestr,"FaultAnalysis",Date,Job,CurUser,POSShareItemDR)) q:POSShareItemDR=""  d
	.s countNum=countNum+1
	.q:countNum>10		//统计近10
	.s POSShareItem = $Piece($Get(^DHCEQSCShareItem(POSShareItemDR)),"^",3)	;资源项
	.s resultinfo=$g(^DHCEQTemp(nodestr,"FaultAnalysis",Date,Job,CurUser,POSShareItemDR))
	.s FaultNum=$p(resultinfo,"^",1)
	.s FaultCost=$p(resultinfo,"^",2)
	.d OneShareFaultNum.%Set("0-"_POSShareItemDR,FaultNum)
	.d OneShareFaultCost.%Set("1-"_POSShareItemDR,FaultCost)
	.i POSShareItemDRs'="" s POSShareItemDRs=POSShareItemDRs_"^"
	.s POSShareItemDRs=POSShareItemDRs_POSShareItemDR
	.i POSShareItems'="" s POSShareItems=POSShareItems
	.s POSShareItems=POSShareItems_POSShareItem
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ShareFaultNum","0","台次",POSShareItemDRs,POSShareItems,OneShareFaultNum,RentShareInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ShareFaultCost","1","成本",POSShareItemDRs,POSShareItems,OneShareFaultCost,RentShareInfo)
	
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
	q RentShareInfo
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSRent","GetRentStatus","")
Query GetRentStatus() As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetRentStatusExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Length=4
	f ID=0:1:Length d
	.;"0":"完好","1":"有缺陷"
	.S TDesc=$CASE(ID,"0":"新增", "1":"申请","2":"借出","3":"归还","4":"其他")
	.d OutputRowGetRentStatus
	
	Quit $$$OK
OutputRowGetRentStatus
	Set Data=$lb(ID,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetRentStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentStatusExecute ]
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

ClassMethod GetRentStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add By zc0079 2020-07-10
/// 描述:取资源项目或资源对应的设备类组ID
/// 入参：ShareResourceDR 资源ID ShareItemDR 资源项目ID 
/// 返回：未找到对应的租赁价格ID,则返回""
/// 	  否则返回相应信息	vRPRowID
/// w ##Class(web.DHCEQ.RM.BUSRent).GetEquipTypeByShare("26951","1")
ClassMethod GetEquipTypeByShare(vShareResourceDR, vShareItemDR)
{
	s vEquipTypeDR=""
	i vShareResourceDR'="" d
	.s vEquipDR=$p($g(^DHCEQSShareResource(vShareResourceDR)),"^",3)
	.i vEquipDR'="" d
	..s vEquipTypeDR=$p($g(^DHCEQEquip(vEquipDR)),"^",63)
	i vEquipTypeDR'="" q vEquipTypeDR

	s vFlag=0
	i vShareItemDR'="" d
	.s vSLRowID=0
	.f  s vSLRowID=$o(^DHCEQSCShareItemList(0,"ShareItem",vShareItemDR,vSLRowID))  quit:(vSLRowID="")||(vFlag'=0)  d
	..q:$p($g(^DHCEQSCShareItemList(vSLRowID)),"^",5)="Y"
	..s vItemDR=$p($g(^DHCEQSCShareItemList(vSLRowID)),"^",2)
	..s vEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",vItemDR)),"^",3)
	..s vFlag=1
	q vEquipTypeDR
}

/// Author  ZX 2020-08-24 ZX0103
/// 描述:调配设备每天执行此方法,计算调配中设备每天产生费用
/// 入参：Date 费用产生日期
/// 返回：0:成功  其它:失败
/// w ##Class(web.DHCEQ.RM.BUSRent).CreateRentFee()
ClassMethod CreateRentFee(Date As %Library.String = "")
{
	s result=0
	i Date="" s Date=+$h-1
	f Status=2:1:3  d
	.s RRowID=0
	.f  s RRowID=$o(^DHCEQSRent(0,"Status",Status,RRowID)) q:(RRowID="")||(result'=0)  d
	..s EndDate=$p($g(^DHCEQSRent(RRowID)),"^",23)
	..q:(EndDate'="")&&(EndDate<Date)
	..s StartDate=$p($g(^DHCEQSRent(RRowID)),"^",10)
	..q:StartDate=""
	..q:StartDate>Date
	..s StartTime=0
	..i StartDate=Date s StartTime=$p($g(^DHCEQSRent(RRowID)),"^",11)
	..s EndTime=$p($g(^DHCEQSRent(RRowID)),"^",24)
	..i Status="2" s EndTime="86399"  //当天归还单据截止时间为23:59:59
	..s DiscountFee=$p($g(^DHCEQSRent(RRowID)),"^",48)
	..s Hour=$fn((EndTime-StartTime)/3600,"",2)
	..s SRDR=$p($g(^DHCEQSRent(RRowID)),"^",9)
	..q:SRDR=""
	..s SPRowID=##Class(web.DHCEQ.RM.CTResourcePrice).GetResourcePriceInfo(SRDR)
	..q:SPRowID=""  //Modify by zx 2020-09-07 BUG ZX0108
	..s CurFlag=0
	..s SHPRowID=0
	..f  s SHPRowID=$o(^DHCEQSResourceHistoryPrice(0,"ResourcePrice",SPRowID,SHPRowID)) q:(SHPRowID="")||(CurFlag'=0)||(result'=0)  d
	...q:$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",9)="N"
	...s CurFlag=1
	...s ModeDR=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",3)
	...s Mode =$CASE(ModeDR,"1":"租赁时长", "2":"工作量","":"")
	...s UomQuantity=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",4)
	...s UOMDR=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",5)
	...s UOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",UOMDR)
	...s Price=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",6)
	...s PriType=$p($g(^DHCEQSResourceHistoryPrice(SHPRowID)),"^",2)
	...s (WorLoad,TotalFee)=0
	...i ModeDR="1" d
	....i UOM="小时" d
	.....s WorLoad=Hour
	.....s TotalFee=##Class(web.DHCEQCommon).FormatNumber((Price*WorLoad)/UomQuantity,2)
	....i UOM="天" d
	.....s WorLoad="1"
	.....s TotalFee=##Class(web.DHCEQCommon).FormatNumber((Price*WorLoad)/UomQuantity,2)
	...s CostFee=TotalFee-DiscountFee
	...s RentFeeVal="^"_RRowID_"^"_SHPRowID_"^"_Date_"^"_PriType_"^"_TotalFee_"^"_UomQuantity_"^"_UOMDR_"^"_WorLoad_"^"_Price_"^"_DiscountFee_"^"_CostFee_"^^^"
	...s result=##Class(web.DHCEQ.RM.BUSRent).SaveRentFee(RentFeeVal)
	...q:result'=0
	
	q result
}

/// Author  ZX 2020-08-24 ZX0103
/// 描述:费用通过sql插入
/// 入参：插入数据拼串
/// 返回：SQLCODE 0:成功  其它:失败
ClassMethod SaveRentFee(val)
{
	k PLIST
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s PLIST(7)=$p(val,"^",7)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)
	s PLIST(11)=$p(val,"^",11)
	s PLIST(12)=$p(val,"^",12)
	s PLIST(13)=$p(val,"^",13)
	s PLIST(14)=$p(val,"^",14)
	&SQL(insert into sqluser.DHC_EQSRentFee values :PLIST())
	q SQLCODE
}

/// Modefied by zc0111 2021-12-29 获取减少时长对应的减少费用
/// 入参：
/// 		RResourcePriceDR：定价记录ID
/// 		RHold2：减少时长
/// 返回值：减少费用
/// w ##Class(web.DHCEQ.RM.BUSRent).GetReduceFeeByRResourcePrice(41,0.49)
ClassMethod GetReduceFeeByRResourcePrice(RResourcePriceDR As %Library.String = "", RHold2 As %Library.String = "")
{
	i RResourcePriceDR="" q 0
	s UomQuantity=+$p($g(^DHCEQSResourceHistoryPrice(RResourcePriceDR)),"^",4)
	i UomQuantity=0 q 0
	s Price=+$p($g(^DHCEQSResourceHistoryPrice(RResourcePriceDR)),"^",6)
	q ##Class(web.DHCEQCommon).FormatNumber(RHold2*Price/UomQuantity,"",2)
}

}
