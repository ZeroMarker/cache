/// 名称: DHCMA.CPW.CPS.InterfaceSrv
/// 描述: 临床路径对外接口相关服务
/// 编写者：jiangpengpeng
/// 编写日期: 2018-08-25
Class DHCMA.CPW.CPS.InterfaceSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2021-04-25
/// Description:  查询符合准入条件的路径
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
/// Input：       aType : 入参弃用，默认为1
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWList(389,1,"")
ClassMethod GetCPWList(aEpisodeID As %String, aType As %String = "1", aKeyWords As %String = "") As %String
{
	New (aEpisodeID,aType,aKeyWords,%session)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
 	Set $ZT="DHCMAGetCPWList"
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
 	Set LocID=$p($g(^PAADM(aEpisodeID)),"^",4)  //就诊科室
 	Set AdmLocID=LocID_"!!"_SYSDr
 	Set HospID=$p($g(^CTLOC(LocID)),"^",22)
 	Set AdmHospID=HospID_"!!"_SYSDr
 	Set VistStatus=$p($g(^PAADM(+aEpisodeID)),"^",20)
 	Quit:VistStatus="D" return							//增加出院患者过滤，出院后修正诊断不提示入径
 	
 	//检查配置是否开启提示入径
 	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWCheckIsToCPW",AdmHospID)
 	Quit:ret'="Y" return
 	
 	//检查是否符合准入天数限制
 	Set ret=##class(DHCMA.CPW.CPS.InterfaceSrv).ChkAdmitDaysVal(aEpisodeID,AdmHospID)
 	Quit:+ret'=1 return
 	
 	//检查当前入径状态：没入过路径或者作废状态，可入径
 	Set Status=##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWStatus(aEpisodeID)
 	Quit:(Status'="")&&(Status'="U")&&(Status'="T") return						//增加不入径申请状态的仍进行提示检查，但过滤已进行不入径申请的路径
 	 	
 	//检查准入类型是否包含当前就诊类型
 	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2) 
 	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWGetInCPWAdmType",AdmHospID)
 	Quit:ret'[AdmType return
 	
 	//查询已申请了不入径和作废的路径列表
 	Set NotInPathList=##class(DHCMA.CPW.CPS.InterfaceSrv).GetNotInPathList(aEpisodeID)
 	
 	Set xPathID="",CPWList=""
 	For{
	 	Set xPathID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(AdmLocID,"U"),xPathID))
	 	Quit:xPathID=""
	 	
	 	//对已进行不入径申请的路径不再进行检查
	 	Continue:$lf(NotInPathList,xPathID)>0
	 	
	 	Set objPath=##class(DHCMA.CPW.BT.PathMast).GetObjById(xPathID)
 		Continue:'$IsObject(objPath)
 		Continue:'objPath.BTIsActive
 		Continue:objPath.BTTypeDr.BTDesc="合并症"
	 	
	 	Set xTypeID="",xFlgMatch=0,TrigDiag="",TrigOper=""
 		For {
 			Set xTypeID=$o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",xPathID,xTypeID))
 			Quit:xTypeID=""
 			//Quit:xFlgMatch=1
			
 			Set xID=""
 			For {
	 			Set xID=$o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",xPathID,xTypeID,xID))
 				Quit:xID=""
 				//Quit:xFlgMatch=1
 				
 				Set obj = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xID)
		 		Continue:'$IsObject(obj)
		 		Continue:obj.BTIsActive=0
		 		Continue:'$IsObject(obj.BTPathDr)
				Continue:obj.BTPathDr.BTIsActive=0
				
		 		Set ICD10 =obj.BTICD10							//维护的诊断ICD代码
			 	Set ICDKeys = obj.BTICDKeys						//维护的诊断关键字
			 	Set OperICD = obj.BTOperICD						//维护的手术代码
			 	Set OperKeys = obj.BTOperKeys					//维护的手术关键字
			 	Set IsICDAcc = obj.BTIsICDAcc					//是否中西医诊断同时符合
			 	Set IsOperAcc = obj.BTIsOperAcc					//是否诊断手术同时符合
			 	Set TypeDesc = obj.BTTypeDr.BTDesc				//入径标准的诊断类型
			 	Set (flgDiag,flgOper)=0
			 	
			 	//add 获取维护的子表排除诊断icd
			 	Set xSubDiagID="",ExclDiagICD=""
				Set xSubDiagID=$o(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",xID," M",""))
				If xSubDiagID '= ""{
					Set objExclDiag = ##class(DHCMA.CPW.BT.PathAdmitOrds).GetObjById(xID_"||"_xSubDiagID)
				 	Set:$IsObject(objExclDiag) ExclDiagICD=objExclDiag.OrdIcd	
				}
				Set retChkDiag=..CheckDiag(aEpisodeID,TypeDesc,ICD10,ICDKeys,AdmHospID,ExclDiagICD)					//检查诊断（中西医）			
				If $p(retChkDiag,"^",1)=1 {	
					Set:(IsICDAcc=1)&&(retChkDiag["西医")&&(retChkDiag["中医") flgDiag=1
					Set:IsICDAcc=0 flgDiag=1
					
					// 获取触发诊断
					Set TrigDiag=TrigDiag_"!"_$p(retChkDiag,"^",2)
				}
				
				
				Set retChkOper=""
				//add 手术排除诊断icd
				Set xSubOperID="",ExclOperICD=""
				Set xSubOperID=$o(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",xID," O",""))
				If xSubOperID '= ""{
					Set objExclOper = ##class(DHCMA.CPW.BT.PathAdmitOrds).GetObjById(xID_"||"_xSubOperID)
				 	Set:$IsObject(objExclOper) ExclOperICD=objExclOper.OrdIcd	
				}
				
				Set retChkOper=..CheckOper(aEpisodeID,OperICD,OperKeys,ExclOperICD)						//检查手术申请(排除急诊类型、日间手术类型）
				If $p(retChkOper,"^",1)=1 {
					Set flgOper=1
					
					// 获取触发手术
					Set TrigOper = TrigOper_"!"_$p(retChkOper,"^",2)
				}
				
				If IsOperAcc=1{
					Set:(flgDiag=1)&&(flgOper=1) xFlgMatch=1
				}Else{
					Set:(flgDiag=1)||(flgOper=1) xFlgMatch=1	
				}
				
 			}
 		}
 		
 		//去重
 		Set TrigDiag=##class(DHCMA.Util.IO.CommonSrv).RmvDupItemToList($lfs(TrigDiag,"!"),1)
 		Set TrigDiag=$lts(TrigDiag,"!")
 		Set TrigOper=##class(DHCMA.Util.IO.CommonSrv).RmvDupItemToList($lfs(TrigOper,"!"),1)
 		Set TrigOper=$lts(TrigOper,"!") 		
 		
 		//匹配成功则获取路径信息
 		If xFlgMatch=1{
 			Set PathDesc=objPath.BTDesc
 			Set:PathDesc'="" PathDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",PathDesc,LangID)
			Set FormStr=##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(xPathID,1)	//FormID_"^"_Version
			Continue:FormStr=""
			Set FormID=$p(FormStr,"^",1)
			Set Version=$p(FormStr,"^",2)
			Set PathWay=FormID_"^"_PathDesc_"("_Version_")"_"^"_TrigDiag_"-"_TrigOper
			Set CPWList=CPWList_","_PathWay
			
			/*
	 		===========================以下内容暂时注释，勿删=========================
	 		//检查质控病种/付费病种关联信息，若存在生成对应路径
	 		Set newCPWID=FormID,newCPWDesc=PathDesc_"("_Version_")"
	 		Set QCEntityID=objPath.BTQCEntityDr
	 		Set chkQCFlg=##class(DHCMA.CPW.CPS.InterfaceSrv).CheckAddQCSDCPW(QCEntityID,AdmLocID)
	 		If (chkQCFlg=1){
		 		Set newCPWID=newCPWID_"-"_QCEntityID
		 		Set newCPWDesc=newCPWDesc_"【单】"
		 	}else{
			 	Set newCPWID=newCPWID_"-"_""
			}
		 	Set PCEntityID=objPath.BTPCEntityDr
		 	Set chkPCFlg=##class(DHCMA.CPW.CPS.InterfaceSrv).CheckAddPCSDCPW(PCEntityID,AdmLocID)
		 	If (chkPCFlg=1){
		 		Set newCPWID=newCPWID_"-"_PCEntityID
		 		Set newCPWDesc=newCPWDesc_"【付】"
		 	}
		 	If (newCPWID'=(xCPWID_"-")){
			 	Set newCPWData=newCPWID_"^"_newCPWDesc
	 			Set CPWList=CPWList_","_newCPWData
			}
			*/
	 	}
	 }
	Set:CPWList'="" CPWList=$e(CPWList,2,$l(CPWList))
 	Set return=CPWList
 	Quit return
 	
DHCMAGetCPWList
	//Quit $ZE
	Quit ""
}

/// Creator:		yankai
/// CrateDate:		2022-07-22
/// Description:	检查诊断入径
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CheckDiag(389,"初步诊断","D33.104&I61.301","脑桥良性肿瘤","2!!1","")
/// return 1^诊断1,诊断2,诊断3^西医,中医
ClassMethod CheckDiag(aEpisodeID As %String, aAdmitDiagType As %String, aAdmitDiagICD As %String, aAdmitDiagKeys As %String, aAdmHospID As %String, aExclDiagICD As %String = "") As %List
{
	New (aEpisodeID,aAdmitDiagType,aAdmitDiagICD,aAdmitDiagKeys,aAdmHospID,aExclDiagICD)
	Set return=""
	Quit:(aEpisodeID="")||((aAdmitDiagICD="")&&(aAdmitDiagKeys="")) -1
	//Set ^TEMPYK("CheckDiag")=$LB(aEpisodeID,aAdmitDiagType,aAdmitDiagICD,aAdmitDiagKeys,aAdmHospID,aExclDiagICD)
	
	Set IsChkMainDiag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsOnlyCheckMainDiag",aAdmHospID)		//获取配置，是否只检查患者主诊断
	Set IsIgnDISDiag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsIgnoreDISDiag",aAdmHospID)			//获取配置，是否忽略出院诊断
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)					//主诊断记录表
	Quit:MRAdm="" -2
	
	Set matchDiagICD="",matchDiagCat=""
	
	Set xRetDiagICD="",xRetDiagICDCat="",xFlgICDMatch=0
	If aAdmitDiagICD '= ""{
		Set aAdmitDiagICD=$tr(aAdmitDiagICD,"，",",")
		For indx=1:1:$l(aAdmitDiagICD,","){
			Set xAdmitDiagICD = $p(aAdmitDiagICD,",",indx)
			Continue:xAdmitDiagICD=""
			
			Set yRetDiagICD="",yRetDiagICDCat="",yFlgICDMatch=1	
			For indy=1:1:$l(xAdmitDiagICD,"&"){
				Quit:yFlgICDMatch=0
				
				Set yAdmitDiagICD = $p(xAdmitDiagICD,"&",indy)
				Continue:yAdmitDiagICD=""
				
				Set retMRDiag=..FetchMRDiags(MRAdm,aAdmitDiagType,IsChkMainDiag,IsIgnDISDiag,yAdmitDiagICD,"",aExclDiagICD)
				If +retMRDiag=0 {
					Set yFlgICDMatch=0			//&分隔下诊断如有其一不符合，则不符合
				}Else{
					Set yRetDiagICD = yRetDiagICD_$lfs($p(retMRDiag,"^",2),",")
					Set yRetDiagICDCat = yRetDiagICDCat_$lfs($p(retMRDiag,"^",3),",")	
				}	
			}
			
			If yFlgICDMatch=1 {
				Set xFlgICDMatch = 1
				Set xRetDiagICD = xRetDiagICD_yRetDiagICD
				Set xRetDiagICDCat = xRetDiagICDCat_yRetDiagICDCat			
			}				
		}
	}
	
	Set xRetDiagKey="",xRetDiagKeyCat="",xFlgKeyMatch=0
	If aAdmitDiagKeys '= ""{
		Set aAdmitDiagKeys=$tr(aAdmitDiagKeys,"，",",")
		For indx=1:1:$l(aAdmitDiagKeys,","){
			Set xAdmitDiagKey = $p(aAdmitDiagKeys,",",indx)
			Continue:xAdmitDiagKey=""
			
			Set yRetDiagKey="",yRetDiagKeyCat="",yFlgKeyMatch=1	
			For indy=1:1:$l(xAdmitDiagKey,"&"){
				Quit:yFlgKeyMatch=0
				Set yAdmitDiagKey = $p(xAdmitDiagKey,"&",indy)
				Continue:yAdmitDiagKey=""
				Set retMRDiag=..FetchMRDiags(MRAdm,aAdmitDiagType,IsChkMainDiag,IsIgnDISDiag,"",yAdmitDiagKey,aExclDiagICD)
				If +retMRDiag=0 {
					Set yFlgKeyMatch=0			//&分隔下诊断如有其一不符合，则不符合
				}Else{
					Set yRetDiagKey = yRetDiagKey_$lfs($p(retMRDiag,"^",2),",")
					Set yRetDiagKeyCat = yRetDiagKeyCat_$lfs($p(retMRDiag,"^",3),",")	
				}	
			}
			
			If yFlgKeyMatch=1 {
				Set xFlgKeyMatch = 1
				Set xRetDiagKey = xRetDiagKey_yRetDiagKey
				Set xRetDiagKeyCat = xRetDiagKeyCat_yRetDiagKeyCat			
			}				
		}
	}
	
	If (xFlgICDMatch=1)||(xFlgKeyMatch=1){
		Set matchDiagICD = ##class(DHCMA.Util.IO.CommonSrv).RmvDupItemToList(xRetDiagICD_xRetDiagKey,1)
		Set matchDiagCat = ##class(DHCMA.Util.IO.CommonSrv).RmvDupItemToList(xRetDiagICDCat_xRetDiagKeyCat,1)
		Set return=1_"^"_$lts(matchDiagICD,"!")_"^"_$lts(matchDiagCat,"!")
	} 
	 
	Quit return
}

