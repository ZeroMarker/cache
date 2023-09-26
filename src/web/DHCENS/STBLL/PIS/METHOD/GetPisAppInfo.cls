Class web.DHCENS.STBLL.PIS.METHOD.GetPisAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—06-17
/// Description:获取病理申请单信息
/// Table：
/// Input：医嘱号
/// w ##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppInfo).SendAppBill("2463||10")
ClassMethod SendAppBill(OrdRowIDs As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.PIS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.PIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.PIS.MODEL.Body).%New()
	
    set ord = $P(OrdRowIDs,"||",1)
	set sub = $P(OrdRowIDs,"||",2)	
	set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	//接收科室信息
    set RecDeptCode=""
    set RecDeptRowID = $P(ordstr3,"^",6)
    set:RecDeptRowID'="" RecDeptCode = $p($g(^CTLOC(RecDeptRowID)),"^",1)    
    set arcimId = $P(ordstr1,"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    //医嘱项的代码与名称
    s ArcimCode=""
    s:arcimId'="" ArcimCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
	zn "PIS"
	set ReportStr=##class(PISApp.PISService).GetApplicationSheet(OrdRowIDs,"")
	zn "DHC-APP"
	set suCount=0,faCount=0,faInfo=""
	set Reportstream=##class(%GlobalCharacterStream).%New()
	d Reportstream.Write(ReportStr)
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Reportstream,.tDocument)
	d Reportstream.Rewind()
    if $$$ISERR(tSC) {
		s stream=##class(%GlobalCharacterStream).%New()
		d stream.Write("-1^"_$ze)
		Quit stream
	}
	else{
		set (RISRAppNum,TMPAADMDR,RISRSubmitDocCode,RISRSubmitDocDesc,TMAPPLICATIONDATE,TMAPPLICATIONTIME,RISRClinicalSymptoms,AppDeptDesc)=""
		set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTMASTER/TMROWID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set RISRAppNum=$tr(fieldValue,$c(0),"")
		}
	
		set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTMASTER/TMPAADMDR","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set TMPAADMDR=$tr(fieldValue,$c(0),"")
		}

		set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTMASTER/TMAPPLICATIONDOCTORDR","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRSubmitDocCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTMASTER/TMAPPLICATIONDOCTOR","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRSubmitDocDesc=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTMASTER/TMAPPLICATIONDATE","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set TMAPPLICATIONDATE=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTMASTER/TMAPPLICATIONTIME","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set TMAPPLICATIONTIME=$tr(fieldValue,$c(0),"")
		}

		set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTMASTER/TMCLINICRECORD","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRClinicalSymptoms=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTMASTER/TMAPPLICATIONDEPT","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set AppDeptDesc=$tr(fieldValue,$c(0),"")
		}
		set appBill=##class(web.DHCENS.STBLL.PIS.MODEL.PisAppInfo).%New()
		set appBill.RISRAppNum=RISRAppNum
		set appBill.PAADMVisitNumber=TMPAADMDR
		set appBill.PAADMEncounterTypeCode=$p(^PAADM(TMPAADMDR),"^",2)
		if TMPAADMDR'="" d
		.s patId=$p(^PAADM(TMPAADMDR),"^",1)
		.s:patId'="" appBill.PATPatientID=$p($g(^PAPER(patId,"PAT",1)),"^",1)
		set appBill.RISRMattersAttention=""
		set appBill.RISRSpecalMedicalRecord=""
		set appBill.RISRSubmitDocCode=RISRSubmitDocCode
		set appBill.RISRSubmitDocDesc=RISRSubmitDocDesc
		set appBill.RISRSubmitTime=TMAPPLICATIONDATE_" "_TMAPPLICATIONTIME
		set appBill.RISRAcceptDeptCode=RecDeptCode
		set appBill.RISRDeptLocation=""
		set appBill.RISRISEmergency=""
		set appBill.RISRClinicalSymptoms=RISRClinicalSymptoms
		set appBill.UpdateUserCode="demo"
		set appBill.UpdateDate=$zd(+$h,3)
		set appBill.UpdateTime=$zt($p($h,",",2))
		set appBill.AppDeptDesc=AppDeptDesc
		set ordObj=##class(web.DHCENS.STBLL.PIS.MODEL.Order).%New()
		set ordObj.OEORIOrderItemID=OrdRowIDs
		set ordObj.RISRPositionCode=""
		set ordObj.RISRPostureCode=""
		set ordObj.RISRCode=ArcimCode
		set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTSPECIMENS","count(TESTSPECIMEN)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			for i=1:1:hsCount {	
				set (SpecimenCode,SpecimenDesc,SpecimenTypeCode,SpecimenTypeDesc,TSROWID)=""	
				s SpecimenObj=##class(web.DHCENS.STBLL.PIS.MODEL.Specimen).%New()
				set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTSPECIMENS/TESTSPECIMEN["_i_"]/TSSPECIMENNO","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set SpecimenCode=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTSPECIMENS/TESTSPECIMEN["_i_"]/TSSPECIMENNAME","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set SpecimenDesc=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/ApplicationSheet/TESTSPECIMENS/TESTSPECIMEN["_i_"]/TSROWID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set TSROWID=$tr(fieldValue,$c(0),"")
				}
				s SpecimenObj.SpecimenCode=SpecimenCode
				s SpecimenObj.SpecimenDesc=SpecimenDesc
				s SpecimenObj.TSROWID=TSROWID
				
				d ordObj.Specimens.Insert(SpecimenObj)
			}   //for
			
			d appBill.OrderList.Insert(ordObj)
			set body.AppBills=appBill
		}   //if
	}   //else
	
	set request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	b ;b
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod GetPatOrdList(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $zt="Err"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		Quit "-1^"_tSC
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/PATCardNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set PATCardNo=tRes.GetAt(1).Value							
			set PATCardNo=$tr(PATCardNo,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/PATCardType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set PATCardType=tRes.GetAt(1).Value							
			set PATCardType=$tr(PATCardType,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/StartDate","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set StartDate=tRes.GetAt(1).Value							
			set StartDate=$tr(StartDate,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/EndDate","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set EndDate=tRes.GetAt(1).Value							
			set EndDate=$tr(EndDate,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/PAADMTypeCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set PAADMTypeCode=tRes.GetAt(1).Value							
			set PAADMTypeCode=$tr(PAADMTypeCode,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RISRAcceptDept","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set RISRAcceptDept=tRes.GetAt(1).Value							
			set RISRAcceptDept=$tr(RISRAcceptDept,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIStatusCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set OEORIStatusCode=tRes.GetAt(1).Value							
			set OEORIStatusCode=$tr(OEORIStatusCode,$c(0),"")
		}
	}
	b ;ordlist
	Set stream=..GetPatOrdListByCard(PATCardNo,PATCardType,StartDate,EndDate,PAADMTypeCode,RISRAcceptDept)
	q stream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	q stream
}

ClassMethod GetPatOrdListByCard(CardValue As %String, CardTypes As %String, StartDate As %String, EndDate As %String, EpsiodeType As %String, ExeLoc As %String) As %GlobalCharacterStream
{
	set request=##class(web.DHCENS.STBLL.PIS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.PIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.PIS.MODEL.Body).%New()
	set appBillList=##class(web.DHCENS.STBLL.PIS.MODEL.PISOrdInfo).%New()
	set RegisterNo=""
	if (CardTypes=1)
	{
			
		set OrRowid=$p(CardValue,"^",1)
		;set APPString=##Class(web.DHCAPPPisInterface).ToPisSystem(OrRowid)
		set APPString=##class(web.DHCDocAPPBL).ToPisSystem(OrRowid)

		set Mainobj=##class(web.DHCENS.STBLL.PIS.MODEL.PISAPPMainInfo).%New()
	
		set CardNo=""
		set admRowId=$p($g(^OEORD(+OrRowid)),"^",1)
		set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	
		set Mainobj.RegNo                         =$p(APPString,"^",1) 
		set Mainobj.Name                          =$p(APPString,"^",2) 
		set Mainobj.SexCode                       =$p(APPString,"^",3) 
		set Mainobj.Age                           =$p(APPString,"^",4) 
		set Mainobj.PatDeptCode                   =$p(APPString,"^",5) 
		set Mainobj.PatWardCode                   =$p(APPString,"^",6) 
		set Mainobj.PatBedNO                      =$p(APPString,"^",7) 
		set Mainobj.Telephone                     =$p(APPString,"^",8) 
		set Mainobj.BirthDay                      =$p(APPString,"^",9) 
		set Mainobj.Address                       =$p(APPString,"^",10) 
		set Mainobj.OrdDeptCode                   =$p(APPString,"^",11) 
		set Mainobj.FeeType                       =$p(APPString,"^",12) 
		set Mainobj.DocumentID                    =$p(APPString,"^",13) 
		set Mainobj.AppCode                       =$p(APPString,"^",14) 
		set Mainobj.AppName                       =$p(APPString,"^",15) 
		set Mainobj.OrdDoctorCode                 =$p(APPString,"^",16) 
		set Mainobj.OrdDoctorName                 =$p(APPString,"^",17) 
		set Mainobj.OrdDate                       =$p(APPString,"^",18) 
		set Mainobj.OrdTime                       =$p(APPString,"^",19) 
		set Mainobj.AdmRowID                      =$p(APPString,"^",20) 
		set cfrowid=""
		f  set cfrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",patRowId,cfrowid)) q:cfrowid=""  d
		.set ActiveFlag=$p($g(^DHCCARD("CF",cfrowid)),"^",10)
		.q:ActiveFlag'="N"
		.set Mainobj.OrdHospital=$p($g(^DHCCARD("CF",cfrowid)),"^",2)  
		
		s Length=$L(CardValue,"^")
		for i=1:1:Length
		{
			s TmpRowid=$p(CardValue,"^",i)
			s insObj=##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).GetAppBillByOrder(TmpRowid)
			d appBillList.PISOrdInfo.Insert(insObj)
		}
		Quit appBillList
	}
	elseif (CardTypes=2)
	{
		set RegisterNo=CardValue
	}
	elseif (CardTypes=3)
	{
		i ('($d(^DHCCARDi("CF",0,"CardNo",CardValue)))!(CardValue=""))
		{
			q MainObj
		}
		s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",CardValue,"")),CardTypeId=""
		s:CardRowid'="" CardTypeId=$p($g(^DHCCARD("CF",CardRowid)),"^",16)
		s:CardTypeId'="" CardType=$p($g(^DHCCARDTYPEDef(CardTypeId)),"^",1)
		// 通过就诊卡号得到病人登记号
		s RegisterNo=##class(web.DHCENS.Util.Common).GetRegNoByCardNo(CardValue,CardType)
	}
	elseif (CardTypes=4)
	{	
		i ('($d(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(CardValue)))!(CardValue="")))
		{
			q MainObj
		}
		set PAPMIRowId=$o(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(CardValue),""))
		s RegisterNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)
	}
	elseif (CardTypes=5)
	{
		q MainObj
	}
	elseif (CardTypes=6)
	{	
		i ('($d(^PAADMi("No",$$ALPHAUP^SSUTIL4(CardValue)))!(CardValue="")))
		{
			q MainObj
		}
		s PAADMDr=$o(^PAADMi("No",$$ALPHAUP^SSUTIL4(CardValue),0))
		set PAPMIRowId=$p($g(^PAADM(PAADMDr)),"^",1)
		s RegisterNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)
	}
	
	if (RegisterNo'="")
	{
		b ;reg
		s MainObj=..GetPatOrdListByPatID(RegisterNo,StartDate,EndDate,ExeLoc,EpsiodeType)
		b ;regm
	}
	b ;reg end
	do MainObj.XMLExportToStream(.stream)
	q stream
}

ClassMethod GetPatOrdListByPatID(RegisterNo As %String, StartDate As %String, EndDate As %String, ExeLoc As %String, EpsiodeType As %String) As web.DHCENS.STBLL.PIS.MODEL.Request
{
	Set $ZTrap = "SendMessageET"
	set request=##class(web.DHCENS.STBLL.PIS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.PIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.PIS.MODEL.Body).%New()	
	set Mainobj=##class(web.DHCENS.STBLL.PIS.MODEL.PISAPPMainInfo).%New()	
	
	s Flag=0
	if (StartDate="")||(EndDate="")||(ExeLoc="")  ;||(EpsiodeType="")
	{
		d OutLocation
	}
	else
	{
		i '$d(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegisterNo))) 
		{
			d OutLocation
		}
		s PISOrdObj=##class(web.DHCENS.STBLL.PIS.MODEL.PISOrdInfo).%New()
		s StartDate=$zdh(StartDate,3)
		s EndDate=$zdh(EndDate,3)
		s PaPatDR=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegisterNo),""))
		s AdmType="" f  s AdmType=$o(^PAPERdr(PaPatDR,"ADM",AdmType),-1) q:(AdmType="")  d  ;!(EpsiodeType'=AdmType)
		.s AdmDr="" f  s AdmDr=$o(^PAPERdr(PaPatDR,"ADM",AdmType,AdmDr)) q:AdmDr=""  d
	    ..s TmpStatus=$p($g(^PAADM(AdmDr)),"^",20)
		..q:TmpStatus'="A"	
		..s OeRowId=$o(^OEORD(0,"Adm",AdmDr,""))
		..q:OeRowId=""
		..s SubId=0 
		..f  s SubId=$o(^OEORD(OeRowId,"I",SubId)) q:SubId=""  d
		...s ordid=OeRowId_"||"_SubId
		...s BillState=$p($g(^OEORD(OeRowId,"I",SubId,3)),"^",5)
		...q:(BillState'="P")&&(AdmType'="I")
		...// 判断读取时间范围
		...s OrdDate=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",9)
		...q:(OrdDate<StartDate)||(OrdDate>EndDate)
		...// 判断医嘱状态				
		...s OrderStatusDr=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",13)
		...s tmpOrderStatus=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
		...q:tmpOrderStatus'="V"	
		...s DeptDr=$p($g(^OEORD(OeRowId,"I",SubId,3)),"^",6)
		...i DeptDr'="" d
		....s DeptCode=$p($g(^CTLOC(DeptDr)),"^",1)
		...e  d
		....s DeptCode=""
		...;w !,ordid_"^"_DeptCode_"^"_$p($g(^CTLOC(DeptDr)),"^",2)
		...q:(ExeLoc'[(DeptCode))	//可以有多个接受科室
		
		...s insObj=##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).GetAppBillByOrder(ordid)
		...d PISOrdObj.PISOrdInfo.Insert(insObj)
		
		set OrRowid=ordid
		;set APPString=##Class(web.DHCAPPPisInterface).ToPisSystem(OrRowid)
		set APPString=##class(web.DHCDocAPPBL).ToPisSystem(OrRowid)
		
		set CardNo=""
		set admRowId=$p($g(^OEORD(+OrRowid)),"^",1)
		set patRowId=$p($g(^PAADM(admRowId)),"^",1)
		
		set Mainobj.RegNo                         =$p(APPString,"^",1) 
		set Mainobj.Name                          =$p(APPString,"^",2) 
		set Mainobj.SexCode                       =$p(APPString,"^",3) 
		set Mainobj.Age                           =$p(APPString,"^",4) 
		set Mainobj.PatDeptCode                   =$p(APPString,"^",5) 
		set Mainobj.PatWardCode                   =$p(APPString,"^",6) 
		set Mainobj.PatBedNO                      =$p(APPString,"^",7) 
		set Mainobj.Telephone                     =$p(APPString,"^",8) 
		set Mainobj.BirthDay                      =$p(APPString,"^",9) 
		set Mainobj.Address                       =$p(APPString,"^",10) 
		set Mainobj.OrdDeptCode                   =$p(APPString,"^",11) 
		set Mainobj.FeeType                       =$p(APPString,"^",12) 
		set Mainobj.DocumentID                    =$p(APPString,"^",13) 
		set Mainobj.AppCode                       =$p(APPString,"^",14) 
		set Mainobj.AppName                       =$p(APPString,"^",15) 
		set Mainobj.OrdDoctorCode                 =$p(APPString,"^",16) 
		set Mainobj.OrdDoctorName                 =$p(APPString,"^",17) 
		set Mainobj.OrdDate                       =$p(APPString,"^",18) 
		set Mainobj.OrdTime                       =$p(APPString,"^",19) 
		set Mainobj.AdmRowID                      =$p(APPString,"^",20) 
		set cfrowid=""
		f  set cfrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",patRowId,cfrowid)) q:cfrowid=""  d
		.set ActiveFlag=$p($g(^DHCCARD("CF",cfrowid)),"^",10)
		.q:ActiveFlag'="N"
		.set Mainobj.OrdHospital=$p($g(^DHCCARD("CF",cfrowid)),"^",2)
		s Mainobj.OrdListInfo=PISOrdObj
		s body.PISAppBills=Mainobj
		s request.body=body
		d OutLocation
	}
OutLocation
	q request
SendMessageET
	b ;$ze
	set request=##class(web.DHCENS.STBLL.PIS.MODEL.Request).%New()
    Quit request
}

/// w ##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppInfo).Test()
ClassMethod Test() As %String
{
	s $zt="Err"
	;s input="<Request><Header><SourceSystem>SYS0004</SourceSystem> <!--来源系统代码--><MessageID>MES0028</MessageID> <!--消息ID--></Header><Body><PATCardNo>0000000060</PATCardNo> <!--就诊卡号--><PATCardType>2</PATCardType> <!--卡类型：1:医嘱rowid,2:登记号,3:就诊卡号,4:病案号，5:预留未使用,6:就诊号，根据项目需要自行处理--><StartDate>2020-07-15</StartDate> <!--开始日期yyyy-MM-dd--><EndDate>2020-07-15</EndDate> <!--结束日期yyyy-MM-dd--><PAADMTypeCode>I</PAADMTypeCode> <!--就诊类型：I:住院，O:门诊，I:急诊，H:体检--><RISRAcceptDept>ZYYJ013</RISRAcceptDept> <!--接收科室（可以有多个接收科室，格式为：代码@名称#代码@名称--><OEORIStatusCode>V</OEORIStatusCode> <!--状态：审核（V），执行（E），全部（A）--></Body></Request>"
	s input="<Request><Header><SourceSystem>SYS0004</SourceSystem> <!--来源系统代码--><MessageID>MES0028</MessageID> <!--消息ID--></Header><Body><PATCardNo>0000000048</PATCardNo> <!--就诊卡号--><PATCardType>2</PATCardType> <!--卡类型：1:医嘱rowid,2:登记号,3:就诊卡号,4:病案号，5:预留未使用,6:就诊号，根据项目需要自行处理--><StartDate>2020-07-21</StartDate> <!--开始日期yyyy-MM-dd--><EndDate>2020-07-21</EndDate> <!--结束日期yyyy-MM-dd--><PAADMTypeCode>I</PAADMTypeCode> <!--就诊类型：I:住院，O:门诊，I:急诊，H:体检--><RISRAcceptDept>ZYYJ013@病理科</RISRAcceptDept> <!--接收科室（可以有多个接收科室，格式为：代码@名称#代码@名称--><OEORIStatusCode>V</OEORIStatusCode> <!--状态：审核（V），执行（E），全部（A）--></Body></Request>"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(input)
	s rtn=..GetPatOrdList(stream)
	q rtn.Read()
Err
	q "-1^"_$ze
}

}
