/// 名称: DHCMed.CCService.Feedback.CtlAdmTransSrv
/// 描述: 目标性监测 科室住院记录
/// 编写者：zhufei
/// 编写日期: 2012-06-16
Class DHCMed.CCService.Feedback.CtlAdmTransSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Feedback.CtlAdmTransSrv).UpdateTrans(73,"W")
ClassMethod UpdateTrans(aPaadm As %String, aTransType As %String) As %String
{
	New (aPaadm,aTransType)
	Set return=-1
	Quit:(aPaadm="")||(aTransType="") return
	
	Set $ZT="UpdateTransErr"
	
	TSTART
	
	Set (PrevID,PrevTransID,PrevTransLoc,PrevTransInDate)=""
	Set xTransID=+$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexNoFinishAdm",aTransType,0,aPaadm,""),-1)
	Set yTransID=+$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexNoFinishAdm",aTransType,1,aPaadm,""),-1)
	Set:yTransID>xTransID xTransID=yTransID
	If xTransID>0 {
		Set objTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xTransID)
		If $IsObject(objTrans) {
			Set PrevID=objTrans.%Id()
			Set PrevTransID=objTrans.TransID
			Set PrevTransLoc=objTrans.TransLoc
			Set PrevTransInDate=objTrans.TransInDate
		}
	}
	
	Set TransID=PrevTransID
	For {
		Set TransID=$o(^PAADM(aPaadm,"TRANS",TransID))
		Quit:TransID=""
		
		Set tmpTrans=$g(^PAADM(aPaadm,"TRANS",TransID))
		Continue:tmpTrans=""
		
		If aTransType="W" {
			Set TransLoc=$p($p(tmpTrans,"^",8),"||",1)
			Continue:TransLoc=""
			Set TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
			Continue:PrevTransLoc=TransLoc
			Set TransDate=$p($g(^PAADM(aPaadm,"TRANS",TransID)),"^",1)
		} Else {
			Set TransLoc=$p(tmpTrans,"^",6)
			Continue:TransLoc=""
			Continue:PrevTransLoc=TransLoc
			Set TransDate=$p($g(^PAADM(aPaadm,"TRANS",TransID)),"^",1)
		}
		
		//1 结束上一条转科记录
		If PrevID'="" {
			Set objPrev=##class(DHCMed.CC.CtlAdmTrans).GetObjById(PrevID)
			If $IsObject(objPrev)
			{
				//1.1 结束上一条转科记录
				Set InputStr=objPrev.%Id()
				Set InputStr=InputStr_"^"_objPrev.EpisodeID
				Set InputStr=InputStr_"^"_TransID
				Set InputStr=InputStr_"^"_objPrev.TransLoc
				Set InputStr=InputStr_"^"_objPrev.TransInDate
				Set InputStr=InputStr_"^"_TransDate
				Set InputStr=InputStr_"^"_objPrev.TransType
				Set InputStr=InputStr_"^"_"1"
				Set tmpPrevID=##Class(DHCMed.CC.CtlAdmTrans).Update(InputStr,"^")
				If tmpPrevID<1 TROLLBACK
				
				//1.2 插入临时转科记录（十天一次）
				Set tmpTransInDate=objPrev.TransInDate
				Set tmpTransLoc=objPrev.TransLoc
				For indCnt=1:1:((TransDate-tmpTransInDate)\10) {
					Set tmpTransDate=tmpTransInDate+(indCnt*10)
					Continue:$d(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexInDateLoc",tmpTransDate,tmpTransLoc,aPaadm))
					
					Set InputStr=""
					Set InputStr=InputStr_"^"_objPrev.EpisodeID
					Set InputStr=InputStr_"^"_""
					Set InputStr=InputStr_"^"_objPrev.TransLoc
					Set InputStr=InputStr_"^"_tmpTransDate
					Set InputStr=InputStr_"^"_tmpTransDate
					Set InputStr=InputStr_"^"_objPrev.TransType
					Set InputStr=InputStr_"^"_"-1"
					Set InputStr=InputStr_"^"_objPrev.%Id()
					Set tmpPrevID=##Class(DHCMed.CC.CtlAdmTrans).Update(InputStr,"^")
					If tmpPrevID<1 TROLLBACK
				}
			}
		}
		
		//2 开始下一条转科记录
		Set InputStr=""
		Set InputStr=InputStr_"^"_aPaadm
		Set InputStr=InputStr_"^"_TransID
		Set InputStr=InputStr_"^"_TransLoc
		Set InputStr=InputStr_"^"_TransDate
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_aTransType
		Set InputStr=InputStr_"^"_"0"
		Set PrevID=##Class(DHCMed.CC.CtlAdmTrans).Update(InputStr,"^")
		If PrevID<1 TROLLBACK
		Set PrevTransLoc=TransLoc
		//PrevID与PrevTransLoc变量在循环中会用到，不能随便修改
	}
	
	//3 处理最后一次转科记录
	Set TransID=$o(^PAADM(aPaadm,"TRANS",""),-1)
	
	//Update by pylian 2016-01-21 修改出院时间取值方式
	//Set DischDate=$p($g(^PAADM(aPaadm)),"^",17)
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aPaadm)
	Set DischDate=$p(DischDateTime,"^",1)
	
	Set TransDate=$s(DischDate'="":DischDate,1:+$h)
	Set objPrev=##class(DHCMed.CC.CtlAdmTrans).GetObjById(PrevID)
	If $IsObject(objPrev)
	{
		If (objPrev.IsFinish=0)
		{
			//3.1 处理最后一次转科记录
			Set InputStr=objPrev.%Id()
			Set InputStr=InputStr_"^"_objPrev.EpisodeID
			Set InputStr=InputStr_"^"_TransID
			Set InputStr=InputStr_"^"_objPrev.TransLoc
			Set InputStr=InputStr_"^"_objPrev.TransInDate
			Set InputStr=InputStr_"^"_TransDate
			Set InputStr=InputStr_"^"_objPrev.TransType
			Set InputStr=InputStr_"^"_$s(DischDate'="":1,1:0)
			Set tmpPrevID=##Class(DHCMed.CC.CtlAdmTrans).Update(InputStr,"^")
			If tmpPrevID<1 TROLLBACK
			
			//3.2 插入临时转科记录（十天一次）
			Set tmpTransInDate=objPrev.TransInDate
			Set tmpTransLoc=objPrev.TransLoc
			For indCnt=1:1:((TransDate-tmpTransInDate)\10)
			{
				Set tmpTransDate=tmpTransInDate+(indCnt*10)
				Continue:$d(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexInDateLoc",tmpTransDate,tmpTransLoc,aPaadm))
				
				Set InputStr=""
				Set InputStr=InputStr_"^"_objPrev.EpisodeID
				Set InputStr=InputStr_"^"_""
				Set InputStr=InputStr_"^"_objPrev.TransLoc
				Set InputStr=InputStr_"^"_tmpTransDate
				Set InputStr=InputStr_"^"_tmpTransDate
				Set InputStr=InputStr_"^"_objPrev.TransType
				Set InputStr=InputStr_"^"_"-1"
				Set InputStr=InputStr_"^"_objPrev.%Id()
				Set tmpPrevID=##Class(DHCMed.CC.CtlAdmTrans).Update(InputStr,"^")
				If tmpPrevID<1 TROLLBACK
			}
		}
	}
	
	TCOMMIT
	
	Set return=PrevID
	Quit return
	
UpdateTransErr
	TROLLBACK
	//Write $ZError,!
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2013-04-27
/// Description:  同步转科记录To科室住院记录
/// Table：       DHCMed.CC.CtlAdmTrans
/// Input：       
/// Return：      return<0 : 失败 , return>0 : 成功
/// w ##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).InitAdmTransData("E","2013-03-01")
ClassMethod InitAdmTransData(aTransType As %String, aStartDate As %String = "") As %String
{
	New (aTransType,aStartDate)
	Set return=-1
	Quit:(aTransType="")||(aStartDate="") return
	
	Set $ZT="InitAdmTransDataErr"
	
	Set ZIndex=$zn,JIndex=$j,NIndex="SyncAdmTransData"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//某一天之后入院的就诊记录
	Set:aStartDate["-" aStartDate=$zdh(aStartDate,3)
	Set:aStartDate["/" aStartDate=$zdh(aStartDate,4)
	Set:aStartDate="" aStartDate=+$h-31
	Set AdmDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateIndex()      //update by pylian 2016-02-18取入院时间索引
	Set xStartDate=$o(^PAADMi(AdmDateIndex,aStartDate-1))
	Set xPaadm=$o(^PAADMi(AdmDateIndex,xStartDate,0))
	For {
		Set xPaadm=$o(^PAADMi("PAADM_Type","I",xPaadm))
		Quit:xPaadm=""
		Continue:$p($g(^PAADM(xPaadm)),"^",2)'="I"  //就诊类型过滤
		Continue:$p($g(^PAADM(xPaadm)),"^",20)="C"  //就诊状态过滤
		Set ^TMP(ZIndex,JIndex,NIndex,xPaadm)=""
	}
	
	Set xWard=""
	For {
		Set xWard=$o(^PAADMi("CurrWard",xWard))
		Quit:xWard=""
		Set xRoom=""
		For {
			Set xRoom=$o(^PAADMi("CurrWard",xWard,xRoom))
			Quit:xRoom=""
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("CurrWard",xWard,xRoom,xPaadm))
				Quit:xPaadm=""
				Continue:$p($g(^PAADM(xPaadm)),"^",2)'="I"  //就诊类型过滤
				Continue:$p($g(^PAADM(xPaadm)),"^",20)="C"  //就诊状态过滤
				Set ^TMP(ZIndex,JIndex,NIndex,xPaadm)=""
			}
		}
	}
	
	Set xPaadm=0
	For {
		Set xPaadm=$o(^TMP(ZIndex,JIndex,NIndex,xPaadm))
		Quit:xPaadm=""
		Set flg=..UpdateTrans(xPaadm,aTransType)
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set return=1
	Quit return
	
InitAdmTransDataErr
	Write $ZError,!
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2013-04-27
/// Description:  同步转科记录To科室住院记录
/// Table：       DHCMed.CC.CtlAdmTrans
/// Input：       
/// Return：      return<0 : 失败 , return>0 : 成功
/// w ##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).SyncAdmTransData("E")
ClassMethod SyncAdmTransData(aTransType As %String) As %String
{
	New (aTransType)
	Set return=-1
	Quit:aTransType="" return
	
	//未初始化数据，初始化数据方法（..InitAdmTransData()）
	Quit:'$d(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexNoFinishAdm",aTransType)) return
	
	Set $ZT="SyncAdmTransDataErr"
	
	Set ZIndex=$zn,JIndex=$j,NIndex="SyncAdmTransData"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//未结束就诊记录
	Set xPaadm=0
	For {
		Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexNoFinishAdm",aTransType,0,xPaadm))
		Quit:xPaadm=""
		Continue:$p($g(^PAADM(xPaadm)),"^",2)'="I"  //就诊类型过滤
		Continue:$p($g(^PAADM(xPaadm)),"^",20)="C"  //就诊状态过滤
		Set ^TMP(ZIndex,JIndex,NIndex,xPaadm)=""
	}
	
	//未处理就诊记录
	Set xPaadm=+$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexNoFinishAdm",aTransType,0,""),-1)
	Set tmpPaadm=+$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexNoFinishAdm",aTransType,1,""),-1)
	Set:tmpPaadm>xPaadm xPaadm=tmpPaadm
	For {
		Set xPaadm=$o(^PAADMi("PAADM_Type","I",xPaadm))
		Quit:xPaadm=""
		Continue:$p($g(^PAADM(xPaadm)),"^",2)'="I"  //就诊类型过滤
		Continue:$p($g(^PAADM(xPaadm)),"^",20)="C"  //就诊状态过滤
		Set ^TMP(ZIndex,JIndex,NIndex,xPaadm)=""
	}
	
	Set xPaadm=0
	For {
		Set xPaadm=$o(^TMP(ZIndex,JIndex,NIndex,xPaadm))
		Quit:xPaadm=""
		Set flg=..UpdateTrans(xPaadm,aTransType)
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set return=1
	Quit return
	
SyncAdmTransDataErr
	Write $ZError,!
	Quit -999
}

}
