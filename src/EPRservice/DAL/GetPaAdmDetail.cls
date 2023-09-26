/// 此类为病历书写和病历浏览共用,修改时请注意.
/// modify by niucaicai
Class EPRservice.DAL.GetPaAdmDetail Extends %Persistent [ ProcedureBlock ]
{

/// craater:  yanghuiying
/// 登记号：  PAPMI_No
/// 病人姓名：PAPMI_Name
/// 年龄：    PAPMI_DOB
/// 性别：    PAPMI_Sex_DR->CT_Sex
/// 就诊日期：PAADM_AdmDate
/// 就诊时间：PAADM_AdmTime
/// 就诊科室：PAADM_DepCode_DR->CT_Loc
/// 医生：    PAADM_AdmDocCodeDR->CT_CareProv
/// 病人类型：PAADM_AdmRaeson_DR->PAC_AdmReason
/// 病房：    PAADM_CurrentRoomDR->PAC_Room
/// 就诊诊断：MRDIA_ICDCode_DR->MRC_ICDDx
/// Debug:    d ##class(%ResultSet).RunQuery("EPRservice.DAL.GetPaAdmDetail","GetPaAdmList","","","0000000001","","","","","","","","","")
/// Debug:    d ##class(%ResultSet).RunQuery("EPRservice.DAL.GetPaAdmDetail","GetPaAdmList","","","","","","张文霞","","","")
/// Debug:    d ##class(%ResultSet).RunQuery("EPRservice.DAL.GetPaAdmDetail","GetPaAdmList","","","","2008-11-25","2010-10-09","","","","")
Query GetPaAdmList(ALocID As %String, AIsArrivedQue As %String, APAPMINo As %String, AMedicareNo As %String, Stdate As %Date, Enddate As %Date, APAPMIName As %String, ACFCardNo As %String, APAAdmType As %String, AIDCard As %String, AexpectedLocID As %String, APAAdmStatus As %String, AMedicalInsuranceNo As %String, AStartTime As %String = "", AEndTime As %String = "") As %Query(ROWSPEC = "mradm:%String,PAPMIDR:%String,PAPMINO:%String,MedicareNo:%String,PAADMRowID:%String,PAPMIName:%String,IDCard:%String,CFCardNo:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,PAAdmWard:%String,Diagnosis:%String,PAADMReason:%String,PAADMBedNO:%String,PADischgeDate:%String,PADischgeTime:%String,Warddesc:%String")
{
}

ClassMethod GetPaAdmListExecute(ByRef qHandle As %Binary, ALocID As %String, AIsArrivedQue As %String, APAPMINo As %String, AMedicareNo As %String, Stdate As %Date, Enddate As %Date, APAPMIName As %String, ACFCardNo As %String, APAAdmType As %String, AIDCard As %String, AexpectedLocID As %String, APAAdmStatus As %String, AMedicalInsuranceNo As %String, AStartTime As %String = "", AEndTime As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s APAPMIName = $zcvt(APAPMIName,"u")
	if (AStartTime '= "") {	s AStartTime = $zth(AStartTime,"1")}
	if (AEndTime '= "") {	s AEndTime = $zth(AEndTime,"1")}
	
	s HospitalName = ##Class(EPRservice.BOSysOption).GetValueByName("HospitalName")
	s PAPMIName = APAPMIName
	s PAAdmType = ""
	s PAADMRowID = ""
	s PAPMIDR = ""
	//新增病案号
	s MedicareNo = ""
	if (APAPMINo '= "")
	{
		s PAPMIDR = ""
		for
		{
			s PAPMIDR = $o(^PAPERi("PAPMI_PatNo",APAPMINo,PAPMIDR))
			
			q:(PAPMIDR = "")
			
			if (APAAdmType '=  "")
			{
				//w "按登记号和就诊类型查询",!
				s PAAdmType = APAAdmType
				d GetPAADMRowID
			}
			else
			{
				s PAAdmType = "O"
				d GetPAADMRowID
				s PAAdmType = "I"
				d GetPAADMRowID
				s PAAdmType = "E"
				d GetPAADMRowID
			}
		}
	}
	elseif (AMedicareNo '= "")
	{
	    s PAPMIDR = $o(^PAPERi("Medicare1",AMedicareNo,""))
		if (APAAdmType '=  "")
		{
			//w "按病案号和就诊类型查询",!
			s PAAdmType = APAAdmType
			d GetPAADMRowID
		}
		else
		{
			s PAAdmType = "O"
			d GetPAADMRowID
			s PAAdmType = "I"
			d GetPAADMRowID
			s PAAdmType = "E"
			d GetPAADMRowID
		}
	}
	elseif (ACFCardNo '= "")
	{
		//按健康卡号和就诊类型查询    add by lina 2014-11-26
		s CFRowId = $o(^DHCCARDi("CF",0,"CardNo",ACFCardNo,""))
		s PAPMIDR = $p($g(^DHCCARD("CF",CFRowId)),"^",4)
		//s PAPMIDR = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDRByCFCardNo(ACFCardNo)
		if (APAAdmType '=  "")
		{
			s PAAdmType = APAAdmType
			d GetPAADMRowID
		}
		else
		{
			s PAAdmType = "O"
			d GetPAADMRowID
			s PAAdmType = "I"
			d GetPAADMRowID
			s PAAdmType = "E"
			d GetPAADMRowID
			
		}
	}
	elseif (AMedicalInsuranceNo '= "")
	{
		//按医保号查询
			s PapmiDRStr = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDRByInsuranceNo(AMedicalInsuranceNo,HospitalName)
			s count = $l(PapmiDRStr,"^")
			s num = 1
			
			for
			{
				q:(num>count)
				s PAPMIDR = $p(PapmiDRStr,"^",num)
				if (APAAdmType '= "")
				{
					s PAAdmType = APAAdmType
					d GetPAADMRowID
				}
				else
				{
					s PAAdmType = "O"
					d GetPAADMRowID
					s PAAdmType = "I"
					d GetPAADMRowID
					s PAAdmType = "E"
					d GetPAADMRowID
			
				}
				s num = num + 1
			}
			
		//w "按医保号查询",!
		//中国医科大学附属第一医院
		/*if (HospitalName = "ZGYDYFY")
		{
			s PapmiDRStr = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDRByInsuranceNo(AMedicalInsuranceNo,HospitalName)
			s count = $l(PapmiDRStr,"^")
			s num = 1
			
			for
			{
				q:(num>count)
				s PAPMIDR = $p(PapmiDRStr,"^",num)
				if (APAAdmType '= "")
				{
					s PAAdmType = APAAdmType
					d GetPAADMRowID
				}
				else
				{
					s PAAdmType = "O"
					d GetPAADMRowID
					s PAAdmType = "I"
					d GetPAADMRowID
					s PAAdmType = "E"
					d GetPAADMRowID
			
				}
				s num = num + 1
			}
		}
		else
		{
			if (APAAdmType '=  "")
			{
				s PAAdmType = APAAdmType
				d GetPAADMRowIDByInsuranceNo
			}
			else
			{
				s PAAdmType = "O"
				d GetPAADMRowIDByInsuranceNo
				s PAAdmType = "I"
				d GetPAADMRowIDByInsuranceNo
				s PAAdmType = "E"
				d GetPAADMRowIDByInsuranceNo
			
			}
		}*/
	}
	elseif (AIDCard '= "")
	{
		//w "按身份证号查询",!
		s PAPMIDR = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDRByIDCard(AIDCard)
		if (APAAdmType '=  "")
		{
			s PAAdmType = APAAdmType
			d GetPAADMRowID
		}
		else
		{
			s PAAdmType = "O"
			d GetPAADMRowID
			s PAAdmType = "I"
			d GetPAADMRowID
			s PAAdmType = "E"
			d GetPAADMRowID
			
		}
	}
	elseif (PAPMIName '= "")
	{	
		//w "按姓名和就诊类型查询",!
		for {
			s PAPMIDR = $o(^PAPERi("PAPER_PatName",PAPMIName,PAPMIDR))
			q:(PAPMIDR = "")
			
			if (APAAdmType '=  "")
			{
				s PAAdmType = APAAdmType
				d GetPAADMRowID
			}
			else
			{
				s PAAdmType = "O"
				d GetPAADMRowID
				s PAAdmType = "I"
				d GetPAADMRowID
				s PAAdmType = "E"
				d GetPAADMRowID
			}	
		}
	}
	elseif (Stdate '= "")&(Enddate '= "")
	{
		s StDate = $zdh(Stdate,3),EndDate=$zdh(Enddate,3)
		
		for AdmDate = StDate:1:EndDate {
			s PAADMRowID = ""
			if (APAAdmType '=  "") 
			{
				//w "按时间段和就诊类型查询",!
				for {
					s PAADMRowID = $o(^PAADMi("NNType",APAAdmType,AdmDate,PAADMRowID))
					q:(PAADMRowID = "")
					
					if (APAAdmStatus '= "all")
					{
						s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
						continue:(AdmStatus '= APAAdmStatus)
						
						//判断开始时间/结束时间
						if (AStartTime '= "")&&(AdmDate = StDate)
						{
							s AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
							continue:(AdmTime < AStartTime)
						}
						if (AEndTime '= "")&&(AdmDate = EndDate)
						{
							s AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
							continue:(AdmTime > AEndTime)
						}
						
						d IsArrivedQue
					}
					else
					{
						//判断开始时间/结束时间
						if (AStartTime '= "")&&(AdmDate = StDate)
						{
							s AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
							continue:(AdmTime < AStartTime)
						}
						if (AEndTime '= "")&&(AdmDate = EndDate)
						{
							s AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
							continue:(AdmTime > AEndTime)
						}
						d IsArrivedQue
					}
				}
			}
			else
			{
				//w "按时间段查询",!
				for {	
					s PAADMRowID = $o(^PAADMi("PAADM_AdmDate",AdmDate,PAADMRowID))
					q:(PAADMRowID = "")
					 
					if (APAAdmStatus '= "all")
					{
						s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
					
						continue:(AdmStatus '= APAAdmStatus)
						
						//判断开始时间/结束时间
						if (AStartTime '= "")&&(AdmDate = StDate)
						{
							s AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
							continue:(AdmTime < AStartTime)
						}
						if (AEndTime '= "")&&(AdmDate = EndDate)
						{
							s AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
							continue:(AdmTime > AEndTime)
						}
						
						d IsArrivedQue
					}
					else
					{
						//判断开始时间/结束时间
						if (AStartTime '= "")&&(AdmDate = StDate)
						{
							s AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
							continue:(AdmTime < AStartTime)
						}
						if (AEndTime '= "")&&(AdmDate = EndDate)
						{
							s AdmTime=$P($g(^PAADM(PAADMRowID)),"^",7)
							continue:(AdmTime > AEndTime)
						}
						
						d IsArrivedQue
					}
				}
			}
		}			
	}
	/*
	elseif (APAAdmType '= "")
	{
		//w "按就诊类型查询",!
		//s PAAdmType = APAAdmType
		d GetPAADMRowIDByPAAdmType
	}
	*/
	elseif (AexpectedLocID '= "")||(AIsArrivedQue = "on")
	{
		if (AIsArrivedQue = "on")
		{
			s locID = ALocID
		}
		if (AexpectedLocID '= "")
		{
			s locID = AexpectedLocID
		}
		//^PAADMi("CurrLoc",{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
		//w "按科室查询",!
		
		s AdmDate = ""
		for
		{
			s AdmDate = $o(^PAADMi("CurrLoc",locID,AdmDate))
			q:(AdmDate = "")
			
			if (Stdate '= "")||(Enddate '= "")
			{
				s StDate = $zdh(Stdate,3),EndDate=$zdh(Enddate,3)
				continue:(AdmDate < Stdate)
				continue:(AdmDate > EndDate)
			}
			
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
					
					if (APAAdmStatus '= "all")
					{
						s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
		
						continue:(AdmStatus '= APAAdmStatus)
					}
					if (APAAdmType '= "")
					{
						s PAAdmType = $p($g(^PAADM(PAADMRowID)),"^",2)
						continue:(PAAdmType '= APAAdmType)
					}
					
					d outputrow
				}
			}
		}
		/*
		s APAAdmType = "O"
		d GetPAADMRowIDByPAAdmType
		s APAAdmType = "I"
		d GetPAADMRowIDByPAAdmType
		s APAAdmType = "E"
		d GetPAADMRowIDByPAAdmType
		*/
	}
	else
	{
		s result = ##Class(%ResultSet).%New("web.DHCDocInPatientList:FindLocDocCurrentAdm")
		s sc = result.Execute("","","","","","","","",AIsArrivedQue,"")	
		While (result.Next())
 		{
	 		s PAADMRowID = $g(result.Data("EpisodeID"))
	 		d outputrow
 		}
	}
	
	Quit $$$OK
GetPAADMRowIDByInsuranceNo
	for 
	{
		s PAADMRowID = $o(^PAADMi("PAADM_Type",PAAdmType,PAADMRowID))
		q:(PAADMRowID = "")
	
		s MedicalInsuranceNo = ##class(EPRservice.HISInterface.PatientInfoAssist).InsuranceNo(PAADMRowID,HospitalName)
		continue:(MedicalInsuranceNo '= AMedicalInsuranceNo)
		if (APAAdmStatus '= "all")
		{
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
		
			continue:(AdmStatus '= APAAdmStatus)
		}
		if (Stdate '= "")
		{
			s StDate = $zdh(Stdate,3)
			s AdmStdate = $P($g(^PAADM(PAADMRowID)),"^",6)
			
			continue:(AdmStdate < StDate)
		}
		if (Enddate '= "")
		{
			s EndDate=$zdh(Enddate,3)
			s AdmEndDate = $P($g(^PAADM(PAADMRowID)),"^",6)
			
			continue:(AdmEndDate > EndDate)
			
		}
		
		d IsArrivedQue
	}
	Quit
GetPAADMRowIDByPAAdmType
	s PAADMRowID = ""
	for {
		s PAADMRowID = $o(^PAADMi("PAADM_Type",APAAdmType,PAADMRowID))
		q:(PAADMRowID = "")
		 
		if (APAAdmStatus '= "all")
		{
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
				
			continue:(AdmStatus '= APAAdmStatus)
		}
		if (Stdate '= "")
		{
			s StDate = $zdh(Stdate,3)
			s AdmStdate = $P($g(^PAADM(PAADMRowID)),"^",6)
		
			continue:(AdmStdate < StDate)
		}
		if (Enddate '= "")
		{
			s EndDate=$zdh(Enddate,3)
			s AdmEndDate = $P($g(^PAADM(PAADMRowID)),"^",6)
		
			continue:(AdmEndDate > EndDate)
		}
	
		d IsArrivedQue
	}
	Quit
GetPAADMRowID
    for {
		s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM",PAAdmType,PAADMRowID))
		
		q:(PAADMRowID = "")
		
		//判断病人的在院状态
		if (APAAdmStatus '= "all")
		{
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
				
			continue:(AdmStatus '= APAAdmStatus)
		}
		if (Stdate '= "")
		{
			s StDate = $zdh(Stdate,3)
			s AdmStdate = $P($g(^PAADM(PAADMRowID)),"^",6)
			
			continue:(AdmStdate < StDate)
		}
		if (Enddate '= "")
		{
			s EndDate=$zdh(Enddate,3)
			s AdmEndDate = $P($g(^PAADM(PAADMRowID)),"^",6)
			
			continue:(AdmEndDate > EndDate)
			
		}
		
		d IsArrivedQue
		
	}
	Quit
	
IsArrivedQue
	s mCurrRow = $g(^PAADM(PAADMRowID))
	s PAADMDepCode=$p($g(mCurrRow),"^",4)
	if (PAADMDepCode '= "")
	{
		s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
	}
	else
	{
		s PAAdmDepCodeDR = "无"
	}
	if (AIsArrivedQue = "on")
	{
		if (PAADMDepCode = ALocID)
		{
			d outputrow
		}
	}
	elseif (AexpectedLocID '= "")
	{
		if (PAADMDepCode = AexpectedLocID)
		{
			d outputrow
		}
	}
	else
	{
		d outputrow
	}
	Quit
outputrow
	//s CFCardNo = ##class(EPRservice.HISInterface.PatientInfoAssist).GetCFCardNo(PAADMRowID)
	s mCurrRow = $g(^PAADM(PAADMRowID))
	s mradm=$p(^PAADM(PAADMRowID),"^",61)
	s PAPMIDR = $p($g(mCurrRow),"^",1)
	//健康卡号   add by lina 2014-11-26
	s CFRowId = $o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDR,""))
	s CFCardNo = ""
	if (CFRowId '= "")
	{
		s CFCardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
	}
	s IDCard = $p($g(^PAPER(PAPMIDR,"PAT",3)),"^",6)
	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	s PAPMINO = $p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
	//新增病案号  add by lina 2014-11-25
	s MedicareNo = $P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22)
	s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
	s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
	s PAAdmType = $p($g(mCurrRow),"^",2)
	if (PAAdmType = "O")
	{
		s PAAdmType = "门诊"
	}
	elseif (PAAdmType = "E")
	{
		s PAAdmType = "急诊"
	}
	elseif (PAAdmType = "I")
	{
		s PAAdmType = "住院"
	}
	//日期时间处理
	s PAPMIDOB = $p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
	if (PAPMIDOB '= "")
	{
		s PAPMIDOB = $zd(PAPMIDOB,3)
	}
	s PAAdmTime = $p($g(mCurrRow),"^",7)
	if (PAAdmTime '= "")
	{
		s PAAdmTime = $zt(PAAdmTime,3)
	}
	s PAAdmDate = $p($g(mCurrRow),"^",6)
	if (PAAdmDate '= "")
	{
		s PAAdmDate = $zd(PAAdmDate,3)
	}
	s PADischgeDate=$P($g(^PAADM(PAADMRowID)),"^",17)
	if (PADischgeDate '= "")
	{
		s PADischgeDate = $zd(PADischgeDate,3)
	}
	s PADischgeTime=$P($g(^PAADM(PAADMRowID)),"^",18)
	if (PADischgeTime '= "")
	{
		s PADischgeTime = $zt(PADischgeTime,3)
	}
	
	s PAADMReasonDR = $p($g(^PAADM(PAADMRowID,1)),"^",7)
	if (PAADMReasonDR '= "")
	{
		s PAADMReason = $p($g(^PAC("ADMREA",PAADMReasonDR)),"^",2)
	}
	else
	{
		s PAADMReason = "无"
	}
	
	s PAADMDepCode=$p($g(mCurrRow),"^",4)
	if (PAADMDepCode '= "")
	{
		s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
	}
	else
	{
		s PAAdmDepCodeDR = "无"
	}
	
	s PAADMDocCode=$p($g(mCurrRow),"^",9)
	if (PAADMDocCode '= "")
	{
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}
	s PAADMBedDR = $p($g(^PAADM(PAADMRowID)),"^",73)
	if (PAADMBedDR '= "")
	{
		s WARDRowID = $p(PAADMBedDR,"||",1)
		s BEDChildsub = $p(PAADMBedDR,"||",2)
		s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
		s PAAdmWard = $p($g(^PAROOM(BEDRoomDR)),"^",2)
		s PAADMBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
	}
	else
	{
		s PAAdmWard = "无"
		s PAADMBedNO = "无"
	}
	//以下是获取患者当前病区
	s disWardDR = $P($g(^PAADM(PAADMRowID)),"^",70)
	if (disWardDR '= "")
	{
		s Wardcode =$p($g(^PAWARD(disWardDR)),"^",1)
		s Warddesc =$p($g(^PAWARD(disWardDR)),"^",2) 
	}
	else
	{
		s Wardcode = "无"
		s Warddesc = "无"
	}
	/*
	s Diagnosis = ""
	s MainMRADMDR = $p($g(^PAADM(PAADMRowID)),"^",61)
	s MRDIRChildsub = ""
	for {
		s MRDIRChildsub = $o(^MR(MainMRADMDR,"DIA",MRDIRChildsub))
		
		q:(MRDIRChildsub = "")
		s ICDCodeDR = $p($g(^MR(MainMRADMDR,"DIA",MRDIRChildsub)),"^",1)
		if (ICDCodeDR '= "")
		{
			s ICDCode = $p($g(^MRC("ID",ICDCodeDR)),"^",2)
			s Diagnosis = Diagnosis_ICDCode_" "
			b
		}
		else
		{
			s Diagnosis = "无"
		}	
	}
	*/
	s Diagnosis = ##class(EPRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
	if (Diagnosis '= "")
	{	
		s Diagnosis = $P(Diagnosis,"^",3)
		s Diagnosis = $tr(Diagnosis,"'","\'")
	}
	else
	{
		s Diagnosis = "无"
	}
	set ^CacheTemp(repid,ind) = $LB(mradm,PAPMIDR,PAPMINO,MedicareNo,PAADMRowID,PAPMIName,IDCard,CFCardNo,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,PAAdmWard,Diagnosis,PAADMReason,PAADMBedNO,PADischgeDate,PADischgeTime,Warddesc)
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

Storage Default
{
<Data name="GetPaAdmDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservice.DAL.GetPaAdmDetailD</DataLocation>
<DefaultData>GetPaAdmDetailDefaultData</DefaultData>
<IdLocation>^EPRservice.DAL.GetPaAdmDetailD</IdLocation>
<IndexLocation>^EPRservice.DAL.GetPaAdmDetailI</IndexLocation>
<StreamLocation>^EPRservice.DAL.GetPaAdmDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
