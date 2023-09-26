/// 名称: DHCHAI.IR.CRuleTestCode
/// 描述: 常规检验-检验项目维护
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.IR.CRuleTestCode Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CRuleTestAb [ Cardinality = parent, Inverse = ChildTC ];

/// 检验项目
Property BTTestCodeDr As DHCHAI.DP.LabTCMap [ Required ];

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

Index IdxofTestCodeDr On BTTestCodeDr;

Index IdxofTestCodeDr2 On (Parref, BTTestCodeDr);

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  根据ID取常规检验-检验项目维护信息
/// Table：       DHCHAI.IR.CRuleTestCode
/// Input：       aId : DHCHAI.IR.CRuleTestCode.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleTestCode).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleTestCode
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleTestCode).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleTestCode).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  更新常规检验-检验项目维护信息
/// Table：       DHCHAI.IR.CRuleTSRstFlag
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleTestCode).Update("2^^4^^^9","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	 
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete=..#SEPARATE	
	Set Parref    = $p(aInputStr,aSeparete,1)
	Set ChildSub  = $p(aInputStr,aSeparete,2)
	Set TestCodeDr= $p(aInputStr,aSeparete,3)
	Set ActDate	  = $p(aInputStr,aSeparete,4)
	Set ActTime   = $p(aInputStr,aSeparete,5)
	Set ActUserDr = $p(aInputStr,aSeparete,6)
	Quit:(Parref="")||(TestCodeDr="") return
	
    //Quit:(ChildSub="")&&($d(^DHCHAI.IR.CRuleTestAbI("TC","IdxofTestCodeDr",TestCodeDr))) -2	
	//检验项目唯一

	Set tChildSub =$o(^DHCHAI.IR.CRuleTestAbI("TC","IdxofTestCodeDr",TestCodeDr,Parref,0)) 
	Quit:(ChildSub="")&&(tChildSub'="") -2  
	Quit:(ChildSub'="")&(tChildSub'="")&(ChildSub'=tChildSub) -2  
	
	Set objParref=##class(DHCHAI.IR.CRuleTestAb).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Quit:'$IsObject(objActUser) return
	Set objTestCode=##class(DHCHAI.DP.LabTCMap).GetObjById(TestCodeDr)
	Quit:'$IsObject(objTestCode) return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)

	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CRuleTestCode).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleTestCode).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.BTTestCodeDr = objTestCode
	Set obj.BTActDate	 = ActDate	
	Set obj.BTActTime    = ActTime 
	Set obj.BTActUserDr	 = objActUser	
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
/// CreatDate：   2017-05-05
/// Description:  删除常规检验-检验项目维护信息
/// Table：       DHCHAI.IR.CRuleTestCode
/// Input：       aId : DHCHAI.IR.CRuleTestCode.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleTestCode).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleTestCode).%DeleteId(aId)
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
<Data name="CRuleTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTestCodeDr</Value>
</Value>
<Value name="3">
<Value>BTActDate</Value>
</Value>
<Value name="4">
<Value>BTActTime</Value>
</Value>
<Value name="5">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TC")</DataLocation>
<DefaultData>CRuleTestCodeDefaultData</DefaultData>
<IdLocation>{%%PARENT}("TC")</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleTestAbI("TC")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
