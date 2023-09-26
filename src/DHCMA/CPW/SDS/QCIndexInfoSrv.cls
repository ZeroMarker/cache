Class DHCMA.CPW.SDS.QCIndexInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据传参获取指标配置树内容
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexInfoSrv","QryScreenInfo","4",1)
Query QryScreenInfo(EntityId As %String, aType As %String = "0") As %Query(ROWSPEC = "RowId:%String,title:%String,field:%String,headertype:%String,active:%String,ID:%String,parent:%String,indexExp:%String,state:%String,sort:%String,type:%String,_parentId:%String")
{
}

ClassMethod QryScreenInfoExecute(ByRef qHandle As %Binary, EntityId As %String, aType As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:EntityId=""
 	Set rowIdField=0,xParentid="",parenField=0
 	For{
	 	Set xParentid         = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEParref"," "_EntityId,xParentid))
	 	set parenField=parenField+1
		Quit:xParentid=""
		Set xSort=""
		For{
			Set xSort   = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEParref"," "_EntityId,xParentid,xSort))
			Quit:xSort=""
			Set xId=""
			For{
				Set xId     = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEParref"," "_EntityId,xParentid,xSort,xId))
				Quit:xId=""	
				Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xId)
				Quit:'$IsObject(objInfo) 
				Continue:objInfo.type'=aType
				Set title		= objInfo.title
				Set field		= objInfo.field
				Set headertype	= objInfo.headertype
				Set active		= objInfo.active
				Set parentid	= objInfo.parentid
				Set indexExp	= objInfo.indexExp
				Set sort		= objInfo.sort
				Set type		= objInfo.type
				Set rowIdField=rowIdField+1
				set retpar=parentid
				Set:xId=retpar retpar=""	
				Set state=""
				;Set:field="" state="closed"
				Set Data=$lb(xId,title,field,headertype,active,xId,parentid,indexExp,state,sort,type,retpar)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}	

	}
	Quit $$$OK
}

ClassMethod QryScreenInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryScreenInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenInfoExecute ]
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

/// 根据传参获取指标配置树内容
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexInfoSrv","QryQCEntityCatTree","99",1)
Query QryQCEntityCatTree(EntityCat As %String, aActive As %String = "") As %Query(ROWSPEC = "id:%String,code:%String,text:%String,iconCls:%String,checked:%String,state:%String,attributes:%String")
{
}

ClassMethod QryQCEntityCatTreeExecute(ByRef qHandle As %Binary, EntityCat As %String, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	if (EntityCat="") {
	 	Set xTypeId=0
	 	For
	 	{
		 	Set xTypeId        = $o(^DHCMA.Util.BT.DicTypeI("IdxofCode"," SDENTITYCAT",xTypeId))
		 	Quit:xTypeId=""
		 	Set xCode=""
		 	For{
			 	Set xCode        = $o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",xTypeId,xCode))
		 		Quit:xCode=""
		 		Set xDicID=""
		 		For{
			 		Set xDicID        = $o(^DHCMA.Util.BT.DictionaryI("IdxofTypeDrCode",xTypeId,xCode,xDicID))
		 			Quit:xDicID=""
		 			Set objDictionary        = ##class(DHCMA.Util.BT.Dictionary).GetObjById(xDicID)
		 			Continue:objDictionary.BTCode'["SD"
		 			Set Code             = objDictionary.BTCode
		 			Set Desc             = objDictionary.BTDesc  
		 			Set IsActive         = objDictionary.BTIsActive
		 			Continue:(aActive'="")&&(IsActive'=aActive)
		 			Set IsActive = $s(IsActive=1:"是",1:"否")
		 			Set Data=$lb(xDicID,Code,Desc,"","false","closed","")
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
			 	}
			 }
	 	}
 	}else {
	 	Set xCode=""
	 	For{
		 	Set xCode       		 = $o(^DHCMA.CPW.SD.QCEntityI("IdxofCode",xCode))
		 	Quit:xCode=""
		 	Set xEntityID=""
		 	For{
			 	Set xEntityID        = $o(^DHCMA.CPW.SD.QCEntityI("IdxofCode",xCode,xEntityID))
		 		Quit:xEntityID=""
		 		Set objEntity        = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(xEntityID)
		 		Set objEntityCat	 = objEntity.BTEntityCat
		 		Continue:'$IsObject(objEntityCat) 
		 		Continue:objEntityCat.%Id()'=EntityCat
		 		Set Code             = objEntity.BTCode
			 	Set Desc             = objEntity.BTDesc  
			 	Set Abbrev           = objEntity.BTAbbrev
			 	Set IsActive         = objEntity.BTIsActive
			 	Continue:(aActive'="")&&(IsActive'=aActive)
			 	Set IsActive = $s(IsActive=1:"是",1:"否")
			 	Set IndNo            = objEntity.BTIndNo
			 	Set Pubdate          = objEntity.BTPubdate 
			 	Set Data=$lb(xEntityID,Code,Desc,"","","","")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			 }
	 	}
	 	if (ind=1) {
		 	Set Data=$lb("","","无表单项目...","","","","")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	 }	
	Quit $$$OK
}

ClassMethod QryQCEntityCatTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCEntityCatTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCEntityCatTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCEntityCatTreeExecute ]
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

/// 获取父级指标
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexInfoSrv","QryQCHeadertype","37",1)
Query QryQCHeadertype(EntityId As %String, aType As %String = "0") As %Query(ROWSPEC = "RowId:%String,Desc:%String,field:%String,headertype:%String,active:%String,parent:%String,indexExp:%String,sort:%String")
{
}

ClassMethod QryQCHeadertypeExecute(ByRef qHandle As %Binary, EntityId As %String, aType As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set rowIdField=0,xParentid="",parenField=0
 	Set xSort=""
 	For{
	 	Set xSort         = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_EntityId," 1",xSort))
		Quit:xSort=""
		For{
		 	Set xParentid         = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_EntityId," 1",xSort,xParentid))
			Quit:xParentid=""	
			Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xParentid)
			Quit:'$IsObject(objInfo)
			Set active		= objInfo.active
			Continue:active=0
			Set type		= objInfo.type
			Continue:type'=aType
			Set title		= objInfo.title
			Set field		= objInfo.field
			Set headertype	= objInfo.headertype
			Set parentid	= objInfo.parentid
			Set indexExp	= objInfo.indexExp
			Set sort		= objInfo.sort
			
			Set Data=$lb(xParentid,title,field,headertype,active,parentid,indexExp,sort,closed)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}

	Quit $$$OK
}

ClassMethod QryQCHeadertypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCHeadertypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCHeadertypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCHeadertypeExecute ]
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

/// 绑定关联项
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexInfoSrv","QryQCItemInfo","7")
Query QryQCItemInfo(aIinkItem As %String) As %Query(ROWSPEC = "RowID:%String,ItemAbbrev:%String,ItemId:%String,ItemDesc:%String,indexExp:%String")
{
}

ClassMethod QryQCItemInfoExecute(ByRef qHandle As %Binary, aIinkItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aIinkItem="" $$$OK
 	Set xItemID=""
 	For{
	 	Set xItemID       	= $o(^DHCMA.CPW.SD.IndexInfoD(aIinkItem,"LinkItem",xItemID))
	 	Quit:xItemID=""
	 	Set objItem       	= ##class(DHCMA.CPW.SD.IndexItem).GetObjById(aIinkItem_"||"_xItemID)
	 	Continue:'$IsObject(objItem)
	 	Set objInfo     	= ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(aIinkItem)
	 	Continue:'$IsObject(objInfo)
	 	Set indexExp=objInfo.indexExp
	 	Set ItemAbbrev      = objItem.ItemAbbrev
	 	Set ItemId     		= objItem.ItemId
	 	Set obj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ItemId)
	 	Continue:'$IsObject(obj)
	 	Set ItemDesc=obj.BTDesc
	 	Set Data=$lb(xItemID,ItemAbbrev,ItemId,ItemDesc,indexExp)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	 }
 	
	Quit $$$OK
}

ClassMethod QryQCItemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCItemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCItemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCItemInfoExecute ]
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

