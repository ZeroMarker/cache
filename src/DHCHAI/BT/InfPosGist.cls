/// 名称: DHCHAI.BT.InfPosGist
/// 描述: 感染诊断诊断依据
/// 编写者：pylian
/// 编写日期: 2018-01-04
Class DHCHAI.BT.InfPosGist Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 感染诊断
Property BTInfPosDr As DHCHAI.BT.InfPos;

/// 诊断依据类型
Property BTTypeDr As DHCHAI.BT.Dictionary;

/// 诊断依据代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 诊断依据内容
Property BTDesc As %String(MAXLEN = 1000, TRUNCATE = 1) [ Required ];

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 诊断依据索引
Index IdxofInfPosDr On (BTInfPosDr, BTDesc) [ Unique ];

/// Creator：     pylian
/// CreatDate：   2018-01-04
/// Description:  根据ID取感染诊断诊断依据信息
/// Table：       DHCHAI.BT.InfPosGist
/// Input：       aId : DHCHAI.BT.InfPosGist.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfPosGist).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.InfPosGist
{
	New (aId)
	Quit:'##class(DHCHAI.BT.InfPosGist).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.InfPosGist).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2018-01-04
/// Description:  更新感染诊断诊断依据信息
/// Table：       DHCHAI.BT.InfPosGist
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfPosGist).Update("^2^1^CODE1^测试1^","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set InfPosDr  = $p(aInputStr,aSeparete,2)
	Set TypeDr    = $p(aInputStr,aSeparete,3)
	Set Code      = $p(aInputStr,aSeparete,4)
	Set Desc      = $p(aInputStr,aSeparete,5)
	Set ActDate   = $p(aInputStr,aSeparete,6)
	Set ActTime   = $p(aInputStr,aSeparete,7)
	Set ActUserDr = $p(aInputStr,aSeparete,8)
	Quit:(InfPosDr="")||(TypeDr="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.BT.InfPosGistI("IdxofInfPosDr",InfPosDr," "_$zcvt(Desc,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objInfPos=##class(DHCHAI.BT.InfPos).GetObjById(InfPosDr)
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(TypeDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.InfPosGist).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.InfPosGist).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	Set obj.BTInfPosDr  = objInfPos
	Set obj.BTTypeDr    = objType
	Set obj.BTCode      = Code
	Set obj.BTDesc      = Desc
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

/// Creator：     pylian
/// CreatDate：   2018-01-04
/// Description:  删除感染诊断诊断依据信息
/// Table：       DHCHAI.BT.InfPosGist
/// Input：       aId : DHCHAI.BT.InfPosGist.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfPosGist).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.InfPosGist")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.BT.InfPosGist).%DeleteId(aId)
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
<Data name="InfPosGistDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTInfPosDr</Value>
</Value>
<Value name="3">
<Value>BTTypeDr</Value>
</Value>
<Value name="4">
<Value>BTCode</Value>
</Value>
<Value name="5">
<Value>BTDesc</Value>
</Value>
<Value name="6">
<Value>BTActDate</Value>
</Value>
<Value name="7">
<Value>BTActTime</Value>
</Value>
<Value name="8">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.InfPosGistD</DataLocation>
<DefaultData>InfPosGistDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.InfPosGistD</IdLocation>
<IndexLocation>^DHCHAI.BT.InfPosGistI</IndexLocation>
<StreamLocation>^DHCHAI.BT.InfPosGistS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