/// Creator:		yankai
/// CrateDate:		2022-07-22
/// Desc:			遍历患者诊断数据
/// return:			0或1^触发诊断ICD1,触发诊断ICD2,触发诊断ICD3^中医,西医
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).FetchMRDiags("112","入院诊断","N||2","Y",,,"C50.600,C50.600x001,")
ClassMethod FetchMRDiags(aMRAdm As %String, aAdmitDiagType As %String, aIsChkMainDiag As %String, aIsIgnDISDiag As %String, aPieceDiagICD As %String, aPieceDiagKey As %String, aExclDiagICD As %String) As %String
{
	New (aMRAdm, aAdmitDiagType, aIsChkMainDiag, aIsIgnDISDiag, aPieceDiagICD, aPieceDiagKey, aExclDiagICD)
	Set return=0
	Quit:(aMRAdm="") return
	//Set ^TEMPYK("FetchMRDiags")=$LB(aMRAdm, aAdmitDiagType, aIsChkMainDiag, aIsIgnDISDiag, aPieceDiagICD, aPieceDiagKey, aExclDiagICD)
	
	Set xDiagnosID=0,retDiagICD="",retDiagCat=""
	For {
		Set xDiagnosID=$o(^MR(aMRAdm,"DIA",xDiagnosID))				//遍历所有诊断
		Quit:xDiagnosID=""
		
		Set tmpDiagnos=$g(^MR(aMRAdm,"DIA",xDiagnosID))
		Continue:$p(tmpDiagnos,"^",7)'=+$h							//只检查当天下的诊断
		Continue:(aIsChkMainDiag="Y")&&($p($g(^MR(aMRAdm,"DIA",xDiagnosID,1)),"^",20)'="Y")   // 如果只检查主诊断，则非主诊断直接过滤
		
		Set ICDDxID=$p(tmpDiagnos,"^",1)							//诊断代码表ID
		Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)					//ICD10编码				
		Set ICDDesc=$tr($p($g(^MRC("ID",+ICDDxID)),"^",2)," ","")	//ICD描述
		
		Set DesID=$o(^MR(aMRAdm,"DIA",xDiagnosID,"DES",0))
		Set:DesID="" DesID=1
		Set ICDDHC=$g(^MR(aMRAdm,"DIA",xDiagnosID,"DHC",DesID))
		Set ICDDES=$g(^MR(aMRAdm,"DIA",xDiagnosID,"DES",DesID))		//诊断备注
		Set DiagPrefix=$p($g(^MR(aMRAdm,"DIA",xDiagnosID,1)),"^",26) //诊断前缀 add 2020-09-17
		Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
		Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
		Set:DiagPrefix'="" ICDDesc=DiagPrefix_" "_ICDDesc

		Set MRDiagType=$o(^MR(aMRAdm,"DIA",xDiagnosID,"TYP",0))
		Set TypeDesc=""
		If MRDiagType'="" {
			Set TypeDicID=$g(^MR(aMRAdm,"DIA",xDiagnosID,"TYP",MRDiagType))
			Set TypeDesc=$p($g(^MRC("DTYP",+TypeDicID)),"^",2) 						//诊断类型
			Continue:(aIsIgnDISDiag="Y")&&($tr(TypeDesc," ")="出院诊断")			//过滤出院诊断，不检查出院诊断是否符合入径 Modefied by yankai20220412
		}
		
		/*
		 *是否只检查主诊断设置为Y时，不检查诊断类型，只有此设置不为Y时，才检查诊断类型
		 *如果诊断类型在临床路径基础字典表中不存在，则不匹配诊断类型，诊断内容符合即入径
		 *如果存在，当字典表中有效性为否，则直接退出，不提示
		 *如果存在，且有效性为是，则匹配入径标准中的诊断类型，不符合退出
		 */
		If (aIsChkMainDiag="N||1")&&(TypeDesc'="") {
			Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWAdmDiagType",TypeDesc)
			Continue:($IsObject(objDic))&&(objDic.BTIsActive=0)
			Continue:($IsObject(objDic))&&(TypeDesc'=aAdmitDiagType)
		}
		
		Set DiagCat=##class(DHCMA.CPW.IO.FromDoc).GetDiagnosCat(ICDDxID,"")
		Continue:(DiagCat'="西医")&&(DiagCat'="中医")									//只检查中西医诊断，不检查中医证型
		Set retICD=..CheckICDArea(ICD10,aPieceDiagICD)
		Set retOutICD=..CheckICDArea(ICD10,aExclDiagICD)
		Set retKey=..CheckKeyArea(ICDDesc,aPieceDiagKey)
		
		If ((retICD=1)||(retKey=1)&&(retOutICD'=1)){
			Set:$lf(retDiagICD,ICD10)<1 retDiagICD=retDiagICD_$lb(ICD10)
			Set:$lf(retDiagCat,DiagCat)<1 retDiagCat=retDiagCat_$lb(DiagCat)
		}
	}
	
	Set retDiagICD = $lts(retDiagICD,",")
	Set retDiagCat = $lts(retDiagCat,",")
	Set:(retDiagICD'="")&&(retDiagCat'="") return= 1_"^"_retDiagICD_"^"_retDiagCat 
	
	Quit return
}

/// 检查手术入径
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CheckOper(18,"01.28&01.1800,02.91","哈哈&呼呼,啦啦啦","")
/// return 1^阑尾炎切除术^胆囊切除术
ClassMethod CheckOper(aEpisodeID As %String, aAdmitOperICD As %String, aAdmitOperKeys As %String, aExclOperICD As %String = "")
{
	New (aEpisodeID,aAdmitOperICD,aAdmitOperKeys,aExclOperICD)
	Set return=0
	Quit:(aEpisodeID="")||((aAdmitOperICD="")&&(aAdmitOperKeys="")) return
	//Set ^TEMPYK("CheckOper")=$LB(aEpisodeID,aAdmitOperICD,aAdmitOperKeys,aExclOperICD)
	
	Set matchOperICD=""
	
	Set xRetOperICD="",xFlgICDMatch=0
	If aAdmitOperICD '= ""{
		Set aAdmitOperICD=$tr(aAdmitOperICD,"，",",")
		For indx=1:1:$l(aAdmitOperICD,","){
			Set xAdmitOperICD = $p(aAdmitOperICD,",",indx)
			Continue:xAdmitOperICD=""
			
			Set yRetOperICD="",yFlgICDMatch=1	
			For indy=1:1:$l(xAdmitOperICD,"&"){
				Quit:yFlgICDMatch=0
				
				Set yAdmitOperICD = $p(xAdmitOperICD,"&",indy)
				Continue:yAdmitOperICD=""
				
				Set retApplyOper=..FetchApplyOper(aEpisodeID,yAdmitOperICD,"",aExclOperICD)
				If +retApplyOper=0 {
					Set yFlgICDMatch=0			//&分隔下手术如有其一不符合，则不符合
				}Else{
					Set yRetOperICD = yRetOperICD_$lfs($p(retApplyOper,"^",2),",")	
				}	
			}
			
			If yFlgICDMatch=1 {
				Set xFlgICDMatch = 1
				Set xRetOperICD = xRetOperICD_yRetOperICD		
			}				
		}
	}
	
	Set xRetOperKey="",xFlgKeyMatch=0
	If aAdmitOperKeys '= ""{
		Set aAdmitOperKey=$tr(aAdmitOperKeys,"，",",")
		For indx=1:1:$l(aAdmitOperKeys,","){
			Set xAdmitOperKey = $p(aAdmitOperKeys,",",indx)
			Continue:xAdmitOperKey=""
			
			Set yRetOperKey="",yFlgKeyMatch=1	
			For indy=1:1:$l(xAdmitOperKey,"&"){
				Quit:yFlgKeyMatch=0
				
				Set yAdmitOperKey = $p(xAdmitOperKey,"&",indy)
				Continue:yAdmitOperKey=""
				
				Set retApplyOper=..FetchApplyOper(aEpisodeID,"",yAdmitOperKey,aExclOperICD)
				If +retApplyOper=0 {
					Set yFlgKeyMatch=0			//&分隔下手术如有其一不符合，则不符合
				}Else{
					Set yRetOperKey = yRetOperKey_$lfs($p(retApplyOper,"^",2),",")	
				}	
			}
			
			If yFlgKeyMatch=1 {
				Set xFlgKeyMatch = 1
				Set xRetOperKey = xRetOperKey_yRetOperKey		
			}				
		}
	}
	
	If (xFlgICDMatch=1)||(xFlgKeyMatch=1){
		Set matchOperICD = ##class(DHCMA.Util.IO.CommonSrv).RmvDupItemToList(xRetOperICD_xRetOperKey,1)
		Set return=1_"^"_$lts(matchOperICD,"!")
	} 
	Quit return
}

/// Description:		遍历本次申请返回的手术
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).FetchApplyOper()
ClassMethod FetchApplyOper(aEpisodeID As %String, aPieceOperICD As %String, aPieceOperKey As %String, aExclOperICD) As %String
{
	New (aEpisodeID, aPieceOperICD, aPieceOperKey, aExclOperICD)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set retOperICD = ""
	Set operInfo=##class(DHCMA.CPW.IO.FromCIS).GetOperListByCIS(aEpisodeID)
	Quit:operInfo="" return						//无手术信息直接返回空
	
	Set operArr=##class(%DynamicArray).%FromJSON(operInfo)
	Set iter=operArr.%GetIterator()
	while iter.%GetNext(.key,.value){
		Set ICDCode = value.ICDCode					//手术名称ICD10编码
		Set OperDesc = value.OperDesc				//手术名称描述
		Set retICD=..CheckICDArea(ICDCode,aPieceOperICD)
		Set retOutICD=..CheckICDArea(ICDCode,aExclOperICD)
		Set retKey=..CheckKeyArea(OperDesc,aPieceOperKey)
		If ((retICD=1)||(retKey=1)&&(retOutICD'=1)){
			Set:$lf(retOperICD,ICDCode)<1 retOperICD=retOperICD_$lb(ICDCode)
		}
	}
	
	Set retOperICD = $lts(retOperICD,",")
	Set:retOperICD'="" return= 1_"^"_retOperICD
	
	Quit return
}

/// 准入ICD范围检查方法
/// w ##Class(DHCMA.CPW.CPS.InterfaceSrv).CheckICDArea("J45","J45-J46")
ClassMethod CheckICDArea(argICD As %String, argArea As %String) As %String
{
	New (argICD,argArea)
	Set return=-1
	Quit:(argArea="")||(argICD="") return
	
	Set:$e(argICD,$l(argICD))'=" " argICD=argICD_" "
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Set Area1=$p(Area,"-",1)
		Set Area2=$p(Area,"-",2)
		If (Area1'="")&&(Area2'="") {
			Kill ICD,ICDO
			Set ICD(" "_Area1)=""
			Set ICD(" "_Area2)=""
			If $o(ICD(" "_Area1))="" {
				Set Areatmp=Area1
				Set Area1=Area2
				Set Area2=Areatmp
			}
			
			Set ICD=$o(ICD(" "_argICD),-1)
			Set ICDO=$e(ICD,2,$l(ICD))
			Set:(ICDO=Area1) return=1
			Set:(ICDO=Area2)&&($e(argICD,1,$l(Area2))=Area2) return=1
		} Else {
			Set:$e(argICD,1,$l(Area))=Area return=1
		}
	}
	
	Quit return
}

