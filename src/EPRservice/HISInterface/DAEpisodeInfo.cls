Class EPRservice.HISInterface.DAEpisodeInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	患者指针，登记rowid
ClassMethod GetPapmiDR(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s retValue = ""
	s retValue = $P($g(^PAADM(AEpisodeID)),"^",1)
	q:(retValue '= "") retValue

	//华西医院：global节点中的数据丢失，但sql语句可以查询出数据
	&sql(select PAADM_PAPMI_DR into :retValue from SQLUser.PA_Adm where PAADM_RowId = :AEpisodeID)
	q retValue
}

/// Desc:	就诊号
ClassMethod GetAdmNo(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	q $P($g(^PAADM(AEpisodeID)),"^",81)
}

/// Desc:	就诊类型
ClassMethod GetAdmType(AEpisodeID As %String) As %String
{
	q $P($g(^PAADM(AEpisodeID)),"^",2)
}

/// Desc:	入院日期时间
/// Table：	PA_Adm.PAADM_AdmDate，PA_Adm.PAADM_AdmTime
ClassMethod GetAdmDateTime(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s dateTime = ""
	
	s date = $P($G(^PAADM(AEpisodeID)),"^",6)
	s time = $P($G(^PAADM(AEpisodeID)),"^",7)
	if (date '= "")&&(date '= "") 
	{
		s dateTime = date_","_time
	}
	
	q dateTime
}

/// Desc:	入院科室
ClassMethod GetAdmDept(AEpisodeID As %String) As %String
{
	s deptDR = "", dept = ""
	
	s childSub = ""
	for {
		s childSub = $o(^PAADM(AEpisodeID,"TRANS",childSub)) 
		q:(childSub = "")
		
		s tmpDeptDR = $p($g(^PAADM(AEpisodeID,"TRANS",childSub)),"^",6)
		if (tmpDeptDR '= "") {s deptDR = tmpDeptDR}
		
		s bed = $p($g(^PAADM(AEpisodeID,"TRANS",childSub)),"^",8)
		q:(bed '= "")
	}
	
	if (deptDR '= "")
	{	
		s DeptCode=$p($g(^CTLOC(deptDR)),"^",1)
		s DeptDesc=$p($g(^CTLOC(deptDR)),"^",2)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s dept = deptDR_"^"_DeptCode_"^"_DeptDesc		
	}
	
	q dept
}

/// Desc:	入院病区
ClassMethod GetAdmWard(AEpisodeID As %String) As %String
{
	s wardDR = "", ward = ""
	
	s childSub = ""
	for {
		s childSub = $o(^PAADM(AEpisodeID,"TRANS",childSub)) 
		q:(childSub = "")
		
		s tmpWardDR = $p($g(^PAADM(AEpisodeID,"TRANS",childSub)),"^",9)
		if (tmpWardDR '= "") {s wardDR = tmpWardDR}
		
		s bed = $p($g(^PAADM(AEpisodeID,"TRANS",childSub)),"^",8)
		q:(bed '= "")
	}
	
	if (wardDR '= "")
	{	
		s DeptCode=$p($g(^PAWARD(wardDR)),"^",1)
		s WardDesc=$p($g(^PAWARD(wardDR)),"^",2)
		if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
		s ward = wardDR_"^"_DeptCode_"^"_WardDesc		
	}
	
	q ward
}

/// Desc:	出院日期时间
ClassMethod GetDisDateTime(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
		
	s date=$P($G(^PAADM(AEpisodeID)),"^",17)
	s time=$P($G(^PAADM(AEpisodeID)),"^",18)
	
	s disDateTime = date_","_time
	q disDateTime
}

/// Desc:	当前病区 = 出院病区
ClassMethod GetCurrentWard(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	
	s disWardDR=$P($g(^PAADM(AEpisodeID)),"^",70)
	q:(disWardDR = "") ""
	
	s code =$p($g(^PAWARD(disWardDR)),"^",1)
	s desc =$p($g(^PAWARD(disWardDR)),"^",2)
	if $l(desc,"-")>1 {s desc=$p($g(desc),"-",2)}
	
	q disWardDR_"^"_code_"^"_desc
}

/// Desc:	当前科室 = 出院科室
ClassMethod GetCurrentDept(AEpisodeID As %String) As %String
{
	q:($d(AEpisodeID)=0)||(AEpisodeID="") ""
	
	s disDeptDR=$P($g(^PAADM(AEpisodeID)),"^",4)
	q:(disDeptDR = "") ""
	 
	s code = $p($g(^CTLOC(disDeptDR)),"^",1)
	s desc = $p($g(^CTLOC(disDeptDR)),"^",2)
	if $l(desc,"-")>1 {s desc=$p($g(desc),"-",2)}
	
	q disDeptDR_"^"_code_"^"_desc
}

/// Desc:	主管医生
ClassMethod GetMainDoc(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s docDR = $P($G(^PAADM(AEpisodeID)),"^",9)
	q:(docDR="") ""
	
	s docCode=$p($g(^CTPCP(docDR,1)),"^",1)
	s docName=$p($g(^CTPCP(docDR,1)),"^",2)
	s mainDoc=docDR_"^"_docCode_"^"_docName
	
	q mainDoc
}

/// modify  YHY  2014-01-03
/// Desc:	当前病房
ClassMethod GetCurrentRoom(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	s PAADMBedDR = ""
	
	s PAADMBedDR = $p($g(^PAADM(AEpisodeID)),"^",73)
	q:(PAADMBedDR="") ""
    s WARDRowID = $p(PAADMBedDR,"||",1)
	s BEDChildsub = $p(PAADMBedDR,"||",2)
	s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
	s PAAdmWard = $p($g(^PAROOM(BEDRoomDR)),"^",2)
	q PAAdmWard
}

/// Desc:	当前床位
/// w ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentBed("41")
ClassMethod GetCurrentBed(AEpisodeID As %String) As %String
{
	/*
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	s bedDR = $P($g(^PAADM(AEpisodeID)),"^",73)
	q:(bedDR = "") ""
	//待续
	s code =$p($g(^PAROOM(bedDR)),"^",1)
	s desc =$p($g(^PAROOM(bedDR)),"^",2)
	if $l(desc,"-")>1 {s desc=$p($g(desc),"-",2)}
	q bedDR_"^"_code_"^"_desc
	*/
	// modify by niucaicai 2014-04-08
	q:($d(AEpisodeID)=0)||(AEpisodeID="") ""
	s bedwordrowid="",bedchildsub=""
	s bedDR="",dischgbedno=""

    q:(($d(^PAADM(AEpisodeID))'=1)&&($d(^PAADM(AEpisodeID))'=11)) ""
    
	s bedDR=$p($g(^PAADM(AEpisodeID)),"^",73)
	
	q:($d(bedDR)=0)||(bedDR="")||($l(bedDR,"||")<2) ""
	s bedwordrowid = $p(bedDR,"||",1)
	s bedchildsub = $p(bedDR,"||",2)
	
    q:($d(^PAWARD(bedwordrowid,"BED"))'=10) ""
    
	s dischgbedno = $p($g(^PAWARD(bedwordrowid,"BED",bedchildsub)),"^",1)

 	q bedDR_"^"_""_"^"_dischgbedno
}

/// w ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDiagnos("41")
/// Desc: 诊断信息，诊断的优先原则为：住院患者——出院诊断>主要诊断>入院诊断>门急诊诊断；门诊患者——可能没有前面三个，然后查门急诊诊断；
/// Input: argAdmId: 就诊rowid
/// Return: RowId^诊断代码^诊断描述
ClassMethod GetDiagnos(argAdmId As %String) As %String
{
	q:(argAdmId="") ""
	
	s retDiagnos = ""
	s diagnosID = ""
	
	//出院诊断
	s disDiagTypeID = $O(^MRC("DTYP",0,"Code","DIS",""))  
	if (disDiagTypeID '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, disDiagTypeID)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	
	//主要诊断
	s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	if (mainDiagTypeId '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, mainDiagTypeId)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	
	//入院诊断
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","PRE",""))
	s tmpid = $O(^MRC("DTYP",0,"Code","C008",""))
	if (tmpid '= "")
	{
		if admDiagTypeId = ""
		{	s admDiagTypeId = tmpid}
		else
		{	s admDiagTypeId = admDiagTypeId_"^"_tmpid}
	}
	if (admDiagTypeId '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, admDiagTypeId)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	
	//门(急)诊诊断   门急诊患者使用
	s MRAdmRowid=$p($g(^PAADM(argAdmId)),"^",61)
 
 	s MRDiagnoseDesc=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmRowid,"^")
 	s MRDLength=$Length(MRDiagnoseDesc,"^")
 	s MRDiagnoseDesc=$P(MRDiagnoseDesc,"^",MRDLength)
 	if (MRDiagnoseDesc '= "")
 	{
	 	s retDiagnos = MRDiagnoseDesc_"^"_MRDiagnoseDesc_"^"_MRDiagnoseDesc
	} 
	
	q retDiagnos
}

ClassMethod GetDiagnote(AEpisodeID)
{
	s diagNoteDesc = ##Class(web.DHCMRDiagnos).GetDiagDescByadm(AEpisodeID)
	q diagNoteDesc
}

/// Desc:	取指定类型的诊断ID
ClassMethod GetTypedDiagnosID(argEpisodeID As %String, argMRCDiagnosTypeID As %String) As %String
{
	q:(argMRCDiagnosTypeID = "") ""
	
	s ret = ""
	
	s mrAdmDR = $p($g(^PAADM(argEpisodeID)),"^",61)
	q:(mrAdmDR = "") ""
	
	s mrcDiagnosTypeIDString = "^"_argMRCDiagnosTypeID_"^"
	
	s mrDiaChildsub = "0"
	for {
		s mrDiaChildsub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub))
		q:(mrDiaChildsub="")
		
		s typeChildSub = 0
		for {
			s typeChildSub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub))
			q:(typeChildSub = "")
			
			s mrcDiagTypID = $p($g(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub)),"^",1)
			continue:(mrcDiagTypID = "")
			
			//判断是否为待选诊断类型
			continue:('$f(mrcDiagnosTypeIDString, "^"_mrcDiagTypID_"^"))
			
			s mrDiagnosID = mrAdmDR_"||"_mrDiaChildsub
			if ret = ""
			{	s ret = mrDiagnosID}
			else
			{	s ret = ret_"^"_mrDiagnosID}	
		}
	}
	q ret
}

/// 	Desc:	取诊断信息
/// 	Input:	argMRDiagnosID : MR_Adm.MRADM_RowId||MR_Diagnos.MRDIA_Childsub
/// 	Return：RowId^诊断代码^诊断描述(诊断备注)
ClassMethod GetDiagnosWithNote(argMRDiagnosID) As %String
{
	s mrAdmID = $P(argMRDiagnosID, "||", 1)
	s mrDiaChildSub = $P(argMRDiagnosID, "||", 2)
	q:(mrAdmID = "")||(mrDiaChildSub = "") ""
	
	s icdid = $p($g(^MR(mrAdmID,"DIA",mrDiaChildSub)),"^",1)
	q:(icdid = "") ""
	
	s icdCode = $p($g(^MRC("ID",icdid)),"^",4)
	s icdDesc = $p($g(^MRC("ID",icdid)),"^",2)
	
	s diagNote=$g(^MR(mrAdmID,"DIA",mrDiaChildSub,"DES",1))
	//s diagNote=$g(^MR(mrAdmID,"DIA",mrDiaChildSub,"DES"))
	if (diagNote '= "") 
	{	s icdDesc = icdDesc_"("_diagNote_")"}	
	
	q icdid_"^"_icdCode_"^"_icdDesc
}

/// Desc:	初诊/复诊/术后复诊
/// w ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetVisitagien("41")
ClassMethod GetVisitagien(AEpisodeID As %String) As %String
{
	s admstatus = $P(^PAADM(AEpisodeID),"^",40)
	if (admstatus = "Admission")
	{
		s admstatus = "初诊"
	}
	elseif (admstatus = "Readmission")
	{
		s admstatus = "复诊"
	}
	elseif (admstatus = "OpReadmission")
	{
		s admstatus = "术后复诊"
	}
	q admstatus
}

/// Desc:	是否下过传染病诊断
/// w ##Class(EPRservice.HISInterface.DAEpisodeInfo).IsDiagnosToEpd("41")
ClassMethod IsDiagnosToEpd(AEpisodeID As %String) As %String
{
	s IsDiagnosToEpd = "0"
	q:(AEpisodeID = "") IsDiagnosToEpd
	s flag = ##class(%Dictionary.ClassDefinition).%ExistsId("web.LTTTest")
	if (flag = 1)
	{
		s ret = ##class(web.LTTTest).CheckDiagnosToEpd(AEpisodeID)
		if (ret = "1")
		{
			s IsDiagnosToEpd = "1"
		}
	}
	
	q IsDiagnosToEpd
	
	/*
	//##class(web.LTTTest).CheckDiagnosToEpd(AEpisodeID)方法对应的取值代码
	Set return=""
	Quit:aEpisodeID="" return
	
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	Set Age=0
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	Set:BirthDay'="" Age=((+$h)-BirthDay)\365
	Set DiagnosDescList="",CtlRstList=""
	Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)
	
	//ICD或关键字监控是否传染病
	Set DiagnosID=$o(^MR(MRAdm,"DIA",""),-1)
	Quit:(+DiagnosID=0) return
	Set tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
	Set ICDDxID=$p(tmpDiagnos,"^",1)
	Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",DiagnosID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",DiagnosID,"DHC",1))
	Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
	Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
	Set IFRowID=0
	For {
		Set IFRowID=$o(^DHCMed.EPDC("IF",IFRowID))
		Quit:IFRowID=""
		Continue:$listfind(CtlRstList,IFRowID)>0
		Set IFICD=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",1)

		//1通过传染病诊断ICD检索是否传染病
		Set:ICD10=IFICD CtlRstList=CtlRstList_$lb(IFRowID)
		//2通过关键字检索是否传染病(检索关键字维护在别名表中,类型为1)
		Set IFAliasID=""
		For {
			Set IFAliasID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID))
			Quit:IFAliasID=""
			Quit:$listfind(CtlRstList,IFRowID)>0
			Set IFAlias=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",1)
			Set IsKeyAlias=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",2)
			Continue:IsKeyAlias'=1  //关键词检索
			//**************************************************
			//update by zf 2011-09-27
			Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IFAlias,"T"))
			Set IFAlias3ID=0,IsAlias3="Y"
			For {
				Set IFAlias3ID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID))
				Quit:IFAlias3ID=""
				Quit:$listfind(CtlRstList,IFRowID)>0
				Set IFAlias3=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID)),"^",1)
				Set IsKeyAlias3=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID)),"^",2)
				Continue:IsKeyAlias3'=3  //关键词过滤
		
				Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IFAlias3,"T"))
			
				Set IsAlias3="N"
			}
			Continue:IsAlias3="N"
			Set CtlRstList=CtlRstList_$lb(IFRowID)
			//**************************************************
		}
		//3通过ICD检索是否传染病(检索ICD维护在别名表中,类型为2)
		Set IFAliasID=""
		For {
			Set IFAliasID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID))
			Quit:IFAliasID=""
			Quit:$listfind(CtlRstList,IFRowID)>0
			Set IFAlias=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",1)
			Set IsKeyAlias=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",2)
			Continue:IsKeyAlias'=2
			Set:ICD10=IFAlias CtlRstList=CtlRstList_$lb(IFRowID)
		}
	}
	Q:CtlRstList'="" "1"
	Q "0"
	*/
}

/// Desc:	根据登记号获取就诊ID列表
/// w ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByPatNo("0000000005#0000000005")
ClassMethod GetAdmListByPatNo(APatNoStr As %String) As %ListOfDataTypes
{
	s retList = ##Class(%ListOfDataTypes).%New()
	
	for k = 1:1:$L(APatNoStr,"#")
	{
		s PatNo = $p(APatNoStr,"#",k)
		s papmiList = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiListByPapmiNo(PatNo)
		
		s count = papmiList.Count()
		for i = 1:1:count
		{
			s admList = ..GetAdmListByPapmiDR(papmiList.GetAt(i))
			s admCount = admList.Count()
			
			for j = 1:1:admCount
			{
				d retList.Insert(admList.GetAt(j))
			}
		}
	}
	
	q retList
}

/// Desc:	根据姓名获取就诊ID列表
ClassMethod GetAdmListByName(APatName As %String) As %ListOfDataTypes
{
	s retList = ##Class(%ListOfDataTypes).%New()
	
	s papmiList = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiListByName(APatName)
	
	s count = papmiList.Count()
	for i = 1:1:count
	{
		s admList = ..GetAdmListByPapmiDR(papmiList.GetAt(i))
		s admCount = admList.Count()
		for j = 1:1:admCount
		{
			d retList.Insert(admList.GetAt(j))
		}
	}
	
	q retList
}

/// add by yaolin 
/// Desc:	根据就诊类型获取就诊ID列表
ClassMethod GetAdmListByType(APatType As %String) As %ListOfDataTypes
{
	s retList = ##Class(%ListOfDataTypes).%New()
	s upAPatType = $zcvt(APatType,"u")
	s admID = ""
	for {
		s admID = $O(^PAADMi("PAADM_Type",upAPatType,admID))
		q:(admID = "")
		
		set VisitStatus = $p($g(^PAADM(admID)),"^",20)
	 	continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息
	 	
		if (upAPatType '= "I")
		{
			//门急诊就诊时，过滤掉走号(没有挂号)的患者
			s ResultHasNotRegister = ##Class(EPRservice.BOSysOption).GetValueByName("ResultHasNotRegister")
			if (ResultHasNotRegister = "N")
			{
				&sql(select ID into :DHCRegistrationFeeID from SQLUser.DHCRegistrationFee where RegfeeAdmDr = :admID)
				continue:(DHCRegistrationFeeID = "")
			}
		}
		
		d retList.Insert(admID)
	}
	
	q retList
}

/// Desc:	根据就诊号获取就诊ID列表
/// w ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByAdmNo("IP0000000010#IP0000000011#OP0000000017#OP0000000024")
ClassMethod GetAdmListByAdmNo(AEpisodeNoStr As %String) As %ListOfDataTypes
{
	s retList = ##Class(%ListOfDataTypes).%New()
	
	for i = 1:1:$L(AEpisodeNoStr,"#")
	{
		s upNo = $zcvt($p(AEpisodeNoStr,"#",i),"u")
		s admID = ""
		for {
			s admID = $O(^PAADMi("No",upNo,admID))
			q:(admID = "")
			
			set VisitStatus = $p($g(^PAADM(admID)),"^",20)
		 	continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息
		 	
			//门急诊就诊时，过滤掉走号(没有挂号)的患者
			s ResultHasNotRegister = ##Class(EPRservice.BOSysOption).GetValueByName("ResultHasNotRegister")
			if (ResultHasNotRegister = "N")&&($P($g(^PAADM(admID)),"^",2) '= "I")
			{
				&sql(select ID into :DHCRegistrationFeeID from SQLUser.DHCRegistrationFee where RegfeeAdmDr = :admID)
				continue:(DHCRegistrationFeeID = "")
			}
		
			d retList.Insert(admID)
		}
	}
	
	/*
	s upNo = $zcvt(AEpisodeNo,"u")
	s admID = ""
	for {
		s admID = $O(^PAADMi("No",upNo,admID))
		q:(admID = "")
		
		d retList.Insert(admID)
	}
	*/
	q retList
}

/// Desc:	根据入院日期获取就诊ID列表
ClassMethod GetAdmListByAdmDate(AStartAdmDate As %String, AEndAdmDate As %String) As %ListOfDataTypes
{
	s retList = ##Class(%ListOfDataTypes).%New()
	
	q:(AStartAdmDate > 	AEndAdmDate) retList
	
	for date = AStartAdmDate:1:AEndAdmDate
	{
		s admID = ""
		for {
			s admID = $O(^PAADMi("PAADM_AdmDate",date,admID))
			q:(admID = "")
			
			set VisitStatus = $p($g(^PAADM(admID)),"^",20)
		 	continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息
		 	
			//门急诊就诊时，过滤掉走号(没有挂号)的患者
			s ResultHasNotRegister = ##Class(EPRservice.BOSysOption).GetValueByName("ResultHasNotRegister")
			if (ResultHasNotRegister = "N")&&($P($g(^PAADM(admID)),"^",2) '= "I")
			{
				&sql(select ID into :DHCRegistrationFeeID from SQLUser.DHCRegistrationFee where RegfeeAdmDr = :admID)
				continue:(DHCRegistrationFeeID = "")
			}
			
			d retList.Insert(admID)
		}
	}
	
	q retList
}

/// Desc:	根据出院日期获取就诊ID列表
ClassMethod GetAdmListByDisDate(AStartDisDate As %String, AEndDisDate As %String) As %ListOfDataTypes
{
	
	s retList = ##Class(%ListOfDataTypes).%New()

	q:(AStartDisDate > AEndDisDate) retList
	
	for date = AStartDisDate:1:AEndDisDate
	{
		s admID = ""
		for {
			s admID = $o(^PAADMi("DischDate",date,admID))
			q:(admID = "")
			
			set VisitStatus = $p($g(^PAADM(admID)),"^",20)
		 	continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息
		 	 
			//门急诊就诊时，过滤掉走号(没有挂号)的患者
			s ResultHasNotRegister = ##Class(EPRservice.BOSysOption).GetValueByName("ResultHasNotRegister")
			if (ResultHasNotRegister = "N")&&($P($g(^PAADM(admID)),"^",2) '= "I")
			{
				&sql(select ID into :DHCRegistrationFeeID from SQLUser.DHCRegistrationFee where RegfeeAdmDr = :admID)
				continue:(DHCRegistrationFeeID = "")
			}
			
			d retList.Insert(admID)	
		}	
	}
	
	q retList
}

/// Desc:	根据就诊指针获取就诊ID列表
ClassMethod GetAdmListByPapmiDR(APapmiDR As %String) As %ListOfDataTypes
{
	s retList = ##Class(%ListOfDataTypes).%New()
	
	q:(APapmiDR = "") retList
	
	s type = ""
	for {
		s type = $O(^PAPERdr(APapmiDR,"ADM",type))
		q:(type = "")
		
		s admID = ""
		for {
			s admID = $O(^PAPERdr(APapmiDR,"ADM",type,admID))
			q:(admID = "")
			
			set VisitStatus = $p($g(^PAADM(admID)),"^",20)
		 	continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息
		 	
			//门急诊就诊时，过滤掉走号(没有挂号)的患者
			s ResultHasNotRegister = ##Class(EPRservice.BOSysOption).GetValueByName("ResultHasNotRegister")
			if (ResultHasNotRegister = "N")&&($P($g(^PAADM(admID)),"^",2) '= "I")
			{
				&sql(select ID into :DHCRegistrationFeeID from SQLUser.DHCRegistrationFee where RegfeeAdmDr = :admID)
				continue:(DHCRegistrationFeeID = "")
			}
			
			d retList.Insert(admID)
		}
	}
	
	q retList
}

/// Desc:	获取编目后的门(急)诊诊断信息
/// add by niucaicai 2013-02-03
ClassMethod GetOpDiagnose(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s OpDiagnoseDesc = $g(Result.Data("Opdiagdesc"))
		s OpDiagnoseICD = $g(Result.Data("Opdiagcode"))
	}
	
	q OpDiagnoseDesc_"^"_OpDiagnoseICD
}

/// Desc:	获取编目后的入院诊断信息
/// add by niucaicai 2013-02-03
ClassMethod GetIpDiagnose(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s IpDiagnoseDesc = $g(Result.Data("Ipdiagdesc"))
		s IpDiagnoseICD = $g(Result.Data("Ipdiagcode"))
	}
	
	q IpDiagnoseDesc_"^"_IpDiagnoseICD
}

/// Desc:	获取编目后的主要诊断信息
/// add by niucaicai 2013-02-03
/// w ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetMainDiagnose("58")
ClassMethod GetMainDiagnose(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MainDiagnoseDesc = $g(Result.Data("icddesc1"))
		s MainDiagnoseICD = $g(Result.Data("icdcode1"))
	}
	
	q MainDiagnoseDesc_"^"_MainDiagnoseICD
}

/// Desc:	获取编目后的其他诊断描述
/// add by niucaicai 2013-02-04
ClassMethod GetOtherDiagnoseDesc(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		//目前模板中最多支持21个其他诊断
		
		s OtherDiagnoseDesc1 = $g(Result.Data("icddesc2"))
		s OtherDiagnoseDesc2 = $g(Result.Data("icddesc3"))
		s OtherDiagnoseDesc3 = $g(Result.Data("icddesc4"))
		s OtherDiagnoseDesc4 = $g(Result.Data("icddesc5"))
		s OtherDiagnoseDesc5 = $g(Result.Data("icddesc6"))
		s OtherDiagnoseDesc6 = $g(Result.Data("icddesc7"))
		s OtherDiagnoseDesc7 = $g(Result.Data("icddesc8"))
		s OtherDiagnoseDesc8 = $g(Result.Data("icddesc9"))
		s OtherDiagnoseDesc9 = $g(Result.Data("icddesc10"))
		s OtherDiagnoseDesc10 = $g(Result.Data("icddesc11"))
		
		//添加其他诊断11至21
		s OtherDiagnoseDesc11 = $g(Result.Data("icddesc15"))
		s OtherDiagnoseDesc12 = $g(Result.Data("icddesc16"))
		s OtherDiagnoseDesc13 = $g(Result.Data("icddesc17"))
		s OtherDiagnoseDesc14 = $g(Result.Data("icddesc18"))
		s OtherDiagnoseDesc15 = $g(Result.Data("icddesc19"))
		s OtherDiagnoseDesc16 = $g(Result.Data("icddesc20"))
		s OtherDiagnoseDesc17 = $g(Result.Data("icddesc21"))
		s OtherDiagnoseDesc18 = $g(Result.Data("icddesc22"))
		s OtherDiagnoseDesc19 = $g(Result.Data("icddesc23"))
		s OtherDiagnoseDesc20 = $g(Result.Data("icddesc24"))
		s OtherDiagnoseDesc21 = $g(Result.Data("icddesc25"))
	}
	//目前模板中最多支持21个其他诊断
	q OtherDiagnoseDesc1_"^"_OtherDiagnoseDesc2_"^"_OtherDiagnoseDesc3_"^"_OtherDiagnoseDesc4_"^"_OtherDiagnoseDesc5_"^"_OtherDiagnoseDesc6_"^"_OtherDiagnoseDesc7_"^"_OtherDiagnoseDesc8_"^"_OtherDiagnoseDesc9_"^"_OtherDiagnoseDesc10_"^"_OtherDiagnoseDesc11_"^"_OtherDiagnoseDesc12_"^"_OtherDiagnoseDesc13_"^"_OtherDiagnoseDesc14_"^"_OtherDiagnoseDesc15_"^"_OtherDiagnoseDesc16_"^"_OtherDiagnoseDesc17_"^"_OtherDiagnoseDesc18_"^"_OtherDiagnoseDesc19_"^"_OtherDiagnoseDesc20_"^"_OtherDiagnoseDesc21
}

/// Desc:	获取编目后的其他诊断描述
ClassMethod GetOtherDiagnoseICD(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		//目前模板中最多支持21个其他诊断
		
		s OtherDiagnoseICD1 = $g(Result.Data("icdcode2"))
		s OtherDiagnoseICD2 = $g(Result.Data("icdcode3"))
		s OtherDiagnoseICD3 = $g(Result.Data("icdcode4"))
		s OtherDiagnoseICD4 = $g(Result.Data("icdcode5"))
		s OtherDiagnoseICD5 = $g(Result.Data("icdcode6"))
		s OtherDiagnoseICD6 = $g(Result.Data("icdcode7"))
		s OtherDiagnoseICD7 = $g(Result.Data("icdcode8"))
		s OtherDiagnoseICD8 = $g(Result.Data("icdcode9"))
		s OtherDiagnoseICD9 = $g(Result.Data("icdcode10"))
		s OtherDiagnoseICD10 = $g(Result.Data("icdcode11"))
		
		//添加其他诊断11至21
		s OtherDiagnoseICD11 = $g(Result.Data("icdcode15"))
		s OtherDiagnoseICD12 = $g(Result.Data("icdcode16"))
		s OtherDiagnoseICD13 = $g(Result.Data("icdcode17"))
		s OtherDiagnoseICD14 = $g(Result.Data("icdcode18"))
		s OtherDiagnoseICD15 = $g(Result.Data("icdcode19"))
		s OtherDiagnoseICD16 = $g(Result.Data("icdcode20"))
		s OtherDiagnoseICD17 = $g(Result.Data("icdcode21"))
		s OtherDiagnoseICD18 = $g(Result.Data("icdcode22"))
		s OtherDiagnoseICD19 = $g(Result.Data("icdcode23"))
		s OtherDiagnoseICD20 = $g(Result.Data("icdcode24"))
		s OtherDiagnoseICD21 = $g(Result.Data("icdcode25"))
	}
	//目前模板中最多支持21个其他诊断
	q OtherDiagnoseICD1_"^"_OtherDiagnoseICD2_"^"_OtherDiagnoseICD3_"^"_OtherDiagnoseICD4_"^"_OtherDiagnoseICD5_"^"_OtherDiagnoseICD6_"^"_OtherDiagnoseICD7_"^"_OtherDiagnoseICD8_"^"_OtherDiagnoseICD9_"^"_OtherDiagnoseICD10_"^"_OtherDiagnoseICD11_"^"_OtherDiagnoseICD12_"^"_OtherDiagnoseICD13_"^"_OtherDiagnoseICD14_"^"_OtherDiagnoseICD15_"^"_OtherDiagnoseICD16_"^"_OtherDiagnoseICD17_"^"_OtherDiagnoseICD18_"^"_OtherDiagnoseICD19_"^"_OtherDiagnoseICD20_"^"_OtherDiagnoseICD21
}

/// Desc:	获取编目后的病理诊断信息
/// add by niucaicai 2013-02-04
ClassMethod GetPathologyDiagnose(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s PathologyDiagnoseDesc = $g(Result.Data("icddesc12"))
		s PathologyDiagnoseICD = $g(Result.Data("icdcode12"))
	}
	
	q PathologyDiagnoseDesc_"^"_PathologyDiagnoseICD
}

/// Desc:	获取编目后的“损伤、中毒的外部因素诊断”信息
/// add by niucaicai 2013-02-04
ClassMethod GetDamAndPoisonDiagnose(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s DamAndPoisonDiagnoseDesc = $g(Result.Data("icddesc13"))
		s DamAndPoisonDiagnoseICD = $g(Result.Data("icdcode13"))
	}
	
	q DamAndPoisonDiagnoseDesc_"^"_DamAndPoisonDiagnoseICD
}

/// Desc:	获取编目后的医院感染诊断信息
/// add by niucaicai 2013-02-04
ClassMethod GetInfectDiagnose(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s InfectDiagnoseDesc = $g(Result.Data("icddesc14"))
		s InfectDiagnoseICD = $g(Result.Data("icdcode14"))
	}
	
	q InfectDiagnoseDesc_"^"_InfectDiagnoseICD
}

/// Desc:	获取编目后的手术名称信息
/// add by niucaicai 2017-07-12
ClassMethod GetOperationDesc(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		//手术
		s OperationDesc1 = $g(Result.Data("operdesc1"))
		s OperationDesc2 = $g(Result.Data("operdesc2"))
		s OperationDesc3 = $g(Result.Data("operdesc3"))
		s OperationDesc4 = $g(Result.Data("operdesc4"))
		s OperationDesc5 = $g(Result.Data("operdesc5"))
		//操作
		s OperationDesc6 = $g(Result.Data("operdesc6"))
		s OperationDesc7 = $g(Result.Data("operdesc7"))
		s OperationDesc8 = $g(Result.Data("operdesc8"))
		s OperationDesc9 = $g(Result.Data("operdesc9"))
		s OperationDesc10 = $g(Result.Data("operdesc10"))
	}
	q OperationDesc1_"^"_OperationDesc2_"^"_OperationDesc3_"^"_OperationDesc4_"^"_OperationDesc5_"^"_OperationDesc6_"^"_OperationDesc7_"^"_OperationDesc8_"^"_OperationDesc9_"^"_OperationDesc10
}

/// Desc:	获取编目后的手术ICD信息
/// add by niucaicai 2017-07-12
ClassMethod GetOperationICD(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		//手术
		s OperationICD1 = $g(Result.Data("opercode1"))
		s OperationICD2 = $g(Result.Data("opercode2"))
		s OperationICD3 = $g(Result.Data("opercode3"))
		s OperationICD4 = $g(Result.Data("opercode4"))
		s OperationICD5 = $g(Result.Data("opercode5"))
		//操作
		s OperationICD6 = $g(Result.Data("opercode6"))
		s OperationICD7 = $g(Result.Data("opercode7"))
		s OperationICD8 = $g(Result.Data("opercode8"))
		s OperationICD9 = $g(Result.Data("opercode9"))
		s OperationICD10 = $g(Result.Data("opercode10"))
	}
	q OperationICD1_"^"_OperationICD2_"^"_OperationICD3_"^"_OperationICD4_"^"_OperationICD5_"^"_OperationICD6_"^"_OperationICD7_"^"_OperationICD8_"^"_OperationICD9_"^"_OperationICD10
}

/// Desc:	获取总费用信息
/// add by niucaicai 2014-04-09
ClassMethod GetTMCTotal(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s TMCTotal = $g(Result.Data("TMCTotal"))
	}
	
	q TMCTotal
}

/// Desc:	获取出院条件
/// add by niucaicai 2014-04-09
ClassMethod GetConditAtDischDR(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s ConditAtDischDR = $p($g(^MR(AEpisodeID,"PRO",1)),"^",10)
	q ConditAtDischDR
}

/// Desc:	获取病案子类费用合计信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCTotal(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCTotal = $g(Result.Data("MCTotal"))
	}
	
	q MCTotal
}

/// Desc:	获取一般医疗服务费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCYBYLFWF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCYBYLFWF = $g(Result.Data("MC01ZLFW"))
	}
	
	q MCYBYLFWF
}

