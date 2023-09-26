/// 名称: DHCMed.NINF.Srv.MKInfMapping
/// 描述: 院感相关字典对照
/// 编写者：zhufei
/// 编写日期: 2013-05-16
Class DHCMed.NINF.Srv.MKInfMapping Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-05-16
/// Description:  通过主代码、别名查询院感相关字典
/// Table：       DHCMed.NINF.Srv.MKDictionary
/// Input：       
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.NINF.Srv.MKInfMapping","QryInfDicByType","SSDIC","INFMinkeMappingType","")
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.NINF.Srv.MKInfMapping","QryInfDicByType","PYDIC","","")
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.NINF.Srv.MKInfMapping","QryInfDicByType","ANTIDIC","","")
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
		 	Set xID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$zcvt(aTypeCode,"U"),xID))
		 	Quit:xID=""
		 	Continue:Count>100
		 	
		 	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xID)
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
	 	Set xCode=""
	 	For {
		 	Set xCode=$o(^DHCMed.NINFDi("Py",0,"IndexCode",xCode))
		 	Quit:xCode=""
		 	Set xID=0
		 	For {
			 	Set xID=$o(^DHCMed.NINFDi("Py",0,"IndexCode",xCode,xID))
			 	Quit:xID=""
				Quit:Count>100
			 	
			 	Set objDic=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(xID)
			 	Continue:'$IsObject(objDic)
			 	Set PYActive=objDic.PYActive
			 	Continue:PYActive'=1
			 	Set PYCode=objDic.PYCode
			 	Set PYDesc=objDic.PYDesc
			 	Set PYDesc1=objDic.PYDesc1
			 	Set PYPinyin=objDic.PYPinyin
			 	Set PYWhonet=objDic.PYWhonet
			 	Continue:(aAlias'="")&&($zcvt(PYCode,"U")'[aAlias)&&($zcvt(PYDesc,"U")'[aAlias)&&($zcvt(PYDesc1,"U")'[aAlias)&&($zcvt(PYPinyin,"U")'[aAlias)&&($zcvt(PYWhonet,"U")'[aAlias)
			 	
				Set Count=Count+1
			 	Set Data=$lb(xID,PYCode,PYDesc,PYPinyin)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	} ElseIf aGroupCode="ANTIDIC" {
		Set xCode=""
	 	For {
		 	Set xCode=$o(^DHCMed.NINFDi("Anti",0,"IndexCode",xCode))
		 	Quit:xCode=""
		 	Set xID=0
		 	For {
			 	Set xID=$o(^DHCMed.NINFDi("Anti",0,"IndexCode",xCode,xID))
			 	Quit:xID=""
				Quit:Count>100
			 	
			 	Set objDic=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(xID)
			 	Continue:'$IsObject(objDic)
			 	Set ANTActive=objDic.ANTActive
			 	Continue:ANTActive'=1
			 	Set ANTCode=objDic.ANTCode
			 	Set ANTDesc=objDic.ANTDesc
			 	Set ANTDesc1=objDic.ANTDesc1
			 	Set ANTPinyin=objDic.ANTPinyin
			 	Set ANTWhonet=objDic.ANTWhonet
			 	Continue:(aAlias'="")&&($zcvt(ANTCode,"U")'[aAlias)&&($zcvt(ANTDesc,"U")'[aAlias)&&($zcvt(ANTDesc1,"U")'[aAlias)&&($zcvt(ANTPinyin,"U")'[aAlias)&&($zcvt(ANTWhonet,"U")'[aAlias)
			 	
				Set Count=Count+1
			 	Set Data=$lb(xID,ANTCode,ANTDesc,ANTPinyin)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
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

}
