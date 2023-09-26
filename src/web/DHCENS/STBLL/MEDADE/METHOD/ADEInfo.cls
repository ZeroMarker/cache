Class web.DHCENS.STBLL.MEDADE.METHOD.ADEInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：医疗安全不良事件系统（HIS和不良事件分库）患者基本信息、就诊信息同步
/// Table：
/// Input：
/// Output:应答xml消息
/// <Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><Starttime></Starttime><Endtime></Endtime><encounterId>1702</encounterId></Body></Request>
/// Debug:w ##class(web.DHCENS.STBLL.MEDADE.METHOD.ADEInfo).GetPatAdmInfo("")
ClassMethod GetPatAdmInfo(InputStream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
{
	try{
		set response=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPatientRp).%New()
		set header=##class(web.DHCENS.STBLL.MEDADE.MODEL.Header).%New()
		set header.SourceSystem="01"
		set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
		set response.Header=header
		set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
		set stream=##class(%Stream.GlobalCharacter).%New()
		if $$$ISERR(tSC)
		{
			do stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_tSC_"]]></ResultContent></Body></Response>")
		}
		else{
			set startTime=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/Starttime","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set startTime=$tr(fieldValue,$c(0),"")
			}	
			set endTime=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/Endtime","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set endTime=$tr(fieldValue,$c(0),"")
			}	
			set encounterId=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/encounterId","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set encounterId=$tr(fieldValue,$c(0),"")
			}	
			
			if encounterId'=""
			{
				d GetAdmInfo
				s ObjList=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPatientRtList).%New()
				d ObjList.SynPatientRtList.Insert(obj)
				s response.Body=ObjList
				d response.XMLExportToStream(.stream)
			}
			else{
				s stDate=$p(startTime," ",1),stTime=$p(startTime," ",2)
				s edDate=$p(endTime," ",1),edTime=$p(endTime," ",2)
				s dateH=$zdh(stDate,3),edDateH=$zdh(edDate,3)
				s date=dateH-1
				s ObjList=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPatientRtList).%New()
				s timeH=$zth(stTime,3),edTimeH=$zth(edTime,3)
				s time=timeH-1
				for  
				{
					s date=$o(^PAADMi("PAADM_DateTime",date)) 
					q:date>edDateH  
					q:date=""
					for 
					{
						s time=$o(^PAADMi("PAADM_DateTime",date,time))
						q:(time>edTimeH)&&(date>=edDateH)
						q:time=""
						s encounterId=$o(^PAADMi("PAADM_DateTime",date,time,""))
						d GetAdmInfo
						d ObjList.SynPatientRtList.Insert(obj)
					}
				}
				s dateD=dateH-1
				for  
				{
					s dateD=$o(^PAADMi("DischDate",dateD)) 
					q:dateD>edDateH  
					q:dateD=""
					s rowid=""
					for 
					{
						s rowid=$o(^PAADMi("DischDate",dateD,rowid))
						q:rowid=""
						s timeD=$p($g(^PAADM(rowid)),"^",18)
						continue:(timeD<timeH)&&(date=dateH)
						q:(timeD>edTimeH)&&(dateD>=edDateH)
						s encounterId=rowid
						d GetAdmInfo
						d ObjList.SynPatientRtList.Insert(obj)
					}
				}
				s response.Body=ObjList
				d response.XMLExportToStream(.stream)
			}
		}
	}
	catch
	{
		s $zt=""
	}
	q stream
