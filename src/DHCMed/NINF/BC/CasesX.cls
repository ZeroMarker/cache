/// 名称: DHCMed.NINF.BC.CasesX
/// 描述: 疑似病例筛查日志
/// 编写者：zhufei
/// 编写日期: 2013-12-03
Class DHCMed.NINF.BC.CasesX Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 主题配置代码
Property CXSubjectCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CX_SubjectCode ];

/// 就诊号
Property CXEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CX_EpisodeID ];

/// 触发日期
Property CXActDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CX_ActDate ];

/// 筛查等级
Property CXScreenGrade As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CX_ScreenGrade ];

/// 保存日期
Property CXUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CX_UpdateDate ];

/// 保存时间
Property CXUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = CX_UpdateTime ];

/// 是否有效
Property CXIsActive As %Boolean [ SqlColumnNumber = 8, SqlFieldName = CX_IsActive ];

/// 备注
Property CXResume As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CX_Resume ];

Index IndexSubjectDateAdm On (CXSubjectCode As Exact, CXActDate As Exact, CXEpisodeID As Exact);

Index IndexSubjectPaadm On (CXSubjectCode As Exact, CXEpisodeID As Exact);

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据ID取疑似病例筛查日志
/// Table：       DHCMed.NINF.BC.CasesX
/// Input：       ID:    DHCMed.NINF.BC.CasesX.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.NINF.BC.CasesX).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.BC.CasesX
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.BC.CasesX).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.BC.CasesX).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  更新疑似病例筛查日志
/// Table：       DHCMed.NINF.BC.CasesX
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.NINF.BC.CasesX).Update("","")
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
	set:ActDate["-" ActDate=$zdh(ActDate,3)
	set ScreenGrade = $p(InStr,separete,5)
	set UpdateDate  = $p(InStr,separete,6)
	set:UpdateDate="" UpdateDate=+$h
	set UpdateTime     = $p(InStr,separete,7)
	set:UpdateTime="" UpdateTime=$p($h,",",2)
	set IsActive    = +$p(InStr,separete,8)
	set Resume      = $p(InStr,separete,9)
	quit:(SubjectCode="")||(EpisodeID="")||(ActDate="") return
	
	//每天只有一条筛查记录
	set ID=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectDateAdm",SubjectCode,ActDate,EpisodeID,0))
	
	if ID="" {
		set obj=##class(DHCMed.NINF.BC.CasesX).%New()
	}else{
		set obj=##class(DHCMed.NINF.BC.CasesX).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.CXSubjectCode = SubjectCode
	set obj.CXEpisodeID   = EpisodeID
	set obj.CXActDate     = ActDate
	set obj.CXScreenGrade = ScreenGrade
	set obj.CXUpdateDate  = UpdateDate
	set obj.CXUpdateTime  = UpdateTime
	set obj.CXIsActive    = IsActive
	set obj.CXResume      = Resume
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
/// Description:  删除疑似病例筛查日志
/// Table：       DHCMed.NINF.BC.CasesX
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.BC.CasesX).%DeleteId(+Id)
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
<Value>CXSubjectCode</Value>
</Value>
<Value name="3">
<Value>CXEpisodeID</Value>
</Value>
<Value name="4">
<Value>CXActDate</Value>
</Value>
<Value name="5">
<Value>CXActTime</Value>
</Value>
<Value name="6">
<Value>CXScreenGrade</Value>
</Value>
<Value name="7">
<Value>CXUpdateDate</Value>
</Value>
<Value name="8">
<Value>CXUpdateTime</Value>
</Value>
<Value name="9">
<Value>CXIsActive</Value>
</Value>
<Value name="10">
<Value>CXResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.BC.CasesXD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.BC.CasesXD</IdLocation>
<IndexLocation>^DHCMed.NINF.BC.CasesXI</IndexLocation>
<StreamLocation>^DHCMed.NINF.BC.CasesXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
