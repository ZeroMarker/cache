/// 名称: DHCMed.InfAim.Catheter
/// 描述: 尿管相关报告表
/// 编写者：liuyh
/// 编写日期: 2011-10-18
Class DHCMed.InfAim.Catheter Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告表ID 指向 目标性监测报告表：DHCMed_InfAim.Report
Property InfAimRepDR As %Integer [ Required ];

/// 插管日期
Property CatDate As %Integer;

/// 置管类型 指向字典表：DHCMed.SS.Dictionary   Code：CatType
Property CatType As %Integer;

/// 置管地点 指向字典表：DHCMed.SS.Dictionary   Code：CatPlace
Property CatPlace As %Integer;

/// 置管人员 指向SS_User
Property CatUserType As %Integer;

/// 拔管日期
Property OutCatDate As %Integer;

/// 是否死亡 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property DeathFlag As %Integer;

/// 去向
Property OutLocPlace As %String;

/// 是否感染 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property InfFlag As %Integer;

/// 报告人 指向SS_User
Property RepUser As %Integer;

/// 当前状态 指向字典表：DHCMed.SS.Dictionary   Code：RepStatus
Property RepStatus As %Integer;

/// 初次报告时间
Property FirstDate As %Integer;

/// 感染时间
Property InfDate As %Integer;

/// 病原菌
Property Pathogenic As %String;

Index InfAimRepDR On InfAimRepDR;

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.InfAim.Catheter
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:InfAimRepDR 3:CatDate 4:CatType 5:CatPlace 6:CatUserType 7:OutCatDate 8:DeathFlag
/// 9:OutLocPlace 10:InfFlag 11:RepUser 12:RepStatus 13:FirstDate 14:InfDate 15:Pathogenic
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfAimRepDR_separete
	set return=return_..CatDate_separete
	set return=return_..CatType_separete
	set return=return_..CatPlace_separete
	set return=return_..CatUserType_separete
	set return=return_..OutCatDate_separete
	set return=return_..DeathFlag_separete
	set return=return_..OutLocPlace_separete
	set return=return_..InfFlag_separete
	set return=return_..RepUser_separete
	set return=return_..RepStatus_separete
	set return=return_..FirstDate_separete
	set return=return_..InfDate_separete
	set return=return_..Pathogenic
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取尿管相关报告表对象
/// Table：       DHCMed.InfAim.Catheter
/// Input：       ID:    DHCMed.InfAim.Catheter.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Catheter).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.InfAim.Catheter
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.InfAim.Catheter).%ExistsId(+id) return
	set obj=##Class(DHCMed.InfAim.Catheter).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取尿管相关报告表信息
/// Table：       DHCMed.InfAim.Catheter
/// Input：       id: DHCMed.InfAim.Catheter.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Catheter).GetStringById(1)
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
/// Description:  更新尿管相关报告表
/// Table：       DHCMed.InfAim.Catheter
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.InfAim.Catheter).%New()
	}Else{
		Set obj=##class(DHCMed.InfAim.Catheter).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.InfAimRepDR=$p(InStr,"^",2)
	Set obj.CatDate=$p(InStr,"^",3)
	Set obj.CatType=$p(InStr,"^",4)
	Set obj.CatPlace=$p(InStr,"^",5)
	Set obj.CatUserType=$p(InStr,"^",6)
	Set obj.OutCatDate=$p(InStr,"^",7)
	Set obj.DeathFlag=$p(InStr,"^",8)
	Set obj.OutLocPlace=$p(InStr,"^",9)
	Set obj.InfFlag=$p(InStr,"^",10)
	Set obj.RepUser=$p(InStr,"^",11)
	Set obj.RepStatus=$p(InStr,"^",12)
	Set obj.FirstDate=$p(InStr,"^",13)
	Set obj.InfDate=$p(InStr,"^",14)
	Set obj.Pathogenic=$p(InStr,"^",15)
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
/// Description:  删除尿管相关报告表
/// Table：       DHCMed.InfAim.Catheter
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.InfAim.Catheter).%DeleteId(+Id)
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
<Data name="CatheterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AimSubRepDR</Value>
</Value>
<Value name="3">
<Value>InfAimRepDR</Value>
</Value>
<Value name="4">
<Value>StatusDR</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
<Value name="7">
<Value>UpdateUser</Value>
</Value>
<Value name="8">
<Value>CatDate</Value>
</Value>
<Value name="9">
<Value>CatPlace</Value>
</Value>
<Value name="10">
<Value>CatType</Value>
</Value>
<Value name="11">
<Value>CatUserType</Value>
</Value>
<Value name="12">
<Value>DeathFlag</Value>
</Value>
<Value name="13">
<Value>FirstDate</Value>
</Value>
<Value name="14">
<Value>InfFlag</Value>
</Value>
<Value name="15">
<Value>OutCatDate</Value>
</Value>
<Value name="16">
<Value>OutLocPlace</Value>
</Value>
<Value name="17">
<Value>RepStatus</Value>
</Value>
<Value name="18">
<Value>RepUser</Value>
</Value>
<Value name="19">
<Value>InfDate</Value>
</Value>
<Value name="20">
<Value>Pathogenic</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAim.CatheterD</DataLocation>
<DefaultData>CatheterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.InfAim.CatheterD</IdLocation>
<IndexLocation>^DHCMed.InfAim.CatheterI</IndexLocation>
<StreamLocation>^DHCMed.InfAim.CatheterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
