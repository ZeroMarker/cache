/// 名称: DHCHAI.IR.CCWarning
/// 描述: 爆发预警表()的业务封装，定义常用属性和方法
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.CCWarning Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录	CW_EpisodeDr
Property CWEpisodeDr As %Integer;

/// 出院日期	CW_DischDate
Property CWDischDate As %Integer;

/// 是否有效	CW_IsActive
Property CWIsActive As %Boolean;

/// 更新日期	CW_UpdateDate
Property CWUpdateDate As %Integer;

/// 更新时间	CW_UpdateTime
Property CWUpdateTime As %Integer;

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  将对象格式化为字符串
/// Table：       DHCHAI.IR.CCWarning
/// Input：       aSeparete:指定的分隔符 
/// Return：      返回各属性值，按照aSeparete分隔
///               1 RowId 2 CWEpisodeDr 3 CWDischDate 4 CWIsActive 5 CWUpdateDate 6 CWUpdateTime
Method ToString(aSeparete As %String) As %String
{
	if $g(aSeparete)=""{
		set aSeparete=..#SEPARATE
		} 
    set return=..%Id()_aSeparete_..CWEpisodeDr
    set CWDischDate=""
    set:+..CWDischDate'=0 CWDischDate=$zd(..CWDischDate,3)
    set return=return_aSeparete_CWDischDate_aSeparete_..CWIsActive
    set CWUpdateDate=""
    set:+..CWUpdateDate'=0 CWUpdateDate=$zd(..CWUpdateDate,3)
    set return=return_aSeparete_CWUpdateDate
    set CWUpdateTime=""
    set:+..CWUpdateTime'=0 CWUpdateTime=$zt(..CWUpdateTime,1)
    set return=return_aSeparete_CWUpdateTime
	quit return
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据RowId取信息
/// Table：       DHCHAI.IR.CCWarning
/// Input：       RowID    DHCHAI.IR.CCWarning
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(RowId As %String) As DHCHAI.IR.CCWarning
{
	new (RowId)
	set return=""
	quit:RowId="" return
	quit:'$d(^DHCHAI.IR.CCWarningD(+RowId)) return
	set obj=##Class(DHCHAI.IR.CCWarning).%OpenId(+RowId)
	quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据RowId医院信息
/// Table：       DHCHAI.IR.CCMsgLog
/// Input：       rowid:    DHCHAI.IR.CCMsgLog
///               aSeparete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCHAI.IR.CCMsgLog).GetStringById(1)
ClassMethod GetStringById(rowId As %String, aSeparete As %String) As %String
{
	new (rowId,aSeparete)
	set return=""
	set obj=..GetObjById(rowId)
	if $IsObject(obj){
		set return=obj.ToString($g(aSeparete))
	}	
	quit return
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新
/// Table：       DHCHAI.IR.CCWarning
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1 RowId 2 CWEpisodeDr 3 CWDischDate 4 CWIsActive 5 CWUpdateDate 6 CWUpdateTime
/// w ##class(DHCHAI.IR.CCWarning).Update("^1^1^1^1^2017-01-16^11:33^1^处置意见^1^2017-01-17^11:43^1^反馈意见","")
ClassMethod Update(InStr As %String, aSeparete As %String) As %String
{
	 
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID=$p(InStr,aSeparete,1)
	Set CWEpisodeDr=$p(InStr,aSeparete,2)
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCWarning).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCWarning).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CWEpisodeDr=CWEpisodeDr
	Set obj.CIMsgType=$p(InStr,aSeparete,3)
	
	Set CWDischDate=$p(InStr,aSeparete,4)
	Set:CWDischDate["-" CWDischDate=$zdh(CWDischDate,3)
	Set:CWDischDate["/" CWDischDate=$zdh(CWDischDate,1)
	//Set:CIMsgDate="" CIMsgDate=+$h  //为空赋值当前日期
	Set obj.CWDischDate=CWDischDate
	Set obj.CWIsActive = $p(InStr,aSeparete,5)
	Set CWUpdateDate=$p(InStr,aSeparete,6)
	Set:CWUpdateDate["-" CWUpdateDate=$zdh(CWUpdateDate,3)
	Set:CWUpdateDate["/" CWUpdateDate=$zdh(CWUpdateDate,1)
	Set:CWUpdateDate="" CWUpdateDate=+$h  //为空赋值当前日期
	Set obj.CWUpdateDate=CWUpdateDate
	set CWUpdateTime=$p(InStr,aSeparete,7)
	Set:CWUpdateTime[":" CWUpdateTime=$zth(CWUpdateTime,1)
	Set:CWUpdateTime="" CWUpdateTime=+$p($h,",",1)
	set obj.CWUpdateTime = CWUpdateTime
	
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

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  删除
/// Table：       DHCHAI.IR.CCWarning
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCHAI.IR.CCWarning).%DeleteId(+Id)
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
<Data name="CCWarningDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CWEpisodeDr</Value>
</Value>
<Value name="3">
<Value>CWDischDate</Value>
</Value>
<Value name="4">
<Value>CWIsActive</Value>
</Value>
<Value name="5">
<Value>CWUpdateDate</Value>
</Value>
<Value name="6">
<Value>CWUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCWarningD</DataLocation>
<DefaultData>CCWarningDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCWarningD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCWarningI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCWarningS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
