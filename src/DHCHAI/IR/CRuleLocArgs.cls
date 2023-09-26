/// 名称: DHCHAI.IR.CRuleLocArgs
/// 描述: 科室参数设置
/// 编写者：zhufei
/// 编写日期: 2017-08-31
Class DHCHAI.IR.CRuleLocArgs Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 类型（1全院、2院区、3科室）
Property BTType As %Integer [ Required ];

/// 全院
Property BTHospGrpDr As DHCHAI.BT.HospGroup [ Required ];

/// 院区
Property BTHospDr As DHCHAI.BT.Hospital;

/// 科室
Property BTLocDr As DHCHAI.BT.Location [ Required ];

/// 体温上限
Property BTFeverMax As %String(MAXLEN = 100, TRUNCATE = 1);

/// 体温下限
Property BTFeverMin As %String(MAXLEN = 100, TRUNCATE = 1);

/// 腹泻下限
Property BTDiarrMin As %String(MAXLEN = 100, TRUNCATE = 1);

/// 腹泻下限（儿童） 格式：年龄|值
Property BTDiarrMin2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUser As DHCHAI.BT.SysUser;

Index IndexTypeLocDr On (BTType, BTLocDr);

Index IndexTypeHospDr On (BTType, BTHospDr);

Index IndexTypeHospGrpDr On (BTType, BTHospGrpDr);

/// Creator：     zhufei
/// CreatDate：   2017-09-02
/// Description:  根据ID取科室参数信息
/// Table：       DHCHAI.IR.CRuleLocArgs
/// Input：       aId : DHCHAI.IR.CRuleLocArgs.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleLocArgs).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleLocArgs
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleLocArgs).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleLocArgs).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-09-02
/// Description:  更新科室参数信息
/// Table：       DHCHAI.IR.CRuleLocArgs
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleLocArgs).Update("^1^9^^^^38^36^3^5","^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete = ..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set Type		= +$p(InStr,aSeparete,2)
	Set LocDr		= $p(InStr,aSeparete,3)
	Set ActDate		= $p(InStr,aSeparete,4)
	Set ActTime		= $p(InStr,aSeparete,5)
	Set ActUser		= $p(InStr,aSeparete,6)
	Set FeverMax	= $p(InStr,aSeparete,7)
	Set FeverMin	= $p(InStr,aSeparete,8)
	Set DiarrMin	= $p(InStr,aSeparete,9)
	Set DiarrMin2	= $p(InStr,aSeparete,10)
	Quit:(LocDr="") return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUser)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTHospDr) return
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) return
	Set objHosp=objLoc.BTHospDr
	Set objHospGroup=objLoc.BTHospDr.BTGroupDr
	Set HospDr=objHosp.%Id()
	Set HospGrpDr=objHospGroup.%Id()
	
	If Type=1 {
		Set IndexNodeCode="IndexTypeHospGrpDr"
		Set NodeVal=HospGrpDr
	} ElseIf Type=2 {
		Set IndexNodeCode="IndexTypeHospDr"
		Set NodeVal=HospDr
	} ElseIf Type=3 {
		Set IndexNodeCode="IndexTypeLocDr"
		Set NodeVal=LocDr
	} Else {
		Quit return //退出
	}
	//代码唯一性
	Set tID =$o(^DHCHAI.IR.CRuleLocArgsI(IndexNodeCode,Type,NodeVal,0))
	Quit:(tID'="")&&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleLocArgs).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleLocArgs).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTType      = Type
	Set obj.BTHospGrpDr = objHospGroup
	Set obj.BTHospDr    = objHosp
	Set obj.BTLocDr     = objLoc
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUser	= objActUser
	Set obj.BTFeverMax	= FeverMax
	Set obj.BTFeverMin	= FeverMin
	Set obj.BTDiarrMin	= DiarrMin
	Set obj.BTDiarrMin2	= DiarrMin2
	
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
/// CreatDate：   2017-09-02
/// Description:  删除科室参数信息
/// Table：       DHCHAI.IR.CRuleLocArgs
/// Input：       aId : DHCHAI.IR.CRuleLocArgs.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleLocArgs).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleLocArgs).%DeleteId(aId)
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
<Data name="CRuleLocArgsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTType</Value>
</Value>
<Value name="3">
<Value>BTHospGrpDr</Value>
</Value>
<Value name="4">
<Value>BTHospDr</Value>
</Value>
<Value name="5">
<Value>BTLocDr</Value>
</Value>
<Value name="6">
<Value>BTFeverMax</Value>
</Value>
<Value name="7">
<Value>BTFeverMin</Value>
</Value>
<Value name="8">
<Value>BTDiarrMin</Value>
</Value>
<Value name="9">
<Value>BTDiarrMin2</Value>
</Value>
<Value name="10">
<Value>BTActDate</Value>
</Value>
<Value name="11">
<Value>BTActTime</Value>
</Value>
<Value name="12">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleLocArgsD</DataLocation>
<DefaultData>CRuleLocArgsDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleLocArgsD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleLocArgsI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleLocArgsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