/// w ##class(DHCMA.CPW.SDS.QCIndexInfoSrv).GetDataByEntity("4",1)
ClassMethod GetDataByEntity(EntityId As %String, aType As %String) As %String
{
	New (EntityId,aType)
	Set ^zqy52=$lb(EntityId)
	Quit:EntityId="" $$$OK
	Set data="",subData="",xData="",MtData="",SubMtData=""
	//没有多层父指标
	Set xSort=""
	For{
		Set xSort  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_EntityId," 0",xSort))
		Quit:xSort=""
		Set xId=""
		For{	
			Set xId  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_EntityId," 0",xSort,xId))
			Quit:xId=""
			Set obj = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xId)
			Quit:'$IsObject(obj)
			Set xparentid=obj.parentid
			Continue:xparentid'=xId
			Set xSubType=obj.type
			Continue:aType'=""&&aType'=xSubType
			Set xSubTitle=obj.title
			Set xfield=obj.field
			Set xSubTitleStr="title^field^align^rowspan"
			Set xSubValStr=xSubTitle_"^"_xfield_"^"_"center"_"^"_"2"
			Set xSubreturnJson=..getJsonData(xSubTitleStr,xSubValStr,"^")
			if (xData=""){
					Set xData=xSubreturnJson
				}else{
					Set xData=xData_","_xSubreturnJson
				}
		}
	}
	Set Sort=""
	For{
		Set Sort  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_EntityId," 1",Sort))
		Quit:Sort=""
		Set xIndexInfoId=""
		For{	
			Set xIndexInfoId  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_EntityId," 1",Sort,xIndexInfoId))
			Quit:xIndexInfoId=""
			Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xIndexInfoId)
			Quit:'$IsObject(objInfo)
			Set active=objInfo.active
			Continue:active'=1
			Set sort=objInfo.sort
			Set type=objInfo.type
			Continue:aType'=""&&aType'=type
			//统计末级指标
			Set SubSort="",xSubIndexNum=0
			For{
				Set SubSort  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEParref"," "_EntityId," "_xIndexInfoId,SubSort))
				Quit:SubSort=""	
				Set xSubIndexId=""
				For{
					Set xSubIndexId  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEParref"," "_EntityId," "_xIndexInfoId,SubSort,xSubIndexId))
					Continue:xSubIndexId=xIndexInfoId
					Quit:xSubIndexId=""
					Set objSubInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xSubIndexId)
					Quit:'$IsObject(objSubInfo)
					Set Subactive=objSubInfo.active
					Continue:Subactive'=1
					Set SubType=objSubInfo.type
					Continue:aType'=""&&aType'=SubType
					Set:xSubIndexId'=xIndexInfoId xSubIndexNum=xSubIndexNum+1		//统计父级有几个子级
					Set SubTitle=objSubInfo.title
					Set field=objSubInfo.field
					Set SubTitleStr="title^field^align^width^halign"
					if (aType=1){
						if ($l(SubTitle)<10){
							Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"150"_"^"_"center"
						}else{
							Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"280"_"^"_"center"
						}
					}else{
						if ($l(SubTitle)<=5){
							Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"80"_"^"_"center"
						}elseif($l(SubTitle)>5)&&($l(SubTitle)<=10){
							Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"150"_"^"_"center"
						}elseif($l(SubTitle)>10)&&($l(SubTitle)<16){
							Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"210"_"^"_"center"
						}else{
							Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"280"_"^"_"center"
						}
					}
					/*if ($l(SubTitle)<10&&aType=1) {
						Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"130"_"^"_"center"
					}elseif($l(SubTitle)>=10&&aType=1){
						Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"280"_"^"_"center"
					}elseif($l(SubTitle)<10&&aType=0){
						Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"130"_"^"_"center"
					}elseif($l(SubTitle)>=10&&aType=0){
						Set SubValStr=SubTitle_"^"_field_"^"_"center"_"^"_"280"_"^"_"center"
					}*/
					Set SubreturnJson=..getJsonData(SubTitleStr,SubValStr,"^")
					if (field'["field"){
						if (SubMtData=""){
							Set SubMtData=SubreturnJson
						}else{
							Set SubMtData=SubMtData_","_SubreturnJson
						}
					}else{
						if (subData=""){
							Set subData=SubreturnJson
						}else{
							Set subData=subData_","_SubreturnJson
						}
					}
				}
			}
			//父指标
			Set title=objInfo.title
			Set titleStr="title^field^align^colspan^halign"
			Set valStr=title_"^"_""_"^"_"center"_"^"_xSubIndexNum_"^"_"center"
			Set returnJson=..getJsonData(titleStr,valStr,"^")
			if (title="基础信息"){
				Set MtData=returnJson
			}else{
				if (data=""){
					Set data=returnJson
				}else{
					Set data=data_","_returnJson
				}
			}
		}
	}
	if ((xData="")&&(data="")){
		if (subData=""){
			Quit "[["_MtData_"],["_SubMtData_"]]"
		}else{
			Quit "[["_MtData_"],["_SubMtData_","_subData_"]]"
		}
	}Elseif (xData=""){
		if (subData=""){
			Quit "[["_MtData_","_data_"],["_SubMtData_"]]"
		}else{
			Quit "[["_MtData_","_data_"],["_SubMtData_","_subData_"]]"
		}
	}Elseif (data=""){
		if (subData=""){
			Quit "[["_MtData_","_xData_"],["_SubMtData_"]]"
		}else{
			Quit "[["_MtData_","_xData_"],["_SubMtData_","_subData_"]]"
		}
	}
	else{
		Quit "[["_MtData_","_data_","_xData_"],["_SubMtData_","_subData_"]]"
	}
}

/// 取值
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexInfoSrv","QryQCDataByEntity","1","","4","","","2019-01-01","2019-12-26","")
Query QryQCDataByEntity(aEntity As %String, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aType As %String = "0") As %Query(ROWSPEC = "Mon:%String,Total:%String,field1:%String,field10:%String,field11:%String,field12:%String,field13:%String,field14:%String,field15:%String,field16:%String,field17:%String,field18:%String,field19:%String,field2:%String,field20:%String,field21:%String,field22:%String,field23:%String,field24:%String,field25:%String,field26:%String,field27:%String,field28:%String,field29:%String,field3:%String,field30:%String,field31:%String,field32:%String,field33:%String,field34:%String,field35:%String,field36:%String,field37:%String,field38:%String,field39:%String,field4:%String,field40:%String,field5:%String,field6:%String,field7:%String,field8:%String,field9:%String")
{
}

