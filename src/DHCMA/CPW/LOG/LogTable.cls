/// 名称:		DHCMA.CPW.LOG.LogTable
/// 描述：		日志实体类
/// 创建者：	yankai
/// 创建日期：	2022-07-14
Class DHCMA.CPW.LOG.LogTable Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildExt As DHCMA.CPW.LOG.LogTableExt [ Cardinality = children, Inverse = Parref ];

/// 操作类名
Property ClassName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 操作表名
Property TableName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 操作类型
Property ActType As %String(DISPLAYLIST = "INSERT,UPDATE,DELETE", VALUELIST = ",I,U,D") [ Required ];

/// 记录ID
Property RecordID As %String [ Required ];

/// 操作日期
Property ActDate As %Date;

/// 操作时间
Property ActTime As %Time;

/// 操作用户
Property ActUserID As %String;

Index IdxofClassName On (ClassName As Exact, ActDate, ActTime);

Index IdxofOperDate On ActDate As Exact;

Index IdxofClassID On (ClassName As Exact, RecordID As Exact);

/// Creator：     yankai
/// CreatDate：   2022-07-14
/// Description:  更新记录
/// Table：       DHCMA.CPW.LOG.LogTable
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.LOG.LogTable).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID		    	= $p(aInputStr,aSeparete,1)
	Set ClassName        = $p(aInputStr,aSeparete,2)
	Set TableName      	= $p(aInputStr,aSeparete,3)
	Set ActType      	= $p(aInputStr,aSeparete,4)
	Set RecordID		= $p(aInputStr,aSeparete,5)
	Set ActDate			= $p(aInputStr,aSeparete,6)
	Set:ActDate="" ActDate = +$h
	Set ActTime			= $p(aInputStr,aSeparete,7)
	Set:ActTime="" ActTime = $p($h,",",2)
	Set ActUserID		= $p(aInputStr,aSeparete,8)
		
	If ID="" {
		Set obj=##class(DHCMA.CPW.LOG.LogTable).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.LOG.LogTable).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
		
	Set obj.ClassName   = ClassName  //对象
	Set obj.TableName	= TableName  
	Set obj.ActType   	= ActType
	Set obj.RecordID   	= RecordID
	Set obj.ActDate   	= ActDate
	Set obj.ActTime   	= ActTime
	Set obj.ActUserID   	= ActUserID

	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator:		yankai
/// Description:	更新日志操作人
/// w ##class(DHCMA.CPW.LOG.LogTable).UpdateActUser()
ClassMethod UpdateActUser(aClassName As %String, aID As %String, aUserID As %String)
{
	New (aClassName, aID, aUserID)
	Set return = ""
	Quit:(aClassName = "")||(aID = "")||(aUserID = "") return
	
	Set logID = $o(^DHCMA.CPW.LOG.LogTableI("IdxofClassID",aClassName,aID,""),-1)
	If logID'=""{
		Set objLog = ##class(DHCMA.CPW.LOG.LogTable).%OpenId(logID)
		Quit:'$IsObject(objLog) return
		Set objLog.ActUserID=aUserID
		Set sc = objLog.%Save()	
		If $system.Status.IsError(sc) { 
			Set return = -1
		}Else {
			Set return = logID	
		}
	}
	
	Quit return
}

Storage Default
{
<Data name="LogTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>ActType</Value>
</Value>
<Value name="5">
<Value>RecordID</Value>
</Value>
<Value name="6">
<Value>ActDate</Value>
</Value>
<Value name="7">
<Value>ActTime</Value>
</Value>
<Value name="8">
<Value>ActUserID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.LOG.LogTableD</DataLocation>
<DefaultData>LogTableDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.LOG.LogTableD</IdLocation>
<IndexLocation>^DHCMA.CPW.LOG.LogTableI</IndexLocation>
<StreamLocation>^DHCMA.CPW.LOG.LogTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
