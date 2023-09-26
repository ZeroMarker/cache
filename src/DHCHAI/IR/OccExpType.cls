/// 名称: DHCHAI.IR.OccExpType
/// 描述: 职业暴露类型定义
/// 编写者：zhufei
/// 编写日期: 2018-04-25
Class DHCHAI.IR.OccExpType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 内容扩展
Relationship ChildExt As DHCHAI.IR.OccExpTypeExt [ Cardinality = children, Inverse = Parref ];

/// 血清学检验
Relationship ChildLab As DHCHAI.IR.OccExpTypeLab [ Cardinality = children, Inverse = Parref ];

/// 暴露感染类型
Relationship ChildEpd As DHCHAI.IR.OccExpTypeEpd [ Cardinality = children, Inverse = Parref ];

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 是否有效
Property BTIsActive As %Boolean;

/// 备注（说明）
Property BTResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 代码索引
Index IndexCode On BTCode As Exact;

/// 名称索引
Index IndexDesc On BTDesc As Exact;

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  根据ID取职业暴露类型
/// Table：       DHCHAI.IR.OccExpType
/// Input：       aId : DHCHAI.IR.OccExpType.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.OccExpType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.OccExpType
{
	New (aId)
	Quit:'##class(DHCHAI.IR.OccExpType).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.OccExpType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  更新职业暴露类型
/// Table：       DHCHAI.IR.OccExpType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpType).Update("1^BJXHZYBL^北京协和职业暴露^1^北京协和职业暴露")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Code		= $p(aInputStr,aSeparete,2)
	Set Desc		= $p(aInputStr,aSeparete,3)
	Set IsActive	= +$p(aInputStr,aSeparete,4)
	Set Resume		= $p(aInputStr,aSeparete,5)
	Quit:(Code="")||(Desc="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.IR.OccExpTypeI("IndexCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.OccExpType).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.OccExpType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTIsActive 	= IsActive
	Set obj.BTResume 	= Resume
	
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
/// CreatDate：   2018-05-10
/// Description:  删除职业暴露类型
/// Table：       DHCHAI.IR.OccExpType
/// Input：       aId : DHCHAI.IR.OccExpType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.OccExpType).%DeleteId(aId)
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
<Data name="OccExpTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTResume</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.OccExpTypeD</DataLocation>
<DefaultData>OccExpTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.OccExpTypeD</IdLocation>
<IndexLocation>^DHCHAI.IR.OccExpTypeI</IndexLocation>
<StreamLocation>^DHCHAI.IR.OccExpTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
