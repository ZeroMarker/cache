/// 住院抗菌药物使用率分析
/// 创建者：zhufei
/// 创建时间：2014-03-20
Class DHCMed.DP.Stat.IPAntiUsage Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String [ SqlColumnNumber = 2, SqlFieldName = EpisodeID ];

/// 数据类型（D出院、A在院）
Property DataType As %String [ SqlColumnNumber = 3, SqlFieldName = DataType ];

/// 科室
Property ActDept As %String [ SqlColumnNumber = 4, SqlFieldName = ActDept ];

/// 病区
Property ActWard As %String [ SqlColumnNumber = 5, SqlFieldName = ActWard ];

/// 日期
Property ActDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ActDate ];

/// 时间
Property ActTime As %Time [ SqlColumnNumber = 7, SqlFieldName = ActTime ];

/// 使用抗生素标记
Property AntiUseFlag As %String [ SqlColumnNumber = 8, SqlFieldName = AntiUseFlag ];

/// 用药目的 治疗\预防
Property AntiObject As %String [ SqlColumnNumber = 9, SqlFieldName = AntiObject ];

/// 抗菌药物DDD频数
Property AntiDDDs As %String [ SqlColumnNumber = 10, SqlFieldName = AntiDDDs ];

/// 是否送检标记
Property SubmitFlag As %String [ SqlColumnNumber = 11, SqlFieldName = SubmitFlag ];

/// 使用抗生素标记（非限制使用抗菌药物）
Property KSS1UseFlag As %String [ SqlColumnNumber = 12, SqlFieldName = KSS1UseFlag ];

/// 用药目的 治疗\预防（非限制使用抗菌药物）
Property KSS1Object As %String [ SqlColumnNumber = 13, SqlFieldName = KSS1Object ];

/// 抗菌药物DDD频数（非限制使用抗菌药物）
Property KSS1DDDs As %String [ SqlColumnNumber = 14, SqlFieldName = KSS1DDDs ];

/// 使用抗生素标记（限制使用抗菌药物）
Property KSS2UseFlag As %String [ SqlColumnNumber = 15, SqlFieldName = KSS2UseFlag ];

/// 用药目的 治疗\预防（限制使用抗菌药物）
Property KSS2Object As %String [ SqlColumnNumber = 16, SqlFieldName = KSS2Object ];

/// 抗菌药物DDD频数（限制使用抗菌药物）
Property KSS2DDDs As %String [ SqlColumnNumber = 17, SqlFieldName = KSS2DDDs ];

/// 使用抗生素标记（特殊使用抗菌药物）
Property KSS3UseFlag As %String [ SqlColumnNumber = 18, SqlFieldName = KSS3UseFlag ];

/// 用药目的 治疗\预防（特殊使用抗菌药物）
Property KSS3Object As %String [ SqlColumnNumber = 19, SqlFieldName = KSS3Object ];

/// 抗菌药物DDD频数（特殊使用抗菌药物）
Property KSS3DDDs As %String [ SqlColumnNumber = 20, SqlFieldName = KSS3DDDs ];

/// Creator：     zhufei
/// CreatDate：   2014-03-20
/// Description:  获取住院抗菌药物使用率数据对象
/// Table：       DHCMed.DP.Stat.IPAntiUsage
/// Input：       DHCMed.DP.Stat.IPAntiUsage.ID
/// Return：      Object
/// w ##class(DHCMed.DP.Stat.IPAntiUsage).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Stat.IPAntiUsage
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Stat.IPAntiUsage).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Stat.IPAntiUsage).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-20
/// Description:  更新住院抗菌药物使用率数据对象
/// Table：       DHCMed.DP.Stat.IPAntiUsage
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Stat.IPAntiUsage).Update("","^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Stat.IPAntiUsage).%New()
	} else {
		set obj=##class(DHCMed.DP.Stat.IPAntiUsage).%OpenId(ID)
	}
	
	set obj.EpisodeID    = $p(InStr,separete,1)
	set obj.DataType     = $p(InStr,separete,2)
	set obj.ActDept      = $p(InStr,separete,3)
	set obj.ActWard      = $p(InStr,separete,4)
	set obj.ActDate      = $p(InStr,separete,5)
	set obj.ActTime      = $p(InStr,separete,6)
	set obj.AntiUseFlag  = $p(InStr,separete,7)
	set obj.AntiObject   = $p(InStr,separete,8)
	set obj.AntiDDDs     = $p(InStr,separete,9)
	set obj.SubmitFlag   = $p(InStr,separete,10)
	set obj.KSS1UseFlag  = $p(InStr,separete,11)
	set obj.KSS1Object   = $p(InStr,separete,12)
	set obj.KSS1DDDs     = $p(InStr,separete,13)
	set obj.KSS2UseFlag  = $p(InStr,separete,14)
	set obj.KSS2Object   = $p(InStr,separete,15)
	set obj.KSS2DDDs     = $p(InStr,separete,16)
	set obj.KSS3UseFlag  = $p(InStr,separete,17)
	set obj.KSS3Object   = $p(InStr,separete,18)
	set obj.KSS3DDDs     = $p(InStr,separete,19)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Creator：     zhufei
/// CreatDate：   2014-02-18
/// Description:  删除住院抗菌药物使用率数据对象
/// Table：       DHCMed.DP.Stat.IPAntiUsage
/// Input：       DHCMed.DP.Stat.IPAntiUsage.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Stat.IPAntiUsage).%DeleteId(aId)
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
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>DataType</Value>
</Value>
<Value name="4">
<Value>ActDept</Value>
</Value>
<Value name="5">
<Value>ActWard</Value>
</Value>
<Value name="6">
<Value>ActDate</Value>
</Value>
<Value name="7">
<Value>ActTime</Value>
</Value>
<Value name="8">
<Value>AntiUseFlag</Value>
</Value>
<Value name="9">
<Value>AntiObject</Value>
</Value>
<Value name="10">
<Value>AntiDDDs</Value>
</Value>
<Value name="11">
<Value>SubmitFlag</Value>
</Value>
<Value name="12">
<Value>KSS1UseFlag</Value>
</Value>
<Value name="13">
<Value>KSS1Object</Value>
</Value>
<Value name="14">
<Value>KSS1DDDs</Value>
</Value>
<Value name="15">
<Value>KSS2UseFlag</Value>
</Value>
<Value name="16">
<Value>KSS2Object</Value>
</Value>
<Value name="17">
<Value>KSS2DDDs</Value>
</Value>
<Value name="18">
<Value>KSS3UseFlag</Value>
</Value>
<Value name="19">
<Value>KSS3Object</Value>
</Value>
<Value name="20">
<Value>KSS3DDDs</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Stat.IPAntiUsageD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Stat.IPAntiUsageD</IdLocation>
<IndexLocation>^DHCMed.DP.Stat.IPAntiUsageI</IndexLocation>
<StreamLocation>^DHCMed.DP.Stat.IPAntiUsageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
