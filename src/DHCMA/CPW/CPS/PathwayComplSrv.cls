/// 名称: DHCMA.CPW.CPS.PathwayComplSrv
/// 描述: 合并症路径服务类
/// 编写者：yankai
/// 编写日期: 2021-05-26
Class DHCMA.CPW.CPS.PathwayComplSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2021-05-27
/// Description:  查询所有合并症路径及当前路径关联信息
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PathwayComplSrv","QryComplPathMast","14","","2!!1","I")
Query QryComplPathMast(aPathwayID As %String, aKeyWord As %String = "", aHospID As %String = "", aAdmType As %String = "I") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String,BTIsActive:%Boolean,BTActDate:%Date,BTActTime:%Time,BTActUserID:%String,BTAdmType:%String,BTAdmTypeDesc:%String,PathComplID:%String,PathComplDesc:%String,isChked:%Integer,ComplFormID:%String,PwComplID:%String,ComplFormVer:%String,RefDate:%String,RefTime:%String,ActUserName:%String")
{
}

ClassMethod QryComplPathMastExecute(ByRef qHandle As %Binary, aPathwayID As %String, aKeyWord As %String = "", aHospID As %String = "", aAdmType As %String = "I") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(aPathwayID)
	Quit:'$IsObject(objPathway) return
	Set EpisodeID=objPathway.CPEpisodeID
	Set aPathMast=""
	If ($IsObject(objPathway.CPFormDr))&&($IsObject(objPathway.CPFormDr.FormPathDr)){
		Set aPathMast=objPathway.CPFormDr.FormPathDr.%Id()	
	}
	Set IsMatchDiag=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsCheckDiagWithCompl",aHospID)			//合并症诊断符合性检查配置
	
 	Set xID=""
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	For {
	 	Set xID = $o(^DHCMA.CPW.BT.PathMastD(xID))
	 	Quit:xID=""

	 	Set obj = ##class(DHCMA.CPW.BT.PathMast).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.BTIsAsCompl'=1
		Continue:(aPathMast'="")&&(aPathMast=xID)
		If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA.CPW.BT.PathCompl",xID,aHospID)
		 	Continue:retFlg'="Y"
		}else{
			Continue:(aHospID'="")&&('$d(^DHCMA.CPW.BT.PathMastI("HOSP","IdxofHosp",xID,aHospID)))
		}
	 	If IsMatchDiag="Y"{
			Set DiagInfo=##class(DHCMA.CPW.BTS.PathLocSrv).GetDiagsInfo(EpisodeID)
			Set retMatch=##class(DHCMA.CPW.BTS.PathLocSrv).CheckIsMatched(xID,DiagInfo,aHospID,2)
			Continue:retMatch'=1	
		}
	 	
	 	Set Code = obj.BTCode
	 	Set Desc = obj.BTDesc
	 	Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",Desc,LangID)
	 	Continue:(aKeyWord'="")&&(Desc'[aKeyWord)
	 	
	 	Set TypeID="",TypeDr=""
	 	If $IsObject(obj.BTTypeDr) {
			Set TypeID  =obj.BTTypeDr.%Id()
	 		Set TypeDesc=obj.BTTypeDr.BTDesc
	 		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathType","BTDesc",TypeDesc,LangID)
		}
		
	 	Set IsActiveDesc = $s(obj.BTIsActive=1:"是",1:"否")
	 	Set:IsActiveDesc'="" IsActiveDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.cp.pathcompl.csp",IsActiveDesc,LangID)	
	 	Set ActDate         = $ZD(obj.BTActDate,3)
	 	Set ActTime        	= $Zt(obj.BTActTime)
	 	Set ActUserID       = obj.BTActUserID      
	 	Set AdmType 		= obj.BTAdmType
	 	Set AdmTypeDesc		= $s(AdmType="I":"住院",AdmType="O":"门诊",1:"")
	 	Set:AdmTypeDesc'="" AdmTypeDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.cp.pathcompl.csp",AdmTypeDesc,LangID)	
	 	Continue:(aAdmType'="")&&(aAdmType'[AdmType)
	 	
	 	Set PathComplID="",PathComplDesc=""
	 	Set:$IsObject(obj.BTPathComplDr) PathComplID=obj.BTPathComplDr.%Id()
		Set:$IsObject(obj.BTPathComplDr) PathComplDesc=obj.BTPathComplDr.BTDesc
		Set:PathComplDesc'="" PathComplDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathCompl","BTDesc",PathComplDesc,LangID)
	 	
	 	Set isChked=0,ComplFormID="",PwComplID="",ComplFormVer="",RefDate="",RefTime="",ActUserName=""
	 	Set retFlg=..IsExistByMastID(aPathwayID,xID)
	 	If $p(retFlg,"^",1)=1{							//已关联合并症的，返回关联表单ID
		 	Set isChked=1
			Set ComplFormID=$p(retFlg,"^",2)
			Set PwComplID=$p(retFlg,"^",3)
			Set ComplFormVer=$p(retFlg,"^",4)
			Set RefDate=$p(retFlg,"^",5)
			Set RefTime=$p(retFlg,"^",6)
			Set ActUserName=$p(retFlg,"^",7)
		}Else{											//未关联的返回最新可用表单ID
			Set FormStr=##class(DHCMA.CPW.BTS.PathFormSrv).GetFormByMast(xID,1)	//FormID_"^"_Version
			Continue:FormStr=""
			
			Set ComplFormID=$p(FormStr,"^",1)
			Set ComplFormVer=$p(FormStr,"^",2)
		}
	 	
		Set Data=$lb(xID,Code,Desc,TypeID,TypeDesc,IsActiveDesc,ActDate,ActTime,ActUserID,AdmType,AdmTypeDesc,PathComplID,PathComplDesc,isChked,ComplFormID,PwComplID,ComplFormVer,RefDate,RefTime,ActUserName)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryComplPathMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryComplPathMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryComplPathMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryComplPathMastExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     yankai
/// CreatDate：   2021-05-28
/// Description:  根据出入径记录和路径ID获取是否已关联该合并症路径，返回状态及已关联表单ID
/// Table：       DHCMA.CPW.CP.PathwayCompl
/// Input：       aPathwayID：出入径记录；aMastID：路径ID
/// output: 	  状态[1/0]^关联表单FormID^关联ComplID^版本信息
/// w ##class(DHCMA.CPW.CPS.PathwayComplSrv).IsExistByMastID(14,27)
ClassMethod IsExistByMastID(aPathwayID As %String, aMastID As %String) As %String
{
	New (aPathwayID,aMastID)
	Set return=""
	Quit:(aPathwayID="")||(aMastID="") return
	
	Set xFormID=""
	For {
		Set xFormID=$o(^DHCMA.CPW.CP.PathwayI("COMPL","IdxofParrefCForm",aPathwayID,xFormID))
		Quit:xFormID=""
		Quit:return'=""
		
		Set objCPCompl=##class(DHCMA.CPW.CP.PathwayCompl).GetObjByParAndForm(aPathwayID,xFormID)
		Continue:'$IsObject(objCPCompl)
		Continue:'objCPCompl.CPIsActive
		Continue:'$IsObject(objCPCompl.CPComplFormDr.FormPathDr)
		Continue:objCPCompl.CPComplFormDr.FormPathDr.%Id()'=aMastID
		Set ComplRefDate=objCPCompl.CPActDate
		Set:ComplRefDate'="" ComplRefDate=##class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ComplRefDate)
		Set ComplRefTime=objCPCompl.CPActTime
		Set:ComplRefTime'="" ComplRefTime=$zt(ComplRefTime,1)
		Set ActUserID=objCPCompl.CPActUserID
		Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		Set:$IsObject(objActUser) ActUserName=objActUser.BTDesc
		
		Set ComplFormVerNo=objCPCompl.CPComplFormDr.FormVersion
		Set:ComplFormVerNo'="" ComplFormVerNo="V"_$fn(ComplFormVerNo,"",1)
		Set return=1_"^"_xFormID_"^"_objCPCompl.%Id()_"^"_ComplFormVerNo_"^"_ComplRefDate_"^"_ComplRefTime_"^"_ActUserName
	}
	Set:return="" return=0
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2021-06-09
/// Description:  合并症路径重点医嘱项目
/// Table：       DHCMA.CPW.BT.PathMast、DHCMA.CPW.CP.PathwayCompl、DHCMA.CPW.BT.PathFormItem
/// Input：       aPathwayID,aEpisID
/// Return：      
/// w ##class(DHCMA.CPW.CPS.PathwayComplSrv).GetComplItemTree(6,"6||1","D")
ClassMethod GetComplItemTree(aPathwayID As %String, aEpisID As %String, aUserType As %String = "") As %String
{
	New (aPathwayID,aEpisID,aUserType,%session)
	Set return="[]"
	Quit:(aPathwayID="")||(aEpisID="") return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aEpisID)
	Quit:'$IsObject(objEpis) return
	Set FormEpID=objEpis.CPFormEpDr.%Id()

	Set treeJson="["
	Set xSubComplID=""
	For {
		Set xSubComplID=$o(^DHCMA.CPW.CP.PathwayD(aPathwayID,"COMPL",xSubComplID))
		Quit:xSubComplID=""
		
		Set xCPComplID=aPathwayID_"||"_xSubComplID
		Set objCPCompl=##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(xCPComplID)
		Continue:'$IsObject(objCPCompl)
		Continue:'objCPCompl.CPIsActive
		Continue:'$IsObject(objCPCompl.CPComplFormDr)
		Set ComplFormID=objCPCompl.CPComplFormDr.%Id()
		Continue:'$IsObject(objCPCompl.CPComplFormDr.FormPathDr)
		Set ComplMastDesc=objCPCompl.CPComplFormDr.FormPathDr.BTDesc
		Set:ComplMastDesc'="" ComplMastDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathMast","BTDesc",ComplMastDesc,LangID)
		
		Set ComplVer=objCPCompl.CPComplFormDr.FormVersion
		Set:ComplVer'="" ComplMastDesc=ComplMastDesc_"(V"_$fn(ComplVer,"",1)_")"

		Set treeJson=treeJson_"{"
		Set treeJson=treeJson_"""id"":""ComplForm-"_xCPComplID_"-"_ComplFormID_""","
		Set treeJson=treeJson_"""text"":"""_ComplMastDesc_""","
		Set treeJson=treeJson_"""state"":""closed"","
		Set treeJson=treeJson_"""children"":["
		Set ChildJson=""
			
		Set xEpIndNo=""
		For {
			Set xEpIndNo=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",ComplFormID,xEpIndNo))
			Quit:xEpIndNo=""
			
			Set xSubEpID=""
			For {
				Set xSubEpID=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",ComplFormID,xEpIndNo,xSubEpID))
				Quit:xSubEpID=""
				
				Set xBTEpID=ComplFormID_"||"_xSubEpID
				Set objBTEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(xBTEpID)
				Continue:'$IsObject(objBTEp)
				Continue:objBTEp.EpIsActive=0
				Set xBTEpDesc=objBTEp.EpDesc
				
				Set ChildJson=ChildJson_"{"
	 			Set ChildJson=ChildJson_"""id"":""ComplEp-"_xBTEpID_""","
	 			Set ChildJson=ChildJson_"""text"":"""_xBTEpDesc_""","
				Set ChildJson=ChildJson_"""state"":""closed"","
	 			Set ChildJson=ChildJson_"""children"":["
				Set SubChildJson=""
				
				Set xSubItemID=""
				For {
					Set xSubItemID=$o(^DHCMA.CPW.BT.PathFormD(ComplFormID,"EP",xSubEpID,"ITM",xSubItemID))
					Quit:xSubItemID=""
					
					Set BTItemID=ComplFormID_"||"_xSubEpID_"||"_xSubItemID
					Set objItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(BTItemID)
					Continue:'$IsObject(objItem)
					Continue:'objItem.ItemIsActive
					
					Set ItemPower=""
					Set objItemCat=objItem.ItemCatDr
					Continue:'$IsObject(objItemCat)
					Continue:'$IsObject(objItemCat.BTTypeDr)
					Continue:objItemCat.BTTypeDr.BTDesc'["重点医嘱"
					Set:$IsObject(objItemCat.BTPowerDr) ItemPower=objItemCat.BTPowerDr.BTCode
					Continue:(aUserType="D")&&((ItemPower'="D")&&(ItemPower'="OE")) 			//医生返回诊疗、医嘱
					Continue:(aUserType="N")&&((ItemPower'="N")&&(ItemPower'="NE")) 			//护士返回护理、护嘱
					
					Set ItemDesc=objItem.ItemDesc
					Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
 					Set ItemDesc=##class(DHCMA.Util.IO.FromHisSrv).ReplaceSpecialChar(ItemDesc)
 		
 					Set IndexNo=objItem.ItemIndNo
 					Set IsRequired=+'objItem.ItemIsOption	//两变量值相反

 					Set ExeInfo=..IsExeComplItem(aEpisID,BTItemID)
 					Set IsImp=$p(ExeInfo,"^",1)
 					Set CPImplID=$p(ExeInfo,"^",2)
					Set IsSystem=$p(ExeInfo,"^",3)
					
					Set SubChildJson=SubChildJson_"{"
 					Set SubChildJson=SubChildJson_"""id"":""ComplItem-"_BTItemID_"-"_CPImplID_""","
 					Set SubChildJson=SubChildJson_"""text"":"""_ItemDesc_""","
					Set SubChildJson=SubChildJson_"""attributes"":{""IsImp"":"_IsImp_",""IsRequired"":"_IsRequired_"}"
 					Set SubChildJson=SubChildJson_"},"	
				}
				Set:SubChildJson'="" SubChildJson=$e(SubChildJson,1,$l(SubChildJson)-1)	//去掉最后一个逗号
				Set ChildJson=ChildJson_SubChildJson_"]},"  	
			}
		}
		Set:ChildJson'="" ChildJson=$e(ChildJson,1,$l(ChildJson)-1)	//去掉最后一个逗号
		Set treeJson=treeJson_ChildJson_"]},"	
	}
	Set:treeJson'="[" treeJson=$e(treeJson,1,$l(treeJson)-1)	//去掉最后一个逗号
	Set treeJson=treeJson_"]"
	
 	Set return=treeJson
 	Quit return
}

