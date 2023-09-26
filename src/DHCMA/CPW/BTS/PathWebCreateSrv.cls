/// 名称: DHCMA.CPW.BTS.PathWebCreateSrv
/// 描述: 临床web页面服务类
/// 编写者：zqy
/// 编写日期: 2022-9-6
Class DHCMA.CPW.BTS.PathWebCreateSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2022-9-8
/// Description:  web创建的路径
/// Table：       DHCMA.CPW.BT.PathWebCreate
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathWebCreateSrv","QryPathWebCreate","","334")
Query QryPathWebCreate(aKeyValue As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "BTID:%String,MastID:%String,BTFormID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String,BTAdmType:%String,BTEntityID:%String,BTEntityDesc:%String,BTPathComplID:%String,BTPathComplDesc:%String,BTIsActiveDesc:%String,BTIsOper:%String,IsOperDesc:%String,BTCreUserDesc:%String,BTCreLocDesc:%String,CreDate:%String,CreTime:%String,IsCompl:%String,IsComplDesc:%String")
{
}

ClassMethod QryPathWebCreateExecute(ByRef qHandle As %Binary, aKeyValue As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:aLocID'["!!" aLocID=aLocID_"!!"_SYSDr
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCMA.CPW.BT.PathWebCreateI("IdxofLoc"," "_aLocID,xID))
	 	Quit:xID=""
	 	Set obj=##class(DHCMA.CPW.BT.PathWebCreate).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.BTStatus="C"
	 	Continue:'$IsObject(obj.PathFormDr.FormPathDr)
	 	Set MastID=obj.PathFormDr.FormPathDr.%Id()
	 	Set Mastobj=##class(DHCMA.CPW.BT.PathMast).GetObjById(MastID)
	 	Continue:'$IsObject(Mastobj)
	 	Set FormID	  = obj.PathFormDr.%Id()
	 	Set Code      = Mastobj.BTCode	//路径代码
	 	Set Desc      = Mastobj.BTDesc	//路径名称
	 	Set TypeID="",TypeDesc=""		//专科类型
	 	If $IsObject(Mastobj.BTTypeDr) {
		 	Set TypeID      = Mastobj.BTTypeDr.%Id()
		 	Set TypeDesc    = Mastobj.BTTypeDr.BTDesc
	 	}
	 	Set AdmType = Mastobj.BTAdmType		//就诊类型
	 	Set EntityID="",EntityDesc=""		//病种路径
	 	If $IsObject(Mastobj.BTEntityDr){
		 	Set EntityID    = Mastobj.BTEntityDr.%Id()
		 	Set EntityDesc  = Mastobj.BTEntityDr.BTDesc
	 	}
	 	Set PathComplID="",PathComplDesc=""	//合病种路径
	 	If $IsObject(Mastobj.BTPathComplDr){
			 Set PathComplID = Mastobj.BTPathComplDr.%Id()
			 Set PathComplDesc = Mastobj.BTPathComplDr.BTDesc
		 }
		
		Set IsCompl  = Mastobj.BTIsAsCompl	//是否合并症
	 	Set IsComplDesc=$s(IsCompl=1:"是",1:"否")
	 	
		Set IsActive  = Mastobj.BTIsActive	//是否有效
	 	Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
	 	Set IsOper	  = Mastobj.BTIsOper	//是否手术
	 	Set IsOperDesc=$s(IsOper=1:"是",1:"否")
	 	
	 	Set CreUserID=obj.BTCreUserID
	 	Set CreLocID=obj.BTCreLocID
	 	Set CreDate=obj.BTCreDate
	 	Set CreTime=obj.BTCreTime
	 	Set:CreDate'="" CreDate=$zd(CreDate,3)
	 	Set:CreTime'="" CreTime=$zt(CreTime,1)
	 	Set CreUserDesc    = "" 
	 	Set objUser    = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(CreUserID)
	 	if ($IsObject(objUser)) {
	 		Set CreUserDesc= objUser.BTDesc
	 	}
	 	Set CreLocDesc=""
		Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(CreLocID)
		Set:$IsObject(objLoc) CreLocDesc=objLoc.BTDesc
		Set:CreLocDesc["-" CreLocDesc=$p(CreLocDesc,"-",2)
		
		Set Data=$lb(xID,MastID,FormID,Code,Desc,TypeID,TypeDesc,AdmType,EntityID,EntityDesc,PathComplID,PathComplDesc,IsActiveDesc,IsOper,IsOperDesc,CreUserDesc,CreLocDesc,CreDate,CreTime,IsCompl,IsComplDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathWebCreateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathWebCreateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathWebCreateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathWebCreateExecute ]
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
/// CreatDate：   2022-9-6
/// Description:  保存web创建的新路径
/// Return：      成功：返回ID，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).SavePathMast("^987654^性早熟^29^^^^^^^^^I^0^1^9!!1^334^2")
ClassMethod SavePathMast(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set ID      	    = 	$p(aInputStr,aSeparete,1)       
	Set Code     		= 	$p(aInputStr,aSeparete,2)	//病种代码
	Set Desc    		= 	$p(aInputStr,aSeparete,3)	//病种描述
	Set BTTypeDr  		= 	$p(aInputStr,aSeparete,4)	//路径类型
	Set EntityDr  		= 	$p(aInputStr,aSeparete,5)	//病种路径
	Set EntityCode 		= 	$p(aInputStr,aSeparete,6)	//新增病种代码
	Set EntityDesc 		= 	$p(aInputStr,aSeparete,7)	//新增病种描述
	Set EntityTypeDr   	= 	$p(aInputStr,aSeparete,8)	//新增病种路径类型
	//Set ComEntityDr    	= 	$p(aInputStr,aSeparete,9)	//合并症
	//Set ComEntityCode  	= 	$p(aInputStr,aSeparete,10)	//新增合并症代码
	//Set ComEntityDesc  	= 	$p(aInputStr,aSeparete,11)	//新增合并症描述
	Set IsCompl 		= 	$p(aInputStr,aSeparete,9)	//合并症
	Set IOType 			= 	$p(aInputStr,aSeparete,10)	//就诊类型
	Set IsOper 			= 	$p(aInputStr,aSeparete,11)	//是否手术路径
	Set IsActive 		= 	$p(aInputStr,aSeparete,12)	//是否有效
	Set User 			= 	$p(aInputStr,aSeparete,13)	//操作人
	Set Loc 			= 	$p(aInputStr,aSeparete,14)	//操作科室
	Set PBID			=   $p(aInputStr,aSeparete,15)	//国家发布
	Set HospID			=   $p(aInputStr,aSeparete,16)	//院区id
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set:User'["!!" User=User_"!!"_SYSDr
	Set:Loc'["!!" Loc=Loc_"!!"_SYSDr
	Set:HospID'["!!" HospID=HospID_"!!"_SYSDr
	
	Set $ZT="SavePathMastErr"
	TStart
	
	Set EntityFlag=""
	if ((EntityCode'="")||(EntityDesc'="")){
		Set EntityInputStr=""_"^"_EntityCode_"^"_EntityDesc_"^1^"_EntityTypeDr_"^^^"_User
		Set EntityFlag=##class(DHCMA.CPW.BT.PathEntity).Update(EntityInputStr,"^",HospID)   
		If EntityFlag<0 TRollBack
		Quit:EntityFlag<0 -1
	}

	
	Set:EntityFlag'="" EntityDr=EntityFlag
	//Set IO=$s(IOType="O":"门诊",1:"住院")
	Set IO=IOType
	Set MastInputStr=""_"^"_Code_"^"_Desc_"^"_BTTypeDr_"^"_EntityDr_"^"_""_"^"_""_"^"_IsActive_"^"_""_"^"_""_"^"_User_"^"_IO_"^"_""_"^"_IsOper_"^"_""_"^"_IsCompl
	Set Flag=##class(DHCMA.CPW.BT.PathMast).Update(MastInputStr,"^",HospID)
	If Flag<0 TRollBack
	Quit:Flag<0 -3
	
	Set Clearflg =##class(DHCMA.CPW.BT.PathHosp).Clear(Flag)
	Set HospInputStr=Flag_"^"_""_"^"_HospID_"^"_"1"_"^"_User
	Set HospFlag=##class(DHCMA.CPW.BT.PathHosp).Update(HospInputStr)
	If HospFlag<0 TRollBack
	Quit:HospFlag<0 -3
	
	Set InputStr=""_"^"_Flag_"^"_""_"^"_""_"^"_""_"^"_""_"^1"_"^"_""_"^"_""_"^"_User_"^"_"1"_"^"_"0"
	Set flg=##Class(DHCMA.CPW.BT.PathForm).Update(InputStr)
	If flg<0 TRollBack
	Quit:flg<0 -4
	
	Set ret=##Class(DHCMA.CPW.BT.PathWebCreate).Update(""_"^"_flg_"^"_""_"^"_Loc_"^"_User)
	If ret<0 TRollBack
	Quit:ret<0 -5
	
	if (PBID'=""){
		Set pbflag=..CopyPB(flg,PBID,User)
		If pbflag<0 TRollBack
		Quit:pbflag<0 -6
	}
	
	If $TLevel>0 TCommit
	Quit ret
	
SavePathMastErr
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).CopyPB("66","1","9!!1")
ClassMethod CopyPB(aPathFormID As %String, aPBaseID As %String, aUser As %String) As %String
{
	New (aPathFormID,aPBaseID,aUser)
	Set return=-1
	Quit:(aPathFormID="")||(aPBaseID="") return
	
	//设置异常标志
	Set ErrorFlg=0
	Set objPB=##class(DHCMA.CPW.KB.PathBase).GetObjById(aPBaseID)
	Quit:'$IsObject(objPB) return
	Set xIndNo=""
	For{
		Set xIndNo=$o(^CT.MA.CPW.KB.PathBaseI("STG","IdxofIndNo",aPBaseID,xIndNo))
		Quit:xIndNo=""
		Quit:ErrorFlg'=0
		Set StgID=""
		For{
			Set StgID=$o(^CT.MA.CPW.KB.PathBaseI("STG","IdxofIndNo",aPBaseID,xIndNo,StgID))
			Quit:StgID=""
			Quit:ErrorFlg'=0
			//遍历阶段
			Set objStg=##class(DHCMA.CPW.KB.PathStage).GetObjById(aPBaseID_"||"_StgID)
			Quit:'$IsObject(objStg)
			Set PSDesc=objStg.PSDesc
			Set PSDesc2=objStg.PSDesc2
			Set PSIndNo=objStg.PSIndNo
			Set PSTime=objStg.PSTime
			Set PSIsKeyStep=objStg.PSIsKeyStep
			Set PSIsOperDay=objStg.PSIsOperDay
			Set PSIsFirstDay=objStg.PSIsFirstDay
			Set:+PSTime=0 PSTime=1 //如果没有指定阶段时长，默认为一天
			Set inputStr=aPathFormID_"^"_""_"^"_PSDesc_"^"_PSDesc2_"^"_PSIndNo_"^"_PSTime_"^"_PSIsKeyStep_"^"_PSIsOperDay_"^"_PSIsFirstDay_"^"_1_"^"_""_"^"_""_"^"_aUser
			Set FormEpID=##class(DHCMA.CPW.BT.PathFormEp).Update(inputStr,"^")
			Set:FormEpID<0 ErrorFlg=1_"^"_inputStr
			//诊疗工作
			Set CIndNo=""
			For{
				Set CIndNo=$o(^CT.MA.CPW.KB.PathBaseI("CLINITM","IdxofIndNo",aPBaseID,StgID,CIndNo))
				Quit:CIndNo=""
				Quit:ErrorFlg'=0
				Set CID=""
				For{
					Set CID=$o(^CT.MA.CPW.KB.PathBaseI("CLINITM","IdxofIndNo",aPBaseID,StgID,CIndNo,CID))
					Quit:CID=""
					Set objCItm=##class(DHCMA.CPW.KB.PathClinItem).GetObjById(aPBaseID_"||"_StgID_"||"_CID)
					Quit:'$IsObject(objCItm)
					Set PCDesc=objCItm.PCDesc
					Set PCCategory=objCItm.PCCategory
					Set PCIndNo=objCItm.PCIndNo
					Set PCIsOption=objCItm.PCIsOption
					Set PCIsActive=objCItm.PCIsActive
					Set PCIsOption=$s(PCIsOption=0:1,1:0)
					Set ItemCatObj=##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode("A00")
					Quit:'$IsObject(ItemCatObj)
					Set CItminputStr=aPathFormID_"||"_FormEpID_"^"_""_"^"_PCDesc_"^"_ItemCatObj.%Id()_"^"_PCIndNo_"^"_PCIsOption_"^"_1_"^"_""_"^"_""_"^"_aUser
					Set return=##class(DHCMA.CPW.BT.PathFormItem).Update(CItminputStr,"^")
					Set:return<0 ErrorFlg=2_"^"_CItminputStr
				}
			}
			//护理工作
			Set NIndNo=""
			For{
				Set NIndNo=$o(^CT.MA.CPW.KB.PathBaseI("NURITM","IdxofIndNo",aPBaseID,StgID,NIndNo))
				Quit:NIndNo=""
				Quit:ErrorFlg'=0
				Set NID=""
				For{
					Set NID=$o(^CT.MA.CPW.KB.PathBaseI("NURITM","IdxofIndNo",aPBaseID,StgID,NIndNo,NID))
					Quit:NID=""
					Quit:ErrorFlg'=0
					Set objNItm=##class(DHCMA.CPW.KB.PathNurItem).GetObjById(aPBaseID_"||"_StgID_"||"_NID)
					Quit:'$IsObject(objNItm)
					Set Desc=objNItm.PNDesc
					Set IndNo=objNItm.PNIndNo
					Set IsOption=objNItm.PNIsOption
					Set ItemCatObj=##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode("C00")
					Quit:'$IsObject(ItemCatObj)
					Set IsOption=$s(IsOption=0:1,1:0)
					Set NItminputStr=aPathFormID_"||"_FormEpID_"^"_""_"^"_Desc_"^"_ItemCatObj.%Id()_"^"_IndNo_"^"_IsOption_"^"_1_"^"_""_"^"_""_"^"_aUser
					Set return=##class(DHCMA.CPW.BT.PathFormItem).Update(NItminputStr,"^")
					Set:return<0 ErrorFlg=3_"^"_NItminputStr
				}
			}
			//医嘱工作
			Set OIndNo=""
			For{
				Set OIndNo=$o(^CT.MA.CPW.KB.PathBaseI("ORDITM","IdxofIndNo",aPBaseID,StgID,OIndNo))
				Quit:OIndNo=""
				Quit:ErrorFlg'=0
				Set OID=""
				For{
					Set OID=$o(^CT.MA.CPW.KB.PathBaseI("ORDITM","IdxofIndNo",aPBaseID,StgID,OIndNo,OID))
					Quit:OID=""
					Quit:ErrorFlg'=0
					Set objOItm=##class(DHCMA.CPW.KB.PathOrdItem).GetObjById(aPBaseID_"||"_StgID_"||"_OID)
					Quit:'$IsObject(objOItm)
					Set Desc=objOItm.PODesc
					Set IndNo=objOItm.POIndNo
					Set IsOption=objOItm.POIsOption
					Set POCategory=objOItm.POCategory
					Set Cate="B02"
					Set:POCategory["长期" Cate="B01"
					Set ItemCatObj=##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode(Cate)
					Quit:'$IsObject(ItemCatObj)
					Set IsOption=$s(IsOption=0:1,1:0)
					Set OItminputStr=aPathFormID_"||"_FormEpID_"^"_""_"^"_Desc_"^"_ItemCatObj.%Id()_"^"_IndNo_"^"_IsOption_"^"_1_"^"_""_"^"_""_"^"_aUser
					Set return=##class(DHCMA.CPW.BT.PathFormItem).Update(OItminputStr,"^")
					Set:return<0 ErrorFlg=4_"^"_OItminputStr
				}
			}

		}
		
	}
	Set return=1
	Set:ErrorFlg'=0 return=-1
	Quit return
}

/// ^DHCMA.CPW.BT.PathFormD(1,"EP",1) 
/// Creator：     chenjb
/// CreatDate：   2018-09-07
/// Description:  查询临床
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathWebCreateSrv","QryPathFormEp","33")
Query QryPathFormEp(aPathFormDr As %String) As %Query(ROWSPEC = "ID:%String,EpDesc:%String,EpDesc2:%String,EpIndNo:%String,EpDays:%String,EpIsKeyStep:%String,EpIsKeyStepD:%String,EpIsOperDay:%String,EpIsOperDayD:%String,EpIsFirstDay:%String,EpIsFirstDayD:%String,EpIsActive:%String,EpIsActiveD:%String")
{
}

ClassMethod QryPathFormEpExecute(ByRef qHandle As %Binary, aPathFormDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:aPathFormDr="" $$$OK
	Set xIndNo=""
 	For {
	 	Set xIndNo = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormDr,xIndNo))		//直接走顺序号索引,按维护顺序输出阶段 fix by yankai20210302
	 	Quit:xIndNo=""
	 	
	 	Set xChildID=""
	 	For {
		 	Set xChildID = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormDr,xIndNo,xChildID))
		 	Quit:xChildID=""
		 	
			Set obj = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aPathFormDr_"||"_xChildID)
			Continue:'$isobject(obj)
			
		 	Set EpDesc = obj.EpDesc
		 	Set EpDesc2 =obj.EpDesc2
		 	Set EpIndNo = obj.EpIndNo
		 	Set EpDays = obj.EpDays
			
		 	Set EpIsKeyStep = obj.EpIsKeyStep
		 	Set EpIsOperDay = obj.EpIsOperDay
		 	Set EpIsFirstDay = obj.EpIsFirstDay
		 	Set EpIsActive = obj.EpIsActive
		 	Set (EpIsKeyStepD,EpIsOperDayD,EpIsFirstDayD,EpIsActiveD)="否"
		 	Set:EpIsKeyStep=1 EpIsKeyStepD="是"
		 	Set:EpIsOperDay=1 EpIsOperDayD="是"
		 	Set:EpIsFirstDay=1 EpIsFirstDayD="是"
		 	Set:EpIsActive=1 EpIsActiveD="是"
		 	
		 	Set Data=$lb(aPathFormDr_"||"_xChildID,EpDesc,EpDesc2,EpIndNo,EpDays,EpIsKeyStep,EpIsKeyStepD,EpIsOperDay,EpIsOperDayD,EpIsFirstDay,EpIsFirstDayD,EpIsActive,EpIsActiveD)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 }
	 
	Quit $$$OK
}

