/// Creator:wangCS
/// CreateDate:2011-07-25
/// Description：死亡报告
Class DHCMed.DTHService.ReportSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:    wangCS
/// CreateDate: 2011-07-27
/// Description:更改报告的状态
/// Input:      instr:   1 reportRowId:报告RowId；2 status:报告的状态；3 userId:用户ID；4 resumeText
///            separate:分割符
/// Output:     成功返回1，失败返回小于0的数字
/// w ##class(DHCMed.DTHService.ReportSrv).ChangeStatus("1^","^")
ClassMethod ChangeStatus(instr, separate) As %String
{
	if ($g(separate)="")
	{
		set separate="^"
	}
	set reportRowId=$p($g(instr),separate,1)
	set status=$p($g(instr),separate,2)
	set userId=$p($g(instr),separate,3)
	set resumeText=$p($g(instr),separate,4)
	set ret=-1
	q:(reportRowId="") ret
	
	set obj=##Class(DHCMed.DTH.Report).GetObjById(+reportRowId)
	if ($IsObject(obj)) {
		set dicId=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(status,"DTHRunningState")
		set obj.RepStatusDR=##Class(DHCMed.SS.Dictionary).%OpenId(+dicId)
		set rpStatusObj=##Class(DHCMed.DTH.ReportStatus).%New()
		set rpStatusObj.StatusDR=##Class(DHCMed.SS.Dictionary).%OpenId(+dicId)
		set currDate=+$h
		set currTime=+$p($h,",",2)
		set rpStatusObj.OpeDate=currDate
		set rpStatusObj.OpeTime=currTime
		set rpStatusObj.OpeUserDR=userId
		set rpStatusObj.ResumeText=resumeText
		set rpStatusObj.ParRef=obj
		
		// 同步更新子表报告状态
		if ($d(^DHCMed.DTHi("ChildREP","IndexDthReportID"," "_reportRowId))){
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.DTHi("ChildREP","IndexDthReportID"," "_reportRowId,xRepID))
				Quit:xRepID=""
				Set Childobj=##class(DHCMed.DTH.ChildReport).%OpenId(xRepID)
				Set Childobj.RepStatusDR = ##Class(DHCMed.SS.Dictionary).%OpenId(+dicId)
				set xxret=Childobj.%Save()
			}
		}
		if ($d(^DHCMed.DTH("MaterREP","IndexDthReportID"," "_reportRowId))){
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.DTHi("ChildREP","IndexDthReportID"," "_reportRowId,xRepID))
				Quit:xRepID=""
				Set Momobj=##class(DHCMed.DTH.MaternalReport).%OpenId(xRepID)
				Set Momobj.RepStatusDR = ##Class(DHCMed.SS.Dictionary).%OpenId(+dicId)
				set xxret=Childobj.%Save()
			}
		}
		set retValue=obj.%Save()
		if ($system.Status.IsError(retValue))
		{
			do $system.OBJ.DisplayError(retValue)
		}
		else
		{
			set ret=1
		}
		do obj.%Close()
		do rpStatusObj.%Close()
	}
	quit ret
}

/// Creator     : zhufei
/// CreateDate  : 2014-04-01
/// Description : 根据报告ID取值死亡证明信息
/// w ##Class(DHCMed.DTHService.ReportSrv).GetDataByReportId("1")
ClassMethod GetDataByReportId(aReportID As %String) As %String
{
	new (aReportID,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	quit:aReportID="" return
	
	set objRep=##Class(DHCMed.DTH.Report).GetObjById(aReportID)
	quit:'$IsObject(objRep) return
	
	set ReportID=objRep.%Id()
	set PatientID=objRep.PatientID   
	set EpisodeID=objRep.EpisodeID
	
	set RepNo=objRep.RepNo
	set DeathNo=objRep.DeathNo   //网号
	set PapmiNo=objRep.PapmiNo   
	set MrNo=objRep.MrNo     //住院号
	set PatName=objRep.Name  //姓名
	set Sex=objRep.Sex   //性别
	set Age=objRep.Age  //年龄
	set Nation=objRep.Nation  //民族
	
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",4)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
		
	set CardType=""
	if $IsObject(objRep.CardTypeDR) {
		set CardType=objRep.CardTypeDR.Description
	}
	set Identify=objRep.Identify
	set Occupation=""
	if $IsObject(objRep.Occupation) {
		set Occupation=objRep.Occupation.Description  
	}
	set RegAddress=objRep.RegAddress  //户籍地址
	set CurrAddress=objRep.CurrAddress  //生前住址
	
	set DeathDate=objRep.DeathDate   //死亡日期
	set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
	set DeathTime=objRep.DeathTime  //死亡时间
	set:DeathTime'="" DeathTime=$zt(DeathTime,1)
	set DeathDateTime=DeathDate_" "_DeathTime  //死亡日期时间
	set AReason=objRep.AReason   //直接死因
	set BaseReason=objRep.BaseReason  //根本死因
	// 如果根本死因为空则以dcba顺序取诊断
	if (BaseReason=""){  
		if (objRep.DReason'=""){
			set BaseReason=objRep.DReason
		}elseif (objRep.CReason'=""){
			set BaseReason=objRep.CReason
		}elseif(objRep.BReason'=""){
			set BaseReason=objRep.BReason
		}elseif(AReason'=""){
			set BaseReason=AReason
		}
	}  
	set RepUserID=objRep.RepUsrDR,RepUserDesc=""
	set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+RepUserID)
	if $IsObject(objUser) {
		set RepUserDesc=objUser.Name   //上报医生
		Set RepUserDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,RepUserDesc)
	}
	set RepLocID=objRep.RepLocDR,RepLocDesc=""
	set objLoc=##Class(DHCMed.Base.Ctloc).GetObjById(+RepLocID)
	if $IsObject(objLoc) {
		set RepLocDesc=objLoc.Descs  //上报科室
		Set RepLocDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,RepLocDesc)
	}
	set FamName=objRep.FamName  //家属姓名
	set FamTel=objRep.FamTel  //家属联系电话
	set RepDate=objRep.RepDate  //填卡日期
	set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	set RepTime=objRep.RepTime
	set:RepTime'="" RepTime=$zt(RepTime,1)
	set RepDateTime=RepDate_" "_RepTime
	set BackReason=""
	set CheckTwoDate=""
	set RepStatusCode="",RepStatusDesc=""
	if $IsObject(objRep.RepStatusDR) {
		set RepStatusID=objRep.RepStatusDR.%Id()
		set RepStatusCode=objRep.RepStatusDR.Code
		if (RepStatusCode=3) {
			set xSubID=""
			for {
				set xSubID=$o(^DHCMed.DTH("REP",ReportID,"Status",xSubID),-1)
				quit:xSubID=""
				quit:BackReason'=""
				set objSub=##Class(DHCMed.DTH.ReportStatus).GetObjById(ReportID_"||"_xSubID)
				continue:'$IsObject(objSub)
				if objSub.StatusDR.Code=3
				set CheckTwoDate = objSub.OpeDate
			}
			set:CheckTwoDate'="" CheckTwoDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckTwoDate)
		}
		set RepStatusDesc=objRep.RepStatusDR.Description
		set RepStatusDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,RepStatusDesc)
		if RepStatusCode="9" {
			set xSubID=""
			for {
				set xSubID=$o(^DHCMed.DTH("REP",ReportID,"Status",xSubID),-1)
				quit:xSubID=""
				quit:BackReason'=""
				set objSub=##Class(DHCMed.DTH.ReportStatus).GetObjById(ReportID_"||"_xSubID)
				continue:'$IsObject(objSub)
				set BackReason=objSub.ResumeText
			}
		}
	}
	set PrintReason=""
	set xSubID=""
	for { 
		set xSubID=$o(^DHCMed.DTH("REP",ReportID,"ChildPrintStatus",xSubID),-1)
		quit:xSubID=""
		quit:PrintReason'=""
		set objSub=##Class(DHCMed.DTH.PrintStatus).GetObjById(ReportID_"||"_xSubID)
		continue:'$IsObject(objSub)
		set PrintReason=objSub.ResumeText
	}
	set Data=$lb(ReportID,PatientID,EpisodeID,RepNo,DeathNo,PapmiNo,MrNo,PatName,Sex,Age,Nation,CardType,Identify,Occupation,RegAddress,CurrAddress,DeathDate,DeathTime,DeathDateTime,AReason,BaseReason,RepUserDesc,RepLocDesc,FamName,FamTel,RepDate,RepTime,RepDateTime,BackReason,CheckTwoDate,RepStatusCode,RepStatusDesc,PrintReason,EncryptLevel,PatLevel)
	quit Data
}

