/// 名称：DHCMed.EPDService.Service
/// 描述：传染病相关接口
/// 创建者：李阳
/// 创建日期：2011-07-10
Class DHCMed.EPDService.Service Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-08-04
/// Description:  To病人列表图标接口
///               根据就诊号判断患者是否上报传染病(包括历史就诊上报)
///               传染病报卡患者返回传染病分类名称列表
/// Table：       DHCMed.EPD.Epidemic
/// Input：       EpisodeID:    User.PAADM
/// Return：      %String
/// w ##class(DHCMed.EPDService.Service).GetEpdRepDiagnos(1727)
ClassMethod GetEpdRepDiagnos(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetEpdRepDiagnosErr"
	
	Set DiagnosList=..getEpdList(aEpisodeID,"1")
	For DiagnosIndex=1:1:$listlength(DiagnosList) {
		Set DiagnosKind=$list(DiagnosList,DiagnosIndex)
		Continue:DiagnosKind=""
		Set objDiagnos=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",DiagnosKind,"")
		Continue:'$IsObject(objDiagnos)
		Set return=return_","_objDiagnos.Description
	}
	Set:return'="" return="["_$e(return,2,$l(return))_"]"_"已报!"
	
	Quit return
	
GetEpdRepDiagnosErr
	Quit ""
}

/// Creator:		Xuwenjie
/// CreatDate:		2020-03-27
/// Description:	取报告的状态
/// Input:			ReportID
/// Return:			StatusCode
/// w ##class(DHCMed.EPDService.Service).GetReportStatus(7)
ClassMethod GetReportStatus(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(+aReportID)
	Quit:'$IsObject(objRep) return
	
	Set RepStatus=objRep.MEPDStatus
	Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatus,"")
	Set RepStatusCode="",RepStatusDesc=""
	If $IsObject(objRepStatus){
		Set RepStatusDesc=objRepStatus.Description
		Set RepStatusCode=objRepStatus.Code
	}
	Set return=RepStatusCode
	
	Quit return
}

/// Creator：     CPJ
/// CreatDate：   2018-03-06
/// Description:  根据就诊号判断患者本次就诊是否上报传染病
/// Input：       EpisodeID
/// Return：      %String:1 是，0 否
/// w ##class(DHCMed.EPDService.Service).GetEpdRepDiagnosNew(1727)
ClassMethod GetEpdRepDiagnosNew(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="0"
	Quit:aEpisodeID="" return
	
	Set $ZT="GetEpdRepDiagnosNewErr"
	Set RepID=0
	For {
		Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,RepID))
		Quit:RepID=""
		
		Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
		Continue:'$IsObject(objRep)
		
		Continue:objRep.MEPDStatus="4"  //被订状态报告无效
		Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
		Continue:objRep.MEPDStatus="7"  //删除状态报告无效
		Continue:'$IsObject(objRep.MEPDICDDR)
		Set return=1
	}
	Quit return
	
GetEpdRepDiagnosNewErr
	Quit "0"
}

/// Creator：     maxp
/// CreatDate：   2016-04-26
/// Description:  To病人列表图标接口
///               根据就诊号判断患者是否上报传染病-》修改为传染病筛查中筛查到且未排除的（2020-01-21）
///               传染病报卡患者返回传染病未报分类名称列表
/// Table：       DHCMed.EPD.Epidemic
/// Input：       EpisodeID:    User.PAADM
/// Return：      %String
/// w ##class(DHCMed.EPDService.Service).GetEpdNotRepDiagnos(1727)
ClassMethod GetEpdNotRepDiagnos(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetEpdNotRepDiagnosErr"
	
	Set xCasesXID=""
	For {
		Set xCasesXID=$o(^DHCMed.EPDi("CasesX","IndexSubjectPaadm","EPDCC",aEpisodeID,xCasesXID))
		Quit:xCasesXID=""
	   
		Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesXID)
		Continue:'$IsObject(objCasesX)
		Set IsActive=objCasesX.CXIsActive
		Continue:IsActive'=1
		
		Set AdmInfo=$g(^PAADM(aEpisodeID))
		Continue:$p(AdmInfo,"^",20)="C"               //就诊状态过滤
		
		Set EpdStatus=objCasesX.CXEpdStatus
		Continue:EpdStatus=0                          //排除状态退出		
		Set ActDiagnos=objCasesX.CXActDiagnos         //触发诊断
		Set EpdDiagnos=""
	
		//确诊
		Set flg=##class(DHCMed.EPDService.SuspCasesXSrv).GetReportByCasesX(xCasesXID)
        Continue:flg'=""
      
		Set EpdDiagnosID=objCasesX.CXEpdDiagnos
		Set objInf=##class(DHCMed.EPD.Infection).GetObjById(EpdDiagnosID)
		Set:$IsObject(objInf) EpdDiagnos=objInf.MIFDisease
		
		Set:EpdDiagnos'="" ActDiagnos=EpdDiagnos
		Set return=return_" "_ActDiagnos
	}
	
	Set:return'="" return="传染病未报:"_return
	
	Quit return
	
GetEpdNotRepDiagnosErr
	Quit ""
}

/// Description:  取传染病信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：       EpisodeID:    User.PAADM
/// Return：      %String
/// w ##class(DHCMed.EPDService.Service).GetEpdDiagnosInfoNew(1936)
ClassMethod GetEpdDiagnosInfoNew(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetEpdDiagnosInfoNewErr"
	
	Set CasesXOutDiag=##class(DHCMed.EPDService.CasesXSrv).GetOutDiagnos(aEpisodeID,"EPDCC")
	Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,"","")
	
	Set DiagnosList=..getEpdList(aEpisodeID) //已上报
	Set arrRec=##Class(DHCMed.DPCustom.Data.MRDiagnos).GetDataByAdm(aEpisodeID)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ActDate=objRec.ActDate
		Set ActTime=objRec.ActTime
		Continue:(ActDate="")||(ActTime="")
		
		Set ICD10=objRec.ICD10
		Set ICDDesc=objRec.ICDDesc
		Set Comments=objRec.Comments
		Continue:$listfind(CasesXOutDiag,ICDDesc)>0 //传染病筛查处置 已排除
		
		Set flg=##class(DHCMed.CCService.Library.MRDiagnos).CheckIsEPD(ICD10,ICDDesc,Comments)
		Continue:flg=""
		Set EPDDiagnos=flg
		
		Set EpdICDs="",EpdNotRepList="",IsRepFlag=0
		For indEpd=1:1:$l(EPDDiagnos,",") {
			Set xEpdIFID=$p(EPDDiagnos,",",indEpd)
			Continue:xEpdIFID=""
			Set tmpEpdIFDesc=$p($g(^DHCMed.EPDC("IF",+xEpdIFID)),"^",2)
			Continue:tmpEpdIFDesc=""
			
			Set IFDiagnosMIFKind = $p($g(^DHCMed.EPDC("IF",+xEpdIFID)),"^",3)
			Set:$listfind(DiagnosList,IFDiagnosMIFKind)>0 IsRepFlag=1  //根据大类判断是否已报
			Set:$listfind(EpdNotRepList,IFDiagnosMIFKind)>0 IsRepFlag=0 //根据大类取未报描述
			Set IFRank=$p($g(^DHCMed.EPDC("IF",+xEpdIFID)),"^",4)
			Set objIFRank=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICRANK",+IFRank,"")
			Continue:'$IsObject(objIFRank)
			Set IFRankDesc=objIFRank.Description
			Continue:(IFRankDesc["AFP")&&((+PatAge)>(+AFPAgeMax)) //AFP年龄限制
			Set EpdNotRepList=EpdNotRepList_$lb(IFDiagnosMIFKind)
			Set:IFRankDesc["AFP" tmpEpdIFDesc="(AFP)"_tmpEpdIFDesc
			Set EpdICDs=EpdICDs_"、"_tmpEpdIFDesc
		}
		Set:EpdICDs'="" EpdICDs=$e(EpdICDs,2,$l(EpdICDs))
		Continue:EpdICDs=""
		Set Summary=objRec.ICDDesc
		Set:objRec.ICD10'="" Summary="【"_objRec.ICD10_"】"_Summary
		Set:objRec.Comments'="" Summary=Summary_";"_objRec.Comments
		If (IsRepFlag=1) {
			Set FlagInfo="【已报】"
		}Else{
			Set FlagInfo="【未报】"
		}
		Set Summary=EpdICDs_FlagInfo_" "_Summary
		set return=return_" "_Summary
	}

	If (DiagnosList'="")&&(return="") {   
		For DiagnosIndex=1:1:$listlength(DiagnosList) {
		Set DiagnosKind=$list(DiagnosList,DiagnosIndex)
			Continue:DiagnosKind=""
			Set objDiagnos=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",DiagnosKind,"")
			Continue:'$IsObject(objDiagnos)
			Set return=return_","_objDiagnos.Description
		}
		Set:return'="" return=$e(return,2,$l(return))_"【已报】"		
	}
	Quit return
	
GetEpdDiagnosInfoNewErr
	Quit ""
}

