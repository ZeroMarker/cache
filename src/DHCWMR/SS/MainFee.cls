/// 病案建档收费表
Class DHCWMR.SS.MainFee Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.SS.Main [ Cardinality = parent, Inverse = ChildFee ];

/// 收费表
Property MFRecordDr As DHCWMR.MF.FeeRecord;

/// 收费表 索引
Index IndexRecordDr On MFRecordDr;

/// Creator：     zhufei
/// CreatDate：   2015-10-12
/// Description:  取病案建档收费表
/// Table：       DHCWMR.SS.MainFee
/// Input：       Id : DHCWMR.SS.MainFee.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.MainFee).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.MainFee
{
	new (aId)
	quit:'##class(DHCWMR.SS.MainFee).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.MainFee).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-10-12
/// Description:  更新病案建档收费表
/// Table：       DHCWMR.SS.MainFee
/// Input：       InputStr ID^DHCWMR.SS.Main.ID^DHCWMR.MF.FeeRecord.ID
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.SS.MainFee).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref			= $p(aInputStr,aSeparate,1)
	Set ChildSub        = $p(aInputStr,aSeparate,2)
	Set FeeRecordID		= $p(aInputStr,aSeparate,3)
	Quit:(FeeRecordID="")||(Parref="") return
	
	Set objFeeRecord = ##class(DHCWMR.MF.FeeRecord).GetObjById(FeeRecordID)
	Quit:'$IsObject(objFeeRecord) return
	
	Set objParref = ##class(DHCWMR.SS.Main).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.SS.MainFee).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.MainFee).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref			= objParref
	Set obj.MFRecordDr		= objFeeRecord
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-10-12
/// Description:  删除病案建档收费表
/// Table：       DHCWMR.SS.MainFee
/// Input：       Id : DHCWMR.SS.MainFee.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.SS.MainFee).%DeleteId(aId)
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
<Value>MFRecordDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("FEE")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("FEE")</IdLocation>
<IndexLocation>^DHCWMR.SS.MainI("FEE")</IndexLocation>
<StreamLocation>^DHCWMR.SS.MainFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