/// Creator     : wangCS
/// CreateDate  : 2011-07-26
/// Description : 根据条件查询死亡报告信息
/// Input       : 开始日期和结束日期【报告日期】、报告科室、医院、报告状态、姓名、登记号、病案号
/// d ##Class(%ResultSet).RunQuery("DHCMed.DTHService.ReportSrv","QryReportInfo","2014-01-01","2014-04-02","","","","张翰","","")
Query QryReportInfo(aSttDate As %String, aEndDate As %String, aRepLoc As %String, aHospital As %String, aRepStatus As %String, aPatName As %String, aMrNo As %String, aRegNo As %String) As %Query(ROWSPEC = "RowID:%String,PatientID:%String,EpisodeID:%String,RepNo:%String,DeathNo:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,Nation:%String,CardType:%String,Identify:%String,Occupation:%String,RegAddress:%String,CurrAddress:%String,DeathDate:%String,DeathTime:%String,DeathDateTime:%String,AReason:%String,BaseReason:%String,RepUser:%String,RepLoc:%String,FamName:%String,FamTel:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,BackReason:%String,CheckTwoDate:%String,RepStatusCode:%String,RepStatusDesc:%String,PrintReason:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QryReportInfoExecute(ByRef qHandle As %Binary, aSttDate As %String, aEndDate As %String, aRepLoc As %String, aHospital As %String, aRepStatus As %String, aPatName As %String, aMrNo As %String, aRegNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Set aSttDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aSttDate)
	Set aEndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aEndDate)
	set:aSttDate="" aSttDate=+aSttDate
	set:aEndDate="" aEndDate=+aEndDate
	quit:(aSttDate="")||(aEndDate="") $$$OK
	
	set xDate=aSttDate-1
	for {
		set xDate=$o(^DHCMed.DTHi("REP","IndexDate",xDate))
		quit:xDate=""
		quit:xDate>aEndDate
		
		set xReportID=0
		for {
			set xReportID=$o(^DHCMed.DTHi("REP","IndexDate",xDate,xReportID))
			quit:xReportID=""
			
			set objReport=##Class(DHCMed.DTH.Report).GetObjById(xReportID)
			continue:'$IsObject(objReport)
			continue:'$IsObject(objReport.RepStatusDR)
			set RepStatus=objReport.RepStatusDR.%Id()
			continue:RepStatus=""
			continue:(aRepStatus'="")&&(aRepStatus'=RepStatus)
			set RepLoc=objReport.RepLocDR
			continue:RepLoc=""
			if aRepLoc'="" {
				continue:RepLoc'=aRepLoc
			} else {
				if aHospital'="" {
					set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(RepLoc,aHospital)
					continue:flg<1
				}
			}
			set PapmiNo=objReport.PapmiNo
			continue:(aRegNo'="")&&(aRegNo'=PapmiNo)
			set MrNo=objReport.MrNo
			continue:(aMrNo'="")&&(aMrNo'=MrNo)
			set PatName=objReport.Name
			continue:(aPatName'="")&&(PatName'[aPatName)
			
			set Data=..GetDataByReportId(xReportID)
			continue:Data=""
			set ^CacheTemp(repid,ind)=Data
			set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryReportInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(DHCMed.DTHService.ReportSrv).QryReportInfoToPrint("fillxlSheet","2014-01-01^2014-08-01")
ClassMethod QryReportInfoToPrint(itmjs As %String, ArgStr As %String) As %String
{
	n (itmjs,ArgStr)
	s Count=0
	s startDate=$p(ArgStr,"^",1)
	s endDate=$p(ArgStr,"^",2)
	s loc=$p(ArgStr,"^",3)
	s hosp=$p(ArgStr,"^",4)
	s status=$p(ArgStr,"^",5)
	s PatName=$p(ArgStr,"^",6)
	s MrNo=$p(ArgStr,"^",7)
	s RegNo=$p(ArgStr,"^",8)
	s ds = ##class(%Library.ResultSet).%New("DHCMed.DTHService.ReportSrv:QryReportInfo")
	d ds.Execute(startDate,endDate,loc,hosp,status,PatName,MrNo,RegNo)
	
	s ReportID=""
	
	s StartRow=3
	while(ds.Next())
	{
		s ReportID = ds.Data("RowID")
		s PatientID = ds.Data("PatientID")
		s EpisodeID=ds.Data("EpisodeID")
		s RepNo=ds.Data("RepNo")
		s DeathNo=ds.Data("DeathNo")
		s PapmiNo=ds.Data("PapmiNo")
		s MrNo=ds.Data("MrNo")		
		s PatName=ds.Data("PatName")
		s Sex=ds.Data("Sex")
		s Age=ds.Data("Age")
		s Nation=ds.Data("Nation")
		s CardType=ds.Data("CardType")
		s Identify=ds.Data("Identify")
		s Occupation=ds.Data("Occupation")
		s RegAddress=ds.Data("RegAddress")
		s CurrAddress=ds.Data("CurrAddress")		
		s DeathDateTime=ds.Data("DeathDateTime")
		s DeathDate=ds.Data("DeathDate")
		s DeathTime=ds.Data("DeathTime")
		s AReason=ds.Data("AReason")
		s BaseReason=ds.Data("BaseReason")
		s RepUserDesc=ds.Data("RepUser")
		s RepLocDesc=ds.Data("RepLoc")
		s FamName=ds.Data("FamName")
		s FamTel=ds.Data("FamTel")
		s RepDateTime=ds.Data("RepDateTime")
		s RepDate=ds.Data("RepDate")
		s RepTime=ds.Data("RepTime")
		s RepLoc=ds.Data("RepLoc")
		s BackReason=ds.Data("BackReason")
		s CheckTwoDate=ds.Data("CheckTwoDate")		
		s RepStatusCode=ds.Data("RepStatusCode")
		s PrintReason=ds.Data("PrintReason")
		s RepStatusDesc=ds.Data("RepStatusDesc")
		s CheckTwoDate = ""
		//友谊
		s str=DeathNo_$c(1)_RepStatusDesc_$c(1)_PatName_$c(1)_Sex_$c(1)_Age_$c(1)_Occupation_$c(1)_BaseReason_$c(1)_CurrAddress_$c(1)_DeathDate_$c(1)_RepDate_$c(1)_RepLoc
		//山东潍坊
		// s str=DeathNo_$c(1)_PatName_$c(1)_Sex_$c(1)_Age_$c(1)_Nation_$c(1)_RegAddress_$c(1)_CurrAddress_$c(1)_DeathDateTime_$c(1)_BaseReason_$c(1)_RepLocDesc_$c(1)_CheckTwoDate_$c(1)_RepUserDesc_$c(1)_FamName_$c(1)_FamTel_$c(1)_MrNo
		s retval=itmjs_"(xlSheet,'"_$ZCVT(str,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		s StartRow=StartRow+1
	}
	
	if ReportID'="" {
		set return=1
		set objReport=##class(DHCMed.DTH.Report).GetObjById(ReportID)
		quit:'$IsObject(objReport) return
		set EpisodeID=objReport.EpisodeID
		quit:EpisodeID="" return
		set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
		quit:AdmLoc="" return
		set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
		quit:CTHospID="" return
		set objSSHosp=##class(DHCMed.SSService.HospitalSrv).GetObjSSHosp(CTHospID,"DTH")
		quit:'$IsObject(objSSHosp) return
		Set SSHospDesc=objSSHosp.HospDesc
		
		s retval=itmjs_"(xlSheet,'"_$ZCVT(SSHospDesc_"死亡病例网络直报日登记"_$zd($h,3),"O","JS")_"',"_1_",1);"
		&javascript<#(retval)#>
	} else {
		s retval=itmjs_"(xlSheet,'"_$ZCVT("XXX死亡病例网络直报日登记"_$zd($h,3),"O","JS")_"',"_1_",1);"
		&javascript<#(retval)#>
	}
	
	d ds.Close()
	
	q 1
}

/// Creator:wangCS
/// CreateDate:2011-08-01
/// Description:返回导出需要的数据
/// Input：reportId
/// Output:
/// d ##Class(%ResultSet).RunQuery("DHCMed.DTHService.ReportSrv","DMReportPrint",1)
Query DMReportPrint(reportId As %String = "") As %Query(ROWSPEC = "reportId:%String,PaperNo:%String,PapmiNo:%String,MrNo:%String,Name:%String,Sex:%String,Country:%String,Nation:%String,Pregnancies:%String,Occupation:%String,Identify:%String,RegAddress:%String,CurrAddress:%String,Marital:%String,Education:%String,Company:%String,Birthday:%String,DeathDateTime:%String,Age:%String,DeathPlace:%String,FamName:%String,FamTel:%String,FamAddr:%String,AReason:%String,AInterval:%String,BReason:%String,BInterval:%String,CReason:%String,CInterval:%String,DReason:%String,DInterval:%String,OtherDiagnose:%String,OtherDiagnoseICD:%String,OtherDiagnoseFP:%String,OtherDiagnoseFPICD:%String,OtherDiagnoseInterval:%String,DiagnoseUnit:%String,DiagnoseBasis:%String,BaseReason:%String,BaseReasonICD:%String,DamageReason:%String,DamageReasonICD:%String,ResumeText:%String,RepDate:%String,ExamMedical:%String,ExamName:%String,ExamAddress:%String,ExamTel:%String,ExamDeathReason:%String,examUserName:%String,ExamRelation:%String,ExamDate:%String,DeathNo:%String,MEPDCountyCode:%String,CardType:%String,MEPDProvince:%String,MEPDCity:%String,MEPDCounty:%String,MEPDVillage:%String,RegProvince:%String,RegCity:%String,RegCounty:%String,RegVillage:%String,RegRoad:%String,CurrRoad:%String,FamIdentify:%String,RepDocName:%String,AFPReason:%String,AFPReasonICD:%String,BFPReason:%String,BFPReasonICD:%String,CFPReason:%String,CFPReasonICD:%String,DFPReason:%String,DFPReasonICD:%String,CardType:%String") [ SqlProc ]
{
}

ClassMethod DMReportPrintExecute(ByRef qHandle As %Binary, reportId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	set separate="^"
	
	set mainReportStr=##Class(DHCMed.DTH.Report).GetStringById(+reportId)
	q:mainReportStr="" $$$OK
	
	set obj=##class(DHCMed.DTH.Report).GetObjById(+reportId)
	quit:'$IsObject(obj) $$$OK
	s PaperNo=##Class(DHCMed.DTHService.PaperNoSrv).GetPaperNo(reportId)
	set repLocDR=obj.RepLocDR
	set HospitalID=$p($g(^CTLOC(repLocDR)),"^",22)
	set PatientID=obj.PatientID
	set PatStr=##class(DHCMed.Base.Patient).GetStringById(PatientID)
	//西院行政区划代码：110102 东院行政区划代码：110101  不是集团化医院 else
	set MEPDCountyCode = ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-CountyCode",HospitalID)
	//为0：基本信息以病人基本信息为准     为1：基本信息以报告为准
	set dataRes = ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-IsUpdatePatientInfo",HospitalID)
	set MrNo=""
	if (dataRes =0) {  //modify by pylian 2015-06-16 与上面的描述相反
		set PapmiNo=$p(PatStr,"^",2)	// 登记号
		set MrNo=$p(PatStr,"^",23)		// 病案号
		set Name=$p(PatStr,"^",3)	    // 姓名
		set Sex=$p(PatStr,"^",4)	    // 性别
		set Nation=$p(PatStr,"^",13)	// 民族
		set Identify=$p(PatStr,"^",9)   // 身份证号
		set Birthday=$p(PatStr,"^",5)   //出生日期
		set Birthday=$p(Birthday,"-",1)_"年"_$p(Birthday,"-",2)_"月"_$p(Birthday,"-",3)_"日"
		set AgeYear=$p(PatStr,"^",6)        //实足年龄
		set AgeMonth=$p(PatStr,"^",7)       //年龄月
		set AgeDay=$p(PatStr,"^",8)         //年龄天
		Set Age=""                           //年龄
		If (AgeYear>0) {
			Set Age=Age_AgeYear_"岁"
		} ElseIf (AgeMonth>0) {
			Set Age=Age_AgeMonth_"月"
		} ElseIf (AgeDay>0) {
			Set Age=Age_AgeDay_"天"
		}
		set Country=$p(PatStr,"^",22)   //国家
		Set CardType=$p(PatStr,"^",25)	//证件类型
	} else {
		set PapmiNo=$p($g(mainReportStr),separate,2) //打印时登记号从报告抓取
		Set MrNo=$p($g(mainReportStr),separate,3)    // 打印时病案号从报告抓取
		Set Name=$p($g(mainReportStr),separate,4)    // 打印时姓名从报告抓取
		set Sex=$p($g(mainReportStr),separate,5)     // 打印时性别从报告抓取             
		set Nation=$p($g(mainReportStr),separate,10)  // 打印时民族从报告抓取
		Set Identify=$p($g(mainReportStr),separate,6)   // 打印时身份证号从报告抓取
		set Birthday=$p($g(mainReportStr),separate,7)  //打印时出生日期从报告抓取
		set Birthday=$zd(##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Birthday),3)
		set Birthday=$p(Birthday,"-",1)_"年"_$p(Birthday,"-",2)_"月"_$p(Birthday,"-",3)_"日"
		set Age=$p($g(mainReportStr),separate,8)  //打印时实足年龄从报告抓取
		set Country=$p($g(mainReportStr),separate,9) // 打印时国家从报告抓取
		Set CardType=..GetStringDesc($p($g(mainReportStr),separate,64))	//打印时证件类型从报告抓取
	}
	Set:Identify="" Identify = $p($g(mainReportStr),separate,6) // HIS的证件号为空，取报告中的值
	set pre=$p($g(mainReportStr),separate,16)     // 打印时孕检从报告抓取
	if (Sex="女"){
		set Pregnancies=$p(pre,$c(1),2)
	}    // 孕检
	else{set Pregnancies=""}
	set cccupa=..GetStringDesc($p($g(mainReportStr),separate,13))    // 打印时职业从报告抓取
	set Occupation=cccupa
	
	set RegAddress=$p($g(mainReportStr),separate,17)             // 户口所在地
	set CurrAddress=$p($g(mainReportStr),separate,18)            //生前常住地
	set matri=..GetStringDesc($p($g(mainReportStr),separate,11))  //婚姻
	set Marital=matri
	set educ=..GetStringDesc($p($g(mainReportStr),separate,12))  
	set Education=educ        //文化程度
	set Company=$p($g(mainReportStr),separate,15)  //生前工作单位
	
	set deathDate=$p($g(mainReportStr),separate,24)              
	set deathTime=$p($g(mainReportStr),separate,25)
	set DeathDateTime=$zd(##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(deathDate),3) //死亡日期时间
	set DeathDateTime=$p(DeathDateTime,"-",1)_"年"_$p(DeathDateTime,"-",2)_"月"_$p(DeathDateTime,"-",3)_"日"_$p(deathTime,":",1)_"时"_$p(deathTime,":",2)_"分"
	set deaPlace=$p($g(mainReportStr),separate,26)
	set:deaPlace[$c(1) deaPlace=$p(deaPlace,$c(1),1)
	set DeathPlace=deaPlace
	set FamName=$p($g(mainReportStr),separate,19)                  //联系人姓名
	set FamTel=$p($g(mainReportStr),separate,21)                   //联系电话
	set FamAddr=$p($g(mainReportStr),separate,22)                  //联系人地址
	set AReason=$p($g(mainReportStr),separate,31)                  //AReason
	set AReason=$p(AReason,"[",1)
	set AInterval=$p($g(mainReportStr),separate,32)_"^"_..GetStringDesc($p($g(mainReportStr),separate,60))                
	set BReason=$p($g(mainReportStr),separate,33)
	set BReason=$p(BReason,"[",1)
	set BInterval=$p($g(mainReportStr),separate,34)_"^"_..GetStringDesc($p($g(mainReportStr),separate,61))
	set CReason=$p($g(mainReportStr),separate,35)
	set CReason=$p(CReason,"[",1)
	set CInterval=$p($g(mainReportStr),separate,36)_"^"_..GetStringDesc($p($g(mainReportStr),separate,62))
	set DReason=$p($g(mainReportStr),separate,37)
	set DReason=$p(DReason,"[",1)
	set DInterval=$p($g(mainReportStr),separate,38)_"^"_..GetStringDesc($p($g(mainReportStr),separate,63))
	set OtherDiagnose=$p($g(mainReportStr),separate,39)
	set OtherDiagnose=$p(OtherDiagnose,"[",1)
	set diagUnit=$p($g(mainReportStr),separate,40)
	set DiagnoseUnit=diagUnit
	set DiagnoseUnit=..GetStringDesc($p($g(mainReportStr),separate,40))
	
	set diagBasis=..GetStringDesc($p($g(mainReportStr),separate,41))
	set DiagnoseBasis=diagBasis  //诊断依据
	set BaseReason=$p($g(mainReportStr),separate,27)
	set BaseReasonICD=$p($g(mainReportStr),separate,28)
	set DamageReason=$p($g(mainReportStr),separate,29)
	set DamageReasonICD=$p($g(mainReportStr),separate,30)
	set ResumeText=$p($g(mainReportStr),separate,42)
	set RepDate=$p($g(mainReportStr),separate,51)
	set RepDate=$zd(##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(RepDate),3)
	set RepDate=$p(RepDate,"-",1)_"年"_$p(RepDate,"-",2)_"月"_$p(RepDate,"-",3)_"日"
	set ExamMedical=$p($g(mainReportStr),separate,43)  //症状
	set ExamName=$p($g(mainReportStr),separate,44)
	set ExamAddress=$p($g(mainReportStr),separate,48)
	set ExamTel=$p($g(mainReportStr),separate,46)
	set ExamDeathReason=$p($g(mainReportStr),separate,47)
	set examUserName=..GetStringDesc($p($g(mainReportStr),separate,49))
	set ExamRelation=..GetStringDesc($p($g(mainReportStr),separate,45))
	set ExamDate=$p($g(mainReportStr),separate,50)
	set:ExamDate'="" ExamDate=$zd(##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ExamDate),3)
	set:ExamDate'="" ExamDate=$p(ExamDate,"-",1)_"年"_$p(ExamDate,"-",2)_"月"_$p(ExamDate,"-",3)_"日"
	set DeathNo=$p($g(mainReportStr),separate,23)
	//生成死亡编号
	set DeathNo=$p(DeathNo,"-",1)_$p(DeathNo,"-",2)_$p(DeathNo,"-",3)
	set cardtype=$p($g(mainReportStr),separate,64)
	set:cardtype[$c(1) cardtype=$p(cardtype,$c(1),1)
	set CardType=cardtype
	set MEPDProvince=$p($g(mainReportStr),separate,66)
	set:MEPDProvince'="" MEPDProvince=$p(MEPDProvince,$c(1),2)
	set MEPDCity=$p($g(mainReportStr),separate,67)
	set:MEPDCity'="" MEPDCity=$p(MEPDCity,$c(1),2)
	set MEPDCounty=$p($g(mainReportStr),separate,68)
	set:MEPDCounty'="" MEPDCounty=$p(MEPDCounty,$c(1),2)
	set MEPDVillage=$p($g(mainReportStr),separate,78)
	set:MEPDVillage'="" MEPDVillage=$p(MEPDVillage,$c(1),2)
	
	set RegProvince=$p($g(mainReportStr),separate,79)
	set:RegProvince'="" RegProvince=$p(RegProvince,$c(1),2)
	set RegCity=$p($g(mainReportStr),separate,80)
	set:RegCity'="" RegCity=$p(RegCity,$c(1),2)
	set RegCounty=$p($g(mainReportStr),separate,81)
	set:RegCounty'="" RegCounty=$p(RegCounty,$c(1),2)
	set RegVillage=$p($g(mainReportStr),separate,82)
	set:RegVillage'="" RegVillage=$p(RegVillage,$c(1),2)
	set RegRoad=$p($g(mainReportStr),separate,85) 
	set CurrRoad=$p($g(mainReportStr),separate,86)
	set FamIdentify=$p($g(mainReportStr),separate,84)
	set RepDocName=$p($g(mainReportStr),separate,77)
	set AFPReason=$p($g(mainReportStr),separate,69)  //诊断A编码
	set AFPReasonICD=$p($g(mainReportStr),separate,73)  //诊断A编码ICD
	set BFPReason=$p($g(mainReportStr),separate,70)  //诊断B编码
	set BFPReasonICD=$p($g(mainReportStr),separate,74)  //诊断B编码ICD
	set CFPReason=$p($g(mainReportStr),separate,71)  //诊断C编码
	set CFPReasonICD=$p($g(mainReportStr),separate,75)  //诊断C编码ICD
	set DFPReason=$p($g(mainReportStr),separate,72)  //诊断D编码
	set DFPReasonICD=$p($g(mainReportStr),separate,76)  //诊断C编码ICD
	
	set OtherDiagnoseICD=$p($g(mainReportStr),separate,87)  //其他诊断ICD
	set OtherDiagnoseFP=$p($g(mainReportStr),separate,88)  //其他诊断编码
	set OtherDiagnoseFPICD=$p($g(mainReportStr),separate,89)  //其他诊断编码ICD
	set OtherDiagnoseInterval=$p($g(mainReportStr),separate,90)_"^"_..GetStringDesc($p($g(mainReportStr),separate,91))
	set data=$lb(reportId,PaperNo,PapmiNo,MrNo,Name,Sex,Country,Nation,Pregnancies,Occupation,Identify,RegAddress,CurrAddress,Marital,Education,Company,Birthday,DeathDateTime,Age,DeathPlace,FamName,FamTel,FamAddr,AReason,AInterval,BReason,BInterval,CReason,CInterval,DReason,DInterval,OtherDiagnose,OtherDiagnoseICD,OtherDiagnoseFP,OtherDiagnoseFPICD,OtherDiagnoseInterval,DiagnoseUnit,DiagnoseBasis,BaseReason,BaseReasonICD,DamageReason,DamageReasonICD,ResumeText,RepDate,ExamMedical,ExamName,ExamAddress,ExamTel,ExamDeathReason,examUserName,ExamRelation,ExamDate,DeathNo,MEPDCountyCode,CardType,MEPDProvince,MEPDCity,MEPDCounty,MEPDVillage,RegProvince,RegCity,RegCounty,RegVillage,RegRoad,CurrRoad,FamIdentify,RepDocName,AFPReason,AFPReasonICD,BFPReason,BFPReasonICD,CFPReason,CFPReasonICD,DFPReason,DFPReasonICD,CardType)
	
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	
	Quit $$$OK
}

/// 入参：描述^ID
/// 说明：传入描述和ID拼成的字符串返回描述，但实际上传入的是ID^描述,这样返回的就是ID了
/// w ##Class(DHCMed.DTHService.ReportSrv).GetStringDesc("省(市)^64")
ClassMethod GetStringDesc(descStr)
{
	new (descStr)
	set retDesc=""
	q:descStr="" retDesc
	
	set retDesc=$p(descStr,$c(1),1)
	
	q retDesc
}

ClassMethod DMReportPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DMReportPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DMReportPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DMReportPrintExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:wangCS
/// CreateDate:201-08-08
/// Description:根据patientId得到报告的Id
/// Input:patientId
/// Output:
/// Debug:w ##Class(DHCMed.DTHService.ReportSrv).GetRepIdByPatientId(143703);
ClassMethod GetRepIdByPatientId(patientId As %String) As %String
{
	new (patientId)
	set ret=""
	
	set patientId=" "_$ZCVT(patientId,"U")
	set repRowId=""
	set repRowId=$o(^DHCMed.DTHi("REP","IndexPatientID",patientId,repRowId),-1)
	q:repRowId="" ret
	
	set ret=repRowId
	
	quit repRowId
}

/// Creator:wangCS
/// CreateDate:2011-08-08
/// Description:根据PatientId得到报告信息
/// Input: PatientId:
/// Output:
/// Debug: w ##Class(DHCMed.DTHService.ReportSrv).GetDecReportByPat(7)
ClassMethod GetDecReportByPat(patientId As %String) As %String
{
	new (patientId)
	set ret=""
	quit:patientId="" ret
	
	set repRowId=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_patientId,""),-1)
	set repObj=##Class(DHCMed.DTH.Report).GetObjById(+repRowId)
	quit:'$IsObject(repObj) ret
	set repDate=repObj.RepDate
	set:repDate'="" repDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(repDate)
	set repTime=repObj.RepTime
	set:repTime'="" repTime=$zt(repTime,2)
	set repDateTime=repDate_" "_repTime
	set repUser=repObj.RepUsrDR
	if repUser'="" {
		set repUserObj=##Class(DHCMed.Base.SSUser).GetObjById(+repUser)
		set repUser=repUserObj.Name
	}
	set repStatus=repObj.RepStatusDR.Description
	quit:(repStatus["删除")||(repStatus["作废") ret
	
	set ret="报告时间:"_repDate_" "_repTime_" 报告人:"_repUser_" 状态:"_repStatus
	quit ret
}

/// 判断是否为住院、急诊死亡患者
ClassMethod CheckIsDecPat(aPatientID As %String) As %String
{
	New (aPatientID)
	Set return=0
	Quit:aPatientID="" return
	
	Set DeceasedFlag=$p(^PAPER(aPatientID,"ALL"),"^",12)
	Set DeceasedDate=$p(^PAPER(aPatientID,"ALL"),"^",13)
	Set DeceasedTime=$p(^PAPER(aPatientID,"ALL"),"^",8)
	Set:(DeceasedFlag="Y")||(DeceasedDate'="")||(DeceasedTime'="") return=1
	Set Paadm=""
	For {
		Quit:return=1
		Set Paadm=$o(^PAPERdr(aPatientID,"ADM","E",Paadm))
		Quit:Paadm=""
		Set tmpID=$o(^DHCADMVisitStatus(0,"PAADM",Paadm,""),-1)
		Continue:(+tmpID)=0
		Set VStatusID=$p($g(^DHCADMVisitStatus(tmpID)),"^",2)
		Set tmpCode=$p($g(^DHCPACVisitStatus(+VStatusID)),"^",1)
		Set tmpDesc=$p($g(^DHCPACVisitStatus(+VStatusID)),"^",2)
		Continue:((tmpCode'["Death")&&(tmpDesc'["死亡"))
		Set return=1
	}
	
	Quit return
}

/// 取死亡患者信息
ClassMethod GetDecPatData(aPatientID As %String, locId As %String = "", hospId As %String = "") As %String
{
	New (aPatientID,locId,hospId)
	Set return=""
	Set (DecStatus,DecDate,DecTime)=""
	//*******************************************************
	Set DecPaadm=""
	/*
	For {
		Set Paadm=$o(^PAPERdr(aPatientID,"ADM","E",Paadm))
		Quit:Paadm=""
		Quit:DecPaadm'=""
		Set tmpID=$o(^DHCADMVisitStatus(0,"PAADM",Paadm,""),-1)
		Continue:(+tmpID)=0
		Set VStatusID=$p($g(^DHCADMVisitStatus(tmpID)),"^",2)
		Set tmpCode=$p($g(^DHCPACVisitStatus(+VStatusID)),"^",1)
		Set tmpDesc=$p($g(^DHCPACVisitStatus(+VStatusID)),"^",2)
		Continue:((tmpCode'["Death")&&(tmpDesc'["死亡"))
		Set DecPaadm=Paadm
		Set DecStatus=tmpDesc
	}
	*/
	
	//判断病人是哪次就诊死亡的，默认为最后一次就诊
	Set PAAdm=$p(..GetPatFinalInfo(aPatientID),"^",1)
	Set DecStatus=$p(..GetPatFinalInfo(aPatientID),"^",2)
	//*******************************************************
	Set DecDate=$p(^PAPER(aPatientID,"ALL"),"^",13)
	Set:DecDate'="" DecDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DecDate)
	Set DecTime=$p(^PAPER(aPatientID,"ALL"),"^",8)
	Set:DecTime'="" DecTime=$zt(DecTime,1)
	
	Set (ReportID,RepDate,RepTime,RepUser,RepStatus,RepLoc,RepLocID,MrNo)=""
	Set RepID=0
	For {
		Set RepID=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_aPatientID,RepID))
		Quit:RepID=""
		Set objReport=##Class(DHCMed.DTH.Report).GetObjById(RepID)
		Continue:'$IsObject(objReport)
		Continue:'$IsObject(objReport.RepStatusDR)
		Continue:(objReport.RepStatusDR.Description["删除")||(objReport.RepStatusDR.Description["作废")
		
		Set ReportID=RepID
		Set RepDate=objReport.RepDate
		Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
		Set RepTime=objReport.RepTime
		Set:RepTime'="" RepTime=$zt(RepTime,2)
		Set RepUser=objReport.RepUsrDR
		Set:RepUser'="" RepUser=$p($g(^SSU("SSUSR",RepUser)),"^",2)
		Set RepStatus=objReport.RepStatusDR.Description
		Set RepLocID=objReport.RepLocDR
		Set:RepLocID'="" RepLoc=$p($g(^CTLOC(RepLocID)),"^",2)
		Set:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
		Set MrNo=objReport.MrNo
	}
	Set:MrNo="" MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(PAAdm,"I")
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(PAAdm)
	Quit:'$IsObject(objPaadm) return
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(aPatientID)
	Quit:'$IsObject(objPatient) return
	/*
	//modify by pylian 2015-06-16 修改报告查询年龄问题
	Set PatAge=""                           //年龄
	If (objPatient.Age>0) {
		Set PatAge=PatAge_objPatient.Age_"岁"
	} ElseIf (objPatient.AgeMonth>0) {
		Set PatAge=PatAge_objPatient.AgeMonth_"月"
	} ElseIf (objPatient.AgeDay>0) {
		Set PatAge=PatAge_objPatient.AgeDay_"天"
	}
	*/
	//统一调用年龄计算方法
	//upadte by pylian 2016-02-18 修改入院时间取值方式
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(PAAdm)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(PAAdm)
	Set DischDate=$p(DischDateTime,"^",1)
	Set:DischDate'="" DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
	Set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(aPatientID,PAAdm,AdmDate,AdmTime)
		
	set HOSPID=$p($g(^CTLOC(objPaadm.DepartmentID)),"^",22)
	//Quit:(HOSPID'="")&&(hospId'="")&&(hospId'[HOSPID) return
	if hospId'="" {
		set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(objPaadm.DepartmentID,hospId)
		Quit:flg<1 return
	}
	Quit:(locId'="")&&(objPaadm.DepartmentID'=locId) return
	//Quit:(locId'="")&&(RepLocID'="")&&(RepLocID'=locId) return
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(aPatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",4)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
		
	Set $li(return,1)=objPaadm.AdmRowID
	Set $li(return,2)=aPatientID
	Set $li(return,3)=objPatient.PapmiNo
	Set $li(return,4)=objPatient.PatientName
	Set $li(return,5)=objPatient.Sex
	//Set $li(return,6)=objPatient.Age  //modify by pylian 2015-04-29 
	Set $li(return,6)=PatAge
	Set $li(return,7)=DecStatus
	Set $li(return,8)=DecDate
	Set $li(return,9)=DecTime
	Set $li(return,10)=objPaadm.DoctorName
	Set $li(return,11)=AdmDate //objPaadm.AdmitDate
	Set $li(return,12)=objPaadm.Department
	Set:$li(return,12)["-" $li(return,12)=$p($li(return,12),"-",2)
	Set $li(return,13)=objPaadm.Ward
	Set:$li(return,13)["-" $li(return,13)=$p($li(return,13),"-",2)
	Set $li(return,14)=objPaadm.Room
	Set $li(return,15)=objPaadm.Bed
	Set $li(return,16)=DischDate //objPaadm.DisDate
	Set:$li(return,16)="1840-12-31" $li(return,16)=""
	Set $li(return,17)=ReportID
	Set $li(return,18)=RepDate
	Set $li(return,19)=RepTime
	Set $li(return,20)=RepUser
	Set $li(return,21)=RepStatus
	Set $li(return,22)=RepLocID
	Set $li(return,23)=RepLoc
	Set $li(return,24)=MrNo
	Set $li(return,25)=EncryptLevel
	Set $li(return,26)=PatLevel
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-10-28
/// Description:  查询死亡患者信息
/// d ##class(%ResultSet).RunQuery("DHCMed.DTHService.ReportSrv","QryDeathPatients","2014-10-01","2014-10-01","","2","","")
Query QryDeathPatients(argDateFrom As %String, argDateTo As %String, arglocId As %String, hospId As %String, argExamConts As %String, argExamSepeare As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String,PatientName:%String,Sex:%String,Age:%String,DecStatus:%String,DecDate:%String,DecTime:%String,DoctorName:%String,AdmitDate:%String,Department:%String,Ward:%String,Room:%String,Bed:%String,DisDate:%String,ReportID:%String,RepDate:%String,RepTime:%String,RepUser:%String,RepStatus:%String,RepLocID:%String,RepLoc:%String,MrNo:%String,EncryptLevel:%String,PatLevel:%String") [ SqlProc ]
{
}

ClassMethod QryDeathPatientsExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, arglocId As %String, hospId As %String, argExamConts As %String, argExamSepeare As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set DateFrom=argDateFrom
	Set DateTo=argDateTo
	Set DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateFrom)
	Set DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateTo)
	Set:DateFrom'="" DateFrom=+DateFrom
	Set:DateTo'="" DateTo=+DateTo
	
	Set locId=arglocId
	Set:$g(argExamSepeare)="" argExamSepeare="^"
	Set (PatName,RegNo,MrNo)=""
	For indCont=1:1:$l(argExamConts,argExamSepeare) {
		Set ExamCont=$p(argExamConts,argExamSepeare,indCont)
		Set:ExamCont["PatName=" PatName=$e(ExamCont,$l("PatName=")+1,$l(ExamCont))
		Set:ExamCont["MrNo=" MrNo=$e(ExamCont,$l("MrNo=")+1,$l(ExamCont))
		Set:ExamCont["RegNo=" RegNo=$e(ExamCont,$l("RegNo=")+1,$l(ExamCont))
	}
	If RegNo'="" {  // 登记号不为空
		Set Len=10
		Set PATCFid=$o(^CF("PATCF",""))
		Set:PATCFid'="" Len=$p($g(^CF("PATCF",+PATCFid,3)),"^",5)
		If $l(RegNo)<Len {
			Set PreLen=Len-$l(RegNo)
			For indPre=1:1:PreLen {
				Set RegNo="0"_RegNo
			}
		}
		Set PatientID=0
		For {
			Set PatientID=$o(^PAPERi("PAPMI_PatNo",RegNo,PatientID))
			Quit:PatientID=""
			Set Name = $p(^PAPER(PatientID,"ALL"),"^",1)
			Continue:(PatName'="")&&(Name'[PatName)  //根据姓查询

			Set PatMrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"I")
			Continue:((MrNo'="")&&(MrNo'=PatMrNo))
			Continue:(..CheckIsDecPat(PatientID)=0)
			Set Data=..GetDecPatData(PatientID)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}ElseIf PatName'="" {  // 病人姓名不为空
		Set PatName=$zcvt(PatName,"U")  //姓名
		Set tmpName=$o(^PAPERi("PAPER_PatName",PatName),-1)
		For {
			Set tmpName=$o(^PAPERi("PAPER_PatName",tmpName))
			Quit:(tmpName="")||($e(tmpName,1,$l(PatName))'=PatName)  //根据姓查询
			Set PatientID=0
			For {
				Set PatientID=$o(^PAPERi("PAPER_PatName",tmpName,PatientID))
				Quit:PatientID=""
				
				Set PatMrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"I") 
				Continue:((MrNo'="")&&(MrNo'=PatMrNo))
				Continue:(..CheckIsDecPat(PatientID)=0)
				Set Data=..GetDecPatData(PatientID)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}Else{    //按死亡日期查询
		Set PatList=""
		Quit:(DateFrom="")||(DateTo="") $$$OK
		Set DecDate=DateFrom-1
		For {
			Set DecDate=$o(^PAPERi("DecDate",DecDate))
			Quit:(DecDate="")||(DecDate>DateTo)
			Set PatientID=""
			For {
				Set PatientID=$o(^PAPERi("DecDate",DecDate,PatientID))
				Quit:PatientID=""
				Set PatMrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"I")
				Continue:((MrNo'="")&&(MrNo'=PatMrNo))
				//Continue:(..CheckIsDecPat(PatientID)=0)
				Set:$ListFind(PatList,PatientID)<1 PatList=PatList_$lb(PatientID)

				Set Data=..GetDecPatData(PatientID,locId,hospId)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		//增加死亡医嘱的判断(仅下了死亡医嘱，未填写死亡报卡)
		If hospId'="" {
			Set ArcimID=$g(^DHCDishChargeSet("Disch","deathDischargeNeedArcim",hospId))			//取demo中配置的死亡医嘱ID
			Set OEOrdPatList=$$GetOEOrdPatList(ArcimID)
			Quit:OEOrdPatList="" $$$OK

			For indPat=1:1:$ListLength(OEOrdPatList) {
				Set OEOrdPatientID=$List(OEOrdPatList,indPat)
				Continue:OEOrdPatientID=""
				
				Set Data=..GetDecPatData(OEOrdPatientID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		} Else {
			Set xHosp=""
			For {
				Set xHosp=$o(^DHCDishChargeSet("Disch","deathDischargeNeedArcim",xHosp))
				Quit:xHosp=""
				Set ArcimID=$g(^DHCDishChargeSet("Disch","deathDischargeNeedArcim",xHosp))			//取demo中配置的死亡医嘱ID
				Set OEOrdPatList=$$GetOEOrdPatList(ArcimID)
				Continue:OEOrdPatList=""

				For indPat=1:1:$ListLength(OEOrdPatList) {
					Set OEOrdPatientID=$List(OEOrdPatList,indPat)
					Continue:OEOrdPatientID=""

					Set Data=..GetDecPatData(OEOrdPatientID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}

		/*
		//急诊死亡病人
		set DepID = ""
		for {
			set DepID = $o(^PAADMi("AdmTypeCurrLoc","E",DepID))
			q:DepID=""
			set FromDate = DateFrom-1
			for {
				set FromDate = $o(^PAADMi("AdmTypeCurrLoc","E",DepID,FromDate))
				Quit:(FromDate="")||(FromDate>DateTo)
				set TimeFrom = ""
				for {
					set TimeFrom = $o(^PAADMi("AdmTypeCurrLoc","E",DepID,FromDate,TimeFrom))
					q:TimeFrom=""
					s paadm = ""
					for {
						set paadm = $o(^PAADMi("AdmTypeCurrLoc","E",DepID,FromDate,TimeFrom,paadm))
						q:paadm=""
						Continue:((locId'="")&&(locId'=DepID))
						Set PatientID=$p($g(^PAADM(paadm)),"^",1)
						Set PatMrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"I") 
						Continue:((MrNo'="")&&(MrNo'=PatMrNo))
						Continue:(..CheckIsDecPat(PatientID)=0)
						Set Data=..GetDecPatData(PatientID,DepID,hospId)
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
		*/
		//急诊死亡病人
	}
	Quit $$$OK

GetOEOrdPatList(aArcimID)
	Set OEOrdPatList=""
	Quit:aArcimID="" ""
	For xDate=DateFrom:1:DateTo {
		Set xOrdID=""
		For {
			Set xOrdID=$o(^OEORDi(0,"StDt",xDate,xOrdID))
			Quit:xOrdID=""
			
			Set Paadm=$p($g(^OEORD(xOrdID)),"^",1)
			Set PatientID=$p($g(^PAADM(Paadm)),"^",1)
			Continue:($ListFind(PatList,PatientID)>0)||($ListFind(OEOrdPatList,PatientID)>0)
			
			Set xSubID=""
			For {
				Set xSubID=$o(^OEORDi(0,"StDt",xDate,xOrdID,xSubID))
				Quit:xSubID=""
				
				Set OrdLocID=$p($g(^OEORD(+xOrdID,"I",xSubID,1)),"^",3)
				Continue:(arglocId'="")&&(arglocId'=OrdLocID)
				
				Set ArcimID=$p($g(^OEORD(+xOrdID,"I",xSubID,1)),"^",2)
				Continue:aArcimID'=ArcimID
				Set OEORIItemStatDR=$p($g(^OEORD(+xOrdID,"I",xSubID,1)),"^",13)
				Set OSTATDesc=""
				Set:OEORIItemStatDR'=0 OSTATDesc=$p($g(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
				Continue:OSTATDesc="作废"		// 过滤掉已作废的死亡医嘱
				Set:$ListFind(OEOrdPatList,PatientID)<1 OEOrdPatList=OEOrdPatList_$lb(PatientID)
			}
		}
	}
	Quit OEOrdPatList
}

ClassMethod QryDeathPatientsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDeathPatientsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDeathPatientsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDeathPatientsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Creator     : zhufei
/// CreateDate  : 2014-04-01
/// Description : 根据PatientID取死亡报告
/// Input       ：PatientID
/// Output      ：死亡报告内容
/// Do ##Class(%ResultSet).RunQuery("DHCMed.DTHService.ReportSrv","QryReportByPatientID",1)
Query QryReportByPatientID(aPatientID As %String) As %Query(ROWSPEC = "RowID:%String,PatientID:%String,EpisodeID:%String,RepNo:%String,DeathNo:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,Nation:%String,CardType:%String,Identify:%String,Occupation:%String,RegAddress:%String,CurrAddress:%String,DeathDate:%String,DeathTime:%String,DeathDateTime:%String,AReason:%String,BaseReason:%String,RepUser:%String,RepLoc:%String,FamName:%String,FamTel:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,BackReason:%String,CheckTwoDate:%String,RepStatusCode:%String,RepStatusDesc:%String,PrintReason:%String,EncryptLevel:%String,PatLevel:%String,ReturnReason:%String,IsCASign:%String") [ SqlProc ]
{
}

ClassMethod QryReportByPatientIDExecute(ByRef qHandle As %Binary, aPatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Quit:aPatientID="" $$$OK
	
	Set xReportID=0
	For {
		Set xReportID=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_aPatientID,xReportID))
		Quit:xReportID=""
		
		Set Data=..GetDataByReportId(xReportID)
		Continue:Data=""
		
		Set ReturnReason=""
		Set xSubID=""
		For { 
			Set xSubID=$o(^DHCMed.DTH("REP",xReportID,"Status",xSubID),-1)
			Quit:xSubID=""
			Quit:ReturnReason'=""
			Set objSub=##Class(DHCMed.DTH.ReportStatus).GetObjById(xReportID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			Continue:'$IsObject(objSub.StatusDR)
			Continue:objSub.StatusDR.Code'=9
			Set ReturnReason=objSub.ResumeText
		}
		Set IsCASign=##Class(DHCMed.CA.SignVerify).GetRepIsSign("DTH","DTH",xReportID,"S")	//是否CA认证
		
		Set ^CacheTemp(repid,ind)=Data_$lb(ReturnReason,IsCASign)
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryReportByPatientIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByPatientIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	//Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportByPatientIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByPatientIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	} else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:    liulan
/// CreateDate: 2013-03-23
/// Description:更新DHCMed.DTH.PrintStatus
/// Input:      instr:字符串
///             separate:分割符
/// Output:     成功返回打印次数，失败返回-1
/// w ##Class(DHCMed.DTHService.ReportSrv).UpdatePrintStatus("98^117^9^Y^med^2^1^^,^")
ClassMethod UpdatePrintStatus(instr, separate) As %String
{
	///reportId+separate+CtlocId+separate+status+separate+resumeText;
	if ($g(separate)="")
	{
		set separate="^"
	}
	
	set reportId=$p($g(instr),separate,1)
	set CtlocId=$p($g(instr),separate,2)
	set userId=$p($g(instr),separate,3)  //报告人
	set PrintFlag=$p($g(instr),separate,4)  //Y
	set UserID=$p($g(instr),separate,5)  //打印人ID
	set Code=$p($g(instr),separate,6)  //打印状态 1 首联 2 三联
	set PrintNum=$p($g(instr),separate,7)
	set TPrintNum=$p($g(instr),separate,8)
	set ret=1
	q:(reportId="") ret
	
	set Reportobj=##Class(DHCMed.DTH.Report).%OpenId(+reportId)
	if (Reportobj'="")
	{
		set Printobj=##Class(DHCMed.DTH.PrintStatus).%New()
		set Printobj.ParRef=Reportobj
		set currDate=+$h
		set currTime=+$p($h,",",2)
		set Printobj.OpeDate=currDate
		set Printobj.OpeTime=currTime
		set Printobj.CtlocId=CtlocId
		set Printobj.OpeUserDR=userId
		set Printobj.PrintFlag=PrintFlag
		set Printobj.UserID=UserID
		set Printobj.Code=Code
		if (PrintNum'=""){
			set Printobj.PrintNum=PrintNum+1
		}else{
			set Printobj.PrintNum=PrintNum}
		if (TPrintNum'=""){
			set Printobj.TPrintNum=TPrintNum+1}
		else{
			set Printobj.TPrintNum=TPrintNum
		}
		set retValue=Printobj.%Save()
		if ($system.Status.IsError(retValue))
		{
			do $system.OBJ.DisplayError(retValue)
			set ret=-1
		}
		do Printobj.%Close()
	}
	
	quit ret
}

/// Creator:    liulan
/// CreateDate: 2013-03-23
/// Description:获取DHCMed.DTH.PrintStatus中的打印状态
/// Input:      instr:字符串
///             separate:分割符
/// Output:     已打印返回Y，未打印返回"N"
/// w ##Class(DHCMed.DTHService.ReportSrv).GetPrintStatus("97^","")
ClassMethod GetPrintStatus(instr, separate) As %String
{
	if ($g(separate)="")
	{
		set separate="^"
	}
	set reportId=$p($g(instr),separate,1)
	set ret=0
	q:(reportId="") ret
	set PrintId=""
	for { 
		set PrintId=$o(^DHCMed.DTH("REP",reportId,"ChildPrintStatus",PrintId))
		q:PrintId=""
		set icd=reportId_"||"_PrintId
		set Printobj=##Class(DHCMed.DTH.PrintStatus).%OpenId(icd)
		set PrintFlag=Printobj.PrintFlag
		set ret=PrintFlag
	}
	quit ret
}

/// Creator:    liulan
/// CreateDate: 2013-04-16
/// Description:获取DHCMed.DTH.PrintStatus中的打印次数
/// Input:      instr:字符串
///             separate:分割符
/// Output:     返回三联打印次数
/// w ##Class(DHCMed.DTHService.ReportSrv).GetPrintNumStatus("98^2","")
ClassMethod GetPrintNumStatus(instr, separate) As %String
{
	if ($g(separate)="")
	{
		set separate="^"
	}
	set reportId=$p($g(instr),separate,1)
	set argCode=$p($g(instr),separate,2)
	set ret=0
	q:(reportId="") ret
	set PrintId=""
	for { 
		set PrintId=$o(^DHCMed.DTH("REP",reportId,"ChildPrintStatus",PrintId))
		q:PrintId=""
		set icd=reportId_"||"_PrintId
		set Printobj=##Class(DHCMed.DTH.PrintStatus).%OpenId(icd)
		set Code=Printobj.Code 
		Continue:Code'=argCode
		set PrintNum=Printobj.PrintNum
		Continue:PrintNum=""
		set ret=PrintNum
	}
	quit ret
}

/// Creator:    liulan
/// CreateDate: 2013-04-16
/// Description:获取DHCMed.DTH.PrintStatus中的打印次数
/// Input:      instr:字符串
///             separate:分割符
/// Output:     返回二联打印次数
/// w ##Class(DHCMed.DTHService.ReportSrv).GetTPrintNumStatus("118^1","")
ClassMethod GetTPrintNumStatus(instr, separate) As %String
{
	if ($g(separate)="")
	{
		set separate="^"
	}
	
	set reportId=$p($g(instr),separate,1)
	set argCode=$p($g(instr),separate,2)
	set ret=0
	q:(reportId="") ret
	set PrintId=""
	for { 
		set PrintId=$o(^DHCMed.DTH("REP",reportId,"ChildPrintStatus",PrintId))
		q:PrintId=""
		
		set icd=reportId_"||"_PrintId
		set Printobj=##Class(DHCMed.DTH.PrintStatus).%OpenId(icd)
		set Code=Printobj.Code 
		Continue:Code'=argCode
		set TPrintNum=Printobj.TPrintNum
		Continue:TPrintNum=""
		set ret=TPrintNum
	}
	quit ret
}

/// Creator     : pylian
/// CreateDate  : 2015-07-14
/// Description : 获得患者最后一次就诊信息
/// w ##Class(DHCMed.DTHService.ReportSrv).GetPatFinalInfo("405")
ClassMethod GetPatFinalInfo(aPatientID) As %String
{
	new (aPatientID)
	set return=-100
	quit:aPatientID="" return
	
	Set AdmType="",PAADMS=""
	For {
		Set AdmType=$O(^PAPERdr(aPatientID,"ADM",AdmType)) 
		Quit:AdmType=""  
		
		Set PAAdm=""
		For {
			Set PAAdm=$O(^PAPERdr(aPatientID,"ADM",AdmType,PAAdm)) 
			Quit:PAAdm="" 
			
			Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
			Continue:PAAdmStatus="C"
			set PAADMS=PAADMS_","_PAAdm	 
			//fix bug 178948 住院的患者未出院之前挂门诊号时仍时住院状态
			Set DeceasedDate=$p(^PAPER(aPatientID,"ALL"),"^",13)
			Set DeceasedTime=$p(^PAPER(aPatientID,"ALL"),"^",8)
			    
			Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)	
			Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(PAAdm)
			Set DischDate=$p(DischDateTime,"^",1)
			Set DischTime=$p(DischDateTime,"^",2)				
		}
		//死亡医嘱即出院医嘱
		Quit:(DischDate'="")&&(DeceasedDate=DischDate)
		Quit:((PAAdmType="I")&&(DischDate=""))
	}
	Set:PAADMS'="" PAADMS=$e(PAADMS,2,$l(PAADMS))
			
	Set Index =""
	If $l(PAADMS,",")>0 {
		Set max=$p(PAADMS,",",1)
		For Index=1:1:$l(PAADMS,",") {
			Set data=$p(PAADMS,",",(Index+1))
			if (data>=max){
				Set max=data
			}
		}
		Set PAAdm=max
		//Set PAAdmDate=$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
		//Set PAAdmTime=$ZT($P($g(^PAADM(PAAdm)),"^",7),3)
		//upadte by pylian 2016-02-18 修改入院时间取值方式
		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(PAAdm)
		Set PAAdmDate=$p(AdmDateTime,"^",1)
		Set PAAdmTime=$p(AdmDateTime,"^",2)
		Set:PAAdmDate'="" PAAdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(PAAdmDate)
		Set:PAAdmTime'="" PAAdmTime=$zt(PAAdmTime,2)
		
		Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
		If PAAdmType="I" Set DecStatus="死亡(住院)"
		If PAAdmType="O" Set DecStatus="死亡(门诊)"
		If PAAdmType="E" Set DecStatus="死亡(急诊)"
		If PAAdmType="H" Set DecStatus="死亡(体检)"				
	}	
	set return=PAAdm_"^"_DecStatus
	quit return
}

/// Creator:    zhufei
/// CreateDate: 2018-02-07
/// Description:根据死亡日期获取死亡报告
/// Input:      StartDate，EndDate
/// Output:     
/// d ##Class(%ResultSet).RunQuery("DHCMed.DTHService.ReportSrv","QryDischStat","2013-11-01","2014-12-29") 
Query QryDischStat(StartDate As %String, EndDate As %String, HospID As %String) As %Query(ROWSPEC = "PAADMName:%String,PACWardDesc:%String,RepPatiertNum:%Integer,RepNum:%Integer,DthNum:%Integer,DeathDate:%String,DeathTime:%String,RepUser:%String,RepDate:%String,RepTime:%String,OpeDate:%String,NotRepNum:%Integer,hour:%Float,CheckRepNum:%Integer") [ SqlProc ]
{
}

ClassMethod QryDischStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:$l(StartDate,"-")=2 StartDate=StartDate_"-01"
	Set:$l(EndDate,"-")=2 EndDate=EndDate_"-01"
	Set:StartDate["/" StartDate=$zdh(StartDate,4)
	Set:StartDate["-" StartDate=$zdh(StartDate,3)
	Set:StartDate'="" StartDate=+StartDate
	Set:EndDate["/" EndDate=$zdh(EndDate,4)
	Set:EndDate["-" EndDate=$zdh(EndDate,3)
	Set:EndDate'="" EndDate=+EndDate
	Quit:(StartDate="")||(EndDate="") $$$OK
		
	Kill ^CacheTemp($zn,$j,"QryDischStat")
	
	For xDecDate=StartDate:1:EndDate {
		// 病人基本信息筛查
		Set xPatientID=0
		For {
			Set xPatientID=$o(^PAPERi("DecDate",xDecDate,xPatientID))
			Quit:xPatientID=""
			
			Set DeathDate=$p(^PAPER(xPatientID,"ALL"),"^",13)
			Set DeathTime=$p(^PAPER(xPatientID,"ALL"),"^",8)
			Continue:DeathDate=""
			Set ^CacheTemp($zn,$j,"QryDischStat",xPatientID)=$lb(DeathDate,DeathTime,"")
		}
		
		/// 死亡报告筛查
		Set xReportID=0
		For {
			Set xReportID=$o(^DHCMed.DTHi("REP","IndexDeathDate",xDecDate,xReportID))
			Quit:xReportID=""
			Set objRep=##class(DHCMed.DTH.Report).GetObjById(xReportID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.RepStatusDR)
			Set RepStatus=objRep.RepStatusDR.Description
			Continue:(RepStatus["删除")||(RepStatus["作废")||(RepStatus["草稿")
			Set PatientID=objRep.PatientID
			Set EpisodeID=objRep.EpisodeID
			If EpisodeID'="" {
				Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
			}
			Set DeathDate=objRep.DeathDate
			Set DeathTime=objRep.DeathTime
			Continue:DeathDate=""
			Set ^CacheTemp($zn,$j,"QryDischStat",PatientID)=$lb(DeathDate,DeathTime,EpisodeID)
		}
	}
	
	Set xPatientID=0
	For {
		Set xPatientID=$o(^CacheTemp($zn,$j,"QryDischStat",xPatientID))
		Quit:xPatientID=""
		
		Set PatInfo=$g(^CacheTemp($zn,$j,"QryDischStat",xPatientID))
		Continue:PatInfo=""
		Set DeathDate=$lg(PatInfo,1)
		Set DeathTime=$lg(PatInfo,2)
		Set EpisodeID=$lg(PatInfo,3)
		Set PatientID=xPatientID
		If EpisodeID="" {
			Set EpisodeID=$o(^PAPERdr(PatientID,"ADM","I",""),-1)
			Set tEpisodeID=$o(^PAPERdr(PatientID,"ADM","E",""),-1)
			If (tEpisodeID'="")&(tEpisodeID>EpisodeID) {
				Set EpisodeID=tEpisodeID
			}
			If EpisodeID="" {
				Set EpisodeID=$o(^PAPERdr(PatientID,"ADM","O",""),-1)
			}
			If EpisodeID="" {
				Set EpisodeID=$o(^PAPERdr(PatientID,"ADM","H",""),-1)
			}
		}
		Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
		Set:AdmType["I" DecStatus="死亡(住院)"
		Set:AdmType["E" DecStatus="死亡(急诊)"
		Set:AdmType["O" DecStatus="死亡(门诊)"
		Set:AdmType["H" DecStatus="死亡(体检)"
		
		//是否死亡,是否报告、是否三日未审数、是否审核、是否未报
		Set (DthNum,RepNum,NotRepNum,CheckRepNum,RepPatiertNum)=0
		//报告日期、报告时间、报告人、操作日期、用时、患者姓名、科室/病区、死亡日期、死亡时间
		Set (RepDate,RepTime,RepUser,OpeDate,hour,PAADMName,WardDesc)=""
		
		Set DthNum=1  //是否死亡
		
		//取报告信息
		Set xRepID=""
		For {
			Set xRepID=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_PatientID,xRepID),-1)
			Quit:xRepID=""
			
			Set objRep=##Class(DHCMed.DTH.Report).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.RepStatusDR)
			Set RepStatusCode=objRep.RepStatusDR.Code
			Set RepStatus=objRep.RepStatusDR.Description
			Continue:(RepStatusCode="0")||(RepStatusCode="5")||(RepStatusCode="6")  //删除、作废、草稿
			
			Set RepNum=1                              //是否报告
			Set RepDate=objRep.RepDate                //报告日期
			Set RepTime=objRep.RepTime                //报告时间
			Set RepUsrDR=objRep.RepUsrDR              //报告人
			Set RepUser=$p($g(^SSU("SSUSR",+RepUsrDR)),"^",2)
			
			Set xStatus=""
			For {
				Set xStatus=$o(^DHCMed.DTH("REP",xRepID,"Status",xStatus),-1)
				Quit:xStatus=""
				
				Set objRepStatus=##Class(DHCMed.DTH.ReportStatus).GetObjById(xRepID_"||"_xStatus)
				Continue:'$IsObject(objRepStatus)
				Continue:'$IsObject(objRepStatus.StatusDR)
				Set OperStatusCode=objRepStatus.StatusDR.Code
				Set OperStatus=objRepStatus.StatusDR.Description
				Continue:OperStatusCode'="3" //审核
				
				Set CheckRepNum=1                       //是否审核
				Set OpeDate=objRepStatus.OpeDate        //审核日期
				Set OpeTime=objRepStatus.OpeTime        //审核时间
				Set:(OpeDate-RepDate)>3 NotRepNum=1     //是否三日未审
				set hour=$fn((((OpeDate-RepDate)*24)+((OpeTime-RepTime)/3600)),"",3)  //审核用时
			}
			
			Quit //退出 处理一人多份报告情况
		}
		
		Set PAADMName=$p(^PAPER(PatientID,"ALL"),"^",1)
		Set LocID=$p(^PAADM(EpisodeID),"^",4)		
		Set LocDesc=$p(^CTLOC(LocID),"^",2)
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		If HospID'="" {
			Set HospID=$tr(HospID,"^",",")
			set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,HospID)
			continue:flg<1
		}
		Set WardDr=$p(^PAADM(EpisodeID),"^",70)
		If WardDr'="" {
			Set WardDesc=$p(^PAWARD(WardDr),"^",2)
			Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		}
		Set:WardDesc="" WardDesc=LocDesc //病区为空，取科室
		Set:DeathDate'="" DeathDate=$zd(DeathDate,3)
		Set:DeathTime'="" DeathTime=$zt(DeathTime,2)
		Set:RepDate'="" RepDate=$zd(RepDate,3)
		Set:RepTime'="" RepTime=$zt(RepTime,2)
		Set:OpeDate'="" OpeDate=$zd(OpeDate,3)
		
		Set:hour="" hour=0
		Set Data=$lb(PAADMName,WardDesc,RepPatiertNum,RepNum,DthNum,DeathDate,DeathTime,RepUser,RepDate,RepTime,OpeDate,NotRepNum,hour,CheckRepNum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^CacheTemp($zn,$j,"QryDischStat")
	
	Quit $$$OK
}

ClassMethod QryDischStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDischStatExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDischStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDischStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:    zhufei
/// CreateDate: 2018-02-07
/// Description:根据死亡日期获取死亡证明书明细
/// Input:      StartDate，EndDate
/// Output:     
/// d ##class(%ResultSet).RunQuery("DHCMed.DTHService.ReportSrv","GetDeadMessage","2014-12-01","2014-12-07")
Query GetDeadMessage(StartDate As %String, EndDate As %String, AdmWard As %String = "", HospID As %String = "") As %Query(ROWSPEC = "CtlocDesc:%String,PACWard:%String,Name:%String,IPNo:%String,DeathDate:%String,DeathTime:%String,RepDate:%String,RepTime:%String,ReportUser:%String,RepNo:%String,OpeDate:%String,OpeUser:%String") [ SqlProc ]
{
}

ClassMethod GetDeadMessageExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, AdmWard As %String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set:StartDate["/" StartDate=$zdh(StartDate,4)
	Set:StartDate["-" StartDate=$zdh(StartDate,3)
	Set:StartDate'="" StartDate=+StartDate
	Set:EndDate["/" EndDate=$zdh(EndDate,4)
	Set:EndDate["-" EndDate=$zdh(EndDate,3)
	Set:EndDate'="" EndDate=+EndDate
	Quit:(StartDate="")||(EndDate="") $$$OK
	
	Kill ^CacheTemp($zn,$j,"GetDeadMessage")
	
	For xDecDate=StartDate:1:EndDate {
		// 病人基本信息筛查
		Set xPatientID=0
		For {
			Set xPatientID=$o(^PAPERi("DecDate",xDecDate,xPatientID))
			Quit:xPatientID=""
			
			Set DeathDate=$p(^PAPER(xPatientID,"ALL"),"^",13)
			Set DeathTime=$p(^PAPER(xPatientID,"ALL"),"^",8)
			Continue:DeathDate=""
			Set ^CacheTemp($zn,$j,"GetDeadMessage",xPatientID)=$lb(DeathDate,DeathTime,"")
		}
		
		/// 死亡报告筛查
		Set xReportID=0
		For {
			Set xReportID=$o(^DHCMed.DTHi("REP","IndexDeathDate",xDecDate,xReportID))
			Quit:xReportID=""
			Set objRep=##class(DHCMed.DTH.Report).GetObjById(xReportID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.RepStatusDR)
			Set RepStatus=objRep.RepStatusDR.Description
			Continue:(RepStatus["删除")||(RepStatus["作废")||(RepStatus["草稿")
			Set PatientID=objRep.PatientID
			Set EpisodeID=objRep.EpisodeID
			If EpisodeID'="" {
				Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
			}
			Set DeathDate=objRep.DeathDate
			Set DeathTime=objRep.DeathTime
			Continue:DeathDate=""
			Set ^CacheTemp($zn,$j,"GetDeadMessage",PatientID)=$lb(DeathDate,DeathTime,EpisodeID)
		}
	}
	
	Set xPatientID=0
	For {
		Set xPatientID=$o(^CacheTemp($zn,$j,"GetDeadMessage",xPatientID))
		Quit:xPatientID=""
		
		Set PatInfo=$g(^CacheTemp($zn,$j,"GetDeadMessage",xPatientID))
		Continue:PatInfo=""
		Set DeathDate=$lg(PatInfo,1)
		Set DeathTime=$lg(PatInfo,2)
		Set EpisodeID=$lg(PatInfo,3)
		Set PatientID=xPatientID
		If EpisodeID="" {
			Set EpisodeID=$o(^PAPERdr(PatientID,"ADM","I",""),-1)
			Set tEpisodeID=$o(^PAPERdr(PatientID,"ADM","E",""),-1)
			If (tEpisodeID'="")&(tEpisodeID>EpisodeID) {
				Set EpisodeID=tEpisodeID
			}
			If EpisodeID="" {
				Set EpisodeID=$o(^PAPERdr(PatientID,"ADM","O",""),-1)
			}
			If EpisodeID="" {
				Set EpisodeID=$o(^PAPERdr(PatientID,"ADM","H",""),-1)
			}
		}
		Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
		Set:AdmType["I" DecStatus="死亡(住院)"
		Set:AdmType["E" DecStatus="死亡(急诊)"
		Set:AdmType["O" DecStatus="死亡(门诊)"
		Set:AdmType["H" DecStatus="死亡(体检)"
		
		//是否死亡,是否报告、是否三日未审数、是否审核、是否未报
		Set (DthNum,RepNum,NotRepNum,CheckRepNum,RepPatiertNum)=0
		//报告日期、报告时间、报告人、操作日期、用时、患者姓名、科室/病区、死亡日期、死亡时间
		Set (RepDate,RepTime,RepUser,RepNo,OpeDate,hour,PAADMName,LocDesc,WardDesc)=""
		
		Set DthNum=1  //是否死亡
		Set WardDr=$p(^PAADM(EpisodeID),"^",70)
		If WardDr'="" {
			Set WardDesc=$p(^PAWARD(WardDr),"^",2)
			Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		}
		Set:WardDesc="" WardDesc=LocDesc //病区为空，取科室
		
		Continue:(AdmWard'="")&(AdmWard'=WardDesc)
		Set OpeUser = ""
		//取报告信息
		Set xRepID=""
		For {
			Set xRepID=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_PatientID,xRepID),-1)
			Quit:xRepID=""
			
			Set objRep=##Class(DHCMed.DTH.Report).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.RepStatusDR)
			Set RepStatusCode=objRep.RepStatusDR.Code
			Set RepStatus=objRep.RepStatusDR.Description
			Continue:(RepStatusCode="0")||(RepStatusCode="5")||(RepStatusCode="6")  //删除、作废、草稿
			
			Set RepNum=1                              //是否报告
			Set RepDate=objRep.RepDate                //报告日期
			Set RepTime=objRep.RepTime                //报告时间
			Set RepUsrDR=objRep.RepUsrDR              //报告人
			set RepNo=objRep.RepNo                    //报告编号
			Set RepUser=$p($g(^SSU("SSUSR",+RepUsrDR)),"^",2)
			
			Set xStatus=""
			For {
				Set xStatus=$o(^DHCMed.DTH("REP",xRepID,"Status",xStatus),-1)
				Quit:xStatus=""
				
				Set objRepStatus=##Class(DHCMed.DTH.ReportStatus).GetObjById(xRepID_"||"_xStatus)
				Continue:'$IsObject(objRepStatus)
				Continue:'$IsObject(objRepStatus.StatusDR)
				Set OperStatusCode=objRepStatus.StatusDR.Code
				Set OperStatus=objRepStatus.StatusDR.Description
				Continue:OperStatusCode'="3" //审核
				Set CheckRepNum=1                       //是否审核
				Set OpeDate=objRepStatus.OpeDate        //审核日期
				Set OpeTime=objRepStatus.OpeTime        //审核时间
				Set OpeUserDR=objRepStatus.OpeUserDR    //审核人
				if ((OpeDate'="")&&(OpeTime'="")){
					Set OpeUser=$p($g(^SSU("SSUSR",+OpeUserDR)),"^",2)
				}else{
					Set OpeUser=""
				}
				
				Set:(OpeDate-RepDate)>3 NotRepNum=1     //是否三日未审
				set hour=$fn((((OpeDate-RepDate)*24)+((OpeTime-RepTime)/3600)),"",3)  //审核用时
			}
			
			Quit //退出 处理一人多份报告情况
		}
		
		Set PAADMName=$p(^PAPER(PatientID,"ALL"),"^",1)
		set IPNO=$p(^PAPER(PatientID,"PAT",1),"^",1)       ;取出病人登记号
		Set LocID=$p(^PAADM(EpisodeID),"^",4)		
		Set LocDesc=$p(^CTLOC(LocID),"^",2)
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		If HospID'="" {
			Set HospID=$tr(HospID,"^",",")
			set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,HospID)
			continue:flg<1
		}
		
	
		Set:DeathDate'="" DeathDate=$zd(DeathDate,3)
		Set:DeathTime'="" DeathTime=$zt(DeathTime,2)
		Set:RepDate'="" RepDate=$zd(RepDate,3)
		Set:RepTime'="" RepTime=$zt(RepTime,2)
		Set:OpeDate'="" OpeDate=$zd(OpeDate,3)
		Set:hour="" hour=0
		
		Set Data=$lb(LocDesc,WardDesc,PAADMName,IPNO,DeathDate,DeathTime,RepDate,RepTime,RepUser,RepNo,OpeDate,OpeUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^CacheTemp($zn,$j,"GetDeadMessage")
	
	Quit $$$OK
}

ClassMethod GetDeadMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeadMessageExecute ]
{
	set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDeadMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeadMessageExecute ]
{
	set AtEnd=$LIST(qHandle,1)
	set repid=$LIST(qHandle,2)
	set ind=$LIST(qHandle,3)
	set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		set AtEnd=1
		set Row=""
		kill ^CacheTemp(repid)
	}
	Else      {				
		set Row=^CacheTemp(repid,ind)
	}
	
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:    liulan
/// CreateDate: 2013-07-08
/// Description:更改DHCMed.DTH.PrintStatus中的打印原因
/// Input:      instr:字符串
///             separate:分割符
/// Output:     更改打印原因
/// w ##Class(DHCMed.DTHService.ReportSrv).ChargePrintReason("104^131^639^Y^^2^4^^7890-9","")
ClassMethod ChargePrintReason(instr, separate) As %String
{
	if ($g(separate)="")
	{
		set separate="^"
	}
	;set ^Temp("ChargePrintReason")=instr_","_separate
	set reportId=$p($g(instr),separate,1)
	set CtlocId=$p($g(instr),separate,2)
	set userId=$p($g(instr),separate,3)
	set PrintFlag=$p($g(instr),separate,4)
	set UserID=$p($g(instr),separate,5)
	set Code=$p($g(instr),separate,6)
	set PrintNum=$p($g(instr),separate,7)
	set TPrintNum=$p($g(instr),separate,8)
	set ResumeText=$p($g(instr),separate,9)
	if (Code="1"){
		set ResumeText="首联打印申请："_"  "_ResumeText
	}
	else{
		set ResumeText="三联打印申请："_"  "_ResumeText
	}
	set ret=1
	q:(reportId="") ret
	
	set Reportobj=##Class(DHCMed.DTH.Report).%OpenId(+reportId)
	if (Reportobj'="")
	{
		set Printobj=##Class(DHCMed.DTH.PrintStatus).%New()
		set Printobj.ParRef=Reportobj
		set currDate=+$h
		set currTime=+$p($h,",",2)
		set Printobj.OpeDate=currDate
		set Printobj.OpeTime=currTime
		set Printobj.CtlocId=CtlocId
		set Printobj.OpeUserDR=userId
		set Printobj.PrintFlag=PrintFlag
		set Printobj.UserID=UserID
		set Printobj.Code=Code
		set Printobj.PrintNum=PrintNum
		set Printobj.TPrintNum=TPrintNum
		
		set Printobj.ResumeText=ResumeText
		set retValue=Printobj.%Save()
		if ($system.Status.IsError(retValue))
		{
			do $system.OBJ.DisplayError(retValue)
			set ret=-1
		}
		do Printobj.%Close()
	}
	
	quit ret
}

/// Creator:    liulan
/// CreateDate: 2013-07-08
/// Description:更新DHCMed.DTH.PrintStatus
/// Input:      instr:字符串
///             separate:分割符
/// Output:     成功返回打印次数，失败返回-1
/// w ##Class(DHCMed.DTHService.ReportSrv).UpdateGrantFlag("98^117^9^Y^med^2^1^^,^")
ClassMethod UpdateGrantFlag(instr, separate) As %String
{
	if ($g(separate)="")
	{
		set separate="^"
	}
	;set ^temp("UpdateGrantFlag")=instr_","_separate
	set reportId=$p($g(instr),separate,1)
	set CtlocId=$p($g(instr),separate,2)
	set UserID=$p($g(instr),separate,3)  //用户代码
	set Code=$p($g(instr),separate,4)   //三联授权状态2
	set PrintNum=$p($g(instr),separate,5)
	set TPrintNum=$p($g(instr),separate,6)
	set GrantFlag=$p($g(instr),separate,7)  //Y
	set ret=1
	q:(reportId="") ret
	if (Code=1){
		set ResumeText="首联打印已授权"
	}else{
		set ResumeText="三联打印已授权"
	}
	set Reportobj=##Class(DHCMed.DTH.Report).%OpenId(+reportId)
	if (Reportobj'="")
	{
		set Printobj=##Class(DHCMed.DTH.PrintStatus).%New()
		set Printobj.ParRef=Reportobj
		set currDate=+$h
		set currTime=+$p($h,",",2)
		set Printobj.OpeDate=currDate
		set Printobj.OpeTime=currTime
		set Printobj.CtlocId=CtlocId
		set Printobj.UserID=UserID
		set Printobj.Code=Code
		set Printobj.PrintNum=PrintNum
		set Printobj.TPrintNum=TPrintNum
		set Printobj.GrantFlag=GrantFlag
		set Printobj.ResumeText=ResumeText
			
		set retValue=Printobj.%Save()
		if ($system.Status.IsError(retValue))
		{
			do $system.OBJ.DisplayError(retValue)
			set ret=-1
		}
		do Printobj.%Close()
	}
	
	quit ret
}

/// Creator:    liulan
/// CreateDate: 2013-07-08
/// Description:获取DHCMed.DTH.PrintStatus中的授权状态
/// Input:      instr:字符串
///             separate:分割符
/// Output:     返回二联打印授权状态
/// w ##Class(DHCMed.DTHService.ReportSrv).GetGrantFlagStatus("104^2^^5","")
ClassMethod GetGrantFlagStatus(instr, separate) As %String
{
	if ($g(separate)="")
	{
		set separate="^"
	}
	;set ^Temp("GetGrantFlagStatus")=instr_","_separate
	set reportId=$p($g(instr),separate,1)
	set argCode=$p($g(instr),separate,2)
	set argTPrintNum=$p($g(instr),separate,3)
	set argPrintNum=$p($g(instr),separate,4)
	set ret=0
	q:(reportId="") ret
	set PrintId=""
	for { 
		set PrintId=$o(^DHCMed.DTH("REP",reportId,"ChildPrintStatus",PrintId))
		q:PrintId=""
		set icd=reportId_"||"_PrintId
		set Printobj=##Class(DHCMed.DTH.PrintStatus).%OpenId(icd)
		set Code=Printobj.Code
		set TPrintNum=Printobj.TPrintNum
		set PrintNum=Printobj.PrintNum 
		Continue:Code'=argCode
		Continue:((TPrintNum'="")&&(TPrintNum'=argTPrintNum))
		Continue:((PrintNum'="")&&(PrintNum'=argPrintNum))
		set GrantFlag=Printobj.GrantFlag
		Continue:GrantFlag=""
		set ret=GrantFlag
	}
	quit ret
}

/// w ##Class(DHCMed.DTHService.ReportSrv).GetDescById(4569)
/// Desc
ClassMethod GetDescById(DicId)
{
	n (DicId)
	q:+DicId=0 ""
	set Dicobj=##Class(DHCMed.SS.Dictionary).%OpenId(DicId)
	set Desc=Dicobj.Description
	q Desc
}

/// w ##Class(DHCMed.DTHService.ReportSrv)GetDataById(4569)
/// Code
ClassMethod GetDataById(DicId)
{
	n (DicId)
	q:+DicId=0 ""
	set Dicobj=##Class(DHCMed.SS.Dictionary).%OpenId(DicId)
	set Code=Dicobj.Code
	q Code
}

/// 返回ID
/// w ##Class(DHCMed.DTHService.ReportSrv).GetDataByCode("","51")
ClassMethod GetDataByCode(Deathtype, DeathCode)
{
	n (Deathtype,DeathCode)
	q:(+DeathCode=0) ""
	set Deathid=0
	set renturn=""
	For {
		set Deathid=$o(^DHCMed.SS.DictionaryD(Deathid))
		quit:Deathid=""
		
		Set DHCMed=$g(^DHCMed.SS.DictionaryD(Deathid)) 
		Set Code=$list(DHCMed,3)
		Set Type=$list(DHCMed,12)
		Continue:Code'=DeathCode
		Continue:Type'=Deathtype
		
		set renturn=Deathid
	}
	q renturn
}

/// 返回ID
/// w ##Class(DHCMed.DTHService.ReportSrv).GetDataByDesc("DTHCardType","身份证")
ClassMethod GetDataByDesc(Deathtype, DeathDesc)
{
	n (Deathtype,DeathDesc)
	q:(DeathDesc="") ""
	set return=""
	
	set Deathid=0
	For {
		set Deathid=$o(^DHCMed.SS.DictionaryD(Deathid))
		quit:Deathid=""
		
		Set DHCMed=$g(^DHCMed.SS.DictionaryD(Deathid)) 
		Set Desc=$list(DHCMed,4)
		Set Type=$list(DHCMed,12)
		Continue:Type'=Deathtype
		Continue:(Desc'=DeathDesc)
		set return=Deathid
	}
	q return
}

/// d ##Class(%ResultSet).RunQuery("DHCMed.DTHService.ReportSrv","QryPrintReasonByInDate","1") 
Query QryPrintReasonByInDate(reportId As %String) As %Query(ROWSPEC = "PrintType:%String,PrintDate:%String,PrintTime:%String,PrintUser:%String,ResumeText:%String,PrintNum:%String,UserID:%String")
{
}

ClassMethod QryPrintReasonByInDateExecute(ByRef qHandle As %Binary, reportId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set repordind=1
	Set qHandle=$LB(0,repid,0)
	Kill ^TMP($zn,repid)
	
	q:(reportId="") ret
	
	Set PrintId=""
	for { 
		Set PrintId=$o(^DHCMed.DTH("REP",reportId,"ChildPrintStatus",PrintId))
		q:PrintId=""
		Set icd=reportId_"||"_PrintId
		Set Printobj=##Class(DHCMed.DTH.PrintStatus).%OpenId(icd)
		Set PrintDate=Printobj.OpeDate
		Set PrintDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(PrintDate)
		Set PrintTime=Printobj.OpeTime
		Set PrintTime=$zt(PrintTime,1)
		Set Code=Printobj.Code
		if (Code="1"){
			Set PrintType="首联打印"
		}
		else{
			Set PrintType="三联打印"
		}
		Set User=Printobj.OpeUserDR
		if ($g(User)'=""){
			Set UserObj=##Class(DHCMed.Base.SSUser).GetObjById(+User)
			if ($IsObject(UserObj)){
				Set PrintUser=UserObj.Name
			}	
		}
		if (User=""){
			Set PrintUser=""
		}
		Set TPrintNum=Printobj.TPrintNum
		if (TPrintNum'=""){
			Set PrintNum=TPrintNum
		}
		Set PrintNumber=Printobj.PrintNum
		
		if (PrintNumber'=""){
			Set PrintNum=PrintNumber
		}
		 
		Set ResumeText=Printobj.ResumeText
		Set UserID=Printobj.UserID
		
		Set ^TMP($zn,repid,repordind)=icd_"^"_PrintType_"^"_PrintDate_"^"_PrintTime_"^"_PrintUser_"^"_ResumeText_"^"_PrintNum_"^"_UserID
		Set repordind=repordind+1
	}
	
	Set repordind=0
	For {
		Set repordind=$o(^TMP($zn,repid,repordind))
		Quit:repordind=""
		
		Set PrintType=$p($g(^TMP($zn,repid,repordind)),"^",2)
		Set PrintDate=$p($g(^TMP($zn,repid,repordind)),"^",3)
		Set PrintTime=$p($g(^TMP($zn,repid,repordind)),"^",4)
		Set PrintUser=$p($g(^TMP($zn,repid,repordind)),"^",5)
		Set ResumeText=$p($g(^TMP($zn,repid,repordind)),"^",6)
		Set PrintNum=$p($g(^TMP($zn,repid,repordind)),"^",7)
		Set UserID=$p($g(^TMP($zn,repid,repordind)),"^",8)
		if (UserID=""){
			Set GrantUser=""
		} else {
			Set UserID= $o(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(UserID,"u"),""))
			if (UserID=""){
				Set GrantUser=""
			} else {
				Set GrantUser=$p(^SSU("SSUSR",UserID),"^",2)
			}	
		}
		Set Data=$lb(PrintType,PrintDate,PrintTime,PrintUser,ResumeText,PrintNum,GrantUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	    
	}
	kill ^TMP($zn,repid)
	Quit $$$OK
}

ClassMethod QryPrintReasonByInDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrintReasonByInDateExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPrintReasonByInDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrintReasonByInDateExecute ]
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

/// w ##Class(DHCMed.DTHService.ReportSrv).GetReportID("产品维护")
ClassMethod GetReportID(DthMenudesc)
{
	n (DthMenudesc)
	q:(DthMenudesc="") ""
	
	Set return=""
	set DthMenuid=0
	For {
		set DthMenuid=$o(^DHCMed.SS.MenusD(DthMenuid))
		quit:DthMenuid=""
		
		Set DthMenus=$g(^DHCMed.SS.MenusD(DthMenuid)) 
		Set:DthMenus'="" MenuCaption=$list(DthMenus,2)
		continue:MenuCaption'=DthMenudesc
		set return=DthMenuid
	}
	q return
}

/*
///旧版二联打印
/// w ##Class(DHCMed.DTHService.ReportSrv).DMReportPrint("fillxlSheet",1)
ClassMethod DMTwoReportPrint(itmjs As %String, ReportID As %String) As %String
{
	n (itmjs,ReportID)
	s Count=0
	
	s ds = ##class(%Library.ResultSet).%New("DHCMed.DTHService.ReportSrv:DMReportPrint")
	d ds.Execute(ReportID)
	
	d ds.Next()
	
	s DeathNo=ds.Data("DeathNo")
	s Name=ds.Data("Name")
	s Sex=ds.Data("Sex")
	s Age=ds.Data("Age")
	s Nation=ds.Data("Nation")
	s Marital=ds.Data("Marital")
	s CardType=ds.Data("CardType")
	s Identify=ds.Data("Identify")
	s Birthday=ds.Data("Birthday")
	s Education=ds.Data("Education")
	s Occupation=ds.Data("Occupation")
	s DeathDateTime=ds.Data("DeathDateTime")
	s DeathPlace=ds.Data("DeathPlace")
	s Company=ds.Data("Company")
	s RegAddress=ds.Data("RegAddress")
	s CurrAddress=ds.Data("CurrAddress")
	s Pregnancies=ds.Data("Pregnancies")
	s FamName=ds.Data("FamName")
	s FamTel=ds.Data("FamTel")
	s FamAddr=ds.Data("FamAddr")
	s AReason=ds.Data("AReason")
	s BReason=ds.Data("BReason")
	s CReason=ds.Data("CReason")
	s DReason=ds.Data("DReason")
	s AInterval=ds.Data("AInterval")
	s BInterval=ds.Data("BInterval")
	s CInterval=ds.Data("CInterval")
	s DInterval=ds.Data("DInterval")
	s OtherDiagnose=ds.Data("OtherDiagnose")
	s DiagnoseUnit=ds.Data("DiagnoseUnit")
	s DiagnoseBasis=ds.Data("DiagnoseBasis")
	s PapmiNo=ds.Data("PapmiNo")
	s RepDate=ds.Data("RepDate")
	s MrNo=ds.Data("MrNo")
	s:MrNo'="" PapmiNo=MrNo	//当病案号不为空时打印病案号，否则打印ID号
	s CurrAddress=ds.Data("CurrAddress")
	s BaseReason=ds.Data("BaseReason")
	s Country=ds.Data("Country")
	
	
	s ExamMedical=ds.Data("ExamMedical")
	s ExamName=ds.Data("ExamName")
	s ExamDate=ds.Data("ExamDate")
	s ExamRelation=ds.Data("ExamRelation")
	s ExamAddress=ds.Data("ExamAddress")
	s ExamTel=ds.Data("ExamTel")
	s ExamDeathReason=ds.Data("ExamDeathReason")
	s examUserName=ds.Data("examUserName")
	
	s ExamDate=ds.Data("ExamDate")
	s ResumeText=ds.Data("ResumeText")
	s Country=ds.Data("Country")
	s MrNo=ds.Data("MrNo")
	s BaseReasonICD=ds.Data("BaseReasonICD")
	s RepDocName=ds.Data("RepDocName")
	
	s DamageReason=ds.Data("DamageReason")
	s DamageReasonICD=ds.Data("DamageReasonICD")
	
	//死亡编号
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathNo,"O","JS")_"',"_2_",8);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Country,"O","JS")_"',"_4_",8);"
	&javascript<#(retval)#>
	
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_3_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_3_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_3_",12);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_4_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Marital,"O","JS")_"',"_4_",12);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CardType,"O","JS")_"',"_5_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_5_",10);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_6_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Education,"O","JS")_"',"_6_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Occupation,"O","JS")_"',"_6_",12);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_7_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathPlace,"O","JS")_"',"_7_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Company,"O","JS")_"',"_8_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_9_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CurrAddress,"O","JS")_"',"_10_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Pregnancies,"O","JS")_"',"_8_",12);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_11_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_11_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_12_",9);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AReason,"O","JS")_"',"_14_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BReason,"O","JS")_"',"_15_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CReason,"O","JS")_"',"_16_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DReason,"O","JS")_"',"_17_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AInterval,"O","JS")_"',"_14_",13);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BInterval,"O","JS")_"',"_15_",13);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CInterval,"O","JS")_"',"_16_",13);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DInterval,"O","JS")_"',"_17_",13);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(OtherDiagnose,"O","JS")_"',"_18_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DiagnoseUnit,"O","JS")_"',"_19_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DiagnoseBasis,"O","JS")_"',"_20_",10);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PapmiNo,"O","JS")_"',"_21_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',"_22_",11);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathNo,"O","JS")_"',"_2_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_3_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_4_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_5_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_6_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_7_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_8_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CurrAddress,"O","JS")_"',"_10_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BaseReason,"O","JS")_"',"_12_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_13_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_14_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_16_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_23_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(MrNo,"O","JS")_"',"_24_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ResumeText,"O","JS")_"',"_25_",2);"
	&javascript<#(retval)#>
	
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamMedical,"O","JS")_"',"_5_",14);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamName,"O","JS")_"',"_18_",15);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamDate,"O","JS")_"',"_19_",15);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamRelation,"O","JS")_"',"_20_",15);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamAddress,"O","JS")_"',"_21_",15);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamTel,"O","JS")_"',"_22_",15);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamDeathReason,"O","JS")_"',"_23_",15);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(examUserName,"O","JS")_"',"_24_",15);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamDate,"O","JS")_"',"_25_",15);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BaseReason,"O","JS")_"',"_24_",8);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DamageReason,"O","JS")_"',"_25_",8);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DamageReasonICD,"O","JS")_"',"_25_",11);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BaseReasonICD,"O","JS")_"',"_24_",11);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BaseReasonICD,"O","JS")_"',"_24_",11);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDocName,"O","JS")_"',"_19_",1);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDocName,"O","JS")_"',"_21_",11);"
	&javascript<#(retval)#>
	d ds.Close()
	
	q 1
}
*/
/// CreateDate: 2013-07-08
/// Description:获取DHCMed_DTH.ReportStatus中的报告状态
/// Input:      instr:字符串
///             separate:分割符
/// Output:     返回报告的状态
/// w ##Class(DHCMed.DTHService.ReportSrv).GetReportStatus("144")
ClassMethod GetReportStatus(reportId) As %String
{
   
	set ret=""
	q:(reportId="") ret
	
	set repObj=##Class(DHCMed.DTH.Report).GetObjById(+reportId)
	quit:'$IsObject(repObj) ret
	set Code=repObj.RepStatusDR.Code
	set ret=Code
	
	quit ret
}

/// CreateDate: 2013-07-08
/// Description:获取DHCMed_DTH.ReportStatus中的报告状态
/// Input:      instr:字符串
///             separate:分割符
/// Output:     返回报告的状态
/// w ##Class(DHCMed.DTHService.ReportSrv).GetReportStatusDesc("144")
ClassMethod GetReportStatusDesc(reportId) As %String
{
   
	n (reportId,%session)
	set ret=""
	q:(reportId="") ret
	Set Languages = "CH"
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
		Set:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set repObj=##Class(DHCMed.DTH.Report).GetObjById(+reportId)
	quit:'$IsObject(repObj) ret
	set Desc=repObj.RepStatusDR.Description
	Set Desc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,Desc)
	set ret=Desc
	
	quit ret
}

/// CreateDate: 2013-12-16
/// Description:判断报告是否打印
/// w ##Class(DHCMed.DTHService.ReportSrv).GetIsPrintByID("144",2)
ClassMethod GetIsPrintByID(ReportID As %String, PrintType As %String) As %String
{
	New (PrintType,ReportID)	
	
	Set Return=""
	
	Quit:(ReportID="")||(PrintType="") Return
	
	Quit:'$d(^DHCMed.DTH("REP",ReportID,"ChildPrintStatus")) Return
	
	Set SubID=""
	For {
		Set SubID=$o(^DHCMed.DTH("REP",ReportID,"ChildPrintStatus",SubID))
		Quit:SubID=""
		
		Set PrtObj=##class(DHCMed.DTH.PrintStatus).%OpenId(ReportID_"||"_SubID)
		Continue:'$IsObject(PrtObj)
		
		Set Code=PrtObj.Code
		Set PrintFlag=PrtObj.PrintFlag
		Set:(PrintType=Code)&&(PrintFlag="Y") Return=1
	}
	
	Quit Return
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// w ##Class(DHCMed.DTHService.ReportSrv).GetServerInfo()
ClassMethod GetServerInfo()
{
	n
	Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	//Set Server=Config.WebServer
	Set Server=$p(Config.LayoutManager,":",2)
	Set Path=Config.PathToReports
	Set LayOutManager=Config.LayoutManager
	Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
	// Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
	d Config.%Close()
	s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

/// 新版三联打印
/// w ##Class(DHCMed.DTHService.ReportSrv).DMReportThreePrintNew("fillxlSheet",1)
ClassMethod DMReportThreePrintNew(itmjs As %String, ReportID As %String, PrintIDs As %String = "", FlagIDs As %String = "") As %String
{
	n (itmjs,ReportID,PrintIDs,FlagIDs)
	s Count=0
	s ds = ##class(%Library.ResultSet).%New("DHCMed.DTHService.ReportSrv:DMReportPrint")
	d ds.Execute(ReportID)
	
	d ds.Next()
	s (switchPrint,OnePrintCode,TwoPrintCode,ThreePrintCode,AddPrintCode)=""
	s OnePrint = $p(PrintIDs,"^",1)
	s TwoPrint = $p(PrintIDs,"^",2)
	s ThreePrint = $p(PrintIDs,"^",3)
	s AddPrint =$p(FlagIDs,"^",1)   //补打
	if (OnePrint'=""){
		s objOnePrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+OnePrint)
		if $IsObject(objOnePrint) {
			s OnePrintCode = objOnePrint.Code
		}
	}
	if (TwoPrint'=""){
		s objTwoPrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+TwoPrint)
		if $IsObject(objTwoPrint) {
			s TwoPrintCode = objTwoPrint.Code
		}
	}
	if (ThreePrint'=""){
		s objThreePrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+ThreePrint)
		if $IsObject(objThreePrint) {
			s ThreePrintCode = objThreePrint.Code
		}
	}
	if (AddPrint'=""){
		s objAddPrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+AddPrint)
		if $IsObject(objAddPrint) {
			s AddPrintCode = objAddPrint.Code
		} else {
			if (AddPrint="Yes") {
				s AddPrintCode=1
			}
		}
	}
	if (PrintIDs="") {
		s switchPrint="123"
	} else {
		s switchPrint = OnePrintCode_TwoPrintCode_ThreePrintCode
	}
	s PaperNo=ds.Data("PaperNo")
	s:PaperNo'="" PaperNo="No."_PaperNo
	s DeathNo=ds.Data("DeathNo")
	s Name=ds.Data("Name")
	s Sex=ds.Data("Sex")
	s Age=ds.Data("Age")
	s Nation=ds.Data("Nation")
	s MaritalID=ds.Data("Marital")
	s Marital=..GetDescById(MaritalID)
	s CardTypeID=ds.Data("CardType")
	s CardType=..GetDescById(CardTypeID)
	s Identify=ds.Data("Identify")
	s Identify=Identify
	s Birthday=ds.Data("Birthday")
	s EducationID=ds.Data("Education")
	s Education=..GetDescById(EducationID)
	s OccupationID=ds.Data("Occupation")
	s Occupation=..GetDescById(OccupationID)
	s DeathDateTime=ds.Data("DeathDateTime")
	s DeathPlaceID=ds.Data("DeathPlace")
	s DeathPlace =..GetDescById(DeathPlaceID)
	s Company=ds.Data("Company")
	s RegAddress=ds.Data("RegAddress")
	s CurrAddress=ds.Data("CurrAddress")
	s Pregnancies=ds.Data("Pregnancies")
	s FamName=ds.Data("FamName")
	s FamTel=ds.Data("FamTel")
	s FamAddr=ds.Data("FamAddr")
	s AReason=ds.Data("AReason")
	s BReason=ds.Data("BReason")
	s CReason=ds.Data("CReason")
	s DReason=ds.Data("DReason")
	s AInterval=ds.Data("AInterval")
	s BInterval=ds.Data("BInterval")
	s CInterval=ds.Data("CInterval")
	s DInterval=ds.Data("DInterval")
	s OtherDiagnose=ds.Data("OtherDiagnose")
	s DiagnoseUnit=ds.Data("DiagnoseUnit")
	s DiagnoseBasis=ds.Data("DiagnoseBasis")
	s PapmiNo=ds.Data("PapmiNo")
	s RepDate=ds.Data("RepDate")
	s MrNo=ds.Data("MrNo")
	//s:MrNo'="" PapmiNo=MrNo	//当病案号不为空时打印病案号，否则打印ID号
	s CurrAddress=ds.Data("CurrAddress")
	s BaseReason=ds.Data("BaseReason")
	s Country=ds.Data("Country")
	s RepDocName=ds.Data("RepDocName")
	//打印电子签名（判断报告是否进行CA认证）
	Set IsSign=##Class(DHCMed.CA.SignVerify).GetRepIsSign("DTH","DTH",ReportID,"S")
	Set:IsSign=1 RepDocName=""
	
	//行政区 县/区
	s MEPDCountyCode=ds.Data("MEPDCountyCode")
	set SwitchPrint = ##Class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-SwitchPrint","")  //配置项的选择打印
	if (SwitchPrint=1){
		if (AddPrintCode["1") {
			s retval=itmjs_"(xlSheet,'"_$ZCVT("居民死亡医学证明（推断）书  【补】","O","JS")_"',"_1_",1);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT("居民死亡医学证明（推断）书  【补】","O","JS")_"',"_14_",1);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT("居民死亡医学证明（推断）书  【补】","O","JS")_"',"_27_",1);"
			&javascript<#(retval)#>
		}
		if (switchPrint["1") {   //传入的参数选择打印
			
			//协和
			//纸单号
			s retval=itmjs_"(xlSheet,'"_$ZCVT(PaperNo,"O","JS")_"',"_1_",22);"
			&javascript<#(retval)#>
			//行政区划代码
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,1),"O","JS")_"',"_3_",4);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,2),"O","JS")_"',"_3_",5);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,3),"O","JS")_"',"_3_",6);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,4),"O","JS")_"',"_3_",7);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,5),"O","JS")_"',"_3_",8);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,6),"O","JS")_"',"_3_",9);"
			&javascript<#(retval)#>
			//死亡编号
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,1),"O","JS")_"',"_3_",12);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,2),"O","JS")_"',"_3_",13);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,3),"O","JS")_"',"_3_",14);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,4),"O","JS")_"',"_3_",15);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,5),"O","JS")_"',"_3_",16);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,6),"O","JS")_"',"_3_",17);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,7),"O","JS")_"',"_3_",18);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,8),"O","JS")_"',"_3_",19);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,9),"O","JS")_"',"_3_",20);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,10),"O","JS")_"',"_3_",21);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,11),"O","JS")_"',"_3_",22);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,12),"O","JS")_"',"_3_",23);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,13),"O","JS")_"',"_3_",24);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,14),"O","JS")_"',"_3_",25);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,15),"O","JS")_"',"_3_",26);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,16),"O","JS")_"',"_3_",27);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,17),"O","JS")_"',"_3_",28);"
			&javascript<#(retval)#>
			//姓名
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_5_",3);"
			&javascript<#(retval)#>
			//性别
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_5_",6);"
			&javascript<#(retval)#>
			//民族
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_5_",11);"
			&javascript<#(retval)#>
			//国家
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Country,"O","JS")_"',"_5_",15);"
			&javascript<#(retval)#>
			//年龄
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_5_",24);"
			&javascript<#(retval)#>
			//身份证件类别
			s retval=itmjs_"(xlSheet,'"_$ZCVT(CardType,"O","JS")_"',"_6_",3);"
			&javascript<#(retval)#>
			//证件号码
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_6_",6);"
			&javascript<#(retval)#>
			//常住地址
			s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_6_",12);"
			&javascript<#(retval)#>
			//出生日期
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_7_",3);"
			&javascript<#(retval)#>
			//死亡日期
			s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_7_",6);"
			&javascript<#(retval)#>
			//死亡地点
			s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathPlace,"O","JS")_"',"_7_",12);"
			&javascript<#(retval)#>
			//死亡原因【根本死因】
			s retval=itmjs_"(xlSheet,'"_$ZCVT(AReason,"O","JS")_"',"_8_",3);"
			&javascript<#(retval)#>
			//家属姓名
			s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_8_",11);"
			&javascript<#(retval)#>
			//联系电话
			s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_8_",23);"
			&javascript<#(retval)#>
			//家属住址
			s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_9_",3);"
			&javascript<#(retval)#>
			//医生签名
			s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDocName,"O","JS")_"',"_9_",11);"
			&javascript<#(retval)#>
			
		}
		if (switchPrint["2") {
			
			//协和
			//纸单号
			s retval=itmjs_"(xlSheet,'"_$ZCVT(PaperNo,"O","JS")_"',"_14_",22);"
			&javascript<#(retval)#>
			//行政区划代码
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,1),"O","JS")_"',"_16_",4);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,2),"O","JS")_"',"_16_",5);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,3),"O","JS")_"',"_16_",6);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,4),"O","JS")_"',"_16_",7);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,5),"O","JS")_"',"_16_",8);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,6),"O","JS")_"',"_16_",9);"
			&javascript<#(retval)#>
			//死亡编号
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,1),"O","JS")_"',"_16_",12);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,2),"O","JS")_"',"_16_",13);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,3),"O","JS")_"',"_16_",14);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,4),"O","JS")_"',"_16_",15);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,5),"O","JS")_"',"_16_",16);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,6),"O","JS")_"',"_16_",17);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,7),"O","JS")_"',"_16_",18);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,8),"O","JS")_"',"_16_",19);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,9),"O","JS")_"',"_16_",20);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,10),"O","JS")_"',"_16_",21);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,11),"O","JS")_"',"_16_",22);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,12),"O","JS")_"',"_16_",23);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,13),"O","JS")_"',"_16_",24);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,14),"O","JS")_"',"_16_",25);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,15),"O","JS")_"',"_16_",26);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,16),"O","JS")_"',"_16_",27);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,17),"O","JS")_"',"_16_",28);"
			&javascript<#(retval)#>
			//姓名
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_18_",3);"
			&javascript<#(retval)#>
			//性别
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_18_",6);"
			&javascript<#(retval)#>
			//民族
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_18_",11);"
			&javascript<#(retval)#>
			//国家
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Country,"O","JS")_"',"_18_",15);"
			&javascript<#(retval)#>
			//年龄
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_18_",24);"
			&javascript<#(retval)#>
			//身份证件类别
			s retval=itmjs_"(xlSheet,'"_$ZCVT(CardType,"O","JS")_"',"_19_",3);"
			&javascript<#(retval)#>
			//证件号码
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_19_",6);"
			&javascript<#(retval)#>
			//常住地址
			s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_19_",12);"
			&javascript<#(retval)#>
			//出生日期
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_20_",3);"
			&javascript<#(retval)#>
			//死亡日期
			s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_20_",6);"
			&javascript<#(retval)#>
			//死亡地点
			s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathPlace,"O","JS")_"',"_20_",12);"
			&javascript<#(retval)#>
			//死亡原因【根本死因】
			s retval=itmjs_"(xlSheet,'"_$ZCVT(AReason,"O","JS")_"',"_21_",3);"
			&javascript<#(retval)#>
			//家属姓名
			s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_21_",11);"
			&javascript<#(retval)#>
			//联系电话
			s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_21_",23);"
			&javascript<#(retval)#>
			//家属住址
			s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_22_",3);"
			&javascript<#(retval)#>
			//医生签名
			s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDocName,"O","JS")_"',"_22_",11);"
			&javascript<#(retval)#>
			
		}
		if (switchPrint["3") {
			
			
			//协和
			//纸单号
			s retval=itmjs_"(xlSheet,'"_$ZCVT(PaperNo,"O","JS")_"',"_27_",22);"
			&javascript<#(retval)#>
			//行政区划代码
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,1),"O","JS")_"',"_29_",4);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,2),"O","JS")_"',"_29_",5);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,3),"O","JS")_"',"_29_",6);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,4),"O","JS")_"',"_29_",7);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,5),"O","JS")_"',"_29_",8);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,6),"O","JS")_"',"_29_",9);"
			&javascript<#(retval)#>
			//死亡编号
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,1),"O","JS")_"',"_29_",12);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,2),"O","JS")_"',"_29_",13);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,3),"O","JS")_"',"_29_",14);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,4),"O","JS")_"',"_29_",15);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,5),"O","JS")_"',"_29_",16);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,6),"O","JS")_"',"_29_",17);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,7),"O","JS")_"',"_29_",18);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,8),"O","JS")_"',"_29_",19);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,9),"O","JS")_"',"_29_",20);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,10),"O","JS")_"',"_29_",21);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,11),"O","JS")_"',"_29_",22);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,12),"O","JS")_"',"_29_",23);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,13),"O","JS")_"',"_29_",24);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,14),"O","JS")_"',"_29_",25);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,15),"O","JS")_"',"_29_",26);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,16),"O","JS")_"',"_29_",27);"
			&javascript<#(retval)#>
			s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,17),"O","JS")_"',"_29_",28);"
			&javascript<#(retval)#>
			//姓名
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_31_",3);"
			&javascript<#(retval)#>
			//性别
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_31_",6);"
			&javascript<#(retval)#>
			//民族
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_31_",11);"
			&javascript<#(retval)#>
			//国家
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Country,"O","JS")_"',"_31_",15);"
			&javascript<#(retval)#>
			//年龄
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_31_",24);"
			&javascript<#(retval)#>
			//身份证件类别
			s retval=itmjs_"(xlSheet,'"_$ZCVT(CardType,"O","JS")_"',"_32_",3);"
			&javascript<#(retval)#>
			//证件号码
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_32_",6);"
			&javascript<#(retval)#>
			//常住地址
			s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_32_",12);"
			&javascript<#(retval)#>
			//出生日期
			s retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_33_",3);"
			&javascript<#(retval)#>
			//死亡日期
			s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_33_",6);"
			&javascript<#(retval)#>
			//死亡地点
			s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathPlace,"O","JS")_"',"_33_",12);"
			&javascript<#(retval)#>
			//死亡原因【根本死因】
			s retval=itmjs_"(xlSheet,'"_$ZCVT(AReason,"O","JS")_"',"_34_",3);"
			&javascript<#(retval)#>
			//家属姓名
			s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_34_",11);"
			&javascript<#(retval)#>
			//联系电话
			s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_34_",23);"
			&javascript<#(retval)#>
			//家属住址
			s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_35_",3);"
			&javascript<#(retval)#>
			//医生签名
			s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDocName,"O","JS")_"',"_35_",11);"
			&javascript<#(retval)#>
			
		}
	} else {
		
		//协和
		//纸单号
		s retval=itmjs_"(xlSheet,'"_$ZCVT(PaperNo,"O","JS")_"',"_1_",22);"
		&javascript<#(retval)#>
		//行政区划代码
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,1),"O","JS")_"',"_3_",4);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,2),"O","JS")_"',"_3_",5);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,3),"O","JS")_"',"_3_",6);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,4),"O","JS")_"',"_3_",7);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,5),"O","JS")_"',"_3_",8);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,6),"O","JS")_"',"_3_",9);"
		&javascript<#(retval)#>
		//死亡编号
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,1),"O","JS")_"',"_3_",12);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,2),"O","JS")_"',"_3_",13);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,3),"O","JS")_"',"_3_",14);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,4),"O","JS")_"',"_3_",15);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,5),"O","JS")_"',"_3_",16);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,6),"O","JS")_"',"_3_",17);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,7),"O","JS")_"',"_3_",18);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,8),"O","JS")_"',"_3_",19);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,9),"O","JS")_"',"_3_",20);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,10),"O","JS")_"',"_3_",21);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,11),"O","JS")_"',"_3_",22);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,12),"O","JS")_"',"_3_",23);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,13),"O","JS")_"',"_3_",24);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,14),"O","JS")_"',"_3_",25);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,15),"O","JS")_"',"_3_",26);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,16),"O","JS")_"',"_3_",27);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,17),"O","JS")_"',"_3_",28);"
		&javascript<#(retval)#>
		//姓名
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_5_",3);"
		&javascript<#(retval)#>
		//性别
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_5_",6);"
		&javascript<#(retval)#>
		//民族
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_5_",11);"
		&javascript<#(retval)#>
		//国家
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Country,"O","JS")_"',"_5_",15);"
		&javascript<#(retval)#>
		//年龄
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_5_",24);"
		&javascript<#(retval)#>
		//身份证件类别
		s retval=itmjs_"(xlSheet,'"_$ZCVT(CardType,"O","JS")_"',"_6_",3);"
		&javascript<#(retval)#>
		//证件号码
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_6_",6);"
		&javascript<#(retval)#>
		//常住地址
		s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_6_",12);"
		&javascript<#(retval)#>
		//出生日期
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_7_",3);"
		&javascript<#(retval)#>
		//死亡日期
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_7_",6);"
		&javascript<#(retval)#>
		//死亡地点
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathPlace,"O","JS")_"',"_7_",12);"
		&javascript<#(retval)#>
		//死亡原因【根本死因】
		s retval=itmjs_"(xlSheet,'"_$ZCVT(AReason,"O","JS")_"',"_8_",3);"
		&javascript<#(retval)#>
		//家属姓名
		s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_8_",11);"
		&javascript<#(retval)#>
		//联系电话
		s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_8_",23);"
		&javascript<#(retval)#>
		//家属住址
		s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_9_",3);"
		&javascript<#(retval)#>
		//医生签名
		s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDocName,"O","JS")_"',"_9_",11);"
		&javascript<#(retval)#>	
		//纸单号
		s retval=itmjs_"(xlSheet,'"_$ZCVT(PaperNo,"O","JS")_"',"_14_",22);"
		&javascript<#(retval)#>
		//行政区划代码
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,1),"O","JS")_"',"_16_",4);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,2),"O","JS")_"',"_16_",5);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,3),"O","JS")_"',"_16_",6);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,4),"O","JS")_"',"_16_",7);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,5),"O","JS")_"',"_16_",8);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,6),"O","JS")_"',"_16_",9);"
		&javascript<#(retval)#>
		//死亡编号
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,1),"O","JS")_"',"_16_",12);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,2),"O","JS")_"',"_16_",13);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,3),"O","JS")_"',"_16_",14);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,4),"O","JS")_"',"_16_",15);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,5),"O","JS")_"',"_16_",16);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,6),"O","JS")_"',"_16_",17);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,7),"O","JS")_"',"_16_",18);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,8),"O","JS")_"',"_16_",19);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,9),"O","JS")_"',"_16_",20);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,10),"O","JS")_"',"_16_",21);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,11),"O","JS")_"',"_16_",22);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,12),"O","JS")_"',"_16_",23);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,13),"O","JS")_"',"_16_",24);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,14),"O","JS")_"',"_16_",25);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,15),"O","JS")_"',"_16_",26);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,16),"O","JS")_"',"_16_",27);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,17),"O","JS")_"',"_16_",28);"
		&javascript<#(retval)#>
		//姓名
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_18_",3);"
		&javascript<#(retval)#>
		//性别
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_18_",6);"
		&javascript<#(retval)#>
		//民族
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_18_",11);"
		&javascript<#(retval)#>
		//国家
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Country,"O","JS")_"',"_18_",15);"
		&javascript<#(retval)#>
		//年龄
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_18_",24);"
		&javascript<#(retval)#>
		//身份证件类别
		s retval=itmjs_"(xlSheet,'"_$ZCVT(CardType,"O","JS")_"',"_19_",3);"
		&javascript<#(retval)#>
		//证件号码
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_19_",6);"
		&javascript<#(retval)#>
		//常住地址
		s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_19_",12);"
		&javascript<#(retval)#>
		//出生日期
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_20_",3);"
		&javascript<#(retval)#>
		//死亡日期
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_20_",6);"
		&javascript<#(retval)#>
		//死亡地点
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathPlace,"O","JS")_"',"_20_",12);"
		&javascript<#(retval)#>
		//死亡原因【根本死因】
		s retval=itmjs_"(xlSheet,'"_$ZCVT(AReason,"O","JS")_"',"_21_",3);"
		&javascript<#(retval)#>
		//家属姓名
		s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_21_",11);"
		&javascript<#(retval)#>
		//联系电话
		s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_21_",23);"
		&javascript<#(retval)#>
		//家属住址
		s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_22_",3);"
		&javascript<#(retval)#>
		//医生签名
		s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDocName,"O","JS")_"',"_22_",11);"
		&javascript<#(retval)#>	
		//纸单号
		s retval=itmjs_"(xlSheet,'"_$ZCVT(PaperNo,"O","JS")_"',"_27_",22);"
		&javascript<#(retval)#>
		//行政区划代码
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,1),"O","JS")_"',"_29_",4);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,2),"O","JS")_"',"_29_",5);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,3),"O","JS")_"',"_29_",6);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,4),"O","JS")_"',"_29_",7);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,5),"O","JS")_"',"_29_",8);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,6),"O","JS")_"',"_29_",9);"
		&javascript<#(retval)#>
		//死亡编号
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,1),"O","JS")_"',"_29_",12);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,2),"O","JS")_"',"_29_",13);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,3),"O","JS")_"',"_29_",14);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,4),"O","JS")_"',"_29_",15);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,5),"O","JS")_"',"_29_",16);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,6),"O","JS")_"',"_29_",17);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,7),"O","JS")_"',"_29_",18);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,8),"O","JS")_"',"_29_",19);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,9),"O","JS")_"',"_29_",20);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,10),"O","JS")_"',"_29_",21);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,11),"O","JS")_"',"_29_",22);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,12),"O","JS")_"',"_29_",23);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,13),"O","JS")_"',"_29_",24);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,14),"O","JS")_"',"_29_",25);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,15),"O","JS")_"',"_29_",26);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,16),"O","JS")_"',"_29_",27);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,17),"O","JS")_"',"_29_",28);"
		&javascript<#(retval)#>
		//姓名
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_31_",3);"
		&javascript<#(retval)#>
		//性别
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_31_",6);"
		&javascript<#(retval)#>
		//民族
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_31_",11);"
		&javascript<#(retval)#>
		//国家
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Country,"O","JS")_"',"_31_",15);"
		&javascript<#(retval)#>
		//年龄
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_31_",24);"
		&javascript<#(retval)#>
		//身份证件类别
		s retval=itmjs_"(xlSheet,'"_$ZCVT(CardType,"O","JS")_"',"_32_",3);"
		&javascript<#(retval)#>
		//证件号码
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_32_",6);"
		&javascript<#(retval)#>
		//常住地址
		s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_32_",12);"
		&javascript<#(retval)#>
		//出生日期
		s retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_33_",3);"
		&javascript<#(retval)#>
		//死亡日期
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_33_",6);"
		&javascript<#(retval)#>
		//死亡地点
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathPlace,"O","JS")_"',"_33_",12);"
		&javascript<#(retval)#>
		//死亡原因【根本死因】
		s retval=itmjs_"(xlSheet,'"_$ZCVT(AReason,"O","JS")_"',"_34_",3);"
		&javascript<#(retval)#>
		//家属姓名
		s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_34_",11);"
		&javascript<#(retval)#>
		//联系电话
		s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_34_",23);"
		&javascript<#(retval)#>
		//家属住址
		s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_35_",3);"
		&javascript<#(retval)#>
		//医生签名
		s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDocName,"O","JS")_"',"_35_",11);"
		&javascript<#(retval)#>	
	}
	d ds.Close()
	q 1
}

