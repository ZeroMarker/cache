/// 名称: DHCHAI.IR.CRuleOper
/// 描述: 手术筛查维护
/// 编写者：zhufei
/// 编写日期: 2017-05-17
Class DHCHAI.IR.CRuleOper Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 类型（1全院、2院区、3科室）
Property BTType As %Integer [ Required ];

/// 全院
Property BTHospGrpDr As DHCHAI.BT.HospGroup [ Required ];

/// 院区
Property BTHospDr As DHCHAI.BT.Hospital;

/// 科室
Property BTLocDr As DHCHAI.BT.Location [ Required ];

/// 手术字典
Property BTOperDxDr As DHCHAI.DP.OROperDx;

/// 手术切口类型
Property BTIncisionDr As DHCHAI.BT.Dictionary;

/// 手术（自定义）
Property BTOperation As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

Index IndexTypeLocDr On (BTType, BTLocDr);

Index IndexTypeHospDr On (BTType, BTHospDr);

Index IndexTypeHospGrpDr On (BTType, BTHospGrpDr);

/// Creator：     zhufei
/// CreatDate：   2017-05-17
/// Description:  根据ID取手术筛查标准信息
/// Table：       DHCHAI.IR.CRuleOper
/// Input：       aId : DHCHAI.IR.CRuleOper.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleOper).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleOper
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleOper).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleOper).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-05-17
/// Description:  更新手术筛查标准信息
/// Table：       DHCHAI.IR.CRuleOper
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleOper).Update("^阑尾病损切除术^56^1^^^9","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set Type	   = +$p(aInputStr,aSeparete,2)
	Set LocDr	   = $p(aInputStr,aSeparete,3)
	Set IncisionDr = $p(aInputStr,aSeparete,4)
	Set OperDxDr   = $p(aInputStr,aSeparete,5)
	Set Operation  = $p(aInputStr,aSeparete,6)
	Set IsActive   = +$p(aInputStr,aSeparete,7)
	Set ActDate    = $p(aInputStr,aSeparete,8)
	Set ActTime    = $p(aInputStr,aSeparete,9)
	Set ActUserDr  = +$p(aInputStr,aSeparete,10)
	Quit:(LocDr="") return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTHospDr) return
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) return
	Set objHosp=objLoc.BTHospDr
	Set objHospGroup=objLoc.BTHospDr.BTGroupDr
	Set HospDr=objHosp.%Id()
	Set HospGrpDr=objHospGroup.%Id()
	
	Set Operation=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Operation) //去掉特殊字符
	Set objIncision=##class(DHCHAI.BT.Dictionary).GetObjById(IncisionDr)
	Set objOperDx=##class(DHCHAI.DP.OROperDx).GetObjById(OperDxDr)
	Quit:(Operation="")&&'$IsObject(objIncision)&&'$IsObject(objOperDx) return
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleOper).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleOper).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTType       = Type
	Set obj.BTHospGrpDr  = objHospGroup
	Set obj.BTHospDr     = objHosp
	Set obj.BTLocDr      = objLoc
	Set obj.BTIncisionDr = objIncision
	Set obj.BTOperDxDr   = objOperDx
	Set obj.BTOperation  = Operation
	Set obj.BTIsActive   = IsActive
	Set obj.BTActDate    = ActDate
	Set obj.BTActTime    = ActTime
	Set obj.BTActUserDr  = objActUser
	
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
/// CreatDate：   2017-05-17
/// Description:  删除手术筛查标准信息
/// Table：       DHCHAI.IR.CRuleOper
/// Input：       aId : DHCHAI.IR.CRuleOper.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleOper).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleOper).%DeleteId(aId)
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
<Data name="CRuleOperDefaultData">
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
<Value>BTOperDxDr</Value>
</Value>
<Value name="7">
<Value>BTIncisionDr</Value>
</Value>
<Value name="8">
<Value>BTOperation</Value>
</Value>
<Value name="9">
<Value>BTIsActive</Value>
</Value>
<Value name="10">
<Value>BTActDate</Value>
</Value>
<Value name="11">
<Value>BTActTime</Value>
</Value>
<Value name="12">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleOperD</DataLocation>
<DefaultData>CRuleOperDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleOperD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleOperI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleOperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
