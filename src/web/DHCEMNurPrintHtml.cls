Import SQLUser

/// Creator: 	qqa
/// CreateDate: 2018-08-06
/// Descript: 急诊护士执行执行单打印	
Class web.DHCEMNurPrintHtml Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	获取打印列
/// w ##class(web.DHCEMNurPrintHtml).GetPrintTitle("")
ClassMethod GetPrintTitle(QueryCode, LgHospID)
{
	n (QueryCode,LgHospID)
	s LgHospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecFormSet",LgHospID)
	s MRowID="",MId=""
	f  s MRowID=$o(^DHCEMEFS(0,"Code",QueryCode,MRowID)) q:(MRowID="")||(MId'="")  d
	.s MHospID=$p(^DHCEMEFS(MRowID),"^",3)
	.q:(LgHospID'="")&&(LgHospID'=MHospID)
	.s MId=MRowID
	
	s ItmID=$o(^DHCEMEFSI(0,"ExecForm",+MId,"PrintSetList",""),-1)
	k TMPData("web.DHCEMNurPrintHtml","GetPrintTitle")
	
	q:+ItmID=0 "[]"
	
	s ListTitle="Desc^Width^Notes^Code^Number^IsMergeRow^IsOnlyShowMain"
	s Count=0
	w "["
	s ItmData=$p(^DHCEMEFSI(ItmID),"^",3)
	s Num=$l(ItmData,"##")
	f i=1:1:Num d
	.s Data=$p(ItmData,"##",i)
	.s Name=$p(Data,"|",1)
	.s Width=$p(Data,"|",2)
	.s OrdLinkID=$p(Data,"|",3)
	.s Desc="",Code=""
	.s:+OrdLinkID'=0 Desc=$p($g(^DHCCLNurseExec("Var",+OrdLinkID)),"^",1)
	.s:+OrdLinkID'=0 Code=$p($g(^DHCCLNurseExec("Var",+OrdLinkID)),"^",2)
	.i Code="" d
	..s CustCode=$p(Data,"|",6)
	..s:CustCode'="" Code=CustCode
	.s IsMergeRow=$p(Data,"|",4)
	.s IsOnlyShowMain=$p(Data,"|",5)
	.s DataList=Name_"^"_Width_"^"_Desc_"^"_Code_"^^"_IsMergeRow_"^"_IsOnlyShowMain
	.s Count = Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,DataList)
    w "]"
    q ""
}

