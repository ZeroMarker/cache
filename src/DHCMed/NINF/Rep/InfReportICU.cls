/// 名称: DHCMed.NINF.Rep.InfReportICU
/// 描述: 重症监护插管信息
/// 编写者：zhufei
/// 编写日期: 2012-12-28
Class DHCMed.NINF.Rep.InfReportICU Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.InfReport [ Cardinality = parent, Inverse = ChildICU ];

/// 数据来源
/// 指向医嘱表   格式:"OEITEM:OE_OrdItem.RowID"
Property DataSource As %String(TRUNCATE = 1);

/// 置管类型("NINFICUIntubateType")
/// 中央导管、呼吸机、导尿管、NICU中央导管、NICU气管插管、NICU脐静脉
Property IntubateType As DHCMed.SS.Dictionary;

/// 置管日期
Property IntubateDate As %Date;

/// 置管时间
Property IntubateTime As %Time;

/// 拔管日期
Property ExtubateDate As %Date;

/// 拔管时间
Property ExtubateTime As %Time;

/// 置管地点("NINFICUIntubatePlace")
Property IntubatePlace As DHCMed.SS.Dictionary;

/// 置管人员类型("NINFICUIntubateUserType")
Property IntubateUserType As DHCMed.SS.Dictionary;

/// 置管人员 指向SS_User
Property IntubateUser As %String(TRUNCATE = 1);

/// 感染日期
Property InfDate As %Date;

/// 病原菌
Property InfPathogeny As list Of DHCMed.NINF.Rep.InfReportICUPy;

/// 中央导管 置管方位("NINFICUPICCIntubatePos")
Property PICCIntubatePos As DHCMed.SS.Dictionary;

/// 中央导管 置管内径("NINFICUPICCIntubateSize")
Property PICCIntubateSize As DHCMed.SS.Dictionary;

/// 中央导管 导管类型("NINFICUPICCIntubateType")
Property PICCIntubateType As DHCMed.SS.Dictionary;

/// 中央导管 置管腔数("NINFICUPICCIntubateNum")
Property PICCIntubateNum As DHCMed.SS.Dictionary;

/// 中央导管 置管部位("NINFICUPICCIntubateRegion")
Property PICCIntubateRegion As DHCMed.SS.Dictionary;

/// 中央导管 拔管原因("NINFICUPICCExtubateReason")
Property PICCExtubateReason As DHCMed.SS.Dictionary;

/// 导尿管 尿袋类型("NINFICUUCUrineBagType")
Property UCUrineBagType As DHCMed.SS.Dictionary;

/// 呼吸机 气道类型("NINFInfVAPIntubateType")
Property VAPIntubateType As DHCMed.SS.Dictionary;

/// 置管感染类型 "NINFICUIntubateINFSymptom") Add By LiYang 2014-04-10
Property INFSymptom As DHCMed.SS.Dictionary;

/// 置管日期索引
Index IndexIntubateDate On (IntubateType As Exact, IntubateDate As Exact, ParRef As Exact);

