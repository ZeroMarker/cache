/// 名称: DHCHAI.MK.BTMappingSrv（对应原有类：DHCMed.NINF.Srv.MKInfMapping）
/// 描述: 院感相关字典对照
/// 编写者：zhufei
/// 编写日期: 2013-05-16
Class DHCHAI.MK.BTMappingSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-05-16
/// Description:  通过主代码、别名查询院感相关字典
/// Table：       DHCHAI.MK.BTDictionary
/// Input：       
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.MK.BTMappingSrv","QryInfDicByType","SSDIC","INFMinkeMappingType","")
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.MK.BTMappingSrv","QryInfDicByType","PYDIC","","")
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.MK.BTMappingSrv","QryInfDicByType","ANTIDIC","","")
Query QryInfDicByType(aGroupCode As %String, aTypeCode As %String, aAlias As %String) As %Query(ROWSPEC = "DicID:%String,DicCode:%String,DicDesc:%String,DicAlias:%String")
{
}

ClassMethod QryInfDicByTypeExecute(ByRef qHandle As %Binary, aGroupCode As %String, aTypeCode As %String, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aGroupCode="" $$$OK
 	Set aAlias=$zcvt(aAlias,"U")
 	
 	Set Count=0
 	If aGroupCode="SSDIC" {
	 	Quit:aTypeCode="" $$$OK
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCHAI.MK.BTMapItemI("IdxofType"," "_$zcvt(aTypeCode,"U"),xID))
		 	Quit:xID=""
		 	Continue:Count>100
		 	
		 	Set objDic=##class(DHCHAI.MK.BTMapItem).GetObjById(xID)
		 	Continue:'$IsObject(objDic)
		 	Set Active=objDic.Active
			Continue:Active'=1
			Set Type=objDic.Type
			Continue:(aTypeCode'="")&&(aTypeCode'=Type)
		 	Set Code=objDic.Code
			Set Desc=objDic.Description
			Continue:(aAlias'="")&&($zcvt(Code,"U")'[aAlias)&&($zcvt(Desc,"U")'[aAlias)
			
			Set Count=Count+1
			
			Set Data=$lb(xID,Code,Desc,"")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	} ElseIf aGroupCode="PYDIC" {
	 	//去掉了
	} ElseIf aGroupCode="ANTIDIC" {
		//去掉了
	} Else {
		//对应院感其他诊断
	}
	
	Quit $$$OK
}

ClassMethod QryInfDicByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfDicByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfDicByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfDicByTypeExecute ]
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

/// 去除字符串前后空格，内部空格不删除
/// w ##class(DHCHAI.MK.BTMappingSrv).Trim("   aaa    ")
ClassMethod Trim(str As %String) As %String
{
	New (str)
	
	Set str=##Class(DHCHAI.MK.BTMappingSrv).Translate(str,"\n","")
	
	Set FromIndex=1
	Set ToIndex=$l(str)
	For i=1:1:$l(str)
	{
		Quit:($ASCII(str,i)'=32)&&($ASCII(str,i)'=9)&&($ASCII(str,i)'=10)&&($ASCII(str,i)'=13)
		Set FromIndex=FromIndex+1
	}
	For i=$l(str):-1:1
	{
		Quit:($ASCII(str,i)'=32)&&($ASCII(str,i)'=9)&&($ASCII(str,i)'=10)&&($ASCII(str,i)'=13)
		Set ToIndex=ToIndex-1
	}
	Quit:ToIndex<FromIndex ""
	Quit $e(str,FromIndex,ToIndex)
}

