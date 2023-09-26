/// Creator:    bianshuai;
/// CreateDate: 2016-10-14
/// Descript:   护士补录医嘱业务类
Class web.DHCEMNurAddOrder Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:获取病人基本就诊信息
/// W ##Class(web.DHCEMNurAddOrder).GetPatEssInfo("","32595")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID,%session)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s:$d(%session) LgHospID=%session.Get("LOGON.HOSPID")
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    //姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)   //出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBDay) //hxy $zd(PatBDay,3)
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)  			// 年龄
	s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   // 诊断
	s PatDiagDesc=$E(PatDiagDesc,1,14)
	s PatType=$p(^PAADM(EpisodeID),"^",2)          /// 就诊类型
	s ErrMsg=""
	s PatMedNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,PatType,.ErrMsg) // 病案号
	s PatBed=""
	s PatBedID=$p(^PAADM(EpisodeID),"^",73) //床号
	i PatBedID'="" s PatBed=$p(^PAWARD($p(PatBedID,"||",1),"BED",$p(PatBedID,"||",2)),"^",1)
	s mradm=$p(^PAADM(EpisodeID),"^",61)          /// 就诊类型

	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiagDesc_"^"_PatMedNo_"^"_BillType_"^"_PatBed_"^"_mradm_"^"_PatType
	
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiagDesc^PatMedNo^BillType^PatBed^mradm^PatType"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Creator:    bianshuai
/// CreateDate: 2016-10-14
/// Descript:   病人用药医嘱列表
/// w ##Class(web.DHCEMNurAddOrder).QueryPatOrderItems("0","15","334","2017-03-24","2017-03-24","","","0","","","67")
ClassMethod QueryPatOrderItems(rows As %String, page As %String, EpisodeID As %String, StartDate As %String, EndDate As %String, PriorCode As %String, TabType As %String, SelDate As %String, Moeori As %String, NurOrd As %String, LgLocID As %String, FirstFlag = "") As %String
{
	n (rows, page, EpisodeID, StartDate, EndDate, PriorCode, TabType, SelDate, Moeori, NurOrd, LgLocID, FirstFlag)
	//s ^BIANSHUAI(1)=$LB(offset, limit, EpisodeID, StartDate, EndDate, PriorCode, TabType, SelDate, Moeori, NurOrd, LgLocID, FirstFlag)
	i StartDate'="" s StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) // $zdh(StartDate,3)
	i EndDate'="" s EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) //$zdh(EndDate,3)

	i SelDate=0 D
	./// 按就诊记录
	.D ##Class(web.DHCEMNurAddOrder).QueryPatOrderItmsByAdm(rows, page, EpisodeID, StartDate, EndDate, PriorCode, TabType, SelDate, Moeori, NurOrd, LgLocID)
	E  D
	./// 按就诊日期
	.D ##Class(web.DHCEMNurAddOrder).QueryPatOrderItmsByDate(rows, page, EpisodeID, StartDate, EndDate, PriorCode, TabType, SelDate, Moeori, NurOrd, LgLocID)
	Q ""
}