/// w ##Class(DHCMed.DTHService.ReportSrv).DMBaseReportPrint("fillxlSheet",1)
ClassMethod DMBaseReportPrint(itmjs As %String, ReportID As %String) As %String
{
	n (itmjs,ReportID)
	s Count=0
	
	s ds = ##class(%Library.ResultSet).%New("DHCMed.DTHService.ReportSrv:DMReportPrint")
	d ds.Execute(ReportID)
	
	d ds.Next()
	
	s PapmiNo=ds.Data("PapmiNo")
	s MrNo=ds.Data("MrNo")
	s Name=ds.Data("Name")
	s Sex=ds.Data("Sex")
	s Age=ds.Data("Age")
	s Nation=ds.Data("Nation")
	//s CardType=ds.Data("CardType")_"*"	//证件类型
	s CardTypeID=ds.Data("CardType")
	s CardType = ..GetDescById(CardTypeID)_"号码"
	s Identify=ds.Data("Identify")
	s Birthday=ds.Data("Birthday")
	s MaritalID=ds.Data("Marital")
	s Marital = ..GetDescById(MaritalID)
	s EducationID=ds.Data("Education")
	s Education = ..GetDescById(EducationID)
	s OccupationID=ds.Data("Occupation")
	s Occupation = ..GetDescById(OccupationID)
	s Company=ds.Data("Company")
	s RegAddress=ds.Data("RegAddress")
	s CurrAddress=ds.Data("CurrAddress")
	s FamName=ds.Data("FamName")
	s FamTel=ds.Data("FamTel")
	s FamAddr=ds.Data("FamAddr")
	s DeathDateTime=ds.Data("DeathDateTime")
	s DeathPlaceID=ds.Data("DeathPlace")
	s DeathPlace = ..GetDescById(DeathPlaceID)
	s RepDocName=ds.Data("RepDocName")
	s examUserName=ds.Data("examUserName")
	s FamIdentify=ds.Data("FamIdentify")
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PapmiNo,"O","JS")_"',"_2_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(MrNo,"O","JS")_"',"_2_",6);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_3_",2);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_3_",4);"
	&javascript<#(retval)#>
	
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_3_",6);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_4_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CardType,"O","JS")_"',"_4_",3);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_4_",4);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_4_",6);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Marital,"O","JS")_"',"_5_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Education,"O","JS")_"',"_5_",4);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Occupation,"O","JS")_"',"_5_",6);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Company,"O","JS")_"',"_6_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_7_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_8_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_8_",5);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_9_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_10_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathPlace,"O","JS")_"',"_10_",5);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamIdentify,"O","JS")_"',"_11_",2);"
	&javascript<#(retval)#>
	d ds.Close()
	
	q 1
}

