/// 修  改:zy 2010-03-30  No ZY0019
/// 添加类：GetApproveSetDRByAppCondition()
/// 修改类：JudgeApproveSet()
/// ---------------------------
Class web.DHCEQCApproveSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ApproveTypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1>采购申请</option>"
	w "<option value=2>采购计划</option>"
	w "<option value=3>设备论证</option>"
	w "</select>",!
}

/// modified by sjh SJH0040 2020-11-26  增加数据修改日志
/// w ##class(web.DHCEQCApproveSet).UpdateData("^13^设备入库^RK01^^^^^true^^","0","2","3")
ClassMethod UpdateData(Val, Type, gHospId As %Library.String = "", BDPHospId As %Library.String = "")
{
	//Type=0,更新
	//Type＝1，删除
	k PLIST,RowID
	s RowID=$P(Val,"^",1)	
 	s $zt="Error"
 	s TableName="DHC_EQCApproveSet"
 	s ClassName="User.DHCEQCApproveSet"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	s BussID=RowID	
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
 	
 	TSTART
	i +Type=0
	{
		s PLIST(2)=$P(Val,"^",2)
		s PLIST(3)=$P(Val,"^",3)
		s PLIST(4)=$P(Val,"^",4)
		s PLIST(6)=$P(Val,"^",5) // modifie by sjh SJH0042 2020-12-16 BEGIN
		s PLIST(7)=$P(Val,"^",6)
		s PLIST(8)=$P(Val,"^",7)
		s PLIST(9)=$P(Val,"^",8)
		s PLIST(10)=##Class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",9),"bool")
		s PLIST(11)=$P(Val,"^",10) //##Class(web.DHCEQCommon).TransValueFromPage($P(Val,"^",11),"bool")
		s PLIST(5)=$P(Val,"^",11) // modifie by sjh SJH0042 2020-12-16 END
		s PLIST(12)=sHospID			//CZF0131
		
		;判断数据是否重复 CZF0138
		s ApproveTypeDR=$P(Val,"^",2)
		s Code=$P(Val,"^",4)
		s Desc=$P(Val,"^",3)
		s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat("DHC_EQCApproveSet",RowID,Code_"^"_Desc_"^"_ApproveTypeDR,sHospID)
		s Rowid=$p(RtnInfo,"$",1)		//重复Rowid
		s ErrorMsg=$p(RtnInfo,"$",2)
		
		i (Rowid="")
		{
			if RowID=""
			{
				Set BussID="",OperateType="A"
				&SQL(insert into sqluser.DHC_EQCApproveSet values :PLIST())
			}
			else
			{
				Set BussID=RowID,OperateType="U"
				s OldObject=##Class(User.DHCEQCApproveSet).%OpenId(BussID)
				s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
				&SQL(update sqluser.DHC_EQCApproveSet values :PLIST() where AS_RowID=:RowID)
			} 
			If SQLCODE
		 	{
			 	TROLLBACK
			 	q SQLCODE
			}
			s RowID=$g(%ROWID)
		}
		else
		{
			;数据重复
			q ErrorMsg
		}
		;保存医院对照关系 CZF0138 2021-04-20
		s SQLCODE=##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHC_EQCApproveSet",RowID,sHospID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	else
	{
		s OldObject=##Class(User.DHCEQCApproveSet).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(delete from sqluser.DHC_EQCApproveSet where AS_RowID=:RowID)
		
	 	If SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
		}
		
		;删除医院对照关系 CZF0138
		s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).DeleteHospitals("DHC_EQCApproveSet",RowID,sHospID)
		if RtnCode<0
		{
			TROLLBACK
			q RtnCode
		}
		
		;保存数据修改日志
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D",NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
		&SQL(delete from sqluser.DHC_EQCApproveFlow where AF_ApproveSetDR=:RowID)
		i SQLCODE<0 
		{
			TROLLBACK
			q SQLCODE
		}
		TCOMMIT
		q SQLCODE
	}
	
	Set ID=RowID
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCApproveSet).%OpenId(ID))
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
Error
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "Error"_ErrorMsg     //返回错误消息 ;
}

// add by myl 2504345 2022-03-08 增加入参查询

