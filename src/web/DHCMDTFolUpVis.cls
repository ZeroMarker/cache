Import SQLUser

/// Creator: 		yangyongtao
/// CreateDate: 	2020-03-06
/// Descript: 		随访业务类
Class web.DHCMDTFolUpVis Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:  插入会诊随访内容
/// Input:     mListData-会诊随访内容
/// Ouput:     随访ID
/// w ##Class(web.DHCMDTFolUpVis).Insert("","110@113@12175@第三次随访@F","")
ClassMethod Insert(McID As %String, mListData As %String, ParentDr As %String = "") As %String
{
	n (McID, mListData, ParentDr)
	S ^yangyongtao("Insert")=$lb(McID, mListData, ParentDr)
	i McID="" D
	.s McID=..InsFolVis(mListData,ParentDr)
	E  D
	.s McID=..UpdFolVis(McID, mListData,ParentDr)

	Q McID
}

/// Descritp:  插入MDT随访主表
/// w ##Class(web.DHCMDTFolUpVis).UpdFolVis("49","135@15@8917@胡维仲专家回复123@R","45")
ClassMethod InsFolVis(ListData As %String, McParentDr As %String)
{
	
  	n (ListData,McParentDr)
    s CstID=$p(ListData,"@!@",1)       		///会诊ID
    s McUserID=$p(ListData,"@!@",3)      		///随访医师/回复专家
    s McType=$p(ListData,"@!@",5)      		///类型 F-随访，R-回复
    //s MCUserDr=$p(^DHCMDTFUV(McID),"^",7)   ///随访医师/回复专家
	s Err=0
	TS
	b ;err
	/// 插入MDT随访主表
	s McID = ..InsConMaster(ListData,McParentDr)
	i McID<0 tro
	Q:McID<0 McID
	b ;err2
	///执行专家消息
	i McType="R" D
	.s Err =..InvRlyExec(CstID,McParentDr,McUserID) 
	i Err'=0 tro
	Q:Err'=0 "-12"

	TC	
 
	Q McID
}

