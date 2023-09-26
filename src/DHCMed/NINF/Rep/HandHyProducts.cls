/// 名称: DHCMed.NINF.Rep.HandHyProducts
/// 描述: 手卫生用品消耗量
/// 编写者：zhufei
/// 编写日期: 2013-07-19
Class DHCMed.NINF.Rep.HandHyProducts Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCMed.NINF.Rep.HandHyProductsLog [ Cardinality = children, Inverse = ParRef ];

/// 调查科室 指向CT_Loc
Property HHPExamLoc As %String(TRUNCATE = 1);

/// 调查日期
Property HHPExamDate As %Date;

/// 手卫生用品
Property HHPProduct As DHCMed.NINF.Dic.HandHyProducts;

/// 手卫生用品消耗量
Property HHPConsumption As %String(TRUNCATE = 1);

/// 报告日期
Property HHPRepDate As %Date;

/// 报告时间
Property HHPRepTime As %Time;

/// 报告科室 指向CT_Loc
Property HHPRepLoc As %String(TRUNCATE = 1);

/// 报告人 指向SS_User
Property HHPRepUser As %String(TRUNCATE = 1);

/// 报告状态("NINFHandHyReportStatus")
Property HHPRepStatus As DHCMed.SS.Dictionary;

/// 备注
Property HHPResume As %String(TRUNCATE = 1);

Index IndexExamDateLoc On (HHPExamDate As Exact, HHPExamLoc As Exact);

Index IndexRepDateLoc On (HHPRepDate As Exact, HHPRepLoc As Exact);

/// Creator：     zhufei
/// CreatDate：   2013-07-19
/// Description:  取手卫生用品消耗量信息
/// Table：       DHCMed.NINF.Rep.HandHyProducts
/// Input：       DHCMed.NINF.Rep.HandHyProducts.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.HandHyProducts).GetObjById("1")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.HandHyProducts
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.HandHyProducts).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2013-07-19
/// Description:  更新手卫生用品消耗量信息
/// Table：       DHCMed.NINF.Rep.HandHyProducts
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.HandHyProducts).Update("","")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Rep.HandHyProducts).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.HandHyProducts).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.HHPExamLoc=$p(aInput,aSeparate,2)
	Set ExamDate=$p(aInput,aSeparate,3)
	Set:ExamDate["-" ExamDate=$zdh(ExamDate,3)
	Set obj.HHPExamDate=ExamDate
	Set obj.HHPProduct=##class(DHCMed.NINF.Dic.HandHyProducts).GetObjById($p(aInput,aSeparate,4))
	Set obj.HHPConsumption=$p(aInput,aSeparate,5)
	Set RepDate=+$h
	Set RepTime=$p($h,",",2)
	Set RepLoc=$p(aInput,aSeparate,6)
	Set RepUser=$p(aInput,aSeparate,7)
	Set RepStatus=$p(aInput,aSeparate,8)
	Set Resume=$p(aInput,aSeparate,9)
	If ID="" {
		Set obj.HHPRepDate=RepDate
		Set obj.HHPRepTime=RepTime
		Set obj.HHPRepLoc=RepLoc
		Set obj.HHPRepUser=RepUser
	}
	Set obj.HHPRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatus)
	Set obj.HHPResume=Resume

	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set UpdateLog=obj.%Id()_"^"_RepLoc_"^"_RepUser_"^"_RepStatus_"^"_Resume
		Set flg=##Class(DHCMed.NINF.Rep.HandHyProductsLog).Update(UpdateLog,"^")
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HHPExamLoc</Value>
</Value>
<Value name="3">
<Value>HHPExamDate</Value>
</Value>
<Value name="4">
<Value>HHPProduct</Value>
</Value>
<Value name="5">
<Value>HHPConsumption</Value>
</Value>
<Value name="6">
<Value>HHPRepDate</Value>
</Value>
<Value name="7">
<Value>HHPRepTime</Value>
</Value>
<Value name="8">
<Value>HHPRepLoc</Value>
</Value>
<Value name="9">
<Value>HHPRepUser</Value>
</Value>
<Value name="10">
<Value>HHPRepStatus</Value>
</Value>
<Value name="11">
<Value>HHPResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("HHP")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("HHP")</IdLocation>
<IndexLocation>^DHCMed.NINFi("HHP",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.HandHyProductsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
