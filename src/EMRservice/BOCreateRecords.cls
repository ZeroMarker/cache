Class EMRservice.BOCreateRecords Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CreateRecordsInfo";

/// 获取该模板下用户模板
/// Debug: ##class(EMRservice.BOCreateRecords).GetAllLoc()
ClassMethod GetAllLoc() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EMRservice.BOCreateRecords:GetLocByType")

	d result.SetArgs("","")
	Quit result
}

// d ##Class(%ResultSet).RunQuery("EMRservice.BOCreateRecords","GetLocByType","","")

Query GetLocByType(pType As %String, pText As %String) As %Query(ROWSPEC = "rowID:%String,Code:%String,Desc:%String,Type:%String")
{
}

ClassMethod GetLocByTypeExecute(ByRef qHandle As %Binary, pType As %String, pText As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	
 	if (pType = "")
 	{
	 	s tmpType = ""
	 	for
	 	{
		 	s tmpType = $o(^CTLOC(0,"LocType",tmpType))
		 	q:(tmpType = "")
		 	d getData
		}
	}
	else
	{
	 	for i=1:1:$l(pType,",")
	 	{
		 	s tmpType = $p(pType,",",i)
		 	d getData
	 	}
	}
	Quit $$$OK
getData
 	s rowId = ""
	for
	{
		s rowId = $o(^CTLOC(0,"LocType",$zcvt(tmpType,"U"),rowId))
		q:(rowId = "")
		continue:($d(^CTLOC(rowId))=0)
		s code = $p(^CTLOC(rowId),"^",1)
		s desc = $p(^CTLOC(rowId),"^",2)
		continue:((pText '= "")&&($zcvt(desc,"U")'[ $zcvt(pText,"U")))
		s ^CacheTemp(repid,ind) = $lb(rowId,code,desc,tmpType)
		s ind=ind+1
	}
}

ClassMethod GetLocByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据科室ID和就诊日期获取患者信息
/// Input:	ALocID为登录科室RowID;
/// 		AUserID为登录用户RowID;
/// 		APatientNo为患者登记号;
/// 		APatientName为患者姓名;
/// 		AdmType为患者就诊类型;
/// 		AStartDate为就诊开始日期;
/// 		AEndDate为就诊截止日期;
/// 		AIsArrivedQue为是否本科患者;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// debug: d ##Class(EMRservice.BOCreateRecords).GetPaAdmList("7","2018-03-01","2018-04-01")
ClassMethod GetPaAdmList(ALocID As %String, AStartDate As %String, AEndDate As %String) As %XML.DataSet [ WebMethod ]
{
	//s param = ALocID_","_AIsArrivedQue_","_APatientNo_","_AMedicareNo_","_AStartDate_","_AEndDate_","_APatientName_","_ACFCardNo_","_AdmType_","_AIDCardNo_","_AexpectedLocID_","_AdmStatus_","_AMedicalInsuranceNo_","_AOutStartDate_","_AOutEndDate_","_","_AexpectedUserCode_","_AMRN 
	//s param = "7,off,,,2018-03-01,2018-04-01,,,,,7,I,,,,,,"
	s param = ALocID_",off,,,"_AStartDate_","_AEndDate_",,,,,"_ALocID_",all,,,,,,"
	s result=##Class(%XML.DataSet).%New("EMRservice.BOCreateRecords:GetPaAdmList")
	d result.SetArgs(param)
	q result
}

/// Desc:     取患者列表
/// creator:  YEJIAN
/// Input: 
///           ALocID 科室
///           AIsArrivedQue 是否到达
/// Debug:    d ##class(%ResultSet).RunQuery("EMRservice.BOCreateRecords","GetPaAdmList","19,off,,,2018-03-27,2018-03-27,,,,,19,all,,,,,,")
Query GetPaAdmList(Aparam As %String) As %Query(ROWSPEC = "ind%String,mradm:%String,PAPMIDR:%String,PAPMINO:%String,MedicareNo:%String,PAADMRowID:%String,PAPMIName:%String,IDCard:%String,CFCardNo:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,DocId:%String,UserCode:%String,ALocCode:%String,ALocID:%String,PADischgeDate:%String,PADischgeTime:%String,SSgroupID:%String,MRCIDDesc:%String,ARCIMDescs:%String,strPacDesc:%String")
{
}

ClassMethod GetPaAdmListExecute(ByRef qHandle As %Binary, Aparam As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	s ALocID = $p(Aparam,",",1),AIsArrivedQue = $p(Aparam,",",2), APAPMINo = $p(Aparam,",",3),AMedicareNo=$p(Aparam,",",4)
	s Stdate = $p(Aparam,",",5),Enddate = $p(Aparam,",",6),APAPMIName = $p(Aparam,",",7),ACFCardNo = $p(Aparam,",",8)
	s APAAdmType = $p(Aparam,",",9),AIDCard = $p(Aparam,",",10),AexpectedLocID = $p(Aparam,",",11)
	s APAAdmStatus = $p(Aparam,",",12),AMedicalInsuranceNo = $p(Aparam,",",13),OutStdate = $p(Aparam,",",14)
	s OutEnddate = $p(Aparam,",",15),WardId = $p(Aparam,",",16),UserId = $p(Aparam,",",17),AMRN = $p(Aparam,",",18)
	s HospitalName = ##Class(EMRservice.BOSysOption).GetValueByName("HospitalName")
	
	s sysStdate=##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",Stdate)
	s sysEnddate=##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",Enddate)
	s sysOutStdate=##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",OutStdate)
	s sysOutEnddate=##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",OutEnddate)
	
	
	if (APAPMINo '= "")
	{
		s PAPMIDR = ""
		for
		{
			s PAPMIDR = $o(^PAPERi("PAPMI_PatNo",APAPMINo,PAPMIDR))
			q:(PAPMIDR = "")
			d GetPAADMRowID
			
		}
	}
	elseif (AMedicareNo '= "")
	{
	    s PAPMIDR = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPatientIDByMRNo(AMedicareNo)
	    d GetPAADMRowID
	}
	elseif (sysStdate '= "")&(sysEnddate '= "")
	{
		for AdmDate = sysStdate:1:sysEnddate 
		{
			s PAADMRowID = ""
			if (APAAdmType '=  "") 
			{
				//w "按时间段和就诊类型查询",!
				for {
					s PAADMRowID = $o(^PAADMi("NNType",APAAdmType,AdmDate,PAADMRowID))
					q:(PAADMRowID = "")
					d outputrow
				}
			}
			else
			{
				//w "按时间段查询",!
				for {	
					s PAADMRowID = $o(^PAADMi("PAADM_AdmDate",AdmDate,PAADMRowID))
					q:(PAADMRowID = "")
					d outputrow
				}
			}
		}	
	}
	elseif (sysOutStdate '= "")&&(sysOutEnddate '= "")
	{
		for DischgDate = sysOutStdate:1:sysOutEnddate 
		{
			s PAADMRowID = ""
			if (APAAdmType '=  "") 
			{
				//w "按时间段和就诊类型查询",!
				for {
					s PAADMRowID = $o(^PAADMi("DisDateT",APAAdmType,DischgDate,PAADMRowID))
					q:(PAADMRowID = "")
					d outputrow
				}
			}
			else
			{
				//w "按时间段查询",!
				for {	
					s PAADMRowID = $o(^PAADMi("DischDate",DischgDate,PAADMRowID))
					q:(PAADMRowID = "")
					d outputrow
				}
			}
		}			
	}
	elseif (AexpectedLocID '= "")||(AIsArrivedQue = "on")
	{
		s locID = $case(AIsArrivedQue,"on":ALocID,:AexpectedLocID)		
		s AdmDate = ""
		for
		{
			s AdmDate = $o(^PAADMi("CurrLoc",locID,AdmDate))
			q:(AdmDate = "")
			s AdmTime = ""
			for
			{
				s AdmTime = $o(^PAADMi("CurrLoc",locID,AdmDate,AdmTime))
				q:(AdmTime = "")
				s PAADMRowID = ""
				for
				{
					s PAADMRowID = $o(^PAADMi("CurrLoc",locID,AdmDate,AdmTime,PAADMRowID))
					q:(PAADMRowID = "")
					b:(PAADMRowID = 68569)
					d outputrow
				}
			}
		}
	}
	Quit $$$OK
GetPAADMRowID
	s PAADMRowID = ""
	if (APAAdmType'="")
	{
    	for {
		s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM",APAAdmType,PAADMRowID))
		q:(PAADMRowID = "")
		d outputrow
		}
	}
	else
	{
		s APAAdmType = ""
		for {
		s APAAdmType = $o(^PAPERdr(PAPMIDR,"ADM",APAAdmType))
		q:(APAAdmType ="")
		continue:((APAAdmType '="O")&&(APAAdmType '="E")&&(APAAdmType '="I"))
		s PAADMRowID=""
		for {
				s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM",APAAdmType,PAADMRowID))
				q:(PAADMRowID = "")
				d outputrow
			}
		}
	}
	Quit
outputrow
	s mCurrRow = $g(^PAADM(PAADMRowID))
	//排除有记录数据
	s Ecrowid = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",PAADMRowID, ""))
	q:(Ecrowid '= "")
	s mradm = $p(^PAADM(PAADMRowID),"^",61)
	s PAPMIDR = $p($g(mCurrRow),"^",1)
	//健康卡号
	s CFCardNo = ""   
	s CFRowId = $o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDR,""))
	s:(CFRowId '= "") CFCardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
    q:((ACFCardNo '= "")&&(CFCardNo '= ACFCardNo))
	s IDCard = $p($g(^PAPER(PAPMIDR,"PAT",3)),"^",6)
	q:((AIDCard '= "")&&(IDCard '= AIDCard))
	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	//q:((APAPMIName '= "")&&(PAPMIName '= APAPMIName))
	s PAPMINO = $p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
	q:((APAPMINo '= "")&&(PAPMINO '= APAPMINo))
	s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(PAADMRowID)
	q:((AMedicareNo '= "")&&(MedicareNo '= AMedicareNo))
	s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
	s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
	s TmpPAAdmTypeDR = $p($g(mCurrRow),"^",2)
	//只查询门诊，急诊和住院
	q:((TmpPAAdmTypeDR'="O"))
	s TmpPAAdmType = $case(TmpPAAdmTypeDR,"O":"门诊","E":"急诊","I":"住院")
	q:((APAAdmType '= "")&&(APAAdmType '= "all")&&(TmpPAAdmTypeDR '= APAAdmType))
	//日期时间处理
	s PAPMIDOB = $p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
	s:(PAPMIDOB '= "") PAPMIDOB = $zd(PAPMIDOB,3)
	
	s PAAdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(PAADMRowID)
	s PAAdmDate = $p(PAAdmDateTime,",",1) 
	q:((sysStdate '= "")&&(sysEnddate '="")&&((PAAdmDate>sysEnddate)||(PAAdmDate<sysStdate)))	
	if (PAAdmDate '= "")
	{
		s PAAdmDate = $zd(PAAdmDate,3)
		s PAAdmDate = ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmDate)
	}
	s PAAdmTime = $p(PAAdmDateTime,",",2)  //$p($g(mCurrRow),"^",7)
	if (PAAdmTime '= "")
	{
		s PAAdmTime = $zt(PAAdmTime,3)
		s PAAdmTime=##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PAAdmTime)
	}
	s DischgDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(PAADMRowID,HospitalName)
	s PADischgeDate =  $p(DischgDateTime,",",1)  //$P($g(^PAADM(PAADMRowID)),"^",17)
	q:((APAAdmStatus = "A")&&(PADischgeDate '= ""))
	q:((APAAdmStatus = "D")&&(PADischgeDate = ""))
	q:((sysOutStdate '= "")&&(sysOutEnddate '="")&&((PADischgeDate>sysOutEnddate)||(PADischgeDate<sysOutStdate)))	
	if (PADischgeDate '= "")
	{
		s PADischgeDate = $zd(PADischgeDate,3)
		s PADischgeDate = ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PADischgeDate)
	}
	s PADischgeTime = $p(DischgDateTime,",",2) //$P($g(^PAADM(PAADMRowID)),"^",18)
	if (PADischgeTime '= "")
	{
		s PADischgeTime = $zt(PADischgeTime,3)
		s PADischgeTime= ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PADischgeTime)
	}
	s ALocCodeDR = $p($g(^PAADM(PAADMRowID,1)),"^",7)
	//s:(PAADMReasonDR '= "") PAADMReason = $p($g(^PAC("ADMREA",PAADMReasonDR)),"^",2)
	s PAADMDepCode = $p($g(mCurrRow),"^",4)
	s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
	s ALocCode = $p($g(^CTLOC(PAADMDepCode)),"^",1)
	q:((AIsArrivedQue = "on")&&(PAADMDepCode '= ALocID))	
	q:(((AIsArrivedQue = "off") && (AexpectedLocID '= ""))&&(PAADMDepCode '= AexpectedLocID))
	s PAADMDocCode = $p($g(mCurrRow),"^",9)
	
	s:(UserId'="") DocId = $p($g(^SSU("SSUSR",UserId)),"^",14)
	s PAAdmDocCodeDR = "无"
	s:(PAADMDocCode '= "") UserCode = $p($g(^CTPCP(PAADMDocCode,1)),"^",1)
	s:(PAADMDocCode '= "") PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
	s:(UserCode '= "") DocId = $o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(UserCode,"U"),""))

	s SSgroupID =""
    if ((ALocID'="")&&(DocId'=""))
    {
	    s SSgroupID = ..GetOthSSgroupID(DocId,ALocID)
    }
	//以下是获取患者当前病区
	s disWardDR = $P($g(^PAADM(PAADMRowID)),"^",70)
	if (WardId '= "")
	{
		s tmpwarddr = $o(^PAWARD(0,"WARD_LocationDR",WardId,""))
	    q:(disWardDR '= tmpwarddr)
	}
	//取诊断
	s MRCIDDesc =""
	s PAADMMainMRADMDR=$p($g(^PAADM(PAADMRowID)),"^",61)     
	q:PAADMMainMRADMDR=""
	s MrCid="" f  s MrCid=$O(^MR(PAADMMainMRADMDR,"DIA",MrCid)) Quit:MrCid=""  d
	.s MRDIADiagStatDR=$p(^MR(PAADMMainMRADMDR,"DIA",MrCid),"^",1)     
	.q:MRDIADiagStatDR=""
	.s MRCIDDescs=$p($g(^MRC("ID",MRDIADiagStatDR)),"^",2)     //本次诊断信息
	.s MRCIDDesc=MRCIDDescs_","_MRCIDDesc
	
	//取医嘱
	s ARCIMDescs = ""
	s OePid=""
	s OePid=$o(^OEORD(0,"Adm",PAADMRowID,OePid))
	s OeCid="0"
	f  s OeCid=$O(^OEORD(OePid,"I",OeCid)) Quit:OeCid=""  d
	.s OEORIDoseQty=$p($g(^OEORD(OePid,"I",OeCid,2)),"^",1)    //本次医嘱剂量
	.s OEORIItmMastDR=$p(^OEORD(OePid,"I",OeCid,1),"^",2)
	.q:OEORIItmMastDR=""
	.s ARCIMDesc=$p($g(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1)),"^",2)   //本次医嘱项
	.s ARCIMDescs =ARCIMDesc_","_ARCIMDescs
	
	//取检查
	s strPacDesc = ##class(web.DHCRisApplicationBill).GetCurrentStatus(PAADMRowID)
	
	set ^CacheTemp(repid,ind) = $LB(ind,mradm,PAPMIDR,PAPMINO,MedicareNo,PAADMRowID,PAPMIName,IDCard,CFCardNo,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmDepCodeDR,PAAdmDocCodeDR,TmpPAAdmType,DocId,UserCode,ALocCode,ALocID,PADischgeDate,PADischgeTime,SSgroupID,MRCIDDesc,ARCIMDescs,strPacDesc)
	set ind = ind + 1
	Quit
}

ClassMethod GetPaAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(EMRservice.BOCreateRecords).GetHISStandardDataTimeFormat()
/// w ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("GetFormatExt","Date")
/// w ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("GetFormatExt","Time")
/// w ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("GetFormat","Date")
/// w ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("GetFormat","Time")
/// w ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToFormat","Date","2012-01-11")
/// w ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToFormat","Time","11:00")
/// w ##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime","2012-01-11 11:00")
ClassMethod GetHISStandardDateTimeFormat(IsFormat As %String, IsDataOrTime As %String, ArgDateTimeValue As %String = "") As %String
{
	s retvalue=""
	
	//取完整格式
	if (IsFormat="ChangeToSysFormat")
	{
		if IsDataOrTime="Date" 
		{
				//---日期转换
				
				/*normal to sys
				入参	日期		2017-2-24	24/2/2017	64338	2017-23-1	
				返回	M中日期数字	64338		64338		64338	ERROR
				*/
				s retvalue=##class(EMRservice.BOCreateRecords).DateHtmlToLogical(ArgDateTimeValue)
				
		}
		elseif IsDataOrTime="Time" {
				//---时间转换
				
				/* normal to sys 
				入参	配置的时间格式	23:09	83340	25:67
				返回	M中时间数字		83340	83340	ERROR
				*/
				s retvalue=##class(websys.Conversions).TimeHtmlToLogical(ArgDateTimeValue)
				
		}
		elseif IsDataOrTime="DateTime"
		{
			s beChangedDateValue=$p(ArgDateTimeValue," ",1)
			
			s beChangedTimeValue=$p(ArgDateTimeValue," ",2)
			
			s dateValue=##class(websys.Conversions).DateHtmlToLogical(beChangedDateValue)	
			
			s timeValue=##class(websys.Conversions).TimeHtmlToLogical(beChangedTimeValue)
			
			
			
			s retvalue=dateValue_" "_timeValue
		}
	}
	elseif (IsFormat="ChangeToFormat")
	{
		if IsDataOrTime="Date" 
		{
				//---日期转换
				
				/*normal to sys
				入参	日期		2017-2-24	24/2/2017	64338	2017-23-1	
				返回	M中日期数字	64338		64338		64338	ERROR
				*/
				s dateHtmlToLogical=##class(EMRservice.BOCreateRecords).DateHtmlToLogical(ArgDateTimeValue)
				
				/*
				入参	M中日期数字	64338		2017-2-24	9999999	
				返回	日期		2017-2-24	2017-2-24	ERROR
				*/
				
			s retvalue=..DateLogicalToHtml(dateHtmlToLogical)
		}
		elseif IsDataOrTime="Time" {
				//---时间转换
				
				/* normal to sys 
				入参	配置的时间格式	23:09	83340	25:67
				返回	M中时间数字		83340	83340	ERROR
				*/
				s timeHtmlToLogical=##class(websys.Conversions).TimeHtmlToLogical(ArgDateTimeValue)
				
				
				
				/*
				入参	M中时间数字		83340	23:09	999999	
				返回	配置的时间格式	23:09	23:09	ERROR
				*/
				s retvalue=##class(websys.Conversions).TimeLogicalToHtml(timeHtmlToLogical)
		}
		elseif IsDataOrTime="DateTime"
		{
			s beChangedDateValue=$p(ArgDateTimeValue," ",1)
			
			s beChangedTimeValue=$p(ArgDateTimeValue," ",2)
			
			s dateHtmlToLogical=##class(websys.Conversions).DateHtmlToLogical(beChangedDateValue)
			
			s dateValue=##class(websys.Conversions).DateLogicalToHtml(dateHtmlToLogical)
			
			s timeHtmlToLogical=##class(websys.Conversions).TimeHtmlToLogical(beChangedTimeValue)
			
			s timeValue=##class(websys.Conversions).TimeLogicalToHtml(timeHtmlToLogical)
			
			s retvalue=dateValue_" "_timeValue
		}
	}
	q retvalue
}

/// modify by wuqk 2011-06-22 根据config修改输出格式
/// w ##class(websys.Conversions).DateHtmlToLogical("-12-1")
ClassMethod DateHtmlToLogical(d As %String) As %String
{
	;Q $$intdate^SSUTIL4(d)
	Q:d="" ""	;ARCOrdSets.Edit->ARCOSEffDateTo
	Q:d?1n.n d
	S format = ..DateFormat()
	if d["-" Set format = 3
	if d["/" {
		if $p(d,"/")>1840{ //这种格式是win7和win10默认的日期格式  2017/9/27
			Set d = $p(d,"/",3)_"/"_$p(d,"/",2)_"/"_$p(d,"/",1)
		}
		Set format = 4
	}
	Q $zdh(d,format)
}

/// 获取系统日期格式配置
/// @return 
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
ClassMethod DateFormat()
{
	n
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY")&&(datesper="/") Quit 3
	i (dateformat="YMD")&&(datesper="-") Quit 3
	i (dateformat="MDY")&&(datesper="/") Quit 3
	Quit 3
}

/// modify by wuqk 2011-06-18 根据config修改输出格式
/// w ##class(websys.Conversions).DateLogicalToHtml(64253) $h
ClassMethod DateLogicalToHtml(h As %String) As %String
{
	;return month/day/year
	;w ##class(websys.Conversions).DateLogicalToHtml()
	s val=""
	Q:h="" ""
	; 不全是数字且不包含逗号,则返回
	Q:(h'?1n.n)&&(h'[",") h
	s $ZT="Err"
	Set format = ..DateFormat()
	Set date = $zd(h,format)
	if (format=4){
		Set date = $zd(h,format)
		Set $p(date,"/",3)=+$zd(h,3)
	}
	quit date
Err
	Q "ERROR!"
}

// debug: w ##class(EMRservice.BOCreateRecords).GetOthSSgroupID("4634","7")

ClassMethod GetOthSSgroupID(auserID As %String, aCTlocID As %String) As %String
{
	s ssgourpID = ""
	if ((aCTlocID'="")&&(auserID'=""))
    {
	    s intoThll = "0"
    	for
    	{
	    	s intoThll = $o(^SSU("SSUSR",auserID,"OTHLL",intoThll))
	    	q:(intoThll ="")
	    	s rest = ^SSU("SSUSR",auserID,"OTHLL",intoThll)
	    	s ctlocid = $p(rest,"^",1)
	    	if (ctlocid = aCTlocID)
	    	{
		    	s ssgourpID = $p(rest,"^",2)
	    		q
	    	}
    	}
    }
    q ssgourpID
}

}
