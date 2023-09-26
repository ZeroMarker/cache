/// 名称: DHCMA.Util.EP.SessionX
/// 描述: 新报告SessionID与ReportID对照
/// 编写者：zhufei
/// 编写日期: 2019-02-19
Class DHCMA.Util.EP.SessionX Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// SessionID
Property SXSessionID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 报告ID
Property SXReportID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IdxofSessionID On SXSessionID [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2019-02-19
/// Description:  根据ID取SessionID与ReportID对照信息
/// Table：       DHCMA.Util.EP.SessionX
/// Input：       aId : DHCMA.Util.EP.SessionX.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EP.SessionX).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.EP.SessionX
{
	New (aId)
	Quit:'##class(DHCMA.Util.EP.SessionX).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.EP.SessionX).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2019-02-19
/// Description:  生成SessionID
/// Table：       DHCMA.Util.EP.SessionX
/// Input：       无
/// Return：      返回%String
/// w ##class(DHCMA.Util.EP.SessionX).NewSessionID()
ClassMethod NewSessionID()
{
	New
	Set return=$tr($zd(+$h,3),"-","")_$tr($zt($p($h,",",2),1),":","")_"-"_$j
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-02-19
/// Description:  根据SessionID取报告ID
/// Table：       DHCMA.Util.EP.SessionX
/// Input：       aSessionID : DHCMA.Util.EP.SessionX.SXSessionID
/// Return：      返回%String
/// w ##class(DHCMA.Util.EP.SessionX).GetValue("AAAA")
ClassMethod GetValue(aSessionID As %String) As %String
{
	New (aSessionID)
	Set return=""
	Quit:(aSessionID="") return
	
	Set ID=$o(^DHCMA.Util.EP.SessionXI("IdxofSessionID"," "_$zcvt(aSessionID,"U"),0))
	Quit:ID="" return
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Set return=obj.SXReportID
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-02-19
/// Description:  更新SessionID与ReportID对照信息
/// Table：       DHCMA.Util.EP.SessionX
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.EP.SessionX).SetValue("AAAA^199")
ClassMethod SetValue(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set SessionID = $p(aInputStr,"^",1)
	Set ReportID  = $p(aInputStr,"^",2)
	Quit:(SessionID="")||(ReportID="") return
	
	Set ID=$o(^DHCMA.Util.EP.SessionXI("IdxofSessionID"," "_$zcvt(SessionID,"U"),0))
	If ID="" {
		Set obj=##class(DHCMA.Util.EP.SessionX).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EP.SessionX).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SXSessionID = SessionID
	Set obj.SXReportID  = ReportID
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

/// Creator：     zhufei
/// CreatDate：   2019-02-19
/// Description:  删除SessionID与ReportID对照信息
/// Table：       DHCMA.Util.EP.SessionX
/// Input：       aId : DHCMA.Util.EP.SessionX.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.EP.SessionX).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.EP.SessionX).%DeleteId(aId)
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
<Data name="SessionXDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SXSessionID</Value>
</Value>
<Value name="3">
<Value>SXReportID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.EP.SessionXD</DataLocation>
<DefaultData>SessionXDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EP.SessionXD</IdLocation>
<IndexLocation>^DHCMA.Util.EP.SessionXI</IndexLocation>
<StreamLocation>^DHCMA.Util.EP.SessionXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
