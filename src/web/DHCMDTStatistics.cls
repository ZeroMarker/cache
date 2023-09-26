Import sqluser

/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-06
/// Descript: 	  mdt会诊统计类
Class web.DHCMDTStatistics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: MDT会诊数据统计
/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-06
/// w ##Class(web.DHCMDTStatistics).JsGetMdtData("30","1","2020-01-01^2020-08-06")
ClassMethod JsGetMdtData(rows As %String, page As %String, Params As %String, LgParam = "") As %String
{
	n (rows,page,Params,LgParam,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-30
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s LgUserID=$p(LgParam,"^",4)
	k ^TMP("DHCMDT","web.DHCMDTStatistics","JsGetMdtData",LgUserID)
	
	
    s pid=..NewPid()
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)  /// 多语言支持
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) /// 年龄
	..S AdmDoctor=""
	..S AdmDocCodeDR=$p(^PAADM(EpisodeID),"^",9) //医生
	..S:AdmDocCodeDR'="" AdmDoctor=$p($g(^CTPCP(+AdmDocCodeDR,1)),"^",2)
	..s AdmDoctor=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",AdmDoctor)
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s:PatLoc["-" PatLoc=$p(PatLoc,"-",2)
	..s PatLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",PatLoc)  /// 多语言支持
	..s MedicalNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)       /// 病案号
	..s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	..s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)  /// 多语言支持
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstRUserID=$p(^DHCMDTCON(ID),"^",5)  /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  /// 多语言支持
	..s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)
	..s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,2)
	..s CstNTime=CstNDate_" "_CstNTime
	..s CstStatusID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..Q:CstStatusID=""
	..s CstStatusDesc=$p($g(^DHCMDTS(CstStatusID)),"^",2)
    ..s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..s DisGroup=""
	..s:$d(^DHCMDTG(DisGrpID)) DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s AppAdmID = $p(^DHCMDTCON(ID),"^",20) 
	..s AdmType=""
	..I AppAdmID="" S AppAdmID=EpisodeID
	..s:AppAdmID'="" AdmType=$p(^PAADM(AppAdmID),"^",2)
	..S AdmType=$S(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",1:"")
	..;s AdmType=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.OTHER","OTHER","",AdmType)
	..s AdmType = ##class(websys.Translation).Get("dhcmdt.consrequery.csp",AdmType)
	..s PayMony =##Class(web.DHCMDTCom).GetConsIsPayMoney(ID)
	..s CstCTime=##Class(web.DHCMDTStatistics).JsonGetMDtLog(ID)   //会诊完成时间
	..s BillId=$o(^DHCMDTORD(0,"IndexCst",ID,""))
	..s Oeori="",itmCost="",arcimid=""
	..s:BillId'="" Oeori=$p(^DHCMDTORD(BillId),"^",2)  /// 医嘱ID
	..s:Oeori'="" arcimid=$p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1)),"^",2) ///医嘱项目ID
	..;s:arcimid'="" itmCost=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcimid,+$h,"","","","")  //会诊诊金
	..s itmCost=##class(web.DHCMDTCom).GetCstBillFee(ID)
	..s Num=Num+1
	..s ListData=pid_"^"_ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_AdmType_"^"_AdmDoctor_"^"_CstRLoc_"^"_MedicalNo
	..s ListData=ListData_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser_"^"_CstNDate_"^"_CstNTime_"^"_CstUser
	..s ListData=ListData_"^"_DisGrpID_"^"_DisGroup_"^"_CstStatusDesc_"^"_PayMony_"^"_PatientID_"^"_AppAdmID_"^"_CstCTime_"^"_itmCost
	..s TMPListData(Num)=ListData
	..;s ^TMP("DHCMDT","web.DHCMDTStatistics","JsGetMdtData",,Num)=ListData
	..s ^TMP("DHCMDT","web.DHCMDTStatistics","JsGetMdtData",LgUserID,Num)=ListData
	///转换数据为Json格式
	s ListTitle="pid^ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^AdmType^AdmDoctor^CstRLoc^MedicalNo"
	s ListTitle=ListTitle_"^CstRDate^CstRTime^CstRUserID^CstRUser^CstNDate^CstNTime^CstUser"
	s ListTitle=ListTitle_"^DisGrpID^DisGroup^CstStatusDesc^PayMony^PatientID^AppAdmID^CstCTime^itmCost"
	W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index)) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// Descript:     MDT会诊数据统计导出
