Class web.DHCEQPrescription Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s SQLCODE=0
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		&SQL(Delete From sqluser.DHC_EQPrescription where P_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s SourceTypeDR=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s HospitalDR=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s EquipTypeDR=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s ActionDR=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s PLIST(7)=$p(val,"^",7)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)
	s Find=""
	i ((HospitalDR'="")&&(EquipTypeDR'=""))  d
	.&SQL(Select P_RowID Into :Find From SQLUSER.DHC_EQPrescription Where P_SourceType=:SourceTypeDR and P_Action=:ActionDR and P_HospitalDR=:HospitalDR and P_EquipTypeDR=:EquipTypeDR)
	e  d
	.i HospitalDR'=""  d
	..&SQL(Select P_RowID Into :Find From SQLUSER.DHC_EQPrescription Where P_SourceType=:SourceTypeDR and P_Action=:ActionDR and P_HospitalDR=:HospitalDR)
	.i EquipTypeDR'=""  d
	..&SQL(Select P_RowID Into :Find From SQLUSER.DHC_EQPrescription Where P_SourceType=:SourceTypeDR and P_Action=:ActionDR and P_EquipTypeDR=:EquipTypeDR)
	.i ((HospitalDR="")&&(EquipTypeDR=""))  d
	..&SQL(Select P_RowID Into :Find From SQLUSER.DHC_EQPrescription Where P_SourceType=:SourceTypeDR and P_Action=:ActionDR)
	
	i (Find'="")	//重复记录判断
	{
		i ((rowid="")||(Find'=rowid)) q -1001
	}
	
	if rowid=""
	{
		&SQL(Insert Into sqluser.DHC_EQPrescription Values :PLIST())
		i SQLCODE q SQLCODE
		s ID=$G(%ROWID)
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQPrescription Values :PLIST() where P_RowID = :rowid)
		i SQLCODE q SQLCODE
		s ID=rowid
	}
	
	q ID
}

Query Prescription(SourceTypeDR As %String = "", HospitalDR As %String = "", EquipTypeDR As %String = "", ActionDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,THospital:%String,TEquipType:%String,TAction:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TSourceTypeDR:%String,TRow:%String")
{
}

ClassMethod PrescriptionExecute(ByRef qHandle As %Binary, SourceTypeDR As %String = "", HospitalDR As %String = "", EquipTypeDR As %String = "", ActionDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s PRowID=0
	f  s PRowID=$o(^DHCEQPrescription(PRowID)) quit:PRowID=""  d
	.d ResetVariablesGetPrescription
	.s TRowID=PRowID
	.s TSourceTypeDR=$p($g(^DHCEQPrescription(TRowID)),"^",1)
	.q:(SourceTypeDR'="")&&(TSourceTypeDR'=SourceTypeDR)
	.s THospitalDR=$p($g(^DHCEQPrescription(TRowID)),"^",2)
	.q:(HospitalDR'="")&&(THospitalDR'=HospitalDR)
	.s TEquipTypeDR=$p($g(^DHCEQPrescription(TRowID)),"^",3)
	.q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	.s TActionDR=$p($g(^DHCEQPrescription(TRowID)),"^",4)
	.q:(ActionDR'="")&&(TActionDR'=ActionDR)
	.i TSourceTypeDR'="" s TSourceType=$p($g(^DHCEQCCode("DHCEQCApproveType",TSourceTypeDR)),"^",2)
	.i THospitalDR'="" s THospital=$p($g(^CT("HOSP",THospitalDR)),"^",2)
	.i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.i TActionDR'="" s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
	.i TActionDR="0" s TAction="提交"
	.s THold1=$p($g(^DHCEQPrescription(TRowID)),"^",5)
	.s THold2=$p($g(^DHCEQPrescription(TRowID)),"^",6)
	.s THold3=$p($g(^DHCEQPrescription(TRowID)),"^",7)
	.s THold4=$p($g(^DHCEQPrescription(TRowID)),"^",8)
	.s THold5=$p($g(^DHCEQPrescription(TRowID)),"^",9)
	.d OutputRowGetPrescription
	Quit $$$OK
OutputRowGetPrescription
	s Data=$lb(TRowID,TSourceType,THospital,TEquipType,TAction,THold1,THold2,THold3,THold4,THold5,TSourceTypeDR,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetPrescription
	s (TRowID,TSourceType,THospital,TEquipType,TAction,THold1,THold2,THold3,THold4,THold5,TSourceTypeDR)=""
	quit
}

ClassMethod PrescriptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrescriptionExecute ]
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

ClassMethod PrescriptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrescriptionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetPrescriptionByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQPrescription(rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveType",$p(result,"^",1))),"^",2) //业务类型
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^CT("HOSP",$p(result,"^",2))),"^",2) //医院
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",3))),"^",2) //类组
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.i $p(result,"^",4)="0"  d
	..s resultex=resultex_"提交"
	.e  d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAction",$p(result,"^",4))),"^",2) //动作
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_"^"_resultex
}

