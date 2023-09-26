/// 新诊断报告丙肝病例个案调查表
Class DHCMed.EPD.HCVReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号
Property HcvEpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 基本信息
Property HcvPatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告状态("HCVRepStatus")
Property HcvStatusDr As DHCMed.SS.Dictionary;

/// 机构名称
Property HcvOrganName As %String;

/// 机构代码
Property HcvOrganID As %String;

/// 流水号
Property HcvSerialNum As %String;

/// 文化程度
Property HcvEducation As DHCMed.SS.Dictionary;

/// 婚姻状况
Property HcvMarrige As DHCMed.SS.Dictionary;

/// 个人月收入
Property HcvPerMonIncome As DHCMed.SS.Dictionary;

/// 医保类型
Property HcvMedInsType As DHCMed.SS.Dictionary;

/// 医保类型其他
Property HcvMedInsTypeExt As %String;

/// 首次抗体检测阳性日期
Property HcvTestPosDate As %Date;

/// 首次抗体检测阳性方法
Property HcvTestMethod As DHCMed.SS.Dictionary;

/// 首次抗体阳性实验室检测主要原因（单选）
Property HcvTestReasonDR As DHCMed.SS.Dictionary;

/// 其他检测原因
Property HcvTestReasonExt As %String;

/// 抗体复检日期
Property HcvRecheckDate As %Date;

/// 未做抗体复检（未做为0）
Property HcvIsRecheck As %Boolean;

/// 抗体复检方法
Property HcvRechMethod As DHCMed.SS.Dictionary;

/// 抗体复检结果
Property HcvResults As DHCMed.SS.Dictionary;

/// 丙肝核酸检测结果（阴性为0，阳性为1）
Property HcvNucleinRet As %Boolean;

/// 病毒载量
Property HcvNucleinRetExt As %Float;

/// 采血日期
Property HcvBloodDate As %Date;

/// 未采血（未做为0）
Property HcvIsCheck As %Boolean;

/// 网络直报录入日期
Property HcvEntryDate As %Date;

/// 疫情库卡片编号
Property HcvCardNo As %String;

/// 转介治疗日期 (数据库name="35")
Property HcvReferDate As %Date;

/// 未转介（未做为0）
Property HcvIsRefer As %Boolean;

/// 转介结果
Property HcvReferResult As DHCMed.SS.Dictionary;

/// 治疗开始日期
Property HcvTreatmentDate As %Date;

/// 未治疗原因
Property HcvUntreatedDR As DHCMed.SS.Dictionary;

/// 其他未治疗原因
Property HcvUntreatedExt As %String;

/// 填报人
Property HcvRepUser As %String;

/// 填报日期
Property HcvRepDate As %Date;

/// 备注
Property HcvResume As %String;

/// 审核人
Property HcvCheckUser As %String;

/// 审核日期
Property HcvCheckDate As %Date;

/// 退回理由
Property HcvReason As %String;

/// 以就诊号为索引
Index IndexEpisodeID On HcvEpisodeID;

/// 以基本信息为索引
Index IndexPatientID On HcvPatientID;

/// 以填报日期为索引
Index IndexReportDate On HcvRepDate;

/// 以审核日期为索引
Index IndexCheckDate On HcvCheckDate;