/// Creator：     mayanpeng
/// CreatDate：   2021-11-18
/// Description:  【To医生站接口】通过传染病筛查结果取传染病诊断与是否上报信息
/// Table：       DHCMed.EPD.CasesX
/// Input：       EpisodeID:    User.PAADM
/// Return：      %String 流行性感冒【未报】
/// w ##class(DHCMed.EPDService.Service).GetEpdDiagFromCasesX(209)
ClassMethod GetEpdDiagFromCasesX(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetEpdDiagFromCasesXErr"
	
	//检查患者已报
 	Set ReportDiagnosList=""
	If $d(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID)) {
		Set xRepID=""
	    For {
		    Set xRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,xRepID))
		    Quit:xRepID=""
		    
		    Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
		    Continue:'$IsObject(objRep)
		  	Continue:objRep.MEPDStatus="4"  //被订状态报告无效
			Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
			Continue:objRep.MEPDStatus="7"  //删除状态报告无效
			Continue:'$IsObject(objRep.MEPDICDDR)
			
			Set EpdDesc=objRep.MEPDICDDR.MIFDisease
			Set EpdKind=objRep.MEPDICDDR.MIFKind
			Continue:(EpdKind="")
			Set ReportDiagnosList=ReportDiagnosList_$lb(EpdDesc_"【已报】")
	    }
	    Set:ReportDiagnosList'="" return=$ListToString(ReportDiagnosList," ")
	}
	//检查筛查结果
	Set CasesXDiagnosList=""
	Set xCasesXID=""
 	For {
 		Set xCasesXID=$o(^DHCMed.EPDi("CasesX","IndexSubjectPaadm","EPDCC",aEpisodeID,xCasesXID))
 		Quit:xCasesXID=""
 		
 		//传染病筛查结果
 		Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesXID)
		Continue:'$IsObject(objCasesX)
		Set IsActive=objCasesX.CXIsActive
		Continue:IsActive'=1
	
		Set EpdStatus=objCasesX.CXEpdStatus
		Continue:EpdStatus'=1	//只取确诊的筛查结果
		Set EpdDiagnos=objCasesX.CXEpdDiagnos
		Continue:EpdDiagnos=""
		Set objDiagnos = ##class(DHCMed.EPD.Infection).GetObjById(EpdDiagnos)
		Continue:'$IsObject(objDiagnos)
		
		If $ListFind(ReportDiagnosList,objDiagnos.MIFDisease_"【已报】")<1 {
			Set return=return_" "_objDiagnos.MIFDisease_"【未报】"
		}
 	}
 	Set:$e(return,1,1)=" " return=$e(return,2,$l(return))
	Quit return
	