/// Creator：     yankai
/// CreatDate：   2021-06-10
/// Description:  检查合并症项目是否在阶段下被执行（是则存在被执行记录）
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       aCPEpisID：路径阶段ID,aBTItemID:维护项目ID
/// output: 	  1^CPImplID：是^执行记录ID；0：否
/// w ##class(DHCMA.CPW.CPS.PathwayComplSrv).IsExeComplItem(14,27)
ClassMethod IsExeComplItem(aCPEpisID As %String, aBTItemID As %String) As %String
{
	New (aCPEpisID,aBTItemID)
	Set return=0
	Quit:($l(aCPEpisID,"||")'=2)||(aBTItemID="") return
	
	Set PathwayID=$p(aCPEpisID,"||",1)
	Set xCPItemID=""
	For {
		Set xCPItemID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,aCPEpisID,xCPItemID))
		Quit:xCPItemID=""
		Quit:return'=0
		
		Set objCPImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xCPItemID)
		Continue:'$IsObject(objCPImpl)
		Continue:'objCPImpl.CPIsActive
		Continue:'$IsObject(objCPImpl.CPFormItemDr)
		Continue:objCPImpl.CPPathwayComplDr=""
		Continue:objCPImpl.CPFormItemDr.%Id()'=aBTItemID
		Continue:'objCPImpl.CPIsImp
		
		Set IsSysExe=objCPImpl.CPIsSystem
		Set return=1_"^"_PathwayID_"||"_xCPItemID_"^"_IsSysExe
	} 
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2023-04-23
/// Description:  查询合并症内关联医嘱
/// Table：       DHCMA.CPW.BT.PathFormOrd
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PathwayComplSrv","QryComplFormOrdAll","27","","","2","","","D","91!!1","113!!1")
Query QryComplFormOrdAll(aFormID As %String, aFormEpID As %String, aFormItemID As %String, aHospID As %String = "", aOrdDesc As %String = "", aOrdGroupID As %String = "", aUserType As %String = "", aEpisodeID As %String = "", aLgnLocID As %String = "") As %Query(ROWSPEC = "xID:%String,ID:%String,OrdTypeDr:%String,OrdTypeDrDesc:%String,OrdMastID:%String,OrdMastIDDesc:%String,OrdGeneID:%String,OrdGeneIDDesc:%String,OrdPriorityID:%String,OrdPriorityIDDesc:%String,OrdQty:%String,OrdFreqID:%String,OrdFreqIDDesc:%String,OrdDuratID:%String,OrdDuratIDDesc:%String,OrdInstrucID:%String,OrdInstrucIDDesc:%String,OrdDoseQty:%String,OrdUOMID:%String,OrdUOMIDDesc:%String,OrdNote:%String,OrdChkPosID:%String,OrdLnkOrdDr:%String,OrdIsDefault:%String,OrdIsFluInfu:%String,OrdCatCode:%String,ItemID:%String,ItemDesc:%String,OrdGroupID:%String,SeqCode:%String,OrdQtyUomDesc:%String,OrdIncilQty:%String,IsSensitive:%String,IsDefSensitive:%String,OrdBuzTypeCode:%String,OrdBuzTypeDesc:%String")
{
}

