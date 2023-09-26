/// 名称: DHCMed.INF.RepItem
/// 描述: 医政管理 感染报告 附加项目
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.RepItem Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 编码
Property Code As %String [ Required ];

/// 描述
Property Description As %String;

/// 数据类型 字典code
Property DataType As %String [ Required ];

/// 有效
Property IsActive As %Boolean;

/// 辅助字典名称code 指向 DHC_Med.SS.Dictionary
Property DicName As %String;

/// 是否可多选 Y/N
Property MultChoice As %String;

/// 备注
Property ResumeText As %String;

/// 拼音索引
Index Alias On Code;

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepItem
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: Code 3: Description 4: DataType 5: IsActive 6: DicName 7: MultChoice 8: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..DataType_separete
	set return=return_..IsActive_separete
	set return=return_..DicName_separete
	set return=return_..MultChoice_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 附加项
/// Table：       DHCMed.INF.RepItem
/// Input：       ID:    DHCMed.INF.RepItem.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepItem
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepItem).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepItem).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 附件项目
/// Table：       DHCMed.INF.RepItem
/// Input：       ID:    DHCMed.INF.RepItem.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepItem).GetStringById(1)
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
/// Description:  更新感染报告 附加项目
/// Table：       DHCMed.INF.RepItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: Code 3: Description 4: DataType 5: IsActive 6: DicName 7: MultChoice 8: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepItem).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepItem).%OpenId(ID)
		}
	set obj.Code=$p(InStr,separete,2)
	set obj.Description=$p(InStr,separete,3)
	set obj.DataType=$p(InStr,separete,4)
	set obj.IsActive=$p(InStr,separete,5)
	set obj.DicName=$p(InStr,separete,6)
	set obj.MultChoice=$p(InStr,separete,7)
	set obj.ResumeText=$p(InStr,separete,8)
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
/// Description:  删除感染报告 附加项目
/// Table：       DHCMed.INF.RepItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepItem).%DeleteId(+Id)
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
<Data name="RepItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>DataType</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>DicName</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>MultChoice</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepItemD</DataLocation>
<DefaultData>RepItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepItemD</IdLocation>
<IndexLocation>^DHCMed.INF.RepItemI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