GetEpdDiagFromCasesXErr
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2020-12-08
/// Description:  To医生站传染病强制或提示报卡接口(根据传染病疑似筛查条件)
///               根据就诊号判断是否传染病未上报患者
///               未上报,弹出传染病报告卡,强制报卡
///               已上报,强制上报期限内弹出传染病报告卡,提示报卡(本次就诊已报，不提示)，超出强制上报期限弹出传染病报告卡,强制报卡
///               甲类传染病、甲类管理的乙类传染病,给出特殊提示
///               AFP传染病,给出特殊提示
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       aICD : ICD编码
/// Input：       aKeys : 关键词
/// Return：      返回String
/// w ##class(DHCMed.EPDService.Service).CheckDiagToEpd("67","3","217","")
ClassMethod CheckDiagToEpd(aEpisodeID As %String, aDiagType As %String, aICDDxID As %String, aDiagNote As %String) As %String
{
	New (aEpisodeID,aDiagType,aICDDxID,aDiagNote,%session)
	Set return=""
	Quit:(aEpisodeID="")||(aDiagType="")||((aICDDxID="")&&(aDiagNote="")) return
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set txtCare = "注意：法定传染病不填报传染病报告，不允许保存诊断！"	
	Set txtCare = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtCare)	
	Set txtReported = "此传染病已上报过"
	Set txtReported = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtReported)	
	Set txtDateReped = "最近一次上报时间为"
	Set txtDateReped = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtDateReped)	
	Set txtHistory  = "该患者存在导入的同类历史报告"
	Set txtHistory = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtHistory)	
	Set txtRepeat = "无需重复上报,您确认需要重复上报吗"
	Set txtRepeat = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtRepeat)	
	Set txtTwoMonth = "发病时间在2个月内,且患者年龄小于等于"
	Set txtTwoMonth = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtTwoMonth)	
	Set txtINfo = "岁,为急性迟缓性麻痹（AFP）病例"
	Set txtINfo = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtINfo)	
	Set txtBy = "为"
	Set txtBy = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtBy)	
	Set txtPlease = "请上报"
	Set txtPlease = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtPlease)	
	Set txtInfo = "岁,为急性迟缓性麻痹（AFP）病例,请点击“确定”完成上报!如不是AFP病例,请点击“取消”继续!"
	Set txtInfo = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtInfo)	
	Set txtIntime = "请及时上报"
	Set txtIntime = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtIntime)	

	
	Set $ZT="CheckDiagToEpdErr"
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	// 过滤中医诊断
	Set BillFlag1=$p(+$g(^MRC("ID",+aICDDxID)),"^",13)
	Set BillFlag3=$p(+$g(^MRC("ID",+aICDDxID)),"^",15)
	Quit:((BillFlag3="Y")&&(BillFlag1'="Y")) return		// 过滤掉所有中医诊断
	
	Set Age=0
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	Set:BirthDay'="" Age=((+$h)-BirthDay)\365
	
	Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)
	//初诊(A)、复诊(R)标记
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	//ICD或关键字监控是否传染病
	Quit:$p(^MRC("ID",+aICDDxID),"^",15)="Y" return               //update 20210518 过滤中医诊断
	Set ICD10=$p($g(^MRC("ID",+aICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+aICDDxID)),"^",2)
	Set:aDiagNote'="" ICDDesc=ICDDesc_" "_aDiagNote
	Set DTYPCode = $p(^MRC("DTYP",aDiagType),"^",1)					//诊断类型Code
	Set DTYPDesc = $p(^MRC("DTYP",aDiagType),"^",2)					//诊断类型Desc
	//Quit:DTYPDesc="出院诊断" return //出院诊断不做检查
	
	Set ScreenList=##class(DHCMed.EPDService.SuspMRDiagnos).GetDiagCheck(ICD10,ICDDesc,Age)
	Quit:ScreenList="" return
	
    Set ThisTimeList=..getEpdThisTimeList(aEpisodeID)  //本次就诊传染病列表
    Set HistoryList=..getEpdHistoryList(aEpisodeID)    //除本次就诊外历史就诊已上报传染病列表
    Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set AFPAgeMax=+AFPAgeMax
	
    Set InfectList="",KindList=""
	For indS=1:1:$l(ScreenList,",") {
		Set ScreenID=$p(ScreenList,",",indS)
		Continue:ScreenID=""
		Set objDic = ##class(DHCMed.EPD.SuspScreening).GetObjById(ScreenID)
		Continue:'$Isobject(objDic)
		// 传染病诊断
		Set (InfectID,Infection)=""
	    If $Isobject(objDic.BTInfectDr.BTInfectDr){
		    Set InfectID = objDic.BTInfectDr.BTInfectDr.%Id()
		    Set Infection = objDic.BTInfectDr.BTInfectDr.MIFDisease
	    }
	    // 传染病分类
	    Set (KindCode,Kind)=""
	    If $Isobject(objDic.BTInfectDr.BTKindDr){
		    Set KindCode = objDic.BTInfectDr.BTKindDr.Code
		    Set Kind = objDic.BTInfectDr.BTKindDr.Description
	    }
	    Continue:KindCode=""
	    Continue:($listfind(ThisTimeList,KindCode)>0)  //本次就诊已报告的类型不重复提示	    
	    Continue:$listfind(InfectList,InfectID)>0 
		Set:InfectID'="" InfectList=InfectList_$lb(InfectID)	
		Continue:$listfind(KindList,KindCode)>0 
		Set KindList=KindList_$lb(KindCode)	  			
	}
	Quit:($ll(KindList)<1) return
	Set RetDesc="",RstList=""
    If ($ll(InfectList)>0) {   //先检查详细传染病诊断
   	    Set MIFKindFlg = ""
	    For indI=1:1:$ll(InfectList) {
    	  	Set InfectID=$lg(InfectList,indI)
			Continue:InfectID=""
	   		Set IFDiagnosMIFKind = $p($g(^DHCMed.EPDC("IF",InfectID)),"^",3)
			Continue:(MIFKindFlg=IFDiagnosMIFKind)		// 同类型的诊断只弹一次框 add by chenrui
			Set MIFKindFlg = IFDiagnosMIFKind
	    	Set retStr=$$CheckInfect(InfectID,IFDiagnosMIFKind)
			Continue:retStr=""
	    	Set RstList=RstList_retStr_$Char(1)
	    }
    }Else { //推荐到分类
   	    Set xIFRowID=0
   	    Set MIFKindFlg = ""
		For {
			Set xIFRowID=$o(^DHCMed.EPDC("IF",xIFRowID))
			Quit:xIFRowID=""
			Set IFDiagnosMIFKind = $p($g(^DHCMed.EPDC("IF",xIFRowID)),"^",3)
			Continue:($listfind(KindList,IFDiagnosMIFKind)<1)    //类型过滤
			Continue:(MIFKindFlg=IFDiagnosMIFKind)		// 同类型的诊断只弹一次框 add by chenrui
			Set MIFKindFlg = IFDiagnosMIFKind
			Set retStr=$$CheckInfect(xIFRowID,IFDiagnosMIFKind)
			Continue:retStr=""
			Set RstList=RstList_retStr_$Char(1)
    	}
	}
	Set:RstList'="" return=$e(RstList,1,$Length(RstList)-1)
	Quit return
	
CheckInfect(aInfectID,aKindCode)
	Set IFICD=$p($g(^DHCMed.EPDC("IF",aInfectID)),"^",1)
	Set IFDesc=$p($g(^DHCMed.EPDC("IF",aInfectID)),"^",2)
	Set IsActive=$p($g(^DHCMed.EPDC("IF",aInfectID)),"^",12)
	Quit:IsActive'="Y" return
	Set IsForceReport=$p($g(^DHCMed.EPDC("IF",aInfectID)),"^",13)  // 是否强制报卡
	Set IFRank=$p($g(^DHCMed.EPDC("IF",aInfectID)),"^",4)
	Set objIFRank=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICRANK",IFRank,"")
	Quit:'$IsObject(objIFRank) return
	Set IFRankDesc=objIFRank.Description
	Set:IFRankDesc'["传染病" IFRankDesc=IFRankDesc_"传染病"
	Set IFMulti=$p($g(^DHCMed.EPDC("IF",aInfectID)),"^",6)   //是否多次患病
    Set TimeLimit=$p($g(^DHCMed.EPDC("IF",aInfectID)),"^",8)   //重复上报时限时限
    Quit:(IFMulti="N")&&($listfind(HistoryList,aKindCode)>0) return //非多次患病不提示重复上报		    
    Set:(IFMulti="Y")&&(TimeLimit="") TimeLimit=1  //多次患病未维护重复报告时限，时限设为1
	Set RepDate=..GetRepDate(aEpisodeID,aKindCode)
	Set Days=(+$h)-RepDate   //上次上报距当前时间相差天数
	If ($listfind(HistoryList,KindCode)>0)&&(Days<=TimeLimit) { //计算时间差是否在上报时限内、有历史导入数据
		Set RetCode=0    //提示报卡 0为confirm提示，2为alert提示
		Set TipStr=","_txtReported
		Set RepDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	    Set TipStr = TipStr_","_txtDateReped_RepDate
		If (RepDate="99999") {    //存在历史导入数据
		    Set TipStr=",<font style='color:red;'>"_txtHistory_"</font>"
	    }
		If IFRankDesc["甲类" {
			Set RetDesc=IFDesc_","_txtBy_IFRankDesc_TipStr_","_txtRepeat_"?"
		}ElseIf IFRankDesc["AFP" {
			Set RetDesc=IFDesc_","_txtTwoMonth_AFPAgeMax_txtINfo_","_TipStr_","_txtRepeat_"?"					
		}Else{
			Set RetDesc=IFDesc_","_txtBy_IFRankDesc_TipStr_","_txtRepeat_"?"
		}
	}Else{
		Set RetCode=1    //强制报卡
		Set:IsForceReport="N" RetCode=0  //提示报卡
		
		Set Info="<span style='font-weight:600;'><font style='color:red;'></br>"_txtCare_"</font></span>"
		If IFRankDesc["甲类" {
			//需求806470
			Set RetDesc=IFDesc_","_txtBy_IFRankDesc_","_txtPlease_"!"_Info
		}ElseIf IFRankDesc["AFP" {
			Set RetCode=0    //提示报卡
			Set RetDesc=IFDesc_","_txtTwoMonth_AFPAgeMax_txtInfo
		}Else{
			Set RetDesc=IFDesc_","_txtBy_IFRankDesc_","_txtIntime_"!"_Info
		}
	}
	Set RetDesc=$tr(RetDesc,";","")		//将RetDesc字符串中;全部替换为""	
	Quit:RetDesc="" return
	Set return=RetCode_"^"_aInfectID_"^"_RetDesc
	Quit return

CheckDiagToEpdErr	
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2020-08-04
/// Description:  To医生站传染病强制或提示报卡接口
///               根据就诊号判断是否传染病未上报患者
///               未上报,弹出传染病报告卡,强制报卡
///               已上报,强制上报期限内弹出传染病报告卡,提示报卡(本次就诊已报，不提示)，超出强制上报期限弹出传染病报告卡,强制报卡
///               甲类传染病、甲类管理的乙类传染病,给出特殊提示
///               AFP传染病,给出特殊提示
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(DHCMed.EPDService.Service).CheckDiagnosToEpdNew("256","3","4","")
ClassMethod CheckDiagnosToEpdNew(aEpisodeID As %String, aDiagType As %String, aICDDxID As %String, aDiagNote As %String) As %String
{
	New (aEpisodeID,aDiagType,aICDDxID,aDiagNote)
	Set return=""
	Quit:(aEpisodeID="")||(aDiagType="")||((aICDDxID="")&&(aDiagNote="")) return
		
	Set $ZT="CheckDiagnosToEpdNewErr"
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set Age=0
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	Set:BirthDay'="" Age=((+$h)-BirthDay)\365
	
	Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)
	//初诊(A)、复诊(R)标记
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	//ICD或关键字监控是否传染病
	Set ICD10=$p($g(^MRC("ID",+aICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+aICDDxID)),"^",2)
	Set:aDiagNote'="" ICDDesc=ICDDesc_" "_aDiagNote
	Set DTYPCode = $p(^MRC("DTYP",aDiagType),"^",1)					//诊断类型Code
	Set DTYPDesc = $p(^MRC("DTYP",aDiagType),"^",2)					//诊断类型Desc
	//Quit:DTYPDesc="出院诊断" return //出院诊断不做检查
    
	Set DiagnosDescList="",CtlRstList=""
	Set IFRowID=0
	For {
		Set IFRowID=$o(^DHCMed.EPDC("IF",IFRowID))
		Quit:IFRowID=""
		Continue:$listfind(CtlRstList,IFRowID)>0
		Set IFICD=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",1)
		Set IsActive=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",12)
		Continue:IsActive'="Y"
		
		//1通过传染病诊断ICD检索是否传染病
		Set:ICD10=IFICD CtlRstList=CtlRstList_$lb(IFRowID)
		//2通过关键字检索是否传染病(检索关键字维护在别名表中,类型为1)
		Set IFAliasID=""
		For {
			Set IFAliasID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID))
			Quit:IFAliasID=""
			Quit:$listfind(CtlRstList,IFRowID)>0
			Set IFAlias=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",1)
			Set IsKeyAlias=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",2)
			Continue:IsKeyAlias'=1  //关键词检索
			//**************************************************
			//update by zf 2011-09-27
			Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IFAlias,"T"))
			Set IFAlias3ID=0,IsAlias3="Y"
			For {
				Set IFAlias3ID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID))
				Quit:IFAlias3ID=""
				Quit:$listfind(CtlRstList,IFRowID)>0
				Set IFAlias3=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID)),"^",1)
				Set IsKeyAlias3=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID)),"^",2)
				Continue:IsKeyAlias3'=3  //关键词过滤
				Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IFAlias3,"T"))
				Set IsAlias3="N"
			}
			Continue:IsAlias3="N"
			Set CtlRstList=CtlRstList_$lb(IFRowID)
			//**************************************************
		}
		//3通过ICD检索是否传染病(检索ICD维护在别名表中,类型为2)
		Set IFAliasID=""
		For {
			Set IFAliasID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID))
			Quit:IFAliasID=""
			Quit:$listfind(CtlRstList,IFRowID)>0
			Set IFAlias=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",1)
			Set IsKeyAlias=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",2)
			Continue:IsKeyAlias'=2
			Set:ICD10[IFAlias CtlRstList=CtlRstList_$lb(IFRowID)	//update by liuyh 2016-09-23 把等于改成包含
		}
	}

	Set ThisTimeList=..getEpdThisTimeList(aEpisodeID)  //本次就诊传染病列表
	Set HistoryList=..getEpdHistoryList(aEpisodeID)    //除本次就诊外历史就诊已上报传染病列表
	Set DiagnosDescList=HistoryList
	//根据条件设置返回值和提示代码
	Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set AFPAgeMax=+AFPAgeMax
	Set RetCode="",RetDesc=""
	For IFIndex=1:1:$listlength(CtlRstList) {
		Quit:return'=""
		Set IFRowID=$list(CtlRstList,IFIndex)
		Set IFICDCode=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",1)
		Set IFDesc=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",2)
		Set IsActive=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",12)
		Continue:IsActive'="Y"
		
		// 获取诊断大类的唯一Code,实际取出DHCMed.EPD.Infection类中MIFKind属性值 等价于 获取DHCMed.SS.Dictionary类中Code属性值
		// 例如：梅毒大类ID为18
		Set IFDiagnosMIFKind = $p($g(^DHCMed.EPDC("IF",IFRowID)),"^",3)	
		Continue:($listfind(ThisTimeList,IFDiagnosMIFKind)>0)  //add 2020-08-04本次就诊已报告的类型不重复提示
				
		Set IFRank=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",4)
		Set objIFRank=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICRANK",IFRank,"")
		Continue:'$IsObject(objIFRank)
		Set IFRankDesc=objIFRank.Description
		Set:IFRankDesc'["传染病" IFRankDesc=IFRankDesc_"传染病"
		Set IFMulti=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",6)   //是否多次患病
	    Set TimeLimit=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",8)   //重复上报时限时限
	    Continue:(IFMulti="N")&&($listfind(DiagnosDescList,IFDiagnosMIFKind)>0)  //非多次患病不提示重复上报
	    Set:(IFMulti="Y")&&(TimeLimit="") TimeLimit=1  //多次患病未维护重复报告时限，时限设为1
		Set RepDate=..GetRepDate(aEpisodeID,IFDiagnosMIFKind)
		Set Days=(+$h)-RepDate   //上次上报距当前时间相差天数
		If ($listfind(DiagnosDescList,IFDiagnosMIFKind)>0)&&(Days<=TimeLimit) { //计算时间差是否在上报时限内
			Set RetCode=0    //提示报卡 0为confirm提示，2为alert提示
			If IFRankDesc["甲类" {
				Set RetDesc=IFDesc_",为"_IFRankDesc_",此传染病已上报过,无需重复上报!您确认需要重复上报吗?"
			}ElseIf IFRankDesc["AFP" {
				If (Age <=AFPAgeMax) {
					Set RetDesc=IFDesc_",发病时间在2个月内,且患者年龄小于等于"_AFPAgeMax_"岁,为急性迟缓性麻痹（AFP）病例,此病例已上报过,无需重复上报,您确认需要重复上报吗?"
				}
			}Else{
				Set RetDesc=IFDesc_",为"_IFRankDesc_",此传染病已上报过,无需重复上报,您确认需要重复上报吗?"
			}
		}Else{
			Set RetCode=1    //强制报卡
			Set Info="<span style='font-weight:600;'><font style='color:red;'></br>注意：法定传染病不填报传染病报告，不允许保存诊断！</font></span>"
			If IFRankDesc["甲类" {
				//需求806470
				Set RetDesc=IFDesc_",为"_IFRankDesc_",请上报!"_Info
			}ElseIf IFRankDesc["AFP" {
				Set RetCode=0    //提示报卡
				If (Age <= AFPAgeMax) {
					//需求806470
					Set RetDesc=IFDesc_",发病时间在2个月内,且患者年龄小于等于"_AFPAgeMax_"岁,为急性迟缓性麻痹（AFP）病例,请点击“确定”完成上报!如不是AFP病例,请点击“取消”继续!"
				}
			}Else{
				Set RetDesc=IFDesc_",为"_IFRankDesc_",请及时上报!"_Info
			}
		}
			
		Set RetDesc=$tr(RetDesc,";","")		//将RetDesc字符串中;全部替换为""
		Continue:RetDesc=""
		Set return=return_RetCode_"^"_IFRowID_"^"_RetDesc
	}
	
	Quit return
	
CheckDiagnosToEpdNewErr
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2020-08-04
/// Description:  取患者本次就诊传染病分类列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
/// w ##class(DHCMed.EPDService.Service).getEpdThisTimeList(aEpisodeID)
ClassMethod getEpdThisTimeList(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set DiagnosList=""		
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,xRepID))
		Quit:xRepID=""
		Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:objRep.MEPDStatus="4"  //被订状态报告无效
		Continue:objRep.MEPDStatus="6"  //草稿状态报告无效   //本次就诊是否需要判断草稿状态？
		Continue:objRep.MEPDStatus="7"  //删除状态报告无效
		Continue:'$IsObject(objRep.MEPDICDDR)
		Set IFKind=objRep.MEPDICDDR.MIFKind		//传染病诊断大类DHCMed.EPD.Infection中MIFKind属性值
		Continue:IFKind=""
		set IsActive=objRep.MEPDICDDR.MIFIsActive    
		Continue:IsActive'="Y"
		
		Continue:$listfind(DiagnosList,IFKind)>0   //重复报卡过滤
		Set DiagnosList=DiagnosList_$lb(IFKind)
	}
	
	Set return=DiagnosList
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-08-04
/// Description:  取患者除本次就诊外的历史就诊传染病分类列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
/// w ##class(DHCMed.EPDService.Service).getEpdHistoryList(aEpisodeID)
ClassMethod getEpdHistoryList(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set (AdmLoc,HospID,lastAdmLoc,lastHospID) = ""
	Set EpdPopupIsCurrAdmHosp = +##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpdPopupIsCurrAdmHosp","")	// 传染病诊断弹窗过滤非本就诊院区历史报告的数据
	if (EpdPopupIsCurrAdmHosp="1"){
		Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
		Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)
	}
	
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	Set DiagnosList=""
	Set AdmType=""
	For {
		Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
		Quit:AdmType=""
		
		Set Paadm=0
		For {
			Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
			Quit:Paadm=""
			Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
			Continue:VisitStatus="C"  //取消就诊
			Continue:Paadm=aEpisodeID   //本次就诊不计入
			
			Set RepID=0
			For {
				Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",Paadm,RepID))
				Quit:RepID=""
				Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.MEPDStatus="4"  //被订状态报告无效
				Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
				Continue:objRep.MEPDStatus="7"  //删除状态报告无效
				Continue:'$IsObject(objRep.MEPDICDDR)

				Set IFKind=objRep.MEPDICDDR.MIFKind		//传染病诊断大类DHCMed.EPD.Infection中MIFKind属性值
				Continue:IFKind=""
				set IsActive=objRep.MEPDICDDR.MIFIsActive   
				Continue:IsActive'="Y"
				
				if (EpdPopupIsCurrAdmHosp="1"){
					Set LastAdmLoc=+$p($g(^PAADM(+Paadm)),"^",4)
					Set LastHospID=+$p($g(^CTLOC(+LastAdmLoc)),"^",22)
					Continue:HospID'=LastHospID
				}
				Continue:$listfind(DiagnosList,IFKind)>0   //重复报卡过滤
				Set DiagnosList=DiagnosList_$lb(IFKind)
			}
		}
	}
	
	Set objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPat) ""
	Set PatientName=objPat.PatientName
	Set Birthday=objPat.Birthday
	Set PersonalID=objPat.PersonalID
	Set PatientName=$$ALPHAUP^SSUTIL4(PatientName)
	If PersonalID'=""
	{
		Quit:'$d(^PAPERi("PAPER_PatName",PatientName)) ""
		Set papmi=""
		For {
			Set papmi=$o(^PAPERi("PAPER_PatName",PatientName,papmi))
			Quit:papmi=""				
			Continue:papmi=PatientID
			
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(papmi)
			Continue:'$IsObject(objPatient)
	
			Set PatName=objPatient.PatientName
			Set PatBirthday=objPatient.Birthday
			Set PatPersonalID=objPatient.PersonalID
		
			Continue:(PatPersonalID="")||(PatPersonalID'=PersonalID)
			
			Set AdmType=""
			For {
				Set AdmType=$o(^PAPERdr(papmi,"ADM",AdmType))
				Quit:AdmType=""
				Set Paadm=0
				For {
					Set Paadm=$o(^PAPERdr(papmi,"ADM",AdmType,Paadm))
					Quit:Paadm=""
					Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
					Continue:VisitStatus="C"  //取消就诊
					Set RepID=0
					For {
						Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",Paadm,RepID))
						Quit:RepID=""
						Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
						Continue:'$IsObject(objRep)
						Continue:objRep.MEPDStatus="4"  //被订状态报告无效
						Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
						Continue:objRep.MEPDStatus="7"  //删除状态报告无效
						Continue:'$IsObject(objRep.MEPDICDDR)
						
						Set IFKind=objRep.MEPDICDDR.MIFKind		//传染病诊断大类DHCMed.EPD.Infection中MIFKind属性值
						Continue:IFKind=""
						set IsActive=objRep.MEPDICDDR.MIFIsActive    //shp
						Continue:IsActive'="Y"
						Continue:$listfind(DiagnosList,IFKind)>0   //重复报卡过滤
						Set DiagnosList=DiagnosList_$lb(IFKind)
					}
				}
			}
		}
	}
	
	//查询从老系统中导入的数据
	Set xRowID=""
	For {
   		Set xRowID=$o(^MA.EPD.ImportReportI("IndexPersonId"," "_PatientName,Birthday," "_PersonalID,xRowID))
   		Quit:xRowID=""
   		
   		Set objRep = ##class(DHCMed.EPD.ImportReport).GetObjById(xRowID)
		Continue:'$IsObject(objRep)
			
		Set DiseaseName = objRep.DiseaseName
		Set DiseaseKind = objRep.DiseaseKind
		
		Set xDicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," EPDEMICTYPE"," "_DiseaseKind,0))
		Continue:xDicID=""
		Set DicInfo =$g(^DHCMed.SS.DictionaryD(xDicID))
		Set IFKind = $lg(DicInfo,3)
			
		Continue:$listfind(DiagnosList,IFKind)>0   //重复报卡过滤
		Set DiagnosList=DiagnosList_$lb(IFKind)	
	}
	
	Set return=DiagnosList
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-08-04
/// Description:  To医生站传染病强制或提示报卡接口
///               根据就诊号判断是否传染病未上报患者
///               未上报,弹出传染病报告卡,强制报卡
///               已上报,弹出传染病报告卡,提示报卡
///               甲类传染病、甲类管理的乙类传染病,给出特殊提示(电话通知传染管理科)
///               AFP传染病,给出特殊提示(多长时间内上报,并电话通知传染管理科)
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(DHCMed.EPDService.Service).CheckDiagnosToEpd(1764)
ClassMethod CheckDiagnosToEpd(aEpisodeID As %String, MRDiagnosRowid As %String) As %String
{
	New (aEpisodeID,MRDiagnosRowid)
	Set return=""
	Quit:(aEpisodeID="")||(MRDiagnosRowid="") return
		
	Set $ZT="CheckDiagnosToEpdErr"
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set Age=0
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	Set:BirthDay'="" Age=((+$h)-BirthDay)\365
	
	Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)
	//初诊(A)、复诊(R)标记
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	//登记号
	Set objPatient=##Class(DHCMed.Base.Patient).GetObjById(PatientID)
	Set PapmiNo=objPatient.PapmiNo
	//ICD或关键字监控是否传染病
	//Set DiagnosID=$o(^MR(MRAdm,"DIA",""),-1)
	Set DiagnosID=$p(MRDiagnosRowid,"||",2) //传入诊断记录ID
	Quit:(+DiagnosID=0) return
	
	Set tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
	Set ICDDxID=$p(tmpDiagnos,"^",1)
	Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",DiagnosID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",DiagnosID,"DHC",1))
	Set DiagPrefix=$p($g(^MR(MRAdm,"DIA",DiagnosID,1)),"^",26)    //诊断前缀 add 2020-09-17
	Set:DiagPrefix'="" ICDDesc=DiagPrefix_" "_ICDDesc
	Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
	Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
 	
	Set DiagnosDescList="",CtlRstList=""
	Set IFRowID=0
	For {
		Set IFRowID=$o(^DHCMed.EPDC("IF",IFRowID))
		Quit:IFRowID=""
		Continue:$listfind(CtlRstList,IFRowID)>0
		Set IFICD=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",1)
		//update by shp 是否有效数据
		Set IsActive=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",12)
		Continue:IsActive'="Y"
		//1通过传染病诊断ICD检索是否传染病
		Set:ICD10=IFICD CtlRstList=CtlRstList_$lb(IFRowID)
		//2通过关键字检索是否传染病(检索关键字维护在别名表中,类型为1)
		Set IFAliasID=""
		For {
			Set IFAliasID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID))
			Quit:IFAliasID=""
			Quit:$listfind(CtlRstList,IFRowID)>0
			Set IFAlias=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",1)
			Set IsKeyAlias=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",2)
			Continue:IsKeyAlias'=1  //关键词检索
			//**************************************************
			//update by zf 2011-09-27
			Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IFAlias,"T"))
			Set IFAlias3ID=0,IsAlias3="Y"
			For {
				Set IFAlias3ID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID))
				Quit:IFAlias3ID=""
				Quit:$listfind(CtlRstList,IFRowID)>0
				Set IFAlias3=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID)),"^",1)
				Set IsKeyAlias3=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID)),"^",2)
				Continue:IsKeyAlias3'=3  //关键词过滤
				Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IFAlias3,"T"))
				Set IsAlias3="N"
			}
			Continue:IsAlias3="N"
			Set CtlRstList=CtlRstList_$lb(IFRowID)
			//**************************************************
		}
		//3通过ICD检索是否传染病(检索ICD维护在别名表中,类型为2)
		Set IFAliasID=""
		For {
			Set IFAliasID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID))
			Quit:IFAliasID=""
			Quit:$listfind(CtlRstList,IFRowID)>0
			Set IFAlias=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",1)
			Set IsKeyAlias=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",2)
			Continue:IsKeyAlias'=2
			Set:ICD10[IFAlias CtlRstList=CtlRstList_$lb(IFRowID)	//update by liuyh 2016-09-23 把等于改成包含
		}
	}
	
	//已上报传染病列表
	Set DiagnosList=..getEpdList(aEpisodeID)
	Set DiagnosDescList=DiagnosList
	/*
	For DiagnosIndex=1:1:$listlength(DiagnosList) {
		Set Diagnos=$list(DiagnosList,DiagnosIndex)
		Continue:Diagnos=""
		Set objDiagnos=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",Diagnos,"")
		Continue:'$IsObject(objDiagnos)
		Set DiagnosDesc=objDiagnos.Description
		Set DiagnosDescList=DiagnosDescList_$lb(DiagnosDesc)
	}
	*/
	
	//根据条件设置返回值和提示代码
	Set Tel1=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicTel1",HospID)
	Set Tel2=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicTel2",HospID)
	Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set AFPAgeMax=+AFPAgeMax
	
	Set RetCode="",RetDesc=""
	For IFIndex=1:1:$listlength(CtlRstList) {
		Quit:return'=""
		Set IFRowID=$list(CtlRstList,IFIndex)
		
		//************************************//
		// Add By PanLei 2013-01-09
		// 获取传染病疾病字典主ICD
		Set IFICDCode=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",1)
		//************************************//
		
		Set IFDesc=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",2)
		//update by shp 是否有效数据
		Set IsActive=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",12)
		Continue:IsActive'="Y"
		
		// 获取诊断大类的唯一Code,实际取出DHCMed.EPD.Infection类中MIFKind属性值 等价于 获取DHCMed.SS.Dictionary类中Code属性值
		// 例如：梅毒大类ID为18
		Set IFDiagnosMIFKind = $p($g(^DHCMed.EPDC("IF",IFRowID)),"^",3)
		Set IFRank=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",4)
		Set objIFRank=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICRANK",IFRank,"")
		Continue:'$IsObject(objIFRank)
		Set IFRankDesc=objIFRank.Description
		Set:IFRankDesc'["传染病" IFRankDesc=IFRankDesc_"传染病"
		Set RetDesc=""
		Set IFMulti=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",6)   //是否多次患病
	    Set TimeLimit=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",8)   //重复上报时限时限
	    Continue:(IFMulti="N")&&($listfind(DiagnosDescList,IFDiagnosMIFKind)>0)  //非多次患病不提示重复上报
	    Set:(IFMulti="Y")&&(TimeLimit="") TimeLimit=1  //多次患病未维护重复报告时限，时限设为1
		Set RepDate=..GetRepDate(aEpisodeID,IFDiagnosMIFKind)
		Set Days=(+$h)-RepDate   //上次上报距当前时间相差天数
		If ($listfind(DiagnosDescList,IFDiagnosMIFKind)>0)&&(Days<=TimeLimit) { //计算时间差是否在上报时限内
			Set RetCode=0    //提示报卡 0为confirm提示，2为alert提示
			Set RepDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
			Set TipStr = ",最近一次上报时间为"_RepDate
			If IFRankDesc["甲类" {
				Set RetDesc=IFDesc_",为"_IFRankDesc_TipStr_",此传染病已上报过,无需重复上报!您确认需要重复上报吗?"
			}ElseIf IFRankDesc["AFP" {
				If (Age <=AFPAgeMax) {
					Set RetDesc=IFDesc_",发病时间在2个月内,且患者年龄小于等于"_AFPAgeMax_"岁,为急性迟缓性麻痹（AFP）病例,此病例已上报过"__TipStr_",无需重复上报,您确认需要重复上报吗?"
				}
			}Else{
				Set RetDesc=IFDesc_",为"_IFRankDesc_",此传染病已上报过"__TipStr_",无需重复上报,您确认需要重复上报吗?"
			}
		}Else{
			Set RetCode=1    //强制报卡
			If IFRankDesc["甲类" {
				//需求806470
				Set RetDesc=IFDesc_",为"_IFRankDesc_",请上报!"
				//Set RetDesc=IFDesc_",为"_IFRankDesc_",立即电话通知（工作日通知疾控办-"_Tel1_",夜间或节假日通知总值班-"_Tel2_"）,请务必在2小时内完成上报!"
			}ElseIf IFRankDesc["AFP" {
				Set RetCode=0    //提示报卡
				If (Age <= AFPAgeMax) {
					//需求806470
					//Set RetDesc=IFDesc_",发病时间在2个月内,且患者年龄小于等于"_AFPAgeMax_"岁,为急性迟缓性麻痹（AFP）病例,应立即电话通知（工作日通知疾控办-"_Tel1_",夜间或节假日通知总值班-"_Tel2_"）,请点击“确定”,在4小时内完成上报!如不是AFP病例,请点击“取消”继续!"
					Set RetDesc=IFDesc_",发病时间在2个月内,且患者年龄小于等于"_AFPAgeMax_"岁,为急性迟缓性麻痹（AFP）病例,请点击“确定”完成上报!如不是AFP病例,请点击“取消”继续!"
				}
			}Else{
				Set RetDesc=IFDesc_",为"_IFRankDesc_",请及时上报!"
			}
		}
		Set RetDesc=$tr(RetDesc,";","")		//将RetDesc字符串中;全部替换为""
		Continue:RetDesc=""
		Set return=return_RetCode_"^"_IFRowID_"^"_RetDesc
	}
	
	Quit return
	
CheckDiagnosToEpdErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2011-08-16
/// Description:  To医生站传染病强制未报卡删除诊断接口
/// Table：       
/// Input：       EpisodeID:    User.PAADM
///               MRDiagnosID:  User.MRDiagons
/// Return：      
/// w ##class(DHCMed.EPDService.Service).DeleteDiagnosToEpd(74362)
ClassMethod DeleteDiagnosToEpd(aEpisodeID As %String, aMRDiagnosID As %String) As %String
{
	New (aEpisodeID,aMRDiagnosID)
	Set return=-1
	Quit:(aEpisodeID="")||(aMRDiagnosID="") return
	
	If aMRDiagnosID'="" {
		Set MRAdm=+$p(aMRDiagnosID,"||",1)
		Set ChildSub=+$p(aMRDiagnosID,"||",2)
		Quit:(+ChildSub=0)||(+MRAdm=0) return
	}Else{
		Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
		Quit:MRAdm="" return
		Set ChildSub=$o(^MR(MRAdm,"DIA",""),-1)
		Quit:(+ChildSub=0) return
	}
	&SQL(DELETE FROM SQLUser.MR_Diagnos WHERE MRDIA_MRADM_ParRef=:MRAdm AND MRDIA_Childsub=:ChildSub)
	Quit SQLCODE
}

/// Creator：     zhufei
/// CreatDate：   2011-08-04
/// Description:  取患者传染病分类列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
/// w ##class(DHCMed.EPDService.Service).getEpdList(aEpisodeID)
ClassMethod getEpdList(aEpisodeID As %String, IsChronicByAdm As %String = "") As %String
{
	New (aEpisodeID,IsChronicByAdm)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	Set DiagnosList=""
	Set AdmType=""
	For {
		Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
		Quit:AdmType=""
		Set Paadm=0
		For {
			Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
			Quit:Paadm=""
			Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
			Continue:VisitStatus="C"  //取消就诊
			
			//^DHCMed.EPDi("EPD",0,"EpisodeID",74362,1)
			Set RepID=0
			For {
				Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",Paadm,RepID))
				Quit:RepID=""
				Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.MEPDStatus="4"  //被订状态报告无效
				Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
				Continue:objRep.MEPDStatus="7"  //删除状态报告无效
				Continue:'$IsObject(objRep.MEPDICDDR)
				//Set Diagnos=objRep.MEPDICDDR.MIFKind  //传染病分类名称
				//Set Diagnos=objRep.MEPDICDDR.MIFDisease  //传染病诊断名称
				
				// Modified By PanLei 2013-03-06
				// FixBug: 传染病诊断报卡,除病毒性肝炎需要判断甲、乙、丙、戊、未分型以外,其余均只需判断所属大类是否上报即可
				Set IFKind=objRep.MEPDICDDR.MIFKind		//传染病诊断大类DHCMed.EPD.Infection中MIFKind属性值
				Continue:IFKind=""
				set IsActive=objRep.MEPDICDDR.MIFIsActive    //shp
				Continue:IsActive'="Y"
				Set IsChronic=objRep.MEPDICDDR.MIFIsChronic    // 是否为慢性传染病
				// IsChronicByAdm="1" 是慢性病时只计算本次就诊的传染病
				if (IsChronicByAdm="1"){
					// 非慢性传染病，根据本次就诊是否填报传染病报告为依据
					Continue:((IsChronic="N")&&(Paadm'=aEpisodeID))
				}
				
				Continue:$listfind(DiagnosList,IFKind)>0   //重复报卡过滤
				Set DiagnosList=DiagnosList_$lb(IFKind)
			}
		}
	}
	
	//add by lyh 2013-2-4 for 一个患者不同登记号,显示传染病未报
	Set objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPat) ""
	Set PatientName=objPat.PatientName
	Set Birthday=objPat.Birthday
	Set PersonalID=objPat.PersonalID
	Set PatientName=$$ALPHAUP^SSUTIL4(PatientName)
	Set PersonalID=$$ALPHAUP^SSUTIL4(PersonalID)
	if PersonalID'=""
	{
		Quit:'$d(^PAPERi("PAPMI_ICPPBC",PersonalID_"Z")) ""
		Set papmi=""
		For {
			Set papmi=$o(^PAPERi("PAPMI_ICPPBC",PersonalID_"Z",papmi))
			Quit:papmi=""	
			
			Continue:papmi=PatientID
			
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(papmi)
			Continue:'$IsObject(objPatient)
		
			Set PatName=objPatient.PatientName
			Set PatBirthday=objPatient.Birthday
			Set PatPersonalID=objPatient.PersonalID
		
			Continue:(PatPersonalID="")||(PatPersonalID'=PersonalID)
			
			Set AdmType=""
			For {
				Set AdmType=$o(^PAPERdr(papmi,"ADM",AdmType))
				Quit:AdmType=""
				Set Paadm=0
				For {
					Set Paadm=$o(^PAPERdr(papmi,"ADM",AdmType,Paadm))
					Quit:Paadm=""
					Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
					Continue:VisitStatus="C"  //取消就诊
			
					//^DHCMed.EPDi("EPD",0,"EpisodeID",74362,1)
					Set RepID=0
					For {
						Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",Paadm,RepID))
						Quit:RepID=""
						Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
						Continue:'$IsObject(objRep)
						Continue:objRep.MEPDStatus="4"  //被订状态报告无效
						Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
						Continue:objRep.MEPDStatus="7"  //删除状态报告无效
						Continue:'$IsObject(objRep.MEPDICDDR)
						//Set Diagnos=objRep.MEPDICDDR.MIFKind  //传染病分类名称
						//Set Diagnos=objRep.MEPDICDDR.MIFDisease  //传染病诊断名称
						
						// Modified By PanLei 2013-03-06
						// FixBug: 传染病诊断报卡,除病毒性肝炎需要判断甲、乙、丙、戊、未分型以外,其余均只需判断所属大类是否上报即可
						Set IFKind=objRep.MEPDICDDR.MIFKind		//传染病诊断大类DHCMed.EPD.Infection中MIFKind属性值
						Continue:IFKind=""
						set IsActive=objRep.MEPDICDDR.MIFIsActive    //shp
						Continue:IsActive'="Y"
				
						
						/*
						Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",IFKind,"")
						Set:$IsObject(objDic) IFKind=objDic.Description
						Set:IFKind="AFP" Diagnos=Diagnos_"(AFP)"
						*/
						
						Continue:$listfind(DiagnosList,IFKind)>0   //重复报卡过滤
						Set DiagnosList=DiagnosList_$lb(IFKind)
					}
				}
			}
		}
	}
    Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)                 // 姓名
	Set IdentityCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)            // 身份证号码
	Quit:IdentityCode="" DiagnosList
    Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)                // 出生日期
    	
	//查询从老系统中导入的数据
	Set xRowID=""
	For {
   		Set xRowID=$o(^MA.EPD.ImportReportI("IndexPersonId"," "_$ZCVT(PatName,"U"),Birthday," "_$ZCVT(PersonalID,"U"),xRowID))
   		Quit:xRowID=""
   		Set objRep = ##class(DHCMed.EPD.ImportReport).GetObjById(xRowID)
		Continue:'$IsObject(objRep)
			
		Set DiseaseName = objRep.DiseaseName
		Set DiseaseKind = objRep.DiseaseKind
		
		Set xDicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," EPDEMICTYPE"," "_DiseaseKind,0))
		Continue:xDicID=""
		Set DicInfo =$g(^DHCMed.SS.DictionaryD(xDicID))
		Set IFKind = $lg(DicInfo,3)
			
		Continue:$listfind(DiagnosList,IFKind)>0   //重复报卡过滤
		Set DiagnosList=DiagnosList_$lb(IFKind)	
	}
	
	Set return=DiagnosList
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-08-04
/// Description:  取患者传染病分类列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
/// w ##class(DHCMed.EPDService.Service).getEpdDescList(aEpisodeID)
ClassMethod getEpdDescList(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	Set DiagnosList=""
	Set AdmType=""
	For {
		Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
		Quit:AdmType=""
		Set Paadm=0
		For {
			Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
			Quit:Paadm=""
			Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
			Continue:VisitStatus="C"  //取消就诊
			
			//^DHCMed.EPDi("EPD",0,"EpisodeID",74362,1)
			Set RepID=0
			For {
				Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",Paadm,RepID))
				Quit:RepID=""
				Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.MEPDStatus="4"  //被订状态报告无效
				Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
				Continue:objRep.MEPDStatus="7"  //删除状态报告无效
				Continue:'$IsObject(objRep.MEPDICDDR)
				//Set Diagnos=objRep.MEPDICDDR.MIFKind  //传染病分类名称
				//Set Diagnos=objRep.MEPDICDDR.MIFDisease  //传染病诊断名称
				
				// Modified By PanLei 2013-03-06
				// FixBug: 传染病诊断报卡,除病毒性肝炎需要判断甲、乙、丙、戊、未分型以外,其余均只需判断所属大类是否上报即可
				Set Diagnos=objRep.MEPDICDDR.MIFDisease		//传染病诊断大类DHCMed.EPD.Infection中MIFKind属性值
				Continue:Diagnos=""
				set IsActive=objRep.MEPDICDDR.MIFIsActive    //shp
				Continue:IsActive'="Y"
				
				Set MIFKind=""
				Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",objRep.MEPDICDDR.MIFKind,"")
				Set:$IsObject(objDic) MIFKind=objDic.Description
				Set:MIFKind="AFP" Diagnos=Diagnos_"(AFP)"
				
				Continue:$listfind(DiagnosList,Diagnos)>0   //重复报卡过滤
				Set DiagnosList=DiagnosList_$lb(Diagnos)
			}
		}
	}
	
	//add by lyh 2013-2-4 for 一个患者不同登记号,显示传染病未报
	Set objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPat) ""
	Set PatientName=objPat.PatientName
	Set Birthday=objPat.Birthday
	Set PersonalID=objPat.PersonalID
	Set PatientName=$$ALPHAUP^SSUTIL4(PatientName)
	if PersonalID'=""
	{
		Quit:'$d(^PAPERi("PAPER_PatName",PatientName)) ""
		Set papmi=""
		For {
			Set papmi=$o(^PAPERi("PAPER_PatName",PatientName,papmi))
			Quit:papmi=""	
			
			Continue:papmi=PatientID
			
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(papmi)
			Continue:'$IsObject(objPatient)
		
			Set PatName=objPatient.PatientName
			Set PatBirthday=objPatient.Birthday
			Set PatPersonalID=objPatient.PersonalID
		
			Continue:(PatPersonalID="")||(PatPersonalID'=PersonalID)
			
			Set AdmType=""
			For {
				Set AdmType=$o(^PAPERdr(papmi,"ADM",AdmType))
				Quit:AdmType=""
				Set Paadm=0
				For {
					Set Paadm=$o(^PAPERdr(papmi,"ADM",AdmType,Paadm))
					Quit:Paadm=""
					Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
					Continue:VisitStatus="C"  //取消就诊
			
					//^DHCMed.EPDi("EPD",0,"EpisodeID",74362,1)
					Set RepID=0
					For {
						Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",Paadm,RepID))
						Quit:RepID=""
						Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
						Continue:'$IsObject(objRep)
						Continue:objRep.MEPDStatus="4"  //被订状态报告无效
						Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
						Continue:objRep.MEPDStatus="7"  //删除状态报告无效
						Continue:'$IsObject(objRep.MEPDICDDR)
						//Set Diagnos=objRep.MEPDICDDR.MIFKind  //传染病分类名称
						//Set Diagnos=objRep.MEPDICDDR.MIFDisease  //传染病诊断名称
						
						// Modified By PanLei 2013-03-06
						// FixBug: 传染病诊断报卡,除病毒性肝炎需要判断甲、乙、丙、戊、未分型以外,其余均只需判断所属大类是否上报即可
						Set Diagnos=objRep.MEPDICDDR.MIFDisease		//传染病诊断大类DHCMed.EPD.Infection中MIFKind属性值
						Continue:Diagnos=""
						set IsActive=objRep.MEPDICDDR.MIFIsActive    //shp
						Continue:IsActive'="Y"
						
						Set MIFKind=""
						Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",objRep.MEPDICDDR.MIFKind,"")
						Set:$IsObject(objDic) MIFKind=objDic.Description
						Set:MIFKind="AFP" Diagnos=Diagnos_"(AFP)"
						
						Continue:$listfind(DiagnosList,Diagnos)>0   //重复报卡过滤
						Set DiagnosList=DiagnosList_$lb(Diagnos)
					}
				}
			}
		}
	}
	
	Set return=DiagnosList
	Quit return
}

/// Creator：     wuqk
/// CreatDate：   2012-09-13
/// Description:  取患者传染病报告的相关信息
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List 如果有多份报告，通过 rep1=$li(ret,1)/rep2$li(ret,2)/....获取
/// rep 也是一个%List，每个字段的格式参见 DHCMed.EPDService.EpidemicSrv.BuildQryEpidemic 的定义
/// w ##class(DHCMed.EPDService.Service).getEpdInfoByAdm(aEpisodeID)
ClassMethod getEpdInfoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	//Quit:PatientID="" return
	
	
	//^DHCMed.EPDi("EPD",0,"EpisodeID",
	
	Quit:'$d(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID)) return
	
	//^DHCMed.EPDi("EPD",0,"EpisodeID",74362,1)
	Set RepID=0
	For {
		Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,RepID))
		Quit:RepID=""
		Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
		Continue:'$IsObject(objRep)
		Continue:objRep.MEPDStatus="4"  //被订状态报告无效
		Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
		Continue:objRep.MEPDStatus="7"  //删除状态报告无效
		Continue:'$IsObject(objRep.MEPDICDDR)
		Set return=return_$lb(##class(DHCMed.EPDService.EpidemicSrv).BuildQryEpidemic(objRep))
	}
	
	Quit return
}

