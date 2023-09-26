/// 修改:zy 2010-03-29  No ZY0019
/// 描述:增加取消和取消到第几步字段的操作。
/// -----------------------------
/// 添加:Mozy	2009-9-13
/// 添加查询类：GetApproveFlowNew()
Class web.DHCEQCApproveFlow Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQCApproveFlow).UpdateData("107^29^14^1^true^true^^^^^false^0^^0^true",0)
/// modified by sjh SJH0040 2020-11-26 增加数据修改日志
ClassMethod UpdateData(Val, Type)
{
	//Type=0,更新
	//Type＝1，删除
	Set $ZT="ERROR"
	s RowID=$P(Val,"^",1)
	s TableName="DHC_EQCApproveFlow"
	s ClassName="User.DHCEQCApproveFlow"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	TSTART
	i +Type=0
	{
		s PLIST(2)=$P(Val,"^",2)
		s PLIST(3)=$P(Val,"^",3)
		s PLIST(4)=$P(Val,"^",4)
		s PLIST(5)=##Class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",5),"bool")
		s PLIST(6)=##Class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",6),"bool")
		s PLIST(7)=$P(Val,"^",7)
		
		//Modified by jdl 2011-3-2 JDL0072
		s PLIST(8)=$P(Val,"^",8)
		s PLIST(9)=$P(Val,"^",9)
		s PLIST(10)=$P(Val,"^",10)
		//s PLIST(11)=$P(Val,"^",11)
		s PLIST(11)=##Class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",11),"bool") //add by zx 2015-08-19  ZX0028
		
		//modify by GBX 2015-12-16   GBX0037
		s PLIST(12)=$P(Val,"^",12)    ;AF_GotoType		
		s PLIST(13)=$P(Val,"^",13)   ;NextToFlowDR
		s PLIST(14)=$P(Val,"^",14)   ;CancelToType
		s PLIST(15)=##Class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",15),"bool")    ;
		
		// add by zx 2016-02-29 ZX0039
		s PLIST(16)=##Class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",16),"bool")
		//Modified by QW 2019-08-31 多方审批 保存MultipleNum,MultipleDefineDR
		s PLIST(17)=$P(Val,"^",17)   ;RepeatNum
		s PLIST(18)=$P(Val,"^",18)   ;Hold3->MultipleNum
		s PLIST(19)=$P(Val,"^",19)   ;MultipleDefineDR  增加表字段
		//End by QW 2019-08-31 多方审批 保存MultipleNum,MultipleDefineDR
		s PLIST(20)=$P(Val,"^",20)   ;ComponentSetID  Add By QW20200108 BUG:QW0035 增加表字段
		s PLIST(21)=$P(Val,"^",21)	 ;HospLimit czf 2021-09-01 院区限制0:不限 1:本院 2:医院默认医院 3:本院及默认医院
		s PLIST(22)=$P(Val,"^",22)	;Default czf 2022-10-12 默认意见
		;DJ0140
		s ApproveSetDR=$P(Val,"^",2)
		s ActionDR=$P(Val,"^",10)
		s FindID=""
		//动作不可重复
		//modify by GBX 2015-12-07 AF_Hold3->AF_ActionDR  GBX0037
		&SQL(Select AF_RowID Into :FindID From SQLUSER.DHC_EQCApproveFlow Where AF_ApproveSetDR=:ApproveSetDR and AF_ActionDR=:ActionDR)
		
		if RowID=""
		{
			;DJ0140
			i FindID'="" q -1001
			Set BussID="",OperateType="A"
			&SQL(insert into sqluser.DHC_EQCApproveFlow values :PLIST())
		}
		else
		{
			;DJ0140
			i (FindID'="")&&(FindID'=RowID) q -1001			//Add By DJ 2015-07-14 DJ0147
			Set BussID=RowID,OperateType="U"
			s OldObject=##Class(User.DHCEQCApproveFlow).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(update sqluser.DHC_EQCApproveFlow values :PLIST() where AF_RowID=:RowID)
			
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		//s ID=$G(%ROWID)
		//q SQLCODE
	}
	else
	{
		s OldObject=##Class(User.DHCEQCApproveFlow).%OpenId(RowID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		&SQL(delete from sqluser.DHC_EQCApproveFlow where AF_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,RowID,"D",NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
		TCOMMIT
		q SQLCODE
	}
	//if SQLCODE  q SQLCODE
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCApproveFlow).%OpenId(ID))
	i BussID'=""	//更新数据获取更新字段Json串
	{
		s key=""
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
    		i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}
	else			//插入数据
	{
		s BussID=ID
		s NewObj=FinalObj
	}
	
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
	}
 	TCOMMIT
 	q SQLCODE
