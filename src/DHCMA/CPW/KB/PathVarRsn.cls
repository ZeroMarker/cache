/// 名称: DHCMA.CPW.KB.PathVarRsn
/// 描述: 变异描述分析
/// 编写者：yankai
/// 编写日期: 2022-05-12
Class DHCMA.CPW.KB.PathVarRsn Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 路径字典库
Relationship Parref As DHCMA.CPW.KB.PathBase [ Cardinality = parent, Inverse = ChildVarRsn ];

/// 序号
Property PVNum As %String [ Required ];

/// 描述
Property PVDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

Index IdxofPar On Parref;

Index IdxofIndNo On (Parref, PVNum);

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  根据ID取变异分析信息
/// Table：       DHCMA.CPW.KB.PathVarRsn
/// Input：       aId :  DHCMA.CPW.KB.PathVarRsn.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.KB.PathVarRsn).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.KB.PathVarRsn
{
	New (aId)
	Quit:'##class(DHCMA.CPW.KB.PathVarRsn).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.KB.PathVarRsn).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  更新变异分析信息
/// Table：       DHCMA.CPW.KB.PathVarRsn
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathVarRsn).Update("39^1^出现发热等感染情况，可能影响化验结果，需待体温正常以后才能进行上述检查")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=-1
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref			= $p(aInputStr,aSeparete,1)
	Set objParref		= ##class(DHCMA.CPW.KB.PathBase).GetObjById(Parref)
	Quit:'$IsObject(objParref) -1
	Set ChildSub     	= $p(aInputStr,aSeparete,2)  
	Set VarNum     		= $p(aInputStr,aSeparete,3)
	Set VarDesc    		= $p(aInputStr,aSeparete,4)
	if ($d(^CT.MA.CPW.KB.PathBaseI("VAR","IdxofIndNo",Parref," "_VarNum))){
		Set ChildSub=$o(^CT.MA.CPW.KB.PathBaseI("VAR","IdxofIndNo",Parref," "_VarNum,""),-1)
	}
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.KB.PathVarRsn).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.KB.PathVarRsn).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref    	= objParref      //写入数据
	Set obj.PVNum    	= VarNum
	Set obj.PVDesc		= VarDesc
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

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  删除变异分析描述
/// Table：       DHCMA.CPW.KB.PathVarRsn
/// Input：       aId : DHCMA.CPW.KB.PathVarRsn.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathVarRsn).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.KB.PathMast")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.KB.PathVarRsn).%DeleteId(aId)
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
<Data name="VarResonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PVNum</Value>
</Value>
<Value name="3">
<Value>PVDesc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("VAR")</DataLocation>
<DefaultData>VarResonDefaultData</DefaultData>
<IdLocation>{%%PARENT}("VAR")</IdLocation>
<IndexLocation>^CT.MA.CPW.KB.PathBaseI("VAR")</IndexLocation>
<StreamLocation>^CT.MA.CPW.KB.PathVarRsnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
