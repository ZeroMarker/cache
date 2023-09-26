/// 名称: DHCMed.SS.Menus
/// 描述: 医政管理菜单表
/// 编写者：wuqk
/// 编写日期: 2010-03-24
Class DHCMed.SS.Menus Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 菜单代码
Property MenuCode As %String(TRUNCATE = 1) [ Required ];

/// 菜单名称
Property MenuCaption As %String(TRUNCATE = 1) [ Required ];

/// 目标地址
Property LinkUrl As %String(TRUNCATE = 1);

/// 表达式
Property Expression As %String(MAXLEN = 100, TRUNCATE = 1);

/// 产品指针
Property ProductDr As %Integer [ Required ];

/// 显示顺序
Property ShowIndex As %Integer;

/// 图标样式
Property IconClass As %String(TRUNCATE = 1);

/// 父菜单指针
Property ParentMenuDr As %Integer;

Index MenuCodeIndex On MenuCode [ Unique ];

Index IndexProParentIndex On (ProductDr, ParentMenuDr, ShowIndex);

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.SS.Menus
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:MenuCode 3:MenuCaption 4:LinkUrl 5:Expression 6:ProductDr 7:ShowIndex 8:IconClass 9:ParentMenuDr
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..MenuCode_separete
	set return=return_..MenuCaption_separete
	set return=return_..LinkUrl_separete
	set return=return_..Expression_separete
	set return=return_..ProductDr_separete
	set return=return_..ShowIndex_separete
	set return=return_..IconClass_separete
	set return=return_..ParentMenuDr
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取菜单信息
/// Table：       DHCMed.SS.Menus
/// Input：       ID:    DHCMed.SS.Menus.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Menus).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.Menus
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.Menus).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.Menus).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取菜单信息
/// Table：       DHCMed.SS.Menus
/// Input：       ID:    DHCMed.SS.Menus.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Menus).GetStringById(1)
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
/// Description:  更新Menu
/// Table：       DHCMed.SS.Menus
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:MenuCode 3:MenuCaption 4:LinkUrl 5:Expression 6:ProductDr 7:ShowIndex 8:IconClass 9:ParentMenuDr
ClassMethod Update(InStr) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCMed.SS.Menus).%New()
		} 
	else {
		set obj=##class(DHCMed.SS.Menus).%OpenId(ID)
		}
	set obj.MenuCode=$p(InStr,"^",2)
	set obj.MenuCaption=$p(InStr,"^",3)
	set obj.LinkUrl=$p(InStr,"^",4)
	set obj.Expression=$p(InStr,"^",5)
	set obj.ProductDr=+$p(InStr,"^",6)
	set obj.ShowIndex=$p(InStr,"^",7)
	set obj.IconClass=$p(InStr,"^",8)
	set obj.ParentMenuDr=+$p(InStr,"^",9)
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
/// Description:  删除Menu
/// Table：       DHCMed.SS.Menus
/// Input：       MenuId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.SS.Menus).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Query QueryByParent(productId As %String, parentId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,LinkUrl,MenuCaption,MenuCode,ParentMenuDr,ProductDr,ShowIndex FROM Menus
 WHERE (ProductDr = :productId AND ParentMenuDr = :parentId)
 ORDER BY ShowIndex
}

Query QueryAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,LinkUrl:%String,MenuCaption,MenuCode,ParentMenuDr,ProductDr,ShowIndex")
{
SELECT %ID,LinkUrl,MenuCaption,MenuCode,ParentMenuDr,ProductDr,ShowIndex FROM Menus
 ORDER BY ShowIndex
}

Storage Default
{
<Data name="MenusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuCaption</Value>
</Value>
<Value name="3">
<Value>MenuCode</Value>
</Value>
<Value name="4">
<Value>ParentMenuDr</Value>
</Value>
<Value name="5">
<Value>ProductDr</Value>
</Value>
<Value name="6">
<Value>ShowIndex</Value>
</Value>
<Value name="7">
<Value>LinkUrl</Value>
</Value>
<Value name="8">
<Value>IconClass</Value>
</Value>
<Value name="9">
<Value>Expression</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.MenusD</DataLocation>
<DefaultData>MenusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.MenusD</IdLocation>
<IndexLocation>^DHCMed.SS.MenusI</IndexLocation>
<StreamLocation>^DHCMed.SS.MenusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
