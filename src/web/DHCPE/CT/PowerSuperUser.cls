/// 名称: 体检用户授权管理
/// 编写者：xy
/// 编写日期: 2021-08-04
Class web.DHCPE.CT.PowerSuperUser Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description: 插入体检超级用户授权表
/// Table：体检超级用户授权表 User.DHCPEPowerSuperUser  
/// Input: UserID 用户ID, GroupID 安全组ID, PowerType 权限类型, EffPower  是否有效授权,  CurUserID  登录用户ID
/// Return：
/// Creator：xy 
/// CreatDate：20210804
/// debug: w ##class(web.DHCPE.CT.PowerSuperUser).InsertPowerSuperUser("12187","164","S","Y","1")
ClassMethod InsertPowerSuperUser(UserID As %String, GroupID As %String, PowerType As %String, EffPower As %String, CurUserID As %String)
{
	new (UserID,GroupID,PowerType,EffPower,CurUserID)
	s ^tempdhcpe("InsertPowerSuperUser")=$lb(UserID,GroupID,PowerType,EffPower,CurUserID)
	s result=1
	Set Date=+$h
	Set Time=$p($h,",",2)
	
	if (UserID="") 
    {
     	s result="-1^用户不能为空"
    }
    elseif(GroupID="") 
    {
    	s result="-1^安全组不能为空"
    }
    elseif(PowerType="") 
    {
    	s result="-1^授权类型不能为空"
    }
    
    s obj=##class(User.DHCPEPowerSuperUser).%New()
    s obj.PSUUserDR=UserID  
    s obj.PSUGroupDR=GroupID
    s obj.PSUPowerType=PowerType
    s obj.PSUEffPower=EffPower 
    S obj.PSUUpdateDate=Date
    S obj.PSUUpdateTime=Time
    S obj.PSUUpdateUserDR=CurUserID
    Ts
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc) 
    {   
    	Tc
    	s id=obj.%Id()
    	s result=id_"^添加成功"
    }
    else
    {
     	Trollback
     	s result="-1^添加失败"
    }
    q result
}

/// Description: 更新体检超级用户授权表
/// Table：体检超级用户授权表 User.DHCPEPowerSuperUser  
/// Input: UserID 用户ID, GroupID 安全组ID, PowerType 权限类型, EffPower  是否有效授权,  CurUserID  登录用户ID
/// Return：
/// Creator：xy 
/// CreatDate：20210804
/// debug: w ##class(web.DHCPE.CT.PowerSuperUser).UpdatePowerSuperUser()
ClassMethod UpdatePowerSuperUser(PSURowid As %String, UserID As %String, GroupID As %String, PowerType As %String, EffPower As %String, CurUserID As %String)
{
	new (PSURowid,UserID,GroupID,PowerType,EffPower,CurUserID)
	Set Date=+$h
	Set Time=$p($h,",",2)    
    s obj=##class(User.DHCPEPowerSuperUser).%OpenId(PSURowid)
    s obj.PSUUserDR=UserID  
    s obj.PSUGroupDR=GroupID
    s obj.PSUPowerType=PowerType
    s obj.PSUEffPower=EffPower 
    S obj.PSUUpdateDate=Date
    S obj.PSUUpdateTime=Time
    S obj.PSUUpdateUserDR=CurUserID
    s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id_"^修改成功"
	}
}

/// Description: 查询体检超级用户授权表
/// Table：体检超级用户授权表 User.DHCPEPowerSuperUser 
/// Input: UserID 用户ID, GroupID 安全组ID, PowerType 权限类型
/// Return：
/// Creator：xy 
/// CreatDate：20210804
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.PowerSuperUser","SearchPowerSuperUser","12187")
Query SearchPowerSuperUser(UserID As %String = "", GroupID As %String = "", PowerType As %String = "", EffPower As %String = "Y") As %Query(ROWSPEC = "TPSUID,TPSUUserDR,TPSUUserName,TPSUGroupDR,TPSUGroupDesc,TPSUPowerTypeID,TPSUPowerType,TPSUEffPower,TUpdateDate,TUpdateTime,TUpdateUserName")
{
}

