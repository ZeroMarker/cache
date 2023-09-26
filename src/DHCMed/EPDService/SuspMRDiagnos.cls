/// 名称: DHCMed.EPDService.SuspMRDiagnos
/// 描述: 传染病监控与临床诊断相关服务
/// 编写者：pylian
/// 编写日期: 2019-01-30
Class DHCMed.EPDService.SuspMRDiagnos Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-01-30
/// Description:  检查临床诊断
/// Table：       MR_Diagnos
/// Input：       aEpisodeID : 就诊号
///               aDateFrom : 开始日期
///               aDateTo : 截止日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspMRDiagnos).CheckHIS("131","2016-01-01","2019-01-31")
ClassMethod CheckHIS(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	new (aEpisodeID,aDateFrom,aDateTo)
	Set return=0,Count=0
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")
	Quit:(aEpisodeID="") return
	
	Set $ZT="CheckHISErr"
	
	Set MRADMDR=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRADMDR="" return
	Quit:'$d(^MR(MRADMDR,"DIA")) return
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set AdmLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set AdmHospID = +$p($g(^CTLOC(+AdmLoc)),"^",22)
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	Set:AdmReadm="" AdmReadm="A"
	Set Age=##class(DHCMed.SSIO.FromHisSrv).CalAge(PatientID,aEpisodeID,"","")
	Quit:Age="" return
	If Age["岁" {
		Set Age=+$p(Age,"岁",1)
	} Else {
		Set Age=1
	}
	Set Count = ..CheckChange(aEpisodeID,Age)
	Set DiagSub=0
	For {
		Set DiagSub=$o(^MR(MRADMDR,"DIA",DiagSub))
		Quit:DiagSub=""
		
		Set (ICD10,ICDDesc,Comments,TypeCode,TypeDesc,DiagDate,DiagTime)=""
		Set tmpDignos = $g(^MR(MRADMDR,"DIA",DiagSub))
		Continue:tmpDignos=""
		Set DiagDate = $p(tmpDignos,"^",7)		// 取下诊断的日期
		Set DiagTime = $p(tmpDignos,"^",8)		// 取下诊断的时间
	
		Continue:DiagDate=""
		Continue:((aDateFrom'="")&&(DiagDate<aDateFrom))
		Continue:((aDateTo'="")&&(DiagDate>aDateTo))
	
		Set ICDID	 = $p(tmpDignos,"^",1)
		If ICDID'="" {
			Set tmpICD  = $g(^MRC("ID",ICDID))
			//Continue:$p(^MRC("ID",ICDID),"^",15)="Y"               //update 20210518 过滤中医诊断
			Set ICD10   = $p(tmpICD,"^",1)
			Set ICDDesc = $p(tmpICD,"^",2)
		}
		Set Comments = $g(^MR(MRADMDR,"DIA",DiagSub,"DES",1))
		
		Set TypeCode=""
		Set xDiagType=$o(^MR(MRADMDR,"DIA",DiagSub,"TYP",0))
		If xDiagType'="" {
			Set TypeID=$g(^MR(MRADMDR,"DIA",DiagSub,"TYP",xDiagType))
			Set TypeCode=$p($g(^MRC("DTYP",+TypeID)),"^",1)
			Set TypeDesc=$p($g(^MRC("DTYP",+TypeID)),"^",2)
		}
		Set DocCode="",DocDesc=""
		Set CareProvID=$p($g(^MR(MRADMDR,"DIA",DiagSub)),"^",4)
		If CareProvID'="" {
			Set DocCode=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,0))
			Set:DocCode'="" DocDesc=$p($g(^SSU("SSUSR",DocCode)),"^",2)
		}
	
		Set ICD10=$zcvt(ICD10,"U"),ICD10=$tr(ICD10," ","")
		Set ICDDesc=$zcvt(ICDDesc,"U"),ICDDesc=$tr(ICDDesc," ","")
		Set Comments = ICDDesc_" "_Comments
	
		Set RstList = ..GetDiagCheck(ICD10,Comments,Age,ICDID)   //ICD/关键词检索
		Continue:RstList=""
        
        Set ScreenDr=""
        For indL=1:1:$l(RstList) {
	        Set ScreenDr=$p(RstList,",",indL)
	        Continue:ScreenDr=""
	        Set objScr = ##class(DHCMed.EPD.SuspScreening).GetObjById(ScreenDr)
	        Continue:'$IsObject(objScr)
	        Continue:'$IsObject(objScr.BTInfectDr)
	        Set InfectDesc = objScr.BTInfectDr.BTDesc
	        Set InfDicID =objScr.BTInfectDr.%Id()
	       
	        Set (EpdStatus,EpdDiagnos,Opinion,EvalDate,EvalTime,EvalLoc,EvalUser)=""
	       
        	Set ID=$o(^DHCMed.EPDi("CasesX","IndexEpisActDiagnos","EPDCC",aEpisodeID," "_$zcvt(InfectDesc,"U"),0))
			If ID'="" {
				Set obj=##class(DHCMed.EPD.CasesX).GetObjById(ID)
				If $IsObject(obj) {
					Set EpdStatus	= obj.CXEpdStatus
					Set EpdDiagnos	= obj.CXEpdDiagnos
					Set Opinion     = obj.CXOpinion
					Set EvalDate    = obj.CXEvalDate
					Set EvalTime    = obj.CXEvalTime
					Set EvalLoc     = obj.CXEvalLoc
					Set EvalUser    = obj.CXEvalUser
				}
			}
			
			//保存病例筛查日志信息
			Set inputStr=ID
			Set inputStr=inputStr_"^"_"EPDCC"
			Set inputStr=inputStr_"^"_aEpisodeID
			Set inputStr=inputStr_"^"_DiagDate
			Set inputStr=inputStr_"^"_AdmLoc
			Set inputStr=inputStr_"^"_InfectDesc
			Set inputStr=inputStr_"^"_AdmReadm
			Set inputStr=inputStr_"^"_""
			Set inputStr=inputStr_"^"_EpdStatus
			Set inputStr=inputStr_"^"_EpdDiagnos
			Set inputStr=inputStr_"^"_Opinion
			Set inputStr=inputStr_"^"_EvalDate
			Set inputStr=inputStr_"^"_EvalTime
			Set inputStr=inputStr_"^"_EvalLoc
			Set inputStr=inputStr_"^"_EvalUser
			Set inputStr=inputStr_"^"_1
			Set inputStr=inputStr_"^"_""
			Set inputStr=inputStr_"^"_DiagDate
			Set CasesXID=##class(DHCMed.EPD.CasesX).Update(inputStr,"^")
			//记录诊断和是否保存成功，发消息使用
			Set MsgArray(InfectDesc,CasesXID)=Comments
			
			If (+CasesXID)>0 {
				Set Count=Count+1
				Set xSubID = ""
				Set xSubID=$o(^DHCMed.EPD.CasesXI("DTL","IndexScreenDateTime",CasesXID,ScreenDr,DiagDate,DiagTime,xSubID))
		
				//保存筛查明细
				Set inputSub=CasesXID
				Set inputSub=inputSub_"^"_xSubID
				Set inputSub=inputSub_"^"_ScreenDr
				Set inputSub=inputSub_"^"_"MRICD:"_MRADMDR_"||"_DiagSub_"#"_ICD10_"#"_ICDDesc
				Set inputSub=inputSub_"^"_DiagDate
				Set inputSub=inputSub_"^"_DiagTime
				Set inputSub=inputSub_"^"_1
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_""
				Set inputSub=inputSub_"^"_DocDesc 
				Set inputSub=inputSub_"^"_MRADMDR_"||"_DiagSub
				Set flg=##class(DHCMed.EPD.CasesXDtl).Update(inputSub,"^")			
			}
        }
	}
	
	//遍历是否需要发送消息
	Set EpdSuspAutoSendMsg = ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpdSuspAutoSendMsg",AdmHospID)	// 传染病筛查后自动发消息
	// 发送全部或发送诊断异常的
	If ((EpdSuspAutoSendMsg["1")||(EpdSuspAutoSendMsg["2")){
		Set xInfectDesc=""
		For{
			Set xInfectDesc = $o(MsgArray(xInfectDesc))
			Quit:xInfectDesc=""
			Set xCasesXID=""
			For{
				Set xCasesXID = $o(MsgArray(xInfectDesc,xCasesXID))
				Quit:xCasesXID=""
				Continue:xCasesXID<=0
				Set CommentInfo	= "该患者临床诊断包含："_xInfectDesc_"，疑似传染病，请及时上报！"
				Set SendMessage = ##class(websys.DHCMessageInterface).Send(CommentInfo,"1018","^med",aEpisodeID,"","","{""linkParam"":""EpisodeID="_aEpisodeID_""",""dialogWidth"":""1340px"",""dialogHeight"":""90%""}","","","")
			}
		}
	}
	Quit Count
	
CheckHISErr
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2020-05-06
/// Description:  检查临床诊断是否删除或修改
/// Table：       MR_Diagnos
/// Input：       aEpisodeID : 就诊号
///               aDateFrom : 开始日期
///               aDateTo : 截止日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspMRDiagnos).CheckChange("55","22")
ClassMethod CheckChange(aEpisodeID As %String, aAge As %String) As %String
{
	new (aEpisodeID,aAge)
	Set return=0,Count=0
	
	Set $ZT="CheckChangeErr"
	
	Set xCasesXID=""
 	For {
 		Set xCasesXID=$o(^DHCMed.EPDi("CasesX","IndexSubjectPaadm","EPDCC",aEpisodeID,xCasesXID))
 		Quit:xCasesXID=""
 		
 		Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesXID)
		Continue:'$IsObject(objCasesX)
		Set IsActive=objCasesX.CXIsActive
		Continue:IsActive'=1

		Set xSubID=""
 		For {
 			Set xSubID=$o(^DHCMed.EPD("CasesX",xCasesXID,"DTL",xSubID))
 			Quit:xSubID=""
 		
 			Set objDtl=##class(DHCMed.EPD.CasesXDtl).GetObjById(xCasesXID_"||"_xSubID)
			Continue:'$IsObject(objDtl)
			Set IsActive=objDtl.CXDIsActive
			Continue:IsActive'=1
 			Set DContent = objDtl.CXDContent
 			Continue:DContent'["MRICD:"    //非诊断项目不判断
 			Set DResultID =objDtl.CXDResultID
 			Set MRADMDR = $p(DResultID,"||",1)
 			Set DiagSub = $p(DResultID,"||",2)
 			Set ICD10 = $p(DContent,"#",2)
 			Set ICDDesc = $p(DContent,"#",3)
 			
 		    If '$d(^MR(MRADMDR,"DIA",DiagSub)) {     //诊断已删除
 		        Set objCasesX=##class(DHCMed.EPD.CasesX).%OpenId(xCasesXID)
				If ($IsObject(objCasesX)) {
					Set objCasesX.CXIsActive = 0
					Set sc=objCasesX.%Save()
					If $system.Status.IsError(sc) {        //检查Save是否成功
				   		Do $system.OBJ.DisplayError(sc) 
				   		Set return=-1
					}Else{
						set return=objCasesX.%Id()
					}
					Do objCasesX.%Close()		
				}
				
				Set objDtl=##class(DHCMed.EPD.CasesXDtl).%OpenId(xCasesXID_"||"_xSubID)
				If ($IsObject(objDtl)) {
					Set objDtl.CXDIsActive = 0
					Set sc=objDtl.%Save()
					If $system.Status.IsError(sc) {        //检查Save是否成功
				   		Do $system.OBJ.DisplayError(sc) 
				   		Set return=-1
					}Else{
						set return=objDtl.%Id()
					}
					Do objDtl.%Close()		
				}
				Set Count=Count+1
 		    } Else {  	
	 		    Set RstList = ..GetDiagCheck(ICD10,ICDDesc,aAge)   //ICD/关键词检索
	            If (RstList="") {   //诊断已修改
	           		Set objCasesX=##class(DHCMed.EPD.CasesX).%OpenId(xCasesXID)
					If ($IsObject(objCasesX)) {
						Set objCasesX.CXIsActive = 0
						Set sc=objCasesX.%Save()
						If $system.Status.IsError(sc) {        //检查Save是否成功
					   		Do $system.OBJ.DisplayError(sc) 
					   		Set return=-1
						}Else{
							set return=objCasesX.%Id()
						}
						Do objCasesX.%Close()		
					}
					
					Set objDtl=##class(DHCMed.EPD.CasesXDtl).%OpenId(xCasesXID_"||"_xSubID)
					If ($IsObject(objDtl)) {
						Set objDtl.CXDIsActive = 0
						Set sc=objDtl.%Save()
						If $system.Status.IsError(sc) {        //检查Save是否成功
					   		Do $system.OBJ.DisplayError(sc) 
					   		Set return=-1
						}Else{
							set return=objDtl.%Id()
						}
						Do objDtl.%Close()		
					}
					
					Set Count=Count+1
	            }
 		    }
 		}
 	}
	Set return = Count
	Quit return
	
CheckChangeErr
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2019-01-30
/// Description:  ICD10/关键词检索判断诊断是否传染病
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       aICD : ICD编码
/// Input：       aKeys : 关键词
/// Return：      返回String
/// w ##class(DHCMed.EPDService.SuspMRDiagnos).GetDiagCheck("A65.x00","非性病性梅毒")
ClassMethod GetDiagCheck(aICD As %String, aKeys As %String, aAge As %String = "", aICDID As %String = "") As %String
{
	new (aICD,aKeys,aAge,aICDID)
	Set return=""
	Quit:(aICD="")&&(aKeys="") return
	
	//根据条件设置返回值和提示代码
	Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set AFPAgeMax=+AFPAgeMax
	
	Set RstList=""
	Set Isflg = 0, Noflg = 0
	//1. ICD10检索
	Set xID = ""
	For {
		Set xID = $o(^DHCMed.EPD.SuspScreeningI("IdxofType","I",xID))
		Quit:xID=""
		//Continue:(Isflg=1)&&(Noflg'=1)  //传染病不再检索
		Set Isflg = 0, Noflg = 0,ExcludeKey=""
		
		Set SrcInfo=$g(^DHCMed.EPD.SuspScreeningD(xID))					//筛查条件
		Continue:SrcInfo=""
		Set SuspInfectID=$List(SrcInfo,2)
		COntinue:SuspInfectID=""
		Set IsActive = $List(SrcInfo,10)
		Continue:IsActive'=1
		Set IncludeKey  = $List(SrcInfo,6)
		Set ExcludeKeys = $List(SrcInfo,7)
		
		Set SuspInfectInfo=$g(^DHCMed.EPD.SuspInfectDicD(SuspInfectID))	//疑似传染病字典
		Continue:SuspInfectInfo=""
		Set InfectID=$List(SuspInfectInfo,4)							//传染病字典
		
		// 当疾病等级为AFP时，判断患者年龄
		Set InfectID="",Rank=""
		If InfectID'="" {
			Set Rank = $p($g(^DHCMed.EPDC("IF",InfectID)),"^",4)
			Continue:(Rank=6)&&(aAge>AFPAgeMax)
		}
		//End
		If ($e(aICD,1,2)=$e(IncludeKey,1,2))&&(aICD[IncludeKey) {   //判断ICD是否包含，需判断首字母是否相同（排除中医诊断、ICD11编码的影响）
			 Set Isflg=1
		}
		If (ExcludeKeys'="") {
			For ind=1:1:$l(ExcludeKeys,"#") {  //排除关键词列表
				Set ExcludeKey=$p(ExcludeKeys,"#",ind)
				Continue:ExcludeKey=""
				Continue:Noflg=1
				Set Noflg=1
				
				Continue:(($zcvt(aICD,"U")[$zcvt(ExcludeKey,"U"))||($zcvt(aKeys,"U")[$zcvt(ExcludeKey,"U")))
				Set Noflg=0
			}
		}
		If (Isflg=1)&&(Noflg'=1) {   //是传染病
			Set RstList=RstList_$lb(xID)
		}
	}
	Quit:Noflg=1 return  //ICD检索非传染病不再继续 
	// Continue:$p(^MRC("ID",aICDID),"^",15)="Y"               //update 20210518 过滤中医诊断
	Set IsKeyflg = 0, NoKeyflg = 0
	//2. 关键词检索(西医)
	Set xkeyID = ""
	For {
		Set xkeyID = $o(^DHCMed.EPD.SuspScreeningI("IdxofType","K",xkeyID))
		Quit:xkeyID=""
		Continue:((aICDID'="")&&($p(^MRC("ID",aICDID),"^",15)="Y")&&($p(^MRC("ID",aICDID),"^",13)'="Y"))	// 过滤掉中医诊断
		//Continue:(IsKeyflg=1)&&(NoKeyflg'=1)  //传染病不再检索
		Set IsKeyflg = 0, NoKeyflg = 0,ExcludeKey="",Key=""
		
		Set SrcInfo=$g(^DHCMed.EPD.SuspScreeningD(xkeyID))					//筛查条件
		Continue:SrcInfo=""
		Set SuspInfectID=$List(SrcInfo,2)
		COntinue:SuspInfectID=""
		Set IsActive = $List(SrcInfo,10)
		Continue:IsActive'=1
		Set IncludeKey  = $List(SrcInfo,6)
		Continue:IncludeKey=""
		Set ExcludeKeys = $List(SrcInfo,7)
		
		Set SuspInfectInfo=$g(^DHCMed.EPD.SuspInfectDicD(SuspInfectID))	//疑似传染病字典
		Continue:SuspInfectInfo=""
		Set InfectID=$List(SuspInfectInfo,4)							//传染病字典
		
		//Add by xwj 2019-04-24 当疾病等级为AFP时，判断患者年龄
		// 当疾病等级为AFP时，判断患者年龄
		Set InfectID="",Rank=""
		If InfectID'="" {
			Set Rank = $p($g(^DHCMed.EPDC("IF",InfectID)),"^",4)
			Continue:(Rank=6)&&(aAge>AFPAgeMax)
		}
		//End
		If (IncludeKey["&") { //诊断关键词允许多个关键词判断一个诊断
			For ind=1:1:$l(IncludeKey,"&") {
				Set Key=$p(IncludeKey,"&",ind)
				Continue:Key=""
				Continue:NoKeyflg=1
				Set NoKeyflg=1				
				Continue:$zcvt(aKeys,"U")'[$zcvt(Key,"U")
				Set NoKeyflg=0
			}
			Continue:NoKeyflg=1    //多关键词不满足
			Set IsKeyflg=1
		}ElseIf(aKeys[IncludeKey) {
			 Set IsKeyflg=1
		}
		If (ExcludeKeys'="") {
			For ind=1:1:$l(ExcludeKeys,"#") {
				Set ExcludeKey=$p(ExcludeKeys,"#",ind)
				Continue:ExcludeKey=""
				Continue:NoKeyflg=1
				Set NoKeyflg=1
				
				Continue:(($zcvt(aICD,"U")[$zcvt(ExcludeKey,"U"))||($zcvt(aKeys,"U")[$zcvt(ExcludeKey,"U")))
				Set NoKeyflg=0
			}
		}
		If (IsKeyflg=1)&&(NoKeyflg'=1) {   //是传染病
			Set RstList=RstList_$lb(xkeyID)
		}		
	}
	
	Set ZYIsKeyflg = 0, ZYNoKeyflg = 0
	//3. 关键词检索(中医)
	Set xkeyID = ""
	For {
		Set xkeyID = $o(^DHCMed.EPD.SuspScreeningI("IdxofType","KZ",xkeyID))
		Quit:xkeyID=""
		Continue:(((aICDID'="")&&($p(^MRC("ID",aICDID),"^",15)'="Y")))		// 过滤掉西医诊断
		
		Set ZYIsKeyflg = 0, ZYNoKeyflg = 0,ExcludeKey="",Key=""
		
		Set SrcInfo=$g(^DHCMed.EPD.SuspScreeningD(xkeyID))					//筛查条件
		Continue:SrcInfo=""
		Set SuspInfectID=$List(SrcInfo,2)
		COntinue:SuspInfectID=""
		Set IsActive = $List(SrcInfo,10)
		Continue:IsActive'=1
		Set IncludeKey  = $List(SrcInfo,6)
		Continue:IncludeKey=""
		Set ExcludeKeys = $List(SrcInfo,7)
		
		Set SuspInfectInfo=$g(^DHCMed.EPD.SuspInfectDicD(SuspInfectID))	//疑似传染病字典
		Continue:SuspInfectInfo=""
		Set InfectID=$List(SuspInfectInfo,4)							//传染病字典
		
		//Add by xwj 2019-04-24 当疾病等级为AFP时，判断患者年龄
		// 当疾病等级为AFP时，判断患者年龄
		Set InfectID="",Rank=""
		If InfectID'="" {
			Set Rank = $p($g(^DHCMed.EPDC("IF",InfectID)),"^",4)
			Continue:(Rank=6)&&(aAge>AFPAgeMax)
		}
		//End
		If (IncludeKey["&") { //诊断关键词允许多个关键词判断一个诊断
			For ind=1:1:$l(IncludeKey,"&") {
				Set Key=$p(IncludeKey,"&",ind)
				Continue:Key=""
				Continue:ZYNoKeyflg=1
				Set ZYNoKeyflg=1				
				Continue:$zcvt(aKeys,"U")'[$zcvt(Key,"U")
				Set ZYNoKeyflg=0
			}
			Continue:ZYNoKeyflg=1    //多关键词不满足
			Set ZYIsKeyflg=1
		}ElseIf(aKeys[IncludeKey) {
			 Set ZYIsKeyflg=1
		}
		If (ExcludeKeys'="") {
			For ind=1:1:$l(ExcludeKeys,"#") {
				Set ExcludeKey=$p(ExcludeKeys,"#",ind)
				Continue:ExcludeKey=""
				Continue:ZYNoKeyflg=1
				Set ZYNoKeyflg=1
				
				Continue:(($zcvt(aICD,"U")[$zcvt(ExcludeKey,"U"))||($zcvt(aKeys,"U")[$zcvt(ExcludeKey,"U")))
				Set ZYNoKeyflg=0
			}
		}
		If (ZYIsKeyflg=1)&&(ZYNoKeyflg'=1) {   //是传染病
			Set RstList=RstList_$lb(xkeyID)
		}		
	}
	For indx=1:1:$listlength(RstList) {
		Set ScreenDr=$list(RstList,indx)
		Continue:ScreenDr=""
		Set return=return_","_ScreenDr
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-05-23
/// Description:  
/// Input：       aPatAge：患者年龄
///               aAgeList：年龄条件
/// 			 
/// Return：     0:患者年龄不在维护的范围内；1：患者年龄在维护的范围内
/// w ##class(DHCMed.EPDService.SuspMRDiagnos).GetAgeInfo("16","<=16&>=5")
ClassMethod GetAgeInfo(aPatAge As %String, aAgeList As %String) As %String
{
	new (aPatAge,aAgeList)
	Set return = 0
	Quit:((aPatAge="")||(aAgeList="")) return
	// 判断范围还是固定值
	if (aAgeList["&"){
		Set TempAge1 = $p(aAgeList,"&",1)
		Set TempAge2 = $p(aAgeList,"&",2)
		
		if (((TempAge1["<=")||(TempAge1["≤"))&&((TempAge2[">=")||(TempAge2["≥"))){
			Set:((aPatAge<=$zstrip(TempAge1,"*E'N"))&&(aPatAge>=$zstrip(TempAge2,"*E'N"))) return = 1
		}
		if (((TempAge1[">=")||(TempAge1["≥"))&&((TempAge2["<=")||(TempAge2["≤"))){
			Set:((aPatAge>=$zstrip(TempAge1,"*E'N"))&&(aPatAge<=$zstrip(TempAge2,"*E'N"))) return = 1
		}
		if ((TempAge1["<")&&(TempAge2[">")){
			Set:(aPatAge<$zstrip(TempAge1,"*E'N"))&&(aPatAge>$zstrip(TempAge2,"*E'N")) return = 1
		}
		if ((TempAge1[">")&&(TempAge2["<")){
			Set:(aPatAge>$zstrip(TempAge1,"*E'N"))&&(aPatAge<$zstrip(TempAge2,"*E'N")) return = 1
		}
	}else{
		if ((aAgeList["<=")||(aAgeList["≤")){
			Set:aPatAge<=$zstrip(aAgeList,"*E'N") return = 1
		}
		if ((aAgeList[">=")||(aAgeList["≥")){
			Set:aPatAge<=$zstrip(aAgeList,"*E'N") return = 1
		}
		if (aAgeList[">"){
			Set:aPatAge>$zstrip(aAgeList,"*E'N") return = 1
		}
		if (aAgeList["<"){
			Set:aPatAge<$zstrip(aAgeList,"*E'N") return = 1
		}
		if (aAgeList["="){
			Set:aPatAge=$zstrip(aAgeList,"*E'N") return = 1
		}
	}
	Quit return
}

}
