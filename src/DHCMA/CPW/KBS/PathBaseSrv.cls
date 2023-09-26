Class DHCMA.CPW.KBS.PathBaseSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2022-6-27
/// Description:  查询项目库
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.KBS.PathBaseSrv","QryPBase","")
Query QryPBase(q As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTType:%String,BTTypeID:%String,BTYear:%String,BTPubType:%String,BTIsActive:%String,BTAdmType:%String,BTIsOper:%String,BTPDFPath:%String,BTDiseEtyName:%String,BTDiseEtyNameID:%String")
{
}

ClassMethod QryPBaseExecute(ByRef qHandle As %Binary, q As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID=""
 	For {
	 	Set xID      = $o(^CT.MA.CPW.KB.PathBaseD(xID))
	 	Quit:xID=""
	 	Set obj         = ##class(DHCMA.CPW.KB.PathBase).GetObjById(xID)
	 	continue:'$IsObject(obj)	
	 	Set Desc          = obj.PBDesc			//路径名称
	 	Continue:(q'="")&&(Desc'[q)
	 	Set Code          = obj.PBCode			//路径名称
	 	Set Year          = obj.PBPubYear		//发布年份
	 	Set Type          = obj.PBType			//专科类型
	 	Set TypeID=##Class(DHCMA.CPW.BTS.ImportPathWay).GetCPWTypeID(Type)
	 	Set PubType       = obj.PBPubType		//发布类型
	 	Set AdmType       = obj.PBAdmType		//是否门诊
	 	Set IsActive      = obj.PBIsActive		//是否有效
	 	Set IsOper        = obj.PBIsOper		//是否手术
	 	Set PDFPath       = obj.PBPDFPath		//pdf文件存储路径
	 	Set DiseEtyName	  = obj.PBDiseEtyName
	 	Set DiseEtyNameID=""
	 	Set:DiseEtyName'="" DiseEtyNameID=##class(DHCMA.CPW.BTS.PathEntitySrv).GetIdByDesc(DiseEtyName)
	 	Set IsOper=$s(IsOper>0:"是",IsOper<=0:"否",1:"")
	 	Set AdmType=$s(AdmType="I":"否",AdmType="O":"是",1:"")
	 	Set IsActive=$s(IsActive>0:"是",IsActive<=0:"否",1:"")
	 	Set PubType=$s(PubType="G":"常规版",PubType="C":"县医院版",1:"")
		Set Data=$lb(xID,Code,Desc,Type,TypeID,Year,PubType,IsActive,AdmType,IsOper,PDFPath,DiseEtyName,DiseEtyNameID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPBaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPBaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPBaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPBaseExecute ]
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

/// Creator：     zqy
/// CreatDate：   2022-6-27
/// Description:  查询项目库
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.KBS.PathBaseSrv","QryPBaseOrderYear","")
Query QryPBaseOrderYear(q As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTType:%String,BTTypeID:%String,BTYear:%String,BTPubType:%String,BTIsActive:%String,BTAdmType:%String,BTIsOper:%String,BTPDFPath:%String,BTDiseEtyName:%String,BTDiseEtyNameID:%String")
{
}

ClassMethod QryPBaseOrderYearExecute(ByRef qHandle As %Binary, q As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xYear=""
 	For{
	 	Set xYear=$o(^CT.MA.CPW.KB.PathBaseI("IdxofPubYear",xYear),-1)
	 	Quit:xYear=""
	 	Set xID=""
	 	For {
		 	Set xID      = $o(^CT.MA.CPW.KB.PathBaseI("IdxofPubYear",xYear,xID))
		 	Quit:xID=""
		 	Set obj         = ##class(DHCMA.CPW.KB.PathBase).GetObjById(xID)
		 	continue:'$IsObject(obj)	
		 	Set Desc          = obj.PBDesc			//路径名称
		 	Continue:(q'="")&&(Desc'[q)
		 	Set Code          = obj.PBCode			//路径名称
		 	Set Year          = obj.PBPubYear		//发布年份
		 	Set Type          = obj.PBType			//专科类型
		 	Set TypeID=##Class(DHCMA.CPW.BTS.ImportPathWay).GetCPWTypeID(Type)
		 	Set PubType       = obj.PBPubType		//发布类型
		 	Set AdmType       = obj.PBAdmType		//是否门诊
		 	Set IsActive      = obj.PBIsActive		//是否有效
		 	Set IsOper        = obj.PBIsOper		//是否手术
		 	Set PDFPath       = obj.PBPDFPath		//pdf文件存储路径
		 	Set DiseEtyName	  = obj.PBDiseEtyName
		 	Set DiseEtyNameID=""
		 	Set:DiseEtyName'="" DiseEtyNameID=##class(DHCMA.CPW.BTS.PathEntitySrv).GetIdByDesc(DiseEtyName)
		 	Set IsOper=$s(IsOper>0:"是",IsOper<=0:"否",1:"")
		 	Set AdmType=$s(AdmType="I":"否",AdmType="O":"是",1:"")
		 	Set IsActive=$s(IsActive>0:"是",IsActive<=0:"否",1:"")
		 	Set PubType=$s(PubType="G":"常规版",PubType="C":"县医院版",1:"")
			Set Data=$lb(xID,Code,Desc,Type,TypeID,Year,PubType,IsActive,AdmType,IsOper,PDFPath,DiseEtyName,DiseEtyNameID)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	 }
 	
	Quit $$$OK
}

ClassMethod QryPBaseOrderYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPBaseOrderYearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPBaseOrderYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPBaseOrderYearExecute ]
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

/// Creator：     zqy
/// CreatDate：   2022-6-27
/// Description:  查询项目库
/// w ##class(DHCMA.CPW.KBS.PathBaseSrv).GetKBInfo("关节")
ClassMethod GetKBInfo(aKeyValue As %String, aYear As %String = "", aType As %String = "", aPubType As %String = "") As %String
{
	New (aKeyValue,aYear,aType,aPubType)
	Set return=""
	//Quit:aKeyValue="" return
	Set xID=""
 	For {
	 	Set xID      = $o(^CT.MA.CPW.KB.PathBaseD(xID))
	 	Quit:xID=""
	 	Set obj         = ##class(DHCMA.CPW.KB.PathBase).GetObjById(xID)
	 	continue:'$IsObject(obj)	
	 	Set Desc          = obj.PBDesc			//路径名称
	 	Set Year          = obj.PBPubYear		//发布年份
	 	Set Type          = obj.PBType			//专科类型
	 	Set PubType       = obj.PBPubType		//发布类型
	 	Continue:(aKeyValue'="")&&(Desc'[aKeyValue)
	 	Continue:(aYear'="")&&(Year'[aYear)
	 	Continue:(aType'="")&&(Type'[aType)
	 	Set PubType=$s(PubType="G":"常规版",PubType="C":"县医院版",1:"")
	 	Continue:(aPubType'="")&&(PubType'[aPubType)
	 	
	 	Set Keys=obj.PBICDKeys
	 	Set OperKeys=obj.PBOperKeys
	 	Set:OperKeys'="" Keys=Keys_","_OperKeys
	 	Set SuitInfo=obj.PBSuitInfo				//对象
	 	Set InPathStd=obj.PBInPathStd			//进入路径标准
	 	Set PDFPath=obj.PBPDFPath
	 	Set xVarRsn="",PVDesc=""
	 	For{
		 	Set xVarRsn=$o(^CT.MA.CPW.KB.PathBaseI("VAR","IdxofPar",xID,xVarRsn))
		 	Quit:xVarRsn=""
		 	Set VarRsnobj = ##class(DHCMA.CPW.KB.PathVarRsn).GetObjById(xID_"||"_xVarRsn)
	 		continue:'$IsObject(VarRsnobj)	
	 		if (PVDesc=""){
		 		Set PVDesc=VarRsnobj.PVDesc
		 	}else{
			 	Set:PVDesc'="" PVDesc=PVDesc_"。"_VarRsnobj.PVDesc
			}
		 }
		Set PVDesc=..CleanSpecialChar(PVDesc) 
		Set InPathStd=..CleanSpecialChar(InPathStd)
		Set SuitInfo=..CleanSpecialChar(SuitInfo)
		Set Keys=..CleanSpecialChar(Keys)
		Set:$e(Keys,0,1)="," Keys=$e(Keys,2,$l(Keys))	//关键字
		Set Json="{"
		Set Json=Json_"""BTID"":"""_xID_""","
		Set Json=Json_"""BTDesc"":"""_Desc_""","
		Set Json=Json_"""BTType"":"""_Type_""","
		Set Json=Json_"""BTKeys"":"""_Keys_""","
		Set Json=Json_"""BTSuitInfo"":"""_SuitInfo_""","
		Set Json=Json_"""BTInPathStd"":"""_InPathStd_""","
		Set Json=Json_"""BTPVDesc"":"""_PVDesc_""","
		Set Json=Json_"""BTYear"":"""_Year_""","
		Set Json=Json_"""BTPDFPath"":"""_PDFPath_""","
		Set Json=Json_"""BTPubType"":"""_PubType_""""
		Set Json=Json_"}"
		if (return=""){
			Set return=Json
		}else{
			Set return=return_","_Json
		}
 	}
	Quit "["_return_"]"
}

ClassMethod CleanSpecialChar(inputStr) As %String
{
	New (inputStr)

	Set inputStr=$tr(inputStr,$char(10),"")			//换行
	Set inputStr=$tr(inputStr,$char(13),"")			//回车
	Set inputStr=$zcvt(inputStr,"O","JSON")
	Quit inputStr
}

/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.KBS.PathBaseSrv","QryPathStage","1041")
Query QryPathStage(aPathBaseDr As %String) As %Query(ROWSPEC = "ID:%String,EpDesc:%String,EpDesc2:%String,EpIndNo:%String,EpDays:%String,EpIsKeyStep:%String,EpIsKeyStepD:%String,EpIsOperDay:%String,EpIsOperDayD:%String,EpIsFirstDay:%String,EpIsFirstDayD:%String,EpIsActive:%String,EpIsActiveD:%String")
{
}

ClassMethod QryPathStageExecute(ByRef qHandle As %Binary, aPathBaseDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:aPathBaseDr="" $$$OK
	Set xIndNo=""
 	For {
	 	Set xIndNo = $o(^CT.MA.CPW.KB.PathBaseI("STG","IdxofIndNo",aPathBaseDr,xIndNo))	
	 	Quit:xIndNo=""
	 	
	 	Set xChildID=""
	 	For {
		 	Set xChildID = $o(^CT.MA.CPW.KB.PathBaseI("STG","IdxofIndNo",aPathBaseDr,xIndNo,xChildID))
		 	Quit:xChildID=""
		 	
			Set obj = ##class(DHCMA.CPW.KB.PathStage).GetObjById(aPathBaseDr_"||"_xChildID)
			Continue:'$isobject(obj)
			
		 	Set EpDesc = obj.PSDesc
		 	Set EpDesc2 =obj.PSDesc2
		 	Set EpIndNo = obj.PSIndNo
		 	Set TimeUnit=$Case(obj.PSTimeUnit,"MTH":"月","W":"周","D":"天","H":"时","M":"分钟","T":"次",:"")
		 	Set EpDays = obj.PSTime_TimeUnit
			
		 	Set EpIsKeyStep = obj.PSIsKeyStep
		 	Set EpIsOperDay = obj.PSIsOperDay
		 	Set EpIsFirstDay = obj.PSIsFirstDay
		 	Set EpIsActive = obj.PSIsActive
		 	Set (EpIsKeyStepD,EpIsOperDayD,EpIsFirstDayD,EpIsActiveD)="否"
		 	Set:EpIsKeyStep=1 EpIsKeyStepD="是"
		 	Set:EpIsOperDay=1 EpIsOperDayD="是"
		 	Set:EpIsFirstDay=1 EpIsFirstDayD="是"
		 	Set:EpIsActive=1 EpIsActiveD="是"
		 	
		 	Set Data=$lb(aPathBaseDr_"||"_xChildID,EpDesc,EpDesc2,EpIndNo,EpDays,EpIsKeyStep,EpIsKeyStepD,EpIsOperDay,EpIsOperDayD,EpIsFirstDay,EpIsFirstDayD,EpIsActive,EpIsActiveD)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 }
	 
	Quit $$$OK
}

ClassMethod QryPathStageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathStageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathStageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathStageExecute ]
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

/// Creator：     zqy
/// CreatDate：   2022-07-27
/// Description:  表单预览展现内容
/// Table：       
/// Input：       PathBaseID : 表单ID
/// Return：      返回{rows: [{"K1":"V1","K2":"V2","K3":"V3"},{},...,{}], total: n, curPage: 1}
/// w ##class(DHCMA.CPW.KBS.PathBaseSrv).GetViewFormItems(1041)
ClassMethod GetViewFormItems(aPathBaseID As %String) As %String
{
	New (aPathBaseID)
	Set return=""
	Quit:aPathBaseID="" return
	Set NIndex="GetViewFormItems"
    Kill ^TMP($zn,$j,NIndex)
	Set objPathBase = ##class(DHCMA.CPW.KB.PathBase).GetObjById(aPathBaseID)
	Quit:'$IsObject(objPathBase) return
	Set FormDesc=objPathBase.PBDesc
	Set FormName=FormDesc
	Set FormCost=""
	Set TimeUnit=$Case(objPathBase.PBPathTimeUnit,"MTH":"月","W":"周","D":"天","H":"时","M":"分钟","T":"次",:"")
	Set FormDays=objPathBase.PBPathTime_TimeUnit
	
	//主要诊疗项目(A),重点医嘱项目(B),主要护理项目(C)
	Set strRowArr="",strRowStepDays=""	
	Set xIndNo="",strDaysJson="",strZLJson="",strYZJson="",strHLJson="",strVarJson="",strNurSignJson="",strDocSignJson=""
 	For {
	 	Set xIndNo = $o(^CT.MA.CPW.KB.PathBaseI("STG","IdxofIndNo",aPathBaseID,xIndNo))
	 	Quit:xIndNo=""

	 	Set xStageID="",tmpDaysKV="",tmpZLKV="",tmpYZKV="",tmpHLKV="",tmpVarKV="",tmpNurSignKV="",tmpDocSignKV=""
	 	For {
		 	Set xStageID = $o(^CT.MA.CPW.KB.PathBaseI("STG","IdxofIndNo",aPathBaseID,xIndNo,xStageID))
		 	Quit:xStageID=""
		 	
		 	Set xBaseStageID = aPathBaseID_"||"_xStageID
			Set objStage = ##class(DHCMA.CPW.KB.PathStage).GetObjById(xBaseStageID)
			Continue:'$IsObject(objStage)
			Set TimeUnit=$Case(objStage.PSTimeUnit,"MTH":"月","W":"周","D":"天","H":"时","M":"分钟","T":"次",:"")
			Set EpDays = objStage.PSTime_TimeUnit	//天数
			//主要诊疗工作
			Set xClinItemID=""
			For{
				Set xClinItemID=$o(^CT.MA.CPW.KB.PathBaseD(aPathBaseID,"STG",xStageID,"CLINITM",xClinItemID))
				Quit:xClinItemID=""
				Set objClinItem = ##class(DHCMA.CPW.KB.PathClinItem).GetObjById(aPathBaseID_"||"_xStageID_"||"_xClinItemID)
				Continue:'$IsObject(objClinItem)
				Set ClinItemID = objClinItem.%Id()
			 	Set ClinItemDesc = objClinItem.PCDesc
				Set ClinItemIndNo=objClinItem.PCIndNo	//顺序号	
				If '$d(^TMP($zn,$j,NIndex,"CLINITM",ClinItemIndNo,ClinItemID)){
					Set ^TMP($zn,$j,NIndex,"CLINITM",ClinItemIndNo,ClinItemID)=ClinItemIndNo
				}
			}
			//重点医嘱工作
			Set xOrdItemID=""
			For{
				Set xOrdItemID=$o(^CT.MA.CPW.KB.PathBaseD(aPathBaseID,"STG",xStageID,"ORDITM",xOrdItemID))
				Quit:xOrdItemID=""
				Set objOrdItem = ##class(DHCMA.CPW.KB.PathOrdItem).GetObjById(aPathBaseID_"||"_xStageID_"||"_xOrdItemID)
				Continue:'$IsObject(objOrdItem)
				Set OrdItemID = objOrdItem.%Id()
			 	Set OrdItemDesc = objOrdItem.PODesc
				Set OrdItemIndNo=objOrdItem.POIndNo	//顺序号	
				If '$d(^TMP($zn,$j,NIndex,"ORDITM",OrdItemIndNo,OrdItemID)){
					Set ^TMP($zn,$j,NIndex,"ORDITM",OrdItemIndNo,OrdItemID)=OrdItemIndNo
				}
			}
			//主要护理工作
			Set xNurItemID=""
			For{
				Set xNurItemID=$o(^CT.MA.CPW.KB.PathBaseD(aPathBaseID,"STG",xStageID,"NURITM",xNurItemID))
				Quit:xNurItemID=""
				Set objNurItem = ##class(DHCMA.CPW.KB.PathNurItem).GetObjById(aPathBaseID_"||"_xStageID_"||"_xNurItemID)
				Continue:'$IsObject(objNurItem)
				Set NurItemID = objNurItem.%Id()
			 	Set NurItemDesc = objNurItem.PNDesc
				Set NurItemIndNo=objNurItem.PNIndNo	//顺序号	
				If '$d(^TMP($zn,$j,NIndex,"NURITM",NurItemIndNo,NurItemID)){
					Set ^TMP($zn,$j,NIndex,"NURITM",NurItemIndNo,NurItemID)=NurItemIndNo
				}
			}
			Set xColZLValue="",xColYZValue="",xColHLValue="",tmpCQYZValue="",tmpLSYZValue="",tmpQTYZValue=""
			Set xType=""
			For {
				Set xType = $o(^TMP($zn,$j,NIndex,xType))
				Quit:xType=""
				Set IndNo=""
				For {
					Set IndNo = $o(^TMP($zn,$j,NIndex,xType,IndNo))
					Quit:IndNo=""
					//主要诊疗工作
					If (xType="CLINITM"){
						Set tID=""
						For {
							Set tID = $o(^TMP($zn,$j,NIndex,xType,IndNo,tID))
							Quit:tID=""
							;b ;1
							Set objClinItem = ##class(DHCMA.CPW.KB.PathClinItem).GetObjById(tID)
							Continue:'$IsObject(objClinItem)
							Set ItemID = objClinItem.%Id()
							Set ItemDesc = objClinItem.PCDesc
							Set:xColZLValue'="" xColZLValue=xColZLValue_"</br>"
				 			Set xColZLValue=xColZLValue_"<input class='hisui-checkbox' type='checkbox' label='"_ItemDesc_"' id='chk-"_ItemID_"'></input>"
						}
						Kill ^TMP($zn,$j,NIndex,"CLINITM",IndNo)
					}
					//重点医嘱工作
					If (xType="ORDITM"){
						Set tID=""
						For {
							Set tID = $o(^TMP($zn,$j,NIndex,xType,IndNo,tID))
							Quit:tID=""
							Set objOrdItem = ##class(DHCMA.CPW.KB.PathOrdItem).GetObjById(tID)
							Continue:'$IsObject(objOrdItem)
							Set ItemID = objOrdItem.%Id()
							Set ItemDesc = objOrdItem.PODesc
							Set Category = objOrdItem.POCategory
							if (Category["长期医嘱"){
								Set:tmpCQYZValue'="" tmpCQYZValue=tmpCQYZValue_"</br><input class='hisui-checkbox' type='checkbox' label='"_ItemDesc_"' id='chk-"_ItemID_"'></input>"
								Set:tmpCQYZValue="" tmpCQYZValue="<b>长期医嘱</b><br/><input class='hisui-checkbox' type='checkbox' label='"_ItemDesc_"' id='chk-"_ItemID_"'></input>"	
							}elseIf (Category["临时医嘱"){
								Set:tmpLSYZValue'="" tmpLSYZValue=tmpLSYZValue_"</br><input class='hisui-checkbox' type='checkbox' label='"_ItemDesc_"' id='chk-"_ItemID_"'></input>"
								Set:tmpLSYZValue="" tmpLSYZValue="<b>临时医嘱</b><br/><input class='hisui-checkbox' type='checkbox' label='"_ItemDesc_"' id='chk-"_ItemID_"'></input>"
							}else{
								Set:tmpQTYZValue'="" tmpQTYZValue=tmpQTYZValue_"</br><input class='hisui-checkbox' type='checkbox' label='"_ItemDesc_"' id='chk-"_ItemID_"'></input>"
								Set:tmpQTYZValue="" tmpQTYZValue="<b>医嘱</b><br/><input class='hisui-checkbox' type='checkbox' label='"_ItemDesc_"' id='chk-"_ItemID_"'></input>"
							}
						}
						Kill ^TMP($zn,$j,NIndex,"ORDITM",IndNo)
					}
					//主要护理工作
					If (xType="NURITM"){
						Set tID=""
						For {
							Set tID = $o(^TMP($zn,$j,NIndex,xType,IndNo,tID))
							Quit:tID=""
							Set objNurItem = ##class(DHCMA.CPW.KB.PathNurItem).GetObjById(tID)
							Continue:'$IsObject(objNurItem)
							Set ItemID = objNurItem.%Id()
							Set ItemDesc = objNurItem.PNDesc
							Set:xColHLValue'="" xColHLValue=xColHLValue_"</br>"
				 			Set xColHLValue=xColHLValue_"<input class='hisui-checkbox' type='checkbox' label='"_ItemDesc_"' id='chk-"_ItemID_"'></input>"
						}
						Kill ^TMP($zn,$j,NIndex,"NURITM",IndNo)
					}
					
					
					
				}
			}
			
			//医嘱项目
			Set:tmpQTYZValue'="" xColYZValue=tmpQTYZValue
			Set:tmpCQYZValue'="" xColYZValue=xColYZValue_"</br>"_tmpCQYZValue
			Set:tmpLSYZValue'="" xColYZValue=xColYZValue_"</br>"_tmpLSYZValue
			
			//参考时间
			Set:tmpDaysKV'="" tmpDaysKV=tmpDaysKV_",""FLD-"_xBaseStageID_""":"""_EpDays_""""
			Set:tmpDaysKV="" tmpDaysKV="""FLD-"_xBaseStageID_""":"""_EpDays_""""
			
			//诊疗内容
			Set:tmpZLKV'="" tmpZLKV=tmpZLKV_",""FLD-"_xBaseStageID_""":"""_xColZLValue_""""	
			Set:tmpZLKV="" tmpZLKV="""FLD-"_xBaseStageID_""":"""_xColZLValue_""""
			
			//重点医嘱
			Set:tmpYZKV'="" tmpYZKV=tmpYZKV_",""FLD-"_xBaseStageID_""":"""_xColYZValue_""""
			Set:tmpYZKV="" tmpYZKV="""FLD-"_xBaseStageID_""":"""_xColYZValue_""""
			
			//护理工作
			Set:tmpHLKV'="" tmpHLKV=tmpHLKV_",""FLD-"_xBaseStageID_""":"""_xColHLValue_""""	
			Set:tmpHLKV="" tmpHLKV="""FLD-"_xBaseStageID_""":"""_xColHLValue_""""	
			
			//病情变异
			Set:tmpVarKV'="" tmpVarKV=tmpVarKV_",""FLD-"_xBaseStageID_""":""<input class='hisui-checkbox' type='checkbox' label='有' name='isVar-_'"_xBaseStageID_" value='1' data-options=\""radioClass:'hischeckbox_square'\""/>&nbsp;&nbsp;&nbsp;&nbsp<input class='hisui-checkbox' type='checkbox' label='无' name='isVar-_'"_xBaseStageID_" value='0' data-options=\""radioClass:'hischeckbox_square'\""/></br>原因："""
			Set:tmpVarKV="" tmpVarKV="""FLD-"_xBaseStageID_""":""<input class='hisui-checkbox' type='checkbox' label='有' name='isVar-_'"_xBaseStageID_" value='1' data-options=\""radioClass:'hischeckbox_square'\""/>&nbsp;&nbsp;&nbsp;&nbsp<input class='hisui-checkbox' type='checkbox' label='无' name='isVar-_'"_xBaseStageID_" value='0' data-options=\""radioClass:'hischeckbox_square'\""/></br>原因："""
			
			//护士签名
			Set:tmpNurSignKV'="" tmpNurSignKV=tmpNurSignKV_",""FLD-"_xBaseStageID_""":"""""
			Set:tmpNurSignKV="" tmpNurSignKV="""FLD-"_xBaseStageID_""":""签名："""
			
			//医生签名
			Set:tmpDocSignKV'="" tmpDocSignKV=tmpDocSignKV_",""FLD-"_xBaseStageID_""":"""""
			Set:tmpDocSignKV="" tmpDocSignKV="""FLD-"_xBaseStageID_""":""签名："""
			
		}
		Set:strDaysJson'="" strDaysJson=strDaysJson_","
		Set:strDaysJson="" strDaysJson="{""step"":""参考时间"","
		Set strDaysJson=strDaysJson_tmpDaysKV
		
		Set:strZLJson'="" strZLJson=strZLJson_","
		Set:strZLJson="" strZLJson="{""step"":""主要诊疗工作"","
		Set strZLJson=strZLJson_tmpZLKV
		 
		Set:strYZJson'="" strYZJson=strYZJson_","	
		Set:strYZJson="" strYZJson="{""step"":""重点医嘱工作"","
		Set strYZJson=strYZJson_tmpYZKV
		
		Set:strHLJson'="" strHLJson=strHLJson_","
		Set:strHLJson="" strHLJson="{""step"":""主要护理工作"","	
		Set strHLJson=strHLJson_tmpHLKV
		
		Set:strVarJson'="" strVarJson=strVarJson_","
		Set:strVarJson="" strVarJson="{""step"":""病情变异记录"","		
		Set strVarJson=strVarJson_tmpVarKV
		
		Set:strNurSignJson'="" strNurSignJson=strNurSignJson_","
		Set:strNurSignJson="" strNurSignJson="{""step"":""护士签名"","
		Set strNurSignJson=strNurSignJson_tmpNurSignKV
		
		Set:strDocSignJson'="" strDocSignJson=strDocSignJson_","
		Set:strDocSignJson="" strDocSignJson="{""step"":""医生签名"","
		Set strDocSignJson=strDocSignJson_tmpDocSignKV
	 }
	 
	 Set strRowVar="["_strDaysJson_"},"_strZLJson_"},"_strYZJson_"},"_strHLJson_"},"_strVarJson_"},"_strNurSignJson_"},"_strDocSignJson_"}]"
	 Set return="{""rows"":"_strRowVar_",""total"":5,""curPage"":1,""name"":"""_FormName_""",""cost"":"""_FormCost_""",""days"":"""_FormDays_"""}"
	 
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-6-27
/// Description:  查询项目库年份维度
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.KBS.PathBaseSrv","QryPBYear")
Query QryPBYear() As %Query(ROWSPEC = "BTDesc:%String")
{
}

ClassMethod QryPBYearExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set NIndex="QryPBYear"
 	Kill ^TMP($zn,$j,NIndex)
 	Set xID=""
 	For {
	 	Set xID      = $o(^CT.MA.CPW.KB.PathBaseD(xID))
	 	Quit:xID=""
	 	Set obj         = ##class(DHCMA.CPW.KB.PathBase).GetObjById(xID)
	 	continue:'$IsObject(obj)	
	 	Set Year          = obj.PBPubYear		//发布年份
	 	Set ^TMP($zn,$j,NIndex,Year)=""
 	}
 	Set xYear=""
 	For{
		Set xYear=$o(^TMP($zn,$j,NIndex,xYear))
		Quit:xYear=""
		Set Data=$lb(xYear)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	Quit $$$OK
}

ClassMethod QryPBYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPBYearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPBYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPBYearExecute ]
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
