/// 名称: DHCWMR.SSService.ConfigSrv
/// 描述: 参数配置服务
/// 编写者：zhufei
/// 编写日期: 2014-08-18
Class DHCWMR.SSService.ConfigSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-26
/// Description: 通过id获取配置信息
/// Table：       DHCWMR.SS.Config
/// Input：       id
/// Return：      返回配置值的字符串
/// w ##class(DHCWMR.SSService.ConfigSrv).GetStringById("2")
ClassMethod GetStringById(id As %String, aSeparate As %String) As %String
{
	new (id,aSeparate)
	set ret=""
	set HispsDescs=""
	if (aSeparate="")
	{
    	s aSeparate="^"
	}
	s myconfig=##class(DHCWMR.SS.Config).%OpenId(id)
	if ($IsObject(myconfig))
	{    
		s HospitalDr=myconfig.HospitalDr
		s HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
		
		set ret=myconfig.ToString(aSeparate)
		set ret=ret_aSeparate_HispsDescs
	}
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  根据Key/HospId获取配置值
///               如果不区分医院，可不传医院Id
/// Table：       DHCWMR.SS.Config
/// Input：       Keys ：主键
///               HospID ： 医院ID
/// Return：      返回配置值的字符串
/// w ##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("")
ClassMethod GetValueByKeyHosp(aKeys As %String, aHospID As %String = "") As %String
{
	new (aKeys,aHospID)
	set return=""
	quit:aKeys="" return
	
	set aHospID=+aHospID
	set IsHaveCofig=0
	set ID=$o(^DHCWMR.SS.ConfigI("IndexKeyHosp"," "_$zcvt(aKeys,"U")," "_aHospID,""))
	if ID'="" {
		set objConfig=##class(DHCWMR.SS.Config).GetObjById(ID)
		if $IsObject(objConfig) {
			set return=objConfig.SCVal
			set IsHaveCofig=1
		}
	}
	quit:IsHaveCofig=1 return
	
	set ID=$o(^DHCWMR.SS.ConfigI("IndexKeyHosp"," "_$zcvt(aKeys,"U")," 0",""))
	if ID'="" {
		set objConfig=##class(DHCWMR.SS.Config).GetObjById(ID)
		if $IsObject(objConfig) {
			set return=objConfig.SCVal
		}
	}
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-18
/// Description:  查询参数配置列表
/// Table：       DHCWMR.SS.Config
/// Input：       aDesc : 名称
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.ConfigSrv","QryItemList","")
Query QryItemList(aDesc As %String) As %Query(ROWSPEC = "Id:%String,Keys:%String,Description:%String,Value:%String,ValueDesc:%String,HospId:%String,HospDesc:%String,Resume:%String")
{
}

ClassMethod QryItemListExecute(ByRef qHandle As %Binary, aDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xId = ""
 	For {
	 	Set xId = $o(^DHCWMR.SS.ConfigD(xId))
	 	Quit:xId=""
	 	
	 	Set objConfig = ##class(DHCWMR.SS.Config).GetObjById(xId)
	 	Quit:'$IsObject(objConfig)
	 	
	 	Set Id         = objConfig.%Id()
	 	Set Keys       = objConfig.SCKey
	 	Set Description= objConfig.SCKeyDesc
	 	Set Value      = objConfig.SCVal
	 	Set ValueDesc  = objConfig.SCValDesc
	 	Set HospID     = objConfig.SCHospID
	 	If (HospID="")||(HospID=0){
		 	Set HospDesc   = ""
	 	}
	 	Else{
	 		Set HospDesc   = $p($g(^CT("HOSP",+HospID)),"^",2)	
	 	}
	 	Set Resume     = objConfig.SCResume
	 	
	 	Set Data = $LB(Id,Keys,Description,Value,ValueDesc,HospID,HospDesc,Resume)
	 	Set ^CacheTemp(repid,ind) = Data
	 	Set ind = ind + 1
 	}
 	
	Quit $$$OK
}

ClassMethod QryItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemListExecute ]
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

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-19
/// Description:  查询所有的医院
/// Table：       DHCWMR.SS.Hosptial
/// Input：       
/// output:       所有的符合条件的医院           
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.ConfigSrv","QueryHosInfo")
Query QueryHosInfo() As %Query(ROWSPEC = "rowid:%String,hosName:%String")
{
}

ClassMethod QueryHosInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	f  s rowid=$o(^CT("HOSP",+rowid)) q:rowid=""  d
	.s $li(data,1)=rowid
	.s $li(data,2)=$p($g(^CT("HOSP",+rowid)),"^",2)   	 // 医院描述 HOSP_Desc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QueryHosInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHosInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryHosInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHosInfoExecute ]
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

/// w ##Class(DHCWMR.SSService.ConfigSrv).ImportConfigs("","^")
ClassMethod ImportConfigs(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	//序号	医院ID	代码	描述	值	值说明	备注
	Set HospitalDr=$p(aInputStr,aSeparate,2)
	Set Keys=$p(aInputStr,aSeparate,3)
	Set Description=$p(aInputStr,aSeparate,4)
	Set Val=$p(aInputStr,aSeparate,5)
	Set ValueDesc=$p(aInputStr,aSeparate,6)
	Set Resume=$p(aInputStr,aSeparate,7)
	
	Set ConfigRowID=""
	Set ConfigID=0
	For {
		Set ConfigID=$o(^DHCWMR.SS.ConfigI("IndexKeyHosp"," "_$ZConvert(Keys,"T"),HospitalDr,ConfigID))
		Quit:ConfigID=""
		Set objConfig=##class(DHCWMR.SS.Config).GetObjById(ConfigID)
		Continue:'$IsObject(objConfig)
		Set ConfigRowID=ConfigID
	}
	
	Set InputStr=ConfigRowID_aSeparate_Keys_aSeparate_Description_aSeparate_Val_aSeparate_ValueDesc_aSeparate_HospitalDr_aSeparate_Resume
	Set return=##Class(DHCWMR.SS.Config).Update(InputStr,aSeparate)
	
	Quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-19
/// Description:  导出配置
/// Table：       DHCWMR.SS.Config
/// w ##Class(DHCWMR.SSService.ConfigSrv).ExportConfigs()
ClassMethod ExportConfigs() As %String
{
	Set return=""
	
	Set xId = ""
	For {
		Set xId = $o(^DHCWMR.SS.ConfigD(xId))
		Quit:xId=""
		Set Ind=0
		
		Set objConfig = ##class(DHCWMR.SS.Config).GetObjById(xId)
		Continue:'$IsObject(objConfig)
		
		Set Id         = objConfig.%Id()
	 	Set Keys       = objConfig.SCKey
	 	Set Description= objConfig.SCKeyDesc
	 	Set Value      = objConfig.SCVal
	 	Set ValueDesc  = objConfig.SCValDesc
	 	Set HospID     = objConfig.SCHospID
	 	If (HospID="")||(HospID=0){
		 	Set HospDesc= ""
	 	}
	 	Else{
	 		Set HospDesc = $p($g(^CT("HOSP",+HospID)),"^",2)	
	 	}
	 	Set Resume     = objConfig.SCResume 
	 	Set Ind=Ind+1
		Set return=return_"||"_Ind_"^"_Id_"^"_Keys_"^"_Description_"^"_Value_"^"_ValueDesc_"^"_HospID_"^"_HospDesc_"^"_Resume
	}
	
	Quit return
}

}