/// 合并病人
/// Modify by wuqk 2011-08-03
/// 参数：
/// FromPatientID:源病人ID
/// ToPatientID:目标病人ID
/// UserId:操作用户ID
/// 功能：将传染病报告的病人ID从FromPatientID转到ToPatientID下
/// w ##class(DHCMed.EPDService.Service).MergePatient(142721,112582,1)
ClassMethod MergePatient(FromPatientID As %String, ToPatientID As %String, UserId As %String) As %Integer
{
	n (FromPatientID,ToPatientID,UserId)
	Quit:((FromPatientID="")||(ToPatientID="")) -1
	Set ICDDr=""
	Set Counter=0
	For {
		Set ICDDr=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",FromPatientID,ICDDr))
		Quit:ICDDr=""
		Set RowID=""
		For {
			Set RowID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",FromPatientID,ICDDr,RowID))
			Quit:RowID=""
			Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RowID)
			Continue:$IsObject(objRep)=0
			Set objRep.MEPDPapmiDR=ToPatientID
			Do objRep.%Save()
			Do objRep.%Close()
			//Set ret=##class(DHCMed.SS.PAPMILog).InsertLog("Epdemic","DHCMed.EPD.Epidemic",objRep.%Id(),FromPatientID,ToPatientID)
			Set ret=##class(User.DHCPATCardUniteLog).InsertLog("DHCMed.EPD.Epidemic",FromPatientID,ToPatientID,objRep.%Id(),"",UserId)
			Set objRep=""
			Set Counter=Counter+1
		}
	}
	Quit Counter
}