ClassMethod QryQCDataByEntityExecute(ByRef qHandle As %Binary, aEntity As %String, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aType As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ^zqy5=$lb(aEntity,aStaType,ayear,aQuarter,aDateFrom,aDateTo)
 	Set Params=##Class(DHCMA.CPW.SDS.Stat.StatService).GetStatParams(aStaType,ayear,aQuarter,aDateFrom,aDateTo)
 	Set DimenMark	= $p(Params,"^",1)
	Set aDateFrom	= $p(Params,"^",2)
	Set aDateTo		= $p(Params,"^",3)
	Set ArrayStatDimens=##Class(DHCMA.CPW.SDS.Stat.StatService).GetArrayStatDimens(DimenMark,aDateFrom,aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aEntity="") $$$OK

 	Set total="",xflag=""
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)

 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	Set:aDateType="3" DischDateIndex="PAADM_AdmDate"
	For xDate=aDateFrom:1:aDateTo {
		set Moth=$p($zd(xDate,3),"-",1,2)	//按月展示
		Set xPaadm=""
		//查找合适的患者
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set EpisodeID	= ##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
			Set MrlistID	= $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:MrlistID=""
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Set InLocOID=MrListObj.QCInLocID
			Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",MrlistID,""),-1)
			Set QCCurrStatusID=MrlistID_"||"_QCCurrStatusSubID
			Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
			Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode
			Continue:QCCurrStateCode'="Up"		//Up
			Continue:MrListObj.QCEntityDr.%Id()'=aEntity
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
			}
			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Set AdmLocDesc=ObjPaadm.PAAdmLocDesc
			Set AdmLocID=ObjPaadm.PAAdmLocID
			Continue:(aLocID'="")&&(aLocID'=AdmLocID)
			Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
	 		Continue:(aHospID'="")&&(aHospID'[xHospID)
			
			Set total=total+1
			if ('$d(^||TMP("QryMonthPeo",repid,Moth))){
				Set ^||TMP("QryMonthPeo",repid,Moth)=1
			}else{
				Set ^||TMP("QryMonthPeo",repid,Moth)=1+^||TMP("QryMonthPeo",repid,Moth)
			}
			Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
			Set Sort=""
			For{
				Set Sort  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort))
				Quit:Sort=""
				Set xInfoId=""
				//当前病种的指标数据
				For{
					Set xInfoId  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort,xInfoId))	
					Quit:xInfoId=""
					Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xInfoId)
					Quit:'$IsObject(objInfo)
					Set active=objInfo.active
					Continue:active=0
					Set indexExp=objInfo.indexExp
					Continue:indexExp=""
					Set type=objInfo.type
					Continue:type'=aType
					Set field=objInfo.field
					Set title=objInfo.title
					Set xItemID="",xItemValue="",xCode="",xValue=""
					For{
						Set xItemID = $o(^DHCMA.CPW.SD.IndexInfoD(xInfoId,"LinkItem",xItemID))
						Quit:xItemID=""
						Set xItemId=xInfoId_"||"_xItemID
						Set objItem = ##class(DHCMA.CPW.SD.IndexItem).GetObjById(xItemId)
						Quit:'$IsObject(objItem)
						Set ItemAbbrev=objItem.ItemAbbrev	
						Set ItemId=objItem.ItemId
						Set xItemValue=..GetItemShowValue(MrlistID,ItemId)
						Set:xItemValue="" xCode=""
						Set:xItemValue'="" xCode=$p(xItemValue ,$c(1),1)	
						Set:xItemValue'="" xValue=$p(xItemValue ,$c(1),2)
						Set:((xCode="")&&(indexExp["-")) xCode=0
						//(indexExp["+")||(indexExp["-")))
						//返回值需要转换时间
						Set:title["天" xCode=$p(xCode," ",1)
						if ((xCode["/")||(xCode["-"))&&((xCode[" ")&&(xCode[":")){
							/*
							Set tmpHour=0
							Set tmpDate=$p(xCode," ",1)
							Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
							Set tmpTime=$p(xCode," ",2),tmpTimeLogic=0
							Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
							//将各个时间参数换算为小时
							Set xCode=(tmpDateLogic-60000)*24+(tmpTimeLogic\3600)
							*/
							//将各个时间参数换算为分钟
							Set thisDate=$p(xCode," ",1)
							Set thisTime=$p(xCode," ",2)
							Set thisLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(thisDate)
							Set thisLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(thisTime)
							Set xCode=(thisLogicDate*86400+thisLogicTime)\60
							;b ;1
							
						}elseif ((xCode["-")||(xCode["/")){
							Set xCode=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xCode)
						}else{
							Set xCode=xCode
						}
						If ((indexExp["平均值")&&(indexExp["#")){
							Set xindexExp=$p(indexExp,"平均值",2)
							Set xindexExp=$Replace(xindexExp,ItemAbbrev,xCode)
							Set indexExp="平均值"_xindexExp
						}
						else{
							Set indexExp=$Replace(indexExp,ItemAbbrev,xCode)
						}
					}
					//根据表达式取值
					If (indexExp["#"){
						Set aflag=0
						Set xindexExp=$p(indexExp,"#",1)
						Set RetVal=$p(indexExp,"#",2)
						if ((xindexExp="")||(xindexExp="平均值")){
							Set aflag=1
						}
						elseif(xindexExp["平均值"){		
							Set PindexExp=$p(xindexExp,"平均值",1)
							Set PRevVal=$p(xindexExp,"平均值",2)
							Set:PRevVal'="" Exp="if "_PRevVal_"{Set aflag=1}"
							x Exp
						}else{
							Set:xindexExp'="" Exp="if "_xindexExp_"{Set aflag=1}"
							x Exp
						}
						if (aflag=1){
							
							Set Exp="Set result="_RetVal
							x Exp
							if (xindexExp'["平均值"){
								if (title["占比"){
									if ('$d(^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field))){
										Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=result
									}else{
										Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)+result
									}
								}else{
								if ('$d(^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field))){
									Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field)=result
								}else{
									Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field)=^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field)+result
									}	
								}
							}else{
								if ('$d(^||TMP("QryQCDataByEntity",repid,"Average",Moth,field))){
									Set ^||TMP("QryQCDataByEntity",repid,"Average",Moth,field)=result
								}else{
									Set ^||TMP("QryQCDataByEntity",repid,"Average",Moth,field)=^||TMP("QryQCDataByEntity",repid,"Average",Moth,field)+result
								}
							}
						}
						elseIf((aflag=0)&&(title["占比")){
							if ('$d(^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field))){
								Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=flag
							}else{
								Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)+flag
							}
						}
					}else{
						Set flag=0
						Set Exp="if "_indexExp_"{Set flag=1}"
						x Exp
						if (title["占比"){
							if ('$d(^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field))){
								Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=flag
							}else{
								Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)+flag
							}
						}else{
							if ('$d(^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field))){
								//Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field)=xCode
								Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field)=flag
							}else{
								//Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field)=^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field)+xCode
								Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field)=^||TMP("QryQCDataByEntity",repid,"Nor",Moth,field)+flag
							}
						}
					}
				}
			}
			
		}
	}
	//平均值
	Set xType=""
	For{
		Set xType = $o(^||TMP("QryQCDataByEntity",repid,xType))
		Quit:xType=""
		Set xMoth=""
		For{
			Set xMoth = $o(^||TMP("QryQCDataByEntity",repid,xType,xMoth))
			Quit:xMoth=""
			Set MothTotal=$g(^||TMP("QryMonthPeo",repid,xMoth))
			Set xfield=""
			For{
				Set xfield = $o(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xfield))
				Quit:xfield=""
				if (xType="Average"){
					if ('$d(^||TMP($this,"Average",repid,xfield))){
						Set ^||TMP($this,"Average",repid,xfield)=$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xfield))
					}else{
						Set ^||TMP($this,"Average",repid,xfield)=$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xfield))+^||TMP($this,"Average",repid,xfield)
					}
					//Set ^||TMP($this,"Average",repid,xfield)=$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xfield))+^||TMP($this,"Average",repid,xfield)
					Set Value=$fn($g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xfield))/MothTotal,"",2)
				}Elseif(xType="Pre"){
					if ('$d(^||TMP($this,"Pre",repid,xfield))){
						Set ^||TMP($this,"Pre",repid,xfield)=$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xfield))
					}else{
						Set ^||TMP($this,"Pre",repid,xfield)=$g(^||TMP($this,"Pre",repid,xfield))+$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xfield))
					}
					Set Value=$fn($g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xfield))/MothTotal*100,"",1)_"%"
				}else{
					Set Value=$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xfield))
				}
				Set ^||TMP("OrderByFiled",repid,xMoth,xfield)=Value
			}
		}
		
	}
	
	Set fromYear=$p($zd(aDateFrom,3),"-",1)
	Set fromMonth=$p($zd(aDateFrom,3),"-",2)
	Set toYear=$p($zd(aDateTo,3),"-",1)
	Set toMonth=$p($zd(aDateTo,3),"-",2)
	for Year=fromYear:1:toYear {
		if (fromYear=toYear){
			Set staMonth=fromMonth
			Set endMonth=toMonth
		}
		Elseif (Year=fromYear){
			Set staMonth=fromMonth
			Set endMonth=12
		}
		ElseIf (Year=toYear){
			Set endMonth=toMonth
			Set staMonth=1
		}
		else{
			Set endMonth=12
			Set staMonth=1
		}
		For xMonth=staMonth:1:endMonth{
			Set outMonth=xMonth
			Set:xMonth<10 outMonth="0"_xMonth
			Set YearMonth=Year_"-"_outMonth
			For fieldNum=1:1:40{
				i '$d(^||TMP("OrderByFiled",repid,YearMonth,"field"_fieldNum)){
					Set ^||TMP("OrderByFiled",repid,YearMonth,"field"_fieldNum)=0
				}	
			}
		}
	}
	
	Set xYMonth=""
	For {
		Set xYMonth = $o(^||TMP("OrderByFiled",repid,xYMonth))
		Quit:xYMonth=""
		Set xVal="",Val=""
		For{
			Set xVal = $o(^||TMP("OrderByFiled",repid,xYMonth,xVal))
			Quit:xVal=""
			if ('$d(^||TMP($this,"Total",repid,xVal))){
				Set ^||TMP($this,"Total",repid,xVal)=$g(^||TMP("OrderByFiled",repid,xYMonth,xVal))
			}else{
				Set ^||TMP($this,"Total",repid,xVal)=$g(^||TMP($this,"Total",repid,xVal))+$g(^||TMP("OrderByFiled",repid,xYMonth,xVal))
			}
			if (Val=""){
				Set Val=$g(^||TMP("OrderByFiled",repid,xYMonth,xVal))
			}else{
				Set Val=Val_"^"_$g(^||TMP("OrderByFiled",repid,xYMonth,xVal))
			}
		}
		
		Set MTotal=$g(^||TMP("QryMonthPeo",repid,xYMonth))
		Set:MTotal="" MTotal=0
		Continue:MTotal=0		//不展示数据为空
		Set xYear=$p(xYMonth,"-",1)
		Set xMDate=$p(xYMonth,"-",2)
		Set MTotal="<a href='#' class='btn_detail' onclick='obj.OpenPeoReport("_xYear_","_xMDate_")'>"_MTotal_"</a>"
		Set Val=xYMonth_"^"_MTotal_"^"_Val
		s data=$lfs(Val,"^")
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}	
	Set xValue="" ,totalVal=""
	For{
		Set xValue=$o(^||TMP($this,"Total",repid,xValue))
		Quit:xValue=""
		Set PreTo="",AveTo=""
		if ($d(^||TMP($this,"Pre",repid,xValue))){
			Set PreTo=$fn($g(^||TMP($this,"Pre",repid,xValue))/total*100,"",2)_"%"
		}
		if ($d(^||TMP($this,"Average",repid,xValue))){
			Set AveTo=$fn($g(^||TMP($this,"Average",repid,xValue))/total,"",2)
		}
		if (totalVal=""){
			if (PreTo'=""){
				Set totalVal=PreTo
			}
			Elseif (AveTo=""){
				Set totalVal=AveTo
			}
			else{
				Set totalVal=$fn($g(^||TMP($this,"Total",repid,xValue))/total,"",2)
			}
		}else{
			if (PreTo'=""){
				Set totalVal=totalVal_"^"_PreTo
			}
			Elseif (AveTo'=""){
				Set totalVal=totalVal_"^"_AveTo
			}
			else{
				Set totalVal=totalVal_"^"_($fn($g(^||TMP($this,"Total",repid,xValue))/total,"",2))
			}
		}
	}
	//Set:total'="" totalVal="合计平均:"_"^"_total_"^"_totalVal
	Set:total'="" totalVal="<a href='#' class='btn_detail' title='占比统计图' onclick='obj.OpenGraphics()'>"_"合计平均:"_"</a>"_"^"_"<a href='#' class='btn_detail' onclick='obj.OpenPeoReportAll()'>"_total_"</a>"_"^"_totalVal
	
	Set:total="" totalVal="暂无数据"
	Set data=$lfs(totalVal,"^")
	Set ^CacheTemp(repid,ind)=data
	Set ind=ind+1
	k ^||TMP($this,"Total",repid)
	k ^||TMP($this,"Pre",repid)
	k ^||TMP($this,"Average",repid)
	k ^||TMP("QryQCDataByEntity",repid)
	k ^||TMP("OrderByFiled",repid)
	k ^||TMP("QryMonthPeo",repid)
	Quit $$$OK
}

ClassMethod QryQCDataByEntityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCDataByEntityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCDataByEntityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCDataByEntityExecute ]
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

/// 每个病种时间+科室输出
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexInfoSrv","QryQCDataByEntityLoc","11","","1","2020","","","","")
Query QryQCDataByEntityLoc(aEntity As %String, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aType As %String = "0") As %Query(ROWSPEC = "Mon:%String,Total:%String,LocD:%String,UpEntity:%String,field1:%String,field10:%String,field11:%String,field12:%String,field13:%String,field14:%String,field15:%String,field16:%String,field17:%String,field18:%String,field19:%String,field2:%String,field20:%String,field21:%String,field22:%String,field23:%String,field24:%String,field25:%String,field26:%String,field27:%String,field28:%String,field29:%String,field3:%String,field30:%String,field31:%String,field32:%String,field33:%String,field34:%String,field35:%String,field36:%String,field37:%String,field38:%String,field39:%String,field4:%String,field40:%String,field5:%String,field6:%String,field7:%String,field8:%String,field9:%String")
{
}

