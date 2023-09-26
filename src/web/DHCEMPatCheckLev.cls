Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-04-25
/// Descript: 	新版登记注册和预检分诊类
Class web.DHCEMPatCheckLev Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  保存检查申请记录
/// PatListData = 病人ID^登记号^姓名^身份证^性别^出生日期^国籍^民族^联系电话^家庭地址^卡号ID^卡号^登记人
/// w ##Class(web.DHCEMPatCheckLev).saveEmRegPat("PatListData")
ClassMethod saveEmRegPat(PatListData As %String, EmPatModFlag As %String, LgParams As %String, ChkComputerIP = "") As %String
{
	n (PatListData, EmPatModFlag, LgParams, ChkComputerIP, %session)
	
	s Err = 0
	TS
	/// 数据一致性检查
	s Err=##Class(web.DHCEMPatCheckLev).CheckDataConsist(PatListData)
	i Err<0 tro
	q:Err<0 Err
	
	/// 保存病人信息
	s PatientID=##Class(web.DHCEMPatCheckLev).savePatInfo(PatListData,LgParams)
	i PatientID<0 tro
	q:PatientID<0 PatientID
	
	/// 保存卡信息
	s EmCardNoID=##Class(web.DHCEMPatCheckLev).saveCardInfo(PatientID,PatListData,LgParams,ChkComputerIP)
	i EmCardNoID<0 tro
	q:EmCardNoID<0 EmCardNoID
	
	/// 分诊登记
	i EmPatModFlag = ""  D
	.s Err=##Class(web.DHCEMPatCheckLev).InsEmPatReg(PatientID,EmCardNoID,PatListData)
	i Err<0 tro
	q:Err<0 Err
	TC
	///Q 0
	Q PatientID
}

