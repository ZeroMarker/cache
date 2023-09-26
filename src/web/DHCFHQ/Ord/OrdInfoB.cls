/// 获取医嘱基本信息
Class web.DHCFHQ.Ord.OrdInfoB Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetOrdByOrdId(OrdId As %String = "") As %String
{
	;w ##class(web.DHCFBOrdGet).GetOrdByOrdId("148||1")
	s del="^",RetStr=""
	q:($g(OrdId)="") RetStr
	s OrdId1=$p(OrdId,"||",1),OrdId2=$p(OrdId,"||",2)
	q:'$d(^OEORD(OrdId1,"I",OrdId2)) RetStr
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime=""
	s ArcimDesc="",OrdLoc="",RecDep="",AdmLoc="",BillStatus="",OeoriDr="",PrescNo=""
	s StopDoctorCode="",AdmLocCode="",DoctorCode="",OrdLocCode=""
	s StopDate="",StopTime="",StopDoctor=""
	s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
	s ArcimId=$p(ordstr1,del,2)
	s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
	q:ArcStr="" ""
	s SeqNo=$p(ordstr3,del,4)
	S SeqNo=$g(SeqNo)
	s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3),OrdUnit=$p(ArcStr,del,9)
	if SeqNo["." s ArcimDesc="__"_ArcimDesc
	s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=$zd(OrdCreateDate,3)
	s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=$zt(OrdCreateTime,2)
	s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
	s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=$zt(OrdStartTime,2)
	s OrdLoc=$p(ordstr1,del,3) ;开单科室
	s:OrdLoc'="" OrdLocCode=$p(^CTLOC(OrdLoc),del,1),OrdLoc=$p(^CTLOC(OrdLoc),del,2)
	s PrescNo=$p(ordstr1,del,14)  ;处方号
	s StopTime=$p(ordstr2,del,15) ;停止时间
	s:StopTime'="" StopTime=$zt(StopTime,2)
	s RecDep=$p(ordstr3,del,6)  ;接收科室
	s:RecDep'="" RecDepCode=$p(^CTLOC(RecDep),del,1),RecDep=$p(^CTLOC(RecDep),del,2)
	s PatNo=$p(ordstr3,del,9) ;病人登记号
	s StopDoctor=$p(ordstr3,del,29) ;停止医生
	s:StopDoctor'="" StopDoctorCode=$p($g(^CTPCP(StopDoctor,1)),del,1),StopDoctor=$p($G(^CTPCP(StopDoctor,1)),del,2)
	s StopDate=$p(ordstr3,del,34) ;停止日期
	s:StopDate'="" StopDate=$zd(StopDate,3)
	s DoseQty=$p(ordstr2,del,1),DoseUnit=$p(ordstr2,del,3) ;剂量单位
	S:DoseQty="NaN" DoseQty=""
	s:DoseUnit'="" DoseUnit=$p(^CT("UOM",DoseUnit),del,2)
	s PackageQty=$p($g(ordstr1),del,12)
	s Priority=$p(ordstr1,del,8)  ;医嘱优先级
	s:$g(Priority)="" Priority=""
	s:$g(Priority)'="" Priority=$p(^OECPR(Priority),del,2)
	s PHFreq=$p(ordstr2,del,4)
	s:$g(PHFreq)'="" PHFreq=$p(^PHCFR(PHFreq),del,1)
	s:$g(PHFreq)="" PHFreq=""
	s Instr=$p(ordstr2,del,7)
	s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,1)
	s:$g(Instr)="" Instr=""
	s OrdStatus=$p(ordstr1,del,13)
	s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),del,2)
	s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
	s Dura=$p(ordstr2,del,6)
	s:$g(Dura)'="" Dura=$p(^PHCDU(Dura),del,3)
	s:$g(Dura)="" Dura=""
	s doctor=$p(ordstr1,del,11)
	s:$g(doctor)'="" DoctorCode=$p(^CTPCP(doctor,1),"^",1),doctor=$p(^CTPCP(doctor,1),"^",2)
	s:$g(doctor)="" doctor=""
	//计费情况
	s BillStatus=$p(ordstr3,del,5)  ;记费壮态
	s ChargeStatus=""
	s:BillStatus="P" ChargeStatus="已结算"
	s:BillStatus="B" ChargeStatus="已做账单"
	s:BillStatus="TB" ChargeStatus="未做账单"
	s:BillStatus="I" ChargeStatus="取消收费"
	s BillStatus=ChargeStatus
	s DspInfo=..GetOrdDspNum(OrdId) //摆药情况
	s DspQty=$p(DspInfo,del,1),DspQtyRetNum=$p(DspInfo,del,2)
	s OrdCost=..GetOrdCost(OrdId)
	s OrdCost=$p(OrdCost,"@",1)
	s BillQty=$p(OrdCost,del,1),Costs=$p(OrdCost,del,2)
	s OrdExecStr=..GetExec(OrdId)   //执行情况
	if OrdExecStr'="" d
	.s OrdExec=$p(OrdExecStr,"*",1)
	.s ExecCareProvId=$p(OrdExec,del,1)
	.s OrdExecCode=$p(OrdExec,del,2),OrdExecName=$p(OrdExec,del,3),OrdExecDate=$p(OrdExec,del,4)
	;b:OrdExecCode=""
	s AdmLoc=$p(ordstr9,del,2)
	s:AdmLoc'="" AdmLocCode=$p(^CTLOC(AdmLoc),"^",1),AdmLoc=$p(^CTLOC(AdmLoc),"^",2)
	s OeoriDr=$p(ordstr11,del,39) ;组合医嘱的的ID
	S RetStr=OrdId_del_OrdCreateDate_del_OrdCreateTime_del_OrdStartDate_del_OrdStartTime_del_ArcimCode_del_ArcimDesc_del_OeoriDr_del_DoseQty_del_DoseUnit_del_Priority_del_PHFreq_del_Instr_del_doctor_del_OrdStatus_del_Dura_del_OrdLoc
	S RetStr=RetStr_del_RecDep_del_AdmLoc_del_BillStatus_del_StopDate_del_StopTime_del_StopDoctor_del_PrescNo_del_PatNo
	s RetStr=RetStr_del_AdmLocCode_del_OrdLocCode_del_RecDepCode_del_StopDoctorCode_del_DoctorCode_del_PackageQty_del_OrdUnit_del_DspQty_del_DspQtyRetNum_del_BillQty_del_Costs_del_$g(OrdExecCode)_del_$g(OrdExecName)_del_$g(OrdExecDate)_del_SeqNo
	;W OrdId,OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimCode,ArcimDesc,OeoriDr,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OrdLoc
	;      1			2		       3		4			5			6			7		8	9		10	   		 11	    12	 	13	14     		15 	16		17
	; RecDep,AdmLoc,BillStatus,StopDate,StopTime,StopDoctor,PrescNo,PatNo,AdmLocCode,OrdLocCode,RecDepCode,StopDoctorCode,DoctorCode,PackageQty,OrdUnit
	;    18		19		20			21		22          23    24		25    26          27           28      29           30          31          32 
	;DspQty,DspQtyRetNum,BillQty,Costs,$g(OrdExecCode),OrdExecName,OrdExecDate,SeqNo
	; 33        34        35      36     37             38          39          40
	q RetStr
}

