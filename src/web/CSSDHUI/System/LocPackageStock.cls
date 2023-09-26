Import sqluser

Class web.CSSDHUI.System.LocPackageStock Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Description：获取科室消毒包数据
/// Creator：lxt
/// CreateDate：20221123
/// input：Params
/// output：科室、消毒包、请领量、库存
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.LocPackageStock","GetLocPackageStock","{""PhaLoc"":""374"",""gUserId"":""6423"",""gLocId"":""382"",""gGroupId"":""265"",""gHospId"":""2"",""Package"":""""}")
Query GetLocPackageStock(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,LocId,LocDesc,PkgId,PkgDesc,NormQty:%Integer,CurQty:%Integer") [ SqlProc ]
{
}

ClassMethod GetLocPackageStockExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pLocId = PJObj.%Get("PhaLoc")
	s pPkgId = PJObj.%Get("Package")
	s gHospId = PJObj.%Get("gHospId")
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID as RowId, CSSDLP_Loc_Dr as LocId,CSSDLP_Pack_Dr as PkgId,CSSDLP_NormQty as NormQty,CSSDLP_CurQty as CurQty"
		_" From CSSD_LocPackage"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s LocId = Result.Data("LocId")
		s PkgId = Result.Data("PkgId")
		s NormQty = Result.Data("NormQty")
		s CurQty = Result.Data("CurQty")
		continue:(pPkgId'="")&&(pPkgId'=PkgId)
		continue:(pLocId'="")&&(pLocId'=LocId)
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PkgId,gHospId)
		continue:ShowDataFlag="N"
		s LocDesc=$p(^CTLOC(LocId),"^",2)
		s PkgObj=##Class(User.CSSDPackage).%OpenId(PkgId)
		s PkgDesc=PkgObj.CSSDPDesc
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,LocId,LocDesc,PkgId,PkgDesc,NormQty,CurQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description：保存科室消毒包数据
/// Creator：lxt
/// CreateDate：20221123
/// input：Params
/// output：成功失败
/// w ##class(web.CSSDHUI.System.LocPackageStock).jsSave(^templxt("jsSave"))
ClassMethod jsSave(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description：保存科室消毒包数据
/// Creator：lxt
/// CreateDate：20221123
/// input：Params
/// output：成功失败
/// d ##class(web.CSSDHUI.System.LocPackageStock).Save()
ClassMethod Save(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s LocId=Obj.%Get("LocId")
		s LocDesc=Obj.%Get("LocDesc")
		s PkgId=Obj.%Get("PkgId")
		s PkgDesc=Obj.%Get("PkgDesc")
		s NormQty=Obj.%Get("NormQty")
		s CurQty=Obj.%Get("CurQty")
		
		i (NormQty'="")&&(NormQty<0) d RtnObj.Err(-2,"","输入每日请领量有误，请重新输入！") q
		i (CurQty'="")&&(CurQty<0) d RtnObj.Err(-2,"","输入现有库存有误，请重新输入！") q
		s StockId=$o(^User.CSSDLocPackageI("CSSDLocPack",LocId,PkgId,0))
		i (StockId'="")&&(StockId'=RowId) d RtnObj.Err(-3,"",LocDesc_" "_PkgDesc_" "_"已存在") q
		
		i RowId="" d
		.s LocPkgObj=##class(User.CSSDLocPackage).%New()
		e  d
		.s LocPkgObj=##class(User.CSSDLocPackage).%OpenId(RowId)
		.d LocPkgObj.%Reload()
		d LocPkgObj.CSSDLPLocDrSetObjectId(LocId)
		d LocPkgObj.CSSDLPPackDrSetObjectId(PkgId)
		s LocPkgObj.CSSDLPNormQty=NormQty
		s LocPkgObj.CSSDLPCurQty=CurQty
		s Sc=LocPkgObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"","保存失败!") q
		s RowId=LocPkgObj.%Id()
	}
	q RtnObj
}

/// Description：删除科室消毒包数据
/// Creator：lxt
/// CreateDate：20221123
/// input：Params
/// output：成功失败
/// w ##class(web.CSSDHUI.System.LocPackageStock).jsDelete(^templxt("jsDelete"))
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	q:sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description：删除科室消毒包数据
/// Creator：lxt
/// CreateDate：20221123
/// input：Params
/// output：成功失败
/// d ##class(web.CSSDHUI.System.LocPackageStock).Delete()
ClassMethod Delete(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	&sql(Delete From CSSD_LocPackage where ID=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-1,"","删除失败")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description：更新科室消毒包数据库存
/// 回收：回收科室-，供应科室+；发放：供应科室-；接收：接收科室+，逆流程处理
/// Creator：lxt
/// CreateDate：20221123
/// input：LocId, PkgId, Qty
/// output：成功失败
/// w ##class(web.CSSDHUI.System.LocPackageStock).UpdateCurQty("166","44",-3).Json()
ClassMethod UpdateCurQty(LocId, PkgId, Qty) As web.CSSDHUI.RtnObj
{
	n (LocId,PkgId,Qty)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:(LocId="")||(PkgId="")||(Qty="") RtnObj.Err(-1,"","库存参数为空")
	q:Qty=0 RtnObj
	
	s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	s AttributeId=PkgObj.CSSDPPackTypeDetail
	s ClassId=PkgObj.CSSDPPackClassGetObjectId()
	s ExtFlag=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	q:AttributeId=7 RtnObj	//非循环包暂不处理
	q:ExtFlag="Y" RtnObj		//外来器械暂不处理
	
	s CurQty=0
	s RowId=$o(^User.CSSDLocPackageI("CSSDLocPack",LocId,PkgId,0))
	i RowId="" d
	.s obj=##class(User.CSSDLocPackage).%New()
	.d obj.CSSDLPLocDrSetObjectId(LocId)
	.d obj.CSSDLPPackDrSetObjectId(PkgId)
	e  d
	.s obj=##class(User.CSSDLocPackage).%OpenId(RowId)
	.d obj.%Reload()
	.s CurQty=+obj.CSSDLPCurQty
	s NewQty=CurQty+Qty
	
	s:NewQty<0 NewQty=0
	s obj.CSSDLPCurQty=NewQty
	s Sc=obj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-5,"","更新当前科室消毒包库存失败！")
	q RtnObj
}

/// Description：获取科室每日请领量
/// Creator：lxt
/// CreateDate：20221123
/// input：LocId,PkgId
/// output：请领量
ClassMethod GetNormQty(LocId, PkgId) As %Library.String
{
	n (LocId,PkgId)
	q:(LocId="")||(PkgId="") ""
	
	s RowId=$o(^User.CSSDLocPackageI("CSSDLocPack",LocId,PkgId,0))
	q:RowId="" ""
	
	s obj=##class(User.CSSDLocPackage).%OpenId(RowId)
	s NormQty=obj.CSSDLPNormQty
	
	q NormQty
}

}
