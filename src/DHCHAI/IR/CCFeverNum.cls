/// 名称: DHCHAI.IR.CCFeverNum
/// 描述: 科室发热人数
/// 编写者：mayanpeng
/// 编写日期: 2018-01-10
Class DHCHAI.IR.CCFeverNum Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 科室
Property CCLocDr As DHCHAI.BT.Location;

/// 日期
Property CCActDate As %Date;

/// 发热人数
Property CCFeverNum As %Integer;

/// 科室+日期索引
Index IndexLocDate On (CCLocDr, CCActDate);

/// Creator：     mayanpeng
/// CreatDate：   2018-01-10
/// Description:  根据ID取科室发热人数
/// Table：       DHCHAI.IR.CCFeverNum
/// Input：       aId : DHCHAI.IR.CCFeverNum.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCFeverNum).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCFeverNum
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCFeverNum).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCFeverNum).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     mayanpeng
/// CreatDate：   2018-01-12
/// Description:  根据科室ID和日期取科室发热人数
/// Table：       DHCHAI.IR.CCFeverNum
/// Input：       aLocID : DHCHAI.IR.CCFeverNum.CCLocDr
/// 			  aActDate : DHCHAI.IR.CCFeverNum.CCActDate
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCFeverNum).GetObjByLocDate()
ClassMethod GetObjByLocDate(aLocID As %String, aActDate As %String) As DHCHAI.IR.CCFeverNum
{
	New (aLocID,aActDate)
	Set return=""
	Quit:(aLocID="")||(aActDate="") return
	
	Set FerverID=$o(^DHCHAI.IR.CCFeverNumI("IndexLocDate",aLocID,aActDate,""))
	Quit:FerverID="" return
	
	Set objFerver=..GetObjById(FerverID)
	Quit:'$IsObject(objFerver) return
	Quit objFerver
}

/// Creator：     mayanpeng
/// CreatDate：   2018-01-10
/// Description:  更新科室发热人数
/// Table：       DHCHAI.IR.CCFeverNum
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCFeverNum).Update("^6^2018-01-10^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID           = $p(aInputStr,aSeparete,1)
	Set LocDr	     = $p(aInputStr,aSeparete,2)
	Set ActDate   	 = $p(aInputStr,aSeparete,3)
	Set FeverNum   	 = $p(aInputStr,aSeparete,4)
	Quit:(LocDr="")||(ActDate="")||(FeverNum="") return
	
	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate="" ActDate=+$h
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCFeverNum).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCFeverNum).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.CCLocDr      = objLoc
	Set obj.CCActDate	 = ActDate
	Set obj.CCFeverNum   = +FeverNum
	
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

/// Creator：     mayanpeng
/// CreatDate：   2018-01-10
/// Description:  删除科室发热人数
/// Table：       DHCHAI.IR.CCFeverNum
/// Input：       aId : DHCHAI.IR.CCFeverNum.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCFeverNum).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CCFeverNum).%DeleteId(aId)
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
<Data name="CCFeverNumDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCLocDr</Value>
</Value>
<Value name="3">
<Value>CCActDate</Value>
</Value>
<Value name="4">
<Value>CCFeverNum</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCFeverNumD</DataLocation>
<DefaultData>CCFeverNumDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCFeverNumD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCFeverNumI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCFeverNumS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
