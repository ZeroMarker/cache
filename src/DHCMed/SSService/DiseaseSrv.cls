/// 名称: DHCMed.SSService.DiseaseSrv
/// 描述: DHCMed.SS.Disease疾病表的常用操作
Class DHCMed.SSService.DiseaseSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  查询疾病字典
/// Table：       DHCMed.SS.Disease
/// Input：       ProductCode : 产品代码
///               IsActive ：是否有效
///               CateID : 分类ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.SSService.DiseaseSrv","QryDisease","","","","")
Query QryDisease(aProductCode As %String, aIsActive As %String, aCateID As %String, aAlias As %String = "", aIDCode As %String = "") As %Query(ROWSPEC = "ID:%String,IDCode:%String,IDDesc:%String,ICD10:%String,CateID:%String,CateDesc:%String,ProID:%String,ProName:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryDiseaseExecute(ByRef qHandle As %Binary, aProductCode As %String, aIsActive As %String, aCateID As %String, aAlias As %String = "", aIDCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aProductCode="" $$$OK
	Set ProductDr=##class(DHCMed.SS.Products).GetIDByCode(aProductCode)
	Quit:ProductDr="" $$$OK
	
	Set xProductID=0
	For {
		Set xProductID=$o(^DHCMed.SS.DiseaseI("IndexCode",xProductID))
		Quit:xProductID=""
		Continue:ProductDr'=xProductID
		
		Set xCode=""
		For {
			Set xCode=$o(^DHCMed.SS.DiseaseI("IndexCode",xProductID,xCode))
			Quit:xCode=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCMed.SS.DiseaseI("IndexCode",xProductID,xCode,xID))
				Quit:xID=""
				
				Set objDisease=##class(DHCMed.SS.Disease).GetObjById(xID)
				Continue:'$IsObject(objDisease)
				Set IDCode=objDisease.IDCode
				Continue:(aIDCode'="")&&(IDCode'=aIDCode)
				Set IDDesc=objDisease.IDDesc
				Set:IDDesc'="" IDDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Disease","IDDesc","",IDDesc)
				Set IDICD10=objDisease.IDICD10
				Continue:(aAlias'="")&&(IDDesc'[aAlias)&&($zcvt(IDICD10,"U")'[$zcvt(aAlias,"U"))
				Set IsActive=objDisease.IDIsActive
				Continue:(aIsActive'="")&&(aIsActive'=IsActive)
				Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
				Set (CateID,CateDesc,ProID,ProName)=""
				If $IsObject(objDisease.IDCateDr){
					Set CateID=objDisease.IDCateDr.%Id()
					Set CateDesc=objDisease.IDCateDr.Description
				}
				Continue:(aCateID'="")&&(aCateID'=CateID)
				If $IsObject(objDisease.IDProductDr){
					Set ProID=objDisease.IDProductDr.%Id()
					Set ProName=objDisease.IDProductDr.ProName
				}
				Set Resume=objDisease.IDResume
				
				Set Data=$lb(xID,IDCode,IDDesc,IDICD10,CateID,CateDesc,ProID,ProName,IsActive,IsActiveDesc,Resume)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryDiseaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiseaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiseaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiseaseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)	// Save QHandle
	Quit $$$OK
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  查询疾病ICD
/// Table：       DHCMed.SS.DiseaseICD
/// Input：       DiseaseID : 疾病ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.SSService.DiseaseSrv","QryDiseaseICD","")
Query QryDiseaseICD(aDiseaseID As %String) As %Query(ROWSPEC = "ID:%String,IDICD10:%String,IDICDDesc:%String,IDExWords:%String") [ SqlProc ]
{
}

ClassMethod QryDiseaseICDExecute(ByRef qHandle As %Binary, aDiseaseID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aDiseaseID="" $$$OK
	
	Set xSubID = ""
	For {
		Set xSubID=$o(^DHCMed.SS.DiseaseD(aDiseaseID,"I",xSubID))
		Quit:xSubID=""
		
		Set ID=aDiseaseID_"||"_xSubID
		Set objICD=##class(DHCMed.SS.DiseaseICD).GetObjById(ID)
		Continue:'$IsObject(objICD)
		Set IDICD10=objICD.IDICD10
		Set IDICDDesc=objICD.IDICDDesc
		Set IDExWords=objICD.IDExWords
		
		Set Data=$lb(ID,IDICD10,IDICDDesc,IDExWords)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDiseaseICDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiseaseICDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiseaseICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiseaseICDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)	// Save QHandle
	Quit $$$OK
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  查询疾病别名
/// Table：       DHCMed.SS.DiseaseAlias
/// Input：       DiseaseID : 疾病ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.SSService.DiseaseSrv","QryDiseaseAlias","")
Query QryDiseaseAlias(aDiseaseID As %String) As %Query(ROWSPEC = "ID:%String,IDAlias:%String") [ SqlProc ]
{
}

ClassMethod QryDiseaseAliasExecute(ByRef qHandle As %Binary, aDiseaseID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aDiseaseID="" $$$OK
	
	Set xSubID = ""
	For {
		Set xSubID=$o(^DHCMed.SS.DiseaseD(aDiseaseID,"A",xSubID))
		Quit:xSubID=""
		
		Set ID=aDiseaseID_"||"_xSubID
		Set objAlias=##class(DHCMed.SS.DiseaseAlias).GetObjById(ID)
		Continue:'$IsObject(objAlias)
		Set IDAlias=objAlias.IDAlias
		
		Set Data=$lb(ID,IDAlias)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDiseaseAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiseaseAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiseaseAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiseaseAliasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)	// Save QHandle
	Quit $$$OK
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-20
/// Description:  导入疾病信息
/// Table：       DHCMed.SS.Disease
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SSService.DiseaseSrv).ImportDisease("","")
ClassMethod ImportDisease(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID=$p(aInputStr,aSeparate,1)
	Set Code=$p(aInputStr,aSeparate,2)
	Set Desc=$p(aInputStr,aSeparate,3)
	Set ICD=$p(aInputStr,aSeparate,4)
	Set Cate=$p(aInputStr,aSeparate,5)	    //疾病分类
	Set:Cate="" Cate="其他"
	Set Product=$p(aInputStr,aSeparate,6)	//产品代码
	Set IsActive=$p(aInputStr,aSeparate,7)
	Quit:(Code="")||(Desc="")||(Cate="")||(Product="")||(IsActive="") return
	
	Set ProductID=+##class(DHCMed.SS.Products).GetIDByCode(Product)
	Quit:ProductID="" return
	Set objProduct=##class(DHCMed.SS.Products).GetObjById(ProductID)
	Quit:'$IsObject(objProduct) return
	Set Product=objProduct.ProCode
	
	Set DiseaseType=Product_"DiseaseType"
	Set CateID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_$zcvt(DiseaseType,"U")," "_$ZCVT(Cate,"U"),""))
	If CateID="" {
		If '$d(^DHCMed.SS.DictionaryI("IndexTypeCode"," SYS"," "_$zcvt(DiseaseType,"U"))) {
			Set SysTypeID=##class(DHCMed.SS.Dictionary).Update("^"_DiseaseType_"^疾病分类^SYS^^1^^^^"_Product,"")
		}
		Set CateID=##class(DHCMed.SS.Dictionary).Update("^"_Cate_"^"_Cate_"^"_DiseaseType_"^^1^^^^"_Product,"")
	}
	
	Set tmpInputStr=aInputStr
	Set $p(tmpInputStr,aSeparate,5)=CateID
	Set $p(tmpInputStr,aSeparate,6)=ProductID
	Set:(ID="") ID=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID," "_$ZCVT(Code,"U"),""))
	Set $p(tmpInputStr,aSeparate,1)=ID	// 代码相同覆盖
	
	Set return=##class(DHCMed.SS.Disease).Update(tmpInputStr,aSeparate)
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-20
/// Description:  导入疾病ICD信息
/// Table：       DHCMed.SS.DiseaseICD
/// Input：       InputStr ：
///               Separate : 分隔符
///               ProCode  : 产品代码
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SSService.DiseaseSrv).ImportDiseaseICD("","")
ClassMethod ImportDiseaseICD(aInputStr As %String, aSeparate As %String, aProCode As %String) As %String
{
	New (aInputStr,aSeparate,aProCode)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="")||(aProCode="") return
	
	Set DisCode=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set ICD10=$p(aInputStr,aSeparate,3)
	Set ICDDesc=$p(aInputStr,aSeparate,4)
	Quit:(DisCode="")||(ICD10="")||(ICDDesc="") return
	
	Set ProductID=+##class(DHCMed.SS.Products).GetIDByCode(aProCode)
	Quit:ProductID="" return
	Set objProduct=##class(DHCMed.SS.Products).GetObjById(ProductID)
	Quit:'$IsObject(objProduct) return
	Set DisID=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID," "_$ZCVT(DisCode,"U"),""))
	Quit:DisID="" return
	
	Set tmpInputStr=aInputStr
	Set:(ChildSub="") ChildSub=$o(^DHCMed.SS.DiseaseI("DI","IndexICD10"," "_$ZCVT(ICD10,"U"),DisID,""))
	Set $p(tmpInputStr,aSeparate,1)=DisID
	Set $p(tmpInputStr,aSeparate,2)=ChildSub
	
	Set return=##class(DHCMed.SS.DiseaseICD).Update(tmpInputStr,aSeparate)
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-20
/// Description:  导入疾病别名信息
/// Table：       DHCMed.SS.DiseaseAlias
/// Input：       InputStr ：
///               Separate : 分隔符
///               ProCode  : 产品代码
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SSService.DiseaseSrv).ImportDiseaseAlias("","")
ClassMethod ImportDiseaseAlias(aInputStr As %String, aSeparate As %String, aProCode As %String) As %String
{
	New (aInputStr,aSeparate,aProCode)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="")||(aProCode="") return
	Set DisCode=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set Alias=$p(aInputStr,aSeparate,3)
	Quit:(DisCode="")||(Alias="") return
	Set tmpInputStr=aInputStr
	Set ProductID=##class(DHCMed.SS.Products).GetIDByCode(aProCode)
	Set DisID=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID," "_$ZCVT(DisCode,"U"),""))
	Set:(ChildSub="") ChildSub=$o(^DHCMed.SS.DiseaseI("DA","IndexAlias"," "_$ZCVT(Alias,"U"),DisID,""))
	Set $p(tmpInputStr,aSeparate,1)=DisID
	Set $p(tmpInputStr,aSeparate,2)=ChildSub
	Set return=##class(DHCMed.SS.DiseaseAlias).Update(tmpInputStr,aSeparate)
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-20
/// Description:  根据产品代码删除疾病信息
/// Table：       DHCMed.SS.Disease
/// Input：       ProCode ：产品代码
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SSService.DiseaseSrv).DeleteDiseaseByProCode("")
ClassMethod DeleteDiseaseByProCode(aProCode As %String) As %String
{
	New (aProCode)
	Set return=0
	Quit:(aProCode="") return
	Set ProductID=+##class(DHCMed.SS.Products).GetIDByCode(aProCode)
	Set xCode=""
	For {
		Set xCode=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,xCode))
		Quit:(xCode="")
		Set xID=""
		For {
			Set xID=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,xCode,xID))
			Quit:(xID="")
			Set flg=##class(DHCMed.SS.Disease).DeleteById(xID)
			Set:(flg>0) return=$i(return)
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-04-22
/// Description:  诊断检查
/// Table：       DHCMed.SS.Disease
/// Input：       ProCode  : 产品代码（慢病CD）
///               MRDiagnosID : 诊断记录ID
///               EpisodeID : 就诊号
/// Return：      诊断检查结果
/// w ##class(DHCMed.SSService.DiseaseSrv).CheckMRDiagnos("CD","11||1")
ClassMethod CheckMRDiagnos(aProCode As %String, aMRDiagnosID As %String) As %String
{
	New (aProCode,aMRDiagnosID)
	Set return=""
	Quit:(aProCode="")||(aMRDiagnosID="") return
	
	Set MRAdm=$p(aMRDiagnosID,"||",1)
	Set SubID=$p(aMRDiagnosID,"||",2)
	Quit:(MRAdm="")||(SubID="") return
	
	Set ProductID=##class(DHCMed.SS.Products).GetIDByCode(aProCode)
	Quit:ProductID="" return
	
	Set ICDDxID=$p($g(^MR(MRAdm,"DIA",SubID)),"^",1)
	Quit:ICDDxID="" return
	Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",ICDDxID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",ICDDxID,"DHC",1))
	Set DiagPrefix=$p($g(^MR(MRAdm,"DIA",SubID,1)),"^",26)    //诊断前缀 add 2020-09-17
	Set:DiagPrefix'="" ICDDesc=DiagPrefix_" "_ICDDesc
	
	Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
	Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
	
	Set xDiaCode=""
	For {
		Set xDiaCode=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,xDiaCode))
		Quit:xDiaCode="" 
		
		Set xDiagnosID=0
		For {
			Set xDiagnosID=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,xDiaCode,xDiagnosID))
			Quit:xDiagnosID=""
			
			Set objDisease=##class(DHCMed.SS.Disease).GetObjById(xDiagnosID)
			Continue:'$IsObject(objDisease)
			Set tICD10=objDisease.IDICD10
			Set tICDDesc=objDisease.IDDesc
			Set tCateDesc=objDisease.IDCateDr.Description
			
			Set IsCheckDisease=0
			Set:(tICD10'="")&&(ICD10=tICD10) IsCheckDisease=1
			Set:(tICDDesc'="")&&(ICDDesc=tICDDesc) IsCheckDisease=1
			Set xICDSub=""
			For {
				Set xICDSub=$o(^DHCMed.SS.DiseaseD(xDiagnosID,"I",xICDSub))
				Quit:xICDSub=""
				Quit:IsCheckDisease=1
				
				Set objDiseaseICD=##class(DHCMed.SS.DiseaseICD).GetObjById(xDiagnosID_"||"_xICDSub)
				Continue:'$IsObject(objDiseaseICD)
				Set sICD10=objDiseaseICD.IDICD10
				Set sICDDesc=objDiseaseICD.IDICDDesc
				Set:(sICD10'="")&&(ICD10=sICD10) IsCheckDisease=1
				Set:(sICDDesc'="")&&(ICDDesc=sICDDesc) IsCheckDisease=1
			}
			Continue:IsCheckDisease=0
			//Set return=return_","_xDiagnosID_"/"_tICD10_"/"_tICDDesc
			Set return=xDiagnosID_"/"_tICD10_"/"_tICDDesc_"/"_tCateDesc
			Quit:return'=""
		}
	}
	//Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

}
