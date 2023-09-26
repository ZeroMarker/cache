/// 不同版本项目对照服务类
/// add by zhugz 2020-10-15
Class DHCMA.CPW.SDS.QCEntityItemVerSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhugz
/// CreatDate：   2020-10-15
/// Description:  查询对照项目值域差异
/// Table：       DHCMA.CPW.SD.QCEntityItemVer      
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCEntityItemVerSrv","QryVerItemDicDif",7,1)
Query QryVerItemDicDif(aParRef As %String, aVersion As %String) As %Query(ROWSPEC = "BTID:%String,aParRef:%String,ItemCode:%String,ItemDesc:%String,DifMessage:%String")
{
}

ClassMethod QryVerItemDicDifExecute(ByRef qHandle As %Binary, aParRef As %String, aVersion) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	Set ^tmpzgz115=aParRef
 	Quit:(aVersion="")||(aParRef="") $$$OK
	Set xCode=""	
 	For
 	{	
 		Set xCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVersion,xCode))
 		Quit:xCode=""
 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVersion,xCode,aParRef,0))
 		Continue:xSubRowID=""
 		Set xRowID = aParRef_"||"_xSubRowID
 		Set (VerCode,VerDesc,Version,LinkItemCode,LinkItemDesc)=""
 		Set ObjVerItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
 		Set VerCode         = ObjVerItem.BTCode
 		Set VerDesc         = ObjVerItem.BTDesc
 		Set MatchItem       = ObjVerItem.BTMatchItem	
 		Continue:MatchItem=""
		Set ItemCode=MatchItem.BTCode
		Set ItemDesc=MatchItem.BTDesc
		Set ItemID=MatchItem.%Id()
		//比较两个值域类型的值域差异
		Set DifMessage=..CompareItemDif(xRowID,ItemID)
		Continue:DifMessage=""
		Set Data=$lb(xRowID,aParRef,VerCode,VerDesc,DifMessage)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryVerItemDicDifClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVerItemDicDifExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVerItemDicDifFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVerItemDicDifExecute ]
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

/// 对照历史表单项目与质控表单项目
/// w ##class(DHCMA.CPW.SDS.QCEntityItemVerSrv).MatchQCItem(7,"1","","",1)
ClassMethod MatchQCItem(aParRef As %String, aVersion As %String, aItemID As %String = "", aItemVerID As %String = "", aAutoMatch As %String = "") As %String
{
	Set return=0
	Quit:(aAutoMatch="1")&&((aParRef="")||(aVersion="")) return
	Quit:(aAutoMatch="")&&((aItemID="")||(aItemVerID="")) return
	If (aAutoMatch="") {
		Set VerObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemVerID)
		Quit:'$IsObject(VerObj) return
		Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
		Quit:'$IsObject(ItemObj) return
		Set VerObj.BTMatchItem=ItemObj
		Set sc=VerObj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}Else{
			Set return=1
		}
		Quit return
	}else{
		Set EntityObj=##class(DHCMA.CPW.SD.QCEntity).GetObjById(aParRef)
		Set xCode=""	
	 	For
	 	{	
	 		Set xCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVersion,xCode))
	 		Quit:xCode=""
	 		Set xSubRowID="",MatchItemLi=""
	 		For {
		 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVersion,xCode,aParRef,xSubRowID))
	 			Quit:xSubRowID=""
		 		Set xRowID = aParRef_"||"_xSubRowID		
		 		Set (VerCode,VerDesc)=""
		 		Set VerObj = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
		 		Continue:VerObj.BTMatchItem'=""  ;已对照项目不自动对照
		 		Set VerCode         = VerObj.BTCode
		 		Set VerDesc         = VerObj.BTDesc
		 		Set xItemID="",ItemObj=""
		 		For {
					Set xItemID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfPDesc",aParRef,VerDesc,xItemID))
					Quit:xItemID=""
					Set ItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aParRef_"||"_xItemID)
					Continue:'$IsObject(ItemObj)
					//只与当前版本的项目对照
					Continue:ItemObj.BTVersion.%Id()'=EntityObj.BTVersion.%Id()
					
					Set ItemCode=ItemObj.BTCode
					Set MatchItemLi=MatchItemLi_$lb(ItemCode,aParRef_"||"_xItemID)
		 		}
	 		}
	 		Continue:MatchItemLi=""
	 		//如果一个项目与多个项目描述相同，则代码相同的才进行对照
	 		Set MatchItem=""
			If ($ll(MatchItemLi)>2) {
				Set Target=$lf(MatchItemLi,xCode)
				Set:Target>0 MatchItem=$li(MatchItemLi,Target+1)
			}else{
				Set MatchItem=$li(MatchItemLi,2)
			}
			Continue:MatchItem=""
	 		//对照项目值域，如果值域不一致，不进行自动对照。
			Set DifMessage=..CompareItemDif(MatchItem,xRowID)
			Continue:DifMessage'=""
			Set VerObj.BTMatchItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(MatchItem)
			Set sc=VerObj.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
			   		Set return=-1
			}Else{
				Set return=return+1
			}
	 	}	
	}
	//自动同步关联项目的取值参数
	d ..SynExpress(aVersion,aParRef)
	Quit return
}

ClassMethod CancelMatchQCItem(aItemVerID As %String) As %String
{
	Set return=0
	Quit:(aItemVerID="") return
	Set VerObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemVerID)
	Quit:'$IsObject(VerObj) return
	Quit:'$IsObject(VerObj.BTMatchItem) -9_"无对照信息，无法取消"
	Set VerObj.BTMatchItem=""
	Set sc=VerObj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
	Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=1
	}
	Quit return
}

