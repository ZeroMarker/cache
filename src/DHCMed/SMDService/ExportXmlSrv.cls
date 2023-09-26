/// 创建者：李阳
/// 创建日期：2015-02-05
/// 功能：为创建XML文件提供公共调用函数
Class DHCMed.SMDService.ExportXmlSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Add By LiYang 2015-02-03
/// 生成XML文件用的病人号码
/// 格式：机构编码+时间（包括时分秒）+四位随机码
/// w ##class(DHCMed.SMDService.ExportXmlSrv).GetPatSerialNo(1)
ClassMethod GetPatSerialNo(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Set return=$g(^DHCMed.SMD.ReportC("SerialNo",aReportID))
	Quit:return'="" return
	
	Set objRep=##class(DHCMed.SMD.Report).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Set EpisodeID=objRep.SREpisodeID
	Set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	Set HospitalID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	Set HospInsCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SMD-HospInsCode",HospitalID)
	Set CurrDate=$zd(+$h,3)
	Set CurrDate=$tr(CurrDate,"-","")
	Set CurrTime=$zt($p($h,",",2),1)
	Set CurrTime=$tr(CurrTime,":","")
	Set Rnd=$Random(9999)
	Set return=HospInsCode_CurrDate_CurrTime_Rnd
	Set ^DHCMed.SMD.ReportC("SerialNo",aReportID)=return  //一份报告对应一个唯一标识
	Quit return
}

/// 功能：通过字典ID获取它的描述
/// 表：DHCMed.SS.AreaDic
/// 参数：DHCMed.SS.AreaDic表的RowID
/// 返回值：DHCMed.SS.AreaDic的短描述
ClassMethod GetAreaDicDesc(aId As %String) As %String
{
	New (aId)
	Set return=""
	Quit:aId="" return
	Set obj=##class(DHCMed.SS.AreaDic).GetObjById(aId)
	Quit:'$IsObject(obj) return
	Set return=obj.ShortDesc
	Quit return
}