Query GetApproveSet(gHospId As %Library.String = "", BDPHospId As %Library.String = "", ApproveType As %Library.String = "", Desc As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TApproveType:%String,TDesc:%String,TCode:%String,TEquipType:%String,TPurchaseType:%String,TSpecialType:%String,TSingleMinFee:%String,TSingleMaxFee:%String,TAutoAuditFlag:%String,TYearFlag:%String,TApproveTypeDR:%String,TRow:%String")
{
}

ClassMethod GetApproveSetExecute(ByRef qHandle As %Binary, gHospId As %Library.String = "", BDPHospId As %Library.String = "", ApproveType As %Library.String = "", Desc As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)	//CZF0138 20210525
	
	s ApproveTypeDR=0
	f  s ApproveTypeDR=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveTypeDR))  q:ApproveTypeDR=""  d
	.s rowid=0
	.for  s rowid=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveTypeDR,rowid)) quit:rowid=""  d
	..q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCApproveSet",rowid,sHospID)'="Y"	//CZF0138 20210525
	..d ResetVariablesGetApproveSet
	..s TRowID=rowid
	..s TApproveTypeDR=ApproveTypeDR
	..i TApproveTypeDR'="" s TApproveType=$p($g(^DHCEQCCode("DHCEQCApproveType",TApproveTypeDR)),"^",2)
	..q:(TApproveType'[ApproveType)&(ApproveType'="")  // add by myl 2504345 2022-03-08 增加审批类型筛选
	..s TDesc=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",2)
	..q:(TDesc'[Desc)&(Desc'="")  // add by myl 2504345 2022-03-08 增加名称筛选
	..s TCode=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",3)
	..;s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",4)
	..;i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	..s TEquipTypeDRs=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",4) //modified by sjh SJH0042 2020-12-16  begin
	..i TEquipTypeDRs="" s TEquipType=""
	..i TEquipTypeDRs'="" d
	...s TELength=$l(TEquipTypeDRs,",")
	...f i=1:1:TELength  d
	....s TEquipTypeDR=$p(TEquipTypeDRs,",",i)
	....s TEquipTypes=$P(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
	....i i=1 d
	.....s TEquipType=TEquipTypes
	....e  d
	.....s TEquipType=TEquipType_","_TEquipTypes  							//modified by sjh SJH0042 2020-12-16  end
	..s TPurchaseTypeDR=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",5)
	..i TPurchaseTypeDR'="" s TPurchaseType=$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	..s TSpecialTypeDR=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",6)
	..i TSpecialTypeDR'="" s TSpecialType=$p($g(^DHCEQCCode("DHCEQCSpecialType",TSpecialTypeDR)),"^",2)
	..s TSingleMinFee=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",7)
	..s TSingleMaxFee=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",8)
	..s TAutoAuditFlag=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",9)
	..s TAutoAuditFlag=$CASE(TAutoAuditFlag,"Y":"是","N":"否","":"否") ;add by QW 2018-10-08 描述：hisui改造,Y/N改为是/否
	..s TYearFlag=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",10)
	..s TYearFlag=$CASE(TYearFlag,"Y":"是","N":"否","":"否") ;add by QW 2018-10-08 描述：hisui改造,Y/N改为是/否
	..d OutputRowGetApproveSet
	Quit $$$OK
OutputRowGetApproveSet
	s Data=$lb(TRowID,TApproveType,TDesc,TCode,TEquipType,TPurchaseType,TSpecialType,TSingleMinFee,TSingleMaxFee,TAutoAuditFlag,TYearFlag,TApproveTypeDR,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetApproveSet
	s (TRowID,TApproveType,TDesc,TCode,TEquipType,TPurchaseType,TSpecialType,TSingleMinFee,TSingleMaxFee,TAutoAuditFlag,TYearFlag,TApproveTypeDR)=""
	quit
}

ClassMethod GetApproveSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApproveSetExecute ]
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

ClassMethod GetApproveSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApproveSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/*********************************************/
ClassMethod GetOneApproveSet(RowID)
{
	new result,EquipType,PurchaseType,SpecialType,ApproveType
	s (result,EquipType,PurchaseType,SpecialType,ApproveType)=""
	s result=^DHCEQCCode("DHCEQCApproveSet",RowID)
	s EquipTypeDR=$P(result,"^",4)
	;i EquipTypeDR'="" s EquipType=$P(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR),"^",2) //modified by sjh SJH0042 2020-12-16
	s PurchaseTypeDR=$P(result,"^",5)
	i PurchaseTypeDR'="" s PurchaseType=$P(^DHCEQCCode("DHCEQCPurchaseType",PurchaseTypeDR),"^",2)
	s SpecialTypeDR=$P(result,"^",6)
	i SpecialTypeDR'="" s SpecialType=$P(^DHCEQCCode("DHCEQCSpecialType",SpecialTypeDR),"^",2)
	s ApproveTypeDR=$P(result,"^",1)
	i ApproveTypeDR'="" s ApproveType=$P(^DHCEQCCode("DHCEQCApproveType",ApproveTypeDR),"^",2)
	i $P(result,"^",9)="Y" 
	{
		s $P(result,"^",9)="1"
	}
	else
	{
		s $P(result,"^",9)="0"
	}
	/*i $P(result,"^",10)="Y" 
	{
		s $P(result,"^",10)="1"
	}
	else
	{
		s $P(result,"^",10)="0"
	}*/
	q result_"^"_EquipTypeDR_"^"_PurchaseType_"^"_SpecialType_"^"_ApproveType //modified by sjh SJH0042 2020-12-16
}

