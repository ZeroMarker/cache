Class web.DHCEQPriorityRule Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String")
{
    SELECT PR_Rule,
	       PR_RowID
    FROM sqluser.DHC_EQPriorityRule
    where PR_InvalidFlag = 'N' and PR_Rule like nvl(:para,'')||'%'
}

ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		s PLIST(4)="Y"
		&SQL(Update sqluser.DHC_EQPriorityRule Values :PLIST() where PR_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s SourceTypeID=PLIST(2)
	s PLIST(3)=$p(val,"^",3)
	s Rule=$p(val,"^",3)
	s PLIST(4)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"bool")
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s PLIST(7)=$p(val,"^",7)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)		//Add By DJ 2015-08-20 DJ0157
	s PLIST(11)=$p(val,"^",11)		//Add By DJ 2015-08-20 DJ0157
	
	s tmpid=""
	&SQL(select PR_RowID into :tmpid from sqluser.DHC_EQPriorityRule where PR_Rule=:Rule and PR_InvalidFlag!='Y')
	if ((tmpid="")||(tmpid=rowid))
	{
		i (rowid="")
		{
			&SQL(Insert Into sqluser.DHC_EQPriorityRule Values :PLIST())
		} 
		else
		{
			&SQL(Update sqluser.DHC_EQPriorityRule Values :PLIST() where PR_RowID = :rowid)
		}
	}
	if SQLCODE  q SQLCODE
	Set ID=$g(%ROWID)
	q ID
}

Query PriorityRule(Rule As %String = "", SourceTypeID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceTypeID:%String,TSourceType:%String,TRule:%String,TInvalidFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,THospitalDR:%String,THospitalDesc:%String,TEquipTypeDR:%String,TEquipType:%String,TRow:%String")
{
}

ClassMethod PriorityRuleExecute(ByRef qHandle As %Binary, Rule As %String = "", SourceTypeID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Rule=$ZCONVERT(Rule ,"U")
	s index=1
	s TRow=1
	s rowid=0
	for  s rowid=$o(^DHCEQPriorityRule(rowid)) quit:rowid=""  d
	.d ResetVariablesGetPriorityRule
	.s TRowID=rowid
	.s TSourceTypeID=$p($g(^DHCEQPriorityRule(rowid)),"^",1)
	.q:(SourceTypeID'="")&(SourceTypeID'=TSourceTypeID)
	.i TSourceTypeID'="" d
	..s TSourceType=$p($g(^DHCEQCCode("DHCEQCApproveType",TSourceTypeID)),"^",2)
	.s TRule=$p($g(^DHCEQPriorityRule(rowid)),"^",2)
	.q:($ZCONVERT(TRule,"U")'[Rule)&(Rule'="")
	.s TInvalidFlag=$p($g(^DHCEQPriorityRule(rowid)),"^",3)
	.q:TInvalidFlag="Y"
	.s THold1=$p($g(^DHCEQPriorityRule(rowid)),"^",4)
	.s THold2=$p($g(^DHCEQPriorityRule(rowid)),"^",5)
	.s THold3=$p($g(^DHCEQPriorityRule(rowid)),"^",6)
	.s THold4=$p($g(^DHCEQPriorityRule(rowid)),"^",7)
	.s THold5=$p($g(^DHCEQPriorityRule(rowid)),"^",8)
	.s THospitalDR=$p($g(^DHCEQPriorityRule(rowid)),"^",9)		//Add By DJ 2015-08-20 DJ0157 begin
	.i THospitalDR'="" s THospitalDesc=$p($g(^CT("HOSP",THospitalDR)),"^",2)
	.s TEquipTypeDR=$p($g(^DHCEQPriorityRule(rowid)),"^",10)
	.i TEquipTypeDR'="" s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)  //Add By DJ 2015-08-20 DJ0157 end
	.d OutputRowGetPriorityRule
	Quit $$$OK
OutputRowGetPriorityRule
	s Data=$lb(TRowID,TSourceTypeID,TSourceType,TRule,TInvalidFlag,THold1,THold2,THold3,THold4,THold5,THospitalDR,THospitalDesc,TEquipTypeDR,TEquipType,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetPriorityRule
	s (TRowID,TSourceTypeID,TSourceType,TRule,TInvalidFlag,THold1,THold2,THold3,THold4,THold5,THospitalDR,THospitalDesc,TEquipTypeDR,TEquipType)=""
	quit
}

ClassMethod PriorityRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PriorityRuleExecute ]
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

ClassMethod PriorityRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PriorityRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQPriorityRule(rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",1) //来源类型ID
	s resultex=resultex_"^"	//2
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCApproveType",$p(result,"^",1))),"^",2) //来源类型描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",2) //
	s resultex=resultex_"^"	//4
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",3) //
	s resultex=resultex_"^"	//5
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",4) //
	s resultex=resultex_"^"	//6
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",5) //
	s resultex=resultex_"^"	//7
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",6) //
	s resultex=resultex_"^"	//8
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",7) //
	s resultex=resultex_"^"	//9
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",8) //
	s resultex=resultex_"^"	//10			//Add By DJ 2015-08-20 DJ0157 begin
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",9) //
	s resultex=resultex_"^"	//11
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^CT("HOSP",$p(result,"^",9))),"^",2) //
	s resultex=resultex_"^"	//12
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p($g(^DHCEQPriorityRule(rowid)),"^",10) //Modified by HHM 20150914 HHM0017
	s resultex=resultex_"^"	//13
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(result,"^",10)) // //Add By DJ 2015-08-20 DJ0157 end
	q resultex
}