/// 准入关键词范围检查方法
/// w ##Class(DHCMA.CPW.CPS.InterfaceSrv).CheckKeyArea("CCC","AAA,BBB")
ClassMethod CheckKeyArea(argDiagDesc As %String, argArea As %String) As %String
{
	New (argDiagDesc,argArea)
	Set return=-1
	Quit:(argArea="")||(argDiagDesc="") return
	
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	Set argDiagDesc=$tr(argDiagDesc,"，",",")
	Set argDiagDesc=$tr(argDiagDesc,"－","-")
	Set argDiagDesc=$tr(argDiagDesc,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Continue:argDiagDesc'[Area
		Set return=1
		Quit:return=1
	}
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-12-12
/// Description:  检查准入天数限制是否满足
/// Table：       
/// Input：       aEpisodeID, aHospID
/// Return：      1:允许入径；0：不允许入径
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).ChkAdmitDaysVal(aEpisodeID,"2!!1")
ClassMethod ChkAdmitDaysVal(aEpisodeID As %String, aHospID As %String = "") As %String
{
	New (aEpisodeID,aHospID,%session)
	Set return = 0
	Quit:(aEpisodeID="") return
	
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	If aHospID=""{
		Set aHospID = ##Class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID)	
	}
	
	Set valAdmitDays=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWDaysForGettingInto",aHospID)
	If valAdmitDays'="" {
		Set AdmDateTime=##class(DHCMA.Util.IO.FromHisSrv).GetAdmDateTime(aEpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmTime=$p(AdmDateTime,"^",2)
		Quit:AdmDate="" return
		If ((+$h-AdmDate)>+valAdmitDays){
			Set return = 0_"^"_valAdmitDays
		}Else{
			Set return = 1
		}
	}else{
		Set return = 1	
	}
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2021-11-12
/// Description:  返回患者已申请了不入径和作废的路径列表
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       aEpisodeID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetNotInPathList(aEpisodeID)
ClassMethod GetNotInPathList(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	If aEpisodeID'["!!"{
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID = aEpisodeID_"!!"_SYSDr	
	}
	
	Set xPathwayID=""
	For {
		Set xPathwayID = $o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,xPathwayID))
		Quit:xPathwayID=""
		
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
		Continue:'$IsObject(objPathway)
		Continue:'$IsObject(objPathway.CPFormDr)
		Continue:'$IsObject(objPathway.CPFormDr.FormPathDr)
		Continue:(objPathway.CPStatus'="T")&&(objPathway.CPStatus'="U")		//过滤非T和非U状态（非不入径申请状态和作废状态）
		Set xPathMastID=objPathway.CPFormDr.FormPathDr.%Id()
		Set:$lf(return,xPathMastID)<1 return=return_$lb(xPathMastID)
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-08-25
/// Description:  取临床路径简要说明
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWSummary(17)
ClassMethod GetCPWSummary(aPathID As %String) As %String
{
	New (aPathID,%session)
	Set return=""
	Quit:aPathID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set objPath=##class(DHCMA.CPW.BT.PathForm).GetObjById(aPathID)
	Quit:'$IsObject(objPath) return
	Quit:'$IsObject(objPath.FormPathDr) return
	
	Set PathDesc=objPath.FormPathDr.BTDesc
	Set:PathDesc'="" PathDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",PathDesc,LangID)
	Set ApplyDoc=objPath.FormApply
	Set:ApplyDoc'="" ApplyDoc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathForm","FormApply",ApplyDoc,LangID)
	Set HelpDoc=objPath.FormHelpDoc
	Set:HelpDoc'="" HelpDoc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathForm","FormHelpDoc",HelpDoc,LangID)
	Set return=PathDesc_"^"_ApplyDoc_"^"_HelpDoc
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  通过就诊号最新一条路径状态
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWStatus("27!!1")
ClassMethod GetCPWStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	If (aEpisodeID'["!!") {
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr
	}
	Set xPathwayID=""
	For {
		Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,xPathwayID),-1)
		Quit:xPathwayID=""
		
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
		Quit:'$IsObject(objPathway)
		
		Set Status=objPathway.CPStatus
		Set return=Status
		Quit
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  给医生站接口
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWStatusToDOC("202")
ClassMethod GetCPWStatusToDOC(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	Set Status=##class(DHCMA.CPW.CPS.InterfaceSrv).GetCPWStatus(aEpisodeID)
	Set:(Status="I") return=1
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-26
/// Description:  不入径申请
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).NotInApply()
ClassMethod NotInApply(aEpisodeID As %String, aInputs As %String) As %String
{
	New (aEpisodeID,aInputs)
	Set return=""
	Quit:(aEpisodeID="")&&(aInputs="") return
	
	Set CPWStatus=..GetCPWStatus(aEpisodeID)
	Set flg=$Case(CPWStatus,"I":"-1","A":"-2", :1)
	Quit:flg<0 flg	//入径状态不能再申请
	
	Set FormID=$p(aInputs,"^",1)
	Set UserID=$p(aInputs,"^",2)
	Set LocID=$p(aInputs,"^",3)
	Set WardID=$p(aInputs,"^",4)
	Set ReasonID=$p(aInputs,"^",5)
	Set ApplyTxt=$p(aInputs,"^",6)
	
	Set PathwayID=##class(DHCMA.CPW.CP.Pathway).NotInApply(aEpisodeID,FormID,LocID,WardID,UserID)
	Quit:PathwayID<1 "-4"
	
	Set ChildID=""
	Set TypeCode="03"
	Set AppylInupt=PathwayID_"^"_ChildID_"^"_TypeCode_"^"_ReasonID_"^"_ApplyTxt_"^"_UserID_"^"_LocID_"^"_WardID
	Set ret=##class(DHCMA.CPW.CP.PathwayApply).Update(AppylInupt,"^")
	Quit:ret<1 "-9"
	
	Set return=ret
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  入径操作
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetInCPW("157!!1","6^4634!!1^110!!1^!!1^15","^")
ClassMethod GetInCPW(aEpisodeID As %String, aInputs As %String, aSeparete As %String = "^") As %String
{
	New (aEpisodeID,aInputs,aSeparete,%session)
	Set return=""
	Quit:(aEpisodeID="")&&(aInputs="") return
	
	Set CPWStatus=..GetCPWStatus(aEpisodeID)
	Set flg=$Case(CPWStatus,"I":"-1", "C":"-2", :1)			//主动入径不限制出径再入径 Modify by yankai 20211116
	Quit:flg<0 flg	//入径状态、完成状态的不再入径
	
	//检查是否符合准入天数限制
 	Set ret=##class(DHCMA.CPW.CPS.InterfaceSrv).ChkAdmitDaysVal(aEpisodeID)
 	Quit:+ret'=1 "-21"
	
	Set FormID		= $p(aInputs,aSeparete,1)
	Set UserID		= $p(aInputs,aSeparete,2)
	Set LocID		= $p(aInputs,aSeparete,3)
	Set WardID		= ##class(DHCMA.CPW.IO.FromDoc).GetCTLocOIDByAdm(+aEpisodeID)
	Set QCEntityID	= $p(aInputs,aSeparete,5)
	Set PCEntityID  = $p(aInputs,aSeparete,6)
	Set DiagOper	= $p(aInputs,aSeparete,7)
	Set TrigDiag	= $p(DiagOper,"-",1)
	Set TrigOper	= $p(DiagOper,"-",2)
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Quit:'$IsObject(objUser) "-3"
	
	Set PathwayID=##class(DHCMA.CPW.CP.Pathway).Update(aEpisodeID,FormID,UserID)
	Quit:PathwayID<1 "-4"
	
	Set ret=##class(DHCMA.CPW.CPS.EpisSrv).SyncSteps(PathwayID,FormID,UserID)	//同步阶段数据
	Quit:ret<1 "-5"
	
	Set FirstEpisID=##class(DHCMA.CPW.CPS.EpisSrv).GetFirstEpisID(PathwayID)
	Set EpisID=PathwayID_"||"_FirstEpisID		//默认第一阶段
	Set DocID=objUser.BTCareProvID
	
	Set CPWInupt=PathwayID_$c(1)_aEpisodeID_$c(1)_FormID_$c(1)_EpisID_$c(1)_UserID_$c(1)_DocID_$c(1)_LocID_$c(1)_WardID_$c(1)_TrigDiag_$c(1)_TrigOper
	Set ret=##class(DHCMA.CPW.CP.Pathway).GetInCPW(CPWInupt,$c(1))
	Quit:ret<1 "-9"
	
	//入径时匹配已经执行的医嘱，并更新项目执行状态
	Set ret0=##class(DHCMA.CPW.CPS.ImplementSrv).CheckOEOrdImplByEpis(EpisID)
	
	//*********质控病种入组*********
	Set isExistQC=##class(%Dictionary.MethodDefinition).%ExistsId("DHCMA.CPW.SD.QCEntity||GetObjById")
	If isExistQC=1{
		Set objQCEntity=##class(DHCMA.CPW.SD.QCEntity).GetObjById(QCEntityID)
		If $IsObject(objQCEntity) {
			Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(FormID)
 			Set objMast=objForm.FormPathDr
 			Set MastID=objMast.%Id()
			Set aInputs=ret_"^"_MastID_"^"_UserID_"^"_LocID_"^"_WardID_"^"_DocID
			Set SDRet=..GetInSD(aEpisodeID,aInputs)
		}		
	}
	
	//*********付费病种入组**********
	Set isExistPC=##class(%Dictionary.MethodDefinition).%ExistsId("DHCMA.CPW.SD.PCEntity||GetObjById")
	If isExistPC=1{
		Set objPCEntity=##class(DHCMA.CPW.SD.PCEntity).GetObjById(PCEntityID)
		If $IsObject(objPCEntity) {
			Set PCRet=##class(DHCMA.CPW.SDS.PCIOToCPWSrv).GetIOPCEntity(aEpisodeID,PathwayID,"I",UserID)	
		}	
	}
	
	Set return=ret
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  出径操作
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetOutCPW(1)
ClassMethod GetOutCPW(aEpisodeID As %String, aInputs As %String) As %String
{
	New (aEpisodeID,aInputs)
	Set return=""
	Quit:(aEpisodeID="")&&(aInputs="") return
	
	Set CPWStatus=..GetCPWStatus(aEpisodeID)
	Quit:CPWStatus'="I" "-1"
	
	Set PathwayID=$p(aInputs,"^",1)
	Set UserID=$p(aInputs,"^",2)
	Set DocID=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Set:$IsObject(objUser) DocID=objUser.BTCareProvID
	Set LocID=$p(aInputs,"^",3)
	Set WardID=##class(DHCMA.CPW.IO.FromDoc).GetCTLocOIDByAdm(+aEpisodeID)
	Set ReasonID=$p(aInputs,"^",5)
	Set ApplyTxt=$p(aInputs,"^",6)
	
	Set ChildID=""
	Set TypeCode="02"
	Set AppylInupt=PathwayID_"^"_ChildID_"^"_TypeCode_"^"_ReasonID_"^"_ApplyTxt_"^"_UserID_"^"_LocID_"^"_WardID
	Set ret=##class(DHCMA.CPW.CP.PathwayApply).Update(AppylInupt,"^")
	Quit:ret<1 "-7"
	
	Set CPWInupt=PathwayID_"^"_UserID_"^"_DocID_"^"_LocID_"^"_WardID
	Set ret=##class(DHCMA.CPW.CP.Pathway).GetOutCPW(CPWInupt,"^")
	Quit:ret<1 "-9"
	
	//*******付费病种出组
	Set isExistPC=##class(%Dictionary.MethodDefinition).%ExistsId("DHCMA.CPW.SD.PCEntity||GetObjById")
	If isExistPC=1{
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
		Set PCEntityID=objPathway.CPFormDr.FormPathDr.BTPCEntityDr
		Set objPCEntity=##class(DHCMA.CPW.SD.PCEntity).GetObjById(PCEntityID)
		If $IsObject(objPCEntity) {
			Set PCRet=##class(DHCMA.CPW.SDS.PCIOToCPWSrv).GetIOPCEntity(aEpisodeID,PathwayID,"O",UserID)	
		}	
	}
	//**********
	
	Set return=ret
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-04-27
/// Description:  作废操作
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetUCanCPW("18!!1","38^18881!!1^191!!1^!!1^39^cs")
ClassMethod GetUCanCPW(aEpisodeID As %String, aInputs As %String) As %String
{
	New (aEpisodeID,aInputs)
	Set return=""
	Quit:(aEpisodeID="")&&(aInputs="") return
	
	Set CPWStatus=..GetCPWStatus(aEpisodeID)
	Quit:CPWStatus'="I" "-1"

	Set PathwayID=$p(aInputs,"^",1)
	Set UserID=$p(aInputs,"^",2)
	Set DocID=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Set:$IsObject(objUser) DocID=objUser.BTCareProvID
	Set LocID=$p(aInputs,"^",3)
	Set WardID=$p(aInputs,"^",4)
	Set ReasonID=$p(aInputs,"^",5)
	Set ApplyTxt=$p(aInputs,"^",6)
	
	Set ChildID=""
	Set TypeCode="04"
	Set AppylInupt=PathwayID_"^"_ChildID_"^"_TypeCode_"^"_ReasonID_"^"_ApplyTxt_"^"_UserID_"^"_LocID_"^"_WardID
	Set ret=##class(DHCMA.CPW.CP.PathwayApply).Update(AppylInupt,"^")
	Quit:ret<1 "-7"
	
	Set CPWInupt=PathwayID_"^"_UserID_"^"_DocID_"^"_LocID_"^"_WardID
	//Set ret=##class(DHCMA.CPW.CP.Pathway).GetOutCPW(CPWInupt,"^")
	Set ret=##class(DHCMA.CPW.CP.Pathway).GetUCanCPW(CPWInupt,"^")
	Quit:ret<1 "-9"
	
	//*******付费病种出组
	Set isExistPC=##class(%Dictionary.MethodDefinition).%ExistsId("DHCMA.CPW.SD.PCEntity||GetObjById")
	If isExistPC=1{
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
		Set PCEntityID=objPathway.CPFormDr.FormPathDr.BTPCEntityDr
		Set objPCEntity=##class(DHCMA.CPW.SD.PCEntity).GetObjById(PCEntityID)
		If $IsObject(objPCEntity) {
			Set PCRet=##class(DHCMA.CPW.SDS.PCIOToCPWSrv).GetIOPCEntity(aEpisodeID,PathwayID,"O",UserID)	
		}	
	}
	//**********
	
	Set return=ret
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  完成操作
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CloseCPW(1)
ClassMethod CloseCPW(aEpisodeID As %String, aInputs As %String) As %String
{
	New (aEpisodeID,aInputs)
	Set return=""
	Quit:(aEpisodeID="")&&(aInputs="") return
	
	Set CPWStatus=..GetCPWStatus(aEpisodeID)
	Quit:CPWStatus'="I" "-1"
	
	Set PathwayID=$p(aInputs,"^",1)
	Set UserID=$p(aInputs,"^",2)
	Set DocID=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Set:$IsObject(objUser) DocID=objUser.BTCareProvID
	Set LocID=$p(aInputs,"^",3)
	Set WardID=$p(aInputs,"^",4)
	
	Set CPWInupt=PathwayID_"^"_UserID_"^"_DocID_"^"_LocID_"^"_WardID
	Set ret=##class(DHCMA.CPW.CP.Pathway).CloseCPW(CPWInupt,"^")
	Quit:ret<1 "-9"
	
	Set return=ret
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-09-06
/// Description:  完成路径前进行各阶段签名检查
/// Table：       
/// Input：       aEpisodeID:就诊
/// Return：      0:都已签名；1^D:阶段1，阶段2^N:阶段1，阶段2：存在未签名阶段及具体信息
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CheckStepSignInfo("364!!1")
ClassMethod CheckStepSignInfo(aEpisodeID As %String, aPathwayID As %String = "") As %String
{
	New (aEpisodeID,aPathwayID)
	Set return = 0
	Quit:aEpisodeID="" return
	
	Set:aPathwayID="" aPathwayID = $o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	
	Set objPathway = ##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) return
	
	Set xIndNo=-1,retDocChk="",retNurChk=""
	For {
		Set xIndNo = $o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",aPathwayID,xIndNo))
		Quit:xIndNo=""
		
		Set xEpisID=""
		For {
			Set xEpisID = $o(^DHCMA.CPW.CP.PathwayI("EPIS","IdxofParIndNo",aPathwayID,xIndNo,xEpisID))
			Quit:xEpisID=""
			
			Set xObjEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aPathwayID_"||"_xEpisID)
			Continue:'$IsObject(xObjEpis)
			Continue:'xObjEpis.CPIsActive
			Continue:'$IsObject(xObjEpis.CPFormEpDr)
			Set EpisDesc = xObjEpis.CPFormEpDr.EpDesc
			
			If xObjEpis.CPSignDocID=""{
				Set:retDocChk'="" retDocChk = retDocChk_EpisDesc_","
				Set:retDocChk="" retDocChk = "D:"_EpisDesc_","
			}
			If xObjEpis.CPSignNurID=""{
				Set:retNurChk'="" retNurChk = retNurChk_EpisDesc_","
				Set:retNurChk="" retNurChk = "N:"_EpisDesc_","	
			}
		}	
	}
	Set:retDocChk'="" retDocChk=$e(retDocChk,1,$l(retDocChk)-1)
	Set:retNurChk'="" retNurChk=$e(retNurChk,1,$l(retNurChk)-1)
	Set:(retDocChk'="")||(retNurChk'="") return = 1_"^"_retDocChk_"^"_retNurChk
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  切换路径
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).SwitchCPW(1)
ClassMethod SwitchCPW(aEpisodeID As %String, aInputs As %String) As %String
{
	New (aEpisodeID,aInputs)
	Set return=""
	Quit:(aEpisodeID="")&&(aInputs="") return
	
	Set CPWStatus=..GetCPWStatus(aEpisodeID)
	Quit:CPWStatus'="I" "-1"
	
	Set PathwayID=$p(aInputs,"^",1)
	Set UserID=$p(aInputs,"^",2)
	Set NewFormID=$p(aInputs,"^",3)
	Set NewFormEpID=$p(aInputs,"^",4)
	Set ExecNote=$p(aInputs,"^",5)
	
	Set ret=##class(DHCMA.CPW.CPS.EpisSrv).DeleteUnCheckEpis(PathwayID,UserID)	//作废掉当前阶段之后的所有阶段数据
	Quit:ret<0 "-4"
	
	Set ret=##class(DHCMA.CPW.CPS.EpisSrv).SyncSteps(PathwayID,NewFormID,UserID,NewFormEpID)	//同步新路径阶段数据
	Quit:ret<0 "-5"
	
	Set objEpis=##class(DHCMA.CPW.CPS.EpisSrv).GetEpisByFormEpID(PathwayID,NewFormID_"||"_NewFormEpID)
	Quit:'$IsObject(objEpis) "-6"
	Set EpisID=objEpis.%Id()
	
	Set CPWInupt=PathwayID_"^"_aEpisodeID_"^"_UserID_"^"_NewFormID_"^"_EpisID_"^"_ExecNote
	Set ret=##class(DHCMA.CPW.CP.Pathway).SwitchCPW(CPWInupt,"^")
	Quit:ret<1 "-9"
	
	//*******付费病种出组
	Set isExistPC=##class(%Dictionary.MethodDefinition).%ExistsId("DHCMA.CPW.SD.PCEntity||GetObjById")
	If (+ret>0)&&(isExistPC=1){
		Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
		Set PCEntityID=objPathway.CPFormDr.FormPathDr.BTPCEntityDr
		Set objPCEntity=##class(DHCMA.CPW.SD.PCEntity).GetObjById(PCEntityID)
		If $IsObject(objPCEntity) {
			Set PCRet=##class(DHCMA.CPW.SDS.PCIOToCPWSrv).GetIOPCEntity(aEpisodeID,PathwayID,"O",UserID)	
		}	
	}
	//**********
	
	Set return=ret
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-10-16
/// Description:  To医生站，通过配置判断是否弹出添加变异页面
/// Table：       DHCMA.Util.BT.Config
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).IsAddVar(2)
ClassMethod IsAddVar(aLgnHospID As %String = "")
{
	New (aLgnHospID)
	Set return=0
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aLgnHospID'["!!" aLgnHospID=aLgnHospID_"!!"_SYSDr
	
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWCheckIsVarOEItem",aLgnHospID)
	Set:ret="Y||1" return=1
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-10-16
/// Description:  医嘱审核后，将医嘱OrderID插入执行记录表
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       aEpisodeID,aOrderID,aUserID,aType:W是普通医嘱审核调用，C为草药类医嘱审核调用
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).ExecuteOrder("503","10052||1*485||60*V*||||||^","10209","W")
ClassMethod ExecuteOrder(aEpisodeID As %String, OrderStr As %String, aUserID As %String, aType As %String = "W") As %String
{
	New (aEpisodeID,OrderStr,aUserID,aType)
	Set return=""
	Quit:(aEpisodeID="")&&(OrderStr="") return
	
	Set CPWStatus=..GetCPWStatusToDOC(aEpisodeID)
	Quit:CPWStatus'="1" return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aUserID'["!!" aUserID=aUserID_"!!"_SYSDr
	Set LocID=$p($g(^PAADM(aEpisodeID)),"^",4)  //就诊科室
	Set HospID=$p($g(^CTLOC(LocID)),"^",22)
 	Set AdmHospID=HospID_"!!"_SYSDr
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录，即当前路径
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	Set EpisID=objPathway.CPEpisDr.%Id()		//当前执行阶段
	
	Set $ZT="ExecuteOrderError"
	TStart
	
	For OrderInd=1:1:$l(OrderStr,"^") {
		Set aOEItmMastID=$p($p(OrderStr,"^",OrderInd),"*",1)
		Continue:aOEItmMastID=""
		Set aOEItemID=$p($p(OrderStr,"^",OrderInd),"*",2)
		Continue:aOEItemID=""
		Set aArcOEStr=$p(OrderStr,"^",OrderInd)
		
		// Modified by yankai 20210619 增加合并症医嘱检查并回写相关记录
		Set retMainPwOrd="",retComplPwOrd=""
		Set retMainPwOrd=..ExeMainPwOrd(PathwayID,EpisID,OrderStr,aArcOEStr,aUserID) 					//主路径记录回写检查
		
		//优先匹配主路径下关联医嘱，主路径医嘱匹配不到，再检测合并症路径下医嘱
		Set:retMainPwOrd=0 retComplPwOrd=..ExeComplPwOrd(PathwayID,EpisID,OrderStr,aArcOEStr,aEpisodeID,aUserID)
	 	
	 	//没匹配成功的，添加到变异记录里
	 	If (retMainPwOrd=0)&&(retComplPwOrd=0) {
		 	Set IsNewVar=1
	 		Set xVarID=""
			For {
				Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",PathwayID,EpisID,xVarID))
				Quit:xVarID=""
				
				Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(PathwayID_"||"_xVarID)
		 		Continue:'$IsObject(objVar)
		 		Continue:$IsObject(objVar.CPImplDr) //路径外医嘱没有项目指针
			 	Set VarOrd=objVar.CPOrdDID	
			 	
			 	Set retVar=""
			 	If (+objVar.CPIsActive=0) {	//回写前有效性为0
			 		If VarOrd=aOEItmMastID {
				 		Set IsNewVar=0
				 		Set retVar=##class(DHCMA.CPW.CP.PathwayVar).UpdateVarOrder(PathwayID_"||"_xVarID,aOEItemID)	//回写前VarOrd为医嘱字典ID
				 		If +retVar<0{
					 		TRollBack 1
					 		Set return=-101
					 		Quit	
					 	}
				 	}
			 	} Else {
			 		Set xVarOrd=$p(VarOrd,"^",1)	//回写后为医嘱记录ID
			 		Set xOESubID=$p(xVarOrd,"||",2)
					Set xOEItmMastID = $p($g(^OEORD(+xVarOrd,"I",xOESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
			 		If aOEItmMastID=xOEItmMastID{
				 		Set IsNewVar=0
				 		Set retVar=##class(DHCMA.CPW.CP.PathwayVar).UpdateVarOrder(PathwayID_"||"_xVarID,aOEItemID)
				 		If +retVar<0{
					 		TRollBack 1
					 		Set return=-102
					 		Quit	
					 	}
				 	}
			 		
			 	}
			}
			Quit:+return<0
			
			//未记录过的路径外医嘱根据配置确定是否要添加变异记录
			Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWCheckIsVarOEItem",AdmHospID)
			If (IsNewVar=1)&&(ret="Y||0"){
				Set varInputStr=PathwayID_"^^^^"_EpisID_"^^"_aOEItemID_"^"_aUserID_"^"_1
				Set retVar=##class(DHCMA.CPW.CP.PathwayVar).Update(varInputStr,"^")
				
		 		If +retVar<0{
			 		TRollBack 1
			 		Set return=-103
			 	}
			}
			Quit:+return<0
	 	}
	}
	Quit:+return<0 return
	
	If $TLevel>0 TCommit
	Quit 1
	
ExecuteOrderError
	If $TLevel>0 TRollBack 1 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator:	yankai
/// CreatDate:	2021-06-19
/// Desc:		执行主路径医嘱并回写记录
/// Input:		aPathwayID:出入径记录ID,
/// 			aEpisID:出入径记录阶段ID,
/// 			aOrdsStr:医生站回传医嘱参数,
/// 			aArcOEStr:回传参数中单项医嘱信息,
/// 			aUserID:操作人
/// Return:		成功保存医嘱执行记录的条数
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).ExeMainPwOrd("33","33||2","10052||1*485||60*V*||||||^","10052||1*485||60*V*||||||","10209!!1")
ClassMethod ExeMainPwOrd(aPathwayID As %String, aEpisID As %String, aOrdsStr As %String, aArcOEStr As %String, aUserID As %String) As %String
{
	New (aPathwayID,aEpisID,aOrdsStr,aArcOEStr,aUserID)
	Set return=0
	Quit:(aPathwayID="")||(aEpisID="")||(aOrdsStr="")||(aArcOEStr="") return
	//Set ^TEMPYK("ExeMainPwOrd")=$lb(aPathwayID,aEpisID,aOrdsStr,aArcOEStr,aUserID)
	
	Set ArcimID=$p(aArcOEStr,"*",1)				//医嘱项ID
	Set OEOriID=$p(aArcOEStr,"*",2)				//患者医嘱执行记录ID
	Set exeCount=0								//记录成功执行的医嘱个数
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID("",aPathwayID,"")
	
	Set $ZT="ExeMainPwOrdError"
	TStart
	
	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
 		Quit:xImplID=""
 		Quit:return<0
 		
 		Set flgExeItem=0			//项目执行标志
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:objImpl.CPPathwayComplDr'=""
 		
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:(TypeDesc'="重点医嘱")
 		Set FormItemID=objImpl.CPFormItemDr.%Id()
		
		// 中药方剂执行情况检查
		Set retChkTCM=..GetExeFormTCM(FormItemID,aOrdsStr,ArcimID)
		If retChkTCM'=""{
			If $p(retChkTCM,"^",1)=1{		//需要更新项目为已执行
				Set ret=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(aPathwayID,xImplID,"",aUserID,1,0)
				If (+ret<0) {
					TRollBack 1
					Set return=-1
					Quit
				}Else{ Set flgExeItem=1 } 	
			}
			Set retFormTCM=$p(retChkTCM,"^",2)
			For ind=1:1:$l(retFormTCM,",") {
				Set FormTCMID=$p(retFormTCM,",",ind)
				Set Parref=aPathwayID_"||"_xImplID
				Set Inputs=Parref_"^^^"_OEOriID_"^"_aUserID_"^"_FormTCMID
				Set ret=##class(DHCMA.CPW.CP.PathwayOrd).Update(Inputs)
				If (+ret<0) {
					TRollBack 1
					Set return=-2
					Quit
				}else{ Set exeCount=exeCount+1}
			}	
		}
		Quit:+return<0	//方剂检查出现错误直接退出
		
		//医嘱项/医嘱套执行情况检查
		Set retChkFormOrd=..GetExeFormOrd(FormItemID,ArcimID,AdmHospID)
		If retChkFormOrd'=""{
			If ($p(retChkFormOrd,"^",1)=1)&&(flgExeItem'=1){		//需要更新项目为已执行
				Set ret=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(aPathwayID,xImplID,"",aUserID,1,0)
				If (+ret<0) {
					TRollBack 1
					Set return=-3
					Quit
				}else{ Set flgExeItem=1}	
			}
			Set retFormOrd=$p(retChkFormOrd,"^",2)
			For ind=1:1:$l(retFormOrd,",") {
				Set FormOrdID=$p(retFormOrd,",",ind)
				Set Parref=aPathwayID_"||"_xImplID
				Set Inputs=Parref_"^^"_FormOrdID_"^"_OEOriID_"^"_aUserID_"^"_""
				Set ret=##class(DHCMA.CPW.CP.PathwayOrd).Update(Inputs)
				If (+ret<0) {
					TRollBack 1
					Set return=-4
					Quit
				}else{ Set exeCount=exeCount+1}
			}	
		}
 	}
 	
 	Quit:+return<0 return
 	
 	If $TLevel>0 TCommit
 	Set:exeCount'=0 return=exeCount
 	Quit return
 	
ExeMainPwOrdError
	If $TLevel>0 TRollBack 1 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator:	yankai
/// CreatDate:	2021-06-19
/// Desc:		执行合并症医嘱并回写记录
/// Input:		aPathwayID:出入径记录ID,
/// 			aEpisID:出入径记录阶段ID,
/// 			aOrdsStr:医生站回传医嘱参数,
/// 			aArcOEStr:回传参数中单项医嘱信息,
/// 			aEpisodeID:就诊ID
/// 				aUserID:操作人
/// Return:		成功保存医嘱执行记录的条数
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).ExeComplPwOrd(aPathwayID,aEpisID,aOrdsStr,aArcOEStr,aEpisodeID,aUserID)
ClassMethod ExeComplPwOrd(aPathwayID As %String, aEpisID As %String, aOrdsStr As %String, aArcOEStr As %String, aEpisodeID As %String, aUserID As %String) As %String
{
	New (aPathwayID,aEpisID,aOrdsStr,aArcOEStr,aEpisodeID,aUserID)
	Set return=0
	Quit:(aPathwayID="")||(aEpisID="")||(aOrdsStr="")||(aArcOEStr="")||(aEpisodeID="") return
	//Set ^TEMPYK("ExeComplPwOrd")=$lb(aPathwayID,aEpisID,aOrdsStr,aArcOEStr,aEpisodeID,aUserID)
	
	Set ArcimID=$p(aArcOEStr,"*",1)				//医嘱项ID
	Set OEOriID=$p(aArcOEStr,"*",2)				//患者医嘱执行记录ID
	Set exeCount=0								//记录成功执行的医嘱个数
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID)
	
	Set $ZT="ExeComplPwOrdError"
	TStart
	
	Set xSubComplID=""
	For {
		Set xSubComplID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"COMPL",xSubComplID))
		Quit:xSubComplID=""
		Quit:+return<0
		
		Set xCPComplID=aPathwayID_"||"_xSubComplID
		Set objCPCompl=##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(xCPComplID)
		Continue:'$IsObject(objCPCompl)
		Continue:'objCPCompl.CPIsActive
		Continue:'$IsObject(objCPCompl.CPComplFormDr)
		Set ComplFormID=objCPCompl.CPComplFormDr.%Id()
		
		Set xFormEpID=""
		For{
			Set xFormEpID=$o(^DHCMA.CPW.BT.PathFormD(ComplFormID,"EP",xFormEpID))
			Quit:xFormEpID=""
			
			Set FormEpID=ComplFormID_"||"_xFormEpID
			Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(FormEpID)
			Continue:'$IsObject(objFormEp)
			Continue:'objFormEp.EpIsActive
			
			Set xFormItmID=""
		 	For {
			 	Set xFormItmID=$o(^DHCMA.CPW.BT.PathFormD(ComplFormID,"EP",xFormEpID,"ITM",xFormItmID))
			 	Quit:xFormItmID=""
			 	
			 	Set FormItemID=ComplFormID_"||"_xFormEpID_"||"_xFormItmID
			 	Set objItm = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(FormItemID)
				Continue:'$IsObject(objItm)
				Continue:'objItm.ItemIsActive
	 			Continue:objItm.ItemCatDr.BTTypeDr.BTCode'="B"	//重点医嘱
	 			
	 			// 中药方剂执行情况检查
				Set retChkTCM=..GetExeFormTCM(FormItemID,aOrdsStr,ArcimID)
				If retChkTCM'=""{
					Set subImplID=""
					If $d(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",aPathwayID,FormItemID)){
						Set subImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",aPathwayID,FormItemID,""),-1) 
					}
					
					Set isExeItem=$p(retChkTCM,"^",1)
					Set inputStr=aPathwayID_"^"_subImplID_"^"_aEpisID_"^"_FormItemID_"^^0^"_aUserID_"^"_aEpisodeID_"^"_xCPComplID_"^"_isExeItem			
					Set retImpl=##class(DHCMA.CPW.CP.PathwayImpl).Update(inputStr,"^")
					If (+retImpl<0) {
						TRollBack 1
						Set return=-1
						Quit
					}Else{ Set flgExeItem=1 }
					 	
					Set retFormTCM=$p(retChkTCM,"^",2)
					For ind=1:1:$l(retFormTCM,",") {
						Set FormTCMID=$p(retFormTCM,",",ind)
						Set Parref=retImpl
						Set Inputs=Parref_"^^^"_OEOriID_"^"_aUserID_"^"_FormTCMID
						Set ret=##class(DHCMA.CPW.CP.PathwayOrd).Update(Inputs)
						If (+ret<0) {
							TRollBack 1
							Set return=-2
							Quit
						}Else{ Set exeCount=exeCount+1}
					}	
				}
				Quit:+return<0	//方剂检查出现错误直接退出
				
				//医嘱项/医嘱套执行情况检查
				Set retChkFormOrd=..GetExeFormOrd(FormItemID,ArcimID,AdmHospID)
				If retChkFormOrd'=""{
					Set subImplID=""
					If $d(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",aPathwayID,FormItemID)){
						Set subImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",aPathwayID,FormItemID,""),-1) 
					}
					
					Set isExeItem=$p(retChkFormOrd,"^",1)
					Set inputStr=aPathwayID_"^"_subImplID_"^"_aEpisID_"^"_FormItemID_"^^0^"_aUserID_"^"_aEpisodeID_"^"_xCPComplID_"^"_isExeItem	
					Set retImpl=##class(DHCMA.CPW.CP.PathwayImpl).Update(inputStr,"^")
					If (+retImpl<0) {
						TRollBack 1
						Set return=-3
						Quit
					}else{ Set flgExeItem=1}	
					
					Set retFormOrd=$p(retChkFormOrd,"^",2)
					For ind=1:1:$l(retFormOrd,",") {
						Set FormOrdID=$p(retFormOrd,",",ind)
						Set Parref=retImpl
						Set Inputs=Parref_"^^"_FormOrdID_"^"_OEOriID_"^"_aUserID_"^"_""
						Set ret=##class(DHCMA.CPW.CP.PathwayOrd).Update(Inputs)
						If (+ret<0) {
							TRollBack 1
							Set return=-4
							Quit
						}else{ Set exeCount=exeCount+1 }
					}	
				}
	 			
		 	}
		}
	}
	Quit:+return<0 return
	
	If $TLevel>0 TCommit
	Set:exeCount'=0 return=exeCount
 	Quit return
 	
ExeComplPwOrdError
 	If $TLevel>0 TRollBack 1 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator:		yankai
/// CreatDate:		2021-06-19
/// Description:	获取中药方剂执行情况
/// Inputs:			aFormEpItemID:表单项目ID,
/// 				aOrdsStr:医生站回传医嘱参数,
/// 				aArcimID:单项医嘱医嘱项ID
/// Return:			项目是否需执行(1/0)^匹配到的表单关联医嘱ID串
/// w ##class(DHCMA.CPW.CPS.InterfaceSrvNew).GetExeFormTCM(aFormEpItemID,aOrdsStr,aArcimID)
ClassMethod GetExeFormTCM(aFormEpItemID As %String, aOrdsStr As %String, aArcimID As %String) As %String
{
	New (aFormEpItemID,aOrdsStr,aArcimID)
	Set return=""
	Quit:($l(aFormEpItemID,"||")'=3)||(aOrdsStr="")||(aArcimID="") return
	//Set ^TEMPYK("GetExeFormTCM")=$lb(aFormEpItemID,aOrdsStr,aArcimID)
	
	Set FormID=$p(aFormEpItemID,"||",1)
	Set FormEpID=$p(aFormEpItemID,"||",2)
	Set FormEpItemID=$p(aFormEpItemID,"||",3)
	Quit:$d(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormID,FormEpID,FormEpItemID))<0 return  //该项目下不含方剂直接返回
	
	Set isNeedExeItem=0,strFormTCMID=""				//项目执行标志,需执行医嘱串	
	Set xTCMDr=""
	For {
		Set xTCMDr=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormID,FormEpID,FormEpItemID,xTCMDr))
		Quit:xTCMDr=""
		
		Set xFromTCMID=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormID,FormEpID,FormEpItemID,xTCMDr,""))
		Set FormTCMID=FormID_"||"_FormEpID_"||"_FormEpItemID_"||"_xFromTCMID
		
		Set isNeedExeItem=..CheckIsMatchTCM(xTCMDr,aOrdsStr)			//检查输入医嘱串是否包含该方剂君药,匹配到君药，则所属项目需要执行
		//Set:(IsNeedCheckTCMVar=1)&&(IsExe=1) IsNeedCheckTCMVar=0		//已匹配方剂君药的，不进行方剂变异检查					  
		
		Set xSubTCMId=""
		For {
			Set xSubTCMId=$o(^DHCMA.CPW.BT.PathTCMD(xTCMDr,"EXT",xSubTCMId))
			Quit:xSubTCMId=""
			Quit:$lf(strFormTCMID,FormTCMID)>0
				
			Set TCMOrdId=xTCMDr_"||"_xSubTCMId
			Set TCMOrder=##class(DHCMA.CPW.BT.PathTCMExt).GetObjById(TCMOrdId)
			Set OrdMastID=""
			Set OrdMastDesc=TCMOrder.BTOrdMastID  //表中存的医嘱描述,考虑兼容后面改为存医嘱ID
			Set:+OrdMastDesc>0 OrdMastID=OrdMastDesc
			Set TCMType=TCMOrder.BTTypeDr.BTDesc
			Set SPriority=TCMOrder.SPriority
			Set IOrdMastDesc=$$ALPHAUP^SSUTIL4(OrdMastDesc)
			If (OrdMastID="") {
				Set SubArcMID=$o(^ARCIM(0,"Desc",IOrdMastDesc,""),-1)
				Set VerID=$o(^ARCIM(0,"Desc",IOrdMastDesc,SubArcMID,""),-1)
				Set OrdMastID=SubArcMID_"||"_VerID
			}
			
			Continue:OrdMastID'=aArcimID
			Set strFormTCMID=strFormTCMID_$lb(FormTCMID)
		}	
	}
	
	Set:strFormTCMID'="" strFormTCMID=$lts(strFormTCMID,",")
	Set:strFormTCMID'="" return=isNeedExeItem_"^"_strFormTCMID
	
	Quit return
}

