/// 名称: DHCMed.NINF.Rep.AimAdmTrans
/// 描述: 目标性监测 科室住院记录
/// 编写者：zhufei
/// 编写日期: 2012-06-16
Class DHCMed.NINF.Rep.AimAdmTrans Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 科室住院记录明细
Relationship ChildDay As DHCMed.NINF.Rep.AimAdmTransDay [ Cardinality = children, Inverse = ParRef ];

/// EpisodeID 指向Pa_Adm
Property EpisodeID As %String(TRUNCATE = 1) [ Required ];

/// 最新记录 指向PA_AdmTransaction
Property TransID As %String;

/// 转入科室 指向CT_Loc
Property TransLoc As %String(TRUNCATE = 1) [ Required ];

/// 转入日期
Property TransInDate As %Date;

/// 转出日期
Property TransOutDate As %Date;

/// 转科类型
Property TransType As %String(TRUNCATE = 1) [ Required ];

/// 完成标志
Property IsFinish As %String(TRUNCATE = 1) [ Required ];

/// 关联记录 指向DHCMed.NINF.Rep.AimAdmTrans
Property LinkID As %String(TRUNCATE = 1);

/// 完成标记索引
Index IndexNoFinishAdm On (TransType As Exact, IsFinish As Exact, EpisodeID As Exact);

/// 时间科室索引
Index IndexInDateLoc On (TransInDate As Exact, TransLoc As Exact, EpisodeID As Exact);

Index IndexOutDateLoc On (TransOutDate As Exact, TransLoc As Exact, EpisodeID As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  取目标性监测 科室住院记录
/// Table：       DHCMed.NINF.Rep.AimAdmTrans
/// Input：       DHCMed.NINF.Rep.AimAdmTrans.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimAdmTrans).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.AimAdmTrans
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.AimAdmTrans).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  更新目标性监测 科室住院记录
/// Table：       DHCMed.NINF.Rep.AimAdmTrans
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimAdmTrans).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Rep.AimAdmTrans).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.AimAdmTrans).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeID=$p(aInput,aSeparate,2)
	Set obj.TransID=$p(aInput,aSeparate,3)
	Set obj.TransLoc=$p(aInput,aSeparate,4)
	Set obj.TransInDate=$p(aInput,aSeparate,5)
	Set obj.TransOutDate=$p(aInput,aSeparate,6)
	Set obj.TransType=$p(aInput,aSeparate,7)
	Set obj.IsFinish=$p(aInput,aSeparate,8)
	Set obj.LinkID=$p(aInput,aSeparate,9)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  删除目标性监测 科室住院记录
/// Table：       DHCMed.NINF.Rep.AimAdmTrans
/// Input：       DHCMed.NINF.Rep.AimAdmTrans.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.AimAdmTrans).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>TransID</Value>
</Value>
<Value name="4">
<Value>TransLoc</Value>
</Value>
<Value name="5">
<Value>TransInDate</Value>
</Value>
<Value name="6">
<Value>TransOutDate</Value>
</Value>
<Value name="7">
<Value>TransType</Value>
</Value>
<Value name="8">
<Value>IsFinish</Value>
</Value>
<Value name="9">
<Value>LinkID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("AimTrans")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("AimTrans")</IdLocation>
<IndexLocation>^DHCMed.NINFi("AimTrans",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.AimAdmTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
