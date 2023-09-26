/// 医嘱
Class CIS.AN.BL.OEOrder Extends %RegisteredObject
{

ClassMethod SaveOrderItem(EpisodeID As %String, orderData As %String) As %String
{
	quit:(##class(CIS.AN.COM.Admission).ExistsEpisode(EpisodeID)="N") "E^不存在就诊记录"
}

/// Creator：      	ypz
/// CreatDate：    	2010-03-12
/// Description： 	获取医嘱状态代码
/// Table：        	OE_OrdItem
/// Input：        	oeoriId:医嘱ID
/// Output：       
/// Return：       	医嘱状态代码
ClassMethod GetOrdStatCode(oeoriId) As %String
{
	q:oeoriId="" ""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
	s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
	s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^")
	s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
	s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	s curDateTimeVal=($h*100000)+$p($h,",",2)
	s xDateTimeVal=(xDate*100000)+xTime
	s EndDate=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",9)
	s EndTime=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",10)
	s endDateTimeVal=(EndDate*100000)+EndTime
	i ordStatCode["D",EndDate'="",curDateTimeVal<xDateTimeVal s ordStatCode="PD" //已停止预停
	i ordStatCode["V",curDateTimeVal<endDateTimeVal s ordStatCode="TPD" //未停止预停	
	q ordStatCode
}

ClassMethod InsertOrderItemNew(EpisodeID, mulOeoriStr, userId, locId, opsId) As %String
{
	//EpisodeID就诊号, userId用户Id, locId登录科室Id, 
	//mulOeoriStr由$c(3)分割：arcimId医嘱码Id, startDate开始日期, startTime开始时间,recDepId接收科室, 
	//doseQty单次剂量,doseQtySum数量, doseUomId等效剂量单位, instrId用法, seqNo序号, masterSeqNo主医嘱序号,oeoriPrice价格,排班表opaId,医嘱备注depProcNotes
	//其中seqNo序号取自然序号，不是插入后的序号。masterSeqNo值取主医嘱的seqNo序号
	//返回以"^"分割的第一部分为0未成功,错误信息为第二部分。成功则返回类于"1576||1*924106||331*V^1402||1*924106||332*V^"的串
	s ^tempck("InsertOrderItem")=EpisodeID_"*"_mulOeoriStr_"*"_userId_"*"_locId
	//w ##class(web.DHCANOrder).InsertOrderItem(1030551,"",10376,831)
	//s mulOeoriStr="1576||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_250_$c(3)_250_$c(3)_619_$c(3)_12_$c(3)_1_$c(3)_""
	//s mulOeoriStr=mulOeoriStr_"^1402||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_160_$c(3)_160_$c(3)_619_$c(3)_12_$c(3)_2_$c(3)_"1"
	//s mulOeoriStr=  "1575||1"_$c(3)_"2012-4-11"_$c(3)_"17:57"_$c(3)_42_$c(3)_1_$c(3)_1_$c(3)_17_$c(3)_$c(3)_1_$c(3)_$c(3)_1.71_$c(3)_84
	//freqId会不会有变
    
	q:(EpisodeID="")!(mulOeoriStr="")!(userId="")!(locId="") "0^输入数据有误!"
	s LABDATA="LABDATA"
	s docId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:docId="" "0^请使用医护人员身份登录!"
    
	s orderType="",packQty="",oeprice=0,drugFormId="",depProcNotes="",phPrescType=""
	s masterSeqNo="",skinTest="N",phSpecInstr="",orderCoverMainIns="Y",actionId="",arcosId=""

	s admReasonId=$p(^PAADM(EpisodeID,1),"^",7)

	s defDurId=0
	s phcduId=0
	f  s phcduId=$o(^PHCDU(phcduId)) q:(phcduId="")!(defDurId>0)  d
		.q:$p(^PHCDU(phcduId),"^",2)'=1
		.s defDurId=phcduId
	q:defDurId=0 "0^没有疗程为1天的数据,请维护!" 
	s defFreqId=0,phcfrId=0,isFind=0
	f  s phcfrId=$o(^PHCFR(phcfrId)) q:(phcfrId="")!(isFind)  d
		.q:$p(^PHCFR(phcfrId),"^",2)'=1
		.q:$p($g(^PHCFR(phcfrId,"DT",1)),"^",1)=""
		.s defFreqId=phcfrId
		.i $p($g(^PHCFR(phcfrId,"DT",1)),"^",1)=28800 s isFind=1
	//i $o(^PHCFR(0,"Code","QD",""))'="" s defFreqId=$o(^PHCFR(0,"Code","QD",""))
	q:defFreqId=0 "0^没有频次为1数据,请维护!"
	s priorId=$o(^OECPR(0,"Code","NORM",""))   //优先级
	q:+priorId=0 "0^没有临时医嘱优先级数据,请维护!"
	 
	/*s Config=##Class(websys.Configuration).%OpenId(1)
	s MEDDATA=Config.DataNamespace
	s CurrentNS=$ZNSPACE
	zn MEDDATA     //转换命名空间
	*/
	s retStr=0
	s oeoriStr=""
	f i=1:1:$l(mulOeoriStr,"^") d
		.s singleOeoriStr=$p(mulOeoriStr,"^",i)
		.s arcimId=$p(singleOeoriStr,$c(3),1)
		.i '$d(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)) s retStr="0^医嘱码"_arcimId_"不对!" q
		.s startDate=$p(singleOeoriStr,$c(3),2)
		.s startTime=$p(singleOeoriStr,$c(3),3)
		.
		.s recLocId=$p(singleOeoriStr,$c(3),4)
		.i '$d(^CTLOC(+recLocId)) s recLocId=""
		.i recLocId="" d
			..s recLocStr=..GetRecLoc(EpisodeID,arcimId)
			..s recLocId=$p(recLocStr,$c(3),1)
		.i recLocId="" s recLocId=locId
		.s doseQty=$p(singleOeoriStr,$c(3),5)
		.s doseQtySum=+$p(singleOeoriStr,$c(3),6)
		.s doseUomId=$p(singleOeoriStr,$c(3),7)
		.s itemCatId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",10)
		.s orderType=$p($g(^ARC("IC",itemCatId)),"^",7)
		.s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
		.i phcdfId>0 s doseQtySum=##class(web.DHCDocOrderEntry).CalDose(doseUomId,phcdfId,doseQty)
		.i doseQtySum>$p(doseQtySum,".") s doseQtySum=$p(doseQtySum,".")+1
		.s instrId=$p(singleOeoriStr,$c(3),8)
		.s freqId=defFreqId
		.s durId=defDurId
		.s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
		.i phcdfId=-1 s phcdfId=""
		.//i (orderType'="R")  d
        .//.s doseQty="",doseUomId="",phcdfId="",doseQtySum="",freqId=""
		.i phcdfId="" s freqId="",durId=""
		.s seqNo=$p(singleOeoriStr,$c(3),9)
		.s masterSeqNo=$p(singleOeoriStr,$c(3),10)
		.s oeprice=$p(singleOeoriStr,$c(3),11) //ypz 110316
		.s packQty=$p(singleOeoriStr,$c(3),12)	//dyl+20160301
		.;s opsId=$p(singleOeoriStr,$c(3),13) //dyl+20160301
		.//s anaId=$p($g(^DHCANOPArrange(+opaId)),"^",2) //ypz 110316
		.s anaId=##class(CIS.AN.BL.OperScheduleList).GetORAnaestID(opsId) //ypz 110316
		.s depProcNotes=$p(singleOeoriStr,$c(3),14)	//dyl+20160301
		.
		.s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
		.s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
		.;病人出院时间
		.s patDisCharDate=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
		.;病人出院状态
		.s patOutStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
		.i (patDisCharDate'="")&(patOutStatus="B") s startDate=$p(patDisCharDate,"^",1),startTime=$p(patDisCharDate,"^",2)
		.s startDate=$ZD(startDate,4)
		.s startTime=$ZT(startTime,3)
		.s admId=EpisodeID
		.s oeordId=$o(^OEORD(0,"Adm",admId,""))
		.s orderCoverMainIns=$p($g(^OEORD(oeordId,"I",1,3)),"^",3)	;20170406+dyl+取医保标志
		.i oeoriStr'="" s oeoriStr=oeoriStr_$c(1)
		.s oeoriStr=oeoriStr_arcimId_"^"_orderType_"^"_priorId_"^"_startDate_"^"_startTime_"^"_packQty_"^"_oeprice_"^"_recLocId_"^"_admReasonId_"^"_drugFormId
		.s oeoriStr=oeoriStr_"^"_depProcNotes_"^"_doseQty_"^"_doseUomId_"^"_doseQtySum_"^"_freqId_"^"_durId_"^"_instrId_"^"_phPrescType_"^"_masterSeqNo_"^"_seqNo
		.s oeoriStr=oeoriStr_"^"_skinTest_"^"_phSpecInstr_"^"_orderCoverMainIns_"^"_actionId_"^"_arcosId_"^^^^^"
		.s oeoriStr=oeoriStr_"^^^^^^^"_anaId
	//s ^TMPCLInsertOrd($j)=1
	// 8.0以上
	s retStr=##class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID,oeoriStr,userId,locId,docId)
	//2010
	//s retStr=##class(appcom.OEOrdItem).InsertMulti(EpisodeID, oeoriStr, userId, locId, docId)
	s ^tempck("retStr")=retStr
	//P5-P8
	//s retStr=##class(web.DHCANCall).InsertOrderItem(EpisodeID, oeoriStr, userId, locId, docId, LABDATA)
	////s retStr=$$InsertMultiple^DHCDocOrderCommon(EpisodeID, oeoriStr, userId, locId, docId, LABDATA)
	i $p(retStr,"^",1)=-1 s $p(retStr,"^",1,2)=$p(retStr,"^",2)
	//k ^TMPCLInsertOrd($j)
	
	////zn CurrentNS   //恢复命名空间
	//i retStr'="" d ##class(web.DHCOEOrdItem).UpdateOrderStatus(retStr, EpisodeID, userId)
	q retStr
}

ClassMethod CancelOEOrder(orderId As %String, userId As %String) As %String
{
	set saveResult="S^"
	set obj=##class(User.OEOrdItem).%OpenId(orderId)
	set OEORIItemStatDR=obj.OEORIItemStatDR
	set OEORIItemStateCode=$s($IsObject(OEORIItemStatDR):OEORIItemStatDR.OSTATCode,1:"")
	if (OEORIItemStateCode'="V") Quit saveResult  //判断医嘱状态不用再停
	set cancelRet=##class(appcom.OEOrdItem).Cancel(orderId,userId)
	set:(+cancelRet'=0) saveResult="E^撤销HIS系统医嘱失败(错误代码："_cancelRet_")，请联系系统管理员。"	
	quit saveResult
}

ClassMethod GetRecLoc(EpisodeID, arcimId) As %String
{
	s retStr=""
	s recLocStrList=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,arcimId)
	//s recLocStrList=1_$c(1)_"A科"_$c(1)_"N"_$c(2)_2_$c(1)_"B科"_$c(1)_"Y"
	f j=1:1:$l(recLocStrList,$c(2)) d
		.s recLocStr=$p(recLocStrList,$c(2),j)
		.q:$p(recLocStr,$c(1),3)'="Y"
		.s retStr=$tr(recLocStr,$c(1),$c(3))
	q retStr
}

ClassMethod GetArimByID(arcimID As %String, dataArr As %String) As %String
{
	if (##class(User.ARCItmMast).%ExistsId(arcimID))
	{
		set arcim=##class(User.ARCItmMast).%OpenId(arcimID)
		set dataArr(1,"RowId")=arcimID
		set dataArr(1,"Description")=arcim.ARCIMDesc
		set dataArr(1,"ItemCatId")=arcim.ARCIMItemCatDR.%Id()
		set dataArr(1,"ItemCatDesc")=arcim.ARCIMItemCatDR.ARCICDesc
		set dataArr(1,"OrderCatId")=arcim.ARCIMItemCatDR.ARCICOrdCatDR.%Id()
		set dataArr(1,"OrderCatDesc")=arcim.ARCIMItemCatDR.ARCICOrdCatDR.ORCATDesc		
	}
	quit ""
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-07
/// Description： 	获取医嘱项JSON字符串
/// Table：        	ARC_ItmMast,ARC_ItemCat,PHC_DrugForm,PHC_FormDoseEquiv
/// Input:			filterDesc:筛选字符串,groupId:安全组ID,locId:科室ID,EpisodeID:患者就诊ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.OEOrder).GetArcimJSON("1","50","bbf","53","298","")
/// w ##class(CIS.AN.BL.OEOrder).GetArcimJSON("1","10","1","1","1","20")
ClassMethod GetArcimJSON(page As %String, rows As %String, filterDesc As %String, groupId As %String, locId As %String, EpisodeID As %String, userId As %String) As %String
{
	quit:(filterDesc="")!(groupId="")!(locId="") ""
	set arcimSet=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	set sc=arcimSet.Execute(filterDesc,groupId,"","","",locId,"",EpisodeID,"","",userId,"","",locId,"","")
	set result="",arrIndex=1,arcimCount=0
	set startRowNo=0
	set page=+page,rows=+rows
	if (page>0)&(rows>0)
	{
		set startRowNo=(page-1)*rows	
	}
	set rowNo=0,displayRows=0
	k arcimArr
	while(arcimSet.%Next())
	{
		if ((rowNo>=startRowNo)&&(displayRows<rows))!(rows=0)
		{
			s arcimArr(arrIndex,"ArcimType")=arcimSet.GetData(4)
			s arcimId=arcimSet.GetData(2)
			s arcimArr(arrIndex,"ArcimId")=arcimId
			s arcimArr(arrIndex,"ArcimCode")=arcimSet.Get("代码")
			s arcimArr(arrIndex,"ArcimAlias")=arcimSet.GetData(32)
			s arcimMainId=+arcimId,arcimVersion=+$p(arcimId,"||",2)
			s arcimArr(arrIndex,"ArcimDesc")=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",2)
			s itemCatId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",10)
			s arcimArr(arrIndex,"ItemCatId")=itemCatId
			s arcimArr(arrIndex,"ItemCatDesc")=$piece($get(^ARC("IC",itemCatId)),"^",2)
			
			s baseUomId=$p($g(^ARCIM(arcimMainId,arcimVersion,8)),"^",14)
			s arcimArr(arrIndex,"BaseUomId")=baseUomId
			s arcimArr(arrIndex,"BaseUomDesc")=##class(CIS.AN.COM.String).GetDescByID("User.CTUOM","CTUOMDesc",baseUomId)
			s instrId=""
			s drugFormId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",12)
			s arcimArr(arrIndex,"DrugFormId")=drugFormId
			s drugFormMainId=+drugFormId,drugFormSubId=+$p(drugFormId,"||",2)
			i (drugFormSubId'="")
			{
				s instrId=$p($g(^PHCD(drugFormMainId,"DF",drugFormSubId,1)),"^",5)	
			}
			s arcimArr(arrIndex,"InstrId")=instrId
			s arcimArr(arrIndex,"InstrDesc")=##class(CIS.AN.COM.String).GetDescByID("User.PHCInstruc","PHCINDesc1",instrId)
			s arcimArr(arrIndex,"EquivUom")=##class(CIS.AN.COM.String).QueryToJSON("CIS.AN.BL.OEOrder","FindDoseEquiv",drugFormId)
			s arcimArr(arrIndex,"EquivUom","Type")="JSON"
			s arcimArr(arrIndex,"Price")=+##Class(CIS.AN.COM.DataAdapter).GetArcimPrice(arcimId,+$h,EpisodeID)
			s arcimArr(arrIndex,"RecvLoc")=##class(CIS.AN.COM.DataAdapter).GetRecvLocJSON(locId,EpisodeID,arcimId)
			s arcimArr(arrIndex,"RecvLoc","Type")="JSON"
			set arrIndex=arrIndex+1	
			set displayRows=displayRows+1
		}
			
		set rowNo=rowNo+1
	}
	set result=##class(CIS.AN.COM.String).ToJson(.arcimArr)
	set result=$tr(result,"\","/")
	//quit:(+rows>0) "{ ""total"":"_rowNo_",""rows"":"_result_"}"
	quit result
}

ClassMethod GetANOPPDFUrl(EpisodeID As %String) As %String
{
	s opaId="",str=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId))  q:opaId=""  d
	.i str="" s str="麻醉记录单地址#ftp://FTP_001:ABCabc123@172.25.3.202/ANOP/"_EpisodeID_"/"_opaId_".pdf"_"$"_"术前访视单地址#ftp://FTP_001:ABCabc123@172.25.3.202/DHCANPRE/"_EpisodeID_"/"_opaId_".pdf"_"$"_"术后访视单地址#ftp://FTP_001:ABCabc123@172.25.3.202/DHCANPOST/"_EpisodeID_"/"_opaId_".pdf"
	.e  s str=str_"&"_"麻醉记录单地址#ftp://FTP_001:ABCabc123@172.25.3.202/ANOP/"_EpisodeID_"/"_opaId_".pdf"_"$"_"术前访视单地址#ftp://FTP_001:ABCabc123@172.25.3.202/DHCANPRE/"_EpisodeID_"/"_opaId_".pdf"_"$"_"术后访视单地址#ftp://FTP_001:ABCabc123@172.25.3.202/DHCANPOST/"_EpisodeID_"/"_opaId_".pdf"
	q str
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-07
/// Description： 	获取医嘱套JSON字符串
/// Table：        	ARC_OrdSets
/// Input:			filterDesc:筛选字符串,groupId:安全组ID,locId:科室ID,userId:用户ID
/// Return：       	ResultSet
/// d ##class(CIS.AN.BL.OEOrder).GetArcimJSON("2527","364","53","1000")
ClassMethod GetOrderSets(filterDesc As %String, locId As %String, groupId As %String, userId As %String) As %String
{
	quit:(filterDesc="")!(groupId="")!(locId="") ""
	set orderCategory=$o(^OEC("ORCAT",0,"Desc","医嘱套",0))
	set arcimSet=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	set sc=arcimSet.Execute(filterDesc,groupId,orderCategory,"","","","","","","",userId,"","",locId,"","")
	set result="",arrIndex=1
	k arcimArr
	while(arcimSet.%Next())
	{
		s arcimArr(arrIndex,"ArcimType")=arcimSet.GetData(4)
		s orderSetId=arcimSet.GetData(2)
		s arcimArr(arrIndex,"RowId")=orderSetId
		s arcimArr(arrIndex,"Description")=arcimSet.GetData(1)	
		s arrIndex=arrIndex+1
	}
	set result=##class(CIS.AN.COM.String).ToJson(.arcimArr)
	quit result
}

ClassMethod GetDoseEquivJSON(arcimId As %String) As %String
{
	set drugFormId=""
	&sql(select ARCIM_PHCDF_DR into :drugFormId from SQLUser.ARC_ItmMast where %ID=:arcimId)
	set result=##class(CIS.AN.COM.String).QueryToJSON("CIS.AN.BL.OEOrder","FindDoseEquiv",drugFormId)
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-04
/// Description： 	查询药学项的等效单位
/// Table：        	CF_AN.ArcimRule
/// Input:			filterDesc:筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OEOrder","FindDoseEquiv","1||1")
Query FindDoseEquiv(drugFormId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As RowId,
	   EQ_CTUOM_DR As EquivUomId,
	   EQ_CTUOM_DR->CTUOM_Desc As EquivUomDesc,
	   EQ_DefaultDose As DefaultDose 
	   from SQLUser.PHC_FormDoseEquiv
	   where EQ_ParRef=:drugFormId
}

/// 根据医嘱ID查询等效剂量，剂量单位
/// d ##class(%ResultSet).RunQuery("DHCAN.BLL.CaculateSummary","FindDrugEqual","9527||1")
/// (SELECT ARCIM_PHCDF_DR FROM ARC_ItmMast a WHERE a.ARCIM_RowId='9527||1')
Query FindDrugEqual(arcItemId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT 
	EQ_CTUOM_DR As uomDr,
	EQ_CTUOM_DR->CTUOM_Desc As uomDesc,
	EQ_Qty As qty
	FROM SQLUser.PHC_FormDoseEquiv WHERE EQ_ParRef in (SELECT ARCIM_PHCDF_DR FROM SQLUser.ARC_ItmMast a WHERE a.ARCIM_RowId=:arcItemId)
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-04
/// Description： 	查询用药途径
/// Table：        	PHC_Instruc
/// Input:			filterDesc:筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OEOrder","FindInstruction","")
Query FindInstruction(filterDesc As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As RowId,
	   PHCIN_Code As Code,
	   PHCIN_Desc1 As Description,
	   PHCIN_Desc2 As ForeignDesc 
	   from SQLUser.PHC_Instruc
	   where PHCIN_ActiveFlag<>'N'
	   and ((UPPER(PHCIN_Desc2) [ UPPER(:filterDesc)) or (:filterDesc is null))
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-09
/// Description： 	查询医嘱套明细项
/// Table：        	ARC_OrdSetDate,ARC_OrdSetDateItem
/// Input:			orderSetId:医嘱套ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OEOrder","FindOrderSetItems","3924")
Query FindOrderSetItems(orderSetId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As RowId,
	   ITM_ARCIM_DR As ArcimID,
	   ITM_ARCIM_DR->ARCIM_Desc As ArcimDesc,
	   ITM_Qty As PackQty,
	   ITM_PackQtyUom_DR As PackUom,
	   ITM_PackQtyUom_DR->CTUOM_Desc As PackUomDesc,
	   ITM_Freq_DR As Freq,
	   ITM_Durat_DR As Duration,
	   ITM_Instruc_DR As InstrId,
	   ITM_Instruc_DR->PHCIN_Desc1 As InstrDesc,
	   ITM_DoseQty As DoseQty,
	   ITM_UOM_DR As DoseUom,
	   ITM_UOM_DR->CTUOM_Desc As DoseUomDesc,
	   CIS_AN_BL.OEOrder_GetOrderPrice(ITM_ARCIM_DR) As Price,
	   ITM_RecLoc_DR As RecvLoc,
	   ITM_RecLoc_DR->CTLOC_Desc As RecvLocDesc 
	   from SQLUser.ARC_OrdSetDateItem
	   where ITM_ParRef->DATE_ParRef=:orderSetId
	   and (ITM_ParRef->DATE_DateTo >= (+$h) or (ITM_ParRef->DATE_DateTo is null))
}

ClassMethod GetItemCatByArcimID(arcimId As %String) As %String [ SqlProc ]
{
	set itemCatDesc=""
	&sql(select ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc into :itemCatDesc from SQLUser.ARC_ItmMast where %ID=:arcimId)	
	quit itemCatDesc
}

/// Creator：        ypz
/// CreatDate：      2009-08-19
/// Description：    取医嘱套
/// Table：          ARC_OrdSets
/// Input：          安全组Id
/// Output：        医嘱套Id和描述
/// Return：         
Query FindARCOrdSets(ssgrpId) As %Query(ROWSPEC = "ARCOSId:%String,ARCOSDesc:%String,ARCOSCode:%String")
{
}

ClassMethod FindARCOrdSetsExecute(ByRef qHandle As %Binary, ssgrpId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s userGroupArcosStr=..GetUserGroupArcos(ssgrpId)
    s orcatIdStr=$p(userGroupArcosStr,"^")
    s arcicIdStr=$p(userGroupArcosStr,"^",2)
    s arcosId=0
    f  s arcosId=$o(^ARCOS(arcosId)) q:arcosId=""  d
        .q:$d(^ARCOS(arcosId))<11
        .s arcosDesc=$p(^ARCOS(arcosId),"^",2)
        .q:arcosDesc=""
        .s arcosCode=$p(^ARCOS(arcosId),"^",1)
        .q:arcosCode=""
        .s orcatId=$p(^ARCOS(arcosId),"^",8)
        .q:orcatId=""
        .s arcicId=$p(^ARCOS(arcosId),"^",9)
        .q:($p(^ARCOS(arcosId),"^",16)>0)&($p(^ARCOS(arcosId),"^",16)<$h) //ARCOS_EffDateTo
        .q:(ssgrpId'="")&((("#"_orcatIdStr_"#")'[("#"_orcatId_"#"))&(("#"_arcicIdStr_"#")'[("#"_arcicId_"#")))
        .d OutputRow1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow1
    set Data=$lb(arcosId,arcosDesc,arcosCode)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindARCOrdSetsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindARCOrdSetsExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindARCOrdSetsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindARCOrdSetsExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUserGroupArcos(ssgrpId = "") As %String
{
    q:ssgrpId="" "^^"
    s orcatIdStr="",arcicIdStr=""
    
    s ssordSub=0
    f  s ssordSub=$o(^SSU("SSGRP",+ssgrpId,"SSORD",ssordSub)) q:ssordSub=""  d
        .s ssordStr=^(ssordSub)
        .q:$p(ssordStr,"^",4)'="Y"
        .i $p(ssordStr,"^",5)'="" d
            ..i arcicIdStr'="" s arcicIdStr=arcicIdStr_"#"
            ..s arcicIdStr=arcicIdStr_$p(ssordStr,"^",5)
        .q:$p(ssordStr,"^",5)'=""
        .i $p(ssordStr,"^",1)'="" d
            ..i orcatIdStr'="" s orcatIdStr=orcatIdStr_"#"
            ..s orcatIdStr=orcatIdStr_$p(ssordStr,"^",1)
    q orcatIdStr_"^"_arcicIdStr_"^"
}

/// Creator：        ypz
/// CreatDate：      2009-08-19
/// Description：    取医嘱套医嘱
/// Table：          ARC_OrdSets,ARC_OrdSetDate,ARC_OrdSetDateItem
/// Input：          医嘱套Id,安全组Id,日期
/// Output：       
/// Return：         返回""无数据。返回数据分两级，第一级"^"，是每条医嘱码数据。
///                 第二级$c(3)：医嘱码Id_$c(3)_医嘱码名_$c(3)_医嘱数量
/// 修改记录 ck 20130412 增加3个返回值 医嘱套默认使用剂量、医嘱套默认使用剂量单位ID、医嘱套默认使用剂量单位
/// w ##class(CIS.AN.BL.OEOrder).GetArcosItem("3928")
ClassMethod GetArcosItem(arcosId, ssgrpId = "", curDate = "") As %String
{
    q:arcosId="" ""
    s curDate="" s curDate=+$h
    s dateDateFrom=$o(^ARCOS(arcosId,"DATE",0,"DateFrom",curDate+1),-1)
    q:dateDateFrom="" ""
    s dateId=$o(^ARCOS(arcosId,"DATE",0,"DateFrom",dateDateFrom,""))
    q:dateId="" ""
    s dateDateTo=$p($g(^ARCOS(arcosId,"DATE",dateId)),"^",2)
    q:(dateDateTo'="")&(dateDateTo<curDate) ""
    s retStr=""
    s itmId=0
    f  s itmId=$o(^ARCOS(arcosId,"DATE",dateId,"ITM",itmId)) q:itmId=""  d
    .s itmValueStr=^(itmId)
    .s arcimId=$p(itmValueStr,"^",1)
    .
    .s arcimDateFrom=$p($g(^ARCIM(+arcimId,1,1)),"^",13)
    .s arcimDateTo=$p($g(^ARCIM(+arcimId,1,7)),"^",1)
    .q:arcimDateFrom>$h //医嘱未到有效期
    .q:(arcimDateTo'="")&(arcimDateTo<$h) //医嘱过有效期
    .
    .s itemQty=$p(itmValueStr,"^",2)
    .i itemQty="" s itemQty=1
    .s itemUomDesc=""
    .s itemDoseQty=$p(itmValueStr,"^",13)
    .s itemUomDr=$p(itmValueStr,"^",10)
    .i itemUomDr'="" s itemUomDesc=$p(^CT("UOM",itemUomDr),"^",2)
    .
    .s arcimStr=##class(web.DHCANCom).GetArcimById(arcimId)
    .s orderPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,"","","","","")
    .i retStr'="" s retStr=retStr_"^"
    .s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
    .s eqIdStr=$p(arcimStr,"^",4),eqDoseStr=$p(arcimStr,"^",5),defInstrId=$p(arcimStr,"^",6)
    .s baseUomId=$p(arcimStr,"^",7),eqQtyStr=$p(arcimStr,"^",8),volume=$p(arcimStr,"^",9),basePrice=$p(arcimStr,"^",10)
    .s retStr=retStr_arcimId_$c(3)_arcimDesc_$c(3)_itemQty
    .s retStr=retStr_$c(3)_eqIdStr_$c(3)_eqDoseStr_$c(3)_defInstrId_$c(3)_baseUomId_$c(3)_eqQtyStr_$c(3)_volume_$c(3)_basePrice_$c(3)_$p(orderPrice,"^",1)_$c(3)_itemDoseQty_$c(3)_itemUomDr_$c(3)_itemUomDesc
    
    q retStr
}

ClassMethod GetOrderPrice(arcimId As %String, EpisodeID As %String = "") As %String [ SqlProc ]
{
	set orderPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,"","","","","")
	quit $p(orderPrice,"^",1)
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-09
/// Description： 	查询医嘱套明细项
/// Table：        	ARC_OrdSetDate,ARC_OrdSetDateItem
/// Input:			orderSetId:医嘱套ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OEOrder","FindUserFavItems","118")
Query FindUserFavItems(deptId As %String, userId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT Fav_ItemRowid As OSRowId,
	   Fav_Dep_Dr As FavDeptId,
	   Fav_User_Dr As FavUserId,
	   Fav_ItemRowid->ARCOS_Code As OSCode,
	   Fav_ItemRowid->ARCOS_Desc As OSDesc 
	   from SQLUser.DHC_UserFavItems
	   where Fav_Dep_Dr=:deptId
	   and (Fav_User_Dr=:userId or :userId is null)
	   and (Fav_ItemRowid->ARCOS_EffDateTo>=(+$h) or (Fav_ItemRowid->ARCOS_EffDateTo is null))
}

ClassMethod GetOSItemsJSON(OSRowId As %String) As %String
{
	set OSItemStr=..GetArcosItem(OSRowId)
	set OSItemCount=$l(OSItemStr,"^")
	kill OSItemArr
	for i=1:1:OSItemCount
	{
		set OSItem=$p(OSItemStr,"^",i)
		set OSItemArr(i,"ArcimID")=$p(OSItem,$c(3),1)
		set OSItemArr(i,"ArcimDesc")=$p(OSItem,$c(3),2)
		set OSItemArr(i,"DefQty")=$p(OSItem,$c(3),3)
		set OSItemArr(i,"EQUom")=$p(OSItem,$c(3),1)
		set OSItemArr(i,"ArcimID")=$p(OSItem,$c(3),1)
		set OSItemArr(i,"ArcimID")=$p(OSItem,$c(3),1)
		set OSItemArr(i,"ArcimID")=$p(OSItem,$c(3),1)
		set OSItemArr(i,"ArcimID")=$p(OSItem,$c(3),1)
		set OSItemArr(i,"ArcimID")=$p(OSItem,$c(3),1)
		set OSItemArr(i,"ArcimID")=$p(OSItem,$c(3),1)
		set OSItemArr(i,"ArcimID")=$p(OSItem,$c(3),1)	
	}
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-09
/// Description： 	查询医嘱套明细项
/// Table：        	ARC_OrdSetDate,ARC_OrdSetDateItem
/// Input:			orderSetId:医嘱套ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OEOrder","FindUserFavItems","118")
Query FindOrderCategory() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT ORCAT_RowId As RowId,
	   ORCAT_Desc As Description
	   from SQLUser.OEC_OrderCategory
}

/// Creator：      	陈长青
/// CreatDate：    	2019-01-09
/// Description： 	查询医嘱套明细项
/// Table：        	ARC_OrdSetDate,ARC_OrdSetDateItem
/// Input:			orderSetId:医嘱套ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OEOrder","FindUserFavItems","118")
Query FindARCItemCat(orderCategoryId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT ARCIC_RowId As RowId,
	   ARCIC_Desc As Description
	   from SQLUser.ARC_ItemCat
	   where ARCIC_OrdCat_DR=:orderCategoryId or :orderCategoryId is null
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-3
/// Description：   插入医嘱
/// Table：        	
/// Input:			List<DHCCL.BLL.OEOrderItem>
/// Return：       	
/// d ##class(DHCCL.BLL.OEOrder).InsertOrderItem()
ClassMethod InsertOrderItem(EpisodeID As %String, OEOrderItemList As %ListOfObjects, userId As %String, locId As %String) As %String
{
	set careprovId=$p($g(^SSU("SSUSR",userId)),"^",14)
	quit:careprovId="" "E^请使用医护人员身份登录!"
	
	set oeoriStr=""
	for i=1:1:OEOrderItemList.Size
	{
		set OEOrderItem=OEOrderItemList.GetAt(i)
		quit:OEOrderItem=""
		
		if oeoriStr'="" set oeoriStr=oeoriStr_$c(1)
		set oeoriStr=oeoriStr_(OEOrderItem.ToString())
	}
	
	set retStr=##class(appcom.OEOrdItem).InsertMulti(EpisodeID, oeoriStr, userId, locId, careprovId)
	
	//write "result: ",retStr,!
	
	if $p(retStr,"^",1)=-1 set $p(retStr,"^",1,2)=$p(retStr,"^",2)
	quit retStr
}

ClassMethod GetArcimHighValueFlag(barCode As %String) As %String
{
}

ClassMethod GetArcimByLabel(barCode As %String) As %String
{
}

/// Creator：      	陈长青
/// CreatDate：    	2021-06-18
/// Description： 	同步麻醉表RowID到医嘱表的OEORI_Anaest_DR字段
/// Table：        	
/// Input:			    startDate,endDate-开始、结束日期，格式为：YYYY-MM-DD    deptID-接收科室ID，这里只传手术室或麻醉科的CTLoc表的RowID
/// Return：       	
/// w ##class(CIS.AN.BL.OEOrder).SyncAnaToOEOrder("2021-04-01","2021-04-02",111)
ClassMethod SyncAnaToOEOrder(startDate As %String, endDate As %String, deptID As %String) As %String
{
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate)
	&sql(declare OPSCursor cursor for select
			RowId,ExtAnaestID,AppOrderItem,EpisodeID
			into :RowId,:AnaestID,:AppOrderItem,:EpisodeID from CIS_AN.OperSchedule
			where OperDate>=:startDateH
			and OperDate<=:endDateH
			and Status->Code in ('Arrange','RoomIn','RoomOut','PACUIn','PACUOut','Finish'))	// 只查询状态为：安排、术中、术毕、恢复、苏醒、完成的手术
	&sql(open OPSCursor)
	for
	{
		&sql(fetch OPSCursor)
		quit:(SQLCODE'=0)
		set operCount=0
		&sql(select count(RowId) into :OperCount from CIS_AN.OperSchedule where EpisodeID=:EpisodeID and Status->Code in ('Arrange','RoomIn','RoomOut','PACUIn','PACUOut','Finish'))
		continue:(operCount>1)	// 一次就诊有多条手术的情况，无法判断医嘱属于哪条手术，先不处理
		set OEOrderID=$p(AppOrderItem,"||",1)		// 根据手术申请医嘱的ID，获取医嘱主表的RowID
		set OEOrderSub=0
		set Anaest=##class(User.ORAnaesthesia).%OpenId(AnaestID)
		for 
		{
			set OEOrderSub=$o(^OEORDi(0,"RecDepOrd",OEOrderID,deptID,OEOrderSub))		//根据接收科室索引，查找接收科室为手术室或麻醉科的医嘱
			quit:(OEOrderSub="")
			
			set OEOrdItem=##class(User.OEOrdItem).%OpenId(OEOrderID_"||"_OEOrderSub)
			continue:(OEOrdItem.OEORIAnaestDR'="")
			set OEOrdItem.OEORIAnaestDR=Anaest
			set sc=OEOrdItem.%Save()
			
			// 写更新失败日志
			w:($System.Status.IsError(sc)) !,"OPSID:"_RowId_",AnaestID:"_AnaestID_",OrderItemID:"_OEOrderID_"||"_OEOrderSub_",Result:"_$SYSTEM.Status.GetErrorText(sc)
			
			// 写更新成功日志
			w:($System.Status.IsOK(sc)) !,"OPSID:"_RowId_",AnaestID:"_AnaestID_",OrderItemID:"_OEOrderID_"||"_OEOrderSub_",Result:Success"
			
			set OEOrdItem=""
		}
		set Anaest=""
	}
	&sql(close OPSCursor)
	quit ""
}

ClassMethod SyncMultiAnaToOEOrder(startDate As %String, endDate As %String, deptID As %String, action As %String = "Query") As %String
{
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate)
	&sql(declare MOPSCursor cursor for select
			RowId,ExtAnaestID,AppOrderItem,EpisodeID,OperDate
			into :RowId,:AnaestID,:AppOrderItem,:EpisodeID,:OperDate from CIS_AN.OperSchedule
			where OperDate>=:startDateH
			and OperDate<=:endDateH
			and Status->Code in ('Arrange','RoomIn','RoomOut','PACUIn','PACUOut','Finish'))	// 只查询状态为：安排、术中、术毕、恢复、苏醒、完成的手术
	&sql(open MOPSCursor)
	for
	{
		&sql(fetch MOPSCursor)
		quit:(SQLCODE'=0)
		set operCount=0
		&sql(select count(RowId) into :OperCount from CIS_AN.OperSchedule where EpisodeID=:EpisodeID and Status->Code in ('Arrange','RoomIn','RoomOut','PACUIn','PACUOut','Finish'))
		continue:(operCount<2)	// 只处理一次就诊有多条手术的情况
		
		set OEOrderID=$p(AppOrderItem,"||",1)		// 根据手术申请医嘱的ID，获取医嘱主表的RowID
		w "OPSID:"_RowId_",AnaestID:"_AnaestID_",EpisodeID:"_EpisodeID_",OEOrderID:"_OEOrderID,!
		continue:(action="Query")		// 只查询一次就诊多次手术的记录

		/*****************************************************
		* 下面更新操作不是很严谨，请谨慎操作
		* 如需操作建议备份数据，否则后果自负。
		******************************************************/
		set OEOrderSub=0
		set Anaest=##class(User.ORAnaesthesia).%OpenId(AnaestID)
		for 
		{
			set OEOrderSub=$o(^OEORDi(0,"RecDepOrd",OEOrderID,deptID,OEOrderSub))		//根据接收科室索引，查找接收科室为手术室或麻醉科的医嘱
			quit:(OEOrderSub="")
			
			set OEOrdItem=##class(User.OEOrdItem).%OpenId(OEOrderID_"||"_OEOrderSub)
			continue:(OEOrdItem.OEORIAnaestDR'="")
			continue:(OEOrdItem.OEORISttDat>(OperDate+1))		// 只判断手术当天或手术次日补录的医嘱
			set OEOrdItem.OEORIAnaestDR=Anaest
			set sc=OEOrdItem.%Save()
			
			// 写更新失败日志
			w:($System.Status.IsError(sc)) !,"OPSID:"_RowId_",AnaestID:"_AnaestID_",OrderItemID:"_OEOrderID_"||"_OEOrderSub_",Result:"_$SYSTEM.Status.GetErrorText(sc)
			
			// 写更新成功日志
			w:($System.Status.IsOK(sc)) !,"OPSID:"_RowId_",AnaestID:"_AnaestID_",OrderItemID:"_OEOrderID_"||"_OEOrderSub_",Result:Success"
			
			set OEOrdItem=""
		}
		set Anaest=""
	}
	&sql(close MOPSCursor)
	quit ""
}

}
