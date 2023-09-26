Class DtPortal.Doctor.D02ClinicPrompt.D0205UndoDoctorAdvice Extends %RegisteredObject
{

/// /// Creator： 赵忠原
/// CreatDate： 2014-7-24
/// Description: 查询有当前医生待审核医嘱病人列表
/// modifyby zhaoli 增加个人或主诊组的参数 ---20170707
/// Input：		UserCode：用户Code   （QueryType 查询范围 p个人pg主诊组	）
/// Return：	BedNo：床号 
/// 			Name：姓名
///             Count:待审核医嘱数量 
/// 			AdmNo：就诊号
/// 				EpisodeID：就诊RowId
/// Debug: 		d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0205UndoDoctorAdvice","D020501QueryUAPat","P","601")
Query D020501QueryUAPat(QueryType As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "BedNo:%String,Name:%String,Count:%String,AdmNo:%String,EpisodeID:%String,Loc:%String,patientID:%String,Sex:%String,Age:%String,DiagnoseDesc:%String,MedicareNo:%String,AdmReason:%String")
{
}

ClassMethod D020501QueryUAPatExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
	
	if UserCode="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	if UserId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s DocId=$P($g(^SSU("SSUSR",UserId)),"^",14)
	set PaadmStr=""
	s LocDr=""
	set PaadmStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserId,"")
	set length=$l(PaadmStr,"^")
	for index=1:1:length
	{
		set EpisodeID=$p(PaadmStr,"^",index)
		set count=0
		
		Set obj=##class(%ResultSet).%New("DtPortal.Doctor.D02ClinicPrompt.D0205UndoDoctorAdvice:D020502QueryUAOrd")
		d obj.Execute(EpisodeID,UserCode)
		
		While (obj.Next()) {
			s count=count+1
		}
		d obj.Close()
		i count>0 d OutputRow2
	}
	
	Quit $$$OK
OutputRow2	
	s patientID=$P($g(^PAADM(EpisodeID)),"^",1)
	set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	quit:PatInfo=""
	set Name=$p(PatInfo,"^",2)											//姓名
	set Sex=$p(PatInfo,"^",3)											//性别
	set Age=$p(PatInfo,"^",4)											//年龄
	set MedicareNo=$p(PatInfo,"^",5)									//病案号
	set AdmReason=$p(PatInfo,"^",6)										//费用类别
	set BedNo=$p(PatInfo,"^",1)											//床号
	set PAPMINo=$p(PatInfo,"^",7)
	
	s patCurrDeptDr=$p(^PAADM(EpisodeID),"^",4)
	s patCurrDept=$p(^CTLOC(patCurrDeptDr),"^",2)
	i patCurrDept["-" s patCurrDept=$p(patCurrDept,"-",2)
	s Loc=patCurrDept
	
	s DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
	
	Set ^||CacheTemp(repid,ind)=$lb(BedNo,Name,count,AdmNo,EpisodeID,Loc,patientID,Sex,Age,DiagnoseDesc,MedicareNo,AdmReason)
	Set ind=ind+1
	quit
}

/// Creator： 赵忠原
/// CreatDate： 2014-7-16
/// Description: 根据就诊查询待审核医嘱列表
/// Input：		EpisodeID：就诊RowId 
/// 				UserCode: 用户Code	
/// Return：	BedNo：床号 
/// 			PAPMINo：登记号
/// 			AdmNo：就诊号
/// 			Name：姓名
/// 			Sex：性别
/// 			OrderItemRowid：医嘱号
/// 			OrderName：医嘱名称
/// 			OrderStatus：医嘱状态
/// 			OrderPrior：医嘱类型
/// 			OrderInstr：医嘱用法
/// 			OrderReason：使用原因
/// 			OrderStartTime：开始时间
/// 			OrderDur：预计疗程
/// 			OrderApplyDoc：申请人
/// 			OrderApplyTime：申请时间
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0205UndoDoctorAdvice","D020502QueryUAOrd","535","435")
Query D020502QueryUAOrd(EpisodeID As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "BedNo:%String,PAPMINo:%String,AdmNo:%String,Name:%String,Sex:%String,Age:%String,diagnos:%String,OrderItemRowid:%String,OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderInstr:%String,OrderReason:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDur:%String,OrderApplyDoc:%String,OrderApplyTime:%String,OrderApplyDate:%String,LinkOrder:%String")
{
}

