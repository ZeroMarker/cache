/// 检验项目表
Class DHCMA.Util.EPx.TestCode Extends (%Persistent, User.Abstract, DHCMA.Util.EP.TestCode) [ ClassType = persistent, Not ProcedureBlock ]
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

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取检验项目信息
/// Table：       DHCMA.Util.EPx.TestCode
/// Input：       aId : DHCMA.Util.EPx.TestCode.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EPx.TestCode).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.EPx.TestCode
{
	New (aId)
	Quit:'##class(DHCMA.Util.EPx.TestCode).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.EPx.TestCode).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新检验项目信息
/// Table：       DHCMA.Util.EPx.TestCode
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.TestCode).Update("","")
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
	Set RstFormat= $p(aInputStr,aSeparete,5)
	Set AbFlagS  = $p(aInputStr,aSeparete,6)
	Set ClDiagnos= $p(aInputStr,aSeparete,7)
	Set RefRanges= $p(aInputStr,aSeparete,8)
	Set WCode    = $p(aInputStr,aSeparete,9)
	Set IsActive = $p(aInputStr,aSeparete,10)
	Set ActUserID= $p(aInputStr,aSeparete,11)
	Quit:(OID="")||(Desc="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(OID)
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(OID)
	Quit:(objSYS="")||(SYSOID="") return
	
	Set tID=$o(^DHCMA.Util.EPx.TestCodeI("IdxOfOID"," "_$zcvt(OID,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.EPx.TestCode).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EPx.TestCode).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.OID          = OID
	Set obj.BTCode       = Code
	Set obj.BTDesc       = Desc
	Set obj.BTRstFormat  = RstFormat
	Set obj.BTAbFlagS    = AbFlagS
	Set obj.BTClDiagnos  = ClDiagnos
	Set obj.BTRefRanges  = RefRanges
	Set obj.BTWCode      = WCode
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
/// Description:  删除检验项目信息
/// Table：       DHCMA.Util.EPx.TestCode
/// Input：       aId : DHCMA.Util.EPx.TestCode.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.TestCode).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.EPx.TestCode).%DeleteId(aId)
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
<Data name="TestCodeDefaultData">
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
<Value>BTRstFormat</Value>
</Value>
<Value name="6">
<Value>BTAbFlagS</Value>
</Value>
<Value name="7">
<Value>BTClDiagnos</Value>
</Value>
<Value name="8">
<Value>BTRefRanges</Value>
</Value>
<Value name="9">
<Value>BTWCode</Value>
</Value>
<Value name="10">
<Value>BTIsActive</Value>
</Value>
<Value name="11">
<Value>BTActDate</Value>
</Value>
<Value name="12">
<Value>BTActTime</Value>
</Value>
<Value name="13">
<Value>BTActUserID</Value>
</Value>
<Value name="14">
<Value>SYSDr</Value>
</Value>
<Value name="15">
<Value>SYSOID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.EPx.TestCodeD</DataLocation>
<DefaultData>TestCodeDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EPx.TestCodeD</IdLocation>
<IndexLocation>^DHCMA.Util.EPx.TestCodeI</IndexLocation>
<StreamLocation>^DHCMA.Util.EPx.TestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