/// Description:  取报告信息
/// Table：       DHCMed.EPD.HCVReport
/// Input：       Id : DHCMed.EPD.HCVReport.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.HCVReport).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.EPD.HCVReport
{
	New (aID)
	Quit:'##class(DHCMed.EPD.HCVReport).%ExistsId(aID) ""   //ID不存在，返回空
	Set obj=##class(DHCMed.EPD.HCVReport).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// 功能：保存调查表信息
/// 返回值：生成的Rowid
/// w ##class(DHCMed.EPD.HCVReport).Update("^4^8^5314^123^001001001^^3910^5575^5715^5707^^2022-05-16^5718^5726^^^0^^^1^3.8^2022-05-19^1^2022-05-23^^1^5742^^5748^^医生01^2022-06-04^^2022-05-29","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="") return
	Set:aSeparate="" aSeparate="^"
	Set ID=$p(aInputStr,aSeparate,1)
	Set EpisodeID=$p(aInputStr,aSeparate,2)
	Set PatientID=$p(aInputStr,aSeparate,3)
	Set StatusDr=$p(aInputStr,aSeparate,4)
	Set OrganName=$p(aInputStr,aSeparate,5)
	Set OrganID=$p(aInputStr,aSeparate,6)
	Set SerialNum=$p(aInputStr,aSeparate,7) //流水号
	Set Education=$p(aInputStr,aSeparate,8)
	Set Marrige=$p(aInputStr,aSeparate,9)
	Set PerMonIncome=$p(aInputStr,aSeparate,10)
	Set MedInsType=$p(aInputStr,aSeparate,11)
	Set MedInsTypeExt=$p(aInputStr,aSeparate,12)
	Set TestPosDate=$p(aInputStr,aSeparate,13)
	Set TestMethod=$p(aInputStr,aSeparate,14)
	Set TestReasonDR=$p(aInputStr,aSeparate,15)
	Set TestReasonExt=$p(aInputStr,aSeparate,16)
	Set RecheckDate=$p(aInputStr,aSeparate,17)
	Set IsRecheck=$p(aInputStr,aSeparate,18)
	Set RechMethod=$p(aInputStr,aSeparate,19)
	Set Results=$p(aInputStr,aSeparate,20)
	Set NucleinRet=$p(aInputStr,aSeparate,21)
	Set NucleinRetExt=$p(aInputStr,aSeparate,22)
	Set BloodDate=$p(aInputStr,aSeparate,23)
	Set IsCheck=$p(aInputStr,aSeparate,24)
	Set EntryDate=$p(aInputStr,aSeparate,25)
	Set CardNo=$p(aInputStr,aSeparate,26)
	Set IsRefer=$p(aInputStr,aSeparate,27)
	Set ReferResult=$p(aInputStr,aSeparate,28)
	Set TreatmentDate=$p(aInputStr,aSeparate,29)
	Set UntreatedDR=$p(aInputStr,aSeparate,30)
	Set UntreatedExt=$p(aInputStr,aSeparate,31)
	Set RepUser=$p(aInputStr,aSeparate,32)
	Set RepDate=$p(aInputStr,aSeparate,33)
	Set Resume=$p(aInputStr,aSeparate,34)
	Set ReferDate=$p(aInputStr,aSeparate,35) ///转介治疗日期
	Set CheckUser=$p(aInputStr,aSeparate,36)
	Set CheckDate=$p(aInputStr,aSeparate,37)
	
	Quit:(EpisodeID="")||(PatientID="")||(StatusDr="") return
	
	//下拉框通过ID取字典对象
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusDr)  //状态
	Quit:'$IsObject(objStatus) return
	Set objEducation=##class(DHCMed.SS.Dictionary).GetObjById(Education) //文化程度
	Set objMarrige=##class(DHCMed.SS.Dictionary).GetObjById(Marrige)	//婚姻
	Set objPerMonIncome=##class(DHCMed.SS.Dictionary).GetObjById(PerMonIncome) //个人月收入
	Set objMedInsType=##class(DHCMed.SS.Dictionary).GetObjById(MedInsType)		//医保类型
	Set objTestMethod=##class(DHCMed.SS.Dictionary).GetObjById(TestMethod)		//首次检测方法
	Set objTestReason=##class(DHCMed.SS.Dictionary).GetObjById(TestReasonDR)		//首次检测原因
	If (objStatus.Code<3) {
		Quit:'$IsObject(objEducation) return
		Quit:'$IsObject(objMarrige) return
		Quit:'$IsObject(objPerMonIncome) return
		Quit:'$IsObject(objMedInsType) return
		Quit:'$IsObject(objTestMethod) return
		Quit:'$IsObject(objTestReason) return		
	}
	
	//日期转化为”YY-MM-DD“格式
	Set:TestPosDate'="" TestPosDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(TestPosDate)
	Set:RecheckDate'="" RecheckDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(RecheckDate)
	Set:BloodDate'="" BloodDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(BloodDate)
	Set:EntryDate'="" EntryDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(EntryDate)
	Set:TreatmentDate'="" TreatmentDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(TreatmentDate)
	Set:ReferDate'="" ReferDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ReferDate)
	Set:RepDate="" RepDate=+$h
	Set RepDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(RepDate)
	Set:CheckDate'="" CheckDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CheckDate)

	
	//新建报告？则初始化；若存在报告，则打开报告更新
	If (ID="") {
		Set obj=##class(DHCMed.EPD.HCVReport).%New()
	}
	Else{
		Set obj=##class(DHCMed.EPD.HCVReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.HcvEpisodeID      = EpisodeID
	Set obj.HcvPatientID      = PatientID
	Set obj.HcvStatusDr       = objStatus
	Set obj.HcvOrganName      = OrganName
	Set obj.HcvOrganID        = OrganID
	Set obj.HcvSerialNum      = SerialNum
	Set obj.HcvEducation      = objEducation
	Set obj.HcvMarrige        = objMarrige
	Set obj.HcvPerMonIncome   = objPerMonIncome
	Set obj.HcvMedInsType     = objMedInsType
	Set obj.HcvMedInsTypeExt  = MedInsTypeExt
	Set obj.HcvTestPosDate    = TestPosDate
	Set obj.HcvTestMethod     = objTestMethod
	Set obj.HcvTestReasonDR   = objTestReason
	Set obj.HcvTestReasonExt  = TestReasonExt
	Set obj.HcvRecheckDate    = RecheckDate
	Set obj.HcvIsRecheck      = IsRecheck
	Set obj.HcvNucleinRet     = NucleinRet
	Set obj.HcvNucleinRetExt  = NucleinRetExt
	Set obj.HcvBloodDate      = BloodDate
	Set obj.HcvIsCheck        = IsCheck
	Set obj.HcvEntryDate      = EntryDate
	Set obj.HcvCardNo         = CardNo
	Set obj.HcvReferDate      = ReferDate
	Set obj.HcvIsRefer        = IsRefer
	Set obj.HcvTreatmentDate  = TreatmentDate
	Set obj.HcvUntreatedExt   = UntreatedExt
	Set obj.HcvRepUser        = RepUser
	Set obj.HcvRepDate        = RepDate
	Set obj.HcvResume         = Resume
	Set obj.HcvCheckUser      = CheckUser
	Set obj.HcvCheckDate      = CheckDate	
	
	If (RechMethod'="") {
		Set objRechMethod=##class(DHCMed.SS.Dictionary).GetObjById(RechMethod)	//复检方法
		Quit:'$IsObject(objRechMethod) return 
		Set obj.HcvRechMethod = objRechMethod
	} else {
		Set obj.HcvRechMethod = ""
	}
	If (Results'="") {
		Set objResults=##class(DHCMed.SS.Dictionary).GetObjById(Results)		//复检结果
		Quit:'$IsObject(objResults) return 
		Set obj.HcvResults = objResults
	} else {
			Set obj.HcvResults = ""
	}
	If (ReferResult'="") {	
		Set objReferResult=##class(DHCMed.SS.Dictionary).GetObjById(ReferResult)	//转介结果
		Quit:'$IsObject(objReferResult) return 
		Set obj.HcvReferResult = objReferResult
	} else {
		Set obj.HcvReferResult = ""
	}
	If (UntreatedDR'="") {	
		Set objUntreated=##class(DHCMed.SS.Dictionary).GetObjById(UntreatedDR)	//未治疗原因
		Quit:'$IsObject(objUntreated) return 
		Set obj.HcvUntreatedDR = objUntreated
	} else {
		Set obj.HcvUntreatedDR = ""
	}

	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Description : 更新流水号
/// Output      : 新的流水号
/// w ##class(DHCMed.EPD.HCVReport).UpdateSerialNum("1","001")
ClassMethod UpdateSerialNum(aID As %String, aSerialNum As %String) As %String
{
	New (aID,aSerialNum)
	Set return=0
	Quit:(aID="")||(aSerialNum="") return

	Set obj=##class(DHCMed.EPD.HCVReport).%OpenId(aID)	
	Quit:'$IsObject(obj) return
	Set obj.HcvSerialNum = aSerialNum
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.HcvSerialNum
	}
	Do obj.%Close()
	Quit return
}