/// 根据相关信息获取审批设置
/// w ##Class(web.DHCEQCApproveSet).JudgeApproveSet("7","2","1",0,"4300","","")
ClassMethod JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxFee, YearFlag, ApproveCondition As %Library.String = "", gHospId As %Library.String = "")
{
	new presetid,preminnum,minnum,flag
	if (ApproveType="") q ""
	s (approveset,presetid)=""
	s preminnum=""
	///模糊匹配数
	s minnum=0
	
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("",gHospId)
	
	s Arowid=0
	f  s Arowid=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,Arowid))  q:(Arowid="")||(approveset'="")  d
	.;当前登录人是否有权限查看表数据 CZF0138
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCApproveSet",Arowid,sHospID)'="Y"	
	.s minnum=0
	.q:approveset'=""
	.s vEquipType=$p(^DHCEQCCode("DHCEQCApproveSet",Arowid),"^",4)
	.q:(vEquipType'="")&((","_vEquipType_",")'[(","_EquipType_","))			//czf 2021-05-18 1837956
	.i (EquipType'="")&(vEquipType="")  s minnum=minnum+1
	.s vPurchaseType=$p(^DHCEQCCode("DHCEQCApproveSet",Arowid),"^",5)
	.q:(vPurchaseType'="")&(vPurchaseType'=PurchaseType)
	.i (PurchaseType'="")&(vPurchaseType="")  s minnum=minnum+1
	.s vSpecialType=$p(^DHCEQCCode("DHCEQCApproveSet",Arowid),"^",6)
	.q:(vSpecialType'="")&(vSpecialType'=SpecialType)
	.i (SpecialType'="")&(vSpecialType="")  s minnum=minnum+1
	.s vYearFlag=$p(^DHCEQCCode("DHCEQCApproveSet",Arowid),"^",10)
	.q:(vYearFlag'="")&(vYearFlag'=YearFlag)
	.i (YearFlag'="")&(vYearFlag="")  s minnum=minnum+1
	.s minfee=$p(^DHCEQCCode("DHCEQCApproveSet",Arowid),"^",7)
	.q:(MaxFee'="")&(minfee'="")&(minfee>MaxFee)
	.i (minfee="")&(MaxFee'="") s minnum=minnum+1
	.s maxfee=$p(^DHCEQCCode("DHCEQCApproveSet",Arowid),"^",8)
	.q:(MaxFee'="")&(maxfee'="")&(maxfee'>MaxFee)
	.i (maxfee="")&(MaxFee'="") s minnum=minnum+1
	.//Modified by zy 2010-03-30  No ZY0019  begin
	.s flag=0
	.i ApproveCondition'=""  d
	..s flag=..GetApproveSetDRByAppCondition(Arowid,ApproveCondition)
	.q:flag<0
	.s minnum=minnum+flag
	.//Modified by zy 2010-03-30  No ZY0019  end
	.
	.i minnum=0 s approveset=Arowid
	.i (minnum>0)&((preminnum="")||(minnum<preminnum))  d
	..s preminnum=minnum
	..s presetid=Arowid
	i (approveset="")&(preminnum>0) s approveset=presetid
	q approveset
}

/// Description: 获取该单据的下一个审批角色和步骤
/// Param: ApproveSet 审批设置
/// Param: ApproveType 审批类型
/// Param: Source 来源ID
/// Param: CurStep 当前步骤
/// Param: CurRole 当前角色
/// Param: ApproveFlowID 指定步骤ID
/// Author: zouxuan 2018-07-06
/// Return: 是否最后步骤标志_"^"_下一步骤_"^"_下一角色_"^"_下一审批流信息_"^^"_来源审批对应动作_"^"_审批设置ID
/// 将审批设置ID拼接在返回值后面,可替代审批中调生成消息时参数拼接的审批设置ID,避免此方法返回值增加造成消息生成方法报错
/// 定义了相同步骤时,此步骤内的审批只能设置为'默认下一步'
/// w ##class(web.DHCEQCApproveSet).GetNextStep("11","5","98","1","2","")
ClassMethod GetNextStep(ApproveSet, ApproveType, Source, CurStep, CurRole, ApproveFlowID As %Library.String = "", CurUser As %Library.String = "")
{
	n rowid,count,hasflag,lastFlag,FromAction
	n nextStep,nextRole,role,Hold,NextToFlowDR,GotoType,CanRepeatFlag,RepeatUserInfo,RepeatInfo,CurRowID
	s FromAction=""
	
	s rowid=0
	s count=0
	s hasflag=0
	s lastFlag="N"
	s RepeatNum=0
	s (nextStep,nextRole,Hold,GotoType,CanRepeatFlag,RepeatUserInfo,RepeatInfo,CurRowID)=""
	if (CurStep="")  s CurStep=0
	//重复步骤获取
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,CurStep,rowid))  q:(rowid="")||(count>0)||(CanRepeatFlag="Y")  d
	.s CurRowID=rowid
	.s role=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",2)
	.i CurRole=role d
	..s FromAction=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",9)
	.s CanRepeatFlag=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",14)
	.s GotoType=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",11)
	.q:CanRepeatFlag="Y"	//modified by zy 20191115 ZY0195判断在上面影响了GotoType的取值.
	.q:(GotoType=1)||(GotoType=2) //指定步骤和人为指定步骤时不再判断重复步骤
	.s selfFlag=0
	.i CurRole=role d
	..s lastFlag=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",4)
	..s selfFlag=1
	.q:selfFlag=1
	.q:lastFlag="Y"
	.s hasflag=##class(web.DHCEQCApproveSet).HasApprove(ApproveType,Source,CurStep,role)
	.q:hasflag>0
	.s nextStep=CurStep
	.s count=count+1
	.s nextRole=role
	.s Hold=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",7,11)
	i lastFlag="Y" q lastFlag_"^^"
	//可重复步骤
	i CanRepeatFlag="Y" d
	.s RepeatNum=$p(^DHCEQCCode("DHCEQCApproveFlow",CurRowID),"^",16)
	.s RepeatInfo=##class(web.DHCEQCApproveSet).GetRepeatApprove(ApproveSet,Source,CurStep,role,CurUser)
	.s RepeatUserInfo=$p(RepeatInfo,"^",2) //重复步骤已操作人员,用于过滤发消息限定人
	.s lastFlag=$p(^DHCEQCCode("DHCEQCApproveFlow",CurRowID),"^",4)
	.s nextStep=CurStep
	.s nextRole=role
	.s Hold=$p(^DHCEQCCode("DHCEQCApproveFlow",CurRowID),"^",7,11)
	i RepeatNum>+RepeatInfo q lastFlag_"^"_nextStep_"^"_nextRole_"^"_Hold_"^^"_FromAction_"^"_ApproveSet_"^"_RepeatUserInfo
	//指定步骤和人为指定步骤判断
	i count=0 d
	.i (GotoType=1) d
	..;指定步骤
	..s NextToFlowDR=$p(^DHCEQCCode("DHCEQCApproveFlow",CurRowID),"^",12)
	..s nextRole=$p(^DHCEQCCode("DHCEQCApproveFlow",NextToFlowDR),"^",2)
	..s nextStep=$p(^DHCEQCCode("DHCEQCApproveFlow",NextToFlowDR),"^",3)
	..s Hold=$p(^DHCEQCCode("DHCEQCApproveFlow",CurRowID),"^",7,11)
	..s count=count+1
	.e  i (GotoType=2)&&(ApproveFlowID'="")  d    
	..;人为操作指定步骤
	..s nextRole=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowID),"^",2)
	..s nextStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowID),"^",3)
	..s Hold=$p(^DHCEQCCode("DHCEQCApproveFlow",CurRowID),"^",7,11)
	..s count=count+1
	
	//重复步骤时取其中一步,信息缺少时对发消息有影响
	i count>0 q lastFlag_"^"_nextStep_"^"_nextRole_"^"_Hold_"^^"_FromAction_"^"_ApproveSet_"^"_RepeatUserInfo
	;i count>1 q lastFlag_"^"_nextStep_"^"
	//默认下一步获取
	s nextStep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,CurStep))
	i nextStep="" q "^^"
	s count=0
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,nextStep,rowid))  q:(rowid="")||(count>0)  d
	.s nextRole=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",2)
	.s Hold=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",7,11)
	.s count=count+1
	//重复步骤时取其中一步,信息缺少时对发消息有影响
	i count>0 q lastFlag_"^"_nextStep_"^"_nextRole_"^"_Hold_"^^"_FromAction_"^"_ApproveSet_"^"_RepeatUserInfo
	;i count>1 q lastFlag_"^"_nextStep_"^"

	quit
}