/// 新版首联打印
/// w ##Class(DHCMed.DTHService.ReportSrv).DMTwoReportPrintNew("fillxlSheet",1)
ClassMethod DMTwoReportPrintNew(itmjs As %String, ReportID As %String, FlagIDs As %String = "") As %String
{
	n (itmjs,ReportID,FlagIDs)
	s return=1,Count=0
	q:ReportID="" return
	
	set objReport=##class(DHCMed.DTH.Report).GetObjById(ReportID)
	quit:'$IsObject(objReport) return
	set EpisodeID=objReport.EpisodeID
	quit:EpisodeID="" return
	set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	quit:AdmLoc="" return
	set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	quit:CTHospID="" return
	//set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(CTHospID,"DTH")
	//quit:SSHospCode="" return
	
	//add by niepeng 取青医附院各院地址
	set DeathHospAddress=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-DeathHospAddress",CTHospID)
	//quit:DeathHospAddress="" return
	s ds = ##class(%Library.ResultSet).%New("DHCMed.DTHService.ReportSrv:DMReportPrint")
	d ds.Execute(ReportID)
	
	d ds.Next()
	
	s DeathNo=ds.Data("DeathNo")
	s Name=ds.Data("Name")
	s Sex=ds.Data("Sex")
	s Age=ds.Data("Age")
	s Nation=ds.Data("Nation")
	s MaritalID=ds.Data("Marital")
	s Marital = ..GetDescById(MaritalID)
	s CardTypeID=ds.Data("CardType")
	s CardType = ..GetDescById(CardTypeID)
	s PaperNo=ds.Data("PaperNo")
	s:PaperNo'="" PaperNo="No."_PaperNo
	s Identify=ds.Data("Identify")
	s Identify=Identify   //add by niepeng 打印完整显示
	s Birthday=ds.Data("Birthday")
	s EducationID=ds.Data("Education")
	s Education = ..GetDescById(EducationID)
	s OccupationID=ds.Data("Occupation")
	s Occupation = ..GetDescById(OccupationID)
	s DeathDateTime=ds.Data("DeathDateTime")
	s DeathPlaceID=ds.Data("DeathPlace")
	s DeathPlace = ..GetDescById(DeathPlaceID)
	s Company=ds.Data("Company")
	s RegAddress=ds.Data("RegAddress")
	s CurrAddress=ds.Data("CurrAddress")
	s Pregnancies=ds.Data("Pregnancies")
	s FamName=ds.Data("FamName")
	s FamTel=ds.Data("FamTel")
	s FamAddr=ds.Data("FamAddr")
	s AReason=ds.Data("AReason")
	s BReason=ds.Data("BReason")
	s CReason=ds.Data("CReason")
	s DReason=ds.Data("DReason")
	s AIntervalID=ds.Data("AInterval")  //AIntervalID 具体时间间隔^时间间隔ID
	s AInterval = $p(AIntervalID,"^",1)_..GetDescById($p(AIntervalID,"^",2))
	s BIntervalID=ds.Data("BInterval")
	s BInterval = $p(BIntervalID,"^",1)_..GetDescById($p(BIntervalID,"^",2))
	s CIntervalID=ds.Data("CInterval")
	s CInterval = $p(CIntervalID,"^",1)_..GetDescById($p(CIntervalID,"^",2))
	s DIntervalID=ds.Data("DInterval")
	s DInterval = $p(DIntervalID,"^",1)_..GetDescById($p(DIntervalID,"^",2))
	s OtherDiagnose=ds.Data("OtherDiagnose")
	s OtherDiagnoseICD=ds.Data("OtherDiagnoseICD")
	s OtherDiagnoseFP=ds.Data("OtherDiagnoseFP")
	Set:OtherDiagnoseFP'="" OtherDiagnose=OtherDiagnoseFP
	s OtherDiagnoseFPICD=ds.Data("OtherDiagnoseFPICD")
	s OtherDiagnoseInterval = $p(OtherDiagnoseInterval,"^",1)_..GetDescById($p(OtherDiagnoseInterval,"^",2))
	s DiagnoseUnitID=ds.Data("DiagnoseUnit")
	s DiagnoseUnit = ..GetDescById(DiagnoseUnitID)
	s DiagnoseBasisID=ds.Data("DiagnoseBasis")
	s DiagnoseBasis = ..GetDescById(DiagnoseBasisID)
	s PapmiNo=ds.Data("PapmiNo")
	s RepDate=ds.Data("RepDate")
	s MrNo=ds.Data("MrNo")
	//s:MrNo'="" PapmiNo=MrNo	//当病案号不为空时打印病案号，否则打印ID号
	s CurrAddress=ds.Data("CurrAddress")
	s BaseReason=ds.Data("BaseReason")
	s Country=ds.Data("Country")
	
	s ExamMedical=ds.Data("ExamMedical")
	s ExamName=ds.Data("ExamName")
	s ExamDate=ds.Data("ExamDate")
	s ExamRelationID=ds.Data("ExamRelation")
	s ExamRelation = ..GetDescById(ExamRelationID)
	s ExamAddress=ds.Data("ExamAddress")
	s ExamTel=ds.Data("ExamTel")
	s ExamDeathReason=ds.Data("ExamDeathReason")
	s examUserName=ds.Data("examUserName")
	
	s ExamDate=ds.Data("ExamDate")
	s ResumeText=ds.Data("ResumeText")
	s MrNo=ds.Data("MrNo")
	s BaseReasonICD=ds.Data("BaseReasonICD")
	
	s MEPDProvince=ds.Data("MEPDProvince")
	s MEPDCity=ds.Data("MEPDCity")
	s MEPDCounty=ds.Data("MEPDCounty")
	
	s DamageReason=ds.Data("DamageReason")
	s DamageReasonICD=ds.Data("DamageReasonICD")
	
	s CurrAddress=ds.Data("CurrAddress")
	s BaseReason=ds.Data("BaseReason")
	s Country=ds.Data("Country")
	s RepDocName=ds.Data("RepDocName")
	//打印电子签名（判断报告是否进行CA认证）
	Set IsSign=##Class(DHCMed.CA.SignVerify).GetRepIsSign("DTH","DTH",ReportID,"S")
	Set:IsSign=1 RepDocName=""
	
	s AFPReason=ds.Data("AFPReason")
	s AFPReasonICD=ds.Data("AFPReasonICD")
	Set:AFPReason'="" AReason=AFPReason
	
	s BFPReason=ds.Data("BFPReason")
	s BFPReasonICD=ds.Data("BFPReasonICD")
	Set:BFPReason'="" BReason=BFPReason
	
	s CFPReason=ds.Data("CFPReason")
	s CFPReasonICD=ds.Data("CFPReasonICD")
	Set:CFPReason'="" CReason=CFPReason
	
	s DFPReason=ds.Data("DFPReason")
	s DFPReasonICD=ds.Data("DFPReasonICD")
	Set:DFPReason'="" DReason=DFPReason
	//行政区 县/区
	s MEPDCountyCode=ds.Data("MEPDCountyCode") 
	s AddPrintCode=""
	s AddPrint =$p(FlagIDs,"^",1)   //补打
	if (AddPrint'=""){
		s objAddPrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+AddPrint)
		if $IsObject(objAddPrint) {
			s AddPrintCode = objAddPrint.Code
		} else {
			if (AddPrint="Yes") {
				s AddPrintCode=1
			}
		}
	}
	
	if (AddPrintCode["1") {
		s retval=itmjs_"(xlSheet,'"_$ZCVT("居民死亡医学证明（推断）书  【补】","O","JS")_"',"_1_",2);"
		&javascript<#(retval)#>
	}
	
	//协和
	//纸单号
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PaperNo,"O","JS")_"',"_1_",23);"
	&javascript<#(retval)#>
	//死者户籍住址
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_2_",2);"
	&javascript<#(retval)#>
	//住院号
	//s retval=itmjs_"(xlSheet,'"_$ZCVT(MrNo,"O","JS")_"',"_2_",23);"
	//&javascript<#(retval)#>
	//行政区划编号
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,1),"O","JS")_"',"_4_",3);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,2),"O","JS")_"',"_4_",4);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,3),"O","JS")_"',"_4_",5);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,4),"O","JS")_"',"_4_",6);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,5),"O","JS")_"',"_4_",7);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(MEPDCountyCode,6),"O","JS")_"',"_4_",8);"
	&javascript<#(retval)#>
	//死亡编号
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,1),"O","JS")_"',"_4_",12);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,2),"O","JS")_"',"_4_",13);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,3),"O","JS")_"',"_4_",14);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,4),"O","JS")_"',"_4_",15);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,5),"O","JS")_"',"_4_",16);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,6),"O","JS")_"',"_4_",17);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,7),"O","JS")_"',"_4_",18);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,8),"O","JS")_"',"_4_",19);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,9),"O","JS")_"',"_4_",20);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,10),"O","JS")_"',"_4_",21);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,11),"O","JS")_"',"_4_",22);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,12),"O","JS")_"',"_4_",23);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,13),"O","JS")_"',"_4_",24);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,14),"O","JS")_"',"_4_",25);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,15),"O","JS")_"',"_4_",26);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,16),"O","JS")_"',"_4_",27);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT($e(DeathNo,17),"O","JS")_"',"_4_",28);"
	&javascript<#(retval)#>
	//死者姓名
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Name,"O","JS")_"',"_6_",3);"
	&javascript<#(retval)#>
	//性别
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_6_",10);"
	&javascript<#(retval)#>
	//民族
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Nation,"O","JS")_"',"_6_",17);"
	&javascript<#(retval)#>
	//国家
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Country,"O","JS")_"',"_6_",25);"
	&javascript<#(retval)#>
	//证件类别
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CardType,"O","JS")_"',"_7_",3);"
	&javascript<#(retval)#>
	//证件号码
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Identify,"O","JS")_"',"_7_",10);"
	&javascript<#(retval)#>
	//年龄
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_7_",17);"
	&javascript<#(retval)#>
	//婚姻
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Marital,"O","JS")_"',"_7_",25);"
	&javascript<#(retval)#>
	//出生日期
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_8_",3);"
	&javascript<#(retval)#>
	//文化程度
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Education,"O","JS")_"',"_8_",10);"
	&javascript<#(retval)#>
	//职业
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Occupation,"O","JS")_"',"_8_",17);"
	&javascript<#(retval)#>
	//死亡日期
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathDateTime,"O","JS")_"',"_9_",3);"
	&javascript<#(retval)#>
	//死亡地点
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathPlace,"O","JS")_"',"_9_",10);"
	&javascript<#(retval)#>
	//死亡时是否处于妊娠期或妊娠终止后42天内
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Pregnancies,"O","JS")_"',"_9_",25);"
	&javascript<#(retval)#>
	//生前工作单位
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Company,"O","JS")_"',"_10_",3);"
	&javascript<#(retval)#>
	//户籍地址
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddress,"O","JS")_"',"_10_",10);"
	&javascript<#(retval)#>
	//常住地址
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CurrAddress,"O","JS")_"',"_10_",22);"
	&javascript<#(retval)#>
	//可联系的家属姓名
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamName,"O","JS")_"',"_11_",3);"
	&javascript<#(retval)#>
	//联系电话
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamTel,"O","JS")_"',"_11_",10);"
	&javascript<#(retval)#>
	//家属住址或工作单位
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FamAddr,"O","JS")_"',"_11_",22);"
	&javascript<#(retval)#>
	//(a)直接死亡原因
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AReason,"O","JS")_"',"_13_",9);"
	&javascript<#(retval)#>
	//发病至死亡大概间隔时间
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AInterval,"O","JS")_"',"_13_",22);"
	&javascript<#(retval)#>
	//(b)引起(a)的疾病或情况
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BReason,"O","JS")_"',"_14_",9);"
	&javascript<#(retval)#>
	//发病至死亡大概间隔时间
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BInterval,"O","JS")_"',"_14_",22);"
	&javascript<#(retval)#>
	//(c)引起(b)的疾病或情况
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CReason,"O","JS")_"',"_15_",9);"
	&javascript<#(retval)#>
	//发病至死亡大概间隔时间
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CInterval,"O","JS")_"',"_15_",22);"
	&javascript<#(retval)#>
	//(d)引起(c)的疾病或情况
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DReason,"O","JS")_"',"_16_",9);"
	&javascript<#(retval)#>
	//发病至死亡大概间隔时间
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DInterval,"O","JS")_"',"_16_",22);"
	&javascript<#(retval)#>
	// II.其他疾病诊断（促进死亡，但与导致死亡无关的其他重要情况）
	s retval=itmjs_"(xlSheet,'"_$ZCVT(OtherDiagnose,"O","JS")_"',"_17_",9);"
	&javascript<#(retval)#>
	//发病至死亡大概间隔时间
	s retval=itmjs_"(xlSheet,'"_$ZCVT(OtherDiagnoseInterval,"O","JS")_"',"_17_",22);"
	&javascript<#(retval)#>
	//生前主要疾病最高诊断单位
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DiagnoseUnit,"O","JS")_"',"_18_",3);"
	&javascript<#(retval)#>
	//生前主要疾病最高诊断依据
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DiagnoseBasis,"O","JS")_"',"_18_",22);"
	&javascript<#(retval)#>
	//首联打印中 医生签名
	//北京中医院不需要打印出来，其他医院需要打印
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDocName,"O","JS")_"',"_19_",3);"
	&javascript<#(retval)#>
	//病案号  登记号：PapmiNo
	s retval=itmjs_"(xlSheet,'"_$ZCVT(MrNo,"O","JS")_"',"_19_",9);"
	&javascript<#(retval)#>
	//填报日期
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',"_19_",22);"
	&javascript<#(retval)#>
	//根本死亡原因  
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BaseReason,"O","JS")_"',"_20_",10);"
	&javascript<#(retval)#>
	//根本死亡原因ICD
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BaseReasonICD,"O","JS")_"',"_20_",22);"
	&javascript<#(retval)#>
	//死者生前病史及症状体症：
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamMedical,"O","JS")_"',"_25_",3);"
	&javascript<#(retval)#>
	//被调查者姓名
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamName,"O","JS")_"',"_29_",3);"
	&javascript<#(retval)#>
	//与死者关系
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamRelation,"O","JS")_"',"_29_",9);"
	&javascript<#(retval)#>
	//联系电话
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamTel,"O","JS")_"',"_29_",13);"
	&javascript<#(retval)#>
	//联系地址或工作单位
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamAddress,"O","JS")_"',"_29_",24);"
	&javascript<#(retval)#>
	//死因推断
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamDeathReason,"O","JS")_"',"_30_",3);"
	&javascript<#(retval)#>
	//调查者签名
	s retval=itmjs_"(xlSheet,'"_$ZCVT(examUserName,"O","JS")_"',"_30_",13);"
	&javascript<#(retval)#>
	//调查日期
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ExamDate,"O","JS")_"',"_30_",24);"
	&javascript<#(retval)#>
	d ds.Close()
	q 1
}

