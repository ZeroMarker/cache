/// 儿童死亡报告卡
/// 创建日期：2015-02-09
/// 创建者：李阳
/// 
Class DHCMed.DTH.ChildReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 基本信息ID Pa_Patmas
Property PatientID As %String [ Required ];

/// 就诊表 ID
Property EpisodeID As %String [ Required ];

/// 死亡报告ID DHCMed.DTH.Report
Property DthReportID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 编号
Property DTHNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否补卡
Property IsReplenish As %Boolean;

/// 姓名
Property Name As %String(MAXLEN = 100, TRUNCATE = 1);

/// 父亲姓名
Property FatherName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 母亲姓名
Property MotherName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户主联系电话
Property FamTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 性别 1--男 2--女 3--性别不明
Property Sex As DHCMed.SS.Dictionary;

/// 出生日期
Property Birthday As %Date;

/// 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
Property RegType As DHCMed.SS.Dictionary;

/// 出生体重
Property Weight As %Numeric;

/// 出生体重类别：1--测量 2--估计
Property WeightType As DHCMed.SS.Dictionary;

/// 怀孕___周
Property PregnancyWeek As %String;

/// 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
Property BirthdayPlace As DHCMed.SS.Dictionary;

/// 死亡日期
Property DeathDate As %Date;

/// 死亡年龄 年
Property DeathAgeYear As %Numeric;

/// 死亡年龄 月
Property DeathAgeMonth As %Numeric;

/// 死亡年龄 日
Property DeathAgeDay As %Numeric;

/// 死亡年龄 小时
Property DeathAgeHour As %Numeric;

/// 死亡地点 1--医院 2--途中 3--家中
Property DeathPosition As DHCMed.SS.Dictionary;

/// 死亡前治疗 1--住院 2--门诊 3--未治疗
Property CareBeforeDeath As DHCMed.SS.Dictionary;

/// 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
Property DiagnoseLv As DHCMed.SS.Dictionary;

/// 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
Property NotCareReason As DHCMed.SS.Dictionary;

/// 未治疗或未就医主要原因（需要注明原因）
Property NotCareReasonTxt As %String;

/// 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
Property DiagnoseBasis As DHCMed.SS.Dictionary;

/// 分类编号 01-痢疾 02--败血症 03-麻疹 ...
Property Category As DHCMed.SS.Dictionary;

/// ICD-10编码
Property ICD10 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医生
Property RepDocDR As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告科室
Property RepLocDR As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告人
Property RepUsrDR As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告日期
Property RepDate As %Date;

/// 报告时间
Property RepTime As %Time;

/// 报告状态
Property RepStatusDR As DHCMed.SS.Dictionary;

/// 审核人
Property CheckUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 审核日期
Property CheckDate As %Date;

/// 审核时间
Property CheckTime As %Time;

/// 备注
Property ResumeText As %String(MAXLEN = 500, TRUNCATE = 1);

/// 母亲身份证号
Property MotherID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 分娩医院
Property BirthHosp As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病人ID索引
Index IndexPatientID On PatientID;

/// 医学死亡证明书ID索引
Index IndexDthReportID On DthReportID;

/// 报告日期索引
Index IndexRepDate On (RepDate, RepStatusDR);

/// Description: 根据Id得到DHCMed.DTH.Report对象
/// Input:       Id:RowId
/// Output:      DHCMed.DTH.ChildReport对象
/// w ##Class(DHCMed.DTH.Report).GetObjById(44)
ClassMethod GetObjById(id As %String) As DHCMed.DTH.ChildReport
{
	new (id)
	set return=""
	set obj=##Class(DHCMed.DTH.ChildReport).%OpenId(id)
	if $IsObject(obj){
		
		//同步医学死亡证明书上的根本死因ICD等信息
		Set tID=obj.DthReportID
		Set objRep=##class(DHCMed.DTH.Report).GetObjById(tID)
		if ($IsObject(objRep)) {
			if (obj.ICD10'=objRep.BaseReasonICD) {
				Set obj.ICD10=objRep.BaseReasonICD
				Do obj.%Save()
			}
		}
		set return=obj
	}
	if obj'="" do obj.%Close()
	quit return
}

