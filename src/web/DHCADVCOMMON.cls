Import sqluser

Class web.DHCADVCOMMON Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 获取病人基本信息
/// Creator:     CongYue
/// CreateDate:  2015-12-21   （2016-01-14  改）
/// Input:  	 病人ID(登记号)
/// Return:  	 病人信息，以字符"^"分割,格式为:病人ID(登记号)^姓名^性别ID^性别^年龄^病案号^出生日期^身份证号  
/// Others: 	 W ##class(web.DHCADVCOMMON).getRepPatInfo("0000000003","124")
ClassMethod getRepPatInfo(patNo, EpisodeID) As %String
{
	N (patNo,EpisodeID)
	I EpisodeID'="" D
	.S medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(EpisodeID,"")  //病案号
	.S papRowid=$p(^PAADM(EpisodeID),"^",1)
	.S admdate=$p(^PAADM(EpisodeID),"^",6) 
	.I +admdate>0 S admdate=##class(web.DHCADVCOMMON).DateLogicalToHtml(admdate) 
	.S admtime=$p(^PAADM(EpisodeID),"^",7) 
	.I +admtime>0 S admtime=$zt(admtime)
	.S patdiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	.S:patdiag'="" patdiag=$p(patdiag,",",1)
	.S curWardDesc=""
	.S curWard=$p(^PAADM(EpisodeID),"^",70)
	.I curWard'="" S curWardDesc=$p(^PAWARD(+curWard),"^",2)
	.S weight="" ,height="", mradm=""
	.;S PatW=##class(web.DHCSTCNTSCOMMON).GetPatWeight(AdmDr) //体重
	.;S PatH=##class(web.DHCSTCNTSCOMMON).GetPatHeight(AdmDr) //身高
	.S AdmLocId=$p(^PAADM(EpisodeID),"^",4) //科室
	.S:AdmLocId'="" AdmLoc=$p(^CTLOC(AdmLocId),"^",2)
	.S:(AdmLoc'="")&(AdmLoc["-") AdmLoc=$p(AdmLoc,"-",2)	
	.S AdmCurrRoom=$p(^PAADM(EpisodeID),"^",69) //房间号
	.S:AdmCurrRoom'="" AdmCurrRoom=$p(^PAROOM(AdmCurrRoom),"^",2)
	.S AdmDoctor=""
	.S AdmDocCodeDR=$p(^PAADM(EpisodeID),"^",9) //医生
	.S:AdmDocCodeDR'="" AdmDoctor=$p(^CTPCP(AdmDocCodeDR,1),"^",2)	
	.S AdmType=""
	.S AdmTypedr=$p(^PAADM(EpisodeID),"^",2) //就诊形式
	.S AdmType=$S(AdmTypedr="I":"住院",AdmTypedr="O":"门诊",AdmTypedr="E":"急诊",AdmTypedr="H":"体检",1:"")
	.S NurLevel=""
	.S NurLeveldr=##class(Nur.CommonInterface.Patient).getCareLevel(EpisodeID)
	.S:NurLeveldr'="" NurLevel=$S(NurLeveldr["特级":"特级",NurLeveldr["一级":"一级",NurLeveldr["二级":"二级",NurLeveldr["三级":"三级",1:"")
	.S AdminDate="",AdminTime=""
	.S AdminDateList=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID) ;入院日期
	.S:AdminDateList["^" AdminDate=$p(AdminDateList,"^",1)
	.S:AdminDate'="" AdminDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdminDate) 
	.S:AdminDateList["^" AdminTime=$p(AdminDateList,"^",2)
	.S:AdminTime'="" AdminTime=$zt(AdminTime,1)
	.S CurBedcode=""
	.S CurBed=$p(^PAADM(EpisodeID),"^",73) 
	.S CurBedcode=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)  //调用护理组接口获取床位号
	.S DischgDate="",DischgTime=""
	.S DischgDateList=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID) ;出院日期
	.S:DischgDateList["^" DischgDate=$p(DischgDateList,"^",1) //病人出院日期
	.S:DischgDate'="" DischgDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(DischgDate) 
	.S:DischgDateList["^" DischgTime=$p(DischgDateList,"^",2) //病人出院时间
	.S:DischgTime'="" DischgTime=$zt(DischgTime,1)
	.I $D(^PAADM(EpisodeID)) d
	..S mradm=$P(^PAADM(EpisodeID),"^",61)
	..I (mradm'="")&($D(^MR(mradm,"PRO",1))) d
	...S weight=$P(^MR(mradm,"PRO",1),"^",27) 
	...S:+weight'=0 weight=weight_"KG"
	...S height=$P(^MR(mradm,"PRO",1),"^",20)
	...S:+height'=0 height=height_"CM"
	..
	E  I patNo'=""  D
	.S papRowid=$o(^PAPERi("PAPMI_PatNo",(patNo),""))
	.S admdate="" 
	.S admtime="" 
	.S patdiag=""
	.S curWardDesc=""
	.S curWard=""
	.S weight="" ,height="", mradm=""
	.S AdmLoc="",AdmCurrRoom="",AdmDoctor="",AdmType="",NurLevel="",AdminDate="",AdminTime="",CurBed="",CurBedcode="",DischgDate="",DischgTime=""
	E  D
	.S param=""
	.S papRowid=""
	I papRowid'=""  D
	.S patNo=$p(^PAPER(papRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	.S patName=$p(^PAPER(papRowid,"ALL"),"^",1) //姓名
	.S sexId=$p(^PAPER(papRowid,"ALL"),"^",7) //性别
	.S patSex=$p(^CT("SEX",sexId),"^",2)
	.S patAge=##Class(web.DHCSTKUTIL).GetAge(papRowid)  //年龄 
	.S:medicalNo="" medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",papRowid) //病案号  
	.S birthday=$p(^PAPER(papRowid,"ALL"),"^",6) //出生日期
	.S:birthday'="" birthday=##class(web.DHCADVCOMMON).DateLogicalToHtml(birthday)
	.S IDcard=$p(^PAPER(papRowid,"ALL"),"^",9) //身份证号
	.S nationdr=$p($g(^PAPER(papRowid,"PER",2)),"^",1)  /// 民族
	.S countrydr=$p(^PAPER(papRowid,"PER",1),"^",8) 	 /// 国家
	.S patTelH=$p(^PAPER(papRowid,"PER",1),"^",11) 	 /// 电话 
	.S address=$g(^PAPER(papRowid,"PER","ADD",1)) 	     /// 家庭住址
	.S param=patNo_"^"_patName_"^"_sexId_"^"_patSex_"^"_patAge_"^"_medicalNo_"^"_birthday_"^"_IDcard_"^"_admdate_"^"_admtime_"^"_patdiag
	.S param=param_"^"_curWardDesc_"^"_curWard_"^"_nationdr_"^"_countrydr_"^"_patTelH_"^"_address_"^"_weight_"^"_height ;18
	.S param=param_"^"_AdmLoc_"^"_AdmCurrRoom_"^"_AdmDoctor_"^"_AdmType_"^"_NurLevel_"^"_AdminDate_"^"_AdminTime_"^"_CurBed_"^"_CurBedcode_"^"_DischgDate_"^"_DischgTime ;29
	E  D
	. S param=""
	Q param
}

/// Description: 获取病人登记号
/// Creator:     CongYue
/// CreateDate:  2016-08-02  
/// Input:  	 病人ID
/// Return:  	 (登记号)
/// Others: 	 W ##class(web.DHCADVCOMMON).getPatNo("1")
ClassMethod getPatNo(patID) As %String
{
	N (patID)
	Q:patID="" ""
	S patNo=$p(^PAPER(patID,"PAT",1),"^",1)	
	Q patNo
}

/// Description: 获取报告类型和初始状态id
/// Creator:     CongYue
/// CreateDate:  2016-01-11 (2016-06-12改)
/// Input:  	 以字符"^"分割,格式为:用户ID^科室ID^安全组ID^不良事件代码
/// Return:  	 工作流类型字段id指向(报告类型)^工作流项目id（状态）  
/// Others:		 w ##class(web.DHCADVCOMMON).GetStatusDr("600^63^126^drug")
ClassMethod GetStatusDr(RepAuditList As %String) As %String
{
	N (RepAuditList)
	
	S UserId=$p(RepAuditList,"^",1)
	S LocId=$p(RepAuditList,"^",2)
	S GroupId=$p(RepAuditList,"^",3)
	S CurRepCode=$p(RepAuditList,"^",4)
	S UserList=$p(RepAuditList,"^",1,3)
	S eventDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(CurRepCode),""))
	S eventparref="",eventsub="" ;2018-08-31
	I eventDr=""  D
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(CurRepCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(CurRepCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") eventDr=eventparref_"||"_eventsub
	
	S Status=""
	S sub=""
	
	//初始化找工作流子项
	S AdrWorkId=""
	;子分类不存在工作流的话就走父类的工作流，字分类存在工作流的话就走自己的工作流
	S:(eventDr["||")&&('$d(^DHCADREVTWF(0,"Event",eventDr))) eventDr=+eventDr  
	S WorkFlowID=""
	F  S WorkFlowID=$o(^DHCADREVTWF(0,"Event",eventDr,WorkFlowID)) Q:WorkFlowID=""  D
	.S:$d(^DHCADREVTWFGR(0,"TypePointer",4,"DHC",1,WorkFlowID)) AdrWorkId=WorkFlowID ;全院标识
	.S:(UserId'="")&&($d(^DHCADREVTWFGR(0,"TypePointer",3,UserId,1,WorkFlowID))) AdrWorkId=WorkFlowID
	.Q:AdrWorkId'=""
	.S:(LocId'="")&&($d(^DHCADREVTWFGR(0,"TypePointer",2,LocId,1,WorkFlowID))) AdrWorkId=WorkFlowID
	.Q:AdrWorkId'=""
	.S:(GroupId'="")&&($d(^DHCADREVTWFGR(0,"TypePointer",1,GroupId,1,WorkFlowID))) AdrWorkId=WorkFlowID
	.Q:AdrWorkId'=""
	.S ParSub=##class(web.DHCADVCOMMONPART).ChkSecuGrpForWorFlow(UserId, LocId,GroupId,WorkFlowID,1)
	.S:ParSub'="" AdrWorkId=WorkFlowID
	.Q:AdrWorkId'=""
    Q:AdrWorkId="" -3 //无授权工作流
  	
    //找工作流子项
    S CurOrderNo=""
    S CurOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,+AdrWorkId,""))
    Q:CurOrderNo="" -4 //无配置子项
    S Sub=""
    S Sub=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,+AdrWorkId,CurOrderNo,""))
    Q:Sub="" -4 //无配置子项
   
    I Sub'="" D
    .S Status=AdrWorkId_"||"_Sub
    .I ..CheckWorkItmGrant(Status,UserList)=0  D //检查子项授权
	..S Status=""
	..S flag=-1
    Q:flag'=0 flag
    
	Q:Status'="" eventDr_"^"_Status
	
	Q ""
}

/// Description: 获取初始状态id
/// Creator:     CongYue
/// CreateDate:  2016-06-12 (改)
/// Input:  	 以字符"^"分割,格式为:主表id,用户ID^科室ID^安全组ID^不良事件代码
/// Return:  	 工作流项目id（状态）  
ClassMethod GetAdrewIRowID(AdrewRowID As %String, RepAuditList As %String) As %String
{
	N (AdrewRowID,RepAuditList)
	S UserId=$p(RepAuditList,"^",1)
	S LocId=$p(RepAuditList,"^",2)
	S GroupId=$p(RepAuditList,"^",3)
	S Status=""
	S AdrewIRowID=""
	;^DHCADREVTWFGR(0,"TypePointer",{ADRWFG_Type},{ADRWFG_Pointer},{ADRWFG_ParRef_Dr},{ADRWFG_Itm_Dr},{ADRWFG_RowID})
	;优先按人取配置
	I UserId'=""  D
	.F  S AdrewIRowID=$o(^DHCADREVTWFGR(0,"TypePointer",3,UserId,2,AdrewIRowID)) Q:AdrewIRowID=""  D
	..Q:AdrewRowID'=+AdrewIRowID
	..S orderno=$o(^DHCADREVTWFI(0,"OrderNo",AdrewRowID,""))
	..q:orderno=""
	..S ChildSub=$o(^DHCADREVTWFI(0,"OrderNo",AdrewRowID,orderno,""))
	..S Status=AdrewRowID_"||"_ChildSub
	..Q:Status=AdrewIRowID
	Q:Status'="" Status
	;不存在按人的定义，则按安全组取
	I GroupId'=""  D
	.F  S AdrewIRowID=$o(^DHCADREVTWFGR(0,"TypePointer",1,GroupId,2,AdrewIRowID)) Q:AdrewIRowID=""  D
	..Q:AdrewRowID'=+AdrewIRowID
	..S orderno=$o(^DHCADREVTWFI(0,"OrderNo",AdrewRowID,""))
	..S ChildSub=$o(^DHCADREVTWFI(0,"OrderNo",AdrewRowID,orderno,""))
	..S Status=AdrewRowID_"||"_ChildSub
	..Q:Status=AdrewIRowID
	Q:Status'="" Status
	;不存在按人和安全组的定义，则按科室取
	I LocId'=""  D
	.F  S AdrewIRowID=$o(^DHCADREVTWFGR(0,"TypePointer",2,LocId,2,AdrewIRowID)) Q:AdrewIRowID=""  D
	..Q:AdrewRowID'=+AdrewIRowID
	..S orderno=$o(^DHCADREVTWFI(0,"OrderNo",AdrewRowID,""))
	..S ChildSub=$o(^DHCADREVTWFI(0,"OrderNo",AdrewRowID,orderno,""))
	..S Status=AdrewRowID_"||"_ChildSub
	..Q:Status=AdrewIRowID
	Q:Status'="" Status
	Q Status
}

/// Description: 获取报告类型和下一个状态id
/// Creator:     CongYue
/// CreateDate:  2015-12-21
/// Input:  	 RepAuditList:以字符"^"分割,格式为:报告ＩＤ^报告类型^人员id^科室id^安全组id
/// Return:  	 param: 报告类型^下一个状态id  
/// Others:		 w ##class(web.DHCADVCOMMON).InsStatusDr("5^96^12714^206^64^20||2^^3")
ClassMethod InsStatusDr(RepAuditList As %String, LgParam = "") As %String
{
	N (RepAuditList,LgParam)
	
	S ID=$p(RepAuditList,"^",1)
	S eventDr=$p(RepAuditList,"^",2)
	S Status=$p(RepAuditList,"^",6)
	S NextLocDR=$p(RepAuditList,"^",7)
	S RepLevel=$p(RepAuditList,"^",8)
	S UserId=$p(LgParam,"^",1)
	S LocId=$p(LgParam,"^",2)
	S GroupId=$p(LgParam,"^",3)
	S HospId=$p(LgParam,"^",4)
	///2021-06-18 cy 多院区业务改造
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdrWorkFlowGrant",HospId)  
	S UserList=UserId_"^"_LocId_"^"_GroupId

	S StatusNext=""
	Q:Status="" eventDr_"^"_StatusNext
	
	S LevelStatus=..GetTowLevel(Status)  //获取此状态第二层级的父元素
	S AdrWorkId=+LevelStatus
	S CurOrderNo=$p(^DHCADREVTWFI(AdrWorkId,"ADREWI",$p(LevelStatus,"||",2)),"^",3)
	S NextOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,AdrWorkId,CurOrderNo))
	
	S WFParref=$o(^DHCADREVTWFI(0,"ItmLevelDr",Status,""))
	I WFParref'=""  D ///存在子元素
	.S StatusNext=..GetNextStatus(Status, NextLocDR, RepLevel,LgParam)  ///   已知报告状态和科室指向获取符合权限的子节点状态  绑定级别优先

	I StatusNext=""  D  /// 不良事件的等级不匹配  则获取 此状态第二层级的父元素 的下一个元素并匹配不良事件的等级 
	.Q:NextOrderNo="" 
	.S WFItmId=""
	.S ChildSub=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,AdrWorkId,NextOrderNo,""))
	.S:ChildSub'="" WFItmId=AdrWorkId_"||"_ChildSub
	.S WFGID="",WFGHospID=""
	.; 2021-08-01 cy 权限增加医院相关索引，唯一获取数据
	.S:NextLocDR'="" WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,2,NextLocDR,2,WFItmId,""))	
	.S:+WFGID'="0" WFGHospID=$p(^DHCADREVTWFGR(WFGID),"^",5)
	.Q:(WFGHospID'="")&&(HospIdGroup'="")&&(WFGHospID'=HospIdGroup)
	.S:((WFGID'="")||(NextLocDR=""))&&(..GetRepLevFlag(WFItmId,RepLevel,HospId)=1) StatusNext=WFItmId

	Q eventDr_"^"_StatusNext
}

/// Description: 获取传入状态第二层级的父元素（父元素为主表数据的节点根元素）
/// Creator:     congyue
/// CreateDate:  2019-07-16
/// Input:  	 报告状态
/// Return:  	 第二层级父元素
/// Others:	W ##class(web.DHCADVCOMMON).GetTowLevel("20||2")
ClassMethod GetTowLevel(Status) As %String
{
	N (Status)
	Q:Status'["||" Status
	S LastItmID=$p(^DHCADREVTWFI(+Status,"ADREWI",$p(Status,"||",2)),"^",6)  /// 上一级ID
	S LastItmLevel=$p(^DHCADREVTWFI(+Status,"ADREWI",$p(Status,"||",2)),"^",5)  /// 层级
	Q:LastItmLevel<3 Status
	Q:LastItmLevel=2 LastItmID
	
	S LastItmID=..GetTowLevel(LastItmID)
	Q LastItmID
}

/// Description: 已知状态获取报告的科室指向
/// Creator:     congyue
/// CreateDate:  2019-07-17
/// Input:  	 状态
/// Return:  	 科室指向
/// Others:	W ##class(web.DHCADVCOMMON).GetNextLoc("113","26||3")
ClassMethod GetNextLoc(RepTypeDr, Status) As %String
{
	N (RepTypeDr,Status)
	S NextLoc=""
	Q:Status'["||" NextLoc
	S RepAuditID=""
	F  S RepAuditID=$o(^DHCMEDREPADT(0,"TypeSta",RepTypeDr,Status,RepAuditID),-1) Q:+RepAuditID=0  D
	.S AuditNextLocDR=$p(^DHCMEDREPADT(RepAuditID),"^",7) //科室指向
	.S AuditReceiveDR=$p(^DHCMEDREPADT(RepAuditID),"^",9) //接收状态
	.S AuditRetStatusDr=$p(^DHCMEDREPADT(RepAuditID),"^",14) //驳回指向
	.S:AuditNextLocDR'="" NextLoc=AuditNextLocDR
	.Q:AuditReceiveDR'=4 //接收状态不是审核则退出
	.Q:NextLoc'=""

	Q NextLoc
}

/// Description: 已知报告状态和科室指向获取符合科室指向与报告等级的子节点
/// Creator:     congyue
/// CreateDate:  2019-07-17
/// Input:  	 状态,科室指向,报告等级
/// Return:  	 下一状态
/// Others:	W ##class(web.DHCADVCOMMON).GetNextStatus("20||2","",3,"12714^206^64")
ClassMethod GetNextStatus(Status, NextLoc, RepLevel = "", UserList) As %String
{
	N (Status,NextLoc,RepLevel,UserList)
	S NextStatusId=""
	Q:Status="" ""
	; 2021-08-01 cy 权限增加医院相关索引，唯一获取数据
	S HospId=$p(UserList,"^",4)
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdrWorkFlowGrant",HospId)  ///2021-06-18 cy 多院区业务改造
	
	S WFParref=$o(^DHCADREVTWFI(0,"ItmLevelDr",Status,""))
	
	Q:WFParref="" ""
	S WFSub="",FistSubStatusId=""
	F  S WFSub=$o(^DHCADREVTWFI(0,"ItmLevelDr",Status,WFParref,WFSub))  Q:+WFSub=0  D
	.Q:NextStatusId'=""
	.S WFItmId=WFParref_"||"_WFSub
	.S ChkFlag=..CheckWorkItmGrant(WFItmId,UserList)
	.S ChkLevFlag=..GetRepLevFlag(WFItmId,RepLevel,HospId)
	.S Orderno=$p(^DHCADREVTWFI(WFParref,"ADREWI",WFSub),"^",3)
	.S NextOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",Status,WFParref,Orderno))
	.S LastOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",Status,WFParref,Orderno),-1)
	.I ((NextOrderNo'="")||(LastOrderNo'=""))&&(NextLoc'="")  D
	..; 2021-08-01 cy 权限增加医院相关索引，唯一获取数据
	..S:($d(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,2,NextLoc,2,WFItmId)))&&(ChkLevFlag=1)&&(ChkFlag=1) NextStatusId=WFItmId
	.E  D
	..S:(ChkLevFlag=1)&&(ChkFlag=1) NextStatusId=WFItmId
	.S:(ChkLevFlag=1)&&(FistSubStatusId="") FistSubStatusId=WFItmId
	.Q:NextStatusId'=""

	S:NextStatusId="" NextStatusId=FistSubStatusId
	Q NextStatusId
}

/// Description: 已知报告状态获取分支最终状态节点
/// Creator:     congyue
/// CreateDate:  2019-07-17
/// Input:  	 状态,科室指向
/// Return:  	 最后叶子节点
/// Others:	W ##class(web.DHCADVCOMMON).GetSubStatus("105","32||2",58)
ClassMethod GetSubStatus(RepTypeDr, Status, ID) As %String
{
	N (RepTypeDr,Status,ID)
	S SubStatus=""
	Q:Status="" ""
	S WFParref=$o(^DHCADREVTWFI(0,"ItmLevelDr",Status,""))
	Q:WFParref="" Status
	S WFSub=""
	F  S WFSub=$o(^DHCADREVTWFI(0,"ItmLevelDr",Status,WFParref,WFSub))  Q:+WFSub=0  D
	.S WFItmId=WFParref_"||"_WFSub
	.S Orderno=$p(^DHCADREVTWFI(WFParref,"ADREWI",WFSub),"^",3)
	.S NextOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",Status,WFParref,Orderno))
	.S LastOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",Status,WFParref,Orderno),-1)
	.S StaInAudit=..ChkStaInAudit(RepTypeDr,WFItmId, ID)
	.S:('$d(^DHCADREVTWFI(0,"ItmLevelDr",WFItmId)))&&(StaInAudit=1) SubStatus=WFItmId
	.S:($d(^DHCADREVTWFI(0,"ItmLevelDr",WFItmId)))&&(StaInAudit=1) SubStatus=..GetSubStatus(RepTypeDr,SubStatus, ID)
	.Q:SubStatus'=""
	

	Q SubStatus
}

/// Description: 判断此状态是否在该报告中存在审批记录
/// Creator:     congyue
/// CreateDate:  2019-07-17
/// Input:  	 报告类型,状态 , 报告ID
/// Return:  	 0 不存在, 1 存在
/// Others:	W ##class(web.DHCADVCOMMON).ChkStaInAudit("105","32||5",58)
ClassMethod ChkStaInAudit(RepTypeDr, Status, ID) As %String
{
	N (RepTypeDr,Status,ID)
	S Flag=0
	Q:(RepTypeDr="")||(Status="")||(ID="") Flag
	S MedAuditID=""
	F  S MedAuditID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,ID,MedAuditID),-1) Q:+MedAuditID=0  D
	.Q:Flag=1
	.S MedStatusDr=$p(^DHCMEDREPADT(MedAuditID),"^",3) //状态
	.Q:MedStatusDr=""
	.S:MedStatusDr=Status Flag=1
	.Q:Flag=1

	Q Flag
}

/// Description: 不良反应报告审批流程
/// Creator:	 CongYue
/// CreateDate:	 2015-12-21
/// Table:		 DHC_MedAdrRepAudit
/// Input:		 matadrID:报告id,  RepAuditList:以字符"^"分割,格式为:报告审核状态^用户ID^科室ID^安全组ID^下一个科室指向^科室建议^接收状态^报告类型
/// Return:		 审批表的id  
/// Others:		 w ##class(web.DHCADVCOMMON).InsRepAudit("12","^600^63^126^^^^用药填报")
ClassMethod InsRepAudit(matadrID As %String, RepAuditList As %String) As %String
{
	N (matadrID,RepAuditList)
	S medadrPointer=matadrID
	S medadrType=$p(RepAuditList,"^",8)  //报告类型
	S medadrStatusDR=$p(RepAuditList,"^",1)  //审核状态
	S medadrAuditUserDR=$p(RepAuditList,"^",2)    //审核人
	S medadrAuditLocDR=$p(RepAuditList,"^",3)    //审核部门
	S medadrAuditDate=+$h    //审核日期
	S medadrAuditTime=$p($h,",",2)   //审核时间
	S medadrNextLocDR=$p(RepAuditList,"^",5)
	S medadrLocAdvice=$p(RepAuditList,"^",6)
	S medadrReceive=$p(RepAuditList,"^",7)
	S medadrRetReason=$p(RepAuditList,"^",9) //驳回原因
	S RevStatus=$p(RepAuditList,"^",10) //驳回指向
	S TimeOutFlag=$p(RepAuditList,"^",11) //护士长审核是否超时
	S RepCancelFlag=$p(RepAuditList,"^",12) //作废标识
	S RecProgress=$p(RepAuditList,"^",13) //调查核实
	&SQL(Insert into DHC_MedAdrRepAudit(MEDADR_Pointer,MEDADR_Type,MEDADR_Status_DR,MEDADR_AuditUser_DR,MEDADR_AuditDate,MEDADR_AuditTime,
		MEDADR_NextLoc_DR,MEDADR_LocAdvice,MEDADR_Receive,MEDADR_RetReason,MEDADR_RetStatus,MEDADR_TimeOutFlag,MEDADR_Invaild,MEDADR_RecProgress,MEDADR_AuditLoc_DR) 
		Values(:medadrPointer,:medadrType,:medadrStatusDR,:medadrAuditUserDR,:medadrAuditDate,:medadrAuditTime,
		:medadrNextLocDR,:medadrLocAdvice,:medadrReceive,:medadrRetReason,:RevStatus,:TimeOutFlag,:RepCancelFlag,:RecProgress,:medadrAuditLocDR))
	Q SQLCODE
}

/// Description: 获取当前病人就诊列表
/// Creator:	 CongYue
/// CreatDate:	 2016-10-28
/// Input:		 登记号
/// Output:		 就诊列表
/// Others:		 w ##class(web.DHCADVCOMMON).GetAdmDs("10","1","0000000121")
ClassMethod GetAdmDs(rows As %String, page As %String, RegNo As %String, Type As %String, LgHospID = "") As %Integer
{
	 N (rows,page,RegNo,Type,LgHospID,%session) ;hxy 2020-06-29
	 ;S page="1"
	 ;S rows="100"
	 S End = page*rows
	 S Start=(page-1)*rows+1
	 S pid=..NewPid()
	 S n=0
	 S papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	 Q:papmi="" ##class(web.DHCADVJSONCOMMON).GetNoJson() //输出空的json串
     
     S admtype=""
     F  S admtype=$o(^PAPERdr(papmi,"ADM",admtype),-1) Q:admtype=""  D
	 .S adm="" 
	 .F  S adm=$o(^PAPERdr(papmi,"ADM",admtype,adm),-1) Q:adm=""  D
	 ..s AdmType=$p($g(^PAADM(adm)),"^",2)
	 ..s AdmTypeDesc=""
	 ..I AdmType="O"  s AdmTypeDesc="门诊"
	 ..I AdmType="E"  s AdmTypeDesc="急诊"
	 ..I AdmType="I"  s AdmTypeDesc="住院"
	 ..I AdmType="H"  s AdmTypeDesc="体检"
	 ..S AdmTypeDesc=##class(websys.Translation).Get("dhcadv.layoutform.csp",AdmTypeDesc)
	 ..q:(AdmType'="O")&(AdmType'="E")&(AdmType'="I")&(AdmType'="H") 
	 ..q:(Type'="")&&(Type'=AdmType)
	 ..S depDesc=""  
	 ..S depcodedr=$p(^PAADM(adm),"^",4) 
	 ..s HospID=$p($g(^CTLOC(+depcodedr)),"^",22) //hxy 2020-02-18 st
	 ..q:(HospID'="")&(LgHospID'="")&(LgHospID'=HospID) //hxy ed
	 ..I depcodedr'="" S depDesc=$p(^CTLOC(depcodedr),"^",2)
	 ..S:depDesc["-" depDesc=$p(depDesc,"-",2)
	 ..S admdate=$p(^PAADM(adm),"^",6) 
	 ..I +admdate>0 S admdate=##class(web.DHCADVCOMMON).DateLogicalToHtml(admdate) 
	 ..S admtime=$p(^PAADM(adm),"^",7) 
	 ..I +admtime>0 S admtime=$zt(admtime)
	 ..S curWardDesc=""
	 ..S curWard=$p(^PAADM(adm),"^",70) 
	 ..I curWard'="" S curWardDesc=$p(^PAWARD(+curWard),"^",2)
	 ..S:curWardDesc["-" curWardDesc=$p(curWardDesc,"-",2)
	 ..S curBedcode=""
	 ..S curBed=$p(^PAADM(adm),"^",73) I curBed'="" D
	 ...S w=+curBed,b=$p(curBed,"||",2) Q:(w="")!(b="")
	 ...S curBedcode=$p(^PAWARD(w,"BED",b),"^",1)
	 ..S curBedcode=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(adm)	 
	 ..S doctor="" ;S doctor=$p(^PAADM(adm),"^",9)
	 ..;I doctor'=""  S doctor=$p(^CTPCP(doctor,1),"^",2 )
	 ..S n=n+1
	 ..S depDesc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",depDesc)  ;2020-06-28 cy
	 ..S curWardDesc=##Class(web.DHCADVCOMMON).GetTransDesc("User.PACWard","WARDDesc","",curWardDesc)  ;2020-06-28 cy
	 ..S data=$g(adm)_"^"_$g(depDesc)_"^"_$g(admdate)_"^"_$g(admtime)_"^"_$g(curWardDesc)_"^"_$g(curBedcode)_"^"_$g(doctor)_"^"_+$g(curWard)_"^"_RegNo_"^"_AdmTypeDesc
	 ..S ^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid,n)=data
	 
     Q:n=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(n) //输出空的json串
    
     S maxrow=n
     S count=0
     W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(n) //输出json前缀串
     S h=""
     F  S h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid,h),-1) Q:h=""  D
     .S mdata=^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid,h)
     .S count = count+1
	 .S Title="Adm^AdmLoc^AdmDate^AdmTime^CurrWard^CurrBed^CurrDoc^CurrWardID^RegNo^AdmTypeDesc"
	 .Q:(count<Start)||(count>End)
	 .I count=Start D
	 ..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	 .E  D
	 ..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	 W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	 K ^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid)
     Q ""
}

/// Description: 获取报告当前状态
/// Creator:     LiangQiang
/// CreateDate:  2016-2-16
/// Input:  	 报告id,报告类型代码
/// Return:  	 报告当前状态id  27  med
/// Others:	W ##class(web.DHCADVCOMMON).GetRepCurStatusDr("86","advWallLeakage")	 
ClassMethod GetRepCurStatusDr(RepRowId, RepTypeCode) As %String
{
	N (RepRowId,RepTypeCode)
	Q:RepRowId="" ""
	S AdrEvtDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),""))
	s AdrEvtparref="",AdrEvtsub="" ;2018-08-29
	i AdrEvtDr=""  d
	.S AdrEvtparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:AdrEvtparref'="" AdrEvtsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),AdrEvtparref,""))
	.S:(AdrEvtparref'="")&&(AdrEvtsub'="") AdrEvtDr=AdrEvtparref_"||"_AdrEvtsub
	Q:AdrEvtDr="" ""
	S AdrAdtDr=$o(^DHCMEDREPADT(0,"Pointer",AdrEvtDr,RepRowId,""),-1) 
	Q:AdrAdtDr="" ""
	S CurStatusDr=$p(^DHCMEDREPADT(AdrAdtDr),"^",3)
	Q CurStatusDr
}

