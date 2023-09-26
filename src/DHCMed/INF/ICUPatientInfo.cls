/// 名称: DHCMed.INF.ICUPatientInfo
/// 描述: 医政管理 ICU调查信息
/// 编写者：ChenJB
/// 编写日期: 2010-08-03
Class DHCMed.INF.ICUPatientInfo Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 类型代码 code
Property TypesDr As %String;

/// 调查日期
Property SurveryDate As %Date;

/// 科室
Property CtLoc As %Integer;

/// 数值1
Property Count1 As %Float;

/// 数值2
Property Count2 As %Float;

/// 数值3
Property Count3 As %Float;

/// 数值4
Property Count4 As %Float;

/// 数值5
Property Count5 As %Float;

/// 数值6
Property Count6 As %Float;

/// 数值7
Property Count7 As %Float;

/// 数值8
Property Count8 As %Float;

/// 类型模块索引
Index TypeMainIdx On (TypesDr, SurveryDate);

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.ICUPatientInfo
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: TypesDr 3: SurveryDate 4: CtLoc 5: SurPatiCount   
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..TypesDr_separete
	set return=return_..SurveryDate_separete
	set return=return_..CtLoc_separete
	set return=return_..Count1_separete
	set return=return_..Count2_separete
	set return=return_..Count3_separete
	set return=return_..Count4_separete
	set return=return_..Count5_separete
	set return=return_..Count6_separete
	set return=return_..Count7_separete
	set return=return_..Count8
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 配置信息
/// Table：       DHCMed.INF.ICUPatientInfo
/// Input：       ID:    DHCMed.INF.ICUPatientInfo.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.ICUPatientInfo).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.ICUPatientInfo
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.ICUPatientInfo).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.ICUPatientInfo).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 配置信息
/// Table：       DHCMed.INF.ICUPatientInfo
/// Input：       ID:    DHCMed.INF.ICUPatientInfo.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.ICUPatientInfo).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  更新感染报告 配置信息
/// Table：       DHCMed.INF.ICUPatientInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: TypesDr 3: SurveryDate 4: CtLoc 5: SurPatiCount   
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.ICUPatientInfo).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.ICUPatientInfo).%OpenId(ID)
		}
	set obj.TypesDr=$p(InStr,separete,2)
	set SurDate=$p(InStr,separete,3)
	set:SurDate["-" SurDate=$zdh(SurDate,3)
	set:SurDate["/" SurDate=$zdh(SurDate,4)   //  14/05/2010
	set obj.SurveryDate=SurDate
	set obj.CtLoc=$p(InStr,separete,4)
	set obj.Count1=+$p(InStr,separete,5)
	set obj.Count2=+$p(InStr,separete,6)
	set obj.Count3=+$p(InStr,separete,7)
	set obj.Count4=+$p(InStr,separete,8)
	set obj.Count5=+$p(InStr,separete,9)
	set obj.Count6=+$p(InStr,separete,10)
	set obj.Count7=+$p(InStr,separete,11)
	set obj.Count8=+$p(InStr,separete,12)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  删除感染报告 配置信息
/// Table：       DHCMed.INF.ICUPatientInfo
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.ICUPatientInfo).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Storage Default
{
<Data name="ICUPatientInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Count1</Value>
</Value>
<Value name="3">
<Value>Count2</Value>
</Value>
<Value name="4">
<Value>Count3</Value>
</Value>
<Value name="5">
<Value>Count4</Value>
</Value>
<Value name="6">
<Value>Count5</Value>
</Value>
<Value name="7">
<Value>Count6</Value>
</Value>
<Value name="8">
<Value>Count7</Value>
</Value>
<Value name="9">
<Value>Count8</Value>
</Value>
<Value name="10">
<Value>CtLoc</Value>
</Value>
<Value name="11">
<Value>SurveryDate</Value>
</Value>
<Value name="12">
<Value>TypesDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.ICUPatientInfoD</DataLocation>
<DefaultData>ICUPatientInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.ICUPatientInfoD</IdLocation>
<IndexLocation>^DHCMed.INF.ICUPatientInfoI</IndexLocation>
<StreamLocation>^DHCMed.INF.ICUPatientInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
