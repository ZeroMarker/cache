Import sqluser

/// Creator: 	huaxiaoying
/// CreateDate: 2018-04-27
/// Descript: 	会诊明细统计
Class web.DHCEMConsultStatistic Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 取会诊申请数据
/// w ##Class(web.DHCEMConsultStatistic).JsonGetConsultNo("10","1","2018-10-09^2018-10-11^")
ClassMethod JsonGetConsultNo(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
    s CstStatus=$p(Params,"^",3) /// 状态
    s LgHospID=$p(Params,"^",4)
    s CstType=$p(Params,"^",5)    /// 会诊类型
    s ConsNature=$p(Params,"^",6) /// 会诊性质 hxy 2021-04-15
    s RLocIDHtml=$p(Params,"^",7) /// 申请科室
	s CLocIDHtml=$p(Params,"^",8) /// 会诊科室
	s DOCAHtml=$p(Params,"^",9)  /// 特抗
    
    i StartDate="" s StartDate=+$H-2
    i EndDate="" s EndDate=+$H

    k TMPListData
    s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	..s AdmHsopID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	..q:(AdmHsopID'=LgHospID)
	..s DOCAnti=$P(^DHCEMCON(CstID),"^",19) //hxy 2022-09-01 st
    ..q:(DOCAHtml="Y")&&(DOCAnti'="DOCA") //ed
	..s PAPMIDr = $p(^PAADM(EpisodeID),"^",1)
	..s PatName = $p(^PAPER(PAPMIDr,"ALL"),"^",1)    /// 病人姓名
	..s PatRegNo=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1) ///病人登记号
	..s PatMrNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID) //hxy 2021-06-24 病案号
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..q:(RLocIDHtml'="")&&(RLocIDHtml'=CstRLocID)
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	..s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	..s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRUser=""
	..s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	..s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	..s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	..s CstTrePro=$tr(CstTrePro,$c(10),"") //hxy 2020-05-09
	..s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	..s CstPurpose=$tr(CstPurpose,$c(10),"") //hxy 2020-05-09
	..s CstNDate=$p(^DHCEMCON(CstID),"^",10)    /// 会诊日期
	..s CstNDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)
	..s CstNDateLogical=##class(web.DHCEMCommonUtil).DateHtmlToLogical(CstNDate)	
	..s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	..s CstECCDate=$p(^DHCEMCON(CstID),"^",20)  /// 完成日期
	..s CstECCTime=$p(^DHCEMCON(CstID),"^",21)  /// 完成时间
	..s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	..s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	..;Q:CstOutFlag'="Y"
	..s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	..s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	..s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	..s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	..s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	..s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	..;s CstCstType=$s(CstEmFlag="Y":"加急",1:"普通")
	..s CstTypeID=$p($g(^DHCEMCON(CstID)),"^",8)   /// 会诊类型
	..q:(CstType'="")&(CstTypeID'=CstType) //hxy 2021-01-29
	..s CstCstType=$p($g(^DHCEMCDI(CstTypeID)),"^",2) /// 会诊类型
	..s CstUserID=$p(^DHCEMCON(CstID),"^",14)  /// 审核人
	..;Q:(CstType="")&(CstUserID'="")
	..s CstNature=$p(^DHCEMCON(CstID),"^",45) //hxy 2021-04-15 st
	..q:(ConsNature'="")&(ConsNature'=CstNature) 
	..s CstNature= $p($g(^DHCEMCDI(+CstNature)),"^",2) //ed
	..s CsTreMea=$p(^DHCEMCON(CstID),"^",17)   ///会诊意见 hxy 2022-06-27
	..s CstStat="" ///
	..s DBCstNDateLogical = CstNDateLogical          //对比用变量:会诊日期为空时取当前时间
	..s:DBCstNDateLogical="" DBCstNDateLogical=+$H  
	..s DBCstNTime = CstNTime                        //对比用变量
	..s:DBCstNTime'="" DBCstNTime = $zth(DBCstNTime)
	..s:DBCstNTime="" DBCstNTime=+$p($H,",",2)
	..
	..s CH=""
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)     /// 会诊医生
	...i CareProvID="" s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2) //hxy 2021-06-24 st
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)          /// 会诊人 ed
	...;s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	...s CsLocDesc=""
	...s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	...Q:(CLocIDHtml'="")&(CsLocID'=CLocIDHtml)
	...s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	...i CstOutFlag="Y" s CsLocDesc=CstUnit_"【"_CstDocName_"】"
	...s CstStat=..GetCstCurStat(CstID_"||"_CH)          /// 取会诊记录的当前状态值
	...q:(CstStatus="超时完成")&&(..GetCsOutStaus(CstID_"||"_CH)'=1)
	...q:(CstStatus="未完成")&&((CstStat="完成")||(CstStat="确认")||(CstStat="评价")||(CstStat="会诊评价")||(CstStat="取消确认")||(CstStat="取消评价")||(CstStat="取消会诊评价")) //hxy 2021-01-28 加三个取消
	...Q:(CstStatus'="")&(CstStatus'=CstStat)&(CstStatus'="未完成")&(CstStatus'="超时完成")
	...s CstLogStr=..GetCstLogStr(CstID_"||"_CH,"60")        //取日志的确认医生和确认时间
	...s CstECLUser=$p(CstLogStr,"^",1) //确认人
	...s CstECLTime=$p(CstLogStr,"^",2) //确认时间
	...s CstECLArriTime=..GetCstArriTime(CstID_"||"_CH) //报到（到达）时间
	...s CstLogOverTime=##Class(web.DHCEMConsultQuery).GetCstNodeTime(CstID_"||"_CH,"50") //完成时间
	...s:CstStat="取消完成" CstLogOverTime=""
	...s CstLogOverDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical($p(CstLogOverTime," ",1))
	...s DBCstLogOverTime=$p(CstLogOverTime," ",2)
	...s:DBCstLogOverTime'="" DBCstLogOverTime=$zth(DBCstLogOverTime)
	...s:DBCstLogOverTime="" DBCstLogOverTime=$p($h,",",2)
	...;i CstStatus="未按时完成" Q:(CstLogOverDate<=CstNDateLogical)
	...;未按时完成的逻辑为申请的时候输入的会诊日期和时间
	...s DBCstLogOverDate = CstLogOverDate           //对比用变量
	...s:DBCstLogOverDate="" DBCstLogOverDate=+$H  
	...b ;err
	...q:(CstStatus="未按时完成")&&(DBCstNTime="")&&(DBCstLogOverDate<DBCstNDateLogical)
	...q:(CstStatus="未按时完成")&&(DBCstNTime'="")&&((DBCstLogOverDate<DBCstNDateLogical)||((DBCstLogOverDate=DBCstNDateLogical)&&(DBCstLogOverTime<DBCstNTime)))
	...s CsOpinion = $p($g(^DHCEMCON(CstID,"I",CH)),"^",4)
	...s:(CsOpinion="")&&(CsTreMea'="") CsOpinion=CsTreMea
	...s Num=Num+1
	...s CstRLoc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",CstRLoc)
	...s CstCstType=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",CstCstType)
	...s CstRUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",CstRUser)
	...s PatName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
	...s CstStat=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsStatus","ECSDesc","",CstStat)
	...s CsLocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",CsLocDesc)
	...s CstECLUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",CstECLUser)
    ...s ListData=CstID_"^"_EpisodeID_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime
    ...s ListData=ListData_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser_"^"_CstPhone_"^"_CstCstType_"^"_CsLocDesc_"^"_CstStat
    ...s ListData=ListData_"^"_CstPurpose_"^"_CstTrePro_"^"_CstECCDate_"^"_CstECCTime_"^"_CstECLUser_"^"_CstECLTime_"^"_CstECLArriTime_"^"_CstLogOverTime_"^"_PatName_"^"_PatRegNo_"^"_CstNature //
    ...s ListData=ListData_"^"_PatMrNo_"^"_CsUser_"^"_CsOpinion
	...s TMPListData(Num)=ListData
	
	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="CstID^EpisodeID^CstRLocID^CstRLoc^CstRDate^CstRTime^CstUserID^CstRUser^CstTrePro^CstPurpose^CstNDate^CstNTime"
	s ListTitle=ListTitle_"^CstNPlace^CstEmFlag^CstOutFlag^CstUnit^CstDocName^CstRemark^CstUser^CstPhone^CstType^CsLocDesc^CstStat"
	s ListTitle=ListTitle_"^CstPurpose^CstTrePro^CstECCDate^CstECCTime^CstECLUser^CstECLTime^CstECLArriTime^CstLogOverTime^PatName^PatRegNo^CstNature" //
	s ListTitle=ListTitle_"^PatMrNo^CsUser^CsOpinion"

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

/// Descript:  取会诊记录的当前状态值
/// w ##Class(web.DHCEMConsultStatistic).GetCstCurStat("12||1")
ClassMethod GetCstCurStat(CstID As %String) As %String
{
	n (CstID)
	s LgID="",ID=""
	F  s LgID=$o(^DHCEMCONL(0,"Cst",CstID,LgID),-1) Q:(LgID="")||(ID'="")  D
	.q:$p($g(^DHCEMCONS(+($p(^DHCEMCONL(LgID),"^",3)))),"^",1)="40" //hxy 2021-05-14 到达不纳入流程状态，因为可多次到达(例如：完成-到达，此时为完成)
	.s ID=$p(^DHCEMCONL(LgID),"^",3)        /// 状态
	.
	i ID="" D
	.s ID=$p(^DHCEMCON(+CstID),"^",18)
	Q $p($g(^DHCEMCONS(+ID)),"^",2)
}

/// Creator:    huaxiaoying
/// CreateDate: 2018-04-28
/// Descript:   取日志确认信息
/// InPut:      CstItmID - rowid,StCode-确认状态code-60
/// OutPut:     
/// w ##Class(web.DHCEMConsultStatistic).GetCstLogStr("506||1","60")
ClassMethod GetCstLogStr(CstItmID As %String, StCode As %String) As %String
{
	n (CstItmID,StCode)
	Q:StCode="" ""
	Q:$p(^DHCEMCON(+CstItmID),"^",18)="" "" /// 会诊状态
	s LgID="",tmp="",QuitFlag=0
	F  s LgID=$o(^DHCEMCONL(0,"Cst",CstItmID,LgID),-1) Q:(LgID="")||(tmp'="")||(QuitFlag=1)  D
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.Q:StatusID=""
	.s StatusCode=$p($g(^DHCEMCONS(+StatusID)),"^",1)
	.i (StCode="60")&(StatusCode="61") s QuitFlag=1
	.Q:StatusCode'=StCode
    .s CstUser=""
	.s UserID=$p(^DHCEMCONL(LgID),"^",2)    /// 操作人
	.s:UserID'="" CstUser=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s tmp=CstUser_"^"_LgDate_" "_LgTime 
	
	Q tmp
}

/// Creator:   huaxiaoying
/// CreateDate: 2018-04-28
/// Descript:  取会诊记录的到达时间(报到时间)
/// w ##Class(web.DHCEMConsultQuery).GetCstCurStat("12")
ClassMethod GetCstArriTime(CstItmID As %String) As %String
{
	n (CstItmID)
	s LgID="",tmp=""
	F  s LgID=$o(^DHCEMCONL(0,"Cst",CstItmID,LgID),-1) Q:(LgID="")||(tmp'="")  D
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.Q:StatusID=""
	.s StatusDesc=$p(^DHCEMCONS(StatusID),"^",2)
	.q:StatusDesc'="到达"
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s tmp=LgDate_" "_LgTime 
	Q tmp
}

/// =======================================全年院内多科统计Start======================================
/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     全年院内多科统计
/// InPut:         - 就诊ID
/// OutPut:       病人ID^姓名^登记号^性别^科室^病区^费别^床号^出生日期^联系方式^地址^病案号^诊断^就诊ID^申请科室ID^申请科室^申请日期^申请时间^申请人ID^申请人^简要病历^会诊目的^要求会诊日期^要求会诊时间^要求会诊地点^是否加急^是否外院^外院名称^外院医生^备注^联系人^联系电话^会诊类型^会诊科室^会诊医生^会诊意见
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsultStatistic","QryHosLocCstTimes","94")
Query QryHosLocCstTimes(argYear As %String) As websys.Query(ROWSPEC = "LocDesc:%String,Jan:%String,Feb:%String,Mar:%String,Apr:%String,May:%String,Jun:%String,Jul:%String,Aug:%String,Sep:%String,Oct:%String,Nov:%String,Dec:%String")
{
}

ClassMethod QryHosLocCstTimesExecute(ByRef qHandle As %Binary, argYear As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpCstArr
    
    /// 检查申请列表
	D ..GetHosLocCstTimes(argYear, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(index_"^"_ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     全年院内多科统计
/// InPut:        argYear - 年份
/// OutPut:       *月份 会诊次数
/// D ##Class(web.DHCEMConsultStatistic).GetHosLocCstTimes("2018",.TmpCstArr)
ClassMethod GetHosLocCstTimes(argYear As %String, TmpCstArr As %String) As %String
{
	n (argYear, TmpCstArr)
	s StartDate=argYear_"-01-01", EndDate=argYear_"-12-31"
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)    /// 申请科室
	..s CstRLoc=$p($g(^CTLOC(+CstRLocID)),"^",2)
	..s CstECCDate=$p(^DHCEMCON(CstID),"^",20)  /// 完成日期
	..s CstECCTime=$p(^DHCEMCON(CstID),"^",21)  /// 完成时间
	..Q:$p(^DHCEMCON(CstID),"^",24)="Y"         /// 是否院外
	..s month=+$p($zd(dd,3),"-",2)
	..i $g(TmpCstArr(CstRLoc))="" D
	...s TmpCstArr(CstRLoc)="0^0^0^0^0^0^0^0^0^0^0^0"
	...s $p(TmpCstArr(CstRLoc),"^",month)=$p($g(TmpCstArr(CstRLoc)),"^",month)+1
	..E  D
	...s $p(TmpCstArr(CstRLoc),"^",month)=$p(TmpCstArr(CstRLoc),"^",month)+1
	..
	Q ""
}

/// =======================================全年院内多科统计End======================================
/// =======================================院际会诊登记报表Start======================================
/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     院际会诊登记报表
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       就诊ID^登记号^姓名^床号^就诊科室^病区^申请科室^申请日期^申请时间^申请人^病情及诊疗经过^会诊的理由和目的^会诊日期^会诊时间^会诊地点^外院^外院科室^联系人^联系电话^最终治疗措施
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsultStatistic","QryInterHosCst","2018-01-01","2018-12-31","2")
Query QryInterHosCst(StartDate As %String, EndDate As %String, CsHospID As %String) As websys.Query(ROWSPEC = "EpisodeID:%String,PatNo:%String,PatName:%String,PatBed:%String,PatLoc:%String,PatWard:%String,CstRLoc:%String,CstRDate:%String,CstRTime:%String,CstRUser:%String,CstTrePro:%String,CstPurpose:%String,CstNDate:%String,CstNTime:%String,CstNPlace:%String,CstUnit:%String,CstDocName:%String,CstUser:%String,CstPhone:%String,TreMeasures:%String")
{
}

ClassMethod QryInterHosCstExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, CsHospID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpCstArr

    /// 检查申请列表
	D ..GetInterHosCst(StartDate,EndDate,CsHospID, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     院际会诊登记报表
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       *月份 会诊次数
/// D ##Class(web.DHCEMConsultStatistic).GetInterHosCst("2018-01-01","2018-12-31","2",.TmpCstArr)
ClassMethod GetInterHosCst(StartDate As %String, EndDate As %String, CsHospID As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, CsHospID, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
    s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..Q:$p(^DHCEMCON(CstID),"^",24)'="Y"          /// 是否院外
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)      /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	..s PatLoc=$p($g(^CTLOC(+PatLocID)),"^",2)
	..s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	  /// 病区ID
	..s PatWard=$p($g(^PAWARD(+PatWardID)),"^",2) /// 病区描述
	..s BedId=$p(^PAADM(EpisodeID),"^",73) 		  /// 床号ID
    ..s PatBed=""
    ..s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..s CstRLoc=$p($g(^CTLOC(+CstRLocID)),"^",2)
	..s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstUserID)),"^",2)
	..s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	..s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)
	..s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	..s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	..s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	..s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	..s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	..s TreMeasures=$p(^DHCEMCON(CstID),"^",17)  /// 最终治疗措施
	..s Num=Num+1
	..s ListData=EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatBed_"^"_PatLoc_"^"_PatWard_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUser_"^"_CstTrePro
	..s ListData=ListData_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstUnit_"^"_CstDocName_"^"_CstUser_"^"_CstPhone_"^"_TreMeasures
	..s TmpCstArr(Num)=ListData
	Q ""
}

/// =======================================院际会诊登记报表End======================================
/// =======================================院内平会诊数据统计Start======================================
/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     院内平会诊数据统计
/// InPut:        StartDate - EndDate - 结束日期
/// OutPut:       科室^邀请会诊次数^取消会诊次数^24小时内会诊次数^会诊及时率^超过24小时会诊次数^会诊率^未会诊的次数
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsultStatistic","QryHosUnEmStat","2018-01-01","2018-12-31")
Query QryHosUnEmStat(StartDate As %String, EndDate As %String) As websys.Query(ROWSPEC = "LocDesc:%String,CsTimes:%String,CancelCsTimes:%String,InLimTimes:%String,CsTimeRate:%String,OutLimTimes:%String,CsRate:%String,UnCsTimes:%String")
{
}

ClassMethod QryHosUnEmStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpCstArr
    
    /// 检查申请列表
	D ..GetHosUnEmStat(StartDate, EndDate, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(index_"^"_ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     院内平会诊数据统计
/// InPut:        StartDate - EndDate - 结束日期
/// OutPut:       科室^邀请会诊次数^取消会诊次数^24小时内会诊次数^会诊及时率^超过24小时会诊次数^会诊率^未会诊的次数
/// D ##Class(web.DHCEMConsultStatistic).GetHosUnEmStat("2018-01-01","2018-12-31",.TmpCstArr)
ClassMethod GetHosUnEmStat(StartDate As %String, EndDate As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
    s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..Q:$p(^DHCEMCON(CstID),"^",24)="Y"        /// 是否院外
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..s CstRLoc=$p($g(^CTLOC(+CstRLocID)),"^",2)
	..s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	..s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	..s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	..s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	..i $g(TmpCstArr(CstRLoc))="" D
	...s TmpCstArr(CstRLoc)="0^0^0^0^0^0^0"
	...s $p(TmpCstArr(CstRLoc),"^",1)=$p($g(TmpCstArr(CstRLoc)),"^",1)+1  /// 邀请会诊次数
	..E  D
	...s $p(TmpCstArr(CstRLoc),"^",1)=$p(TmpCstArr(CstRLoc),"^",1)+1
	..s CurStat=##Class(web.DHCEMConsultQuery).GetCstCurStat(CstID)
	..i CurStat="取消" s $p(TmpCstArr(CstRLoc),"^",2)=$p(TmpCstArr(CstRLoc),"^",2)+1
	../// 未会诊次数
	..i CstNDate="" s $p(TmpCstArr(CstRLoc),"^",7)=$p($g(TmpCstArr(CstRLoc)),"^",7)+1
	..Q:CstNDate=""
	../// 会诊时间差
	..s DiffTime=(CstNDate-CstRDate)*24+$p($zt((CstNTime-CstRTime),1),":",1)
	..i DiffTime>24 s $p(TmpCstArr(CstRLoc),"^",3)=$p($g(TmpCstArr(CstRLoc)),"^",3)+1 /// 24小时内会诊次数
	..E  s $p(TmpCstArr(CstRLoc),"^",5)=$p($g(TmpCstArr(CstRLoc)),"^",5)+1  /// 超过24小时会诊次数
	..

	/// 计算会诊及时率、会诊率
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s CsTimes=$p(TmpCstArr(CstRLoc),"^",1)      /// 会诊次数
	.s InLimTimes=$p(TmpCstArr(CstRLoc),"^",3)   /// 24小时内会诊次数
	.s UnCsTimes=$p(TmpCstArr(CstRLoc),"^",7)    /// 未会诊次数
	.s $p(TmpCstArr(CstRLoc),"^",5)=$fn(InLimTimes/CsTimes,"",2)_"%"
	.s $p(TmpCstArr(CstRLoc),"^",6)=$fn(UnCsTimes/CsTimes,"",2)_"%"
	.
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     会诊申请指定节点时间
/// InPut:        CstID - 会诊ID, stCode - 状态代码
/// OutPut:       时间
/// D ##Class(web.DHCEMConsultStatistic).GetCstNodeTime("2018",.TmpCstArr)
ClassMethod GetCstNodeTime(CstID As %String, stCode As %String) As %String
{
	n (CstID, stCode)
	Q:stCode="" ""
	Q:$p(^DHCEMCON(CstID),"^",18)="" ""     /// 会诊状态
	s LgID="",LgCstTime=""
	F  s LgID=$o(^DHCEMCONL(0,"Cst",CstID,LgID)) Q:(LgID="")||(LgCstTime'="")  D
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.Q:$p(^DHCEMCONS(StatusID),"^",1)'=stCode
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s LgCstTime=LgDate_"^"_LgTime
	.
	Q LgCstTime
}

/// Creator:      qqa
/// CreateDate:   2019-09-19
/// Descript:     会诊是否超时
/// InPut:        CstID - 会诊ID
/// OutPut:       1:超时完成,2:超时未完成,0:未超时
/// w ##Class(web.DHCEMConsultStatistic).GetCsOutStaus("288||1")
ClassMethod GetCsOutStaus(ItmID) As %String
{
	n (ItmID)
	s Ret=0
	s ID=$p($g(^DHCEMCON(+ItmID,"I",+$p(ItmID,"||",2))),"^",6)  /// 会诊状态
	s:ID="" ID=$p(^DHCEMCON(+ItmID),"^",18)  /// 会诊状态
	s CmpDateInfo=""
	s:'$d(^DHCEMCON(+ItmID,"I")) CmpDateInfo=..GetCstOverCacheTime(+ItmID)
	s:$d(^DHCEMCON(+ItmID,"I")) CmpDateInfo=..GetCstOverCacheTime(ItmID)
	Q:ID="" ""
	s StCode=$p($g(^DHCEMCONS(+ID)),"^",1)
	Q:(StCode<50)||(StCode=51) ""              /// 完成&取消完成
	s CstEmFlag=$p(^DHCEMCON(+ItmID),"^",23)   /// 是否加急
	s CsRDate=$p(^DHCEMCON(+ItmID),"^",3)      /// 申请日期
	s CsRTime=$p(^DHCEMCON(+ItmID),"^",4)      /// 申请时间
	
	s CsEndDate=+$h,CsEndTime=$p($h,",",2)
	i CmpDateInfo'="" d
	.s CsEndDate=$p(CmpDateInfo,"^",1)
	.s CsEndTime=$p(CmpDateInfo,"^",2)
#;	b ;err //hxy 2021-03-03 st
#;	s:((+CsEndDate-CsRDate)>1)&&(CmpDateInfo="") Ret=2
#;	s:((+CsEndDate-CsRDate)>1)&&(CmpDateInfo'="") Ret=1
#;	q:Ret'=0 Ret
#;	
#;	i CstEmFlag="Y" D
#;	.i CsRDate=+CsEndDate D
#;	..s CrTime=7200-(CsEndTime-CsRTime)
#;	.E  D 
#;	..s CrTime=7200-(($p($H,",",2)+(3600*24))-CsRTime) //hxy 2019-07-17
#;	E  D
#;	.i CsRDate=+CsEndDate D
#;	..s CrTime=3600*24-(CsEndTime-CsRTime)
#;	.E  D
#;	..s CrTime=3600*24-(3600*24+CsEndTime-CsRTime) //hxy 2019-07-17
#;	s:(CrTime<0)&&(CmpDateInfo="") Ret=2 //hxy 2020-09-23 Q->S
#;	s:(CrTime<0)&&(CmpDateInfo'="") Ret=1
	s CsPropID = $p(^DHCEMCON(+ItmID),"^",45)   /// 会诊性质
	s Hours=24
	i CstEmFlag="Y" s Hours=2
	s HoursConfig=##Class(web.DHCEMConsultQuery).GetHoursConfig(CsPropID,"OVERTIEMHOUR")
	s:+HoursConfig'=0 Hours=HoursConfig
	;s SSCut= $SYSTEM.SQL.DATEDIFF("ss",CsRDate_","_CsRTime,CsEndDate_","_CsEndTime) //hxy 2021-03-16 st
	s CstRLocID=$p(^DHCEMCON(+ItmID),"^",2) /// 申请科室 
	s HospID=##Class(web.DHCEMCommonUtil).GetHospitalIDByLocID(CstRLocID)
	s OverTimeFilter=##class(web.DHCEMConsultCom).GetEmSysConfig("OVERTIMEFILTER",HospID)
	i (OverTimeFilter=1)!(OverTimeFilter=2) d
	.s SSCut=##Class(web.DHCEMConsultQuery).GetDateDiff(CsRDate,CsRTime,CsEndDate,CsEndTime,OverTimeFilter)
	e  d
	.s SSCut= $SYSTEM.SQL.DATEDIFF("ss",CsRDate_","_CsRTime,CsEndDate_","_CsEndTime) //ed
	q:SSCut<=0 ""
	s CrTime=Hours*3600-SSCut
	s:(CrTime<0)&&(CmpDateInfo="") Ret=2
	s:(CrTime<0)&&(CmpDateInfo'="") Ret=1 //ed
	Q Ret
}

/// Creator:   huaxiaoying
/// CreateDate: 2018-05-03
/// Descript:  取会诊记录的完成时间
/// w ##Class(web.DHCEMConsultStatistic).GetCstOverCacheTime("534||1")
ClassMethod GetCstOverCacheTime(CstItmID As %String) As %String
{
	n (CstItmID)
	s LgID="",tmp="",QuitFlag=0
	F  s LgID=$o(^DHCEMCONL(0,"Cst",CstItmID,LgID),-1) Q:(LgID="")||(tmp'="")||(QuitFlag=1)  D
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.Q:StatusID=""
	.s:$p(^DHCEMCONS(StatusID),"^",1)="51" QuitFlag=1
	.s StatusDesc=$p(^DHCEMCONS(StatusID),"^",2)
	.q:StatusDesc'="完成"
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s tmp=LgDate_"^"_LgTime 
	Q tmp
}

/// =======================================院内平会诊数据统计End======================================

}
