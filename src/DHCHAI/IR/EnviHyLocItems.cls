/// 名称: DHCHAI.IR.EnviHyLocItems
/// 描述: 环境卫生学科室监测项目计划
/// 编写者：zhufei
/// 编写日期: 2019-09-09
Class DHCHAI.IR.EnviHyLocItems Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 申请科室
Property EHLocationDr As DHCHAI.BT.Location [ Required ];

/// 监测项目
Property EHItemDr As DHCHAI.IR.EnviHyItem [ Required ];

/// 限定数量（上限）
Property EHItemMax As %Integer;

/// 限定数量（下限）
Property EHItemMin As %Integer;

/// 限定单位（项/月、项/季度、项/半年、项/年）EHItemUnit
Property EHItemUnit As DHCHAI.BT.Dictionary [ Required ];

/// 计划安排日期
Property EHPlanDate As %Date;

/// 备注说明
Property EHNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否有效
Property EHIsActive As %Boolean;

/// 更新日期
Property EHActDate As %Date;

/// 更新时间
Property EHActTime As %Time;

/// 更新人
Property EHActUserDr As DHCHAI.BT.SysUser;

/// 申请科室 索引
Index IdxLocationDr On EHLocationDr;

/// 申请科室+监测项目 索引
Index IdxLocItemDr On (EHLocationDr, EHItemDr);

/// Creator：     zhangdc
/// CreatDate：   2019-09-20
/// Description:  根据ID取科室监测项目计划
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       
/// Return：      返回Object
/// w ##class(DHCHAI.IR.EnviHyLocItems).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.IR.EnviHyLocItems
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.IR.EnviHyLocItems).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.IR.EnviHyLocItems).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2019-09-20
/// Description:  更新科室监测项目计划
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyLocItems).Update("^3^千级洁净手术室空气监测^^^项/季度^^^0")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Set $ZT="UpdateErr"
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID				= $p(InStr,aSeparete,1)
	Set LocationID	    = $p(InStr,aSeparete,2)
	Set ItemID        	= $p(InStr,aSeparete,3)
	Set ItemMax         = $p(InStr,aSeparete,4)
	Set ItemMin         = $p(InStr,aSeparete,5)
	Set ItemUnitID      = $p(InStr,aSeparete,6)
	Set PlanDate        = $p(InStr,aSeparete,7)
	Set:PlanDate'="" PlanDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(PlanDate)
	Set Note            = $p(InStr,aSeparete,8)
	Set IsActive		= +$p(InStr,aSeparete,9)
	Quit:(LocationID="")||(ItemID="")||(ItemUnitID="") return
	
	Set objItemUnit = ##class(DHCHAI.BT.Dictionary).GetObjById(ItemUnitID)
	Quit:'$IsObject(objItemUnit) return
	
	Set objEnviHyItem = ##class(DHCHAI.IR.EnviHyItem).GetObjById(ItemID)
	Quit:'$IsObject(objEnviHyItem) return
	
	Set objLocation = ##class(DHCHAI.BT.Location).GetObjById(LocationID)
	Quit:'$IsObject(objLocation) return
	
	if ID="" {
		Set obj=##class(DHCHAI.IR.EnviHyLocItems).%New()
	}else{
		Set obj=##class(DHCHAI.IR.EnviHyLocItems).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.EHItemDr	  = objEnviHyItem
	Set obj.EHItemUnit	  = objItemUnit
	Set obj.EHLocationDr  = objLocation
	Set obj.EHItemMax	  = ItemMax
	Set obj.EHItemMin	  = ItemMin
	Set obj.EHPlanDate	  = PlanDate
	Set obj.EHNote	      = Note 
	Set obj.EHIsActive	  = IsActive
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
UpdateErr
	Write "Error:"_$ZERROR,!
 	Quit -1
}

/// Creator：     zhangdc
/// CreatDate：   2019-09-22
/// Description:  删除科室监测项目计划对象
/// Table：       DHCHAI.IR.EnviHyLocItems
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.EnviHyLocItems).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="EnviHyLocItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHMonth</Value>
</Value>
<Value name="3">
<Value>EHItemDr</Value>
</Value>
<Value name="4">
<Value>EHItemMax</Value>
</Value>
<Value name="5">
<Value>EHItemMin</Value>
</Value>
<Value name="6">
<Value>EHItemUnit</Value>
</Value>
<Value name="7">
<Value>EHPlanDate</Value>
</Value>
<Value name="8">
<Value>EHNote</Value>
</Value>
<Value name="9">
<Value>EHIsActive</Value>
</Value>
<Value name="10">
<Value>EHActDate</Value>
</Value>
<Value name="11">
<Value>EHActTime</Value>
</Value>
<Value name="12">
<Value>EHActUserDr</Value>
</Value>
<Value name="13">
<Value>EHLocationDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.EnviHyLocItemsD</DataLocation>
<DefaultData>EnviHyLocItemsDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.EnviHyLocItemsD</IdLocation>
<IndexLocation>^DHCHAI.IR.EnviHyLocItemsI</IndexLocation>
<StreamLocation>^DHCHAI.IR.EnviHyLocItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
