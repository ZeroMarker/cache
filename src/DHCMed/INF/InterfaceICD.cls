/// 名称: DHCMed.INF.InterfaceICD
/// 描述: 医政管理 疾病/手术接口ICD
/// 编写者：liuyh
/// 编写日期: 2010-09-15
Class DHCMed.INF.InterfaceICD Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// ICD
Property ICD As %String [ Required ];

/// 名称
Property Name As %String [ Required ];

/// 全名
Property LongName As %String;

/// 类型 字典Code
Property Type As %String [ Required ];

/// 有效
Property IsActive As %Boolean;

/// 备注
Property ResumeText As %String;

/// 拼音
Property PinYin As %String [ Required ];

/// 类型拼音索引
Index TypePinYin On (Type, PinYin);

Index TypeICD On (Type, ICD) [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2010-09-15
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.InfPathogenDic
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: ICD 3: Name 4: LongName 5: Type 6：IsActive 7：ResumeText 8：PinYin
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..ICD_separete
	set return=return_..Name_separete
	set return=return_..LongName_separete
	set return=return_..Type
	set return=return_..IsActive_separete
	set return=return_..ResumeText_separete
	set return=return_..PinYin
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-09-15
/// Description:  根据ID接口ICD信息
/// Table：       DHCMed.INF.InterfaceICD
/// Input：       ID:    DHCMed.INF.InfPathogenDic.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.InterfaceICD).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.InterfaceICD
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.InterfaceICD).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.InterfaceICD).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-09-15
/// Description:  根据ID接口ICD信息
/// Table：       DHCMed.INF.InterfaceICD
/// Input：       ID:    DHCMed.INF.InterfaceICD.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.InterfaceICD).GetStringById(1)
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

/// Creator：     liuyh
/// CreatDate：   2010-09-15
/// Description:  更新病原体信息
/// Table：       DHCMed.INF.InterfaceICD
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: ICD 3: Name 4: LongName 5: Type 6：IsActive 7：ResumeText 8：PinYin
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.InterfaceICD).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.InterfaceICD).%OpenId(ID)
		}
	set obj.ICD=$p(InStr,separete,2)
	set obj.Name=$p(InStr,separete,3)
	set obj.LongName=$p(InStr,separete,4)
	set obj.Type=$p(InStr,separete,5)
	set obj.IsActive=$p(InStr,separete,6)
	set obj.ResumeText=$p(InStr,separete,7)
	set obj.PinYin=$p(InStr,separete,8)
	b
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     liuyh
/// CreatDate：   2010-09-15
/// Description:  删除接口ICD信息
/// Table：       DHCMed.INF.InterfaceICD
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.InterfaceICD).%DeleteId(+Id)
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
<Data name="InterfaceICDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICD</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>LongName</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>PinYin</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.InterfaceICDD</DataLocation>
<DefaultData>InterfaceICDDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.InterfaceICDD</IdLocation>
<IndexLocation>^DHCMed.INF.InterfaceICDI</IndexLocation>
<StreamLocation>^DHCMed.INF.InterfaceICDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
