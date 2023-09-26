Import sqluser

/// Descript:用药错误报告业务类
Class web.DHCSTPHCMDRGMISUSEREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存用药错误
ClassMethod SaveDrgQEvtReport(drgMURepID As %String, drgMURepList As %String, drgMURepDrgItmList As %String) As %String
{
	n (drgMURepID,drgMURepList,drgMURepDrgItmList)
	s ret=0
	i drgMURepID="" d
	.s ret=..Insert(drgMURepList,drgMURepDrgItmList)
	e  d
	.s ret=..Update(drgMURepID,drgMURepList,drgMURepDrgItmList)
	q ret
}

/// Descript:Insert DHC_PHDrgMisReport
ClassMethod Insert(drgMURepList As %String, drgMURepDrgItmList As %String) As %String
{
	n (drgMURepList,drgMURepDrgItmList)
	s Err=0
	TS
	s drgMURepID=..InsDrgMisuseReport(drgMURepList)
	i drgMURepID<0 tro
	q:drgMURepID<0 drgMURepID

	//保存用药错误报告相关药品信息
	i drgMURepDrgItmList'="" d
	.s Err=..InsDrgMisRepDrgItm(drgMURepID,drgMURepDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	TC
	Q 0
}

/// Descript:Update DHC_PHDrgMisReport
ClassMethod Update(drgMURepID As %String, drgMURepList As %String, drgMURepDrgItmList As %String) As %String
{
	n (drgMURepID,drgMURepList,drgMURepDrgItmList)
	s Err=0
	TS
	s drgMURepID=..UpdDrgMisuseReport(drgMURepID,drgMURepList)
	i drgMURepID<0 tro
	q:drgMURepID<0 drgMURepID
	B  ///NNNN
	//保存用药错误报告相关药品信息
	s Err=..delDrgMisRepDrgItm(drgMURepID)
	i Err'=0 tro
	q:Err'=0 Err
	B   ///XXXX
	i drgMURepDrgItmList'="" d
	.s Err=..InsDrgMisRepDrgItm(drgMURepID,drgMURepDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	TC
	Q 0
}

/// Descript:插入用药错表误报告
ClassMethod InsDrgMisuseReport(drgMURepList As %String) As %String
{
	n (drgMURepList)
	s RepDate=$p(drgMURepList,"^",1)    //报告日期
	s:RepDate'="" RepDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(RepDate) ;$zdh(RepDate,3)
	s ErrOccDate=$p(drgMURepList,"^",2) //错误发生日期
	s:ErrOccDate'="" ErrOccDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(ErrOccDate) ;$zdh(ErrOccDate,3)
	s DisErrDate=$p(drgMURepList,"^",3) //发现错误日期
	s:DisErrDate'="" DisErrDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(DisErrDate) ;$zdh(DisErrDate,3)
	s DspToPat=$p(drgMURepList,"^",4)   //是否发药
	s PatTaked=$p(drgMURepList,"^",5)   //是否用药
	s ErrorLevel=$p(drgMURepList,"^",6) //错误级别
	s PatID=$p(drgMURepList,"^",7)      //病人ID
	s PatName=$p(drgMURepList,"^",8)    //姓名
	s PatSex=$p(drgMURepList,"^",9)     //性别
	s PatAge=$p(drgMURepList,"^",10)    //年龄
	s PatDOB=$p(drgMURepList,"^",11)    //出生日期
	s:PatDOB'="" PatDOB=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(PatDOB) ;$zdh(PatDOB,3)
	s PatWeight=$p(drgMURepList,"^",12)  //体重
	s PatContact=$p(drgMURepList,"^",13) //联系方式
	s PatMedNo=$p(drgMURepList,"^",14)   //住院号/门诊就诊号
	s ICDDesc=$p(drgMURepList,"^",15)    //诊断
	s HarmRet=$p(drgMURepList,"^",16)    //伤害结果
	s HarmRetDesc=$p(drgMURepList,"^",17) //伤害结果描述
	s DeathDate=$p(drgMURepList,"^",18) //死亡日期
	s:DeathDate'="" DeathDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(DeathDate) ;$zdh(DeathDate,3)
	s DeathTime=$p(drgMURepList,"^",19) //死亡时间
	S:DeathTime'="" DeathTime=$zth(DeathTime,1)
	s Rescue=$p(drgMURepList,"^",20)      //是否抢救
	s ResMeasDesc=$p(drgMURepList,"^",21) //抢救措施
	s RecProc=$p(drgMURepList,"^",22)     //恢复过程
	s RepUser=$p(drgMURepList,"^",23)     //报告人
	s DeptOfRepUser=$p(drgMURepList,"^",24) //报告人科室
	s ProTitle=$p(drgMURepList,"^",25)      //报告人职称
	s TelOfRepUser=$p(drgMURepList,"^",26)  //报告人电话
	s Email=$p(drgMURepList,"^",27)         //Email
	s PostCode=$p(drgMURepList,"^",28)      //邮编
	s ErrHappSite=$p(drgMURepList,"^",29)   //错误发生场所
	s ErrHappSiteDesc=$p(drgMURepList,"^",30)   //错误发生场所描述
	s TriErrUser=$p(drgMURepList,"^",31)     //引发错误人员职称
	s TriErrUserDesc=$p(drgMURepList,"^",32) //引发错误人员职称描述
	s DisErrUser=$p(drgMURepList,"^",33)     //发现错误人员职称
	s DisErrUserDesc=$p(drgMURepList,"^",34) //发现错误人员职称描述
	s ErrRelUser=$p(drgMURepList,"^",35)     //错误相关人员职称
	s ErrRelUserDesc=$p(drgMURepList,"^",36) //错误相关人员职称描述
	s DisAndHandMea=$p(drgMURepList,"^",37)  //发现和处理措施
	s ProDrgRelInfo=$p(drgMURepList,"^",38)  //能否提供相关资料
	s DrgRelInfoDesc=$p(drgMURepList,"^",39) //相关信息描述
	s PreSuggest=$p(drgMURepList,"^",40) //预防建议
	s ErrContent=$p(drgMURepList,"^",41) //错误内容
	s TriErrFac=$p(drgMURepList,"^",42)  //诱发因素
	s RepCode=$p(drgMURepList,"^",43)    //编码
	s RepProcess=$p(drgMURepList,"^",44)    //错误发生经过
	&SQL(Insert Into DHC_PHDrgMisReport(DMR_RepDate,DMR_ErrOccDate,DMR_DisErrDate,DMR_DspToPat,DMR_PatTaked,DMR_ErrorLevel,DMR_PatID,
		DMR_PatName,DMR_PatSex,DMR_PatAge,DMR_PatDOB,DMR_PatWeight,DMR_PatContact,DMR_PatMedNo,DMR_ICDDesc,DMR_HarmRet,DMR_HarmRetDesc,
		DMR_DeathDate,DMR_DeathTime,DMR_Rescue,DMR_ResMeasDesc,DMR_RecProc,DMR_RepUser,DMR_DeptOfReporter,DMR_ProTitleOfReporter,DMR_TelOfReporter,
		DMR_EmailOfReporter,DMR_PostCode,DMR_ErrHappSite,DMR_ErrHappSiteDesc,DMR_TriErrUser,DMR_TriErrUserDesc,DMR_DisErrUser,DMR_DisErrUserDesc,DMR_ErrRelUser,
		DMR_ErrRelUserDesc,DMR_DisAndHandMea,DMR_ProDrgRelInfo,DMR_DrgRelInfoDesc,DMR_PreSuggest,DMR_ErrContent,DMR_TriErrFac,DMR_RepCode,DMR_ErrHappProcess)
		values(:RepDate,:ErrOccDate,:DisErrDate,:DspToPat,:PatTaked,:ErrorLevel,:PatID,:PatName,:PatSex,:PatAge,:PatDOB,:PatWeight,
		:PatContact,:PatMedNo,:ICDDesc,:HarmRet,:HarmRetDesc,:DeathDate,:DeathTime,:Rescue,:ResMeasDesc,:RecProc,:RepUser,:DeptOfRepUser,
		:ProTitle,:TelOfRepUser,:Email,:PostCode,:ErrHappSite,:ErrHappSiteDesc,:TriErrUser,:TriErrUserDesc,:DisErrUser,:DisErrUserDesc,:ErrRelUser,:ErrRelUserDesc,
		:DisAndHandMea,:ProDrgRelInfo,:DrgRelInfoDesc,:PreSuggest,:ErrContent,:TriErrFac,:RepCode,:RepProcess))
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript:更新用药错表误报告
ClassMethod UpdDrgMisuseReport(drgMURepID As %String, drgMURepList As %String) As %String
{
	n (drgMURepID,drgMURepList)
	s RepDate=$p(drgMURepList,"^",1)    //报告日期
	s:RepDate'="" RepDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(RepDate) ;$zdh(RepDate,3)
	s ErrOccDate=$p(drgMURepList,"^",2) //错误发生日期
	s:ErrOccDate'="" ErrOccDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(ErrOccDate) ;$zdh(ErrOccDate,3)
	s DisErrDate=$p(drgMURepList,"^",3) //发现错误日期
	s:DisErrDate'="" DisErrDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(DisErrDate) ;$zdh(DisErrDate,3)
	s DspToPat=$p(drgMURepList,"^",4)   //是否发药
	s PatTaked=$p(drgMURepList,"^",5)   //是否用药
	s ErrorLevel=$p(drgMURepList,"^",6) //错误级别
	s PatID=$p(drgMURepList,"^",7)      //病人ID
	s PatName=$p(drgMURepList,"^",8)    //姓名
	s PatSex=$p(drgMURepList,"^",9)     //性别
	s PatAge=$p(drgMURepList,"^",10)    //年龄
	s PatDOB=$p(drgMURepList,"^",11)    //出生日期
	s:PatDOB'="" PatDOB=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(PatDOB) ;$zdh(PatDOB,3)
	s PatWeight=$p(drgMURepList,"^",12)  //体重
	s PatContact=$p(drgMURepList,"^",13) //联系方式
	s PatMedNo=$p(drgMURepList,"^",14)   //住院号/门诊就诊号
	s ICDDesc=$p(drgMURepList,"^",15)    //诊断
	s HarmRet=$p(drgMURepList,"^",16)    //伤害结果
	s HarmRetDesc=$p(drgMURepList,"^",17) //伤害结果描述
	s DeathDate=$p(drgMURepList,"^",18) //死亡日期
	s:DeathDate'="" DeathDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(DeathDate) ;$zdh(DeathDate,3)
	s DeathTime=$p(drgMURepList,"^",19) //死亡时间
	S:DeathTime'="" DeathTime=$zth(DeathTime,1)
	s Rescue=$p(drgMURepList,"^",20)      //是否抢救
	s ResMeasDesc=$p(drgMURepList,"^",21) //抢救措施
	s RecProc=$p(drgMURepList,"^",22)     //恢复过程
	s RepUser=$p(drgMURepList,"^",23)     //报告人
	s DeptOfRepUser=$p(drgMURepList,"^",24) //报告人科室
	s ProTitle=$p(drgMURepList,"^",25)      //报告人职称
	s TelOfRepUser=$p(drgMURepList,"^",26)  //报告人电话
	s Email=$p(drgMURepList,"^",27)         //Email
	s PostCode=$p(drgMURepList,"^",28)      //邮编
	s ErrHappSite=$p(drgMURepList,"^",29)   //错误发生场所
	s ErrHappSiteDesc=$p(drgMURepList,"^",30)   //错误发生场所描述
	s TriErrUser=$p(drgMURepList,"^",31)     //引发错误人员职称
	s TriErrUserDesc=$p(drgMURepList,"^",32) //引发错误人员职称描述
	s DisErrUser=$p(drgMURepList,"^",33)     //发现错误人员职称
	s DisErrUserDesc=$p(drgMURepList,"^",34) //发现错误人员职称描述
	s ErrRelUser=$p(drgMURepList,"^",35)     //错误相关人员职称
	s ErrRelUserDesc=$p(drgMURepList,"^",36) //错误相关人员职称描述
	s DisAndHandMea=$p(drgMURepList,"^",37)  //发现和处理措施
	s ProDrgRelInfo=$p(drgMURepList,"^",38)  //能否提供相关资料
	s DrgRelInfoDesc=$p(drgMURepList,"^",39) //相关信息描述
	s PreSuggest=$p(drgMURepList,"^",40) //预防建议
	s ErrContent=$p(drgMURepList,"^",41) //错误内容
	s TriErrFac=$p(drgMURepList,"^",42)  //诱发因素
	s RepCode=$p(drgMURepList,"^",43)    //编码
	s RepProcess=$p(drgMURepList,"^",44)    //错误发生经过

	&SQL(Update DHC_PHDrgMisReport Set DMR_RepDate=:RepDate,DMR_ErrOccDate=:ErrOccDate,DMR_DisErrDate=:DisErrDate,DMR_DspToPat=:DspToPat,DMR_PatTaked=:PatTaked,DMR_ErrorLevel=:ErrorLevel,DMR_PatID=:PatID,
		DMR_PatName=:PatName,DMR_PatSex=:PatSex,DMR_PatAge=:PatAge,DMR_PatDOB=:PatDOB,DMR_PatWeight=:PatWeight,DMR_PatContact=:PatContact,DMR_PatMedNo=:PatMedNo,DMR_ICDDesc=:ICDDesc,DMR_HarmRet=:HarmRet,DMR_HarmRetDesc=:HarmRetDesc,
		DMR_DeathDate=:DeathDate,DMR_DeathTime=:DeathTime,DMR_Rescue=:Rescue,DMR_ResMeasDesc=:ResMeasDesc,DMR_RecProc=:RecProc,DMR_RepUser=:RepUser,DMR_DeptOfReporter=:DeptOfRepUser,DMR_ProTitleOfReporter=:ProTitle,DMR_TelOfReporter=:TelOfRepUser,
		DMR_EmailOfReporter=:Email,DMR_PostCode=:PostCode,DMR_ErrHappSite=:ErrHappSite,DMR_ErrHappSiteDesc=:ErrHappSiteDesc,DMR_TriErrUser=:TriErrUser,DMR_TriErrUserDesc=:TriErrUserDesc,DMR_DisErrUser=:DisErrUser,DMR_DisErrUserDesc=:DisErrUserDesc,DMR_ErrRelUser=:ErrRelUser,
		DMR_ErrRelUserDesc=:ErrRelUserDesc,DMR_DisAndHandMea=:DisAndHandMea,DMR_ProDrgRelInfo=:ProDrgRelInfo,DMR_DrgRelInfoDesc=:DrgRelInfoDesc,DMR_PreSuggest=:PreSuggest,DMR_ErrContent=:ErrContent,DMR_TriErrFac=:TriErrFac,DMR_RepCode=:RepCode,DMR_ErrHappProcess=:RepProcess WHERE DMR_RowID=:drgMURepID)
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Descript:保存用药错误相关药品信息
ClassMethod InsDrgMisRepDrgItm(drgMURepID As %String, dqEvtRepDrgItmList As %String) As %String
{
	N (drgMURepID,dqEvtRepDrgItmList)
	S Len=$L(dqEvtRepDrgItmList,"!!")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S tmpStr=$p(dqEvtRepDrgItmList,"!!",i)
	.S oeori=$p(tmpStr,"^",1)      //医嘱ID
	.S phcddr=$p(tmpStr,"^",2)     //药学项ID
	.S goodsname=$p(tmpStr,"^",3)  //商品名
	.S genericdr=$p(tmpStr,"^",4)  //通用名
	.S phformdr=$p(tmpStr,"^",5)   //剂型
	.S dosage=$p(tmpStr,"^",6)     //剂量
	.S dosuomdr=$p(tmpStr,"^",7)   //剂量单位
	.S instrucdr=$p(tmpStr,"^",8)  //用法
	.S freqdr=$p(tmpStr,"^",9)     //频次
	.S manfdr=$p(tmpStr,"^",10)    //厂家
	.S drgcat=$p(tmpStr,"^",11)    //药品分类
	.S spec=$p(tmpStr,"^",12)      //规格
	.S packtype=$p(tmpStr,"^",13)  //包装类型
	.
	.S childSub=$o(^DHCPHDMR(drgMURepID,"DMRDI",""),-1)+1
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
	i $o(^DHCPHDMR(drgMURepID,"DMRDI","")) d
	.&SQL(DELETE DHC_PHDrgMisRepDrgItm WHERE DMRDI_DMR_Parref=:drgMURepID)
	Q +$g(SQLCODE)
}

/// Descript:用药错误报告
/// w ##class(web.DHCSTPHCMDRGMISUSEREPORT).QueryDrgMisuseReport("40","1","2016-09-17^2016-09-19^^")
ClassMethod QueryDrgMisuseReport(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S pid=..NewPid()
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S StDate=$p(params,"^",1)   //开始日期
	S EndDate=$p(params,"^",2)   //结束日期
	S LocID=$p(params,"^",3)    //科室ID
	S PatNo=$p(params,"^",4)    //登记号
	s Status=$p(params,"^",5)   //状态 -liyarong 2016-9-20
	d ..killTmpGlobal(pid)
	
	S StDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StDate) ;$zdh(StDate,3)
	S EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate) ;$zdh(EndDate,3)
	S QuitFlag=0
	S Num=0
	F dd=StDate:1:EndDate D
	.S dgERepID=""
	.F  S dgERepID=$o(^DHCPHDMR(0,"RepDate",dd,dgERepID)) Q:dgERepID=""  D
	..S dgERepLoc=$p(^DHCPHDMR(dgERepID),"^",24)  //报告科室
	..Q:(LocID'="")&(dgERepLoc'=LocID)
	..S:dgERepLoc'="" dgERepLoc=$p(^CTLOC(dgERepLoc),"^",2)
	..S dgERepDate=$p(^DHCPHDMR(dgERepID),"^",1)  //日期
	..I dgERepDate'="" S dgERepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dgERepDate) ;$zd(dgERepDate,3)
	..S dgEPatID=$p(^DHCPHDMR(dgERepID),"^",7)     //病人ID
	..S dgEPatName=$p(^DHCPHDMR(dgERepID),"^",8)   //病人姓名
	..S dgEPatMedNo=$p(^DHCPHDMR(dgERepID),"^",14) //病历号/门诊号
	..S dgEReporter=$p(^DHCPHDMR(dgERepID),"^",23) //报告人
	..i dgEReporter'="" s dgEReporter=$p(^SSU("SSUSR",dgEReporter),"^",2)
	..//S:dgEReporter'="" dgEReporter=$p($g(^SSU("SSUSR",dgEReporter)),"^",2)
	..S dmRepCode=$p(^DHCPHDMR(dgERepID),"^",43)  //编码
	..S AdrPatNo="",InMedicare=""
	..I dgEPatID'="" d
	...S dgEPatNo=$p(^PAPER(dgEPatID,"PAT",1),"^",1) //登记号
	..Q:(PatNo'="")&(PatNo'=dgEPatNo)
	..I dgERepID'="" d                                //liyarong 2016-09-19
	...S dgERepStatus=$p(^DHCPHDMR(dgERepID),"^",45)  //当前状态  
	..Q:(Status'="")&(Status'=dgERepStatus)
	..i dgERepStatus="Y" s dgERepStatus="提交"
	..i dgERepStatus="N" s dgERepStatus="未提交"
	..S ListData=dgERepID_"^"_$g(dgEPatNo)_"^"_dgEPatName_"^"_dgERepStatus_"^"_dgERepLoc_"^"_dgEReporter_"^"_dgERepDate_"^"_dmRepCode
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMDRGMISUSEREPORT","QueryDrgMisuseReport",pid,Num)=ListData
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMDRGMISUSEREPORT","QueryDrgMisuseReport",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMDRGMISUSEREPORT","QueryDrgMisuseReport",pid,index)
	.S Title="dgERepID^dgEPatNo^dgEPatName^dgERepStatus^dgERepLoc^dgEReporter^dgERepDate^dmRepCode"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:用药错误报告药品信息
ClassMethod getDrgMisuseRepDrgItm(drgMURepID As %String) As %String
{
	n (drgMURepID)
	s pid=..NewPid()
	d ..killTmpGlobal(pid)

	s Num=0
	s ch=""
	f  s ch=$o(^DHCPHDMR(drgMURepID,"DMRDI",ch)) q:ch=""  d
	.s oeori=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",1) //医嘱ID
	.s phcddr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",2) //药学项ID
	.s goodsname=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",3) //商品名
	.s genericdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",4) //通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.s formdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",5) //剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.s dosage=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",6) //剂量
	.s dosageuomdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",7) //剂量单位
	.i dosageuomdr'="" S doseuom=$p($g(^CT("UOM",dosageuomdr)),"^",2)
	.s instrucdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",8) //用法
	.i formdr'="" S instru=$p($g(^PHCIN(instrucdr)),"^",2)
	.s freqdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",9) //频次
	.i freqdr'="" S freq=$p($g(^PHCFR(freqdr)),"^",3)
	.s manfdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",10) //产地
	.s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.s drgcat=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",11) //药品分类
	.s spec=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",12) //规格
	.s packtype=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",13) //包装类型
	.s ListData=oeori_"^"_phcddr_"^"_goodsname_"^"_genericdr_"^"_$g(genenic)_"^"_formdr_"^"_form_"^"_dosage_doseuom_"/"_instru_"/"_freq_"^"_dosageuomdr
	.s ListData=ListData_"^"_manfdr_"^"_$g(manf)_"^"_instrucdr_"^"_freqdr_"^"_drgcat_"^"_spec_"^"_packtype
	.
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCSTPHCMDRGMISUSEREPORT","getDrgMisuseRepDrgItm",pid,Num)=ListData
	
	i 4>Num d
	.S Len=4-Num
	.f i=1:1:Len d
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMDRGMISUSEREPORT","getDrgMisuseRepDrgItm",pid,Num)=""
	
	q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	s quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	s Num=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMDRGMISUSEREPORT","getDrgMisuseRepDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.s mdata=^TMP("DHCST","web.DHCSTPHCMDRGMISUSEREPORT","getDrgMisuseRepDrgItm",pid,index)
	.s Title="orditm^phcdf^incidesc^genenicdr^genenic^formdr^form^usemethod^dosuomID^manfdr^manf^instrudr^freqdr^drgclass^spec^packtype"
	.s Num=Num+1
	.//q:Num<StPage
	.//s:Num=EndPage quitflag=1
	.i Num=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:用药错误报告
ClassMethod getDrgMisuseRepInfo(dmRepID As %String) As %String
{
	N (dmRepID)
	Q:'$d(^DHCPHDMR(dmRepID)) ""
	S dmRepDate=$p(^DHCPHDMR(dmRepID),"^",1) //报告日期
	S:dmRepDate'="" dmRepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepDate) ;$zd(dmRepDate,3)
	S dmRepOccDate=$p(^DHCPHDMR(dmRepID),"^",2)  //错误发生日期 
	S:dmRepOccDate'="" dmRepOccDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepOccDate) ;$zd(dmRepOccDate,3)
	S dmRepDisDate=$p(^DHCPHDMR(dmRepID),"^",2)  //发现错误日期
	S:dmRepDisDate'="" dmRepDisDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepDisDate) ;$zd(dmRepDisDate,3)
	S dmRepDspToPat=$p(^DHCPHDMR(dmRepID),"^",4) //是否发放给患者
	S dmRepPatTaked=$p(^DHCPHDMR(dmRepID),"^",5) //患者是否使用
	S dmRepLevel=$p(^DHCPHDMR(dmRepID),"^",6) //伤害级别
	S dmRepPatID=$p(^DHCPHDMR(dmRepID),"^",7)   //病人ID
	S dmRepPaAdm=$o(^PAPERdr(dmRepPatID,"ADM","I",""),-1)
	S dmRepPatName=$p(^DHCPHDMR(dmRepID),"^",8) //姓名
	S dmRepPatSex=$p(^DHCPHDMR(dmRepID),"^",9)  //性别
	S dmRepPatAge=$p(^DHCPHDMR(dmRepID),"^",10)  //年龄
	S dmRepPatDOB=$p(^DHCPHDMR(dmRepID),"^",11)  //出生日期
	S:dmRepPatDOB'="" dmRepPatDOB=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepPatDOB) ;$zd(dmRepPatDOB,3)
	S dmRepPatWeight=$p(^DHCPHDMR(dmRepID),"^",12)  //体重
	S dmRepPatContact=$p(^DHCPHDMR(dmRepID),"^",13)  //联系方式
	S dmRepPatMedNo=$p(^DHCPHDMR(dmRepID),"^",14) //就诊号
	S dmRepPatICDDesc=$p(^DHCPHDMR(dmRepID),"^",15) //诊断
	S dmRepHarmRet=$p(^DHCPHDMR(dmRepID),"^",16) //伤害结果
	S dmRepHarmRetDesc=$p(^DHCPHDMR(dmRepID),"^",17) //伤害描述
	S dmRepDeathDate=$p(^DHCPHDMR(dmRepID),"^",18) //死亡日期
	S:dmRepDeathDate'="" dmRepDeathDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepDeathDate) ;$zd(dmRepDeathDate,3)
	S dmRepDeathTime=$p(^DHCPHDMR(dmRepID),"^",19) //死亡时间
	S:dmRepDeathTime'="" dmRepDeathTime=$zt(dmRepDeathTime,1)
	S dmRepRescue=$p(^DHCPHDMR(dmRepID),"^",20) //是否抢救
	S dmRepResMeasDesc=$p(^DHCPHDMR(dmRepID),"^",21) //抢救措施
	S dmRepRecProc=$p(^DHCPHDMR(dmRepID),"^",22) //恢复过程
	S dmRepUser="",dmRepUserID=""
	S dmRepUser=$p(^DHCPHDMR(dmRepID),"^",23) //报告人
	//S dmRepUserID=$p(^DHCPHDMR(dmRepID),"^",23) //报告人
	//S:dmRepUserID'="" dmRepUser=$p($g(^SSU("SSUSR",dmRepUserID)),"^",2)
	S dmRepDept=""
	S dmRepDeptID=$p(^DHCPHDMR(dmRepID),"^",24) //报告科室
	S:dmRepDeptID'="" dmRepDept=$p(^CTLOC(dmRepDeptID),"^",2)
	S dmRepProTitle=$p(^DHCPHDMR(dmRepID),"^",25) //报告人职称
	S dmRepTel=$p(^DHCPHDMR(dmRepID),"^",26) //电话
	S dmRepEmail=$p(^DHCPHDMR(dmRepID),"^",27) //E-mail
	S dmRepPostCode=$p(^DHCPHDMR(dmRepID),"^",28) //邮编
	S dmRepHappSite=$p(^DHCPHDMR(dmRepID),"^",29)    //发生位置
	S dmRepHappSiteDesc=$p(^DHCPHDMR(dmRepID),"^",30) //发生位置描述
	S dmRepTriErrUser=$p(^DHCPHDMR(dmRepID),"^",31) //引起错误的人员
	S dmRepTriErrUserDesc=$p(^DHCPHDMR(dmRepID),"^",32) //引起错误的人员描述
	S dmRepDisErrUser=$p(^DHCPHDMR(dmRepID),"^",33) //发错错误人员
	S dmRepDisErrUserDesc=$p(^DHCPHDMR(dmRepID),"^",34) //发错错误人员描述
	S dmRepErrRelUser=$p(^DHCPHDMR(dmRepID),"^",35) //错误相关人员
	S dmRepErrRelUserDesc=$p(^DHCPHDMR(dmRepID),"^",36) //错误相关人员描述
	S dmRepDisAndHandleMea=$p(^DHCPHDMR(dmRepID),"^",37) //发现和预防措施
	S dmRepProDrgRelInfo=$p(^DHCPHDMR(dmRepID),"^",38) //是否提供相关信息
	S dmRepDrgRelInfoDesc=$p(^DHCPHDMR(dmRepID),"^",39) //相关信息描述
	S dmRepPreSuggest=$p(^DHCPHDMR(dmRepID),"^",40) //预防意见
	s dmRepErrContent=$p(^DHCPHDMR(dmRepID),"^",41) //错误内容
	s dmRepTriErrFac=$p(^DHCPHDMR(dmRepID),"^",42)  //诱发因素
	s dmRepCode=$p(^DHCPHDMR(dmRepID),"^",43)  //编码
	s dmRepProcess=$p(^DHCPHDMR(dmRepID),"^",44)  //错误发生经过
		
	S adrRepDataList=dmRepID_"!"_dmRepDate_"!"_dmRepOccDate_"!"_dmRepDisDate_"!"_dmRepDspToPat_"!"_dmRepPatTaked_"!"_dmRepLevel_"!"_dmRepPatID_"!"_dmRepPatName_"!"_dmRepPatSex
	S adrRepDataList=adrRepDataList_"!"_dmRepPatAge_"!"_dmRepPatDOB_"!"_dmRepPatWeight_"!"_dmRepPatContact_"!"_dmRepPatMedNo_"!"_dmRepPatICDDesc_"!"_dmRepHarmRet
	S adrRepDataList=adrRepDataList_"!"_dmRepHarmRetDesc_"!"_dmRepDeathDate_"!"_dmRepDeathTime_"!"_dmRepRescue_"!"_dmRepResMeasDesc_"!"_dmRepRecProc_"!"_dmRepUser
	S adrRepDataList=adrRepDataList_"!"_dmRepDept_"!"_dmRepProTitle_"!"_dmRepTel_"!"_dmRepEmail_"!"_dmRepPostCode_"!"_dmRepHappSite_"!"_dmRepHappSiteDesc
	S adrRepDataList=adrRepDataList_"!"_dmRepTriErrUser_"!"_dmRepTriErrUserDesc_"!"_dmRepDisErrUser_"!"_dmRepDisErrUserDesc_"!"_dmRepErrRelUser_"!"_dmRepErrRelUserDesc
	S adrRepDataList=adrRepDataList_"!"_dmRepDisAndHandleMea_"!"_dmRepProDrgRelInfo_"!"_dmRepDrgRelInfoDesc_"!"_dmRepPreSuggest_"!"_dmRepErrContent_"!"_dmRepTriErrFac
	S adrRepDataList=adrRepDataList_"!"_dmRepUserID_"!"_dmRepDeptID_"!"_dmRepPaAdm_"!"_dmRepCode_"!"_dmRepProcess
	
 Q adrRepDataList
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMDRGMISUSEREPORT","QueryDrgMisuseReport",pid)
	k ^TMP("DHCST","web.DHCSTPHCMDRGMISUSEREPORT","getDrgMisuseRepDrgItm",pid)
}

/// Descript:获取病人基本信息
ClassMethod getDMRRepPatInfo(AdmDr As %String, LocID As %String) As %String
{
	N (AdmDr,LocID)
	S papmidr=$p(^PAADM(AdmDr),"^",1)
	S patName=$p(^PAPER(papmidr,"ALL"),"^",1) //姓名
	S patNo=$p(^PAPER(papmidr,"PAT",1),"^",1) //登记号
	S sexId=$p(^PAPER(papmidr,"ALL"),"^",7) //姓别
	S patSex=$p(^CT("SEX",sexId),"^",2)
	S birthday=$p(^PAPER(papmidr,"ALL"),"^",6) //出生日期
	S nationdr=$p(^PAPER(papmidr,"PER",1),"^",2) //民族
	i birthday'="" s birthday=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(birthday) ;$zd(birthday,3)
	S patAge=+##class(web.DHCSTKUTIL).GetAge(papmidr)  //年龄
	S patW=""
	S patTel=""
	S medicalNo=patNo //##Class(web.DHCWMRService).IGetMrNoByEpisodeID(AdmDr) //病案号
	S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(AdmDr,",")
	I LocID'="" D
	.S LocDesc=$p(^CTLOC(LocID),"^",2)
 	.S HospID=$p(^CTLOC(LocID),"^",22)
	.S Hospital=$p(^CT("HOSP",HospID),"^",2)
	.S HospitalCode=$p(^CT("HOSP",HospID),"^",1)
	S AdmLocID=$p(^PAADM(AdmDr),"^",4) //科室
	S:AdmLocID'="" AdmLoc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
	S AdmWardID=$p(^PAADM(AdmDr),"^",70) //病区
	S:AdmWardID'="" AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	S AdmBedID=$p(^PAADM(AdmDr),"^",73) //床号
	S bed=""
	I AdmBedID'="" S bed=$p(^PAWARD($p(AdmBedID,"||",1),"BED",$p(AdmBedID,"||",2)),"^",1)
	S repdate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(+$H) ;$zd(+$H,3)
	S Prefix=HospitalCode_"DMR"_$zd(+$H,8)  //报告编码规则 医院编码+"ADR"+年月日+顺序号
	S AdrReportCode=..GetReportCurMaxNo(Prefix,"3")
	Q papmidr_"^"_patNo_"^"_patName_"^"_sexId_"^"_patSex_"^"_patAge_"^"_birthday_"^"_nationdr_"^"_medicalNo_"^"_patW_"^"_patTel_"^"_PatDiag_"^"_$g(Hospital)_"^"_AdmLoc_"^"_AdmLocID_"^"_repdate_"^"_AdmWard_"^"_AdmWardID_"^"_bed_"^"_$g(LocDesc)_"^"_AdrReportCode
}

/// Creator:    bianshuai
/// CreateDate: 2015-02-03
/// Descript:   取当前编号最大码
ClassMethod GetReportCurMaxNo(Prefix As %String, NoLen As %String) As %String
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

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMDRGMISUSEREPORT"))
}

/// Descript:用药错误报告
ClassMethod getDrgMisRepExportInfo(dmRepID As %String) As %String
{
	N (dmRepID)
	Q:'$d(^DHCPHDMR(dmRepID)) ""
	S dmRepDate=$p(^DHCPHDMR(dmRepID),"^",1) //报告日期
	S:dmRepDate'="" dmRepDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepDate) ;$zd(dmRepDate,3)
	S dmRepOccDate=$p(^DHCPHDMR(dmRepID),"^",2)  //错误发生日期 
	S:dmRepOccDate'="" dmRepOccDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepOccDate) ;$zd(dmRepOccDate,3)
	S dmRepDisDate=$p(^DHCPHDMR(dmRepID),"^",2)  //发现错误日期
	S:dmRepDisDate'="" dmRepDisDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepDisDate) ;$zd(dmRepDisDate,3)
	S dmRepDspToPat=$p(^DHCPHDMR(dmRepID),"^",4) //是否发放给患者
	S dmRepDspToPat=$S(dmRepDspToPat="10":"是",dmRepDspToPat="11":"否",dmRepDspToPat="99":"不详",1:"")
	S dmRepPatTaked=$p(^DHCPHDMR(dmRepID),"^",5) //患者是否使用
	S dmRepPatTaked=$S(dmRepPatTaked="10":"是",dmRepPatTaked="11":"否",dmRepPatTaked="99":"不详",1:"")
	S dmRepLevel=$p(^DHCPHDMR(dmRepID),"^",6)    //伤害级别
	S dmRepLevel=$S(dmRepLevel="10":"A级：客观环境或条件可能引发错误（错误隐患）;",dmRepLevel="11":"B级：发生错误但未发给患者, 或已发给患者但患者未使用;",dmRepLevel="12":"C级：患者已使用，但未造成伤害;",1:dmRepLevel)
	S dmRepLevel=$S(dmRepLevel="13":"D级：患者已使用，需要监测错误对患者的后果，并根据后果判断是否需要采取措施预防和减少伤害;",dmRepLevel="14":"E级：错误造成患者暂时性伤害，需要采取预防措施;",dmRepLevel="15":"F级：错误对患者的伤害可导致住院或延长住院时间;",1:dmRepLevel)
	S dmRepLevel=$S(dmRepLevel="16":"G级：错误导致患者永久性伤害;",dmRepLevel="17":"H级：错误导致患者生命垂危;",dmRepLevel="18":"I级：错误导致患者死亡;",1:dmRepLevel)
	S dmRepPatID=$p(^DHCPHDMR(dmRepID),"^",7)    //病人ID
	S dmRepPaAdm=$o(^PAPERdr(dmRepPatID,"ADM","I",""),-1)
	S dmRepPatName=$p(^DHCPHDMR(dmRepID),"^",8)  //姓名
	S dmRepPatSex=$p(^DHCPHDMR(dmRepID),"^",9)   //性别
	S:dmRepPatSex'="" dmRepPatSex=$p(^CT("SEX",dmRepPatSex),"^",2)
	S dmRepPatAge=$p(^DHCPHDMR(dmRepID),"^",10)  //年龄
	S dmRepPatDOB=$p(^DHCPHDMR(dmRepID),"^",11)  //出生日期
	S:dmRepPatDOB'="" dmRepPatDOB=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepPatDOB) ;$zd(dmRepPatDOB,3)
	S dmRepPatWeight=$p(^DHCPHDMR(dmRepID),"^",12)   //体重
	S dmRepPatContact=$p(^DHCPHDMR(dmRepID),"^",13)  //联系方式
	S dmRepPatMedNo=$p(^DHCPHDMR(dmRepID),"^",14)    //就诊号
	S dmRepPatICDDesc=$p(^DHCPHDMR(dmRepID),"^",15)  //诊断
	S dmRepHarmRet=$p(^DHCPHDMR(dmRepID),"^",16)     //伤害结果
	S dmRepHarmRet=$S(dmRepHarmRet="10":"无明显伤害",dmRepHarmRet="11":"暂时伤害",dmRepHarmRet="12":"残疾",dmRepHarmRet="13":"死亡",1:"")
	S dmRepHarmRetDesc=$p(^DHCPHDMR(dmRepID),"^",17) //伤害描述
	S dmRepDeathDate=$p(^DHCPHDMR(dmRepID),"^",18)   //死亡日期
	S:dmRepDeathDate'="" dmRepDeathDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(dmRepDeathDate) ;$zd(dmRepDeathDate,3)
	S dmRepDeathTime=$p(^DHCPHDMR(dmRepID),"^",19)   //死亡时间
	S:dmRepDeathTime'="" dmRepDeathTime=$zt(dmRepDeathTime,1)
	S dmRepRescue=$p(^DHCPHDMR(dmRepID),"^",20)      //是否抢救
	S dmRepRescue=$S(dmRepRescue="Y":"是",1:"")
	S dmRepResMeasDesc=$p(^DHCPHDMR(dmRepID),"^",21) //抢救措施
	S dmRepRecProc=$p(^DHCPHDMR(dmRepID),"^",22)     //恢复过程
	S dmRepRecProc=$S(dmRepRecProc="10":"住院治疗",dmRepRecProc="11":"门诊随访治疗",dmRepRecProc="12":"自行恢复",1:"")
	S dmRepUser="",dmRepUserID=""
	S dmRepUser=$p(^DHCPHDMR(dmRepID),"^",23) 		 //报告人
	S dmRepUserID=$p(^DHCPHDMR(dmRepID),"^",23)		 //报告人
	S:dmRepUserID'="" dmRepUser=$p($g(^SSU("SSUSR",dmRepUserID)),"^",2)
	S dmRepDept=""
	S dmRepDeptID=$p(^DHCPHDMR(dmRepID),"^",24) 	 //报告科室
	S:dmRepDeptID'="" dmRepDept=$p(^CTLOC(dmRepDeptID),"^",2)
	S dmRepProTitle=""
	S dmRepCarTpID=$p(^DHCPHDMR(dmRepID),"^",25)       //报告人职称
	i dmRepCarTpID'="" D
	.S dmRepProTitle=$p($g(^CT("CPT",dmRepCarTpID)),"^",2)
	S dmRepTel=$p(^DHCPHDMR(dmRepID),"^",26)            //电话
	S dmRepEmail=$p(^DHCPHDMR(dmRepID),"^",27)          //E-mail
	S dmRepPostCode=$p(^DHCPHDMR(dmRepID),"^",28)       //邮编
	S dmRepHappSite=$p(^DHCPHDMR(dmRepID),"^",29)       //发生位置
	S dmRepHappSite=..getdmRepErrRelUser(dmRepHappSite,"Site")
	S dmRepHappSiteDesc=$p(^DHCPHDMR(dmRepID),"^",30)   //发生位置描述
	S dmRepTriErrUser=$p(^DHCPHDMR(dmRepID),"^",31)     //引起错误的人员
	S dmRepTriErrUser=..getdmRepErrRelUser(dmRepTriErrUser,"User")
	S dmRepTriErrUserDesc=$p(^DHCPHDMR(dmRepID),"^",32) //引起错误的人员描述
	S dmRepDisErrUser=$p(^DHCPHDMR(dmRepID),"^",33)     //发错错误人员
	S dmRepDisErrUser=$S(dmRepDisErrUser="10":"医生",dmRepDisErrUser="11":"药师 ",dmRepDisErrUser="12":"护士",dmRepDisErrUser="13":"患者及家属",1:"")
	S dmRepDisErrUserDesc=$p(^DHCPHDMR(dmRepID),"^",34) //发错错误人员描述
	S dmRepErrRelUser=$p(^DHCPHDMR(dmRepID),"^",35)     //错误相关人员
	S dmRepErrRelUser=$S(dmRepErrRelUser="10":"医生",dmRepErrRelUser="11":"药师 ",dmRepErrRelUser="12":"护士",dmRepErrRelUser="13":"患者及家属",1:"")
	S dmRepErrRelUserDesc=$p(^DHCPHDMR(dmRepID),"^",36)  //错误相关人员描述
	S dmRepDisAndHandleMea=$p(^DHCPHDMR(dmRepID),"^",37) //发现和预防措施
	S dmRepProDrgRelInfo=$p(^DHCPHDMR(dmRepID),"^",38)   //是否提供相关信息
	S dmRepProDrgRelInfo=$S(dmRepProDrgRelInfo="10":"是",dmRepProDrgRelInfo="11":"否",1:"")
	S dmRepDrgRelInfoDesc=$p(^DHCPHDMR(dmRepID),"^",39)  //相关信息描述
	S dmRepPreSuggest=$p(^DHCPHDMR(dmRepID),"^",40) 	 //预防意见
	S dmRepErrContent=$p(^DHCPHDMR(dmRepID),"^",41) 	 //错误内容
	S dmRepErrContent=..getdmRepErrRelUser(dmRepErrContent,"ErrCon")
	S dmRepTriErrFac=$p(^DHCPHDMR(dmRepID),"^",42)  	 //诱发因素
	S dmRepTriErrFac=..getdmRepErrRelUser(dmRepTriErrFac,"TriFac")
	S dmRepCode=$p(^DHCPHDMR(dmRepID),"^",43)  			 //编码
	
	S dmRepDrgItm=..getExportDrgMisuseRepDrgItm(dmRepID)
		
	S adrRepDataList=dmRepID_"&&"_dmRepDate_"&&"_dmRepOccDate_"&&"_dmRepDisDate_"&&"_dmRepDspToPat_"&&"_dmRepPatTaked_"&&"_dmRepLevel_"&&"_dmRepPatID_"&&"_dmRepPatName_"&&"_dmRepPatSex
	S adrRepDataList=adrRepDataList_"&&"_dmRepPatAge_"&&"_dmRepPatDOB_"&&"_dmRepPatWeight_"&&"_dmRepPatContact_"&&"_dmRepPatMedNo_"&&"_dmRepPatICDDesc_"&&"_dmRepHarmRet
	S adrRepDataList=adrRepDataList_"&&"_dmRepHarmRetDesc_"&&"_dmRepDeathDate_"&&"_dmRepDeathTime_"&&"_dmRepRescue_"&&"_dmRepResMeasDesc_"&&"_dmRepRecProc_"&&"_dmRepUser
	S adrRepDataList=adrRepDataList_"&&"_dmRepDept_"&&"_dmRepProTitle_"&&"_dmRepTel_"&&"_dmRepEmail_"&&"_dmRepPostCode_"&&"_dmRepHappSite_"&&"_dmRepHappSiteDesc
	S adrRepDataList=adrRepDataList_"&&"_dmRepTriErrUser_"&&"_dmRepTriErrUserDesc_"&&"_dmRepDisErrUser_"&&"_dmRepDisErrUserDesc_"&&"_dmRepErrRelUser_"&&"_dmRepErrRelUserDesc
	S adrRepDataList=adrRepDataList_"&&"_dmRepDisAndHandleMea_"&&"_dmRepProDrgRelInfo_"&&"_dmRepDrgRelInfoDesc_"&&"_dmRepPreSuggest_"&&"_dmRepErrContent_"&&"_dmRepTriErrFac
	S adrRepDataList=adrRepDataList_"&&"_dmRepUserID_"&&"_dmRepDeptID_"&&"_dmRepPaAdm_"&&"_dmRepCode_"&&"_dmRepDrgItm
	
 Q adrRepDataList
}

/// 获取错误相关信息描述
ClassMethod getdmRepErrRelUser(Arg As %String, Type As %String) As %String
{
	N (Arg,Type)
	S dmRepErrRelList=""
	i Type="User" D
	.S dmRepErrRelList=$S(Arg="10":"初级医生",Arg="11":"中级医生",Arg="12":"高级医生",Arg="13":"实习医生",Arg="14":"进修医生",Arg="15":"初级药师",Arg="16":"中级药师",Arg="17":"高级药师",Arg="18":"实习药师",Arg="19":"进修药师",Arg="20":"初级护士",Arg="21":"中级护士",Arg="22":"高级护士",Arg="23":"实习护士",Arg="24":"进修护士",Arg="25":"患者或家属",1:"")

	i Type="Site" D
	.S dmRepErrRelList=$S(Arg="10":"门诊诊室",Arg="11":"病房医生办公室",Arg="12":"门诊药房",Arg="13":"病房药房",Arg="14":"急诊药房",Arg="15":"社区卫生站",1:"")
	
	i Type="TriFac" D
	.S Len=$L(Arg,"||")
	.F i=1:1:Len D
	..S TmpArg=$p(Arg,"||",i)
	..S TmpArg=$S(TmpArg="10":"适应症",TmpArg="11":"品种",TmpArg="12":"禁忌症",TmpArg="13":"剂型",TmpArg="14":"给药途径",TmpArg="15":"给药顺序",TmpArg="16":"漏给药",TmpArg="17":"给药技术",TmpArg="18":"重复给药 ",TmpArg="19":"数量",TmpArg="20":"规格",TmpArg="21":"用量",TmpArg="22":"给药频次",TmpArg="23":"给药时间",TmpArg="24":"疗程",TmpArg="25":"溶媒",TmpArg="26":"配伍",TmpArg="27":"相互作用",1:"")
	..I dmRepErrRelList'="" S dmRepErrRelList=dmRepErrRelList_";"_TmpArg
	..E  S dmRepErrRelList=TmpArg
	.S dmRepErrRelList=dmRepErrRelList_$p(Arg,"#",2)
	
	i Type="ErrCon" D
	.S Len=$L(Arg,"||")
	.F i=1:1:Len D
	..S TmpArg=$p(Arg,"||",i)
	..S TmpArg=$S(TmpArg="10":"适应证",TmpArg="11":"品种",TmpArg="12":"禁忌症",TmpArg="13":"剂型",TmpArg="14":"给药途径",TmpArg="15":"给药顺序",TmpArg="16":"漏给药",TmpArg="17":"给药技术",TmpArg="18":"重复给药",TmpArg="19":"数量",TmpArg="20":"规格",TmpArg="21":"用量",TmpArg="22":"给药频次",TmpArg="23":"给药时间",TmpArg="24":"疗程",TmpArg="25":"溶媒",TmpArg="26":"配伍",TmpArg="27":"相互作用",TmpArg="28":"患者身份",1:"")
	..I dmRepErrRelList'="" S dmRepErrRelList=dmRepErrRelList_";"_TmpArg
	..E  S dmRepErrRelList=TmpArg
	.S dmRepErrRelList=dmRepErrRelList_$p(Arg,"#",2)
	
    Q dmRepErrRelList
}

/// Descript:用药错误报告药品信息
ClassMethod getExportDrgMisuseRepDrgItm(drgMURepID As %String) As %String
{
	n (drgMURepID)

	s adrRepDrgStr=""
	s ch=""
	f  s ch=$o(^DHCPHDMR(drgMURepID,"DMRDI",ch)) q:ch=""  d
	.s oeori=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",1) 		//医嘱ID
	.s phcddr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",2)    	//药学项ID
	.s goodsname=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",3) 	//商品名
	.s genericdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",4) 	//通用名ID
	.i genericdr'="" S genenic=$p($g(^PHCGE("GE",genericdr)),"^",2) //通用名
	.s form=""
	.s formdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",5) 		//剂型
	.i formdr'=""  s form=$p(^PHCF(formdr),"^",2)
	.s dosage=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",6) 	    //剂量
	.i $p(dosage,".")="" s dosage=0_dosage
	.s dosageuomdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",7)   //剂量单位
	.i dosageuomdr'="" S doseuom=$p($g(^CT("UOM",dosageuomdr)),"^",2)
	.s instrucdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",8) 	//用法
	.i formdr'="" S instru=$p($g(^PHCIN(instrucdr)),"^",2)
	.s freqdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",9) 	    //频次
	.i freqdr'="" S freq=$p($g(^PHCFR(freqdr)),"^",3)
	.s manfdr=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",10) 		//产地
	.s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.s drgcat=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",11)		//药品分类
	.s spec=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",12) 		//规格
	.s packtype=$p(^DHCPHDMR(drgMURepID,"DMRDI",ch),"^",13) 	//包装类型
	.s ListData=goodsname_"^"_genericdr_"^"_$g(genenic)_"^"_formdr_"^"_form_"^"_instru_"^"_dosage_doseuom
	.s ListData=ListData_"^"_manfdr_"^"_$g(manf)_"^"_instrucdr_"^"_freqdr_"^"_drgcat_"^"_spec_"^"_packtype
	.
	.i adrRepDrgStr="" S adrRepDrgStr=ListData
	.E  S adrRepDrgStr=adrRepDrgStr_"||"_ListData
	Q adrRepDrgStr
}

}
