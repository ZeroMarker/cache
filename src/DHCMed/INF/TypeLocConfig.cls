/// 名称: DHCMed.INF.TypeLocConfig
/// 描述: 医政管理 感染报告类型 配置信息
/// 编写者：ChenJB
/// 编写日期: 2010-07-17
Class DHCMed.INF.TypeLocConfig Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 报告类型字典 code
Property TypesDr As %String;

/// 调查日期
Property SurveryDate As %Date;

/// 科室
Property CtLoc As %Integer;

/// 人数
Property SurPatiCount As %Integer;

/// 类型模块索引
Index TypeMainIdx On (TypesDr, SurveryDate);

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.TypeLocConfig
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
	set return=return_..SurPatiCount
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 配置信息
/// Table：       DHCMed.INF.TypeLocConfig
/// Input：       ID:    DHCMed.INF.TypeLocConfig.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.TypeLocConfig).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.TypeLocConfig
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.TypeLocConfig).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.TypeLocConfig).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 配置信息
/// Table：       DHCMed.INF.TypeLocConfig
/// Input：       ID:    DHCMed.INF.TypeLocConfig.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.TypeLocConfig).GetStringById(1)
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
/// Table：       DHCMed.INF.TypeLocConfig
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
		set obj=##class(DHCMed.INF.TypeLocConfig).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.TypeLocConfig).%OpenId(ID)
		}
	set obj.TypesDr=$p(InStr,separete,2)
	set SurDate=$p(InStr,separete,3)
	set:SurDate["-" SurDate=$zdh(SurDate,3)
	set:SurDate["/" SurDate=$zdh(SurDate,4)   //  14/05/2010
	set obj.SurveryDate=SurDate
	set obj.CtLoc=$p(InStr,separete,4)
	set obj.SurPatiCount=+$p(InStr,separete,5)
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
/// Table：       DHCMed.INF.TypeLocConfig
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.TypeLocConfig).%DeleteId(+Id)
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
<Data name="TypeLocConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtLoc</Value>
</Value>
<Value name="3">
<Value>SurPatiCount</Value>
</Value>
<Value name="4">
<Value>SurveryDate</Value>
</Value>
<Value name="5">
<Value>TypesDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.TypeLocConfigD</DataLocation>
<DefaultData>TypeLocConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.TypeLocConfigD</IdLocation>
<IndexLocation>^DHCMed.INF.TypeLocConfigI</IndexLocation>
<StreamLocation>^DHCMed.INF.TypeLocConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