/// Descript:  保存急诊分诊
/// EmListData = 分诊护士^推荐分级^护士分级^护士分级原因^去向分区^分诊科室^重返标识^成批就诊^成批就诊人数^既往史
///     病人来源^来诊方式^意识状态^筛查^用药情况^用药情况描述^辅助物^辅助物描述^生命体征^症状表^症状描述
///     复合伤^ECG^中毒^疼痛^疼痛分级^疼痛范围^疼痛日期^疼痛时间^吸氧^请假
/// w ##Class(web.DHCEMPatCheckLev).saveEmPatCheckLev("","4636^^4^^3^266^^^^^^^^^^^^^"_$c(1,1,1,1,1,1,1)_"^^^^^^^^^^^^^^22^12^1788,266^^^^2#266#4636#199^N^^^^","22^0000000022^检查测试1^^1^03/03/1993^1^1^^^^^4636^1^25岁^2^","","","2^266^4636^199")
ClassMethod saveEmPatCheckLev(EmPCLvID As %String, EmListData As %String, PatListData As %String, strAIS As %String, strGCS As %String, LgParams As %String, strESI As %String, strFALL As %String, strREMS As %String, strMEWS As %String, autoScore As %String, strPAIN As %String, ChkComputerIP = "", otherScore = "", strChildEmr = "") As %String
{
	n (EmPCLvID,EmListData,PatListData,strAIS,strGCS,LgParams,strESI,strFALL,strREMS,strMEWS,autoScore,strPAIN,ChkComputerIP,otherScore,strChildEmr,%session)
	
	;s ^qqa("saveEmPatCheckLev") = $lb(EmPCLvID,EmListData,PatListData,strAIS,strGCS,LgParams,strESI,strFALL,strREMS,strMEWS,autoScore,strPAIN,ChkComputerIP,otherScore,strChildEmr)
	
	s AddChk=$case(EmPCLvID,"":"1",:"")
	s EmWardID=""
	s EmPatWardID=$p(EmListData,"^",41)                 /// 抢救病区
	s:+EmPCLvID'=0 EmWardID=$p(^DHCEMPCL(EmPCLvID),"^",47)         /// 病区
	s PatientID = $p(PatListData,"^",1)  /// 病人ID
	s AddPatFlag = ""
	s:+PatientID=0 AddPatFlag=1
	s Err = 0
	/// 分诊模式	
	s PatRegType=##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("PATTYPE",LgParams)
	/// 是否插入挂号记录
	s InsertFlag=##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("INSERTDOC",LgParams)
	/// 号别是否发生变化
	s changeFlag=..checkCare(EmPCLvID,EmListData)
	/// 会诊建档时是否自动关联一个条形码
	s AddDefCard=##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("ADDDEFCARD",LgParams)
	
	//q:##Class(web.DHCEMPatCheckLev).checkRBCSessionType(EmPCLvID,EmListData)=1 -9
	
	//判断病人是否留观 
	s checkStay=##Class(web.DHCEMPatCheckLev).CheckStayFlag(EmPCLvID,PatListData,EmListData)   //病人是否留观
	q:(checkStay'=0)&&(+EmPCLvID'=0)&&(changeFlag'=1) "-77^病人正在留观或抢救，不能修改分诊科室、号别和抢救病区"    
	q:(checkStay'=0)&&(+EmPCLvID=0)&&(EmPatWardID'="") "-77^病人正在留观或抢救,不能直接分诊进入留观室"  
	q:(checkStay'=0)&&(+EmPCLvID'=0)&(EmPatWardID'=EmWardID) "-77^病人正在留观或抢救，不能修改分诊科室、号别和抢救病区"    
	
	TS
	/// 数据一致性检查
	s Err=##Class(web.DHCEMPatCheckLev).CheckDataConsist(PatListData)
	i Err<0 tro
	q:Err<0 Err
	
	/// 检查号别是否发生变化
	s retFlag=0
	i PatRegType'=1 s retFlag=..IsCarProChange(EmPCLvID,EmListData)
	i retFlag<0 tro
	q:retFlag<0 retFlag
	
	/// 保存病人信息 按配置是否可以修改病人信息 zhouxin 
	s PatientID=##Class(web.DHCEMPatCheckLev).savePatInfo(PatListData,LgParams)
	i PatientID<0 tro
	q:PatientID<0 PatientID
	
	/// 保存卡信息
	s rtn=##Class(web.DHCEMPatCheckLev).saveCardInfo(PatientID,PatListData,LgParams,ChkComputerIP)
	s err=$p(rtn,$c(1),1)
	s EmCardNoID=$p(rtn,$c(1),6)
	s:$p(rtn,$c(1),1)>=0 err=0,EmCardNoID=rtn
	i err'=0 tro
	q:err'=0 "-991^"_##class(web.DHCDocService).GetNewCardErrMsg(err)_"("_rtn_")"
	
	///
	;i (AddPatFlag=1)&&($p(PatListData,"^",11)="") d
	;.q:AddDefCard'=1
	;.s $p(PatListData,"^",14)="1"	    /// 卡号ID:条形码
	;.s $p(PatListData,"^",12)=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	;.s rtn=##Class(web.DHCEMPatCheckLev).savePatCardInfo(PatientID,PatListData,LgParams,ChkComputerIP)
	;.s err=$p(rtn,$c(1),1)
	;.s EmCardNoID=$p(rtn,$c(1),6)
	;.s:$p(rtn,$c(1),1)>=0 err=0,EmCardNoID=rtn
	;i err'=0 tro
	;q:err'=0 "-992^"_##class(web.DHCDocService).GetNewCardErrMsg(err)_"("_rtn_")"
	
	i +EmPCLvID'=0 d
	.s $p(EmListData,"^",34)=$p(^DHCEMPCL(EmPCLvID),"^",2)
	e  d
	./// 分诊登记 一天只插一次 modify zhouxin
	.s Err=##Class(web.DHCEMPatCheckLev).InsEmPatReg(PatientID,EmCardNoID,PatListData)
	.i Err<0 tro
	.s $p(EmListData,"^",34)=$o(^DOCEMREGi(0,"PAPMIDate",+$h,PatientID,""))
	q:Err<0 Err
	
	s $p(EmListData,"^",33)=PatientID     ///  病人ID
	
	/// 预检分级
	s EmPCLvID=##Class(web.DHCEMPatCheckLev).EmPatCheckLev(EmPCLvID,EmListData)
	i EmPCLvID<0 tro
	q:EmPCLvID<0 EmPCLvID

	/// 删除预检分级关联表
	s Err=##Class(web.DHCEMPatCheckLev).delEmPatChkLevRefTbl(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 Err

	/// 预检生命体征
	s Err=##Class(web.DHCEMPatCheckLev).InsEmPatChkSign(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-12"
		
	/// 预检既往史
	s Err=##Class(web.DHCEMPatCheckLev).InsEmPatChkHis(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	/// 预检号别表
	s Err=##Class(web.DHCEMPatCheckLev).InsEmPatChkCare(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	/*  /// 注释：不能更新病人号别，如需更换，重新挂号 bianshuai 2017-02-25
	/// 更新病人就诊队列
	i PatRegType=1 d
	.s Err=##Class(web.DHCEMPatCheckLev).SetPatAdmQueue(EmListData)
    i Err'=0 tro
	q:Err'=0 "-15"
	*/

	/// 预检分诊就诊表
	s Err=##Class(web.DHCEMPatCheckLev).InsEmPatChkAdm(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-16"

	//保存创伤评分
	s Err=##Class(web.DHCEMPatCheckLevQuery).saveEmPatChkAISBySql(EmPCLvID,strAIS) 
	i Err'=0 tro
	q:Err'=0 "-18"
	
	//保存格拉斯哥昏迷
	s Err=##Class(web.DHCEMPatCheckLev).saveEmPatChkGCS(EmPCLvID,strGCS)
	i Err'=0 tro
	q:Err'=0 "-19"
	
	
	//保存坠跌评分
	s Err=##Class(web.DHCEMPatCheckLev).saveEmPatChkFALL(EmPCLvID,strFALL)
	i Err'=0 tro
	q:Err'=0 "-26"
	
	//保存ESI评分
	s Err=##Class(web.DHCEMPatCheckLev).saveEmPatChkESI(EmPCLvID,strESI)
	i Err'=0 tro
	q:Err'=0 "-27"
	
	//保存REMS评分
	s Err=##Class(web.DHCEMPatCheckLev).saveEmPatChkREMS(EmPCLvID,strREMS)
	i Err'=0 tro
	q:Err'=0 "-28"
	
	//保存MEWS评分
	s Err=##Class(web.DHCEMPatCheckLev).saveEmPatChkMEWS(EmPCLvID,strMEWS)
	i Err'=0 tro
	q:Err'=0 "-29"
	
	//保存自动评分项
	s Err=##Class(web.DHCEMPatCheckLev).saveEmPatChkAutoScore(EmPCLvID,autoScore)
	i Err'=0 tro
	q:Err'=0 "-30"
	
	//保存疼痛评分
	s Err=##Class(web.DHCEMPatCheckLev).SaveEmPatChkPain(EmPCLvID,strPAIN)
	i Err'=0 tro
	q:Err'=0 "-31"
	
	//保存其他评分：RTS评分
	s Err=##Class(web.DHCEMPatCheckLev).SaveEmPatChkOtherScore(EmPCLvID,otherScore,LgParams)
	i Err'=0 tro
	q:Err'=0 "-32"
	
	//保存儿童预警评分
	s Err=##Class(web.DHCEMPatCheckLev).SaveEmChildEmr(EmPCLvID,strChildEmr)
	i Err'=0 tro
	q:Err'=0 "-33"

	/// 绿色通道 2017-02-28 bianshuai //hxy 2022-08-26 上移
	s:AddChk Err=##Class(web.DHCEMPatCheckLev).InsEmPatGreen(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-21"

	s InsEpiFlag=$p(EmListData,"^",42)                  /// 插入挂号记录标示
	s HasEpiFlag=..HasPatChkLvEpi(EmPCLvID) 			/// 分诊就诊记录是否可用
	i PatRegType'=1 d 								    /// 
	.Q:(PatRegType=2)&(InsertFlag'=1)  	  			    /// 先分诊,需要判断是否插入挂号标志 bianshuai 2017-03-08
	.Q:(PatRegType=3)&((InsEpiFlag'=1)||((HasEpiFlag=1)&(changeFlag=1))) /// 第3、4模式,判断是否是绿色通道或危重病人 bianshuai 2017-03-08
	.Q:(PatRegType=4)&(InsEpiFlag'=1)&(InsertFlag'=1)
	.Q:(changeFlag=1)&(HasEpiFlag=1)
	.s Err=##Class(web.DHCEMPatCheckLev).InsEmPatDocReg(EmPCLvID,EmListData,retFlag,LgParams)
	.;s:+Err=-213 Err="-213^号别停止挂号!"
	i Err'=0 tro
	q:Err'=0 "-27^"_$tr(Err,"||","1")
	
#;	/// 绿色通道 2017-02-28 bianshuai //hxy 2022-08-26 注释(上移)
#;	s:AddChk Err=##Class(web.DHCEMPatCheckLev).InsEmPatGreen(EmPCLvID,EmListData)
#;	i Err'=0 tro
#;	q:Err'=0 "-21"
	
	/// 抢救病区 2017-03-08 bianshuai
	s Err=##Class(web.DHCEMPatCheckLev).InsEmPatWard(EmPCLvID,EmListData)   ///非留观病人,修改病人状态为抢救
	i Err'=0 tro
	q:Err'=0 "-22"
	
	/// 预检分级 2017-03-08 bianshuai
	s Err=##Class(web.DHCEMPatCheckLev).InsAdmPatChkLv(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-23"
	
	/// 修改分级 2018-03-09 bianshuai
	s Err=##Class(web.DHCEMPatCheckLev).InsEmDocUpdPatLev(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-24"
	
	//保存六大病种
	s Err=##Class(web.DHCEMPatCheckLev).InsEmPatChkSpec(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-25"
	
	//保存症状
	s Err=##Class(web.DHCEMPatCheckLev).InsEmPatChkSm(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-26"
	
	/// 插入生命体征类别 2022-07-25 cy
	s Err=##Class(web.DHCEMPatCheckLev).InsVitalsigns(EmPCLvID,EmListData)
	i Err'=0 tro
	q:Err'=0 "-27"	
	TC
	Q EmPCLvID_"^"_PatientID_"^"_..GetEpiAdm(EmPCLvID)
}

/// Descript:分诊是否满足插入就诊条件,入参跟就诊保持一致
/// Return:1(满足),其他:不满足
/// W ##Class(web.DHCEMPatCheckLev).ChkLevIsInsAdm("74","","")
ClassMethod ChkLevIsInsAdm(EmPCLvID, EmListData, LgParams)
{
	n (EmPCLvID, EmListData, LgParams)
	
	s RetFlag = ##Class(web.DHCEMPatCheckLev).IsCarProChange(EmPCLvID,EmListData)
	q:RetFlag<0 "已经就诊,不允许修改号别!"
	
	/// 分诊模式	
	s PatRegType=##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("PATTYPE",LgParams)
	/// 是否插入挂号记录
	s InsertFlag=##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("INSERTDOC",LgParams)
	/// 号别是否发生变化
	s changeFlag=..checkCare(EmPCLvID,EmListData)
	
	s InsEpiFlag=$p(EmListData,"^",42)                  /// 插入挂号记录标示
	s HasEpiFlag=..HasPatChkLvEpi(EmPCLvID) 			/// 分诊就诊记录是否可用
	
	s Ret=""
	i PatRegType'=1 d 								    /// 
	.Q:(PatRegType=2)&(InsertFlag'=1)  	  			    /// 先分诊,需要判断是否插入挂号标志 bianshuai 2017-03-08
	.Q:(PatRegType=3)&((InsEpiFlag'=1)||((HasEpiFlag=1)&(changeFlag=1))) /// 第3、4模式,判断是否是绿色通道或危重病人 bianshuai 2017-03-08
	.Q:(PatRegType=4)&(InsEpiFlag'=1)&(InsertFlag'=1)
	.Q:(changeFlag=1)&(HasEpiFlag=1)
	.s Ret=1
	q:Ret'=1 "当前分诊条件不满足【自动挂号】或【号别未变化】"
	q Ret
}

ClassMethod GetEpiAdm(EmPCLvID As %String) As %String
{
	n (EmPCLvID)
	s EpisodeID=0
	s EmAdmID=""
	F  s EmAdmID=$o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,EmAdmID)) Q:(EmAdmID="")||(EpisodeID'=0)  D
	.s EpisodeID=+$p(^DHCEMPCA(EmAdmID),"^",2)
	Q EpisodeID
}

/// Descript: 判断病人是否留观
/// W ##Class(web.DHCEMPatCheckLev).CheckStayFlag("74","","")
ClassMethod CheckStayFlag(EmPCLvID As %String = "", PatListData As %String, EmListData As %String) As %String
{
	n (EmPCLvID,PatListData,EmListData)
	
	s EmPatWardID=$p(EmListData,"^",41)                 /// 抢救病区
	s PatNo = $p(PatListData,"^",2)      		      /// 登记号
	
	s checkStayFlag=0
	q:PatNo="" checkStayFlag
	s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
    i papmiId'="" d
    .s EpisodeID=""
    .f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:(EpisodeID="")||(checkStayFlag'=0)  d  
    ..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..q:(pavisit'="A")
	..s stayStatus=##class(web.DHCEMPatCheckLev).IsStaying(EpisodeID)
	..s:stayStatus=1 checkStayFlag="-77^病人正在留观或抢救,不能分诊"
	q:checkStayFlag'=0 checkStayFlag
	q 0
}

/// 是否正在留观1：是，0：不是
ClassMethod IsStaying(EpisodeID)
{
	s ObsWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	q:ObsWardId'="" 1
	s ObsWardId=$o(^PAWARDA(0,"WADM",EpisodeID,""))
	q:ObsWardId'="" 1
	q 0
}

/// Descript: 插入急诊病人登记表
/// W ##Class(web.DHCEMPatCheckLev).InsEmPatReg("10^10^I^2506^2506")
ClassMethod InsEmPatReg(PatientID As %String, EmCardNoID As %String, ListData As %String) As %String
{
	n (PatientID, EmCardNoID, ListData)
	s EmPreStatus="I"  ///$p(ListData,"^",3)     ///  登记状态
	s EmPreNurseID=$p(ListData,"^",13)    ///  预检护士
	s EmCreateUserID=$p(ListData,"^",13)  ///  登记用户
	
	s EmCreateDate=+$H   				 ///  申请日期
	s EmCreateTime=$p($H,",",2)   		 ///  申请时间
	s reg=$o(^DOCEMREGi(0,"PAPMIDate",+$h,PatientID,""))
	q:+reg'=0 0
	///一天只能登记一次
	&SQL(Insert Into DHC_DocEmReg(EM_PAPMI_DR,EM_DHCCARD_DR,ER_DateCreate,ER_TimeCreate,ER_CreateUserDR,EM_PreviewStatus,EM_PreviewNurse_DR,EM_LastUpdateUser_DR)
		values(:PatientID,:EmCardNoID,:EmCreateDate,:EmCreateTime,:EmCreateUserID,:EmPreStatus,:EmPreNurseID,:EmPreNurseID))
	i SQLCODE'=0  q SQLCODE
	//q +%ROWID
	q SQLCODE
}

/// Descript:	保存预检分级信息
ClassMethod EmPatCheckLev(EmPCLvID As %String, EmListData As %String) As %String
{
	n (EmPCLvID, EmListData)
	i EmPCLvID = ""  D
	.s EmPCLvID=##Class(web.DHCEMPatCheckLev).InsEmPatCheckLev(EmListData)
	E  D
	.s EmPCLvID=##Class(web.DHCEMPatCheckLev).UpdEmPatCheckLev(EmPCLvID,EmListData)
	q EmPCLvID
}

/// Descript:	插入预检分级信息
ClassMethod InsEmPatCheckLev(ListData As %String) As %String
{
	n (ListData)
	
	s UserID=$p(ListData,"^",1)        ///  分诊护士
	s RecLevel=$p(ListData,"^",2)      ///  推荐分级
	s NurseLevel=$p(ListData,"^",3)    ///  护士分级
	s NurReaID=$p(ListData,"^",4)      ///  护士分级原因
	s AreaCode=$p(ListData,"^",5)      ///  去向分区
	s LocID=+$p(ListData,"^",6)        ///  分诊科室
	s AgainFlag=$p(ListData,"^",7)     ///  重返标识
	s BatchFlag=$p(ListData,"^",8)     ///  成批就诊
	s BatchNum=$p(ListData,"^",9)      ///  成批就诊人数
	s SouID=$p(ListData,"^",11)        ///  病人来源
	s AdmWayID=$p(ListData,"^",12)     ///  来诊方式
	s AwID=$p(ListData,"^",13)         ///  意识状态
	s ScreenFlag=$p(ListData,"^",14)   ///  筛查
	s HisDrug=$p(ListData,"^",15)      ///  用药情况
	s HisDrugDesc=$p(ListData,"^",16)  ///  用药情况描述
	s Material=$p(ListData,"^",17)     ///  辅助物
	s MaterialDesc=$p(ListData,"^",18) ///  辅助物描述
	s SymID=$p(ListData,"^",20)        ///  症状表
	s SymDesc=$p(ListData,"^",21)      ///  症状描述
	s CombFlag=$p(ListData,"^",22)     ///  复合伤
	s ECGFlag=$p(ListData,"^",23)      ///  ECG
	s PoisonFlag=$p(ListData,"^",24)   ///  中毒
	s PainFlag=$p(ListData,"^",25)     ///  疼痛
	s PainLev=$p(ListData,"^",26)      ///  疼痛分级
	s PainRange=$p(ListData,"^",27)    ///  疼痛范围
	s PainDate=$p(ListData,"^",28)     ///  疼痛日期
	s:PainDate'="" PainDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(PainDate) //hxy 2017-03-02 $zdh(PainDate,3)
	s PainTime=$p(ListData,"^",29)     ///  疼痛时间
	s:PainTime'="" PainTime=$zth(PainTime,1)
	s OxygenFlag=$p(ListData,"^",30)   ///  吸氧
	s PatAskFlag=$p(ListData,"^",31)   ///  请假
	s EmOtherDesc=$p(ListData,"^",32)  ///  其他
	
	s PatientID=$p(ListData,"^",33)     ///  病人ID
	s EmRegID=$p(ListData,"^",34)       ///  登记表ID
	s AdmID=$p(ListData,"^",36)       ///  就诊号
	s PatTypeID=$p(ListData,"^",37)       ///  特殊人群 2016-09-05 congyue
	s EmToLocID=+$p(ListData,"^",38)         ///  转向科室
	s PChkHisOther=$p(ListData,"^",39)      /// yuliping 其他既往史
	s DateInfo=$p(ListData,"^",53)
	s CreateDate=+$H
	s CreateTime = $p($h,",",2)
	s PCLDate=$p(DateInfo," ",1)
	s PCLTime=$p(DateInfo," ",2)
	s:PCLDate'="" PCLDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(PCLDate)
	s:PCLDate="" PCLDate=+$H   				   ///  分诊日期
	s:PCLTime'="" PCLTime=$zth(PCLTime,1)
	s:PCLTime="" PCLTime=$p($H,",",2)   	   ///  分诊时间
	
	s AisFlag =$p(ListData,"^",43)     ///	创伤标记
	s GcsFlag=$p(ListData,"^",44) 	   ///  格拉斯哥标记
	s EmWardID=$p(ListData,"^",41) 	   ///  抢救病区 bianshuai 2017-03-14
	s PCLNotes = $p(ListData,"^",52) ;$p(AddNotes,"^",1)    ///  分诊备注
	s:+EmToLocID'=0 LocID=""
	&SQL(Insert Into DHC_EmPatCheckLev(PCL_PAPMI_Dr,PCL_Reg_Dr,PCL_Creator_Dr,PCL_CreateDate,PCL_CreateTime,PCL_RecLevel,PCL_NurseLevel,PCL_NurRea_Dr,PCL_Area,PCL_Loc_Dr,
		PCL_AgainFlag,PCL_BatchFlag,PCL_BatchNum,PCL_Sou_Dr,PCL_AdmWay_Dr,PCL_Aw_Dr,PCL_ScreenFlag,PCL_HisDrug,PCL_HisDrugDesc,PCL_Material,PCL_MaterialDesc,
		PCL_Sym_Dr,PCL_SymDesc,PCL_CombFlag,PCL_ECGFlag,PCL_PoisonFlag,PCL_PainFlag,PCL_PainLev,PCL_PainRange,PCL_PainDate,PCL_PainTime,PCL_OxygenFlag,PCL_PatAskFlag,
		PCL_Other,PCL_Adm_Dr,PCL_PatType_Dr,PCL_ToLoc_Dr,PCL_His_Dr,PCL_GcsFlag,PCL_AisFlag,PCL_Ward_Dr,PCL_Notes)
		Values(:PatientID,:EmRegID,:UserID,:CreateDate,:CreateTime,:RecLevel,:NurseLevel,:NurReaID,:AreaCode,:LocID,:AgainFlag,:BatchFlag,:BatchNum,:SouID,:AdmWayID,:AwID,:ScreenFlag,
		:HisDrug,:HisDrugDesc,:Material,:MaterialDesc,:SymID,:SymDesc,:CombFlag,:ECGFlag,:PoisonFlag,:PainFlag,:PainLev,:PainRange,:PainDate,:PainTime,:OxygenFlag,:PatAskFlag,:EmOtherDesc,
		:AdmID,:PatTypeID,:EmToLocID,:PChkHisOther,:GcsFlag,:AisFlag,:EmWardID,:PCLNotes))
		
	//取消修改来诊时间
	//PCL_Other,PCL_Adm_Dr,PCL_PatType_Dr,PCL_ToLoc_Dr,PCL_His_Dr,PCL_GcsFlag,PCL_AisFlag,PCL_Ward_Dr,PCL_Notes,PCL_Date,PCL_Time)
	//:AdmID,:PatTypeID,:EmToLocID,:PChkHisOther,:GcsFlag,:AisFlag,:EmWardID,:PCLNotes,:PCLDate,:PCLTime))

	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript:	更新预检分级信息
ClassMethod UpdEmPatCheckLev(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID, ListData)
	s RecLevel=$p(ListData,"^",2)      ///  推荐分级
	s NurseLevel=$p(ListData,"^",3)    ///  护士分级
	s NurReaID=$p(ListData,"^",4)      ///  护士分级原因
	s AreaCode=$p(ListData,"^",5)      ///  去向分区
	s LocID=+$p(ListData,"^",6)
	s AgainFlag=$p(ListData,"^",7)     ///  重返标识
	s BatchFlag=$p(ListData,"^",8)     ///  成批就诊
	s BatchNum=$p(ListData,"^",9)      ///  成批就诊人数
	s SouID=$p(ListData,"^",11)        ///  病人来源
	s AdmWayID=$p(ListData,"^",12)     ///  来诊方式
	s AwID=$p(ListData,"^",13)         ///  意识状态
	s ScreenFlag=$p(ListData,"^",14)   ///  筛查
	s HisDrug=$p(ListData,"^",15)      ///  用药情况
	s HisDrugDesc=$p(ListData,"^",16)  ///  用药情况描述
	s Material=$p(ListData,"^",17)     ///  辅助物
	s MaterialDesc=$p(ListData,"^",18) ///  辅助物描述
	s SymID=$p(ListData,"^",20)        ///  症状表
	s SymDesc=$p(ListData,"^",21)      ///  症状描述
	s CombFlag=$p(ListData,"^",22)     ///  复合伤
	s ECGFlag=$p(ListData,"^",23)      ///  ECG
	s PoisonFlag=$p(ListData,"^",24)   ///  中毒
	s PainFlag=$p(ListData,"^",25)     ///  疼痛
	s PainLev=$p(ListData,"^",26)      ///  疼痛分级
	s PainRange=$p(ListData,"^",27)    ///  疼痛范围
	s PainDate=$p(ListData,"^",28)     ///  疼痛日期
	s:PainDate'="" PainDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(PainDate) //hxy $zdh(PainDate,3)
	s PainTime=$p(ListData,"^",29)     ///  疼痛时间
	s:PainTime'="" PainTime=$zth(PainTime,1)
	s OxygenFlag=$p(ListData,"^",30)   ///  吸氧
	s PatAskFlag=$p(ListData,"^",31)   ///  请假
	s EmOtherDesc=$p(ListData,"^",32)  ///  其他
	s PatTypeID=$p(ListData,"^",37)          ///  特殊人群 2016-09-05 congyue
	s EmToLocID=+$p(ListData,"^",38)         ///  转向科室
	s PChkHisOther=$p(ListData,"^",39)       /// yuliping 其他既往史
	s AisFlag =$p(ListData,"^",43)     ///	创伤标记
	s GcsFlag=$p(ListData,"^",44) 	   ///  格拉斯哥标记
	//s EmWardID=+$p(^DHCEMPCL(EmPCLvID),"^",47)  /// 病区
	s EmWardID=$p(ListData,"^",41) /// 抢救病区 bianshuai 2017-03-14
	s PCLNotes = $p(ListData,"^",52)  ;$p(AddNotes,"^",1)
	s DateInfo=$p(ListData,"^",53)
	s CreateDate=+$H
	s CreateTime = $p($h,",",2) 
	s PCLDate=$p(DateInfo," ",1)
	s PCLTime=$p(DateInfo," ",2)
	s:PCLDate'="" PCLDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(PCLDate)
	s:PCLDate="" PCLDate=+$H   				   ///  分诊日期
	s:PCLTime'="" PCLTime=$zth(PCLTime,1)
	s:PCLTime="" PCLTime=$p($H,",",2)   	   ///  分诊时间
	
	s:+EmToLocID'=0 LocID=0
	
	;PCL_CreateDate=:CreateDate,PCL_CreateTime=:CreateTime,
	&SQL(Update DHC_EmPatCheckLev Set PCL_RecLevel=:RecLevel,PCL_NurseLevel=:NurseLevel,PCL_NurRea_Dr=:NurReaID,PCL_Area=:AreaCode,PCL_AgainFlag=:AgainFlag,
		PCL_BatchFlag=:BatchFlag,PCL_BatchNum=:BatchNum,PCL_Sou_Dr=:SouID,PCL_AdmWay_Dr=:AdmWayID,PCL_Aw_Dr=:AwID,PCL_ScreenFlag=:ScreenFlag,PCL_HisDrug=:HisDrug,
		PCL_HisDrugDesc=:HisDrugDesc,PCL_Material=:Material,PCL_MaterialDesc=:MaterialDesc,PCL_Sym_Dr=:SymID,PCL_SymDesc=:SymDesc,PCL_CombFlag=:CombFlag,PCL_ECGFlag=:ECGFlag,
		PCL_PoisonFlag=:PoisonFlag,PCL_PainFlag=:PainFlag,PCL_PainLev=:PainLev,PCL_PainRange=:PainRange,PCL_PainDate=:PainDate,PCL_PainTime=:PainTime,PCL_OxygenFlag=:OxygenFlag,
		PCL_PatAskFlag=:PatAskFlag,PCL_Other=:EmOtherDesc,PCL_PatType_Dr=:PatTypeID,PCL_ToLoc_Dr=:EmToLocID,PCL_Loc_Dr=:LocID,PCL_His_Dr=:PChkHisOther,PCL_AisFlag=:AisFlag,
		PCL_GcsFlag=:GcsFlag,PCL_Ward_Dr=:EmWardID, PCL_Notes=:PCLNotes,PCL_Date=:PCLDate,PCL_Time=:PCLTime
		 Where PCL_RowID=:EmPCLvID)
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript:	预检生命体征
ClassMethod InsEmPatChkSign(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID, ListData)
	
	s signListData=$p(ListData,"^",19)       ///  生命体征
	s Len=$L(signListData,"||")
	s PCSDate=+$h //hxy 2020-03-17
	s quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.s EmPcsListData=$p(signListData,"||",i)
	.s EmPcsTime=$p(EmPcsListData,$C(1),1)   ///  时间
	.s:EmPcsTime'="" EmPcsTime=$zth(EmPcsTime,1)
	.s EmPcsTemp=$p(EmPcsListData,$C(1),2)   ///  体温
	.s EmPcsHeart=$p(EmPcsListData,$C(1),3)  ///  心率HR
	.s EmPcsPulse=$p(EmPcsListData,$C(1),4)  ///  脉搏R
	.s EmPcsSBP=$p(EmPcsListData,$C(1),5)    ///  血压(BP)收缩压
	.s EmPcsDBP=$p(EmPcsListData,$C(1),6)    ///  血压(BP)舒张压
	.s EmPcsSoP2=$p(EmPcsListData,$C(1),7)   ///  血氧饱合度SoP2
	.s EmPcsBreath=$p(EmPcsListData,$C(1),8)   ///  呼吸频率
	.s EmPcsGLU = $p(EmPcsListData,$C(1),9)
	.&SQL(Insert Into DHC_EmPatChkSign(PCS_Chk_Dr,PCS_Time,PCS_Temp,PCS_Heart,PCS_PCS_Pulse,PCS_SBP,PCS_DBP,PCS_SoP2,PCS_Breathe,PCS_GLU,PCS_Date)
		Values(:EmPCLvID,:EmPcsTime,:EmPcsTemp,:EmPcsHeart,:EmPcsPulse,:EmPcsSBP,:EmPcsDBP,:EmPcsSoP2,:EmPcsBreath,:EmPcsGLU,:PCSDate))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:	预检既往史
ClassMethod InsEmPatChkHis(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID, ListData)
	s EmPchListData=$p(ListData,"^",10)        ///  既往史
	s Len=$L(EmPchListData,$C(1))
	s quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.s EmPchHis=$p(EmPchListData,$C(1),i)      ///  既往史
	.
	.&SQL(Insert Into DHC_EmPatChkHis(PCH_Chk_Dr,PCH_His_Dr)
		Values(:EmPCLvID,:EmPchHis))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:	六大病种
ClassMethod InsEmPatChkSpec(EmPCLvID As %String, EmListData As %String) As %String
{
	n (EmPCLvID,EmListData)
	s ListData = $p(EmListData,"^",46)
	q:ListData="" 0
	s QuitFlag=0
	s Len=$L(ListData,"#")
	F i=1:1:Len q:QuitFlag  d
	.s EmChkSpec=$p(ListData,"#",i)      ///  六大病种
	.
	.&SQL(Insert Into DHC_EmPatChkSpec(PCSP_Chk_Dr,PCSP_SpecDise_Dr)
		Values(:EmPCLvID,:EmChkSpec))
	.s:SQLCODE'=0 QuitFlag=1
	.
	Q QuitFlag
}

/// Descript:诊断:主诉
ClassMethod InsEmPatChkSm(EmPCLvID As %String, EmListData As %String) As %String
{
	n (EmPCLvID,EmListData)
	s Syms = $p(EmListData,"^",21)
	s Len = $l(Syms,"#")
	s InsertFlag=0
	f i=1:1:Len q:(InsertFlag'=0)  d
	.s SymDr = $p(Syms,"#",i)
	.q:SymDr=""
	.&sql(INSERT INTO DHC_EmPatChkSym (PCSY_Chk_Dr,PCSY_SymField_Dr) VALUES(:EmPCLvID,:SymDr))
	.s InsertFlag = SQLCODE
	q InsertFlag
}

/// Descript:	预检号别表
ClassMethod InsEmPatChkCare(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID, ListData)
	s EmCareListData=$p(ListData,"^",35)   		///  预检号别表
	s quitflag=0
	s Len=$L(EmCareListData,"#")
	s quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.s EmCareList=$p(EmCareListData,"#",i)
	.s EmCareID=$p(EmCareList,",",1)   ///  号别ID
	.s EmCareLoc=$p(EmCareList,",",2)  ///  科室ID
	.Q:EmCareID=""
	.
	.&SQL(Insert Into DHC_EmPatChkCare(PCC_Chk_Dr,PCC_Care_Dr,PCC_Loc_Dr)
		Values(:EmPCLvID,:EmCareID,:EmCareLoc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:   预检分诊就诊表
ClassMethod InsEmPatChkAdm(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID,ListData)
	s EmAdmListData=$p(ListData,"^",36)    ///  预检就诊ID
	s Len=$L(EmAdmListData,"#")
	s quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.s EmAdmID=$p(EmAdmListData,"#",i)   ///  就诊ID
	.Q:EmAdmID=""
	.
	.&SQL(Insert Into DHC_EmPatChkAdm(PCA_Chk_Dr,PCA_Adm_Dr)
		Values(:EmPCLvID,:EmAdmID))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// 保存格拉斯哥昏迷  guoguomin 
/// W ##Class(web.DHCEMPatCheckLev).saveEmPatChkGCS(1,"2||1#3||2#4||1#")
ClassMethod saveEmPatChkGCS(EmPCLvID As %String, strGCS As %String) As %String
{
	n (EmPCLvID, strGCS)
	q:EmPCLvID=""
	d ##class(web.DHCEMPatCheckLevQuery).clearGcs(EmPCLvID)  //清除表中数据
	q:strGCS="" "0"
	s rs=0
	for i=1:1:$l(strGCS,"#") d
	.
	.s GcsiId = $p(strGCS,"#",i)
	.q:GcsiId=""
	.s GcsId = $p(GcsiId,"||",1)
	.s count =""
	.&sql(select count(*) from DHC_EmPatChkGCS where PCG_Chk_Dr=:EmPCLvID and PCG_GCS_Dr=:GcsiId )
	.i (count>0)  d
	.. &sql(update DHC_EmPatChkGCS set PCG_GCSI_Dr =:GcsiId where PCG_Chk_Dr=:EmPCLvID and PCG_GCS_Dr=:GcsiId )
	..s rs=SQLCODE
	.e  d 
	..&sql(insert into DHC_EmPatChkGCS values(:EmPCLvID,:GcsId,:GcsiId))
	..s rs=SQLCODE
	Q rs
}

/// Cretor:     bianshuai
/// CreateDate：2017-02-27
/// Descript:   绿色通道
ClassMethod InsEmPatGreen(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID,ListData)
	
	s UserID=$p(ListData,"^",1)      	     	   /// 用户ID
	s EmPatGreenFlag=$p(ListData,"^",40)           /// 绿色通道标示
	s GreenHours=$p(ListData,"^",47)              /// 绿色通道有效时长
	s loginStr=$p(ListData,"^",39)
	s LoginGroup=$p(loginStr,"#",4)
	s ReaDr=$p(ListData,"^",56)  //申请原因
	s LoginHosp=$p(loginStr,"#",1)
	s GreenAudit=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENAUDIT",LoginHosp,"","","") //hxy 2022-07-14 开通绿色通道是否需要审核
	
	s EmAdmListData=..GetEmPatCheckLvAdm(EmPCLvID) /// 预检就诊ID
	i EmAdmListData="" s EmAdmListData="A"
	s Err=0
	F i=1:1:$L(EmAdmListData,"#") q:Err'=0  d
	.s EpisodeID=$p(EmAdmListData,"#",i)        ///  就诊ID
	.i EpisodeID="A" s EpisodeID=""
	.s mListData=EpisodeID_"^"_UserID_"^"_GreenHours_"^"_LoginGroup_"^"_ReaDr
	.s EmPatGreRes=..GetEmPatGreenCont(EmPCLvID,EpisodeID) /// 取绿色通道标示
	.s EmPatGreFlag=$p(EmPatGreRes,"^",1)
	.s EmPatGreID=$p(EmPatGreRes,"^",2)
	.i (EmPatGreFlag=0)&(EmPatGreenFlag="Y") d
	..s Err=..InsEmPatGreenDet(EmPCLvID,mListData)       /// 插入绿色通道信息
	..Q:Err'=0
	..s:GreenAudit'=1 Err=..UpdPaAdmPatGreen(EpisodeID,EmPatGreenFlag) /// 修改就诊表绿色通道信息
	.
	.i (EmPatGreFlag=1)&(EmPatGreenFlag="N") d
	..s Err=..UpdEmPatGreenDet(EmPatGreID,mListData)     /// 修改绿色通道信息
	..Q:Err'=0
	..s Err=..UpdPaAdmPatGreen(EpisodeID,EmPatGreenFlag) /// 修改就诊表绿色通道信息
	..
	.
	Q Err
}

/// Descript:   插入绿色通道信息
ClassMethod InsEmPatGreenDet(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID,ListData)
	s EmAdmID=$p(ListData,"^",1)	 /// 就诊ID
	s UserID=$p(ListData,"^",2)      /// 操作人ID
	s GreenHours=+$p(ListData,"^",3) /// 绿色通道有效时间
	s LoginGroup=$p(ListData,"^",4)  /// 登录安全组ID
	s ReasonDr=$p(ListData,"^",5)    /// 原因
	
	s EmStartDate=+$H 				 /// 开始日期 $p(ListData,"^",3)
	s EmStartTime=$p($H,",",2) 		 /// 开始时间 $p(ListData,"^",4)
	s CreateDate=+$H   				 /// 操作日期
	s CreateTime=$p($H,",",2)   	 /// 操作时间
	
	s EndDate=""
	s EndTime=""
	i GreenHours>0 d
	.s end=$SYSTEM.SQL.DATEADD("hh",GreenHours,$h)
	.s end=$zdth(end,3)
	.s EndDate=+end
	.s EndTime=$p(end,",",2)
	&SQL(Insert Into DHC_EmPatGreenRec(PGR_Chk_Dr,PGR_GreenStartDate,PGR_GreenStartTime,PGR_Adm_Dr,PGR_Operator,
		PGR_OperateDate,PGR_OperateTime,PGR_Group,PGR_GreenEndDate,PGR_GreenEndTime,PGR_Reason_Dr)
		Values(:EmPCLvID,:EmStartDate,:EmStartTime,:EmAdmID,:UserID,:CreateDate,:CreateTime,:LoginGroup,:EndDate,:EndTime,:ReasonDr))
	Q SQLCODE
}

/// Descript:   更新绿色通道信息
ClassMethod UpdEmPatGreenDet(EmPatGreID As %String, ListData As %String) As %String
{
	n (EmPatGreID,ListData)
	s UserID=$p(ListData,"^",2)      /// 操作人ID
	s EmEndDate=+$H 			     /// 结束日期  $p(ListData,"^",3)
	s EmEndTime=$p($H,",",2) 		 /// 结束时间  $p(ListData,"^",4)
	s XDate=+$H   				 	 /// 操作日期
	s XTime=$p($H,",",2)   	         /// 操作时间
	
	&SQL(update DHC_EmPatGreenRec set PGR_GreenEndDate=:EmEndDate,PGR_GreenEndTime=:EmEndTime,PGR_XOperator=:UserID,
		PGR_XOperateDate=:XDate,PGR_XOperateTime=:XTime where PGR_RowID=:EmPatGreID)
	Q SQLCODE
}

/// Descript:   更新就诊表绿色通道标示
/// ^PAC("ADMCAT",1)="01^绿色通道^61744^"
/// ^PAC("ADMCAT",2)="02^非绿色通道^61744^"
ClassMethod UpdPaAdmPatGreen(EpisodeID As %String, EmPatGreFlag As %String) As %String
{
	n (EpisodeID, EmPatGreFlag)
	Q:EpisodeID="" 0
	i EmPatGreFlag="Y" s EmPatGreID=1
	E  s EmPatGreID=2
	&SQL(Update PA_Adm Set PAADM_AdmCateg_DR=:EmPatGreID where PAADM_RowID=:EpisodeID)
	Q SQLCODE
}

/// Descript:   取绿色通道信息
ClassMethod GetEmPatGreenCont(EmPCLvID As %String, EpisodeID As %String) As %String
{
	n (EmPCLvID, EpisodeID)
	s EmPatGreFlag=0,EmPatGreenID=""
	s EmPatGreID=""
	F  s EmPatGreID=$o(^DHCEMPGR(0,"PatCheckLev",EmPCLvID,EmPatGreID)) Q:(EmPatGreID="")||(EmPatGreFlag=1)  D
	.s EmAdmID=$p(^DHCEMPGR(EmPatGreID),"^",6)    /// 就诊ID
	.Q:(EpisodeID'="")&(EpisodeID'=EmAdmID)
	.//Q:$p(^DHCEMPGR(EmPatGreID),"^",4)'=""  	  /// 结束日期
	.s endDate=+$p(^DHCEMPGR(EmPatGreID),"^",4)   ///zhouxin 2018-07-18 取绿色通道截止时间
	.Q:(endDate'=0)&&(endDate<+$h) 	              ///zhouxin 2018-07-18
	.s EndTime=+$p(^DHCEMPGR(EmPatGreID),"^",5)    /// 结束时间
	.Q:(EndTime'=0)&&(EndTime<$p($h,",",2)) 
	.s EmPatGreFlag=1
	.s EmPatGreenID=EmPatGreID
	
	Q EmPatGreFlag_"^"_EmPatGreenID
}

/// Descript:   取绿色通道标示
ClassMethod GetEmPatGreenFlag(EmPCLvID As %String, EpisodeID As %String) As %String
{
	n (EmPCLvID, EpisodeID)
	s EmPatGreFlag=0
	s EmPatGreID=""
	F  s EmPatGreID=$o(^DHCEMPGR(0,"PatCheckLev",EmPCLvID,EmPatGreID)) Q:(EmPatGreID="")||(EmPatGreFlag=1)  D
	.s EmAdmID=$p(^DHCEMPGR(EmPatGreID),"^",6)    /// 就诊ID
	.Q:(EpisodeID'="")&(EpisodeID'=EmAdmID)
	.s EndDate=$p(^DHCEMPGR(EmPatGreID),"^",4)   /// 结束日期 	              
	.s EndTime=$p(^DHCEMPGR(EmPatGreID),"^",5)    /// 结束时间
	.
	.s aliveHours=0
	.i EndDate'="" d
	..s aliveHours=$SYSTEM.SQL.DATEDIFF("hh",$h,EndDate_","_EndTime)
	.q:(EndDate'="")&&(aliveHours<0)  //绿色通道超时
	.s xUser=+$p(^DHCEMPGR(EmPatGreID),"^",10)
	.q:(xUser'=0) //取消绿色通道
	.q:##class(web.DHCEMPatGreenRec).IfPass(EmPatGreID)'=1 //是否审核通过
	.s EmPatGreFlag=1
	.
	
	Q EmPatGreFlag
}

/// Descript:   取绿色通道有效时间
/// w ##Class(web.DHCEMPatCheckLev).GetEmPatGreenHours("168","3363")
ClassMethod GetEmPatGreenHours(EmPCLvID As %String, EpisodeID As %String) As %String
{
	n (EmPCLvID, EpisodeID)
	s EmPatGreHours=""
	s EmPatGreID=""
	F  s EmPatGreID=$o(^DHCEMPGR(0,"PatCheckLev",EmPCLvID,EmPatGreID),-1) Q:(EmPatGreID="")||(EmPatGreHours'="")  D
	.s EmAdmID=$p(^DHCEMPGR(EmPatGreID),"^",6)    /// 就诊ID
	.Q:(EpisodeID'="")&&(EpisodeID'=EmAdmID)
	.s EndDate=$p(^DHCEMPGR(EmPatGreID),"^",4)      /// 结束日期
	.s EndTime=$p(^DHCEMPGR(EmPatGreID),"^",5)      /// 结束时间
	.i EndDate'="" d
	..s EmPatGreHours=$SYSTEM.SQL.DATEDIFF("hh",$h,EndDate_","_EndTime)
	
	Q EmPatGreHours
}

/// Descript:   取绿色通道申请原因
/// w ##Class(web.DHCEMPatCheckLev).GetEmPatGreenHours("16","")
ClassMethod GetEmPatGreenReaDr(EmPCLvID As %String, EpisodeID As %String) As %String
{
	n (EmPCLvID, EpisodeID)
	s EmPatGreReaDr=""
	s EmPatGreID=""
	F  s EmPatGreID=$o(^DHCEMPGR(0,"PatCheckLev",EmPCLvID,EmPatGreID),-1) Q:(EmPatGreID="")||(EmPatGreReaDr'="")  D
	.s EmAdmID=$p(^DHCEMPGR(EmPatGreID),"^",6)    /// 就诊ID
	.Q:(EpisodeID'="")&&(EpisodeID'=EmAdmID)
	.s EmPatGreReaDr=$p(^DHCEMPGR(EmPatGreID),"^",14)
	
	Q EmPatGreReaDr
}

/// Descript:   取预检分诊就诊ID
ClassMethod GetEmPatCheckLvAdm(EmPCLvID As %String) As %String
{
	n (EmPCLvID)
	s ListData=""
	s EmAdmID=""
	F  s EmAdmID=$o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,EmAdmID)) Q:EmAdmID=""  D
	.s EpisodeID=$p(^DHCEMPCA(EmAdmID),"^",2)
	.Q:$p(^PAADM(EpisodeID),"^",20)="C"
	.i ListData="" s ListData=EpisodeID
	.E  s ListData=ListData_"#"_EpisodeID
	Q ListData
}

/// Descript:   抢救病区
ClassMethod InsEmPatWard(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID, ListData)
	
	s EmPatWardID=$p(ListData,"^",41)               /// 抢救病区
	Q:+EmPatWardID=0 0								/// 
	s EmPatLgParam=$p(ListData,"^",39)              /// 登录信息
	s EmAdmListData=..GetEmPatCheckLvAdm(EmPCLvID)  /// 预检就诊ID
	Q:EmAdmListData="" 0
	s EmAdmListData=$p(EmAdmListData,"#",1)        ///  默认插入第一条分诊记录为抢救状态
	s Err=0
	F i=1:1:$L(EmAdmListData,"#") q:Err'=0  d
	.s EpisodeID=$p(EmAdmListData,"#",i)           /// 就诊ID
	.
	.Q:+$p(^PAADM(EpisodeID),"^",70)=EmPatWardID   /// 已经在当前留观室不插入新状态
	.s Err=..DelWardAdm(EpisodeID)    			   /// 删除等候区
	.Q:Err'=0
	.s Err=..InsWardAdm(EpisodeID,EmPatWardID)     /// 插入等候区
	.Q:Err'=0
	.i ..UpdAdmVisit(EpisodeID,EmPatWardID)'=0 D
	..s Err=..InsAdmVisit(EpisodeID,EmPatWardID,EmPatLgParam) /// 病人状态表
	.Q:Err'=0
	.s Err=..UpdEmPatADM(EpisodeID,EmPatWardID)    /// 抢救病区
	.Q:Err'=0
	.s Err=..UpdInHospDate(EpisodeID)
	Q Err
}

/// Descript:   更新就诊表抢救病区字段
ClassMethod UpdEmPatADM(EpisodeID As %String, EmPatWardID As %String) As %String
{
	n (EpisodeID, EmPatWardID)
	&SQL(UPDATE PA_ADM set PAADM_CurrentWard_DR=:EmPatWardID where PAADM_RowID=:EpisodeID)
	Q SQLCODE
}

ClassMethod UpdInHospDate(EpisodeID)
{
	
	n (EpisodeID)
	
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	
	&sql(Update PA_AdmExt (PAADM_AdminDate,PAADM_AdminTime) Values (:CurDate,:CurTime) Where PAADM_RowId=:EpisodeID)
    Q SQLCODE
}

/// Descript:   插入病人状态表
ClassMethod InsAdmVisit(EpisodeID As %String, WardID As %String, EmPatLgParam As %String) As %String
{
	n (EpisodeID, WardID, EmPatLgParam)
	s VisID=$o(^DHCPACVisitStatus(0,"Code","SALVAGE",""))
	Q:VisID="" -1
	Q:WardID="" 0
	s LgLocID=$p(EmPatLgParam,"#",2)  /// 登录科室
	s LgUserID=$p(EmPatLgParam,"#",3) /// 登录人
	s CreateDate=+$H
	s CreateTime=$p($H,",",2)
	&SQL(Insert into DHC_ADMVisitStatus(AVS_PAADM_DR,AVS_VisitStatus,AVS_Date,AVS_Time,AVS_User_DR,AVS_Location,AVS_CreateDate,AVS_CreateTime,AVS_CreateUser,AVS_Ward_Dr)
		values (:EpisodeID,:VisID,:CreateDate,:CreateTime,:LgUserID,:LgLocID,:CreateDate,:CreateTime,:UserID,:WardID))
	Q SQLCODE
}

/// Descript:   插入等候区
ClassMethod InsWardAdm(EpisodeID As %String, WardID As %String) As %String
{
	n (EpisodeID, WardID)
	Q:+WardID="0" 0
	s BookedStatus="O"
	&SQL(Insert into PAC_WardAdm(WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus)
		values(:WardID,:EpisodeID,:BookedStatus))
	Q SQLCODE
}

/// Descript:   删除病人等候区记录
ClassMethod DelWardAdm(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s WardID=$p(^PAADM(EpisodeID),"^",70)
	Q:WardID="" 0
	s CH=$o(^PAWARDA(0,"WADM",EpisodeID,WardID,""))
	Q:CH="" 0
	s PWardID=WardID_"||"_CH
	&SQL(delete from PAC_WardAdm where WADM_RowId =:PWardID)
	Q SQLCODE
}

/// Descript:   更新病人状态记录内容
ClassMethod UpdAdmVisit(EpisodeID As %String, TempWardID As %String) As %String
{
	n (EpisodeID, TempWardID)
	s WardID=$p(^PAADM(EpisodeID),"^",70) /// 病区ID
	s AdmVID=$o(^DHCPACVisitStatus(0,"Code","SALVAGE",""))
	Q:AdmVID="" "-1"
	s ID="", TempID=""
	F  s ID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,ID)) Q:(ID="")||(TempID'="")  D
	.Q:$p(^DHCADMVisitStatus(ID),"^",10)'=WardID
	.Q:$p(^DHCADMVisitStatus(ID),"^",2)'=AdmVID
	.s TempID=ID
	.
	Q:TempID="" "-2"
	i TempWardID="" D
	.&SQL(delete DHC_ADMVisitStatus where AVS_RowId =:TempID)
	E  D
	.&SQL(update DHC_ADMVisitStatus set AVS_Ward_Dr=:TempWardID where AVS_RowId =:TempID)
	Q SQLCODE
}

/// Descript:   更新就诊表分级字段
ClassMethod InsAdmPatChkLv(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID, ListData)
	s EmLvCode=$p(ListData,"^",3)    ///  护士分级
	Q:EmLvCode="" 0
	s EmLvCode=EmLvCode_"级"
	s EmLvID=$o(^CT("ACU",0,"Code",$$ALPHAUP^SSUTIL4(EmLvCode),""))
	Q:EmLvID="" -1
	s EmAdmListData=..GetEmPatCheckLvAdm(EmPCLvID)  /// 预检就诊ID
	Q:EmAdmListData="" 0
	s Err=0
	F i=1:1:$L(EmAdmListData,"#") q:Err'=0  d
	.s EpisodeID=$p(EmAdmListData,"#",i)           /// 就诊ID
	.&SQL(update PA_ADM set PAADM_Priority_DR=:EmLvID where PAADM_RowID=:EpisodeID)
	.i SQLCODE'=0 s Err=-2
	Q Err
}

/// Descript:	更新病人就诊队列
ClassMethod SetPatAdmQueue(ListData As %String) As %String
{
	n (ListData)
	s Err=0
	s EmAdmListData=$p(ListData,"^",36)    ///  预检就诊ID
	s Len=$L(EmAdmListData,"#")
	s quitflag=0
	F i=1:1:Len q:Err'=0  d
	.s EmAdmID=$p(EmAdmListData,"#",i)   ///  就诊ID
	.Q:EmAdmID=""
	.//D:tuihao
	.s VisitStatus=$p(^PAADM(EmAdmID),"^",20)
    .s QueID=$O(^User.DHCQueueI("QuePaadmDrIndex",+EmAdmID,""),-1)
    .Q:QueID=""
    .s EmLocID=+$p(ListData,"^",6)           ///  科室ID
    .q:EmLocID=0
    .s EmPatChkCare=+$p(ListData,"^",35)     ///  就诊号别
	.q:EmPatChkCare=0
    .s Err=##Class(web.DHCOPQueueChangeDep).Commit(EmLocID,QueID,EmPatChkCare)
    Q Err
}

/// Descript:	预检分诊配置类型
ClassMethod GetEmSysConfig(ListData As %String) As %String
{
	n (ListData)
	s StrParam=$p(ListData,"^",37)    ///  预检就诊ID
	s LgHospID=$p(StrParam,"#",1)
	s LgCtLocID=$p(StrParam,"#",2)
	s LgUserID=$p(StrParam,"#",3)
	s LgGroupID=$p(StrParam,"#",4)
	s ResType=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","PATTYPE",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	Q ResType
}

/// Descript:	预检号别表
ClassMethod delEmPatChkLevRefTbl(EmPCLvID As %String, EmListData) As %String
{
	n (EmPCLvID,EmListData)
	///  预检生命体征:不删除
	;i $o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,"")) D
	;.&SQL(delete from DHC_EmPatChkSign where PCS_Chk_Dr=:EmPCLvID)
	;q:+$g(SQLCODE)'=0 SQLCODE
	
	///  预检既往史
	i $o(^DHCEMPCH(0,"PatCheckLev",EmPCLvID,"")) D
	.&SQL(delete from DHC_EmPatChkHis where PCH_Chk_Dr=:EmPCLvID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	///  预检号别
	i $o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,"")) D
	.&SQL(delete from DHC_EmPatChkCare where PCC_Chk_Dr=:EmPCLvID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	///  预检就诊
	i $o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,"")) D
	.&SQL(delete from DHC_EmPatChkAdm where PCA_Chk_Dr=:EmPCLvID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	///  六大病种
	i $o(^DHCEMPCSP(0,"PatCheckLev",EmPCLvID,"")) D
	.&SQL(delete from DHC_EmPatChkSpec where PCSP_Chk_Dr=:EmPCLvID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	///  分诊诊断
	i $o(^DHCEMPCSY(0,"PatCheckLev",EmPCLvID,"")) D
	.&SQL(delete from DHC_EmPatChkSym where PCSY_Chk_Dr=:EmPCLvID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	q 0
}

/// Descript:	保存卡信息
/// 病人ID^登记号^姓名^身份证^性别^出生日期^国籍^民族^联系电话^家庭地址^卡号ID^卡号^登记人
/// W ##Class(web.DHCEMPatCheckLev).savePatCardInfo("1269","^^林书没^^^^1^1^^^1^0000001269^7930^1^^2^^^^","2^35^7930^199")
ClassMethod savePatCardInfo(PatientID As %String, ListData As %String, LgParams As %String, ChkComputerIP) As %String
{
	n (PatientID, ListData, LgParams, ChkComputerIP)
	;s CardNoID = $p(ListData,"^",11)    /// 卡号ID
	;Q:CardNoID'="" CardNoID    			/// 卡号记录,不予更新
	s CardTypeID = $p(ListData,"^",14)  /// 卡类型定义	
	s CardNo = $p(ListData,"^",12)
	q:CardNo="" 0
	s SecurityNO = $p(ListData,"^",17)  /// 安全码
	
	///改用医生站统一接口 zhouxin 2016-10-19
	//客户端IP^用户Id^科室Id^安全组Id^医院Id^站点Id
	s LgHospID=$p(LgParams,"^",1)	/// 医院ID
	s LgCtLocID=$p(LgParams,"^",2)  /// 科室ID
	s LgUserID=$p(LgParams,"^",3)   /// 用户ID
	s LgGroupID=$p(LgParams,"^",4)  /// 安全组ID
	s SessionStr="^"_LgUserID_"^"_LgCtLocID_"^"_LgGroupID_"^"_LgHospID_"^"
	s ConfigInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).ReadDefaultCardTypeConfigByDR(CardTypeID,SessionStr)
	s PaPatInfo=..getPaPatXMLInfo(PatientID,LgUserID)
	s CardInfo=..getCardXMLInfo(PatientID, ListData ,ChkComputerIP)
	s CardInvPrt=..GetCardInvPrtXML(PatientID,ListData) /// 取卡的收费记录xml串
	s AccInfo=..GetAccManagerXML(PatientID,ListData,LgParams)
	b ;err
	s rtn=##class(web.DHCBL.CARDIF.ICardRefInfo).SavePCAInfoToServer(ConfigInfo,PaPatInfo,CardInfo,AccInfo,"",CardInvPrt,SecurityNO,"")
	q rtn
}

/// Descript:	保存卡信息
/// 病人ID^登记号^姓名^身份证^性别^出生日期^国籍^民族^联系电话^家庭地址^卡号ID^卡号^登记人
/// W ##Class(web.DHCEMPatCheckLev).saveCardInfo("1018","^^微软^^1^^1^1^^^^^18850^1^^2^^^^^1^^21","2^39^18850^199","10.1.30.144")
ClassMethod saveCardInfo(PatientID As %String, ListData As %String, LgParams As %String, ChkComputerIP = "") As %String
{
	n (PatientID, ListData, LgParams ,ChkComputerIP)
	;s ^qqa("saveCardInfo") = $lb(PatientID, ListData, LgParams ,ChkComputerIP)
	;s flag=+##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("ISNEEDCARD",LgParams)
	s LgHospId = +LgParams
	s AddDefCard=##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("ADDDEFCARD",LgParams)
	;q:flag'=1 0
	s CardNoID = $p(ListData,"^",11)    /// 卡号ID
	q:CardNoID'="" CardNoID    			/// 卡号记录,不予更新
	s CardTypeID = $p(ListData,"^",14)  /// 卡类型定义
	q:+CardTypeID=0 0
	s UsePAPMINoToCardFlag=$P(^DHCCARDTYPEDef(CardTypeID),"^",36)
	;q:(AddDefCard=1)&&(CardTypeID=1) 0  ///	 配置了自动插入条形码
	s CardNo = $p(ListData,"^",12)
	q:(CardNo="")&&(UsePAPMINoToCardFlag'="Y") 0
	s SecurityNO = $p(ListData,"^",17)  /// 安全码
	s ExpStr="^"_UsePAPMINoToCardFlag_"^"_LgHospId
	
	///改用医生站统一接口 zhouxin 2016-10-19
	//客户端IP^用户Id^科室Id^安全组Id^医院Id^站点Id
	s LgHospID=$p(LgParams,"^",1)	/// 医院ID
	s LgCtLocID=$p(LgParams,"^",2)  /// 科室ID
	s LgUserID=$p(LgParams,"^",3)   /// 用户ID
	s LgGroupID=$p(LgParams,"^",4)  /// 安全组ID
	s SessionStr="^"_LgUserID_"^"_LgCtLocID_"^"_LgGroupID_"^"_LgHospID_"^"
	s ConfigInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).ReadDefaultCardTypeConfigByDR(CardTypeID,SessionStr)
	s PaPatInfo=..getPaPatXMLInfo(PatientID,LgUserID)
	s CardInfo=..getCardXMLInfo(PatientID, ListData,ChkComputerIP)
	s CardInvPrt=..GetCardInvPrtXML(PatientID,ListData) /// 取卡的收费记录xml串
	s AccInfo=..GetAccManagerXML(PatientID,ListData,LgParams)
	
	s rtn=##class(web.DHCBL.CARDIF.ICardRefInfo).SavePCAInfoToServer(ConfigInfo,PaPatInfo,CardInfo,AccInfo,"",CardInvPrt,SecurityNO,ExpStr)
	q rtn
	/////////////////////////////////////////////////////////////////////////////////////////
	///  卡信息
#;	i CardNoID = "" D
#;	.s CardRefObj = ##Class(User.DHCCardRef).%New()
#;	E  D
#;	.s CardRefObj = ##Class(User.DHCCardRef).%OpenId(CardNoID)
#;	
#;	//s SecurityFlag=$p($g(^DHCCARDTYPEDef(CardTypeDefine)),"^",18)
#;	//i SecurityFlag="Y" d
#;	//.s CardObj.SecurityNo=##class(web.UDHCAccEnrypt).Encrypt(SecurityNO)
#;	
#;	i CardNoID = "" D
#;	.s CardRefObj.CFDate = +$H 			    /// 发卡日期
#;	.s CardRefObj.CFTime = $p($H,",",2)		/// 发卡时间
#;
#;	s CardRefObj.CFCardNo = CardNo    		/// 卡号
#;	s CardRefObj.CFSecurityNO = SecurityNO  /// 卡的安全号码
#;	s CardRefObj.CFPAPMIDR = PatientID 		/// 病人指针
#;	s CardRefObj.CFIDCardNo= IdentNo 		/// 身份证号码
#;	s CardRefObj.CFPAPMINo= PatNo 			/// 登记号
#;	s CardRefObj.CFActiveFlag= "N" 			/// 有效卡标志
#;	s CardRefObj.CFUserDR = userID		    /// 建卡人
#;	s CardRefObj.CFDateFrom = +$H			/// 发卡日期
#;	s CardRefObj.CFFareType = ""			/// 卡缴费类型方式
#;	i CardTypeID'="" D CardRefObj.CFCardTypeDRSetObjectId(CardTypeID)  /// 卡类型定义
#;	
#;	s sc=CardRefObj.%Save()
#;	i $$$ISERR(sc) q -200   ///  卡信息保存失败
#;	s CardNoID = CardRefObj.%Id()
#;	
#;	///  卡状态信息
#;	s CardStatChaObj = ##class(User.DHCCardStatusChange).%New(CardNoID)
#;	s CardStatChaObj.CSCCFParRef = CardRefObj
#;	i CardNoID = "" D
#;	.s CardStatChaObj.CSCDate = CFDate
#;	.s CardStatChaObj.CSCTime = CFTime
#;	s CardStatChaObj.CSCCurStatus = "N"
#;	s CardStatChaObj.CSCUserDR = userID
#;
#;	s sc=CardStatChaObj.%Save()
#;	i $$$ISERR(sc) q -201    /// 卡状态信息保存失败
#;	
#;	q CardNoID
}

/// Descript:	保存病人信息
/// 病人ID^登记号^姓名^身份证^性别^出生日期^国籍^民族^联系电话^家庭地址^卡号ID^卡号^登记人
/// W ##Class(web.DHCEMPatCheckLev).savePatInfo("^^罗东生^232303199301030010^1^1993-01-03^1^1^^^^DD0224022^7930^1^26岁^2^6511475739^^^","2^35^7930^199")
ClassMethod savePatInfo(PatListData As %String, LgParams As %String) As %String
{
	n (PatListData, LgParams, %session)
	
	s modflag=+##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("MODIFYPAT",LgParams)
	s PatientID = $p(PatListData,"^",1)  /// 病人ID
	q:(modflag'=1)&&(+PatientID'=0) PatientID
	
	s PatNo = $p(PatListData,"^",2)      /// 登记号
	s PatName = $p(PatListData,"^",3)    /// 姓名
	s IdentNo = $p(PatListData,"^",4)    /// 身份证
	s mPatientID=##Class(web.DHCEMPatCheckLevCom).GetPatientID(IdentNo)
	;Q:(+PatientID'=mPatientID)&(mPatientID'="") "-401"
	s PatSexID = $p(PatListData,"^",5)   /// 性别
	i PatSexID = "" s PatSexID = "3"
	s PatDob = $p(PatListData,"^",6)     /// 出生日期
	s:PatDob'="" PatDob=##class(web.DHCEMCommonUtil).DateHtmlToLogical(PatDob) //hxy $zdh(PatDob,3)
	;i PatDob = "" s PatDob = +$H //hxy 2020-06-16 	【多院区】三无病人建档时目前出生日期时间默认是当天时间，应置空
	s CountryID = $p(PatListData,"^",7)  /// 国籍
	i CountryID = "" s CountryID = "1"
	s NationID = $p(PatListData,"^",8)   /// 民族
	s TelHNo = $p(PatListData,"^",9)     /// 联系电话
	s Address = $p(PatListData,"^",10)   /// 家庭地址
	s PatSocailType = $p(PatListData,"^",21)   ///病人类型
	s HealthCareNo = $p(PatListData,"^",22)   ///医保卡号
	s patCertType  =$p(PatListData,"^",23)    ///证件类型
	s IdCardNo=""			///身份证
	s patCertTypeDesc=""
	s:patCertType'="" patCertTypeDesc=$p(^PAC("CARD",patCertType),"^",2)
	s:patCertTypeDesc="居民身份证" IdCardNo=IdentNo
	;s:+patCertType=0 ^qqa("ErrCardType",IdentNo)=$h
	s age= $p(PatListData,"^",15)
	/// 急诊病人无名氏登记：性别:未知性别,国籍:中国,出生日期:登记日期
	i PatName = "" D
	.s Anonym=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patchecklev.hisui.csp","无名氏") //hxy 2023-02-09
	.s Prefix=..GetPrefix(LgParams)
	.s EmPatChkMaxNo=..GetEmPatChkMaxNo(Prefix,3)
	.s PatName=Anonym_EmPatChkMaxNo //"无名氏"
	.D ..InsEmPatChkNo(EmPatChkMaxNo)
	
	
	///改用医生站统一接口 zhouxin 2016-10-19
	s patVOObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	s patVOObj.Address=Address
	s patVOObj.Birth=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatDob) //hxy $zd(PatDob,4)

	s BirthTime=##Class(web.DHCEMPatCheckLev).CalBirthTime(PatDob,age)
	i +PatientID=0 d
	.s BirthTime=$zt($p($h,",",2),1)
	s patVOObj.BirthTime=BirthTime
	s patVOObj.Sex=PatSexID
	s patVOObj.Name=PatName
	s patVOObj.UpdateDate=+$h
	s patVOObj.UpdateTime=$p($h,",",2)
	s patVOObj.PatType=PatSocailType
	s patVOObj.PAPMIRowID=PatientID
	s patVOObj.NationDescLookUpRowID=NationID
	s patVOObj.CountryDescLookUpRowID=CountryID
	s patVOObj.CredNo=IdentNo
	s patVOObj.IDCardNo1=IdCardNo
	s patVOObj.CredType=patCertType
	s patVOObj.TelHome=TelHNo
	s patVOObj.PatYBCode=HealthCareNo
	i +PatientID'=0 d
	.s patVOObj.PatType=PatSocailType
	.s patVOObj.EMail=$p($g(^PAPER(PatientID,"PER",4)),"^",19)
	.s patVOObj.EmployeeNo=$p($g(^PAPER(PatientID,"EMP")),"^",5)
	.s patVOObj.ForeignPhone=$p($g(^PAPER(PatientID,"ALL")),"^",4)
	.s patVOObj.ForeignName=$p($g(^PAPER(PatientID,"PER",2)),"^",13)
	.s patVOObj.Company=$p($g(^PAPER(PatientID,"PER",4)),"^",18)
	.s patVOObj.PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	.s patVOObj.Allergy=$g(^PAPER(PatientID,"ALLERGY",1))
	.s patVOObj.PoliticalLevel=$p($g(^PAPER(PatientID,"PER",3)),"^",3)
	.s patVOObj.SecretLevel=$P($g(^PAPER(PatientID,"DHC")),"^",30)
	.s oldType=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	.i (+IdentNo=0)&&(oldType'=1) d
	..s patVOObj.CredNo=IdentNo
	..s patVOObj.IDCardNo1=IdCardNo
	..s patVOObj.CredType=patCertType
	.s patVOObj.PatYBCode=HealthCareNo
	
	;s rtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(patVOObj)
	s rtn=##class(web.DHCEMPatCheckLev).SavePatInfoDoc(patVOObj)
	s err=$p(rtn,"^",1)
	s ret=$p(rtn,"^",2)
	q:err'=0 -11 
	q ret
}

/// 保存患者基本信息
/// 分为: 新增或者 更新
ClassMethod SavePatInfoDoc(PatObj As web.DHCEntity.PCA.PATMAS) As %String
{
  
	;s $ZT="ERROR^DHCSSERR"
	;需要保存 PA_PatMas
	;此处保存的都是患者基本的信息
	;对于其他信息需要一个更新过程接口
	;n (PatObj)
	s myrtn=0
	s PAPMIRowID=""
	s myNewFlag=0	;是新增,还是Update 标志
	s PrePatTypeId=""
	set OldDataObject=""
	set OldDataJson=""
	s myBirth=""
	s Vnull=$C(0)
	if (PatObj.Birth'="") {
		;;如果为空默认当前日期
		i PatObj.Birth["-" d  s myBirth=$zdh(PatObj.Birth,3)
		i PatObj.Birth["/" d  s myBirth=$zdh(PatObj.Birth,4)
	}
	
		b	;;获取是否已经生成Person的Id
		Set PatRowId = PatObj.PAPMIRowID
		;通过身份证关联唯一的病人
		if PatRowId="" {
		
		}
		;s OldPatInfo=""
		;使用RowID来决定是否 更新和新增
		if ((PatRowId = "")||(PatRowId=$c(0)))
		{
			Set person = ##class(User.PAPerson).%New()
			s myNewFlag=1
			
		}else{
			Set person = ##class(User.PAPerson).%OpenId(PatRowId)
 			i $IsObject(person.PAPERSocialStatusDR) s PrePatTypeId=person.PAPERSocialStatusDR.%Id()
			s myNewFlag=0
			set OldDataObject=##class(web.DHCBL.Patient.DHCPatientUpdateLog).GetLogData("User.PAPatMas"_$c(2)_PatRowId_"^"_"User.PAPerson"_$c(2)_PatRowId)
		    set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatRowId_"^"_"User.PAPerson"_$c(2)_PatRowId)
		}
		
		Set person.PAPERID = PatObj.IDCardNo1
		Set OtherCard=PatObj.OtherCardInfo
		Set person.PAPERName = PatObj.Name
		Set person.PAPERName2 = ##class(ext.util.String).ToChineseSpell(PatObj.Name)
		Set person.PAPERName3 = ##class(web.DHCINSUPort).GetCNCODE(PatObj.Name,3,"")	;调用医保组基础类接口,需要有汉字编码字典的支撑
		;s mybj=##class(%Library.Date).IsValidDT(PatObj.Birth)
		if (PatObj.OpMedicare'="") {
			s person.PAPERGovernCardNo=PatObj.OpMedicare	;门诊病历号
		}
		Set person.PAPERDob = myBirth
		;Set person.PAPERForeignAddress = PatObj.Address
		d person.PAPERStName.Clear()
		d person.PAPERStName.Insert(PatObj.Address)
		Do person.PAPERSocialStatusDRSetObjectId(PatObj.PatType)
		i (PatObj.Sex'=""){
			Do person.PAPERSexDRSetObjectId(PatObj.Sex)
		}
		if (PatObj.UserDR'=""){
			if (myNewFlag=1) {
				Set person.PAPERDateAdded = +$h
				d person.PAPERUserAddedDRSetObjectId(PatObj.UserDR)
			}else{
				d person.PAPERUserUpdateSetObjectId(PatObj.UserDR)
			}
		}
		;^CT("COU",{CTCOU_RowId})
		s myCountryDR=$o(^CT("COU",0))
		if (myCountryDR'=""){
			;设定国家
			d person.PAPERCountryDRSetObjectId(myCountryDR)
		}
		if (PatObj.CountryDescLookUpRowID'=Vnull){ //(PatObj.CountryDescLookUpRowID'="")&&
			d person.PAPERCountryDRSetObjectId(PatObj.CountryDescLookUpRowID)
		}
		
		if (PatObj.NationDescLookUpRowID'=Vnull){
			d person.PAPERNationDRSetObjectId(PatObj.NationDescLookUpRowID)
		}
		
		;设定语言
		s myLangDR=$o(^SS("LAN",0,"Code","CHN",0))
		i (myLangDR'=""){
			d person.PAPERLangPrimDRSetObjectId(myLangDR)
		}
		s person.PAPERUpdateDate=+$h //PatObj.UpdateDate
		s person.PAPERUpdateTime=$p($h,",",2) //PatObj.UpdateTime
		;特定值
		s person.PAPEREstDOB="N"	;
		s person.PAPERIncompleteRegistration="N"
		
		s person.PAPERTelH=PatObj.TelHome		;家庭电话
		;s person.PAPERTelO=PatObj.TelOffice		;单位电话
		s person.PAPERForeignPhone=PatObj.ForeignPhone
		;PAPER_EmployeeCompany
		;PAPER_EmployeeCompany
		;;集团/单位
		i (PatObj.EmployeeCompanyLookUpRowID'="")&&(PatObj.EmployeeCompanyLookUpRowID'=Vnull){
			d person.PAPEREmployeeCompanySetObjectId(PatObj.EmployeeCompanyLookUpRowID)
		}
		
		s person.PAPEREmail=PatObj.EMail
		
		//工号  2011-07-15
		s person.PAPEREmployeeNo=PatObj.EmployeeNo
		
		///PAPER_StayingPermanently  是否专程来京就诊  医联码新增
		if (PatObj.AdmSource="on") s AdmSource="Y"
		else  s AdmSource="N"
		s person.PAPERStayingPermanently =AdmSource
		
		///PAPER_SecondPhone 工作单位  医联码新增
		if (PatObj.Company'=Vnull){ //(PatObj.Company'="")&&
			s person.PAPERSecondPhone =PatObj.Company
		}
		//单位邮编
		;s person.PAPERName6=PatObj.CompanyPostCode
		//联系人邮编
		;s person.PAPERForeignPostCode=PatObj.ForeignPostCode
		//联系人地址
		;s person.PAPERForeignAddress=PatObj.ForeignAddress
		//血型
		;s person.PAPERBloodTypeDR=PatObj.BloodType
		
		//省(籍贯)
		;d person.PAPERProvinceBirthDRSetObjectId(PatObj.ProvinceHome)
		//省(籍贯)
		;d person.PAPERCityBirthDRSetObjectId(PatObj.CityHome)
		///病人级别 
		if (PatObj.PoliticalLevel'=Vnull){ //(PatObj.PoliticalLevel'="")&&
			d person.PAPEREmployeeFunctionSetObjectId(PatObj.PoliticalLevel)
		}
		//照片信息base64
		if ((PatObj.PhotoInfo'="")&&(PatObj.PhotoInfo'=Vnull))
		{
			s person.PAPERPhoto=PatObj.PhotoInfo	
		}
		Set sc = person.%Save()
	
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
			q myrtn_"^"
		}
		b	;Save PaPerson
		;PatMas
		Set PAPMIRowID = person.%Id()
		
		If ((PAPMIRowID'="") && (+myrtn = 0))
		{
			;Set patmas = ##class(User.PAPatMas).%New()
			Set patmas = ##class(User.PAPatMas).%OpenId(PAPMIRowID)
			;设置登记号码
			;如果是新增的需要更新登记号码
			;而对于已经生成的登记号需要 不需要更新登记号
			if (+myNewFlag'=0){
				i PatObj.PAPMINo'=""{  ;导入数据时根据外面传入的病人ID使用
					s myMAXNo=PatObj.PAPMINo
				}else{ 
					s myMAXNo=0
					;pd by tanjishan 20201120
					;担心体检或其他系统批量新建患者，导致该Global死锁的问题
					;lock 不加参数，Caché将解锁所有先前的锁定并应用指定的锁定。但是只会在事务结束时释放
					//Lock ^PAPER(0,"CNT","I")
					s myMAXNo=$i(^PAPER(0,"CNT","I"))
					//Lock -^PAPER(0,"CNT","I")
					s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
					s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo
				}
				s patmas.PAPMINo=myMAXNo
				s patmas.PAPMIIPNo=myMAXNo
				s patmas.PAPMIOPNo=myMAXNo
			}
			if (PatObj.InMedicare'=""){
				;s patmas.PAPMIMedicare=PatObj.InMedicare	;InMedicare 住院病案号
			}
			;证件类型
			;PatObj.CredType
			i (PatObj.CredType'=""){
				d patmas.PAPMICardTypeDRSetObjectId(PatObj.CredType)
			}
			;PAPMI_MobPhone   移动电话
			;s patmas.PAPMIMobPhone=PatObj.MobPhone //移动电话
			;s ^wrz("MobPhone")=PatObj.MobPhone
			;s $P(^PAPER(PAPMIRowID,"PER",4),21)=PatObj.MobPhone
	
			;过敏史
			d patmas.PAPMIAllergy.Clear()
			d patmas.PAPMIAllergy.Insert(PatObj.Allergy)
			
			;证件号码  有索引
			s patmas.PAPMIDVAnumber=PatObj.CredNo
			;身份证的设置要判断证件类型是不是身份证
			s CredTypeDesc=""
			S:PatObj.CredType'="" CredTypeDesc=$P($G(^PAC("CARD",PatObj.CredType)),"^",2)
			s:(PatObj.IDCardNo1="")&&(CredTypeDesc[("身份证")) PatObj.IDCardNo1=PatObj.CredNo
			s IDCardNo=PatObj.IDCardNo1
			//此处极其影响效率，需要改为按照ID更新
			//&Sql(Update SQLUser.DHC_CardRef Set CF_IDCardNo=:IDCardNo Where CF_PAPMI_DR=:PAPMIRowID)
			s myCFRowID=0
			for{
				s myCFRowID=$O(^DHCCARDi("CF",0,"PAPMIDR",PAPMIRowID,myCFRowID))
				q:(myCFRowID="")
				&Sql(Update SQLUser.DHC_CardRef Set CF_IDCardNo=:IDCardNo Where CF_RowID=:myCFRowID)
			}
			
			if (+myNewFlag'=0){
				;有效
				s patmas.PAPMIActive="Y"
			}
			
			///PAPMI_VIPFlag  协和国际医疗部就诊卡标志
			if (PatObj.VIPFlag="on") s VIPFlag="Y"
			else  s VIPFlag="N"
			s patmas.PAPMIVIPFlag =VIPFlag
			
			//首诊科室
			;d patmas.PAPMIGPOrgAddress.Clear()
			;d patmas.PAPMIGPOrgAddress.Insert(PatObj.GPOrgAddress)
			
			Set sc = patmas.%Save()
			If ($System.Status.IsError(sc))
			{
				Do $System.Status.DisplayError(sc)
				Set myrtn = "-101"
				q myrtn_"^"
			}
			;&&(PatObj.IDCardNo1)
			if ((+myrtn=0)){
				s myrtn=+##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(PAPMIRowID,PatObj.IDCardNo1)
				if (+myNewFlag=0) {
					;根据设置确定是否更新当日及以后就诊记录费别
				    s CFMedifyPatTypeSynAdmRea=##class(web.DHCOPRegConfig).GetSpecConfigNode("MedifyPatTypeSynAdmRea")
				    i (CFMedifyPatTypeSynAdmRea=1)&&(PrePatTypeId'=PatObj.PatType) {
						d ##class(web.DHCBL.Patient.DHCPatient).UpdateAdmedReason(PAPMIRowID)
				    }
			    }
			}
		}
		Else
		{
			Set myrtn = "-102"
		}
		
		;对于特殊的字段存储
		i (+myrtn=0){
			;留给其他医院的接口
			s myinfortn=##class(web.DHCBL.CARDIF.ICardPaPatMasInfo).SavePatOtherInfo(PAPMIRowID, PatObj)
			s myrtn=+$p(myinfortn,"^",1)
		}
		;保存其他证件类型
		if (OtherCard'="")&&(+myrtn = 0){
			s myrtn=##Class(web.DHCBL.CARD.UCardPaPatMasInfo).SaveOtherCardInfo(PAPMIRowID,OtherCard)
		}
		
		///病人密级 密级表 DHC_ SecretLevel
		if (PatObj.SecretLevel'=Vnull){ //(PatObj.SecretLevel'="")&&
			s $P(^PAPER(PAPMIRowID ,"DHC"),"^",30)=PatObj.SecretLevel
		}
		;使用新的记日志方法 guobaoping 
		i $IsObject(OldDataObject)  
		{
			//set flag=##class(web.DHCBL.Patient.DHCPatientUpdateLog).SaveUpdLog(OldDataObject,"User.PAPatMas"_$c(2)_PAPMIRowID_"^"_"User.PAPerson"_$c(2)_PAPMIRowID,PatObj.UserDR)
		    set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatRowId_"^"_"User.PAPerson"_$c(2)_PatRowId)
		    s OperateType=$case(myNewFlag,0:"U",1:"A")
		    set falg=##class(web.DHCDocDataChangeLog).SaveLog("PA_PatMas#PA_Person","User.PAPatMas#User.PAPerson","患者基本信息","User.PAPatMas#User.PAPerson_"_PAPMIRowID,PatObj.Name,OperateType,NewDataJson,OldDataJson,PatObj.UserDR)
		}
	q myrtn_"^"_PAPMIRowID
LogErr
	q myrtn_"^"_PAPMIRowID
}

/// Descript: 生成登记号
/// W ##Class(web.DHCEMPatCheckLev).GetMaxPatNo()
ClassMethod GetMaxPatNo() As %String
{
	s CurrMaxNo=0
	L ^PAPER(0,"CNT","I"):10 E  Q -100
	s CurrMaxNo=$I(^PAPER(0,"CNT","I"))
	L -^PAPER(0,"CNT","I")
	s PatNoLen=+$p(^CF("PATCF",1,3),"^",5)
	s CurrMaxNo=$e("0000000000000000000",1,PatNoLen-$l(CurrMaxNo))_CurrMaxNo
	q CurrMaxNo
}

/// 	Descript:预检病人无名氏增递计算器表
ClassMethod InsEmPatChkNo(EmPatChkMaxNo) As %String
{
	n (EmPatChkMaxNo)
	//s EmPatChkMaxNo=..GetEmPatChkMaxNo("EM",3)
	s CreateDate=+$H
	&SQL(Insert Into DHC_EmPatChkNo(PCN_Date,PCN_No)Values(:CreateDate,:EmPatChkMaxNo))
	q SQLCODE
}

/// Descript: 获取最大号
ClassMethod GetEmPatChkMaxNo(Prefix As %String, NoLen As %String) As %String
{
	N (Prefix,NoLen)
	S NextNo=""
	L +^DHCEMPCN("EmPatChkNo",Prefix):10 E  Q -100
	S PreLen=$L(Prefix)
	S MinSuffix=1
	F i=1:1:NoLen-1 S MinSuffix="0"_MinSuffix
	S MinNo=Prefix_MinSuffix	//最小码
	S CurLen=PreLen+NoLen	    //单号长度
	///表里记录的最大码
	S CurrMaxNo=..GetEmPatChkNo(Prefix)
	S CurPrefix=$E(CurrMaxNo,1,PreLen)
	S CurrNo=$E(CurrMaxNo,PreLen+1,CurLen)

	i Prefix'=CurPrefix D
	.S NextNo=MinNo
	.L -^DHCEMPCN("EmPatChkNo",Prefix)
	Q:NextNo'="" NextNo

	S Suffix=CurrNo+1
	
	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix="0"_Suffix
	S NextNo=Prefix_Suffix
	L -^DHCEMPCN("EmPatChkNo",Prefix)
	Q NextNo
}

/// Descript:无名氏递增号
ClassMethod GetEmPatChkNo(prefix) As %String
{
	n (prefix)
	q:prefix="" ""
	s EmPcnDate=+$H
	s EmPatChkNo=""
	&sql(select max(PCN_No) into :EmPatChkNo from DHC_EmPatChkNo Where PCN_Date=:EmPcnDate And PCN_No %STARTSWITH %ALPHAUP :prefix)
	q EmPatChkNo
}

/// Descript:数据一致性检查
ClassMethod CheckDataConsist(PatListData As %String) As %String
{
	n (PatListData)
	s PatientID = $p(PatListData,"^",1)  /// 病人ID
	s CardNoID = $p(PatListData,"^",11)  /// 卡号ID
	s CardNo = $p(PatListData,"^",12)    /// 卡号
	q:CardNo="" 0
	i CardNoID="" s CardNoID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1)
	Q:(PatientID="")&(CardNoID="") "0"
	//Q:(PatientID'="")&(CardNoID="") "-11"
	q:CardNoID="" 0
	s CFPatientID=$p(^DHCCARD("CF",CardNoID),"^",4) /// 卡号记录病人ID
	s activeflag=$p(^DHCCARD("CF",CardNoID),"^",10)
	i activeflag="R" s CFPatientID=""
	Q:(PatientID'=CFPatientID) "-10"
	Q 0
}

/// 根据session获取参数配置的值
/// w ##class(web.DHCEMPatCheckLev).GetConfigBySession("INSERTDOC")
ClassMethod GetConfigBySession(Type As %String) As %String
{
	n (StrParam,Type,%session)
	s LgHospID=%session.Get("LOGON.HOSPID")
	s LgCtLocID=%session.Get("LOGON.CTLOCID")
	s LgUserID=%session.Get("LOGON.USERID")
	s LgGroupID=%session.Get("LOGON.GROUPID")
	s ResType=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM",Type,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	Q ResType
}

/// Description: 挂号和打印程序
/// Creator:	 CongYue
/// CreateDate:  2016-08-30
/// Input:		 RegistList:"PatientID:病人ID->PA_PATMAS,ASRowId:排班ID->RB_ApptSchedule,AdmReason:病人费别（默认传空）,FeeStr:收费内容，user：操作员ID->SS_User，group：安全组ID->SS_Group,LocID:所挂科室ID->CT_Loc" CareProvList:号别数组
/// OutPut: 	 Err_"$"_PrintData 成功失败标记_"$"_号条信息 0：成功；-101：没有找到出诊记录,或者从未排班；-102：此病人已经存在相同的登记记录,请使用病人列表查询；其他：失败! 错误代码:"+ErrCode
/// w ##class(web.DHCEMPatCheckLev).RegistInfo(LocID,"","","","",DocRowId)
ClassMethod RegistInfo(RegistList As %String, CareProvList As %String) As %String
{
	N (RegistList,CareProvList)
	S PatientID=$p(RegistList,"^",1)
	S ASRowId=$p(RegistList,"^",2)
	S AdmReason=$p(RegistList,"^",3)
	S FeeStr=$p(RegistList,"^",4)
	S user=$p(RegistList,"^",5)
	S group=$p(RegistList,"^",6)
	S LocIDList=$p(RegistList,"^",7)
	S PrintData=""
	S Err=0
	S PrintDataList=""
	TS
	S len=$L(CareProvList,"&&")
	F i=1:1:len D
	.S DocRowId=$p(CareProvList,"&&",i)
	.S LocID=$p(LocIDList,"&&",i)
	.S ASRowId=##class(web.DHCOPAdmReg).GetRapidASRowId(LocID,"","","","",DocRowId)
	.S:ASRowId="" Err="-1"
	.Q:Err'=0
	.S DtatList=##class(web.DHCOPAdmReg).OPDocRapidRegistBroker(PatientID,ASRowId,AdmReason,FeeStr,user,group,LocID,DocRowId)
	.S Err=$p(DtatList,"^",1)
	.S PrintData=$p(DtatList,"^",2)
	.S PrintDataList=PrintDataList_"$"_PrintData
	.Q:Err'=0
	I Err'=0 tro
	Q:Err'=0 Err
	TC
	Q "0"_"&&"_PrintDataList
}

/// 返回<CardRef><CardNo></CardNo><PAPMIRowID></PAPMIRowID>......</CardRef>
/// zhouxin 2016-10-19
ClassMethod getCardXMLInfo(PatientID As %String, ListData As %String, ChkComputerIP = "") As %String
{
	n (PatientID,ListData,ChkComputerIP)
	
	s CardNoID = $p(ListData,"^",11)    /// 卡号ID
	Q:CardNoID'="" CardNoID    			/// 卡号记录,不予更新
	
	s CardNo = $p(ListData,"^",12)      /// 卡号
	s userID = $p(ListData,"^",13)      /// 建卡人员
	s CardTypeID = $p(ListData,"^",14)  /// 卡类型定义
	s HospID = $p(ListData,"^",16)      /// 医院ID
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)  /// 身份证号码
	
	s obj=##class(web.DHCEntity.PCA.CardRef).%New()
	s obj.CardNo=CardNo
	s obj.ActiveFlag="N"
	s obj.CardTypeDefine=CardTypeID
	s obj.UserDR=userID
	s obj.PAPMINo=PatNo
	s obj.CredNo=IdentNo
	s obj.LogonHospDR=HospID
	s obj.FareType="PC"
	s obj.ComputerIP=ChkComputerIP
	d obj.XMLExportToString(.myXmlData)
	d obj.%Close()
	q myXmlData
}

/// Descript: 	取卡的收费记录xml串
/// Creator:  	bianshuai
/// CreateDate: 2017-04-01
/// D ##Class(web.DHCEMPatCheckLev).GetCardInvPrtXML("12","1")
ClassMethod GetCardInvPrtXML(PatientID As %String, ListData As %String) As %String
{
	n (PatientID,ListData)
	s CardTypeID = $p(ListData,"^",14)  /// 卡类型定义
	s userID = $p(ListData,"^",13)      /// 建卡人员
	s CardFareCost=+$P(^DHCCARDTYPEDef(CardTypeID),"^",6)
	s obj=##Class(web.DHCEntity.PCA.CardINVPRT).%New()
	s obj.CardFareCost=CardFareCost
	s obj.PAPMIRowID=PatientID
	s obj.UserDR=userID
	s obj.Flag="Y"
	s obj.PayMode=+$o(^CT("CTPM",0,"Code",$$ALPHAUP^SSUTIL4("CASH"),""))
	d obj.XMLExportToString(.myXmlData)
	d obj.%Close()
	Q myXmlData
}

/// Acc
ClassMethod GetAccManagerXML(PatientID As %String, ListData As %String, LgParams = "") As %String
{
	n (PatientID,ListData,LgParams)
	s userID = $p(ListData,"^",13)      /// 建卡人员
	s CardNo = $p(ListData,"^",12)
	s HospID=$p(LgParams,"^",1)
	s obj=##Class(web.DHCEntity.PCA.AccManager).%New()
	s obj.CardNo=CardNo
	s obj.UserDR=userID
	s obj.HospitalID=HospID
	d obj.XMLExportToString(.myXmlData)
	d obj.%Close()
	Q myXmlData
}

/// Creator:  	bianshuai
/// CreateDate: 2017-08-17
/// Descript: 	取就诊号对应挂号费ID ？？？
/// InPut:      EmPCLvID-分诊级别ID
/// D ##Class(web.DHCEMPatCheckLev).GetEpiRegFeeID("")
ClassMethod GetEpiRegFeeID(EmPCLvID As %String) As %String
{
	n (EmPCLvID)
	Q:EmPCLvID="" 0
	s EmAdmID=$o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,""),-1)
	Q:EmAdmID="" 0
	s EpisodeID=$p(^DHCEMPCA(EmAdmID),"^",2)
	Q:EpisodeID="" ""
	&SQL(SELECT ID into :regFeeID FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:EpisodeID)
    Q regFeeID
}

/// Creator:  	bianshuai
/// CreateDate: 2017-08-17
/// Descript: 	科室号别是否发生变化
/// InPut:      EmPCLvID-分诊级别ID
/// D ##Class(web.DHCEMPatCheckLev).IsCarProChange("")
ClassMethod IsCarProChange(EmPCLvID As %String, EmListData As %String) As %String
{
	n (EmPCLvID, EmListData)
	Q:EmPCLvID="" 0
	s EmAdmID=$o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,""),-1)
	Q:EmAdmID="" 0
	s EpisodeID=$p(^DHCEMPCA(EmAdmID),"^",2)
	Q:EpisodeID="" ""
	s WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)
	//已就诊
	s VisitStatus=$p(^PAADM(EpisodeID),"^",20)
	s feeFlag=..checkAdmFee(EpisodeID)
	s EmPatChkCare=+$p(EmListData,"^",35)
	Q:+EmPatChkCare=0 0
	s EmLocID=+$p($p(EmListData,"^",35),",",2)      /// 科室ID //hxy 2022-10-21
	s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,""))
	Q:+EmPccID=0 0
	s EmCareProvID=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	s EmCareLocID=+$p(^DHCEMPCC(EmPccID),"^",1)   /// 科室ID //hxy 2022-10-21 st
	Q:(EmLocID=EmCareLocID)&&(EmCareProvID=EmPatChkCare) 1
	;Q:EmCareProvID=EmPatChkCare 0 //ed
	Q:$p(WalkStatus,"^",1)="Arrival" "-98"
	Q:(VisitStatus'="C")&&(feeFlag=1) "-99"
	Q 1
}