ERROR
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERROR"_ErrorMsg    //返回错误消息 ;
}

ClassMethod GetOneApproveFlow(RowID)
{
	i RowID="" q ""
	new result,ApproveRole
	///Modified By QW20200108 BUG:QW0035 组件设置ComponentSet
	s (result,ApproveRole,ApproveFlowDR,Step,NextToFlowDR,NextToFlow,MultipleDefine,ComponentSet)=""
	///End By QW20200108 BUG:QW0035 组件设置
	s result=^DHCEQCCode("DHCEQCApproveFlow",RowID)
	s ApproveRoleDR=$P(result,"^",2)
	i ApproveRoleDR'="" s ApproveRole=$P($g(^DHCEQCCode("DHCEQCApproveRole",ApproveRoleDR)),"^",2)
	s ApproveFlowDR=$P(result,"^",6)
	i ApproveFlowDR'="" s Step=$P($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",3)
	
	//add by GBX 2015-12-16  可重复标志   GBX0037
	s NextToFlowDR=$P(result,"^",12)
	i NextToFlowDR'="" s NextToFlow=$P($g(^DHCEQCCode("DHCEQCApproveFlow",NextToFlowDR)),"^",3)
	
	i $P(result,"^",4)="Y" 
	{
		s $P(result,"^",4)="1"
	}
	else
	{
		i $P(result,"^",4)'="Y" s $P(result,"^",4)="0"
	}
	i $P(result,"^",5)="Y" 
	{
		s $P(result,"^",5)="1"
	}
	else
	{
		i $P(result,"^",5)'="Y" s $P(result,"^",5)="0"
	}
	i $P(result,"^",10)="Y"  //add by zx 2015  ZX0028	
	{
		s $P(result,"^",10)="1"
	}
	else
	{
		i $P(result,"^",10)'="Y" s $P(result,"^",10)="0"
	}
	i $P(result,"^",14)="Y"  //add by GBX 2015-12-16  可重复标志   GBX0037
	{
		s $P(result,"^",14)="1"
	}
	else
	{
		i $P(result,"^",14)'="Y" s $P(result,"^",14)="0"
	}
	i $P(result,"^",15)="Y"  //add by zx 2016-02-29  ZX0039
	{
		s $P(result,"^",15)="1"
	}
	else
	{
		i $P(result,"^",15)'="Y" s $P(result,"^",15)="0"
	}
	;DJ0140
	s Action=$P(result,"^",9)
	i Action="0"  d
	.s Action="提交"
	e  d
	.i Action'="" s Action=$p($g(^DHCEQCCode("DHCEQCAction",Action)),"^",2)
	
	///add by QW 2019-08-31 多方审批
    i $P(result,"^",18)'="" s MultipleDefine=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",$P(result,"^",18))),"^",4)
    i $P(result,"^",19)'="" s ComponentSet=$p($g(^DHCEQCCode("DHCEQCComponentSet",$P(result,"^",19))),"^",9)  //Add By QW20200108 BUG:QW0035 组件设置
	q result_"^"_ApproveRole_"^"_ApproveFlowDR_"^"_Step_"^"_Action_"^"_NextToFlow_"^"_MultipleDefine_"^"_ComponentSet            //Modified By QW20200108 BUG:QW0035 组件设置
	///End  by QW 2019-08-31 多方审批
}

// modify by GBX 2015-12-07  DHC_EQCApproveFlow表结构修改   GBX0037

Query GetApproveFlow(ApproveSetDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TApproveSet:%String,TApproveRole:%String,TStep:%String,TLastFlag:%String,TCancelFlag:%String,TCancelToFlowDR:%String,Hidden:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
SELECT AF_RowID TRowID,
	   AF_ApproveSetDR->AS_Desc TApproveSet,	
	   AF_ApproveRoleDR->AR_Desc TApproveRole,
	   AF_Step TStep,
	   AF_LastFlag TLastFlag,
	   AF_CancelFlag TCancelFlag,
	   AF_CancelToFlowDR->AF_Step TCancelToFlowDR,
	   AF_ApproveRoleDR TApproveRoleDR,
	   AF_QXType THold1,
	   AF_LocDR THold2,
	   AF_ActionDR THold3,
	   AF_UnMustFlag THold4,
	   AF_GotoType THold5
	   
FROM sqluser.DHC_EQCApproveFlow
where AF_ApproveSetDR=:ApproveSetDR
}

