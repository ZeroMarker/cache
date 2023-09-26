Import sqluser

/// Creator:    bianshuai
/// CreateDate: 2016-06-12
/// Descript:用药错误报告业务类
Class web.DHCSTPHCMDrugMisUseReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存用药错误
/// w ##Class(web.DHCSTPHCMDrugMisUseReport).save("","","")
ClassMethod save(mrRepID As %String, mrListData As %String, mrItemList As %String) As %String
{
	n (mrRepID,mrListData,mrItemList)
	s ret=0
	i mrRepID="" d
	.s ret=..Insert(mrListData,mrItemList)
	e  d
	.s ret=..Update(mrRepID,mrListData,mrItemList)
	q ret
}

/// Descript:Insert DHC_PHDrgMisReport
ClassMethod Insert(mrListData As %String, mrItemList As %String) As %String
{
	n (mrListData,mrItemList)
	s Err=0
	TS
	/// 报告主信息
	s mrRepID=..InsMisRep(mrListData)
	i mrRepID<0 tro
	q:mrRepID<0 mrRepID

	/// 药品信息
	i mrItemList'="" d
	.s Err=..InsMisRepDrgItm(mrRepID,mrItemList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	TC
	//Q 0
	Q mrRepID
}

/// Descript:Update DHC_PHDrgMisReport
ClassMethod Update(mrRepID As %String, mrListData As %String, mrItemList As %String) As %String
{
	n (mrRepID,mrListData,mrItemList)
	s Err=0
	TS
	s mrRepID=..UpdMisRep(mrRepID,mrListData)
	i mrRepID<0 tro
	q:mrRepID<0 mrRepID
	
	/// 删除药品信息
	s Err=..delDrgMisRepDrgItm(mrRepID)
	i Err'=0 tro
	q:Err'=0 "-11"

	/// 药品信息
	i mrItemList'="" d
	.s Err=..InsMisRepDrgItm(mrRepID,mrItemList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	TC
	//Q 0
	Q mrRepID
}

/// 报告日期^发生日期^发现日期^是否发给患者^患者是否使用^错误分级^姓名^性别^年龄^出生日期^体重^联系方式^登记号^诊断^伤害结果
/// 伤害结果描述^死亡日期^死亡时间^抢救^抢救(措施)^恢复过程^报告人^报告科室^职称^电话^E-mail^邮编^发生错误的场所^发生错误的场所描述
/// 引起差错的人员^引起差错的人员描述^发现错误人员^发现错误人员描述^错误相关人员^错误相关人员描述^后果及防范措施^是否提供药品相关资料^是否提供药品相关资料描述^错误内容^引发错误的因素^当前状态
/// Descript:	插入用药错表误报告
ClassMethod InsMisRep(mrListData As %String) As %String
{
	n (mrListData)
	s mrRepDate=$p(mrListData,"^",1)    	//报告日期
	s:mrRepDate'="" mrRepDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrRepDate) ;$zdh(mrRepDate,3)
	s mrErrOccDate=$p(mrListData,"^",2)		//错误发生日期
	s:mrErrOccDate'="" mrErrOccDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrErrOccDate) ;$zdh(mrErrOccDate,3)
	s mrDisErrDate=$p(mrListData,"^",3)     //发现错误日期
	s:mrDisErrDate'="" mrDisErrDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrDisErrDate) ;$zdh(mrDisErrDate,3)
	s mrDspToPat=$p(mrListData,"^",4)   	//是否发药
	s mrPatTaked=$p(mrListData,"^",5)   	//是否用药
	s mrErrorLevel=$p(mrListData,"^",6) 	//错误级别
	s PatientID=$p(mrListData,"^",7)    	//病人ID
	s mrPatName=$p(mrListData,"^",8)    	//姓名
	s mrPatSex=$p(mrListData,"^",9)    	 	//性别
	s mrPatAge=$p(mrListData,"^",10)    	//年龄
	s mrPatDOB=$p(mrListData,"^",11)    	//出生日期
	s:mrPatDOB'="" mrPatDOB=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrPatDOB) ;$zdh(mrPatDOB,3)
	s mrPatWeight=$p(mrListData,"^",12)  	//体重
	s mrPatContact=$p(mrListData,"^",13) 	//联系方式
	s mrPatMedNo=$p(mrListData,"^",14)   	//住院号/门诊就诊号
	s mrICDDesc=$p(mrListData,"^",15)    	//诊断
	s mrHarmRet=$p(mrListData,"^",16)    	//伤害结果
	s mrHarmRetDesc=$p(mrListData,"^",17)  	//伤害结果描述
	s mrDeathDate=$p(mrListData,"^",18)    	//死亡日期
	s:mrDeathDate'="" mrDeathDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrDeathDate) ;$zdh(mrDeathDate,3)
	s mrDeathTime=$p(mrListData,"^",19)     //死亡时间
	s:mrDeathTime'="" mrDeathTime=$zth(mrDeathTime,1)
	s mrRescue=$p(mrListData,"^",20)      	//是否抢救
	s mrResMeasDesc=$p(mrListData,"^",21) 	//抢救措施
	s mrRecProc=$p(mrListData,"^",22)     	//恢复过程
	s mrRepUser=$p(mrListData,"^",23)     	//报告人
	s mrDeptOfRepUser=$p(mrListData,"^",24) //报告人科室
	s mrProTitle=$p(mrListData,"^",25)      //报告人职称
	s mrTelOfRepUser=$p(mrListData,"^",26)  //报告人电话
	s mrEmail=$p(mrListData,"^",27)         //Email
	s mrPostCode=$p(mrListData,"^",28)      //邮编
	s mrErrHappSite=$p(mrListData,"^",29)   //错误发生场所
	s mrErrHappSiteDesc=$p(mrListData,"^",30)  //错误发生场所描述
	s mrTriErrUser=$p(mrListData,"^",31)       //引发错误人员职称
	s mrTriErrUserDesc=$p(mrListData,"^",32)   //引发错误人员职称描述
	s mrDisErrUser=$p(mrListData,"^",33)       //发现错误人员职称
	s mrDisErrUserDesc=$p(mrListData,"^",34)   //发现错误人员职称描述
	s mrErrRelUser=$p(mrListData,"^",35)       //错误相关人员职称
	s mrErrRelUserDesc=$p(mrListData,"^",36)   //错误相关人员职称描述
	s mrDisAndHandMea=$p(mrListData,"^",37)    //发现和处理措施
	s mrProDrgRelInfo=$p(mrListData,"^",38)    //能否提供相关资料
	s mrDrgRelInfoDesc=$p(mrListData,"^",39)   //相关信息描述
	s mrErrContent=$p(mrListData,"^",40)       //错误内容
	s mrTriErrFac=$p(mrListData,"^",41)        //诱发因素
	s mrCurStatus=$p(mrListData,"^",42)        //当前状态 //liyarong 2016-09-19
	s mrReqCode=..GetCurMaxNo("M"_$zd(+$H,8),"3") //编码
	
	&SQL(Insert Into DHC_PHDrgMisReport(DMR_RepDate,DMR_ErrOccDate,DMR_DisErrDate,DMR_DspToPat,DMR_PatTaked,DMR_ErrorLevel,DMR_PatID,
		DMR_PatName,DMR_PatSex,DMR_PatAge,DMR_PatDOB,DMR_PatWeight,DMR_PatContact,DMR_PatMedNo,DMR_ICDDesc,DMR_HarmRet,DMR_HarmRetDesc,
		DMR_DeathDate,DMR_DeathTime,DMR_Rescue,DMR_ResMeasDesc,DMR_RecProc,DMR_RepUser,DMR_DeptOfReporter,DMR_ProTitleOfReporter,DMR_TelOfReporter,
		DMR_EmailOfReporter,DMR_PostCode,DMR_ErrHappSite,DMR_ErrHappSiteDesc,DMR_TriErrUser,DMR_TriErrUserDesc,DMR_DisErrUser,DMR_DisErrUserDesc,DMR_ErrRelUser,
		DMR_ErrRelUserDesc,DMR_DisAndHandMea,DMR_ProDrgRelInfo,DMR_DrgRelInfoDesc,DMR_PreSuggest,DMR_ErrContent,DMR_TriErrFac,DMR_RepCode,DMR_CurStatus_DR)
		values(:mrRepDate,:mrErrOccDate,:mrDisErrDate,:mrDspToPat,:mrPatTaked,:mrErrorLevel,:PatientID,:mrPatName,:mrPatSex,:mrPatAge,:mrPatDOB,:mrPatWeight,
		:mrPatContact,:mrPatMedNo,:mrICDDesc,:mrHarmRet,:mrHarmRetDesc,:mrDeathDate,:mrDeathTime,:mrRescue,:mrResMeasDesc,:mrRecProc,:mrRepUser,:mrDeptOfRepUser,
		:mrProTitle,:mrTelOfRepUser,:mrEmail,:mrPostCode,:mrErrHappSite,:mrErrHappSiteDesc,:mrTriErrUser,:mrTriErrUserDesc,:mrDisErrUser,:mrDisErrUserDesc,:mrErrRelUser,:mrErrRelUserDesc,
		:mrDisAndHandMea,:mrProDrgRelInfo,:mrDrgRelInfoDesc,:mrPreSuggest,:mrErrContent,:mrTriErrFac,:mrReqCode,:mrCurStatus))
	B  ///BBB
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript:	更新用药错表误报告
ClassMethod UpdMisRep(drgMURepID As %String, mrListData As %String) As %String
{
	n (drgMURepID,mrListData)
	s mrRepDate=$p(mrListData,"^",1)    	//报告日期
	s:mrRepDate'="" mrRepDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrRepDate) ;$zdh(mrRepDate,3)
	s mrErrOccDate=$p(mrListData,"^",2)		//错误发生日期
	s:mrErrOccDate'="" mrErrOccDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrErrOccDate) ;$zdh(mrErrOccDate,3)
	s mrDisErrDate=$p(mrListData,"^",3)     //发现错误日期
	s:mrDisErrDate'="" mrDisErrDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrDisErrDate) ;$zdh(mrDisErrDate,3)
	s mrDspToPat=$p(mrListData,"^",4)   	//是否发药
	s mrPatTaked=$p(mrListData,"^",5)   	//是否用药
	s mrErrorLevel=$p(mrListData,"^",6) 	//错误级别
	s PatientID=$p(mrListData,"^",7)    	//病人ID
	s mrPatName=$p(mrListData,"^",8)    	//姓名
	s mrPatSex=$p(mrListData,"^",9)    	 	//性别
	s mrPatAge=$p(mrListData,"^",10)    	//年龄
	s mrPatDOB=$p(mrListData,"^",11)    	//出生日期
	s:mrPatDOB'="" mrPatDOB=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrPatDOB) ;$zdh(mrPatDOB,3)
	s mrPatWeight=$p(mrListData,"^",12)  	//体重
	s mrPatContact=$p(mrListData,"^",13) 	//联系方式
	s mrPatMedNo=$p(mrListData,"^",14)   	//住院号/门诊就诊号
	s mrICDDesc=$p(mrListData,"^",15)    	//诊断
	s mrHarmRet=$p(mrListData,"^",16)    	//伤害结果
	s mrHarmRetDesc=$p(mrListData,"^",17)  	//伤害结果描述
	s mrDeathDate=$p(mrListData,"^",18)    	//死亡日期
	s:mrDeathDate'="" mrDeathDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(mrDeathDate) ;$zdh(mrDeathDate,3)
	s mrDeathTime=$p(mrListData,"^",19)     //死亡时间
	s:mrDeathTime'="" mrDeathTime=$zth(mrDeathTime,1)
	s mrRescue=$p(mrListData,"^",20)      	//是否抢救
	s mrResMeasDesc=$p(mrListData,"^",21) 	//抢救措施
	s mrRecProc=$p(mrListData,"^",22)     	//恢复过程
	s mrRepUser=$p(mrListData,"^",23)     	//报告人
	s mrDeptOfRepUser=$p(mrListData,"^",24) //报告人科室
	s mrProTitle=$p(mrListData,"^",25)      //报告人职称
	s mrTelOfRepUser=$p(mrListData,"^",26)  //报告人电话
	s mrEmail=$p(mrListData,"^",27)         //Email
	s mrPostCode=$p(mrListData,"^",28)      //邮编
	s mrErrHappSite=$p(mrListData,"^",29)   //错误发生场所
	s mrErrHappSiteDesc=$p(mrListData,"^",30)  //错误发生场所描述
	s mrTriErrUser=$p(mrListData,"^",31)       //引发错误人员职称
	s mrTriErrUserDesc=$p(mrListData,"^",32)   //引发错误人员职称描述
	s mrDisErrUser=$p(mrListData,"^",33)       //发现错误人员职称
	s mrDisErrUserDesc=$p(mrListData,"^",34)   //发现错误人员职称描述
	s mrErrRelUser=$p(mrListData,"^",35)       //错误相关人员职称
	s mrErrRelUserDesc=$p(mrListData,"^",36)   //错误相关人员职称描述
	s mrDisAndHandMea=$p(mrListData,"^",37)    //发现和处理措施
	s mrProDrgRelInfo=$p(mrListData,"^",38)    //能否提供相关资料
	s mrDrgRelInfoDesc=$p(mrListData,"^",39)   //相关信息描述
	s mrErrContent=$p(mrListData,"^",40)       //错误内容
	s mrTriErrFac=$p(mrListData,"^",41)        //诱发因素
    s mrCurStatus=$p(mrListData,"^",42)        //当前状态
	&SQL(Update DHC_PHDrgMisReport Set DMR_RepDate=:mrRepDate,DMR_ErrOccDate=:mrErrOccDate,DMR_DisErrDate=:mrDisErrDate,DMR_DspToPat=:mrDspToPat,DMR_PatTaked=:mrPatTaked,DMR_ErrorLevel=:mrErrorLevel,DMR_PatID=:PatientID,
		DMR_PatName=:mrPatName,DMR_PatSex=:mrPatSex,DMR_PatAge=:mrPatAge,DMR_PatDOB=:mrPatDOB,DMR_PatWeight=:mrPatWeight,DMR_PatContact=:mrPatContact,DMR_PatMedNo=:mrPatMedNo,DMR_ICDDesc=:mrICDDesc,DMR_HarmRet=:mrHarmRet,DMR_HarmRetDesc=:mrHarmRetDesc,
		DMR_DeathDate=:mrDeathDate,DMR_DeathTime=:mrDeathTime,DMR_Rescue=:mrRescue,DMR_ResMeasDesc=:mrResMeasDesc,DMR_RecProc=:mrRecProc,DMR_RepUser=:mrRepUser,DMR_DeptOfReporter=:mrDeptOfRepUser,DMR_ProTitleOfReporter=:mrProTitle,DMR_TelOfReporter=:mrTelOfRepUser,
		DMR_EmailOfReporter=:mrEmail,DMR_PostCode=:mrPostCode,DMR_ErrHappSite=:mrErrHappSite,DMR_ErrHappSiteDesc=:mrErrHappSiteDesc,DMR_TriErrUser=:mrTriErrUser,DMR_TriErrUserDesc=:mrTriErrUserDesc,DMR_DisErrUser=:mrDisErrUser,DMR_DisErrUserDesc=:mrDisErrUserDesc,DMR_ErrRelUser=:mrErrRelUser,
		DMR_ErrRelUserDesc=:mrErrRelUserDesc,DMR_DisAndHandMea=:mrDisAndHandMea,DMR_ProDrgRelInfo=:mrProDrgRelInfo,DMR_DrgRelInfoDesc=:mrDrgRelInfoDesc,DMR_ErrContent=:mrErrContent,DMR_TriErrFac=:mrTriErrFac,DMR_CurStatus_DR=:mrCurStatus WHERE DMR_RowID=:drgMURepID)
	B  ///MM
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript:	保存用药错误相关药品信息
ClassMethod InsMisRepDrgItm(drgMURepID As %String, dqEvtRepDrgItmList As %String) As %String
{
	n (drgMURepID,dqEvtRepDrgItmList)
	s Len=$L(dqEvtRepDrgItmList,"!!")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s dqEvtRepDrgItm=$p(dqEvtRepDrgItmList,"!!",i)
	.s oeori=$p(dqEvtRepDrgItm,"^",1)      /// 医嘱ID
	.s phcddr=$p(dqEvtRepDrgItm,"^",2)     /// 药学项ID
	.s goodsname=$p(dqEvtRepDrgItm,"^",3)  /// 商品名
	.s genericdr=$p(dqEvtRepDrgItm,"^",4)  /// 通用名
	.s phformdr=$p(dqEvtRepDrgItm,"^",5)   /// 剂型
	.s dosage=+$p(dqEvtRepDrgItm,"^",6)    /// 剂量
	.s dosuomdr=$p(dqEvtRepDrgItm,"^",7)   /// 剂量单位
	.s instrucdr=$p(dqEvtRepDrgItm,"^",8)  /// 用法
	.s freqdr=$p(dqEvtRepDrgItm,"^",9)     /// 频次
	.s manfdr=$p(dqEvtRepDrgItm,"^",10)    /// 厂家
	.s drgcat=$p(dqEvtRepDrgItm,"^",11)    /// 药品分类
	.s spec=$p(dqEvtRepDrgItm,"^",12)      /// 规格
	.s packtype=$p(dqEvtRepDrgItm,"^",13)  /// 包装类型
	.
	.s childSub=$o(^DHCPHDMR(drgMURepID,"DMRDI",""),-1)+1
	.&SQL(Insert Into DHC_PHDrgMisRepDrgItm(DMRDI_DMR_Parref,DMRDI_ChildSub,DMRDI_OEORI_DR,DMRDI_PHCD_DR,
		DMRDI_GoodsName,DMRDI_Generic_DR,DMRDI_PhForm_DR,DMRDI_Dosage,DMRDI_DosUom_DR,DMRDI_Instruc_DR,DMRDI_Freq_DR,
		DMRDI_Manf_DR,DMRDI_Classify,DMRDI_Spec,DMRDI_PackType)
		Values(:drgMURepID,:childSub,:oeori,:phcddr,:goodsname,:genericdr,:phformdr,:dosage,:dosuomdr,
			:instrucdr,:freqdr,:manfdr,:drgcat,:spec,:packtype))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:药品用药错误相关药品信息
ClassMethod delDrgMisRepDrgItm(drgMURepID As %String) As %String
{
	N (drgMURepID)
	i $d(^DHCPHDMR(drgMURepID,"DMRDI",1)) d    //liyarong 2016-10-09
	.&SQL(DELETE DHC_PHDrgMisRepDrgItm WHERE DMRDI_DMR_Parref=:drgMURepID)
	Q +$g(SQLCODE)                               //liyarong 2016-10-09
}

/// Descript:   取当前报告最大编码
ClassMethod GetCurMaxNo(Prefix As %String, NoLen As %String) As %String
{
	N (Prefix,NoLen,CurrMaxNo)
	S NextNo=""
	L +^DHCPHCMADR("DHCPHCMADR",Prefix):10 E  Q -100
	S PreLen=$L(Prefix)
	S MinSuffix=1
	F i=1:1:NoLen-1 S MinSuffix="0"_MinSuffix
	S MinNo=Prefix_MinSuffix	//最小码
	S CurLen=PreLen+NoLen	    //单号长度
	///表里记录的最大码
	S CurrMaxNo=..GetMaxCodeByCode(Prefix)
	S CurPrefix=$E(CurrMaxNo,1,PreLen)
	S CurrNo=$E(CurrMaxNo,PreLen+1,CurLen)

	i Prefix'=CurPrefix D
	.S NextNo=MinNo
	.L -^DHCPHCMADR("DHCPHCMADR",Prefix)
	Q:NextNo'="" NextNo

	S Suffix=CurrNo+1
	
	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix="0"_Suffix
	S NextNo=Prefix_Suffix
	L -^DHCPHCMADR("DHCPHCMADR",Prefix)
	Q NextNo
}

/// Descript:获取当前最大码
/// 科室当前处方最编码
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S adrrcode=""
	&sql(select max(DMR_RepCode) into :adrrcode from DHC_PHDrgMisReport Where DMR_RepCode %STARTSWITH %ALPHAUP :Prefix)
	Q adrrcode
}

}
