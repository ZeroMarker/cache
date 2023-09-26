/// 名称: DHCHAI.BT.Dictionary
/// 描述: 系统字典表
/// 编写者：chenjb
/// 编写日期: 2017-01-10
Class DHCHAI.BT.Dictionary Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(TRUNCATE = 1) [ Required ];

/// 字典分类
Property BTTypeDr As DHCHAI.BT.DicType [ Required ];

/// 排序码
Property BTIndNo As %String(TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 字典分类 + 代码 索引
Index IdxofTypeDrCode On (BTTypeDr, BTCode As Exact);

/// 字典分类 + 名称 索引
Index IdxofTypeDrDesc On (BTTypeDr, BTDesc As Exact);

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  根据ID取系统字典信息
/// Table：       DHCHAI.BT.Dictionary
/// Input：       aId : DHCHAI.BT.Dictionary.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Dictionary).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.Dictionary
{
	New (aId)
	Quit:'##class(DHCHAI.BT.Dictionary).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.Dictionary).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-04-10
/// Description:  根据Code取系统字典信息
/// Table：       DHCHAI.BT.Dictionary
/// Input：       aTypeCode : DHCHAI.BT.DicType.Code
///               aCode : DHCHAI.BT.Dictionary.Code
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Dictionary).GetObjByCode("UserType","D")
ClassMethod GetObjByCode(aTypeCode As %String, aCode As %String) As DHCHAI.BT.Dictionary
{
	New (aTypeCode,aCode)
	Quit:(aTypeCode="")||(aCode="") ""
	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) ""
	Set TypeDr=objType.%Id()
	Set ID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aCode,0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2017-08-03
/// Description:  根据描述取系统字典信息
/// Table：       DHCHAI.BT.Dictionary
/// Input：       aTypeCode : DHCHAI.BT.DicType.Code
///               aDesc : DHCHAI.BT.Dictionary.Desc
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Dictionary).GetObjByDesc("UserType","D")
ClassMethod GetObjByDesc(aTypeCode As %String, aDesc As %String) As DHCHAI.BT.Dictionary
{
	New (aTypeCode,aDesc)
	Quit:(aTypeCode="")||(aDesc="") ""
	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) ""
	Set TypeDr=objType.%Id()
	Set ID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrDesc",TypeDr,aDesc,0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     chenrui
/// CreatDate：   2020-07-27
/// Description:  根据描述取系统字典信息
/// Table：       DHCHAI.BT.Dictionary
/// Input：       aTypeCode : DHCHAI.BT.DicType.Code
///               aDesc : DHCHAI.BT.Dictionary.Desc
/// Return：      返回ID
/// w ##class(DHCHAI.BT.Dictionary).GetIDByDesc("MRBOutLabType","外院携带")
ClassMethod GetIDByDesc(aTypeCode As %String, aDesc As %String) As %String
{
	New (aTypeCode,aDesc)
	Quit:(aTypeCode="")||(aDesc="") ""
	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) ""
	Set TypeDr=objType.%Id()
	Set ID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrDesc",TypeDr,aDesc,0))
	Quit ID
}

/// Creator：     pylian
/// CreatDate：   2017-08-03
/// Description:  根据描述取系统字典信息
/// Table：       DHCHAI.BT.Dictionary
/// Input：       aTypeCode : DHCHAI.BT.DicType.Code
///               aDesc : DHCHAI.BT.Dictionary.Desc
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Dictionary).GetIDByCode("HandHyUnit","ml")
ClassMethod GetIDByCode(aTypeCode As %String, aCode As %String) As %String
{
	New (aTypeCode,aCode)
	Quit:(aTypeCode="")||(aCode="") ""
	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) ""
	Set TypeDr=objType.%Id()
	Set ID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,aCode,0))
	Quit ID
}

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  更新系统字典信息
/// Table：       DHCHAI.BT.Dictionary
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.Dictionary).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set TypeDr   = $p(aInputStr,aSeparete,4)
	Set IndNo    = $p(aInputStr,aSeparete,5)
	Set IsActive = +$p(aInputStr,aSeparete,6)
	Quit:(Code="")||(Desc="")||(TypeDr="") return
	
	Set objType=##class(DHCHAI.BT.DicType).GetObjById(TypeDr)
	Quit:'$IsObject(objType) return
	
	Set tID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.Dictionary).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.Dictionary).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTTypeDr   = objType
	Set obj.BTIndNo    = IndNo
	Set obj.BTIsActive = IsActive
	
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

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  删除系统字典信息
/// Table：       DHCHAI.BT.Dictionary
/// Input：       aId : DHCHAI.BT.Dictionary.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.Dictionary).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.Dictionary")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCHAI.BT.Dictionary).%DeleteId(aId)
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
<Data name="DictionaryDefaultData">
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
<Value>BTTypeDr</Value>
</Value>
<Value name="5">
<Value>BTIndNo</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.DictionaryD</DataLocation>
<DefaultData>DictionaryDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.DictionaryD</IdLocation>
<IndexLocation>^DHCHAI.BT.DictionaryI</IndexLocation>
<StreamLocation>^DHCHAI.BT.DictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
