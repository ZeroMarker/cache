/// 名称: DHCMed.FBDService.SignDicSrv
/// 描述: 主要症状与体征字典
Class DHCMed.FBDService.SignDicSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator     : zhaoyu
/// CreatDate   : 2014-11-17
/// Description : 查询主要症状与体征
/// Table       : DHCMed.FBD.SignDic
/// Input       : aActive:是否有效; aLength:代码长度; aCode:代码前几位
/// Return      : ROWSPEC...
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.SignDicSrv","QrySignDic","","","006016")
Query QrySignDic(aActive As %String, aLength As %String, aCode As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ExtraTypeID:%String,ExtraTypeDesc:%String,ExtraUnit:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QrySignDicExecute(ByRef qHandle As %Binary, aActive As %String, aLength As %String, aCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set aLength=$g(aLength),aCode=$g(aCode)
	Set xCode=""
	For {
		Set xCode=$o(^DHCMed.FBD.SignDicI("IndexCode",xCode))
		Quit:(xCode="")
		Continue:(aCode'="")&&($e(xCode,2,$l(aCode)+1)'=$ZCVT(aCode,"U"))
		Set xID=""
		For {
			Set xID=$o(^DHCMed.FBD.SignDicI("IndexCode",xCode,xID))
			Quit:(xID="")
			Set objSignDic=##class(DHCMed.FBD.SignDic).GetObjById(xID)
			Continue:'$IsObject(objSignDic)
			Set Code=objSignDic.SDCode
			Continue:(aLength'="")&&($l(Code)'=aLength)
			Set Desc=objSignDic.SDDesc
			Set ExtraType=objSignDic.SDExtraType
			Set ExtraUnit=objSignDic.SDExtraUnit
			Set IsActive=objSignDic.SDIsActive
			Continue:(aActive'="")&&(aActive'=IsActive)
			Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
			Set Resume=objSignDic.SDResume
			Set (ExtraTypeID,ExtraTypeDesc)=""
			If $IsObject(ExtraType) {
				Set ExtraTypeID=ExtraType.%Id()
				Set ExtraTypeDesc=ExtraType.Description
			}
			Set Data=$lb(xID,Code,Desc,ExtraTypeID,ExtraTypeDesc,ExtraUnit,IsActive,IsActiveDesc,Resume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QrySignDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySignDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySignDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySignDicExecute ]
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
/// Description:  导入主要症状与体征信息
/// Table：       DHCMed.FBD.SignDic
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SSService.DiseaseSrv).ImportSignDic("","")
ClassMethod ImportSignDic(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID=$p(aInputStr,aSeparate,1)
	Set Code=$p(aInputStr,aSeparate,2)
	Set Desc=$p(aInputStr,aSeparate,3)
	Set ExtraTypeDesc=$p(aInputStr,aSeparate,4)
	Set ExtraUnit=$p(aInputStr,aSeparate,5)
	Set IsActive=$p(aInputStr,aSeparate,6)
	Set Resume=$p(aInputStr,aSeparate,7)
	Set:(ExtraTypeDesc="") ExtraTypeDesc="无"
	Quit:(Code="")||(Desc="")||(IsActive="") return
	Set tmpInputStr=aInputStr
	Set ExtraTypeID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," FBDSIGNEXTRATYPE"," "_$ZCVT(ExtraTypeDesc,"U"),""))
	Set $p(tmpInputStr,aSeparate,4)=ExtraTypeID
	Set:(ID="") ID=$o(^DHCMed.FBD.SignDicI("IndexCode"," "_$ZCVT(Code,"U"),""))
	Set $p(tmpInputStr,aSeparate,1)=ID
	Set return=##class(DHCMed.FBD.SignDic).Update(tmpInputStr,aSeparate)
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-20
/// Description:  删除主要症状与体征信息
/// Table：       DHCMed.FBD.SignDic
/// Input：       ProCode ：产品代码
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SSService.DiseaseSrv).DeleteSignDic()
ClassMethod DeleteSignDic() As %String
{
	New
	Set return=+$g(^DHCMed.FBD.SignDicD)
	If (return>0) {
		Kill ^DHCMed.FBD.SignDicD
		Kill ^DHCMed.FBD.SignDicI
	}
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2018-10-12
/// Description : 判断主要症状与体征是否存在子节点
/// Table       : DHCMed.FBD.SignDic
/// Input       : Code
/// Return      : return>0: 存在; return<=0:不存在
/// w ##class(DHCMed.FBDService.SignDicSrv).IsExistSub("006")
ClassMethod IsExistSub(aCode As %String) As %String
{
	New (aCode)
	Set return = 0
	Quit:aCode="" return 
	
	Set IsExistSub = 0
	Set xCode=""
	For {
		Set xCode=$o(^DHCMed.FBD.SignDicI("IndexCode",xCode))
		Quit:(xCode="")
		Quit:(IsExistSub = 1)
		Continue:($e(xCode,2,$l(aCode)+1)'=$ZCVT(aCode,"U"))
		
		Set xID=""
		For {
			Set xID=$o(^DHCMed.FBD.SignDicI("IndexCode",xCode,xID))
			Quit:(xID="")
		
			Set objSignDic=##class(DHCMed.FBD.SignDic).GetObjById(xID)
			Continue:'$IsObject(objSignDic)
			Set Code=objSignDic.SDCode
			Continue:(Code=aCode)
			Set IsExistSub = 1
		}
	}
	Set return = IsExistSub
	Quit return
}

}