/*
/// 添加:Mozy	2009-9-13
/// 添加查询类：GetApproveFlowNew()
Query GetApproveFlowNew(ApproveSetDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TApproveSet:%String,Hidden:%String,TApproveRole:%String,TStep:%String,TLastFlag:%String")
{
SELECT AF_RowID TRowID,
	   AF_ApproveSetDR->AS_Desc TApproveSet,	
	   AF_ApproveRoleDR,
	   AF_ApproveRoleDR->AR_Desc TApproveRole,
	   AF_Step TStep,
	   AF_LastFlag TLastFlag
	   
FROM sqluser.DHC_EQCApproveFlow
where AF_ApproveSetDR=:ApproveSetDR
}
*/
/// 添加:zy 2010-03-29  No ZY0019
/// 添加查询类：GetApproveStep()
/// 查找可以取消到的步骤
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetApproveStep(ApproveSetDR, Step) As %SQLQuery(ROWSPEC = "Hidden:%String,TStep:%String:步骤,TApproveRole:%String:审批角色")
{
SELECT AF_RowID TRowID,	
	   AF_Step TStep,
	   AF_ApproveRoleDR->AR_Desc TApproveRole	   
FROM sqluser.DHC_EQCApproveFlow
where AF_ApproveSetDR=:ApproveSetDR and AF_Step<>:Step
}

/// 添加:GBX 2015-12-16  GBX0037
/// 添加查询类：GetGoToApproveStep()
/// 查找可以指定的审批步骤
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetGoToApproveStep(ApproveSetDR, Step) As %SQLQuery(ROWSPEC = "Hidden:%String,TStep:%String:步骤,TApproveRole:%String:审批角色")
{
SELECT AF_RowID TRowID,	
	   AF_Step TStep,
	   AF_ApproveRoleDR->AR_Desc TApproveRole	   
FROM sqluser.DHC_EQCApproveFlow
where AF_ApproveSetDR=:ApproveSetDR and AF_Step<>:Step
}

/*****************************************************************************/
/// d ##class(%ResultSet).RunQuery("web.DHCEQCApproveFlow","ApproveFlow","37")
Query ApproveFlow(ApproveSetDR As %String) As %Query(ROWSPEC = "TRowID:%String,TApproveSet:%String,TApproveRole:%String,TStep:%String,TLastFlag:%String,TCancelFlag:%String,TCancelToFlowDR:%String,Hidden:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TAction:%String,TNextToFlowDR:%String,TNextToFlow:%String,TCancelToType:%String,TCanRepeatFlag:%String,TChangeTypeFlag:%String,TRow:%String,TRepeatNum:%String,THospLimit:%String,TDefaultOpinion:%String")
{
}

ClassMethod ApproveFlowExecute(ByRef qHandle As %Binary, ApproveSetDR As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s TRow=0
	s index=1
	s ASRowID=0
	f  s ASRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveSet",ASRowID))  q:ASRowID=""  d
	.q:(ApproveSetDR'="")&&(ASRowID'=ApproveSetDR)
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveSet",ASRowID,rowid)) quit:rowid=""  d
	..d ResetVariablesGetApproveFlow
	..s TRowID=rowid
	..s TApproveSetDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",1)
	..i TApproveSetDR'="" s TApproveSet=$p($g(^DHCEQCCode("DHCEQCApproveSet",TApproveSetDR)),"^",2)
	..s TApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",2)
	..i TApproveRoleDR'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	..s TStep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",3)
	..s TLastFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",4)
	..s TLastFlag=$CASE(TLastFlag,"Y":"是","N":"否","":"否") ;add by QW 2018-10-08 描述：hisui改造,Y/N改为是/否
	..s TCancelFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",5)
	..s TCancelFlag=$CASE(TCancelFlag,"Y":"是","N":"否","":"否") ;add by QW 2018-10-08 描述：hisui改造,Y/N改为是/否
	..s TCancelToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",6)
	..i TCancelToFlowDR'="" s TCancelToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TCancelToFlowDR)),"^",3)
	..//Modified BY QW20181025 需求号:729018
	..s THold1=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",7)
	..s THold2=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",8)
	..s THold3=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",9)
	..s THold4=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",10)
	..s THold4=$CASE(THold4,"Y":"是","N":"否","":"否") 
	..//End BY QW20181025 需求号:729018
	..s THold5=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",11)
	..//add by GBX 2015-12-16  GBX0037
	..s THold5=..GetApproveToType(THold5)
	..s TNextToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",12)
	..i TNextToFlowDR'="" s TNextToFlow=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TNextToFlowDR)),"^",3)
	..s TCancelToType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",13)
	..s TCancelToType=..GetApproveToType(TCancelToType)
	..s TCanRepeatFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",14)
	..s TCanRepeatFlag=$CASE(TCanRepeatFlag,"Y":"是","N":"否","":"否") ;add by QW 2018-10-08 描述：hisui改造,Y/N改为是/否
	..i THold3'=""  d
	...i THold3=0 s TAction="提交"
	...i THold3'=0 s TAction=$p($g(^DHCEQCCode("DHCEQCAction",THold3)),"^",2)
	..s TChangeTypeFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",15) //add by zx 2016-02-29 ZX0039
	..s TChangeTypeFlag=$CASE(TChangeTypeFlag,"Y":"是","N":"否","":"否") ;add by QW 2018-10-08 描述：hisui改造,Y/N改为是/否
	..s TRepeatNum=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",16) //add by zx 2018-07-10
	..s THospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",20)
	..s THospLimit=$case(THospLimit,"1":"本院及医院组总院","2":"本院","3":"医院组总院",0:"不限",:"")	//czf 2021-09-01
	..s TDefaultOpinion=$p($g(^DHCEQCCode("DHCEQCApproveFlow",TRowID)),"^",21)	//默认意见 czf 2022-10-12
	..d OutputRowGetApproveFlow
	Quit $$$OK
OutputRowGetApproveFlow
	s TRow=TRow+1
	s Data=$lb(TRowID,TApproveSet,TApproveRole,TStep,TLastFlag,TCancelFlag,TCancelToFlowDR,TApproveRoleDR,THold1,THold2,THold3,THold4,THold5,TAction,TNextToFlowDR,TNextToFlow,TCancelToType,TCanRepeatFlag,TChangeTypeFlag,TRow,TRepeatNum,THospLimit,TDefaultOpinion)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetApproveFlow
	s (TRowID,TApproveSet,TApproveRole,TStep,TLastFlag,TCancelFlag,TCancelToFlowDR,TApproveRoleDR,THold1,THold2,THold3,THold4,THold5,TAction,TNextToFlowDR,TNextToFlow,TCancelToType,TCanRepeatFlag,TChangeTypeFlag,TRepeatNum,THospLimit,TDefaultOpinion)=""
	quit
}

