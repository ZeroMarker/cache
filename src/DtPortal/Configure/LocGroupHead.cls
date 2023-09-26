/// ClassName:    DtPortal.Configure.LocGroupHead
/// TableName:	  DtPortal_Configure.LocGroupHead
/// Description:  大科室科主任维护
/// Creator：     chengpeng
/// CreatDate:    2016-10-20
Class DtPortal.Configure.LocGroupHead Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DtPortal.Configure.LocGroup [ Cardinality = parent, Inverse = ChildLogHead ];

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
/// Description:  大科室科主任维护对象
/// Table：       DtPortal_Configure.LocGroupHead
/// Input：       DtPortal.Configure.LocGroupHead.ID
/// Return：      返回obj
/// w ##class(DtPortal.Configure.LocGroupHead).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DtPortal.Configure.LocGroupHead
{
	New (aId)
	Set obj=##Class(DtPortal.Configure.LocGroupHead).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chengpeng
/// CreatDate：   2016-10-20
/// Description:  更新大科室科主任维护记录
/// Table：       DtPortal_Configure.LocGroupHead
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.LocGroupHead).Update("1^^2^N")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	Set HeadID=$p(aInput,aSeparate,3)
	Set Flag=$p(aInput,aSeparate,4)
	
	set ID=ParRef_"||"_ChildSub

	If (ChildSub="") {
		Set obj=##class(DtPortal.Configure.LocGroupHead).%New()
	} Else {
		Set obj=##class(DtPortal.Configure.LocGroupHead).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DtPortal.Configure.LocGroup).GetObjById(ParRef)
	Set obj.LocGroupDocHead  =##Class(User.SSUser).%OpenId(HeadID)
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
/// w ##Class(DtPortal.Configure.LocGroupHead).DeleteById("1||11")
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DtPortal.Configure.LocGroupHead).%DeleteId(ID)
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
<Data name="LocGroupHeadDefaultData">
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
<DataLocation>{%%PARENT}("HEAD")</DataLocation>
<DefaultData>LocGroupHeadDefaultData</DefaultData>
<IdLocation>{%%PARENT}("HEAD")</IdLocation>
<IndexLocation>^DtPortal.Configure.LocGroupI("HEAD")</IndexLocation>
<StreamLocation>^DtPortal.Configure.LocGroupHeadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