/// Desc:	获取一般治疗操作费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCYBZLCZF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCYBZLCZF = $g(Result.Data("MC02ZLCZ"))
	}
	
	q MCYBZLCZF
}

/// Desc:	获取护理费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCHLF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCHLF = $g(Result.Data("MC03HL"))
	}
	
	q MCHLF
}

/// Desc:	获取其他费用信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCQTFY(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCQTFY = $g(Result.Data("MC04QTFY"))
	}
	
	q MCQTFY
}

/// Desc:	获取病理诊断费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCBLZDF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCBLZDF = $g(Result.Data("MC05BLZD"))
	}
	
	q MCBLZDF
}

/// Desc:	获取实验室诊断费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCSYSZDF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCSYSZDF = $g(Result.Data("MC06SYSZD"))
	}
	
	q MCSYSZDF
}

/// Desc:	获取影像学诊断费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCYXXZDF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCYXXZDF = $g(Result.Data("MC07YXXZD"))
	}
	
	q MCYXXZDF
}

/// Desc:	获取临床诊断项目费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCLCZDXMF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCLCZDXMF = $g(Result.Data("MC08LCZDXM"))
	}
	
	q MCLCZDXMF
}

/// Desc:	获取临床物理治疗费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCLCWLZLF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCLCWLZLF = $g(Result.Data("MC09LCWLZL"))
	}
	
	q MCLCWLZLF
}

