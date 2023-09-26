/// 名称: DHCWMR.SSService.HospitalSrv
/// 描述: 医院列表的常用操作
/// 编写者：zhufei
/// 编写日期: 2014-08-27
Class DHCWMR.SSService.HospitalSrv Extends DHCWMR.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  检查科室ID和医院ID是否匹配
/// Table：       DHCWMR.SS.Hospital、CT_Hospital、CT_Loc
/// Input：       aLocID  : 科室ID（CT_Loc.ID）
///               aHospitalIDs  : 医院ID（CT_Hospital.ID）
/// Return：      返回是否匹配
/// w ##class(DHCWMR.SSService.HospitalSrv).CheckHospital(20,2)
ClassMethod CheckHospital(aLocID As %String, aHospitalIDs As %String) As %String
{
	New (aLocID,aHospitalIDs)
	Set return=0
	Quit:(aLocID="")||(aHospitalIDs="") return
	
	Set HospitalID=..GetCTHospID(aLocID)
	Quit:HospitalID="" return
	Set HospitalID=","_HospitalID_","
	Set aHospitalIDs=","_aHospitalIDs_","
	Quit:aHospitalIDs'[HospitalID return
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  根据医院ID获取医院编码及名称
/// Table：       DHCWMR.SS.Hospital
/// Input：       aHospitalID  : 医院ID（CT_Hospital.ID）
/// Return：      返回医院编码及医院列表
/// w ##class(DHCWMR.SSService.HospitalSrv).GetSSHospCode("2")
ClassMethod GetSSHospCode(aHospitalID As %String)
{
	new (aHospitalID)
	set return=""
	
	set:aHospitalID=0 aHospitalID=""
	set:aHospitalID="" aHospitalID=$o(^CT("HOSP",0))
	quit:aHospitalID="" return
	
	//取医院ID对应的产品医院代码
	set xHospCode=""
	for {
		set xHospCode=$o(^DHCWMR.SS.HospitalI("IndexCode",xHospCode))
		quit:xHospCode=""
		quit:return'=""
		
		set xID=0
		for {
			set xID=$o(^DHCWMR.SS.HospitalI("IndexCode",xHospCode," "_aHospitalID,xID))
			quit:xID=""
			quit:return'=""
			
			set objHosp=##class(DHCWMR.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			set return=objHosp.SHCode
		}
	}
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  根据医院代码获取医院编码及名称
/// Table：       DHCWMR.SS.Hospital
/// Input：       aHospCode  : 医院代码（DHCWMR.SS.Hospital.SHCode）
/// Return：      返回医院编码及医院列表
/// w ##class(DHCWMR.SSService.HospitalSrv).GetSSHospList("BJDT")
ClassMethod GetSSHospList(aHospCode As %String)
{
	new (aHospCode)
	set return=""
	quit:(aHospCode="") return
	
	//取医院代码对应的产品医院列表
	set xHospitalID=0
	for {
		set xHospitalID=$o(^DHCWMR.SS.HospitalI("IndexCode"," "_aHospCode,xHospitalID))
		quit:xHospitalID=""
		
		set xID=0
		for {
			set xID=$o(^DHCWMR.SS.HospitalI("IndexCode"," "_aHospCode,xHospitalID,xID))
			quit:xID=""
			
			set objHosp=##class(DHCWMR.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			set return=return_","_objHosp.SHHospID
		}
	}
	set:return'="" return=$e(return,2,$l(return))
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  根据代码取医院列表
/// Table：       DHCWMR.SS.Hospital
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCWMR.SSService.HospitalSrv","QrySSHospByCode","BJDT")
Query QrySSHospByCode(aHospCode As %String) As %Query(ROWSPEC = "CTHospID:%String,CTHospDesc:%String")
{
}

ClassMethod QrySSHospByCodeExecute(ByRef qHandle As %Binary, aHospCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set SSHospList=..GetSSHospList(aHospCode)
	quit:SSHospList="" $$$OK
	
	if $l(SSHospList,",")>1 {
		Set Data=$lb(SSHospList,"全部院区")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	for indHosp=1:1:$l(SSHospList,",") {
		set CTHospID=$p(SSHospList,",",indHosp)
		continue:CTHospID=""
		set CTHospDesc=$p($g(^CT("HOSP",CTHospID)),"^",2)
		continue:CTHospDesc=""
		Set Data=$lb(CTHospID,CTHospDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QrySSHospByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySSHospByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySSHospByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySSHospByCodeExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  根据科室获取医院ID
/// Table：       CT_Hospital,CT_Loc
/// Input：       aLocID  : 科室ID
/// Return：      返回医院ID
/// w ##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(1)
ClassMethod GetCTHospID(aLocID As %String)
{
	new (aLocID)
	set return=""
	quit:(aLocID="") return
	
	quit:'$d(^CTLOC(aLocID)) return
	
	set HospitalID=$p($g(^CTLOC(aLocID)),"^",22)
	If HospitalID="" {
		Set xID=0
		For {
			Set xID=$o(^DHCWMR.SS.HospitalD(xID))
			Quit:xID=""
			
			set objHosp=##class(DHCWMR.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			
			set CTHospID=objHosp.SHHospID
			continue:CTHospID=""
			continue:'$d(^CT("HOSP",CTHospID))
			set HospitalID=CTHospID
		}
	}
	
	set return=HospitalID
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  取HIS医院列表
/// Table：       CT_Hospital
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCWMR.SSService.HospitalSrv","QryCTHospital")
Query QryCTHospital() As %Query(ROWSPEC = "HospID:%String,HospCode:%String,HospDesc:%String")
{
}

ClassMethod QryCTHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xHospID=0
	For {
		Set xHospID=$o(^CT("HOSP",xHospID))
		Quit:xHospID=""
		
		Set HospCode=$p($g(^CT("HOSP",xHospID)),"^",1)
		Set HospDesc=$p($g(^CT("HOSP",xHospID)),"^",2)
		
		Set Data=$lb(xHospID,HospCode,HospDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCTHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCTHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCTHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCTHospitalExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  取医政组医院列表
/// Table：       DHCWMR.SS.Hospital
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCWMR.SSService.HospitalSrv","QrySSHospital")
Query QrySSHospital() As %Query(ROWSPEC = "SSHospID:%String,SSHospCode:%String,SSHospDesc:%String,CTHospID:%String,CTHospDesc:%String,Resume:%String")
{
}

ClassMethod QrySSHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set xHospCode=""
	for {
		set xHospCode=$o(^DHCWMR.SS.HospitalI("IndexCode",xHospCode))
		quit:xHospCode=""
		
		set xHospital=""
		for {
			set xHospital=$o(^DHCWMR.SS.HospitalI("IndexCode",xHospCode,xHospital))
			quit:xHospital=""
			
			set xID=0
			for {
				set xID=$o(^DHCWMR.SS.HospitalI("IndexCode",xHospCode,xHospital,xID))
				quit:xID=""
				
				set objHosp=##class(DHCWMR.SS.Hospital).GetObjById(xID)
				continue:'$IsObject(objHosp)
				
				set HospCode=objHosp.SHCode
				set HospDesc=objHosp.SHDesc
				set CTHospID=objHosp.SHHospID
				set CTHospDesc=$p($g(^CT("HOSP",CTHospID)),"^",2)
				set Resume=objHosp.SHResume
				
				Set Data=$lb(xID,HospCode,HospDesc,CTHospID,CTHospDesc,Resume)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySSHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySSHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySSHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySSHospitalExecute ]
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

/// 查询科室列表
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.HospitalSrv","QueryLoction","","","","E","","","")
Query QueryLoction(aAlias As %String, aDepGroup As %String, aLinkLoc As %String, aLocType As %String, aAdmType As %String, aAddItem As %String, aHospitalIDs As %String) As %Query(ROWSPEC = "LocRowId:%String,LocDesc:%String,LocDesc1:%String")
{
}

ClassMethod QueryLoctionExecute(ByRef qHandle As %Binary, aAlias As %String, aDepGroup As %String, aLinkLoc As %String, aLocType As %String, aAdmType As %String, aAddItem As %String, aHospitalIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$g(aAlias)
	Set aDepGroup=$g(aDepGroup)
	Set aLinkLoc=$g(aLinkLoc)
	Set aLocType=$g(aLocType)
	Set aAdmType=$g(aAdmType)
	Set aAddItem=$g(aAddItem)
	Set aHospitalIDs=$g(aHospitalIDs)
	
	Set:aLocType'="" aLocType=$ZCVT($g(aLocType),"U")
	Set:aAdmType'="" aAdmType=$ZCVT($g(aAdmType),"U")
	
 	//add by zf 20130225 增加附加选项
	If (aAddItem'="")&&(aAlias="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemCode,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set LocID=0
	For {
		Set LocID=$o(^CTLOC(LocID))
		Quit:LocID=""
		Set tmpLoc=$g(^CTLOC(LocID))
		Set LocDesc=$p(tmpLoc,"^",2)
		Set LocDep=$p(tmpLoc,"^",19)
		Set LocType=$p(tmpLoc,"^",13)
		
		Continue:(aAlias'="")&&($zcvt(LocDesc,"U")'[$zcvt(aAlias,"U"))           //别名
		Continue:(aDepGroup'="")&&(LocDep'=aDepGroup)                            //部门组
		Continue:(aLocType'="")&&(LocType'=aLocType)                             //科室类型
		Continue:(aLinkLoc'="")&&('$d(^CTLOC(+aLinkLoc,"LINK",0,"Loc",LocID)))   //关联科室
		
		//主要处理集团化医院情况和总院分院情况
		If aHospitalIDs'="" {
			Set flg=..CheckHospital(LocID,aHospitalIDs)
			Continue:flg<1
		}
		
		//增加科室按门诊、住院分类的过滤
		If (aLocType'="W")&&(aAdmType'="") {
			Continue:'$d(^PAC("ADMLOC",0,"AdmType",aAdmType,LocID))
		}
		
		Set LocDesc1=LocDesc
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
		Set Data=$lb(LocID,LocDesc,LocDesc1)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryLoctionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLoctionExecute ]
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

ClassMethod QueryLoctionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLoctionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  查询科室/病区
/// Input：       Type(类型:E-执行科室,W-病区),LocID(关联科室:科室找病区或病区找科室)
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.HospitalSrv","QryCTLoc","E","")
Query QryCTLoc(argType As %String, argLocID As %String) As %Query(ROWSPEC = "CTLocID:%String,CTLocCode:%String,CTLocDesc:%String")
{
}

ClassMethod QryCTLocExecute(ByRef qHandle As %Binary, argType As %String, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set CTLocID=0
	For {
		Set CTLocID=$o(^CTLOC(CTLocID))
		Quit:CTLocID=""
		Set tmp=$g(^CTLOC(CTLocID))
		Set CTLocCode=$p(tmp,"^",1)
		Set CTLocDesc=$p(tmp,"^",2)
		Set CTLocType=$p(tmp,"^",13)
		Continue:(argType'="")&&(CTLocType'=argType)
		Continue:(argLocID'="")&&'$d(^CTLOC(+argLocID,"LINK",0,"Loc",CTLocID))
		
		Set Data=$lb(CTLocID,CTLocCode,CTLocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCTLocExecute ]
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

}
