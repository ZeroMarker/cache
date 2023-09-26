Class DHCDoc.OPDoc.PatientList Extends DHCDoc.Util.RegisteredObject
{

ClassMethod DocRegList(userId As %String, locId As %String) As %String
{
	q:((userId="")||(locId="")) ""
	s langid=..%LanguageID()
	s docId=$P(^SSU("SSUSR",userId),"^",14)
	q:docId="" ""
	s json="["
	s (ret,Default)=""
	s count=0
	s markRowId=0 
	f  s markRowId=$o(^User.DHCMarkDocI("MarkdDocMarkIndex",docId,markRowId))  q:markRowId=""  d
	.s flag=0
	.s id="" f  s id=$o(^User.DHCMarkDocI("MarkdDocMarkIndex",docId,markRowId,id)) q:(id="")||(flag=1)  d
	..s markDepId=$list(^User.DHCMarkDocD(id),4)
        ..s Default=$list(^User.DHCMarkDocD(id),5)
        ..s:Default'=1 Default=""
	..i markDepId=locId s flag=1
	.q:flag=0
	.s id=0,findActiveResId=""
	.f  s id=$o(^RB("RES",0,"CTPCP",markRowId,locId,id)) q:id=""  d
	..s DateActiveFrom=$p(^RB("RES",id),"^",22)
	..q:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
	..s DateActiveTo=$p(^RB("RES",id),"^",23)
	..q:(DateActiveTo'="")&&(DateActiveTo<+$h)
	..s findActiveResId=id
	.q:findActiveResId=""
	.s st=$p(^RB("RES",findActiveResId),"^",6)
	.q:st'="Y"
	.s markDesc=$p($g(^CTPCP(markRowId,1)),"^",2)
	.Set markDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",markDesc,langid)
	.if count>0 s json=json_","
	.s json=json_"{""id"":"""_markRowId_""",""des"":"""_markDesc_""",""selected"":"""_Default_"""}"
	.s count=count+1
	q json_"]"
}

// w ##class(DHCDoc.OPDoc.PatientList).GessCardType("000001036766")

ClassMethod GessCardType(cardValue As %String)
{
	s count=0
	s myTypeID=0
	s myDataFlag=0
	s SessionStr=##class(web.DHCBL.Configure.PatEnroll).DHCGetDefaultSystemSession()
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	s myHospitalID=$p(SessionStr,"^",5)
	Set langid=..%LanguageID()
	s json="["
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.//判断卡类型是否给该院区授权
	.s Flag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",myTypeID,myHospitalID,+$H)
	.q:Flag'="Y"
	.s mydes=##class(User.DHCCardTypeDef).GetTranByDesc("CTDDesc",mydes,langid)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  s mySelFlag=1
	.q:(+myFindFlag=0)
	.s checkdValue= ..CheckCardValue(myTypeID,cardValue)
	.q:checkdValue=""
	.s cfRowId=0
	.f  s cfRowId=$o(^DHCCARDi("CF",0,"CardTypeNo",myTypeID,checkdValue,cfRowId)) q:cfRowId=""  d
	..s papmiNo=$p(^DHCCARD("CF",cfRowId),"^",6)
	..s CFActiveFlag=$p($g(^DHCCARD("CF",cfRowId)),"^",10)
	..q:CFActiveFlag'="N"
	..s SecurityNo=$P(^DHCCARD("CF",cfRowId),"^",3)
	..s SecurityNo=##class(web.UDHCAccEnrypt).Decrypt(SecurityNo)
	..i count>0 s json=json_","
	..s json=json_"{""cardTypeId"":"""_myTypeID_""",""cardDesc"":"""_mydes_""",""checkdValue"":"""_checkdValue_""",""papmiNo"":"""_papmiNo_""",""SecurityNo"":"""_SecurityNo_"""}"
	..s count=count+1
	q json_"]"
}

// d ##class(DHCDoc.OPDoc.PatientList).CheckCardValue("1","1")

ClassMethod CheckCardValue(cardTypeId As %String, cardNo As %String) As %String [ Private ]
{
	q:( (cardTypeId="") || ('$d(^DHCCARDTYPEDef(cardTypeId))) ) ""
	s ls=^DHCCARDTYPEDef(cardTypeId)
	s len=$p(ls,"^",17)
	for i=$l(cardNo)+1:1:(+len) {
		s cardNo="0"_cardNo
	}
	if '$d(^DHCCARDi("CF",0,"CardNo",cardNo)) s cardNo=""
	if cardNo'="",'$d(^DHCCARDi("CF",0,"CardTypeNo",cardTypeId,cardNo)) s cardNo=""
	q cardNo
}

// d ##class(DHCDoc.OPDoc.PatientList).GetOPHandleStatusData("1981","JSON")

ClassMethod GetOPHandleStatusData(EpisodeID, format = "JSON", ByRef list = "") As %String
{
	s HospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	try{
		d ##class(DHCDoc.OPDoc.PatientList).GetOPHandleData(EpisodeID,"",.opMap,HospitalId)
	}catch(e){
		zn "dhc-app"
		k opMap
	}
	s list=$lb()
	if '$d(opMap) d
	.s list=$lb("","","","")
	if ($d(opMap("DisDrugs"))) d
	.s code="DisDrugs"
	.s opMap(code)=$g(opMap(code),"")_"S3"
	.s OrdType=##class(websys.Translation).Get("opdoc.patient.list.csp","药品")
	.s StatuType=##class(websys.Translation).Get("opdoc.patient.list.csp","已发药")
	.s opMap(code,"$Des")=OrdType_"<span style='color:yellow'>("_StatuType_")</span>"_":"
	.s $list(list,1)=$lg(list,1)_"S3"
	if ($d(opMap("UnDisDrugs"))) d
	.s code="UnDisDrugs"
	.s opMap(code)=$g(opMap(code),"")_"S1"
	.s OrdType=##class(websys.Translation).Get("opdoc.patient.list.csp","药品")
	.s StatuType=##class(websys.Translation).Get("opdoc.patient.list.csp","未发药")
	.s opMap(code,"$Des")=OrdType_"<span style='color:yellow'>("_StatuType_")</span>"_":"
	.s $list(list,1)=$lg(list,1)_"S1"
	if (('$d(opMap("DisDrugs"))) && ('$d(opMap("UnDisDrugs")))) d
	.s $list(list,1)=$lg(list,1)_"S0"
	if ($d(opMap("AbnormalLab"))) d
	.s code="AbnormalLab"
	.s opMap(code)=$g(opMap(code),"")_"S3"
	.s OrdType=##class(websys.Translation).Get("opdoc.patient.list.csp","化验")
	.s StatuType=##class(websys.Translation).Get("opdoc.patient.list.csp","异常结果")
	.s opMap(code,"$Des")=OrdType_"<span style='color:yellow'>("_StatuType_")</span>"_":"
	.s $list(list,2)=$lg(list,2)_"S3"
	if ($d(opMap("NotLabReport"))) d
	.s code="NotLabReport"
	.s opMap(code)=$g(opMap(code),"")_"S2"
	.s OrdType=##class(websys.Translation).Get("opdoc.patient.list.csp","化验")
	.s StatuType=##class(websys.Translation).Get("opdoc.patient.list.csp","未做")
	.s opMap(code,"$Des")=OrdType_"<span style='color:yellow'>("_StatuType_")</span>"_":"
	.s $list(list,2)=$lg(list,2)_"S2"
	if (('$d(opMap("AbnormalLab"))) && ('$d(opMap("NotLabReport")))) d
	.s $list(list,2)=$lg(list,2)_"S0"
	if ($d(opMap("AbnormalExam"))) d
	.s code="AbnormalExam"
	.s opMap("AbnormalExam")="S3"
	.s OrdType=##class(websys.Translation).Get("opdoc.patient.list.csp","检查")
	.s StatuType=##class(websys.Translation).Get("opdoc.patient.list.csp","结果")
	.s opMap(code,"$Des")=OrdType_"<span style='color:yellow'>("_StatuType_")</span>"_":"
	.s $list(list,3)=$lg(list,3)_"S3"
	if ($d(opMap("NotExamReport"))) d
	.s code="NotExamReport"
	.s opMap(code)=$g(opMap(code),"")_"S2"
	.s OrdType=##class(websys.Translation).Get("opdoc.patient.list.csp","检查")
	.s StatuType=##class(websys.Translation).Get("opdoc.patient.list.csp","未做")
	.s opMap(code,"$Des")=OrdType_"<span style='color:yellow'>("_StatuType_")</span>"_":"
	.s $list(list,3)=$lg(list,3)_"S2"
	if (('$d(opMap("AbnormalExam"))) && ('$d(opMap("NotExamReport")))) d
	.s $list(list,3)=$lg(list,3)_"S0"
	if ($d(opMap("TreatItem"))) d
	.s code="TreatItem" //"TreatItemStatus"
	.s opMap(code)=$g(opMap(code),"")_"S1"
	.s OrdType=##class(websys.Translation).Get("opdoc.patient.list.csp","治疗")
	.s opMap(code,"$Des")=OrdType_":"
	.s $list(list,4)=$lg(list,4)_"S1"
	/*else  d
	.s code="TreatItem"
	.s opMap(code)=$g(opMap(code),"")_"S0"
	.s opMap(code,"$Des")="治疗"
	.s $list(list,4)=$lg(list,4)_"S0"*/
	if format="JSON" d
	.s ci=0
	.s str= "["
	.s code="" f  s code=$o(opMap(code)) q:code=""  d
	..s:ci>0 str=str_ ","
	..s ci=ci+1
	..s ii=0
	..s str=str_ "{""status"":"""_opMap(code)_""",""field"":"""_code_""",""des"":"""_opMap(code,"$Des")_""",""list"":["
	..s ind="" f  s ind=$o(opMap(code,ind)) q:ind=""  d
	...q:$e(ind,1)="$"
	...s v=opMap(code,ind)
	...q:v=""
	...s:ii>0 str=str_","
	...s ii=ii+1
	...s str=str_ """"_##class(DHCDoc.Util.FormatData).Escape(v)_""""
	..s str=str_ "]"
	..s str=str_ "}"
	.s str=str_ "]"
	else  d
	.s str=""
	q str
}

// d ##class(DHCDoc.OPDoc.PatientList).GetOutPatientListColSet(.a)

ClassMethod GetOutPatientListColSet(ByRef ConfigAry As %String)
{
	
	s Count=0
	set rs=##Class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	s len=rs.GetColumnCount()
	f i=1:1:len {
		set name=rs.GetColumnName(i)
		set ColumnExtInfo=rs.GetColumnHeader(i)
		
		#; d colDefine.add(rs.GetColumnName(i))
		#; s colDefine.map(rs.GetColumnName(i),"Type")=rs.GetColumnType(i)
		set caption=$p(ColumnExtInfo,"$",1)
		set width=$p(ColumnExtInfo,"$",2)
		set Type=rs.GetColumnType(i)
		if caption="" set caption=name
		s nameTrans=##class(websys.Translation).Get("opdoc.patient.list.csp",caption)
		#;如果name翻译过,列头走翻译
		if name'=nameTrans Set caption = nameTrans
		if caption="" set caption=name
		s hidden="N",sort="N"
		if width="" s width=80
		s Count=Count+1
		s ConfigAry(Count)=name_"^"_caption_"^"_Count_"^"_width_"^"_hidden_"^"_sort_"^^"_Type
	}
	s Count=Count+1
	s ConfigAry(Count)="DrugsStatus^药品^"_Count_"^70^N^N^^10"
	s Count=Count+1
	s ConfigAry(Count)="LaboratoryStatus^化验^"_Count_"^70^N^N^^"
	s Count=Count+1
	s ConfigAry(Count)="InspectStatus^检查^"_Count_"^70^N^N^^"
	s Count=Count+1
	s ConfigAry(Count)="TreatmentStatus^治疗^"_Count_"^70^N^N^^"
	s Count=Count+1
	s ConfigAry(Count)="TransEpisodeID^转诊^"_Count_"^70^N^N^^"
	s Count=Count+1
	s ConfigAry(Count)="CancleEpisodeID^取消接诊^"_Count_"^70^N^N^^"

	
	q
}

ClassMethod OutPatientList(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String, MarkID As %String = "", CheckName As %String = "", PatSeqNo As %String = "") As %String
{
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	s ^tempscl("OutPatientList12")=LocID_","_UserID_","_IPAddress_","_AllPatient_","_PatientNo_","_SurName_","_StartDate_","_EndDate_","_ArrivedQue_","_RegQue_","_Consultation_","_MarkID_","_CheckName_","_PatSeqNo
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, CheckName,PatSeqNo)
	s colDefine=##class(DHCDoc.Util.MapIndex).%New()
	s len=rs.GetColumnCount()
	d ##class(DHCDoc.OPDoc.PatientList).GetOutPatientListColSet(.ConfigAry)
	s Index=0
	for {
		s Index=$O(ConfigAry(Index))
		q:(Index="")
		s ColumnInfo=$G(ConfigAry(Index))
		s Code=$P(ColumnInfo,"^",1)
		s Type=$P(ColumnInfo,"^",8)
		d colDefine.add(Code)
		s colDefine.map(Code,"Type")=Type
	}
	
	s epIndex=colDefine.index("EpisodeID")
	s count=0
	w "["
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s list=$lb()
		s index=0
		f index=1:1:len{
			s $list(list,index)=rs.GetData(index)
		}
		s EpisodeID=$lg(list,epIndex)
		;s EpisodeID=""
		if EpisodeID'="" {
			d ..GetOPHandleStatusData(EpisodeID,"",.list2)
			s $list(list,len+1,len+$ll(list2))=list2
		}
		s count=count+1
		w:count>1 ","
		d ##class(DHCDoc.Util.FormatData).JsonList(colDefine,list)
	}
	w "]"
	d rs.Close()
	q ""
}

// d ##class(DHCDoc.OPDoc.PatientList).OutPatientListCatCount("63","600","","","000000000001","","","","","","","","")

ClassMethod OutPatientListCatCount(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, Consultation As %String, MarkID As %String = "", CheckName As %String = "") As %String
{
	s NextPatName="",NextPatSeqNo=""
	w "{"
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, "RegQue")
	s count=0 ;rs.%ROWCOUNT
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		//未就诊数量不包含说明记录
		s PatEpisodeID=rs.GetDataByName("EpisodeID")
		continue:PatEpisodeID=""
		//未就诊数量不包含已到达、完成就诊
		s PatWalkStatus=rs.GetDataByName("WalkStatus")
		continue:PatWalkStatus="到达"
		s count=count+1
		if (NextPatName=""){
			s NextPatName=rs.GetDataByName("PAPMIName")
			s NextPatSeqNo=rs.GetDataByName("LocSeqNo")
		}
	}
	s NextPatName=##class(web.DHCDocUtil).EvalJSON(NextPatName)
	w """RegQue"":"_count
	w ",""NextPatName"":"_""""_NextPatName_""""
	w ",""NextPatSeqNo"":"_""""_NextPatSeqNo_""""
	d rs.Close()
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, "ArrivedQue")
	s count=0 ;rs.%ROWCOUNT
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s count=count+1
	}
	w ",""Complete"":"_count
	d rs.Close()
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, "Report")
	s count=0 ;rs.%ROWCOUNT
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s count=count+1
	}
	w ",""Report"":"_count
	d rs.Close()
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(LocID , UserID , IPAddress , AllPatient, PatientNo , SurName , StartDate , EndDate, ArrivedQue, RegQue, Consultation, MarkID, "Complete")
	s count=0 ;rs.%ROWCOUNT
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s count=count+1
	}
	w ",""DocComplete"":"_count
	d rs.Close()
	w "}"
	q ""
}