/// Add By DJ 2016-12-22
/// 描述:获取各业务已提交未审核完成单据时效清单
/// 预警，超期以超期计算，相同则显示日期最近
/// d ##class(%ResultSet).RunQuery("web.DHCEQPrescription","GetBussPrcSum","25","","","85","","1")
Query GetBussPrcSum(vBussType As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", FindClass As %String = "", CurUserDR As %String = "", IsOperFlag As %String = "") As %Query(ROWSPEC = "TBussType:%String,TAlertNum:%String,TExpiorNum:%String,TBussCode:%String")
{
}

ClassMethod GetBussPrcSumExecute(ByRef qHandle As %Binary, vBussType As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", FindClass As %String = "", CurUserDR As %String = "", IsOperFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s ApproveTypeDR=0
	f  s ApproveTypeDR=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR))  q:ApproveTypeDR=""  d
	.q:(vBussType'="")&&(ApproveTypeDR'=##Class(web.DHCEQApproveList).GetApproveType(vBussType))
	.d ResetVariablesGetBussPrcSum
	.s TBussType=$p($g(^DHCEQCCode("DHCEQCApproveType",ApproveTypeDR)),"^",2)
	.s TBussCode=$p($g(^DHCEQCCode("DHCEQCApproveType",ApproveTypeDR)),"^",1)
	.s TAlertNum=0
	.s TExpiorNum=0
	.s ALSourceID=0
	.f  s ALSourceID=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR,ALSourceID))  q:ALSourceID=""  d
	..s CheckReturnFlag=..CheckReturnFlag(ApproveTypeDR,ALSourceID,QXType,CurLocDR,CurGroupDR,FindClass,CurUserDR,IsOperFlag)		//检测单据是否有效以及新增，审核状态
	..q:CheckReturnFlag=1
	..s PrescriptionInfo=..GetPrescriptionInfo(ApproveTypeDR,ALSourceID,IsOperFlag)
	..i +PrescriptionInfo=1  d
	...s TAlertNum=TAlertNum+1
	..else  if +PrescriptionInfo=2  d
	...s TExpiorNum=1+TExpiorNum
	.d OutputRowGetBussPrcSum
	
	Quit $$$OK
OutputRowGetBussPrcSum
	s Data=$lb(TBussType,TAlertNum,TExpiorNum,TBussCode)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBussPrcSum
	s (TBussType,TAlertNum,TExpiorNum,TBussCode)=""
	quit
}

ClassMethod GetBussPrcSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussPrcSumExecute ]
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

