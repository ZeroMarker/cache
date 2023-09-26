/// 名称: DHCHAI.IR.CRuleInfSuRule
/// 描述: 医院感染疑似筛查规则
/// 编写者：zhufei
/// 编写日期: 2019-05-30
Class DHCHAI.IR.CRuleInfSuRule Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目表达式
Relationship ChildExp As DHCHAI.IR.CRuleInfSuRuleExp [ Cardinality = children, Inverse = Parref ];

/// 规则编号（年月日+3位流水号）
Property BTRuleNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 疑似筛查项目
Property BTItmScreenDr As DHCHAI.IR.CCItmScreen [ Required ];

/// 疑似诊断（部位）
Property BTSuPosDr As DHCHAI.BT.InfSuPos;

/// 规则定义（A无菌部位标本检出菌、B清洁标本培养阳性、C血培养检出菌、...）
Property BTRuleType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 规则说明
Property BTRuleNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// add 2022-05-06 阈值（总分）
Property BTThreshold As %String;

Index IdxofItmScreenDr On BTItmScreenDr;

Index IdxofRuleType On BTRuleType;

Index IdxofRuleNo On BTRuleNo [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2019-05-30
/// Description:  根据ID取疑似筛查规则
/// Table：       DHCHAI.IR.CRuleInfSuRule
/// Input：       aId : DHCHAI.IR.CRuleInfSuRule.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleInfSuRule
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleInfSuRule).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleInfSuRule).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2022-03-14
/// Description:  更新医院感染疑似筛查规则
/// Table：       DHCHAI.IR.CRuleInfSuRule
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleInfSuRule).Update("1^20190621001^检出致病菌^^A^无菌部位标本检出菌^1^^^","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        	= $p(aInputStr,aSeparete,1)
	Set RuleNo   	= $p(aInputStr,aSeparete,2)
	Set ItmScreenDr = $p(aInputStr,aSeparete,3)
	Set SuPosDr  	= $p(aInputStr,aSeparete,4)
	Set RuleType 	= $p(aInputStr,aSeparete,5)
	Set RuleNote 	= $p(aInputStr,aSeparete,6)
	Set IsActive    = +$p(aInputStr,aSeparete,7)
	Set ActDate	    = $p(aInputStr,aSeparete,8)
	Set ActTime	    = $p(aInputStr,aSeparete,9)
	Set ActUserDr   = $p(aInputStr,aSeparete,10)
	Set Threshold   = $p(aInputStr,aSeparete,11)	
	Quit:(RuleNo="")||(ItmScreenDr="") return
	
	Set objItmScreen=##class(DHCHAI.IR.CCItmScreen).GetObjById(ItmScreenDr)
	Quit:'$IsObject(objItmScreen) return
	Set objSuPos=##class(DHCHAI.BT.InfSuPos).GetObjById(SuPosDr)

	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h   //当前日期
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set tID=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleNo"," "_RuleNo,0))
	Quit:(tID'="")&(ID'=tID) -2
		
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleInfSuRule).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleInfSuRule).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTRuleNo   	  = RuleNo   	
	Set obj.BTItmScreenDr = objItmScreen
	Set obj.BTSuPosDr  	  = objSuPos  	
	Set obj.BTRuleType 	  = RuleType 	
	Set obj.BTRuleNote 	  = RuleNote 	
	Set obj.BTIsActive    = IsActive   
	Set obj.BTActDate	  = ActDate	   
	Set obj.BTActTime	  = ActTime	   
	Set obj.BTActUserDr   = objActUser  
	Set obj.BTThreshold	  = Threshold
	
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
/// CreatDate：   2022-03-14
/// Description:  删除医院感染疑似筛查规则
/// Table：       DHCHAI.IR.CRuleInfSuRule
/// Input：       aId : DHCHAI.IR.CRuleInfSuRule.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleInfSuRule).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleInfSuRule).%DeleteId(aId)
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
<Data name="CRuleInfSuRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTRuleNo</Value>
</Value>
<Value name="3">
<Value>BTItmScreenDr</Value>
</Value>
<Value name="4">
<Value>BTSuPosDr</Value>
</Value>
<Value name="5">
<Value>BTRuleType</Value>
</Value>
<Value name="6">
<Value>BTRuleNote</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUserDr</Value>
</Value>
<Value name="11">
<Value>BTThreshold</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleInfSuRuleD</DataLocation>
<DefaultData>CRuleInfSuRuleDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleInfSuRuleD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleInfSuRuleI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleInfSuRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
