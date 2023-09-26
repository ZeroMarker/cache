/// 名称: DHCHAI.BTS.LocationSrv
/// 描述: 科室相关服务
/// 编写者：pylian
/// 编写日期: 2017-03-21
Class DHCHAI.BTS.LocationSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-03-22
/// Description:  查询科室列表
/// Table：       DHCHAI.BT.Location
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用"|"连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.LocationSrv","QryLoc","1","","I","E","1")
Query QryLoc(aHospIDs As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "ID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,LocTypeDr:%String,LocTypeCode:%String,LocTypeDesc:%String,LocCateDr:%String,LocCateCode:%String,LocCateDesc:%String,GroupDr:%String,GroupCode:%String,GroupDesc:%String,HospDr:%String,HospCode:%String,HospDesc:%String,IsOPER:%String,IsICU:%String,IsNICU:%String,ICUTpDr:%String,ICUTpCode:%String,ICUTpDesc:%String,XCode:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,ParLocDr:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QryLocExecute(ByRef qHandle As %Binary, aHospIDs As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	 
	Set aLocCate=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocCate,"|")	 
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
			Continue:(aLocID'="")&&(xID'=aLocID)	//增加科室过滤
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
			//特殊判断(职业暴露加载 科室+其他 [不加载病区])
			If (aLocType="OELocType"){
				Continue:LocTypeCode="W"
			}
			ElseIf (aLocType="OWLocType"){  //特殊判断(职业暴露加载 病区+其他 [不加载科室])
				Continue:LocTypeCode="E"
			}
			Else{
				Continue:(aLocType'="")&&(aLocType'=LocTypeCode)
			}
			Set LocCateDr="",LocCateCode="",LocCateDesc=""
			If $IsObject(objLoc.BTCateDr) {
				Set LocCateDr 	= objLoc.BTCateDr.%Id()
				Set LocCateCode	= objLoc.BTCateDr.BTCode
				Set LocCateDesc	= objLoc.BTCateDr.BTDesc
			}
			Continue:(aLocCate'="")&&($listfind(aLocCate,LocCateCode)<1)
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
			Set IndNo = objLoc.BTIndNo
			//多语言处理
			Set LocDesc2=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc2,"User.CTLoc")
			Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
			Set Data=$lb(xID,LocCode,LocDesc,LocDesc2,LocTypeDr,LocTypeCode,LocTypeDesc,LocCateDr,LocCateCode,LocCateDesc,GroupDr,GroupCode,GroupDesc,LocHospDr,HospCode,HospDesc,IsOPER,IsICU,IsNICU,ICUTpDr,ICUTpCode,ICUTpDesc,XCode,IsActive,ActDate,ActTime,ActUserCode,ActUserDesc,ParLocDr,IndNo)
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
/// CreatDate：   2017-08-08
/// Description:  根据医院查询医院分组下的科室列表
/// Table：       DHCHAI.BT.Location
/// Input：       aHospID:DHCHAI.BT.Hospital.ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.LocationSrv","QryLocSrv","3","","I","E","1")
Query QryLocSrv(aHospID As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aIsGroup As %String = "") As %Query(ROWSPEC = "ID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,LocTypeDr:%String,LocTypeCode:%String,LocTypeDesc:%String,LocCateDr:%String,LocCateCode:%String,LocCateDesc:%String,GroupDr:%String,GroupCode:%String,GroupDesc:%String,HospDr:%String,HospCode:%String,HospDesc:%String,IsOPER:%String,IsICU:%String,IsNICU:%String,ICUTpDr:%String,ICUTpCode:%String,ICUTpDesc:%String,XCode:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLocSrvExecute(ByRef qHandle As %Binary, aHospID As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aIsGroup As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aHospID="") $$$OK
	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(aHospID)
	Quit:'$Isobject(objHosp) $$$OK
	Set HospGrpID="",HospGrpCode="",HospGrpDesc=""
	If $Isobject(objHosp.BTGroupDr) {
		Set HospGrpID=objHosp.BTGroupDr.%Id()
		Set HospGrpCode=objHosp.BTGroupDr.BTCode
		Set HospGrpDesc=objHosp.BTGroupDr.BTDesc
		
	}
	Quit:HospGrpID="" $$$OK

	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.HospitalI("IndexHospGroupDr",HospGrpID,xHospID))
		Quit:xHospID=""
	    Continue:((aIsGroup'="")&&(aIsGroup'=1)&&(xHospID'=aHospID))  //aIsGroup=1或空：按登陆医院查找医院分组下的科室，其他：只查找登陆医院下的科室
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
			Continue:(aIsActive'="")&&(aIsActive'=IsActive)
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
			Set:LocDesc2'="" LocDesc=LocDesc2
			//多语言处理
			Set LocDesc =##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
			Set Data=$lb(xID,LocCode,LocDesc,LocDesc2,LocTypeDr,LocTypeCode,LocTypeDesc,LocCateDr,LocCateCode,LocCateDesc,GroupDr,GroupCode,GroupDesc,LocHospDr,HospCode,HospDesc,IsOPER,IsICU,IsNICU,ICUTpDr,ICUTpCode,ICUTpDesc,XCode,IsActive,ActDate,ActTime,ActUserCode,ActUserDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryLocSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocSrvExecute ]
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

/// Creator：     liyi
/// CreatDate：   2016-07-21
/// Description:  检查HIS科室是否属于医院
/// Input：       aCTLocID：HIS科室ID
/// 			  aCTHospCode ：HIS医院代码
/// Return：      1：是 、0：否
/// w ##class(DHCMed.DCSrv.HospSrv).CheckHospital("")
ClassMethod CheckHospital(aCTLocID As %String, aCTHospCode As %String)
{
	New (aCTHospCode,aCTLocID)
	Set return=0
	Quit:'$d(^CTLOC(aCTLocID)) return
	
	Set HospitalID=$p($g(^CTLOC(aCTLocID)),"^",22)
	Quit:HospitalID="" return
	
	Set CTHospCode = $p($g(^CT("HOSP",HospitalID)),"^",1)
	Set:CTHospCode=aCTHospCode return=1
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  根据科室获得医院信息
/// w ##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(1)
ClassMethod GetHospCodeByLoc(aLocID As %String) As %String
{
	New (aLocID)
	Set return=""
	Quit:aLocID="" return
	Set HospID="",HospCode="",HospDesc=""
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	If $IsObject(objLoc){
		Set LocCode = objLoc.BTCode
		Set LocDesc = objLoc.BTDesc
		If $IsObject(objLoc.BTHospDr) {
			Set HospID = objLoc.BTHospDr.%Id()
			Set HospCode = objLoc.BTHospDr.BTCode
			Set HospDesc = objLoc.BTHospDr.BTDesc
		}		
		
	}
	Set return=return_HospID_"^"_HospCode_"^"_HospDesc
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  根据医院ID获得科室信息列表
/// w ##Class(DHCHAI.BTS.LocationSrv).GetLocListByHospID(2)
ClassMethod GetLocListByHospID(aHospID As %String) As %String
{
	New (aHospID)
	Set return=""
	Quit:aHospID="" return
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.LocationI("IndexHospDr",aHospID,xID))
		Quit:xID=""
		
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xID)
		If $IsObject(objLoc){
			Set LocCode  = objLoc.BTCode
			Set LocDesc  = objLoc.BTDesc
		}
		
		Set return=return_$c(1)_LocCode_"^"_LocDesc
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  根据类型ID获得科室信息列表
/// w ##Class(DHCHAI.BTS.LocationSrv).GetLocListByCateID(2)
ClassMethod GetLocListByCateID(aCateID As %String) As %String
{
	New (aCateID)
	Set return=""
	Quit:aCateID="" return
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.LocationI("IndexLocCateDr",aCateID,xID))
		Quit:xID=""
		
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xID)
		If $IsObject(objLoc){
			Set LocCode  = objLoc.BTCode
			Set LocDesc  = objLoc.BTDesc
		}
		
		Set return=return_$c(1)_LocCode_"^"_LocDesc
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-01-12
/// Description:  根据登录科室ID获得科室、关联科室ICU属性
/// w ##Class(DHCHAI.BTS.LocationSrv).GetLocICUType(8)
ClassMethod GetLocICUType(aHospID As %String, aLocID As %String) As %String
{
	New (aHospID,aLocID)
	Set return=""
	Quit:(aHospID="")&(aLocID="") return
   
    Set Type=""
    // 获取登录科室的科室类型
	Set LocTypeCode="", LocIDList=""  //获取虚拟病区或科室关联病区
    Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$isobject(objLoc) return
	Set IsActive=objLoc.BTIsActive
	Quit:IsActive'=1 return
	Set IsICU = objLoc.BTIsICU
	Set IsNICU = objLoc.BTIsNICU    //登录科室ICU属性
	
	//通过系统参数'ICUSurveryType'显示科室/病区
	Set ICUSurveryType=##class(DHCHAI.BT.Config).GetValByCode("ICUSurveryType")
	If (ICUSurveryType="1"){
		Set aLocCate ="I|E", aLocType ="W"  //查询住院的病区
	}
	else{
		Set aLocCate ="I|W", aLocType ="E"  //查询住院的科室
	}
	
	If $IsObject(objLoc.BTTypeDr) {
		Set LocTypeCode = objLoc.BTTypeDr.BTCode
	}
	If (LocTypeCode="W") {   //病区对应虚拟病区
		Set xLocID=0
		For {
			Set xLocID = $o(^DHCHAI.BT.LocationI("IndexHospDr",aHospID,xLocID))
			Quit:xLocID=""
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
			Continue:'$isobject(objLoc)
			Continue:'$isobject(objLoc.BTParLocDr)
			
			Set IsActive=objLoc.BTIsActive
			Continue:IsActive'=1
			Set ParLocDr=objLoc.BTParLocDr.%Id()		
		    Continue:ParLocDr'=aLocID
		    Set LocIDList=LocIDList_"|"_xLocID			
		}
		Set:LocIDList'="" LocIDList=$e(LocIDList,2,$l(LocIDList))
	}Else{
		// 获取关联科室
		Set LocIDList = ##class(DHCHAI.BT.LocationLink).GetLocLinks(aLocID)
	}

	Set ICUFlg=0,NICUFlg=0   //初始	
	Set:IsICU=1 ICUFlg=1
	Set:IsNICU=1 NICUFlg=1
	For indL=1:1:$l(LocIDList,"|") {
		Set LocID =$p(LocIDList,"|",indL)
		Continue:LocID=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$isobject(objLoc)
		If $IsObject(objLoc.BTTypeDr) {
			Set LocTypeCode	= objLoc.BTTypeDr.BTCode
		}	
		Continue:(aLocType'="")&&(aLocType'=LocTypeCode) //通过系统参数'ICUSurveryType'显示科室/病区
		Set IsICU	    = objLoc.BTIsICU
		Set IsNICU	    = objLoc.BTIsNICU
		Continue:(IsICU'=1)&(IsNICU'=1)	
		Set:IsICU=1 ICUFlg=1
		Set:IsNICU=1 NICUFlg=1
	}
	
	Set:(ICUFlg=1)&(NICUFlg'=1) Type=1
	Set:(ICUFlg'=1)&(NICUFlg=1) Type=2
	Set:(ICUFlg=1)&(NICUFlg=1) Type=3
	
    Set return =Type
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-08-11
/// Description:  查询ICU/NICU科室or病区列表
/// Table：       DHCHAI.BT.Location
/// aLocCate ="I", aLocType ="W"
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用"|"连接
///               aLocID：DHCHAI.BT.Location.ID，登陆科室ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.LocationSrv","QryICULoc","1","291")
Query QryICULoc(aHospIDs As %String, aLocID As %String = "", aTypeID As %String = "") As %Query(ROWSPEC = "ID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,GroupDr:%String,GroupCode:%String,GroupDesc:%String,HospDr:%String,HospCode:%String,HospDesc:%String,IsOPER:%String,IsICU:%String,IsNICU:%String,ICUTpDr:%String,ICUTpCode:%String,ICUTpDesc:%String,XCode:%String,ParLocID:%String,ParLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryICULocExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String = "", aTypeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	
	
	//通过系统参数'ICUSurveryType'显示科室/病区
	Set ICUSurveryType=##class(DHCHAI.BT.Config).GetValByCode("ICUSurveryType")
	If (ICUSurveryType="1"){
		Set aLocCate ="I|E", aLocType ="W"  //查询住院的病区
	}
	else{
		Set aLocCate ="I|W", aLocType ="E"  //查询住院的科室
	}
	 
	// 获取登录科室的科室类型
	Set aLocTypeCode="", LocIDList=""  //获取虚拟病区
	If (aLocID'=""){
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
		Quit:'$isobject(objLoc) $$$OK
		Set IsActive=objLoc.BTIsActive
		Quit:IsActive'=1 $$$OK
		If $IsObject(objLoc.BTTypeDr) {
			Set aLocTypeCode = objLoc.BTTypeDr.BTCode
		}
		
		Set xLocID=0
		For {
			Set xLocID = $o(^DHCHAI.BT.LocationD(xLocID))
			Quit:xLocID=""
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocID)
			Continue:'$isobject(objLoc)
			Continue:'$isobject(objLoc.BTParLocDr)
			
			Set IsActive=objLoc.BTIsActive
			Continue:IsActive'=1
			Set ParLocDr=objLoc.BTParLocDr.%Id()		
		    Continue:ParLocDr'=aLocID
		    Set LocIDList=LocIDList_","_xLocID			
		}
	}
	Set:LocIDList'="" LocIDList=$e(LocIDList,2,$l(LocIDList))
	
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,xHospID)<1)
		
		Set xID=0
		For {
			Set xID = $o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xID))
			Quit:xID=""
			
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xID)
			Continue:'$isobject(objLoc)
			Set IsActive=objLoc.BTIsActive
			Continue:IsActive'=1
			
			Set LocTypeCode=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocTypeCode	= objLoc.BTTypeDr.BTCode
			}
			
			If (aLocTypeCode=aLocType) {
				Continue:(aLocID'="")&&((aLocID'=xID)&&((","_LocIDList_",")'[(","_xID_",")))				
			}Else{
				// 获取关联科室
				Set LocLinks = ##class(DHCHAI.BT.LocationLink).GetLocLinks(xID)			//(1|2|3)
				Continue:(aLocID'="")&&('(("|"_LocLinks_"|")[("|"_aLocID_"|")))
			}
			Set (LocCode,LocDesc,LocDesc2,GroupCode,GroupDesc,IsNullLoc)=""
			Set (HospCode,HospDesc,IsICU,IsNICU,ICUTpCode,ICUTpDesc)=""
			Set LocCode	    = objLoc.BTCode
			Set LocDesc	    = objLoc.BTDesc
			Set LocDesc2	= objLoc.BTDesc2
			Set:LocDesc2="" LocDesc2 = LocDesc
			Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
			
			Set ParLocID="",ParLocDesc=""
			If $IsObject(objLoc.BTParLocDr){
				Set ParLocID=objLoc.BTParLocDr.%Id()
				Set ParLocDesc=objLoc.BTParLocDr.BTDesc
			}
			
			Set LocTypeCode=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocTypeCode	= objLoc.BTTypeDr.BTCode
			}
			
			Continue:(aLocType'="")&&(aLocType'=LocTypeCode)
			Set LocCateCode=""
			If $IsObject(objLoc.BTCateDr) {
				Set LocCateCode	= objLoc.BTCateDr.BTCode
			}
			Continue:(aLocCate'="")&&(aLocCate'[LocCateCode)  //急诊和住院病区
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
			Set IsICU	    = objLoc.BTIsICU
			Set IsNICU	    = objLoc.BTIsNICU
			Continue:(IsICU'=1)&&(IsNICU'=1)
			
		    Set ICUTpDr="",ICUTpCode="",ICUTpDesc=""
			If $IsObject(objLoc.BTICUTpDr) {
				Set ICUTpDr = objLoc.BTICUTpDr.%Id()
				Set ICUTpCode	= objLoc.BTICUTpDr.BTCode
				Set ICUTpDesc	= objLoc.BTICUTpDr.BTDesc
			}
			Set XCode = objLoc.BTXCode
			Continue:(aTypeID="1")&&(IsICU'=1)
			Continue:(aTypeID="2")&&(IsNICU'=1)
			//多语言处理
			Set:LocDesc'="" LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
			Set:LocDesc2'="" LocDesc2=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc2,"User.CTLoc")			
			Set Data=$lb(xID,LocCode,LocDesc,LocDesc2,GroupDr,GroupCode,GroupDesc,LocHospDr,HospCode,HospDesc,IsOPER,IsICU,IsNICU,ICUTpDr,ICUTpCode,ICUTpDesc,XCode,ParLocID,ParLocDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryICULocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICULocExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryICULocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICULocExecute ]
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
/// CreatDate：   2017-03-22
/// Description:  查询科室列表
/// Table：       DHCHAI.BT.Location
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用|连接
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.LocationSrv","QryLocSta","","","","W")
Query QryLocSta(aHospIDs As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "") As %Query(ROWSPEC = "ID:%String,LocDescBZ:%String,HospDr:%String") [ SqlProc ]
{
}

ClassMethod QryLocStaExecute(ByRef qHandle As %Binary, aHospIDs As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//Set aLocType ="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")	
	Set xHospID=0
	For {
		Set xHospID=$o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID))
		Quit:xHospID=""
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,xHospID)<1)
		
		Set xID=0
		For {
			Set xID = $o(^DHCHAI.BT.LocationI("IndexHospDr",xHospID,xID))
			Quit:xID=""
			Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xID)
			Continue:'$isobject(objLoc)
			
			Set (LocCode,LocDesc,LocDesc2,LocTypeCode,LocTypeDesc,LocCateCode,LocCateDesc,GroupCode,GroupDesc)=""
			Set (HospCode,HospDesc,IsICU,IsNICU,ICUTpCode,ICUTpDesc,IsActive,ActDate,ActTime,ActUserCode,ActUserDesc)=""
			Set LocCode	    = objLoc.BTCode
			Set LocDesc	    = objLoc.BTDesc
			Set LocDesc2	= objLoc.BTDesc2
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
			Set LocDescBZ =LocDesc2
			//Set LocHospDr = "1"
			Set:LocDesc2="" LocDescBZ = LocDesc
			Continue:LocDesc["停用"			
			//解决有换行符号 报表下拉异常
			Set LocDescBZ = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(LocDescBZ)
			Set Data=$lb(xID,LocDescBZ,LocHospDr)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryLocStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocStaExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocStaExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2017-12-13
/// Description:  获取科室/病区Json(分为手术科室/非手术科室两个节点,抗生素评估科室列表树使用)
/// Input：       aHospIDs:DHCHAI.BT.Hospital.ID串，多个医院用"|"连接
/// w ##class(DHCHAI.BTS.LocationSrv).GetLocJsonByHospIDs(1,"","I","W","1")
ClassMethod GetLocJsonByHospIDs(aHospIDs As %String, aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "") As %String
{
	New (aHospIDs,aAlias,aLocCate,aLocType,aIsActive)
	Set return=0
	Quit:(aHospIDs="") return
	
	Set OperLocJson = ""
	Set NotOperLocJson = ""
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
			Set IsICU	    = objLoc.BTIsICU
			Set IsNICU	    = objLoc.BTIsNICU
			Set IsActive	= objLoc.BTIsActive
			Continue:(aIsActive'="")&&(aIsActive'=IsActive)
			
			Set:IsOPER=1 OperLocJson=OperLocJson_","_"{""text"":"""_LocDesc2_""",""href"":""#"_LocCode_""",""tags"":"_xID_"}"
			Set:IsOPER'=1 NotOperLocJson=NotOperLocJson_","_"{""text"":"""_LocDesc2_""",""href"":""#"_LocCode_""",""tags"":"_xID_"}"
		}
	}
	Set:OperLocJson'="" OperLocJson=$e(OperLocJson,2,$l(OperLocJson))
	Set:NotOperLocJson'="" NotOperLocJson=$e(NotOperLocJson,2,$l(NotOperLocJson))
	Set OperLocJson="{""text"":""手术科室"",""href"":""#operLoc"",""tags"":"""",""nodes"":["_OperLocJson_"]}"
	Set NotOperLocJson="{""text"":""非手术科室"",""href"":""#NotoperLoc"",""tags"":"""",""nodes"":["_NotOperLocJson_"]}"
	Quit "["_OperLocJson_","_NotOperLocJson_"]"
}

