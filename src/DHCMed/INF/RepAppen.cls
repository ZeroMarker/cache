/// 名称: DHCMed.INF.RepAppen
/// 描述: 医政管理 感染报告 附加项目关联信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.RepAppen Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 报告的id DHC_Med.INF.Report
Property InfRepDr As %Integer [ Required ];

/// 指向 DHCMed.INF.RepItem的ID
Property ItemsDr As %Integer [ Required ];

/// 项目值
Property ItemsValue As %String;

/// 报告类型 父子索引
Index InfRepDr On InfRepDr;

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepAppen
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: ItemsDr 4: ItemsValue 
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepDr_separete
	set return=return_..ItemsDr_separete
	set return=return_..ItemsValue
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepAppen
/// Input：       ID:    DHCMed.INF.RepAppen.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepAppen).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepAppen
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepAppen).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepAppen).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepAppen
/// Input：       ID:    DHCMed.INF.RepAppen.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepAppen).GetStringById(1)
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
/// Description:  更新感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepAppen
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: ItemsDr 4: ItemsValue 
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepAppen).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepAppen).%OpenId(ID)
		}
	set obj.InfRepDr=$p(InStr,separete,2)
	set obj.ItemsDr=$p(InStr,separete,3)
	set obj.ItemsValue=$p(InStr,separete,4)
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
/// Description:  删除感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepAppen
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepAppen).%DeleteId(+Id)
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
<Data name="RepAppenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfRepDr</Value>
</Value>
<Value name="3">
<Value>ItemsDr</Value>
</Value>
<Value name="4">
<Value>ItemsValue</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepAppenD</DataLocation>
<DefaultData>RepAppenDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepAppenD</IdLocation>
<IndexLocation>^DHCMed.INF.RepAppenI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepAppenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