/// Description: 检查工作流/工作流项目（状态）是否有授权
/// Creator:     CongYue
/// CreateDate:  2021-04-28
/// Input:  	 AdrWorkItmId：工作流id/工作流项目id ,用户信息：人员id^科室id^安全组id^医院id，    WorkFlag :1 工作流 / 2 工作流项目
/// Return:  	 1通过 0不通过
/// Others:	W ##class(web.DHCADVCOMMON).CheckWorkItmGrant("10||5","10211^151^23")
ClassMethod CheckWorkItmGrant(AdrWorkItmId, UserList, WorkFlag = 2) As %String
{
	N (AdrWorkItmId,UserList,WorkFlag)
	
	S UserId=$p(UserList,"^",1)
	S LocId=$p(UserList,"^",2)
	S GroupId=$p(UserList,"^",3)
	S HospId=$p(UserList,"^",4)
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdrWorkFlowGrant",HospId)  ///2021-06-18 cy 多院区业务改造
	S chk=0
	Q:HospIdGroup="" chk
	
	; 2021-08-01 cy 权限增加医院相关索引，唯一获取数据
        S WFGID="",WFGHospID="" 
	//全院
	S WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,4,"DHC",WorkFlag,AdrWorkItmId,"")) 
	S:+WFGID'="0" chk=1
	Q:chk=1 chk
	//安全组
	S:+GroupId'=0 WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,1,GroupId,WorkFlag,AdrWorkItmId,"")) 
	S:+WFGID'="0" chk=1
	Q:chk=1 chk
	//科室
	S:+LocId'=0 WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,2,LocId,WorkFlag,AdrWorkItmId,"")) 
	S:+WFGID'="0" chk=1
	Q:chk=1 chk
	//人员
	S:+UserId'=0 WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,3,UserId,WorkFlag,AdrWorkItmId,"")) 
	S:+WFGID'="0" chk=1
	Q:chk=1 chk
	//大科
	I (+UserId'=0)&&(+LocId'=0)  D
	.S Sub=##class(web.DHCADVCOMMONPART).ChkSecuGrpForWorFlow(UserId, LocId,GroupId,AdrWorkItmId,WorkFlag,HospId)
	.S:(Sub'="") chk=1
	Q:chk=1 chk
	Q chk
}