/// 判断该角色是否已经在该单中是否已经审批
/// 结果返回：0未审批 大于0已经审批返回的是审批ID
ClassMethod HasApprove(ApproveType, Source, CurStep, Role)
{
	new approvelistid
	s approvelistid=0
	s ID=0
	s hasFlag=0
	f  s approvelistid=$o(^DHCEQApproveList(0,"Step",ApproveType,Source,CurStep,approvelistid))  q:approvelistid=""  d
	.s ALInvalidFlag=$p($g(^DHCEQApproveList(approvelistid)),"^",10)
	.q:ALInvalidFlag="Y"
	.q:hasFlag=1
	.i Role=$p(^DHCEQApproveList(approvelistid),"^",5) d
	..s hasFlag=1
	..s ID=approvelistid
	q ID
}

/// @Description 南方医院组长审核与科室审核不分先后操作处理
/// @Param ApproveType:审批设置id
/// @param Source:业务单据id
/// @Author zouxuan 2018-05-15
/// @Return 0:不存在 其他:未操作必要步骤ID
/// w ##Class(web.DHCEQCApproveSet).CheckMustStep(25,37,9)
ClassMethod CheckMustStep(ApproveType, ApproveSet, Source)
{
	n Result,FlowDR,UnMustFlag,CurStep
	s Result=0
	s FlowDR=0
	f  s FlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveSet",ApproveSet,FlowDR)) q:(FlowDR="")||(Result'=0)  d
	.s UnMustFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",FlowDR)),"^",10)
	.q:UnMustFlag'="N"
	.s CurStep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",FlowDR)),"^",3)
	.q:$d(^DHCEQApproveList(0,"Step",ApproveType,Source,CurStep))'=0
	.s Result=FlowDR
	
	q Result
}

