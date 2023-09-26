/// 名称：DHCMA.CPW.OPCPS.OPInterfaceSrv
/// 描述：门诊临床路径对外接口相关服务类
/// 编写者：yankai
/// 编写日期：2019-06-06 
Class DHCMA.CPW.OPCPS.InterfaceSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2019-06-06
/// Description:  查询符合准入条件的路径
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
/// Input：       aType : 1诊断(含中医、西医),2手术,3其他
/// Return：      路径表单ID^路径描述(版本)^上次门诊路径VisitID^符合诊断,路径表单ID^路径描述(版本)^上次门诊路径VisitID^符合诊断...
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetOPCPWList(550,1,"")
ClassMethod GetOPCPWList(aEpisodeID As %String, aType As %String = "1", aKeyWords As %String = "") As %String
{
	New (aEpisodeID,aType,aKeyWords,%session)
	Set return=""
 	Quit:(aEpisodeID="") return
 	
 	Set LangID=20,Languages=""
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set xEpisodeID=aEpisodeID
 	Set:xEpisodeID["!!" xEpisodeID=$p(xEpisodeID,"!!",1)
 	 
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set AdmLocID=$p($g(^PAADM(xEpisodeID)),"^",4)  				//就诊科室
 	Set AdmHospID=$p($g(^CTLOC(AdmLocID)),"^",22)_"!!"_SYSDr
	Set:AdmLocID'["!!" AdmLocID=AdmLocID_"!!"_SYSDr
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
 	 
 	//检查配置“门诊路径是否启用通过诊断匹配提示入径”
 	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPCheckDiagnos",AdmHospID)					
 	Quit:ret'="Y" return																
 	
 	//本次就诊已入径的不提示入径(保证一次就诊只存在一条在径记录)
 	Set IsInMastPath=##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).CheckIsInPath(aEpisodeID)
 	Quit:IsInMastPath=1 return
 	
 	//已存在不入径记录的不提示入径
 	Set CurPathStatus = ##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).GetPathStatus(aEpisodeID)
 	Quit:CurPathStatus="T" return
 	
 	//取患者身份信息
 	Set PatIDAndIDCardCode=##class(DHCMA.CPW.IO.FromDoc).GetPatIDAndIDCardCode(aEpisodeID)
 	Set IDCardCode=$p(PatIDAndIDCardCode,"^",2)
 	//Quit:IDCardCode="" return
 	
 	//检查配置“门诊路径准入就诊类型”
	Set AdmType=$p($g(^PAADM(xEpisodeID)),"^",2)  												//就诊类型
 	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPGetInAdmType",AdmHospID)					
 	Quit:ret'[AdmType return
 	
 	Set $ZT="DHCMAGetCPWList"
 	Kill tmpOPCPW("OPCPWList",$J)
 	Kill tmpOPCPW("AllMatchOPCPWList",$J)
 	
 	//获取配置，是否只检查患者主诊断
	Set IsOnlyChkMainDiag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPIsOnlyCheckMainDiag",AdmHospID)
 	
 	Set tmpCPWList=""
 	If (aType=1){																				//西医诊断、中医诊断
	 	Set MRAdm=$p($g(^PAADM(+xEpisodeID)),"^",61)
		Quit:MRAdm="" return
		
		Set xDiagnosID=""
		For {
			Set xDiagnosID=$o(^MR(MRAdm,"DIA",xDiagnosID))
			Quit:xDiagnosID=""
			
			Set tmpDiagnos=$g(^MR(MRAdm,"DIA",xDiagnosID))
			Set DiaDate=$p(tmpDiagnos,"^",7)
			Continue:DiaDate'=+$h	//只检查当天下的诊断
			Continue:(IsOnlyChkMainDiag="Y")&&($p($g(^MR(MRAdm,"DIA",xDiagnosID,1)),"^",20)'="Y")   // 如果只检查主诊断，则非主诊断直接过滤
			
			Set ICDDxID=$p(tmpDiagnos,"^",1)
			Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)											//ICD10代码
			Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)										//ICD诊断描述
			Set ICDDesc=$tr(ICDDesc," ","")
			Set DesID=$o(^MR(MRAdm,"DIA",xDiagnosID,"DES",0))
			Set:DesID="" DesID=1
			Set ICDDHC=$g(^MR(MRAdm,"DIA",xDiagnosID,"DHC",DesID))								//???好像不存在
			Set ICDDES=$g(^MR(MRAdm,"DIA",xDiagnosID,"DES",DesID))								//诊断备注
			Set MRDiagType=$o(^MR(MRAdm,"DIA",xDiagnosID,"TYP",0))
			Set TypeDesc=""
			If MRDiagType'="" {
				Set TypeDicID=$g(^MR(MRAdm,"DIA",xDiagnosID,"TYP",MRDiagType))
				Set TypeDesc=$p($g(^MRC("DTYP",+TypeDicID)),"^",2) 								//诊断类型描述
			}
			
			Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
			Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
			Set:aKeyWords'="" ICDDesc=ICDDesc_" "_aKeyWords
			Set DiagPrefix=$p($g(^MR(MRAdm,"DIA",xDiagnosID,1)),"^",26)    //诊断前缀 add 2020-09-17
			Set:DiagPrefix'="" ICDDesc=DiagPrefix_" "_ICDDesc
	
			//只检查中西医诊断，不检查中医证型
			Set xDiagnosCat=##class(DHCMA.CPW.IO.FromDoc).GetDiagnosCat(ICDDxID,"")
			Continue:(xDiagnosCat'="西医")&&(xDiagnosCat'="中医")
											
			Do CheckICDAndDesc(TypeDesc,ICD10,ICDDesc,IsOnlyChkMainDiag)
		}
 	} ElseIf (aType="2") {																		//手术待完善
 	} Else{
 	}
 	
 	Set OPCPWList=""
 	Set xFormID=""
 	For {
 		Set xFormID=$o(tmpOPCPW("AllMatchOPCPWList",$J,xFormID))
 		Quit:xFormID=""
 		
 		Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(xFormID)
 		Continue:'$IsObject(objForm)
 		Set objMast=objForm.FormPathDr
 		Continue:'$IsObject(objMast)
 		Set MastID=objMast.%Id()
 		Continue:'$d(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(AdmLocID,"U"),MastID))		//未关联科室过滤
 		Set xAdmitID=""
	 	For {
		 	Set xAdmitID=$o(tmpOPCPW("OPCPWList",$J,"XY",xFormID,xAdmitID))
	 		Quit:xAdmitID=""
	 		
	 		Set objAdmit=##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xAdmitID)
	 		Continue:'$IsObject(objAdmit)
	 		Set IsICDAcc=objAdmit.BTIsICDAcc
	 		If (IsICDAcc=1)&&('$d(tmpOPCPW("OPCPWList",$J,"ZY",xFormID,xAdmitID))) {				//去掉有西医无中医记录
		 		Kill tmpOPCPW("OPCPWList",$J,"XY",xFormID,xAdmitID)								
		 	}
		 }

		 Set zAdmitID=""
		 For {
		 	Set zAdmitID=$o(tmpOPCPW("OPCPWList",$J,"ZY",xFormID,zAdmitID))
	 		Quit:zAdmitID=""
	 		
	 		Set objAdmit=##class(DHCMA.CPW.BT.PathAdmit).GetObjById(zAdmitID)
	 		Continue:'$IsObject(objAdmit)
	 		Set IsICDAcc=objAdmit.BTIsICDAcc
	 		If (IsICDAcc=1)&&('$d(tmpOPCPW("OPCPWList",$J,"XY",xFormID,zAdmitID))) {			//去掉有中医无西医记录
		 		Kill tmpOPCPW("OPCPWList",$J,"ZY",xFormID,zAdmitID)								
		 	}
		 }
		 
		If $d(tmpOPCPW("OPCPWList",$J,"XY",xFormID))||$d(tmpOPCPW("OPCPWList",$J,"ZY",xFormID)){
			Set tmpAdmitID="",DiagList="",TypeList=$lb("XY","ZY")
			For indx=1:1:$ll(TypeList){														  	//获取符合路径对应的诊断RowID(MR_Diagnos)串，符合诊断入径标准的所有诊断都可以取得,无重复
				Set tmpType=$li(TypeList,indx)
				For {
					Set tmpAdmitID=$o(tmpOPCPW("OPCPWList",$J,tmpType,xFormID,tmpAdmitID))
					Quit:tmpAdmitID=""
					Set tmpDiagnosID=""
					For {
						Set tmpDiagnosID=$o(tmpOPCPW("OPCPWList",$J,tmpType,xFormID,tmpAdmitID,tmpDiagnosID))
						Quit:tmpDiagnosID=""
						
						Set:DiagList'[tmpDiagnosID DiagList=DiagList_"$"_tmpDiagnosID 
					}	
				}
			}
			Set:DiagList'="" DiagList=$e(DiagList,2,$l(DiagList))
			
			Set xCPWDescAndVisit=$g(tmpOPCPW("AllMatchOPCPWList",$J,xFormID))
 			Set CPWData=xFormID_"^"_xCPWDescAndVisit_"^"_DiagList									//
 			Set OPCPWList=OPCPWList_","_CPWData
		}
 		
 	}
 	
 	Set:OPCPWList'="" OPCPWList=$e(OPCPWList,2,$l(OPCPWList))
 	Set return=OPCPWList
 	Quit return
 	
