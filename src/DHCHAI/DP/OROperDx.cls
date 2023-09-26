/// 名称: DHCHAI.DP.OROperDx
/// 描述: 手术字典
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OROperDx Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 手术代码
Property BTOperCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 手术名称
Property BTOperDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 手术切口
Property BTOperIncDr As DHCHAI.BT.Dictionary;

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 手术代码索引
Index IndexOperCode On BTOperCode As Exact;

/// 手术名称索引
Index IndexOperDesc On BTOperDesc As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取手术分类
/// Table：       DHCHAI.DP.OROperDx
/// Input：       ID:    DHCHAI.DP.OROperDx.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperDx).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OROperDx
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OROperDx).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OROperDx).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取手术
/// Table：       DHCHAI.DP.OROperDx
/// Input：       aCode:    手术代码
/// 			  aDesc:    手术名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperDx).GetObjByCodeDesc("","")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.OROperDx
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.OROperDxI("IndexOperCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.OROperDxI("IndexOperDesc",aDesc,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新手术分类
/// Table：       DHCHAI.DP.OROperDx
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OROperDx).Update("^FDP^肺大泡缝合术^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set OperCode   	= $p(InStr,aSeparete,2)
	Set OperDesc   	= $p(InStr,aSeparete,3)
	Set OperIncDr   = $p(InStr,aSeparete,4)
	Set IsActive   	= +$p(InStr,aSeparete,5)
	Quit:(OperCode="")||(OperDesc="")||(IsActive="") return
	Set OperDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(OperDesc) //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.OROperDxI("IndexOperCode",OperCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	//名称唯一
	Set tID =$o(^DHCHAI.DP.OROperDxI("IndexOperDesc",OperDesc,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objOperInc=##class(DHCHAI.BT.Dictionary).GetObjById(OperIncDr)
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OROperDx).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OROperDx).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTOperCode	= OperCode
	Set obj.BTOperDesc	= OperDesc
	Set obj.BTOperIncDr = objOperInc
	Set obj.BTIsActive	= IsActive
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

/// Creator：     zhoubo
/// CreatDate：   2017-07-28
/// Description:  导入手术字典
/// Table：       DHCHAI.DP.OROperDx
/// Input：       
/// w ##class("DHCHAI.DP.OROperDx").ImportOperDx("","^")
ClassMethod ImportOperDx(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set CutDr=""
	Set CutDesc = $p(aInputStr,aSeparate,4)
	Set CutDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("CuteType",CutDesc,"1")
	Set $p(aInputStr,aSeparate,4) = CutDr 
	
	Set return=##Class(DHCHAI.DP.OROperDx).Update(aInputStr,aSeparate)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除手术分类
/// Table：       DHCHAI.DP.OROperDx
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.OROperDx")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.OROperDx).%DeleteId(+Id)
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
<Value>BTOperCode</Value>
</Value>
<Value name="3">
<Value>BTOperDesc</Value>
</Value>
<Value name="4">
<Value>BTOperIncDr</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OROperDxD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OROperDxD</IdLocation>
<IndexLocation>^DHCHAI.DP.OROperDxI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OROperDxS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