ClassMethod ApproveFlowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ApproveFlowExecute ]
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

ClassMethod ApproveFlowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ApproveFlowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// modified by ZY0272 2021-06-28 ApproveSetDR不能初始化
/// modified by czf 2021-06-16 增加ApproveSetDR参数
/// add 20191012 by zy 采购申请审批流的控制，增加判断条件
/// 输出为0表示要过滤此单据，为1表示不过滤
/// 增加审批流过滤类型,Type:1,是否非必要 2,是否可中断
/// Add By ZX 2016-02-29 BugZX0035
/// w ##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("1","BuyReq_Decision","2","2")
ClassMethod CheckApproveFlagAbove(ApproveType, Action, SourceID, Type As %Library.String = "1", ApproveSetDR As %String = "")
{
	new ActionDR,ApproveFlowDR,Step,ApproveInfoDR,NextFlowStep,CurStep,AFID
	new UnMustFlag,AllowSteps,ChangeTypeFlag,AllowFlowDR,AllowStep,ApproveInfoDR,EquipType
	s Flag=1
	s (EquipType,PurchaseType,MaxPrice,YearFlag)=""			//Add By DJ 2016-04-20 begin
	s ApproveTypeDR=##class(web.DHCEQApproveList).GetApproveType(ApproveType)
	i ApproveType="25" s EquipType=$p($g(^DHCEQMMaintRequest(SourceID)),"^",3)
	i ApproveType="1"
	{
		s EquipType=$p($g(^DHCEQBuyRequest(SourceID)),"^",25)
		s PurchaseType=$p($g(^DHCEQBuyRequest(SourceID)),"^",26)
		s MaxPrice=$p($g(^DHCEQBuyRequest(SourceID)),"^",9)
		s YearFlag=$p($g(^DHCEQBuyRequest(SourceID)),"^",3)
	}
	i ApproveSetDR="" s ApproveSetDR=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveTypeDR, EquipType,PurchaseType,"",MaxPrice,YearFlag,"")	//Add By DJ 2016-04-20 end
	//s ApproveSetDR=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveTypeDR,0))
	s ApproveInfoDR=$o(^DHCEQApproveInfo(0,"SourceID",ApproveTypeDR,SourceID,0))
	i ApproveInfoDR="" q 0
	s Step=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",5)
	i Step="" q 0
	s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,Step,0))
	i ApproveFlowDR="" q 0
	//是否非必要
	i Type=1
	{
	    s ApproveInfoDR=$o(^DHCEQApproveInfo(0,"SourceID",ApproveTypeDR,SourceID,0))
	    i ApproveInfoDR="" q Step
	    s NextFlowStep=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",5)
		i Step-1-NextFlowStep<0 s Flag=0  //超过此步骤 不显示
	    f CurStep=NextFlowStep:1:Step-1  d
	    .s AFID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,CurStep,0))
	    .i AFID'="" d
	    ..s UnMustFlag =$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFID)),"^",10)
	    ..i UnMustFlag'="Y" s Flag=0  //有必填项 不显示
	    
	    q Step_"^"_Flag
	}
	//是否可中断
	i Type=2
	{
		s AllowSteps=""
		s ChangeTypeFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",15)
		i ChangeTypeFlag'="Y" s Flag=0 //无中断权限
		e  d
		.s AllowFlowDR=0
		.f  s AllowFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",0,"SourceFlow",2,ApproveFlowDR,AllowFlowDR)) q:AllowFlowDR=""  d
		..s AllowStep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AllowFlowDR)),"^",3)
		..s AllowSteps=AllowSteps_AllowStep_","
		
		q Step_"^"_Flag_"^"_AllowSteps
	}
}

