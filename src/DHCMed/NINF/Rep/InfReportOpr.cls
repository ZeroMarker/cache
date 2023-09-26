/// 名称: DHCMed.NINF.Rep.InfReportOpr
/// 描述: 医院感染报告 手术相关
/// 编写者：zhufei
/// 编写日期: 2012-06-19
Class DHCMed.NINF.Rep.InfReportOpr Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.InfReport [ Cardinality = parent, Inverse = ChildOpr ];

/// 数据来源
/// 指向手术麻醉   格式:"OPANA:手术麻醉系统.RowID"
/// 指向手术医嘱   格式:"OEITEM:OE_OrdItem.RowID"
Property DataSource As %String(TRUNCATE = 1);

/// 手术ID 指向ORC_Operation
Property OperationID As %String(TRUNCATE = 1);

/// 手术名称
Property OperationDesc As %String(TRUNCATE = 1);

/// 开始日期
Property OperStartDate As %Date;

/// 开始时间
Property OperStartTime As %Time;

/// 结束日期
Property OperEndDate As %Date;

/// 结束时间
Property OperEndTime As %Time;

/// 手术医生 指向SS_User
Property OperDoc As %String(TRUNCATE = 1);

/// 手术类型("NINFInfOperationType")
Property OperationType As DHCMed.SS.Dictionary;

/// 麻醉方式("NINFInfAnesthesia")
Property Anesthesia As DHCMed.SS.Dictionary;

/// 切口类型("NINFInfCuteType")
Property CuteType As DHCMed.SS.Dictionary;

/// 愈合情况("NINFInfCuteHealing")
Property CuteHealing As DHCMed.SS.Dictionary;

/// 切口感染("NINFInfCuteInfFlag")(是/否)
Property CuteInfFlag As DHCMed.SS.Dictionary;

/// 手术感染类型("NINFInfOperInfType")
Property OperInfType As DHCMed.SS.Dictionary;

/// 引起院内感染("NINFInfInHospInfFlag")(是/否)
Property InHospInfFlag As DHCMed.SS.Dictionary;

/// ASA(麻醉)评分("NINFInfASAScore")
Property ASAScore As DHCMed.SS.Dictionary;

/// 术前外周WBC计数(×10^9/L)
Property PreoperWBC As %String(TRUNCATE = 1);

/// 切口个数("NINFInfCuteNumber")
Property CuteNumber As DHCMed.SS.Dictionary;

/// 使用窥镜("NINFInfEndoscopeFlag")(是/否)
Property EndoscopeFlag As DHCMed.SS.Dictionary;

/// 植入物("NINFInfImplantFlag")(是/否)
Property ImplantFlag As DHCMed.SS.Dictionary;

/// 术前口服抗生素肠道准备("NINFInfPreoperAntiFlag")(是/否)
Property PreoperAntiFlag As DHCMed.SS.Dictionary;

/// 失血("NINFInfBloodLossFlag")(是/否)
Property BloodLossFlag As DHCMed.SS.Dictionary;

/// 失血量(MLS)
Property BloodLoss As %String(TRUNCATE = 1);

/// 输血("NINFInfBloodTransFlag")(是/否)
Property BloodTransFlag As DHCMed.SS.Dictionary;

/// 输血量(MLS)
Property BloodTrans As %String(TRUNCATE = 1);

/// 术后并发症("NINFInfPostoperComps")
Property PostoperComps As list Of DHCMed.SS.Dictionary;

