/// 医护人员表
Class DHCMA.Util.EPx.CareProv Extends (%Persistent, User.Abstract, DHCMA.Util.EP.CareProv) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统指针
Property SYSDr As DHCMA.Util.BT.SYSTEM [ Required ];

/// 字典指针
Property SYSOID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 记录码 索引
Index IdxOfOID On OID [ Unique ];

/// 代码 索引
Index IdxOfCode On (SYSDr, BTCode);

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取医护人员信息
/// Table：       DHCMA.Util.EPx.CareProv
/// Input：       aId : DHCMA.Util.EPx.CareProv.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EPx.CareProv).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.EPx.CareProv
{
	New (aId)
	Quit:'##class(DHCMA.Util.EPx.CareProv).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.EPx.CareProv).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新医护人员信息
/// Table：       DHCMA.Util.EPx.CareProv
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.CareProv).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set OID      = $p(aInputStr,aSeparete,2)
	Set Code     = $p(aInputStr,aSeparete,3)
	Set Desc     = $p(aInputStr,aSeparete,4)
	Set Type     = $p(aInputStr,aSeparete,5)
	Set RangeID  = $p(aInputStr,aSeparete,6)
	Set IsActive = +$p(aInputStr,aSeparete,7)
	Set ActUserID= $p(aInputStr,aSeparete,8)
	Quit:(OID="")||(Desc="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(OID)
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(OID)
	Quit:(objSYS="")||(SYSOID="") return
	
	Set tID=$o(^DHCMA.Util.EPx.CareProvI("IdxOfOID"," "_$zcvt(OID,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.EPx.CareProv).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EPx.CareProv).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.OID          = OID
	Set obj.BTCode       = Code
	Set obj.BTDesc       = Desc
	Set obj.BTType       = Type
	Set obj.BTRangeID    = RangeID
	Set obj.BTIsActive   = IsActive
	Set obj.BTActDate    = +$h
	Set obj.BTActTime    = $p($h,",",2)
	Set obj.BTActUserID  = ActUserID
	Set obj.SYSDr        = objSYS
	Set obj.SYSOID       = SYSOID
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
/// CreatDate：   2018-07-31
/// Description:  删除医护人员信息
/// Table：       DHCMA.Util.EPx.CareProv
/// Input：       aId : DHCMA.Util.EPx.CareProv.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.CareProv).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.EPx.CareProv).%DeleteId(aId)
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
<Data name="CareProvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OID</Value>
</Value>
<Value name="3">
<Value>BTCode</Value>
</Value>
<Value name="4">
<Value>BTDesc</Value>
</Value>
<Value name="5">
<Value>BTType</Value>
</Value>
<Value name="6">
<Value>BTRangeID</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUserID</Value>
</Value>
<Value name="11">
<Value>SYSDr</Value>
</Value>
<Value name="12">
<Value>SYSOID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.EPx.CareProvD</DataLocation>
<DefaultData>CareProvDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EPx.CareProvD</IdLocation>
<IndexLocation>^DHCMA.Util.EPx.CareProvI</IndexLocation>
<StreamLocation>^DHCMA.Util.EPx.CareProvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
