/// 名称: DHCHAI.IO.ToSzNIDPSrv
/// 描述: 与深圳质控平台相关接口
/// 编写者：chenjb
/// 编写日期: 2019-07-25
Class DHCHAI.IO.ToSzNIDPSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 流水号 唯一性:"1970-01-01 00:00:00.000"至生成数据包的时点所有的毫秒数，左移 20 位
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).CurrTimeNo()
ClassMethod CurrTimeNo() As %String
{
	New 
	Set StDate = "1970-01-01"
	Set millsDiff=((((+$h)-$zdh(StDate,3))*(24*60*60))+(+$p($h,",",2)))*1000  //秒差
	Set millsDiff =millsDiff +$p($zts,".",2)  //毫秒差
	Quit millsDiff*(2**20)   //转为毫秒左移20位
}

/// 查询条件默认日期周期 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetDateBetweenStr()
ClassMethod GetDateBetweenStr() As %String
{
	New 
	Set return=""
	//上个月的整月范围
	Set aYYMMDD = $zd(+$h,3)
	Set $p(aYYMMDD,"-",3)="01"
	Set MM = +$p(aYYMMDD,"-",2)
	Set YYYY = +$p(aYYMMDD,"-",1)
	Set DateFrom = ""
	if (MM=1)
	{
		Set MM = 12
		Set YYYY =YYYY-1
		Set DateFrom = YYYY_"-"_MM_"-"_"01"
	}
	else
	{
		Set MM = MM-1
		Set:MM>9 DateFrom = YYYY_"-"_MM_"-"_"01"
		Set:MM<10 DateFrom = YYYY_"-0"_MM_"-"_"01"
	}
	Set DateTo = $zdh(aYYMMDD,3)-1
	Set return=DateFrom_"^"_$zd(DateTo,3)
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2019-07-25
/// Description:  去字符串中的特殊字符
/// Input：       aInputStr
///               aExceptChar   去掉特殊字符配置
/// Return：      去除特殊字符的字符串
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).ChangeKeyStr("dsf&123")
ClassMethod ChangeKeyStr(aInputStr As %String, aExceptChar As %String = "") As %String
{
	New (aInputStr,aExceptChar)
	Quit:aInputStr="" aInputStr
	Set:aExceptChar'["&" aInputStr = $REPLACE(aInputStr,"&","&amp;")       //
	Set:aExceptChar'["<" aInputStr = $REPLACE(aInputStr,"<","&lt;")        // 
	Set:aExceptChar'[">" aInputStr = $REPLACE(aInputStr,">","&gt;")        // 	
	Set:aExceptChar'["""" aInputStr =$REPLACE(aInputStr,"""","&quot;")     //
	Set:aExceptChar'["'" aInputStr = $REPLACE(aInputStr,"'","&apos;")      //
	
	Quit aInputStr
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeDtls(1)
ClassMethod GetEpisodeDtls(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  "
	Set return="<?xml version=""1.0"" encoding=""UTF-8""?>"
	Set return=return_LineFlag_Lv1_"<caseinfo>"
	Set return=return_LineFlag_Lv1_..GetEpisodeBasic(aEpisodeID,Lv2,LineFlag)  //基本信息
	Set return=return_LineFlag_Lv1_..GetEpisodeDeptList(aEpisodeID,Lv2,LineFlag)   //转病区信息
	Set return=return_LineFlag_Lv1_..GetEpisodeInfinstList(aEpisodeID,Lv2,LineFlag)   //感染诊断信息
	Set return=return_LineFlag_Lv1_..GetEpisodeBactList(aEpisodeID,Lv2,LineFlag)   //微生物信息
	Set return=return_LineFlag_Lv1_..GetEpisodeTreatList(aEpisodeID,Lv2,LineFlag)   //侵袭性操作
	Set return=return_LineFlag_Lv1_..GetEpisodeAntiList(aEpisodeID,Lv2,LineFlag)   //抗菌药物
	Set return=return_LineFlag_Lv1_..GetEpisodeOperList(aEpisodeID,Lv2,LineFlag)   //手术信息
	Set return=return_LineFlag_Lv1_..GetEpisodeDiagList(aEpisodeID,Lv2,LineFlag)   //诊断信息
	Set return=return_LineFlag_Lv1_..GetEpisodeRoutList(aEpisodeID,Lv2,LineFlag)   //感染相关标记物检验信息
	Set return=return_LineFlag_Lv1_..GetEpisodeTempList(aEpisodeID,Lv2,LineFlag)   //体温
	Set return=return_LineFlag_Lv1_..GetEpisodeInfList(aEpisodeID,Lv2,LineFlag)   //临床及感控科处理预警信息
	
	Set return=return_LineFlag_Lv1_"</caseinfo>"
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeBasic(27539)
ClassMethod GetEpisodeBasic(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Set return = aLv_"<basic"
	if $Isobject(objPaadm)
	{
		Set caseid = objPaadm.PAMrNo_"("_objPaadm.PAAdmTimes_")"
		Set return =return_" caseid="""_caseid_""""
		Set return =return_" pid="""_objPaadm.PAMrNo_""""   //病案号
		Set return =return_" vid="""_objPaadm.PAAdmTimes_""""   //住院次数
		//*性别
		Set Sex=objPaadm.PASex
		If (Sex="F") { //M男、F女、O其他
			Set Sex="女"
		} ElseIf (Sex="M") {
			Set Sex="男"
		} Else {
			Set Sex="男"
		}
		Set return =return_" sex="""_Sex_""""   //
		//出生日期
		Set PABirthday=objPaadm.PABirthday
		Set:PABirthday'="" PABirthday=$zd(PABirthday,3)
		Set return =return_" birthday="""_PABirthday_""""   //
		//出生体重
		Set weight="0.0"
		Set:+objPaadm.PAAdmitWeight>0 weight=(+objPaadm.PAAdmitWeight)/1000
		Set return =return_" weight="""_weight_""""
		//就诊时间
		Set PAAdmDate=objPaadm.PAAdmDate		
		Set PaAdmTime = objPaadm.PAAdmTime
		//##Class(DHCHAI.IO.ToSzNIDPSrv).GetAdmInBedDT(29095)
			
		//就诊病区编码
		//Set admDept =objPaadm.PAAdmWardDr
		//入院病区
		Set deptInfo = ..GetTransLocInfo(aEpisodeID,"W")
		Set deptDr = $p(deptInfo,"^",2)
		Set admDept=##class(DHCHAI.BT.Location).GetObjById(deptDr)
		Set:'$Isobject(admDept) admDept =objPaadm.PAAdmWardDr
		Set:$Isobject(admDept) admDept = admDept.BTCode
		Set:$p(deptInfo,"^",1)'="" PAAdmDate =$p(deptInfo,"^",1)
		//取分床时间
		Set BedDt = ##Class(DHCHAI.IO.ToSzNIDPSrv).GetAdmInBedDT(aEpisodeID)
		If (BedDt=""){
			//处理分床时间为空报错
			Set EpisodeIDx = objPaadm.PAEpisodeIDx
			Set AdmDate=$p($g(^PAADM($p(EpisodeIDx,"||",2))),"^",6)
			Set AdmTime=$p($g(^PAADM($p(EpisodeIDx,"||",2))),"^",7)
			Set BedDt=AdmDate_"^"_AdmTime
		}
		Set:$p(BedDt,"^",1)'="" PAAdmDate = $p(BedDt,"^",1)
		Set:$p(BedDt,"^",2)'="" PaAdmTime = $p(BedDt,"^",2)
		
		Set:PAAdmDate'="" PAAdmDate=$zd(PAAdmDate,3)
		Set:PaAdmTime'="" PAAdmDate=PAAdmDate_" "_$zt(PaAdmTime,1)	
		
		Set return =return_" admTime="""_PAAdmDate_""""   //
		Set return =return_" admDept="""_admDept_""""
		Set disTime ="9999"
		if (objPaadm.PAVisitStatus="D")||(objPaadm.PADischDate'="")
		{
			Set disTime =""
			//出院时间
			Set:objPaadm.PADischDate'="" disTime =$zd(objPaadm.PADischDate,3)
			Set:objPaadm.PADischTime'="" disTime =disTime_" "_$zt(objPaadm.PADischTime,1)
			Set return =return_" disTime="""_disTime_""""
			//出院病区编码
			Set disDept =objPaadm.PADischWardDr
			Set:$Isobject(disDept) disDept = disDept.BTCode
			Set return =return_" disDept="""_disDept_""""
			Set disWay="未死亡" //20190916-正常改为未死亡
			Set:objPaadm.PAIsDeath disWay="死亡"
			Set return =return_" disWay="""_disWay_""""				
		}
		else
		{
			Set return =return_" disTime="""_disTime_""""			
		}
		Set selfreport = "0"
		//支持(成人|新生儿)报告同时查询
		Set aRepType ="1|2"
		For Ind = 1:1:$length(aRepType,"|"){
			Set xRepType = $p(aRepType,"|",Ind)
			Continue:xRepType=""		
			Set xRepID=0
			Set (ReportUserID,ReportUserDesc)=""
			Set (ReportDate,ReportTime,ReportStatusID,ReportStatusCode,ReportStatusDesc)=""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xRepID))
				Quit:xRepID=""
				Set ReportID=xRepID
				Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
				Continue:'$IsObject(objReport)
				If $IsObject(objReport.IRStatusDr) {
					Set ReportStatusID=objReport.IRStatusDr.%Id()
					Set ReportStatusCode=objReport.IRStatusDr.BTCode
					Set ReportStatusDesc=objReport.IRStatusDr.BTDesc
				}
				
				Continue:(ReportStatusCode'="3")  //提交审核的报告 (ReportStatusCode'="2")&
				Set selfreport=1
			}
		}
		Set return =return_" selfreport="""_selfreport_""""
	}
	Set return = return_"/>"
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeDeptList(29035,$c(2)," ")
ClassMethod GetEpisodeDeptList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return =""
	//无数据
	Set DeptData = ""
	Set LvN=" "	
	Set aLocType = "W" //病区
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Set BedDt = ##Class(DHCHAI.IO.ToSzNIDPSrv).GetAdmInBedDT(aEpisodeID)
	//就诊时间
	Set PAAdmDate=objPaadm.PAAdmDate		
	Set PaAdmTime = objPaadm.PAAdmTime
	Set:$p(BedDt,"^",1)'="" PAAdmDate = $p(BedDt,"^",1)
	Set:$p(BedDt,"^",2)'="" PaAdmTime = $p(BedDt,"^",2)
	Set disDate = objPaadm.PADischDate
	Set disTime = objPaadm.PADischTime
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate))
		Quit:xDate=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate,xID))
			Quit:xID=""
			
			Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xID)
			Continue:'$IsObject(objTrans)
			Continue:'$IsObject(objTrans.PATransLocDr)
			Set objLoc=objTrans.PATransLocDr
			Continue:'$IsObject(objLoc.BTTypeDr)
			Set LocType=objLoc.BTTypeDr.BTCode
			Set LocID=objLoc.%Id()
			Set LocCode = objLoc.BTCode
			Set LocDesc=objLoc.BTDesc
			Set LocDesc2=objLoc.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set TransDate=objTrans.PATransDate	//PATransTime	
			Set TransTime=objTrans.PATransTime
			
			//处理以分床为入院时间
			Set:(TransDate=PAAdmDate)&(TransTime<PaAdmTime) TransTime=PaAdmTime
			Set:TransDate<PAAdmDate TransTime =PaAdmTime
			Set:TransDate<PAAdmDate TransDate =PAAdmDate			
			//w $zt(TransTime,1),!
			Set:TransDate'="" TransDate=$zd(TransDate,3)
			Set:TransTime'="" TransDate=TransDate_" "_$zt(TransTime,1)
			//Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set TOutDate = objTrans.PAOutLocDate  //PAOutLocTime
			Set TOutTime = objTrans.PAOutLocTime			
			if (TOutDate'="")
			{
				Set:(TOutDate=PAAdmDate)&(TOutTime<PaAdmTime) TOutTime=PaAdmTime				
				Set:TOutDate<PAAdmDate TOutTime =PaAdmTime
				Set:TOutDate<PAAdmDate TOutDate =PAAdmDate
								
				Set:(TOutDate=disDate)&(TOutTime>disTime) TOutTime=disTime
				Set:(disTime'="")&(TOutDate>disDate) TOutTime=disTime
				Set:(disDate'="")&(TOutDate>disDate) TOutDate=disDate
				//已经出科
				Set:TOutDate'="" TOutDate=$zd(TOutDate,3)
				Set:TOutTime'="" TOutDate=TOutDate_" "_$zt(TOutTime,1)				
			}
			else
			{
				//未出科 9999
				Set TOutDate="9999"
			}
			Set:DeptData'="" DeptData = DeptData_aLineFlag_aLv_LvN_"<dept dept="""_LocCode_""" timeFrom="""_TransDate_""" timeTo="""_TOutDate_"""/>"
			Set:DeptData="" DeptData = aLineFlag_aLv_LvN_"<dept dept="""_LocCode_""" timeFrom="""_TransDate_""" timeTo="""_TOutDate_"""/>"
			
		}
	}
	Set return = aLv_"<dept-list>"	
	Set:DeptData'="" return=return_DeptData
	Set return=return_aLineFlag_aLv_"</dept-list>"	
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeInfinstList(33959,$c(2)," ")
ClassMethod GetEpisodeInfinstList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return =""
	Set InfinstDataAll=""
	Set LvN = " "
	//就诊患者对象
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Set AdmitDate=objPaadm.PAAdmDate
	Set AdmitTime=objPaadm.PAAdmTime
	//以院感报告为主
	//支持(成人|新生儿)报告同时查询
	Set aRepType ="1|2"
	For Ind = 1:1:$length(aRepType,"|"){
		Set xRepType = $p(aRepType,"|",Ind)
		Continue:xRepType=""		
		Set xRepID=0
		Set (ReportUserID,ReportUserDesc)=""
		Set (ReportDate,ReportTime,ReportStatusID,ReportStatusCode,ReportStatusDesc)=""
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xRepID))
			Quit:xRepID=""			
			Set ReportID=xRepID
			Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
			Continue:'$IsObject(objReport)
			If $IsObject(objReport.IRStatusDr) {
				Set ReportStatusID=objReport.IRStatusDr.%Id()
				Set ReportStatusCode=objReport.IRStatusDr.BTCode
				Set ReportStatusDesc=objReport.IRStatusDr.BTDesc
			}
			
			Continue:(ReportStatusCode'="3")  //提交审核的报告 (ReportStatusCode'="2")&
			Set ReportDate=objReport.IRRepDate
			Set ReportTime=objReport.IRRepTime
			Set factorData=""  //侵害性操作
			Set aDataType = "DHCHAI.IR.INFPreFactor"
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),ReportID,xSub))
				Quit:xSub=""				
				Set RepExtID=ReportID_"||"_xSub
				Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
				Continue:'$IsObject(obj)
				Set ObjectID=obj.IRObjectID
				Continue:ObjectID=""
				Set objFactor=##class(DHCHAI.IR.INFPreFactor).GetObjById(ObjectID)
				Continue:'$Isobject(objFactor.IRPreFactorDr)
				Set:factorData'="" factorData=factorData_aLineFlag_aLv_LvN_LvN_"<factor>"_objFactor.IRPreFactorDr.BTDesc_"</factor>"
				Set:factorData="" factorData=aLineFlag_aLv_LvN_LvN_"<factor>"_objFactor.IRPreFactorDr.BTDesc_"</factor>"
			}		
			Set aDataType = "DHCHAI.IR.INFDiagnos"
			Set InfDiagList=objReport.GetRepLinkIDs(aDataType)
			For indInfD=1:1:$l(InfDiagList,","){													
				Set xInfDiagnosID=$p(InfDiagList,",",indInfD)
				Continue:xInfDiagnosID=""
				Set objDias=##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagnosID)
				Continue:'$IsObject(objDias.IRInfPosDr)
				Set InfPosDesc=objDias.IRInfPosDr.BTDesc  //感染部位-> 是否考虑有诊断分类取诊断分类
				If $IsObject(objDias.IRInfSubDr) {
					Set xInfDiagDesc=objDias.IRInfSubDr.BTDesc
					Set:xInfDiagDesc'="" InfPosDesc=InfPosDesc_"("_xInfDiagDesc_")"
				}
				//If $IsObject(objDias.IRInfSubDr) {}
				Set InfDate = objDias.IRInfDate
				Set itime = $zd(InfDate,3)  //_" 23:59:59"  //用的默认时间 不要时间
				Set idept = ""  //23:59:59零点？入院时间？
				Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"23:59:59") 
				Set WardDr = $p(TransInfo,"^",2)
				Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
				Set:$Isobject(objWard) idept = objWard.BTCode
				Set isite = "院内"
				Set:InfDate-AdmitDate<2 isite="院外"				
				Set InfinstData =aLineFlag_aLv_LvN_"<infinst instid=""IG"_xInfDiagnosID_""" itime="""_itime_""" idept="""_idept_""""
				Set InfinstData=InfinstData_" ipart="""_InfPosDesc_""" isite="""_isite_""""
				Set oc = objDias.IRInfEffectDr  //治愈、恶化、携带
				if ($Isobject(oc))
				{
					Set oc = oc.BTDesc
					Set:oc="好转" oc="治愈"
					Set:oc="无变化" oc="携带"
					Set:oc="死亡" oc="恶化"					
					Set octime =objDias.IRInfXDate
					Set:octime'="" octime = $zd(octime,3)
					Set ocreporttime = $zd(ReportDate,3)_" "_$zt(ReportTime,1)   //报告时间
					Set InfinstData=InfinstData_" oc="""_oc_""" octime="""_octime_""" ocreporttime="""_ocreporttime_""""
				}
				Set InfinstData=InfinstData_">"
				if (factorData="")
				{
					Set InfinstData =InfinstData_aLineFlag_aLv_LvN_"<factor-list/>"
				}
				else
				{
					Set InfinstData =InfinstData_aLineFlag_aLv_LvN_"<factor-list>"
					Set InfinstData =InfinstData_factorData
					Set InfinstData =InfinstData_aLineFlag_aLv_LvN_"</factor-list>"
				}
				//<diag-list>感染诊断信息 个人所有的确诊征兆
				Set diagDataAll = ""
				Set xScreenID = ""
				For {
					Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
					Quit:xScreenID=""
					Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
					Continue:'$IsObject(objScreen)
					Continue:+objScreen.CSStatus'=1
					Set diagData=aLineFlag_aLv_LvN_LvN_"<diag diagid="""_xScreenID_""""
					If (objScreen.CSItmScreenDr.%Id()=2)
					{
						Set diagData=diagData_" bact="""_objScreen.CSItmScreenTxt_""" note="""_objScreen.CSItmScreenTxt_"""" 
					}
					else
					{
						Set diagData=diagData_" note="""_objScreen.CSItmScreenDr.CCDesc_"""" 
					}
					Set generatetime=""
					Set generatetime = $zd(objScreen.CSRstFromDate,3)
					Set:generatetime'="" generatetime=generatetime_" 23:59:59"  //征兆的生成时间
					Set reportDoctor = objReport.IRRepUser.BTDesc  //上报人
					Set reporttimeR = $zd(ReportDate,3)_" "_$zt(ReportTime,1)					
					Set confirmer=""  //审核人
					Set xLogDr=""
					For {
						Set xLogDr=$o(^DHCHAI.IR.INFReportD(ReportID,"LOG",xLogDr),-1)
						Quit:(xLogDr="")||(confirmer'="")
						Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(ReportID_"||"_xLogDr)
						Continue:'$IsObject(objLog)
						Continue:'$IsObject(objLog.IRStatusDr)
						Set StatusCode=objLog.IRStatusDr.BTCode
						Continue:(StatusCode'="3")   // 审核
						Set confirmer = objLog.IRUpdateUserDr.BTDesc
						Set confirmedtime=$zd(objLog.IRUpdateDate,3)_" "_$zt(objLog.IRUpdateTime,1)
					}
					//Set diagData=diagData_" state=""确认"" generatetime="""_generatetime_""" reportdoctor="""_reportDoctor_""""
					//Set diagData=diagData_" reporttime="""_reporttimeR_""" reportcontent=""1"" confirmer="""_confirmer_""" confirmedtime="""_confirmedtime_""""
					//Set diagData=diagData_" infected_time="""_itime_""" infected_dept="""_idept_""" isnosocomial="""_isite_""""
					Set diagData=diagData_"/>"
					Set:diagDataAll'="" diagDataAll=diagDataAll_diagData
					Set:diagDataAll="" diagDataAll=diagData					
				}
				if (diagDataAll="")
				{
					//自报感染
					Set diagData=aLineFlag_aLv_LvN_LvN_"<diag diagid=""INF"_xInfDiagnosID_""""
					
					Set diagData=diagData_" note=""自报感染""" 				
					Set reportDoctor = objReport.IRRepUser.BTDesc  //上报人
					Set reporttimeR = $zd(ReportDate,3)_" "_$zt(ReportTime,1)	
					Set generatetime=reporttimeR			
					Set confirmer=""  //审核人
					Set xLogDr=""
					For {
						Set xLogDr=$o(^DHCHAI.IR.INFReportD(ReportID,"LOG",xLogDr),-1)
						Quit:(xLogDr="")||(confirmer'="")
						Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(ReportID_"||"_xLogDr)
						Continue:'$IsObject(objLog)
						Continue:'$IsObject(objLog.IRStatusDr)
						Set StatusCode=objLog.IRStatusDr.BTCode
						Continue:(StatusCode'="3")   // 审核
						Set confirmer = objLog.IRUpdateUserDr.BTDesc
						Set confirmedtime=$zd(objLog.IRUpdateDate,3)_" "_$zt(objLog.IRUpdateTime,1)
					}
					//Set diagData=diagData_" state=""确认"" generatetime="""_generatetime_""" reportdoctor="""_reportDoctor_""""
					//Set diagData=diagData_" reporttime="""_reporttimeR_""" reportcontent=""1"" confirmer="""_confirmer_""" confirmedtime="""_confirmedtime_""""
					//Set diagData=diagData_" infected_time="""_itime_""" infected_dept="""_idept_""" isnosocomial="""_isite_""""
					Set diagData=diagData_"/>"
					Set diagDataAll = diagData
				}
				Set InfinstData =InfinstData_aLineFlag_aLv_LvN_"<diag-list>"
				Set InfinstData =InfinstData_diagDataAll
				Set InfinstData =InfinstData_aLineFlag_aLv_LvN_"</diag-list>"
				Set InfinstData = InfinstData_aLineFlag_aLv_"</infinst>"  //增加闭环
				Set:InfinstDataAll'="" InfinstDataAll=InfinstDataAll_InfinstData
				Set:InfinstDataAll="" InfinstDataAll=InfinstData
			}				
		}		
	}	
	if (InfinstDataAll="")
	{
		//无数据	
		Set return = aLv_"<infinst-list/>"	
	}
	else
	{
		Set return = aLv_"<infinst-list>"_InfinstDataAll
		Set return =return_aLineFlag_aLv_"</infinst-list>"
	}	
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeBactList(44976,$c(2)," ")
ClassMethod GetEpisodeBactList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set aTestSetDr =1  //检验医嘱分类表ID
	Set return =""
	Set BactDataAll = ""  //送检及检出菌数据
	Set LvN = " "  //层级缩进格式
	Set AdmDate =0  //入院日期
	Set AdmTime =0
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)	
	Set:$Isobject(objPaadm) AdmDate = objPaadm.PAAdmDate
	Set:$Isobject(objPaadm) AdmTime = objPaadm.PAAdmTime
	Set xVisitNumberDr="" 
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$isobject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		Set SCode=objVisitNumber.LabSCode
		
		Set CollDate=objVisitNumber.LabCollDate		//采集日期
		Set CollTime=objVisitNumber.LabCollTime
		
		Set RecDate=objVisitNumber.LabRecDate		//接收日期
		Set RecTime=objVisitNumber.LabRecTime
		
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		Set IPHour=((CollDate-AdmDate)*24)+((CollTime-AdmTime)\3600)  //排除CA入院小于48小时
		Set site = "院内"
		Set itype ="HA"
		Set:IPHour<=48 site = "院外"	
		Set:IPHour<=48 itype = "CA"	
		//取病区编码
		Set LocCode 	= ""
		Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,CollDate,CollTime)
		Set WardDr = $p(TransInfo,"^",2)
		Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
		Set:$Isobject(objWard) LocCode = objWard.BTCode
		
		Set:CollDate'="" CollDate=$zd(CollDate,3)
		Set:CollTime'="" CollTime=$zt(CollTime,1)
		
		Set SCode	 	= objVisitNumber.LabSCode  //子系统
		Set EpisodeNo 	= objVisitNumber.LabEpisodeNo
		Set Specimen 	= objVisitNumber.LabSpecimen
	
		/*
		If $isobject(objVisitNumber.LabLocDr){
			Set:LocCode="" LocCode=objVisitNumber.LabLocDr.BTCode			
		}*/
		// 检查送检记录是否是（检出菌、常规检验、PCT（降钙素原）、CRP（C反映蛋白）、G试验、M试验）
		Set xTestSetDesc="",checkFlg=0
		For {
			Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			
			Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))
			Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
			Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
			Continue:'$isobject(objTestSetMap)
			Continue:'$isobject(objTestSetMap.BTMapItemDr)
			Set checkFlg =1
		}
		Continue:checkFlg=0
		
		Kill arrVisitReport
		Set xTestSetDr=""
		
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
				Continue:'$IsObject(objVisitReport)
				
				Set Status = objVisitReport.LabStatus
				//Continue:Status=6	//作废
				Set IsActive = objVisitReport.LabIsActive
				//Continue:IsActive=0
				
				Set VisitReportID = objVisitReport.%Id()
				Set LabReportID = objVisitReport.LabReportID
				Set LabRepOrder = objVisitReport.LabRepOrder
				Set AuthDate=objVisitReport.LabAuthDate
				Set FlagBug = +$zdh("2019-11-01",3)
				Continue:(IsActive=0)&(AuthDate>=FlagBug)  //历史处理状态问题20191101才开始判断
				Set AuthTime=objVisitReport.LabAuthTime
				Set:AuthDate'="" AuthDate=$zd(AuthDate,3)
				Set:AuthTime'="" AuthTime=$zt(AuthTime,1)
				
				Set objVisitTestSet=objVisitReport.LabTestSetDr
				Continue:'$IsObject(objVisitTestSet)
				Set TestSetDesc=objVisitTestSet.LabTestSetDesc
				Set OrdTsDesc=objVisitTestSet.LabOrdTSDesc
				//Set OrdTsDesc = TestSetDesc
				//b:objVisitNumber.LabEpisodeNo="10381457" //3
				//add by zf 20171212 增加检验类型过滤
				
				If aTestSetDr'="" {
					Set objTSMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,TestSetDesc)
					Continue:'$IsObject(objTSMap)
					Continue:'$IsObject(objTSMap.BTMapItemDr)
					Set TSMapItemDr=objTSMap.BTMapItemDr.%Id()
					Continue:TSMapItemDr'=aTestSetDr
				}
				
				Set CollDateR=CollDate
				Set AuthDateR=AuthDate
				
				Set:CollTime'="" CollDateR=CollDate_" "_CollTime
				Set:AuthTime'="" AuthDateR=AuthDate_" "_AuthTime	
						
				//Set Data=$lb(xVisitNumberDr,EpisodeNo,OrdTsDesc,Specimen,LocDesc,CollDateR,VisitReportID,AuthDateR,CollTime)
				//组织数据异常标识
				Set abr = 0
				Set xRstID=0
				For {
					Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",VisitReportID,xRstID))
					Quit:xRstID=""
					//b:xVisitNumberDr=348758
					Set objRst=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRstID)
					Continue:'$IsObject(objRst)
					Set ResultID=objRst.%Id()
					Set TestCode=objRst.LabTestCode
					Continue:TestCode=""					
					Set TestDesc=objRst.LabTestDesc
					Set RstFormat=objRst.LabRstFormat
					Continue:RstFormat=""
					Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
					Continue:MapRstFormat=""
					Continue:MapRstFormat'="M"
					Set Bacteria=objRst.LabResult
					Continue:Bacteria=""						
					Set abr=1  //"检出菌"
					Set SusData=""  //药敏
					Set idiagid=..GetINFReportsDia(aEpisodeID,VisitReportID)
					Set xAntDesc=""
					For {
						Set xAntDesc = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",ResultID,xAntDesc))
						Quit:xAntDesc=""
						
						Set xSenID = ""
						For {
							Set xSenID = $o(^DHCHAI.DP.LabVisitRepRstSenI("IndexResultDrAntDesc",ResultID,xAntDesc,xSenID))
							Quit:xSenID=""
						
							Set objRstSen = ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
							Continue:'$isobject(objRstSen)
							Set objResult = objRstSen.LabResultDr
							Continue:'$isobject(objResult)
							Continue:'$isobject(objResult.LabReportDr)							
							
							Set AntCode 	= objRstSen.LabAntCode
							Set AntDesc 	= objRstSen.LabAntDesc
							Set objAntiMap = ##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(SCode,AntDesc)
							Set AntID = ""
							If $isobject(objAntiMap){
								if objAntiMap.BTIsActive=1{
									if $isobject(objAntiMap.BTMapItemDr){
										Set AntID = objAntiMap.BTMapItemDr.%Id()
										Set AntDesc = objAntiMap.BTMapItemDr.BTAntDesc
										Set AntCode = objAntiMap.BTMapItemDr.BTAntCode
									}
								}
							}
							Set Sensitivity = objRstSen.LabSensitivity
							Set SensitivityID = ""
							Set SenPhraseMap = ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"LABTestRstSen",Sensitivity)
							If SenPhraseMap'=""{
								Set SensitivityID = $p(SenPhraseMap,"^",1)
								Set Sensitivity = $p(SenPhraseMap,"^",3)
							}
							Continue:SensitivityID=""  // modi 1217 Sensitivity=""
							// 细菌
							Set Bacteria   = objResult.LabResult
							Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
							
							Set BacteriaID=""
							If $isobject(objBactMap){
								if objBactMap.BTIsActive=1{
									if $isobject(objBactMap.BTMapItemDr){
										Set BacteriaID = objBactMap.BTMapItemDr.%Id()
										Set BacteriaBZ = objBactMap.BTMapItemDr.BTBacDesc  //标准细菌
									}
								}
							}
							Set:SusData'="" SusData =SusData_aLineFlag_aLv_LvN_LvN_LvN_"<sus anti="""_AntDesc_""" sus="""_Sensitivity_""" requesttime="""_CollDateR_""" reporttime="""_AuthDateR_"""/>"
							Set:SusData="" SusData ="<sus anti="""_AntDesc_""" sus="""_Sensitivity_""" requesttime="""_CollDateR_""" reporttime="""_AuthDateR_"""/>"
						
						}
					}
					//HA、CA、HA 重复、CA重复、定植、定植重复、污染
					Set:(+idiagid)=0 itype= "定植" 	
					Set:Bacteria="2-Sep" Bacteria="表皮葡萄球菌"
					//处理多耐重点菌加备注	
					Set BactBak = ""
					Set BactFoc = ""				
					Set RstObjectID = LabReportID_"||"_TestCode
					Set xItemID =""
					For {
						Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexObjectID",aEpisodeID,xItemID))
						Quit:xItemID=""			
						Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
						Continue:'$IsObject(objItem)
						Set CCItemCode=objItem.CCCode
						Continue:(CCItemCode'="LAB-Bacteria")&(CCItemCode'="LAB-TestAb")
						
						Set xCCRstID =$o(^DHCHAI.IR.CCResultI("IndexObjectID",aEpisodeID,xItemID,SCode,RstObjectID,""))
						Continue:xCCRstID=""
						Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xCCRstID)
						Continue:'$Isobject(objResult)
						Continue:objResult.CCIsActive'=1
						Set IsAbFlagRst=objResult.CCIsAbFlag   //异常标志
						Continue:IsAbFlagRst'=1 //过滤非耐药菌	
						Set MRBDesc=""
						If $IsObject(objResult.CCMRBTpDr) {   //多耐菌分类	
							Set BactFoc = objResult.CCMRBTpDr.BTDesc
							Set:$Isobject(objResult.CCMRBTpDr.BTCatDr) BactBak = objResult.CCMRBTpDr.BTCatDr.BTCode
						}						
					}
					
					Set BactData = aLineFlag_aLv_LvN_"<bact tno=""Rep"_xRstID_""" bact="""_Bacteria_""""
					Set BactData=BactData_" btype="""_TestSetDesc_""""
					Set BactData=BactData_" spec="""_Specimen_""" dept="""_LocCode_""""
					Set BactData=BactData_" reqtime="""_CollDateR_""" rpttime="""_AuthDateR_""""
					Set BactData=BactData_" abr=""1"" itype="""_itype_""""
					//多耐
					if (BactBak'="")
					{
						Set EsblsF = 0 
						Set:BactBak["ESBLs" EsblsF=1
						Set BactData=BactData_" dlevel=""多耐药"""_" focus="""_BactFoc_""" esbl="""_EsblsF_""""
					}

					
					//关联的感染部位
					Set:(+idiagid)>0 BactData=BactData_" idiagid="""_idiagid_""""
					Set BactData=BactData_" site="""_site_""">"										
					if (SusData="")
					{
						Set BactData=BactData_aLineFlag_aLv_LvN_LvN_"<sus-list/>"
					}
					else
					{
						//有药敏实验数据
						Set BactData=BactData_aLineFlag_aLv_LvN_LvN_"<sus-list>"
						Set BactData=BactData_aLineFlag_aLv_LvN_LvN_LvN_SusData
						Set BactData=BactData_aLineFlag_aLv_LvN_LvN_"</sus-list>"
					}
					Set BactData=BactData_aLineFlag_aLv_LvN_"</bact>"	
					Set:BactDataAll'="" BactDataAll=BactDataAll_BactData
					Set:BactDataAll="" BactDataAll = BactData 				
				}				
				if (abr=0)
				{
					Set BactData = aLineFlag_aLv_LvN_"<bact tno=""Vi"_xVisitNumberDr_"R"_xVisitReportDr_""" bact=""无菌"""
					Set BactData=BactData_" btype="""_TestSetDesc_""""
					Set BactData=BactData_" spec="""_Specimen_""" dept="""_LocCode_""""
					Set BactData=BactData_" reqtime="""_CollDateR_""" rpttime="""_AuthDateR_""""
					Set BactData=BactData_" abr=""0"" site="""_site_""">"
					Set BactData=BactData_aLineFlag_aLv_LvN_LvN_"<sus-list/>"
					Set BactData=BactData_aLineFlag_aLv_LvN_"</bact>"
					
					Set:BactDataAll'="" BactDataAll=BactDataAll_BactData
					Set:BactDataAll="" BactDataAll = BactData
				}
			}
		}
	}
	
	if (BactDataAll="")
	{
		//无数据	
		Set return = aLv_"<bact-list/>"	
	}
	else
	{
		Set return = aLv_"<bact-list>"_BactDataAll
		Set return =return_aLineFlag_aLv_"</bact-list>"
	}
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeTreatList(44910,$c(2)," ")
ClassMethod GetEpisodeTreatList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return =""
	Set LvN = " "  //层级缩进格式
	Set TreatDataAll = ""  //侵害性操作
	//合并同一种操作 暂不考虑及临时医嘱
	//S1长期（滚执行记录）、S2长期（滚医嘱）、N临时
	//Set MapPriority=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"OEPriority",OEPriority)
	Set aLocType = "W" //病区
	
	 Set NIndex="GetEpisodeTreatList"
	 Kill ^TMP($zn,$j,NIndex)
	 //医嘱信息
	 Set xSCode= ""
	 For {		
		Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode))  //子系统索引
		Quit:xSCode=""			
		
			Set xUpdateDate =""
			For {
				Set xUpdateDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode,0,xUpdateDate))
				Quit:xUpdateDate=""
				Set xOrdItemID ="" 
				
				For {
					Set xOrdItemID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xSCode,0,xUpdateDate,xOrdItemID))
					Quit:xOrdItemID="" 
					Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
					Continue:'$Isobject(objOrdItem)
					Set xOrdItemDesc = objOrdItem.OEOrdDesc
					Set IsActive=objOrdItem.OEIsActive
					Continue:IsActive'=1
					//取的临床医嘱名称
					Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xSCode,xOrdItemDesc,""))	
					Continue:xMastMapID=""
					Set objMap = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(xMastMapID)
					Continue:'$Isobject(objMap)			
					Continue:'$Isobject(objMap.BTMapItemDr)  //治疗医嘱项  
					Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr)  //治疗医嘱分类
					
					Set BTCode = objMap.BTMapItemDr.BTCatDr.BTCode 
					Continue:(BTCode'["PICC")&&(BTCode'["UC")&&(BTCode'["VAP")
					
					Set OeItemType=$s(BTCode["PICC":"中心静脉插管",BTCode["VAP":"呼吸机",BTCode["UC":"导尿管插管",1:"其他") 
					Set OeItemDesc =objOrdItem.OEOrdDesc
					Set EndDt=""  //结束时间
					Set EndTime =""
					Set StartDt=""
					Set StartTime = ""
					if (objOrdItem.OESttDate'="")
					{
						//Set StartDt = $zd(objOrdItem.OESttDate,3)
						Set StartDt=objOrdItem.OESttDate
						Set:objOrdItem.OESttTime'="" StartTime = objOrdItem.OESttTime								
					}
					if (objOrdItem.OEXDate'="")
					{
						//Set EndDt = $zd(objOrdItem.OEXDate,3)
						Set EndDt=objOrdItem.OEXDate
						Set:objOrdItem.OEXTime'="" EndTime = objOrdItem.OEXTime
					}
					Set TypeValue =objOrdItem.OEPriority  //医嘱类型 临时医嘱
					//Set OeOrdNum = objOrdItem.
					Continue:TypeValue="临时医嘱"										
					//开始时间-结束时间	
					//w xOrdItemID_"="_TransDate_","_TransTime_";"_StartDt_","_StartTime_";"_TOutDate_","_TOutTime_";"_EndDt_","_EndTime,!		
					Set idx =$i(^TMP($zn,$j,NIndex,OeItemType))
					if (idx=1)
					{
						//直接存储
						Set ^TMP($zn,$j,NIndex,OeItemType,idx)=StartDt_"^"_StartTime_"^"_EndDt_"^"_EndTime_"^"_xOrdItemID
					}
					else
					{
						//取值比较，判断是否要新增
						Set dateStr = $g(^TMP($zn,$j,NIndex,OeItemType,idx-1))
						Set tmpStDate = $p(dateStr,"^",1)
						Set tmpStTime = $p(dateStr,"^",2)
						Set tmpEndDt = $p(dateStr,"^",3)
						Set tmpEndTime=$p(dateStr,"^",4)
						if (tmpEndDt="")
						{
							if (..CompareDateTimeDiff(tmpStDate,tmpStTime,StartDt,StartTime)<0)
							{
								if (EndDt="")
								{											
									//当前医嘱的时间小于之前的	
									Set $p(dateStr,"^",1) = StartDt
									Set $p(dateStr,"^",2) = StartTime								
									Set ^TMP($zn,$j,NIndex,OeItemType,idx-1)= dateStr
								}
								else
								{
									if (..CompareDateTimeDiff(tmpStDate,tmpStTime,EndDt,EndTime)<0)
									{
										//直接存储
										Set ^TMP($zn,$j,NIndex,OeItemType,idx)=StartDt_"^"_StartTime_"^"_EndDt_"^"_EndTime_"^"_xOrdItemID
									}	
								}
				
							}									
						}
						else
						{
							//有结束日期
							if (..CompareDateTimeDiff(tmpStDate,tmpStTime,StartDt,StartTime)<0)
							{
								if (EndDt="")
								{											
									//当前医嘱的时间小于之前的	
									Set $p(dateStr,"^",1) = StartDt
									Set $p(dateStr,"^",2) = StartTime
									Set $p(dateStr,"^",3) = EndDt
									Set $p(dateStr,"^",4) = EndTime								
									Set ^TMP($zn,$j,NIndex,OeItemType,idx-1)= dateStr
								}
								else
								{
									if (..CompareDateTimeDiff(tmpStDate,tmpStTime,EndDt,EndTime)<0)
									{
										//直接存储
										Set ^TMP($zn,$j,NIndex,OeItemType,idx)=StartDt_"^"_StartTime_"^"_EndDt_"^"_EndTime_"^"_xOrdItemID
									}
									else
									{
										//当前医嘱的时间小于之前的	
										Set $p(dateStr,"^",1) = StartDt
										Set $p(dateStr,"^",2) = StartTime							
										Set ^TMP($zn,$j,NIndex,OeItemType,idx-1)= dateStr
									}	
								}						
							}
							else
							{
								//
								if (EndDt'="")
								{
									if (..CompareDateTimeDiff(tmpEndDt,tmpEndTime,EndDt,EndTime)>0)
									{
										if (..CompareDateTimeDiff(tmpEndDt,tmpEndTime,StartDt,StartDt)>0)
										{
											//新增项目
											//直接存储
											Set ^TMP($zn,$j,NIndex,OeItemType,idx)=StartDt_"^"_StartTime_"^"_EndDt_"^"_EndTime_"^"_xOrdItemID
										}
										else
										{
											//合并
											Set $p(dateStr,"^",3) = EndDt
											Set $p(dateStr,"^",4) = EndTime								
											Set ^TMP($zn,$j,NIndex,OeItemType,idx-1)= dateStr
										}
									}			
								}	
							}
						}	
					}							
				}
			}
		//
	}
	
	Set aOrderDesc = ""
	For {
		Set aOrderDesc = $o(^TMP($zn,$j,NIndex,aOrderDesc))
		Quit:aOrderDesc=""
		
		Set aIdx = ""
		For {
			Set aIdx = $o(^TMP($zn,$j,NIndex,aOrderDesc,aIdx))
			Quit:aIdx=""
			Set rstStr = $g(^TMP($zn,$j,NIndex,aOrderDesc,aIdx))
			Set rstStartDt = $p(rstStr,"^",1)
			Set rstStartTime = $p(rstStr,"^",2)
			Set rstEndDt = $p(rstStr,"^",3)
			Set rstEndTime = $p(rstStr,"^",4)
			Set rstOrdItemID = $p(rstStr,"^",5)
			Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,rstStartDt,rstStartTime)
			Set LocCode=""
			Set WardDr = $p(TransInfo,"^",2)
			Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
			Set:$Isobject(objWard) LocCode = objWard.BTCode
			
			Set FromDateTime = $zd(rstStartDt,3)_" "_$zt(rstStartTime,1)
			if (rstEndDt="")
			{
				Set ToDateTime = "9999"
			}
			else
			{
				Set ToDateTime = $zd(rstEndDt,3)_" "_$zt(rstEndTime,1)
			}
			Set TreatData = aLineFlag_aLv_LvN_"<treat tno="""_rstOrdItemID_""" ttype="""_aOrderDesc_""" dept="""_LocCode_""""
			Set TreatData=TreatData_" timeFrom="""_FromDateTime_""" timeTo="""_ToDateTime_"""/>"
			
			Set:TreatDataAll'="" TreatDataAll = TreatDataAll_TreatData
			Set:TreatDataAll="" TreatDataAll = TreatData
			
		}
	}		
	
							
	//根据转病区记录切分医嘱记录	
	if (TreatDataAll="")
	{
		//无数据	
		Set return = aLv_"<treat-list/>"	
	}
	else
	{
		Set return = aLv_"<treat-list>"_TreatDataAll
		Set return =return_aLineFlag_aLv_"</treat-list>"
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit return
}

/// aEpisodeID 就诊号20200820
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeTreatList(79732,$c(2)," ")
ClassMethod GetEpisodeTreatListbak0820(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return =""
	Set LvN = " "  //层级缩进格式
	Set TreatDataAll = ""  //侵害性操作
	//合并同一种操作 暂不考虑及临时医嘱
	//S1长期（滚执行记录）、S2长期（滚医嘱）、N临时
	//Set MapPriority=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"OEPriority",OEPriority)
	Set aLocType = "W" //病区
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate))
		Quit:xDate=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate,xID))
			Quit:xID=""
			
			Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xID)
			Continue:'$IsObject(objTrans)
			Continue:'$IsObject(objTrans.PATransLocDr)
			Set objLoc=objTrans.PATransLocDr
			Continue:'$IsObject(objLoc.BTTypeDr)
			Set LocType=objLoc.BTTypeDr.BTCode
			Set LocID=objLoc.%Id()
			Set LocCode = objLoc.BTCode
			Set LocDesc=objLoc.BTDesc
			Set LocDesc2=objLoc.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set TransDate=objTrans.PATransDate	//PATransTime	
			Set TransTime=objTrans.PATransTime
			Set TOutDate = objTrans.PAOutLocDate  //PAOutLocTime 出科时间
			Set TOutTime = objTrans.PAOutLocTime
			//医嘱信息
			Set xSCode= ""
			For {		
				Set xSCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode))  //子系统索引
				Quit:xSCode=""
				Set xOrdItemDesc = "" 
				For {
					Set xOrdItemDesc = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode,xOrdItemDesc))
					Quit:xOrdItemDesc=""
					Set xUpdateDate =""
					For {
					Set xUpdateDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode,xOrdItemDesc,xUpdateDate))
						Quit:xUpdateDate=""
						Set xOrdItemID ="" 
						For {
							Set xOrdItemID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeOrdDescDate",aEpisodeID,xSCode,xOrdItemDesc,xUpdateDate,xOrdItemID))
							Quit:xOrdItemID="" 
							Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
							Continue:'$Isobject(objOrdItem)
							Set IsActive=objOrdItem.OEIsActive
							Continue:IsActive'=1
							//取的临床医嘱名称
							Set xMastMapID = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",xSCode,xOrdItemDesc,""))	
							Continue:xMastMapID=""
							Set objMap = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(xMastMapID)
							Continue:'$Isobject(objMap)			
							Continue:'$Isobject(objMap.BTMapItemDr)  //治疗医嘱项  
							Continue:'$Isobject(objMap.BTMapItemDr.BTCatDr)  //治疗医嘱分类
							
							Set BTCode = objMap.BTMapItemDr.BTCatDr.BTCode 
							Continue:(BTCode'["PICC")&&(BTCode'["UC")&&(BTCode'["VAP")
							
							Set OeItemType=$s(BTCode["PICC":"中心静脉插管",BTCode["VAP":"呼吸机",BTCode["UC":"导尿管插管",1:"其他") 
							Set OeItemDesc =objOrdItem.OEOrdDesc
							Set EndDt=""  //结束时间
							Set EndTime =""
							Set StartDt=""
							Set StartTime = ""
							if (objOrdItem.OESttDate'="")
							{
								//Set StartDt = $zd(objOrdItem.OESttDate,3)
								Set StartDt=objOrdItem.OESttDate
								Set:objOrdItem.OESttTime'="" StartTime = objOrdItem.OESttTime
							}
							if (objOrdItem.OEXDate'="")
							{
								//Set EndDt = $zd(objOrdItem.OEXDate,3)
								Set EndDt=objOrdItem.OEXDate
								Set:objOrdItem.OEXTime'="" EndTime = objOrdItem.OEXTime
							}
							Set TypeValue =objOrdItem.OEPriority  //医嘱类型 临时医嘱
							//Set OeOrdNum = objOrdItem.
							Continue:TypeValue="临时医嘱"											
							//开始时间-结束时间	
							//w xOrdItemID_"="_TransDate_","_TransTime_";"_StartDt_","_StartTime_";"_TOutDate_","_TOutTime_";"_EndDt_","_EndTime,!		
							if (TOutDate="")
							{
								Continue:(..CompareDateTimeDiff(TransDate,TransTime,EndDt,EndTime))<0
								//患者在病区
								Set FromDateTime = ""
								Set ToDateTime =""
								if (..CompareDateTimeDiff(TransDate,TransTime,StartDt,StartTime)<0)
								{
									Set FromDateTime = $zd(TransDate,3)_" "_$zt(TransTime,1)
									Set:EndDt'="" ToDateTime = $zd(EndDt,3)_" "_$zt(EndTime,1)
									Set:EndDt="" ToDateTime = "9999"									
								}
								else
								{
									Set FromDateTime = $zd(StartDt,3)_" "_$zt(StartTime,1)
									Set ToDateTime = $zd(EndDt,3)_" "_$zt(EndTime,1)
									Set:EndDt="" ToDateTime = "9999"	
								}
								Set FDateVal=$p(FromDateTime," ",1)
								Set TDateVal =$p(ToDateTime," ",1)
								Continue:FDateVal=TDateVal  //因为拆分医嘱结束医嘱在转科后几分钟 这种过滤掉
								Set TreatData = aLineFlag_aLv_LvN_"<treat tno="""_xOrdItemID_""" ttype="""_OeItemType_""" dept="""_LocCode_""""
								Set TreatData=TreatData_" timeFrom="""_FromDateTime_""" timeTo="""_ToDateTime_"""/>"
								
								Set:TreatDataAll'="" TreatDataAll = TreatDataAll_TreatData
								Set:TreatDataAll="" TreatDataAll = TreatData
								
							}
							else
							{
								//出病区
								Continue:(..CompareDateTimeDiff(TransDate,TransTime,EndDt,EndTime))<0
								Continue:(..CompareDateTimeDiff(StartDt,StartTime,TOutDate,TOutTime))<0
								if (..CompareDateTimeDiff(TransDate,TransTime,StartDt,StartTime)<0)
								{
									Set FromDateTime = $zd(TransDate,3)_" "_$zt(TransTime,1)								
								}
								else
								{
									Set FromDateTime = $zd(StartDt,3)_" "_$zt(StartTime,1)	
								}
								if (..CompareDateTimeDiff(TOutDate,TOutTime,EndDt,EndTime)<0)
								{
									Set ToDateTime = $zd(EndDt,3)_" "_$zt(EndTime,1)								
								}
								else
								{
									Set ToDateTime = $zd(TOutDate,3)_" "_$zt(TOutTime,1)	
								}
								Set FDateVal=$p(FromDateTime," ",1)
								Set TDateVal =$p(ToDateTime," ",1)
								Continue:FDateVal=TDateVal  //因为拆分医嘱结束医嘱在转科后几分钟 这种过滤掉
								Set TreatData = aLineFlag_aLv_LvN_"<treat tno="""_xOrdItemID_""" ttype="""_OeItemType_""" dept="""_LocCode_""""
								Set TreatData=TreatData_" timeFrom="""_FromDateTime_""" timeTo="""_ToDateTime_"""/>"
								
								Set:TreatDataAll'="" TreatDataAll = TreatDataAll_TreatData
								Set:TreatDataAll="" TreatDataAll = TreatData
							}
						}
					}
				}
			}

		}
	}	
	//根据转病区记录切分医嘱记录	
	if (TreatDataAll="")
	{
		//无数据	
		Set return = aLv_"<treat-list/>"	
	}
	else
	{
		Set return = aLv_"<treat-list>"_TreatDataAll
		Set return =return_aLineFlag_aLv_"</treat-list>"
	}
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeAntiList(11,$c(2)," ")
ClassMethod GetEpisodeAntiList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return =""
	Set AntiDataAll =""
	Set LvN = " "
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		
		Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
		Continue:'$IsObject(objOrdItem)
		Continue:objOrdItem.OEIsActive=0	// 无效医嘱
		Set SCode   = objOrdItem.OESCode
		Set OrdType = objOrdItem.OEOrdType
		Continue:OrdType'="R" //过滤掉非药品医嘱
		Continue:objOrdItem.OEAntUseFlag'=1  //抗菌用药标志
		Set OrdDesc = objOrdItem.OEOrdDesc
		Set Generic=objOrdItem.OEGeneric
		Set Priority= objOrdItem.OEPriority
		Set OrdDate = objOrdItem.OEOrdDate
		Set:OrdDate'="" OrdDate=$zd(OrdDate,3)
		Set OrdTime = objOrdItem.OEOrdTime
		Set:OrdTime'="" OrdTime=$zt(OrdTime,1)
		Set SttDate = objOrdItem.OESttDate
		Set:SttDate'="" SttDate=$zd(SttDate,3)
		Set SttTime = objOrdItem.OESttTime
		Set:SttTime'="" SttTime=$zt(SttTime,1)
		Set EndDate	= objOrdItem.OEXDate
		
		Set EndTime	= objOrdItem.OEXTime
		Set:EndDate'="" EndDate=$zd(EndDate,3)
		Set:EndTime'="" EndTime=$zt(EndTime,1)
		If (Priority["临时")
		{
			Set EndDate =SttDate
			Set EndTime =SttTime
		}
		
		If $IsObject(objOrdItem.OEOrdLocDr) {
			Set OrdLocDesc=objOrdItem.OEOrdLocDr.BTDesc
		} Else {
			Set OrdLocDesc=objOrdItem.OEOrdLoc  //ID|Code|Desc
			Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
		}
		Set OrdDocDesc=objOrdItem.OEDoctor  //ID|Code|Desc
		Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
		Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,objOrdItem.OEOrdDate,objOrdItem.OEOrdTime)
		Set WardDr = $p(TransInfo,"^",2)
		Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
		Set WardCode = ""
		Set:$Isobject(objWard) WardCode = objWard.BTCode
		Set DrgPoison = objOrdItem.OEAntDrgPoison
		Set Prop=objOrdItem.OEAntUsePurpose
		// 使用目的
		Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiMedPurpose",Prop)
		Set PropID = "" 
		If (PhraseMap'="") {
			Set PropID  = $p(PhraseMap,"^",1)
			Set Prop 	= $p(PhraseMap,"^",3)
		}
		Set OEInstruc=objOrdItem.OEInstruc  //给药方式
		// 给药途径   
		Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiAdminRoute",OEInstruc)
		Set OEInstrucID = "" 
		If (PhraseMap'="") {
			Set OEInstrucID = $p(PhraseMap,"^",1)
			Set OEInstruc 	= $p(PhraseMap,"^",3)
		}
		Set InstrucList = $lb("口服","肌肉注射","静脉点滴","静脉注射")	//全身用药	
		Continue:'$listfind(InstrucList,OEInstruc)
				
		//抗生素标准名
		//Set objAntiMast=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(SCode,OrdDesc)
		//Continue:'$IsObject(objAntiMast)
		//Set objOEAnti = objAntiMast.BTMapItemDr
		//Continue:'$IsObject(objOEAnti)
		//Set AntiMastID = objOEAnti.%Id()
		//Set:($IsObject(objAntiMast))&($IsObject(objAntiMast.BTMapItemDr)) Generic = objAntiMast.BTMapItemDr.BTName
		Set:(DrgPoison'="KSS1")&(DrgPoison'="KSS2")&(DrgPoison'="KSS3") DrgPoison="非限制类"
		Set:DrgPoison="KSS1" DrgPoison="非限制类"
		Set:DrgPoison="KSS2" DrgPoison="限制类"
		Set:DrgPoison="KSS3" DrgPoison="特殊类"
		Set:EndDate'="" EndDate=EndDate_" "_EndTime
		Set:EndDate="" EndDate = "9999"
		/*
		Set MapPriority=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"OEPriority",Priority)
		If MapPriority["S" {
			Set:XDate="" IsNotEnd=0  //长期医嘱未结束
		}
		*/
		Continue:Prop=""
		Continue:Prop="皮试"
		Set AntiData = aLineFlag_aLv_LvN_"<anti orderno="""_xID_""" cname="""_Generic_""" alevel="""_DrgPoison_""""
		Set AntiData=AntiData_" timeFrom="""_SttDate_" "_SttTime_""" timeTo="""_EndDate_""" dept="""_WardCode_""" dlevel=""未知"" doctor="""_OrdDocDesc_""""
		Set AntiData=AntiData_" administration="""_OEInstruc_""" goal="""_Prop_"""/>"
		Set:AntiDataAll'="" AntiDataAll=AntiDataAll_AntiData
		Set:AntiDataAll="" AntiDataAll=AntiData
	}
	
	if (AntiDataAll="")
	{
		//无数据	
		Set return = aLv_"<anti-list/>"	
	}
	else
	{
		Set return = aLv_"<anti-list>"_AntiDataAll
		Set return =return_aLineFlag_aLv_"</anti-list>"
	}
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeOperList(54081,$c(2)," ")
ClassMethod GetEpisodeOperList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return =""
	Set LvN = " "
	Set OperDataAll=""
	Set AdmDate =0  //入院日期
	Set AdmTime =0
	Set DisDate = 0  //出院日期
	Set DisTime = 0
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)	
	Set:$Isobject(objPaadm) AdmDate = objPaadm.PAAdmDate
	Set:$Isobject(objPaadm) AdmTime = objPaadm.PAAdmTime
	Set:$Isobject(objPaadm) DisDate = objPaadm.PADischDate
	Set:$Isobject(objPaadm) DisTime = objPaadm.PADischTime
	// 手麻数据	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""

		Set objOperAna = ##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
		Continue:'$IsObject(objOperAna)
		
		Set IsActive 	= objOperAna.ORIsActive
		Continue:IsActive'=1
		Set Status = objOperAna.OROperStatus
		Continue:Status'="F"  //只导出完成的手术
		
		Set OperAnaData = ..BuildOperData(xID,"")
		Continue:OperAnaData=""
		Set OperICD 	= $lg(OperAnaData,3)
		Set OperName 	= $lg(OperAnaData,4)
		Set OperTypeID 	= $lg(OperAnaData,5)
		Set OperType 	= $lg(OperAnaData,6)
		Set OperDate 	= $lg(OperAnaData,7)
		Set SttTime 	= $lg(OperAnaData,8)
		
		Set EndDate 	= $lg(OperAnaData,9)
		Set EndTime 	= $lg(OperAnaData,10)
		
		Set OperHour 	= +$lg(OperAnaData,11)
		Set OperLocID 	= $lg(OperAnaData,12)
		Set OperLoc 	= $lg(OperAnaData,13)
		Set OpertorName = $lg(OperAnaData,14)
		Set OpertorCode = $lg(OperAnaData,15)
		Set Assistant1 	= $lg(OperAnaData,16)
		Set Assistant2 	= $lg(OperAnaData,17)
		Set CuteTypeID 	= $lg(OperAnaData,18)
		Set CuteType 	= $lg(OperAnaData,19)
		Set CuteHealingID 	= $lg(OperAnaData,20)
		Set CuteHealing 	= $lg(OperAnaData,21)
		Set AnesthesiaID= $lg(OperAnaData,22)
		Set Anesthesia 	= $lg(OperAnaData,23)
		Set AnesthesiaDoc 	= $lg(OperAnaData,24)
		Set ASAScoreID 	= $lg(OperAnaData,25)
		Set ASAScore 	= $lg(OperAnaData,26)
		Set NNISLevelID = $lg(OperAnaData,27)
		Set NNISLevel 	= $lg(OperAnaData,28)
		Set PreoperWBC 	= $lg(OperAnaData,29)
		Set CuteNumber  = $lg(OperAnaData,30)
		Set EndoscopeFlag= $lg(OperAnaData,31)
		Set ImplantFlag = $lg(OperAnaData,32)
		Set BloodLoss 	= $lg(OperAnaData,33)
		Set BloodTrans 	= $lg(OperAnaData,34)
		Set PostoperComps= $lg(OperAnaData,35)
		
		Set INFOpsID = $o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",aEpisodeID,xID,""),-1)
		// 该手术有报告记录
		If INFOpsID'=""{
			//如果有调查报告,则用报告数据为准
			Set objINFOPS = ##class(DHCHAI.IR.INFOPS).GetObjById(INFOpsID)	
						
			Set objOperAnaes = objINFOPS.IROperDr  //对应的手麻记录对象
			Set OperAnaesID = ""
			If $IsObject(objOperAnaes){
				Set OperAnaesID = objOperAnaes.%Id()
			}
			Set:objINFOPS.IROperName'="" OperName = objINFOPS.IROperName
			Set:objINFOPS.IROperName2'="" OperName = objINFOPS.IROperName2  //标准名称为准
		}
		Set timeFrom =""
		If OperDate'=""
		{
			Set timeFrom = $zd(OperDate,3)
		}
		If SttTime'=""{
			Set timeFrom = timeFrom_" "_$zt(SttTime,1)
		}
		Set timeTo = ""
		If EndDate'=""
		{
			Set timeTo = $zd(EndDate,3)	
		}
		If EndTime'=""{
			Set timeTo =timeTo_" "_$zt(EndTime,1)
		}
		// 手术时长
	    //有bug Set:(+OperHour)<=0 OperHour = ..GetHourByDateTime(OperDate,SttTime,EndDate,EndTime)
	    //Set:(+OperHour)<=0 OperHour =$Number((..CompareDateTimeDiff(OperDate,SttTime,EndDate,EndTime))/3600,1)
		Set OperHour =$Number((..CompareDateTimeDiff(OperDate,SttTime,EndDate,EndTime))/3600,1)
		Continue:OperHour<0
		Set OperHour=$fn(OperHour,",",1)
		Set woundGrade="无"
		Set:CuteType["Ⅰ类" woundGrade="Ⅰ"
		Set:CuteType["Ⅱ类" woundGrade="Ⅱ"
		Set:CuteType["Ⅲ类" woundGrade="Ⅲ"
		Set:CuteType["Ⅳ类" woundGrade="Ⅳ"
		// 计算NNIS分级
		Set nnis =+NNISLevel
		If (NNISLevel="") {
			Set:OperHour>=3 nnis=(+nnis)+1
			Set:woundGrade="Ⅲ" nnis=(+nnis)+1
			Set:woundGrade="Ⅳ" nnis=(+nnis)+1
			Set:ASAScore="P3" nnis=(+nnis)+1
			Set:ASAScore="P4" nnis=(+nnis)+1
			Set:ASAScore="P5" nnis=(+nnis)+1
			Set:ASAScore="P6" nnis=(+nnis)+1
		}
		//embed 植入物
		Set embed ="无"
		Set:(+ImplantFlag)>0 embed = "有"
		Set bloodOut ="0.0"
		Set bloodIn ="0.0"
		Set:BloodLoss'="" bloodOut=+BloodLoss  //失血量
		Set:BloodTrans'="" bloodIn=+BloodTrans //输血量
		Set antiB = "否",antiB2="否"  //术前用药
		Set antiBHours ="0.0"
		Set antiFlag = ..CheckUesAnti(aEpisodeID,AdmDate,AdmTime,OperDate,SttTime,"预防")  //期间使用抗生素情况
		If (+antiFlag>0)
		{
			Set antiB ="是"
			Set lastDateTime = $p(antiFlag,"^",2)
			Set diffMill = ..CompareDateTimeDiff(+lastDateTime,$p(lastDateTime,",",2),OperDate,SttTime)
			Set antiBHours = $fn(diffMill/3600,",",1)
			Set:(antiBHours>=0.5)&(antiBHours<=2) antiB2="是"
		}
		//术后
		Set antiI = "否"  //是否术中
		Set antiA="0.0"
		Set antiAN="否"   //是否术后 
		Set antiA24="否"  //术后24小时停止使用
		Set antiA48="否"
		if (EndDate'="")
		{
			Set:+DisDate=0 DisDate =+$h
			Set:+DisTime=0 DisTime=+$p($h,",",2)
			Set antiFlagI = ..CheckUesAnti(aEpisodeID,EndDate,EndTime,DisDate,DisTime,"预防")  //期间使用抗生素情况
			If (+antiFlagI>0)
			{
				//Set antiI ="是"
				Set antiAN ="是"
				Set lastDateTimeI = $p(antiFlagI,"^",2)
				Set diffMillI = ..CompareDateTimeDiff(EndDate,EndTime,+lastDateTimeI,+$p(lastDateTimeI,",",2))
				Set antiA = $fn(diffMillI/3600,",",1)
				//术后24小时 -48小时
				//w lastDateTimeI,antiA,!
				Set:antiA<=24 antiA24="是",antiA48="是"
				
				Set:antiA<=48 antiA48="是"
				Set:antiA>24 antiA24="否"
				Set:antiA>48 antiA48="否"
			}
		} 
		Set OperData = aLineFlag_aLv_LvN_"<oper operid="""_xID_""" opercate="""_OperName_""" amethod="""_Anesthesia_""""
		Set OperData =OperData_" timeFrom="""_timeFrom_""" timeTo="""_timeTo_""" hours="""_OperHour_""""
		Set OperData =OperData_" woundGrade="""_woundGrade_""" heal="""_CuteHealing_""" nnis="""_nnis_""" opertype="""_OperType_""""
		Set OperData =OperData_" embed="""_embed_""" anti_b="""_antiB_""" anti_b_hours="""_antiBHours_""" anti_b2="""_antiB2_""" anti_i="""_antiI_""" anti_a="""_antiAN_""" opercode="""_OperICD_""""
		Set OperData =OperData_" surgeon="""_OpertorName_""" blood_out="""_bloodOut_""" blood_in="""_bloodIn_""" operroom=""0100"" anti_a24="""_antiA24_""" anti_a48="""_antiA48_"""/>"
		
		Set:OperDataAll'="" OperDataAll=OperDataAll_OperData
		Set:OperDataAll="" OperDataAll=OperData
	}
	if (OperDataAll="")
	{
		//无数据	
		Set return = aLv_"<oper-list/>"	
	}
	else
	{
		Set return = aLv_"<oper-list>"_OperDataAll
		Set return =return_aLineFlag_aLv_"</oper-list>"
	}
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeDiagList(33959,$c(2)," ")
ClassMethod GetEpisodeDiagList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return =""
	Set LvN=" " 
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Set BedDt = ##Class(DHCHAI.IO.ToSzNIDPSrv).GetAdmInBedDT(aEpisodeID)
	//就诊时间
	Set PAAdmDate=objPaadm.PAAdmDate		
	Set PaAdmTime = objPaadm.PAAdmTime
	Set:$p(BedDt,"^",1)'="" PAAdmDate = $p(BedDt,"^",1)
	Set:$p(BedDt,"^",2)'="" PaAdmTime = $p(BedDt,"^",2)
	// 增加返回诊断信息
	Set (DiagDataAll,dno,dtime,ddesc,dicd10,dtype,dept)=""		// 主要诊断、入院诊断、其他诊断、出院诊断
	Set xDiagnosID = ""
	For {
		Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xDiagnosID))
		Quit:xDiagnosID=""
		
		Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
		Continue:'$isobject(objDiagnos)
		Set IsActive = objDiagnos.MRIsActive
		Continue:IsActive'=1
		Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
		Set SCode	   = objDiagnos.MRSCode
		Set dicd10  	   = objDiagnos.MRDiagICD10
		Set ddesc   = objDiagnos.MRDiagDesc
		Set DiagTpCode = objDiagnos.MRDiagTpCode
		Set DiagTpDesc = objDiagnos.MRDiagTpDesc
		Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
		If DiagTypeMap'="" {
			Set DiagTpCode=$p(DiagTypeMap,"^",2)
			Set DiagTpDesc=$p(DiagTypeMap,"^",3)
		}
		Set dno = xDiagnosID
		Set dtype=DiagTpDesc
		Set diagDate = objDiagnos.MRDiagDate
		Set diagTime = objDiagnos.MRDiagTime
		//诊断时间早于入院分床时间的用分床时间代替
		Set:(diagDate=PAAdmDate)&(diagTime<PaAdmTime) diagTime = PaAdmTime
		Set:diagDate<PAAdmDate diagDate=PAAdmDate
		Set:diagDate<PAAdmDate diagTime=PaAdmTime
		Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,diagDate,diagTime)
		Set WardDr = $p(TransInfo,"^",2)
		Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
		Set:$Isobject(objWard) dept = objWard.BTCode
		Set dtime = $zd(diagDate,3)_" "_$zt(diagTime,1)
		Set DiagData = aLineFlag_aLv_LvN_"<diag dtype="""_dtype_""" ddesc="""_ddesc_""""
		Set DiagData =DiagData_" dtime="""_dtime_""" dicd10="""_dicd10_""" dept="""_dept_""" dno="""_dno_"""/>"
		
		Set:DiagDataAll'="" DiagDataAll= DiagDataAll_DiagData
		Set:DiagDataAll="" DiagDataAll = DiagData
	}
	if (DiagDataAll="")
	{
		//无数据	
		Set return = aLv_"<diag-list/>"	
	}
	else
	{
		Set return = aLv_"<diag-list>"_DiagDataAll
		Set return =return_aLineFlag_aLv_"</diag-list>"
	}
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeRoutList(10,$c(2)," ")
ClassMethod GetEpisodeRoutList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return =""
	Set RoutDataAll = ""  //常规检验数据
	Set LvN = " "  //层级缩进格式	
	Set xVisitNumberDr="" 
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeID,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$isobject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		Set SCode=objVisitNumber.LabSCode
		
		Set CollDate=objVisitNumber.LabCollDate		//采集日期
		Set CollTime=objVisitNumber.LabCollTime
		
		Set RecDate=objVisitNumber.LabRecDate		//接收日期
		Set RecTime=objVisitNumber.LabRecTime
		
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,CollDate,CollTime)
		Set WardDr = $p(TransInfo,"^",2)
		Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
		Set dept=""
		Set:$Isobject(objWard) dept = objWard.BTCode
		
		Set:CollDate'="" CollDate=$zd(CollDate,3)
		Set:CollTime'="" CollTime=$zt(CollTime,1)
		
		Set SCode	 	= objVisitNumber.LabSCode  //子系统
		Set EpisodeNo 	= objVisitNumber.LabEpisodeNo
		Set Specimen 	= objVisitNumber.LabSpecimen
		Set LocCode 	= ""
		If $isobject(objVisitNumber.LabLocDr){
			Set LocCode=objVisitNumber.LabLocDr.BTCode			
		}
		// 检查送检记录是否是（检出菌、常规检验、PCT（降钙素原）、CRP（C反映蛋白）、G试验、M试验）
		Set xTestSetDesc="",checkFlg=0
		For {
			Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			
			Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))
			Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
			Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
			Continue:'$isobject(objTestSetMap)
			Continue:'$isobject(objTestSetMap.BTMapItemDr)
			Continue:'$IsObject(objTestSetMap.BTMapItemDr.BTCatDr)
			Set MapTSDesc=objTestSetMap.BTMapItemDr.BTTestSet
			Set MapTSCatDesc=objTestSetMap.BTMapItemDr.BTCatDr.BTDesc
			Continue:(MapTSCatDesc'="常规检验")
			Set checkFlg =1
		}
		Continue:checkFlg=0
		
		Kill arrVisitReport
		Set xTestSetDr=""
		
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
				Continue:'$IsObject(objVisitReport)
				Set IsActive = objVisitReport.LabIsActive						
				Set VisitReportID = objVisitReport.%Id()
				Set LabReportID = objVisitReport.LabReportID
				Set LabRepOrder = 1 //objVisitReport.LabRepOrder  //报告序号				
				Set objVisitTestSet=objVisitReport.LabTestSetDr
				Continue:'$IsObject(objVisitTestSet)
				Set TestSetDesc=objVisitTestSet.LabTestSetDesc  //检验医嘱
				Set AuthDate=objVisitReport.LabAuthDate
				Set FlagBug = +$zdh("2019-11-01",3)
				Continue:(IsActive=0)&(AuthDate>=FlagBug)  //历史处理状态问题20191101才开始判断
				Set AuthTime=objVisitReport.LabAuthTime
				Set:AuthDate'="" AuthDate=$zd(AuthDate,3)
				Set:AuthTime'="" AuthTime=$zt(AuthTime,1)
				
				Set xTestCode=""
				For {
					Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
					Quit:xTestCode=""
					
					//筛查检验项目
					Set objTCMap=##class(DHCHAI.DP.LabTCMap).GetObjByTestCode(SCode,xTestCode)
					Continue:'$IsObject(objTCMap)
					Set TCMapID=objTCMap.%Id()
					Continue:'$d(^DHCHAI.IR.CRuleTestAbI("TC","IdxofTestCodeDr",TCMapID))		
					Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode,0))
					Continue:xRstID=""
					Set objRst=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRstID)
					Continue:'$IsObject(objRst)
					Set ResultID=objRst.%Id()
					Set TestCode=objRst.LabTestCode
					Continue:TestCode=""
					Set TestDesc=objRst.LabTestDesc
					Set LabResult =objRst.LabResult
					Set:LabResult["-" LabResult =$p(LabResult,"-",2)
					Set LabResult = +LabResult
					Set LabResult=$fn(LabResult,",",2)
					
					Set abnormal=0
					Set:(objRst.LabAbFlag'="")&(objRst.LabAbFlag'="N") abnormal=1
					//维护了筛查规则
					Continue:'$d(^DHCHAI.IR.CRuleTestAbI("TC","IdxofTestCodeDr",TCMapID)) 
					Set requesttime=CollDate_" "_CollTime
					Set reporttime=AuthDate_" "_AuthTime
					//修改字段xVisitNumberDr->xVisitReportDr 
					Set RoutData=aLineFlag_aLv_LvN_"<rout testno="""_xVisitReportDr_""" rindex="""_LabRepOrder_""" specimen="""_Specimen_""""
					Set RoutData=RoutData_" requesttime="""_requesttime_""" reporttime="""_reporttime_""""
					Set RoutData=RoutData_" rtype="""_TestSetDesc_""" ritem="""_TestDesc_""" rvalue="""_LabResult_""" abnormal="""_abnormal_""" dept="""_dept_"""/>"
					
					Set:RoutDataAll'="" RoutDataAll=RoutDataAll_RoutData
					Set:RoutDataAll="" RoutDataAll=RoutData
					Set LabRepOrder=LabRepOrder+1
				}				
			}
		}
	}
	
	if (RoutDataAll="")
	{
		//无数据	
		Set return = aLv_"<rout-list/>"	
	}
	else
	{
		Set return = aLv_"<rout-list>"_RoutDataAll
		Set return =return_aLineFlag_aLv_"</rout-list>"
	}
	
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeTempList(44976,$c(2)," ")
ClassMethod GetEpisodeTempList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return =""
	Set LvN = " "
	Set xID = ""	
	Set TempDataAll =""
	Set NIndex="GetEpisodeTempList"
	Kill ^TMP($zn,$j,NIndex)
	Set BZValue = 38 //超过标准
	For {
		Set xID = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		
		Set objObservation = ##class(DHCHAI.DP.MRObservations).GetObjById(xID)
		Continue:'$isobject(objObservation)
		
		Set IsActive  = objObservation.OBIsActive
		Set ItemDesc  = objObservation.OBItemDesc
		Set EntryDate = objObservation.OBEntryDate
		Set EntryTime = objObservation.OBEntryTime
		Set SCode  	  = objObservation.OBSCode
		Set XCode  	  = objObservation.OBXCode
		Continue:IsActive=0		//无效
		Continue:(EntryDate="")||(EntryTime="")
		
		Set objItemMap = ##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(SCode,ItemDesc)
		
		Continue:'$isobject(objItemMap)
		Continue:'$isobject(objItemMap.BTMapItemDr)
		Continue:'$isobject(objItemMap.BTMapItemDr.BTCatDr)
		Set OBSItemCatBTDesc=objItemMap.BTMapItemDr.BTCatDr.BTDesc
		Continue:(OBSItemCatBTDesc'="体温")
		Set Value = +objObservation.OBItemValue
		Continue:Value<=0
		Continue:Value>47  //max-46.5
		Continue:(Value<=(+BZValue))
		Continue:(+$g(^TMP($zn,$j,NIndex,EntryDate,"maxVal")))>(+Value)
		Set ^TMP($zn,$j,NIndex,EntryDate,"maxVal")=Value_"^"_EntryTime		
		
	}
	//取值输出
	Set xTDate = ""
	For {
		Set xTDate = $o(^TMP($zn,$j,NIndex,xTDate))
		Quit:xTDate=""
		Set Value=$p(^TMP($zn,$j,NIndex,xTDate,"maxVal"),"^",1)
		Set xTDateTime =$p(^TMP($zn,$j,NIndex,xTDate,"maxVal"),"^",2)
		Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,xTDate,xTDateTime)
		Set WardDr = $p(TransInfo,"^",2)
		Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
		Set:$Isobject(objWard) dept = objWard.BTCode
		Set recorddate = $zd(xTDate,3)_" "_$zt(xTDateTime,1)
		//增加一天只显示最高体温
		
		Set TempData=aLineFlag_aLv_LvN_"<temp recorddate="""_recorddate_""" value="""_Value_""" dept="""_dept_"""/>"
		Set:TempDataAll'="" TempDataAll=TempDataAll_TempData
		Set:TempDataAll="" TempDataAll=TempData
	}
	if (TempDataAll="")
	{
		//无数据	
		Set return = aLv_"<temp-list/>"	
	}
	else
	{
		Set return = aLv_"<temp-list>"_TempDataAll
		Set return =return_aLineFlag_aLv_"</temp-list>"
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细 
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetEpisodeInfList(167,$c(2)," ")
ClassMethod GetEpisodeInfList(aEpisodeID As %String, aLv As %String = "", aLineFlag As %String = "") As %String
{
	New (aEpisodeID,aLv,aLineFlag)
	Set return = aLv_"<inf-list/>" //无数据
	Quit return  //暂时不传
	Quit:aEpisodeID="" return
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)	
	Quit:'$Isobject(objPaadm) return
	Set:$Isobject(objPaadm) AdmDate = objPaadm.PAAdmDate
	Set:$Isobject(objPaadm) AdmTime = objPaadm.PAAdmTime
	//患者疑似状态信息 	
 	Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,0))
	Quit:AttID="" return
	Set objAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(AttID)
	Quit:'$IsObject(objAtt) return
	Set IsSusInf=objAtt.CSIsSusInf    //疑似病例  （1疑似病例）
	Set IsSuspend=objAtt.CSIsSuspend  //处置病例  （0待处理、1已确诊、2已排除、3已上报）
	
	Quit:IsSusInf'="1" return  //疑似状态
	Set arrResult=##class(DHCHAI.IRC.CSResultSrv).GetScreenResult(aEpisodeID)
 	//Quit:arrResult.Count()<1 return  //没有征兆 只表示没有待处理的征兆
	Set LvN =" "
	Set InfDataAll =""
	Set Count=arrResult.Count()	
 	For indArr=1:1:Count {
	 	//Continue:IsSuspend'=0
		Set obj=arrResult.GetAt(indArr)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.CSItmScreenDr)
		Set ItmScreenID   = obj.CSItmScreenDr.%Id()
		Set ItmScreenTxt  = obj.CSItmScreenTxt
		Set ResultNote    = obj.CSResultNote
		//Set ResultDate=$tr(ResultDate,"-","")
		Set ResultDate    = obj.CSResultDate
		Set ResultCnt     = obj.CSResultCnt
		Set RstFromDate   = obj.CSRstFromDate
		Set RstToDate     = obj.CSRstToDate
		Set RstStatus     = obj.CSRstStatus
		Set OprStatus     = obj.CSOprStatus
		Continue:OprStatus'=0
		//w "OprStatus="_OprStatus,! No=未保存
		Set rid = "No"_aEpisodeID_"|"_ItmScreenID_"|"_RstFromDate //就诊id+项目id+开始时间
		Continue:RstStatus'=1  //组合条件
		Set state= "疑似"
		Set infectedTime="",infectedDept="",isnosocomial="院内",infectedDept=""
		Set note = obj.CSItmScreenDr.CCDesc
		Set:ItmScreenID=2 note = ItmScreenTxt //检出菌
		Set generatetime= ""  //征兆生成时间
		Set:RstFromDate'="" infectedTime = $zd(RstFromDate,3)_" 23:59:59"
		Set generatetime = $zd(objAtt.CSSusDate,3)_" "_$zt(objAtt.CSSusTime,1)
		//通过时间取病区
		Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,RstFromDate,"23:59:59")
		Set WardDr = $p(TransInfo,"^",2)
		Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
		Set:$Isobject(objWard) infectedDept = objWard.BTCode
		Set IPHour=((RstFromDate-AdmDate)*24)+(($zth("23:59:59",1)-AdmTime)\3600)  //排除CA入院小于48小时
		Set:IPHour<=48 isnosocomial = "院外"
		if (ItmScreenID=1)
		{
			//自报感染 审核的，当做确诊预警
			Set state="确诊"
			Set InfDiagnosDr = obj.CSInfDiagnosDr
			Continue:InfDiagnosDr=""
			Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagnosDr)
			Set ReportCnt=listReports.Count()
			Continue:ReportCnt<1
			Set objReport=listReports.GetAt(1)
			Continue:'$IsObject(objReport)
			If $IsObject(objReport.IRStatusDr) {
				Set ReportStatusID=objReport.IRStatusDr.%Id()
				Set ReportStatusCode=objReport.IRStatusDr.BTCode
				Set ReportStatusDesc=objReport.IRStatusDr.BTDesc
			}
			Set ReportID = objReport.%Id()
			Continue:(ReportStatusCode'="3")  //提交审核的报告 (ReportStatusCode'="2")&
			Set ReportDate=objReport.IRRepDate
			Set ReportTime=objReport.IRRepTime
			Set objDias=##class(DHCHAI.IR.INFDiagnos).GetObjById(InfDiagnosDr)
			Continue:'$IsObject(objDias.IRInfPosDr)		
			Set reportdoctor = objReport.IRRepUser.BTDesc  //上报人
			Set reporttimeR = $zd(ReportDate,3)_" "_$zt(ReportTime,1)
			//审核人
			Set confirmer=""
			Set xLogDr=""
			For {
				Set xLogDr=$o(^DHCHAI.IR.INFReportD(ReportID,"LOG",xLogDr),-1)
				Quit:(xLogDr="")||(confirmer'="")
				Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(ReportID_"||"_xLogDr)
				Continue:'$IsObject(objLog)
				Continue:'$IsObject(objLog.IRStatusDr)
				Set StatusCode=objLog.IRStatusDr.BTCode
				Continue:(StatusCode'="3")   // 审核
				Set confirmer = objLog.IRUpdateUserDr.BTDesc
				Set confirmedtime=$zd(objLog.IRUpdateDate,3)_" "_$zt(objLog.IRUpdateTime,1)
			}
			Set InfDate = objDias.IRInfDate
			Set infectedTime = $zd(InfDate,3)_" 23:59:59"  //用的默认时间
			Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"23:59:59") 
			Set WardDr = $p(TransInfo,"^",2)
			Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
			Set:$Isobject(objWard) infectedDept = objWard.BTCode
			Set:InfDate-AdmDate<2 isnosocomial="院外"
			Set gid = "IG"_InfDiagnosDr
			Set InfData = aLineFlag_aLv_LvN_"<inf rid="""_rid_""" state="""_state_""" note="""_note_""""
			Set InfData =InfData_" generatetime="""_generatetime_""" reportdoctor="""_reportdoctor_""" reporttime="""_reporttimeR_""" reportcontent=""1"""
			Set InfData =InfData_" confirmer="""_confirmer_""" confirmedtime="""_confirmedtime_""""
			Set InfData =InfData_" infected_time="""_infectedTime_"""infected_dept="""_infectedDept_""" isnosocomial="""_isnosocomial_""" gid="""_gid_"""/>"
						
		}
		else
		{
			Set InfData = aLineFlag_aLv_LvN_"<inf rid="""_rid_""" state="""_state_""" note="""_note_""" generatetime="""_generatetime_"""" 
			Set InfData =InfData_" infected_time="""_infectedTime_""" infected_dept="""_infectedDept_""" isnosocomial="""_isnosocomial_"""/>"
 		
		}		
 		Set:InfDataAll'="" InfDataAll=InfDataAll_InfData
 		Set:InfDataAll="" InfDataAll = InfData
 	}
 	//院感科确诊排除病例因为没有关联感染部位暂无法上传
 	/*
 	//必须临床上报报告表示确认，否则认为没有操作
 	Set xID = 0
 	For {
	 	Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeID,xID))
	 	Quit:xID=""
	 	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
		Quit:'$IsObject(objScreen)
		Set OprStatus=objScreen.CSStatus
		Set RstFromDate=objScreen.CSRstFromDate
		Set RstToDate=objScreen.CSRstToDate
		Set ActDate =objScreen.CSActDate
		
	}
 	*/
 	//临床上报审核流程作为一类预警信息(院感科确认，临床确认即上报;排除，临床确认) 
 		
 	Set xScreenID = ""
	For {
		Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
		Quit:xScreenID=""
		Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
		Continue:'$IsObject(objScreen)
		Continue:(+objScreen.CSStatus'=1)&(+objScreen.CSStatus'=2)
		Set state =""
		Set:objScreen.CSStatus=1 state="确认"
		Set:objScreen.CSStatus=2 state="排除"
		Set ItmScreenID =objScreen.CSItmScreenDr.%Id()
		Set note = objScreen.CSItmScreenDr.CCDesc
		Set:ItmScreenID=2 note = ItmScreenTxt //检出菌 
		Set generatetime=$zd(objScreen.CSRstFromDate+1,3)_" 23:59:59"
		Set reportdoctor="",reporttimeR="",confirmer="",confirmedtime="",infectedTime="",infectedDept="",isnosocomial="院内",gid=""
		//(成人|新生儿)报告，如果只有一份报告则gid直接赋值，若多份报告感染日期和结果开始日期最接近用那份
		Set aRepType ="1|2"
		Set CntFlag = 0 //感染计数
		For Ind = 1:1:$length(aRepType,"|"){
			Set xRepType = $p(aRepType,"|",Ind)
			Continue:xRepType=""		
			Set xRepID=0
			Set (ReportUserID,ReportUserDesc)=""
			Set (ReportDate,ReportTime,ReportStatusID,ReportStatusCode,ReportStatusDesc)=""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xRepID))
				Quit:xRepID=""			
				Set ReportID=xRepID
				Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
				Continue:'$IsObject(objReport)
				If $IsObject(objReport.IRStatusDr) {
					Set ReportStatusID=objReport.IRStatusDr.%Id()
					Set ReportStatusCode=objReport.IRStatusDr.BTCode
					Set ReportStatusDesc=objReport.IRStatusDr.BTDesc
				}
				
				Continue:(ReportStatusCode'="3")  //提交审核的报告 (ReportStatusCode'="2")&
				Set ReportDate=objReport.IRRepDate
				Set ReportTime=objReport.IRRepTime
								
				Set aDataType = "DHCHAI.IR.INFDiagnos"			
				Set InfDiagList=objReport.GetRepLinkIDs(aDataType)
				For indInfD=1:1:$l(InfDiagList,","){													
					Set xInfDiagnosID=$p(InfDiagList,",",indInfD)
					Continue:xInfDiagnosID=""	
					Set objDias=##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagnosID)
					Continue:'$IsObject(objDias.IRInfPosDr)						
					If (CntFlag =0)
					{						
						Set reportdoctor = objReport.IRRepUser.BTDesc  //上报人
						Set reporttimeR = $zd(ReportDate,3)_" "_$zt(ReportTime,1)
						//审核人
						Set xLogDr=""
						For {
							Set xLogDr=$o(^DHCHAI.IR.INFReportD(ReportID,"LOG",xLogDr),-1)
							Quit:(xLogDr="")||(confirmer'="")
							Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(ReportID_"||"_xLogDr)
							Continue:'$IsObject(objLog)
							Continue:'$IsObject(objLog.IRStatusDr)
							Set StatusCode=objLog.IRStatusDr.BTCode
							Continue:(StatusCode'="3")   // 审核
							Set confirmer = objLog.IRUpdateUserDr.BTDesc
							Set confirmedtime=$zd(objLog.IRUpdateDate,3)_" "_$zt(objLog.IRUpdateTime,1)
						}
						Set InfDate = objDias.IRInfDate
						Set infectedTime = $zd(InfDate,3)_" 23:59:59"  //用的默认时间
						Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"23:59:59") 
						Set WardDr = $p(TransInfo,"^",2)
						Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
						Set:$Isobject(objWard) infectedDept = objWard.BTCode
						Set:InfDate-AdmDate<2 isnosocomial="院外"
						Set gid = xInfDiagnosID
						Set CntFlag =CntFlag+1
					}
					else
					{
						Set InfDateN = objDias.IRInfDate
						if ($zabs(InfDate-objScreen.CSRstFromDate)>$zabs(InfDateN-objDias.IRInfDate))
						{
							//更合适的感染部位
							Set reportdoctor = objReport.IRRepUser.BTDesc  //上报人
							Set reporttimeR = $zd(ReportDate,3)_" "_$zt(ReportTime,1)
							//审核人
							Set xLogDr=""
							For {
								Set xLogDr=$o(^DHCHAI.IR.INFReportD(ReportID,"LOG",xLogDr),-1)
								Quit:(xLogDr="")||(confirmer'="")
								Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(ReportID_"||"_xLogDr)
								Continue:'$IsObject(objLog)
								Continue:'$IsObject(objLog.IRStatusDr)
								Set StatusCode=objLog.IRStatusDr.BTCode
								Continue:(StatusCode'="3")   // 审核
								Set confirmer = objLog.IRUpdateUserDr.BTDesc
								Set confirmedtime=$zd(objLog.IRUpdateDate,3)_" "_$zt(objLog.IRUpdateTime,1)
							}
							Set InfDate = objDias.IRInfDate
							Set infectedTime = $zd(InfDate,3)_" 23:59:59"  //用的默认时间
							Set TransInfo = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"23:59:59") 
							Set WardDr = $p(TransInfo,"^",2)
							Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
							Set:$Isobject(objWard) infectedDept = objWard.BTCode
							Set:InfDate-AdmDate<2 isnosocomial="院外"
							Set gid = xInfDiagnosID
						}
						Set CntFlag =CntFlag+1 
					}
				}
			}
		}
		Continue:gid="" //没有感染部位
		Set gid="IG"_gid
		Set InfData = aLineFlag_aLv_LvN_"<inf rid="""_xScreenID_""" state="""_state_""" note="""_note_""""
		Set InfData =InfData_" generatetime="""_generatetime_""" reportdoctor="""_reportdoctor_""" reporttime="""_reporttimeR_""" reportcontent=""1"""
		Set InfData =InfData_" confirmer="""_confirmer_""" confirmedtime="""_confirmedtime_""""
		Set InfData =InfData_" infected_time="""_infectedTime_"""infected_dept="""_infectedDept_""" isnosocomial="""_isnosocomial_""" gid="""_gid_"""/>"
		
		Set:InfDataAll'="" InfDataAll=InfDataAll_InfData
 		Set:InfDataAll="" InfDataAll = InfData
	}
 		
 	
 	if (InfDataAll'="")
	{
		Set return = aLv_"<inf-list>"_InfDataAll
		Set return =return_aLineFlag_aLv_"</inf-list>"
	}
	Quit return
}

/// aEpisodeID 就诊号
/// 返回单个患者的xml内容明细
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetPatDtls()
ClassMethod GetPatDtls(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return = "<note>的院感过程数据</note>"	
	Quit return
}

/// w ##class(DHCHAI.IO.ToSzNIDPSrv).ExportReportSum(15,15)
ClassMethod ExportReportSum(aFromDate As %String, aToDate As %String, aCount As %String, aGidNo As %String, aHospIDs As %String = "") As %String
{
	New (aFromDate,aToDate,aCount,aGidNo,aHospIDs)
	Set return=""
	//生成汇总文件
	Quit:aGidNo="" return
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	
	Set LineFlag = $c(2)   //文件换行
	Set Lv1 =""             //顶层格式控制
	Set Lv2 =" "			//二层单空格缩进控制
	Set Lv3 ="  "
	Set return="<?xml version=""1.0"" encoding=""UTF-8""?>"
	Set return = return_LineFlag_Lv1_"<summary>"
	Set return = return_LineFlag_Lv2_"<gid>"_aGidNo_"</gid>"
	Set return = return_LineFlag_Lv2_"<type>1</type>"
	Set return = return_LineFlag_Lv2_"<date-from>"_aFromDate_"</date-from>"
	Set return = return_LineFlag_Lv2_"<date-to>"_aToDate_"</date-to>"
	Set YYMMVal = $p(aFromDate,"-",1)_"年"_(+$p(aFromDate,"-",2))_"月"
	Set return = return_LineFlag_Lv2_"<note>"_YYMMVal_"医院的院感过程数据</note>"
	Set CurrDt = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
	Set return = return_LineFlag_Lv2_"<rstamp>"_CurrDt_"</rstamp>"
	Set return = return_LineFlag_Lv2_"<caseCount>"_aCount_"</caseCount>"
	Set return = return_LineFlag_Lv2_"<creator>东华医为</creator>"
	Set return = return_LineFlag_Lv2_"<dept-list>"
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
	    Continue:(aHospIDs'="")&($listfind(aHospIDs,xHospID)<1)
	    
		Set xID=0
		For {
			Set xID = $o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xID))
			Quit:xID=""
			Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xID)
			Continue:'$isobject(objLoc)
			
			Set LocCode	    = objLoc.BTCode
			Set LocDesc	    = ..ChangeKeyStr(objLoc.BTDesc)
			Set LocDesc2	= ..ChangeKeyStr(objLoc.BTDesc2)
			Continue:((LocDesc["停用")||(LocDesc2["停用"))
			Set IsActive	= objLoc.BTIsActive			
			Set IsActive=$s(IsActive=1:"是",IsActive=0:"否",1:"是")
			Continue:(IsActive="否")
			Set LocTypeDr="",LocTypeCode="",LocTypeDesc=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocTypeDr 	= objLoc.BTTypeDr.%Id()
				Set LocTypeCode	= objLoc.BTTypeDr.BTCode
				Set LocTypeDesc	= objLoc.BTTypeDr.BTDesc
			}
			Continue:(LocTypeCode'="W")
			Set:LocDesc2="" LocDesc2 = LocDesc
			Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
			
			Set IsICU	    = objLoc.BTIsICU
			Set IsICU=$s(IsICU=1:"true",IsICU=0:"false",1:"true")
			Set IsNICU	    = objLoc.BTIsNICU
			Set IsNICU=$s(IsNICU=1:"true",IsNICU=0:"false",1:"true")			
			Set return = return_LineFlag_Lv3_"<dept code="""_LocCode_""" label="""_LocDesc2_""" icu="""_IsICU_""" newbaby="""_IsNICU_"""/>"
		}
	}	
	Set return = return_LineFlag_Lv2_"</dept-list>"	
	Set return = return_LineFlag_Lv1_"</summary>"
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2019-08-01
/// Description:  获取报告信息
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       DHCHAI.IR.INFRepExt.IRDataType
///               DHCHAI.IR.INFRepExt.IRObjectID
/// Return：      返回List
/// w ##class(DHCHAI.IO.ToSzNIDPSrv).GetINFReportsDia(10,-100000000000000)
ClassMethod GetINFReportsDia(aEpisodeID As %String, aRepLabID As %String) As %String
{
	New (aEpisodeID,aRepLabID)
	
	Set aDataType = "DHCHAI.IR.INFLab" 	
	Set return=0
	Quit:(aEpisodeID="")||(aRepLabID="") return
	Set xObjectID = 0
	For {
		Set xObjectID = $o(^DHCHAI.IR.INFLabI("IndexEpisodeLabRepDr",aEpisodeID,aRepLabID,xObjectID))
		Quit:xObjectID=""
		Set aObjectID = xObjectID
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt(aDataType,"U")," "_$zcvt(aObjectID,"U"),xRepID))
			Quit:xRepID=""
			
			Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.IRStatusDr)
			Set StatusCode=objRep.IRStatusDr.BTCode
			Continue:(StatusCode'=3)&(StatusCode'=2) //提交 审核
			Set RepType =objRep.IRRepType
			Continue:(RepType'="1")&&(RepType'="2") 			
			// 感染诊断信息 id,id
			Set LinkDiags = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			Set return = +LinkDiags
		}
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2019-08-01
/// Description:  获取报告信息
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       DHCHAI.IR.INFRepExt.IRDataType
///               DHCHAI.IR.INFRepExt.IRObjectID
/// Return：      返回List
/// w ##class(DHCHAI.IO.ToSzNIDPSrv).CompareDateTimeDiff("2019-08-05","17:30:00","2019-08-05","17:30:00")
ClassMethod CompareDateTimeDiff(aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String) As %Integer
{
	New (aFromDate,aFromTime,aToDate,aToTime)
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	
	Set return = 0
	Quit:(aFromDate="")||(aFromTime="")||(aToDate="")||(aToTime="") return
	Set return = (aToDate*24*3600+aToTime)-(aFromDate*24*3600+aFromTime)
	Quit return
}

/// 取单个手术信息
ClassMethod BuildOperData(aOperAnaesID As %String, aOperType As %String) As %String
{
	New (aOperAnaesID,aOperType)
	Set return=""
	Quit:aOperAnaesID="" return
	
	Set objOper = ##class(DHCHAI.DP.OROperAnaes).GetObjById(aOperAnaesID)
	Quit:'$isobject(objOper) return
	Set ORXCode =objOper.ORXCode
	Set IsActive 	= objOper.ORIsActive
	Quit:IsActive'=1 return
	
	Set SCode 		= objOper.ORSCode
	Set OperICD 	= objOper.OROperICD
	Set OperDesc 	= objOper.OROperDesc
	Set OperType 	= objOper.OROperType
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"OperType",OperType)  
	If (PhraseMap'="") {
		Set OperTypeID  = $p(PhraseMap,"^",1)
		Set OperType 	= $p(PhraseMap,"^",3)
	}Else {
		Set OperTypeID  = ""
	}
	Quit:(aOperType'="")&&(aOperType'=OperType) return
	
	Set OperDate 	= objOper.OROperDate
	;Set SttTime 	= objOper.ORSttTime
	Set EndDate 	= objOper.OREndDate
	;Set EndTime 	= objOper.OREndTime
	
	
	////手术开始结shu时间优先取手麻接口
	Set ssStr=""
	Set ssStr= ..GetKSSTimeByOpaId(ORXCode)
	Set SttTime=$p(ssStr,$c(3),2)
	Set EndTime=$p(ssStr,$c(3),6)
	
	Set:SttTime="" SttTime = objOper.ORSttTime
	Set:EndTime="" EndTime = objOper.OREndTime
	
	Set OperHour 	= objOper.OROperHour
	Set objOperLoc 	= objOper.OROperLocDr
	Set (OperLocID,OperLoc)=""
	If $isobject(objOperLoc){
		Set OperLocID = objOperLoc.%Id()
		If objOperLoc.BTDesc2'=""{
			Set OperLoc = objOperLoc.BTDesc2
		}else{
			Set OperLoc = objOperLoc.BTDesc
		}
	}
	If (OperLoc=""){
		Set OperLocID = $p(objOper.OROperLoc,"|",1)
		Set OperLoc   = $p(objOper.OROperLoc,"|",3)
	}
	Set Opertor = objOper.OROpertor
	Set OpertorCode=$p(Opertor,"|",2)
	Set OpertorName=$p(Opertor,"|",3)
	Set Assistant1 	= objOper.ORAssistant1
	Set Assistant2 	= objOper.ORAssistant2
	Set Incision 	= objOper.ORIncision
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
	If (PhraseMap'="") {
		Set IncisionID  = $p(PhraseMap,"^",1)
		Set Incision 	= $p(PhraseMap,"^",3)
	}Else {
		Set IncisionID  = ""
	}
	Set Healing 	= objOper.ORHealing
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",Healing)  
	If (PhraseMap'="") {
		Set HealingID   = $p(PhraseMap,"^",1)
		Set Healing 	= $p(PhraseMap,"^",3)
	}Else {
		Set HealingID   = ""
	}
	Set AnesMethod 	= objOper.ORAnesMethod
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"Anesthesia",AnesMethod)  
	If (PhraseMap'="") {
		Set AnesMethodID  	= $p(PhraseMap,"^",1)
		Set AnesMethod 		= $p(PhraseMap,"^",3)
	}Else {
		Set AnesMethodID   	= ""
	}
	Set Anesthesia 	= objOper.ORAnesthesia
	Set ASAScore 	= objOper.ORASAScore
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
	If (PhraseMap'="") {
		Set ASAScoreID  = $p(PhraseMap,"^",1)
		Set ASAScore 	= $p(PhraseMap,"^",3)
	}Else {
		Set ASAScoreID  = ""
	}
	Set NNISGrade 	= objOper.ORNNISGrade
	Set PhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
	If (PhraseMap'="") {
		Set NNISGradeID = $p(PhraseMap,"^",1)
		Set NNISGrade 	= $p(PhraseMap,"^",3)
	}Else {
		Set NNISGradeID = ""
	}
	Set WBC 		= objOper.ORWBC
	Set IncisionNum = objOper.ORIncisionNum
	Set IsSightGlass= objOper.ORIsSightGlass
	Set IsImplants 	= objOper.ORIsImplants
	Set LoseBlood 	= objOper.ORLoseBlood
	Set GotBlood 	= objOper.ORGotBlood
	Set Complication= objOper.ORComplication
	Set return = $lb(aOperAnaesID,aEpisodeID,OperICD,OperDesc,OperTypeID,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocID,OperLoc,OpertorName,OpertorCode,Assistant1,Assistant2,IncisionID,Incision,HealingID,Healing,AnesMethodID,AnesMethod,Anesthesia,ASAScoreID,ASAScore,NNISGradeID,NNISGrade,WBC,IncisionNum,IsSightGlass,IsImplants,LoseBlood,GotBlood,Complication)
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-08-04
/// Description:  计算两个时间的间隔小时数（时差-小时）
/// Input：       aFromDate ：开始日期  YYYY-MM-DD 或者 数字格式
///               aFromTime : 开始时间  HH:MM:SS   或者 数字格式
///               aEndDate  ：结束日期  YYYY-MM-DD 或者 数字格式
///               aEndTime  : 结束时间  HH:MM:SS   或者 数字格式
/// Return:		  时间间隔小时数
/// Debug:		  w ##class(DHCHAI.IO.ToSzNIDPSrv).GetHourByDateTime("2017-08-04","01:00:00","2017-08-04","05:00:00")
ClassMethod GetHourByDateTime(aFromDate As %String, aFromTime As %String, aEndDate As %String, aEndTime As %String) As %String
{
	New (aFromDate,aFromTime,aEndDate,aEndTime)
	Set return=0
	Quit:(aFromDate="")||(aFromTime="")||(aEndDate="")||(aEndTime="") return
	Set Hours=0
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	Set:aEndTime[":" aEndTime=$zth(aEndTime,1)
	Quit:(aFromDate>aEndDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aEndDate)&&(aFromTime>aEndTime) return
	
	If (aFromDate=aEndDate) {
		Set HoursNumber = $Number((aEndTime-aFromTime)/3600,1) 
		If (HoursNumber["."){
			Set Hours = $e(HoursNumber,0,1)+1
		}else{
			Set Hours = $e(HoursNumber,0,1)
		}
		
		//Set Hours=$Number((aEndTime-aFromTime)/3600,0)+1     // 向上取整
	} Else {  // aFromDate<aEndDate
		Set DayHours=(aEndDate-aFromDate)*24
		//Set tmpHours=$Number((aEndTime-aFromTime)/3600,0)+1  // 向上取整
		Set tmpHours=$Number((aEndTime-aFromTime)/3600,1)  // 向上取整
		If (tmpHours["."){
			Set Hours = $e(tmpHours,0,1)+1
		}else{
			Set Hours = $e(tmpHours,0,1)
		}
		Set Hours=DayHours+tmpHours
	}
	Set return = Hours
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2019-08-05
/// Description:  判断在一段时间内是否使用预防/治疗抗菌药物
/// Return：      1：使用    0：未使用
/// w ##class(DHCHAI.STAT.S260AIncAntUse).CheckUesAnti(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod CheckUesAnti(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String, aPuro As %String = "预防") As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime,aPuro)
	Set return=0
	Quit:(aEpisodeDr="") return
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	Set UseAntiFlg =0
	Set xSCode=""
	Set lastDate = "",lastTime=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:((xSCode=""))
		
		For xSttDate=aFromDate:1:aToDate {
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:((xID=""))
				Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
				Continue:'$IsObject(objOrdItem)
				Continue:objOrdItem.OEIsActive=0
				Set AntUsePurpose = objOrdItem.OEAntUsePurpose
				Continue:AntUsePurpose'[aPuro
				Set OESttDate = objOrdItem.OESttDate   // 执行医嘱日期
				Set OESttTime = objOrdItem.OESttTime   // 执行医嘱时间
				If (xSttDate=aFromDate) {
					Continue:((aFromTime'="")&&(OESttTime<aFromTime))
				}
				If (xSttDate=aToDate) {
					Continue:((aToTime'="")&&(OESttTime>aToTime))
				}
				Set UseAntiFlg=1
				Set lastDate=OESttDate
				Set lastTime=OESttTime
			}
		}
	}
	Set return=UseAntiFlg_"^"_lastDate_","_lastTime
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-27
/// Description:  取转科科室信息
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeID : 就诊号
///               aLocType : 科室类型(E科室、W病区)
/// Return：      返回String=入院科室_"^"_当前科室_"^"_入科日期_"^"_入科来源
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocInfo(691,"W")
ClassMethod GetTransLocInfo(aEpisodeID As %String, aLocType As %String) As %String
{
	New (aEpisodeID,aLocType)
	Set return=""
	Quit:(aEpisodeID="")||(aLocType="") return
	
	Set aLocType=$zcvt(aLocType,"U")
	Quit:(aLocType'="E")&&(aLocType'="W") return
	
	//取入院科室、入院日期信息
	Set InHospDate="",InHospLocID="",InHospLocDesc=""
	//取入科日期、入院来源
	Set CurrLocID="",CurrLocDesc="",InLocDate="",FromLocID="",FromLocDesc=""
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate))
		Quit:xDate=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate,xID))
			Quit:xID=""
			
			Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xID)
			Continue:'$IsObject(objTrans)
			Continue:'$IsObject(objTrans.PATransLocDr)
			Set objLoc=objTrans.PATransLocDr
			Continue:'$IsObject(objLoc.BTTypeDr)
			Set LocType=objLoc.BTTypeDr.BTCode
			Set LocID=objLoc.%Id()
			Set LocDesc=objLoc.BTDesc
			Set LocDesc2=objLoc.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set TransDate=objTrans.PATransDate
			Set:TransDate'="" TransDate=$zd(TransDate,3)
			Set:objTrans.PATransTime'="" TransDate = TransDate_" "_$zt(objTrans.PATransTime,1)
			//Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			
			If InHospLocID="" {
				Set InHospDate=TransDate
				Set InHospLocID=LocID
				Set InHospLocDesc=LocDesc
			}
			
			If CurrLocID'=LocID {
				Set FromLocID=CurrLocID
				Set FromLocDesc=CurrLocDesc
				Set CurrLocID=LocID
				Set CurrLocDesc=LocDesc
				Set InLocDate=TransDate
			}
		}
	}
	
	Set return=InHospDate
	Set return=return_"^"_InHospLocID_"^"_InHospLocDesc
	Set return=return_"^"_InLocDate
	Set return=return_"^"_CurrLocID_"^"_CurrLocDesc
	Set return=return_"^"_FromLocID_"^"_FromLocDesc
	Quit return
}

/// 取分床时间即作为入院的真正时间
/// w ##Class(DHCHAI.IO.ToSzNIDPSrv).GetAdmInBedDT(17041)
ClassMethod GetAdmInBedDT(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set FtFlag = 1  //1-是否深圳福田医院 0 -其他svn上用
	Set ret = ""
	If (FtFlag=1)
	{
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
		Set EpisodeIDx = objAdm.PAEpisodeIDx
		Set ret = ##class(web.DHCDischargeHistory).GetAdminDateTime($p(EpisodeIDx,"||",2))
		Set:ret="^" ret =""
	}
	else
	{
		//非福田 返回空 以就诊表就诊时间为准
	}
	Quit ret
}

/// Creator：     liyi
/// CreatDate：   2017-08-28
/// Description:  病历查询
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PAAdmSrv","QryAdm","4^99^2020-06-01^2020-06-30^^^^^")
Query QryAdm(aIntputs As %String) As %Query(ROWSPEC = "EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Nation:%String,Birthday:%String,Age:%String,IdentityCode:%String,HomeAddress:%String,Company:%String,RelativeName:%String,RelativeTel:%String,IsDeath:%String,DeathDate:%String,DeathTime:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,IsNewBaby:%String,BirthWeight:%String,AdmitWeight:%String,AdmTimes:%String,AdmDays:%String,MainDiag:%String,AdmitDiag:%String,OtherDiag:%String,DischDiag:%String") [ SqlProc ]
{
}

ClassMethod QryAdmExecute(ByRef qHandle As %Binary, aIntputs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aIntputs="" $$$OK
 	Set ^HHLTestQryAdm=$lb(aIntputs)
 	
 	Set aHospIDs 	= $p(aIntputs,"^",1)
 	Set aDateType	= $p(aIntputs,"^",2)
 	Set aDateFrom 	= $p(aIntputs,"^",3)
 	Set aDateTo 	= $p(aIntputs,"^",4)
 	Set aLocationID = $p(aIntputs,"^",5)
 	Set aWardID 	= $p(aIntputs,"^",6)
 	Set aPatName 	= $p(aIntputs,"^",7)
 	Set aPapmiNo 	= $p(aIntputs,"^",8)
 	Set aMrNo 		= $p(aIntputs,"^",9)
 	Quit:(aHospIDs="") $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	If aDateType=1{
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xAdmDate = aDateFrom:1:aDateTo{
				Set xAdmTime = ""
				For {
					Set xAdmTime = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime))
					Quit:xAdmTime=""
					
					Set xPaadmId = ""
					For {
						Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime,xPaadmId))
						Quit:xPaadmId=""
						
						Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}elseIf aDateType=2{
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xDisDate = aDateFrom:1:aDateTo{
				Set xDisTime = ""
				For {
					Set xDisTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime))
					Quit:xDisTime=""
					
					Set xPaadmId = ""
					For {
						Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime,xPaadmId))
						Quit:xPaadmId=""
						
						Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}elseIf aDateType=3{
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set PaadmList =""
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xAdmDate = aDateFrom:1:aDateTo{
				Set xAdmTime = ""
				For {
					Set xAdmTime = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime))
					Quit:xAdmTime=""
					
					Set xPaadmId = ""
					For {
						Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime,xPaadmId))
						Quit:xPaadmId=""
						//重复退出
						Continue:$listfind(PaadmList,xPaadmId)>0
						Set PaadmList=PaadmList_$lb(xPaadmId)
						
						Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			
			For xDisDate = aDateFrom:1:aDateTo{
				Set xDisTime = ""
				For {
					Set xDisTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime))
					Quit:xDisTime=""
					
					Set xPaadmId = ""
					For {
						Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDisDate,xDisTime,xPaadmId))
						Quit:xPaadmId=""
						//重复退出
						Continue:$listfind(PaadmList,xPaadmId)>0
						Set PaadmList=PaadmList_$lb(xPaadmId)
						Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID)
						Continue:Data=""
						
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
		Set xDays=-1  //在院患者
		Set xAdmType = ""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xPaadmId=""
				For {
					Set xPaadmId=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xPaadmId))
					Quit:xPaadmId=""
					//重复退出
					Continue:$listfind(PaadmList,xPaadmId)>0
					Set PaadmList=PaadmList_$lb(xPaadmId)
					Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadmId)
					Continue:'$isobject(objPaadm)
					Set AdmDate = objPaadm.PAAdmDate	
					Set AdmTime = objPaadm.PAAdmTime
					//入院日期在结束日期之后排除
					Continue:(AdmDate>aDateTo)
					Set BedDt = ##Class(DHCHAI.IO.ToSzNIDPSrv).GetAdmInBedDT(xPaadmId)	//16595
					Continue:BedDt=""				
					//暂时把新库上线2018-12-01之前的排除
					Continue:(AdmDate<$zdh("2018-12-01",3))
					Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID)
					Continue:Data=""
						
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}elseIf aDateType=99{
		//新的查询规则和同一住院患者规则一样
		//DHCHAI.STAT.S010Inf QryS010Inf
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
 		Quit:(aDateFrom>aDateTo) $$$OK
 		Set PaadmList =""
		//Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
		//同期在科:某段时间的在科人数
    	Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I")
    	For index1=1:1:ListLocArray.Count() {
			Set TransInfo=ListLocArray.GetAt(index1)
			Continue:TransInfo=""
			
			Set Date   = $LIST(TransInfo,1)
			Set Paadm  = $LIST(TransInfo,2)
			
			Set Status = $LIST(TransInfo,3)			
			Set LocID  = $LIST(TransInfo,4)	
			Set TansID = $LIST(TransInfo,5)
			
			Set objPAAdm1=##class(DHCHAI.DP.PAAdm).GetObjById(Paadm)
			Set PAMrNo=objPAAdm1.PAMrNo
			
			Set PAAdmDate=objPAAdm1.PAAdmDate
			If (PAAdmDate'=Date){				//福田：当天入院的应算在内
				Continue:(Status="I")                 // 当天转入不算在内
			}
			//Continue:(Status="A2")              // 当天转入当天转出不算在内
			Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
			Continue:'$IsObject(objLoc)			
			// 医院过滤
			//Continue:'$IsObject(objLoc.BTHospDr)
			//Continue:(aHospIDs'="")&&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)	
						
			//b:Paadm="44959"
			// 全院住院患者人数
			/*
			If '$d(^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm))
			{
				//b:Paadm="40962"
				Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm",Paadm)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","PatAdm"))
				Set ^TMP($zn,$j,NIndex,"Hosp","PatAdm")=num+1
			}
			*/
			//重复退出
			Continue:$listfind(PaadmList,Paadm)>0
			Set PaadmList=PaadmList_$lb(Paadm)
			Set BedDt = ##Class(DHCHAI.IO.ToSzNIDPSrv).GetAdmInBedDT(Paadm)	//16595
			Continue:BedDt=""				
			//暂时把新库上线2018-12-01之前的排除
			//Continue:(AdmDate<$zdh("2018-12-01",3))
			Set Data = ..BuildPaadmData(Paadm,aHospIDs,aLocationID,aWardID)
			Continue:Data=""
				
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
    	}    	
	}elseIf aDateType=""{
		if (aPatName'=""){
			Set Count=0
			Set xPatName = ""
			For {
				Set xPatName=$o(^DHCHAI.DP.PAAdmI("IndexPatName",xPatName))
				Quit:xPatName=""
				
				Continue:'(xPatName[aPatName)
				
				Set xPaadmId = ""
				For {
					Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexPatName",xPatName,xPaadmId))
					Quit:xPaadmId=""
					
					Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID)
					Continue:Data=""
					
					Set Count=Count+1
					Quit:Count>200 //超过200条不在输出
					
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}elseif (aPapmiNo'=""){
			Set xPaadmId = ""
			For {
				Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexPapmiNo",aPapmiNo,xPaadmId))
				Quit:xPaadmId=""
				
				Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID)
				Continue:Data=""
				
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}elseif (aMrNo'=""){
			Set xPaadmId = ""
			For {
				Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexMrNo",aMrNo,xPaadmId))
				Quit:xPaadmId=""
				
				Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aLocationID,aWardID)
				Continue:Data=""
				
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
 	
	Quit $$$OK
}

ClassMethod QryAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildPaadmData(aEpisodeID As %String, aHospIDs As %String = "", aLocationID As %String = "", aWardID As %String = "") As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx=objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") return //预住院P、在院A、出院D、退院C、作废U
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Quit:PatName="测试" return
	Quit:('(PatName[$g(aPatName)))&&($g(aPatName)'="") return
	Quit:($g(aPapmiNo)'="")&&($g(aPapmiNo)'=PapmiNo) return
	Quit:($g(aMrNo)'="")&&($g(aMrNo)'=MrNo) return

	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Nation = objPaadm.PANation
	Set Birthday = objPaadm.PABirthday
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set Age = objPaadm.PAAge
	Set IdentityCode = objPaadm.PAIdentityCode
	Set HomeAddress = objPaadm.PAHomeAddress
	Set Company = objPaadm.PACompany
	Set RelativeName = objPaadm.PARelativeName
	Set RelativeTel = objPaadm.PARelativeTel
	Set IsDeath = objPaadm.PAIsDeath
	Set DeathDate = objPaadm.PADeathDate
	Set:DeathDate'="" DeathDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DeathDate)
	Set DeathTime = objPaadm.PADeathTime
	Set:DeathTime'="" DeathTime=$zt(DeathTime)
	Set AdmType = objPaadm.PAAdmType
	Set AdmDate = objPaadm.PAAdmDate	
	Set AdmTime = objPaadm.PAAdmTime
	//入院日期在结束日期之后排除 
	//Quit:(AdmDate>aDateTo) return
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmTimes = objPaadm.PAAdmTimes
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
		Set HospGroupID=""
		If $isobject(objPaadm.PAAdmLocDr.BTHospDr){
			Set HospID=objPaadm.PAAdmLocDr.BTHospDr.%Id()
			Quit:($g(aHospIDs)'="")&($listfind($g(aHospIDs),HospID)<1) return	//医院过滤
		}
		Quit:($g(aLocationID)'="")&&($g(aLocationID)'=objAdmLoc.%Id()) return  //科室过滤
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set AdmWardID = objAdmWard.%Id()
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Quit:($g(aWardID)'="")&&($g(aWardID)'=AdmWardID) return  //病区过滤
	
	Set AdmRoom = objPaadm.PAAdmRoom
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objPaadm.PAAdmBedDr){
		Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
		Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set AdmDays = objPaadm.PAAdmDays
	if AdmDays=-1{
		//Set AdmDays = (+$h)-objPaadm.PAAdmDate+1	//未出院患者计算入院到当天天数
		Set AdmDays = (+$h)-objPaadm.PAAdmDate //修复bug:557856统一住院天数计算
		if (DischDate) {  //如果已经下出院医嘱，取其中最小的住院时间
			/*if (DischDate["/"){
				Set DischDate=$p(DischDate,"/",3)_"-"_$p(DischDate,"/",2)_"-"_$p(DischDate,"/",1)
			}*/
			if (DischDate["-"){
				Set AdmDays1 = $zdh(DischDate,3) - objPaadm.PAAdmDate
			} elseif(DischDate["/"){
				Set AdmDays1 = $zdh(DischDate,4) - objPaadm.PAAdmDate
			}
			
			
			if (AdmDays1<AdmDays) Set AdmDays=AdmDays1
		}
	}
	Set IsNewBaby = objPaadm.PAIsNewBaby
	Set BirthWeight = objPaadm.PABirthWeight
	Set AdmitWeight = objPaadm.PAAdmitWeight
	// 增加返回诊断信息
	Set (MainDiag,AdmitDiag,OtherDiag,DischDiag)=""		// 主要诊断、入院诊断、其他诊断、出院诊断
	Set xDiagnosID = ""
	For {
		Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xDiagnosID))
		Quit:xDiagnosID=""
		
		Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
		Continue:'$isobject(objDiagnos)
		Set IsActive = objDiagnos.MRIsActive
		Continue:IsActive'=1
		Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
		Set SCode	   = objDiagnos.MRSCode
		Set ICD10  	   = objDiagnos.MRDiagICD10
		Set DiagDesc   = objDiagnos.MRDiagDesc
		Set DiagTpCode = objDiagnos.MRDiagTpCode
		Set DiagTpDesc = objDiagnos.MRDiagTpDesc
		Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
		If DiagTypeMap'="" {
			Set DiagTpCode=$p(DiagTypeMap,"^",2)
			Set DiagTpDesc=$p(DiagTypeMap,"^",3)
		}
		
		If DiagTpDesc="入院诊断"{
			Set AdmitDiag = AdmitDiag_","_DiagDesc
		}elseif DiagTpDesc="主要诊断"{
			Set MainDiag = MainDiag_","_DiagDesc
		}elseif DiagTpDesc="出院诊断"{
			Set DischDiag = DischDiag_","_DiagDesc
		}else {
			Set OtherDiag = OtherDiag_","_DiagDesc
		}
	}
	Set:MainDiag'="" MainDiag = $e(MainDiag,2,$l(MainDiag))
	Set:AdmitDiag'="" AdmitDiag = $e(AdmitDiag,2,$l(AdmitDiag))
	Set:DischDiag'="" DischDiag = $e(DischDiag,2,$l(DischDiag))
	Set:OtherDiag'="" OtherDiag = $e(OtherDiag,2,$l(OtherDiag))
	
    If (OtherDiag="") {
	    Set OtherDiag=DischDiag   //出院诊断显示在其他诊断中
    }Else {
	   Set:DischDiag'="" OtherDiag=DischDiag_","_OtherDiag   //出院诊断显示在其他诊断中
    }
    
	Set return = $lb(aEpisodeID,EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Nation,Birthday,Age,IdentityCode,HomeAddress,Company,RelativeName,RelativeTel,IsDeath,DeathDate,DeathTime,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime,DischLocDesc,DischWardDesc,IsNewBaby,BirthWeight,AdmitWeight,AdmTimes,AdmDays,MainDiag,AdmitDiag,OtherDiag,DischDiag)
	Quit return
}

/// 入参：手术id
/// 出参：opaId_$c(3)_anopStartTime_$c(3)_KSSUseDate_$c(3)_KSSUseTime_$c(3)_endDate_$c(3)_endTime_$c(3)_KSSUseDesc
/// 手术id_$c(3)_手术开始时间_$c(3)_抗生素使用日期_$c(3)_抗生素使用时间_$c(3)_手术结束日期_$c(3)_手术结束时间_$c(3)_使用抗生素事件所属时间节点（术前/术中/术后）
/// w ##class(web.DHCANAdaptor).GetKSSTimeByOpaId("6998")
ClassMethod GetKSSTimeByOpaId(opaId As %String)
{
	s ret=""
	s needEpisodeID=$p(^DHCANOPArrange(opaId),"^",1) 
	s AdmDr=$p(^DHCANOPArrange(opaId),"^",2)
	s chl=$p(AdmDr,"||",2)
	s anopStartTime=$p($g(^OR(needEpisodeID,"ANA",chl)),"^",19)
	s KSSUseTimeDr=$o(^DHCANOrder(0,"CommOrd",175,opaId,""),-1)
	q:KSSUseTimeDr="" "无抗生素使用时间"
	s startTimeDr=$o(^DHCANOrder(0,"CommOrd",17,opaId,""))
	s endTimeDr=$o(^DHCANOrder(0,"CommOrd",18,opaId,""))
	s KSSUseDate=$p(^DHCANOrder(KSSUseTimeDr),"^",5)
	s KSSUseTime=$p(^DHCANOrder(KSSUseTimeDr),"^",6)
	s endDate=$p(^DHCANOrder(endTimeDr),"^",5)
	s endTime=$p(^DHCANOrder(endTimeDr),"^",6)
	
	s startDT=$p(^DHCANOrder(startTimeDr),"^",5)+$p(^DHCANOrder(startTimeDr),"^",6)/100000
	s endDT=endDate+endTime/100000
	s KSSUseDT=KSSUseDate+KSSUseTime/100000
	s KSSUseDesc="术中"
	i KSSUseDT<startDT s KSSUseDesc="术前"
	i KSSUseDT>endDT s KSSUseDesc="术后"
	s ret=opaId_$c(3)_anopStartTime_$c(3)_KSSUseDate_$c(3)_KSSUseTime_$c(3)_endDate_$c(3)_endTime_$c(3)_KSSUseDesc
	
	q ret
}

}
