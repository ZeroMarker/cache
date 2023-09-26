Import SQLUser

Class web.DHCMDTWaitingListNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：  qqa
/// CreatDate：    2021-07-27
/// Description:： 查询交班明细
/// Table：        DHC_MDTFolUpVis
/// Others：       w ##class(web.DHCMDTWaitingListNew).QryFolUpDetail(10,1,110)
ClassMethod QryFolUpDetail(rows As %String, page As %String, Params As %String) As %String
{
	N (rows,page,Params,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
    s MdtID=$p(Params,"^",1)	
    
    ///转换数据为Json格式
	s ListTitle="ID^MCDate^MDDiseases^FreebackNum^MCLocDr^PatName^isFeedback^EpisodeID^PatientID^CstID"
	s ListTitle=ListTitle_"^PatNo^MedicareNo^PatBed^PatSex^CstRTime^CstRUser^FolText"
	
    w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
   	s Count=0
    s ID=""
    f  s ID=$o(^DHCMDTFUV(0,"MdtCst",MdtID,ID),-1) q:ID=""  d
    .s Type=$p(^DHCMDTFUV(ID),"^",9)  //类型
	.q:Type="R"
    .s MCDate=$p(^DHCMDTFUV(ID),"^",5)     // 要求随访日期
    .s MCTime=$p(^DHCMDTFUV(ID),"^",6)     // 要求随访时间
    .s FolText=$p(^DHCMDTFUV(ID),"^",8)	   // 反馈信息
    .s:MCDate'="" MCDate=##Class(web.DHCMDTCom).DateLogicalToHtml(MCDate)
    .s:MCTime'="" MCTime=$zt(MCTime,1)
    .s MCDate=MCDate_" "_MCTime
    .s MCGroupID=$p(^DHCMDTCON(MdtID),"^",16)  //疑难病种分组ID
    .s MDDiseases=$p(^DHCMDTG(MCGroupID),"^",2)     //疑难病种
	.s MCLocDr=$p(^DHCMDTCON(MdtID),"^",2)   /// 申请科室
	.s:MCLocDr'="" MCLocDr=$p(^CTLOC(MCLocDr),"^",2)
	.s MCLocDr=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",MCLocDr)
	.s EpisodeID=$p(^DHCMDTCON(MdtID),"^",1) /// 就诊ID
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatSex=""
	.s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	.i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	.s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	.s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	.i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
	.;s MedicareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号
	.s MedicareNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)
	.s CstRDate=$p(^DHCMDTCON(MdtID),"^",3)    /// 申请日期
	.s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	.s CstRTime=$p(^DHCMDTCON(MdtID),"^",4)    /// 申请时间
	.s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	.s CstRTime=CstRDate_" "_CstRTime
    .s CstRUserID=$p(^DHCMDTCON(MdtID),"^",5)  /// 申请医生
	.s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	.s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)
	.s FreebackNum=##class(web.DHCMDTWaitingListNew).GetFreebackCount(MdtID,ID)
	.s FbNum="第"_FreebackNum_"次"
	.s isFeedback=##Class(web.DHCMDTWaitingListNew).IsExpReplyNew(ID)
	.s isFeedback=$case(isFeedback,0:"未回复",1:"部分回复",2:"全部回复")
	.s ListData=ID_"^"_MCDate_"^"_MDDiseases_"^"_FbNum_"^"_MCLocDr_"^"_PatName_"^"_isFeedback_"^"_EpisodeID_"^"_PatientID_"^"_MdtID
	.s ListData=ListData_"^"_PatNo_"^"_MedicareNo_"^"_PatBed_"^"_PatSex_"^"_CstRTime_"^"_CstRUser_"^"_FolText
	.s Count=Count+1
	.q:(Count<Start)||(Count>End)
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	Q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-03-05
/// Description:： 会诊专家回复内容
/// Table：         DHC_MDTFolUpVis
/// Others：       w ##class(web.DHCMDTWaitingList).QryReplyContent(10,1,3)
ClassMethod QryReplyContent(rows As %String, page As %String, mID As %String) As %String
{
	N (rows,page,mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	//s MCParRefDr=$p(^DHCMDTFUV(mID),"^",1) //会诊记录ID
	k TmpItemDetRC
	s h=0,count=0
	s ID="0"
	//f  s ID=$o(^DHCMDTFUV(0,"MdtCst",MCParRefDr,ID)) Q:ID=""  d
	//.q:$d(^DHCMDTFUV(0,"Paref",ID))=0
	//.;b ;4
	s MCParentDr=""
	f  s MCParentDr=$o(^DHCMDTFUV(0,"Paref",mID,MCParentDr)) q:MCParentDr=""  d	
	.;s MCParentDr=$p(^DHCMDTFUV(mID),"^",10) //随访记录ID
	.s Doctor=$p(^DHCMDTFUV(MCParentDr),"^",7) //回复专家
	.s:Doctor'="" Doctor=$p(^SSU("SSUSR",Doctor),"^",2)
	.s Advice=$p(^DHCMDTFUV(MCParentDr),"^",8) //回复意见
	.;s Type=$p(^DHCMDTFUV(mID),"^",9) //回复意见
	.;b ;11
	.s h=h+1
	.s ListData=ID_"^"_Doctor_"^"_Advice_"^"_mID
	.s TmpItemDetRC(h)=ListData		
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""	
	///转换数据为Json格式
	s ListTitle="ID^DocID^Advice^mID"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 	  //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDetRC(index)) Q:index=""  D
	.s ListData=$g(TmpItemDetRC(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() 		   //输出json结尾符
	k TmpItemDet
	Q ""
}

/// Return:第几次随访
/// w ##class(web.DHCMDTWaitingListNew).GetFreebackCount()
ClassMethod GetFreebackCount(MdtID, MCRowID)
{
	n (MdtID,MCRowID)
	s FreebackCount=""
	s Count=0
	s RowID=""
	f  s RowID=$o(^DHCMDTFUV(0,"MdtCst",MdtID,RowID)) q:(RowID="")||(FreebackCount'="")  d
	.s DataType=$p(^DHCMDTFUV(RowID),"^",9)  //类型
	.q:DataType="R"
	.s Count=Count+1
	.s:RowID=MCRowID FreebackCount=Count
	q FreebackCount
}

/// Descript:回复状态
/// Return: 0:未回复,1:部分回复,2:全部回复
/// W ##Class(web.DHCMDTWaitingListNew).IsExpReply("110")
ClassMethod IsExpReply(MdtID As %String)
{
	N (MdtID)
	s HasNoRep="",HasRep=""
	s CH=""
	f  s CH=$o(^DHCMDTCON(MdtID,"I",CH)) Q:CH=""  D
	.s CareProvID=+$p($g(^DHCMDTCON(MdtID,"I",CH)),"^",2)
	.i CareProvID=0 s CareProvID=+$p($g(^DHCMDTCON(MdtID,"I",CH)),"^",3)
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	.s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.q:+CsUserID=0
	.s McID=$o(^DHCMDTFUV(0,"MCUser",CsUserID,MdtID,""))
	.s:+McID=0 HasNoRep=1
	.q:+McID=0
	.s McType=$p(^DHCMDTFUV(McID),"^",9)  
	.q:McType'="R"
	.s HasRep=1
	
	s Ret=""
	s:HasNoRep&&'HasRep Ret=0
	s:HasNoRep&&HasRep Ret=1
	s:'HasNoRep&&HasRep Ret=2
	q Ret
}

/// Descript:回复状态
/// Return: 0:未回复,1:部分回复,2:全部回复
/// W ##Class(web.DHCMDTWaitingListNew).IsExpReplyNew("29")
ClassMethod IsExpReplyNew(MCParentID As %String)
{
	N (MCParentID)

	s MdtID=$p(^DHCMDTFUV(MCParentID),"^",1)
	s HasNoRep="",HasRep=""
	s CH=""
	f  s CH=$o(^DHCMDTCON(MdtID,"I",CH)) Q:CH=""  D
	.s CareProvID=+$p($g(^DHCMDTCON(MdtID,"I",CH)),"^",2)
	.i CareProvID=0 s CareProvID=+$p($g(^DHCMDTCON(MdtID,"I",CH)),"^",3)
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	.s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.q:+CsUserID=0
	.s ItmIsRep=##Class(web.DHCMDTWaitingListNew).IsRep(MCParentID,CsUserID)	;1/0(是否已经回复)
	.s:ItmIsRep HasRep=1	
	.s:'ItmIsRep HasNoRep=1
	
	s Ret=""
	s:HasNoRep&&'HasRep Ret=0
	s:HasNoRep&&HasRep Ret=1
	s:'HasNoRep&&HasRep Ret=2
	q Ret
}

/// 是否已经回复，1/0
/// W ##Class(web.DHCMDTWaitingListNew).IsRep("29","12176")
ClassMethod IsRep(MCParentID, CsUserID)
{
	n (MCParentID,CsUserID)
	s IsRep=0
	s MCRowID=0
	f  s MCRowID=$o(^DHCMDTFUV(0,"Paref",MCParentID,MCRowID)) q:MCRowID=""  d
	.s McType=$p(^DHCMDTFUV(MCRowID),"^",9) 
	.q:McType'="R"
	.s MCUserID=$p(^DHCMDTFUV(MCRowID),"^",7)
	.q:CsUserID'=MCUserID
	.s IsRep=1
	q IsRep
}

}
