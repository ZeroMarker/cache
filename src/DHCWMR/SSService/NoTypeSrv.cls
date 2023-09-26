/// 名称: DHCWMR.SSService.NoTypeSrv
/// 描述: 病案号码类型关联“科室、医院”条件设置【相关服务】
/// 编写者：liyi
/// 编写日期: 2014-08-29
Class DHCWMR.SSService.NoTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-10-08
/// Description:  通过ID查询号码类型列表
/// Table：       DHCWMR.SS.NoType
/// Input：       号码类型ID列表，以英文逗号分隔
/// Return：      返回String
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.NoTypeSrv","QryNoTypeByID","1||1,1||2")
Query QryNoTypeByID(aNoTypeIDs As %String) As %Query(ROWSPEC = "NoTypeID:%String,NoTypeCode:%String,NoTypeDesc:%String,MrTypeID:%String,MrTypeDesc:%String,NoFiled:%String,GetWayTp:%String")
{
}

ClassMethod QryNoTypeByIDExecute(ByRef qHandle As %Binary, aNoTypeIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	For xIndex=1:1:$l(aNoTypeIDs,",") {
		Set NoTypeID=$p(aNoTypeIDs,",",xIndex)
		Continue:NoTypeID=""
		Set objNoType=##class(DHCWMR.SS.NoType).GetObjById(NoTypeID)
		Continue:'$IsObject(objNoType)
		Continue:objNoType.NTIsActive'=1
		Continue:'$IsObject(objNoType.Parref)
		Set MrTypeID=objNoType.Parref.%Id()
		Set MrTypeDesc=objNoType.Parref.MTDesc
		Set NoFiled=objNoType.Parref.MTNoFiled
		Set GetWayTp=""
		If $IsObject(objNoType.Parref.MTGetWay){
			Set GetWayTp=objNoType.Parref.MTGetWay.SDCode
		}
		Set NoTypeID=objNoType.%Id()
		Set NoTypeCode=objNoType.NTCode
		Set NoTypeDesc=objNoType.NTDesc
		
		Set Data=$lb(NoTypeID,NoTypeCode,NoTypeDesc,MrTypeID,MrTypeDesc,NoFiled,GetWayTp)
		Set ^CacheTemp(repid,ind) = Data
		Set ind= ind+1
	}
	Quit $$$OK
}

ClassMethod QryNoTypeByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNoTypeByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNoTypeByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNoTypeByIDExecute ]
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

/// Creator：     liyi
/// CreatDate：   2014-09-03
/// Description:  通过医院ID,病案号码类型ID 查询科室
/// Table：       
/// Input：       医院ID，病案号码类型ID
/// Return：      医院列表
/// Debug:		  D ##class(%ResultSet).RunQuery("DHCWMR.SSService.NoTypeSrv","QryLocByNoType","2","6||1")
Query QryLocByNoType(aHospID As %String, aNoTypeID As %String) As %Query(ROWSPEC = "HospID:%String,LocID:%String,LocDesc:%String,IsChecked:%String")
{
}

