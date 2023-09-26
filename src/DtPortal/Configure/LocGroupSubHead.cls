/// ClassName:    DtPortal.Configure.LocGroupSubHead
/// TableName:	  DtPortal_Configure.LocGroupSubHead
/// Description:  科室组项目主任维护（科室组项目中维护科室，如果是住院科室可以维护病区主任）
/// Creator：     chengpeng
/// CreatDate:    2016-12-12
Class DtPortal.Configure.LocGroupSubHead Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DtPortal.Configure.LocGroupSub [ Cardinality = parent, Inverse = ChildHeadLog ];

/// 科主任id
Property LocGroupDocHead As User.SSUser;

/// 区分正副科主任 (正:Y;  副:N)
Property LocGroupHeadFlag As %String(TRUNCATE = 1);

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 索引：科主任索引
Index IndexDocHead On LocGroupDocHead;

/// Creator：     chengpeng
/// CreatDate：   2016-10-20
/// Description:  病区主任维护对象
/// Table：       DtPortal_Configure.LocGroupHead
/// Input：       DtPortal.Configure.LocGroupHead.ID
/// Return：      返回obj
/// w ##class(DtPortal.Configure.LocGroupSubHead).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SPE.Patients
{
	New (aId)
	Set obj=##Class(DtPortal.Configure.LocGroupSubHead).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chengpeng
/// CreatDate：   2016-10-20
/// Description:  更新大科室科主任维护记录
/// Table：       DtPortal_Configure.LocGroupHead
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.LocGroupSubHead).Update("2^1^^5^N")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set logID=$p(aInput,aSeparate,2)
	Set HeadSubID=$p(aInput,aSeparate,3)
	Set DocHeadID=$p(aInput,aSeparate,4)
	Set Flag=$p(aInput,aSeparate,5)
	

	If (HeadSubID="") {
		Set obj=##class(DtPortal.Configure.LocGroupSubHead).%New()
	} Else {
		Set obj=##class(DtPortal.Configure.LocGroupSubHead).%OpenId(ParRef_"||"_logID_"||"_HeadSubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DtPortal.Configure.LocGroupSub).GetObjById(ParRef_"||"_logID)
	Set obj.LocGroupDocHead  =##Class(User.SSUser).%OpenId(DocHeadID)
	Set obj.LocGroupHeadFlag   =Flag
	Set obj.UpdateDate     = $p($h,",",1)
	Set obj.UpdateTime     = $p($h,",",2)
	
	
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

/// Creator：     chengpeng
/// CreatDate：   2016-10-20
/// Description:  删除大科室科主任维护记录
/// Table：       DtPortal_Configure.LocGroupHead
/// Input：       DtPortal.Configure.LocGroupHead.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.LocGroupSubHead).DeleteById("1||11")
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DtPortal.Configure.LocGroupSubHead).%DeleteId(ID)
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
<Data name="LocGroupSubHeadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocGroupDocHead</Value>
</Value>
<Value name="3">
<Value>LocGroupHeadFlag</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
<Value name="5">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SUBHEAD")</DataLocation>
<DefaultData>LocGroupSubHeadDefaultData</DefaultData>
<IdLocation>{%%PARENT}("SUBHEAD")</IdLocation>
<IndexLocation>^DtPortal.Configure.LocGroupI("SUBHEAD")</IndexLocation>
<StreamLocation>^DtPortal.Configure.LocGroupSubHeadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