/// Desc:	获取麻醉费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCMZF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCMZF = $g(Result.Data("MC101MZ"))
	}
	
	q MCMZF
}

/// Desc:	获取手术费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCSSF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCSSF = $g(Result.Data("MC102SS"))
	}
	
	q MCSSF
}

/// Desc:	获取康复费信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCKFF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCKFF = $g(Result.Data("MC11KF"))
	}
	
	q MCKFF
}

/// Desc:	获取中医诊断信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYZD(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYZD = $g(Result.Data("MC12ZYZD"))
	}
	
	q MCZYZD
}

/// Desc:	获取中医外治信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYWZ(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYWZ = $g(Result.Data("MC131ZYWZ"))
	}
	
	q MCZYWZ
}

/// Desc:	获取针刺与灸法信息
/// add by niucaicai 2014-04-09
ClassMethod GetMCZCYJF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZCYJF = $g(Result.Data("MC132ZCYJF"))
	}
	
	q MCZCYJF
}

/// Desc:	中医推拿治疗
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYTNZL(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYTNZL = $g(Result.Data("MC133ZYTNZL"))
	}
	
	q MCZYTNZL
}

/// Desc:	中医肛肠治疗
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYGCZL(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYGCZL = $g(Result.Data("MC134ZYGCZL"))
	}
	
	q MCZYGCZL
}

