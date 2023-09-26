Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-12-09
/// Descript: 	病人基础信息后台类
Class web.DHCSTPHCMPatBaseInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: json 病人检验项目指标(不用)
/// D ##Class(web.DHCSTPHCMPatBaseInfo).JSonGetPatLabItem("41")
ClassMethod JSonGetPatLabItem(EpisodeID As %String) As %String
{
	n (EpisodeID)

	Q:EpisodeID="" ""
	
	s pid=..NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    
    //s ^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItem",pid,1) = "1604140018#全血细胞分析(18项以上指标)(血常规)(门/急)#2016-04-14 16:46####全血###" 
    //s ^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItem",pid,2) = "1604190010#全血细胞分析(18项以上指标)(血常规)(门/急)#2016-04-19 13:09##2016-04-19 13:10:52#2016-04-19 13:11:56#全血#2#sdfsf#25" 
    
    /// 准备数据
	D ..GetPatLabItem(pid, EpisodeID)
	
	/// 转换数据为Json格式
	s ListTitle="LabEpisode#arcitmdesc#reqDateTime#specDateTime#recDateTime#authDateTime#specName#tsResultAnomaly#transComm#reportID"
	w "[" //输出json前缀串
	s index="",quitflag=0,count=0
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItem",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItem",pid,index))
	.s count = count+1
	.I count=1 d
	..w ##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"#")
	.e  d
	..w ","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"#")
	w "]" //输出json结尾符
	
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Descript: json 病人检验项目指标
/// D ##Class(web.DHCSTPHCMPatBaseInfo).JsGetLabItemStream("781")
ClassMethod JsGetLabItemStream(EpisodeID As %String) As %GlobalCharacterStream
{
	n (EpisodeID)

	Q:EpisodeID="" ""
	
	s pid=..NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
        
    /// 准备数据
	D ..GetPatLabItem(pid, EpisodeID)
	
	/// 转换数据为Json格式
	s ListTitle="LabEpisode#arcitmdesc#reqDateTime#specDateTime#recDateTime#authDateTime#specName#tsResultAnomaly#transComm#reportID#admDocUser"
	d OutBinStream.Write("[")  //输出json前缀串
	s index="",quitflag=0,count=0
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItem",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItem",pid,index))
	.s count = count+1
	.I count=1 d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"#"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"#"))
	d OutBinStream.Write("]")   //输出json结尾符
	D OutBinStream.OutputToDevice()
	D ..killTmpGlobal(pid) //k掉临时global
	Q OutBinStream
}

