/// 名称: DHCMed.NINF.Rep.HandHyProductsLog
/// 描述: 手卫生用品消耗量 更新日志
/// 编写者：zhufei
/// 编写日期: 2013-07-19
Class DHCMed.NINF.Rep.HandHyProductsLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.HandHyProducts [ Cardinality = parent, Inverse = ChildLog ];

/// 更新科室 指向CT_Loc
Property LogLoc As %String(TRUNCATE = 1);

/// 更新人员 指向SS_User
Property LogUser As %String(TRUNCATE = 1);

/// 更新日期
Property LogDate As %Date;

/// 更新时间
Property LogTime As %Time;

/// 更新状态("NINFEnviHyReportStatus")
Property LogStatus As DHCMed.SS.Dictionary;

/// 备注
Property LogResume As %String(MAXLEN = 200, TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2013-07-19
/// Description:  取手卫生用品消耗量 更新日志
/// Table：       DHCMed.NINF.Rep.HandHyProductsLog
/// Input：       DHCMed.NINF.Rep.HandHyProductsLog.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.HandHyProductsLog).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.HandHyProductsLog
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.HandHyProductsLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2013-07-19
/// Description:  更新手卫生用品消耗量 更新日志
/// Table：       DHCMed.NINF.Rep.HandHyProductsLog
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.HandHyProductsLog).Update("3/117/9/5580/","/")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set CHR1=$p(aSeparate,",",1)
	Quit:(CHR1="") return
	
	Set obj=##Class(DHCMed.NINF.Rep.HandHyProductsLog).%New()
	Set ParRef=$p(aInput,CHR1,1)
	Set obj.ParRef=##class(DHCMed.NINF.Rep.HandHyProducts).GetObjById(ParRef)
	Set obj.LogLoc=$p(aInput,CHR1,2)
	Set obj.LogUser=$p(aInput,CHR1,3)
	Set obj.LogDate=+$h
	Set obj.LogTime=$p($h,",",2)
	Set StatusID=$p(aInput,CHR1,4)
	Set obj.LogStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Set obj.LogResume=$p(aInput,CHR1,5)
	
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LogLoc</Value>
</Value>
<Value name="3">
<Value>LogUser</Value>
</Value>
<Value name="4">
<Value>LogDate</Value>
</Value>
<Value name="5">
<Value>LogTime</Value>
</Value>
<Value name="6">
<Value>LogStatus</Value>
</Value>
<Value name="7">
<Value>LogResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^DHCMed.NINFi("HHP",0,"Log")</IndexLocation>
<StreamLocation>^DHCMed.NINF493.HandHyProducts5F1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