/// Desc:	中医特殊治疗
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYTSZL(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYTSZL = $g(Result.Data("MC13ZYTSZL"))
	}
	
	q MCZYTSZL
}

/// Desc:	中医特殊调配加工
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYTSTPJG(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYTSTPJG = $g(Result.Data("MC141ZYTSTPJG"))
	}
	
	q MCZYTSTPJG
}

/// Desc:	辩证施膳
/// add by niucaicai 2014-04-09
ClassMethod GetMCBZSS(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCBZSS = $g(Result.Data("MC142BZSS"))
	}
	
	q MCBZSS
}

/// Desc:	西药费
/// add by niucaicai 2014-04-09
ClassMethod GetMCXYF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCXYF = $g(Result.Data("MC151XY"))
	}
	
	q MCXYF
}

/// Desc:	西药制剂费
/// add by niucaicai 2014-04-09
ClassMethod GetMCXYZJF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCXYZJF = $g(Result.Data("MC152XYZJ"))
	}
	
	q MCXYZJF
}

/// Desc:	抗菌药物费用
/// add by niucaicai 2014-04-09
ClassMethod GetMCKJYWFY(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCKJYWFY = $g(Result.Data("MC153KJYWFY"))
	}
	
	q MCKJYWFY
}

/// Desc:	中成药费
/// add by niucaicai 2014-04-09
ClassMethod GetMCZCYF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZCYF = $g(Result.Data("MC161ZCY"))
	}
	
	q MCZCYF
}