ClassMethod QryComplFormOrdAllExecute(ByRef qHandle As %Binary, aFormID As %String, aFormEpID As %String, aFormItemID As %String, aHospID As %String = "", aOrdDesc As %String = "", aOrdGroupID As %String = "", aUserType As %String = "", aEpisodeID As %String = "", aLgnLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	//Set ^TEMPYK("QryComplFormOrdAll")=$LB(aFormID,aFormEpID,aFormItemID,aHospID,aOrdDesc,aOrdGroupID,aUserType,aEpisodeID,aLgnLocID)
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	Quit:aFormID="" $$$OK
	
	Set IsFltRepOrd=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWFilterComplRepOrd",aHospID)
	Set xEpIndNo="",ListOrds=""
	For {
		Set xEpIndNo=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aFormID,xEpIndNo))
		Quit:xEpIndNo=""
		
		Set xSubFormEpID=""
		For {
			Set xSubFormEpID=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aFormID,xEpIndNo,xSubFormEpID))
			Quit:xSubFormEpID=""
			
			Set xFormEpID=aFormID_"||"_xSubFormEpID
			Continue:(aFormEpID'="")&&(aFormEpID'=xFormEpID)
			Set objBTEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(xFormEpID)
			Continue:'$IsObject(objBTEp)
			Continue:objBTEp.EpIsActive=0
			
			Set xSubFormItemID=""
			For {
				Set xSubFormItemID=$o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xSubFormEpID,"ITM",xSubFormItemID))
				Quit:xSubFormItemID=""
				Set xFormItemID=aFormID_"||"_xSubFormEpID_"||"_xSubFormItemID
				Continue:(aFormItemID'="")&&(aFormItemID'=xFormItemID)
				
				Set objItm = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(xFormItemID)
				Continue:'$IsObject(objItm)
				
			 	Set ItemDesc = objItm.ItemDesc
			 	Set:ItemDesc'="" ItemDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ItemDesc,LangID)
				
				Set ItemPower=""
				Set objItemCat=objItm.ItemCatDr
				Continue:'$IsObject(objItemCat)
				Set:$IsObject(objItemCat.BTPowerDr) ItemPower=objItemCat.BTPowerDr.BTCode
				Continue:(aUserType="D")&&((ItemPower'="D")&&(ItemPower'="OE")) 			//医生返回诊疗、医嘱
				Continue:(aUserType="N")&&((ItemPower'="N")&&(ItemPower'="NE")) 			//护士返回护理、护嘱
				
			 	Set xSubFormOrdID=""
			 	For {
				 	Set xSubFormOrdID = $o(^DHCMA.CPW.BT.PathFormD(aFormID,"EP",xSubFormEpID,"ITM",xSubFormItemID,"ORD",xSubFormOrdID))
				 	Quit:xSubFormOrdID=""
				 	
				 	Set xFormOrdID=aFormID_"||"_xSubFormEpID_"||"_xSubFormItemID_"||"_xSubFormOrdID
					Set obj = ##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(xFormOrdID)
					Continue:'$IsObject(obj)
				 	Continue:obj.OrdIsActive=0
				 	Continue:'$Isobject(obj.OrdTypeDr)
				 	Set OrdTypeDr = obj.OrdTypeDr.%Id()
				 	Set OrdTypeDrDesc = obj.OrdTypeDr.BTDesc
				 	Set:OrdTypeDrDesc'="" OrdTypeDrDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",OrdTypeDrDesc,LangID)
				 	Set OrdMastID =obj.OrdMastID
				 	Continue:OrdMastID=""
				 	Continue:(IsFltRepOrd=1)&&($lf(ListOrds,OrdMastID)>0)
				 	Set ListOrds=ListOrds_$lb(OrdMastID)
				 	
				 	//频次 指向PHC_Freq  疗程 指向PHC_Duration 用法 指向PHCInstruc  单位 指向CTUOM
					Set (OrdGeneID,OrdGeneIDDesc,OrdCatCode,OrdCatVal)=""
					Set (OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdQtyUomDesc,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc)=""
				 	Set (OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdIsActive)=""
				 	Set (IsSensitive,IsDefSensitive,OrdBuzTypeCode,OrdBuzTypeDesc)=""		// 是否加急、是否默认加急、医嘱分类
				 	
				 	//调用医生站接口区分草药类医嘱与非草药类医嘱 
				 	Set:(aHospID="")&&($d(%session)) aHospID=%session.Get("LOGON.HOSPID")
				 	Set OrdCatVal=##class(DHCMA.CPW.IO.FromDoc).IsCPWCNMedItem(OrdMastID,aHospID)
				 	Set OrdCatCode=$s(OrdCatVal=0:"W",1:"C")
				 	
				 	//取医嘱信息、通用名
				 	Set OrdInfo = ##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById(OrdMastID)
				 	Set OrdMastIDDesc = $p(OrdInfo,"^",20)  //医嘱名
				 	Continue:(aOrdDesc'="")&&(OrdMastIDDesc'[aOrdDesc)
				 	
				 	Set OrdGeneID = $p(OrdInfo,"^",15)
				 	Set OrdGeneIDDesc = $p(OrdInfo,"^",16)  //通用名
				 	Set OrdPriorityID = obj.OrdPriorityID
				 	Set OrdPriorityIDDesc=$p($g(^OECPR(OrdPriorityID)),"^",2)
				 	Set:OrdPriorityIDDesc'="" OrdPriorityIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.OECPriority","OECPRDesc",OrdPriorityIDDesc,Languages)
				 	Set OrdQty = obj.OrdQty
				 	Set OrdQtyUomDesc = $p(OrdInfo,"^",19)
				 	Set OrdFreqID = obj.OrdFreqID
				 	Set:OrdFreqID'="" OrdFreqIDDesc=$p($g(^PHCFR(OrdFreqID)),"^",3)
				 	Set:OrdFreqIDDesc'="" OrdFreqIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCFreq","PHCFRDesc2",OrdFreqIDDesc,Languages)
				 	Set OrdDuratID = obj.OrdDuratID 
				 	Set:OrdDuratID'="" OrdDuratIDDesc=$p($g(^PHCDU(OrdDuratID)),"^",3)
				 	Set:OrdDuratIDDesc'="" OrdDuratIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCDuration","PHCDUDesc1",OrdDuratIDDesc,Languages)
				 	Set OrdInstrucID = obj.OrdInstrucID
				 	Set:OrdInstrucID'="" OrdInstrucIDDesc=$p($g(^PHCIN(OrdInstrucID)),"^",2)
				 	Set:OrdInstrucIDDesc'="" OrdInstrucIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCInstruc","PHCINDesc1",OrdInstrucIDDesc,Languages)
				 	Set OrdDoseQty = obj.OrdDoseQty
				 	If (OrdDoseQty'="")&(OrdDoseQty<1)&(OrdDoseQty'=0){
						Set OrdDoseQty="0"_OrdDoseQty
					} 
				 	Set OrdUOMID = obj.OrdUOMID
				 	Set:OrdUOMID'="" OrdUOMIDDesc=$p($g(^CT("UOM",OrdUOMID)),"^",2)
				 	Set:OrdUOMIDDesc'="" OrdUOMIDDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTUOM","CTUOMDesc",OrdUOMIDDesc,Languages)
				 	Set OrdNote = obj.OrdNote
				 	Set OrdChkPosID = obj.OrdChkPosID
					Set:OrdChkPosID'="" OrdChkPosID=##class(DHCMA.CPW.BTS.PathFormEpSrv).GetTransOfChkPost(OrdChkPosID)		// 检查部位的翻译
				 	Set OrdLnkOrdDr =obj.OrdLnkOrdDr
				 	Set OrdIsDefault =obj.OrdIsDefault
				 	Set OrdIsFluInfu =obj.OrdIsFluInfu
				 	Set OrdGroupID = obj.OrdGroupID
				 	Continue:(aOrdGroupID'="")&&($lf($lfs(OrdGroupID,","),aOrdGroupID)<=0)
				 	Set SeqCode = obj.SeqCode
				 	
				 	//取医嘱项药品库存数量
				 	Set OrdIncilQty=""
				 	If OrdMastID["||"{
						Set RecLocStr=##class(DHCMA.CPW.IO.FromDoc).GetRecLocByDoc(aEpisodeID,aLgnLocID,OrdMastID)		//接收科室
						Set IncilInfo=##Class(DHCMA.CPW.IO.FromDoc).GetIncilQtyListByPHA(OrdMastID,$p(RecLocStr,$c(1),1),"I")
						Set IncilInfo=$p(IncilInfo,$c(2),1)		//取第一条库存信息
						If IncilInfo'=""{
							Set IncilQty=$p(IncilInfo,"^",9),IncilUomDesc=$p(IncilInfo,"^",6)
							Set:IncilUomDesc'="" IncilUomDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTUOM","CTUOMDesc",IncilUomDesc,Languages)
							Set:IncilInfo'="" OrdIncilQty=IncilQty_"("_IncilUomDesc_")"
						}
						Set IsSensitive=$p($g(^ARCIM(+OrdMastID,$p(OrdMastID,"||",2),9)),"^",18)			// 是否加急医嘱
						Set IsDefSensitive=$p($g(^ARCIM(+OrdMastID,$p(OrdMastID,"||",2),9)),"^",41)			// 是否默认加急医嘱
						Set OrdBuzTypeCode=##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderType(OrdMastID)
						Set OrdBuzTypeDesc=$case(OrdBuzTypeCode,"R":"药品","N":"诊疗","L":"检验","P":"自定价医嘱","M":"材料","X":"检查",1:"")
					}Else{
						Set OrdBuzTypeCode="YZT"
						Set OrdBuzTypeDesc="医嘱套"
					}
				 	 	
				 	Set Data=$lb(xFormOrdID,xSubFormOrdID,OrdTypeDr,OrdTypeDrDesc,OrdMastID,OrdMastIDDesc,OrdGeneID,OrdGeneIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc,OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdCatCode,xFormItemID,ItemDesc,OrdGroupID,SeqCode,OrdQtyUomDesc,OrdIncilQty,IsSensitive,IsDefSensitive,OrdBuzTypeCode,OrdBuzTypeDesc)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1	
			 	}	
			 	if ($d(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",aFormID,xSubFormEpID,xSubFormItemID))) {
				 	Set TCMID=""
				 	For {
					 	Set TCMID=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",aFormID,xSubFormEpID,xSubFormItemID,TCMID))
					 	Quit:TCMID=""
					 	
					 	Set (TCMDesc,OrdGeneID,OrdGeneIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdQtyUomDesc,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc,OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdCatCode,SeqCode,OrdIncilQty,IsSensitive,IsDefSensitive,OrdBuzTypeCode,OrdBuzTypeDesc)=""
					 	Set ObjTCM=##class(DHCMA.CPW.BT.PathTCM).GetObjById(TCMID)
					 	Continue:'$IsObject(ObjTCM)
					 	Set TCMDesc=ObjTCM.BTDesc
					 	Set:TCMDesc'="" TCMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathTCM","BTDesc",TCMDesc,LangID)
					 	
					 	Continue:(aOrdDesc'="")&&(TCMDesc'[aOrdDesc)
					 	Set FormTCMID=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",aFormID,xSubFormEpID,xSubFormItemID,TCMID,""))
					 	Set RowID="FJ:"_TCMID_":"_aFormEpID_"||"_xSubFormItemID_"||"_FormTCMID
					 	Set OrdCatCode="C" //走中草药录入
					 	Set OrdIsDefault="1",OrdIsFluInfu="1",OrdTypeDrDesc="自定义方剂"
					 	Set:OrdTypeDrDesc'="" OrdTypeDrDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",OrdTypeDrDesc,LangID)
					 	
					 	Set objFormTCM = ##class(DHCMA.CPW.BT.PathFormTCM).GetObjById(xFormItemID_"||"_FormTCMID)
					 	Set OrdGroupID = objFormTCM.TCMGroupID
					 	Continue:(aOrdGroupID'="")&&($lf($lfs(OrdGroupID,","),aOrdGroupID)<=0)
					 	Set OrdBuzTypeCode="ZDYFJ",OrdBuzTypeDesc=OrdTypeDrDesc
					 	
					 	Set Data=$lb(RowID,"","",OrdTypeDrDesc,RowID,TCMDesc,OrdGeneID,OrdGeneIDDesc,OrdPriorityID,OrdPriorityIDDesc,OrdQty,OrdFreqID,OrdFreqIDDesc,OrdDuratID,OrdDuratIDDesc,OrdInstrucID,OrdInstrucIDDesc,OrdDoseQty,OrdUOMID,OrdUOMIDDesc,OrdNote,OrdChkPosID,OrdLnkOrdDr,OrdIsDefault,OrdIsFluInfu,OrdCatCode,xFormItemID,ItemDesc,OrdGroupID,SeqCode,OrdQtyUomDesc,OrdIncilQty,IsSensitive,IsDefSensitive,OrdBuzTypeCode,OrdBuzTypeDesc)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					 }
				}		
			}
		}
	}

	Quit $$$OK
}

ClassMethod QryComplFormOrdAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryComplFormOrdAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryComplFormOrdAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryComplFormOrdAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