GetAdmInfo
	set obj=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPatientRt).%New()
	set patRowId=$p($g(^PAADM(encounterId)),"^",1)
	set obj.encounterSource=$p($g(^PAADM(encounterId)),"^",2)
	set obj.patientName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set obj.encounterId=encounterId
	set obj.patMediNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set sexRowId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	set obj.patGenderCode=sexRowId
	set:sexRowId'="" obj.patGenderDesc=$p($g(^CT("SEX",sexRowId)),"^",2)
	set obj.patientAge=##class(web.DHCBillInterface).GetPapmiAge(patRowId,encounterId)
	set birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set:birthDay'="" obj.patBirthDate=$zd(birthDay,3)
	set obj.patMobPhone=$p($g(^PAPER(patRowId,"PER",1)),"^",11)
	set nationRowID="",nationCode="",nationDesc=""
	set nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
	set obj.patNationCode=nationRowID
	set:nationRowID'="" obj.patNationDesc=$p($g(^CT("NAT",nationRowID)),"^",2)
	set mrAdmId=$p($g(^PAADM(encounterId)),"^",61)
	set obj.vitalSignWeight=$p($g(^MR(+mrAdmId,"PRO",1)),"^",27)
	set obj.inpatientTimes=$p($g(^PAADM(encounterId)),"^",29)
	set locDr=$p($g(^PAADM(encounterId)),"^",4)
	set obj.encDeptId=locDr
	set:locDr'="" obj.encDeptCode=$p($g(^CTLOC(locDr)),"^",1)
	set:locDr'="" obj.encDeptDesc=$p($g(^CTLOC(locDr)),"^",2)
	set encDocId=$p($g(^PAADM(encounterId)),"^",9)
	set:encDocId'="" obj.encDocCode=$p($g(^CTPCP(encDocId,1)),"^",1)
	set:encDocId'="" obj.encDocName=$p($g(^CTPCP(encDocId,1)),"^",2)				
	set admDate=$p($g(^PAADM(encounterId)),"^",6)
	set:admDate'="" obj.encounterDate=$zd(admDate,3)
	set admTime=$p($g(^PAADM(encounterId)),"^",7)
	set:admTime'="" obj.encounterTime=$zt(admTime)
	set dischargeDate=$p($g(^PAADM(encounterId)),"^",17)
	set:dischargeDate'="" obj.dischargeDate=$zd(dischargeDate,3)
	set dischargeTime=$p($g(^PAADM(encounterId)),"^",18)
	set:dischargeTime'="" obj.dischargeTime=$zt(dischargeTime)
	set occupationRowID=$P($G(^PAPER(patRowId,"PER",2)),"^",6)
	set obj.patOccuCode=occupationRowID
	set:occupationRowID'="" obj.patOccuDesc=$p($g(^CT("OCC",occupationRowID)),"^",2)
	set admReaonDr=$p($g(^PAADM(encounterId,1)),"^",7)
	set:admReaonDr'="" obj.medicalType=$p($g(^PAC("ADMREA",admReaonDr)),"^",2)
	set mrdiachildsub=$o(^MR(mrAdmId,"DIA","0")),mricdCode="",mricdDesc=""
	if mrdiachildsub'=""
	{
		set mricdid = $p($g(^MR(mrAdmId,"DIA",mrdiachildsub)),"^",1)
		if (mricdid="") {
		   set mricdCode=""
		   set mricdDesc=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
		}
		else {
		   set mricdCode = $p($g(^MRC("ID",mricdid)),"^",1)
		   set mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
		}
	}
	set obj.diagnoseCode=mricdCode
	set obj.diagnoseDesc=mricdDesc
	set obj.patientDegree=""
	set obj.patientId=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	
	set CurrentBedRowID=$P($g(^PAADM(encounterId)),"^",73)
	i ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)
	{
		s BedWordRowID = $p(CurrentBedRowID,"||",1)
		s BedChildSub = $p(CurrentBedRowID,"||",2)
		i $d(^PAWARD(BedWordRowID,"BED"))=10
		{
			s obj.currBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
		}
	}
	set obj.flag="A"
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：医疗安全不良事件系统（HIS和不良事件分库）护理信息同步
/// Table：
/// Input：
/// Output:应答xml消息
/// Debug:
/// <Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><encounterId>1708</encounterId><enDate>2022-12-21</enDate></Body></Request>
/// w ##class(web.DHCENS.STBLL.MEDADE.METHOD.ADEInfo).SynchNurInfor("")
ClassMethod SynchNurInfor(InputStream As %Stream.GlobalCharacter) As %String
{
	try{
		set rtn=""
		set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
		if $$$ISERR(tSC)
		{
			s rtn="<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_tSC_"]]></ResultContent></Body></Response>"
		
		}
		else{		
			set encounterId=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/encounterId","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set encounterId=$tr(fieldValue,$c(0),"")
			}	
			set enDate=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/enDate","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set enDate=$tr(fieldValue,$c(0),"")
			}	
			if (encounterId="")||(enDate="")
			{
				s rtn="<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>就诊号或查询结束日期不能为空</ResultContent></Body></Response>"
			}
			s rtn=##class(NurMp.Sources.RecordInterface).SynchNurInfor(encounterId,enDate)
		}
	}
	catch
	{
		s $zt=""
	}
	q rtn
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：医疗安全不良事件系统（HIS和不良事件分库）药品信息同步
/// Table：
/// Input：
/// Output:应答xml消息
/// Debug:
/// <Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><encounterId>1708</encounterId></Body></Request>
/// w ##class(web.DHCENS.STBLL.MEDADE.METHOD.ADEInfo).SynPrescInfo("")
ClassMethod SynPrescInfo(InputStream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
{
	try{
		set response=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPrescRp).%New()
		set header=##class(web.DHCENS.STBLL.MEDADE.MODEL.Header).%New()
		set header.SourceSystem="01"
		set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
		set response.Header=header
		set rtn=""
		set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
		set stream=##class(%Stream.GlobalCharacter).%New()
		if $$$ISERR(tSC)
		{
			do stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_tSC_"]]></ResultContent></Body></Response>")
		}
		else{		
			set encounterId=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/encounterId","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set encounterId=$tr(fieldValue,$c(0),"")
			}	
			
			if (encounterId="")
			{
				s rtn="<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>就诊号或查询结束日期不能为空</ResultContent></Body></Response>"
				d stream.Write(rtn)
			}
			set objList=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPrescRtList).%New()
			set ord=$O(^OEORD(0,"Adm",encounterId,""))
			set sub=0 
			s dosqty=""
			f  set sub=$o(^OEORD(ord,"I",sub)) q:sub=""  d
			.set Oeori=ord_"||"_sub
			.set Arcim=$p($g(^OEORD(ord,"I",sub,1)),"^",2)
			.q:Arcim=""
			.set ItemCatDR=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10)
 			.set OrderType=$p($g(^ARC("IC",ItemCatDR)),"^",7)
 			.q:OrderType'="R"
 			.s stDate=$p(^OEORD(ord,"I",sub,3),"^",7)
			.s stTime=$p(^OEORD(ord,"I",sub,1),"^",17)
			.q:stDate>+$h
			.q:(stTime>$p($h,",",2))&&(stDate=+$h)
			.q:'$d(^DHCOEDISQTY(0,"OEORI",Oeori))
			.set DspRowId="",DspStatus=""
			.f  set DspRowId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,DspRowId)) q:(DspRowId="")  d
			..set DspStatus=$p($g(^DHCOEDISQTY(DspRowId)),"^",7)
			..q:DspStatus'="C"
			..set obj=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPrescRt).%New()
			..set Qty=$p($g(^DHCOEDISQTY(DspRowId)),"^",5)
			..set ArcimDr=$p($g(^OEORD(ord,"I",sub,1)),"^",2),Inci="",QtyUomId="",QtyUom="",PhQtyOrd="",StartDateTime="",dosqty=""
			..set:ArcimDr'="" Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcimDr,"||",1),""))
			..set:ArcimDr'="" obj.orderCode=$p($g(^ARCIM($p(ArcimDr,"||",1),$p(ArcimDr,"||",2),1)),"^",1)
			..set:ArcimDr'="" obj.orderDesc=$p($g(^ARCIM($p(ArcimDr,"||",1),$p(ArcimDr,"||",2),1)),"^",2)
			..s ItmRemark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(Inci)  //批准文号
			..set obj.approvalNumber=ItmRemark
			..set obj.commodityName=$p($g(^INCI(Inci,1)),"^",2)
			..set obj.medGeneDesc=""
			..set:Inci'="" QtyUomId=$p($g(^INCI(Inci,1)),"^",10)
			..Set PHCGeneID=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),8)),"^",20)
			..Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)	//处方通用名
			..s Add=$o(^DHCITMINFO(0,"INCI",Inci,"")) 
			..q:Add=""
			..s ManfId=$p($G(^DHCITMINFO(Add)),"^",48)
			..s:ManfId'="" ManfCode=$P(^PHMNF(ManfId),"^",1)
			..s:ManfId'="" ManfDesc=$P(^PHMNF(ManfId),"^",2)
			..s obj.medicineManufacturer=ManfDesc
			..s Sub="0"
			..f  s Sub=$o(^INCI(Inci,"IL",Sub)) q:Sub=""  d
			...s Incil=Inci_"||"_Sub
			...s LB=0
			...f  s LB=$o(^INCI(Inci,"IL",Sub,"LB",LB))  q:LB=""  d
			....s inclb=Inci_"||"_Sub_"||"_LB
			....s IngrSub=..GetIngrtSubByClb(inclb)
			....s Ingr=+IngrSub,ChiSub=$p(IngrSub,"||",2)
			....s manulotnum=$p(^DHCINGR(Ingr,"GRI",ChiSub),"^",13)	
			....s obj.medBatNo=manulotnum
			....s apc=$p(^DHCINGR(Ingr),"^",3),apcname=""
			....s:apc'="" apcname=$p(^APC("APCVM",apc),"^",3)         //供应商
			....set obj.medicineVendor=apcname
			..set OEORIInstrDR=$p(^OEORD(ord,"I",sub,2),"^",7),OEORIInstrDesc=""	//用法DR
			..set:OEORIInstrDR'="" OEORIInstrDesc=$p(^PHCIN(OEORIInstrDR),"^",2)
			..set obj.medUsageDesc=OEORIInstrDesc
			..set:QtyUomId'="" QtyUom=$p($g(^CT("UOM",QtyUomId)),"^",1)
			..;单次剂量，剂量单位，总剂量
    		..S dosqty=$P(^OEORD(ord,"I",sub,2),"^",1)
    		..s obj.medicineDosage=dosqty
			..S dosuomdr=$P(^OEORD(ord,"I",sub,2),"^",3),dosuom=""
			..I dosuomdr'="" D
			...I $D(^CT("UOM",dosuomdr)) S dosuom=$P(^CT("UOM",dosuomdr),"^",1)
			..q:dosuom="" 
			..s obj.medDosUnitCode=dosuom
			..s PhQtyOrd=$p(^OEORD(ord,"I",sub,1),"^",12) //药物使用-总剂量
			..set obj.orderQuantity=PhQtyOrd
			..set StartDateTime=$zd($p(^OEORD(ord,"I",sub,3),"^",7),3)_" "_$zt($p(^OEORD(ord,"I",sub,1),"^",17))
			..set obj.ordStartTime=StartDateTime
			..set EndDateTime=""
			..s XDate=$p(^OEORD(ord,"I",sub,3),"^",34)
			..s XTime=$p(^OEORD(ord,"I",sub,2),"^",15)
			..i XDate'=""  s EndDateTime=$zd(XDate,3)_" "_$zt(XTime)
			..set obj.ordEndTime=EndDateTime
			..set obj.medicalReasons=$g(^OEORD(ord,"I",sub,"REM"))
			..set obj.medSpecId=$p($G(^DHCITMINFO(Add)),"^",27)
			..set arcimId = $p($g(^OEORD(ord,"I",sub,1)),"^",2)
    		..set arcSub = $p(arcimId,"||",1)
    		..set arcVer = $p(arcimId,"||",2)
    		..//药物剂型代码
			..s phcFormCode="",phcForm=""
			..s phcdfdr=$p(^ARCIM(arcSub,arcVer,1),"^",12)
			..s phcdfdr=$p(^PHCD(+phcdfdr,"DF",$p(phcdfdr,"||",2),1),"^",1)
			..i phcdfdr'=""  d
			..s phcForm=$p($g(^PHCF(phcdfdr)),"^",2)   ;PHC_Form
			..s phcFormCode=$p($g(^PHCF(phcdfdr)),"^",1)
			..s phcFormDesc=$p($g(^PHCF(phcdfdr)),"^",2)
			..set:phcFormDesc'="" obj.medGeneDesc=PHCGeneDesc_"("_phcFormDesc_")"
			..set obj.medDoseFormId=phcForm
			..set obj.medDoseFormCode=phcFormCode
			..set obj.medDoseFormDesc=phcFormDesc
			..set obj.flag="A"
			..set freqRowID = $p($g(^OEORD(ord,"I",sub,2)),"^",4)
			..set:freqRowID'="" obj.medFreqCode=$P($g(^PHCFR(freqRowID)),"^",1)
			..set:freqRowID'="" obj.medFreqDesc=$P($g(^PHCFR(freqRowID)),"^",4)
	
			..d objList.SynPrescRtList.Insert(obj)
			set respObj=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPrescRp).%New()
			set respObj.Body=objList
			s stream=##class(%GlobalCharacterStream).%New()
			d respObj.XMLExportToStream(.stream)
		}
	}
	catch
	{
		s $zt=""
	}
	q stream
}