/// Descript:  按照就诊ID查询病人用药医嘱列表
/// w ##Class(web.DHCEMNurAddOrder).QueryPatOrderItmsByAdm("10","1","32596","","","","","","","","1")
ClassMethod QueryPatOrderItmsByAdm(rows As %String, page As %String, EpisodeID As %String, StartDate As %String, EndDate As %String, PriorCode As %String, TabType As %String, SelDate As %String, IMoeori As %String, NurOrd As %String, LgLocID As %String) As %String
{
	n (rows, page, EpisodeID, StartDate, EndDate, PriorCode, TabType, SelDate, IMoeori, NurOrd, LgLocID)
	
	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    s LinkLocStr=..GetLinkLocation(LgLocID) /// 关联科室
 	s PriorDescStr=""
 	i PriorCode="Temps" s PriorDescStr=$g(^DHCOEOrdPrintSet("OrdTyp"))        /// 临嘱类型
 	e  i PriorCode="Long" s PriorDescStr=$g(^DHCOEOrdPrintSet("L","OrdTyp"))  /// 长嘱类型
	
	s HospId=0 //$p(^CTLOC(LgLocID),"^",22)  /// 医院ID
	
	s h=0
	s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	s itm=0
	f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d
	.Q:'$D(^OEORD(ord,"I",itm,1))
	.s OrdStatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)  /// 医嘱状态
	.q:(OrdStatus'="V")&(OrdStatus'="E")
	.s seqNo=$p($g(^OEORD(ord,"I",itm,3)),"^",4)	/// OEORI_SeqNo
	.s arcimid=$p($g(^OEORD(ord,"I",itm,1)),"^",2)  /// OEORI_ItmMast_DR
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s itemCatID=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",10) /// 医嘱子类ID 
	.s priorid=$p($g(^OEORD(ord,"I",itm,1)),"^",8) /// OEORI_Priority_DR
	.q:priorid=""  /// 床位费和诊疗费没有医嘱优先级,也不需要显示
	.s ordPrior=$p($g(^OECPR(priorid)),"^",2)      ///医嘱优先级 
	.s OrderOrdLocDR=$p($g(^OEORD(ord,"I",itm,7)),"^",2)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  /// 医嘱项名称
	.i TabType'="" Q:'##Class(web.DHCEMNurExe).CheckCon(HospId,TabType,ord,itm,"Temp","","")
	.s ItemOrderType=$P(^ARC("IC",itemCatID),"^",7)         /// 医嘱类型 代码
	.i seqNo["." s arcitmdesc="____"_arcitmdesc             /// 如果为子医嘱 名称前增加缩进
	.s oeori=ord_"||"_itm
	.s OrderStartDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)   /// 开始日期
	.i OrderStartDate'="" s OrderStartDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrderStartDate) //$zd(OrderStartDate,3)
	.s OrderStartTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)  /// 开始时间
	.i OrderStartTime'="" s OrderStartTime=$zt(OrderStartTime,1)
	.s OrderDate=$p($g(^OEORD(ord,"I",itm,3)),"^",7)
	.i OrderDate'="" s OrderDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrderDate) //$zd(OrderDate,3)
	.s OrderTime=$p($g(^OEORD(ord,"I",itm,1)),"^",17)
	.i OrderTime'="" s OrderTime=$zt(OrderTime,1)
	.s moeori=..GetMainOeori(ord_"||"_itm)   /// 主医嘱ID
	.s StartTab=""
	.i IMoeori=moeori s StartTab="1"
	.s OrderDocDR=$p($g(^OEORD(ord,"I",itm,1)),"^",11)
	.q:OrderDocDR=""
	.//s OrderDocDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
	.s OrderDocDesc=##Class(web.DHCEMOrdInfoVO).getCtcpDesc(ord,itm)
	.s SelectOrderItem=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",10)
	.s DurDesc=""
	.s DurID=$p($g(^OEORD(ord,"I",itm,2)),"^",6)            /// 疗程
	.i DurID'="" s DurDesc=$p($g(^PHCDU(DurID)),"^",3)
	.s OrderFreq=""
	.s OrderFreqRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",4)  /// 频次
	.i OrderFreqRowid'="" s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",3)
	.s OrderInstr=""
	.s OrderInstrRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",7)	/// 用法
	.i OrderInstrRowid'="" s OrderInstr=$p($g(^PHCIN(OrderInstrRowid)),"^",2)  
	.;s OrderDoseQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)	     /// 剂量
	.;s OrderDoseUOMRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",3) /// 剂量单位
	.;i OrderDoseUOMRowid'="" s OrderDoseUOM=$p($g(^CT("UOM",OrderDoseUOMRowid)),"^",2) /// 剂量单位
	.;e  s OrderDoseUOM=""
	.s LabEpisodeNo=$p($g(^OEORD(ord,"I",itm,3)),"^",20)  /// OEORI_LabEpisodeNo
	.;s OrderDoseQty=OrderDoseQty_OrderDoseUOM
	.s OrderDoseQty=##class(web.DHCEMOrdInfoVO).GetOrdItmQtyUnit(ord,itm)
	.s OrdProcNote=$g(^OEORD(ord,"I",itm,"DEP",1))        /// 备注
	.s OrdProcNote=OrdProcNote_""_$p($g(^OEORD(ord,"I",itm,2)),"^",8)
	.s recLoc=""
	.s recLocID=$p($g(^OEORD(ord,"I",itm,3)),"^",6)
	.i recLocID'="" s recLoc=$p($g(^CTLOC(recLocID)),"^",2)  /// 接收科室
	.s:recLoc["-" recLoc=$p(recLoc,"-",2)
	.s index=""
	.i moeori'="" D
	..s mord=$p(moeori,"||",1),mitm=$p(moeori,"||",2)
	..s index=$p($g(^OEORD(mord,"I",mitm,3)),"^",7)_"^"_$p($g(^OEORD(mord,"I",mitm,1)),"^",17) /// 医嘱日期^医嘱时间
	.s h=h+1
	.s ListData=arcitmdesc_"^"_oeori_"^"_seqNo_"^"_priorid_"^"_ordPrior_"^"_OrderDate_"^"_OrderTime_"^"_OrderDocDesc_"^"_OrderStartDate_"^"_OrderStartTime_"^"_SelectOrderItem_"^"_moeori_"^"_OrderFreq
	.s ListData=ListData_"^"_OrderInstr_"^"_DurDesc_"^"_OrderDoseQty_"^"_OrdProcNote_"^"_OrderFreqRowid_"^"_recLoc_"^"_LabEpisodeNo_"^"_arcimid
	.s ^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItems",pid,StartTab_"^"_index_"^"_$fn(seqNo,"",1)_"^"_moeori_"^"_h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""

	///转换数据为Json格式
	S ListTitle="arcitmdesc^oeori^SeqNo^priorid^ordPrior^OrderDate^OrderTime^OrderDocDesc^OrderStartDate^OrderStartTime^SelectOrderItem^moeori^OrderFreq^OrderInstr^OrderDurt^OrderDoseQty^OrderDepProcNote^OrderFreqRowid^recLoc^LabEpisodeNo^arcimid"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItems",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItems",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator:    bianshuai
/// CreateDate: 2016-10-14
/// Descript:   病人用药医嘱列表 按日期
/// w ##Class(web.DHCEMNurAddOrder).QueryPatOrderItmsByDate("10","1","451","63918","64223","","","","","","1")
ClassMethod QueryPatOrderItmsByDate(rows As %String, page As %String, EpisodeID As %String, StartDate As %String, EndDate As %String, PriorCode As %String, TabType As %String, SelDate As %String, IMoeori As %String, NurOrd As %String, LgLocID As %String) As %String
{
	n (rows, page, EpisodeID, StartDate, EndDate, PriorCode, TabType, SelDate, IMoeori, NurOrd, LgLocID)

    //i StartDate'="" s StartDate=$zdh(StartDate,3)
    //i EndDate'="" s EndDate=$zdh(EndDate,3)
  
	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    s LinkLocStr=..GetLinkLocation(LgLocID) /// 关联科室
 	s PriorDescStr=""
 	i PriorCode="Temps" s PriorDescStr=$g(^DHCOEOrdPrintSet("OrdTyp"))        /// 临嘱类型
 	e  i PriorCode="Long" s PriorDescStr=$g(^DHCOEOrdPrintSet("L","OrdTyp"))  /// 长嘱类型
	
	s HospId=0 //$p(^CTLOC(LgLocID),"^",22)  /// 医院ID
	
	i StartDate=""  s StartDate=+$h
	i EndDate=""  s EndDate=+$h
	s h=0
	s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	f OrdStDate=StartDate:1:EndDate  d
	.s itm=0
	.f  s itm=$o(^OEORDi(0,"StDt",OrdStDate,ord,itm)) q:itm=""  d
	..s OrdStatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)  /// 医嘱状态
	..q:(OrdStatus'="V")&(OrdStatus'="E")
	..s seqNo=$p($g(^OEORD(ord,"I",itm,3)),"^",4)	/// OEORI_SeqNo
	..s arcimid=$p($g(^OEORD(ord,"I",itm,1)),"^",2) /// OEORI_ItmMast_DR
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s itemCatID=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",10) /// 医嘱子类ID 
	..s priorid=$p($g(^OEORD(ord,"I",itm,1)),"^",8) /// OEORI_Priority_DR
	..q:priorid=""  /// 床位费和诊疗费没有医嘱优先级,也不需要显示
	..s ordPrior=$p($g(^OECPR(priorid)),"^",2)      ///医嘱优先级 
	..s OrderOrdLocDR=$p($g(^OEORD(ord,"I",itm,7)),"^",2)
	..s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  /// 医嘱项名称
	..i TabType'="" Q:'##Class(web.DHCEMNurExe).CheckCon(HospId,TabType,ord,itm,"Temp","","")
	..s ItemOrderType=$P(^ARC("IC",itemCatID),"^",7)         /// 医嘱类型 代码
	..i seqNo["." s arcitmdesc="____"_arcitmdesc             /// 如果为子医嘱 名称前增加缩进
	..s oeori=ord_"||"_itm
	..s OrderStartDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)   /// 开始日期
	..i OrderStartDate'="" s OrderStartDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrderStartDate) //$zd(OrderStartDate,3)
	..s OrderStartTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)  /// 开始时间
	..i OrderStartTime'="" s OrderStartTime=$zt(OrderStartTime,1)
	..s OrderDate=$p($g(^OEORD(ord,"I",itm,3)),"^",7)
	..i OrderDate'="" s OrderDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrderDate) //$zd(OrderDate,3)
	..s OrderTime=$p($g(^OEORD(ord,"I",itm,1)),"^",17)
	..i OrderTime'="" s OrderTime=$zt(OrderTime,1)
	..s moeori=..GetMainOeori(ord_"||"_itm)   /// 主医嘱ID
	..s StartTab=""
	..i IMoeori=moeori s StartTab="1"
	..s OrderDocDR=$p($g(^OEORD(ord,"I",itm,1)),"^",11)
	..q:OrderDocDR=""
	..//s OrderDocDesc=$p($g(^CTPCP(OrderDocDR,1)),"^",2)
	..s OrderDocDesc=##Class(web.DHCEMOrdInfoVO).getCtcpDesc(ord,itm)
	..s SelectOrderItem=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",10)
	..s OrderFreq=""
	..s OrderFreqRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",4)  /// 频次
	..i OrderFreqRowid'="" s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",3)
	..s OrderInstr=""
	..s OrderInstrRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",7)	/// 用法
	..i OrderInstrRowid'="" s OrderInstr=$p($g(^PHCIN(OrderInstrRowid)),"^",2)
	..s DurDesc=""
	..s DurID=$p($g(^OEORD(ord,"I",itm,2)),"^",6)            /// 疗程
	..i DurID'="" s DurDesc=$p($g(^PHCDU(DurID)),"^",3)
	..;s OrderDoseQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)	  /// 剂量
	..;s OrderDoseUOMRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",3) /// 剂量单位
	..;i OrderDoseUOMRowid'="" s OrderDoseUOM=$p($g(^CT("UOM",OrderDoseUOMRowid)),"^",2)				;剂量单位
	..;e  s OrderDoseUOM=""
	..s LabEpisodeNo=$p($g(^OEORD(ord,"I",itm,3)),"^",20)  /// OEORI_LabEpisodeNo
	..;s OrderDoseQty=OrderDoseQty_OrderDoseUOM
	..s OrderDoseQty=##class(web.DHCEMOrdInfoVO).GetOrdItmQtyUnit(ord,itm)
	..s OrdProcNote=$g(^OEORD(ord,"I",itm,"DEP",1))   	   /// 备注
	..s OrdProcNote=OrdProcNote_""_$p($g(^OEORD(ord,"I",itm,2)),"^",8)
	..s recLoc=""
	..s recLocID=$p($g(^OEORD(ord,"I",itm,3)),"^",6)
	..i recLocID'="" s recLoc=$p($g(^CTLOC(recLocID)),"^",2)  /// 接收科室
	..s:recLoc["-" recLoc=$p(recLoc,"-",2)
	..s index=""
	..i moeori'="" D
	...s mord=$p(moeori,"||",1),mitm=$p(moeori,"||",2)
	...s index=$p($g(^OEORD(mord,"I",mitm,3)),"^",7)_"^"_$p($g(^OEORD(mord,"I",mitm,1)),"^",17) /// 医嘱日期^医嘱时间
	..s h=h+1
	..s ListData=arcitmdesc_"^"_oeori_"^"_seqNo_"^"_priorid_"^"_ordPrior_"^"_OrderDate_"^"_OrderTime_"^"_OrderDocDesc_"^"_OrderStartDate_"^"_OrderStartTime_"^"_SelectOrderItem_"^"_moeori_"^"_OrderFreq
	..s ListData=ListData_"^"_OrderInstr_"^"_DurDesc_"^"_OrderDoseQty_"^"_OrdProcNote_"^"_OrderFreqRowid_"^"_recLoc_"^"_LabEpisodeNo_"^"_arcimid
	..s ^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItems",pid,StartTab_"^"_index_"^"_$fn(seqNo,"",1)_"^"_moeori_"^"_h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="arcitmdesc^oeori^SeqNo^priorid^ordPrior^OrderDate^OrderTime^OrderDocDesc^OrderStartDate^OrderStartTime^SelectOrderItem^moeori^OrderFreq^OrderInstr^OrderDurt^OrderDoseQty^OrderDepProcNote^OrderFreqRowid^recLoc^LabEpisodeNo^arcimid"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItems",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItems",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator:    bianshuai
/// CreateDate: 2016-10-14
/// Descript:   病人用药医嘱列表 按日期
/// w ##Class(web.DHCEMNurAddOrder).QueryPatOrderItmsByLoc("50","1","379","","","67")
ClassMethod QueryPatOrderItmsByLoc(rows As %String, page As %String, EpisodeID As %String, StartDate As %String, EndDate As %String, LgLocID As %String) As %String
{
	n (rows, page, EpisodeID, StartDate, EndDate, LgLocID)

    i StartDate'="" s StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) //$zdh(StartDate,3)
    i EndDate'="" s EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) //$zdh(EndDate,3)
    i StartDate="" s StartDate=+$H
    i EndDate="" s EndDate=+$H
    
	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s HospId=$p($g(^CTLOC(LgLocID)),"^",22)
    s LinkLocStr=..GetLinkLocation(LgLocID) /// 关联科室

	i StartDate=""  s StartDate=+$h
	i EndDate=""  s EndDate=+$h
	s h=0
	s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	f OrdStDate=StartDate:1:EndDate  d
	.s itm=0
	.f  s itm=$o(^OEORDi(0,"StDt",OrdStDate,ord,itm)) q:itm=""  d
	..s OrdStatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)  /// 医嘱状态
	..Q:(OrdStatus'="V")&(OrdStatus'="E")
	..Q:$p($g(^OEORD(ord,"I",itm,3)),"^",5)'="TB"
	..s SeqNo=$p($g(^OEORD(ord,"I",itm,3)),"^",4)	/// OEORI_SeqNo
	..s arcimid=$p($g(^OEORD(ord,"I",itm,1)),"^",2) /// OEORI_ItmMast_DR
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s itemCatID=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",10) /// 医嘱子类ID 
	..s PriorID=$p($g(^OEORD(ord,"I",itm,1)),"^",8) /// OEORI_Priority_DR
	..Q:PriorID=""									/// 床位费和诊疗费没有医嘱优先级,也不需要显示
	..s Prior=$p($g(^OECPR(PriorID)),"^",2)         /// 医嘱优先级 
	..s OrderOrdLocDR=$p($g(^OEORD(ord,"I",itm,7)),"^",2)
	..s CareProvID=$p($g(^OEORD(ord,"I",itm,1)),"^",11)
	..Q:##Class(web.DHCEMNurAddOrder).GetCarPrvTp(CareProvID)'="NURSE"
	..s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  /// 医嘱项名称
	..s ItemOrderType=$P(^ARC("IC",itemCatID),"^",7)         /// 医嘱类型 代码
	..s Oeori=ord_"||"_itm
	..s StartDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)   /// 开始日期
	..i StartDate'="" s StartDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(StartDate) //$zd(StartDate,3)
	..s StartTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)  /// 开始时间
	..i StartTime'="" s StartTime=$zt(StartTime,1)
	..//s PackQty=$p($g(^OEORD(ord,"I",itm,9)),"^",4)     /// 
	..s PackQty=$p($g(^OEORD(ord,"I",itm,1)),"^",12)
	..s billuomDesc="",billuomID=""
	..s billuomID=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)  /// 计价单位
	..i billuomID'="" s billuomDesc=$p(^CT("UOM",billuomID),"^",2)
	..s FreqDesc=""
	..s FreqID=$p($g(^OEORD(ord,"I",itm,2)),"^",4)      /// 频次
	..i FreqID'="" s FreqDesc=$p($g(^PHCFR(FreqID)),"^",3)
	..s InstrDesc=""
	..s InstrID=$p($g(^OEORD(ord,"I",itm,2)),"^",7)   	/// 用法
	..i InstrID'="" s InstrDesc=$p($g(^PHCIN(InstrID)),"^",2)
	..s DurDesc=""
	..s DurID=$p($g(^OEORD(ord,"I",itm,2)),"^",6)       /// 疗程
	..i DurID'="" s DurDesc=$p($g(^PHCDU(DurID)),"^",3) 
	..s DQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)	    /// 剂量
	..s DUomDesc=""
	..s DuomID=$p($g(^OEORD(ord,"I",itm,2)),"^",3)      /// 剂量单位
	..i DuomID'="" s DUomDesc=$p($g(^CT("UOM",DuomID)),"^",2)	/// 剂量单位
	..s OrdNote=$g(^OEORD(ord,"I",itm,"DEP",1))   /// OEORI_DepProcNotes
	..s OrdNote=OrdNote_""_$p($g(^OEORD(ord,"I",itm,2)),"^",8)
	..s bomId="",fac=1
	..s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,""))
	..i inci'="" d
	...s bomId=$p(^INCI(inci,1),"^",10) /// 基本单位
	...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(billuomID,bomId)
	..s sprice=+##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcimid,+$h,"","","","",HospId)
	..i ItemOrderType="P" s sprice=$p($g(^OEORD(ord,"I",itm,3)),"^",25)      /// 单价
	..s sprice=$fn(sprice*fac,"",2)				   /// 医嘱项价格
	..i $p(sprice,".")="" s sprice=0_sprice        /// 小于0的价格前补0
	..s spamt=sprice*PackQty					   /// 金额
	..i $p(spamt,".")="" s spamt=0_spamt           /// 小于0的价格前补0
	..s recLoc=""
	..s recLocID=$p($g(^OEORD(ord,"I",itm,3)),"^",6)
	..i recLocID'="" s recLoc=$p($g(^CTLOC(recLocID)),"^",2)  /// 接收科室
	..s:recLoc["-" recLoc=$p(recLoc,"-",2)
	..s h=h+1
	..s moeori=..GetMainOeori(ord_"||"_itm)   /// 主医嘱ID
	..i moeori'="" D
	...s mord=$p(moeori,"||",1),mitm=$p(moeori,"||",2)
	...s SeqNo=$p($g(^OEORD(mord,"I",mitm,3)),"^",4) /// 主医嘱序号
	..s BillType=""
	..s BillTypeID=$p($g(^OEORD(ord,"I",itm,11)),"^",18)
	..i BillTypeID'=""  s BillType=$p($g(^PAC("ADMREA",BillTypeID)),"^",2)
	..s ListData=h_"^"_arcimid_"^"_arcitmdesc_"^"_Oeori_"^"_SeqNo_"^"_PriorID_"^"_Prior_"^"_StartDate_"^"_StartTime_"^"_FreqID_"^"_FreqDesc
	..s ListData=ListData_"^"_InstrID_"^"_InstrDesc_"^"_DurID_"^"_DurDesc_"^"_sprice_"^"_PackQty_"^"_billuomID_"^"_billuomDesc_"^"_recLocID
	..s ListData=ListData_"^"_recLoc_"^"_DQty_"^"_DuomID_"^"_DUomDesc_"^"_OrdNote_"^"_spamt_"^"_BillTypeID_"^"_BillType_"^"_moeori
	..s ^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItmsByLoc",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ItmXuNo^ItmID^ItmDesc^ItmOeori^ItmSeqNo^ItmPriorID^ItmPrior^StartDate^StartTime^FreqID^FreqDesc^InstrID^InstrDesc^DurID^DurDesc^Sprice^PackQty^PUomID^PUomDesc^recLocID^recLoc^DQty^DuomID^DUomDesc^ProcNote^ItmTotal^BillTypeID^BillType^moeori"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItmsByLoc",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItmsByLoc",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator:    bianshuai
/// CreateDate: 2016-10-14
/// Descript:   获取科室的关联科室
/// w ##class(web.DHCEMNurAddOrder).GetLinkLocation(15)
ClassMethod GetLinkLocation(QueLocRowid As %String) As %String
{
	n (QueLocRowid)
	s LinkLocStr=""
	s LinkSub=0
	f  s LinkSub=$o(^CTLOC(QueLocRowid,"LINK",LinkSub)) q:LinkSub=""  d
	.s LinkLocDR=$p($g(^CTLOC(QueLocRowid,"LINK",LinkSub)),"^",1)
	.i LinkLocStr=""  s LinkLocStr=LinkLocDR
	.e  s LinkLocStr=LinkLocStr_"^"_LinkLocDR
 	q LinkLocStr
}

/// Creator:    bianshuai
/// CreateDate: 2016-10-14
/// Descript:   根据医嘱项目获取开医嘱所需信息
/// w ##class(web.DHCEMNurAddOrder).GetArcItemInfoByArcID(32596,"9384||1")
ClassMethod GetArcItemInfoByArcID(EpisodeID As %String, arcitemId As %String) As %String
{
	n (EpisodeID, arcitemId)
	Q:(EpisodeID="")||(arcitemId="") "-1"
	
	s PriorID=$O(^OECPR(0,"Code","NORM",0))         /// 优先级
	s Prior=$p($g(^OECPR(PriorID)),"^",2)           /// 医嘱优先级 
	s StartDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(+$h) //$zd(+$h,4)	  /// 医嘱日期
	s StartTime=$zt($p($h,",",2),2)			        /// 医嘱时间
	//s BillType=""
	//s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)   /// 费别指针
	//i BillTypeID'="" s BillType=$p(^PAC("ADMREA",BillTypeID),"^",2)
	s DefBillType=##Class(web.DHCEMNurAddOrder).GetPatDefualtBillType("E",EpisodeID)   /// 费别指针
	s BillTypeID=$p(DefBillType,"^",1)  /// 费别指针
	s BillType=$p(DefBillType,"^",2) 	/// 费别
	s itmmastid=$p(arcitemId,"||",1)
	s itmmastver=$p(arcitemId,"||",2)
	Q:+itmmastver=0 "-2"
	Q:'$d(^ARCIM(itmmastid,itmmastver)) "-3"
	s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  /// 医嘱项代码
	s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  /// 医嘱项名称
	s arcitmprice=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcitemId,+$h,"","","","")
	s arcitmprice=+$p(arcitmprice,"^") 					   /// 医嘱项价格
	//i $p(arcitmprice,".")="" s arcitmprice=0_arcitmprice   /// 小于0的价格前补0
	s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)  /// 医嘱子类ID
	s OrderType=$P(^ARC("IC",itemCatID),"^",7)  	       /// 医嘱子类类型
	s recLocDesc=""
	s recLocID=..jsDefaultRecLocID(EpisodeID,arcitemId)    /// 默认接收科室
	i recLocID'="" s recLocDesc=$p(^CTLOC(recLocID),"^",2)
	s:recLocDesc["-" recLocDesc=$p(recLocDesc,"-",2)
	s billuomDesc="",billuomID=""
	s billuomID=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)  /// 计价单位
	i billuomID'="" s billuomDesc=$p(^CT("UOM",billuomID),"^",2)
	s fac=1  	/// 单位转换系数
	s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmastid,"||",1),""))
	i inci'=""  D
	.s bomId=$p(^INCI(inci,1),"^",10) /// 基本单位
	.s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(billuomID,bomId)
	s pQty=1    /// 整包装数量
	s arcitmprice=arcitmprice*fac
	i $p(arcitmprice,".")="" s arcitmprice=0_arcitmprice   /// 小于0的价格前补0
	s arcitmprice=$fn(arcitmprice,"",2)
	s FreqRowid="",FreqDesc="",InstrRowid="",InstrDesc="",DurRowid="",DurDesc="",buomID="",buomDesc="",bQty=""
	s PhcDrgFormId=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",12)
	i PhcDrgFormId'="" D
	.s PhcDrgID=$P(PhcDrgFormId,"||",1)
	.s ChildSub=$P(PhcDrgFormId,"||",2)
	.s bQty=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,2)),"^",5)       /// 基本数量
	.s buomID=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,2)),"^",4)     /// 基本单位
	.i buomID'="" s buomDesc=$p(^CT("UOM",buomID),"^",2)
	.s FreqRowid=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,1)),"^",4)  /// 频次
	.i FreqRowid'="" s FreqDesc=$p($g(^PHCFR(FreqRowid)),"^",3)
	.s InstrRowid=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,1)),"^",5) /// 用法
	.i InstrRowid'="" s InstrDesc=$p($g(^PHCIN(InstrRowid)),"^",2)
	.s DurRowid=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,1)),"^",8)   /// 疗程
	.i DurRowid'="" s DurDesc=$p($g(^PHCDU(DurRowid)),"^",3)
	.s EqSub="0",EqUomID=""
	.f  s EqSub=$O(^PHCD(PhcDrgID,"DF",ChildSub,"EQ",EqSub)) Q:(EqSub="")||(EqUomID'="")  d
	..s EqUomID=$P(^PHCD(PhcDrgID,"DF",ChildSub,"EQ",EqSub),"^",1)
	..i EqUomID'="" s EqUomDesc=$P(^CT("UOM",EqUomID),"^",2)
	..s EqQty=+$P(^PHCD(PhcDrgID,"DF",ChildSub,"EQ",EqSub),"^",3) /// 缺省数量
	..Q:(EqUomID="")||(EqQty=0)
	..s buomID=EqUomID,buomDesc=EqUomDesc,bQty=EqQty
	.i $p(bQty,".",1)="" s bQty=0_bQty
	
	s ListData=arcitemId_"^"_arcitmcode_"^"_arcitmdesc_"^"_OrderType_"^"_PriorID_"^"_Prior_"^"_StartDate_"^"_StartTime_"^"_BillTypeID_"^"_BillType
	s ListData=ListData_"^"_PhcDrgFormId_"^"_FreqRowid_"^"_FreqDesc_"^"_DurRowid_"^"_DurDesc_"^"_InstrRowid_"^"_InstrDesc_"^"_bQty
	s ListData=ListData_"^"_buomID_"^"_buomDesc_"^"_arcitmprice_"^"_recLocID_"^"_recLocDesc_"^"_pQty_"^"_billuomID_"^"_billuomDesc
	s ListTitle="arcitemId^arcitmcode^arcitmdesc^OrderType^ItmPriorID^ItmPrior^OrderStartDate^OrderStartTime^BillTypeID^BillType^PhcDrgFormId^FreqRowid^FreqDesc^DurRowid^DurDesc^InstrRowid^InstrDesc^bQty^buomID^buomDesc^arcitmprice^recLocID^recLocDesc^pQty^billuomID^billuomDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2016-10-14
/// Descript:	插入医嘱
/// 入参: mListData=itmmastid_"^"_OrderType_"^"_OrderPriorId_"^"_OrderStartDate_"^"_OrderStartTime_"^"_PackQty_"^"_""_"^"_recLocID_"^"_BillTypeRowid
/// mListData=mListData_"^"_DrgFormRowid_"^"_""_"^"_""_"^"_""_"^"_DoseQtySum_"^"_FreqRowid_"^"_DurRowid_"^"_InstrRowid_"^"_""_"^"_""_"^"_SeqNo
/// mListData=mListData_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
/// 示例：mListData="27899||1^N^3^26/10/2016^16:51^1^^4^1^^^^^1^^^^^^1^^^^^^^^!!27898||1^N^3^26/10/2016^16:51^1^^4^1^^^^^1^^^^^^2^^^^^^^^"
/// W ##Class(web.DHCEMNurAddOrder).SaveOrderItems("1797","4636","285","11558||1^^3^^^1^54.34^370^1^^^^^^^^^^^1^^^^^^^^^^^^^^^^^^^")
ClassMethod SaveOrderItems(EpisodeID As %String, UserID As %String, LocID As %String, mListData As %String) As %String
{
	n (EpisodeID, UserID, LocID, mListData)
	s $ZT="MsgError"
	Q:(EpisodeID="")||(UserID="")||(LocID="") "-1"
	Q:mListData="" "-2"
	s mListData=..dealInsListData(EpisodeID, mListData) /// 保存医嘱前，进行数据效验
	s mListData=$replace(mListData,"&&",$c(1))  	    /// 替换分割符
	s CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)    /// 医生ID
	s ret=##Class(DHCDoc.Interface.Inside.ServiceOrd.cls).SaveOrderItems(EpisodeID, mListData, UserID, LocID, CareProvID, "", "^^^1")
	i ret<0 Q "-3"
	Q 0
MsgError
  Q "-99"
}

