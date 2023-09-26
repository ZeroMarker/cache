Class web.DHCInterfaceAnOperation Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetDeptDict(inPut As %String = "") As %GlobalCharacterStream
{
	;w ##class(web.DHCInterfaceAnOperation).GetDeptDict()
	s retStr=""
	s retStr=##class(%GlobalCharacterStream).%New()
	d retStr.Rewind()
	d retStr.Write("<Response>")
	s ret=0
    s ctlocId=""
    f  s ctlocId=$O(^CTLOC(+ctlocId)) q:ctlocId=""  d
    .s myobj=##class(User.DHCInterfaceDeptDict).%New()
    .s myobj.SerialNO =$p($g(^CTLOC(+ctlocId)),"^",19)
    .i myobj.SerialNO="" s myobj.SerialNO=" "
	.s myobj.DeptName=$p($g(^CTLOC(+ctlocId)),"^",1)     //$p($g(^CTLOC(+ctlocId)),"^",2)
	.s myobj.DeptCode =ctlocId                           //$p($g(^CTLOC(+ctlocId)),"^",1)
	.s ctDesc=$p($g(^CTLOC(+ctlocId)),"^",2)
	.s myobj.InputCode =$P($G(ctDesc),"-")
	.s Xml=##class(%GlobalCharacterStream).%New()
	.s ret=myobj.XMLExportToStream(.Xml,"HisUsers")
	.q:ret=0
	.d retStr.CopyFrom(Xml)
	//.s Xml=""
	//.s ret=myobj.XMLExportToString(.Xml,"DeptDict")
	//.q:ret=0
	//.i retStr'="" s retStr=retStr_Xml
	//.e  s retStr=Xml
	//.s Xml=""
	//q "<Response>"_retStr_"</Response>"
	d retStr.Write("</Response>")
	q retStr
}

ClassMethod GetHisUsers(inPut As %String = "") As %GlobalCharacterStream
{
	;w ##class(web.DHCInterfaceAnOperation).GetHisUsers()
	s retStr=""
	s ret=0
    s userId=""
    s retStr=##class(%GlobalCharacterStream).%New()
    d retStr.Rewind()
    d retStr.Write("<Response>")
    f  s userId=$O(^SSU("SSUSR",userId))  q:userId=""  d
    .s SSusrActive=$p(^SSU("SSUSR",userId),"^",19)
	.q:SSusrActive'="Y" 
	.s myobj=##class(User.DHCInterfaceHisUsers).%New()
	.s myobj.UserID =$P($G(^SSU("SSUSR",userId)),"^",1)
	.s myobj.UserName=$P($G(^SSU("SSUSR",userId)),"^",2)
	.s logctlocDr=$P($G(^SSU("SSUSR",userId)),"^",4)
	.i logctlocDr'="" s logctlocCode=$p($g(^CTLOC(+logctlocDr)),"^",1)
	.e  s logctlocCode=" "
	.s myobj.UserDept =logctlocDr            //$G(logctlocCode)
	.s ctpcpDr=$P($G(^SSU("SSUSR",userId)),"^",14)
	.q:ctpcpDr=""
	.i ctpcpDr'="" d
	..s ctptpDr=$P($G(^CTPCP(ctpcpDr,1)),"^",4)
	..i ctptpDr'=""  s ctptpDesc=$P($G(^CT("CPT",ctptpDr)),"^",2)
	..e  s ctptpDesc=" "
	.e  s ctptpDesc=" "
	.s myobj.UserJob =$G(ctptpDesc)
	.s myobj.CreateDate=" "
	.s Xml=##class(%GlobalCharacterStream).%New()
	.s ret=myobj.XMLExportToStream(.Xml,"HisUsers")
	.q:ret=0
	.d retStr.CopyFrom(Xml)
	.//i retStr'="" s retStr=retStr_Xml
	.//e  s retStr=Xml
	.//s Xml=""
	//d retStr.SaveStream()
	d retStr.Write("</Response>")
	q retStr
	//d retStr.%Close()
	/*d retStr.Rewind()
    Set reader=##class(%XML.Reader).%New()
    Set sc=reader.OpenStream(retStr)
    Do reader.Correlate("HisUsers","User.DHCInterfaceHisUsers")
    b
	While reader.Next(.person,.sc1)
	{
	b
       s count=person.UserName
       w count
	}*/
}

