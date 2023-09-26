/// 名称: CT.IPMR.DP.SSUser
/// 描述: 用户
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DP.SSUser Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统指针
Property DSSysDr As CT.IPMR.DP.System [ Required ];

/// 字典ID （指向SS_User 或 第三方用户字典ID）
Property DSDicID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 用户ID （DSDicID_||_DSSysDr）
Property DSUserID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 用户代码
Property DSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 用户名称
Property DSDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 用户密码
Property DSPassword As %String(MAXLEN = 100, TRUNCATE = 1);

/// 用户科室（CT.IPMR.DP.Location.DLLocID）
Property DSLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 医护类型
Property DCCPTInternalType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医护人员类型名称
Property DCCPTDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医生资格证书号
Property DCUnit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property DSIsActive As %Boolean;

/// 名称拼音
Property DSSpell As %String(MAXLEN = 50, TRUNCATE = 1);

/// 用户ID 索引
Index IdxOfUserID On DSUserID [ Unique ];

/// 用户代码 索引
Index IdxOfCode On DSCode;

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  根据拼接的用户ID取用户信息
/// Table：       CT.IPMR.DP.SSUser
/// Input：       aUserID : CT.IPMR.DP.SSUser.DSUserID
/// Return：      返回obj
/// w ##class(CT.IPMR.DP.SSUser).GetObjByOID(1)
ClassMethod GetObjByOID(aUserID As %String) As CT.IPMR.DP.SSUser
{
	New (aUserID)
	Set return=""
	Quit:aUserID="" return
	Set id =  $o(^CT.IPMR.DP.SSUserI("IdxOfUserID"," "_$zcvt(aUserID,"U"),""))
	Quit:id="" return
	Set return = ..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  根据ID取用户信息
/// Table：       CT.IPMR.DP.SSUser
/// Input：       aId : CT.IPMR.DP.SSUser.ID
/// Return：      返回obj
/// w ##class(CT.IPMR.DP.SSUser).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.DP.SSUser
{
	New (aId)
	Quit:'##class(CT.IPMR.DP.SSUser).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.DP.SSUser).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-24
/// Description:  更新用户信息
/// Table：       CT.IPMR.DP.SSUser
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.SSUser).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set SysID    = $p(aInputStr,aSeparete,2)
	Set DicID    = $p(aInputStr,aSeparete,3)
	Set UserID	 = $p(aInputStr,aSeparete,4)
	Set Code	 = $p(aInputStr,aSeparete,5)
	Set Desc     = $p(aInputStr,aSeparete,6)
	Set Password = $p(aInputStr,aSeparete,7)
	Set LocID    = $p(aInputStr,aSeparete,8)
	Set IsActive = +$p(aInputStr,aSeparete,9)
	Set Spell    = $p(aInputStr,aSeparete,10)
	Set CPTInternalType	 = $p(aInputStr,aSeparete,11)
	Set CPTDesc= $p(aInputStr,aSeparete,12)
	Set Unit	 = $p(aInputStr,aSeparete,13)
	Quit:(SysID="")||(DicID="")||(Code="")||(Desc="")||(UserID="") return
	
	Set objSYS=##class(CT.IPMR.DP.System).GetObjById(SysID)
	Quit:'$IsObject(objSYS) return
	
	Set tID=$o(^CT.IPMR.DP.SSUserI("IdxOfUserID"," "_$zcvt(UserID,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(CT.IPMR.DP.SSUser).%New()
	}Else{
		Set obj=##class(CT.IPMR.DP.SSUser).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DSSysDr      = objSYS
	Set obj.DSDicID      = DicID
	Set obj.DSCode       = Code
	Set obj.DSDesc       = Desc
	Set obj.DSPassword   = Password
	Set obj.DSLocID      = LocID
	Set obj.DSIsActive   = IsActive
	Set obj.DSSpell    	 = Spell
	Set obj.DSUserID     = UserID
	Set obj.DCCPTInternalType	 = CPTInternalType
	Set obj.DCCPTDesc = CPTDesc
	Set obj.DCUnit		 = Unit
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
/// CreatDate：   2019-10-24
/// Description:  删除用户信息
/// Table：       CT.IPMR.DP.SSUser
/// Input：       aId : CT.IPMR.DP.SSUser.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.SSUser).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(CT.IPMR.DP.SSUser).%DeleteId(aId)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSSysDr</Value>
</Value>
<Value name="3">
<Value>DSDicID</Value>
</Value>
<Value name="4">
<Value>DSUserID</Value>
</Value>
<Value name="5">
<Value>DSCode</Value>
</Value>
<Value name="6">
<Value>DSDesc</Value>
</Value>
<Value name="7">
<Value>DSPassword</Value>
</Value>
<Value name="8">
<Value>DSLocID</Value>
</Value>
<Value name="9">
<Value>DCCPTInternalType</Value>
</Value>
<Value name="10">
<Value>DCCPTDesc</Value>
</Value>
<Value name="11">
<Value>DCUnit</Value>
</Value>
<Value name="12">
<Value>DSIsActive</Value>
</Value>
<Value name="13">
<Value>DSSpell</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.DP.SSUserD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.DP.SSUserD</IdLocation>
<IndexLocation>^CT.IPMR.DP.SSUserI</IndexLocation>
<StreamLocation>^CT.IPMR.DP.SSUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