ClassMethod SearchPowerSuperUserExecute(ByRef qHandle As %Binary, UserID As %String = "", GroupID As %String = "", PowerType As %String = "", EffPower As %String = "Y") As %Status
{
	; d ##class(%ResultSet).RunQuery("web.DHCPE.CT.PowerSuperUser","SearchPowerSuperUser")
	S ^tempdhcpe("SearchPowerSuperUser")=$lb(UserID,GroupID,PowerType )
	Set repid=$I(^CacheTemp)
 	s ind=1
 
 	if (UserID'=""){
	 	s PSUGroup=""
	 	f  s PSUGroup=$O(^CF.PE.PowerSuperUserI("IdxOfUserGrp"," "_UserID,PSUGroup)) q:PSUGroup=""  d
	 	.s ID=""
	 	.f  s ID=$O(^CF.PE.PowerSuperUserI("IdxOfUserGrp"," "_UserID,PSUGroup,ID)) q:ID=""  d
	 	..d GetPowerSuperUserList 
 	}else{
	 	s ID=""
 		f  s ID=$O(^CF.PE.PowerSuperUserD(ID)) q:ID=""  d
 	    .d GetPowerSuperUserList   	   
 	   
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetPowerSuperUserList 
 	s PSUUserDR=$lg($g(^CF.PE.PowerSuperUserD(ID)),2)
 	s PSUUserName=""
 	i PSUUserDR'="" s PSUUserName=$p($g(^SSU("SSUSR",PSUUserDR)),"^",2)
 	
 	s PSUGroupDR=$lg($g(^CF.PE.PowerSuperUserD(ID)),3)
 	q:(GroupID'="")&&(GroupID'=PSUGroupDR)
 	s PSUGroupDesc=""
 	i PSUGroupDR'="" s PSUGroupDesc=$P($g(^SSU("SSGRP",PSUGroupDR)),"^",1)
 	
 	s PSUPowerTypeID=$lg($g(^CF.PE.PowerSuperUserD(ID)),4)
 	q:(PowerType'="")&&(PowerType'=PSUPowerTypeID)
 	S PSUPowerType=..GetPowerType(PSUPowerTypeID)
 	
 	s PSUEffPower=$lg($g(^CF.PE.PowerSuperUserD(ID)),5)
 	q:(EffPower'="")&&(EffPower'=PSUEffPower)
 	
 	s UpdateDate=$lg($g(^CF.PE.PowerSuperUserD(ID)),6)
	i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	
	s UpdateTime=$lg($g(^CF.PE.PowerSuperUserD(ID)),7)
	i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
	
	s UpdateUserDR=$lg($g(^CF.PE.PowerSuperUserD(ID)),8)
	s UpdateUserName=""
	i UpdateUserDR'="" s UpdateUserName=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
	
 	d FindBuild 
 	q
 	

FindBuild 
	set Data=$lb(ID,PSUUserDR,PSUUserName,PSUGroupDR,PSUGroupDesc,PSUPowerTypeID,PSUPowerType,PSUEffPower,UpdateDate,UpdateTime,UpdateUserName) 
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPowerSuperUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPowerSuperUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchPowerSuperUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPowerSuperUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 获取权限类型
/// Table： 
/// Input:  PowerTypeID 授权类型的ID
/// Return：
/// Creator：xy 
/// CreatDate：20210804
/// debug: w ##class(web.DHCPE.CT.PowerSuperUser).GetPowerType()
ClassMethod GetPowerType(PowerTypeID)
{
	new (PowerTypeID)
	q:PowerTypeID="" ""
	s PowerType=""
	i PowerTypeID="S" s PowerType="超级"
	i PowerTypeID="G" s PowerType="科室组"
	i PowerTypeID="L" s PowerType="科室"
	q PowerType
}

}