/// Desc:	中药制剂费
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYZJF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYZJF = $g(Result.Data("MC162ZCZJF"))
	}
	
	q MCZYZJF
}

/// Desc:	中草药费
/// add by niucaicai 2014-04-09
ClassMethod GetMCZCaoYF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZCaoYF = $g(Result.Data("MC17ZCY"))
	}
	
	q MCZCaoYF
}

/// Desc:	血费
/// add by niucaicai 2014-04-09
ClassMethod GetMCXF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCXF = $g(Result.Data("MC18XF"))
	}
	
	q MCXF
}

/// Desc:	白蛋白类制品费
/// add by niucaicai 2014-04-09
ClassMethod GetMCBDBLZPF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCBDBLZPF = $g(Result.Data("MC19BDBLZP"))
	}
	
	q MCBDBLZPF
}

/// Desc:	球蛋白类制品费
/// add by niucaicai 2014-04-09
ClassMethod GetMCQDBLZPF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCQDBLZPF = $g(Result.Data("MC20QDBLZP"))
	}
	
	q MCQDBLZPF
}

/// Desc:	凝血因子类制品费
/// add by niucaicai 2014-04-09
ClassMethod GetMCNXYZLZPF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCNXYZLZPF = $g(Result.Data("MC21LXYZLZP"))
	}
	
	q MCNXYZLZPF
}

