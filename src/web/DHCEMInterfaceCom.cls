Import SQLUser

/// Creator: 	 zhouxin
/// CreateDate:  2016-01-19
/// Descript:    新产品研发组(预检分诊模块)对外接口公共类
Class web.DHCEMInterfaceCom Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  用于急诊预检分诊
///            1:病人登记队列,2:不插入挂号记录的情况 
///            病人挂完号后和病人预检登记记录关联下,  
/// Input:     PatientId-病人ID,EpisodeId-病人admid,RbResourceId-RB_Resource的rowid
/// w ##Class(web.DHCEMInterfaceCom).UpdateEmChk(478,635,545)
ClassMethod UpdateEmChkOLD(PatientId As %String, EpisodeId As %String, RbResourceId As %String) As %String
{
	n (PatientId,EpisodeId,RbResourceId)
	s Err=0,ExistFlag=0
	//该就诊记录已经分诊过
	s empca=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeId,""))
	q:+empca'=0 Err
	s emreg="" f  s emreg=$o(^DHCEMPCL(0,"EmPatReg",PatientId,emreg),-1) q:(emreg="")||(ExistFlag'=0)  d
	.s empcl=""  f  s empcl=$o(^DHCEMPCL(0,"EmPatReg",PatientId,emreg,empcl),-1) q:(empcl="")||(ExistFlag'=0)  d
	..s empca=$o(^DHCEMPCA(0,"PatCheckLev",empcl,""))
	..q:+empca'=0
	..s empcc=$o(^DHCEMPCC(0,"PatCheckLev",empcl,""))
	..q:+empcc=0
	..s emcare=+$p(^DHCEMPCC(empcc),"^",2)
	..q:emcare=0
	..s emloc=+$p(^DHCEMPCC(empcc),"^",3)
	..q:emloc=0
	..s emres=$o(^RB("RES",0,"CTPCP",emcare,emloc,""))
	..q:+emres=0
	..i emres=RbResourceId d
	...s ExistFlag=1
	...//&SQL(delete from DHC_EmPatChkAdm where PCA_Chk_Dr=:empcl)
	...&SQL(Insert Into DHC_EmPatChkAdm(PCA_Chk_Dr,PCA_Adm_Dr) Values(:empcl,:EpisodeId))    
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2017-02-25
/// Descript:   取病人预检号别信息【24小时内的号别】
/// InPut:      病人ID
/// OutPut:     号别ID^科室ID^分级ID^分诊日期^分诊时间^绿色通道^抢救病区ID||号别ID^科室ID^分级ID^分诊日期^分诊时间^绿色通道^抢救病区ID
/// w ##Class(web.DHCEMInterfaceCom).GetPatChkLvCareInfo("298")
ClassMethod GetPatChkLvCareInfo(PatientID As %String, Admflag As %String = "1") As %String
{
	n (PatientID, Admflag)
	Q:PatientID="" ""
	s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1) 
	Q:EmRegID="" ""
	s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1)
	Q:EmPCLvID="" ""
	Q:($d(^DHCEMPCA(0,"PatCheckLev",EmPCLvID)))&&(Admflag=1) ""
	s EmPCLvDate=$p(^DHCEMPCL(EmPCLvID),"^",4)  /// 分诊日期
	s EmPCLvTime=$p(^DHCEMPCL(EmPCLvID),"^",5)  /// 分诊时间
	s EmWardID=$p(^DHCEMPCL(EmPCLvID),"^",47)   /// 抢救病区
	Q:EmPCLvDate<(+$H-1) ""
	Q:(EmPCLvDate=(+$H-1))&(EmPCLvTime<$p($h,",",2)) ""
	s:EmPCLvDate'="" EmPCLvDate=$zd(EmPCLvDate,3)
	s:EmPCLvTime'="" EmPCLvTime=$zt(EmPCLvTime,1)
	s EmPatGreFlag=##Class(web.DHCEMPatCheckLev).GetEmPatGreenFlag(EmPCLvID,"") /// 绿色通道标示
	s EmListData=""
	s EmPCLCareID=""
	f  s EmPCLCareID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,EmPCLCareID)) Q:EmPCLCareID=""  D
	.s EmPCLCare=$p(^DHCEMPCC(EmPCLCareID),"^",2)  /// 号别 CT_CareProv
	.s EmPCLLocID=$p(^DHCEMPCC(EmPCLCareID),"^",3) /// 科室 CT_Loc
	.i EmListData=""  s EmListData=EmPCLCare_"^"_EmPCLLocID_"^"_EmPCLvID_"^"_EmPCLvDate_"^"_EmPCLvTime_"^"_EmPatGreFlag_"^"_EmWardID
	.E  s EmListData=EmListData_"||"_EmPCLCare_"^"_EmPCLLocID_"^"_EmPCLvID_"^"_EmPCLvDate_"^"_EmPCLvTime_"^"_EmPatGreFlag_"^"_EmWardID

	Q EmListData
}

