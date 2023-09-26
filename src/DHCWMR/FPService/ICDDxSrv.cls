/// 名称: DHCWMR.FPService.ICDDxSrv
/// 描述: 诊断库相关服务
/// 编写者：zhuouruimeng
/// 编写日期: 2014-09-01
Class DHCWMR.FPService.ICDDxSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-12
/// Description:  查询诊断字典列表
/// Table：       DHCWMR.FP.ICDDx
/// Input：       Alias : 别名
///               VerID : 版本
///               PageSize : 输入行
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.ICDDxSrv","QryICDByAlias","xzb q63 不良","1","150","100")
Query QryICDByAlias(aAlias As %String, aFPItemID As %String, aTypeID As %String, aPageSize As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ICD10:%String") [ SqlProc ]
{
}

ClassMethod QryICDByAliasExecute(ByRef qHandle As %Binary, aAlias As %String, aFPItemID As %String, aTypeID As %String, aPageSize As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set ^ZF=$lb(aAlias,aFPItemID,aTypeID,aPageSize)
 	
	Quit:(aAlias="")||(aFPItemID="")||(aTypeID="") $$$OK
	Set objFPItem=##class(DHCWMR.FP.WorkFItem).GetObjById(aFPItemID)
	Quit:'$IsObject(objFPItem) $$$OK
	Set (ICDVerID,OprVerID,ICDVer2ID,ICDVer3ID)=""
	If $IsObject(objFPItem.WIICDVer){
		Set ICDVerID=objFPItem.WIICDVer.%Id()   //诊断库
	}
	If $IsObject(objFPItem.WIOprVer){
		Set OprVerID=objFPItem.WIOprVer.%Id()   //手术库
	}
	If $IsObject(objFPItem.WIICDVer2){
		Set ICDVer2ID=objFPItem.WIICDVer2.%Id()   //中医诊断库
	}
	If $IsObject(objFPItem.WIICDVer3){
		Set ICDVer3ID=objFPItem.WIICDVer3.%Id()   //肿瘤码诊断库
	}
	Set objType=##class(DHCWMR.SS.Dictionary).GetObjById(aTypeID)
	Quit:'$IsObject(objType) $$$OK
	Set DicType=objType.SDType
	Set TypeCode=objType.SDCode
	Set TypeDesc=objType.SDDesc
	
	//诊断和手术库选择
	If DicType="FPICDType" {
		Set aVerId=ICDVerID
		If (TypeCode=4)||(TypeCode=8) {  //病理诊断、肿瘤码
			Set:ICDVer3ID'="" aVerId=ICDVer3ID
		}
	} Else {
		Set aVerId=OprVerID
	}
	Quit:aVerId="" $$$OK
	
	Set Count=0,aPageSize=+aPageSize
	
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
	Quit:rowIndex<1 $$$OK
	Quit:aAlias1="" $$$OK //以第一个关键词检索，其他关键词过滤
	
	Kill arrICDList
	Kill arrICDDrList
	
	//完全匹配诊断名称
 	Set xID=0
	For {
 		Set xID=$o(^DHCWMR.FP.ICDDxI("IndexDesc",+aVerId," "_$zcvt(aAlias1,"U"),xID))
 		Quit:xID=""
 		
 		//Set TypeIndex=1
 		Set TypeIndex=4  //青医附院检索出的诊断都按ICD排序
 		Set tmpAlias=""
		Do BuildDataByAlias
	}
	
	//完全匹配诊断别名
 	Set xID=0
	For {
 		Set xID=$o(^DHCWMR.FP.ICDDxI("IA","IndexAlias",+aVerId," "_$zcvt(aAlias1,"U"),xID))
 		Quit:xID=""
 		
 		//Set TypeIndex=2
 		Set TypeIndex=4  //青医附院检索出的诊断都按ICD排序
 		Set tmpAlias=$zcvt(aAlias1,"U")
		Do BuildDataByAlias
	}
	
 	//完全匹配诊断ICD10
 	Set xID="" 
 	For {
	 	Set xID=$o(^DHCWMR.FP.ICDDxI("IndexICD10",+aVerId," "_$zcvt(aAlias1,"U"),xID))
		Quit:xID=""
		
		//Set TypeIndex=3
 		Set TypeIndex=4  //青医附院检索出的诊断都按ICD排序
 		Set tmpAlias=""
		Do BuildDataByAlias
	}
	
 	//包含关系 诊断名称
 	Set xAlias=""
 	For {
	 	Set xAlias=$o(^DHCWMR.FP.ICDDxI("IndexDesc",+aVerId,xAlias))
	 	Quit:xAlias=""
	 	Quit:(aPageSize>0)&&(Count>aPageSize)
	 	Continue:(xAlias=(" "_$zcvt(aAlias1,"U")))
	 	Continue:xAlias'[$zcvt(aAlias1,"U")
	 	
	 	Set xID=0
		For {
	 		Set xID=$o(^DHCWMR.FP.ICDDxI("IndexDesc",+aVerId,xAlias,xID))
	 		Quit:xID=""
	 		Quit:(aPageSize>0)&&(Count>aPageSize)
	 		
 			Set TypeIndex=4  //青医附院检索出的诊断都按ICD排序
 			Set tmpAlias=""
 			Do BuildDataByAlias
		}
 	}
 	
 	//包含关系 诊断别名
 	Set xAlias=""
 	For {
	 	Set xAlias=$o(^DHCWMR.FP.ICDDxI("IA","IndexAlias",+aVerId,xAlias))
	 	Quit:xAlias=""
	 	Quit:(aPageSize>0)&&(Count>aPageSize)
	 	Continue:(xAlias=(" "_$zcvt(aAlias1,"U")))
	 	Continue:xAlias'[$zcvt(aAlias1,"U")
	 	
	 	Set xID=0
		For {
	 		Set xID=$o(^DHCWMR.FP.ICDDxI("IA","IndexAlias",+aVerId,xAlias,xID))
	 		Quit:xID=""
	 		Quit:(aPageSize>0)&&(Count>aPageSize)
	 		
 			Set TypeIndex=4  //青医附院检索出的诊断都按ICD排序
	 		Set tmpAlias=xAlias
 			Do BuildDataByAlias
		}
 	}
 	
 	//包含关系 诊断ICD
 	Set xAlias=" "_$zcvt(aAlias1,"U")  //ICD从头开始匹配，不匹配中间包含
 	For {
	 	Set xAlias=$o(^DHCWMR.FP.ICDDxI("IndexICD10",+aVerId,xAlias))
	 	Quit:xAlias=""
	 	Quit:(aPageSize>0)&&(Count>aPageSize)
	 	Continue:(xAlias=(" "_$zcvt(aAlias1,"U")))
	 	Continue:xAlias'[$zcvt(aAlias1,"U")
	 	
	 	Set xID=0
		For {
	 		Set xID=$o(^DHCWMR.FP.ICDDxI("IndexICD10",+aVerId,xAlias,xID))
	 		Quit:xID=""
	 		Quit:(aPageSize>0)&&(Count>aPageSize)
	 		
 			Set TypeIndex=4  //青医附院检索出的诊断都按ICD排序
 			Set tmpAlias=""
 			Do BuildDataByAlias
		}
 	}
 	
 	//输出结果
 	Set xTypeIndex=""
 	For {
		Set xTypeIndex=$o(arrICDList(xTypeIndex))
		Quit:xTypeIndex=""
		
		Set xICD10=""
		For {
			Set xICD10=$o(arrICDList(xTypeIndex,xICD10))
			Quit:xICD10=""
			Set Data=$g(arrICDList(xTypeIndex,xICD10))
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	Kill arrICDList
	Kill arrICDDrList
	
	Quit $$$OK
	
BuildDataByAlias
	Set obj=##class(DHCWMR.FP.ICDDx).GetObjById(xID)
	Quit:'$IsObject(obj)
	Quit:'$IsObject(obj.IDVCode)
	Quit:obj.IDVCode.%Id()'=aVerId
	Quit:obj.IDIsActive'=1
	
	Set DicType=objType.SDType
	Set TypeCode=objType.SDCode
	Set TypeDesc=objType.SDDesc
	
	Set ID=xID
	Set Code=obj.IDCode
	Set Desc=obj.IDDesc
	Set ICD10=obj.IDICD10
	Quit:ICD10=""
	
	Quit:$d(arrICDDrList(xID)) // 已经存在，不再重复加载
	
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
				Set xAliasID=$o(^DHCWMR.FP.ICDDxD(ID,"A",xAliasID))	
				Quit:xAliasID=""
				
				Set IsSuccess11=1
				Set xAliasDesc=$lg($g(^DHCWMR.FP.ICDDxD(ID,"A",xAliasID)),2)
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
	
	//诊断和手术控制
	If DicType="FPICDType" {
		Set ZYM="ABCDEFGHIJKLMNOPQRSTUVWXYZ"	//update by niepeng 20150123 过滤掉中医码(前两位都是字母)
		Quit:(ZYM[$e(ICD10,1,1))&&(ZYM[$e(ICD10,2,2))
		
		Set IsTumorCode=0,IsInjuryCode=0
		//modify by mxp 2016-10-18 肿瘤码 不同项目ICD编码长度可能不同
		//If ($e(ICD10,1,1)="M")&&($l(ICD10)=9)&&($e(ICD10,8,8)="/"){  //肿瘤码检查（例子：M800000/0）
		If ($e(ICD10,1,1)="M")&&(ICD10["/") {
			Set IsTumorCode=1
		} Else {
			Set ICDHead=$e(ICD10,1,1)	//update by niepeng 20150123 损伤中毒查不出来(将&&改成||)
			If (ICDHead="V")||(ICDHead="W")||(ICDHead="X")||(ICDHead="Y"){  //损伤中毒码检查（例子： V01.191）
				Set IsInjuryCode=1
			}
		}
		If (TypeCode=1)||(TypeCode=2)||(TypeCode=3)||(TypeCode=6)||(TypeCode=7) {  //主要诊断、其它诊断、医院感染诊断、门急诊诊断、入院诊断
			Quit:IsTumorCode=1
			Quit:IsInjuryCode=1
		} ElseIf (TypeCode=4)||(TypeCode=8) {  //病理诊断、肿瘤码
			Quit:IsTumorCode'=1
		} ElseIf (TypeCode=5) {  //损伤中毒
			Quit:IsInjuryCode'=1
		} Else {  //诊断类型错误
			Quit
		}
	}
	
	/*
	// 已经存在，不再重复加载
	Quit:$d(arrICDList(1,ICD10))
	Quit:$d(arrICDList(2,ICD10))
	Quit:$d(arrICDList(3,ICD10))
	*/
	Set Count=Count+1
 	Set arrICDList(TypeIndex,ICD10)=$lb(ID,Code,Desc,ICD10)
 	Set arrICDDrList(ID)=""
 	Quit
}

ClassMethod QryICDByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDByAliasExecute ]
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
/// CreatDate：   2014-09-01
/// Description:  查询诊断库
/// Table：       DHCWMR.FP.ICDDx
/// Input：       
/// output:       所有的诊断库      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.ICDDxSrv","QryICDLibrary","1","",32439)
Query QryICDLibrary(aVerId As %String, aAlias As %String, aICDID As %String = "") As %Query(ROWSPEC = "ID:%String,ICDCode:%String,ICDDesc:%String,ICDVID:%String,ICDVCode:%String,ICDVDesc:%String,IDICD10:%String,IDICD9:%String,ICDMCode:%String,IsActive:%String,Alias:%String,Resume:%String")
{
}

ClassMethod QryICDLibraryExecute(ByRef qHandle As %Binary, aVerId As %String, aAlias As %String, aICDID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aVerId="") $$$OK
 	Set aAlias=$ZCVT(aAlias,"U")
 	Quit:(aICDID="")&&(aAlias="") $$$OK
 	
 	If (aICDID'=""){
	 	Set xID = aICDID,Count=0
		Do BuildData
	}else{	
	 	Set xID=0,Count=0
	 	For {
		 	Set xID=$o(^DHCWMR.FP.ICDDxD(xID))
		 	Quit:xID="" 
		 	Do BuildData
	 	}
	}		
	Quit $$$OK
	
BuildData
	Set objICD=##class(DHCWMR.FP.ICDDx).GetObjById(xID)
 	Quit:'$IsObject(objICD)
 	
 	Set ICDCode   = objICD.IDCode
 	Set ICDDesc   = objICD.IDDesc
 	Set ICDVCode  = objICD.IDVCode
 	Quit:'$IsObject(ICDVCode)
 	Set IDVID     = ICDVCode.%Id()
 	Quit:aVerId'=IDVID
 	Set IDVCode   = ICDVCode.IVCode
 	Set IDVDesc   = ICDVCode.IVDesc
 	Set ICD10     = objICD.IDICD10
 	Set ICD9      = objICD.IDICD9
 	Set IDMCode   = objICD.IDMCode 
 	
 	Set IsActive  = objICD.IDIsActive
 	Set ISActive  = $s(IsActive = 1:"是",1:"否")
 	Set Resume    = objICD.IDResume
 	
 	Set Alias = ""
	Set xSubId = ""
	For {
		Set xSubId = $o(^DHCWMR.FP.ICDDxD(xID,"A",xSubId))
		Quit:xSubId=""
		Set objSub = ##class(DHCWMR.FP.ICDAlias).GetObjById(xID_"||"_xSubId)
		Continue:'$IsObject(objSub)
		Set Alias = Alias_","_objSub.IAAlias
	}
	Quit:((Alias'[aAlias)&&(ICDDesc'[aAlias))&&(ICDDesc'[aAlias)
	Set:Alias'="" Alias = $e(Alias,"2",$l(Alias))
	Set Count=Count+1
	
 	Set Data = $LB(xID,ICDCode,ICDDesc,IDVID,IDVCode,IDVDesc,ICD10,ICD9,IDMCode,ISActive,Alias,Resume)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod QryICDLibraryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDLibraryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDLibraryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDLibraryExecute ]
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
/// CreatDate：   2014-09-01
/// Description:  查询诊断的别名
/// Table：       DHCWMR.FP.ICDAlias
/// Input：       诊断的RowID
/// output:       诊断所有的别名    
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.ICDDxSrv","QryICDAlias")
Query QryICDAlias(Parref As %String) As %Query(ROWSPEC = "SubID:%String,ICDAlias:%String")
{
}

ClassMethod QryICDAliasExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xSubId=""
 	For {
	 	Set xSubId = $o(^DHCWMR.FP.ICDDxD(Parref,"A",xSubId))
	 	Quit:xSubId=""
	 	
	 	Set SubRowID = Parref_"||"_xSubId
	 	Set objSub = ##class(DHCWMR.FP.ICDAlias).GetObjById(SubRowID)
	 	Continue:'$IsObject(objSub)
	 	
	 	Set IAAlias = objSub.IAAlias
	 	
	 	Set Data = $LB(xSubId,IAAlias)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind +1		
 	}
 	
	Quit $$$OK
}

ClassMethod QryICDAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDAliasExecute ]
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

/// w ##Class(DHCWMR.FPService.ICDDxSrv).ImportLibrary("^GDHL^古典生物型霍乱^1^A00.001^A00.001^^GDSWXHL^1^^","^")
ClassMethod ImportLibrary(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	//代码	 描述 	版本	ICD10	ICD9	IDMCode	  拼音码   IsActive	   Resume		
	Set Code    = $p(aInputStr,aSeparate,2)
	Set Desc    = $p(aInputStr,aSeparate,3)
	Set Version = $p(aInputStr,aSeparate,4)
	Set ICD10   = $p(aInputStr,aSeparate,5)
	Set ICD9    = $p(aInputStr,aSeparate,6)
	Set IDMCode = $p(aInputStr,aSeparate,7)
	Set Alias   = $p(aInputStr,aSeparate,8)
	Set IsActive= $p(aInputStr,aSeparate,9)
	Set Resume  = $p(aInputStr,aSeparate,10)
	
	Set InputStr=""_aSeparate_Code_aSeparate_Desc_aSeparate_Version_aSeparate_ICD10_aSeparate_ICD9_aSeparate_IDMCode_aSeparate_IsActive_aSeparate_Resume_aSeparate_Alias
	Set return=##Class(DHCWMR.FP.ICDDx).Update(InputStr,aSeparate)
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-03
/// Description:  同步HIS诊断库
/// Table：       MRC_ICDDx
/// Input：       TpCode : 类型代码
/// Return：      返回String
/// w ##class(DHCWMR.FPService.ICDDxSrv).GetICDLIBByDS()
ClassMethod GetICDLIBByDS(aVerId As %String) As %String
{
	New (aVerId)
	Set return=0
	Quit:aVerId="" return
	
	Set VerID=aVerId
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^MRC("ID",xID))
		Quit:xID=""
		
		Set Count=Count+1
		//Write:(Count#1000)=0 "同步HIS诊断库：已处理 "_Count_" 条!",!
		
		Set Code=$p($g(^MRC("ID",xID)),"^",1)
		Set Desc=$p($g(^MRC("ID",xID)),"^",2)
		Set ICD10=$p($g(^MRC("ID",xID)),"^",4)
		Set ICD9=$p($g(^MRC("ID",xID)),"^",35)
		Set IsActive=1
		Set:ICD10="" IsActive=0
		Set DateFrom=$p($g(^MRC("ID",xID)),"^",6)
		Set DateTo=$p($g(^MRC("ID",xID)),"^",7)
		If DateFrom'="" {
			Set:DateFrom>(+$h) IsActive=0
		}
		If DateTo'="" {
			Set:DateTo<(+$h) IsActive=0
		}
		
		Set ID=$o(^DHCWMR.FP.ICDDxI("IndexMRCDr"," "_xID,0))
		Set InputStr=ID  //ID取值
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_VerID
		Set InputStr=InputStr_"^"_ICD10
		Set InputStr=InputStr_"^"_ICD9
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""  //别名
		Set InputStr=InputStr_"^"_xID //诊断库指针
		Set InputStr=InputStr_"^"_""  //手术库指针
		Set flg=##class(DHCWMR.FP.ICDDx).Update(InputStr,"^")
		Continue:flg<0
		Set ID=flg
		
		Set xSub=0
		For {
			Set xSub=$o(^DHCWMR.FP.ICDDxD(ID,"A",xSub))
			Quit:xSub=""
			Set flg=##class(DHCWMR.FP.ICDAlias).DeleteById(ID_"||"_xSub)
		}
		
		//同步诊断别名
		Set xSub=0
		For {
			Set xSub=$o(^MRC("ID",xID,"ALIAS",xSub))
			Quit:xSub=""
			
			Set InputStr=ID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_$g(^MRC("ID",xID,"ALIAS",xSub))
			Set flg=##class(DHCWMR.FP.ICDAlias).Update(InputStr,"^")
		}
		
		//诊断ICD10加入别名表
		If ICD10'="" {
			Set InputStr=ID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_ICD10
			Set flg=##class(DHCWMR.FP.ICDAlias).Update(InputStr,"^")
		}
	}
	
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2015-02-03
/// Description:  同步HIS手术库
/// Table：       MRC_ICDDx
/// Input：       TpCode : 类型代码
/// Return：      返回String
/// w ##class(DHCWMR.FPService.ICDDxSrv).GetOPRLIBByDS()
ClassMethod GetOPRLIBByDS(aVerId As %String) As %String
{
	New (aVerId)
	Set return=0
	Quit:aVerId="" return
	
	Set VerID=aVerId
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^ORC("OPER",xID))
		Quit:xID=""
		
		Set Count=Count+1
		//Write:(Count#1000)=0 "同步HIS手术库：已处理 "_Count_" 条!",!
		
		Set Code=$p($g(^ORC("OPER",xID)),"^",1)
		Set Desc=$p($g(^ORC("OPER",xID)),"^",2)
		Set ICD10=$p($g(^ORC("OPER",xID)),"^",14)
		Set ICD9=$p($g(^ORC("OPER",xID)),"^",21)
		Set IsActive=1
		Set:ICD10="" IsActive=0
		Set DateFrom=$p($g(^ORC("OPER",xID)),"^",5)
		Set DateTo=$p($g(^ORC("OPER",xID)),"^",6)
		If DateFrom'="" {
			Set:DateFrom>(+$h) IsActive=0
		}
		If DateTo'="" {
			Set:DateTo<(+$h) IsActive=0
		}
		
		Set ID=$o(^DHCWMR.FP.ICDDxI("IndexORCDr"," "_xID,0))
		Set InputStr=ID  //ID取值
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_VerID
		Set InputStr=InputStr_"^"_ICD10
		Set InputStr=InputStr_"^"_ICD9
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""   //别名
		Set InputStr=InputStr_"^"_""   //诊断库指针
		Set InputStr=InputStr_"^"_xID  //手术库指针
		Set flg=##class(DHCWMR.FP.ICDDx).Update(InputStr,"^")
		Continue:flg<0
		Set ID=flg
		
		Set xSub=0
		For {
			Set xSub=$o(^DHCWMR.FP.ICDDxD(ID,"A",xSub))
			Quit:xSub=""
			Set flg=##class(DHCWMR.FP.ICDAlias).DeleteById(ID_"||"_xSub)
		}
		
		Set xSub=0
		For {
			Set xSub=$o(^ORC("OPER",xID,"ALIAS",xSub))
			Quit:xSub=""
			
			Set InputStr=ID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_$g(^ORC("OPER",xID,"ALIAS",xSub))
			Set flg=##class(DHCWMR.FP.ICDAlias).Update(InputStr,"^")
		}
		
		//手术ICD10加入别名表
		If ICD10'="" {
			Set InputStr=ID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_ICD10
			Set flg=##class(DHCWMR.FP.ICDAlias).Update(InputStr,"^")
		}
	}
	
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2015-02-03
/// Description:  同步HIS手术库
/// Table：       MRC_ICDDx
/// Input：       TpCode : 类型代码
/// Return：      返回String
/// w ##class(DHCWMR.FPService.ICDDxSrv).GetICDDxDS(4)
ClassMethod GetICDDxDS(aVerId As %String) As %String
{
	New (aVerId)
	Set return=0
	Quit:aVerId="" return
	
	Set objVersion=##class(DHCWMR.FP.ICDVersion).GetObjById(aVerId)
	Quit:'$IsObject(objVersion) return
	Set VerCode=objVersion.IVCode
	If VerCode="HIS-D" {
		Set return=..GetICDLIBByDS(aVerId)
	} ElseIf VerCode="HIS-O" {
		Set return=..GetOPRLIBByDS(aVerId)
	} Else {
		Set return=-1
	}
	
	Quit return
}

}
