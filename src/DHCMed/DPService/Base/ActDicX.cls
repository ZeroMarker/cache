/// 名称: DHCMed.DPService.Base.ActDicX
/// 描述: 数据字典相关Service
/// 编写者：Zhugz
/// 编写日期: 2013-11-28
Class DHCMed.DPService.Base.ActDicX Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2014-2-27
/// Description:  查询数据字典(用于下拉框数据项)
/// Table：       DHCMed.DP.Base.ActDicX
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.DPService.Base.ActDicX","QryDicByCateg","SS-WORD-CAT")
Query QryDicByCateg(aCategCode As %String) As %Query(ROWSPEC = "ID:%String,DicCate:%String,Code:%String,Desc:%String,Text1:%String,Text2:%String,Text3:%String,Text4:%String,Text5:%String,Text6:%String,Text7:%String,Text8:%String,Text9:%String,Text10:%String")
{
}

ClassMethod QryDicByCategExecute(ByRef qHandle As %Binary, aCategCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aCategCode="" $$$OK
 	
 	Set xCode=""
 	For {
		Set xCode=$o(^DHCMed.DP.Base.ActDicXI("IndexCategoryCode"," "_$zcvt(aCategCode,"U"),xCode))
		Quit:xCode=""
		Set xID=0
		For {
			Set xID=$o(^DHCMed.DP.Base.ActDicXI("IndexCategoryCode"," "_$zcvt(aCategCode,"U"),xCode,xID))
			Quit:xID=""
			
			Set obj=##class(DHCMed.DP.Base.ActDicX).GetObjById(xID)
			Continue:'$IsObject(obj)
			
			Set DicCate=obj.ADXDicCate
			Set Code=obj.ADXCode
			Set Desc=obj.ADXDesc
			Set IsActive=obj.ADXIsActive
			Continue:IsActive'=1
			Set Text1=obj.ADXText1
			Set Text2=obj.ADXText2
			Set Text3=obj.ADXText3
			Set Text4=obj.ADXText4
			Set Text5=obj.ADXText5
			Set Text6=obj.ADXText6
			Set Text7=obj.ADXText7
			Set Text8=obj.ADXText8
			Set Text9=obj.ADXText9
			Set Text10=obj.ADXText10
			Set Resume=obj.ADXResume
			
		 	Set Data=$lb(xID,DicCate,Code,Desc,Text1,Text2,Text3,Text4,Text5,Text6,Text7,Text8,Text9,Text10)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryDicByCategClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicByCategExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicByCategFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicByCategExecute ]
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
