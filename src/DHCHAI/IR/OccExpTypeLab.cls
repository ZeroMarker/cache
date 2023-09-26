/// 名称: DHCHAI.IR.OccExpTypeLab
/// 描述: 职业暴露血清学检查计划
/// 编写者：zhufei
/// 编写日期: 2018-04-25
Class DHCHAI.IR.OccExpTypeLab Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.OccExpType [ Cardinality = parent, Inverse = ChildLab ];

/// 检查时机（暴露24小时内、4周、8周、12周、6个月、1年）
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 排序码
Property BTIndNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发生日期后多少天血清学检查
Property BTDays As %Integer;

/// 是否有效
Property BTIsActive As %Boolean;

/// 备注（说明）
Property BTResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 检验外部项目
Property BTExtItemDr As DHCHAI.DP.LabInfTestSet;

/// 检查时机索引
Index IndexDescDays On (Parref, BTDesc As Exact, BTDays As Exact);

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  根据ID取职业暴露血清学检查计划
/// Table：       DHCHAI.IR.OccExpTypeLab
/// Input：       aId : DHCHAI.IR.OccExpTypeLab.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.OccExpTypeLab).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.OccExpTypeLab
{
	New (aId)
	Quit:'##class(DHCHAI.IR.OccExpTypeLab).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.OccExpTypeLab).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  更新职业暴露血清学检查计划
/// Table：       DHCHAI.IR.OccExpTypeLab
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpTypeLab).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref	  = $p(aInputStr,aSeparete,1)
	Set ChildSub  = $p(aInputStr,aSeparete,2)
	Set Desc	  = $p(aInputStr,aSeparete,3)
	Set IndNo	  = $p(aInputStr,aSeparete,4)
	Set Days	  = $p(aInputStr,aSeparete,5)
	Set IsActive  = +$p(aInputStr,aSeparete,6)
	Set Resume    = $p(aInputStr,aSeparete,7)
	Set ExtItemDr = $p(aInputStr,aSeparete,8)
	Quit:(Desc="")||(Days="") return

	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set objParref=##class(DHCHAI.IR.OccExpType).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set objExtItem = ##class(DHCHAI.DP.LabInfTestSet).GetObjById(ExtItemDr)
	Set tID=$o(^DHCHAI.IR.OccExpTypeI("LAB","IndexDescDays",Parref,Desc,Days,0))
	Quit:(tID'="")&(ChildSub'=tID) -2
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.OccExpTypeLab).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.OccExpTypeLab).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref	    = objParref
	Set obj.BTDesc	    = Desc
	Set obj.BTIndNo	    = IndNo
	Set obj.BTDays	    = Days
	Set obj.BTIsActive 	= IsActive
	Set obj.BTResume 	= Resume
	Set obj.BTExtItemDr = objExtItem
	
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

/// Creator：     pylian
/// CreatDate：   2018-06-22
/// Description:  导入血清学检查计划
/// w ##Class(DHCHAI.IR.OccExpTypeLab).ImportLab("北京协和职业暴露^HBV暴露^90^1^1^3个月","^")
ClassMethod ImportLab(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ExpType = $p(aInputStr,aSeparate,1)
	Set Desc    = $p(aInputStr,aSeparate,2)
	Set Days    = $p(aInputStr,aSeparate,3)
	Set IndNo   = $p(aInputStr,aSeparate,4)
	Set IsActive= $p(aInputStr,aSeparate,5)
	Set Resume  = $p(aInputStr,aSeparate,6)
	
	Quit:'$d(^DHCHAI.IR.OccExpTypeI("IndexDesc",ExpType)) return
	
    Set Parref =$o(^DHCHAI.IR.OccExpTypeI("IndexDesc",ExpType,0))
    Set ChildSub=$o(^DHCHAI.IR.OccExpTypeI("LAB","IndexDescDays",Parref,Desc,Days,0))
	
	Set ExtItemDr=$o(^DHCHAI.DP.LabInfTestSetI("IdxofCode","2",0))
	
	Set InputStr=Parref_aSeparate_ChildSub_aSeparate_Desc_aSeparate_IndNo_aSeparate_Days_aSeparate_IsActive_aSeparate_Resume_aSeparate_ExtItemDr
	Set return=##Class(DHCHAI.IR.OccExpTypeLab).Update(InputStr,aSeparate)
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  删除职业暴露血清学检查计划
/// Table：       DHCHAI.IR.OccExpTypeLab
/// Input：       aId : DHCHAI.IR.OccExpTypeLab.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpTypeLab).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.OccExpTypeLab).%DeleteId(aId)
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
<Data name="OccExpTypeLabDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTDesc</Value>
</Value>
<Value name="3">
<Value>BTIndNo</Value>
</Value>
<Value name="4">
<Value>BTDays</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTResume</Value>
</Value>
<Value name="7">
<Value>BTExtItemDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("LAB")</DataLocation>
<DefaultData>OccExpTypeLabDefaultData</DefaultData>
<IdLocation>{%%PARENT}("LAB")</IdLocation>
<IndexLocation>^DHCHAI.IR.OccExpTypeI("LAB")</IndexLocation>
<StreamLocation>^DHCHAI.IR.OccExpTypeLabS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
