/// 传染病接口导出问题提示
/// 创建者：李阳
/// 创建日期：2015-05-18
Class DHCMed.EPDService.EpdExportProblem Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 查询医院感染报告校验信息
/// 参数：
///     aReportList : 报告ID列表
///     aDelimiter:  报告ID的分割符
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.EpdExportProblem","QryValidateInfo","72^73^74^71","^")
Query QryValidateInfo(aReportList As %String, aDelimiter As %String = "^") As %Query(ROWSPEC = "Index:%String,ID:%String,SrcValue:%String,SrcDesc:%String,TargetValue:%String,TargetDesc:%String,ResumeText:%String,MappingTypeCode:%String,MappingTypeDesc:%String,MapDicGroupCode:%String,MapDicTypeCode:%String")
{
}

ClassMethod QryValidateInfoExecute(ByRef qHandle As %Binary, aReportList As %String, aDelimiter As %String = "^") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set NIndex="QryValidateInfo"
 	Kill ^TMP($zn,$j,NIndex)
 	
 	For indRep=1:1:$l(aReportList,aDelimiter) {
 		Set ReportID=$p(aReportList,aDelimiter,indRep)
 		Continue:ReportID=""
 		
 		Set t=##class(DHCMed.EPDService.EpdExportInterface).GetExportString(ReportID)
 		Set flg=$p(t,$c(1),1)
 		Continue:flg="OK"
 		Set err=$p(t,$c(1),2)
 		Set ErrorList=err    //获取错误列表
 		For indErr=1:1:$l(ErrorList,$c(2)) {
	 		Set ErrorItem=$p(ErrorList,$c(2),indErr)
	 		Continue:ErrorItem=""
	 		
	 		//"ERROR^"_{对照字典类别}_"^"_{错误信息}_"^"_{源值}_"^"_{源值描述}
	 		Set ErrorLevel=$p(ErrorItem,"^",1)   //错误级别
	 		Set MappingType=$p(ErrorItem,"^",2)  //对照字典类别
	 		Set ErrorMsg=$p(ErrorItem,"^",3)     //错误信息
	 		Set SrcValue=$p(ErrorItem,"^",4)     //源值
	 		Set SrcDesc=$p(ErrorItem,"^",5)      //源值描述
	 		Continue:((MappingType="")||(SrcValue=""))
	 		Set ^TMP($zn,$j,NIndex,"ErrorIndex",MappingType,SrcValue)=ErrorItem
	 	}
 	}
 	
 	Set xMappingType=""
 	For {
	 	Set xMappingType=$o(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType))
	 	Quit:xMappingType=""
	 	
	 	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpdMappingDic",xMappingType,"")
	 	Continue:'$IsObject(objDic)
	 	
	 	Set xSrcValue=""
	 	For {
	 		Set xSrcValue=$o(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType,xSrcValue))
	 		Quit:xSrcValue=""
	 		
			Set ErrorItem=$g(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType,xSrcValue))
	 		Continue:ErrorItem=""
	 		Set ErrorLevel=$p(ErrorItem,"^",1)   //错误级别
	 		Set MappingType=$p(ErrorItem,"^",2)  //对照字典类别
	 		Set ErrorMsg=$p(ErrorItem,"^",3)     //错误信息
	 		Set SrcValue=$p(ErrorItem,"^",4)     //源值
	 		Set SrcDesc=$p(ErrorItem,"^",5)      //源值描述
	 		
	 		//字典对照RowID
	 		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$zcvt(MappingType,"U")," "_$zcvt(SrcValue,"U"),0))
	 		
	 		//对照字典类别代码,对照字典类别名称,源值,源值描述,目标值,目标值描述,备注,字典类别,序号
	 		Set Data=$lb("")
	 		Set $li(Data,1)=ind
	 		Set $li(Data,2)=ID
	 		Set $li(Data,3)=SrcValue
	 		Set $li(Data,4)=SrcDesc
	 		Set $li(Data,5)=""
	 		Set $li(Data,6)=""
	 		Set $li(Data,7)=""
	 		Set $li(Data,8)=objDic.Code
	 		Set $li(Data,9)=objDic.Description
	 		Set $li(Data,10)=objDic.StrA
	 		Set $li(Data,11)=objDic.StrB
	 		Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
	 	}
 	}
 	Kill ^TMP($zn,$j,NIndex)
 	
	Quit $$$OK
}

ClassMethod QryValidateInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryValidateInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryValidateInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryValidateInfoExecute ]
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
