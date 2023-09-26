Class DHCCL.BLL.OEOrder Extends %RegisteredObject
{

ClassMethod SaveOrderItem(EpisodeID As %String, orderData As %String) As %String
{
	quit:(##class(DHCCL.BLL.Admission).ExistsEpisode(EpisodeID)="N") "E^不存在就诊记录"
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

ClassMethod InsertOrderItemNew(EpisodeID, mulOeoriStr, userId, locId) As %String
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
		.q:'$d(^PHCFR(phcfrId,"DT",1))
		.s defFreqId=phcfrId
		.i ^PHCFR(phcfrId,"DT",1)=28800 s isFind=1
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
		.s opsId=$p(singleOeoriStr,$c(3),13) //dyl+20160301
		.//s anaId=$p($g(^DHCANOPArrange(+opaId)),"^",2) //ypz 110316
		.s anaId=##class(DHCAN.BLL.AnaSchedule).GetORAnaestID(opsId) //ypz 110316
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
	//2010
	s retStr=##class(appcom.OEOrdItem).InsertMulti(EpisodeID, oeoriStr, userId, locId, docId)
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

}
