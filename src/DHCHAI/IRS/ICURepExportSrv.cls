/// 名称: DHCHAI.IRS.ICURepExportSrv
/// 描述: ICU调查表明细数据导出相关服务
/// 编写者： zhouob
/// 编写日期: 2023-02-01
Class DHCHAI.IRS.ICURepExportSrv Extends (%RegisteredObject, DHCHAI.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouob
/// CreatDate：   2023-03-09
/// Description:  导出ICU调查表
/// w ##class(DHCHAI.IRS.ICURepExportSrv).ExportFromServer("1","2023-04-08","2023-04-11","80",2,"")
ClassMethod ExportFromServer(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, LocID As %String = "", aDateType As %String = "", aStatus As %String = "", aRepIDs As %Text = "") As %String
{
	New (aHospIDs,aDateFrom,aDateTo,LocID,aDateType,aStatus,aRepIDs)
	Set return=""
	quit:(aDateFrom="")||(aDateTo="")||(aRepIDs="") return
 	Set:aDateType="" aDateType=1
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aExtension="xls"
	Quit:$listfind($lb("xls","csv","txt"),aExtension)=0 return
	Set NIndex = "ExportFromServer"
 	Kill ^TMP($zn,$j,NIndex)
 	
 	Kill ^TMP($zn,$j,"QryICURepInfo")
 	
	Set aSeparate = $s(aExtension="xls":$c(9),aExtension="csv":",",aExtension="txt":$c(9),1:"")
	//创建文件
	Set cDate=$tr($zd(+$h,3),"-","")
	Set cTime=$tr($zt($p($h,",",2),1),":","")
	Set FileName="ICURepDetaile."_aExtension
	Set FileDir=..GetTempDir()  //获取服务器文件目录
	New File
	Set File=##class(%File).%New(FileDir_FileName)
	Do File.Open("NWRS")
	
	For xind=1:1:$l(aRepIDs,","){
		Set xRepID=$p(aRepIDs,",",xind)
		Continue:xRepID=""
		Do BuildICURepDate
	}
	// 输出表头
	Set ViewTitles="登记号^病案号^姓名^年龄^性别^就诊科室^就诊病区^入科日期^出科日期^APACH评分^报告日期^填报科室"
	// PICC表头
	Set PICCMax=+$g(^TMP($zn,$j,"QryICURepInfo","PICCMax"))
	For indx=1:1:PICCMax{
		Set ViewTitles=ViewTitles_"^PICC导管类型"_indx_"^导管腔数"_indx_"^置管部位"_indx_"^置管日期"_indx_"^拔管日期"_indx_"^置管人员"_indx_"^置管地点"_indx_"^是否感染"_indx_"^感染日期"_indx_"^感染症状"_indx
	}
	// VAP表头
	Set VAPMax=+$g(^TMP($zn,$j,"QryICURepInfo","VAPMax"))
	For indx=1:1:VAPMax{
		Set ViewTitles=ViewTitles_"^VAP气道类型"_indx_"^上机时间"_indx_"^脱机时间"_indx_"^置管人员"_indx_"^置管地点"_indx_"^是否感染"_indx_"^感染日期"_indx_"^感染症状"_indx	
	}
	// UC表头
	Set UCMax=+$g(^TMP($zn,$j,"QryICURepInfo","UCMax"))
	For indx=1:1:UCMax{
		Set ViewTitles=ViewTitles_"^UC尿管类型"_indx_"^插管时间"_indx_"^拔管时间"_indx_"^置管人员"_indx_"^置管地点"_indx_"^是否感染"_indx_"^感染日期"_indx_"^感染症状"_indx
	}
	
	//导出表头
	Do File.WriteLine($tr(ViewTitles,"^",aSeparate))
	
	Set Row=2,Col=1
	/// 组织输出
	Set xRepID=""
	For {
		Set xRepID = $o(^TMP($zn,$j,"QryICURepInfo","Rep",xRepID))
		Quit:xRepID=""
		Set ReportID = xRepID 
		Set RowData="" 
		Set DataBase = $g(^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"BASE"))	
		Continue:DataBase=""
		
		//输出基本信息
		Set BaseCnt=$ll(DataBase)
		For indx=1:1:$ll(DataBase) {
			Set data=$lg(DataBase,indx)
			Set RowData=RowData_aSeparate_data
		}
		Set PICCMax=+$g(^TMP($zn,$j,"QryICURepInfo","PICCMax"))
		For indx=1:1:PICCMax{
			Set tmpDataPICC = $g(^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"PICC",indx))
			If (tmpDataPICC'=""){ // 10个字段
				//输出PICC
				For indxx=1:1:$ll(tmpDataPICC) {
					Set data=$lg(tmpDataPICC,indxx)
					Set RowData=RowData_aSeparate_data
				}
			}Else{
				Set RowData=RowData_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""
			}
		}
		Set VAPMax=+$g(^TMP($zn,$j,"QryICURepInfo","VAPMax"))
		For indx=1:1:VAPMax{
			Set tmpDataVAP = $g(^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"VAP",indx))
			If (tmpDataVAP'=""){ // 8个字段
				//输出PICC
				For indxx=1:1:$ll(tmpDataVAP) {
					Set data=$lg(tmpDataVAP,indxx)
					Set RowData=RowData_aSeparate_data
				}
			}Else{
				Set RowData=RowData_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""
			}
		}
		Set UCMax=+$g(^TMP($zn,$j,"QryICURepInfo","UCMax"))
		For indx=1:1:UCMax{
			Set tmpDataUC = $g(^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"UC",indx))
			If (tmpDataUC'=""){ // 8个字段
				//输出PICC
				For indxx=1:1:$ll(tmpDataUC) {
					Set data=$lg(tmpDataUC,indxx)
					Set RowData=RowData_aSeparate_data
				}
			}Else{
				Set RowData=RowData_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""_aSeparate_""
			}
		}
		
		Continue:RowData=""
		Set RowData=$e(RowData,2,$l(RowData))
		Do File.WriteLine(RowData)
		
		Set Row=Row+1
		Set Col=1
	}
	
	Do File.Flush()
	Do File.%Save()
	Do File.Close()
	Set File=""
	Set url="dhcma.hai.filedownload.csp?1=1&act=download&filename="_FileName_"&dirname="_FileDir_"&2=2"
	Kill ^TMP($zn,$j,NIndex)
	Quit url
	
