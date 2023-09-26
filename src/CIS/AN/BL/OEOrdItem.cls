/// 手术申请医嘱
Class CIS.AN.BL.OEOrdItem Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.OEOrdItem).SaveAppOrderItem(1)
ClassMethod SaveAppOrderItem(opsId As %String) As %String
{
	set $zt="Error"
	
	set arcimId=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("AppArcim")
	quit:(##class(User.ARCItmMast).%ExistsId(arcimId)=0) "E^手术申请关联的医嘱项不存在!"
	
	quit:(##class(CIS.AN.OperCatalogue).%ExistsId(opsId)=0) "E^手术计划不存在！"
	set operCatalogueObj=##class(CIS.AN.OperCatalogue).%OpenId(opsId)
	
	set EpisodeID=operCatalogueObj.EpisodeID
	quit:(##class(User.PAAdm).%ExistsId(EpisodeID)=0) "E^就诊记录不存在！"
	
	quit:(##class(User.ORAnaesthesia).%ExistsId(operCatalogueObj.ExtAnaestID)=0) "E^HIS麻醉计划不存在！"
	set anaId=operCatalogueObj.ExtAnaestID
	
	set orderItemID=operCatalogueObj.AppOrderItem
	set orderDesc=..GetOrderDesc(opsId)
	// 如果已经存在手术申请医嘱，那么更新手术申请医嘱的描述
	if (orderItemID'="")
	{
		set orderID=$piece(orderItemID,"||",1),itemSub=$piece(orderItemID,"||",2)
		quit:($data(^OEORDi(0,"Ana",anaId,orderID,itemSub))=0) "E^手术申请医嘱不存在！"
		set orderStatCode=##class(CIS.AN.BL.OEOrder).GetOrdStatCode(orderItemID)
		if (orderStatCode="E")!(orderStatCode="V")
		{
			set ^OEORD(orderID,"I",itemSub,"DEP",1)=orderDesc	
		}	
		quit "S^"_orderItemID
	}
	else
	{
		set orderId=$order(^OEORD(0,"Adm",EpisodeID,""))
		// 医嘱主表ID不存在，那么先创建医嘱主表的数据
		if (+orderId=0)
		{
			set today=+$horolog,now=$piece($horolog,",",2)
			set order=##class(User.OEOrder).%New()
			set order.OEORDAdmDR=##class(User.PAAdm).%OpenId(EpisodeID)
			set order.OEORDDate=today
			set order.OEORDTime=now
			set sc=order.%Save()
			quit:($System.Status.IsError(sc)) "E^插入医嘱主表失败，原因："_$System.Status.GetErrorText(sc,"zh-cn")
		}	
		set orderData=arcimId_$c(3)_$zd(+$h,3)_$c(3)_$zt($p($h,",",2))_$c(3)_operCatalogueObj.AppDeptID_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_$c(3)_opsId_$c(3)_orderDesc
		set ret=..InsertOrderItemNew(EpisodeID,orderData,operCatalogueObj.AppUserID,operCatalogueObj.AppDeptID,opsId)
		if ($piece(ret,"^",1)=0)
		{
			quit "E^"_$piece(ret,"^",2)
		}
		else
		{
			set orderItemID=$piece(ret,"*",2)
			set operCatalogueObj.AppOrderItem=orderItemID
			set sc=operCatalogueObj.%Save()
			if ($System.Status.IsError(sc))
			{
				quit "E^"_$System.Status.GetErrorText(sc)	
			}
			else
			{
				quit "S^"_orderItemID	
			}
				
		}
	}
Error
	set $zt=""
	quit "E^"_$ze
}

ClassMethod GetOrderDesc(opsId As %String) As %String
{
	set result=""
	set query=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	set sc=query.Execute("","","",opsId)
	set operData=##class(CIS.AN.COM.DataObject).%New()
	while(query.%Next())
	{
		set columnCount=query.GetColumnCount()
		for i=1:1:columnCount
		{
			set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
			set keyValuePair.Key=query.GetColumnName(i)
			set keyValuePair.Value=query.GetData(i)
			do operData.KeyValuePairs.Insert(keyValuePair)	
		}
	}
	set query=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindDataConfigurations")
	set sc=query.Execute("OrderFormatter")
	set orderFormat=""
	while(query.%Next())
	{
		set orderFormat=query.Get("DataValue")
	}
	if (orderFormat'="")
	{
		set orderDesc=""
		
		do ..GenerateOrderDesc(orderFormat,operData,.orderDesc)
		set result=orderDesc
	}	
	quit result
}

ClassMethod GenerateOrderDesc(orderFormat As %String, operData As CIS.AN.COM.DataObject, Output orderDesc As %String = "") As %String
{
	set leftIndex=$find(orderFormat,"{")
	quit:(leftIndex=0) $$$OK
	set leftIndex=leftIndex-1
	set rightIndex=$find(orderFormat,"}")-1
	set dataField=$extract(orderFormat,leftIndex+1,rightIndex-1)
	set dataValue=operData.GetValue(dataField)
	set $extract(orderFormat,leftIndex,rightIndex)=dataValue
	set orderDesc=orderFormat
	do ..GenerateOrderDesc(orderFormat,operData,.orderDesc)
}

ClassMethod InsertOrderItemNew(EpisodeID, mulOeoriStr, userId, locId, opsId) As %String
{
	//EpisodeID就诊号, userId用户Id, locId登录科室Id, 
	//mulOeoriStr由$c(3)分割：arcimId医嘱码Id, startDate开始日期, startTime开始时间,recDepId接收科室, 
	//doseQty单次剂量,doseQtySum数量, doseUomId等效剂量单位, instrId用法, seqNo序号, masterSeqNo主医嘱序号,oeoriPrice价格,排班表opaId,医嘱备注depProcNotes
	//其中seqNo序号取自然序号，不是插入后的序号。masterSeqNo值取主医嘱的seqNo序号
	//返回以"^"分割的第一部分为0未成功,错误信息为第二部分。成功则返回类于"1576||1*924106||331*V^1402||1*924106||332*V^"的串
	s ^tempck("InsertOrderItem")=EpisodeID_"*"_mulOeoriStr_"*"_userId_"*"_locId
	 
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
	q:defFreqId=0 "0^没有频次为1数据,请维护!"
	s priorId=$o(^OECPR(0,"Code","NORM",""))   //优先级
	q:+priorId=0 "0^没有临时医嘱优先级数据,请维护!"
	
	s retStr=0
	s oeoriStr=""
	s operCatalogueObj=##class(CIS.AN.OperCatalogue).%OpenId(opsId)
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
		.i phcdfId="" s freqId="",durId=""
		.s seqNo=$p(singleOeoriStr,$c(3),9)
		.s masterSeqNo=$p(singleOeoriStr,$c(3),10)
		.s oeprice=$p(singleOeoriStr,$c(3),11)
		.s packQty=$p(singleOeoriStr,$c(3),12)
		.s anaId=operCatalogueObj.ExtAnaestID
		.
		.s depProcNotes=$p(singleOeoriStr,$c(3),14)
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
		
	s retStr=##class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID,oeoriStr,userId,locId,docId)
	i $p(retStr,"^",1)=-1 s $p(retStr,"^",1,2)=$p(retStr,"^",2)
	q retStr
}

ClassMethod GetRecLoc(EpisodeID, arcimId) As %String
{
	s retStr=""
	s recLocStrList=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,arcimId)
	f j=1:1:$l(recLocStrList,$c(2)) d
		.s recLocStr=$p(recLocStrList,$c(2),j)
		.q:$p(recLocStr,$c(1),3)'="Y"
		.s retStr=$tr(recLocStr,$c(1),$c(3))
	q retStr
}

}
