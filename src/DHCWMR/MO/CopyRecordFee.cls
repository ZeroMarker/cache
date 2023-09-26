/// 病案复印收费表
Class DHCWMR.MO.CopyRecordFee Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MO.CopyRecord [ Cardinality = parent, Inverse = ChildFee ];

/// 收费表
Property CRFRecordDr As DHCWMR.MF.FeeRecord;

/// 收费表 索引
Index IndexRecordDr On CRFRecordDr;

/// Creator：     liyi
/// CreatDate：   2015-08-02
/// Description:  更新病案复印收费表
/// Table：       DHCWMR.MO.CopyRecordFee
/// Input：       InputStr ID^DHCWMR.MO.CopyRecord.ID^DHCWMR.MF.FeeRecord.ID
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MO.CopyRecordFee).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID 				= $p(aInputStr,aSeparate,1)
	Set Parref			= $p(aInputStr,aSeparate,2)
	Set FeeRecordID		= $p(aInputStr,aSeparate,3)
	Quit:(FeeRecordID="")||(Parref="") return
	
	Set tID=$o(^DHCWMR.MO.CopyRecordI("FEE","IndexRecordDr",FeeRecordID,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objFeeRecord = ##class(DHCWMR.MF.FeeRecord).GetObjById(FeeRecordID)
	Quit:'$IsObject(objFeeRecord) return
	
	Set objParref = ##class(DHCWMR.MO.CopyRecord).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ID="" {
		Set obj=##class(DHCWMR.MO.CopyRecordFee).%New()
	} Else {
		Set obj=##class(DHCWMR.MO.CopyRecordFee).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.Parref			= objParref
	Set obj.CRFRecordDr		= objFeeRecord
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-08-02
/// Description:  取病案复印收费表
/// Table：       DHCWMR.MO.CopyRecordFee
/// Input：       Id : DHCWMR.MO.CopyRecordFee.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MO.CopyRecordFee).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MO.CopyRecordFee
{
	new (aId)
	quit:'##class(DHCWMR.MO.CopyRecordFee).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MO.CopyRecordFee).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-08-02
/// Description:  删除病案复印收费表
/// Table：       DHCWMR.MO.CopyRecordFee
/// Input：       Id : DHCWMR.MO.CopyRecordFee.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.MO.CopyRecordFee).%DeleteId(aId)
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
<Value>CRFRecordDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("FEE")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("FEE")</IdLocation>
<IndexLocation>^DHCWMR.MO.CopyRecordI("FEE")</IndexLocation>
<StreamLocation>^DHCWMR.MO.CopyRecordFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
