/// 医院表
Class DHCMA.Util.EPx.Hospital Extends (%Persistent, User.Abstract, DHCMA.Util.EP.Hospital) [ ClassType = persistent, Not ProcedureBlock ]
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
/// Description:  根据ID取医院信息
/// Table：       DHCMA.Util.EPx.Hospital
/// Input：       aId : DHCMA.Util.EPx.Hospital.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EPx.Hospital).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.EPx.Hospital
{
	New (aId)
	Quit:'##class(DHCMA.Util.EPx.Hospital).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.EPx.Hospital).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新医院信息
/// Table：       DHCMA.Util.EPx.Hospital
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.Hospital).Update("","")
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
	Set Desc2    = $p(aInputStr,aSeparete,5)
	Set GroupDr  = $p(aInputStr,aSeparete,6)
	Set RangeID  = $p(aInputStr,aSeparete,7)
	Set IsActive = +$p(aInputStr,aSeparete,8)
	Set ActUserID= $p(aInputStr,aSeparete,9)
	Quit:(OID="")||(Desc="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(OID)
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(OID)
	Quit:(objSYS="")||(SYSOID="") return
	
	Set objHospGrp=##class(DHCMA.Util.BT.HospGroup).GetObjById(GroupDr)
	
	Set tID=$o(^DHCMA.Util.EPx.HospitalI("IdxOfOID"," "_$zcvt(OID,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.EPx.Hospital).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EPx.Hospital).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.OID          = OID
	Set obj.BTCode       = Code
	Set obj.BTDesc       = Desc
	Set obj.BTDesc2      = Desc2
	Set obj.BTGroupDr    = objHospGrp
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
/// Description:  删除医院信息
/// Table：       DHCMA.Util.EPx.Hospital
/// Input：       aId : DHCMA.Util.EPx.Hospital.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.Hospital).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.EPx.Hospital).%DeleteId(aId)
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
<Data name="HospitalDefaultData">
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
<Value>BTDesc2</Value>
</Value>
<Value name="6">
<Value>BTGroupDr</Value>
</Value>
<Value name="7">
<Value>BTRangeID</Value>
</Value>
<Value name="8">
<Value>BTIsActive</Value>
</Value>
<Value name="9">
<Value>BTActDate</Value>
</Value>
<Value name="10">
<Value>BTActTime</Value>
</Value>
<Value name="11">
<Value>BTActUserID</Value>
</Value>
<Value name="12">
<Value>SYSDr</Value>
</Value>
<Value name="13">
<Value>SYSOID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.EPx.HospitalD</DataLocation>
<DefaultData>HospitalDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EPx.HospitalD</IdLocation>
<IndexLocation>^DHCMA.Util.EPx.HospitalI</IndexLocation>
<StreamLocation>^DHCMA.Util.EPx.HospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