/// Creator:    bianshuai
/// CreateDate: 2017-02-25
/// Descript:   Insert预检分诊就诊表
/// InPut:      EmPCLvID-分诊级别，EpisodeID-就诊ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMInterfaceCom).InsPatChkLvAdm("")
ClassMethod InsPatChkLvAdm(EmPCLvID As %String, EpisodeID As %String) As %String
{
	n (EmPCLvID, EpisodeID)
	Q:(EmPCLvID="")||(EpisodeID="") -1
	&SQL(Insert Into DHC_EmPatChkAdm(PCA_Chk_Dr,PCA_Adm_Dr) Values(:EmPCLvID,:EpisodeID))
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-11
/// Descript:   更新病人就诊表分诊信息
/// InPut:      EpisodeID-就诊ID， EmLvCode-分级代码
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMInterfaceCom).InsAdmPatChkLv("")
ClassMethod InsAdmPatChkLv(EpisodeID As %String, EmLvCode As %String, EmPatGreFlag As %String, EmWardID As %String) As %String
{
	n (EpisodeID, EmLvCode, EmPatGreFlag, EmWardID)
	Q:EpisodeID="" 0
	/// 根据分级代码取分级ID 
	s EmLvCode=EmLvCode_"级"
	s EmLvID=$o(^CT("ACU",0,"Code",$$ALPHAUP^SSUTIL4(EmLvCode),""))
	Q:EmLvID="" -1
	/// 绿色通道
	i EmPatGreFlag=1 s EmPatGreID=1
	E  s EmPatGreID=2

	&SQL(Update PA_Adm Set PAADM_AdmCateg_DR=:EmPatGreID, PAADM_Priority_DR=:EmLvID, PAADM_CurrentWard_DR=:EmWardID where PAADM_RowID=:EpisodeID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-11
/// Descript:   插入绿色通道信息
/// InPut:      EmPCLvID-分级ID, EpisodeID-就诊ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMInterfaceCom).InsEmPatGreen("")
ClassMethod InsEmPatGreen(EmPCLvID As %String, EpisodeID As %String) As %String
{
	n (EmPCLvID, EpisodeID)
	s Err=0,quitflag=0
	s EmPatGreID=""
	F  s EmPatGreID=$o(^DHCEMPGR(0,"PatCheckLev",EmPCLvID,EmPatGreID)) Q:(EmPatGreID="")||(quitflag=1)||(Err'=0)  D
	.s EmAdmID=$p(^DHCEMPGR(EmPatGreID),"^",6)   	  /// 就诊ID
	.Q:(EmAdmID'="")&(EpisodeID'=EmAdmID)
	.s Err=..UpdEmPatGreenDet(EmPatGreID, EpisodeID)  /// 更新绿色通道
	.Q:Err'=0
	.s quitflag=1
	Q:Err'=0 -1
	Q:quitflag=1 0
	/// 插入绿色通道
	s Err=##Class(web.DHCEMPatCheckLev).InsEmPatGreenDet(EmPCLvID, EpisodeID)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-11
/// Descript:   更新绿色通道信息
/// InPut:      EmPatGreID-绿色通道ID， EpisodeID-就诊ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMInterfaceCom).UpdEmPatGreenDet("")
ClassMethod UpdEmPatGreenDet(EmPatGreID As %String, EpisodeID As %String) As %String
{
	n (EmPatGreID, EpisodeID)
	&SQL(update DHC_EmPatGreenRec set PGR_Adm_Dr=:EpisodeID where PGR_RowID=:EmPatGreID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-11
/// Descript:   挂号成功后回调函数，修改病人就诊表分诊内容
/// InPut:      EmPCLvID-分级ID, EpisodeID-就诊ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMInterfaceCom).UpdAdmPatChkLv("172","3374")
ClassMethod UpdAdmPatChkLv(EmPCLvID As %String, EpisodeID As %String) As %String
{
	n (EmPCLvID, EpisodeID)
	Q:(EmPCLvID="")||(EpisodeID="") "-1"

	s EmLvCode=$p(^DHCEMPCL(EmPCLvID),"^",7)   	  	/// 分级
	s EmPatWardID=$p(^DHCEMPCL(EmPCLvID),"^",47)    /// 抢救病区
	i $d(^DHCEMPCA(0,"PatCheckLev",EmPCLvID)) D     /// 预检就诊ID
	.s EmPatWardID=""
	
	/// 修改分诊表
	s Err=##Class(web.DHCEMInterfaceCom).InsPatChkLvAdm(EmPCLvID, EpisodeID)
	Q:Err'=0 "-2"

	/// 取绿色通道标示
	s EmPatGreRes=##Class(web.DHCEMPatCheckLev).GetEmPatGreenCont(EmPCLvID,"")
	s EmPatGreFlag=$p(EmPatGreRes,"^",1)
	
	/// 修改绿色通道
	i EmPatGreFlag = 1 D
	.s Err=##Class(web.DHCEMInterfaceCom).InsEmPatGreen(EmPCLvID, EpisodeID)
	Q:Err'=0 "-3"
	
	/// 修改就诊表
	s Err=##Class(web.DHCEMInterfaceCom).InsAdmPatChkLv(EpisodeID, EmLvCode, EmPatGreFlag, EmPatWardID)
	Q:Err'=0 "-4"
	Q:EmPatWardID="" 0

	/// 插入等候区
	s Err=##Class(web.DHCEMPatCheckLev).InsWardAdm(EpisodeID,EmPatWardID)
	Q:Err'=0 "-5"
	
	s EmUserID=$p(^DHCEMPCL(EmPCLvID),"^",3)   	  	  /// 分诊人
	s EmLocID=$p(^DHCEMPCL(EmPCLvID),"^",10)   	  	  /// 分诊科室
	s EmPatLgParam="#"_EmLocID_"#"_EmUserID

	/// 病人状态表
	s:+EmPatWardID'=0 Err=##Class(web.DHCEMPatCheckLev).InsAdmVisit(EpisodeID,EmPatWardID,EmPatLgParam)
	Q:Err'=0 "-6"
	
	/// 置入院时间
	s:+EmPatWardID'=0 Err=##Class(web.DHCEMPatCheckLev).UpdInHospDate(EpisodeID)
	Q:Err'=0 "-7"
	
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-11
/// Descript:   挂号成功后回调函数，修改病人就诊表分诊内容
/// InPut:      EmPCLvID-分级ID, EpisodeID-就诊ID，RbResourceId-资源号别
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMInterfaceCom).UpdateEmChk("1123","1","RbResourceId")
ClassMethod UpdateEmChk(EmPCLvID As %String, EpisodeID As %String, RbResourceId As %String) As %String
{
	n (EmPCLvID, EpisodeID, RbResourceId)
	Q:(EmPCLvID="")||(EpisodeID="") "-1"
	Q:'..IsNedEmChkLev(EmPCLvID, EpisodeID) 0
	TS
	s Err=##Class(web.DHCEMInterfaceCom).UpdAdmPatChkLv(EmPCLvID, EpisodeID)
	i Err'=0 tro
	Q:Err'=0 "-1"
	TC
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2017-07-27
/// Descript:   提供预检分级的生命体征数据给电子病历
/// InPut:      EpisodeID-就诊ID
/// OutPut:     生命体征内容，空-失败
/// w ##Class(web.DHCEMInterfaceCom).GetPatChkLvSign("361")
ClassMethod GetPatChkLvSign(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q:EpisodeID="" ""
	s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""),-1)
	Q:EmPCLvID="" ""
	s EmPatChkSign=..GetEmPatChkSign(EmPCLvID)
	Q EmPatChkSign
}

/// Creator:    bianshuai
/// CreateDate: 2017-07-27
/// Descript:	生命体征
/// InPut:      EmPCLvID-分诊ID
/// OutPut:     生命体征内容，空-失败
ClassMethod GetEmPatChkSign(EmPCLvID) As %String
{
	n (EmPCLvID)
	s ListData=""
	s EmPcsID=""
	f  s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,EmPcsID)) Q:EmPcsID=""  D
	.s EmPcsTime=$p(^DHCEMPCS(EmPcsID),"^",2)   /// 时间
	.s:EmPcsTime'="" EmPcsTime=$zt(EmPcsTime,2)
	.s EmPcsTemp=$p(^DHCEMPCS(EmPcsID),"^",3)   /// 体温
	.s EmPcsHeart=$p(^DHCEMPCS(EmPcsID),"^",4)  /// 心率HR
	.s EmPcsPulse=$p(^DHCEMPCS(EmPcsID),"^",5)  /// 脉搏R
	.s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	.s EmPcsDBP=$p(^DHCEMPCS(EmPcsID),"^",7)    /// 舒张压
	.s EmPcsSoP2=$p(^DHCEMPCS(EmPcsID),"^",8)   /// 血氧饱合度SoP2
	.s EmPcsBrth=$p(^DHCEMPCS(EmPcsID),"^",9)   /// 呼吸频率
	.i ListData="" s ListData="时间："_EmPcsTime_"  T："_EmPcsTemp_"  HR："_EmPcsHeart_"(次/分) P："_EmPcsPulse_"(次/分) BP："_EmPcsSBP_"-"_EmPcsDBP_"(mmHg) SOP2："_EmPcsSoP2_"(%) R："_EmPcsBrth_"(次/分)"
	.E  s ListData=ListData_"; "_"时间："_EmPcsTime_"  T："_EmPcsTemp_"  HR："_EmPcsHeart_"(次/分) P："_EmPcsPulse_"(次/分) BP："_EmPcsSBP_"-"_EmPcsDBP_"(mmHg) SOP2："_EmPcsSoP2_"(%) R："_EmPcsBrth_"(次/分)"
	
	Q ListData
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-16
/// Descript:	新挂号是否与预检分诊进行关联
///             1、先挂号后分诊，挂号时不需关联分诊
///             2、先分诊后挂号，挂号时关联24小时内最后一次分诊记录
/// InPut:      EmPCLvID-分诊
/// OutPut:     1-关联，0-不关联
/// w ##Class(web.DHCEMInterfaceCom).IsNedEmChkLev("")
ClassMethod IsNedEmChkLev(EmPCLvID As %String, EpisodeID As %String) As %String
{
	n (EmPCLvID, EpisodeID)
	Q:(EmPCLvID="")||(EpisodeID="") 0
	Q:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID,EmPCLvID)) 0  /// 就诊和分级已关联
	s EmLocID=$p(^DHCEMPCL(EmPCLvID),"^",10)   	  	     /// 分诊科室
	Q:EmLocID="" 0
	s HospID=$p(^CTLOC(EmLocID),"^",22)				     /// 医院ID
	Q:HospID="" 0
	s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID) //hxy 2022-07-27 st
	Q:HospID'=AdmHospID 0 //ed
	s Params=HospID_"^"_EmLocID_"^^"
	s PatType=##Class(web.DHCEMPatCheckLevQuery).GetEmSysConfig("PATTYPE",Params)
	Q:((PatType=2)||(PatType=4)) 1
	Q 0
}

/// Creator:    qiaoqingao
/// CreateDate: 2017-09-20
/// Descript:	通过就诊ID取出病人的分诊信息
/// InPut:      PAADM
/// OutPut:    		 推荐分级^护士分级^护士更改分级原因^分级区域^分诊科室^重返标识^成批就诊   1-7
/// 				^重返人数^病人来源^来诊方式^意识状态^筛查^用药情况^用药情况描述^辅助物    8-15
/// 				^辅助物描述^复合伤^ECG^中毒^疼痛^吸氧^请假^其它^既往史^生命体征时间^体温  16-26
/// 					^心率HR^脉搏R^血压(BP)收缩压^舒张压^血氧饱合度SoP2^呼吸频率^疼痛分级      27-33
/// 				^疼痛范围^疼痛时间^号别^疼痛部位^症状^特殊人群^转向科室^创伤分级^格拉斯哥 34-42
/// 					^六大病种   43
/// w ##Class(web.DHCEMInterfaceCom).GetPatCheckInfo("2530")
ClassMethod GetPatCheckInfo(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:+EpisodeID=0 "就诊ID为空！"
	s EmPCLvID=""
	s:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID))>=10 EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	q:+EmPCLvID=0 "病人无分诊信息"
	s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	s:EmRecLevel'="" EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级")
	s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",1:"")
	s EmUpdLevRe=$p(^DHCEMPCL(EmPCLvID),"^",8)  /// 护士更改分级原因
	s:EmUpdLevRe'="" EmUpdLevRe=$p(^DHCEMULR(EmUpdLevRe),"^",2)
	s Area=$p(^DHCEMPCL(EmPCLvID),"^",9)  		/// 去向分区
	s Area=$s(Area=1:"红区",Area=2:"橙区",Area=3:"黄区",Area=4:"绿区")
	s EmLocID=$p(^DHCEMPCL(EmPCLvID),"^",10) 	/// 分诊科室
	s:EmLocID'="" EmLocID=$p(^CTLOC(EmLocID),"^",2)
	s EmAgainFlag=$p(^DHCEMPCL(EmPCLvID),"^",11) 	/// 重返标识
	s EmBatchFlag=$p(^DHCEMPCL(EmPCLvID),"^",12) 	/// 成批就诊
	s EmBatchNum=$p(^DHCEMPCL(EmPCLvID),"^",13) 	/// 成批就诊人数
	s EmPatSource=$p(^DHCEMPCL(EmPCLvID),"^",15) 	/// 病人来源
	s:EmPatSource'="" EmPatSource=$p(^DHCEMPSO(EmPatSource),"^",2)
	s EmPatAdmWay=$p(^DHCEMPCL(EmPCLvID),"^",16) 	/// 来诊方式
	s:EmPatAdmWay'="" EmPatAdmWay=$p(^DHCEMPADW(EmPatAdmWay),"^",2)
	s EmAware=$p(^DHCEMPCL(EmPCLvID),"^",17) 	    /// 意识状态
	s:EmAware'="" EmAware=$p($g(^DHCEMPAW(EmAware)),"^",2)
	s EmScreenFlag=$p(^DHCEMPCL(EmPCLvID),"^",18) 	/// 筛查
	s:EmScreenFlag'="" EmScreenFlag=$SELECT(EmScreenFlag=1:"发热",EmScreenFlag=2:"肠道",1:"")
	s EmHisDrug=$p(^DHCEMPCL(EmPCLvID),"^",19) 	    /// 用药情况
	s EmHisDrugDesc=$p(^DHCEMPCL(EmPCLvID),"^",20) 	/// 用药情况描述
	s EmMaterial=$p(^DHCEMPCL(EmPCLvID),"^",21) 	/// 辅助物
	s EmMaterialDesc=$p(^DHCEMPCL(EmPCLvID),"^",22) /// 辅助物描述
	s EmCombFlag=$p(^DHCEMPCL(EmPCLvID),"^",26) 	/// 复合伤
	s EmECGFlag=$p(^DHCEMPCL(EmPCLvID),"^",27) 	    /// ECG
	s EmPoisonFlag=$p(^DHCEMPCL(EmPCLvID),"^",28)   /// 中毒
	s EmPainFlag=$p(^DHCEMPCL(EmPCLvID),"^",29) 	/// 疼痛
	s EmPainLev=$p(^DHCEMPCL(EmPCLvID),"^",30) 	    /// 疼痛分级
	s EmPainRange=$p(^DHCEMPCL(EmPCLvID),"^",31) 	/// 疼痛范围
	s EmPainRangeDesc=$s(EmPainRange="1":"中枢",EmPainRange="2":"外周",1:"")
	s EmPainDate=$p(^DHCEMPCL(EmPCLvID),"^",32) 	/// 疼痛日期
	s:EmPainDate'="" EmPainDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmPainDate)  //hxy
	s EmPainTime=$p(^DHCEMPCL(EmPCLvID),"^",33) 	/// 疼痛时间
	s:EmPainTime'="" EmPainTime=$zt(EmPainTime,2)
	s:EmPainDate'="" EmPainTime=EmPainDate_" "_EmPainTime
	s EmOxygenFlag=$p(^DHCEMPCL(EmPCLvID),"^",34)   /// 吸氧
	s EmPatAskFlag=$p(^DHCEMPCL(EmPCLvID),"^",35) 	/// 请假
	s EmOtherDesc=$p(^DHCEMPCL(EmPCLvID),"^",36) 	/// 其它
	s EmSymDescStr=$p(^DHCEMPCL(EmPCLvID),"^",25) 	    /// 症状
	s EmSymDesc=""
	i EmSymDescStr'="" d
	.s Len=""
	.s Len = $l(EmSymDescStr,"#")
	.for i=1:1:Len d
	..s:EmSymDesc'="" EmSymDesc=EmSymDesc_"; "_$p($p(EmSymDescStr,"#",i),"!",2)
	..s:EmSymDesc="" EmSymDesc=$p($p(EmSymDescStr,"#",i),"!",2)
	s EmPatChkType=$p(^DHCEMPCL(EmPCLvID),"^",40) 	/// 特殊人群 2016-09-05 congyue
	s EmToLocID=$p(^DHCEMPCL(EmPCLvID),"^",41) 	/// 转向科室 2016-09-09 congyue
	s:EmToLocID'="" EmToLocID=$p(^CTLOC(EmToLocID),"^",1)
	s EmPatChkHisStr=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkLvHis(EmPCLvID)		/// 既往史
	s EmPatChkHis=""
	i EmPatChkHisStr'="" d
	.s Len=""
	.s Len = $l(EmPatChkHisStr,"#")
	.for i=1:1:Len d
	..s:EmPatChkHis'="" EmPatChkHis=EmPatChkHis_"; "_$p(^DHCEMPHI($p(EmPatChkHisStr,"#",i)),"^",2)
	..s:EmPatChkHis="" EmPatChkHis=$p(^DHCEMPHI($p(EmPatChkHisStr,"#",i)),"^",2)
	;s EmPatChkSign=..GetEmPatChkSign(EmPCLvID)      /// 生命体征
	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,""),-1)
	s EmPcsTime=$p(^DHCEMPCS(EmPcsID),"^",2)   /// 时间
	s:EmPcsTime'="" EmPcsTime=$zt(EmPcsTime,2)
	s EmPcsTemp=$p(^DHCEMPCS(EmPcsID),"^",3)   /// 体温
	s EmPcsHeart=$p(^DHCEMPCS(EmPcsID),"^",4)  /// 心率HR
	s EmPcsPulse=$p(^DHCEMPCS(EmPcsID),"^",5)  /// 脉搏R
	s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	s EmPcsDBP=$p(^DHCEMPCS(EmPcsID),"^",7)    /// 舒张压
	s EmPcsSoP2=$p(^DHCEMPCS(EmPcsID),"^",8)   /// 血氧饱合度SoP2
	s EmPcsBrth=$p(^DHCEMPCS(EmPcsID),"^",9)   /// 呼吸频率
	s EmPatChkCare=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkCare(EmPCLvID)      /// 预检号别表
	s:EmPatChkCare'="" EmPatChkCare=$p(^CTPCP($p(EmPatChkCare,"@",1),1),"^",2)
	S AisDataStr = ##class(web.DHCEMPatCheckLevQuery).GetAisData(EmPCLvID)       	/// 创伤分级
	S GCSDataStr = ##class(web.DHCEMPatCheckLevQuery).GetGCSData(EmPCLvID)    		/// 格拉斯哥
	s SixSick = ##class(web.DHCEMPatCheckLevQuery).GetSixSickDesc(EmPCLvID)				/// 六大病种
	
	s ListData=EmRecLevel_"^"_NurseLevel_"^"_EmUpdLevRe_"^"_Area_"^"_EmLocID_"^"_EmAgainFlag_"^"_EmBatchFlag_"^"_EmBatchNum_"^"_EmPatSource_"^"_EmPatAdmWay_"^"_EmAware_"^"_EmScreenFlag
	s ListData=ListData_"^"_EmHisDrug_"^"_EmHisDrugDesc_"^"_EmMaterial_"^"_EmMaterialDesc_"^"_EmCombFlag_"^"_EmECGFlag_"^"_EmPoisonFlag_"^"_EmPainFlag_"^"_EmOxygenFlag_"^"_EmPatAskFlag
	s ListData=ListData_"^"_EmOtherDesc_"^"_EmPatChkHis_"^"_EmPcsTime_"^"_EmPcsTemp_"^"_EmPcsHeart_"^"_EmPcsPulse_"^"_EmPcsSBP_"^"_EmPcsDBP_"^"_EmPcsSoP2_"^"_EmPcsBrth_"^"_EmPainLev
	s ListData=ListData_"^"_EmPainRange_"^"_EmPainTime_"^"_EmPatChkCare_"^"_EmPainRangeDesc_"^"_EmSymDesc_"^"_EmPatChkType_"^"_EmToLocID_"^"_AisDataStr_"^"_GCSDataStr_"^"_SixSick
	b ;data
	Q ListData
}

