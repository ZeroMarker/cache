/// 名称: DHCMed.INF.InfAntiDic
/// 描述: 医政管理 抗菌药物字典
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INF.InfAntiDic Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 编码
Property Code As %String [ Required ];

/// 抗菌药描述
Property Description As %String [ Required ];

/// 有效
Property Active As %Boolean;

/// 备注
Property ResumeText As %String;

/// 编码索引
Index Code On Code [ Unique ];

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: Code 3: Description 4: Active 5: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..Active_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取抗菌药信息
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       ID:    DHCMed.INF.InfAntiDic.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.InfAntiDic).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.InfAntiDic
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.InfAntiDic).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.InfAntiDic).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取抗菌药信息
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       ID:    DHCMed.INF.InfAntiDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.InfAntiDic).GetStringById(1)
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
/// Description:  更新抗菌药信息
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: Code 3: Description 4: Active 5: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.InfAntiDic).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.InfAntiDic).%OpenId(ID)
		}
	set obj.Code=$p(InStr,separete,2)
	set obj.Description=$p(InStr,separete,3)
	set obj.Active=+$p(InStr,separete,4)
	set obj.ResumeText=$p(InStr,separete,5)
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
/// Description:  删除抗菌药物
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.InfAntiDic).%DeleteId(+Id)
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
<Data name="InfAntiDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Desc</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.InfAntiDicD</DataLocation>
<DefaultData>InfAntiDicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.InfAntiDicD</IdLocation>
<IndexLocation>^DHCMed.INF.InfAntiDicI</IndexLocation>
<StreamLocation>^DHCMed.INF.InfAntiDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