/// Description: 获取报告下一个状态
/// Creator:     LiangQiang
/// CreateDate:  2016-2-20
/// Input:  	 报告id ^ 报告类型id ^ 登录人员id ^ 科室id ^ 安全组id ^ 压疮类型
/// Return:  	 报告下一个状态id 12^87||2^10277^336^69^^^   12^87||2^10211^151^23^^^
/// Others:	 w ##class(web.DHCADVCOMMON).GetRepNextStatusDr("25^87||3","","12177^114^23^2")
ClassMethod GetRepNextStatusDr(RepAuditList, ScanFlag = "", LgParam = "") As %String
{
	
	N (RepAuditList,ScanFlag,LgParam)
	S RepRowId=$p(RepAuditList,"^",1)
	S EvtTypeId=$p(RepAuditList,"^",2)
	S NextLocDR=$p(RepAuditList,"^",7)
	S RepLevel=$p(RepAuditList,"^",8)
	S UserId=$p(LgParam,"^",1)
	S LocId=$p(LgParam,"^",2)
	S GroupId=$p(LgParam,"^",3)
	S HospId=$p(LgParam,"^",4)
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdrWorkFlowGrant",HospId)  ///2021-06-18 cy 多院区业务改造
	S UserList=UserId_"^"_LocId_"^"_GroupId

	S flag=0
	S NextStatusId="",RepTypeCode=""
	S:(EvtTypeId'="")&&(EvtTypeId'["||") RepTypeCode=$p(^DHCMEDADREVT(EvtTypeId),"^",1)
	S:(EvtTypeId'="")&&(EvtTypeId["||") RepTypeCode=$p(^DHCMEDADREVTI(+EvtTypeId,"MADREVI",$p(EvtTypeId,"||",2)),"^",1)
	
	
	// 获取报告当前状态
	S CurStatusId=..GetRepCurStatusDr(RepRowId,RepTypeCode)
	
	// 当前状态不为空 获取报告下一状态
	I CurStatusId'="" D
	.// 根据获取当前状态的二层级元素、不良事件等级 获取二层级元素下一状态
	.S LevelStatus=..GetTowLevel(CurStatusId)  // 获取此状态第二层级的父元素
	.S AdrWorkId=+LevelStatus
	.S CurOrderNo=$p(^DHCADREVTWFI(AdrWorkId,"ADREWI",$p(LevelStatus,"||",2)),"^",3)
	.S NextOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,AdrWorkId,CurOrderNo))
	.I $D(^DHCADREVTWFI(0,"ItmLevelDr",CurStatusId))  D
	..// 根据 报告状态、指向科室、不良事件的等级、当前登录信息 获取符合权限的子状态
	..S NextStatusId=..GetNextStatus(CurStatusId, NextLocDR, RepLevel,LgParam)
	..//sufan 2020-07-14 增加取不到对应等级的状态
	..I NextStatusId=""  D  /// 不良事件的等级不匹配  则获取 此状态第二层级的父元素 的下一个元素并匹配不良事件的等级 
	...s:NextOrderNo="" flag=-2
	...S WFItmId=""
	...S ChildSub=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,AdrWorkId,NextOrderNo,""))
	...S:ChildSub'="" WFItmId=AdrWorkId_"||"_ChildSub
	...D ChkLoc
	.E  D
	..S:NextOrderNo="" flag=-2
	..Q:NextOrderNo=""
	..S WFItmId=""
	..S ChildSub=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,AdrWorkId,NextOrderNo,""))
	..S:ChildSub'="" WFItmId=AdrWorkId_"||"_ChildSub
	..D ChkLoc
 	.// 检查下一状态是否符合权限
 	.I NextStatusId'="" D
	..I ..CheckWorkItmGrant(NextStatusId,LgParam)=0  D //检查子项授权
	...S NextStatusId=""
	...S flag=-1 //无权限
	.E  D
	..S flag=-2 //已是最后一个权限
	
	Q:NextStatusId'="" NextStatusId
	Q:flag'=0 flag
	
	// 获取报告初始状态
	S NextStatusId=..GetRepFistStatusID(EvtTypeId,LgParam,ScanFlag)
	Q NextStatusId
	
ChkLoc
	S WFGID="",WFGHospID=""
	; 2021-08-01 cy 权限增加医院相关索引，唯一获取数据
	S:NextLocDR'="" WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,2,NextLocDR,2,WFItmId,""))
	S:((WFGID'="")||(NextLocDR=""))&&(..GetRepLevFlag(WFItmId,RepLevel,HospId)=1) NextStatusId=WFItmId
}

/// Description: 获取报告初始状态id
/// Creator:     CongYue
/// CreateDate:  2020-06-21 (改)
/// Input:  	 报告类型id 登录人信息UserList 人员id^科室id^安全组id
/// Return:  	 报告初始状态  
ClassMethod GetRepFistStatusID(EvtTypeId As %String, UserList As %String, ScanFlag As %String) As %String
{
	N (EvtTypeId,UserList,ScanFlag)
	S UserId=$p(UserList,"^",1)
	S LocId=$p(UserList,"^",2)
	S GroupId=$p(UserList,"^",3)
	S HospId=$p(UserList,"^",4)
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdrWorkFlowGrant",HospId)  ///2021-06-18 cy 多院区业务改造
	S flag=0
	//初始化找工作流子项
	S AdrWorkId=""
	;子分类不存在工作流的话就走父类的工作流，字分类存在工作流的话就走自己的工作流
	S:(EvtTypeId["||")&&('$d(^DHCADREVTWF(0,"Event",EvtTypeId))) EvtTypeId=+EvtTypeId  
	S WorkFlowID=""
	F  S WorkFlowID=$o(^DHCADREVTWF(0,"Event",EvtTypeId,WorkFlowID)) Q:WorkFlowID=""  D
	.S WFGID="",WFGHospID=""
	.; 全院 2021-08-01 cy 权限增加医院相关索引，唯一获取数据
	.S WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,4,"DHC",1,WorkFlowID,"")) 
	.S:+WFGID'="0" AdrWorkId=WorkFlowID
	.Q:AdrWorkId'=""
	.; 人员
	.S:(+UserId'=0) WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,3,UserId,1,WorkFlowID,"")) 
	.S:+WFGID'="0" AdrWorkId=WorkFlowID
	.Q:AdrWorkId'=""
	.; 科室
	.S:(+LocId'=0) WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,2,LocId,1,WorkFlowID,"")) 
	.S:+WFGID'="0" AdrWorkId=WorkFlowID
	.Q:AdrWorkId'=""
	.; 安全组
	.S:(+GroupId'=0) WFGID=$o(^DHCADREVTWFGR(0,"HospTypePointer",HospIdGroup,1,GroupId,1,WorkFlowID,"")) 
	.S:+WFGID'="0" AdrWorkId=WorkFlowID
	.Q:AdrWorkId'=""
	.; 大科
	.S ParSub=##class(web.DHCADVCOMMONPART).ChkSecuGrpForWorFlow(UserId, LocId,GroupId,WorkFlowID,1,HospId)
	.S:ParSub'="" AdrWorkId=WorkFlowID
	.Q:AdrWorkId'=""
    Q:AdrWorkId="" -3 //无授权工作流
  	
    //找工作流子项
    S CurOrderNo=""
    S CurOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,+AdrWorkId,""))
    Q:CurOrderNo="" -4 //无配置子项
    S Sub=""
    S Sub=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,+AdrWorkId,CurOrderNo,""))
    Q:Sub="" -4 //无配置子项
    
    I Sub'="" D
    .S NextStatusId=AdrWorkId_"||"_Sub
    .I ..CheckWorkItmGrant(NextStatusId,UserList,2)=0  D //检查子项授权
	..S NextStatusId=""
	..S flag=-1
	
    Q:(ScanFlag'="")&&(flag'=0)&&(Sub'="") AdrWorkId_"||"_Sub			//sufan 2020-03-24 ScanFlag这个参数 只在首页工作流查看时传，原因是这里判断了当前状态是否有授权，有查看工作流权限的不一定有授权，会报错
    
    Q:flag'=0 flag
	Q NextStatusId
}

/// Description:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCADV("DHCADVBLDREPORT"))
}

/// Descript:格式化Json数据串
ClassMethod getJsonData(Title As %String, DataList As %String, Deli As %String = "^") As %String
{
	N (Title,DataList,Deli)
	S del=""""
	S jsonStr=""
	S HLen=$L(Title,Deli)  //列
	S DLen=$L(DataList,Deli) //值
	F i=1:1:HLen  D
	.S Name=$p(Title,Deli,i)
	.S Value=$p(DataList,Deli,i)
	.S Value=$tr(Value,$c(10))   ;替换换行符
	.S Value=$tr(Value,$c(13))	;替换回车符
	.S Value=$Replace(Value,"\","\\")
	.S Value=$Replace(Value,"'","\'")
	.I i=1 D
	..S jsonStr="{"_del_Name_del_":"_del_Value_del
	.E  i i=3 D
	..S jsonStr=jsonStr_","_del_Name_del_":"_Value
	.E  D
	..S jsonStr=jsonStr_","_del_Name_del_":"_del_Value_del
	S jsonStr=jsonStr_"}"
	S jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// Descript:返回Json串起始符
ClassMethod getJsonStartSign(Count) As %String
{
	N (Count)
	S del=""""
	Q "{"_del_"results"_del_":"_Count_","_del_"rows"_del_":["
}

/// Descript:返回Json串结束符
ClassMethod getJsonEndSign() As %String
{
	Q "]}"
}

/// Descript:返回Json空串符
ClassMethod getJsonEmptySign(Count) As %String
{
	N (Count)
	S del=""""
	Q "{"_del_"results"_del_":"_Count_","_del_"rows"_del_":[]}"
}

/// Descript:获取病人医嘱信息
/// W ##class(web.DHCADVCOMMON).GetAdmOrdList("20","1","179")
ClassMethod GetAdmOrdList(rows As %String, page As %String, EpisodeID As %String)
{
	N (rows,page,EpisodeID)
	
	Q:EpisodeID="" ##class(web.DHCADVJSONCOMMON).GetNoJson() //输出空的json串 
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	S pid=..NewPid()
	
	S Num=0
    S chl=0 
    F  S chl=$o(^OEORD(ord,"I",chl)) Q:(chl="")||(chl=0)  D
	.S orditm=ord_"||"_chl
	.Q:'$d(^OEORD(ord,"I",chl,1))
	.S priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .Q:priDr=0 
    .S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码              
    .;Q:priorty["OM" //自备药
    .S priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
    .S StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	.//Q:(OeFlag'="V")&(OeFlag'="E")
	.S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12) //滚医嘱来源信息 OEORI_FillerNo
    .Q:(FillerNo'="")&(FillerNo'=orditm_"!!"_orditm)&(OeFlag'="D")  //长嘱非首日和截止日期的记录过滤
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  //医嘱名称
	.s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcItmId) ;判断某医嘱项的结构模式 Y-一对多，N-一对一 
	.;S incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S incidesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2)  ; 取医嘱项名称，因为医嘱项和库存项存在一对多关系
	.S dosage="",dosuomID="",doseuom="",freqdr="",freq="",instrudr="",instru="",durId=""
	.I $D(^OEORD(ord,"I",chl,2))  D
	..S dosage=$p(^OEORD(ord,"I",chl,2),"^",1) //剂量
	..S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	..S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	..S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    ..S freq=$p($g(^PHCFR(freqdr)),"^",3) //频率
    ..S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    ..S instru=$p($g(^PHCIN(instrudr)),"^",2) //用法
    ..s durId=+$p(^OEORD(ord,"I",chl,2),"^",6)
	..S duration=$p($g(^PHCDU(durId)),"^",3) //用药疗程
    
    .S dspid=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
    .S qty=$p(^DHCOEDISQTY(dspid),"^",2) //药品数量
    .S qtyuomdr=$p(^DHCOEDISQTY(dspid),"^",6) //药品数量单位指向
    .S qtyuom=$p(^CT("UOM",qtyuomdr),"^",2)
    .S qty=qty_qtyuom
	.;S qty=$p(^OEORD(ord,"I",chl,1),"^",18) //药品数量
    .S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) Q:phcdf=""
    .S genenicdr=+$p($g(^PHCD(+phcdf,4)),"^",1)
    .S genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .s formdr="",form=""
    .s:$d(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)) formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
    .s:formdr'="" form=$p(^PHCF(formdr),"^",2) //剂型
    .S manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    .S:manf["-" manf=$p(manf,"-",2)
    .S apprdocu=""
    .S itminfo=$o(^DHCITMINFO(0,"INCI",inci,""))
    .I itminfo'="" S apprdocu=$p(^DHCITMINFO(itminfo),"^",10) //批准文号
	.S spec=""
	.S add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	.I add'=""  D
	..S spec=$p($G(^DHCITMINFO(add)),"^",27) //规格
	.S:CheckCHNFlag=1 spec=""
	.S statusID=""
    .S statusID=$o(^DHCOEDISQTY(0,"OEORI",orditm,statusID))
    .Q:statusID=""   
    .S status=$p(^DHCOEDISQTY(statusID),"^",7) //发药状态
    .Q:((priorty["S")||(priorty["NORM")||(priorty["OUT")||(priorty["临时医嘱"))&&(status'="C")  //如果状态为C为已发药
    .;S spec="["_$p(^INCI(inci,3),"^",9)_"]" 
    .S EndDate=$p(^OEORD(ord,"I",chl,3),"^",34)     //停止日期
    .
	.S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(EndDate)
	.I FillerNo'="" D
	..S orditm=$p(FillerNo,"!!",1)
	.S StartDate=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",9)  //开始日期
	.S:StartDate'="" StartDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(StartDate)
	.S moeori=..GetMainOeori(orditm) //主医嘱
    .S index=StartDate_"||"_moeori_"||"_orditm
    .I $d(^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index)) D
	..S $p(^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index),"^",21)=EndDate
	..S $p(^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index),"^",22)=OeFlag
	.E  D
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index)=orditm_"^"_phcdf_"^"_incidesc_"^"_dosage_doseuom_"^"_dosuomID_"^"_freqdr_"^"_freq_"^"_instrudr_"^"_instru_"^"_durId_"^"_duration_"^"_genenicdr_"^"_genenic_"^"_formdr_"^"_form_"^"_manfdr_"^"_manf_"^"_apprdocu_"^"_spec_"^"_StartDate_"^"_EndDate_"^"_OeFlag_"^"_priorty_"^"_qty_"^"_inci

	Q:Num=0 ##class(web.DHCADVJSONCOMMON).GetNoJson() //输出空的json串
	
	S Title="orditm^phcdf^incidesc^dosage^dosuomID^freqdr^freq^instrudr^instru^durId^duration^genenicdr^genenic^formdr^form^manfdr^manf^apprdocu^spec^startdate^enddate^OeFlag^priorty^qty^inci"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	
	K ^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid)
	
	Q ""
}

/// Description: 病区
/// Creator:     congyue
/// CreateDate:  2016-01-18
/// Table: 		 PAC_Ward
/// Output:  	 所有病区描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVCOMMON).SelwardDesc()
ClassMethod SelwardDesc() As %String
{
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT WARD_RowID as WardDr, WARD_Desc as WardDesc FROM PAC_Ward"
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S WardDr = result.Data("WardDr")
		S WardDesc = result.Data("WardDesc")
		S tmp=WardDr_"^"_WardDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	}
	w "]"
}

/// 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// Descript: 年龄 
/// w ##class(web.DHCADVCOMMON).GetAge("419")
ClassMethod GetAge(papmidr As %String) As %String
{
	//根据患者rowid取出年龄
	n (papmidr)
	q:papmidr="" ""
	s argBirthday=$p($g(^PAPER(papmidr,"ALL")),"^",6)
	q:(+argBirthday=0) ""
	q:(+papmidr=0) ""
	s argAdmDate=$p($h,",",1)
	s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
	s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
	i (tmpAge'="")&&($l(tmpAge,"|")'<14) d
	.s ageYears=$p(tmpAge,"|",12)
	.s ageMonths=$p(tmpAge,"|",13)
	.s ageDays=$p(tmpAge,"|",14)
	.
	.i ageYears>3 d
	..s age=ageYears_"岁"
	.
	.i (ageYears>0)&(ageYears'>3) d
	..s age=ageYears_"岁"
	..i ageMonths'=0 s age=age_ageMonths_"月"
	.
	.i (ageYears=0)&(ageMonths'=0) d
	..s age=ageMonths_"月"
	..i ageDays'=0 s age=age_ageDays_"天"
	.
	.i (ageYears=0)&(ageMonths=0) d
	..s age=ageDays_"天"
	e  d
	.s age=""
	q age
}

// Description: 获取不良事件报告评估权限

/// Creator:     wangxuejian
/// CreateDate:  2016-10-19
/// Table: 		 DHC_AdvQuerySec
/// Input:         报告id, RepTypeCode:报告类型代码 LgParam：人员id^科室id^安全组id^医院id
/// Output:  	 输出评估权限的字段 
/// Others:	w ##class(web.DHCADVCOMMON).GetAssessAuthority("1","med","982^100^4^2")	
ClassMethod GetAssessAuthority(RepTypeCode As %String, LgParam = "") As %String
{
	N (RepTypeCode,LgParam)
	S ShareFlag=##class(web.DHCADVCOMMON).GetOperSecFlag(RepTypeCode,LgParam,5)
	Q ShareFlag
}

/// Description: 公共 (日期 转为 M中的日期数字)
/// Creator:     congyue
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       日期  2017-2-24
/// Output:  	 M中日期数字 64338
/// Others:	w ##class(web.DHCADVCOMMON).DateHtmlToLogical("2017-2-24")	
ClassMethod DateHtmlToLogical(date As %String) As %String
{
	N (date)
	q:date=""""
	s CommonDate=""
	s CommonDate=##class(websys.Conversions).DateHtmlToLogical(date) ;$zdh(date,3) ;
	q CommonDate
}

