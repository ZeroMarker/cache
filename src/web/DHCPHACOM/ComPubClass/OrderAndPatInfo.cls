Import sqluser

/// creator: 	yunhaibao
/// createdate:	2018-05-22
/// description:公共方法,仅用于获取医嘱\病人相关信息
Class web.DHCPHACOM.ComPubClass.OrderAndPatInfo Extends %RegisteredObject
{

/// description: 医嘱剂量
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriDosage("1220||380")
ClassMethod OeoriDosage(oeori As %String) As %String
{
	s ordId=+oeori
	s ordItm=+$p(oeori,"||",2)
	S doseQty=$P($g(^OEORD(ordId,"I",ordItm,2)),"^",1)
	S doseUom=$P($g(^OEORD(ordId,"I",ordItm,2)),"^",3)
	q:(+doseQty=0)||(+doseUom=0) ""
	s doseUomDesc=$P($g(^CT("UOM",+doseUom)),"^",2)
	q doseQty_doseUomDesc
}

/// description: 医嘱用法
ClassMethod OeoriInstruc(oeori As %String) As %String
{
	s instrucId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),2)),"^",7)
	q:instrucId="" ""
	s instrucDesc=$p($g(^PHCIN(instrucId)),"^",2)
	q instrucId_"^"_instrucDesc
}

/// description: 医嘱频次(药房统一调用)
/// 标库默认PHCFR_Desc1
/// 医院不同可能取法不同:PHCFR_Code	 	PHCFR_Desc1	PHCFR_Desc2
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriFreq("1791||3")
ClassMethod OeoriFreq(oeori As %String) As %String
{
	s freqId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),2)),"^",4)
	q:freqId="" ""
	s freqCode=$P($g(^PHCFR(freqId)),"^",1) // PHCFR_Code	
	s freqDesc2=$P($g(^PHCFR(freqId)),"^",4) // PHCFR_Desc2
	s freqDesc1=$P($g(^PHCFR(freqId)),"^",3)	// PHCFR_Desc1
	s freqWeek=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),"DHC")),"^",55)
	i freqWeek'="" s freqDesc1=freqDesc1_"-"_$replace(freqWeek,"|","")
	q freqId_"^"_freqCode_"^"_freqDesc1_"^"_freqDesc1
}

/// description: 医嘱疗程
ClassMethod OeoriDuration(oeori As %String) As %String
{
	s duratId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),2)),"^",6)
	q:duratId="" ""
	s durationDesc=$P($g(^PHCDU(duratId)),"^",1)
	q duratId_"^"_durationDesc
}

/// description: 开单医生
ClassMethod OeoriDoctor(oeori As %String) As %String
{
	S doctor=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",11)
	Q:doctor="" ""
	S doctorName=$P($g(^CTPCP(doctor,1)),"^",2)
	Q doctor_"^"_doctorName
}

/// description: 医嘱优先级
ClassMethod OeoriPriority(oeori As %String) As %String
{
	S priority=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",8)
	Q:priority="" ""
	S priCode=$P(^OECPR(priority),"^",1)
	S priDesc=$P(^OECPR(priority),"^",2)
	Q priority_"^"_priCode_"^"_priDesc
}

/// description: 开医嘱时间,开单时间
ClassMethod OeoriDateTime(oeori As %String) As %String
{
	q:oeori="" ""
	s oeoriDate=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),3)),"^",7)
	s oeoriDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(oeoriDate) 
	s oeoriTime=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",17)
	s oeoriTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(oeoriTime) 
	q oeoriDate_" "_oeoriTime
}

