/// 名称: DHCHAI.IR.CCWarningAct
/// 描述: 暴发预警表处置记录
/// 编写者：zhoubo
/// 编写日期: 2019-03-15
Class DHCHAI.IR.CCWarningAct Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 预警科室
Property IRWarnLocDr As DHCHAI.BT.Location;

/// 预警报卡
Property IRWarnRepDr As DHCHAI.IR.CCWarningRep;

/// 预警项目
Property IRWarnItem As %String;

/// 预警日期
Property IRWarnDate As %Date;

/// 处置状态(1:疑似聚集,2:散发)
Property IRActStatus As %String;

/// 处置日期
Property CCActDate As %Date;

/// 处置时间
Property CCActTime As %Time;

/// 处置人
Property CCActUserDr As DHCHAI.BT.SysUser;

/// 处置意见
Property CCOpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 处置查询条件
Property CCWarnItems As %String(MAXLEN = 500, TRUNCATE = 1);

/// 预警科室+预警日期索引
Index IndexWarnLocDate On (IRWarnLocDr As Exact, IRWarnDate);

/// 预警日期+预警科室索引
Index IndexWarnDateLoc On (IRWarnDate, IRWarnLocDr As Exact);

/// 唯一索引预警科室+预警日期+项目索引
Index IndexWarnLocDateItem On (IRWarnLocDr As Exact, IRWarnDate, IRWarnItem As Exact);

/// Creator：     zhoubo
/// CreatDate：   2019-03-15
/// Description:  获取对象
/// Table：       DHCHAI.IR.CCWarningAct
/// Input：       DHCHAI.IR.CCWarningAct.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCWarningAct).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCWarningAct
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.CCWarningAct).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2019-03-15
/// Description:  获取处置状态
/// Table：       DHCHAI.IR.CCWarningAct
/// Input：       DHCHAI.IR.CCWarningAct.ID
/// Return：      返回%String
/// w ##class(DHCHAI.IR.CCWarningAct).GetStatusByLocDate(189,"2019-03-14","现患人数")
ClassMethod GetStatusByLocDate(aWarnLocDr As %String, aWarnDate As %String, aWarnItem As %String) As %String
{
	New (aWarnLocDr,aWarnDate,aWarnItem)
	Set return=""
	Quit:((aWarnLocDr="")||(aWarnDate="")||(aWarnItem="")) return
	Set:aWarnDate'="" aWarnDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aWarnDate)
	
	Set ID=$o(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",aWarnLocDr,aWarnDate,aWarnItem,0))
	Set obj=##Class(DHCHAI.IR.CCWarningAct).GetObjById(ID)
	Quit:'$IsObject(obj) return	
	Set Status = obj.IRActStatus
	Set return = Status
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-10-17
/// Description:  更新对象
/// Table：       DHCHAI.IR.CCWarningAct
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.CCWarningAct).Update("^189^现患人数^2019-03-14^^^^^")
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID 			 = $p(aInput,aSeparate,1)
	Set IRWarnLocDr  = $p(aInput,aSeparate,2)
	Set IRWarnItem 	 = $p(aInput,aSeparate,3)
	Set IRWarnDate   = $p(aInput,aSeparate,4)
	Set IRActStatus  = $p(aInput,aSeparate,5)
	Set CCActDate	 = $p(aInput,aSeparate,6)
	Set CCActTime    = $p(aInput,aSeparate,7)
	Set CCActUserDr	 = $p(aInput,aSeparate,8)
	Set CCOpinion    = $p(aInput,aSeparate,9)
	Set IRWarnRepDr  = $p(aInput,aSeparate,10)
	Set WarnItems    = $p(aInput,"#",2)
	Quit:((IRWarnLocDr="")||(IRWarnItem="")||(IRWarnDate="")) return
	//唯一索引
	Set:IRWarnDate'="" IRWarnDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IRWarnDate)
	Set ID=$o(^DHCHAI.IR.CCWarningActI("IndexWarnLocDateItem",IRWarnLocDr,IRWarnDate,IRWarnItem,0))
	If (ID'=""){
		Set obj=##class(DHCHAI.IR.CCWarningAct).GetObjById(ID)
		Quit:'$IsObject(obj) return
		Set Status=obj.IRActStatus
		Set:Status=1 IRWarnRepDr=obj.IRWarnRepDr.%Id()
	}
	Set:CCActDate'="" CCActDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(CCActDate)
	Set:CCActTime[":" CCActTime = $zth(CCActTime,1)
	Set:CCActDate="" CCActDate=+$h
	Set:CCActTime="" CCActTime=$p($h,",",2)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(IRWarnLocDr)
	Quit:'$IsObject(objLoc) return
	Set objRep=##class(DHCHAI.BT.Location).GetObjById(IRWarnRepDr)
	Set objActUser = ##class(DHCHAI.BT.SysUser).GetObjById(CCActUserDr)
	Quit:'$IsObject(objActUser) return
		
	If (ID="") {
		Set obj=##class(DHCHAI.IR.CCWarningAct).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.CCWarningAct).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IRWarnLocDr  = objLoc
	Set obj.IRWarnItem   = IRWarnItem
	Set obj.IRWarnDate   = IRWarnDate
	Set obj.IRActStatus  = IRActStatus
	Set obj.CCActDate    = CCActDate
	Set obj.CCActTime    = CCActTime
	Set obj.CCActUserDr  = objActUser
	Set obj.CCOpinion    = CCOpinion
	Set obj.IRWarnRepDr  = objRep
	Set obj.CCWarnItems  = WarnItems
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-03-14
/// Description:  删除对象
/// Table：       DHCHAI.IR.CCWarningAct
/// Input：       DHCHAI.IR.CCWarningAct.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.CCWarningAct).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.IR.CCWarningAct).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="CCWarningActDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRWarnLocDr</Value>
</Value>
<Value name="3">
<Value>IRWarnItem</Value>
</Value>
<Value name="4">
<Value>IRWarnDate</Value>
</Value>
<Value name="5">
<Value>IRActStatus</Value>
</Value>
<Value name="6">
<Value>CCActDate</Value>
</Value>
<Value name="7">
<Value>CCActTime</Value>
</Value>
<Value name="8">
<Value>CCActUserDr</Value>
</Value>
<Value name="9">
<Value>CCOpinion</Value>
</Value>
<Value name="10">
<Value>IRWarnRepDr</Value>
</Value>
<Value name="11">
<Value>CCWarnItems</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCWarningActD</DataLocation>
<DefaultData>CCWarningActDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCWarningActD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCWarningActI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCWarningActS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