/// Description: 公共 (M中的日期数字 转为 日期)
/// Creator:     congyue
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       M中日期数字 64338
/// Output:  	 日期  2017-2-24
/// Others:	
ClassMethod DateLogicalToHtml(date As %String) As %String
{
	N (date)
	q:date=""""
	s CommonDate=""
	s CommonDate=##class(websys.Conversions).DateLogicalToHtml(date) ;$zd(date,3) ;
	q CommonDate
}

/// Description: js 获取配置日期显示类型
/// Creator:     congyue
/// CreateDate:  2017-03-06
/// Table: 		 
/// Input:       
/// Output:  	 4:"DMY" DD/MM/YYYY 3:"YMD" YYYY-MM-DD  1:"MDY" MM/DD/YYYY
/// Others:	w ##class(web.DHCADVCOMMON).getDateType()	
ClassMethod getDateType() As %String
{
	S DateFormat = ##class(websys.Conversions).DateFormat()
	w "<SCRIPT Language='JavaScript'> var DateFormat='"_DateFormat_"';</SCRIPT>"
}

/// Description: 不良反应报告获取指向科室（下拉框）
/// Creator:     CongYue
/// CreateDate:  2017-05-24
/// Input:  	 adrRepID :报告id
/// Return: 	 状态配置的科室
/// Others:		 w ##class(web.DHCADVCOMMON).QueryAuditLocList("5","advOccExpose","20||3")
ClassMethod QueryAuditLocList(RepID, RepTypeCode, CurStatusDR, HospId = "") As %String
{
	N (RepID,RepTypeCode,CurStatusDR,HospId,%session)
	Q:RepID="" "[]"
	Q:RepTypeCode="" "[]"
	S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	S eventDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),""))
	s eventparref="",eventsub=""

	i eventDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") eventDr=eventparref_"||"_eventsub
	S Parref="",Sub="",OrderNo="",OrderNoNext=""
	//获取初始状态
	S:(eventDr["||")&&('$d(^DHCADREVTWF(0,"Event",eventDr))) eventDr=+eventDr 
	S:eventDr'="" Parref=$o(^DHCADREVTWF(0,"Event",eventDr,""))
	S OrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",Parref,Parref,""))
	S:(Parref'="")&&(OrderNo'="") Sub=$o(^DHCADREVTWFI(0,"LevOrderNo",Parref,Parref,OrderNo,""))
	S NextCurStatusDR=""
	
	S pid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid)
	
	I CurStatusDR="" D
	.S NextCurStatusDR=Parref_"||"_Sub
	.I '$d(^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid,NextCurStatusDR)) D
	..S ^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid,NextCurStatusDR)=NextCurStatusDR
	E  D
	.S WFParref=$o(^DHCADREVTWFI(0,"ItmLevelDr",CurStatusDR,""))
	.I (WFParref="")  D  ///不存在子元素
	..S LevelStatus=..GetTowLevel(CurStatusDR)  //获取此状态第二层级的父元素
	..S AdrWorkId=+LevelStatus
	..S CurOrderNo=$p(^DHCADREVTWFI(AdrWorkId,"ADREWI",$p(LevelStatus,"||",2)),"^",3)
	..S NextOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,AdrWorkId,CurOrderNo))
	..I NextOrderNo=""  S flag=-2 //已是最后一个权限
	..Q:NextOrderNo=""
	..S ChildSub=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,AdrWorkId,NextOrderNo,""))
	..S:ChildSub'="" NextCurStatusDR=AdrWorkId_"||"_ChildSub
	..I '$d(^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid,NextCurStatusDR)) D
	...S ^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid,NextCurStatusDR)=NextCurStatusDR
	.E  D
	..S WFSub=""
	..F  S WFSub=$o(^DHCADREVTWFI(0,"ItmLevelDr",CurStatusDR,WFParref,WFSub))  Q:+WFSub=0  D
	...S Active=$p(^DHCADREVTWFI(WFParref,"ADREWI",WFSub),"^",4) //是否可用
	...Q:Active="N"
	...S WFItmId=WFParref_"||"_WFSub
	...I '$d(^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid,WFItmId)) D
	....S ^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid,WFItmId)=WFItmId
	Q:'$d(^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid)) "[]"
	W "["
	s h=0
	s NextID=""
	f  s NextID=$o(^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid,NextID)) q:+NextID=0  d
	.s AdrwfgDr=""  
	.f  s AdrwfgDr=$o(^DHCADREVTWFGR(0,"ItmDr",NextID,AdrwfgDr)) q:+AdrwfgDr=0  d
	..s Type=$p(^DHCADREVTWFGR(AdrwfgDr),"^",3) //类型 1 安全组，2 科室，3 人员
	..s wfgHospID=$p(^DHCADREVTWFGR(AdrwfgDr),"^",5)
	..q:Type'="2"
	..q:##class(web.DHCADVCOMMON).GetRepLevFlag(NextID,RepLevelDr,HospId)=0
	..s locdr=$p(^DHCADREVTWFGR(AdrwfgDr),"^",4)
	..Q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("CT_Loc",locdr,HospId,"")'="Y"
	..s code=$p(^CTLOC(locdr),"^",1)
	..s desc=$p(^CTLOC(locdr),"^",2)
	..s desc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",desc)  ;2020-06-28 cy
	..s rowid=locdr
	..s data=rowid_"^"_desc
	..s h=h+1
	..I h=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",data)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",data)
	w "]"
	k ^TMP("DHCADV","web.DHCADVCOMMON","QueryAuditLocList",pid)
	q ""
}

/// Description: 性别
/// Creator:     congyue
/// CreateDate:  2017-10-23
/// Table: 		 CT_Sex
/// Output:  	 性别（下拉框显示）  
/// Others:		 d ##class(web.DHCADVCOMMON).SelSex()
ClassMethod SelSex() As %String
{
	n (%session)
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT CTSEX_RowId as SexDr, CTSEX_Desc as SexDesc FROM CT_Sex"
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S SexDr = result.Data("SexDr")
		S SexDesc = result.Data("SexDesc")
	  	S SexDesc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTSex","CTSEXDesc","",SexDesc)  ;2020-06-28 cy
		S tmp=SexDesc_"^"_SexDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Description: 获取报告类型和上一个状态id
/// Creator:     yangyongtao
/// CreateDate:  2016-09-18
/// Input:  	 RepAuditList:以字符"^"分割,格式为:报告ＩＤ^报告类型^人员id^科室id^安全组id
/// Return:  	 param: 报告类型^上一个状态id  
/// Others:		 w ##class(web.DHCADVCOMMON).InsStatusLast("5^83^12751^101^25")
ClassMethod InsStatusLast(RepAuditList As %String) As %String
{
	N (RepAuditList)
	
	S ID=$p(RepAuditList,"^",1)
	S eventDr=$p(RepAuditList,"^",2)
	S UserId=$p(RepAuditList,"^",3)
	S LocId=$p(RepAuditList,"^",4)
	S GroupId=$p(RepAuditList,"^",5)
	S Status=$p(RepAuditList,"^",6)
	S NextLocDR=$p(RepAuditList,"^",7)
	Q:Status="" ""
	S StatusLast=""

	I Status'="" D
	.S LevelDr=$p(^DHCADREVTWFI(+Status,"ADREWI",$p(Status,"||",2)),"^",6)
	.I (LevelDr["||")  D  // 当前状态父元素包含||,则父元素为上一状态
	..S StatusLast=LevelDr
	.E  D
	..S LevelStatus=..GetTowLevel(Status)
	..S AdrWorkId=+LevelStatus
	..S CurOrderNo=$p(^DHCADREVTWFI(AdrWorkId,"ADREWI",$p(LevelStatus,"||",2)),"^",3)
	..S LastOrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,AdrWorkId,CurOrderNo),-1)
	..Q:LastOrderNo=""
	..S ChildSub=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrWorkId,AdrWorkId,LastOrderNo,""))
	..Q:ChildSub=""
	..S WFItmId=AdrWorkId_"||"_ChildSub
	..S WFParref=$o(^DHCADREVTWFI(0,"ItmLevelDr",WFItmId,""))
	..I (WFParref'="")  D  ///存在子元素
	...S StatusLast=..GetSubStatus(eventDr, WFItmId,ID)
	...S:StatusLast="" StatusLast=WFItmId
	..E  D
	...S StatusLast=WFItmId
	Q eventDr_"^"_StatusLast
}

/// Description: 获取报告上一个状态
/// Creator:     yangyongtao
/// CreateDate:  2016-09-18
/// Input:  	 报告填报人员数据
/// Return:  	 报告上一个状态id
/// Others:	 w ##class(web.DHCADVCOMMON).GetRepLastStatusDr("56^1^600^63^126")
ClassMethod GetRepLastStatusDr(RepAuditList) As %String
{
	
	N (RepAuditList)
	S RepRowId=$p(RepAuditList,"^",1)
	S EvtTypeId=$p(RepAuditList,"^",2)
	S UserId=$p(RepAuditList,"^",3)
	S LocId=$p(RepAuditList,"^",4)
	S GroupId=$p(RepAuditList,"^",5)
	S UserList=$p(RepAuditList,"^",3)_"^"_$p(RepAuditList,"^",4)_"^"_$p(RepAuditList,"^",5)
	
	S LastStatusId="",RepTypeCode=""
	S:(EvtTypeId'="")&&(EvtTypeId'["||") RepTypeCode=$p(^DHCMEDADREVT(EvtTypeId),"^",1)
	S:(EvtTypeId'="")&&(EvtTypeId["||") RepTypeCode=$p(^DHCMEDADREVTI(+EvtTypeId,"MADREVI",$p(EvtTypeId,"||",2)),"^",1)
	S CurStatusId=..GetRepCurStatusDr(RepRowId,RepTypeCode)
	s MedLastStatusId=$o(^DHCMEDREPADT(0,"TypeSta",EvtTypeId,CurStatusId),-1)
	S:+MedLastStatusId=+CurStatusId LastStatusId=MedLastStatusId
	Q LastStatusId
}

/// Description: 用病案号获取当前病人就诊列表
/// Creator:	 yangyongtao
/// CreatDate:	 2016-08-03
/// Input:		 病案号
/// Output:		 就诊列表
/// Table:		 PA_PatMas
/// Others:		 w ##class(web.DHCADVCOMMON).GetAdmList("10","1","0000000001")
ClassMethod GetAdmList(rows As %String, page As %String, MedicareNo As %String, Type As %String, LgHospID = "") As %Integer
{
   
	 N (rows,page,MedicareNo,Type,LgHospID,%session) ;hxy 2020-06-29
	 S End = page*rows
	 S Start=(page-1)*rows+1
	 S pid=..NewPid()
	 S n=0
	 S papmi=$o(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(MedicareNo),"")) ;^PAPERi("Medicare1",$$ALPHAUP({PAPMI_Medicare}),{PAPMI_RowId}) 
	 Q:papmi="" ##class(web.DHCADVJSONCOMMON).GetNoJson() //输出空的json串
	 S RegNo=$p(^PAPER(papmi,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
     S admtype=""
     F  S admtype=$o(^PAPERdr(papmi,"ADM",admtype),-1) Q:admtype=""  D
	 .S adm="" 
	 .F  S adm=$o(^PAPERdr(papmi,"ADM",admtype,adm),-1) Q:adm=""  D
	 ..q:adm=""
	 ..s AdmType=$p($g(^PAADM(adm)),"^",2)
	 ..s AdmTypeDesc=""
	 ..I AdmType="O"  s AdmTypeDesc="门诊"
	 ..I AdmType="E"  s AdmTypeDesc="急诊"
	 ..I AdmType="I"  s AdmTypeDesc="住院"
	 ..I AdmType="H"  s AdmTypeDesc="体检"
	 ..S AdmTypeDesc=##class(websys.Translation).Get("dhcadv.layoutform.csp",AdmTypeDesc)
	 ..q:(AdmType'="O")&(AdmType'="E")&(AdmType'="I")&(AdmType'="H") 
	 ..q:(Type'="")&&(Type'=AdmType)
	 ..S depDesc=""  
	 ..S depcodedr=$p(^PAADM(adm),"^",4) 
	 ..s HospID=$p($g(^CTLOC(+depcodedr)),"^",22) //hxy 2020-02-26 st
	 ..q:(HospID'="")&(LgHospID'="")&(LgHospID'=HospID) //hxy ed
	 ..I depcodedr'="" S depDesc=$p(^CTLOC(depcodedr),"^",2)
	 ..S:(depDesc'="")&(depDesc["-") depDesc=$p(depDesc,"-",2)
	 ..S admdate=$p(^PAADM(adm),"^",6) 
	 ..I +admdate>0 S admdate=##class(web.DHCADVCOMMON).DateLogicalToHtml(admdate) 
	 ..S admtime=$p(^PAADM(adm),"^",7) 
	 ..I +admtime>0 S admtime=$zt(admtime)
	 ..S curWardDesc=""
	 ..S curWard=$p(^PAADM(adm),"^",70) 
	 ..I curWard'="" S curWardDesc=$p(^PAWARD(+curWard),"^",2)
	 ..I curWardDesc'="" S curWardDesc=$p(curWardDesc,"-",2)
	 ..S curBedcode=""
	 ..S curBed=$p(^PAADM(adm),"^",73) I curBed'="" D
	 ...S w=+curBed,b=$p(curBed,"||",2) Q:(w="")!(b="")
	 ...S curBedcode=$p(^PAWARD(w,"BED",b),"^",1)
	 ..S curBedcode=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(adm)	 
	 ..S doctor=""  ;S doctor=$p(^PAADM(adm),"^",9)
	 ..;I doctor'=""  S doctor=$p(^CTPCP(doctor,1),"^",2 )
	 ..S n=n+1
	 ..S depDesc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",depDesc)  ;2020-06-28 cy
	 ..S curWardDesc=##Class(web.DHCADVCOMMON).GetTransDesc("User.PACWard","WARDDesc","",curWardDesc)  ;2020-06-28 cy	 
	 ..S data=$g(adm)_"^"_$g(depDesc)_"^"_$g(admdate)_"^"_$g(admtime)_"^"_$g(curWardDesc)_"^"_$g(curBedcode)_"^"_$g(doctor)_"^"_+$g(curWard)_"^"_RegNo_"^"_AdmTypeDesc
	 ..S ^TMP("DHCADV","web.DHCADVCOMMON","GetAdmList",pid,n)=data
	 
     Q:n=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(n) //输出空的json串
    
     S maxrow=n
     S count=0
     W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(n) //输出json前缀串
     S h=""
     F  S h=$o(^TMP("DHCADV","web.DHCADVCOMMON","GetAdmList",pid,h),-1) Q:h=""  D
     .S mdata=^TMP("DHCADV","web.DHCADVCOMMON","GetAdmList",pid,h)
     .S count = count+1
	 .S Title="Adm^AdmLoc^AdmDate^AdmTime^CurrWard^CurrBed^CurrDoc^CurrWardID^RegNo^AdmTypeDesc"
	 .Q:(count<Start)||(count>End)
	 .I count=Start D
	 ..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	 .E  D
	 ..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	 W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	 K ^TMP("DHCADV","web.DHCADVCOMMON","GetAdmList",pid)
     Q ""
}

/// Description: 获取报告状态第一操作人
/// Creator:     CongYue
/// CreateDate:  2018-02-07
/// Table:		 DHC_MedAdrRepAudit
/// Input:  	 报告id ，报告类型id，报告状态id
/// Return: 	 状态第一操作人
/// Others:		 w ##class(web.DHCADVCOMMON).GetStaFisUserID("46","80","10||1")
ClassMethod GetStaFisUserID(RepDr As %String, RepTypeDr As %String, RepStatusDr As %String) As %String
{
	N (RepDr,RepTypeDr,RepStatusDr)
	S MedadrUserID="",MedadrID=""
	F  S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepDr,MedadrID)) Q:MedadrID=""  D
	.Q:+MedadrID=0
	.Q:MedadrUserID'=""
	.S MedadrStatusDr=$p(^DHCMEDREPADT(MedadrID),"^",3)
	.Q:MedadrStatusDr'=RepStatusDr
	.S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	.Q:MedadrUserID'=""
	Q MedadrUserID
}

/// Description: 判断登录人是否有分享权限
/// Creator:     ylp
/// CreateDate:  2017-12-11
/// Table: 		 DHC_AdvQuerySec
/// Input:         报告id,   人员id^科室id^安全组id^报告类型id
/// Output:  	 输出分享权限的字段 
/// Others:	w ##class(web.DHCADVCOMMON).GetShareAuthority("982^102^29^med")	
ClassMethod GetShareAuthority(params As %String) As %String
{
	N (params)
	S repTypeCode=$p(params,"^",4)   //报告类型代码
	q:repTypeCode=""""
	s repTypeID=""
	s repTypeID=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(repTypeCode),"")) //获取报告类型id
	s repTypeparref="",repTypesub="" ;2018-08-29
	i repTypeID=""  d
	.S repTypeparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(repTypeCode),"")) //子表类别指向
	.S:repTypeparref'="" repTypesub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(repTypeCode),repTypeparref,""))
	.S:(repTypeparref'="")&&(repTypesub'="") repTypeID=repTypeparref_"||"_repTypesub
	;子分类没有维护权限时走父分类的权限，维护权限时走子分类的权限
	s:'$d(^DHCADVQUS(0,"RepType",repTypeID)) repTypeID=+repTypeID
	s userID=$p(params,"^",1)
	s advqsRowID="" ,assessFlag=""
	s advqsRowID=$o(^DHCADVQUS(0,"RepType",repTypeID,3,userID,""))
	s:advqsRowID'="" assessFlag=$p(^DHCADVQUS(advqsRowID),"^",7)
	q:assessFlag="Y" "Y"
	S locID=$p(params,"^",2) 
	s advqsRowID=$o(^DHCADVQUS(0,"RepType",repTypeID,2,locID,"")) 
	s:advqsRowID'="" assessFlag=$p(^DHCADVQUS(advqsRowID),"^",7)
	q:assessFlag="Y" "Y"
	S groupID=$p(params,"^",3) 
	s advqsRowID=$o(^DHCADVQUS(0,"RepType",repTypeID,1,groupID,""))
	s:advqsRowID'="" assessFlag=$p(^DHCADVQUS(advqsRowID),"^",7)
	q:assessFlag="Y" "Y"
	q "N"
}