/// 获取审批设置的工作流串
/// 返回值格式：step1,role1,roledesc1^step2,role2,roledesc2^....
/// w ##Class(web.DHCEQCApproveSet).GetApproveFlow(37)
ClassMethod GetApproveFlow(ApproveSet)
{
	i ApproveSet="" q ""
	s workflows=""
	s rowid=0
	s step=0
	f  s step=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,step))  q:step=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,step,rowid))  q:rowid=""  d
	..s role=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",2)
    ..s defaultopinion=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",21)	//czf 2022-10-12
	..s ApproveButtonName=$p(^DHCEQCCode("DHCEQCApproveRole",role),"^",2)		//Add By DJ 2016-04-20 begin
	..s ApproveTypeDR=$p($g(^DHCEQCCode("DHCEQCApproveSet",ApproveSet)),"^",1)
	..s ApproveTypeCode=$p($g(^DHCEQCCode("DHCEQCApproveType",ApproveTypeDR)),"^",1)
	..i ApproveTypeCode="25"  d
	...s ActionDR=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",9)
	...s ApproveButtonName=$p(^DHCEQCCode("DHCEQCAction",ActionDR),"^",2)
    ..s workflows=workflows_"^"_step_","_role_","_ApproveButtonName_","_rowid_","_defaultopinion   //Add By DJ 2016-04-20 end
	i workflows'="" s workflows=$e(workflows,2,$l(workflows))
	q workflows
}

/// add by zx 2016-03-10 增加动作判断 Bug ZX0045
/// w ##class(web.DHCEQCApproveSet).GetStepByRole("37","139","WX_Accept")
ClassMethod GetStepByRole(ApproveSet, Role As %String = "", Action As %String = "")
{
	new Flow,Step,FlowActionID
	s FlowAction=""
	s Step=0
	i ApproveSet="" q Step
	i (Role="")&&(Action="") q Step
	
	i Role'="" d
	.s Flow=0
	.f  s Flow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,Role,Flow)) q:Flow=""  d
	..s FlowActionID=$p(^DHCEQCCode("DHCEQCApproveFlow",Flow),"^",9)
	..q:(Action'="")&&(Action'=($p($g(^DHCEQCCode("DHCEQCAction",FlowActionID)),"^",1)))
	..s Step=$p(^DHCEQCCode("DHCEQCApproveFlow",Flow),"^",3)
	e  d
	.s ActionID=$o(^DHCEQCCode("DHCEQCAction",0,"Code",Action,0))
	.s Flow=0
	.f  s Flow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionID,Flow)) q:(Flow="")||(Step'=0)  d
	..s Step=$p(^DHCEQCCode("DHCEQCApproveFlow",Flow),"^",3)
	
	q Step
}