/// 拔管日期索引
Index IndexExtubateDate On (IntubateType As Exact, ExtubateDate As Exact, ParRef As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-12-28
/// Description:  取重症监护插管信息
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input：       DHCMed.NINF.Rep.InfReportICU.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportICU).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.InfReportICU
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.InfReportICU).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-12-28
/// Description:  更新重症监护插管信息
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportICU).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Set CHR3=$p(aSeparate,",",3)
	Quit:(CHR1="")||(CHR2="")||(CHR3="") return
	
	Set ParRef=$p(aInput,CHR1,1)
	Set ChildSub=$p(aInput,CHR1,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.InfReportICU).%New()
		Set obj.ParRef=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ParRef)
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.InfReportICU).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.ParRef) return
	
	//置管类型、置管日期、置管时间、拔管日期、拔管时间
	//置管地点、置管人员类型、置管人员
	Set obj.IntubateType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,3))
	Set obj.IntubateDate=$p(aInput,CHR1,4)
	Set obj.IntubateTime=$p(aInput,CHR1,5)
	Set obj.ExtubateDate=$p(aInput,CHR1,6)
	Set obj.ExtubateTime=$p(aInput,CHR1,7)
	Set obj.IntubatePlace=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,8))
	Set obj.IntubateUserType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,9))
	Set obj.IntubateUser=$p(aInput,CHR1,10)
	//感染日期、病原体
	Set obj.InfDate=$p(aInput,CHR1,11)
	While (obj.InfPathogeny.Count()>0) {
		Do obj.InfPathogeny.RemoveAt(1)
	}
	Set InfPyList=$p(aInput,CHR1,12)
	Set InfPyLB=""
	For indPy=1:1:$length(InfPyList,CHR2) {
		Set InfPy=$p(InfPyList,CHR2,indPy)
		Continue:($listfind(InfPyLB,InfPy)>0)
		Set InfPyLB=InfPyLB_$lb(InfPy)
		Set objInfPy=##class(DHCMed.NINF.Rep.InfReportICUPy).GetObj(InfPy,CHR3)
		Continue:'$IsObject(objInfPy)
		Do obj.InfPathogeny.Insert(objInfPy)
	}
	
	//中央导管 置管方位、置管内径、导管类型、置管腔数、置管部位、拔管原因
	Set obj.PICCIntubatePos=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,13))
	Set obj.PICCIntubateSize=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,14))
	Set obj.PICCIntubateType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,15))
	Set obj.PICCIntubateNum=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,16))
	Set obj.PICCIntubateRegion=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,17))
	Set obj.PICCExtubateReason=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,18))
	
	//导尿管 尿袋类型
	Set obj.UCUrineBagType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,19))
	
	//呼吸机 气道类型
	Set obj.VAPIntubateType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,20))
	
	//数据来源
	Set obj.DataSource=$p(aInput,CHR1,21)
	
	//置管感染类型 "NINFICUIntubateINFSymptom" Add By LiYang 2014-04-10
	Set obj.INFSymptom=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,22))
	
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
/// CreatDate：   2012-12-28
/// Description:  删除重症监护插管信息
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input：       DHCMed.NINF.Rep.InfReportICU.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportICU).DeleteById("1||3")
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.InfReportICU).%DeleteId(aId)
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
<Value>IntubateType</Value>
</Value>
<Value name="3">
<Value>IntubateDate</Value>
</Value>
<Value name="4">
<Value>IntubateTime</Value>
</Value>
<Value name="5">
<Value>ExtubateDate</Value>
</Value>
<Value name="6">
<Value>ExtubateTime</Value>
</Value>
<Value name="7">
<Value>IntubatePlace</Value>
</Value>
<Value name="8">
<Value>IntubateUserType</Value>
</Value>
<Value name="9">
<Value>IntubateUser</Value>
</Value>
<Value name="10">
<Value>InfDate</Value>
</Value>
<Value name="11">
<Value>InfPathogeny</Value>
</Value>
<Value name="12">
<Value>PICCIntubatePos</Value>
</Value>
<Value name="13">
<Value>PICCIntubateSize</Value>
</Value>
<Value name="14">
<Value>PICCIntubateType</Value>
</Value>
<Value name="15">
<Value>PICCIntubateNum</Value>
</Value>
<Value name="16">
<Value>PICCIntubateRegion</Value>
</Value>
<Value name="17">
<Value>PICCExtubateReason</Value>
</Value>
<Value name="18">
<Value>UCUrineBagType</Value>
</Value>
<Value name="19">
<Value>VAPIntubateType</Value>
</Value>
<Value name="20">
<Value>DataSource</Value>
</Value>
<Value name="21">
<Value>INFSymptom</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ICU")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ICU")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"ICU")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.InfReportICUS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