CheckICDAndDesc(aTypeDesc,aICD,aKeyWords,aIsOnlyChkMainDiag)
 	//如果诊断类型在临床路径基础字典表中不存在，则不匹配诊断类型，诊断内容符合即入径
	//如果存在，当字典表中有效性为否，则直接退出，不提示
	//如果存在，且有效性为是，则匹配入径标准中的诊断类型，符合即入径
	If (aTypeDesc'="") {
		Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWAdmDiagType",aTypeDesc)
		Quit:($IsObject(objDic))&&('objDic.BTIsActive) 											//诊断类型存在且无效，退出
	}
	Set xPathID=""
 	For {
 		Set xPathID=$o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",xPathID))
 		Quit:xPathID=""
 		
 		Set xTypeID=""
 		For {
 			Set xTypeID=$o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",xPathID,xTypeID))
 			Quit:xTypeID=""
 			
 			//Continue:(+aType'=0)&&(TypeID'=xTypeID)
 			
 			Set xID=""
 			For {
	 			Set xID=$o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",xPathID,xTypeID,xID))
 				Quit:xID=""
 				
 				Set obj = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xID)
		 		Continue:'$IsObject(obj)
		 		Set IsActive=obj.BTIsActive
		 		
		 		Continue:IsActive=0
		 		Continue:'$IsObject(obj.BTPathDr)
		 		Continue:obj.BTPathDr.BTAdmType'["O"
		 		
		 		//处理路径设置无效也有入径提示 fcz
		 		Set pathIsActive=obj.BTPathDr.BTIsActive
		 		Continue:pathIsActive=0
		 		
		 		If (aIsOnlyChkMainDiag'="Y")&&(aTypeDesc'="") {
		 			Set xTypeDesc=obj.BTTypeDr.BTDesc											//入径标准的诊断类型
		 			Continue:($IsObject(objDic))&&(aTypeDesc'=xTypeDesc)						//过滤诊断类型存在且不匹配的
		 		}
		 		Set ICD10 =obj.BTICD10
			 	Set ICDKeys = obj.BTICDKeys
			 	Set OperICD = obj.BTOperICD
			 	Set OperKeys = obj.BTOperKeys
			 	Set IsICDAcc = obj.BTIsICDAcc													//中西医诊断是否同时符合
			 	Set IsOperAcc = obj.BTIsOperAcc													//诊断手术是否同时符合
			 	
			 	If (aType="1"){																	//中西医诊断检查
			 		Set retICD=..CheckICDArea(aICD,ICD10)
			 		Set retKey=..CheckKeyArea(aKeyWords,ICDKeys)
			 	} ElseIf (aType="2") {															//手术检查
			 		Set retICD=..CheckICDArea(aICD,OperICD)
			 		Set retKey=..CheckKeyArea(aKeyWords,OperKeys)
			 	} Else {
			 	}
			 	
			 	If (retICD="1")||(retKey="1") {													//ICD符合或关键字符合
			 		Set PathID=obj.BTPathDr.%Id()			 		
			 		Set PathDesc=obj.BTPathDr.BTDesc
			 		Set:PathDesc'="" PathDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",PathDesc,LangID)			 		
			 		Set FormStr=""
			 		//先检查是否存在该病人有效历史入径，历史入径为空时再检查路径可用版本
			 		Set FormStr=##class(DHCMA.CPW.BTS.PathFormSrv).GetHistoryFormInfo(xEpisodeID,PathID)
			 		Set:FormStr="" FormStr=##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(PathID,1)		//FormID_"^"_Version
			 		Continue:FormStr=""
			 		Set FormID=$p(FormStr,"^",1)
			 		Set Version=$p(FormStr,"^",2)
			 		Set VisitID=$p(FormStr,"^",3)
			 		Set:(aType=1)&&(xDiagnosCat="西医") tmpOPCPW("OPCPWList",$J,"XY",FormID,xID,MRAdm_"||"_xDiagnosID)=IsICDAcc
			 		Set:(aType=1)&&(xDiagnosCat="中医") tmpOPCPW("OPCPWList",$J,"ZY",FormID,xID,MRAdm_"||"_xDiagnosID)=IsICDAcc			 		
			 		Set:'$d(tmpOPCPW("AllMatchOPCPWList",$J,FormID)) tmpOPCPW("AllMatchOPCPWList",$J,FormID)=PathDesc_"("_Version_")"_"^"_VisitID
			 	}
 			}
 		}
 	}
 	
DHCMAGetCPWList
	Quit ""
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  通过手术ICD和手术关键字判断是否符合临床路径标准
/// Table：       DHCMA.CPW.BT.PathAdmit
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).CheckOper(1)
ClassMethod CheckOper(aICD As %String, aKeyWords As %String) As %String
{
}

