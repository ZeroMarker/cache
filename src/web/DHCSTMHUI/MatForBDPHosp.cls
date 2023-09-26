Class web.DHCSTMHUI.MatForBDPHosp Extends (%RegisteredObject, StkTypeM) [ ProcedureBlock ]
{

/// Descript:	根据当前登录角色的医院级授权，返回医院信息  此query是调用的query 必须使用ProcedureBlock 此query暂不使用
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 		
/// return: 医院信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.MatForBDPHosp","GetHospDataForCloud",^litmp("GetHospDataForCloud"))
Query GetHospDataForCloud(Params As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetHospDataForCloudExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s ^litmp("GetHospDataForCloud")=Params
	s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetHospDataForCloud"
	s CompiledObj=##class(%Dictionary.QueryDefinition).%OpenId(ClassMethodStr,0)
	q:'$IsObject(CompiledObj) $$$OK
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pHospid=PJObj.%Get("Hospid")
	s pFilterName=PJObj.%Get("FilterName")
	s ptablename=PJObj.%Get("tablename")
	s pdataid=PJObj.%Get("dataid")
	s pUserid=PJObj.%Get("gUserId")
	s pGroupid=PJObj.%Get("gGroupId")
	s pHospid=PJObj.%Get("gHospId")
	s pLocid=PJObj.%Get("gLocId")
	s sessionParams=pUserid_"^"_pGroupid_"^"_pLocid_"^"_pHospid
	s Result = ##class(%Library.ResultSet).%New("web.DHCBL.BDP.BDPMappingHOSP:GetHospDataForCloud")
	s sc=Result.Execute(pHospid,pFilterName,ptablename,pdataid,sessionParams)    
 	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("HOSPRowId")
	    s Description = Result.Data("HOSPDesc")
		d OutPutHospRow1
	}
	d Result.Close()
	Quit $$$OK
OutPutHospRow1
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