/// add by GBX 2015-12-16  GBX0037
/// 描述:审批流转类型
/// Modify By QW 2018-08-31 HISUI改造：自定义下拉列表显示格式错误
ClassMethod ApproveToType(name, width) As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	Write "<option value=></option>"
	Write "<option value=0>默认下一步</option>"
	Write "<option value=1>指定步骤</option>"
	Write "<option value=2>人为操作指定步骤</option>"
	Write "<option value=3>根据条件流转步骤</option>"
	Write "</select>",!
}

/// add by GBX 2015-12-16  GBX0037
ClassMethod GetApproveToType(ApproveToType)
{
	q $CASE(ApproveToType,"0":"默认下一步","1":"指定步骤","2":"人为操作指定步骤","3":"根据条件流转步骤",:"")
}

/*****************************************************************************/
Query GetApproveFlowAllow(ApproveFlowDR As %String, Type As %String) As %Query(ROWSPEC = "TRowID:%String,TCurRoleDR:%String,TCurRole:%String,TAllowRoleDR:%String,TAllowRole:%String,TAction:%String")
{
}

ClassMethod GetApproveFlowAllowExecute(ByRef qHandle As %Binary, ApproveFlowDR As %String, Type As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (ApproveFlowDR="") Quit $$$OK
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid))  q:rowid=""  d
	.d ResetVariablesGetApproveFlowAllow
	.s TRowID=rowid
	.s TCurRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid),"^",1)
	.q:(ApproveFlowDR'="")&(ApproveFlowDR'=TCurRoleDR)
	.s TType=$p(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid),"^",3)
	.q:(TType'=Type)&(Type'="")
	.s TCurRoleFlowDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TCurRoleDR),"^",2)
	.i TCurRoleFlowDR'="" s TCurRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TCurRoleFlowDR)),"^",2)
	.s TAllowRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid),"^",2)
	.q:TAllowRoleDR=""
	.s TAllowRoleFlowDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TAllowRoleDR),"^",2)
	.i TAllowRoleFlowDR'="" s TAllowRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TAllowRoleFlowDR)),"^",2)
	.s TAction=$p(^DHCEQCCode("DHCEQCApproveFlow",TAllowRoleDR),"^",9)						//Add By DJ 2016-04-20
	.i TAction'="" s TAction=$p(^DHCEQCCode("DHCEQCAction",TAction),"^",2)			//Add By DJ 2016-04-20
	.d OutputRowGetApproveFlowAllow
	Quit $$$OK
OutputRowGetApproveFlowAllow
	s Data=$lb(TRowID,TCurRoleDR,TCurRole,TAllowRoleDR,TAllowRole,TAction)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetApproveFlowAllow
	s (TRowID,TCurRoleDR,TCurRole,TAllowRoleDR,TAllowRole,TCurRoleFlowDR,TAllowRoleFlowDR,TAction)=""
	quit
}

ClassMethod GetApproveFlowAllowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApproveFlowAllowExecute ]
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