/// Creator:    liangqiang
/// CreateDate: 2018-03-21
/// Descript:	通过EpisodeID判断该病人是否需要显示留观病历菜单(给基础平台组控制急诊病历菜单)
/// InPut:      (PAADM,0流水病历,1留观病历,2抢救病历)
/// OutPut:    	Y/N (Y:需要显示留观菜单，N:不需要显示)
/// w ##class(web.DHCEMInterfaceCom).GetPatStayStatusForMenu(668,1)
ClassMethod GetPatStayStatusForMenu(EpisodeID As %String, MenuFlag) As %String
{
	n (EpisodeID,MenuFlag)
	s ret=##class(web.DHCEMPatChange).GetStayStatus(EpisodeID)
	i (MenuFlag=0) q "Y"
	i (MenuFlag=1)&(ret'=-1) q "Y"
	i (MenuFlag=2)&(ret'=-1) q "Y"
	q "N"
}

/// Creator:    zhouxin
/// CreateDate: 2018-07-13
/// Descript:	是否走门急诊担保申请流程(给计费组)
/// InPut:      (HospId,医院id)
/// OutPut:    	Y/N (Y:需要走门急诊担保申请，N:不需要走门急诊担保申请)
/// w ##class(web.DHCEMInterfaceCom).GetGuarantee(2)
ClassMethod GetGuarantee(HospId As %String) As %String
{
	n (HospId)
	s ret=+##class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENSWITCH",HospId)
	q:ret>0 "Y"
	q "N"
}

/// /// Creator：      zhouxin
/// /// CreatDate：    2018-07-11
/// /// Description:： 判断该就诊记录是否是绿色通道
/// /// Table：        DHC_EmPatGreenRec 
/// /// Others：       w ##class(web.DHCEMInterfaceCom).checkGreenRec("124")
/// /// Return:        0:非绿色通道 ，1:绿色通道 
/// w ##class(web.DHCEMInterfaceCom).CheckGreenRec(2)
ClassMethod CheckGreenRec(adm As %String) As %String
{
	n (adm)
	q ##class(web.DHCEMPatGreenRec).checkGreenRec(adm)
}

/// Creator:	   bianshuai
/// CreateDate:    2018-08-27
/// Descript:	   急诊病人留观时间
/// w ##Class(web.DHCEMInterfaceCom).GetPatObsTime("320")
ClassMethod GetPatObsTime(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	Q:EpisodeID="" ""
	Q ##Class(web.DHCEMInComUseMethod).GetObserTime(EpisodeID)
}

/// Creator:	   qqa
/// CreateDate:    2018-12-11
/// Descript:	   留观病人是否离院
/// Return: 1(已经离院)，2(未离院),-1(就诊无留观)
/// w ##Class(web.DHCEMInterfaceCom).GetObsPatYetDisHosp("1628")
ClassMethod GetObsPatYetDisHosp(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s Ret = ##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	q:(Ret'=1)&&(Ret'=2) -1   //无留观
	s PaAdmStatus = $p(^PAADM(EpisodeID),"^",20)
	s Ret=2  //未离院
	s ADMVisitStatusDr= $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	s PACVisitStatusDr=$p(^DHCADMVisitStatus(ADMVisitStatusDr),"^",2)
	s CuStatusCode = $p(^DHCPACVisitStatus(PACVisitStatusDr),"^",1)
	s:(CuStatusCode="Discharge")&&(PaAdmStatus="D") Ret=1  //已经离院
	s:('$d(^PAWARDA(0,"WADM",EpisodeID)))&&('$d(^PAWARDA(0,"ADM",EpisodeID)))&&(PaAdmStatus="D") Ret=1   ;//留观床位以及等候区无病人并且就诊状态为离院
	q Ret
}

/// Creator:	   qqa
/// CreateDate:    2020-04-09
/// Descript:	   最新的预交金评估
/// Input:	就诊ID
/// Return: 评估日期^时间^评估金额
/// w ##Class(web.DHCEMInterfaceCom).GetAdvPayassInfo("1027")
ClassMethod GetAdvPayassInfo(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s RowID=$o(^DHCEMADVPA(0,"AdmNo",EpisodeID,""),-1)
	q:+RowID=0 ""
	s PayAssDate=$p(^DHCEMADVPA(RowID),"^",8)     //评估日期
	i PayAssDate'="" s PayAssDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PayAssDate)
	s PayAssTime=$p(^DHCEMADVPA(RowID),"^",9)     //评估时间	
	i PayAssTime'="" S PayAssTime=$zt(PayAssTime,1)	
	s AdvPayAmt=$p(^DHCEMADVPA(RowID),"^",5)
	s Ret=PayAssDate_"^"_PayAssTime_"^"_AdvPayAmt
	q Ret
}

/// Creator:	   qqa
/// CreateDate:    2020-05-12
/// Descript:	   转床、安排床位、转科
/// Input:		   就诊ID,操作用户ID,病区ID,床位ID
/// Return: 	   0:成功，其他：失败信息
/// w ##Class(web.DHCEMInterfaceCom).GetAdvPayassInfo("1027")
ClassMethod MoveAdm(EpisodeID = "", UserID = "", WardID = "", BedID = "")
{
	n (EpisodeID, UserID, WardID, BedID)
	s Ret =##class(web.DHCEMObsRoomSeat).MoveAdm(EpisodeID , UserID, WardID , BedID)
	q Ret
}

/// Creator:	   qqa
/// CreateDate:    2020-05-12
/// Descript:	   离院
/// Input:		   就诊ID,操作用户ID,离院医院
/// Return: 	   0:成功，其他：失败信息
/// w ##Class(web.DHCEMInterfaceCom).DischargeAdm("160","11843","")
ClassMethod DischargeAdm(EpisodeID = "", UserID = "", VsNote = "")
{
	n (EpisodeID, UserID, VsNote)
	s CurDateStr=##class(web.DHCEMCommonUtil).DateLogicalToHtml(+$H)
	s CurTimeStr=$zt($p($h,",",2))
	s Ret = ##class(web.DHCEMPatChange).SetPatChargeStatusNew(EpisodeID,CurDateStr,CurTimeStr,UserID,"",VsNote)
	q Ret
}

/// Creator:	   qqa
/// CreateDate:    2020-06-16
/// Descript:	   通过单子描述+医院获取单子的code
/// Input:		   单子描述，医院ID
/// Return: 	   单子Code
/// w ##Class(web.DHCEMInterfaceCom).GetFormExecCode("输液单","2")
ClassMethod GetFormExecCode(Desc = "", HospID = "")
{
	n (Desc, HospID)
	
	s:HospID'="" HospID = ##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecFormSet",HospID)
	s RetCode=""
	s FSRowID=0
	f  s FSRowID=$o(^DHCEMEFS(FSRowID)) q:(FSRowID="")||(RetCode'="")  d
	.s FSCode=$p(^DHCEMEFS(FSRowID),"^",1)
	.s FSDesc=$p(^DHCEMEFS(FSRowID),"^",2)
	.s FSHospID=$p(^DHCEMEFS(FSRowID),"^",3)
	.q:(HospID'="")&&(HospID'=FSHospID)
	.q:FSDesc'[Desc
	.s RetCode=FSCode
	q RetCode
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCEM("InterfaceCom"))
}

/// Description: 取预检分级病人分区
/// Creator:     yuliping
/// CreateDate:  2020-11-04
/// Input:  	 EpisodeID
///  W ##Class(web.DHCEMInterfaceCom).GetEmPatCheckArea("1")
ClassMethod GetEmPatCheckArea(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s PatientID="" 
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	Q:PatientID="" ""
	s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)          /// 登记ID
	Q:EmRegID="" ""
	s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1) /// 分诊ID
	Q:EmPCLvID="" ""
	s Area= ""
	s Area=$p(^DHCEMPCL(EmPCLvID),"^",9)  		/// 去向分区
	s Area=$s(Area=1:"红区",Area=2:"橙区",Area=3:"黄区",Area=4:"绿区",Area=5:"绿区",1:"")
	q Area
}

