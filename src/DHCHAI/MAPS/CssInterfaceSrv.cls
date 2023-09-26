/// 描述: 2022横断面调查数据上传接口
/// 编写者：chenjb
/// 编写日期: 2022-08-24
Class DHCHAI.MAPS.CssInterfaceSrv Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// 流水号的规范： "1970-01-01 00:00:00.000"至生成数据包的时点所有的毫秒数，左移 20 位。
/// w ##Class(DHCHAI.MAPS.CssInterfaceSrv).CurrTimeNo()
ClassMethod CurrTimeNo() As %String
{
	New 
	Set StDate = "1970-01-01"
	Set millsDiff=((((+$h)-$zdh(StDate,3))*(24*60*60))+(+$p($h,",",2)))*1000  //秒差
	Set millsDiff =millsDiff +$p($zts,".",2)  //毫秒差
	Quit millsDiff*(2**20)   //转为毫秒左移20位
}

/// Creator：     chenjb
/// CreatDate：   2022-08-24
/// Description:  摘要文件
/// Input：       RepIDs : 摘要数据
/// Return：      返回String
/// w ##class(DHCHAI.MAPS.CssInterfaceSrv).ExportReportSum("2","19,20","NIOA-1742130082143535104","")
ClassMethod ExportReportSum(aSurNo As %String, aRepIDs As %String, aFileName As %String, aUserDesc As %String) As %String
{
	New (aSurNo,aRepIDs,aFileName,aUserDesc)
	Set return=0
	Quit:(aSurNo="")||(aRepIDs="") return
	
	Set objSur = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNo)
	Quit:'$Isobject(objSur) return
	Set aDateFrom = objSur.SESurvSttDate
	Set aDateTo = objSur.SESurvEndDate
	Set:(+aDateTo)=0 aDateTo=aDateFrom
	Set aHospID = objSur.SEHospDr	
	Set aHospName =""
	Set objHosp =##class(DHCHAI.BT.Hospital).GetObjById(+aHospID)
	Set:$Isobject(objHosp) aHospName=objHosp.BTDesc
	Set DateFrom =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(aDateFrom)
	Set DateTo =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(aDateTo)	
	Set:aUserDesc="" aUserDesc="DHCHAI"  //
	
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  "
	Set Lv4 ="   "
	Set return="<?xml version=""1.0"" encoding=""UTF-8""?>"
	Set return=return_LineFlag_Lv1_"<userInfo>"
	
	Set return=return_LineFlag_Lv2_"<NIOASn>"_aFileName_"</NIOASn>"
	Set return=return_LineFlag_Lv2_"<type>2</type>"
	Set return=return_LineFlag_Lv2_"<dateFrom>"_DateFrom_"</dateFrom>"
	Set return=return_LineFlag_Lv2_"<dateTo>"_DateTo_"</dateTo>"
	Set year=$p(DateFrom,"-",1)
	Set month=$p(DateFrom,"-",2)
	Set return=return_LineFlag_Lv2_"<note>"_year_"年"_month_"月"_aHospName_"的院感现患率数据</note>"
	Set Date = $zd($p($h,",",1),3)
	Set Time = $zt($p($h,",",2),1)
	Set exportDate=Date_" "_Time	//数据包生成时间
	Set return=return_LineFlag_Lv2_"<exportDate>"_exportDate_"</exportDate>"
	Set Count=$l(aRepIDs,",") //调查病人总数
    
	Set return=return_LineFlag_Lv2_"<caseCount>"_Count_"</caseCount>"
	Set return=return_LineFlag_Lv2_"<loginUser>"_aUserDesc_"</loginUser>"
    
    Set return=return_LineFlag_Lv1_"</userInfo>"
	Quit return
}

/// w ##Class(DHCHAI.MAPS.CssInterfaceSrv).GetEpisodeMain(19)
ClassMethod GetEpisodeMain(aRepIDs As %String) As %String
{
	New (aRepIDs)
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  " 
	Set Lv4 ="   "
	
	Set xmlStream=##class(%GlobalCharacterStream).%New()
    Do xmlStream.Rewind()

	Do xmlStream.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	//Set return="<?xml version=""1.0"" encoding=""UTF-8""?>"
	
	Do xmlStream.Write(LineFlag_Lv1_"<data>")
	Do xmlStream.Write(LineFlag_Lv1_"<PatientMainList>")
	//循环
	For idx=1:1:$l(aRepIDs,",") {
		Set aRepID=$p(aRepIDs,",",idx)
		Do xmlStream.Write(LineFlag_Lv2_..GetEpisodeBasic(aRepID)) //基本信息	   
	}
	Do xmlStream.Write(LineFlag_Lv1_"</PatientMainList>")
	Do xmlStream.Write(LineFlag_Lv1_"</data>")
	Do xmlStream.%Close()
	Quit xmlStream.Read()
}

