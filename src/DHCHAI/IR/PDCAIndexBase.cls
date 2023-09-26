/// 名称: DHCHAI.IR.PDCAIndexBase
/// 描述: PDCA指标库
/// 编写者：ShenC
/// 编写日期: 2022-06-28
Class DHCHAI.IR.PDCAIndexBase Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 指标代码
Property PAIndexCode As %String [ Required ];

/// 指标名称
Property PAIndexDesc As %String [ Required ];

/// 指标分类[暂未启用]
Property PAIndexType As %String(MAXLEN = 500, TRUNCATE = 1);

/// 标准值
Property PAKPA As %String;

/// 报表名称
Property PALinkRep As %String [ Required ];

/// 报表路径
Property PALinkRepPath As %String [ Required ];

/// 报表参数
Property PALinkParm As %String(MAXLEN = 500, TRUNCATE = 1);

/// 关联csp
Property PALinkCsp As %String(MAXLEN = 500, TRUNCATE = 1);

/// 是否有效
Property PAIsActive As %Boolean;

/// 索引-指标代码
Index IndexCode On PAIndexCode As Exact;

/// 索引-指标名称
Index IndexDesc On PAIndexDesc As Exact;

/// Creator：     ShenC
/// CreatDate：   2022-06-28
/// Description:  根据ID取PDCA指标库
/// Table：       DHCHAI.IR.PDCAIndexBase
/// Input：       aID : DHCHAI.IR.PDCAIndexBase.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCAIndexBase).GetObjById(1)
ClassMethod GetObjById(aID As %String) As DHCHAI.IR.PDCAIndexBase
{
	New (aID)
	Quit:'##class(DHCHAI.IR.PDCAIndexBase).%ExistsId(aID) ""
	Set obj=##Class(DHCHAI.IR.PDCAIndexBase).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2022-06-28
/// Description:  更新PDCA指标库
/// Table：       DHCHAI.IR.PDCAIndexBase
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCAIndexBase).Update("^BfCureSubRatio^抗菌药物治疗前送检率^住院患者抗菌药物送检率统计表^DHCMA.HAI.STATV2.S170AntTheSub.raq^^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID				= $p(aInputStr,aSeparete,1)
	Set IndexCode		= $p(aInputStr,aSeparete,2)
	Set IndexDesc		= $p(aInputStr,aSeparete,3)
	Set IndexType		= $p(aInputStr,aSeparete,4)
	Set KPA				= $p(aInputStr,aSeparete,5)
	Set LinkRep			= $p(aInputStr,aSeparete,6)
	Set LinkRepPath		= $p(aInputStr,aSeparete,7)
	Set LinkParm		= $p(aInputStr,aSeparete,8)
	Set LinkCsp			= $p(aInputStr,aSeparete,9)
	Set IsActive		= +$p(aInputStr,aSeparete,10)

	//'指标代码'+'指标名称'+'报表名称'+'报表路径'+'关联csp'不能为空
	Quit:(IndexCode="")||(IndexDesc="")||(LinkRep="")||(LinkRepPath="")||(LinkCsp="") return
	//'指标代码'唯一
	Set tID=$o(^CT.MA.HAI.IR.PDCAIndexBaseI("IndexCode",IndexCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	//'指标名称'唯一
	Set tID=$o(^CT.MA.HAI.IR.PDCAIndexBaseI("IndexDesc",IndexDesc,0))
	Quit:(tID'="")&(ID'=tID) -3
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.PDCAIndexBase).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.PDCAIndexBase).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PAIndexCode		= IndexCode
	Set obj.PAIndexDesc 	= IndexDesc
	Set obj.PAIndexType 	= IndexType
	Set obj.PAKPA 			= KPA
	Set obj.PALinkRep	    = LinkRep
	Set obj.PALinkRepPath	= LinkRepPath
	Set obj.PALinkParm	    = LinkParm
	Set obj.PALinkCsp		= LinkCsp
	Set obj.PAIsActive 		= IsActive
	
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

/// Creator：     ShenC
/// CreatDate：   2022-10-10
/// Description:  删除PDCA指标库
/// Table：       DHCHAI.IR.PDCAIndexBase
/// Input：       aId : DHCHAI.IR.PDCAIndexBase.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCAIndexBase).DeleteById(1)
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set sc = ##class(DHCHAI.IR.PDCAIndexBase).%DeleteId(aID)
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
<Data name="PDCAIndexBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAIndexCode</Value>
</Value>
<Value name="3">
<Value>PAIndexDesc</Value>
</Value>
<Value name="4">
<Value>PAIndexType</Value>
</Value>
<Value name="5">
<Value>PAKPA</Value>
</Value>
<Value name="6">
<Value>PALinkRep</Value>
</Value>
<Value name="7">
<Value>PALinkRepPath</Value>
</Value>
<Value name="8">
<Value>PALinkParm</Value>
</Value>
<Value name="9">
<Value>PALinkCsp</Value>
</Value>
<Value name="10">
<Value>PAIsActive</Value>
</Value>
</Data>
<DataLocation>^CT.MA.HAI.IR.PDCAIndexBaseD</DataLocation>
<DefaultData>PDCAIndexBaseDefaultData</DefaultData>
<IdLocation>^CT.MA.HAI.IR.PDCAIndexBaseD</IdLocation>
<IndexLocation>^CT.MA.HAI.IR.PDCAIndexBaseI</IndexLocation>
<StreamLocation>^CT.MA.HAI.IR.PDCAIndexBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
