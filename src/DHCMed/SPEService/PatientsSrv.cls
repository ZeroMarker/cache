/// ClassName:    DHCMed.SPEService.PatientsSrv
/// Description:  特殊患者记录 相关操作
/// Creator：     zhufei
/// CreatDate:    2014-07-24
Class DHCMed.SPEService.PatientsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-10-31
/// Description:  取病人基本信息
/// Table：       Pa_PatMas、Pa_Adm
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String "^"分隔
/// w ##class(DHCMed.SPEService.PatientsSrv).GetPatInfoByAdm(12)
ClassMethod GetPatInfoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	Set LocID=$p($g(^PAADM(aEpisodeID)),"^",4),LocDesc=""
	Set:LocID'="" LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	Set DocID=$p($g(^PAADM(aEpisodeID)),"^",9),DocDesc=""
	Set:DocID'="" DocDesc=$p($g(^CTPCP(DocID,1)),"^",2)
	Set RegNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	Set:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,AdmDate,AdmTime)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	//Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,"","")	//返回值为“*岁*月*天”
	
	Set $p(return,"^",1)=aEpisodeID
	Set $p(return,"^",2)=PatientID
	Set $p(return,"^",3)=LocID_$c(1)_LocDesc
	Set $p(return,"^",4)=DocID_$c(1)_DocDesc
	Set $p(return,"^",5)=RegNo
	Set $p(return,"^",6)=PatName
	Set $p(return,"^",7)=Sex
	Set $p(return,"^",8)=Age
	Set $p(return,"^",9)=AdmDate
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-10-31
/// Description:  取特殊患者内容
/// Table：       DHCMed.SPE.Patients
/// Input：       aSepID     : 特殊患者ID
/// Return：      返回String "^"分隔
/// w ##class(DHCMed.SPEService.PatientsSrv).GetSepInfoByID(5)
ClassMethod GetSepInfoByID(aSepID As %String) As %String
{
	New (aSepID)
	Set return=""
	Quit:aSepID="" return
	
	Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(aSepID)
	Quit:'$IsObject(objSpe) return
	Quit:'$IsObject(objSpe.PSPatTypeDr) return
	Quit:'$IsObject(objSpe.PSCurrStatus) return
	
	Set EpisodeID = objSpe.PSEpisodeID
	Set PatTypeSubID = objSpe.PSPatTypeDr.%Id()
	Set PatTypeSubDesc = objSpe.PSPatTypeDr.PTSDesc
	Set PatTypeID = objSpe.PSPatTypeDr.ParRef.%Id()
	Set PatTypeDesc = objSpe.PSPatTypeDr.ParRef.PTDesc
	Set CurrStatusID = objSpe.PSCurrStatus.%Id()
	Set CurrStatusCode = objSpe.PSCurrStatus.Code
	Set CurrStatusDesc = objSpe.PSCurrStatus.Description
	
	Set DutyDeptID = objSpe.PSDutyDept,DutyDeptDesc=""
	Set:DutyDeptID'="" DutyDeptDesc=$p($g(^CTLOC(DutyDeptID)),"^",2)
	Set:$p(DutyDeptDesc,"-",2)'="" DutyDeptDesc=$p(DutyDeptDesc,"-",2)
	Set DutyUserID = objSpe.PSDutyUser,DutyUserDesc=""
	Set:DutyUserID'="" DutyUserDesc=$p($g(^SSU("SSUSR",DutyUserID)),"^",2)
	Set MarkDate = objSpe.PSMarkDate
	Set:MarkDate'="" MarkDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(MarkDate)
	Set MarkTime = objSpe.PSMarkTime
	Set:MarkTime'="" MarkTime=$zt(MarkTime,1)
	Set Note = objSpe.PSNote
	Set Opinion = objSpe.PSOpinion
	Set CheckDate = objSpe.PSCheckDate
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set CheckTime = objSpe.PSCheckTime
	Set:CheckTime'="" CheckTime=$zt(CheckTime,1)
	Set CheckOpinion = objSpe.PSCheckOpinion
	Set FinalDate = objSpe.PSFinalDate
	Set:FinalDate'="" FinalDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FinalDate)
	Set FinalTime = objSpe.PSFinalTime
	Set:FinalTime'="" FinalTime=$zt(FinalTime,1)
	Set PrognosisID="",PrognosisDesc=""
	If $IsObject(objSpe.PSPrognosis){
		Set PrognosisID=objSpe.PSPrognosis.%Id()
		Set PrognosisDesc=objSpe.PSPrognosis.Description
	}
	Set IsCheck=objSpe.PSIsCheck
	Set IsFinal=objSpe.PSIsFinal
	
	Set $p(return,"^",1)=aSepID
	Set $p(return,"^",2)=EpisodeID
	Set $p(return,"^",3)=PatTypeID_$c(1)_PatTypeDesc
	Set $p(return,"^",4)=PatTypeSubID_$c(1)_PatTypeSubDesc
	Set $p(return,"^",5)=CurrStatusID_$c(1)_CurrStatusCode_$c(1)_CurrStatusDesc
	Set $p(return,"^",6)=DutyDeptID_$c(1)_DutyDeptDesc
	Set $p(return,"^",7)=DutyUserID_$c(1)_DutyUserDesc
	Set $p(return,"^",8)=MarkDate_" "_MarkTime
	Set $p(return,"^",9)=Note
	Set $p(return,"^",10)=Opinion
	Set $p(return,"^",11)=CheckDate_" "_CheckTime
	Set $p(return,"^",12)=CheckOpinion
	Set $p(return,"^",13)=FinalDate_" "_FinalTime
	Set $p(return,"^",14)=PrognosisID_$c(1)_PrognosisDesc
	Set $p(return,"^",15)=IsCheck
	Set $p(return,"^",16)=IsFinal
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-07-24
/// Description:  更新特殊患者标记内容
/// Table：       DHCMed.SPE.Patients
/// Input：       aInputStr     : 特殊患者标记内容
/// Return：      return>0:成功  return<1:失败
/// w ##class(DHCMed.SPEService.PatientsSrv).SaveSpeOper("4^15^2||2^117^9^^^2015-11-03^16:33:40^2^^^^^^^9")
ClassMethod SaveSpeOper(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set $ZT="SaveSpeOperErr"
	
	Set SpeID        = $p(aInputStr,"^",1)
	Set EpisodeID    = $p(aInputStr,"^",2)
	Quit:EpisodeID="" return
	Set PatTypeSubID = $p(aInputStr,"^",3)
	Quit:PatTypeSubID="" return
	Set DutyDeptID   = $p(aInputStr,"^",4)
	If DutyDeptID="" {
		Set DutyDeptID=$p(^PAADM(EpisodeID),"^",4)
	}
	Set DutyUserID   = $p(aInputStr,"^",5)
	If DutyUserID="" {
		Set CareProvID=$p(^PAADM(EpisodeID),"^",9)
		Set:CareProvID'="" DutyUserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	}
	Set Note         = $p(aInputStr,"^",6)
	Set Opinion      = $p(aInputStr,"^",7)
	Set MarkDate     = $p(aInputStr,"^",8)
	Set:MarkDate'="" MarkDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(MarkDate)
	Set MarkTime     = $p(aInputStr,"^",9)
	Set:MarkTime[":" MarkTime=$zth(MarkTime,1)
	Set StatusCode   = $p(aInputStr,"^",10)
	Set StatusID     = ""
	Set objStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("SPEStatus",StatusCode,"")
	If $IsObject(objStatus) {
		Set StatusID=objStatus.%Id()
	}
	Quit:StatusID="" return
	Set CheckOpinion = $p(aInputStr,"^",11)
	Set CheckDate    = $p(aInputStr,"^",12)
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CheckDate)
	Set CheckTime    = $p(aInputStr,"^",13)
	Set:CheckTime[":" CheckTime=$zth(CheckTime,1)
	Set PrognosisID  = $p(aInputStr,"^",14)
	Set FinalDate    = $p(aInputStr,"^",15)
	Set:FinalDate'="" FinalDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(FinalDate)
	Set FinalTime    = $p(aInputStr,"^",16)
	Set:FinalTime[":" FinalTime=$zth(FinalTime,1)
	Set UpdateUser   = $p(aInputStr,"^",17)
	Set OperUserType = $p(aInputStr,"^",18) // 1:临床科室 2:管理科
	Quit:UpdateUser="" return
	
	If (StatusCode="1") {
		Set MarkDate=+$h
		Set MarkTime=$p($h,",",2)
	} ElseIf (StatusCode="2") {
		Set CheckDate=+$h
		Set CheckTime=$p($h,",",2)
	} ElseIf (StatusCode="3") {
		Set FinalDate=+$h
		Set FinalTime=$p($h,",",2)
	}
	
	Set objPatType=##class(DHCMed.SPE.PatTypeSub).GetObjById(PatTypeSubID)
	Quit:'$IsObject(objPatType) return
	
	If SpeID="" {
		//标记状态下，自动审核、自动关闭设置处理
		Set IsCheck=0 //objPatType.PTSAutoCheck  //2审核状态
		Set IsFinal=0 //objPatType.PTSAutoClose  //3关闭状态
		
		//add by pylian fix bug 153224 标记时加入判断是否存在相同的有效转态的标记
		Set return="-3^不允许重复标记"  //已存在特殊患者标记，不允许重复标记
		Set StrRecord=..GetRecord(EpisodeID,PatTypeSubID)
		Quit:(StrRecord'=0) return
	} Else {
		Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(SpeID)
		Quit:'$IsObject(objSpe) return
		Set IsCheck=objSpe.PSIsCheck  //是否审核
		Set:objStatus.Code="2" IsCheck=2
		Set IsFinal=objSpe.PSIsFinal  //是否关闭
		Set:objStatus.Code="3" IsFinal=2
	}
	
	TStart
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=SpeID           //ID
	Set $p(InputStr,"^",2)=EpisodeID       //就诊号
	Set $p(InputStr,"^",3)=PatTypeSubID    //特殊患者类型
	Set $p(InputStr,"^",4)=DutyDeptID      //责任科室
	Set $p(InputStr,"^",5)=DutyUserID      //责任人
	Set $p(InputStr,"^",6)=Note            //情况说明
	Set $p(InputStr,"^",7)=Opinion         //初步意见
	Set $p(InputStr,"^",8)=MarkDate        //标记日期
	Set $p(InputStr,"^",9)=MarkTime        //标记时间
	Set $p(InputStr,"^",10)=StatusID       //状态
	Set $p(InputStr,"^",11)=CheckOpinion   //审核意见
	Set $p(InputStr,"^",12)=CheckDate      //审核日期
	Set $p(InputStr,"^",13)=CheckTime      //审核时间
	Set $p(InputStr,"^",14)=PrognosisID    //转归情况
	Set $p(InputStr,"^",15)=FinalDate      //关闭日期
	Set $p(InputStr,"^",16)=FinalTime      //关闭时间
	Set $p(InputStr,"^",17)=+$h            //更新日期
	Set $p(InputStr,"^",18)=$p($h,",",2)   //更新时间
	Set $p(InputStr,"^",19)=UpdateUser     //操作人
	Set $p(InputStr,"^",20)=+IsCheck       //是否审核
	Set $p(InputStr,"^",21)=+IsFinal       //是否关闭
	
	Set return="-1^保存特殊患者记录失败"
	Set flg=##Class(DHCMed.SPE.Patients).Update(InputStr,"^")
	If (+flg<1) TRollback
	Quit:(+flg<1) return
	Set SpeID=flg  //特殊患者记录ID
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=SpeID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=StatusID        //当前状态
	Set $p(InputStr,"^",4)=Opinion         //处置意见
	Set $p(InputStr,"^",5)=+$h             //发生日期
	Set $p(InputStr,"^",6)=$p($h,",",2)    //发生时间
	Set $p(InputStr,"^",7)=UpdateUser      //操作人
	Set $p(InputStr,"^",8)=0		       //消息类型
	Set $p(InputStr,"^",9)=0		       //是否阅读
	Set $p(InputStr,"^",10)=""	           //阅读日期
	Set $p(InputStr,"^",11)=""	           //阅读时间
	Set $p(InputStr,"^",12)=""	           //阅读人
	Set $p(InputStr,"^",13)=1	           //是否有效
	Set $p(InputStr,"^",14)=UpdateUser	   //更新人
	
	Set return="-2^保存特殊患者更新日志失败"
	Set flg=##Class(DHCMed.SPE.PatientsLog).Update(InputStr,"^")
	If (+flg<1) TRollback
	Quit:(+flg<1) return
	
	TCommit
	 //标记、关闭推送消息
	If StatusCode="1"  {//标记	
		Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000038",SpeID,"1",EpisodeID)
	}ElseIf StatusCode="3"{    //关闭  
		Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000038",SpeID,"3",EpisodeID)
	}
	
	//add by mxp 特殊患者标记、关闭，往消息平台发消息
	If (OperUserType=2)&&((StatusCode=1)||(StatusCode=3)) {
		//是否启用消息平台消息发送功能
		Set IsSendMsg=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SS-IsSendMessage","")
		If (+IsSendMsg)=1 {
			Set tmpOpinion="特殊患者"
			Set:StatusCode=1 tmpOpinion="特殊患者标记 类型:"_objPatType.PTSDesc
			Set:StatusCode=3 tmpOpinion="特殊患者关闭 类型:"_objPatType.PTSDesc
			Set LnkJson="{""BizObjId"":"_SpeID_"}"
			Set flg=##class(DHCMed.SSIO.FromHisSrv).SendMsg(tmpOpinion,"1058",UpdateUser,EpisodeID,"",LnkJson)
		}
	}
	
	Set return=SpeID
	
	Quit return
	
SaveSpeOperErr
	Quit -999_"^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2014-07-24
/// Description:  撤销特殊患者操作
/// Table：       DHCMed.SPE.Patients
/// Input：       aInputStr     : 1记录ID，2撤销操作，3原因，4用户
/// Return：      return>0:成功  return<1:失败
/// w ##class(DHCMed.SPEService.PatientsSrv).UpdoSpeOper("6^3^作废特殊患者标记^9")
ClassMethod UpdoSpeOper(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set $ZT="UpdoSpeOperErr"
	
	Set SpeID=$p(aInputStr,"^",1)
	Set OperCode=$p(aInputStr,"^",2)
	Set UpdoOpinion=$p(aInputStr,"^",3)
	Set UpdateUser=$p(aInputStr,"^",4)
	Quit:(SpeID="")||(UpdateUser="") return
	
	Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(SpeID)
	Quit:'$IsObject(objSpe) return
	Quit:'$IsObject(objSpe.PSCurrStatus) return
	Set StatusCode=objSpe.PSCurrStatus.Code
	//Quit:StatusCode'=OperCode return
	Quit:'$IsObject(objSpe.PSPatTypeDr) return
	Set objPatType=objSpe.PSPatTypeDr
	
	Set EpisodeID=objSpe.PSEpisodeID
	Set PatTypeSubID=objPatType.%Id()
	Set DutyDeptID=objSpe.PSDutyDept
	Set DutyUserID=objSpe.PSDutyUser
	Set Note=objSpe.PSNote
	Set Opinion=objSpe.PSOpinion
	Set MarkDate=objSpe.PSMarkDate
	Set MarkTime=objSpe.PSMarkTime
	Set CheckOpinion=objSpe.PSCheckOpinion
	Set CheckDate=objSpe.PSCheckDate
	Set CheckTime=objSpe.PSCheckTime
	Set PrognosisID=""
	//If $IsObject(objSpe.PSPrognosis){
	//	Set PrognosisID=objSpe.PSPrognosis.%Id()
	//}
	Set FinalDate=objSpe.PSFinalDate
	Set FinalTime=objSpe.PSFinalTime
	Set IsCheck=objSpe.PSIsCheck
	Set IsFinal=objSpe.PSIsFinal
	
	Set StatusID=""
	If OperCode="1" {  //作废
		Set StatusCode="0"
		Set UpdoStatusCode="0"
	} ElseIf OperCode="2" {  //撤销审核
		Set StatusCode="1"
		Set UpdoStatusCode="20"
		//Set IsCheck=objPatType.PTSAutoCheck  //3审核状态
		Set IsCheck=0
		Set CheckOpinion=""  //撤销审核时，审核意见清空
		Set CheckDate=""
		Set CheckTime=""
	} ElseIf OperCode="3" {  //撤销关闭
		If objSpe.PSIsCheck=2 {
			Set StatusCode="2"
		} Else {
			Set StatusCode="1"
		}
		Set UpdoStatusCode="30"
		//Set IsFinal=objPatType.PTSAutoClose  //4关闭状态
		Set IsFinal=0
		Set FinalDate=""
		Set FinalTime=""
	}
	Set objStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("SPEStatus",StatusCode,"")
	Quit:'$IsObject(objStatus) return
	Set StatusID=objStatus.%Id()
	
	Set objUpdoStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("SPEStatus",UpdoStatusCode,"")
	Quit:'$IsObject(objUpdoStatus) return
	Set UpdoStatusID=objUpdoStatus.%Id()
	
	TStart
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=SpeID           //ID
	Set $p(InputStr,"^",2)=EpisodeID       //就诊号
	Set $p(InputStr,"^",3)=PatTypeSubID    //特殊患者类型
	Set $p(InputStr,"^",4)=DutyDeptID      //责任科室
	Set $p(InputStr,"^",5)=DutyUserID      //责任人
	Set $p(InputStr,"^",6)=Note            //情况说明
	Set $p(InputStr,"^",7)=Opinion         //初步意见
	Set $p(InputStr,"^",8)=MarkDate        //标记日期
	Set $p(InputStr,"^",9)=MarkTime        //标记时间
	Set $p(InputStr,"^",10)=StatusID       //状态
	Set $p(InputStr,"^",11)=CheckOpinion   //审核意见
	Set $p(InputStr,"^",12)=CheckDate      //审核日期
	Set $p(InputStr,"^",13)=CheckTime      //审核时间
	Set $p(InputStr,"^",14)=PrognosisID    //转归情况
	Set $p(InputStr,"^",15)=FinalDate      //关闭日期
	Set $p(InputStr,"^",16)=FinalTime      //关闭时间
	Set $p(InputStr,"^",17)=+$h            //更新日期
	Set $p(InputStr,"^",18)=$p($h,",",2)   //更新时间
	Set $p(InputStr,"^",19)=UpdateUser     //操作人
	Set $p(InputStr,"^",20)=+IsCheck       //是否审核
	Set $p(InputStr,"^",21)=+IsFinal       //是否关闭
	
	Set return="-1^保存特殊患者记录失败"
	Set flg=##Class(DHCMed.SPE.Patients).Update(InputStr,"^")
	If (+flg<1) TRollback
	Quit:(+flg<1) return
	Set SpeID=flg  //特殊患者记录ID
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=SpeID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=UpdoStatusID    //当前状态
	Set $p(InputStr,"^",4)=UpdoOpinion     //处置意见
	Set $p(InputStr,"^",5)=+$h             //发生日期
	Set $p(InputStr,"^",6)=$p($h,",",2)    //发生时间
	Set $p(InputStr,"^",7)=UpdateUser      //操作人
	Set $p(InputStr,"^",8)=0		       //消息类型
	Set $p(InputStr,"^",9)=0		       //是否阅读
	Set $p(InputStr,"^",10)=""	           //阅读日期
	Set $p(InputStr,"^",11)=""	           //阅读时间
	Set $p(InputStr,"^",12)=""	           //阅读人
	Set $p(InputStr,"^",13)=1	           //是否有效
	Set $p(InputStr,"^",14)=UpdateUser	   //更新人
	
	Set return="-2^保存特殊患者更新日志失败"
	Set flg=##Class(DHCMed.SPE.PatientsLog).Update(InputStr,"^")
	If (+flg<1) TRollback
	Quit:(+flg<1) return
	
	TCommit
	
    //作废推送消息
	If OperCode="1"  {
		Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000038",SpeID,"3",EpisodeID)
	}
	Set return=SpeID
	Quit return
	
UpdoSpeOperErr
	Quit -999_"^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2015-11-03
/// Description:  发送消息
/// Table：       DHCMed.SPE.PatientsLog
/// Input：       InputStr : 消息内容=SpeID^Opinion^NewsType^UserID
/// Return：      return=<0:更新失败  return>0:更新成功
/// w ##class(DHCMed.SPEService.PatientsSrv).SendNews("3^测试消息^2^9")
ClassMethod SendNews(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	//Set ^ZF=aInputStr
	
	Set SpeID=$p(aInputStr,"^",1)
	Set Opinion=$p(aInputStr,"^",2)
	Set NewsType=$p(aInputStr,"^",3)
	Set UpdateUser=$p(aInputStr,"^",4)
	Quit:(SpeID="")||(Opinion="")||(NewsType="") return
	
	Set StatusCode="9"  //消息
	Set objStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("SPEStatus",StatusCode,"")
	Quit:'$IsObject(objStatus) return
	Set StatusID=objStatus.%Id()
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=SpeID
	Set $p(InputStr,"^",2)=""
	Set $p(InputStr,"^",3)=StatusID        //当前状态
	Set $p(InputStr,"^",4)=Opinion         //处置意见
	Set $p(InputStr,"^",5)=+$h             //发生日期
	Set $p(InputStr,"^",6)=$p($h,",",2)    //发生时间
	Set $p(InputStr,"^",7)=UpdateUser      //操作人
	Set $p(InputStr,"^",8)=+NewsType        //消息类型
	Set $p(InputStr,"^",9)=0		       //是否阅读
	Set $p(InputStr,"^",10)=""	           //阅读日期
	Set $p(InputStr,"^",11)=""	           //阅读时间
	Set $p(InputStr,"^",12)=""	           //阅读人
	Set $p(InputStr,"^",13)=1	           //是否有效
	Set $p(InputStr,"^",14)=UpdateUser	   //更新人
	
	Set return=##Class(DHCMed.SPE.PatientsLog).Update(InputStr,"^")
    //发送消息推送
	Set NewsID=return	
	Set EpisodeID=$p(..GetSepInfoByID(SpeID),"^",2)
	Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000023",NewsID,"1",EpisodeID)
	
	//add by mxp 管理科特殊患者消息，往消息平台发提示消息
	If NewsType="2" {
		//是否启用消息平台消息发送功能
		Set IsSendMsg=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SS-IsSendMessage","")
		If (+IsSendMsg)=1 {
			Set PatTypeDesc=$p($p(..GetSepInfoByID(SpeID),"^",4),$c(1),2)
			Set tmpOpinion="特殊患者类型："_PatTypeDesc_" 消息提醒："_Opinion
			Set LnkJson="{""BizObjId"":"_NewsID_"}"
			Set flg=##class(DHCMed.SSIO.FromHisSrv).SendMsg(tmpOpinion,"1064",UpdateUser,EpisodeID,"",LnkJson)
		}
	}
	
	Quit return
}

/// w ##Class(DHCMed.SPEService.PatientsSrv).DeleteNews("3||8","9")
ClassMethod DeleteNews(aSpeLogID As %String, aUserID As %String) As %String
{
	New (aSpeLogID,aUserID)
	Set return=0
	Quit:aSpeLogID="" return
	
	Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(aSpeLogID)
	Quit:'$IsObject(objLog) return
	
	Set return=-100
    Quit:objLog.PSLIsActive'=1 return  //无效
    Quit:'$IsObject(objLog.PSLStatus) return
    Quit:objLog.PSLStatus.Code'=9 return  //状态不符
    Set return=-300               //已读的删除提示
    Quit:objLog.PSLIsRead=1 return    //过滤已读
    
	Set return=-200
	Quit:objLog.PSLActUser'=aUserID return
	
	Set SpeID=$p(aSpeLogID,"||",1)
	Set ChildSub=$p(aSpeLogID,"||",2)
	Set StatusID=""
	If $IsObject(objLog.PSLStatus) {
		Set StatusID=objLog.PSLStatus.%Id()
	}
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=SpeID
	Set $p(InputStr,"^",2)=ChildSub
	Set $p(InputStr,"^",3)=StatusID            //当前状态
	Set $p(InputStr,"^",4)=objLog.PSLOpinion   //处置意见
	Set $p(InputStr,"^",5)=objLog.PSLActDate   //发生日期
	Set $p(InputStr,"^",6)=objLog.PSLActTime   //发生时间
	Set $p(InputStr,"^",7)=objLog.PSLActUser   //操作人
	Set $p(InputStr,"^",8)=objLog.PSLNewsType  //消息类型
	Set $p(InputStr,"^",9)=objLog.PSLIsRead    //是否阅读
	Set $p(InputStr,"^",10)=objLog.PSLReadDate //阅读日期
	Set $p(InputStr,"^",11)=objLog.PSLReadTime //阅读时间
	Set $p(InputStr,"^",12)=objLog.PSLReadUser //阅读人
	Set $p(InputStr,"^",13)=0	               //是否有效
	Set $p(InputStr,"^",14)=aUserID 	       //更新人
	
	Set return=##Class(DHCMed.SPE.PatientsLog).Update(InputStr,"^")
	//发送消息推送
	Set NewsID=return
	Set EpisodeID=$p(..GetSepInfoByID(SpeID),"^",2)
	Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000023",NewsID,"3",EpisodeID)
	
	//撤销消息平台消息
	If objLog.PSLNewsType=2 {
		//是否启用消息平台消息发送功能
		Set IsSendMsg=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SS-IsSendMessage","")
		If (+IsSendMsg)=1 {
			Set LnkJson="{""BizObjId"":"_NewsID_"}"
			Set flg=##class(DHCMed.SSIO.FromHisSrv).CancelMsg("","1064",EpisodeID,LnkJson,aUserID,"","")
		}
	}
	
	Quit return
}

/// 添加参数 aBackFlag ：消息平台阅读消息后回调 
/// w ##Class(DHCMed.SPEService.PatientsSrv).ReadNews("","662","","1||2")
ClassMethod ReadNews(aSpeID As %String, aUserID As %String, aOperTpCode As %String, aSpeLogIDs As %String = "", aBackFlag As %String = "") As %String
{
	New (aSpeID,aUserID,aOperTpCode,aSpeLogIDs,aBackFlag)
	Set return=0
	Quit:(aSpeID="")&&(aSpeLogIDs="") return
	Quit:(aSpeID'="")&&(aOperTpCode="") return
	
	If aSpeLogIDs'="" {
		For indSL=1:1:$l(aSpeLogIDs,",") {
			Set SpeLogID=$p(aSpeLogIDs,",",indSL)
			Continue:SpeLogID=""
			
			Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
			Continue:'$IsObject(objLog)
			Continue:objLog.PSLIsActive'=1
			Continue:objLog.PSLIsRead=1
		    Continue:'$IsObject(objLog.PSLStatus)
		    Continue:objLog.PSLStatus.Code'=9  //状态不符
	    	
			Set SpeID=$p(SpeLogID,"||",1)
			Set ChildSub=$p(SpeLogID,"||",2)
		    Set StatusID=objLog.PSLStatus.%Id()
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=SpeID
			Set $p(InputStr,"^",2)=ChildSub
			Set $p(InputStr,"^",3)=StatusID                //当前状态
			Set $p(InputStr,"^",4)=objLog.PSLOpinion       //处置意见
			Set $p(InputStr,"^",5)=objLog.PSLActDate       //发生日期
			Set $p(InputStr,"^",6)=objLog.PSLActTime       //发生时间
			Set $p(InputStr,"^",7)=objLog.PSLActUser       //操作人
			Set $p(InputStr,"^",8)=objLog.PSLNewsType      //消息类型
			Set $p(InputStr,"^",9)=1                       //是否阅读
			Set $p(InputStr,"^",10)=+$h                    //阅读日期
			Set $p(InputStr,"^",11)=$p($h,",",2)           //阅读时间
			Set $p(InputStr,"^",12)=aUserID                //阅读人
			Set $p(InputStr,"^",13)=objLog.PSLIsActive     //是否有效
			Set $p(InputStr,"^",14)=aUserID 	           //更新人
			
			Set flg=##Class(DHCMed.SPE.PatientsLog).Update(InputStr,"^")
			Set EpisodeID=$p(..GetSepInfoByID(SpeID),"^",2)
			Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000023",SpeLogID,"2",EpisodeID)
			
			//是否启用消息平台消息发送功能:消息已读,同步消息平台数据
			Set IsSendMsg=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SS-IsSendMessage","")
			If ((+IsSendMsg)=1)&&(aBackFlag'="Y")&&(aOperTpCode=1) {
				set DoctorDr = $p(^PAADM(EpisodeID),"^",9)
				Set DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
				Set flg=##class(DHCMed.SSIO.FromHisSrv).Exec(DoctorUserDr,"1064",EpisodeID,SpeLogID,aUserID,"","")
			}
		}
	} Else {
		Set xLogSub=0
		For {
			Set xLogSub=$o(^DHCMed.SPE("Pat",aSpeID,"Log",xLogSub))
			Quit:xLogSub=""
			
			Set SpeLogID=aSpeID_"||"_xLogSub
			Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
			Continue:'$IsObject(objLog)
			Continue:objLog.PSLIsActive'=1
			Continue:objLog.PSLIsRead=1
			If aOperTpCode=1 {
				Continue:objLog.PSLNewsType'=2
			} Else {
				Continue:objLog.PSLNewsType'=1
			}
		    Continue:'$IsObject(objLog.PSLStatus)
		    Continue:objLog.PSLStatus.Code'=9  //状态不符
	    	
			Set SpeID=$p(SpeLogID,"||",1)
			Set ChildSub=$p(SpeLogID,"||",2)
		    Set StatusID=objLog.PSLStatus.%Id()
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=SpeID
			Set $p(InputStr,"^",2)=ChildSub
			Set $p(InputStr,"^",3)=StatusID                //当前状态
			Set $p(InputStr,"^",4)=objLog.PSLOpinion       //处置意见
			Set $p(InputStr,"^",5)=objLog.PSLActDate       //发生日期
			Set $p(InputStr,"^",6)=objLog.PSLActTime       //发生时间
			Set $p(InputStr,"^",7)=objLog.PSLActUser       //操作人
			Set $p(InputStr,"^",8)=objLog.PSLNewsType      //消息类型
			Set $p(InputStr,"^",9)=1                       //是否阅读
			Set $p(InputStr,"^",10)=+$h                    //阅读日期
			Set $p(InputStr,"^",11)=$p($h,",",2)           //阅读时间
			Set $p(InputStr,"^",12)=aUserID                //阅读人
			Set $p(InputStr,"^",13)=objLog.PSLIsActive     //是否有效
			Set $p(InputStr,"^",14)=aUserID 	           //更新人
			
			Set flg=##Class(DHCMed.SPE.PatientsLog).Update(InputStr,"^")
			Set EpisodeID=$p(..GetSepInfoByID(SpeID),"^",2)
			Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000023",SpeLogID,"2",EpisodeID)

			//是否启用消息平台消息发送功能:消息已读,同步消息平台数据
			Set IsSendMsg=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SS-IsSendMessage","")		
			If ((+IsSendMsg)=1)&&(aBackFlag'="Y")&&(aOperTpCode=1) {
				set DoctorDr = $p(^PAADM(EpisodeID),"^",9)
				Set DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
				Set flg=##class(DHCMed.SSIO.FromHisSrv).Exec(DoctorUserDr,"1064",EpisodeID,SpeLogID,aUserID,"","")
			}
		}
	}
	
	Set return=1
	Quit return
}

/// 检查是否有可读消息
/// w ##Class(DHCMed.SPEService.PatientsSrv).CheckNews("77","2")
ClassMethod CheckNews(aSpeID As %String, aOperTpCode As %String) As %String
{
	New (aSpeID,aOperTpCode)
	Set return=0
	Quit:(aSpeID="")||(aOperTpCode="") return
	Set flg = 0
	Set xLogSub=0
	For {
		Set xLogSub=$o(^DHCMed.SPE("Pat",aSpeID,"Log",xLogSub))
		Quit:xLogSub=""
		Quit:flg=1
		Set SpeLogID=aSpeID_"||"_xLogSub
		Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
		Continue:'$IsObject(objLog)
		Continue:objLog.PSLIsActive'=1
		Continue:objLog.PSLIsRead=1
		If aOperTpCode=1 {
			Continue:objLog.PSLNewsType'=2
		} Else {
			Continue:objLog.PSLNewsType'=1
		}
	    Continue:'$IsObject(objLog.PSLStatus)
	    Continue:objLog.PSLStatus.Code'=9  //状态不符
	    Set flg =1
	}
	
	Set return=flg
	Quit return
}

/// w ##class(DHCMed.SPEService.PatientsSrv).GetDicForCheckGroup("SPEStatus","1")
ClassMethod GetDicForCheckGroup(aType As %String, aActive As %String) As %String
{
	New (aType,aActive)
	Set return=""
	Quit:(aType="") return
	Set rs=##class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute(aType,aActive)
	While (rs.Next()) {
		Set Code=rs.Get("Code")
		Continue:((Code="30")||(Code="20")||(Code="9"))
		Set Desc=rs.Get("Description")	
		Set return=return_Code_"^"_Desc_","
	}
	Do rs.Close()
	Set:(return'="") return=$e(return,1,$l(return)-1)
	Quit return
}

/// 根据就诊号和特殊患者子分类，查询当前特殊患者标记记录
/// w ##class(DHCMed.SPEService.PatientsSrv).GetRecord("109","2||3")
ClassMethod GetRecord(aEpisodeID As %String, aPatTypeSub As %String) As %String
{
	New (aEpisodeID,aPatTypeSub)
	Set return=0
	Quit:((aEpisodeID="")||(aPatTypeSub="")) return

	Set xID=0
	For {
		Set xID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID,aPatTypeSub,xID))
		Quit:xID=""
				
		Set objTmp=##class(DHCMed.SPE.Patients).GetObjById(xID)
		Continue:'$IsObject(objTmp)
		Continue:'$IsObject(objTmp.PSCurrStatus)
		Set CurrStatus=objTmp.PSCurrStatus.Code
		Set CurrStatusID=objTmp.PSCurrStatus.%Id()
		Continue:CurrStatus="0"  //作废状态记录
		Continue:CurrStatus="3"  //关闭状态记录	
		Set return=objTmp.%Id()	
	}
	Quit return
}

/// 根据消息ID判断消息类型
/// w ##class(DHCMed.SPEService.PatientsSrv).GetNewsType("34||4")
ClassMethod GetNewsType(aNewsID As %String) As %String
{
	New (aNewsID)
	Set return=""
	Quit:(aNewsID="") return
	
    Set objSpeNews=##class(DHCMed.SPE.PatientsLog).GetObjById(aNewsID)
	Quit:'$IsObject(objSpeNews)
	
	Set NewsType=objSpeNews.PSLNewsType
	Quit:NewsType=0 return   //0不是消息

	Set SpeID=$p(aNewsID,"||",1)
	Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(SpeID)	
	Quit:'$IsObject(objSpe) return
    Quit:'$IsObject(objSpe.PSCurrStatus) return

	Set EpisodeID=objSpe.PSEpisodeID
	//Set DutyUserID=objSpe.PSDutyUser  //标记人
	Set DoctorID  =$g(^CTPCP(+$p(^PAADM(EpisodeID),"^",9),1))
	Set DoctorCode=$p(DoctorID,"^",1)
    
	Set LocInfo=##class(DHCMed.Base.Ctloc).GetByDescAlias("YWK","E")

	Set CtLocCode=$p(LocInfo,"^",2)
	If (NewsType=1) {          //临床消息
		Set return="^"_CtLocCode
	}Else {                    //管理科室消息
		Set return=DoctorCode_"^"
	}
	
	Quit return
}

}