/// w ##Class(DHCMed.DTHService.ReportSrv).CheckIdentify("110106196510123630")
ClassMethod CheckIdentify(argIdentify As %String, argEpisodeID As %String) As %String
{
	Set return = 0
	Quit:argIdentify="" return
	Set repId=""
	For {
		Set repId=$o(^DHCMed.DTH("REP",repId))
		Quit:repId=""
		
		Set obj=##class(DHCMed.DTH.Report).GetObjById(repId)
		Continue:'$IsObject(obj)	
		Set Identify=obj.Identify
		Set EpisodeID=obj.EpisodeID
		if ((Identify=argIdentify)&&(EpisodeID'=argEpisodeID)) {
			Set return = 1	
		}
	}
 	Quit return
}

/// w ##Class(DHCMed.DTHService.ReportSrv).CheckDthRepByAdm(585095)
ClassMethod CheckDthRepByAdm(aEpisodeID As %String, aPatientID As %String = "") As %String
{
	new (aEpisodeID,aPatientID)
	set return=0
	
	if aEpisodeID'="" {
		set aPatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	}
	quit:aPatientID="" return
	
	set xReportID=0
	for {
		set xReportID=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_aPatientID,xReportID))
		quit:xReportID=""
		
		set obj=##Class(DHCMed.DTH.Report).GetObjById(xReportID)
		continue:'$IsObject(obj)
		continue:'$IsObject(obj.RepStatusDR)
		set RepStatus=obj.RepStatusDR.Code
		continue:RepStatus="5"  //作废
		continue:RepStatus="0"  //删除
		set return=1
	}
	
	quit return
}