ClassMethod D020502QueryUAOrdExecute(ByRef qHandle As %Binary, EpisodeID As %String, UserCode As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	
	;if UserCode="" Quit $$$OK
	;s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	;s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	;if UserId="" Quit $$$OK
	if EpisodeID=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	s BedNo=""
	Set Bed=$P($g(^PAADM(EpisodeID)),"^",73)
	if Bed'="" s BedNo=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	Set PatientID=$P($g(^PAADM(EpisodeID)),"^",1)
	Set PAPMINo=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set Name=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	if Sex'="" Set Sex=$P($g(^CT("SEX",Sex)),"^",2)
	
	
	//取诊断---先取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
	s diagnos=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
	
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	
	set PatientID=$P($g(^PAADM(EpisodeID)),"^",1)
	set Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) //统一调用计费组的年龄接口
	
	Set obj=##class(%ResultSet).%New("DtPortal.Doctor.D02ClinicPrompt.D0205UndoDoctorAdvice:FindUnActiveOrderItemsPortal")
	d obj.Execute(EpisodeID)
	For  Quit:'obj.Next()  d
	.s OrderItemRowid=obj.Data("OrderItemRowid")
	.q:OrderItemRowid=""
	.s OrderName=obj.Data("OrderName")
	.s OrderStatus=obj.Data("OrderStatus")
	.s OrderPrior=obj.Data("OrderPrior")
	.s OrderInstr=obj.Data("OrderInstr")
	.;s OrderReason=obj.Data("OrderDepProcNote")
	.s arcim=obj.Data("OrderARCIMRowid")
	.s ZCYFlag=..JudgeZCY(arcim)
	.s OrderReason=$G(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DEP",1))
	.i ZCYFlag=1  s OrderReason=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),2),"^",8)
	.s OrderStartDate=obj.Data("OrderStartDate")
	.i OrderStartDate'=""  s OrderStartDate=$zd(OrderStartDate,3)
	.s OrderStartTime=obj.Data("OrderStartTime")
	.i OrderStartTime'=""  s OrderStartTime=$zt(OrderStartTime,2)
	
	
	.s OrderDur=obj.Data("OrderDur")
	.s OrderApplyDoc=obj.Data("OrderDoc")
	.s OrderApplyTime="",OrderApplyDate=""
	.S OrderApplyDate=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),3),"^",7)
	.s OrderApplyTime=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),1),"^",17)
	.;过滤超过半小时的待审核医嘱--bmz20160422
	.s OrderApplyDateTime=OrderApplyDate_OrderApplyTime
	.s CurrDateTimeTemp=+$h_$p($h,",",2)
	.q:(CurrDateTimeTemp-OrderApplyDateTime)>1800
	.s OrderApplyDate=$ZD(OrderApplyDate,3)
	.s OrderApplyTime=$zt(OrderApplyTime)
	.s LinkOrder=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),11),"^",39)
	.d OutputRow
	d obj.Close()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow	
	Set ^||CacheTemp(repid,ind)=$lb(BedNo,PAPMINo,AdmNo,Name,Sex,Age,diagnos,OrderItemRowid,OrderName,OrderStatus,OrderPrior,OrderInstr,OrderReason,OrderStartDate,OrderStartTime,OrderDur,OrderApplyDoc,OrderApplyTime,OrderApplyDate,LinkOrder)
	Set ind=ind+1
	quit
}

