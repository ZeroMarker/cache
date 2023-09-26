Class EPRmeta.FPInterface.DisPatient Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property AdmId As %String(TRUNCATE = 1);

Property PapmiDR As %String(TRUNCATE = 1) [ ReadOnly ];

Property Name As %String(TRUNCATE = 1) [ ReadOnly ];

Property RegNo As %String(TRUNCATE = 1) [ ReadOnly ];

Property PRecNo As %String(TRUNCATE = 1) [ ReadOnly ];

Property DisDate As %String(TRUNCATE = 1) [ ReadOnly ];

Property DisDept As %String(TRUNCATE = 1) [ ReadOnly ];

Property DocInCharge As %String(TRUNCATE = 1) [ ReadOnly ];

//Property EPRVersion As %String [ ReadOnly ];

Property PatInfoAssistPath As %String(TRUNCATE = 1);

Property FPInterfacePath As %String(TRUNCATE = 1);

Property FPMainCategoryId As %String(TRUNCATE = 1);

/// SubCategories of MainCategory's Ids that need to be checked for the FP integrity
Property FPSubCategoryId As %String(TRUNCATE = 1);

/// argDisDate is like "2006-1-1"
/// 根据出院日期(就诊表)检索出病人明细
ClassMethod GetDisPatByDateOld(argBeginDisDate As %String, argEndDisDate As %String, argPatInfoAssistPath As %String, argFPinterfacePath As %String) As %ListOfObjects
{
	q:($d(argBeginDisDate)=0)||(argBeginDisDate="")||($d(argEndDisDate)=0)||(argEndDisDate="") ""
	
	s patType="",patStatus=""
	
	s argBeginDisDate=$zdh(argBeginDisDate,3)
	s argEndDisDate=$zdh(argEndDisDate,3)
	q:(argBeginDisDate>argEndDisDate) ""
	
	s ResultList=##class(%Library.ListOfObjects).%New()
	
	for date=argBeginDisDate:1:argEndDisDate {
		s adm=""
		for {
			s adm=$o(^PAADMi("DischDate",date,adm))
			q:(adm="")
			s aDisPatient=""
			;s aDisPatient=##class(EPRservice.FPInterface.DisPatient).GetDisPatByAdm(adm)
			s aDisPatient=$ZOBJCLASSMETHOD(argFPinterfacePath_".DisPatient","GetDisPatByAdm",adm,argPatInfoAssistPath,argFPinterfacePath)
			if (aDisPatient'="") {d ResultList.Insert(aDisPatient)}
		}
	}
	q ResultList
}

/// d ##class(DHC.EPR.FPInterface.DisPatient).GetDisPatByDate("2008-01-01","2008-01-31","DHC.EPR","DHC.EPR.FPInterface")
/// 根据出院日期(工作量报表)检索出病人明细
ClassMethod GetDisPatByDate(argBeginDisDate As %String, argEndDisDate As %String, argPatInfoAssistPath As %String, argFPinterfacePath As %String) As %ListOfObjects
{
	q:($d(argBeginDisDate)=0)||(argBeginDisDate="")||($d(argEndDisDate)=0)||(argEndDisDate="") ""
	
	s argBeginDisDate=$zdh(argBeginDisDate,3)
	s argEndDisDate=$zdh(argEndDisDate,3)
	q:(argBeginDisDate>argEndDisDate) ""
	s admidStr=""
	s ResultList=##class(%Library.ListOfObjects).%New()
	
	;d $zu(5,"meddata") ;EPR V1.0
	d $zu(5,"DHC-DATA") ;EPR V2.0
	for date=argBeginDisDate:1:argEndDisDate {
		s iprowid=0
		for {
			s iprowid=$o(^MRIPdaily("MRIP_DATE",date,iprowid))
			q:(iprowid="")
			q:$p(^MRIPdaily(iprowid),"^",7)'=""
			s admrowid=0
			for {
				s admrowid=$o(^DHCMRIPDetail(0,"IPDayDr",iprowid,"Type","CYRS","Paadm",admrowid))
				q:(admrowid="")
				if admidStr=""
				{
					s admidStr = admrowid
				}
				else
				{
					s admidStr = admidStr_"^"_admrowid
				}
			}
		}
	}
	;d $zu(5,"EPR") ;EPR V1.0
	d $zu(5,"DHC-APP") ;EPR V2.0
	s i=0
	for i=1:1:$l(admidStr,"^") {
		s adm=$p(admidStr,"^",i)
		s aDisPatient=""
		s aDisPatient=$ZOBJCLASSMETHOD(argFPinterfacePath_".DisPatient","GetDisPatByAdm",adm,argPatInfoAssistPath,argFPinterfacePath)
		if (aDisPatient'="") 
		{
			d ResultList.Insert(aDisPatient)
		}	
	}

	q ResultList
}

/// 根据出院日期(电子病历记录的日期)检索出病人明细
/// d ##class(DHC.EPR.FPInterface.DisPatient).GetDisPatByEPR("2008-01-01","2008-01-31","DHC.EPR","DHC.EPR.FPInterface","#{39||1-G-265-txt301-T}")
ClassMethod GetDisPatByEPR(argBeginDisDate As %String, argEndDisDate As %String, argPatInfoAssistPath As %String, argFPinterfacePath As %String, argDisdateCode As %String) As %ListOfObjects
{
	q:($d(argBeginDisDate)=0)||(argBeginDisDate="")||($d(argEndDisDate)=0)||(argEndDisDate="") ""
	
	s argBeginDisDate=$zdh(argBeginDisDate,3)
	s argEndDisDate=$zdh(argEndDisDate,3)
	q:(argBeginDisDate>argEndDisDate) ""
	
	s argDisdateCode = $e(argDisdateCode,3,$l(argDisdateCode) - 1)
	s catogeryID = $p(argDisdateCode,"-",1)
	s modelID = $p(argDisdateCode,"-",3)
	s cotrolID = $zcvt($p(argDisdateCode,"-",4),"U")
	
	s ResultList=##class(%Library.ListOfObjects).%New()
	
	for date=argBeginDisDate:1:argEndDisDate {
		s zddate=" "_$zd(date,3)
		s PID=""
		for {
			s PID=$o(^DHC.EPR.ScatterItemI("path"," "_catogeryID," "_modelID," "_cotrolID," "," "," "," "," "," "," 2001",zddate,PID))
			q:(PID="")
			s TPID = $E(PID,2,$l(PID))
			s objPatientInof = ##class(DHC.EPR.PatientInfo).%OpenId(TPID)
			q:(objPatientInof="")
			s AdmID=objPatientInof.PInfoAdmID
			q:(AdmID="")
			s aDisPatient=""
			s aDisPatient=$ZOBJCLASSMETHOD(argFPinterfacePath_".DisPatient","GetDisPatByAdm",AdmID,argPatInfoAssistPath,argFPinterfacePath)
			if (aDisPatient'="") 
			{
				d ResultList.Insert(aDisPatient)
			}
		}
	}
	q ResultList
}

/// 根据出院日期(临床工作站医生填的时间)检索出病人明细
/// d ##class(DHC.EPR.FPInterface.DisPatient).GetDisPatByDocWorkStation("2008-02-01","2008-02-29","DHC.EPR","DHC.EPR.FPInterface")
ClassMethod GetDisPatByDocWorkStation(argBeginDisDate As %String, argEndDisDate As %String, argPatInfoAssistPath As %String, argFPinterfacePath As %String) As %ListOfObjects
{
	q:(($d(argBeginDisDate)=0)||(argBeginDisDate="")||($d(argEndDisDate)=0)||(argEndDisDate="")) ""
	s argBeginDisDate=$zdh(argBeginDisDate,3)
	s argEndDisDate=$zdh(argEndDisDate,3)
	q:(argBeginDisDate>argEndDisDate) ""
	s ResultList=##class(%Library.ListOfObjects).%New()
	 
	s adm=0,aPrecdataId=0,ScatteredLog=0,Total=0
	for  s adm=$o(^PAADM(adm)) q:(adm="")  d
	.s DisDate = $p($g(^PAADM(adm)),"^",59)
	.q:(DisDate="")
	.q:((DisDate<argBeginDisDate)||(DisDate>argEndDisDate)) //是否在选定的时间段
	.s aDisPatient=""
	.s aDisPatient=$ZOBJCLASSMETHOD(argFPinterfacePath_".DisPatient","GetDisPatByAdm",adm,argPatInfoAssistPath,argFPinterfacePath)
	.i aDisPatient'=""  d
	..d ResultList.Insert(aDisPatient)
  	q ResultList
  	/*
  	for date=argBeginDisDate:1:argEndDisDate {
	  	s AdmID=""
	  	for {
			s AdmID=$o(^PAADMi("DHCEstDate",date,AdmID))
			w AdmID,!
			q:(AdmID="")
			q:($d(^PAADM(AdmID))=0)
			s aDisPatient=""
			s aDisPatient=$ZOBJCLASSMETHOD(argFPinterfacePath_".DisPatient","GetDisPatByAdm",AdmID,argPatInfoAssistPath,argFPinterfacePath)
			if (aDisPatient'="") 
			{
				d ResultList.Insert(aDisPatient)
			}
		}
  	}
  	*/
}

/// 将出院日期转化为标准的日期格式
/// w ##class(DHC.EPR.FPInterface.DisPatient).ConvertAllDisdate("DHC.EPR")
ClassMethod ConvertAllDisdate(argPatInfoAssistPath As %String, argDisdateCode As %String) As %String
{
	q:(($d(argPatInfoAssistPath)=0)||(argPatInfoAssistPath="")||($d(argDisdateCode)=0)||(argDisdateCode="")) ""
	q:($e(argDisdateCode,1,2)'="#{") ""	
	s argDisdateCode = $e(argDisdateCode,3,$l(argDisdateCode) - 1)
	s catogeryID = $p(argDisdateCode,"-",1)
	s modelID = $p(argDisdateCode,"-",3)
	s cotrolID = $zcvt($p(argDisdateCode,"-",4),"U")
	s resultStr=""

	s RowID=""
	for  s RowID=$o(^DHC.EPR.ScatterItemI("pathbaseitem"," "_catogeryID," "_modelID," "_cotrolID," "," "," 2001",RowID)) q:(RowID="")  d
	.s scatterItem = $g(^DHC.EPR.ScatterItem(RowID))
	.s disDate = $LG(scatterItem,3)
	.q:(disDate="")
	.if ($l(disDate)'=10) d 
	..s disDate=##class(DHC.EPR.FPInterface.DisPatient).Convertadate(disDate)
	..s disDate=$tr(disDate,"/","-")
	..if (disDate?4N1"-"2N1"-"2N)=1 d
	...s objScatterItem = ##class(DHC.EPR.ScatterItem).%OpenId(RowID)
	...q:(objScatterItem="")
	...s objScatterItem.BaseItemValue=disDate
	...d objScatterItem.%Save()
	..e  d
	...s PID = $LG(scatterItem,15)
	...s PatientList = ^DHC.PatientInfoD(PID)
	...s AdmID = $LG(PatientList,11)
	...s papmidr=$ZOBJCLASSMETHOD(argPatInfoAssistPath_".PatientInfoAssist","GetPapmiDR",AdmID)
	...q:(papmidr="")
	...s regno=$ZOBJCLASSMETHOD(argPatInfoAssistPath_".PatientInfoAssist","GetPapmiNo",papmidr)
	...q:(regno="")
	...s resultStr = resultStr_$c(13)_$c(10)_"登记号（"_regno_"）的非法日期为："_disDate
	q resultStr
}

ClassMethod Convertadate(argDate As %String) As %String
{
    q:($d(argDate)=0)||(argDate="") ""
	q:($e(argDate,1,4)="1840") ""
	q:(argDate?4N1"/"2N1"/"2N) argDate
	s argDate=$tr(argDate,",","/")
	s argDate=$tr(argDate,".","/")
	s argDate=$tr(argDate," ","/")
	s argDate=$tr(argDate,"、","/")
	s argDate=$tr(argDate,"年","/")
	s argDate=$tr(argDate,"月","/")
	s argDate=$tr(argDate,"日","")
	s argDate=$tr(argDate,"-","/")
	s argDate=$tr(argDate,"－","/")
	s argDate=$tr(argDate,"－","/")
	s argDate=$tr(argDate,"，","/")
	s argDate=$tr(argDate,"。","/")
	s argDateLen=$l(argDate)
	;if '$isvalidnum($e(argDate,argDateLen,argDateLen)) {
	;	s argDate=$e(argDate,1,argDateLen-1)
	;}
	if $extract(argDate,argDateLen,argDateLen)?1"/" {
		s argDate=$extract(argDate,1,argDateLen-1)
	}
	q:(argDate?4N1"/"2N1"/"2N) argDate

	s convertStr = $p(argDate,"/",1)
	for j=2:1:3
	{
		set tempStr = $p(argDate,"/",j)
		if $l(tempStr)=1
		{
			s tempStr = "0"_tempStr
		}
		s convertStr = convertStr_"/"_tempStr		
	}
	q convertStr
}

/// d ##class(DHC.EPR.FPInterface.DisPatient).GetDisPatByLogDate("2008-01-01","2008-01-31","39","DHC.EPR","DHC.EPR.FPInterface")
/// 根据病案完成日期检索出病人明细
ClassMethod GetDisPatByLogDate(argBeginDisDate As %String, argEndDisDate As %String, argFPCategoryID As %String, argPatInfoAssistPath As %String, argFPinterfacePath As %String) As %ListOfObjects
{
	q:(($d(argBeginDisDate)=0)||(argBeginDisDate="")||($d(argEndDisDate)=0)||(argEndDisDate="")) ""
	s argBeginDisDate=$zdh(argBeginDisDate,3)
	s argEndDisDate=$zdh(argEndDisDate,3)
	q:(argBeginDisDate>argEndDisDate) ""
	k ^DhcEprFPTemp1($j)
	s ResultList=##class(%Library.ListOfObjects).%New()
	 
	s aPatientRecId=0,aPrecdataId=0,ScatteredLog=0,Total=0
	for  s aPatientRecId=$o(^DHC.PatientRecD(aPatientRecId)) q:(aPatientRecId="")  d
	.s aPrecdataId=0
	.for  s aPrecdataId=$o(^DHC.PatientRecD(aPatientRecId,"PRecData",aPrecdataId)) q:(aPrecdataId="")  d
	..s objPRecData= ##Class(DHC.EPR.PRecData).%OpenId(aPatientRecId_"||"_aPrecdataId)
	..q:(objPRecData="")
	..s strSaveDate=""
	..i (objPRecData.PRDataSaveDate?4N1"-"2N1"-"2N)=1 d
	...s strSaveDate=$zdh(objPRecData.PRDataSaveDate,3)
	..e  d
	...s strSaveDate=objPRecData
	..q:((strSaveDate<argBeginDisDate)||(strSaveDate>argEndDisDate)) //是否在选定的时间段
	..q:(objPRecData.PRDataRecID="")
	..q:(objPRecData.PRDataRecID.PRecCateID="")
	..q:(objPRecData.PRDataRecID.PRecCateID.CateMCateID="")
	..set gTemplCategoryID=objPRecData.PRDataRecID.PRecCateID.CateMCateID.%Id()
	..q:(gTemplCategoryID'=argFPCategoryID) //是否为首页模板
	..q:(objPRecData.PRDataRecID.PRecPInfoID="")
  	..set adm=objPRecData.PRDataRecID.PRecPInfoID.PInfoAdmID 
  	..q:(adm="")
  	..q:($d(^DhcEprFPTemp1($j,adm))'=0) //如果本次已检索出该首页,则不需要再次插入导出列表(因为根据首页的其他模板可能已经检索出来)
  	..s ^DhcEprFPTemp1($j,adm)=""
  	..s aDisPatient=$ZOBJCLASSMETHOD(argFPinterfacePath_".DisPatient","GetDisPatByAdm",adm,argPatInfoAssistPath,argFPinterfacePath)
	..if (aDisPatient'="") {d ResultList.Insert(aDisPatient)}

 	k ^DhcEprFPTemp1($j)
  	q ResultList
}

/// 根据就诊号检索出病人明细
ClassMethod GetDisPatByAdm(argAdmId As %String, argPatInfoAssistPath As %String, argFPinterfacePath As %String) As DisPatient
{
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//检查是否是新生儿,如果是新生儿
	s matherAdmId=$p($g(^PAADM(argAdmId)),"^",75)
	q:(matherAdmId'="") ""
	//
	s patType="",patStatus="",aDisPatient=""
	s patType=$p($g(^PAADM(argAdmId)),"^",2)
	s patStatus=$p($g(^PAADM(argAdmId)),"^",20)
	if (patType="I")&&(patStatus="D") {
		s papmidr="",aDisPatient=""
		;s papmidr=##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argAdmId)
		s papmidr=$ZOBJCLASSMETHOD(argPatInfoAssistPath_".PatientInfoAssist","GetPapmiDR",argAdmId)  ;EPR V1.0
		;s papmidr=$ZOBJCLASSMETHOD(argPatInfoAssistPath_".FPInterface.DisPatient","GetPapmiDR",argAdmId)
		q:(papmidr="") ""
		;s aDisPatient=##class(EPRservice.FPInterface.DisPatient).%New()
		s aDisPatient=$ZOBJCLASSMETHOD(argFPinterfacePath_".DisPatient","%New")
		q:(aDisPatient="") ""
		s aDisPatient.AdmId=argAdmId
		s aDisPatient.PatInfoAssistPath=argPatInfoAssistPath
	    s aDisPatient.FPInterfacePath=argFPinterfacePath
	}
	q aDisPatient
}

ClassMethod GetPapmiDR(argAdmId As %String)
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	q $P($g(^PAADM(argAdmId)),"^",1)
}

/// 根据登记号检索出病人明细
/// w ##class(DHC.EPR.FPInterface.DisPatient).GetAdmIdByRegNo("14698","8")
ClassMethod GetAdmIdByRegNo(argPapmiNo As %String, argPapmiNoLength As %Integer) As %String
{
	q:($d(argPapmiNo)=0)||(argPapmiNo="")||($d(argPapmiNoLength)=0)||(argPapmiNoLength="") ""
	s papminoLength=$l(argPapmiNo)
	q:(papminoLength>argPapmiNoLength) ""
	s zero = ""
	if papminoLength<argPapmiNoLength {
		s zeroNum=argPapmiNoLength-papminoLength
		s zero=""
		for i=1:1:zeroNum {
			s zero=zero_"0"
		}
	}
	s argPapmiNo=zero_argPapmiNo
	s result=""
	
	s papmiRowid=""
	for {
		b "s"
		s papmiRowid=$o(^PAPERi("PAPMI_PatNo",argPapmiNo,papmiRowid))
		q:(papmiRowid="")
		s paadm=""
		for {
			b "s"
			s paadm=$o(^PAPERdr(papmiRowid,"ADM","I",paadm))
			q:(paadm="")
			s patStatus=$p(^PAADM(paadm),"^",20)
			//q:(patStatus'="D")
			s disdate=$p(^PAADM(paadm),"^",17)
			s disdate=$zd(disdate,3)
			if (result="") {s result=paadm_"^"_disdate}
			else {s result=result_"!"_paadm_"^"_disdate}
		}
	}
	q result
}

/// 根据病案号检索出病人明细
/// w ##class(DHC.EPR.FPInterface.DisPatient).GetAdmIdByBaId("199404","8")
ClassMethod GetAdmIdByBaId(argBaId As %String, argPapmiNoLength As %Integer) As %String
{
	q:($d(argBaId)=0)||(argBaId="")||($d(argPapmiNoLength)=0)||(argPapmiNoLength="") ""
	s papminoLength=$l(argBaId)
	q:(papminoLength>argPapmiNoLength) ""
	if papminoLength<argPapmiNoLength {
		s zeroNum=argPapmiNoLength-papminoLength
		s zero=""
		for i=1:1:zeroNum {
			s zero=zero_"0"
		}
	}
	s argBaId=zero_argBaId
	s result=""
	
	s papmiRowid=""
	for {
		s papmiRowid=$o(^PAPERi("Govern",argBaId_"Z",papmiRowid))
		q:(papmiRowid="")
		s paadm=""
		for {
			s paadm=$o(^PAPERdr(papmiRowid,"ADM","I",paadm))
			q:(paadm="")
			s patStatus=$p($g(^PAADM(paadm)),"^",20)
			q:(patStatus'="D")
			s disdate=$p($g(^PAADM(paadm)),"^",17)
			s disdate=$zd(disdate,3)
			if (result="") {s result=paadm_"^"_disdate}
			else {s result=result_"!"_paadm_"^"_disdate}
		}
	}
	q result
}

ClassMethod GetHospitalName(argFPinterfacePath As %String, argEPRVersion As %String) As %String
{
	s hospital=""
	s hospital=$ZOBJCLASSMETHOD(argFPinterfacePath_".DisPatient","GetHospitalNameV"_argEPRVersion)
	q hospital
}

ClassMethod GetHospitalNameV1() As %String
{
	s hospital=""
	s hospital=##class(DHC.EPR.Parameter).selectByName("Hospital")
	s hospital=$ZOBJCLASSMETHOD("DHC.EPR.Parameter","selectByName","Hospital")
	q hospital
}

ClassMethod GetHospitalNameV2() As %String
{
	s hospital=""
	q hospital
}

Method GetIsFPFinished(argFPInterfacePath As %String) As %String
{
	q:($d(argFPInterfacePath)=0)||(argFPInterfacePath="") "-1"
	s version=$ZOBJCLASSMETHOD(argFPInterfacePath_".DisPatient","GetEPRVersion")
	s result=""
	s result=$ZOBJMETHOD(##this,"IsFPFinishedV"_version)
	q result
}

Method IsFPFinishedV2() As %String
{
	s ECRecordId="",aECRecord=""
	s ECRecordId=##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(..AdmId,..FPMainCategoryId)
	q:(ECRecordId="") "0"
	
	s aECRecord=##class(EPRinstance.ECRecord).%OpenId(ECRecordId)
	//if there is no ECRecordId, the patient's EPR is unfinished
	q:(aECRecord="") "0"
	
	s finished="1" ;initialize this variable to "finished" status
	s key=0
	
	While (key '= "") {
		q:(finished="0") ;if finished has been 0, do not loop
		s InstanceData=aECRecord.Instances.GetNext(.key)
		q:(InstanceData="")
		s newFPSubCategoryId="^"_..FPSubCategoryId_"^"
		s newInstanceDataId="^"_InstanceData.GroupItemID_"^"
		if ($f(newFPSubCategoryId,newInstanceDataId)'=0)&&(InstanceData.Status="UnSave") {s finished="0"}
	} 
	
	q finished
}

Method IsFPFinishedV1() As %String
{
	//get all patientinfo ids of ..AdmId; check all their PatientRec from above categories 
	//to determine if every category assigned in ..FPSubCategoryId has been saved
	s finished="1",patinfoid=""

	//get PatientIds from AdmId
	s rset=""
	Set rset = ##class(%ResultSet).%New("DHC.EPR.PatientInfo:selectByPatientID")
	q:('rset.QueryIsValid()) "0"
	Set sc = rset.Execute(..AdmId)
	
	//loop all PatientIds of the AdmId
	While (rset.Next()) {
		q:(finished="0")
    s patinfoid=rset.Get("ID")
    //check every category id in ..FPSubCategoryId to check if it has been saved in PatientRec
    for i=1:1:$l(..FPSubCategoryId,"^") {
	    ;b "s"
	    q:(finished="0")
	    s aPatientRec=""
	    
	    //get PatientRecs of the PatientInfo and Categroy
	    s rset1=##class(%ResultSet).%New("DHC.EPR.PatientRec:selectPatientRec")
	    if ('rset1.QueryIsValid()) {s finished="0"}
	    s sc1=rset1.Execute(patinfoid,..FPMainCategoryId_"||"_$p(..FPSubCategoryId,"^",i))
	    
	    //if the resultset is empty, this flag will still be 0
	    s hasDataFlag=0
	    
	    while (rset1.Next()) {
		    ;b "s"
		    q:(finished="0")
		    s hasDataFlag=1
		    s aPatientRec=""
		    s aPatientRec=##class(DHC.EPR.PatientRec).%OpenId(rset1.Get("ID"))
		    if (aPatientRec="") {s finished="0"}
		    elseif (aPatientRec.PRecFirstSaveDate="") {s finished="0"}
	    }
	    
	    d rset1.Close()
	    if (hasDataFlag=0) {s finished="0"}
    }
  }
	
	Do rset.Close()
	q:(patinfoid="") "0"
	q finished
}

Method NameGet() As %String
{
	s papmidr=..PapmiDR
	q:(papmidr="") ""
	s name=""
	;s name=##class(EPRservice.HISInterface.PatientInfoAssist).Name(papmidr)
	s tmppath=..PatInfoAssistPath
	s name=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","Name",papmidr)
	q name
}

Method PapmiDRGet() As %String
{
	q:(..AdmId="") ""
	s papmidr=""
	;s papmidr=##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(..AdmId)
	s tmppath=..PatInfoAssistPath
	s papmidr=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","GetPapmiDR",..AdmId)
	q papmidr
}

Method RegNoGet() As %String
{
	s papmidr=..PapmiDR
	q:(papmidr="") ""
	s regno=""
	;s regno=##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmidr)
	s tmppath=..PatInfoAssistPath
	s regno=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","GetPapmiNo",papmidr)
	q regno
}

/// modified on 2007-12-10
Method PRecNoGet() As %String
{
	s papmidr=..PapmiDR
	q:(papmidr="") ""
	
	s version = ..GetEPRVersion()
	s hospital = ..GetHospitalName(..FPInterfacePath, version)
	
	s precno=""
	;s precno=##class(EPRservice.HISInterface.PatientInfoAssist).IMedicare(papmidr,"DiTan")
	;s precno=##class(EPRservice.HISInterface.PatientInfoAssist).PatientRecordID(papmidr)
	s tmppath=..PatInfoAssistPath
	s precno=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","IMedicare",papmidr,"DiTan")
	q precno
}

Method DisDateGet() As %String
{
	s adm=..AdmId
	q:(adm="") ""
	s disdate=""
	s tmppath=..PatInfoAssistPath
	
	//出院日期存在以下几种取法
	//根据参数设置来取出院日期
	s DisDateType = $G(^EPRDisDateType(0))
	if DisDateType = "gzlrq"{
		s disdate=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","DisDateTimeMR",adm,"DHC-DATA","DiTan")  //(出院日期)工作量表中的出院日期
		i disdate'="" { s disdate=$zd($p($g(disdate)," ",1),3)}
	}
	elseif DisDateType = "ycyrq"{
		s disdate=$p($g(^PAADM(adm)),"^",59)
		if disdate'="" {s disdate=$zd(disdate,3)}  //(出院日期)预出院日期
	}
	else
	{
		s disdate=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","DisDateTime",adm)
	    if disdate'="" {s disdate=$zd(disdate,3)}  //(出院日期)最终结算日期
	}
	//end--出院日期
	
	q disdate
	
	;s disdate=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","DisDateTime",adm)
	;if disdate'="" {s disdate=$zd(disdate,3)}
	;
	;080220暂时注掉,等袁旭改完后再恢复回用这种方式
	;先从工作量报表取，如果没有则取就诊表的最终结算日期
	;s disdate=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","DisDateNew",adm,"Meddata","EPR")
	;if disdate=""
	;{
	;	s disdate=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","DisDateTime",adm)
	;	if disdate'="" {s disdate=$zd(disdate,3)}
	;}	
    ;
    ;从电子病历出的日期
    ;s disdate=##class(DHC.EPR.FPInterface.ExportTable).GetItemDataValueV1Another(adm,"#{39||1-G-265-txt301-T}","0")
	;
	;从临床工作站取日期
	;s disdate=$p($g(^PAADM(adm)),"^",59)
	;s disdate=$zd(disdate,3)
	;q disdate
}

Method DisDeptGet() As %String
{
	s argAdmId=..AdmId
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s WardDesc="",WardCode=""
	s WardDesc=##Class(EPRservice.HISInterface.PatientInfoAssist).DisDept(argAdmId,"DiTan")
	//s dischgWard=$P($g(^PAADM(argAdmId)),"^",70)
	//if dischgWard'="" 
	//{
	//	s WardCode=$p(^PAWARD(dischgWard),"^",1)
	//	s WardDesc=$p(^PAWARD(dischgWard),"^",2)
	//	if $l(WardDesc,"-")>1 {s WardDesc=$p(WardDesc,"-",2)}
	//}
	q WardDesc
	
	/*
	s adm=..AdmId
	q:(adm="") ""
	s disdept=""
	;s disdept=##class(EPRservice.HISInterface.PatientInfoAssist).DisDept(adm)
	s tmppath=..PatInfoAssistPath
	s disdept=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","DisDept",adm)
	q:disdept="" ""
	
	s RowId = ""
	s RowId=$o(^CTLOC(0,"Code",disdept,RowId))
	q:RowId="" disdept
	q:'$d(^CTLOC(RowId)) disdept
	s disdeptname = ^CTLOC(RowId)
	s disdeptname = $p(disdeptname,"^",2)
	q $p(disdeptname,"-",2)
	*/
}

Method DocInChargeGet() As %String
{
	
	s adm=..AdmId
	q:(adm="") ""
	s mainDoc=""
	;s disdept=##class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(adm)
	;##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDoctor(adm,"DiTan")
	s tmppath=..PatInfoAssistPath
	s mainDoc=$ZOBJCLASSMETHOD(tmppath_".PatientInfoAssist","AdmDoctor",adm,"DiTan")
	q mainDoc
}

/// check if the class "EPRinstance.InstanceData" exists in current namespace
/// if it exists, the EPRVersion should be 2, the B/S version
/// despite of the possible existence of classes of the C/S version
ClassMethod GetEPRVersion() As %String
{
	s eprversion=""
	q:(##class(%Dictionary.ClassDefinition).%OpenId("EPRinstance.InstanceData")'="") 2
	q 1
}

/// **************************以下为测试代码************************
/// w ##class(DHC.EPR.FPInterface.DisPatient).test()
ClassMethod test()
{
	;s a=##class(EPRservice.FPInterface.DisPatient).GetDisPatByAdm(388568,"EPRservice.HISInterface","EPRservice.FPInterface")
	;s a.FPMainCategoryId=5
	;s a.FPSubCategoryId="6^9"
	;s version=##class(EPRservice.FPInterface.DisPatient).GetEPRVersion()
	s a=##class(DHC.EPR.FPInterface.DisPatient).GetDisPatByAdm(364615,"DHC.EPR","DHC.EPR.FPInterface")
	;s a.FPMainCategoryId=23
	;s a.FPSubCategoryId="1^2^3^4"
	
	w "AdmId: "_a.AdmId,!
	w "PapmiDR: "_a.PapmiDR,!
	w "Name: "_a.Name,!
	w "RegNo: "_a.RegNo,!
	w "PRecNo: "_a.PRecNo,!
	w "DisDate: "_a.DisDate,!
	w "DisDept: "_a.DisDept,!
	w "DocInCharge: "_a.DocInCharge,!
	;w "IsFPFinished: "_a.IsFPFinished,!
	;w "EPRVersion: "_a.EPRVersion
	
	q
}

ClassMethod testFinish()
{
	s a=##class(DHC.EPR.FPInterface.DisPatient).GetDisPatByAdm(66,"DHC.EPR","DHC.EPR.FPInterface")
	s a.FPMainCategoryId="23"
	s a.FPSubCategoryId="1^3"
	w a.GetIsFPFinished("DHC.EPR.FPInterface")
	q
}

Storage Default
{
<Data name="DisPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdmId</Value>
</Value>
<Value name="3">
<Value>DisDate</Value>
</Value>
<Value name="4">
<Value>DisDept</Value>
</Value>
<Value name="5">
<Value>DocInCharge</Value>
</Value>
<Value name="6">
<Value>FPInterfacePath</Value>
</Value>
<Value name="7">
<Value>FPMainCategoryId</Value>
</Value>
<Value name="8">
<Value>FPSubCategoryId</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
<Value name="10">
<Value>PRecNo</Value>
</Value>
<Value name="11">
<Value>PapmiDR</Value>
</Value>
<Value name="12">
<Value>PatInfoAssistPath</Value>
</Value>
<Value name="13">
<Value>RegNo</Value>
</Value>
</Data>
<DataLocation>^EPRmeta.FPInterf6E3.DisPatientD</DataLocation>
<DefaultData>DisPatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.FPInterf6E3.DisPatientD</IdLocation>
<IndexLocation>^EPRmeta.FPInterf6E3.DisPatientI</IndexLocation>
<StreamLocation>^EPRmeta.FPInterf6E3.DisPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
