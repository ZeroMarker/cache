/// 名称: DHCHAI.DP.OEItmCat
/// 描述: 医嘱分类
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OEItmCat Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 类型（如：器械相关治疗）
Property BTTypeDr As DHCHAI.DP.OEItmType;

/// 代码索引
Index IndexCode On BTCode As Exact;

/// 名称索引
Index IndexDesc On BTDesc As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取医嘱分类
/// Table：       DHCHAI.DP.OEItmCat
/// Input：       ID:    DHCHAI.DP.OEItmCat.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEItmCat).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OEItmCat
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OEItmCat).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OEItmCat).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-28
/// Description:  根据代码、名称取医嘱分类
/// Table：       DHCHAI.DP.OEItmCat
/// Input：       aCode:    医嘱代码
/// 			  aDesc:    医嘱名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEItmCat).GetObjByCodeDesc("1","")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.OEItmCat
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.OEItmCatI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.OEItmCatI("IndexDesc",aDesc,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新医嘱分类
/// Table：       DHCHAI.DP.OEItmCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEItmCat).Update("^SHS^四环素")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set Code		= $p(InStr,aSeparete,2)
	Set Desc		= $p(InStr,aSeparete,3)
	Set TypeDr		= $p(InStr,aSeparete,4)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	//分类代码唯一性
	Set tID =$o(^DHCHAI.DP.OEItmCatI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	Set objType = ##class(DHCHAI.DP.OEItmType).GetObjById(TypeDr)
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OEItmCat).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OEItmCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code
	Set obj.BTDesc		= Desc
	Set obj.BTTypeDr    = objType
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
/// Description:  删除医嘱分类
/// Table：       DHCHAI.DP.OEItmCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.OEItmCat")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.OEItmCat).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylin
/// CreatDate：   2017-12-01
/// Description:  导入医嘱分类字典
/// Table：       DHCHAI.DP.OEItmCat
/// Input：       
/// w ##class("DHCHAI.DP.OEItmCat").ImportItemCat("^DRT-I-PICC^中央血管导管^器械相关治疗","^")
ClassMethod ImportItemCat(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set TypeDesc = $p(aInputStr,aSeparate,4)
	Set TypeDr=""
	Set objItmType = ##class(DHCHAI.DP.OEItmType).GetObjByCodeDesc("",TypeDesc)
	Set:$isobject(objItmType) TypeDr = objItmType.%Id()
	Set $p(aInputStr,aSeparate,4) = TypeDr 
	
	Set return=##Class(DHCHAI.DP.OEItmCat).Update(aInputStr,aSeparate)
	Quit return
}

Storage Default
{
<Data name="DefaultData">
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
</Data>
<DataLocation>^DHCHAI.DP.OEItmCatD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OEItmCatD</IdLocation>
<IndexLocation>^DHCHAI.DP.OEItmCatI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OEItmCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