/// Creator:     bianshuai
/// CreateDate:  2016-10-14
/// Descript:    调用停医嘱接口
/// InPut：      医嘱ID,用户UserID
/// OutPut:      0-成功、非0-失败
/// W ##Class(web.DHCEMNurAddOrder).InvStopOrder("85722||1","13")
ClassMethod InvStopOrder(Oeori As %String, LgUserID As %String) As %String
{
	n (Oeori, LgUserID)
	Q:Oeori="" "-1"
	s OeStat=..GetOeoriStat(Oeori)   /// 医嘱状态
	Q:(OeStat="D")||(OeStat="C") 0
	//s Err=##Class(appcom.OEOrdItem).StopMulti(Oeori,LgUserID,"","N")
	s Err=##Class(web.DHCOEOrdItem).Stop(Oeori,LgUserID,0)
	Q Err
}

/// Descript: 医嘱执行状态
ClassMethod GetOeoriStat(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" ""
	s ItemStatID=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
	Q:ItemStatID="" ""
	s ExeStatCode=$p(^OEC("OSTAT",ItemStatID),"^",1)
	Q ExeStatCode
}

/// Creator:     bianshuai
/// CreateDate:  2016-10-14
/// Descritp:	 接收科室  deftyle="Y"是默认接收科室
/// W ##Class(web.DHCEMNurAddOrder).jsonArcCatRecLocByItemCat("24","20")
ClassMethod jsonArcCatRecLocByItemCat(EpisodeID As %String, itemCatID As %String) As %String
{
	n (EpisodeID, itemCatID)

	s admLocID=$p(^PAADM(EpisodeID),"^",4) 			 ///就诊科室
	s LocListData=##Class(web.DHCDocOrderCommon).GetLocRecLocByItemCat(admLocID,itemCatID)
	s count = 0
	w "["
	s Len = $L(LocListData,$C(2))
	f i=1:1:Len d
	.s LocList = $p(LocListData,$C(2),i)
	.s LocID = $p(LocList,$C(1),1)
	.s LocDesc = $p(LocList,$C(1),2)
	.i LocDesc["-" s LocDesc=$p(LocDesc,"-",2) 
	.s tmp=LocID_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Creator:     bianshuai
/// CreateDate:  2016-10-25
/// Descritp:	 获取默认接收科室
/// W ##Class(web.DHCEMNurAddOrder).jsDefaultRecLocID("32595","35")
ClassMethod jsDefaultRecLocID(EpisodeID As %String, ItmmastID As %String) As %String
{
	n (EpisodeID, ItmmastID)
	s LocListData=##Class(web.DHCDocOrderCommon).GetRecloc(EpisodeID, ItmmastID)
	s LocID=""
	s Len = $L(LocListData,$C(2))
	f i=1:1:Len d
	.s LocList = $p(LocListData,$C(2),i)
	.s DefTyle = $p(LocList,$C(1),3)
	.Q:DefTyle'="Y"
	.s LocID = $p(LocList,$C(1),1)
	
	Q LocID
}

/// Descritp:	接收科室
/// w ##Class(web.DHCEMNurAddOrder).jsonExaCatRecLocNew("27689","11207||1")
ClassMethod jsonExaCatRecLocNew(EpisodeID As %String, ItmmastID As %String) As %String
{
	n (EpisodeID, ItmmastID)
	s LocListData=##Class(web.DHCDocOrderCommon).GetRecloc(EpisodeID, ItmmastID)
	s count = 0
	w "["
	s Len = $L(LocListData,$C(2))
	f i=1:1:Len d
	.s LocList = $p(LocListData,$C(2),i)
	.s LocID = $p(LocList,$C(1),1)
	.s LocDesc = $p(LocList,$C(1),2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s Default = $p(LocList,$C(1),3)
	.s tmp=LocID_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Descritp:	费别
/// w ##Class(web.DHCEMNurAddOrder).jsonEpiAdmReason("")
ClassMethod jsonEpiAdmReason(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s count = 0
	w "["
	s reaID=0
	f  s reaID=$o(^PAC("ADMREA",reaID)) Q:reaID=""  D
	.s reaDesc=$p(^PAC("ADMREA",reaID),"^",2)
	.s tmp=reaID_"^"_reaDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Creator:     bianshuai
/// CreateDate:  2016-10-25
/// Descript:	 护士可补录医嘱列表
/// D ##Class(%ResultSet).RunQuery("web.DHCEMNurAddOrder","QueryArcNurAddOrder","592","","","","wss")
Query QueryArcNurAddOrder(rows As %String, page As %String, EpisodeID As %String, LgGroupID As %String, LgUserID As %String, LgLocID As %String, EntryAlias As %String) As %Query(ROWSPEC = "arcitemId:%String,arcitmcode:%String,arcitmdesc:%String,arcitmprice:%String,recLocID:%String,recLocDesc:%String,FreqRowid:%String,FreqDesc:%String,InstrRowid:%String,InstrDesc:%String,DurRowid:%String,DurDesc:%String,ItmPriorID:%String,ItmPrior:%String,BillTypeRowid:%String,BillType:%String,pQty:%String,billuomID:%String,billuomDesc:%String,bQty:%String,buomID:%String,buomDesc:%String,OrderType:%String") [ SqlProc ]
{
}

ClassMethod QueryArcNurAddOrderExecute(ByRef qHandle As %Binary, rows As %String, page As %String, EpisodeID As %String, LgGroupID As %String, LgUserID As %String, LgLocID As %String, EntryAlias As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s EndPage=page*rows           /// 结束行
	s StartPage=((page-1)*rows)+1 /// 开始行
	s total=0
	
	s PriorID=$O(^OECPR(0,"Code","NORM",0))        /// 优先级
	s Prior=$p($g(^OECPR(PriorID)),"^",2)          /// 医嘱优先级
	//s BillTypeRowid=$P(^PAADM(EpisodeID,1),"^",7)  /// 费别指针
	s DefBillType=##Class(web.DHCEMNurAddOrder).GetPatDefualtBillType("E",EpisodeID)   /// 费别指针
	s BillTypeID=$p(DefBillType,"^",1)  /// 费别指针
	s BillType=$p(DefBillType,"^",2) 	/// 费别
	s EpisodeType=$P(^PAADM(EpisodeID),"^",2)      /// 就诊类型
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	Q:EntryAlias="" $$$OK
	s EntryAlias1="%"_EntryAlias_"%" ;;hxy
	s EntryAlias="%"_$$ALPHAUP^SSUTIL4(EntryAlias)_"%"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr ="select distinct alias_arcim_dr from arc_alias where %ALPHAUP(alias_text) like '"_EntryAlias_"' or ALIAS_Desc like '"_EntryAlias1_"' "  
	;s sqlStr ="select distinct alias_arcim_dr from arc_alias where %ALPHAUP(alias_text) like '"_EntryAlias_"'"  
    D result.Prepare(sqlStr)
    s SC=result.Execute()
    i $$$ISERR(SC) Q ""
 
    While(result.Next()){
	    s arcitemId = result.Data("ALIAS_ARCIM_DR")
	    s itmmastid=$p(arcitemId,"||",1)
	    s itmmastver=$p(arcitemId,"||",2)
	    Continue:+itmmastver=0
        Continue:'$d(^ARCIM(itmmastid,itmmastver))
        s found=##Class(web.DHCDocOrderEntry).ValOrd("ARCIM",LgGroupID,arcitemId,EpisodeType,"",LgUserID,LgLocID,"","",PatientID)
		Continue:'found
		s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  /// 医嘱项代码
		s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  /// 医嘱项名称
		s arcitmprice=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcitemId,+$h,"","","","")
		s arcitmprice=+$p(arcitmprice,"^") 					   /// 医嘱项价格
		s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)  /// 医嘱子类ID
		s OrderType=$P(^ARC("IC",itemCatID),"^",7)  	       /// 医嘱子类类型
		s recLocDesc=""
		s recLocID=..jsDefaultRecLocID(EpisodeID,arcitemId)    /// 默认接收科室
		i recLocID'="" s recLocDesc=$p(^CTLOC(recLocID),"^",2)
		s:recLocDesc["-" recLocDesc=$p(recLocDesc,"-",2)
		s billuomDesc="",billuomID=""
		s billuomID=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)  /// 计价单位
		i billuomID'="" s billuomDesc=$p(^CT("UOM",billuomID),"^",2)
		s fac=1
		s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmastid,"||",1),""))
		i inci'="" D	
		.s bomId=$p(^INCI(inci,1),"^",10) /// 基本单位
		.s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(billuomID,bomId)
		s pQty=1    /// 整包装数量
		s arcitmprice=arcitmprice*fac
		i $p(arcitmprice,".")="" s arcitmprice=0_arcitmprice   /// 小于0的价格前补0
		s FreqRowid="",FreqDesc="",InstrRowid="",InstrDesc="",DurRowid="",DurDesc="",buomID="",buomDesc="",bQty=""
		s PhcDrgFormId=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",12)
		i PhcDrgFormId'="" D
		.s PhcDrgID=$P(PhcDrgFormId,"||",1)
		.s ChildSub=$P(PhcDrgFormId,"||",2)
		.s bQty=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,2)),"^",5)       /// 基本数量
		.s buomID=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,2)),"^",4)     /// 单位
	    .i buomID'="" s buomDesc=$p(^CT("UOM",buomID),"^",2)
		.s FreqRowid=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,1)),"^",4)  /// 频次
	    .i FreqRowid'="" s FreqDesc=$p($g(^PHCFR(FreqRowid)),"^",3)
	    .s InstrRowid=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,1)),"^",5) /// 用法
	    .i InstrRowid'="" s InstrDesc=$p($g(^PHCIN(InstrRowid)),"^",2)
	    .s DurRowid=$p($g(^PHCD(PhcDrgID,"DF",ChildSub,1)),"^",8)   /// 疗程
	    .i DurRowid'="" s DurDesc=$p($g(^PHCDU(DurRowid)),"^",3)
		.s EqSub="0",EqUomID=""
		.f  s EqSub=$O(^PHCD(PhcDrgID,"DF",ChildSub,"EQ",EqSub)) Q:(EqSub="")||(EqUomID'="")  d
		..s EqUomID=$P(^PHCD(PhcDrgID,"DF",ChildSub,"EQ",EqSub),"^",1)
		..i EqUomID'="" s EqUomDesc=$P(^CT("UOM",EqUomID),"^",2)
		..s EqQty=+$P(^PHCD(PhcDrgID,"DF",ChildSub,"EQ",EqSub),"^",3) /// 缺省数量
		..Q:(EqUomID="")||(EqQty=0)
		..s buomID=EqUomID,buomDesc=EqUomDesc,bQty=EqQty
		.i $p(bQty,".",1)="" s bQty=0_bQty
	    s total = total+1
		Continue:total<StartPage
		Continue:total>EndPage
		
        s ListData = arcitemId_"^"_arcitmcode_"^"_arcitmdesc_"^"_arcitmprice_"^"_recLocID_"^"_recLocDesc_"^"_FreqRowid_"^"_FreqDesc
 		s ListData = ListData_"^"_InstrRowid_"^"_InstrDesc_"^"_DurRowid_"^"_DurDesc_"^"_PriorID_"^"_Prior_"^"_BillTypeID_"^"_BillType_"^"_pQty_"^"_billuomID
 		s ListData = ListData_"^"_billuomDesc_"^"_bQty_"^"_buomID_"^"_buomDesc_"^"_OrderType
 		D OutPutRow
 
    }
    Q $$$OK
