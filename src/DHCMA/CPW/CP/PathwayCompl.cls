/// 名称: DHCMA.CPW.CP.PathwayCompl
/// 描述: 临床路径 合并症（并发症）
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.CP.PathwayCompl Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.CP.Pathway [ Cardinality = parent, Inverse = ChildCompl ];

/// 合并症（并发症）表单指针
Property CPComplFormDr As DHCMA.CPW.BT.PathForm;

/// 合并症（并发症）病种指针(合并症功能修改后此字段已无用20230421)
Property CPComplDr As DHCMA.CPW.BT.PathCompl;

/// 是否有效
Property CPIsActive As %Boolean;

/// 处置日期
Property CPActDate As %Date;

/// 处置时间
Property CPActTime As %Time;

/// 处置人ID（指向DHCMA.Util.EP.SSUser.OID）
Property CPActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofCompl On CPComplDr As Exact;

Index IdxofParrefCForm On (Parref, CPComplFormDr As Exact);

Index IdxofDateTime On (Parref, CPActDate, CPActTime);

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.PathwayCompl
/// Input：       aId : DHCMA.CPW.CP.PathwayCompl.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PathwayCompl
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PathwayCompl).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PathwayCompl).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator: 	  yankai
/// CreatDate：   2021-05-27
/// Description:  根据出入径记录及合并症表单ID获取关联合并症记录
/// Table：       DHCMA.CPW.CP.PathwayCompl
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayCompl).GetObjByParAndForm("14","57")
ClassMethod GetObjByParAndForm(aParrefID As %String, aComplFormID As %String) As DHCMA.CPW.CP.PathwayCompl
{
	New (aParrefID,aComplFormID)
	Set return=""
	Quit:(aParrefID="")||(aComplFormID="")
	
	Set subID = $o(^DHCMA.CPW.CP.PathwayI("COMPL","IdxofParrefCForm",aParrefID,aComplFormID,""),-1)
	Set obj = ##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(aParrefID_"||"_subID)
	Set:$IsObject(obj) return=obj
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2021-05-19
/// Description:  更新数据
/// Table：       DHCMA.CPW.CP.PathwayCompl
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayCompl).Update("14^^57^4^10209!!1^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" -1
	
	Set Parref=$p(aInputStr,aSeparete,1)
	Set ChildID=$p(aInputStr,aSeparete,2)
	Set ComplFormID=$p(aInputStr,aSeparete,3)
	Set ComplID=$p(aInputStr,aSeparete,4)
	Set objCompl=##class(DHCMA.CPW.BT.PathCompl).GetObjById(ComplID)
	Set ActUserID=$p(aInputStr,aSeparete,5)
	Set IsActive=$p(aInputStr,aSeparete,6)
	Set:IsActive="" IsActive=1
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	
	Set objParref=##class(DHCMA.CPW.CP.Pathway).GetObjById(Parref)
	Quit:'$IsObject(objParref) -2
	
	Set objComplForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(ComplFormID)
	Quit:'$IsObject(objComplForm) -3
	
	If ChildID="" {
		Set obj=##class(DHCMA.CPW.CP.PathwayCompl).GetObjByParAndForm(Parref,ComplFormID)
		Set:'$IsObject(obj) obj=##class(DHCMA.CPW.CP.PathwayCompl).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PathwayCompl).%OpenId(Parref_"||"_ChildID)
	}
	Quit:'$IsObject(obj) -4
	
	Set obj.Parref = objParref
	Set obj.CPComplFormDr = objComplForm
	Set obj.CPComplDr = objCompl	
	Set obj.CPIsActive=IsActive
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-5
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  作废数据
/// Table：       DHCMA.CPW.CP.PathwayCompl
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayCompl).Invalid(1||1)
ClassMethod Invalid(aID As %String, aUserID As %String) As %String
{
	New (aID,aUserID)
	Set return=""
	Quit:aID="" return
	
	Set obj=##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(aID)
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
<Data name="PathwayComplDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPComplFormDr</Value>
</Value>
<Value name="3">
<Value>CPComplDr</Value>
</Value>
<Value name="4">
<Value>CPIsActive</Value>
</Value>
<Value name="5">
<Value>CPActDate</Value>
</Value>
<Value name="6">
<Value>CPActTime</Value>
</Value>
<Value name="7">
<Value>CPActUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("COMPL")</DataLocation>
<DefaultData>PathwayComplDefaultData</DefaultData>
<IdLocation>{%%PARENT}("COMPL")</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayI("COMPL")</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayComplS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
