/// 编写者：lixu。
/// 编写日期: 2021-05-31
/// <p> 描述: 通过重载%Library.ArrayOfDataTypes，使老数据库支持动态的基本写法：点、%Set、%Get、%Size、%ToJSON、%FromJSON
/// <p>备注：{}/%Library.DynamicObject：替换为：##Class(DHCDoc.Util.ArrayData).%New()
/// <p>      []/%Library.DynamicArray：替换为：##Class(DHCDoc.Util.ListData).%New()
/// <p>例子：w ##class(DHCDoc.Util.ArrayData).TestData()
Class DHCDoc.Util.ArrayData Extends %Library.ArrayOfDataTypes
{

/// 父节点
Property %xmlParentNode As %String;

/// 存在属性标识
Property %xmlHasAttr As %String;

/// 属性数组
Property %xmlAttrNode As %String(XMLPROJECTION = "NONE") [ MultiDimensional ];

/// 对象初始化
Method %OnNew(key = "") As %Status [ Private, ServerOnly = 1 ]
{
	Quit:(key = "") $$$OK
	set $this.%xmlParentNode = key
	Quit $$$OK
}

Method SetAttr(key As %String, value As %String) As DHCDoc.Util.ArrayData
{
	Quit:($this.%xmlParentNode = "") $this
	set ..%xmlAttrNode($this.%xmlParentNode,key)=value
	set $this.%xmlHasAttr=1
	Quit $this
}

/// 点写法赋值
Method %DispatchGetProperty(key As %String) As %String [ CodeMode = expression, Final ]
{
$get(i%Data(key))
}

/// 点写法获取值
Method %DispatchSetProperty(key As %String, value As %String)
{
	Set i%Data(key)=value
	Quit $$$OK
}

/// 增加了链式写法和字符类型赋值
/// Type:字符类型(null,boolean,number,string,Ignore/忽略节点):默认string
Method %Set(key As %String, value As %String, Type As %String = "") As DHCDoc.Util.ArrayData
{
	Set i%Data(key)=value
	if Type'=""{
		Set i%Data(key,"Type")=Type
	}
	Quit $this
	Quit $$$OK
}

Method %Get(key As %String) [ CodeMode = expression, Final ]
{
$get(i%Data(key))
}

Method Set(key As %String, value As %String, Type As %String = "") As DHCDoc.Util.ArrayData
{
	Set i%Data(key)=value
	Set i%Data(key,"Type")=Type
	Quit $this
	Quit $$$OK
}

Method Get(key As %String) [ CodeMode = expression, Final ]
{
$get(i%Data(key))
}

Method SetAt(element As %String, key As %String, Type As %String = "") As %Status
{
	Set i%Data(key)=element
	Set i%Data(key,"Type")=Type
	Quit $$$OK
}

Method GetNext(ByRef key As %String, ByRef Type As %String = "") As %String
{
	Set key=$order(i%Data($get(key)))
	Set Type=$select(key="":"",1:$get(i%Data(key,"Type")))
	Set Type=$zcvt(Type,"U")
	Quit $select(key="":"",1:$get(i%Data(key)))
}

/// 增加了字符类型转换值处理
Method %GetNext(ByRef key As %String, ByRef Type As %String = "") As %String
{
	Set key=$order(i%Data($get(key)))
	Set Type=$select(key="":"",1:$get(i%Data(key,"Type")))
	Quit $select(key="":"",1:$get(i%Data(key)))
}

Method %Size() As %Integer [ ProcedureBlock = 1 ]
{
	Set key="" For count=0:1 Set key=$order(i%Data(key)) Quit:key=""
	Quit count
}

Method %ToJSON() As %Stream.GlobalCharacter
{
	s json= ##Class(DHCDoc.Util.FromXML).Arr2Json($this)
	q json
}

Method %FromJSON(Json) As DHCDoc.Util.ArrayData
{
	s obj= ##Class(DHCDoc.Util.FromXML).Json2Arr(Json)
	q obj
}

Method %ToXML(Root = "") As %Stream.GlobalCharacter
{
	i Root'="" {
		s xml= ##Class(DHCDoc.Util.FromXML).XMLRoot($this,Root)
	}else{
		s xml= ##Class(DHCDoc.Util.FromXML).Arr2XML($this)
	}
	q xml
}

Method %FromXML(Xml, Root = "", DemicFlag = 1) As DHCDoc.Util.ArrayData
{
	s obj= ##Class(DHCDoc.Util.FromXML).XML2Arr(Xml,Root,DemicFlag)
	q obj
}

/// 克隆对象，返回新的对象
/// w ##class(DHCDoc.Util.ArrayData).CloneObjects()
Method CloneObjects() As DHCDoc.Util.ArrayData
{
	set target=$this.%ConstructClone()
	quit target
}

/// 合并多个对象，返回新的对象
/// w ##class(DHCDoc.Util.ArrayData).MergeObjects()
Method MergeObject(pArgs...) As DHCDoc.Util.ArrayData
{
	q ..MergeObjects($this,pArgs...)
}

/// w ##class(DHCDoc.Util.ArrayData).MergeObjects()
ClassMethod MergeObjects(pArgs...) As DHCDoc.Util.ArrayData
{
	s target=##class(DHCDoc.Util.ArrayData).%New()	
	for i=1:1:pArgs {
		set arg = pArgs(i)
		set typeData=$CLASSNAME(arg)
		if (typeData="DHCDoc.Util.ArrayData") {
			for {
				set pData=arg.GetNext(.key,.Type)
				quit:key=""
				do target.%Set(key,pData,Type)
			}
		}
	}
    q target
}

/// 测试例子
/// w ##class(DHCDoc.Util.ArrayData).TestData()
ClassMethod TestData()
{
	s Obj=##Class(DHCDoc.Util.ArrayData).%New()
	s Obj.a=1
	d Obj.SetAt(2,"b_b")
	d Obj.%Set("c",3)
	d Obj.Set("d",4)
	d Obj.Set("Data",5)
	
	s Json=Obj.%ToJSON()
	w "Json：",!
	w "	"_Json.Read(),!
	
	s Arr=##Class(DHCDoc.Util.ArrayData).%New()
	s JsonObj=Arr.%FromJSON(Json)
	w "JsonObj：	",!
	w "	Obj.a="_JsonObj."a"_"、Obj.b_b="_JsonObj."b_b"_"、Obj.c="_JsonObj.%Get("c")_"、Obj.d="_JsonObj.GetAt("d") 
	w "、Obj.Data="_ JsonObj.Data("Data")
	w !
	
	s XML=Obj.%ToXML("Request")
	w "XML：",!
	w "	"_XML.Read(),!
	s Arr=##Class(DHCDoc.Util.ArrayData).%New()
	s XMLObj=Arr.%FromXML(XML,"Request")
	w "XMLObj：	",!
	w "	Obj.a="_XMLObj."a"_"、Obj.b_b="_XMLObj."b_b"_"、Obj.c="_XMLObj.%Get("c")_"、Obj.d="_XMLObj.GetAt("d") 
	w "、Obj.Data="_ XMLObj.Data("Data")
	w !
	
	s a=##class(DHCDoc.Util.ArrayData).%New()
	s a."a"=1
	
	s b=##class(DHCDoc.Util.ArrayData).%New()
	s b."b"=1
	;合并对象
	s c=a.MergeObject(b)
	
	;复制对象
	s d=c.CloneObjects()
	s d."a"=2
	s d."d"=2
	
	q ""
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