OutPutRow
	s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")
	s ind=ind+1
	Q
}

ClassMethod QueryArcNurAddOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryArcNurAddOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryArcNurAddOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryArcNurAddOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:     bianshuai
/// CreateDate:  2016-10-25
/// Descript:	 护士可补录医嘱列表
/// W ##Class(web.DHCEMNurAddOrder).JsonQryArcNurAddOrder("10","1","1053","175","600","159","CS")
ClassMethod JsonQryArcNurAddOrder(rows As %String, page As %String, EpisodeID As %String, LgGroupID As %String, LgUserID As %String, LgLocID As %String, EntryAlias As %String) As %String
{
	n (rows, page, EpisodeID, LgGroupID, LgUserID, LgLocID, EntryAlias)
	Set count = 0, total = 0
 	Set result1=##Class(%Library.ResultSet).%New("web.DHCEMNurAddOrder:QueryArcNurAddOrder")
 	Set sc=result1.Execute(rows, page, EpisodeID, LgGroupID, LgUserID, LgLocID, EntryAlias)
 	If $$$ISERR(sc) Quit ""
    Set colNum=result1.GetColumnCount() //列数
    
    Set del=""""
 	Write "{"_del_"rows"_del_":["
	While(result1.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.Set resValue=##Class(ext.util.String).EvalJSON($P(result1.%GetData(i),$C(13,10)))
		.If ret="" Set ret=del_result1.GetColumnName(i)_del_":"_del_resValue_del
		.Else   Set ret=ret_","_del_result1.GetColumnName(i)_del_":"_del_resValue_del
		Set count = count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }	 
	 Write "],"_del_"total"_del_":"_total_"}"
	 Do result1.Close()
	 Quit ""
}

/// Creator:     huaxiaoying
/// CreateDate:  2016-12-22
/// Descript:	 用法列出  PHC_Instruc
/// W ##Class(web.DHCEMNurAddOrder).JsonQryLookUpInstr(10,1,"","口服")
ClassMethod JsonQryLookUpInstr(rows = 10, page = 1, arcimrowid, instrdesc, paadmtype) As %String
{
	n (rows, page, arcimrowid, instrdesc, paadmtype)
	
	s start=(page-1)*rows+1
	s end=page*rows
	
	Set count = 0, total = 0
 	Set result1=##class(%Library.ResultSet).%New("web.DHCEMNurAddOrder:LookUpInstr")
 	Set sc=result1.Execute(instrdesc, paadmtype, arcimrowid)
 	If $$$ISERR(sc) Quit ""
    Set colNum=result1.GetColumnCount() //列数
    
    Set del=""""
 	Write "{"_del_"rows"_del_":["
	While(result1.Next())
	{ 
		Set ret=""
		Set count = count+1
		continue:count<start
		continue:count>end ;q:count>end
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result1.GetColumnName(i)_del_":"_del_$P(result1.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result1.GetColumnName(i)_del_":"_del_$P(result1.%GetData(i),$C(13,10))_del
		If count=start Write "{"_ret_"}" ;If count=((page-1)*10+1) Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }	 
	 Write "],"_del_"total"_del_":"_count_"}"
	 Do result1.Close()
	 Quit ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMNurAddOrder","LookUpInstr","口服","8598||1")
/// Descript: 用法字典
Query LookUpInstr(instrdesc As %String, paadmtype As %String, arcimrowid As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "ID:%String,Desc:%String,Code:%String")
{
}

ClassMethod LookUpInstrClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpInstrFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LookUpInstrExecute(ByRef qHandle As %Library.Binary, instrdesc As %Library.String, paadmtype As %String = "", arcimrowid As %Library.String = "") As %Library.Status
{
	n (qHandle,instrdesc,paadmtype,arcimrowid)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	K ^TMP($J,"InstrLookup")
	s instrdesc=$zcvt(instrdesc,"U")
	
	if $g(arcimrowid)'="" {
		Set rset=##Class(%ResultSet).%New("web.DHCSTINTERFACE.GetPHCInstruc")
		If rset.QueryIsValid() { 
			Set Status=rset.Execute(arcimrowid)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				s code=rset.GetData(1)
				s desc1=rset.GetData(2)
				s rowid=rset.GetData(3)
				continue:(instrdesc'="")&&((desc1'[instrdesc)&&(code'[instrdesc))
				s ^TMP($J,"InstrLookup",rowid)=rowid_"^"_desc1_"^"_code				
			}
			d rset.Close()
		}
		Set repid=$I(^CacheTemp)
		If $g(ind)="" Set ind=1
		//按照序号排序
		s rid=0 for {
			s rid=$O(^TMP($J,"InstrLookup",rid))
			Quit:rid=""
			s temp=^TMP($J,"InstrLookup",rid)
			s rowid=$P(temp,"^",1)
			s desc1=$P(temp,"^",2)
			s code=$P(temp,"^",3)
			do OuputRow5		
		}
		
	}else{
		&sql(declare CurInstr cursor for
			SELECT PHCIN_RowId,PHCIN_Desc1,PHCIN_Code FROM SQLUser.PHC_Instruc 
			WHERE (PHCIN_Desc1 %STARTSWITH :instrdesc or PHCIN_Code %STARTSWITH :instrdesc) and (PHCIN_Desc1 NOT LIKE '%停用%') and (PHCIN_Desc2<>'饮片')
			ORDER BY PHCIN_Code)
		&sql(open CurInstr)
		s num=0
		f  &sql(fetch CurInstr into :rowid,:desc1,:code) q:SQLCODE  d
		.do OuputRow5
		;S ^TMP($J,"InstrLookup",rowid)=rowid_"^"_desc1_"^"_code
		&sql(close CurInstr)
		
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow5
	set Data=$lb(rowid,desc1,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpInstrFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpInstrExecute ]
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

/// Creator:     huaxiaoying
/// CreateDate:  2016-12-22
/// Descript:	 疗程列出 PHC_Duration
/// W ##Class(web.DHCEMNurAddOrder).JsonQryLookUpDuration(10,1,"天")
ClassMethod JsonQryLookUpDuration(rows = 10, page = 1, freqdesc) As %String
{
	n (rows, page, freqdesc)
	
	s start=(page-1)*rows+1
	s end=page*rows
	
	Set count = 0, total = 0
 	Set result1=##class(%Library.ResultSet).%New("web.DHCEMNurAddOrder:LookUpDuration")
 	Set sc=result1.Execute(freqdesc)
 	If $$$ISERR(sc) Quit ""
    Set colNum=result1.GetColumnCount() //列数
    
    Set del=""""
 	Write "{"_del_"rows"_del_":["
	While(result1.Next())
	{ 
		Set ret=""
		Set count = count+1
		continue:count<start
		continue:count>end ;q:count>end
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result1.GetColumnName(i)_del_":"_del_$P(result1.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result1.GetColumnName(i)_del_":"_del_$P(result1.%GetData(i),$C(13,10))_del
		If count=start Write "{"_ret_"}" ;If count=((page-1)*10+1) Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }	 
	 Write "],"_del_"total"_del_":"_count_"}"
	 Do result1.Close()
	 Quit ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMNurAddOrder","LookUpDuration","天")
/// Descript: 疗程字典
Query LookUpDuration(desc As %String) As %Query(CONTAINID = 3, ROWSPEC = "ID:%String,Desc:%String,Code:%String,HIDDEN:%String")
{
}

ClassMethod LookUpDurationExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s desc=$$ALPHAUP^SSUTIL4(desc)
 	s PHCDURowId=0
 	f  s PHCDURowId=$O(^PHCDU(PHCDURowId)) Q:PHCDURowId=""  d
 	.s PHCDUCode=$P(^PHCDU(PHCDURowId),"^",1)
 	.s PHCDUFactor=$P(^PHCDU(PHCDURowId),"^",2)
 	.s PHCDUDesc1=$P(^PHCDU(PHCDURowId),"^",3)
 	.s PHCDUDesc2=$P(^PHCDU(PHCDURowId),"^",4)
 	.Q:PHCDUDesc2="饮片"
 	.s FindFlag=1
 	.i desc'=""  d
 	..s FindFlag=0
 	..s SubFactor=$$ALPHAUP^SSUTIL4(PHCDUFactor)
 	..s SubDesc1=$$ALPHAUP^SSUTIL4(PHCDUDesc1)
 	..i ((SubFactor=desc)||(SubDesc1[desc))  d
 	...s FindFlag=1
 	..i FindFlag'=1 d
 	...s SubID=0  
	...f  s SubID=$O(^User.BDPAliasI("DataRef","PHC_Duration",PHCDURowId,SubID)) Q:SubID=""  d
	....i $D(^User.BDPAliasD(SubID)) d
	.....s SUbCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
	.....i SUbCode[desc  d
	......s FindFlag=1
	.Q:FindFlag'=1
	.s RowID=PHCDURowId
	.s CTPCPDesc=PHCDUDesc1
	.s CTPCPCode=PHCDUCode
	.s Facter=PHCDUFactor
	.Do OutputDuration
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDuration
	set Data=$lb(RowID,CTPCPDesc,CTPCPCode,Facter)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDurationExecute ]
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

ClassMethod LookUpDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpDurationExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:     huaxiaoying
/// CreateDate:  2016-12-21
/// Descript:	 频次列出 PHC_Freq
/// W ##Class(web.DHCEMNurAddOrder).JsonQryLookUpFrequency(10,1,"")
ClassMethod JsonQryLookUpFrequency(rows = 10, page = 1, freqdesc, paadmtype) As %String
{
	n (rows, page, freqdesc, paadmtype)

	s start=(page-1)*rows+1
	s end=page*rows
	
	Set count = 0, total = 0
 	Set result1=##class(%Library.ResultSet).%New("web.DHCEMNurAddOrder:LookUpFrequency")
 	Set sc=result1.Execute(freqdesc,paadmtype)
 	If $$$ISERR(sc) Quit ""
    Set colNum=result1.GetColumnCount() //列数
    
    Set del=""""
 	Write "{"_del_"rows"_del_":["
	While(result1.Next())
	{ 
		Set ret=""
		Set count = count+1
		continue:count<start
		continue:count>end
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result1.GetColumnName(i)_del_":"_del_$P(result1.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result1.GetColumnName(i)_del_":"_del_$P(result1.%GetData(i),$C(13,10))_del
		If count=start Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }	 
	 Write "],"_del_"total"_del_":"_count_"}"
	 Do result1.Close()
	 Quit ""
}

/// huaxiaoying 2016-12-19
/// d ##class(%ResultSet).RunQuery("web.DHCEMNurAddOrder","LookUpFrequency","bid","")
/// Descript: 频次字典
Query LookUpFrequency(desc As %Library.String, PAAdmType As %Library.String = "") As %Library.Query(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String,HIDDEN:%String,ID:%String,HIDDEN:%String")
{
}

ClassMethod LookUpFrequencyClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFrequencyFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LookUpFrequencyExecute(ByRef qHandle As %Library.Binary, desc As %Library.String, PAAdmType As %Library.String = "") As %Library.Status
{
	n (qHandle,desc,PAAdmType)
	
	K ^TMP($J,"FreqLookup")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	s desc=$$ALPHAUP^SSUTIL4(desc)
	s PHCFRRowId=0
	f  s PHCFRRowId=$O(^PHCFR(PHCFRRowId)) Q:PHCFRRowId=""  d
	.s PHCFRCode=$P(^PHCFR(PHCFRRowId),"^",1)
	.s PHCFRFactor=$P(^PHCFR(PHCFRRowId),"^",2)
	.s PHCFRDesc1=$P(^PHCFR(PHCFRRowId),"^",3)
	.s PHCFRDesc2=$P(^PHCFR(PHCFRRowId),"^",4)
	.s PHCFRDays=$P(^PHCFR(PHCFRRowId),"^",5)
	.Q:(PHCFRDesc2="饮片")||(PHCFRDesc2="UNUSE")
	.s FindFlag=1
	.i desc'=""  d
	..s FindFlag=0
	..s SubCode=$$ALPHAUP^SSUTIL4(PHCFRCode)
	..s subDesc1=$$ALPHAUP^SSUTIL4(PHCFRDesc1)
	..i ((SubCode=desc)||(subDesc1[desc))  d
	...s FindFlag=1
	..i FindFlag'=1  d
	...s SubID=0  
	...f  s SubID=$O(^User.BDPAliasI("DataRef","PHC_Freq",PHCFRRowId,SubID)) Q:SubID=""  d
	....i $D(^User.BDPAliasD(SubID)) d
	.....s SUbCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
	.....i SUbCode[desc  d
	......s FindFlag=1
	.Q:FindFlag'=1
	.s desc1=PHCFRDesc1
	.s code=PHCFRCode
	.s factor=PHCFRFactor
	.s days=PHCFRDays
	.s rowid=PHCFRRowId
	.;上边是SQL改为M---------------end--------
	.s PHCFRMarkNO=$p($G(^PHCFR(rowid,"DHC")),"^",2) 	//频次序列
 	.s PHCFRADMType=$p($G(^PHCFR(rowid,"DHC")),"^",3)	//就诊类型
	.q:((PAAdmType'="")&&(PHCFRADMType'=PAAdmType)&&(PHCFRADMType'=""))  //要求按照就诊类型来查
	.s weekflag=$P($g(^PHCFR(+$g(rowid),"DHC")),"^",1)
	.s disptimestr=""
	.i weekflag=1 s disptimestr=..GetFreqDispTimeStr(+$g(rowid))
	.i PHCFRMarkNO="" s PHCFRMarkNO="F9999"
	.e  s PHCFRMarkNO="F"_PHCFRMarkNO
	.S ^TMP($J,"FreqLookup",PHCFRMarkNO,rowid)=desc1_"^"_code_"^"_factor_"^"_days_"^"_rowid_"^"_disptimestr   //建立临时Globle
	
	//按照序号排序
	s seq=0 for {
		s seq=$O(^TMP($j,"FreqLookup",seq))
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(^TMP($J,"FreqLookup",seq,seq1))
			Quit:seq1=""
			s temp=^TMP($j,"FreqLookup",seq,seq1)
			s desc1=$P(temp,"^",1)
			s code=$P(temp,"^",2)
			s factor=$P(temp,"^",3)
			s days=$P(temp,"^",4)
			s rowid=$P(temp,"^",5)
			s disptimestr=$P(temp,"^",6)

			d OuputRow4		
		}
	}

	K ^TMP($J,"FreqLookup")
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow4
	set Data=$lb(desc1,code,factor,days,rowid,disptimestr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpFrequencyFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpFrequencyExecute ]
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

ClassMethod GetFreqDispTimeStr(PHCFRrow As %String) As %String
{
	s ret=""
	s childsub=0  f  s childsub=$O(^PHCFR(PHCFRrow,"OPDT",childsub)) Q:childsub=""  d
	.s time=$p(^PHCFR(PHCFRrow,"OPDT",childsub),"^",1)
	.s timestr=$zt(time,3)
	.s week=$p(^PHCFR(PHCFRrow,"OPDT",childsub),"^",2)
	.s DispTime=time_$C(2)_week
	.i ret="" s ret=DispTime
	.e  s ret=ret_$C(1)_DispTime
	Q ret
}

// hxy end

/// Descript: 病人历次就诊记录
/// w ##Class(web.DHCEMNurAddOrder).JsonPatAdmHisList("30","1","1507")
ClassMethod JsonPatAdmHisList(rows As %String, page As %String, EpisodeID As %String) As %String
{
	n (rows, page, EpisodeID)
    ;s rows=30,page=1
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s PatientID=$p(^PAADM(EpisodeID),"^",1)      /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s h=0,count=0
	s PatType=""
	f  s PatType=$o(^PAPERdr(PatientID,"ADM",PatType)) Q:PatType=""  D
	.s EpisodeID=""
	.f  s EpisodeID=$o(^PAPERdr(PatientID,"ADM",PatType,EpisodeID)) Q:EpisodeID=""  D
	..s AdmDate=$p(^PAADM(EpisodeID),"^",6)  //就诊日期
	..s AdmTime=$p(^PAADM(EpisodeID),"^",7)  //就诊时间
	..i AdmDate'="" S AdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate) //$zd(AdmDate,3)
	..i AdmTime'="" S AdmTime=$zt(AdmTime,1)
	..s AdmLoc=""
	..s AdmLocID=$p(^PAADM(EpisodeID),"^",4)     /// 科室
	..s:AdmLocID'="" AdmLoc=$p(^CTLOC(AdmLocID),"^",2)
	..s AdmDoc=""
	..s AdmDocID=$p(^PAADM(EpisodeID),"^",9)     /// 医生
	..s:AdmDocID'="" AdmDoc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
	..s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) /// 诊断
	..s h=h+1
	..s itmLabel=AdmDate_" "_AdmLoc_" "_AdmDoc_" "_PatDiag
	..s ListData=EpisodeID_"^"_itmLabel_"^"_AdmDate_"^"_AdmTime_"^"_PatNo_"^"_PatName_"^"_AdmLoc_"^"_AdmDoc
	..s ^TMP("DHCST","web.DHCEMNurAddOrder","jsonPatAdmHisList",pid,h)=ListData
	.
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="EpisodeID^itmLabel^AdmDate^AdmTime^PatNo^PatName^AdmLoc^AdmDoc^PatDiag"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMNurAddOrder","jsonPatAdmHisList",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMNurAddOrder","jsonPatAdmHisList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:   新版急诊 病人历次就诊记录副本 下拉
/// Creator:     huaxiaoying
/// CreateDate:  2016-10-03
/// w ##Class(web.DHCEMNurAddOrder).JsonPatAdmHisList1("98")
ClassMethod JsonPatAdmHisList1(EpisodeID As %String) As %String
{
	n ( EpisodeID)

	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s PatientID=$p(^PAADM(EpisodeID),"^",1)      /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s h=0,count=0
	s PatType=""
	f  s PatType=$o(^PAPERdr(PatientID,"ADM",PatType)) Q:PatType=""  D
	.s EpisodeID=""
	.f  s EpisodeID=$o(^PAPERdr(PatientID,"ADM",PatType,EpisodeID)) Q:EpisodeID=""  D
	..s AdmDate=$p(^PAADM(EpisodeID),"^",6)  //就诊日期
	..s AdmTime=$p(^PAADM(EpisodeID),"^",7)  //就诊时间
	..i AdmDate'="" S AdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate) //$zd(AdmDate,3)
	..i AdmTime'="" S AdmTime=$zt(AdmTime,1)
	..s AdmLoc=""
	..s AdmLocID=$p(^PAADM(EpisodeID),"^",4)     /// 科室
	..s:AdmLocID'="" AdmLoc=$p(^CTLOC(AdmLocID),"^",2)
	..s AdmDoc=""
	..s AdmDocID=$p(^PAADM(EpisodeID),"^",9)     /// 医生
	..s:AdmDocID'="" AdmDoc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
	..s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) /// 诊断
	..s h=h+1
	..i AdmLoc["-" d
	...s AdmLoc=$p(AdmLoc,"-",2)
	..s itmLabel=EpisodeID_" "_AdmDate_" "_AdmLoc_" "_AdmDoc_" "_PatDiag
	..s ListData=EpisodeID_"^"_itmLabel
	..s ^TMP("DHCST","web.DHCEMNurAddOrder","jsonPatAdmHisList",pid,h)=ListData
	.
	
	i h=0 ;w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	w "["
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMNurAddOrder","jsonPatAdmHisList",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMNurAddOrder","jsonPatAdmHisList",pid,index))
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",ListData)
	w "]"
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:	获取项目对应单位的价格
/// Input:  	itmmastid-医嘱项ID,uomId-单位ID,LocId-科室ID
/// W ##Class(web.DHCEMNurAddOrder).GetItmSpriceByUomID("9993||1","98","101")
ClassMethod GetItmSpriceByUomID(itmmastid As %String, uomId As %String, LocId As %String) As %String
{
	n (itmmastid, uomId, LocId)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmastid,"||",1),""))
    q:inci="" 0
	s bomId=$p(^INCI(inci,1),"^",10) /// 基本单位
	s HospId=""
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uomId,bomId)
	s itmprice=##Class(web.UDHCJFPRICE).GetOrderPrice("","",itmmastid,+$h,"","","","",HospId)
	s itmprice=+$p(itmprice,"^") 					   /// 医嘱项价格
	i $p(itmprice,".")="" s itmprice=0_itmprice   /// 小于0的价格前补0
	s sp=itmprice*fac
	s sp=$fn(sp,"",2)
    //s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId,"G","")
    //I UomId=BUomId d
    //.S Sp=##class(web.DHCSTM.Common.AppCommon).FormatSp(sp,HospId,2,"M")
    //E  D
    //.S Sp=##class(web.DHCSTM.Common.AppCommon).FormatSp(sp,HospId,1,"M")
	Q sp
}

/// Descript:  根据医嘱项ID,获取等价单位和基本单位
/// W ##Class(web.DHCEMNurAddOrder).GetPhcUomList("1028||1")
ClassMethod GetPhcUomList(itmmastid) As %String
{
	n (itmmastid)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmastid,"||",1),""))
    Q:inci="" 0
	w "["
	s count=##Class(web.DHCEMNurAddOrder).jsonGetEqualUom(itmmastid)
	/// 输出基本单位
    s buomDesc=""
	s buomID=$p(^INCI(inci,1),"^",10)  /// 基本单位
	i buomID'="" s buomDesc=$p(^CT("UOM",buomID),"^",2)
	i count=0 D
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",buomID_"^"_buomDesc)
	E  D
	.w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",buomID_"^"_buomDesc)
	w "]"
	q ""
}

/// Descript:  获取等效单位
ClassMethod jsonGetEqualUom(itmmastid) As %String
{
	n (itmmastid)
	s arcimm=$P(itmmastid,"||",1)
	Q:arcimm="" 0
	s arcims=$P(itmmastid,"||",2)
	Q:arcims="" 0
	Q:'$D(^ARCIM(arcimm,arcims,1)) ""
	s phcdf=$P(^ARCIM(arcimm,arcims,1),"^",12)
	s phc=$P(phcdf,"||",1)
	Q:phc="" 0
	s formsub=$P(phcdf,"||",2)
	Q:formsub="" 0
	s count=0
	s eqsub="0"
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) Q:eqsub=""  D
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.s equom=$P(^CT("UOM",equomdr),"^",2)
	.s eqqty=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量
	.s count=count+1
	.i count=1 D
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",equomdr_"^"_equom)
	.E  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",equomdr_"^"_equom)
	
	Q count
}

/// Descript:  根据医嘱项ID,获取基本单位和入库单位
/// W ##Class(web.DHCEMNurAddOrder).GetArcUomList("1028||1")
ClassMethod GetArcUomList(itmmastid) As %String
{
	n (itmmastid)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmastid,"||",1),""))
    q:inci="" ""
    s buomDesc="",puomDesc=""
	s buomID=$p(^INCI(inci,1),"^",10)  /// 基本单位
	i buomID'="" s buomDesc=$p(^CT("UOM",buomID),"^",2)
	s puomID=$p(^INCI(inci,3),"^",6)   /// 入库单位
	i puomID'="" s puomDesc=$p(^CT("UOM",puomID),"^",2) //hxy 2016-12-27
	
	w "["
	w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",buomID_"^"_buomDesc)
	i buomID'=puomID D 
	.w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",puomID_"^"_puomDesc)
	w "]"
	q ""
}

