Class DHCMed.CCService.Lib.Embed.Epidemic Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-08-07
/// Description:  检查某个患者是否为传染病患者（查看疾病列表）
/// Table：       MR_Diagns,DHCMed.EPD.Infection
/// Input：       
/// Return：      ret=0:非传染病患者  ret=1:传染病患者  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Embed.Epidemic).CheckEpdDiagnos()
ClassMethod CheckEpdDiagnos() As %String
{
	New (%EpisodeID,%ExtraData,%ErrorData,%Value)
	Set return=0,Count=0
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set $ZT="CheckEpdDiagnosErr"
	Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(%EpisodeID)
	Quit:MRAdm="" return
	
	Set Age=0
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	Set:BirthDay'="" Age=((+$h)-BirthDay)\365
	
	Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set AFPAgeMax=+AFPAgeMax
	
	Set IsDisplayAFP=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("CCIsControlAFPEpd","")
	
	Set epdList=##class(DHCMed.CCService.Lib.Epidemic).GetEpdList(%EpisodeID)
	
	Set CtlRstList=""
	Set MRAdm=$p(%Value,"||",1)
	Set DiagnosID=$p(%Value,"||",2)
	
	Set tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
	Set ICDDxID=$p(tmpDiagnos,"^",1)
	Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",DiagnosID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",DiagnosID,"DHC",1))
	Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
	Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
	Set ICDDate=$p(tmpDiagnos,"^",7)
	Set ICDTime=$p(tmpDiagnos,"^",8)
	Set:ICDDate'="" ICDDate=$zd(ICDDate,3)
	Set:ICDTime'="" ICDTime=$zt(ICDTime,2)	
	Set IFRowID=0
	For {
		Set IFRowID=$o(^DHCMed.EPDC("IF",IFRowID))
		Quit:IFRowID=""
		Set IFICD=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",1)
		Set IFDiseas=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",2)
		Continue:IFDiseas=""
		Set IFKind=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",3)
		Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",IFKind,"")
		Set:$IsObject(objDic) IFKind=objDic.Description
		Set IFRank=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",4)
		Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicRank",IFRank,"")
		Set:$IsObject(objDic) IFRank=objDic.Description
		
		Continue:$listfind(epdList,IFKind)>0    //此传染病已上报
		Continue:$listfind(epdList,IFDiseas)>0  //此传染病已上报
		If ((IFKind["AFP")||(IFRank["AFP")) {   //AFP类传染病特殊处理
			Continue:(IsDisplayAFP["N") //基础配置设置"N",AFP传染病未上报不显示
			Continue:(Age>AFPAgeMax)    //年龄超过限制的AFP报告无需上报
		}
		//w IFICD_"  " _ICD10_"  "_IFDiseas,!
		If ICD10=IFICD {
			Set Rst=IFDiseas_" 未上报(临床诊断:"_ICD10_" "_ICDDesc_" 诊断时间:"_ICDDate_" "_ICDTime_")"
			Set Rst=$$BuildCheckEpdDiagnosResult(1)
			Set %ExtraData=%ExtraData_$lb(Rst)
			Set Count=Count+1
		}Else{
			Set IFAliasID="",IsEPDDiseas="N"
			For {
				Set IFAliasID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID))
				Quit:IFAliasID=""
				Quit:IsEPDDiseas="Y"
				Set IFAlias=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",1)
				Set IsKeyAlias=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",2)
				Continue:IsKeyAlias'=1  //关键词
				//**************************************************
				//update by zf 2011-09-27
				Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IFAlias,"T"))
				Set IsEPDDiseas="Y"
				Set IFAlias3ID=0
				For {
					Set IFAlias3ID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID))
					Quit:IFAlias3ID=""
					Set IFAlias3=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID)),"^",1)
					Set IsKeyAlias3=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAlias3ID)),"^",2)
					Continue:IsKeyAlias3'=3  //关键词过滤
					Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IFAlias3,"T"))
					Set IsEPDDiseas="N"
				}
				//**************************************************
			}
			Set IFAliasID=""
			For {
				Set IFAliasID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID))
				Quit:IFAliasID=""
				Quit:IsEPDDiseas="Y"
				Set IFAlias=$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",1)
				Set IsKeyAlias=+$p($g(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID)),"^",2)
				Continue:IsKeyAlias'=2  //ICD
				Set:ICD10=IFAlias IsEPDDiseas="Y"
			}
			Continue:IsEPDDiseas="N"
			Set Rst=IFDiseas_" 未上报(临床诊断:"_ICD10_" "_ICDDesc_",诊断时间:"_ICDDate_" "_ICDTime_")"
			Set Rst=$$BuildCheckEpdDiagnosResult(1)
			Set %ExtraData=%ExtraData_$lb(Rst)
			Set Count=Count+1
		}
	}
	
	Set:Count>0 return=1
	Quit return
	
CheckEpdDiagnosErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildCheckEpdDiagnosResult(arg0)
	Set tmpDesc=Rst

	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objDia=##class(DHCMed.Base.MRDiagnose).GetObjById(MRAdm_"||"_DiagnosID)
	Set:$IsObject(objDia)=0 objDia=##class(DHCMed.Base.MRDiagnose).%New()
	Do objDia.%Close()
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objDia.DocCodeDr)
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.MRDiagnose).%New()
	Do objUser.%Close()		
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=+objDia.DiaDate
	Set $p(tmp,$c(3),3)=+objDia.DiaTime
	Set $p(tmp,$c(3),4)=ICD10_" "_ICDDesc
	Set $p(tmp,$c(3),5)=+DiagnosID
	Set $p(tmp,$c(3),6)=+objUser.Rowid
	Set $p(tmp,$c(3),7)=""
	Quit tmp
}

/// Creator：     zhufei
/// CreatDate：   2012-03-05
/// Description:  根据ICD10检查某个患者是否为传染病患者（查看疾病列表）
/// Table：       MR_Diagns,DHCMed.EPD.Infection
/// Input：       
/// Return：      ret=0:非传染病患者  ret=1:传染病患者  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Embed.Epidemic).CheckEpdDiagnosByICD()
ClassMethod CheckEpdDiagnosByICD() As %String
{
	New (%EpisodeID,%ExtraData,%ErrorData,%Value)
	Set return=0,Count=0
	Set %EpisodeID=$g(%EpisodeID)
	
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set $ZT="CheckEpdDiagnosByICDErr"
	
	Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(%EpisodeID)
	Quit:MRAdm="" return
	
	Set Age=0
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	Set:BirthDay'="" Age=((+$h)-BirthDay)\365
	
	Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set AFPAgeMax=+AFPAgeMax
	
	Set IsDisplayAFP=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("CCIsControlAFPEpd","")
	
	//Set epdList=##class(DHCMed.CCService.Lib.Epidemic).GetEpdList(%EpisodeID)
	
	Set MRAdm=$p(%Value,"||",1)
	Set DiagnosID=$p(%Value,"||",2)
	
	
	Set CtlRstList=""
	Set tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
	Set ICDDxID=$p(tmpDiagnos,"^",1)
	Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",DiagnosID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",DiagnosID,"DHC",1))
	Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
	Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
	Set ICDDate=$p(tmpDiagnos,"^",7)
	Set ICDTime=$p(tmpDiagnos,"^",8)
	Set:ICDDate'="" ICDDate=$zd(ICDDate,3)
	Set:ICDTime'="" ICDTime=$zt(ICDTime,2)
	Quit:ICD10="" return
	
	Set IFRowID=$o(^DHCMed.EPDCi("IF",0,"ICD",ICD10,0))
	If IFRowID=""
	{
		Set IFRowID=$o(^DHCMed.EPDCi("IF",0,"InfALIAS",ICD10,0))
	}
	Quit:IFRowID="" return
		
	Set IFICD=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",1)
	Set IFDiseas=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",2)
	Quit:IFDiseas="" return
	Set IFKind=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",3)
	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",IFKind,"")
	Set:$IsObject(objDic) IFKind=objDic.Description
	Set IFRank=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",4)
	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicRank",IFRank,"")
	Set:$IsObject(objDic) IFRank=objDic.Description
	//Quit:$listfind(epdList,IFKind)>0 return   //此传染病已上报
	//Quit:$listfind(epdList,IFDiseas)>0 return  //此传染病已上报
	If ((IFKind["AFP")||(IFRank["AFP")) {   //AFP类传染病特殊处理
		Quit:(IsDisplayAFP["N") return  //基础配置设置"N",AFP传染病未上报不显示
		Quit:(Age>AFPAgeMax) return   //年龄超过限制的AFP报告无需上报
	}
		
	Set Rst=IFDiseas_" 未上报(临床诊断:"_ICD10_" "_ICDDesc_" 诊断时间:"_ICDDate_" "_ICDTime_")"
	Set Rst=$$BuildCheckEpdDiagnosByICDResult(1)
	Set %ExtraData=%ExtraData_$lb(Rst)
	Set Count=Count+1
	
	
	Set:Count>0 return=1
	Quit return
	
CheckEpdDiagnosByICDErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildCheckEpdDiagnosByICDResult(arg0)
	Set tmpDesc=Rst

	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objDia=##class(DHCMed.Base.MRDiagnose).GetObjById(MRAdm_"||"_DiagnosID)
	Set:$IsObject(objDia)=0 objDia=##class(DHCMed.Base.MRDiagnose).%New()
	Do objDia.%Close()
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objDia.DocCodeDr)
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.MRDiagnose).%New()
	Do objUser.%Close()
	
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=+objDia.DiaDate
	Set $p(tmp,$c(3),3)=+objDia.DiaTime
	Set $p(tmp,$c(3),4)=ICD10_" "_ICDDesc
	Set $p(tmp,$c(3),5)=%Value
	Set $p(tmp,$c(3),6)=+objUser.Rowid
	Set $p(tmp,$c(3),7)=""
	Quit tmp
}

