/// 名称: CT.IPMR.FPS.ICDDxSrv
/// 描述: ICD诊断服务方法
/// 创建者：chenPJ
/// 创建日期: 2019-10-21
Class CT.IPMR.FPS.ICDDxSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenPJ
/// CreatDate：   2019-10-22
/// Description:  查询ICDDx字典表
/// Table：       CT.IPMR.FP.ICDDx
/// Input：       aVerID : ID
///               aTypeID ：ICD类型
///               aAlias ：别名
///               aIsActive ：有效标志
/// 			  aICDDxID ：指定某个字典ID
/// Output:       符合条件的ICD字典数据  
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxSrv","QryICDDx","1","159","混合细胞型霍奇金病",1)
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxSrv","QryICDDx","1","","e14.","1","")
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxSrv","QryICDDx","1","","N28.800",1)
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxSrv","QryICDDx","1","","霍乱 埃尔托",1)
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxSrv","QryICDDx","1","","HL，YY",1)
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxSrv","QryICDDx","2","145","角膜","1","")
Query QryICDDx(aVerID As %String, aTypeID As %String, aAlias As %String, aIsActive As %String = "", aICDDxID As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,VerID:%String,VerCode:%String,VerDesc:%String,ICD10:%String,InPairCode:%String,MCode:%String,IsActive:%String,Resume:%String,Alias:%String,MRCDr:%String,ORCDr:%String,OperTypeID:%String,OperTypeDesc:%String,ActDate:%String,EndDate:%String,CatID:%String,CatAlias:%String,CatSubID:%String,CatSubAlias:%String,Count:%Integer,OperLevelID:%String,OperLevelDesc:%String,DetailCataID:%String,DetailCataDesc:%String,IsGroupDRGID:%String,IsGroupDRGDesc:%String,DrgComplicationID:%String,DrgComplicationDesc:%String,IsMedInsuGrayID:%String,IsMedInsuGrayDesc:%String") [ SqlProc ]
{
}

ClassMethod QryICDDxExecute(ByRef qHandle As %Binary, aVerID As %String, aTypeID As %String, aAlias As %String, aIsActive As %String = "", aICDDxID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	//Set ^TMP("QryICDDx") = $lb(aVerID,aTypeID,aAlias,aIsActive,aICDDxID)
 	Quit:(aVerID="") $$$OK
 	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	
 	Set aPageSize = 10000
 	Set Count = 0
 	Set aAlias = $zcvt(aAlias,"U")
 	Set objICDVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(aVerID)
 	Quit:'$IsObject(objICDVer) $$$OK
 	Quit:'$IsObject(objICDVer.FIICDType) $$$OK
 	
 	Set DicTypeCode = objICDVer.FIICDType.BDCode	// 诊断 or 手术
 	
 	Set objType=##class(CT.IPMR.BT.Dictionary).GetObjById(aTypeID)
 	Set ICDTypeCode="",ICDTypeDesc="",ICDDicType=""
	if $IsObject(objType) {
		Set ICDDicType=objType.BDType
		Set ICDTypeCode=objType.BDCode
		Set ICDTypeDesc=objType.BDDesc
	}
	
	// 联合检索，例如 “霍乱 埃尔托” 空格为分隔
	Kill arrAlias
	Set rowIndex=0,aAlias1=""
	For indAlias=1:1:$length(aAlias," ") {
		Set tmpAlias=$p(aAlias," ",indAlias)
		Continue:tmpAlias=""
		Set tmpAlias=$zcvt(tmpAlias,"U")
		
		Set rowIndex=rowIndex+1
		If $l(tmpAlias)>$l(aAlias1) {
			Set:aAlias1'="" arrAlias(rowIndex)=aAlias1
			Set aAlias1=tmpAlias
		} Else {
			Set arrAlias(rowIndex)=tmpAlias
		}
	}
	
	Kill arrICDList
	If aICDDxID'="" {
		Set xID =aICDDxID
		Do BuildDataByAlias
	}else {
		Quit:rowIndex<1 $$$OK
		Quit:aAlias1="" $$$OK //以第一个关键词检索，其他关键词过滤
		
		set checkflg = ##Class(MA.IPMR.SSService.CommonSrv).checkStr1(aAlias1,DicTypeCode)
		if checkflg = 1 { // 以编码作为条件
			//完全匹配 编码
		 	Set xID="" 
		 	For {
			 	Set xID=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",+aVerID," "_$zcvt(aAlias1,"U"),xID))
				Quit:xID=""
		 		Set tmpAlias=""
				Do BuildDataByAlias
			}
			
			//包含关系 编码
		 	set aAlias1=$tr($tr(aAlias1,".",""),"/","")
		 	Set xAlias=" "_$zcvt(aAlias1,"U")  //从头开始匹配，不匹配中间包含
		 	
		 	Set xAlias=$o(^CT.IPMR.FP.ICDDxI("IndexICD10ALP",+aVerID,xAlias),-1)
		 	For {
			 	Set xAlias=$o(^CT.IPMR.FP.ICDDxI("IndexICD10ALP",+aVerID,xAlias))
			 	Quit:xAlias=""
			 	Quit:(aPageSize>0)&&(Count>aPageSize)
			 	Continue:xAlias'[$zcvt(aAlias1,"U")
			 	Quit:$e(xAlias,2,$l(aAlias1)+1)'=$zcvt(aAlias1,"U")
			 	
			 	Set xID=0
				For {
			 		Set xID=$o(^CT.IPMR.FP.ICDDxI("IndexICD10ALP",+aVerID,xAlias,xID))
			 		Quit:xID=""
			 		Set tmpAlias=""
		 			Do BuildDataByAlias
				}
		 	}
		 	
			//包含关系 别名
		 	Set xAlias=""
		 	For {
			 	Set xAlias=$o(^CT.IPMR.FP.ICDDxI("Alias","IndexAlias",+aVerID,xAlias))
			 	Quit:xAlias=""
			 	Quit:(aPageSize>0)&&(Count>aPageSize)
			 	Continue:(xAlias=(" "_$zcvt(aAlias1,"U")))
			 	Continue:xAlias'[$zcvt(aAlias1,"U")
			 	Quit:$e(xAlias,2,$l(aAlias1)+1)'=$zcvt(aAlias1,"U")   // 别名也从头匹配
	
			 	Set xID=0
				For {
			 		Set xID=$o(^CT.IPMR.FP.ICDDxI("Alias","IndexAlias",+aVerID,xAlias,xID))
			 		Quit:xID=""
			 		Set tmpAlias=xAlias
		 			Do BuildDataByAlias
				}
		 	}
		}else{
			//完全匹配名称
		 	Set xID=0
			For {
				
		 		Set xID=$o(^CT.IPMR.FP.ICDDxI("IndexDesc",+aVerID," "_$zcvt(aAlias1,"U"),xID))
		 		Quit:xID=""
		 		Set tmpAlias=""
				Do BuildDataByAlias
			}
			
			//完全匹配别名
		 	Set xID=0
			For {
		 		Set xID=$o(^CT.IPMR.FP.ICDDxI("Alias","IndexAlias",+aVerID," "_$zcvt(aAlias1,"U"),xID))
		 		Quit:xID=""
		 		Set tmpAlias=$zcvt(aAlias1,"U")
				Do BuildDataByAlias
			}
			//包含关系 名称
		 	Set xAlias=""
		 	For {
			 	Set xAlias=$o(^CT.IPMR.FP.ICDDxI("IndexDesc",+aVerID,xAlias))
			 	Quit:xAlias=""
			 	Quit:(aPageSize>0)&&(Count>aPageSize)
			 	Continue:(xAlias=(" "_$zcvt(aAlias1,"U")))
			 	Continue:xAlias'[$zcvt(aAlias1,"U")
			 	
			 	Set xID=0
				For {
			 		Set xID=$o(^CT.IPMR.FP.ICDDxI("IndexDesc",+aVerID,xAlias,xID))
			 		Quit:xID=""
			 		Set tmpAlias=""
		 			Do BuildDataByAlias
				}
		 	}
			//包含关系 别名
		 	Set xAlias=""
		 	For {
			 	Set xAlias=$o(^CT.IPMR.FP.ICDDxI("Alias","IndexAlias",+aVerID,xAlias))
			 	Quit:xAlias=""
			 	Quit:(aPageSize>0)&&(Count>aPageSize)
			 	Continue:(xAlias=(" "_$zcvt(aAlias1,"U")))
			 	Continue:xAlias'[$zcvt(aAlias1,"U")
			 	
			 	Set xID=0
				For {
			 		Set xID=$o(^CT.IPMR.FP.ICDDxI("Alias","IndexAlias",+aVerID,xAlias,xID))
			 		Quit:xID=""
			 		Set tmpAlias=xAlias
		 			Do BuildDataByAlias
				}
		 	}
		}
	}
 	//输出结果
 	Set xICD10=""
 	For {
		Set xICD10=$o(arrICDList(xICD10))
		Quit:xICD10=""
		Set xDesc = ""
		For {
			Set xDesc = $o(arrICDList(xICD10,xDesc))
			Quit:xDesc=""
			Set Data=$g(arrICDList(xICD10,xDesc))
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	Kill arrICDList
	Quit $$$OK
 	
BuildDataByAlias
	Set obj=##class(CT.IPMR.FP.ICDDx).GetObjById(xID)
	Quit:'$IsObject(obj)
	Quit:'$IsObject(obj.FIICDVerDr)
	Quit:obj.FIICDVerDr.%Id()'=aVerID
	Quit:(aIsActive'="")&&(aIsActive'=obj.FIIsActive)

	Set ID			= xID
	Set Code		= obj.FICode
	Set Desc		= obj.FIDesc
	Set ICD10		= obj.FIICD10
	Set InPairCode	= obj.FIICDinPair
	Set MCode		= obj.FIMCode
	Set IsActive	= obj.FIIsActive
	Set Resume		= obj.FIResume
	Set MRCDr		= obj.FIMRCDr
	Set ORCDr		= obj.FIORCDr
	Set ActDate		= obj.FIActDate
	Set ActDate=##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(ActDate)
	Set EndDate		= obj.FIEndDate
	Set EndDate=##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(EndDate)
	Set objOperType	= obj.FIOperTypeDr
	Set (OperTypeID,OperTypeDesc)=""
	If $isobject(objOperType) {
		Set OperTypeID	= objOperType.%Id()
		Set OperTypeDesc= objOperType.BDDesc
	}
	Set objCat	= obj.FICatDr
	Set objCatSub	= obj.FICatSubDr
	Set (CatID,CatAlias)=""
	If $isobject(objCat) {
		Set CatID	= objCat.%Id()
		Set CatAlias= objCat.FIICDAlias
	}
	Set (CatSubID,CatSubAlias)=""
	If $isobject(objCatSub) {
		Set CatSubID	= objCatSub.%Id()
		Set CatSubAlias = objCatSub.FIICDAlias
	}
	Set objOperLevel	= obj.FIOperLevelDr
	Set (OperLevelID,OperLevelDesc)=""
	If $isobject(objOperLevel) {
		Set OperLevelID	= objOperLevel.%Id()
		Set OperLevelDesc= objOperLevel.BDDesc
	}
	// 细目
	Set objDetailCata	= obj.FIDetailCataDr
	Set (DetailCataID,DetailCataDesc)=""
	If $isobject(objDetailCata) {
		Set DetailCataID	= objDetailCata.%Id()
		Set DetailCataDesc  = objDetailCata.FIICDAlias
	}
	// 诊断是否入组Drg
	Set objIsGroupDRG	= obj.FIIsGroupDRGDr
	Set (IsGroupDRGID,IsGroupDRGDesc)=""
	If $isobject(objIsGroupDRG) {
		Set IsGroupDRGID	= objIsGroupDRG.%Id()
		Set IsGroupDRGDesc  = objIsGroupDRG.BDDesc
	}
	// 诊断并发症或合并症
	Set objDrgComplication	= obj.FIDrgComplicationDr
	Set (DrgComplicationID,DrgComplicationDesc)=""
	If $isobject(objDrgComplication) {
		Set DrgComplicationID	= objDrgComplication.%Id()
		Set DrgComplicationDesc = objDrgComplication.BDDesc
	}
	// 医保灰码
	Set objIsMedInsuGray = obj.FIIsMedInsuGray
	Set (IsMedInsuGrayID,IsMedInsuGrayDesc) = ""
	If ($IsObject(objIsMedInsuGray)) {
		Set IsMedInsuGrayID = objIsMedInsuGray.%Id()
		Set IsMedInsuGrayDesc = objIsMedInsuGray.BDDesc
	}
	
	Set VerID		= objICDVer.%Id()
	Set VerCode		= objICDVer.FICode
	Set VerDesc		= objICDVer.FIEdition.BDDesc_" "_objICDVer.FIICDType.BDDesc_" "_objICDVer.FIVersion
	Quit:ICD10=""
	Quit:$d(arrICDList(ICD10,Desc)) // 已经存在，不再重复加载

	//多个关键词检索
	If $o(arrAlias(0))'="" {
		If tmpAlias'="" {
			Set IsSuccess=1
			Set strICDInfo=Desc_" "_ICD10_" "_tmpAlias
			Set rowIndex=1
			For {
				Set rowIndex=$o(arrAlias(rowIndex))
				Quit:rowIndex=""
				Set strAlias=$g(arrAlias(rowIndex))
				Continue:strICDInfo[strAlias
				Set IsSuccess=0
			}
		} Else {
			Set IsSuccess=0
			Set xAliasID=""
			For {
				Set xAliasID=$o(^CT.IPMR.FP.ICDDxD(ID,"Alias",xAliasID))	
				Quit:xAliasID=""
				
				Set IsSuccess11=1
				Set xAliasDesc=$lg($g(^CT.IPMR.FP.ICDDxD(ID,"Alias",xAliasID)),2)
				Set strICDInfo=Desc_" "_ICD10_" "_xAliasDesc
				Set rowIndex=1
				For {
					Set rowIndex=$o(arrAlias(rowIndex))
					Quit:rowIndex=""
					Continue:strICDInfo[$g(arrAlias(rowIndex))
					Set IsSuccess11=0
				}
				Continue:IsSuccess11=0
				Set IsSuccess=1
			}
		}
		Quit:IsSuccess=0
	}
	// 西医诊断控制
	If ICDDicType="DiagType" {
		Set ZYM="ABCDEFGHIJKLMNOPQRSTUVWXYZ"	//中医码(前两位都是字母)
		Quit:(ZYM[$e(ICD10,1,1))&&(ZYM[$e(ICD10,2,2))
		
		Set IsTumorCode=0,IsInjuryCode=0
		If ($e(ICD10,1,1)="M")&&(ICD10["/") {	//肿瘤码检查（例子：M800000/0）
			Set IsTumorCode=1
		} Else {
			Set ICDHead=$e(ICD10,1,1)
			If (ICDHead="V")||(ICDHead="W")||(ICDHead="X")||(ICDHead="Y"){  //损伤中毒码检查（例子： V01.191）
				Set IsInjuryCode=1
			}
		}
		
		If (ICDTypeCode=1)||(ICDTypeCode=2)||(ICDTypeCode=3)||(ICDTypeCode=4)||(ICDTypeCode=6)||(ICDTypeCode=8) {  //门急诊诊断、入院诊断、主要诊断、次要诊断、医院感染诊断、附加次要诊断
			Quit:IsTumorCode=1
			Quit:IsInjuryCode=1
		} ElseIf (ICDTypeCode=7)||(ICDTypeCode=9) {  //病理诊断、附加病理诊断
			Quit:IsTumorCode'=1
		} ElseIf (ICDTypeCode=5) {  //损伤中毒
			Quit:IsInjuryCode'=1
		} Else {  //诊断类型错误
			Quit
		}
	}elseif ICDDicType="CMDiagType" {
		Set ZYM="ABCDEFGHIJKLMNOPQRSTUVWXYZ"	//中医码(前两位都是字母)
		Set IsCMCode=0
		// 新的中医码
		iF $LENGTH(ICD10) = 6 {	//a17.42
			Set IsCMCode=1
		}elseIF $LENGTH(ICD10) = 4 {	//A01.
			Set IsCMCode=1
		}else{
			if $length(ICD10,".")>2 {
				set charcount=0
				for i=1:1:$length(ICD10) {
					set c = $e(ICD10,i,i)
					set ascii = $ASCII(c)
					if (ascii>=65)&&(ascii<=90) {	// A-Z
						set charcount = charcount+1
					}
				}
				set:charcount=1 IsCMCode=1
			}
		}
		/*
		If (ZYM[$e(ICD10,1,1))&&(ZYM[$e(ICD10,2,2)){
			Set IsCMCode=1
		}
		*/
		Set IsTumorCode=0,IsInjuryCode=0
		If ($e(ICD10,1,1)="M")&&(ICD10["/") {	//肿瘤码检查（例子：M800000/0）
			Set IsTumorCode=1
		} Else {
			Set ICDHead=$e(ICD10,1,1)
			If (ICDHead="V")||(ICDHead="W")||(ICDHead="X")||(ICDHead="Y"){  //损伤中毒码检查（例子： V01.191）
				Set IsInjuryCode=1
			}
		}
		
		If (ICDTypeCode=1)||(ICDTypeCode=2)||(ICDTypeCode=3)||(ICDTypeCode=4)||(ICDTypeCode=6)||(ICDTypeCode=8) {  //门急诊诊断、入院诊断、主要诊断、次要诊断、医院感染诊断、附加次要诊断
			Quit:IsTumorCode=1
			Quit:IsInjuryCode=1
		} ElseIf (ICDTypeCode=7)||(ICDTypeCode=9) {  //病理诊断、附加病理诊断
			Quit:IsTumorCode'=1
		} ElseIf (ICDTypeCode=5) {  //损伤中毒
			Quit:IsInjuryCode'=1
		}ElseIf (ICDTypeCode=10)||(ICDTypeCode=11)||(ICDTypeCode=12)||(ICDTypeCode=13)||(ICDTypeCode=14) {  // 中医诊断类型
			Quit:IsCMCode'=1
		} Else {  //诊断类型错误
			Quit
		}
	}elseif ICDDicType="OperType" {
		Quit:(aTypeID'="")&&(aTypeID'=OperTypeID)
	}
	// 关键字
	Set Alias = ""
	Set xSubId = ""
	For {
		Set xSubId = $o(^CT.IPMR.FP.ICDDxD(xID,"Alias",xSubId))
		Quit:xSubId=""
		Set objSub = ##class(CT.IPMR.FP.ICDAlias).GetObjById(xID_"||"_xSubId)
		Continue:'$IsObject(objSub)
		
		Set Alias = Alias_","_objSub.FIAlias
	}
	Set:Alias'="" Alias=$e(Alias,2,$L(Alias))
	Quit:$g(arrICDList(ICD10,Desc))'=""
	
	Set Count = Count+1
	set:Desc'="" Desc=##class(CT.IPMR.FP.ICDDx).GetTranByDesc("FIDesc",Desc,langid)
	Set:OperTypeDesc'="" OperTypeDesc=##class(CT.IPMR.BT.Dictionary).GetTranByDesc("BDDesc",OperTypeDesc,langid)
 	Set arrICDList(ICD10,Desc)=$LB(ID,Code,Desc,VerID,VerCode,VerDesc,ICD10,InPairCode,MCode,IsActive,Resume,Alias,MRCDr,ORCDr,OperTypeID,OperTypeDesc,ActDate,EndDate,CatID,CatAlias,CatSubID,CatSubAlias,Count,OperLevelID,OperLevelDesc,DetailCataID,DetailCataDesc,IsGroupDRGID,IsGroupDRGDesc,DrgComplicationID,DrgComplicationDesc,IsMedInsuGrayID,IsMedInsuGrayDesc)
 	Quit
}

ClassMethod QryICDDxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDDxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDDxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDDxExecute ]
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

/// Creator：     chenPJ
/// CreatDate：   2019-10-22
/// Description:  查询ICD字典别名表
/// Table：       CT.IPMR.FP.ICDDxAlias
/// Input：       aICDDxID：ICDDx字典ICD
/// output:       符合条件的别名数据  
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxSrv","QryICDDxAlias","2")
Query QryICDDxAlias(aICDDxID As %String) As %Query(ROWSPEC = "ID:%String,ICDDxAlias:%String,ICDVer:%String") [ SqlProc ]
{
}

ClassMethod QryICDDxAliasExecute(ByRef qHandle As %Binary, aICDDxID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aICDDxID="" $$$OK
 	
	Set xSubId = ""
	For {
		Set xSubId = $o(^CT.IPMR.FP.ICDDxD(aICDDxID,"Alias",xSubId))
		Quit:xSubId=""
		
		Set AliasID = aICDDxID_"||"_xSubId
		Set objSub = ##class(CT.IPMR.FP.ICDAlias).GetObjById(AliasID)
		Continue:'$IsObject(objSub)
		Set ICDAlias = objSub.FIAlias
		Set ICDVer	 = objSub.FIICDVerDr.%Id()
		
		Set Data = $LB(AliasID,ICDAlias,ICDVer)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryICDDxAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDDxAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDDxAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDDxAliasExecute ]
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

/// Creator : chenPJ
/// CreateDate : 2019-10-24
/// Description: 同步HIS诊断到病案编码库
/// Input  : aVerCode : 版本代码
/// Output : 1 成功 0 失败 
/// w ##Class(CT.IPMR.FPS.ICDDxSrv).SynHISMRCLIB("CM2020")
ClassMethod SynHISMRCLIB(aVerCode As %String) As %String
{
	New (aVerCode)
	Set return = ""
	Quit:aVerCode="" return
	
	Set ICDVerID = $o(^CT.IPMR.FP.ICDVerI("IndexCode"," "_$zcvt(aVerCode,"U"),0))
	Set objVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(ICDVerID)
	Quit:'$isobject(objVer) return
	Quit:'$isobject(objVer.FIEdition) return
	Quit:'$isobject(objVer.FIICDType) return
	Quit:objVer.FIICDType.BDCode'="D"	// 只同步诊断
	// pro : 增加备份机制 
	Set TimeStamp = $tr($tr($SYSTEM.SYS.TimeStamp(),",",""),".","")
	set str1 = "M ^CT.IPMR.FP.ICDDxD"_TimeStamp_" = ^CT.IPMR.FP.ICDDxD"
	set str2 = "M ^CT.IPMR.FP.ICDDxI"_TimeStamp_" = ^CT.IPMR.FP.ICDDxI"
	w "^CT.IPMR.FP.ICDDxD"_TimeStamp,!
	w "^CT.IPMR.FP.ICDDxI"_TimeStamp,!
	x str1
	x str2
	Set xID=0,Count=0
	For {
		Set xID=$o(^MRC("ID",xID))
		Quit:xID=""
		
		Write:(Count#1000)=0 "同步HIS诊断库：已处理 "_Count_" 条!",!
		
		Set Code =$p($g(^MRC("ID",xID)),"^",1)
		Set Desc =$p($g(^MRC("ID",xID)),"^",2)
		Set ICD10=$p($g(^MRC("ID",xID)),"^",4)
		Set ICDinPair = $p($g(^MRC("ID",xID)),"^",43)	//副码
		Set IsActive=1
		Set:ICD10="" IsActive=0
		Set DateFrom=$p($g(^MRC("ID",xID)),"^",6)
		Set DateTo=$p($g(^MRC("ID",xID)),"^",7)
		
		Set MRCIDBillFlag3=$p($g(^MRC("ID",xID)),"^",15)	// 中医诊断标志
		Set MRCIDBillFlag1=$p($g(^MRC("ID",xID)),"^",13)	// 中医证型标志
		
		if objVer.FIEdition.BDCode=4 {	//中医
			Continue:'((MRCIDBillFlag3="Y")||(MRCIDBillFlag1="Y"))
		}else{	// 非中医
			Continue:(MRCIDBillFlag3="Y")||(MRCIDBillFlag1="Y")
		}
		
		If DateFrom'="" {
			Set:DateFrom>(+$h) IsActive=0
		}
		If DateTo'="" {
			Set:DateTo<(+$h) IsActive=0
		}
		// 病案系统 版本ID+主码+名称唯一索引
		Set ID=$o(^CT.IPMR.FP.ICDDxI("IndexVerICD",ICDVerID," "_$zcvt(ICD10,"U")," "_$zcvt(Desc,"U"),0))
		Set InputStr=ID  					//ID取值
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_aVerCode
		Set InputStr=InputStr_"^"_ICD10
		Set InputStr=InputStr_"^"_ICDinPair
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""  		//OperType
		Set InputStr=InputStr_"^"_xID 		//诊断库指针
		Set InputStr=InputStr_"^"_""  		//手术库指针
		Set InputStr=InputStr_"^"_DateFrom  //启用日期
		Set InputStr=InputStr_"^"_DateTo   	//停用日期
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_""
		
		Set LogInfo = "^^批量同步HIS诊断字典表"
		Set flg = ##class(CT.IPMR.FPS.ICDDxSrv).ImportICD(InputStr,"",LogInfo,"^")
		
		Continue:flg<0
		
		Set Count=Count+1
		Set ID=flg
		
		//同步诊断别名
		Set ICDVerID = $o(^CT.IPMR.FP.ICDVerI("IndexCode"," "_$zcvt(aVerCode,"U"),0))
		
		Set xSub=0
		For {
			Set xSub=$o(^MRC("ID",xID,"ALIAS",xSub))
			Quit:xSub=""
			
			Set InputStr=ID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_ICDVerID
			Set InputStr=InputStr_"^"_$g(^MRC("ID",xID,"ALIAS",xSub))
			Set flg=##class(CT.IPMR.FP.ICDAlias).Update(InputStr,"^")
		}
	}
	
	Set return = Count
	Quit return
}

/// Creator : chenPJ
/// CreateDate : 2019-10-24
/// Description: 同步HIS手术到新库里
/// Input  : aVerCode 
/// Output : 1 成功 0 失败 
/// w ##Class(CT.IPMR.FPS.ICDDxSrv).SynHISOperLIB("ICD9V20C")
ClassMethod SynHISOperLIB(aVerCode As %String) As %String
{
	New (aVerCode)
	Set return = ""
	Quit:aVerCode="" return
	Set ICDVerID = $o(^CT.IPMR.FP.ICDVerI("IndexCode"," "_$zcvt(aVerCode,"U"),0))
	Set objVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(ICDVerID)
	Quit:'$isobject(objVer) return
	Quit:'$isobject(objVer.FIEdition) return
	Quit:'$isobject(objVer.FIICDType) return
	Quit:objVer.FIICDType.BDCode'="O"	// 只同步手术
	// pro : 增加备份机制 
	Set TimeStamp = $tr($tr($SYSTEM.SYS.TimeStamp(),",",""),".","")
	set str1 = "M ^CT.IPMR.FP.ICDDxD"_TimeStamp_" = ^CT.IPMR.FP.ICDDxD"
	set str2 = "M ^CT.IPMR.FP.ICDDxI"_TimeStamp_" = ^CT.IPMR.FP.ICDDxI"
	w "^CT.IPMR.FP.ICDDxD"_TimeStamp,!
	w "^CT.IPMR.FP.ICDDxI"_TimeStamp,!
	x str1
	x str2
	Set xID = 0,Count = 0
	For {
		Set xID = $o(^ORC("OPER",xID))
		Quit:xID=""
		
		Set Count = Count+1
		Write:(Count#1000)=0 "同步HIS手术库：已处理 "_Count_" 条!",!
		
		Set Code = $p($g(^ORC("OPER",xID)),"^",1)
		Set Desc = $p($g(^ORC("OPER",xID)),"^",2)
		Set ICD10 = $p($g(^ORC("OPER",xID)),"^",14)
		Set ICDinPair = ""
		Set IsActive = 1
		Set:ICD10="" IsActive = 0
		Set DateFrom = $p($g(^ORC("OPER",xID)),"^",5)
		Set DateTo = $p($g(^ORC("OPER",xID)),"^",6)
		If DateFrom '= "" {
			Set:DateFrom>(+$h) IsActive = 0
		}
		If DateTo'="" {
			Set:DateTo<(+$h) IsActive = 0
		}
		
		Set OperType = ""
		Set HISOperType = $p($g(^ORC("OPER",xID,"DHC")),"^",11)
		Set:(HISOperType = "")||(HISOperType = "N") OperType = "手术"
		Set:(HISOperType = "T") OperType = "治疗性操作"
		Set:(HISOperType = "D") OperType = "诊断性操作"
		Set:(HISOperType = "I") OperType = "介入治疗"
		
		Set OperLevel = ""
		Set HISOperLevelID = $p($g(^ORC("OPER",xID,"DHC")),"^",1)
		if HISOperLevelID'="" {
			Set HISOperLevel = $p($g(^ORC("CATEG",HISOperLevelID)),"^",2)
			Set:(HISOperLevel [ "一级") OperLevel = "一级手术"
			Set:(HISOperLevel [ "二级") OperLevel = "二级手术"
			Set:(HISOperLevel [ "三级") OperLevel = "三级手术"
			Set:(HISOperLevel [ "四级") OperLevel = "四级手术"
		}
		// 病案系统 版本ID+主码+名称唯一索引
		Set ID=$o(^CT.IPMR.FP.ICDDxI("IndexVerICD",ICDVerID," "_$zcvt(ICD10,"U")," "_$zcvt(Desc,"U"),0))
		Set InputStr=ID  					//ID取值
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_aVerCode
		Set InputStr=InputStr_"^"_ICD10
		Set InputStr=InputStr_"^"_ICDinPair
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_OperType
		Set InputStr=InputStr_"^"_"" 		//诊断库指针
		Set InputStr=InputStr_"^"_xID  		//手术库指针
		Set InputStr=InputStr_"^"_DateFrom  //启用日期
		Set InputStr=InputStr_"^"_DateTo   	//停用日期
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_OperLevel
		
		Set LogInfo = "^^批量同步HIS手术字典表"
		Set flg = ##class(CT.IPMR.FPS.ICDDxSrv).ImportICD(InputStr,"",LogInfo,"^")
		Continue:flg<0
		
		Set ID=flg
		//同步别名
		Set ICDVerID = $o(^CT.IPMR.FP.ICDVerI("IndexCode"," "_$zcvt(aVerCode,"U"),0))
		
		Set xSub=0
		For {
			Set xSub=$o(^ORC("OPER",xID,"ALIAS",xSub))
			Quit:xSub=""
			
			Set InputStr=ID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_ICDVerID
			Set InputStr=InputStr_"^"_$g(^ORC("OPER",xID,"ALIAS",xSub))
			
			Set flg=##class(CT.IPMR.FP.ICDAlias).Update(InputStr,"^")
		}
	}
	
	Set return = Count
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2020-02-22
/// Description:  后台导入icd
/// Table：       CT.IPMR.FP.ICDDx
/// Input：       aInputStr ：ICD字典数据
///               aPYAlias : 拼音别名
///               aLogInfo : 日志信息
///               aSeparate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FPS.ICDDxSrv).ImportICD("2^A00.101^埃尔托生物型霍乱^ICD10V60^A00.101^^^^^^2020-02-27^^1^^^","","^11865^","^")
ClassMethod ImportICD(aInputStr As %String, aPYAlias As %String, aLogInfo As %String = "", aSeparate As %String = "") As %String
{
	New (aInputStr,aPYAlias,aLogInfo,aSeparate)
	Set return = 0
	//Set ^TMP("ImportICD")=$lb(aInputStr,aPYAlias,aLogInfo,aSeparate)
	Set ICDVerCode = $p(aInputStr,"^",4)
	Set ICDVerID = $o(^CT.IPMR.FP.ICDVerI("IndexCode"," "_$zcvt(ICDVerCode,"U"),0))
	Quit:ICDVerID="" return
	
	Set $p(aInputStr,"^",4) = ICDVerID
	Set OperTypeDesc = $p(aInputStr,"^",8)
	Set objOperTypeDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("OperType",OperTypeDesc)
	Set OperTypeID = ""
	If $Isobject(objOperTypeDic){
		Set OperTypeID = objOperTypeDic.%Id()
	}
	Set $p(aInputStr,"^",8) = OperTypeID
	
	Set OperLevelDesc = $p(aInputStr,"^",17)
	Set objOperLevelDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("OperationRank",OperLevelDesc)
	Set OperLevelID = ""
	If $Isobject(objOperLevelDic){
		Set OperLevelID = objOperLevelDic.%Id()
	}
	Set $p(aInputStr,"^",17) = OperLevelID
	
	Set ICD10 = $p(aInputStr,"^",5)
	Set ICDinPair = $p(aInputStr,"^",6)
	Set objICDVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(ICDVerID)
	Quit:'$IsObject(objICDVer) return 
	Quit:'$IsObject(objICDVer.FIICDType) return 
	
	Set CatInfo =  ##class(CT.IPMR.FPS.ICDDxSrv).getICDCat(ICD10,objICDVer.FIICDType.BDCode)
	Set $p(aInputStr,"^",15) = $p($p(CatInfo,"^",1),"|",1) 
	Set $p(aInputStr,"^",16) = $p($p(CatInfo,"^",2),"|",1) 
	Set $p(aInputStr,"^",18) = $p($p(CatInfo,"^",3),"|",1) 
	// 是否入组Drg
	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("ICDIsGroupDRG",$p(aInputStr,"^",19))
	Set IsGroupDRGID = ""
	If $Isobject(objDic){
		Set IsGroupDRGID = objDic.%Id()
	}
	Set $p(aInputStr,"^",19) = IsGroupDRGID
	// 诊断并发症或合并症
	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("DrgComplication",$p(aInputStr,"^",20))
	Set DrgComplicationID = ""
	If $Isobject(objDic){
		Set DrgComplicationID = objDic.%Id()
	}
	Set $p(aInputStr,"^",20) = DrgComplicationID
	
	
	// 医保灰码
	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("ICDIsMedInsuGray",$p(aInputStr,"^",21))
	Set ICDIsMedInsuGrayID = ""
	If $Isobject(objDic){
		Set ICDIsMedInsuGrayID = objDic.%Id()
	}
	Set $p(aInputStr,"^",21) = ICDIsMedInsuGrayID
	
	Set return = ..SaveICD(aInputStr,aPYAlias,aLogInfo,aSeparate)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2020-02-22
/// Description:  保存icd字典
/// Table：       CT.IPMR.FP.ICDDx
/// Input：       aInputStr ：ICD字典数据
///               aPYAlias : 拼音别名
///               aLogInfo : 日志信息
///               aSeparate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FPS.ICDDxSrv).SaveICD("5256^A01.01.^外感时令类病12^12^A01.01.^^^^^^2022-11-08^^1^^^^^^^","","127.0.0.1^1732^","^")
ClassMethod SaveICD(aInputStr As %String, aPYAlias As %String, aLogInfo As %String, aSeparate As %String)
{
	New (aInputStr,aPYAlias,aLogInfo,aSeparate)
	//Set ^TMP("SaveICD")=$lb(aInputStr,aPYAlias,aLogInfo,aSeparate)
	Tstart
	Set VerID = $p(aInputStr,"^",4)
	Set ICD10  = $p(aInputStr,"^",5)
	Set Desc  = $p(aInputStr,"^",3)

	Set ID = $p(aInputStr,"^",1)  //$o(^CT.IPMR.FP.ICDDxI("IndexVerICD",VerID," "_$zcvt(ICD10,"U")," "_$zcvt(Desc,"U"),0))
	Set oldData = ""
	if ID'="" {
		Set oldData = $g(^CT.IPMR.FP.ICDDxD(ID))
		Set oldData = ##class(%Library.List).LogicalToOdbc(oldData)
	}
	
	// 保存icd
	Set ID = ##class(CT.IPMR.FP.ICDDx).Update(aInputStr,aSeparate)
	if ID<1 {
		trollback
		Quit -100
	}
	// 保存别名
	if aPYAlias '="" {
		Set aInputAlias = ID_"^"_""_"^"_VerID_"^"_aPYAlias
		Set ret = ##class(CT.IPMR.FP.ICDAlias).Update(aInputAlias,"^")
		if (+ret)<1 {
			trollback
			Quit -200
		}
	}
	// 保存描述拼音别名
	Set PYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
	if PYCode'="" {
		Set aInputAlias = ID_"^"_""_"^"_VerID_"^"_PYCode
		Set ret = ##class(CT.IPMR.FP.ICDAlias).Update(aInputAlias,"^")
		if (+ret)<1 {
			trollback
			Quit -200
		}
	}
	// 保存日志
	Set newData = $g(^CT.IPMR.FP.ICDDxD(ID))
	Set newData = ##class(%Library.List).LogicalToOdbc(newData)
	If oldData'="" {
		if oldData=newData{
			Set return = ID
			trollback
			Quit return 
		}else{
			Set OperType="M"
		}
	}else {
		Set OperType = "A"
	}
	Set aInputStr = ID
	Set aInputStr = aInputStr_"^"_OperType
	Set aInputStr = aInputStr_"^"_oldData
	Set aInputStr = aInputStr_"^"_newData
	Set aInputStr = aInputStr_"^"_aLogInfo
	Set ret = ##class(CT.IPMR.FP.ICDDxLog).Update(aInputStr,"^")
	if (+ret)<1 {
		trollback
		Quit -300
	}
	tcommit
	Set return = ID
	Quit return
}

/// w ##class(CT.IPMR.FPS.ICDDxSrv).AutoCat()
ClassMethod AutoCat()
{
	For xID = "" 
	for {
		Set xID = $o(^CT.IPMR.FP.ICDDxD(xID))
		Quit:xID=""
		Set objICD = ##class(CT.IPMR.FP.ICDDx).GetObjById(xID)
		Continue:'$IsObject(objICD) 
		Set objICDVer=objICD.FIICDVerDr
		Continue:'$IsObject(objICDVer) 
		Continue:'$IsObject(objICDVer.FIICDType)
		
		Set ICD10 = objICD.FIICD10
		Set ICDinPair = objICD.FIICDinPair
		Set (CatID,CatSubID)=""
		if CatID="" {
			Set xICDAlias= ""
			For {
				Set xICDAlias = $o(^CT.IPMR.FP.ICDCatI("IndexICDAlias",objICDVer.FIICDType.%Id(),xICDAlias))
				Quit:xICDAlias=""
				Quit:CatID'=""
				Set ICDAlias=$e(xICDAlias,2,$length(xICDAlias))
				Set ICDAlias=$e(ICDAlias,1,3)
				Set flg = ##class(MA.IPMR.SSService.CommonSrv).ICDCheck(ICD10,ICDAlias)
				Continue:flg=0
				Set CatID=$o(^CT.IPMR.FP.ICDCatI("IndexICDAlias",objICDVer.FIICDType.%Id(),xICDAlias,""))
			}
		}
		if CatSubID=""{
			Set xICDAlias= ""
			For {
				Set xICDAlias = $o(^CT.IPMR.FP.ICDCatSubI("IndexICDAlias",objICDVer.FIICDType.%Id(),xICDAlias))
				Quit:xICDAlias=""
				Quit:CatSubID'=""
				Set ICDAlias=$e(xICDAlias,2,$length(xICDAlias))
				Set ICDAlias=$e(ICDAlias,1,5)
				Set flg = ##class(MA.IPMR.SSService.CommonSrv).ICDCheck(ICD10,ICDAlias)
				Continue:flg=0
				Set CatSubID=$o(^CT.IPMR.FP.ICDCatSubI("IndexICDAlias",objICDVer.FIICDType.%Id(),xICDAlias,""))
			}
		}
		Set obj=##class(CT.IPMR.FP.ICDDx).%OpenId(xID)
		Set obj.FICatDr   = ##class(CT.IPMR.FP.ICDCat).GetObjById(CatID)
		Set obj.FICatSubDr   = ##class(CT.IPMR.FP.ICDCatSub).GetObjById(CatSubID)
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}Else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
	}
	Quit 1
}

// w ##class(CT.IPMR.FPS.ICDDxSrv).CheckICD(1,"A00.904","霍乱重型")

ClassMethod CheckICD(aICDVer As %String, aICD10 As %String, aICDDesc As %String)
{
	New (aICDVer,aICD10,aICDDesc,%session)
	Set return = 0	
	Quit:(aICDVer="")||(aICD10="")||(aICDDesc="") return
	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Set aICDDesc = $$ALPHAUP^SSUTIL4(aICDDesc)
	Set aICDDesc = $tr(aICDDesc,",","")
	Set aICDDesc = $tr(aICDDesc,"，","")
	Set xID=0
	For {
		Set xID=$o(^CT.IPMR.FP.ICDDxI("IndexICD10",aICDVer," "_$zcvt(aICD10,"U"),xID))
		Quit:xID=""
		
		Set obj=##class(CT.IPMR.FP.ICDDx).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set ICDDesc  = obj.FIDesc
		Set ICDDesc = $$ALPHAUP^SSUTIL4(ICDDesc)
		Set ICDDesc = $tr(ICDDesc,",","")
		Set ICDDesc = $tr(ICDDesc,"，","")
		Set ICDDesc = ##class(CT.IPMR.FP.ICDDx).GetTranByDesc("FIDesc",ICDDesc,langid)
		Continue:$$ALPHAUP^SSUTIL4(ICDDesc)'=aICDDesc
		Set return=1
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2022-07-25
/// Description:  组织单行页面导入数据
/// Input：       Row : 单行数据
/// Output:       数据list
ClassMethod buildInputData(Row)
{
	New (Row)
	Set Code=Row.%Get("代码")
	Set ICD10=Row.%Get("主码")
	Set Desc=Row.%Get("名称")
	Set inPair=Row.%Get("副码")
	Set ActDate=Row.%Get("启用日期")
	Set EndDate=Row.%Get("停用日期")
	Set IsActive=Row.%Get("是否有效")
	Set Resume=Row.%Get("备注")
	Set Alias=Row.%Get("别名")
	Set GroupDRG=Row.%Get("是否入组")
	Set Complication=Row.%Get("合并症与并发症")
	Set OperType=Row.%Get("手术类型")
	Set OperLevel=Row.%Get("手术级别")
	Set IsGray=Row.%Get("是否灰码")
	Set Data = $lb(Code,ICD10,Desc,inPair,ActDate,EndDate,IsActive,Resume,Alias,GroupDRG,Complication,OperType,OperLevel,IsGray)
	Quit Data
}

/// Creator：     liyi
/// CreatDate：   2022-07-25
/// Description:  验证通过界面导入Excel中的ICD数据
/// Input：       Rows : 多行数据
///               JIndex ：进程号
///               ICDType ：D(诊断)或者O(手术)
/// 			  Start ：excel分段验证时的开始行
/// 			  EndFlag ：结束标志
/// Output:       验证结果json  
/// w ##class(CT.IPMR.FPS.ICDDxSrv).TestDataInput(1,"","O",0,1)
ClassMethod TestDataInput(Rows As %Library.DynamicArray, JIndex As %String, ICDType As %String, Start As %String, EndFlag As %String)
{
	New (Rows,JIndex,ICDType,Start,EndFlag)
	Set return={"success":1,"msg":"","jIndex":""}
	Set:JIndex="" JIndex=$j
	//Set ^TEMP("TestDataInput")=Rows
	Set DynamicArray = {}.%FromJSON(Rows)
	Set cnt=0
	Set RowErr=""
	Set iter = DynamicArray.%GetIterator()
	while iter.%GetNext(.key , .Row ) {
	  	//write "key = "_key_" , value = "_value,!
	  	Set Data = ..buildInputData(Row)
	  	Set Code		= $listget(Data,1)
	  	Set ICD10		= $listget(Data,2)
	  	Set Desc		= $listget(Data,3)
	  	Set inPair		= $listget(Data,4)
	  	Set ActDate		= $listget(Data,5)
	  	Set EndDate		= $listget(Data,6)
	  	Set IsActive	= $listget(Data,7)
	  	Set Resume		= $listget(Data,8)
	  	Set Alias		= $listget(Data,9)
	  	Set GroupDRG	= $listget(Data,10)
	  	Set Complication= $listget(Data,11)
	  	Set OperType	= $listget(Data,12)	
	  	Set OperLevel	= $listget(Data,13)
	  	Set IsGray		= $listget(Data,14)
	  	//Set Order = $i(^TEMP("DataInput",JIndex,"Count"))
		//Set ^TEMP("DataInput",JIndex,Order)=Data
		// 校验数据
		Set rowcnt=key+1+Start
		Set RowErr = ""
		If Code="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"代码为空！"
		}
		If ICD10="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"主码为空！"
		}else{
			If ICD10["+" {
				Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"主码中的加号需为剑号！"
			}
			// 校验末尾是空格
			if ($e(ICD10,$l(ICD10),$l(ICD10))=" ")||($e(ICD10,$l(ICD10),$l(ICD10))=$char(160)) {
				Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"主码末尾有空格！"
			}
		}
		If inPair["+" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"副码中的加号需为剑号！"
		}
		If Desc="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"名称为空！"
		}else{
			// 校验末尾是空格
			if ($e(Desc,$l(Desc),$l(Desc))=" ")||($e(Desc,$l(Desc),$l(Desc))=$char(160)) {
				Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"名称末尾有空格！"
			}
		}
		
		Set ActDate=##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(ActDate)
		if ActDate="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"启用日期为空！"
		}else{
			If ActDate="ERROR!" {
				If RowErr="" {
					Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"启用日期格式不对！"
				}else{
					Set RowErr=RowErr_"启用日期格式不对！"
				}
			}
		}
		Set EndDate=##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(EndDate)
		If EndDate="ERROR!" {
			If RowErr="" {
				Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"停用日期格式不对！"
			}else{
				Set RowErr=RowErr_"停用日期格式不对！"
			}
		}
		// 是否有效
		If IsActive="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"是否有效为空！"
		}else{
			If '((IsActive="Y")||(IsActive="N")) {
				If RowErr="" {
					Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"是否有效值域不对！"
				}else{
					Set RowErr=RowErr_"是否有效值域不对！"
				}
			}
		}
		// 是否入组值
		Set rsd = ##class(%ResultSet).%New("CT.IPMR.BTS.DictionarySrv:QryDictionary")
	    D rsd.Execute("ICDIsGroupDRG",1)
	    Set DicList=""
		While(rsd.Next()){
			Set Desc = rsd.GetDataByName("Desc")
			Set DicList=DicList_$lb(Desc)
		}
		If ($listfind(DicList,GroupDRG)=0)&&(GroupDRG'="") {
			If RowErr="" {
				Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"是否入组值域不对！"
			}else{
				Set RowErr=RowErr_"是否入组值域不对！"
			}
		}
		If ICDType="D" {
			// 合并症与并发症
			Set rsd = ##class(%ResultSet).%New("CT.IPMR.BTS.DictionarySrv:QryDictionary")
		    D rsd.Execute("DrgComplication",1)
		    Set DicList=""
			While(rsd.Next()){
				Set Desc = rsd.GetDataByName("Desc")
				Set DicList=DicList_$lb(Desc)
			}
			If ($listfind(DicList,Complication)=0)&&(Complication'="") {
				If RowErr="" {
					Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"合并症与并发症值域不对！"
				}else{
					Set RowErr=RowErr_"合并症与并发症值域不对！"
				}
			}
		}
		If ICDType="O" {
			// 手术类型
			Set rsd = ##class(%ResultSet).%New("CT.IPMR.BTS.DictionarySrv:QryDictionary")
		    D rsd.Execute("OperType",1)
		    Set DicList=""
			While(rsd.Next()){
				Set Desc = rsd.GetDataByName("Desc")
				Set DicList=DicList_$lb(Desc)
			}
			If ($listfind(DicList,OperType)=0)&&(OperType'="") {
				If RowErr="" {
					Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"手术类型值域不对！"
				}else{
					Set RowErr=RowErr_"手术类型值域不对！"
				}
			}
			// 手术级别
			Set rsd = ##class(%ResultSet).%New("CT.IPMR.BTS.DictionarySrv:QryDictionary")
		    D rsd.Execute("OperationRank",1)
		    Set DicList=""
			While(rsd.Next()){
				Set Desc = rsd.GetDataByName("Desc")
				Set DicList=DicList_$lb(Desc)
			}
			If ($listfind(DicList,OperLevel)=0)&&(OperLevel'="") {
				If RowErr="" {
					Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"手术级别值域不对！"
				}else{
					Set RowErr=RowErr_"手术级别值域不对！"
				}
			}
		}
		Set return.msg = return.msg_RowErr
	}
	If return.msg="" {
		Set return.jIndex=JIndex
	}else{
		Set return.success=0
		Set return.jIndex=JIndex
	}
	if EndFlag=1 {
		//Kill ^TEMP("DataInput",JIndex)
	}	
	Quit return.%ToJSON()
}

/// Creator：     liyi
/// CreatDate：   2022-07-25
/// Description:  通过界面导入Excel中的ICD数据
/// Table：       CT.IPMR.FP.ICDDx
/// Input：       Rows : 多行数据
///               JIndex ：进程号
///               ICDType ：D(诊断)或者O(手术)
/// 			  Start ：excel分段导入时的开始行
/// 			  EndFlag ：结束标志
/// 			  VerCode ：版本代码
/// 			  LogInfo ：登陆信息
/// Output:       验证结果json  
/// w ##class(CT.IPMR.FPS.ICDDxSrv).DataInput(1,"","D",0,1,"Test1")
ClassMethod DataInput(Rows As %Library.DynamicArray, JIndex As %String, ICDType As %String, Start As %String, EndFlag As %String, VerCode As %String, LogInfo As %String)
{
	New (Rows,JIndex,ICDType,Start,EndFlag,VerCode,LogInfo)
	Set return={"success":1,"msg":"","jIndex":""}
	Set:JIndex="" JIndex=$j
	//Set ^TEMP("DataInput")=Rows
	Set DynamicArray = {}.%FromJSON(Rows)
	Set cnt=0
	Set iter = DynamicArray.%GetIterator()
	Set ICDVerID = $o(^CT.IPMR.FP.ICDVerI("IndexCode"," "_$zcvt(VerCode,"U"),0))
	Set objVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(ICDVerID)
	Quit:'$isobject(objVer) return
	Quit:'$isobject(objVer.FIEdition) return
	
	while iter.%GetNext(.key , .Row ) {
	  	Set Data = ..buildInputData(Row)
	  	Set Code		= $listget(Data,1)
	  	Set ICD10		= $listget(Data,2)
	  	Set Desc		= $listget(Data,3)
	  	Set inPair		= $listget(Data,4)
	  	Set ActDate		= $listget(Data,5)
	  	Set EndDate		= $listget(Data,6)
	  	Set IsActive	= $listget(Data,7)
	  	Set Resume		= $listget(Data,8)
	  	Set Alias		= $listget(Data,9)
	  	Set GroupDRG	= $listget(Data,10)
	  	Set Complication= $listget(Data,11)
	  	Set OperType	= $listget(Data,12)	
	  	Set OperLevel	= $listget(Data,13)
	  	Set IsGray		= $listget(Data,14)
	  	
	  	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("OperType",OperType)
		Set OperTypeID = ""
		If $Isobject(objDic){
			Set OperTypeID = objDic.%Id()
		}
		Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("OperationRank",OperLevel)
		Set OperLevelID = ""
		If $Isobject(objDic){
			Set OperLevelID = objDic.%Id()
		}
		Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("ICDIsGroupDRG",GroupDRG)
		Set IsGroupDRGID = ""
		If $Isobject(objDic){
			Set IsGroupDRGID = objDic.%Id()
		}
		Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("DrgComplication",Complication)
		Set DrgComplicationID = ""
		If $Isobject(objDic){
			Set DrgComplicationID = objDic.%Id()
		}
		Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("ICDIsMedInsuGray",IsGray)
		Set ICDIsMedInsuGrayID = ""
		If $Isobject(objDic){
			Set ICDIsMedInsuGrayID = objDic.%Id()
		}
		
		if objVer.FIEdition.BDCode=4 {	// 中医编码
			set CatInfo=""
		}else{
			Set CatInfo =  ##class(CT.IPMR.FPS.ICDDxSrv).getICDCat(ICD10,ICDType)
		}
		Set ID = $o(^CT.IPMR.FP.ICDDxI("IndexVerICD",ICDVerID," "_$zcvt(ICD10,"U")," "_$zcvt(Desc,"U"),0))
		Set InputStr = ID
		Set InputStr = InputStr_"^"_Code
		Set InputStr = InputStr_"^"_Desc
		Set InputStr = InputStr_"^"_ICDVerID 
		Set InputStr = InputStr_"^"_ICD10
		Set InputStr = InputStr_"^"_inPair
		Set InputStr = InputStr_"^"_""  // MCode
		Set InputStr = InputStr_"^"_OperTypeID
		Set InputStr = InputStr_"^"_""  // MRCID
		Set InputStr = InputStr_"^"_""	// ORCID
		Set InputStr = InputStr_"^"_ActDate
		Set InputStr = InputStr_"^"_EndDate
		Set InputStr = InputStr_"^"_$s(IsActive="Y":1,"N":0,1:0)
		Set InputStr = InputStr_"^"_Resume
		Set InputStr = InputStr_"^"_$p($p(CatInfo,"^",1),"|",1)  // CatID
		Set InputStr = InputStr_"^"_$p($p(CatInfo,"^",2),"|",1)  // CatSubID
		Set InputStr = InputStr_"^"_OperLevelID
		Set InputStr = InputStr_"^"_$p($p(CatInfo,"^",3),"|",1)	// DetailCataID
		Set InputStr = InputStr_"^"_IsGroupDRGID
		Set InputStr = InputStr_"^"_DrgComplicationID
		Set InputStr = InputStr_"^"_ICDIsMedInsuGrayID
		Set ret = ##class(CT.IPMR.FPS.ICDDxSrv).SaveICD(InputStr,Alias,LogInfo,"^")
		Set rowcnt=key+1+Start
		Set RowErr = ""
		if (+ret)<0 {
			Set ^LLLL=InputStr
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"导入失败！"
		}
		Set return.msg = return.msg_RowErr
	}
	If return.msg="" {
		Set return.jIndex=JIndex
	}else{
		Set return.success=0
		Set return.jIndex=JIndex
	}
	Quit return.%ToJSON()
}

/// Creator：     liyi
/// CreatDate：   2022-07-25
/// Description:  获取icd分类信息
/// Input：       aICD : ICD编目
///               aType ：类型
/// Output:       类目id|类目代码|类目描述^亚目...^细目...
/// 界面导入数据
/// w ##class(CT.IPMR.FPS.ICDDxSrv).getICDCat("A16.000","D")
ClassMethod getICDCat(aICD As %String, aType As %String) As %String
{
	New (aICD,aType)
	Set return=""
	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("ICDType",aType,"",1)
	Quit:'$isobject(objDic) return
	Quit:($e(aICD,1,1)="M")&&(aICD["/") return
	
	Set ICDTypeID = objDic.%Id()
	
	// 类目
	Set Alias=""
	Set:aType="D" Alias = $e(aICD,1,3)
	Set:aType="O" Alias = $e(aICD,1,2)
	Quit:Alias="" return
	
	Set CatInfo=""
	Set xAlias=" "_$zcvt(Alias,"U")
	Set xAlias=$o(^CT.IPMR.FP.ICDCatI("IndexICDAlias",ICDTypeID,xAlias),-1)
	For {
		Set xAlias =$o(^CT.IPMR.FP.ICDCatI("IndexICDAlias",ICDTypeID,xAlias))
		Quit:xAlias=""
		Quit:CatInfo'=""
		Quit:(aType="D")&&(Alias'=$e(xAlias,2,4))
		Quit:(aType="O")&&(Alias'=$e(xAlias,2,3))
		Set CatID = $o(^CT.IPMR.FP.ICDCatI("IndexICDAlias",ICDTypeID,xAlias,""))
		Set obj = ##class(CT.IPMR.FP.ICDCat).GetObjById(CatID)
		Continue:'$isobject(obj)
		Set CatInfo=CatID_"|"_obj.FIICDAlias_"|"_obj.FIDesc
	}
	
	// 亚目
	Set Alias=""
	Set:aType="D" Alias = $e(aICD,1,5)
	Set:aType="O" Alias = $e(aICD,1,4)
	Quit:Alias="" return
	
	Set CatSubInfo=""
	Set xAlias=" "_$zcvt(Alias,"U")
	Set xAlias=$o(^CT.IPMR.FP.ICDCatSubI("IndexICDAlias",ICDTypeID,xAlias),-1)
	For {
		Set xAlias =$o(^CT.IPMR.FP.ICDCatSubI("IndexICDAlias",ICDTypeID,xAlias))
		Quit:xAlias=""
		Quit:CatSubInfo'=""
		Quit:(aType="D")&&(Alias'=$e(xAlias,2,6))
		Quit:(aType="O")&&(Alias'=$e(xAlias,2,5))
		Set CatSubID = $o(^CT.IPMR.FP.ICDCatSubI("IndexICDAlias",ICDTypeID,xAlias,""))
		Set obj = ##class(CT.IPMR.FP.ICDCatSub).GetObjById(CatSubID)
		Continue:'$isobject(obj)
		Set CatSubInfo=CatSubID_"|"_obj.FIICDAlias_"|"_obj.FIDesc
	}
	
	// 细目
	Set Alias=""
	Set:aType="D" Alias = $e(aICD,1,6)
	Set:aType="O" Alias = $e(aICD,1,5)
	Quit:Alias="" return
	
	Set CatDetailInfo=""
	Set xAlias=" "_$zcvt(Alias,"U")
	Set xAlias=$o(^CT.IPMR.FP.ICDDetailCataI("IndexICDAlias",ICDTypeID,xAlias),-1)
	For {
		Set xAlias =$o(^CT.IPMR.FP.ICDDetailCataI("IndexICDAlias",ICDTypeID,xAlias))
		Quit:xAlias=""
		Quit:CatDetailInfo'=""
		Quit:(aType="D")&&(Alias'=$e(xAlias,2,7))
		Quit:(aType="O")&&(Alias'=$e(xAlias,2,6))
		Set CatDetailID = $o(^CT.IPMR.FP.ICDDetailCataI("IndexICDAlias",ICDTypeID,xAlias,""))
		Set obj = ##class(CT.IPMR.FP.ICDDetailCata).GetObjById(CatDetailID)
		Continue:'$isobject(obj)
		Set CatDetailInfo=CatDetailID_"|"_obj.FIICDAlias_"|"_obj.FIDesc
	}
	Set return = CatInfo_"^"_CatSubInfo_"^"_CatDetailInfo
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2022-07-29
/// Description:  查询ICD字典（维护页面）
/// Table：       CT.IPMR.FP.ICDDx
/// Input：       aVerID : ID
///               aAlias ：关键字
/// Output:       符合条件的ICD字典数据  
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDDxSrv","QryICDDic",6,"B0")
Query QryICDDic(aVerID As %String, aAlias As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,VerID:%String,VerCode:%String,VerDesc:%String,ICD10:%String,InPairCode:%String,MCode:%String,IsActive:%String,Resume:%String,Alias:%String,MRCDr:%String,ORCDr:%String,OperTypeID:%String,OperTypeDesc:%String,ActDate:%String,EndDate:%String,CatID:%String,CatAlias:%String,CatSubID:%String,CatSubAlias:%String,OperLevelID:%String,OperLevelDesc:%String,DetailCataID:%String,DetailCataDesc:%String,IsGroupDRGID:%String,IsGroupDRGDesc:%String,DrgComplicationID:%String,DrgComplicationDesc:%String,IsMedInsuGrayID:%String,IsMedInsuGrayDesc:%String")
{
}

ClassMethod QryICDDicExecute(ByRef qHandle As %Binary, aVerID As %String, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aVerID="" $$$OK
 	Set objVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(aVerID)
 	Quit:'$isobject(objVer) $$$OK
 	Set VerID 	= objVer.%Id()
 	Set VerCode	= objVer.FICode
	Set VerDesc	= objVer.FIEdition.BDDesc_" "_objVer.FIICDType.BDDesc_" "_objVer.FIVersion
 	Set xId = ""
 	For {
		Set xId = $o(^CT.IPMR.FP.ICDDxI("IndexICDVer",aVerID,xId))
		Quit:xId=""
		Set obj = ##class(CT.IPMR.FP.ICDDx).GetObjById(xId)
		continue:'$isobject(obj)
		
		Set MRCDr		= obj.FIMRCDr
		Set ORCDr		= obj.FIORCDr
		Set Code = obj.FICode
		Set Desc = obj.FIDesc
		Set ICD10 = obj.FIICD10
		
		
		Set InPairCode = obj.FIICDinPair
		Set MCode = obj.FIMCode
		Set objOperType = obj.FIOperTypeDr
		Set (OperTypeDesc,OperTypeID)=""
		if $isobject(objOperType) {
			set OperTypeDesc=objOperType.BDDesc
			set OperTypeID=objOperType.%Id()
		}
		Set ActDate = obj.FIActDate
		Set ActDate = ##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(ActDate)
		Set EndDate = obj.FIEndDate
		Set EndDate = ##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(EndDate)
		Set IsActive = obj.FIIsActive
		
		Set IsActive = $s(IsActive=1:"Y",1:"N")
		Set objOperLevel = obj.FIOperLevelDr
		Set (OperLevelDesc,OperLevelID)=""
		If $isobject(objOperLevel) {
			set OperLevelDesc=objOperLevel.BDDesc
			set OperLevelID = objOperLevel.%Id()
		}
		
		Set objIsGroupDRG = obj.FIIsGroupDRGDr
		Set (IsGroupDRGDesc,IsGroupDRGID)=""
		If $isobject(objIsGroupDRG) {
			set IsGroupDRGDesc=objIsGroupDRG.BDDesc
			set IsGroupDRGID = objIsGroupDRG.%Id()
		}
		
		Set objComplication = obj.FIDrgComplicationDr
		Set (DrgComplicationDesc,DrgComplicationID)=""
		If $isobject(objComplication) {
			set DrgComplicationDesc=objComplication.BDDesc
			set DrgComplicationID = objComplication.%Id()
		}
		Set objMedInsuGray = obj.FIIsMedInsuGray
		Set (IsMedInsuGrayID,IsMedInsuGrayDesc) = ""
		If $isobject(objMedInsuGray) {
			set IsMedInsuGrayDesc=objMedInsuGray.BDDesc
			set IsMedInsuGrayID = objMedInsuGray.%Id()
		}
		
		Set Resume = obj.FIResume
		
		// 暂时取第一个别名
		Set SubId = $o(^CT.IPMR.FP.ICDDxD(xId,"Alias",""))
		Set Alias = ""
		If SubId'="" {
			Set objSub = ##class(CT.IPMR.FP.ICDAlias).GetObjById(xId_"||"_SubId)
			If $isobject(objSub) {
				Set Alias = objSub.FIAlias
			}
		}
		If aAlias'="" {
			continue:'((ICD10[aAlias)||(Desc[aAlias)||(Alias[aAlias))
		}
		Set objCat	= obj.FICatDr
		Set objCatSub	= obj.FICatSubDr
		Set (CatID,CatAlias)=""
		If $isobject(objCat) {
			Set CatID	= objCat.%Id()
			Set CatAlias= objCat.FIICDAlias
		}
		Set (CatSubID,CatSubAlias)=""
		If $isobject(objCatSub) {
			Set CatSubID	= objCatSub.%Id()
			Set CatSubAlias = objCatSub.FIICDAlias
		}
		// 细目
		Set objDetailCata	= obj.FIDetailCataDr
		Set (DetailCataID,DetailCataDesc)=""
		If $isobject(objDetailCata) {
			Set DetailCataID	= objDetailCata.%Id()
			Set DetailCataDesc  = objDetailCata.FIICDAlias
		}
		Set Data = $LB(xId,Code,Desc,VerID,VerCode,VerDesc,ICD10,InPairCode,MCode,
		IsActive,Resume,Alias,MRCDr,ORCDr,OperTypeID,OperTypeDesc,ActDate,EndDate,
		CatID,CatAlias,CatSubID,CatSubAlias,
		OperLevelID,OperLevelDesc,DetailCataID,DetailCataDesc,
		IsGroupDRGID,IsGroupDRGDesc,DrgComplicationID,DrgComplicationDesc,IsMedInsuGrayID,IsMedInsuGrayDesc)
		
		Set ^CacheTemp(repid,ind) = Data
 		Set ind = ind + 1
	}
	Quit $$$OK
}

ClassMethod QryICDDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDDicExecute ]
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

/// 批量把加号处理为剑号
/// verid:版本ID
/// d ##class(CT.IPMR.FPS.ICDDxSrv).batch(verid)
ClassMethod batch(verid)
{
	new (verid)
	tstart
	Set xid =""
	For {
		Set xid = $o(^CT.IPMR.FP.ICDDxI("IndexICDVer",verid,xid))
		Quit:xid=""
		SEt obj = ##class(CT.IPMR.FP.ICDDx).GetObjById(xid)
		continue:'$isobject(obj)
		continue:obj.FIIsActive'=1
		If (obj.FICode["+") {
			Set obj1=##class(CT.IPMR.FP.ICDDx).%OpenId(xid)
			
			Set obj1.FICode     = $tr(obj.FICode,"+","†")
			Set obj1.FIICD10    = $tr(obj.FIICD10,"+","†")
			Set obj1.FIICDinPair= $tr(obj.FIICDinPair,"+","†")
			Set sc=obj1.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
		   		Set return=-1
			}Else{
				Set return=obj1.%Id()
			}
			Do obj1.%Close()
			w obj1.FICode,!
		}
	}
	tcommit
}

}