/*
/// ----------------------------------
/// 新建:zy 2010-03-30  No ZY0019
/// 描述:审批附加条件判断
/// 入参：ApproveSet审批设置ID
/// 	  apprCondition：条件字段信息 格式： FieldName1_","_TableName1_","_FieldValue1..."^"...FieldNameN_","_TableNameN_","_FieldValueN
/// 返回值：
/// w ##Class(web.DHCEQCApproveSet).GetApproveSetDRByAppCondition(29,"MoveType,DHC_EQStoreMove,3")
ClassMethod GetApproveSetDRByAppCondition(ApproveSet, apprCondition)
{
	new (ApproveSet,apprCondition)
	i ApproveSet="" q ""
	i apprCondition="" q ""
	s Length=$L(apprCondition,"^")
	for i=1:1:Length d
	.s Condition=$P(apprCondition,"^",i)
	.s Name=$P(Condition,",",1)
	.s TableName=$P(Condition,",",2)
	.s Value=$P(Condition,",",3)
	.s rowid=0
	.s Count=0 //未满足条件个数
	.s Sum=0 //总数
	.f  s rowid=$o(^DHCEQCCode("DHCEQCApproveCondition",0,"ApproveSet",ApproveSet,rowid)) q:(rowid="")||(Count<Sum)  d
	..s Sum=Sum+1
	..s CFRowID=$p(^DHCEQCCode("DHCEQCApproveCondition",rowid),"^",2)
	..s vValue=$p(^DHCEQCCode("DHCEQCApproveCondition",rowid),"^",3)
	..s vToValue=$p(^DHCEQCCode("DHCEQCApproveCondition",rowid),"^",4)
	..s Tag=0
	..i CFRowID'=""  d
	...s vName=$p(^DHCEQCCode("DHCEQCConditionFields",CFRowID),"^",1)
	...s vTableName=$p(^DHCEQCCode("DHCEQCConditionFields",CFRowID),"^",2)
	...s vType=$p(^DHCEQCCode("DHCEQCConditionFields",CFRowID),"^",3)
	..i (vName'=Name)||(vTableName'=TableName) s Tag=1
	..i (vType="0")&&(Value'="")&&(vValue'=Value) s Tag=1
	..i (vType="1")&&(Value'="")&&((Value<vValue)||(Value>vToValue)) s Tag=1
	..s Count=Count+Tag
	.i Count=Sum s i=Length+1
	i i<=Length q ApproveSet
	q ""
}
*/
/// ----------------------------------
/// 新建:zy 2010-03-30  No ZY0019
/// 描述:审批附加条件判断
/// 入参：ApproveSet审批设置ID
/// 	  apprCondition：条件字段信息 格式： FieldName1_","_TableName1_","_FieldValue1..."^"...FieldNameN_","_TableNameN_","_FieldValueN
/// 返回值：不匹配则返回-1，匹配则返回模糊匹配数
/// w ##Class(web.DHCEQCApproveSet).GetApproveSetDRByAppCondition(29,"MoveType,DHC_EQStoreMove,3")
ClassMethod GetApproveSetDRByAppCondition(ApproveSet, apprCondition)
{
	new (ApproveSet,apprCondition)
	
	i ApproveSet="" q "-1"
	i apprCondition="" q "-1"
	;不匹配标志
	s unmatch=0
	s minnum=0
	s Length=$L(apprCondition,"^")
	for i=1:1:Length d
	.s Condition=$P(apprCondition,"^",i)
	.s Name=$ZConvert($P(Condition,",",1),"U")
	.s TableName=$ZConvert($P(Condition,",",2),"U")
	.s Value=$P(Condition,",",3)
	.s FieldID=$o(^DHCEQCCode("DHCEQCConditionFields",0,"Name",TableName,Name,0))
	.q:FieldID=""
	.s vType=$p(^DHCEQCCode("DHCEQCConditionFields",FieldID),"^",3)
	.s ConditionID=$o(^DHCEQCCode("DHCEQCApproveCondition",0,"ApproveSet",ApproveSet,FieldID,0))
	.i ConditionID="" s minnum=minnum+1
	.q:ConditionID=""
	.s vValue=$p(^DHCEQCCode("DHCEQCApproveCondition",ConditionID),"^",3)
	.s vToValue=$p(^DHCEQCCode("DHCEQCApproveCondition",ConditionID),"^",4)
	.i (vType="0")  d
	..i (vValue'="")&&(vValue'=Value) d
	...s unmatch=1
	..e  d
	...i ((vValue="")&&(Value'="")) s minnum=minnum+1
	.else  if (vType="1")  d
	..i ((vValue'="")&&(Value<vValue))||((vToValue'="")&&(Value>vToValue))  d
	...s unmatch=1
	..e  d
	...i ((vValue="")&&(vToValue="")&&(Value'="")) s minnum=minnum+1
	.;不匹配则退出循环,返回-1
	.i unmatch=1  d
	..s minnum="-1"
	..s i=Length+1
	q minnum
}

/// add by zy 20160218 
/// 生成消息的时候,取下面审批步骤中可以接收这个消息的角色id.包含中断处理
/// w ##class(web.DHCEQCApproveSet).GetCanReceiveRoleIDs("11","14")
/// add by zx 2018-07-23 增加同步骤多角色处理
ClassMethod GetCanReceiveRoleIDs(ApproveSet, RoleStep As %String = "", SourceID As %String = "")
{
	new rowid,ChangeTypeFlag,NextRole,NextAction,ReceiveInfo,RoleIDs,Actions
	s (ChangeTypeFlag,NextRole,NextAction,ReceiveInfo,RoleIDs,Actions)=""
	s Flag=0
	i (RoleStep="")||(SourceID="") q Flag_"^" //取消提交到新增状态时,返回空
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,RoleStep,rowid))  q:rowid=""  d
	.s ChangeTypeFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",15)
	.i ChangeTypeFlag="Y"  d
	..s AllowFlowID=0
	..f  s AllowFlowID=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",0,"SourceFlow","2",rowid,AllowFlowID))  q:AllowFlowID=""  d
	...s AllowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",AllowFlowID),"^",3)
	...s NextRole=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AllowFlowID)),"^",2)
	...s NextAction=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AllowFlowID)),"^",9)
	...s Flag=1
	...i ReceiveInfo="" d
	....s RoleIDs=NextRole
	....s ReceiveInfo=NextRole_"@"_NextAction
	...e  d
	....s RoleIDs=RoleIDs_","_NextRole
	....s ReceiveInfo=ReceiveInfo_","_NextRole_"@"_NextAction
	
	s rowid=0
	s ApproveType=$p($g(^DHCEQCCode("DHCEQCApproveSet",ApproveSet)),"^",1)
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,RoleStep,rowid))  q:rowid=""  d
	.s ApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",2)
	.s ApproveListID=0
	.s NextFlag=0
	.f  s ApproveListID=$o(^DHCEQApproveList(0,"ApproveRole",ApproveType,SourceID,ApproveRole,ApproveListID)) q:(ApproveListID="")||(NextFlag=1)  d
	..q:$p($g(^DHCEQApproveList(ApproveListID)),"^",10)="Y"
	..s CurStep=$p($g(^DHCEQApproveList(ApproveListID)),"^",9)
	..i RoleStep=CurStep s NextFlag=1
	.q:NextFlag=1
	.s Flag=1
	.s Action=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",9)
	.i ReceiveInfo="" d
	..s RoleIDs=ApproveRole
	..s ReceiveInfo=ApproveRole_"@"_Action
	.e  d
	..i ReceiveInfo'[("@"_Action) d
	...s RoleIDs=RoleIDs_","_ApproveRole
	...s ReceiveInfo=ReceiveInfo_","_ApproveRole_"@"_Action
	
	q Flag_"^"_RoleIDs_"^"_ReceiveInfo
}