/// Description: 判断登录人是否有重点关注权限
/// Creator:     ylp
/// CreateDate:  2017-12-11
/// Table: 		 DHC_AdvQuerySec
/// Input:         报告id,   人员id^科室id^安全组id^报告类型id
/// Output:  	 输出重点关注权限的字段 
/// Others:	w ##class(web.DHCADVCOMMON).GetFocusAuthority("982^102^29^med")	
ClassMethod GetFocusAuthority(params As %String) As %String
{
	N (params)
	S repTypeCode=$p(params,"^",4)   //报告类型代码
	q:repTypeCode=""""
	s repTypeID=""
	s repTypeID=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(repTypeCode),"")) //获取报告类型id
	s repTypeparref="",repTypesub="" ;2018-08-29
	i repTypeID=""  d
	.S repTypeparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(repTypeCode),"")) //子表类别指向
	.S:repTypeparref'="" repTypesub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(repTypeCode),repTypeparref,""))
	.S:(repTypeparref'="")&&(repTypesub'="") repTypeID=repTypeparref_"||"_repTypesub
	;子分类没有维护权限时走父分类的权限，维护权限时走子分类的权限
	s:'$d(^DHCADVQUS(0,"RepType",repTypeID)) repTypeID=+repTypeID
	s userID=$p(params,"^",1)
	s advqsRowID="" ,assessFlag=""
	s advqsRowID=$o(^DHCADVQUS(0,"RepType",repTypeID,3,userID,""))
	s:advqsRowID'="" assessFlag=$p(^DHCADVQUS(advqsRowID),"^",8)
	q:assessFlag="Y" "Y"
	S locID=$p(params,"^",2) 
	s advqsRowID=$o(^DHCADVQUS(0,"RepType",repTypeID,2,locID,"")) 
	s:advqsRowID'="" assessFlag=$p(^DHCADVQUS(advqsRowID),"^",8)
	q:assessFlag="Y" "Y"
	S groupID=$p(params,"^",3) 
	s advqsRowID=$o(^DHCADVQUS(0,"RepType",repTypeID,1,groupID,""))
	s:advqsRowID'="" assessFlag=$p(^DHCADVQUS(advqsRowID),"^",8)
	q:assessFlag="Y" "Y"
	q "N"
}

/// sufan  2018-01-10
/// w ##class(web.DHCADVCOMMON).JugeDate("2018-01-10 16:18:39")
ClassMethod JugeDate(chdate)
{
	n (chdate)
	s date=$p(chdate," ",1)		///界面传过来的为日期时间的取值
	s hour=$p(chdate," ",2)
	s DateFormat = ##class(websys.Conversions).DateFormat() //日期格式
	q:DateFormat="3" chdate
	i (DateFormat="1")&&(date'="")  d
	.s date=$zdh(date,1)
    i DateFormat="4"  d 
	.s date=$zdh(date,4)
	s date=$zd(date,3)
	q date_" "_hour
}

/// Creator:     qunianpeng
/// CreateDate:  2018-1-11
/// Table: 		 
/// Input:       人员id^科室id^安全组id^报告类型id
/// Output:  	 输出分享和关注权限的字段 
/// Others:	w ##class(web.DHCADVCOMMON)GetFoucsAndShare("982^102^29^med")	
ClassMethod GetFoucsAndShare(params As %String) As %String
{
	n (params)
	
	q ##class(web.DHCADVCOMMON).GetShareAuthority(params)_"^"_ ##class(web.DHCADVCOMMON).GetFocusAuthority(params)
}

/// Creator:     qunianpeng
/// CreateDate:  2018-1-11
/// Table: 		 
/// Input:       报告id^^报告类型id^人员id^科室id^安全组id
/// Output:  	 -1 不能转抄 0 能 
/// Others:	w ##class(web.DHCADVCOMMON).CheckTranPermiss("970^80^4636^197^23")	
ClassMethod CheckTranPermiss(params As %String, LgParam = "") As %String
{
 	n (params,LgParam)
 	s ret="0"
	s statusNextID=##class(web.DHCADVCOMMON).GetRepNextStatusDr(params,"",LgParam)
	i statusNextID'["||" s ret="-1"
	e  s ret="0"

	q ret
}

/// Description: 获取病人基本信息
/// Creator:     CongYue
/// CreateDate:  2015-12-21   （2016-01-14  改）
/// Input:  	 病人ID(登记号)
/// Return:  	 病人信息，以字符"^"分割,格式为:病人ID(登记号)^姓名^性别ID^性别^年龄^病案号^出生日期^身份证号  
/// Others: 	 W ##class(web.DHCADVCOMMON).GetPatInfoJson("","1")
ClassMethod GetPatInfoJson(PatNo, EpisodeID) As %String
{
	N (PatNo,EpisodeID,%session)
	S PapRowid="",PatName="",SexId="",PatSex="",PatAge="",MedicalNo="",Birthday="",IDCard="",Nationdr="",Countrydr="",PatTelH="",Address="",Weight="" ,Height="", Mradm=""
	S PatDiag="",AdmDate="",AdmTime="",CurWardDesc="",CurWard="",AdmLoc="",AdmCurrRoom="",AdmDoctor="",AdmType="",NurLevel="",AdminDate="",AdminTime="",CurBed="",CurBedcode="",DischgDate="",DischgTime=""	
	S InTimes="",Nation="",PatBill="",PatAdmADLScore="",OccurADLScore=""
	I EpisodeID'="" D
	.S MedicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(EpisodeID,"")  //病案号
	.S PapRowid=$p(^PAADM(EpisodeID),"^",1)
	.S AdmDate=$p(^PAADM(EpisodeID),"^",6) 
	.I +AdmDate>0 S AdmDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdmDate) 
	.S AdmTime=$p(^PAADM(EpisodeID),"^",7) 
	.I +AdmTime>0 S AdmTime=$zt(AdmTime)
	.S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	.S:PatDiag'="" PatDiag=$p(PatDiag,",",1)
	.S:PatDiag["." PatDiag=$p(PatDiag,".",2)
	.S PatDiag=##class(web.DHCADVCOMMON).GetTransDesc("User.MRCICDDx","MRCIDDesc","",PatDiag)
	.S CurWardDesc=""
	.S CurWard=$p(^PAADM(EpisodeID),"^",70)
	.I CurWard'="" S CurWardDesc=$p(^PAWARD(+CurWard),"^",2)
	.S AdmLocId=$p(^PAADM(EpisodeID),"^",4) //科室
	.S:AdmLocId'="" AdmLoc=$p(^CTLOC(AdmLocId),"^",2)
	.S:(AdmLoc'="")&(AdmLoc["-") AdmLoc=$p(AdmLoc,"-",2)	
	.S AdmCurrRoom=$p(^PAADM(EpisodeID),"^",69) //房间号
	.S:AdmCurrRoom'="" AdmCurrRoom=$p(^PAROOM(AdmCurrRoom),"^",2)
	.S AdmDoctor=""
	.S AdmDocCodeDR=$p(^PAADM(EpisodeID),"^",9) //医生
	.S:AdmDocCodeDR'="" AdmDoctor=$p(^CTPCP(AdmDocCodeDR,1),"^",2)	
	.S AdmDoctor=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",AdmDoctor)  ;2020-06-28 cy
	.S AdmType=""
	.S AdmTypedr=$p(^PAADM(EpisodeID),"^",2) //就诊形式
	.S AdmType=$S(AdmTypedr="I":"住院",AdmTypedr="O":"门诊",AdmTypedr="E":"急诊",AdmTypedr="H":"体检",1:"")
	.S NurLevel=""
	.S NurLeveldr=##class(Nur.CommonInterface.Patient).getCareLevel(EpisodeID)
	.S:NurLeveldr'="" NurLevel=$S(NurLeveldr["特级":"特级",NurLeveldr["一级":"一级",NurLeveldr["二级":"二级",NurLeveldr["三级":"三级",1:"")
	.S AdminDate="",AdminTime=""
	.S AdminDateList=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID) ;入院日期
	.S:AdminDateList["^" AdminDate=$p(AdminDateList,"^",1)
	.S:AdminDate'="" AdminDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdminDate) 
	.S:AdminDateList["^" AdminTime=$p(AdminDateList,"^",2)
	.S:AdminTime'="" AdminTime=$zt(AdminTime,1)
	.S CurBedcode=""
	.S CurBed=$p(^PAADM(EpisodeID),"^",73) 
	.;I CurBed'="" D  
	.;.S w=+CurBed,b=$p(CurBed,"||",2) Q:(w="")!(b="")
	.;.S CurBedcode=$p(^PAWARD(w,"BED",b),"^",1) //床位号
	.S CurBedcode=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)  //调用护理组接口获取床位号
	.S DischgDate="",DischgTime=""
	.S DischgDateList=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID) ;出院日期
	.S:DischgDateList["^" DischgDate=$p(DischgDateList,"^",1) //病人出院日期
	.S:DischgDate'="" DischgDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(DischgDate) 
	.S:DischgDateList["^" DischgTime=$p(DischgDateList,"^",2) //病人出院时间
	.S:DischgTime'="" DischgTime=$zt(DischgTime,1)
	.S InTimes=##class(EMRservice.DAL.GetPaAdmDetail).InTimes(EpisodeID,2) //住院次数
	.;S PatBill="" /// 费别指针(医疗类别)
	.S BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)
	.S:BillTypeID'="" PatBill=$P($g(^PAC("ADMREA",BillTypeID)),"^",2)   ;$p($g(^CT("SS",BillTypeID)),"^",2)
	.S PatBill=##class(web.DHCADVCOMMON).GetTransDesc("User.PACAdmReason","READesc","",PatBill)
	.S Weight="" ,Height="", Mradm=""
	.S Mradm=$P(^PAADM(EpisodeID),"^",61)
	.I (Mradm'="")&($D(^MR(Mradm,"PRO",1))) D
	..S Weight=$P(^MR(Mradm,"PRO",1),"^",27) 
	..S:+Weight'=0 Weight=Weight_"KG"
	..S Height=$P(^MR(Mradm,"PRO",1),"^",20)
	..S:+Height'=0 Height=Height_"CM"
	.S ScoreList=##Class(web.DHCADVCOMMON).GetNurMarkInfo(EpisodeID) // 护理得分数据串
	.S PatAdmADLScore=$p(ScoreList,"$$",1)
	.S OccurADLScore=$p(ScoreList,"$$",2)
	E  I PatNo'=""  D
	.S PapRowid=$o(^PAPERi("PAPMI_PatNo",(PatNo),""))
	I PapRowid'=""  D
	.S PatNo=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	.S PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	.S SexId=$p(^PAPER(PapRowid,"ALL"),"^",7) //性别
	.S PatSex=$p(^CT("SEX",SexId),"^",2)
	.S PatAge=##Class(web.DHCSTKUTIL).GetAge(PapRowid)  //年龄    
	.S:MedicalNo="" MedicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",PapRowid)  //病案号
	.S Birthday=$p(^PAPER(PapRowid,"ALL"),"^",6) //出生日期
	.S:Birthday'="" Birthday=##class(web.DHCADVCOMMON).DateLogicalToHtml(Birthday)
	.S IDCard=$p(^PAPER(PapRowid,"ALL"),"^",9) //身份证号
	.S Nationdr=$p($g(^PAPER(PapRowid,"PER",2)),"^",1)  /// 民族
	.S:Nationdr'="" Nation=$p($g(^CT("NAT",Nationdr)),"^",2)  /// 民族
	.S Countrydr=$p(^PAPER(PapRowid,"PER",1),"^",8) 	 /// 国家
	.S PatTelH=$p(^PAPER(PapRowid,"PER",1),"^",11) 	 /// 电话 
	.S Address=$g(^PAPER(PapRowid,"PER","ADD",1)) 	     /// 家庭住址
	.S PatOccupation="",OccupationID=""  ///病人职业
	.S:$d(^PAPER(PapRowid,"PER",2)) OccupationID=$P(^PAPER(PapRowid,"PER",2),"^",6)           
	.S:OccupationID'="" PatOccupation=$p($g(^CT("OCC",OccupationID)),"^",2)
	.S PatOccupation=##class(web.DHCADVCOMMON).GetTransDesc("User.CTOccupation","CTOCCDesc","",PatOccupation)
	S PatSex=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)  ;2020-06-28 cy
	S AdmLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",AdmLoc)  ;2020-06-28 cy
	S Nation=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTNation","CTNATDesc","",Nation)  ;2020-06-28 cy
	S tmpObj={}
	S tmpObj.PatNo=PatNo
	S tmpObj.PatName=PatName
	S tmpObj.SexId=SexId
	S tmpObj.PatSex=PatSex
	S tmpObj.PatAge=PatAge
	S tmpObj.MedicalNo=MedicalNo
	S tmpObj.Birthday=Birthday
	S tmpObj.IDCard=IDCard
	S tmpObj.Nationdr=Nationdr
	S tmpObj.Countrydr=Countrydr
	S tmpObj.PatTelH=PatTelH
	S tmpObj.Address=Address
	S tmpObj.Weight=Weight
	S tmpObj.Height=Height
	S tmpObj.PatDiag=PatDiag
	S tmpObj.AdmDate=AdmDate
	S tmpObj.AdmTime=AdmTime
	S tmpObj.CurWardDesc=CurWardDesc
	S tmpObj.CurWard=CurWard
	S tmpObj.AdmLoc=AdmLoc
	S tmpObj.AdmCurrRoom=AdmCurrRoom
	S tmpObj.AdmDoctor=AdmDoctor
	S tmpObj.AdmType=AdmType
	S tmpObj.NurLevel=NurLevel
	S tmpObj.AdminDate=AdminDate
	S tmpObj.AdminTime=AdminTime
	S tmpObj.CurBed=CurBed
	S tmpObj.CurBedcode=CurBedcode
	S tmpObj.DischgDate=DischgDate
	S tmpObj.DischgTime=DischgTime
	S tmpObj.PatBill=PatBill
	S tmpObj.PatOccupation=PatOccupation
	S tmpObj.Nation=Nation
	S tmpObj.InTimes=InTimes
	S tmpObj.PatAdmADLScore=PatAdmADLScore
	S tmpObj.OccurADLScore=OccurADLScore
	W tmpObj.%ToJSON()
	Q ""
}

/// Description: 发送短信通知接口    作废，需要时写新的接口
/// Creator:   	 liyarong
/// CreateDate:  2018-05-25
/// xiugai       2018-06-01  yangyongtao
/// Input:  	 报告表id
/// Others:		 w ##class(web.DHCADVCOMMON).SendMessge("47","med")
ClassMethod SendMessge(RepID As %String, RepTypeCode As %String) As %String
{
	N (RepID,RepTypeCode)
	Q:RepID="" "-1"
	Q:RepTypeCode="" "-2"
	S NextStatusId="",CTPCPDesc=""
	I RepTypeCode="drug" D                              //   药品
	.S RepTypeDr=$p(^DHCADVDRUGREP(RepID),"^",49)       //   报告类型
	.S RepCode=$p(^DHCADVDRUGREP(RepID),"^",1)          //   报告编码
	.S AdmNo=$p(^DHCADVDRUGREP(RepID),"^",7)            //   就诊ID
	.S PatNo=$p(^DHCADVDRUGREP(RepID),"^",8)            //   病人登记号
	.S RepUserCode=$p(^DHCADVDRUGREP(RepID),"^",41)     //   填报人
	.S RepUserDr=""
	.S RepUser=""
	.I RepUserCode'="" S RepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	.I RepUserDr'="" S RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	.S RepDeptDr=""
	.S RepDept=""
	.S RepDeptCode=$p(^DHCADVDRUGREP(RepID),"^",42)      //   科室
	.I RepDeptCode'="" S RepDeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(RepDeptCode),""))
	.I RepDeptDr'="" S RepDept=$p(^CTLOC(RepDeptDr),"^",2)
	
	.S AdrAdtDr=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	.Q:AdrAdtDr="" 
	.S CurStatusId=$p(^DHCMEDREPADT(AdrAdtDr),"^",3)
	.I CurStatusId'="" D
	..S AdrWorkId=+CurStatusId 
	..S CurOrderNo=$p(^DHCADREVTWFI(AdrWorkId,"ADREWI",$p(CurStatusId,"||",2)),"^",3)
	..S NextOrderNo=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,CurOrderNo))
    ..q:NextOrderNo="""-4"
    ..S ChildSub=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,NextOrderNo,""))
	..I ChildSub'="" D
	...S NextStatusId=AdrWorkId_"||"_ChildSub
	
	I (RepTypeCode="med")||(RepTypeCode="bldevent") D   //  医疗
	.S RepTypeDr=$p(^DHCMEDADRR(RepID),"^",30)          //  报告类型
	.S RepCode=$p(^DHCMEDADRR(RepID),"^",1)             //  报告编码
	.S AdmNo=$p(^DHCMEDADRR(RepID),"^",33)              //  就诊ID
	.S PatNo=$p(^DHCMEDADRR(RepID),"^",23)              //  病人登记号
	.S RepUserCode=$p(^DHCMEDADRR(RepID),"^",19)        //  填报人
	.S RepUserDr=""
	.S RepUser=""
	.I RepUserCode'="" S epUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	.I RepUserDr'="" S RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	.S RepDeptDr=""
	.S RepDept=""
	.S RepDeptCode=$p(^DHCMEDADRR(RepID),"^",20)        //   科室
	.I RepDeptCode'="" S RepDeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(RepDeptCode),""))
	.I RepDeptDr'="" S RepDept=$p(^CTLOC(RepDeptDr),"^",2)
	
	.S AdrAdtDr=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1) 
	.Q:AdrAdtDr=""
	.S CurStatusId=$p(^DHCMEDREPADT(AdrAdtDr),"^",3)
	.I CurStatusId'="" D
	..S AdrWorkId=+CurStatusId
	..S CurOrderNo=$p(^DHCADREVTWFI(AdrWorkId,"ADREWI",$p(CurStatusId,"||",2)),"^",3)
	..S NextOrderNo=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,CurOrderNo))
    ..q:NextOrderNo="""-4"
    ..S ChildSub=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,NextOrderNo,""))
	..S NextStatusId=""
	..I ChildSub'="" D
	...S NextStatusId=AdrWorkId_"||"_ChildSub
	
	I RepTypeCode="blood" D                              //   输血
	.S RepTypeDr=$p(^DHCBLDADVRPT(ID),"^",47)            //   报告类型
	.S RepTypeDr=$p(^DHCBLDADVRPT(RepID),"^",3)          //   报告编码
	.S AdmNo=$p(^DHCBLDADVRPT(RepID),"^",7)              //   就诊ID
	.S PatNo=$p(^DHCBLDADVRPT(RepID),"^",9)              //   病人登记号
	.S RepUserCode=$p(^DHCBLDADVRPT(RepID),"^",2)        //   填报人
	.S RepUserDr=""
	.S RepUser=""
	.I RepUserCode'="" S RepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	.I RepUserDr'="" S RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	.S RepDeptDr=""
	.S RepDept=""
	.S RepDeptCode=$p(^DHCBLDADVRPT(RepID),"^",1)        //   科室
	.I RepDeptCode'="" S RepDeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(RepDeptCode),""))
	.I RepDeptDr'="" S RepDept=$p(^CTLOC(RepDeptDr),"^",2)
	
	.S AdrAdtDr=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1) 
	.Q:AdrAdtDr=""
	.S CurStatusId=$p(^DHCMEDREPADT(AdrAdtDr),"^",3)
	.I CurStatusId'="" D
	..S AdrWorkId=+CurStatusId
	..S CurOrderNo=$p(^DHCADREVTWFI(AdrWorkId,"ADREWI",$p(CurStatusId,"||",2)),"^",3)
	..S NextOrderNo=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,CurOrderNo))
    ..q:NextOrderNo="""-4"
    ..S ChildSub=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,NextOrderNo,""))
	..I ChildSub'="" D
	...S NextStatusId=AdrWorkId_"||"_ChildSub
	
	I RepTypeCode="material" D                           //   器械
	.S RepTypeDr=$p(^DHCMATADRR(RepID),"^",46)           //   报告类型
	.S RepCode=$p(^DHCMATADRR(RepID),"^",1)              //   报告编码
	.S AdmNo=$p(^DHCMATADRR(RepID),"^",48)               //   就诊ID
	.S PatNo=$p(^DHCMATADRR(RepID),"^",5)                //   病人登记号
	.S RepUserCode=$p(^DHCMATADRR(RepID),"^",35)         //   填报人
	.S RepUserDr=""
	.S RepUser=""
	.I RepUserCode'="" S RepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	.I RepUserDr'="" S RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	.S RepDeptDr=""
	.S RepDept=""
	.S RepDeptCode=$p(^DHCMATADRR(RepID),"^",36)          //  科室
	.I RepDeptCode'="" S RepDeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(RepDeptCode),""))
	.I RepDeptDr'="" S RepDept=$p(^CTLOC(RepDeptDr),"^",2)
	
	.S AdrAdtDr=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1) 
	.Q:AdrAdtDr=""
	.S CurStatusId=$p(^DHCMEDREPADT(AdrAdtDr),"^",3)
	.I CurStatusId'="" D
	..S AdrWorkId=+CurStatusId
	..S CurOrderNo=$p(^DHCADREVTWFI(AdrWorkId,"ADREWI",$p(CurStatusId,"||",2)),"^",3)
	..S NextOrderNo=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,CurOrderNo))
    ..q:NextOrderNo="""-4"
    ..S ChildSub=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,NextOrderNo,""))
	..S NextStatusId=""
	..I ChildSub'="" D
	...S NextStatusId=AdrWorkId_"||"_ChildSub
	
	I RepTypeCode="drugerr" D                            //   用药差错
	.S RepTypeDr=$p(^DHCADVMEDSAR(ID),"^",20)            //   报告类型
	.S RepCode=$p(^DHCADVMEDSAR(RepID),"^",19)           //   报告编码
	.S AdmNo=$p(^DHCADVMEDSAR(RepID),"^",21)             //   就诊ID
	.S PatNo=$p(^DHCADVMEDSAR(RepID),"^",8)              //   病人登记号
	.S RepUserCode=$p(^DHCADVMEDSAR(RepID),"^",15)       //   填报人
	.S RepUserDr=""
	.S RepUser=""
	.I RepUserCode'="" S RepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	.I RepUserDr'="" S RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	.S RepDeptDr=""
	.S RepDept=""
	.S RepDeptCode=$p(^DHCADVMEDSAR(RepID),"^",1)        //   科室
	.I RepDeptCode'="" S RepDeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(RepDeptCode),""))
	.I RepDeptDr'="" S RepDept=$p(^CTLOC(RepDeptDr),"^",2)
	
	.S AdrAdtDr=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	.Q:AdrAdtDr="" 
	.S CurStatusId=$p(^DHCMEDREPADT(AdrAdtDr),"^",3)
	.I CurStatusId'="" D
	..S AdrWorkId=+CurStatusId
	..S CurOrderNo=$p(^DHCADREVTWFI(AdrWorkId,"ADREWI",$p(CurStatusId,"||",2)),"^",3)
	..S NextOrderNo=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,CurOrderNo))
    ..q:NextOrderNo="""-4"
    ..S ChildSub=$o(^DHCADREVTWFI(0,"OrderNo",+CurStatusId,NextOrderNo,""))
	..S NextStatusId=""
	..I ChildSub'="" D
	...S NextStatusId=AdrWorkId_"||"_ChildSub
		
	Q:NextStatusId="" 
	S RepTypeCode=$S(RepTypeCode="med":"医疗不良反应",RepTypeCode="bldevent":"输血不良事件",RepTypeCode="blood":"输血不良反应",RepTypeCode="material":"器械不良反应",RepTypeCode="drug":"药物不良反应",RepTypeCode="drugerr":"用药差错不良反应",1:"")
	s MsgContent="请审核一份来自"_RepDept_" ，"_RepUser_"发送编号为:"_RepCode_",类型为:"_RepTypeCode_"的报告"

	S AdrwfgID=""
	F  S AdrwfgID=$o(^DHCADREVTWFGR(0,"ItmDr",NextStatusId,AdrwfgID)) Q:AdrwfgID=""  D
	.S ParRefDr=$p(^DHCADREVTWFGR(AdrwfgID),"^",1) //
	.S ItmDR=$p(^DHCADREVTWFGR(AdrwfgID),"^",2) //
	.S Type=$p(^DHCADREVTWFGR(AdrwfgID),"^",3) //类型
	.S Pointer=$p(^DHCADREVTWFGR(AdrwfgID),"^",4) //指针
	.//S TypeName=$S(Type="1":"安全组",Type="2":"科室",Type="3":"人员",Type="5":"大科室安全组",1:"") 
    .//S PointerName = ##class(web.DHCADVEVTWORKFLOW).FindPointer(Pointer,Type)
	.I Type="1" D
	..S quitflag=0
	..S UserRowId=""
	..F  S UserRowId=$o(^SSU("SSUSR",0,"Group",Pointer,UserRowId)) q:UserRowId=""  d
	...s SSUserCareProvDR=$p(^SSU("SSUSR",UserRowId),"^",14)
	...s SSUserLocDR=$p(^SSU("SSUSR",UserRowId),"^",4)
	...Q:(SSUserLocDR'="")&(SSUserLocDR'=RepDeptDr)
	...s CTPcpMobile=$p(^CTPCP(SSUserCareProvDR,3),"^",6)
	...i CTPcpMobile'="" d
	....S MsgData=+$H_""_$P($H,",",2)_"^"_CTPcpMobile_"^"_MsgContent
	....d ##class(LYGFY.LYGFYMSG).SendMSG(MsgData) S quitflag=1
	..Q:quitflag=1   
	..S SSRowId="" 
	..F  S SSRowId=$o(^SSU("SSUSR",SSRowId)) q:SSRowId=""  d    
	...s OtherChildSub=""
	...F  s OtherChildSub=$o(^SSU("SSUSR",SSRowId,"OTHLL",OtherChildSub)) q:OtherChildSub=""  d
	....s OTUserGroupDR=$p(^SSU("SSUSR",SSRowId,"OTHLL",OtherChildSub),"^",2)
	....q:OTUserGroupDR'=Pointer
	....s SSUserCareProvDR=$p(^SSU("SSUSR",SSRowId),"^",14)
	....s SSUserLocDR=$p(^SSU("SSUSR",SSRowId),"^",4)
	....Q:(SSUserLocDR'="")&(SSUserLocDR'=RepDeptDr)
	....s CTPcpMobile=$p(^CTPCP(SSUserCareProvDR,3),"^",6)
	....i CTPcpMobile'="" d
	.....S MsgData=+$H_""_$P($H,",",2)_"^"_CTPcpMobile_"^"_MsgContent
	.....d ##class(LYGFY.LYGFYMSG).SendMSG(MsgData)
	q "0"
}

