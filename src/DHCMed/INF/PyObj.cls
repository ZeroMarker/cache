/// 名称: DHCMed.INF.PyObj
/// 描述: 医政管理 感染报告 辅助检查病原体
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.PyObj Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 辅助检查 指向 DHCMed.INF.Pathogeny
Property InfPathDr As %Integer [ Required ];

/// 病原体 指向病原体字典
Property Object As %Integer;

/// 药敏结果
Property Flag As %String;

/// 辅助检查父子索引
Index InfPathDr On InfPathDr;

/// 病原体索引
Index PathDrObjIdx On (InfPathDr, Object);

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.PyObj
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfPathDr 3: Object 4: Flag 
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfPathDr_separete
	set return=return_..Object_separete
	set return=return_..Flag
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 辅助检查 病原体
/// Table：       DHCMed.INF.PyObj
/// Input：       ID:    DHCMed.INF.PyObj.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.PyObj).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.PyObj
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.PyObj).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.PyObj).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 辅助检查 病原体
/// Table：       DHCMed.INF.PyObj
/// Input：       ID:    DHCMed.INF.PyObj.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.PyObj).GetStringById(1)
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
/// Description:  更新感染报告 辅助检查 病原体
/// Table：       DHCMed.INF.PyObj
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfPathDr 3: Object 4: Flag
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.PyObj).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.PyObj).%OpenId(ID)
		}
	set obj.InfPathDr=$p(InStr,separete,2)
	set obj.Object=$p(InStr,separete,3)
	set obj.Flag=$p(InStr,separete,4)
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
/// Description:  删除感染报告 辅助检查 病原体
/// Table：       DHCMed.INF.PyObj
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.PyObj).%DeleteId(+Id)
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
<Data name="PyObjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Flag</Value>
</Value>
<Value name="3">
<Value>InfPathDr</Value>
</Value>
<Value name="4">
<Value>Object</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.PyObjD</DataLocation>
<DefaultData>PyObjDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.PyObjD</IdLocation>
<IndexLocation>^DHCMed.INF.PyObjI</IndexLocation>
<StreamLocation>^DHCMed.INF.PyObjS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
