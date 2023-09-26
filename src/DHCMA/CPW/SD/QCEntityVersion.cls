/// 描述: 单病种版本记录
/// 编写者：zhugz
/// 编写日期: 2020-10-20
Class DHCMA.CPW.SD.QCEntityVersion Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 版本代码
Property VerCode As %String(TRUNCATE = 1) [ Required ];

/// 版本说明
Property VerDesc As %String(TRUNCATE = 1) [ Required ];

/// 启用日期
Property VerSDate As %Date;

/// 截止日期
Property VerEDate As %Date;

Index IdxofCode On VerCode As Exact;

/// w ##class(DHCMA.CPW.SD.QCEntityVersion).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCEntityVersion
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCEntityVersion).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCEntityVersion).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhugz
/// CreatDate：   2020-10-20
/// Description:  根据Code取病种版本信息
/// Table：       DHCMA.CPW.SD.QCEntityVersion
/// Input：       aCode : DHCMA.CPW.SD.QCEntityVersion.VerCode
/// Return：      返回String
/// w ##class(DHCMA.CPW.SD.QCEntityVersion).GetObjByCode("V202010")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMA.CPW.SD.QCEntityVersionI("IdxofCode",$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhugz
/// CreatDate：   2020-10-20
/// Description:  更新病种版本信息
/// Table：       DHCMA.CPW.SD.QCEntityVersion
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.QCEntityVersion).Update("^daima^miaoshu^suoxie^1^11^2009")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID               = $p(aInputStr,aSeparete,1)
	Set Code             = $p(aInputStr,aSeparete,2)
	Set Desc             = $p(aInputStr,aSeparete,3)
	Set VerSDate         = $p(aInputStr,aSeparete,4)
	Set VerEDate         = $p(aInputStr,aSeparete,5)
	Set:VerSDate["-" VerSDate=$zdh(VerSDate,3)
	Set:VerEDate["-" VerEDate=$zdh(VerEDate,3)
	Quit:(Code="")||(Desc="") return
	Set tID=$o(^DHCMA.CPW.SD.QCEntityVersionI("IdxofCode",$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2                
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCEntityVersion).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCEntityVersion).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.VerCode        	= Code
	Set obj.VerDesc        	= Desc
	Set obj.VerSDate      	= VerSDate
	Set obj.VerEDate    	= VerEDate
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhugz
/// CreatDate：   2020-10-20
/// Description:  删除病种版本信息
/// Table：       DHCMA.CPW.SD.QCEntityVersion
/// Input：       aId : DHCMA.CPW.SD.QCEntityVersion.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.QCEntityVersion).DeleteById(6)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCEntityVersion).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="QCEntityVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VerCode</Value>
</Value>
<Value name="3">
<Value>VerDesc</Value>
</Value>
<Value name="4">
<Value>VerSDate</Value>
</Value>
<Value name="5">
<Value>VerEDate</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCEntityVersionD</DataLocation>
<DefaultData>QCEntityVersionDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCEntityVersionD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCEntityVersionI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCEntityVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