/// description: 皮试结果
/// return:		 $p(ret,"^",1)<0:皮试不合格,$p(ret,"^",1):皮试描述信息		 
/// others:		 需求可能不定,判断是否皮试不能仅根据皮试备注判断
/// 			 原液,目前原液医嘱的皮试标志为Y,但允许发药
/// 			 补充:医嘱有皮试标识，皮试备注为“皮试剂”只有皮试结果为阴性才能发药
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriSkinTest("739||1")
ClassMethod OeoriSkinTest(oeori As %String) As %String
{
	q:oeori="" ""
	s ordId=+$p(oeori,"||",1) q:ordId=0 ""
	S ordItm=+$p(oeori,"||",2) q:ordItm=0 ""
	q:'$d(^OEORD(ordId,"I",ordItm,5)) ""
	s skinTestDesc="",skinTestValue=1
	s skinTestFlag=$P($g(^OEORD(ordId,"I",ordItm,5)),"^",2)
	s actionId=$P($g(^OEORD(ordId,"I",ordItm,11)),"^",21)	// OEC_Action
	// 需要皮试
	i skinTestFlag="Y" d
	.s abNormal=$P($g(^OEORD(ordId,"I",ordItm,11)),"^",3)
	.i abNormal="N" s skinTestValue=1,skinTestDesc="(-)"
	.e  i abNormal="Y" s skinTestValue=-1,skinTestDesc="(+)"
	.e  s skinTestValue=-1,skinTestDesc="( )"
	.i actionId'="" d
	..s skinTestDesc=$p($g(^OEC("ACT",actionId)),"^",2)
	..i (skinTestDesc["原液")||((skinTestDesc["皮试剂")&&(abNormal="N")) s skinTestValue=1
	..i skinTestDesc'="" s skinTestDesc="("_skinTestDesc_")"
	e  d
	.// 皮试备注
	.i actionId'="" d
	..s skinTestDesc=$p($g(^OEC("ACT",actionId)),"^",2)
	..i skinTestDesc'="" s skinTestDesc="("_$e(skinTestDesc,1,1)_")"
	.e  s skinTestDesc=""
	q skinTestValue_"^"_skinTestDesc
}

/// description: 诊断
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).MrDiagnose("716",",")
ClassMethod MrDiagnose(admId, delim = ",")
{
	q:+admId=0 ""
	s retStr=""
	s i=0
	s mrAdmId=$p($g(^PAADM(admId)),"^",61)
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(mrAdmId)
	For  Quit:'obj.Next()  Do
	.s desc=obj.Data("MRDIAICDCodeDRDesc")
	.s id=obj.Data("ID")
	.s codeDesc=obj.Data("MRDIAICDCodeDR")
	.s mrDesc=obj.Data("MRDIADesc")
    .i mrDesc'="" s mrDesc=$LIST(mrDesc,1)
	.i desc="" s desc=mrDesc
	.e  d
	..i mrDesc'="" s desc=desc_"("_mrDesc_")"
	.q:desc=""
	.s i=i+1
	.s desc=i_"."_desc
	.if retStr="" s retStr=desc
	.e  s retStr=retStr_delim_desc
	d obj.Close()
	q retStr
}

/// description: 过敏史
ClassMethod PatAllergy(patId, delim = ",")
{
	s retStr=""
	s i=0
	s obj=##class(%ResultSet).%New("web.PAAllergy:Find")
	d obj.Execute(patId,"ALG_InActive")
	For  Quit:'obj.Next()  Do
	.s id=obj.Data("RowID")
	.s geneName=obj.Data("PHCGEName")
	.s dName=obj.Data("PHCDName")
	.s comm=$G(^PAPER(patId,"ALG",$P(id,"||",2),"CMT",1))
    .S desc=""
	.i geneName'="" S desc=geneName
	.i dName'="" d
	..I desc="" S desc=dName
	..E  S desc=desc_","_dName
	.I comm'="" D
	..I desc="" S desc=comm
	..E  S desc=desc_","_comm
	.Q:desc=""
	.s i=i+1
	.s desc=i_"."_desc
	.if retStr="" s retStr=desc
	.e  s retStr=retStr_delim_desc
	d obj.Close()
	Q retStr
}

/// description: 根据就诊Id获取床号
/// tables:		 PA_Adm,PA_AdmTransaction
/// 1.婴儿床号会变,需取转科记录
/// 2.只要离开原床位,视为空
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetAdmBedCode(4136)
/// input:		 admId(就诊Id),wardLocId(打包表DSPAdmLocDR,为空取当前床位)
/// output:		 床位Id^床位代码
ClassMethod GetAdmBedCode(admId, dspWardLocId = "")
{
	s dspWardId=$s(dspWardLocId'="":$o(^PAWARD(0,"WARD_LocationDR",dspWardLocId,"")),1:"")
	q:+admId=0 ""
	s admBedId=$p(^PAADM(admId),"^",73)
	q:admBedId="" ""
	s admWardId=$p(admBedId,"||",1)
	q:(dspWardId'="")&&(dspWardId'=admWardId) "" // 打包表记录病区与当前病区不一致时,返回空
	s bedCode=""
	s montherAdmId=$p(^PAADM(admId),"^",75) // 关联母亲就诊,不为空视为婴儿
	i montherAdmId'="" d
	.s transSub=""
	.f  s transSub = $O(^PAADM(admId,"TRANS",transSub),-1) q:(transSub="")!($g(bedId)'="")  d
	..s bedId=$p(^PAADM(admId,"TRANS",transSub),"^",8)
	..q:bedId=""
	..s bedCode=$p(^PAADM(admId,"TRANS",transSub),"^",33)
	q:(montherAdmId'="")&&(dspWardId'="")&&(+bedId'=dspWardId) ""
	q:montherAdmId'="" bedId_"^"_bedCode
	// 非婴儿保持原样
	s bedId=$p(^PAADM(admId),"^",73)
	i bedId'=""  s bedCode=$p($g(^PAWARD(+$p(bedId,"||",1),"BED",+$p(bedId,"||",2))),"^",1)
	q bedId_"^"_bedCode
}

/// description: 针对婴儿的特殊处理,婴儿床位应取转科记录中的文字
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetAdmTransBed(4136)
ClassMethod GetAdmTransBed(admId, admBedId)
{
	q:admBedId="" ""
	s transSub="",bedCode=""
	f  s transSub = $O(^PAADM(admId,"TRANS",transSub),-1) q:(transSub="")!($g(bedId)'="")  d
	.s bedId=$p(^PAADM(admId,"TRANS",transSub),"^",8)
	.q:admBedId'=bedId
	.s bedCode=$p(^PAADM(admId,"TRANS",transSub),"^",33)
	q bedCode
}

/// description: 医嘱医保类别(甲类乙类)
/// ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriInsuType()
ClassMethod OeoriInsuType(oeori As %String) As %String
{
	q ##class(PHA.COM.Order).OeoriInsuType(oeori)
}

/// description: 医嘱状态
/// ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriStat()
ClassMethod OeoriStat(oeori As %String) As %String
{
	s oeStateId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",13)
	q:oeStateId="" ""
	s oeStateCode=$P($g(^OEC("OSTAT",+oeStateId)),"^",1)
	s oeStateDesc=$P($g(^OEC("OSTAT",+oeStateId)),"^",2)
	q oeStateCode_"^"_oeStateDesc
}

/// description: 医嘱备注
/// ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriStat()
ClassMethod OeoriRemark(oeori As %String) As %String
{
	s ordId=+$p(oeori,"||",1)
	s ordItm=+$p(oeori,"||",2)
	s (num,memo)=""
	s num="0" f  s num=$o(^OEORD(ordId,"I",ordItm,"DEP",num)) q:num=""  d
	.s memo=memo_$g(^OEORD(ordId,"I",ordItm,"DEP",num))
	q memo
}

/// description: 草药医嘱煎药方式
/// ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).PrescCookType()
ClassMethod PrescCookType(prescNo)
{
   q:prescNo="" ""
   s cookType=""
   s queId=""
   f  s queId=$o(^PAQUE1(0,"PrescNo",prescNo,queId)) q:(queId="")||(cookType'="")  d
   .q:'$d(^PAQUE1(queId,"DHC")) 
   .s cookType=$p(^PAQUE1(queId,"DHC"),"^",15)
   q cookType
}

/// description: 主医嘱id
/// ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetMainOeori()
ClassMethod GetMainOeori(oeori As %String) As %String
{
 	q:'$d(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)) ""
 	s linkOeori=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),11),"^",39)
 	q:linkOeori'="" linkOeori
 	q oeori
}

/// description: 获取打包表对应主医嘱的该用药日期轮次打包Id
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetMainDspId(480840)
ClassMethod GetMainDspId(dspId) As %String
{
	Q:dspId="" ""
	s dspData=^DHCOEDISQTY(dspId)
	s seqNo=$p(dspData,"^",4)
	S oeori=$p(dspData,"^",1)
	S mOeori=..GetMainOeori(oeori)
	q:(mOeori="")||(seqNo="") dspId
	S doseDate=$p(dspData,"^",21)
	q:doseDate="" dspId
 	S mDspId=$o(^DHCOEDISQTY(0,"SEQNO",mOeori,doseDate,seqNo,""))
 	Q mDspId
}

/// description: 医生科室
ClassMethod OeoriDocLoc(oeori As %String) As %String
{
	s docLocId=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),7)),"^",2)
	q:docLocId="" ""
	s docLocDesc=$p($g(^CTLOC(+docLocId)),"^",2)
	q docLocId_"^"_docLocDesc
}