/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-06
/// w ##Class(web.DHCMDTStatistics).JsGetMdtDataExport("199591")
ClassMethod JsonExportData(LgUserID)
{
	n (LgUserID)
	
	///转换数据为Json格式
	s ListTitle="pid^ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^AdmType^AdmDoctor^CstRLoc^MedicalNo"
	s ListTitle=ListTitle_"^CstRDate^CstRTime^CstRUserID^CstRUser^CstNDate^CstNTime^CstUser"
	s ListTitle=ListTitle_"^DisGrpID^DisGroup^CstStatusDesc^PayMony^PatientID^AppAdmID^CstCTime^itmCost"
	
	w "["
	s Index="",Count=0
	f  s Index=$o(^TMP("DHCMDT","web.DHCMDTStatistics","JsGetMdtData",LgUserID,Index)) Q:Index=""  D
	.s ListData=$g(^TMP("DHCMDT","web.DHCMDTStatistics","JsGetMdtData",LgUserID,Index))
	.q:ListData=""
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript:     MDT会诊数据统计导出
/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-06
/// w ##Class(web.DHCMDTStatistics).JsGetMdtDataExport("199591")
ClassMethod JsGetMdtDataExport(pid As %String)
{

	///转换数据为Json格式
	s ListTitle="pid^ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^AdmType^AdmDoctor^CstRLoc^MedicalNo"
	s ListTitle=ListTitle_"^CstRDate^CstRTime^CstRUserID^CstRUser^CstNDate^CstNTime^CstUser"
	s ListTitle=ListTitle_"^DisGrpID^DisGroup^CstStatusDesc^PayMony^PatientID^AppAdmID^CstCTime^itmCost"
	s count=0,Start=1
	///转换数据为Json格式
	W "[" //输出json前缀串
	s index=""
	F  s index=$o(^TMP("DHCMDT","web.DHCMDTStatistics","JsGetMdtData",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCMDT","web.DHCMDTStatistics","JsGetMdtData",pid,index))
	.Q:ListData=""
	.S count=count+1
    .W $case(count,Start:"",:",") 
	.W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData) 
	W "]" //输出json结尾符
	K ^TMP("DHCMDT","web.DHCMDTStatistics","JsGetMdtData",pid)
	Q ""
}

/// Descript:    各组会诊总量统计
/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-06
/// w ##Class(web.DHCMDTStatistics).JsGetGrpStat("2020")
ClassMethod JsGetGrpStat(Params As %String) As %String
{
	n (Params)
    k ^TMP("web.DHCMDTStatistics","JsGetGrpStat")
    s year=$p(Params,"^",1)    /// 年
    s ArgDisGrp=$p(Params,"^",2)   /// 疑难病种
   	s StartDate=$zdh(year_"-01-01",3)
	s EndDate=$zdh(year_"-12-31",3)
	F dd=StartDate:1:EndDate D
	.s ID=""
	.f  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s CstStatusID=$p(^DHCMDTCON(ID),"^",12)     /// 状态ID
	..s CstStatusCode = $p($g(^DHCMDTS(+CstStatusID)),"^",2)
	..q:CstStatusCode=10 ;撤销的不显示
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)        /// 疑难病种
	..Q:(ArgDisGrp'="")&(ArgDisGrp'=DisGrpID)
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
    ..s month=$SYSTEM.SQL.MONTH(dd)
  	..s ^TMP("web.DHCMDTStatistics","JsGetGrpStat","GROUP",DisGrpID)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","GROUP",DisGrpID))+1
  	..s ^TMP("web.DHCMDTStatistics","JsGetGrpStat","COUNT",DisGrpID,year)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","COUNT",DisGrpID,year))+1
	..s ^TMP("web.DHCMDTStatistics","JsGetGrpStat","MONTH",DisGrpID,year,month)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","MONTH",DisGrpID,year,month))+1
    ..s ^TMP("web.DHCMDTStatistics","JsGetGrpStat","AllCOUNT",year,month)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","AllCOUNT",year,month))+1
        
    s Num=0
    s DisGrpID=""
	f  s DisGrpID=$o(^TMP("web.DHCMDTStatistics","JsGetGrpStat","GROUP",DisGrpID)) q:DisGrpID=""  d
	.s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
    .s grpdata="",DataStr=""
	.f month=1:1:12 d
	..s monthdata=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","MONTH",DisGrpID,year,month))
	..s:monthdata="" monthdata="0"
	..s grpdata=$s(grpdata="":monthdata,1:grpdata_"^"_monthdata)
	.s count=$g( ^TMP("web.DHCMDTStatistics","JsGetGrpStat","COUNT",DisGrpID,year))
	.s:count="" count="0"
	.s grpdata=grpdata_"^"_count
	.s DataStr=$s(DataStr="":grpdata,1:DataStr_"^"_grpdata)
	.s Num=Num+1
	.s ListData=DisGroup_"^"_DataStr
	.s TMPListData(Num)=ListData

	S EMonStr="",AllTotle=0
	f month=1:1:12 d     //获取总合计
	.s EMonData=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","AllCOUNT",year,month))
	.s:EMonData="" EMonData="0"
	.s AllTotle=AllTotle+EMonData
	.s EMonStr=$s(EMonStr="":EMonData,1:EMonStr_"^"_EMonData)
	s TMPListData(Num+1)="合计"_"^"_EMonStr_"^"_AllTotle
	///转换数据为Json格式
	s ListTitle="DisGroup^OneMonNum^TwoMonNum^ThreeMonNum^FourMonNum^FiveMonNum^SixMonNum^SevenMonNum"
	s ListTitle=ListTitle_"^EightMonNum^NineMonNum^TenMonNum^ElevenMonNum^TwelveMonNum^TotleNum"
    
    W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num+1) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index)) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// Descript:    各组会诊费用统计