/// 准入ICD范围检查方法
/// w ##Class(DHCMA.CPW.OPCPS.InterfaceSrv).CheckICDArea("J45","J45-J46")
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
/// w ##Class(DHCMA.CPW.OPCPS.InterfaceSrv).CheckKeys("CCC","AAA,BBB")
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
/// CreatDate：   2019-06-24
/// Description:  门诊临床路径取历史入径信息及简要说明
/// Table：       DHCMA.CPW.BT.PathForm、DHCMA.CPW.BT.PathwayVisit
/// Input：       aVisitID,aFormID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetOPCPWInfoAndSum(8,17)
ClassMethod GetOPCPWInfoAndSum(aVisitID As %String, aFormID As %String) As %String
{
	New (aVisitID,aFormID,%session)
	Set return=""
	Quit:(aVisitID="")&&(aFormID="") return
	
	Set LangID=20,Languages=""
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set PathName="",FirstInDate="",InDays=0,CurStep="",NextStep="",InWayCount=0,ApplyPerson="",HelpDoc=""
	If aVisitID="" {
		Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
		Quit:'$IsObject(objForm) return
		Quit:'$IsObject(objForm.FormPathDr) return
		Set PathName=objForm.FormPathDr.BTDesc
		Set ApplyPerson=objForm.FormApply
		Set HelpDoc=objForm.FormHelpDoc
	} Else {
		Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(aVisitID)
		Quit:'$IsObject(objVisit) return
		Quit:'$IsObject(objVisit.CPPathwayDr) return
		Quit:'$IsObject(objVisit.CPFormDr) return
		Quit:'$IsObject(objVisit.CPEpisDr) return
		Set PatientID=objVisit.CPPatientID
		Set PathwayID=objVisit.CPPathwayDr.%Id()
		Set PathName=objVisit.CPFormDr.FormPathDr.BTDesc
		//获取该条路径首次入径时间及入径就诊次数
		Set xVisitID=""
		For {
			Set xVisitID=$o(^DHCMA.CPW.CP.PathwayVisitI("IdxOfPathwayDr",PathwayID,xVisitID))
			Quit:xVisitID=""			
		    Set xObjVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(xVisitID)
		    Continue:'$IsObject(xObjVisit)
		    Continue:xObjVisit.CPStatus'="I"
		    Set InWayCount=InWayCount+1															//有效入径次数
		    Set:FirstInDate="" FirstInDate=xObjVisit.CPInDate									//首次入径时间
		}
		Set:FirstInDate'="" InDays=+$h-FirstInDate+1
		Set CurStepIndNo=objVisit.CPPathwayDr.CPEpisDr.CPFormEpDr.EpIndNo
		Set CurStep=objVisit.CPPathwayDr.CPEpisDr.CPFormEpDr.EpDesc
		Set:CurStep'="" CurStep=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",CurStep,LangID)
		
		Set CurStep2=objVisit.CPPathwayDr.CPEpisDr.CPFormEpDr.EpDesc2
		Set:CurStep2'="" CurStep2=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc2",CurStep2,LangID)
		Set:CurStep2'="" CurStep=CurStep_"("_CurStep2_")"
		Set NextCPEpID=##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).GetNextStepID(aVisitID)
		if (NextCPEpID'="")
		{
			Set objNextCPEp=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(NextCPEpID)
			Quit:'$IsObject(objNextCPEp) return
			Set NextStep=objNextCPEp.CPFormEpDr.EpDesc
			Set:NextStep'="" NextStep=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc",NextStep,LangID)
			
			Set NextStep2=objNextCPEp.CPFormEpDr.EpDesc2
			Set:NextStep2'="" NextStep2=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormEp","EpDesc2",NextStep2,LangID)
			Set:NextStep2'="" NextStep=NextStep_"("_NextStep2_")"	
		}
		Set ApplyPerson=objVisit.CPFormDr.FormApply
		Set HelpDoc=objVisit.CPFormDr.FormHelpDoc
	}
	Set:FirstInDate'="" FirstInDate=##class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(FirstInDate)
	
	Set:PathName'="" PathName=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",PathName,LangID)
	Set:ApplyPerson'="" ApplyPerson=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathForm","FormApply",ApplyPerson,LangID)
	Set:HelpDoc'="" HelpDoc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathForm","FormHelpDoc",HelpDoc,LangID)
	Set Txt1=##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.io.opshow.csp","入径第",LangID)
	Set Txt2=##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.io.opshow.csp","天(第",LangID)
	Set Txt3=##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.io.opshow.csp","次)",LangID)
	
	//返回路径名称^该条路径初次入径日期^到今天为止入径天数(已入径次数)^当前阶段^下一阶段^适用对象^进入路径标准（帮助文档）
	Set return=PathName_"^"_FirstInDate_"^"_Txt1_InDays_Txt2_InWayCount_Txt3_"^"_CurStep_"^"_NextStep_"^"_ApplyPerson_"^"_HelpDoc
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-06-28
/// Description:  不入径申请
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).ApplyNotInPath("711!!1","37^10209!!1^6!!1^!!1^4^不入径测试^")
ClassMethod ApplyNotInPath(aEpisodeID As %String, aInputs As %String) As %String
{
	New (aEpisodeID,aInputs)
	Set return=""
	Quit:(aEpisodeID="")&&(aInputs="") return
	
	//本次就诊该路径已经入径不允许提交不入径申请
	Set IsInPath=##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).CheckIsInPath(aEpisodeID)
	Quit:IsInPath=1 "-1"																	
	
	//获取病人身份信息
	Set PatIDAndIDCardCode=##class(DHCMA.CPW.IO.FromDoc).GetPatIDAndIDCardCode(aEpisodeID)
	Set PatientID=$p(PatIDAndIDCardCode,"^",1)
	Set IDCardCode=$p(PatIDAndIDCardCode,"^",2)
	Quit:PatientID="" "-2"
	
	If aEpisodeID'["!!"{
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr	
	}
	
	Set FormID=$p(aInputs,"^",1)
	Set UserID=$p(aInputs,"^",2)
	Set LocID=$p(aInputs,"^",3)
	Set WardID=$p(aInputs,"^",4)
	Set ReasonID=$p(aInputs,"^",5)
	Set ApplyTxt=$p(aInputs,"^",6)
	Set HistVisitID=$p(aInputs,"^",7)
	
	Set CurStepID="",PathwayID=""
	If HistVisitID'=""{
		Set ObjHistVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(HistVisitID)
		Quit:'$IsObject(ObjHistVisit) "-3"
		
		Set:$IsObject(ObjHistVisit.CPPathwayDr) PathwayID=ObjHistVisit.CPPathwayDr.%Id()
		Set:$IsObject(ObjHistVisit.CPEpisDr) CurStepID=ObjHistVisit.CPEpisDr.%Id()
	}
	
	Set $ZT="ApplyNotInPathError"	
	TStart
	
	//没有历史入径的重新生成出入径记录
	If PathwayID=""{
		Set PathwayID=##class(DHCMA.CPW.CP.Pathway).NotInApply(aEpisodeID,FormID,LocID,WardID,UserID)
		If PathwayID<1{
			TRollBack 1
			Quit "-4"
		}
		Set retSync=##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).SyncSteps(PathwayID,FormID,UserID)			//同步阶段数据
		If retSync<1 {
			TRollBack 1
			Quit "-5"
		}
		Set CurStepID=PathwayID_"||"_1
	}
			
	Set ChildID=""
	Set TypeCode="03"
	Set AppylInupt=PathwayID_"^"_ChildID_"^"_TypeCode_"^"_ReasonID_"^"_ApplyTxt_"^"_UserID_"^"_LocID_"^"_WardID
	Set ApplyID=##class(DHCMA.CPW.CP.PathwayApply).Update(AppylInupt,"^")
	If $p(ApplyID,"||",2)<1{
		TRollBack 1
		Quit "-6"
	}
	
	Set VisitInput=""_"^"_aEpisodeID_"^"_PatientID_"^"_IDCardCode_"^"_PathwayID_"^"_FormID_"^"_CurStepID_"^"_ApplyID_"^"_"T"_"^^^"_UserID_"^^"_+$h_"^"_$p($h,",",2)_"^^"_LocID_"^^"
	Set VisitID=##class(DHCMA.CPW.CP.PathwayVisit).Update(VisitInput,"^")
	If VisitID<1{
		TRollBack 1
		Quit "-7"
	}
		
	If $TLevel>0 TCommit
	Quit 1
	