/// 取消合并病人
/// By wuqk 2011-08-03
/// 参数：
/// FromPatientID:源病人ID
/// ToPatientID:目标病人ID
/// UserId:操作用户ID
/// 功能：将传染病报告中曾经从FromPatientID转到ToPatientID下的病人ID还原
/// w ##class(DHCMed.EPDService.Service).CancelMerge(142721,112582,1)
ClassMethod CancelMerge(FromPatientID As %String, ToPatientID As %String, UserId As %String) As %Integer
{
	n (FromPatientID,ToPatientID,UserId)
	set recordId=""
	//^User.DHCPATCardUniteLogI
	//Index OldNewPAPMI On (CUActiveFlag, CUOldPAPMIRowid, CUNewPAPMIRowid, CUTableName As AlphaUp);
	if $d(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_FromPatientID," "_ToPatientID," DHCMEDEPDEPIDEMIC")){
		set logId=$o(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_FromPatientID," "_ToPatientID," DHCMEDEPDEPIDEMIC",0))
		while logId'="" {
			set objLog=##class(User.DHCPATCardUniteLog).%OpenId(logId)
			set recordId=objLog.CURecordID
			set objLog=""
			set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(recordId)
			Continue:$IsObject(objRep)=0
			set objRep.MEPDPapmiDR=FromPatientID
			Do objRep.%Save()
			Do objRep.%Close()
			Set ret=##class(User.DHCPATCardUniteLog).UpdateLog(logId, UserId)
			set logId=$o(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_FromPatientID," "_ToPatientID," DHCMEDEPDEPIDEMIC",logId))
		}
	}
	quit $$$OK
}