/// Description: 获取当前科室的用户
/// Creator:	 wangxuejian
/// CreatDate:	 2018-05-08
/// Input:		 科室id
/// Output:		 用户姓名、用户code
/// Others:		 w ##class(web.DHCADVCOMMON).GetStaff("100","1","122")
ClassMethod GetStaff(rows = 100, page = 1, Input As %String) As %String
{
	N (rows,page,Input,%session)
	s UserName=""
	s len=$l(Input,"^")
	i len>1 d
	.s UserName=$p(Input,"^",1)
	.s LocID=$p(Input,"^",2)
	e  d
	.s LocID=Input
	S End = page*rows
	S Start=(page-1)*rows+1
	S pid=..NewPid()
	S h=0
	S UserId=""
	F  S UserId=$o(^SSU("SSUSR",UserId))  Q:UserId=""  D
	.S locId=$p(^SSU("SSUSR",UserId),"^",4)
	.S Sub=""
	.F  S Sub=$o(^SSU("SSUSR",UserId,"OTHLL",Sub)) Q:Sub=""  D
	..Q:Sub=0
	..S OthLogLocID=$p(^SSU("SSUSR",UserId,"OTHLL",Sub),"^",1)
	..S flag=0
	..Q:(OthLogLocID="")&&(locId="")
	..S:(locId'=LocID)&&(OthLogLocID'=LocID) flag=-1
	..Q:flag=-1
	..S userCode=$p(^SSU("SSUSR",UserId),"^",1)
	..S userName=$p(^SSU("SSUSR",UserId),"^",2)
	..Q:userName'[UserName
	..S userName=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",userName)  ;2020-06-28 cy
	..S ListData=userCode_"^"_userName
	..Q:$d(^TMP("DHCADV","web.DHCADVCOMMON","GetStaff",pid,userName))
	..S h=h+1
	..S ^TMP("DHCADV","web.DHCADVCOMMON","GetStaff",pid,userName,h)=ListData
	.S flag=0 
	.S:locId'=LocID flag=-1
	.S userCode=$p(^SSU("SSUSR",UserId),"^",1)
	.S userName=$p(^SSU("SSUSR",UserId),"^",2)
	.Q:userName'[UserName
	.S userName=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",userName)  ;2020-06-28 cy
	.Q:flag=-1
	.Q:$d(^TMP("DHCADV","web.DHCADVCOMMON","GetStaff",pid,userName))
	.S h=h+1
	.S ListDatas=userCode_"^"_userName
	.S ^TMP("DHCADV","web.DHCADVCOMMON","GetStaff",pid,userName,h)=ListDatas
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出空的json串
    S count=0
    W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
    
	S index="",user=""
	F  S user=$o(^TMP("DHCADV","web.DHCADVCOMMON","GetStaff",pid,user)) Q:user=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVCOMMON","GetStaff",pid,user,index)) Q:index=""  D
	..S mdate=$g(^TMP("DHCADV","web.DHCADVCOMMON","GetStaff",pid,user,index))
	..S count = count+1
	..S Title="userCode^userName"
    ..Q:(count<Start)||(count>End)
	..I count=Start D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符	
	K ^TMP("DHCADV","web.DHCADVCOMMON","GetStaff",pid)
	Q ""
}