ClassMethod GetBussPrcSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussPrcSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQPrescription","GetBussPrcDetail","25")
Query GetBussPrcDetail(vBussType As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", FindClass As %String = "", CurUserDR As %String = "", IsOperFlag As %String = "") As %Query(ROWSPEC = "TBussNo:%String,TEquip:%String,TWaringFlag:%String,TWaringInfo:%String,TFromAction:%String,TToAction:%String,TFromDate:%String,TFromTime:%String,TFromUser:%String,TBussRowID:%String,TFileNo:%String,TModel:%String,TEquipNo:%String,TUseLoc:%String,TLastOperate:%String")
{
}

ClassMethod GetBussPrcDetailExecute(ByRef qHandle As %Binary, vBussType As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", FindClass As %String = "", CurUserDR As %String = "", IsOperFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s ApproveTypeDR=0
	f  s ApproveTypeDR=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR))  q:ApproveTypeDR=""  d
	.q:(vBussType'="")&&(ApproveTypeDR'=##Class(web.DHCEQApproveList).GetApproveType(vBussType))
	.s ALSourceID=0
	.f  s ALSourceID=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR,ALSourceID))  q:ALSourceID=""  d
	..d ResetVariablesGetBussPrcDetail
	..s CheckReturnFlag=..CheckReturnFlag(ApproveTypeDR,ALSourceID,QXType,CurLocDR,CurGroupDR,FindClass,CurUserDR,IsOperFlag)		//检测单据是否有效以及新增，审核状态
	..q:CheckReturnFlag=1
	..s PrescriptionInfo=..GetPrescriptionInfo(ApproveTypeDR,ALSourceID,IsOperFlag)
	..q:+PrescriptionInfo<=0
	..s BussInfo=""
	..s MsgTypeCode=##Class(web.DHCEQMessages).GetMsgTypeByApproveType(ApproveTypeDR)
	..q:MsgTypeCode=""
	..s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(MsgTypeCode,ALSourceID)
	..s TBussNo=$p(BussInfo,"^",1)
	..s TEquip=$p(BussInfo,"^",2)
	..s TEquipNo=$p(BussInfo,"^",23)
	..s TFileNo=$p(BussInfo,"^",24)
	..s TModel=$p(BussInfo,"^",25)
	..s TLastOperate=$p(BussInfo,"^",21)
	..s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",5))
	..s TBussRowID=ALSourceID
	..s TWaringFlag=+PrescriptionInfo
	..s TFromDate=##Class(web.DHCEQCommon).TransValueToPage($p(PrescriptionInfo,"^",4),"date")
	..s TFromTime=##Class(web.DHCEQCommon).TransValueToPage($p(PrescriptionInfo,"^",5),"time")
	..s TFromUser=$p(PrescriptionInfo,"^",6)
	..s TWaringInfo=$p($p(PrescriptionInfo,"^",3),",",2)
	..s PLRowID=$p(PrescriptionInfo,"^",2)
	..i PLRowID'=""  d
	...s PRowID=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",1)
	...s TFromActionDR=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",2)
	...s TToAction=$p($g(^DHCEQPrescription(PRowID)),"^",4)
	..e  d
	...s TFromActionDR=$p(PrescriptionInfo,"^",7)
	...s TToAction=$p(PrescriptionInfo,"^",8)
	..i +TFromActionDR'=0  d
	...s TFromAction=$p($g(^DHCEQCCode("DHCEQCAction",TFromActionDR)),"^",2)
	..e  d
	...s TFromAction="提交"
	..i TToAction'="" s TToAction=$p($g(^DHCEQCCode("DHCEQCAction",TToAction)),"^",2)
	..d OutputRowGetBussPrcDetail
	
	Quit $$$OK
OutputRowGetBussPrcDetail
	s Data=$lb(TBussNo,TEquip,TWaringFlag,TWaringInfo,TFromAction,TToAction,TFromDate,TFromTime,TFromUser,TBussRowID,TFileNo,TModel,TEquipNo,TUseLoc,TLastOperate)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBussPrcDetail
	s (TBussNo,TEquip,TWaringFlag,TWaringInfo,TFromAction,TToAction,TFromDate,TFromTime,TFromUser,TBussRowID,TFileNo,TModel,TEquipNo,TUseLoc,TLastOperate)=""
	quit
}

ClassMethod GetBussPrcDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussPrcDetailExecute ]
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

