/// 名称: DHCMed.INF.InfPosition
/// 描述: 医政管理感染部位
/// 编写者：ChenJB
/// 编写日期: 2010-05-11
Class DHCMed.INF.InfPosition Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 部位编码
Property Code As %String [ Required ];

/// 感染部位
Property InfPosition As %String [ Required ];

/// 有效状态
Property Active As %Boolean;

/// 备注
Property ResumeText As %String;

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.InfPosition
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: Code 3: InfPosition 4: Active 5: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..InfPosition_separete
	set return=return_..Active_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  根据ID取感染部位信息
/// Table：       DHCMed_INF.InfPosition
/// Input：       ID:    DHCMed.INF.InfPosition.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.InfPosition).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.InfPosition
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.InfPosition).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.InfPosition).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  根据ID取感染部位信息
/// Table：       DHCMed_INF.InfPosition
/// Input：       ID:    DHCMed.INF.InfPosition.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.InfPosition).GetStringById(1)
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
/// CreatDate：   2010-05-11
/// Description:  更新感染信息
/// Table：       DHCMed.INF.InfPosition
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: Code 3: InfPosition 4: Active 5: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.InfPosition).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.InfPosition).%OpenId(ID)
		}
	set obj.Code=$p(InStr,separete,2)
	set obj.InfPosition=$p(InStr,separete,3)
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
/// CreatDate：   2010-05-11
/// Description:  删除感染部位
/// Table：       DHCMed.INF.InfPosition
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.InfPosition).%DeleteId(+Id)
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
<Data name="InfPositionDefaultData">
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
<Value>InfPosition</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.InfPositionD</DataLocation>
<DefaultData>InfPositionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.InfPositionD</IdLocation>
<IndexLocation>^DHCMed.INF.InfPositionI</IndexLocation>
<StreamLocation>^DHCMed.INF.InfPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