BuildICURepDate
	Set ReportID=xRepID
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
	Quit:'$IsObject(objReport)
	If $IsObject(objReport.IRStatusDr) {
		Set ReportStatusID=objReport.IRStatusDr.%Id()
		Set ReportStatusCode=objReport.IRStatusDr.BTCode
		Set ReportStatusDesc=objReport.IRStatusDr.BTDesc
	}
	Set ReportLocDesc=""
	Set objRepLoc=objReport.IRRepLocDr
	If $IsObject(objRepLoc) {
		Set ReportLocID=objRepLoc.%Id()
		Set ReportLocDesc=objRepLoc.BTDesc2
		Set:ReportLocDesc="" ReportLocDesc=objRepLoc.BTDesc
		If $IsObject(objReport.IRRepLocDr.BTHospDr){
			Set HospID=objReport.IRRepLocDr.BTHospDr.%Id()			
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
		}
	}
	Set objPaadm=objReport.IREpisodeDr
	Quit:'$IsObject(objPaadm)
	Set EpisodeID = objPaadm.%Id()
	Set AdmitDate=objPaadm.PAAdmDate
	If (AdmitDate'="")
	{
		Set AdmitDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmitDate)
	}
	Set AdmitTime=objPaadm.PAAdmTime
	Set DischDate=objPaadm.PADischDate
	If (DischDate'="")
	{
		Set DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	}
	Set AdmLoc=objPaadm.PAAdmLocDr.BTDesc2
	Set AdmWard=objPaadm.PAAdmWardDr.BTDesc2
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objPaadm.PAAdmBedDr){
		Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
		Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
	}
	/// 基础数据
	Set PatientID=objPaadm.PAPatientIDx
	Set PapmiNo=objPaadm.PAPapmiNo
	Set PatName=objPaadm.PAPatName
	Set PatMrNo=objPaadm.PAMrNo
	Set PatAge=objPaadm.PAAge
	Set IsDeath = objPaadm.PAIsDeath
	Set IsDeath=$s(IsDeath="1":"是",1:"否")
	Set PADeathDate = objPaadm.PADeathDate
	Set:PADeathDate'="" PADeathDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PADeathDate)
	Set PADeathTime = objPaadm.PADeathTime
	Set:PADeathTime'="" PADeathTime=$zt(PADeathTime,1)
	Set PatSex=objPaadm.PASex
	Set PatSex=$s(PatSex="M":"男",PatSex="F":"女",1:"其他")
	//当前科室 
	Set (AdmLocID,AdmLocDesc,AdmWardID,AdmWardDesc)=""
	If $IsObject(objPaadm.PAAdmLocDr){
		Set AdmLocID = objPaadm.PAAdmLocDr.%Id()
		Set AdmLocDesc = objPaadm.PAAdmLocDr.BTDesc
		Set:$p(AdmLocDesc,"-",2)'="" AdmLocDesc=$p(AdmLocDesc,"-",2)
		Set AdmLocDesc2 = objPaadm.PAAdmLocDr.BTDesc2
		Set:AdmLocDesc2'="" AdmLocDesc=AdmLocDesc2
	}
	If $IsObject(objPaadm.PAAdmWardDr){
		Set AdmWardID = objPaadm.PAAdmWardDr.%Id()
		Set AdmWardDesc = objPaadm.PAAdmWardDr.BTDesc
		Set:$p(AdmWardDesc,"-",2)'="" AdmWardDesc=$p(AdmWardDesc,"-",2)
		Set AdmWardDesc2 = objPaadm.PAAdmWardDr.BTDesc2
		Set:AdmWardDesc2'="" AdmWardDesc=AdmWardDesc2
	}
	Quit:((LocID'="")&&(LocID'=AdmLocID)&&(LocID'=AdmWardID))
	Set PAAdmDate=AdmitDate
	Set PADischDate=DischDate
	
	Set APACHEScore = objReport.IRAPACHEScore
	Set RepDate = objReport.IRRepDate
	Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	
	Set HisEpisodeID = objPaadm.PAEpisodeIDx
	Set HisEpisodeID = $p(HisEpisodeID,"||",2)
	Set Data=$lb(PapmiNo,PatMrNo,PatName,PatAge,PatSex,AdmLocDesc,AdmWardDesc,PAAdmDate,PADischDate,APACHEScore,RepDate,ReportLocDesc)
	Set ^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"BASE")=Data	
	
	///  PICC数据
	Set PICCCnt=0
	Set xPICCID = ""
	For {
		Set xPICCID = $o(^DHCHAI.IR.INFICUPICCI("IdxofIREpisodeDr",EpisodeID,xPICCID))
		Quit:xPICCID=""
		
		Set obj = ##class(DHCHAI.IR.INFICUPICC).GetObjById(xPICCID)
		Continue:'$Isobject(obj)
		Set IRIntuDate = obj.IRIntuDate
		Set:IRIntuDate'="" IRIntuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRIntuDate)
		Set IRExtuDate = obj.IRExtuDate
		Set:IRExtuDate'="" IRExtuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRExtuDate)
		//导管类型 导管腔数 置管部位 ...
		Set (IRPICCType,IRPICCTypeDesc,IRPICCCnt,IRPICCCntDesc)=""
		Set (IRPICCPos,IRPICCPosDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc)=""
		if $Isobject(obj.IRPICCType)
		{
			Set IRPICCType =obj.IRPICCType.%Id()
			Set IRPICCTypeDesc =obj.IRPICCType.BTDesc
		}
		if $Isobject(obj.IRPICCCnt)
		{
			Set IRPICCCnt =obj.IRPICCCnt.%Id()
			Set IRPICCCntDesc =obj.IRPICCCnt.BTDesc
		}
		if $Isobject(obj.IRPICCPos)
		{
			Set IRPICCPos =obj.IRPICCPos.%Id()
			Set IRPICCPosDesc =obj.IRPICCPos.BTDesc
		}
		if $Isobject(obj.IROperDoc)
		{
			Set IROperDoc =obj.IROperDoc.%Id()
			Set IROperDocDesc =obj.IROperDoc.BTDesc
		}
		if $Isobject(obj.IROperLoc)
		{
			Set IROperLoc =obj.IROperLoc.%Id()
			Set IROperLocDesc =obj.IROperLoc.BTDesc
		}
		Set IRIsInf = obj.IRIsInf
		Set IRIsInf = $s(IRIsInf="1":"是",1:"否")
		Set IRInfDate = obj.IRInfDate
		Set:IRInfDate'="" IRInfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRInfDate)
		if $Isobject(obj.IRInfSymptoms)
		{
			Set IRInfSymptoms =obj.IRInfSymptoms.%Id()
			Set IRInfSymptomsDesc =obj.IRInfSymptoms.BTDesc
		}
		Set (BacteriaID,BacteriaDesc)=""
		if $Isobject(obj.IRBacteria)
		{
			Set BacteriaID =obj.IRBacteria.%Id()
			Set BacteriaDesc =obj.IRBacteria.BTBacDesc
		}
		
		Set PICCCnt=PICCCnt+1
		Set Data=$lb(IRPICCTypeDesc,IRPICCCntDesc,IRPICCPosDesc,IRIntuDate,IRExtuDate,IROperDocDesc,IROperLocDesc,IRIsInf,IRInfDate,IRInfSymptomsDesc)
		Set ^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"PICC",PICCCnt)=Data
	}
	Set tmpMax=+$g(^TMP($zn,$j,"QryICURepInfo","PICCMax"))
	If (PICCCnt>tmpMax) {
		Set ^TMP($zn,$j,"QryICURepInfo","PICCMax")=PICCCnt
	}
	/// 呼吸机数据
	Set VAPCnt=0
	Set xVAPID = ""
	For {
		Set xVAPID = $o(^DHCHAI.IR.INFICUVAPI("IdxofIREpisodeDr",EpisodeID,xVAPID))
		Quit:xVAPID=""
		
		Set obj = ##class(DHCHAI.IR.INFICUVAP).GetObjById(xVAPID)
		Continue:'$Isobject(obj)
		Set IRIntuDate = obj.IRIntuDate
		Set:IRIntuDate'="" IRIntuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRIntuDate)
		Set IRExtuDate = obj.IRExtuDate
		Set:IRExtuDate'="" IRExtuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRExtuDate)
		//置管人员 ...
		Set (IRVAPType,IRVAPTypeDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc)=""
		
		if $Isobject(obj.IRVAPType)
		{
			Set IRVAPType =obj.IRVAPType.%Id()
			Set IRVAPTypeDesc =obj.IRVAPType.BTDesc
		}
		if $Isobject(obj.IROperDoc)
		{
			Set IROperDoc =obj.IROperDoc.%Id()
			Set IROperDocDesc =obj.IROperDoc.BTDesc
		}
		if $Isobject(obj.IROperLoc)
		{
			Set IROperLoc =obj.IROperLoc.%Id()
			Set IROperLocDesc =obj.IROperLoc.BTDesc
		}
		Set IRIsInf = obj.IRIsInf
		Set IRIsInf = $s(IRIsInf="1":"是",1:"否")
		Set IRInfDate = obj.IRInfDate
		Set:IRInfDate'="" IRInfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRInfDate)
		if $Isobject(obj.IRInfSymptoms)
		{
			Set IRInfSymptoms =obj.IRInfSymptoms.%Id()
			Set IRInfSymptomsDesc =obj.IRInfSymptoms.BTDesc
		}
		
		Set VAPCnt=VAPCnt+1
		Set Data=$lb(IRVAPTypeDesc,IRIntuDate,IRExtuDate,IROperDocDesc,IROperLocDesc,IRIsInf,IRInfDate,IRInfSymptomsDesc)
		Set ^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"VAP",VAPCnt)=Data
	}
	
	Set tmpMax=+$g(^TMP($zn,$j,"QryICURepInfo","VAPMax"))
	If (VAPCnt>tmpMax){
		Set ^TMP($zn,$j,"QryICURepInfo","VAPMax")=VAPCnt
	}
	
	/// 导尿管数据
	Set UCCnt=0
	Set xUCID = ""
	For {
		Set xUCID = $o(^DHCHAI.IR.INFICUUCI("IdxofIREpisodeDr",EpisodeID,xUCID))
		Quit:xUCID=""
		
		Set obj = ##class(DHCHAI.IR.INFICUUC).GetObjById(xUCID)
		Continue:'$Isobject(obj)
		Set IRIntuDate = obj.IRIntuDate
		Set:IRIntuDate'="" IRIntuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRIntuDate)
		Set IRExtuDate = obj.IRExtuDate
		Set:IRExtuDate'="" IRExtuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRExtuDate)
		//置管人员 ...
		Set (IRUCType,IRUCTypeDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc,IsCheck)=""
		
		if $Isobject(obj.IRUCType)
		{
			Set IRUCType =obj.IRUCType.%Id()
			Set IRUCTypeDesc =obj.IRUCType.BTDesc
		}
		if $Isobject(obj.IROperDoc)
		{
			Set IROperDoc =obj.IROperDoc.%Id()
			Set IROperDocDesc =obj.IROperDoc.BTDesc
		}
		if $Isobject(obj.IROperLoc)
		{
			Set IROperLoc =obj.IROperLoc.%Id()
			Set IROperLocDesc =obj.IROperLoc.BTDesc
		}
		Set IRIsInf = obj.IRIsInf
		Set IRIsInf = $s(IRIsInf="1":"是",1:"否")
		Set IRInfDate = obj.IRInfDate
		Set:IRInfDate'="" IRInfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRInfDate)
		if $Isobject(obj.IRInfSymptoms)
		{
			Set IRInfSymptoms =obj.IRInfSymptoms.%Id()
			Set IRInfSymptomsDesc =obj.IRInfSymptoms.BTDesc
		}
		
		Set UCCnt=UCCnt+1
		Set Data=$lb(IRUCTypeDesc,IRIntuDate,IRExtuDate,IROperDocDesc,IROperLocDesc,IRIsInf,IRInfDate,IRInfSymptomsDesc)
		Set ^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"UC",UCCnt)=Data
	}
	Set tmpMax=+$g(^TMP($zn,$j,"QryICURepInfo","UCMax"))
	If (UCCnt>tmpMax) {
		Set ^TMP($zn,$j,"QryICURepInfo","UCMax")=UCCnt
	}
	Quit
}