/// Creator：     yukai
/// CreatDate：   2019-01-26
/// Description:  取传染病疑似筛查确诊未报数量
/// Table：       DHCMed.EPD.CasesX
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 开始日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.Service).GetUnRepEpdCnt("2017-03-01","2019-01-01")
/// w ##class(DHCMed.EPDService.Service).GetUnRepEpdCnt("","")
ClassMethod GetUnRepEpdCnt(aDateFrom As %String, aDateTo As %String, aloc As %String = "") As %String
{
	New (aDateFrom,aDateTo,aloc)
	Set return=0
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=$p($h,",",1)-30
	Set:aDateTo="" aDateTo=$p($h,",",1)
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aloc,"EPD")
	
	Set Cnt=0
	Set xDate=aDateFrom-1
	For{
		Set xDate=$o(^DHCMed.EPDi("CasesX","IndexSubjectActDate","EPDCC",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xCasesID=0
		For {
			Set xCasesID=$o(^DHCMed.EPDi("CasesX","IndexSubjectActDate","EPDCC",xDate,xCasesID))
			Quit:xCasesID="" 
			Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesID)
			Continue:'$IsObject(objCasesX)
			Set IsActive=objCasesX.CXIsActive
			Continue:IsActive'=1
			Set EpdStatus=objCasesX.CXEpdStatus
			Continue:EpdStatus'="1"
			Set EpisodeID=objCasesX.CXEpisodeID
			If (aHospCode'=""){
		    	Set flag=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,EpisodeID,"EPD")
		    	continue:flag<1
		    }
			Set AdmInfo=$g(^PAADM(EpisodeID))
			Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
			Set flg=##class(DHCMed.EPDService.SuspCasesXSrv).GetReportByCasesX(xCasesID)
			Set:flg="" Cnt=Cnt+1
		}
	}
	Set:Cnt'=0 return=Cnt
	Quit return
}