/// 横断面报告ID
/// 返回单个患者出入院信息 
/// w ##Class(DHCHAI.MAPS.CssInterfaceSrv).GetEpisodeBasic()
ClassMethod GetEpisodeBasic(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(aRepID)
	
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.IREpisodeDr) return
	Set objPaadm=objRep.IREpisodeDr
	
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  "
	
	Set return=Lv2_"<PatientMain>"
	If $IsObject(objPaadm){	
		Set BRID   =objPaadm.PAPapmiNo  //登记号
		Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"		
		//该住院患者在该医疗机构的第几次住院过程
		Set return =return_LineFlag_Lv3_"<PATIENTID>"_objPaadm.%Id()_"</PATIENTID>"
		//就诊科室编号
		Set LocCode=""
		Set LocDesc=""
		Set:$IsObject(objPaadm.PAAdmLocDr) LocDesc=objPaadm.PAAdmLocDr.BTDesc
		Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("科室名称",objPaadm.PAAdmLocDr.%Id(),LocDesc)
		Set:MapData'="" LocCode = $p(MapData,"^",1)
		Set:MapData'="" LocDesc = $p(MapData,"^",2)		
		Set return =return_LineFlag_Lv3_"<OFFICE>"_LocDesc_"</OFFICE>"
		Set return =return_LineFlag_Lv3_"<STANDOFFICEID>"_LocCode_"</STANDOFFICEID>"
		Set BEDNO=""
		Set:$IsObject(objPaadm.PAAdmBedDr) BEDNO=objPaadm.PAAdmBedDr.BTDesc
		Set return =return_LineFlag_Lv3_"<BEDNO>"_BEDNO_"</BEDNO>"
		Set CASEID=objPaadm.PAMrNo
		Set return =return_LineFlag_Lv3_"<CASEID>"_CASEID_"</CASEID>"
		Set PATIENTNAME = objPaadm.PAPatName
		Set return =return_LineFlag_Lv3_"<PATIENTNAME>"_PATIENTNAME_"</PATIENTNAME>"
		//*性别
		Set PATSEX=$s(objPaadm.PASex="F":"女",objPaadm.PASex="M":"男",1:"")		
		Set return =return_LineFlag_Lv3_"<PATSEX>"_PATSEX_"</PATSEX>"
		//年龄 10月14天,35岁
		Set PAAge=objPaadm.PAAge
		set AgeYear=0,AgeMonth=0,AgeDay=0
		if PAAge["岁" {
			set AgeYear=+PAAge
		} else {
			if ageData["月" {
				set AgeMonth=+ageData
				set AgeDay=+$p(ageData,"月",2)
			}elseif ageData["天"{
				set AgeDay=+ageData
			}else{
				set AgeDay=1
			}
		}
		Set return =return_LineFlag_Lv3_"<AGEY>"_AgeYear_"</AGEY>"
		Set return =return_LineFlag_Lv3_"<AGEM>"_AgeMonth_"</AGEM>"
		Set return =return_LineFlag_Lv3_"<AGED>"_AgeDay_"</AGED>"
		//IN_HOSP_AT
		Set INHOSPAT= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objPaadm.PAAdmDate)
		Set return =return_LineFlag_Lv3_"<IN_HOSP_AT>"_INHOSPAT_" 00:00:00"_"</IN_HOSP_AT>"
		//横断面表数据
		Set aCssID = +objRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
		Set objCss = ##class(DHCHAI.IR.INFCSS).GetObjById(aCssID)
		//疾病诊断 IRCSSDiagnosDr
		Set DIAGNOSE=""
		if $Isobject(objCss.IRCSSDiagnosDr)
		{
			//从新导入字典和标准版接口数据字典一致,不需要对照了
			//Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("疾病诊断",objCss.IRCSSDiagnosDr.%Id(),objCss.IRCSSDiagnosDr.BTDesc)
			//Set:MapData'="" LocCode = $p(MapData,"^",1)
			Set DIAGNOSE = objCss.IRCSSDiagnosDr.BTDesc
		}
		Set return =return_LineFlag_Lv3_"<DIAGNOSE>"_DIAGNOSE_"</DIAGNOSE>"
		//LHYY IRAntiCombinedMedDr
		Set LHYY=0
		if $Isobject(objCss.IRAntiCombinedMedDr)
		{
			Set tmpDesc = objCss.IRAntiCombinedMedDr.BTDesc
			Set:tmpDesc["一" LHYY =1
			Set:tmpDesc["二" LHYY =2
			Set:tmpDesc["三" LHYY =3
			Set:tmpDesc["四" LHYY =4			
		}
		Set return =return_LineFlag_Lv3_"<LHYY>"_LHYY_"</LHYY>"
		// IFINFECT
		Set IFINFECT="0"
		if $Isobject(objCss.IRInfectionDr)
		{
			Set tmpDesc = objCss.IRInfectionDr.BTDesc
			Set:tmpDesc="存在" IFINFECT ="1"
		}
		Set return =return_LineFlag_Lv3_"<IFINFECT>"_IFINFECT_"</IFINFECT>"
		// YYGR IRInfCategoryDr
		Set YYGR=0
		if $Isobject(objCss.IRInfCategoryDr)
		{
			Set tmpDesc = objCss.IRInfCategoryDr.BTDesc
			Set:tmpDesc="医院" YYGR ="1"
		}
		
		Set return =return_LineFlag_Lv3_"<YYGR>"_YYGR_"</YYGR>"
		// SQGR IRInfCategoryDr
		Set SQGR=0
		if $Isobject(objCss.IRInfCategoryDr)
		{
			Set tmpDesc = objCss.IRInfCategoryDr.BTDesc
			Set:tmpDesc="社区" SQGR ="1"
		}
		// FIRST_HOSP_INFECT
		if (objCss.IRFirInfDate'="")
		{
			Set return =return_LineFlag_Lv3_"<FIRST_HOSP_INFECT>"_objCss.IRFirInfDate_" 00:00:00"_"</FIRST_HOSP_INFECT>"
		}
		// INPUTDATE 上传时间
		Set Date = $zd($p($h,",",1),3)
		Set Time = $zt($p($h,",",2),1)
		Set INPUTDATE=Date_" "_Time	//数据包生成时间
		Set return =return_LineFlag_Lv3_"<INPUTDATE>"_INPUTDATE_"</INPUTDATE>"
		// VOTENAME IRSurvUser 调查人
		Set return =return_LineFlag_Lv3_"<VOTENAME>"_objCss.IRSurvUser_"</VOTENAME>"
		// 调查日期 IRUpdateDate IRUpdateTime
		Set tmpDt = $zd(objCss.IRUpdateDate,3)_" "_$zt(objCss.IRUpdateTime,1)		
		Set return =return_LineFlag_Lv3_"<VOTEDATE>"_tmpDt_"</VOTEDATE>"
		// IROperFlag
		Set OPERATOR =+objCss.IROperFlag		
		Set return =return_LineFlag_Lv3_"<OPERATOR>"_OPERATOR_"</OPERATOR>"
		// PYSJ IROperAntiFlag
		Set PYSJ =+objCss.IROperAntiFlag
		Set return =return_LineFlag_Lv3_"<PYSJ>"_PYSJ_"</PYSJ>"
		//用药目的
		Set YYMD=0
		if $Isobject(objCss.IRAntiUsePurposeDr)
		{
			Set tmpDesc = objCss.IRAntiUsePurposeDr.BTDesc
			Set:tmpDesc="治疗用药" YYMD ="1"
			Set:tmpDesc="预防用药" YYMD ="2"
			Set:tmpDesc="治疗+预防" YYMD ="3"
		}
		Set return =return_LineFlag_Lv3_"<YYMD>"_YYMD_"</YYMD>"
		//手术切口类型 OPERTION_INCISION
		Set OPERTIONINCISION=0
		if $Isobject(objCss.IROperCuteTypeDr)
		{
			Set tmpDesc = objCss.IROperCuteTypeDr.BTCode
			Set:tmpDesc="1" OPERTIONINCISION ="1"
			Set:tmpDesc="2" OPERTIONINCISION ="2"
			Set:tmpDesc="3" OPERTIONINCISION ="3"
			Set:tmpDesc="4" OPERTIONINCISION ="4"
		}
		Set return =return_LineFlag_Lv3_"<OPERTION_INCISION>"_OPERTIONINCISION_"</OPERTION_INCISION>"
		//治疗前送检 ZLYYSPY
		Set ZLYYSPY=+objCss.IRAntiSenFlag		
		Set return =return_LineFlag_Lv3_"<ZLYYSPY>"_ZLYYSPY_"</ZLYYSPY>"
		//审核状态 CHECKED IRStatusDr
		Set CHECKED=0
		if $Isobject(objRep.IRStatusDr)
		{
			Set tmpDesc = objRep.IRStatusDr.BTDesc
			Set:tmpDesc="审核" CHECKED=1
		}
		Set return =return_LineFlag_Lv3_"<CHECKED>"_CHECKED_"</CHECKED>"
		//是否术后肺炎 SSHFY IROprInf
		Set SSHFY=0
		if $Isobject(objCss.IROprInf)
		{
			Set tmpDesc = objCss.IROprInf.BTDesc
			Set:tmpDesc="是" SSHFY=1
		}
		Set return =return_LineFlag_Lv3_"<SSHFY>"_SSHFY_"</SSHFY>"
		//抗菌药物使用标识 KJYWSY 
		Set KJYWSY=0
		Set KJYWSY=+objCss.IRAntiFlag
		Set return =return_LineFlag_Lv3_"<KJYWSY>"_KJYWSY_"</KJYWSY>"
		//标本是否革兰染色 BBGLRS
		Set BBGLRS=0
		Set BBGLRS=+objCss.IRCSSSpecGLFlag
		Set return =return_LineFlag_Lv3_"<BBGLRS>"_BBGLRS_"</BBGLRS>"
		//标本是否抗酸染色 BBKSRS
		Set BBKSRS=0
		Set BBKSRS=+objCss.IRCSSSpecKSFlag
		Set return =return_LineFlag_Lv3_"<BBKSRS>"_BBKSRS_"</BBKSRS>"
		//标本基因测序 BBJYCX
		Set BBJYCX=0
		Set BBJYCX=+objCss.IRCSSSpecJYFlag
		Set return =return_LineFlag_Lv3_"<BBJYCX>"_BBJYCX_"</BBJYCX>"
		//标本墨汁染色 BBMZRS
		Set BBMZRS=0
		Set BBMZRS=+objCss.IRCSSSpecMZFlag
		Set return =return_LineFlag_Lv3_"<BBMZRS>"_BBMZRS_"</BBMZRS>"
		//外院感染 WYGR 
		Set WYGR=0
		Set:(+objCss.SQMethod1)=1 WYGR=1
		Set:(+objCss.SQMethod2)=1 WYGR=1
		Set:(+objCss.SQMethod3)=1 WYGR=1
		Set return =return_LineFlag_Lv3_"<WYGR>"_WYGR_"</WYGR>"
	}
	Set return=return_LineFlag_Lv2_"</PatientMain>"
	Quit return
}

/// w ##Class(DHCHAI.MAPS.CssInterfaceSrv).GetEpisodeInfs(19)
ClassMethod GetEpisodeInfs(aRepIDs As %String) As %String
{
	New (aRepIDs)
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  " 
	Set Lv4 ="   "
	
	Set xmlStream=##class(%GlobalCharacterStream).%New()
    Do xmlStream.Rewind()

	Do xmlStream.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	//Set return="<?xml version=""1.0"" encoding=""UTF-8""?>"
	
	Do xmlStream.Write(LineFlag_Lv1_"<data>")
	Do xmlStream.Write(LineFlag_Lv1_"<InfectInfoList>")
	//循环
	For idx=1:1:$l(aRepIDs,",") {
		Set aRepID=$p(aRepIDs,",",idx)
		Set RstInf = ..GetEpisodeInf(aRepID)
		Do:RstInf'="" xmlStream.Write(LineFlag_Lv2_RstInf) //感染信息	   
	}
	Do xmlStream.Write(LineFlag_Lv1_"</InfectInfoList>")
	Do xmlStream.Write(LineFlag_Lv1_"</data>")
	Do xmlStream.%Close()
	Quit xmlStream.Read()
}

/// 横断面报告ID
/// 返回单个患者出入院信息 
/// w ##Class(DHCHAI.MAPS.CssInterfaceSrv).GetEpisodeInf()
ClassMethod GetEpisodeInf(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(aRepID)
	
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.IREpisodeDr) return
	Set objPaadm=objRep.IREpisodeDr
	//判断没有感染返回空 横断面表数据
	Set aCssID = +objRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
	Set objCss = ##class(DHCHAI.IR.INFCSS).GetObjById(aCssID)
	Set IFINFECT="0"
	if $Isobject(objCss.IRInfectionDr)
	{
		Set tmpDesc = objCss.IRInfectionDr.BTDesc
		Set:tmpDesc="存在" IFINFECT ="1"
	}
	Quit:IFINFECT'="1" return
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  "	
	
	// DIAGID
	if (objCss.IRInfPathogen1'="######")
	{
		Set xInfID = +objCss.IRInfPathogen1
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		
		Set:return'="" return=return_LineFlag_Lv2_"<InfectInfo>"
		Set:return="" return=Lv2_"<InfectInfo>"
		Set BTCode =objInf.%Id()
		Set BTDesc =objInf.BTDesc
		Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("感染诊断部位",BTCode,BTDesc)
		Set:MapData'="" BTCode = $p(MapData,"^",1)
		Set:MapData'="" BTDesc = $p(MapData,"^",2)		
		//感染诊断编号
		Set return =return_LineFlag_Lv3_"<DIAGID>"_BTCode_"</DIAGID>"	
		Set return =return_LineFlag_Lv3_"<INFECTTYPE>1</INFECTTYPE>"
			
		Set BRID   =objPaadm.PAPapmiNo  //登记号
		Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
		//感染编号唯一 GRID
		Set GRID=""
		Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
		Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
		//感染诊断名称 INFECTDIAG
		Set return =return_LineFlag_Lv3_"<INFECTDIAG>"_BTDesc_"</INFECTDIAG>"
		Set return=return_LineFlag_Lv2_"</InfectInfo>"
	}
	// DIAGID
	if (objCss.IRInfPathogen2'="######")
	{
		Set xInfID = +objCss.IRInfPathogen2
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		Set:return'="" return=return_LineFlag_Lv2_"<InfectInfo>"
		Set:return="" return=Lv2_"<InfectInfo>"
		Set BTCode =objInf.%Id()
		Set BTDesc =objInf.BTDesc
		Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("感染诊断部位",BTCode,BTDesc)
		Set:MapData'="" BTCode = $p(MapData,"^",1)
		Set:MapData'="" BTDesc = $p(MapData,"^",2)		
		//感染诊断编号
		Set return =return_LineFlag_Lv3_"<DIAGID>"_BTCode_"</DIAGID>"	
		Set return =return_LineFlag_Lv3_"<INFECTTYPE>1</INFECTTYPE>"
			
		Set BRID   =objPaadm.PAPapmiNo  //登记号
		Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
		//感染编号唯一 GRID
		Set GRID=""
		Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
		Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
		//感染诊断名称 INFECTDIAG
		Set return =return_LineFlag_Lv3_"<INFECTDIAG>"_BTDesc_"</INFECTDIAG>"
		Set return=return_LineFlag_Lv2_"</InfectInfo>"
	}
	// DIAGID
	if (objCss.IRInfPathogen3'="######")
	{
		Set xInfID = +objCss.IRInfPathogen3
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		Set:return'="" return=return_LineFlag_Lv2_"<InfectInfo>"
		Set:return="" return=Lv2_"<InfectInfo>"
		Set BTCode =objInf.%Id()
		Set BTDesc =objInf.BTDesc
		Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("感染诊断部位",BTCode,BTDesc)
		Set:MapData'="" BTCode = $p(MapData,"^",1)
		Set:MapData'="" BTDesc = $p(MapData,"^",2)		
		//感染诊断编号
		Set return =return_LineFlag_Lv3_"<DIAGID>"_BTCode_"</DIAGID>"	
		Set return =return_LineFlag_Lv3_"<INFECTTYPE>1</INFECTTYPE>"
			
		Set BRID   =objPaadm.PAPapmiNo  //登记号
		Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
		//感染编号唯一 GRID
		Set GRID=""
		Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
		Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
		//感染诊断名称 INFECTDIAG
		Set return =return_LineFlag_Lv3_"<INFECTDIAG>"_BTDesc_"</INFECTDIAG>"
		Set return=return_LineFlag_Lv2_"</InfectInfo>"
	}
	
	if (objCss.IRComInfPathogen1'="######")
	{
		Set xInfID = +objCss.IRComInfPathogen1
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		Set:return'="" return=return_LineFlag_Lv2_"<InfectInfo>"
		Set:return="" return=Lv2_"<InfectInfo>"
		Set BTCode =objInf.%Id()
		Set BTDesc =objInf.BTDesc
		Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("感染诊断部位",BTCode,BTDesc)
		Set:MapData'="" BTCode = $p(MapData,"^",1)
		Set:MapData'="" BTDesc = $p(MapData,"^",2)		
		//感染诊断编号
		Set return =return_LineFlag_Lv3_"<DIAGID>"_BTCode_"</DIAGID>"	
		Set return =return_LineFlag_Lv3_"<INFECTTYPE>2</INFECTTYPE>"
			
		Set BRID   =objPaadm.PAPapmiNo  //登记号
		Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
		//感染编号唯一 GRID
		Set GRID=""
		Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
		Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
		//感染诊断名称 INFECTDIAG
		Set return =return_LineFlag_Lv3_"<INFECTDIAG>"_BTDesc_"</INFECTDIAG>"
		Set return=return_LineFlag_Lv2_"</InfectInfo>"
	}
	if (objCss.IRComInfPathogen2'="######")
	{
		Set xInfID = +objCss.IRComInfPathogen2
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		Set:return'="" return=return_LineFlag_Lv2_"<InfectInfo>"
		Set:return="" return=Lv2_"<InfectInfo>"
		Set BTCode =objInf.%Id()
		Set BTDesc =objInf.BTDesc
		Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("感染诊断部位",BTCode,BTDesc)
		Set:MapData'="" BTCode = $p(MapData,"^",1)
		Set:MapData'="" BTDesc = $p(MapData,"^",2)		
		//感染诊断编号
		Set return =return_LineFlag_Lv3_"<DIAGID>"_BTCode_"</DIAGID>"	
		Set return =return_LineFlag_Lv3_"<INFECTTYPE>2</INFECTTYPE>"
			
		Set BRID   =objPaadm.PAPapmiNo  //登记号
		Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
		//感染编号唯一 GRID
		Set GRID=""
		Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
		Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
		//感染诊断名称 INFECTDIAG
		Set return =return_LineFlag_Lv3_"<INFECTDIAG>"_BTDesc_"</INFECTDIAG>"
		Set return=return_LineFlag_Lv2_"</InfectInfo>"
	}
	if (objCss.IRComInfPathogen3'="######")
	{
		Set xInfID = +objCss.IRComInfPathogen3
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		Set:return'="" return=return_LineFlag_Lv2_"<InfectInfo>"
		Set:return="" return=Lv2_"<InfectInfo>"
		Set BTCode =objInf.%Id()
		Set BTDesc =objInf.BTDesc
		Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("感染诊断部位",BTCode,BTDesc)
		Set:MapData'="" BTCode = $p(MapData,"^",1)
		Set:MapData'="" BTDesc = $p(MapData,"^",2)		
		//感染诊断编号
		Set return =return_LineFlag_Lv3_"<DIAGID>"_BTCode_"</DIAGID>"	
		Set return =return_LineFlag_Lv3_"<INFECTTYPE>2</INFECTTYPE>"
			
		Set BRID   =objPaadm.PAPapmiNo  //登记号
		Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
		//感染编号唯一 GRID
		Set GRID=""
		Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
		Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
		//感染诊断名称 INFECTDIAG
		Set return =return_LineFlag_Lv3_"<INFECTDIAG>"_BTDesc_"</INFECTDIAG>"
		Set return=return_LineFlag_Lv2_"</InfectInfo>"
	}
	Quit return
}

/// w ##Class(DHCHAI.MAPS.CssInterfaceSrv).GetEpisodePathos(20)
ClassMethod GetEpisodePathos(aRepIDs As %String) As %String
{
	New (aRepIDs)
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  " 
	Set Lv4 ="   "
	
	Set xmlStream=##class(%GlobalCharacterStream).%New()
    Do xmlStream.Rewind()

	Do xmlStream.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	//Set return="<?xml version=""1.0"" encoding=""UTF-8""?>"
	
	Do xmlStream.Write(LineFlag_Lv1_"<data>")
	Do xmlStream.Write(LineFlag_Lv1_"<PathoInfoList>")
	//循环
	For idx=1:1:$l(aRepIDs,",") {
		Set aRepID=$p(aRepIDs,",",idx)
		Set RstInf = ..GetEpisodePatho(aRepID)
		Do:RstInf'="" xmlStream.Write(LineFlag_Lv2_RstInf) //病原体信息	   
	}
	Do xmlStream.Write(LineFlag_Lv1_"</PathoInfoList>")
	Do xmlStream.Write(LineFlag_Lv1_"</data>")
	Do xmlStream.%Close()
	Quit xmlStream.Read()
}

/// 横断面报告ID
/// 返回单个患者出入院信息 
/// w ##Class(DHCHAI.MAPS.CssInterfaceSrv).GetEpisodePatho()
ClassMethod GetEpisodePatho(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(aRepID)
	
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.IREpisodeDr) return
	Set objPaadm=objRep.IREpisodeDr
	//判断没有感染返回空 横断面表数据
	Set aCssID = +objRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
	Set objCss = ##class(DHCHAI.IR.INFCSS).GetObjById(aCssID)
	Set IFINFECT="0"
	if $Isobject(objCss.IRInfectionDr)
	{
		Set tmpDesc = objCss.IRInfectionDr.BTDesc
		Set:tmpDesc="存在" IFINFECT ="1"
	}
	Quit:IFINFECT'="1" return
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  "	
	
	// DIAGID
	if (objCss.IRInfPathogen1'="######")
	{
		Set xInfID = +objCss.IRInfPathogen1
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRInfPathogen1,"#",2)
		Set xPatho2= $p(objCss.IRInfPathogen1,"#",4)
		Set xPatho3= $p(objCss.IRInfPathogen1,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho1_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho2_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho3_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
	}
	// DIAGID
	if (objCss.IRInfPathogen2'="######")
	{
		Set xInfID = +objCss.IRInfPathogen2
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRInfPathogen2,"#",2)
		Set xPatho2= $p(objCss.IRInfPathogen2,"#",4)
		Set xPatho3= $p(objCss.IRInfPathogen2,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho1_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho2_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho3_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
	}
	// DIAGID
	if (objCss.IRInfPathogen3'="######")
	{
		Set xInfID = +objCss.IRInfPathogen3
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRInfPathogen3,"#",2)
		Set xPatho2= $p(objCss.IRInfPathogen3,"#",4)
		Set xPatho3= $p(objCss.IRInfPathogen3,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho1_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho2_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho3_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
	}
	
	if (objCss.IRComInfPathogen1'="######")
	{
		Set xInfID = +objCss.IRComInfPathogen1
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRComInfPathogen1,"#",2)
		Set xPatho2= $p(objCss.IRComInfPathogen1,"#",4)
		Set xPatho3= $p(objCss.IRComInfPathogen1,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho1_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho2_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho3_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
	}
	if (objCss.IRComInfPathogen2'="######")
	{
		Set xInfID = +objCss.IRComInfPathogen2
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRComInfPathogen2,"#",2)
		Set xPatho2= $p(objCss.IRComInfPathogen2,"#",4)
		Set xPatho3= $p(objCss.IRComInfPathogen2,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho1_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho2_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho3_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
	}
	if (objCss.IRComInfPathogen3'="######")
	{
		Set xInfID = +objCss.IRComInfPathogen3
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRComInfPathogen3,"#",2)
		Set xPatho2= $p(objCss.IRComInfPathogen3,"#",4)
		Set xPatho3= $p(objCss.IRComInfPathogen3,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho1_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho2_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set:return'="" return=return_LineFlag_Lv2_"<PathoInfo>"
			Set:return="" return=Lv2_"<PathoInfo>"
			Set BTCode =objPatho.%Id()
			Set BTDesc =objPatho.BTBacDesc
			Set MapData = ##class(DHCHAI.MAPS.CssMappingSrv).GetBaseMapDescV2("病原体",BTCode,BTDesc)
			Set:MapData'="" BTCode = $p(MapData,"^",1)
			Set:MapData'="" BTDesc = $p(MapData,"^",2)				
			Set BRID   =objPaadm.PAPapmiNo  //登记号
			Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
			//感染编号唯一 GRID
			Set GRID=""
			Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
			Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
			Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_xPatho3_"</BYTID>"
			Set return =return_LineFlag_Lv3_"<PATHOID>"_BTCode_"</PATHOID>"
			Set return =return_LineFlag_Lv3_"<PATHONAME>"_BTDesc_"</PATHONAME>"
			Set Date = $zd($p($h,",",1),3)
			Set Time = $zt($p($h,",",2),1)
			Set exportDate=Date_" "_Time	//数据包生成时间
			Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
			//药敏 
			Set return =return_LineFlag_Lv3_"<PATHORESULT></PATHORESULT>"
			Set return=return_LineFlag_Lv2_"</PathoInfo>"
		}
	}
	Quit return
}

/// w ##Class(DHCHAI.MAPS.CssInterfaceSrv).GetEpisodeAntis(20)
ClassMethod GetEpisodeAntis(aRepIDs As %String) As %String
{
	New (aRepIDs)
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  " 
	Set Lv4 ="   "
	
	Set xmlStream=##class(%GlobalCharacterStream).%New()
    Do xmlStream.Rewind()

	Do xmlStream.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	//Set return="<?xml version=""1.0"" encoding=""UTF-8""?>"
	
	Do xmlStream.Write(LineFlag_Lv1_"<data>")
	Do xmlStream.Write(LineFlag_Lv1_"<AntibInfoList>")
	//循环
	For idx=1:1:$l(aRepIDs,",") {
		Set aRepID=$p(aRepIDs,",",idx)
		Set RstInf = ..GetEpisodeAnti(aRepID)
		Do:RstInf'="" xmlStream.Write(LineFlag_Lv2_RstInf) //病原体信息	   
	}
	Do xmlStream.Write(LineFlag_Lv1_"</AntibInfoList>")
	Do xmlStream.Write(LineFlag_Lv1_"</data>")
	Do xmlStream.%Close()
	Quit xmlStream.Read()
}

/// 横断面报告ID
/// 返回单个患者出入院信息 # 取余
/// w ##Class(DHCHAI.MAPS.CssInterfaceSrv).GetEpisodeAnti()
ClassMethod GetEpisodeAnti(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(aRepID)
	
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.IREpisodeDr) return
	Set objPaadm=objRep.IREpisodeDr
	//判断没有感染返回空 横断面表数据
	Set aCssID = +objRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
	Set objCss = ##class(DHCHAI.IR.INFCSS).GetObjById(aCssID)
	Set IFINFECT="0"
	if $Isobject(objCss.IRInfectionDr)
	{
		Set tmpDesc = objCss.IRInfectionDr.BTDesc
		Set:tmpDesc="存在" IFINFECT ="1"
	}
	Quit:IFINFECT'="1" return
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  "	
	
	// DIAGID
	if (objCss.IRInfPathogen1'="######")
	{
		Set xInfID = +objCss.IRInfPathogen1
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRInfPathogen1,"#",2)
		Set xPatho2= $p(objCss.IRInfPathogen1,"#",4)
		Set xPatho3= $p(objCss.IRInfPathogen1,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
	}
	// DIAGID
	if (objCss.IRInfPathogen2'="######")
	{
		Set xInfID = +objCss.IRInfPathogen2
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRInfPathogen2,"#",2)
		Set xPatho2= $p(objCss.IRInfPathogen2,"#",4)
		Set xPatho3= $p(objCss.IRInfPathogen2,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
	}
	// DIAGID
	if (objCss.IRInfPathogen3'="######")
	{
		Set xInfID = +objCss.IRInfPathogen3
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRInfPathogen3,"#",2)
		Set xPatho2= $p(objCss.IRInfPathogen3,"#",4)
		Set xPatho3= $p(objCss.IRInfPathogen3,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="1"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
	}
	
	if (objCss.IRComInfPathogen1'="######")
	{
		Set xInfID = +objCss.IRComInfPathogen1
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRComInfPathogen1,"#",2)
		Set xPatho2= $p(objCss.IRComInfPathogen1,"#",4)
		Set xPatho3= $p(objCss.IRComInfPathogen1,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
	}
	if (objCss.IRComInfPathogen2'="######")
	{
		Set xInfID = +objCss.IRComInfPathogen2
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRComInfPathogen2,"#",2)
		Set xPatho2= $p(objCss.IRComInfPathogen2,"#",4)
		Set xPatho3= $p(objCss.IRComInfPathogen2,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
	}
	if (objCss.IRComInfPathogen3'="######")
	{
		Set xInfID = +objCss.IRComInfPathogen3
		Set objInf = ##class(DHCHAI.BT.InfPos).GetObjById(xInfID)
		//枚举3个
		Set xPatho1= $p(objCss.IRComInfPathogen3,"#",2)
		Set xPatho2= $p(objCss.IRComInfPathogen3,"#",4)
		Set xPatho3= $p(objCss.IRComInfPathogen3,"#",6)		
		if (xPatho1'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho1)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho2'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho2)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
		if (xPatho3'="")
		{
			Set objPatho=##class(DHCHAI.DP.LabBacteria).GetObjById(xPatho3)
			Set tmpAntiSen = objCss.IRBugsAntiSen
			Set PathoName = objPatho.BTBacDesc
			//取特定菌药敏 金黄色葡萄球菌||1||6#	19006 苯唑西林 19074 头孢西丁	
			if (PathoName="金黄色葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",3)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",3)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",5)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",5)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}			
			//凝固酶阴性葡萄球菌||||#
			if (PathoName="凝固酶阴性葡萄球菌")
			{
				if ($p(tmpAntiSen,"|",7)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19006"
					Set BTDesc ="苯唑西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",7)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",9)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19074"
					Set BTDesc ="头孢西丁"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",9)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//粪肠球菌||||# 19010 氨苄西林  19105 万古霉素
			if (PathoName="粪肠球菌")
			{
				if ($p(tmpAntiSen,"|",11)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",11)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",13)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",13)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//屎肠球菌||||#
			if (PathoName="屎肠球菌")
			{
				if ($p(tmpAntiSen,"|",15)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19010"
					Set BTDesc ="氨苄西林"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",15)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",17)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19105"
					Set BTDesc ="万古霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",17)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
			}
			//肺炎链球菌||# 
			if (PathoName="肺炎链球菌")
			{
				if ($p(tmpAntiSen,"|",19)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="01001"
					Set BTDesc ="青霉素"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",19)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//大肠埃希菌||||||#
			if (PathoName="大肠埃希菌")
			{
				if ($p(tmpAntiSen,"|",21)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",21)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",23)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",23)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",25)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",25)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//肺炎克雷伯菌||||||#
			if (PathoName="肺炎克雷伯菌")
			{
				if ($p(tmpAntiSen,"|",27)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",27)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",29)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",29)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",31)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19152"
					Set BTDesc ="左氧氟沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",31)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}				
			}
			//铜绿假单胞菌||1||5||||||||#
			if (PathoName="铜绿假单胞菌")
			{
				if ($p(tmpAntiSen,"|",33)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19143"
					Set BTDesc ="环丙沙星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",33)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",35)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19022"
					Set BTDesc ="哌拉西林和他唑巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",35)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",37)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",37)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",39)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19058"
					Set BTDesc ="头孢他啶"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",39)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",41)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19070"
					Set BTDesc ="头孢吡肟"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",41)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}	
				if ($p(tmpAntiSen,"|",43)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19094"
					Set BTDesc ="阿米卡星"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",43)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}		
			}
			//鲍曼不动杆菌||||
			if (PathoName="鲍曼不动杆菌")
			{
				if ($p(tmpAntiSen,"|",45)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="03202"
					Set BTDesc ="亚胺培南或美罗培南"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",45)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}
				if ($p(tmpAntiSen,"|",47)'="")
				{
					Set:return'="" return=return_LineFlag_Lv2_"<AntibInfo>"
					Set:return="" return=Lv2_"<AntibInfo>"
					Set BTCode ="19069"
					Set BTDesc ="头孢哌酮和舒巴坦"			
					Set BRID   =objPaadm.PAPapmiNo  //登记号
					Set return =return_LineFlag_Lv3_"<BRID>"_BRID_"</BRID>"
					//感染编号唯一 GRID
					Set GRID=""
					Set GRID ="2"_aCssID_xInfID  //组合形成 横断面报告ID+感染诊断ID
					Set return =return_LineFlag_Lv3_"<GRID>"_GRID_"</GRID>"
					Set return =return_LineFlag_Lv3_"<BYTID>"_GRID_objPatho.%Id()_"</BYTID>"
					// 药敏药物编号 唯一 DURGID
					Set return =return_LineFlag_Lv3_"<DURGID>"_GRID_objPatho.%Id()_BTCode_"</DURGID>"
					Set return =return_LineFlag_Lv3_"<TROCHEID>"_BTCode_"</TROCHEID>"
					Set return =return_LineFlag_Lv3_"<ANTIBNAME>"_BTDesc_"</ANTIBNAME>"					
					//药敏 ANTIBRESULT
					Set ANTIBRESULT=""
					Set SenRst = +$p(tmpAntiSen,"|",47)
					Set:(SenRst#3)=1 ANTIBRESULT="耐药"
					Set:(SenRst#3)=2 ANTIBRESULT="敏感"
					Set:(SenRst#3)=0 ANTIBRESULT="未做"
					Set return =return_LineFlag_Lv3_"<ANTIBRESULT>"_ANTIBRESULT_"</ANTIBRESULT>"
					Set Date = $zd($p($h,",",1),3)
					Set Time = $zt($p($h,",",2),1)
					Set exportDate=Date_" "_Time	//数据包生成时间
					Set return =return_LineFlag_Lv3_"<INPUTDATE>"_exportDate_"</INPUTDATE>"
					Set return=return_LineFlag_Lv2_"</AntibInfo>"
				}							
			}
		}
	}
	Quit return
}

}