/// Descript: 病人检验项目
ClassMethod GetPatLabItem(pid As %String, EpisodeID As %String) As %String
{
	n (pid, EpisodeID)
	Q:EpisodeID="" ""
	
	s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:ord="" ""
	
	s PatLoc="",HospCode=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4)     /// 科室
	i PatLocID'="" D
	.s PatLoc=$p($p(^CTLOC(PatLocID),"^",2),"-",2)
	.s HospID=$p(^CTLOC(PatLocID),"^",22)
	.s HospCode=$p(^CT("HOSP",HospID),"^",1)   /// 医院
	
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)  /// 就诊日期
	s AdmTime=$p(^PAADM(EpisodeID),"^",7)  /// 就诊时间
	i AdmDate'="" s AdmDate=$zd(AdmDate,3)
	i AdmTime'="" s AdmTime=$zt(AdmTime,1)
	
	s AdmType=$p(^PAADM(EpisodeID),"^",2)  /// 就诊类型
	s AdmType=$s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="I":"住院",AdmType="H":"体检",1:"")

	s num=""
	s itm=0
	f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d 
	.s orditm=ord_"||"_itm
	.s admDocUser=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)  //医生
	.s ItemStatDR=$p(^OEORD(ord,"I",itm,1),"^",13) //医嘱状态
	.i ItemStatDR'="" s ItemStatCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.Q:(ItemStatCode'="V")&(ItemStatCode'="E")
	.s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.Q:'##Class(web.DHCLabOrder).isLabTS(arcimid)
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) /// 医嘱项名称
	.s LabEpisode=$p(^OEORD(ord,"I",itm,3),"^",20)     	   /// 检验号
	.s LabTestSetRow=$p(^OEORD(ord,"I",itm,3),"^",35)      /// 报告ID
	.s reqdate=$p(^OEORD(ord,"I",itm,3),"^",7)   /// 申请日期
	.s:reqdate'="" reqdate=$zd(reqdate,3)
	.s reqtime=$p(^OEORD(ord,"I",itm,1),"^",17)  /// 申请时间
	.s:reqtime'="" reqtime=$zt(reqtime,2)
	.s reqDateTime=reqdate_" "_reqtime
	.s WorkGroupMachineDR="NULL"
	.//s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",$c(32)_LabEpisode,""))
	.s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode),""))
	.i $l(LabTestSetRow) s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	.i '$l(WorkGroupMachineDR) s WorkGroupMachineDR="NULL"
	./// 标本类型
	.s specCode="",specName=""
	.s specDr=$o(^OEORD(ord,"I",itm,"SPEC",""),-1)
	.i specDr'="" s specCode=$p(^OEORD(ord,"I",itm,"SPEC",specDr),"^",1)
	.i specCode'="" s specName=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specCode,HospCode),$c(2),2)
	./// 采集日期时间Collection
	.s specDateTime=""
	.s retval=##Class(web.DHCNurSpecerNo).GetspecCollDatetime(orditm)
	.i $l(retval) d
	..s specDate=$p(retval,"^",2)
	..i $l(specDate) s specDate=$zd(specDate,3)
	..s specTime=$p(retval,"^",3)
	..i $l(specTime) s specTime=$zt(specTime)
	..s specDateTime=specDate_" "_specTime
	./// 接收日期
	.s recDateTime="",authDateTime="",tsResultAnomaly="",transComm="",reportID=""
	.i $l(VisitNumberDR) d
	..s recDate=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),66)
	..s recTime=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),67)
	..i $l(recTime) s recTime=$zt(recTime)
	..i $l(recDate) s recDateTime=$e(recDate,1,4)_"-"_$e(recDate,5,6)_"-"_$e(recDate,7,8)_" "_recTime
	../// 审核日期
	..s Order=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""))
	..i $l(Order) d 
	...s reportID=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,Order,""))
	...s authDate=$lg($g(^dbo.RPVisitNumberReportD(reportID)),19)
	...s authTime=$lg($g(^dbo.RPVisitNumberReportD(reportID)),20)
	...i $l(authTime) s authTime=$zt(authTime,2)
	...i $l(authDate) s authDateTime=$e(authDate,1,4)_"-"_$e(authDate,5,6)_"-"_$e(authDate,7,8)_" "_authTime
	.../// 结果异常标志
	...s tsResultAnomaly=##class(DHCLIS.DHCCommon).checkTSResultStatus(reportID)
	.../// 危机值提示
	...s transComm=##Class(DHCLIS.DHCCommon).GetPanicMsg(VisitNumberDR)
	.
	.s num=num+1
	.s ListData=LabEpisode_"#"_arcitmdesc_"#"_reqDateTime_"#"_specDateTime_"#"_recDateTime_"#"_authDateTime_"#"_specName_"#"_tsResultAnomaly_"#"_transComm_"#"_reportID_"#"_admDocUser
	.s ^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItem",pid,num)=ListData

    Q num
}

/// Descript: json 病人检验项目指标(不用)
/// D ##Class(web.DHCSTPHCMPatBaseInfo).JSonGetPatLabItemDetail("25")
ClassMethod JSonGetPatLabItemDetail(EpisodeID As %String, reportID As %String) As %String
{
	n (EpisodeID, reportID)
	Q:EpisodeID="" ""
	
	s pid=..NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    
    /// 准备数据
	D ..GetPatLabItemDetail(pid, EpisodeID, reportID)
	
	/// 转换数据为Json格式
	s ListTitle="TestCodeDR#Synonym#TestCodeName#Units#ResultFormat#ResClass#Result#ExtraRes#AbFlag#RefRanges#ClinicalSignifyS#PreResultList"
	w "[" //输出json前缀串
	s index="",quitflag=0,count=0
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItemDetail",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItemDetail",pid,index))
	.s count = count+1
	.I count=1 d
	..w ##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"#")
	.e  d
	..w ","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"#")
	w "]" //输出json结尾符
	
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Descript: json 病人检验项目指标
/// D ##Class(web.DHCSTPHCMPatBaseInfo).JsGetLabItemDetStream("781","2970")
ClassMethod JsGetLabItemDetStream(EpisodeID As %String, reportID As %String) As %GlobalCharacterStream
{
	n (EpisodeID, reportID)
	Q:EpisodeID="" ""
	s pid=..NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
    
    /// 准备数据
	D ..GetPatLabItemDetail(pid, EpisodeID, reportID)
	
	/// 转换数据为Json格式
	s ListTitle="TestCodeDR@Synonym@TestCodeName@Units@ResultFormat@ResClass@Result@ExtraRes@AbFlag@RefRanges@ClinicalSignifyS@PreResultList"
	d OutBinStream.Write("[")  //输出json前缀串
	s index="",quitflag=0,count=0
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItemDetail",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItemDetail",pid,index))
	.s count = count+1
	.I count=1 d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"@"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"@"))
	d OutBinStream.Write("]")   //输出json结尾符
	D OutBinStream.OutputToDevice()
	D ..killTmpGlobal(pid) //k掉临时global
	Q OutBinStream
}