/// w ##Class(DHCHAI.MK.BTMappingSrv).Translate("aaaa\nbbb","\n","")
ClassMethod Translate(string As %String, identifier As %String, associator As %String) As %String
{
	New (string,identifier,associator)
	Set return=""
	Quit:(string="")||(identifier="") return
	
	For Ind=1:1:$l(string,identifier)
	{
		Set tmp=$p(string,identifier,Ind)
		If return="" {
			Set return=tmp
		}Else{
			Set return=return_associator_tmp
		}
	}
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2022-07-29
/// Description:  按类别查询民科院感字典对照
/// Table：       DHCHAI.MK.BTMapData
/// Input：       
/// Do ##class(%ResultSet).RunQuery("DHCHAI.MK.BTMappingSrv","QryByCategoryNew","MKDiagnos","","","","")
/// Do ##class(%ResultSet).RunQuery("DHCHAI.MK.BTMappingSrv","QryByCategoryNew","","","","","")
Query QryByCategoryNew(aCategory As %String, aSrcValue As %String, aSrcDesc As %String, aTargetValue As %String, aTargetDesc As %String) As %Query(ROWSPEC = "ID:%String,Category:%String,SrcObjectID:%String,SrcDescription:%String,Target:%String,TargetDesc:%String,ResumeText:%String,CategoryDesc:%String") [ SqlProc ]
{
}

ClassMethod QryByCategoryNewExecute(ByRef qHandle As %Binary, aCategory As %String, aSrcValue As %String, aSrcDesc As %String, aTargetValue As %String, aTargetDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Quit:aCategory="" $$$OK
 	if (aCategory=""){
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCHAI.MK.BTMapDataD(xID))
		 	Quit:xID=""
		 	
		 	Set objMap=##class(DHCHAI.MK.BTMapData).GetObjById(xID)
		 	Continue:'$IsObject(objMap)
		 	Set Category=objMap.Category
		 	Set objDicTmp=##class(DHCHAI.MK.BTMapItem).GetByTypeCode("INFMinkeMappingType",Category,"")
		 	Set CategoryDesc =objDicTmp.Description
		 	Set SrcValue=..ChangeKeyStr(objMap.SrcObjectID)
		 	Set SrcDesc=..ChangeKeyStr(objMap.SrcDescription)
		 	//$c(17)
		 	Set TargetValue=objMap.Target
		 	Set TargetDesc=objMap.TargetDesc
		 	Set ResumeText=objMap.ResumeText
		 	Continue:(aSrcValue'="")&&($zcvt(SrcValue,"U")'[$zcvt(aSrcValue,"U"))
		 	Continue:(aSrcDesc'="")&&($zcvt(SrcDesc,"U")'[$zcvt(aSrcDesc,"U"))
		 	Continue:(aTargetValue'="")&&($zcvt(TargetValue,"U")'[$zcvt(aTargetValue,"U"))
		 	Continue:(aTargetDesc'="")&&($zcvt(TargetDesc,"U")'[$zcvt(aTargetDesc,"U"))
		 	
		 	Set Data=$lb(xID,Category,SrcValue,SrcDesc,TargetValue,TargetDesc,ResumeText,CategoryDesc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
 	}
 	else
 	{
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCHAI.MK.BTMapDataI("IndexCategory"," "_$zcvt(aCategory,"U"),xID))
		 	Quit:xID=""
		 	
		 	Set objMap=##class(DHCHAI.MK.BTMapData).GetObjById(xID)
		 	Continue:'$IsObject(objMap)
		 	Set Category=objMap.Category
		 	Set objDicTmp=##class(DHCHAI.MK.BTMapItem).GetByTypeCode("INFMinkeMappingType",Category,"")
		 	Set CategoryDesc =objDicTmp.Description
		 	Set SrcValue=..ChangeKeyStr(objMap.SrcObjectID)
		 	Set SrcDesc=..ChangeKeyStr(objMap.SrcDescription)
		 	Set TargetValue=objMap.Target
		 	Set TargetDesc=objMap.TargetDesc
		 	Set ResumeText=objMap.ResumeText
		 	Continue:(aSrcValue'="")&&($zcvt(SrcValue,"U")'[$zcvt(aSrcValue,"U"))
		 	Continue:(aSrcDesc'="")&&($zcvt(SrcDesc,"U")'[$zcvt(aSrcDesc,"U"))
		 	Continue:(aTargetValue'="")&&($zcvt(TargetValue,"U")'[$zcvt(aTargetValue,"U"))
		 	Continue:(aTargetDesc'="")&&($zcvt(TargetDesc,"U")'[$zcvt(aTargetDesc,"U"))
		 	
		 	Set Data=$lb(xID,Category,SrcValue,SrcDesc,TargetValue,TargetDesc,ResumeText,CategoryDesc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryByCategoryNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByCategoryNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByCategoryNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByCategoryNewExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-09-11
/// Description:  去字符串中的特殊字符
/// Input：       aInputStr
///               aFlag   去掉特殊字符配置
/// Return：      去除特殊字符的字符串
/// w ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr("dsfe345fdghsdh")
ClassMethod ChangeKeyStr(aInputStr As %String, aExceptChar As %String = "") As %String
{
	New (aInputStr,aExceptChar)
	Quit:aInputStr="" aInputStr
	set:aExceptChar'["^" aInputStr = $tr(aInputStr,"^","ˋ")         // ^
	set:aExceptChar'[$c(0) aInputStr = $tr(aInputStr,$c(0),"")      // 不可见字符
	set:aExceptChar'[$c(1) aInputStr = $tr(aInputStr,$c(1),"")      // 不可见字符
	set:aExceptChar'[$c(2) aInputStr = $tr(aInputStr,$c(2),"")      // 不可见字符
	set:aExceptChar'[$c(3) aInputStr = $tr(aInputStr,$c(3),"")      // 不可见字符
	set:aExceptChar'[$c(4) aInputStr = $tr(aInputStr,$c(4),"")      // 不可见字符
	set:aExceptChar'[$c(5) aInputStr = $tr(aInputStr,$c(5),"")      // 不可见字符
	set:aExceptChar'[$c(6) aInputStr = $tr(aInputStr,$c(6),"")      // 不可见字符
	set:aExceptChar'[$c(7) aInputStr = $tr(aInputStr,$c(7),"")      // 不可见字符
	set:aExceptChar'[$c(8) aInputStr = $tr(aInputStr,$c(8),"")      // 不可见字符
	set:aExceptChar'[$c(9) aInputStr = $tr(aInputStr,$c(9),"")      // 水平制表符
	set:aExceptChar'[$c(10) aInputStr = $tr(aInputStr,$c(10),"")   	// 换行
	set:aExceptChar'[$c(13) aInputStr = $tr(aInputStr,$c(13),"")    // 回车
	set:aExceptChar'[$c(17) aInputStr = $tr(aInputStr,$c(17),"")    // ctrl
	set:aExceptChar'["  " aInputStr = $tr(aInputStr,"  ","")        // 不可见字符
	set:aExceptChar'["'" aInputStr = $tr(aInputStr,"'","")        // '字符
	set:aExceptChar'["""" aInputStr = $tr(aInputStr,"""","")        // "字符
	
	Quit aInputStr
}

}