ClassMethod QryLocByNoTypeExecute(ByRef qHandle As %Binary, aHospID As %String, aNoTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aHospID="")||(aNoTypeID="") $$$OK

 	//获取该号码关联类型是什么病案类型的关联
 	Set MrTypeID = $p(aNoTypeID,"||",1)
 	Quit:(MrTypeID="") $$$OK
 	Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
 	Quit:'$IsObject(objMrType) $$$OK
 	Set MTMrClassDesc = objMrType.MTMrClass.MCCode
 	Quit:MTMrClassDesc="" $$$OK
 	Set MTAdmType = objMrType.MTAdmType
 	
 	For ind=1:1:$length(MTAdmType,"#"){
		Set LocType=""
		Set AdmType = $p(MTAdmType,"#",ind)
	 	Set:AdmType["I" LocType="E"		//住院
	 	Set:AdmType["O" LocType="E"		//门诊
	 	Set:AdmType["E" LocType="EM"		//急诊
	 	Quit:LocType=""
	 	Set CTLocID=0
		For {
			Set CTLocID=$o(^CTLOC(CTLocID))
			Quit:CTLocID=""
			Set tmp=$g(^CTLOC(CTLocID))
			Set CTLocType   =$p(tmp,"^",13)
			Set HospID =$p(tmp,"^",22)
			Set CTLocDesc=$p(tmp,"^",2)
			Continue:$d(^DHCWMR.SS.MrTypeI("MNTL","IndexOnLocID"," "_CTLocID))
			Continue:(LocType'="")&&(CTLocType'=LocType)
			Continue:(aHospID'="")&&(HospID'=aHospID)
			Continue:(AdmType="I")&&(LocType="E")&&('$d(^PAC("ADMLOC",0,"AdmType","I",CTLocID)))
			Continue:(AdmType="O")&&(LocType="E")&&('$d(^PAC("ADMLOC",0,"AdmType","O",CTLocID)))
			Continue:(AdmType="E")&&(LocType="EM")&&('$d(^PAC("ADMLOC",0,"AdmType","I",CTLocID)))
			&sql(Select *from DHCWMR_SS.NoTypeLnk where Parref = :aNoTypeID And NTLHospID = :HospID And NTLLocID = :CTLocID)
			Continue:'SQLCODE
			Set IsChecked="0"
			Set Data=$lb(HospID,CTLocID,CTLocDesc,IsChecked)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		} 	
	}
	/*
 	Set LocType=""
 	Set:MTMrClassDesc["I" LocType="E"		//住院
 	Set:MTMrClassDesc["O" LocType="E"		//门诊
 	Set:MTMrClassDesc["E" LocType="EM"		//急诊
 	Quit:LocType="" $$$OK
 	
	Set CTLocID=0
	For {
		Set CTLocID=$o(^CTLOC(CTLocID))
		Quit:CTLocID=""
		Set tmp=$g(^CTLOC(CTLocID))
		Set CTLocType   =$p(tmp,"^",13)
		Set HospID =$p(tmp,"^",22)
		Set CTLocDesc=$p(tmp,"^",2)
		Continue:(LocType'="")&&(CTLocType'=LocType)
		Continue:(aHospID'="")&&(HospID'=aHospID)
		if (MTMrClassDesc="I"){
			//Continue:$d(^PAC("ADMLOC",0,"AdmType","O",CTLocID))
		}
		Continue:(MTMrClassDesc="I")&&(LocType="E")&&('$d(^PAC("ADMLOC",0,"AdmType","I",CTLocID)))
		Continue:(MTMrClassDesc="O")&&(LocType="E")&&('$d(^PAC("ADMLOC",0,"AdmType","O",CTLocID)))
		&sql(Select *from DHCWMR_SS.NoTypeLnk where Parref = :aNoTypeID And NTLHospID = :HospID And NTLLocID = :CTLocID)
		Continue:'SQLCODE
		Set IsChecked="0"
		Set Data=$lb(HospID,CTLocID,CTLocDesc,IsChecked)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	} 	
 	*/
 	
	Quit $$$OK
}

ClassMethod QryLocByNoTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocByNoTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocByNoTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocByNoTypeExecute ]
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

/// Creator：     liyi
/// CreatDate：   2014-08-29
/// Description:  通过医院ID查询医院列表，
/// Table：       
/// Input：       医院ID列表，以#作为分隔符
/// Return：      医院列表
/// Debug:		  D ##class(%ResultSet).RunQuery("DHCWMR.SSService.NoTypeSrv","QryHospByIDs","2#3")
Query QryHospByIDs(aHospIDs As %String) As %Query(ROWSPEC = "HospID:%String,HospDesc:%String,IsChecked:%String")
{
}

ClassMethod QryHospByIDsExecute(ByRef qHandle As %Binary, aHospIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set length = $l(aHospIDs,"#")
 	For xIndex = 1:1:length
 	{
		Set HospID = $p(aHospIDs,"#",xIndex)
		Set HospDesc=$p($g(^CT("HOSP",+HospID)),"^",2)
		Quit:HospDesc=""
		Set IsChecked=0
		Set Data = $lb(HospID,HospDesc,Ischecked)
		Set ^CacheTemp(repid,ind) = Data
		Set ind= ind+1
	}
	Quit $$$OK
}

ClassMethod QryHospByIDsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospByIDsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospByIDsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospByIDsExecute ]
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
