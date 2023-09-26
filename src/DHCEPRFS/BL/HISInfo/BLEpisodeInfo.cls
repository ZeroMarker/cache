Class DHCEPRFS.BL.HISInfo.BLEpisodeInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 通过就诊号得到就诊类型
/// AEpisodeID:就诊号   AdmType:就诊类型
/// output:I:住院   O:门诊   E:急诊   N:新生儿   H:健康促进
/// debug:w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType("579")
ClassMethod GetAdmType(AEpisodeID As %String) As %String
{
	s AdmType = $p($g(^PAADM(AEpisodeID)),"^",2)   
	s AdmTypeDesc = ""
	//就诊类型
	if (AdmType = "I")
	{
		s AdmTypeDesc = "住院"
	}
	elseif (AdmType = "O")
	{
		s AdmTypeDesc = "门诊"
	}
	elseif (AdmType = "E")
	{
		s AdmTypeDesc = "急诊"
	}
	
	q AdmType_"^"_AdmTypeDesc
}

ClassMethod GetPatientInfoByAdm(AEpisodeID As %String) As %String
{
	s patientID = ..GetPapmiDR(AEpisodeID)
	s admDate = ..GetAdmDate(AEpisodeID)
	s:((admDate '= "") && (admDate '= $c(0))) admDate = $zd(admDate,3)
	s disDate = ..DisDateTime(AEpisodeID)
	s:((disDate '= "") && (disDate '= $c(0))) disDate = $zd($p(disDate,",",1),3)
	s admLoc = ..AdmDept(AEpisodeID)
	s:((admLoc '= "") && (admLoc '= $c(0))) admLoc = $p(admLoc,"^",3)
	s disLoc = ..DisDept(AEpisodeID)
	s:((disLoc '= "") && (disLoc '= $c(0))) disLoc = $p(disLoc,"^",3)
	s RegNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
	s MedRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",AEpisodeID)
	s Name = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetName(patientID)
	s Gender = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetGender(patientID)
	s:($l(Gender,"^") > 1) Gender = $p(Gender,"^",3)
	s ret = MedRecordNo_"^"_RegNo_"^"_patientID_"^"_AEpisodeID_"^"_Name_"^"_Gender_"^"_admDate_"^"_disDate_"^"_admLoc_"^"_disLoc
	q ret
}

/// Desc:	根据PatientID获取就诊ID列表
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmListByPapmiDR("00000005")
ClassMethod GetAdmListByPapmiDR(APapmiDR As %String) As %String
{
	s ret = ""
	
	q:(APapmiDR = "") ret
	
	s type = ""
	for {
		s type = $O(^PAPERdr(APapmiDR,"ADM",type))
		q:(type = "")
		
		s admID = ""
		for {
			s admID = $O(^PAPERdr(APapmiDR,"ADM",type,admID))
			q:(admID = "")
			
			if (ret = "")
			{
				s ret = admID
			}
			else
			{
				s ret = ret_"^"_admID	
			}
		}
	}
	
	q ret
}

/// debug: w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).NoPlanAgainOp("973530")
ClassMethod NoPlanAgainOp(AEpisodeID As %String)
{
	//非计划再次手术
	s Glossary = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,"HDSD00.11")
	s operStatusFP = Glossary.GetAt("HDSD00.11.823")
	if (operStatusFP = "是")
	{
		s operStatusFP = "Y"
	}
	else
	{
		s operStatusFP = "N"
	}
	//s operStatusFP = ##class(EPRservice.BOScatterData).GetEPRData(AEpisodeID,"#TYPE:Simple#TID:181#TVER:0#SCODE:O0392#VTYPE:V")
	q operStatusFP
}

/// debug: w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetMedNo(4714475)
ClassMethod GetMedNo(AEpisodeID As %String) As %String
{
	s medicare = ##class(EPRservice.HISInterface.PatientInfoAssist).IPRecordNoByMR(AEpisodeID)
	s:(+medicare < 0 ) medicare = ""
	q medicare
}

/// debug: w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAge()
ClassMethod GetAge(AEpisodeID As %String) As %String
{
	s RetAge = ""
	q:(AEpisodeID = "") RetAge
	
	s PapmiDR = ..GetPapmiDR(AEpisodeID)
	
	//（用以计算年龄）入院日期时间（入院登记日期时间）
	s (ArgAdmDate, ArgAdmTime) = ""
	s AdmDateTime = ..GetAdmDateTime(AEpisodeID)
	if (AdmDateTime '= "")
	{
		//入院日期内部格式
		s ArgAdmDate = $p($g(AdmDateTime),",",1)
		//入院时间内部格式
		s ArgAdmTime = $p($g(AdmDateTime),",",2)
	}
	
	//获取HIS年龄信息
	s tmpAge = ##class(web.DHCBillInterface).GetPapmiAge(PapmiDR,AEpisodeID)
	
	//获取年月日初始值
	s tmpAgeYear = "", tmpAgeAfterYear = ""
	if (tmpAge["岁")
	{
		s tmpAgeYear = $p(tmpAge,"岁",1)
		s tmpAgeAfterYear = $p(tmpAge,"岁",2)
	}
	else
	{
		s tmpAgeAfterYear = tmpAge
	}
	s tmpAgeMonth = "", tmpAgeAfterMonth = ""
	if (tmpAgeAfterYear["月")
	{
		s tmpAgeMonth = $p(tmpAgeAfterYear,"月",1)
		s tmpAgeAfterMonth = $p(tmpAgeAfterYear,"月",2)
	}
	else
	{
		s tmpAgeAfterMonth = tmpAgeAfterYear
	}
	s tmpAgeDay = ""
	s:(tmpAgeAfterMonth["天") tmpAgeDay = $p(tmpAgeAfterMonth,"天",1)
	
	s RetAge = tmpAgeYear_"^"_tmpAgeMonth_"^"_tmpAgeDay
	q RetAge
}

ClassMethod GetPatientID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	s retValue = $P($g(^PAADM(AEpisodeID)),"^",1)
	q:(retValue '= "") retValue

	//华西医院：global节点中的数据丢失，但sql语句可以查询出数据
	&sql(select PAADM_PAPMI_DR into :retValue from SQLUser.PA_Adm where PAADM_RowId = :argAdmId)
	q:(retValue '= "") retValue
	
	s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_AEpisodeID, ""))
	q:(mrEpisodeID="") ""
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
	q:(objMREpisode="") ""
	s mrPatientID = objMREpisode.MRPatientID
	q:(mrPatientID = "") ""
	s objMRPatientID = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	q:(objMRPatientID = "") ""
	s retValue = objMRPatientID.PatientID 
	q retValue
}

/// Desc:	入院次数(Trak中入院病人状态不是Cancel的个数)
/// Others:	not different from hospitals 
ClassMethod InTimes(AEpisodeID As %String) As %String
{
	q:($d(AEpisodeID)=0)||(AEpisodeID="") ""	
	
	s admid=0,times=0,papmiDR=""
	
	//PAADM_InPatNo
	s times= $p($g(^PAADM(AEpisodeID)),"^",29)
	q:(times '="")&&(times '= $C(0)) times
	
	s times = 0
	s papmiDR = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(AEpisodeID)
	if (papmiDR = "")
	{
		s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_AEpisodeID, ""))
		q:(mrEpisodeID="") ""
		s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		q:(objMREpisode="") ""
		s times = objMREpisode.InNum
	}
	else
	{
		q:($d(^PAPERdr(papmiDR,"ADM","I"))'=10) "1"
		for {
			s admid=$o(^PAPERdr(papmiDR,"ADM","I",admid))
			q:((admid="")||(admid>AEpisodeID))
			// Trak中入院病人状态不是Cancel的个数
			if $d(^PAADMi("PAADM_VisitStatus","C",admid))=0 {s times=times+1}
		}
	}
		
	q times
}

/// Desc:	医政组的入院次数</Description>
ClassMethod InTimesWMR(argAdmId As %String, argHospital As %String)
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
    s status = $P($G(^PAADM(argAdmId)), "^", 20)
    q:status="C" ""		
	
	s InTimesWMR=""
	s InTimesWMR=##Class(web.DHCWMRService).IGetIPCountByEpisodeID(argAdmId)
	s InTimesWMR=$CASE(InTimesWMR,-1:"",0:1,:InTimesWMR)

	q InTimesWMR
}

/// Desc: 通过就诊号得到就诊日期
/// Input: EpisodeID:就诊号
/// Return: PAdmDate:就诊日期
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate("579")
ClassMethod GetAdmDate(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	
	s admTypeCode = $p($g(^PAADM(AEpisodeID)),"^",2)
	if ($d(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))&&(admTypeCode="I"))
	{
		s admdate = $p($g(^PAADM(AEpisodeID,"DHC")),"^",31)
		s:(admdate="") admdate = $p($g(^PAADM(AEpisodeID)),"^",6)
	}
	else
	{
		s admdate = $p($g(^PAADM(AEpisodeID)),"^",6)
	}
	q:(admdate'="") admdate
	
	s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_AEpisodeID, ""))
	q:(mrEpisodeID="") ""
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
	q:(objMREpisode="") ""
	s admdate = objMREpisode.AdmDate
	
	q admdate
}

