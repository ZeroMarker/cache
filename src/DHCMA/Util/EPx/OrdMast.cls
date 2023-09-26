/// 医嘱项表
Class DHCMA.Util.EPx.OrdMast Extends (%Persistent, User.Abstract, DHCMA.Util.EP.OrdMast) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统指针
Property SYSDr As DHCMA.Util.BT.SYSTEM [ Required ];

/// 字典指针
Property SYSOID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 记录码 索引
Index IdxOfOID On OID [ Unique ];

/// 代码 索引
Index IdxOfCode On (SYSDr, BTCode);

/// 名称 索引
Index IdxOfDesc On (SYSDr, BTDesc);

/// 类型 索引
Index IdxOfType On (SYSDr, BTType As Exact);

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取医嘱项信息
/// Table：       DHCMA.Util.EPx.OrdMast
/// Input：       aId : DHCMA.Util.EPx.OrdMast.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EPx.OrdMast).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.EPx.OrdMast
{
	New (aId)
	Quit:'##class(DHCMA.Util.EPx.OrdMast).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.EPx.OrdMast).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新医嘱项信息
/// Table：       DHCMA.Util.EPx.OrdMast
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.OrdMast).Update("","")
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
	Set CatDesc  = $p(aInputStr,aSeparete,5)
	Set Type     = $p(aInputStr,aSeparete,6)
	Set IsActive = $p(aInputStr,aSeparete,7)
	Set ActUserID= $p(aInputStr,aSeparete,8)
	Quit:(OID="")||(Desc="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(OID)
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(OID)
	Quit:(objSYS="")||(SYSOID="") return
	
	Set tID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfOID"," "_$zcvt(OID,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.EPx.OrdMast).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EPx.OrdMast).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.OID          = OID
	Set obj.BTCode       = Code
	Set obj.BTDesc       = Desc
	Set obj.BTCatDesc    = CatDesc
	Set obj.BTType       = Type
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
/// Description:  删除医嘱项信息
/// Table：       DHCMA.Util.EPx.OrdMast
/// Input：       aId : DHCMA.Util.EPx.OrdMast.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.OrdMast).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.EPx.OrdMast).%DeleteId(aId)
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
<Data name="OrdMastDefaultData">
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
<Value>BTCatDesc</Value>
</Value>
<Value name="6">
<Value>BTType</Value>
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
<DataLocation>^DHCMA.Util.EPx.OrdMastD</DataLocation>
<DefaultData>OrdMastDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EPx.OrdMastD</IdLocation>
<IndexLocation>^DHCMA.Util.EPx.OrdMastI</IndexLocation>
<StreamLocation>^DHCMA.Util.EPx.OrdMastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
