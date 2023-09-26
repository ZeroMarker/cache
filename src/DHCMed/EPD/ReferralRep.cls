/// 名称: DHCMed.EPD.ReferralRep
/// 描述: 肺结核病人转诊单
/// 编写者：jiangpengpeng
/// 编写日期: 2016-07-21
Class DHCMed.EPD.ReferralRep Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 患者姓名
Property PatName As %String;

/// 性别
Property PatSex As %String;

/// 年龄
Property PatAge As %String;

/// 门诊或住院号
Property PatMrNo As %String;

/// 现住址
Property PatAddress As %String;

/// 联系电话
Property PatPhoneNo As %String;

/// 病人或户主姓名
Property FamilyName As %String;

/// 工作单位
Property WorkAddress As %String;

/// 转诊原因
Property ReferralReason As %String;

/// 转诊单位
Property ReferralHosp As %String;

/// 转诊医生
Property ReferralDoc As %String;

/// 转诊日期
Property ReferralDate As %String;

/// 地址
Property ReferralAdd As %String;

/// 联系电话
Property ReferralPhone As %String;

/// 报告状态(ReportStatus：1上报2审核3删除)
Property ReportStatus As DHCMed.SS.Dictionary;

/// 报告人
Property ReportUser As %String;

/// 报告日期
Property ReportDate As %String;

/// 报告时间
Property ReportTime As %String;

/// 病人转诊到的医院
Property PatReferralHosp As %String;

/// 就诊ID
Property EpisodeID As %String;

Index EpisodeIDIndex On EpisodeID;

Index ReportDateIndex On ReportDate As Exact;

/// w ##class(DHCMed.EPD.ReferralRep).%BuildIndices()
/// Creator：     jiangpengpeng
/// CreatDate：   2016-07-21
/// Description:  根据ID取报告信息
/// Table：       DHCMed.EPD.ReferralRep
/// Input：       ID:    DHCMed.EPD.ReferralRep.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.ReferralRep).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.EPD.ReferralRep
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.EPD.ReferralRep).%ExistsId(+id) return
	set obj=##Class(DHCMed.EPD.ReferralRep).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