ClassMethod GetAdmDateTime(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	
	s admTypeCode = $p($g(^PAADM(AEpisodeID)),"^",2)
	if ($d(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))&&(admTypeCode="I"))
	{
		s admdate = $p($g(^PAADM(AEpisodeID,"DHC")),"^",31)
		s admtime = $p($g(^PAADM(AEpisodeID,"DHC")),"^",32)
		if (admdate = "")&&(admtime = "")
		{
			s admdate = $p($g(^PAADM(AEpisodeID)),"^",6)
			s admtime = $p($g(^PAADM(AEpisodeID)),"^",7)
		}
	}
	else
	{
		s admdate = $p($g(^PAADM(AEpisodeID)),"^",6)
		s admtime = $p($g(^PAADM(AEpisodeID)),"^",7)
	}
	
	q admdate_","_admtime
}

/// Desc: 通过就诊号得到出院日期时间
/// Output: date_","_time【Cache内部格式】
/// Others: not different from hospitals
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime("579")
ClassMethod DisDateTime(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s dischgdatetime="",dischgdate="",dischgtime=""
	s dischgdateyear="",dischgdatemonth="",dischgdateday=""
	
	if (($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11))
	{
		s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_argAdmId, ""))
		q:(mrEpisodeID="") ""
		s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		q:(objMREpisode="") ""
		s dischgdate = objMREpisode.DisDate
		s dischgtime = objMREpisode.DisTime
		s dischgdatetime=dischgdate_","_dischgtime
	}
	else
	{
		if $d(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))
		{
			s dischgdate = $p($g(^PAADM(argAdmId,"DHC")),"^",29)
			s dischgtime = $p($g(^PAADM(argAdmId,"DHC")),"^",30)
		}
		else
		{
			s dischgdate = $p($g(^PAADM(argAdmId)),"^",17)
			s dischgtime = $p($g(^PAADM(argAdmId)),"^",18)
		}
		q:((dischgdate="")||(dischgtime="")) ""
		s dischgdatetime=dischgdate_","_dischgtime
	}
	q dischgdatetime
}

/// Desc: 	出院日期时间(医生结算)
/// Output：date_","_time【Cache内部格式】
/// Others：not different from hospitals
ClassMethod DisDateTimeDoctor(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s dischgdatetime="",dischgdate="",dischgtime=""
	s dischgdateyear="",dischgdatemonth="",dischgdateday=""
		
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s dischgdate=$P($G(^PAADM(argAdmId)),"^",59)
	s dischgtime=$P($G(^PAADM(argAdmId)),"^",60)
	q:((dischgdate="")||(dischgtime="")) ""

	s dischgdatetime=dischgdate_","_dischgtime
	q dischgdatetime
}

/// Desc：	死亡日期时间
/// Ouput：	date，time【内部格式】
/// Others：not different from hospitals 
/// debug w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DeathDateTime("3498596")
ClassMethod DeathDateTime(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	
	s deathdate="",deathtime=""
	s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
	s deathtime=$p(^PAPER(argPapmiDR,"ALL"),"^",8)
	q:((deathdate="")||(deathtime="")) ""
	q deathdate_","_deathtime
}

/// Desc：	入院科室【返回: RowId^Code^Desc】
/// Table：	
/// OutPut:	RowId^Code^Desc
/// Others: not different from hospitals
/// w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDept("O402014")
ClassMethod AdmDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s TRANSChildsub="",locDR="",tmplocDR="",bed="",admdept="",DeptDesc="",DeptCode=""
	
	// 遍历转科记录，取入院科室
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s tmplocDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",6)
	.if tmplocDR'="" {s locDR=tmplocDR}
		
	if locDR'="" 
	{	
		s DeptCode=$p($g(^CTLOC(locDR)),"^",1)
		s DeptDesc=$p($g(^CTLOC(locDR)),"^",2)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s admdept=locDR_"^"_DeptCode_"^"_DeptDesc		
	}
	
	q:(admdept '="") admdept
	
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("admdept"," DHC"," "_argAdmId,""))
	q:(mrEpisodeID = "") ""
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
	s locID = objMREpisode.AdmLocID
	s loc = objMREpisode.AdmLoc
	s admdept=locID_"^^"_loc
	q admdept
}

/// Desc:	入院病区【RowId^Code^Desc】
/// Table：	
/// Output：RowId^Code^Desc
/// Others：not different from hospitals
ClassMethod AdmWard(argAdmId As %String, argHospital As %String) As %String
{
	
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s TRANSChildsub="",WardCode="",wardDR="",bed="",WardDesc="",admward=""
	
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s wardDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",9)
	if wardDR'="" 
	{
	
			s WardCode=$p($g(^PAWARD(wardDR)),"^",1)
			s WardDesc=$p($g(^PAWARD(wardDR)),"^",2)
			if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
			s admward=wardDR_"^"_WardCode_"^"_WardDesc
	}
	
	q admward
}

/// Desc: 	出院科室(即当前科室)【RowId^Code^Desc】
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod DisDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s DeptCode="",DeptDesc="",dischgDeptDR="",dischgDept=""
	
	s dischgDeptDR=$P($g(^PAADM(argAdmId)),"^",4)
	if dischgDeptDR'="" 
	{	
		s DeptDesc=$p($g(^CTLOC(dischgDeptDR)),"^",2)
		s DeptCode=$p($g(^CTLOC(dischgDeptDR)),"^",1)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s dischgDept=dischgDeptDR_"^"_DeptCode_"^"_DeptDesc
	}

	q:(dischgDept '="") dischgDept
	
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_argAdmId,""))
	q:(mrEpisodeID = "") ""
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
	s locID = objMREpisode.DisLocID
	s loc = objMREpisode.DisLoc
	s dischgDept=locID_"^^"_loc
	q dischgDept
}

/// Desc:  	出院病区【RowId^Code^Desc】
/// Output: RowId^Code^Desc
/// Others：not different from hospitals 
ClassMethod DisWard(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s WardDesc="",WardCode="",dischgWardDR="",dischgWard=""
	
	s dischgWardDR=$P($g(^PAADM(argAdmId)),"^",70)
	if dischgWardDR'="" 
	{

			s WardDesc=$p($g(^PAWARD(dischgWardDR)),"^",2)
			s WardCode=$p($g(^PAWARD(dischgWardDR)),"^",1)
			if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
			s dischgWard=dischgWardDR_"^"_WardCode_"^"_WardDesc
		
	}	
	
	q dischgWard
}

/// Desc:	入院医生 
/// Output:	RowId^医生代码^医生描述
/// Table:	PA_Adm.PAADM_AdmDocCodeDR
/// 		AdmDoctorDR is CT_CareProv RowID
ClassMethod AdmDoctor(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s admdoctorDR="",admdoctor="",admdoctorcode=""
	
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s AdmDoctorDR=$P($g(^PAADM(argAdmId)),"^",9)
	if AdmDoctorDR'=""
	{
		s admdoctorcode=$P($g(^CTPCP(AdmDoctorDR,1)),"^",1)
		s admdoctor=$P($g(^CTPCP(AdmDoctorDR,1)),"^",2)
		s admdoctor=AdmDoctorDR_"^"_admdoctorcode_"^"_admdoctor
	}
 
	q admdoctor
}

/// Desc:	转科明细
/// Output:	//(科室DR^科室名称^日期^时间^病区DR^病区名称->科室DR^科室名称^日期^时间^病区DR^病区名称->...)或(无)
/// 			科室DR-科室DR^科室名称-科室名称
/// 		Update wangwentao 20090901 Update 20100408
/// ModifyDate: 2009-09-12
/// ModifyUser: houj
/// ModifyReson: 使用global实现替代sql实现
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).TransDeptDetail(5727508)
ClassMethod TransDeptDetail(argAdmId As %String, argHospital As %String = "") As %String
{
	//入参检查
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="") ""
	
	//定义变量
	s transDept="",tmpTransDept="",lastTransDept="",lastTransWard="",tmpTransWard=""
	s transDeptID = ""
	s transDeptDesc = ""
	
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s tmpTransDept = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p(tmpTransDept,"-",2)}
		if tmpTransDept="" continue
		if tmpTransDept=lastTransDept continue
		
		//get TRANS_Ward_DR PAC_Ward
		s transPACWardDR = $p($g(^PAADM(argAdmId,"TRANS",childSub+1)),"^",9)
		if transPACWardDR="" continue
		
		s tmpTransWard = $p($g(^PAWARD(transPACWardDR)),"^",2)
		if $l(tmpTransWard,"-")>1 {s tmpTransWard=$p(tmpTransWard,"-",2)}
		if tmpTransDept="" continue
		if tmpTransWard=lastTransWard continue
		
		
		s startDate = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",1)
		s startTime = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",2)
		
		s transDept = transDept_transCtlocDR_"^"_tmpTransDept_"^"_$zd(startDate,3)_"^"_$zt(startTime)_"^"_transPACWardDR_"^"_tmpTransWard
		s transDept = transDept_"->"
		
		s lastTransDept=tmpTransDept
		s lastTransWard=tmpTransWard
		
		if (transDeptID = "")
		{
			s transDeptID = transCtlocDR
			s transDeptDesc = tmpTransDept  	
		}
		else
		{
			s transDeptID = transDeptID_"-"_transCtlocDR
			s transDeptDesc = transDeptDesc_"-"_tmpTransDept  		
		}
	}
	
	if transDept'=""
	{
		s transDept=$e(transDept,1,$l(transDept)-2)
		if ('($f(transDept,"->")>0)) 
		{
			s transDept=""
			q ""
		}
	}
	
	//s transDept = $p(transDept,"->",$l(transDept,"->")) 
		
	//q transDept
	q transDeptID_"^"_transDeptDesc
}