ClassMethod QryPathFormEpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormEpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormEpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormEpExecute ]
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
/// CreatDate：   2021-03-04
/// Description:  表单预览展现内容
/// Table：       
/// Input：       PathFormID : 表单ID
/// Return：      返回{rows: [{"K1":"V1","K2":"V2","K3":"V3"},{},...,{}], total: n, curPage: 1}
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).GetViewFormItems(65)
ClassMethod GetViewFormItems(aPathFormID As %String) As %String
{
	New (aPathFormID)
	Set return=""
	Quit:aPathFormID="" return
	Set NIndex="GetViewFormItems"
    Kill ^TMP($zn,$j,NIndex)
	Set objPathForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(aPathFormID)
	Quit:'$IsObject(objPathForm) return
	Set FormDesc=objPathForm.FormPathDr.BTDesc
	Set FormVersion=objPathForm.FormVersion_".0"
	Set FormName=FormDesc_"(v"_FormVersion_")"

	//主要诊疗项目(A),重点医嘱项目(B),主要护理项目(C)
	Set strRowArr="",strRowStepDays=""	
	Set xIndNo=""
	Set strDaysJson="{""step"":""参考时间"""
	Set strZLJson="{""step"":""主要诊疗工作"""
	Set strYZJson="{""step"":""重点医嘱工作"""
    Set strHLJson="{""step"":""主要护理工作"""
 	For {
	 	Set xIndNo = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormID,xIndNo))
	 	Quit:xIndNo=""
	 	
	 	Set xSubEpID="",tmpDaysKV="",tmpZLKV="",tmpYZKV="",tmpHLKV=""
	 	For {
		 	Set xSubEpID = $o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",aPathFormID,xIndNo,xSubEpID))
		 	Quit:xSubEpID=""
		 	
		 	Set xFormEpID = aPathFormID_"||"_xSubEpID
			Set objFormEP = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(xFormEpID)
			Continue:'$IsObject(objFormEP)
			Set EpDays = objFormEP.EpDays_"天"
			
			Set xItemID = "",xColZLValue="",xColYZValue="",xColHLValue="",tmpCQYZValue="",tmpLSYZValue=""
			For {
			 	Set xItemID = $o(^DHCMA.CPW.BT.PathFormD(aPathFormID,"EP",xSubEpID,"ITM",xItemID))
			 	Quit:xItemID=""
			 	
				Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aPathFormID_"||"_xSubEpID_"||"_xItemID)
				Continue:'$IsObject(objItem)
				Set ItemID = objItem.%Id()
			 	Set ItemDesc = objItem.ItemDesc
			 	Set ItemDesc=$Replace(ItemDesc,"""","“")
			 	Continue:'$IsObject(objItem.ItemCatDr) 	
				
				Set ItemIndNo=objItem.ItemIndNo	//顺序号	
				If '$d(^TMP($zn,$j,NIndex,ItemIndNo,ItemID)){
					Set ^TMP($zn,$j,NIndex,ItemIndNo,ItemID)=ItemIndNo
				}
				
			}
			Set IndNo=""
			For {
				Set IndNo = $o(^TMP($zn,$j,NIndex,IndNo))
				Quit:IndNo=""
				Set tID=""
				For {
					Set tID = $o(^TMP($zn,$j,NIndex,IndNo,tID))
					Quit:tID=""
					Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(tID)
					Continue:'$IsObject(objItem)
					Set ItemID = objItem.%Id()
					Set ItemDesc = objItem.ItemDesc
					Set ItemDesc=$Replace(ItemDesc,"""","“")
					Set ItemDesc=$Replace(ItemDesc,"\","/")
					Continue:'$IsObject(objItem.ItemCatDr) 	
					If objItem.ItemCatDr.BTCode["A"	{				//主要诊疗工作
						Set:xColZLValue'="" xColZLValue=xColZLValue_"</br>"
						Set EpID=$p(ItemID,"||",1,2)
				 		Set xColZLValue=xColZLValue_"<input class='hisui-radio' type='radio' name='ZL"_EpID_"' value="_ItemID_" data-options=\""radioClass:'hischeckbox_square-blue'\"" id='chk-"_ItemID_"'><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
					}
					If objItem.ItemCatDr.BTCode["B"	{				//重点医嘱工作
						//输出医嘱类别和项目
						Set EpID=$p(ItemID,"||",1,2)
						If (objItem.ItemCatDr.BTCode["B01"){		//长期医嘱
							Set:tmpCQYZValue'="" tmpCQYZValue=tmpCQYZValue_"</br><input class='hisui-radio' name='YZ"_EpID_"' type='radio' value="_ItemID_" data-options=\""radioClass:'hischeckbox_square-blue'\"" id='chk-"_ItemID_"'><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
							Set:tmpCQYZValue="" tmpCQYZValue="<b>长期医嘱</b><br/><input class='hisui-radio' name='YZ"_EpID_"' type='radio' value="_ItemID_" data-options=\""radioClass:'hischeckbox_square-blue'\"" id='chk-"_ItemID_"'><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"	
						}
						If (objItem.ItemCatDr.BTCode["B02"){		//临时医嘱（含出院医嘱）
							Set:tmpLSYZValue'="" tmpLSYZValue=tmpLSYZValue_"</br><input class='hisui-radio' name='YZ"_EpID_"' type='radio' value="_ItemID_" data-options=\""radioClass:'hischeckbox_square-blue'\"" id='chk-"_ItemID_"'><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
							Set:tmpLSYZValue="" tmpLSYZValue="<b>临时医嘱</b><br/><input class='hisui-radio' name='YZ"_EpID_"' type='radio' value="_ItemID_" data-options=\""radioClass:'hischeckbox_square-blue'\"" id='chk-"_ItemID_"'><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
						}
						Set xColYZValue=tmpCQYZValue_"</br></br>"_tmpLSYZValue
					}
					If objItem.ItemCatDr.BTCode["C"	{				//主要护理工作
						Set EpID=$p(ItemID,"||",1,2)
						Set:xColHLValue'="" xColHLValue=xColHLValue_"</br>"
					 	Set xColHLValue=xColHLValue_"<input  class='hisui-radio' type='radio' name='HL"_EpID_"' value="_ItemID_" data-options=\""radioClass:'hischeckbox_square-blue'\"" id='chk-"_ItemID_"'><label for='chk-"_ItemID_"'>"_ItemDesc_"</label>"
					}
				}
				Kill ^TMP($zn,$j,NIndex,IndNo)
			}
			//参考时间
			Set:tmpDaysKV'="" tmpDaysKV=tmpDaysKV_",""FLD-"_xFormEpID_""":"""_EpDays_""""
			Set:tmpDaysKV="" tmpDaysKV="""FLD-"_xFormEpID_""":"""_EpDays_""""
			
			//诊疗内容
			Set:tmpZLKV'="" tmpZLKV=tmpZLKV_",""FLD-"_xFormEpID_""":"""_xColZLValue_""""	
			Set:tmpZLKV="" tmpZLKV="""FLD-"_xFormEpID_""":"""_xColZLValue_""""
			
			//重点医嘱
			Set:tmpYZKV'="" tmpYZKV=tmpYZKV_",""FLD-"_xFormEpID_""":"""_xColYZValue_""""
			Set:tmpYZKV="" tmpYZKV="""FLD-"_xFormEpID_""":"""_xColYZValue_""""
			
			//护理工作
			Set:tmpHLKV'="" tmpHLKV=tmpHLKV_",""FLD-"_xFormEpID_""":"""_xColHLValue_""""	
			Set:tmpHLKV="" tmpHLKV="""FLD-"_xFormEpID_""":"""_xColHLValue_""""	
			
			
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
		
	 }

	Set strRowVar="["_strDaysJson_"},"_strZLJson_"},"_strYZJson_"},"_strHLJson_"}]"
	Set return="{""rows"":"_strRowVar_",""total"":5,""curPage"":1,""name"":"""_FormName_"""}"
	
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-9-9
/// Description:  保存阶段信息,自动补充顺序号
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Return：      成功：ID，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).UpdateFromEp("33^33||8^第2^第三天^1^1^1^9!!1")
ClassMethod UpdateFromEp(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		 = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set:ChildSub["||" ChildSub= $p(ChildSub,"||",2)
	Set EpDesc       = $p(aInputStr,aSeparete,3)
	Set EpDesc2      = $p(aInputStr,aSeparete,4)
	Set EpDays  	 = +$p(aInputStr,aSeparete,5)
	Set EpIsKeyStep  = +$p(aInputStr,aSeparete,6)
	Set EpIsOperDay  = +$p(aInputStr,aSeparete,7)
	Set EpActUserID  = $p(aInputStr,aSeparete,8)
	if (ChildSub'=""){
		Set obj=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(Parref_"||"_ChildSub)
		Quit:'$IsObject(obj) return
		Set EpIndNo=obj.EpIndNo
	}else{
		Set EpIndNo=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",Parref,""),-1)
	}
	Set:(ChildSub="")&&(EpIndNo'="") EpIndNo=+EpIndNo+1
	Set:EpIndNo="" EpIndNo=1
	Set aInputStr=Parref_"^"_ChildSub_"^"_EpDesc_"^"_EpDesc2_"^"_EpIndNo_"^"_EpDays_"^"_EpIsKeyStep_"^"_EpIsOperDay_"^^1^^^"_EpActUserID
	Set return=##class(DHCMA.CPW.BT.PathFormEp).Update(aInputStr,"^")
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-9-13
/// Description:  调整顺序号
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Return：      成功：ID，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).RightMove(33)
ClassMethod RightMove(aEpID As %String) As %String
{
	New (aEpID)
	Set return=0
	Quit:aEpID="" return
	
	Set objFormEP = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aEpID)
	Quit:'$IsObject(objFormEP) return
	Set EpIndNo=objFormEP.EpIndNo
	Set Parref=$p(aEpID,"||",1)
	Set AfterIndNo=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",Parref,EpIndNo))
	Quit:AfterIndNo="" -777
	Set AfterSubID=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",Parref,AfterIndNo,""),-1)
	Set AfterID=Parref_"||"_AfterSubID
	Set return=..UpdateIndNo(AfterID,EpIndNo)
	Quit:return<0 return
	Set return=..UpdateIndNo(aEpID,AfterIndNo)
	Quit:return<0 return
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-9-13
/// Description:  调整顺序号
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Return：      成功：ID，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).LeftMove("33||1")
ClassMethod LeftMove(aEpID As %String) As %String
{
	New (aEpID)
	Set return=0
	Quit:aEpID="" return
	Set objFormEP = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aEpID)
	Quit:'$IsObject(objFormEP) return
	Set EpIndNo=objFormEP.EpIndNo
	Set Parref=$p(aEpID,"||",1)
	Set BeforeIndNo=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",Parref,EpIndNo),-1)
	Quit:BeforeIndNo="" -777
	Set BeforeSubID=$o(^DHCMA.CPW.BT.PathFormI("EP","IdxofIndNo",Parref,BeforeIndNo,""),-1)
	Set BeforeID=Parref_"||"_BeforeSubID
	Set return=..UpdateIndNo(BeforeID,EpIndNo)
	Quit:return<=0 return
	Set return=..UpdateIndNo(aEpID,BeforeIndNo)
	Quit:return<=0 return
	Quit return
}

/// Description:  保存顺序号
/// Table：       DHCMA.CPW.BT.PathFormEp
/// Return：      成功：ID，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).UpdateIndNo(33)
ClassMethod UpdateIndNo(aEpID As %String, EpIndNo As %String) As %String
{
	New (aEpID,EpIndNo)
	Set return=0
	Quit:(aEpID="")||(EpIndNo="") return
	
	Set objFormEP = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(aEpID)
	Quit:'$IsObject(objFormEP) return
	Set objFormEP.EpIndNo=EpIndNo
	Set sc=objFormEP.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=objFormEP.%Id()
	}
	Do objFormEP.%Close()

	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-9-9
/// Description:  保存项目信息,自动补充顺序号
/// Table：       DHCMA.CPW.BT.PathFormItem
/// Return：      成功：ID，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).UpdateFromEpItem("75||64^75||64||10^出院带药^B01^22222^1^9!!1")
ClassMethod UpdateFromEpItem(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set xChildSub=""
	Set Parref		 	= $p(aInputStr,aSeparete,1)
	Set ChildSub     	= $p(aInputStr,aSeparete,2)
	Set:$l(ChildSub,"||")=3 xChildSub= $p(ChildSub,"||",3)
	Set ItemDesc       	= $p(aInputStr,aSeparete,3)
	Quit:ItemDesc="" "-999"
	Set ItemCatDr      	= $p(aInputStr,aSeparete,4)
	Set:ItemCatDr="A" ItemCatDr="A00"
	Set:ItemCatDr="C" ItemCatDr="C00"
	Set ItemCatObj=##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode(ItemCatDr)
	Quit:'$IsObject(ItemCatObj) return
	Set ItemCatID=ItemCatObj.%Id()
	Set ExeDesc      	= $p(aInputStr,aSeparete,5)
	Set ItemIsOption   	= +$p(aInputStr,aSeparete,6)
	Set ItemActUserID  	= $p(aInputStr,aSeparete,7)
	
	Set $ZT="UpdateFromEpItemErr"
	TS
	Set ErrorFlg=0
	For i=1:1:$l(Parref,","){
		Set xParref=$p(Parref,",",i)
		Continue:xParref=""
		//For index=1:1:$l(ItemDesc,"&"){
			//Set Desc=$p(ItemDesc,"&",index)
			//Continue:Desc=""
			if (xChildSub'="")&&(xParref=$p(ChildSub,"||",1,2)){
				Set obj=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(xParref_"||"_xChildSub)
				Continue:'$IsObject(obj)
				Set ItemIndNo=obj.ItemIndNo
				Set nChildSub= $p(ChildSub,"||",3)
			}else{
				Set ItemIndNo=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",$p(xParref,"||",1),$p(xParref,"||",2),ItemCatID,""),-1)
				Set nChildSub=""
			}
			Set:(xChildSub="")&&(ItemIndNo'="") ItemIndNo=+ItemIndNo+1
			Set:ItemIndNo="" ItemIndNo=1
			Set aInputStr=xParref_"^"_nChildSub_"^"_ItemDesc_"^"_ItemCatID_"^"_ItemIndNo_"^"_ItemIsOption_"^"_1_"^"_""_"^^"_ItemActUserID_"^^"_ExeDesc
			//Set aInputStr=xParref_"^"_nChildSub_"^"_Desc_"^"_ItemCatID_"^"_ItemIndNo_"^"_ItemIsOption_"^"_1_"^"_""_"^^"_ItemActUserID_"^^"_ExeDesc
			Set return=##class(DHCMA.CPW.BT.PathFormItem).Update(aInputStr,"^")
			if (return<0) {
				Set ErrorFlg=1
				Quit
			}
	}
	if (ErrorFlg=1) {
		tro
	}else {
		If $TLevel>0 TCOMMIT	
	}
	Quit return
	
UpdateFromEpItemErr
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     zqy
/// CreatDate：   2022-9-13
/// Description:  调整顺序号
/// Table：       DHCMA.CPW.BT.PathFormItem
/// Return：      成功：ID，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).TopMove("33||1||5")
ClassMethod TopMove(aEpItemID As %String) As %String
{
	New (aEpItemID)
	Set return=0
	Quit:aEpItemID="" return
	
	Set objFormEPItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aEpItemID)
	Quit:'$IsObject(objFormEPItem) return
	Set ItemIndNo=objFormEPItem.ItemIndNo
	Set ItemCat=objFormEPItem.ItemCatDr.%Id()
	Set Parref=$p(aEpItemID,"||",1)
	Set SubParref=$p(aEpItemID,"||",2)
	Set Sub=$p(aEpItemID,"||",3)
	Set AfterIndNo=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",Parref,SubParref,ItemCat,ItemIndNo),-1)
	Quit:AfterIndNo="" -777
	Set AfterSubID=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",Parref,SubParref,ItemCat,AfterIndNo,""),-1)
	Set AfterID=Parref_"||"_SubParref_"||"_AfterSubID

	Set return=..UpdateEpItemIndNo(AfterID,ItemIndNo)
	Quit:return<0 return
	Set return=..UpdateEpItemIndNo(aEpItemID,AfterIndNo)
	Quit:return<0 return
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-9-13
/// Description:  调整顺序号
/// Table：       DHCMA.CPW.BT.PathFormItem
/// Return：      成功：ID，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).UnderMove("33||1||5")
ClassMethod UnderMove(aEpItemID As %String) As %String
{
	New (aEpItemID)
	Set return=0
	Quit:aEpItemID="" return
	
	Set objFormEPItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aEpItemID)
	Quit:'$IsObject(objFormEPItem) return
	Set ItemIndNo=objFormEPItem.ItemIndNo
	Set ItemCat=objFormEPItem.ItemCatDr.%Id()
	Set Parref=$p(aEpItemID,"||",1)
	Set SubParref=$p(aEpItemID,"||",2)
	Set Sub=$p(aEpItemID,"||",3)
	Set AfterIndNo=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",Parref,SubParref,ItemCat,ItemIndNo))
	Quit:AfterIndNo="" -777
	Set AfterSubID=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",Parref,SubParref,ItemCat,AfterIndNo,""),-1)

	Set AfterID=Parref_"||"_SubParref_"||"_AfterSubID
	Set return=..UpdateEpItemIndNo(AfterID,ItemIndNo)
	Quit:return<0 return
	Set return=..UpdateEpItemIndNo(aEpItemID,AfterIndNo)
	Quit:return<0 return
	Quit return
}

/// Description:  保存顺序号
/// Table：       DHCMA.CPW.BT.PathFormItem
/// Return：      成功：ID，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).UpdateEpItemIndNo(33)
ClassMethod UpdateEpItemIndNo(aEpItemID As %String, ItemIndNo As %String) As %String
{
	New (aEpItemID,ItemIndNo)
	Set return=0
	Quit:(aEpItemID="")||(ItemIndNo="") return
	
	Set objFormEPItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aEpItemID)
	Quit:'$IsObject(objFormEPItem) return
	Set objFormEPItem.ItemIndNo=ItemIndNo
	Set sc=objFormEPItem.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=objFormEPItem.%Id()
	}
	Do objFormEPItem.%Close()

	Quit return
}

/// w ##class(DHCMA.CPW.BTS.PathWebCreateSrv).CopyFormStepAsNew("45^^第三天^第一天^2^0^0^9!!1^45||6")
ClassMethod CopyFormStepAsNew(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	
	Set return=""
	Set EpSubID=..UpdateFromEp(aInputStr,aSeparete)
	Quit:EpSubID<0 -3
	Set PathForm=$p(aInputStr,aSeparete,1)
	Set EpID=PathForm_"||"_EpSubID
	Set EpOldID=$p(aInputStr,aSeparete,9)
	Set:EpOldID["||" EpOldID=$p(EpOldID,"||",2)
	Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(EpID)
	Quit:'$IsObject(objFormEp) -3
	Set $ZT="CopyFormStepAsNew"
	TS
	Set xItemCatDr="",returnFlag="",ErrorFlg=0
	For{
		Set xItemCatDr=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",PathForm,EpOldID,xItemCatDr))
		set:xItemCatDr="" returnFlag=1
		Quit:xItemCatDr=""
		Set xIndNo=""
		For{
			Set xIndNo=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",PathForm,EpOldID,xItemCatDr,xIndNo))
			Quit:xIndNo=""
			Set xID=""
			For{
				Set xID=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",PathForm,EpOldID,xItemCatDr,xIndNo,xID))
				Quit:xID=""
				Set objFormEpItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(PathForm_"||"_EpOldID_"||"_xID)
				Continue:'$IsObject(objFormEpItem)
				Set ItemDesc=objFormEpItem.ItemDesc
				Set ItemCatDr=objFormEpItem.ItemCatDr.%Id()
				Set ItemIndNo=objFormEpItem.ItemIndNo
				Set ItemIsOption=objFormEpItem.ItemIsOption
				Set ItemIsActive=objFormEpItem.ItemIsActive
				Set ItemActUserID=$p(aInputStr,aSeparete,8)
				Set ExeDesc=objFormEpItem.ExeDesc
				Set InputStr=EpID_"^"_""_"^"_ItemDesc_"^"_ItemCatDr_"^"_ItemIndNo_"^"_ItemIsOption_"^"_ItemIsActive_"^"_""_"^^"_ItemActUserID_"^^"_ExeDesc
		
				Set return=##class(DHCMA.CPW.BT.PathFormItem).Update(InputStr,"^")
				if (return<0) {
					Set ErrorFlg=1
					Quit
				}
				
			}
		}
	}
	//Set:returnFlag=1 return="该阶段没有维护项目"
	//if (returnFlag=1) tro
	if (ErrorFlg=1) {
		tro
	}else {
		If $TLevel>0 TCOMMIT	
	}
	Quit return
	
CopyFormStepAsNew
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     zqy
/// CreatDate：   2022-9-8
/// Description:  web创建的路径
/// Table：       DHCMA.CPW.BT.PathWebCreate
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathWebCreateSrv","QryPathItem","75||63","B")
Query QryPathItem(aID As %String = "", aItemCat As %String = "") As %Query(ROWSPEC = "RowID:%String,BTEpItemDesc:%String,BTEpTips:%String,BTItemIsOption:%String,BTItemCat:%String")
{
}

ClassMethod QryPathItemExecute(ByRef qHandle As %Binary, aID As %String = "", aItemCat As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aID="")||(aItemCat="")
 	//当前阶段全部项目
 	if (aItemCat'="B"){
	 	Set:aItemCat="A" ItemCatObj=##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode("A00")
 		Set:aItemCat="C" ItemCatObj=##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode("C00")
 		Set:aItemCat["B" ItemCatObj=##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode(aItemCat)
 		Quit:'$IsObject(ItemCatObj)
 		Set ItemCatID=ItemCatObj.%Id()
	 	Set xIndNo=""
	 	For{
			Set xIndNo=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",$p(aID,"||",1),$p(aID,"||",2),ItemCatID,xIndNo))
			Quit:xIndNo=""
			Set xItemID=""
		 	For{
			 	Set xItemID = $o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",$p(aID,"||",1),$p(aID,"||",2),ItemCatID,xIndNo,xItemID))
				Quit:xItemID=""
				Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aID_"||"_xItemID)
				Continue:'$IsObject(objItem)
				Continue:'$IsObject(objItem.ItemCatDr) 
				Continue:objItem.ItemCatDr.BTCode'[aItemCat
				Set EpItemDesc=objItem.ItemDesc
				Set EpTips=objItem.ExeDesc
				Set ItemIsOption=objItem.ItemIsOption
				Set ItemCat=""
				Set ItemCat=objItem.ItemCatDr.BTCode
				Set:ItemCat["A" ItemCat="A"
				Set:ItemCat["C" ItemCat="C"
				Set Data=$lb(aID_"||"_xItemID,EpItemDesc,EpTips,ItemIsOption,ItemCat)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}else{
			Set ItemCatObj=##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode("B01")
			Set ItemCat2Obj=##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode("B02")
 			Quit:('$IsObject(ItemCatObj))||('$IsObject(ItemCatObj))
 			Set ItemCatID=ItemCatObj.%Id()_"^"_ItemCat2Obj.%Id()
 			For index=1:1:$l(ItemCatID,"^"){
	 			Set xItemCatID=$p(ItemCatID,"^",index)
	 			Continue:xItemCatID=""
	 			Set xIndNo=""
			 	For{
					Set xIndNo=$o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",$p(aID,"||",1),$p(aID,"||",2),xItemCatID,xIndNo))
					Quit:xIndNo=""
					Set xItemID=""
				 	For{
					 	Set xItemID = $o(^DHCMA.CPW.BT.PathFormI("ITM","IdxofCatDrIndNo",$p(aID,"||",1),$p(aID,"||",2),xItemCatID,xIndNo,xItemID))
						Quit:xItemID=""
						Set objItem = ##class(DHCMA.CPW.BT.PathFormItem).GetObjById(aID_"||"_xItemID)
						Continue:'$IsObject(objItem)
						Continue:'$IsObject(objItem.ItemCatDr) 
						Continue:objItem.ItemCatDr.BTCode'[aItemCat
						Set EpItemDesc=objItem.ItemDesc
						Set EpTips=objItem.ExeDesc
						Set ItemIsOption=objItem.ItemIsOption
						Set ItemCat=""
						Set ItemCat=objItem.ItemCatDr.BTCode
						Set:ItemCat["A" ItemCat="A"
						Set:ItemCat["C" ItemCat="C"
						Set Data=$lb(aID_"||"_xItemID,EpItemDesc,EpTips,ItemIsOption,ItemCat)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
	 		}
 	}	
	Quit $$$OK
}

ClassMethod QryPathItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathItemExecute ]
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