/// Descript: 病人检验项目指标
ClassMethod GetPatLabItemDetail(pid As %String, EpisodeID As %String, reportID As %String) As %String
{
	n (pid, EpisodeID, reportID)
	Q:EpisodeID="" ""
	Q:reportID="" ""
	
	s PatientID=$p(^PAADM(EpisodeID),"^",1)      /// 病人ID
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 病人登记号
	
	Q:'$d(^dbo.RPVisitNumberReportD(reportID)) ""
	s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(reportID)),19)
	s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(reportID)),20)
	s ReAuthDate=$lg($g(^dbo.RPVisitNumberReportD(reportID)),23)
	s ReAuthTime=$lg($g(^dbo.RPVisitNumberReportD(reportID)),24)
	//如果有重审时间，审核时间为重审时间，用于前次结果查询
	i $l($g(ReAuthDate)) s AuthDate = ReAuthDate
	i $l($g(ReAuthTime)) s AuthTime = ReAuthTime
	
	s TestCodeDRs = ##Class(web.DHCSTPHCMPatBaseInfo).GetTestCodeDRsByReportDR(reportID)
	Q:TestCodeDRs="" ""
	s num=0
	s TLength = $l(TestCodeDRs,",")
	for i=1:1:TLength {
		s TestCodeDR = $p(TestCodeDRs,",",i)
		s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
		s TestCodeName = $lg(TestCodeData,3)
		s Synonym = $lg(TestCodeData,7) /// 缩写
		s Units = $lg(TestCodeData,8)   /// 单位
		s $LIST(TestCodeData,1)=TestCodeDR
		s ResultFormat=$LIST(TestCodeData,9) /// 结果格式(N数字,X文本,S列表,A血型ABO,R血型RH,M微生物)
		s ReportResult=##Class(web.DHCSTPHCMPatBaseInfo).GetReportResult(reportID,TestCodeDR)
		s ResClass =  $lg(ReportResult,10)   /// 结果类别(0普通,1危急)
		s Result = $lg(ReportResult,5)
		s ExtraRes = $lg(ReportResult,6)
		//结果描述，细菌名称
        //i ResultFormat="M",$l(Result) d  s Result=$lg(^dbo.BTOrganismD(Result),3)

		s AbFlag = $lg(ReportResult,9) //异常提示
		s RefRanges = $lg(ReportResult,12) //参考范围
		s ClinicalSignifyS = $lg(TestCodeData,20) //临床意义
		s (ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh)=""
	
		//获取前一次结果
		s PreResultList=##Class(web.DHCSTPHCMPatBaseInfo).GetPreResult(PatNo,TestCodeDR,AuthDate,AuthTime)
		s PreResult=$p(PreResultList,"^",1),PreAbFlag=$p(PreResultList,"^",2),PreResultDR=$p(PreResultList,"^",3)
		s PreResultList=$lb(PreResult,PreAbFlag,PreResultDR)
		
		s num=num+1
		s ListData=TestCodeDR_"@"_Synonym_"@"_TestCodeName_"@"_Units_"@"_ResultFormat_"@"_ResClass_"@"_Result_"@"_ExtraRes_"@"_AbFlag_"@"_RefRanges_"@"_ClinicalSignifyS_"@"_PreResultList
		s ^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItemDetail",pid,num)=ListData
	}
    Q num
}