/// CreatDate：   2023-02-01
/// CreatUser:    zhoubo
/// Description:  查询ICU报告信息 EXCEL
/// Table：       DHCHAI.IR.INFReport
/// w ##Class(DHCHAI.IRS.ICURepExportSrv).PrintEHReport("fillxlSheet,MergCells,DeleteRows","","2023-03-08","2023-03-08")
ClassMethod PrintEHReport(itmjs As %String, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, LocID As %String = "") As %String
{
	new (itmjs,aHospIDs,aDateFrom,aDateTo,LocID)
	set return=0
	quit:(aDateFrom="")||(aDateTo="") return
 	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Kill ^TMP($zn,$j,"QryICURepInfo")
	set fillxlSheet=$p(itmjs,",",1)
	set mergCells=$p(itmjs,",",2)
	set deleteRows=$p(itmjs,",",3)
			
 	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCHAI.IR.INFReportI("IndexRepDate","3",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
				
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexRepDate","3",xDate,xRepID))
			Quit:xRepID=""
			
			Set ReportID=xRepID
			Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
			Continue:'$IsObject(objReport)
			If $IsObject(objReport.IRStatusDr) {
				Set ReportStatusID=objReport.IRStatusDr.%Id()
				Set ReportStatusCode=objReport.IRStatusDr.BTCode
				Set ReportStatusDesc=objReport.IRStatusDr.BTDesc
			}
			Set ReportLocDesc=""
			Set objRepLoc=objReport.IRRepLocDr
			If $IsObject(objRepLoc) {
				Set ReportLocID=objRepLoc.%Id()
				Set ReportLocDesc=objRepLoc.BTDesc2
				Set:ReportLocDesc="" ReportLocDesc=objRepLoc.BTDesc
				If $IsObject(objReport.IRRepLocDr.BTHospDr){
					Set HospID=objReport.IRRepLocDr.BTHospDr.%Id()			
					Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
				}
			}
			Set objPaadm=objReport.IREpisodeDr
			Continue:'$IsObject(objPaadm)
			Set EpisodeID = objPaadm.%Id()
			Set AdmitDate=objPaadm.PAAdmDate
			If (AdmitDate'="")
			{
				Set AdmitDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmitDate)
			}
			Set AdmitTime=objPaadm.PAAdmTime
			Set DischDate=objPaadm.PADischDate
			If (DischDate'="")
			{
				Set DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			}
			Set AdmLoc=objPaadm.PAAdmLocDr.BTDesc2
			Set AdmWard=objPaadm.PAAdmWardDr.BTDesc2
			Set (AdmBedDr,AdmBed)=""
			If $IsObject(objPaadm.PAAdmBedDr){
				Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
				Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
			}
			/// 基础数据
			Set PatientID=objPaadm.PAPatientIDx
			Set PapmiNo=objPaadm.PAPapmiNo
			Set PatName=objPaadm.PAPatName
			Set PatMrNo=objPaadm.PAMrNo
			Set PatAge=objPaadm.PAAge
			Set IsDeath = objPaadm.PAIsDeath
			Set IsDeath=$s(IsDeath="1":"是",1:"否")
			Set PADeathDate = objPaadm.PADeathDate
			Set:PADeathDate'="" PADeathDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PADeathDate)
			Set PADeathTime = objPaadm.PADeathTime
			Set:PADeathTime'="" PADeathTime=$zt(PADeathTime,1)
			Set PatSex=objPaadm.PASex
			Set PatSex=$s(PatSex="M":"男",PatSex="F":"女",1:"其他")
			//当前科室 
			Set (AdmLocID,AdmLocDesc,AdmWardID,AdmWardDesc)=""
			If $IsObject(objPaadm.PAAdmLocDr){
				Set AdmLocID = objPaadm.PAAdmLocDr.%Id()
				Set AdmLocDesc = objPaadm.PAAdmLocDr.BTDesc
				Set:$p(AdmLocDesc,"-",2)'="" AdmLocDesc=$p(AdmLocDesc,"-",2)
				Set AdmLocDesc2 = objPaadm.PAAdmLocDr.BTDesc2
				Set:AdmLocDesc2'="" AdmLocDesc=AdmLocDesc2
			}
			If $IsObject(objPaadm.PAAdmWardDr){
				Set AdmWardID = objPaadm.PAAdmWardDr.%Id()
				Set AdmWardDesc = objPaadm.PAAdmWardDr.BTDesc
				Set:$p(AdmWardDesc,"-",2)'="" AdmWardDesc=$p(AdmWardDesc,"-",2)
				Set AdmWardDesc2 = objPaadm.PAAdmWardDr.BTDesc2
				Set:AdmWardDesc2'="" AdmWardDesc=AdmWardDesc2
			}
			Continue:((LocID'="")&&(LocID'=AdmLocID)&&(LocID'=AdmWardID))
			Set PAAdmDate=AdmitDate
			Set PADischDate=DischDate
			
			Set APACHEScore = objReport.IRAPACHEScore
			Set RepDate = objReport.IRRepDate
			Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			
			Set HisEpisodeID = objPaadm.PAEpisodeIDx
			Set HisEpisodeID = $p(HisEpisodeID,"||",2)
			Set Data=$lb(PapmiNo,PatMrNo,PatName,PatAge,PatSex,AdmLocDesc,AdmWardDesc,PAAdmDate,PADischDate,APACHEScore,RepDate,ReportLocDesc)
			Set ^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"BASE")=Data	
			
			///  PICC数据
			Set PICCCnt=0
			Set xPICCID = ""
			For {
				Set xPICCID = $o(^DHCHAI.IR.INFICUPICCI("IdxofIREpisodeDr",EpisodeID,xPICCID))
				Quit:xPICCID=""
				
				Set obj = ##class(DHCHAI.IR.INFICUPICC).GetObjById(xPICCID)
				Continue:'$Isobject(obj)
				Set IRIntuDate = obj.IRIntuDate
				Set:IRIntuDate'="" IRIntuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRIntuDate)
				Set IRExtuDate = obj.IRExtuDate
				Set:IRExtuDate'="" IRExtuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRExtuDate)
				//导管类型 导管腔数 置管部位 ...
				Set (IRPICCType,IRPICCTypeDesc,IRPICCCnt,IRPICCCntDesc)=""
				Set (IRPICCPos,IRPICCPosDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc)=""
				if $Isobject(obj.IRPICCType)
				{
					Set IRPICCType =obj.IRPICCType.%Id()
					Set IRPICCTypeDesc =obj.IRPICCType.BTDesc
				}
				if $Isobject(obj.IRPICCCnt)
				{
					Set IRPICCCnt =obj.IRPICCCnt.%Id()
					Set IRPICCCntDesc =obj.IRPICCCnt.BTDesc
				}
				if $Isobject(obj.IRPICCPos)
				{
					Set IRPICCPos =obj.IRPICCPos.%Id()
					Set IRPICCPosDesc =obj.IRPICCPos.BTDesc
				}
				if $Isobject(obj.IROperDoc)
				{
					Set IROperDoc =obj.IROperDoc.%Id()
					Set IROperDocDesc =obj.IROperDoc.BTDesc
				}
				if $Isobject(obj.IROperLoc)
				{
					Set IROperLoc =obj.IROperLoc.%Id()
					Set IROperLocDesc =obj.IROperLoc.BTDesc
				}
				Set IRIsInf = obj.IRIsInf
				Set IRIsInf = $s(IRIsInf="1":"是",1:"否")
				Set IRInfDate = obj.IRInfDate
				Set:IRInfDate'="" IRInfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRInfDate)
				if $Isobject(obj.IRInfSymptoms)
				{
					Set IRInfSymptoms =obj.IRInfSymptoms.%Id()
					Set IRInfSymptomsDesc =obj.IRInfSymptoms.BTDesc
				}
				Set (BacteriaID,BacteriaDesc)=""
				if $Isobject(obj.IRBacteria)
				{
					Set BacteriaID =obj.IRBacteria.%Id()
					Set BacteriaDesc =obj.IRBacteria.BTBacDesc
				}
				
				Set PICCCnt=PICCCnt+1
				Set Data=$lb(IRPICCTypeDesc,IRPICCCntDesc,IRPICCPosDesc,IRIntuDate,IRExtuDate,IROperDocDesc,IROperLocDesc,IRIsInf,IRInfDate,IRInfSymptomsDesc)
				Set ^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"PICC",PICCCnt)=Data
			}
			Set tmpMax=+$g(^TMP($zn,$j,"QryICURepInfo","PICCMax"))
			If (PICCCnt>tmpMax) {
				Set ^TMP($zn,$j,"QryICURepInfo","PICCMax")=PICCCnt
			}
			/// 呼吸机数据
			Set VAPCnt=0
			Set xVAPID = ""
			For {
				Set xVAPID = $o(^DHCHAI.IR.INFICUVAPI("IdxofIREpisodeDr",EpisodeID,xVAPID))
				Quit:xVAPID=""
				
				Set obj = ##class(DHCHAI.IR.INFICUVAP).GetObjById(xVAPID)
				Continue:'$Isobject(obj)
				Set IRIntuDate = obj.IRIntuDate
				Set:IRIntuDate'="" IRIntuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRIntuDate)
				Set IRExtuDate = obj.IRExtuDate
				Set:IRExtuDate'="" IRExtuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRExtuDate)
				//置管人员 ...
				Set (IRVAPType,IRVAPTypeDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc)=""
				
				if $Isobject(obj.IRVAPType)
				{
					Set IRVAPType =obj.IRVAPType.%Id()
					Set IRVAPTypeDesc =obj.IRVAPType.BTDesc
				}
				if $Isobject(obj.IROperDoc)
				{
					Set IROperDoc =obj.IROperDoc.%Id()
					Set IROperDocDesc =obj.IROperDoc.BTDesc
				}
				if $Isobject(obj.IROperLoc)
				{
					Set IROperLoc =obj.IROperLoc.%Id()
					Set IROperLocDesc =obj.IROperLoc.BTDesc
				}
				Set IRIsInf = obj.IRIsInf
				Set IRIsInf = $s(IRIsInf="1":"是",1:"否")
				Set IRInfDate = obj.IRInfDate
				Set:IRInfDate'="" IRInfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRInfDate)
				if $Isobject(obj.IRInfSymptoms)
				{
					Set IRInfSymptoms =obj.IRInfSymptoms.%Id()
					Set IRInfSymptomsDesc =obj.IRInfSymptoms.BTDesc
				}
				
				Set VAPCnt=VAPCnt+1
				Set Data=$lb(IRVAPTypeDesc,IRIntuDate,IRExtuDate,IROperDocDesc,IROperLocDesc,IRIsInf,IRInfDate,IRInfSymptomsDesc)
				Set ^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"VAP",VAPCnt)=Data
			}
			
			Set tmpMax=+$g(^TMP($zn,$j,"QryICURepInfo","VAPMax"))
			If (VAPCnt>tmpMax){
				Set ^TMP($zn,$j,"QryICURepInfo","VAPMax")=VAPCnt
			}
			
			/// 导尿管数据
			Set UCCnt=0
			Set xUCID = ""
			For {
				Set xUCID = $o(^DHCHAI.IR.INFICUUCI("IdxofIREpisodeDr",EpisodeID,xUCID))
				Quit:xUCID=""
				
				Set obj = ##class(DHCHAI.IR.INFICUUC).GetObjById(xUCID)
				Continue:'$Isobject(obj)
				Set IRIntuDate = obj.IRIntuDate
				Set:IRIntuDate'="" IRIntuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRIntuDate)
				Set IRExtuDate = obj.IRExtuDate
				Set:IRExtuDate'="" IRExtuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRExtuDate)
				//置管人员 ...
				Set (IRUCType,IRUCTypeDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc,IsCheck)=""
				
				if $Isobject(obj.IRUCType)
				{
					Set IRUCType =obj.IRUCType.%Id()
					Set IRUCTypeDesc =obj.IRUCType.BTDesc
				}
				if $Isobject(obj.IROperDoc)
				{
					Set IROperDoc =obj.IROperDoc.%Id()
					Set IROperDocDesc =obj.IROperDoc.BTDesc
				}
				if $Isobject(obj.IROperLoc)
				{
					Set IROperLoc =obj.IROperLoc.%Id()
					Set IROperLocDesc =obj.IROperLoc.BTDesc
				}
				Set IRIsInf = obj.IRIsInf
				Set IRIsInf = $s(IRIsInf="1":"是",1:"否")
				Set IRInfDate = obj.IRInfDate
				Set:IRInfDate'="" IRInfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRInfDate)
				if $Isobject(obj.IRInfSymptoms)
				{
					Set IRInfSymptoms =obj.IRInfSymptoms.%Id()
					Set IRInfSymptomsDesc =obj.IRInfSymptoms.BTDesc
				}
				
				Set UCCnt=UCCnt+1
				Set Data=$lb(IRUCTypeDesc,IRIntuDate,IRExtuDate,IROperDocDesc,IROperLocDesc,IRIsInf,IRInfDate,IRInfSymptomsDesc)
				Set ^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"UC",UCCnt)=Data
			}
			Set tmpMax=+$g(^TMP($zn,$j,"QryICURepInfo","UCMax"))
			If (UCCnt>tmpMax) {
				Set ^TMP($zn,$j,"QryICURepInfo","UCMax")=UCCnt
			}
		}
	}
	// 输出表头
	Set Row=1
	set retval=fillxlSheet_"(xlSheet,'"_"登记号"_"',"_Row_","_1_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"病案号"_"',"_Row_","_2_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"姓名"_"',"_Row_","_3_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"年龄"_"',"_Row_","_4_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"性别"_"',"_Row_","_5_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"就诊科室"_"',"_Row_","_6_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"就诊病区"_"',"_Row_","_7_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"入科日期"_"',"_Row_","_8_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"出科日期"_"',"_Row_","_9_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"APACH评分"_"',"_Row_","_10_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"报告日期"_"',"_Row_","_11_");"
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_"填报科室"_"',"_Row_","_12_");"
	&javascript<#(retval)#>
			
	Set BaseCnt=12
	// PICC表头
	Set PICCMax=+$g(^TMP($zn,$j,"QryICURepInfo","PICCMax"))
	Set PICCCnt=PICCMax*10
	Set Col=BaseCnt
	For indx=1:1:PICCMax{
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"PICC导管类型"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"导管腔数"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"置管部位"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"置管日期"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"拔管日期"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"置管人员"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"置管地点"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"是否感染"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"感染日期"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"感染症状"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
	}
	// VAP表头
	Set VAPMax=+$g(^TMP($zn,$j,"QryICURepInfo","VAPMax"))
	Set VAPCnt=VAPMax*8
	Set Col=BaseCnt+PICCCnt
	For indx=1:1:VAPMax{
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"VAP气道类型"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"上机时间"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"脱机时间"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1		
		set retval=fillxlSheet_"(xlSheet,'"_"置管人员"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"置管地点"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"是否感染"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"感染日期"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"感染症状"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
	}
	// UC表头
	Set UCMax=+$g(^TMP($zn,$j,"QryICURepInfo","UCMax"))
	Set UCCnt=UCMax*8
	Set Col=BaseCnt+PICCCnt+VAPCnt
	For indx=1:1:UCMax{
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"UC尿管类型"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"插管时间"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"拔管时间"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"置管人员"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"置管地点"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"是否感染"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"感染日期"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
		Set Col=Col+1
		set retval=fillxlSheet_"(xlSheet,'"_"感染症状"_indx_"',"_Row_","_Col_");"
		&javascript<#(retval)#>
	}
	
	Set Row=2,Col=1
	/// 组织输出
	Set xRepID=""
	For {
		Set xRepID = $o(^TMP($zn,$j,"QryICURepInfo","Rep",xRepID))
		Quit:xRepID=""
		Set ReportID = xRepID 
		 
		Set DataBase = $g(^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"BASE"))	
		Continue:DataBase=""
		//输出基本信息
		//
		Set BaseCnt=$ll(DataBase)
		For indx=1:1:$ll(DataBase) {
			Set data=$lg(DataBase,indx)
			set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(data,"O","JS")_"',"_Row_","_Col_");"
			&javascript<#(retval)#>
			Set Col=Col+1
		}
		
		Set PICCMax=+$g(^TMP($zn,$j,"QryICURepInfo","PICCMax"))
		Set PICCCnt=PICCMax*10
		For indx=1:1:PICCMax{
			Set tmpDataPICC = $g(^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"PICC",indx))
			If (tmpDataPICC'=""){ // 10个字段
				//输出PICC
				For indxx=1:1:$ll(tmpDataPICC) {
					Set data=$lg(tmpDataPICC,indxx)
					set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(data,"O","JS")_"',"_Row_","_Col_");"
					&javascript<#(retval)#>
					Set Col=Col+1
				}
			}
		}
		Set VAPMax=+$g(^TMP($zn,$j,"QryICURepInfo","VAPMax"))
		Set Col=BaseCnt+PICCCnt+1
		Set VAPCnt=VAPMax*8
		For indx=1:1:VAPMax{
			Set tmpDataVAP = $g(^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"VAP",indx))
			If (tmpDataVAP'=""){ // 8个字段
				//输出PICC
				For indxx=1:1:$ll(tmpDataVAP) {
					Set data=$lg(tmpDataVAP,indxx)
					set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(data,"O","JS")_"',"_Row_","_Col_");"
					&javascript<#(retval)#>
					Set Col=Col+1
				}
			}
		}
		Set UCMax=+$g(^TMP($zn,$j,"QryICURepInfo","UCMax"))
		Set Col=BaseCnt+PICCCnt+VAPCnt+1
		Set UCCnt=UCMax*8
		For indx=1:1:UCMax{
			Set tmpDataUC = $g(^TMP($zn,$j,"QryICURepInfo","Rep",ReportID,"UC",indx))
			If (tmpDataUC'=""){ // 8个字段
				//输出PICC
				For indxx=1:1:$ll(tmpDataUC) {
					Set data=$lg(tmpDataUC,indxx)
					set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(data,"O","JS")_"',"_Row_","_Col_");"
					&javascript<#(retval)#>
					Set Col=Col+1
				}
			}
		}
		
		Set Row=Row+1
		Set Col=1
	}
	Kill ^TMP($zn,$j,"QryICURepInfo")
	Quit "2"
}

