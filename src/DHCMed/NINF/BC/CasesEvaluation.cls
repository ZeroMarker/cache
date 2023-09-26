/// 名称: DHCMed.NINF.BC.CasesEvaluation
/// 描述: 疑似病例评价记录
/// 编写者：zhufei
/// 编写日期: 2013-12-03
Class DHCMed.NINF.BC.CasesEvaluation Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.BC.Cases [ Cardinality = parent, Inverse = ChildEval ];

/// 操作
Property CEOperation As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CE_Operation ];

/// 评价日期
Property CEEvalDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CE_EvalDate ];

/// 评价时间
Property CEEvalTime As %Time [ SqlColumnNumber = 5, SqlFieldName = CE_EvalTime ];

/// 评价科室
Property CEEvalDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CE_EvalDept ];

/// 评价人员
Property CEEvalUser As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CE_EvalUser ];

/// 处置意见
Property CEOpinion As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CE_Opinion ];

/// 是否有效
Property CEIsActive As %Boolean [ SqlColumnNumber = 9, SqlFieldName = CE_IsActive ];

/// 备注
Property CEResume As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CE_Resume ];

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据ID取疑似病例评价记录
/// Table：       DHCMed.NINF.BC.CasesEvaluation
/// Input：       ID:    DHCMed.NINF.BC.CasesEvaluation.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.NINF.BC.CasesEvaluation).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.BC.CasesEvaluation
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.BC.CasesEvaluation).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.BC.CasesEvaluation).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  更新疑似病例评价记录
/// Table：       DHCMed.NINF.BC.CasesEvaluation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.NINF.BC.CasesEvaluation).Update("","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set:$g(separete)="" separete=..#SEPARATE
	set ParRef    = $p(InStr,separete,1)
	set Childsub  = $p(InStr,separete,2)
	set Operation = $p(InStr,separete,3)
	set EvalDate   = $p(InStr,separete,4)
	set:EvalDate="" EvalDate=+$h
	set EvalTime   = $p(InStr,separete,5)
	set:EvalTime="" EvalTime=$p($h,",",2)
	set EvalDept   = $p(InStr,separete,6)
	set EvalUser   = $p(InStr,separete,7)
	set Opinion   = $p(InStr,separete,8)
	set IsActive  = +$p(InStr,separete,9)
	set Resume    = $p(InStr,separete,10)
	quit:(ParRef="")||(Operation="") return
	
	if Childsub="" {
		set obj=##class(DHCMed.NINF.BC.CasesEvaluation).%New()
	}else{
		set ID=ParRef_"||"_Childsub
		set obj=##class(DHCMed.NINF.BC.CasesEvaluation).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.ParRef=##class(DHCMed.NINF.BC.Cases).%OpenId(ParRef)
	set obj.CEOperation = Operation
	set obj.CEEvalDate   = EvalDate
	set obj.CEEvalTime   = EvalTime
	set obj.CEEvalDept   = EvalDept
	set obj.CEEvalUser   = EvalUser
	set obj.CEOpinion   = Opinion
	set obj.CEIsActive  = IsActive
	set obj.CEResume    = Resume
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
/// Description:  删除疑似病例评价记录
/// Table：       DHCMed.NINF.BC.CasesEvaluation
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.BC.CasesEvaluation).%DeleteId(Id)
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
<Value>CEOperation</Value>
</Value>
<Value name="3">
<Value>CEEvalDate</Value>
</Value>
<Value name="4">
<Value>CEEvalTime</Value>
</Value>
<Value name="5">
<Value>CEEvalDept</Value>
</Value>
<Value name="6">
<Value>CEEvalUser</Value>
</Value>
<Value name="7">
<Value>CEOpinion</Value>
</Value>
<Value name="8">
<Value>CEIsActive</Value>
</Value>
<Value name="9">
<Value>CEResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EVA")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("EVA")</IdLocation>
<IndexLocation>^DHCMed.NINF.BC.CasesI("EVA")</IndexLocation>
<StreamLocation>^DHCMed.NINF.BC.CasesEvaluationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
