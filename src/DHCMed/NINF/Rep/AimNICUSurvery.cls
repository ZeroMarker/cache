/// 名称: DHCMed.NINF.Rep.AimNICUSurvery
/// 描述: NICU调查日志  同一字段不允许定义不同意义
/// 编写者：zhufei
/// 编写日期: 2012-05-16
Class DHCMed.NINF.Rep.AimNICUSurvery Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 调查科室
Property ANISLocDr As %Integer;

/// 调查日期
Property ANISDate As %Date;

/// 调查项目1(BW<=1000g 新住院新生儿数)
Property ANISItem1 As %Float;

/// 调查项目2(BW<=1000g 已住新生儿数)
Property ANISItem2 As %Float;

/// 调查项目3(BW<=1000g 脐\中心静脉插管数)
Property ANISItem3 As %Float;

/// 调查项目4(BW<=1000g 使用呼吸机数)
Property ANISItem4 As %Float;

/// 调查项目5(BW 1001g~1500g 新住院新生儿数)
Property ANISItem5 As %Float;

/// 调查项目6(BW 1001g~1500g 已住新生儿数)
Property ANISItem6 As %Float;

/// 调查项目7(BW 1001g~1500g 脐\中心静脉插管数)
Property ANISItem7 As %Float;

/// 调查项目8(BW 1001g~1500g 使用呼吸机数)
Property ANISItem8 As %Float;

/// 调查项目9(BW 1501g~2500g 新住院新生儿数)
Property ANISItem9 As %Float;

/// 调查项目10(BW 1501g~2500g 已住新生儿数)
Property ANISItem10 As %Float;

/// 调查项目11(BW 1501g~2500g 脐\中心静脉插管数)
Property ANISItem11 As %Float;

/// 调查项目12(BW 1501g~2500g 使用呼吸机数)
Property ANISItem12 As %Float;

/// 调查项目13(BW>2500g 新住院新生儿数)
Property ANISItem13 As %Float;

/// 调查项目14(BW>2500g 已住新生儿数)
Property ANISItem14 As %Float;

/// 调查项目15(BW>2500g 脐\中心静脉插管数)
Property ANISItem15 As %Float;

/// 调查项目16(BW>2500g 使用呼吸机数)
Property ANISItem16 As %Float;

/// 调查项目1A
Property ANISItem1A As %Float;

/// 调查项目2A
Property ANISItem2A As %Float;

/// 调查项目3A(BW<=1000g 脐\中心静脉插管感染人数)
Property ANISItem3A As %Float;

/// 调查项目4A(BW<=1000g 使用呼吸机感染人数)
Property ANISItem4A As %Float;

/// 调查项目5A
Property ANISItem5A As %Float;

/// 调查项目6A
Property ANISItem6A As %Float;

/// 调查项目7A(BW 1001g~1500g 脐\中心静脉插管感染人数)
Property ANISItem7A As %Float;

/// 调查项目8A(BW 1001g~1500g 使用呼吸机感染人数)
Property ANISItem8A As %Float;

/// 调查项目9A
Property ANISItem9A As %Float;

/// 调查项目10A
Property ANISItem10A As %Float;

/// 调查项目11A(BW 1501g~2500g 脐\中心静脉插管感染人数)
Property ANISItem11A As %Float;

/// 调查项目12A(BW 1501g~2500g 使用呼吸机感染人数)
Property ANISItem12A As %Float;

/// 调查项目13A
Property ANISItem13A As %Float;

/// 调查项目14A
Property ANISItem14A As %Float;

/// 调查项目15A(BW>2500g 脐\中心静脉插管感染人数)
Property ANISItem15A As %Float;

/// 调查项目16A(BW>2500g 使用呼吸机感染人数)
Property ANISItem16A As %Float;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 更新用户 指向SS_User.ID
Property UpdateUser As %String(TRUNCATE = 1);

Index IndexLocDate On (ANISLocDr, ANISDate);

