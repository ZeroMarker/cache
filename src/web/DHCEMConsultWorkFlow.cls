Import sqluser

/// Creator: 		bianshuai
/// CreateDate: 	2019-12-25
/// Descript: 		会诊申请工作流业务类
Class web.DHCEMConsultWorkFlow Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	执行函数
/// Input:      CstID - 会诊ID
/// Output:
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).ExecFn("")
ClassMethod ExecFn(CsID As %String, FnID As %String, Pa As %String) As %String
{
	n (CsID, FnID, Pa)
	s Fu=$p(^DHCEMCONF(FnID),"^",3)   /// 表达式函数
	//s Fu=$p(Fu,"(",1)_"("_$p(Fu,"(",2)
	i (Pa'="")&(Fu["get") D
	.s x="s val=##Class(web.DHCEMConsultWorkFlow)."_Fu_"("""_CsID_""","""_Pa_""")"
	E  D
	.s x="s val=##Class(web.DHCEMConsultWorkFlow)."_Fu_"("""_CsID_""")"
    x x
	Q val
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	是否住院病人
/// Input:      CsID - 会诊ID
/// Output:     1 - 是，0 - 不是
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).isInHosPat()
ClassMethod isInHosPat(CsID As %String) As %String
{
	n (CsID)
	s EpisodeID=$p(^DHCEMCON(CsID),"^",1)   /// 就诊ID
	Q:$p(^PAADM(EpisodeID),"^",2)'="I" 0
	Q 1
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	是否门急诊病人
/// Input:      CsID - 会诊ID
/// Output:     1 - 是，0 - 不是
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).isOutHosPat()
ClassMethod isOutHosPat(CsID As %String) As %String
{
	n (CsID)
	s EpisodeID=$p(^DHCEMCON(CsID),"^",1)   /// 就诊ID
	Q:$p(^PAADM(EpisodeID),"^",2)="I" 0
	Q 1
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	是否是指定的病人类型
/// Input:      CsID - 会诊ID
/// Output:     1 - 是，0 - 不是
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).getPatType("")
ClassMethod getPatType(PatType As %String) As %String
{
	n (PatType, %CsID)
	s EpisodeID=$p(^DHCEMCON(%CsID),"^",1)   /// 就诊ID
	Q:$p(^PAADM(EpisodeID),"^",2)'=PatType 0
	Q 1
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	是否单科
/// Input:      CsID - 会诊ID
/// Output:     1 - 是，0 - 不是
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).isOneFlag()
ClassMethod isOneFlag(CsID As %String) As %String
{
	n (CsID)
	Q:($p(^DHCEMCON(CsID),"^",31)'="Y")&($p(^DHCEMCON(CsID),"^",24)'="Y") 1   /// 单科
	Q 0
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	是否多科
/// Input:      CsID - 会诊ID
/// Output:     1 - 是，0 - 不是
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).isMoreFlag()
ClassMethod isMoreFlag(CsID As %String) As %String
{
	n (CsID)
	Q:$p(^DHCEMCON(CsID),"^",31)="Y" 1   /// 多科
	Q 0
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	是否院外
/// Input:      CsID - 会诊ID
/// Output:     1 - 是，0 - 不是
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).isOutFlag()
ClassMethod isOutFlag(CsID As %String) As %String
{
	n (CsID)
	Q:$p(^DHCEMCON(CsID),"^",24)="Y" 1   /// 院外
	Q 0
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	是否护理
/// Input:      CsID - 会诊ID
/// Output:     1 - 是，0 - 不是
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).isNurFlag()
ClassMethod isNurFlag(CsID As %String) As %String
{
	n (CsID)
	Q:$p(^DHCEMCON(CsID),"^",19)="NUR" 1
	Q 0
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	是否医疗
/// Input:      CsID - 会诊ID
/// Output:     1 - 是，0 - 不是
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).isDocFlag()
ClassMethod isDocFlag(CsID As %String) As %String
{
	n (CsID)
	Q:$p(^DHCEMCON(CsID),"^",19)="DOC" 1
	Q 0
}

/// Creator: 	bianshuai
/// CreateDate: 2019-11-10
/// Descript: 	是否是指定的会诊类型
/// Input:      CstID - 会诊ID
/// Output:
/// Others:		W ##Class(web.DHCEMConsultWorkFlow).isCsType("")
ClassMethod isCsType(CsID As %String) As %String
{
	n (CsID)
	s CstTypeID=$p(^DHCEMCON(CsID),"^",8)      /// 会诊类型
	Q:$p(^DHCEMCDI(CstTypeID),"^",1)'=CsType 0
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	是否是指定的职称
/// InPut:      CstID - 会诊ID
/// OutPut:     0-未审核，1-审核
/// w ##Class(web.DHCEMConsultWorkFlow).isLastPrv()
ClassMethod isLastPrv(CsID As %String) As %String
{
	n (CsID)
	s userID=$p(^DHCEMCON(CsID),"^",5)   /// 申请医生
    s PrvTp=..GetPrvTp(userID)           /// 职称
	Q:((PrvTp["主治医师")||(PrvTp["副主任医师")||(PrvTp["主任医师")) 1
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	是否是指定的职称
/// InPut:      CstID - 会诊ID
/// OutPut:     0-未审核，1-审核
/// w ##Class(web.DHCEMConsultWorkFlow).isNotLastPrv()
ClassMethod isNotLastPrv(CsID As %String) As %String
{
	n (CsID)
	s userID=$p(^DHCEMCON(CsID),"^",5)   /// 申请医生
    s PrvTp=..GetPrvTp(userID)           /// 职称
	Q:((PrvTp["主治医师")||(PrvTp["副主任医师")||(PrvTp["主任医师")) 0
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	是否是指定的职称
/// InPut:      CstID - 会诊ID
/// OutPut:     0-未审核，1-审核
/// w ##Class(web.DHCEMConsultWorkFlow).getTakPrvTp()
ClassMethod getTakPrvTp(CsID As %String, Params = "") As %String
{
	n (CsID, Params)
	q:Params="" 1 //hxy 2021-02-04 容错（职称配置了前置未配置参数）
	s userID=$p(^DHCEMCON(CsID),"^",5)   /// 申请医生
    s PrvTp=..GetPrvTp(userID)           /// 职称
    Q:'$LF($LISTFROMSTRING(Params,","),PrvTp) 0
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	是否是指定的病人类型
/// InPut:      CstID - 会诊ID
/// OutPut:     0-未审核，1-审核
/// w ##Class(web.DHCEMConsultWorkFlow).isTakPatType()
ClassMethod getTakPatType(CsID As %String, Params = "") As %String
{
	n (CsID, Params)
	q:Params="" 1 //hxy 2021-02-04 容错（职称配置了前置未配置参数）
	s EpisodeID=$p(^DHCEMCON(CsID),"^",1)   /// 就诊ID
	//Q:$p(^PAADM(EpisodeID),"^",2)'="I" 0
	s PatType=$p(^PAADM(EpisodeID),"^",2)
	s PatType=$s(PatType="O":"门诊",PatType="E":"急诊",1:"住院")
	Q:'$LF($LISTFROMSTRING(Params,","),PatType) 0
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	取医生职称
/// InPut:      CstID - 会诊ID
/// OutPut:     0-未审核，1-审核
/// w ##Class(web.DHCEMConsultWorkFlow).GetPrvTp("147")
ClassMethod GetPrvTp(userID As %String) As %String
{
	n (userID)
	s CareProvID=$p($g(^SSU("SSUSR",+userID)),"^",14)    /// 医生
	s PrvTpID="",PrvTp=""
	s PrvTpID=$p($g(^CTPCP(+CareProvID,1)),"^",4)        /// 职称
	i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	Q PrvTp
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	前置条件判断
/// InPut:      CsID - 会诊ID
/// OutPut:     0 - 通过，1 - 未通过
/// w ##Class(web.DHCEMConsultWorkFlow).TakPreCon("147")
ClassMethod TakPreCon(CsID As %String, WFID As %String) As %String
{
	n (CsID, WFID)
	Q:'$D(^DHCEMCONPC(0,"WorkFlow",WFID)) 1   ;多院区改造需要更改
	s PcID="", Flag=0
	F  s PcID=$o(^DHCEMCONPC(0,"WorkFlow",WFID,PcID)) Q:(PcID="")||(Flag=1)  D
	.s FnID=$p(^DHCEMCONPC(PcID),"^",2)
	.Q:$p(^DHCEMCONF(FnID),"^",4)'="Y"
	.s FnParam=$p(^DHCEMCONPC(PcID),"^",3)
	.Q:..ExecFn(CsID, FnID, FnParam)
	.s Flag=1
	.
	Q Flag
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	符合当前会诊的工作流项目
/// InPut:      CsID - 会诊ID
/// OutPut:     工作流项目指针
/// w ##Class(web.DHCEMConsultWorkFlow).GetCsWorkFlow("147")
ClassMethod GetCsWorkFlow(CsID As %String, InHospID = "") As %String
{
	n (CsID,InHospID)
	i InHospID="" d
	.s CsRLocID=$p(^DHCEMCON(CsID),"^",2)        /// 申请科室
	.s InHospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(CsRLocID)
	
	s InHospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsWorkFlow",InHospID)
	s ID=0, WFID=""
	F  s ID=$o(^DHCEMCONWF(ID)) Q:(ID="")||(WFID'="")  D
	.s HospID=$p(^DHCEMCONWF(ID),"^",3)
	.q:(InHospID'="")&&(InHospID'=HospID)
	.Q:..TakPreCon(CsID, ID)
	.s WFID=ID
	.
	Q WFID
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	用户权限
/// InPut:      CstID - 会诊ID
/// OutPut:     0-未审核，1-审核
/// w ##Class(web.DHCEMConsultWorkFlow).GetUserGrant("29^95^10209")
ClassMethod GetUserGrant(LgParams As %String, TmpArr As %String, Flag As %String) As %String
{
	n (LgParams, TmpArr, Flag)
	
	s TmpArr=""
	s LgGroupID=$p(LgParams,"^",1)  /// 安全组
	s LgLocID=$p(LgParams,"^",2)    /// 科室
	s LgUserID=$p(LgParams,"^",3)   /// 人员
	
	/// 按人取配置
	i LgUserID'=""  d
	.s WIID=""
	.F  s WIID=$o(^DHCEMCONG(0,"TypePointer","U",LgUserID,WIID)) Q:WIID=""  D
	..i Flag=1 s TmpArr(+WIID)=WIID
	..E  s TmpArr(WIID)=""
	.

	/// 按安全组取
	i (LgGroupID'="")||(TmpArr="")  d
	.s WIID=""
	.F  s WIID=$o(^DHCEMCONG(0,"TypePointer","G",LgGroupID,WIID)) Q:WIID=""  D
	..i Flag=1 s TmpArr(+WIID)=WIID
	..E  s TmpArr(WIID)=""
	.

    /// 按科室取
	i (LgLocID'="")||(TmpArr="")  d
	.s WIID=""
	.F  s WIID=$o(^DHCEMCONG(0,"TypePointer","L",LgLocID,WIID)) Q:WIID=""  D
	..i Flag=1 s TmpArr(+WIID)=WIID
	..E  s TmpArr(WIID)=""
	.
	
	Q TmpArr
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	取当前状态的下一个工作流
/// InPut:      CstID - 会诊ID
/// OutPut:     0-未审核，1-审核
/// w ##Class(web.DHCEMConsultWorkFlow).GetNextWorkFlowItem("154")
ClassMethod GetNextWorkFlowItem(CsID As %String, InHospID = "", direction = 1) As %Library.String
{
	n (CsID, InHospID, direction)
	s StatusID=$p(^DHCEMCON(CsID),"^",18)      /// 申请状态
	Q:StatusID="" ""
	s WFID=..GetCsWorkFlow(CsID,InHospID)      /// 取当前会诊工作流ID
	Q:WFID="" ""
	s LCH=$o(^DHCEMCONWF(0,"Status",StatusID,WFID,""))
	Q:LCH="" ""
	s CH=$o(^DHCEMCONWF(WFID,"I",LCH), direction)
	Q:CH="" ""
	Q WFID_"||"_CH
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	取当前会诊状态的下一个状态ID
/// InPut:      CstID - 会诊ID
/// OutPut:     空 ，非空 - 状态代码
/// w ##Class(web.DHCEMConsultWorkFlow).GetGrantStCode("154")
ClassMethod GetGrantStCode(CsID As %String, LgParams As %String) As %Library.String
{
	n (CsID, LgParams)
	k TmpArr
	s CstRLocID=$p(^DHCEMCON(CsID),"^",2)   /// 申请科室
	s CstHospID=$p(^CTLOC(CstRLocID),"^",22)
	D ..GetUserGrant(LgParams, .TmpArr, 0)  /// 用户权限
	s WFID=..GetNextWorkFlowItem(CsID,CstHospID)
	Q:WFID="" ""
	Q:'$d(TmpArr(WFID)) ""
	s StID=$p(^DHCEMCONWF(+WFID,"I",$p(WFID,"||",2)),"^",1)
	Q StID
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	当前会诊是否已经审核
/// InPut:      CstID - 会诊ID
/// OutPut:     1 - 已审 ，0 - 未审 
/// w ##Class(web.DHCEMConsultWorkFlow).isTakFlag("155")
ClassMethod isTakFlag(CsID As %String, LgParams As %String) As %Library.String
{
	n (CsID, LgParams)
	k TmpWFArr
	s CstRLocID=$p(^DHCEMCON(CsID),"^",2)   /// 申请科室
	s CstHospID=$p(^CTLOC(CstRLocID),"^",22)
	s WFID=..GetNextWorkFlowItem(CsID,CstHospID)     /// 下一个工作流
	Q:WFID="" 1
	s CH=""
	F  s CH=$o(^DHCEMCONWF(+WFID,"I",CH)) Q:CH=""  D
	.s TmpWFArr(+WFID_"||"_CH)=$s($p(WFID,"||",2)>CH:1,$p(WFID,"||",2)=CH:2,1:0)
	.
	
	k TmpArr
	D ..GetUserGrant(LgParams, .TmpArr, 0) /// 用户权限
	s ID="", userGrantID=""
	F  s ID=$o(TmpArr(ID)) Q:ID=""  D
	.i +WFID=+ID s userGrantID=ID
	.
	Q $g(TmpWFArr(userGrantID))
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	当前会诊工作流是否已经审核完
/// InPut:      CstID - 会诊ID
/// OutPut:     Y - 审核完成 ，N - 未审完成 
/// w ##Class(web.DHCEMConsultWorkFlow).isWFCompFlag("155")
ClassMethod isWFCompFlag(CsID As %String, InHospID = "") As %Library.String
{
	n (CsID,InHospID)
	i InHospID="" d
	.s CsRLocID=$p(^DHCEMCON(CsID),"^",2)        /// 申请科室
	.s InHospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(CsRLocID)
	Q:'..GetNextWorkFlowItem(CsID,InHospID) "Y"  /// 取当前状态的下一个工作流
	Q "N"
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	取用户权限对应会诊工作流状态Code
/// InPut:      CstID - 会诊ID
/// OutPut:     空 ，非空 - 状态代码
/// w ##Class(web.DHCEMConsultWorkFlow).GetUserGrantStCode("154")
ClassMethod GetUserGrantStCode(CsID As %String, LgParams As %String) As %Library.String
{
	n (CsID, LgParams)
	k TmpArr
	s CstRLocID=$p(^DHCEMCON(CsID),"^",2)   /// 申请科室
	s CstHospID=$p(^CTLOC(CstRLocID),"^",22)
	D ..GetUserGrant(LgParams, .TmpArr, 1)  /// 用户权限
	s ID=..GetCsWorkFlow(CsID,CstHospID)
	Q:'$d(TmpArr(ID)) ""
	s WFID=$g(TmpArr(ID))
	s StID=$p(^DHCEMCONWF(+WFID,"I",$p(WFID,"||",2)),"^",1)
	Q $p(^DHCEMCONS(StID),"^")
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	取当前会诊状态的上一个状态ID
/// InPut:      CstID - 会诊ID
/// OutPut:     空 ，非空 - 状态代码
/// w ##Class(web.DHCEMConsultWorkFlow).GetGrantPrevStCode("154")
ClassMethod GetGrantPrevStCode(CsID As %String) As %Library.String
{
	n (CsID)
	k TmpArr
	s RLocID=$p(^DHCEMCON(CsID),"^",2)   /// 申请科室
	s HospID=$p(^CTLOC(RLocID),"^",22)
	s WFID=..GetNextWorkFlowItem(CsID, HospID, -1)
	Q:WFID="" ""
	s StID=$p(^DHCEMCONWF(+WFID,"I",$p(WFID,"||",2)),"^",1)
	Q StID
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	工作流最后一个状态
/// InPut:      CstID - 会诊ID
/// OutPut:     0-未审核，1-审核
/// w ##Class(web.DHCEMConsultWorkFlow).GetWorkFlowLastStCode("154")
ClassMethod GetWorkFlowLastStCode(CsID As %String, InHospID = "") As %Library.String
{
	n (CsID, InHospID)
	s WFID=..GetCsWorkFlow(CsID,InHospID)      /// 取当前会诊工作流ID
	Q:WFID="" ""
	s CH=$o(^DHCEMCONWF(WFID,"I",""), -1)
	Q:CH="" ""
	s StID=$p(^DHCEMCONWF(+WFID,"I",CH),"^",1)
	Q StID
}

}
