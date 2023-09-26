/// 名称: DHCHAI.BT.InfSuPos
/// 描述: 医院感染疑似诊断（部位）表
/// 编写者：zhufei
/// 编写日期: 2017-03-14
Class DHCHAI.BT.InfSuPos Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 疑似诊断
Property BTDiagnos As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 感染部位
Property BTInfPosDr As DHCHAI.BT.InfPos;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

Index IdxofBTDiagnos On BTDiagnos As Exact;

/// Creator：     zhufei
/// CreatDate：   2017-03-14
/// Description:  根据ID取疑似诊断（部位）信息
/// Table：       DHCHAI.BT.InfSuPos
/// Input：       aId : DHCHAI.BT.InfSuPos.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfSuPos).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.InfSuPos
{
	New (aId)
	Quit:'##class(DHCHAI.BT.InfSuPos).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.InfSuPos).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-14
/// Description:  更新疑似诊断（部位）信息
/// Table：       DHCHAI.BT.InfSuPos
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfSuPos).Update("^C001^CDesc^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set Diagnos   = $p(aInputStr,aSeparete,2)
	Set InfPosDr  = $p(aInputStr,aSeparete,3)
	Set ActDate   = $p(aInputStr,aSeparete,4)
	Set ActTime   = $p(aInputStr,aSeparete,5)
	Set ActUserDr = $p(aInputStr,aSeparete,6)
	Quit:Diagnos="" return
	Set Diagnos = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Diagnos)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.BT.InfSuPosI("IdxofBTDiagnos",Diagnos,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objInfPos=##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.InfSuPos).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.InfSuPos).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTDiagnos   = Diagnos
	Set obj.BTInfPosDr  = objInfPos
	Set obj.BTActDate   = ActDate
	Set obj.BTActTime   = ActTime
	Set obj.BTActUserDr = objActUser
	
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
/// CreatDate：   2017-03-14
/// Description:  删除疑似诊断（部位）信息
/// Table：       DHCHAI.BT.InfSuPos
/// Input：       aId : DHCHAI.BT.InfSuPos.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfSuPos).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.InfSuPos")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.BT.InfSuPos).%DeleteId(aId)
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
<Data name="InfSuPosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTDiagnos</Value>
</Value>
<Value name="3">
<Value>BTInfPosDr</Value>
</Value>
<Value name="4">
<Value>BTActDate</Value>
</Value>
<Value name="5">
<Value>BTActTime</Value>
</Value>
<Value name="6">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.InfSuPosD</DataLocation>
<DefaultData>InfSuPosDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.InfSuPosD</IdLocation>
<IndexLocation>^DHCHAI.BT.InfSuPosI</IndexLocation>
<StreamLocation>^DHCHAI.BT.InfSuPosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