/// Creator：     yukai
/// CreatDate：   2019-01-26
/// Description:  取传染病报告未审核数量
/// Table：       DHCMed.EPD.Epidemic
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 开始日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.Service).GetUnChkEpdCnt("2017-03-20","2017-06-20")
/// w ##class(DHCMed.EPDService.Service).GetUnChkEpdCnt("","")
ClassMethod GetUnChkEpdCnt(aDateFrom As %String, aDateTo As %String, aLoc As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLoc)
	Set return=0
	Set Cnt=0
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=$p($h,",",1)-30
	Set:aDateTo="" aDateTo=$p($h,",",1)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLoc,"EPD")
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.EPDi("EPD",0,"RepDate",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xReportID=0
		For {
			Set xReportID=$o(^DHCMed.EPDi("EPD",0,"RepDate",xDate,xReportID))
			Quit:xReportID="" 
			Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xReportID)
			continue:'$IsObject(objRep) 
			continue:'$IsObject(objRep.MEPDICDDR)  
			continue:objRep.MEPDICDDR.MIFIsActive'="Y" 
			If (aHospCode'=""){
		    	Set flag=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,objRep.MEPDText1,"EPD")
		    	continue:flag<1
		    }
			
			Set RepStatus=objRep.MEPDStatus
			Set:RepStatus="1" Cnt=Cnt+1
			}
		}
		Set:Cnt'="" return=Cnt
	Quit return
}

/// Creator：     yukai
/// CreatDate：   2019-02-17
/// Description:  传染病未报科室汇总 
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.Service","QryEpdUnRepLocCnt","2")
Query QryEpdUnRepLocCnt(aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "LocDesc:%String,Cnt:%String") [ SqlProc ]
{
}

ClassMethod QryEpdUnRepLocCntExecute(ByRef qHandle As %Binary, aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=+$h-30
	Set:aDateTo="" aDateTo=+$h
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK 
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLocID,"EPD")
	
	Set NIndex="QryEpdUnRepLocCnt"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"EpdUnRepLocCnt")
	
	Set xDate=aDateFrom-1
	For{
		Set xDate=$o(^DHCMed.EPDi("CasesX","IndexEpdStatusDate","EPDCC",1,xDate))  //只取确诊的
		Quit:(xDate="")||(xDate>aDateTo)
		Set CXReportID=0
		For{
			Set CXReportID=$o(^DHCMed.EPDi("CasesX","IndexEpdStatusDate","EPDCC",1,xDate,CXReportID))
			Quit:CXReportID=""
			Set CXReportobj=##class(DHCMed.EPD.CasesX).GetObjById(CXReportID)
			Quit:'$IsObject(CXReportobj)
			Set IsActive=CXReportobj.CXIsActive
			Continue:IsActive'=1
			Set EpisodeID=CXReportobj.CXEpisodeID
			Set AdmInfo=$g(^PAADM(EpisodeID))
			Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
			Set AdmLocID=$p(AdmInfo,"^",4)
			
			If (aHospCode'=""){
				Set HospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(AdmLocID,"EPD")
				Continue:HospCode'=aHospCode
			}
						
			Set flg=##class(DHCMed.EPDService.SuspCasesXSrv).GetReportByCasesX(CXReportID)
			Continue:flg'="" 
			Set CXActLoc=CXReportobj.CXActLoc
			Set num=$i(^TMP($zn,$j,NIndex,CXActLoc,"同期科室传染病未报数"))
		}
	}

	Set xLoc=""
	For {
		Set xLoc=$o(^TMP($zn,$j,NIndex,xLoc))
		Quit:xLoc=""
      	Set EpdUnReportLocCount =^TMP($zn,$j,NIndex,xLoc,"同期科室传染病未报数")
		Continue:EpdUnReportLocCount=0
		Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(xLoc)
		If $IsObject(objRepLoc){
			Set LocDesc=objRepLoc.Descs
		}
		Set ^TMP($zn,$j,"EpdUnRepLocCnt",EpdUnReportLocCount,LocDesc)=1
	}
	set Count=0
	Set xEpdCount=""
	For {
		Set xEpdCount=$o(^TMP($zn,$j,"EpdUnRepLocCnt",xEpdCount),-1)
		Quit:((xEpdCount="")||(Count>11))
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^TMP($zn,$j,"EpdUnRepLocCnt",xEpdCount,xLocDesc))
			Quit:((xLocDesc="")||(Count>11))
			Set LocDesc=xLocDesc
			set Count=Count+1
      		Set Data=$lb(LocDesc,xEpdCount)
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"EpdUnRepLocCnt")
	Quit $$$OK
}

ClassMethod QryEpdUnRepLocCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpdUnRepLocCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEpdUnRepLocCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocInfRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     yukai
/// CreatDate：   2019-02-17
/// Description:  传染病科室汇总
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.Service","QryEpdRepLocCnt","2")
Query QryEpdRepLocCnt(aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "RepLocDesc:%String,RepCnt:%String") [ SqlProc ]
{
}

