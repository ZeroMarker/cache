/// 名称: DHCMA.CPW.OPCPS.PathwayVarSrv
/// 描述: 门诊临床路径变异服务类
/// 编写者：yankai
/// 编写日期: 2019-09-09
Class DHCMA.CPW.OPCPS.PathwayVarSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2019-09-09
/// Description:  门诊路径自动保存必选未执行项目变异
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       aVisitID
/// Return：      %String
/// w ##class(DHCMA.CPW.OPCPS.PathwayVarSrv).SaveNoExeItemVar()	
ClassMethod SaveNoExeItemVar(aVisitID As %String) As %String
{
	New (aVisitID)
	Set return=""
	Quit:aVisitID="" return
	
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID("","",aVisitID)
	Set VarRsnDicIDStr=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPVarRsnIDs",AdmHospID)	
	Set VarRsnID=$p(VarRsnDicIDStr,",",1)  									//必选项目未执行变异原因ID
	
	Set objVarRsn=##class(DHCMA.CPW.BT.PathVariat).GetObjById(VarRsnID)
	Quit:'$IsObject(objVarRsn) return
	Set VarRsnTxt=objVarRsn.BTDesc
	
	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(aVisitID)
	Quit:'$IsObject(objVisit) return
	Quit:'$IsObject(objVisit.CPPathwayDr) return
	Quit:'$IsObject(objVisit.CPEpisDr) return
	Set PathwayID=objVisit.CPPathwayDr.%Id()
	Set EpisID=objVisit.CPEpisDr.%Id()
	
	Set $ZT="AutoSaveNoExeItemVarError"
	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,EpisID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		
 		Set IsActive=objImpl.CPIsActive
 		Continue:'IsActive
 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
 		Continue:'IsRequired	//是否可选
 		Set IsImp=objImpl.CPIsImp
 		Continue:IsImp
 		
 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc
 		Set IndexNo=objImpl.CPFormItemDr.ItemIndNo
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		
 		Set (VariatTxt,VariatCat)=""
 		Set xVarID=""
 		For {
			Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",PathwayID,EpisID,PathwayID_"||"_xImplID,xVarID))
			Quit:xVarID=""
			
	 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
	 		If ($IsObject(objVar)) {
		 		Continue:'objVar.CPIsActive
		 		
	 			Set VariatTxt=objVar.CPVariatTxt
	 			Set VariatCat=objVar.CPVariatDr.BTDesc
	 		}
			Quit
		}
		
		Set InputStr=PathwayID
		Set InputStr=InputStr_"^"_xVarID
		Set InputStr=InputStr_"^"_VarRsnID
		Set InputStr=InputStr_"^"_VarRsnTxt
		Set InputStr=InputStr_"^"_EpisID
		Set InputStr=InputStr_"^"_PathwayID_"||"_xImplID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		 
		Do ##class(DHCMA.CPW.CP.PathwayVar).Update(InputStr)
	}
	Quit 1
	
AutoSaveNoExeItemVarError
	Set ErrorMsg=$ZE
	Quit "-999"_"^"_ErrorMsg
}