/// Creator:  	bianshuai
/// CreateDate: 2017-08-17
/// Descript: 	退号/插入挂号记录
/// InPut:      EmPCLvID-分诊级别ID
/// D ##Class(web.DHCEMPatCheckLev).InsEmPatDocReg("")
ClassMethod InsEmPatDocReg(EmPCLvID As %String, EmListData As %String, retFlag As %String, LgParams) As %String
{
	n (EmPCLvID, EmListData, retFlag, LgParams, %session)
	s Err=0
	s AdmReason="" ///病人费别（默认传空）
	s FeeStr="1||1||0||0"  ///收费内容  收取诊查费传“1||1||0||0”,不收诊查费传“1||0||0||0”
	s LocID=+$p(EmListData,"^",6)        ///  科室ID
    Q:LocID=0 0
    s EmCareList=$p(EmListData,"^",35)   ///  就诊号别
    Q:EmCareList="" 0
    s EmCareID=+$p(EmCareList,",",1)     ///  号别ID
    Q:EmCareID=0 0
	s EmLocID=+$p(EmCareList,",",2)      ///  科室ID
	Q:EmLocID=0 0
    s PatientID=$p(EmListData,"^",33)    ///  病人ID
	s LgLocID=$p(LgParams,"^",2)    /// 科室ID
	s LgUserID=$p(LgParams,"^",3)   /// 用户ID
	s LgGroupID=$p(LgParams,"^",4)  /// 安全组ID
	s PayModeCode=""
	s IsPayMoney=$p(EmListData,"^",54)
	s:IsPayMoney="Y" PayModeCode="CPP"
	s AccRowId=$p(EmListData,"^",55)
	
    i retFlag=1 d
    ./// 退号
    .s regFee=..GetEpiRegFeeID(EmPCLvID) 
    .s NewInvoiceId=""
	.s Err=##class(web.DHCOPAdmReg).CancelOPRegist(regFee,LgUserID,LgGroupID,LgLocID,.NewInvoiceId)
	Q:+Err'=0 Err
	/// 科室号别排班记录
	S ASRowId=##class(web.DHCOPAdmReg).GetRapidASRowId(EmLocID,"","","","",EmCareID)
	/// 调用挂号接口
																;(PatientID,ASRowId,AdmReason,FeeStr,user    , group   , LocID ,DocRowId, TimeRangeRowId,PayModeCode, AccRowId)
	s RegExpStr="^^^"_EmPCLvID //hxy 2022-08-26
	S DtatList=##class(web.DHCOPAdmReg).OPDocRapidRegistNewBroker(PatientID,ASRowId,AdmReason,FeeStr,LgUserID,LgGroupID,EmLocID,EmCareID,"",PayModeCode,AccRowId,RegExpStr)
	S Err=$p(DtatList,"^",1)
	Q:Err'=0 DtatList
	s EmAdmID=$p(DtatList,"^",2)
	s EmPatGreID=$o(^DHCEMPGR(0,"PatCheckLev",EmPCLvID,""),-1)
	d:EmPatGreID'="" ##Class(web.DHCEMInterfaceCom).UpdEmPatGreenDet(EmPatGreID,EmAdmID)
	Q:$d(^DHCEMPCA(0,"AdmChkLev",EmAdmID,EmPCLvID)) 0  /// 就诊和分级已关联
	&SQL(Insert Into DHC_EmPatChkAdm(PCA_Chk_Dr,PCA_Adm_Dr) Values(:EmPCLvID,:EmAdmID))
	Q SQLCODE
}

