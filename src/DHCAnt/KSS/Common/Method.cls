/// CTOR: QP
/// DATE: 2016-08-7
/// VERN: V4.1.3
/// DESC: 公共类：放置医生站界面和维护界面的公共Method
Class DHCAnt.KSS.Common.Method Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 根据医嘱项id获取管制分类代码
/// IN  : 医嘱项ID
/// OUT : 
/// TABL: PHC_Poison
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetKssCate("903||1")
ClassMethod GetKssCate(arcim As %String)
{
	n (arcim)
	Q:arcim="" 0
	s code="" 
	s phcdr=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",12)   //PHC_DrgForm
	s phcid=+phcdr
	s phcpo=$p(^PHCD(phcid,1),"^",4)
	q:phcpo="" 0
	s phccode=$p(^PHCPO(phcpo),"^",1)  //管制分类代码
	s code=$zcvt(phccode,"U") 
	q code
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 根据医嘱项id获取管制分类id
/// IN  : 医嘱项ID
/// OUT : 
/// TABL: PHC_Poison
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetKssPoisonId("903||1")
ClassMethod GetKssPoisonId(arcim As %String)
{
	n (arcim)
	Q:arcim="" ""
	s code="" 
	s phcdr=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",12)   //PHC_DrgForm
	Q:phcdr="" ""
	s phcid=+phcdr
	s phcpo=$p(^PHCD(phcid,1),"^",4)
	i phcpo=$C(0) s phcpo=""
	q phcpo
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 获取病人就诊类型
/// IN  : 就诊ID
/// OUT : 
/// TABL: PA_ADM
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetPAAdmType("1")
ClassMethod GetPAAdmType(EpisodeID As %String)
{
	n (EpisodeID)
	q:EpisodeID="" ""
	s PAAdmType=""
	s obj=##class(User.PAAdm).%OpenId(EpisodeID)
	i $IsObject(obj) {s PAAdmType=obj.PAADMType}
	Q PAAdmType
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 根据医生ID、管制分类CODE, 就诊类型，来获取医生对应的抗生素级别的流程类型和流程
/// IN  : SSUID、POISONCode
/// 	  mode:1/2
/// OUT : KSS3APPA/KSS2APP/KSS3APPNOA/0
/// 
/// EXEC:  w ##class(DHCAnt.KSS.Common.Method).GetUserIsAuth("10209","KSS3","3","I",2)
ClassMethod GetUserIsAuth(UserId As %String, poisoncode As %String, mode As %String, admType As %String = "", InHosp = "")
{
	n (UserId,poisoncode,mode,admType,InHosp,%session)
	
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
 	q:$g(UserId)="" ""
 	q:$g(poisoncode)="" ""
 	q:$g(admType)="" ""
 	q:$g(InHosp)="" ""
 	s Userid=$zcvt(UserId,"U"),process="",mRtn="",lastAuditUser=""
 	s ctCareDr=$p(^SSU("SSUSR",Userid),"^",14) 
 	q:ctCareDr="" ""
 	s CTCPTDr=$p(^CTPCP(ctCareDr,1),"^",4) 
 	
 	//处理处方权
	s MCGCode="F"_ctCareDr
	s MCGID=""
	;s MCGID=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
	s MCGID=$o(^DHCAntBaseMainConfigI("MCGHospAndCode",InHosp,MCGCode,""))
	s MCGvalue=1
	i MCGID'="" d
	.s MCGactive=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",5) 
	.i MCGactive=1 d
	..s DateFrom=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",6) 
    ..s DateTo=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",7) 
    ..s HospId=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",14)
    ..q:HospId'=InHosp
    ..q:(DateTo<+$h)||(DateFrom>+$h)
	..s MCGvalue=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",9)
	q:MCGvalue=0 ""
	
 	s Child=0 
 	s flag1=0
 	f  s Child=$O(^CT("CPT",CTCPTDr,"PHPO",Child)) q:Child=""  d	;DHC_CarPrvTpPHPoison
 	.s TPPControlType=$p(^CT("CPT",CTCPTDr,"PHPO",Child),"^",2)
 	.s TPPEpisodeType=$p(^CT("CPT",CTCPTDr,"PHPO",Child),"^",3)
 	.s HospId=$p(^CT("CPT",CTCPTDr,"PHPO",Child),"^",5)
 	.q:(HospId'=InHosp)&&(InHosp'="")
 	.q:admType'=TPPEpisodeType
 	.s PoisonRowId=$P(^CT("CPT",CTCPTDr,"PHPO",Child),"^",1)
 	.s PoisonCode1=$p(^PHCPO(PoisonRowId),"^",1)
 	.q:PoisonCode1'=poisoncode
 	.s flag=$p(^CT("CPT",CTCPTDr,"PHPO",Child),"^",4)
 	.s grandChild=""
 	.s grandChild=$o(^CT(0,"CPDR",ctCareDr,CTCPTDr,Child,""))
 	.i grandChild'="" d
 	..s TPPControlType=$p(^CT("CPT",CTCPTDr,"PHPO",Child,"CP",grandChild),"^",8)
 	..s flag=$p(^CT("CPT",CTCPTDr,"PHPO",Child,"CP",grandChild),"^",7)
 	.i (poisoncode="KSS1")&&((TPPControlType="P")||(TPPControlType="E"))  s flag1="KSS2APP"
 	.i (poisoncode="KSS2")&&((TPPControlType="P")||(TPPControlType="E"))  s flag1="KSS2APP"
 	.i (flag="Y")&&(poisoncode="KSS3")&&((TPPControlType="P")||(TPPControlType="E"))  s flag1="KSS3APPA"
 	.i (flag="N")&&(poisoncode="KSS3")&&((TPPControlType="P")||(TPPControlType="E"))  s flag1="KSS3APPNOA"
 	
 	i (flag1'="")&&(flag1'=0) s process=##class(DHCAnt.Base.MainConfigExcute).GetProcessNew(flag1,InHosp)
 	i process["U" s lastAuditUser=##class(DHCAnt.Base.MainConfigExcute).GetControlTypeByMCGCode(flag1,InHosp)
 	
 	i mode=3 s mRtn=process_"!"_flag1_"!"_lastAuditUser
 	e  i mode=2  s mRtn=process_"!"_flag1
 	e  s mRtn=process
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 将日期转换成定量数值(秒)
/// IN  : 
/// OUT : 
/// 
/// EXEC: 
ClassMethod GetAbsTime(dt As %String) As %String
{
  n (dt)
  
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 得到医护人员对某个管制分类是否有权限
/// IN  : 	  
/// OUT : 1/""
/// 
/// EXEC:  w ##class(DHCAnt.KSS.Common.Method).GetDoctorTypePoisonFlag("1350","I","11")
ClassMethod GetDoctorTypePoisonFlag(DoctorID As %String, PAAdmType As %String, PoisonId, InHosp = "") As %String
{
	n (DoctorID,PAAdmType,PoisonId,InHosp,%session)
	/*
	s Flag=0
	if DoctorID="" Q ""
	s DoctorTypeRowId=$P($G(^CTPCP(DoctorID,1)),"^",4)
	if DoctorTypeRowId="" Q ""
	s ret=""
	s Child=0 f  s Child=$O(^CT("CPT",DoctorTypeRowId,"PHPO",Child)) Q:(Child="")||(Flag=1)  d
	.s PoisonRowId=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",1)
	.Quit:PoisonRowId'=PoisonId
	.s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",2)
	.s TPPEpisodeType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",3)
	.q:TPPEpisodeType'=PAAdmType
	.s TPPChkVerify=$p($g(^CT("CPT",DoctorTypeRowId,"PHPO",Child)),"^",4) 
	.if TPPChkVerify="Y" do
	..Set Flag=1
	Q Flag
	*/
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
	s Flag=0
	if DoctorID="" Q Flag
	s DoctorTypeRowId=$P($G(^CTPCP(DoctorID,1)),"^",4)
	if DoctorTypeRowId="" Q Flag
	;处理处方权
	s MCGCode="F"_DoctorID
	s MCGID=""
	;s MCGID=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
	i InHosp'="" s MCGID=$o(^DHCAntBaseMainConfigI("MCGHospAndCode",InHosp,MCGCode,""))
	e  s MCGID=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
	s MCGvalue=1
	i MCGID'="" d
	.s MCGactive=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",5) 
	.i MCGactive=1 d
	..s DateFrom=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",6) 
    ..s DateTo=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",7) 
    ..q:(DateTo<+$h)||(DateFrom>+$h)
	..s MCGvalue=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",9)
	q:MCGvalue=0 Flag
	
	s AUTHTODOC=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("AUTHTODOC",InHosp)
	
	s ret=""
	s Child=0 f  s Child=$O(^CT("CPT",DoctorTypeRowId,"PHPO",Child)) Q:(Child="")||(Flag=1)  d
	.s PoisonRowId=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",1)
	.Quit:PoisonRowId'=PoisonId
	.s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",2)
	.s TPPEpisodeType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",3)
	.s HospId=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",5)
	.q:(HospId'=InHosp)&&(InHosp'="")
	.q:TPPEpisodeType'=PAAdmType
	.s TPPChkVerify="N"	//默认为无审核权限
	.i AUTHTODOC'=1 s TPPChkVerify=$p($g(^CT("CPT",DoctorTypeRowId,"PHPO",Child)),"^",4) //主表审核权限
	.s AntPrescBility="Y"	//医生处方权，默认都为Y
	.i $d(^CT(0,"CPDR",DoctorID,DoctorTypeRowId,Child)) d
	..s rowid=$o(^CT(0,"CPDR",DoctorID,DoctorTypeRowId,Child,""))
	..s AntPrescBility=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",5)
	..s TPPChkVerify=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",7)
	.q:AntPrescBility'="Y"
	.if TPPChkVerify="Y" do
	..Set Flag=1
	Q Flag
}

/// CTOR: QP
/// DATE: 2016-09-01
/// DESC: 医护人员转换成SSUSER
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser("954")
ClassMethod TransCTCareToSSUser(ctCareId) As %String
{
	n (ctCareId)
	s mRet=""
	q:ctCareId="" mRet
	q:'$d(^SSU("SSUSR",0,"CTPCP",ctCareId)) mRet
	s mRet=$o(^SSU("SSUSR",0,"CTPCP",ctCareId,""))
	q mRet
}

/// CTOR: QP
/// DATE: 2016-09-01
/// DESC: SSUSER转换成医护人员
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).TransSSUserToCTCare("2072")
ClassMethod TransSSUserToCTCare(ssuid) As %String
{
	n (ssuid)
	s mRet=""
	q:ssuid="" mRet
	q:'$d(^SSU("SSUSR",ssuid)) mRet
	s mRet=$p(^SSU("SSUSR",ssuid),"^",14)
	q mRet
}

/// CTOR: QP
/// DATE: 2016-08-06
/// DESC: 获取医生的权限配置
/// 
/// EXEC: d ##class(DHCAnt.KSS.Common.Method).Test()
ClassMethod Test() As %String
{
	for i=1:1:200{
		&sql(INSERT INTO DHCAnt_Base.PurposeDataConfig(PDC_Type) VALUES(:i))
	}
}

/// CTOR: QP
/// DATE: 2016-08-06
/// DESC: 得到抗菌药物功能打开标志
/// OSKJ、ESKJ、ISKJ、
/// EXEC: d ##class(DHCAnt.KSS.Common.Method).GetKJSwitchFlag("I")
ClassMethod GetKJSwitchFlag(admType, inHosp = "") As %String
{
	n (admType,inHosp,%session)
	s mRtn=1
	i admType="O" d
	.s oskjFlag=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("OSKJ",inHosp)
	.i oskjFlag=1 s mRtn=0
	
	i admType="E" d
	.s oskjFlag=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("ESKJ",inHosp)
	.i oskjFlag=1 s mRtn=0
	
	i admType="I" d
	.s oskjFlag=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("ISKJ",inHosp)
	.i oskjFlag=1 s mRtn=0
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 获取科室
/// IN  : 科室id
/// OUT : 
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetAllDep("I")
ClassMethod GetAllDep(loc As %String)
{
	n (loc)
	s rtn="[",num=0
	Set CTLOCID=0
	F  s CTLOCID=$O(^CTLOC(CTLOCID)) q:CTLOCID=""  d 
	.S CTLOCDesc=$P($G(^CTLOC(CTLOCID)),"^",1)
	.s CTLOCDesc1=$P($G(^CTLOC(CTLOCID)),"^",2)
	.i CTLOCDesc1["-" d	;旧版
	..i CTLOCDesc'="" S CTLOCDesc2=##class(DHCAnt.Util.ConvertJson).FilterValue(CTLOCDesc)
	..e  s CTLOCDesc2=##class(DHCAnt.Util.ConvertJson).FilterValue($p(CTLOCDesc1,"-",2))
	.e  s CTLOCDesc2=CTLOCDesc1	;新版
	.s num=num+1 
	.i num=1 d
	..s rtn="{""id"": "_""""_CTLOCID_""", ""desc"": "_""""_CTLOCDesc2_"""}"
	.e  d
	..s rtn=rtn_"%{""id"": "_""""_CTLOCID_""", ""desc"": "_""""_CTLOCDesc2_"""}"
	q rtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 工具方法，判断数值包含
/// IN  : 
/// OUT : 
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).InArray("I")
ClassMethod InArray(kssarray As %String, docId As %String) As %String
{
	s rtn=0,data=""
	s multiLen=$l(kssarray,",")
	f len=1:1:multiLen {
		s data=$p(kssarray,",",len)
		continue:data="" 
		i data=docId{
			s rtn=1	
			q
		}
		
	}
	q rtn
}

/// CTOR: QP
/// DATE: 2017-03-20
/// DESC: 根据医生工号获取医生的相关信息
/// IN  : 医生工号
/// OUT : 
/// 
/// EXEC: 
ClassMethod GetDocInfoByDocNum(docnum As %String)
{
	n (docnum)
	s docnum=$zcvt(docnum,"U")
	q:docnum="" ""
	s ssuid=$o(^SSU("SSUSR",0,"SSUSR_Initials",docnum,""))
	q:ssuid="" ""
	s docname=$p(^SSU("SSUSR",ssuid),"^",2)
	s ctcarePrvId=..TransSSUserToCTCare(ssuid)
	q:ctcarePrvId="" ""
	s ctcarPrvTpId=$p(^CTPCP(ctcarePrvId,1),"^",4)
	q:ctcarPrvTpId="" ""
	q ctcarPrvTpId_"^"_ctcarePrvId
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 根据管制分类代码获取管制分类ID
/// IN  : 管制分类代码
/// OUT : 
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetPoisonIdByCode("kss1")
ClassMethod GetPoisonIdByCode(code As %String)
{
	n (code)
	q:code="" ""
	s code=$zcvt(code,"U")
	s rowid=$o(^PHCPO(0,"Code",code,""))
	q:rowid="" ""
	
	q rowid
}

/// CTOR: QP
/// DATE: 2017-04-21
/// DESC: 根据配置来得到审核界面应该显示会诊科室的个数
/// IN  : 
/// OUT : 会诊科室个数		
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetConsultDepNums(2)
ClassMethod GetConsultDepNums(InHosp)
{
	n (InHosp,%session)
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
	s defaultDep=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("DEFAULTCONDEP",InHosp)
	;q:(defaultDep'="")&&(defaultDep'=0) 1
	s manyConsult=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SMANYCONSULT",InHosp)
	q:(manyConsult="")||(manyConsult=0) 1
	s consultNums=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("CONDEPNUM",InHosp)
	;i ((consultNums="")||(consultNums=0)) s consultNums=1	;处理启用了多科会诊但未激活会诊科室个数的情况，此时默认为1 QP 2017-05-31
	q consultNums
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 根据会诊科室 或 会诊医生 -> 判断 是否为感染性疾病科
/// IN  : 科室ID,医护人员id
/// 
/// OUT : 1：是/ 0：否		
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComIsInfectDep(16,288)
ClassMethod ComIsInfectDep(loc As %String = "", doc As %String = "")
{
	n (loc, doc)
	s mRtn=0
	q:(loc="")&&(doc="") mRtn
	
	i loc'="" d
	.s pdcId=""
	.f  s pdcId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONLOC",pdcId)) q:pdcId=""  d
	..s infectDepFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",9)	//
	..s consultDep=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)
	..i ((consultDep=loc)&&(infectDepFlag=1)) s mRtn=1
	..q:mRtn=1
	.i ((mRtn'=1)&&(doc'="")) d
	..s pdcId=""
	..f  s pdcId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONDOC",pdcId)) q:pdcId=""  d
	...s infectDepFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",9)	//
	...s consultDoc=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)
	...i (consultDoc=doc)&&(infectDepFlag=1) s mRtn=1
	...q:mRtn=1
	e  d
	.s pdcId=""
	.f  s pdcId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONDOC",pdcId)) q:pdcId=""  d
	..s infectDepFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",9)	//
	..s consultDoc=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)
	..i (consultDoc=doc)&&(infectDepFlag=1) s mRtn=1
	..q:mRtn=1
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 获取抗菌药物系统版本号
/// IN  : 
/// 
/// OUT : 	
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetKSSVersion()
ClassMethod GetKSSVersion()
{
	n 
	s version=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("VERSION")
	q version
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 判断是否为新版
/// IN  : 
/// 
/// OUT : 	1:是 / 0:否
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComIsNewVersion()
ClassMethod ComIsNewVersion()
{
	n 
	s mRtn=0
	i $d(^DHCAntBaseMainConfigD) s mRtn=1
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 根据医嘱项判断是否为，碳青霉烯类抗菌药物或替加环素类
/// IN  : 医嘱项ID, mode: 1 2 3
/// 	  mode=1 代表 碳青霉烯类抗菌药物
/// 		  mode=2 代表 替加环素类
/// 		  mode=3 代表 碳青霉烯类抗菌药物 和 替加环素类
/// OUT : 1：是 /  0：否
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComIsCqmxOrTgc("5||1", 1)
ClassMethod ComIsCqmxOrTgc(arcim As %String = "", mode As %String = "")
{
	n (arcim, mode)
	s mRtn=0
	q:arcim="" mRtn
	i mode="" s mode=3	//若没指定，则默认两者都有
	s CQMXArray=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("CQMX")
	s TGCArray=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("TGC")
	i mode=1 s mRtn=..InArray(CQMXArray,arcim)
	i mode=2 s mRtn=..InArray(TGCArray,arcim) 
	i mode=3 s mRtn=(..InArray(TGCArray,arcim))||(..InArray(CQMXArray,arcim))
	q mRtn
}

/// QP
/// DATE: 2017-06-13
/// DESC: 获取系统日期格式配置
/// @return 
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetDateFormat()
ClassMethod GetDateFormat() As %String
{
	n
	/*
	s sptHisDate=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SPTHISDATE")
	s cfgDateFormat=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("DATEFORMAT")
	i (cfgDateFormat'=3)&&(cfgDateFormat'=1)&&(cfgDateFormat'=4) s cfgDateFormat=4
	s defaultFormat=cfgDateFormat
	i sptHisDate=1 s defaultFormat=##class(websys.Conversions).DateFormat()
	q defaultFormat
	*/
	s defaultFormat=##class(websys.Conversions).DateFormat()
	q defaultFormat
}

/// QP
/// DATE: 2017-06-13
/// DESC: 处理日期显示格式 
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml("64447")
ClassMethod DateLogicalToHtml(h As %String) As %String [ Final ]
{
	n (h)
	s val=""
	Q:h="" ""
	Q:(h'?1n.n)&&(h'[",") h
	s $ZT="Err"
	Set format = ..GetDateFormat()
	Set date = $zd(h,format)
	if (format=4){
		Set date = $zd(h,format)
		Set $p(date,"/",3)=+$zd(h,3)
	}
	quit date
Err
	Q ""
}

/// CTOR: QP
/// DATE: 2017-06-13
/// DESC: 处理日期存储格式
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).DateHtmlToLogical("2017-06-03")
ClassMethod DateHtmlToLogical(d As %String) As %String [ Final ]
{
	n (d)
	
	s $ZT="Err"
	
	Q:d="" ""
	Q:d?1n.n d
	S format = ..GetDateFormat()
	//if d["-" Set format = 3
	//if d["/" Set format = 4
	Q $zdh(d,format)
}

/// CTOR: QP
/// DATE: 2017-06-13
/// DESC: 将日期数字串转换为Cache中日期格式
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComStrToDate("20170603")
ClassMethod ComStrToDate(str As %String) As %String [ Final ]
{
	n (str)
	
	s $ZT="Err"
	s rtn=""
	s year=$Extract(str,1,4)
	s month=$Extract(str,5,6)
	s day=$Extract(str,7,8)
	s rtn=year_"-"_month_"-"_day
	i rtn'="" s rtn=$zdh(rtn,3)
	q rtn
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 得到当前的审核人^审核日期^审核时间^审核状态
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetCurrentAuditInfo("1110")
ClassMethod GetCurrentAuditInfo(aid As %String) As %String
{
	n (aid)
	
	s (mRtn,mLogAuditUser,mLogAuditDate,mLogAuditTime,mLogStatus)=""
	q:'$d(^DHCAntBaseMainLogI("MLOGTypeCodeQuote","KSS","KSSPROCESS",aid)) mRtn
	s mLogId=$o(^DHCAntBaseMainLogI("MLOGTypeCodeQuote","KSS","KSSPROCESS",aid,""),-1)
	q:mLogId="" mRtn
	s mLogAuditUser=$p(^DHCAntBaseMainLogD(mLogId),"^",6)
	s mLogAuditDate=$p(^DHCAntBaseMainLogD(mLogId),"^",7)
	s mLogAuditTime=$p(^DHCAntBaseMainLogD(mLogId),"^",8)
	s mLogStatus=$p(^DHCAntBaseMainLogD(mLogId),"^",11)
	s mLogAction=$p(^DHCAntBaseMainLogD(mLogId),"^",12)
	s exitFlag=0
	
	i mLogAction="CE" d
	.s mLogId=""
	.f  s mLogId=$o(^DHCAntBaseMainLogI("MLOGTypeCodeQuote","KSS","KSSPROCESS",aid,mLogId),-1) q:(mLogId="")||(exitFlag=1)  d
	..s curStatus=$p(^DHCAntBaseMainLogD(mLogId),"^",11)
	..s mLogAuditUser=$p(^DHCAntBaseMainLogD(mLogId),"^",6)
	..s mLogAuditDate=$p(^DHCAntBaseMainLogD(mLogId),"^",7)
	..s mLogAuditTime=$p(^DHCAntBaseMainLogD(mLogId),"^",8)
	..s curAction=$p(^DHCAntBaseMainLogD(mLogId),"^",12)
	..i (curStatus=mLogStatus)&&(curAction'="CE") s exitFlag=1
	
	q:mLogAuditUser="" mRtn
	s mRtn=mLogAuditUser_"^"_mLogAuditDate_"^"_mLogAuditTime_"^"_mLogStatus
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 得到会诊记录上一个状态
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetConPrevStatus("1102")
ClassMethod GetConPrevStatus(aid As %String) As %String
{
	n (aid)
	q:aid="" ""
	s curProcess=$p(^DHCDAA("ANT",aid,1),"^",36)
	q:curProcess'["H" ""
	
	s pLen=$l(curProcess,","),prevNode=$p(curProcess,",",1)
	q:pLen<2 ""
	f cLen=2:1:pLen {
		s curNode=$p(curProcess,",",cLen)
		q:curNode="H"
		s prevNode=curNode
	}
	
	q prevNode
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 得到下一个审核步骤
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetNextStatusDesc("1102","F")
ClassMethod GetNextStatusDesc(aid As %String, curStatus As %String) As %String
{
	n (aid,curStatus)
	s mRtn=""
	q:aid="" mRtn
	s curProcess=$p(^DHCDAA("ANT",aid,1),"^",36)
	
	s pLen=$l(curProcess,","),nextNode=$p(curProcess,",",1)
	q:pLen<2 mRtn
	f cLen=1:1:pLen {
		s curNode=$p(curProcess,",",cLen)
		q:curNode=curStatus
	}
	s nextNode=$p(curProcess,",",(cLen+1))
	q:nextNode="" mRtn
	s mRtn=##class(DHCAnt.Base.MainConfigExcute).GetDescByMCGCode("PTYPE"_nextNode)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 得到当前状态下面的所有审核步骤
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetNextAllStatusDesc("1102","F")
ClassMethod GetNextAllStatusDesc(aid As %String, curStatus As %String, InHosp = "") As %String
{
	n (aid,curStatus,InHosp,%session)
	s ^TEPM("wxn")=$lb(aid,curStatus,InHosp)
	s mRtn=""
	q:aid="" mRtn
	s curProcess=$p(^DHCDAA("ANT",aid,1),"^",36)
	
	s pLen=$l(curProcess,","),nextNode=$p(curProcess,",",1)
	q:pLen<2 mRtn
	f cLen=1:1:pLen {
		s curNode=$p(curProcess,",",cLen)
		q:curNode=curStatus
	}
	s cLen=cLen+1
	f i=cLen:1:pLen {
		s curNode=$p(curProcess,",",i)
		if mRtn="" {
			//s mRtn=##class(DHCAnt.Base.MainConfigExcute).GetDescByMCGCode("PTYPE"_curNode,InHosp)
			s mRtn=##class(DHCAnt.Base.MainConfigExcute).GetOSDesc("PTYPE"_curNode)
		}else  {
			//s mRtn=mRtn_"、"_##class(DHCAnt.Base.MainConfigExcute).GetDescByMCGCode("PTYPE"_curNode,InHosp)
			s mRtn=mRtn_"、"_##class(DHCAnt.Base.MainConfigExcute).GetOSDesc("PTYPE"_curNode)
		}
	}
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-29
/// DESC: 得到当前节点的上一个节点
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetPrevNode("1102","F")
ClassMethod GetPrevNode(aid As %String, node As %String) As %String
{
	n (aid,node)
	s prevNode=""
	q:aid="" prevNode
	s curProcess=$p(^DHCDAA("ANT",aid,1),"^",36)
	q:curProcess'[node prevNode
	q:node="A" prevNode
	s pLen=$l(curProcess,","),prevNode=$p(curProcess,",",1)
	q:pLen<2 ""
	f cLen=2:1:pLen {
		s curNode=$p(curProcess,",",cLen)
		q:curNode=node
		s prevNode=curNode
	}
	
	q prevNode
}

/// CTOR: QP
/// DATE: 2017-06-29
/// DESC: 得到当前节点的上一个节点,通过日志
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetPrevNodeByKSSLog("1119","R")
ClassMethod GetPrevNodeByKSSLog(aid As %String, node As %String) As %String
{
	n (aid,node)
	s mRtn="",exitFlag=0,cLen=0
	q:'$d(^DHCAntBaseMainLogI("MLOGTypeCodeQuote","KSS","KSSPROCESS",aid)) mRtn
	s mLogId=""
	f  s mLogId=$o(^DHCAntBaseMainLogI("MLOGTypeCodeQuote","KSS","KSSPROCESS",aid,mLogId),-1) q:(mLogId="")||(exitFlag=1)  d
	.s curStatus=$p(^DHCAntBaseMainLogD(mLogId),"^",11)
	.s curAction=$p(^DHCAntBaseMainLogD(mLogId),"^",12)
	.s cLen=cLen+1
	.i curStatus=node s exitFlag=1
	q:exitFlag'=1 mRtn
	s cLen=cLen+1,mLogId="",mLen=0,exitFlag=0
	f  s mLogId=$o(^DHCAntBaseMainLogI("MLOGTypeCodeQuote","KSS","KSSPROCESS",aid,mLogId),-1) q:(mLogId="")||(exitFlag=1)  d
	.s curStatus=$p(^DHCAntBaseMainLogD(mLogId),"^",11)
	.s curAction=$p(^DHCAntBaseMainLogD(mLogId),"^",12)
	.s mLen=mLen+1
	.i mLen=cLen s exitFlag=1
	s mRtn=curStatus
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 得到抗菌素申请单的状态
/// 	  1  申请状态  0 已审核  -1  此医嘱没有对应的申请单
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetAntStatusForNurse("1110")
ClassMethod GetAntStatusForNurse(ConsultDR As %String)
{
	n (ConsultDR)
	q:ConsultDR="" -1
	s AppRowid=$o(^DHCDAAi("Consult",ConsultDR,0))
	q:AppRowid="" -1
	s Process=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",36)
	q:Process'["H" -1
	s mRtn=1
	s Status=$p(^DHCDAA("ANT",AppRowid),"^",12)
	i (Status="U")||(Status="R")||(Status="S") s mRtn=0
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-07-10
/// DESC: 判断是否为抗菌药物会诊医生
/// 	  1  是  0 不是
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComIfAntiConsultDoc("295")
ClassMethod ComIfAntiConsultDoc(curLoginDoc As %String)
{
	n (curLoginDoc)
	s isAntiDoc=0
	q:(curLoginDoc="")||(curLoginDoc=0) isAntiDoc
	s defaultConDoc=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("DEFAULTCONDOC")
	i ((defaultConDoc'="")&&(defaultConDoc'=0)) s defaultConDoc=..TransCTCareToSSUser(defaultConDoc)
	q:curLoginDoc=defaultConDoc 1
	
	s AntiId=""
    f  s AntiId=$O(^DHCAntBasePurposeDataConfigI("PDCType","CONDOC",AntiId)) q:(AntiId="")!(isAntiDoc=1)  d
    .s antiDoc=$p(^DHCAntBasePurposeDataConfigD(AntiId),"^",3)
    .s antiDoc=..TransCTCareToSSUser(antiDoc)
    .i curLoginDoc=antiDoc s isAntiDoc=1
	
	q isAntiDoc
}

/// CTOR: QP
/// DATE: 2017-07-10
/// DESC: 是否启用预防用药控制
/// 	  1  是  0 否
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComIfEnableYFDrug()
ClassMethod ComIfEnableYFDrug()
{
	n 
	s mRtn=0
	s yfDrug=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SUSEDRUGTIME")
	i ((yfDrug'="")&&(yfDrug'=0)) s mRtn=1
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 清除抗菌药物表所有数据,成功返回1，否则返回空
/// 	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ClearDHCAntAllData()
ClassMethod ClearDHCAntAllData()
{
	n
	&SQL(TRUNCATE TABLE SQLUser.DHCAntAdmCombinedSub)
	&SQL(TRUNCATE TABLE SQLUser.DHCAntAdmCombinedInfo)
	
	&SQL(TRUNCATE TABLE DHCAnt_Base.MainLog)
	&SQL(TRUNCATE TABLE SQLUser.DHC_AntUsePurpose)
	&SQL(TRUNCATE TABLE SQLUser.DHC_Doc_AntibioticApply)
	
   	;底下一般不做清理，在清理时慎重检查
   	&SQL(TRUNCATE TABLE SQLUser.DHC_CarPrvTpPHPCp)
	&SQL(TRUNCATE TABLE SQLUser.DHC_CarPrvTpPHPoison)
	&SQL(TRUNCATE TABLE DHCAnt_Base.PurposeDataConfig)
	&SQL(TRUNCATE TABLE DHCAnt_Base.MainConfig)
	
	q 1
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 清除业务数据
/// 	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ClearDHCAntBusinessData()
ClassMethod ClearDHCAntBusinessData()
{
	n
	&SQL(TRUNCATE TABLE SQLUser.DHCAntAdmCombinedSub)
	&SQL(TRUNCATE TABLE SQLUser.DHCAntAdmCombinedInfo)
	&SQL(TRUNCATE TABLE DHCAnt_Base.MainLog)
	&SQL(TRUNCATE TABLE SQLUser.DHC_AntUsePurpose)
	&SQL(TRUNCATE TABLE SQLUser.DHC_Doc_AntibioticApply)
	
	q 1
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 清除配置数据
/// 	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ClearDHCAntConfigData()
ClassMethod ClearDHCAntConfigData()
{
	n
	&SQL(delete from DHCAnt_Base.PurposeDataConfig 
				WHERE PDC_Type='CONLOC' OR PDC_Type='CONDOC')
   	&SQL(delete from DHCAnt_Base.MainConfig 
   				WHERE MCG_ParentCode='NOAUTHDOC')
	
	;清楚权限
	d ..DeleteDocAuth()
	;&SQL(TRUNCATE TABLE SQLUser.DHC_CarPrvTpPHPoison)
	
	;清楚医嘱项设置
	&SQL(TRUNCATE TABLE DHCAnt_Base.ItmMast)
	
	;清楚本地化参数设置
	k ^CF.ANT("LocalConfig")
	
	;清楚管制分类设置
	&SQL(TRUNCATE TABLE DHCAnt_Base_Config.PoisonSet)
	
	;清楚使用目的管控设置
	&SQL(TRUNCATE TABLE DHCAnt_Base_Config.UsePurposeManage)
	
	
	;清楚常规设置配置项
	&SQL(
		UPDATE DHCAnt_Base.MainConfig 
		SET MCG_ControlValue=NULL 
		WHERE MCG_Code IN ('OSKJ','ESKJ','ISKJ','SCKJ','MSGTIP',
		'SKSS3IND','SBJ','AUTHTODOC','AUTOAIM','AUTOOPEN','EMAGAIN',
		'DOCAUTHNUM','YFDRUGTIME','EMLEVEL','EMNUM','EOE','TWOAPP',
		'SMANYCONSULT','NOSELFCONLOC','CONDEPNUM','DEFAULTCONDEP','DEFAULTCONDOC',
		'LABWAY','LABOECATE','SCQMX','MCQMX','OETYPE','LOCALMODEL',
		'UPMYF','UPMZL','UPMYFLEVEL','UPMYFVAL','UPMZLLEVEL','UPMZLVAL',
		'DEFAULTCONDEP1','DEFAULTCONDOC1','DEFAULTCONDEP2','DEFAULTCONDOC2','DEFAULTCONDEP3','DEFAULTCONDOC3',
		'OATD','EATD','IATD'
		)
	)
	
	
	;清楚流程设置中最终审核科室和审核步骤
	&SQL(UPDATE DHCAnt_Base.MainConfig SET MCG_ControlType=NULL,MCG_ControlValue='A,F' WHERE MCG_Type='NEWPROCESS' AND MCG_Code='KSS2APP')
	&SQL(UPDATE DHCAnt_Base.MainConfig SET MCG_ControlType=NULL,MCG_ControlValue='A,F,H' WHERE MCG_Type='NEWPROCESS' AND MCG_Code='KSS3APPNOA')
	&SQL(UPDATE DHCAnt_Base.MainConfig SET MCG_ControlType=NULL,MCG_ControlValue='A,H' WHERE MCG_Type='NEWPROCESS' AND MCG_Code='KSS3APPA')
	
	
	;清楚致病菌
	&SQL(delete from DHCAnt_Base.PurposeDataConfig WHERE PDC_Type='ZBJ')
	
	;清楚联合用药原因
	&SQL(delete from DHCAnt_Base.PurposeDataConfig WHERE PDC_Type='CMB')
	
	;清楚联合用药变更原因
	&SQL(delete from DHCAnt_Base.PurposeDataConfig WHERE PDC_Type='CMBCHG')
			
	q 1
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 导出配置数据
/// 	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ExporConfigData()
ClassMethod ExporConfigData()
{
	n
	Do $System.OBJ.Export("DHCAntBaseMainConfigD.GBL","D:\temp\DHCAntBaseMainConfigD.xml")
	Do $System.OBJ.Export("DHCAntBaseMainConfigI.GBL","D:\temp\DHCAntBaseMainConfigI.xml")
	Do $System.OBJ.Export("DHCAntBasePurposeDataConfigD.GBL","D:\temp\DHCAntBasePurposeDataConfigD.xml")
	Do $System.OBJ.Export("DHCAntBasePurposeDataConfigI.GBL","D:\temp\DHCAntBasePurposeDataConfigI.xml")
	
	q 1
}

/// CTOR: QP
/// DATE: 2017-07-18
/// DESC: 获取医生权限个数，默认为1个
/// 	  1  是  0 否
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetDocAuthNum(2)
ClassMethod GetDocAuthNum(InHosp)
{
	n (InHosp)
	s mRtn=1
	Q:InHosp="" mRtn
	s docAuthNum=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("DOCAUTHNUM",InHosp)
	i ((docAuthNum'="")&&(docAuthNum'=0)) s mRtn=docAuthNum
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-07-18
/// DESC: 是否所有权限到医生
/// 	  1  是  0 否
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComIfAllAuthToDoc()
ClassMethod ComIfAllAuthToDoc()
{
	n 
	s mRtn=0
	s docAuthNum=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("AUTHTODOC")
	i ((docAuthNum'="")&&(docAuthNum'=0)) s mRtn=docAuthNum
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-07-18
/// DESC: 获取医护人员的9条抗生素权限
/// 	  1  是  0 否
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).Get9DocAuthById(6)
ClassMethod Get9DocAuthById(DoctorID)
{
	n (DoctorID)
	s ret=""
	if DoctorID="" Q ""
	k ^TEMP("DHCAnt","KSS",$j)
	s DoctorTypeRowId=$P($G(^CTPCP(DoctorID,1)),"^",4)
	if DoctorTypeRowId="" Q ""
	
	;处理处方权
	s MCGCode="F"_DoctorID
	s MCGID=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
	s MCGvalue=1
	i MCGID'="" d
	.s MCGactive=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",5) 
	.i MCGactive=1 d
	..s MCGvalue=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",9)
	q:MCGvalue=0 ""
	
    s AUTHTODOC=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("AUTHTODOC")
	s ret=""
	s Child=0 f  s Child=$O(^CT("CPT",DoctorTypeRowId,"PHPO",Child)) Q:Child=""  d
	.s PoisonRowId=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",1)
	.s PoisonCode=$p(^PHCPO(PoisonRowId),"^",1)
	.s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",2)
	.s TPPEpisodeType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",3)	;就诊类型
	.s tppChkVerify=$p(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",4)
	.s tppRowId=DoctorTypeRowId_"||"_Child // 主表id
	
	.i AUTHTODOC=1 s AntPrescBility="N"
	.e  s AntPrescBility="Y"
	.i $d(^CT(0,"CPDR",DoctorID,DoctorTypeRowId,Child)) d
	..s rowid=$o(^CT(0,"CPDR",DoctorID,DoctorTypeRowId,Child,""))
	..s AntPrescBility=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",5)
	..s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",8)
	..s tppChkVerify=$p(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",7)
	..s tppRowId=tppRowId_"||"_rowid
	.q:AntPrescBility'="Y"
	.s ^TEMP("DHCAnt","KSS",$j,TPPEpisodeType,PoisonCode)=PoisonRowId_"^"_ControlType_"^"_tppChkVerify_"^"_tppRowId
	
	Q ret
}

/// CTOR: QP
/// DATE: 2017-07-18
/// DESC: 获取医护人员的9条抗生素权限
/// 	  1  是  0 否
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetSingleDocAuth(6,"I","KSS1")
ClassMethod GetSingleDocAuth(DoctorID, AdmType, mPoisonCode, InHosp = "")
{
	n (DoctorID,AdmType,mPoisonCode,InHosp)
	s ret=""
	Q:InHosp="" ""
	if DoctorID="" Q ""
	s DoctorTypeRowId=$P($G(^CTPCP(DoctorID,1)),"^",4)
	if DoctorTypeRowId="" Q ""
	
	;处理处方权
	s MCGCode="F"_DoctorID
	s MCGID=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
	s MCGvalue=1
	i MCGID'="" d
	.s MCGactive=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",5) 
	.i MCGactive=1 d
	..s DateFrom=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",6) 
    ..s DateTo=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",7) 
    ..s HospId=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",14)
    ..q:HospId'=InHosp
    ..q:(DateTo<+$h)||(DateFrom>+$h)
	..s MCGvalue=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",9)
	q:MCGvalue=0 ""
	
    s AUTHTODOC=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("AUTHTODOC",InHosp)
	s ret=""
	s Child=0 f  s Child=$O(^CT("CPT",DoctorTypeRowId,"PHPO",Child)) Q:Child=""  d
	.s PoisonRowId=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",1)
	.s PoisonCode=$p(^PHCPO(PoisonRowId),"^",1)
	.s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",2)
	.s TPPEpisodeType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",3)	;就诊类型
	.s HospId=$p(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",5)
 	.q:(HospId'=InHosp)&&(InHosp'="")
	.q:TPPEpisodeType'=AdmType
	.q:PoisonCode'=mPoisonCode
	.s tppChkVerify=$p(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",4)
	.s tppRowId=DoctorTypeRowId_"||"_Child // 主表id
	
	.i AUTHTODOC=1 s AntPrescBility="N"
	.e  s AntPrescBility="Y"
	.i $d(^CT(0,"CPDR",DoctorID,DoctorTypeRowId,Child)) d
	..s rowid=$o(^CT(0,"CPDR",DoctorID,DoctorTypeRowId,Child,""))
	..s AntPrescBility=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",5)
	..s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",8)
	..s tppChkVerify=$p(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",7)
	..s tppRowId=tppRowId_"||"_rowid
	.q:AntPrescBility'="Y"
	.s ret=ControlType_"^"_tppChkVerify_"^"_tppRowId
	
	Q ret
}

/// CTOR: QP
/// DATE: 2017-07-18
/// DESC: 获取医护人员的9条抗生素权限
/// 	  1  是  0 否
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).Get9DocAuth(6)
ClassMethod Get9DocAuth(DoctorID, InHosp = "")
{
	n (DoctorID,InHosp)
	Q:InHosp="" ""
	s ^TEMP("Get9DocAuth",1)=DoctorID
	s ret=""
	if DoctorID="" Q ""
	s sperator="&",defaultValue="^^"
	s OKSS1=..GetSingleDocAuth(DoctorID,"O","KSS1",InHosp)
	s OKSS2=..GetSingleDocAuth(DoctorID,"O","KSS2",InHosp)
	s OKSS3=..GetSingleDocAuth(DoctorID,"O","KSS3",InHosp)
	i OKSS1="" s OKSS1=defaultValue
	i OKSS2="" s OKSS2=defaultValue
	i OKSS3="" s OKSS3=defaultValue
	s ret=OKSS1_"^"_OKSS2_"^"_OKSS3
	s EKSS1=..GetSingleDocAuth(DoctorID,"E","KSS1",InHosp)
	s EKSS2=..GetSingleDocAuth(DoctorID,"E","KSS2",InHosp)
	s EKSS3=..GetSingleDocAuth(DoctorID,"E","KSS3",InHosp)
	i EKSS1="" s EKSS1=defaultValue
	i EKSS2="" s EKSS2=defaultValue
	i EKSS3="" s EKSS3=defaultValue
	s ret=ret_"&"_EKSS1_"^"_EKSS2_"^"_EKSS3
	s IKSS1=..GetSingleDocAuth(DoctorID,"I","KSS1",InHosp)
	s IKSS2=..GetSingleDocAuth(DoctorID,"I","KSS2",InHosp)
	s IKSS3=..GetSingleDocAuth(DoctorID,"I","KSS3",InHosp)
	i IKSS1="" s IKSS1=defaultValue
	i IKSS2="" s IKSS2=defaultValue
	i IKSS3="" s IKSS3=defaultValue
	s ret=ret_"&"_IKSS1_"^"_IKSS2_"^"_IKSS3
	Q ret
}

/// CTOR: QP
/// DATE: 2017-07-18
/// DESC: 插入9条权限功能的配置
/// 	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).DBInsert9DocAuthConfig(9)
ClassMethod DBInsert9DocAuthConfig(cnum)
{
	n (cnum)
	s mcgId=$o(^DHCAntBaseMainConfigI("MCGCode","DOCAUTHNUM",""))
	if mcgId="" {
		&SQL(INSERT INTO SQLUser.DHCAnt_Base.MainConfig(MCG_Type,MCG_ParentCode,MCG_Code,MCG_Desc,MCG_Active,MCG_ControlValue) 
					VALUES("PARAMATER","PARA","DOCAUTHNUM","医生权限维护个数","1","9"))
	} else {
		&SQL(UPDATE DHCAnt_Base.MainConfig SET MCG_ControlValue=:cnum WHERE MCG_RowId=:mcgId)	
	}
	
	q SQLCODE
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 处理cache中的小数
/// 	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComDealToNum()
ClassMethod ComDealToNum(num)
{
	n (num)
	q:num="" num
	i num<1 s num="0"_num
	q num
}

/// CTOR: QP
/// DATE: 2017-08-14
/// DESC: 是否需要返送消息
/// OUT : 0:无记录，不发送
/// 		  1:正常流程，可以正常方式
///       2:越级流程，需在审核医嘱时发送	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetSendMsgType()
ClassMethod GetSendMsgType(aaid)
{
	n (aaid)
	s mRtn=0
	q:aaid="" mRtn
	q:'$d(^DHCDAA("ANT",aaid)) mRtn
	s oeori=$p(^DHCDAA("ANT",aaid,1),"^",6)
	s status=$p(^DHCDAA("ANT",aaid),"^",12)
	;q:status'="A" mRtn
	s emergency=$p(^DHCDAA("ANT",aaid,1),"^",23)
	i ((oeori'="")||(emergency'=1)) s mRtn=1
	i ((emergency=1)&&(status="A")) s mRtn=2
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-01-31
/// DESC: 获取最终审核科室
/// OUT : 
///       	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetFinallyLoc()
ClassMethod GetFinallyLoc(mcgCode As %String = "", InHosp = "")
{
	n (mcgCode,InHosp,%session)
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
	i mcgCode'="" d
	.i mcgCode'["U" s mcgCode=mcgCode_"U"
	s mRtn=""
	s kss2Loc=##class(DHCAnt.Base.MainConfigExcute).GetControlTypeByMCGCode("KSS2APPU",InHosp)
	i kss2Loc'="" s mRtn=kss2Loc
	
	s kss3LocA=##class(DHCAnt.Base.MainConfigExcute).GetControlTypeByMCGCode("KSS3APPAU",InHosp)
	i kss3LocA'="" d
	.i mRtn="" s mRtn=kss3LocA
	.e  s mRtn=mRtn_","_kss3LocA		;(kss3LocA'="")&&(mRtn'="")
	
	s kss3LocNOA=##class(DHCAnt.Base.MainConfigExcute).GetControlTypeByMCGCode("KSS3APPNOAU",InHosp)
	i kss3LocNOA'="" d
	.i mRtn="" s mRtn=kss3LocNOA
	.e  s mRtn=mRtn_","_kss3LocNOA	;(kss3LocNOA'="")&&(mRtn'="")
	
	i mcgCode'="" s mRtn=##class(DHCAnt.Base.MainConfigExcute).GetControlTypeByMCGCode(mcgCode,InHosp)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-01-31
/// DESC: 获取默认审核类型
/// OUT : F 科室预审，S 科室审核，U 最终审核 
///       	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetAuditType(4)
ClassMethod GetAuditType(locid As %String = "", inHosp = "")
{
	n (locid,inHosp)
	s mRtn="F"
	q:locid="" mRtn
	s uLocArr=..GetFinallyLoc("",inHosp)
	s uFlag=..InArray(uLocArr,locid)
	i uFlag=1 s mRtn="U"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-01-31
/// DESC: 获取是哪一步骤拒绝
/// OUT : FR 科室预审拒绝，SR 科室审核拒绝，UR 最终审核拒绝，HR 会诊拒绝 
///       	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetRefuseStep(1135)
ClassMethod GetRefuseStep(aid As %String = "")
{
	n (aid)
	s mRtn=""
	q:aid="" mRtn
	s curProcess=$p(^DHCDAA("ANT",aid,1),"^",36)
	s lastStep=..GetPrevNodeByKSSLog(aid,"R")
	q:lastStep="" mRtn
	i lastStep="A" d
	.i curProcess["F" s mRtn="FR"
	.e  i curProcess["H" s mRtn="HR"
	.e  i curProcess["S" s mRtn="SR"
	.e  s mRtn="UR"
	e  i lastStep="F" d
	.i curProcess["H" s mRtn="HR"
	.e  i curProcess["S" s mRtn="SR"
	.e  s mRtn="UR"
	e  i lastStep="H" d
	.i curProcess["S" s mRtn="SR"
	.e  s mRtn="UR"
	e  s mRtn="UR"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-01-17
/// DESC: 获取库存项皮试标志
/// OUT : 1/0
///       	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetPSFlag(1135)
ClassMethod GetPSFlag(arcim As %String = "")
{
	n (arcim)
	s mRtn = 0
	q:arcim="" mRtn
	s arc=+arcim,sub=$p(arcim,"||",2)
	q:arc="" mRtn
	s incItm=$O(^INCI(0,"ARCIM_DR",arc,""))
	q:incItm="" mRtn
	s incItmAddInfo=$o(^DHCITMINFO(0,"INCI",incItm,""))
	q:incItmAddInfo="" mRtn
	s SkinTest=$p(^DHCITMINFO(incItmAddInfo),"^",35)
	i SkinTest="Y" s mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-01-17
/// DESC: 获取门诊皮试用原液和住院皮试用原液 标志
/// OUT : 1/0
///       	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetOrderActionFlag("929||1","I")
ClassMethod GetOrderActionFlag(arcim As %String = "", admType As %String = "")
{
	n (arcim,admType)
	s mRtn = 0
	q:(arcim="")||(admType="") mRtn
	s arc=+arcim,sub=$p(arcim,"||",2)
	s phcdf=$p(^ARCIM(arc,sub,1),"^",12)
	q:phcdf="" mRtn
	s phc=+phcdf,phcsub=$p(phcdf,"||",2)
	s OPSkinTestYY=$P(^PHCD(phc,"DF",phcsub,"DHC"),"^",2)
	s IPSkinTestYY=$P(^PHCD(phc,"DF",phcsub,"DHC"),"^",3)
	i admType="I" s mRtn=IPSkinTestYY
	e  s mRtn=OPSkinTestYY
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-01-17
/// DESC: 获取皮试原液
/// ##Class(web.DHCDocOrderCommon).GetOrderAction("JSON")
/// OUT : 1/0
///       	  
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetOrderActionYY()
ClassMethod GetOrderActionYY() As %String
{
	n
	s mRtn=""
	s rowid=0 f  s rowid=$o(^OEC("ACT",rowid)) q:(rowid="")||(mRtn'="")  d
	.s code=$p($g(^OEC("ACT",rowid)),"^",1)
	.s desc=$p($g(^OEC("ACT",rowid)),"^",2)
	.i code="YY" s mRtn=rowid_"^"_desc
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 过滤医嘱状态
/// IN  : 1：退出
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.Common.Method).FilterOrdStatus("59||111")
ClassMethod FilterOrdStatus(oeori As %String) As %String
{
	n (oeori)
	s mRtn=1
	Q:oeori="" mRtn
	q:'$d(^OEORD(+oeori,"I",$p(oeori,"||",2),1)) mRtn
	s oeoriStatusDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)	//OEC_OrderStatus
	q:oeoriStatusDr="" mRtn
	s oeoriStatusCode=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	i ((oeoriStatusCode'="U")&&(oeoriStatusCode'="C")) s mRtn=0
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 工具方法，判断数值包含
/// IN  : 
/// OUT : 
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetArrayItem("7P^6A^5F","^",7)
ClassMethod GetArrayItem(kssarray As %String, sp As %String, key As %String) As %String
{
	n (kssarray,sp,key)
	s rtn=""
	i sp="" s sp=","
	s multiLen=$l(kssarray,sp)
	f len=1:1:multiLen {
		s data=$p(kssarray,sp,len)
		q:data="" 
		i data[key{
			s rtn=data
			q
		}
		
	}
	q rtn
}

/// CTOR: QP
/// DATE: 2021-11-11
/// DESC: 获取当前配置的翻译语言
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).%LanguageID()
ClassMethod %LanguageID() As %String
{
    Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    q langid
}

/// CTOR: QP
/// DATE: 2016-08-06
/// DESC: 得到抗肿瘤药物功能打开标志
/// OATD、EATD、IATD
/// OUT : 0:启用，1未启用
/// EXEC: d ##class(DHCAnt.KSS.Common.Method).GetATDSwitchFlag("I",2)
ClassMethod GetATDSwitchFlag(admType, inHosp = "") As %String
{
	n (admType,inHosp)
	s mRtn=1
	i admType="O" d
	.s oskjFlag=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("OATD",inHosp)
	.i oskjFlag=1 s mRtn=0
	
	i admType="E" d
	.s oskjFlag=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("EATD",inHosp)
	.i oskjFlag=1 s mRtn=0
	
	i admType="I" d
	.s oskjFlag=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("IATD",inHosp)
	.i oskjFlag=1 s mRtn=0
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-12-06
/// DESC: 清理抗菌药物医生权限数据
/// 
/// OUT : 
/// EXEC: d ##class(DHCAnt.KSS.Common.Method).DeleteDocAuth()
ClassMethod DeleteDocAuth() As %String
{
	s mRtn=0
	&SQL(delete from SQLUser.DHC_CarPrvTpPHPCp)
	&SQL(TRUNCATE TABLE SQLUser.DHC_CarPrvTpPHPoison)
	;清理垃圾索引
	k ^CT(0,"CPDR")
	
	;清理垃圾数据
	s ref=""
	f  s ref=$o(^CT("CPT",ref)) q:ref=""  d
	.s sub=""
	.f  s sub=$o(^CT("CPT",ref,"PHPO",sub)) q:sub=""  d
	..k ^CT("CPT",ref,"PHPO",sub)
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2022-04-19
/// DESC: 获取常用描述
/// IN  : Table: plan,dic,group
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetCommonDesc("1","user")
ClassMethod GetCommonDesc(ID As %String, Table As %String) As %String
{
	Q:(ID="")||(Table="") ""
	return $CASE(Table,
			"user":$p(^SSU("SSUSR",ID),"^",2),
			"loc":$p(^CTLOC(ID),"^",2),
			"hosp":$p(^CT("HOSP",ID),"^",2),
			"group":$p(^SSU("SSGRP",ID),"^",1),
			"sex":$p(^CT("SEX",ID),"^",2),
			"pat":$p(^PAPER(ID,"ALL"),"^",1),
			"doc":$p(^CTPCP(ID,1),"^",2),
			"kss":$p(^PHCPO(ID),"^",2),
			"doctp":$p(^CT("CPT",ID),"^",2),
			:""
		)
}

}