/// Creator:     huaxiaoying 参照web.DHCDocOrderCommon GetBillUOMStr
/// CreateDate:  2016-12-28
/// Descript:取协议包装单位,医嘱项上为维护的计价单位排在最后
/// w ##class(web.DHCEMNurAddOrder).GetBillUOMList("1034||1")     // 13159||1,192
ClassMethod GetBillUOMList(ArcimRowid As %String)
{
 
    w "["  
	s BillUOMStr=""
	s LocRowid=100 ;%session.Get("LOGON.CTLOCID")
	// 协议包装单位
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
	if (INCIRowid'="")&&(LocRowid'="")  d
	.s ChildSub=$o(^INCI("IL_LOC",LocRowid,INCIRowid,0))
	.s INCILocRowid=INCIRowid_"||"_ChildSub
	.s Rowid=0
	.f  s Rowid=$o(^DHCILDU(0,"INCIL",INCILocRowid,Rowid)) q:Rowid=""  d
	..s DispUomDR=$p($g(^DHCILDU(Rowid)),"^",1)
	..s ActiveFlag=$p($g(^DHCILDU(Rowid)),"^",2) ;激活标志
	..Q:ActiveFlag'="Y"
	..s StDate=$p($g(^DHCILDU(Rowid)),"^",3) ;有效日期
	..Q:(StDate'="")&&(StDate>+$H)
	..s EnDate=$p($g(^DHCILDU(Rowid)),"^",4)
	..Q:(EnDate'="")&&(EnDate<+$H)
	..s DispUomDesc=$p($g(^CT("UOM",DispUomDR)),"^",2)
	..s DispUomStr=DispUomDR_$C(1)_DispUomDesc
	..;i BillUOMStr="" s BillUOMStr=DispUomStr
	..;e  i ($C(2)_BillUOMStr_$C(2))'[($C(2)_DispUomStr_$C(2)) s BillUOMStr=BillUOMStr_$C(2)_DispUomStr
	..i BillUOMStr="" s BillUOMStr=##class(web.DHCAPPJsonCommon).getJsonData("value^text",DispUomDR_"^"_DispUomDesc) 
	..e  i ($C(2)_BillUOMStr_$C(2))'[($C(2)_DispUomStr_$C(2))  s BillUOMStr=BillUOMStr_$C(2)_","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",DispUomDR_"^"_DispUomDesc)
	
	// 计价单位
	s ArcimBillUOMRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	q:ArcimBillUOMRowid="" BillUOMStr
	s ArcimBillUOMDesc=$p($g(^CT("UOM",ArcimBillUOMRowid)),"^",2)
	s ArcimBillUOMStr=ArcimBillUOMRowid_$C(1)_ArcimBillUOMDesc
	;i BillUOMStr="" s BillUOMStr=ArcimBillUOMStr
	;e  s BillUOMStr=BillUOMStr_$C(2)_ArcimBillUOMStr
	i BillUOMStr="" s BillUOMStr=##class(web.DHCAPPJsonCommon).getJsonData("value^text",ArcimBillUOMRowid_"^"_ArcimBillUOMDesc)
	e  s BillUOMStr=BillUOMStr_$C(2)_","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",ArcimBillUOMRowid_"^"_ArcimBillUOMDesc)
	w BillUOMStr
	
	w "]"
	q ""
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCEM("EMNurAddOrder"))
}

/// Descript:   k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItems",pid)
	k ^TMP("DHCST","web.DHCEMNurAddOrder","jsonPatAdmHisList",pid)
	k ^TMP("DHCST","web.DHCEMNurAddOrder","QueryPatOrderItmsByLoc",pid)
	q ""
}