ClassMethod GetOrdItem(ByRef repid As %Integer = 0, AdmId As %String = "", OrdCatSubId As %String = "", ArcId As %String = "") As %Integer
{
	s del="^",AdmType="",RetNum=0
	q:($g(AdmId)="") RetNum
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	q:OrdId1=""
	s OrdId2=0
	set NoDisplayItemCat=##class(web.DHCDocConfig).GetConfigNode("NoDisplayItemCat")
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s OrdId=OrdId1_"||"_OrdId2
	.S OrdInfo=..GetOrdByOrdId(OrdId)
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	.s ArcimId=$p(ordstr1,del,2)
	.q:((ArcId'="")&(ArcimId'=ArcId))
	.s subcat=$p($g(^ARCIM(+ArcimId,1,1)),"^",10)
	.Q:(NoDisplayItemCat'="")&(subcat'="")&(("^"_NoDisplayItemCat_"^")[("^"_subcat_"^"))
	.s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
	.q:ArcStr=""
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.s ArcUnit=$p(ArcStr,del,9)
	.s OrdCreateDate=$p(OrdInfo,del,2)
	.s SeqNo=$p(OrdInfo,del,39)
	.if SeqNo["." s ArcimDesc="____"_ArcimDesc
	.s OrdCreateTime=$p(OrdInfo,del,3)
	.s OrdStartDate=$p(OrdInfo,del,4)
	.s OrdStartTime=$p(OrdInfo,del,5)
	.s PackageNum=$p(OrdInfo,del,31)
	.s DoseQty=$p(OrdInfo,del,9),DoseUnit=$p(OrdInfo,del,10)
	.S:DoseQty="NaN" DoseQty=""
	.s Priority=$p(OrdInfo,del,11)
	.s PHFreq=$p(OrdInfo,del,12)
	.s Instr=$p(OrdInfo,del,13)
	.s OrdStatus=$p(OrdInfo,del,15)
	.s billstatus=$p(OrdInfo,del,20)
	.s ChargeStatus=""
	.s:billstatus="P" ChargeStatus="已结算"
	.s:billstatus="B" ChargeStatus="已做账单"
	.s:billstatus="TB" ChargeStatus="未做账单"
	.s:billstatus="I" ChargeStatus="取消收费"
	.s Dura=$p(OrdInfo,del,16)
	.s doctor=$p(OrdInfo,del,14)
	.S OrdUnit=ArcUnit
	.s StopDoctor=$p(OrdInfo,del,23)
	.;if ((DoseUnit="")&(DoseQty="")) s DoseUnit=ArcUnit,DoseQty=PackageNum
	.if ((DoseUnit="")&(DoseQty'="")) s DoseUnit=ArcUnit
	.if PackageNum="" s ArcUnit=""
	.s PackageNum=PackageNum_ArcUnit
	.s DspQty=$p(OrdInfo,del,33),DspQtyRetNum=$p(OrdInfo,del,34)
	.s OrdExecDate="",OrdExecName="",BillQty="",Costs=""
	.s BillQty=$p(OrdInfo,del,35),Costs=$p(OrdInfo,del,36)
	.if BillQty'="" s BillQty=BillQty,Costs=Costs_"元"
	.s OrdExecName=$p(OrdInfo,del,37),OrdExecDate=$p(OrdInfo,del,38)
	.if $g(SeqNo)="" s SeqNo=0
	.s ^CacheTempFHQ(repid,0,OrdStartDate,OrdStartTime,$g(SeqNo))=$LB($g(OrdCreateDate),$g(OrdCreateTime),$g(OrdStartDate),$g(OrdStartTime),$g(ArcimDesc),$g(DoseQty),$g(DoseUnit),$g(Priority),$g(PHFreq),$g(Instr),$g(doctor),$g(OrdStatus),$g(Dura),$g(ChargeStatus),$g(PackageNum),$g(ArcUnit),$g(SeqNo),$g(Costs),$g(DspQty),$g(DspQtyRetNum),$g(BillQty),$g(OrdExecName),$g(OrdExecDate),$g(StopDoctor))
	s OrdCreateDate="",OrdCreateTime="",SeqNo="",RetNum=0
	Q:'$D(^CacheTempFHQ(repid,0)) 0
	f  s OrdCreateDate=$o(^CacheTempFHQ(repid,0,OrdCreateDate),-1) q:OrdCreateDate=""  d
	.f  s OrdCreateTime=$o(^CacheTempFHQ(repid,0,OrdCreateDate,OrdCreateTime),-1) q:OrdCreateTime=""  d
	..f  s SeqNo=$o(^CacheTempFHQ(repid,0,OrdCreateDate,OrdCreateTime,SeqNo)) q:SeqNo=""  d
	...s RetNum=RetNum+1
	...s ^CacheTempFHQ(repid,RetNum)=$g(^CacheTempFHQ(repid,0,OrdCreateDate,OrdCreateTime,SeqNo))
	...
	q RetNum
}

/// 得到医嘱发药和退药的数量
ClassMethod GetOrdDspNum(OrdId As %String) As %String
{
	s del="^"
	s DspId=0,circleflag=1,DspQtyNum=0,DspQtyRetNum=0
	q:$g(OrdId)="" ""_del_""
	f  s DspId=$o(^DHCOEDISQTY(0,"OEORI",OrdId,DspId)) q:((DspId=""))  d
	.s DspFlag=$p(^DHCOEDISQTY(DspId),del,7)
	.s DspQty=$p(^DHCOEDISQTY(DspId),del,5)
	.S UomId=$p(^DHCOEDISQTY(DspId),del,6)
	.s Uom=$p($g(^CT("UOM",UomId)),del,2)
	.if DspFlag="C" s DspQtyNum=+DspQtyNum+DspQty
	.if DspFlag="R" s DspQtyRetNum=DspQtyRetNum+DspQty
	if $g(DspQtyNum)=0 s DspQtyNum=""
	else  s DspQtyNum=DspQtyNum_$g(Uom)
	if $g(DspQtyRetNum)=0 s DspQtyRetNum=""
	else  s DspQtyRetNum=DspQtyRetNum_$g(Uom)
	S RetStr=$g(DspQtyNum)_"^"_DspQtyRetNum
	q RetStr
}

ClassMethod GetOrdCost(OrdId As %String) As %String
{
	s del="^",del1="@"
	q:$g(OrdId)="" ""
	
	S OrdId1=$p(OrdId,"||",1),OrdId2=$p(OrdId,"||",2)
	q:'$d(^OEORD(OrdId1)) ""
	q:'$d(^OEORD(OrdId1,"I",OrdId2)) ""
	;S PbOIdDr=$p(^OEORD(OrdId1,"I",OrdId2,1),del,16)
	b 
	q:'$d(^DHCPBi(0,"OEORI",OrdId)) ""
	s PbId=""
	f  s PbId=$o(^DHCPBi(0,"OEORI",OrdId,PbId)) q:PbId=""  d
	.s PbOId=""
	.s OrdBillQty=0,OrdTotalAmount=0
	.f  s PbOId=$o(^DHCPBi(0,"OEORI",OrdId,PbId,PbOId)) q:PbOId=""  d
	..s PbDId=""
	..f  s PbDId=$o(^DHCPB(PbId,"O",PbOId,"D",PbDId)) q:PbDId=""  d
	...s TarId=$p(^DHCPB(PbId,"O",PbOId,"D",PbDId),del,3)
	...s TarQty=$p(^DHCPB(PbId,"O",PbOId,"D",PbDId),del,5)
	...s TarTotalAmount=$p(^DHCPB(PbId,"O",PbOId,"D",PbDId),del,7)
	...s TarPatShare=$p(^DHCPB(PbId,"O",PbOId,"D",PbDId),del,10)
	...s:$g(TarStr)'="" TarStr=TarStr_del1_TarId_del_TarQty_del_TarTotalAmount_del_TarPatShare
	...s:$g(TarStr)="" TarStr=TarId_del_TarQty_del_TarTotalAmount_del_TarPatShare
	..s OrdBillQty=OrdBillQty+$p(^DHCPB(PbId,"O",PbOId),del,5)
	..s OrdTotalAmount=OrdTotalAmount+$p(^DHCPB(PbId,"O",PbOId),del,11)
	..if OrdTotalAmount=0 s OrdTotalAmount="",OrdBillQty=""
	S RetStr=$g(OrdBillQty)_"^"_$g(OrdTotalAmount)_del1_$g(TarStr)
	q RetStr
}

ClassMethod GetTarCostByOrdId(OrdId As %String) As %String
{
	s del="^",del1="@"
	q:$g(OrdId)="" ""
	S OrdId1=$p(OrdId,"||",1),OrdId2=$p(OrdId,"||",2)
	q:'$d(^OEORD(OrdId1)) ""
	q:'$d(^OEORD(OrdId1,"I",OrdId2)) ""
	S PbOIdDr=$p(^OEORD(OrdId1,"I",OrdId2,1),del,16)
	q:$g(PbOIdDr)="" ""
	s PbId=$p(PbOIdDr,"||",1),PbOId=$p(PbOIdDr,"||",2)
	q:'$d(^DHCPB(PbId)) ""
	q:'$d(^DHCPB(PbId,"O",PbOId)) ""
	s PbDId=0,TarStr=""
	f  s PbDId=$o(^DHCPB(PbId,"O",PbOId,"D",PbDId)) q:PbDId=""  d
	.s TarId=$p(^DHCPB(PbId,"O",PbOId,"D",PbDId),del,3)
	.s TarQty=$p(^DHCPB(PbId,"O",PbOId,"D",PbDId),del,5)
	.s TarTotalAmount=$p(^DHCPB(PbId,"O",PbOId,"D",PbDId),del,7)
	.s TarPatShare=$p(^DHCPB(PbId,"O",PbOId,"D",PbDId),del,10)
	.s:TarStr'="" TarStr=TarStr_del1_TarId_del_TarQty_del_TarTotalAmount_del_TarPatShare
	.s:TarStr="" TarStr=TarId_del_TarQty_del_TarTotalAmount_del_TarPatShare
	s OrdBillQty=$p(^DHCPB(PbId,"O",PbOId),del,5)
	s OrdTotalAmount=$p(^DHCPB(PbId,"O",PbOId),del,11)
	if TotalAmount=0 s TotalAmount="",BillQty=""
	S RetStr=$g(OrdBillQty)_"^"_$g(OrdTotalAmount)_del1_TarStr
	q RetStr
}

ClassMethod GetExec(OrdId As %String) As %String
{
	s del="^",RetStr=""
	s ^Tmp("GetExec")=OrdId
	q:$g(OrdId)="" ""
	S OrdId1=$p(OrdId,"||",1),OrdId2=$p(OrdId,"||",2)
	q:'$d(^OEORD(OrdId1)) ""
	q:'$d(^OEORD(OrdId1,"I",OrdId2)) ""
	s OrdExId=0,ExecCareName="",ExecDate="",ExecQty=0
	s OrdStatusId=$p(^OEORD(OrdId1,"I",OrdId2,1),del,13)
	s ExecCareCode="",ExecCareProvId=""
	if OrdStatusId=6  d
	.;if 1=1  d
	.Q:'$D(^OEORD(OrdId1,"I",OrdId2,6))
	.s ExecDate=$p(^OEORD(OrdId1,"I",OrdId2,6),del,2)
	.q:$g(ExecDate)=""
	.s ExecDate=$zd(ExecDate,3)
	.s ExecCareProvId=$p(^OEORD(OrdId1,"I",OrdId2,6),del,4)
	.q:$g(ExecCareProvId)=""
	.if $d(^SSU("SSUSR",ExecCareProvId)) s ExecCareCode=$p($g(^SSU("SSUSR",ExecCareProvId)),del,1),ExecCareName=$p($g(^SSU("SSUSR",ExecCareProvId)),del,2)
	.else  s ExecCareName="无对应"
	if $g(ExecCareName)'="" s RetStr=ExecCareProvId_del_ExecCareCode_del_ExecCareName_del_ExecDate
	q:$g(ExecCareName)'="" RetStr
	q:'$d(^OEORD(OrdId1,"I",OrdId2,"X")) ""
	f  S OrdExId=$o(^OEORD(OrdId1,"I",OrdId2,"X",OrdExId)) q:((OrdExId="")!(ExecCareName'=""))  d
	.s ExecDate=$p(^OEORD(OrdId1,"I",OrdId2,"X",OrdExId),del,19)
	.q:$g(ExecDate)=""
	.s ExecDate=$zd(ExecDate,3)
	.s ExecCareProvId=$p(^OEORD(OrdId1,"I",OrdId2,"X",OrdExId),del,15)
	.q:$g(ExecCareProvId)=""
	.if $d(^CTPCP(ExecCareProvId)) s ExecCareName=$p($g(^CTPCP(ExecCareProvId,1)),del,2),ExecCareCode=$p(^CTPCP(ExecCareProvId),del,1)
	.else  s ExecCareName="无对应"
	.s ExecQty=ExecQty+1
	.if ExecQty=1 s RetStr=ExecCareProvId_del_ExecCareCode_del_$g(ExecCareName)_del_ExecDate
	.else  s RetStr=RetStr_"*"_ExecCareProvId_del_ExecCareCode_del_$g(ExecCareName)_del_ExecDate
	q RetStr
}

}
