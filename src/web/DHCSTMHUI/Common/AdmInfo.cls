Import sqluser

/// Descript:	公共取患者、医嘱相关数据类
/// Creator:	wxj
/// CreateDate:	2022-10-13
Class web.DHCSTMHUI.Common.AdmInfo Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	获取患者基本信息
/// Creator:	wxj
/// CreateDate:	2022-10-13
/// Table:		PA_PatMas,PA_PatMas
/// Input:		就诊ID
/// Return：	患者基本信息
/// d ##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(10)
ClassMethod GetPatientInfoByAdm(Adm)
{
	n (Adm)
	s PatObj={}
	s PatId=$p(^PAADM(Adm),"^",1)
	q:PatId="" PatObj
	s AdmType=$p(^PAADM(Adm),"^",2)
	s MrAdmId=$p(^PAADM(Adm),"^",61)
	s HospId=##class(web.DHCSTMHUI.Common.ServiceCommon).GetHospIdByAdm(Adm)	
	s PatAge=##class(web.DHCSTMHUI.Common.ServiceCommon).GetPapmiAge(PatId,Adm,HospId)
	
	s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	s PatDOB=$p(^PAPER(PatId,"ALL"),"^",6)
	s PatSexId=$p(^PAPER(PatId,"ALL"),"^",7)
	
	s PatCompany=$p(^PAPER(PatId,"PER",4),"^",18)
	s PatPhone=$p(^PAPER(PatId,"PER",1),"^",11)
	s PatAddress=$p($g(^PAPER(PatId,"PER",4)),"^",18)
	s PatNationId=$p($g(^PAPER(PatId,"PER",2)),"^",1)
	
	s PatNo=$p(^PAPER(PatId,"PAT",1),"^",2)
	s PatDVANumber=$p(^PAPER(PatId,"PAT",3),"^",6)
	
	s CfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatId,""),-1)
	s PatCardNo=$S(CfRowId'="":$p($g(^DHCCARD("CF",CfRowId)),"^",2),1:"")
	
	s (PatSex,PatNation,PatHeight,PatWeight)=""
	s:PatSexId'="" PatSex=$p(^CT("SEX",PatSexId),"^",2)
	s:PatNationId'="" PatNation=$p($g(^CT("NAT",PatNationId)),"^",2)	
	i MrAdmId'="" d
	.s PatHeight=$p(^MR(MrAdmId,"PRO",1),"^",20)
	.s:PatHeight'="" PatHeight=PatHeight_"cm"
	.s PatWeight=$p(^MR(MrAdmId,"PRO",1),"^",27)
	.s:PatWeight'="" PatWeight=PatWeight_"kg"
	s MrNo=##class(web.DHCSTMHUI.Common.ServiceCommon).GetMrNoByPatientID(PatId,AdmType)
	
	s PatObj.PatId=PatId				//ID
	s PatObj.PatName=PatName			//名字
	s PatObj.PatNo=PatNo				//登记号
	s PatObj.PatAge=PatAge				//年龄
	s PatObj.PatSex=PatSex				//性别
	s PatObj.PatCompany=PatCompany		//单位
	s PatObj.PatPhone=PatPhone			//电话
	s PatObj.PatAddress=PatAddress		//地址
	s PatObj.PatNation=PatNation		//民族
	s PatObj.PatCardNo=PatCardNo		//卡号
	s PatObj.PatHeight=PatHeight		//身高
	s PatObj.PatWeight=PatWeight		//体重
	s PatObj.AdmType=AdmType			//就诊类型
	s PatObj.MrNo=MrNo					//病案号
	s PatObj.PatDVANumber=PatDVANumber	//身份证号
	s PatObj.PatDOB=PatDOB				//出生日期
	
	q PatObj
}

/// Descript:	获取患者就诊记录相关信息
/// Creator:	wxj
/// CreateDate:	2022-10-13
/// Table:		PA_Adm
/// Input:		就诊ID
/// Return：	就诊信息
/// d ##class(web.DHCSTMHUI.Common.AdmInfo).GetAdmInfo(10)
ClassMethod GetAdmInfo(Adm)
{
	n (Adm)
	s AdmObj={}
	s AdmNo=$p(^PAADM(Adm),"^",81)
	s Papmi=$p(^PAADM(Adm),"^",1)
	s AdmType=$p(^PAADM(Adm),"^",2)
	s AdmDate=$p(^PAADM(Adm),"^",6)
	s AdmTime=$p(^PAADM(Adm),"^",7)
	s AdmLocId=$p(^PAADM(Adm),"^",4)
	s AdmDocDR=$p(^PAADM(Adm),"^",9)
	s WardId=$p($g(^PAADM(Adm)),"^",70)
	s BedId=$p($g(^PAADM(Adm)),"^",73)
	s:AdmDate'="" AdmDate=..DL2H(AdmDate)
	s:AdmTime'="" AdmTime=..TL2H(AdmTime)
	s (AdmLocDesc,PatDocName,WardDesc,BedNo)=""
	s:AdmLocId'="" AdmLocDesc=$p($g(^CTLOC(AdmLocId)),"^",2)
	s:AdmDocDR'="" PatDocName=$p($g(^CTPCP(AdmDocDR,1)),"^",2)
	s:WardId'="" WardDesc=$p($g(^PAWARD(WardId)),"^",2)
	s:BedId'="" BedNo=$p($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1) 
	s MrNo=##class(web.DHCSTMHUI.Common.ServiceCommon).GetMrNoByPatientID(Papmi,AdmType)
	s DiagDesc=..GetMRDiagnosDesc(Adm,",")
	
	s AdmObj.DiagDesc=DiagDesc		;诊断
	s AdmObj.AdmNo=AdmNo			;就诊号
	s AdmObj.Papmi=Papmi			;PA_PatMas患者信息表ID
	s AdmObj.AdmType=AdmType		;就诊类型:O-门诊;I-住院;E-急诊;H-体检
	s AdmObj.AdmDate=AdmDate		;就诊日期
	s AdmObj.AdmTime=AdmTime		;就诊时间
	s AdmObj.AdmLocDesc=AdmLocDesc	;就诊科室
	s AdmObj.PatDocName=PatDocName	;就诊医生
	s AdmObj.WardDesc=WardDesc		;入院病区
	s AdmObj.BedNo=BedNo			;床位号
	s AdmObj.MrNo=MrNo				;病案号
	q AdmObj
}