/// 通过医学死亡证明书编号查询儿童死亡报告卡ID
/// 参数：
///    DthRepID:医学死亡证明书ID
/// 返回值：
///    儿童死亡报告卡的ID（DHCMed.DTH.ChildReport）
/// w ##class(DHCMed.DTH.ChildReport).GetRepIDByDthID(1)
ClassMethod GetRepIDByDthID(DthRepID As %String) As %String
{
	n (DthRepID)
	Set ret=""
	Set RepID=""
	For {
		Set RepID=$o(^DHCMed.DTHi("ChildREP","IndexDthReportID"," "_DthRepID,RepID))
		Quit:RepID=""
		Set o=##class(DHCMed.DTH.ChildReport).GetObjById(RepID)
		Continue:'$IsObject(o)
		Continue:'$IsObject(o.RepStatusDR)
		Continue:((o.RepStatusDR.Description["删除")||(o.RepStatusDR.Description["作废"))
		Set ret=o.%Id()
		Do o.%Close()
	}
	Quit ret
}

ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.DTH.ChildReport).%New()
	} Else {
		Set obj=##class(DHCMed.DTH.ChildReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.PatientID=$p(aInput,aSeparate,2) // 基本信息ID Pa_Patmas
	Set obj.EpisodeID=$p(aInput,aSeparate,3) // 就诊表 ID
	Set obj.DthReportID=$p(aInput,aSeparate,4) // 死亡报告ID DHCMed.DTH.Report
	Set obj.Name=$p(aInput,aSeparate,5) // 姓名
	Set obj.FatherName=$p(aInput,aSeparate,6) // 父亲姓名
	Set obj.MotherName=$p(aInput,aSeparate,7) // 母亲姓名
	Set obj.FamTel=$p(aInput,aSeparate,8) //  联系电话
	Set obj.Sex=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,9))  // 性别 1--男 2--女 3--性别不明
	Set Birthday = $p(aInput,aSeparate,10)
	Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Birthday)
	
	Set obj.Birthday=Birthday // 出生日期
	Set obj.RegType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,11)) // 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
	Set obj.Weight=$p(aInput,aSeparate,12) // 出生体重
	Set obj.WeightType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,13)) // 出生体重类别：1--测量 2--估计
	Set obj.PregnancyWeek=$p(aInput,aSeparate,14) // 怀孕___周
	Set obj.BirthdayPlace=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,15)) // 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
	Set DeathDate = $p(aInput,aSeparate,16)
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DeathDate)
	Set obj.DeathDate=DeathDate //死亡日期
	Set obj.DeathAgeYear=$p(aInput,aSeparate,17) /// 死亡年龄 年
	Set obj.DeathAgeMonth=$p(aInput,aSeparate,18) /// 死亡年龄 月
	Set obj.DeathAgeDay=$p(aInput,aSeparate,19) /// 死亡年龄 日
	Set obj.DeathPosition=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,20)) /// 死亡地点 1--医院 2--途中 3--家中
	Set obj.CareBeforeDeath=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,21)) /// 死亡前治疗 1--住院 2--门诊 3--未治疗
	Set obj.DiagnoseLv=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,22)) /// 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
	Set obj.NotCareReason=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,23)) /// 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
	Set obj.NotCareReasonTxt=$p(aInput,aSeparate,24) /// 未治疗或未就医主要原因 需要注明
	Set obj.DiagnoseBasis=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,25)) // 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
	Set obj.Category=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,26)) //分类编号
	Set obj.ICD10=$p(aInput,aSeparate,27) //ICD-10编码
	Set obj.RepDocDR=$p(aInput,aSeparate,28)
	Set obj.RepLocDR=$p(aInput,aSeparate,29)
	Set obj.RepUsrDR=$p(aInput,aSeparate,30)
	Set obj.RepDate=+$h
	Set obj.RepTime=$p($h,",",2)
	Set obj.RepStatusDR=##class(DHCMed.SS.Dictionary).GetByTypeCode("DTHRunningState",+$p(aInput,aSeparate,33),"1")  // 状态
	Set obj.DTHNo=$p(aInput,aSeparate,34) //编号
	Set obj.IsReplenish=$p(aInput,aSeparate,35) //是否补卡
	Set obj.DeathAgeHour=$p(aInput,aSeparate,36) //死亡年龄 小时
	Set obj.MotherID=$p(aInput,aSeparate,37) //母亲身份证号
	Set obj.BirthHosp=$p(aInput,aSeparate,38) //分娩医院
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

