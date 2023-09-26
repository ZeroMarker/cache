/// 名称: DHCMed.INF.EnvironmentSub
/// 描述: 环境卫生学报告子表 
/// 编写者：liuyh
/// 编写日期: 2011-10-26
Class DHCMed.INF.EnvironmentSub Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 环境卫生学ID 指向 DHCMed.INF.Environment
Property EnviID As %Integer [ Required ];

/// 监测标本 指向字典表：DHCMed.SS.Dictionary   Code:EnviPath
Property EnviPath As %String [ Required ];

/// 标本 值
Property EnviPathValue As %String [ Required ];

/// 备注
Property ResumeText As %String;

Index EnviID On EnviID;

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.EnvironmentSub
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:EnviID 3:EnviPath 4:EnviPathValue 5:ResumeText
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..EnviID_separete
	set return=return_..EnviPath_separete
	set return=return_..EnviPathValue_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取环境卫生学报告子表 对象
/// Table：       DHCMed.INF.EnvironmentSub
/// Input：       ID:    DHCMed.INF.EnvironmentSub.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.EnvironmentSub).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.EnvironmentSub
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.EnvironmentSub).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.EnvironmentSub).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取环境卫生学报告子表 信息
/// Table：       DHCMed.INF.EnvironmentSub
/// Input：       id: DHCMed.INF.EnvironmentSub.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.EnvironmentSub).GetStringById(1)
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
/// Description:  更新环境卫生学报告子表
/// Table：       DHCMed.INF.EnvironmentSub
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:EnviID 3:EnviPath 4:EnviPathValue 5:ResumeText
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.INF.EnvironmentSub).%New()
	}Else{
		Set obj=##class(DHCMed.INF.EnvironmentSub).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.EnviID=$p(InStr,"^",2)
	Set obj.EnviPath=$p(InStr,"^",3)
	Set obj.EnviPathValue=$p(InStr,"^",4)
	Set obj.ResumeText=$p(InStr,"^",5)
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
/// Description:  删除环境卫生学报告子表 
/// Table：       DHCMed.INF.EnvironmentSub
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.INF.EnvironmentSub).%DeleteId(+Id)
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
<Data name="EnvironmentSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EnviID</Value>
</Value>
<Value name="3">
<Value>EnviPath</Value>
</Value>
<Value name="4">
<Value>EnviPathValue</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.EnvironmentSubD</DataLocation>
<DefaultData>EnvironmentSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.EnvironmentSubD</IdLocation>
<IndexLocation>^DHCMed.INF.EnvironmentSubI</IndexLocation>
<StreamLocation>^DHCMed.INF.EnvironmentSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