/// 返回<PATMAS><Name></Name><Sex></Sex>......</PATMAS>
/// zhouxin 2016-10-19
ClassMethod getPaPatXMLInfo(PatientID As %String, LgUserID) As %String
{
	n (PatientID,LgUserID)
	
	///改用医生站统一接口 zhouxin 2016-10-19
	s patVOObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	s patVOObj.Address=$g(^PAPER(PatientID,"PER","ADD",1))
	s patVOObj.Birth=##class(web.DHCEMCommonUtil).DateLogicalToHtml($p(^PAPER(PatientID,"ALL"),"^",6)) //$zd($p(^PAPER(PatientID,"ALL"),"^",6),4)
	s patVOObj.Sex=$p(^PAPER(PatientID,"ALL"),"^",7)
	s patVOObj.Name=$p(^PAPER(PatientID,"ALL"),"^",1)
	s patVOObj.UpdateDate=+$h
	s patVOObj.UpdateTime=$p($h,",",2)
	s patVOObj.PatType=$p(^PAPER(PatientID,"PER",1),"^",10)
	s patVOObj.CredNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	s patVOObj.PAPMIRowID=PatientID
	s patVOObj.NationDescLookUpRowID=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
	s patVOObj.CountryDescLookUpRowID=$p(^PAPER(PatientID,"PER",1),"^",8) 
	s patVOObj.TelHome=$p(^PAPER(PatientID,"PER",1),"^",11)
	s patVOObj.UserDR=LgUserID
	s patVOObj.PatType=$p(^PAPER(PatientID,"PER",1),"^",10)
	s patVOObj.EMail=$p($g(^PAPER(PatientID,"PER",4)),"^",19)
	s patVOObj.EmployeeNo=$p($g(^PAPER(PatientID,"EMP")),"^",5)
	s patVOObj.ForeignPhone=$p($g(^PAPER(PatientID,"ALL")),"^",4)
	s patVOObj.ForeignName=$p($g(^PAPER(PatientID,"PER",2)),"^",13)
	s patVOObj.Company=$p($g(^PAPER(PatientID,"PER",4)),"^",18)
	s patVOObj.CredType=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	s patVOObj.PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	s patVOObj.Allergy=$g(^PAPER(PatientID,"ALLERGY",1))
	s:$p($g(^PAPER("DHC",PatientID,1)),"^",2)'="" patVOObj.BirthTime=$zt($p($g(^PAPER("DHC",PatientID,1)),"^",2))
	d patVOObj.XMLExportToString(.myXmlData)
	d patVOObj.%Close()
	
	q myXmlData
}

