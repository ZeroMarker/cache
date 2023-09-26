/// 名称: DHCMed.SS.MenuOperation
/// 描述: 医政管理菜单操作表
/// 编写者：wuqk
/// 编写日期: 2010-03-24
Class DHCMed.SS.MenuOperation Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 菜单指针
Property MenuDr As %Integer [ Required ];

/// 操作代码
Property OperaCode As %String(TRUNCATE = 1) [ Required ];

/// 操作名称
Property OperaName As %String(TRUNCATE = 1);

Index IndexOfMenuOpera On (MenuDr, OperaCode) [ Unique ];

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.SS.MenuOperation
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:MenuDr 3:OperaCode 4:OperaName
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()
	set return=return_separete
	set return=return_..MenuDr_separete
	set return=return_..OperaCode_separete
	set return=return_..OperaName
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取菜单操作信息
/// Table：       DHCMed.SS.MenuOperation
/// Input：       ID:    DHCMed.SS.MenuOperation.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.MenuOperation).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.MenuOperation
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.MenuOperation).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.MenuOperation).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取菜单操作信息
/// Table：       DHCMed.SS.MenuOperation
/// Input：       ID:    DHCMed.SS.MenuOperation.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.MenuOperation).GetStringById(1)
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

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  更新MenuOperation
/// Table：       DHCMed.SS.MenuOperation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:MenuDr 3:OperaCode 4:OperaName
ClassMethod Update(InStr) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCMed.SS.MenuOperation).%New()
		} 
	else {
		set obj=##class(DHCMed.SS.MenuOperation).%OpenId(ID)
		}
	set obj.MenuDr=+$p(InStr,"^",2)
	set obj.OperaCode=$p(InStr,"^",3)
	set obj.OperaName=$p(InStr,"^",4)
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

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  删除MenuOperation
/// Table：       DHCMed.SS.MenuOperation
/// Input：       MenuOperationId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.SS.MenuOperation).%DeleteId(+Id)
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
<Data name="MenuOperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuDr</Value>
</Value>
<Value name="3">
<Value>OperaCode</Value>
</Value>
<Value name="4">
<Value>OperaName</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.MenuOperationD</DataLocation>
<DefaultData>MenuOperationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.MenuOperationD</IdLocation>
<IndexLocation>^DHCMed.SS.MenuOperationI</IndexLocation>
<StreamLocation>^DHCMed.SS.MenuOperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