/// Creator:    yhb
/// CreateDate: 2014-07-07
/// Description:返回是否距第一次上报的时间超过24小时
/// Input:     reportId：报告ID
/// Output:    1:超过 0：未超过
/// w ##Class(DHCMed.DTHService.ReportSrv).GetTimeOutFlag("1")
ClassMethod GetTimeOutFlag(reportId As %String) As %String
{
	new (reportId)
	s TimeOutFlag=0
	s StatusId=""
	for {
		s StatusId = $o(^DHCMed.DTH("REP",+reportId,"Status",StatusId))
		q:StatusId=""
		s StatusObj = ##Class(DHCMed.DTH.ReportStatus).GetObjById(+reportId_"||"_StatusId)
		if $IsObject(StatusObj) {
			s StatusDR = StatusObj.StatusDR
			if $IsObject(StatusDR) {
				s StatusCode = StatusDR.Code
				if (StatusCode="1") {
					s OpeDate=StatusObj.OpeDate
					s OpeTime=StatusObj.OpeTime
					s TimeAway = (+$h)-OpeDate+(($p($h,",",2)-OpeTime)/3600)
					if TimeAway>24 {
						s TimeOutFlag=1
						q
					}
				} 
			}
		}
	}
	q TimeOutFlag
}

/// 功能：由死亡报告ID获取上报人ID
/// 目的：电子签名获取签名图(保证签名医师与UKey的一致性)
/// w ##Class(DHCMed.DTHService.ReportSrv).GetUserIDByRepID(3)
ClassMethod GetUserIDByRepID(reportId) As %String
{
	set ret=""
	q:(reportId="") ret
	
	set repObj=##Class(DHCMed.DTH.Report).GetObjById(+reportId)
	quit:'$IsObject(repObj) ret
	
	set RepUsrDR=repObj.RepUsrDR
	set ret=RepUsrDR
	
	quit ret
}

