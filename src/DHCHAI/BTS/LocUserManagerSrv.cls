/// 名称: DHCHAI.BTS.LocUserManagerSrv
/// 描述: 用户科室关联表
/// 编写者: liuzhenhe
/// 编写日期: 2022-09-22
Class DHCHAI.BTS.LocUserManagerSrv Extends %RegisteredObject
{

/// 批量导入用户科室关联表
/// d ##class(DHCHAI.BTS.LocUserManagerSrv).ImportLocUserManager("^HS01^内分泌科^感控专员^^2022-11-28^^1^^^Med^123456789","^")
ClassMethod ImportLocUserManager(aInputStr As %String, aSeparete As %String = "^")
{
    Set (ID,BTUserDr,BTLocDr,BTRole,BTModel,BTEffectDate,BTExpiryDate,BTIsActive,BTActDate,BTActTime,BTActUserDr,Phone)=""
    Quit:aInputStr="" "入参无值1"
    Set ^TMPLH=aInputStr
    Set ID = $p(aInputStr,aSeparete,1)
    Set BTUserCode = $p(aInputStr,aSeparete,2)
    Set BTLocDesc = $p(aInputStr,aSeparete,3)
    Set BTRoleCode = $p(aInputStr,aSeparete,4)
    Set BTModelCode= $p(aInputStr,aSeparete,5)
    Set BTEffectDate = $p(aInputStr,aSeparete,6)
    Set BTExpiryDate = $p(aInputStr,aSeparete,7)
    Set BTIsActive = $p(aInputStr,aSeparete,8)
    Set BTActDate = $p(aInputStr,aSeparete,9)
    Set BTActTime = $p(aInputStr,aSeparete,10)
    Set BTActUserCode = $p(aInputStr,aSeparete,11)
    Set Phone = $p(aInputStr,aSeparete,12)   //手机号
    Quit:(BTUserCode="")||(BTLocDesc="") "入参无值2"
    if (BTRoleCode="") {
        quit
    }else{
        Set:BTRoleCode["感控" BTRoleCode="LocHaiUser"
        Set:BTRoleCode["主任" BTRoleCode="LocDirectior"
    }
    
    Set BTUserDr=##class(DHCHAI.BT.SysUser).GetIDByCode(BTUserCode)
    Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(BTUserDr)
    Quit:'$IsObject(objUser) "用户无值1"
     
    Set (LocDesc,LocDesc2)=""
    Set:$IsObject(objUser.BTLocDr) LocDesc=objUser.BTLocDr.BTDesc
    Set:$IsObject(objUser.BTLocDr) LocDesc2=objUser.BTLocDr.BTDesc2
    
    Set:BTLocDesc="" BTLocDesc=LocDesc
    Quit:(LocDesc="")&&(LocDesc2="")
    if (LocDesc[BTLocDesc)||(LocDesc2[BTLocDesc){
        Set:$IsObject(objUser.BTLocDr) BTLocDr=objUser.BTLocDr.%Id()
    }else{
       Set objLocDr=##class(DHCHAI.BT.Location).GetObjByLocDesc2(BTLocDesc)
      
       if $IsObject(objLocDr){
           Set BTLocDr=objLocDr.%Id()
       }else{
            //Set ^TMPLH=$lb(ID,BTUserDr,BTLocDr,BTRole,BTModel,BTEffectDate,BTExpiryDate)
        quit "科室无值1"
       }
    }
    Set objRole=##class(DHCHAI.BT.Dictionary).GetObjByCode("LocUserRole",BTRoleCode)
    Set:$IsObject(objRole) BTRole=objRole.%Id()
    Set objModel=##class(DHCHAI.BT.Dictionary).GetObjByCode("HAIModel",BTModelCode)
    Set:$IsObject(objModel) BTModel=objModel.%Id()
    Set BTActUserDr=##class(DHCHAI.BT.SysUser).GetIDByCode(BTActUserCode)
    Set:BTExpiryDate="无" BTExpiryDate=""
    Set:BTExpiryDate="至今" BTExpiryDate=""
    Set InputStr="",aSeparete="^"
    Set $p(InputStr,aSeparete,1)=""
    Set $p(InputStr,aSeparete,2)=BTUserDr
    Set $p(InputStr,aSeparete,3)=BTLocDr
    Set $p(InputStr,aSeparete,4)=BTRole
    Set $p(InputStr,aSeparete,5)=BTModel
    Set $p(InputStr,aSeparete,6)=BTEffectDate
    Set $p(InputStr,aSeparete,7)=BTExpiryDate
    Set $p(InputStr,aSeparete,8)=BTIsActive
    Set $p(InputStr,aSeparete,9)=BTActDate
    Set $p(InputStr,aSeparete,10)=BTActTime
    Set $p(InputStr,aSeparete,11)=BTActUserDr
    
    Set ret= ##class(DHCHAI.BT.LocUserManager).Update(InputStr, aSeparete)
    if (Phone'="")&&(ret>0){
        do ##class(DHCHAI.BT.SysUser).ChangePhone(BTUserDr,Phone)
    }
   // Set ^TMPLH=aInputStr_"^"_Phone
    Quit ret
}

///  js更新用户科室关联表及手机号
///  d ##class(DHCHAI.BTS.LocUserManagerSrv).Update("1^19^1^123^2022-09-01^2022-09-01^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^")
{
    Set return=0
    Quit:aInputStr="" return
    Set ID = $p(aInputStr,aSeparete,1)
    Set BTUserDr = $p(aInputStr,aSeparete,2)
    Set BTLocDr = $p(aInputStr,aSeparete,3)
    Set Phone = $p(aInputStr,aSeparete,4)
    
    Set BTEffectDate = $p(aInputStr,aSeparete,5)
    Set BTExpiryDate = $p(aInputStr,aSeparete,6)
    Set BTIsActive = $p(aInputStr,aSeparete,7)
    Quit:(BTUserDr="")||(BTLocDr="")
    Set InputStr=""
    Set $p(InputStr,aSeparete,1)=ID
    Set $p(InputStr,aSeparete,2)=BTUserDr
    Set $p(InputStr,aSeparete,3)=BTLocDr
    Set $p(InputStr,aSeparete,6)=BTEffectDate
    Set $p(InputStr,aSeparete,7)=BTExpiryDate
    Set $p(InputStr,aSeparete,8)=BTIsActive

    set ret= ##class(DHCHAI.BT.LocUserManager).Update(InputStr, aSeparete)
    if ret>0{
        do ##class(DHCHAI.BT.SysUser).ChangePhone(BTUserDr,Phone)
    }
    quit ret
}

/// Creator：     liuzhenhe
/// CreatDate：   2022-09-22
/// Description:  根据科室获取各用户(HIS标识)
/// Table：       DHCHAI.BT.LocUserManager
/// Input：       aId 
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.LocUserManagerSrv).GetUserByLocID(1)
ClassMethod GetUserByLocID(aLocId As %String, aRole As %String = "", aModel As %String = "") As %String
{
    Set return=""
    Quit:aLocId="" return
     Set xLocID=0
    For {
        Set xLocID=$o(^MA.HAI.BT.LocUserManagerI("IndexLocUserDr",xLocID))
        Quit:xLocID=""
        Continue:(aLocId'="")&&(aLocId'=xLocID)

        Set xUserID=""
        For {
            Set xUserID=$o(^MA.HAI.BT.LocUserManagerI("IndexLocUserDr",xLocID,xUserID))
            Quit:xUserID=""
           
            Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(xUserID)
            Continue:'$IsObject(objUser)
            Set return=return_","_$p(objUser.BTXCode,"||",2)
        }
    }

    Set:return'="" return=$e(return,2,$l(return)) 
    Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2022-09-22
/// Description:  查询用户科室等关联信息
/// Input:        aSearch以分割符分割 用户工号 用户姓名 角色 所属模块
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.LocUserManagerSrv","QryLocUserManager","1|2","","","")
Query QryLocUserManager(aHospIDs As %String, aLocID As %String, aIsActive As %String, aSearch As %String = "") As %Query(ROWSPEC = "xID,xLocID,LocDesc2,UserID,UserCode,UserName,UserType,PhoneNo,EffectDate,ExpiryDate,IsActive,ActDate,ActTime,ActUserID,ActUserName") [ SqlProc ]
{
}

ClassMethod QryLocUserManagerExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aIsActive As %String, aSearch As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set (aUserCode,aUserName,Role,Model)=""
    if aSearch'=""{
        Set aUserCode=$p("aSearch","^",1)
        Set aUserName=$p("aSearch","^",2)
        Set Role=$p("aSearch","^",3)
        Set Model=$p("aSearch","^",4)
    }
    Set xLocID=0
    For {
        Set xLocID=$o(^MA.HAI.BT.LocUserManagerI("IndexLocUserDr",xLocID))
        Quit:xLocID=""
        Continue:(aLocID'="")&&(aLocID'=xLocID)

        Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
        Continue:'$IsObject(objLoc)
        Set LocDesc=objLoc.BTDesc
        Set LocDesc2=objLoc.BTDesc2
        Set:LocDesc2="" LocDesc2=LocDesc
        b ;4
        Set xUserID=""
        For {
            Set xUserID=$o(^MA.HAI.BT.LocUserManagerI("IndexLocUserDr",xLocID,xUserID))
            Quit:xUserID=""
            //Continue:(xUserID'="")&&(aWardID'=xUserID)
            Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(xUserID)
            Continue:'$IsObject(objUser)
            
            Set xID=""
            For {
                Set xID=$o(^MA.HAI.BT.LocUserManagerI("IndexLocUserDr",xLocID,xUserID,xID))
                Quit:xID=""
                
                Set obj=##class(DHCHAI.BT.LocUserManager).GetObjById(xID)
                Continue:'$IsObject(obj)
                Set IsActive=+obj.BTIsActive
                Continue:(aIsActive'="")&&(IsActive'=aIsActive)
                Set IsActive=$case(IsActive,1:"是",0:"否",:"否")
                Set UserDr=obj.BTUserDr
                Set (UserID,UserCode,UserName,UserTypeDr,UserType)=""
                Set PhoneNo=""
                If $IsObject(UserDr){
                    Set UserID=UserDr.%Id()
                    Set UserCode=UserDr.BTCode
                    Set UserName=UserDr.BTDesc
                    Set UserTypeDr=UserDr.BTTypeDr
                    Set:$IsObject(UserTypeDr) UserType=UserTypeDr.BTDesc
                    Set PhoneNo=UserDr.BTPhoneNo
                }
                Continue:(aUserCode'="")&&($ZCVT(UserCode,"U")'[$ZCVT(aUserCode,"U"))
                Continue:(aUserName'="")&&(UserName'[aUserName)
                
                Set EffectDate=obj.BTEffectDate
                Set ExpiryDate=obj.BTExpiryDate
                Set ActDate=obj.BTActDate
                Set:EffectDate'="" EffectDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EffectDate)
                Set:ExpiryDate'="" ExpiryDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExpiryDate)
                Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
                Set ActTime=obj.BTActTime
                Set:ActTime'="" ActTime=$zt(ActTime,1)
                Set ActUserDr=obj.BTActUserDr
                Set (ActUserID,ActUserName)=""
                If $IsObject(ActUserDr){
                    Set ActUserID=ActUserDr.%Id()
                    Set ActUserName=ActUserDr.BTDesc
                }
                Set Data=$lb(xID,xLocID,LocDesc2,UserID,UserCode,UserName,UserType,PhoneNo,EffectDate,ExpiryDate,IsActive,ActDate,ActTime,ActUserID,ActUserName)
                Set ^CacheTemp(repid,ind)=Data
                Set ind=ind+1
            }
        }
    }
    Quit $$$OK
}

ClassMethod QryLocUserManagerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocUserManagerExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryLocUserManagerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocUserManagerExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

}