/// 手术日期索引
Index IndexStDate On (OperStartDate As Exact, ParRef As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input：       DHCMed.NINF.Rep.InfReportOpr.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.InfReportOpr
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.InfReportOpr).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportOpr).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Quit:(CHR1="")||(CHR2="") return
	
	Set ParRef=$p(aInput,CHR1,1)
	Set objParRef=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ParRef)
	Quit:'$IsObject(objParRef) return
	Set ChildSub=$p(aInput,CHR1,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.InfReportOpr).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.InfReportOpr).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	Set obj.ParRef=objParRef
	Set obj.DataSource=$p(aInput,CHR1,3)
	Set obj.OperationID=$p(aInput,CHR1,4)
	Set obj.OperationDesc=$p(aInput,CHR1,5)
	Set obj.OperStartDate=$p(aInput,CHR1,6)
	Set obj.OperStartTime=$p(aInput,CHR1,7)
	Set obj.OperEndDate=$p(aInput,CHR1,8)
	Set obj.OperEndTime=$p(aInput,CHR1,9)
	Set obj.OperDoc=$p(aInput,CHR1,10)
	Set obj.OperationType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,11))
	Set obj.Anesthesia=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,12))
	Set obj.CuteType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,13))
	Set obj.CuteHealing=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,14))
	Set obj.CuteInfFlag=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,15))
	Set obj.OperInfType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,16))
	Set obj.InHospInfFlag=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,17))
	Set obj.ASAScore=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,18))
	Set obj.PreoperWBC=$p(aInput,CHR1,19)
	Set obj.CuteNumber=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,20))
	Set obj.EndoscopeFlag=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,21))
	Set obj.ImplantFlag=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,22))
	Set obj.PreoperAntiFlag=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,23))
	Set obj.BloodLossFlag=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,24))
	Set obj.BloodLoss=$p(aInput,CHR1,25)
	Set obj.BloodTransFlag=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,26))
	Set obj.BloodTrans=$p(aInput,CHR1,27)
	
	Set PostoperComps=$p(aInput,CHR1,28)
	While (obj.PostoperComps.Count()>0) {
		Do obj.PostoperComps.RemoveAt(1)
	}
	Set PostoperCompLB=""
	For ind=1:1:$length(PostoperComps,CHR2) {
		Set PostoperComp=$p(PostoperComps,CHR2,ind)
		Continue:($listfind(PostoperCompLB,PostoperComp)>0)
		Set PostoperCompLB=PostoperCompLB_$lb(PostoperComp)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(PostoperComp)
		Continue:'$IsObject(objDic)
		Do obj.PostoperComps.Insert(objDic)
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

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  删除医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input：       DHCMed.NINF.Rep.InfReportOpr.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportOpr).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.InfReportOpr).%DeleteId(aId)
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
<Value>OperationID</Value>
</Value>
<Value name="4">
<Value>OperationDesc</Value>
</Value>
<Value name="5">
<Value>OperStartDate</Value>
</Value>
<Value name="6">
<Value>OperStartTime</Value>
</Value>
<Value name="7">
<Value>OperEndDate</Value>
</Value>
<Value name="8">
<Value>OperEndTime</Value>
</Value>
<Value name="9">
<Value>OperDoc</Value>
</Value>
<Value name="10">
<Value>OperationType</Value>
</Value>
<Value name="11">
<Value>Anesthesia</Value>
</Value>
<Value name="12">
<Value>CuteType</Value>
</Value>
<Value name="13">
<Value>CuteHealing</Value>
</Value>
<Value name="14">
<Value>CuteInfFlag</Value>
</Value>
<Value name="15">
<Value>OperInfType</Value>
</Value>
<Value name="16">
<Value>InHospInfFlag</Value>
</Value>
<Value name="17">
<Value>ASAScore</Value>
</Value>
<Value name="18">
<Value>PreoperWBC</Value>
</Value>
<Value name="19">
<Value>CuteNumber</Value>
</Value>
<Value name="20">
<Value>EndoscopeFlag</Value>
</Value>
<Value name="21">
<Value>ImplantFlag</Value>
</Value>
<Value name="22">
<Value>PreoperAntiFlag</Value>
</Value>
<Value name="23">
<Value>BloodLossFlag</Value>
</Value>
<Value name="24">
<Value>BloodLoss</Value>
</Value>
<Value name="25">
<Value>BloodTransFlag</Value>
</Value>
<Value name="26">
<Value>BloodTrans</Value>
</Value>
<Value name="27">
<Value>PostoperComps</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Opr")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Opr")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"Opr")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.InfReportOprS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
