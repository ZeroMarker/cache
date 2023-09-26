/// 导出到民科医院感染系统（横断面）
/// 创建者：zhufei
/// 创建日期:2014-06-01
Class DHCMed.NINFService.Srv.ExportMinKeCss Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 默认分隔符  <TAB>
Parameter FieldSeperator = "^";

/// 说明        :更新导出标记
/// 输入参数    ：
/// ReportID    :报告的ID
/// 返回值      :返回0或1
/// w ##class(DHCMed.NINFService.Srv.ExportMinKeCss).UpdateExportFlg(1)
ClassMethod UpdateExportFlg(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set return=##class(DHCMed.NINF.CSS.ClinReportLog).Update(aInput,aSeparate)
	Quit:(+return)<1 return
	
	Set return=1
	Quit return
}

/// 说明        :导出的主函数
/// 输入参数    ：
/// ReportID    :报告的ID
/// 返回值      :
/// 返回值格式  :返回代码_$c(1)_问题描述_$c(1)_具体记录
/// 返回值代码  :OK--没有问题
/// 			:Error--有问题，但能够导出
/// 			:Fail--致命错误，无法导出
/// w ##class(DHCMed.NINFService.Srv.ExportMinKeCss).ExportReport(886)
ClassMethod ExportReport(ReportID As %String) As %String
{
	New (ReportID)
	Set return=""
	Quit:ReportID="" return
	
	Set objRep=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	
	Set $p(return,$c(1),1)=..BuildBaseInfo(objRep)        //病人基本信息
	Set $p(return,$c(1),2)=..BuildBaseDiag(objRep)        //基础疾病
	Set $p(return,$c(1),3)=..BuildLabResult(objRep)       //病原学检测
	
	Quit return
}