/// Description: 护士补录医嘱 长/临
/// Creator:     huaxiaoying
/// CreateDate:  2016-10-27
/// Table: 		 OEC_Priority
/// Input:  	 
/// Return： 	 下拉data
/// W ##Class(web.DHCEMNurAddOrder).ListOECPriority()
ClassMethod ListOECPriority(priorCode)
{
	n (priorCode)
	s count=0
	w "["
	s rowid=""
	f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
	.q:rowid=0
	.s code=$p(^OECPR(rowid),"^",1)
	.Q:(priorCode'="")&(priorCode'=code)
	.s desc=$p(^OECPR(rowid),"^",2) 
	.q:(desc'="长期医嘱")&(desc'="临时医嘱")
	.s tmp=rowid_"^"_desc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 护士补录医嘱server width
/// Creator:     hxy
/// CreateDate:  2016-12-23
/// W ##Class(web.DHCEMNurAddOrder).getWidth()
ClassMethod getWidth(myWidth As %String)
{
	n (myWidth)
	s ^TMP("DHCEM","web.DHCEMNurAddOrder","getWidth")=myWidth
	q ""
}

/// 修改模板
ClassMethod PrefEditItem(EditType As %String, objectType As %String, CONTEXT As %String, SelectPosition As %String, OldOrderType As %String, OldItemID As %String, NewOrderType As %String, NewItemID As %String) As %String
{
	s ^tan("PrefEditItem",1)=EditType_","_objectType_","_CONTEXT_","_SelectPosition_","_OldOrderType_","_OldItemID_","_NewOrderType_","_NewItemID
	s PrefType=""
	if objectType="User.SSUser" {
		s PrefType=##class(epr.PreferencesQuery).GetPrefTypeByLoc(%session.Data("LOGON.CTLOCID"))
		s objectReference=%session.Data("LOGON.USERID")
	}
	if objectType="User.CTLoc" s objectReference=%session.Data("LOGON.CTLOCID")
	if objectType="User.CTHospital" s objectReference=%session.Data("LOGON.HOSPID")
	
	s appKey="ORDER"_CONTEXT_PrefType
	s appSubKey="OEOrder.PrefTabs.EditList"
	
	s myPrefRowID=$O(^websys.PreferencesI("Index",objectType,objectReference,appKey,appSubKey,0))
	i (myPrefRowID=""){
		s appKey="ORDER"_PrefType
		s myPrefRowID=$O(^websys.PreferencesI("Index",objectType,objectReference,appKey,appSubKey,0))
	}
	//s ^tan("PrefEditItem")=objectType_","_objectReference_","_appKey_","_appSubKey_","_myPrefRowID_","_CONTEXT
	if myPrefRowID="" {
		q "-1^查找不到模板索引"
	}
	s ^tan("PrefEditItem",2)=myPrefRowID
	s objPref=##class(websys.Preferences).%OpenId(myPrefRowID)
	s Data = objPref.Data
	s myData = $lg(Data,3)
	s ^tan("PrefEditItem",3)=myData
	s lstcnt=$P(SelectPosition,"Z",1)
	s tabidx=$P(SelectPosition,"Z",2)
	//lstcnt+"Z"+tabidx
	s SelTabData=$lg(myData,tabidx+1)
	s ^tan("PrefEditItem",4)=SelTabData
	s SelListData=$p(SelTabData,$c(1),lstcnt+2)
	s ^tan("PrefEditItem",5)=SelListData
	
	if (EditType="edit") {
		s SelListData=$replace(SelListData,OldOrderType_$c(4)_OldItemID,NewOrderType_$c(4)_NewItemID)
	}elseif (EditType="add"){
		s SelListData=SelListData_$c(28)_NewOrderType_$c(4)_NewItemID
	}elseif(EditType="remove") {
		s SelListData=$replace(SelListData,$c(28)_OldOrderType_$c(4)_OldItemID,"")
	}
	
	s $p(SelTabData,$c(1),lstcnt+2)=SelListData
	s $list(myData,tabidx+1)=SelTabData
	s $list(Data,3) = myData
	s objPref.Data=Data
	set sc=objPref.%Save()
	d objPref.%Close()
	s ^tan("PrefEditItem",6)=myData
	q sc
}

/// Descript:   开医嘱的医护人员类型
/// w ##Class(web.DHCEMNurAddOrder).GetCarPrvTp("67")
ClassMethod GetCarPrvTp(CareProvID As %String) As %String
{
	n (CareProvID)
	Q:CareProvID="" ""
	Q:'$d(^CTPCP(CareProvID,1)) ""
	s CarPrvTpID=$p(^CTPCP(CareProvID,1),"^",4)  /// 医护人员类型ID
	Q:'$d(^CT("CPT",CarPrvTpID)) ""
	s CarPrvTp=$p(^CT("CPT",CarPrvTpID),"^",4)
	Q CarPrvTp
}

/// 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// 病人医嘱信息
/// W ##Class(web.DHCEMNurAddOrder).GetPatOeoriInfo("26830","30152||3")
ClassMethod GetPatOeoriInfo(EpisodeID As %String, oeori As %String) As %String
{
	n (EpisodeID, oeori)
	s BillTypeRowid=$P(^PAADM(EpisodeID,1),"^",7)  /// 费别指针
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	s SeqNo=$p($g(^OEORD(ord,"I",itm,3)),"^",4)	  /// OEORI_SeqNo
	s arcimid=$p($g(^OEORD(ord,"I",itm,1)),"^",2) /// OEORI_ItmMast_DR
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s itemCatID=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",10) /// 医嘱子类ID 
	s PriorID=$p($g(^OEORD(ord,"I",itm,1)),"^",8)   /// OEORI_Priority_DR
	q:PriorID="" ""  								/// 床位费和诊疗费没有医嘱优先级,也不需要显示
	s Prior=$p($g(^OECPR(PriorID)),"^",2)           ///医嘱优先级 
	s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  /// 医嘱项代码
	s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  /// 医嘱项名称
	s OrderType=$P(^ARC("IC",itemCatID),"^",7)  	       /// 医嘱子类类型
	s StartDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)   /// 开始日期
	i StartDate'="" s StartDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(StartDate) //$zd(StartDate,3)
	s StartTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)  /// 开始时间
	i StartTime'="" s StartTime=$zt(StartTime,1)
	s FreqDesc=""
	s FreqRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",4)    /// 频次
	i FreqRowid'="" s FreqDesc=$p($g(^PHCFR(FreqRowid)),"^",3)
	s InstrDesc=""
	s InstrRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",7)	 /// 用法
	i InstrRowid'="" s InstrDesc=$p($g(^PHCIN(InstrRowid)),"^",2)
	s DurDesc=""
	s DurRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",6)      /// 疗程
	i DurRowid'="" s DurDesc=$p($g(^PHCDU(DurRowid)),"^",3)
	s bQty=$p($g(^OEORD(ord,"I",itm,2)),"^",1)	        /// 剂量
	s buomDesc=""
	s buomID=$p($g(^OEORD(ord,"I",itm,2)),"^",3)         /// 剂量单位
	i buomID'="" s buomDesc=$p($g(^CT("UOM",buomID)),"^",2)	/// 剂量单位
	s recLocDesc=""
	s recLocID=$p($g(^OEORD(ord,"I",itm,3)),"^",6)          /// 默认接收科室
	i recLocID'="" s recLocDesc=$p(^CTLOC(recLocID),"^",2)
	s arcitmprice=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcimid,+$h,"","","","")
	s arcitmprice=+$p(arcitmprice,"^") 					    /// 医嘱项价格
	i $p(arcitmprice,".")="" s arcitmprice=0_arcitmprice    /// 小于0的价格前补0
	s pQty=$p($g(^OEORD(ord,"I",itm,9)),"^",4)
	s billuomDesc="",billuomID=""
	s billuomID=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)  /// 计价单位
	i billuomID'="" s billuomDesc=$p(^CT("UOM",billuomID),"^",2)
	s PhcfDr=""
	s PhcDrgFormId=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",12)
	i PhcDrgFormId'="" D
	.s PhcfStr=..GetFormByPhcdf(PhcDrgFormId) 			   /// 剂型
	.s PhcfDr=$p(PhcfStr,"^",3)
	
	s ListData=arcimid_"^"_arcitmcode_"^"_arcitmdesc_"^"_OrderType_"^"_PriorID_"^"_Prior_"^"_StartDate_"^"_StartTime_"^"_BillTypeRowid
	s ListData=ListData_"^"_PhcfDr_"^"_FreqRowid_"^"_FreqDesc_"^"_DurRowid_"^"_DurDesc_"^"_InstrRowid_"^"_InstrDesc_"^"_bQty
	s ListData=ListData_"^"_buomID_"^"_buomDesc_"^"_arcitmprice_"^"_recLocID_"^"_recLocDesc_"^"_pQty_"^"_billuomID_"^"_billuomDesc
	s ListTitle="arcitemId^arcitmcode^arcitmdesc^OrderType^ItmPriorID^ItmPrior^OrderStartDate^OrderStartTime^BillTypeRowid^DrgFormID^FreqRowid^FreqDesc^DurRowid^DurDesc^InstrRowid^InstrDesc^bQty^buomID^buomDesc^arcitmprice^recLocID^recLocDesc^pQty^billuomID^billuomDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript:	根据PHC_DrgForm的ID取剂型代码和描述
