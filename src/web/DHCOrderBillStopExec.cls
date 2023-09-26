Class web.DHCOrderBillStopExec Extends %RegisteredObject
{

ClassMethod FindOEOrdInfoByAdmNoExecute(ByRef qHandle As %Binary, PRowID, ARCDESC) As %Status
{
	s ^Temp("wanghc","info")=PRowID_"^"_ARCDESC
	Set repid=$I(^CacheTemp)
	set index=1
	s len=$l(ARCDESC)  
	s OEAdmDr=PRowID
	s ORowId=$o(^OEORD(0,"Adm",OEAdmDr,""))   
	i ORowId>0 d
	.s OIMDR=0  f  s OIMDR=$o(^OEORDi(0,"ARCIM",ORowId,OIMDR)) q:OIMDR=""  d
	..S ARCIM = +OIMDR
	..S ARCVersion = $p(OIMDR,"||",2)
	..s ARCIMDesc=$p(^ARCIM(ARCIM,ARCVersion,1),"^",2)
	..s ARCIMCode=$p(^ARCIM(ARCIM,ARCVersion,1),"^",1)
	..Q:(ARCDESC'="")&&(($e(ARCIMDesc,1,len)'=ARCDESC)&&('##class(web.DHCDocMain).MatchAlias(OIMDR,ARCDESC)))
	..d Outputrow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Outputrow                                                              
	;s Data=$lb(ARCIMDesc,CTPCPAllocatedDoc,OSTATDesc)
	s Data=$lb(ARCIMDesc,ARCIMCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCOrderBillStopExec","FindOEOrdInfoByAdmNo",13,"")
/// ,CTPCPAllocatedDoc:%String,OSTATDesc:%String
Query FindOEOrdInfoByAdmNo(PRowID, ARCDESC) As websys.Query(ROWSPEC = "ARCIMDesc:%String,ARCIMCode:%String")
{
}

/// @Param: IsAll   on:查询所有,其它:显示非停止的
Query Find(EpisodeID, StDate, EndDate, OrderDesc, IsDoctorOrder, IsExec, LongExec, ShortExec, IsAll) As websys.Query(ROWSPEC = "OESeqNo:%String:医嘱序号,TOrderExecId:%String:执行记录ID,TOrderDesc:%String:医嘱名称,TItemStatCode:%String:医嘱状态代码,TItemStatDesc:%String:医嘱状态,TExStDate:%String:要求执行时间,TExecStateDesc:%String:执行状态,TExecStateCode:%String:状态代码,TRealExecDate:%String:执行时间,TExecRes:%String:执行原因,TExecUser:%String:处理人,TExecLoc:%String:处理科室,TBillState:%String:帐单状态,TgiveDrugQty:%String:发药数量,TcancelDrugQty:%String:退药数量,TPBOID:%String:帐单号,TOrderTimeTimes:%String:时间次数,TOECPRDesc:%String:优先级,TOeoreOeoreDR:%String:父嘱ID,TDoctor:%String:开单医生")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, EpisodeID, StDate, EndDate, OrderDesc, IsDoctorOrder, IsExec, LongExec, ShortExec, IsAll) As %Status
{
	Set ^Temp("wanghc","xFind")="d ##class(%ResultSet).RunQuery(""web.DHCOrderBillStopExec"",""Find"","_EpisodeID_","_StDate_","_EndDate_","""_OrderDesc_""","""_IsDoctorOrder_""","""_IsExec_""","""_LongExec_""","""_ShortExec_""")"
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	if EpisodeID="" Set qHandle = $lb(0,repid,0) Q $$$OK
	if StDate="" Set StDate=+$h
	if EndDate="" Set EndDate=StDate
	if EndDate<StDate Set qHandle = $lb(0,repid,0) Q $$$OK
	//set (LongExec,ShortExec,IsDoctorOrder,IsExec)=""
	set IsLongOrder = ##class(websys.Conversions).BooleanHtmlToLogical(LongExec)
	set IsShortOrder = ##class(websys.Conversions).BooleanHtmlToLogical(ShortExec)
	//set IsDoctorOrder = ##class(websys.Conversions).BooleanHtmlToLogical(IsDoctorOrder)
	set IsExecBoolean = ##class(websys.Conversions).BooleanHtmlToLogical(IsExec)
	set IsAllBoolean =  ##class(websys.Conversions).BooleanHtmlToLogical(IsAll)
	set order = $o(^OEORD(0,"Adm",EpisodeID,""))
	;s pb=$o(^DHCPB(0,"ADM",EpisodeID,""))
	if order="" Set qHandle = $lb(0,repid,0) Q $$$OK
	Set ordItem=0 for  set ordItem=$o(^OEORDi(0,"OrdItem",order,ordItem)) q:ordItem=""  d 
	.Do InitOrderInfo
	.Set OESeqNo = $p(^OEORD(order,"I",ordItem,3),"^",4)
	.Set ArcimDr = $p(^OEORD(order,"I",ordItem,1),"^",2)
	.if ArcimDr'="" Set TOrderDesc = $p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",2)
	.q:(OrderDesc'="")&&(OrderDesc'=TOrderDesc)
	.Set TOrderStatusDR=$p(^OEORD(order,"I",ordItem,1),"^",13)
	.if +TOrderStatusDR>0 set TItemStatCode = $p(^OEC("OSTAT",TOrderStatusDR),"^",1),TItemStatDesc=$p(^OEC("OSTAT",TOrderStatusDR),"^",2)
	.quit:TItemStatCode="I"	;未审核的医嘱跳出,实习生下的医嘱
	.s ordDept = $p(^OEORD(order,"I",ordItem,1),"^",3)
	.s:+ordDept>0 deptDesc = $p(^CTLOC(ordDept),"^",2)
	.set TOrderPriorityDR=$p(^OEORD(order,"I",ordItem,1),"^",8)
	.if +TOrderPriorityDR>0 set TOECPRDesc=$p(^OECPR(TOrderPriorityDR),"^",2)	
	.q:('IsLongOrder&&##class(appcom.OEOrdItem).ISLongOrderPrior(TOrderPriorityDR))
	.q:('IsShortOrder&&##class(appcom.OEOrdItem).ISShortOrderPrior(TOrderPriorityDR))
	.i $d(^OEORD(order,"I",ordItem,1))=1 d
	..s DoctorDr=$p(^OEORD(order,"I",ordItem,1),"^",11)
	.s CTCPTInternalType=""
	.i DoctorDr>0 d		
	..s CTPCPCarPrvTpDR = $p(^CTPCP(DoctorDr,1),"^",4)
	..s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
	.q:(IsDoctorOrder="on")&&(CTCPTInternalType'="DOCTOR")
	.q:(IsDoctorOrder'="on")&&(CTCPTInternalType="DOCTOR")	;查询非医生下的(包含护士下的,和滚医嘱出来的).
	.i $d(^OEORD(order,"I",ordItem,1))=1 s DoctorDr=$p(^OEORD(order,"I",ordItem,1),"^",11)
	.s:+$g(DoctorDr)>0 TDoctor = $p(^CTPCP(DoctorDr,1),"^",2),DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
	.s packUomQty=$p($g(^OEORD(order,"I",ordItem,9)),"^",4)
	.s phOrdQty=$p($g(^OEORD(order,"I",ordItem,1)),"^",12)
    .i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
    .s doseQty=$p($g(^OEORD(order,"I",ordItem,2)),"^",1)
    .i doseQty'="" s unitUomId=$p($g(^OEORD(order,"I",ordItem,2)),"^",3)
    .i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    .i (phOrdQty'="") s TgiveDrugQty=phOrdQty_" "_$g(unitDesc)
    .s packUomQty=$p($g(^OEORD(order,"I",ordItem,9)),"^",4)
    .s packUomId=+$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),8),"^",14)
    .i (packUomId'=0)&(packUomQty'="") d
    ..s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
    .s dipUomId=$p($g(^OEORD(order,"I",ordItem,"DHC")),"^",13)
    .i (+dipUomId)'=0 s packUomDesc=$p($g(^CT("UOM",dipUomId)),"^",2)
    .i packUomQty'=""  s TgiveDrugQty=packUomQty_" "_$g(packUomDesc)
	.;set TgiveDrugQty = ##class(web.DHCDocMain).GetQtyAndUom(order,ordItem)
	.set ChargePartial = $p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),7)),"^",15)	;ARCIM_ChargePartial，Y表示部分结账
	.s DrgformRowid = $p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",12) ;PHC_DrgForm
	.i DrgformRowid>0 d
	..set DeductPartially= $p(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),2),"^",6) ;PHCDF_DeductPartially，Y表示住院按一天用量计算
	.for tempDate = StDate:1:EndDate d
	..q:$d(^OEORDi(0,"OrdItem",order,ordItem,tempDate))'=10
	..set times=1
	..set orderExecId=0 for  set orderExecId=$o(^OEORDi(0,"OrdItem",order,ordItem,tempDate,orderExecId)) q:orderExecId=""  d		
	...Do InitOrderExecInfo
	...Do Outputrow
	Set parent=""
	for  set parent = $o(^||ExecOrderTempRow(parent)) q:parent=""  d 
	.if ($d(^||ExecOrderTempRow(parent))=11) || ($d(^||ExecOrderTempRow(parent))=1) d
	..set ind=ind+1
	..set ^CacheTemp(repid,ind) = ^||ExecOrderTempRow(parent)	
	.Set sub=""
	.for  Set sub = $o(^||ExecOrderTempRow(parent,sub)) q:sub=""  d 
	..set ind=ind+1
	..set ^CacheTemp(repid,ind) = ^||ExecOrderTempRow(parent,sub)
	
	set qHandle = $lb(0,repid,0)
	Q $$$OK
	
	
InitOrderInfo
	Set (TOrderDesc,TItemStatCode,TItemStatDesc,deptDesc,TOECPRDesc,TDoctor,TgiveDrugQty,ChargePartial,DeductPartially)=""
	Q
InitOrderExecInfo 	
	Set (TOrderExecId ,TExStDate ,TExecStateDesc ,TExecStateCode ,TRealExecDate ,TExecRes,TExecUser ,TExecLoc,TBillState,TPBOID,TcancelDrugQty,TOrderTimeTimes,TOeoreOeoreDR)=""
	Set TExecStateDesc="未执行",TExecStateCode="未执行"
	Set pbo=""
	Q
Outputrow
	set TOrderExecId = order_"||"_ordItem_"||"_orderExecId
	Set exeg = ^OEORD(order,"I",ordItem,"X",orderExecId)
	Set exegBill = $g(^OEORD(order,"I",ordItem,"X",orderExecId,"BILL"))
	Set ExStDate = $p(exeg,"^",1)
	If ExStDate'="" Set ExStDate = $zd(ExStDate,3)
	Set ExStTime = $p(exeg,"^",2)			// OEORE_ExStTime
	If ExStTime'="" Set ExStTime=$zt(ExStTime,2)
	Set TExStDate = ExStDate_","_ExStTime
	Set ExecStateDR= $p(exeg,"^",16)	
	If +ExecStateDR>0 Set TExecStateDesc = $p(^OEC("STAT",ExecStateDR),"^",2),TExecStateCode=$p(^OEC("STAT",ExecStateDR),"^",1)	;OEC_Order_AdminStatus
	quit:IsExecBoolean&&(TExecStateCode'="F")
	quit:'IsAllBoolean&&(TExecStateCode="D")
	set TExecDate = $p(exeg,"^",19)		// OEORE_DateExecuted
	set TExecTime = $p(exeg,"^",20)		// OEORE_TimeExecuted
	if TExecTime'="" set TExecDate=$zd(TExecDate,3),TExecTime=$zt(TExecTime,2),TRealExecDate=TExecDate_","_TExecTime
	;执行的原因
	if $d(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH"))=10 d
	.Set STCHSub = $o(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH",""),-1)		;OE_OrdExecStatus
	.Set:STCHSub>0 ExecResDr = $p(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH",STCHSub),"^",2) ;STCH_Reason_DR
	.Set:ExecResDr>0 TExecRes= $p(^OEC("ASCR",ExecResDr),"^",2)	;OEC_AdminStatusChReason->ASCR_Desc
	Set CtpcpDR = $p(exeg,"^",15)
	Set:(+CtpcpDR>0)&&($d(^CTPCP(CtpcpDR,1))=1) TExecUser = $p(^CTPCP(CtpcpDR,1),"^",2)
	Set TExecLoc = deptDesc
	set TBillState = $p(exeg,"^",6)
	set TBillState=$s(TBillState="B":"计费", TBillState="P":"结算", TBillState="I":"停止后未做账单", TBillState="R":"已退费",1:"需要计费") ;TBillState="TB":"需要计费", 
	set drugRtnInfo=##class(web.DHCSTCOMMONSRV).GetDispReturnQty(TOrderExecId) ;返回：发药数量^退药数量
	;set TgiveDrugQty = $p(drugRtnInfo,"^",1)
	set TcancelDrugQty = $p(drugRtnInfo,"^",2)
	;OEORI_PHQTYORD
	if ChargePartial="Y",DeductPartially="Y" d
	.s DspRowID="",TColQty=0,TRefQty=0
    .f  s DspRowID=$o(^DHCOEDISQTY(0,"OEORE",TOrderExecId,DspRowID)) q:DspRowID=""  d
    ..s disp=^DHCOEDISQTY(DspRowID)
    ..s dspstatus=$P(disp,"^",7)
    ..s DspQty=$P(disp,"^",11)
    ..i dspstatus="C" Do
    ...s TColQty=TColQty+DspQty
    ..I dspstatus="R" Do
    ...s TRefQty=TRefQty+DspQty
	.set TgiveDrugQty = TColQty_$e(TgiveDrugQty,$l(TgiveDrugQty))
	.set TcancelDrugQty = TRefQty
	set pb=0, pbo=0 set pb = $o(^DHCPBi(0,"OEORI",order_"||"_ordItem,""))
	set:+pb>0 pbo=$o(^DHCPB(0,"OEEXC",TOrderExecId,pb,0))
	set:+pbo>0 TPBOID=pb_"||"_pbo	;set ind=ind+1
	Set TOeoreOeoreDR=$p(exegBill,"^",3)
	Set TOrderTimeTimes=ExStDate_",第"_times_"次"
	Set times=times+1
	Set:$d(^OEORD(order,"I",ordItem,11)) TOeoriOeoriDR = $p(^OEORD(order,"I",ordItem,11),"^",39)
				;"OESeqNo,TOrderExecId,TOrderDesc,TItemStatCode,TItemStatDesc,TExStDate,TExecStateDesc,TExecStateCode,TRealExecDate,    TExecRes,TExecUser,TExecLoc,TBillState,TgiveDrugQty,TcancelDrugQty,TPBOID,TOrderTimeTimes,TOECPRDesc,TOeoreOeoreDR,TDoctor")
	Set data=$lb(OESeqNo,TOrderExecId ,TOrderDesc ,TItemStatCode,TItemStatDesc,TExStDate ,TExecStateDesc ,TExecStateCode ,TRealExecDate ,TExecRes,TExecUser ,TExecLoc,TBillState,TgiveDrugQty,TcancelDrugQty,TPBOID,TOrderTimeTimes,TOECPRDesc,TOeoreOeoreDR,TDoctor)
	if TOeoreOeoreDR="" Set ^||ExecOrderTempRow(TOrderExecId)=data
	else  Set ^||ExecOrderTempRow(TOeoreOeoreDR,TOrderExecId)=data
	Quit
}

ClassMethod GetPatientBaseInfo(EpisodeID)
{
	s name="",bedno="",age="",sex="",weight="",ipno="",insu="",ipdate=""
	s papmi = +^PAADM(EpisodeID)
	q:'$d(^PAPER(papmi)) "{}"
	s:$d(^PAPER(papmi,"ALL")) name = $p(^PAPER(papmi,"ALL"),"^",1)
	s:$d(^PAADM(EpisodeID)) beddr = $p(^PAADM(EpisodeID),"^",73)
	s:+beddr>0 bedno=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)	
	s sexDr=$p(^PAPER(papmi,"ALL"),"^",7) 
	i sexDr'="" s sex=$p(^CT("SEX",sexDr),"^","2")
	s weight=""   //##class(web.DHCDocInPatientList).GetWeight(EpisodeID)
	s age = ##class(web.PAPerson).calculateAgeUnitsShow(papmi)
	//s ipno = ##class(web.DHCDocMainOrderInterface).IGetMrNoByEpisodeID(EpisodeID)
	s:$d(^PAPER(papmi,"PAT",1)) ipno =$p(^PAPER(papmi,"PAT",1),"^",1)
	s insu = $p(^PAADM(EpisodeID,1),"^",7) ;PAADMAdmReasonDR
	s:insu'="" insu=$p(^PAC("ADMREA",insu),"^",2)
	s ipdate = $p(^PAADM(EpisodeID),"^",6)
	s:ipdate'="" ipdate=$zd(ipdate,3)
	s admDept = $p(^PAADM(EpisodeID),"^",4)
	s:+admDept>0 TdeptDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(admDept)
	s admNo = $p(^PAADM(EpisodeID),"^",81)
	
	s jsonObj = ##class(ext.util.JsonObject).%New()
	d jsonObj.Put("name",name).Put("bedno",bedno).Put("age",age).Put("sex",sex)
	d jsonObj.Put("weight",weight).Put("ipno",ipno).Put("insu",insu).Put("date",ipdate).Put("admno",admNo)
	q jsonObj.Json()
}

/// -303 执行记录已停止不需再停止
ClassMethod StopExecItem(OEORERowId, UserRowId, ChangeReasonRowId As %String = "")
{
	Set nowdate = +$h, nowtime = $p($h,",",2),rtn=0
	Set orderParref=+OEORERowId,orderId=$p(OEORERowId,"||",2),execId=$P(OEORERowId,"||",3)
	Set OldStatusCode=""
	Set OldStatusRowId=$P(^OEORD(orderParref,"I",orderId,"X",execId),"^",16)
	if OldStatusRowId'="" s OldStatusCode=$P($G(^OEC("STAT",OldStatusRowId)),"^",1)
	Quit:(OldStatusCode="D") "-303"	
	
	Set orderg1 = ^OEORD(orderParref,"I",orderId,1)
	Set PriorityDR = $p(orderg1,"^",8)
	Set DoctorDr=$p(orderg1,"^",11)
	Set CTCPTInternalType=""
	If +DoctorDr>0 {
		s CTPCPCarPrvTpDR = $p(^CTPCP(DoctorDr,1),"^",4)
		s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)     
	}  

	s ExeOrderStatusId=$P($g(^OEORD(orderParref,"I",orderId,"X",execId,"BILL")),"^",1)
	s ExeStatusCode=$S(ExeOrderStatusId'="":$P($G(^OEC("OSTAT",ExeOrderStatusId)),"^",1),1:"")
	if ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR),ExeStatusCode'="C",ExeStatusCode'="D" Q "-314"
	if ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR)&&((CTCPTInternalType="NURSE")||(CTCPTInternalType="")){
		if (OldStatusCode="F"){
			
			s rtn = ##class(appcom.OEOrdExec).UpdateStatus(OEORERowId,"C",UserRowId,nowdate,nowtime,ChangeReasonRowId)
		}
		s rtn = ##class(appcom.OEOrdItem).Cancel(orderParref_"||"_orderId,UserRowId)
	}else{
		if (OldStatusCode="F"){
			;执行过-先撤销再停止
			
			s rtn = ##class(appcom.OEOrdExec).UpdateStatus(OEORERowId,"C",UserRowId,nowdate,nowtime,ChangeReasonRowId)
		}
		if rtn=0 {
		
			Set rtn=##class(appcom.OEOrdExec).UpdateStatus(OEORERowId,"D",UserRowId,nowdate,nowtime,ChangeReasonRowId)
		
			
		}
	}
	q rtn
}

/// @params: ExecIds 执行记录id串 id1^id2
ClassMethod StopExec(ExecIds, UserRowId, ChangeReasonRowId As %String = "") As %String
{
	s ^Temp("wanghc","execids")="w ##class(web.DHCOrderBillStopExec).StopExec("""_ExecIds_""","""_UserRowId_""","""_ ChangeReasonRowId_""")"
	Set len = $l(ExecIds,"^")	
	Set rtn=0,OEORERowId=0,OrderDesc=""
	for j=1:1:len {
		Set OEORERowId = $p(ExecIds,"^",j)
		s rtn = ..StopExecItem(OEORERowId,UserRowId, ChangeReasonRowId)
		if rtn="-303" set rtn=0 ;-303是已停止
		q:(rtn'=0)
	}
	if OEORERowId>0{
		s ItmMastDR = $p( $g(^OEORD(+OEORERowId,"O",$P(OEORERowId,"||",2),1)),"^",2)
		if ItmMastDR>0 Set OrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)
	}
	q rtn_"^"_OEORERowId_"^"_OrderDesc
}

ClassMethod SelectedCheckColumn(rowNum, OrderStatus, ExecStatus)
{
	Set Name = "TSelectedExecz"_rowNum
	if ExecStatus="D"{
		q "<input id="""_Name_""" name="""_Name_""" Disabled type=""checkbox"">"
	}else{
		q "<input id="""_Name_""" name="""_Name_""" type=""checkbox"" onclick=""SelectExecClickHandler(this)"">"
	}
}

}
