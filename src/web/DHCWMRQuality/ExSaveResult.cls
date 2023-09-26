Import SQLUser

Class web.DHCWMRQuality.ExSaveResult Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

/// 保存主动评价结果
/// IniResult=Paadm^ExamRule^SignUser^ExamEntry^INumber^TriggerDate^ErrType^ResumeText^Employee^RSbility^Loc
/// 评价结果=就诊号^质控标准^报告人^质控项目^触发次数^问题日期^问题类型^备注^责任人^责任人类型^责任科室
/// w ##Class(web.DHCWMRQuality.ExSaveResult).SaveIniResult(RID,IniResult)
ClassMethod SaveIniResult(RID, IniResult)
{
	n (RID,IniResult)
	s ret=0
	
	s RVolID=""                           //就诊号对应的卷ID
	s RExamRule=$p(IniResult,"^",2)       //质控标准
	s RVeto=""                            //单项否决
	s RScore=""                           //得分
	s RActualScore=""                     //累计得分
	s RIsPrimary=""                       //是否主要评价
	s RGradeDr=""                         //等级
	s RRemind=""                          //是否需要提醒
	s RMoney=""                           //奖惩金额
	s RSignUser=$p(IniResult,"^",3)       //报告人、评估人
	s:RSignUser="" RSignUser=$o(^SSU("SSUSR",0))
	s RExamDate=+$h                       //评估日期
	s RExamTime=$p($h,",",2)              //评估时间
	s RIsActive="Yes"                     //是否有效
	s RResumeText=""                      //备注
	s RPaadm=$p(IniResult,"^",1)          //就诊号
	s RExamType="F"                       //质控类型
	
	s DExamEntry=$p(IniResult,"^",4)      //评估项目
	s DINumber=$p(IniResult,"^",5)        //触发次数
	s DScore=""                           //得分
	s DMoney=""                           //奖惩金额
	s DTriggerDate=$p(IniResult,"^",6)    //问题日期
	s DErrType=$p(IniResult,"^",7)        //问题类型
	s DIsActive="Yes"                     //是否有效
	s DResumeText=$p(IniResult,"^",8)     //备注
	
	s PEmployee=$p(IniResult,"^",9)       //责任人
	s PRSbility=$p(IniResult,"^",10)      //责任人类型
	s PLoc=$p(IniResult,"^",11)           //责任科室
	s PIsActive="Yes"                     //是否有效
	s PResumeText=""                      //备注
	
	q:(RExamRule="")||(RSignUser="")||(RPaadm="") ret
	q:(DExamEntry="")||(DINumber="")||(DTriggerDate="")||(DErrType="") ret
	q:(PEmployee="")||(PRSbility="")||(PLoc="") ret
	
	;根据是否允许多次评分和质控结果判断是否还需要检查此项内容
	s sExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(DExamEntry)
	s MultiErr=$p(sExamEntry,"^",6)
	s MultiFlg=1
	i ((MultiErr'["Y")&&$d(^DHCWMRERST(0,"RuleAdm",RExamRule,RPaadm))) d
	.s RstId=0
	.f  s RstId=$o(^DHCWMRERST(0,"RuleAdm",RExamRule,RPaadm,RstId)) q:RstId=""  d
	..s:$d(^DHCWMRERST(RstId,"0","RstDtlEntryDr",DExamEntry,"Y")) MultiFlg=0
	q:MultiFlg=0 ret
	
	TStart
	
	s ret=-1
	//DHC_WMR_ExamResult 评估结果
	i (+RID)<1 d
	.i RPaadm'="" d
	..//RVolID   就诊号对应的卷ID
	..;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	..s VolRowid=0
	..f  s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",+RPaadm,VolRowid)) q:(VolRowid="")||(RVolID'="")  d
	...s tmpVol=$g(^DHCWMRVOL(+VolRowid))
	...q:tmpVol=""
	...q:$p(tmpVol,"^",7)'="Y"
	...s RVolID=VolRowid
	..//RIsPrimary   是否主要评价
	..;^DHCWMRRERST(0,"PAADM",{PaadmDr},{Rowid})
	..s RRowid=0
	..f  s RRowid=$o(^DHCWMRRERST(0,"PAADM",RPaadm,RRowid)) q:(RRowid="")||(RIsPrimary'="")  d
	...q:($p($g(^DHCWMRERST(+RRowid)),"^",13)'="Y")
	...s RIsPrimary="No"  //对应标准和就诊号已经存在记录,"是否主要评价"为No,否则为Yes
	.e  d
	..q:RVolID=""     //此就诊记录没建病案
	..;^DHCWMRERST(0,"RuleVol",{ExamRuleDr},{VolumeId},{Rowid})
	..s RRowid=0
	..f  s RRowid=$o(^DHCWMRERST(0,"RuleVol",+RExamRule,+RVolID,RRowid)) q:(RRowid="")||(RIsPrimary'="")  d
	...q:($p($g(^DHCWMRERST(+RRowid)),"^",13)'="Y")
	...s RIsPrimary="No"                //对应标准和就诊号已经存在记录,"是否主要评价"为No,否则为Yes
	.s:RIsPrimary'="No" RIsPrimary="Yes"
	.s RInPut=""_"^"_RVolID_"^"_RExamRule_"^"_RVeto_"^"_RScore_"^"_RActualScore_"^"_RIsPrimary_"^"_RGradeDr_"^"_RRemind_"^"_RMoney_"^"_RSignUser_"^"_RExamDate_"^"_RExamTime_"^"_RIsActive_"^"_RResumeText_"^"_RPaadm_"^"_RExamType
	.s RID=##Class(web.DHCWMRExamResultCtl).UpdateExamResult(RInPut)
	.i (+RID)<1 TRollback
	q:(+RID)<1 ret
	
	s ret=-2
	//DHC_WMR_ExamRDtl 评估结果项目内容
	s DID="",DInPut=RID_"^"_""_"^"_DExamEntry_"^"_DINumber_"^"_DScore_"^"_DMoney_"^"_DTriggerDate_"^"_DErrType_"^"_DIsActive_"^"_DResumeText
	s DID=##Class(web.DHCWMRExamResultCtl).UpdateExamRDtl(DInPut)
	i (+DID)<0 TRollback
	q:(+DID)<1 ret
	
	s ret=-3
	//DHC_WMR_ExamRDtlPeople 评估项目
	s PID="",PInPut=DID_"^"_""_"^"_PEmployee_"^"_PRSbility_"^"_PLoc_"^"_PIsActive_"^"_PResumeText
	s PID=##Class(web.DHCWMRExamResultCtl).UpdateExamRDtlPeople(PInPut)
	i (+PID)<0 TRollback
	q:(+PID)<1 ret
	
	TCommit
	s ret=RID
	q ret
}

/// 删除评估结果
/// RstEntryId--评估项目内容ID
/// w ##Class(web.DHCWMRQuality.ExSaveResult).DeleteIniResult("146||1||1")
ClassMethod DeleteIniResult(RstEntryId)
{
	n (RstEntryId)
	s ret=0
	
	s RstRowid=$p(RstEntryId,"||",1)
	s RstDtlSub=$p(RstEntryId,"||",2)
	s RstDtlPSub=$p(RstEntryId,"||",3)
	
	TStart
	
	//评估项目内容
	s tmpRstDtlP=$g(^DHCWMRERST(RstRowid,"D",RstDtlSub,"P",RstDtlPSub))
	q:tmpRstDtlP="" ret
	s $p(tmpRstDtlP,"^",4)="N"
	s InPut=RstRowid_"||"_RstDtlSub_"^"_RstDtlPSub_"^"_tmpRstDtlP
	s ret=##Class(web.DHCWMRExamResultCtl).UpdateExamRDtlPeople(InPut)
	i (+ret)<0 TRollBack
	q:(+ret)<0 ret
	
	//评估项目
	s Sub=0,Flg=0
	f  s Sub=$o(^DHCWMRERST(RstRowid,"D",RstDtlSub,"P",Sub)) q:(Sub="")||(Flg=1)  d
	.s tmpRstDtlP=$g(^DHCWMRERST(RstRowid,"D",RstDtlSub,"P",Sub))
	.q:tmpRstDtlP=""
	.q:$p(tmpRstDtlP,"^",4)'="Y"
	.s Flg=1
	i Flg=1 TCommit         //评估项目下还有有效评估项目内容,提交事务并退出
	q:Flg=1 1               //返回成功
	s tmpRstDtl=$g(^DHCWMRERST(RstRowid,"D",RstDtlSub))
	q:tmpRstDtl=""
	s $p(tmpRstDtl,"^",7)="N"
	s InPut=RstRowid_"^"_RstDtlSub_"^"_tmpRstDtl
	s ret=##Class(web.DHCWMRExamResultCtl).UpdateExamRDtl(InPut)
	i (+ret)<0 TRollBack
	q:(+ret)<0 ret
	
	//评估结果
	s Sub=0,Flg=0
	f  s Sub=$o(^DHCWMRERST(RstRowid,"D",Sub)) q:(Sub="")||(Flg=1)  d
	.s tmpRstDtl=$g(^DHCWMRERST(RstRowid,"D",Sub))
	.q:tmpRstDtl=""
	.q:$p(tmpRstDtlP,"^",7)'="Y"
	.s Flg=1
	i Flg=1 TCommit         //评估结果下还有有效评估项目,提交事务并退出
	q:Flg=1 1               //返回成功
	s tmpRst=$g(^DHCWMRERST(RstRowid))
	q:tmpRst=""
	s $p(tmpRst,"^",13)="N"
	s InPut=RstRowid_"^"_tmpRst
	s ret=##Class(web.DHCWMRExamResultCtl).UpdateExamResult(InPut)
	i (+ret)<0 TRollBack
	q:(+ret)<0 ret
	
	TCommit
	s ret=1
	q ret
}

/// 保存自动评价结果
/// AutoResult=Paadm^ExamRule^ExamEntry^ExamDate
/// 评价结果=就诊号^质控标准^质控项目^报告日期
/// w ##Class(web.DHCWMRQuality.ExSaveResult).SaveAutoResult(RID,AutoResult)
ClassMethod SaveAutoResult(RID, AutoResult)
{
	n (RID,AutoResult)
	s ret=0
	
	s RVolID=""                           //就诊号对应的卷ID  通过Paadm取RVolID
	s RExamRule=$p(AutoResult,"^",2)      //质控标准
	s RVeto=""                            //单项否决
	s RScore=""                           //得分
	s RActualScore=""                     //累计得分
	s RIsPrimary=""                       //是否主要评价  通过已保存记录判断
	s RGradeDr=""                         //等级
	s RRemind=""                          //是否需要提醒
	s RMoney=""                           //奖惩金额
	s RSignUser=""                        //报告人、评估人
	s:RSignUser="" RSignUser=$o(^SSU("SSUSR",0))
	s RExamDate=$p(AutoResult,"^",4)      //评估日期
	s:RExamDate["-" RExamDate=$zdh(RExamDate,3)
	s:RExamDate["/" RExamDate=$zdh(RExamDate,4)
	s:RExamDate="" RExamDate=+$h
	s RExamDate=+RExamDate
	s RExamTime=$p($h,",",2)              //评估时间
	s RIsActive="Yes"                     //是否有效
	s RResumeText=""                      //备注
	s RPaadm=$p(AutoResult,"^",1)         //就诊号
	s RExamType="M"                       //质控类型
	
	s DExamEntry=$p(AutoResult,"^",3)     //评估项目
	s DINumber=1                          //触发次数
	s DScore=""                           //得分
	s DMoney=""                           //奖惩金额
	s DTriggerDate=RExamDate              //问题日期
	s DErrType=""                         //问题类型
	s DIsActive="Yes"                     //是否有效
	s DResumeText=""                      //备注
	
	s PEmployee=""                        //责任人   通过就诊取主管医生对应的SS_User表用户ID
	s PRSbility=""                        //责任人类型
	s PLoc=""                             //责任科室    通过就诊取就诊科室
	s PIsActive="Yes"                     //是否有效
	s PResumeText=""                      //备注
	
	q:(RExamRule="")||(RPaadm="") ret
	q:(DExamEntry="")||(DTriggerDate="") ret
	
	TStart
	
	s ret=-1
	//DHC_WMR_ExamResult 评估结果
	i (+RID)<1 d 
	.;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	.s VolRowid=0
	.f  s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",+RPaadm,VolRowid)) q:(VolRowid="")||(RVolID'="")  d
	..s tmpVol=$g(^DHCWMRVOL(+VolRowid))
	..q:tmpVol=""
	..q:$p(tmpVol,"^",7)'="Y"
	..s RVolID=VolRowid               //就诊号对应的卷ID
	.;^DHCWMRERST(0,"RuleVol",{ExamRuleDr},{VolumeId},{Rowid})
	.s RRowid=0
	.f  s RRowid=$o(^DHCWMRERST(0,"RuleVol",+RExamRule,+RVolID,RRowid)) q:(RRowid="")||(RIsPrimary'="")  d
	..q:($p($g(^DHCWMRERST(+RRowid)),"^",13)'="Y")
	..s RIsPrimary="No"                //对应标准和就诊号已经存在记录,"是否主要评价"为No,否则为Yes
	.s:RIsPrimary'="No" RIsPrimary="Yes"     //是否主要评价
	.s RInPut=""_"^"_RVolID_"^"_RExamRule_"^"_RVeto_"^"_RScore_"^"_RActualScore_"^"_RIsPrimary_"^"_RGradeDr_"^"_RRemind_"^"_RMoney_"^"_RSignUser_"^"_RExamDate_"^"_RExamTime_"^"_RIsActive_"^"_RResumeText_"^"_RPaadm_"^"_RExamType
	.s RID=##Class(web.DHCWMRExamResultCtl).UpdateExamResult(RInPut)
	.i (+RID)<1 TRollback
	q:(+RID)<1 ret
	
	s ret=-2
	//DHC_WMR_ExamRDtl 评估结果项目内容
	s DErrType=$o(^DHCWMRDIC(0,"DicName","ErrorType","Y",0))   //问题类型
	s DID="",DInPut=RID_"^"_""_"^"_DExamEntry_"^"_DINumber_"^"_DScore_"^"_DMoney_"^"_DTriggerDate_"^"_DErrType_"^"_DIsActive_"^"_DResumeText
	s DID=##Class(web.DHCWMRExamResultCtl).UpdateExamRDtl(DInPut)
	i (+DID)<0 TRollback
	q:(+DID)<1 ret
	
	s ret=-3
	//DHC_WMR_ExamRDtlPeople 评估项目
	s tmpPaadm=$g(^PAADM(+RPaadm))
	s Doc=$p(tmpPaadm,"^",9)
	;^SSU("SSUSR",0,"CTPCP",{SSUSR_CareProv_DR},{SSUSR_RowId})
	s PEmployee=$o(^SSU("SSUSR",0,"CTPCP",+Doc,0))          //责任人
	s:PEmployee="" PEmployee=$o(^SSU("SSUSR",0))
	s PRSbility=$o(^DHCWMRDIC(0,"DicName","Responsibility","Y",0))   //责任人类型
	s PLoc=$p(tmpPaadm,"^",4)                              //责任科室
	s PID="",PInPut=DID_"^"_""_"^"_PEmployee_"^"_PRSbility_"^"_PLoc_"^"_PIsActive_"^"_PResumeText
	s PID=##Class(web.DHCWMRExamResultCtl).UpdateExamRDtlPeople(PInPut)
	i (+PID)<0 TRollback
	q:(+PID)<1 ret
	
	TCommit
	s ret=RID
	q ret
}

}
