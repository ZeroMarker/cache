/// 名称: DHCMed.SSService.HospitalSrv
/// 描述: 医院列表的常用操作
/// 编写者：zhufei
/// 编写日期: 2014-03-17
Class DHCMed.SSService.HospitalSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-03-21
/// Description:  检查科室ID和医院ID是否匹配
/// Table：       DHCMed.SS.Hospital、CT_Hospital、CT_Loc
/// Input：       aLocID  : 科室ID（CT_Loc.ID）
///               aHospitalIDs  : 医院ID（CT_Hospital.ID）
/// Return：      返回是否匹配
/// w ##class(DHCMed.SSService.HospitalSrv).CheckHospital(458,3)
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
/// CreatDate：   2014-03-17
/// Description:  根据医院ID获取医院编码及名称
/// Table：       DHCMed.SS.Hospital
/// Input：       aHospitalID  : 医院ID（CT_Hospital.ID）
///               aProductCode : 产品代码
/// Return：      返回医院编码及医院列表
/// w ##class(DHCMed.SSService.HospitalSrv).GetSSHospCode("","DTH")
ClassMethod GetSSHospCode(aHospitalID As %String, aProductCode As %String)
{
	new (aHospitalID,aProductCode)
	set return=""
	quit:(aProductCode="") return
	
	set:aHospitalID=0 aHospitalID=""
	set:aHospitalID="" aHospitalID=$o(^CT("HOSP",0))
	quit:aHospitalID="" return
	
	set ProductID=$o(^DHCMA.Util.BT.ProductI("IdxOfProCode"," "_$zcvt(aProductCode,"U"),0))
	quit:ProductID="" return
	
	//取医院ID对应的产品医院代码
	set xHospCode=""
	for {
		set xHospCode=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," "_ProductID,xHospCode))
		quit:xHospCode=""
		quit:return'=""
		
		set xID=0
		for {
			set xID=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," "_ProductID,xHospCode," "_aHospitalID,xID))
			quit:xID=""
			quit:return'=""
			
			set objHosp=##class(DHCMed.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			set IsActive=objHosp.IsActive
			continue:IsActive'=1
			set return=objHosp.HospCode
		}
	}
	quit:return'="" return
	
	//取医院ID对应的默认医院代码
	set xHospCode=""
	for {
		set xHospCode=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," 0",xHospCode))
		quit:xHospCode=""
		quit:return'=""
		
		set xID=0
		for {
			set xID=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," 0",xHospCode," "_aHospitalID,xID))
			quit:xID=""
			quit:return'=""
			
			set objHosp=##class(DHCMed.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			set IsActive=objHosp.IsActive
			continue:IsActive'=1
			set return=objHosp.HospCode
		}
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-28
/// Description:  根据就诊号取系统医院代码
/// Table：       DHCMed.SS.Hospital、CT_Hospital、DHCMed.DC.BTHospital
/// Input：       aEpisodeID  : 就诊号
/// Return：      返回String
/// w ##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc("","EPD")
ClassMethod GetSSHospCodeByLoc(aLocID As %String, aProductCode As %String) As %String
{
	New (aLocID,aProductCode)
	Set return=""
	Quit:aLocID="" return
	Set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(aLocID)
	Set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(CTHospID,aProductCode)
	Set return=SSHospCode
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-17
/// Description:  根据医院ID获取医院名称
/// Table：       DHCMed.SS.Hospital
/// Input：       aHospitalID  : 医院ID（CT_Hospital.ID）
///               aProductCode : 产品代码
/// Return：      返回医院编码及医院列表
/// w ##class(DHCMed.SSService.HospitalSrv).GetObjSSHosp("","DTH")
ClassMethod GetObjSSHosp(aHospitalID As %String, aProductCode As %String)
{
	new (aHospitalID,aProductCode)
	set return=""
	quit:(aProductCode="") return
	
	set:aHospitalID=0 aHospitalID=""
	set:aHospitalID="" aHospitalID=$o(^CT("HOSP",0))
	quit:aHospitalID="" return
	
	set ProductID=$o(^DHCMed.SS.ProductsI("ProductActive",$zcvt(aProductCode,"U"),1,0))
	quit:ProductID="" return
	
	//取医院ID对应的产品医院代码
	set xHospCode=""
	for {
		set xHospCode=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," "_ProductID,xHospCode))
		quit:xHospCode=""
		quit:return'=""
		
		set xID=0
		for {
			set xID=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," "_ProductID,xHospCode," "_aHospitalID,xID))
			quit:xID=""
			quit:return'=""
			
			set objHosp=##class(DHCMed.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			set IsActive=objHosp.IsActive
			continue:IsActive'=1
			set return=objHosp.HospCode
		}
	}
	quit:return'="" return
	
	//取医院ID对应的默认医院代码
	set xHospCode=""
	for {
		set xHospCode=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," 0",xHospCode))
		quit:xHospCode=""
		quit:return'=""
		
		set xID=0
		for {
			set xID=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," 0",xHospCode," "_aHospitalID,xID))
			quit:xID=""
			quit:return'=""
			
			set objHosp=##class(DHCMed.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			set IsActive=objHosp.IsActive
			continue:IsActive'=1
			set return=objHosp.HospCode
		}
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-17
/// Description:  根据医院代码获取医院编码及名称
/// Table：       DHCMed.SS.Hospital
/// Input：       aHospCode  : 医院代码（DHCMed.SS.Hospital.HospCode）
///               aProductCode : 产品代码
/// Return：      返回医院编码及医院列表
/// w ##class(DHCMed.SSService.HospitalSrv).GetSSHospList("HN-ZDWFY","WMR")
ClassMethod GetSSHospList(aHospCode As %String, aProductCode As %String)
{
	new (aHospCode,aProductCode)
	set return=""
	quit:(aHospCode="")||(aProductCode="") return
	
	set ProductID=$o(^DHCMA.Util.BT.ProductI("IdxOfProCode"," "_$zcvt(aProductCode,"U"),0))
	quit:ProductID="" return
	
	//取医院代码对应的产品医院列表
	set xHospitalID=0
	for {
		set xHospitalID=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," "_ProductID," "_aHospCode,xHospitalID))
		quit:xHospitalID=""
		
		set xID=0
		for {
			set xID=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," "_ProductID," "_aHospCode,xHospitalID,xID))
			quit:xID=""
			
			set objHosp=##class(DHCMed.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			set IsActive=objHosp.IsActive
			continue:IsActive'=1
			set return=return_","_objHosp.HospitalDr
		}
	}
	set:return'="" return=$e(return,2,$l(return))
	quit:return'="" return
	
	//取医院ID对应的默认医院代码
	set xHospitalID=0
	for {
		set xHospitalID=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," 0"," "_aHospCode,xHospitalID))
		quit:xHospitalID=""
		
		set xID=0
		for {
			set xID=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," 0"," "_aHospCode,xHospitalID,xID))
			quit:xID=""
			
			set objHosp=##class(DHCMed.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			set IsActive=objHosp.IsActive
			continue:IsActive'=1
			set return=return_","_objHosp.HospitalDr
		}
	}
	set:return'="" return=$e(return,2,$l(return))
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-04-02
/// Description:  根据代码取医院列表
/// Table：       DHCMed.SS.Hospital
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.HospitalSrv","QrySSHospByCode","BJ-DTYY","DTH")
Query QrySSHospByCode(aHospCode As %String, aProductCode As %String) As %Query(ROWSPEC = "CTHospID:%String,CTHospDesc:%String")
{
}

