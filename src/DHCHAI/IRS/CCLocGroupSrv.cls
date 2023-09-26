/// 名称: DHCHAI.IRS.CCLocGroupSrv
/// 描述: 院感工作科室分组相关服务
/// 编写者：zhoubo
/// 编写日期: 2018-01-05
Class DHCHAI.IRS.CCLocGroupSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-03-22
/// Description:  查询科室列表----工作组分组使用
/// Table：       DHCHAI.BT.Location
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用"|"连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCLocGroupSrv","QryLoc","","","","","")
Query QryLoc(aHospIDs As %String, aGrpType As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,LocTypeDr:%String,LocTypeCode:%String,LocTypeDesc:%String,LocCateDr:%String,LocCateCode:%String,LocCateDesc:%String,GroupDr:%String,GroupCode:%String,GroupDesc:%String,HospDr:%String,HospCode:%String,HospDesc:%String,IsOPER:%String,IsICU:%String,IsNICU:%String,ICUTpDr:%String,ICUTpCode:%String,ICUTpDesc:%String,XCode:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,ParLocDr:%String,LocUser:%String,CCLocGroupID:%String,LocUserID:%String") [ SqlProc ]
{
}

ClassMethod QryLocExecute(ByRef qHandle As %Binary, aHospIDs As %String, aGrpType As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aGrpType="" $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	 
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
	    Continue:(aHospIDs'="")&($listfind(aHospIDs,xHospID)<1)
	    
		Set xID=0
		For {
			Set xID = $o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xID))
			Quit:xID=""
			Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xID)
			Continue:'$isobject(objLoc)
			
			Set (LocCode,LocDesc,LocDesc2,LocTypeCode,LocTypeDesc,LocCateCode,LocCateDesc,GroupCode,GroupDesc)=""
			Set (HospCode,HospDesc,IsICU,IsNICU,ICUTpCode,ICUTpDesc,IsActive,ActDate,ActTime,ActUserCode,ActUserDesc)=""
			Set LocCode	    = objLoc.BTCode
			Set LocDesc	    = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objLoc.BTDesc)
			Set LocDesc2	= ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(objLoc.BTDesc2)
			Continue:(aIsActive'="")&&((LocDesc["停用")||(LocDesc2["停用"))		
			Set:LocDesc2="" LocDesc2 = LocDesc
			Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
			Continue:(aAlias'="")&&((LocCode'[aAlias)&&(LocDesc'[aAlias)&&(LocDesc2'[aAlias))
		
			Set LocTypeDr="",LocTypeCode="",LocTypeDesc=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocTypeDr 	= objLoc.BTTypeDr.%Id()
				Set LocTypeCode	= objLoc.BTTypeDr.BTCode
				Set LocTypeDesc	= objLoc.BTTypeDr.BTDesc
			}
			Continue:(aLocType'="")&&(aLocType'=LocTypeCode)
			Set LocCateDr="",LocCateCode="",LocCateDesc=""
			If $IsObject(objLoc.BTCateDr) {
				Set LocCateDr 	= objLoc.BTCateDr.%Id()
				Set LocCateCode	= objLoc.BTCateDr.BTCode
				Set LocCateDesc	= objLoc.BTCateDr.BTDesc
			}
			Continue:(aLocCate'="")&&(aLocCate'=LocCateCode)
			Set GroupDr="",GroupCode="",GroupDesc=""
			If $IsObject(objLoc.BTGroupDr) {
				Set GroupDr 	= objLoc.BTGroupDr.%Id()
				Set GroupCode	= objLoc.BTGroupDr.BTCode
				Set GroupDesc	= objLoc.BTGroupDr.BTDesc	
			}
			
		    Set LocHospDr="",HospCode="",HospDesc=""
			If $IsObject(objLoc.BTHospDr) {
				Set LocHospDr 	= objLoc.BTHospDr.%Id()
				Set HospCode	= objLoc.BTHospDr.BTCode
				Set HospDesc	= objLoc.BTHospDr.BTDesc
			}
			
			Set IsOPER	    = objLoc.BTIsOPER
			Set IsOPER=$s(IsOPER=1:"是",IsOPER=0:"否",1:"是")
			Set IsICU	    = objLoc.BTIsICU
			Set IsICU=$s(IsICU=1:"是",IsICU=0:"否",1:"是")
			Set IsNICU	    = objLoc.BTIsNICU
			Set IsNICU=$s(IsNICU=1:"是",IsNICU=0:"否",1:"是")
			
		    Set ICUTpDr="",ICUTpCode="",ICUTpDesc=""
			If $IsObject(objLoc.BTICUTpDr) {
				Set ICUTpDr = objLoc.BTICUTpDr.%Id()
				Set ICUTpCode	= objLoc.BTICUTpDr.BTCode
				Set ICUTpDesc	= objLoc.BTICUTpDr.BTDesc
			}
			Set XCode = objLoc.BTXCode
			Set IsActive	= objLoc.BTIsActive
			Continue:(aIsActive'="")&&(IsActive'=aIsActive)
			Set IsActive=$s(IsActive=1:"是",IsActive=0:"否",1:"是")	
			Set ActDate     = objLoc.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime     = objLoc.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			
		    Set ActUserCode="",ActUserDesc=""
			If $IsObject(objLoc.BTActUserDr) {
				Set ActUserCode = objLoc.BTActUserDr.BTCode
				Set ActUserDesc = objLoc.BTActUserDr.BTDesc
			}
			Set ParLocDr=""
			If $IsObject(objLoc.BTParLocDr) {
				Set ParLocDr=objLoc.BTParLocDr.%Id()
			}
			// 取院感科室分组信息
			Set CCLocGroupID="",LocUser="",LocUserID=""
			Set xGrpID=""
			For {
				Set xGrpID=$o(^DHCHAI.IR.CCLocGroupI("IndexLocType",xID,aGrpType,xGrpID),-1)
				Quit:xGrpID=""
				Set objGrpLoc = ##class(DHCHAI.IR.CCLocGroup).GetObjById(xGrpID)
				Continue:'$isobject(objGrpLoc)
				Set CCLocGroupID=xGrpID
				Continue:'$IsObject(objGrpLoc.CCLocUser)
				Set LocUser=objGrpLoc.CCLocUser.BTDesc
				Set LocUserID=objGrpLoc.CCLocUser.%Id()
				Quit:LocUser'=""
			}
			Set Data=$lb(xID,LocCode,LocDesc,LocDesc2,LocTypeDr,LocTypeCode,LocTypeDesc,LocCateDr,LocCateCode,LocCateDesc,GroupDr,GroupCode,GroupDesc,LocHospDr,HospCode,HospDesc,IsOPER,IsICU,IsNICU,ICUTpDr,ICUTpCode,ICUTpDesc,XCode,IsActive,ActDate,ActTime,ActUserCode,ActUserDesc,ParLocDr,LocUser,CCLocGroupID,LocUserID)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2019-06-19
/// Description:  查询工作组
/// Table：       DHCHAI.BT.Location
///               aHospIDs  : 医院代码 多值"^"分割
///               aViewFlag : 按科室/病区分组（E科室、W病区）
///               aGrpType  : 分组类型
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用"|"连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCLocGroupSrv","QryLocGroupUser","1","W","359")
Query QryLocGroupUser(aHospIDs As %String, aViewFlag As %String, aGrpType As %String) As %Query(ROWSPEC = "ID:%String,GroupUser:%String") [ SqlProc ]
{
}

ClassMethod QryLocGroupUserExecute(ByRef qHandle As %Binary, aHospIDs As %String, aViewFlag As %String, aGrpType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aGrpType="" $$$OK
	Kill ^TMP($zn,$j,"QryLocGroupUser")
	Set:aViewFlag="" aViewFlag="W"
	
	Set Count=0
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	 
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
	    Continue:(aHospIDs'="")&($listfind(aHospIDs,xHospID)<1)
	    
	    Set LocGroupFlg=##class(DHCHAI.BT.Config).GetValByCode("IRScreenIsGroup",xHospID)
	    If (LocGroupFlg=0) {
		    Set LocUser="全部工作组"
		    Set ^TMP($zn,$j,"QryLocGroupUser",1,LocUser)=""
		    Continue
	    }
		Set xID=0
		For {
			Set xID = $o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xID))
			Quit:xID=""
			Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xID)
			Continue:'$isobject(objLoc)
			
			Set LocTypeDr="",LocTypeCode="",LocTypeDesc=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocTypeDr 	= objLoc.BTTypeDr.%Id()
				Set LocTypeCode	= objLoc.BTTypeDr.BTCode
				Set LocTypeDesc	= objLoc.BTTypeDr.BTDesc
			}
			Continue:(aViewFlag'="")&&(aViewFlag'=LocTypeCode)
			
			// 取院感科室分组信息
			Set CCLocGroupID="",LocUser=""
			Set xGrpID=""
			For {
				Set xGrpID=$o(^DHCHAI.IR.CCLocGroupI("IndexLocType",xID,aGrpType,xGrpID),-1)
				Quit:xGrpID=""
				Set objGrpLoc = ##class(DHCHAI.IR.CCLocGroup).GetObjById(xGrpID)
				Continue:'$isobject(objGrpLoc)
				Set CCLocGroupID=xGrpID
				Continue:'$IsObject(objGrpLoc.CCLocUser)
				Set LocUser=objGrpLoc.CCLocUser.BTDesc
			}
			Set:LocUser="" LocUser="其他科"
			
			If '$d(^TMP($zn,$j,"QryLocGroupUser",LocUser)){
				Set Count = Count+1
				Set ^TMP($zn,$j,"QryLocGroupUser",LocUser)=""
				Set ^TMP($zn,$j,"QryLocGroupUser",Count,LocUser)=""
			}
		}	
	
	}
	Set xNum ="" 
	For {
		Set xNum = $o(^TMP($zn,$j,"QryLocGroupUser",xNum))
		Quit:xNum=""
		Set xLocUser=""
		For {
			Set xLocUser = $o(^TMP($zn,$j,"QryLocGroupUser",xNum,xLocUser))
			Quit:xLocUser=""
			
			Set Data=$lb(xNum,xLocUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
	
		
	Kill ^TMP($zn,$j,"QryLocGroupUser")
	
	Quit $$$OK
}

ClassMethod QryLocGroupUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocGroupUserExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocGroupUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocGroupUserExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2023-04-20
/// Description:  根据用户获取用户工作组
/// Table：       DHCHAI.IR.CCLocGroup
///               aHospIDs  : 医院代码 多值"^"分割
///               aGrpType  : 分组类型
///               aUserID   : 用户
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用"|"连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCLocGroupSrv","QryUserLocGroup","1","","23")
Query QryUserLocGroup(aHospIDs As %String, aGrpType As %String, aUserID As %String) As %Query(ROWSPEC = "ID:%String,LocUserID:%String,LocUser:%String,LocID:%String,LocCode:%String,LocDesc:%String,LocTypeDr:%String,LocTypeCode:%String,LocTypeDesc:%String,LocCateDr:%String,LocCateCode:%String,LocCateDesc:%String,IsActive:%String,IsActDesc:%String,EffectDate:%String,ExpiryDate:%String") [ SqlProc ]
{
}

ClassMethod QryUserLocGroupExecute(ByRef qHandle As %Binary, aHospIDs As %String, aGrpType As %String, aUserID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aUserID="" $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	 
	Set xLocGroup=""
	For {
		Set xLocGroup=$o(^DHCHAI.IR.CCLocGroupI("IndexUserGroup",aUserID,xLocGroup))
		Quit:xLocGroup=""
		
	    Continue:(aGrpType'="")&(aGrpType'=xLocGroup)
	    
		Set xID=0
		For {
			Set xID = $o(^DHCHAI.IR.CCLocGroupI("IndexUserGroup",aUserID,xLocGroup,xID))
			Quit:xID=""
			Set objGrpLoc = ##class(DHCHAI.IR.CCLocGroup).GetObjById(xID)
			Continue:'$isobject(objGrpLoc)
			Continue:'$isobject(objGrpLoc.CCLocDr)
			
			Set LocUser=objGrpLoc.CCLocUser.BTDesc
			
			Set LocID="",LocCode="",LocDesc=""
			If $IsObject(objGrpLoc.CCLocDr) {
				Set LocID 	= objGrpLoc.CCLocDr.%Id()
				Set LocCode	= objGrpLoc.CCLocDr.BTCode
				Set LocDesc	= objGrpLoc.CCLocDr.BTDesc
			}
			Set LocHospDr=""
			If $IsObject(objGrpLoc.CCLocDr.BTHospDr) {
				Set LocHospDr 	= objGrpLoc.CCLocDr.BTHospDr.%Id()
			}
			Continue:(aHospIDs'="")&($listfind(aHospIDs,LocHospDr)<1)
			  
			Set EffectDate	= objGrpLoc.BTEffectDate
			Set:EffectDate'="" EffectDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EffectDate)
			Set ExpiryDate	= objGrpLoc.BTExpiryDate
			Set:ExpiryDate'="" ExpiryDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExpiryDate)
			Set IsActive	= objGrpLoc.BTIsActive
			Set IsActDesc =$s(IsActive=1:"是",IsActive=0:"否",1:"是")
			Set LocTypeDr="",LocTypeCode="",LocTypeDesc=""
			If $IsObject(objGrpLoc.CCLocDr.BTTypeDr) {
				Set LocTypeDr 	= objGrpLoc.CCLocDr.BTTypeDr.%Id()
				Set LocTypeCode	= objGrpLoc.CCLocDr.BTTypeDr.BTCode
				Set LocTypeDesc	= objGrpLoc.CCLocDr.BTTypeDr.BTDesc
			}
			Set LocCateDr="",LocCateCode="",LocCateDesc=""
			If $IsObject(objGrpLoc.CCLocDr.BTCateDr) {
				Set LocCateDr 	= objGrpLoc.CCLocDr.BTCateDr.%Id()
				Set LocCateCode	= objGrpLoc.CCLocDr.BTCateDr.BTCode
				Set LocCateDesc	= objGrpLoc.CCLocDr.BTCateDr.BTDesc
			}
			
			Set Data=$lb(xID,LocUserID,LocUser,LocID,LocCode,LocDesc,LocTypeDr,LocTypeCode,LocTypeDesc,LocCateDr,LocCateCode,LocCateDesc,IsActive,IsActDesc,EffectDate,ExpiryDate)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
			
	Quit $$$OK
}

ClassMethod QryUserLocGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserLocGroupExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUserLocGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserLocGroupExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2023-04-20
/// Description:  批量新增
/// Table：       DHCHAI.IR.CCLocGroup
///               aInputStr 
///               aSeparete  
/// Input：       
/// d ##class(DHCHAI.IRS.CCLocGroupSrv).BatchSave("^1^361^2^^8^2023-04-23^^1","^")
ClassMethod BatchSave(aInputStr As %String, aSeparete As %String = "^")
{
	New (aInputStr,aSeparete)
    Set return=0,Flg=0
    Quit:aInputStr="" return
    
    Set $ZT="BatchSaveErr"

    Set ID         = $p(aInputStr,aSeparete,1)
    Set LocIDs     = $p(aInputStr,aSeparete,2)
    Set GroupDr    = $p(aInputStr,aSeparete,3)
    Set UserDr     = $p(aInputStr,aSeparete,4)
    Set Phone      = $p(aInputStr,aSeparete,5)
    Set UpdateUser = $p(aInputStr,aSeparete,6)
    Set EffectDate = $p(aInputStr,aSeparete,7)
    Set ExpiryDate = $p(aInputStr,aSeparete,8)
    Set IsActive   = +$p(aInputStr,aSeparete,9)
    Quit:(LocIDs="")||(UserDr="") return
        
    TStart 
    
    Set InputStr=""
    Set Len = $l(LocIDs,",")
    For indL=1:1:Len {
	    Set LocID =$p(LocIDs,",",indL)
	    Continue:LocID=""

	    Set $p(InputStr,aSeparete,1)=ID
	    Set $p(InputStr,aSeparete,2)=LocID
	    Set $p(InputStr,aSeparete,3)=GroupDr
	    Set $p(InputStr,aSeparete,4)=UserDr
	    Set $p(InputStr,aSeparete,7)=UpdateUser
	    Set $p(InputStr,aSeparete,8)=EffectDate
	    Set $p(InputStr,aSeparete,9)=ExpiryDate
	    Set $p(InputStr,aSeparete,10)=IsActive

	    Set ret= ##class(DHCHAI.IR.CCLocGroup).Update(InputStr, aSeparete)
	    Set:(+ret<1) Flg=1
	   
    }
    If (Flg=1) TRollback
  	
  	TCommit
  	Set return=1
  	
    Quit return
	
BatchSaveErr
	Set $ZT=""
 	TRollback
	Quit -999_"^"_$ZError
}

/// Description:  获取工作组下科室关联用户
/// Table：       DHCHAI.IR.CCLocGroup
/// Input:        aGrpType , aLocID , aIsActive              
/// return:       用户ID 代码 名称 有效开始时间 有效截止时间
/// Creator：     lzh
/// CreatDate：   2023-01-19
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCLocGroupSrv","QryUser","362","4","123")
/// d ##class(DHCHAI.IR.CCLocGroup).%BuildIndices()
Query QryUser(aGrpType As %String, aLocID As %String, aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID,LocID,CCLocUser,UserCode,UserDesc,PhoneNo,BTEffectDate,BTExpiryDate,IsActive,UpdateDate,UpdateUser")
{
}

ClassMethod QryUserExecute(ByRef qHandle As %Binary, aGrpType As %String, aLocID As %String, aAlias As %String = "", aIsActive As %String = "") As %Status
{
 
    
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:(aGrpType="")||(aLocID="") $$$OK
    Quit:'$d(^DHCHAI.IR.CCLocGroupI("IndexGroupLocUser",aGrpType,aLocID)) $$$OK
    Kill ^TMP($zn,$j,"QryUser")
    Set CCLocUser=""
    
    for {
        Set CCLocUser=$o(^DHCHAI.IR.CCLocGroupI("IndexGroupLocUser",aGrpType,aLocID, CCLocUser))
        Quit:CCLocUser=""
        Set GroupID=$o(^DHCHAI.IR.CCLocGroupI("IndexGroupLocUser",aGrpType,aLocID, CCLocUser,""),-1)
        Set obj=##class(DHCHAI.IR.CCLocGroup).GetObjById(GroupID)
        Set BTEffectDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(obj.BTEffectDate)
        Set BTExpiryDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(obj.BTExpiryDate)
        Set UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(obj.UpdateDate)
        Set UpdateUserDr=obj.UpdateUserDr,UpdateUser=""
        Set:$IsObject(UpdateUserDr) UpdateUser=UpdateUserDr.BTDesc
        Set IsActive =obj.BTIsActive
        Continue:(aIsActive'="")&&(IsActive'=aIsActive)
        Set IsActive=$s(IsActive=1:"是",IsActive=0:"否",1:"是")    
        Set User=obj.CCLocUser,(UserCode,UserDesc)=""
        if $IsObject(User) {
            Set UserCode=User.BTCode
            Set UserDesc=User.BTDesc
            Set PhoneNo=User.BTPhoneNo
            Continue:(aAlias'="")&&((UserCode'[aAlias)&&(UserDesc'[aAlias))
            Set Data=$lb(GroupID,aLocID,CCLocUser,UserCode,UserDesc,PhoneNo,BTEffectDate,BTExpiryDate,IsActive,UpdateDate,UpdateUser)
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
        }
        
    }
    
    Kill ^TMP($zn,$j,"QryUser")
    Quit $$$OK
}

ClassMethod QryUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserExecute ]
{
    set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserExecute ]
{
    set AtEnd=$LIST(qHandle,1)
    set repid=$LIST(qHandle,2)
    set ind=$LIST(qHandle,3)
    set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        set AtEnd=1
        set Row=""
    }
    Else      {             // fetch row
        set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

///  js更新用户科室关联表及手机号
///  d ##class(DHCHAI.IRS.CCLocGroupSrv).Update("^1^1280^3^23434^8^2023-01-19^^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^")
{
    Set return=0
    
    Quit:aInputStr="" return
    Set ID = $p(aInputStr,aSeparete,1)
    Set BTLocDr = +$p(aInputStr,aSeparete,2)
    Set CCLocGroupDr = +$p(aInputStr,aSeparete,3)
    Set BTUserDr = +$p(aInputStr,aSeparete,4)
    Set Phone = $p(aInputStr,aSeparete,5)
   
    Set UpdateUserDr = +$p(aInputStr,aSeparete,6)
    Set BTEffectDate = $p(aInputStr,aSeparete,7)
    Set BTExpiryDate = $p(aInputStr,aSeparete,8)
    Set BTIsActive = $p(aInputStr,aSeparete,9)
    
    Quit:(BTUserDr="")||(BTLocDr="")||(CCLocGroupDr="") return

    Set InputStr=""
    Set $p(InputStr,aSeparete,1)=ID
    Set $p(InputStr,aSeparete,2)=BTLocDr
    Set $p(InputStr,aSeparete,3)=CCLocGroupDr
    Set $p(InputStr,aSeparete,4)=BTUserDr
    Set $p(InputStr,aSeparete,7)=UpdateUserDr
    Set $p(InputStr,aSeparete,8)=BTEffectDate
    Set $p(InputStr,aSeparete,9)=BTExpiryDate
    Set $p(InputStr,aSeparete,10)=BTIsActive

    set ret= ##class(DHCHAI.IR.CCLocGroup).Update(InputStr, aSeparete)
    
    if ret>0{
        do ##class(DHCHAI.BT.SysUser).ChangePhone(BTUserDr,Phone)
    }
    quit ret
}

/// Creator：     lzh
/// CreatDate：   2023-01-19
/// Description:  根据科室获取各用户(HIS标识)
/// Table：       DHCHAI.IR.CCLocGroup
/// Input：       aId 
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.CCLocGroupSrv).GetUserByLocID("3",1)
ClassMethod GetUserByLocID(aGrpTypeCode As %String, aLocID As %String, aIsActive As %String = "1") As %String
{
    Set return=""
    
    Set aGrpType=##class(DHCHAI.BT.Dictionary).GetIDByCode("CCLocGroupType",aGrpTypeCode)
    Quit:(aGrpType="")||(aLocID="") return
    Quit:'$d(^DHCHAI.IR.CCLocGroupI("IndexGroupLocUser",aGrpType,aLocID)) return
    Kill ^TMP($zn,$j,"QryUser")
    Set CCLocUser=""
    
    for {
        Set CCLocUser=$o(^DHCHAI.IR.CCLocGroupI("IndexGroupLocUser",aGrpType,aLocID, CCLocUser))
        Quit:CCLocUser=""
        Set GroupID=$o(^DHCHAI.IR.CCLocGroupI("IndexGroupLocUser",aGrpType,aLocID, CCLocUser,""),-1)
        Set obj=##class(DHCHAI.IR.CCLocGroup).GetObjById(GroupID)
        Set IsActive =obj.BTIsActive
        Continue:(aIsActive'="")&&(IsActive'=aIsActive)
        Set User=obj.CCLocUser,(UserCode,UserDesc)=""
        if $IsObject(User) {
            Set IsActive= User.BTIsActive
            Continue:(aIsActive'="")&&(IsActive'=aIsActive)
            Set return=return_","_$p(User.BTXCode,"||",2)
        }
    }
    Set:return'="" return=$e(return,2,$l(return)) 
    Quit return
}

}