/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-07
/// w ##Class(web.DHCMDTStatistics).JsGetGrpFeeStat("2020")
ClassMethod JsGetGrpFeeStat(Params As %String) As %String
{
	n (Params)
    k ^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat")
    s year=$p(Params,"^",1)    /// 年
    s ArgDisGrp=$p(Params,"^",2)   /// 疑难病种
   	s StartDate=$zdh(year_"-01-01",3)
	s EndDate=$zdh(year_"-12-31",3)
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)        /// 疑难病种
	..Q:(ArgDisGrp'="")&(ArgDisGrp'=DisGrpID)
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
    ..s month=$SYSTEM.SQL.MONTH(dd)
    ..s BillId=$o(^DHCMDTORD(0,"IndexCst",ID,""))
	..s Oeori="",CostStr="",itmCost="",arcimid=""
	..s:BillId'="" Oeori=$p(^DHCMDTORD(BillId),"^",2)  /// 医嘱ID
	..s:Oeori'="" arcimid=$p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1)),"^",2) ///医嘱项目ID
	..s:arcimid'="" CostStr=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcimid,+$h,"","","","") 
	..;s:CostStr'="" itmCost=$p(CostStr,"^",1)  //会诊诊金
    ..s itmCost=##class(web.DHCMDTCom).GetCstBillFee(ID)
  	..s ^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","GROUP",DisGrpID)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","GROUP",DisGrpID))+itmCost
  	..s ^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","COUNT",DisGrpID,year)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","COUNT",DisGrpID,year))+itmCost
	..s ^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","MONTH",DisGrpID,year,month)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","MONTH",DisGrpID,year,month))+itmCost
    ..s ^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","AllCOUNT",year,month)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","AllCOUNT",year,month))+itmCost

    s Num=0
    s DisGrpID=""
	f  s DisGrpID=$o(^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","GROUP",DisGrpID)) q:DisGrpID=""  d
	.s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
    .s grpdata="",DataStr=""
	.f month=1:1:12 d
	..s monthdata=$g(^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","MONTH",DisGrpID,year,month))
	..s:monthdata="" monthdata="0"
	..s grpdata=$s(grpdata="":monthdata,1:grpdata_"^"_monthdata)
	.s count=$g( ^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","COUNT",DisGrpID,year))
	.s:count="" count="0"
	.s grpdata=grpdata_"^"_count
	.s DataStr=$s(DataStr="":grpdata,1:DataStr_"^"_grpdata)
	.s Num=Num+1
	.s ListData=DisGroup_"^"_DataStr
	.s TMPListData(Num)=ListData

	S EMonStr="",AllTotle=0
	f month=1:1:12 d     //获取总合计
	.s EMonData=$g(^TMP("web.DHCMDTStatistics","JsGetGrpFeeStat","AllCOUNT",year,month))
	.s:EMonData="" EMonData="0"
	.s AllTotle=AllTotle+EMonData
	.s EMonStr=$s(EMonStr="":EMonData,1:EMonStr_"^"_EMonData)
	s TMPListData(Num+1)="合计"_"^"_EMonStr_"^"_AllTotle
	///转换数据为Json格式
	s ListTitle="DisGroup^OneMonNum^TwoMonNum^ThreeMonNum^FourMonNum^FiveMonNum^SixMonNum^SevenMonNum"
	s ListTitle=ListTitle_"^EightMonNum^NineMonNum^TenMonNum^ElevenMonNum^TwelveMonNum^TotleNum"
    
    W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num+1) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index)) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// Descript:    各组会诊质控统计