ApplyNotInPathError
	If $TLevel>0 TRollBack 1 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     dsp
/// CreatDate：   2019-10-23
/// Description:  门诊主动路径入径验证
/// Table：       
/// Input：       aEpisodeID
/// Return：      %String
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).CheckIsInOPCPW("713!!1")
ClassMethod CheckIsInOPCPW(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return =""
	Quit:aEpisodeID="" return
	
	//获取病人身份信息
 	Set PatIDAndIDCardCode=##class(DHCMA.CPW.IO.FromDoc).GetPatIDAndIDCardCode(aEpisodeID)
 	Set IDCardCode=$p(PatIDAndIDCardCode,"^",2)
 	//Set:IDCardCode="" return = "无身份证号患者，不允许入径！<br/>"																 
 	
 	Set xEpisodeID=aEpisodeID
 	Set:xEpisodeID["!!" xEpisodeID=$p(xEpisodeID,"!!",1) 
 	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID) 
 	
 	//检查配置“门诊路径准入就诊类型”
	Set AdmType=$p($g(^PAADM(xEpisodeID)),"^",2)  												//就诊类型
 	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPGetInAdmType",AdmHospID)					
 	Set:ret'[AdmType return = return_"当前就诊类型与路径准入就诊类型不符，不允许入径！"
 	
 	//当前就诊已经入径不允许再次入径
	Set IsInPath=##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).CheckIsInPath(aEpisodeID)
	Set:IsInPath=1 return = return_"当前就诊已经入径，不允许再次入径！"
 	
 	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-06-28
/// Description:  门诊路径入径
/// Table：       
/// Input：       aEpisodeID,aInputs字符串,aBtnType按钮类型:{"btnInCurStep","btnInNextStep","btnGetIn"}
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetInOPCPW("550!!1","17^10209!!1^6!!1^!!1^^550||1"_$c(1)_"550||2"_$c(1)_"550||3","btnGetIn")
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetInOPCPW("6992135!!1","2^2455!!1^44!!1^!!1^^","btnGetIn")
ClassMethod GetInOPCPW(aEpisodeID As %String, aInputs As %String, aBtnType As %String) As %String
{
	New (aEpisodeID,aInputs,aBtnType)
	Set return=""
	Quit:(aEpisodeID="")||(aInputs="")||(aBtnType="") return
	
	//本次就诊该病人已经入径不允许再次入径
	Set IsInPath=##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).CheckIsInPath(aEpisodeID)
	Quit:IsInPath=1 "-1"
	
	//获取病人身份信息，无病人ID不允许入径
	Set PatIDAndIDCardCode=##class(DHCMA.CPW.IO.FromDoc).GetPatIDAndIDCardCode(aEpisodeID)
	Set PatientID=$p(PatIDAndIDCardCode,"^",1)
	Set IDCardCode=$p(PatIDAndIDCardCode,"^",2)
	Quit:(PatientID="") "-2"
	
	If aEpisodeID'["!!"{
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr	
	}
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID) 		//患者就诊医院
	
	Set FormID=$p(aInputs,"^",1)
	Set UserID=$p(aInputs,"^",2)
	Set LocID=$p(aInputs,"^",3)
	Set WardID=$p(aInputs,"^",4)
	Set HistVisitID=$p(aInputs,"^",5)															//复诊患者上次入径VisitID
	Set Diagnos=$tr($p(aInputs,"^",6),$c(1),",")												//触发路径提示诊断
																		
	Set DocID=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Set:$IsObject(objUser) DocID=objUser.BTCareProvID
	
	Set $ZT="OPGetInOPCPWError"
	Tstart
	
	Set PathwayID="",EpisID="",Status="I",VisitID=""
	If (HistVisitID="") {																		//初次入径患者入径
		Set PathwayID=##class(DHCMA.CPW.CP.Pathway).Update(aEpisodeID,FormID,UserID)
		If PathwayID<1{
			TRollBack 1
			Quit "-3"
		}
		
		Set retSync=##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).SyncSteps(PathwayID,FormID,UserID)			//同步阶段数据
		If retSync<1 {
			TRollBack 1
			Quit "-4"	
		}
		Set EpisID=PathwayID_"||"_1																//默认第一阶段
		Set CPWInupt=PathwayID_"^"_aEpisodeID_"^"_FormID_"^"_EpisID_"^"_UserID_"^"_DocID_"^"_LocID_"^"_WardID
		Set retInCPW=##class(DHCMA.CPW.CP.Pathway).GetInCPW(CPWInupt,"^")
		If retInCPW<1 {
			TRollBack 1
			Quit "-5"	
		}
	}Else{
		//检查配置“门诊路径是否启用每次就诊入径自动进入新阶段”
 		Set CheckFlag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPEvrInNewEp",AdmHospID)					 		
 		If CheckFlag="Y"{
	 		//必选未执行项目变异检查及添加
	 		Set retVarCheck=##class(DHCMA.CPW.OPCPS.PathwayVarSrv).SaveNoExeItemVar(HistVisitID)	
	 		If retVarCheck'=1{
				TRollBack 1
				Quit "-6"
			}
			
	 		//非首次入径先进行上次就诊入径的阶段确认
			Set retLstEpisCfm=##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).AutoConfirmPathEpis(HistVisitID)
			If retLstEpisCfm=""{
				TRollBack 1
				Quit "-7"
			}
	 	}
		
		Set objHistVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(HistVisitID)
		Quit:'$IsObject(objHistVisit) "-8"
		Quit:'$IsObject(objHistVisit.CPPathwayDr) "-9"
		Set objPathway=objHistVisit.CPPathwayDr
		Set PathwayID=objPathway.%Id()
		Set EpisID=objPathway.CPEpisDr.%Id()  							//不管怎样，入径阶段ID都是路径当前阶段
	}
	
	//生成记录唯一性检查，如已存在该就诊下该阶段的有效入径，则入径失败
	If $d(^DHCMA.CPW.CP.PathwayVisitI("IdxOfEpisodeIDEpisDr"," "_aEpisodeID,EpisID," I")){
		TRollBack 1
		Quit "-10"	
	}
		
	Set VisitInput=VisitID												//Visit始终为空，每次入径都插入一条新的Visit记录
	Set VisitInput=VisitInput_"^"_aEpisodeID
	Set VisitInput=VisitInput_"^"_PatientID
	Set VisitInput=VisitInput_"^"_IDCardCode
	Set VisitInput=VisitInput_"^"_PathwayID
	Set VisitInput=VisitInput_"^"_FormID
	Set VisitInput=VisitInput_"^"_EpisID
	Set VisitInput=VisitInput_"^"_""
	Set VisitInput=VisitInput_"^"_Status
	Set VisitInput=VisitInput_"^"_""
	Set VisitInput=VisitInput_"^"_""
	Set VisitInput=VisitInput_"^"_UserID
	Set VisitInput=VisitInput_"^"_DocID
	Set VisitInput=VisitInput_"^"_+$h
	Set VisitInput=VisitInput_"^"_$p($h,",",2)
	Set VisitInput=VisitInput_"^"_UserID
	Set VisitInput=VisitInput_"^"_LocID
	Set VisitInput=VisitInput_"^"_WardID
	Set VisitInput=VisitInput_"^"_Diagnos
	
	Set VisitID=##class(DHCMA.CPW.CP.PathwayVisit).Update(VisitInput,"^")
	If VisitID<1 {
		TRollBack 1
		Quit "-11"
	}
	/*
	//江苏省中医个性化要求	
	//系统默认执行所有主要诊疗项目
	Set PathImplId = ##class(DHCMA.CPW.OPCPS.ImplementSrv).ExecuteAllItem(aEpisodeID,PathwayID,EpisID)
	If PathImplId<1 {
		TRollBack 1
		Quit "-12"
	}
	*/

	If $TLevel>0 TCommit	
	Set return=VisitID
	Quit return
	
