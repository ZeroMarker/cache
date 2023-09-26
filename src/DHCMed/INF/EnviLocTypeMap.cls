/// 名称: DHCMed.INF.EnviLocTypeMap
/// 描述: 环境卫生学报告科室环境类别对照表 
/// 编写者：liuyh
/// 编写日期: 2011-10-27
Class DHCMed.INF.EnviLocTypeMap Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告科室 指向Ct_loc表
Property CtlocDR As %Integer [ Required ];

/// 环境类别 指向字典表：DHCMed.SS.Dictionary   Code:EnviType
Property EnviType As %Integer;

Index CtlocDR On CtlocDR [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2011-10-27
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.EnviLocTypeMap
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:CtlocDR 3:EnviType
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CtlocDR_separete
	set return=return_..EnviType
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-27
/// Description:  根据ID取环境卫生学报告科室环境类别对照表 对象
/// Table：       DHCMed.INF.EnviLocTypeMap
/// Input：       ID:    DHCMed.INF.EnviLocTypeMap.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.EnviLocTypeMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.EnviLocTypeMap
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.EnviLocTypeMap).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.EnviLocTypeMap).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-27
/// Description:  根据ID取环境卫生学报告科室环境类别对照表 信息
/// Table：       DHCMed.INF.EnviLocTypeMap
/// Input：       id: DHCMed.INF.EnviLocTypeMap.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.EnviLocTypeMap).GetStringById(1)
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
/// CreatDate：   2011-10-27
/// Description:  更新环境卫生学报告科室环境类别对照表
/// Table：       DHCMed.INF.EnviLocTypeMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:CtlocDR 3:EnviType
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.INF.EnviLocTypeMap).%New()
	}Else{
		Set obj=##class(DHCMed.INF.EnviLocTypeMap).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.CtlocDR=$p(InStr,"^",2)
	Set obj.EnviType=$p(InStr,"^",3)
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
/// CreatDate：   2011-10-27
/// Description:  删除环境卫生学报告科室环境类别对照表
/// Table：       DHCMed.INF.EnviLocTypeMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.INF.EnviLocTypeMap).%DeleteId(+Id)
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
<Data name="EnviLocTypeMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtlocDR</Value>
</Value>
<Value name="3">
<Value>EnviType</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.EnviLocTypeMapD</DataLocation>
<DefaultData>EnviLocTypeMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.EnviLocTypeMapD</IdLocation>
<IndexLocation>^DHCMed.INF.EnviLocTypeMapI</IndexLocation>
<StreamLocation>^DHCMed.INF.EnviLocTypeMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
