/// 名称:CT.IPMR.BTS.NoTypeSrv
/// 描述:号码类型服务
/// 创建者:WHui
/// 创建日期:2019-10-27
Class CT.IPMR.BTS.NoTypeSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2023-05-06
/// Description:  获取参数配置MrNoUseYear在不同配置情况下病案号计数器节点相关信息
/// Table：       
/// Input：       aHospID : 医院ID
/// Return：      UseYearType_"^"_YearNode
/// w ##class(CT.IPMR.BTS.NoTypeSrv).GetMrNoUseYearConfig(1)
ClassMethod GetMrNoUseYearConfig(aHospID As %String = "") As %String
{
	New (aHospID)
	Set return=""
	Set UseYearType	= ##class(CT.IPMR.BT.Config).GetValByCode("MrNoUseYear","")	// 病案号前是否拼接年份或年月配置
	If UseYearType=1{
		Set YearNode=$p($zd(+$h,3),"-",1)
	}elseif UseYearType=2{
		Set YearNode=$p($zd(+$h,3),"-",1)_$p($zd(+$h,3),"-",2)
	}else{
		Set YearNode="NULL"
	}
	Set return=UseYearType_"^"_YearNode
	Quit return
}

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  根据病案类型查询号码类型
/// Table：       CT.IPMR.BT.NoType
/// Input：       MrTypeID ：CT.IPMR.BT.MrType.ID 病案类型
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.NoTypeSrv","QryMrNoType","7")
Query QryMrNoType(aMrTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,NoLen:%String,NoHead:%String,CurrNo:%String,CurrMrNo:%String,MaxNo:%String,MinNo:%String,IsDefault:%String,IsDefaultDesc:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String")
{
}

ClassMethod QryMrNoTypeExecute(ByRef qHandle As %Binary, aMrTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aMrTypeID="" $$$OK
 	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Set MrNoUseYearConfig = ##class(CT.IPMR.BTS.NoTypeSrv).GetMrNoUseYearConfig()
	Set YearNode=$p(MrNoUseYearConfig,"^",2)
 	Set xSub=0
 	For {
	 	Set xSub=$o(^CT.IPMR.BT.MrTypeD(aMrTypeID,"NoType",xSub))
	 	Quit:xSub=""
	 	
	 	Set ID=aMrTypeID_"||"_xSub
	 	Set obj=##class(CT.IPMR.BT.NoType).GetObjById(ID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set Code				= obj.BNCode
	 	Set Desc				= obj.BNDesc
	 	Set NoLen				= obj.BNNoLen
	 	Set NoHead				= obj.BNNoHead
		Set CurrNo				= obj.BNCurrNo
		Set CurrNo				=+CurrNo
		Set xCurrNo=+$g(^MA.IPMR.SS.MrNoC(aMrTypeID,YearNode,ID))
		Set:CurrNo<xCurrNo CurrNo=xCurrNo
		Set MaxNo				= obj.BNMaxNo
		Set MinNo				= obj.BNMinNo
		Set IsDefault			= obj.BNIsDefault
		Set IsDefaultDesc		= $s(IsDefault=1:"是",1:"否")
		Set IsActive			= obj.BNIsActive
		Set IsActiveDesc		= $s(IsActive=1:"是",1:"否")
		Set Resume				= obj.BNResume
		
		Set CurrMrNo=""
		Set xNoLen=+NoLen
		If xNoLen>$l(CurrNo) {
			Set $p(CurrMrNo,"0",xNoLen+1-$l(CurrNo))=CurrNo
		} Else {
			Set CurrMrNo=CurrNo
		}
		Set:NoHead'="" CurrMrNo=$zcvt(NoHead,"U")_CurrMrNo
		Set:Desc'="" Desc=##class(CT.IPMR.BT.NoType).GetTranByDesc("BNDesc",Desc,langid)
		Set Data=$lb(ID,Code,Desc,NoLen,NoHead,CurrNo,CurrMrNo,MaxNo,MinNo,IsDefault,IsDefaultDesc,IsActive,IsActiveDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMrNoTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMrNoTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMrNoTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMrNoTypeExecute ]
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

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  通过医院ID查询医院列表，
/// Table：       
/// Input：       医院ID列表，以#作为分隔符
/// Return：      医院列表
/// Debug:		  D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.NoTypeSrv","QryHospByIDs","2#3")
Query QryHospByIDs(aHospIDs As %String, aAlias As %String = "") As %Query(ROWSPEC = "HospID:%String,HospDesc:%String,IsChecked:%String")
{
}

ClassMethod QryHospByIDsExecute(ByRef qHandle As %Binary, aHospIDs As %String, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	;Set ^TMPWHui = $lb(aHospIDs,aAlias)
 	Set length = $l(aHospIDs,"#")
 	For xIndex = 1:1:length
 	{
		Set HospID		= $p(aHospIDs,"#",xIndex)
		;Set HospDesc	=$p($g(^CT("HOSP",+HospID)),"^",2)
		Set HospInfo=##class(MA.IPMR.BTS.HospitalSrv).GetHospStrById(HospID)
		Set HospDesc=$p(HospInfo,"^",2)
		Quit:HospDesc=""
		Set IsChecked	=0
		// 检索
		;Set HospCode	= $p($g(^CT("HOSP",+HospID)),"^",1)
		Set HospCode	= $p(HospInfo,"^",1)
		Set HospLongDesc= HospCode_"@"_HospDesc
		Continue:($f(HospLongDesc,aAlias)<=0)
		// end
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

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  通过医院ID,病案号码类型ID 查询科室
/// Table：       
/// Input：       医院ID，病案号码类型ID
/// Return：      科室列表
/// Debug:		  D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.NoTypeSrv","QryLocByNoType","2","7||1")
Query QryLocByNoType(aHospID As %String, aNoTypeID As %String, aAlias As %String = "") As %Query(ROWSPEC = "HospID:%String,LocID:%String,LocDesc:%String,IsChecked:%String")
{
}

ClassMethod QryLocByNoTypeExecute(ByRef qHandle As %Binary, aHospID As %String, aNoTypeID As %String, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aHospID="")||(aNoTypeID="") $$$OK

 	//获取该号码关联类型是什么病案类型的关联
 	Set MrTypeID 	= $p(aNoTypeID,"||",1)
 	Set NoTypeSub	= $p(aNoTypeID,"||",2)
 	Quit:(MrTypeID="") $$$OK
 	Set objMrType = ##class(CT.IPMR.BT.MrType).GetObjById(MrTypeID)
 	Quit:'$IsObject(objMrType) $$$OK
 	Set MTMrClassDesc = objMrType.BMMrClass.BMCode
 	Quit:MTMrClassDesc="" $$$OK
 	Set MTAdmType = objMrType.BMAdmType
 	
 	For ind=1:1:$length(MTAdmType,"#"){
		Set LocType=""
		Set AdmType = $p(MTAdmType,"#",ind)
	 	Set:AdmType["I" LocType="E"		//住院
	 	Set:AdmType["O" LocType="E"		//门诊
	 	Set:AdmType["E" LocType="EM"	//急诊
	 	Quit:LocType=""
	 	
	 	Set arr	= ##Class(%ArrayOfDataTypes).%New()
		Set arr = ##class(MA.IPMR.BTS.LocationSrv).GetAllLocArray()
		Set xKey=""
		For {
		    Do arr.GetNext(.xKey)
		    Quit:xKey=""
		    Set tValue	= arr.GetAt(xKey)
		    
		    Set CTLocID		= $p(tValue,"^",1)
		    Set CTLocDesc	= $p(tValue,"^",3)
		    Set CTLocType   = $p(tValue,"^",4)
		    Set HospID 		= $p(tValue,"^",5)
		    Continue:$d(^CT.IPMR.BT.MrTypeI("Link","IndexLocID",MrTypeID,NoTypeSub," "_CTLocID))
			Continue:(LocType'="")&&(CTLocType'=LocType)
			Continue:(aHospID'="")&&(HospID'=aHospID)
			Set LocAdmTypeisI	= ##class(MA.IPMR.BTS.LocationSrv).LocAccAdmType(CTLocID,"I")
			Set LocAdmTypeisO	= ##class(MA.IPMR.BTS.LocationSrv).LocAccAdmType(CTLocID,"O")
			Continue:(AdmType="I")&&(LocType="E")&&('LocAdmTypeisI)		;$d(^PAC("ADMLOC",0,"AdmType","I",CTLocID))
			Continue:(AdmType="O")&&(LocType="E")&&('LocAdmTypeisO)		;$d(^PAC("ADMLOC",0,"AdmType","O",CTLocID))
			Continue:(AdmType="E")&&(LocType="EM")&&('LocAdmTypeisI)	;$d(^PAC("ADMLOC",0,"AdmType","I",CTLocID))
			&sql(Select *from CT_IPMR_BT.NoTypeLnk where Parref = :aNoTypeID And BNHospID = :HospID And BNLocID = :CTLocID)
			Continue:'SQLCODE
			
			// 检索 aAlias
			Set LongLocdesc = $p(tValue,"^",2)_"@"_CTLocDesc
			Continue:($f(LongLocdesc,aAlias)<=0)
			// end
			
			Set IsChecked="0"
			Set Data=$lb(HospID,CTLocID,CTLocDesc,IsChecked)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
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

}