OPGetInOPCPWError
	If $TLevel>0 TRollBack 1 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2019-07-01
/// Description:  出径操作
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetOutOPCPW(1)
ClassMethod GetOutOPCPW(aInputs As %String, aSeparete As %String = "^") As %String
{
	New (aInputs)
	Set return=""
	Quit:aInputs="" return
	
	Set PathwayID=$p(aInputs,"^",1)	
	Set UserID=$p(aInputs,"^",2)
	Set DocID=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Set:$IsObject(objUser) DocID=objUser.BTCareProvID
	Set LocID=$p(aInputs,"^",3)
	Set WardID=$p(aInputs,"^",4)
	Set ReasonID=$p(aInputs,"^",5)
	Set ApplyTxt=$p(aInputs,"^",6)
	
	Set ObjPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(ObjPathway) "-3"
	Quit:ObjPathway.CPStatus'="I" "-4"															//整条路径的状态如果不是入径状态不允许出径
	
	Set ChildID=""
	Set TypeCode="02"
	Set ApplyInupt=PathwayID_"^"_ChildID_"^"_TypeCode_"^"_ReasonID_"^"_ApplyTxt_"^"_UserID_"^"_LocID_"^"_WardID
	Set retApply=##class(DHCMA.CPW.CP.PathwayApply).Update(ApplyInupt,"^")
	If retApply<1 {
		Quit "-5"
	}
	
	Set CPWInupt=PathwayID_"^"_UserID_"^"_DocID_"^"_LocID_"^"_WardID
	Set retPathway=##class(DHCMA.CPW.CP.Pathway).GetOutCPW(CPWInupt,"^")
	If retPathway<1 {
		Quit "-6"
	}
	
	Set return=retPathway
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2019-07-05
/// Description:  完成操作
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).CloseOPCPW(1)
ClassMethod CloseOPCPW(aEpisodeID As %String, aInputs As %String) As %String
{
	New (aEpisodeID,aInputs)
	Set return=""
	Quit:(aEpisodeID="")&&(aInputs="") return
	
	If aEpisodeID'["!!"{
		Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
		Set aEpisodeID=aEpisodeID_"!!"_SYSDr	
	}
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID)		//患者就诊医院
	
	Set PathwayID=$p(aInputs,"^",1)
	Set UserID=$p(aInputs,"^",2)
	Set DocID=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
	Set:$IsObject(objUser) DocID=objUser.BTCareProvID
	Set LocID=$p(aInputs,"^",3)
	Set WardID=$p(aInputs,"^",4)
	
	Set ObjPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(PathwayID)
	Quit:'$IsObject(ObjPathway) return
	Quit:ObjPathway.CPStatus'="I" "-1"
	
	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisodeID(aEpisodeID)
	Quit:'$IsObject(objVisit) return
	Set VisitID=objVisit.%Id()
	
	Set $ZT="OPCloseOPCPWError"
	TStart
	
	//检查配置“门诊路径是否启用每次就诊入径自动进入新阶段”
 	Set CheckFlag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPEvrInNewEp",AdmHospID)					 		
 	If CheckFlag="Y"{
	 	Set IsExistVar=##class(DHCMA.CPW.OPCPS.PathwayVarSrv).CheckVarToCfmStep(PathwayID,objVisit.CPEpisDr.%Id())
	 	If +IsExistVar>0{
			//必选未执行项目变异检查及添加
	 		Set retVarCheck=##class(DHCMA.CPW.OPCPS.PathwayVarSrv).SaveNoExeItemVar(VisitID)	
	 		If retVarCheck'=1{
				TRollBack
				Quit "-2"
			} 	
		}else{
			//完成前自动进行当前阶段确认
			Set retCurrEpisCfm=##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).AutoConfirmPathEpis(VisitID)
			If retCurrEpisCfm=""{
				TRollBack
				Quit "-3"
			}	
		}
	 }
	
	Set CPWInupt=PathwayID_"^"_UserID_"^"_DocID_"^"_LocID_"^"_WardID
	Set ret=##class(DHCMA.CPW.CP.Pathway).CloseCPW(CPWInupt,"^")
	If ret<1{
		TRollBack
		Quit "-4"
	}
	
	If $TLevel>0 TCommit
	Set return=ret
	Quit return
	