/// Descript: 是否是绿色通道
/// Creator:     yuliping
/// CreateDate:  2020-11-04
/// Input:  	 EpisodeID
/// W ##Class(web.DHCEMInterfaceCom).GetEmPatFlag(1)
ClassMethod GetEmPatFlag(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s PatientID="" 
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	Q:PatientID="" 0
	s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)          /// 登记ID
	Q:EmRegID="" 0
	s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1) /// 分诊ID
	Q:EmPCLvID="" 0
	Q:$d(^DHCEMPGR(0,"PatCheckLev",EmPCLvID)) 1 	/// 绿色通道
    Q 0
}

/// Descript: 是否转入院
/// Creator:     yuliping
/// CreateDate:  2020-11-04
/// Input:  	 EpisodeID
/// W ##Class(web.DHCEMInterfaceCom).getInhospitalFlag(165)
ClassMethod getInhospitalFlag(EpisodeID)
{
	
	n (EpisodeID)
	q:EpisodeID="" 0
	s avsId = "" , flag = 0
	f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId),-1) q:(avsId="")||(flag=1)  d
	.s pvsId=$P(^DHCADMVisitStatus(avsId),"^",2)
	.i $p(^DHCPACVisitStatus(pvsId),"^",1) = "Inhospital" s flag = 1
	
	q flag
}