Method ToString(separete As %String, lagCode As %String) As %String
{
	Set return=..PatName_separete
	Set return=return_..PatSex_separete
	Set return=return_..PatAge_separete
	Set return=return_..PatMrNo_separete
	Set return=return_..PatAddress_separete
	Set return=return_..PatPhoneNo_separete
	Set return=return_..FamilyName_separete
	Set return=return_..WorkAddress_separete
	Set return=return_..ReferralReason_separete
	Set HospitalName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",lagCode,..ReferralHosp)
	Set return=return_HospitalName_separete
	Set ReferralDoc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",lagCode,..ReferralDoc)
	Set return=return_ReferralDoc_separete
	Set return=return_..ReferralDate_separete
	Set return=return_..ReferralAdd_separete
	Set return=return_..ReferralPhone_separete
	Set return=return_..PatReferralHosp_separete
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2016-07-21
/// Description:  根据ID取报告主卡信息
/// Table：       DHCMed.EPD.ReferralRep
/// Input：       ID:    DHCMed.EPD.ReferralRep.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.ReferralRep).GetStringById(1)
ClassMethod GetStringById(id As %String, lagCode As %String) As %String
{
	new (id,lagCode)
	set return=""
	quit:id="" return
	
	set obj=##Class(DHCMed.EPD.ReferralRep).GetObjById(+id)
	if $IsObject(obj){
		set return=obj.ToString("^",lagCode)
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2016-07-21
/// Description:  更新表信息
/// Table：       DHCMed.EPD.ReferralRep
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ReferralRep).Update("","^")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set ID=$p(aInput,separete,1)
	If (ID="") {
		Set obj=##class(DHCMed.EPD.ReferralRep).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.ReferralRep).%OpenId(+ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PatName          =$p(aInput,separete,2)
	Set obj.PatSex           =$p(aInput,separete,3)
	Set obj.PatAge           =$p(aInput,separete,4)
	Set obj.PatMrNo          =$p(aInput,separete,5)
	Set obj.PatAddress       =$p(aInput,separete,6)
	Set obj.PatPhoneNo       =$p(aInput,separete,7)
	Set obj.FamilyName       =$p(aInput,separete,8)
	Set obj.WorkAddress      =$p(aInput,separete,9)
	Set obj.ReferralReason   =$p(aInput,separete,10)
	Set obj.ReferralHosp     =$p(aInput,separete,11)
	Set obj.ReferralDoc      =$p(aInput,separete,12)
	Set obj.ReferralDate     =$p(aInput,separete,13)
	Set obj.ReferralAdd      =$p(aInput,separete,14)
	Set obj.ReferralPhone    =$p(aInput,separete,15)
	Set obj.EpisodeID		 =$p(aInput,separete,16)
	Set obj.PatReferralHosp	 =$p(aInput,separete,17)
	Set ReportStatusCode     =$p(aInput,separete,18)
	Set obj.ReportStatus     =##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDReferralStatus",ReportStatusCode,1)
	// 只会保存一次
	if (ID=""){
		Set obj.ReportUser   =$p(aInput,separete,19)
		Set obj.ReportDate   =+$H
		Set obj.ReportTime   =$p($H,",",2)
	}
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2016-07-21
/// Description:  审核/删除报告
/// Table：       DHCMed.EPD.ReferralRep
/// Input：       ID:    DHCMed.EPD.ReferralRep.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.ReferralRep).CheckReport(1)
ClassMethod ChangeReport(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.EPD.ReferralRep).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	
	Set ReportStatus=$p(aInput,separete,2)
	Set obj.ReportStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDReferralStatus",ReportStatus,1)
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2016-07-21
/// Description:  根据就诊号遍历传染病报告 取报告信息
/// Table：       DHCMed.EPD.ReferralRep
/// Input：       aEpisodeID
/// Return：      
/// w ##class(DHCMed.EPD.ReferralRep).GetInfoByEPD(1045)
ClassMethod GetInfoByEPD(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
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
		//根据疾病类型判断肺结核
		Set aDiseaseID =objRep.MEPDICDDR.%Id()
		Set EpdTypeDesc=##class(DHCMed.EPDService.InfectionSrv).GetMIFKind(aDiseaseID)
		Continue:EpdTypeDesc'="肺结核"
		
		Set PatientID=objRep.MEPDPapmiDR          //PatientID
		Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
		If $IsObject(objPatient){
			Set PatientName=objPatient.PatientName      //姓名
			Set PatientSex=objPatient.Sex               //性别
			Set PatientAge=objPatient.Age				//年龄
		}
		Set PatAddress=objRep.MEPDAddress
		Set PatPhoneNo=objRep.MEPDTelPhone
		Set FamilyName=objRep.MEPDFamName
		Set WorkAddress=objRep.MEPDCompany
		Set PatMrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(aEpisodeID,"I","")
		
		Set return=PatientName_"^"_PatientSex_"^"_PatientAge_"^"_PatMrNo_"^"_PatAddress_"^"_PatPhoneNo_"^"_FamilyName_"^"_WorkAddress
	}
	Quit return
}

ClassMethod GetRepStatus(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set obj=..GetObjById(aRepID)
	Quit:'$IsObject(obj) return
	
	Set Status=obj.ReportStatus.Code
	Set return=Status
	
	Quit return
}

ClassMethod GetRepIDByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set xID=""
	//循环遍历找到第一个有效的报卡ID
	For
	{
		Set xID=$o(^DHCMed.EPD.ReferralRepI("EpisodeIDIndex"," "_aEpisodeID,xID))
		Quit:xID=""
		Set obj=..GetObjById(xID)
		Quit:$IsObject(obj.ReportStatus)&&(obj.ReportStatus.Code'="3")
	}
	Set return=xID
	
	Quit return
}

Storage Default
{
<Data name="ReferralRepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatName</Value>
</Value>
<Value name="3">
<Value>PatSex</Value>
</Value>
<Value name="4">
<Value>PatAge</Value>
</Value>
<Value name="5">
<Value>PatMrNo</Value>
</Value>
<Value name="6">
<Value>PatAddress</Value>
</Value>
<Value name="7">
<Value>PatPhoneNo</Value>
</Value>
<Value name="8">
<Value>FamilyName</Value>
</Value>
<Value name="9">
<Value>WorkAddress</Value>
</Value>
<Value name="10">
<Value>ReferralReason</Value>
</Value>
<Value name="11">
<Value>ReferralHosp</Value>
</Value>
<Value name="12">
<Value>ReferralDoc</Value>
</Value>
<Value name="13">
<Value>ReferralDate</Value>
</Value>
<Value name="14">
<Value>ReferralAdd</Value>
</Value>
<Value name="15">
<Value>ReferralPhone</Value>
</Value>
<Value name="16">
<Value>ReportStatus</Value>
</Value>
<Value name="17">
<Value>ReportUser</Value>
</Value>
<Value name="18">
<Value>ReportDate</Value>
</Value>
<Value name="19">
<Value>ReportTime</Value>
</Value>
<Value name="20">
<Value>EpisodeID</Value>
</Value>
<Value name="21">
<Value>PatReferralHosp</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.ReferralRepD</DataLocation>
<DefaultData>ReferralRepDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.ReferralRepD</IdLocation>
<IndexLocation>^DHCMed.EPD.ReferralRepI</IndexLocation>
<StreamLocation>^DHCMed.EPD.ReferralRepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