ClassMethod GetApproveFlowAllowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApproveFlowAllowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// modified by sjh SJH0040 2020-11-26 增加数据修改日志
ClassMethod UpdateApproveFlowAllow(Val, Type)
{
	k PLIST
	
	n RowID,FindID
	Set $ZT="ERRORALLOW"
	s RowID=$P(Val,"^",1)
	s TableName="DHC_EQCApproveFlowAllow"
	s ClassName="User.DHCEQCApproveFlowAllow"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	TSTART
	i +Type=0
	{
		s PLIST(2)=$P(Val,"^",2)
		s PLIST(3)=$P(Val,"^",3)
		s PLIST(4)=$P(Val,"^",4)
		;s PLIST(5)=$P(Val,"^",5)
		;s PLIST(6)=$P(Val,"^",6)
		
		s FindID=""

		&SQL(Select AFA_RowID Into :FindID From SQLUSER.DHC_EQCApproveFlowAllow Where AFA_AllowFlowDR=:PLIST(2) and AFA_AllowFlowDR=:PLIST(3)) //add by zx 2016-02-29 ZX0039
		
		if RowID=""
		{
			i FindID'="" q -1001
			Set BussID="",OperateType="A"
			&SQL(insert into sqluser.DHC_EQCApproveFlowAllow values :PLIST())
			if SQLCODE Q SQLCODE
		}
		else
		{
			i (FindID'="")&&(FindID'=RowID) q -1001	
			Set BussID=RowID,OperateType="U"
			s OldObject=##Class(User.DHCEQCApproveFlowAllow).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(update sqluser.DHC_EQCApproveFlowAllow values :PLIST() where AFA_RowID=:RowID)
			IF SQLCODE Q SQLCODE
		}
	}
	else
	{
		s OldObject=##Class(User.DHCEQCApproveFlowAllow).%OpenId(RowID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		&SQL(delete from sqluser.DHC_EQCApproveFlowAllow where AFA_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,RowID,"D",NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
		TCOMMIT
	 	Quit SQLCODE
	}
	if SQLCODE  q SQLCODE
	Set ID=$g(%ROWID)
	s FinalObj.AFASouceFlowDR=$Piece(Val,"^",2)
	s FinalObj.AFAAllowFlowDR=$Piece(Val,"^",3)
	s FinalObj.AFAHold1=$Piece(Val,"^",4)
	i BussID'=""	//更新数据获取更新字段Json串
	{
		s key=""	//CZF0131 2020-01-20
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
			i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}
	else			//插入数据
	{
		s BussID=ID
		s NewObj=FinalObj
	}
	
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
	}
 	TCOMMIT
 	q SQLCODE
ERRORALLOW
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORALLOW"_ErrorMsg     //返回错误消息 ;
}

