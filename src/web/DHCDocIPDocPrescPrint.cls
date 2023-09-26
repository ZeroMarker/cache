Class web.DHCDocIPDocPrescPrint Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creator:      宋春莉
/// CreatDate:    2020.10.10
/// Description:  住院处方打印数据获取
/// Input:        EpisodeID:就诊指针, SearchStartDate:开始日期,SearchEndDate:截止日期,
/// CategoryID:	  大类指针, SubsortID:子类指针
/// Return:       
/// Others:  web.DHCDocQryOEOrder.GetOrdByAdm 此方法门诊本次医嘱、预览&打印在用，其中一些过滤条件和住院处方打印冲突
/// w ##class(web.DHCDocIPDocPrescPrint).GetOrdDataJson("","2020-10-14","2020-10-14","","J1^DM^DX^MZ","N","",10)
ClassMethod GetOrdDataJson(PatNo As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", OutOrd As %String = "", DrgFormPoison As %String = "", CMMedFlag As %String = "", LocId As %String = "", WardId As %String = "", PrintSel As %String = "") As %String
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	s SearchStartDate=..%ZDH(SearchStartDate)
	s SearchEndDate=..%ZDH(SearchEndDate)
	k AdmCongeriesArr
	if (PatNo '="") {
		s PatientID=##class(web.DHCDocOrderEntry).GetPapmiRowidByNo(PatNo)
		s PAADMType=""
		for {
			s PAADMType=$o(^PAPERdr(PatientID,"ADM",PAADMType)) Q:PAADMType=""
			s PAADMRowID=""
			for {
				s PAADMRowID=$o(^PAPERdr(PatientID,"ADM",PAADMType,PAADMRowID)) Q:PAADMRowID=""
				continue:'$$CheckValid(PAADMRowID)
				s PatientID=$p(^PAADM(PAADMRowID),"^",1)
				s AdmCongeriesArr(PatientID,PAADMRowID)=1
			}
		}
	}elseif (WardId '="") {
		s PAADMCurrentRoomDR=""
		for {
			s PAADMCurrentRoomDR=$o(^PAADMi("CurrWard",WardId,PAADMCurrentRoomDR)) Q:PAADMCurrentRoomDR=""
			s PAADMRowID=""
			for {
				s PAADMRowID=$o(^PAADMi("CurrWard",WardId,PAADMCurrentRoomDR,PAADMRowID)) Q:PAADMRowID=""
				continue:'$$CheckValid(PAADMRowID)
				s PatientID=$p(^PAADM(PAADMRowID),"^",1)
				s AdmCongeriesArr(PatientID,PAADMRowID)=1
			}
		}
		
		
	}elseif (LocId '="") {
		s PAADMType=""
		for {
			s PAADMType=$o(^PAADMi("AdmTypeCurrLoc",PAADMType)) Q:PAADMType=""
			s Date=""
			for {
				s Date=$o(^PAADMi("AdmTypeCurrLoc",PAADMType,LocId,Date)) Q:Date=""
				s Time=""
				for {
					s Time=$o(^PAADMi("AdmTypeCurrLoc",PAADMType,LocId,Date,Time)) Q:Time=""
					s PAADMRowID=""
					for {
						s PAADMRowID=$o(^PAADMi("AdmTypeCurrLoc",PAADMType,LocId,Date,Time,PAADMRowID)) Q:PAADMRowID=""
						continue:'$$CheckValid(PAADMRowID)
						s PatientID=$p(^PAADM(PAADMRowID),"^",1)
						s AdmCongeriesArr(PatientID,PAADMRowID)=1
					}
				}
			}
		}
	}
	s JsonObj=[]
	s JsonData={}
	s index=0,MJ1Count=0,J2Count=0
	s dataobj = ##class(%DynamicObject).%New() 
	s dataobj.MyList= ##class(%DynamicArray).%New()
	if (DrgFormPoison'="") s DrgFormPoison="^"_DrgFormPoison_"^"
	s tmpPatientID=""
	for {
		s tmpPatientID=$O(AdmCongeriesArr(tmpPatientID)) Q:tmpPatientID=""
		s OnePatOrdCount=0
		s onePatOrdobj = ##class(%DynamicObject).%New() 
		s onePatOrdobj.MyList= ##class(%DynamicArray).%New()
		s tmpEpisodeID=""
		for {
			s tmpEpisodeID=$O(AdmCongeriesArr(tmpPatientID,tmpEpisodeID)) Q:tmpEpisodeID=""
			s HospId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(tmpEpisodeID)
			s result = ##Class(%ResultSet).%New("web.DHCDocQryOEOrder:GetOrdByAdm")
			s sc = result.Execute(tmpEpisodeID,"",SearchStartDate,SearchEndDate)
			Set columns = result.GetColumnCount()
			While (result.Next()){
				s OrderType=$g(result.Data("OrderType"))
				;过滤非药品
				continue:OrderType'="R"
				s OEItemID=$g(result.Data("OEItemID"))
				s ARCIMRowId=$g(result.Data("ARCIMRowId"))
				s OrderPrescNo=$g(result.Data("OrderPrescNo"))
				s PriorityDr=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",8)
				s PriorityCode=$p(^OECPR(PriorityDr),"^",1)
				s DMFlag=##Class(DHCDoc.OPDoc.TreatPrint).CheckPrescIsDMFlag(OrderPrescNo)
				;查询出院处方时过滤非出院医嘱、毒麻医嘱
				continue:(OutOrd="on")&&((PriorityCode'="OUT")||(DMFlag=1))
				;查询毒麻处方时过滤非毒麻医嘱
				continue:(DrgFormPoison'="")&&(DMFlag'=1)
				;查询草药处方时过滤毒麻、出院带药医嘱
				s CNMedFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowId,HospId)
				continue:(CMMedFlag="Y")&&((PriorityCode="OUT")||(DMFlag=1)||(CNMedFlag'=1))
				s OnePatOrdCount=OnePatOrdCount+1
				s oneJson={}
				For col = 1:1:columns {
					s name=result.GetColumnName(col)
					s value=result.GetData(col)
					if (name="DMdsstatus") s value=##class(websys.Translation).Get("ipdoc.prescprintall.csp",value)
					if (name="PrescTitle") s value=##class(websys.Translation).Get("ipdoc.prescprintall.csp",value)
					do oneJson.%Set(name,value)
				}
				s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDr)
				do oneJson.%Set("LongPriorFlag",LongPriorFlag)
				do oneJson.%Set("EpisodeID",tmpEpisodeID)
				s OrdStartDateHide=..%ZDH($g(result.Data("OrdStartDate")))
				do oneJson.%Set("OrdStartDateHide",OrdStartDateHide)
				s index=index+1
				do oneJson.%Set("index",index)
				do oneJson.%Set("name","")
				s OrderPrintFlag=$g(result.Data("OrderPrintFlag"))
				if (PrintSel ="AllUnPrint")&&(OrderPrintFlag '="Y") do oneJson.%Set("checked","true")
				if (PrintSel ="AllPrinted")&&(OrderPrintFlag ="Y") do oneJson.%Set("checked","true")
				d onePatOrdobj.MyList.%Push(oneJson)
				s PrescTitle=$g(result.Data("PrescTitle"))
				if (PrescTitle ="毒麻")||(PrescTitle ="精一") {
					s MJ1Count=MJ1Count+1
				}elseif (PrescTitle ="精二"){
					s J2Count=J2Count+1
				}
			}
		}
		if (OnePatOrdCount > 0) {
			s onePatObj={}
			s index=index+1
			do onePatObj.%Set("index",index)
			do onePatObj.%Set("name",$$GetPatInfo(tmpPatientID))
			if (PrintSel ="SelctAll") {
				do onePatObj.%Set("checked","true")
			}
			do onePatObj.%Set("children",onePatOrdobj.MyList)
			do JsonObj.%Push(onePatObj)
		}
	}
	do JsonData.%Set("MJ1Count",MJ1Count)
	do JsonData.%Set("J2Count",J2Count)
	do JsonData.%Set("data",JsonObj)
	
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonData.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	q JsonInfo
CheckValid(PAADMRowID)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PAADMRowID)
	Q:AdmHospitalId'=HospID 0
	s PatientID1=$p(^PAADM(PAADMRowID),"^",1)
	s PatNo1=##Class(web.PAPatMas).GetRegistration(PatientID1)
	Q:(PatNo'="")&&(PatNo'=PatNo1) 0
	s PAADMVisitStatus=$p(^PAADM(PAADMRowID),"^",20)
	Q:(PAADMVisitStatus="C") 0
	s PAADMCurrentWardDR=$p(^PAADM(PAADMRowID),"^",70)
	Q:(WardId'="")&&(PAADMCurrentWardDR'=WardId) 0
	s PAADMDepCodeDR=$p(^PAADM(PAADMRowID),"^",4)
	Q:(LocId'="")&&(PAADMDepCodeDR'=LocId) 0
	s OEORDRowId=$o(^OEORD(0,"Adm",PAADMRowID,""))
	Q:OEORDRowId="" 0
	s OEORIChildsub=$o(^OEORDi(0,"StDt",SearchStartDate,OEORDRowId,""))
	s OEOREExStTime=$o(^OEORDi(0,"Date",OEORDRowId,SearchStartDate,""))
	;Q:(OEORIChildsub="")&&(OEOREExStTime="") 0
    Q 1
GetPatInfo(PatientID)
	Set langid=..%LanguageID()
 	s PatNo1=##Class(web.PAPatMas).GetRegistration(PatientID)
 	s PatName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
 	s PatSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
 	if PatSexDr'="" s PatSex=$P($G(^CT("SEX",PatSexDr)),"^",2)
 	s PatSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,"",HospID)
 	Q ##class(websys.Translation).Get("ipdoc.prescprintall.csp","登记号：")_PatNo1_##class(websys.Translation).Get("ipdoc.prescprintall.csp"," 姓名：")_PatName_##class(websys.Translation).Get("ipdoc.prescprintall.csp"," 性别：")_$g(PatSex)_##class(websys.Translation).Get("ipdoc.prescprintall.csp"," 年龄：")_PatAge
}

/// w ##class(web.DHCDocIPDocPrescPrint).GetIPDocPrescCatCount(112,65664,65664)
ClassMethod GetIPDocPrescCatCount(EpisodeID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "") As %String
{
	s HospId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s MJUnPrintCount=0,OutUnPrintCount=0,CMUnPrintCount=0
	s data=##class(web.DHCDocIPDocPrescPrint).GetOrdDataJsonByAdm(EpisodeID,SearchStartDate,SearchEndDate,"","","")
	k OrdCongeriesArr,OrdPrescNoArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(data,.OrdCongeriesArr)
	s OrdCounter=""
	for {
		s OrdCounter=$O(OrdCongeriesArr("rows",OrdCounter))
		q:(OrdCounter="")
		s OrderType=OrdCongeriesArr("rows",OrdCounter,"OrderType")
		;过滤非药品
		continue:OrderType'="R"
		s OrderPrintFlag=OrdCongeriesArr("rows",OrdCounter,"OrderPrintFlag")
		continue:OrderPrintFlag="Y"
		s OrderPrescNo=OrdCongeriesArr("rows",OrdCounter,"OrderPrescNo")
		continue:$d(OrdPrescNoArr(OrderPrescNo))
		s DMFlag=##Class(DHCDoc.OPDoc.TreatPrint).CheckPrescIsDMFlag(OrderPrescNo)
		if (DMFlag=1) {
			s MJUnPrintCount=MJUnPrintCount+1
		}
		s ARCIMRowId=OrdCongeriesArr("rows",OrdCounter,"ARCIMRowId")
		s OEItemID=OrdCongeriesArr("rows",OrdCounter,"OEItemID")
		s PriorityDr=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",8)
		s PriorityCode=$p(^OECPR(PriorityDr),"^",1)
		if (PriorityCode="OUT")&&(DMFlag'=1) {
			s OutUnPrintCount=OutUnPrintCount+1
		}
		s CNMedFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowId,HospId)
		if (CNMedFlag=1)&&(PriorityCode'="OUT")&&(DMFlag'=1) {
			s CMUnPrintCount=CMUnPrintCount+1
		}
		s OrdPrescNoArr(OrderPrescNo)=1
	}
	s JsonData={}
	do JsonData.%Set("MJUnPrintCount",MJUnPrintCount)
	do JsonData.%Set("OutUnPrintCount",OutUnPrintCount)
	do JsonData.%Set("CMUnPrintCount",CMUnPrintCount)
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonData.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	q JsonInfo
}

}