ClassMethod checkAdmFee(adm As %String) As %String
{
	n (adm)
	s bci=$o(^DHCBCI(0,"ADM",adm,""))
	q:+bci=0 0
	q 1
	&SQL(SELECT ID into :I FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:adm)
	q:+I=0 0
	s InvPRTRowid=$List(^User.DHCRegistrationFeeD(I),11)
	q:+InvPRTRowid=0 0 
	s INVPRTNo=$P(^DHCINVPRT(InvPRTRowid),"^",14)
	q:INVPRTNo="" 0
	q 1
}

/// w ##class(web.DHCEMPatCheckLev).checkCare("127","13806^^2^^2^71^N^N^^^^^^N^N^^N^^^^^N^N^N^^^^^^N^N^^89^116^1534,71^2180^^^2#71#13806#199^Y^^^^^^^21^N##YM^N##QJ^N##LY^N##JC^^2021-05-21 10:47:39^Y^2701") 
ClassMethod checkCare(EmPCLvID As %String, ListData) As %String
{
	n (EmPCLvID,ListData)
	q:+EmPCLvID=0 0
	s EmPatChkCare=+$p(ListData,"^",35)   		///  预检号别表
	q:+EmPatChkCare=0 0
	s EmLocID=+$p($p(ListData,"^",35),",",2)    ///  科室ID //hxy 2022-10-21
	s EmCareProvID=0,EmCareLocID=0
	s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,""),-1)
	s:+EmPccID'=0 EmCareProvID=+$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	s:+EmPccID'=0 EmCareLocID=+$p(^DHCEMPCC(EmPccID),"^",1)    /// 科室ID //hxy 2022-10-21st
	q:(EmLocID=EmCareLocID)&&(EmPatChkCare=EmCareProvID) 1
	;q:EmPatChkCare=EmCareProvID 1 //ed
	q 0
}