ClassMethod GetOneFlowAllow(RowID)
{
	s result=""
	s AllowRoleFlowDR=""
	s AllowRole=""
	i RowID="" q "^^^^^^"
	s result=$g(^DHCEQCCode("DHCEQCApproveFlowAllow",RowID))
	i ($P(result,"^",2)'="") 
	{
		s AllowRoleFlowDR=$p(^DHCEQCCode("DHCEQCApproveFlow",$P(result,"^",2)),"^",2)
		s AllowRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",AllowRoleFlowDR)),"^",2)
	}
	q RowID_"^"_result_"^"_AllowRole
}

/// add by GBX 2015-12-21 GBX0037
/// 获取人为指定操作的审批步骤
/// ApproveFlowDR:当前审批步骤  Type:0  审批  1 取消审批
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query GetApproveFlowRole(ApproveFlowDR As %String, Type As %String) As %Query(ROWSPEC = "HIDDEN:%String,HIDDEN:%String,TRole:%String:角色,TAction:%String:动作")
{
}

ClassMethod GetApproveFlowRoleExecute(ByRef qHandle As %Binary, ApproveFlowDR As %String, Type As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i ((ApproveFlowDR="")||(Type="")) Quit $$$OK
	s ApproveSetDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",1)
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveSet",ApproveSetDR,rowid))  q:rowid=""  d
	.d ResetVariablesGetApproveFlowRole
	.q:ApproveFlowDR=rowid
	.s ApproveFlowAllowID=0
	.s Flag=0
	.f  s ApproveFlowAllowID=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",ApproveFlowAllowID))  q:(ApproveFlowAllowID="")  d
	..s TApproveFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",ApproveFlowAllowID)),"^",1)
	..q:(TApproveFlowDR'=ApproveFlowDR)
	..s ApproveFlowAllowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",ApproveFlowAllowID)),"^",2)
	..s TType=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",ApproveFlowAllowID)),"^",3)
	..q:(Type'=TType)
	..i ApproveFlowAllowDR=rowid  d
	...s Flag=1
	.q:Flag=1
	.s TRowID=rowid
	.s TRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",2)
	.i TRoleDR'="" s TRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TRoleDR)),"^",2)
	.s TAction=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",9)						//Add By DJ 2016-04-20
	.i TAction'="" s TAction=$p(^DHCEQCCode("DHCEQCAction",TAction),"^",2)			//Add By DJ 2016-04-20
	.d OutputRowGetApproveFlowRole
	Quit $$$OK
OutputRowGetApproveFlowRole
	s Data=$lb(TRowID,TRoleDR,TRole,TAction)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetApproveFlowRole
	s (TRowID,TRoleDR,TRole,TAction)=""
	quit
}

ClassMethod GetApproveFlowRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApproveFlowRoleExecute ]
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

ClassMethod GetApproveFlowRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApproveFlowRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by GBX 2015-12-21 GBX0037
/// 取得用户能分配的审批角色
/// SourceID:业务ID  CurRoleDR:当前审批角色
/// CurStep:当前步骤  Type：0：审批  1：取消审批
/// d ##class(%ResultSet).RunQuery("web.DHCEQCApproveFlow","GetUserApproves","424","","25","0","","WX_Accept")
Query GetUserApproves(SourceID As %String, CurRoleDR As %String = "", ApproveTypeCode As %String, Type As %String, CurStep As %String = "", Action As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRoleDR:%String,TRole:%String,TStep:%String,TAction:%String,TActionCode:%String")
{
}

ClassMethod GetUserApprovesExecute(ByRef qHandle As %Binary, SourceID As %String, CurRoleDR As %String = "", ApproveTypeCode As %String, Type As %String, CurStep As %String = "", Action As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	i ((ApproveTypeCode="")||(SourceID="")||(CurRoleDR="")||(Type=""))  Quit $$$OK
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType(ApproveTypeCode)
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet(ApproveTypeCode, SourceID)
	//begin add by zx 2017-06-20 BUG ZX0038 可根据动作获取
	s ApproveFlowDR="" 
	i CurStep'="" d
	.s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,CurStep,0))
	i (ApproveFlowDR="")&&(Action'="") d
	.s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code",Action,0))
	.i ActionDR'="" s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionDR,0))
	if Action'="" d
	.s NextApproveFlowDRs=##Class(web.DHCEQ.EM.BUSMMaintRequest).ChangAction(SourceID,Action) //add by WY 2022-9-6取下一步审批设置
	//end add by zx 2017-06-20
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid))  q:rowid=""  d
	.d ResetVariablesGetUserApproves
	.s TRowID=rowid
	.s TApproveFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid)),"^",1)
	.q:(ApproveFlowDR'="")&(TApproveFlowDR'=ApproveFlowDR)
	.s TType=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid)),"^",3)
	.q:(Type'=TType)
	.s TApproveFlowAllowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid)),"^",2)
	.q:(NextApproveFlowDRs'="")&&((","_NextApproveFlowDRs_",")'[(","_TApproveFlowAllowDR_","))  ////add by WY 2022-9-6过滤取下一步审批设置
	.s TRowID=TApproveFlowAllowDR
	.s TRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowAllowDR),"^",2)
	.i TRoleDR'="" s TRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TRoleDR)),"^",2)
	.s TStep=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowAllowDR),"^",3)
	.s TActionDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowAllowDR),"^",9)						//Add By DJ 2016-04-20
	.i TActionDR'="" d
	..s TAction=$p(^DHCEQCCode("DHCEQCAction",TActionDR),"^",2)			//Add By DJ 2016-04-20
	..s TActionCode=$p(^DHCEQCCode("DHCEQCAction",TActionDR),"^",1)
	.s TRole=TRole_","_TAction  //add by wy 2022-9-28 输出角色时增加到动作
	.d OutputRowGetUserApproves
	Quit $$$OK
OutputRowGetUserApproves
	s Data=$lb(TRowID,TRoleDR,TRole,TStep,TAction,TActionCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUserApproves
	s (TRowID,TRoleDR,TRole,TStep,TApproveFlowDR,TType,TApproveFlowAllowDR,TAction,TActionCode,TActionDR)=""
	quit
}

ClassMethod GetUserApprovesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserApprovesExecute ]
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

ClassMethod GetUserApprovesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserApprovesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by zx 2016-03-04  BugZX0035
/// 141^19^25^0^2
/// w ##class(web.DHCEQCApproveFlow).GetApproveFlowType("141","19","25","0","2","WX_Maint")
///  Add by zx 2017-06-21 可根据动作获取审批流类型 BUG ZX0038
ClassMethod GetApproveFlowType(SourceID, CurRoleID, ApporveTypeCode, Type, RoleStep, ActionCode As %String = "")
{
    	//s ^DHCEQZX(1)=SourceID_"^"_CurRoleID_"^"_ApporveTypeCode_"^"_Type_"^"_RoleStep
    	n ApproveType,ApproveSet,ApproveFlowDR,ApproveAllowType
    	s ApproveType=##class(web.DHCEQApproveList).GetApproveType(ApporveTypeCode)
    	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet(ApporveTypeCode,SourceID)
    	s ApproveAllowType=""
    	i ActionCode="" d
    	.s ApproveFlowDR=0
    	.f  s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,CurRoleID,ApproveFlowDR)) q:ApproveFlowDR=""  d
    	..q:$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",3)'=RoleStep
    	..i Type=0 d
    	...s ApproveAllowType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",11)
    	..i Type=1 d
    	...s ApproveAllowType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",13)
    	// add by zx 2017-06-21 begin BUG ZX0038
    	e  d
    	.s ActionID=$o(^DHCEQCCode("DHCEQCAction",0,"Code",ActionCode,0))
    	.i ActionID'="" d
    	..s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionID,0))
    	..q:ApproveFlowDR=""
    	..i Type=0 d
    	...s ApproveAllowType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",11)
    	..i Type=1 d
    	...s ApproveAllowType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",13)
   	// add by zx 2017-06-21 end BUG ZX0038
    
    	q ApproveAllowType
}