/// Desc:	住院天数
/// Input:	argAdmId: 病人就诊RowID，argHospital:医院标识
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod ResidentDaysAdm(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//q:($d(argHospital)=0)||(argHospital="") ""
	
	s papmidr="",DeathDateTime="",AdmDateTime="",DisDateTimeMR="",DisDateTime=""
	s admdate="",admtime="",dischgdate="",dischgtime=""
	s residentdays=""

	//取PapmiDR
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s papmidr = ..GetPapmiDR(argAdmId)
	
	
	//取入院日期(护士分床)
	s AdmDateTimeInBed=..GetAdmDateTime(argAdmId)
	if AdmDateTimeInBed'="" 
	{
		s admdate=$p($g(AdmDateTimeInBed),",",1)
	}
	
	//出院日期取值判断  死亡日期->出院日期(统计组)->出院日期(护士结算)
	

	//取死亡日期
	s DeathDateTime=..DeathDateTime(papmidr)
	if DeathDateTime'=""
	{
		s dischgdate=$p($g(DeathDateTime),",",1)
	}
		
	if dischgdate=""
	{
		/*取出院日期(统计组)
		s DisDateTimeMR=..DisDateTimeMR(argAdmId)
		if DisDateTimeMR'="" 
		{
			s dischgdate=$p($g(DisDateTimeMR),",",1)
		}*/
		
		if dischgdate=""
		{
			//取出院日期(护士结算)
			s DisDateTime=..DisDateTime(argAdmId)
			if DisDateTime'="" 
			{
				s dischgdate=$p($g(DisDateTime),",",1)
			}
		}
	}
	
	
	q:((admdate="")||(dischgdate="")) ""
	
	//计算住院天数
	s residentdays = ..ResidentDays(admdate,dischgdate)

	q residentdays
}

