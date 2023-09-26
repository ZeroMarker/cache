/// 名称:  DHCMed.EPD.HCVReferral
/// 描述:  丙肝转介通知单
/// 编写者： chenrui
/// 编写日期:  2023-03-01
Class DHCMed.EPD.HCVReferral Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String;

/// 病人ID
Property PatientID As %String;

/// 接收医疗机构名称
Property RecHospName As %String;

/// 患者姓名
Property PatName As %String;

/// 性别
Property PatSex As %String;

/// 身份证号
Property PersonalID As %String;

/// 丙肝病毒抗体检测（抗-HCV/HCV RNA阳性）
Property HCVDetectionDr As DHCMed.SS.Dictionary;

/// 丙肝病毒抗体检测方案
Property HCVExamPlanDr As DHCMed.SS.Dictionary;

/// 其他方案
Property OtherPlan As %String;

/// 转介单位联系电话
Property RefTelPhone As %String;

/// 转介医生签名
Property RefDoctor As %String;

/// 转介单位
Property RefOrgName As %String;

/// 备注
Property Resume As %String;

/// 报告日期
Property ReportDate As %Date;

/// 报告状态
Property RepStatus As %String;

Index EpisodeIDIndex On EpisodeID As Exact;

Index ReportDateIndex On ReportDate As Exact;

/// Creator：     chenrui
/// CreatDate：   2023-03-01
/// Description:  根据ID取报告信息
/// Table：       DHCMed.EPD.HCVReferral
/// Input：       ID:    DHCMed.EPD.HCVReferral.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.HCVReferral).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.EPD.HCVReferral
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.EPD.HCVReferral).%ExistsId(+id) return
	set obj=##Class(DHCMed.EPD.HCVReferral).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

Method ToString(separete As %String) As %String
{
	Set return=..RecHospName_separete
	Set return=return_..PatName_separete
	Set return=return_..PatSex_separete
	Set return=return_..PersonalID_separete
	Set return=return_..GetDicByObj(..HCVDetectionDr)_separete
	Set return=return_..GetDicByObj(..HCVExamPlanDr)_separete
	Set return=return_..OtherPlan_separete
	Set return=return_..RefTelPhone_separete
	Set return=return_..RefDoctor_separete
	Set return=return_..RefOrgName_separete
	Set return=return_##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(..ReportDate)_separete
	Set return=return_..Resume_separete
	Set return=return_..RepStatus_separete
	
	
	Quit return
}

ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.Description
	quit return
}

/// Creator：     chenrui
/// CreatDate：   2023-03-01
/// Description:  根据ID取报告主卡信息
/// Table：       DHCMed.EPD.HCVReferral
/// Input：       ID:    DHCMed.EPD.HCVReferral.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.HCVReferral).GetStringById(1)
ClassMethod GetStringById(id As %String) As %String
{
	new (id)
	set return=""
	quit:id="" return
	
	set obj=##Class(DHCMed.EPD.HCVReferral).GetObjById(+id)
	if $IsObject(obj){
		set return=obj.ToString("^")
	}
	quit return
}

/// Creator：     chenrui
/// CreatDate：   2023-03-01
/// Description:  更新表信息
/// Table：       DHCMed.EPD.HCVReferral
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.HCVReferral).Update("^43^23^测试^第二也是我^女^510125199811133815^8814^8817^^11890811566^医生01^东华标准版数字化医院[总院]^2023-03-01^备注^1","^")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set ID=$p(aInput,separete,1)
	If (ID="") {
		Set obj=##class(DHCMed.EPD.HCVReferral).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.HCVReferral).%OpenId(+ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeID       =$p(aInput,separete,2)
	Set obj.PatientID       =$p(aInput,separete,3)
	Set obj.RecHospName     =$p(aInput,separete,4)
	Set obj.PatName         =$p(aInput,separete,5)
	Set obj.PatSex       	=$p(aInput,separete,6)
	Set obj.PersonalID      =$p(aInput,separete,7)
	Set obj.HCVDetectionDr  =##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,separete,8))
	Set obj.HCVExamPlanDr   =##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,separete,9))
	Set obj.OtherPlan   	=$p(aInput,separete,10)
	Set obj.RefTelPhone     =$p(aInput,separete,11)
	Set obj.RefDoctor      	=$p(aInput,separete,12)
	Set obj.RefOrgName     	=$p(aInput,separete,13)
	Set obj.ReportDate    	=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInput,separete,14))
	Set obj.Resume      	=$p(aInput,separete,15)
	Set Status				=$p(aInput,separete,16) 	/// 报告状态
	Set Status=$CASE(Status,"1":"上报","2":"审核","3":"作废","4":"0")
	Set obj.RepStatus		 = Status 
	
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