/// Creator： 赵忠原
/// CreatDate： 2014-7-16
/// Description: 审核医嘱
/// Input： UserCode：用户Code  
/// 			OrderItemRowid：医嘱号
/// 			Flag：审核标记(1、同意 2、拒绝)
/// Return：成功标记
/// w ##class(DtPortal.Doctor.D02ClinicPrompt.D0205UndoDoctorAdvice).D020503UpUAOrd("435","797||35;797||36",2)
ClassMethod D020503UpUAOrd(UserCode As %String, OrderRowidArr As %String, Flag As %String) As DtPortal.OutPut
{
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	s Count=0
	s err=0
	s epsoidID=""
	if (UserCode="") s err=-1
	if (OrderRowidArr="")  s err=-2
	s len=$length(OrderRowidArr,";")
	if err=0{
		s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
		s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
		if (UserId="") s err=-1	
		if err=0{
			for k=1:1:len 
			{
				;w k,!
				s OrderItemRowid=$p(OrderRowidArr,";",k)
				
				;查询就诊id
				s epsoidID=$p(^OEORD(+OrderItemRowid),"^",1)
					
				;医嘱不存在了，就退出---bmz20150914
				i '$d(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2))) continue
				;判断是否是主医嘱，非主医嘱退出---bmz20150626
				s LinkOrderTemp=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),11),"^",39)
				i LinkOrderTemp'="" continue
				
				if OrderItemRowid="" s err=-2
				if err=0{
					if Flag=2{
						s err=##class(web.DHCOEOrdItem).DeleteUnActiveOrderItems(OrderItemRowid,UserId)
						if err'=0 s err=-3
						if err=0 d NewsPush
					}elseif Flag=1{
						s ArcimRowId=$p($g(^OEORD(+OrderItemRowid,"I",$P(OrderItemRowid,"||",2),1)),"^",2)
						if ArcimRowId="" s err=-4
						s err=..CheckBeforeUpdate(OrderItemRowid)
						if err=0{
							s OrderStatus=$p(^OEC("OSTAT",$p(^OEORD(+OrderItemRowid,"I",$P(OrderItemRowid,"||",2),1),"^",13)),"^",1)
							b //
							if (OrderStatus'="I") s err=-5
							if err=0{
								s OrderItemStr=OrderItemRowid //ArcimRowId_"*"_OrderItemRowid_"*V"
								s loc=$p(^OEORD(+OrderItemRowid,"I",$P(OrderItemRowid,"||",2),7),"^",2)
								s Adm=$p(^OEORD(+OrderItemRowid),"^",1)						
								d ##class(web.DHCOEOrdItem).SavePractiseDocOrderItems(Adm,UserId,OrderItemStr,loc)
								s AfterOrderStatus=$p(^OEC("OSTAT",$p(^OEORD(+OrderItemRowid,"I",$P(OrderItemRowid,"||",2),1),"^",13)),"^",1)
								if AfterOrderStatus'="V" s err=-6
								if AfterOrderStatus="V" d NewsPush
							}
						}
					}
				
				}
			}
		}	
	}
	if err=0 s err=1
  	s ret.status = err
 
	set:err=1 ret.errMSG = ""
	set:err=-1 ret.errMSG = "用户不存在"
	set:err=-2 ret.errMSG = "请选择医嘱"
	set:err=-3 ret.errMSG = "删除失败"
	set:err=-4 ret.errMSG = "医嘱项为空"
	set:err=-5 ret.errMSG = "医嘱状态不是未审核"
	set:err=-6 ret.errMSG = "审核失败"
	set:err=-7 ret.errMSG = "医嘱开始时间只能比当前时间少30分钟，存在不符合条件项目，请确认。"

	Set ret.data =err
	Quit ret
	
NewsPush
	//增加医嘱审核消息推送 update by chengpeng
	//start
	set NesFlag=+Flag+1
	set rtnNew=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000028",OrderItemRowid,NesFlag,epsoidID)
	//end
}