ClassMethod QryQCDataByEntityLocExecute(ByRef qHandle As %Binary, aEntity As %String, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String, aType As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ^zqy52=$lb(aEntity,aStaType,ayear,aQuarter,aDateFrom,aDateTo)
 	Set Params=##Class(DHCMA.CPW.SDS.Stat.StatService).GetStatParams(aStaType,ayear,aQuarter,aDateFrom,aDateTo)
 	Set DimenMark	= $p(Params,"^",1)
	Set aDateFrom	= $p(Params,"^",2)
	Set aDateTo		= $p(Params,"^",3)
	Set ArrayStatDimens=##Class(DHCMA.CPW.SDS.Stat.StatService).GetArrayStatDimens(DimenMark,aDateFrom,aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aEntity="") $$$OK

 	Set total="",xflag=""
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)

 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	Set:aDateType="3" DischDateIndex="PAADM_AdmDate"
	For xDate=aDateFrom:1:aDateTo {
		set Moth=$p($zd(xDate,3),"-",1,2)	//按月展示
		Set xPaadm=""
		//查找合适的患者
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set EpisodeID	= ##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
			Set MrlistID	= $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:MrlistID=""
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Set InLocOID=MrListObj.QCInLocID
			Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",MrlistID,""),-1)
			Set QCCurrStatusID=MrlistID_"||"_QCCurrStatusSubID
			Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
			Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode
			Set total=total+1 //总人数包含未上报的
			Continue:QCCurrStateCode'="Up"		//Up
			Continue:MrListObj.QCEntityDr.%Id()'=aEntity
			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Set AdmLocDesc=ObjPaadm.PAAdmLocDesc
			Set AdmLocID=ObjPaadm.PAAdmLocID
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
			}
			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Set AdmLocDesc=ObjPaadm.PAAdmLocDesc
			Set AdmLocID=ObjPaadm.PAAdmLocID
			Continue:(aLocID'="")&&(aLocID'=AdmLocID)
			Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
	 		Continue:(aHospID'="")&&(aHospID'[xHospID)
			//Set total=total+1  //总人数只包含上报的
			if ('$d(^||TMP("QryMonthPeo",repid,Moth,AdmLocDesc))){
				Set ^||TMP("QryMonthPeo",repid,Moth,AdmLocDesc)=1
			}else{
				Set ^||TMP("QryMonthPeo",repid,Moth,AdmLocDesc)=1+^||TMP("QryMonthPeo",repid,Moth,AdmLocDesc)
			}
			Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
			Set Sort=""
			For{
				Set Sort  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort))
				Quit:Sort=""
				Set xInfoId=""
				//当前病种的指标数据
				For{
					Set xInfoId  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort,xInfoId))	
					Quit:xInfoId=""
					Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xInfoId)
					Quit:'$IsObject(objInfo)
					Set active=objInfo.active
					Continue:active=0
					Set indexExp=objInfo.indexExp
					Continue:indexExp=""
					Set type=objInfo.type
					Continue:type'=aType
					Set field=objInfo.field
					Set title=objInfo.title
					Set xItemID="",xItemValue="",xCode="",xValue=""
					For{
						Set xItemID = $o(^DHCMA.CPW.SD.IndexInfoD(xInfoId,"LinkItem",xItemID))
						Quit:xItemID=""
						Set xItemId=xInfoId_"||"_xItemID
						Set objItem = ##class(DHCMA.CPW.SD.IndexItem).GetObjById(xItemId)
						Quit:'$IsObject(objItem)
						Set ItemAbbrev=objItem.ItemAbbrev	
						Set ItemId=objItem.ItemId
						Set xItemValue=..GetItemShowValue(MrlistID,ItemId)
						Set:xItemValue="" xCode=""
						Set:xItemValue'="" xCode=$p(xItemValue ,$c(1),1)	
						Set:xItemValue'="" xValue=$p(xItemValue ,$c(1),2)
						Set:((xCode="")&&(indexExp["-")) xCode=0
						//(indexExp["+")||(indexExp["-")))
						//返回值需要转换时间
						Set:title["天" xCode=$p(xCode," ",1)
						Set:title["日" xCode=$p(xCode," ",1)
						if ((xCode["-")||(xCode["\"))&&((xCode[" ")&&(xCode[":")){
							Set thisDate=$p(xCode," ",1)
							Set thisTime=$p(xCode," ",2)
							Set thisLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(thisDate)
							Set thisLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(thisTime)
							Set xCode=(thisLogicDate*86400+thisLogicTime)\60
						}elseif ((xCode["-")||(xCode["/")){
							Set xCode=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xCode)
						}else{
							Set xCode=xCode
						}
						If ((indexExp["平均值")&&(indexExp["#")){
							Set xindexExp=$p(indexExp,"平均值",2)
							Set xindexExp=$Replace(xindexExp,ItemAbbrev,xCode)
							Set indexExp="平均值"_xindexExp
						}ElseIf(indexExp["len"){
							Set len=$l(xCode,",")
							Set indexExp=$Replace(indexExp,ItemAbbrev,len)
						}
						else{
							Set indexExp=$Replace(indexExp,ItemAbbrev,xCode)
						}
					}
					//根据表达式取值
					If (indexExp["#"){
						Set aflag=0
						Set xindexExp=$p(indexExp,"#",1)
						Set RetVal=$p(indexExp,"#",2)
						if ((xindexExp="")||(xindexExp="平均值")){
							Set aflag=1
						}
						elseif(xindexExp["平均值"){		
							Set PindexExp=$p(xindexExp,"平均值",1)
							Set PRevVal=$p(xindexExp,"平均值",2)
							Set:PRevVal'="" Exp="if "_PRevVal_"{Set aflag=1}"
							x Exp
						}else{
							Set:xindexExp'="" Exp="if "_xindexExp_"{Set aflag=1}"
							x Exp
						}
						if (aflag=1){
							Set Exp="Set result="_RetVal
							x Exp
							if (xindexExp'["平均值"){
								if (title["占比"){
									if ('$d(^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field))){
										Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=result
									}else{
										Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)+result
									}
								}else{
									if ('$d(^||TMP("QryQCDataByEntity",repid,"Nor",Moth,AdmLocDesc,field))){
										Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,AdmLocDesc,field)=result
									}else{
										Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,AdmLocDesc,field)=^||TMP("QryQCDataByEntity",repid,"Nor",Moth,AdmLocDesc,field)+result
									}
								}
							}else{
								if ('$d(^||TMP("QryQCDataByEntity",repid,"Average",Moth,AdmLocDesc,field))){
									Set ^||TMP("QryQCDataByEntity",repid,"Average",Moth,AdmLocDesc,field)=result
								}else{
									Set ^||TMP("QryQCDataByEntity",repid,"Average",Moth,AdmLocDesc,field)=^||TMP("QryQCDataByEntity",repid,"Average",Moth,AdmLocDesc,field)+result
								}
							}
							
						}
						elseIf((aflag=0)&&(title["占比")){
							if ('$d(^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field))){
								Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=flag
							}else{
								Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)=^||TMP("QryQCDataByEntity",repid,"Pre",Moth,field)+flag
							}
						}
					}else{
						Set flag=0
						Set Exp="if "_indexExp_"{Set flag=1}"
						x Exp
						if (title["占比"){
							if ('$d(^||TMP("QryQCDataByEntity",repid,"Pre",Moth,AdmLocDesc,field))){
								Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,AdmLocDesc,field)=flag
							}else{
								Set ^||TMP("QryQCDataByEntity",repid,"Pre",Moth,AdmLocDesc,field)=^||TMP("QryQCDataByEntity",repid,"Pre",Moth,AdmLocDesc,field)+flag
							}
						}else{
							if ('$d(^||TMP("QryQCDataByEntity",repid,"Nor",Moth,AdmLocDesc,field))){
								Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,AdmLocDesc,field)=flag
							}else{
								Set ^||TMP("QryQCDataByEntity",repid,"Nor",Moth,AdmLocDesc,field)=^||TMP("QryQCDataByEntity",repid,"Nor",Moth,AdmLocDesc,field)+flag
							}
						}
					}
				}
			}
			
		}
	}
	//安月统计
	Set xType=""
	For{
		Set xType = $o(^||TMP("QryQCDataByEntity",repid,xType))
		Quit:xType=""
		Set xMoth=""
		For{
			Set xMoth = $o(^||TMP("QryQCDataByEntity",repid,xType,xMoth))
			Quit:xMoth=""
			//***
			Set xLoc=""
			For{
				Set xLoc = $o(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xLoc))
				Quit:xLoc=""
				Set MothTotal=$g(^||TMP("QryMonthPeo",repid,xMoth,xLoc))
				Set xfield=""
				For{
					Set xfield = $o(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xLoc,xfield))
					Quit:xfield=""
					if (xType="Average"){
						if ('$d(^||TMP($this,"Average",repid,xLoc,xfield))){
							Set ^||TMP($this,"Average",repid,xLoc,xfield)=$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xLoc,xfield))
						}else{
							Set ^||TMP($this,"Average",repid,xLoc,xfield)=$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xLoc,xfield))+^||TMP($this,"Average",repid,xLoc,xfield)
						}
						Set Value=$fn($g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xLoc,xfield))/MothTotal,"",2)
					}Elseif(xType="Pre"){
						if ('$d(^||TMP($this,"Pre",repid,xLoc,xfield))){
							Set ^||TMP($this,"Pre",repid,xLoc,xfield)=$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xLoc,xfield))
						}else{
							Set ^||TMP($this,"Pre",repid,xLoc,xfield)=$g(^||TMP($this,"Pre",repid,xLoc,xfield))+$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xLoc,xfield))
						}
						Set Value=$fn($g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xLoc,xfield))/MothTotal*100,"",1)_"%"
					}else{
						Set Value=$g(^||TMP("QryQCDataByEntity",repid,xType,xMoth,xLoc,xfield))
					}
					Set ^||TMP("OrderByFiled",repid,xMoth,xLoc,xfield)=Value
				}
			}
			//**
		}
		
	}
	
	Set fromYear=$p($zd(aDateFrom,3),"-",1)
	Set fromMonth=$p($zd(aDateFrom,3),"-",2)
	Set toYear=$p($zd(aDateTo,3),"-",1)
	Set toMonth=$p($zd(aDateTo,3),"-",2)
	for Year=fromYear:1:toYear {
		if (fromYear=toYear){
			Set staMonth=fromMonth
			Set endMonth=toMonth
		}
		Elseif (Year=fromYear){
			Set staMonth=fromMonth
			Set endMonth=12
		}
		ElseIf (Year=toYear){
			Set endMonth=toMonth
			Set staMonth=1
		}
		else{
			Set endMonth=12
			Set staMonth=1
		}
		For xMonth=staMonth:1:endMonth{
			Set outMonth=xMonth
			Set:xMonth<10 outMonth="0"_xMonth
			Set YearMonth=Year_"-"_outMonth
			Set xLocDesc=""
			For{
				Set xLocDesc=$o(^||TMP("OrderByFiled",repid,YearMonth,xLocDesc))
				Quit:xLocDesc=""
				For fieldNum=1:1:40{
					i '$d(^||TMP("OrderByFiled",repid,YearMonth,xLocDesc,"field"_fieldNum)){
						Set ^||TMP("OrderByFiled",repid,YearMonth,xLocDesc,"field"_fieldNum)=0
					}	
				}
			}
			
		}
	}
	
	Set xYMonth=""
	For {
		Set xYMonth = $o(^||TMP("OrderByFiled",repid,xYMonth))
		Quit:xYMonth=""
		Set xLocD=""
		For{
			Set xLocD = $o(^||TMP("OrderByFiled",repid,xYMonth,xLocD))
			Quit:xLocD=""
			Set xVal="",Val=""
			For{
				Set xVal = $o(^||TMP("OrderByFiled",repid,xYMonth,xLocD,xVal))
				Quit:xVal=""
				if ('$d(^||TMP($this,"Total",repid,xLocD,xVal))){
					Set ^||TMP($this,"Total",repid,xLocD,xVal)=$g(^||TMP("OrderByFiled",repid,xYMonth,xLocD,xVal))
				}else{
					Set ^||TMP($this,"Total",repid,xLocD,xVal)=$g(^||TMP($this,"Total",repid,xLocD,xVal))+$g(^||TMP("OrderByFiled",repid,xYMonth,xLocD,xVal))
				}
				if (Val=""){
					Set Val=$g(^||TMP("OrderByFiled",repid,xYMonth,xLocD,xVal))
				}else{
					Set Val=Val_"^"_$g(^||TMP("OrderByFiled",repid,xYMonth,xLocD,xVal))
				}
			}
			Set MTotal=$g(^||TMP("QryMonthPeo",repid,xYMonth,xLocD))
			Set:MTotal="" MTotal=0
			Continue:MTotal=0		//不展示数据为空
			Set xYear=$p(xYMonth,"-",1)
			Set xMDate=$p(xYMonth,"-",2)
			Set Entity=$fn(MTotal/total*100,"",2)_"%"	//病种上报率
			s AdmLocID=$o(^CTLOC(0,"Desc",xLocD,0))
			Set MTotal="<a href='#' class='btn_detail' onclick='obj.OpenPeoReport2("_xYear_","_xMDate_","_AdmLocID_")'>"_MTotal_"</a>"
			Set Val=xYMonth_"^"_MTotal_"^"_xLocD_"^"_Entity_"^"_Val
			s data=$lfs(Val,"^")
			Set ^CacheTemp(repid,ind)=data
			Set ind=ind+1
		}	
	}	
	Set LocDesc=""
	For{
		Set LocDesc=$o(^||TMP($this,"Total",repid,LocDesc))
		Quit:LocDesc=""
		Set xValue="" ,totalVal=""
		For{
			Set xValue=$o(^||TMP($this,"Total",repid,LocDesc,xValue))
			Quit:xValue=""
			Set PreTo="",AveTo=""
			if ($d(^||TMP($this,"Pre",repid,LocDesc,xValue))){
				Set PreTo=$fn($g(^||TMP($this,"Pre",repid,LocDesc,xValue))/total*100,"",2)_"%"
			}
			if ($d(^||TMP($this,"Average",repid,xValue))){
				Set AveTo=$fn($g(^||TMP($this,"Average",repid,LocDesc,xValue))/total,"",2)
			}
			if (totalVal=""){
				if (PreTo'=""){
					Set totalVal=PreTo
				}
				Elseif (AveTo=""){
					Set totalVal=AveTo
				}
				else{
					Set totalVal=$fn($g(^||TMP($this,"Total",repid,LocDesc,xValue))/total,"",2)
				}
			}else{
				if (PreTo'=""){
					Set totalVal=totalVal_"^"_PreTo
				}
				Elseif (AveTo'=""){
					Set totalVal=totalVal_"^"_AveTo
				}
				else{
					Set totalVal=totalVal_"^"_($fn($g(^||TMP($this,"Total",repid,LocDesc,xValue))/total,"",2))
				}
			}
		}
	}
	
	Set:total'="" totalVal="病种人数:"_"^"_total
	Set:total="" totalVal="暂无数据"
	Set data=$lfs(totalVal,"^")
	Set ^CacheTemp(repid,ind)=data
	Set ind=ind+1
	k ^||TMP($this,"Total",repid)
	k ^||TMP($this,"Pre",repid)
	k ^||TMP($this,"Average",repid)
	k ^||TMP("QryQCDataByEntity",repid)
	k ^||TMP("OrderByFiled",repid)
	k ^||TMP("QryMonthPeo",repid)
	Quit $$$OK
}

