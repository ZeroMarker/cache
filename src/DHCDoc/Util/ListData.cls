/// 编写者：lixu
/// 日期: 2021-05-31
/// <p>描述: 通过重载%Library.ListOfDataTypes，使老数据库支持动态的基本写法：点、%Set、%Get、%Push、%Size、%ToJSON
/// <p>备注：{}/%Library.DynamicObject：替换为：##Class(DHCDoc.Util.ArrayData).%New()
/// <p>     []/%Library.DynamicArray：替换为：##Class(DHCDoc.Util.ListData).%New()
/// <p>例子：w ##class(DHCDoc.Util.ListData).TestList()
Class DHCDoc.Util.ListData Extends %Library.ListOfDataTypes
{

/// 父节点
Property %xmlParentNode As %String;

/// 列表属性标识
Property %isList As %String;

/// 对象初始化
Method %OnNew(key = "") As %Status [ Private, ServerOnly = 1 ]
{
	;q:(key = "") $$$OK
	s $this.%xmlParentNode = key
	q $$$OK
}

Method %DispatchSetProperty(key As %String, value As %String)
{
	If key=""||($data(i%Data(key))=0) Quit $$$ERROR($$$CollectionKeyInvalid,key)
	Set i%Data(key)=value
	Quit $$$OK
}

Method %DispatchGetProperty(key As %String) As %String [ CodeMode = expression, Final ]
{
$get(i%Data(key))
}

Method %Set(key As %String, value As %String)
{
	If key=""||($data(i%Data(key))=0) Quit $$$ERROR($$$CollectionKeyInvalid,key)
	Set i%Data(key)=value
	Quit $$$OK
}

/// 如果是列表主节点获取数据时，需从1开始：1:1:%Size()
Method %Get(key As %String) [ CodeMode = expression, Final ]
{
$get(i%Data(key))
}

Method Set(key As %String, value As %String)
{
	If key=""||($data(i%Data(key))=0) Quit $$$ERROR($$$CollectionKeyInvalid,key)
	Set i%Data(key)=value
	Quit $$$OK
}

Method Get(key As %String) [ CodeMode = expression, Final ]
{
$get(i%Data(key))
}

Method %Push(key As %String) As %Status
{
	Set i%Size=i%Size+1,i%Data(i%Size)=key
	Quit $$$OK
}

Method Push(key As %String) As %Status
{
	Set i%Size=i%Size+1,i%Data(i%Size)=key
	Quit $$$OK
}

/// Returns the number of elements contained in the list.
Method %Size() As %Integer [ CodeMode = expression, Final ]
{
i%Size
}

Method %ToJSON(key As %String) As %Stream.GlobalCharacter
{
	s obj= ##Class(DHCDoc.Util.FromXML).Arr2Json($this)
	q obj
}

/// w ##class(DHCDoc.Util.ListData).TestList()
ClassMethod TestList()
{
	s SubObj=##Class(DHCDoc.Util.ListData).%New()	;[]	
	f Sub=1:1:2 {
		s DescSub="第"_Sub_"层"
		s SubArr=##Class(DHCDoc.Util.ArrayData).%New()	;{}
		s SubArr."Desc_1"=DescSub
		d SubArr.SetAt(Sub,"Code")
		d SubArr.%Set("Data","测试"_Sub)
		
		i Sub=1 d SubObj.Insert(SubArr)
		e  d SubObj.%Push(SubArr)
	}
	s Json=SubObj.%ToJSON()
	w "Json：",!
	w "	"_Json.Read(),!
	
	s Arr=##Class(DHCDoc.Util.ArrayData).%New()
	s Obj=Arr.%FromJSON(Json)
	w "JsonObj：	",!

	f len=1:1:Obj.%Size() d
	.w "	Obj("_len_").Code="_Obj.Get(len)."Code"_"、Obj("_len_").Desc_1="_Obj.%Get(len)."Desc_1"
	.w "、Obj("_len_").Data="_Obj.Data(len).Data("Data") ,!
	q ""
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