/// CREATOR    :SHP
/// DESCRIPTION:超过30分钟不允许审核
/// DATE       :20140822
ClassMethod CheckBeforeUpdate(oeori) As %String
{
	s flag=0
	s curTime=$p($h,",",2)
	;s OrdDate=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",9)
	;s SttTime=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",10)
	
	S OrderApplyDate=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",7)
	s OrderApplyTime=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",17)
	
	
	
	s OrderApplyDateTime=OrderApplyDate_OrderApplyTime
	s CurrDateTime=+$h_curTime
	i (CurrDateTime-OrderApplyDateTime)>1800 s flag=-7  //bmz20160422--修改判断
	
	;i SttTime<(curTime-1800)  s flag=-7
	q flag
}

/// CREATOR    :SHP
/// DESCRIPTION:超过30分钟不允许审核
/// DATE       :20140822
/// DEBUG      :W ##CLASS(DtPortal.Doctor.D02ClinicPrompt.D0205UndoDoctorAdvice).JudgeZCY("100||1")
ClassMethod JudgeZCY(arcim) As %String
{
	s flag=0
	s imcatdr=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
	q:imcatdr="" flag
	s imcatDesc=$p(^ARC("IC",imcatdr),"^",2)
	i imcatDesc["中草药"  s flag=1
	q flag
}

/// CREATOR    :bmz
/// DESCRIPTION:待审核医嘱查询，复制his中的方法，---web.DHCOEOrdItem FindUnActiveOrderItems   query方法
/// DATE       :20141127
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0205UndoDoctorAdvice","FindUnActiveOrderItemsPortal","001")
Query FindUnActiveOrderItemsPortal(EpisodeID As %String) As DtPortal.Query(ROWSPEC = "OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDoseQty:%String,OrderDoseUOM:%String,OrderFreq:%String,OrderInstr:%String,OrderDur:%String,OrderPrice:%String,OrderPackQty:%String,OrderPackUOM:%String,OrderSkinTest:%String,OrderRecDep:%String,OrderUserDep:%String,OrderSum:%String,OrderPrescNo:%String,OrderDepProcNote:%String,OrderDoc:%String,OrderUserAdd:%String,OrderSeqNo:%String,OrderMasterSeqNo:%String,OrderLinkTo:%String,OrderLabEpisodeNo:%String,OrderItemRowid:%String,OrderARCIMRowid:%String,OrderSttDate:%String,OrderDoseUOMRowid:%String,OrderFreqRowid:%String,OrderPriorRowid:%String,OrderInstrRowid:%String,OrderDurRowid:%String,OrderPackUOMRowid:%String,OrderRecDepRowid:%String,OrderUserDepRowid:%String,OrderStatusRowid:%String,OrderBaseUOMRowid:%String,OrderDocRowid:%String,OrderUserAddRowid:%String,OrderARCOSRowid:%String,OrderDrugFormRowid:%String,OrderMaxDurRowid:%String,OrderType:%String,OrderBillTypeRowid:%String,OrderMaxDurRowid:%String,OrderBillType:%String,DepProcNotes:%String,OrderPhSpecInstr:%String,OrderLabSpec:%String,OrderAutoCalculate:%String,OrderCoverMainIns:%String,OrderActionRowid:%String,OrderAction:%String,OrderFile1:%String,OrderFile2:%String,OrderFile3:%String,OrderLabExCode:%String")
{
}

ClassMethod FindUnActiveOrderItemsPortalExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 ;OrderName,OrderStatus,OrderPrior,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderMasterSeqNo,Spec,OrderLabEpisodeNo
 ;OrderItemRowid,OrderARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderLinkto,OrderARCOSRowid,OrderDrugForRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid
 Set repid=$I(^||CacheTemp)
 If $g(ind)="" Set ind=1
 ;
 do ResetVariables5
 set PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice="",LabEpisodeNo=""
 set PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
 set NoDisplayItemCat=##class(web.DHCDocConfig).GetConfigNode("NoDisplayItemCat")
 set ShowPaidOrder=##class(web.DHCDocConfig).GetConfigNode("ShowPaidOrder")
 
 s Today=+$H,CurrDateTime=+$H_$p($H,",",2)
 s PatType=$P(^PAADM(EpisodeID,1),"^",6)  //PAADM_Epissubtype_DR
 &SQL(DECLARE OrdCur1 CURSOR FOR
 SELECT OEORI_Rowid,OEORI_ItmMast_DR,OEORI_ItmMast_DR->ARCIM_Desc,
 OEORI_SttDat,OEORI_SttTim,Todate(OEORI_SttDat,'yyyy-mm-dd'),
 OEORI_DoseQty,OEORI_Unit_DR,OEORI_Unit_DR->CTUOM_Desc,
 OEORI_QtyPackUOM,OEORI_ItmMast_DR->ARCIM_BillingUOM_DR->CTUOM_Desc,OEORI_ItmMast_DR->ARCIM_BillingUOM_DR,
	    OEORI_Priority_dr,OEORI_Priority_dr->OECPR_Desc,
	    OEORI_Itemstat_dr,OEORI_Itemstat_dr->OSTAT_Desc,
	    OEORI_PHFreq_DR,OEORI_PHFreq_DR->PHCFR_Desc1,
	    OEORI_Instr_DR,OEORI_Instr_DR->PHCIN_Desc1,
	    OEORI_Durat_DR,OEORI_Durat_DR->PHCDU_Desc1,
	    OEORI_RecDep_DR,OEORI_RecDep_DR->CTLOC_Desc,
	    OEORI_UserDepartment_DR,OEORI_UserDepartment_DR->CTLOC_Desc,
	    OEORI_Doctor_DR,OEORI_Doctor_DR->CTPCP_Desc,OEORI_UserAdd,OEORI_UserAdd->SSUSR_Name,
	    OEORI_Billed,OEORI_AdministerSkinTest,OEORI_BBExtCode,
	    OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
	    OEORI_SeqNo,OEORI_LinkNo,OEORI_LinkToOrder,OEORI_PrescNo,OEORI_LabEpisodeNo,
	    OEORI_ARCOS_DR,OEORI_BBExtCode,OEORI_OEORI_DR,OEORI_PhSpecInstr,OEORI_Price,
	    OEORI_CoverMainIns,OEORI_Action_DR,OEORI_Action_DR->ACT_Desc,OEORI_FillerNo,OEORI_Date,
	    OEORI_TimeOrd
 INTO :OrderItemRowid,:ARCIMRowid,:OrderName,:OrderSttDate,:OrderSttTime,:StartDate,
:OrderDoseQty,:OrderDoseUOMRowid,:OrderDoseUOM,:OrderPackQty,:OrderPackUOM,:OrderPackUOMRowid,
:OrderPriorRowid,:OrderPrior,:OrderStatusRowid,:OrderStatus,:OrderFreqRowid,:OrderFreq,
:OrderInstrRowid,:OrderInstr,:OrderDurRowid,:OrderDur,
:OrderRecDepRowid,:OrderRecDep,:OrderUserDepRowid,:OrderUserDep,
:OrderDocRowid,:OrderDoc,:OrderUserAddRowid,:OrderUserAdd,
:OrderBilled,:OrderSkinTest,:OrderBillTypeRowid,:OrderType,
:OrderSeqNo,:OrderMasterSeqNo,:OrderLinkTo,:OrderPrescNo,:OrderLabEpisodeNo,
:OrderARCOSRowid,:OrderBillTypeRowid,:LinkOrderItem,:OrderPhSpecInstr,:OrderPrice,
:OrderCoverMainIns,:OrderActionRowid,:OrderAction,:FillerNo,:DateAdd,:TimeAdd
 From SQLUser.OE_OrdItem 
 WHERE OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID and OEORI_SttDat>=:Today and
 (OEORI_ItemStat_DR->OSTAT_Code='I') Order By OEORI_SttDat desc)
 &SQL(OPEN OrdCur1)
 For  &SQL(FETCH OrdCur1) QUIT:SQLCODE  do
	. ;OrderDepProcNote,Spec,OrderBaseUOMRowid,OrderMaxDurRowid
	. s billed=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),3)),"^",5)
	. q:(billed="P")&(ShowPaidOrder'="1")
	. s subcat=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
	. //实习医嘱不走此判断，否则未核实医嘱无法通过审核
	. //Q:(NoDisplayItemCat'="")&(subcat'="")&(("^"_NoDisplayItemCat_"^")[("^"_subcat_"^"))
	. ;非本科室医嘱退出
	. ;Q:OrderUserDepRowid'=%session.Get("LOGON.CTLOCID")
	. ;非实习医生医嘱退出
	. //Q:..practice(OrderDocRowid)'=1
	. ;住院非新开长嘱不显示
	. Q:(PAADMType="I")&(FillerNo'="")
	. s DateTimeAdd=$g(DateAdd)_$g(TimeAdd)
	. ;下医嘱时间超过半小时则不显示
	. ;Q:(CurrDateTime-DateTimeAdd)>1800
	. s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
	. s orcatdesc=""
	. i orcat'="" s orcatdesc=$p($g(^OEC("ORCAT",orcat)),"^",2)
	. s RecDepDesc=$p(OrderRecDep,"-",2)
	. i RecDepDesc'="" s OrderRecDep=RecDepDesc
	
	. s UserDep=$p(OrderUserDep,"-",2)
	. i UserDep'="" s OrderUserDep=UserDep
	. i OrderType'="P" d
	. . ;s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	. . s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,OrderRecDepRowid)
	. . ;w retPrice,!
	. . s OrderPrice=$P(retPrice,"^",1)
	. . s DiscPrice=$P(retPrice,"^",2)
	. . s InsPrice=$P(retPrice,"^",3)
	. . s PatPrice=$P(retPrice,"^",4)
	. s OrderSum=OrderPackQty*OrderPrice
	. i OrderBillTypeRowid="" s OrderBillType="自费"
	. e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
	. i OrderDoseQty'="" d
	. . i OrderDoseQty<1 s OrderDoseQty="0"_$number(OrderDoseQty)
	. i OrderType'="R" d
	. .s DoseqtySum=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),1)),"^",12)
	. .s OrderPackQty=DoseqtySum
	. s OrderPackUOM=$p(OrderPackUOM,"(",1)
	. s OrderSum=OrderPackQty*OrderPrice
	. i OrderPackQty'="" d
	. . i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
	. s DepProcNotes=$g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DEP",1))
	. s OrderLabSpec=..GetLabSpec(OrderItemRowid)
	. s OrderLabExCode=""
	. s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	. s OrderAutoCalculate=1
	. s OrderFile1=$p($g(^ARCIM($p(ARCIMRowid,"||",1),1,9)),"^",5)
	. s OrderFile2=$p($g(^ARCIM($p(ARCIMRowid,"||",1),1,9)),"^",19)
	. s OrderFile3=$p($g(^ARCIM($p(ARCIMRowid,"||",1),1,9)),"^",20)
	. s Data1=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes,OrderPhSpecInstr,OrderLabSpec,OrderAutoCalculate,OrderCoverMainIns,OrderActionRowid,OrderAction,OrderFile1,OrderFile2,OrderFile3)
	. i LinkOrderItem="" s ^||CacheTemp("DHCFindOrdItem",$j,"master",OrderItemRowid)=Data1
	. e  d
	. .if '$D(^||CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItem)) d
	. ..s ^||CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItem)=""
	. .s ^||CacheTemp("DHCFindOrdItem",$j,"master",LinkOrderItem,"sub",OrderItemRowid)=Data1
	&SQL(CLOSE OrdCur1)
	;m ^zhou("b")=^||CacheTemp("DHCFindOrdItem")
	s SeqNo=0
	s mas=0 for  s mas=$O(^||CacheTemp("DHCFindOrdItem",$j,"master",mas)) q:mas=""  d
	. s s1=^||CacheTemp("DHCFindOrdItem",$j,"master",mas)
	. i s1'="" d 
	. .s SeqNo=SeqNo+1
	. .s $List(s1,22)=SeqNo
	. .s Data=s1
	. .d OutputRow5
	. s SubSeqCount=0
	. s sub=0  for  s sub=$O(^||CacheTemp("DHCFindOrdItem",$j,"master",mas,"sub",sub)) q:sub=""  d
	. . s s2=^||CacheTemp("DHCFindOrdItem",$j,"master",mas,"sub",sub)
	. . i s1="" d
	. . . s SeqNo= SeqNo+1
	. . . s $List(s2,22)=SeqNo
	. . . s Data=s2
	. . . d OutputRow5
	. . e  d
	. . . s SubSeqCount=SubSeqCount+1
	. . . s SubSeqNo=SeqNo_"."_SubSeqCount
	. . . s $List(s2,22)=SubSeqNo
	. . . s Data=s2
	. . . d OutputRow5
	k ^||CacheTemp("DHCFindOrdItem",$j,"master")

 i ind=1 d
 . do ResetVariables5
 . set Data=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes,OrderPhSpecInstr,OrderLabSpec,OrderAutoCalculate,OrderCoverMainIns,OrderActionRowid,OrderAction,OrderFile1,OrderFile2,OrderFile3,OrderLabExCode)
 . Do OutputRow5	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow5
 ;set Data=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes)
 Set ^||CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