/// Descrit:获取医嘱信息
/// w ##class(web.DHCEMNurPrintHtml).GetOrdInfo("4407||18||1^4407||18||2^4407||18||3","")
ClassMethod GetOrdInfo(OrderId, QueryCode, RowSpan)
{
	n (OrderId,QueryCode,RowSpan)
	
	k TMPDate("web.DHCEMNurPrintHtml","GetOrdInfo")
	s RetString = ##class(web.DHCEMNurPrintHtml).getExcuteOrderInfo(OrderId,QueryCode,1)
	s Len = $l(RetString,"^")
	f i=1:1:Len d
	.s Itm = $p(RetString,"^",i)
	.s ItmCode = $p(Itm,"@",1)
	.s ItmValue = $p(Itm,"@",2)
	.;s ItmValue = $tr(ItmValue," ","")
	.s ItmValue = $tr(ItmValue,$c(10),"")
	.q:ItmCode=""
	.s TMPDate("web.DHCEMNurPrintHtml","GetOrdInfo",ItmCode) = ItmValue
	
	
	s Del="""",Count=0
	w "{"
	s ItmCode=""
	f  s ItmCode = $o(TMPDate("web.DHCEMNurPrintHtml","GetOrdInfo",ItmCode)) q:ItmCode=""  d
	.s ItmValue = TMPDate("web.DHCEMNurPrintHtml","GetOrdInfo",ItmCode)
	.s Count = Count+1
    .w $case(Count,1:"",:",")
	.w Del_ItmCode_Del_":"
	.w Del_ItmValue_Del
	w ","
	w Del_"RowSpan"_Del_":"   //RowSpan:不包含子医嘱合并rowspan数目
	w Del_RowSpan_Del
	w "}"
	q ""
}

/// w ##class(web.DHCEMNurPrintHtml).getExcuteOrderInfo("4407||18||1","SYDO")
ClassMethod getExcuteOrderInfo(orderId, queryCode = "", IsAdd = "") As %String
{
	n (orderId, queryCode, IsAdd)
	q:(orderId="") ""
	k:IsAdd val

	i $g(^LabColor("Color","A"))="" d
	.d ..SetLabColor()
	s oeordId=$p(orderId,"||",1)
	s oeordSub=$p(orderId,"||",2)
	s oeoreSub=$p(orderId,"||",3)
	s episodeId=$p($g(^OEORD(oeordId)),"^",1)
	s patInfo=##class(web.DHCMGNurComm).PatInfo(episodeId)
	s val("age")=$p($p(patInfo,"^",7),"@",2)
	s val("regNo")=$p($p(patInfo,"^",1),"@",2)
	s val("patName")=$p($p(patInfo,"^",5),"@",2)
	s val("locDesc")=$p($p(patInfo,"^",2),"@",2)
	s val("bedCode")=$p($p(patInfo,"^",6),"@",2)
	s val("sex")=$p($p(patInfo,"^",4),"@",2)
	s val("ward")=$p($p(patInfo,"^",8),"@",2)
	s val("medCareNo")=$p($p(patInfo,"^",10),"@",2)
	s val("oeoriId")=orderId
	///床号
	s:val("bedCode")'="" val("bedCode")=val("bedCode")_"床"
	
	///座位号
	i val("bedCode")="" d
	.s bedInfo = ##class(web.DHCEMPatientSeat).GetPatSeatNo("",episodeId)  ///输液室座位
	.s val("bedCode")=$p(bedInfo,"!!",2)
	.s:val("bedCode")'="" val("bedCode")=val("bedCode")_"座"

	//取诊断  2013-11-21
	i episodeId'="" d
	.s mradmId=$p(^PAADM(episodeId),"^",61)
	.i mradmId'="" d
	..s dig=##class(Nur.NurseExcuteSheet).getDiag(mradmId) 
	..s val("dia")=dig


	//医嘱类型 ^OECPR({OECPR_RowId})    LX
	s oecprId=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",8) 
	i oecprId'=""  d
	.s oecprCode=$p($g(^OECPR(oecprId)),"^",2)
	.s val("orderType")=oecprCode

	///皮试结果
	s abnorm=$p($g(^OEORD(+oeordId,"I",oeordSub,11)),"^",3)
    s skin=$s(abnorm="N":" (-)",abnorm="Y":" (+)",abnorm="":"")

	s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2)   //lx 2013-10-29
	s arcimDr=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",2) 
	//医嘱名称
	s val("arcimDesc")=$P($G(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1)),"^",2)
	i $P(val("arcimDesc"),"}",2)'="" s val("arcimDesc")=$P(val("arcimDesc"),"}",2)
	s PriorityDesc=""
    s PriorityDr = $p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",8)
    s:+PriorityDr'=0 PriorityDesc = $p(^OECPR(PriorityDr),"^",2) 
    i PriorityDesc["自备药" s val("arcimDesc")=val("arcimDesc")_"(自备药)"
    i PriorityDesc["嘱托" s val("arcimDesc")=val("arcimDesc")_"(嘱托)"
    s:skin'="" val("arcimDesc")=val("arcimDesc")_skin
	
	s arcimDescJC=##Class(web.DHCAPPInterface).GetExaReqItemDesc(oeordId_"||"_oeordSub)
	s:arcimDescJC'="" val("arcimDesc")=arcimDescJC

	s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeordId_"||"_oeordSub)
	s val("arcimshortDesc")=$P($G(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1)),"^",3)

	//医生
	s doctorId=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",11)
	i doctorId'=""  s val("ctcpDesc")=$p($g(^CTPCP(doctorId,1)),"^",2)

	//用药途径
	s phcinId=$p($g(^OEORD(oeordId,"I",oeordSub,2)),"^",7) 
	i phcinId'="" s val("phcinDesc")=$p($g(^PHCIN(phcinId)),"^",2) 
	i $G(val("phcinDesc"))["-" s val("phcinDesc")=$p(val("phcinDesc"),"-",2)

	//频次
	s phcfrId=$p($g(^OEORD(oeordId,"I",oeordSub,2)),"^",4)
	i phcfrId'="" d
	.s val("phcfrCode")=##class(web.DHCEMOrdInfoVO).getPhcfrCode(oeordId,oeordSub)
	.s phcfrNum=$p($g(^PHCFR(phcfrId)),"^",2)
	.s val("phcfrNum")=phcfrNum

	//首次
	s oeoriQty=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",18)

	//要求执行日期时间
	i $g(val("phcfrCode"))'="" s val("sttDateTime")=##class(web.DHCLCNUREXCUTE).FreqTime(val("phcfrCode"))
	i oeoreSub'="" d
	.s sttDate=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub)),"^",1) 
	.s sttTime=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub)),"^",2) 


	i oeoreSub'="" d
	.//总价
	.s reclocId=$p($g(^OEORD(oeordId,"I",oeordSub,3)),"^",6)
	.s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeordSub,3)),"^",25)
	.s hospital=""
	.i reclocId'="" d
	..s hospital=$p($g(^CTLOC(reclocId)),"^",22)
	.s expStr="^"_oeordId_"||"_oeordSub_"^"_oeordId_"||"_oeordSub_"||"_oeoreSub_"^"_episodeId_"^"_reclocId
	.s val("price")=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimDr,sttDate,"","","",oeoriPrice,hospital,expStr)
	.s val("price")=$fn(val("price"),"",2)
	.s orderBaseQty=##Class(web.DHCCLCom).GetOrderBaseQty(oeordId_"||"_oeordSub)
	.s val("totalAmount")=$fn(orderBaseQty*val("price"),"",2)
	e  d
	.s sttDate=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",9)  
	.s sttTime=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",10) 

	s val("sttDate")=sttDate
	s tmpSttDate=$zd(sttDate,3)
	s sttDate=$p(tmpSttDate,"-",2)_"-"_$p(tmpSttDate,"-",3)
	s sttTime=$zt(sttTime,2)
	s val("freqTime")=+sttTime
	i (val("freqTime")<=12) s val("freqTime")=val("freqTime")_"a"
	e  s val("freqTime")=val("freqTime")-12,val("freqTime")=val("freqTime")_"p"

	s val("sttTime")=sttTime
	s val("sttDateTime")=sttDate_" "_sttTime
	s val("sttDate_zh")=$p(sttDate,"-",2)_"日" 
	i queryCode="cqkfyd"  s val("sttDateTime")= val("sttDate_zh")_" "_val("freqTime")

	s oeordDate=$p($g(^OEORD(oeordId,"I",oeordSub,3)),"^",7)         //LX 2013-12-24
	s oeordTime=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",17) 
	s val("createDateTime")=$zd(oeordDate,3)_" "_$zt(oeordTime,2)
	i oeoreSub'="" d
	.s oeordSttDate=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub)),"^",1) 
	e  d
	.s oeordSttDate=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",9)  
	i ((oeordSttDate=oeordDate)&(+oeoriQty>0))  d
	.s mode=oeoreSub#oeoriQty
	.s:mode=0 mode=oeoriQty
	.s val("freqNo")=mode_"/"_oeoriQty
	e  i ((oeoreSub'="")&&($g(phcfrNum)'="")) d
	.s mode=(oeoreSub-oeoriQty)#phcfrNum
	.s:mode=0 mode=phcfrNum
	.s val("freqNo")=mode_"/"_phcfrNum

	//备注
	f num=1:1:$g(^OEORD(oeordId,"I",oeordSub,"DEP",0))  d
	.s val("notes")=$g(val("notes"))_$g(^OEORD(oeordId,"I",oeordSub,"DEP",num))
	i queryCode'="SYDO" {
	 s child=""
	 f  s child=$O(^OEORDi(0,"OEORI",oeordId,oeordId_"||"_oeordSub,child)) q:child=""  d
	 .q:child=oeordSub
	 .f num=1:1:$g(^OEORD(oeordId,"I",child,"DEP",0))  d
	 ..s val("notes")=$g(val("notes"))_$g(^OEORD(oeordId,"I",child,"DEP",num))
	}

	s actId=$p($g(^OEORD(oeordId,"I",oeordSub,11)),"^",21)
	s actDesc=""
	i actId'="" s actDesc=$p(^OEC("ACT",actId),"^",2)
	;i actDesc'="" s val("notes")=$g(val("notes"))_"(皮试:"_actDesc_")"
	i actDesc'="" s val("arcimDesc")=val("arcimDesc")_$s(actDesc="阴性":" (-)",actDesc="阳性":" (+)",actDesc="":"")

	//剂量
	s val("doseQtyUnit")=##class(web.DHCEMOrdInfoVO).GetdoseQtyUnit(oeordId,oeordSub,oeoreSub)

	//用量
	s val("dosage")=##class(web.DHCEMNurPrintHtml).GetQtyAndUom(oeordId,oeordSub)
	;s:$l(val("dosage"))>20 val("dosage")=$j(val("dosage"),1,2)

	//疗程
	s duratID=$p($g(^OEORD(oeordId,"I",oeordSub,2)),"^",6)
	i duratID'=""  s durateDesc=$p($g(^PHCDU(duratID)),"^",3)
	e  s durateDesc=""
	s val("Durat")=durateDesc

	//总量
	s doseQty=$p($g(^OEORD(oeordId,"I",oeordSub,2)),"^",1)
	i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeordSub,2)),"^",3)
	e  s unitUomId=""
	i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
	s dose=$g(doseQty)_" "_$g(unitDesc)

	s phOrdQty=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",12)
	i (phOrdQty'="") s PackNum=phOrdQty_" "_$g(unitDesc)

	s orderBaseQty=##class(web.DHCLCNUREXCUTE).GetOrdBaseQtyNum(oeordId_"||"_oeordSub)
	s phcdfId=$p($g(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1)),"^",12)
	i phcdfId'="" d 
	.s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	.s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
	.i (baseUomId'="")&(baseUomId'=unitUomId) d
	..s baseUomDesc=$p($g(^CT("UOM",baseUomId)),"^",2)
	..s PackNum=$g(orderBaseQty)_" "_$g(baseUomDesc)

	s packUomQty=$p($g(^OEORD(oeordId,"I",oeordSub,9)),"^",4)
	s packUomId=$P($G(^ARCIM(+arcimDr,$p(arcimDr,"||",2),8)),"^",14)
	s packUomId=+packUomId
	i (packUomId'=0)&(packUomQty'="") d 
	.s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
	i packUomQty'="" s PackNum=$g(packUomQty)_" "_$g(packUomDesc)
	s val("phOrdQtyUnit")=PackNum
	i ($p(val("phOrdQtyUnit")," ",1)'="")&($p(val("phOrdQtyUnit"),".",1)="")  d
	.s $p(val("phOrdQtyUnit")," ",1)=$FN($p(val("phOrdQtyUnit")," ",1),"",1)

	//标本号
	s val("labNo")=$p($g(^OEORD(oeordId,"I",oeordSub,3)),"^",20)
	s deeppurple=$p($g(^OEORD(oeordId,"I",oeordSub,11)),"^",55)
	i deeppurple="Y"  s val("elabFlag")="加急"
	//接受科室
	s reclocId=$p($g(^OEORD(oeordId,"I",oeordSub,3)),"^",6)
	i reclocId'=""  d
	.i $p($p($g(^CTLOC(reclocId)),"^",2),"-",2)'="" s val("reclocDesc")=$p($p($g(^CTLOC(reclocId)),"^",2),"-",2)
	.e  s val("reclocDesc")=$p($g(^CTLOC(reclocId)),"^",2)
	.i (queryCode["JYD")&&($p(^CTLOC(reclocId),"^",51)'="") s val("reclocDesc")=$p(^CTLOC(reclocId),"^",51)
	e  s val("reclocDesc")=""
	s arcicId=$p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",10)
	//标本名称
	s val("specDesc")=""
	s specCode=$p($g(^OEORD(oeordId,"I",oeordSub,"SPEC",1)),"^")
	i specCode'="" s val("specDesc")=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specCode,""),$c(2),2)

	s placerStr=##Class(web.DHCNurCom).GetSpecContainerCode(oeordId_"||"_oeordSub) //G^01^试管^容量^#ffff
	s var("specersNum")=$p(placerStr,"^",7)
	i ($p(placerStr,"^",4)'="") s placerMount=$p(placerStr,"^",4)
	i ($g(placerMount)'="0")&($g(placerMount)'="")&(val("specDesc")'="") s val("specDesc")=val("specDesc")_"("_placerMount_"ml)"
	s val("specContainer")=$p(placerStr,"^",3)
	s placerCode=$p(placerStr,"^",1)  
	s val("SpecColor")=$p(placerStr,"^",8)
	i $g(val("SpecColor"))'="" d
	.s val("specContainer")=val("specContainer") ;_"("_$g(val("SpecColor"))_")"

	//病理
	s blLabNo=##Class(web.DHCAPPPisInterface).GetRepRowIdByOeordID(oeordId_"||"_oeordSub) //新产品病理申请单 ;##class(web.DHCPisApplicationSheet).GetRowIdByOrderDr(oeordId_"||"_oeordSub)
	i blLabNo'="" d
	.s specDateInfo=""
	.s val("specDesc")=##Class(web.DHCAPPPisInterface).GetSpeNameByRepID(blLabNo)  ;##class(web.DHCPisApplicationSheet).GetSpecimensinfo(blLabNo)
	.s val("labNo")=blLabNo  ;_"||"_$p($g(val("specDesc")),"^",1)
	.s val("specDesc")=$replace(val("specDesc"),"^","!")
	.s val("specDesc")=val("specDesc")_"!"
	//发药状态
	s dispensingStat=##class(web.DHCCLCom).GetDispensingStat(oeordId_"||"_oeordSub,"Y")
	i dispensingStat="TC" s val("DspStat")="未发"
	i dispensingStat="C" s val("DspStat")="已发"
	i dispensingStat="PC" s val("DspStat")="部分发"
	//滴数
	S speedFlow=""
	S speedFlowRate=$P($G(^OEORD(oeordId,"I",oeordSub,3)),"^",17)
	s speedFlowUnitDr=$P($G(^OEORD(oeordId,"I",oeordSub,6)),"^",8)
	i speedFlowUnitDr'="" s speedFlowUnit=$p($g(^OEC("SFR",speedFlowUnitDr)),"^",2)
	i speedFlowRate'="",speedFlowUnitDr'="" S val("speedFlow")=$g(speedFlowRate)_" "_$g(speedFlowUnit)

	//LX  2013-10-29
	I admType="I" d
	.s SeqNo=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub,"BILL")),"^",3)
	.i +SeqNo'=0 d
	..s val("arcimDesc")="____"_val("arcimDesc")
	..s myArcimLen=..GetStringByte(val("arcimDesc"))
	..i myArcimLen>35 d
	...s val("arcimDesc")=..GetStringSplit(val("arcimDesc"),35)_"\n"_..GetStringSplit(val("arcimDesc"),36,myArcimLen)
	..s val("phcfrCode")=""
	..s val("phcinDesc")=""
	..s val("sttDateTime")=""
	e  d
	.;s seqNo=$p($g(^OEORD(oeordId,"I",oeordSub,3)),"^",4)    //序号
	.s seqNo=$p($g(^OEORD(oeordId,"I",oeordSub,11)),"^",39)   //seqNo
	.i seqNo=""  s seqNo=oeordId_"||"_oeordSub
	.i seqNo'=(oeordId_"||"_oeordSub)  d
	..s val("arcimDesc")="____"_val("arcimDesc")
	..s myArcimLen=..GetStringByte(val("arcimDesc"))
	..i myArcimLen>35 d
	...s val("arcimDesc")=..GetStringSplit(val("arcimDesc"),35)_"\n"_..GetStringSplit(val("arcimDesc"),36,myArcimLen)
	..s val("phcfrCode")=""
	..s val("phcinDesc")=""
	..s val("speedFlow")=""
	..s val("Durat")=""

	s skintest=$p($g(^OEORD(oeordId,"I",oeordSub,5)),"^",2)
	i (oeoreSub'="") d
	.s execDate=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub)),"^",19)
	.s execTime=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub)),"^",20)
	.s val("execDateTime")=##class(web.DHCLCNUREXCUTE).FormatDate(execDate)_" "_##class(web.DHCLCNUREXCUTE).FormatTime(execTime)
	i (oeoreSub'="")&&(skintest="Y") d
	.s skinTestDate=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub,"NUR")),"^",14)
	.s skinTestTime=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub,"NUR")),"^",15)
	.s val("skinTestDateTime") =##class(web.DHCEMOrdInfoVO).GetSkinTestDate(oeordId_"||"_oeordSub) ;##class(web.DHCLCNUREXCUTE).FormatDate(skinTestDate)_" "_##class(web.DHCLCNUREXCUTE).FormatTime(skinTestTime)

	//输液状态
	i ((admType'="I")) d
	.q:oeoreSub=""
	.s dosageML=##class(Nur.NurseExcuteSheet).GetDosageML(oeordId_"||"_oeordSub)
	.i dosageML="" s dosageML=0
	.s orderStatus=##class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeordSub)
	.i orderStatus'="V" s val("infusionStatus")="UnVerify" q
	.i $p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub)),"^",19)'="" s val("infusionStatus")="OrdExec" q
	.i $p($g(^OEORD(oeordId,"I",oeordSub,3)),"^",32)="Y" s val("infusionStatus")="ReturnStock" q
	.s dosRowId=$O(^User.DHCIFDosAgeI("Oeore"," "_oeordId_"||"_oeordSub_"||"_oeoreSub,""))
	.i dosRowId'="" s val("infusionStatus")="Dosage"
	.i dosRowId="" s val("infusionStatus")="UnDosage" q
	.i $p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub)),"^",1)'=+$h s val("infusionStatus")="NotToday" q
	.s val("infusionStatus")="UnExec" q
		
	i ((admType'="I")) d
	.//录入科室
	.s OrdDeptDR=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",3)  //ypz 060620
	.s OrdDeptDEsc=$p($g(^CTLOC(OrdDeptDR)),"^",2)
	.s:OrdDeptDEsc["-" OrdDeptDEsc=$p($p($g(^CTLOC(OrdDeptDR)),"^",2),"-",2)
	.s DocAndLoc=$g(val("ctcpDesc"))_$C(10)_OrdDeptDEsc
	i ($g(val("labNo"))'="")&(admType'="I") d
	.s excode=""
	.s chl=0 f  s chl=$o(^ARCIM(+arcimDr,$p(arcimDr,"||",2),"EXT",chl)) q:(chl="")!(excode'="")  d
	..s tod=$p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),"EXT",chl),"^",2)
	..q:(tod'="")&(tod<+$h)
	..s excode=$p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),"EXT",chl),"^",4)
	.;i excode'="" s ReturnTime=$p($G(^["LABDATA"]TTAB("TS",excode)),"\",33)  //门诊检验取报告时间
	s val("arcimDesc")=$replace(val("arcimDesc"),"(限制使用)","")
	s val("arcimDesc")=$replace(val("arcimDesc"),"(非限制)","")
	s CurrentDate=$zd(+$h,3)
	s CurrentTime=$zt($p($h,",",2),2)
	s CurrentDateTime=$p(CurrentDate,"-",2)_"-"_$p(CurrentDate,"-",3)_" "_CurrentTime

	s Papmidr=$P(^PAADM(episodeId),"^",1)
	s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel(Papmidr,"")
	s EncryptLevel=$p(PatEncryptLevel,"^",1)
	s PatLevel=$p(PatEncryptLevel,"^",2) 

	s execCount=$g(^OEORD(oeordId,"I",oeordSub,"X",0))  	//医嘱有几条执行记录
	i execCount="" s execCount=1

	//补打标志
	i oeoreSub'="" d
	.s pmark=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub,"NUR")),"^",1)
	.s printDate=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub,"NUR")),"^",2)
	.s printTime=$p($g(^OEORD(oeordId,"I",oeordSub,"X",oeoreSub,"NUR")),"^",3)
	.q:(printDate=+$h)&&(($p($h,",",2)-printTime)<10)  //10秒内不算不打
	.i pmark["P" s val("prtFlag")="补"
	.i pmark["T" s val("prtFlag")="补" 

	//预住院
	s val("preInFlag")=""
	s admVisitStatus=$p(^PAADM(episodeId),"^",20)
	i admVisitStatus="P"  s val("preInFlag")="预"
	s IPBppkDr=$O(^DHCDocIPBK(0,"EpisodeIDTo",episodeId,""))
	i IPBppkDr="" s IPBppkDr=$O(^DHCDocIPBK(0,"EpisodeIDFrom",episodeId,""))
	i IPBppkDr'="" d
	.s bookOBJ=##class(User.DHCDocIPBooking).%OpenId(IPBppkDr,0)
	.i bookOBJ.TreatedPrinciple.MDICCode="DaySurg" s val("preInFlag")="日间"

	//优先级
	s oecprId=$p($g(^OEORD(oeordId,"I",oeordSub,1)),"^",8)
	i oecprId'="" s val("oecprDesc")=$p($g(^OECPR(oecprId)),"^",2)
    
    ///执行人CA图片
    s val("imageBase64")=##class(web.DHCEMNurPrintHtml).GetCAImage(oeordId_"||"_oeordSub_"||"_oeoreSub)
    
    s ret=""
	s index=""
	f  s index=$o(val(index)) q:index=""  d
	.s value=$g(val(index))
	.s:ret'="" ret=ret_"^"_index_"@"_$g(val(index))
	.s:ret="" ret=index_"@"_$g(val(index))
	
    q $g(ret)
     
	///通过配置获取打印数据:qqa 20191119不取配置
	s num=0 f  s num=$o(^DHCCLNurseExec("Var",num)) q:num=""  d
	.s type=$p(^DHCCLNurseExec("Var",num),"^",2)
	.i $g(ret)="" s ret=type_"@"_$g(val(type))
	.e  s ret=ret_"^"_type_"@"_$g(val(type))
}

/// w ##class(web.DHCEMNurPrintHtml).GetCAImage("2856||4||1")
ClassMethod GetCAImage(ordExecId)
{
	q:ordExecId="" ""
	s ord = +ordExecId
	s itm = $p(ordExecId,"||",2)
	s sub = $p(ordExecId,"||",3)
	s isCaExec=$o(^DHCEMSV(0,"IndexOre",ordExecId,""),-1)
	q:+isCaExec=0 ""
    s signatureID = $p($g(^DHCEMSV(+isCaExec)),"^",11)
	q ##class(CA.BICAService).GetImageBySignID(signatureID)
}

ClassMethod SetLabColor()
{
	s ^LabColor("Color","A")="紫色"
	s ^LabColor("Color","B")="蓝色"
	s ^LabColor("Color","C")="灰色"
	s ^LabColor("Color","G")="绿色"
	s ^LabColor("Color","H")="黑色"
	s ^LabColor("Color","O")="褐色"
	s ^LabColor("Color","P")="粉色"
	s ^LabColor("Color","Q")="橙色"
	s ^LabColor("Color","R")="红色"
	s ^LabColor("Color","W")="白色"
	s ^LabColor("Color","Y")="黄色"
}

/// Input: Orders,QueryCode:执行记录串,单据类型
/// Descript:获取前台打印数据
/// 返回数组
/// w ##class(web.DHCEMNurPrintHtml).GetOrdInfos("30621354||5||1^30621354||6||1^30621354||7||1^30621354||8||1^30621354||9||1","JZZSD")
ClassMethod GetOrdInfos(Orders, QueryCode)
{
	n (Orders,QueryCode)
	s ItmCount=0
	w "["
	s OrdExecItmLen = $l(Orders,"^")
	f i=1:1:OrdExecItmLen d
	.s OrdExecItm = $p(Orders,"^",i)
	.s OrdExecLen = $l(OrdExecItm,"#")
	.s ItmCount = ItmCount+1
	.w $case(ItmCount,1:"",:",")
	.s Num=0
	.w "["
	.f j=1:1:OrdExecLen d
	..s RowSpan=""       			//RowSpan:前台js rowspan数目
	..s:j=1 RowSpan=OrdExecLen      //只有第一条有rowspan个数，第二条为0，前台界面对应不显示
	..s:j'=1 RowSpan=0
	..s OrdExecs = $p(OrdExecItm,"#",j)
	..s OrdExecsLen = $l(OrdExecs,"@")
	..s Num=Num+1
	..w $case(Num,1:"",:",")
	..s Count=0
	..w "["                             //返回数组的目的，对于主子医嘱能按组进行判断
	..f k=1:1:OrdExecsLen d
	...s OrdExecID = $p(OrdExecs,"@",k)
	...q:OrdExecID=""
	...s Count = Count+1
	...w $case(Count,1:"",:",")
	...w ##class(web.DHCEMNurPrintHtml).GetOrdInfo(OrdExecID,QueryCode,RowSpan)
	..w "]"
	.w "]"
	.
	w "]"
	q ""
}

/// Descript:执行记录的串串:一个完全是一条一条传给你的串串
/// Return: MainExec1@ChildExec1#MainExec2@ChildExec2#MainExec3@ChildExec3^MainExec4@ChildExec4#MainExec5@ChildExec5#MainExec6@ChildExec6
/// w ##class(web.DHCEMNurPrintHtml).FormatOrders("30621354||5||1^30621354||6||1^30621354||7||1^30621354||8||1^30621354||9||1")
ClassMethod FormatOrders(Orders)
{
	n (Orders)
	k TMPData("web.DHCEMNurPrintHtml","FormatOrders")
	//按照医嘱进行排序归类
	s Len = $l(Orders,"^")
	f i=1:1:Len d
	.s OrderExec = $p(Orders,"^",i)
	.s OrderID = $p(OrderExec,"||",1)
	.s OrderItmSub = $p(OrderExec,"||",2)
	.s OrderItmID = OrderID_"||"_OrderItmSub
	.s:$d(TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrderItmID)) TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrderItmID) = TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrderItmID)_"#"_OrderExec
	.s:'$d(TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrderItmID)) TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrderItmID) = OrderExec
	
	//循环先Copy所有的主医嘱
	s FormatOrders=""
	s OrderItmID =""
	f  s OrderItmID = $o(TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrderItmID)) q:OrderItmID=""  d
	.s MainOrdItmID = $p(^OEORD(+OrderItmID,"I",$P(OrderItmID,"||",2),11),"^",39)   //获取主医嘱ID
	.q:MainOrdItmID'=""                                                             //本身是主医嘱
	.s TMPData("web.DHCEMNurPrintHtml","FormatOrders","AllOrder",OrderItmID) = TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrderItmID) 
	
	b ;data1
	//循环再合并传递过来的子医嘱
	s FormatOrders=""
	s OrderItmID =""
	f  s OrderItmID = $o(TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrderItmID)) q:OrderItmID=""  d
	.s MainOrdItmID = $p(^OEORD(+OrderItmID,"I",$P(OrderItmID,"||",2),11),"^",39)   //获取主医嘱ID
	.q:MainOrdItmID=""                                                              //不是子医嘱的直接Q
	.i $d(TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",MainOrdItmID)) d   //如果是列表中有主医嘱:进行合并 
	..s MainExecs = TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",MainOrdItmID)
	..s OrdExecs="" 
	..s Len = $l(MainExecs,"#")
	..f i=1:1:Len d
	...s OrdItmExecs=""
	...s OrdChildItmID = ""
	...f  s OrdChildItmID = $o(TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrdChildItmID)) q:(OrdChildItmID="")  d
	....q:$p(^OEORD(+OrdChildItmID,"I",$P(OrdChildItmID,"||",2),11),"^",39)'=MainOrdItmID
	....s ChildExecs = TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrdChildItmID)
	....s:OrdItmExecs'="" OrdItmExecs = OrdItmExecs_"@"_$p(ChildExecs,"#",i)
	....s:OrdItmExecs="" OrdItmExecs = $p(MainExecs,"#",i)_"@"_$p(ChildExecs,"#",i)
	...s:OrdExecs'="" OrdExecs=OrdExecs_"#"_OrdItmExecs
	...s:OrdExecs="" OrdExecs = OrdItmExecs
	...
	..s TMPData("web.DHCEMNurPrintHtml","FormatOrders","AllOrder",MainOrdItmID) = OrdExecs
	.i '$d(TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",MainOrdItmID)) d   //如果是列表中没有主医嘱
	..s TMPData("web.DHCEMNurPrintHtml","FormatOrders","AllOrder",OrderItmID) = TMPData("web.DHCEMNurPrintHtml","FormatOrders","Order",OrderItmID)
	b ;data2
	
	s FormatOrders=""
	s OrderItmID =""
	f  s OrderItmID = $o(TMPData("web.DHCEMNurPrintHtml","FormatOrders","AllOrder",OrderItmID)) q:OrderItmID=""  d
	.s OrderExec = TMPData("web.DHCEMNurPrintHtml","FormatOrders","AllOrder",OrderItmID)
	.s ItmData = OrderExec
	.s:FormatOrders'="" FormatOrders = FormatOrders_"^"_ItmData
	.s:FormatOrders="" FormatOrders = ItmData
	
	q FormatOrders
}

ClassMethod GetPatInfo(EpisodeID)
{
	n (EpisodeID,%session)
	s TraBed=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","床号")
	s TraSeat=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","座位")
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	s:CurDate'="" CurDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CurDate)
	s:CurTime'="" CurTime=$zt(CurTime,1)
	s Bed=""
	s BedId=$p($g(^PAADM(EpisodeID)),"^",73)
	i BedId'="" s Bed=$p($g(^PAWARD(+BedId,"BED",$p(BedId,"||",2))),"^",1)  /// 床号
	s:Bed'="" Bed=TraBed_":"_Bed
	i Bed="" d
	.s Seat=$p(##class(web.DHCEMPatientSeat).GetPatSeatInfo(PatientID),"!!",2) //座位号
	.s:Seat'="" Bed=TraSeat_":"_Seat
	s:PatSex'="" PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2022-12-27 st
	s:PatLoc'="" PatLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PatLoc) //ed
	s RetData = EpisodeID_"^"_PatientID_"^"_PatName_"^"_PatNo_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_CurDate_"^"_CurTime_"^"_Bed
	q RetData
}

ClassMethod GetAllPrintData(AllOrders, QueryCode, Params)
{
	n (AllOrders, QueryCode, Params,%session)
	s Len=$l(AllOrders,"^")
	f i=1:1:Len d
	.s OrdItmId=$p(AllOrders,"^",i)
	.s AdmID=+^OEORD(+OrdItmId)
	.q:+AdmID=0
	.s PatientID=+^PAADM(+AdmID)
	.s:$d(TMPData(PatientID)) TMPData(PatientID)=TMPData(PatientID)_"^"_OrdItmId
	.s:'$d(TMPData(PatientID)) TMPData(PatientID)=OrdItmId
	
	w "["
	s Index="",Count=0
	f  s Index=$o(TMPData(Index)) q:Index=""  d
	.s Orders=TMPData(Index)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCEMNurPrintHtml).GetPrintDate(Orders,QueryCode,Params)
	w "]"
	q ""
}

/// Descript:主要方法,获取打印数据
/// Input:Orders(医嘱执行记录ID串^号分割),QueryCode：类型, Params:就诊ID^医院ID
/// w ##class(web.DHCEMNurPrintHtml).GetPrintDate("1460||23||1^1460||24||1^1460||23||2^1460||24||2^1460||23||3^1460||24||3^1460||33||1^1460||33||2^1460||33||3^1460||23||4^1460||24||4^1460||33||4^1460||48||1^1460||23||5^1460||24||5^1460||33||5^1460||48||2^1460||23||6^1460||24||6^1460||33||6^1460||48||3^1460||23||7^1460||24||7^1460||33||7^1460||48||4^1460||23||8^1460||24||8^1460||33||8^1460||48||5^1460||80||1^1460||81||1^1460||82||1^1460||83||1^1460||84||1^1460||85||1^1460||86||1^1460||80||2^1460||81||2^1460||82||2^1460||83||2^1460||84||2^1460||85||2^1460||86||2^1460||23||9^1460||24||9^1460||33||9^1460||48||6^1460||80||3^1460||81||3^1460||82||3^1460||83||3^1460||84||3^1460||85||3^1460||86||3^1460||48||7^1460||80||5^1460||81||5^1460||82||5^1460||83||5^1460||84||5^1460||85||5^1460||86||5^1460||48||8^1460||48||9^1460||80||6^1460||81||6^1460||82||6^1460||83||6^1460||84||6^1460||85||6^1460||86||6^1460||80||4^1460||81||4^1460||82||4^1460||83||4^1460||84||4^1460||85||4^1460||86||4^1460||80||8^1460||81||8^1460||82||8^1460||83||8^1460||84||8^1460||85||8^1460||86||8^1460||93||1^1460||93||2^1460||95||1^1460||95||2^1460||80||9^1460||81||9^1460||82||9^1460||83||9^1460||84||9^1460||85||9^1460||86||9^1460||93||3^1460||95||3^1460||80||7^1460||81||7","SYDO","^2")
ClassMethod GetPrintDate(Orders, QueryCode, Params)
{
	n (Orders,QueryCode,Params,%session)
	s EpisodeID = $p(Params,"^",1)
	s:EpisodeID="" EpisodeID = $p(^OEORD(+Orders),"^",1)
	s HospID = $p(Params,"^",2)
	s HospDesc = $p(^CT("HOSP",HospID),"^",2)
	s HospDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTHospital","HOSPDesc","",HospDesc) //hxy 2022-12-27
	s PrintTitle = HospDesc_" "_##class(web.DHCEMNurExecFormSet).getNurExecFormName(QueryCode,HospID) ;##class(Nur.NurseExcuteSheet).getSheetName(QueryCode)
	s PatInfo = ##class(web.DHCEMNurPrintHtml).GetPatInfo(EpisodeID)
	s Orders = ##class(web.DHCEMNurPrintHtml).FormatOrders(Orders)  //排序医嘱执行记录
	s Del=""""
	w "{"
		w Del_"columns"_Del_":"    //打印数据title
		w ##class(web.DHCEMNurPrintHtml).GetPrintTitle(QueryCode,HospID)
		w ","
		w Del_"printData"_Del_":"    //打印数据
		w ##class(web.DHCEMNurPrintHtml).GetOrdInfos(Orders,QueryCode)
		w ","
		w Del_"printTitle"_Del_":"    //表头
		w Del_PrintTitle_Del
		w ","
		w Del_"printPatInfo"_Del_":"    //病人信息
		w Del_PatInfo_Del
	w "}"
	q ""
}