/// description: 医嘱费别
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriAdmReason("1220||380")
ClassMethod OeoriAdmReason(oeori As %String) As %String
{
	s ordId=+oeori
	s ordItm=+$p(oeori,"||",2)
	s admReasonId=$p($g(^OEORD(ordId,"I",ordItm,11)),"^",18)
	s admReasonDesc=$p($g(^PAC("ADMREA",+admReasonId)),"^",2)
	q admReasonId_"^"_admReasonDesc
}

/// description: 获取医嘱对应的数量以及单位
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriQtyUom("436||4")
ClassMethod OeoriQtyUom(oeori)
{
	s ordId=+oeori
	s ordItm=+$p(oeori,"||",2)
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId="" ""
	s qty=$p(^DHCOEDISQTY(dspId),"^",5)	//一对多的是药学基本单位数量,否则为库存基本单位
	s arcItmId=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",2)
	s arcSub=+arcItmId
	s arcVer=$p(arcItmId,"||",2)
	s tmpIncId=$o(^INCI(0,"ARCIM_DR",arcSub,""))
	q:tmpIncId="" "" 
 	s stkGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(tmpIncId)
 	q:$p(stkGrpStr,"^",3)'="G"
 	s uomDesc=""
 	s struModeFlag=$p(stkGrpStr,"^",7)
 	i struModeFlag="Y" d // 药学基本单位
    .s phcdfId=$p(^ARCIM(arcSub,arcVer,1),"^",12)
    .i phcdfId'="" d
    ..s uomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
    ..s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
 	e  d				 // 按门诊或住院或发药单位
	.s admId=$p(^DHCOEDISQTY(dspId),"^",26)
	.s admType=$p(^PAADM(admId),"^",2)
	.s dispUomId=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",13)
	.i dispUomId'="" d
	..s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(tmpIncId,qty,dispUomId)
	.e  i admType="I" d // 住院转为住院发药单位
	..s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToInUomQty(tmpIncId,qty)
	.e  d			 	// 门诊转为门诊发药单位
    ..s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(tmpIncId,qty)
    .s qty=$p(qtyUomStr,"^",1)
    .s uomId=$p(qtyUomStr,"^",2)
    .s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
    i (qty'="")&&(qty<1)&&($p(qty,".",1)="") s qty=0_qty
 	q qty_"^"_uomDesc
}

/// description: 成组医嘱是否皮试合格
/// return:		 -2(阳性),-1(未做)
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OrderSkinTest("19||137")
ClassMethod OrderSkinTest(MOeori)
{
	q:MOeori="" ""
	s ordId=+MOeori
	s testVal=..OeoriSkinTestVal(ordId,+$p(MOeori,"||",2))
	q:(testVal=-2)||(testVal=-3) testVal
	s skinRet=testVal
	s ordItm=0
	f  s ordItm=$o(^OEORDi(0,"OEORI",ordId,MOeori,ordItm)) q:(ordItm="")||(skinRet=-2)||(skinRet=-3)  d
	.q:+ordItm=0
	.s testVal=..OeoriSkinTestVal(ordId,ordItm)
	.q:testVal=""
	.s skinRet=testVal
	.q:(skinRet=-2)||(skinRet=-3)
	.s skinRet=testVal
	q skinRet
}

/// description: 处方是否皮试合格
/// return:		 -2(阳性),-1(未做)
/// w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).PrescSkinTest("I181123000027")
ClassMethod PrescSkinTest(PrescNo)
{
	q:PrescNo="" ""
	s skinRet=""
	s ordId=""
	f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId)) q:(ordId="")||(skinRet=-2)||(skinRet=-3)  d
	.s ordItm=0
	.f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm)) q:(ordItm="")||(skinRet=-2)||(skinRet=-3)  d
	..q:+ordItm=0
	..s testVal=..OeoriSkinTestVal(ordId,ordItm)
	..q:testVal=""
	..s skinRet=testVal
	..q:(skinRet=-2)||(skinRet=-3)
	..s skinRet=testVal
	q skinRet
}