/// description: 获取医嘱明细信息
/// d ##class(web.DHCSTMHUI.Common.AdmInfo).GetOeoriData("483||1")
ClassMethod GetOeoriData(Oeori) As %Library.DynamicObject
{
	n (Oeori)
	s OeoriObj={}
	
	s Doctor="",PrtNo="",BillType=""
	s FreqDesc=$p(##class(web.DHCSTMHUI.Common.OrderInfo).OeoriFreq(Oeori),"^",4)		//医嘱频次
	s InstrucDesc=$p(##class(web.DHCSTMHUI.Common.OrderInfo).OeoriInstruc(Oeori),"^",2)	//医嘱用法
	s DuraDesc=$p(##class(web.DHCSTMHUI.Common.OrderInfo).OeoriDuration(Oeori),"^",2)	//医嘱疗程
	s Dosage=##class(web.DHCSTMHUI.Common.OrderInfo).OeoriDosage(Oeori)	//医嘱剂量
	s Remark=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),2)),"^",8)
	i Remark="" s Remark=##class(web.DHCSTMHUI.Common.OrderInfo).OeoriRemark(Oeori)		//医嘱备注
	s StatCode=$p(##class(web.DHCSTMHUI.Common.OrderInfo).OeoriStat(Oeori),"^",1)		//医嘱状态
	s OrdDate=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),3)),"^",7)
	s:OrdDate'="" OrdDate=..DL2H(OrdDate)
	s OrdTime=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1)),"^",17)
	s:OrdTime'="" OrdTime=..TL2H(OrdTime)
	s PrescNo=$p(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1),"^",14)	//处方号
	s Preason=$p(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),11),"^",18)
	s:+Preason'=0 BillType=$p(^PAC("ADMREA",Preason),"^",2)
	s PrtId=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
	s:PrtId'="" PrtNo=$p(^DHCINVPRT(PrtId),"^",14)
	s DoctorId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),7)),"^",1)
	i DoctorId'="" s Doctor=$p($g(^SSU("SSUSR",DoctorId)),"^",2)
	
	s OeoriObj.FreqDesc=FreqDesc		//医嘱频次
	s OeoriObj.InstrucDesc=InstrucDesc	//医嘱用法
	s OeoriObj.DuraDesc=DuraDesc		//医嘱疗程
	s OeoriObj.Dosage=Dosage			//医嘱剂量
	s OeoriObj.Remark=Remark			//医嘱备注
	s OeoriObj.StatCode=StatCode		//医嘱状态
	s OeoriObj.OrdDate=OrdDate			//医嘱日期
	s OeoriObj.OrdTime=OrdTime			//医嘱时间
	s OeoriObj.PrescNo=PrescNo			//处方号
	s OeoriObj.BillType=BillType		//计费类型(医保/自费)
	s OeoriObj.PrtNo=PrtNo				//账单号
	s OeoriObj.DoctorId=DoctorId		//医生Id
	s OeoriObj.Doctor=Doctor			//医生
	
	q OeoriObj
}

/// 取诊断
/// Type(GX-西药,GZ-中药,GC-草药)
ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String, Type As %String = "") As %String
{
	 n (MRAdmRowid,DelimStr,Type)
	 q:MRAdmRowid="" ""
	 s MRAdmRowid=$p(^PAADM(MRAdmRowid),"^",61)
	 q:MRAdmRowid="" ""
	 s retval=""
	 s i=0
	 s obj = ##class(%Library.ResultSet).%New()
	 s sqlStr = "SELECT MRDIA_RowID as ID, MRDIA_MRADM_ParRef, MRDIA_ICDCode_DR, MRDIA_ICDCode_DR->MRCID_Desc as MRDIAICDCodeDRDesc, MRDIA_ICDCode_DR->MRCID_Code as MRDIAICDCodeDRCode, MRDIA_Desc FROM SQLUser.MR_Diagnos WHERE MRDIA_MRADM_ParRef ="_MRAdmRowid
	 d obj.Prepare(sqlStr)
	 s obj.RuntimeMode=0
	 d obj.Execute()
	 While(obj.Next())
	{
	 s Desc=obj.Data("MRDIAICDCodeDRDesc")
	 s Rowid=obj.Data("ID")
	 s CodeRowid=obj.Data("MRDIA_ICDCode_DR")
	 s MRDesc=obj.Data("MRDIA_Desc")
	 s ZYZDFlag=$p($g(^MRC("ID",+CodeRowid)),"^",15) //中医诊断标志
	 q:(Type="GC")&&(ZYZDFlag'="Y") ;取中医诊断,过滤非中医诊断
	 q:(Type="GX")&&(ZYZDFlag="Y")  ;取西医诊断,过滤中医诊断
	 if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	 i Desc="" s Desc=MRDesc
	 e  d
	 .i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	 s i=i+1
	 s Desc=i_"."_Desc
	 if retval="" s retval=Desc
	 e  s retval=retval_DelimStr_Desc
	}
	 q retval
}

}