/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-07
/// w ##Class(web.DHCMDTStatistics).JsGetControlStat("30","1","2020-08-01^2020-08-14^")
ClassMethod JsGetControlStat(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)
    k ^TMP("web.DHCMDTStatistics","JsGetControlStat")
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)	
	i StartDate="" s StartDate=$H-30
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s ArgDisGrp=$p(Params,"^",3)   /// 疑难病种
	
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)        /// 疑难病种
	..Q:(ArgDisGrp'="")&(ArgDisGrp'=DisGrpID)
	..q:'$d(^DHCMDTG(DisGrpID))
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s TumStage=$p(^DHCMDTCON(ID),"^",27)    	  /// 肿瘤状态
    ..Q:TumStage=""
    ..s ^TMP("web.DHCMDTStatistics","JsGetControlStat","GROUP",DisGrpID)=$g(^TMP("web.DHCMDTStatistics","JsGetControlStat","GROUP",DisGrpID))+1
  	..s ^TMP("web.DHCMDTStatistics","JsGetControlStat","TumStage",DisGrpID,TumStage)=$g(^TMP("web.DHCMDTStatistics","JsGetControlStat","TumStage",DisGrpID,TumStage))+1
       
    s Num=0
    s DisGrpID=""
	f  s DisGrpID=$o(^TMP("web.DHCMDTStatistics","JsGetControlStat","TumStage",DisGrpID)) q:DisGrpID=""  d
	.s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	.s GrpNum=$g( ^TMP("web.DHCMDTStatistics","JsGetControlStat","GROUP",DisGrpID))
	.S TumStage="",OneNum=0,TwoNum=0,ThreeNum=0
	.S OneGdp=0,TwoGdp=0,ThreeGdp=0
	.f  s TumStage=$o(^TMP("web.DHCMDTStatistics","JsGetControlStat","TumStage",DisGrpID,TumStage)) q:TumStage=""  d
	..s DataStr=$g(^TMP("web.DHCMDTStatistics","JsGetControlStat","TumStage",DisGrpID,TumStage))
	..I TumStage=1  S OneNum=DataStr, OneGdp=$j(OneNum/GrpNum*100,"",1)_"%"
    ..I TumStage=2  S TwoNum=DataStr, TwoGdp=$j(TwoNum/GrpNum*100,"",1)_"%"
    ..I TumStage=3  S ThreeNum=DataStr, ThreeGdp=$j(ThreeNum/GrpNum*100,"",1)_"%"
    .S Num=Num+1
	.s TMPListData(Num)=DisGroup_"^"_GrpNum_"^"_OneNum_"^"_OneGdp_"^"_TwoNum_"^"_TwoGdp_"^"_ThreeNum_"^"_ThreeGdp
	///转换数据为Json格式
	s ListTitle="DisGroup^GrpNum^OneNum^OneGdp^TwoNum^TwoGdp^ThreeNum^ThreeGdp"
    
    W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index)) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
    
    q ""
}

/// Descript:    各组会诊质控统计导出
/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-18
/// w ##Class(web.DHCMDTStatistics).JsGetControlExport("2020-08-01^2020-08-14^")
ClassMethod JsGetControlExport(Params As %String) As %String
{
	n (Params,%session)
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)	
	i StartDate="" s StartDate=$H-30
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s ArgDisGrp=$p(Params,"^",3)   /// 疑难病种
	
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)  /// 多语言支持
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) /// 年龄
	..s PatDiagDesc=##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis(EpisodeID)   /// 诊断
	..S AdmDoctor=""
	..S AdmDocCodeDR=$p(^PAADM(EpisodeID),"^",9) //医生
	..S:AdmDocCodeDR'="" AdmDoctor=$p(^CTPCP(AdmDocCodeDR,1),"^",2)
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s:PatLoc["-" PatLoc=$p(PatLoc,"-",2)
	..s PatLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",PatLoc)  /// 多语言支持
	..s MedicalNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)       /// 病案号
	
	..s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	..s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)  /// 多语言支持
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstRUserID=$p(^DHCMDTCON(ID),"^",5)  /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  /// 多语言支持
	..s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)

	..s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,2)
	..s CstNTime=CstNDate_" "_CstNTime
	..s CstStatusID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..Q:CstStatusID=""
	..s CstStatusDesc=$p($g(^DHCMDTS(CstStatusID)),"^",2)
    ..s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s TreMeasures=$p($g(^DHCMDTCON(ID)),"^",11)     /// 最终治疗措施
	..s TumStage=$p($g(^DHCMDTCON(ID)),"^",27)    	  /// 肿瘤状态
	..s TumStage=$s(TumStage="1":"早期",TumStage="2":"局部晚期",TumStage="3":"晚期",1:"")
	..s AppAdmID = $p(^DHCMDTCON(ID),"^",20) 
	..s AdmType=""
	..I AppAdmID="" S AppAdmID=EpisodeID
	..s:AppAdmID'="" AdmType=$p(^PAADM(AppAdmID),"^",2)
	..S AdmType=$S(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",1:"")
	..s PayMony =##Class(web.DHCMDTCom).GetConsIsPayMoney(ID)
	..s CstCTime=##Class(web.DHCMDTStatistics).JsonGetMDtLog(ID)   //会诊完成时间
	..s BillId=$o(^DHCMDTORD(0,"IndexCst",ID,""))
	..s Oeori="",CostStr="",itmCost="",arcimid=""
	..s:BillId'="" Oeori=$p(^DHCMDTORD(BillId),"^",2)  /// 医嘱ID
	..s:Oeori'="" arcimid=$p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1)),"^",2) ///医嘱项目ID
	..s:arcimid'="" CostStr=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcimid,+$h,"","","","")  
	..;s:CostStr'="" itmCost=$p(CostStr,"^",1)  //会诊诊金
	..s itmCost=##class(web.DHCMDTCom).GetCstBillFee(ID)
	..s Num=Num+1
	..s ListData=Num_"^"_ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_AdmType_"^"_AdmDoctor_"^"_CstRLoc_"^"_MedicalNo_"^"_PatDiagDesc
	..s ListData=ListData_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser_"^"_CstNDate_"^"_CstNTime_"^"_CstUser
	..s ListData=ListData_"^"_DisGrpID_"^"_DisGroup_"^"_CstStatusDesc_"^"_PayMony_"^"_PatientID_"^"_AppAdmID_"^"_CstCTime_"^"_itmCost
	..s ListData=ListData_"^"_TreMeasures_"^"_TumStage
	..s TMPListData(Num)=ListData
	..
	///转换数据为Json格式
	s ListTitle="Num^ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^AdmType^AdmDoctor^CstRLoc^MedicalNo^PatDiagDesc"
	s ListTitle=ListTitle_"^CstRDate^CstRTime^CstRUserID^CstRUser^CstNDate^CstNTime^CstUser"
	s ListTitle=ListTitle_"^DisGrpID^DisGroup^CstStatusDesc^PayMony^PatientID^AppAdmID^CstCTime^itmCost"
	s ListTitle=ListTitle_"^TreMeasures^TumStage"
	s count=0,Start=1
	///转换数据为Json格式
	W "[" //输出json前缀串
	s index=""
	F  s index=$o(TMPListData(index)) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.S count=count+1
    .W $case(count,Start:"",:",") 
	.W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData) 
	W "]" //输出json结尾符
	Q ""
}

