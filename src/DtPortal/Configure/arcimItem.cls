Class DtPortal.Configure.arcimItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DtPortal.Configure.arcim [ Cardinality = parent, Inverse = ChildItem ];

/// 医嘱项指针
Property ItmMastObj As User.ARCItmMast;

/// 非关联医嘱配置
Property ItmOtherText As %String;

/// 更新日期
Property ItemUpdate As %Date;

/// 更新时间
Property ItemUpTime As %Time;

// 医嘱索引

Index IndexItmMastID On ItmMastObj;

/// Creator：     chengpeng
/// CreatDate：   2016-09-13
/// Description:  取医嘱配置项目
/// Table：       DtPortal_Configure.arcim
/// Return：      返回obj
/// w ##class(DtPortal.Configure.arcimItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DtPortal.Configure.arcim
{
	New (aId)
	Set obj=##Class(DtPortal.Configure.arcimItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chengpeng
/// CreatDate：   2016-08-05
/// Description:  更新医嘱项配置
/// Table：       DtPortal_Configure.arcimItem
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.arcimItem).Update("1^^^66","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	set ^cheng("aInput")=aInput
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	Set ItmMastID=$p(aInput,aSeparate,3)
	Set OtherText =$p(aInput,aSeparate,4)
	set ID=ParRef_"||"_ChildSub
	
	if ItmMastID'=""
	{
		set checkID=$o(^DtPortal.Configure.ArcimI("Item","IndexItmMastID",ItmMastID,ParRef,""))
		quit:checkID'="" 0
	}

	
	If (ChildSub="") {
		Set obj=##class(DtPortal.Configure.arcimItem).%New()
	} Else {
		Set obj=##class(DtPortal.Configure.arcimItem).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) -1
	
	Set obj.ParRef=##class(DtPortal.Configure.arcim).GetObjById(ParRef)
	Set:ItmMastID'="" obj.ItmMastObj  =##Class(User.ARCItmMast).%OpenId(ItmMastID)
	Set obj.ItmOtherText  =OtherText
	Set obj.ItemUpdate     = $p($h,",",1)
	Set obj.ItemUpTime     = $p($h,",",2)
	
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=1
	}
	Do obj.%Close()
		
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-08-05
/// Description:  查询医嘱项信息
/// Table：       DtPortal_Configure.arcimItem
/// w ##Class(DtPortal.Configure.arcimItem).qureyArcimItem(,,4)
ClassMethod qureyArcimItem(page = 1, rows = 10, arcimID As %String) As %String
{
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 w "{""rows"":["
	 
	 set arcimSubID=""
	 for
	 {
		 set arcimSubID=$o(^DtPortal.Configure.ArcimD(arcimID,"Item",arcimSubID))
		 quit:arcimSubID=""
		 
		 Set arcimSubIDObj=##class(DtPortal.Configure.arcimItem).%OpenId(arcimID_"||"_arcimSubID)
		 continue:'$IsObject(arcimSubIDObj)
		 
		 set count=count+1
		 continue:count<start
		 continue:count>end
		 set ItmMastID="",ItmMastCode="",ItmMastDesc="",ItmOtherText=""
		 if arcimSubIDObj.ItmMastObj'=""
		 {
			set ItmMastID=arcimSubIDObj.ItmMastObj.%Id()
		 	set ItmMastCode=arcimSubIDObj.ItmMastObj.ARCIMCode
		 	set ItmMastDesc=arcimSubIDObj.ItmMastObj.ARCIMDesc
		 }
		
		 set ItmOtherText=arcimSubIDObj.ItmOtherText
	
		 w $case(count,start:"",:",")
		 w "{"
		 w """ID"":"_""""_arcimID_"||"_arcimSubID_""""_","
		 w """arcimID"":"_""""_arcimID_""""_","
		 w """arcimSubID"":"_""""_arcimSubID_""""_","
		 w """ItmMastID"":"_""""_ItmMastID_""""_","
		 w """ItmMastCode"":"_""""_ItmMastCode_""""_","
		 w """ItmOtherText"":"_""""_ItmOtherText_""""_","
		 w """ItmMastDesc"":"_""""_ItmMastDesc_""""
		 w "}" 
		 
	 }
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  删除医嘱项配置
/// Table：       DtPortal_Configure.arcimItem
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.arcimItem).DeleteById("5||1")
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DtPortal.Configure.arcimItem).%DeleteId(ID)
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
<Data name="arcimItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItmMastObj</Value>
</Value>
<Value name="3">
<Value>ItemUpdate</Value>
</Value>
<Value name="4">
<Value>ItemUpTime</Value>
</Value>
<Value name="5">
<Value>ItmOtherText</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Item")</DataLocation>
<DefaultData>arcimItemDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Item")</IdLocation>
<IndexLocation>^DtPortal.Configure.ArcimI("Item")</IndexLocation>
<StreamLocation>^DtPortal.Configure.arcimItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
