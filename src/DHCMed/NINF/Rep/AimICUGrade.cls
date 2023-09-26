/// 名称: DHCMed.NINF.Rep.AimICUGrade
/// 描述: ICU临床病情等级调查  同一字段不允许定义不同意义
/// 编写者：zhufei
/// 编写日期: 2012-05-16
Class DHCMed.NINF.Rep.AimICUGrade Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 调查科室
Property AIGLocDr As %Integer;

/// 调查年
Property AIGYear As %Integer;

/// 调查月
Property AIGMonth As %Integer;

/// 调查周
Property AIGWeek As %Integer;

/// 调查项目1(A)
Property AIGItem1 As %Float;

/// 调查项目2(B)
Property AIGItem2 As %Float;

/// 调查项目3(C)
Property AIGItem3 As %Float;

/// 调查项目4(D)
Property AIGItem4 As %Float;

/// 调查项目5(E)
Property AIGItem5 As %Float;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 更新用户 指向SS_User.ID
Property UpdateUser As %String(TRUNCATE = 1);

Index IndexLocYYMM On (AIGLocDr, AIGYear, AIGMonth, AIGWeek);

/// Creator：     zhufei
/// CreatDate：   2012-05-16
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Rep.AimICUGrade
/// Input：       argSeparete:指定的分隔符
/// Return：      返回各属性值，按照argSeparete分隔
/// 1: ID 2: AIGLocDr 3: AIGYear 4: AIGMonth 5: AIGWeek 6: AIGItem1 7: AIGItem2 ...
Method ToString(argSeparete As %String = "") As %String
{
	if $g(argSeparete)=""{
		set argSeparete=..#SEPARATE
		} 
	set return=..%Id()_argSeparete
	set return=return_..AIGLocDr_argSeparete
	set return=return_..AIGYear_argSeparete
	set return=return_..AIGMonth_argSeparete
	set return=return_..AIGItem1_argSeparete
	set return=return_..AIGItem2_argSeparete
	set return=return_..AIGItem3_argSeparete
	set return=return_..AIGItem4_argSeparete
	set return=return_..AIGItem5_argSeparete
	set return=return_..UpdateDate_argSeparete
	set return=return_..UpdateTime_argSeparete
	set return=return_..UpdateUser
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-16
/// Description:  根据ID取ICU临床病情等级记录
/// Table：       DHCMed.NINF.Rep.AimICUGrade
/// Input：       ID:    DHCMed.NINF.Rep.AimICUGrade.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimICUGrade).GetObjById(1)
ClassMethod GetObjById(argId As %String) As DHCMed.NINF.Rep.AimICUGrade
{
	new (argId)
	set return=""
	set obj=##Class(DHCMed.NINF.Rep.AimICUGrade).%OpenId(argId)
	if obj'="" do obj.%Close()
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-16
/// Description:  根据ID取ICU临床病情等级记录
/// Table：       DHCMed.NINF.Rep.AimICUGrade
/// Input：       ID:    DHCMed.NINF.Rep.AimICUGrade.ID
///               argSeparete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Rep.AimICUGrade).GetStringById(1)
ClassMethod GetStringById(argId As %String, argSeparete As %String) As %String
{
	new (argId,argSeparete)
	set return=""
	set obj=..GetObjById(argId)
	if $IsObject(obj){
		set return=obj.ToString($g(argSeparete))
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-16
/// Description:  更新ICU临床病情等级记录
/// Table：       DHCMed.NINF.Rep.AimICUGrade
/// Input：       各属性列表 ^ 分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: ID 2: AIGLocDr 3: AIGYear 4: AIGMonth 5: AIGWeek 6: AIGItem1 7: AIGItem2 ...
/// w ##Class(DHCMed.NINF.Rep.AimICUGrade).Update("^1^2012^5^1^12^10^1^1^1^1^","^")
ClassMethod Update(argInput As %String, argSeparete As %String) As %String
{
	new (argInput,argSeparete)
	set return=0
	
	if $g(argSeparete)="" {
		set argSeparete=..#SEPARATE
	}
	set ID=$p(argInput,argSeparete,1)
	if ID="" {
		set obj=##class(DHCMed.NINF.Rep.AimICUGrade).%New()
	} else {
		set obj=##class(DHCMed.NINF.Rep.AimICUGrade).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.AIGLocDr=$p(argInput,argSeparete,2)
	set obj.AIGYear=+$p(argInput,argSeparete,3)
	set obj.AIGMonth=+$p(argInput,argSeparete,4)
	set obj.AIGWeek=+$p(argInput,argSeparete,5)
	set obj.AIGItem1=+$p(argInput,argSeparete,6)
	set obj.AIGItem2=+$p(argInput,argSeparete,7)
	set obj.AIGItem3=+$p(argInput,argSeparete,8)
	set obj.AIGItem4=+$p(argInput,argSeparete,9)
	set obj.AIGItem5=+$p(argInput,argSeparete,10)
	set obj.UpdateDate=+$h
	set obj.UpdateTime=$p($h,",",2)
	set obj.UpdateUser=$p(argInput,argSeparete,11)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else{
		set return=obj.%Id()
	}
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-16
/// Description:  删除ICU临床病情等级记录
/// Table：       DHCMed.NINF.Rep.AimICUGrade
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(argId As %String) As %String
{
	new (argId)
	set sc = ##class(DHCMed.NINF.Rep.AimICUGrade).%DeleteId(+argId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else{
		set return=0
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AIGLocDr</Value>
</Value>
<Value name="3">
<Value>AIGYear</Value>
</Value>
<Value name="4">
<Value>AIGMonth</Value>
</Value>
<Value name="5">
<Value>AIGWeek</Value>
</Value>
<Value name="6">
<Value>AIGItem1</Value>
</Value>
<Value name="7">
<Value>AIGItem2</Value>
</Value>
<Value name="8">
<Value>AIGItem3</Value>
</Value>
<Value name="9">
<Value>AIGItem4</Value>
</Value>
<Value name="10">
<Value>AIGItem5</Value>
</Value>
<Value name="11">
<Value>AIGItem6</Value>
</Value>
<Value name="12">
<Value>AIGItem7</Value>
</Value>
<Value name="13">
<Value>AIGItem8</Value>
</Value>
<Value name="14">
<Value>AIGItem9</Value>
</Value>
<Value name="15">
<Value>AIGItem10</Value>
</Value>
<Value name="16">
<Value>UpdateDate</Value>
</Value>
<Value name="17">
<Value>UpdateTime</Value>
</Value>
<Value name="18">
<Value>UpdateUser</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("Aim","ICUG")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("Aim","ICUG")</IdLocation>
<IndexLocation>^DHCMed.NINFi("Aim","ICUG")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.AimICUGradeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