ClassMethod QryQCDataByEntityLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCDataByEntityLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCDataByEntityLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCDataByEntityLocExecute ]
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

/// w ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay("2018-02")
ClassMethod GetMonthStaLastDay(aDate As %String = "", aIsOriginal As %String = "0") As %String
{
	New (aDate,aIsOriginal)
	Set return="^"
	Set aDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(aDate)
	Set:(aDate="") aDate=$e($zd(+$h,3),1,7)
	Set $ZT="GetMonthLastDayErr"
	
	Set aYear=$p(aDate,"-",1)
	Set aMonth=$p(aDate,"-",2)
	If (aYear="")||($l(aYear)<4){
		Set aMonth=aYear
		Set aYear=$e($zd($h,3),1,4)
	}
	Set:aMonth="" aMonth=$e($zd($h,3),6,7)
	
	Set StartDay=aYear_"-"_aMonth_"-"_"01"
	Set StartDayOrig=+$zdh(StartDay,3)
	
	Set nextMonth=$zd(StartDayOrig+32,3)
	Set nextMonth=$e(nextMonth,1,7)_"-"_"01"
	
	Set lastDay=+$zdh(nextMonth,3)-1
	If (aIsOriginal="0") {
		Set lastDay=$zd(lastDay,3)
	} Else {
		Set StartDay=StartDayOrig
	}
	Quit StartDay_"^"_lastDay
GetMonthLastDayErr
	Quit return
}

/// 取值
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexInfoSrv","QryQCDataByPeo","11","2!!1","2020-05","98!!1","1")
Query QryQCDataByPeo(aEntity As %String, aHospID As %String, aDate As %String, aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "", aStaType As %String = "", ayear As %String = "", aQuarter As %String = "", aType As %String = "1") As %Query(ROWSPEC = "name:%String,UpDTime:%String,DischDateT:%String,MrNo:%String,field1:%String,field10:%String,field11:%String,field12:%String,field13:%String,field14:%String,field15:%String,field16:%String,field17:%String,field18:%String,field19:%String,field2:%String,field20:%String,field21:%String,field22:%String,field23:%String,field24:%String,field25:%String,field26:%String,field27:%String,field28:%String,field29:%String,field3:%String,field30:%String,field31:%String,field32:%String,field33:%String,field34:%String,field35:%String,field36:%String,field37:%String,field38:%String,field39:%String,field4:%String,field40:%String,field41:%String,field42:%String,field43:%String,field44:%String,field45:%String,field46:%String,field47:%String,field48:%String,field49:%String,field5:%String,field50:%String,field51:%String,field52:%String,field53:%String,field54:%String,field55:%String,field56:%String,field57:%String,field58:%String,field59:%String,field6:%String,field60:%String,field61:%String,field62:%String,field63:%String,field64:%String,field65:%String,field66:%String,field67:%String,field68:%String,field69:%String,field7:%String,field70:%String,field71:%String,field72:%String,field73:%String,field74:%String,field75:%String,field76:%String,field77:%String,field78:%String,field79:%String,field8:%String,field80:%String,field81:%String,field82:%String,field83:%String,field84:%String,field85:%String,field86:%String,field87:%String,field88:%String,field89:%String,field9:%String,field90:%String,field91:%String,field92:%String,field93:%String,field94:%String,field95:%String,field96:%String,field97:%String,field98:%String,field99:%String")
{
}