ClassMethod QryEpdRepLocCntExecute(ByRef qHandle As %Binary, aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=+$h-30
	Set:aDateTo="" aDateTo=+$h
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK 
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLocID,"EPD")
	
	Set NIndex="QryEpdRepLocCnt"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"EpdRepLocCnt")
	Set xDate=aDateFrom-1
	For{
		Set xDate=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xLocID=0
		For{
			Set xLocID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID))
			Quit:xLocID=""
			
			If (aHospCode'=""){
				Set HospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(xLocID,"EPD")
				Continue:HospCode'=aHospCode
			}
			
			Set xReportID=0
			For{
				Set xReportID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID,xReportID))
				Quit:xReportID=""
				Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xReportID)
				Continue:'$IsObject(objRep)
				Set Status=objRep.MEPDStatus
				Continue:(Status'=2)&&(Status'=1)&&(Status'=3)
				Set num=$i(^TMP($zn,$j,NIndex,xLocID,"同期科室传染病数"))
			}
		}
	}
	Set xLoc=""
	For {
		Set xLoc=$o(^TMP($zn,$j,NIndex,xLoc))
		Quit:xLoc=""
      	Set EpdReportLocCount =^TMP($zn,$j,NIndex,xLoc,"同期科室传染病数")
		Continue:EpdReportLocCount=0
		Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(xLoc)
		If $IsObject(objRepLoc){
			Set LocDesc=objRepLoc.Descs
		}
		Set ^TMP($zn,$j,"EpdRepLocCnt",EpdReportLocCount,LocDesc)=1
	}
	set Count=0
	Set xEpdCount=""
	For {
		Set xEpdCount=$o(^TMP($zn,$j,"EpdRepLocCnt",xEpdCount),-1)
		Quit:((xEpdCount="")||(Count>11))
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^TMP($zn,$j,"EpdRepLocCnt",xEpdCount,xLocDesc))
			Quit:((xLocDesc="")||(Count>11))
			Set LocDesc=xLocDesc
			set Count=Count+1
      		Set Data=$lb(LocDesc,xEpdCount)
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"EpdRepLocCnt")
	Quit $$$OK
}

ClassMethod QryEpdRepLocCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpdRepLocCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEpdRepLocCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospPrevRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     yukai
/// CreatDate：   2019-02-17
/// Description:  传染病疾病分布
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.Service","QryEpdRepICDCnt","2")
Query QryEpdRepICDCnt(aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Query(ROWSPEC = "RepLocDesc:%String,RepCnt:%String") [ SqlProc ]
{
}

ClassMethod QryEpdRepICDCntExecute(ByRef qHandle As %Binary, aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=+$h-30
	Set:aDateTo="" aDateTo=+$h
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK 
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLocID,"EPD")
	
	Set NIndex="QryEpdRepICDCnt"
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"EpdRepICDCnt")
	Set xDate=aDateFrom-1
	For{
		Set xDate=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xLocID=0
		For{
			Set xLocID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID))
			Quit:xLocID=""
			
			If (aHospCode'=""){
				Set HospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(xLocID,"EPD")
				Continue:HospCode'=aHospCode
			}
			
			Set xReportID=0
			For{
				Set xReportID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID,xReportID))
				Quit:xReportID=""
				Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xReportID)
				Continue:'$IsObject(objRep)
				Set Status=objRep.MEPDStatus

				Continue:(Status'=2)&&(Status'=1)&&(Status'=3)
				Set MEPDICDDR=objRep.MEPDICDDR.%Id()
				Set num=$i(^TMP($zn,$j,NIndex,MEPDICDDR,"同期疾病传染病数"))
				}
			}
		}
	Set xEPDICD=""
	
	For {
		Set xEPDICD=$o(^TMP($zn,$j,NIndex,xEPDICD))
		Quit:xEPDICD=""
      	Set EpdReportICDCount = $g(^TMP($zn,$j,NIndex,xEPDICD,"同期疾病传染病数"))
		Continue:EpdReportICDCount=0
		Set objICD=##class(DHCMed.EPD.Infection).GetObjById(xEPDICD)
		Continue:'$isobject(objICD)
		Set ICDDesc=objICD.MIFDisease
		Set ^TMP($zn,$j,"EpdRepICDCnt",EpdReportICDCount,ICDDesc)=1
	}
	set Count=0
	Set xEPDICDCount=""
	For {
		Set xEPDICDCount=$o(^TMP($zn,$j,"EpdRepICDCnt",xEPDICDCount),-1)
		Quit:((xEPDICDCount="")||(Count>11))
		Set xICDDesc=""
		For {
			Set xICDDesc=$o(^TMP($zn,$j,"EpdRepICDCnt",xEPDICDCount,xICDDesc))
			Quit:((xICDDesc="")||(Count>11))
			Set ICDDesc=xICDDesc
			set Count=Count+1
      		Set Data=$lb(ICDDesc,xEPDICDCount)
       	 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Kill ^TMP($zn,$j,"EpdRepICDCnt")
	Quit $$$OK
}

ClassMethod QryEpdRepICDCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpdRepICDCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEpdRepICDCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospPrevRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuzhehe
/// CreatDate：   2019-08-09
/// Description:  生成报卡编号(YYYYTTNNNN...
/// ;HIV: HIV随访表-01  ；ILI： 流感样病例-02
/// Return：      
/// w ##class(DHCMed.EPDService.Service).GetNewRepNo("HIV")
ClassMethod GetNewRepNo(RepType As %String) As %String
{
	New (RepType)
	Set return=""
	Quit:RepType="" return
	//审查年份
	Set YearCurr=$p($zd(+$H,3),"-",1)
	Set YearLast=$g(^DHCMed.EPD.ReportNo("YearLast"))
	If (YearCurr'=YearLast) {
		Kill ^DHCMed.EPD.ReportNo(RepType)
		Set ^DHCMed.EPD.ReportNo("YearLast")=YearCurr
	}

	Set return="-1^无相应报卡类型"
	Set TypeNo=$$GetTypeNo(RepType)
	Quit:TypeNo="" return
	
	Set NoHead=$tr($zd(+$H,3),"-","")_TypeNo
	
	Set NoLen=4
	Set RepIndNo=""
	Set NumCurr=$i(^DHCMed.EPD.ReportNo(RepType))
	
	if NoLen>$l(NumCurr) {
		set $p(RepIndNo,"0",NoLen+1-$l(NumCurr))=NumCurr
	} else {
		set RepIndNo=NumCurr
	}

	Set ^DHCMed.CD.CRReportNo(RepType)=RepIndNo
	Set NewRepNo=NoHead_RepIndNo
	Set return=NewRepNo
	Quit return
GetTypeNo(Type)
	If (Type="HIV"){
		//HIV随访表
		//6位随机数
		Set Random=$R(999999)
		Set RandomNo=""
		Set $p(RandomNo,"0",7-$l(Random))=Random
		Quit "01"_RandomNo
	}elseif(Type="ILI"){
		//流感样
		Quit "02"
	}elseif(Type="TB"){
		//肺结核患者信息卡
		Quit "03"
	}else{
		Quit ""
	}
}

/// Creator:     luotiantian
/// CreatDate：  2020-03-13
/// Description: 获取最新的传染病报告日期
/// Table： DHCMed.EPD.Epidemic
/// Input： aEpisodeID
/// Return： 
/// W ##class(DHCMed.EPDService.Service).GetRepDate("5","41")
ClassMethod GetRepDate(aEpisodeID As %String, aMIFKind As %String) As %String
{
	New (aEpisodeID,aMIFKind)
	Set return = 0
	Quit:(aEpisodeID="")||(aMIFKind="") return
	Set RepDate =0
	//查找历次就诊
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	Set xInfectionDr=""
	For {
		Set xInfectionDr=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,xInfectionDr))
		Quit:xInfectionDr=""
		
		Set objInfection=##class(DHCMed.EPD.Infection).GetObjById(xInfectionDr)
		Continue:'$IsObject(objInfection)
		
		Set MIFIsActive = objInfection.MIFIsActive  //是否有效
		Continue:MIFIsActive'="Y"
		Set MIFKind = objInfection.MIFKind   //类别
		Continue:(MIFKind'=aMIFKind)
		
		Set xRepID=""
		For {
			Set xRepID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,xInfectionDr,xRepID),-1)
			Quit:xRepID=""
			Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			Continue:objRep.MEPDStatus="4" //被订状态报告无效
			Continue:objRep.MEPDStatus="6" //草稿状态报告无效
			Continue:objRep.MEPDStatus="7" //删除状态报告无效
			Set RepDate = objRep.MEPDRepDate
			//Quit:RepDate'=""
			Set:RepDate>return return=RepDate
		}
		//Quit:RepDate'=""
	}
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)                 // 姓名
	Set IdentityCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)            // 身份证号码
	Quit:IdentityCode="" return
    Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)                // 出生日期
    //查询从老系统中导入的数据 历史导入数据特殊处理
	Set xRowID=""
	For {
   		Set xRowID=$o(^MA.EPD.ImportReportI("IndexPersonId"," "_$ZCVT(PatName,"U"),Birthday," "_$ZCVT(IdentityCode,"U"),xRowID))
   		Quit:xRowID=""
   		
   		Set objRep = ##class(DHCMed.EPD.ImportReport).GetObjById(xRowID)
		Continue:'$IsObject(objRep)
			
		Set DiseaseName = objRep.DiseaseName
		Set DiseaseKind = objRep.DiseaseKind
		
		Set xDicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," EPDEMICTYPE"," "_DiseaseKind,0))
		Continue:xDicID=""
		Set DicInfo =$g(^DHCMed.SS.DictionaryD(xDicID))
		Set IFKind = $lg(DicInfo,3)
		Continue:aMIFKind'=IFKind
		Set RepDate="99999"
		Quit:RepDate'=""
	}
	Set return = RepDate
	Quit return
}

}
