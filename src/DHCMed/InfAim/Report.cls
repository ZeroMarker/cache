/// 名称: DHCMed.InfAim.Report
/// 描述: 目标性监测报告表
/// 编写者：liuyh
/// 编写日期: 2011-10-18
Class DHCMed.InfAim.Report Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 指向 pa_adm表
Property PaadmDR As %Integer [ Required ];

/// 转科表ID 指向PA_AdmTransaction表
Property TransSubID As %Integer [ Required ];

Index TransSubID On (PaadmDR, TransSubID) [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.InfAim.Report
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:PaadmDR 3:TransSubID
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..PaadmDR_separete
	set return=return_..TransSubID
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取目标性监测报告表对象
/// Table：       DHCMed.InfAim.Report
/// Input：       ID:    DHCMed.InfAim.Report.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Report).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.InfAim.Report
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.InfAim.Report).%ExistsId(+id) return
	set obj=##Class(DHCMed.InfAim.Report).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取目标性监测报告表信息
/// Table：       DHCMed.InfAim.Report
/// Input：       id: DHCMed.InfAim.Report.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Report).GetStringById(1)
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
/// Description:  更新目标性监测报告表
/// Table：       DHCMed.InfAim.Report
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:PaadmDR 3:TransSubID
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.InfAim.Report).%New()
	}Else{
		Set obj=##class(DHCMed.InfAim.Report).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.PaadmDR=$p(InStr,"^",2)
	Set obj.TransSubID=$p(InStr,"^",3)
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
/// Description:  删除目标性监测报告表
/// Table：       DHCMed.InfAim.Report
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.InfAim.Report).%DeleteId(+Id)
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
<Data name="ReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtLoc</Value>
</Value>
<Value name="3">
<Value>InLocDate</Value>
</Value>
<Value name="4">
<Value>PaadmDR</Value>
</Value>
<Value name="5">
<Value>InLocTime</Value>
</Value>
<Value name="6">
<Value>TransSubID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAim.ReportD</DataLocation>
<DefaultData>ReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.InfAim.ReportD</IdLocation>
<IndexLocation>^DHCMed.InfAim.ReportI</IndexLocation>
<StreamLocation>^DHCMed.InfAim.ReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