/// 功能：由死亡报告ID获取上报科室ID
/// 目的：电子签名获取签名图(保证签名医师与UKey的一致性)
/// w ##Class(DHCMed.DTHService.ReportSrv).GetLocIDByRepID(3)
ClassMethod GetLocIDByRepID(reportId) As %String
{
	set ret=""
	q:(reportId="") ret
	
	set repObj=##Class(DHCMed.DTH.Report).GetObjById(+reportId)
	quit:'$IsObject(repObj) ret
	
	set RepLocDR=repObj.RepLocDR
	set ret=RepLocDR
	
	quit ret
}

/// Creator：     chenrui
/// CreatDate：   2023-04-11
/// Description:  根据报告ID查询报告修改日志
/// Table：       DHCMed.EPDService.EpidemicSrv
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.DTHService.ReportSrv","QryDTHReportLog","74","","","","","")
Query QryDTHReportLog(aReportID As %String, aFromDate As %String, aToDate As %String, aHospital As %String, aLoc As %String, aStatusCode As %String) As %Query(ROWSPEC = "LogID:%String,EpisodeID:%String,StatusCode:%String,StatusDesc:%String,LocID:%String,LocCode:%String,LocDesc:%String,DTHDate:%String,DTHTime:%String,UserID:%String,UserCode:%String,UserName:%String,Resume:%String,DTHEditContent:%String")
{
}