/// Desc：	取患者指针(PatientID)，not different from hospitals
/// Table:	PA_Adm.PAADM_PAPMI_DR
/// Others：被下列模板引用
/// 		[病案质控]EPRmeta.Quality.QualityExamSet
/// 		[模板控制]EPRservice.TPrivLogic.PatientInfoAssist
ClassMethod GetPapmiDR(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s retValue = ""
	s retValue = $P($g(^PAADM(argAdmId)),"^",1)
	q:(retValue '= "") retValue

	//华西医院：global节点中的数据丢失，但sql语句可以查询出数据
	&sql(select PAADM_PAPMI_DR into :retValue from SQLUser.PA_Adm where PAADM_RowId = :argAdmId)
	q retValue
}

/// Desc:	住院天数
/// Input:	argAdmDate: 入院日期(Cache内部格式)，argDischgDate:出院日期(Cache内部格式)
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod ResidentDays(argAdmDate As %String, argDischgDate As %String) As %String
{
	q:($d(argAdmDate)=0)||($d(argDischgDate)=0)||(argAdmDate="")||(argDischgDate="") ""
	s residentdays=""
	
	s residentdays=argDischgDate - argAdmDate
	q:(residentdays<0) ""
 	//不足1天按1天计算
 	q:(residentdays=0) "1"
 	
 	q residentdays
}

/// Desc：	取母亲就诊RowID
ClassMethod GetMotherAdmDR(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	q $P($g(^PAADM(AEpisodeID)),"^",75)
}

ClassMethod SetMREpisode(AEMREpisode As DHCEPRFS.Entity.EMREpisode) As %String
{
	s result = "0"
	q:((AEMREpisode.MRPatientID = "")||(AEMREpisode.EpisodeID = "")) result

	if ($d(^DHCEPRFS.INST.MREpisodeI("IdxEpisodeID"," "_AEMREpisode.MRPatientID," "_AEMREpisode.SysCode," "_AEMREpisode.EpisodeID)))
	{
		s result = $o(^DHCEPRFS.INST.MREpisodeI("IdxEpisodeID"," "_AEMREpisode.MRPatientID," "_AEMREpisode.SysCode," "_AEMREpisode.EpisodeID,""))
		q result
	}
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%New()
	s objMREpisode.MRPatientID = AEMREpisode.MRPatientID
	s objMREpisode.MedRecordNo = AEMREpisode.MedRecordNo
	s objMREpisode.SysCode = AEMREpisode.SysCode
	s objMREpisode.EpisodeID = AEMREpisode.EpisodeID
	s objMREpisode.AdmDate = AEMREpisode.AdmDate
	s objMREpisode.AdmTime = AEMREpisode.AdmTime
	s objMREpisode.DisDate = AEMREpisode.DisDate
	s objMREpisode.DisTime = AEMREpisode.DisTime
	s objMREpisode.DeathDate = AEMREpisode.DeathDate
	s objMREpisode.DeathTime = AEMREpisode.DeathTime
	s sc = objMREpisode.%Save()
	s:($$$ISOK(sc)) result = objMREpisode.%Id()
	q result
}

/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLEpisodeInfo","GetEpisode","582^^^")
Query GetEpisode(AParam As %String) As %Query(ROWSPEC = "FlagMRCompletion:%String,FlagFinalAccount:%String,SysCode:%String,CreateDate:%String,CreateTime:%String,FlagFinalAccountDate:%String,FlagFinalAccountTime:%String,FlagMRCompletionDate:%String,FlagMRCompletionTime:%String,FlagFinalAccountUserName:%String,FlagMRCompletionUserName:%String,PAPMIName:%String,PAStatusType:%String,PAAdmType:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String")
{
}

ClassMethod GetEpisodeExecute(ByRef qHandle As %Binary, AParam As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s AAdmNo = $p(AParam,"^",1)
	s AMedRecordNo = $p(AParam,"^",2)
	s APatientName = $p(AParam,"^",3)
	s ARegNo = $p(AParam,"^",4)
	
	d DealParamter   //处理参数
	if (AAdmNo '= "")
	{
		s PAAdm = AAdmNo
		d OutPutRow
	}
	elseif (ARegNo '= "")
	{
		s ARegNo = ..AddZero(ARegNo)
		s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PAPMI = "") $$$OK
		d OutPutPAMI
	}
	elseif (AMedRecordNo '= "")
	{
		s PAPMIS = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiInfo(AMedRecordNo)
		for index=1:1:$l(PAPMIS,"^")
		{
			s PAPMI = $p(PAPMIS,"^",index)
			continue:(PAPMI = "")
			d OutPutPAMI
		}
	}
	elseif (APatientName '= "")
	{
		s PAPMI = ""
		for {
			s PAPMI = $o(^PAPERi("PAPER_PatName",APatientName,PAPMI))
			q:(PAPMI = "")
			d OutPutPAMI
		}
	}
	
	Quit $$$OK
	
OutPutPAMI
	s AdmType = ""
	for {
		s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
		q:(AdmType = "")
		s PAAdm = ""
		for {
			s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
			q:(PAAdm = "")
			d OutPutRow
		}
	}
	q
	
OutPutRow
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," "_"DHC"," "_PAAdm,rowID))
	if (rowID '= "")
	{
		s objScheme = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(rowID)
		s SysCode = objScheme.SysCode
		s CreateDate = $case(objScheme.CreateDate,"":"",:$zd(objScheme.CreateDate,3))
		s CreateTime = $case(objScheme.CreateTime,"":"",:$zt(objScheme.CreateTime,1))
		s FlagFinalAccount = objScheme.FlagFinalAccount
		s FlagFinalAccountDate = $case(objScheme.FlagFinalAccountDate,"":"",:$zd(objScheme.FlagFinalAccountDate,3))
		s FlagFinalAccountTime = $case(objScheme.FlagFinalAccountTime,"":"",:$zt(objScheme.FlagFinalAccountTime,1))
		s FlagMRCompletion = objScheme.FlagMRCompletion
		s FlagMRCompletionDate = $case(objScheme.FlagMRCompletionDate,"":"",:$zd(objScheme.FlagMRCompletionDate,3))
		s FlagMRCompletionTime = $case(objScheme.FlagMRCompletionTime,"":"",:$zt(objScheme.FlagMRCompletionTime,1))
		s FlagFinalAccountUserID = objScheme.FlagFinalAccountUserID
		if ($p(FlagFinalAccountUserID,"^",1) = "TEMP")
		{
			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(FlagFinalAccountUserID,"^",2))
			s FlagFinalAccountUserName = objUser.UserName
		}
		else
		{
			s FlagFinalAccountUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(FlagFinalAccountUserID)
		}
		s FlagMRCompletionUserID = objScheme.FlagMRCompletionUserID
		if ($p(FlagMRCompletionUserID,"^",1) = "TEMP")
		{
			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(FlagMRCompletionUserID,"^",2))
			s FlagMRCompletionUserName = objUser.UserName
		}
		else
		{
			s FlagMRCompletionUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(FlagMRCompletionUserID)
		}
	}
	else
	{
		s SysCode = ""
		s CreateDate = ""
		s CreateTime = ""
		s FlagFinalAccount = ""
		s FlagFinalAccountDate = ""
		s FlagFinalAccountTime = ""
		s FlagMRCompletion = ""
		s FlagMRCompletionDate = ""
		s FlagMRCompletionTime = ""
		s FlagFinalAccountUserID = ""
		s FlagMRCompletionUserID = ""
	}
	
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)
	q:(PAAdmType '= "I")	//只显示住院的就诊
	//就诊类型
	if (PAAdmType = "I")
	{
		s PAAdmType = "住院"
	}
	elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}
	elseif PAAdmType = "E"
	{
		s PAAdmType = "急诊"
	}
	//病人姓名
	s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)
	//身份证号
	s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9)
	//登记号
	s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	
	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""
	s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
	if (DobDate '= "")
	{
		s PAPMIDOB = $ZD(DobDate,3)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	//性别
	s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)
	s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	//婚姻
	s tmpMarriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
	if (tmpMarriage '= "")
	{
		s Marriage= $p($g(tmpMarriage),"^",3)
	}
	//出生地
	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
	if (tmpNative '= "")
	{
		//出生地城市
		s CityBirth = $p($g(tmpNative),"!",2)
		s CityBirth = $p($g(CityBirth),"^",2)
		
		//出生地省份
		s ProvinceBirth = $p($g(tmpNative),"!",1)
		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
	}
	//职业
	s tmpOccupation = ##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
	if (tmpOccupation '= "")
	{
		s Occupation = $p($g(tmpOccupation),"^",2)
	}
	//民族
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	if (tmpNation '= "")
	{
		s Nation = $p($g(tmpNation),"^",2)
	}
	//手机
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	
	s PAAdmDateTime = ""
	s AdmDateTime = ..GetAdmDateTime(PAAdm)
	s PAAdmDate = $p(AdmDateTime,",",1)  //入院日期
	s PAAdmTime = $p(AdmDateTime,",",2)  //入院时间
	s:(PAAdmDate'="")&&(PAAdmTime'="") PAAdmDateTime = $zd(PAAdmDate,3)_","_$zt(PAAdmTime,3)
	//病区
	s PAAdmWard = ""
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	s:(WardDr '= "") PAAdmWard = $P($g(^PAWARD(WardDr)),"^",2)
	
	s PAAdmRoom = ""  //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	s:(RoomDr '= "") PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)
	s:(BedId '= "") PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)
	s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",2)
	//出院日期时间
	s PADischgeDateTime = ""
	s DisDateTime = ..DisDateTime(PAAdm)
	s PADischgeDate = $p(DisDateTime,",",1)
	s PADischgeTime = $p(DisDateTime,",",2)
	s:(PADischgeDate'="")&&(PADischgeTime'="") PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	//在院状态
	s PAStatusType = "A"
	s:(PADischgeDate = "") PADischgeDateTime = ""
	s:(PADischgeDateTime '= "") PAStatusType = "D"
	
	if (PAStatusType = "A")
	{
		s PAStatusType = "在院"
	}
	elseif (PAStatusType = "D")
	{
		s PAStatusType = "出院"
	}
	//医生
	s PAAdmDoc = ""
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9)
	s:(Doctor '= "") PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	//付费方式
	s PayMode = ""
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmDesc = ""
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s:(pmRowID '= "") pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		s:($f(PayMode,pmDesc) = 0) PayMode = PayMode_pmDesc_" "
	}
	s data = $lb(FlagMRCompletion,FlagFinalAccount,SysCode,CreateDate,CreateTime,FlagFinalAccountDate,FlagFinalAccountTime,FlagMRCompletionDate,FlagMRCompletionTime,FlagFinalAccountUserName,FlagMRCompletionUserName,PAPMIName,PAStatusType,PAAdmType,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
	
DealParamter
	s:(ARegNo = $c(0)) ARegNo = ""
	s:(APatientName = $c(0)) APatientName = ""
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
	s:(AAdmNo = $c(0)) AAdmNo = ""
	q
}

ClassMethod GetEpisodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEpisodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If (ind = "") 
	{				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else
	{				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLEpisodeInfo","GetEpisodeList","^^500308^^")
Query GetEpisodeList(AParam As %String) As %Query(ROWSPEC = "IsCreated:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String")
{
}

ClassMethod GetEpisodeListExecute(ByRef qHandle As %Binary, AParam As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	
	s APatientID = $p(AParam,"^",1)
	s APatientName = $p(AParam,"^",2)
	s APatientName = $zcvt(APatientName,"U")
	s AMedRecordNo = $p(AParam,"^",3)
	s AAdmNo = $p(AParam,"^",4)
	s ARegNo = $p(AParam,"^",5)
	if ($l(AParam,"^") = 7)
	{
		s AStartDate = $p(AParam,"^",6)
		s:(AStartDate '= "") AStartDate = $zdh(AStartDate,3)
		s AEndDate = $p(AParam,"^",7)
		s:(AEndDate '= "") AEndDate = $zdh(AEndDate,3)
	}
	else
	{
		s AStartDate = ""
		s AEndDate = ""
	}
	
	d DealParamter   //处理参数
	
	if (AAdmNo '= "")
	{
		s PAAdm = AAdmNo
		d OutPutRow
	}
	elseif (APatientID '= "")
	{
		s PAPMI = APatientID
		d OutPutPAMI
	}
	elseif (ARegNo '= "")
	{
		s ARegNo = ..AddZero(ARegNo)
		s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PAPMI = "") $$$OK
		d OutPutPAMI
	}
	elseif (AMedRecordNo '= "")
	{
		if (hospitalFlag = "FCYY")
		{
			//b "s"
			s RegNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNoByMedRecordNo(AMedRecordNo)
			s PAPMI = $o(^PAPERi("PAPMI_PatNo",RegNo,""))
			q:(PAPMI = "") $$$OK
			d OutPutPAMI
		}
		else
		{
			s PAPMI = $o(^PAPERi("Medicare1",AMedRecordNo,0))
			q:(PAPMI = "") $$$OK
			d OutPutPAMI
		}
	}
	elseif (APatientName '= "")
	{
		s PAPMI = ""
		for {
			s PAPMI = $O(^PAPERi("PAPER_PatName",APatientName,PAPMI))
			q:(PAPMI = "")
			d OutPutPAMI
		}
	}
	
	Quit $$$OK
	
OutPutPAMI
	s AdmType = ""
	for {
		s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
		q:(AdmType = "")
		s PAAdm = ""
		for {
			s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
			q:(PAAdm = "")
			d OutPutRow
		}
	}
	q
	
OutPutRow
	//检查就诊是否已取消，取消的就诊不显示
	s IsCancel = ..CheckEpisodeCancel(PAAdm)
	q:(IsCancel = "1")
	
	s IsCreated = "N"
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(PAAdm,"DHC")
	if (mrEpisodeID '= "")
	{
		s IsCreated = "Y"
	}
	
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)
	//就诊类型
	if (PAAdmType = "I")
	{
		s PAAdmType = "住院"
	}
	elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}
	elseif PAAdmType = "E"
	{
		s PAAdmType = "急诊"
	}
	//病人姓名
	if (PatientID '= "")
	{
		s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)
		//身份证号
		s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9)
		//登记号
		s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
		
		//出生日期,年龄
		s PAPMIDOB = "" ,PAPMIAge = ""
		s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
		if (DobDate '= "")
		{
			s PAPMIDOB = $ZD(DobDate,3)
			s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
		}
		//性别
		s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)
		s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	}
	//婚姻
	s tmpMarriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
	if (tmpMarriage '= "")
	{
		s Marriage= $p($g(tmpMarriage),"^",3)
	}
	//出生地
	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
	if (tmpNative '= "")
	{
		//出生地城市 
		s CityBirth = $p($g(tmpNative),"!",2)
		s CityBirth = $p($g(CityBirth),"^",2)
		
		//出生地省份 
		s ProvinceBirth = $p($g(tmpNative),"!",1)
		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
	}
	//职业
	s tmpOccupation = ##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
	if (tmpOccupation '= "")
	{
		s Occupation = $p($g(tmpOccupation),"^",2)
	}
	//民族
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	if (tmpNation '= "")
	{
		s Nation = $p($g(tmpNation),"^",2)
	}
	//手机
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	
	s PAAdmDateTime = ""
	s AdmDateTime = ..GetAdmDateTime(PAAdm)
	s PAAdmDate = $p(AdmDateTime,",",1)  //入院日期
	//若存在开始和结束日期，则需判断就诊日期是否在范围内
	if (AStartDate '= "")
	{
		q:(PAAdmDate < AStartDate)
	}
	if (AEndDate '= "")
	{
		q:(PAAdmDate > AEndDate)
	}
	s PAAdmTime = $p(AdmDateTime,",",2)  //入院时间
	s:(PAAdmDate'="")&&(PAAdmTime'="") PAAdmDateTime = $zd(PAAdmDate,3)_","_$zt(PAAdmTime,3)
	
	//病区
	s PAAdmWard = ""
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	s:(WardDr '= "") PAAdmWard = $P($g(^PAWARD(WardDr)),"^",2)
	
	s PAAdmRoom = ""  //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	s:(RoomDr '= "") PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)
	s:(BedId '= "") PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)
	s:(Loc '="") PAAdmLoc = $P($g(^CTLOC(Loc)),"^",2)
	//出院日期时间
	s PADischgeDateTime = ""
	s DisDateTime = ..DisDateTime(PAAdm)
	s PADischgeDate = $p(DisDateTime,",",1)
	s PADischgeTime = $p(DisDateTime,",",2)
	s:(PADischgeDate'="")&&(PADischgeTime'="") PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	//在院状态
	s PAStatusType = "A"
	s:(PADischgeDate = "") PADischgeDateTime = ""
	s:(PADischgeDateTime '= "") PAStatusType = "D"
	
	if (PAStatusType = "A")
	{
		s PAStatusType = "在院"
	}
	elseif (PAStatusType = "D")
	{
		s PAStatusType = "出院"
	}
	//医生
	s PAAdmDoc = ""
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9)
	s:(Doctor '= "") PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	//付费方式
	s PayMode = ""
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		s:($f(PayMode,pmDesc) = 0) PayMode = PayMode_pmDesc_" "
	}
	s data = $lb(IsCreated,PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
	
DealParamter
	s:(APatientID = $c(0)) APatientID = ""
	s:(ARegNo = $c(0)) ARegNo = ""
	s:(APatientName = $c(0)) APatientName = ""
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
	s:(AAdmNo = $c(0)) AAdmNo = ""
	q
}

ClassMethod GetEpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If (ind = "") 
	{				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else
	{				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AddZero(APatientNo As %String) As %String
{
	s patientNo = ""
	s patientNo = $o(^PAPERi("PAPMI_PatNo",patientNo))
	s patientNo = $tr(patientNo, " ")
	s patientNo = $tr(patientNo,$c(10),"")
	s patientNo = $tr(patientNo,$c(13),"")
	s length = $l(patientNo)
	q:(length = $l(APatientNo)) APatientNo
	
	for index=1:1:(length - $l(APatientNo)) {
		s APatientNo = "0"_APatientNo
	}
	q APatientNo
}

/// Desc:根据条件查询病人基本信息列表
/// Creator: Candyxu
/// Create Date：2012-07-27 
/// Modify: yang
/// Modify Date: 2012-10-15
/// Input:	AStartDate 开始日期，
/// 		AStartTime 开始时间，
/// 		AEndDate 结束日期，
/// 		AEndTime 结束时间
///       	AWard 病区ID，
///       	APatientNo 病人登记号，
///       	APatientName 病人姓名
///       	ALocID 科室ID,
///       	AAdmType 就诊类型
/// Output:PAAdmType 就诊类型,PAPMINO 登记号,PAPMIDOB 出生日期,PAPMIAge 年龄,PAPMISex 性别
///       PAAdmDateTime 入院时间,PAAdmWard 病区,PAAdmRoom 病房,PAAdmBed病床,PAAdmLoc就诊科室
///       PADischgeDateTime出院时间,PAAdmDoc医生,PayMode付费类型
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLEpisodeInfo","GetPatientList","^^1853^^2014-8-1^^2014-8-5^^^^^^","^^^^^^^^^^")
Query GetPatientList(AParam As %String, AFilterParam As %String) As %Query(ROWSPEC = "PAADM:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, AParam As %String, AFilterParam As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s APatientNo = $p(AParam,"^",1)
	s APatientName = $p(AParam,"^",2)
	s ALocID = $p(AParam,"^",3)
    s AWard = $p(AParam,"^",4)
	s AStartDate = $p(AParam,"^",5)
	s AStartTime = $p(AParam,"^",6)
	s AEndDate = $p(AParam,"^",7)
	s AEndTime = $p(AParam,"^",8)
	s AOutStartDate = $p(AParam,"^",9)
	s AOutStartTime = $p(AParam,"^",10)
	s AOutEndDate = $p(AParam,"^",11)
	s AOutEndTime = $p(AParam,"^",12)
	s AAdmNo = $p(AParam,"^",13)
	
	s APAStatusType = $p(AFilterParam,"^",1)
	s APAAdmType = $p(AFilterParam,"^",2) 
	s AGender = $p(AFilterParam,"^",3)
	s AAge = $p(AFilterParam,"^",4)
	s ABirthday = $p(AFilterParam,"^",5)
	s AMarriage = $p(AFilterParam,"^",6)  
	s ANation = $p(AFilterParam,"^",7)
	s AMobilePhone = $p(AFilterParam,"^",8)
	s AOccupation = $p(AFilterParam,"^",9) 
	s AProvinceBirth = $p(AFilterParam,"^",10)
	s ACityBirth = $p(AFilterParam,"^",11) 
	s AIdCardNo = $p(AFilterParam,"^",12)
 	
 	d DealParamter   //处理参数
 	
	if (AAdmNo '= ""){
		s count = 0
		for {
			s count = count + 1
			q:(count > 1)
			s PAAdm = AAdmNo
		    continue:(..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime,"in") = "invalid")
		    continue:(..CheckAdmDate(PAAdm,AOutStartDate,AOutEndDate,AOutStartTime,AOutEndTime,"out") = "invalid")
			d OutPutRow 		
		}

	}
 	elseif (APatientNo '= ""){
	 	s APatientNo = ..AddZero(APatientNo)
	 	s PAPMI = $o(^PAPERi("PAPMI_PatNo",APatientNo,""))
	 	q:(PAPMI = "") $$$OK
	 	d OutPutPAMI 
	}
	elseif (APatientName '= ""){ 
		s PAPMI = ""
		for {
		   s PAPMI = $O(^PAPERi("PAPER_PatName",APatientName,PAPMI))
		   q:(PAPMI = "")
		   d OutPutPAMI
	    }	 
	}
	elseif(AWard '= ""){
		s RowID = ""
		for {
			 s RowID = $o(^PAADMi("CurrWard",AWard,RowID))
			 q:(RowID = "")
			 s PAAdm = ""
			 for {
				 s PAAdm = $o(^PAADMi("CurrWard",AWard,RowID,PAAdm))
				 q:(PAAdm = "")
		         continue:(..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime,"in") = "invalid")
		         continue:(..CheckAdmDate(PAAdm,AOutStartDate,AOutEndDate,AOutStartTime,AOutEndTime,"out") = "invalid")
		         d OutPutRow 
			 }
		}		
	}
	else{
		//科室
		if (AStartDate '= "") {s TempDate = AStartDate-1} else {s TempDate = ""}
		for {
			s TempDate = $o(^PAADMi("DepDateTime",ALocID,TempDate))
			q:((TempDate > AEndDate) && (AEndDate '= ""))
			q:(TempDate = "")
			s TempTime = ""
			for {
				s TempTime = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime))
				q:((TempDate = AStartDate)&&(TempTime < AStartTime))
				q:((TempDate = AEndTime)&&(TempDate > AEndTime))
				q:(TempTime = "")
				s PAAdm = ""
				for {
					s PAAdm = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime,PAAdm))
					q:(PAAdm = "")
		       		continue:(..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime,"in") = "invalid")
		         	continue:(..CheckAdmDate(PAAdm,AOutStartDate,AOutEndDate,AOutStartTime,AOutEndTime,"out") = "invalid")
					d OutPutRow
				}
			}
		}
	}
	Quit $$$OK
	
OutPutPAMI
	s AdmType = ""
	for {
	    s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
	    q:(AdmType = "")
	    s PAAdm = ""
	    for {
		     s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
		     q:(PAAdm = "")
			 continue:(..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime,"in") = "invalid")
		     continue:(..CheckAdmDate(PAAdm,AOutStartDate,AOutEndDate,AOutStartTime,AOutEndTime,"out") = "invalid")
		     d OutPutRow
		}
	}
	q
	
OutPutRow
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)   
	//就诊类型
	if ((APAAdmType '= "") && (APAAdmType '= PAAdmType)) q
	if PAAdmType = "I"
	{
		s PAAdmType = "住院"
	}elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}elseif PAAdmType = "E"
	{
		s PAAdmType = "急诊"
	}
	//病人姓名
	s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  
	if ((APatientName '= "") && (APatientName '= PAPMIName)) q
	//身份证号
	s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9) 
	if ((AIdCardNo '= "") && (AIdCardNo '= IdCardNo)) q
	//登记号
	s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1) 

	if ((APatientNo '= "") && ((+APatientNo) '= (+PAPMINO))) q
	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""  
	s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate '= ""
	{
		s PAPMIDOB = $ZD(DobDate,3)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	if ((ABirthday '= "") && (ABirthday '= PAPMIDOB)) q
	if ((AAge '= "") && (AAge '= PAPMIAge)) q 
	//性别
	s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)  
	if ((AGender '= "") && (AGender '= Sex)) q 
	s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	//婚姻
 	s tmpMarriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
 	if tmpMarriage'=""
 	{
	 	s Marriage= $p($g(tmpMarriage),"^",3)
	}
	if ((AMarriage '= "") && (AMarriage '= $p($g(tmpMarriage),"^",2))) q
	//出生地
	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
 	if tmpNative'=""
 	{
   		//出生地城市 
   		s CityBirth = $p($g(tmpNative),"!",2)
   		s CityBirth = $p($g(CityBirth),"^",2)
 
   		//出生地省份 
   		s ProvinceBirth = $p($g(tmpNative),"!",1)
   		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
 	}
 	if ((ACityBirth '= "") && (ACityBirth '= CityBirth)) q
 	if ((AProvinceBirth '= "") && (AProvinceBirth '= ProvinceBirth)) q
 	//职业
 	s tmpOccupation=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
 	i tmpOccupation'=""
 	{
   		s Occupation = $p($g(tmpOccupation),"^",2)
 	}
 	if ((AOccupation '= "") && (AOccupation '= Occupation)) q
	//民族
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	i tmpNation'=""
 	{
   		s Nation = $p($g(tmpNation),"^",2)
 	}
 	if ((ANation '= "") && (ANation '= Nation)) q
 	//手机
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	if ((AMobilePhone '= "") && (AMobilePhone '= MobilePhone)) q
	
	s PAAdmDate = $ZD($P($g(^PAADM(PAAdm)),"^",6),3) //入院日期
	s PAAdmTime = $ZT($P($g(^PAADM(PAAdm)),"^",7),3)  //入院时间
	s PAAdmDateTime = PAAdmDate_","_PAAdmTime
	if (PAAdmDateTime = ",") s PAAdmDateTime = ""
	//病区
	s PAAdmWard = ""  
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	if ((AWard '= "") && (AWard '= WardDr)) q
	if WardDr '= "" s PAAdmWard = $P($g(^PAWARD(WardDr)),"^",1)
	
	s PAAdmRoom = "" //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	if RoomDr '="" s PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)   
	if BedId '= "" s PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""    
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)  
	if ((ALocID '= "") && (ALocID '= Loc)) q	
	s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",1)
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17) 
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
	s PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	//在院状态
	s PAStatusType = "A"
	if (PADischgeDate = "") s PADischgeDateTime = "" 
	if (PADischgeDateTime '= "") s PAStatusType = "D"
	if ((APAStatusType '= "") && (APAStatusType '= PAStatusType)) q
	if (PAStatusType = "A")
	{
		s PAStatusType = "在院"
	}elseif (PAStatusType = "D")
	{
		s PAStatusType = "出院"
	}
	//医生 
	s PAAdmDoc = ""  
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9) 
	//if ((ADoctor '= "") && (ADoctor '= Doctor)) q
	if Doctor '= ""  s PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	//付费方式
	s PayMode = "" 
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		if $f(PayMode,pmDesc) = 0 s PayMode = PayMode_pmDesc_" "
	}
 	s data = $lb(PAAdm,PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
DealParamter
    if ((AStartDate = $c(0)) || (AStartDate = "")) {s AStartDate = ""} else {s AStartDate = $zdh(AStartDate,3)}
    if ((AStartTime = $c(0)) || (AStartTime = "")) {s AStartTime = ""} else {s AStartTime = $zth(AStartTime)}
    if ((AEndDate = $c(0)) || (AEndDate = "")) {s AEndDate = ""} else {s AEndDate = $zdh(AEndDate,3)}
    if ((AEndTime =$c(0)) || (AEndTime = "")) {s AEndTime = ""} else {s AEndTime = $zth(AEndTime)}
    
    if ((AOutStartDate = $c(0)) || (AOutStartDate = "")) {s AOutStartDate = ""} else {s AOutStartDate = $zdh(AOutStartDate,3)}
    if ((AOutStartTime = $c(0)) || (AOutStartTime = "")) {s AOutStartTime = ""} else {s AOutStartTime = $zth(AOutStartTime)}
    if ((AOutEndDate = $c(0)) || (AOutEndDate = "")) {s AOutEndDate = ""} else {s AOutEndDate = $zdh(AOutEndDate,3)}
    if ((AOutEndTime =$c(0)) || (AOutEndTime = "")) {s AOutEndTime = ""} else {s AOutEndTime = $zth(AOutEndTime)}
    
    if AWard = $c(0) s AWard = ""
    if AWard '= ""
    {
       s TempWard = $o(^PAWARD(0,"WARD_LocationDR",AWard,""))
       if TempWard '= "" s AWard = TempWard
    }
    if APatientNo = $c(0) s APatientNo = ""
    if APatientName = $c(0) s APatientName = ""
    if ALocID = $c(0) s ALocID = ""
    if APAStatusType = $c(0) s APAStatusType = ""
    q
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
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

/// Desc:时间是否在查询范围内
/// Creator: Candyxu
/// Create Date:2012-07-27
/// [Previously private]
/// [Previously private]
ClassMethod CheckAdmDate(Adm As %String, DateFrom As %Date, DateTo As %Date, TimeFrom As %Time, TimeTo As %Time, Type As %String) As %Status
{
	s AdmDate = ""
	s AdmTime = ""
	if (Type = "in"){
		s AdmDate = $P($g(^PAADM(Adm)),"^",6)
		s AdmTime = $P($g(^PAADM(Adm)),"^",7)
	}
	else{
		s AdmDate = $P($g(^PAADM(Adm)),"^",17)
		s AdmTime = $P($g(^PAADM(Adm)),"^",18)	
	}

	if (DateFrom '= "")&&(AdmDate < DateFrom) q "invalid" 
	if (TimeFrom '= "")&&(AdmDate = DateFrom)&&(AdmTime < TimeFrom) q "invalid" 
	If (DateTo '= "")&&(AdmDate > DateTo) q "invalid" 
	if (TimeTo '= "")&&(AdmDate = DateTo)&&(AdmTime>TimeTo) q "invalid" 
	//出院日期为空，过滤条件截至日期不为空
	if (Type = "out")&&(DateTo '= "") && (AdmDate = "") q "invalid"
	q "valid"
}

ClassMethod CheckEpisodeCancel(AEpisodeID As %String) As %String
{
	s ret = "0"
	s flag = $p($g(^PAADM(AEpisodeID)),"^",20)
	s:(flag = "c") ret = "1"
	s:(flag = "C") ret = "1"
	q ret
}

/// Desc:	由就诊号获取医嘱号
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetOEOrdItemDR("1")
ClassMethod GetOEOrdItemDR(AEpisodeID As %String) As %String
{
	s ret = ""
	s orderRowid = ""
 	s orderRowid = $o(^OEORD(0,"Adm",AEpisodeID,orderRowid))
 	q:(orderRowid = "") ""
	s itemSub = 0 
	for {
		s itemSub = $o(^OEORD(orderRowid,"I",itemSub)) 
		q:(itemSub = "")
		s oeorditemdr = orderRowid_"||"_itemSub
		if (ret = "")
		{
			s ret = oeorditemdr	
		}
		else
		{
			s ret = ret_"^"_oeorditemdr	
		}
	}
	q ret
}

/// w ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).HasFinalAccount("2")
ClassMethod HasFinalAccount(AEpisodeID As %String) As %String
{
	//b "s"
	s hasBill = "0", billFlag = "1"
	
	s pbRowID = ""
	for {
		//b "s"
		s pbRowID = $O(^DHCPB(0,"ADM",AEpisodeID,pbRowID))
		q:(pbRowID="")
		
		s hasBill = 1
		s flag = $p($g(^DHCPB(pbRowID)),"^",16)
		if (flag '= "P")
		{
			s billFlag = "0"
			quit
		}
	}
	
	q:(hasBill = "1")&&(billFlag="1") "1"
	q "0"
}

/// Desc:	获取患者就诊的死亡日期
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetDeathDate("37")
ClassMethod GetDeathDate(AMREpisodeID As %String) As %String
{
	s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	
	s EpisodeID = objMREpisode.EpisodeID
	s PatientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(EpisodeID)	//why not from MRPatient?
	s AdmDate = objMREpisode.AdmDate
	s AdmTime = objMREpisode.AdmTime   
	s DisDate = objMREpisode.DisDate
	s DisTime = objMREpisode.DisTime
	s MRPatientID=objMREpisode.MRPatientID
	
	if ($e(EpisodeID,1,2) = "VE")
    {
		s DeathDate = objMREpisode.DeathDate   
		s:(DeathDate '= "") DeathDate = $zd(DeathDate,3) 
	}
    else
    {
   		s DeathDateTime = ..DeathDateTime(PatientID)
    	if (DeathDateTime = "")
    	{
			s DeathDate = ""    
		}
		else
		{
			//只有最后一次就诊死亡
			if ((DisDate '= "") && (DisDate < $p(DeathDateTime,",",1)))
			{
				//出院日期小于死亡日期，此次就诊未死亡	
				s DeathDate = ""
			}
			elseif ((DisDate '= "") && (DisDate = $p(DeathDateTime,",",1)))
			{
				//出院日期等于死亡日期，判断此次就诊是否是最后一次就诊	
				s mrEpisodeID = ""
				s lastDisDate = $zd(DisDate,3)
				s lastDisTime = $zt(DisTime,3)
				s tempMREpisodeID = AMREpisodeID
				for {
					s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,mrEpisodeID))
					q:(mrEpisodeID = "")
					s objTemp = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
					if ($zd(objTemp.DisDate,3) > lastDisDate)
					{
						s lastDisDate = $zd(objTemp.DisDate,3)
						s lastDisTime = $zt(objTemp.DisTime,3)
						s tempMREpisodeID = mrEpisodeID
						continue
					}
				
					if (($zd(objTemp.DisDate,3) = lastDisDate) && ($zt(objTemp.DisTime,3) > lastDisTime))
					{
						s lastDisDate = $zd(objTemp.DisDate,3)
						s lastDisTime = $zt(objTemp.DisTime,3)
						s tempMREpisodeID = mrEpisodeID
						continue
					}
				}
				//此次为最后一次就诊
				if (tempMREpisodeID = AMREpisodeID)
				{
					s DeathDate = $zd($p(DeathDateTime,",",1),3)_" "_$zt($p(DeathDateTime,",",2),3)
				}
				else
				{
					s DeathDate = ""
				}
			}
			else
			{
    			s DeathDate = $zd($p(DeathDateTime,",",1),3)_" "_$zt($p(DeathDateTime,",",2),3)
			}
		}
    }
	
	q DeathDate
}

/// Desc: 根据母亲就诊号获取新生儿就诊号
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetChildEpisodeIDByAdm("135")
ClassMethod GetChildEpisodeIDByAdm(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	s childEpisodeID = ""
	for {
		s childEpisodeID = $o(^PAADMi("Mother",AEpisodeID,childEpisodeID))
		q:(childEpisodeID = "")
		s isCancel = ..CheckEpisodeCancel(childEpisodeID)
		continue:(isCancel = "1")
		if (ret = "")
		{
			s ret = childEpisodeID
		}
		else
		{
			s ret = ret_"^"_childEpisodeID
		}
	}
	q ret
}

/// 通过就诊号得到就诊状态
/// AEpisodeID:就诊号   VisitStatus:观察状态
/// output:C:取消   A:在院   D:出院   P:预约   R:Released   N:DNA
/// debug:w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetVisitStatusByEpisode("579")
ClassMethod GetVisitStatusByEpisode(AEpisodeID As %String) As %String
{
	q:(AEpisodeID ="") ""
	s VisitStatus=$P($G(^PAADM(AEpisodeID)),"^",20)
	q VisitStatus
}

/// Desc: 通过就诊号得到就诊信息
/// PAAdm:就诊号   arrFiles:就诊信息队列
/// Output:
/// Hospital:院区
/// PatientID:病人号
/// PAAdmType:就诊类型
/// PAPMIName:患者姓名
/// IdCardNo:身份证号码
/// PAPMINO:登记号
/// PAPMIDOB:出生日期
/// PAPMIAge:年龄
/// PAPMISex:性别
/// Marriage:婚姻
/// CityBirth:出生城市
/// ProvinceBirth:出生省份
/// Occupation:职业
/// Nation:名族
/// MobilePhone:手机号
/// PAAdmDateTime:入院时间日期
/// PAAdmWard:病区
/// PAAdmRoom:病房
/// PAAdmBed:病床
/// PAAdmLocID:科室ID
/// PAAdmLoc:科室描述
/// PADischgeDateTime:出院时间日期
/// PAStatusType:在院状态
/// PAStatusTypeDesc:在院状态描述
/// PayMode:付费方式
/// DeathDate:死亡日期
/// Debug: w ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetEpisodeInfoByPAADM("189")
ClassMethod GetEpisodeInfoByPAADM(PAAdm As %String) As %ArrayOfDataTypes
{
	//先取就诊信息，只跟基础数据表交互一次，提高效能
	s paadmInfo = $g(^PAADM(PAAdm))
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	s Hospital = ""
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	d arrFiles.SetAt(Hospital,"Hospital")
	s PatientID = ""
	s PatientID = $p(paadmInfo,"^",1)
	d arrFiles.SetAt(PatientID,"PatientID")
	//先取病人信息，只跟基础数据表交互一次，提高效能
	s patientInfo = $g(^PAPER(PatientID,"ALL"))
	s PAAdmType =""
	s PAAdmTypeValue = $p(paadmInfo,"^",2)
	d arrFiles.SetAt(PAAdmTypeValue,"PAAdmTypeValue")
	//就诊类型
	if PAAdmTypeValue = "I"
	{
		s PAAdmType = "住院"
	}elseif PAAdmTypeValue = "O"
	{
		s PAAdmType = "门诊"
	}elseif PAAdmTypeValue = "E"
	{
		s PAAdmType = "急诊"
	}
	d arrFiles.SetAt(PAAdmType,"PAAdmType")
	//病人姓名
	s PAPMIName = ""
	s PAPMIName = $p(patientInfo,"^",1)
	d arrFiles.SetAt(PAPMIName,"PAPMIName")
	//身份证号
	s IdCardNo =""
	s IdCardNo = $P(patientInfo,"^",9)
	d arrFiles.SetAt(IdCardNo,"IdCardNo")
	//登记号
	s PAPMINO =""
	s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	d arrFiles.SetAt(PAPMINO,"PAPMINO")

	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""
	s DobDate = $p(patientInfo,"^",6)
	If DobDate '= ""
	{
		s PAPMIDOB = $ZD(DobDate,3)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	d arrFiles.SetAt(PAPMIDOB,"PAPMIDOB")
	d arrFiles.SetAt(PAPMIAge,"PAPMIAge")

	//性别
	s PAPMISex = ""
	s Sex = $P(patientInfo,"^",7)
	s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	d arrFiles.SetAt(PAPMISex,"PAPMISex")
	//婚姻
	s Marriage = ""
	s tmpMarriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
	if tmpMarriage'=""
	{
		s Marriage= $p($g(tmpMarriage),"^",3)
	}
	d arrFiles.SetAt(Marriage,"Marriage")
	//出生地
	s CityBirth =""
	s ProvinceBirth =""
	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
	if tmpNative'=""
	{
		//出生地城市
		s CityBirth = $p($g(tmpNative),"!",2)
		s CityBirth = $p($g(CityBirth),"^",2)
		
		//出生地省份
		s ProvinceBirth = $p($g(tmpNative),"!",1)
		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
	}
	d arrFiles.SetAt(CityBirth,"CityBirth")
	d arrFiles.SetAt(ProvinceBirth,"ProvinceBirth")
	//职业
	s Occupation =""
	s tmpOccupation=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
	i tmpOccupation'=""
	{
		s Occupation = $p($g(tmpOccupation),"^",2)
	}
	d arrFiles.SetAt(Occupation,"Occupation")
	//民族
	s Nation =""
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	i tmpNation'=""
	{
		s Nation = $p($g(tmpNation),"^",2)
	}
	d arrFiles.SetAt(Nation,"Nation")
	//手机
	s MobilePhone =""
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	d arrFiles.SetAt(MobilePhone,"MobilePhone")
	
	s PAAdmDateTime = ""
	s AdmDateTime = ..GetAdmDateTime(PAAdm)
	s PAAdmDate = $p(AdmDateTime,",",1)  //入院日期
	s PAAdmTime = $p(AdmDateTime,",",2)  //入院时间
	s:(PAAdmDate'="")&&(PAAdmTime'="") PAAdmDateTime = $zd(PAAdmDate,3)_","_$zt(PAAdmTime,3)
	d arrFiles.SetAt(PAAdmDateTime,"PAAdmDateTime")
	//病区
	s PAAdmWard = ""
	s WardDr = $P(paadmInfo,"^",70)
	if WardDr '= "" s PAAdmWard = $P($g(^PAWARD(WardDr)),"^",1)
	d arrFiles.SetAt(PAAdmWard,"PAAdmWard")
	s PAAdmRoom = "" //病房
	s RoomDr = $P(paadmInfo,"^",69)
	if RoomDr '="" s PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	d arrFiles.SetAt(PAAdmRoom,"PAAdmRoom")
	s PAAdmBed = ""  //病床
	s BedId = $P(paadmInfo,"^",73)
	if BedId '= "" s PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	d arrFiles.SetAt(PAAdmBed,"PAAdmBed")
	//当前科室
	s PAAdmLoc = ""
	s Loc = ""
	s Loc = $P(paadmInfo,"^",4)
	d arrFiles.SetAt(Loc,"PAAdmLocID")
	s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",1)
	d arrFiles.SetAt(PAAdmLoc,"PAAdmLoc")
	//出院日期时间
	s PADischgeDateTime = ""
	s DisDateTime = ..DisDateTime(PAAdm)
	s PADischgeDate = $p(DisDateTime,",",1)
	s PADischgeTime = $p(DisDateTime,",",2)
	s:(PADischgeDate'="")&&(PADischgeTime'="") PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	d arrFiles.SetAt(PADischgeDateTime,"PADischgeDateTime")
	//在院状态
	s PAStatusType = "A"
	s PAStatusTypeDesc = ""
	if (PADischgeDate = "") s PADischgeDateTime = ""
	if (PADischgeDateTime '= "") s PAStatusType = "D"
	if (PAStatusType = "A")
	{
		s PAStatusTypeDesc = "在院"
	}elseif (PAStatusType = "D")
	{
		s PAStatusTypeDesc = "出院"
	}
	d arrFiles.SetAt(PAStatusType,"PAStatusType")
	d arrFiles.SetAt(PAStatusTypeDesc,"PAStatusTypeDesc")
	//医生
	s PAAdmDoc = ""
	s Doctor = $P(paadmInfo,"^",9)
	//if ((ADoctor '= "") && (ADoctor '= Doctor)) q
	if Doctor '= ""  s PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	d arrFiles.SetAt(PAAdmDoc,"PAAdmDoc")
	//付费方式
	s PayMode = ""
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmDesc = ""
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s:(pmRowID '= "") pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		if $f(PayMode,pmDesc) = 0 s PayMode = PayMode_pmDesc_" "
	}
	d arrFiles.SetAt(PayMode,"PayMode")
	//死亡日期
	s DeathDate = ""
	s DeathDate = $p(patientInfo,"^",13)
	s:(DeathDate '= "") DeathDate = $zd(DeathDate,3)
	d arrFiles.SetAt(DeathDate,"DeathDate")
	q arrFiles
}

/// Desc: 根据住院就诊号获取关联门诊就诊号
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetOPEpisodeIDByIP("521")
ClassMethod GetOPEpisodeIDByIP(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "")
	{
	}
	else  //默认通过住院证关联
	{
		s ipBookID = ""
		f {
			s ipBookID = $o(^DHCDocIPBK(0,"EpisodeIDTo",AEpisodeID,ipBookID))
			q:(ipBookID = "")
			s ret = $p($g(^DHCDocIPBK(ipBookID)),"^",2)
		}
	}	
	q ret
}

/// Desc: 武汉普仁 根据出院科室和日期查询患者信息
/// Input:DisLocID
/// Debug: d ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLEpisodeInfo","GetPatInfoByDisLocID","2020-12-01","2020-12-23","162")
Query GetPatInfoByDisLocID(AStartDate As %String, AEndDate As %String, ADisLocID As %String) As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,AdmDateTime:%String,DisDateTime:%String,DischgrgeLoc:%String,MainDoctorInitials:%String,MainDoctor:%String,ScanDateTime:%String,ScanUserName:%String,TotalPages:%String,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,c35,c36,c37,c38,c39,c40")
{
}

ClassMethod GetPatInfoByDisLocIDExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ADisLocID As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    s:(AStartDate '="") AStartDate = $zdh(AStartDate,3)
	s:(AEndDate '="") AEndDate = $zdh(AEndDate,3)
	s:(ADisLocID=$c(0)) ADisLocID=""
	
	//获取所有扫描项目的itemID
	s scanItemID = ""
	s typeParams = " 0"
	//维护的扫描分类项太多，只取默认的扫描分类方案项目
	/*for
	{
		s typeParams= $o(^DHCEPRFS.META.MRItemI("IdxType"," PS",typeParams))
		q:typeParams=""
		s itemid = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType("PS",$P(typeParams," ",2))
		//B ;1
		s itemObj = ##class(DHCEPRFS.META.MRItem).%OpenId(itemid)
		continue:itemObj=""
		s description = itemObj.Description
		s itemInfo = itemid_"#"_description
		s scanItemID=scanItemID_"^"_itemInfo
			
	}*/
	s scanItemID=##class(DHCEPRFS.BL.BLPrintScheme).GetDefaultScanArrange()
	if (ADisLocID '="")
	{
		s MREpisodeID =""
		for
		{
			s MREpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxDisLocID"," "_ADisLocID,MREpisodeID))
			q:MREpisodeID=""
			
			//剔除未扫描的
			s flagAction = "SCAN"
			s LogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_MREpisodeID,""))
			continue:(LogID = "")
			s DetailID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",LogID," "_flagAction,""),-1)
			continue:(DetailID = "")
			
			s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
			continue:('$ISOBJECT(objMREpisode))
			s MRPatientID = objMREpisode.MRPatientID
			s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
			continue:('$ISOBJECT(objMRPatient))
			s flag = $$GetEpisodeInfo()
			continue:flag="0"
			
		}
	}else
	{
		for disDate = AStartDate-1:1:AEndDate
		{
			s MRPatientID = ""
			for
			{
				s MRPatientID = $O(^DHCEPRFS.INST.MREpisodeI("IdxDisDate",disDate,MRPatientID))
				q:MRPatientID="" 
				//b ;1
				continue:MRPatientID=""
				s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId($p(MRPatientID," ",2))
				continue:('$ISOBJECT(objMRPatient))
			
				s MREpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxDisDate",disDate,MRPatientID,""))
				continue:MREpisodeID=""
				//b ;2
				s isScan = ##class(DHCEPRFS.BL.BLMRLog).CheckAction(MREpisodeID,"SCAN")
				continue:'isScan
				s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
				continue:('$ISOBJECT(objMREpisode))
				//b ;3
				s flag = $$GetEpisodeInfo()
				continue:flag="0"
			}
			
		} 
	}
    q $$$OK
GetEpisodeInfo()
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetScanItemsByMREpisodeID")
	s sc = result.Execute(MREpisodeID)	
	s totalPages = 0
	While (result.Next())
	{
		s totalPages = totalPages + $g(result.Data("Pages"))
	}
	
	//获得扫描日期和操作员	
	s Scan = ##class(DHCEPRFS.BL.BLMRLog).GetScanData(MREpisodeID)
	s ScanerName = $p(Scan,"^",1)
	s ScanDate = $p(Scan,"^",2)
	s ScanTime = $p(Scan,"^",3)
	s ScanDateTime = ScanDate_" "_ScanTime
	
	s medRecordNo = objMREpisode.MedRecordNo
	s name = objMRPatient.Name
	s admDateTime = objMREpisode.AdmDate
	s disDateTime = objMREpisode.DisDate
	q:((disDateTime = "")||(disDateTime < AStartDate)||(disDateTime> AEndDate)) "0"
	s disLoc = objMREpisode.DisLoc
	s mainDoc = objMREpisode.MainDoctor
	s mainDocInitials = $P($g(^CTPCP(objMREpisode.MainDoctorID,1)),"^",1)

	s data = $lb(MRPatientID,MREpisodeID,medRecordNo,name,$zd(admDateTime,3),$zd(disDateTime,3),disLoc,mainDocInitials,mainDoc,ScanDateTime,ScanerName,totalPages)
	s scanData = ..GetResult(scanItemID,MREpisodeID)
	s ^CacheTemp(repid,ind) = data_scanData 
	s ind = ind + 1
	q "1"
}

ClassMethod GetPatInfoByDisLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChildEpisodeIDByMomIDExecute ]
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

ClassMethod GetPatInfoByDisLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChildEpisodeIDByMomIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:获得扫描项页数查询结果
/// Creator：Candy
/// Input：AResult 扫描项目ID的字符串,AMrEpisodeID：就诊号
/// Output：值列表
/// w ##Class(DHCEPRFS.BL.BLQuery).GetResult(^TempCandy,1)
ClassMethod GetResult(AResult As %String, AMrEpisodeID As %String) As %List
{
	s resultValue = ""	
    s count = $l(AResult,"^")
    //为了分隔就诊信息和动态扫描分类项
    s resultValue = $lb("^")
    //为了获取到扫描分类项
    s resultValue = resultValue_$lb(AResult)
    for i = 2:1:count
    {
   	    s tmp = $p($p(AResult,"^",i),"#",1)
		//b ;3
	    s value = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetScanPagesByItemID(tmp,AMrEpisodeID)
    	s resultValue = resultValue_value
    }
    //s resultValue =resultValue_$lb("^")
   	q resultValue
}

/// Desc:根据MRItemID和MrEpisodeID获取扫描项目的页数
/// Creator:Candy
/// Input:item:取值方法名, AMrEpisodeID:就诊ID
/// Output：结果值
/// w ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetScanPagesByItemID
ClassMethod GetScanPagesByItemID(MRItemID As %String, AMREpisdoeID As %String) As %List
{
	q:MRItemID="" 
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisdoeID)
	s MRVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMREpisdoeID,"0")
 	q:(MRVersionID = "") ""
 	s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(MRItemID)
 	s mrItemName = objMRItem.Name
	s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_MRVersionID, " "_MRItemID, ""))
	//b ;mrVerItemID
	s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
	if (objMRVerItem ="")
	{
		s pages = 0
	}
	else
	{
		s pages = objMRVerItem.TotCount	
	}
	//b ;2
	//q $lb(MRItemID_"#"_mrItemName_"#"_pages)
	q $lb(pages)
}

}
