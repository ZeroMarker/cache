/// 名称: DHCMed.INF.Environment
/// 描述: 环境卫生学报告表 
/// 编写者：liuyh
/// 编写日期: 2011-10-26
Class DHCMed.INF.Environment Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告科室 指向Ct_loc表
Property CtlocDR As %Integer [ Required ];

/// 报告日期
Property RepDate As %Integer [ Required ];

Index CtlocDR On CtlocDR;

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.Environment
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:CtlocDR 3:RepDate
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CtlocDR_separete
	set return=return_..RepDate
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取环境卫生学报告表 对象
/// Table：       DHCMed.INF.Environment
/// Input：       ID:    DHCMed.INF.Environment.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.Environment).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.Environment
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.Environment).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.Environment).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取环境卫生学报告表 信息
/// Table：       DHCMed.INF.Environment
/// Input：       id: DHCMed.INF.Environment.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.Environment).GetStringById(1)
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
/// CreatDate：   2011-10-18
/// Description:  更新环境卫生学报告表 
/// Table：       DHCMed.INF.Environment
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:CtlocDR 3:RepDate
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.INF.Environment).%New()
	}Else{
		Set obj=##class(DHCMed.INF.Environment).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.CtlocDR=$p(InStr,"^",2)
	Set RepDate=$p(InStr,"^",3)
	Set:RepDate["-" RepDate=$zdh(RepDate,3)
	Set obj.RepDate=RepDate
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {            //检查Save是否成功
		//Do $System.Status.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
	
UpdateErr
	Quit -1
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  删除环境卫生学报告表 
/// Table：       DHCMed.INF.Environment
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.INF.Environment).%DeleteId(+Id)
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
<Data name="EnvironmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AirNum</Value>
</Value>
<Value name="3">
<Value>CtlocDR</Value>
</Value>
<Value name="4">
<Value>EnviType</Value>
</Value>
<Value name="5">
<Value>Hand</Value>
</Value>
<Value name="6">
<Value>Object</Value>
</Value>
<Value name="7">
<Value>RepDate</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.EnvironmentD</DataLocation>
<DefaultData>EnvironmentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.EnvironmentD</IdLocation>
<IndexLocation>^DHCMed.INF.EnvironmentI</IndexLocation>
<StreamLocation>^DHCMed.INF.EnvironmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
