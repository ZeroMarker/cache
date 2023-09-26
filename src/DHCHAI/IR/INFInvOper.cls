/// 名称: DHCHAI.IR.INFInvOper
/// 描述: 医院感染 ICU侵害性操作
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.INFInvOper Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 侵入性操作
Property IRInvOperDr As DHCHAI.BT.InvasOper;

/// 开始日期
Property IRSttDate As %Date;

/// 结束日期
Property IREndDate As %Date;

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

Index IndexEpisodeDr On IREpisodeDr As Exact;

/// Creator：     chenjb
/// CreatDate：   2017-01-21
/// Description:  取医院感染报告 疾病诊断
/// Table：       DHCHAI.IR.INFInvOper
/// Input：       DHCHAI.IR.INFInvOper.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFInvOper).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFInvOper
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.INFInvOper).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 疾病诊断
/// Table：       DHCHAI.IR.INFInvOper
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFInvOper).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	Set:$g(aSeparate)="" aSeparate=..#SEPARATE
	
	Set ID		  = $p(aInput,aSeparate,1)
	Set EpisodeDr = $p(aInput,aSeparate,2)
	Set InvOperDr = $p(aInput,aSeparate,3)
	Set SttDate	  = $p(aInput,aSeparate,4)
	Set EndDate   = $p(aInput,aSeparate,5)
	Set UpdateUserDr=$p(aInput,aSeparate,6)
	Set SttDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SttDate)
	Set EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(EndDate)
	If (ID="") {
		Set obj=##class(DHCHAI.IR.INFInvOper).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.INFInvOper).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Set objInvOper =##class(DHCHAI.BT.InvasOper).GetObjById(InvOperDr)
	Set objUpdateUser  =##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	Quit:'$IsObject(objPaadm) return
	Quit:'$IsObject(objInvOper) return
	
	Set obj.IREpisodeDr = objPaadm
	Set obj.IRInvOperDr = objInvOper
	Set obj.IRSttDate = SttDate
	Set obj.IREndDate = EndDate
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

/// Creator：     chenjb
/// CreatDate：   2017-01-21
/// Description:  删除医院感染报告 疾病诊断
/// Table：       DHCHAI.IR.INFInvOper
/// Input：       DHCHAI.IR.INFInvOper.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFInvOper).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.IR.INFInvOper).%DeleteId(aId)
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
<Data name="INFInvOperDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRInvOperDr</Value>
</Value>
<Value name="4">
<Value>IRSttDate</Value>
</Value>
<Value name="5">
<Value>IREndDate</Value>
</Value>
<Value name="6">
<Value>IRUpdateDate</Value>
</Value>
<Value name="7">
<Value>IRUpdateTime</Value>
</Value>
<Value name="8">
<Value>IRUpdateUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFInvOperD</DataLocation>
<DefaultData>INFInvOperDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFInvOperD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFInvOperI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFInvOperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
