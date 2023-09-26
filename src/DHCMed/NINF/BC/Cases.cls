/// 名称: DHCMed.NINF.BC.Cases
/// 描述: 疑似病例记录
/// 编写者：zhufei
/// 编写日期: 2013-12-03
Class DHCMed.NINF.BC.Cases Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildHandleA As DHCMed.NINF.BC.CasesHandleA [ Cardinality = children, Inverse = ParRef ];

Relationship ChildHandleB As DHCMed.NINF.BC.CasesHandleB [ Cardinality = children, Inverse = ParRef ];

Relationship ChildEval As DHCMed.NINF.BC.CasesEvaluation [ Cardinality = children, Inverse = ParRef ];

/// 就诊号
Property CSEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CS_EpisodeID ];

/// 主题配置代码
Property CSSubjectCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CS_SubjectCode ];

/// 监控处置（1:排除、2:疑似、3:确诊、4:消息、5:感染结束）
Property CSHandleAOper As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CS_HandleAOper ];

/// 处置日期
Property CSHandleADate As %Date [ SqlColumnNumber = 5, SqlFieldName = CS_HandleADate ];

/// 处置时间
Property CSHandleATime As %Time [ SqlColumnNumber = 6, SqlFieldName = CS_HandleATime ];

/// 临床处置
Property CSHandleBOper As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CS_HandleBOper ];

/// 处置日期
Property CSHandleBDate As %Date [ SqlColumnNumber = 8, SqlFieldName = CS_HandleBDate ];

/// 处置时间
Property CSHandleBTime As %Time [ SqlColumnNumber = 9, SqlFieldName = CS_HandleBTime ];

/// 确诊日期/感染日期
Property CSSttDate As %Date [ SqlColumnNumber = 10, SqlFieldName = CS_SttDate ];

/// 感染结束日期
Property CSEndDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CS_EndDate ];

/// 评价
Property CSEvalOper As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CS_EvalOper ];

/// 评价日期
Property CSEvalDate As %Date [ SqlColumnNumber = 13, SqlFieldName = CS_EvalDate ];

/// 评价时间
Property CSEvalTime As %Time [ SqlColumnNumber = 14, SqlFieldName = CS_EvalTime ];

/// 是否有效
Property CSIsActive As %Boolean [ SqlColumnNumber = 15, SqlFieldName = CS_IsActive ];

/// 备注
Property CSResume As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CS_Resume ];

/// 主题配置代码+就诊号 索引
Index IndexSubjectEpisodeID On (CSSubjectCode As Exact, CSEpisodeID As Exact);

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据ID取疑似病例记录
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       ID:    DHCMed.NINF.BC.Cases.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.NINF.BC.Cases).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.BC.Cases
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.BC.Cases).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.BC.Cases).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  更新疑似病例记录
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.NINF.BC.Cases).Update("","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	Set:$g(separete)="" separete=..#SEPARATE
	set ID          = $p(InStr,separete,1)
	set EpisodeID   = $p(InStr,separete,2)
	set SubjectCode = $p(InStr,separete,3)
	set HandleAOper = $p(InStr,separete,4)
	set HandleADate = $p(InStr,separete,5)
	set HandleATime = $p(InStr,separete,6)
	set HandleBOper = $p(InStr,separete,7)
	set HandleBDate = $p(InStr,separete,8)
	set HandleBTime = $p(InStr,separete,9)
	set SttDate     = $p(InStr,separete,10)
	set EndDate     = $p(InStr,separete,11)
	set EvalOper    = $p(InStr,separete,12)
	set EvalDate    = $p(InStr,separete,13)
	set EvalTime    = $p(InStr,separete,14)
	set IsActive    = $p(InStr,separete,15)
	set Resume      = $p(InStr,separete,16)
	quit:(EpisodeID="")||(SubjectCode="") return
	
	if ID="" {
		set obj=##class(DHCMed.NINF.BC.Cases).%New()
	}else{
		set obj=##class(DHCMed.NINF.BC.Cases).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.CSEpisodeID   = EpisodeID
	set obj.CSSubjectCode = SubjectCode
	set obj.CSHandleAOper = HandleAOper
	set obj.CSHandleADate = HandleADate
	set obj.CSHandleATime = HandleATime
	set obj.CSHandleBOper = HandleBOper
	set obj.CSHandleBDate = HandleBDate
	set obj.CSHandleBTime = HandleBTime
	set obj.CSSttDate     = SttDate
	set obj.CSEndDate     = EndDate
	set obj.CSEvalOper    = EvalOper
	set obj.CSEvalDate    = EvalDate
	set obj.CSEvalTime    = EvalTime
	set obj.CSIsActive    = IsActive
	set obj.CSResume      = Resume
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
/// Description:  删除疑似病例记录
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.BC.Cases).%DeleteId(+Id)
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
<Value>CSEpisodeID</Value>
</Value>
<Value name="3">
<Value>CSSubjectCode</Value>
</Value>
<Value name="4">
<Value>CSHandleAOper</Value>
</Value>
<Value name="5">
<Value>CSHandleADate</Value>
</Value>
<Value name="6">
<Value>CSHandleATime</Value>
</Value>
<Value name="7">
<Value>CSHandleBOper</Value>
</Value>
<Value name="8">
<Value>CSHandleBDate</Value>
</Value>
<Value name="9">
<Value>CSHandleBTime</Value>
</Value>
<Value name="10">
<Value>CSSttDate</Value>
</Value>
<Value name="11">
<Value>CSEndDate</Value>
</Value>
<Value name="12">
<Value>CSEvalOper</Value>
</Value>
<Value name="13">
<Value>CSEvalDate</Value>
</Value>
<Value name="14">
<Value>CSEvalTime</Value>
</Value>
<Value name="15">
<Value>CSIsActive</Value>
</Value>
<Value name="16">
<Value>CSResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.BC.CasesD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.BC.CasesD</IdLocation>
<IndexLocation>^DHCMed.NINF.BC.CasesI</IndexLocation>
<StreamLocation>^DHCMed.NINF.BC.CasesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