/// 判断号别职称是否改变
/// w ##Class(web.DHCEMPatCheckLev).checkRBCSessionType(305,"4^2^1^^1^67^^^^^^^^^^^^^12:12"_$c(1)_"12"_$c(1)_"12"_$c(1)_"12"_$c(1)_"12"_$c(1)_"12"_$c(1)_"12"_$c(1)_"12||"_$c(1,1,1,1,1,1)_"^^188!发热:伴有咳嗽和咽痛#182!发热:急性呼吸窘迫^^^^^^^^^^^^491^317^924^^^^2#100#4#123")
ClassMethod checkRBCSessionType(EmPCLvID, EmListData) As %String
{
	n (EmPCLvID,EmListData)
	//$List(^User.DHCRegistrationFeeD(I),11)
	s ^ZXZX=EmPCLvID_"$$"_EmListData
	s adm=+$p(EmListData,"^",36) 
	q:(+EmPCLvID=0)&&(adm=0) 0
	s ret=0,odoc=0,oloc=0
	
	i +EmPCLvID'=0 d
	.s EmPccID=0
    .s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,"")) 
    .Q:+EmPccID=0 
	.s odoc=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	.s oloc=$p(^DHCEMPCC(EmPccID),"^",3)
	//b 
	i (+odoc=0)&&(adm'=0) d
	.&SQL(SELECT ID into :I FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:adm)
	.q:+I=0
	.s odoc=$List(^User.DHCRegistrationFeeD(I),14)   /// 预检号别
	.s oloc=$List(^User.DHCRegistrationFeeD(I),13)
	q:+odoc=0 0
	q:+oloc=0 0
	
	
	s loc=+$p(EmListData,"^",6)       ///  科室ID
	s doc=+$p(EmListData,"^",35)     ///  就诊号别
    q:loc=0 0
    q:doc=0 0
	 
	s res=$o(^RB("RES",0,"CTPCP",doc,loc,"")) 
	q:+res=0 0
	s ressub=$o(^RBAS(res,0))
	q:+ressub=0 0
	s type=$P($G(^RBAS(res,ressub,"DHC")),"^",6)
	s oldres=$o(^RB("RES",0,"CTPCP",odoc,oloc,"")) 
	q:+oldres=0 0
	s oldressub=$o(^RBAS(oldres,0))
	q:+oldressub=0 0
	s oldtype=$P($G(^RBAS(oldres,oldressub,"DHC")),"^",6)

	q:type'=oldtype 1
	q 0
}