/// Description: 判断登录人是否有归档权限
/// Creator:     congyue
/// CreateDate:  2018-11-26
/// Table: 		 DHC_AdvQuerySec
/// Input:       人员id^科室id^安全组id^报告类型id
/// Output:  	 输出 分享^重点关注^归档^案例共享^删除^作废字段的权限
/// Others:	w ##class(web.DHCADVCOMMON).GetFocusAuthority("982^102^29^med")	
ClassMethod GetOperSecAll(RepTypeCode As %String, LgParam As %String = "") As %String
{
	n (RepTypeCode,LgParam)
	s ShareFlag=##class(web.DHCADVCOMMON).GetOperSecFlag(RepTypeCode,LgParam,7)
	s FocusFlag=##class(web.DHCADVCOMMON).GetOperSecFlag(RepTypeCode,LgParam,8)
	s FileFlag=##class(web.DHCADVCOMMON).GetOperSecFlag(RepTypeCode,LgParam,9)
	s CaseShareFlag=##class(web.DHCADVCOMMON).GetOperSecFlag(RepTypeCode,LgParam,10)
	s DeleteFlag=##class(web.DHCADVCOMMON).GetOperSecFlag(RepTypeCode,LgParam,11)
	s CancelFlag=##class(web.DHCADVCOMMON).GetOperSecFlag(RepTypeCode,LgParam,12)
	q ShareFlag_"^"_ FocusFlag_"^"_ FileFlag_"^"_ CaseShareFlag_"^"_ DeleteFlag_"^"_ CancelFlag
}

/// Description: 判断登录人是否有归档权限
/// Creator:     congyue
/// CreateDate:  2018-11-26
/// Table: 		 DHC_AdvQuerySec
/// Input:       人员id^科室id^安全组id^报告类型id^操作字段表中截取位置（5 评估，7 分享，8 重点关注，归档 9，案例共享 10 ，删除 11，作废 12）
/// Output:  	 输出重点关注权限的字段 
/// Others:	w ##class(web.DHCADVCOMMON).GetOperSecFlag("4805^193^23^advSkinUlcer^9")	
ClassMethod GetOperSecFlag(RepTypeCode As %String, LgParam As %String = "", PosiType As %String = "") As %String
{
	N (RepTypeCode,LgParam,PosiType)
	Q:RepTypeCode="""N"
	Q:PosiType="""N"
	
	S UserId=$p(LgParam,"^",1)
	S LocId=$p(LgParam,"^",2)
	S GroupId=$p(LgParam,"^",3)
	S HospId=$p(LgParam,"^",4)
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdvQuerySec",HospId) ///2021-06-18 cy 多院区业务改造	S RepTypeID=""

	S RepTypeID=""
	S RepTypeID=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //获取报告类型id
	S RepTypeParref="",RepTypeSub="" ;2018-08-29
	I RepTypeID=""  D
	.S RepTypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:RepTypeParref'="" RepTypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),RepTypeParref,""))
	.S:(RepTypeParref'="")&&(RepTypeSub'="") RepTypeID=RepTypeParref_"||"_RepTypeSub
	
	;子分类没有维护权限时走父分类的权限，维护权限时走子分类的权限 2021-08-01 cy 权限增加医院相关索引，唯一获取数据
	S:'$d(^DHCADVQUS(0,"HospRepType",HospIdGroup,RepTypeID)) RepTypeID=+RepTypeID
	S SecID="",SecHospID="",SecFlag=""
	S:+UserId'=0 SecID=$o(^DHCADVQUS(0,"HospRepType",HospIdGroup,RepTypeID,3,UserId,""))
	S:SecID'="" SecFlag=$p(^DHCADVQUS(SecID),"^",PosiType)
	Q:SecFlag="Y" "Y"
	S:+LocId'=0 SecID=$o(^DHCADVQUS(0,"HospRepType",HospIdGroup,RepTypeID,2,LocId,""))
	S:SecID'="" SecFlag=$p(^DHCADVQUS(SecID),"^",PosiType)
	Q:SecFlag="Y" "Y"
	S:+GroupId'=0 SecID=$o(^DHCADVQUS(0,"HospRepType",HospIdGroup,RepTypeID,1,GroupId,""))
	S:SecID'="" SecFlag=$p(^DHCADVQUS(SecID),"^",PosiType)
	Q:SecFlag="Y" "Y"

	Q "N"
}

/// Description: 不良事件产品功能配置
/// Creator:     congyue
/// CreateDate:  2019-07-25
/// Table: 		 
/// Input:       AdvCode-不良事件产品功能代码, Params-医院id^科室id^用户id^安全组id
/// Output:  	 不良事件产品功能参数值 
/// Others:	w ##class(web.DHCADVCOMMON).GetEmSysConfig("FILLTIME","10211^151^23^2")	
ClassMethod GetEmSysConfig(AdvCode As %String, Params As %String) As %String
{
	N (AdvCode, Params)
	S LgUserID=$p(Params,"^",1)    //用户ID
    S LgCtLocID=$p(Params,"^",2)     //科室ID
	S LgGroupID=$p(Params,"^",3)   //安全组ID
	S LgHospID=$p(Params,"^",4)   //医院ID
	S ResType=##Class(web.DHCAppComPar).GetAppPropValue("DHCADV",AdvCode,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	Q ResType
}

/// Description: 获取此状态与等级是否满足权限
/// Creator:     congyue
/// CreateDate:  2019-11-18
/// Input:  	 状态,不良事件等级
/// Return:  	 1 满足  0 不满足
/// Others:	W ##class(web.DHCADVCOMMON).GetRepLevFlag("32||3",1)
ClassMethod GetRepLevFlag(Status, RepLevel = "", HospId = "") As %String
{
	N (Status,RepLevel,HospId)
	S HospIdGroup=""
	S:HospId'="" HospIdGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdrEvtWorkFlowLink",HospId)  ///2021-06-18 cy 多院区业务改造
	Q:Status="" "1"
	Q:RepLevel="" "1"
	Q:'$d(^DHCADREVTWFL(0,"LinkDrHosp",Status,HospIdGroup)) "1"
	S Flag=0
	S WFLinkID=""
	F  S WFLinkID=$o(^DHCADREVTWFL(0,"LinkDrHosp",Status,HospIdGroup,WFLinkID))  Q:+WFLinkID=0  D
	.S WFLinkLevel=$p(^DHCADREVTWFL(WFLinkID),"^",2)
	.S:RepLevel=WFLinkLevel Flag=1
		
	Q Flag
}

