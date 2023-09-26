/// 名称: CT.IPMR.DP.SSUserMap
/// 描述: 用户对照
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DP.SSUserMap Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病案用户ID （指向MA_IPMR_BT.SSUser）
Property DSIpmrUserID As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// HIS用户ID （指向CT_IPMR_DP.SSUsre.DSUserID）
Property DSHisUserID As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

Index IndexOfHisUser On DSHisUserID [ Unique ];

Index IndexOfIpmrUser On DSIpmrUserID;

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  取用户对照
/// Table：       CT.IPMR.DP.SSUserMap
/// Input：       Id : CT.IPMR.DP.SSUserMap.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.DP.SSUserMap).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.DP.SSUserMap
{
	new (aId)
	quit:'##class(CT.IPMR.DP.SSUserMap).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.DP.SSUserMap).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  取用户对照
/// Table：       CT.IPMR.DP.SSUserMap
/// Input：       Id : CT_IPMR_DP.SSUser.DSUserID
/// Return：      返回Object
/// w ##class(CT.IPMR.DP.SSUserMap).GetObjByHisUserID("9||1")
ClassMethod GetObjByHisUserID(aHisUserID As %String) As CT.IPMR.DP.SSUserMap
{
	new (aHisUserID)
	Set id = $o(^CT.IPMR.DP.SSUserMapI("IndexOfHisUser"," "_aHisUserID,""))
	quit:'##class(CT.IPMR.DP.SSUserMap).%ExistsId(id) ""
	set obj=##Class(CT.IPMR.DP.SSUserMap).%OpenId(id)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  更新用户对照
/// Table：       CT.IPMR.DP.SSUserMap
/// Input：       InputStr ：对照数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.SSUserMap).Update("^1^175","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID			= $p(aInputStr,aSeparate,1)
	Set IpmrUserID	= $p(aInputStr,aSeparate,2)
	Set HisUserID 	= $p(aInputStr,aSeparate,3)
	Quit:(IpmrUserID="")||(HisUserID="") return

	Set objIpmrUser = ##class(MA.IPMR.BT.SSUser).GetObjById(IpmrUserID)
	Quit:'$IsObject(objIpmrUser) return
	
	Set objHisUser= ##class(CT.IPMR.DP.SSUser).GetObjByOID(HisUserID)
	Quit:'$IsObject(objHisUser) return

	Set tID = $o(^CT.IPMR.DP.SSUserMapI("IndexOfHisUser"," "_HisUserID,""))
	Quit:tID'="" -100
	
	If ID="" {
		Set obj=##class(CT.IPMR.DP.SSUserMap).%New()
	}Else{
		Set obj=##class(CT.IPMR.DP.SSUserMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DSIpmrUserID	= IpmrUserID
	Set obj.DSHisUserID	= HisUserID
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

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  删除用户对照
/// Table：       CT.IPMR.DP.SSUserMap
/// Input：       Id : CT.IPMR.DP.SSUserMap.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.DP.SSUserMap).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.DP.SSUserMap).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSIpmrUserID</Value>
</Value>
<Value name="3">
<Value>DSHisUserID</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.DP.SSUserMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.DP.SSUserMapD</IdLocation>
<IndexLocation>^CT.IPMR.DP.SSUserMapI</IndexLocation>
<StreamLocation>^CT.IPMR.DP.SSUserMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
