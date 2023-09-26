/// 名称: CT.IPMR.BTS.DictionarySrv
/// 描述: 基础字典相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BTS.DictionarySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     WHui
/// CreatDate：   2019-10-26
/// Description:  根据字典类型查询字典表
/// 				  用于js: Common_RadioToDic()
/// Table：       CT.IPMR.BT.Dictionary
/// Input：       aType: 字典类型
///               aHospID: 医院ID
///               aActive: 有效标志
/// output:       ID_$c(2)_Code_$c(2)_Desc_$c(1)...
/// 			  30A在院31D出院32S归档
/// w ##Class(CT.IPMR.BTS.DictionarySrv).GetDicsByType("WorkFlowStep","","")
ClassMethod GetDicsByType(aType As %String, aHospID As %String = "", aActive As %String = "1") As %String
{
	New (aType,aHospID,aActive,%session)
	Set return=""
	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Set aType=$ZCVT($g(aType),"U")
	Set TypeCode=""
	For {
		Set TypeCode = $o(^CT.IPMR.BT.DictionaryI("IndexTypeCode"," "_aType,TypeCode))
		Quit:TypeCode=""
		Set xHospID=""
		For {
			Set xHospID=$o(^CT.IPMR.BT.DictionaryI("IndexTypeCode"," "_aType,TypeCode,xHospID))
			Quit:xHospID=""
			Continue:(aHospID'="")&&(xHospID'=(" "_aHospID))
			
			Set RowID=0
			For {
				Set RowID=$o(^CT.IPMR.BT.DictionaryI("IndexTypeCode"," "_aType,TypeCode,xHospID,RowID))
				Quit:RowID=""
				Set objDic=##class(CT.IPMR.BT.Dictionary).%OpenId(RowID)
				If $IsObject(objDic){
					Set Code		= objDic.BDCode
					Set Description	= objDic.BDDesc
					Set Type		= objDic.BDType
					Continue:(aType'="")&&(aType'=$ZCVT($g(Type),"U"))
					
					Set Active		= objDic.BDIsActive
					Continue:(aActive'="")&&(Active'=aActive)
					If (Active="1"){
						Set Active="Yes"  
					}Else{
						Set Active="No"
					}
					
					Set HospitalDr=objDic.BDHospID
					Set HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
					Set:Description'="" Description=##class(CT.IPMR.BT.Dictionary).GetTranByDesc("BDDesc",Description,langid)
					Set return=return_RowID_$c(2)_Code_$c(2)_Description_$c(1)
				}
				If objDic'="" Do objDic.%Close()
			}
		}
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询字典表
/// Table：       CT.IPMR.BT.Dictionary
/// Input：       aDicType：字典类型
///               aIsActive：有效标志
///               aHospID：医院ID
/// output:       符合条件的字典数据  
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.DictionarySrv","QryDictionary","DiagType","1","","急诊")
Query QryDictionary(aDicType As %String, aIsActive As %String, aHospID As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,Type:%String,Code:%String,Desc:%String,OrderNo:%String,HospID:%String,HospDesc:%String,IsActive:%String,Resume:%String,PYAlias:%String") [ SqlProc ]
{
}

ClassMethod QryDictionaryExecute(ByRef qHandle As %Binary, aDicType As %String, aIsActive As %String, aHospID As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aDicType="" $$$OK
 	
 	// 多语言
 	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
 	Set xOrderNo=""
 	For {
	 	Set xOrderNo = $o(^CT.IPMR.BT.DictionaryI("IndexTypeOrder"," "_$ZCVT(aDicType,"U"),xOrderNo))
	 	Quit:xOrderNo=""
 	
 		Set xHospID=""
 		For {
	 		Set xHospID = $o(^CT.IPMR.BT.DictionaryI("IndexTypeOrder"," "_$ZCVT(aDicType,"U"),xOrderNo,xHospID))
	 		Quit:xHospID=""
	 	
	 		Continue:(aHospID'="")&&(aHospID'=xHospID)

			Set xID=0
 			For {
	 			Set xID=$o(^CT.IPMR.BT.DictionaryI("IndexTypeOrder"," "_$ZCVT(aDicType,"U"),xOrderNo,xHospID,xID))
	 			Quit:xID=""
	 			
	 			Set objDic=##class(CT.IPMR.BT.Dictionary).GetObjById(xID)
	 			Continue:'$IsObject(objDic)
				
				Set OrderNo=objDic.BDOrderNo
	 			Set Code=objDic.BDCode
				Set Desc=objDic.BDDesc
				Set Type=objDic.BDType
				Set HospID=objDic.BDHospID
				Set HospInfo = ##class(MA.IPMR.BTS.HospitalSrv).GetHospStrById(HospID)
				Set HospDesc = $p(HospInfo,"^",2)
				
				Set IsActive=objDic.BDIsActive
				Continue:(aIsActive'="")&&(aIsActive'=IsActive)
				Set IsActive=$s(IsActive=1:"是",1:"否")
				Set Resume = objDic.BDResume
				Set PYAlias = objDic.BDPYAlias
				Continue:(aAlias'="")&&((Code'[aAlias)&&(Desc'[aAlias)&&($ZCVT(PYAlias,"U")'[$ZCVT(aAlias,"U")))
				
				Set:Desc'="" Desc=##class(CT.IPMR.BT.Dictionary).GetTranByDesc("BDDesc",Desc,langid)
				Set:IsActive'="" IsActive=##class(CT.IPMR.BT.Dictionary).GetTranByDesc("BDIsActive",IsActive,langid)
				Set Data=$lb(xID,Type,Code,Desc,OrderNo,HospID,HospDesc,IsActive,Resume,PYAlias)
       	 		Set ^CacheTemp(repid,ind)=Data
        		Set ind=ind+1
 			}
 		}
 	}
	Quit $$$OK
}

ClassMethod QryDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictionaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictionaryExecute ]
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

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询字典树（根据字典项代码展现树形结构，格式：父代码-子代码）
/// Table：       CT.IPMR.BT.Dictionary
/// Input：       aDicType：字典类型
///               aIsActive：有效标志
///               aHospID：医院ID
/// output:       字典项
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.DictionarySrv","QryDicTree","SealContent","1","")
Query QryDicTree(aDicType As %String, aIsActive As %String, aHospID As %String = "") As %Query(ROWSPEC = "ID:%String,Type:%String,Code:%String,Desc:%String,OrderNo:%String,HospID:%String,HospDesc:%String,IsActive:%String,Resume:%String,_parentId:%String") [ SqlProc ]
{
}

ClassMethod QryDicTreeExecute(ByRef qHandle As %Binary, aDicType As %String, aIsActive As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aDicType="" $$$OK
 	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
 	Set xOrderNo=""
 	For {
	 	Set xOrderNo = $o(^CT.IPMR.BT.DictionaryI("IndexTypeOrder"," "_$ZCVT(aDicType,"U"),xOrderNo))
	 	Quit:xOrderNo=""
 	
 		Set xHospID=""
 		For {
	 		Set xHospID = $o(^CT.IPMR.BT.DictionaryI("IndexTypeOrder"," "_$ZCVT(aDicType,"U"),xOrderNo,xHospID))
	 		Quit:xHospID=""
	 	
	 		Continue:(aHospID'="")&&(aHospID'=xHospID)

			Set xID=0
 			For {
	 			Set xID=$o(^CT.IPMR.BT.DictionaryI("IndexTypeOrder"," "_$ZCVT(aDicType,"U"),xOrderNo,xHospID,xID))
	 			Quit:xID=""
	 			
	 			Set objDic=##class(CT.IPMR.BT.Dictionary).GetObjById(xID)
	 			Continue:'$IsObject(objDic)
				
				Set OrderNo=objDic.BDOrderNo
	 			Set Code=objDic.BDCode
				Set Desc=objDic.BDDesc
				Set Type=objDic.BDType
				Set HospID=objDic.BDHospID
				Set HospInfo = ##class(MA.IPMR.BTS.HospitalSrv).GetHospStrById(HospID)
				Set HospDesc = $p(HospInfo,"^",2)
				
				Set IsActive=objDic.BDIsActive
				Continue:(aIsActive'="")&&(aIsActive'=IsActive)
				Set IsActive=$s(IsActive=1:"是",1:"否")
				Set Resume = objDic.BDResume
				Set ParentID = ""
				if Code["-" {
					Set tLen=$l(Code,"-")-1		; - 个数
					Set:tLen=1 ParentCode = $p(Code,"-",1)
					Set:tLen=2 ParentCode = $p(Code,"-",1)_"-"_$p(Code,"-",2)
					;Set ParentCode = $p(Code,"-",1)
					Set objParent = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode(aDicType,ParentCode,aHospID,aIsActive)
					Set:$isobject(objParent) ParentID=objParent.%Id()
				}
				Set:Desc'="" Desc=##class(CT.IPMR.BT.Dictionary).GetTranByDesc("BDDesc",Desc,langid)
				Set Data=$lb(xID,Type,Code,Desc,OrderNo,HospID,HospDesc,IsActive,Resume,ParentID)
       	 		Set ^CacheTemp(repid,ind)=Data
        		Set ind=ind+1
 			}
 		}
 	}
	Quit $$$OK
}

ClassMethod QryDicTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicTreeExecute ]
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

}