ClassMethod QryQCDataByPeoExecute(ByRef qHandle As %Binary, aEntity As %String, aHospID As %String, aDate As %String, aLocID As %String, aDateFrom As %String = "", aDateTo As %String = "", aStaType As %String = "", ayear As %String = "", aQuarter As %String = "", aType As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aEntity="") $$$OK
	if (aDate=""){
		Set Params=##Class(DHCMA.CPW.SDS.Stat.StatService).GetStatParams(aStaType,ayear,aQuarter,aDateFrom,aDateTo)
	 	Set DimenMark	= $p(Params,"^",1)
		Set aDateFrom	= $p(Params,"^",2)
		Set aDateTo		= $p(Params,"^",3)
	}else{
		Set aDate=..GetMonthStaLastDay(aDate,1)
		Set aDateFrom=$p(aDate,"^",1)
		Set aDateTo=$p(aDate,"^",2)
	}
 	Set total=""
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	Set:aDateType="3" DischDateIndex="PAADM_AdmDate"
	For xDate=aDateFrom:1:aDateTo {
		Set xPaadm=""
		//查找合适的患者
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set EpisodeID	= ##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
			Set MrlistID	= $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:MrlistID=""
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Set InLocOID=MrListObj.QCInLocID
			Continue:MrListObj.QCEntityDr.%Id()'=aEntity
			Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",MrlistID,""),-1)
			Set QCCurrStatusID=MrlistID_"||"_QCCurrStatusSubID
			Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
			Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode
			Continue:QCCurrStateCode'="Up"	//Up
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
			}
			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Set AdmLocDesc=ObjPaadm.PAAdmLocDesc
			Set AdmLocID=ObjPaadm.PAAdmLocID
			Continue:(aLocID'="")&&(aLocID'=AdmLocID)
			Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
	 		Continue:(aHospID'="")&&(aHospID'[xHospID)
			Set total=total+1
			Set VerID=MrListObj.QCEntityDr.BTVersion.%Id()
			Set Sort=""
			For{
				Set Sort  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort))
				Quit:Sort=""
				Set xInfoId=""
				//当前病种的指标数据
				For{
					Set xInfoId  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort,xInfoId))	
					Quit:xInfoId=""
					Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xInfoId)
					Quit:'$IsObject(objInfo)
					Set active=objInfo.active
					Continue:active=0
					Set indexExp=objInfo.indexExp
					Continue:indexExp=""
					Set type=objInfo.type
					Continue:type'=aType
					Set field=objInfo.field
					Set title=objInfo.title
					Set title=$Replace(title,"（","(")
					Set title=$Replace(title,"）",")")
					Set xItemID=""
					Continue:field'["field"
					Set xItemValue="",xCode="",xValue=""
					For{
						Set xItemID = $o(^DHCMA.CPW.SD.IndexInfoD(xInfoId,"LinkItem",xItemID))
						Quit:xItemID=""
						Set xItemId=xInfoId_"||"_xItemID
						Set objItem = ##class(DHCMA.CPW.SD.IndexItem).GetObjById(xItemId)
						Quit:'$IsObject(objItem)
						Set ItemAbbrev=objItem.ItemAbbrev	
						Set ItemId=objItem.ItemId
						Set xItemValue=..GetItemShowValue(MrlistID,ItemId)
						Set:xItemValue="" xCode="",xValue=""
						Set:xItemValue'="" xCode=$p(xItemValue ,$c(1),1)	
						Set:xItemValue'="" xValue=$p(xItemValue ,$c(1),2)
						if (title["天"){
							Set xCode=$p(xCode," ",1)
							Set xCode=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xCode)
						}
						if ((xCode[":")&&(xCode[" ")&&(indexExp["-"))&&((xCode["-")||(xCode["\")){
							/*Set tmpHour=0
							Set tmpDate=$p(xCode," ",1)
							Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
							Set tmpTime=$p(xCode," ",2),tmpTimeLogic=0
							Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
							//将各个时间参数换算为与固定时间小时差
							Set xCode=(tmpDateLogic-60000)*24+(tmpTimeLogic\3600)*/
							
							//将各个时间参数换算为分钟
							Set thisDate=$p(xCode," ",1)
							Set thisTime=$p(xCode," ",2)
							Set thisLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(thisDate)
							Set thisLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(thisTime)
							Set xCode=(thisLogicDate*86400+thisLogicTime)\60
						}
						Set indexExp=$Replace(indexExp,ItemAbbrev,xCode)
					}
					
					if (indexExp["#"){
						if (indexExp["or"){
							Set ^||TMP("QryDataPeo",repid,EpisodeID,field)=""
							Continue:xCode=""
							Set ^||TMP("QryDataPeo",repid,EpisodeID,field)=xCode
						}
						else{
							Set RetRule=$p(indexExp,"#",1)
							Set RetVal=$p(indexExp,"#",2)
							Set xflag=0
							Set:RetRule="" xflag=1
							Set:RetRule'="" Exp="if "_RetRule_"{Set xflag=1}"
							x:RetRule'="" Exp
							if (xflag=1){
								if ((indexExp["-")||(indexExp["+")||(indexExp["*")){
									Set Exp="Set result="_RetVal
									x Exp
									Set ^||TMP("QryDataPeo",repid,EpisodeID,field)=result
								}else{
									Set:xValue="" xValue=xCode
									Set:(xValue[":")&&(xValue[" ") xValue=$p(xValue," ",1)
									Set ^||TMP("QryDataPeo",repid,EpisodeID,field)=xValue	
								}
							}
						}
					}else{
						if ((title["(是/否)")||(title["是否")){
							
							if (indexExp'=""){
								Set flag=0
								Set Exp="if "_indexExp_"{Set flag=1}"
								x Exp
								Set ^||TMP("QryDataPeo",repid,EpisodeID,field)=$Select(flag="1":"是",1:"否")
							}else{
								Set ^||TMP("QryDataPeo",repid,EpisodeID,field)=$Select(xValue="是":"是",1:"否")
							}
						}else{
							b ;12
							Set:xValue="" xValue=xCode
							Set ^||TMP("QryDataPeo",repid,EpisodeID,field)=xValue
						}	
					}
					
				}
			}

		}
	}
	Set xEpisodeID="",ret=""
	For{
		Set xEpisodeID=$o(^||TMP("QryDataPeo",repid,xEpisodeID))
		Quit:xEpisodeID=""
		Set PatientID=$p($g(^PAADM(+xEpisodeID)),"^",1)
		Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
		
		Set EpisodeID	= ##class(DHCMA.Util.EPS.OIDService).GetValidOID(xEpisodeID)
		Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
		Continue:'$IsObject(objPaadm)
		Set MrNo=objPaadm.PAMrNo
		Set DischDate=objPaadm.PADischDate
		Set DischTime=objPaadm.PADischTime
		Set DischDateT=DischDate_" "_DischTime
		Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
		Set MrlistID	= $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
		Continue:MrlistID=""
		Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
		;Continue:MrListObj.QCState="O"		//未来应该是'Up
		
		Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",MrlistID,""),-1)
		Set QCCurrStatusID=MrlistID_"||"_QCCurrStatusSubID
		Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
		Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode
		Continue:QCCurrStateCode'="Up"		//Up
		set StateId=""
		Set UpDateTime=""
		Set obj=##class(DHCMA.Util.BT.Dictionary).GetObjByCode("SDQCMrStatus","Up")	//Up
		Set State=obj.%Id()
		For{
			Quit:StateId'=""
			Set StateId=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexPState",MrlistID,State,StateId),-1)
			Quit:StateId=""
			Set objState=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(MrlistID_"||"_StateId)
			Continue:'$IsObject(objState) 
			set Date=$zd(objState.StateDate,3)
			set Time=$zt(objState.StateTime,1)
			Set UpDateTime=Date_" "_Time
			
		}
		For fieldNum=1:1:99{
			i '$d(^||TMP("QryDataPeo",repid,xEpisodeID,"field"_fieldNum)){
				Set ^||TMP("QryDataPeo",repid,xEpisodeID,"field"_fieldNum)=""
			}	
		}
		
		Set xfield=""
		For{
			Set xfield=$o(^||TMP("QryDataPeo",repid,xEpisodeID,xfield))
			Quit:xfield=""
			if (ret=""){
				Set ret=PatName_"^"_UpDateTime_"^"_DischDateT_"^"_MrNo_"^"_$g(^||TMP("QryDataPeo",repid,xEpisodeID,xfield))
			}else{
				Set ret=ret_"^"_$g(^||TMP("QryDataPeo",repid,xEpisodeID,xfield))
			}
		}
		Set data=$lfs(ret,"^")
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
		Set ret=""
	}
	K ^||TMP("QryDataPeo",repid)
	Quit $$$OK
}

ClassMethod QryQCDataByPeoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCDataByPeoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCDataByPeoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCDataByPeoExecute ]
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

/// Descript:格式化Json数据串
ClassMethod getJsonData(Title As %String, DataList As %String, Deli As %String = "^") As %String
{
	N (Title,DataList,Deli)
	S del=""""
	S jsonStr=""
	S HLen=$L(Title,Deli)  //列
	S DLen=$L(DataList,Deli) //值
	F i=1:1:HLen  d
	.S Name=$p(Title,Deli,i)
	.S Value=$p(DataList,Deli,i)
	.s Value=..GetValue(Value)
	.i i=1 d
	..S jsonStr="{"_del_Name_del_":"_del_Value_del
	.e  d
	..S jsonStr=jsonStr_","_del_Name_del_":"_del_Value_del
	S jsonStr=jsonStr_"}"
	S jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// 　处理影响JSON格式的字符
ClassMethod GetValue(value) As %String
{
	s value=$tr(value,$c(10))   ;替换换行符
	s value=$tr(value,$c(13))	;替换回车符
	s value=$Replace(value,"\","\\")
	//s value=$Replace(value,"'","\'") ;easyui 不需转换单引号，ext需要
	s value=$Replace(value,"""","")
	q value
}

/// 检查当前项目是否为有效表单项目58,4||39
/// w ##class(DHCMA.CPW.SDS.QCIndexInfoSrv).GetItemShowValue("6","11||94")
ClassMethod GetItemShowValue(MrListID As %String, xRowID As %String) As %String
{
	n (MrListID,xRowID)
	Set return=""
	Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,xRowID,""),-1)
	Set EditPower=1 //默认每个项目可编辑
	Quit:ESubID="" return
	Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_ESubID)
	Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
	Set QCID=ObjEntityItem.Parref.%Id()
	Set VerID=ObjEntityItem.BTVersion.%Id()
 	Set BTCode = ObjEntityItem.BTCode
	If $IsObject(ItemExecObj){
 		Set ExecResult=ItemExecObj.ExecResult
 		Set ExecResultText=""
 		//如果存的是字典代码  需要转换为描述
 		for ResultInd=1:1:$l(ExecResult,",") {
	 		Set ExecResultSub=$p(ExecResult,",",ResultInd)
 			Set DicItemObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(QCID,VerID,BTCode,ExecResultSub)
 			Set:$IsObject(DicItemObj) ExecResultText=ExecResultText_","_DicItemObj.BTDesc
 		}
 		Set:ExecResultText'="" ExecResultText=$e(ExecResultText,2,$l(ExecResultText))
 		Set ExecRowID=MrListID_"||"_ESubID
	}
	Set return=ExecResult
	Set:ExecResultText'="" return=ExecResult_$c(1)_ExecResultText
	if (ObjEntityItem.BTLinkedItem'=""){
		Set PValue=""
		Set PItemDr=ObjEntityItem.BTLinkedItem.%Id()
		Set PESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,PItemDr,""),-1)
 		Set PItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_PESubID)
 		Set:$IsObject(PItemExecObj) PValue=PItemExecObj.ExecResult
 		//判断前提条件是否满足a,b,c
 		Set BTTriggerCondition=","_ObjEntityItem.BTTriggerCondition_","
		Set PValue=","_PValue_","
 		Set:(PValue'[BTTriggerCondition)&&(BTTriggerCondition'[PValue) EditPower=0 //有前置质控项目的，如果不满足前提值，则不可编辑
	}elseif (ObjEntityItem.BTTriggerCondition'=""){
		Set BTLinkedParam=ObjEntityItem.BTTriggerCondition
		Set ExcuteExp=BTLinkedParam
		Set EditPower=0 //默认关联项目不显示，满足条件才显示
		for ParamExpInd=1:1:$l(BTLinkedParam,"}") {
			k CodeArr
			Set ParamExpSub=$p(BTLinkedParam,"}",ParamExpInd)
			continue:ParamExpSub=""
			Set:ParamExpSub["{" ParamExpSub=$p(ParamExpSub,"{",2)
			Set ParamExp=$p(ParamExpSub,":",2)
			Set:ParamExp'[")" ExcuteExp=0 //如果有表达式未正常写入code格式，则退出
			Quit:ExcuteExp=0
			for j=1:1:$l(ParamExpSub,")") {
				Set CodeSub=$p(ParamExpSub,")",j)
				Set Code=$p(CodeSub,"(",2)
				continue:Code=""
				Set ItemDr=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,Code)
				if ($IsObject(ItemDr)) {
					Set xSubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,ItemDr.%Id(),""),-1)
					Set xItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_xSubID)
					Set xValue=""
					Set:$IsObject(xItemExecObj) xValue=xItemExecObj.ExecResult
					Set CodeArr(Code)=xValue
				}
			}
			Set CodeTmp=""
			for {
				Set CodeTmp=$o(CodeArr(CodeTmp))
				Quit:CodeTmp=""
				if ($p(ParamExpSub,":",1)="CALC-h") { //计算小时数
				Set tmpHour=0
				Set tmpDate=$p(CodeArr(CodeTmp)," ",1)
				Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
				if (tmpDateLogic=""){
					Set ExcuteExp=0
					Quit  //如果有时间为空 则不执行表达式
				}
				Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
				Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
				//将各个时间参数换算为与固定时间小时差
				Set tmpHour=(tmpDateLogic-60000)*24+(tmpTimeLogic\3600)
				Set ParamExp=$Replace(ParamExp,CodeTmp,tmpHour)
			}elseif ($p(ParamExpSub,":",1)="CALC-m") { //计算分钟数
				Set tmpMin=0
				Set tmpDate=$p(CodeArr(CodeTmp)," ",1)	
				Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
				if (tmpDateLogic=""){
					Set ExcuteExp=0
					Quit  //如果有时间为空 则不执行表达式
				}
				Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
				Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
				//将各个时间参数换算为与固定时间分钟差
				Set tmpMin=(tmpDateLogic-60000)*24*60+(tmpTimeLogic\60)
				Set ParamExp=$Replace(ParamExp,CodeTmp,tmpMin)
			}elseif ($p(ParamExpSub,":",1)="CALC-month") { //计算月数
				Set tmpDate=$p(CodeArr(CodeTmp)," ",1)
				Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
				if (tmpDateLogic=""){
					Set ExcuteExp=0
					Quit  //如果有时间为空 则不执行表达式
				}
				Set tmpDate=$zd(tmpDateLogic,3)
				Set tmpMon=$p(tmpDate,"-",1)*12+$p(tmpDate,"-",2)+$fn(($p(tmpDate,"-",3)/30),"",2)
				Set ParamExp=$Replace(ParamExp,CodeTmp,tmpMon)
			}else{
				//默认情况下替换Code值，进行运算
				Set CodeValue=""""_$g(CodeArr(CodeTmp))_""""
				Set ParamExp=$Replace(ParamExp,CodeTmp,CodeValue)
			}
		}
		Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,ParamExp)
		}
		//小括号被作为标记项目code符号，所以表达式优先级用[] {}来写
		
		Set ExcuteExp=$tr($tr(ExcuteExp,"[","("),"]",")")  //[]相当于小括号
		Set ExcuteExp=$tr($tr(ExcuteExp,"{","("),"}",")")
		Set ExcuteExp=$Replace(ExcuteExp,"不包含","'[")
		Set ExcuteExp=$Replace(ExcuteExp,"包含","[")
		
		Set ExcuteExp=$Replace(ExcuteExp,"!","'")
		if (ExcuteExp["[") {
			Set ExcuteExp=##class(DHCMA.CPW.SDS.QCEntityItemSrv).ChangeExp(ExcuteExp)	
		}
		Set Exp="Set result="_ExcuteExp
		Set Exp="Set result="_ExcuteExp
		x Exp
		Set:result EditPower=1
	}
	Set:EditPower=0 return=""
	Quit return
}