/// Descript: 根据报告id取项目的id串
ClassMethod GetTestCodeDRsByReportDR(ReportDR As %String) As %String
{
	n (ReportDR)
	s TestCodeDRs=""
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
	s WorkGroupMachineDR = $lg($g(^dbo.RPVisitNumberReportD(ReportDR)),4)
	s WorkGroupDR = $lg(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR),4)
	i '$l(WorkGroupDR) Q ""
	s TestSetDR="" 
	f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.s VisNumTSDR = $o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
	.s tWorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisNumTSDR)),5)
	.i tWorkGroupMachineDR'=WorkGroupMachineDR q
	.s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR,WorkGroupDR,TestCodeDR)) q:TestCodeDR=""  d
	..i $l($g(TestCodeDRs)) d
	...s TestCodeDRs = TestCodeDRs_","_TestCodeDR
	..else  d
	...s TestCodeDRs = TestCodeDR
	Q TestCodeDRs
}

/// Descript: 获取报告结果
ClassMethod GetReportResult(ReportDR As %String, TestCodeDR As %String) As %String
{
	n (ReportDR, TestCodeDR)
	s ReportDR=$g(ReportDR),TestCodeDR=$g(TestCodeDR)
	s RetVal=$lb("","","","","","","","","","","","","","","","","","","","","","","","","","")
	i '$l(ReportDR) q RetVal
	i '$l(TestCodeDR) q RetVal
	s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR, TestCodeDR,""))
	i '$l(ReportResultDR) q RetVal
	s ReportResultData=$li($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),1,26)
	s $li(ReportResultData,1)=ReportResultDR
	Q ReportResultData
}

/// Descript: 获取最近一次结果"201501041","260",20150814,69214
ClassMethod GetPreResult(RegNo, TestCodeDR, AuthDate, AuthTime, WorkGroupMachineDR) As %String
{
	n (RegNo, TestCodeDR, AuthDate, AuthTime, WorkGroupMachineDR)
	s RegNo=$g(RegNo),TestCodeDR=$g(TestCodeDR),AuthDate=$g(AuthDate),AuthTime=$g(AuthTime),WorkGroupMachineDR=$g(WorkGroupMachineDR)
	s RetVal="",ReportResultDR=""
	i '$l(RegNo) q RetVal
	i '$l(TestCodeDR) q RetVal
	i '$l(AuthDate) d
	.s AuthDate=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,""),-1)
	.i '$l(AuthDate) q
	.s AuthTime=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,""),-1)
	.i '$l(AuthTime) q
	.s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime,""))
	e  d
	.i $l($o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime),-1)) d
	..s AuthTime = $o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime),-1)
	..s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime,""))
	.e  d
	..s AuthDate = $o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate),-1)
	..i AuthDate="" q
	..s AuthTime = $o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,""),-1)
	..s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime,""))
	///获取结果
	i '$l(ReportResultDR) q RetVal
	s ReportResultData=$g(^dbo.RPVisitNumberReportResultD(ReportResultDR))
	s VisitNumberReportDR=$lg(ReportResultData,2)
	s TextRes=$lg(ReportResultData,5)
	s AbFlag=$lg(ReportResultData,9)
	s RetVal=TextRes_"^"_AbFlag_"^"_ReportResultDR
	Q RetVal
}