/// Creater:	bianshuai
/// CreateDate:	2017-01-09
/// Input:		PhcdfDr-PHC_DrgForm的ID
/// Output:		Return
/// Return：	剂型代码^描述
ClassMethod GetFormByPhcdf(PhcdfDr)
{
 N (PhcdfDr)
 Q:PhcdfDr="" ""
 S Phcd=$P(PhcdfDr,"||",1)
 S DfSub=$P(PhcdfDr,"||",2)
 Q:Phcd="" ""
 Q:DfSub="" ""
 Q:'$D(^PHCD(Phcd,"DF",DfSub)) ""
 S PhcfDr=$P(^PHCD(Phcd,"DF",DfSub,1),"^",1)
 Q:PhcfDr="" ""
 Q:'$D(^PHCF(PhcfDr)) ""
 S PhcfCode=$P(^PHCF(PhcfDr),"^",1)
 S PhcfDesc=$P(^PHCF(PhcfDr),"^",2)
 Q PhcfCode_"^"_PhcfDesc_"^"_PhcfDr
}

/// Descript: 重新计算大包装数量
ClassMethod GetPackQty(ListData As %String) As %String
{
	n (ListData)
	s dosQty=$p(ListData,"^",1)     /// 剂量
	s dosUomID=$p(ListData,"^",2)   /// 剂量单位
	s FreqID=$p(ListData,"^",3)     /// 频次
	s DurID=$p(ListData,"^",4)      /// 疗程
	s puomID=$p(ListData,"^",5)     /// 整包装单位
	s FreqFac=1,DurFac=1
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puomID,dosUomID)
	i FreqID'="" s FreqFac=$p(^PHCFR(FreqID),"^",2) /// 频次系数
	i DurID'="" s DurFac=$p(^PHCDU(DurID),"^",2)    /// 疗程系数
	s packQty=(dosQty*FreqFac*DurFac)/fac
	i packQty["." s packQty=$fn(packQty,"",0)+1
	Q packQty
}

/// Descript:  获取His系统维护日期格式
/// W ##Class(web.DHCEMNurAddOrder).GetSysDateToHtml("1988-03-08")
ClassMethod GetSysDateToHtml(HtDate As %String) As %String
{
	n (HtDate)
	Q:HtDate="" ""
	/// 转换输入日期格式为系统存储格式
	s HtDate=##Class(web.DHCEMCommonUtil).DateHtmlToLogical(HtDate)
	Q:HtDate="" ""
	/// Demo配置的日期格式
	s HtDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(HtDate)
	Q HtDate
}

/// Creator:     bianshuai
/// CreateDate:  2016-10-25
/// Descript:	 护士可补录医嘱列表
/// W ##Class(web.DHCEMNurAddOrder).JsonQryOrderTemp("600","184","63","User.CTLoc","2","88")
ClassMethod JsonQryOrderTemp(LgUserID As %String, LgGroupID As %String, LgLocID As %String, ObjectType As %String, HospID As %String, EpisodeID As %String) As %String
{
	n (LgUserID, LgGroupID, LgLocID, ObjectType, HospID, EpisodeID)
	s count = 0, total = 0
 	s result1=##Class(%Library.ResultSet).%New("DHCDoc.OPDoc.OrderTemplateCommmon:GetOEPrefTabsTrees")
 	s sc=result1.Execute(LgUserID, LgGroupID, LgLocID, "WNewOrderEntry", ObjectType, HospID, "", "DHCHEALTH", EpisodeID)
 	i $$$ISERR(sc) Q ""
    s colNum=result1.GetColumnCount() //列数
    
    s del=""""
 	W "["
	While(result1.Next())
	{
		s quitflag=0
		s ret=""
		F i=1:1:colNum D
		.s resValue=##Class(ext.util.String).EvalJSON($P(result1.%GetData(i),$C(13,10)))
		.i ret="" s ret=del_result1.GetColumnName(i)_del_":"_del_resValue_del
		.e   s ret=ret_","_del_result1.GetColumnName(i)_del_":"_del_resValue_del
		.i (result1.GetColumnName(i)="eleid")&(resValue="") s quitflag=1
		.
		Continue:quitflag=1
		s count = count+1
		i count=1 W "{"_ret_"}"
		e  W ",{"_ret_"}"
	 }	 
	 W "]"
	 D result1.Close()
	 Q ""
}

/// Creator:     bianshuai
/// CreateDate:  2017-03-23
/// Descript:	 医嘱模板列表
/// W ##Class(web.DHCEMNurAddOrder).JsonQryOrderTempCov("600","1","2","2")
ClassMethod JsonQryOrderTempCov(LgUserID As %String, LgLocID As %String, search As %String, LgHospID As %String, Conditiones As %String = "") As %String
{
	n (LgUserID, LgLocID, search, LgHospID, Conditiones)

	s count = 0, total = 0
 	s result1=##Class(%Library.ResultSet).%New("web.DHCEMNurAddOrder:FindUserOrderSet")
 	s sc=result1.Execute(LgUserID, LgLocID, "", "", "", Conditiones, "", "", "", search, "", LgHospID)
 	i $$$ISERR(sc) Q ""
    s colNum=result1.GetColumnCount() //列数
    
    s del=""""
 	W "["
	While(result1.Next())
	{ 
		s ret=""
		F i=1:1:colNum D
		.Q:(result1.GetColumnName(i)'="id")&(result1.GetColumnName(i)'="text")
		.s resValue=##Class(ext.util.String).EvalJSON($P(result1.%GetData(i),$C(13,10)))
		.i ret="" s ret=del_"value"_del_":"_del_resValue_del
		.e   s ret=ret_","_del_"text"_del_":"_del_resValue_del
		s count = count+1
		i count=1 W "{"_ret_"}"
		e  W ",{"_ret_"}"
	 }	 
	 W "]"
	 D result1.Close()
	 Q ""
}

Query FindUserOrderSet(UserID As %String, CTLOCROWID As %String, ForQueryUserID As %String, ForQueryLocID As %String, status As %String, Conditiones As %String, DocMedUnit As %String, subCatID As %String, Code As %String, Desc As %String, Alias As %String, LogonHospID As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "id:%String,ARCOSCode:%String,text:%String,ARCOSOrdCat:%String,ARCOSOrdSubCat:%String,ARCOSEffDateFrom:%String,ARCOSOrdCatDR:%String,ARCOSOrdSubCatDR:%String,FavRowid:%String,ARCOSAlias:%String,FavUserDesc:%String,FavDepDesc:%String,FavUserDr:%String,FavDepDr:%String,MedUnit:%String,MedUnitDesc:%String,OrdSetPrice:%String")
{
}