/// Descript:     MDT病例不同分期情况所占比例
/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-18
/// w ##Class(web.DHCMDTStatistics).JsGetTumStageMap("30","1","2020-08-01^2020-08-14^","")
ClassMethod JsGetTumStageMap(rows As %String, page As %String, Params As %String, pid As %String) As %String
{
	n (rows,page,Params, pid)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=+$H-30
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=+$H
	k TmpArr
	
	i pid="" s pid=..NewPid()
    d ..killTmpGlobal(pid) /// k掉临时global
    
	s mParams=Params /// 准备下级筛查条件
	D ..GetTumStageMap(StartDate, EndDate, .TmpArr) /// 获取MDT会诊数据

	///转换数据为Json格式
	s ListTitle="TumStage^DisQty^Params^pid"
	W ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s TumStage=$p(ListData,"^",1)
	.s TumStage=$s(TumStage="1":"早期",TumStage="2":"局部晚期",TumStage="3":"晚期",1:"未确定")
	.S DisQty=$p(ListData,"^",2)
	.s ListData=TumStage_"^"_DisQty_"^"_index_"^"_pid
	.s ^TMP("DHCMDT","web.DHCMDTStatistics","JsGetTumStageMap",pid,index)=ListData
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count) //输出json前缀串
	Q ""
}

/// Descript:    MDT病例不同分期情况所占比例
/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-18
/// w ##Class(web.DHCMDTStatistics).GetTumStageMap()
ClassMethod GetTumStageMap(StartDate As %String, EndDate As %String, TmpArr As %String) As %String
{
	n (StartDate, EndDate, TmpArr)
  
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s StatID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..//Q:StatID=""
	..//Q:$p($g(^DHCMDTS(StatID)),"^",1)'=80
	..s TumStage=$p(^DHCMDTCON(ID),"^",27)    	  /// 肿瘤状态
    ..Q:TumStage=""
	..I '$D(TmpArr(TumStage)) s TmpArr(TumStage)=TumStage_"^"_1
	..E  s $p(TmpArr(TumStage),"^",2)=$p($g(TmpArr(TumStage)),"^",2)+1
	.
	Q ""
}

/// Creator: 	  yangyongtao
/// CreateDate:   2020-08-18
/// Descript:     MDT病例不同分期情况所占比例
/// w ##Class(web.DHCMDTStatistics).JsGetTumStageMapCharts("")
ClassMethod JsGetTumStageMapCharts(pid As %String) As %String
{
	n (pid)
	//Q:pid="" "[]"
	/// 转换数据为Json格式
	s ListTitle="name^group^value"
	W "["
	s index="", Num=0
	F  s index=$o(^TMP("DHCMDT","web.DHCMDTStatistics","JsGetTumStageMap",pid,index)) Q:index=""  D
	.s mdata=$g(^TMP("DHCMDT","web.DHCMDTStatistics","JsGetTumStageMap",pid,index))
	.Q:mdata=""
	.s Key=$p(mdata,"^",1)
	.s Val=$p(mdata,"^",2)
	.s ListData=Key_"^^"_Val
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.
	W "]"
	d ..killTmpGlobal(pid) /// k掉临时global
	Q ""
}