/// Creator：     yankai
/// CreatDate：   2019-10-08
/// Description:  门诊路径检查方剂变异并保存变异原因
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       aVisitID
/// Return：      %String
/// w ##class(DHCMA.CPW.OPCPS.PathwayVarSrv).SaveTCMPVar("714!!1","3675||1*686||4*V^4702||1*686||5*V^","10209!!1")	
ClassMethod SaveTCMPVar(aEpisodeID As %String, aOrdStr As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aOrdStr,aUserID)
	Set return=""
	Quit:aEpisodeID="" return
	;Set ^TEMPYK("SaveTCMPVar")=$lb(aEpisodeID,aOrdStr,aUserID)
	
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID(aEpisodeID)
	Set (VarRsnID,VarRsnTxt)=""
	Set IsAutoSaveVar=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPEvrInNewEp",AdmHospID)
	If IsAutoSaveVar="Y"||IsAutoSaveVar=1{
		Set VarRsnDicIDStr=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPVarRsnIDs",AdmHospID)	
		Set TCMPVarRsnID=$p(VarRsnDicIDStr,",",2)  									//中药方剂变异原因ID
	
		Set objTCMPVarRsn=##class(DHCMA.CPW.BT.PathVariat).GetObjById(TCMPVarRsnID)
		Quit:'$IsObject(objTCMPVarRsn) return
		Set VarRsnID=TCMPVarRsnID
		Set VarRsnTxt=objTCMPVarRsn.BTDesc	
	}

	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjByEpisodeID(aEpisodeID)
	Quit:'$IsObject(objVisit) return
	Quit:'$IsObject(objVisit.CPPathwayDr) return
	Quit:'$IsObject(objVisit.CPEpisDr) return
	Set PathwayID=objVisit.CPPathwayDr.%Id()
	Set EpisID=objVisit.CPEpisDr.%Id()
	
	Set $ZT="SaveTCMPVarError"
	
	Kill FJDetail,TCMPExeOrds,CVOEItemID
	Set xImplID=""
	For {
	 	Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",PathwayID,EpisID,xImplID))
	 	Quit:xImplID=""
	 	
	 	Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(PathwayID_"||"_xImplID)
	 	Continue:'$IsObject(objImpl)
	 	Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
	 	Continue:(TypeDesc'="重点医嘱")
	 	Set FormItemID=objImpl.CPFormItemDr.%Id()
	 	Set FormID =$p(FormItemID,"||",1)
		Set FormEpID =$p(FormItemID,"||",2)
		Set FormEpItemID =$p(FormItemID,"||",3)
		//获取表单维护的所有方剂明细
		if ($d(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormID,FormEpID,FormEpItemID))) {
			Set xTCMDr=""
			for {
				Set xTCMDr=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormID,FormEpID,FormEpItemID,xTCMDr))
				Quit:xTCMDr=""
				
				Set xSubFormTCMID=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormID,FormEpID,FormEpItemID,xTCMDr,""))
				Set xFormTCMID=FormID_"||"_FormEpID_"||"_FormEpItemID_"||"_xSubFormTCMID
				;w PathwayID_","_xImplID_","_xFormTCMID
				
				//对执行记录中的方剂检查，已执行的方剂不进行变异检查
				Continue:$d(^DHCMA.CPW.CP.PathwayI("IMPL","ORD","IdxofFJParRef",PathwayID,xImplID,xFormTCMID))
				
				Set xSubTCMId="",FJDetail(xImplID_"||"_xTCMDr)=""
				for {
					Set xSubTCMId=$o(^DHCMA.CPW.BT.PathTCMD(xTCMDr,"EXT",xSubTCMId))
					Quit:xSubTCMId=""
							
					Set TCMOrdId=xTCMDr_"||"_xSubTCMId
					Set TCMOrder=##class(DHCMA.CPW.BT.PathTCMExt).GetObjById(TCMOrdId)
					Set OrdMastID="",IsExe=0
					Set OrdMastDesc=TCMOrder.BTOrdMastID  //表中存的医嘱描述,考虑兼容后面改为存医嘱ID
					Set:+OrdMastDesc>0 OrdMastID=OrdMastDesc
					Set TCMType=TCMOrder.BTTypeDr.BTDesc
					Set SPriority=TCMOrder.SPriority
					//Set IOrdMastDesc=$tr($tr(OrdMastDesc,"[",""),"]","")
					Set IOrdMastDesc=$$ALPHAUP^SSUTIL4(OrdMastDesc)
					if (OrdMastID="") {
						Set ArcMID=$o(^ARCIM(0,"Desc",IOrdMastDesc,""),-1)
						Set VerID=$o(^ARCIM(0,"Desc",IOrdMastDesc,ArcMID,""),-1)
						Set OrdMastID=ArcMID_"||"_VerID
					}
					Set:TCMType="君" OrdMastID=OrdMastID_"*"_"君" 
					Set FJDetail(xImplID_"||"_xTCMDr)=FJDetail(xImplID_"||"_xTCMDr)_$lb(OrdMastID)				//所有维护的方剂明细存入临时变量
				}
			}
		}
	}
	
	//循环检查所有传入医嘱项是否符合方剂变异条件
	Set xSubTCMDr=""
	For {
		Set xSubTCMDr=$o(FJDetail(xSubTCMDr))
		Quit:xSubTCMDr=""
		
		Set IsTCMPVar=0,CVOEItemID(xSubTCMDr)=""
		For indx=1:1:$l(aOrdStr,"^"){
			Quit:'$d(FJDetail(xSubTCMDr))
			Set xExeOrdMastID=$p($p(aOrdStr,"^",indx),"*",1)
			Set xExeOrdOEItemID=$p($p(aOrdStr,"^",indx),"*",2)
			
			For indy=1:1:$ll(FJDetail(xSubTCMDr)){
				Set xFJOrdMastID=$p($li(FJDetail(xSubTCMDr),indy),"*",1)
				If xFJOrdMastID=xExeOrdMastID{
					Set IsTCMPVar=1
					Set CVOEItemID(xSubTCMDr)=CVOEItemID(xSubTCMDr)_$lb(xExeOrdOEItemID)
					If $p($li(FJDetail(xSubTCMDr),indy),"*",2)="君"{
						Set IsTCMPVar=0
						Kill FJDetail(xSubTCMDr)
						Kill CVOEItemID(xSubTCMDr)
						Quit
					}
				}
			}
				
		}
		//符合方剂变异的添加变异记录
		If IsTCMPVar=1 {
			Set xCVImplID=$p(xSubTCMDr,"||",1)
			Set xCVTCMID=$p(xSubTCMDr,"||",2)
			Set xObjCVTCM=##class(DHCMA.CPW.BT.PathTCM).GetObjById(xCVTCMID)
			Continue:'$IsObject(xObjCVTCM)
			Set xCVTCMDesc=xObjCVTCM.BTDesc
			For indz=1:1:$ll(CVOEItemID(xSubTCMDr)){
				Set xCVOEItemID=$li(CVOEItemID(xSubTCMDr),indz)
				Set InputStr=PathwayID_"^"_""_"^"_VarRsnID_"^"_"【"_xCVTCMDesc_"】"_VarRsnTxt_"^"_EpisID_"^"_PathwayID_"||"_xCVImplID_"^"_xCVOEItemID_"^"_aUserID_"^"_1	
				Do ##class(DHCMA.CPW.CP.PathwayVar).Update(InputStr,"^")
			}	
		}
	}
	Quit 1
	