/// Creator:		yankai
/// CreatDate:		2021-06-19
/// Description:	获取医嘱项/医嘱套执行情况
/// Inputs:			aFormEpItemID:表单项目ID,
/// 				aArcimID:单项医嘱医嘱项ID
/// Return:			项目是否需执行(1/0)^匹配到的表单关联医嘱ID串
/// w ##class(DHCMA.CPW.CPS.InterfaceSrvNew).GetExeFormOrd(aFormEpItemID,aArcimID)
ClassMethod GetExeFormOrd(aFormEpItemID As %String, aArcimID As %String, aHospID As %String = "") As %String
{
	New (aFormEpItemID,aArcimID,aHospID)
	Set return=""
	Quit:($l(aFormEpItemID,"||")'=3)||(aArcimID="") return
	//Set ^TEMPYK("GetExeFormOrd")=$lb(aFormEpItemID,aArcimID)
	
	Set FormID=$p(aFormEpItemID,"||",1)
	Set FormEpID=$p(aFormEpItemID,"||",2)
	Set FormEpItemID=$p(aFormEpItemID,"||",3)
	
	Set aPHCGeneID="",aPHChemical="",aPHCGeneDesc=""
	Set ComDescType=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWGetCommonDescByType",aHospID)		//1处方通用名，2化学通用名
	If (ComDescType="1") {
		Set aPHCGeneID=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),8)),"^",20)
		Set:aPHCGeneID'="" aPHCGeneDesc=$p($g(^PHCGE("GE",aPHCGeneID)),"^",2)	//处方通用名
	} ElseIf (ComDescType="2") {
		Set aPHChemical=##class(PHA.FACE.OUT.Com).GetPHChemicalByArc(aArcimID)
		Set aPHCGeneDesc=$p(aPHChemical,"^",3)	//化学通用名
	} Else {
	}
	Set:aPHCGeneDesc="" aPHCGeneDesc=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),1)),"^",2)    	//通用名为空则取医嘱名称	
	
	Set isNeedExeItem=0,strFormOrdID=""		//项目执行标志,需执行医嘱串
	Set xFormOrdID=""
	For {
		Set xFormOrdID=$o(^DHCMA.CPW.BT.PathFormD(FormID,"EP",FormEpID,"ITM",FormEpItemID,"ORD",xFormOrdID))
		Quit:xFormOrdID=""
		
		Set FormOrdID=FormID_"||"_FormEpID_"||"_FormEpItemID_"||"_xFormOrdID
		Set objOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(FormOrdID)
		Continue:'$IsObject(objOrd)
		Set OrdMastID=objOrd.OrdMastID
		Continue:OrdMastID=""
		
		If (OrdMastID'["||"){					//医嘱套
			Set OrderMastIDStr=##class(DHCMA.CPW.CPS.InterfaceSrv).GetOSItems(OrdMastID)
			For oind=1:1:$l(OrderMastIDStr,"^") {
				Set xOrdMastID=$p(OrderMastIDStr,"^",oind)	
				Continue:aArcimID'=xOrdMastID
				Set:$lf(strFormOrdID,FormOrdID)=0 strFormOrdID=strFormOrdID_$lb(FormOrdID)
			}
		}else{									//医嘱项
			Set PHCGeneDesc=""					//通过通用名匹配
			If (ComDescType="1") {
				Set PHCGeneID=$p($g(^ARCIM(+OrdMastID,+$p(OrdMastID,"||",2),8)),"^",20)
				Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)	//处方通用名
			} ElseIf (ComDescType="2") {
				Set PHChemical=##class(PHA.FACE.OUT.Com).GetPHChemicalByArc(OrdMastID)
				Set PHCGeneDesc=$p(PHChemical,"^",3)	//化学通用名
			} Else {
			}
			Set:PHCGeneDesc="" PHCGeneDesc=$p($g(^ARCIM(+OrdMastID,+$p(OrdMastID,"||",2),1)),"^",2)    //通用名为空则取医嘱名称
			
			Continue:aPHCGeneDesc'=PHCGeneDesc
			Set:$lf(strFormOrdID,FormOrdID)=0 strFormOrdID=strFormOrdID_$lb(FormOrdID)
		}	
		Set:objOrd.OrdIsFluInfu=1 isNeedExeItem=1	//只有主医嘱执行，此项目则需要是执行	
	}
	
	Set:strFormOrdID'="" strFormOrdID=$lts(strFormOrdID,",")
	Set:strFormOrdID'="" return=isNeedExeItem_"^"_strFormOrdID
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2021.01.05
/// Description:  检查新开医嘱是否已经添加变异原因
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       aEpisodeID,aOEItmMastID
/// Return：      1是，0否
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CheckIsAddVarToOrd("")
ClassMethod CheckIsAddVarToOrd(aPathwayID As %String, aEpisID As %String, aOEItmMastID As %String) As %Boolean
{
	New (aPathwayID,aEpisID,aOEItmMastID)
	Set return=0
	Quit:(aPathwayID="")||(aEpisID="")||(aOEItmMastID="") return
	
	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",aPathwayID,aEpisID,xVarID))
		Quit:xVarID=""
		
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
 		Continue:'$IsObject(objVar)
	 	//Continue:'objVar.CPIsActive	//对医嘱而言，CPIsActive=0表示未回写orderID
	 	Continue:objVar.CPOrdDID=""
	 	Continue:$IsObject(objVar.CPImplDr)		//路径外医嘱没有项目指针
	 	
 		Set xOrdDID=objVar.CPOrdDID
 		Set:xOrdDID["^" xOrdDID=$p(xOrdDID,"^",1)
 		If objVar.CPIsActive{
	 		Set OESubID=$p(xOrdDID,"||",2)
			Set OEItmMastID = $p($g(^OEORD(+xOrdDID,"I",OESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
	 	}Else {
		 	Set OEItmMastID=xOrdDID
		}
		
		If (aOEItmMastID=OEItmMastID){
			Set return=1
			Quit
		}
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-10-16
/// Description:  检查是否路径外医嘱
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       aEpisodeID,aOEItmMastID
/// Return：      1是路径外医嘱，0否
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CheckIsVarOrder("41!!1","11212||1","95")
ClassMethod CheckIsVarOrder(aEpisodeID As %String, aOEItmMastID As %String, aOrdlocID As %String) As %String
{
	New (aEpisodeID,aOEItmMastID,aOrdlocID)
	Set return=""
	Quit:(aEpisodeID="")||(aOEItmMastID="") return
	
	Set xEpisodeID=$p(aEpisodeID,"!!",1)
	Set AdmLocID=$p($g(^PAADM(xEpisodeID)),"^",4)  //就诊科室
	Quit:(aOrdlocID'=AdmLocID) return			   //非就诊科室下的医嘱不检查，比如手术室等
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set AdmHospID=$p($g(^CTLOC(AdmLocID)),"^",22)_"!!"_SYSDr
	
	Set ArcimSubCat=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOutFormArcimSubCat",AdmHospID)	//不检查的医嘱子类
	Set ArcimCateg=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOutFormArcimCateg",AdmHospID)	//不检查的医嘱大类
	
	Set ItemSubCatDR=$P($g(^ARCIM($P(aOEItmMastID,"||",1),$P(aOEItmMastID,"||",2),1)),"^",10)
	Set ItemSubCatDesc=""
	Set:ItemSubCatDR'="" ItemSubCatDesc=$p(^ARC("IC",ItemSubCatDR),"^",2)
	Set ItemSubCatDesc=","_ItemSubCatDesc_","
	If (ArcimSubCat'="") {
		Set ArcimSubCat=","_ArcimSubCat_","
		Quit:ArcimSubCat[ItemSubCatDesc return
	}
	If (ItemSubCatDR'="") {
		Set OrdCatDR=$p(^ARC("IC",ItemSubCatDR),"^",8)
		Set OrdCatDesc=$p(^OEC("ORCAT",OrdCatDR),"^",2)
	} Else {
		Set OrdCatDesc=""
	}
	//判断是否维护过非变异医嘱
	//Set ret=..CheckOrdVar(aEpisodeID,aOEItmMastID,OrdCatDR,ItemSubCatDR,aOrdlocID)
	//Quit:ret=1 return
	Set OrdCatDesc=","_OrdCatDesc_","
	If (ArcimCateg'="") {
		Set ArcimCateg=","_ArcimCateg_","
		Quit:ArcimCateg[OrdCatDesc return
	}
	
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录，即当前路径
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	Set EpisID=objPathway.CPEpisDr.%Id()		//当前执行阶段
	
	Set InLocID=objPathway.CPInLocID
	Quit:(aOrdlocID'=$p(InLocID,"!!",1)) return	//非入径科室下的医嘱不算变异955717
	
	Set ret=##class(DHCMA.CPW.CPS.InterfaceSrv).CheckIsAddVarToOrd(PathwayID,EpisID,aOEItmMastID)	//判断是否已经添加过变异原因
	Quit:ret return
	
	Set IsVarOrder=1
	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,EpisID,xImplID))
 		Quit:xImplID=""
 		Quit:IsVarOrder=0
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:objImpl.CPPathwayComplDr'=""
 		
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:(TypeDesc'="重点医嘱")
 		
 		Set FormItemID=objImpl.CPFormItemDr.%Id()
 		Set FormID =$p(FormItemID,"||",1)
		Set FormEpID =$p(FormItemID,"||",2)
		Set FormEpItemID =$p(FormItemID,"||",3)
		
		Set retMapOrd=..GetExeFormOrd(FormItemID,aOEItmMastID,AdmHospID)
		Set:$p(retMapOrd,"^",2)'="" IsVarOrder=0
		
 	}
 	Quit:IsVarOrder=0 IsVarOrder
 	
 	Set xSubComplID=""
	For {
		Set xSubComplID=$o(^DHCMA.CPW.CP.PathwayD(PathwayID,"COMPL",xSubComplID))
		Quit:xSubComplID=""
		Quit:IsVarOrder=0
		
		Set xCPComplID=PathwayID_"||"_xSubComplID
		Set objCPCompl=##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(xCPComplID)
		Continue:'$IsObject(objCPCompl)
		Continue:'objCPCompl.CPIsActive
		Continue:'$IsObject(objCPCompl.CPComplFormDr)
		Set ComplFormID=objCPCompl.CPComplFormDr.%Id()
		
		Set xCFormEpID=""
		For{
			Set xCFormEpID=$o(^DHCMA.CPW.BT.PathFormD(ComplFormID,"EP",xCFormEpID))
			Quit:xCFormEpID=""
			Quit:IsVarOrder=0
			
			Set CFormEpID=ComplFormID_"||"_xCFormEpID
			Set objCFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(CFormEpID)
			Continue:'$IsObject(objCFormEp)
			Continue:'objCFormEp.EpIsActive
			
			Set xCFormItmID=""
	 		For {
			 	Set xCFormItmID=$o(^DHCMA.CPW.BT.PathFormD(ComplFormID,"EP",xCFormEpID,"ITM",xCFormItmID))
			 	Quit:xCFormItmID=""
			 	Quit:IsVarOrder=0
			 	
			 	Set CFormItemID=ComplFormID_"||"_xCFormEpID_"||"_xCFormItmID
			 	Set objItm = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(CFormItemID)
				Continue:'$IsObject(objItm)
				Continue:'objItm.ItemIsActive
	 			Continue:objItm.ItemCatDr.BTTypeDr.BTCode'="B"	//重点医嘱
	 			
				Set retMapOrd=..GetExeFormOrd(CFormItemID,aOEItmMastID,AdmHospID)
				Set:$p(retMapOrd,"^",2)'="" IsVarOrder=0
	 		}	
		}
	}
 	
 	Set return=IsVarOrder
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-11
/// Description:  （添加变异）查询路径外医嘱
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
///               aOEItmMastList : 医嘱项ID拼成的串(^)
/// 				  aOrdlocID : 下医嘱科室ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.InterfaceSrv","QryCPWVarOrder","361","493||1^","114","")
Query QryCPWVarOrder(aEpisodeID As %String, aOEItmMastList As %String, alocID As %String, aWardID As %String) As %Query(ROWSPEC = "ind:%String,ARCIMID:%String,ARCIMDesc:%String,checkOrd:%String,VarDesc:%String,VarTxt:%String") [ SqlProc ]
{
}

ClassMethod QryCPWVarOrderExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aOEItmMastList As %String, alocID As %String, aWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Quit:(aEpisodeID="")||(aOEItmMastList="") $$$OK
 	Quit:(aWardID'="") $$$OK	//病区ID不为空时，说明此时是护士下医嘱，都不算作变异
 	
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	//非入径状态不检查
	Set CPWStatus=..GetCPWStatusToDOC(aEpisodeID)
	Quit:CPWStatus'="1" $$$OK
	
 	For xOEind=1:1:$l(aOEItmMastList,"^") {
 		Set xOEItmMastID=$p(aOEItmMastList,"^",xOEind)
 		Continue:xOEItmMastID=""
 		
 		Set flg=..CheckIsVarOrder(aEpisodeID,xOEItmMastID,alocID)
 		Continue:'flg
 		
 		Set ARCIMDesc=$p($g(^ARCIM(+xOEItmMastID,1,1)),"^",2)	//医嘱项描述
 		Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
 		
		Set Data=$lb(ind,xOEItmMastID,ARCIMDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWVarOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVarOrderExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVarOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVarOrderExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-10-16
/// Description:  删除变异原因临时数据
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       aFlg
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).DeleteTmpVarOrd("N")
ClassMethod DeleteTmpVarOrd(aFlg As %String) As %String
{
	New (aFlg)
	Set return=""
	Quit:aFlg="" return
	
	If (aFlg="Y") {
		For ind=1:1:$ll(^tmp.DCHMA.CPW.VarOrd) {
			Set tmpID=$lg(^tmp.DCHMA.CPW.VarOrd,ind)
			Continue:tmpID=""
			
			Set ret=##class(DHCMA.CPW.CP.PathwayVar).Delete(tmpID)
			Set return=ret
		}
		Kill ^tmp.DCHMA.CPW.VarOrd
	} Else {
		Kill ^tmp.DCHMA.CPW.VarOrd
		Set return=1
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-13
/// Description:  获取项目关联医嘱执行信息
/// Table：       DHCMA.CPW.CP.PathwayOrd
/// Input：       aFlg
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetImpOrdInfo("73","1","FJ:17:17||1||8||17")
ClassMethod GetImpOrdInfo(aCPWID As %String, aEpisID As %String, aFormOrdID As %String) As %String
{
	New (aCPWID,aEpisID,aFormOrdID,%session)
	Set return=""
	Quit:(aCPWID="")||(aEpisID="")||(aFormOrdID="") return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	if (aFormOrdID["FJ")
	{
		//Set TCMDr=$p(aFormOrdID,":",2)
		Set PathTCMID=$p(aFormOrdID,":",2)
		//Set aFormItemID=$p(aFormOrdID,":",3)
		Set FormTCMID=$p(aFormOrdID,":",3)
		Set aFormItemID=$p(FormTCMID,"||",1,3)
	}else{
		Set objFormItmOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(aFormOrdID)
		Quit:'$IsObject(objFormItmOrd)
		Set OrdMastID =objFormItmOrd.OrdMastID		//表单项目中关联的医嘱项ID
		Set aFormItemID=$p(aFormOrdID,"||",1)_"||"_$p(aFormOrdID,"||",2)_"||"_$p(aFormOrdID,"||",3)
	}
	
	Set xImplID=""
 	For {
	 	Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParFormItem",aCPWID,aFormItemID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aCPWID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		Continue:'objImpl.CPIsActive
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Continue:TypeDesc'="重点医嘱"
 		Set IsSystem=objImpl.CPIsSystem
 		Set IsImp=+objImpl.CPIsImp
		//Continue:'IsImp		//过滤未执行的项目
		Set FormItemID=objImpl.CPFormItemDr.%Id()
		
		Set IsSame=""
		if (aFormOrdID["FJ") {
			Set xID="",IsSame=1						//方剂默认原医嘱
			For {
				Set xID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofFJParRef",aCPWID,xImplID,FormTCMID,xID))
				Quit:xID=""
				Set objCPOrd=##class(DHCMA.CPW.CP.PathwayOrd).GetObjById(aCPWID_"||"_xImplID_"||"_xID)
				Continue:'$IsObject(objCPOrd)
				
				Set IsActive=objCPOrd.CPIsActive
				Continue:'IsActive
				
				Set OrdID=objCPOrd.CPOrdID		//实际执行的医嘱ID
				Continue:OrdID=""
				continue:objCPOrd.CPFormOrdDr'=""
				Set OEORIChildsub=+$p(OrdID,"||",2)
				Set OEORIItmMastDR = $p($g(^OEORD(+OrdID,"I",OEORIChildsub,1)),"^",2) // 医嘱项指针 ARC_ItmMast
				Set ARCIMDesc=$p($g(^ARCIM(+OEORIItmMastDR,1,1)),"^",2)				//医嘱名称
				Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
				Set OEORISttDat = $p($g(^OEORD(+OrdID,"I",OEORIChildsub,1)),"^",9) // 开始日期 
				Set OEORISttTim = $p($g(^OEORD(+OrdID,"I",OEORIChildsub,1)),"^",10) // 开始时间
				Set:OEORISttDat'="" OEORISttDat=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OEORISttDat)
				Set:OEORISttTim'="" OEORISttTim=$zt(OEORISttTim,1)
				Set DateTime=OEORISttDat_" "_OEORISttTim
				Set OrdInfo=ARCIMDesc_"("_DateTime_")"
				Set return=return_"<br />"_OrdInfo
			}
			Set:return'="" return=IsSame_"^"_$e(return,7,$l(return))
			
		}else{
			Set xCPOrdID="",IsSame=0
			For {
				Set xCPOrdID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofParRef",aCPWID,xImplID,aFormOrdID,xCPOrdID))
				Quit:xCPOrdID=""
				
				Set objCPOrd=##class(DHCMA.CPW.CP.PathwayOrd).GetObjById(aCPWID_"||"_xImplID_"||"_xCPOrdID)
				Continue:'$IsObject(objCPOrd)
				
				Set IsActive=objCPOrd.CPIsActive
				Continue:'IsActive
				
				Set OrdID=objCPOrd.CPOrdID		//实际执行的医嘱ID
				Continue:OrdID=""
				For ind=1:1:$l(OrdID,"^"){
					Set xOrdID=$p(OrdID,"^",ind)
					Continue:xOrdID=""
					Set OEORIChildsub=+$p(xOrdID,"||",2)
					Set OEORIItmMastDR = $p($g(^OEORD(+xOrdID,"I",OEORIChildsub,1)),"^",2) // 医嘱项指针 ARC_ItmMast
					Set ARCIMDesc=$p($g(^ARCIM(+OEORIItmMastDR,1,1)),"^",2)				//医嘱名称
					Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
					Set OEORISttDat = $p($g(^OEORD(+xOrdID,"I",OEORIChildsub,1)),"^",9) // 开始日期 
					Set OEORISttTim = $p($g(^OEORD(+xOrdID,"I",OEORIChildsub,1)),"^",10) // 开始时间
					Set:OEORISttDat'="" OEORISttDat=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OEORISttDat)
					Set:OEORISttTim'="" OEORISttTim=$zt(OEORISttTim,1)
					Set DateTime=OEORISttDat_" "_OEORISttTim
					Set OrdInfo=ARCIMDesc_"("_DateTime_")"
					Set:OrdMastID=OEORIItmMastDR IsSame=1
					Set return=return_"<br />"_OrdInfo	
				}
				If OrdMastID'["||"{									//医嘱套默认原医嘱
					Set IsSame=1
				}Else{
					Set:OrdMastID=OEORIItmMastDR IsSame=1			//医嘱项检查原医嘱还是替换医嘱
				}
			}
			Set:return'="" return=IsSame_"^"_$e(return,7,$l(return))
		}
		Quit:return'=""
 	}
 	
 	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-01-26
/// Description:  To护士站，查询本病区内入径患者
/// Table：       
/// Input：       q : 无用
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.InterfaceSrv","QryCPWVPatByWard","5")
Query QryCPWVPatByWard(q As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,BedNo:%String,Status:%String") [ SqlProc ]
{
}

ClassMethod QryCPWVPatByWardExecute(ByRef qHandle As %Binary, q As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	
 	Set xWardID=$g(%session.Data("LOGON.WARDID"))
 	Set xRoomID=""
	For {
		Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
		Quit:xRoomID=""
		
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAADMi("CurrWard",xWardID,xRoomID,xEpisodeID))
			Quit:xEpisodeID=""
			
			Set LocID=$p($g(^PAADM(xEpisodeID)),"^",4)
			
			Set AdmType=$p(^PAADM(xEpisodeID),"^",2)
			Continue:AdmType'="I"
			
			Set VisitStatus=$p(^PAADM(xEpisodeID),"^",20)
			Continue:VisitStatus'="A"
			
			Set CPWStatus=..GetCPWStatus(xEpisodeID_"!!"_SYSDr)
			Continue:CPWStatus=""
			Continue:("I-C-O-"'[CPWStatus)
			
			Set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(xEpisodeID_"!!"_SYSDr)
			Continue:'$IsObject(objPat)
			
			Set Status=$Case(CPWStatus,"I":"入径","C":"完成","O":"出径")
			Set PatientID=objPat.PAPatientID
			Set PapmiNo=objPat.PAPapmiNo
			Set MrNo=objPat.PAMrNo
			Set PatName=objPat.PAPatName
			Set PatSex=objPat.PASex
			Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
			Set BedNo=objPat.PAAdmBed
			Set Data=$lb(ind,xEpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,BedNo,Status)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWVPatByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVPatByWardExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVPatByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVPatByWardExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2019-01-26
/// Description:  切换患者时，初始赋值
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetPatName()
ClassMethod GetPatName(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set:aEpisodeID["!!" aEpisodeID=$p(aEpisodeID,"!!",1)
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)      // 病人ID
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)   // 病人姓名
	
	Quit PatName
}

/// Creator：     zhuguozhang
/// CreatDate：   2019-03-01
/// Description:  进入路径后，进入单病种管理
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetInSD()
ClassMethod GetInSD(aEpisodeID As %String, aInputs As %String) As %String
{
	new (aEpisodeID,aInputs)
	Set return=-1
	Set CPID	= $p(aInputs,"^",1)
	Set PMastID	= $p(aInputs,"^",2)
	Set UserID	= $p(aInputs,"^",3)
	Set LocID	= $p(aInputs,"^",4)
	Set WardID	= $p(aInputs,"^",5)
	Set DocID=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Set:$IsObject(objUser) DocID=objUser.BTCareProvID
	Set PathMast=##class(DHCMA.CPW.BT.PathMast).GetObjById(PMastID)
	Set (PCEntityID,QCEntityID)=""
	//修改表结构，两个字段存ID。jpp 2020-05-22
	Set PCEntityID=PathMast.BTPCEntityDr
	Set QCEntityID=PathMast.BTQCEntityDr
	Set MrListStr=aEpisodeID_"^"_PCEntityID_"^"_QCEntityID_"^"_DocID_"^"_LocID_"^"_WardID_"^"_CPID
	Set return=##class(DHCMA.CPW.SDS.QCMrListSrv).InQCEntity(MrListStr)	
	Quit return
}

/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetMrListIDByCPID(21)
ClassMethod GetMrListIDByCPID(CPID As %String) As %String
{
	n (CPID)
	Set return=-1
	Quit:'$d(^DHCMA.CPW.SD.QCMrListI("IndexCPID"," "_CPID)) return
	Set MrListID=$o(^DHCMA.CPW.SD.QCMrListI("IndexCPID"," "_CPID,""),-1)
	Quit MrListID
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019年7月8日
/// Description:  根据医嘱套ID，取医嘱明细
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).GetOSItems(3494)
ClassMethod GetOSItems(ARCOSRowid As %String) As %String
{
	New (ARCOSRowid)
	Set return=""
	Quit:ARCOSRowid="" return
	
	Set ARCOSDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(ARCOSRowid)
	Quit:ARCOSDateRowid=""
	
	Set OSItems=""
	Set xID=""
	For {
		Set xID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",xID))
		Quit:xID=""
		
		Set Itmstr=$g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",xID))
		Continue:Itmstr=""
		
		Set ARCIMRowid=$p(Itmstr,"^",1)
		Set OSItems=OSItems_"^"_ARCIMRowid
	}
	Set:OSItems'="" OSItems=$e(OSItems,2,$l(OSItems))
	
	Quit OSItems
}

/// Creator：     yankai
/// CreatDate：   2019-12-07
/// Description:  检查输入的医嘱串是否含指定方剂君药
/// Table：       
/// Input：       1：含；0：不含
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CheckIsMatchTCM()
ClassMethod CheckIsMatchTCM(aTCMID As %String, aOrdStr As %String) As %String
{
	New (aTCMID,aOrdStr)
	Set return=0
	Quit:(aTCMID="")||(aOrdStr="") return
	
	Set MastIDStr=""
	For OrderInd=1:1:$l(aOrdStr,"^") {
		Set MastIDStr=MastIDStr_$lb($p($p(aOrdStr,"^",OrderInd),"*",1))
	}
	
	Set DicType=##Class(DHCMA.Util.BTS.DictionarySrv).GetDicIDByCode("CPWTCMOrdType","01")	//获取君药字典ID
	Set xSubTCMID=""
	Set retOrdMstList=""
	For {
		Set xSubTCMID=$o(^DHCMA.CPW.BT.PathTCMI("EXT","IdxofTypeDr",DicType,aTCMID,xSubTCMID))
		Quit:return=1
		Quit:xSubTCMID=""
		
		Set objSubTCM=##class(DHCMA.CPW.BT.PathTCMExt).GetObjById(aTCMID_"||"_xSubTCMID)
		Continue:'$IsObject(objSubTCM)
		Set OrdMastDesc=objSubTCM.BTOrdMastID
		Set IOrdMastDesc=$$ALPHAUP^SSUTIL4(OrdMastDesc)
		Set ArcMID=$o(^ARCIM(0,"Desc",IOrdMastDesc,""),-1)
		Set VerID=$o(^ARCIM(0,"Desc",IOrdMastDesc,ArcMID,""),-1)
		Set OrdMastID=ArcMID_"||"_VerID
		Set:$lf(MastIDStr,OrdMastID)>0 return=1
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2020-04-10
/// Description:  存储选择医嘱套明细结果，添加医嘱后清除
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).SaveARCOSItems()
ClassMethod SaveARCOSItems(aEpisodeID As %String, aARCIMRowids As %String, aARCOSID As %String) As %String
{
	New (aEpisodeID,aARCIMRowids,aARCOSID)
	Set return=""
	Quit:(aEpisodeID="")||(aARCIMRowids="")||(aARCOSID="") return
	
	Kill ^tmpDHCMA.CPW.ARCOSItems(aEpisodeID,aARCOSID)
	Set ^tmpDHCMA.CPW.ARCOSItems(aEpisodeID,aARCOSID,"Open")=""
	Set ind=1
	For {
		Set xItemStr=$p(aARCIMRowids,"^",ind)
		Quit:xItemStr=""
		
		Set xARCIMID=$p(xItemStr,"*",1)
		Set xSeqNo=$p(xItemStr,"*",2)
		Set ^tmpDHCMA.CPW.ARCOSItems(aEpisodeID,aARCOSID,xARCIMID)=xSeqNo
		
		Set ind=ind+1
	}
	
	Quit 1
}

/// Creator：     yankai
/// CreatDate：   2020-09-24
/// Description:  入径提示时，检查是否满足生成质控病种路径条件
/// Table：       
/// Input：       
/// Return：     1:满足条件；0：不满足条件 
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CheckAddQCSDCPW(26,'95!!1')
ClassMethod CheckAddQCSDCPW(aQCEntityID As %String, aAdmLocID As %String) As %String
{
	
	New (aQCEntityID,aAdmLocID)
	Set return=0
	Quit:(aQCEntityID="")||(aAdmLocID="") return
	
	Set objEntity = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(aQCEntityID)
	Quit:'$IsObject(objEntity) return
	Quit:objEntity.BTIsActive'=1 return
	Set BTLocation = objEntity.BTLocation
	Quit:(BTLocation'="")&&($listfind(BTLocation,aAdmLocID)=0) return
	
	Quit 1
}

/// Creator：     yankai
/// CreatDate：   2020-09-24
/// Description:  入径提示时，检查是否满足生成付费病种路径条件
/// Table：       
/// Input：       
/// Return：     1:满足条件；0：不满足条件 
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CheckAddPCSDCPW(26,"95!!1")
ClassMethod CheckAddPCSDCPW(aPCEntityID As %String, aAdmLocID As %String = "") As %String
{
	
	New (aPCEntityID,aAdmLocID)
	Set return=0
	Quit:aPCEntityID="" return
	
	//检查配置是否启用基于临床路径的病种控费模块
	Set IsOpenPCSDMod=##class(DHCMA.Util.BT.Config).GetValueByCode("SDIsOpenPCModBaseCPW")
	Quit:IsOpenPCSDMod'=1 return
	
	Set objPCEntity=##class(DHCMA.CPW.SD.PCEntity).GetObjById(aPCEntityID)
	Quit:'$IsObject(objPCEntity) return
	Quit:objPCEntity.BTIsActive'=1 return
	
	Quit 1
}

/// Creator：     zqy
/// CreatDate：   2020-09-24
/// Description:  判断医嘱是否在医嘱维护页面中
/// Table：       
/// Input：        
/// w ##class(DHCMA.CPW.CPS.InterfaceSrv).CheckOrdVar("850!!1","4",9,9,"")
ClassMethod CheckOrdVar(aEpisodeID As %String, aOEItmMastID As %String, aOrdCatDR As %String, aItemSubCatDR As %String, aOrdlocID As %String) As %String
{
	
	New (aEpisodeID,aOEItmMastID,aOrdCatDR,aItemSubCatDR,aOrdlocID)
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set HospID=$p($g(^CTLOC(+aOrdlocID)),"^",22)
	Set:HospID'["!!" HospID=HospID_"!!"_SYSDr
	Set:aOrdlocID'["!!" aOrdlocID=aOrdlocID_"!!"_SYSDr
	Set return=""
	Set PathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)	//取最新一条记录，即当前路径
	
	Quit:PathwayID="" return
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(objPathway) return
	Set TypeID=objPathway.CPFormDr.FormPathDr.BTTypeDr.%Id()
	Set MastID=objPathway.CPFormDr.FormPathDr.%Id()
	
	if ($d(^DHCMA.CPW.BT.NoVarOrderI("IdxofARC","M",aOEItmMastID))){
		Set xID=""
		For{
			Set xID=$o(^DHCMA.CPW.BT.NoVarOrderI("IdxofARC","M",aOEItmMastID,xID))
			Quit:xID=""
			Quit:return=1
			Set obj=##class(DHCMA.CPW.BT.NoVarOrder).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set Level=obj.BTLevel
			Set LevelType=obj.BTLevelType
			Set:(Level="H")&&(LevelType=HospID) return=1
			Set:(Level="L")&&(LevelType=aOrdlocID) return=1
			Set:(Level="T")&&(LevelType=TypeID) return=1
			Set:(Level="P")&&(LevelType=MastID) return=1
		}
	}elseif ($d(^DHCMA.CPW.BT.NoVarOrderI("IdxofARC","G",aItemSubCatDR))){
		Set xID=""
		For{
			Set xID=$o(^DHCMA.CPW.BT.NoVarOrderI("IdxofARC","G",aItemSubCatDR,xID))
			Quit:xID=""
			Quit:return=1
			Set obj=##class(DHCMA.CPW.BT.NoVarOrder).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set Level=obj.BTLevel
			Set LevelType=obj.BTLevelType
			Set:(Level="H")&&(LevelType=HospID) return=1
			Set:(Level="L")&&(LevelType=aOrdlocID) return=1
			Set:(Level="T")&&(LevelType=TypeID) return=1
			Set:(Level="P")&&(LevelType=MastID) return=1
		}
		
	}elseif ($d(^DHCMA.CPW.BT.NoVarOrderI("IdxofARC","C",aOrdCatDR))){
		Set xID=""
		For{
			Set xID=$o(^DHCMA.CPW.BT.NoVarOrderI("IdxofARC","C",aOrdCatDR,xID))
			Quit:xID=""
			Quit:return=1
			Set obj=##class(DHCMA.CPW.BT.NoVarOrder).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set Level=obj.BTLevel
			Set LevelType=obj.BTLevelType
			Set:(Level="H")&&(LevelType=HospID) return=1
			Set:(Level="L")&&(LevelType=aOrdlocID) return=1
			Set:(Level="T")&&(LevelType=TypeID) return=1
			Set:(Level="P")&&(LevelType=MastID) return=1
		}
	}
	Quit return
}

}