/// Descript:	电子病历图片接口
/// D ##Class(web.DHCSTPHCMPatBaseInfo).GetPatEmrImageDetial("21")
ClassMethod GetPatEmrImageDetial(EpisodeID As %String) As %GlobalCharacterStream
{
	n (EpisodeID)

	//s EpisodeID="807"
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s del=""""
	d OutBinStream.Write("[")
	s TempID = ""
	s rs = ##class(%ResultSet).%New("EMRservice.BL.ImageMedicalRecords:GetImageMedicalRecords")
	s sc = rs.Execute(EpisodeID)
 	while (rs.Next()) {
 		s id = rs.GetDataByName("cateCharpterId")
 		s desc = rs.GetDataByName("cateCharpterName")
 		s fullFile = rs.GetDataByName("fileLocation")
 		s filePath=$p(fullFile,"/",1,$L(fullFile,"/")-1)_"/"
 		s fileName=$p(fullFile,"/",$L(fullFile,"/"))
 		continue:(id = "") //必要数据
 		s ListTile="fileIndex^filePath^fileName"
 		i TempID'="" D
	    .d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTile,id_"^"_filePath_"^"_fileName))
 		E  D
 		.d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTile,id_"^"_filePath_"^"_fileName))
		s TempID = id
#; 		if (TempID '= id){
#;	 		i TempID'="" d OutBinStream.Write("]}")
#;	 		d OutBinStream.Write("{"_del_"Id"_del_":"_del_id_del_","_del_"Desc"_del_":"_del_desc_del)
#;	 		d OutBinStream.Write(",""PathList"":[")
#;	 		d OutBinStream.Write("{"_del_"Path"_del_":"_del_fullFile_del_"}")
#;	 		s TempID = id
#; 		}
#; 		else
#; 		{
#;	 		d OutBinStream.Write(",{"_del_"Path"_del_":"_del_fullFile_del_"}")
#;	 	}
	 	
 	}
 	i TempID'="" d OutBinStream.Write("]}")
 	d OutBinStream.Write("]")

	Q OutBinStream
}

/// Creator: 	QuNianpeng
/// CreateDate: 2017-05-24
/// Descript: 	病人检查信息
/// Input: 		就诊id
/// Return：	病人检查信息
/// w ##Class(web.DHCSTPHCMPatBaseInfo).GetLisItemStream(143)
ClassMethod GetLisItemStream(episodeID)
{
	n (episodeID)
	Q:episodeID="" ""
	
	s pid=..NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    s outBinStream=##Class(%GlobalCharacterStream).%New()
    /// 准备数据
	D ..GetPatLisItemData(pid, episodeID)	
	
	/// 转换数据为Json格式
	s listTitle="regNo^studyNo^strOrderName^strDate^itemStatus^oeordItemDr^isIll^locName^repLocDr^ishasImg^mediumName^image^report^memo^grade^isModify^isReaded^oeordItem"
	d outBinStream.Write("[")   //输出json结尾符
	s index="",quitflag=0,count=0
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLisItemData",pid,index)) Q:index=""  D
	.s listData=$g(^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLisItemData",pid,index))
	.s count = count+1
	.I count=1 d
	..d outBinStream.Write(##class(web.DHCSTPHCMJsonCommon).getJsonData(listTitle,listData))
	.e  d
	..d outBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(listTitle,listData))
	d outBinStream.Write("]")   //输出json结尾符
	;D outBinStream.OutputToDevice()
	D ..killTmpGlobal(pid) //k掉临时global
	Q outBinStream
}

/// Creator: 	QuNianpeng
/// CreateDate: 2017-05-24
/// Descript: 	病人检查信息数据准备
/// Input:		进程号，就诊id
/// w ##Class(web.DHCSTPHCMPatBaseInfo).GetPatLisItemData(18,41)
ClassMethod GetPatLisItemData(pid, episodeID)
{
	n (pid,episodeID)	
	s result = ##Class(%ResultSet).%New("web.DHCSTPHCMPatBaseInfo:QueryALLStudyByPaadmDR")
	s sc = result.Execute(episodeID,"","","","")	
	s num=0
	s regNo="" 			 //登记号
	s studyNo=""  		 //检查号
	s strOrderName="" 	 //医嘱名称
	s strDate=""		 //医嘱日期	
	s itemStatus="" 	 //医嘱状态
	s oeordItemDr=""     //医嘱明细id
	s isIll=""			 //是否阳性
	s locName=""		 //科室名称
	s repLocDr=""		 //科室
	s ishasImg=""		 //是否有图像
	s mediumName=""		 //介质
	s image=""			 //图像
	s report=""			 //报告
	s memo=""			 //备注
	s grade=""			 //评级
	s isModify=""		 //是否修改
	s isReaded="" 		 //是否阅读
	s oeordItem=""   	 //医嘱id
	While (result.Next())
	{	//TRegNo:TStudyNo:TItemName:TItemDate:TItemStatus:TOEOrderDr:TIsIll:TLocName:TreplocDr:TIshasImg:TMediumName:TImgBrowse:TImgShut:TOpenRpt:Memo:ImageUrl:Grade:TIsModify:TIsReaded:
		s regNo=$g(result.Data("TRegNo")) 			//登记号
		s studyNo=$g(result.Data("TStudyNo"))   	//检查号
		s strOrderName=$g(result.Data("TItemName")) //医嘱名称
		s strDate=$g(result.Data("TItemDate")) 		//医嘱日期	
		s itemStatus=$g(result.Data("TItemStatus")) //医嘱状态
		s oeordItemDr=$g(result.Data("TOEOrderDr")) //医嘱明细id
		s isIll=$g(result.Data("TIsIll")) 			//是否阳性
		s locName=$g(result.Data("TLocName")) 		//科室名称
		i locName["-" d
		.s locName=$p(locName,"-",2)
		s repLocDr=$g(result.Data("TreplocDr")) 	//科室
		s ishasImg=$g(result.Data("TIshasImg")) 	//是否有图像
		s mediumName=$g(result.Data("TMediumName")) //介质
		s image=$g(result.Data("TImgBrowse")) 		//图像
		s report=$g(result.Data("TOpenRpt"))		//报告
		s memo=$g(result.Data("Memo")) 				//备注
		s grade=$g(result.Data("Grade")) 			//评级
		s isModify=$g(result.Data("TIsModify")) 	//是否修改
		s isReaded=$g(result.Data("TIsReaded"))  	//是否阅读
		s oeordItem=$g(result.Data("OeordItemDr")) 	//医嘱id
		
		s num=num+1
		s ListData=regNo_"^"_studyNo_"^"_strOrderName_"^"_strDate_"^"_itemStatus_"^"_oeordItemDr_"^"_isIll_"^"_locName_"^"_repLocDr_"^"_ishasImg_"^"_mediumName_"^"_image_"^"_report_"^"_memo_"^"_grade_"^"_isModify_"^"_isReaded_"^"_oeordItem
		;w ListData,!
		s ^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLisItemData",pid,num)=ListData
	}
	q num
}

/// Creator: 	QuNianpeng
/// CreateDate: 2017-05-24
/// Descript: 	病人检查结果
/// Input: 		就诊id
/// Return：	病人检查信息
/// w ##Class(web.DHCSTPHCMPatBaseInfo)GetLisItemDetStream(41)
ClassMethod GetLisItemDetStream(ordItem)
{
	n (ordItem)
	Q:ordItem="" ""
	s outBinStream=##Class(%GlobalCharacterStream).%New()
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","SelectReportByOeordID","147||66")
	s result = ##Class(%ResultSet).%New("web.DHCRisclinicQueryOEItemDo:SelectReportByOeordID")	
	s sc = result.Execute(ordItem)	
	s num=0,listData=""
	While(result.Next())
	{
		s examDesc=$g(result.Data("ExamDesc"))			//检查所见
		s strResult=$g(result.Data("strResult")) 		//诊断意见
		s strOrderName=$g(result.Data("strOrderName")) 	//检查方法
		s listData=examDesc_"^"_strResult_"^"_strOrderName
	}	
	// 转换数据为Json格式
	s listTitle="examDesc^strResult^strOrderName"
	d outBinStream.Write("[")   //输出json结尾符
	d outBinStream.Write(##class(web.DHCSTPHCMJsonCommon).getJsonData(listTitle,listData))
	d outBinStream.Write("]")   //输出json结尾符
	D outBinStream.OutputToDevice()
	Q outBinStream
}

/// Descript: 获取系统FTP地址
/// w ##Class(web.DHCSTPHCMPatBaseInfo).GetSysConFTP("Code")
ClassMethod GetSysConFTP(bsCode As %String) As %String
{
	n (bsCode)
	Q:bsCode="" ""
	s id=$o(^DHCPHFTPC(0,"Code",bsCode,""))
	Q:id="" "^^^"
	s AddresIP=$p(^DHCPHFTPC(id),"^",3)  /// IP地址
	s UserName=$p(^DHCPHFTPC(id),"^",4)  /// 账号
	s PassWord=$p(^DHCPHFTPC(id),"^",5)  /// 密码
	s Port=$p(^DHCPHFTPC(id),"^",6)      /// 端口
	s ListData=AddresIP_"^"_Port_"^"_UserName_"^"_PassWord
	Q ListData
}

/// Descript: 获取系统FTP地址
/// w ##Class(web.DHCSTPHCMPatBaseInfo).jsonGetSysConFTP()
ClassMethod jsonGetSysConFTP() As %String
{
	s ListData=##Class(web.DHCSTPHCMPatBaseInfo).GetSysConFTP("EMR")
	s ListData=ListData_"^"_##Class(web.DHCSTPHCMPatBaseInfo).GetSysConFTP("SIN")
	s ListTitle="EHostName^EServerPort^EUserName^EPassWord^SHostName^SServerPort^SUserName^SPassWord"
	Q ##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData)
}

/// Descript: 获取检查结果
/// Creator: 	QuNianpeng
/// CreateDate: 2017-09-15
/// Input: 		就诊id
/// Return：	病人检查信息
/// Other:		调用pac组query,session报错(移动端没有session)，复制query修改
/// d ##Class(%ResultSet).RunQuery("web.DHCSTPHCMPatBaseInfo","QueryALLStudyByPaadmDR",614)
Query QueryALLStudyByPaadmDR(paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String, ALLFlag As %String = "N") As %Query(ROWSPEC = "TRegNo:%String,TStudyNo:%String,TItemName:%String,TItemDate:%String,TItemStatus:%String,TOEOrderDr:%String,TIsIll:%String,TLocName:%String,TreplocDr:%String,TIshasImg:%String,TMediumName:%String,TImgBrowse:%String,TImgShut:%String,TOpenRpt:%String,Memo:%String,ImageUrl:%String,Grade:%String,TIsModify:%String,TIsReaded:%String,OeordItemDr:%String")
{
}

ClassMethod QueryALLStudyByPaadmDRExecute(ByRef qHandle As %Binary, paadmdr As %String, LocDr As %String, StdDate As %String, enddate As %String, ALLFlag As %String = "N") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryALLStudyByPaadmDR","61527","","","")
  	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s LocDr=$p(LocDr,$c(0))
	s StDate=$p(StdDate,$c(0))
	s EndDate=$p(enddate,$c(0))
	s Memo="",ItemStatus="",StatusCode=""
	s RegNo="",StudyNo="",strOrderName="",strDate="",ItemStatus="",IsIll="",LocName="",IshasImg="N",MediumDR=""
    s ^tmp("2015092801")=paadmdr_"^"_LocDr_"^"_StdDate_"^"_enddate
	s PAPMIDR = $p(^PAADM(paadmdr),"^",1)
	s PAType="" f  s PAType=$o(^PAPERdr(PAPMIDR,"ADM",PAType)) q:PAType=""  d
	.s PaadmdrOne=0 f  s PaadmdrOne=$o(^PAPERdr(PAPMIDR,"ADM",PAType,PaadmdrOne)) q:(PaadmdrOne="")  d
	..q:(ALLFlag'="Y")&(paadmdr'=PaadmdrOne)
	..;w !,"PaadmdrOne="_PaadmdrOne
	..s RegNo="",StudyNo="",strOrderName="",ItemStatus="",IsIll="",ItemStatusCode=""
	..s RptNum = 0
	..s OrderRowid=""
 	..s OrderRowid=$o(^OEORD(0,"Adm",PaadmdrOne,OrderRowid)) 
 	..q:OrderRowid=""
 	..s papatmasmdr=$p(^PAADM(PaadmdrOne),"^",1)
	..s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)
	..s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	...;不是检查项目的则退出  
	...s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2) 
	...q:(arcimid="")
	...s OeordItemDr=OrderRowid_"||"_itemsub
	...s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	...q:(ServerMaterial'="S") 
	...s replocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	...q:(replocdr="")
	...q:(LocDr'="")&(replocdr'=LocDr)
	...;没有配置临床查看报告路径退出
	...s ClinicRowid=0
	...s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	...q:(ClinicRowid="")
	...i replocdr'="" s LocName=$p(^CTLOC(replocdr),"^",2)
	...;医嘱状态
	...s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	...i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	...;医嘱日期和时间
	...s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	...s strDate=##class(websys.Conversions).DateLogicalToHtml(Date1) ;$zd(Date1,3)
	...s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	...s strTime=$zt(Time1)
	...s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(OrderRowid_"||"_itemsub)
	...s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(OrderRowid_"||"_itemsub)    //申请单号
	...;这里取个巧 : 不管带不带部位,都可以走循环(无部位也走一次循环，就是部位为空)
	...f iBody=1:1:$L(bodydrList,"^")  d  
	....s bodypart=$p($g(bodydrList),"^",iBody)
	....s bodypartRowid=$p($g(bodypart),":",1) 
	....s bodypartDesc=$p($g(bodypart),":",2)
	....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	....if bodypartDesc'="" d
	.....s strOrderName=strOrderName_" ("_bodypartDesc_")"
	....s Memo=""
	....s StudyNo="",ItemStatus="N",IsIll="N"
	....s Image="",Shut="",Report="",ImageUrl="",Grade=""
	....s orderStatusInfo=##class(web.DHCRisWorkBenchDoEx).getOrderBodyStatus(OrderRowid_"||"_itemsub,bodypartRowid)
	....s ItemStatusCode=$p($g(orderStatusInfo),"^",1)
	....q:(ItemStatusCode'="V")&(ItemStatusCode'="E")	
	....s IsVerify="N"  ;没有审核
	....;s resrowid=""  
	....s oeorditemdr=OrderRowid_"||"_itemsub
	....s RegDR=##class(web.DHCRisResApptSchudleSystem).getRegRowid(oeorditemdr_"^"_bodypartRowid ) ;$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	....i $g(RegDR)'="" d
	.....s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.....s ImageUrl=$p(^DHCPACRegInfo(RegDR),"^",22)      ;存放外部传输过来的URL
	....s StatusCode=""
	....i StudyNo'="" d
	.....s Imgrowid=0
	.....s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imgrowid))
	.....i Imgrowid'="" s IshasImg="Y"
	.....s IshasImg=##class(web.DHCRisclinicQueryOEItemDo).GetImageStatus(StudyNo)
	.....s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	......s ReportID=$p(^DHCRBStudy("Report",RptRowId),"^",2)
	......s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	......q:(StatusDR="")
	......s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	......s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	......s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	......i StatusCode="S" d
	.......s ItemStatus="Y"
	.......s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	........s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	........i FullFileName'="" s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	.....;医嘱结果状态（暂时无法考虑分部位的医嘱）
	.....s tmpItemStatus=##CLASS(web.DHCRisclinicQueryOEItemDo).GetOEOrdStatus(OrderRowid,itemsub)
	.....if StudyNo'="" d
	......s ItemStatus=$p(tmpItemStatus,"^",1)
	......s ItemCode=$p(tmpItemStatus,"^",2)
	....i StatusCode="S" d
	.....s Image="图像"
	.....;s Shut="关闭"
	.....s Report="报告"
	.....s Grade="评级"
	....s isModify=""
	....s isReaded=""
	....s IsModify=""
	....s IsReaded=""
	....i StudyNo'="" d
	.....s PortalRowId=0
	.....s PortalRowId=$o(^DHCRBCLINICCHECKRPTINFOi(oeorditemdr,StudyNo,PortalRowId))
	.....i PortalRowId'="" d
	......s myDocCode="" //%session.Get("LOGON.USERCODE")
	......s CMStatus=##class(RISService.TrakRISService).GetRPTCMStatus(oeorditemdr,StudyNo,myDocCode)
	......s isReaded=$p(CMStatus,"^",1)
	......s isModify=$p(CMStatus,"^",2)
	......i isModify="Y" d
	.......s IsModify="已修改"
	......e  d
	.......s IsModify=""
	......i isReaded="Y" d
	.......s IsReaded="已阅读"
	......e  d
	.......i Report="报告" d
	........s IsReaded="未阅读"
	.......e  d
	........s IsReaded=""
	....Do OutALLStudy
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutALLStudy
	//set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumDR,Memo)
	//set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumName,"Image","Shut","Report",Memo)
	set Data=$lb(RegNo,StudyNo,strOrderName,strDate,ItemStatus,oeorditemdr,IsIll,LocName,replocdr,IshasImg,MediumName,Image,Shut,Report,Memo,ImageUrl,Grade,IsModify,IsReaded,OeordItemDr)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryALLStudyByPaadmDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryALLStudyByPaadmDRExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryALLStudyByPaadmDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryALLStudyByPaadmDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PatBaseInfo"))
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItem",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLabItemDetail",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPatBaseInfo","GetPatLisItemData",pid)
	Q ""
}

}
