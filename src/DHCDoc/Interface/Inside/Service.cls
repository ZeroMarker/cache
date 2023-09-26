/// creator:guorongyong
/// date:2016-07-13
/// desc:和东华内部系统的接口类【主要是提供给其他产品组的接口】,仅医生站,不包括建卡,挂号,分诊与内部的接口
Class DHCDoc.Interface.Inside.Service Extends DHCDoc.Util.RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:      郭荣勇
/// CreatDate:    2018.08.14
/// Description:  获取门急诊医嘱先诊疗后付费标识(执行科室在医嘱未收费情况下按此接口判断是否可执行)
/// Table:        
/// Input:        OEORIRowId:医嘱明细表RowId,	ExpStr：待扩展(以^分割)
/// Return:       flag^msg; flag:Y 是,N 不是; msg:成功或错误信息
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetPreCureAfterPayFlag("2||1")
ClassMethod GetPreCureAfterPayFlag(OEORIRowId As %String, ExpStr As %String = "")
{
	n (OEORIRowId,ExpStr)
	s $zt="GetPreCureAfterPayFlagErr"
	Q:OEORIRowId="" $$SetOutMsg("N","OEORIRowId参数不能为空","N")
	s Adm=$p(^OEORD(+OEORIRowId),"^",1)
	s AdmReasonDR=$p(^PAADM(Adm,1),"^",7)
	s Ord=+OEORIRowId,Chl=$p(OEORIRowId,"||",2)
	s AdmDepDr=$p($g(^PAADM(Adm)),"^",4)
	s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
	//0:普通收费模式；1：押金收费模式
	s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmDepHospId)
	;判断留观
	s StayStatus=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
	if ((" 1 2 "[(" "_StayStatus_" ")))&&(StayPayMode="1") Q $$SetOutMsg("Y","留观状态患者后付费","Y")
	
	;判断医嘱先诊疗后付费标识(急诊押金结算标识等)
	s OEORIReadyToBillFlag=$P($g(^OEORD(Ord,"I",Chl,12)),"^",26)
	if OEORIReadyToBillFlag="Y" Q $$SetOutMsg("Y","医嘱先诊疗后付费标识(急诊押金结算标识等)","N")
	/*
	;临床药理医嘱标识--pb by tanjishan 现在临床药理完全走billed标志就可以了，要么开医嘱自动置P，要么走窗口收费，不需要走先诊疗后付费标志
	s ProPilotId=$p($g(^OEORD(Ord,"I",Chl,"DHC")),"^",10)
	i ProPilotId'="" Q $$SetOutMsg("Y","临床药理医嘱后付费","N")
	*/

	q $$SetOutMsg("N","不是先诊疗后付费医嘱","N")

	
SetOutMsg(flag,msg,chkdepflag)
	Q flag_"^"_msg_"^"_chkdepflag
GetPreCureAfterPayFlagErr
	Q $$SetOutMsg("N","程序异常:"_$zerror,"N")
}

/// Creator:      郭荣勇
/// CreatDate:    2017.03.09
/// Description:  产生检验条码和处方号
/// Table:        
/// Input:        AdmId:就诊RowId   UserID:用户ID	ExpStr：就诊科室Rowid(CT_Loc)^
/// Return:      
/// Others:       d ##class(DHCDoc.Interface.Inside.Service).GenPresno("6119",1,"") 
ClassMethod GenPresno(AdmId As %String, UserId As %String, ExpStr As %String = "")
{
	n (AdmId,UserId,ExpStr)
	s AdmLocId=$p(^PAADM(AdmId),"^",4)
	s AdmHospitalId=##Class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmId)
	s Doc=$P(^SSU("SSUSR",UserId),"^",14)
	s SessionStr=UserId_"^^"_AdmLocId_"^"_AdmHospitalId
	s ord=$o(^OEORD(0,"Adm",AdmId,""))
	if (..%IsValidMethod("web.DHCDocPrescript","CreatOrdNo")){
		//生成处方
		k LabEpisArray
		d ##Class(web.DHCDocPrescript).CreatOrdNo(AdmId,"",UserId_"^"_"^"_AdmLocId_"^"_AdmHospitalId,.LabEpisArray)

		/// 插入需要附加绑定的材料医嘱
		k OrdAddCongeriesArr,OrdCongeriesArr
		d ##class(web.DHCOEOrdAppendItem).GetLabOrdItemAppendItem(AdmId,SessionStr,.OrdCongeriesArr,.LabEpisArray,.OrdAddCongeriesArr,0)
		if ($D(OrdAddCongeriesArr)){
			s AppendOrdStr="",Index=0
			for {
				s Index=$O(OrdAddCongeriesArr(Index))
				q:(Index="")
				s OrdStr=$G(OrdAddCongeriesArr(Index,"OrdListInfo"))
				continue:(OrdStr="")
				if (AppendOrdStr=""){
					s AppendOrdStr=OrdStr
				}else{
					s AppendOrdStr=AppendOrdStr_$c(1)_OrdStr
				}
			}
			if (AppendOrdStr'=""){
				d ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(AdmId, AppendOrdStr, UserId, AdmLocId, Doc, "", "", .ErrMsg )
			}
		}

	}else{
		/// 8.5.3已删除DHCaOET1.mac中的大部分功能
		Set AutoPresc=$$getconfignode^DHCDocConfig("PrescByAuto")
		if AutoPresc="1" Do presno3^DHCaOET1(AdmId,UserId,AdmLocId)
		e  d presno1^DHCaOET1(AdmId,UserId,AdmLocId)
	}
	q
}

/// Creator:      郭荣勇
/// CreatDate:    2017.03.09
/// Description:  【私有接口,未经产品组允许不得使用】更新医嘱信息【接收科室,】
/// Table:        
/// Input:        oeitm:医嘱RowId   UserID:用户ID
/// Return:       0 成功; 非0 不成功
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).UpdateOEORI("747886||227") 
ClassMethod UpdateOEORI(OEORIRowId As %String, UserId As %String, NewInfo As %String) As %String
{
	n (OEORIRowId,UserId,NewInfo)
	Q:NewInfo="" 0
	Q:OEORIRowId="" "-1"
	Q:$l(OEORIRowId,"||")'=2 "-2"
	
	;接收科室ID
	s RecDepId=$p(NewInfo,"^",1)
    &sql(Update SQLUser.OE_OrdItem set OEORI_RecDep_DR=:RecDepId Where OEORI_RowId=:OEORIRowId)
    if SQLCODE {
	    d ##class(DHCDoc.Log.Common).General("Update","DHCDoc.Interface.Inside.Service","UpdateOEORI","更新医嘱信息失败",OEORIRowId,"SQL错误信息:"_$g(%mdiag(1)))
    }
    
    Q SQLCODE
}

/// lxz 
/// desc 获取身份证设备硬件参数
/// OutPut 设备参数配置ID^设备描述
/// w ##class(DHCDoc.Interface.Inside.Service).GetIECreat()
ClassMethod GetIECreat() As %String
{
	s Str=""
	s myGRowID=$o(^DHCCARDHARDCOMi("GROUP",0,"IE",0))
	s myMRowID=0
	f  s myMRowID=$o(^DHCCARDHARDCOMi("MANAGER",0,"CG",myGRowID,myMRowID))  q:(myMRowID="")  d
	.s myDateTo=+$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",15)
	.q:((+myDateTo'=0)&&(myDateTo<+$h))
	.s myDllType=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",16)
	.s myMDesc=$p(^DHCCARDHARDCOM("MANAGER",myMRowID),"^",2)
	.s myHCTypeDR=myMRowID
	.s Str=myMRowID_"^"_myMDesc
	q Str
}

ClassMethod FindEMROPItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEMROPItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 入参：就诊号，草药标识:CHMED 为草药,"" 为西药,Business：业务代码(SaveOrder/Finish)
/// 出参：医嘱名称，医嘱状态，医嘱优先级，开始日期，开始时间，剂量，剂量单位，频次，用法，疗程，单价，数量，数量单位，皮试，接收科室，用户登录科室，开医嘱科室，总金额，处方号，备注，开医嘱医生，医嘱添加人，开医嘱日期，序号，主序号，关联序号，标本号，医嘱ID，医嘱项ID，剂量单位ID，频次ID，医嘱优先级ID，用法ID，疗程ID，数量单位ID，接收科室ID，用户登录科室ID，开医嘱科室ID，医嘱状态ID，医嘱基本单位ID，开医嘱医生ID，医嘱添加人ID，医嘱套ID，药学项ID，最大疗程ID，医嘱类型，医嘱费别ID，医嘱费别，频次系数，频次间隔时间，疗程系数，关联医嘱ID,就诊Rowid,费别Rowid,是否有权限开此医嘱,医嘱项目备注,皮试备注,医嘱项目分类,草药处方附属信息
ClassMethod FindEMROPItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, CHMEDFlag As %String = "", Business As %String = "SaveOrder") As %Status
{
 	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems",11150695,"")
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	k OrdList
 	s AdmHospitalId=##Class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
 	if CHMEDFlag="CHMED" {
	 	;得到草药数据
	 	d getCHMEDEMRData()
 	}else{
	 	;得到非草药数据
	 	d getEMRData()
 	}
	
	s SeqNo=0
	;s adm=0 for  s adm=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm)) q:adm=""  d
	s mas=0 for  s mas=$O(OrdList("master",mas)) q:mas=""  d
	. s s1=OrdList("master",mas)
	. q:s1=""
	. i s1'="" d 
	. .s SeqNo=SeqNo+1
	. .s $List(s1,24)=SeqNo
	. .s Data=s1
	. .d OutputRow4
	. s SubSeqCount=0
	. s sub=0  for  s sub=$O(OrdList("master",mas,"sub",sub)) q:sub=""  d
	. . s s2=OrdList("master",mas,"sub",sub)
	. . i s1="" d
	.. .s SeqNo=SeqNo+1
	. . . s $List(s2,24)=SeqNo
	. . . s Data=s2
	.. .d OutputRow4
	. . e  d
	. . . s SubSeqCount=SubSeqCount+1
	. . . s SubSeqNo=SeqNo_"."_SubSeqCount
	. . . s $List(s2,24)=SubSeqNo
	. . . s Data=s2
	. . . d OutputRow4
	 K ^CacheTemp("DHCAdmOrdItem",$j,"adm")
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
getEMRData()
	s ret=""
	Set OrderId=$o(^OEORD(0,"Adm",EpisodeID,0))
	if OrderId="" Quit ""
	Set sub=0
	for  Set sub=$o(^OEORD(OrderId,"I",sub)) Quit:sub=""  do
	.d GetOrdItemInfo(OrderId,sub)
 	
 	q