/// w ##class(web.DHCEMNurPrintHtml).GetPrintDataXml("37||6||1^37||7||1","00000022^00000022","")
ClassMethod GetPrintDataXml(OreDatas, MainOreDatas, QueryCode = "")
{
	n (OreDatas,MainOreDatas,QueryCode)
	
	s MergeCell="arcimDesc!1^doseQtyUnit!2"   ///MergeCell:标识需要合并的列，1换行连接，2+号连接
	s:QueryCode["JYD" $p(MergeCell,"^",1)="arcimDesc!2"
	
	s TMPData=""
	s Ret=""
	s Len=$l(OreDatas,"^")
	f i=1:1:Len d
	.s OreID=$p(OreDatas,"^",i)
	.s MainFlag=$p(MainOreDatas,"^",i)
	.s:MainFlag="" TMPData(OreID)=OreID
	.i MainFlag'="" d
	..s:$d(TMPData(MainFlag)) TMPData(MainFlag)=TMPData(MainFlag)_"^"_OreID
	..s:'$d(TMPData(MainFlag)) TMPData(MainFlag)=OreID
	
	s Main=""
	f  s Main =$o(TMPData(Main)) q:Main=""  d
	.s GroupOreDatas=TMPData(Main)
	.s Len = $l(GroupOreDatas,"^")
	.s ItmData=""
	.f i=1:1:Len d
	..s OreID=$p(GroupOreDatas,"^",i)
	..s ItmLineData = ##class(web.DHCEMNurPrintHtml).getExcuteOrderInfo(OreID,QueryCode,"")			   ///获取数据
	..s:ItmData'="" ItmData = ##class(web.DHCEMNurPrintHtml).MergeCell(ItmData,ItmLineData,MergeCell)  ///合并的操作
	..s:ItmData="" ItmData=ItmLineData
	.;病理条码打印需要特殊处理，按照标本进行拆分，且条码应该为医嘱ID+标本ID
	.s:QueryCode["BLD" ItmData = ##class(web.DHCEMNurPrintHtml).SplitBLDCell(ItmData)  ///病理条码单独拆分
	.s:Ret'="" Ret=Ret_"#"_ItmData
	.s:Ret="" Ret=ItmData
	q Ret
}

/// Decripts:合并单元格
/// w ##class(web.DHCEMNurPrintHtml).MergeCell()
ClassMethod MergeCell(BasData, MergeData, MergeCell)
{
	n (BasData,MergeData,MergeCell)
	q:MergeCell="" BasData
	s Len=$l(BasData,"^")
	f i=1:1:Len d
	.s BaseItmInfo=$p(BasData,"^",i)
	.s MergeItmInfo=$p(MergeData,"^",i)
	.s BaseKey=$p(BaseItmInfo,"@",1)

	.s BaseValue=$p(BaseItmInfo,"@",2)
	.s MergeKey=$p(MergeItmInfo,"@",1)
	.s MergeValue=$p(MergeItmInfo,"@",2)
	.s BasVal(BaseKey)=BaseValue
	.s MergeVal(MergeKey)=MergeValue
	
	s MergeCellLen=$l(MergeCell,"^")
	f j=1:1:MergeCellLen d
	.s MergeCellTile=$p(MergeCell,"^",j)
	.s MergeCellMode=$p(MergeCellTile,"!",2)
	.s MergeCellTile=$p(MergeCellTile,"!",1)
	.s:MergeCellMode=1 BasVal(MergeCellTile)=$g(BasVal(MergeCellTile))_"\n"_$g(MergeVal(MergeCellTile))
	.s:MergeCellMode=2 BasVal(MergeCellTile)=$g(BasVal(MergeCellTile))_"+"_$g(MergeVal(MergeCellTile))
	
	s Ret=""
	s Index=""
	f  s Index=$o(BasVal(Index)) q:Index=""  d
	.s Value=$g(BasVal(Index))
	.s:Ret'="" Ret=Ret_"^"_Index_"@"_$g(BasVal(Index))
	.s:Ret="" Ret=Index_"@"_$g(BasVal(Index))
    q Ret
}

/// w ##class(web.DHCEMNurPrintHtml).SplitBLDCell("Durat@^SpecColor@^age@28岁^arcimDesc@活体组织病理诊断^arcimshortDesc@活体组织病理诊断^bedCode@09床^createDateTime@2020-01-15 14:03^ctcpDesc@急诊医生01^dia@急性呼吸衰竭 ;聚星障病 ;风证类 ^dosage@1次^doseQtyUnit@^execDateTime@ ^freqTime@2p^infusionStatus@UnDosage^labNo@78^locDesc@急诊内科门诊^medCareNo@^notes@^oecprDesc@临时医嘱^oeoriId@394||36||1^orderType@临时医嘱^patName@沈测试三三^phOrdQtyUnit@1 次^preInFlag@^price@60.00^reclocDesc@病理科^regNo@0000000263^sex@男^specContainer@^specDesc@1!组织病理!!1!394-36-1;2!细胞!!1!394-36-2;3!体内积液!!1!394-36-3!^sttDate@65393^sttDateTime@01-15 14:03^sttDate_zh@15日^sttTime@14:03^totalAmount@60.00^ward@急诊留观室")
ClassMethod SplitBLDCell(BasData)
{
	n (BasData)
	
	s Len=$l(BasData,"^")
	f i=1:1:Len d
	.s BaseItmInfo=$p(BasData,"^",i)
	.s BaseKey=$p(BaseItmInfo,"@",1)
	.s BaseValue=$p(BaseItmInfo,"@",2)
	.s BasVal(BaseKey)=BaseValue
	
	s SpecDescs=BasVal("specDesc")
	q:SpecDescs="" BasData
	
	s ItmBaseRet=""
	s Index=""
	f  s Index=$o(BasVal(Index)) q:Index=""  d
	.q:Index="specDesc"   ///病理单这两个要拆分
	.q:Index="labNo"
	.s Value=$g(BasVal(Index))
	.s:ItmBaseRet'="" ItmBaseRet=ItmBaseRet_"^"_Index_"@"_$g(BasVal(Index))
	.s:ItmBaseRet="" ItmBaseRet=Index_"@"_$g(BasVal(Index))
	
	s Ret=""
	s Len =$l(SpecDescs,";")
	
	s ItemRet=""
	f i=1:1:Len d
	.s ItmSpecDesc=$p(SpecDescs,";",i)
	.s SpecID=$p(ItmSpecDesc,"!",1)
	.s SpecDesc=$p(ItmSpecDesc,"!",2)
	.s SpecNumber=$p(ItmSpecDesc,"!",4)
	.s BlLabNo = $p(ItmSpecDesc,"!",5)
	.s:ItmBaseRet'="" ItemRet=ItmBaseRet_"^labNo@"_BlLabNo_"^specDesc@"_SpecID_":"_SpecDesc_"_"_SpecNumber
	.s:ItmBaseRet="" ItemRet="labNo@"_BlLabNo_"^specDesc@"_SpecID_":"_SpecDesc_"_"_SpecNumber
	.s:Ret'="" Ret=Ret_"#"_ItemRet
	.s:Ret="" Ret=ItemRet
	q Ret
}

ClassMethod GetQtyAndUom(OrderId, OrdItemId)
{
	/// 总量取值调用医生站公共方法 bianshuai 2021-02-04
	s rets=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OrderId_"||"_OrdItemId)
	Q $p(rets,"^")_$p(rets,"^",2)
	
#;	set DrgQtyUom = ""
#;	Set str2 = $g(^OEORD(OrderId,"I",OrdItemId,2))
#;	Set str1 = $g(^OEORD(OrderId,"I",OrdItemId,1))
#;	set orderPackQty=$p($g(^OEORD(OrderId,"I",OrdItemId,9)),"^",4)	;整包装数量 OEORI_QtyPackUOM
#;	Set orderPhQtyOrd=$p(str1,"^",12)  ;检查-治疗数量 OEORI_PHQTYORD
#;	set doseQty = $p(str2,"^",1)				;用量 OEORI_DoseQty
#;	set doseUnitDr= $p(str2,"^",3)				;剂量单位 OEORI_Unit_DR 
#;	set ItmMastDR = $p(^OEORD(OrderId,"I",OrdItemId,1),"^",2)
#;	set ARCIMBillingUOMDr=$P($G(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),8)),"^",14)
#;	set PriorityDR = $p(str1,"^",8)
#;	
#;	;检查-治疗数量 OEORI_PHQTYORD
#;	if orderPhQtyOrd'="" d
#;	.s OrderPhQtyUOM=""
#;	.i ARCIMBillingUOMDr'="" s OrderPhQtyUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ARCIMBillingUOMDr) 
#;	.s DrgQtyUom = orderPhQtyOrd_OrderPhQtyUOM
#;		
#;	if doseQty'="" d
#;	.s DrgformRowid = $p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",12) ;PHC_DrgForm
#;	.i DrgformRowid>0 d
#;	..s order2PackQty = (##class(Nur.NurseExcuteSheet).CalDose(doseUnitDr,DrgformRowid,doseQty))
#;	..s bsUOMph = $p(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),2),"^",4)
#;	..s bsUOMphDesc = ##class(web.DHCDocOrderCommon).GetUOMDesc(bsUOMph)
#;	..s order2PackQty=$j(order2PackQty,1,2)
#;	..s DrgQtyUom = order2PackQty_bsUOMphDesc
#;	
#;	;临时--药品-----医嘱是不是
#;	if ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR){
#;		if orderPackQty'="" {
#;			s OrderPackUOM=""
#;			i ARCIMBillingUOMDr'="" s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ARCIMBillingUOMDr) 
#;			s DrgQtyUom = orderPackQty_OrderPackUOM
#;		}
#;	}
#;	s:$p(DrgQtyUom,".",1)="" DrgQtyUom="0"_DrgQtyUom
#;	q DrgQtyUom
}

/// w ##class(web.DHCEMNurPrintHtml).GetStringByte("____0.9%氯化钠注射液(塑瓶)[250ml]")
ClassMethod GetStringByte(str)
{
	n (str)
	s len = 0
	for i = 1 : 1 : $l(str) {
		s word = $e(str, i)
		if ($ziswide(word)) {
			s len = len + 2
		} else {
			s len = len + 1
		}
	}
	q len
}

/// desc: 按字节截取字符串
/// w ##class(web.DHCEMNurPrintHtml).GetStringSplit("____5%葡萄糖氯化钠注射液(袋装)[100ml]",35,38)
ClassMethod GetStringSplit(str, num, edNum = "")
{
	n (str, num, edNum)
	s len = "0", j = ""
	for i = 1 : 1 : $l(str) {
		s word = $e(str, i)
		if ($ziswide(word)) {
			s len = len + 2
		} else {
			s len = len + 1
		}
		i (len = num)||(len - num = 1)  s j = i
		q:(j '= "")
	}
	i edNum="" d
	.s target = $e(str, 1, j)
	e  d
	.s target = $e(str, j, edNum)	
	q target
}

}