/// Descript:  取会诊状态日志
/// w ##Class(web.DHCMDTStatistics).JsonGetMDtLog("15")
ClassMethod JsonGetMDtLog(CstID As %String) As %String
{
	n (CstID)
	S RetTmp=""
	s LgID=""
	F  s LgID=$o(^DHCMDTL(0,"CstRef",CstID,LgID)) Q:(LgID="")  D
	.s CstUser=""
	.s UserID=$p(^DHCMDTL(LgID),"^",2)    /// 操作人
	.s:UserID'="" CstUser=$p(^SSU("SSUSR",UserID),"^",2)
	.s StatusID=$p(^DHCMDTL(LgID),"^",3)  /// 状态
	.Q:StatusID=""
	.s StatusCode=$p($g(^DHCMDTS(StatusID)),"^",1)
	.s Status=$p($g(^DHCMDTS(StatusID)),"^",2)
	.Q:Status'="完成"
	.s LgDate=$p(^DHCMDTL(LgID),"^",4)    /// 日期
	.s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCMDTL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,2)
	.s RetTmp=LgDate_" "_LgTime
	Q RetTmp
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q ##Class(web.DHCAPPExaRepCom).NewPid()
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCMDT","web.DHCMDTStatistics","JsGetTumStageMap",pid)
	q ""
}

/// Descript:    各组会诊质控统计
/// Creator: 	  yangzongyi
/// CreateDate:   2020-08-07
/// w ##Class(web.DHCMDTStatistics).JsGetControlStatt("30","1","2020-11-03^2021-07-29^")
ClassMethod JsGetControlStatt(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)
    k ^TMP("web.DHCMDTStatistics","JsGetControlStat")
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)	
	i StartDate="" s StartDate=$H-30
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s ArgDisGrp=$p(Params,"^",3)   /// 疑难病种
	
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)        /// 疑难病种
	..q:+DisGrpID=0
	..Q:(ArgDisGrp'="")&(ArgDisGrp'=DisGrpID)
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
    ..s CH=""
	..F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	...s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	...q:+CsLocID=0
	...s ^TMP("web.DHCMDTStatistics","JsGetGrpStat","GROUPID",DisGrpID)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","GROUPID",DisGrpID))+1
  	...s ^TMP("web.DHCMDTStatistics","JsGetGrpStat","LOC",CsLocID)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","LOC",CsLocID))+1
  	...s ^TMP("web.DHCMDTStatistics","JsGetGrpStat","COUNT",CsLocID,DisGrpID)=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","COUNT",CsLocID,DisGrpID))+1
        
    s Num=0
    s CsLocID=""
	f  s CsLocID=$o(^TMP("web.DHCMDTStatistics","JsGetGrpStat","LOC",CsLocID)) q:CsLocID=""  d
	.s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	.f  s DisGrpID=$o(^TMP("web.DHCMDTStatistics","JsGetGrpStat","GROUPID",DisGrpID)) q:DisGrpID=""  d
    .s grpdata="",DataStr=""
	.s count=$g(^TMP("web.DHCMDTStatistics","JsGetGrpStat","COUNT",CsLocID,+DisGrpID))
	.s:count="" count="0"
	.s grpdata=grpdata_"^"_count
	.s DataStr=$s(DataStr="":grpdata,1:DataStr_"^"_grpdata)
	.s Num=Num+1
	.s ListData=CsLocDesc_"^"_DataStr
	.s TMPListData(Num)=ListData

	
	///转换数据为Json格式
	s ListTitle="DisGroup^CsLocDesc"
	
    
    W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num+1) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index)) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// /do ##class(%ResultSet).RunQuery("web.DHCMDTStatistics","GetOPBillDailyUserGZL", "2021-03-1", "2021-5-13") 
Query GetOPBillDailyUserGZL(stDate As %String, endDate As %String) As websys.Query(ROWSPEC = "CsLocdESC:%String,nums1:%Float,nums2:%Float,nums3:%Float,nums4:%Float,nums5:%Float,nums6:%Float,nums7:%Float,nums8:%Float,nums9:%Float,nums10:%Float,nums11:%Float,nums12:%Float,nums13:%Float,nums14:%Float,nums15:%Float,nums16:%Float,nums17:%Float,nums18:%Float,nums19:%Float,nums20:%Float,nums21:%Float") [ SqlProc ]
{
}

ClassMethod GetOPBillDailyUserGZLExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String) As %Status
{
	set repid=$I(^CacheTemp)
    set ind=1
	if ((stDate="")||(endDate=""))  set qHandle=$lb(0,repid,0) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	k ^TempOPUserGZL("GYSRMYY",$I)	
	
	f date=stDate:1:endDate d
	.;b ;12
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",date,ID)) Q:ID=""  D
	..;b ;2
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)        /// 疑难病种
	..;Q:(ArgDisGrp'="")&(ArgDisGrp'=DisGrpID)
	..;s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..
    ..s CH=""
	..F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	...s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	...s ^TempOPUserGZL("GYSRMYY",$I,CsLocID,DisGrpID)=+$g(^TempOPUserGZL("GYSRMYY",$I,CsLocID,DisGrpID))+1
	
	
	S CsLocID=""
	f  s CsLocID=$o(^TempOPUserGZL("GYSRMYY",$I,CsLocID)) q:CsLocID=""  d
	.s (nums1,nums2,nums3,nums4,nums5,nums6,nums7,nums8,nums9,nums10,nums11,nums12,nums13,nums14,nums15,nums16,nums17,nums18,nums19,nums20,nums21)=0
	.s group=""
	.f  s group=$o(^TempOPUserGZL("GYSRMYY",$I,CsLocID,group)) q:group=""  d
	..s num1=+$g(^TempOPUserGZL("GYSRMYY",$I,CsLocID,group))
	..s DisGroup=$p(^DHCMDTG(group),"^",2)
	..i group=1 s nums1=nums1+num1
	..e  i group =2 s nums2=nums2+num1
	..e  i group =3 s nums3=nums3+num1
	..e  i group =4 s nums4=nums4+num1
	..e  i group =5 s nums5=nums5+num1
	..e  i group =6 s nums6=nums6+num1
	..e  i group =7 s nums7=nums7+num1
	..e  i group =8 s nums8=nums8+num1
	..e  i group =9 s nums9=nums9+num1
	..e  i group =10 s nums10=nums10+num1
	..e  i group =11 s nums11=nums11+num1
	..e  i group =12 s nums12=nums12+num1
	..e  i group =13 s nums13=nums13+num1
	..e  i group =14 s nums14=nums14+num1
	..e  i group =15 s nums15=nums15+num1
	..e  i group =16 s nums16=nums16+num1
	..e  i group =17 s nums17=nums17+num1
	..e  i group =18 s nums18=nums18+num1
	..e  i group =19 s nums19=nums19+num1
	..e  i group =20 s nums20=nums20+num1
	..e  i group =21 s nums21=nums21+num1
	.s CsLocdESC=$p(^CTLOC(CsLocID),"^",2)       /// 会诊科室
	.d GetOPBillDailyUserGZL
    set qHandle=$lb(0,repid,0)
	quit $$$OK

	
GetOPBillDailyUserGZL
	set data=$lb(CsLocdESC,nums1,nums2,nums3,nums4,nums5,nums6,nums7,nums8,nums9,nums10,nums11,nums12,nums13,nums14,nums15,nums16,nums17,nums18,nums19,nums20,nums21)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
}