/// Description: 急诊统计  已就诊 未就诊人数统计
/// Creator:     yuliping
/// CreateDate:  2020-11-04
/// Input:  	 LocID, DocId 
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMInterfaceCom","QueryEpisoded","71","12175")
Query QueryEpisoded(LocID As %String, UserID As %String) As %Query(ROWSPEC = "EmWait:%String,EmUnWait:%String,Totalduration:%String,Waitingtime:%String,VisitTime:%String") [ SqlProc ]
{
}

ClassMethod QueryEpisodedExecute(ByRef qHandle As %Binary, LocID As %String, UserID As %String) As %Status
{
	n (qHandle,LocID,UserID)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
    s EmData = ..getEpisodeData(LocID,UserID)
	d OutPutEpisode

    s qHandle = $lb(0,repid,0)
	Quit $$$OK
OutPutEpisode
 	s ^CacheTemp(repid,ind) = EmData
 	s ind = ind+1
	quit
}

ClassMethod QueryEpisodedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEpisodedExecute ]
{
 s repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryEpisodedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEpisodedExecute ]
{
 s AtEnd=$LIST(qHandle,1)
 s repid=$LIST(qHandle,2)
 s ind=$LIST(qHandle,3)
 s ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
 }
 Else {			
 		s Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Description: 急诊统计  已就诊 未就诊人数统计取数据
/// Creator:     yuliping
/// CreateDate:  2020-11-04
/// Input:  	 LocID, DocId 
/// Return: 	 报告表数据
/// Others:		 w ##class(web.DHCEMInterfaceCom).getEpisodeData("71","12175")
ClassMethod getEpisodeData(LocID, UserID)
{
		
	n (LocID,UserID)
	
	s EmWait = 0    	//未就诊人数
	s EmUnWait = 0 		// 已就诊人数 
	s Totalduration = 0 // 总时长
	s Waitingtime = 0   // 平均等待时长
	s VisitTime = 0   	// 平均就诊时长
	s PatListType = "Per"
	s StartDate = +$h
	s EndDate = +$h
	s DocId=$p($g(^SSU("SSUSR",UserID)),"^",14) 	 /// 医生ID 

	f Date=StartDate:1:EndDate d
	.s Time = ""
	.f  s Time=$o(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time)) q:Time=""  d
	..s EpisodeID=0
	..f  s EpisodeID=$o(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time,EpisodeID)) q:EpisodeID=""  q
	...s AdmDoctor=$p($g(^PAADM(EpisodeID)),"^",9)
	...s AdmSeenDate=$p($g(^PAADM(EpisodeID),1),"^",10)
	...s AdmSeenTime=$p($g(^PAADM(EpisodeID),1),"^",11)
	...q:$P(^PAADM(EpisodeID),"^",20)'="A"
	...s WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)
	...i WalkStatus'="" s WalkStatus=$p(WalkStatus,"^",2)  //到达
	...s PatQueState=""
	...s QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	...i QueRowId'="" d
	....s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	....s StatusName=QueObj.QueStateDr.PersName   //状态2
	....s QueDocId=QueObj.QueDocDrGetObjectId()
	....s QueMarkId=QueObj.QueMarkDrGetObjectId()
	....s Include=$o(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))
	....q:(QueDocId'=DocId)&(PatListType="Per")
	....s DoctorId=$P($g(^PAADM(EpisodeID)),"^",9)   ///主管医生
	....s UnitFlag=""   /// 医疗组
	....s:(PatListType="Grp") UnitFlag=##Class(EMRservice.DAL.GetPaAdmDetail).CheckCTLocMedUnit(DoctorId,DocId,LocID)
	....q:(PatListType="Grp")&(UnitFlag'=1)

	....i WalkStatus["到达" s PatQueState="A"
	....d QueObj.%Close()
	...q:(PatQueState="")
	...s EmUnWait = EmUnWait + 1           //已就诊人数
	...s Totalduration = Totalduration + 1 // 总时长
	...s Waitingtime = Waitingtime + 1     // 总等待时长
	...s VisitTime = VisitTime + 1    	   // 总就诊时长
	/// 统计未诊断的病人
	s NoArriveCount=0,QueStateDr=""
	For Date=StartDate:1:EndDate Do
	.s Time = ""
	.For  Set Time=$O(^PAADMi("CurrLoc",LocID,Date,Time)) Quit:(Time="")  Do
	..Set EpisodeID=""
	..For  Set EpisodeID=$O(^PAADMi("CurrLoc",LocID,Date,Time,EpisodeID)) Quit:(EpisodeID="")  Do
	...Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(EpisodeID,DocId)
	...Q:QueRowId=""  
	...if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	...s StateDesc=""
	...if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	...Q:StateDesc="报到"
	...Set QueDocId=$List(^User.DHCQueueD(QueRowId),5)
	...Set QueMarkId=$List(^User.DHCQueueD(QueRowId),8)
	...Set Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))
	...Quit:(Include="")&(PatListType="Per")  ///
	...s DoctorId=$P($g(^PAADM(EpisodeID)),"^",9)   ///主管医生
	...s UnitFlag=""   /// 医疗组
	...s:(PatListType="Grp") UnitFlag=##Class(EMRservice.DAL.GetPaAdmDetail).CheckCTLocMedUnit(DoctorId,DocId,LocID)
	...;s:(QueDocId="")&(Include'="") UnitFlag=1   ///无小组一个患者都不显示
	...q:(PatListType="Grp")&(UnitFlag'=1)
	...Q:$P(^PAADM(EpisodeID),"^",20)'="A"
	...Set PatPMI=$P($g(^PAADM(EpisodeID)),"^",1)
	...Set PatAdmWard=$P($g(^PAADM(EpisodeID)),"^",70)
	...Quit:PatPMI=""
	...Quit:(PatAdmWard'="")
	...Set CurStat=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)
	...Set WalkStatus=CurStat
	...If CurStat'="" Set CurStat=$P(CurStat,"^",1)
	...;到达病人不显示
	...If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	...Quit:WalkStatus="到达"
	...s EmWait = EmWait + 1
	
	s total = EmWait+EmUnWait 
	i total'=0 d
	.s Totalduration =$justify((Totalduration/total),3,0)    	//平均总时长
	.s Waitingtime = $justify((Waitingtime/total),3,0)			// 平均总等待时长
	.s VisitTime = $justify((VisitTime/total),3,0)				// 平均总就诊时长
	
	q $lb(EmWait,EmUnWait,Totalduration,Waitingtime,VisitTime)
}

/// Description: 急诊统计  留观抢救病区统计
/// Creator:     yuliping
/// CreateDate:  2020-11-04
/// Input:  	 LocID, UserID,wardId
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMInterfaceCom","QueryStayAdm","71","")
Query QueryStayAdm(LocID As %String, wardId As %String) As %Query(ROWSPEC = "ward:%String,Episode:%String") [ SqlProc ]
{
}

ClassMethod QueryStayAdmExecute(ByRef qHandle As %Binary, LocID As %String, wardId As %String) As %Status
{
	n (qHandle,LocID,wardId)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	k StayAdmArr
	s wardDesc = ""
	i wardId'="" s wardDesc = $p(^PAWARD(wardId),"^",2)
    d ..getStayAdmData(LocID,.StayAdmArr)
    s ward = ""
    f  s ward = $o(StayAdmArr(ward)) q:ward=""  d
    .q:(wardDesc'="")&&(wardDesc'=ward)
    .s Episode = ""
    .f  s Episode = $o(StayAdmArr(ward,Episode)) q:Episode=""  d
	..d OutPutStayAdm

    s qHandle = $lb(0,repid,0)
    k StayAdmArr
	Quit $$$OK
OutPutStayAdm
 	s ^CacheTemp(repid,ind) = $lb(ward,Episode)
 	s ind = ind+1
	quit
}

ClassMethod QueryStayAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStayAdmExecute ]
{
 s repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryStayAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStayAdmExecute ]
{
 s AtEnd=$LIST(qHandle,1)
 s repid=$LIST(qHandle,2)
 s ind=$LIST(qHandle,3)
 s ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
 }
 Else {			
 		s Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod getStayAdmData(LocID, StayAdmArr)
{
	
	n (LocID,StayAdmArr)
	;s DocId=$p($g(^SSU("SSUSR",UserID)),"^",14) 	 /// 医生ID 

	/// 留观/抢救
	Set LinkID="" For  Set LinkID=$O(^CTLOC(LocID,"LINK",LinkID)) Quit:LinkID=""  Do
	.Set LnkLocID=$P($G(^CTLOC(LocID,"LINK",LinkID)),"^",1)
	.Set LnkLocType=$P($G(^CTLOC(LnkLocID)),"^",13)
	.Quit:LnkLocType'="EM"
	.Set EmWardID=$O(^PAWARD(0,"WARD_LocationDR",LnkLocID,""))
	.Quit:EmWardID=""
	.Set RoomDr=0
	.For  Set RoomDr=$O(^PAADMi("CurrWard",EmWardID,RoomDr)) Quit:RoomDr=""  Do
	..Set EpisodeID=""
	..For  Set EpisodeID=$O(^PAADMi("CurrWard",EmWardID,RoomDr,EpisodeID)) Quit:EpisodeID=""  Do
	...Q:$P(^PAADM(EpisodeID),"^",20)'="A"
	...;Set QueRowId=##Class(web.DHCDocOutPatientList).GetQueRowidByMore(EpisodeID,DocId)
	...;Set QueStateDr=$List($g(^User.DHCQueueD(+QueRowId)),14)
	...;Set StateDesc=$List($g(^User.DHCPerStateD(QueStateDr)),4)
	...;Quit:StateDesc="报到"
	...Set PatLoc=$P($g(^PAADM(EpisodeID)),"^",4)  /// 留观病人是否是本科室判断
	...Quit:PatLoc'=LocID
	...s PAAdmWard=""
	...s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)                                    /// 
	...i WardDr'="" s PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	...s:PAAdmWard["-" PAAdmWard=$p(PAAdmWard,"-",2)
	...s:PAAdmWard'="" StayAdmArr(PAAdmWard,EpisodeID) = 0

	.Set CH=0
	.For  Set CH=$O(^PAWARDA(EmWardID,"WADM",CH)) Quit:CH=""  Do
	..Set EpisodeID=$P(^PAWARDA(EmWardID,"WADM",CH),"^",1)
	..Q:$P(^PAADM(EpisodeID),"^",20)'="A"
	..//Set AdmDate=$p(^PAADM(EpisodeID),"^",6)
	..//Quit:(AdmDate<StartDate)||(AdmDate>EndDate)
	..;Set QueRowId=##Class(web.DHCDocOutPatientList).GetQueRowidByMore(EpisodeID,DocId)
	..;Set QueStateDr=$List($g(^User.DHCQueueD(+QueRowId)),14)
	..;Set StateDesc=$List($g(^User.DHCPerStateD(QueStateDr)),4)
	..;Quit:StateDesc="报到"
	..Set PatLoc=$P($g(^PAADM(EpisodeID)),"^",4)  /// 留观病人是否是本科室判断
	..Quit:PatLoc'=LocID
	..s PAAdmWard=""
	..s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)                                    /// 
	..i WardDr'="" s PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	..s:PAAdmWard["-" PAAdmWard=$p(PAAdmWard,"-",2)
	..set:PAAdmWard'="" StayAdmArr(PAAdmWard,EpisodeID) = 0

	
	q ""
}