ClassMethod GetPatientMasterIndex(papmiNo As %String) As %String
{
	//papmiNo=papmiNo_"^"_admId
	;w ##class(web.DHCInterfaceAnOperation).GetPatientMasterIndex("1")
	s retStr=""
	s ret=0
	s myobj=##class(User.DHCInterfacePatientMasterIndex).%New()
    s admId=$P(papmiNo,"^",2)
    s papmiNo=$P(papmiNo,"^")
    i admId="" d
    .s papmiId=$O(^PAPERi("PAPMI_PatNo",papmiNo,""))
    .s admId=$O(^PAPERdr(papmiId,"ADM","I",""),-1)
    e  d
    .s papmiId=+^PAADM(admId)
    .s admType=$p($G(^PAADM(admId)),"^",2)
    .i admType="I" s papmiNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",1)
 	.e  s papmiNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",2)
    s myobj.PatientID =$G(papmiNo)   //$p($G(^PAPER(papmiId,"PAT",1)),"^",2)
    s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s myobj.InpNO=$G(MedCareNo)  //$p($G(^PAPER(papmiId,"PAT",1)),"^",1)
	s myobj.Name=$p($G(^PAPER(papmiId,"ALL")),"^",1)
	s myobj.NamePhonetic=$p($G(^PAPER(papmiId,"ALL")),"^",2)
	s sexDr=$p($G(^PAPER(papmiId,"ALL")),"^",7)
	i sexDr'="" s sexDesc=$P($G(^CT("SEX",sexDr)),"^",2)
	e  s sexDesc=" "
	s myobj.Sex=$G(sexDesc)
	s dob=$p($G(^PAPER(papmiId,"ALL")),"^",6)
	i dob'="" s dob=$zd(dob,3)
	s myobj.DateOfBirth=$G(dob)
    s cityDr=$p($G(^PAPER(papmiId,"ALL")),"^",18)
    i cityDr'="" s cityDesc=$P($G(^CT("CIT",cityDr)),"^",2)
    e  s cityDesc=" "
    s myobj.BirthPlace=$G(cityDesc)
    s countryDr=$p($G(^PAPER(papmiId,"ALL")),"^",11) 
    i countryDr'="" s countryDesc=$P($G(^CT("COU",countryDr)),"^",2)
    e  s countryDesc=" "
    s myobj.Citizenship=$G(countryDesc)
    s nationDr=$p($G(^PAPER(papmiId,"PER",2)),"^",1)
    i nationDr'="" s nationDesc=$P($G(^CT("NAT",nationDr)),"^",2)
    e  s nationDesc=" "
    s myobj.Nation=$G(nationDesc) 
    s myobj.IDNO=$p($G(^PAPER(papmiId,"ALL")),"^",9)
    s emplTypeDr=$P($G(^PAPER(papmiId,"EMP")),"^",1)
    i emplTypeDr'="" s emplTypeDesc=$P($G(^PAC("EPE",emplTypeDr)),"^",2) 
    e   s emplTypeDesc=" "
    s myobj.Identity=$G(emplTypeDesc)
    s reasonDr=$P($G(^PAADM(admId,1)),"^",7)
    i reasonDr'="" s reasonDesc=$P($G(^PAC("ADMREA",reasonDr)),"^",2)
    e  s reasonDesc=" "
    s myobj.ChargeType=$G(reasonDesc)
    s myobj.MailingAddress=$G(^PAPER(papmiId,"PER","ADD",1))   
    s zipDr=$P($G(^PAPER(papmiId,"PER",1)),"^",7)
    i zipDr'="" s zipCode=$P($G(^CT("ZIP",zipDr)),"^",1)
    e  s zipCode=" "
    s myobj.ZipCode=$G(zipCode)
    s myobj.PhoneNumberHome=$P($G(^PAPER(papmiId,"PER",1)),"^",11)
    s myobj.PhoneNumbeBusiness=$P($G(^PAPER(papmiId,"PER",1)),"^",9)
    s myobj.NextOfKin=$P($G(^PAPER(papmiId,"PER",2)),"^",13)
    s relationDr=$P($G(^PAPER(papmiId,"EMP")),"^",4)
    i relationDr'="" s relationDesc=$P($G(^CT("RLT",relationDr)),"^",2)
    e  s relationDesc=" "
    s myobj.RelationShip=$G(relationDesc)
    s myobj.NextOfKinAddr=$P($G(^PAPER(papmiId,"PER",1)),"^",1)
    s myobj.NextOfKinZipCode=$P($G(^PAPER(papmiId,"PER",2)),"^",8)
    s myobj.NextOfKinPhome=$P($G(^PAPER(papmiId,"ALL")),"^",4)
    s myobj.LastVisitDate=""
    s myobj.VipIndicator=$P($G(^PAPER(papmiId,"PAT",4)),"^",1)
	s myobj.CreateDate=$ZD($P($G(^PAPER(papmiId,"PER",5)),"^",17),3)
	s adduserDr=$P($G(^PAPER(papmiId,"PER",5)),"^",18)
	i adduserDr'="" s adduserDesc=$P($G(^SSU("SSUSR",adduserDr)),"^",2)
	e  s adduserDesc=" "
	s myobj.Operator=$G(adduserDesc)
	s Xml=""
	s ret=myobj.XMLExportToString(.Xml,"PatientMasterIndex")
	i ret=1 s retStr=Xml
	q "<Response>"_retStr_"</Response>"
}