/// Descript: 计算出生时间
/// w ##Class(web.DHCEMPatCheckLev).CalBirthTime("64344","5小时")
ClassMethod CalBirthTime(PatDob As %String, BirthTime As %String) As %String
{
	n (PatDob, BirthTime)
	Q ""
	Q:(BirthTime'["分钟")&(BirthTime'["小时") "00:00:00"
	i BirthTime["小时" D
	.i PatDob=+$h d
	..s BirthTime=$p($h,"," ,2)-$zth(+BirthTime_":00:00")
	.e  d
	..s BirthTime=((+$h-PatDob)*86400)-(+BirthTime*60*60-$p($h,"," ,2))
	.
	i BirthTime["分钟" D
	.s BirthTime=$p($h,"," ,2)-$zth("00:"_+BirthTime_":00")
	.
	Q $zt(BirthTime,1)
}

/// Descript:   预检分诊就诊记录是否可用
/// W ##Class(web.DHCEMPatCheckLev).HasPatChkLvEpi("")
ClassMethod HasPatChkLvEpi(EmPCLvID As %String) As %String
{
	n (EmPCLvID)
	q:+EmPCLvID=0 ""
	s quitflag=""
	s EmAdmID=""
	F  s EmAdmID=$o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,EmAdmID)) Q:(EmAdmID="")||(quitflag=1)  D
	.s EpisodeID=$p(^DHCEMPCA(EmAdmID),"^",2)
	.Q:EpisodeID=""
	.s quitflag=1
	.
	Q quitflag
}

/// Descript:  获取病人证件类型居民身份证对应的类型ID
/// w ##Class(web.DHCEMPatCheckLev).GetPatCredTypeID()
ClassMethod GetPatCredTypeID(IdentNo = "") As %String
{
	n (IdentNo)
	s CredTypeID="", ID=""
	F  s CredTypeID=$o(^PAC("CARD",CredTypeID)) Q:CredTypeID=""  D
	.s CredType=$p(^PAC("CARD",CredTypeID),"^",2)
	.;Q:(CredType'["居民身份证")&&(+IdentNo'=0)
	.q:CredType'["居民身份证"
	.s DataTo=$p(^PAC("CARD",CredTypeID),"^",4)
	.Q:(DataTo<+$H)&(DataTo'="")
	.s ID=CredTypeID
	Q ID
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-09
/// Descript:   Insert 医生变更病人分级表 DHC_EmDocUpdPatLev
/// InPut:      "级别^分诊原因ID^护士ID^护士分级评估^评估说明^日期(数字)^时间(数字)"
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMPatCheckLev).InsEmDocUpdPatLev("1141","1^2^600^1^的发射点")
ClassMethod InsEmDocUpdPatLev(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID, ListData)
	Q:EmPCLvID="" "-1"
	s UserID = $p(ListData,"^",1)     /// 分诊护士
	s EmLvCode=$p(ListData,"^",3)     /// 护士分级
	s EmLvCode=EmLvCode_"级"
	s EmLvID=$o(^CT("ACU",0,"Code",$$ALPHAUP^SSUTIL4(EmLvCode),""))
	Q:EmLvID="" -2
	s EmLvReaID = $p(ListData,"^",45) /// 分级原因
	Q:EmLvReaID="" 0
	s OperType = "Nur"
	s CreateDate = +$h
	s CreateTime = $p($h,",",2)
	&SQL(Insert into DHC_EmDocUpdPatLev(DUPL_Level, DUPL_UpdReason_Dr, DUPL_Operator, DUPL_OperateDate, DUPL_OperateTime,DUPL_OperateType,DUPL_Chk_Dr) 
		values(:EmLvID,:EmLvReaID,:UserID,:CreateDate,:CreateTime,:OperType,:EmPCLvID))

	Q SQLCODE
}

/// /// 保存ESI  
/// /// W ##Class(web.DHCEMPatCheckLev).saveEmPatChkESI(1,"2||1#3||2#4||1#")
/// /// InPut:      "级别^分诊原因ID^护士ID^护士分级评估^评估说明^日期(数字)^时间(数字)"
/// /// OutPut:     0-成功，其他-失败
/// 
ClassMethod saveEmPatChkESI(EmPCLvID As %String, strESI As %String) As %String
{
	n (EmPCLvID, strESI)
	q:EmPCLvID=""
    s esiId=+$o(^User.DHCEmPatChkESII("IndexChk",EmPCLvID,""))
    i esiId=0 d
    .s esiObj=##class(User.DHCEmPatChkESI).%New()
    e  d
    .s esiObj=##class(User.DHCEmPatChkESI).%OpenId(esiId)
    d esiObj.PCSChkDrSetObjectId(EmPCLvID)
    s esiObj.PCSESIEnDanger=$p(strESI,"#",1)
    s esiObj.PCSESIWait=$p(strESI,"#",2)
    s esiObj.PCSESIEmergencyCase=$p(strESI,"#",3)
    s esiObj.PCSESIException=$p(strESI,"#",4)
    s esiObj.PCSESIResource=$p(strESI,"#",5)
    s esiObj.PCSESIActive=$p(strESI,"#",6)
    s sc=esiObj.%Save()
 	q:$$$ISERR(sc) -1
	Q 0
}

/// /// 保存MEWS  
/// /// W ##Class(web.DHCEMPatCheckLev).saveEmPatChkMEWS(1,"2||1#3||2#4||1#")
/// 
ClassMethod saveEmPatChkMEWS(EmPCLvID As %String, str As %String) As %String
{
	n (EmPCLvID, str)
	q:EmPCLvID=""
    s id=+$o(^User.DHCEmPatChkMEWSI("IndexChk",EmPCLvID,""))
    i id=0 d
    .s obj=##class(User.DHCEmPatChkMEWS).%New()
    e  d
    .s obj=##class(User.DHCEmPatChkMEWS).%OpenId(id)
    d obj.PCGChkDrSetObjectId(EmPCLvID)
    s obj.PCGMEWSHeart=$p(str,"#",1)
    s obj.PCGMEWSSbp=$p(str,"#",2)
    s obj.PCGMEWSBreathe=$p(str,"#",3)
    s obj.PCGMEWSTemp=$p(str,"#",4)
    s obj.PCGMEWSAware=$p(str,"#",5)
    s obj.PCGMEWSActive=$p(str,"#",6)
    s sc=obj.%Save()
 	q:$$$ISERR(sc) -1
	Q 0
}

/// /// 保存REMS 
/// /// W ##Class(web.DHCEMPatCheckLev).saveEmPatChkREMS(1,"2||1#3||2#4||1#")
/// 
ClassMethod saveEmPatChkREMS(EmPCLvID As %String, str As %String) As %String
{
	n (EmPCLvID, str)
	q:EmPCLvID=""
    s id=+$o(^User.DHCEmPatChkREMSI("IndexChk",EmPCLvID,""))
    i id=0 d
    .s obj=##class(User.DHCEmPatChkREMS).%New()
    e  d
    .s obj=##class(User.DHCEmPatChkREMS).%OpenId(id)
    d obj.PCSChkDrSetObjectId(EmPCLvID)
    s obj.PCSREMSPulse=$p(str,"#",1)
    s obj.PCSREMSSpo2=$p(str,"#",2)
    s obj.PCSREMSSBP=$p(str,"#",3)
    s obj.PCSREMSBreathe=$p(str,"#",4)
    s obj.PCSREMSAge=$p(str,"#",5)
    s obj.PCSREMSActive=$p(str,"#",6)
    s sc=obj.%Save()
 	q:$$$ISERR(sc) -1
	Q 0
}

/// /// 保存自动得分项 
/// 
ClassMethod saveEmPatChkAutoScore(EmPCLvID As %String, str As %String) As %String
{
	n (EmPCLvID, str)
	q:EmPCLvID=""
    s scoreId=""
    f  s scoreId=$o(^User.DHCEmPatChkScoreItmI("IndexChk",EmPCLvID,scoreId)) q:scoreId=""  d
    .d ##class(User.DHCEmPatChkScoreItm).%DeleteId(scoreId)
    
    s ret=0
    f i=1:1:$l(str,"^")  q:ret'=0  d
    .s tmp=$p(str,"^",i)
    .s code=$p(tmp,"||",1)
    .q:code=""
    .s tmpScoreId=+$o(^User.DHCEmPatChkScoreItmI("IndexChkCode",EmPCLvID," "_code,""))
    .i tmpScoreId=0 d
    ..s obj=##class(User.DHCEmPatChkScoreItm).%New()
    .e  d
    ..s obj=##class(User.DHCEmPatChkScoreItm).%OpenId(tmpScoreId)
    .d obj.PCSChkDrSetObjectId(EmPCLvID)
    .s obj.PCSItm=$p(tmp,"||",4)
    .s obj.PCSItmCode=$p(tmp,"||",1)
    .s obj.PCSLevel=$p(tmp,"||",2)
    .s obj.PCSScore=$p(tmp,"||",3)
    .s sc=obj.%Save()
    .s:$$$ISERR(sc) ret=-1
	Q ret
}

/// /// 删除坠伤
/// 
ClassMethod clearFALL(EmPCLvID As %String) As %String
{
	n (EmPCLvID)
	q:EmPCLvID=""
	S FALLId=""
	F  S FALLId = $o(^DHCEMPCF(0,"CHECKLEV",EmPCLvID,FALLId)) Q:FALLId=""  D
	.S $p(^DHCEMPCF(FALLId),"^",3)=""
	Q ""
}

/// /// 保存坠跌  张海龙 
/// /// W ##Class(web.DHCEMPatCheckLev).saveEmPatChkFALL(1,"2||1#3||2#4||1#")
/// 
ClassMethod saveEmPatChkFALL(EmPCLvID As %String, strFALL As %String) As %String
{
	n (EmPCLvID, strFALL)
	q:EmPCLvID=""
	d ##class(web.DHCEMPatCheckLev).clearFALL(EmPCLvID)  //清除表中数据
	q:strFALL="" "0"
	for i=1:1:$l(strFALL,"#")-1 d
	.s rs=""
	.s FalliId = $p(strFALL,"#",i)
	.s FallId = $p(FalliId,"||",1)
	.s count =""
	.&sql(select count(*)into:count from DHC_EmPatChkFall where PCF_Chk_Dr=:EmPCLvID and PCF_Fall_Dr=:FallId )
	.b
	.i (count>0)  d
	.. &sql(update DHC_EmPatChkFall set PCF_FallItem_Dr =:FalliId where PCF_Chk_Dr=:EmPCLvID and PCF_Fall_Dr=:FallId )
	..s rs=SQLCODE
	.e  d 
	..&sql(insert into DHC_EmPatChkFall values(:EmPCLvID,:FallId,:FalliId))
	..s rs=SQLCODE
	Q rs
}

/// /// Descript:	疼痛评分 zhl 2018-02-06
/// 
ClassMethod SaveEmPatChkPain(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID, ListData)
	s pchiflag=0
	s EmPcpScore=$p(ListData,"#",1) 	
	s EmPcpTime=$p(ListData,"#",3) 
	s EmPcpNature=$p(ListData,"#",4) 
	s EmMethod=$p(ListData,"#",5)
	s EmActive=$p(ListData,"#",6)
	s PCPPos=$p(ListData,"#",2)     
	
	i '$d(^DHCEMPCP(0,"PatCheckLev",EmPCLvID))  d
	.b
	.&SQL(Insert Into DHC_EmPatChkPain(PCP_Chk_Dr,PCP_Nature,PCP_Score,PCP_Time,PCP_Method,PCP_Active,PCP_Pos)
		Values(:EmPCLvID,:EmPcpNature,:EmPcpScore,:EmPcpTime,:EmMethod,:EmActive,:PCPPos))
	.i SQLCODE'=0  s pchiflag="-1" 
	e  d
	.s pchipRowId=$o(^DHCEMPCP(0,"PatCheckLev",EmPCLvID,""))
	.&SQL(update DHC_EmPatChkPain set PCP_Chk_Dr=:EmPCLvID,PCP_Nature=:EmPcpNature,PCP_Score=:EmPcpScore,PCP_Time=:EmPcpTime,PCP_Method=:EmMethod,PCP_Active=:EmActive,PCP_Pos=:PCPPos
	  where PCP_RowId=:pchipRowId)
	.i SQLCODE'=0  s pchiflag="-1" 
    q pchiflag
}

/// Descript:保存其他评分项
/// w ##class(web.DHCEMPatCheckLev).SaveEmPatChkOtherScore("174","","^^1^")
ClassMethod SaveEmPatChkOtherScore(EmPCLvID, otherScore, LgParams)
{
	n (EmPCLvID,otherScore,LgParams)
	s LgUserID=$p(LgParams,"^",3)   /// 用户ID
	s Len=$l(otherScore,"##")
	s Err=0
	f i=1:1:Len q:Err<0  d
	.s ItmScore = $p(otherScore,"##",i)
	.q:ItmScore=""
	.s ItmScoreScale=$p(ItmScore,$c(2),1)
	.s ItmScoreDr = $p(ItmScoreScale,"^",4)
	.s $p(ItmScoreScale,"^",2)= LgUserID	///用户ID
	.s $p(ItmScoreScale,"^",6)= EmPCLvID	///增加分诊ID
	.s $p(ItmScore,$c(2),1) = ItmScoreScale
	.s ItmScoreRowID = ##Class(web.DHCEMCScore).GetScoreRowID(EmPCLvID,ItmScoreDr)
	.s Err = ##Class(web.DHCEMCScore).Insert(ItmScoreRowID,ItmScore)	///返回值为评分表ID
	.q:Err<0
	s:Err>0 Err=0
	q Err
}

/// /// 保存儿童预警评分
/// /// lp 20200911 
/// /// W ##Class(web.DHCEMPatCheckLev).SaveEmChildEmr(1,"2||1#3||2#4||1#")
/// 
ClassMethod SaveEmChildEmr(EmPCLvID As %String, str As %String) As %String
{
	n (EmPCLvID, str)
	q:EmPCLvID=""
    s id=+$o(^User.DHCEmChildEarWarnI("IndexChk",EmPCLvID,""))
    i id=0 d
    .s obj=##class(User.DHCEmChildEarWarn).%New()
    e  d
    .s obj=##class(User.DHCEmChildEarWarn).%OpenId(id)
    d obj.CEWChkDrSetObjectId(EmPCLvID)
    s obj.CEWAware=$p(str,"#",1)
    s obj.CEWCvlSys=$p(str,"#",2)
    s obj.CEWRptSys=$p(str,"#",3)
    s sc=obj.%Save()
 	q:$$$ISERR(sc) -1
	Q 0
}

ClassMethod GetConfig(LgHospID, LgCtLocID, LgUserID, LgGroupID) As %String
{
	n (LgHospID,LgCtLocID,LgUserID,LgGroupID)
	
	s PATTYPE=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","PATTYPE",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s MODIFYPAT=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","MODIFYPAT",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s ISSHOWDRUG=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","ISSHOWDRUG",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s ISSHOWECG=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","ISSHOWECG",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s ISNEEDCARD=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","ISNEEDCARD",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s GreenEffectSwitch=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENEFFECTSWITCH",LgHospID,LgCtLocID,LgUserID,LgGroupID)
    s GreenModifyTime=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENMODIFYTIME",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s AISSCORE=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","AISSCORE",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s READDEVDATA=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","READDEVDATA",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s Ret=PATTYPE_"^"_MODIFYPAT_"^"_ISSHOWDRUG_"^"_ISSHOWECG_"^"_ISNEEDCARD_"^"_GreenEffectSwitch_"^"_GreenModifyTime_"^"_AISSCORE
	s Ret=Ret_"^"_READDEVDATA
	Q Ret
}

/// Descrip:后期分离了护士和分诊护士的配置
ClassMethod GetConfigNew(LgHospID, LgCtLocID, LgUserID, LgGroupID) As %String
{
	n (LgHospID,LgCtLocID,LgUserID,LgGroupID)
	
	s PATTYPE=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","PATTYPE",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s MODIFYPAT=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","MODIFYPAT",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s ISSHOWDRUG=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","ISSHOWDRUG",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s ISSHOWECG=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","ISSHOWECG",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s ISNEEDCARD=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","ISNEEDCARD",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s GreenEffectSwitch=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENEFFECTSWITCH",LgHospID,LgCtLocID,LgUserID,LgGroupID)
    s GreenModifyTime=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENMODIFYTIME",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s AISSCORE=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","AISSCORE",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s READDEVDATA=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","READDEVDATA",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s CANUPDARRDATE=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","CANUPDARRDATE",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s MAXWIDTH=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","MAXWIDTH",LgHospID,LgCtLocID,LgUserID,LgGroupID) //hxy 2020-02-17
	s AUTOPRINT=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","AUTOPRINT",LgHospID,LgCtLocID,LgUserID,LgGroupID) //hxy 2020-02-17
	s GREENAUDIT=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENAUDIT",LgHospID,LgCtLocID,LgUserID,LgGroupID) //hxy 2022-07-14

	s Ret=PATTYPE_"^"_MODIFYPAT_"^"_ISSHOWDRUG_"^"_ISSHOWECG_"^"_ISNEEDCARD_"^"_GreenEffectSwitch_"^"_GreenModifyTime_"^"_AISSCORE
	s Ret=Ret_"^"_READDEVDATA_"^"_CANUPDARRDATE_"^"_MAXWIDTH_"^"_AUTOPRINT_"^"_GREENAUDIT
	Q Ret
}

/// w ##class(web.DHCEMPatCheckLev).GroupHurtPatReg("12^^^^^^1^6469^29/01/2019 16:19:11^群伤地点^群伤描述")
ClassMethod GroupHurtPatReg(params)
{
	n (params ,%session)
	;12^^^11月11天^^01/01/2018^1^4636
	s GroupHurtType=$p(params,"^",1) 
	s GroupHurtPatName=$p(params,"^",2)
	s GroupHurtPatSex=$p(params,"^",3)
	s GroupHurtPatAge=$p(params,"^",4)
	s GroupHurtPatNation=$p(params,"^",5)
	s GroupHurtPatBirth=$p(params,"^",6)
	;s:GroupHurtPatBirth="" GroupHurtPatBirth = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(+$h)
	s total=$p(params,"^",7)
	s UserID=$p(params,"^",8)
	s GroupHurtDateInfo = $p(params,"^",9)
	s GroupHurtDate = $p(GroupHurtDateInfo," ",1)
	s GroupHurtTime = $p(GroupHurtDateInfo," ",2)
	s:GroupHurtDate'="" GroupHurtDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(GroupHurtDate)
	s:GroupHurtDate="" GroupHurtDate=+$h
	s:GroupHurtTime'="" GroupHurtTime = $zth(GroupHurtTime)
	s:GroupHurtTime="" GroupHurtTime = $p($h,",",2)
	q:(GroupHurtDate>+$h)||((GroupHurtDate=+$H)&&(GroupHurtTime>$p($h,",",2))) "-1"
	s GroupHurtSite = $p(params,"^",10)
	s GroupHurtDesc = $p(params,"^",11)
	s LgHospID = $p(params,"^",12)
	
	s Prefix=..GetPrefix(LgHospID) //hxy 2022-09-28

	TS
	s quitflag=0
	f lv=1:1:total  d
	.///改用医生站统一接口 zhouxin 2016-10-19
	.s patVOObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	.
	.s patVOObj.Birth=GroupHurtPatBirth  //hxy $zd(PatDob,4)
	.s BirthTime=##Class(web.DHCEMPatCheckLev).CalBirthTime(GroupHurtPatBirth,GroupHurtPatAge)
	.s patVOObj.BirthTime=BirthTime
	.s:+GroupHurtPatSex=0 GroupHurtPatSex=3   //默认是未知性别
	.s patVOObj.Sex=GroupHurtPatSex
	.i GroupHurtPatName="" d
	..s EmPatChkMaxNo=..GetEmPatChkMaxNo(Prefix,3) //("EM",3)
	..s patname="无名氏"_EmPatChkMaxNo
	..D ..InsEmPatChkNo(EmPatChkMaxNo)
	..s patVOObj.Name=patname
	.e  s patVOObj.Name=GroupHurtPatName
	.s patVOObj.UpdateDate=+$h
	.s patVOObj.UpdateTime=$p($h,",",2)
	.s patVOObj.PatType=$o(^CT("SS",0))
	.s patVOObj.PAPMIRowID=""
	.s patVOObj.UserDR = UserID
	.s patVOObj.NationDescLookUpRowID=GroupHurtPatNation
	.s patVOObj.CredType=..GetPatCredTypeID("")
	.s rtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(patVOObj)	   //保存病人信息
	.s err=$p(rtn,"^",1)
	.s ret=$p(rtn,"^",2)
	.s:err'=0 quitflag=-1
	.s GPSCreateDate=+$h
	.s GPSCreateTime=$p($h,",",2)
	.s GPSPAPMIDr=ret
	.s GPSGHUDr=GroupHurtType
	.s VirtulCardInput = GPSPAPMIDr_"^"_$p(^PAPER(GPSPAPMIDr,"PAT",1),"^",1)_"^"_"1"
	.s rtn = 0 ;##class(web.DHCBL.CARD.UCardPatRegBuilder).CreatVirtulCardInfo(VirtulCardInput,UserID)
	.&SQL(insert into DHC_EmGroupPatAsso (GPS_CreateDate,GPS_CreateTime,GPS_PAPMI_Dr,GPS_GHU_Dr,GPS_StDate,GPS_StTime,GPS_Site,GPS_Desc,GPS_Hosp_Dr)
		values(:GPSCreateDate,:GPSCreateTime,:GPSPAPMIDr,:GPSGHUDr,:GroupHurtDate,:GroupHurtTime,:GroupHurtSite,:GroupHurtDesc,:LgHospID))
	.s:+$g(SQLCODE)'=0 quitflag=-2

	i quitflag'=0 TRO
	q:quitflag'=0 quitflag

	TC
	q 0
}

