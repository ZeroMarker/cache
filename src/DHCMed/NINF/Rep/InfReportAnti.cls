/// 名称: DHCMed.NINF.Rep.InfReportAnti
/// 描述: 医院感染报告 抗菌用药
/// 编写者：zhufei
/// 编写日期: 2012-06-19
Class DHCMed.NINF.Rep.InfReportAnti Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.InfReport [ Cardinality = parent, Inverse = ChildAnti ];

/// 数据来源
/// 指向医嘱表   格式:"OEITEM:OE_OrdItem.RowID"
Property DataSource As %String(TRUNCATE = 1);

/// 医嘱ID
Property ArcimID As %String(TRUNCATE = 1);

/// 医嘱名称
Property ArcimDesc As %String(TRUNCATE = 1);

/// 开始日期
Property StartDate As %Date;

/// 开始时间
Property StartTime As %Time;

/// 结束日期
Property EndDate As %Date;

/// 结束时间
Property EndTime As %Time;

/// 剂量
Property DoseQty As %String(TRUNCATE = 1);

/// 剂量单位 指向CT_UOM
Property DoseUnit As %String(TRUNCATE = 1);

/// 频次 指向PHC_Freq
Property PhcFreq As %String(TRUNCATE = 1);

/// 用途("NINFInfMedUsePurpose")
Property MedUsePurpose As DHCMed.SS.Dictionary;

/// 给药途径("NINFInfAdminRoute")
Property AdminRoute As DHCMed.SS.Dictionary;

/// 目的("NINFInfMedPurpose")
Property MedPurpose As DHCMed.SS.Dictionary;

/// 治疗用药方式("NINFInfTreatmentMode")
Property TreatmentMode As DHCMed.SS.Dictionary;

/// 预防用药指征("NINFInfPreMedIndicat")
Property PreMedIndicat As DHCMed.SS.Dictionary;

/// 预防用药效果("NINFInfPreMedEffect")
Property PreMedEffect As DHCMed.SS.Dictionary;

/// 联合用药("NINFInfCombinedMed")
Property CombinedMed As DHCMed.SS.Dictionary;

/// 术前用药时间(分钟)
Property PreMedTime As %String(TRUNCATE = 1);

/// 术后用药天数(天)
Property PostMedDays As %String(TRUNCATE = 1);

/// 敏感度("NINFInfSenAna")
Property SenAna As DHCMed.SS.Dictionary;

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 抗菌用药
/// Table：       DHCMed.NINF.Rep.InfReportAnti
/// Input：       DHCMed.NINF.Rep.InfReportAnti.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportAnti).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.InfReportAnti
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.InfReportAnti).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 抗菌用药
/// Table：       DHCMed.NINF.Rep.InfReportAnti
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportAnti).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set CHR1=$p(aSeparate,",",1)
	Quit:(CHR1="") return
	
	Set ParRef=$p(aInput,CHR1,1)
	Set ChildSub=$p(aInput,CHR1,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.InfReportAnti).%New()
		
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.InfReportAnti).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ParRef)
	
	Set obj.DataSource=$p(aInput,CHR1,3)
	Set obj.ArcimID=$p(aInput,CHR1,4)
	Set obj.ArcimDesc=$p(aInput,CHR1,5)
	Set obj.StartDate=$p(aInput,CHR1,6)
	Set obj.StartTime=$p(aInput,CHR1,7)
	Set obj.EndDate=$p(aInput,CHR1,8)
	Set obj.EndTime=$p(aInput,CHR1,9)
	Set obj.DoseQty=$p(aInput,CHR1,10)
	Set obj.DoseUnit=$p(aInput,CHR1,11)
	Set obj.PhcFreq=$p(aInput,CHR1,12)
	Set obj.MedUsePurpose=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,13))
	Set obj.AdminRoute=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,14))
	Set obj.MedPurpose=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,15))
	Set obj.TreatmentMode=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,16))
	Set obj.PreMedIndicat=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,17))
	Set obj.PreMedEffect=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,18))
	Set obj.CombinedMed=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,19))
	Set obj.PreMedTime=$p(aInput,CHR1,20)
	Set obj.PostMedDays=$p(aInput,CHR1,21)
	Set obj.SenAna=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,22))
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

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  删除医院感染报告 抗菌用药
/// Table：       DHCMed.NINF.Rep.InfReportAnti
/// Input：       DHCMed.NINF.Rep.InfReportAnti.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportAnti).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.InfReportAnti).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataSource</Value>
</Value>
<Value name="3">
<Value>ArcimID</Value>
</Value>
<Value name="4">
<Value>ArcimDesc</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>StartTime</Value>
</Value>
<Value name="7">
<Value>EndDate</Value>
</Value>
<Value name="8">
<Value>EndTime</Value>
</Value>
<Value name="9">
<Value>DoseQty</Value>
</Value>
<Value name="10">
<Value>DoseUnit</Value>
</Value>
<Value name="11">
<Value>PhcFreq</Value>
</Value>
<Value name="12">
<Value>MedUsePurpose</Value>
</Value>
<Value name="13">
<Value>AdminRoute</Value>
</Value>
<Value name="14">
<Value>MedPurpose</Value>
</Value>
<Value name="15">
<Value>TreatmentMode</Value>
</Value>
<Value name="16">
<Value>PreMedIndicat</Value>
</Value>
<Value name="17">
<Value>PreMedEffect</Value>
</Value>
<Value name="18">
<Value>CombinedMed</Value>
</Value>
<Value name="19">
<Value>PreMedTime</Value>
</Value>
<Value name="20">
<Value>PostMedDays</Value>
</Value>
<Value name="21">
<Value>SenAna</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Anti")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Anti")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"Anti")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.InfReportAntiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