/// Add By DJ 2015-02-11
/// 描述:获取业务优先级别
/// 入参:SourceType表示业务类型  SourceID表示业务RowID   ApproveRole表示当前审批角色
/// 返回值:""表示问题单据  -3表示审核单据  -2表示新增单据  -1表示未配置优先级别或时效定义等  其它返回值越大优先级别越高
ClassMethod GetPriorityLevel(SourceType, SourceID, ApproveRole)
{
	n (SourceType,SourceID,ApproveRole)
	s PriorityLevel=""
	i ((SourceType="")||(SourceID="")) q ""
	s (Severity,Emergency)=1
	i SourceType="25"	//新维修
	{
		s Status=$p($g(^DHCEQMMaintRequest(SourceID)),"^",41)
		s EquipTypeDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",3)
		s LocDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",7)		//RequestLocDR
		s SeverityDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",62)
		i SeverityDR'="" s Severity=$Piece($Get(^DHCEQCCode("DHCEQMCSeverityLevel",SeverityDR)),"^",3)
		s EmergencyDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",61)
		i EmergencyDR'="" s Emergency=$p($g(^DHCEQCCode("DHCEQMCEmergencyLevel",EmergencyDR)),"^",3)
	}
	else
	{
		q "0"
	}
	i Status=2 q "-3"		//已审核单据
	i Status=0 q "-2"		//新增单据
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType(SourceType)
	i ApproveType="" q ""		//无审批类型
	i ApproveRole=""	//获取单据当前审批角色
	{
		s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,SourceID,0))
		i ApproveInfoID="" q ""
		s ApproveRoleDR = $P($G(^DHCEQApproveInfo(ApproveInfoID)),"^",4)
	}
	else
	{
		s ApproveRoleDR=ApproveRole
	}
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "","")
	i ApproveSet="" q ""	//该业务无审批设置
	s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRoleDR,0))
	i ApproveFlowDR="" q ""
	s ActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",9)
	i ActionDR="" q "-1"		//当前审批流未设置动作
	;s HospitalDR=+$p($g(^CTLOC(LocDR)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
	s HospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)   //modify by jyp 2019-10-18 CTLOC调整
	s PRRowID=$o(^DHCEQPriorityRule(0,"Rule",+HospitalDR,ApproveType,+EquipTypeDR,"N",0))
	i PRRowID="" s PRRowID=$o(^DHCEQPriorityRule(0,"Rule",+HospitalDR,ApproveType,0,"N",0))
	i PRRowID="" s PRRowID=$o(^DHCEQPriorityRule(0,"Rule",0,ApproveType,0,"N",0))
	i PRRowID="" q "-1"		//未设置优先规则
	s PRRule=$p($g(^DHCEQPriorityRule(PRRowID)),"^",2)
	i PRRule="" q "-1"		//无优先规则
	s PRowID=$o(^DHCEQPrescription(0,"Prescription",+HospitalDR,ApproveType,+EquipTypeDR,ActionDR,0))
	i PRowID="" s PRowID=$o(^DHCEQPrescription(0,"Prescription",+HospitalDR,ApproveType,0,ActionDR,0))
	i PRowID="" s PRowID=$o(^DHCEQPrescription(0,"Prescription",0,ApproveType,0,ActionDR,0))
	i PRowID="" q "-1"		//未设置时效
	s PLRowID=$o(^DHCEQPrescriptionList(0,"Prescription",PRowID,0))
	i PLRowID="" q "-1"		//未设置时效详细信息
	s ActivePreFlag=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",7)	//执行优先标志
	i ActivePreFlag="N" q "-1"		//未激活优先标志
	
	s PRRule=##class(web.DHCEQCommon).Replace(PRRule,"{Severity}",Severity)		//严重程度
	s PRRule=##class(web.DHCEQCommon).Replace(PRRule,"{Emergency}",Emergency)		//紧急程度
	
	f i=1:1:$L(PRRule)  d
	.s FindLeft=$F(PRRule,"{")
	.q:FindLeft=0
	.s FindRight=$F(PRRule,"}")
	.q:FindRight<FindLeft
	.s PRRule=##class(web.DHCEQCommon).Replace(PRRule,$E(PRRule,FindLeft-1,FindRight-1),1)	//未定义变量默认1
	.s i=0
	
	i $F(PRRule,"{")>0 q "-1"
	i $F(PRRule,"}")>0 q "-1"
	
	s PriorityLevel=##Class(web.DHCEQCommon).Calculator(PRRule)
	q PriorityLevel
}