/// Description: 性别//sufan 2019-12-05 修改了，加了返回值和改了输出val改为value
/// CreateDate:  2017-10-23
/// Table: 		 CT_Sex
/// Output:  	 性别（下拉框显示）  
/// Others:		 d ##class(web.DHCADVCOMMON).SelSexNew()
ClassMethod SelSexNew() As %String
{
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT CTSEX_RowId as SexDr, CTSEX_Desc as SexDesc FROM CT_Sex"
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S SexDr = result.Data("SexDr")
		S SexDesc = result.Data("SexDesc")
		S tmp=SexDr_"^"_SexDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Description:全角转半角后并返回字符串的首拼
/// Creator:	congyue
/// Input： 	HANZI:汉字
/// Output：	返回字符串的首拼
/// CreatDate:	2019-12-06
/// Others:		w ##class(web.DHCADVCOMMON).GetPYCODE("")
ClassMethod GetPYCODE(HANZIS As %String = "") As %String
{
	n (HANZIS)
	s Rtnstr=""
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=##class(web.DHCBL.BDP.FunLib).GetCNCODE(HANZIS,4,"")
	q Rtnstr
}

/// Description: 公共 (日期，时间 是否大于当前的时间)
/// Creator:     congyue
/// CreateDate:  2020-03-05
/// Table: 		 
/// Input:       日期 , 时间
/// Output:  	 0 输入日期时间小于当前时间  1 输入日期时间大于当前时间
/// Others:	w ##class(web.DHCADVCOMMON).DateTimeCompare("2020-03-02","20:30")	
ClassMethod DateTimeCompare(Date As %String, Time As %String) As %String
{
	N (Date,Time)
	q:Time=""""
	s Flag=0
	s Date=##class(web.DHCADVCOMMON).DateHtmlToLogical(Date)
	s Time=$zth(Time,1)
	i Date="" d
	.s:(Time>$p($h,",",2)) Flag=1
	e  s:(Date=+$h)&&(Time>$p($h,",",2)) Flag=1
	q Flag
}

/// Descript:js 获取医院字典信息
/// Creator: cy
/// CreateDate: 2020-04-08
/// w ##Class(web.DHCADVCOMMON).GetHospDs()
ClassMethod GetHospDs() As %String
{
	s count=0
	w "["
	s hosprowid=""
	f  s hosprowid=$o(^CT("HOSP",hosprowid)) q:hosprowid=""  d
	.q:hosprowid=0
	.s hospdesc=$p(^CT("HOSP",hosprowid),"^",2) 
	.s hospDateTo=$p(^CT("HOSP",hosprowid),"^",10) ;huaxiaoying 2017-1-6
	.i hospDateTo'=""  q:hospDateTo<+$h ;huaxiaoying 2017-1-6
	.s tmp=hosprowid_"^"_hospdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 获取报告 处理人id,处理科室id
/// Creator:     CongYue
/// CreateDate:  2018-02-07
/// Table:		 DHC_MedAdrRepAudit
/// Input:  	 报告id ，报告类型id，报告状态id
/// Return: 	 报告 处理人id,处理科室id
/// Others:		 w ##class(web.DHCADVCOMMON).GetRepAuditUserLoc("30","77||4")
ClassMethod GetRepAuditUserLoc(RepDr As %String, RepTypeDr As %String) As %String
{
	N (RepDr,RepTypeDr)
	S MedadrUserLocList="",MedadrID="",Status=""
	F  S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepDr,MedadrID)) Q:MedadrID=""  D
	.Q:+MedadrID=0
	.S MedadrReceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9)
	.Q:(MedadrReceivedr'="1")&&(MedadrReceivedr'="4")
	.S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	.S MedadrLocID=$p(^DHCMEDREPADT(MedadrID),"^",12)
	.S MedadrStatus=$p(^DHCMEDREPADT(MedadrID),"^",3)
	.Q:(Status'="")&&(MedadrStatus=Status)
	.S Status=MedadrStatus
	.I (MedadrReceivedr="1")||(MedadrReceivedr="4")  D
	..I MedadrUserLocList="" D
	...S MedadrUserLocList=MedadrLocID_":"_MedadrUserID_"；"
	..E  D
	...S MedadrUserLocList=MedadrUserLocList_MedadrLocID_":"_MedadrUserID_"；"
	

	Q MedadrUserLocList
}

/// Description: 根据 关联表单记录id 获取表单是否进行转归、追踪、评价标识串
/// Creator:     CongYue
/// CreateDate:  2020-04-28
/// Table:		 DHC_AdvFormRecord
/// Input:  	 关联表单记录id
/// Return: 	 转归^追踪^评价标识串   Y^Y^Y
/// Others:		 w ##class(web.DHCADVCOMMON).GetLinkFlagList("12","cs")
ClassMethod GetLinkFlagList(LinkRecordId As %String) As %String
{
	N (LinkRecordId)
	S PatOutFlag="",FunDeptFlag="",RepAssFalg=""
	S PatOutForm="",UlcPatOutForm="",FunDeptForm=""
	S PatOutForm=$o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4("PatOutcomform"),""))
	S UlcPatOutForm=$o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4("UlcPatOutcomform"),""))
	S FunDeptForm=$o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4("FunDeptConform"),""))
	S RecordId="",RecID=""
	F  S RecID=$o(^User.DHCAdvFormRecordI("IndexLink",$$ALPHAUP^SSUTIL4(LinkRecordId),RecID)) Q:RecID=""  D
	.Q:+RecID=0
	.S Recorddata=^User.DHCAdvFormRecordD(RecID)
	.S RecFormNameID=$LIST(Recorddata,2)
	.I (RecFormNameID=PatOutForm)||(RecFormNameID=UlcPatOutForm)  D 
	..S PatOutFlag="Y"
	.E  I (RecFormNameID=FunDeptForm)  D
	..S FunDeptFlag="Y"
	.E  D
	..S RepAssFalg="Y"
	
	q PatOutFlag_"^"_FunDeptFlag_"^"_RepAssFalg
}

/// Creator:      congyue
/// CreateDate:   2020-05-07
/// Descript:     病案号
/// InPut:        就诊id
/// OutPut:       病案号
/// w ##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("1","")
ClassMethod IGetMrNoByEpisodeID(EpisodeID As %String, PatID As %String) As %String
{
	N (EpisodeID,PatID)
	Q:(EpisodeID="")&&(PatID="") ""
	S $ZT="ErrorMsg"
	s:(PatID="")&&(EpisodeID'="") PatID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	S:EpisodeID'="" MedType=$p($g(^PAADM(+EpisodeID)),"^",2)	
	S MrNo=""
	S IfHaveClass=##class(websys.Conversions).IsValidClassName("DHCWMR.IO.OutService")
	I EpisodeID'="" D
	.I IfHaveClass=1 D
	..S MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID, MedType, .ErrMsg)
    .E  D
    ..S MrNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号

    S:(MrNo="")&&(PatID'="") MrNo=$p(^PAPER(PatID,"PAT",1),"^",22) //病案号
    
	Q MrNo
ErrorMsg
	Q ""
}

/// Creator:      hxy
/// CreateDate:   2020-06-23
/// Descript:     根据表名，字段名，语言和翻译前中文，返回翻译后内容
/// InPut:        表名，字段名，语言和翻译前中文
/// OutPut:       翻译后内容
/// w ##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","EN","体检中心")
ClassMethod GetTransDesc(TableName, FieldName, Languages, FieldDesc) As %String
{
	n (TableName, FieldName, Languages, FieldDesc,%session)
	s ret=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc(TableName, FieldName, Languages, FieldDesc)
	q ret
}

/// Creator:      congyue
/// CreateDate:   2021-11-08
/// Descript:     根据表名，字段名，语言和翻译后内容，返回翻译前内容
/// InPut:        表名，字段名，语言和翻译后内容
/// OutPut:       翻译前内容
/// w ##Class(web.DHCADVCOMMON).GetBeforeTransDesc("User.CTLoc","CTLOCDesc","EN","paediatrics")
ClassMethod GetBeforeTransDesc(TableName, FieldName, Languages, FieldDesc) As %String
{
	n (TableName, FieldName, Languages, FieldDesc,%session)
	s ret=##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc(TableName, FieldName, Languages, FieldDesc)
	q ret
}

/// Description: 获取默认开始日期，结束日期
/// Creator:     CongYue
/// CreateDate:  2021-05-07
/// Input:  	 LgParam : 以字符"^"分割,格式为:人员、科室、安全组、医院
/// Return:		 开始日期 结束日期
/// Others:		 w ##class(web.DHCADVCOMMON).GetStaEndDate("12177^114^23^2","")
ClassMethod GetStaEndDate(LgParam As %String, DateFormat = "") As %String
{
	N (LgParam,DateFormat)
	S DATECYCLE=##class(web.DHCADVCOMMON).GetEmSysConfig("DATECYCLE",LgParam)
	S:DATECYCLE'="" DATECYCLE=$NORMALIZE(+DATECYCLE,-1)  ; 下取整
	S:(DATECYCLE'="0")&&((+DATECYCLE=0)||(DATECYCLE<0)) DATECYCLE=7  ; 输入小于0的数字或者字符串或者为空时，默认为7 ；  输入小数时 下取整；
	S StDate=+$h-DATECYCLE //开始日期
	S:StDate<0 StDate=+$h-7  ;日期间隔输入过大时， 默认为7 
	S:(StDate'="")&&(DateFormat="") StDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(StDate)
	S:(StDate'="")&&(DateFormat="3") StDate=$zd(StDate,3)
	S EndDate=+$h   //结束日期
	S:(EndDate'="")&&(DateFormat="") EndDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(EndDate)
	S:(EndDate'="")&&(DateFormat="3") EndDate=$zd(EndDate,3)
	Q StDate_"^"_EndDate
}

/// 不良事件User文件导出
/// w ##Class(web.DHCADVCOMMON).GetTest()
ClassMethod GetTest() As %String
{
	s cls="User.DHCAdr"
	f  s cls= $o(^oddDEF(cls)) q:cls=""  d
	.q:cls'["User.DHCAdr"
	.d $system.OBJ.Export( cls_".cls", "D:\User\"_cls_".xml","" )
	
	s cls="User.DHCAdv"
	f  s cls= $o(^oddDEF(cls)) q:cls=""  d
	.q:cls'["User.DHCAdv"
	.d $system.OBJ.Export( cls_".cls", "D:\User\"_cls_".xml","" )

	s cls="User.DHCADV"
	f  s cls= $o(^oddDEF(cls)) q:cls=""  d
	.q:cls'["User.DHCADV"
	.d $system.OBJ.Export( cls_".cls", "D:\User\"_cls_".xml","" )

	s cls="User.DHCMatAdrR"
	f  s cls= $o(^oddDEF(cls)) q:cls=""  d
	.q:cls'["User.DHCMatAdrR"
	.d $system.OBJ.Export( cls_".cls", "D:\User\"_cls_".xml","" )

	s cls="User.DHCMedAdr"
	f  s cls= $o(^oddDEF(cls)) q:cls=""  d
	.q:cls'["User.DHCMedAdr"
	.d $system.OBJ.Export( cls_".cls", "D:\User\"_cls_".xml","" )

	s cls="User.DHCMedAdv"
	f  s cls= $o(^oddDEF(cls)) q:cls=""  d
	.q:cls'["User.DHCMedAdv"
	.d $system.OBJ.Export( cls_".cls", "D:\User\"_cls_".xml","" )

	s cls="User.DHCMedReport"
	f  s cls= $o(^oddDEF(cls)) q:cls=""  d
	.q:cls'["User.DHCMedReport"
	.d $system.OBJ.Export( cls_".cls", "D:\User\"_cls_".xml","" )

	s cls="User.DHCMedSafetyR"
	f  s cls= $o(^oddDEF(cls)) q:cls=""  d
	.q:cls'["User.DHCMedSafetyR"
	.d $system.OBJ.Export( cls_".cls", "D:\User\"_cls_".xml","" )
	
	s cls="web.DHCADV"
	f  s cls= $o(^oddDEF(cls)) q:cls=""  d
	.q:cls'["web.DHCADV"
	.d $system.OBJ.Export( cls_".cls", "D:\cycls\"_cls_".xml","" )
	q ""
}

/// Creator:      congyue
/// CreateDate:   2021-05-24
/// Descript:     获取压疮评分与自我照顾能力评分（根据护理接口获取）
/// InPut:        就诊id
/// OutPut:       评分
/// w ##Class(web.DHCADVCOMMON).GetNurMarkInfo("1")
ClassMethod GetNurMarkInfo(EpisodeID As %String) As %String
{
	N (EpisodeID)
	Q:EpisodeID="" ""
	S HospADLScore="",OccADLScore="",HosUlcRiskScore="",OccUlcRiskScore=""
	; 入院时ADL得分
	S HospADLScore=##class(web.DHCADVCOMMON).GetInterfaceInfo("NurMp.Sources.RecordInterface","AbilityToCare",EpisodeID,"query") 
	S:+HospADLScore=0 HospADLScore=""
	; 发生时ADL得分（24小时以内）
	S OccADLScore=##class(web.DHCADVCOMMON).GetInterfaceInfo("NurMp.Sources.RecordInterface","THAbilityToCare",EpisodeID,"query") 
	S:+OccADLScore=0 OccADLScore=""
	; 入院时压疮评分（评分表^分数）
	S HosUlcRiskScore=##class(web.DHCADVCOMMON).GetInterfaceInfo("NurMp.Sources.RecordInterface","AdmFallRisk",EpisodeID,"query") 
	S:HosUlcRiskScore'["^" HosUlcRiskScore=""
	; 发生时疮评分24小时以内（评分表^分数）
	S OccUlcRiskScore=##class(web.DHCADVCOMMON).GetInterfaceInfo("NurMp.Sources.RecordInterface","THFallRisk",EpisodeID,"query") 
	S:OccUlcRiskScore'["^" OccUlcRiskScore=""

	Q HospADLScore_"$$"_OccADLScore_"$$"_HosUlcRiskScore_"$$"_OccUlcRiskScore
}

/// Creator:      congyue
/// CreateDate:   2021-06-15
/// Descript:     获取接口信息
/// InPut:        类名,方法名,参数,类型（Flag:judge-判断接口是否存在, query-获取接口信息）
/// OutPut:       参数有值：接口信息，参数无值：接口是否存在,  Flag:judge-判断接口是否存在 1-存在， 空-不存在
/// w ##Class(web.DHCADVCOMMON).GetInterfaceInfo("web.DHCADVCOMMON","SaveHOSP","","")
ClassMethod GetInterfaceInfo(ClassName, MethodName, Arg, Flag) As %String
{
	N (ClassName, MethodName,Arg,Flag)
	Q:(ClassName="")||(MethodName="") ""
	S Info=""
	S $ZT="Error"
	S IfHaveClass=##class(websys.Conversions).IsValidClassName(ClassName)
	Q:IfHaveClass'=1 ""
	S IfHaveAbility=##class(websys.Conversions).IsValidMethodName(ClassName,MethodName)
	Q:IfHaveAbility'=1 ""
	S:Flag="query" Info=$classmethod(ClassName,MethodName,Arg)
	S:Flag="judge" Info=1
	Q Info
Error	
	Q Info
}

/// Creator:      congyue
/// CreateDate:   2021-06-15
/// Descript:     加密 encrypt
/// InPut:        密码字符串
/// OutPut:       加密串
/// w ##Class(web.DHCADVCOMMON).EnCode("1")
ClassMethod EnCode(List) As %String
{
	N (List)
	S List=##class(web.DHCADVCOMMON).GetInterfaceInfo("%SYSTEM.Encryption","Base64Encode",List,"query") ;##class(%SYSTEM.Encryption).Base64Encode(List) 
	Q List
}

/// Creator:      congyue
/// CreateDate:   2021-06-15
/// Descript:     解密 decrypt
/// InPut:        密码加密串
/// OutPut:       密码字符串
/// w ##Class(web.Util.Encryption).SimpleEncrypt("加密内容","key") w ##Class(web.Util.Encryption).SimpleDecrypt("解密内容","key")
/// w ##Class(web.DHCADVCOMMON).DeCode("1_ftp_2")
ClassMethod DeCode(List) As %String
{
 	N (List)
	S List=##class(web.DHCADVCOMMON).GetInterfaceInfo("%SYSTEM.Encryption","Base64Decode",List,"query") ;##class(%SYSTEM.Encryption).Base64Decode(List) 
	Q List
}

/// Creator:    cy
/// CreateDate: 2021-06-17
/// Descript:   判断该条数据是否要显示到界面上(医院id为空，显示全部)
/// InPut:      表名、数据ID、选择医院ID、日期
/// OutPut:     Y/N
/// w ##Class(web.DHCADVCOMMON).GetHospShowDataFlag("CT_Loc",282,"2","")
ClassMethod GetHospShowDataFlag(TableName, DataReference, Hospital = "", Date = "") As %String
{
	n (TableName, DataReference, Hospital,Date)
	s Flag=##Class(web.DHCADVCOMMON).GetInterfaceInfo("web.DHCBL.BDP.BDPMappingHOSP","GetHospShowDataFlag","","judge")
	q:Flag'="1" "Y"  ;接口不存在 显示数据 返回 Y
	s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(TableName, DataReference, Hospital,Date)
	q ret
}

/// Creator:    cy
/// CreateDate: 2021-06-17
/// Descript:   将数据保存到基础数据平台数据医院关联表中
/// InPut:      表名、数据ID、医院ID（单个医院）
/// OutPut:     0:成功,<0:失败
/// w ##Class(web.DHCADVCOMMON).SaveHOSP("","",2)
ClassMethod SaveHOSP(TableName, DataReference, Hospital) As %String
{
	n (TableName, DataReference, Hospital)
	s Flag=##Class(web.DHCADVCOMMON).GetInterfaceInfo("web.DHCBL.BDP.BDPConfig","GetConfigValue","","judge")
	q:Flag'="1" "0"  ;接口不存在 成功 返回 0
	s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
	q:HospAutflag'="Y" 0
	s Flag=##Class(web.DHCADVCOMMON).GetInterfaceInfo("web.DHCBL.BDP.BDPMappingHOSP","SaveHOSP","","judge")
	q:Flag'="1" "0"  ;接口不存在 成功 返回 0
	s Ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(TableName,DataReference,Hospital)
	q:+Ret<0 +Ret
	q 0
}

/// Creator:    cy
/// CreateDate: 2021-06-17
/// Descript:   删除通用医院关联表的表结构及关联医院保存方法
/// InPut:      表名、数据ID
/// OutPut:     成功：1  失败：-1^关联医院表数据删除失败
/// w ##Class(web.DHCADVCOMMON).DeleteHospitals()
ClassMethod DeleteHospitals(TableName, DataReference) As %String
{
	n (TableName, DataReference)
	s Flag=##Class(web.DHCADVCOMMON).GetInterfaceInfo("web.DHCBL.BDP.BDPMappingHOSP","DeleteHospitals","","judge")
	q:Flag'="1" "1"  ;接口不存在 成功 返回 1
	s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospitals(TableName,DataReference)
	q ret
}

/// Creator:    cy
/// CreateDate: 2021-06-17
/// Descript:   获取医院接口（配置数据用）根据表名、业务数据中的医院、日期取要取哪个医院的配置。
/// InPut:      表名/配置名、医院ID、日期
/// OutPut:     医院ID
/// w ##Class(web.DHCADVCOMMON).GetDefHospIdByTableName()
ClassMethod GetDefHospIdByTableName(TableName, HospID, Date = "") As %String
{
	n (TableName, HospID,Date)
	s Flag=##Class(web.DHCADVCOMMON).GetInterfaceInfo("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","","judge")
	q:Flag'="1" HospID  ;接口不存在 成功 返回 HospID
	s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(TableName,HospID,Date)
	q ret
}

/// Creator:    cy
/// CreateDate: 2021-06-17
/// Descript:   判断该条数据是否要显示到界面上(医院id为空，显示全部)--私有数据使用
/// InPut:      表名、数据ID、选择医院ID、日期、登记表表名（私有数据）
/// OutPut:     Y/N
/// w ##Class(web.DHCADVCOMMON).GetHospShowDataFlagSpecial("CT_Loc",282,"2","")
ClassMethod GetHospShowDataFlagSpecial(TableName, DataReference, Hospital = "", Date = "", ConfigTableName) As %String
{
	n (TableName, DataReference, Hospital,Date,ConfigTableName)
	s Flag=##Class(web.DHCADVCOMMON).GetInterfaceInfo("web.DHCBL.BDP.BDPMappingHOSP","GetHospShowDataFlagSpecial","","judge")
	q:Flag'="1" "Y"  ;接口不存在 成功 返回 Y
	s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial(TableName, DataReference, Hospital,Date,ConfigTableName)
	q ret
}

/// Creator:    cy
/// CreateDate: 2021-06-17
/// Descript:   根据表名，医院id，日期，返回该医院组下所有的非例外医院
/// InPut:      表名、选择医院ID、日期
/// OutPut:     医院rowid串，逗号(,)分隔
/// w ##Class(web.DHCADVCOMMON).GetGroupHospIdsByTableName("CT_Loc","2","")
ClassMethod GetGroupHospIdsByTableName(TableName, Hospital = "", Date = "") As %String
{
	n (TableName, Hospital,Date)
	s Flag=##Class(web.DHCADVCOMMON).GetInterfaceInfo("web.DHCBL.BDP.BDPMappingHOSP","GetGroupHospIdsByTableName","","judge")
	q:Flag'="1" Hospital  ;接口不存在 成功 返回 Hospital
	s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).GetGroupHospIdsByTableName(TableName, Hospital,Date)
	q ret
}

}
