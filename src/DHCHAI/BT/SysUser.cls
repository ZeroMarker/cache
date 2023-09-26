/// 名称: DHCHAI.BT.SysUser
/// 描述: 系统用户表
/// 编写者：liyi
/// 编写日期: 2017-01-12
Class DHCHAI.BT.SysUser Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 用户工号
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 用户名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 用户密码（暂时不用）
Property BTPassword As %String(MAXLEN = 100, TRUNCATE = 1);

/// 用户科室
Property BTLocDr As DHCHAI.BT.Location;

/// 医护类型（D医生、N护士）
Property BTTypeDr As DHCHAI.BT.Dictionary;

/// 指向医护人员
Property BTCareProvDr As DHCHAI.BT.CareProv;

/// 记录索引码（HIS中用户ID）
Property BTXCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 用户电话
Property BTPhoneNo As %String;

/// 待处理事项授权(新增 待处理事项)
Property BTTodoControl As %String(MAXLEN = 500, TRUNCATE = 1);

/// 全院概况授权(新增 全院概况)
Property BTHospControl As %String(MAXLEN = 500, TRUNCATE = 1);

/// 代码索引
Index IndexUserCode On BTCode As Exact;

/// 记录索引码索引
Index IndexXCode On BTXCode As Exact;

/// Creator：     pylian
/// CreatDate：   2018-06-27
/// Description:  根据用户工号取用户信息
/// Table：       DHCHAI.BT.SysUser
/// Input：       aUserCode : DHCHAI.BT.SysUser.BTCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUser).GetIDByCode("med")
ClassMethod GetIDByCode(aUserCode As %String) As %String
{
	New (aUserCode)
	Set return = ""
	Quit:(aUserCode="") return
	
	Set aUserCode=$zcvt(aUserCode,"U")
	Set ID=$o(^DHCHAI.BT.SysUserI("IndexUserCode",aUserCode,0))
	Set return = ID
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据用户代码取对照用户
/// Table：       DHCHAI.BT.SysUser、DHCHAI.BT.SysUserMap
/// Input：       aSCode : DHCHAI.BT.SysUserMap.BTSCode
///               aUserCode : DHCHAI.BT.SysUserMap.BTCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUser).GetObjByUserCode("HIS01","med")
ClassMethod GetObjByUserCode(aSCode As %String, aUserCode As %String) As DHCHAI.BT.SysUser
{
	New (aSCode,aUserCode)
	Set return = ""
	Quit:(aSCode="")||(aUserCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aUserCode=$zcvt(aUserCode,"U")
	Set objMap=##class(DHCHAI.BT.SysUserMap).GetObjByCode(aSCode,aUserCode)
	If $IsObject(objMap) {
		Quit:'$IsObject(objMap.BTMapUserDr) return
		Set return=objMap.BTMapUserDr
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据XCode取对照用户
/// Table：       DHCHAI.BT.SysUser、DHCHAI.BT.SysUserMap
/// Input：       aSCode : DHCHAI.BT.SysUserMap.BTSCode
///               aXCode : DHCHAI.BT.SysUserMap.BTXCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUser).GetObjByXCode(1)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.BT.SysUser
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aXCode=$zcvt(aXCode,"U")
	Set objMap=##class(DHCHAI.BT.SysUserMap).GetObjByXCode(aSCode,aXCode)
	If $IsObject(objMap) {
		Quit:'$IsObject(objMap.BTMapUserDr) return
		Set return=objMap.BTMapUserDr
	}
	Quit:return'="" return
	
	Set ID=$o(^DHCHAI.BT.SysUserI("IndexXCode",aSCode_"||"_aXCode,0))
	Set:ID'="" return=##class(DHCHAI.BT.SysUser).GetObjById(ID)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取用户信息
/// Table：       DHCHAI.BT.SysUser
/// Input：       aId : DHCHAI.BT.SysUser.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUser).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.SysUser
{
	New (aId)
	Quit:'##class(DHCHAI.BT.SysUser).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.SysUser).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新用户信息
/// Table：       DHCHAI.BT.SysUser
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.SysUser).Update("^med^med manager^U&dDF1,""7k7k^2446^^9^1^^^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID	   		= $p(aInputStr,aSeparete,1)
	Set Code	    = $p(aInputStr,aSeparete,2)
	Set Desc	    = $p(aInputStr,aSeparete,3)
	Set Password    = $p(aInputStr,aSeparete,4)
	Set LocDr	    = $p(aInputStr,aSeparete,5)
	Set TypeDr	    = $p(aInputStr,aSeparete,6)
	Set XCode		= $p(aInputStr,aSeparete,7)
	Set IsActive	= +$p(aInputStr,aSeparete,8)
	Set ActDate		= $p(aInputStr,aSeparete,9)
	Set ActTime		= $p(aInputStr,aSeparete,10)
	Set ActUserDr   = $p(aInputStr,aSeparete,11)
	Set CareProvDr  = $p(aInputStr,aSeparete,12)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(Code="")||(Desc="")||(XCode="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set XCode=$zcvt(XCode,"U")
	Set tID=$o(^DHCHAI.BT.SysUserI("IndexXCode",XCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(TypeDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Set objCareProv=##class(DHCHAI.BT.CareProv).GetObjById(CareProvDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.SysUser).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.SysUser).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTPassword  = Password
	Set obj.BTLocDr	    = objLoc
	Set obj.BTTypeDr	= objType
	Set obj.BTXCode		= XCode
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUserDr	= objActUser
	Set obj.BTCareProvDr= objCareProv
	
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
/// Description:  删除用户信息
/// Table：       DHCHAI.BT.SysUser
/// Input：       aId : DHCHAI.BT.SysUser.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.SysUser).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.SysUser).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2021-09-22
/// Description:  根据用户ID取权限信息
/// Table：       DHCHAI.BT.SysUser
/// Input：       aID : DHCHAI.BT.SysUser.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUser).GetControlByID("1","2")
ClassMethod GetControlByID(aType As %String, aID As %String) As %String
{
	New (aType,aID)
	Set return = ""
	Quit:(aType="")||(aID="") return
	
	Set obj=##class(DHCHAI.BT.SysUser).GetObjById(aID)
	Quit:('$IsObject(obj)) return
	Set Control=""
	if (aType=1){			//1.待处理事项
		Set Control=obj.BTTodoControl
	}
	elseif (aType=2){		//2.全院概况
		Set Control=obj.BTHospControl
	}
	Set return = Control
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2021-09-22
/// Description:  根据用户ID更新权限信息
/// Table：       DHCHAI.BT.SysUser
/// Input：       aID : DHCHAI.BT.SysUser.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUser).UpdateControlByID("1","x|y")
ClassMethod UpdateControlByID(aType As %String, aID As %String, aControl As %String) As %String
{
	New (aType,aID,aControl)
	Set return = ""
	Quit:(aType="")||(aID="") return
	
	Set obj=##class(DHCHAI.BT.SysUser).%OpenId(aID)
	Quit:'$IsObject(obj) return
	
	if (aType=1){			//1.待处理事项
		Set obj.BTTodoControl=aControl
	}
	elseif (aType=2){		//2.全院概况
		Set obj.BTHospControl=aControl
	}
	//保存
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

/// Creator：     liuzhenhe
/// CreatDate：   2022-09-22
/// Description:  根据更新用户手机号
/// Table：       DHCHAI.BT.SysUser
/// Input：       aUserId : DHCHAI.BT.SysUser.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUser).ChangePhone("19","123")
ClassMethod ChangePhone(aUserId As %String, aPhone As %String)
{
    new (aUserId,aPhone)
    Set return=""
    Quit:'##class(DHCHAI.BT.SysUser).%ExistsId(aUserId) return
    Set obj=##Class(DHCHAI.BT.SysUser).%OpenId(aUserId)
    Set obj.BTPhoneNo= aPhone
    //Quit:'$IsObject(obj)
    Set sc=obj.%Save()
    if $system.Status.IsError(sc) {        //检查Save是否成功
        Do $system.OBJ.DisplayError(sc)
        Set return=-1
    }else{
        Set return=obj.%Id()
    }
    Do obj.%Close()
    quit return
}

Storage Default
{
<Data name="SysUserDefaultData">
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
<Value>BTPassword</Value>
</Value>
<Value name="5">
<Value>BTLocDr</Value>
</Value>
<Value name="6">
<Value>BTTypeDr</Value>
</Value>
<Value name="7">
<Value>BTXCode</Value>
</Value>
<Value name="8">
<Value>BTIsActive</Value>
</Value>
<Value name="9">
<Value>BTActDate</Value>
</Value>
<Value name="10">
<Value>BTActTime</Value>
</Value>
<Value name="11">
<Value>BTActUserDr</Value>
</Value>
<Value name="12">
<Value>BTCareProvDr</Value>
</Value>
<Value name="13">
<Value>BTControl</Value>
</Value>
<Value name="14">
<Value>BTTodoControl</Value>
</Value>
<Value name="15">
<Value>BTHospControl</Value>
</Value>
<Value name="16">
<Value>BTPhoneNo</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.SysUserD</DataLocation>
<DefaultData>SysUserDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.SysUserD</IdLocation>
<IndexLocation>^DHCHAI.BT.SysUserI</IndexLocation>
<StreamLocation>^DHCHAI.BT.SysUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
