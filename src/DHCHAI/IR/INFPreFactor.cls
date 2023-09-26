/// 名称: DHCHAI.IR.INFPreFactor
/// 描述: 医院感染 易感因素
/// 编写者：liyi
/// 编写日期: 2017-09-21
Class DHCHAI.IR.INFPreFactor Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 易感因素
Property IRPreFactorDr As DHCHAI.BT.PreFactor;

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

Index IndexEpisodeDr On IREpisodeDr As Exact;

/// Creator：     liyi
/// CreatDate：   2017-09-21
/// Description:  取医院感染报告 易感因素
/// Table：       DHCHAI.IR.INFPreFactor
/// Input：       DHCHAI.IR.INFPreFactor.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFPreFactor).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFPreFactor
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.INFPreFactor).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 易感因素
/// Table：       DHCHAI.IR.INFPreFactor
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFPreFactor).Update()
ClassMethod Update(aInput As %String, aSeparete As %String = "^") As %String
{
	New (aInput,aSeparete)
	Set return=0
	Quit:aInput="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		  = $p(aInput,aSeparete,1)
	Set EpisodeDr = $p(aInput,aSeparete,2)
	Set PreFactorDr=$p(aInput,aSeparete,3)
	Set UpdateUserDr=$p(aInput,aSeparete,4)
	If (ID="") {
		Set obj=##class(DHCHAI.IR.INFPreFactor).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.INFPreFactor).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Set objPreFactor =##class(DHCHAI.BT.PreFactor).GetObjById(PreFactorDr)
	Set objUpdateUser  =##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	Quit:'$IsObject(objPaadm) return
	Quit:'$IsObject(objPreFactor) return
	
	Set obj.IREpisodeDr=objPaadm
	Set obj.IRPreFactorDr=objPreFactor
	Set obj.IRUpdateDate = +$h
	Set obj.IRUpdateTime = +($p($h,",",2))
	Set obj.IRUpdateUserDr = objUpdateUser
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

/// Creator：     liyi
/// CreatDate：   2017-09-21
/// Description:  删除医院感染报告 易感因素
/// Table：       DHCHAI.IR.INFPreFactor
/// Input：       DHCHAI.IR.INFPreFactor.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFPreFactor).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.IR.INFPreFactor).%DeleteId(aId)
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
<Data name="INFPreFactorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRPreFactor</Value>
</Value>
<Value name="4">
<Value>IRUpdateDate</Value>
</Value>
<Value name="5">
<Value>IRUpdateTime</Value>
</Value>
<Value name="6">
<Value>IRUpdateUserDr</Value>
</Value>
<Value name="7">
<Value>IRPreFactorDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFPreFactorD</DataLocation>
<DefaultData>INFPreFactorDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFPreFactorD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFPreFactorI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFPreFactorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
