/// 名称: DHCMA.CPW.CP.PathwayExec
/// 描述: 临床路径 路径执行（切换路径）
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.CP.PathwayExec Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.CP.Pathway [ Cardinality = parent, Inverse = ChildExec ];

/// 就诊ID（指向DHCMA.CPW.EP.Episode.OID）
Property CPEpisodeID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 原路径指针
Property CPFormDr As DHCMA.CPW.BT.PathForm [ Required ];

/// 原阶段指针
Property CPEpisDr As DHCMA.CPW.CP.PathwayEpis;

/// 切换到路径指针
Property CPToFormDr As DHCMA.CPW.BT.PathForm;

/// 切换到阶段指针
Property CPToEpisDr As DHCMA.CPW.CP.PathwayEpis;

/// 路径切换原因
Property CPExecNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 有效标志
Property CPIsActive As %Boolean;

/// 处置日期
Property CPActDate As %Date;

/// 处置时间
Property CPActTime As %Time;

/// 处置人ID（指向DHCMA.Util.EP.SSUser.OID）
Property CPActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofParRef On Parref;

Index IdxofEpisodeID On CPEpisodeID As Exact;

Index IdxofDateTime On (CPActDate, CPActTime);

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.PathwayExec
/// Input：       aId : DHCMA.CPW.CP.PathwayExec.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayExec).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PathwayExec
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PathwayExec).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PathwayExec).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  更新数据
/// Table：       DHCMA.CPW.CP.PathwayExec
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayExec).Update(1)
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set Parref=$p(aInputStr,aSeparete,1)
	Set ChildID=$p(aInputStr,aSeparete,2)
	Set EpisodeID=$p(aInputStr,aSeparete,3)
	Set FormID=$p(aInputStr,aSeparete,4)
	Set FormEpID=$p(aInputStr,aSeparete,5)
	Set ExecNote=$p(aInputStr,aSeparete,6)
	Set IsActive=1
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	Set ActUserID=$p(aInputStr,aSeparete,7)
	Set ToFormID=$p(aInputStr,aSeparete,8)
	Set ToEpisID=$p(aInputStr,aSeparete,9)
	
	Set objParref=##class(DHCMA.CPW.CP.Pathway).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(FormID)
	Quit:'$IsObject(objForm) return
	Set objFormEp=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(FormEpID)
	Quit:'$IsObject(objFormEp) return
	Set objToForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(ToFormID)
	Quit:'$IsObject(objToForm) return
	Set objToFormEp=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(ToEpisID)
	Quit:'$IsObject(objToFormEp) return
	
	If ChildID="" {
		Set obj=##class(DHCMA.CPW.CP.PathwayExec).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PathwayExec).%OpenId(Parref_"||"_ChildID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.CPEpisodeID=EpisodeID
	Set obj.CPFormDr=objForm
	Set obj.CPEpisDr=objFormEp
	Set obj.CPExecNote=ExecNote
	Set obj.CPIsActive=IsActive
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	Set obj.CPToFormDr=objToForm
	Set obj.CPToEpisDr=objToFormEp
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  作废数据
/// Table：       DHCMA.CPW.CP.PathwayExec
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayExec).Invalid(1||1)
ClassMethod Invalid(aID As %String, aUserID As %String) As %String
{
	New (aID,aUserID)
	Set return=""
	Quit:aID="" return
	
	Set obj=##class(DHCMA.CPW.CP.PathwayExec).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPIsActive=0
	Set obj.CPActDate=+$H
	Set obj.CPActTime=$p($H,",",2)
	Set obj.CPActUserID=aUserID
	
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

Storage Default
{
<Data name="PathwayExecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPEpisodeID</Value>
</Value>
<Value name="3">
<Value>CPFormDr</Value>
</Value>
<Value name="4">
<Value>CPEpisDr</Value>
</Value>
<Value name="5">
<Value>CPExecNote</Value>
</Value>
<Value name="6">
<Value>CPIsActive</Value>
</Value>
<Value name="7">
<Value>CPActDate</Value>
</Value>
<Value name="8">
<Value>CPActTime</Value>
</Value>
<Value name="9">
<Value>CPActUserID</Value>
</Value>
<Value name="10">
<Value>CPToFormDr</Value>
</Value>
<Value name="11">
<Value>CPToEpisDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXEC")</DataLocation>
<DefaultData>PathwayExecDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXEC")</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayI("EXEC")</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayExecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
