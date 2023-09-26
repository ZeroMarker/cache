/// 名称: DHCMed.NINFService.Dic.InfDiagnoseGist
/// 描述: 诊断标准的常用操作
/// 编写者：zhangxing
/// 编写日期: 2012-12-03
Class DHCMed.NINFService.Dic.InfDiagnoseGist Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangxing
/// CreatDate：   2012-12-03
/// Description:  保存诊断标准字典
/// Table：       DHCMed_NINF_Dic.InfDiagnoseGist
/// Input：       aRepTypeCode : 报告类型代码
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.InfDiagnoseGist).SaveRec("","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveRecErr"
	
	Set Parref=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	Set Type=$p(aInput,aSeparate,3)
	Set Code=$p(aInput,aSeparate,4)
	Set InfDeas=$p(aInput,aSeparate,5)
	Quit:(Parref="")||(Type="")||(Code="") return
	
	Set return=##Class(DHCMed.NINF.Dic.InfDiagnoseGist).Update(aInput,aSeparate)
	Quit return
	
SaveRecErr
	Quit -999
}

/// Creator：     zhangxing
/// CreatDate：   2012-12-04
/// Description:  查询诊断标准字典
/// Table：       DHCMed.NINF.Dic.InfDiagnoseGist
/// Input：       
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.InfDiagnoseGist","QryInfDiagnoseGist",1)
Query QryInfDiagnoseGist(aInfDiagID As %String) As %Query(ROWSPEC = "IDGRowID:%String,IDGTypeID:%String,IDGTypeDesc:%String,IDGCode:%String,IDGDesc:%String")
{
}

ClassMethod QryInfDiagnoseGistExecute(ByRef qHandle As %Binary, aInfDiagID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aInfDiagID="" $$$OK
 	
 	Set ChildSub=""
 	For {
	 	Set ChildSub=$o(^DHCMed.NINFD("InfDia",+aInfDiagID,"GIST",ChildSub))
	 	Quit:ChildSub=""
	 	
	 	Set IDGRowID = aInfDiagID_"||"_ChildSub
	 	Set obj=##class(DHCMed.NINF.Dic.InfDiagnoseGist).GetObjById(IDGRowID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set (IDGTypeID,IDGTypeDesc,CodeType,IDGDesc)=""
		If $IsObject(obj.IDGType) {
			Set IDGTypeID=obj.IDGType.%Id()
			Set IDGTypeDesc=obj.IDGType.Description
		}
		Set IDGCode=obj.IDGCode
		Set IDGDesc=obj.IDGDesc
		Set Data=$lb(IDGRowID,IDGTypeID,IDGTypeDesc,IDGCode,IDGDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryInfDiagnoseGistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfDiagnoseGistExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfDiagnoseGistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfDiagnoseGistExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2013-06-15
/// Description:  查询诊断依据字典
/// Table：       DHCMed.NINF.Dic.InfDiagnoseGist
/// Input：       
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.InfDiagnoseGist","QryInfDiagGistList","","","44")
Query QryInfDiagGistList(aTypeCode As %String, aInfPosID As %String, aInfDiagID As %String) As %Query(ROWSPEC = "IDGRowID:%String,IDGTypeID:%String,IDGTypeDesc:%String,IDGCode:%String,IDGDesc:%String,IDRowID:%String,IDDesc:%String")
{
}

ClassMethod QryInfDiagGistListExecute(ByRef qHandle As %Binary, aTypeCode As %String, aInfPosID As %String, aInfDiagID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xInfDiagID=0
 	For {
	 	Set xInfDiagID=$o(^DHCMed.NINFD("InfDia",xInfDiagID))
	 	Quit:xInfDiagID=""
	 	
	 	//判断感染诊断
	 	Continue:(aInfDiagID'="")&&(aInfDiagID'=xInfDiagID)
	 	//判断感染部位
	 	If (aInfPosID'="")&&(aInfDiagID="") { // &&(aInfDiagID="")  add by zhoubo 2014-12-23 fixbug:1560
	 		Continue:'$d(^DHCMed.NINFDi("MapPosDia",0,"IndexPosDiag",aInfPosID,xInfDiagID))
	 	}
	 	
	 	Set objDiag=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(xInfDiagID)
	 	Continue:'$IsObject(objDiag)
	 	Set IDRowID=objDiag.%Id()
	 	Set IDDesc=objDiag.IDDesc
	 	
	 	Set SubID=0
	 	For {
		 	Set SubID=$o(^DHCMed.NINFD("InfDia",xInfDiagID,"GIST",SubID))
	 		Quit:SubID=""
	 		
	 		Set IDGRowID=xInfDiagID_"||"_SubID
	 		Set objDic=##class(DHCMed.NINF.Dic.InfDiagnoseGist).GetObjById(IDGRowID)
	 		Continue:'$IsObject(objDic)
	 		
	 		Set (IDGTypeID,IDGTypeDesc,CodeType,IDGDesc)=""
			If $IsObject(objDic.IDGType) {
				Set IDGTypeID=objDic.IDGType.%Id()
				Set IDGTypeCode=objDic.IDGType.Code
				Set IDGTypeDesc=objDic.IDGType.Description
				Continue:(aTypeCode'="")&&(aTypeCode'=IDGTypeCode)
			}
			Set IDGCode=objDic.IDGCode
			Set IDGDesc=objDic.IDGDesc
			Set Data=$lb(IDGRowID,IDGTypeID,IDGTypeDesc,IDGCode,IDGDesc,IDRowID,IDDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryInfDiagGistListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfDiagGistListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfDiagGistListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfDiagGistListExecute ]
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

/// Creator：     zhangxing
/// CreatDate：   2012-12-12
/// Description:  导入Excel感染诊断字典
/// Table：       DHCMed.NINF.Dic.InfDiagnoseGist
/// Input：       感染诊断字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINFService.Dic.InfDiagnoseGist).ImportInfDiagnoseGistDic("上呼吸道感染^说明^1^性炎症表现","^")
ClassMethod ImportInfDiagnoseGistDic(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set IDDesc=$p(aInput,aSeparate,1)   //感染诊断名称
	Set IDGType=$p(aInput,aSeparate,2)  //诊断标准类型
	Set IDGCode=$p(aInput,aSeparate,3)  //诊断标准代码
	Set IDGDesc=$p(aInput,aSeparate,4)  //诊断标准内容
	
	Set IDGTypeID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," NINFDIAGTYPE"," "_IDGType,0))
	Set IDRowID=$o(^DHCMed.NINFDi("InfDia",0,"IndexDesc"," "_$zcvt(IDDesc,"U"),0))
	Quit:IDRowID="" return
	Set ChildSub=$o(^DHCMed.NINFDi("InfDia",0,"GIST","InCode"," "_$zcvt(IDGCode,"U"),IDRowID,0))
	
	Set InputStr=IDRowID                       //感染诊断ID
	Set InputStr=InputStr_aSeparate_ChildSub   //诊断标准ChildSub
	Set InputStr=InputStr_aSeparate_IDGTypeID  //诊断标准类型ID
	Set InputStr=InputStr_aSeparate_IDGCode    //诊断标准代码
	Set InputStr=InputStr_aSeparate_IDGDesc    //诊断标准内容
	
	Set return=##Class(DHCMed.NINF.Dic.InfDiagnoseGist).Update(InputStr, aSeparate)
	Quit return
}

}