/// w ##class(DHCHAI.IRS.ICURepExportSrv).GetTempDir()
ClassMethod GetTempDir() As %String
{
	New
	Set $zt="GetTempDirError"
	Set version=$ZVERSION
	If version["Windows" {
		//Set tmp="C:\InterSystems\Cache\mgr\Temp\"
		Set tempChild=##class(%File).TempFilename()
		Set temp=##class(%File).ParentDirectoryName(tempChild)
		Set:(tempChild'="")&&(temp="")&&(tempChild["\") temp=$e(tempChild,1,$l(tempChild)-$l($p(tempChild,"\",$l(tempChild,"\"))))
	} Else {
		Set temp="/tmp/excel/"
	}
	Set path=..SetPathOS(temp)
	Quit $p(path,"||")
	
GetTempDirError
	Set version=$ZVERSION
	If version["Windows" {
		Set temp="c:\tmp\excel\"
	} Else {
		Set temp="/tmp/excel/"
	}
	Set path=..SetPathOS(temp)
	Quit $p(path,"||")
}

/// w ##class(MA.IPMR.SSService.ExcelSrv).SetPathOS("D:\hello\test\a")
ClassMethod SetPathOS(name... As %List) As %String
{
	n (name)
	s deli="/"
	s version=$ZVERSION
	s path=""
	i version ["Windows" {
		s deli="\"
	}
	s len=$get(name,0)
	f i=1:1:len-1  {
		s:name(i)'[deli path=path_$get(name(i))_deli
	}
	s path=path_$get(name(len))
	i deli="/" d
	.s wrong="\"
	e  d
	.s wrong="/"
	s path2=""
	f i=1:1:$l(path) d
	.i $e(path,i)=wrong  s path2=path2_deli
	.e  s path2=path2_$e(path,i)
	i $p(path2,deli,$l(path2,deli)) ["." d ;若路径中最后一个为文件，则创建该文件。
	.s len=$l(path2,deli)
	.s path=$p(path2,deli,0,len-1),fileName=$p(path2,deli,len)
	e  d
	.s path=path2
	i '##class(%File).Exists(path) d
	.d ##class(%File).CreateDirectoryChain(path)
	i ($g(fileName)'="") d
	.if '(##class(%File).Exists(path_deli_fileName)) d
	..s file=##class(%File).%New(path_deli_fileName)
	..d file.Open("WN")
	..d file.Close()
	.s path=path_deli_fileName
	q path_"||"_deli
}

}