/// Description: 取预检分级病人分级描述
/// Creator:     yuliping
/// CreateDate:  2020-11-04
/// Input:  	 EpisodeID
///  W ##Class(web.DHCEMInterfaceCom).GetEmPatCheckLevel("1")
ClassMethod GetEmPatCheckLevel(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:EpisodeID="" ""
	s PAAdmPriority="",PriorityCode=""                      /// 优先级、优先级代码、背景色
	s Priority=$P($g(^PAADM(EpisodeID)),"^",33)
	i Priority'="" s PAAdmPriority=$p($g(^CT("ACU",Priority)),"^",1)
	s Area=""
	i PAAdmPriority'="" s Area=$case(PAAdmPriority,"1级":"Ⅰ级","2级":"Ⅱ级","3级":"Ⅲ级","4级":"Ⅳa级","5级":"Ⅳb级",1:"")
	q Area
}

/// Creator:	   yuliping 
/// CreateDate:    2020-11-12
/// Descript:	   医生院前出诊次数
/// w ##Class(web.DHCEMInterfaceCom).getPreHos("2020-10-10","2020-12-10","ys01")
ClassMethod getPreHos(StartDate, EndDate, doctor)
{
	n (StartDate,EndDate,doctor)
	
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-30
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	q:doctor="" 0
	s count = 0 
	F dd=StartDate:1:EndDate D
	.s VisID=""
	.F  s VisID=$o(^DHCEMPHV(0,"CreateDate",dd,VisID)) Q:VisID=""  D
	..s MaID=""
    ..I $d(^DHCEMDAM(0,"HOSVIS",VisID)) D
    ...s MaID=$o(^DHCEMDAM(0,"HOSVIS",VisID,""))
	..i MaID'="" D
	...s SCDocdr=$o(^DHCEMACCPi(0,"ParType",MaID,"医生",""))
	...i SCDocdr'="" d
	....s SSDocUser=$p($g(^DHCEMACCP(SCDocdr)),"^",3)
	....s UserDocID="", SCDoc=""
	....s:SSDocUser'="" UserDocID=$o(^SSU("SSUSR",0,"CTPCP",SSDocUser,""))
	....s:UserDocID'="" SCDoc=$p(^SSU("SSUSR",UserDocID),"^",1)
	....i SCDoc = $$ALPHAUP^SSUTIL4(doctor) s count = count +1 
	
	
	q count
}

