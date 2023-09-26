/// 名称: DHCMed.NINF.BC.Warning
/// 描述: 爆发预警记录
/// 编写者：zhufei
/// 编写日期: 2013-12-03
Class DHCMed.NINF.BC.Warning Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 主题配置代码
Property WASubjectCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WA_SubjectCode ];

/// 就诊号
Property WAEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WA_EpisodeID ];

/// 就诊号
Property WAResultID As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = WA_ResultID ];

/// 预警日期
Property WAActDate As %Date [ SqlColumnNumber = 4, SqlFieldName = WA_ActDate ];

/// 预警时间
Property WAActTime As %Time [ SqlColumnNumber = 5, SqlFieldName = WA_ActTime ];

/// 预警项目代码
Property WAItemCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = WA_ItemCode ];

/// 预警项目名称
Property WAItemDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = WA_ItemDesc ];

/// 预警信息值
Property WADataValue As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = WA_DataValue ];

/// 关键字
Property WAKeyWord As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = WA_KeyWord ];

/// 预警信息摘要
Property WADataSummary As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = WA_DataSummary ];

/// 预警科室
Property WAActDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = WA_ActDept ];

/// 预警病区
Property WAActWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = WA_ActWard ];

/// 是否有效
Property WAIsActive As %Boolean [ SqlColumnNumber = 12, SqlFieldName = WA_IsActive ];

/// 备注
Property WAResume As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = WA_Resume ];

Index IndexSubjectDate On (WASubjectCode As Exact, WAActDate As Exact);

Index IndexDateEpisodeID On (WAActDate As Exact, WAEpisodeID As Exact);

Index IndexResultID On WAResultID As Exact;

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据ID取爆发预警记录
/// Table：       DHCMed.NINF.BC.Warning
/// Input：       ID:    DHCMed.NINF.BC.Warning.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.NINF.BC.Warning).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.BC.Warning
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.BC.Warning).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.BC.Warning).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  更新爆发预警记录
/// Table：       DHCMed.NINF.BC.Warning
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.NINF.BC.Warning).Update("","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set:$g(separete)="" separete=..#SEPARATE
	set ID          = $p(InStr,separete,1)
	set SubjectCode = $p(InStr,separete,2)
	set EpisodeID   = $p(InStr,separete,3)
	set ActDate     = $p(InStr,separete,4)
	set:ActDate="" ActDate=+$h
	set ActTime     = $p(InStr,separete,5)
	set:ActTime="" ActTime=$p($h,",",2)
	set ItemCode    = $p(InStr,separete,6)
	set ItemDesc    = $p(InStr,separete,7)
	set DataValue   = $p(InStr,separete,8)
	set WAKeyWord   = $p(InStr,separete,9)
	set DataSummary = $p(InStr,separete,10)
	set ActDept     = $p(InStr,separete,11)
	set ActWard     = $p(InStr,separete,12)
	set IsActive    = +$p(InStr,separete,13)
	set Resume      = $p(InStr,separete,14)
	set ResultID    = $p(InStr,separete,15)
	quit:(SubjectCode="")||(EpisodeID="")||(ItemCode="")||(ItemDesc="")||(DataValue="")||(ResultID="") return
	
	if ID="" {
		set obj=##class(DHCMed.NINF.BC.Warning).%New()
	}else{
		set obj=##class(DHCMed.NINF.BC.Warning).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.WASubjectCode = SubjectCode
	set obj.WAEpisodeID   = EpisodeID
	set obj.WAActDate     = ActDate
	set obj.WAActTime     = ActTime
	set obj.WAItemCode    = ItemCode
	set obj.WAItemDesc    = ItemDesc
	set obj.WADataValue   = DataValue
	set obj.WAKeyWord     = WAKeyWord
	set obj.WADataSummary = DataSummary
	set obj.WAActDept     = ActDept
	set obj.WAActWard     = ActWard
	set obj.WAIsActive    = IsActive
	set obj.WAResume      = Resume
	set obj.WAResultID    = ResultID
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  删除爆发预警记录
/// Table：       DHCMed.NINF.BC.Warning
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.BC.Warning).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WASubjectCode</Value>
</Value>
<Value name="3">
<Value>WAEpisodeID</Value>
</Value>
<Value name="4">
<Value>WAActDate</Value>
</Value>
<Value name="5">
<Value>WAActTime</Value>
</Value>
<Value name="6">
<Value>WAItemCode</Value>
</Value>
<Value name="7">
<Value>WAItemDesc</Value>
</Value>
<Value name="8">
<Value>WADataValue</Value>
</Value>
<Value name="9">
<Value>WADataSummary</Value>
</Value>
<Value name="10">
<Value>WAActDept</Value>
</Value>
<Value name="11">
<Value>WAActWard</Value>
</Value>
<Value name="12">
<Value>WAIsActive</Value>
</Value>
<Value name="13">
<Value>WAResume</Value>
</Value>
<Value name="14">
<Value>WAResultID</Value>
</Value>
<Value name="15">
<Value>WAKeyWord</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.BC.WarningD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.BC.WarningD</IdLocation>
<IndexLocation>^DHCMed.NINF.BC.WarningI</IndexLocation>
<StreamLocation>^DHCMed.NINF.BC.WarningS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
