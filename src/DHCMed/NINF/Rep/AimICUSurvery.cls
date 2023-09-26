/// 名称: DHCMed.NINF.Rep.AimICUSurvery
/// 描述: ICU调查日志  同一字段不允许定义不同意义
/// 编写者：zhufei
/// 编写日期: 2012-05-10
Class DHCMed.NINF.Rep.AimICUSurvery Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 调查科室
Property AISLocDr As %Integer;

/// 调查日期
Property AISDate As %Date;

/// 调查项目1(新入院人数)
Property AISItem1 As %Float;

/// 调查项目2(住院病人总数)
Property AISItem2 As %Float;

/// 调查项目3(带尿管病人数)
Property AISItem3 As %Float;

/// 调查项目4(带中心静脉导管病人数)
Property AISItem4 As %Float;

/// 调查项目5(带呼吸机病人数)
Property AISItem5 As %Float;

/// 调查项目6(手术台数)
Property AISItem6 As %Float;

/// 调查项目7(气管切开人数)
Property AISItem7 As %Float;

/// 调查项目8(气管插管人数)
Property AISItem8 As %Float;

/// 调查项目9
Property AISItem9 As %Float;

/// 调查项目10
Property AISItem10 As %Float;

/// 调查项目11
Property AISItem11 As %Float;

/// 调查项目12(感染人数)
Property AISItem12 As %Float;

/// 调查项目13(尿管病感染人数)
Property AISItem13 As %Float;

/// 调查项目14(中心静脉导管病感染人数)
Property AISItem14 As %Float;

/// 调查项目15(呼吸机病感染人数)
Property AISItem15 As %Float;

/// 调查项目16(手术切口感染人数)
Property AISItem16 As %Float;

/// 调查项目17(气管切开感染人数)
Property AISItem17 As %Float;

/// 调查项目18(气管插管感染人数)
Property AISItem18 As %Float;

/// 调查项目19
Property AISItem19 As %Float;

/// 调查项目20
Property AISItem20 As %Float;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 更新用户 指向SS_User.ID
Property UpdateUser As %String(TRUNCATE = 1);

Index IndexLocDate On (AISLocDr, AISDate);