/// Descritp:  插入MDT随访主表
ClassMethod InsConMaster(ListData As %String, McParentDr As %String) As %String
{
	n (ListData,McParentDr)
	s CstID=$p(ListData,"@!@",1)       	///会诊ID
	s McLocID=$p(ListData,"@!@",2)       	///随访(回复)科室
	s McUserID=$p(ListData,"@!@",3)      	///随访医师/回复专家
	s McContent=$p(ListData,"@!@",4)      ///随访内容/回复意见
	s McType=$p(ListData,"@!@",5)      	///类型 F-随访，R-回复
	S McID=$o(^DHCMDTFUV(0,"MCUser",McUserID,CstID,""),-1)
	S FloID=##Class(web.DHCMDTFolUpVis).JsIsReplyFlo(CstID)
	s Type=""
	s:McID'="" Type=$p(^DHCMDTFUV(McID),"^",9)
	;q:(FloID=McID)&&(McType=Type) "-1"
	//s McParentDr=$p(ListData,"@!@",6)     ///关联ID
	s McDate=+$H   		           		///随访(回复)日期 
	s McTime=$p($H,",",2)             	///随访(回复)时间
	&SQL(Insert Into DHC_MDTFolUpVis(MC_ParRef_Dr,MC_Loc_Dr,MC_Date,MC_Time,MC_User_Dr,MC_Content,MC_Type,MC_Parent_Dr)
		values(:CstID,:McLocID,:McDate,:McTime,:McUserID,:McContent,:McType,:McParentDr))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  执行专家回复信封消息
/// Creator: 	yangyongtao
/// CreateDate: 2020-04-20
/// Input:      CstID - 会诊ID, McID-随访ID，McUserID-专家ID
/// Output:     Ret：0，执行成功
/// w ##Class(web.DHCMDTFolUpVis).InvRlyExec("140","72","8917")
ClassMethod InvRlyExec(CstID As %String, McID As %String, McUserID As %String) As %String
{
	n (CstID,McID, McUserID)
	s Ret=0
	s EpisodeID = $p(^DHCMDTCON(CstID),"^",20)
	s CH=0
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:(CH="")||(Ret<0)  D  
	.s CareProvID=$p(^DHCMDTCON(CstID,"I",CH),"^",2) /// 会诊医生
	.s UserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.Q:UserID="" 
	.Q:(UserID'=McUserID)
	.s itmID = McID_"||"_CstID_"||"_CH
	.s Ret = ##class(websys.DHCMessageInterface).Exec("","1014",EpisodeID,"",itmID,McUserID)                                                                       ;//处理消息	
	.i Ret="-3" s Ret=0    /// -3 未找到消息
	.i Ret="-102" s Ret=0  /// -102 消息已执行过
	.i Ret>0 s Ret=0
	q Ret
}

/// Descritp:  插入MDT随访主表
/// w ##Class(web.DHCMDTFolUpVis).UpdFolVis("49","135@15@8917@胡维仲专家回复123@R","45")
ClassMethod UpdFolVis(McID As %String, ListData As %String, McParentDr As %String)
{
	
  	n (McID,ListData,McParentDr)
    s CstID=$p(ListData,"@!@",1)       		///会诊ID
    s McUserID=$p(ListData,"@!@",3)      		///随访医师/回复专家
    s McType=$p(ListData,"@!@",5)      		///类型 F-随访，R-回复
    s MCUserDr=$p(^DHCMDTFUV(McID),"^",7)   ///随访医师/回复专家
    /// 信封消息
	I (McType="F")&&(MCUserDr="") D ##Class(web.DHCMDTInterface).SendCsReqMsg(CstID,"","F",McID)  
	s StatusID=##class(web.DHCMDTConsult).GetConsStatus(90) /// 已反馈
	s Err=0
	TS
	
	/// 插入MDT随访主表
	s McID = ..UpdConMaster(McID,ListData,McParentDr)
	i McID<0 tro
	Q:McID<0 McID
	
	
	/// 修改状态
	I (McType="F")&&(MCUserDr="") D
	.s Err = ##class(web.DHCMDTConsult).InsMasStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入日志
	I (McType="F")&&(MCUserDr="") D
	.s Err = ##class(web.DHCMDTConsult).InsConsLog(CstID,McUserID,StatusID,"")
	i Err'=0 tro
	Q:Err'=0 "-12"
	

	TC	
 
	Q McID
}

/// Descritp:  更新MDT随访主表
ClassMethod UpdConMaster(McID As %String, ListData As %String, McParentDr As %String) As %String
{
	n (McID,ListData,McParentDr)
	s CstID=$p(ListData,"@!@",1)       	///会诊ID
	s McLocID=$p(ListData,"@!@",2)       	///随访(回复)科室
	s McUserID=$p(ListData,"@!@",3)      	///随访医师/回复专家
	s McContent=$p(ListData,"@!@",4)      ///随访内容/回复意见
	s McDate=+$H   		           		///随访(回复)日期 
	s McTime=$p($H,",",2)             	///随访(回复)时间
	&SQL(Update DHC_MDTFolUpVis Set MC_Loc_Dr=:McLocID,MC_Date=:McDate,MC_Time=:McTime,
	     MC_User_Dr=:McUserID,MC_Content=:McContent,MC_Parent_Dr=:McParentDr Where MC_RowID=:McID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 	yangyongtao
/// CreateDate: 2020-03-09
/// Descript:	获取本次随访内容
/// Input:      McID - 随访ID
/// Output:     
/// W ##Class(web.DHCMDTFolUpVis).JsMcContent("118")
ClassMethod JsMcContent(CstID As %String, Type As %String = "", LgParam As %String = "") As %String
{
	n (CstID,Type,LgParam)
	S LgUserID=$p(LgParam,"^",1)
	S LgLocID=$p(LgParam,"^",2)
	k TmpArr
	s TreMeasures=$p($g(^DHCMDTCON(CstID)),"^",11) /// 最终治疗措施   会诊意见
	s McID=""
	F  s McID=$o(^DHCMDTFUV(0,"MdtCst",CstID,McID)) Q:((McID=""))  D
	.s CstID=$p(^DHCMDTFUV(McID),"^",1)       		///会诊ID
	.s McLocID=$p(^DHCMDTFUV(McID),"^",4)       	///随访(回复)科室
	.s McLoc=""
	.S:McLocID'="" McLoc=$p(^CTLOC(McLocID),"^",2)
	.Q:(LgLocID'="")&&(LgLocID'=McLocID)
	.S:McLocID["-" McLoc=$p(McLocID,"-",2)
	.s McDate=$p(^DHCMDTFUV(McID),"^",5)   			///随访(回复)日期 
	.s:McDate'="" McDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(McDate)
	.s McTime=$p(^DHCMDTFUV(McID),"^",6)         	///随访(回复)时间
	.s:McTime'="" McTime=$zt(McTime,1)
	.s McUserID=$p(^DHCMDTFUV(McID),"^",7)      	///随访医师/回复专家
	.Q:(LgUserID'="")&&(LgUserID'=McUserID)
	.s McUser=$p($g(^SSU("SSUSR",+McUserID)),"^",2)
	.s McContent=$p(^DHCMDTFUV(McID),"^",8)      	///随访内容/回复意见
	.s McType=$p(^DHCMDTFUV(McID),"^",9)      		///随访内容/回复意见
	.Q:(McType'=Type)&&(Type'="")
	.s TmpArr("FolUpVIs",McID)=CstID_"^"_McID_"^"_McLocID_"^"_McLoc_"^"_McDate_"^"_McTime_"^"_McUserID_"^"_McUser_"^"_McContent_"^"_McType_"^"_TreMeasures
	s ListTitle="CstID^McID^McLocID^McLoc^McDate^McTime^McUserID^McUser^McContent^McType^TreMeasures"
	W "["
	s Num=0
	s index=""
	F  s index=$o(TmpArr("FolUpVIs",index)) Q:index=""  D
	.s ListData=$g(TmpArr("FolUpVIs",index))
	.Q:ListData=""
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	k TmpArr
	Q ""
}

/// Creator: 	yangyongtao
/// CreateDate: 2020-03-09
/// Descript:	获取本次随访内容
/// Input:      McID - 随访ID
/// Output:     
/// W ##Class(web.DHCMDTFolUpVis).GetMcContent("1")
ClassMethod GetMcContent(McID As %String) As %String
{
	n (McID)
	s McLocID=$p(^DHCMDTFUV(McID),"^",4)       		///随访(回复)科室
	s McLoc=""
	S:McLocID'="" McLoc=$p(^CTLOC(McLocID),"^",2)
	S:McLocID["-" McLoc=$p(McLocID,"-",2)
	s McDate=$p(^DHCMDTFUV(McID),"^",5)   			///随访(回复)日期 
	s:McDate'="" McDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(McDate)
	s McTime=$p(^DHCMDTFUV(McID),"^",6)         	///随访(回复)时间
	s:McTime'="" McTime=$zt(McTime,1)
	s McUserID=$p(^DHCMDTFUV(McID),"^",7)      		///随访医师/回复专家
	s McUser=$p($g(^SSU("SSUSR",+McUserID)),"^",2)
	s McContent=$p(^DHCMDTFUV(McID),"^",8)      	///随访内容/回复意见
	s McType=$p(^DHCMDTFUV(McID),"^",9)      		///类型 F-随访，R-回复
	s ListData=McID_"^"_McLocID_"^"_McLoc_"^"_McDate_"^"_McTime_"^"_McUserID_"^"_McUser_"^"_McContent_"^"_McType
	s ListTitle="McID^McLocID^McLoc^McDate^McTime^McUserID^McUser^McContent^McType"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator: 	yangyongtao
/// CreateDate: 2020-03-09
/// Descript:	时间轴信息 
/// Input:      CstID - 会诊ID,LgParam-当前登陆信息
/// Output:     
/// W ##Class(web.DHCMDTFolUpVis).JsMcTimeAxis("25","")
ClassMethod JsMcTimeAxis(CstID As %String, LgParam = "") As %String
{
	n (CstID,LgParam,%session)
	
	k TmpArr
	s TmpArr("Num")=0

	w "["
	d ..QueryCstLog(CstID,LgParam,.TmpArr)		// 日志
	
	d ..QueryFolupVis(CstID,LgParam,.TmpArr)	// 随访
	w "]"
	Q ""
}

/// Creator: 	yangyongtao
/// CreateDate: 2020-03-09
/// Descript:	MDT会诊状态日志
/// Input:      CstID - 会诊ID,LgParam-当前登陆信息
/// Output:     
/// W ##Class(web.DHCMDTFolUpVis).QueryCstLog("45","443^13^29^2")
ClassMethod QueryCstLog(CstID, LgParam, TmpArr)
{
	n (CstID,LgParam,TmpArr,%session)
	
	S LgUserID=$p(LgParam,"^",1)
	S LgLocID=$p(LgParam,"^",2)
	/// 会诊讨论填写方式
	s CONSDISRUL=##Class(web.DHCMDTCom).GetEmSysConfig("CONSDISRUL",LgParam)
	s ListTitle="Type^McDate^McTime^McUserID^McUser^McContent^McType^Status^StatusDesc^CstTrePro^CstPurpose^TreMeasures^DisProcess"
	s LgID=""
	F  s LgID=$o(^DHCMDTL(0,"CstRef",CstID,LgID)) Q:LgID=""  D
	.s CstUser=""
	.s UserID=$p(^DHCMDTL(LgID),"^",2)    /// 操作人
	.s:UserID'="" CstUser=$p(^SSU("SSUSR",UserID),"^",2)
	.s CstUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",CstUser)
	.s StatusID=$p(^DHCMDTL(LgID),"^",3)  /// 状态
	.s StatusCode=$p($g(^DHCMDTS(+StatusID)),"^",1)
	.s StatusDesc=$p($g(^DHCMDTS(+StatusID)),"^",2)
	.s StatusDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCMDTConsStatus","MDDesc","",StatusDesc)
	.s LgDate=$p(^DHCMDTL(LgID),"^",4)    /// 日期
	.s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCMDTL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s CstTrePro=$p(^DHCMDTCON(CstID),"^",6)    	/// 病情及诊疗经过
	.s CstPurpose=$p(^DHCMDTCON(CstID),"^",7)   	/// 会诊的理由和目的
	.s TreMeasures=$p(^DHCMDTCON(CstID),"^",11) 	/// 最终治疗措施
	.s DisProcess=##class(web.DHCMDTConsultQuery).GetMdtDiscuss(CstID,CONSDISRUL)
	.;s DisProcess=$p(^DHCMDTCON(CstID),"^",23)    	/// 会诊讨论内容
	.s AssContent="" //评估内容
	.s TmpArr("Num")=TmpArr("Num")+1
	.s Num=TmpArr("Num")
	.s ListData="Log"_"^"_LgDate_"^"_LgTime_"^"_UserID_"^"_CstUser_"^^^"_StatusCode_"^"_StatusDesc_"^"_CstTrePro_"^"_CstPurpose_"^"_TreMeasures_"^"_DisProcess
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
    .e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	q ""
}

/// Creator: 	yangyongtao
/// CreateDate: 2020-03-09
/// Descript:	MDT反馈数据
/// Input:      CstID - 会诊ID,LgParam-当前登陆信息
/// Output:     
/// W ##Class(web.DHCMDTFolUpVis).QueryFolupVis("129","443^13^29^2")
ClassMethod QueryFolupVis(CstID, LgParam, TmpArr)
{
	n (CstID,LgParam,TmpArr)
	S LgUserID=$p(LgParam,"^",1)
	S LgLocID=$p(LgParam,"^",2)
	s ListTitle="Type^FTimes^CstID^McID^McLocID^McLoc^McDate^McTime^McUserID^McUser^McContent^McType^Status^StatusDesc^CstTrePro^CstPurpose^TreMeasures^DisProcess"
	s FTime=0
	s McID=""
	F  s McID=$o(^DHCMDTFUV(0,"MdtCst",CstID,McID)) Q:McID=""  D
	.s McLocID=$p(^DHCMDTFUV(McID),"^",4)       	///随访(回复)科室
	.Q:(LgLocID'="")&&(LgLocID'=McLocID)
	.s McLoc=""
	.S:McLocID'="" McLoc=$p(^CTLOC(McLocID),"^",2)
	.S:McLocID["-" McLoc=$p(McLocID,"-",2)
	.s McDate=$p(^DHCMDTFUV(McID),"^",5)   			///随访(回复)日期 
	.s:McDate'="" McDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(McDate)
	.s McTime=$p(^DHCMDTFUV(McID),"^",6)         	///随访(回复)时间
	.s:McTime'="" McTime=$zt(McTime,1)
	.s McUserID=$p(^DHCMDTFUV(McID),"^",7)      	///随访医师/回复专家
	.Q:McUserID=""
	.Q:(LgUserID'="")&&(LgUserID'=McUserID)
	.s McUser=$p($g(^SSU("SSUSR",+McUserID)),"^",2)
	.
	.s McContent=$p(^DHCMDTFUV(McID),"^",8)      	///随访内容/回复意见
	.s McType=$p(^DHCMDTFUV(McID),"^",9)      		///类型 F-随访，R-回复
	.Q:McType'="F" 
	.s TmpArr("Num")=TmpArr("Num")+1
	.s Num=TmpArr("Num")
	.S FTime=FTime+1
	.s ListData="Fol"_"^"_FTime_"^"_CstID_"^"_McID_"^"_McLocID_"^"_McLoc_"^"_McDate_"^"_McTime_"^"_McUserID_"^"_McUser_"^"_McContent_"^"_McType
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
    .e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.d ..QueryReply(CstID,McID,LgParam,.TmpArr)
	
	q ""
}

/// Creator: 	yangyongtao
/// CreateDate: 2020-03-09
/// Descript:	MDT反馈数据
/// Input:      CstID - 会诊ID,McID-反馈ID,LgParam-当前登陆信息
/// Output:     
/// W ##Class(web.DHCMDTFolUpVis).QueryReply("129","443^13^29^2")
ClassMethod QueryReply(CstID, McID, LgParam, TmpArr)
{
	n (CstID,McID,LgParam,TmpArr)
	S LgUserID=$p(LgParam,"^",1)
	S LgLocID=$p(LgParam,"^",2)
	s ListTitle="FTimes^CstID^McID^McLocID^McLoc^McDate^McTime^McUserID^McUser^McContent^McType^Status^StatusDesc^CstTrePro^CstPurpose^TreMeasures"
	s RpyNum=0
	s ID=""
	F  s ID=$o(^DHCMDTFUV(0,"Paref",McID,ID)) Q:ID=""  D
	.s McLocID=$p(^DHCMDTFUV(ID),"^",4)       	///随访(回复)科室
	.s McLoc=""
	.S:McLocID'="" McLoc=$p(^CTLOC(McLocID),"^",2)
	.S:McLocID["-" McLoc=$p(McLocID,"-",2)
	.s McDate=$p(^DHCMDTFUV(ID),"^",5)   			///随访(回复)日期 
	.s:McDate'="" McDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(McDate)
	.s McTime=$p(^DHCMDTFUV(ID),"^",6)         	///随访(回复)时间
	.s:McTime'="" McTime=$zt(McTime,1)
	.s McUserID=$p(^DHCMDTFUV(ID),"^",7)      	///随访医师/回复专家
	.s McUser=$p($g(^SSU("SSUSR",+McUserID)),"^",2)
	.s McContent=$p(^DHCMDTFUV(ID),"^",8)      	///随访内容/回复意见
	.s McType=$p(^DHCMDTFUV(ID),"^",9)      		///类型 F-随访，R-回复
    .s TmpArr("Num")=TmpArr("Num")+1
	.s Num=TmpArr("Num")
    .S RpyNum=RpyNum+1
	.S ListData=RpyNum_"^"_CstID_"^"_ID_"^"_McLocID_"^"_McLoc_"^"_McDate_"^"_McTime_"^"_McUserID_"^"_McUser_"^"_McContent_"^"_McType
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
    .e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

    q ""
}

/// 获取所有的MDT专家用户
/// W ##Class(web.DHCMDTFolUpVis).GetExpUserDr("122")
ClassMethod GetExpUserDr(ID As %String)
{
	N (ID)
	S UserArr=""
	S CH=""
	F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	.s CsLocID=$p($g(^DHCMDTCON(ID,"I",CH)),"^",1)       /// 会诊科室
	.s CareProvID=+$p($g(^DHCMDTCON(ID,"I",CH)),"^",2)
	.s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	.i CareProvID=0 s CareProvID=+$p($g(^DHCMDTCON(ID,"I",CH)),"^",3)
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	.s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.I UserArr=""  S UserArr=CsUserID
	.E  S UserArr=UserArr_"!!"_CsUserID
	Q UserArr
}

/// 判断是否所有的专家已经回复信息
///  RepFlag  1  回复   0 未回复
/// W ##Class(web.DHCMDTFolUpVis).IsExpReply("118")
ClassMethod IsExpReply(ID As %String)
{
	N (ID)
	s Num=0
	S ExpUserDrStr=..GetExpUserDr(ID)
	S Len=$L(ExpUserDrStr,"!!")
	S RlyFlag=0
	S ReplyArr=""
	F i=1:1:Len   d
	.S McUserID=$p(ExpUserDrStr,"!!",i)
	.q:McUserID=""
	.S McID=$o(^DHCMDTFUV(0,"MCUser",McUserID,ID,""))
	.Q:McID="" 
	.s McType=$p(^DHCMDTFUV(McID),"^",9)      		///类型 F-随访，R-回复
	.Q:McType'="R"
	.s ParentDr=$p(^DHCMDTFUV(McID),"^",10)      		///关联ID
	.S Num=Num+1
	I Len=Num D 
	.S RlyFlag=1
	.S ReplyArr=RlyFlag_"#"_ParentDr
	Q ReplyArr
}

/// 获取未回复完成的随访记录
/// W ##Class(web.DHCMDTFolUpVis).JsIsReplyFlo("118")
ClassMethod JsIsReplyFlo(CstID As %String)
{
   n (CstID)
   S ParentDr=""
   S FloID=""
   S McID=""
   F  s McID=$o(^DHCMDTFUV(0,"MdtCst",CstID,McID)) Q:(McID="")||(FloID'="")  D
   .s McType=$p(^DHCMDTFUV(McID),"^",9)      		///类型 F-随访，R-回复
   .Q:McType'="F"
   .S ReplyArr=##Class(web.DHCMDTFolUpVis).IsExpReply(CstID)
   .S:ReplyArr["#" ParentDr=$p(ReplyArr,"#",2)
   .I (ParentDr'=McID) S FloID=McID
   Q FloID
}

/// 会诊报告是否允许专家回复
/// 1:允许,0:不允许
/// W ##Class(web.DHCMDTFolUpVis).GetIsReplyFlag("118")
ClassMethod GetIsReplyFlag(CstID As %String)
{
   N (CstID)
   S IsVisFlag=0
   I $d(^DHCMDTFUV(0,"MdtCst",CstID))  S IsVisFlag=1
   Q IsVisFlag
}

/// Creator: 	yangyongtao
/// CreateDate: 2020-03-09
/// Descript:	获取本次随访内容
/// Input:      McID - 随访ID
/// Output:     
/// W ##Class(web.DHCMDTFolUpVis).JsFloUpVis("110","1","","12175^113^29^2")
ClassMethod JsFloUpVis(CstID As %String, McID As %String, Type As %String = "", LgParam As %String = "") As %String
{
	n (CstID,McID,Type,LgParam,%session)
	//S ^yangyongtao("JsFloUpVis")=$lb(CstID,McID,Type,LgParam)
	S LgUserID=$p(LgParam,"^",1)
	S LgLocID=$p(LgParam,"^",2)
	;s:McID="" McID=$o(^DHCMDTFUV(0,"MCUser",LgUserID,CstID,""),-1)
	;s McID=1
	b ;errData
	k TmpArr
	s TreMeasures=$p($g(^DHCMDTCON(CstID)),"^",11) /// 最终治疗措施   会诊意见
	//S McID=##Class(web.DHCMDTFolUpVis).JsIsReplyFlo(CstID)
	//Q:McID="" "[]"
	//s CstID=$p(^DHCMDTFUV(McID),"^",1)       		///会诊ID
	s McLocID=$p(^DHCMDTFUV(McID),"^",4)       	///随访(回复)科室
	s McLoc=""
	S:McLocID'="" McLoc=$p(^CTLOC(McLocID),"^",2)
	S:McLocID["-" McLoc=$p(McLocID,"-",2)
	s McLoc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",McLoc)
	s McDate=$p(^DHCMDTFUV(McID),"^",5)   			///随访(回复)日期 
	s:McDate'="" McDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(McDate)
	s McTime=$p(^DHCMDTFUV(McID),"^",6)         	///随访(回复)时间
	s:McTime'="" McTime=$zt(McTime,1)
	s McUserID=$p(^DHCMDTFUV(McID),"^",7)      	///随访医师/回复专家
	q:McUserID="" "[]"
	s McUser=$p($g(^SSU("SSUSR",+McUserID)),"^",2)
	s McUser = ##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",McUser)
	s McContent=$p(^DHCMDTFUV(McID),"^",8)      	///随访内容/回复意见
	s McType=$p(^DHCMDTFUV(McID),"^",9)      		///随访内容/回复意见
	Q:(McType'=Type)&&(Type'="") "[]"
	s TmpArr("FolUpVIs",McID)=CstID_"^"_McID_"^"_McLocID_"^"_McLoc_"^"_McDate_"^"_McTime_"^"_McUserID_"^"_McUser_"^"_McContent_"^"_McType_"^"_TreMeasures
	S ID="" 
	F  s ID=$o(^DHCMDTFUV(0,"Paref",McID,ID)) Q:ID=""  D
	.s McType=$p(^DHCMDTFUV(ID),"^",9)      		///类型 F-随访，R-回复
	.s McLocID=$p(^DHCMDTFUV(ID),"^",4)       	///随访(回复)科室
	.Q:(LgLocID'="")&&(LgLocID'=McLocID)&&(McType="R")
	.s McLoc=""
	.S:McLocID'="" McLoc=$p(^CTLOC(McLocID),"^",2)
	.S:McLocID["-" McLoc=$p(McLocID,"-",2)
	.s McLoc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",McLoc)
	.s McDate=$p(^DHCMDTFUV(ID),"^",5)   			///随访(回复)日期 
	.s:McDate'="" McDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(McDate)
	.s McTime=$p(^DHCMDTFUV(ID),"^",6)         	///随访(回复)时间
	.s:McTime'="" McTime=$zt(McTime,1)
	.s McUserID=$p(^DHCMDTFUV(ID),"^",7)      	///随访医师/回复专家
	.Q:(LgUserID'="")&&(LgUserID'=McUserID)&&(McType="R")
	.s McUser=$p($g(^SSU("SSUSR",+McUserID)),"^",2)
	.s McUser = ##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",McUser)
	.s McContent=$p(^DHCMDTFUV(ID),"^",8)      	///随访内容/回复意见
	.s TmpArr("FolUpVIs",ID)=CstID_"^"_ID_"^"_McLocID_"^"_McLoc_"^"_McDate_"^"_McTime_"^"_McUserID_"^"_McUser_"^"_McContent_"^"_McType_"^"_TreMeasures
	s ListTitle="CstID^McID^McLocID^McLoc^McDate^McTime^McUserID^McUser^McContent^McType^TreMeasures"
	W "["
	s Num=0
	s index=""
	F  s index=$o(TmpArr("FolUpVIs",index)) Q:index=""  D
	.s ListData=$g(TmpArr("FolUpVIs",index))
	.Q:ListData=""
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	k TmpArr
	Q ""
}

ClassMethod JsFloUpLastVis(CstID As %String, McID As %String, Type As %String = "", LgParam As %String = "")
{
	
	n (CstID,McID,Type,LgParam,%session)
	s LgUserID=$p(LgParam,"^",1)
	s:McID="" McID=##Class(web.DHCMDTFolUpVis).GetLastMcID(CstID)
	w ##Class(web.DHCMDTFolUpVis).JsFloUpVis(CstID,McID,Type,LgParam)
	q ""
}

/// 完成会诊会诊按照配置数据插入随访记录
/// W ##Class(web.DHCMDTFolUpVis).InsMdtFolVis("123")
ClassMethod InsMdtFolVis(CstID As %String)
{
	n (CstID)
	Q:$d(^DHCMDTFUV(0,"MdtCst",CstID)) 0
	s GrpID=$p(^DHCMDTCON(CstID),"^",16)    	/// 疑难病种
	s McUserID=""  //$p(LgParam,"^",4)         		/// 用户ID
	s ID=$o(^DHCMDTFUT(0,"Group",GrpID,""))
	s MDTimes=$p(^DHCMDTFUT(ID),"^",2)    		/// 次数
	s MDInterval=$p(^DHCMDTFUT(ID),"^",3)    	/// 间隔时间
	s quitflag=0
	F i=1:1:MDTimes Q:quitflag'="0"  D
	.s McNDate=+$H+((MDInterval/MDTimes)*(i-1))   		    		/// 要求随访日期 
	.s McNTime=$p($H,",",2)             		/// 要求随访时间
	.S McType="F"
	.&SQL(Insert Into DHC_MDTFolUpVis(MC_ParRef_Dr,MC_NDate,MC_NTime,MC_User_Dr,MC_Type)
		values(:CstID,:McNDate,:McNTime,:McUserID,:McType))
	.i SQLCODE'=0 s quitflag="1"
	//F  s McID=$o(^DHCMDTFUV(0,"MdtCst",CstID,McID)) Q:McID=""  D		
	//.&SQL(Update DHC_MDTFolUpVis Set MC_NDate=:McNDate,MC_NTime=:McNTime Where MC_RowID=:McID)
	//.i SQLCODE'=0 s quitflag="1"
	
	Q quitflag
}

/// Descript:	当前登录用户权限
/// InPut:      CstID - 会诊ID  LgParam-用户
/// OutPut:     IsPerFlag  0:无权限 1:申请医师 2:会诊医师  
/// IsLgUser:0 无权限 IsLgUser:1 申请医师 IsLgUser:2 会诊医师
/// W ##Class(web.DHCMDTFolUpVis).GetIsPerFlag("8","2^95^29^10209")
ClassMethod GetIsPerFlag(CstID As %String, LgParam As %String = "")
{
	N (CstID,LgParam)
	S ^yangyongtao("GetIsPerFlag")=$lb(CstID,LgParam)
	S IsPerFlag=0
	S LgUserID=$p(LgParam,"^",4)
	S LgLocID=$p(LgParam,"^",2)
	S IsCstUser="",IsCsUser=""
	s CstRUserID=$p(^DHCMDTCON(CstID),"^",5)  /// 申请医生
	s:LgUserID=CstRUserID IsCstUser=1
	s:IsCstUser=1 IsPerFlag=1 
	b ;1
	S CH=""
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:(CH="")||(IsCsUser'="")  D
	.s CsLocID=$p($g(^DHCMDTCON(CstID,"I",CH)),"^",1)       /// 会诊科室
	.s CareProvID=+$p($g(^DHCMDTCON(CstID,"I",CH)),"^",2)
	.s PrvTpID=$p(^DHCMDTCON(CstID,"I",CH),"^",4)       /// 职称
	.i CareProvID=0 s CareProvID=+$p($g(^DHCMDTCON(ID,"I",CH)),"^",3)
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	.s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
   	.s:(+CsUserID'=0)&&(CsUserID=LgUserID) IsCsUser=1            /// 当前登录人是否会诊医师
	.s:(IsCsUser=1) IsPerFlag=2
	Q IsPerFlag
}

/// Descript:	当前记录是否可以反馈
/// InPut:      CstID - 会诊ID  McDate-日期
/// OutPut:     IsFloVis  0:不可以 1:可以 
/// W ##Class(web.DHCMDTFolUpVis).GetIsFloVis("107","2020-04-09")
ClassMethod GetIsFloVis(CstID As %String, McDate As %String = "")
{
	N (CstID,McDate)
	//S ^yangyongtao("GetIsFloVis")=$lb(CstID,McDate)
	S IsFloVis=1
	S RlyFlag=""
    S ReplyArr=##Class(web.DHCMDTFolUpVis).IsExpReply(CstID)
    S:ReplyArr["#" RlyFlag=$p(ReplyArr,"#",1)
    s:McDate'="" McDate=##class(web.DHCMDTCom).DateHtmlToLogical(McDate)
    I (+$H<McDate)&&(RlyFlag'=1) S IsFloVis=0
	Q IsFloVis
}

/// Creator: 	yangyongtao
/// CreateDate: 2020-03-09
/// Descript:	本次会诊是否已经随访
/// Input:      CstID - 会诊ID
/// Output:     
/// W ##Class(web.DHCMDTFolUpVis).GetIsFeedBack("132")
ClassMethod GetIsFeedBack(CstID As %String) As %String
{
	n (CstID)
    S IsFBack="0"
	s McID=""
	F  s McID=$o(^DHCMDTFUV(0,"MdtCst",CstID,McID)) Q:(McID="")||(IsFBack="1")  D
	.s CstID=$p(^DHCMDTFUV(McID),"^",1)       		///会诊ID
	.s McLocID=$p(^DHCMDTFUV(McID),"^",4)       	///随访(回复)科室
	.s McUserID=$p(^DHCMDTFUV(McID),"^",7)      	///随访医师/回复专家
	.s McType=$p(^DHCMDTFUV(McID),"^",9)      		///类型 F-随访，R-回复
	.i (McType="F")&&(McUserID'="") S IsFBack="1"
	Q IsFBack
}

/// W ##Class(web.DHCMDTFolUpVis).GetLastMcID("110")
ClassMethod GetLastMcID(ID)
{
	n (ID)
	s Ret=""
	s McID=""
	f  s McID=$o(^DHCMDTFUV(0,"MdtCst",ID,McID),-1) Q:(McID="")||(Ret'="")  D
	.s McType=$p(^DHCMDTFUV(McID),"^",9)      		///类型 F-随访，R-回复
	.q:McType'="F"
	.s Ret=McID
	Q Ret
}

}