/// Creator：     zhufei
/// CreatDate：   2012-05-16
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Rep.AimNICUSurvery
/// Input：       argSeparete:指定的分隔符
/// Return：      返回各属性值，按照argSeparete分隔
/// 1: ID 2: ANISLocDr 3: ANISDate 4: ANISItem1 5: ANISItem2 ...
Method ToString(argSeparete As %String = "") As %String
{
	if $g(argSeparete)=""{
		set argSeparete=..#SEPARATE
		} 
	set return=..%Id()_argSeparete
	set return=return_..ANISLocDr_argSeparete
	set return=return_..ANISDate_argSeparete
	set return=return_..ANISItem1_argSeparete
	set return=return_..ANISItem2_argSeparete
	set return=return_..ANISItem3_argSeparete
	set return=return_..ANISItem4_argSeparete
	set return=return_..ANISItem5_argSeparete
	set return=return_..ANISItem6_argSeparete
	set return=return_..ANISItem7_argSeparete
	set return=return_..ANISItem8_argSeparete
	set return=return_..ANISItem9_argSeparete
	set return=return_..ANISItem10_argSeparete
	set return=return_..ANISItem11_argSeparete
	set return=return_..ANISItem12_argSeparete
	set return=return_..ANISItem13_argSeparete
	set return=return_..ANISItem14_argSeparete
	set return=return_..ANISItem15_argSeparete
	set return=return_..ANISItem16_argSeparete
	set return=return_..UpdateDate_argSeparete
	set return=return_..UpdateTime_argSeparete
	set return=return_..UpdateUser
	set return=return_..ANISItem1A_argSeparete
	set return=return_..ANISItem2A_argSeparete
	set return=return_..ANISItem3A_argSeparete
	set return=return_..ANISItem4A_argSeparete
	set return=return_..ANISItem5A_argSeparete
	set return=return_..ANISItem6A_argSeparete
	set return=return_..ANISItem7A_argSeparete
	set return=return_..ANISItem8A_argSeparete
	set return=return_..ANISItem9A_argSeparete
	set return=return_..ANISItem10A_argSeparete
	set return=return_..ANISItem11A_argSeparete
	set return=return_..ANISItem12A_argSeparete
	set return=return_..ANISItem13A_argSeparete
	set return=return_..ANISItem14A_argSeparete
	set return=return_..ANISItem15A_argSeparete
	set return=return_..ANISItem16A_argSeparete
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-16
/// Description:  根据ID取NICU调查日志记录
/// Table：       DHCMed.NINF.Rep.AimNICUSurvery
/// Input：       ID:    DHCMed.NINF.Rep.AimNICUSurvery.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimNICUSurvery).GetObjById(1)
ClassMethod GetObjById(argId As %String) As DHCMed.NINF.Rep.AimNICUSurvery
{
	new (argId)
	set return=""
	set obj=##Class(DHCMed.NINF.Rep.AimNICUSurvery).%OpenId(argId)
	if obj'="" do obj.%Close()
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-16
/// Description:  根据ID取NICU调查日志记录
/// Table：       DHCMed.NINF.Rep.AimNICUSurvery
/// Input：       ID:    DHCMed.NINF.Rep.AimNICUSurvery.ID
///               argSeparete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Rep.AimNICUSurvery).GetStringById(1)
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
/// Description:  更新NICU调查日志记录
/// Table：       DHCMed.NINF.Rep.AimNICUSurvery
/// Input：       各属性列表 ^ 分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: ID 2: ANISLocDr 3: ANISDate 4: ANISItem1 5: ANISItem2 ...
/// w ##Class(DHCMed.NINF.Rep.AimNICUSurvery).Update("^1^2012-05-16^12^10^1^1^1^1^","^")
ClassMethod Update(argInput As %String, argSeparete As %String) As %String
{
	new (argInput,argSeparete)
	set return=0
	
	set SurveryDate=$p(argInput,argSeparete,3)
	set:SurveryDate["-" SurveryDate=$zdh(SurveryDate,3)
	set:SurveryDate["/" SurveryDate=$zdh(SurveryDate,4)
	set:SurveryDate'="" SurveryDate=+SurveryDate
	quit:SurveryDate="" return
	
	if $g(argSeparete)="" {
		set argSeparete=..#SEPARATE
	}
	set ID=$p(argInput,argSeparete,1)
	if ID="" {
		set obj=##class(DHCMed.NINF.Rep.AimNICUSurvery).%New()
	} else {
		set obj=##class(DHCMed.NINF.Rep.AimNICUSurvery).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.ANISLocDr=$p(argInput,argSeparete,2)
	set obj.ANISDate=SurveryDate
	set obj.ANISItem1=+$p(argInput,argSeparete,4)
	set obj.ANISItem2=+$p(argInput,argSeparete,5)
	set obj.ANISItem3=+$p(argInput,argSeparete,6)
	set obj.ANISItem4=+$p(argInput,argSeparete,7)
	set obj.ANISItem5=+$p(argInput,argSeparete,8)
	set obj.ANISItem6=+$p(argInput,argSeparete,9)
	set obj.ANISItem7=+$p(argInput,argSeparete,10)
	set obj.ANISItem8=+$p(argInput,argSeparete,11)
	set obj.ANISItem9=+$p(argInput,argSeparete,12)
	set obj.ANISItem10=+$p(argInput,argSeparete,13)
	set obj.ANISItem11=+$p(argInput,argSeparete,14)
	set obj.ANISItem12=+$p(argInput,argSeparete,15)
	set obj.ANISItem13=+$p(argInput,argSeparete,16)
	set obj.ANISItem14=+$p(argInput,argSeparete,17)
	set obj.ANISItem15=+$p(argInput,argSeparete,18)
	set obj.ANISItem16=+$p(argInput,argSeparete,19)
	set obj.UpdateDate=+$h
	set obj.UpdateTime=$p($h,",",2)
	set obj.UpdateUser=$p(argInput,argSeparete,20)
	
	set obj.ANISItem1A=+$p(argInput,argSeparete,21)
	set obj.ANISItem2A=+$p(argInput,argSeparete,22)
	set obj.ANISItem3A=+$p(argInput,argSeparete,23)
	set obj.ANISItem4A=+$p(argInput,argSeparete,24)
	set obj.ANISItem5A=+$p(argInput,argSeparete,25)
	set obj.ANISItem6A=+$p(argInput,argSeparete,26)
	set obj.ANISItem7A=+$p(argInput,argSeparete,27)
	set obj.ANISItem8A=+$p(argInput,argSeparete,28)
	set obj.ANISItem9A=+$p(argInput,argSeparete,29)
	set obj.ANISItem10A=+$p(argInput,argSeparete,30)
	set obj.ANISItem11A=+$p(argInput,argSeparete,31)
	set obj.ANISItem12A=+$p(argInput,argSeparete,32)
	set obj.ANISItem13A=+$p(argInput,argSeparete,33)
	set obj.ANISItem14A=+$p(argInput,argSeparete,34)
	set obj.ANISItem15A=+$p(argInput,argSeparete,35)
	set obj.ANISItem16A=+$p(argInput,argSeparete,36)
	
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
/// Description:  删除NICU调查日志记录
/// Table：       DHCMed.NINF.Rep.AimNICUSurvery
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(argId As %String) As %String
{
	new (argId)
	set sc = ##class(DHCMed.NINF.Rep.AimNICUSurvery).%DeleteId(+argId)
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
<Value>ANISLocDr</Value>
</Value>
<Value name="3">
<Value>ANISDate</Value>
</Value>
<Value name="4">
<Value>ANISItem1</Value>
</Value>
<Value name="5">
<Value>ANISItem2</Value>
</Value>
<Value name="6">
<Value>ANISItem3</Value>
</Value>
<Value name="7">
<Value>ANISItem4</Value>
</Value>
<Value name="8">
<Value>ANISItem5</Value>
</Value>
<Value name="9">
<Value>ANISItem6</Value>
</Value>
<Value name="10">
<Value>ANISItem7</Value>
</Value>
<Value name="11">
<Value>ANISItem8</Value>
</Value>
<Value name="12">
<Value>ANISItem9</Value>
</Value>
<Value name="13">
<Value>ANISItem10</Value>
</Value>
<Value name="14">
<Value>ANISItem11</Value>
</Value>
<Value name="15">
<Value>ANISItem12</Value>
</Value>
<Value name="16">
<Value>ANISItem13</Value>
</Value>
<Value name="17">
<Value>ANISItem14</Value>
</Value>
<Value name="18">
<Value>ANISItem15</Value>
</Value>
<Value name="19">
<Value>ANISItem16</Value>
</Value>
<Value name="20">
<Value>UpdateDate</Value>
</Value>
<Value name="21">
<Value>UpdateTime</Value>
</Value>
<Value name="22">
<Value>UpdateUser</Value>
</Value>
<Value name="23">
<Value>ANISItem1A</Value>
</Value>
<Value name="24">
<Value>ANISItem2A</Value>
</Value>
<Value name="25">
<Value>ANISItem3A</Value>
</Value>
<Value name="26">
<Value>ANISItem4A</Value>
</Value>
<Value name="27">
<Value>ANISItem5A</Value>
</Value>
<Value name="28">
<Value>ANISItem6A</Value>
</Value>
<Value name="29">
<Value>ANISItem7A</Value>
</Value>
<Value name="30">
<Value>ANISItem8A</Value>
</Value>
<Value name="31">
<Value>ANISItem9A</Value>
</Value>
<Value name="32">
<Value>ANISItem10A</Value>
</Value>
<Value name="33">
<Value>ANISItem11A</Value>
</Value>
<Value name="34">
<Value>ANISItem12A</Value>
</Value>
<Value name="35">
<Value>ANISItem13A</Value>
</Value>
<Value name="36">
<Value>ANISItem14A</Value>
</Value>
<Value name="37">
<Value>ANISItem15A</Value>
</Value>
<Value name="38">
<Value>ANISItem16A</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("Aim","NICUS")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("Aim","NICUS")</IdLocation>
<IndexLocation>^DHCMed.NINFi("Aim","NICUS")</IndexLocation>
<StreamLocation>^DHCMed.NINF493.AimNICUSurveryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