/// Creator:guorongyong
/// CreateDate:2014-08-11
/// Desc:得到门诊已处理的业务数据
/// input: EpisodeID 就诊表rowid,OutDataType 需要输出的数据类型("" 或 "JSON")
/// output: Json数据格式eg:{DisDrugs:[{Desc:具体描述},{Desc:具体描述}],UnDisDrugs[{Desc:具体描述},{Desc:具体描述}]}
/// output: 字符数据格式eg:"DisDrugs"_$c(1)_具体描述1_$c(2)_具体描述2_"^"_"UnDisDrugs"_$c(1)_具体描述1_$c(2)_具体描述2
/// w ##class(DHCDoc.OPDoc.PatientList).GetOPHandleData(3101,"","JSON")
ClassMethod GetOPHandleData(EpisodeID As %String, OutDataType As %String, ByRef OutPutArray = "", CurLogonHosp As %String = "") As %String(MAXLEN=5000)
{
	;1.已取药品:DisDrugs
	;2.未取药品:UnDisDrugs
	;3.异常检验:AbnormalLab
	;4.未出检验报告:NotLabReport
	;5.异常检查:AbnormalExam
	;6.未出检查报告:NotExamReport
	;7.治疗项目:TreatItem(子类配置:^DHCDocConfig("TreatItemCat")="...^...^...")
	s ^tmpgry("GetOPHandleData")=EpisodeID_","_OutDataType
	s langid=..%LanguageID()
	Set myrtnStr=""
	Quit:$g(EpisodeID)="" myrtnStr
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	q:OrderRowid="" myrtnStr
	Kill OutPutArray
	s itemsub=0,LabOrdNum=0
	for {
		s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")
		continue:'$d(^OEORD(OrderRowid,"I",itemsub,1))
		s OrdData1=$g(^OEORD(OrderRowid,"I",itemsub,1))
		s OrdData2=$g(^OEORD(OrderRowid,"I",itemsub,2))
		s OrdData3=$g(^OEORD(OrderRowid,"I",itemsub,3))
		s OrdData9=$g(^OEORD(OrderRowid,"I",itemsub,9))
		s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
		i itemstat'="" d
		.s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		continue:(statcode'="V")&&(statcode'="E")
	
		s ArcimId=$p(OrdData1,"^",2) 
		s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2)
		s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
		s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(OrderRowid_"||"_itemsub)
		if (ReqPartDesc'="") s ArcimDesc=ArcimDesc_ReqPartDesc
		s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		s ItemCatDR=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
		s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
		s FreqDesc="",DurDesc="",InstrDesc=""
		s FreqId=$p(OrdData2,"^",4)
		/*i FreqId'="" d
		.s FreqDesc=$p(^PHCFR(FreqId),"^",3)
		.s WeekFlag=$P(^PHCFR(FreqId),"^",9)
		.i WeekFlag="Y" d
		..s OrderFreqWeek=$p($g(^OEORD(+OrderRowid,"I",itemsub,"DHC")),"^",55)
		..s FreqDesc=FreqDesc_"-"_$TR(OrderFreqWeek,"|","")*/
		s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(OrderRowid_"||"_itemsub,"-",langid)
		s FreqDesc=$List(OrdFreqInfo,2)
		s DurDesc=""
		s DurId=$p(OrdData2,"^",6)
		i DurId'="" s DurDesc=$p(^PHCDU(DurId),"^",3)
		s DurDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",DurDesc,langid)
		s InstrDesc=""
		s InstrId=$p(OrdData2,"^",7)
		i InstrId'="" s InstrDesc=$p(^PHCIN(InstrId),"^",2)
		s InstrDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",InstrDesc,langid)
		s DoseQty=$p(OrdData2,"^",1)
		s DoseUomId=$p(OrdData2,"^",3)
		s DoseUom=##class(web.DHCDocOrderCommon).GetUOMDesc(DoseUomId,"") 
		s DoseUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DoseUom,langid)

		;保持显示数据对其(30个空格字符)
		s Space="                              "
		//s ArcimDesc=ArcimDesc_$e(Space,1,30-$l(ArcimDesc))
		//s InstrDesc=InstrDesc_$e("    ",1,4-$l(InstrDesc))
		//s FreqDesc=FreqDesc_$e("    ",1,4-$l(FreqDesc))
		//s DurDesc=DurDesc_$e("    ",1,4-$l(DurDesc))
		i OrderType="R" {
			s OrdPackQtyInfo=##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OrderRowid_"||"_itemsub) //$$GetPackQty(OrderRowid_"||"_itemsub)
			s PackUOMDesc=$p(OrdPackQtyInfo,"^",2)
			s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
		    s PackQty=$p(OrdPackQtyInfo,"^",1)_PackUOMDesc
			s DrugOutPutDesc=ArcimDesc_"&nbsp"_InstrDesc_"&nbsp"_FreqDesc_"&nbsp"_DurDesc_"&nbsp"_PackQty
			s dstatusFlag=$$IsDspDrug(OrderRowid_"||"_itemsub)
			i dstatusFlag=1 {
				;1. 得到已取药品
				s OutPutArray("DisDrugs",$i(OutPutArray("DisDrugs")))=DrugOutPutDesc
			}else{
				;2. 未取药品
				s OutPutArray("UnDisDrugs",$i(OutPutArray("UnDisDrugs")))=DrugOutPutDesc
			}
		}
		
		i OrderType="L" {
			s LabEpisode=$p(OrdData3,"^",20) 
 			s VisitNumberTestSetDR=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISRptIDByLabNo",LabEpisode)
 			i VisitNumberTestSetDR="" {
	 			;4.未出检验报告
	 			s Qty=$$GetQtyPackUOM(OrderRowid_"||"_itemsub)
				s OutPutArray("NotLabReport",$i(OutPutArray("NotLabReport")))=ArcimDesc_"&nbsp"_Qty
 			}else{
	 			;3.异常检验
	 			s n=0
				Set rset=##Class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID")
				If rset.QueryIsValid() { 
					Set Status=rset.Execute(OrderRowid_"||"_itemsub)
					If 'Status Quit
					While (rset.Next()) {
						;Code:检测项目,Name:项目名称,Sync:项目缩写,Result:项目结果,Flag:异常提示(H/L),Unit:单位,Ranges:参考范围,Comment:结果说明,Method:检测方法,Sequence:显示序号
					    s Code=rset.GetDataByName("ItemCod")
					    s Name=rset.GetDataByName("ItemDesc")
					    s Sync=rset.GetDataByName("Synonym")
					    s Result=rset.GetDataByName("ItemResult")
					    s Flag=rset.GetDataByName("AbnorFlag")
					    s Unit=rset.GetDataByName("ItemUnit")
					    s Ranges=rset.GetDataByName("ItemRanges")
					    s Comment="" ;rset.GetDataByName("Comment")
					    s Method="" ;rset.GetDataByName("Method")
					    s Sequence=rset.GetDataByName("Sequence")
					    //s Name=Name_$e("            ",1,12-$l(Name))
					    //s Result=Result_$e("    ",1,4-$l(Result))_Unit
					    //s Ranges=Ranges_$e("      ",1,6-$l(Ranges))
					    i Flag'="" {
						    s n=n+1
						    s AbnormalLabOutput="&nbsp"_Name_"&nbsp"_Result_"&nbsp"_Flag_"&nbsp"_Ranges
						    ;对于第一条需要加上医嘱名称的显示
						    i n=1 {
							    s LabOrdNum=LabOrdNum+1
						    	s OutPutArray("AbnormalLab",$i(OutPutArray("AbnormalLab")))=LabOrdNum_"&nbsp"_ArcimDesc
						    	s OutPutArray("AbnormalLab",$i(OutPutArray("AbnormalLab")))="&nbsp&nbsp"_LabOrdNum_"."_n_"&nbsp"_AbnormalLabOutput
						    }else{
							    s OutPutArray("AbnormalLab",$i(OutPutArray("AbnormalLab")))="&nbsp&nbsp"_LabOrdNum_"."_n_"&nbsp"_AbnormalLabOutput
						    }
					    }
					    
					}
					d rset.Close()
				}
 			}
		}
		s IsExamItemFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimId)
		i IsExamItemFlag="1" {
			s RptRowIdStr=$$GetRisReportId(OrderRowid_"||"_itemsub)
			s RptRowId=$p(RptRowIdStr,"^",1)
			s StudyNo=$p(RptRowIdStr,"^",2)
			i ((RptRowId="")&&(StudyNo="")) {
				;6.未出检查报告
				s Qty=$$GetQtyPackUOM(OrderRowid_"||"_itemsub)
				s OutPutArray("NotExamReport",$i(OutPutArray("NotExamReport")))=ArcimDesc_"&nbsp"_Qty
			}else{
				;5.异常检查
				s ReportInfo=$$GetRisReport(OrderRowid_"||"_itemsub)
				s ExamDesc=$p(ReportInfo,"^",1)
				s strResult=$p(ReportInfo,"^",2)
				s IsIll=$p(ReportInfo,"^",3)
				i IsIll="Y" {
					s OutPutArray("AbnormalExam",$i(OutPutArray("AbnormalExam")))=ArcimDesc_"&nbsp&nbsp&nbsp&nbsp"_strResult
					//s OutPutArray("AbnormalExam",$i(OutPutArray("AbnormalExam")))="&nbsp&nbsp&nbsp&nbsp"_strResult
				}else{
					s OutPutArray("AbnormalExam",$i(OutPutArray("AbnormalExam")))=ArcimDesc
					}
			}
		}
		s TreatItemCatStr=..%GetConfig("TreatItemCat",CurLogonHosp ) //$g(^DHCDocConfig("TreatItemCat"))
		i ("^"_TreatItemCatStr_"^")[("^"_ItemCatDR_"^") {
			;5.治疗项目
			s Qty=$$GetQtyPackUOM(OrderRowid_"||"_itemsub)
			s TreatItemOutPutDesc=ArcimDesc_"&nbsp"_InstrDesc_"&nbsp"_FreqDesc_"&nbsp"_DurDesc_"&nbsp"_Qty
			s OutPutArray("TreatItem",$i(OutPutArray("TreatItem")))=TreatItemOutPutDesc
		}
	}
	i OutDataType="JSON" {
		s Node=""
		for {
			s Node=$o(OutPutArray(Node)) q:Node=""
			s Index=0,NodeResultStr=""
			for {
				s Index=$o(OutPutArray(Node,Index)) q:Index=""
				i NodeResultStr="" {
					s NodeResultStr="{""Desc"":"""_OutPutArray(Node,Index)
				}else{
					s NodeResultStr=NodeResultStr_"""},{""Desc"":"""_OutPutArray(Node,Index)
				}
			}
			i NodeResultStr'="" s NodeResultStr=NodeResultStr_"""}"
			
			i myrtnStr="" {
				s myrtnStr="{"""_Node_""":["_NodeResultStr
			}else{
				s myrtnStr=myrtnStr_"],"""_Node_""":["_NodeResultStr
			}
		}
		i myrtnStr'="" s myrtnStr=myrtnStr_"]}"
	}else{
		s Node=""
		for {
			s Node=$o(OutPutArray(Node)) q:Node=""
			s Index=0,NodeResultStr=""
			for {
				s Index=$o(OutPutArray(Node,Index)) q:Index=""
				i NodeResultStr="" {
					s NodeResultStr=OutPutArray(Node,Index)
				}else{
					s NodeResultStr=NodeResultStr_$c(2)_OutPutArray(Node,Index)
				}
			}
			i myrtnStr="" {
				s myrtnStr=Node_$c(1)_NodeResultStr
			}else{
				s myrtnStr=myrtnStr_"^"_Node_$c(1)_NodeResultStr
			}
		}
	}
	
	Q myrtnStr
	
IsDspDrug(oeitm)
	s dstatusFlag=0
	s dis=0 for {
		s dis=$O(^DHCOEDISQTY(0,"OEORI",oeitm,dis)) q:dis=""
		s dstatus=""
		if $g(dis)'="" s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		if dstatus="C" s dstatusFlag=1
		q:dstatusFlag=1	
	}
	
	q dstatusFlag
 ;药品得到实际使用的整包装数量
GetPackQty(oeitm)
	s ord=$p(oeitm,"||",1)
	s chl=$p(oeitm,"||",2)
	s PackQty=##class(web.DHCDocOrderEntry).GetActiveDrugQty(oeitm)
	i (PackQty'="")&&(PackQty<1) s PackQty="0"_$number(PackQty)
	s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
	s BillingUOM="" 
	s ProtocolPackUOMDR=$p($g(^OEORD(+ord,"I",chl,"DHC")),"^",13)
	//s BillingUOMDR=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8)),"^",14)
	//i BillingUOMDR'="" s BillingUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(oeitm)
	i BillingUOMDR'="" {
		s convqty=$$ConvFac^ST02(BillingUOMDR,ProtocolPackUOMDR),convqty=$p(convqty,$c(1),1)
		i +convqty=0 s convqty=1
		s BillingUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
		s PackQty=PackQty/convqty
		;向上取整
		s PackQty=PackQty\1+$s(PackQty#1:1,1:0)
	}
	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcimId)
	if (CheckCHNFlag="Y"){
		S Phcdf=$P($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
		if (Phcdf'=""){
			s BillingUOMDR=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
			s BillingUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
		}
	}
	Q PackQty_BillingUOM
 ;得到整包装数量和单位,直接获取存储数据
GetQtyPackUOM(oeitm)
	s ord=$p(oeitm,"||",1)
	s chl=$p(oeitm,"||",2)
	s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2) 
	s Qty=$P($g(^OEORD(ord,"I",chl,1)),"^",12)
	s BillingUOM="" 
	;s BillingUOMDR=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8)),"^",14)
	s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(oeitm)
	i BillingUOMDR'="" s BillingUOM=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	
	Q Qty_"  "_BillingUOM
	
 ;得到检查报告,参考RIS组提供给电子病历的Query:web.DHCRisclinicQueryEPR|SelectReportByOeordID
GetRisReport(oeitm)
	s ExamDesc="未回报",strResult="未回报"
	s RptRowIdStr=$$GetRisReportId(oeitm)
	s RptRowId=$p(RptRowIdStr,"^",1)
	;检查号
	s StudyNo=$p(RptRowIdStr,"^",2)
	s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),"-1")
	s IsIll = ""
	i RptRowId'="" {
		i $g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))'= "" {
			s ExamDesc=^DHCRBStudy("Report",RptRowId,"ExamDescEx")	
			s:(ExamDesc'="") ExamDesc=##class(web.DHCRisclinicQueryEPR).ConvertRptContent(ExamDesc)  //处理协和项目 平台组特殊字符
		}
	    i $g(^DHCRBStudy("Report",RptRowId,"ResultDescEx"))'= "" {
			s strResult=^DHCRBStudy("Report",RptRowId,"ResultDescEx")
			s:(strResult'="") strResult=##class(web.DHCRisclinicQueryEPR).ConvertRptContent(strResult)  //处理协和项目 平台组特殊字符
	    }
	    s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	}
	s:IsIll="" IsIll = ##class(web.DHCEkg.GetEkgReportState).GetEkgPositive(oeitm) 
	s ord=$p(oeitm,"||",1)
	s chl=$p(oeitm,"||",2)
	s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2) 
	s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2)
	s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	s ExamDesc=ArcimDesc
	;通过检查号获取检查阴阳性结果
	/*s CurrentSpace=$znspace
	zn "DHC-PACS"
	s ReportInfo=##class(PACS.RISInterface).GetReportInfo(StudyNo)
	zn CurrentSpace
	s sdoccode=$p(ReportInfo,"^",30)*/
	
	Q ExamDesc_"^"_strResult_"^"_IsIll
 ;得到检查报告Rowid
GetRisReportId(oeitm)
	/*s RptRowId="",StudyNo=""
    s RegRowid=$o(^DHCPACRegInfoi("OEORI",oeitm,0))
    i RegRowid'="" {
    	s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
    	s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0)) 
    }*/
    s RptRowId="",StudyNo=""
	s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(oeitm,"")
    Q RptRowId_"^"_StudyNo
}

ClassMethod GetPatNameByAdm(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s PatId=$p(^PAADM(EpisodeID),"^",1)
	Q:PatId="" ""
	s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	Q PatName
}

/// creator:谭吉善
/// date:	20210310
/// input:	
/// return:	
/// desc:   根据列头设置得到对应query的表格配置对象
/// 参考：d ##class(DHCDoc.OPDoc.PatientList).ReadListColSet()
ClassMethod ReadListColSet(classname As %String, classmethod As %String, ByRef colNames As %String, ByRef colModelAry As %String, ByRef ParamAry As %String, context As %String, ColClassName As %String, ColMethodName As %String) As %String
{
	q:(classname="")||(classmethod="") ""
	q:(ColClassName="")||(ColMethodName="") ""
	;s LookupListComponetId = $o(^websys.ComponentI("UniqueNameIndex","WEBSYSLOOKUPLIST",0))
	s context="K"_classname_"."_classmethod_"."_context
	
	s SessionStr=""
	
	i %session,$d(%session.Data) {
		s SessionStr=%session.Get("LOGON.SITECODE")_"^"_%session.Get("LOGON.USERID")
		s SessionStr=SessionStr_"^"_%session.Get("LOGON.GROUPID")_"^"_%session.Get("LOGON.CTLOCID")
		s SessionStr=SessionStr_"^"_%session.Get("CONTEXT")_"^"_%session.Get("LOGON.WARDID")
		s SessionStr=SessionStr_"^"_%session.Get("LOGON.HOSPID")_"^"_%session.Get("LOGON.LANGID")
	}
	
	k ConfigAry
	d $CLASSMETHOD(ColClassName,ColMethodName,.ConfigAry)
	//d ##Class(DHCDoc.OPDoc.PatientList).GetOutPatientListColSet(.ConfigAry)
	k SortQueue			
	s uSet=""
	if (($g(%session)'="")&&($g(%session.Data("LOGON.USERID"))'="")) d
	.;s uSet=##class(websys.Preferences).GetDataExLE(1,1,"","",context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,"","")
	.s uSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.;不能改顺序,影响前台取值
	.f idx=1:1:$l(uSet,"|") d
	..s uSetItem = $p(uSet,"|",idx)
	..s myIdx = $p(uSetItem,",",1)		;col-index,width,sort|
	..s:myIdx>0 SortQueue(myIdx,idx)=1,hiddenPlist(myIdx)=1,hiddenPlist(myIdx,2)=$p(uSetItem,",",2),hiddenPlist(myIdx,3)=$p(uSetItem,",",3)	
	.s rowsSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"ROWS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.s pageSize=$lg(rowsSet,1)
	s ^tmphiddenPlist=uSet
	;排序,所有隐藏列排在后面,显示列按设置显示
	;SortConfigAry为临时排序数组,Loop为原ConfigAry数组计数器,不会重复;所以只要取到Loop可以直接使用ConfigAry(Loop)取值
	m ^tan("mth","ConfigAry")=ConfigAry
	m ^tan("mth","SortQueue")=SortQueue
	k SortConfigAry
	i uSet'="" {
		s Loop=0
		for {
			s Loop=$O(ConfigAry(Loop)) Q:Loop=""
			i $g(hiddenPlist(Loop))="" {
				//2014-04-15
				s SortConfigAry(999,Loop)=$g(ConfigAry(Loop))
			}else{
				s SortNum=$o(SortQueue(Loop,0))
				s SortConfigAry(+SortNum,Loop)=$g(ConfigAry(Loop))
			} 
		}
	}
	s SortNum=""
	for {
		s SortNum=$O(SortConfigAry(SortNum)) Q:SortNum=""
		s Loop=0
		for {
			s Loop=$O(SortConfigAry(SortNum,Loop)) Q:Loop=""
			s OneItem=$g(ConfigAry(Loop))
			s name=$p(OneItem,"^",1)
			s cap=$p(OneItem,"^",2)
			s col=$p(OneItem,"^",3)
			s wid=$p(OneItem,"^",4)
			s isHidden=$p(OneItem,"^",5)
			i (isHidden="Y")||(cap="") s cap=name
			s sort=$p(OneItem,"^",6)
			s expression=$p(OneItem,"^",7)
			i '$d(colNames) {
				s colNames=cap
			}else{
				s colNames=colNames_","_cap
			}
			i (uSet'=""),$g(hiddenPlist(Loop))="" s isHidden="Y"
			;转换
			i isHidden="Y" s isHidden="true"
			e  s isHidden="false"
			k ColCFAry
			s ColCFAry("name")=name
			s ColCFAry("cap")=cap
			s ColCFAry("col")=col
			s ColCFAry("wid")=wid
			s ColCFAry("isHidden")=isHidden
			s ColCFAry("sort")=sort
			s ClassName=$p(expression,".",1,$l(expression,".")-1)
			s MethodName=$p(expression,".",$l(expression,"."))
			s colModelAry(cap)="{}"
			s ExpStr=""
			i $d(ParamAry(name)) s ExpStr=$g(ParamAry(name))
			i ClassName'="" {
				;判断方法是否存在
				s CLSObj=##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
				if $IsObject(CLSObj) {
					if $d(^oddDEF(CLSObj.%Id(),"m",MethodName)) {
						s colModelAry(cap)=$CLASSMETHOD(ClassName,MethodName,SessionStr,.ColCFAry,ExpStr)
					}
				}
			}else{
				s colModelAry(cap)="{field:'"_name_"',title:'"_cap_"',width:'"_wid_"',hidden:"_isHidden_"}"
			}
		}
	}

	q
}

ClassMethod GessCardTypeIncludUnActiveCard(cardValue As %String)
{
	s count=0
	s myTypeID=0
	s myDataFlag=0
	s SessionStr=##class(web.DHCBL.Configure.PatEnroll).DHCGetDefaultSystemSession()
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	s myHospitalID=$p(SessionStr,"^",5)
	Set langid=..%LanguageID()
	s json="["
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.//判断卡类型是否给该院区授权
	.s Flag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",myTypeID,myHospitalID,+$H)
	.q:Flag'="Y"
	.s mydes=##class(User.DHCCardTypeDef).GetTranByDesc("CTDDesc",mydes,langid)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  s mySelFlag=1
	.q:(+myFindFlag=0)
	.s checkdValue= ..CheckCardValue(myTypeID,cardValue)
	.q:checkdValue=""
	.s cfRowId=0
	.f  s cfRowId=$o(^DHCCARDi("CF",0,"CardTypeNo",myTypeID,checkdValue,cfRowId)) q:cfRowId=""  d
	..s papmiNo=$p(^DHCCARD("CF",cfRowId),"^",6)
	..s CFActiveFlag=$p($g(^DHCCARD("CF",cfRowId)),"^",10)
	..//q:CFActiveFlag'="N"
	..s SecurityNo=$P(^DHCCARD("CF",cfRowId),"^",3)
	..s SecurityNo=##class(web.UDHCAccEnrypt).Decrypt(SecurityNo)
	..i count>0 s json=json_","
	..s json=json_"{""cardTypeId"":"""_myTypeID_""",""cardDesc"":"""_mydes_""",""checkdValue"":"""_checkdValue_""",""papmiNo"":"""_papmiNo_""",""SecurityNo"":"""_SecurityNo_"""}"
	..s count=count+1
	q json_"]"
}

}
