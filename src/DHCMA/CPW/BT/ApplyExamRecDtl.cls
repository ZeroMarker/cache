/// 名称: DHCMA.CPW.BT.ApplyExamRecDtl
/// 描述: 表单审核记录明细类
/// 编写者：yankai
/// 编写日期: 2021-11-26
Class DHCMA.CPW.BT.ApplyExamRecDtl Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 申请记录
Relationship Parref As DHCMA.CPW.BT.ApplyExamRec [ Cardinality = parent, Inverse = ChildDtl ];

/// 审核角色
Property BTExamRoleDr As DHCMA.CPW.BT.PathExamRole [ Required ];

/// 申请表单指针
Property BTExamFormDr As DHCMA.CPW.BT.PathForm;

/// 当前审核是否通过(1:通过，0未通过，-1：待审核)
Property BTExamResult As %String;

/// 审核意见
Property BTExamOpinion As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 审核人（指向DHCMA.Util.EP.SSUser.OID）
Property BTExamUser As %String(MAXLEN = 50, TRUNCATE = 1);

/// 审核日期
Property BTExamDate As %Date;

/// 审核时间
Property BTExamTime As %Time;

Index IdxofFormRole On (BTExamFormDr, BTExamRoleDr);

/// Creator：     yankai
/// CreatDate：   2021-11-26
/// Description:  获取对象
/// Table：       DHCMA.CPW.BT.ApplyExamRecDtl
/// Input：       aId :  DHCMA.CPW.BT.ApplyExamRecDtl.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.ApplyExamRecDtl).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.ApplyExamRecDtl
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.ApplyExamRecDtl).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.ApplyExamRecDtl).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2021-11-26
/// Description:  更新信息
/// Table：       DHCMA.CPW.BT.ApplyExamRecDtl
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.ApplyExamRecDtl).Update("^003^测试3^1^U^1^1")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set Parref       	= $p(aInputStr,aSeparete,1)		//Parref
	Set ChildSub		= $p(aInputStr,aSeparete,2)		//subID
	Set ExamRoleDr		= $p(aInputStr,aSeparete,3)		//审核角色
	Set ExamResult     	= $p(aInputStr,aSeparete,4)		//是否通过
	Set:ExamResult="" ExamResult=-1
	Set ExamOpinion		= $p(aInputStr,aSeparete,5)		//审核意见
	Set ExamUser		= $p(aInputStr,aSeparete,6)		//审核人
	Set ExamDate		= $p(aInputStr,aSeparete,7)		//审核日期
	Set:(ExamResult'=-1)&&(ExamDate="") ExamDate=+$h
	Set ExamTime		= $p(aInputStr,aSeparete,8)		//审核时间
	Set:(ExamResult'=-1)&&(ExamTime="") ExamTime=$p($h,",",2)
	Set ExamFormDr		= $p(aInputStr,aSeparete,9)		//审核时间
	
	Set objParref=##class(DHCMA.CPW.BT.ApplyExamRec).GetObjById(Parref)
	Quit:'$IsObject(objParref) -2
	Set objExamRole=##class(DHCMA.CPW.BT.PathExamRole).GetObjById(ExamRoleDr)
	Quit:'$IsObject(objExamRole) -3
	Set objExamForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(ExamFormDr)
	Quit:'$IsObject(objExamForm) -4
	
	
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.BT.ApplyExamRecDtl).%New()
	}Else{
		Set ID=Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.BT.ApplyExamRecDtl).%OpenId(ID)
	}
	Quit:'$IsObject(obj) -4
	
	Set obj.Parref			= objParref
	Set obj.BTExamRoleDr	= objExamRole
	Set obj.BTExamResult	= ExamResult
	Set obj.BTExamOpinion	= ExamOpinion
	Set obj.BTExamUser		= ExamUser
	Set obj.BTExamDate		= ExamDate
	Set obj.BTExamTime		= ExamTime
	Set obj.BTExamFormDr	= objExamForm
	
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
/// CreatDate：   2021-11-26
/// Description:  删除审核角色
/// Table：       DHCMA.CPW.BT.ApplyExamRecDtl
/// Input：       aId :  DHCMA.CPW.BT.ApplyExamRecDtl.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.ApplyExamRecDtl).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.ApplyExamRecDtl")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.BT.ApplyExamRecDtl).%DeleteId(aId)
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
<Data name="ApplyExamRecDtlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTExamRoleDr</Value>
</Value>
<Value name="3">
<Value>BTExamResult</Value>
</Value>
<Value name="4">
<Value>BTExamOpinion</Value>
</Value>
<Value name="5">
<Value>BTExamUser</Value>
</Value>
<Value name="6">
<Value>BTExamDate</Value>
</Value>
<Value name="7">
<Value>BTExamTime</Value>
</Value>
<Value name="8">
<Value>BTExamFormDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DTL")</DataLocation>
<DefaultData>ApplyExamRecDtlDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DTL")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.ApplyExamRecI("DTL")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.ApplyExamRecDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