/// add by zx 2017-05-17 用动作取角色和步骤 BUG ZX0045
/// w ##class(web.DHCEQCApproveSet).GetRoleByAction("37","WX_Maint")
ClassMethod GetRoleByAction(ApproveSet, Action As %String = "")
{
    new ApproveFlowID,Role,Step,ActionID
    
    s Step=0
    i (ApproveSet="")||(Action="") q "^"
    s ActionID=$o(^DHCEQCCode("DHCEQCAction",0,"Code",Action,0))
    s ApproveFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionID,0))
    i ApproveFlowID="" q "^"
    s Role=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowID)),"^",2)
    s Step=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowID),"^",3)
    //MODIFY by mwz 2021-06-02 MWZ0050
    q Role_"^"_Step_"^"_ApproveFlowID
}

/// Description:获取该单据的下一个审批角色和步骤
/// Param: ApproveSet 审批设置
/// Param: SourceID 业务ID
/// Param: RoleStep 当前步骤
/// Author:zouxuan 2018-07-09
/// Return:ResultFlag 1表示存在同一步多角色、0表示不存在;ResultRoles 未审批的角色串;ResultReceive 发消息需要的角色串和动作串
/// 相同步骤时消息发送给未操作过的角色
/// w ##class(web.DHCEQCApproveSet).CheckSameStepRoleIDs("11","100","2")
ClassMethod CheckSameStepRoleIDs(ApproveSet, SourceID, RoleStep)
{
	i RoleStep="" q 0
	s ResultFlag=0
	s (ResultRoles,ResultReceive,Action)=""
	s rowid=0
	s ApproveType=$p($g(^DHCEQCCode("DHCEQCApproveSet",ApproveSet)),"^",1)
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,RoleStep,rowid))  q:rowid=""  d
	.s ApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",2)
	.s ApproveListID=0
	.s NextFlag=0
	.f  s ApproveListID=$o(^DHCEQApproveList(0,"ApproveRole",ApproveType,SourceID,ApproveRole,ApproveListID)) q:(ApproveListID="")||(NextFlag=1)  d
	..q:$p($g(^DHCEQApproveList(ApproveListID)),"^",10)="Y"
	..s CurStep=$p($g(^DHCEQApproveList(ApproveListID)),"^",9)
	..i RoleStep=CurStep s NextFlag=1
	.q:NextFlag=1
	.s ResultFlag=1
	.s Action=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",9)
	.i ResultReceive="" d
	..s ResultRoles=ApproveRole
	..s ResultReceive=ApproveRole_"@"_Action
	.e  d
	..s ResultRoles=ResultRoles_","_ApproveRole
	..s ResultReceive=ResultReceive_","_ApproveRole_"@"_Action
	
	q ResultFlag_"^"_ResultRoles_"^"_ResultReceive
}

