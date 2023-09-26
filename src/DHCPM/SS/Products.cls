/// 名称: DHCPM.SS.Products
/// 描述: 项目管理产品表
/// 编写者：dongzt
/// 编写日期: 2015-01-11
Class DHCPM.SS.Products Extends (%Persistent, DHCPM.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 产品代码
Property ProCode As %String(MAXLEN = 20, TRUNCATE = 1) [ Required ];

/// 产品名称
Property ProName As %String(TRUNCATE = 1) [ Required ];

/// 版本号
Property ProVersion As %String(TRUNCATE = 1);

/// 图标样式
Property IconClass As %String(TRUNCATE = 1);

/// 显示顺序
Property ShowIndex As %String(TRUNCATE = 1);

/// 是否有效
Property ProActive As %Boolean;

/// 备注
Property ProResume As %String(TRUNCATE = 1);

Index ProCodeIndex On ProCode [ Unique ];

Index ProShowIndex On ShowIndex;

Index ProductActive On (ProCode As AlphaUp, ProActive);

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  将对象格式化为字符串
/// Table：       DHCPM.SS.Products
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:ProCode 3:ProName 4:ProVersion 5:IconClass 6:ShowIndex 7:ProActive 8:ProResume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..ProCode_separete
	set return=return_..ProName_separete
	set return=return_..ProVersion_separete
	set return=return_..IconClass_separete
	set return=return_..ShowIndex_separete
	set return=return_..ProActive_separete
	set return=return_..ProResume
	quit return
}

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  根据ID取产品信息
/// Table：       DHCPM.SS.Products
/// Input：       ID:    DHCMed.SS.Menus.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCPM.SS.Products).GetStringById(1)
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

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  根据ID取产品信息
/// Table：       DHCPM.SS.Products
/// Input：       ID:    DHCPM.SS.Products.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCPM.SS.Products).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.Products
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCPM.SS.Products).%ExistsId(+id) return
	set obj=##Class(DHCPM.SS.Products).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  更新Products
/// Table：       DHCPM.SS.Products
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:ProCode 3:ProName 4:ProVersion 5:IconClass 6:ShowIndex 7:ProActive 8:ProResume
/// /w ##class(DHCPM.SS.Products).Update(^dongzt("Update"))
ClassMethod Update(InStr) As %String
{
	S ^dongzt("Update")=InStr
	new (InStr)
	set id=0
	
	set ID=$p(InStr,"^",1)
	set ProCode=$p(InStr,"^",2)
	quit:ProCode="" id
	b ;;01
	;Set xID=$o(^DHCPM.SS.ProductsI("ProCodeIndex"," "_ProCode,0))
	;quit:(ID'="")&&(ID'=xID) id
	b ;002
	;set ID=xID
	
	if ID="" {
		set obj=##class(DHCPM.SS.Products).%New()
	} else {
		set obj=##class(DHCPM.SS.Products).%OpenId(ID)
	}
	b ;;
	set obj.ProCode=$p(InStr,"^",2)
	set obj.ProName=$p(InStr,"^",3)
	set obj.ProVersion=$p(InStr,"^",4)
	set obj.IconClass=$p(InStr,"^",5)
	set obj.ShowIndex=$p(InStr,"^",6)
	set obj.ProActive=$s(+$p(InStr,"^",7)=0:0,1:1)
	set obj.ProResume=$p(InStr,"^",8)
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

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  删除Products
/// Table：       DHCPM.SS.Products
/// Input：       ProductsId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCPM.SS.Products).%DeleteId(+Id)
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
<Data name="ProductsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProCode</Value>
</Value>
<Value name="3">
<Value>ProName</Value>
</Value>
<Value name="4">
<Value>ProVersion</Value>
</Value>
<Value name="5">
<Value>IconClass</Value>
</Value>
<Value name="6">
<Value>ShowIndex</Value>
</Value>
<Value name="7">
<Value>ProActive</Value>
</Value>
<Value name="8">
<Value>ProResume</Value>
</Value>
</Data>
<DataLocation>^DHCPM.SS.ProductsD</DataLocation>
<DefaultData>ProductsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCPM.SS.ProductsD</IdLocation>
<IndexLocation>^DHCPM.SS.ProductsI</IndexLocation>
<StreamLocation>^DHCPM.SS.ProductsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
