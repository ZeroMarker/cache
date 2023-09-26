Import sqluser

/// Description:门诊草药房审方发药表操作相关
/// Creator:    hulihua
/// CreateDate: 2018-08-14
/// Table:      DHC_PHACollected、DHC_PHACollectItm、DHC_PhaCollectItmLB、DHC_STDRUGREFUSE
Class web.DHCOUTPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// Description:门诊草药审方发药相关
/// Creator:	hulihua
/// CreateDate:	2018-08-14
/// Table:      DHC_PHACollected、DHC_PHACollectItm、DHC_PhaCollectItmLB
/// Input:		处方号、开始日期、截至日期、药房科室ID、发药人ID
/// Output:
/// Return：    发药主表ID
/// Others:
/// w ##class(web.DHCOUTPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp).SaveData("295668^4^^^11^O18081400001^67")
ClassMethod SaveData(params)
{
	s PrescPrt=$p(params,"^",1)
	s PharPhl=$p(params,"^",2)
	s PharPhw=$p(params,"^",3)
	s PharPydr=$p(params,"^",4)
	s PharFydr=$p(params,"^",5)
	s prescNo=$p(params,"^",6)
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s CookType=$p(prescStr,"^",7)
	s CookCost="",PayDispFlag=""
	//代煎处方获取煎药费，对于先发药的无需判断
	i CookType["代煎" d
	.s ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	.q:ord=""
	.s chl=$o(^OEORD(0,"PrescNo",prescNo,ord,""),-1)
	.q:chl=""
	.s Moeori=##class(web.DHCOutPhCommon).GetMainOeori(ord_"||"_chl)
	.q:Moeori=""
	.s PayDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(Moeori)
	.s CookCost=##class(web.DHCOutPhCommon).GetDecoctFee(prescNo,"1")
	q:(CookType["代煎")&&(PayDispFlag'="Y")&&(CookCost="") "-201^该代煎处方煎药费还未收！"
	s Err=0
	l +^DHCOUTPHADISPLOCK(prescNo):5  e  q "-202^加锁失败！"
	s $zt="ThrowSaveData"
    s RetCode=##class(web.DHCOUTPHA.Disp.DirectDisp).SAVEDATA(PrescPrt,PharPhl,PharPhw,PharPydr,PharFydr,prescNo,"","","","","")
	l -^DHCOUTPHADISPLOCK(prescNo)
	q RetCode
ThrowSaveData
	l -^DHCOUTPHADISPLOCK(prescNo)
	d JsonErrorRecord^DHCSTERROR()
	q ""
}

/// Description:保存处方修改信息
/// Creator：   pushuangcai
/// CreatDate： 2018/07/18
/// Table：     PA_QUE1--处方表,^PAQUE1(QUE1_RowID,"DHC")  
/// Input：       
/// Output：    w ##class(web.DHCSTPharmacyCommon).SavePrescModified()
/// Return：    0--成功, 非0--失败 
/// Others：
ClassMethod SavePrescModified(PrescNo As %String, ParamStr As %String, DetailStr As %String)
{
	Quit:PrescNo="" 0
	Set QueId=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
	Quit:QueId="" 0		
	Set InstrucId = $P(ParamStr,"^",1)	
	Set MakeMethodId = $P(ParamStr,"^",2)	
	Set FreqId = $P(ParamStr,"^",3)
	Set OrderQtyId = $P(ParamStr,"^",4)
	Set Efficacy = $P(ParamStr,"^",5)
	Set $ZT="ERRORPrescSave"
	Ts
	Set $P(^PAQUE1(QueId,"DHC"),"^",9)=FreqId			//频次 
	Set $P(^PAQUE1(QueId,"DHC"),"^",11)=InstrucId		//用法
	Set $P(^PAQUE1(QueId,"DHC"),"^",13)=OrderQtyId		//用量
	Set $P(^PAQUE1(QueId,"DHC"),"^",27)=MakeMethodId	//配制方法
	Set $P(^PAQUE1(QueId,"DHC"),"^",29)=Efficacy		//功效
	// 保存特殊煎法
	For i=1:1:$l(DetailStr,"&") Do
	.Set Detail=$P(DetailStr,"&",i)
	.Quit:Detail=""
	.Set Oeori=$p(Detail,"^",2)
	.Set PhSpecInstr=$p(Detail,"^",4)
	.Quit:(Oeori="")
	.Set Err=..UpdateOeoriInstr(Oeori,PhSpecInstr)
	.Quit:Err<0
	If Err'=0 TRO  Quit Err
	TC 
	Quit Err
ERRORPrescSave	
	Tro
	Quit $ZE
}

/// Descript: 	更新医嘱明细表的特殊煎法
/// Creator：	pushaungcai
/// CreateDate：2018-08-20
/// Table：		OE_OrdItem
/// Input：		Oeori--医嘱明细id , PhSpecInstr--特殊煎法
/// Return：	0--成功; 非0--错误
/// d ##Class(web.DHCINPHA.MobilePHA).UpdateOeoriInstr()
ClassMethod UpdateOeoriInstr(Oeori As %String, PhSpecInstr As %String)
{
	s Err=0
	&sql(update OE_OrdItem set oeori_phspecinstr=:PhSpecInstr where oeori_rowid=:Oeori) 
	If SQLCODE'=0  Do
	.Set ret=$$SqlErrorRecord^DHCSTERROR("UpdateOeoriInstr:OE_OrdItem",Oeori,SQLCODE_":"_$g(%msg))
	.Set Err=-2
	Q:SQLCODE'=0 Err
	Quit Err
}

/// Description:转换煎药方式
/// Creator:	hulihua
/// CreateDate:	2018-09-03
/// Table:      PA_QUE1--处方表,^PAQUE1(QUE1_RowID,"DHC")
/// Input:		PrescNo-处方号，InputCookType-原煎药方式
/// Output:
/// Return：    0-成功，非0-失败
/// Others:
/// w ##class(web.DHCOUTPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp).SavePrescCookType()
ClassMethod SavePrescCookType(PrescNo As %String, InputCookType As %String, Phl As %String)
{
	Q:PrescNo="" "-1^该处方不存在!"
	Q:InputCookType="" "-2^该处方原煎药方式为空!"
	S QueId=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
	Q:QueId="" "-3^该处方不是草药处方!"
	s phd=##class(web.DHCOutPhDisp).GetPhdByPresc(PrescNo,"",Phl)
	s phdretid=$s(phd'="":$o(^DHCPHRETi(Phl,phd,""),-1),1:"")
	q:phdretid'="" "-4^该处方已存在退药信息，无需转换！"
	S CookCost=""
	I InputCookType="自煎"  D
	.s ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	.q:ord=""
	.s chl=$o(^OEORD(0,"PrescNo",PrescNo,ord,""),-1)
	.q:chl=""
	.s Moeori=##class(web.DHCOutPhCommon).GetMainOeori(ord_"||"_chl)
	.q:Moeori=""
	.s PayDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(Moeori)
	.S CookCost=##class(web.DHCOutPhCommon).GetDecoctFee(PrescNo,"1")
	Q:(InputCookType="自煎")&&(PayDispFlag'="Y")&&(CookCost="") "-5^该自煎处方的煎药费还未收，无需转换为代煎!"
	Q:(InputCookType="自煎")&&(PayDispFlag="Y")&&(CookCost="") "-6^该自煎处方无煎药费信息，请先做煎药申请！"
	S CookMode=$s(InputCookType="代煎":"自煎",1:"代煎")		
	S $P(^PAQUE1(QueId,"DHC"),"^",15)=CookMode
	Q 0
}

/// Description:煎药费关联处方
/// Creator:	hulihua
/// CreateDate:	2018-09-06
/// Table:      OE_OrdItem
/// Input:		Oeori-煎药费ID，Moeori-草药处方主医嘱ID
/// Output:
/// Return：    0-成功，非0-失败
/// Others:
/// Debug:		w ##class(web.DHCOUTPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp)UpdateCookOeori()
ClassMethod UpdateCookOeori(Oeori As %String, Moeori As %String)
{
	Q:Oeori="" "-8^煎药费插入失败！"
	Q:Moeori="" "-9^该处方没有主医嘱！"
	s err=0
	s obj=##class(User.OEOrdItem).%OpenId(Oeori)
	d obj.OEORIOEORIDRSetObjectId(Moeori)
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.s err=-1
	q:err'=0 "-11^$SYSTEM.Status.GetErrorText(sc)"
	Q 0
}

/// Description:第三方移动端完成调剂之后回传给HIS调剂信息
/// Creator:	hulihua
/// CreateDate:	2018-09-07
/// Table:      DHC_PHDISPEN--门诊配/发药主表
/// Input:		PhdId-发药主表ID，ListData-发药主表ID^调剂完成日期^调剂完成时间^调剂人^复核日期^复核时间^复核人^发药日期^发药时间^发药人
/// Output:
/// Return： 	""-空  
/// Others:
/// w ##class(web.DHCOUTPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp).UpdateDrugDisp()
ClassMethod UpdateDrugDisp(PhdId, ListData As %String) As %String
{
	s MakeUpDate=$p(ListData,"^",1)
	s MakeUpTime=$p(ListData,"^",2)
	s MakeUpCode=$p(ListData,"^",3)
	//根据工号判断
	s MakeUpUser=$s(MakeUpCode'="":$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MakeUpCode),""),-1),1:"") 
	q:(MakeUpCode'="")&&(MakeUpUser="") "-3^HIS系统中调剂人工号不存在！"
	s PhpMakeUpUser=$o(^DHCPHPERi("USR",MakeUpUser,""),-1)
	q:(MakeUpCode'="")&&(PhpMakeUpUser="") "-4^药房未维护调剂人权限！"
	s ValidationDate=$p(ListData,"^",4)
	s ValidationTime=$p(ListData,"^",5)
	s ValidationerCode=$p(ListData,"^",6)
	s ValidationerUser=$s(ValidationerCode'="":$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ValidationerCode),""),-1),1:"")
	q:(ValidationerCode'="")&&(ValidationerUser="") "-5^HIS系统中复核人工号不存在！"
	s DrugDispDate=$p(ListData,"^",7)
	s DrugDispTime=$p(ListData,"^",8)
	s DrugDispCode=$p(ListData,"^",9)
	s DrugDispUser=$s(DrugDispCode'="":$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DrugDispCode),""),-1),1:"")
	q:(DrugDispCode'="")&&(DrugDispUser="") "-6^HIS系统中发药人工号不存在！"
	s PhpDrugDispUser=$o(^DHCPHPERi("USR",DrugDispUser,""),-1)
	q:(DrugDispCode'="")&&(PhpDrugDispUser="") "-7^药房未维护发药人权限！"
	s DataSource="2"
	l +^DHCOUTPHALOCK("UpdateDrugDisp"_PhdId):2 e  q "-8^加锁失败！"   
	s err=0
	&sql(UPDATE DHC_PHDISPEN SET PHD_PYDATE=:MakeUpDate, PHD_PYTime=:MakeUpTime, PHD_PHP_PYDR=:PhpMakeUpUser,
	PHD_PYCKDATE=:ValidationDate, PHD_PYCKTIME=:ValidationTime, PHD_CheckUser_Dr=:ValidationerUser, 
	PHD_FYDATE=:DrugDispDate, PHD_FYTIME=:DrugDispTime, PHD_PHP_FYDR=:PhpDrugDispUser,PHD_DataSource=:DataSource 
	WHERE PHD_ROWID=:PhdId)
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("UpdateDrugDisp:DHC_PHDISPEN",PhdId,SQLCODE_":"_$G(%msg))
 	.s err=-1
 	l -^DHCOUTPHALOCK("UpdateDrugDisp"_PhdId)
 	q:err'=0 "-9^HIS更新发药主表失败！"
 	;草药处方需要插入处方追踪信息！
 	s PhlDr=$p(^DHCPHDISP(PhdId,1),"^",1)									
	s PhLocId=$p(^DHCPHLOC(PhlDr),"^",1)									
	s PrescNo=$p(^DHCPHDISP(PhdId,2),"^",1)
	i (MakeUpDate'="")||(MakeUpTime'="")||(MakeUpUser'="")  d
	.s SqlStr="^^"_PrescNo_"^C6^"_PhLocId_"^"_MakeUpUser_"^"_MakeUpDate_"^"_MakeUpTime
	.d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr,"1")
	i (ValidationDate'="")||(ValidationTime'="")||(ValidationerUser'="")  d
	.s SqlStr="^^"_PrescNo_"^C7^"_PhLocId_"^"_ValidationerUser_"^"_ValidationDate_"^"_ValidationTime
	.d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr,"1")
	i (DrugDispDate'="")||(DrugDispTime'="")||(DrugDispUser'="")  d
	.s SqlStr="^^"_PrescNo_"^C8^"_PhLocId_"^"_DrugDispUser_"^"_DrugDispDate_"^"_DrugDispTime
	.d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr,"1")
 	q 0
}

}