ClassMethod GetBussPrcDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussPrcDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CheckReturnFlag(vBussType As %String = "", vBussRowID As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", FindClass As %String = "", CurUserDR As %String = "", IsOperFlag As %String = "")
{
	n ReturnFlag,BStatus,BInvalidFlag
	s ReturnFlag=0
	i vBussType="25"
	{
		s BStatus=$p($g(^DHCEQMMaintRequest(vBussRowID)),"^",41)
		s BEquipTypeDR=$p($g(^DHCEQMMaintRequest(vBussRowID)),"^",3)
		s BInvalidFlag=$p($g(^DHCEQMMaintRequest(vBussRowID)),"^",57)
		i BInvalidFlag="Y" s ReturnFlag=1
		i ((IsOperFlag="")&&(BStatus'=1)) s ReturnFlag=1
		i ##Class(web.DHCEQCommon).EquipTypeIsIn(BEquipTypeDR,CurGroupDR)=1 s ReturnFlag=1
		s MsgTypeCode=##Class(web.DHCEQMessages).GetMsgTypeByApproveType(vBussType)
		i MsgTypeCode="" q 1
		;FindClass查看级别  0:查看全部  1:维修组长  2:个人
		i FindClass'=0  d
		.s MsgRowID=$o(^DHCEQMessages(0,"MessageType",1,MsgTypeCode,vBussRowID,""),-1)		//最后一次消息
		.i MsgRowID=""	s ReturnFlag=1
		.q:ReturnFlag=1
		.s MRIFind=0
		.s MRIRowID=0
		.f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"Message",MsgRowID,MRIRowID))  q:(MRIRowID="")||(MRIFind'=0)  d
		..s MRIReceiveUserDR=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",2)
		..i MRIReceiveUserDR=CurUserDR s MRIFind=1		//用户级别
		..q:MRIFind'=0
		..s MGRowID=0
		..f  s MGRowID=$o(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",1,CurUserDR,MGRowID))  q:(MGRowID="")||(MRIFind'=0)  d
		...s MGInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)
		...q:MGInvalidFlag="Y"
		...s MGLRowID=0
		...f  s MGLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",MGRowID,MGLRowID))  q:(MGLRowID="")||(MRIFind'=0)  d
		....s MGLInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",6)
		....q:MGLInvalidFlag="Y"
		....s MGLMemberDR=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",2)
		....i MGLMemberDR=MRIReceiveUserDR s MRIFind=1
		.i MRIFind=0 s ReturnFlag=1
	}
	q ReturnFlag
}

ClassMethod CheckApproveAction(vApproveTypeDR As %String = "", vBussRowID As %String = "", vAction As %String = "")
{
	n ALRowID,ALInvalidFlag,ALAction,ALFind
	s ALFind=0
	s ALRowID=0
	f  s ALRowID=$o(^DHCEQApproveList(0,"Source",vApproveTypeDR,vBussRowID,ALRowID))  q:(ALRowID="")||(ALFind'=0)  d
	.s ALInvalidFlag=$p($g(^DHCEQApproveList(ALRowID)),"^",10)
	.q:ALInvalidFlag="Y"
	.s ALAction=$p($g(^DHCEQApproveList(ALRowID)),"^",11)
	.q:ALAction'=vAction
	.s ALFind=ALRowID
	q ALFind
}

/// w ##Class(web.DHCEQPrescription).GetPrescriptionInfo("25","427")
ClassMethod GetPrescriptionInfo(ApproveTypeDR As %String = "", ALSourceID As %String = "", IsOperFlag As %String = "")
{
	s PReturnFlag=""
	s ALFind=0
	s ALRowID=""
	f  s ALRowID=$o(^DHCEQApproveList(0,"Source",ApproveTypeDR,ALSourceID,ALRowID),-1)  q:(ALRowID="")||(ALFind'=0)  d
	.s ALInvalidFlag=$p($g(^DHCEQApproveList(ALRowID)),"^",10)
	.q:ALInvalidFlag="Y"
	.s ALOperateType=$p($g(^DHCEQApproveList(ALRowID)),"^",12)
	.q:ALOperateType=1
	.s ALFind=1
	.s ALApproveDate=$p($g(^DHCEQApproveList(ALRowID)),"^",7)
	.s ALApproveTime=$p($g(^DHCEQApproveList(ALRowID)),"^",8)
	.s ALActionDR=$p($g(^DHCEQApproveList(ALRowID)),"^",11)
	.;获取审批信息
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveTypeDR,ALSourceID,0))
	.s AILocDR=$p($g(^DHCEQApproveInfo(AIRowID)),"^",9)
	.s AIStatus=$p($g(^DHCEQApproveInfo(AIRowID)),"^",8)
	.q:AIStatus=0
	.q:((IsOperFlag="")&&(AIStatus=2))		//不检测审核状态单据
	.s AIHospitalDR=""
	.i AILocDR'=""  d
	..;s AIHospitalDR=$p($g(^CTLOC(AILocDR)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
	..s AIHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(AILocDR)   //modify by jyp 2019-10-18 CTLOC调整
	.i AIHospitalDR="" s AIHospitalDR=0
	.s AIEquipTypeDR=$p($g(^DHCEQApproveInfo(AIRowID)),"^",10)
	.;获取业务时效定义
	.i IsOperFlag=""  d
	..s PFind=0
	..s PHospDR=""
	..f  s PHospDR=$o(^DHCEQPrescription(0,"PrescriptionSort",ApproveTypeDR,PHospDR),-1)  q:(PHospDR="")||(PFind'=0)  d
	...s PEquipTypeDR=""
	...f  s PEquipTypeDR=$o(^DHCEQPrescription(0,"PrescriptionSort",ApproveTypeDR,PHospDR,PEquipTypeDR),-1)  q:(PEquipTypeDR="")||(PFind'=0)  d
	....i (PHospDR=AIHospitalDR)&&(PEquipTypeDR=AIEquipTypeDR) s PFind=1
	....i (PHospDR=AIHospitalDR)&&(PEquipTypeDR=0) s PFind=1
	....i (PHospDR=0)&&(PEquipTypeDR=AIEquipTypeDR) s PFind=1
	....i (PHospDR=0)&&(PEquipTypeDR=0) s PFind=1
	....s PReturnFlag=""
	....s PSort=""
	....f  s PSort=$o(^DHCEQPrescription(0,"PrescriptionSort",ApproveTypeDR,PHospDR,PEquipTypeDR,PSort))  q:(PSort="")||(+PReturnFlag="2")  d
	.....s PRowID=0
	.....f  s PRowID=$o(^DHCEQPrescription(0,"PrescriptionSort",ApproveTypeDR,PHospDR,PEquipTypeDR,PSort,PRowID))  q:(PRowID="")||(+PReturnFlag="2")  d
	......s PRAction=$p($g(^DHCEQPrescription(PRowID)),"^",4)
	......s ToCheckApproveAction=..CheckApproveAction(ApproveTypeDR,ALSourceID,PRAction)
	......q:ToCheckApproveAction'=0
	......s PLSort=""
	......f  s PLSort=$o(^DHCEQPrescriptionList(0,"PrescriptionListSort",PRowID,"Y",PLSort))  q:(PLSort="")||(+PReturnFlag="2")  d
	.......s PLRowID=0
	.......f  s PLRowID=$o(^DHCEQPrescriptionList(0,"PrescriptionListSort",PRowID,"Y",PLSort,PLRowID))  q:(PLRowID="")||(+PReturnFlag="2")  d
	........s PLFromAction=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",2)
	........q:PLFromAction=""
	........;检测是否有开始动作审批(无则过滤)
	........s CheckApproveAction=..CheckApproveAction(ApproveTypeDR,ALSourceID,PLFromAction)
	........q:CheckApproveAction=0
	........s FromUser=$p($g(^DHCEQApproveList(CheckApproveAction)),"^",6)
	........i FromUser'="" s FromUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",FromUser)	
	........s FromDate=$p($g(^DHCEQApproveList(CheckApproveAction)),"^",7)
	........s FromTime=$p($g(^DHCEQApproveList(CheckApproveAction)),"^",8)
	........s TimeDiff=##Class(web.DHCEQCommon).TimeDiff(FromDate,FromTime,+$H,+$P($H,",",2),1)
	........s FromUnit=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",4)
	........s UnitNum=+$CASE(FromUnit,1:"31536000",2:"2592000",3:"86400",4:"3600",5:"60",6:"1",:"0")
	........s PassTime=+$p($g(^DHCEQPrescriptionList(PLRowID)),"^",3)*UnitNum
	........s WaringTime=+$p($g(^DHCEQPrescriptionList(PLRowID)),"^",5)*UnitNum
	........q:(+TimeDiff)<WaringTime								//未进入预警期不显示
	........i (WaringTime<=+TimeDiff)&&(+TimeDiff<PassTime) s TPrcFlag="1"		//进入预警期
	........i (+TimeDiff)>=PassTime s TPrcFlag="2"					//过期
	........i TPrcFlag="2"  d
	.........s PReturnFlag="2^"_PLRowID_"^"_TimeDiff_"^"_FromDate_"^"_FromTime_"^"_FromUser_"^^"
	........e  d
	.........i PReturnFlag="" s PReturnFlag="1^"_PLRowID_"^"_TimeDiff_"^"_FromDate_"^"_FromTime_"^"_FromUser_"^^"
	.e  d
	..s PIRowID=$o(^DHCEQPrescriptionInfo(0,"ApproveList",ALRowID,0))
	..q:PIRowID=""
	..s PIApproveListDR=$p($g(^DHCEQPrescriptionInfo(PIRowID)),"^",1)
	..s FromUser=$p($g(^DHCEQApproveList(PIApproveListDR)),"^",6)
	..i FromUser'="" s FromUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",FromUser)	
	..s FromDate=$p($g(^DHCEQPrescriptionInfo(PIRowID)),"^",2)
	..s FromTime=$p($g(^DHCEQPrescriptionInfo(PIRowID)),"^",3)
	..s PIToDate=$p($g(^DHCEQPrescriptionInfo(PIRowID)),"^",4)
	..s PIToTime=$p($g(^DHCEQPrescriptionInfo(PIRowID)),"^",5)
	..s PIHold1=$p($g(^DHCEQPrescriptionInfo(PIRowID)),"^",11)
	..s PIFromAction=$p($g(^DHCEQPrescriptionInfo(PIRowID)),"^",9)
	..s PIToAction=$p($g(^DHCEQPrescriptionInfo(PIRowID)),"^",10)
	..s TimeDiff=##Class(web.DHCEQCommon).TimeDiff(FromDate,FromTime,PIToDate,PIToTime,1)
	..s PReturnFlag=PIHold1_"^^"_TimeDiff_"^"_FromDate_"^"_FromTime_"^"_FromUser_"^"_PIFromAction_"^"_PIToAction
	if PReturnFlag="" q 0
	q PReturnFlag
}

}