GetOrdItemInfo(OrderId,sub)
	s OrdItemInfo=""
	s OrderItemRowid=OrderId_"||"_sub
 	s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
	Quit:OrderStatusRowid="" ""
 	s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
 	s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",2)
 	;协和保存医嘱时为未核实医嘱,完成接诊病历做比较,提示医生确认
 	Quit:((Business="Finish")&&(ItemStatCode'="V")&&(ItemStatCode'="E")) ""
 	Quit:((Business="SaveOrder")&&(ItemStatCode'="V")&&(ItemStatCode'="E")&&(ItemStatCode'="I")) ""
 	s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
 	Quit:(checkrtn="Reg")||(checkrtn="Check") ""
 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
 	Quit:DoctorDR="" ""
 	
	;非医生录入的医嘱退出
	s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
	s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	Q:(DoctorType'="DOCTOR") ""
	;检验自动绑定上的医嘱不显示
	s LinkLabNo=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",22)
	Q:LinkLabNo'="" ""
	;留观医生下的医嘱不同步到病历
	s EMStayFlag=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",17)
	//Q:EMStayFlag="1"
	Q:'$$IsMedicalRecords(OrderId_"||"_sub) ""
	 
 	s Subscript=$p(ARCIMRowid,"||",1)
 	s Version=$p(ARCIMRowid,"||",2)
 	s OrderName=$p(^ARCIM(Subscript,Version,1),"^",2)
 	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(OrderId_"||"_sub)
 	if (ReqPartDesc'="") s OrderName=OrderName_ReqPartDesc
 	s OrderPrior=""
 	s OrderPriorRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",8)
 	i OrderPriorRowid'="" s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
 	s OrderSttDate=$p($g(^OEORD(OrderId,"I",sub,1)),"^",9)
 	i OrderSttDate'="" s OrderSttDate=$zd(OrderSttDate,3)
 	s OrderSttTime=$p($g(^OEORD(OrderId,"I",sub,1)),"^",10)
 	i OrderSttTime'="" s OrderSttTime=..%ZT(OrderSttTime,1)
 	
 	s OrderDoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OrderItemRowid) //$p($g(^OEORD(OrderId,"I",sub,2)),"^",1)
 	S OrderDoseUOM=""
 	S OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
 	S OrderDur="",OrderDurFactor=""
 	s OrderDoseUOMRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",3)
 	i OrderDoseUOMRowid'="" D
 	.s OrderDoseUOM=$p(^CT("UOM",OrderDoseUOMRowid),"^",2)
 	s OrderFreqRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",4)
 	i OrderFreqRowid'="" d
 	.s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",4)
 	.s OrderFreqFactor=$p($g(^PHCFR(OrderFreqRowid)),"^",2)
 	.s OrderFreqInterval=$p($g(^PHCFR(OrderFreqRowid)),"^",9)
 	s OrderInstr=""
 	s OrderInstrRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",7)
 	i OrderInstrRowid'="" s OrderInstr=$p(^PHCIN(OrderInstrRowid),"^",2)
 	s OrderDurRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",6)
 	i OrderDurRowid'="" D
 	.s OrderDur=$p(^PHCDU(OrderDurRowid),"^",3)
 	.s OrderDurFactor=$p(^PHCDU(OrderDurRowid),"^",2)
 	s OrderPackQty=$p($g(^OEORD(OrderId,"I",sub,9)),"^",4)
	s OrderPackUOM=""
    s OrderPackUOMRowid=$p(^ARCIM(Subscript,Version,8),"^",14)
    i OrderPackUOMRowid'="" s OrderPackUOM=$p(^CT("UOM",OrderPackUOMRowid),"^",2)
 	s OrderBillTypeRowid=$p($g(^OEORD(OrderId,"I",sub,11)),"^",18)
 	s OrderRecDepRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",6)
 	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", OrderBillTypeRowid, ARCIMRowid, OrderSttDate, OrderPriorRowid, OrderInstrRowid, "", "",OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
	s OrderDoseQty=$TR(OrderDoseQty," ","")
	s OrderType=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i OrderType'="R" d
	. s DoseqtySum=$p($g(^OEORD(OrderId,"I",sub,1)),"^",12)
	. s OrderPackQty=DoseqtySum
	s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	
 	s ItemCatDR=$p(^ARCIM(Subscript,Version,1),"^",10)
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,AdmHospitalId,ARCIMRowid)
	Q:(PHPrescType=3) ""
	s OrderSkinTest=$p($g(^OEORD(OrderId,"I",sub,5)),"^",2)
	s OrderRecDep=""
	i OrderRecDepRowid'="" s OrderRecDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderUserDep=""
	s OrderUserDepRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",2)
	i OrderUserDepRowid'="" s OrderUserDep=$p(^CTLOC(OrderUserDepRowid),"^",2)
	s OrderPrescNo=$p($g(^OEORD(OrderId,"I",sub,1)),"^",14)
	s OrderDepProcNote=$g(^OEORD(OrderId,"I",sub,"DEP",1))
	s OrderDoc=""
	s OrderDocRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",11)
	i OrderDocRowid'="" s OrderDoc=$p($g(^CTPCP(OrderDocRowid,1)),"^",2)
	s OrderUserAdd=""
	s OrderUserAddRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",1)
	i OrderUserAddRowid'="" s OrderUserAdd=$p($g(^SSU("SSUSR",OrderUserAddRowid)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderId,"I",sub,3)),"^",7)
	i OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderSeqNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",4)
	s OrderMasterSeqNo=$p($g(^OEORD(OrderId,"I",sub,2)),"^",2)
	s OrderLabEpisodeNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",20)
	s OrderOrdDepRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",3)
	s OrderBaseUOMRowid=""
	s OrderARCOSRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",10)
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	;,,OrderItemInValid,TypeClass
	s OrderMaxDurRowid=""
	s LinkOrderItem=$p($g(^OEORD(OrderId,"I",sub,11)),"^",39)
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	s ArcService=""
	s ArcService=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
	s TypeClass=""
	i OrderType="R" d
	.i PHPrescType="3" s TypeClass="草药"
	.e  s TypeClass="西药"
	
	e  i OrderType="L" s TypeClass="检验"
	e  i $g(ArcService)="S" s TypeClass="检查"
	e  s TypeClass="其他"
	
	s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(OrderId_"||"_sub)
	s skintestremark=##class(web.DHCSTPCHCOLLS2).SkinTest2(OrderId_"||"_sub)
    s:skintestremark'="" ordremark=skintestremark_" "_ordremark
	
 	/*i OrderType="R" d
 	.s GenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(ARCIMRowid)
	.s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(Subscript)
	.s qty=""
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrderId_"||"_sub,"")) 
    .s:dsp'="" qty=$p(^DHCOEDISQTY(dsp),"^",2)
	.s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(InciRowid,qty)
    .s OrderPackQty=$p(qtyinfo,"^",1)
	.s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	.s inciDesc=$p(^INCI(InciRowid,1),"^",2)
	.s OrderName=inciDesc*/
	
	s Data1=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,ordremark,skintestremark,TypeClass,CHMEDNotes)
 	;
	s OrderChl=$P(OrderItemRowid,"||",2)
	s LinkOrderItemChl=$P(LinkOrderItem,"||",2)
	i LinkOrderItem="" s OrdList("master",OrderChl)=Data1
	e  d
	.if '$D(OrdList("master",LinkOrderItemChl)) d
	..s OrdList("master",LinkOrderItemChl)=""
	.s OrdList("master",LinkOrderItemChl,"sub",OrderChl)=Data1
	
 	q 1
IsMedicalRecords(OEORI)
	s ARCIM=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
	;是否上医嘱单,统一调用护理组方法判断
	;s rtn=##class(web.DHCNurseInterface).IfInOrderSheet(OEORI)
	;i rtn'="Y" q 0
	s OrderCategory=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",10)
	i ItemCatDR'="" {
		s OrderCategoryDR=$P(^ARC("IC",ItemCatDR),"^",8)
		i OrderCategoryDR'="" s OrderCategory=$p(^OEC("ORCAT",OrderCategoryDR),"^",2)
	}
	s OEORIBindSource=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",41)
	//Q:OEORIBindSource'="" 0
	;材料不上医嘱单
	;i OrderCategory["材料" q 0
	
	;特殊的一些项目不上医嘱单,特殊处理
	i $g(^DHCDocLocalSysP("OPDoc.MedicalRecords.SpecARCIM"))[("^"_ARCIM_"^") q 0
	
	q 1
getCHMEDEMRData()
	s QUE1RowID=""
	f  s QUE1RowID=$o(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUE1RowID)) q:QUE1RowID=""  d
	.q:'$d(^PAQUE1(QUE1RowID))
	.q:'$d(^PAQUE1(QUE1RowID,"DHC"))
	.s prestype=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2)
    .q:prestype'=3
    .//非医护人员录入不显示
	.s AddUser=$P(^PAQUE1(QUE1RowID,"DHC"),"^",3)
	.s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(AddUser)
	.s CareProvType=$zcvt(CareProvType,"U")
	.q:CareProvType'="DOCTOR"
	.s prescno=$p(^PAQUE1(QUE1RowID),"^",14)
	.s insdr=$p(^PAQUE1(QUE1RowID,"DHC"),"^",11)
    .s Instruc=""
    .i insdr'="" s Instruc=$p(^PHCIN(insdr),"^",1) ;用法
    .s durdr=$p(^PAQUE1(QUE1RowID,"DHC"),"^",10)
    .s facotor=""
    .i durdr'="" s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
    .s orderqty=$p(^PAQUE1(QUE1RowID,"DHC"),"^",13) ;用量
    .s CHMEDNotes="共"_facotor_"剂"_"  用法:"_Instruc_"   一次用量:"_orderqty
	.s OEORDRowId="",prescOrdNum=0, Ordret="",stopflag=0
	.f  s OEORDRowId=$o(^OEORD(0,"PrescNo",prescno,OEORDRowId)) q:OEORDRowId=""  d
	..s OEORIChildsub="" 
	..f  s OEORIChildsub=$o(^OEORD(0,"PrescNo",prescno,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
	...q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub))
	...s ItemStat=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
    ...q:ItemStat="4"
	...d getCHOrderItemInfo(OEORDRowId,OEORIChildsub)
	
	q