/// Description:获取该单据的下一个审批角色和步骤
/// Param: ApproveSet 审批设置
/// Param: SourceID 业务ID
/// Param: RoleStep 当前步骤
/// Param: Role 当前角色
/// Author:zouxuan 2018-07-10
/// Return:TotalNum 重复已执行次数;ApproveUsers 已执行用户ID串
/// 同一步骤重复操作
/// w ##class(web.DHCEQCApproveSet).GetRepeatApprove("","","")
ClassMethod GetRepeatApprove(ApproveSet, SourceID, RoleStep, Role, CurUser)
{
	s TotalNum=1  //当前操作步骤
	s ApproveUsers=CurUser
	s ApproveType=$p($g(^DHCEQCCode("DHCEQCApproveSet",ApproveSet)),"^",1)
	s ApproveListID=0
	f  s ApproveListID=$o(^DHCEQApproveList(0,"ApproveRole",ApproveType,SourceID,Role,ApproveListID)) q:ApproveListID=""  d
	.q:$p($g(^DHCEQApproveList(ApproveListID)),"^",10)="Y"
	.q:$p($g(^DHCEQApproveList(ApproveListID)),"^",9)'=RoleStep
	.s TotalNum=TotalNum+1
	.s ApproveUser=$p($g(^DHCEQApproveList(ApproveListID)),"^",6)
	.i ApproveUsers'="" s ApproveUsers=ApproveUsers_","
	.s ApproveUsers=ApproveUsers_ApproveUser
	
	q TotalNum_"^"_ApproveUsers
}

/// modified by ZY 20220928 修改global
/// 20190326 Mozy0222
/// w ##Class(web.DHCEQCApproveSet).GetBussApproveFlow(21, 31)
ClassMethod GetBussApproveFlow(Buss, Id, EquipType As %String = "")
{
	;s ^DHCEQMozy("GetBussApproveFlow")=Buss_","_ Id
	i (Buss="")||(Id="") q ""
	Set ApproveType=##class(web.DHCEQMessages).GetApproveTypeByBussType(Buss)
	;Set ApproveType=##class(web.DHCEQApproveList).GetApproveType(Code)
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", "", "")
	If ApproveSet="" Quit -4007
	
	s rsult=$p($g(^DHCEQCCode("DHCEQCApproveSet",ApproveSet)),"^",2)_"^1"
	s rsult="申请^1"
	s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,1,""))
	i rowid="" q rsult
	
	i $d(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet))
	{
		;通过动作配置流获取审批流信息
		
		;设置步骤临时节点
		s job=$job
		k ^TempDHCEQ("GetBussApproveFlow",job)
		
		s ActionID=""
		f  s ActionID=$o(^DHCEQCCode("DHCEQCAction",0,"SourceType",ApproveType,ActionID)) q:ActionID=""  d
		.q:$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",5)'="N"
		.i $p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",3)="" d
		..s ^TempDHCEQ("GetBussApproveFlow",job,ActionID)=ActionID
		.e  d
		..s ^TempDHCEQ("GetBussApproveFlow",job,$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",3))=ActionID
		 
		s Step=""
		f  s Step=$o(^TempDHCEQ("GetBussApproveFlow",job,Step)) q:Step=""  d
		.s ActionID=$g(^TempDHCEQ("GetBussApproveFlow",job,Step))
		.s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionID,""))
		.q:rowid=""
		.d SetApproveFlowInfo
		k ^TempDHCEQ("GetBussApproveFlow",job)
	}
	else
	{
		s Step=""
		f  s Step=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,Step)) quit:Step=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,Step,rowid)) quit:rowid=""  d
		..d SetApproveFlowInfo
	}
	
	;s rsult= "申请^1&派单^0&受理^1&维修^1&配件确认^0&完成^1&组长审核^1&科室确认^1"
	;s rsult= "验收申请^1&物资审核^1&主任审核^1"
	q rsult
	
SetApproveFlowInfo
	s TApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",2)
	i TApproveRoleDR'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	i rsult'="" s rsult=rsult_"&"
	s THold3=+$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",9)
	i THold3>0 d
	.s rsult=rsult_$p($g(^DHCEQCCode("DHCEQCAction",THold3)),"^",2)
	e  d
	.s rsult=rsult_TApproveRole
	s TUnMustFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",10)
	s TUnMustFlag=$CASE(TUnMustFlag,"Y":"0","N":"1","":"1")
	
	;s TChangeTypeFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",15)
	;s TChangeTypeFlag=$CASE(TChangeTypeFlag,"Y":"0","N":"1","":"1")
	
	s rsult=rsult_"^"_TUnMustFlag
	q
}

/// add by sjh SJH0042 2020-12-16 类组下拉框
ClassMethod EquipTypeList(name, width As %String = "") As %String
{
	if (width="")||(width=0) s width=155
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;'>"
	w "</select>",!
}

}
