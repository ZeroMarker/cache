/// 名称: DHCHAI.DP.LabSpecimen
/// 描述: 标本
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabSpecimen Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTSpecCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTSpecDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// whone码
Property BTWCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 属性 LabSpecType（无菌部位、清洁标本、非清洁标本）
Property BTPropertyDr As DHCHAI.BT.Dictionary;

/// 代码索引
Index IndexCode On BTSpecCode As Exact;

/// 名称索引
Index IndexDesc On BTSpecDesc As Exact;

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取标本
/// Table：       DHCHAI.DP.LabSpecimen
/// Input：       aCode:    标本代码
/// 			  aDesc:    标本名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabSpecimen).GetObjByCodeDesc("","")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.LabSpecimen
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.LabSpecimenI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.LabSpecimenI("IndexDesc",aDesc,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取标本
/// Table：       DHCHAI.DP.LabSpecimen
/// Input：       ID:    DHCHAI.DP.LabSpecimen.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabSpecimen).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabSpecimen
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabSpecimen).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabSpecimen).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新标本
/// Table：       DHCHAI.DP.LabSpecimen
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabSpecimen).Update("^XY^血液^Xy^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set SpecCode	= $p(InStr,aSeparete,2)
	Set SpecDesc	= $p(InStr,aSeparete,3)
	Set WCode		= $p(InStr,aSeparete,4)
	Set IsActive	= +$p(InStr,aSeparete,5)
	Set PropertyDr	= $p(InStr,aSeparete,6)
	Quit:(SpecCode="")||(SpecDesc="")||(IsActive="") return
	
	Set SpecDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)  //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.LabSpecimenI("IndexCode",SpecCode,0))
	If tID="" {
		//名称唯一性
		Set tID =$o(^DHCHAI.DP.LabSpecimenI("IndexDesc",SpecDesc,0))
	}
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.DP.LabSpecimen).%New()
	} Else {
		Set obj=##class(DHCHAI.DP.LabSpecimen).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTSpecCode	= SpecCode
	Set obj.BTSpecDesc	= SpecDesc
	Set obj.BTWCode		= WCode
	Set obj.BTIsActive	= IsActive
	Set obj.BTPropertyDr = ##class(DHCHAI.BT.Dictionary).GetObjById(PropertyDr)
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除标本
/// Table：       DHCHAI.DP.LabSpecimen
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.LabSpecimen")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.LabSpecimen).%DeleteId(+Id)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTSpecCode</Value>
</Value>
<Value name="3">
<Value>BTSpecDesc</Value>
</Value>
<Value name="4">
<Value>BTWCode</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTPropertyDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabSpecimenD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabSpecimenD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabSpecimenI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