/// Add By DJ 2015-02-15
/// 描述:获取时效预警
/// 入参:SourceType表示业务类型  SourceID表示业务RowID   ApproveRole表示当前审批角色
/// 返回值: ""表示问题单据  0表示正常  -1表示预警  -2表示过期
ClassMethod GetPrescriptionAlarm(SourceType, SourceID, ApproveRole)
{
	n (SourceType,SourceID,ApproveRole)
	i ((SourceType="")||(SourceID="")) q ""
	i SourceType="25"	//新维修
	{
		s Status=$p($g(^DHCEQMMaintRequest(SourceID)),"^",41)
		s EquipTypeDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",3)
		s LocDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",7)		//RequestLocDR
		s SubmitDate=$p($g(^DHCEQMMaintRequest(SourceID)),"^",49)
		s SubmitTime=$p($g(^DHCEQMMaintRequest(SourceID)),"^",50)
	}
	else
	{
		q 0
	}
	
	i Status=2 q 0		//已审核单据
	i Status=0 q 0		//新增单据
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType(SourceType)
	i ApproveType="" q ""		//无审批类型
	i ApproveRole=""	//获取单据当前审批角色
	{
		s ApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,SourceID,0))
		i ApproveInfoID="" q ""
		s ApproveRoleDR = $P($G(^DHCEQApproveInfo(ApproveInfoID)),"^",4)
	}
	else
	{
		s ApproveRoleDR=ApproveRole
	}
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "","")
	i ApproveSet="" q ""	//该业务无审批设置
	s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRoleDR,0))
	s ActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlowDR)),"^",9)
	i ActionDR="" q "0"		//当前审批流未设置动作
	;s HospitalDR=+$p($g(^CTLOC(LocDR)),"^",22)
	s HospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocDR)
	s PRowID=$o(^DHCEQPrescription(0,"Prescription",+HospitalDR,ApproveType,+EquipTypeDR,ActionDR,0))
	i PRowID="" s PRowID=$o(^DHCEQPrescription(0,"Prescription",+HospitalDR,ApproveType,0,ActionDR,0))
	i PRowID="" s PRowID=$o(^DHCEQPrescription(0,"Prescription",0,ApproveType,0,ActionDR,0))
	i PRowID="" q "0"		//未设置时效
	s PLRowID=$o(^DHCEQPrescriptionList(0,"Prescription",PRowID,0))
	i PLRowID="" q "0"		//未设置时效详细信息
	s ActiveTimeFlag=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",6)	//激活时效标志
	i ActiveTimeFlag="N" q "0"		//未激活时效标志
	
	s FromAction=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",2)
	s TimeNum=+$p($g(^DHCEQPrescriptionList(PLRowID)),"^",3)
	s TimeUnitDR=$p($g(^DHCEQPrescriptionList(PLRowID)),"^",4)
	s AlarmNum=+$p($g(^DHCEQPrescriptionList(PLRowID)),"^",5)
	s CycleDays=TimeNum*($CASE(TimeUnitDR,"1":"365","2":"30","3":"1"))
	s AlarmDays=AlarmNum*($CASE(TimeUnitDR,"1":"365","2":"30","3":"1"))
	
	i FromAction=""  d
	.s FromDate=SubmitDate
	e  d
	.s FromDate=""
	.s ALRowID=0
	.f  s ALRowID=$o(^DHCEQApproveList(0,"Source",ApproveType,SourceID,ALRowID))  q:(ALRowID="")||(FromDate'="")  d
	..s ALInvalidFlag=$p($g(^DHCEQApproveList(ALRowID)),"^",10)
	..q:ALInvalidFlag="Y"
	..s ALAction=$p($g(^DHCEQApproveList(ALRowID)),"^",11)
	..q:ALAction'=FromAction
	..s FromDate=$p($g(^DHCEQApproveList(ALRowID)),"^",7)
	..s FromTime=$p($g(^DHCEQApproveList(ALRowID)),"^",8)
	i FromDate="" q "0"	//开始步骤审批时间未找到
	
	s AlarmDate=FromDate+CycleDays-AlarmDays
	s TimeDate=FromDate+CycleDays
	//开始计算预警及过期
	i (+$H<AlarmDate) q 0
	i (AlarmDate<=+$H)&&(+$H<=TimeDate) q "-1"
	i (+$H>TimeDate) q "-2"
	
	q 0
}

}