ClassMethod GetInPatientInfo(admId As %String) As %String
{
	;w ##class(web.DHCInterfaceAnOperation).GetInPatientInfo("1")
	s retStr=""
	s ret=0
	s myobj=##class(User.DHCInterfaceInPatientInfo).%New()
    s admType=$p($G(^PAADM(admId)),"^",2)
    s papmiId=$p($G(^PAADM(admId)),"^",1)
    i admType="I" s regNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",1)
 	e  s regNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",2)
	s myobj.PatientID =$G(regNo)
	s myobj.VisitID =$G(admId)
	s wardDr=$P($G(^PAADM(admId)),"^",70)
	i wardDr'="" s ctlocRowId=$P($G(^PAWARD(wardDr)),"^",5)
	e  s ctlocRowId=" "
	/*i wardDr'="" s wardCode=$P($G(^PAWARD(wardDr)),"^")
	e  s wardCode=" "*/
	s myobj.WardCode =ctlocRowId        ///$G(wardCode)
	s ctlocDr=$P($G(^PAADM(admId)),"^",4)
	i ctlocDr'="" s ctlocCode=$P($G(^CTLOC(ctlocDr)),"^")
	e  s ctlocCode=" "
	s myobj.DeptCode =$G(ctlocDr)       ///$G(ctlocCode)
	s bedDr=$P($G(^PAADM(admId)),"^",73)
	i bedDr'="" s bedCode=$P($G(^PAWARD($P(bedDr,"||"),"BED",$P(bedDr,"||",2))),"^")
	e  s bedCode=" "
	s myobj.BedNO =$G(bedCode)
	s myobj.AdmissionDateTime =$ZD($P($G(^PAADM(admId)),"^",6),3)
	s ctcpDr=$P($G(^PAADM(admId)),"^",9)
	i ctcpDr'=""  s ssUserId=$O(^SSU("SSUSR",0,"CTPCP",ctcpDr,""))
	e  s ssUserId=" "
	/*i ctcpDr'="" s ctcpDesc=$P($G(^CTPCP(ctcpDr,1)),"^",2)
	e  s ctcpDesc=" "*/
	s myobj.DoctorInCharge =$G(ssUserId)           //$G(ctcpDesc)
	s mradmDr=$P($G(^PAADM(admId)),"^",61)
	s mrdiagDesc=""
	i mradmDr'="" d
		.s diagStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradmDr)
		.s digStrLength=$l(diagStr,"^")
		.f dnum=1:1:digStrLength d
			..s curDiagStr=$p(diagStr,"^",dnum)
			..s curDesc=$p(curDiagStr,"|",1)
			..s curId=$p(curDiagStr,"|",2)
			..s curNote=$p(curDiagStr,"|",3)
			..s curPreFix=$p(curDiagStr,"|",4)
			..s newDiagStr=curPreFix_curDesc_curNote
			..i mrdiagDesc'="" s mrdiagDesc=mrdiagDesc_","_newDiagStr
			..e  s mrdiagDesc=newDiagStr
		
	/*
	.s mradmSub=0
	.f  s mradmSub=$O(^MR(mradmDr,"DIA",mradmSub)) q:(mradmSub="")  d
	..s typSub=0  f  s typSub=$O(^MR(mradmDr,"DIA",mradmSub,"TYP",typSub)) q:(typSub="")   d
	...s dtypId=$P(^MR(mradmDr,"DIA",mradmSub,"TYP",typSub),"^",1)
	...q:dtypId=""
	...s typCode=$p($G(^MRC("DTYP",dtypId)),"^",1)
	...q:typCode'="PRE"
	...s MRDIAICDCodeDR=$p($G(^MR(mradmDr,"DIA",mradmSub)),"^",1)
	...q:MRDIAICDCodeDR=""
	...i mrdiagDesc="" s mrdiagDesc=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	...e  s mrdiagDesc=mrdiagDesc_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	i mrdiagDesc="" s mrdiagDesc=" "
	*/
	
	s myobj.ClinDiag =$G(mrdiagDesc)
	s myobj.Memo =""
	s Xml=""
	s ret=myobj.XMLExportToString(.Xml,"InPatientInfo")
	i ret=1 s retStr=Xml
	q "<Response>"_retStr_"</Response>"
}

ClassMethod GetOperationSchedule(startDate As %String, endDate As %String, operCtlocCode As %String = "", opaCollectedStatus As %String = "") As %GlobalCharacterStream
{
	//w ##class(web.DHCInterfaceAnOperation).GetOperationSchedule("20080101","20080808","","")
	//s retString=""
	//s ret1=""
    s retString=##class(%GlobalCharacterStream).%New()
    d retString.Rewind()
    d retString.Write("<Response>")
	s startDate=$ZDH(startDate,5)
	s endDate=$ZDH(endDate,5)
    f date=startDate:1:endDate
    {  
    	s opRowId="" 
        f  s opRowId=$O(^DHCANOPArrange(0,"SDate",date,opRowId)) q:opRowId=""  d 
	    .s oprRoomDr=$P($G(^DHCANOPArrange(opRowId)),"^",20)
	    .i oprRoomDr'="" d
	    ..s oprDeptDr=$P($G(^DHCANC("OPRoom",oprRoomDr)),"^",3)
	    ..i oprDeptDr'=""   s oprDeptCode=$P($G(^CTLOC(oprDeptDr)),"^")
        ..e  s oprDeptCode=" "
        .e  s oprDeptCode=" "
        .q:(oprDeptCode'=operCtlocCode)&(operCtlocCode'="")
        .s collectedStatus=$P($G(^DHCANOPArrange(opRowId)),"^",18)
        .q:(opaCollectedStatus'[collectedStatus)&(opaCollectedStatus'="")
        .s ret1=##class(%GlobalCharacterStream).%New()
        .s ret1=..GetAnOpApp(opRowId)
        .d retString.CopyFrom(ret1)
        .//i retString'="" s retString=retString_ret1
        .//e  s retString=ret1
	}
	d retString.Write("</Response>")
	q $G(retString)
}