/// 柱状图
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexInfoSrv","QryQCGraphicsData","7","2","1","2019","","","")
Query QryQCGraphicsData(aEntity As %String, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String = "") As %Query(ROWSPEC = "BTDesc:%String,BTVal:%String") [ SqlProc ]
{
}

ClassMethod QryQCGraphicsDataExecute(ByRef qHandle As %Binary, aEntity As %String, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ^zqy215=$lb(aEntity,aHospID,aStaType,ayear,aQuarter,aDateFrom,aDateTo)
 	Set Params=##Class(DHCMA.CPW.SDS.Stat.StatService).GetStatParams(aStaType,ayear,aQuarter,aDateFrom,aDateTo)
 	Set DimenMark	= $p(Params,"^",1)
	Set aDateFrom	= $p(Params,"^",2)
	Set aDateTo		= $p(Params,"^",3)
	Set ArrayStatDimens=##Class(DHCMA.CPW.SDS.Stat.StatService).GetArrayStatDimens(DimenMark,aDateFrom,aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aEntity="") $$$OK

 	Set total="",xflag=""
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)

 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	Set:aDateType="3" DischDateIndex="PAADM_AdmDate"
	For xDate=aDateFrom:1:aDateTo {
		Set xPaadm=""
		//查找合适的患者
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set EpisodeID	= ##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
			Set MrlistID	= $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:MrlistID=""
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Set InLocOID=MrListObj.QCInLocID
			Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",MrlistID,""),-1)
			Set QCCurrStatusID=MrlistID_"||"_QCCurrStatusSubID
			Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
			Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode
			Continue:QCCurrStateCode'="Up"		//Up
			Continue:MrListObj.QCEntityDr.%Id()'=aEntity
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
			}
			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Set AdmLocDesc=ObjPaadm.PAAdmLocDesc
			Set AdmLocID=ObjPaadm.PAAdmLocID
			Continue:(aLocID'="")&&(aLocID'=AdmLocID)
			Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
	 		Continue:(aHospID'="")&&(aHospID'[xHospID)
			
			Set total=total+1
			Set Sort=""
			For{
				Set Sort  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort))
				Quit:Sort=""
				Set xInfoId=""
				//当前病种的指标数据
				For{
					Set xInfoId  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort,xInfoId))	
					Quit:xInfoId=""
					Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xInfoId)
					Quit:'$IsObject(objInfo)
					Set active=objInfo.active
					Continue:active=0
					Set indexExp=objInfo.indexExp
					Continue:indexExp=""
					Set title=objInfo.title
					Continue:title'["占比"
					Set field=objInfo.field
					Set xItemID="",xItemValue="",xCode="",xValue=""
					For{
						Set xItemID = $o(^DHCMA.CPW.SD.IndexInfoD(xInfoId,"LinkItem",xItemID))
						Quit:xItemID=""
						Set xItemId=xInfoId_"||"_xItemID
						Set objItem = ##class(DHCMA.CPW.SD.IndexItem).GetObjById(xItemId)
						Quit:'$IsObject(objItem)
						Set ItemAbbrev=objItem.ItemAbbrev	
						Set ItemId=objItem.ItemId
						Set xItemValue=..GetItemShowValue(MrlistID,ItemId)
						Set:xItemValue="" xCode=""
						Set:xItemValue'="" xCode=$p(xItemValue ,$c(1),1)	
						Set:xItemValue'="" xValue=$p(xItemValue ,$c(1),2)
						Set:((xCode="")&&(indexExp["-")) xCode=0
						//返回值需要转换时间
						Set:title["天" xCode=$p(xCode," ",1)
						if ((xCode["/")||(xCode["-"))&&((xCode[" ")&&(xCode[":")){
							//将各个时间参数换算为分钟
							Set thisDate=$p(xCode," ",1)
							Set thisTime=$p(xCode," ",2)
							Set thisLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(thisDate)
							Set thisLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(thisTime)
							Set xCode=(thisLogicDate*86400+thisLogicTime)\60
						}elseif ((xCode["-")||(xCode["/")){
							Set xCode=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xCode)
						}else{
							Set xCode=xCode
						}
						Set indexExp=$Replace(indexExp,ItemAbbrev,xCode)
					}
					//根据表达式取值
					Set flag=0
					Set Exp="if "_indexExp_"{Set flag=1}"
					x Exp
					if (title["占比"){
						if ('$d(^||TMP("QryQCDataByEntity",repid,"Pre",field))){
							Set ^||TMP("QryQCDataByEntity",repid,"Pre",field)=flag
						}else{
							Set ^||TMP("QryQCDataByEntity",repid,"Pre",field)=^||TMP("QryQCDataByEntity",repid,"Pre",field)+flag
						}
					}

				}
			}
			
		}
	}
	//平均值
	Set xfield=""
	For{
		Set xfield = $o(^||TMP("QryQCDataByEntity",repid,"Pre",xfield))
		Quit:xfield=""
		Set xID=""
		For{
			Set xID=$o(^DHCMA.CPW.SD.IndexInfoI("IdxOfETypeField"," "_aEntity," "_0," "_$zcvt(xfield,"U"),xID))
			Quit:xID=""
			Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xID)
			Quit:'$IsObject(objInfo)
			Set title=objInfo.title
		}
		Set PreVal=$fn($g(^||TMP("QryQCDataByEntity",repid,"Pre",xfield))/total*100,"",2)
		Set data=$lb(title,PreVal)
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	k ^||TMP("QryQCDataByEntity",repid)
	Quit $$$OK
}

ClassMethod QryQCGraphicsDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCGraphicsDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCGraphicsDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCGraphicsDataExecute ]
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

/// 柱状图
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCIndexInfoSrv","QryQCGraphicsLocData","7","2","1","2019","","","","93!!1")
Query QryQCGraphicsLocData(aEntity As %String, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String = "") As %Query(ROWSPEC = "BTLocName:%String,BTDesc:%String,BTVal:%String") [ SqlProc ]
{
}

ClassMethod QryQCGraphicsLocDataExecute(ByRef qHandle As %Binary, aEntity As %String, aHospID As %String, aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String, aDateTo As %String, aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ^zqy2158=$lb(aEntity,aHospID,aStaType,ayear,aQuarter,aDateFrom,aDateTo,aLocID)
 	Set Params=##Class(DHCMA.CPW.SDS.Stat.StatService).GetStatParams(aStaType,ayear,aQuarter,aDateFrom,aDateTo)
 	Set DimenMark	= $p(Params,"^",1)
	Set aDateFrom	= $p(Params,"^",2)
	Set aDateTo		= $p(Params,"^",3)
	Set ArrayStatDimens=##Class(DHCMA.CPW.SDS.Stat.StatService).GetArrayStatDimens(DimenMark,aDateFrom,aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aEntity="") $$$OK

	Set Item="CM-0-1-1-3"
	Set Itemobj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode("2",aEntity,Item)
	Quit:'$IsObject(Itemobj) ""
	Set ItemID=Itemobj.%Id()
 	Set total="",xflag=""
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)

 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	Set:aDateType="3" DischDateIndex="PAADM_AdmDate"
	For xDate=aDateFrom:1:aDateTo {
		Set xPaadm=""
		//查找合适的患者
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set EpisodeID	= ##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
			Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))
			Set MrlistID	= $o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
			Continue:MrlistID=""
			Set MrListObj	=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
			Set InLocOID=MrListObj.QCInLocID
			Set QCCurrStatusSubID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",MrlistID,""),-1)
			Set QCCurrStatusID=MrlistID_"||"_QCCurrStatusSubID
			Set StatusObj=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(QCCurrStatusID)
			Set:$IsObject(StatusObj) QCCurrStateCode=StatusObj.StateCode.BTCode
			Continue:QCCurrStateCode'="Up"		//Up
			Continue:MrListObj.QCEntityDr.%Id()'=aEntity
			Set objInLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocOID)
			Set InLocDesc="",InLocID=""
			If ($IsObject(objInLoc)){
				Set InLocID=+InLocOID
				Set InLocDesc=objInLoc.BTDesc
			}
			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(EpisodeID)
			Set AdmLocDesc=ObjPaadm.PAAdmLocDesc
			Set AdmLocID=ObjPaadm.PAAdmLocID
			Continue:(aLocID'="")&&(aLocID'=AdmLocID)
			Set xHospID=+$p($g(^CTLOC(($p(InLocID,"!!",1)))),"^",22)
	 		Continue:(aHospID'="")&&(aHospID'[xHospID)
			
			
			Set Sort=""
			For{
				Set Sort  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort))
				Quit:Sort=""
				Set xInfoId=""
				//当前病种的指标数据
				For{
					Set xInfoId  = $o(^DHCMA.CPW.SD.IndexInfoI("IdxOfEType"," "_aEntity," 0",Sort,xInfoId))	
					Quit:xInfoId=""
					Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xInfoId)
					Quit:'$IsObject(objInfo)
					Set active=objInfo.active
					Continue:active=0
					Set indexExp=objInfo.indexExp
					Continue:indexExp=""
					Set title=objInfo.title
					Continue:title'["占比"
					Set field=objInfo.field
					Set xItemID="",xItemValue="",xCode="",xValue=""
					For{
						Set xItemID = $o(^DHCMA.CPW.SD.IndexInfoD(xInfoId,"LinkItem",xItemID))
						Quit:xItemID=""
						Set xItemId=xInfoId_"||"_xItemID
						Set objItem = ##class(DHCMA.CPW.SD.IndexItem).GetObjById(xItemId)
						Quit:'$IsObject(objItem)
						Set ItemAbbrev=objItem.ItemAbbrev	
						Set ItemId=objItem.ItemId
						Set xItemValue=..GetItemShowValue(MrlistID,ItemId)
						Set LocName=..GetItemShowValue(MrlistID,ItemID)	//主治医生
						Set:xItemValue="" xCode=""
						Set:xItemValue'="" xCode=$p(xItemValue ,$c(1),1)	
						Set:xItemValue'="" xValue=$p(xItemValue ,$c(1),2)
						Set:((xCode="")&&(indexExp["-")) xCode=0
						//返回值需要转换时间
						Set:title["天" xCode=$p(xCode," ",1)
						if ((xCode["/")||(xCode["-"))&&((xCode[" ")&&(xCode[":")){
							//将各个时间参数换算为分钟
							Set thisDate=$p(xCode," ",1)
							Set thisTime=$p(xCode," ",2)
							Set thisLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(thisDate)
							Set thisLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(thisTime)
							Set xCode=(thisLogicDate*86400+thisLogicTime)\60
						}elseif ((xCode["-")||(xCode["/")){
							Set xCode=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xCode)
						}else{
							Set xCode=xCode
						}
						Set indexExp=$Replace(indexExp,ItemAbbrev,xCode)
					}
					//根据表达式取值
					Set flag=0
					Set Exp="if "_indexExp_"{Set flag=1}"
					x Exp
					Set total=total+flag
					if (title["占比"){
						if ('$d(^||TMP("QryQCDataByEntity",repid,"Pre",LocName,field))){
							Set ^||TMP("QryQCDataByEntity",repid,"Pre",LocName,field)=flag
						}else{
							Set ^||TMP("QryQCDataByEntity",repid,"Pre",LocName,field)=^||TMP("QryQCDataByEntity",repid,"Pre",LocName,field)+flag
						}
					}

				}
			}
			
		}
	}
	//平均值
	Set xLocName=""
	For{
		Set xLocName=$o(^||TMP("QryQCDataByEntity",repid,"Pre",xLocName))
		Quit:xLocName=""
		Set xfield=""
		For{
			Set xfield = $o(^||TMP("QryQCDataByEntity",repid,"Pre",xLocName,xfield))
			Quit:xfield=""
			Set xID=""
			For{
				Set xID=$o(^DHCMA.CPW.SD.IndexInfoI("IdxOfETypeField"," "_aEntity," "_0," "_$zcvt(xfield,"U"),xID))
				Quit:xID=""
				Set objInfo = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(xID)
				Quit:'$IsObject(objInfo)
				Set title=objInfo.title
			}
			Set PreVal=$fn($g(^||TMP("QryQCDataByEntity",repid,"Pre",xLocName,xfield))/total*100,"",2)
			//Set PreVal=$g(^||TMP("QryQCDataByEntity",repid,"Pre",xLocName,xfield))
			//Set PreVal=1000
			Set data=$lb(xLocName,title,PreVal)
			Set ^CacheTemp(repid,ind)=data
			Set ind=ind+1
		}
	}
	

	k ^||TMP("QryQCDataByEntity",repid)
	Quit $$$OK
}

ClassMethod QryQCGraphicsLocDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCGraphicsLocDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCGraphicsLocDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCGraphicsLocDataExecute ]
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