ClassMethod QrySSHospByCodeExecute(ByRef qHandle As %Binary, aHospCode As %String, aProductCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set SSHospList=..GetSSHospList(aHospCode,aProductCode)
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

/// Creator：     mxp
/// CreatDate：   2016-12-29
/// Description:  根据登录科室取医院列表(报表使用)
/// Table：       DHCMed.SS.Hospital
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.HospitalSrv","QrySSHospByCTLoc",9,"DTH")
Query QrySSHospByCTLoc(aCTLogLoc As %String, aProductCode As %String) As %Query(ROWSPEC = "CTHospID:%String,CTHospDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySSHospByCTLocExecute(ByRef qHandle As %Binary, aCTLogLoc As %String, aProductCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	quit:aCTLogLoc="" $$$OK
	
	Set LogonHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(aCTLogLoc)
	Set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(LogonHospID,aProductCode)
	
	Set SSHospList=..GetSSHospList(SSHospCode,aProductCode)
	quit:SSHospList="" $$$OK
	
	Set SSHospList=$tr(SSHospList,",","^") //智能报表下拉字段ID不能出现","
	
	if $l(SSHospList,"^")>1 {
		Set Data=$lb(SSHospList,"全部院区")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	for indHosp=1:1:$l(SSHospList,"^") {
		set CTHospID=$p(SSHospList,"^",indHosp)
		continue:CTHospID=""
		set CTHospDesc=$p($g(^CT("HOSP",CTHospID)),"^",2)
		continue:CTHospDesc=""
		Set Data=$lb(CTHospID,CTHospDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QrySSHospByCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySSHospByCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySSHospByCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySSHospByCTLocExecute ]
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
/// CreatDate：   2014-04-02
/// Description:  根据代码取医院列表
/// Table：       DHCMed.SS.Hospital
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.HospitalSrv","QrySSHospByCodeAA","BJ-DTYY","DTH")
Query QrySSHospByCodeAA(aHospCode As %String, aProductCode As %String) As %Query(ROWSPEC = "CTHospID:%String,CTHospDesc:%String")
{
}

ClassMethod QrySSHospByCodeAAExecute(ByRef qHandle As %Binary, aHospCode As %String, aProductCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set SSHospList=..GetSSHospList(aHospCode,aProductCode)
	quit:SSHospList="" $$$OK
	
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

ClassMethod QrySSHospByCodeAAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySSHospByCodeAAExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySSHospByCodeAAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySSHospByCodeAAExecute ]
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
/// CreatDate：   2014-03-20
/// Description:  根据科室获取医院ID
/// Table：       CT_Hospital,CT_Loc
/// Input：       aLocID  : 科室ID
/// Return：      返回医院ID
/// w ##class(DHCMed.SSService.HospitalSrv).GetCTHospID(1)
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
			Set xID=$o(^DHCMed.SS.HospitalD(xID))
			Quit:xID=""
			
			set objHosp=##class(DHCMed.SS.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			continue:objHosp.IsActive'=1
			
			set CTHospID=objHosp.HospitalDr
			continue:CTHospID=""
			continue:'$d(^CT("HOSP",CTHospID))
			set HospitalID=CTHospID
		}
	}
	
	set return=HospitalID
	quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2020-06-24
/// Description:  跟据就诊号判断是否是该医院患者，若是返回1，否返回0; 用于公卫主页的多院区过滤
/// Table：       CT_Hospital,CT_Loc
/// Input：       aLocID  : 医院代码（代码相同为同一家医院） 就诊号 产品代码
/// Return：      返回1或0
/// w ##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(1)
ClassMethod CheckIsHosp(aHospCode As %String, aEpisodeID As %String, aProductCode As %String = "EPD") As %String
{
	New (aHospCode,aEpisodeID,aProductCode)
	Set return=0
	Quit:(aHospCode="")||(aEpisodeID="") return
	Set PAData=$g(^PAADM(+aEpisodeID))
	Set LocID=$p(PAData,"^",4)
	Set HospCode = ..GetSSHospCodeByLoc(LocID,aProductCode)
	
	Set:HospCode=aHospCode return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-19
/// Description:  取HIS医院列表
/// Table：       CT_Hospital
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.HospitalSrv","QryCTHospital")
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
/// Table：       DHCMed.SS.Hospital
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.HospitalSrv","QrySSHospital")
Query QrySSHospital() As %Query(ROWSPEC = "SSHospID:%String,SSHospCode:%String,SSHospDesc:%String,CTHospID:%String,CTHospDesc:%String,ProductID:%String,ProductDesc:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String")
{
}

ClassMethod QrySSHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set xProduct=""
	for {
		set xProduct=$o(^DHCMed.SS.HospitalI("IndexProductHospital",xProduct))
		quit:xProduct=""
		
		set xHospCode=""
		for {
			set xHospCode=$o(^DHCMed.SS.HospitalI("IndexProductHospital",xProduct,xHospCode))
			quit:xHospCode=""
			
			set xHospital=""
			for {
				set xHospital=$o(^DHCMed.SS.HospitalI("IndexProductHospital",xProduct,xHospCode,xHospital))
				quit:xHospital=""
				
				set xID=0
				for {
					set xID=$o(^DHCMed.SS.HospitalI("IndexProductHospital",xProduct,xHospCode,xHospital,xID))
					quit:xID=""
					
					set objHosp=##class(DHCMed.SS.Hospital).GetObjById(xID)
					continue:'$IsObject(objHosp)
					
					set HospCode=objHosp.HospCode
					set HospDesc=objHosp.HospDesc
					set CTHospID=objHosp.HospitalDr
					set CTHospDesc=$p($g(^CT("HOSP",CTHospID)),"^",2)
					set ProductID=objHosp.ProductDr
					set objProduct=##class(DHCMA.Util.BT.Product).GetObjById(ProductID)
					if $IsObject(objProduct) {
						set ProductID=objProduct.%Id()
						set ProductDesc=objProduct.ProDesc
					} else {
						set ProductID=""
						set ProductDesc=""
					}
					set IsActive=objHosp.IsActive
					set IsActiveDesc=$s(IsActive=1:"是",1:"否")
					set Resume=objHosp.Resume
					
					Set Data=$lb(xID,HospCode,HospDesc,CTHospID,CTHospDesc,ProductID,ProductDesc,IsActive,IsActiveDesc,Resume)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
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
/// d ##Class(%ResultSet).RunQuery("DHCMed.SSService.HospitalSrv","QueryLoction","jzk","","","E|EM","","","")
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
	Set aLocType=$tr(aLocType,",","|")
	Set aLocType=$tr(aLocType,"/","|")
	Set aLocType=$tr(aLocType,"\","|")
	Set:aLocType'="" aLocType="|"_aLocType_"|"
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
		Continue:(aLocType'="")&&(aLocType'[("|"_LocType_"|"))                   //科室类型
		Continue:(aLinkLoc'="")&&('$d(^CTLOC(+aLinkLoc,"LINK",0,"Loc",LocID)))   //关联科室
		
		//主要处理集团化医院情况和总院分院情况
		If aHospitalIDs'="" {
			Set flg=..CheckHospital(LocID,aHospitalIDs)
			Continue:flg<1
		}
		
		//增加科室按门诊、住院分类的过滤
		If (aLocType'["|W|")&&(aAdmType'="") {	
			Continue:'$d(^PAC("ADMLOC",0,"AdmType",aAdmType,LocID))
			Continue:((aAdmType="I")&&(LocDesc["门诊"))
			Continue:((aAdmType="I")&&(LocDesc["急诊"))
		}
		
		Set LocDesc1=LocDesc
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
		Set LocDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
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

}