/// description: 简写的皮试结果
/// return:		 -2(阳性),-1(未做),-3(皮试剂非阴性)
ClassMethod OeoriSkinTestVal(OrdId, OrdItm)
{
	s skinTestFlag=$P($g(^OEORD(OrdId,"I",OrdItm,5)),"^",2)
	q:skinTestFlag'="Y" ""
	s oeStateId=$p($g(^OEORD(OrdId,"I",OrdItm,1)),"^",13)
	q:oeStateId="" ""
	s oeStateCode=$P($g(^OEC("OSTAT",+oeStateId)),"^",1)
	q:(oeStateCode'="V")&&(oeStateCode'="E") ""
	s abNormal=$P($g(^OEORD(OrdId,"I",OrdItm,11)),"^",3)
	q:abNormal="Y" -2
	s actionId=$P($g(^OEORD(OrdId,"I",OrdItm,11)),"^",21)
	s skinTestDesc=$s(actionId'="":$p($g(^OEC("ACT",actionId)),"^",2),1:"")
	q:skinTestDesc["原液" ""
	q:##class(PHA.COM.Order).IsInstForSkinTest(OrdId_"||"_OrdItm)="Y" "" //Huxt 2020-04-20 用法为皮试,相当于皮试原液
	q:(skinTestDesc["皮试剂")&&(abNormal'="N") -3
	q:abNormal="N" ""
	q -1
}

/// Description:获取病人相关信息
/// Creator:	hulihua
/// CreateDate:	2017-04-06
/// Table:      pa_patmas
/// Input:		AdmDr-就诊ID、PhacId-住院发药主表ID
/// Output:		
/// Return：	登记号、卡号、姓名、性别、年龄、电话号码、地址、工作单位、诊断、体重、身高 
/// Others:     
/// Debug:		w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo("1")
ClassMethod GetPatInfo(AdmDr As %String, PhacId As %String = "") As %String
{
	s papmi=$p(^PAADM(AdmDr),"^",1)
	s papmi=+papmi
	s admType=$p(^PAADM(AdmDr),"^",2)
	s PatNo=$p(^PAPER(papmi,"PAT",1),"^",2)															//登记号
    s PatName=$p(^PAPER(papmi,"ALL"),"^",1)															//姓名
   	s PatTel=$p(^PAPER(papmi,"PER",1),"^",11)														//电话号码
   	s PatAddress=$p($g(^PAPER(papmi,"PER",4)),"^",18)												//地址
   	s PatAge=##class(PHA.FACE.IN.Com).GetAge(papmi,AdmDr)											//年龄 
   	s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
   	s PatSex=$p(^CT("SEX",sexdr),"^",2)																//性别
   	s PatCompany=$p(^PAPER(papmi,"PER",4),"^",18) 													//工作单位
   	s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
   	s PatCardNo=$S(cfRowId'="":$p($g(^DHCCARD("CF",cfRowId)),"^",2),1:"")							//卡号
   	s Diagnodesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",")								//诊断
   	s PatW=##class(web.DHCOutPhCommon).GetPatWeight(AdmDr)											//体重
   	s PatH=##class(web.DHCOutPhCommon).GetPatHeight(AdmDr)											//身高
   	s PatMedNo=##class(PHA.FACE.IN.Com).GetMrNoByEpisodeID(AdmDr,admType)							//病案号
   	s bedNo=""																						//床号
   	i PhacId'="" d
   	.s phacCh=$o(^DHCPHAC(PhacId,"I",""),-1)
   	.q:phacCh=""
   	.s bedNo=$p($g(^DHCPHAC(PhacId,"I",phacCh)),"^",8)
   	e  d
   	.s bedNo=$p(..GetAdmBedCode(AdmDr),"^",2)														
   	s patNationId=$p($g(^PAPER(papmi,"PER",2)),"^",1)									
	s patNation=$p($g(^CT("NAT",+patNationId)),"^",2)												//民族
	//输出
   	s Data1=PatNo_"^"_PatCardNo_"^"_PatName_"^"_PatSex_"^"_PatAge			;5
   	s Data2=PatTel_"^"_PatAddress_"^"_PatCompany_"^"_Diagnodesc_"^"_PatW	;10
   	s Data3=PatH_"^"_PatMedNo_"^"_$g(bedNo)_"^"_$g(patNation)
   	s Data=Data1_"^"_Data2_"^"_Data3
   	q Data
}

/// Description:判断该医嘱是否需要显示医生签名
/// Creator:	hulihua
/// CreateDate:	2019-01-15
/// Table:      OE_OrdItem
/// Input:		oeori-医嘱ID
/// Output:		
/// Return：	""-无需显示签名，医生签名	
/// Others:   
/// Debug:		w ##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).CheckIfShowSign("684||38")
ClassMethod CheckIfShowSign(oeori As %String) As %String
{
	q:oeori="" ""
	s ordId=+oeori
	s ordItm=+$p(oeori,"||",2)
	s prescNo=$p(^OEORD(ordId,"I",ordItm,1),"^",14)
	q:prescNo="" ""		;非药品不判断
	s queId=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(prescNo)
	q:queId="" ""		;非草药处方不判断
	s prescInfoStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s queFactor=$p(prescInfoStr,"^",2)
	s ordUserID=$p($g(^OEORD(ordId,"I",ordItm,7)),"^",1)
	s ordUserName=$p($g(^SSU("SSUSR",ordUserID)),"^",2) 				 
	//限量、极量判断
	s doseQty=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",12)
	s doseQtyCM=doseQty/queFactor
	s arcimId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
	s xlQty=0,jlQty=0,prescSign=""
	s dhcArcimId=$o(^DHCItmMast("0","ARCIM",arcimId,0))
	i dhcArcimId'="" d
	.s xlQty=+$p($g(^DHCItmMast(dhcArcimId)),"^",3)
	.s jlQty=+$p($g(^DHCItmMast(dhcArcimId)),"^",12)
	.s:((xlQty'=0)&&(doseQtyCM>xlQty))||((jlQty'=0)&&(doseQtyCM>jlQty)) prescSign=ordUserName
	q:prescSign'="" prescSign
	//十八反十九畏判断
	s limitFlag=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).CheckCMPrescLimitInfo(oeori)
	s prescSign=$s(limitFlag="Y":ordUserName,1:"")
	q:prescSign'="" prescSign
	//毒麻判断
	s phcdfId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimId)  
 	s poisonDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(phcdfId),"^",2)
 	s prescSign=$s((poisonDesc["毒")||(poisonDesc["麻"):ordUserName,1:"")
 	q prescSign
}

}