ClassMethod GetAnOpApp(opRowId As %String) As %GlobalCharacterStream
{
	;w ##class(web.DHCInterfaceAnOperation).GetAnOpApp("1")
	s retStr=""
	s ret=0
    s retStr=##class(%GlobalCharacterStream).%New()
    d retStr.Rewind()
	s myobj=##class(User.DHCInterfaceOperationSchedule).%New()
    s admId=$P($G(^DHCANOPArrange(opRowId)),"^",1)
    s admType=$p($G(^PAADM(admId)),"^",2)
    s papmiId=$p($G(^PAADM(admId)),"^",1)
    i admType="I" s regNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",1)
 	e  s regNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",2)
	s myobj.PatientID =$G(regNo)
	s myobj.VisitID =$G(admId)
    s myobj.ScheduleID=$G(opRowId)
    s patDeptDr=$P($G(^DHCANOPArrange(opRowId)),"^",21)
    i patDeptDr="" s patDeptDr=" "
    /*i patDeptDr'="" s patDeptCode=$P($G(^CTLOC(patDeptDr)),"^")
	e  s patDeptCode=" "*/
    s myobj.DeptStayed=$G(patDeptDr)  //$G(patDeptCode)
	s bedDr=$P($G(^PAADM(admId)),"^",73)
	i bedDr'="" s bedCode=$P($G(^PAWARD($P(bedDr,"||"),"BED",$P(bedDr,"||",2))),"^")
	e  s bedCode=" "
	s myobj.BedNO =$G(bedCode)
    s opaStartDate=$P($G(^DHCANOPArrange(opRowId)),"^",14)
    s opaStartTime=$P($G(^DHCANOPArrange(opRowId)),"^",15)
    s opaStartDateTime=$ZD(opaStartDate,3)_" "_$ZT(opaStartTime)
    s myobj.ScheduledDateTime=$G(opaStartDateTime)
    s oprDr=$P($G(^DHCANOPArrange(opRowId)),"^",20)
    i oprDr'="" d
    .s oprDesc=$P($G(^DHCANC("OPRoom",oprDr)),"^",2)
    .s oprDeptDr=$P($G(^DHCANC("OPRoom",oprDr)),"^",3)
    .i oprDeptDr="" s oprDeptDr=" "
    e  d
    .s oprDesc=" "
    .s oprDeptDr=" "
    /*.i oprDeptDr'=""   s oprDeptCode=$P($G(^CTLOC(oprDeptDr)),"^")
    .e   s oprDeptCode=" "
    e  d
    .s oprDesc=" "
    .s oprDeptCode=" "*/
    s myobj.OperatingRoom=$G(oprDeptDr)
    s myobj.OperatingRoomNo=$G(oprDesc)    
    s myobj.Sequence=$P($G(^DHCANOPArrange(opRowId)),"^",26)
    s anaId=$P($G(^DHCANOPArrange(opRowId)),"^",2)
	s admId=$P(anaId,"||",1)
	s anaSub=$P(anaId,"||",2)
	s anaopSub=0  s anaopSub=$O(^OR(admId,"ANA",anaSub,"OP",anaopSub))
	i anaopSub="" s operDiagDesc=""
	e  d
	.s operDiagDr=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub)),"^",4)
	.i operDiagDr'="" s operDiagDesc=$P($G(^MRC("ID",operDiagDr)),"^",2)
	.e  s operDiagDesc=" "
    s myobj.DiagBeforeOperation=$G(operDiagDesc)
    s myobj.PatientCondition=""
    s oplevelDr=$P($G(^DHCANOPArrange(opRowId)),"^",28)
    i oplevelDr'=""  s oplevelDesc=$P($G(^DHCANC("OPLevel",oplevelDr)),"^",2)
    e  s oplevelDesc=" "
    s myobj.OperationScale=$G(oplevelDesc)
    s opaEmergencyFlage=$P($G(^DHCANARRAGE("ch",opRowId)),"^",5)
    s myobj.EmergencyIndicator=$G(opaEmergencyFlage)
    i $P($G(^DHCANOPArrange(opRowId)),"^",10)="" d
    .s myobj.IsolationIndicator=1
    e  d
    .s myobj.IsolationIndicator=$P($G(^DHCANOPArrange(opRowId)),"^",10)
    s myobj.OperatingDept=$G(oprDeptDr)  //$G(patDeptCode)
    i anaopSub'=""  d
    .s opSurgeonDr=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub)),"^",8)
	.i opSurgeonDr'=""  s opSurgeonId=$O(^SSU("SSUSR",0,"CTPCP",opSurgeonDr,""))
	.e  s opSurgeonId=" "
    e  s opSurgeonId=" "
    /*.i opSurgeonDr'="" s opSurgeonDesc=$P($G(^CTPCP(opSurgeonDr,1)),"^",2)
    .e  s opSurgeonDesc=" "
    e  s opSurgeonDesc=" "*/
    s myobj.Surgeon=$G(opSurgeonId)    //$G(opSurgeonDesc)
    s opasDr1=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ASS",1)),"^",1)
	i opasDr1'=""  s opasId1=$O(^SSU("SSUSR",0,"CTPCP",opasDr1,""))
	e  s opasId1=" "
    /*i opasDr1'="" s opasDesc1=$P($G(^CTPCP(opasDr1,1)),"^",2)
    e  s opasDesc1=" "*/
    s opasDr2=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ASS",2)),"^",1)
	i opasDr2'=""  s opasId2=$O(^SSU("SSUSR",0,"CTPCP",opasDr2,""))
	e  s opasId2=" "
    /*i opasDr2'="" s opasDesc2=$P($G(^CTPCP(opasDr2,1)),"^",2)
    e  s opasDesc2=" "*/
    s opasDr3=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ASS",3)),"^",1)
	i opasDr3'=""  s opasId3=$O(^SSU("SSUSR",0,"CTPCP",opasDr3,""))
	e  s opasId3=" "
    /*i opasDr3'="" s opasDesc3=$P($G(^CTPCP(opasDr3,1)),"^",2)
    e  s opasDesc3=" "*/
    s opasDr4=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ASS",4)),"^",1)
	i opasDr4'=""  s opasId4=$O(^SSU("SSUSR",0,"CTPCP",opasDr4,""))
	e  s opasId4=" "
    /*i opasDr4'="" s opasDesc4=$P($G(^CTPCP(opasDr4,1)),"^",2)
    e  s opasDesc4=" "*/
    s myobj.FirstAssistant=$G(opasId1)   //$G(opasDesc1)
    s myobj.SecondAssistant=$G(opasId2)  //$G(opasDesc2)
    s myobj.ThirdAssistant=$G(opasId3)   //$G(opasDesc3)
    s myobj.FourthAssistant=$G(opasId4)  //$G(opasDesc4)
    s anmedthodDr=$P($G(^OR(admId,"ANA",anaSub)),"^",5)
    i anmedthodDr'="" s anmedthodDesc=$P($G(^ORC("ANMET",anmedthodDr)),"^",2)
    e  s anmedthodDesc=" "
    s myobj.AnesthesiaMethod=$G(anmedthodDesc)
    s anaDr=$P($G(^OR(admId,"ANA",anaSub)),"^",6)
	i anaDr'=""  s anaId=$O(^SSU("SSUSR",0,"CTPCP",anaDr,""))
	e  s anaId=" "
    /*i anaDr'="" s anaDesc=$P($G(^CTPCP(anaDr,1)),"^",2)
    e  s anaDesc=" "*/
    s myobj.AnesthesiaDoctor=$G(anaId)  //$G(anaDesc)
    s anassDr1=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",1)),"^")
	i anassDr1'=""  s anassId1=$O(^SSU("SSUSR",0,"CTPCP",anassDr1,""))
	e  s anassId1=" "
    /*i anassDr1'="" s anassDesc1=$P($G(^CTPCP(anassDr1,1)),"^",2)
    e  s anassDesc1=" "*/
    s anassDr2=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",2)),"^")
	i anassDr2'=""  s anassId2=$O(^SSU("SSUSR",0,"CTPCP",anassDr2,""))
	e  s anassId2=" "
    /*i anassDr2'="" s anassDesc2=$P($G(^CTPCP(anassDr2,1)),"^",2)
    e  s anassDesc2=" "*/
    s myobj.SecondAnesthesiaDoctor=$G(anassId1)   //$G(anassDesc1)
    s myobj.ThirdAnesthesiaDoctor=$G(anassId2)    //$G(anassDesc2) 
    s anassDr3=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",21)),"^")
	i anassDr3'=""  s anassId3=$O(^SSU("SSUSR",0,"CTPCP",anassDr3,""))
	e  s anassId3=" "
    /*i anassDr3'="" s anassDesc3=$P($G(^CTPCP(anassDr3,1)),"^",2)
    e  s anassDesc3=" "*/
    s anassDr4=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",22)),"^")
	i anassDr4'=""  s anassId4=$O(^SSU("SSUSR",0,"CTPCP",anassDr4,""))
	e  s anassId4=" "
    /*i anassDr4'="" s anassDesc4=$P($G(^CTPCP(anassDr4,1)),"^",2)
    e  s anassDesc4=" "*/
    s anassDr5=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",23)),"^")
	i anassDr5'=""  s anassId5=$O(^SSU("SSUSR",0,"CTPCP",anassDr5,""))
	e  s anassId5=" "
    /*i anassDr5'="" s anassDesc5=$P($G(^CTPCP(anassDr5,1)),"^",2)
    e  s anassDesc5=" "*/
    s anassDr6=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",24)),"^")
	i anassDr6'=""  s anassId6=$O(^SSU("SSUSR",0,"CTPCP",anassDr6,""))
	e  s anassId6=" "
    /*i anassDr6'="" s anassDesc6=$P($G(^CTPCP(anassDr6,1)),"^",2)
    e  s anassDesc6=" "*/
    s anassDr7=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",25)),"^")
	i anassDr7'=""  s anassId7=$O(^SSU("SSUSR",0,"CTPCP",anassDr7,""))
	e  s anassId7=" "
    /*i anassDr7'="" s anassDesc6=$P($G(^CTPCP(anassDr7,1)),"^",2)
    e  s anassDesc7=" "*/
    s myobj.AnesthesiaAssistant=$G(anassId3)         //$G(anassDesc3)
    s myobj.SecondAnesthesiaAssistant=$G(anassId4)   //$G(anassDesc4)
    s myobj.ThirdAnesthesiaAssistant=$G(anassId5)    //$G(anassDesc5)
    s myobj.FourthAnesthesiaAssistant=$G(anassId6)   //$G(anassDesc6)
    s myobj.BloodTranDoctor=$G(anassId7)             //$G(anassDesc7)
    s opscnDr1=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",1)),"^")
	i opscnDr1'=""  s opscnId1=$O(^SSU("SSUSR",0,"CTPCP",opscnDr1,""))
	e  s opscnId1=" "
    /*i opscnDr1'="" s opscnDesc1=$P($G(^CTPCP(opscnDr1,1)),"^",2)
    e  s opscnDesc1=" "*/
    s opscnDr2=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",2)),"^")
	i opscnDr2'=""  s opscnId2=$O(^SSU("SSUSR",0,"CTPCP",opscnDr2,""))
	e  s opscnId2=" "
    /*i opscnDr2'="" s opscnDesc2=$P($G(^CTPCP(opscnDr2,1)),"^",2)
    e  s opscnDesc2=" "*/
    s myobj.FirstOperationNurse=$G(opscnId1)  //$G(opscnDesc1)
    s myobj.SecondOperationNurse=$G(opscnId2) //$G(opscnDesc2)
    s opcirnDr1=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",1)),"^")
	i opcirnDr1'=""  s opcirnId1=$O(^SSU("SSUSR",0,"CTPCP",opcirnDr1,""))
	e  s opcirnId1=" "
    /*i opcirnDr1'="" s opcirnDesc1=$P($G(^CTPCP(opcirnDr1,1)),"^",2)
    e  s opcirnDesc1=" "*/
    s opcirnDr2=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",2)),"^")
	i opcirnDr2'=""  s opcirnId2=$O(^SSU("SSUSR",0,"CTPCP",opcirnDr2,""))
	e  s opcirnId2=" "
    /*i opcirnDr2'="" s opcirnDesc2=$P($G(^CTPCP(opcirnDr1,1)),"^",2)
    e  s opcirnDesc2=" "*/
    s opcirnDr3=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",3)),"^")
	i opcirnDr3'=""  s opcirnId3=$O(^SSU("SSUSR",0,"CTPCP",opcirnDr3,""))
	e  s opcirnId3=" "
    /*i opcirnDr3'="" s opcirnDesc3=$P($G(^CTPCP(opcirnDr1,1)),"^",2)
    e  s opcirnDesc3=" " */
    s myobj.FirstSupplyNurse=$G(opcirnId1)  //$G(opcirnDesc1)
    s myobj.SecondSupplyNurse=$G(opcirnId2) //$G(opcirnDesc2)
    s myobj.ThirdSupplyNurse=$G(opcirnId3)  //$G(opcirnDesc3)
    s anaNotes=$G(^OR(admId,"ANA",anaSub,"TXT"))
    s myobj.NotesOnOperation=$G(anaNotes)
    s opaAppDate=$P($G(^DHCANOPArrange(opRowId)),"^",3)
    i opaAppDate'="" s opaAppDate=$ZD(opaAppDate,3)
    s opaAppTime=$P($G(^DHCANOPArrange(opRowId)),"^",5)
    i opaAppTime'="" s opaAppTime=$ZT(opaAppTime)
    s myobj.ReqDateTime=$G(opaAppDate)_" "_$G(opaAppTime)
    s myobj.EnteredBy=" "
    i $P($G(^DHCANOPArrange(opRowId)),"^",18)="" d
    .s myobj.OperStatus="N"
    e  d
    .s myobj.OperStatus=$P($G(^DHCANOPArrange(opRowId)),"^",18)
	//s Xml=""
	s Xml=##class(%GlobalCharacterStream).%New()
	s ret=myobj.XMLExportToStream(.Xml,"OperationSchedule")
	i ret=1 s retStr=Xml
	e  s retStr=""
	q retStr
}