/// Creator：     chenrui
/// CreatDate：   2016-07-21
/// Description:  根据就诊号遍历传染病报告 取报告信息
/// Table：       DHCMed.EPD.ReferralRep
/// Input：       aEpisodeID
/// Return：      
/// w ##class(DHCMed.EPD.HCVReferral).GetInfoByEPD(1045)
ClassMethod GetInfoByEPD(aEpisodeID As %String) As %String
{
	New (aEpisodeID,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return=""
	Quit:aEpisodeID="" return
	
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,xRepID))
		Quit:xRepID=""
		Quit:return'=""
		
		Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.MEPDICDDR)
		
		Continue:objRep.MEPDStatus="4"  //被订状态报告无效
		Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
		Continue:objRep.MEPDStatus="7"  //删除状态报告无效
		
		Set aDiseaseID =objRep.MEPDICDDR.%Id()
		Set EpdTypeDesc=##class(DHCMed.EPDService.InfectionSrv).GetMIFKind(aDiseaseID)
		Continue:EpdTypeDesc'="丙型病毒性肝炎"
		
		Set PatientID=objRep.MEPDPapmiDR          //PatientID
		Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
		If $IsObject(objPatient){
			Set PatientName=objPatient.PatientName      // 姓名
			Set PatientSex=objPatient.Sex               // 性别
			Set:PatientSex'="" PatientSex = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc",Languages,PatientSex)
			Set PersonalID=objPatient.PersonalID		// 身份证号
			Set:PersonalID="" PersonalID = objRep.MEPDText5	// HIS身份证如果为空，则取报告里面的身份证号
		}
		
		Set return=PatientName_"^"_PatientSex_"^"_PersonalID
	}
	Quit return
}

/// w ##class(DHCMed.EPD.HCVReferral).GetRepIDByAdm(289)
ClassMethod GetRepIDByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set xID=""
	//循环遍历找到第一个有效的报卡ID
	For
	{
		Set xID=$o(^DHCMed.EPD.HCVReferralI("EpisodeIDIndex",aEpisodeID,xID))
		Quit:xID=""
		Set obj=..GetObjById(xID)
		Quit:(obj.RepStatus'="作废")
	}
	Set return=xID
	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2023-03-01
/// Description:  审核/作废报告
/// Table：       DHCMed.EPD.HCVReferral
/// Input：       ID:    DHCMed.EPD.HCVReferral.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.HCVReferral).CheckReport(1)
ClassMethod ChangeReport(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.EPD.HCVReferral).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	Set Status=$p(aInput,separete,16)
	Set Status=$CASE(Status,"1":"上报","2":"审核","3":"作废","4":"0")
	Set obj.RepStatus=Status
	
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

/// w ##class(DHCMed.EPD.HCVReferral).GetRepStatus(1)
ClassMethod GetRepStatus(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set obj=..GetObjById(aRepID)
	Quit:'$IsObject(obj) return
	
	Set Status=obj.RepStatus
	Set return=Status
	
	Quit return
}

Storage Default
{
<Data name="HCVReferralDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>RecHospName</Value>
</Value>
<Value name="5">
<Value>PatName</Value>
</Value>
<Value name="6">
<Value>PatSex</Value>
</Value>
<Value name="7">
<Value>PersonalID</Value>
</Value>
<Value name="8">
<Value>HCVDetectionDr</Value>
</Value>
<Value name="9">
<Value>HCVExamPlanDr</Value>
</Value>
<Value name="10">
<Value>OtherPlan</Value>
</Value>
<Value name="11">
<Value>RefTelPhone</Value>
</Value>
<Value name="12">
<Value>RefDoctor</Value>
</Value>
<Value name="13">
<Value>RefOrgName</Value>
</Value>
<Value name="14">
<Value>Resume</Value>
</Value>
<Value name="15">
<Value>ReportDate</Value>
</Value>
<Value name="16">
<Value>RepStatus</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.HCVReferralD</DataLocation>
<DefaultData>HCVReferralDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.HCVReferralD</IdLocation>
<IndexLocation>^DHCMed.EPD.HCVReferralI</IndexLocation>
<StreamLocation>^DHCMed.EPD.HCVReferralS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