ClassMethod ModifyStatus(ReportID As %String, StatusID As %String, ResumeText As %String, UserID As %String)
{
	n (ReportID,ResumeText,StatusID,UserID)
	Set obj=##class(DHCMed.DTH.ChildReport).GetObjById(ReportID)
	Do obj.%Close()
	Set obj.RepStatusDR=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Set obj.ResumeText=ResumeText
	Set obj.CheckUser=UserID
	Set obj.CheckDate=+$h
	Set obj.CheckTime=$p($h,",",2)
	Set ret=obj.%Save()
	Quit ret
}

Storage Default
{
<Data name="ChildReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>FatherName</Value>
</Value>
<Value name="6">
<Value>MotherName</Value>
</Value>
<Value name="7">
<Value>FamTel</Value>
</Value>
<Value name="8">
<Value>Sex</Value>
</Value>
<Value name="9">
<Value>Birthday</Value>
</Value>
<Value name="10">
<Value>RegType</Value>
</Value>
<Value name="11">
<Value>Weight</Value>
</Value>
<Value name="12">
<Value>WeightType</Value>
</Value>
<Value name="13">
<Value>PregnancyWeek</Value>
</Value>
<Value name="14">
<Value>BirthdayPlace</Value>
</Value>
<Value name="15">
<Value>DeathDate</Value>
</Value>
<Value name="16">
<Value>DeathAgeYear</Value>
</Value>
<Value name="17">
<Value>DeathAgeMonth</Value>
</Value>
<Value name="18">
<Value>DeathAgeDay</Value>
</Value>
<Value name="19">
<Value>DeathPosition</Value>
</Value>
<Value name="20">
<Value>CareBeforeDeath</Value>
</Value>
<Value name="21">
<Value>DiagnoseLv</Value>
</Value>
<Value name="22">
<Value>NotCareReason</Value>
</Value>
<Value name="23">
<Value>DiagnoseBasis</Value>
</Value>
<Value name="24">
<Value>RepDocDR</Value>
</Value>
<Value name="25">
<Value>RepLocDR</Value>
</Value>
<Value name="26">
<Value>RepUsrDR</Value>
</Value>
<Value name="27">
<Value>RepDate</Value>
</Value>
<Value name="28">
<Value>RepTime</Value>
</Value>
<Value name="29">
<Value>RepStatusDR</Value>
</Value>
<Value name="30">
<Value>DthReportID</Value>
</Value>
<Value name="31">
<Value>NotCareReasonTxt</Value>
</Value>
<Value name="32">
<Value>Category</Value>
</Value>
<Value name="33">
<Value>ICD10</Value>
</Value>
<Value name="34">
<Value>DTHNo</Value>
</Value>
<Value name="35">
<Value>IsReplenish</Value>
</Value>
<Value name="36">
<Value>DeathAgeHour</Value>
</Value>
<Value name="37">
<Value>CheckUser</Value>
</Value>
<Value name="38">
<Value>CheckDate</Value>
</Value>
<Value name="39">
<Value>CheckTime</Value>
</Value>
<Value name="40">
<Value>ResumeText</Value>
</Value>
<Value name="41">
<Value>BirthHosp</Value>
</Value>
<Value name="42">
<Value>MotherID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DTH("ChildREP")</DataLocation>
<DefaultData>ChildReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DTH("ChildREP")</IdLocation>
<IndexLocation>^DHCMed.DTHi("ChildREP")</IndexLocation>
<StreamLocation>^DHCMed.DTH.ChildReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