SaveTCMPVarError
	Set ErrorMsg=$ZE
	Quit "-999"_"^"_ErrorMsg
}

/// Creator：     yankai
/// CreatDate：   2019-09-09
/// Description:  门诊路径保存路径外医嘱变异原因
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       aVisitID
/// Return：      %String
/// w ##class(DHCMA.CPW.OPCPS.PathwayVarSrv).SaveOutPathOrdVar("27","2514||1","707||5","19","10209!!1")	
ClassMethod SaveOutPathOrdVar(aVisitID As %String, aOEMastID As %String, aOEItemID As %String, aUserID As %String = "") As %String
{
	New (aVisitID,aOEMastID,aOEItemID,aUserID)
	Set return=""
	Quit:(aVisitID="")||(aOEMastID="")||(aOEItemID="") return
	
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID("","",aVisitID)
	
	Set (VarRsnID,VarRsnTxt)=""
	Set IsAutoSaveVar=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPEvrInNewEp",AdmHospID)
	If IsAutoSaveVar="Y"||IsAutoSaveVar=1{
		Set VarRsnDicIDStr=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWOPVarRsnIDs",AdmHospID)	
		Set OutPathOrdVarRsnID=$p(VarRsnDicIDStr,",",3) 									//路径外医嘱变异原因ID
															
		Set objOrdVarRsn=##class(DHCMA.CPW.BT.PathVariat).GetObjById(OutPathOrdVarRsnID)	//路径外医嘱变异原因
		Quit:'$IsObject(objOrdVarRsn) return
		Set VarRsnID=OutPathOrdVarRsnID
		Set VarRsnTxt=objOrdVarRsn.BTDesc	
	}
		
	Set objVisit=##class(DHCMA.CPW.CP.PathwayVisit).GetObjById(aVisitID)
	Quit:'$IsObject(objVisit) return
	Quit:'$IsObject(objVisit.CPPathwayDr) return
	Quit:'$IsObject(objVisit.CPEpisDr) return
	Set PathwayID=objVisit.CPPathwayDr.%Id()
	Set EpisID=objVisit.CPEpisDr.%Id()
	
	Set $ZT="SaveOutPathOrdVarError"
	Set IsNew=1
	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",PathwayID,EpisID,xVarID))
		Quit:xVarID=""
				
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(PathwayID_"||"_xVarID)
		Continue:'$IsObject(objVar)
		Continue:$IsObject(objVar.CPImplDr) //路径外医嘱没有项目指针
		Set VarOrd=objVar.CPOrdDID	
		If (+objVar.CPIsActive=0) {			//回写前有效性为0
			If (VarOrd=aOEMastID) {		//回写前VarOrd为医嘱字典ID
				Set return=##class(DHCMA.CPW.CP.PathwayVar).UpdateVarOrder(PathwayID_"||"_xVarID,aOEItemID)
			 	Set IsNew=0
			 	Quit
			} 
		} Else {
			Set xVarOrd=$p(VarOrd,"^",1)	//回写后为医嘱记录ID
			Set xOESubID=$p(xVarOrd,"||",2)
			Set xOEItmMastID = $p($g(^OEORD(+xVarOrd,"I",xOESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
			If (aOEMastID=xOEItmMastID) {
				Set return=##class(DHCMA.CPW.CP.PathwayVar).UpdateVarOrder(PathwayID_"||"_xVarID,aOEItemID)
			 	Set IsNew=0
			 	Quit
			}
		}
	}
	//插入新记录
	If (IsNew=1) {
		Set InputStr=PathwayID_"^"_""_"^"_VarRsnID_"^"_VarRsnTxt_"^"_EpisID_"^"_""_"^"_aOEItemID_"^"_aUserID_"^"_1
		Set return=##class(DHCMA.CPW.CP.PathwayVar).Update(InputStr,"^")
	}
	
	Quit return
	
SaveOutPathOrdVarError
	Quit "-999"
}

/// Creator:	  jiangpengpeng
/// Description:  查询一个阶段里的路径外医嘱  
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
///               aStepID : 阶段ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.OPCPS.PathwayVarSrv","QryCPWVarOrder","21","21||2")
Query QryCPWVarOrder(aPathwayID As %String, aEpisID As %String) As %Query(ROWSPEC = "ind:%String,VarID:%String,OrdDID:%String,ARCIMDesc:%String,VariatCat:%String,VariatTxt:%String") [ SqlProc ]
{
}

ClassMethod QryCPWVarOrderExecute(ByRef qHandle As %Binary, aPathwayID As %String, aEpisID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPathwayID="")||(aEpisID="") $$$OK
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",aPathwayID,aEpisID,xVarID))
		Quit:xVarID=""
		
		Set (VariatTxt,VariatCat)=""
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
 		Continue:'$IsObject(objVar)
	 	Continue:objVar.CPIsActive'=1											//对医嘱而言，CPIsActive=0表示未回写orderID
	 	Continue:(objVar.CPOrdDID="")||($IsObject(objVar.CPImplDr)) 			//路径外医嘱变异：医嘱不为空但项目为空
	 	
 		Set VariatTxt=objVar.CPVariatTxt
 		Set VariatCat=objVar.CPVariatDr.BTDesc
 		Set:VariatCat'="" VariatCat=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVariat","BTDesc",VariatCat,LangID)
 		
 		Set xOrdDID=objVar.CPOrdDID
 		Set:xOrdDID["^" xOrdDID=$p(xOrdDID,"^",1)
 		Set OESubID=$p(xOrdDID,"||",2)
		Set OEItmMastID = $p($g(^OEORD(+xOrdDID,"I",OESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
 		Set ARCIMDesc=$p($g(^ARCIM(+OEItmMastID,1,1)),"^",2)
 		Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
 		Set:'objVar.CPIsActive ARCIMDesc=$p($g(^ARCIM(+objVar.CPOrdDID,1,1)),"^",2)	//未回写orderID
 		
		Set Data=$lb(ind,xVarID,xOrdDID,ARCIMDesc,VariatCat,VariatTxt)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWVarOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVarOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVarOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVarOrderExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-11
/// Description:  查询一个阶段里的未执行项目
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aEpisodeID : 就诊号
///               aStepID : 阶段ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.OPCPS.PathwayVarSrv","QryCPWVarItem","77","77||1")
Query QryCPWVarItem(aPathwayID As %String, aEpisID As %String) As %Query(ROWSPEC = "ind:%String,VarID:%String,ImplID:%String,IndexNo:%String,ItemDesc:%String,TypeDesc:%String,VariatTxt:%String,VariatCat:%String") [ SqlProc ]
{
}

ClassMethod QryCPWVarItemExecute(ByRef qHandle As %Binary, aPathwayID As %String, aEpisID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aPathwayID="")||(aEpisID="") $$$OK
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set xImplID=""
 	For {
 		Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
 		Quit:xImplID=""
 		
 		Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
 		Continue:'$IsObject(objImpl)
 		
 		Set IsActive=objImpl.CPIsActive
 		Continue:'IsActive
 		Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
 		Continue:'IsRequired	//是否可选
 		Set IsImp=objImpl.CPIsImp
 		Continue:IsImp
 		
 		Set ItemDesc=objImpl.CPFormItemDr.ItemDesc
 		Set IndexNo=objImpl.CPFormItemDr.ItemIndNo
 		Set TypeDesc=objImpl.CPFormItemDr.ItemCatDr.BTTypeDr.BTDesc
 		Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.Util.BT.Dictionary","BTDesc",TypeDesc,LangID)
 		
 		Set (VariatTxt,VariatCat)=""
 		Set xVarID=""
 		For {
			Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,aPathwayID_"||"_xImplID,xVarID))
			Quit:xVarID=""
			
	 		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
	 		If ($IsObject(objVar)) {
		 		Continue:'objVar.CPIsActive
		 		
	 			Set VariatTxt=objVar.CPVariatTxt
	 			Set VariatCat=objVar.CPVariatDr.BTDesc
	 			Set:VariatCat'="" VariatCat=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVariat","BTDesc",VariatCat,LangID)
	 		}
			Quit
		}
	 	Set Data=$lb(ind,xVarID,xImplID,IndexNo,ItemDesc,TypeDesc,VariatTxt,VariatCat)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
			
 	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWVarItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWVarItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWVarItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWVarItemExecute ]
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

/// Creator:	  yankai
/// Description:  查询一个阶段里的方剂变异
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       aEpisodeID : 就诊号
///               aStepID : 阶段ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.OPCPS.PathwayVarSrv","QryCPWTCMVar","59","59||1")
Query QryCPWTCMVar(aPathwayID As %String, aEpisID As %String) As %Query(ROWSPEC = "ind:%String,VarID:%String,OrdDID:%String,ARCIMDesc:%String,VariatCat:%String,VariatTxt:%String,ImplID:%String,ImplDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCPWTCMVarExecute(ByRef qHandle As %Binary, aPathwayID As %String, aEpisID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aPathwayID="")||(aEpisID="") $$$OK
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",aPathwayID,aEpisID,xVarID))
		Quit:xVarID=""
		
		Set (VariatTxt,VariatCat)=""
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
 		Continue:'$IsObject(objVar)
	 	Continue:objVar.CPIsActive'=1										//对医嘱而言，CPIsActive=0表示未回写orderID
	 	Continue:(objVar.CPOrdDID="")||('$IsObject(objVar.CPImplDr))		//方剂变异：医嘱不为空且项目也不为空
	 	
 		Set VariatTxt=objVar.CPVariatTxt
 		Set VariatCat=objVar.CPVariatDr.BTDesc
 		Set:VariatCat'="" VariatCat=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVariat","BTDesc",VariatCat,LangID)
 		Set ImplID=objVar.CPImplDr.%Id()
 		Set ImplDesc=objVar.CPImplDr.CPFormItemDr.ItemDesc
 		Set:ImplDesc'="" ImplDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathFormItem","ItemDesc",ImplDesc,LangID)
 		Set xOrdDID=objVar.CPOrdDID
 		Set:xOrdDID["^" xOrdDID=$p(xOrdDID,"^",1)
 		Set OESubID=$p(xOrdDID,"||",2)
		Set OEItmMastID = $p($g(^OEORD(+xOrdDID,"I",OESubID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
 		Set ARCIMDesc=$p($g(^ARCIM(+OEItmMastID,1,1)),"^",2)
 		Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
 		
 		Set:'objVar.CPIsActive ARCIMDesc=$p($g(^ARCIM(+objVar.CPOrdDID,1,1)),"^",2)	//未回写orderID
 		Set:ARCIMDesc'="" ARCIMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ARCIMDesc,Languages)
 		
		Set Data=$lb(ind,xVarID,xOrdDID,ARCIMDesc,VariatCat,VariatTxt,ImplID,ImplDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	
 	Quit $$$OK
}

ClassMethod QryCPWTCMVarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWTCMVarExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWTCMVarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWTCMVarExecute ]
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

/// Creator：     yankai
/// CreatDate：   2019-10-24
/// Description:  阶段确认前检查未执行项目及变异
/// Table：       
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.OPCPS.PathwayVarSrv).CheckVarToCfmStep(60,"60||1")
ClassMethod CheckVarToCfmStep(aPathwayID As %String, aEpisID As %String) As %String
{
	New (aPathwayID,aEpisID)
	Set return=""
	Quit:(aPathwayID="")||(aEpisID="") return
	
	Set Count=0
	//检查未添加变异原因的未执行项目
	Set xImplID=""
	For {
	 	Set xImplID=$o(^DHCMA.CPW.CP.PathwayI("IMPL","IdxofParRef",aPathwayID,aEpisID,xImplID))
	 	Quit:xImplID=""
	 		
	 	Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_xImplID)
	 	Continue:'$IsObject(objImpl)
 			
	 	Continue:objImpl.CPIsActive'=1
	 	Set IsRequired=+'objImpl.CPFormItemDr.ItemIsOption	//两变量值相反
	 	Continue:IsRequired'=1								//只检查必选项目
	 	Set IsImp=objImpl.CPIsImp
	 	Continue:IsImp=1									//过滤已执行项目
	 	Set Count=Count+1									//未执行项目计数+1
	 		
	 	Set xVarID=""
	 	For {
			Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEpImpl",aPathwayID,aEpisID,aPathwayID_"||"_xImplID,xVarID))
			Quit:xVarID=""
				
		 	Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
		 	If ($IsObject(objVar)) {
			 	Continue:'objVar.CPIsActive
			 	Set Count=Count-1							//未执行项目添加了变异原因-1
		 	}
		}
				
	 }
	Set return=Count
	Quit:return>0 return	
	
	Set AdmHospID=##class(DHCMA.CPW.IO.FromDoc).GetAdmHospOID("",aPathwayID,"")	
	Set Count=0
	Set xVarID=""
	For {
		Set xVarID=$o(^DHCMA.CPW.CP.PathwayI("VAR","IdxofPwEp",aPathwayID,aEpisID,xVarID))
		Quit:xVarID=""
				
		Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aPathwayID_"||"_xVarID)
		Continue:'$IsObject(objVar)
		Continue:'objVar.CPIsActive
		Continue:objVar.CPOrdDID=""									//过滤未执行项目变异
		Continue:$IsObject(objVar.CPVariatDr)						//过滤已添加原因的变异
		Set Count=Count+1		
	}
	Set return=Count
	Quit return
}

}