ClassMethod FindUserOrderSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserOrderSetExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCUserFavItems","FindUserOrderSet","37")
ClassMethod FindUserOrderSetExecute(ByRef qHandle As %Binary, UserID As %String, CTLOCROWID As %String, ForQueryUserID As %String, ForQueryLocID As %String, status As %String, Conditiones As %String, DocMedUnit As %String, subCatID As %String, Code As %String, Desc As %String, Alias As %String, LogonHospID As %String) As %Status
{
	s Code=$ZCVT(Code,"U")
	s Desc=$ZCVT(Desc,"U")
	s Alias=$ZCVT(Alias,"U")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	//i Desc="" Quit $$$OK
	s FavUserList=ForQueryUserID  s FavDepList=ForQueryLocID 
	s FavRowid="",FavRowidOut="",FavItemRowid="",FavUserDr="",FavUserDesc="",FavDepDesc=""
	s ARCOSRowid="",ARCOSCode="",ARCOSDesc="",ARCOSOrdCat=""
	s ARCOSOrdSubCat="",ARCOSEffDateFrom="",ARCOSOrdCatDR=""
	s ARCOSOrdSubCatDR="",FavRowid="",ARCOSAlias=""
	s UserNumber=$p(^SSU("SSUSR",UserID),"^",1)
	set RowCount=0
	s NO=0
	&SQL(DECLARE EmpCursor CURSOR FOR
	Select ARCOS_Rowid,ARCOS_Code,ARCOS_Desc,ARCOS_OrdCat_DR->ORCAT_Desc,
		ARCOS_OrdSubCat_DR->ARCIC_Desc,ARCOS_EffDateFrom,ARCOS_OrdCat_DR,
		ARCOS_OrdSubCat_DR,Fav_Rowid ,SQLUser.DHC_UserFavItems.Fav_User_Dr,SQLUser.DHC_UserFavItems.Fav_ItemRowid,
		SQLUser.DHC_UserFavItems.Fav_Dep_Dr,SQLUser.DHC_UserFavItems.Fav_MedUnit_Dr
	into :ARCOSRowid,:ARCOSCode,:ARCOSDesc,:ARCOSOrdCat,:ARCOSOrdSubCat,
		:ARCOSEffDateFrom,:ARCOSOrdCatDR,:ARCOSOrdSubCatDR,:FavRowid,:FavUserDr,:FavItemRowid,
		:FavDepDr,:FavMedUnitDr
	From SQLUser.ARC_OrdSets,SQLUser.DHC_UserFavItems 
	Where 
	SQLUser.ARC_OrdSets.ARCOS_Rowid=SQLUser.DHC_UserFavItems.Fav_ItemRowid
	order by ARCOS_Rowid desc) 
	&SQL(OPEN EmpCursor)
	for  &SQL(FETCH EmpCursor) QUIT:SQLCODE  do
	.//if (Conditiones="") q
	.//s MedUnit=FavMedUnitDr  //组ID
	.//Q:((FavUserDr'=UserID)||(FavMedUnitDr'=""))&((FavDepDr'=CTLOCROWID)||(FavDepDr="")||(FavDepDr=0))
	.Q:((FavUserDr'=UserID)&(FavUserDr'=""))||((FavDepDr'=CTLOCROWID)&(+FavDepDr'=0))
	.//个人
	.//if (Conditiones="1") q:(FavUserDr'=UserID)||(FavMedUnitDr'="")
	.//科室
	.//if (Conditiones="2") q:(FavDepDr'=CTLOCROWID)||(FavDepDr="")||(FavDepDr=0)
	.//if (Conditiones="3") q:FavUserDr'=""
	.//if (Conditiones="3") q:FavDepDr'=""
	.//if (Conditiones="3") q:FavMedUnitDr'=""
	.//if (Conditiones="4") q:(FavMedUnitDr'=DocMedUnit)
	.s MedUnitDesc=""
	.if (FavMedUnitDr'="")  s MedUnitDesc=##Class(web.DHCUserFavItems).GetMedUnitDesc(FavMedUnitDr) //组描述
	.s ARCOSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",ARCOSRowid,0))
	.if ARCOSAliasRowid'="" d 
	..s ARCOSAlias=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",6)
	.//if (FavItemRowid=ARCOSRowid) d
	..s FavRowidOut=FavRowid
	.IF FavUserDr'="" s FavUserDesc=$p($g(^SSU("SSUSR",FavUserDr)),"^",2)
	.if FavDepDr'="" s FavDepDesc=$p($g(^CTLOC(FavDepDr)),"^",2)
	.q:(subCatID'="")&&((ARCOSOrdSubCat'=subCatID)&&(ARCOSOrdSubCatDR'=subCatID))
	.q:(Code'="")&&($ZCVT(ARCOSCode,"U")'[Code)
	.q:(Desc'="")&&($ZCVT(ARCOSDesc,"U")'[Desc)
	.q:(Alias'="")&&($ZCVT(ARCOSAlias,"U")'[Alias)
	.s OrdSetPrice="包装价格"
	.Do OutputRow2
	.do ResetVariables2
	&SQL(Close EmpCursor)
	s Conditiones=""
	s ARCOSRowid=""
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat,ARCOSEffDateFrom,ARCOSOrdCatDR,ARCOSOrdSubCatDR,FavRowid,ARCOSAlias,FavUserDesc,FavDepDesc,FavUserDr,FavDepDr,MedUnit,MedUnitDesc,OrdSetPrice)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
ResetVariables2
	set (ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat,ARCOSEffDateFrom,ARCOSOrdCatDR,ARCOSOrdSubCatDR,FavRowid,ARCOSAlias,FavUserDesc,FavDepDesc,FavUserDr,FavDepDr,MedUnit,MedUnitDesc)=""
	Quit
}

ClassMethod FindUserOrderSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserOrderSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
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

/// Creator:     bianshuai
/// CreateDate:  2017-03-23
/// Descript:	 医嘱模板明细列表
/// W ##Class(web.DHCEMNurAddOrder).JsonQryOrderTempCovDet("2264","2")
ClassMethod JsonQryOrderTempCovDet(ID As %String, LgHospID As %String, EpisodeID As %String) As %String
{
	n (ID, LgHospID, EpisodeID)
	s count = 0, total = 0
 	s result1=##Class(%Library.ResultSet).%New("web.DHCDocOrderCommon:FindOSItems")
 	s sc=result1.Execute(ID, LgHospID, EpisodeID)
 	i $$$ISERR(sc) Q ""
    s colNum=result1.GetColumnCount() //列数
    
    s del=""""
 	W "["
	While(result1.Next())
	{ 
		s ret=""
		F i=1:1:colNum D
		.s ColumnName=result1.GetColumnName(i)
		.Q:(ColumnName'="Item")&(ColumnName'="ItemRowid")&(ColumnName'="ItemQty")&(ColumnName'="ItemBillUOM")
		.s resValue=##Class(ext.util.String).EvalJSON($P(result1.%GetData(i),$C(13,10)))
		.i ret="" s ret=del_ColumnName_del_":"_del_resValue_del
		.e   s ret=ret_","_del_ColumnName_del_":"_del_resValue_del
		.i ColumnName="ItemBillUOM" D
		..s resValue=..GetUomID(resValue)
		..i ret="" s ret=del_"ItemBillUomID"_del_":"_del_resValue_del
		..e   s ret=ret_","_del_"ItemBillUomID"_del_":"_del_resValue_del
		s count = count+1
		i count=1 W "{"_ret_"}"
		e  W ",{"_ret_"}"
	 }	 
	 W "]"
	 D result1.Close()
	 Q ""
}

/// Descript:  获取单位的ID
/// W ##Class(web.DHCEMNurAddOrder).GetUomID("瓶[100片]")
ClassMethod GetUomID(uomDesc As %String) As %String
{
	n (uomDesc)
	//s uomID=$o(^CT("UOM",0,"Desc",$$ALPHAUP^SSUTIL4(uomDesc),""))
	s uomID=$o(^CT("UOM",0,"Desc",uomDesc,""))
	Q uomID
}

/// Descript:  开医嘱时判断是否有可用库存
/// W ##Class(web.DHCEMNurAddOrder).GetAvaQtyByArc("1338||1","100","1","116")
ClassMethod GetAvaQtyByArc(arcitmid As %String, recLoc As %String, bQty As %String, uomID As %String) As %String
{
	n (arcitmid, recLoc, bQty, uomID)
	Q:..ChkWoStock(arcitmid)=1 1
	s fac=1
	s inci=$o(^INCI(0,"ARCIM_DR",+arcitmid,""))
	Q:inci="" 1
	s bomId=$p(^INCI(inci,1),"^",10) /// 基本单位
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uomID,bomId)
	s bQty=bQty*fac
	s ret=##Class(web.DHCSTINTERFACE).GetAvailQtyByArc(arcitmid , recLoc, bQty, 1)
	s:ret<0 ret=0
	Q ret
}

/// Creator:	bianshuai
/// CreatDate:	2012-04-13
/// Table:		Arc_ItmMast
/// Input:		医嘱项ID
/// Descript:   判断医嘱是否是无库存医嘱
/// Return:		1-是无库存医嘱,0-不是无库存医嘱
ClassMethod ChkWoStock(ArcimID As %String) As %String
{
	n (ArcimID)
	s ArcimSub=$p(ArcimID,"||",1)
	s ArcimVer=$p(ArcimID,"||",2)
	q:(ArcimSub="")!(ArcimVer="") 1
	s WoFlag=0
	s WoStock=$p($g(^ARCIM(ArcimSub,ArcimVer,8)),"^",11)
	i WoStock="Y" s WoFlag=1
	q WoFlag
}

/// Descript:  获取病人的默认费别
/// W ##Class(web.DHCEMNurAddOrder).GetPatDefualtBillType("O","2")
ClassMethod GetPatDefualtBillType(PatType As %String, EpisodeID As %String) As %String
{
	n (PatType, EpisodeID)
	s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)   /// 费别指针
	s TempListData=""
	s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM("O",BillTypeID)
	s Len=$L(PrescriptTypes,"||")
	s ListData=""
	F i=1:1:Len Q:ListData'=""  D
	.s BillTypeList=$p(PrescriptTypes,"||",i)
	.s BillTypeID=$p(BillTypeList,"!",5)
	.s BillType=$p(BillTypeList,"!",3)
	.i i=1 s TempListData=BillTypeID_"^"_BillType
	.Q:$p(BillTypeList,"!",8)'="Y"
	.s ListData=BillTypeID_"^"_BillType
	.
	i ListData="" s ListData=TempListData
	//w "["
	//w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData)
	//w "]"
	Q ListData
}

/// Descript:  获取病人对应费别列表
/// W ##Class(web.DHCEMNurAddOrder).jsonGetPatBillType("E","2")
ClassMethod jsonGetPatBillType(PatType As %String, EpisodeID As %String) As %String
{
	n (PatType, EpisodeID)
	s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)   /// 费别指针
	s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM("O",BillTypeID)
	s Len=$L(PrescriptTypes,"||")
	s count = 0
	w "["
	F i=1:1:Len D
	.s BillTypeList=$p(PrescriptTypes,"||",i)
	.s BillTypeID=$p(BillTypeList,"!",5)
	.s BillType=$p(BillTypeList,"!",3)
	.s tmp=BillTypeID_"^"_BillType
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	Q ""
}

/// Descript:  保存前设置医嘱的开始日期和开始时间
ClassMethod dealInsListData(EpisodeID As %String, mListData As %String) As %String
{
	n (EpisodeID, mListData)
	s StartDate=$zd(+$h,4)						   /// 医嘱日期
	s StartTime=$zt($p($h,",",2),2)			       /// 医嘱时间
	s EsDischgDate=$p(^PAADM(EpisodeID),"^",59)	   /// 出院日期
	s EsDischgTime=$p(^PAADM(EpisodeID),"^",60)    /// 出院时间
	i EsDischgDate'="" s StartDate=$zd(EsDischgDate,4)	
	i EsDischgTime'="" s StartTime=$zt(EsDischgTime,2)
	s TmpListData=""
	s Len=$L(mListData,"&&")
	f i=1:1:Len  d
	.s mdata=$p(mListData,"&&",i)
	.s $p(mdata,"^",4)=StartDate  /// 医嘱开始日期
	.s $p(mdata,"^",5)=StartTime  /// 医嘱开始时间
	.i TmpListData="" s TmpListData=mdata
	.E  s TmpListData=TmpListData_"&&"_mdata
	Q TmpListData
}

/// Descript:  库存锁定检查
/// W ##Class(web.DHCEMNurAddOrder).GetStkLockFlag("22||1","311")
ClassMethod GetStkLockFlag(arcitmid As %String, recLoc As %String) As %String
{
	n (arcitmid, recLoc)
	s inci=$o(^INCI(0,"ARCIM_DR",+arcitmid,""))
	Q:inci="" ""
	s IL=$o(^INCI("IL_LOC",recLoc,inci,""))
	Q:IL="" ""
	s ID=$o(^DHCINCIL(0,"INCIL",inci_"||"_IL,""))
	Q:ID="" ""
	s LockFlag=$p(^DHCINCIL(ID),"^",1)
	Q LockFlag
}

/// Creator:    bianshuai
/// CreateDate: 2017-02-25
/// Descript:   取病人预检号别信息【24小时内的号别】
/// InPut:      就诊ID
/// OutPut:     座位号
/// w ##Class(web.DHCEMNurAddOrder).GetPatSeatNo("4640")
ClassMethod GetPatSeatNo(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s SeatInfo = ##class(web.DHCEMPatientSeat).GetPatSeatNo("",EpisodeID)
	q:+SeatInfo=0 ""
	s PatSeat=" ("_$p(SeatInfo,"!!",2)_")"
	Q PatSeat
}

}