getCHOrderItemInfo(OrderId,sub)
	s OrdItemInfo=""
	s OrderItemRowid=OrderId_"||"_sub
 	s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
	Quit:OrderStatusRowid="" ""
 	s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
 	s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",2)
 	;协和保存医嘱时为未核实医嘱,完成接诊病历做比较,提示医生确认
 	Quit:((Business="Finish")&&(ItemStatCode'="V")&&(ItemStatCode'="E")) ""
 	Quit:((Business="SaveOrder")&&(ItemStatCode'="V")&&(ItemStatCode'="E")&&(ItemStatCode'="I")) ""
 	s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
 	Quit:(checkrtn="Reg")||(checkrtn="Check") ""
 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
 	Quit:DoctorDR="" ""
 	
	;非医生录入的医嘱退出
	s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
	s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	Q:(DoctorType'="DOCTOR") ""

	Q:'$$IsMedicalRecords(OrderId_"||"_sub) ""
	
	s Subscript=$p(ARCIMRowid,"||",1)
 	s Version=$p(ARCIMRowid,"||",2)
 	s OrderName=$p(^ARCIM(Subscript,Version,1),"^",2)
 	s OrderPrior=""
 	s OrderPriorRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",8)
 	i OrderPriorRowid'="" s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
 	s OrderSttDate=$p($g(^OEORD(OrderId,"I",sub,1)),"^",9)
 	i OrderSttDate'="" s OrderSttDate=$zd(OrderSttDate,3)
 	s OrderSttTime=$p($g(^OEORD(OrderId,"I",sub,1)),"^",10)
 	i OrderSttTime'="" s OrderSttTime=..%ZT(OrderSttTime,1)
 	
 	s OrderDoseQty=$p($g(^OEORD(OrderId,"I",sub,2)),"^",1)
 	S OrderDoseUOM=""
 	S OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
 	S OrderDur="",OrderDurFactor=""
 	;s OrderDoseUOMRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",3)
 	;i OrderDoseUOMRowid'="" D
 	;.s OrderDoseUOM=$p(^CT("UOM",OrderDoseUOMRowid),"^",2)
 	s Phcdf=$P($g(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",12)
    if Phcdf'="" s OrderDoseUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4),OrderDoseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderDoseUOMRowid)
 	s OrderFreqRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",4)
 	i OrderFreqRowid'="" d
 	.s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",4)
 	.s OrderFreqFactor=$p($g(^PHCFR(OrderFreqRowid)),"^",2)
 	.s OrderFreqInterval=$p($g(^PHCFR(OrderFreqRowid)),"^",9)
 	s OrderInstr=""
 	s OrderInstrRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",7)
 	i OrderInstrRowid'="" s OrderInstr=$p(^PHCIN(OrderInstrRowid),"^",2)
 	s OrderDurRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",6)
 	i OrderDurRowid'="" D
 	.s OrderDur=$p(^PHCDU(OrderDurRowid),"^",3)
 	.s OrderDurFactor=$p(^PHCDU(OrderDurRowid),"^",2)
 	s OrderPackQty=$p($g(^OEORD(OrderId,"I",sub,9)),"^",4)
	s OrderPackUOM=""
    s OrderPackUOMRowid=$p(^ARCIM(Subscript,Version,8),"^",14)
    i OrderPackUOMRowid'="" s OrderPackUOM=$p(^CT("UOM",OrderPackUOMRowid),"^",2)
 	s OrderBillTypeRowid=$p($g(^OEORD(OrderId,"I",sub,11)),"^",18)
 	s OrderRecDepRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",6)
 	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", OrderBillTypeRowid, ARCIMRowid, OrderSttDate, OrderPriorRowid, OrderInstrRowid, "", "",OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
	s OrderDoseQty=$TR(OrderDoseQty," ","")
	s OrderType=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i OrderType'="R" d
	. s DoseqtySum=$p($g(^OEORD(OrderId,"I",sub,1)),"^",12)
	. s OrderPackQty=DoseqtySum
	s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	
 	s ItemCatDR=$p(^ARCIM(Subscript,Version,1),"^",10)
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,AdmHospitalId,ARCIMRowid)
	Q:(PHPrescType'=3) ""
	s OrderSkinTest=$p($g(^OEORD(OrderId,"I",sub,5)),"^",2)
	s OrderRecDep=""
	i OrderRecDepRowid'="" s OrderRecDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderUserDep=""
	s OrderUserDepRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",2)
	i OrderUserDepRowid'="" s OrderUserDep=$p(^CTLOC(OrderUserDepRowid),"^",2)
	s OrderPrescNo=$p($g(^OEORD(OrderId,"I",sub,1)),"^",14)
	s OrderDepProcNote=$g(^OEORD(OrderId,"I",sub,"DEP",1))
	s OrderDoc=""
	s OrderDocRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",11)
	i OrderDocRowid'="" s OrderDoc=$p($g(^CTPCP(OrderDocRowid,1)),"^",2)
	s OrderUserAdd=""
	s OrderUserAddRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",1)
	i OrderUserAddRowid'="" s OrderUserAdd=$p($g(^SSU("SSUSR",OrderUserAddRowid)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderId,"I",sub,3)),"^",7)
	i OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderSeqNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",4)
	s OrderMasterSeqNo=$p($g(^OEORD(OrderId,"I",sub,2)),"^",2)
	s OrderLabEpisodeNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",20)
	s OrderOrdDepRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",3)
	s OrderBaseUOMRowid=""
	s OrderARCOSRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",10)
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	;,,OrderItemInValid,TypeClass
	s OrderMaxDurRowid=""
	s LinkOrderItem=$p($g(^OEORD(OrderId,"I",sub,11)),"^",39)
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	s ArcService=""
	s ArcService=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
	s TypeClass=""
	i OrderType="R" d
	.i PHPrescType="3" s TypeClass="草药"
	.e  s TypeClass="西药"
	e  i OrderType="L" s TypeClass="检验"
	e  i $g(ArcService)="S" s TypeClass="检查"	s ArcService=""	
	e  s TypeClass="其他"
	///e  i (" Service S ")[(" "_ServerMaterial_" ") s TypeClass="检查"
	s ordremark=OrderDepProcNote
	s skintestremark=""
	s actiondr=$p(^OEORD(OrderId,"I",sub,11),"^",21) 
	i actiondr'="" s skintestremark=$p(^OEC("ACT",actiondr),"^",2)
	
 	/*i OrderType="R" d
 	.s GenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(ARCIMRowid)
	.s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(Subscript)
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrderId_"||"_sub,"")) 
    .s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	.s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(InciRowid,qty)
    .s OrderPackQty=$p(qtyinfo,"^",1)
	.s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	.s inciDesc=$p(^INCI(InciRowid,1),"^",2)
	.s OrderName=inciDesc_" "_Spec*/
	s Data1=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,ordremark,skintestremark,TypeClass,CHMEDNotes)
 	;
	s OrderChl=$P(OrderItemRowid,"||",2)
	s LinkOrderItemChl=$P(LinkOrderItem,"||",2)
	i LinkOrderItem="" s OrdList("master",OrderChl)=Data1
	e  d
	.if '$D(OrdList("master",LinkOrderItemChl)) d
	..s OrdList("master",LinkOrderItemChl)=""
	.s OrdList("master",LinkOrderItemChl,"sub",OrderChl)=Data1
	
	q	
	 
OutputRow4
	;set Data=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderLinkto,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindEMROPItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEMROPItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      郭荣勇
/// CreatDate:    2018.03.14
/// Description:  【私有接口,定向,电子病历组调用】提供医嘱数据数据给门诊电子病历【仅限门诊】
/// Table:        
/// Input:        入参：就诊号，是否草药标识(CHMED 为草药,空 为非草药)，业务代码(SaveOrder/Finish)
/// Return:       出参：医嘱名称，医嘱状态，医嘱优先级，开始日期，开始时间，剂量，剂量单位，频次，用法，疗程，单价，数量，数量单位，皮试，接收科室，用户登录科室，开医嘱科室，总金额，处方号，备注，开医嘱医生，医嘱添加人，开医嘱日期，序号，主序号，关联序号，标本号，医嘱ID，医嘱项ID，剂量单位ID，频次ID，医嘱优先级ID，用法ID，疗程ID，数量单位ID，接收科室ID，用户登录科室ID，开医嘱科室ID，医嘱状态ID，医嘱基本单位ID，开医嘱医生ID，医嘱添加人ID，医嘱套ID，药学项ID，最大疗程ID，医嘱类型，医嘱费别ID，医嘱费别，频次系数，频次间隔时间，疗程系数，关联医嘱ID,就诊Rowid,费别Rowid,是否有权限开此医嘱,医嘱项目备注,皮试备注,医嘱项目分类,草药处方附属信息
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems","166","","")
Query FindEMROPItems(EpisodeID As %String, CHMEDFlag As %String = "", Business As %String = "SaveOrder") As %Library.Query(CONTAINID = "", ROWSPEC = "OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDoseQty:%String,OrderDoseUOM:%String,OrderFreq:%String,OrderInstr:%String,OrderDur:%String,OrderPrice:%String,OrderPackQty:%String,OrderPackUOM:%String,OrderSkinTest:%String,OrderRecDep:%String,OrderUserDep:%String,OrderOrdDep:%String,OrderSum:%String,OrderPrescNo:%String,OrderDepProcNote:%String,OrderDoc:%String,OrderUserAdd:%String,OrderDate:%String,OrderSeqNo:%String,OrderMasterSeqNo:%String,OrderLinkTo:%String,OrderLabEpisodeNo:%String,OrderItemRowid:%String,OrderARCIMRowid:%String,OrderDoseUOMRowid:%String,OrderFreqRowid:%String,OrderPriorRowid:%String,OrderInstrRowid:%String,OrderDurRowid:%String,OrderPackUOMRowid:%String,OrderRecDepRowid:%String,OrderUserDepRowid:%String,OrderOrdDepRowid:%String,OrderStatusRowid:%String,OrderBaseUOMRowid:%String,OrderDocRowid:%String,OrderUserAddRowid:%String,OrderARCOSRowid:%String,OrderDrugFormRowid:%String,OrderMaxDurRowid:%String,OrderType:%String,OrderBillTypeRowid:%String,OrderBillType:%String,OrderFreqFactor:%String,OrderFreqInterval:%String,OrderDurFactor:%String,LinkOrderItem:%String,EpisodeID:%String,OrderBillTypeRowId:%String,OrderItemInValid:%String,ordremark:%String,skintestremark:%String,TypeClass:%String,CHMEDNotes:%String")
{
}

ClassMethod DiagnosListExecute(ByRef qHandle As %Binary, MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","DiagnosList","35","","")
	n (qHandle , MRADMID, ICDType , DiagnosTypeCode)
	Set repid2=$I(^CacheTemp)
	If $g(ind2)="" Set ind2=1
	Set qHandle=$lb(0,repid2,0)
	if MRADMID="" {  
		Quit $$$OK
	}
	Set rsObj=##Class(%ResultSet).%New("DHCDoc.Interface.Inside.ServiceDiag:DiagnosList")
	If rsObj.QueryIsValid() { 
		 Set Status=rsObj.Execute(MRADMID,ICDType,DiagnosTypeCode)
		 If 'Status Quit $$$OK
		 Set columns = rsObj.GetColumnCount()
		 While rsObj.Next() {
			s Data=$LISTFROMSTRING($P(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,",",",columns),",")
			
			for i=1:1:columns {
				s $list(Data,i)=rsObj.GetData(i)
			}
			Set ^CacheTemp(repid2,ind2)=Data
			Set ind2=ind2+1
		 }
	}
	kill rsObj
	
	
	Quit $$$OK
}

/// Creator:      郭荣勇
/// CreatDate:    2018.03.20
/// Description:  获取本次就诊诊断记录
/// Table:        
/// Input:        入参：MR_Adm表Rowid，是否获取中医诊断.(1 中医,空或0 西医)，诊断类型代码.(空 获取全部,不为空 获取指定诊断代码的诊断)
/// Return:       出参：ICD描述 诊断表ID ICD诊断ID 诊断注释 ICDCode 诊断类型 诊断注释 日期 发病日期 诊断状态描述 诊断级别(数字) 主诊断标识(Y/N) 诊断前缀描述 分类(西医、中医、证型) 录入人
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","DiagnosList","35","","")
Query DiagnosList(MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "") As websys.Query(ROWSPEC = "DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate:%String,DiagStat:%String,DiagnosLeavel:%String,MainDiagFlag:%String,DiagnosPrefix:%String,DiagnosNumber:%String,MRDIAAddLocDr:%String,MRDIADocCode:%String,MRDIADocDesc:%String,MRdiagnosTime:%String,DiagnosCat:%String,SDSDesc:%String")
{
}

/// Creator:      谭吉善
/// CreatDate:    2018.03.23
/// Description:  【私有接口,未经产品组允许不得使用】批量替换医嘱套中的医嘱项目
/// Table:        
/// Input:        入参：需要替换的医嘱项id，新医嘱项id
/// Return:       出参：0 成功；非0失败
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).ReplaceARCOSItem("747886||227") 
ClassMethod ReplaceARCOSItem(OldArcimRowID As %String, NewArcimRowID As %String) As %String
{
	n (OldArcimRowID, NewArcimRowID)
	s ret=##Class(web.DHCArcositm).upacosarcim(OldArcimRowID, NewArcimRowID)
	q ret
}

/// Creator:      谭吉善
/// CreatDate:    2018.03.23
/// Description:  【私有接口,未经产品组允许不得使用】批量替换医嘱模板中的医嘱项目
/// Table:        
/// Input:        入参：需要替换的医嘱项id，新医嘱项id
/// Return:       出参：0 成功；非0失败
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).ReplacePreferItem("836||1","1346||1") 
ClassMethod ReplacePreferItem(OldArcimRowID As %String, NewArcimRowID As %String) As %String
{
	n (OldArcimRowID, NewArcimRowID)
	s ret=0
	k OutPutData
 	s groupitemDelim=$C(28)
	s itemdataDelim=$C(4)
	s tabgroupDelim=$C(1)
 	s AppKeyDesc="%ORDER%"
	&sql(declare QueryPrefer cursor  for 
		select distinct ID,AppKey,AppSubKey,Data,ObjectReference,ObjectType
    	from websys.Preferences WHERE (AppKey like :AppKeyDesc))
	&sql(open QueryPrefer)
	for{
		&sql(fetch QueryPrefer into :ID,:AppKey,:AppSubKey,:Data,:ObjectReference,:ObjectType)
		q:SQLCODE
		s TABLIST=$lg(Data,3)
		for i=1:1:$listlength(TABLIST){
			s TABLIST(i)=$listget(TABLIST,i)
		}
		///TABLIST()存储的表列表数据
		///先遍历表列表
		s LISTTabsRowID=0
		for {
			s LISTTabsRowID=$o(TABLIST(LISTTabsRowID))
			q:LISTTabsRowID=""
			s Desc=$P(TABLIST(LISTTabsRowID),tabgroupDelim,1)
			if (TABLIST(LISTTabsRowID)[("ARCIM"_$c(4)_OldArcimRowID)){
				s OutPutData($o(OutPutData(""),-1)+1)=ID_"||"_LISTTabsRowID_"^"_Desc_"^"_ObjectReference_"^"_ObjectType
			}
		}
	}
	&sql(close QueryPrefer)
	s Index=0
	for {
		s Index=$O(OutPutData(Index))
		q:Index=""
		s val=$G(OutPutData(Index))
		s IDStr=$P(val,"^",1)
		s RowID=$p(IDStr,"||",1)
		s LISTTabsRowID=$p(IDStr,"||",2)
		
		s obj=##Class(websys.Preferences).%OpenId(RowID)
		continue:('$IsObject(obj))
		s Data=obj.Data
		s TABLIST=$lg(Data,3)
		///TABLIST()存储的表列表数据
		for i=1:1:$listlength(TABLIST){
			s TABLIST(i)=$listget(TABLIST,i)
		}
		continue:'$d(TABLIST(LISTTabsRowID)) //"-5^表列表数据不存在"
		continue:(TABLIST(LISTTabsRowID)'[("ARCIM"_$c(4)_OldArcimRowID)) //"-10^表列表数据中未查询到原始医嘱"
		s TABLIST(LISTTabsRowID)=$replace(TABLIST(LISTTabsRowID),"ARCIM"_$c(4)_OldArcimRowID,"ARCIM"_$c(4)_NewArcimRowID)
		s $list(TABLIST,LISTTabsRowID)=TABLIST(LISTTabsRowID)
		s $list(Data,3)=TABLIST
		s obj.Data=Data
		
		s save=obj.%Save(0)
		d obj.%Close()
		i (save'=1){
			s ret=ret=1
		}
	}
	q ret
}

/// Creator:      谭吉善
/// CreatDate:    2018.03.29
/// Description:  获取病人过敏信息
/// Table:        
/// Input:        入参：PatientID患者主索引ID,QueryAllergiesList需要展示的记录id串（非必填项,^分割）
/// Return:       出参：见文档《HIS标准接口定义.doc》
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","Allergies","173")
Query Allergies(PatientID As %String, QueryAllergiesList As %String = "") As websys.Query(ROWSPEC = "RowID:%String,Category:%String,Allergen:%String,ALGItem:%String,tag:%String,ALGItemRowID:%String,NatureOfReaction:%String,Severity:%String,SeverityColour:%String,OnsetDate:%Date,OnsetDateFreeText:%String,CareProvider:%String,InActive:%Boolean,OnsetDateText:%String,RowHexColour:%String,LastUpdateDate:%Date,LastUpdateTime:%Time,LastUpdateUser:%String,LastUpdateHospital:%String,Status:%String,ExternalID:%String,LastUpdateUserRole:%String,LastUpdateUserId:%String,Comments:%String,ALGFreeTextAllergy:%String,DrugSpecific:%Boolean,ALGDSReportFlag:%Boolean,HiddenFields:%String")
{
}

ClassMethod AllergiesExecute(ByRef qHandle As %Binary, PatientID As %String, QueryAllergiesList As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","Allergies","142")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if PatientID="" {  
	    d ResetAllergiesVar
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set rsObj=##Class(%ResultSet).%New("web.DHCPAAllergy:Allergies")
	If rsObj.QueryIsValid() {
		 Set Status=rsObj.Execute(PatientID)
		 If 'Status Quit
		 While rsObj.Next() {
			s RowID=rsObj.GetData(1)
			continue:(QueryAllergiesList'="")&&(("^"_QueryAllergiesList_"^")'[("^"_RowID_"^"))
			//过敏分类
			s Category=rsObj.GetData(2)
			//自定义过敏分类
			s Allergen=rsObj.GetData(3)
			//过敏源名称
			s ALGItem=rsObj.GetData(4)
			//分类
			s tag=rsObj.GetData(25)
			//i (tag="P")!(tag="G")!(tag="I") s tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",tag)
			s ALGItemRowID=""
			s ALGTypeDR=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",9)	;PACAllergy
			s ALGPHCGEDR=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",4) ;通用名 PHC_Generic
			s ALGPHCDMDR=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",27) ;药学项 PHC_DrgMast
			s:ALGTypeDR'="" ALGItemRowID=ALGTypeDR
			s:ALGPHCGEDR'="" ALGItemRowID=ALGPHCGEDR	//,tag="G"
			s:ALGPHCDMDR'="" ALGItemRowID=ALGPHCDMDR	//,tag="P"
			//拮抗反应
			s NatureOfReaction=rsObj.GetData(5)
			//严重
			s Severity=rsObj.GetData(6)
			//严重颜色
			s SeverityColour=rsObj.GetData(7)
			//发作日期-系统日期
			s OnsetDate=rsObj.GetData(8)
			//发作日期文字补充
			s OnsetDateFreeText=rsObj.GetData(9)
			//医护人员
			s CareProvider=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",1)
			if (CareProvider'=""){
				s CareProvider=$P($G(^CTPCP(CareProvider,1)),"^",2)
			}
			//未激活标志 Y/N
			s InActive=rsObj.GetData(11)
			//发作日期描述
			s OnsetDateText=rsObj.GetData(12)
			//不明
			s RowHexColour=rsObj.GetData(13)
			//最近一次更新日期
			s LastUpdateDate=rsObj.GetData(14)
			//最近一次更新时间
			s LastUpdateTime=rsObj.GetData(15)
			//最近一次更新人
			s LastUpdateUser=rsObj.GetData(16)
			//最近一次更新医院描述
			s LastUpdateHospital=rsObj.GetData(17)
			//状态
			s Status=rsObj.GetData(18)
			s Status=##class(websys.StandardTypeItem).GetDescription("AllergyStatus",Status)
			//医嘱项id
			s ExternalID=rsObj.GetData(19)
			//最后更新用户
			s LastUpdateUserRole=rsObj.GetData(20)
			//最后更新用户ID
			s LastUpdateUserId=rsObj.GetData(21)
			//过敏情况补充
			s Comments=rsObj.GetData(22)
			//
			s ALGFreeTextAllergy=rsObj.GetData(23)
			//是否药品YN
			s DrugSpecific=rsObj.GetData(24)
			//不明
			s ALGDSReportFlag=rsObj.GetData(26)
			//不明
			s HiddenFields=rsObj.GetData(27)
			 
			d AllergiesOutput
		}
	}
	kill rsObj
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
AllergiesOutput
	set Data=$lb(RowID,Category,Allergen,ALGItem,tag,ALGItemRowID,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,DrugSpecific,ALGDSReportFlag,HiddenFields)  //
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetAllergiesVar
	set (RowID,Category,Allergen,ALGItem,ALGItemRowID,tag,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,DrugSpecific,ALGDSReportFlag,HiddenFields)=""
	quit
}

/// Creator:      谭吉善
/// CreatDate:    2018.05.02
/// Description:  医保控费获取医嘱信息接口方法
/// Table:        
/// Input:        OEORIRowId:医嘱ID
/// Return:       中草药单复方标志(0是单方，1是复方)^给药途径代码^给药途径描述(口服、注射等)^药品标志(Y为药品)^处方号^用药天数^出院带药标志^处方费别
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GenOrdInfoByInsuCost("91||201") 
ClassMethod GenOrdInfoByInsuCost(OEORIRowId As %String) As %String
{
	n (OEORIRowId)
	s OrderID=$P(OEORIRowId,"||",1)
	s SubID=$P(OEORIRowId,"||",2)
	q:(SubID="")||(OrderID="") ""
	q:'$D(^OEORD(OrderID,"I",SubID,1)) ""
	s ARCIMRowID=$p(^OEORD(OrderID,"I",SubID,1),"^",2)
	s ItemCatDR=$p(^ARCIM(+ARCIMRowID,$p(ARCIMRowID,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s IsCNMedItem=##Class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowID)
	s OrderPrescNo=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",14)
	s OrderPrescSeqNo=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",15)
	s OrderFreqRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",4) ; OEORI_PHFreq_DR
	s OrderDurRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",6) ;OEORI_Durat_DR
	s OrderInstrRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",7) ; OEORI_Instr_DR
	s PriorityDR = $p($g(^OEORD(OrderID,"I",SubID,1)),"^",8)
	s OrderBillTypeRowid=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",18)
	
	s SDFlag=0
	if (IsCNMedItem=1)&&($P(OrderPrescSeqNo,"/",2)>1){
		s SDFlag=1
	}
	s (OrderInstrCode,OrderInstrDesc)=""
	if (OrderInstrRowid'=""){
		s OrderInstrDesc=$P($g(^PHCIN(OrderInstrRowid)),"^",2)
		s OrderInstrCode=$P($g(^PHCIN(OrderInstrRowid)),"^",1)
	}
	s DrugFlag="N"
	if (OrderType="R"){
		s DrugFlag="Y"
	}
	s OEORIPriorityCode=$p(^OECPR(PriorityDR),"^",1)
	s OUTFlag=0
	if (OEORIPriorityCode["OUT"){
		s OUTFlag=1
	}
	s OrderDurFactory=1
	if (OrderDurRowid'=""){
		s OrderDurFactory=$P(^PHCDU(OrderDurRowid),"^",2)
	}
	s OutPutInfo=SDFlag_"^"_OrderInstrCode_"^"_OrderInstrDesc_"^"_DrugFlag_"^"_OrderPrescNo_"^"_OrderDurFactory_"^"_OUTFlag_"^"_OrderBillTypeRowid
	
	q OutPutInfo
}

/// Creator:      宋春莉
/// CreatDate:    2018.08.23
/// Description:  取患者本次就诊生理指标Code+描述
/// Table:        
/// Input:        AdmId:就诊RowId
/// Return:      Code_"^"_描述_"^"_id
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetPhysiologicalCycle("4182") 
ClassMethod GetPhysiologicalCycle(AdmId As %String)
{
	n (AdmId)
	s mradm=$p(^PAADM(AdmId),"^",61)
	s PhysiologicalCycleId=$p($G(^MR(mradm,"DHC")),"^",9)
	q:PhysiologicalCycleId="" "^"
	s desc=$p($g(^DHCPHYC(PhysiologicalCycleId)),"^",2)
	s code=$p($g(^DHCPHYC(PhysiologicalCycleId)),"^",1)
	q code_"^"_desc_"^"_PhysiologicalCycleId
}

/// Creator:      屈坚
/// CreatDate:    2018.11.23
/// Description:  护士分床时默认插入管床医生的上级医生和主(副)任医生
/// Table:        
/// Input:        UserID:管床医生的UserID, LocID:科室id, Adm:就诊RowId
/// Return:      0为成功
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).InsertDefinedThreeCheckDoc("4634","110","305") 
ClassMethod InsertDefinedThreeCheckDoc(UserID As %String, LocID As %String, Adm As %String)
{
	n (UserID,LocID,Adm)
	s rtn=##class(web.DHCDocThreeCheckListAdm).InsertDefinedThreeCheck(UserID,LocID,Adm)
	q rtn
}

/// Creator:      屈坚
/// CreatDate:    2018.11.23
/// Description:  得到该病人的管床医生的上级医生和主(副)任医生
/// Table:        
/// Input:        UserID:管床医生的UserID, LocID:科室id, Adm:就诊RowId
/// Return:      json串 [{"UserID":"4808","UserDesc":"陆玉梅","Type":"主(副)任医师"},{"UserID":"5007","UserDesc":"王耀锋","Type":"上级医师"}]
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetAdmThreeCheckDoc("4634","110","305")
ClassMethod GetAdmThreeCheckDoc(UserID As %String = "", LocID As %String, Adm As %String)
{
	n (UserID,LocID,Adm)
	if UserID="" {
		s AdmDoc=$P(^PAADM(Adm),"^",9) 
		s UserID=$O(^SSU("SSUSR",0,"CTPCP",AdmDoc,""),-1)
		}
	s json="["
	Set rset = ##class(%ResultSet).%New("web.DHCDocThreeCheckListAdm:FindThreeDocAdm")
	Set columns = rset.GetColumnCount()
	// Execute the query
	Set rs = rset.Execute(UserID,LocID,Adm)
	While (rset.Next()) {
		s ActiveFlag=$g(rset.Data("ActiveFlag"))
		continue:ActiveFlag'="Y"
		s UserIDDR=$g(rset.Data("UserID"))
		s UserDesc=$g(rset.Data("UserDesc"))
		s TypeDesc=$g(rset.Data("Type"))
		if TypeDesc="主(副)任医师" s Type=3
		if TypeDesc="上级医师" s Type=2
		s OneJsonData="{""UserID"":"""_$g(UserIDDR)_""",""UserDesc"":"""_$g(UserDesc)_""",""Type"":"""_$g(Type)_""",""TypeDesc"":"""_$g(TypeDesc)_""""
		s OneJsonData=OneJsonData_"}"
		if json="[" s json=json_OneJsonData
		else  s json=json_","_OneJsonData
		}
	s UserDesc=$p(^SSU("SSUSR",UserID),"^",2)
	s OneJsonData="{""UserID"":"""_$g(UserID)_""",""UserDesc"":"""_$g(UserDesc)_""",""Type"":"""_"1"_""",""TypeDesc"":"""_"管床医师"_""""
	s OneJsonData=OneJsonData_"}"
	if json="[" s json=json_OneJsonData
	else  s json=json_","_OneJsonData
	s json=json_"]"
	q json
}

/// Creator:      宋春莉
/// CreatDate:    2019.01.14
/// Description:  判断是否为皮试用法医嘱
/// Table:        
/// Input:       医嘱id
/// Return:      0：非皮试用法医嘱 1：皮试用法医嘱
/// Others:      w ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsSkinInstr()
ClassMethod CheckOrdIsSkinInstr(OEORIRowId As %String)
{
	Q:OEORIRowId="" 0
	s OrderInstrRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),2)),"^",7)
	Q:OrderInstrRowid="" 0
	;皮试用法
	s SkinTestInstr=..%GetConfig("SkinTestInstr")
	if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
	if (SkinTestInstr'="")&&(SkinTestInstr[("^"_OrderInstrRowid_"^")){
		Q 1
	}
	Q 0
}

/// Creator:      宋春莉
/// CreatDate:    2019.01.17
/// Description:  判断就诊是否存在草药或西药医嘱
/// Table:        
/// Input:       就诊ID
/// Return:      0：不存在 1：存在
/// Others:      w ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsExist()
ClassMethod CheckOrdIsExist(EpisodeID As %String, CHMEDFlag As %String = "")
{
	s rtn=0
	Set OrderId=$o(^OEORD(0,"Adm",EpisodeID,0))
	if OrderId="" Quit rtn
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	Set sub=0
	for  {
		Set sub=$o(^OEORD(OrderId,"I",sub)) 
		Quit:(sub="")||(rtn=1)
		s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
		continue:OrderStatusRowid="" 
		s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
		continue:(ItemStatCode'="V")&&(ItemStatCode'="E")
		s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
	 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
	 	continue:(checkrtn="Reg")||(checkrtn="Check") 
	 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
	 	continue:DoctorDR=""
	 	;非医生录入的医嘱退出
		s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
		s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
		continue:(DoctorType'="DOCTOR") 
		;检验自动绑定上的医嘱不显示
		s LinkLabNo=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",22)
		continue:LinkLabNo'="" 
		;留观医生下的医嘱不同步到病历
		s EMStayFlag=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",17)
		continue:EMStayFlag="1"
		continue:'$$IsMedicalRecord(OrderId_"||"_sub)
		s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10) 
		s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,AdmHospitalId,ARCIMRowid)
		continue:(PHPrescType=3)&&(CHMEDFlag'="CHMED") 
		continue:(PHPrescType'=3)&&(CHMEDFlag="CHMED") 
		s rtn=1
	}
	Q rtn
IsMedicalRecord(OEORI)
	s ARCIM=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
	;是否上医嘱单,统一调用护理组方法判断
	;s rtn=##class(web.DHCNurseInterface).IfInOrderSheet(OEORI)
	;i rtn'="Y" q 0
	s OrderCategory=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",10)
	i ItemCatDR'="" {
		s OrderCategoryDR=$P(^ARC("IC",ItemCatDR),"^",8)
		i OrderCategoryDR'="" s OrderCategory=$p(^OEC("ORCAT",OrderCategoryDR),"^",2)
	}
	s OEORIBindSource=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",41)
	Q:OEORIBindSource'="" 0
	;材料不上医嘱单
	;i OrderCategory["材料" q 0
	
	;特殊的一些项目不上医嘱单,特殊处理
	i $g(^DHCDocLocalSysP("OPDoc.MedicalRecords.SpecARCIM"))[("^"_ARCIM_"^") q 0
	
	q 1
}

/// Creator:      宋春莉
/// CreatDate:    2019.04.26
/// Description:  根据长效诊断，对住院新产生的就诊记录自动插入有效诊断
/// Table:        
/// Input:       就诊ID,UserRowId操作用户ID
/// Return:      0：成功 其他失败
/// Others:      w ##class(DHCDoc.Interface.Inside.Service).InsertPALongICD()
ClassMethod InsertPALongICD(EpisodeID As %String, UserRowId As %String)
{
	Q ##class(web.DHCDocDiagnosEntryV8).InsertPALongICD(EpisodeID,UserRowId)
}

/// Creator:      宋春莉
/// CreatDate:    2019.06.19
/// Description:  根据医嘱ID获取同频次不同剂量串
/// Table:        
/// Input:       
/// Return:      OEORIRowId 医嘱ID;SearchDate 需要展示的日期,系统日期
/// Others:      w ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty("3||33")
ClassMethod GetOrdDoseQty(OEORIRowId As %String, SearchDate As %String = "") As %String
{
	n (OEORIRowId,SearchDate)
	q ##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdDoseQty(OEORIRowId,SearchDate)
}

/// CTOR: QP
/// DATE: 2019-10-14
/// DESC: 【公共接口】获取医嘱数据数据
/// IN  :  {EpisodeID:109,OEORIItmMastDR:1074||1}
/// JsonInput:目前支持的属性有 
/// =====================================================================================
/// EpisodeID、OEORI_PrescNo、OEORI_Anaest_DR、OEORI_AnaOper_DR、OEORI_AnaestAgent_DR、OEORI_APPT_DR
/// OEORI_WaitList_DR、OEORI_ClinPathways_DR、OEORI_ManufacturerOrder_DR、OEORI_ItemGroup
/// OEORI_HICClaimNo、OEORI_LabEpisodeNo、OEORI_Consult_DR、OEORI_Date、OEORI_XDate、OEORI_BilledDate
/// OEORI_ItmMast_DR、OEORI_BBExtCode、OEORI_Priority_DR、OEORI_LabTestSetRow
/// 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","QryOeoriCommon","")
Query QryOeoriCommon(JsonInput As %String) As %Query(ROWSPEC = "seqno:%String,OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDoseQty:%String,OrderDoseUOM:%String,OrderFreq:%String,OrderInstr:%String,OrderDur:%String,OrderPrice:%String,OrderPackQty:%String,OrderPackUOM:%String,OrderSkinTest:%String,OrderRecDep:%String,OrderUserDep:%String,OrderOrdDep:%String,OrderSum:%String,OrderPrescNo:%String,OrderDepProcNote:%String,OrderDoc:%String,OrderUserAdd:%String,OrderDate:%String,OrderSeqNo:%String,OrderMasterSeqNo:%String,OrderLinkTo:%String,OrderLabEpisodeNo:%String,OrderItemRowid:%String,OrderARCIMRowid:%String,OrderDoseUOMRowid:%String,OrderFreqRowid:%String,OrderPriorRowid:%String,OrderInstrRowid:%String,OrderDurRowid:%String,OrderPackUOMRowid:%String,OrderRecDepRowid:%String,OrderUserDepRowid:%String,OrderOrdDepRowid:%String,OrderStatusRowid:%String,OrderBaseUOMRowid:%String,OrderDocRowid:%String,OrderUserAddRowid:%String,OrderARCOSRowid:%String,OrderDrugFormRowid:%String,OrderMaxDurRowid:%String,OrderType:%String,OrderBillTypeRowid:%String,OrderBillType:%String,OrderFreqFactor:%String,OrderFreqInterval:%String,OrderDurFactor:%String,LinkOrderItem:%String,EpisodeID:%String,OrderBillTypeRowId:%String,OrderItemInValid:%String,ordremark:%String,skintestremark:%String,TypeClass:%String,CHMEDNotes:%String")
{
}

ClassMethod QryOeoriCommonExecute(ByRef qHandle As %Binary, JsonInput As %Library.String) As %Status
{
	n (qHandle,JsonInput)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//s JsonInput = "{EpisodeID:""109"",""OEORIOEORDParRef"":""103"",OEORIItmMastDR:""1074||1"",""OEORIPrescNo"":""E190202000029""}"
	if (JsonInput="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK		
	}
	s sqlStr = "SELECT * FROM SQLUser.OE_OrdItem WHERE "
	s sqlPre = "",OrderParref="",sqlAdm=""
	s JsonObj = ##class(ext.util.JsonObject).FromJSON(JsonInput)
	i ($$GetOrderParref=1) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	d BuildPreIndex
	d BuildAfterIndex
	
	s sqlStr = sqlStr_sqlPre_sqlAfter
	;w sqlStr,!
	s tStatement = ##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(sqlStr)
	if (qStatus'=1) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s x=tStatement.%Metadata.columns.Count()
	set rset = tStatement.%Execute()
	s totalRecord=0,seqno=0
	s totalColumn=rset.%ResultColumnCount
	WHILE rset.%Next() {
    	//s seqno=rset.%ROWCOUNT
    	//s name=rset.%StatementTypeName
     	//DO rset.%Print("^|^")
     	s record=""
     	s totalRecord=totalRecord+1
     	s (OrderName,OrderStatus,OrderPrior,OrderStartDate,OrderStartTime)=""
     	s (OrderARCIMRowid,OrderStatusRowid,OrderPriorRowid,oeori)=""
     	for j=1:1:totalColumn {
	  		s column=tStatement.%Metadata.columns.GetAt(j)
	  		s colName=column.colName
	  		s colValue=rset.%GetData(j)
	  		i colName="OEORI_RowId" s oeori=colValue
	  		Q:oeori'=""
		}
		continue:oeori=""
		s OrderId=$p(oeori,"||",1)
		s sub=$p(oeori,"||",2)
		d GeOeoriInfo(OrderId,sub)
    } 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
BuildDateIndex
	s DateIndex(1)="OEORIDate:OEORI_Date"
	s dateLen=$o(DateIndex(""),-1)
	s sqlDate=""
	f i=1:1:dateLen {
		s cItem=DateIndex(i)
		s cKey=$p(cItem,":",1)
		s cSqlName=$p(cItem,":",2)
		s cValue=JsonObj.GetValue(cKey)
		if (cValue="") {
			continue:JsonInput'[cKey
		}
		//
		i sqlDate="" s sqlDate=sqlDate_" BETWEEN '"_cValue_"' AND '"_cValue_"'"
		e  s sqlDate=sqlDate_sqlDate_" BETWEEN '"_cValue_"' AND '"_cValue_"'"
		
	}
	Q 0
	
GetOrderParref()
	s admid=JsonObj.GetValue("EpisodeID")
	s InParref=JsonObj.GetValue("OEORIOEORDParRef")
	i admid'="" {
		//f  s ord=$o(^OEORD(0,"Adm",admid,ord)) q:ord=""  d
		s OrderParref=$o(^OEORD(0,"Adm",admid,0))
	}
	i OrderParref'="" {
		s sqlAdm="OEORI_OEORD_ParRef="_OrderParref
	}
	i (OrderParref'="")&&(InParref'="")&&(InParref'=OrderParref) {
		Q 1	
	}
	i OrderParref="" s OrderParref=InParref
	
	Q 0
BuildPreIndex
	s PreIndex(1)="OEORIPrescNo:OEORI_PrescNo"
	s PreIndex(2)="OEORIAnaestDR:OEORI_Anaest_DR"
	s PreIndex(3)="OEORIAnaestAgentDR:OEORI_AnaestAgent_DR"
	s PreIndex(4)="OEORIAnaOperDR:OEORI_AnaOper_DR"
	s PreIndex(5)="OEORIAPPTDR:OEORI_APPT_DR"
	s PreIndex(6)="OEORIWaitListDR:OEORI_WaitList_DR"				//User.PAWaitingList
	s PreIndex(7)="OEORIClinPathwaysDR:OEORI_ClinPathways_DR"		//	User.MRClinicalPathWays
	s PreIndex(8)="OEORIManufacturerOrderDR:OEORI_ManufacturerOrder_DR"	//	User.INManufactureOrder
	s PreIndex(9)="OEORIItemGroup:OEORI_ItemGroup"
	s PreIndex(10)="OEORIHICClaimNo:OEORI_HICClaimNo"
	s PreIndex(11)="OEORILabEpisodeNo:OEORI_LabEpisodeNo"
	s PreIndex(12)="OEORIConsultDR:OEORI_Consult_DR"		//User.PAPersonConsultSetCons
	s PreIndex(13)="OEORIDate:OEORI_Date"
	s PreIndex(14)="OEORIXDate:OEORI_XDate"
	s PreIndex(15)="OEORIBilledDate:OEORI_BilledDate"
	s preLen=$o(PreIndex(""),-1)
	f i=1:1:preLen {
		s cItem=PreIndex(i)
		s cKey=$p(cItem,":",1)
		s cSqlName=$p(cItem,":",2)
		s cValue=JsonObj.GetValue(cKey)
		if (cValue="") {
			continue:JsonInput'[cKey
		}
		i sqlPre="" s sqlPre=cSqlName_"='"_cValue_"'"
		e  s sqlPre=sqlPre_" AND "_cSqlName_"='"_cValue_"'"
		
	}
	Q 0
	
BuildAfterIndex
	s AfterIndex(1)="OEORIItmMastDR:OEORI_ItmMast_DR"
	s AfterIndex(2)="OEORIBBExtCode:OEORI_BBExtCode"
	s AfterIndex(3)="OEORIPriorityDR:OEORI_Priority_DR"
	s AfterIndex(4)="OEORILabTestSetRow:OEORI_LabTestSetRow"
	
	s aftLen=$o(AfterIndex(""),-1)
	s sqlAfter=""
	i (OrderParref'="") {
		if sqlPre="" {
			s sqlAfter="OEORI_OEORD_ParRef='"_OrderParref_"'"
		}else {
			s sqlAfter=" AND OEORI_OEORD_ParRef='"_OrderParref_"'"
		}
		f i=1:1:aftLen {
			s cItem=AfterIndex(i)
			s cKey=$p(cItem,":",1)
			s cSqlName=$p(cItem,":",2)
			s cValue=JsonObj.GetValue(cKey)
			if (cValue="") {
				continue:JsonInput'[cKey
			}
			i sqlAfter="" s sqlAfter=cSqlName_"='"_cValue_"'"
			e  s sqlAfter=sqlAfter_" AND "_cSqlName_"='"_cValue_"'"
		}
	}
	Q 0
	
GeOeoriInfo(OrderId,sub)
	s OrdItemInfo=""
	s OrderItemRowid=OrderId_"||"_sub
 	s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
	Q:OrderStatusRowid=""
 	s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
 	s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",2)
 	s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
 	Quit:(checkrtn="Reg")||(checkrtn="Check") ""
 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
 	//Quit:DoctorDR="" ""
 	
	;非医生录入的医嘱退出
	s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
	s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	//Q:(DoctorType'="DOCTOR") ""
	;检验自动绑定上的医嘱不显示
	s LinkLabNo=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",22)
	//Q:LinkLabNo'="" ""
	;留观医生下的医嘱不同步到病历
	s EMStayFlag=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",17)
	;Q:EMStayFlag="1"
	;Q:'$$IsMedicalRecords(OrderId_"||"_sub) ""
	 
 	s Subscript=$p(ARCIMRowid,"||",1)
 	s Version=$p(ARCIMRowid,"||",2)
 	s OrderName=$p(^ARCIM(Subscript,Version,1),"^",2)
 	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(OrderId_"||"_sub)
 	if (ReqPartDesc'="") s OrderName=OrderName_ReqPartDesc
 	s OrderPrior=""
 	s OrderPriorRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",8)
 	i OrderPriorRowid'="" s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
 	s OrderSttDate=$p($g(^OEORD(OrderId,"I",sub,1)),"^",9)
 	i OrderSttDate'="" s OrderSttDate=$zd(OrderSttDate,3)
 	s OrderSttTime=$p($g(^OEORD(OrderId,"I",sub,1)),"^",10)
 	i OrderSttTime'="" s OrderSttTime=..%ZT(OrderSttTime,1)
 	
 	s OrderDoseQty=$p($g(^OEORD(OrderId,"I",sub,2)),"^",1)
 	S OrderDoseUOM=""
 	S OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
 	S OrderDur="",OrderDurFactor=""
 	s OrderDoseUOMRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",3)
 	i OrderDoseUOMRowid'="" D
 	.s OrderDoseUOM=$p(^CT("UOM",OrderDoseUOMRowid),"^",2)
 	s OrderFreqRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",4)
 	i OrderFreqRowid'="" d
 	.s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",4)
 	.s OrderFreqFactor=$p($g(^PHCFR(OrderFreqRowid)),"^",2)
 	.s OrderFreqInterval=$p($g(^PHCFR(OrderFreqRowid)),"^",9)
 	s OrderInstr=""
 	s OrderInstrRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",7)
 	i OrderInstrRowid'="" s OrderInstr=$p(^PHCIN(OrderInstrRowid),"^",2)
 	s OrderDurRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",6)
 	i OrderDurRowid'="" D
 	.s OrderDur=$p(^PHCDU(OrderDurRowid),"^",3)
 	.s OrderDurFactor=$p(^PHCDU(OrderDurRowid),"^",2)
 	s OrderPackQty=$p($g(^OEORD(OrderId,"I",sub,9)),"^",4)
	s OrderPackUOM=""
	s OrderPackUOMRowid = $p($g(^OEORD(OrderId,"I",sub,"DHC")), "^", 13)
    s:OrderPackUOMRowid="" OrderPackUOMRowid=$p(^ARCIM(Subscript,Version,8),"^",14)
    i OrderPackUOMRowid'="" s OrderPackUOM=$p(^CT("UOM",OrderPackUOMRowid),"^",2)
 	s OrderBillTypeRowid=$p($g(^OEORD(OrderId,"I",sub,11)),"^",18)
 	s OrderRecDepRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",6)
 	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", OrderBillTypeRowid, ARCIMRowid, OrderSttDate, OrderPriorRowid, OrderInstrRowid, "", "",OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
	s OrderDoseQty=$TR(OrderDoseQty," ","")
	s OrderType=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i OrderType'="R" d
	. s DoseqtySum=$p($g(^OEORD(OrderId,"I",sub,1)),"^",12)
	. s OrderPackQty=DoseqtySum
	s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	
 	s ItemCatDR=$p(^ARCIM(Subscript,Version,1),"^",10)
 	s RecHospDr=$p($G(^CTLOC(+OrderRecDepRowid)),"^",22)
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,RecHospDr,ARCIMRowid)
	;Q:(PHPrescType=3) ""
	s OrderSkinTest=$p($g(^OEORD(OrderId,"I",sub,5)),"^",2)
	s OrderRecDep=""
	i OrderRecDepRowid'="" s OrderRecDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderUserDep=""
	s OrderUserDepRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",2)
	i OrderUserDepRowid'="" s OrderUserDep=$p(^CTLOC(OrderUserDepRowid),"^",2)
	s OrderPrescNo=$p($g(^OEORD(OrderId,"I",sub,1)),"^",14)
	s OrderDepProcNote=$g(^OEORD(OrderId,"I",sub,"DEP",1))
	s OrderDoc=""
	s OrderDocRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",11)
	i OrderDocRowid'="" s OrderDoc=$p($g(^CTPCP(OrderDocRowid,1)),"^",2)
	s OrderUserAdd=""
	s OrderUserAddRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",1)
	i OrderUserAddRowid'="" s OrderUserAdd=$p($g(^SSU("SSUSR",OrderUserAddRowid)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderId,"I",sub,3)),"^",7)
	i OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderSeqNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",4)
	s OrderMasterSeqNo=$p($g(^OEORD(OrderId,"I",sub,2)),"^",2)
	s OrderLabEpisodeNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",20)
	s OrderOrdDepRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",3)
	s OrderBaseUOMRowid=""
	s OrderARCOSRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",10)
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	;,,OrderItemInValid,TypeClass
	s OrderMaxDurRowid=""
	s LinkOrderItem=$p($g(^OEORD(OrderId,"I",sub,11)),"^",39)
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	s ArcService=""
	s ArcService=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
	s TypeClass=""
	i OrderType="R" d
	.i PHPrescType="3" s TypeClass="草药"
	.e  s TypeClass="西药"
	e  i OrderType="L" s TypeClass="检验"
	e  i $g(ArcService)="S" s TypeClass="检查"
	e  s TypeClass="其他"
	
	s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(OrderId_"||"_sub)
	s skintestremark=##class(web.DHCSTPCHCOLLS2).SkinTest2(OrderId_"||"_sub)
    s:skintestremark'="" ordremark=skintestremark_" "_ordremark
    s seqno=seqno+1
	d QryOeoriCommonOutput
	Q 
QryOeoriCommonOutput
	set Data=$lb(seqno,OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,ordremark,skintestremark,TypeClass,CHMEDNotes)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryOeoriCommonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOeoriCommonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryOeoriCommonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOeoriCommonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:      宋春莉
/// CreatDate:    2019.12.31
/// Description:  获取本次就诊"穿刺"医嘱信息
/// Table:        
/// Input:        PAADMRowid:就诊表RowId
/// Return:       RetOrderStr:医嘱名称^医嘱ID*医嘱名称^医嘱ID
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetPunctureOrdStr(1)
ClassMethod GetPunctureOrdStr(PAADMRowid)
{
	
	s OrderStr="",RetOrderStr=""
	s OrderRowid=##Class(web.DHCDocOrderEntry).GetPAADMOrderRowid(PAADMRowid)
	Q:OrderRowid="" 0
	;循环取出医嘱
	s itemsub=0 
	f  {
		s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) 
		q:(itemsub="")  
		;如果医嘱未核实则为退出
		s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
		i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		;trakcare先开的医嘱是inactive
		continue:($g(statcode)'="V")&&($g(statcode)'="E")
	    s ItmMastrowid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)  //获取医嘱项ID
	    s ARCIMDesc=$p($g(^ARCIM(+ItmMastrowid,$p(ItmMastrowid,"||",2),1)),"^",2)
	    i ARCIMDesc["穿刺" s OrderStr=ARCIMDesc_"^"_OrderRowid_"||"_itemsub
	    i RetOrderStr="" {
		    s RetOrderStr=OrderStr
	    }else{
		    s RetOrderStr=RetOrderStr_"*"_OrderStr
	    }
	}
    q RetOrderStr
}

/// Creator:      宋春莉
/// CreatDate:    2019.01.07
/// Description:  获取床位费用
/// Table:        
/// Input:        床位ID
/// Return:       床位费用
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetBedFeeByBedId(1)
ClassMethod GetBedFeeByBedId(BedID As %String, HospId As %String = "", bedBillList = "") As %String
{
	s BedFee=0
	Q:BedID="" BedFee
	s LangId=..%LanguageID()
	if (HospId="") s HospId=$g(%session.Data("LOGON.HOSPID"))
	s today=..%SysDate()
	s CFRollNotUseNewConfig=$$getconfignode^DHCDocConfig("RollNotUseNewConfig")
	if CFRollNotUseNewConfig=1 {
		s bedtype=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2))),"^",2)
 		s arcim=$p($g(^PAC("BEDTP",+bedtype)),"^",4)
 		if $d(^ARCIM(+arcim,1,1)) {
	 		s OrdPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcim,+$h,"","","","",HospId)
			s BedFee=BedFee+OrdPrice
	 	}
	 	d setBedBillList
		s CFRollIPCheckFeeStr=$$getconfignode^DHCDocConfig("RollIPCheckFee")
		s CFRollIPCheckFee=$p(CFRollIPCheckFeeStr,"^",1)
		s CFRollIPCheckFeeStartDate=$p(CFRollIPCheckFeeStr,"^",2)
		if CFRollIPCheckFeeStartDate["/" s CFRollIPCheckFeeStartDate=$zdh(CFRollIPCheckFeeStartDate,4)
		if CFRollIPCheckFeeStartDate["-" s CFRollIPCheckFeeStartDate=$zdh(CFRollIPCheckFeeStartDate,3)
		if (today<+CFRollIPCheckFeeStartDate) s CFRollIPCheckFee=""
		if (CFRollIPCheckFee'="")&&($d(^ARCIM(+CFRollIPCheckFee,1,1))) {
			s OrdPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",CFRollIPCheckFee,+$h,"","","","",HospId)
			s BedFee=BedFee+OrdPrice
			s arcim=CFRollIPCheckFee
			d setBedBillList
		}
		 s CFRollSeasonAddFeeStr=$$getconfignode^DHCDocConfig("RollSeasonAddFee")
		 s CFRollSeasonAddFee=$p(CFRollSeasonAddFeeStr,"^",1)
		 s CFRollSeasonAddFeeStartDate=$p(CFRollSeasonAddFeeStr,"^",2)
		 if CFRollSeasonAddFeeStartDate["/" s CFRollSeasonAddFeeStartDate=$zdh(CFRollSeasonAddFeeStartDate,4)
		 if CFRollSeasonAddFeeStartDate["-" s CFRollSeasonAddFeeStartDate=$zdh(CFRollSeasonAddFeeStartDate,3)
		 s CFRollSeasonAddFeeEndDate=$p(CFRollSeasonAddFeeStr,"^",3)
		 if CFRollSeasonAddFeeEndDate["/" s CFRollSeasonAddFeeEndDate=$zdh(CFRollSeasonAddFeeEndDate,4)
		 if CFRollSeasonAddFeeEndDate["-" s CFRollSeasonAddFeeEndDate=$zdh(CFRollSeasonAddFeeEndDate,3)
		 if (today<+CFRollSeasonAddFeeStartDate)||(today>+CFRollSeasonAddFeeEndDate) s CFRollSeasonAddFee=""
		 if (CFRollSeasonAddFee'="")&&($d(^ARCIM(+CFRollSeasonAddFee,1,1))) {
			s OrdPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",CFRollSeasonAddFee,+$h,"","","","",HospId)
			s BedFee=BedFee+OrdPrice
			s arcim=CFRollSeasonAddFee
			d setBedBillList
		}
	}else{
		;启用空调费,暖气费全局收取开关
	    s EnableAir=##class(web.DHCPACBedFeeSet).GetConfig("EnableAir")
	    s EnableHeat=##class(web.DHCPACBedFeeSet).GetConfig("EnableHeat")
	    ;根据个别的床位进行遍历收费项目
	    s FeeFlag="N"
 		s BedOnlyFeeNum=$g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2),"FEE",0))  ;制定规则,床位优先
 		i BedOnlyFeeNum'="" {
	 		for BedFeeIndex=1:1:BedOnlyFeeNum {
		 		s arcim=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2),"FEE",BedFeeIndex)),"^",2)
		 		continue:arcim=""
			    s FeeTypeCode=""
			    s FeeTypeDR=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2),"FEE",BedFeeIndex)),"^",1)
			    i FeeTypeDR'="" s FeeTypeCode=$p($g(^PAC("FEETP",FeeTypeDR)),"^",1)
			    continue:(EnableAir'="Y")&&(FeeTypeCode="AC")
			    continue:(EnableHeat'="Y")&&(FeeTypeCode="H")
			 	s StartDate=$p(^PAWARD(+BedID,"BED",+$p(BedID,"||",2),"FEE",BedFeeIndex),"^",3)
			 	s EndDate=$p(^PAWARD(+BedID,"BED",+$p(BedID,"||",2),"FEE",BedFeeIndex),"^",4)
			 	s:EndDate="" EndDate=today+1
			 	continue:(today>EndDate)||(today<StartDate)
			 	s FeeFlag="Y"
			 	s OrdPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcim,+$h,"","","","",HospId)
			 	s BedFee=BedFee+OrdPrice
			 	d setBedBillList
		 	}
	 	}
	 	if (FeeFlag="N"){
		 	;根据床的类型遍历该类型的床的收费项目
		 	s bedtype=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2))),"^",2)
		    s BedTypeFeeNum=$g(^PAC("BEDTP",bedtype,"FEE",0))
		    if (BedTypeFeeNum'="") {
			    for TypeFeeIndex=1:1:BedTypeFeeNum {
				    s arcim=$p($g(^PAC("BEDTP",bedtype,"FEE",TypeFeeIndex)),"^",2)
				    continue:arcim=""
				    s FeeTypeCode=""
					s FeeTypeDR=$p($g(^PAC("BEDTP",bedtype,"FEE",TypeFeeIndex)),"^",1)
					i FeeTypeDR'="" s FeeTypeCode=$p($g(^PAC("FEETP",FeeTypeDR)),"^",1)
					continue:(EnableAir'="Y")&&(FeeTypeCode="AC")
					continue:(EnableHeat'="Y")&&(FeeTypeCode="H")
					s StartDate=$p(^PAC("BEDTP",bedtype,"FEE",TypeFeeIndex),"^",3)
					s EndDate=$p(^PAC("BEDTP",bedtype,"FEE",TypeFeeIndex),"^",4)
					s:EndDate="" EndDate=today+1
					continue:(today>EndDate)||(today<StartDate)
					continue:(today>EndDate)||(today<StartDate)
					s OrdPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcim,+$h,"","","","",HospId)
			 		s BedFee=BedFee+OrdPrice
			 		d setBedBillList
				}
			}
	 	}
	}
	Q BedFee
setBedBillList
	if (bedBillList){
		s itm=##class(%ArrayOfDataTypes).%New()
		s arcimDesc=$P($G(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
		s arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcimDesc,LangId)
	    d itm.SetAt(arcimDesc,"desc")
	    d itm.SetAt($fn($p(OrdPrice,"^",1),"",2),"price")
	    d itm.SetAt(arcim,"ID")
	    d bedBillList.Insert(itm)
	}
	q
}

/// Creator:      谭吉善
/// CreatDate:    2020.03.16
/// Description:  写入待审核列表并将该医嘱列表加载至医嘱录入界面
/// Table:        
/// Input:       EpisodeID:就诊ID,必填项;LocDr:使用科室ID(CT_Loc),非必填，指定使用科室时传入;UserDr:使用用户ID(SS_User),非必填，指定使用用户时传入;
/// 	         CopyItemList:以$c(1)分割的医嘱信息串，例：OneItemStr_$C(1)_OneItemStr_$C(1)_OneItemStr
/// 	             OneItemStr说明:以^分割的数据串,*为必填标识
/// 	             *序号^*医嘱项ID^单次剂量^单次剂量单位ID^频次ID
/// 	             ^用法ID^疗程ID^整包装数量^整包装数量单位ID^医嘱优先级ID
/// 	             ^医嘱套ID^医嘱备注^*是否加急(N|Y)^医嘱套项目ID^检验标本代码
/// 	             ^接受科室ID(未实现)^费别
/// 	 	             序号:非关联医嘱为自增,关联医嘱的子医嘱为[主医嘱序号.子医嘱序号]。例如序号1有两条子医嘱，第一条子医嘱为1.1，第二条子医嘱为1.2；第二组医嘱的序号分别为2，2.1，2.2		
/// Return:      0：成功 其他：失败
/// Others:      w ##class(DHCDoc.Interface.Inside.Service).InsertCopyItem(62,"","","1^311||1"_$C(1)_"2^312||1")
/// 应用方法为   d ##Class(User.DHCDocOrderCopyData).GetCopyItem()
ClassMethod InsertCopyItem(EpisodeID As %String, LocDr As %String, UserDr As %String, CopyItemList As %String) As %String
{
	n (EpisodeID,LocDr,UserDr,CopyItemList)
	s ch1 = $char(1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s AdmLocDr=$P(^PAADM(EpisodeID),"^",4)
	s ForbidDosing=$P($G(^CTLOC(AdmLocDr,"DHC")),"^",18)
	s ForbidDosingInstr=""
	i (ForbidDosing="1"){
		if (PAAdmType="I"){
			s ForbidDosingInstr=..%GetConfig("IPDosingInstr")
		}elseif (PAAdmType="O"){
			s ForbidDosingInstr=..%GetConfig("OPInfusionInstr")
		}
		i ForbidDosingInstr'="" s ForbidDosingInstr="^"_ForbidDosingInstr_"^"
	}
	
	
	s OrdCDRowID=""
	s ID=0
	for {
		s ID=$O(^DHCDocOrderCopyData(0,"IndexAdmDr",EpisodeID,ID))
		q:(ID="")
		s Active=$P(^DHCDocOrderCopyData(ID),"^",4)
		continue:(Active'="Y")
		s OrdCDUserDr=$P(^DHCDocOrderCopyData(ID),"^",2)
		continue:(UserDr'=OrdCDUserDr)
		s OrdCDLocDr=$P(^DHCDocOrderCopyData(ID),"^",3)
		continue:(LocDr'=OrdCDLocDr)
		s OrdCDRowID=ID
		Quit
	}
	if (OrdCDRowID'=""){
		s Obj=##Class(User.DHCDocOrderCopyData).%OpenId(OrdCDRowID)
	}else{
		s Obj=##Class(User.DHCDocOrderCopyData).%New()
		d Obj.OrdCDAdmDrSetObjectId(EpisodeID)
		d Obj.OrdCDUserDrSetObjectId(UserDr)
		d Obj.OrdCDLocDrSetObjectId(LocDr)
		s Obj.OrdCDActive="Y"
	}
	s OrdDataCount=Obj.OrdCDOrdData.Count()
	Set CopyItemCount=$L(CopyItemList,$c(1))
	For i=1:1:CopyItemCount{
		s OneItemStr=$P(CopyItemList,$c(1),i)
		continue:(OneItemStr="")
		s OrderSeqNo=$P(OneItemStr,"^",1)
		if (OrderSeqNo["."){
			s OrderSeqNo=($P(OrderSeqNo,".",1)+OrdDataCount)_"."_$P(OrderSeqNo,".",2)
		}else{
			s OrderSeqNo=OrderSeqNo+OrdDataCount
		}
		
		s ARCIMRowid=$P(OneItemStr,"^",2)
		s OrderDoseQty=$P(OneItemStr,"^",3)
		s OrderDoseUOMRowid=$P(OneItemStr,"^",4)
		s OrderDoseUOM=""
		s:OrderDoseUOMRowid'="" OrderDoseUOM=$P($G(^CT("UOM",OrderDoseUOMRowid)),"^",2)
		s OrderFreqRowid=$P(OneItemStr,"^",5)
		s (OrderFreq,OrderFreqInterval)="",OrderFreqFactor=1
		i OrderFreqRowid'="" {
			s OrderFreq=$P($g(^PHCFR(FormFreqRowid)),"^",3)
			s OrderFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
			s OrderFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
		}
		s OrderInstrRowid=$P(OneItemStr,"^",6)
		s OrderInstr=""
		if (OrderInstrRowid'=""){
			s Active=$P($g(^PHCIN(OrderInstrRowid)),"^",4)
			s AvailableType=$P($g(^PHCIN(OrderInstrRowid)),"^",5)
			if ((AvailableType'="")&&(AvailableType'[PAAdmType))||(Active="N"){
				s OrderInstrRowid=""
			}
			if (ForbidDosingInstr[("^"_OrderInstrRowid_"^")){
				s OrderInstrRowid=""
			}
		}
		s:OrderInstrRowid'="" OrderInstr=$P($g(^PHCIN(OrderInstrRowid)),"^",2)
		;疗程
		s OrderDurRowid=$P(OneItemStr,"^",7)
		s OrderDur="",OrderDurFactor=1
		i OrderDurRowid'="" {
			s OrderDur=$P($g(^PHCDU(FormDurRowid)),"^",3)
			s OrderDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
		}
		
		s OrderPackQty=$P(OneItemStr,"^",8)
		s OrderPackUOMRowid=$P(OneItemStr,"^",9)
		s OrderPackUOM=""
		s:OrderPackUOMRowid'="" OrderPackUOM=$P($G(^CT("UOM",OrderPackUOMRowid)),"^",2)
		s OrderPriorRowid=$P(OneItemStr,"^",10)
		s OrderPrior=""
		s:OrderPriorRowid'="" OrderPrior=$p($g(^OECPR(OrderPriorRowid)),"^",2) 
		s ARCOSRowId=$P(OneItemStr,"^",11)
		s OrderResume=$P(OneItemStr,"^",12)
		s OrderNotifyClinician=$P(OneItemStr,"^",13)
		s ArcimARCOSRowId=$P(OneItemStr,"^",14)
		s ItemSpecCode=$P(OneItemStr,"^",15)
		s OrderRecDepRowid=$P(OneItemStr,"^",16)
		s OrderBillTypeRowId=$P(OneItemStr,"^",17)
		s OrderType=""
		
		s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		s (OrderStage,OrderStageDesc,SpeedFlowRate,FlowRateUnit,FlowRateUnitRowid)=""
		s (ReqPartId,OrderActionRowid,OrderAction,OrderSkinTest)=""
		s (OrderFreqTimeDoseQtyStr,OrderFreqWeekStr,ExceedReasonID,ExceedReason)=""
		s ItemData = ARCIMRowid_"!"_OrderSeqNo_"!"_OrderDoseQty_ch1_OrderDoseUOM_ch1_OrderDoseUOMRowid
		s ItemData = ItemData_"^"_OrderFreq_ch1_OrderFreqRowid_ch1_OrderFreqFactor_ch1_OrderFreqInterval
		s ItemData = ItemData_"^"_OrderInstr_ch1_OrderInstrRowid
		s ItemData = ItemData_"^"_OrderDur_ch1_OrderDurRowid_ch1_OrderDurFactor
		s ItemData = ItemData_"^"_OrderPackQty_ch1_OrderPackUOM_ch1_OrderPackUOMRowid
		s ItemData = ItemData_"^"_OrderPrior_ch1_OrderPriorRowid
		s ItemData = ItemData_"^"_ARCOSRowId_"^^"	//医嘱套ID、空、医嘱子类ID
		s ItemData = ItemData_"^"_OrderResume	//备注
		
		s ItemData=ItemData_"^"	//附加说明
		s ItemData=ItemData_"^"	//抗生素
		s ItemData=ItemData_"^"_OrderNotifyClinician	//紧急标志
		s ItemData=ItemData_"^"_ArcimARCOSRowId //医嘱套项目id
		s ItemData=ItemData_"^"_ItemSpecCode	//标本	
		s ItemData=ItemData_"^"_OrderStage_ch1_OrderStageDesc	//医嘱阶段
		s ItemData=ItemData_"^"_SpeedFlowRate_ch1_FlowRateUnit_ch1_FlowRateUnitRowid //输液流速、流速单位
		s ItemData=ItemData_"^"_ReqPartId
		s ItemData=ItemData_"^"_OrderActionRowid_"^"_OrderAction_"^"_OrderSkinTest
		s ItemData=ItemData_"^" //计费组套餐明细编号
		s ItemData=ItemData_"^"_OrderFreqTimeDoseQtyStr_"^"_OrderFreqWeekStr //同频次不同剂量、周频次
		s ItemData=ItemData_"^"_ExceedReasonID_ch1_ExceedReason
		s ItemData = ItemData_"!"_OrderType_"!"_OrderBillTypeRowId_"!"_"Order"
		d Obj.OrdCDOrdData.Insert(ItemData)
	}
	Set sc=Obj.%Save()
	d Obj.%Close()
	If $$$ISERR(sc) {
		Quit -100
	}
	q 0
}

/// Creator:      宋春莉
/// CreatDate:    2020.03.23
/// Description:  根据处方号返回煎药费对应的医嘱id串接口(供煎药管理中会统计草药处方的煎药费用信息)
/// Input:PrescNo 处方号
/// OutPut: 医嘱ID串，多个医嘱ID以^分割
ClassMethod GetCMCookModeLinkOrdStr(PrescNo As %String) As %String
{
	n (PrescNo)
	s rtn=""
	Q:PrescNo="" ""
	s QUERowID=$o(^PAQUE1(0,"PrescNo",PrescNo,""))
	Q:QUERowID="" ""
	s AdmId=$p(^PAQUE1(QUERowID),"^",3)
	s OEOrdRowID=+$o(^OEORD(0,"Adm",+AdmId,0))
	Q:OEOrdRowID="" ""
	s LinkOrderItemDR=$p($g(^PAQUE1(QUERowID,"DHC")),"^",34)
	Q:LinkOrderItemDR="" ""
	s Childsub=0
	for {
		s Childsub=$o(^OEORDi(0,"OEORI",OEOrdRowID,LinkOrderItemDR,Childsub)) Q:Childsub=""
		s statcode=""
		s Stat=$P($G(^OEORD(+OEOrdRowID,"I",Childsub,1)),"^",13)
		s:Stat'="" statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
		continue:(statcode'="V")&&(statcode'="E")&&(statcode'="")
		s OEORIBindSource=$p($g(^OEORD(OEOrdRowID,"I",Childsub,"DHC")),"^",41)
		if (OEORIBindSource="CMCMAO")||(OEORIBindSource="CMPTCMA") {
			if rtn="" s rtn=OEOrdRowID_"||"_Childsub
			else  s rtn=rtn_"^"_OEOrdRowID_"||"_Childsub
		}
	}
	Q rtn
}

/// Creator:      宋春莉
/// CreatDate:    2020.07.08
/// Description:  判断执行记录是否需要退费(仅供检验、检查等医技执行单使用)
/// Input:        OrdExecID:执行记录ID
/// Return:       Y 是 N 不是
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetExecRefundFlag("147||35||3")
ClassMethod GetExecRefundFlag(OrdExecID) As %String
{
	s RefundFlag="N"
	Q:OrdExecID="" RefundFlag
	;仅处理检验、检查医嘱
	s ArcimId=$p($g(^OEORD(+OrdExecID,"I",$p(OrdExecID,"||",2),1)),"^",2)
	s ArcimClassification=##class(web.DHCDocOrderCommon).GetArcimClassification(ArcimId)
	q:" E L "'[(" "_ArcimClassification_" ") RefundFlag
	s OEOREOrderStatusDate=$p($g(^OEORD(+OrdExecID,"I",$p(OrdExecID,"||",2),"X",$p(OrdExecID,"||",3),"BILL")),"^",21)
	s OEOREOrderStatusTime=$p($g(^OEORD(+OrdExecID,"I",$p(OrdExecID,"||",2),"X",$p(OrdExecID,"||",3),"BILL")),"^",22)
	s OEOREOrderStatusCancelDate=$p($g(^OEORD(+OrdExecID,"I",$p(OrdExecID,"||",2),"X",$p(OrdExecID,"||",3),"BILL")),"^",24)
	s OEOREOrderStatusCancelTime=$p($g(^OEORD(+OrdExecID,"I",$p(OrdExecID,"||",2),"X",$p(OrdExecID,"||",3),"BILL")),"^",25)
	;1.医嘱作废/撤销需退费
	s OrdStatusCode=##class(appcom.OEOrdItem).GetStatusCode(OrdExecID)
	Q:(OrdStatusCode="U")||(OrdStatusCode="C") "Y"
	s ExecStatusCode=""
	s ExecStatusRowId=$P(^OEORD(+OrdExecID,"I",$P(OrdExecID,"||",2),"X",$P(OrdExecID,"||",3)),"^",16)
	if ExecStatusRowId'="" s ExecStatusCode=$P($G(^OEC("STAT",ExecStatusRowId)),"^",1)
	;2.执行记录停止执行且申请单执行日期为空需退费(病区护士只能执行/撤销执行记录,医生站撤销单条部位时执行记录变停止)
	Q:(ExecStatusCode="D")&&(OEOREOrderStatusDate="") "Y"
	s STChildsub="",STStatusCode=""
	for {
		s STChildsub=$o(^OEORD(+OrdExecID,"I",$p(OrdExecID,"||",2),"ST",STChildsub),-1) Q:STChildsub=""
		s STStatusDR=$p($g(^OEORD(+OrdExecID,"I",$p(OrdExecID,"||",2),"ST",STChildsub)),"^",3)
		continue:(STStatusDR="")
		s STStatusCode=$p(^OEC("OSTAT",STStatusDR),"^",1)
		Q:STStatusCode="E"
	}
	s OEOREPBODR=$p($g(^OEORD(+OrdExecID,"I",$p(OrdExecID,"||",2),"X",$p(OrdExecID,"||",3),"BILL")),"^",2)
	;3.医嘱核实状态且医嘱状态变化表存在执行状态的记录且执行记录账单ID不为空须退费
	Q:(OrdStatusCode="V")&&(STStatusCode="E")&&(OEOREPBODR'="") "Y"
	;4.医嘱状态变化表存在执行状态的记录且执行记录账单ID不为空且
	Q:(STStatusCode="E")&&(OEOREOrderStatusCancelDate'="")&&(OEOREOrderStatusDate="") "Y"
	;5.申请单执行日期为空不需退费
	Q:(OEOREOrderStatusDate'="")||(OEOREOrderStatusDate'="") RefundFlag
	Q RefundFlag
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  获取住院证ID
/// Input:        BookID:住院证ID
/// Return:       住院证明细
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetBookMesage
ClassMethod GetBookMesage(BookID) As %String
{
	Q ##class(web.DHCDocIPBookNew).GetBookMesage(BookID)
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  更新住院证状态
/// Input:        Paadm:就诊ID，StateCode:状态Code
/// Return:       0 成功 其他 失败
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).IUpdateIPBState
ClassMethod IUpdateIPBState(Paadm, StateCode) As %String
{
	Q ##class(web.DHCDocIPBookingCtl).IUpdateIPBState(Paadm, StateCode)
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  查询处方剂型列表
/// Input:        HospId:院区ID，IsActive:状态
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindCMPrescType")
Query FindCMPrescType(HospId As %String = "", IsActive As %String = "") As websys.Query(ROWSPEC = "Code:%String,Desc:%String,Active:%String")
{
}

ClassMethod FindCMPrescTypeExecute(ByRef qHandle As %Binary, HospId As %String = "", IsActive As %String = "") As %Status [ ProcedureBlock = 1 ]
{
	Set repid=$I(^CacheTemp)
    Set ind=1
	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.CMDocConfig:FindCMPrescType")
	do rset.Execute(HospId,IsActive)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	   s Code=rset.GetData(1)
	   s Desc=rset.GetData(2)
	   s Active=rset.GetData(3)
	   d OutputRowFindCMPrescType
	}
	d rset.Close()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCMPrescType
	set Data=$lb(Code,Desc,Active)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// Creator:      郭荣勇
/// CreatDate:    2020.08.06
/// Description:  使用场景：
/// 					1、【私有接口】将当前系统有效医嘱项插入到某个就诊（仅提供给医保组使用,项目上线前检测和医保中心的项目对照情况）
/// 					2、医生站自测当前系统中有效的医嘱，哪些是有问题的，将问题记录下来，提供项目上线前参考
/// 				  配置任务执行，否则会有很多断点; 错误信息查看^TMPTestBatchInsOrd("ErrData")
/// Table:        
/// Input:        EpisodeID:就诊表RowId,UserID:用户表RowId	ExpStr：待扩展(以^分割)
/// Return:       成功总数量
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).TestBatchInsOrd(12175,919)
ClassMethod TestBatchInsOrd(EpisodeID As %String, UserID As %String, ExpStr As %String = "")
{
	n (EpisodeID,UserID,ExpStr)
	
	Q:EpisodeID="" "EpisodeID不能为空"
	
	s $zt="TestBatchInsOrdErr"
	;记录错误数据
	kill ^TMPTestBatchInsOrd("ErrData")
	
	s Count=0,ErrCount=0
	s Today=..%SysDate()
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	s admLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	s HospId=$p(^CTLOC(admLoc),"^",22)
	s Doc=$p(^SSU("SSUSR",UserID),"^",14)
	
	;循环当前有效医嘱项目
	s ARCIMSub=0
	for {
		s ARCIMSub=$O(^ARCIM(ARCIMSub)) Q:ARCIMSub=""
		;q:Count>3
		s ARCIMVer=0
		for {
			s ARCIMVer=$O(^ARCIM(ARCIMSub,ARCIMVer)) Q:ARCIMVer=""
			;q:Count>3
			s ARCIMEffDate=$p($p(^ARCIM(ARCIMSub,ARCIMVer,1),"^",13),"Z",1)
			s ARCIMEffDateTo=$p(^ARCIM(ARCIMSub,ARCIMVer,7),"^",1)
			;continue:(ARCIMEffDate'="")&&(ARCIMEffDate>Today)
			;continue:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<Today)
			
			s ARCIMRowid=ARCIMSub_"||"_ARCIMVer
			continue:##class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
			s ARCIMName=$p(^ARCIM(ARCIMSub,ARCIMVer,1),"^",2)
			;得到需加收的医嘱项目信息串
			s OrdItemStr=$$getOrdItemInfo(EpisodeID,ARCIMRowid,$zd(Today,4),HospId)
			i $p(OrdItemStr,"^",1)="Err" {
				s ^TMPTestBatchInsOrd("ErrData",ARCIMRowid)=$p(OrdItemStr,"^",1)_"【"_ARCIMName_"】"
				s ErrCount=ErrCount+1
				continue
			}
			;插入医嘱,因为不需要测试插入医嘱的接口,账单,其他数据更新；所以在这里不调用统一对外插入医嘱服务接口,而直接调用插医嘱方法
			if PAADMType="I" {
				Set Ret=$$InsertMultiple^DHCDocOrderCommonNew(EpisodeID,OrdItemStr,UserID,admLoc,Doc,LABDATA)
			}else{
				Set Ret=$$InsertMultiple^DHCDocOrderCommon(EpisodeID,OrdItemStr,UserID,admLoc,Doc,LABDATA)
			}
			
			i Ret'=100 {
				;医嘱插入成功
				s Count=Count+1
				/*
				f k=1:1:$l(ret,"^") {
					s ArcimRowId=$p($p(ret,"^",k),"*",1)
					s newOrdIdDR=$p($p(ret,"^",k),"*",2)
					i newOrdIdDR="" continue
				}
				*/
			}else{
				;医嘱插入失败
				s ^TMPTestBatchInsOrd("ErrData",ARCIMRowid)="该医嘱插入失败,errCode:"_Ret_"【"_ARCIMName_"】"
				s ErrCount=ErrCount+1
			}
		}
	}
	
	q Count_"^"_ErrCount
TestBatchInsOrdErr
	s ^TMPTestBatchInsOrd("ErrData","Ex",$h)="程序异常，err:"_$zerror
	q
 ;返回格式为：Err^错误描述  , 正常需插入医嘱信息
getOrdItemInfo(EpisodeID,ARCIMRowid,OrdItemSttDate,HospId)
	Set Ord=$o(^OEORD(0,"Adm",+EpisodeID,""))
	Set ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	Set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i OrderType="R" {
		;药品按取药走
		Set PriorRowid=$O(^OECPR(0,"Code","ONE",0))
	}else{
		;其他按临时
		Set PriorRowid=$O(^OECPR(0,"Code","NORM",0))
	}
	s LabSpecRowid=""
	if (OrderType="L") {
		s LabSpec=##class(web.DHCDocOrderCommon).GetLabSpec(ARCIMRowid,HospId)
		for labI=1:1:$l(LabSpec,$c(2)) {
			s labOne=$p(LabSpec,$c(2),labI)
			s LabSpecCode=$p(labOne,$c(3),1)
			s LabSpecDefaultFlag=$p(labOne,$c(3),4)
			i LabSpecDefaultFlag="Y" s LabSpecRowid=LabSpecCode
		}
		i LabSpecRowid="" s LabSpecRowid=$p(LabSpec,$c(3),1)
		
		q:LabSpecRowid="" "Err^该检验医嘱没有获取到可用标本"
	}
	
	set PackQty=1,oeprice=""
	Set startdate=$zdh(OrdItemSttDate,4),starttime=..%ZT(..%SysTime(),1)
	Set RecDepStr=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,ARCIMRowid)
	set DefaultRecDepRowid=""
	for i=1:1:$l(RecDepStr,$c(2)) {
		s oneRecDepStr=$p(RecDepStr,$c(2),i)
		s defaultFlag=$p(oneRecDepStr,$C(1),3)
		i defaultFlag="Y" s DefaultRecDepRowid=$p(oneRecDepStr,$C(1),1) quit
	}
	i DefaultRecDepRowid="" s DefaultRecDepRowid=$p(RecDepStr,$C(1),1)
	q:DefaultRecDepRowid="" "Err^该医嘱没有获取到接收科室"
	s AdmReason=$p(^PAADM(EpisodeID,1),"^",7)
	
	Set DrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	Set DepProcNotes=""
	Set DoseQty=""
	Set DoseUOMRowid=""
	i DrugFormRowid'="" {
		s PHCDRowid=$p(DrugFormRowid,"||",1)
		s PHCDChildSub=$p(DrugFormRowid,"||",2)
		s DoseQty=$p($g(^PHCD(PHCDRowid,"DF",PHCDChildSub,2)),"^",5) ;Pharmacy base UOM
	  	s DoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",PHCDChildSub,2)),"^",4)
	}else{
		q:OrderType="R" "Err^该药品医嘱没有配置药学项"
	}
	
	Set FreqRowid=""
	Set DurRowid=""
	Set InstrRowid=""
	Set PHPrescType=""
	Set SkinTest=""
	Set PhSpecInstr=""
	Set OrderCoverMainIns=""
	Set ActionRowid=""
	Set ARCOSRowid=""
	Set EndDate=""
	Set EndTime=""
	Set ExecuteDateStr=""
	Set NotifyClinician=""
	Set DIACatRowId=""
	Set InsurCatRowId=""
	Set PackQty=PackQty
	Set DoseQtySum=##class(web.DHCDocOrderEntry).GetItemConFac(ARCIMRowid)
	Set MasterSeqNo=""
	Set LastSeqNo=$o(^OEORDi(0,"StDtSeqNo",Ord,startdate," "),-1)
    i LastSeqNo["." s LastSeqNo=$p(LastSeqNo,".")
	Set SubSeqNo=+LastSeqNo+1
	
	Set AppendOrdItem=ARCIMRowid_"^"_OrderType_"^"_PriorRowid_"^"_startdate_"^"_starttime_"^"_PackQty_"^"_oeprice
	Set AppendOrdItem=AppendOrdItem_"^"_DefaultRecDepRowid_"^"_AdmReason_"^"_DrugFormRowid_"^"_DepProcNotes
	Set AppendOrdItem=AppendOrdItem_"^"_DoseQty_"^"_DoseUOMRowid_"^"_DoseQtySum_"^"_FreqRowid_"^"_DurRowid_"^"_InstrRowid
	Set AppendOrdItem=AppendOrdItem_"^"_PHPrescType_"^"_MasterSeqNo_"^"_SubSeqNo_"^"_SkinTest_"^"_PhSpecInstr_"^"_OrderCoverMainIns
	Set AppendOrdItem=AppendOrdItem_"^"_ActionRowid_"^"_ARCOSRowid_"^"_EndDate_"^"_EndTime_"^"_LabSpecRowid
	
	q AppendOrdItem
}

/// Creator:      谭吉善
/// CreatDate:    2020.10.12
/// Description:  查询医嘱项\医嘱套列表
/// Input:        Item:简拼\检索码，后缀为.时模糊检索
///               SessionStr:UserID^登录科室ID^登录安全组ID
///               EpisodeID:就诊ID
///               NonFormulary:空-使用默认配置，CM-仅检索草药及草药医嘱套，XY-检索内容过滤草药相关内容
///               Category:大类检索范围
///               SubCategory:子类检索范围
///               RecLocByLogonLocFlag:按登录科室获取接受科室标志
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","LookUpItem","LHN","12175^29^113",2049,"XY","","","N")
Query LookUpItem(Item As %String, SessionStr As %String, EpisodeID As %String, NonFormulary As %String, Category As %String, SubCategory As %String, RecLocByLogonLocFlag As %String) As websys.Query(ROWSPEC = "OrdName:%String,ItemRowID:%String,ItemType:%String,PHBaseUom:%String,ItemPrice:%String,BillUom:%String,StockQty:%String,GenericName:%String,InsurClass:%String,InsurSelfPay:%String,Recloc:%String")
{
}

ClassMethod LookUpItemExecute(ByRef qHandle As %Binary, Item As %String, SessionStr As %String, EpisodeID As %String, NonFormulary As %String, Category As %String, SubCategory As %String, RecLocByLogonLocFlag As %String) As %Status [ ProcedureBlock = 1 ]
{
	s UserID=$P(SessionStr,"^",1)
	s GroupID=$P(SessionStr,"^",2)
	s LogonLocID=$P(SessionStr,"^",3)
	s (TYPE,OrderDepRowId,OrderPriorRowId,BillingGrp,BillingSubGrp,OrdCatGrp,Strength,Route)=""
	i RecLocByLogonLocFlag="Y" s OrderDepRowId=LogonLocID
	s HospitalId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LogonLocID)
	s Form=LogonLocID_$c(3)_HospitalId
	i NonFormulary'=""{
		s NonFormulary="Y^"_NonFormulary
	}
	Set obj=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d obj.Execute(Item,GroupID,Category,SubCategory,TYPE,OrderDepRowId,OrderPriorRowId,EpisodeID,BillingGrp,BillingSubGrp,UserID,OrdCatGrp,NonFormulary,Form,Strength,Route)
	Set repid=$I(^CacheTemp)
	Set index=1
	Set columns = obj.GetColumnCount()
	While (obj.Next()) {
		s OrdName=obj.GetData(1)
		s ItemRowID=obj.GetData(2)
		s ItemType=obj.GetData(4)
		s PHBaseUom=obj.GetData(12)
		s ItemPrice=obj.GetData(19)
		s BillUom=obj.GetData(21)
		s StockQty=obj.GetData(22)
		s GenericName=obj.GetData(24)
		s InsurClass=obj.GetData(27)
		s InsurSelfPay=obj.GetData(28)
		s Recloc=obj.GetData(29)
		d OutputRowLookUpItem
	}
	d obj.Close()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLookUpItem
	set Data=$lb(OrdName,ItemRowID,ItemType,PHBaseUom,ItemPrice,BillUom,StockQty,GenericName,InsurClass,InsurSelfPay,Recloc)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	Quit
}

/// Creator:      谭吉善
/// CreatDate:    2020.10.12
/// Description:  查询医嘱套明细
/// Input:        ARCOSRowid:医嘱套ID
///               SessionStr:UserID^登录科室ID^登录安全组ID
///               EpisodeID:就诊ID
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","LookUpOSItems","168","12175^29^113",2049)
Query LookUpOSItems(ARCOSRowid As %String, SessionStr As %String, EpisodeID As %String) As websys.Query(ROWSPEC = "ItemSeqNo:%String,Item:%String,ItemRowid:%String,ItemDoseQty:%String,ItemDoseUOM:%String,ItemDoseUOMRowid:%String,ItemFreq:%String,ItemFreqRowid:%String,ItemInstr:%String,ItemInstrRowid:%String,ItemDur:%String,ItemDurRowid:%String,ItemPackQty:%String,ItemPackQtyUOM:%String,ItemPackQtyUOMRowid:%String,ItemPrior:%String,ItemPriorRowid:%String,NotifyClinician:%String,id:%String,ItemSpec:%String,ItemSpecCode:%String,OrderStage:%String,OrderStageDesc:%String,SpeedFlowRate:%String,FlowRateUnit:%String,FlowRateUnitRowid:%String,OrderBodyPartLabel:%String,OrderActionRowid:%String,OrderAction:%String,OrderSkinTest:%String,OrderFreqTimeDoseStr:%String,OrderFreqWeekStr:%String,ItemRemark:%String,CNMedItemFlag:%String,ItemPrice:%String,ItemStatus:%String,OrderMustEnter:%String")
{
}

ClassMethod LookUpOSItemsExecute(ByRef qHandle As %Binary, ARCOSRowid As %String, SessionStr As %String, EpisodeID As %String) As %Status [ ProcedureBlock = 1 ]
{
	s UserID=$P(SessionStr,"^",1)
	s GroupID=$P(SessionStr,"^",2)
	s LogonLocID=$P(SessionStr,"^",3)
	s HospitalId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LogonLocID)
	Set obj=##class(%ResultSet).%New("web.DHCDocOrderCommon:FindOSItems")
	d obj.Execute(ARCOSRowid,HospitalId,EpisodeID)
	Set repid=$I(^CacheTemp)
	Set index=1
	Set columns = obj.GetColumnCount()
	While (obj.Next()) {
		//序号\组号，主医嘱为纯数字，子医嘱为【主医嘱序号.子医嘱序号】，非成组医嘱序号可为空
		s ItemSeqNo=obj.GetData(31)
		//医嘱项名称
		s Item=obj.GetData(1)
		//医嘱项ID
		s ItemRowid=obj.GetData(10)
		//
		s ItemData=obj.GetData(9)
		s ItemData=$tr(ItemData,"~",$C(1))
		s ItemData=$tr(ItemData,"@",$C(2))
		s ItemDoseStr=$P(ItemData,"^",1)
		//单次剂量
		s ItemDoseQty=$P(ItemDoseStr,$C(1),1)
		//单次剂量单位
		s ItemDoseUOM=$P(ItemDoseStr,$C(1),2)
		//单次剂量单位ID
		s ItemDoseUOMRowid=$P(ItemDoseStr,$C(1),3)
		s ItemFreqStr=$P(ItemData,"^",2)
		//频次
		s ItemFreq=$P(ItemFreqStr,$C(1),1)
		//频次ID
		s ItemFreqRowid=$P(ItemFreqStr,$C(1),2)
		s ItemInstrStr=$P(ItemData,"^",3)
		//用法
		s ItemInstr=$P(ItemInstrStr,$C(1),1)
		//用法id
		s ItemInstrRowid=$P(ItemInstrStr,$C(1),2)
		s ItemDurStr=$P(ItemData,"^",4)
		//疗程
		s ItemDur=$P(ItemDurStr,$C(1),1)
		//疗程ID
		s ItemDurRowid=$P(ItemDurStr,$C(1),2)
		s ItemPackQtyStr=$P(ItemData,"^",5)
		//数量
		s ItemPackQty=$P(ItemPackQtyStr,$C(1),1)
		//数量单位
		s ItemPackQtyUOM=$P(ItemPackQtyStr,$C(1),2)
		//数量单位ID
		s ItemPackQtyUOMRowid=$P(ItemPackQtyStr,$C(1),3)
		s ItemPriorStr=$P(ItemData,"^",6)
		s ItemPriorRemarksDR=$P(ItemData,"^",11)
		//医嘱级别
		s ItemPrior=$P(ItemPriorStr,$C(1),1)
		//医嘱级别ID
		s ItemPriorRowid=$P(ItemPriorStr,$C(1),2)
		i (ItemPriorRowid'=""){
			if (ItemPriorRemarksDR'=""){
				s ItemPriorRowid=##Class(web.DHCOEOrdItemView).ReSetOrderPriorRowid(ItemPriorRowid,ItemPriorRemarksDR)
			}
			s ItemPrior=$P(^OECPR(ItemPriorRowid),"^",2)
		}
		
		//加急
		s NotifyClinician=obj.GetData(29)
		//医嘱套明细表ID
		s id=obj.GetData(28)
		//标本
		s ItemSpec=obj.GetData(17)
		//标本代码
		s ItemSpecCode=$P(ItemData,"^",15)
		s ItemOrderStageStr=$P(ItemData,"^",16)
		//医嘱阶段代码
		s OrderStage=$P(ItemOrderStageStr,$C(1),1)
		//医嘱阶段
		s OrderStageDesc=$P(ItemOrderStageStr,$C(1),2)
		s ItemSpeedFlowRateStr=$P(ItemData,"^",17)
		//输液流速
		s SpeedFlowRate=$P(ItemSpeedFlowRateStr,$C(1),1)
		//输液流速单位
		s FlowRateUnit=$P(ItemSpeedFlowRateStr,$C(1),2)
		//输液流速单位ID
		s FlowRateUnitRowid=$P(ItemSpeedFlowRateStr,$C(1),3)
		//多部位检查部位体位列表
		s OrderBodyPartLabel=$P(ItemData,"^",18)
		//皮试备注代码
		s OrderActionRowid=$P(ItemData,"^",19)
		//皮试备注描述
		s OrderAction=$P(ItemData,"^",20)
		if (OrderAction="")&&(OrderActionRowid'="") s OrderAction=$p($g(^OEC("ACT",OrderActionRowid)),"^",2)
		//皮试标识
		s OrderSkinTest=$P(ItemData,"^",21)
		//同频次不同剂量,频次分发时间段$单次剂量!频次分发时间段$单次剂量!...,其中频次分发时间段的结构为：频次主表id_分发时间子表id，^PHCFR(+PHCDTRowID,"DT",$p(PHCDTRowID,"_",2)))
		s OrderFreqTimeDoseStr=$P(ItemData,"^",23)
		s OrderFreqTimeDoseStr=$replace(OrderFreqTimeDoseStr,$C(2),"!")
		//周频次,周数|周数|...
		s OrderFreqWeekStr=""
		s OrderFreqDispTimeStr=$P(ItemData, "^", 24)
		for i=1:1:$l(OrderFreqDispTimeStr,$C(1)) {
			s oneStr=$p(OrderFreqDispTimeStr,$C(1),i)
			s DispWeek=$p(oneStr,$C(2),2)
			i OrderFreqWeekStr="" s OrderFreqWeekStr=DispWeek
			e  s OrderFreqWeekStr=OrderFreqWeekStr_"|"_DispWeek
		}
		
		
		//备注
		s ItemRemark=obj.GetData(14)
		//草药标志
		s CNMedItemFlag=obj.GetData(26)
		//单价
		s ItemPrice=obj.GetData(12)
		//项目状态,空|停用
		s ItemStatus=obj.GetData(13)
		//医嘱套中的必选项目
		s OrderMustEnter=obj.GetData(25)

		d LookUpOSItems
	}
	d obj.Close()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
LookUpOSItems
	set Data=$lb(ItemSeqNo,Item,ItemRowid,ItemDoseQty,ItemDoseUOM,ItemDoseUOMRowid,ItemFreq,ItemFreqRowid,ItemInstr,ItemInstrRowid,ItemDur,ItemDurRowid,ItemPackQty,ItemPackQtyUOM,ItemPackQtyUOMRowid,ItemPrior,ItemPriorRowid,NotifyClinician,id,ItemSpec,ItemSpecCode,OrderStage,OrderStageDesc,SpeedFlowRate,FlowRateUnit,FlowRateUnitRowid,OrderBodyPartLabel,OrderActionRowid,OrderAction,OrderSkinTest,OrderFreqTimeDoseStr,OrderFreqWeekStr,ItemRemark,CNMedItemFlag,ItemPrice,ItemStatus,OrderMustEnter)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	Quit
}

/// Creator:      屈坚
/// CreatDate:    2020.11.2
/// Description:  取接收科室 (如果就诊id不为空，优先根据就诊科室取接收科室，如就诊id为空，根据开单科室取接收科室)
/// Input:        EpisodeID:就诊ID
///               EpLoc:开单科室
///               Arcim:医嘱项ID
/// 			  OpenForAllHosp:是否跨院 (1是 0否)
/// 			  OrdDate:日期 (可以为空,空为当天)
/// Others:      d ##class(DHCDoc.Interface.Inside.Service).GetRecloc(EpisodeID,EpLoc,Arcim,0,OrdDate)
ClassMethod GetRecloc(EpisodeID As %String, EpLoc As %String, Arcim As %String, OpenForAllHosp As %String = "", OrdDate As %String = "")
{
	n (EpisodeID , EpLoc , Arcim , OpenForAllHosp , OrdDate)
	s ret=""
	if (EpisodeID'=""){
		s ret=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,Arcim,OpenForAllHosp,OrdDate)
	}else{
		s ret=##class(web.DHCDocOrderCommon).GetLocRecLoc(EpLoc,Arcim,OpenForAllHosp,OrdDate) 
		}
	q ret
}

/// Creator:      宋春莉
/// CreatDate:    2020.11.24
/// Description:  判断患者是否为"纠纷患者"(判断来源特殊患者管理)
/// Table:        DHC_SpecPat
/// Input:        PatientID:患者RowId,	ExpStr：待扩展(以^分割)
/// Return:       flag flag:Y 是,N 不是
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetDisputePatFlag("8")
ClassMethod GetDisputePatFlag(PatientID As %String, ExpStr As %String = "")
{
	n (PatientID,ExpStr)
	s DisputePatFlag="N"
	s $zt="GetDisputePatFlag"
	Q:PatientID="" DisputePatFlag
	s PAPMIDVAnumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6) //"ALL" 9
	Q:PAPMIDVAnumber="" DisputePatFlag
	s DHCSPRowID=0
	for {
		s DHCSPRowID=$o(^DHCSP(0,"CredNo",PAPMIDVAnumber,DHCSPRowID)) Q:DHCSPRowID=""
		s SPStDate=$p($g(^DHCSP(DHCSPRowID)),"^",5)
		continue:(SPStDate'="")&&(SPStDate>+$h)
		s SPEndDate=$p($g(^DHCSP(DHCSPRowID)),"^",6)
		continue:(SPEndDate'="")&&(SPEndDate<+$h)
		s SPTypeDr=$p($g(^DHCSP(DHCSPRowID)),"^",4)
		continue:SPTypeDr=""
		s DHCPatTypeCode=$p($g(^DHCPatType(SPTypeDr)),"^",1)
		continue:DHCPatTypeCode'="DisputePat"
		s DisputePatFlag="Y"
		Q
	}
	Q DisputePatFlag
GetDisputePatFlag
	Q "程序异常:"_$zerror
}

/// Creator:      宋春莉
/// CreatDate:    2020.11.27
/// Description:  获取住院证上的实际入院日期和时间
/// Table:        DHCDocIPBooking
/// Input:        BookID:患者RowId,	ExpStr：待扩展(以^分割)
/// Return:       实际住院日期^时间
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).GetIPBookingInAdmDateTime("8")
ClassMethod GetIPBookingInAdmDateTime(BookID As %String, ExpStr As %String = "")
{
	n (BookID,ExpStr)
	Q:BookID="" "^"
	s InAdmDate=$p($g(^DHCDocIPBK(BookID)),"^",44) ;实际入院日期
	s:InAdmDate'="" InAdmDate=..%ZD(InAdmDate) 
	s InAdmTime=$p($g(^DHCDocIPBK(BookID)),"^",45) ;实际入院时间
	s:InAdmTime'="" InAdmTime=..%ZT(InAdmTime,1)
	Q InAdmDate_"^"_InAdmTime
}

/// Creator:      宋春莉
/// CreatDate:    2020.12.17
/// Description:  撤销护士置阳性记录产生的过敏记录
/// Table:        PA_Allergy
/// Input:        OEORIRowId:医嘱ID  UserID:用户ID
/// Return:       0 成功 其他 失败
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).CancelNursePatAllergy(1885||2,12307)
ClassMethod CancelNursePatAllergy(OEORIRowId As %String, UserID As %String) As %String
{
	n (OEORIRowId,UserID)
	Q:(OEORIRowId="")||(UserID="") 0
	s Adm=$p(^OEORD(+OEORIRowId),"^",1)
	s PatientID=$p(^PAADM(+Adm),"^",1)
	s ALGChildSub=$o(^PAPER(PatientID,"ALGOEORI",OEORIRowId,""),-1)
	Q:ALGChildSub="" 0
	s ALGRowId=PatientID_"||"_ALGChildSub
	s objAllergy=##class(User.PAAllergy).%OpenId(ALGRowId)
	s objAllergy.ALGStatus="I" ;状态
	s objAllergy.ALGInActive="Y" ;未激活标志
	s objAllergy.ALGLastUpdateDate=..%SysDate()
 	s objAllergy.ALGLastUpdateTime=..%SysTime()
	d objAllergy.ALGUpdateUserDRGetObjectId(UserID)
	s sc=objAllergy.%Save(0)
	If ($System.Status.IsError(sc)){
		Do $System.Status.DisplayError(sc)
		Q "-100"
	}
	d objAllergy.%Close()  s objAllergy=""
	s $P(^PAPER(+ALGRowId,"ALG",$P(ALGRowId,"||",2),"DHC"),"^",3)="N" ;冲突是否开启
	Q 0
}

/// Creater: 屈坚
/// CreateDate: 2021.11.22
/// Descript: 取药方式是否判断库存
/// InPut: aRowID : 取药方式RowID
/// OutPut: Y是N否
/// w ##Class(DHCDoc.Interface.Inside.Service).GetTakingMedicineCheck(1)
ClassMethod GetTakingMedicineCheck(aRowID As %String) As %String
{
	s rtn=$P(^DHCDocConfig("TakingMedicineMethod",aRowID),$c(1),4)
	q rtn
}

/// Creater: 	nk
/// CreateDate: 2023.02.27
/// Descript: 	根据传入科室获取审方系统是否开启,及其厂家配置信息
/// Input: 		LocRowID 科室RowID
/// OutPut: 	Json格式数组，若数组为空(返回值非空)，则表示未启用任何厂家审方系统
/// 			[{"CompanyRowid":37,"CompanyCode":"iMedical","CompanyDesc":"iMedical","ModuleRowid":30,"ModuleCode":"PrescAudit","ModuleDesc":"审方系统(合理用药与审方属同一模块的无需单独维护)","ReferenceJS":"scripts/dhcnewpro/dhcckb/css/pdss.css,scripts/dhcnewpro/dhcckb/pdss.js","ExtList":[]},{"CompanyRowid":34,"CompanyCode":"MeiKang","CompanyDesc":"美康","ModuleRowid":30,"ModuleCode":"PrescAudit","ModuleDesc":"审方系统(合理用药与审方属同一模块的无需单独维护)","ReferenceJS":"","ExtList":[]}]
/// Json字段说明:CompanyRowid 厂家rowid	CompanyCode 厂家代码	CompanyDesc 厂家描述
/// 			 ModuleCode 模块代码  	ModuleDesc 模块描述		ReferenceJS 关联的第三方js	ExtList 扩展设定
/// Other:		 CompanyCode=iMedical为东华医为审方系统
/// w ##Class(DHCDoc.Interface.Inside.Service).GetPrescAuditCompany(1)
ClassMethod GetPrescAuditCompany(LocRowID As %String) As %String
{
	n (LocRowID,%session)
	s HospitalId=$p($g(^CTLOC(LocRowID)),"^",22)
	s LinkInfo=##class(DHCDoc.Interface.AccessManage).GetAccessLinkInfo("Company","PrescAudit",HospitalId,"",LocRowID)
	Q LinkInfo
}

}