ResetVariables5
 set (OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes,OrderPhSpecInstr,OrderLabSpec,OrderAutoCalculate,OrderCoverMainIns,OrderActionRowid,OrderAction,OrderFile1,OrderFile2,OrderFile3,OrderLabExCode)=""
 Quit
}

ClassMethod GetLabSpec(OrderItemRowid As %String) As %String
{
 s SpecStr=""
 s OrderRowid=$p(OrderItemRowid,"||",1)
 s Childsub=$p(OrderItemRowid,"||",2)
 s spec=0 for  s spec=$o(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)) QUIT:spec=""  do
 . s SpecCode=$P($g(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)),"^",1)
 . s SpecDesc=$p($G(^TTAB("SPEC",SpecCode)),"\",1)
 . i SpecStr="" s SpecStr=SpecDesc
 . e  s SpecStr=SpecStr+","+SpecDesc
 Q SpecStr

 s Ord=+OrderItemRowid
 s Sub=$P(OrderItemRowid,"||",2)
 s retno=""
 q:Ord="" retno
 q:'$d(^OEORD(Ord,"I",Sub,1)) retno
 s ItmMastDR=$p(^OEORD(Ord,"I",Sub,1),"^",2)
 q:ItmMastDR="" retno
 s arcsub=$p(ItmMastDR,"||",2)
 q:arcsub="" retno
 s excode=""
 s chl=0 f  s chl=$o(^ARCIM(+ItmMastDR,arcsub,"EXT",chl)) q:chl=""  d
 .s tod=$p(^ARCIM(+ItmMastDR,arcsub,"EXT",chl),"^",2)
 .q:(tod'="")&(tod<+$h)
 .s excode=$p(^ARCIM(+ItmMastDR,arcsub,"EXT",chl),"^",4)
 q:excode="" retno
	s contdr=$o(^TTAB("TS",excode,"SC",""))
	q:contdr="" retno
	s specdr=$o(^TTAB("TS",excode,"SC",contdr,""))
	q:specdr="" retno  
	s specdesc=$p($G(^TTAB("SPEC",specdr)),"\",1)
	q specdesc
}

Storage Default
{
<Data name="UpUAOrdDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DtPortal.Doctor.Un6EB2.UpUAOrdD</DataLocation>
<DefaultData>UpUAOrdDefaultData</DefaultData>
<IdLocation>^DtPortal.Doctor.Un6EB2.UpUAOrdD</IdLocation>
<IndexLocation>^DtPortal.Doctor.Un6EB2.UpUAOrdI</IndexLocation>
<StreamLocation>^DtPortal.Doctor.Un6EB2.UpUAOrdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