/// Descripts:用于复诊队列排序
/// w ##Class(web.DHCEMInterfaceCom).UpdEmVisitPosition("2020-10-10","2020-12-10","ys01")
ClassMethod UpdEmVisitPosition(Adm, UserId)
{
	n (Adm,UserId)
	s WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(Adm)
	q:WalkStatus["到达" 0
	s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(Adm)
	s LimitNum=+##Class(web.DHCEMComPar).GetAppPropValue("DHCEMDOC","VISITLISTORDER",AdmHospID,"","","")
	s:'$d(^TMP("ThisLimitNum",+UserId)) ^TMP("ThisLimitNum",+UserId)=LimitNum+1
	q:+LimitNum=0 0
	s:'$d(^TMP("ThisLimitNum",+UserId)) ^TMP("ThisLimitNum",+UserId)=LimitNum+1
	s:WalkStatus["复诊" ^TMP("ThisLimitNum",+UserId)=LimitNum+1
	s:WalkStatus'["复诊" ^TMP("ThisLimitNum",+UserId)=^TMP("ThisLimitNum",+UserId)-1
	s:^TMP("ThisLimitNum",+UserId)<1 ^TMP("ThisLimitNum",+UserId)=1
	q 0
}

/// Description: 获取患者有无检验医嘱
/// Creator:     qqa
/// CreateDate:  2021-06-08
/// Input:  	 PatientID,StDate(M),EndDate(M),QueryTypeCode(执行单Code)
/// 				 AdmType(O/E/OE),LgHospId(登录医院ID)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMInterfaceCom","QueryPatLisOrd","90",65803,65903,"JYDO","OE","2")
Query QueryPatLisOrd(PatientID, StDate, EndDate, QueryTypeCode, OrdType, LgHospId) As %Query(ROWSPEC = "OrdItmId,LabNo,OrdBilled")
{
}

ClassMethod QueryPatLisOrdExecute(ByRef qHandle As %Binary, PatientID, StDate, EndDate, QueryTypeCode, OrdType, LgHospId) As %Status
{
	n (qHandle,PatientID, StDate,EndDate,QueryTypeCode,OrdType,LgHospId)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:+PatientID=0 $$$OK
	
	f CurDate=StDate:1:EndDate d
	.;这里不走就诊的索引，改为走执行记录要求执行时间
	.s Time=""
	.f  s Time=$o(^OEORDi(0,"DateExec",CurDate,Time)) q:Time=""  d
	..s Ord=0
	..f  s Ord=$o(^OEORDi(0,"DateExec",CurDate,Time,Ord)) q:Ord=""  d
	...s EpisodeID=+^OEORD(Ord)
	...s PatVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ...q:PatVisit'="A"
	...s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
    ...q:OrdType'[AdmType
	...q:+^PAADM(+EpisodeID)'=PatientID
	...s AdmHosp = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	...q:AdmHosp'=+LgHospId
	...s Itm=0
	...f  s Itm=$o(^OEORDi(0,"DateExec",CurDate,Time,Ord,Itm)) q:Itm=""  d
	....s IsHasOrd=""
	....s Sub=0
	....f  s Sub=$o(^OEORDi(0,"DateExec",CurDate,Time,Ord,Itm,Sub))  q:(Sub="")||(IsHasOrd=1)  d
	.....s IsThisFormOrd=##class(web.DHCEMPat).IsInThisForm(LgHospId,QueryTypeCode,Ord,Itm,Sub,"false","true")
	.....s:+IsThisFormOrd IsHasOrd=1
	....d:IsHasOrd OutPutLisOrdData

    s qHandle = $lb(0,repid,0)
	Quit $$$OK
OutPutLisOrdData
	s OrdItmId=Ord_"||"_Itm
	s LabNoInfo=##class(web.DHCEMOrdInfoVO).getLisOrdLabNo(Ord,Itm)
 	s LabNo=$p(LabNoInfo,"^",1)
 	s OrdBilled=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
 	s isPayManey=##class(web.DHCEMNurExe).YetPayManey(OrdItmId) //hxy 2022-09-30
    s:isPayManey OrdBilled="P"
 	s ^CacheTemp(repid,ind) = $lb(OrdItmId,LabNo,OrdBilled)
 	s ind = ind+1
	quit
}

ClassMethod QueryPatLisOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatLisOrdExecute ]
{
 s repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPatLisOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatLisOrdExecute ]
{
 s AtEnd=$LIST(qHandle,1)
 s repid=$LIST(qHandle,2)
 s ind=$LIST(qHandle,3)
 s ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
 }
 Else {			
 		s Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Descript:医生站接口：获取患者正在留观病区
/// Input:EpisodeID(就诊ID)
/// Return:""(未正在留抢),其他(留抢病区描述)
/// w ##class(web.DHCEMInterfaceCom).IsStayingObsWard(1)
ClassMethod IsStayingObsWard(EpisodeID)
{
	q:EpisodeID="" ""
	s ObsRet=""
	s ObsWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	s:ObsWardId'="" ObsRet=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",$p($g(^PAWARD(+ObsWardId)),"^",2))
	q:ObsRet'="" ObsRet
	s ObsWardId=$o(^PAWARDA(0,"WADM",EpisodeID,""))
	s:ObsWardId'="" ObsRet=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",$p($g(^PAWARD(+ObsWardId)),"^",2))
	q:ObsRet'="" ObsRet
	q ""
}

/// Creator：      hxy
/// CreatDate：    2022-06-20
/// Description:： 判断该就诊记录是否是绿色通道
/// Inputs:        提供是否绿色通道接口： 入参：就诊号，日期+时间 （时间不传按当前时间计算;若传入就诊时间，则返回本次就诊是否开通过绿色通道）
/// Table：        DHC_EmPatGreenRec 
/// Return:        是否绿色通道^先诊疗后付费(0:非绿色通道 ，1:绿色通道; Y:是 ，其他:否)
/// Others：       w ##class(web.DHCEMInterfaceCom).CheckGreenRecByTime(17863)
/// Others：       w ##class(web.DHCEMInterfaceCom).CheckGreenRecByTime(17859)
/// Others：       w ##class(web.DHCEMInterfaceCom).CheckGreenRecByTime(17859,"2022-06-20","14:08:40") //1
/// Others：       w ##class(web.DHCEMInterfaceCom).CheckGreenRecByTime(17859,"2022-06-20","14:08:00") //1
/// Others：       w ##class(web.DHCEMInterfaceCom).CheckGreenRecByTime(17859,"2022-06-20","14:08:41") //0
/// Others：       w ##class(web.DHCEMInterfaceCom).CheckGreenRecByTime(17863,"2022-06-21","11:21:13")
ClassMethod CheckGreenRecByTime(Adm As %String, Date = "", Time = "") As %String
{
	n (Adm,Date,Time)
	s ret=0,GreenRec=0
	q:+Adm=0 ret
	q:'$d(^PAADM(Adm)) ret
	s IsPay=..GetAdmCategory(Adm)
	s AdmType=$p($g(^PAADM(+Adm)),"^",2)
	s Date=##class(web.DHCEMCommonUtil).DateHtmlToLogical(Date)
	s:Time[":" Time=$zth(Time)
	s:Date="" Date=+$h
	s:Time="" Time=$p($h,",",2)
	i AdmType="E" d
	.s GreenRec=##class(web.DHCEMPatGreenRec).CheckGreenRecByTime(Adm,Date,Time)
	.s:GreenRec'=1 IsPay=$p($g(^PAC("ADMCAT",2)),"^",5) //绿色通道到时后，没有更新就诊表状态;有些医院非绿色通道患者也可能使用先诊疗后付费模式
	.s:GreenRec=1 IsPay=$p($g(^PAC("ADMCAT",1)),"^",5) //绿色通道手工取消后，就诊表就诊分类变更为非绿色通道，所以按绿色通道标记取是否先诊疗后付费
	i AdmType'="E" d
	.s GreenRec=$p($g(^PAADM(+Adm)),"^",5)
	.s:GreenRec'=1 GreenRec=0
	s:IsPay="" IsPay="N" 
	q GreenRec_"^"_IsPay
}

/// Creator：      hxy
/// CreatDate：    2022-06-21
/// Description:： 取是否先诊疗后付费
/// Inputs:        就诊号
/// Table：        PAC_AdmCategory 
/// Return:        Y:是 ，其他:否
/// Others：       w ##class(web.DHCEMInterfaceCom).GetAdmCategory(17863)
ClassMethod GetAdmCategory(Adm As %String) As %String
{
	n (Adm)
	s IsPay=""
	s CategoryDr=$p($g(^PAADM(+Adm)),"^",5)
	s IsPay=$p($g(^PAC("ADMCAT",+CategoryDr)),"^",5)
	q IsPay
}

/// Creator:    hxy
/// CreateDate: 2022-08-09
/// Descript:   提供接口：通过就诊号获取分诊时所填收缩压与舒张压，供医生站诊断录入界面获取
/// InPut:      EpisodeID-就诊ID
/// OutPut:     收缩压^舒张压
/// w ##Class(web.DHCEMInterfaceCom).GetPatChkBPForDoc("1730")
ClassMethod GetPatChkBPForDoc(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q:EpisodeID="" ""
	s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""),-1)
	Q:EmPCLvID="" ""
	s EmPcsSBP="",EmPcsDBP=""
	s EmPcsID=""
	f  s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,EmPcsID),-1) Q:(EmPcsID="")!(EmPcsSBP'="")!(EmPcsDBP'="")  D
	.s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	.s EmPcsDBP=$p(^DHCEMPCS(EmPcsID),"^",7)    /// 舒张压
	Q EmPcsSBP_"^"_EmPcsDBP
}

/// Creator:    hxy
/// CreateDate: 2022-11-28
/// Descript:   提供计费医保组一个接口：入参是就诊Id 返参：分诊级别^分组级别描述 ，然后计费医保组再根据分诊级别字典与医保医疗类别字典对照 取 对应的医疗类类别
/// OutPut:     分诊级别^分组级别描述
/// w ##Class(web.DHCEMInterfaceCom).GetEmPatLevel("5814")
ClassMethod GetEmPatLevel(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:+EpisodeID=0 ""
	s AcuCode="",AcuDesc=""
	s Priority=$p($g(^PAADM(+EpisodeID)),"^",33)
	q:+Priority=0 "^"
	s AcuCode=$p($g(^CT("ACU",+Priority)),"^",1)
	s AcuDesc=$p($g(^CT("ACU",+Priority)),"^",2)
	q AcuCode_"^"_AcuDesc
}

/// Description: 门急诊输液护士-提供护理病历获取座位图病人的接口（具体可联系护理组姚继宁姚工）
/// Creator:     hxy
/// CreateDate:  2022-12-09
/// Input:  	 科室ID
/// Return: 	 输出姓名，性别，座位号,PatentID,登记号
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMInterfaceCom","QrySeatPat","39")
Query QrySeatPat(LocId) As %Query(ROWSPEC = "PatName,PatSex,PatSeatNo,PatentID,PatNo")
{
}

ClassMethod QrySeatPatExecute(ByRef qHandle As %Binary, LocId) As %Status
{
	n (qHandle,LocId)
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:+LocId=0 $$$OK
	
	s HospId=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(LocId)
	
	s PatSeatId=0
	F  s PatSeatId=$o(^DHCEMPSE(0,"Loc",LocId,PatSeatId))  Q:PatSeatId=""  D
	.s seatItmSub=0 
	.F  s seatItmSub=$o(^DHCEMPSE(PatSeatId,"SE",seatItmSub))  Q:seatItmSub=""  D
	..Q:^DHCEMPSE(PatSeatId,"SE",seatItmSub)=""
	..s patSeatiDr = PatSeatId_"||"_seatItmSub
	..s PatSeatNo = $p(^DHCEMPSE(PatSeatId,"SE",seatItmSub),"^",2) 
	..s SeatType = $p(^DHCEMPSE(PatSeatId,"SE",seatItmSub),"^",3)
	..q:+SeatType=0 												
	..s PatRecDr= $p(^DHCEMPSE(PatSeatId,"SE",seatItmSub),"^",4)
	..s PatData=""
	..s:+PatRecDr'="0" PatData=##class(web.DHCEMPatientSeat).GetPatBySeatIdNew(patSeatiDr,+HospId)    //获取在床位上的病人的基本信息
	..q:PatData=""
	..s PatName=$p(PatData,"^",2)
	..s PatentID=$p(PatData,"^",4)
	..s PatNo=$p(PatData,"^",5)
	..s PatSexDr=$p(PatData,"^",8)
	..s PatSex=$p($g(^CT("SEX",+PatSexDr)),"^",2)
	..d SeatPatData

    s qHandle = $lb(0,repid,0)
	Quit $$$OK
SeatPatData
 	s ^CacheTemp(repid,ind) = $lb(PatName,PatSex,PatSeatNo,PatentID,PatNo)
 	s ind = ind+1
	quit
}