/// Creator：     liyi
/// CreatDate：   2018-05-09
/// Description:  查询科室关联科室列表
/// Table：       DHCHAI.BT.LocationLink
/// Input：       aLocID：科室ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.LocationSrv","QryLocLink",1)
Query QryLocLink(aLocID As %String) As %Query(ROWSPEC = "RowID:%String,LocID:%String,LinkLocID:%String,LinkLocDesc:%String,LinkLocDesc2:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String")
{
}

ClassMethod QryLocLinkExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aLocID="" $$$OK
 	
 	Set xSubID = ""
 	For {
		Set xSubID = $o(^DHCHAI.BT.LocationD(aLocID,"Link",xSubID))
		Quit:xSubID=""
		
		Set xID = aLocID_"||"_xSubID
		Set objLocLink = ##class(DHCHAI.BT.LocationLink).GetObjById(xID)
		Continue:'$IsObject(objLocLink)
		Continue:'$IsObject(objLocLink.BTLinkLocDr)
		Continue:(+objLocLink.BTIsActive)'=1
		
		Set LinkLocID = objLocLink.BTLinkLocDr.%Id()
		Set LinkLocDesc = objLocLink.BTLinkLocDr.BTDesc
		Set LinkLocDesc2 = objLocLink.BTLinkLocDr.BTDesc2
		Set IsActive  = +objLocLink.BTIsActive
		Set ActDate   = objLocLink.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime   = objLocLink.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set objActUser= objLocLink.BTActUserDr
		Set (ActUserID,ActUserDesc)=""
		If $IsObject(objActUser){
			Set ActUserID = objActUser.%Id()
			Set ActUserDesc = objActUser.BTDesc
		}
		Set Data=$lb(xID,aLocID,LinkLocID,LinkLocDesc,LinkLocDesc2,IsActive,ActDate,ActTime,ActUserID,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLocLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocLinkExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenjb
/// CreatDate：   2020-04-15
/// Description:  检查医院科室病区列表
/// Input：       hospIds :1|2,locType E W 科室病区,start 当前开始序号,limit 返回记录数
/// Return：      jsonStr
/// w ##class(DHCHAI.BTS.LocationSrv).QueryDepts("1","E|W","11","10")
ClassMethod QueryDepts(aHospIDs As %String, aLocType As %String, start As %String = "1", limit As %String = "20")
{
	New (aHospIDs,aLocType, start,limit)	
	s end = start+limit
	s idxCnt=0  //当前位置标识符
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aLocType=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocType,"|")
	Set return=""
	
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
			Continue:((LocDesc["停用")||(LocDesc2["停用"))	
			Set:LocDesc2="" LocDesc2 = LocDesc
			Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
			
			Set LocTypeDr="",LocTypeCode="",LocTypeDesc=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocTypeDr 	= objLoc.BTTypeDr.%Id()
				Set LocTypeCode	= objLoc.BTTypeDr.BTCode
				Set LocTypeDesc	= objLoc.BTTypeDr.BTDesc
			}
			//Continue:(aLocType'="")&&(aLocType'=LocTypeCode)
			Continue:(aLocType'="")&&($listfind(aLocType,LocTypeCode)<1)
			Set LocCateDr="",LocCateCode="",LocCateDesc=""
			If $IsObject(objLoc.BTCateDr) {
				Set LocCateDr 	= objLoc.BTCateDr.%Id()
				Set LocCateCode	= objLoc.BTCateDr.BTCode
				Set LocCateDesc	= objLoc.BTCateDr.BTDesc
			}
			Continue:LocCateCode'="I"
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
			Set IndNo = objLoc.BTIndNo
			
			Set idxCnt= idxCnt + 1
			Continue:idxCnt<start
			Quit:idxCnt>=end
			//组织返回json串
			//Set Data=$lb(xID,LocCode,LocDesc,LocDesc2,LocTypeDr,LocTypeCode,LocTypeDesc,
			//LocCateDr,LocCateCode,LocCateDesc,GroupDr,GroupCode,GroupDesc,LocHospDr,
			//HospCode,HospDesc,IsOPER,IsICU,IsNICU,ICUTpDr,ICUTpCode,ICUTpDesc,XCode,
			//IsActive,ActDate,ActTime,ActUserCode,ActUserDesc,ParLocDr,IndNo)
			//$LISTTOSTRING(Data,":")
			//组织语义分析参数（转换为Json串）
			/* Set objToJSON=##class(%DynamicObject).%New()
			Set objToJSON=objToJSON.%Set("KeyId",xID)
			Set objToJSON=objToJSON.%Set("LocCode",LocCode)  //编码
			Set objToJSON=objToJSON.%Set("LocDesc",LocDesc)
			Set objToJSON=objToJSON.%Set("LocDesc2",LocDesc2)
			Set objToJSON=objToJSON.%Set("LocHospDr",LocHospDr)
			Set objToJSON=objToJSON.%Set("LocTypeCode",LocTypeCode)
			Set objToJSON=objToJSON.%Set("LocTypeDesc",LocTypeDesc)	
			//Set objToJSON=objToJSON.%Set("LocCateCode",LocCateCode)  //LocCateCode I -住院
			//Set objToJSON=objToJSON.%Set("LocCateDesc",LocCateDesc)
			Set objToJSON=objToJSON.%Set("GroupCode",GroupCode)
			Set objToJSON=objToJSON.%Set("GroupDesc",GroupDesc)
			Set objToJSON=objToJSON.%Set("IsOPER",IsOPER)
			Set objToJSON=objToJSON.%Set("IsICU",IsICU)
			Set objToJSON=objToJSON.%Set("IsNICU",IsNICU)	
			Set objToJSON=objToJSON.%Set("IsActive",IsActive)					
			Set objToJSON=objToJSON.%Set("LocHospDr",LocHospDr)
			
			Set:return'="" return=return_"#"_objToJSON.%ToJSON()
			Set:return="" return=objToJSON.%ToJSON()
			*/
			//json采用公共方法兼容2010
			Set objToJSON=##Class(%ArrayOfDataTypes).%New()
			Do objToJSON.SetAt(xID, "KeyId")
			Do objToJSON.SetAt(LocCode, "LocCode")
			Do objToJSON.SetAt(LocDesc, "LocDesc")
			Do objToJSON.SetAt(LocDesc2, "LocDesc2")
			Do objToJSON.SetAt(LocHospDr, "LocHospDr")
			Do objToJSON.SetAt(LocTypeCode, "LocTypeCode")
			Do objToJSON.SetAt(LocTypeDesc, "LocTypeDesc")
			//Do objToJSON.SetAt(LocCateCode, "LocCateCode")
			//Do objToJSON.SetAt(LocCateDesc, "LocCateDesc")
			Do objToJSON.SetAt(GroupCode, "GroupCode")
			Do objToJSON.SetAt(GroupDesc, "GroupDesc")
			Do objToJSON.SetAt(IsOPER, "IsOPER")
			Do objToJSON.SetAt(IsICU, "IsICU")
			Do objToJSON.SetAt(IsNICU, "IsNICU")
			Do objToJSON.SetAt(IsActive, "IsActive")
			Do objToJSON.SetAt(LocHospDr, "LocHospDr")
			
			Set JsonStr = ##class(ext.util.JsonObject).ObjToJson(objToJSON)
			Set:return'="" return=return_"#"_JsonStr
			Set:return="" return=JsonStr
		}
	}
	Quit return
}

}