/// 病人基本信息
ClassMethod BuildBaseInfo(objRep As DHCMed.NINF.CSS.ClinReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	//*调查表时间（发生院内感染的时间）
	Set SurvDate=objRep.CRSurvDate
	Set SurvDate=$zd(+SurvDate,3)
	Set $p(ret,..#FieldSeperator,1)=SurvDate
	//*感染科别
	Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKCSSLocation",objRep.CRLoc,"",objRep.CRLoc)
	//院内科别
	Set $p(ret,..#FieldSeperator,3)=..GetMapping("MKCSSHospLoc",objRep.CRSurvLoc,"",objRep.CRSurvLoc)
	//*调查者
	Set $p(ret,..#FieldSeperator,4)=objRep.CRSurvUser
	//*病历号
	Set $p(ret,..#FieldSeperator,5)=objRep.CRMRNo
	//*姓名
	Set $p(ret,..#FieldSeperator,6)=objRep.CRName
	//*性别
	Set $p(ret,..#FieldSeperator,7)=objRep.CRSex
	//*年龄
	Set $p(ret,..#FieldSeperator,8)=objRep.CRAgeY_"岁"_objRep.CRAgeM_"月"_objRep.CRAgeD_"天"
	//床位号
	Set $p(ret,..#FieldSeperator,9)=objRep.CRBed
	//*医院感染
	Set $p(ret,..#FieldSeperator,10)=..GetMapping("MKCSSBoolean",objRep.CRIsInfection,"",objRep.CRIsInfection)
	//HbsAg 阳性
	Set $p(ret,..#FieldSeperator,11)=""
	//抗-HCV阳性
	Set $p(ret,..#FieldSeperator,12)=""
	//抗-HIV阳性
	Set $p(ret,..#FieldSeperator,13)=""
	//*动静脉插管
	Set $p(ret,..#FieldSeperator,14)=..GetMapping("MKCSSBoolean",objRep.CRAddOns1,"",objRep.CRAddOns1)
	//*泌尿道插管
	Set $p(ret,..#FieldSeperator,15)=..GetMapping("MKCSSBoolean",objRep.CRAddOns2,"",objRep.CRAddOns2)
	//*使用呼吸机
	Set $p(ret,..#FieldSeperator,16)=..GetMapping("MKCSSBoolean",objRep.CRAddOns3,"",objRep.CRAddOns3)
	//静脉输液
	Set $p(ret,..#FieldSeperator,17)=""
	//*抗菌药物使用
	Set $p(ret,..#FieldSeperator,18)=..GetMapping("MKCSSBoolean",objRep.CRAnti1,"",objRep.CRAnti1)
	//*目的
	Set $p(ret,..#FieldSeperator,19)=..GetMapping("MKCSSMedObj",objRep.CRAnti2,"",objRep.CRAnti2)
	//*联用
	Set $p(ret,..#FieldSeperator,20)=..GetMapping("MKCSSDrugCom",objRep.CRAnti3,"",objRep.CRAnti3)
	//*治疗用药已送细菌培养
	Set $p(ret,..#FieldSeperator,21)=..GetMapping("MKCSSBoolean",objRep.CRAnti4,"",objRep.CRAnti4)
	//*手术
	Set $p(ret,..#FieldSeperator,22)=..GetMapping("MKCSSBoolean",objRep.CROper1,"",objRep.CROper1)
	//*术前应用抗生素
	Set $p(ret,..#FieldSeperator,23)=..GetMapping("MKCSSBoolean",objRep.CROper2,"",objRep.CROper2)
	//*手术切口
	Set $p(ret,..#FieldSeperator,24)=..GetMapping("MKCSSOperCut",objRep.CROper3,"",objRep.CROper3)
	//*外科围术期用药
	Set $p(ret,..#FieldSeperator,25)=..GetMapping("MKCSSBoolean",objRep.CROper4,"",objRep.CROper4)
	//*入院日期
	Set $p(ret,..#FieldSeperator,26)=objRep.CRAdmDate
	//*过去24小时内是否有≥3次的腹泻
	Set $p(ret,..#FieldSeperator,27)=..GetMapping("MKCSSBoolean",objRep.CRAddOns4,"",objRep.CRAddOns4)
	
	Quit ret
}

/// 基本诊断
ClassMethod BuildBaseDiag(objRep As DHCMed.NINF.CSS.ClinReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set Diagnos=objRep.CRDiagnos
	For indDiag=1:1:$l(Diagnos,"#") {
		Set tmpDiag=$p(Diagnos,"#",indDiag)
		Continue:tmpDiag=""
		
		Set:ret'="" ret=ret_$c(2)
		Set ret=ret_..GetMapping("MKCSSDiagnos",tmpDiag,"",tmpDiag)
	}
	
	Quit ret
}

/// 病原学检测
ClassMethod BuildLabResult(objRep As DHCMed.NINF.CSS.ClinReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set InfPos=objRep.CRInfPos1
	Set InfDate=objRep.CRInfDate1
	Set Pathogen=objRep.CRPathogen1
	If InfPos'="" {
		Set InfPos=..GetMapping("MKCSSInfPos",InfPos,"",InfPos)
		For indPy=1:1:$l(Pathogen,"#") {
			Set tmpPy=$p(Pathogen,"#",indPy)
			Continue:tmpPy=""
			Set tmpPy=..GetMapping("MKCSSPathogeny",tmpPy,"",tmpPy)
			
			Set tmpret=""
			Set $p(tmpret,..#FieldSeperator,1)=InfPos
			Set $p(tmpret,..#FieldSeperator,2)=tmpPy
			Set $p(tmpret,..#FieldSeperator,3)=InfDate
			
			Set:ret'="" ret=ret_$c(2)
			Set ret=ret_tmpret
		}
	}
	
	Set InfPos=objRep.CRInfPos2
	Set InfDate=objRep.CRInfDate2
	Set Pathogen=objRep.CRPathogen2
	If InfPos'="" {
		Set InfPos=..GetMapping("MKCSSInfPos",InfPos,"",InfPos)
		For indPy=1:1:$l(Pathogen,"#") {
			Set tmpPy=$p(Pathogen,"#",indPy)
			Continue:tmpPy=""
			Set tmpPy=..GetMapping("MKCSSPathogeny",tmpPy,"",tmpPy)
			
			Set tmpret=""
			Set $p(tmpret,..#FieldSeperator,1)=InfPos
			Set $p(tmpret,..#FieldSeperator,2)=tmpPy
			Set $p(tmpret,..#FieldSeperator,3)=InfDate
			
			Set:ret'="" ret=ret_$c(2)
			Set ret=ret_tmpret
		}
	}
	
	Set InfPos=objRep.CRInfPos3
	Set InfDate=objRep.CRInfDate3
	Set Pathogen=objRep.CRPathogen3
	If InfPos'="" {
		Set InfPos=..GetMapping("MKCSSInfPos",InfPos,"",InfPos)
		For indPy=1:1:$l(Pathogen,"#") {
			Set tmpPy=$p(Pathogen,"#",indPy)
			Continue:tmpPy=""
			Set tmpPy=..GetMapping("MKCSSPathogeny",tmpPy,"",tmpPy)
			
			Set tmpret=""
			Set $p(tmpret,..#FieldSeperator,1)=InfPos
			Set $p(tmpret,..#FieldSeperator,2)=tmpPy
			Set $p(tmpret,..#FieldSeperator,3)=InfDate
			
			Set:ret'="" ret=ret_$c(2)
			Set ret=ret_tmpret
		}
	}
	
	Quit ret
}

/// w ##class(DHCMed.NINFService.Srv.ExportMinKeCss).ValidateReport(48)
ClassMethod ValidateReport(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	
	Set ErrorList=""
	Set tmp=..CheckReport(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	Set tmp=..CheckReportDiag(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	Set tmp=..CheckReportLab(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	
	Set:ErrorList'="" return=$e(ErrorList,1,$l(ErrorList)-1)
	Set:ErrorList="" return="OK"
	
	Quit return
}

ClassMethod CheckReport(objRep As DHCMed.NINF.CSS.ClinReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set tmp=..IsMapping(objRep.CRLoc,"","MKCSSLocation","报告科室无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRSurvLoc,"","MKCSSHospLoc","报告科室无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	
	Set tmp=..IsMapping(objRep.CRIsInfection,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRAddOns1,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRAddOns2,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRAddOns3,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRAddOns4,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRAnti1,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRAnti2,"","MKCSSMedObj","抗菌用药目的无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRAnti3,"","MKCSSDrugCom","抗菌用药联用无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRAnti4,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CROper1,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CROper2,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CROper3,"","MKCSSOperCut","手术切口无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CROper4,"","MKCSSBoolean","是否\有无无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportDiag(objRep As DHCMed.NINF.CSS.ClinReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set Diagnos=objRep.CRDiagnos
	For indDiag=1:1:$l(Diagnos,"#") {
		Set tmpDiag=$p(Diagnos,"#",indDiag)
		Continue:tmpDiag=""
		Set tmp=..IsMapping(tmpDiag,"","MKCSSDiagnos","报告科室无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportLab(objRep As DHCMed.NINF.CSS.ClinReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set tmp=..IsMapping(objRep.CRInfPos1,"","MKCSSInfPos","感染部位无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRInfPos2,"","MKCSSInfPos","感染部位无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.CRInfPos3,"","MKCSSInfPos","感染部位无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	
	Set Pathogen=objRep.CRPathogen1
	For indPy=1:1:$l(Pathogen,"#") {
		Set tmpPy=$p(Pathogen,"#",indPy)
		Continue:tmpPy=""
		Set tmp=..IsMapping(tmpPy,"","MKCSSPathogeny","病原菌无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	Set Pathogen=objRep.CRPathogen2
	For indPy=1:1:$l(Pathogen,"#") {
		Set tmpPy=$p(Pathogen,"#",indPy)
		Continue:tmpPy=""
		Set tmp=..IsMapping(tmpPy,"","MKCSSPathogeny","病原菌无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	Set Pathogen=objRep.CRPathogen3
	For indPy=1:1:$l(Pathogen,"#") {
		Set tmpPy=$p(Pathogen,"#",indPy)
		Continue:tmpPy=""
		Set tmp=..IsMapping(tmpPy,"","MKCSSPathogeny","病原菌无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

/// 判断是否已对照民科字典
/// 如果已对照，返回值 return="OK"
/// 如果未对照，返回值 return="ERROR^"_{对照字典类别}_"^"_{错误信息}_"^"_{源值}_"^"_{源值描述}
ClassMethod IsMapping(aSrcValue As %String, aSrcDesc As %String, aMappingType As %String, aErrorMsg As %String)
{
	New (aSrcValue,aSrcDesc,aMappingType,aErrorMsg)
	Set return=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).IsMapping(aSrcValue,aSrcDesc,aMappingType,aErrorMsg)
	Quit return
}

/// 取对照民科字典值，取之为空返回默认值
ClassMethod GetMapping(aMappingType As %String, aSrcValue As %String, aSrcDesc As %String, aDefaultValue As %String = "") As %String
{
	New (aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Set return=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).GetMapping(aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Quit return
}

/// 查询医院感染报告校验信息
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Srv.ExportMinKeCss","QryValidateInfo","503^509^536^539^542^540","^")
Query QryValidateInfo(aReportList As %String, aDelimiter As %String = "^") As %Query(ROWSPEC = "Index:%String,ID:%String,SrcValue:%String,SrcDesc:%String,TargetValue:%String,TargetDesc:%String,ResumeText:%String,MappingTypeCode:%String,MappingTypeDesc:%String,MapDicGroupCode:%String,MapDicTypeCode:%String")
{
}

ClassMethod QryValidateInfoExecute(ByRef qHandle As %Binary, aReportList As %String, aDelimiter As %String = "^") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set NIndex="QryValidateInfo"
 	Kill ^TMP($zn,$j,NIndex)
 	
 	For indRep=1:1:$l(aReportList,aDelimiter) {
 		Set ReportID=$p(aReportList,aDelimiter,indRep)
 		Continue:ReportID=""
 		
 		Set flg=..ValidateReport(ReportID)
 		Continue:flg="OK"
 		Set ErrorList=flg    //获取错误列表
 		
 		For indErr=1:1:$l(ErrorList,$c(2)) {
	 		Set ErrorItem=$p(ErrorList,$c(2),indErr)
	 		Continue:ErrorItem=""
	 		
	 		//"ERROR^"_{对照字典类别}_"^"_{错误信息}_"^"_{源值}_"^"_{源值描述}
	 		Set ErrorLevel=$p(ErrorItem,"^",1)   //错误级别
	 		Set MappingType=$p(ErrorItem,"^",2)  //对照字典类别
	 		Set ErrorMsg=$p(ErrorItem,"^",3)     //错误信息
	 		Set SrcValue=$p(ErrorItem,"^",4)     //源值
	 		Set SrcDesc=$p(ErrorItem,"^",5)      //源值描述
	 		Continue:((MappingType="")||(SrcValue=""))
	 		Set ^TMP($zn,$j,NIndex,"ErrorIndex",MappingType,SrcValue)=ErrorItem
	 	}
 	}
 	
 	Set xMappingType=""
 	For {
	 	Set xMappingType=$o(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType))
	 	Quit:xMappingType=""
	 	
	 	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("INFMinkeMappingType",xMappingType,"")
	 	Continue:'$IsObject(objDic)
	 	
	 	Set xSrcValue=""
	 	For {
	 		Set xSrcValue=$o(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType,xSrcValue))
	 		Quit:xSrcValue=""
	 		
			Set ErrorItem=$g(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType,xSrcValue))
	 		Continue:ErrorItem=""
	 		Set ErrorLevel=$p(ErrorItem,"^",1)   //错误级别
	 		Set MappingType=$p(ErrorItem,"^",2)  //对照字典类别
	 		Set ErrorMsg=$p(ErrorItem,"^",3)     //错误信息
	 		Set SrcValue=$p(ErrorItem,"^",4)     //源值
	 		Set SrcDesc=$p(ErrorItem,"^",5)      //源值描述
	 		
	 		//字典对照RowID
	 		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$zcvt(MappingType,"U")," "_$zcvt(SrcValue,"U"),0))
	 		
	 		//对照字典类别代码,对照字典类别名称,源值,源值描述,目标值,目标值描述,备注,字典类别,序号
	 		Set Data=$lb("")
	 		Set $li(Data,1)=ind
	 		Set $li(Data,2)=ID
	 		Set $li(Data,3)=SrcValue
	 		Set $li(Data,4)=SrcDesc
	 		Set $li(Data,5)=""
	 		Set $li(Data,6)=""
	 		Set $li(Data,7)=""
	 		Set $li(Data,8)=objDic.Code
	 		Set $li(Data,9)=objDic.Description
	 		Set $li(Data,10)=objDic.StrA
	 		Set $li(Data,11)=objDic.StrB
	 		Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
	 	}
 	}
 	Kill ^TMP($zn,$j,NIndex)
 	
	Quit $$$OK
}

ClassMethod QryValidateInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryValidateInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryValidateInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryValidateInfoExecute ]
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

}