ClassMethod QryDTHReportLogExecute(ByRef qHandle As %Binary, aReportID As %String, aFromDate As %String, aToDate As %String, aHospital As %String, aLoc As %String, aStatusCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aReportID="" $$$OK
	Set objRep =##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	
	Set xData=""
	Set:aFromDate'="" xData=aToDate+1
	For {
		Set xData=$o(^DHCMed.DTH.ReportLogI("IndexReportIDDateTime",aReportID,xData),-1)
		Quit:xData=""
		Quit:xData<aFromDate
		
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.DTH.ReportLogI("IndexReportIDDateTime",aReportID,xData,xTime),-1)
			Quit:xTime=""
			
			Set xLogID=""
			For {
				Set xLogID=$o(^DHCMed.DTH.ReportLogI("IndexReportIDDateTime",aReportID,xData,xTime,xLogID),-1)
				Quit:xLogID=""
				
				Set objLog=##class(DHCMed.DTH.ReportLog).GetObjById(xLogID)
				Continue:'$IsObject(objLog)
				
				Set EpisodeID	= objLog.EpisodeID
				Set DTHStatus	= objLog.DTHStatus
				Set StatusCode="",StatusDesc=""
				If $IsObject(DTHStatus) {
					Set StatusCode	= DTHStatus.Code
					Set StatusDesc	= DTHStatus.Description
				}
				Continue:(aStatusCode'="")&&(StatusCode'=aStatusCode)
				
				// 重新命名描述
				// 
				Set:StatusCode="1" StatusDesc="提交"
				Set:StatusCode="3" StatusDesc="审核"
				
				Set LocID	= objLog.DTHLoc
				Continue:(aLoc'="")&&(LocID'=aLoc)
				If aHospital'="" {
					set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospital)
					continue:flg<1
				}
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
				Set LocCode="",LocDesc=""
				If $IsObject(objLoc) {
					Set LocCode=objLoc.Code
			   		Set LocDesc=objLoc.Descs
				}
				Set DTHDate		= ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(xData)
				Set DTHTime		= $zt(xTime,1)
				Set UserID	= objLog.DTHUser
				Set objUser=##Class(DHCMed.Base.SSUser).GetObjById(UserID)
				If $IsObject(objUser) {
					Set UserCode=objUser.Code
					Set UserName=objUser.Name
				}
				Set Resume		= objLog.Resume
				Set DTHEditContent = objLog.DTHEditContent
				Set:DTHEditContent'="" DTHEditContent=$replace(DTHEditContent,$C(1),"<br>")
				
				Set Data=$lb(xLogID,EpisodeID,StatusCode,StatusDesc,LocID,LocCode,LocDesc,DTHDate,DTHTime,UserID,UserCode,UserName,Resume,DTHEditContent)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryDTHReportLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDTHReportLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDTHReportLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDTHReportLogExecute ]
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