OPCloseOPCPWError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2019-07-22
/// Description:  给医生站接口,检查当前就诊入径情况，用于医嘱录入页面是否显示“添加门诊路径“按钮
/// Table：       
/// Input：       ID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetOPCPWStatusToDOC("202")
ClassMethod GetOPCPWStatusToDOC(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
  	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	
	Set return=##class(DHCMA.CPW.OPCPS.PathwayVisitSrv).CheckIsInPath(aEpisodeID)	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2018-10-16
/// Description:  门诊路径医嘱审核后，将医嘱OrderID插入执行记录表
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       aEpisodeID,aOrderID
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).ExecuteOPCPWOrder("714","3675||1*686||4*V^4702||1*686||5*V^","10209","C")
ClassMethod ExecuteOPCPWOrder(aEpisodeID As %String, OrderStr As %String, aUserID As %String, aType As %String) As %String
{
	New (aEpisodeID,OrderStr,aUserID,aType)
	Set return=""
	Quit:(aEpisodeID="")&&(OrderStr="") return	
	;Set ^TEMPYK("ExecuteOPCPWOrder")=$LB(aEpisodeID,OrderStr,aUserID,aType)
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aUserID'["!!" aUserID=aUserID_"!!"_SYSDr
	Set:aEpisodeID'["!!" aEpisodeID=aEpisodeID_"!!"_SYSDr
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID)
	
	Set ComDescType=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPGetComDescByType",AdmHospID)	//1处方通用名，2化学通用名
    Set objOldVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisodeID(aEpisodeID)
	Quit:'$IsObject(objOldVisit) return
	Set OldVisitID = objOldVisit.%Id()   		
	Set PathwayID = objOldVisit.CPPathwayDr.%Id()
	Quit:'$IsObject(objOldVisit.CPEpisDr)
	Set OldEpisID = objOldVisit.CPEpisDr.%Id()
	
	//检查阶段是否确认，从而确定是否要生成新就诊入径(PathwayVisit)记录
	Set IsCfmEp=objOldVisit.CPEpisDr.CPIsConfirm
	If IsCfmEp{													//如果已确认，获取下一阶段并生成新的就诊入径（PathwayVisit）记录
		Set NewEpisID=##class(DHCMA.CPW.OPCPS.PathwayEpisSrv).GetNextStepID(OldVisitID)
		Quit:NewEpisID="" return
		
		Set NewVisitID=##Class(DHCMA.CPW.OPCPS.ImplementSrv).AddNewEPVsit(aEpisodeID,NewEpisID)
		Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(NewVisitID)
		Set VisitID=NewVisitID
		Set EpisID=NewEpisID
	}Else{
		Set objVisit=objOldVisit
		Set VisitID=OldVisitID
		Set EpisID=OldEpisID
	}
	
	Set IsNeedCheckTCMVar=1						//是否需要进行方剂检查标记
  	Kill TCMRecord,OPCPWOrder("ARCOSRecord")
  	
	Set $ZT="ExecuteOPCPWOrderError"
  	TStart
  	 
	For OrderInd=1:1:$l(OrderStr,"^") {
		Set aOEItmMastID=$p($p(OrderStr,"^",OrderInd),"*",1)
		Continue:aOEItmMastID=""
		Set aOEItemID=$p($p(OrderStr,"^",OrderInd),"*",2)
		Continue:aOEItemID=""
		Set aPHCGeneDesc=""
		If (ComDescType="1") {
			Set PHCGeneID=$p($g(^ARCIM(+aOEItmMastID,+$p(aOEItmMastID,"||",2),8)),"^",20)
			Set:PHCGeneID'="" aPHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)	//处方通用名
		} ElseIf (ComDescType="2") {
			Set PHChemical=##class(PHA.FACE.OUT.Com).GetPHChemicalByArc(aOEItmMastID)
			Set aPHCGeneDesc=$p(PHChemical,"^",3)	//化学通用名
		} Else {
		}
		If (aPHCGeneDesc="") {
			Set ArcimDesc=$p($g(^ARCIM(+aOEItmMastID,+$p(aOEItmMastID,"||",2),1)),"^",2)    //医嘱名称
			Set aPHCGeneDesc=ArcimDesc
		}
		Set IsMatch=0,vInd=""
		Set xImplID=""
	 	For {
	 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,EpisID,xImplID))
	 		Quit:xImplID=""
	 		
	 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xImplID)
	 		Continue:'$IsObject(objImpl)
	 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
	 		Continue:(TypeDesc'="重点医嘱")
	 		Set FormItemID=objImpl.CPFormItemDr.%Id()
	 		Set FormID =$p(FormItemID,"||",1)
			Set FormEpID =$p(FormItemID,"||",2)
			Set FormEpItemID =$p(FormItemID,"||",3)
			
			//如果项目关联方剂的走这里↓  如果能确认第一味药为君药，可以设置为符合君药的才匹方剂医嘱，否则全都属于路径外医嘱
			If ($d(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormID,FormEpID,FormEpItemID))) {
				 Set xTCMDr=""
				 For {
					Set xTCMDr=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormID,FormEpID,FormEpItemID,xTCMDr))
					Quit:xTCMDr=""
					
					Set xFromTCMID=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormID,FormEpID,FormEpItemID,xTCMDr,""))
					Set FormTCMID=FormID_"||"_FormEpID_"||"_FormEpItemID_"||"_xFromTCMID
					
					//检查输入医嘱串是否包含该方剂君药
					Set IsExe=..CheckIsMatchTCM(xTCMDr,OrderStr)
					Set:(IsNeedCheckTCMVar=1)&&(IsExe=1) IsNeedCheckTCMVar=0		//已匹配方剂君药的，不进行方剂变异检查
										  
					Set xSubTCMId=""
					For {
						Set xSubTCMId=$o(^DHCMA.CPW.BT.PathTCMD(xTCMDr,"EXT",xSubTCMId))
						Quit:xSubTCMId=""
							
						Set TCMOrdId=xTCMDr_"||"_xSubTCMId
						Set TCMOrder=##class(DHCMA.CPW.BT.PathTCMExt).GetObjById(TCMOrdId)
						Set OrdMastID=""
						Set OrdMastDesc=TCMOrder.BTOrdMastID  //表中存的医嘱描述,考虑兼容后面改为存医嘱ID
						Set:+OrdMastDesc>0 OrdMastID=OrdMastDesc
						Set TCMType=TCMOrder.BTTypeDr.BTDesc
						Set SPriority=TCMOrder.SPriority
						Set IOrdMastDesc=$$ALPHAUP^SSUTIL4(OrdMastDesc)
						If (OrdMastID="") {
							Set ArcMID=$o(^ARCIM(0,"Desc",IOrdMastDesc,""),-1)
							Set VerID=$o(^ARCIM(0,"Desc",IOrdMastDesc,ArcMID,""),-1)
							Set OrdMastID=ArcMID_"||"_VerID
						}
						;w !,"aOEItmMastID="_aOEItmMastID_",OrdMastID="_OrdMastID
						If (OrdMastID=aOEItmMastID) {
							Set ImplID=xImplID
							If (IsExe=1) {
								Set ret=0
								Set TCMRecord(xTCMDr)=""
								Set ret=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(PathwayID,ImplID,aOEItemID,aUserID,IsExe,0)
								;君药医嘱执行才去更新项目执行记录
								If (+ret<0) {
									TRollBack 1
									Set return=-1
									Quit
								} 
							}
							Set IsMatch=1,ret=0
							Set Parref=PathwayID_"||"_ImplID
							Set Child=""
							If (IsExe=1){
								Set Inputs=Parref_"^"_Child_"^^"_aOEItemID_"^"_aUserID_"^"_FormTCMID
							}Else{
								Set Inputs=Parref_"^"_Child_"^^"_aOEItemID_"^"_aUserID_"^"_""
							}
							
							Set ret=##class(DHCMA.CPW.CP.PathwayOrd).Update(Inputs)
							If (+ret<0) {
								TRollBack 1
								Set return=-2
								Quit
							} Else {
								Set return=ret
							}
						}
					}
					Quit:return<0
				}
				Quit:return<0
			}
			
			//关联了医嘱项/医嘱套的↓
			Set xFormOrdID=""
			For {
				Set xFormOrdID=$o(^DHCMA.CPW.BT.PathFormD(FormID,"EP",FormEpID,"ITM",FormEpItemID,"ORD",xFormOrdID))
				Quit:xFormOrdID=""
					
				Set FormOrdID=FormID_"||"_FormEpID_"||"_FormEpItemID_"||"_xFormOrdID
				Set objOrd = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(FormOrdID)
				Continue:'$IsObject(objOrd)
				Set OrdMastID=objOrd.OrdMastID
				Continue:OrdMastID=""
				
				Set ImplID=xImplID,ImplFlg=0
				If (OrdMastID'["||"){	//医嘱套单独处理
					Set OrderMastIDStr=##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetOSItems(OrdMastID)
					For oind=1:1:$l(OrderMastIDStr,"^") {
						Set xOrdMastID=$p(OrderMastIDStr,"^",oind)	
						Continue:aOEItmMastID'=xOrdMastID
						
						//医嘱套内之一医嘱匹配即算医嘱套匹配，更新项目执行状态
						Set:ImplFlg'=1 ret=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(PathwayID,ImplID,"",aUserID,1,0)
						If (+ret<0) {
							TRollBack 1
							Set return=-3
							Quit
						}Else{
							Set ImplFlg=1	
						}
						Set Inputs=PathwayID_"||"_ImplID_$c(1)_""_$c(1)_FormOrdID_$c(1)_aOEItemID_$c(1)_aUserID_$c(1)_""
						Set ret=##class(DHCMA.CPW.CP.PathwayOrd).Update(Inputs,$c(1))
						If (+ret<0) {
							TRollBack 1
							Set return=-4
							Quit
						} Else {
							Set return=ret
						}
					}	
					Quit:return<0
				}
				
				Set IsExe=0	//项目是否执行
				Set IsMainord=objOrd.OrdIsFluInfu	//是否主医嘱
				Set:IsMainord IsExe=1	//只有主医嘱执行，此项目才算是执行
				
				//通过通用名匹配
				Set PHCGeneDesc=""
				If (ComDescType="1") {
					Set PHCGeneID=$p($g(^ARCIM(+OrdMastID,+$p(OrdMastID,"||",2),8)),"^",20)
					Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)	//处方通用名
				} ElseIf (ComDescType="2") {
					Set PHChemical=##class(PHA.FACE.OUT.Com).GetPHChemicalByArc(OrdMastID)
					Set PHCGeneDesc=$p(PHChemical,"^",3)	//化学通用名
				} Else {
				}
				If (PHCGeneDesc="") {
					Set ArcimDesc=$p($g(^ARCIM(+OrdMastID,+$p(OrdMastID,"||",2),1)),"^",2)    //医嘱名称
					Set PHCGeneDesc=ArcimDesc
				}
				If (aPHCGeneDesc=PHCGeneDesc) {  ;主医嘱执行才去更新项目执行记录
					Set ImplID=xImplID
					Set IsMatch=1,ret=0
					Set:IsExe=1 ret=##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem(PathwayID,ImplID,aOEItemID,aUserID,IsExe,0)
					If (+ret<0) {
						TRollBack 1
						Set return=-5
						Quit
					} 
					Set Parref=PathwayID_"||"_ImplID
					Set Child=""
				
					Set Inputs=Parref_"^"_Child_"^"_FormOrdID_"^"_aOEItemID_"^"_aUserID_"^"_""
					Set ret=##class(DHCMA.CPW.CP.PathwayOrd).Update(Inputs)
					If (+ret<0) {
						TRollBack 1
						Set return=-6
						Quit
					} Else {
						Set return=ret
					}
				}
			}
			Quit:return<0
	 	}
		Quit:return<0
		
	 	//所有没匹配上的添加路径外医嘱变异
		If (IsMatch=0){
			Set ret=##class(DHCMA.CPW.OPCPS.PathwayVarSrv).SaveOutPathOrdVar(VisitID,aOEItmMastID,aOEItemID,aUserID)
			If (+ret<=0) {
				Set return=-7
				TRollBack 1
				Quit
			} 
		}
	}
	Quit:+return<0 return
	
	//草药类医嘱进行方剂变异检查
	If (aType="C")&&(IsNeedCheckTCMVar=1){
		Set ret=##class(DHCMA.CPW.OPCPS.PathwayVarSrv).SaveTCMPVar(aEpisodeID, OrderStr, aUserID)
		If +ret<=0{
			TRollBack 1
			Set return=-8
			Quit return	
		}
	}
	Quit:+return<0 return
		
 	If $TLevel>0 TCommit
	Quit return
		
ExecuteOPCPWOrderError
	If $TLevel>0 TRollBack 1 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019年7月8日
/// Description:  根据医嘱套ID，取医嘱明细
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetOSItems(3494)
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

/// Creator：     jiangpengpeng
/// CreatDate：   2019-01-26
/// Description:  切换患者时，初始赋值
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).GetPatName()
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

/// Creator：     yankai
/// CreatDate：   2019-12-07
/// Description:  检查输入的医嘱串是否含指定方剂君药
/// Table：       
/// Input：       1：含；0：不含
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.InterfaceSrv).CheckIsMatchTCM()
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

}