/// Creator:ylp
/// Descipt:获取生命体征接口
/// Input:IP地址
ClassMethod GetDevDataInterface(IPAdress)
{
	n (IPAdress)
	
	q:'$d(^YGRHSKLWHB(IPAdress)) ""
	s IPData=^YGRHSKLWHB(IPAdress,"OmronHBP")
	
	s Rtn=##class(web.DHCANAdaptor).GetDevData($p(IPData,"^",3),$p(IPData,"^",2),$p(IPData,"^",1),"OmronHBP")
	
	s SBP=$p($p(rtn,"^",2),"#",5)
	s SDP=$p($p(rtn,"^",3),"#",5)
	s Pulse=$p($p(rtn,"^",4),"#",5)
	q SBP_"^"_SDP_"^"_Pulse
}

/// Creator:    bianshuai
/// CreateDate: 2020-03-18
/// Descript:   修改病人就诊时间
/// InPut:      EpisodeID - 就诊ID
/// OutPut:     0 - 成功, 其他 - 失败
/// w ##Class(web.DHCEMPatCheckLev).modPatRegTime("1", "2020-03-18^10:00")
ClassMethod modPatRegTime(EpisodeID As %String, mParams As %String) As %String
{
	n (EpisodeID, mParams)
	Q:EpisodeID="" 0
	s admDate=$p(mParams,"^",1), admTime=$p(mParams,"^",2)
	i admDate'="" s admDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(admDate)
	s:admTime'="" admTime=$zth(admTime,1)
	
	s MRdiaDate="",MRdiaTime=""
	s MRAMRsub=$o(^MR(EpisodeID,"DIA",0))
 	i MRAMRsub'="" d 
 	.s MRdiaDate=$p(^MR(EpisodeID,"DIA",MRAMRsub),"^",7) //下诊断日期
 	.s MRdiaTime=$p($g(^MR(EpisodeID,"DIA",MRAMRsub)),"^",8) //下诊断时间
	q:(MRdiaDate'="")&&(MRdiaDate<admDate) "日期不能晚于下诊断日期"
	q:(MRdiaDate'="")&&(MRdiaDate=admDate)&&(MRdiaTime<admTime) "时间不能晚于下诊断时间"
	
	&SQL(Update PA_Adm Set PAADM_AdmDate=:admDate, PAADM_AdmTime=:admTime where PAADM_RowID=:EpisodeID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2020-03-18
/// Descript:   取病人就诊时间
/// InPut:      EpisodeID - 就诊ID
/// OutPut:     
/// w ##Class(web.DHCEMPatCheckLev).GetPatRegTime("1")
ClassMethod GetPatRegTime(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s admDate=$p(^PAADM(EpisodeID),"^",6) /// 就诊日期
	s admDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(admDate)
	s admTime=$p(^PAADM(EpisodeID),"^",7) /// 就诊时间
	s:admTime'="" admTime=$zt(admTime,1)
	w ##class(web.DHCAPPJsonCommon).getJsonData("admDate^admTime",admDate_"^"_admTime)
	Q ""
}

/// Descript:   插入群伤病人登记关联表
ClassMethod InsGroupHurtPat(params) As %String
{
	n (params ,%session)
	s GroupHurtType=$p(params,"^",1) 
	s GroupHurtPatName=$p(params,"^",2)
	s GroupHurtPatSex=$p(params,"^",3)
	s GroupHurtPatAge=$p(params,"^",4)
	s GroupHurtPatNation=$p(params,"^",5)
	s GroupHurtPatBirth=$p(params,"^",6)
	s:GroupHurtPatBirth="" GroupHurtPatBirth = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(+$h)
	s total=$p(params,"^",7)
	s UserID=$p(params,"^",8)
	s GroupHurtDateInfo = $p(params,"^",9)
	s GroupHurtDate = $p(GroupHurtDateInfo," ",1)
	s GroupHurtTime = $p(GroupHurtDateInfo," ",2)
	s:GroupHurtDate'="" GroupHurtDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(GroupHurtDate)
	s:GroupHurtDate="" GroupHurtDate=+$h
	s:GroupHurtTime'="" GroupHurtTime = $zth(GroupHurtTime)
	s:GroupHurtTime="" GroupHurtTime = $p($h,",",2)
	s GroupHurtSite = $p(params,"^",10)
	s GroupHurtDesc = $p(params,"^",11)
	s GPSPAPMIDr=$p(params,"^",12)
	s GPSCreateDate=+$h
	s GPSCreateTime=$p($h,",",2)
	s GPSGHUDr=GroupHurtType
	i '$d(^DHCEMGPS(0,"PAPMI",GPSPAPMIDr)) d
	.&SQL(insert into DHC_EmGroupPatAsso (GPS_CreateDate,GPS_CreateTime,GPS_PAPMI_Dr,GPS_GHU_Dr,GPS_StDate,GPS_StTime,GPS_Site,GPS_Desc)
	  values(:GPSCreateDate,:GPSCreateTime,:GPSPAPMIDr,:GPSGHUDr,:GroupHurtDate,:GroupHurtTime,:GroupHurtSite,:GroupHurtDesc))
	e  d
	.s GPSRowID=$o(^DHCEMGPS(0,"PAPMI",GPSPAPMIDr,""),-1)
	.&sql(update DHC_EmGroupPatAsso set GPS_CreateDate =:GPSCreateDate,GPS_CreateTime =:GPSCreateTime,GPS_GHU_Dr =:GPSGHUDr,
	 GPS_StDate =:GroupHurtDate,GPS_StTime =:GroupHurtTime,GPS_Site =:GroupHurtSite,GPS_Desc =:GroupHurtDesc
	 where GPS_RowID=:GPSRowID )
	Q SQLCODE
}

/// Descript:   插入群伤病人登记关联表
/// W ##class(web.DHCEMPatCheckLev).InsGroupHurtPatNew("65757,40120,2,12",1164)
ClassMethod InsGroupHurtPatNew(QsIndex, PatientID) As %String
{
	n (QsIndex,PatientID)
	
	s InCreatDate=$p(QsIndex,",",1)
	s InCreatTime=$p(QsIndex,",",2)
	s InHospID=$p(QsIndex,",",3)
	s InQsTypeID=$p(QsIndex,",",4)
	
	s GPSRowID = ##class(web.DHCEMPatCheckLevQuery).GetQsRowID(QsIndex)
	q:+GPSRowID=0 "未找到对应群伤事件！"
	
	K PLIST
	&sql(SELECT * INTO :PLIST() FROM DHC_EmGroupPatAsso WHERE GPS_RowID=:GPSRowID)
	s PLIST(1)=""
	s PLIST(4)=PatientID
	
	&sql(INSERT INTO DHC_EmGroupPatAsso VALUES PLIST())
	Q SQLCODE
}

/// Descript:   删除群伤关联患者
ClassMethod DelGroupHurtPat(QsRowID As %String) As %String
{
	n (QsRowID)
	&SQL(delete from DHC_EmGroupPatAsso where GPS_RowID =:QsRowID)
	Q SQLCODE
}

/// Description: 24小时内超时患者
/// Creator:     hxy
/// CreateDate:  2019-11-13
/// Return： 	 0:成功
/// Others:		 W ##class(web.DHCEMPatCheckLev).DealWaitOutPat(0518,1320,"更改分级^1^17^")
ClassMethod DealWaitOutPat(EmPCLvID As %String, LgUserID As %String, DealParams As %String, LgGroupID = "")
{
	n (EmPCLvID,LgUserID,DealParams,LgGroupID)
	s Result=$p(DealParams,"^",1) //处理结果 修改分级 修改分级原因 暂不处理原因
	s DealNurseLevel=$p(DealParams,"^",2)
	s EmNurReaDeal=$p(DealParams,"^",3)
	s NoDealRea=$p(DealParams,"^",4)
	s Date=$zd($h,3)
	s Time=$zt($h,2)
	s DateTime=Date_" "_Time
	s ResultCon=""
	s PCHIIMText=""
	s PCHIMHis=$o(^DHCEMPHIM(0,"Code","等待超时","")) //等待超时
	q:PCHIMHis="" "-1"
	s ret="0",Err="0"
	
	s DealNurseArea=$case(DealNurseLevel,1:1,2:2,3:3,4:4,5:4,:"")
	
	TS
	//预检分级主表分级修改
	i +DealNurseLevel'=0 d
	.&SQL(Update DHC_EmPatCheckLev Set PCL_NurseLevel=:DealNurseLevel,PCL_Area=:DealNurseArea Where PCL_RowID=:EmPCLvID)
	.i SQLCODE'=0 tro
	.s:SQLCODE'=0 Err=SQLCODE
	q:Err'=0 Err

    //更新就诊表分级字段 预检分级 2017-03-08 bianshuai 
    i +DealNurseLevel'=0 d
    .s EmListData="^^"_DealNurseLevel
	.s Err=##Class(web.DHCEMPatCheckLev).InsAdmPatChkLv(EmPCLvID,EmListData)
	.i Err'=0 tro
	q:Err'=0 "-21"
	
	//插护士修改分级记录  
	i +DealNurseLevel'=0 d
	.s ListData=LgUserID_"^"_DealNurseLevel_"^"_EmNurReaDeal
	.s Err=##Class(web.DHCEMPatCheckLev).InsEmDocUpdPatLevByDeal(EmPCLvID,ListData)
	.i Err'=0 tro 
	q:Err'=0 "-22"
	
	//优先
	i Result="优先" d
	.s Err=##class(web.DHCEMPatCheckLev).Priority(EmPCLvID,DateTime)
	.;s QueStateDr=$List(^User.DHCQueueD(QueID),14)
	.;s StatusPerName=$Lg(^User.DHCPerStateD(QueStateDr),4)
	.;s Err = ##class(web.DHCAlloc).PatPrior("PatPriorToHUI","",QueID,"",LgUserID,LgGroupID)
	.i Err'=0 tro
	q:Err'=0 "-23"
	
	
	//存处理记录
	s PCHIIMText=Result_"#"_DateTime_"#"_LgUserID_"#"_ResultCon //ResultCon：暂不处理存原因
	s Err=..UpdOrInsEmPatChkHisMoreS(EmPCLvID,"DDCS",PCHIMHis,PCHIIMText)    
	i Err'=0 tro
	q:Err'=0 "-24"
	
	TC
	q ret
}

/// Descript:	预检综合既往史 hxy 2019-09-07
/// w ##Class(web.DHCEMPatCheckLev).UpdOrInsEmPatChkHisMoreObsAG(1509,2,"")
ClassMethod UpdOrInsEmPatChkHisMoreS(EmPCLvID As %String, Flag As %String, PCHIMHis As %String, PCHIIMText = "") As %String
{
	n (EmPCLvID,Flag,PCHIMHis,PCHIIMText)	
	s EmFlagY=-1
	s EmChkId=""
	f  s EmChkId=$o(^DHCEMPCHIM("0","PatCheckLev",EmPCLvID,EmChkId)) q:EmChkId=""  d
	.s PCHIMHisDr=$P(^DHCEMPCHIM(EmChkId),"^",2)
	.s PHIMType=$p($g(^DHCEMPHIM(+PCHIMHisDr)),"^",5)
	.q:PHIMType'=Flag
	.i (EmChkId) D		 
	..&SQL(update DHC_EmPatChkHisMore set PCHIM_His_Dr=:PCHIMHis,PCHIIM_Text=:PCHIIMText where PCHIM_RowID=:EmChkId)
	..i SQLCODE=0 s EmFlagY=0
	i EmFlagY'=0 d
    .&SQL(Insert Into DHC_EmPatChkHisMore(PCHIM_Chk_Dr,PCHIM_His_Dr,PCHIIM_Text) Values(:EmPCLvID,:PCHIMHis,:PCHIIMText))
    .i SQLCODE=0 s EmFlagY=0
	q EmFlagY
}

/// Creator:    hxy
/// CreateDate: 2019-11-14
/// Descript:   Insert 医生变更病人分级表 DHC_EmDocUpdPatLev
/// InPut:      "护士ID^分级^更改原因ID"
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMPatCheckLev).InsEmDocUpdPatLevByDeal("1141","1^2^600^1^的发射点")
ClassMethod InsEmDocUpdPatLevByDeal(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID, ListData)
	b
	Q:EmPCLvID="" "-1"
	s UserID = $p(ListData,"^",1)     /// 分诊护士
	s EmLvCode=$p(ListData,"^",2)     /// 护士分级
	s EmLvCode=EmLvCode_"级"
	s EmLvID=$o(^CT("ACU",0,"Code",$$ALPHAUP^SSUTIL4(EmLvCode),""))
	Q:EmLvID="" -2
	s EmLvReaID = $p(ListData,"^",3) /// 分级原因
	Q:EmLvReaID="" 0
	s OperType = "Nur"
	s CreateDate = +$h
	s CreateTime = $p($h,",",2)
	&SQL(Insert into DHC_EmDocUpdPatLev(DUPL_Level, DUPL_UpdReason_Dr, DUPL_Operator, DUPL_OperateDate, DUPL_OperateTime,DUPL_OperateType,DUPL_Chk_Dr) 
		values(:EmLvID,:EmLvReaID,:UserID,:CreateDate,:CreateTime,:OperType,:EmPCLvID))

	Q SQLCODE
}

/// Descript:   急诊病人优先
/// Creator:    huaxiaoying
/// CreateDate: 2019-09-10
/// w ##class(web.DHCEMPatCheckLev).Priority(266,1)
ClassMethod Priority(PCLRowID, Text)
{
	n (PCLRowID,Text)
	s Ret=0
	s PCHIMHis=$o(^DHCEMPHIM(0,"Code","优先",""))
	s Ret=##class(web.DHCEMPatCheckLev).UpdOrInsEmPatChkHisMoreS(PCLRowID,"YX",PCHIMHis,Text)
	q Ret
}

/// Descript: 插入生命体征信息 
/// Creator:    cy
/// CreateDate: 2022-07-25
ClassMethod InsVitalsigns(EmPCLvID As %String, ListData As %String) As %String
{
	n (EmPCLvID,ListData)
	s pchimHisId=$p(ListData,"^",57)             //维护表id
	s Err=0
	s pchimId=$o(^DHCEMPCHIM(0,"PatCheckLev",EmPCLvID,""))
	i pchimId="" d
	.s Err=..InsEmVitalsign(EmPCLvID,pchimHisId)       /// 插入万能表
	.q:Err'=0
	e  d
	.s Err=..UpdEmVitalsign(pchimId,EmPCLvID,pchimHisId) /// 更新万能表
	.q:Err'=0
	q Err
}

/// Descript:   插入生命体征信息
/// Creator:    cy
/// CreateDate: 2022-07-25
ClassMethod InsEmVitalsign(EmPCLvID As %String, pchimHisId As %String) As %String
{
	n (EmPCLvID,pchimHisId)
	s pchimFlag="N"
	&SQL(Insert Into DHC_EmPatChkHisMore(PCHIM_Chk_Dr,PCHIM_His_Dr,PCHIIM_Flag)
		Values(:EmPCLvID,:pchimHisId,:pchimFlag))
	Q SQLCODE
}

/// Descript:   更新生命体征信息
/// Creator:    cy
/// CreateDate: 2022-07-25
ClassMethod UpdEmVitalsign(pchimId, EmPCLvID As %String, pchimHisId As %String) As %String
{
	n (pchimId,EmPCLvID,pchimHisId)
	s pchimFlag="N"
	&SQL(update DHC_EmPatChkHisMore set PCHIM_Chk_Dr=:EmPCLvID,PCHIM_His_Dr=:pchimHisId,PCHIIM_Flag=:pchimFlag where PCHIM_RowID=:pchimId)
	Q SQLCODE
}

/// Descript:   获取无名氏命名规则
/// Creator:    hxy
/// CreateDate: 2022-09-06
/// W ##Class(web.DHCEMPatCheckLev).GetPrefix("2^35^7930^199")
ClassMethod GetPrefix(LgParams As %String) As %String
{
	n (LgParams)
	s Ret="EM"
	s Flag=##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("NAMELESSRULE",LgParams)
	s:Flag=1 Ret=$zd($h,8) ;1:无名氏+年月日+00X（序号）
	q Ret
}

}