/// Description:  删除个案调查表
/// Table：       DHCMed.EPD.HCVReport
/// Input：       aId : DHCMed.EPD.HCVReport.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.HCVReport).DeleteById(2)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMed.EPD.HCVReport).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Description:  更新个案调查表状态
/// w ##class(DHCMed.EPD.HCVReport).UpdateStatus("3^5315^9^", "^")
ClassMethod UpdateStatus(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ReportID  =$p(aInputStr,aSeparate,1)
	Set StatusID  =$p(aInputStr,aSeparate,2)
	Set CheckUser =$p(aInputStr,aSeparate,3)
	Set CheckDate =$p(aInputStr,aSeparate,4)
	Set Reason	  =$p(aInputStr,aSeparate,5)
	Quit:(ReportID="") return
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Quit:'$IsObject(objStatus) return
	
	If (objStatus.Code=2) {
		Set:CheckDate'="" CheckDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CheckDate)
		Set:CheckDate="" CheckDate=$p($h,",",1)
	} Else {
		Set CheckUser=""
	}

	Set obj=##class(DHCMed.EPD.HCVReport).%OpenId(ReportID)
	Quit:'$IsObject(obj) return
	
	Set obj.HcvStatusDr = objStatus
	Set obj.HcvCheckUser = CheckUser
	Set obj.HcvCheckDate = CheckDate
    Set obj.HcvReason = Reason
    
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

Storage Default
{
<Data name="HCVReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HcvEpisodeID</Value>
</Value>
<Value name="3">
<Value>HcvPatientID</Value>
</Value>
<Value name="4">
<Value>HcvStatusDr</Value>
</Value>
<Value name="5">
<Value>HcvOrganName</Value>
</Value>
<Value name="6">
<Value>HcvOrganID</Value>
</Value>
<Value name="7">
<Value>HcvSerialNum</Value>
</Value>
<Value name="8">
<Value>HcvEducation</Value>
</Value>
<Value name="9">
<Value>HcvMarrige</Value>
</Value>
<Value name="10">
<Value>HcvPerMonIncome</Value>
</Value>
<Value name="11">
<Value>HcvMedInsType</Value>
</Value>
<Value name="12">
<Value>HcvMedInsTypeExt</Value>
</Value>
<Value name="13">
<Value>HcvTestPosDate</Value>
</Value>
<Value name="14">
<Value>HcvTestMethod</Value>
</Value>
<Value name="15">
<Value>HcvTestReasonDR</Value>
</Value>
<Value name="16">
<Value>HcvTestReasonExt</Value>
</Value>
<Value name="17">
<Value>HcvRecheckDate</Value>
</Value>
<Value name="18">
<Value>HcvIsRecheck</Value>
</Value>
<Value name="19">
<Value>HcvRechMethod</Value>
</Value>
<Value name="20">
<Value>HcvResults</Value>
</Value>
<Value name="21">
<Value>HcvNucleinRet</Value>
</Value>
<Value name="22">
<Value>HcvNucleinRetExt</Value>
</Value>
<Value name="23">
<Value>HcvBloodDate</Value>
</Value>
<Value name="24">
<Value>HcvIsCheck</Value>
</Value>
<Value name="25">
<Value>HcvEntryDate</Value>
</Value>
<Value name="26">
<Value>HcvCardNo</Value>
</Value>
<Value name="27">
<Value>HcvReferDate</Value>
</Value>
<Value name="28">
<Value>HcvIsRefer</Value>
</Value>
<Value name="29">
<Value>HcvReferResult</Value>
</Value>
<Value name="30">
<Value>HcvTreatmentDate</Value>
</Value>
<Value name="31">
<Value>HcvUntreatedDR</Value>
</Value>
<Value name="32">
<Value>HcvUntreatedExt</Value>
</Value>
<Value name="33">
<Value>HcvRepUser</Value>
</Value>
<Value name="34">
<Value>HcvRepDate</Value>
</Value>
<Value name="35">
<Value>HcvResume</Value>
</Value>
<Value name="36">
<Value>HcvCheckUser</Value>
</Value>
<Value name="37">
<Value>HcvCheckDate</Value>
</Value>
<Value name="38">
<Value>HcvReason</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.HCVReportD</DataLocation>
<DefaultData>HCVReportDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.HCVReportD</IdLocation>
<IndexLocation>^DHCMed.EPD.HCVReportI</IndexLocation>
<StreamLocation>^DHCMed.EPD.HCVReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
