/// 名称: DHCMed.INF.RepConfig
/// 描述: 医政管理 感染报告 配置信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.RepConfig Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 报告类型字典 code
Property TypesDr As %String;

/// 包含项目code
Property TypesObjCode As %String;

/// 包含项目描述
Property TypesObjDesc As %String;

/// 报告类型索引
Index TypesDrIdx On TypesDr;

/// 类型模块索引
Index TypeCode On (TypesDr, TypesObjCode);

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepConfig
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: TypesDr 3: TypesObjCode 4: TypesObjDesc  
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..TypesDr_separete
	set return=return_..TypesObjCode_separete
	set return=return_..TypesObjDesc
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 配置信息
/// Table：       DHCMed.INF.RepConfig
/// Input：       ID:    DHCMed.INF.RepConfig.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepConfig).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepConfig
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepConfig).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepConfig).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 配置信息
/// Table：       DHCMed.INF.RepConfig
/// Input：       ID:    DHCMed.INF.RepConfig.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepConfig).GetStringById(1)
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
/// Table：       DHCMed.INF.RepConfig
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: TypesDr 3: TypesObjCode 4: TypesObjDesc  
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepConfig).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepConfig).%OpenId(ID)
		}
	set obj.TypesDr=$p(InStr,separete,2)
	set obj.TypesObjCode=$p(InStr,separete,3)
	set obj.TypesObjDesc=$p(InStr,separete,4)
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
/// Table：       DHCMed.INF.RepConfig
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepConfig).%DeleteId(+Id)
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
<Data name="RepConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypesDr</Value>
</Value>
<Value name="3">
<Value>TypesObjCode</Value>
</Value>
<Value name="4">
<Value>TypesObjDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepConfigD</DataLocation>
<DefaultData>RepConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepConfigD</IdLocation>
<IndexLocation>^DHCMed.INF.RepConfigI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