ClassMethod QrySeatPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySeatPatExecute ]
{
 s repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QrySeatPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySeatPatExecute ]
{
 s AtEnd=$LIST(qHandle,1)
 s repid=$LIST(qHandle,2)
 s ind=$LIST(qHandle,3)
 s ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
 }
 Else {			
 		s Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Desc:通过就诊判断患者是不是三无患者
/// Ret: 0(不是)/1(是)
/// w ##class(web.DHCEMInterfaceCom).IsThreeNotsPat(1)
ClassMethod IsThreeNotsPat(EpisodeID)
{
	s Ret=0
	s EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""),-1)
	q:+EmPCLvID=0 Ret
	s EmPatChkType=$p(^DHCEMPCL(+EmPCLvID),"^",40) 	/// 特殊人群
	q:+EmPatChkType=0 Ret
	
	s Type=$p(^DHCEMPT(+EmPatChkType),"^",2)
	s:Type["三无人员" Ret=1
	q Ret
}

/// Creator:	   qqa
/// CreateDate:    2021-04-21
/// Descript:	   是否正在留观
/// Return: 1:正在留观/其他:未正在留观
/// w ##Class(web.DHCEMInterfaceCom).IsObsIng("1628")
ClassMethod IsObsIng(EpisodeID As %String)
{
	n (EpisodeID)
	
	s Ret=""
	s:$d(^PAWARDA(0,"WADM",EpisodeID)) Ret=1
	s:$d(^PAWARDA(0,"RADM",EpisodeID)) Ret=1
	s:$d(^PAWARDA(0,"ADM",EpisodeID)) Ret=1
	q Ret
}

/// Creator:	   qqa
/// CreateDate:    2023-04-04
/// Descript:	   患者类型：急诊留观，住院，急诊留观的离院患者，预住院患者
/// Return: O(门诊),I(住院),IP(预住院),E(急诊流水),OB(留观),OBD(留观已离院),其他(非上述状态)
/// w ##Class(web.DHCEMInterfaceCom).PatientVisitStatus("429")
ClassMethod PatientVisitStatus(EpisodeID As %String)
{
	n (EpisodeID)
	
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s PaAdmStatus = $p($g(^PAADM(EpisodeID)),"^",20)
	
	s Ret=""
	
	i AdmType="O" {
		s Ret="O"
	}
	
	i AdmType="I" {
		s:PaAdmStatus="P" Ret="IP"
		s:PaAdmStatus'="P" Ret="I"
	}
	
	i AdmType="E" {
		s Ret="E"
		s IsObsing = ##Class(web.DHCEMInterfaceCom).IsObsIng(EpisodeID)
		i IsObsing '="" {
			s Ret="OB"
		}
		i IsObsing="" {
			s PatAdmWard=$P($g(^PAADM(EpisodeID)),"^",70)
			i (+PatAdmWard'=0)&&(PaAdmStatus="D") {
				s Ret="OBD"
			}
		}
	}
	q Ret
}

/// Description: 获取留抢室总床位和当前可用床位接口(院前急救对第三方接口)
/// Creator:     hxy
/// CreateDate:  2023-04-07
/// Input:  	 HIS医院描述或者医院CODE
/// Return: 	 留抢总床位^当前可用床位
/// Others:		 W ##class(web.DHCEMInterfaceCom).GetBedInfo("DHSZHYYZY")
ClassMethod GetBedInfo(Hosp)
{
	n (Hosp)
	q:Hosp="" "^"
	s totalBedNum=0,availBedNum=0
	s HospID=""
	s HospID=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(Hosp),""))
	s:HospID="" HospID=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hosp),""))
	q:HospID="" "^"
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .q:LocID=""
    .q:$p(^CTLOC(LocID),"^",13)'="EM"
	.q:$p(^CTLOC(LocID),"^",14)'="Y"
    .q:'$o(^PAWARD(WardID,"ROOM",0))
    .q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocID,HospID)'="Y"
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
 	.s HasBed=$o(^PAWARD(WardID,"BED",0))		///是否有床位
 	.q:'+HasBed
	.s HasRoom=$o(^PAWARD(WardID,"ROOM",0))		///是否有房间
 	.q:'+HasRoom
 	.s ret=..GetBedStr(WardID)
 	.s totalBedNum=totalBedNum+$p(ret,"^",1)
 	.s availBedNum=availBedNum+$p(ret,"^",2)
	
	q totalBedNum_"^"_availBedNum
}

/// Creator：   hxy
/// CreatDate： 2021-01-11
/// Description:获取该病区下总床位数、已使用数
/// Table：     PAC_Ward、PAC_Bed
/// Input：     病区ID
/// W ##class(web.DHCEMInterfaceCom).GetBedStr("34")
ClassMethod GetBedStr(WardID)
{
	n (WardID)
	s BedSub=0,Total=0,Used=0
	f  s BedSub = $o(^PAWARD(WardID,"BED",BedSub)) q:BedSub=""  d
	.s ActiveFlag=$p(^PAWARD(WardID,"BED",BedSub),"^",4)
	.q:(ActiveFlag'="Y")
	.s BedStDate = $p(^PAWARD(WardID,"BED",BedSub),"^",21)
	.s BedEndDate = $p(^PAWARD(WardID,"BED",BedSub),"^",22)
	.s ADMChildsub ="",PaAdm=""
	.s ADMChildsub = $o(^PAWARDA(WardID,"BED",BedSub,"ADM",0))
	.s:+ADMChildsub'=0 PaAdm=$p(^PAWARDA(WardID,"BED",BedSub,"ADM",ADMChildsub),"^",1)
	.q:(PaAdm="")&&(BedStDate'="")&&(BedStDate>+$h)
	.q:(PaAdm="")&&(BedEndDate'="")&&(BedEndDate<+$H)
	.q:($p($g(^PAWARD(WardID,"BED",BedSub)),"^",18)="") //没维护宽度
	.s Total=Total+1
	.q:PaAdm=""
	.s Used=Used+1
	q Total_"^"_Used
}

/// Creator:      bianshuai
/// CreateDate:   2020-08-18
/// Descript:     患者转归信息
/// InPut:        EpisodeID
/// OutPut:       院前病人ID^转归去向^转归时间^初步诊断^医院ID^医院名称^身份证号^患者姓名^性别
/// w ##Class(web.DHCEMInterfaceCom).GetPatOutComeInfo("1973")
ClassMethod GetPatOutComeInfo(EpisodeID As %String) As %String
{
	n (EpisodeID)
	
	Q:EpisodeID="" ""
	s Gender=""
	s HospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	s Hosp=$p(^CT("HOSP",HospID),"^",7) 
	s HospDesc=$p(^CT("HOSP",HospID),"^",2) 
	s PatientID=$p(^PAADM(EpisodeID),"^",1)  	    /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)     /// 患者姓名
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)  
	i SexId'="" s Gender=$p(^CT("SEX",SexId),"^",2) /// 性别
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)     /// 身份证号
	s PreHosID="" //..GetPatPreHosID(EpisodeID)          /// 病人院前标识ID

	s vsNotes="", vsDate="", vsTime=""
	s vsID=""
	F  s vsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,vsID),-1) Q:(vsID="")||(vsNotes'="")  D
    .s ID=$p(^DHCADMVisitStatus(vsID),"^",2)
    .Q:'$D(^DHCPACVisitStatus(ID))
    .s vStatus=$p(^DHCPACVisitStatus(ID),"^",1)    /// 状态代码
    .Q:vStatus="Discharge"   /// 离院
    .s vsNotes=$p(^DHCADMVisitStatus(vsID),"^",11) /// 备注
    .i vsNotes'="" s vsNotes="离院"_"("_vsNotes_")"
    .E  s vsNotes="离院"
    .s vsDate=$p(^DHCADMVisitStatus(vsID),"^",5)   /// 业务日期
    .s vsDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(vsDate)
    .s vsTime=$p(^DHCADMVisitStatus(vsID),"^",6)   /// 业务时间
    .s:vsTime'="" vsTime=$zt(vsTime,1)
    .s diagnose=##Class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	.
	s ret=PreHosID_"^"_vsNotes_"^"_vsDate_" "_vsTime_"^"_diagnose_"^"_Hosp_"^"_HospDesc_"^"_IdentNo_"^"_PatName_"^"_Gender
	Q ret
}

}