ClassMethod GetOperationScheduleName(opRowId As %String) As %String
{
	;w ##class(web.DHCInterfaceAnOperation).GetOperationScheduleName("1")
	s retString=""
	s ret1=""
	s anaId=$P($G(^DHCANOPArrange(opRowId)),"^",2)
	s adm=$P(anaId,"||",1)
	s anaSub=$P(anaId,"||",2)
	s anaopSub=0
	f  s anaopSub=$O(^OR(adm,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")||(anaopSub=0)  d
	.s opanRowId=opRowId_"||"_anaopSub
	.s ret1=..GetAnOperationName(opanRowId)
	.i ret1'="" s retString=retString_ret1
	.e  s retString=ret1
	q "<Response>"_retString_"</Response>"
}

ClassMethod GetAnOperationName(opanRowId As %String) As %String
{
	;w ##class(web.DHCInterfaceAnOperation).GetAnOperationName("1||1")
	s retStr=""
	s ret=0
	s myobj=##class(User.DHCInterfaceOperationName).%New()
    s opRowId=$P(opanRowId,"||")
    s anaopSub=$P(opanRowId,"||",2)
    s admId=$P($G(^DHCANOPArrange(opRowId)),"^",1)
    s admType=$p($G(^PAADM(admId)),"^",2)
    s papmiId=$p($G(^PAADM(admId)),"^",1)
    i admType="I" s regNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",1)
 	e  s regNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",2)
    s myobj.PatientID=$G(regNo)
    s myobj.VisitID=$G(admId)
    s myobj.ScheduleID=$G(opRowId)
    s anaId=$P($G(^DHCANOPArrange(opRowId)),"^",2)
	s admId=$P(anaId,"||",1)
	s anaSub=$P(anaId,"||",2)
	s operDr=$P($G(^OR(admId,"ANA",anaSub,"OP",anaopSub)),"^",6)
	i operDr'=""  s operDesc=$P($G(^ORC("OPER",operDr)),"^",2)
	e  s operDesc=" "
    s myobj.OperationNO=$G(anaopSub)
    s myobj.Operation=$G(operDesc)
    s oplevelDr=$P($G(^DHCANOPArrange(opRowId)),"^",28)
    i oplevelDr'="" s oplevelDesc=$P($G(^DHCANC("OPLevel",oplevelDr)),"^",2)
    e  s oplevelDesc=" "
    s myobj.OperationScale=$G(oplevelDesc)
	s Xml=""
	s ret=myobj.XMLExportToString(.Xml,"OperationScheduleName")
	i ret=1 s retStr=Xml
	e  s retStr=""
	q retStr
}

ClassMethod UpdateOperStatus(opRowId As %String, opaCollectedStatus As %String) As %String
{
	;w ##class(web.DHCInterfaceAnOperation).UpdateOperStatus("1","N")
	s ret=0
	s retStr=""
	s myobj=##class(User.DHCAnOPMsgReturn).%New()
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_CollectedStatus=:opaCollectedStatus where opa_rowid=:opRowId)
	i SQLCODE=0 s resultCode=0
	e  s resultCode=1
	s myobj.ResultCode =$G(resultCode)
	i SQLCODE=0 s myobj.ErrorMsg="更新成功"
	e  s myobj.ErrorMsg="SQL error"_SQLCODE
	s Xml=""
	s ret=myobj.XMLExportToString(.Xml,"OperStatus")
	i ret=1 s retStr=Xml
	q "<Response>"_retStr_"</Response>"
}

ClassMethod GetLocOperPatInfo(ctlocId As %String, date As %String = "") As %GlobalCharacterStream
{
	;w ##class(web.DHCInterfaceAnOperation).GetLocOperPatInfo(831)
	s i=0
	s retStr=""
	s ret=0
    s curDate=""
    s retStr=##class(%GlobalCharacterStream).%New()
    d retStr.Rewind()
    d retStr.Write("<Response>")
    s appArcimId=$g(^DHCCLSet("AnOp","AppArcimId"))
    f  s curDate=$O(^PAADMi("CurrLoc",ctlocId,curDate)) q:curDate=""  d
    .s curTime=""
    .f  s curTime=$O(^PAADMi("CurrLoc",ctlocId,curDate,curTime)) q:curTime=""  d
    ..s EpisodeID=""
    ..f  s EpisodeID=$O(^PAADMi("CurrLoc",ctlocId,curDate,curTime,EpisodeID)) q:EpisodeID=""  d
    ...q:'$d(^PAADM(EpisodeID))
    ...//q:i>0
    ...//w EpisodeID,!
    ...s i=i+1
    ...s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	...q:oeordId=""
	...
	...s retno=0
	...s flag=0,curOeoriSub=""
	...q:appArcimId=""
	...s num=$l(appArcimId,"^")
	...
	...for i=1:1:num d
	....q:flag=1
	....s testdate=60748
	....s arcimId=$p(appArcimId,"^",i)
	....q:arcimId=""
	....//s oeoriSub="" for  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,+$h,oeoriSub)) q:oeoriSub=""  d
	....s oeoriSub="" for  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,testdate,oeoriSub)) q:oeoriSub=""  d
	.....q:'$d(^OEORD(oeordId,"I",oeoriSub))
	.....s statdr=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13)
	.....q:(statdr'=1)
    .....s myobj=##class(User.DHCInterfaceInPatientInfo).%New()
    .....s admType=$p($G(^PAADM(EpisodeID)),"^",2)
    .....s papmiId=$p($G(^PAADM(EpisodeID)),"^",1)
    .....i admType="I" s regNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",1)
 	.....e  s regNo=$p($G(^PAPER(papmiId,"PAT",1)),"^",2)
	.....s myobj.PatientID =$G(regNo)
	.....s myobj.VisitID =$G(EpisodeID)
	.....s wardDr=$P($G(^PAADM(EpisodeID)),"^",70)
	.....i wardDr'="" s ctlocRowId=$P($G(^PAWARD(wardDr)),"^",5)
	.....e  s ctlocRowId=" "
	.....s myobj.WardCode =ctlocRowId        ///$G(wardCode)
	.....s ctlocDr=$P($G(^PAADM(EpisodeID)),"^",4)
	.....i ctlocDr'="" s ctlocCode=$P($G(^CTLOC(ctlocDr)),"^")
	.....e  s ctlocCode=" "
	.....s myobj.DeptCode =$G(ctlocDr)       ///$G(ctlocCode)
	.....s bedDr=$P($G(^PAADM(EpisodeID)),"^",73)
	.....i bedDr'="" s bedCode=$P($G(^PAWARD($P(bedDr,"||"),"BED",$P(bedDr,"||",2))),"^")
	.....e  s bedCode=" "
	.....s myobj.BedNO =$G(bedCode)
	.....s myobj.AdmissionDateTime =$ZD($P($G(^PAADM(EpisodeID)),"^",6),3)
	.....s ctcpDr=$P($G(^PAADM(EpisodeID)),"^",9)
	.....i ctcpDr'=""  s ssUserId=$O(^SSU("SSUSR",0,"CTPCP",ctcpDr,""))
	.....e  s ssUserId=" "
	.....s myobj.DoctorInCharge =$G(ssUserId)           //$G(ctcpDesc)
	.....s mradmDr=$P($G(^PAADM(EpisodeID)),"^",61)
	.....s mrdiagDesc=""
	.....i mradmDr'="" d
	......s diagStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradmDr)
	......s digStrLength=$l(diagStr,"^")
	......f dnum=1:1:digStrLength d
	.......s curDiagStr=$p(diagStr,"^",dnum)
	.......s curDesc=$p(curDiagStr,"|",1)
	.......s curId=$p(curDiagStr,"|",2)
	.......s curNote=$p(curDiagStr,"|",3)
	.......s curPreFix=$p(curDiagStr,"|",4)
	.......s newDiagStr=curPreFix_curDesc_curNote
	.......i mrdiagDesc'="" s mrdiagDesc=mrdiagDesc_","_newDiagStr
	.......e  s mrdiagDesc=newDiagStr
	.....;.s mradmSub=0
	.....;.f  s mradmSub=$O(^MR(mradmDr,"DIA",mradmSub)) q:(mradmSub="")  d
	.....;..s typSub=0  f  s typSub=$O(^MR(mradmDr,"DIA",mradmSub,"TYP",typSub)) q:(typSub="")   d
	.....;...s dtypId=$P(^MR(mradmDr,"DIA",mradmSub,"TYP",typSub),"^",1)
	.....;...q:dtypId=""
	.....;...s typCode=$p($G(^MRC("DTYP",dtypId)),"^",1)
	.....;...q:typCode'="PRE"
	.....;...s MRDIAICDCodeDR=$p($G(^MR(mradmDr,"DIA",mradmSub)),"^",1)
	.....;...q:MRDIAICDCodeDR=""
	.....;...i mrdiagDesc="" s mrdiagDesc=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	.....;...e  s mrdiagDesc=mrdiagDesc_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	.....
	.....i mrdiagDesc="" s mrdiagDesc=" "
	.....s myobj.ClinDiag =$G(mrdiagDesc)
	.....s myobj.Memo =""
	.....s patInfo=##class(web.DHCANOPCom).PatInfo("^"_EpisodeID)
    .....s myobj.MedCareNo=$p(patInfo,"^",13)
    .....s myobj.PatName=$p(patInfo,"^",5)
    .....s myobj.PatSex=$p(patInfo,"^",4)
    .....s myobj.PatAge=$p(patInfo,"^",8)
    .....s createDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    .....s createTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
    .....s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    .....s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    .....s myobj.OrderCreateDateTime=##Class(web.DHCCLCom).FormatDate(createDate)_" "_##Class(web.DHCCLCom).FormatTime(createTime)
    .....s myobj.OrderStartDateTime=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
    .....
    .....//w myobj.MedCareNo_"/"_myobj.PatName_"/"_myobj.PatSex_"/"_myobj.PatAge_"/"_myobj.OrderCreateDateTime_"/"_OrderStartDateTime
    .....//w myobj.MedCareNo_"/"_myobj.PatName_"/"_myobj.PatSex_"/"_myobj.PatAge_"/"_myobj.OrderCreateDateTime_"/"_OrderStartDateTime
    .....//////
    .....s Xml=##class(%GlobalCharacterStream).%New()
	.....s ret=myobj.XMLExportToStream(.Xml,"PatInfo")
	.....q:ret=0
	.....d retStr.CopyFrom(Xml)
	.....//w retStr
	.....///////
	.....
	.....//s ret=myobj.XMLExportToString(.Xml,"PatInfo")
	.....//i ret=1 s retStr=Xml
	//w "end",!
	d retStr.Write("</Response>")
	q retStr
}