/// w ##class(DHCMed.SMDService.ExportXmlSrv).ValidateReport(2)
ClassMethod ValidateReport(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=##class(DHCMed.SMD.Report).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	
	Set ErrorList=""
	Set tmp=..CheckReport(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	
	Set:ErrorList'="" return=$e(ErrorList,1,$l(ErrorList)-1)
	Set:ErrorList="" return="OK"
	
	Quit return
}

/// w ##Class(DHCMed.SMDService.ExportXmlSrv).CheckReport()
ClassMethod CheckReport(objRep As DHCMed.SMD.Report) As %String
{
	New (objRep)
	Set return=""
	Quit:'$IsObject(objRep) return
	Set ReportID=objRep.%Id()
	Set EpisodeID=objRep.SREpisodeID
	
	//获取患者基本信息
	Set objPat=##class(DHCMed.SMD.ReportPat).GetPatObj(ReportID,EpisodeID)
	
	//性别
	If (objPat.RPSex'="") {
		Set tmp=..IsMapping(objPat.RPSex,"","IOSex","性别代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//民族
	If (objPat.RPNation'="") {
		Set NationDr=##class(DHCMed.SS.Dictionary).GetObjById(objPat.RPNation)
		Set NationDesc=NationDr.Description
		;Set tmp=..IsMapping(objPat.RPNation,"","IONation","民族代码无法对照")
		Set tmp=..IsMapping(NationDesc,"","IONation","民族代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	
	
	//人员属地
	If $IsObject(objRep.SRLocalDr) {
		Set tmp=..IsMapping(objRep.SRLocalDr.Code,objRep.SRLocalDr.Description,"IOLocal","常住类型代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//现住址类型
	If $IsObject(objRep.SRCurrAddrTypeDr) {
		Set tmp=..IsMapping(objRep.SRCurrAddrTypeDr.Code,objRep.SRCurrAddrTypeDr.Description,"IOAddrType","地区类型代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//现住址(省、市)
	If (objRep.SRCurrProvince'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRCurrProvince)
		If $IsObject(objArea) {
			Set tmp=..IsMapping(objArea.Code,objArea.ShortDesc,"IOProvince","省代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//现住址(区)
	If (objRep.SRCurrCounty'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRCurrCounty)
		If $IsObject(objArea) {
			Set tmp=..IsMapping(objArea.Code,objArea.ShortDesc,"IOCounty","区县代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//现住址(街道)
	If (objRep.SRCurrVillage'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRCurrVillage)
		If $IsObject(objArea) {
			Set tmp=..IsMapping(objArea.Code,objArea.ShortDesc,"IOVillage","街道代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//职业类别
	If $IsObject(objRep.SROccupationDr) {
		Set tmp=..IsMapping(objRep.SROccupationDr.Code,objRep.SROccupationDr.Description,"IOOccupation","职业类别代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//患者类型
	If $IsObject(objRep.SRPatTypeDr) {
		Set tmp=..IsMapping(objRep.SRPatTypeDr.Code,objRep.SRPatTypeDr.Description,"IOPatType","患者类型代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//疾病名称
	If $IsObject(objRep.SRDiseaseDr) {
		If $IsObject(objRep.SRDiseaseDr.IDCateDr) {
			Set tmp=..IsMapping(objRep.SRDiseaseDr.IDCateDr.Code,objRep.SRDiseaseDr.IDCateDr.Description,"IODiseasType","诊断代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//ICD10编码
	If $IsObject(objRep.SRDiseaseDr) {
		Set tmp=..IsMapping(objRep.SRDiseaseDr.IDCode,objRep.SRDiseaseDr.IDDesc,"IOICD10","ICD10代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//户籍类型
	If $IsObject(objRep.SRRegAddrTypeDr) {
		Set tmp=..IsMapping(objRep.SRRegAddrTypeDr.Code,objRep.SRRegAddrTypeDr.Description,"IOAddrType","地区类型代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//户籍省
	If (objRep.SRRegProvince'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRRegProvince)
		If $IsObject(objArea) {
			Set tmp=..IsMapping(objArea.Code,objArea.ShortDesc,"IOProvince","省代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//户籍区县
	If (objRep.SRRegCounty'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRRegCounty)
		If $IsObject(objArea) {
			Set tmp=..IsMapping(objArea.Code,objArea.ShortDesc,"IOCounty","区县代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//户籍街道
	If (objRep.SRRegVillage'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRRegVillage)
		If $IsObject(objArea) {
			Set tmp=..IsMapping(objArea.Code,objArea.ShortDesc,"IOVillage","街道代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//送诊主体
	For indRef=1:1:objRep.SRReferralDr.Count() {
		Set objRef=objRep.SRReferralDr.GetAt(indRef)
		If $IsObject(objRef) {
			Set tmp=..IsMapping(objRef.Code,objRef.Description,"IOReferral","送诊主体代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//本次入院原因
	If $IsObject(objRep.SRAdmitReasonDr) {
		Set tmp=..IsMapping(objRep.SRAdmitReasonDr.Code,objRep.SRAdmitReasonDr.Description,"IOAdmitReason","本次入院原因代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//精神症状
	For indSym=1:1:objRep.SRSymptomDr.Count() {
		Set objSym=objRep.SRSymptomDr.GetAt(indSym)
		If $IsObject(objSym) {
			Set tmp=..IsMapping(objSym.MSCode,objSym.MSDesc,"IOSymptom","精神症状代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//门诊既往治疗情况
	If $IsObject(objRep.SROPTreatmentDr) {
		Set tmp=..IsMapping(objRep.SROPTreatmentDr.Code,objRep.SROPTreatmentDr.Description,"IOOPTreatment","门诊既往治疗情况代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//主要医疗付款方式
	If $IsObject(objRep.SRPaymentDr) {
		Set tmp=..IsMapping(objRep.SRPaymentDr.Code,objRep.SRPaymentDr.Description,"IOPayment","主要医疗付款方式代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//本次住院康复措施
	For indTM=1:1:objRep.SRTreatMeasureDr.Count() {
		Set objTM=objRep.SRTreatMeasureDr.GetAt(indTM)
		If $IsObject(objTM) {
			Set tmp=..IsMapping(objTM.Code,objTM.Description,"IOMeasure","康复措施代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//住院疗效
	If $IsObject(objRep.SRPrognosisDr) {
		Set tmp=..IsMapping(objRep.SRPrognosisDr.Code,objRep.SRPrognosisDr.Description,"IOPrognosis","住院疗效代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//本次住院患者是否获得经费补助
	If $IsObject(objRep.SRIsFunding) {
		Set tmp=..IsMapping(objRep.SRIsFunding.Code,objRep.SRIsFunding.Description,"IOIsFunding","是否获得经费补助代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//补贴类型
	If $IsObject(objRep.SRFundsType) {
		Set tmp=..IsMapping(objRep.SRFundsType.Code,objRep.SRFundsType.Description,"IOFundsType","补贴类型代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//经费来源
	If $IsObject(objRep.SRFundsSourceDr) {
		Set tmp=..IsMapping(objRep.SRFundsSourceDr.Code,objRep.SRFundsSourceDr.Description,"IOFundsSource","经费来源代码无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	//下一步康复措施
	For indRM=1:1:objRep.SRRehabMeasureDr.Count() {
		Set objRM=objRep.SRRehabMeasureDr.GetAt(indRM)
		If $IsObject(objRM) {
			Set tmp=..IsMapping(objRM.Code,objRM.Description,"IOMeasure","康复措施代码无法对照")
			Set:tmp'="OK" return=return_tmp_$c(2)
		}
	}
	//患者信息完整性
	If $IsObject(objRep.SRWholenessDr) {
		Set tmp=..IsMapping(objRep.SRWholenessDr.Code,objRep.SRWholenessDr.Description,"IOWholeness","患者信息完整性无法对照")
		Set:tmp'="OK" return=return_tmp_$c(2)
	}
	
	Set:return'="" return=$e(return,1,$l(return)-1)
	Set:return="" return="OK"
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  检查接口字典对照
/// Table：       DHCMed.SMD.IOMapping
/// Input：       ReportIDs : 报告ID串,“^”分隔
/// Return：      ROWSPEC=...
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.SMDService.ExportXmlSrv","QryValidateInfo","1")
Query QryValidateInfo(aReportIDs As %String) As %Query(ROWSPEC = "Index:%String,ID:%String,SrcValue:%String,SrcDesc:%String,TargetValue:%String,TargetDesc:%String,ResumeText:%String,MappingTypeCode:%String,MappingTypeDesc:%String,MapDicGroupCode:%String,MapDicTypeCode:%String")
{
}

ClassMethod QryValidateInfoExecute(ByRef qHandle As %Binary, aReportIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set NIndex="QryValidateInfo"
 	Kill ^TMP($zn,$j,NIndex)
 	
 	For indRep=1:1:$l(aReportIDs,"^") {
 		Set ReportID=$p(aReportIDs,"^",indRep)
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
	 	
	 	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("SMDIOMappingType",xMappingType,"")
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
	 		Set ID=$o(^DHCMed.SMD.IOMappingI("IndexCategorySrcID"," "_$zcvt(MappingType,"U")," "_$zcvt(SrcValue,"U"),0))
	 		
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

/// 判断是否已对照接口字典
/// 如果已对照，返回值 return="OK"
/// 如果未对照，返回值 return="ERROR^"_{对照字典类别}_"^"_{错误信息}_"^"_{源值}_"^"_{源值描述}
ClassMethod IsMapping(aSrcValue As %String, aSrcDesc As %String, aMappingType As %String, aErrorMsg As %String)
{
	New (aSrcValue,aSrcDesc,aMappingType,aErrorMsg)
	Set return=""
	Quit:(aMappingType="")||(aSrcValue="") return
	
	Set tmpValue=..GetMapping(aMappingType,aSrcValue,aSrcDesc)
	If tmpValue="" {
		Set return="ERROR^"_aMappingType_"^"_aErrorMsg_"^"_aSrcValue_"^"_aSrcDesc
	} Else {
		Set return="OK"
	}
	
	Quit return
}

/// 取对照接口字典值，取之为空返回默认值
/// w ##Class(DHCMed.SMDService.ExportXmlSrv).GetMapping()
ClassMethod GetMapping(aMappingType As %String, aSrcValue As %String, aSrcDesc As %String, aDefaultValue As %String = "") As %String
{
	New (aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Set return=""
	Quit:(aMappingType="")||(aSrcValue="") return
	
	//存储数据时，把空格都替换掉了
	Set aSrcValue=$tr(aSrcValue," ","")
	
	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("SMDIOMappingType",aMappingType,"")
	Quit:'$IsObject(objDic) return
	Set TargetField=objDic.StrC
	Set:TargetField="" TargetField="Target"
	
	Set aSrcValue=..Trim(aSrcValue)  //处理前后空格
	Set objMap=##class(DHCMed.SMD.IOMapping).GetMappingData(aMappingType,aSrcValue)
	If $IsObject(objMap){
		If TargetField="Target" {
			Set return=objMap.Target               //取目标值
		} ElseIf TargetField="TargetDesc" {
			Set return=objMap.TargetDesc           //取目标值描述
		} ElseIf TargetField="SrcObjectID" {
			Set return=objMap.SrcObjectID          //取源值
		} ElseIf TargetField="SrcDescription" {
			Set return=objMap.SrcDescription       //取源值描述
		} Else {}
	}
	
	If return="空" {
		Set return=""
	} Else {
		Set:return="" return=aDefaultValue             //默认值
	}
	Quit return
}

/// 去除字符串前后空格，内部空格不删除
/// w ##class(DHCMed.NINFService.Srv.CommonCls).Trim("   aaa    ")
ClassMethod Trim(str As %String) As %String
{
	New (str)
	
	Set str=..Translate(str,"\n","")
	
	Set FromIndex=1
	Set ToIndex=$l(str)
	For i=1:1:$l(str)
	{
		Quit:($ASCII(str,i)'=32)&&($ASCII(str,i)'=9)&&($ASCII(str,i)'=10)&&($ASCII(str,i)'=13)
		Set FromIndex=FromIndex+1
	}
	For i=$l(str):-1:1
	{
		Quit:($ASCII(str,i)'=32)&&($ASCII(str,i)'=9)&&($ASCII(str,i)'=10)&&($ASCII(str,i)'=13)
		Set ToIndex=ToIndex-1
	}
	Quit:ToIndex<FromIndex ""
	Quit $e(str,FromIndex,ToIndex)
}

/// w ##Class(DHCMed.NINFService.Srv.CommonCls).Translate("aaaa\nbbb","\n","")
ClassMethod Translate(string As %String, identifier As %String, associator As %String) As %String
{
	New (string,identifier,associator)
	Set return=""
	Quit:(string="")||(identifier="") return
	
	For Ind=1:1:$l(string,identifier)
	{
		Set tmp=$p(string,identifier,Ind)
		If return="" {
			Set return=tmp
		}Else{
			Set return=return_associator_tmp
		}
	}
	
	Quit return
}

}