/// Desc:	细胞因子类制品费
/// add by niucaicai 2014-04-09
ClassMethod GetMCXBYZLZPF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCXBYZLZPF = $g(Result.Data("MC22NXYZLZP"))
	}
	
	q MCXBYZLZPF
}

/// Desc:	检查用一次性医用材料费
/// add by niucaicai 2014-04-09
ClassMethod GetMCJCYYCXYYCLF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCJCYYCXYYCLF = $g(Result.Data("MC23JCYYCXYYCL"))
	}
	
	q MCJCYYCXYYCLF
}

/// Desc:	治疗用一次性医用材料费
/// add by niucaicai 2014-04-09
ClassMethod GetMCZLYYCXYYCLF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZLYYCXYYCLF = $g(Result.Data("MC24ZLYYCXYYCL"))
	}
	
	q MCZLYYCXYYCLF
}

/// Desc:	手术用一次性医用材料费
/// add by niucaicai 2014-04-09
ClassMethod GetMCSSYYCXYYCLF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCSSYYCXYYCLF = $g(Result.Data("MC24ZLYYCXYYCL"))
	}
	
	q MCSSYYCXYYCLF
}

/// Desc:	其他费
/// add by niucaicai 2014-04-09
ClassMethod GetMCQTF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCQTF = $g(Result.Data("MC26QT"))
	}
	
	q MCQTF
}

