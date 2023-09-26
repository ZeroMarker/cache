/// 名称: CT.IPMR.DP.System
/// 描述: 系统定义
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DP.System Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统代码（例：HIS1,HIS2...，约定DHCIPMR为病案系统代码）
Property DSSysCode As %String(MAXLEN = 50, TRUNCATE = 0) [ Required ];

/// 系统名称
Property DSSysDesc As %String(MAXLEN = 100, TRUNCATE = 0) [ Required ];

/// 外部码（用于与HIS对接，约定localhost为和病案系统同库HIS）
Property DSExCode As %String(MAXLEN = 100, TRUNCATE = 0) [ Required ];

/// 系统说明
Property DSResume As %String(MAXLEN = 500, TRUNCATE = 0);

/// 数据webservice接口类
Property DSDataSoap As %String(MAXLEN = 500, TRUNCATE = 0);

/// 浏览病历url
Property DSEMRUrl As %String(MAXLEN = 500, TRUNCATE = 0);

Index IndexOfCode On DSSysCode [ Unique ];

Index IndexOfExCode On DSExCode [ Unique ];

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  根据ID取系统定义
/// Table：       CT.IPMR.DP.System
/// Input：       aId : CT.IPMR.DP.System.ID
/// Return：      返回obj
/// w ##class(CT.IPMR.DP.System).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.DP.System
{
	New (aId)
	Quit:'##class(CT.IPMR.DP.System).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.DP.System).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  根据Code取系统定义
/// Table：       CT.IPMR.DP.System
/// Input：       aCode : CT.IPMR.DP.System.DSCode
/// Return：      返回String
/// w ##class(CT.IPMR.DP.System).GetObjByCode("")
ClassMethod GetObjByCode(aCode As %String) As CT.IPMR.DP.System
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^CT.IPMR.DP.SystemI("IndexOfCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  根据ExCode取系统定义
/// Table：       CT.IPMR.DP.System
/// Input：       aCode : CT.IPMR.DP.System.DSExCode
/// Return：      返回String
/// w ##class(CT.IPMR.DP.System).GetObjByExCode("HIS01")
ClassMethod GetObjByExCode(aExCode As %String) As CT.IPMR.DP.System
{
	New (aExCode)
	Set return=""
	Quit:aExCode="" return
	
	Set ID=$o(^CT.IPMR.DP.SystemI("IndexOfExCode"," "_$zcvt(aExCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  更新系统定义
/// Table：       CT.IPMR.DP.System
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.System).Update("^DHCIPMR^独立部署本地HIS环境库^localhost^独立部署本地HIS环境库","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID         = $p(aInputStr,aSeparete,1)
	Set Code       = $p(aInputStr,aSeparete,2)
	Set Desc       = $p(aInputStr,aSeparete,3)
	Set ExCode     = $p(aInputStr,aSeparete,4)
	Set DataSoap     = $p(aInputStr,aSeparete,5)
	Set Resume     = $p(aInputStr,aSeparete,6)
	Set EMRUrl		= $p(aInputStr,aSeparete,7)
	Quit:(Code="")||(Desc="")||(ExCode="") return
	
	Set tID=$o(^CT.IPMR.DP.SystemI("IndexOfCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -100
	
	Set tID=$o(^CT.IPMR.DP.SystemI("IndexOfExCode"," "_$zcvt(ExCode,"U"),0))
	Quit:(tID'="")&(ID'=tID) -101
	
	//Set flg = ##class(%Dictionary.CompiledClass).%OpenId(DataSoap)
	//Quit:flg="" -102
	
	If ID="" {
		Set obj=##class(CT.IPMR.DP.System).%New()
	}Else{
		Set obj=##class(CT.IPMR.DP.System).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DSSysCode     	= Code
	Set obj.DSSysDesc     	= Desc
	Set obj.DSExCode		= ExCode
	Set obj.DSResume     	= Resume
	Set obj.DSDataSoap		= DataSoap
	Set obj.DSEMRUrl		= EMRUrl
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

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  删除系统定义
/// Table：       CT.IPMR.DP.System
/// Input：       aId : CT.IPMR.DP.System.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.System).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(CT.IPMR.DP.System).%DeleteId(aId)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSSysCode</Value>
</Value>
<Value name="3">
<Value>DSSysDesc</Value>
</Value>
<Value name="4">
<Value>DSExCode</Value>
</Value>
<Value name="5">
<Value>DSResume</Value>
</Value>
<Value name="6">
<Value>DSDataSoap</Value>
</Value>
<Value name="7">
<Value>DSEMRUrl</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.DP.SystemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.DP.SystemD</IdLocation>
<IndexLocation>^CT.IPMR.DP.SystemI</IndexLocation>
<StreamLocation>^CT.IPMR.DP.SystemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