/// Description: 根据Inclb取入库子表id
/// Debug: w ##class(PHA.FACE.OUT.WFYPSCBASE).GetIngrtSubByClb("1","1")
ClassMethod GetIngrtSubByClb(inclb) As %Library.String
{
	q:$g(inclb)="" ""
	s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	s IngrtSub=""
	s Ingrt=$o(^DHCINGR(0,"GRI_INCIB",incib,""),-1)
 	i Ingrt d
 	.s ChiSub=$o(^DHCINGR(0,"GRI_INCIB",incib,Ingrt,""))
	.s IngrtSub=Ingrt_"||"_ChiSub
	e  d
	.s incib=##Class(web.DHCSTCOMINC).GetLastIncib(+incib,2,+$h)
	.s Ingrt=$o(^DHCINGR(0,"GRI_INCIB",incib,""),-1)
	.q:Ingrt=""
	.s ChiSub=$o(^DHCINGR(0,"GRI_INCIB",incib,Ingrt,""))
	.s IngrtSub=Ingrt_"||"_ChiSub
	q IngrtSub
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：医疗安全不良事件系统（HIS和不良事件分库）输血信息同步
/// Table：
/// Input：
/// Output:应答xml消息
/// Debug:
/// <Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><encounterId>171</encounterId></Body></Request>
/// w ##class(web.DHCENS.STBLL.MEDADE.METHOD.ADEInfo).SynPatInfusionInfo("")
ClassMethod SynPatInfusionInfo(InputStream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
{
	try{
		set response=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPatInfusionRp).%New()
		set header=##class(web.DHCENS.STBLL.MEDADE.MODEL.Header).%New()
		set header.SourceSystem="01"
		set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
		set response.Header=header
		set rtn=""
		set stream=##class(%Stream.GlobalCharacter).%New()
		set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
		if $$$ISERR(tSC)
		{
			set stream=##class(%Stream.GlobalCharacter).%New()
			do stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_tSC_"]]></ResultContent></Body></Response>")
		}
		else{		
			set encounterId=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/encounterId","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set encounterId=$tr(fieldValue,$c(0),"")
			}	
			
			if (encounterId="")
			{
				s rtn="<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>就诊号或查询结束日期不能为空</ResultContent></Body></Response>"
				d stream.Write(rtn)
			}
			set objList=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPatInfusionRtList).%New()
			set rset=##class(%ResultSet).%New("DHCLIS.DHCBloodInterface:QryPatInfusionInfo")
			set rs=rset.Execute(encounterId)
			while (rset.Next()) 
			{
				s obj=##class(web.DHCENS.STBLL.MEDADE.MODEL.SynPatInfusionRt).%New()
				s obj.encounterId=encounterId
				s obj.bloodTransfusionNumber=rset.Data("PackID")
				s obj.bloodComponents=rset.Data("BloodProduct")
				s obj.bloodType=rset.Data("ABOType")
				s obj.rhd=rset.Data("RHType")
				s obj.bloodAmount=rset.Data("PackSize")
				s obj.bloodTranStartTime=rset.Data("InfusionStartDT")
				s obj.bloodTranEndTime=rset.Data("InfusionEndDT")
				s obj.flag="A"
				d objList.SynBloodRtList.Insert(obj)
			}
			s response.Body=objList
		}
		d response.XMLExportToStream(.stream)
	}
	catch
	{
		s $zt=""		
	}
	q stream
}

}