/// Desc:	中医骨伤
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYGS(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYGS = $g(Result.Data("MC136ZYGS"))
	}
	
	q MCZYGS
}

/// Desc:	中医辨证论治费
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYBZLZF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYBZLZF = $g(Result.Data("MC012ZYBZLZ"))
	}
	
	q MCZYBZLZF
}

/// Desc:	中医辨证论治会诊费
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYBZLZHZF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYBZLZHZF = $g(Result.Data("MC013ZYBZLZHZ"))
	}
	
	q MCZYBZLZHZF
}

/// Desc:	一般费用总和
/// add by niucaicai 2014-04-09
ClassMethod GetMCYBFYZH(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCYBFYZH = $g(Result.Data("SUNMC1"))
	}
	
	q MCYBFYZH
}

/// Desc:	中医治疗
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYZL(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYZL = $g(Result.Data("SUNMC13"))
	}
	
	q MCZYZL
}

/// Desc:	中医其他
/// add by niucaicai 2014-04-09
ClassMethod GetMCZYQT(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZYQT = $g(Result.Data("SUNMC14"))
	}
	
	q MCZYQT
}

/// Desc:	西药费总和
/// add by niucaicai 2014-04-09
ClassMethod GetMCXYFZH(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCXYFZH = $g(Result.Data("SUNMC15"))
	}
	
	q MCXYFZH
}

/// Desc:	手术治疗费
/// add by niucaicai 2014-04-09
ClassMethod GetMCSSZLF(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCSSZLF = $g(Result.Data("SUNMC10"))
	}
	
	q MCSSZLF
}

/// Desc:	中成药费总和
/// add by niucaicai 2014-04-09
ClassMethod GetMCZCYFZH(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s Result = ##class(%ResultSet).%New("EPRservice.SystemData:GetMCFeeInfo")
	d Result.Execute(AEpisodeID)
	while(Result.Next())
	{
		s MCZCYFZH = $g(Result.Data("SUNMC16"))
	}
	
	q MCZCYFZH
}

}