/// Creator：     zhufei
/// CreatDate：   2012-05-10
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Rep.AimICUSurvery
/// Input：       argSeparete:指定的分隔符
/// Return：      返回各属性值，按照argSeparete分隔
/// 1: ID 2: AISLocDr 3: AISDate 4: AISItem1 5: AISItem2 ...
Method ToString(argSeparete As %String = "") As %String
{
	if $g(argSeparete)=""{
		set argSeparete=..#SEPARATE
		} 
	set return=..%Id()_argSeparete
	set return=return_..AISLocDr_argSeparete
	set return=return_..AISDate_argSeparete
	set return=return_..AISItem1_argSeparete
	set return=return_..AISItem2_argSeparete
	set return=return_..AISItem3_argSeparete
	set return=return_..AISItem4_argSeparete
	set return=return_..AISItem5_argSeparete
	set return=return_..AISItem6_argSeparete
	set return=return_..AISItem7_argSeparete
	set return=return_..AISItem8_argSeparete
	set return=return_..AISItem9_argSeparete
	set return=return_..AISItem10_argSeparete
	set return=return_..UpdateDate_argSeparete
	set return=return_..UpdateTime_argSeparete
	set return=return_..UpdateUser_argSeparete
	set return=return_..AISItem11_argSeparete
	set return=return_..AISItem12_argSeparete
	set return=return_..AISItem13_argSeparete
	set return=return_..AISItem14_argSeparete
	set return=return_..AISItem15_argSeparete
	set return=return_..AISItem16_argSeparete
	set return=return_..AISItem17_argSeparete
	set return=return_..AISItem18_argSeparete
	set return=return_..AISItem19_argSeparete
	set return=return_..AISItem20
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-10
/// Description:  根据ID取ICU调查日志记录
/// Table：       DHCMed.NINF.Rep.AimICUSurvery
/// Input：       ID:    DHCMed.NINF.Rep.AimICUSurvery.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimICUSurvery).GetObjById(1)
ClassMethod GetObjById(argId As %String) As DHCMed.NINF.Rep.AimICUSurvery
{
	new (argId)
	set return=""
	set obj=##Class(DHCMed.NINF.Rep.AimICUSurvery).%OpenId(argId)
	if obj'="" do obj.%Close()
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-10
/// Description:  根据ID取ICU调查日志记录
/// Table：       DHCMed.NINF.Rep.AimICUSurvery
/// Input：       ID:    DHCMed.NINF.Rep.AimICUSurvery.ID
///               argSeparete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Rep.AimICUSurvery).GetStringById(1)
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
/// CreatDate：   2012-05-10
/// Description:  更新ICU调查日志记录
/// Table：       DHCMed.NINF.Rep.AimICUSurvery
/// Input：       各属性列表 ^ 分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: ID 2: AISLocDr 3: AISDate 4: AISItem1 5: AISItem2 ...
/// w ##Class(DHCMed.NINF.Rep.AimICUSurvery).Update("^1^2012-05-10^12^10^1^1^1^1^","^")
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
		set obj=##class(DHCMed.NINF.Rep.AimICUSurvery).%New()
	} else {
		set obj=##class(DHCMed.NINF.Rep.AimICUSurvery).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.AISLocDr=$p(argInput,argSeparete,2)
	set obj.AISDate=SurveryDate
	set obj.AISItem1=+$p(argInput,argSeparete,4)
	set obj.AISItem2=+$p(argInput,argSeparete,5)
	set obj.AISItem3=+$p(argInput,argSeparete,6)
	set obj.AISItem4=+$p(argInput,argSeparete,7)
	set obj.AISItem5=+$p(argInput,argSeparete,8)
	set obj.AISItem6=+$p(argInput,argSeparete,9)
	set obj.AISItem7=+$p(argInput,argSeparete,10)
	set obj.AISItem8=+$p(argInput,argSeparete,11)
	set obj.AISItem9=+$p(argInput,argSeparete,12)
	set obj.AISItem10=+$p(argInput,argSeparete,13)
	set obj.UpdateDate=+$h
	set obj.UpdateTime=$p($h,",",2)
	set obj.UpdateUser=$p(argInput,argSeparete,14)
	set obj.AISItem11=+$p(argInput,argSeparete,15)
	set obj.AISItem12=+$p(argInput,argSeparete,16)
	set obj.AISItem13=+$p(argInput,argSeparete,17)
	set obj.AISItem14=+$p(argInput,argSeparete,18)
	set obj.AISItem15=+$p(argInput,argSeparete,19)
	set obj.AISItem16=+$p(argInput,argSeparete,20)
	set obj.AISItem17=+$p(argInput,argSeparete,21)
	set obj.AISItem18=+$p(argInput,argSeparete,22)
	set obj.AISItem19=+$p(argInput,argSeparete,23)
	set obj.AISItem20=+$p(argInput,argSeparete,24)
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
/// CreatDate：   2012-05-10
/// Description:  删除ICU调查日志记录
/// Table：       DHCMed.NINF.Rep.AimICUSurvery
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(argId As %String) As %String
{
	new (argId)
	set sc = ##class(DHCMed.NINF.Rep.AimICUSurvery).%DeleteId(+argId)
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
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AISLocDr</Value>
</Value>
<Value name="3">
<Value>AISDate</Value>
</Value>
<Value name="4">
<Value>AISItem1</Value>
</Value>
<Value name="5">
<Value>AISItem2</Value>
</Value>
<Value name="6">
<Value>AISItem3</Value>
</Value>
<Value name="7">
<Value>AISItem4</Value>
</Value>
<Value name="8">
<Value>AISItem5</Value>
</Value>
<Value name="9">
<Value>AISItem6</Value>
</Value>
<Value name="10">
<Value>AISItem7</Value>
</Value>
<Value name="11">
<Value>AISItem8</Value>
</Value>
<Value name="12">
<Value>AISItem9</Value>
</Value>
<Value name="13">
<Value>AISItem10</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>UpdateTime</Value>
</Value>
<Value name="16">
<Value>UpdateUser</Value>
</Value>
<Value name="17">
<Value>AISItem11</Value>
</Value>
<Value name="18">
<Value>AISItem12</Value>
</Value>
<Value name="19">
<Value>AISItem13</Value>
</Value>
<Value name="20">
<Value>AISItem14</Value>
</Value>
<Value name="21">
<Value>AISItem15</Value>
</Value>
<Value name="22">
<Value>AISItem16</Value>
</Value>
<Value name="23">
<Value>AISItem17</Value>
</Value>
<Value name="24">
<Value>AISItem18</Value>
</Value>
<Value name="25">
<Value>AISItem19</Value>
</Value>
<Value name="26">
<Value>AISItem20</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("Aim","ICUS")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("Aim","ICUS")</IdLocation>
<IndexLocation>^DHCMed.NINFi("Aim","ICUS")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.AimICUSurveryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
