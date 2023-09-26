Import sqluser

/// Creator: 		bianshuai 
/// CreateDate: 	2020-03-13
/// Descript: 		His业务数据导出用于知识库测试
Class web.DHCCKBHisBusiExpBack Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:   	His业务数据导出
/// InPut:      	
/// OutPut:     	0-成功，其他-失败
/// w ##Class(web.DHCCKBHisBusiExp).HisBusiExp("2018-01-01","2020-01-01")
ClassMethod HisBusiExp(startDate As %String, endDate As %String, TmpArr As %String) As %String
{
	n (startDate, endDate, TmpArr)
	
	s startDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(endDate)
    s Num=0
	F Date=startDate:1:endDate D
	.s Time=""
	.F  s Time=$o(^PAADM("PAADM_DateTime",Date,Time)) Q:Time=""  D
	..s EpisodeID=""
	..F  s EpisodeID=$o(^PAADM("PAADM_DateTime",Date,Time,EpisodeID)) Q:EpisodeID=""  D
	...s PatEssInfo=..GetPatEssInfo(EpisodeID) /// 病人信息
	...D ..GetOrderInfo(EpisodeID, .TmpArr)    /// 医嘱信息
	...s index=""
	...F  s index=$o(TmpArr(index)) Q:index=""  D
	....s TmpArr(index)=PatEssInfo_"^"_$g(TmpArr(index))
	...

	Q ""
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:   	病人信息
/// InPut:      	
/// OutPut:     	
/// w ##Class(web.DHCCKBHisBusiExp).GetPatEssInfo("")
ClassMethod GetPatEssInfo(EpisodeID As %String) As %String
{
	n (EpisodeID)
	
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	s PatDiag=##class(web.DHCCKBHisBusiExp).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s PatType=$s(PatType="I":"住院",PatType="E":"急诊",PatType="O":"门诊",1:"")
#;	s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
#;	s BillType=##class(web.DHCDoc.OP.AjaxInterface).GetAdmReason(EpisodeID)    /// 费别
	s PatHeight=..GetPatHeight(EpisodeID) /// 身高
	s PatWeight=..GetPatWeight(EpisodeID) /// 体重
	s PatAllergy=..GetPatAllergy(PatientID) /// 过敏记录

	Q PatType_"^"_PatNo_"^"_PatAge_"^"_PatSex_"^"_PatAllergy_"^"_PatWeight_"^"_PatHeight_"^"_PatDiag
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:   	医嘱信息
/// InPut:      	
/// OutPut:     	
/// w ##Class(web.DHCCKBHisBusiExp).GetOrderInfo("")
ClassMethod GetOrderInfo(EpisodeID As %String, TmpArr) As %String
{
	n (EpisodeID, TmpArr)
	
			s ord=0
			F  s ord=$o(^OEORD(0,"Adm",EpisodeID,ord)) Q:ord=""  D
			.s itm=""
			.F  s itm=$o(^OEORD(ord,"I",itm)) Q:itm=""  D
				..//s arcimDesc=##Class(web.DHCEMOrdInfoVO).getArcimDesc(ord,itm)     /// 医嘱名称
				..s arcimDesc=##class(web.DHCCKBHisBusiExp).getArcimDesc(ord,itm)
    ..s doseQtyUnit=##Class(web.DHCEMOrdInfoVO).GetdoseQtyUnit(ord,itm) /// 医嘱的剂量
    ..s doseQty=$p(doseQtyUnit," ",1), doseUnit=$p(doseQtyUnit," ",2)
    ..s phcfrCode=##Class(web.DHCEMOrdInfoVO).getPhcfrCode(ord,itm)     /// 频次
    ..s phOrdQtyUnit=##Class(web.DHCEMOrdInfoVO).getPhOrdQtyUnit(ord,itm) /// 总量
    ..s phcinDesc=##Class(web.DHCEMOrdInfoVO).getPhcinDesc(ord,itm)     /// 用法
    ..s phcdurat=##Class(web.DHCEMOrdInfoVO).getDurat(ord,itm) 		    /// 疗程
    ..s spec=##Class(web.DHCCKBHisBusiExp).GetSpec(ord,itm)
    ..s form=##Class(web.DHCCKBHisBusiExp).GetDrugForm(ord,itm)         /// 剂型
    ..s buom=##Class(web.DHCCKBHisBusiExp).GetIncBuom(ord,itm)          /// 基本单位
    ..s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)               /// 处方号
    ..s OrdDate=##Class(web.DHCCKBHisBusiExp).GetOrdDate(ord_"||"_itm)  /// 开医嘱日期
    ..s specDesc=##Class(web.DHCEMOrdInfoVO).getSpecDesc(ord,itm)       /// 标本名称 
    ..s ordLocDesc=##Class(web.DHCEMOrdInfoVO).getOrdDep(ord,itm)       /// 医嘱科室
    ..s recLocDesc=##Class(web.DHCEMNurExe).getReclocDesc(ord,itm)      /// 接收科室
    ..s ordStatDesc=##Class(web.DHCEMOrdInfoVO).getOrdStatDesc(ord,itm) /// 医嘱状态
    ..s ctcpDesc=##Class(web.DHCEMOrdInfoVO).getCtcpDesc(ord,itm)       /// 取医嘱医生
    ..s seqno=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",4) /// 关联序号
    ..s dispQty=##Class(web.DHCCKBHisBusiExp).GetDispQty(ord_"||"_itm)  /// 发药数量
    ..s prescQty=##Class(web.DHCCKBHisBusiExp).GetPrescQty(ord,itm)     /// 处方上药品数量
    ..s ListData=prescno_"^"_prescQty_"^"_arcimDesc_"^"_form_"^"_spec_"^"_buom_"^"_dispQty_"^"_doseQty_"^"_doseUnit_"^"_phcfrCode_"^"_phcinDesc_"^"_phcdurat_"^"_seqno_"^"_OrdDate
	..s TmpArr(ord_"||"_itm)=ListData
	.
	Q ""
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:       检验指标
/// w ##class(web.DHCCKBHisBusiExp).JsonQryTSInfo("1","6","",0)
ClassMethod JsonQryTSInfo(ReportDR As %String, showType As %String)
{
	n (ReportDR,showType)
	
	Set result=##class(%Library.ResultSet).%New("LIS.WS.BLL.DHCRPVisitNumberReportResult:QryTSInfo")
	Set sc=result.Execute(ReportDR)
	If $$$ISERR(sc) Quit ""
	
	Set colNum=result.GetColumnCount() //列数
	Set count = 0
	Set del=""""
	Set tmp=""
	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevNotCnt=0
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$tr($P(result.%GetData(i),$C(13,10)),$c(34),"")_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$tr($P(result.%GetData(i),$C(13,10)),$c(34),"")_del
	
		s retObj = ##class(%DynamicAbstractObject).%FromJSON("{"_ret_"}")
		continue:(showType=1)&(retObj.AbFlag="")
		Set count = count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 Quit ""
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:       过敏记录
ClassMethod GetPatAllergy(PatientID As %String) As %String
{
	n (PatientID)
	s argyData=""
	s ID=""
	F  s ID=$o(^PAPER(PatientID,"ALG",ID)) Q:ID=""  D
	.s TypeID=$p(^PAPER(PatientID,"ALG",ID),"^",9)  /// 过敏源
	.s argyDesc=$p($g(^PAC("ALG",+TypeID)),"^",2)
	.i argyDesc="" s argyDesc=$p(^PAPER(PatientID,"ALG",ID),"^",2) /// 其他过敏源
	.s argyData=$s(argyData="":argyDesc,1:argyData_"^"_argyDesc)
	Q argyData
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:       发药数量
ClassMethod GetDispQty(oeori As %String) As %String
{
	n (oeori)
    s dispid=$o(^DHCOEDISQTY(0,"OEORE",oeori,""))
    Q:dispid="" ""
    s Qty=$p(^DHCOEDISQTY(dispid),"^",5)
    Q Qty
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:       处方数量
ClassMethod GetPrescQty(ord As %String, itm As %String) As %String
{
	n (ord, itm)
    s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)   /// 处方号
    s CH="", num=0
    F  s CH=$o(^OEORD(0,"PrescNo",prescno,ord,CH)) Q:CH=""  D
    .s num=num+1
    .
    Q num
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:       取医嘱开单日期
ClassMethod GetOrdDate(oeori As %String) As %String
{
   n (oeori)
   s ord=+oeori
   s itm=$p(oeori,"||",2)
   s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
   i orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate)
   Q orddate
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:   	剂型
/// InPut:      	
/// OutPut:     	
/// w ##Class(web.DHCCKBHisBusiExp).GetDrugForm("")
ClassMethod GetDrugForm(ord As %String, itm As %String) As %String
{
	n (ord, itm)
    s itmmastid=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
    Q:itmmastid="" ""
    s drgForm=""
    s drgForm=$p(^ARCIM($p(itmmastid,"||",1),$p(itmmastid,"||",2),1),"^",12)
    Q drgForm
}

/// Descript:	根据库存项ID取基本单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	基本单位ID^基本单位描述
ClassMethod GetIncBuom(ord As %String, itm As %String) As %String
{
	n (ord, itm)
	 s InciDr=..GetInci(ord, itm)
	 Q:InciDr="" ""
	 Q:'$D(^INCI(InciDr)) ""
	 S buomdr=$P(^INCI(InciDr,1),"^",10)
	 Q:buomdr="" ""
	 Q:'$D(^CT("UOM",buomdr)) ""
	 S buomdesc=$P(^CT("UOM",buomdr),"^",2)
	 Q buomdesc
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:       取患者体重
ClassMethod GetPatWeight(paadm) As %String
{
	Q:paadm="" ""
	Q:'$D(^PAADM(paadm)) ""
	S mradm=$P(^PAADM(paadm),"^",61)
	Q:mradm="" ""
	Q:'$D(^MR(mradm,"PRO",1)) ""
	S weight=$P(^MR(mradm,"PRO",1),"^",27)
	S:weight'="" weight=weight_"KG"
	Q weight
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:       取患者身高
ClassMethod GetPatHeight(paadm) As %String
{
	Q:paadm="" ""
	Q:'$D(^PAADM(paadm)) ""
	S mradm=$P(^PAADM(paadm),"^",61)
	Q:mradm="" ""
	Q:'$D(^MR(mradm,"PRO",1)) ""
	S Height=$P(^MR(mradm,"PRO",1),"^",20)
	S:Height'="" Height=Height_"CM"
	Q Height
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:   	库存项ID
/// InPut:      	
/// OutPut:     	
/// w ##Class(web.DHCCKBHisBusiExp).GetInci("")
ClassMethod GetInci(ord As %String, itm As %String) As %String
{
	n (ord, itm)
    s itmmastid=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
    Q:itmmastid="" ""
    Q $o(^INCI(0,"ARCIM_DR",+itmmastid,""))
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:       根据库存项代码或RowID取得规格
ClassMethod GetSpec(ord As %String, itm As %String) As %String
{
	n (ord, itm)
	s inci=..GetInci(ord, itm)
	Q:$g(inci)="" ""
	s spec=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	Q:add="" ""
	s spec=$p($G(^DHCITMINFO(add)),"^",27)
	Q spec
}

/// Creator:    	bianshuai
/// CreateDate: 	2020-03-13
/// Descript:       输出Excel使用的Query
/// w ##Class(websys.Query).ToExcel("CKB_Excel","web.DHCCKBHisBusiExp","QueryHisBusiExp","2017-01-01","2020-01-01")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBHisBusiExp","QueryHisBusiExp","","")
Query QueryHisBusiExp(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "类型:%String,就诊号:%String,年龄:%String,性别:%String,患者过敏信息:%String,体重:%String,身高:%String,诊断:%String,处方号:%String,药学名称:%String,处方上药品数量:%String,药学名称:%String,药品剂型:%String,规格:%String,最小包装:%String,发药数量:%String,单次剂量:%String,剂量单位:%String,频次:%String,服药途径:%String,疗程:%String,关联医嘱组号:%String,开方时间:%String")
{
}

ClassMethod QueryHisBusiExpExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	k TmpArr
	b ///AAA
	/// 准备数据
	D ##Class(web.DHCCKBHisBusiExp).HisBusiExp(StartDate, EndDate, .TmpArr)
	
	/// 输出数据
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D 
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING($g(TmpArr(index)),"^")

	Quit $$$OK
}

ClassMethod QueryHisBusiExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHisBusiExpExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryHisBusiExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHisBusiExpExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:    	qunianpeng
/// CreateDate: 	2020-07-10
/// Descript:       特殊人群
///  w ##Class(web.DHCCKBHisBusiExp).GetSpecialPerson(108)
ClassMethod GetSpecialPerson(EpisodeID As %String) As %String
{
	n (EpisodeID)
	
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	s specialistStr=$p($G(^MR(mradm,"DHC")),"^",8)  // 之前是id_$c(1)_描述 2018/3/30 标板现在从基础数据维护-》病人管理-》特殊人群维护id_$c(1)_
    s speciaListDesc=""
    if (specialistStr'=""){
      s lengSpec=$L(specialistStr,"!")
      for sub=1:1:lengSpec {
	      s subStr=$P(specialistStr,"!",sub)
	      s specID=$P(subStr,$C(1),1)
	      continue:specID=""
	      s specDesc=$p(^CT("CTSPECR",specID),"^",2)
	      i speciaListDesc="" s speciaListDesc=specDesc
	      e  s speciaListDesc=speciaListDesc_";"_specDesc
     }
   }
   q speciaListDesc
}

/// 取病人医嘱名称
/// w ##class(web.DHCCKBHisBusiExp).getArcimDesc()
ClassMethod getArcimDesc(ord As %String, itm As %String) As %String
{
				n (ord,itm)
				s arcimDesc=""
				s arcimID =$p($g(^OEORD(ord,"I",itm,1)),"^",2)
				i arcimID'="" s arcimDesc= $P($G(^ARCIM(+arcimID,$p(arcimID,"||",2),1)),"^",2)
				e  q ""
   
				q arcimDesc
}

ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String, Type As %String = "") As %String
{
	n (MRAdmRowid,DelimStr,Type)
	q:MRAdmRowid="" ""
	s MRAdmRowid=$p(^PAADM(MRAdmRowid),"^",61)
	q:MRAdmRowid="" ""
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
	.i CodeRowid'=""  d
	..s ZXFlag=$p($g(^MRC("ID",+CodeRowid)),"^",13) 	;证型标志
	..s ZYZDFlag=$p($g(^MRC("ID",+CodeRowid)),"^",15) 	;中医诊断标志
	..i ZYZDFlag'="Y" d
	...s DiagnosCat="西医"
	..e  i (ZYZDFlag="Y")&&(ZXFlag'="Y") d
	...s DiagnosCat="中医"
	..e  d
	...s DiagnosCat="证型"
	.e  d
	..//非ICD诊断
	..s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
	..s DiagnosCat=$s(Questionnaire=1:"西医",Questionnaire=2:"中医",Questionnaire=3:"证型",1:"")
	.i DiagnosCat="" s DiagnosCat="西医"
	.q:(Type="GC")&&(DiagnosCat="西医")  				;中医诊断
	.q:(Type="GX")&&(DiagnosCat'="西医")  				;西医诊断
	.q:(Type="ZX")&&(DiagnosCat'="证型")  				;证型  
	.if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	.i Desc="" d
	..s Desc=MRDesc
	.e  d
	..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	.//证型与诊断不要区分(需求810128)
	.i DiagnosCat'="证型"  d
	..//s i=i+1
	..//s Desc=i_"."_Desc
	.i retval="" d
	..s retval=Desc
	.e  d
	..s retval=$s(DiagnosCat="证型":retval_" "_Desc,1:retval_DelimStr_Desc)
	.
	d obj.Close()
	q $ZCVT($g(retval),"O","JS")
}

}