/// d ##class(%ResultSet).RunQuery("web.DHCMDTStatistics","DiagnosList",1)
Query DiagnosList(MRADMID As %String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", LogonCTLocRowId As %String = "", SqlDbxFlag As %String = "") As %Query(ROWSPEC = "DiagnosICDDesc:%String")
{
}

ClassMethod DiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod DiagnosListExecute(ByRef qHandle As %Binary, MRADMID As %String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", LogonCTLocRowId As %String = "", SqlDbxFlag As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosEntryV8","DiagnosList","634",,,63)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if MRADMID="" {  
	    d ResetVariables1
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set RetStr="",NO=1
	k TempArr("FindDiagnos",$J)
	
	s defaultDiagnosTypeID=""
	if DiagnosTypeCode'="" {
		s defaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code",DiagnosTypeCode,0))
	}
	s Id=0
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s MRDiagnosTypeDesc=""
	.s MRDiagnosTypeDr=""
	.S MRdiagnosNoteDr=""
	.S MRdiagnosNoteDesc=""
	.s MRdiagnosNoteSubRowid=""
	.S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
	.if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
	.Q:(defaultDiagnosTypeID'="")&&(MRDiagnosTypeDr'=defaultDiagnosTypeID)
	.I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
	.S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
	.I MRdiagnosNoteSubRowid'="" Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
	.s MRdiagnosNoteDesc=##class(ext.util.String).EvalJSON(MRdiagnosNoteDesc)
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
	.S MRDiagnosDate=obj.Data("MRDIADate")
	.s MRdiagnosTime=obj.Data("MRDIATime")
	.s MRAddLocDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
	.s MRDIAMRDIADR=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",15)
	.I MRDiagnosDate'="" Set MRDiagnosDate=##class(websys.Conversions).DateLogicalToHtml(MRDiagnosDate) //$zd(MRDiagnosDate,3)
	.I MRdiagnosTime'="" Set MRdiagnosTime=$zt(MRdiagnosTime,3)
	.s BillFlag1="" 
	.s BillFlag3=""
	.s DiagnosCat=""
	.i CodeRowid'="" d
	..s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
	..s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
	..
	..i BillFlag3'="Y" d
	...s DiagnosCat="西医"
	..else  if (BillFlag3="Y")&&(BillFlag1'="Y") d
	...s DiagnosCat="中医"
	..else  d
	...s DiagnosCat="证型"
	.e  d
	..s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
	..i Questionnaire=1 d
	...s DiagnosCat="西医"
	..else  if (Questionnaire=2) d
	...s DiagnosCat="中医"
	..else  if (Questionnaire=3) d
	...s DiagnosCat="证型"
	.i DiagnosCat="" s DiagnosCat="西医"
	.Q:(ICDType="1")&&(BillFlag3'="Y")
	.s MainDiagFlag=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
	.i MainDiagFlag="Y" s MainDiagFlag="是"
	.e  s MainDiagFlag="否"
	.s MRDesc=obj.Data("MRDIADesc")
	.if (MRDesc'="")&&(SqlDbxFlag'="1") s MRDesc=$LIST(MRDesc,1)
	.s DiagStat=""
	.s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
	.s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
	.s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
	.s DIAOnsetDate=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",35) //取发病日期
	.s:DIAOnsetDate'="" DIAOnsetDate=##class(websys.Conversions).DateLogicalToHtml(DIAOnsetDate) //$zd(DIAOnsetDate,3) //取发病日期
	.if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
	.if DiagnosNumber="" s DiagnosNumber=9999 //$g(^MR(3,"DIA",0))+1
	.;tanjishan 慢病
	.s NCDCode=$p($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DHC")),"^",10)
	.s NCDDesc="" //..GetNCDDesc(NCDCode)
	.;end
	.;描述有反斜杠会影响前台
	.s MRDesc=$replace(MRDesc,"\","")
	.;s banlkSpace="" f i=1:1:(+DiagnosLeavel-1) s banlkSpace=banlkSpace_"&nbsp&nbsp&nbsp&nbsp" ;根椐级别加空格
	.s banlkSpace="" f i=1:1:(+DiagnosLeavel-1) s banlkSpace=banlkSpace ;根椐级别加空格
    .s Desc=banlkSpace_Desc
    .s SyndromeDesc=##class(web.DHCDocDiagnosNew).GetDiaSyndDesc(Rowid)
    .i SyndromeDesc'="" s SyndromeDesc=$tr(SyndromeDesc,","," ")
	.//i MainDiagFlag'="" s Desc=Desc_MainDiagFlag
	.s DiagnosDoctor=""
	.s DoctorDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",4)
    .i DoctorDr'="" s DiagnosDoctor=$P($G(^CTPCP(DoctorDr,1)),"^",2)
	.s BodyPartDesc=""
    .s BodyPartDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",21)
    .i BodyPartDr'="" s BodyPartDesc=$List(^DHCEMRM.DicDiagnosPositionD(BodyPartDr),3)
    .//b //451
	.s TempArr("FindDiagnos",$j,DiagnosNumber,$P(Rowid,"||",2))=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_DiagnosCat_"^"_MRDIAMRDIADR_"^"_NCDCode_"^"_NCDDesc_"^"_MainDiagFlag_"^"_SyndromeDesc_"^"_DiagStatDr_"^"_MRDiagnosTypeDr_"^"_DiagnosDoctor_"^"_BodyPartDesc_"^"_BodyPartDr
	d obj.Close()
	
	//按顺序输出设置
	s TempDia=""
	s DiagnosNumber=0  f  {
		s DiagnosNumber=$O(TempArr("FindDiagnos",$j,DiagnosNumber)) 
		Q:DiagnosNumber=""  d
		s Temprowid=0 f {
			s Temprowid=$O(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid))
			q:Temprowid=""
			s DiagnosDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",1)
			s DiagnosValue=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",2)
			s DiagnosCodeRowid=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",3)
			s DiagnosMRDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",4)
			s DiagnosICDCode=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",5)
			s DiagnosType=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",6)
			s DiagnosNote=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",7)
			s DiagnosDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",8)
			s DiagnosOnsetDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",13)
			s DiagnosLeavel=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",11)
			s DiagStat=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",10)
			s DiagnosCat=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",14)
			s MRDIAMRDIADR=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",15)
			
			s NCDCode=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",16)
			s NCDDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",17)
			s MainDiagFlag=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",18)
			s SyndromeDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",19)
			
			s DiagStatDr=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",20)
			s MRDiagnosTypeDr=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",21)
			s DiagnosDoctor=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",22)
			s BodyPartDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",23)
			s BodyPartDr=$p(TempArr("FindDiagnos",$j,DiagnosNumber,Temprowid),"^",24)
			s Id=Id+1
			Do OutputRow1
		}
	}
	k TempArr("FindDiagnos",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
     set Data=$lb(DiagnosDesc)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	quit
ResetVariables1
	set (DiagnosDesc)=""
	quit
}

ClassMethod DiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosListExecute ]
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

}