/// add by GBX 2015-12-21 GBX0037
/// 取得用户能分配的审批角色
/// SourceID:业务ID  CurRoleDR:当前审批角色
/// CurStep:当前步骤  Type：0：审批  1：取消审批
/// d ##class(%ResultSet).RunQuery("web.DHCEQCApproveFlow","GetUserApprovesForPDA","790","","25","0","","WX_Maint")
Query GetUserApprovesForPDA(SourceID As %String, Role As %String = "", ApproveTypeCode As %String, Type As %String, CurStep As %String = "", Action As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRoleDR:%String,TRole:%String,TStep:%String,TAction:%String,TActionCode:%String")
{
}

ClassMethod GetUserApprovesForPDAExecute(ByRef qHandle As %Binary, SourceID As %String, Role As %String = "", ApproveTypeCode As %String, Type As %String, CurStep As %String = "", Action As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	;modified By qw 20170929 需求号:458987
	i ((ApproveTypeCode="")||(SourceID="")||(Type=""))  Quit $$$OK
	;end By  qw 20170929
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType(ApproveTypeCode)
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet(ApproveTypeCode, SourceID)
	//begin add by zx 2017-06-20 BUG ZX0038 可根据动作获取
	s ApproveFlowDR="" 
	i CurStep'="" d
	.s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,CurStep,0))
	i (ApproveFlowDR="")&&(Action'="") d
	.s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code",Action,0))
	.i ActionDR'="" s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionDR,0))
	//end add by zx 2017-06-20
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid))  q:rowid=""  d
	.d ResetVariablesGetUserApprovesForPDA
	.s TRowID=rowid
	.s TApproveFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid)),"^",1)
	.q:(ApproveFlowDR'="")&(TApproveFlowDR'=ApproveFlowDR)
	.s TType=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid)),"^",3)
	.q:(Type'=TType)
	.s TApproveFlowAllowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",rowid)),"^",2)
	.s TRowID=TApproveFlowAllowDR
	.s TRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowAllowDR),"^",2)
	.i TRoleDR'="" s TRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TRoleDR)),"^",2)
	.s TStep=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowAllowDR),"^",3)
	.s TActionDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowAllowDR),"^",9)						//Add By DJ 2016-04-20
	.i TActionDR'="" d
	..s TAction=$p(^DHCEQCCode("DHCEQCAction",TActionDR),"^",2)			//Add By DJ 2016-04-20
	..s TActionCode=$p(^DHCEQCCode("DHCEQCAction",TActionDR),"^",1)
	.d OutputRowGetUserApprovesForPDA
	Quit $$$OK
OutputRowGetUserApprovesForPDA
	s Data=$lb(TRowID,TRoleDR,TRole,TStep,TAction,TActionCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUserApprovesForPDA
	s (TRowID,TRoleDR,TRole,TStep,TApproveFlowDR,TType,TApproveFlowAllowDR,TAction,TActionCode,TActionDR)=""
	quit
}

ClassMethod GetUserApprovesForPDAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserApprovesExecute ]
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

ClassMethod GetUserApprovesForPDAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserApprovesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// czf 2021-09-01
/// 获取院区限制下拉列表
/// d ##Class(web.DHCEQCApproveFlow).HospLimitList("HsopLimit",130)
ClassMethod HospLimitList(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	w "<option value=></option>"
	w "<option value=0>不限</option>"
	w "<option value=1>本院及医院组总院</option>"
	w "<option value=2>本院</option>"
	w "<option value=3>医院组总院</option>"
	w "</select>",!
}

/// czf 2022-10-12
/// 根据步骤和审批设置获取审批流ID
/// w ##Class(web.DHCEQCApproveFlow).GetAppFlowIDByStep(18,1)
ClassMethod GetAppFlowIDByStep(ApproveSet, Step)
{
	i (ApproveSet="")||(Step="") q ""
    
    q $o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,Step,""))
}

}
