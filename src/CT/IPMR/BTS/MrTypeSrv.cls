/// 名称:CT.IPMR.BTS.MrTypeSrv
/// 描述:病案类型服务
/// 创建者:WHui
/// 创建日期:2019-10-27
/// 
Class CT.IPMR.BTS.MrTypeSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     WHui
/// CreatDate：   2019-10-27
/// Description:  查询病案类型
/// Table：       CT.IPMR.BT.MrType
/// Input：    	  无	或	CT_IPMR_BT.MrClass.BMCode
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.MrTypeSrv","QueryMrType","")
Query QueryMrType(aMrClass As %String = "") As %Query(ROWSPEC = "ID:%String,MrClassID:%String,MrClassDesc:%String,MrTypeDesc:%String,HospIDs:%String,HospDescs:%String,ReceiptTypeID:%String,ReceiptTypeDesc:%String,AssignTypeID:%String,AssignTypeDesc:%String,RecycleType:%String,RecycleTypeDesc:%String,NoFiledID:%String,NoFiledDesc:%String,WorkFlowID:%String,WorkFlowDesc:%String,IsBWMrNo:%String,IsBWMrNoDesc:%String,AdmType:%String,AdmTypeDesc:%String,MTResume:%String")
{
}

ClassMethod QueryMrTypeExecute(ByRef qHandle As %Binary, aMrClass As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
 	Set xID=""
 	For {
	 	Set xID=$o(^CT.IPMR.BT.MrTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(CT.IPMR.BT.MrType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=xID
	 	Set MrTypeDesc=obj.BMDesc
	 	Set MrClassID="",MrClassDesc=""
	 	If $IsObject(obj.BMMrClass){
		 	Set MrClassID=obj.BMMrClass.%Id()
		 	Set MrClassCode = obj.BMMrClass.BMCode
		 	Set MrClassDesc=obj.BMMrClass.BMDesc
	 	}
	 	Continue:(aMrClass'="")&&(MrClassCode'=aMrClass)
	 	Set HospIDs=obj.BMHospIDs
	 	Set HospDescs=""
		For indHosp=1:1:$l(HospIDs,"#") {
			Set HospID=$p(HospIDs,"#",indHosp)
			Continue:HospID=""
			;Set HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
			Set HospInfo=##class(MA.IPMR.BTS.HospitalSrv).GetHospStrById(HospID)
			Set HospDesc=$p(HospInfo,"^",2)
			Continue:HospDesc=""
			Set HospDescs=HospDescs_","_HospDesc
		}
		Set:HospDescs'="" HospDescs=$e(HospDescs,2,$l(HospDescs))
		Set ReceiptTypeID="",ReceiptTypeDesc=""
		If $IsObject(obj.BMReceiptType) {
			Set ReceiptTypeID=obj.BMReceiptType.%Id()
			Set ReceiptTypeDesc=obj.BMReceiptType.BDDesc
		}
		Set AssignTypeID="",AssignTypeDesc=""
		If $IsObject(obj.BMAssignType) {	;MTAssignType
			Set AssignTypeID=obj.BMAssignType.%Id()
			Set AssignTypeDesc=obj.BMAssignType.BDDesc
		}
		Set RecycleType=obj.BMRecycleType
		Set RecycleTypeDesc=$s(RecycleType=1:"是",1:"否")
		Set NoFiledID="",NoFiledDesc=""
		If $IsObject(obj.BMNoFiled) {
			Set NoFiledID=obj.BMNoFiled.%Id()
			Set NoFiledDesc=obj.BMNoFiled.BDDesc
		}
		Set MTResume=obj.BMResume
		Set WorkFlowID ="", WorkFlowDesc=""
		If $IsObject(obj.BMWorkFlow){
			Set WorkFlowID=obj.BMWorkFlow.%Id()
			Set WorkFlowDesc=obj.BMWorkFlow.BWDesc
		}
		Set IsBWMrNo=obj.BMIsBWMrNo
		Set IsBWMrNoDesc=$s(IsBWMrNo=1:"是",1:"否")
		Set AdmType=obj.BMAdmType
		Set cAdmType="#"_AdmType_"#"
		Set AdmTypeDesc=""
		Set:cAdmType["#O#" AdmTypeDesc=AdmTypeDesc_","_"门诊"
		Set:cAdmType["#E#" AdmTypeDesc=AdmTypeDesc_","_"急诊"
		Set:cAdmType["#I#" AdmTypeDesc=AdmTypeDesc_","_"住院"
		Set:AdmTypeDesc'="" AdmTypeDesc=$e(AdmTypeDesc,2,$l(AdmTypeDesc))
		
		set:MrTypeDesc'="" MrTypeDesc=##class(CT.IPMR.BT.MrType).GetTranByDesc("BMDesc",MrTypeDesc,langid)
		Set Data=$lb(ID,MrClassID,MrClassDesc,MrTypeDesc,HospIDs,HospDescs,ReceiptTypeID,ReceiptTypeDesc,AssignTypeID,AssignTypeDesc,RecycleType,RecycleTypeDesc,NoFiledID,NoFiledDesc,WorkFlowID,WorkFlowDesc,IsBWMrNo,IsBWMrNoDesc,AdmType,AdmTypeDesc,MTResume)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	
 	Quit $$$OK
}

ClassMethod QueryMrTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMrTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMrTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMrTypeExecute ]
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

/// Creator：     WHui
/// CreatDate：   2019-10-27
/// Description:  根据病案类型ID查询配置医院列表
/// Table：       CT.IPMR.BT.MrType、CT_Hosptial
/// Input：       MrTypeID ：CT.IPMR.BT.MrType.ID
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.MrTypeSrv","QryMTHospList",1)
Query QryMTHospList(aMrTypeID As %String) As %Query(ROWSPEC = "HospID:%String,HospDesc:%String,IsChecked:%String")
{
}

ClassMethod QryMTHospListExecute(ByRef qHandle As %Binary, aMrTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aMrTypeID="" $$$OK
	Set objMrType=##class(CT.IPMR.BT.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) $$$OK
	Set HospIDs=objMrType.BMHospIDs
	Set HospIDs="#"_HospIDs_"#"
	
	Set arr	= ##Class(%ArrayOfDataTypes).%New()
	Set arr = ##class(MA.IPMR.BTS.HospitalSrv).GetAllHospArray()
	Set xKey=""
	For {
	    Do arr.GetNext(.xKey)
	    Quit:xKey=""
	    Set tValue	= arr.GetAt(xKey)
	    
	    Set HospID	= $p(tValue,"^",1)
		Set HospDesc= $p(tValue,"^",2)
		Set tmpHospID= "#"_HospID_"#"
		Set IsChecked= $s(HospIDs[tmpHospID:1,1:0)
		
		Set Data=$lb(HospID,HospDesc,IsChecked)
    	Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMTHospListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMTHospListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMTHospListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMTHospListExecute ]
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

/// Creator：		WHui
/// CreatDate：		2019-10-29
/// Description:	导入病案类型数据
/// Input:			
/// w ##Class(CT.IPMR.BTS.MrTypeSrv).ImportMrType("7^I^住院病案^病人接诊^自动分号^1^PA_Patmas.PAPMI_Medicare^IP^1^I^完成配置")
ClassMethod ImportMrType(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	//Set ^TMPWHui = $lb(aInputStr)
	
	Set MrTypeId		= +$p(aInputStr,"^",1)
	Set MrClassCode 	= $p(aInputStr,"^",2)
	Set MrTypeDesc		= $p(aInputStr,"^",3)
	Set ReceiptType     = $p(aInputStr,"^",4)
	Set AssignType      = $p(aInputStr,"^",5)
	Set RecycleType		= $p(aInputStr,"^",6)
	Set NoFiled			= $p(aInputStr,"^",7)
	Set WorkFlowCode	= $p(aInputStr,"^",8)
	Set IsBWMrNo		= $p(aInputStr,"^",9)
	Set AdmType			= $p(aInputStr,"^",10)
	Set Resume			= $p(aInputStr,"^",11)
	Set objMrClass=##class(CT.IPMR.BT.MrClass).GetObjByCode(MrClassCode)
	Quit:'$IsObject(objMrClass) return
	Set objReceiptType = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("ReceiptType",ReceiptType)
	Set objAssignType = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("AssignType",AssignType)
	Set objNoFiled = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("MrNoField",NoFiled)
	Set objWorkFlow = ##class(CT.IPMR.BT.WorkFlow).GetObjByCode(WorkFlowCode)
	
	Set HospIDs = ""
	Set rset=##class(%ResultSet).%New("MA.IPMR.BTS.HospitalSrv:QryHosp")
	do rset.Execute()
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		Set HospIDs = $s(HospIDs="":rset.Data("HospID"),1:HospIDs_"#"_rset.Data("HospID"))
	}
	Set objMrType		= ##class(CT.IPMR.BT.MrType).GetObjById(MrTypeId)
	If '$IsObject(objMrType) {
		Set ^CT.IPMR.BT.MrTypeD=MrTypeId-1
		Set InputStr	=""
		Set InputStr	= InputStr_"^"_objMrClass.%Id()
		Set InputStr	= InputStr_"^"_MrTypeDesc
		Set InputStr	= InputStr_"^"_HospIDs
		Set InputStr	= InputStr_"^"_$s($isobject(objReceiptType):objReceiptType.%Id(),1:"")
		Set InputStr	= InputStr_"^"_$s($isobject(objAssignType):objAssignType.%Id(),1:"")
		Set InputStr	= InputStr_"^"_RecycleType
		Set InputStr	= InputStr_"^"_$s($isobject(objNoFiled):objNoFiled.%Id(),1:"")
		Set InputStr	= InputStr_"^"_$s($isobject(objWorkFlow):objWorkFlow.%Id(),1:"")
		Set InputStr	= InputStr_"^"_IsBWMrNo
		Set InputStr	= InputStr_"^"_AdmType
		Set InputStr	= InputStr_"^"_Resume
		Set flg	= ##class(CT.IPMR.BT.MrType).Update(InputStr,"^")
		
		Set return = flg
	}
	
	Quit return
}

}
