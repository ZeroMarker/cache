/// 名称:DHCMed.SPEService.Screening
/// 描述:重点病人筛查条件服务类
/// 编写者: liuzhenhe
/// 编写日期: 2019-01-23
Class DHCMed.SPEService.Screening Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  测试js导入   入参:ID^代码^描述^特殊病人类型代码
/// w ##class(DHCMed.SPEService.Screening).ImportScreening("^CC02^行重大手术病人^05")
ClassMethod ImportScreening(aInputStr As %String, asparete As %String = "^") As %String
{
	New (aInputStr,asparete)
	Set return=0
	Quit:aInputStr="" return
	Set PatTypeCode=$p(aInputStr,"^",4)
	Quit:PatTypeCode="" return
	Set (ParID,SubID)=""  
	
	Set ParID=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode"," "_$zcvt(PatTypeCode,"U"),ParID))
	Quit:ParID="" return
	Set SubID=$o(^DHCMed.SPEDi("PatTp",0,"Sub","IndexCode"," "_$zcvt(PatTypeCode,"U"),ParID,SubID))
	Quit:SubID="" return
	Set PatTypeID=ParID_"||"_SubID
	Set InputStr=$p(aInputStr,"^",1)
	Set InputStr=InputStr_"^"_$p(aInputStr,"^",2)
	Set InputStr=InputStr_"^"_$p(aInputStr,"^",3)
	Set InputStr=InputStr_"^"_PatTypeID
	Set InputStr=InputStr_"^"_"1"
	
	Set return=##class(DHCMed.SPE.Screening).Update(InputStr,"^")
	Quit return
}

/// 查询特殊患者筛查条件信息 根据有效性
/// d ##Class(%ResultSet).RunQuery("DHCMed.SPEService.Screening","QueryScreening")
Query QueryScreening(aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String:ID,Code:%String:代码,Desc:%String:描述,PatTypeID:%String:患者类型ID,PatTypeCode:%String:患者类型代码,PatTypeDesc:%String:患者类型描述,ActiveDesc:%String:是否有效,ActDate:%String:更新日期,ActTime:%String:更新时间,ActUser:%String:更新人")
{
}

ClassMethod QueryScreeningExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aIsActive="" aIsActive="1,0"
	Set RowId=""
	For {
		Set RowId= $o(^DHCMed.SPE.ScreeningD(RowId))
		Quit:RowId=""
		Set obj=##Class(DHCMed.SPE.Screening).%OpenId(RowId)
		Continue:'$IsObject(obj)
		Set IsActive=obj.BTIsActive  
		Continue:aIsActive'[IsActive
		Set ActiveDesc=$Case(IsActive,"1":"是","0":"否","":"")
		Set Code= obj.BTCode   
		Set Desc=obj.BTDesc  
		Set objPatType=obj.BTPatTypeDr
		
		Set (PatTypeID,PatTypeCode,PatTypeDesc)=""
		If $IsObject(objPatType) {
			Set PatTypeID =objPatType.%Id()
			Set PatTypeCode =objPatType.PTSCode
			Set PatTypeDesc =objPatType.PTSDesc
		}
	
		Set ActDate=obj.BTActDate   
		Set ActTime=obj.BTActTime   
		Set ActUser=obj.BTActUser   
		
		Set Data=$lb(RowId,Code,Desc,PatTypeID,PatTypeCode,PatTypeDesc,ActiveDesc,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryScreeningClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryScreeningExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryScreeningFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryScreeningExecute ]
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