/// 比较两个值域类型的值域差异
/// w ##class(DHCMA.CPW.SDS.QCEntityItemVerSrv).CompareItemDif("7||20","7||154")
ClassMethod CompareItemDif(aItemID, aVerItemID) As %String
{
	new (aItemID,aVerItemID)
	Set return=""
	Quit:(aItemID="")||(aVerItemID="") return
	Set ItemDicTypeID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofItemDR",aItemID,0))
	Set VerDicTypeID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofItemDR",aVerItemID,0))
	Quit:(ItemDicTypeID="")||(VerDicTypeID="") return
	k tmpVerDicArr,tmpItemDicArr
	Set xCode = ""
 	For {
	 	Set xCode= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",VerDicTypeID,xCode))
	 	Quit:xCode=""
	 	Set xSubID = ""
	 	For {
		   	Set xSubID= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",VerDicTypeID,xCode,xSubID))
		   	Quit:xSubID=""
		 	Set BTObj= ##class(DHCMA.CPW.SD.Dictionary).GetObjById(xSubID)
		 	Continue:'$IsObject(BTObj)
		 	Set Code         = BTObj.BTCode
		 	Set Desc         = BTObj.BTDesc
		 	Set tmpVerDicArr(Code)=Desc
	 	}
 	}
	 	Set yCode = ""
	 	For {
		 	Set yCode= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",ItemDicTypeID,yCode))
		 	Quit:yCode=""
		 	Set ySubID = ""
		 	For {
			   	Set ySubID= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",ItemDicTypeID,yCode,ySubID))
			   	Quit:ySubID=""
			 	Set BTObj= ##class(DHCMA.CPW.SD.Dictionary).GetObjById(ySubID)
			 	Continue:'$IsObject(BTObj)
			 	Set Code         = BTObj.BTCode
			 	Set Desc         = BTObj.BTDesc
			 	Set tmpItemDicArr(Code)=Desc
		 	}
	 	}
	 	
	 	Set zCode="",DifMessage="",DifMessage1="",DifMessage2=""
	 	For {
		 	Set zCode=$o(tmpVerDicArr(zCode))
		 	Quit:zCode=""
		 	Set zDesc=$g(tmpVerDicArr(zCode))
		 	If '$d(tmpItemDicArr(zCode)) {
			 	//缺少字典
			 	Set DifMessage1=DifMessage1_","_zCode_" "_zDesc
			 }else{
				Set xItemDesc=$g(tmpItemDicArr(zCode))	
				//代码相同，描述不同
				
				Set:xItemDesc'=zDesc DifMessage2=DifMessage2_","_zCode_" "_zDesc
				k tmpItemDicArr(zCode)
			}	
		}
		//检查表单项目多出的字典
		Set jCode="",DifMessage3=""
		For {
			Set jCode=$o(tmpItemDicArr(jCode))
		 	Quit:jCode=""
		 	Set jDesc=$g(tmpItemDicArr(jCode))	
		 	Set DifMessage3=DifMessage3_","_jCode_" "_jDesc
		}
		Set:DifMessage1'="" DifMessage1=$e(DifMessage1,2,$l(DifMessage1))
		Set:DifMessage2'="" DifMessage2=$e(DifMessage2,2,$l(DifMessage2))
		Set:DifMessage3'="" DifMessage3=$e(DifMessage3,2,$l(DifMessage3))
		Set:DifMessage1'="" DifMessage=DifMessage_"缺少字典项："_DifMessage1_";"
		Set:DifMessage2'="" DifMessage=DifMessage_"同代码不同描述："_DifMessage2_";"
		Set:DifMessage3'="" DifMessage=DifMessage_"多余字典项："_DifMessage3_";"
		Quit DifMessage
}

/// 同步已关联项目的取值表达式
/// w ##class(DHCMA.CPW.SDS.QCEntityItemVerSrv).SynExpress(1)
ClassMethod SynExpress(aVersion As %String, aParRef As %String = "") As %String
{
	New (aParRef,aVersion)
	Set return=""
	Quit:(aVersion="") return
	Set xRowID=0
 	For
 	{
	 	Set xRowID     = $o(^DHCMA.CPW.SD.QCEntityD(xRowID))
	 	Quit:xRowID=""
	 	Continue:(aParRef'="")&&(aParRef'=xRowID)
		Set xCode=""	
	 	For
	 	{	
	 		Set xCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVersion,xCode))
	 		Quit:xCode=""
	 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",aVersion,xCode,xRowID,0))
	 		Continue:xSubRowID=""
	 		Set xItemID = xRowID_"||"_xSubRowID
	 		Set ObjVerItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xItemID)
	 		Set MatchItem       = ObjVerItem.BTMatchItem	
	 		Continue:'$IsObject(MatchItem)
	 		Continue:'$IsObject(ObjVerItem.BTExpressDr) //过滤没有取值参数的项目
	 		Set MatchItem.BTExpressDr=ObjVerItem.BTExpressDr
	 		Set MatchItem.GetDataParam=ObjVerItem.GetDataParam
	 		Set sc=MatchItem.%Save()
	 		If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
			   		Set return=-1
				}Else{
					Set return=return+1
				}
	 	}
 	}
 	Quit return
}

}