ClassMethod Import()
{
	//w ##class(web.DHCInterfaceAnOperation).Import()
    // Create an instance of %XML.Reader
    Set reader = ##class(%XML.Reader).%New()

    // Begin processing of the file
    //Do reader.OpenFile("test.xml")
    //s ret= ##class(web.DHCInterfaceAnOperation).GetLocOperPatInfo(831)
    s ret=##class(web.DHCANAdaptor).GetOperPatInfo("2008-5-2","2012-2-2","","")
    Do reader.OpenStream(ret)
    w ret.Size,!
    
    // Associate a class name with the XML element name
    //Do reader.Correlate("PatInfo","User.DHCInterfaceInPatientInfo")
    Do reader.Correlate("PatInfo","web.DHCANRegInterface")

    // Read objects from xml file
    While (reader.Next(.object,.sc)) {
        //Write object.PatName,!
        Write object.OpDate,"/"_object.OpDoctor_"/"_sc,!
    }
    w reader.Next(.object,.sc)
 w sc,!
    // If error found during processing, show it
    If $system.Status.IsError(sc) do $system.OBJ.DisplayError(sc)
    
    q 0
}

ClassMethod ReadXML(id)
{
    /*
    set recordObj=##class(User.DHCICUXMLConfigration).%OpenId(1)
    write recordObj.DocVersion,!
    s charStream=##class(%Library.GlobalCharacterStream).%New()
    d charStream.CopyFrom(recordObj.DocContent)
    w "res="_charStream.ReadLine(),!
    Do charStream.%Close()
    q 0
    */
        //d charStream.Rewind()

    i id="" s id=1
    set recordObj=##class(User.DHCICUXMLConfig).%OpenId(id)
    write recordObj.ICUXCVersion,!
    w "ok",!
    s charStream=##class(%Library.GlobalCharacterStream).%New()
    w "kk",!
    d charStream.CopyFrom(recordObj.ICUXCLayoutConfig)
    w "res="_charStream.Read(10),!
    d charStream.CopyFrom(recordObj.ICUXCPrintConfig)

    w "res="_charStream.Read(10),!
    w "ok",!


    //Do reader.OpenStream(icuxcLayoutConfig)
    //w reader.
    //w icuxcLayoutConfig.ReadLn(),!
    //s icuxcPrintConfig=recordObj.ICUXCPrintConfig
    //w icuxcPrintConfig.readln(),!
    q 0
}

ClassMethod Test(test) As %String
{
	w ##class(OAICUDevSrv.OAICUDevSrvSoap).Description()
}

}
