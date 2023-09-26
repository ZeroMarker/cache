Class web.DHCDocDiagnosEntryV8CDSS Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(web.DHCDocDiagnosEntryV8CDSS).FindDiagListItems(12175,16)
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnosFuseInterface","GetListByPatient","0000000014","IP0000000006")
ClassMethod FindDiagListItems(USERID As %String, MRADM As %String) As %String
{
	s page=1,total=0,records=0,data=""
	i (USERID="")||(MRADM="") {
		w "{""page"":"""_page_""",""total"":"""_total_""",""records"":"""_records_""",""data"":[]}"
	}
	w "{""page"":"""_page_""",""total"":"""_total_""",""records"":"""_records_""",""data"":["
	k DiagListArr
	s EpisodeID=$p($G(^MR(MRADM,"PRO",1)),"^",9)
	s AdmLocId=$p(^PAADM(EpisodeID),"^",4)
	s ADMNo=$p(^PAADM(EpisodeID),"^",81)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	b //55
	Set rset=##Class(%ResultSet).%New("web.DHCBL.MKB.SDSDiagnosFuseInterface:GetListByPatient")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(PatNo,ADMNo)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s SDSRowId=rset.Data("SDSRowId") //结构化诊断RowId
			s SDSTermDR=rset.Data("SDSTermDR") //结构化诊断中心词DR
			s SDSDisplayName=rset.Data("SDSDisplayName") //结构化诊断表达式
			s SDSValue=rset.Data("SDSValue") //结构化诊断勾选属性ID串
			s SDSIcdCode=rset.Data("SDSIcdCode") //ICD编码
			s SDSIcdDesc=rset.Data("SDSIcdDesc") //ICD描述
			s SDSVisitFlag=rset.Data("SDSVisitFlag") //是否本次就诊诊断 本次：true，非本次：false
			s MRDiagRowId=rset.Data("MRDiagRowId") //医生站诊断RowId
			s PAAdmRowid=$p($G(^MR(+MRDiagRowId,"PRO",1)),"^",9)
			s PAAdmLocId=$p(^PAADM(PAAdmRowid),"^",4)
			if (SDSVisitFlag="true") {
				s index1=1
			}elseif (PAAdmLocId=AdmLocId){
				s index1=2
			}else{
				s index1=3
			}
			s DiagListArr(index1,$p(MRDiagRowId,"||",2),MRDiagRowId)=SDSRowId_"^"_SDSTermDR_"^"_SDSDisplayName_"^"_SDSIcdCode_"^"_SDSVisitFlag_"^"_SDSValue
		}
	}
	s Id=0
	s index1=0
	for {
		s index1=$o(DiagListArr(index1)) Q:index1=""
		
		s index2=""
		for {
			if (index1=1) s index2=$o(DiagListArr(index1,index2)) Q:index2=""
			else  s index2=$o(DiagListArr(index1,index2),-1) Q:index2=""
			//s index2=$o(DiagListArr(index1,index2),sort) Q:index2=""
			s MRDiagRowId=""
			for {
				s MRDiagRowId=$o(DiagListArr(index1,index2,MRDiagRowId)) Q:MRDiagRowId=""
				s cdssdata=$g(DiagListArr(index1,index2,MRDiagRowId))
				s Id=Id+1
				s DiagGridRowAry(USERID,MRADM,"OLD","id")=Id
				s MRCIDRowId=$p(^MR(+MRDiagRowId,"DIA",$p(MRDiagRowId,"||",2)),"^",1)
				s DiagGridRowAry(USERID,MRADM,"OLD","MRCIDRowId")=MRCIDRowId
				s DiagGridRowAry(USERID,MRADM,"OLD","MRDIARowId")=MRDiagRowId
				if (MRCIDRowId '=""){
					s ICDInfo=##class(web.DHCDocDiagnosEntryV8).GetICDInfoByICDDr(MRCIDRowId)
					s DiagnosCat=$p(ICDInfo,"^",4)
					//s DiagnosICDDesc=$p(^MRC("ID",MRCIDRowId),"^",2)
				}else{
					s Questionnaire=$P($G(^MR(+MRDiagRowId,"DIA",$p(MRDiagRowId,"||",2))),"^",22)
					s DiagnosCat=$case(Questionnaire,1:"中医",2:"西医",3:"证型")
				}
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosCat")=DiagnosCat
				s SubRowid=$G(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2),"TYP",0))
				if SubRowid'="" {
					s MRDiagnosTypeDr=$G(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2),"TYP",SubRowid))
					if MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
				}
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosType")=$g(MRDiagnosTypeDesc)
				s DiagnosLeavel=$P($G(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2),"EPR")),"^",1)
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosLeavel")=DiagnosLeavel
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosICDDesc")=$p(cdssdata,"^",3)
				s MainDiagFlag=$p(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2),1),"^",20)
				s DiagGridRowAry(USERID,MRADM,"OLD","MainDiagFlag")=MainDiagFlag
				s DiagnosNotes=$g(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2),"DES",1))
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosNotes")=DiagnosNotes
				s DiagGridRowAry(USERID,MRADM,"OLD","MRCIDCode")=$p(cdssdata,"^",4)
				s DiagnosStatusRowId=$P($G(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2))),"^",9)
				s DiagnosStatus=$p(^MRC("DSTAT",DiagnosStatusRowId),"^",2)
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosStatus")=DiagnosStatus
				s DIAOnsetDate=$P($G(^MR(+MRDiagRowId,"DIA",$p(MRDiagRowId,"||",2))),"^",35) //取发病日期
				s DIAOnsetDate=##class(websys.Conversions).DateLogicalToHtml(DIAOnsetDate)
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosOnsetDate")=DIAOnsetDate
				s DiagnosDate=$P($G(^MR(+MRDiagRowId,"DIA",$p(MRDiagRowId,"||",2))),"^",7)
				s DiagnosDate=##class(websys.Conversions).DateLogicalToHtml(DiagnosDate)
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosDate")=DiagnosDate
				
				s SyndromeDesc=##class(web.DHCDocDiagnosNew).GetDiaSyndDesc(MRDiagRowId)
    			i SyndromeDesc'="" s SyndromeDesc=$tr(SyndromeDesc,","," ")
				s DiagGridRowAry(USERID,MRADM,"OLD","SyndromeDesc")=SyndromeDesc
				s MRDIAMRDIADR=$p($g(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2))),"^",15)
				s DiagGridRowAry(USERID,MRADM,"OLD","MRDIAMRDIADR")=MRDIAMRDIADR
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosStatusRowId")=DiagnosStatusRowId
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosTypeRowId")=$g(MRDiagnosTypeDr)
				s BodyPartDr=$p($g(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2),1)),"^",21)
				i BodyPartDr'="" s BodyPartDesc=$List(^DHCEMRM.DicDiagnosPositionD(BodyPartDr),3)
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosBodyPart")=$g(BodyPartDesc)
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosBodyPartRowId")=BodyPartDr
				s DiagnosDoctor=""
				s AddUserDr=$p($g(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2),1)),"^",18)
				if (AddUserDr'="") {
					s DoctorDr=$p(^SSU("SSUSR",+AddUserDr),"^",14)
				    i DoctorDr'="" s DiagnosDoctor=$P($G(^CTPCP(DoctorDr,1)),"^",2)
				}
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosDoctor")=$g(DiagnosDoctor)
				s LongDiagnosFlagRowId=$P($G(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2),1)),"^",23)
    			s DiagnosPrefix=$P($G(^MR(+MRDiagRowId,"DIA",$P(MRDiagRowId,"||",2),1)),"^",26)
				s DiagGridRowAry(USERID,MRADM,"OLD","LongDiagnosFlagRowId")=LongDiagnosFlagRowId
				s DiagGridRowAry(USERID,MRADM,"OLD","LongDiagnosFlag")=$case(LongDiagnosFlagRowId,"L":##class(websys.Translation).Get("diagnosentry.v8.csp","本科"),"H":##class(websys.Translation).Get("diagnosentry.v8.csp","全科"),:"")
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosPrefix")=DiagnosPrefix
				// 结构化诊断RowId^结构化诊断中心词DR^结构化诊断表达式ID串^是否本次就诊诊断
				s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosHiddenPara")=$p(cdssdata,"^",1,2)_"^"_$p(cdssdata,"^",6)_"^"_$p(cdssdata,"^",5)
				s total=+total+1
				s records=+records+1
				s onedata=##class(web.DHCDocDiagnosEntryV8).GetDiagJSONStr(USERID,MRADM,.DiagGridRowAry)
				i onedata="" continue
				if (data=""){
					s data=onedata
				}else{
					s data=","_onedata
				}
				w data
			}
		}
	}
	/*
	Set rset=##Class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(MRADM)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s DiagGridRowAry(USERID,MRADM,"OLD","id")=rset.Data("id")
			s DiagGridRowAry(USERID,MRADM,"OLD","MRCIDRowId")=rset.Data("MRCIDRowId")
			s DiagGridRowAry(USERID,MRADM,"OLD","MRDIARowId")=rset.Data("MRDIARowId")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosCat")=rset.Data("DiagnosCat")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosType")=rset.Data("DiagnosType")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosLeavel")=rset.Data("DiagnosLeavel")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosICDDesc")=rset.Data("DiagnosICDDesc")
			s DiagGridRowAry(USERID,MRADM,"OLD","MainDiagFlag")=rset.Data("MainDiagFlag")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosNotes")=rset.Data("DiagnosNotes")
			s DiagGridRowAry(USERID,MRADM,"OLD","MRCIDCode")=rset.Data("MRCIDCode")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosStatus")=rset.Data("DiagnosStatus")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosOnsetDate")=rset.Data("DiagnosOnsetDate")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosDate")=rset.Data("DiagnosDate")
			s DiagGridRowAry(USERID,MRADM,"OLD","SyndromeDesc")=rset.Data("SyndromeDesc")
			s DiagGridRowAry(USERID,MRADM,"OLD","MRDIAMRDIADR")=rset.Data("MRDIAMRDIADR")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosStatusRowId")=rset.Data("DiagnosStatusRowId")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosTypeRowId")=rset.Data("DiagnosTypeRowId")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosBodyPart")=rset.Data("DiagnosBodyPart")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosBodyPartRowId")=rset.Data("DiagnosBodyPartRowId")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosDoctor")=rset.Data("DiagnosDoctor")
			s DiagGridRowAry(USERID,MRADM,"OLD","LongDiagnosFlagRowId")=rset.Data("LongDiagnosFlagRowId")
			s DiagGridRowAry(USERID,MRADM,"OLD","LongDiagnosFlag")=$case(rset.Data("LongDiagnosFlagRowId"),"L":##class(websys.Translation).Get("diagnosentry.v8.csp","本科"),"H":##class(websys.Translation).Get("diagnosentry.v8.csp","全科"),:"")
			s DiagGridRowAry(USERID,MRADM,"OLD","DiagnosPrefix")=rset.Data("DiagnosPrefix")
			s total=+total+1
			s records=+records+1
			s onedata=##class(web.DHCDocDiagnosEntryV8).GetDiagJSONStr(USERID,MRADM,.DiagGridRowAry)
			i onedata="" continue
			if (data=""){
				s data=onedata
			}else{
				s data=","_onedata
			}
			w data
		}	
		d rset.Close()
	}*/
	w "]}"
	q
}

}