/// Creator：     PanLei
/// CreatDate：   2012-10-21
/// Description:  解决武汉儿童医院现场环境,根据住院电子病历的初步诊断,检查某个患者是否为传染病患者（查看疾病列表）
/// Table：       DHCMed_SS.Dictionary,
/// 			  DHCMed_EPD.DHCMed_EPD_Infection,
/// 			  DHCMed_EPD.DHCMed_EPD_InfectionAlias
/// Input：       
/// Return：      ret=0:非传染病患者  ret=1:传染病患者  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Epidemic).CheckEpdDiagnosByEPRKeyWord()
ClassMethod CheckEpdDiagnosByEPRKeyWord() As %String
{
	New (%EpisodeID, %ExtraData, %ErrorData)
	
	Set return = 0,Count = 0
	Set %EpisodeID = $g(%EpisodeID)
	Quit:%EpisodeID="" return
	
	Set %ExtraData = $g(%ExtraData)
	Set %ErrorData = $g(%ErrorData)
	
	Set $ZT="CheckEpdDiagnosByEPRKeyWordErr"
	
	Set Age=0
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	Set:BirthDay'="" Age=((+$h)-BirthDay)\365
	
	Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set AFPAgeMax=+AFPAgeMax
	
	Set IsDisplayAFP=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("CCIsControlAFPEpd","")
	
	// 根据就诊ID获取上报传染病的列表
	Set epdList=##class(DHCMed.CCService.Lib.Epidemic).GetEpdList(%EpisodeID)
	
	// Add By PanLei 2012-10-26
	// 取电子病历组专为武汉儿童医院开发的接口：入院记录界面模板8个初步诊断
	Set rset = ##class(%ResultSet).%New()
 	Set rset.ClassName = "EPRservice.SpecialData"
 	Set rset.QueryName = "GetModAdmDiagnosInfoWHET"
 	Set columns = rset.GetColumnCount()
	Do rset.Execute(%EpisodeID)
	
	Set EPRAdmDiagnosList = ""
	Set tmpAdmDiagnos = ""
	While (rset.Next()) {
		For col = 1:1:columns {
            Set tmpAdmDiagnos = rset.GetData(col)
            Set tmpAdmDiagnos = $TR(tmpAdmDiagnos,"?","")
            Set tmpAdmDiagnos = $TR(tmpAdmDiagnos,"？","")
            Set tmpAdmDiagnos = $TR(tmpAdmDiagnos,"^","")
            Set tmpAdmDiagnos = $TR(tmpAdmDiagnos," ","")
            Continue:tmpAdmDiagnos=""
            
            // 获取住院电子病历初步诊断
            Set EPRAdmDiagnosList = EPRAdmDiagnosList_$ListBuild(tmpAdmDiagnos)
        }
	}
	Do rset.Close()
	
	Set EPRAdmDiagnosListCount = $ListLength(EPRAdmDiagnosList)
	If (EPRAdmDiagnosListCount > 0) {
		For i = 1:1:EPRAdmDiagnosListCount {
			
			// 获取电子病历诊断
			Set EPRAdmDiagnos = $List(EPRAdmDiagnosList, i)
			Continue:EPRAdmDiagnos=""
			
			Set IFRowID=0
			For {
				Set IFRowID=$o(^DHCMed.EPDC("IF",IFRowID))
				Quit:IFRowID=""
				
				// 传染病疾病字典诊断描述
				Set IFDiseas=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",2)
				Continue:IFDiseas=""
				
				// 传染病基础字典大类
				Set IFKind=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",3)
				Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",IFKind,"")
				Set:$IsObject(objDic) IFKind=objDic.Description
				
				// 传染病级别
				Set IFRank=$p($g(^DHCMed.EPDC("IF",IFRowID)),"^",4)
				Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicRank",IFRank,"")
				Set:$IsObject(objDic) IFRank=objDic.Description
				
				Continue:$ListFind(epdList,IFDiseas)>0  //此传染病已上报
				Continue:$ListFind(epdList,IFKind)>0    //此传染病已上报
				
				//AFP类传染病特殊处理
				If ((IFKind["AFP") || (IFRank["AFP")) {
					Continue:(IsDisplayAFP["N") //基础配置设置"N",AFP传染病未上报不显示
					Continue:(Age>AFPAgeMax)    //年龄超过限制的AFP报告无需上报
				}
				
				// 获取传染病疾病字典别名中全部关键字
				Set IFAliasID=0
				For {
					Set IFAliasID=$o(^DHCMed.EPDC("IF",IFRowID,"InfAlias",IFAliasID))
					Quit:IFAliasID=""
					
					Set IFAliasObj=##class(DHCMed.EPD.InfectionAlias).GetObjById(IFRowID_"||"_IFAliasID)
					Continue:IFAliasObj=""
					
					Set IFKeyWordDesc = ""
					Set IFKeyWordDesc = $TR(IFAliasObj.MIFAAlias," ","")
					Continue:IFKeyWordDesc=""
					
					Set IFKeyWordCode = +IFAliasObj.MIFAIsKeyword
					
					// 处理关键字过滤的问题
					Continue:((IFKeyWordCode = 3) && (EPRAdmDiagnos[IFKeyWordDesc))
					
					If ((IFKeyWordCode = 1) && (EPRAdmDiagnos[IFKeyWordDesc)) {
						
						// 关键位置说明：校验电子病历诊断列表是否包含传染病疾病字典中指定的关键字
						If (EPRAdmDiagnos[IFKeyWordDesc) {
							Set Rst=$$CheckEpdDiagnosByEPRKeyWordRst(IFAliasObj)
							Set %ExtraData=%ExtraData_$ListBuild(Rst)
							Set Count=Count+1
						}
					}
				}
			}
		}
	}

	Set:Count>0 return=1
	Quit return
	
CheckEpdDiagnosByEPRKeyWordErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
CheckEpdDiagnosByEPRKeyWordRst(IFAliasObj)
	New (IFAliasObj)
	
	Set IFKindDesc=""
	Set IFKindCode=IFAliasObj.MIFAParRef.MIFKind
	Set objInfectionKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",IFKindCode,"")
	Set:$IsObject(objInfectionKind) IFKindDesc=objInfectionKind.Description
	
	Set tmpDesc = IFKindDesc
	Set ICD10 = IFAliasObj.MIFAParRef.MIFICD
	Set ICDDesc = IFAliasObj.MIFAParRef.MIFDisease
	Set tmpIFRowID = IFAliasObj.MIFAParRef.%Id()
	
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=""
	Set $p(tmp,$c(3),3)=""
	Set $p(tmp,$c(3),4)=ICD10_" "_ICDDesc
	Set $p(tmp,$c(3),5)=tmpIFRowID
	Set $p(tmp,$c(3),6)=""
	Set $p(tmp,$c(3),7)=""
	Quit tmp
}

}
