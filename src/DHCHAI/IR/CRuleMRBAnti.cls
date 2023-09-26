/// 名称: DHCHAI.IR.CRuleMRBAnti
/// 描述: 多重耐药菌-抗生素维护
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.IR.CRuleMRBAnti Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CRuleMRB [ Cardinality = parent, Inverse = ChildAnti ];

/// 抗生素分类
Property BTAntiCatDr As DHCHAI.DP.LabAntiCat [ Required ];

/// 抗生素
Property BTAntiDr As DHCHAI.DP.LabAntibiotic;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 索引 抗生素分类
Index IndexAntiCat On BTAntiCatDr;

/// 索引 抗生素
Index IndexAnti On BTAntiDr;

/// 索引 抗生素分类
Index IndexAntiCat2 On (Parref, BTAntiCatDr);

/// 索引 抗生素
Index IndexAnti2 On (Parref, BTAntiDr);

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  根据ID取多重耐药菌-抗生素维护信息
/// Table：       DHCHAI.IR.CRuleMRBAnti
/// Input：       aId : DHCHAI.IR.CRuleMRBAnti.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleMRBAnti).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleMRBAnti
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleMRBAnti).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleMRBAnti).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  更新多重耐药菌-抗生素维护信息
/// Table：       DHCHAI.IR.CRuleTSRstFlag
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleMRBAnti).Update("2^^4^^^9","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	 
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete = ..#SEPARATE	
	Set Parref    	= $p(aInputStr,aSeparete,1)
	Set ChildSub  	= $p(aInputStr,aSeparete,2)
	Set AntiCatDr	= $p(aInputStr,aSeparete,3)
	Set AntiDr      = $p(aInputStr,aSeparete,4)
	Set ActDate	  	= $p(aInputStr,aSeparete,5)
	Set ActTime		= $p(aInputStr,aSeparete,6)
	Set ActUserDr 	= $p(aInputStr,aSeparete,7)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)	
	Quit:(Parref="")||(AntiCatDr="") return
		
	Set objParref = ##class(DHCHAI.IR.CRuleMRB).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objAntiCat = ##class(DHCHAI.DP.LabAntiCat).GetObjById(AntiCatDr)
	Quit:'$IsObject(objAntiCat) return
	Set objAnti = ##class(DHCHAI.DP.LabAntibiotic).GetObjById(AntiDr)

	Set objActUser = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	// 抗生素 不能重复  
	Set tChildSub=$o(^DHCHAI.IR.CRuleMRBI("ANT","IndexAntiCat",AntiCatDr,Parref,0))
	if (tChildSub'="")&&(AntiDr'=""){
		Set xChildSub=$o(^DHCHAI.IR.CRuleMRBI("ANT","IndexAnti",AntiDr,Parref,0))
		Quit:(xChildSub'="")&&(xChildSub'=ChildSub) -2
	}
		
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CRuleMRBAnti).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleMRBAnti).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref		= objParref
	Set obj.BTAntiCatDr	= objAntiCat
	Set obj.BTAntiDr	= objAnti
	Set obj.BTActDate	= ActDate	
	Set obj.BTActTime	= ActTime 
	Set obj.BTActUserDr	= objActUser	
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

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  删除多重耐药菌-抗生素维护信息
/// Table：       DHCHAI.IR.CRuleMRBAnti
/// Input：       aId : DHCHAI.IR.CRuleMRBAnti.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleMRBAnti).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleMRBAnti).%DeleteId(aId)
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
<Data name="CRuleMRBAntiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTAntiCatDr</Value>
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
<Value name="6">
<Value>BTAntiDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ANT")</DataLocation>
<DefaultData>CRuleMRBAntiDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ANT")</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleMRBI("ANT")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleMRBAntiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
