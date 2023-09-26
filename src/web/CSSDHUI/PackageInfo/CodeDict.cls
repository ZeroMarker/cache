Import sqluser

Class web.CSSDHUI.PackageInfo.CodeDict Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 保存消毒包分类信息
/// w ##class(web.CSSDHUI.PackageInfo.CodeDict).jsSave()
ClassMethod jsSave(Params As %String, Others As %String) As %Library.String
{
	n (Params,Others,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 保存消毒包分类信息
/// d ##class(web.CSSDHUI.PackageInfo.CodeDict).Save()
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params,Others,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) q RtnObj.Err(-1,"","入参解析失败!")

	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s gLocId=OthersObj.%Get("gLocId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s CodedictId=Obj.%Get("RowId")
		s CodedictDesc=Obj.%Get("CodedictDesc")
		s LocId=Obj.%Get("LocId")
		s UseFlag=Obj.%Get("UseFlag")

		continue:CodedictId=""
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",CodedictDesc,"CSSD_CodeDict",PHospId,CodedictId)
		i DescId'="" d RtnObj.Err(-2,"","名称已存在!")
		continue:RtnObj.success'=0

		s CodeDictObj=##class(User.CSSDCodeDict).%OpenId(CodedictId)
		d CodeDictObj.%Reload()
		s CodeDictObj.CSSDCDPackName=CodedictDesc
		d CodeDictObj.CSSDCDOPRLocIDSetObjectId(LocId)
		d CodeDictObj.CSSDCDCreateLocDrSetObjectId(gLocId)
		s CodeDictObj.CSSDCDNotUseFlag=UseFlag
		s Sc=CodeDictObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-3,"","保存失败!")
		continue:RtnObj.success'=0
		s CodedictId=CodeDictObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_CodeDict",CodedictId,PHospId)
		i ret'=0 d RtnObj.Err(-4,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageInfo.CodeDict","SelectAll","{""PackTypeDetail"":"""",""gUserId"":""15929"",""gLocId"":""37"",""gGroupId"":""294"",""gHospId"":""2"",""SterType"":"""",""package"":"""",""Qty"":"""",""codedictName"":""""}","{""BDPHospital"":""2"",""gUserId"":""15929"",""gLocId"":""37"",""gGroupId"":""294"",""gHospId"":""2""}")
Query SelectAll(Params As %String, Others As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,CodedictCode,PkgDesc,CodedictDesc,AttributeDesc,CycleCount:%Integer,LocId,LocDesc,SterTypeId,SterTypeDesc,PkgItemCount,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String, Others As %String) As %Status
{
	n (qHandle,Params,Others,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s OtherSc=OthersObj.%FromJSON(Others)
	s Sc=PJObj.%FromJSON(Params)
	i ((Sc'=0)||(OtherSc'=0)) q $$$OK

	s PPkgId = PJObj.%Get("PkgDesc")
	s PSteTypeId = PJObj.%Get("SterType")
	s PCodedictDesc=PJObj.%Get("CodedictDesc")
	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s gLocId = PJObj.%Get("gLocId")
	s OprFlag = PJObj.%Get("OprFlag")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID as RowId ,CSSDCD_Code,CSSDCD_PackDR,CSSDCD_PackDR->CSSDP_Desc as PkgDesc,"
			_"CSSDCD_PackName,CSSDCD_PackDR->CSSDP_PackTypeDetail as AttributeId,"
			_"CSSDCD_CycleCount,CSSDCD_OPRLocID as LocId,CSSDCD_NotUseFlag,"
			_"CSSDCD_CreateLocDr FROM CSSD_CodeDict"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next()) {
		s RowId = Result.Data("RowId")
		s CreateLocId = Result.Data("CSSDCD_CreateLocDr")
		s CodedictCode = Result.Data("CSSDCD_Code")
		s PkgId = Result.Data("CSSDCD_PackDR")
		s PkgDesc = Result.Data("PkgDesc")
		s CodedictDesc = Result.Data("CSSDCD_PackName")
		s AttributeId = Result.Data("AttributeId")
		s CycleCount = Result.Data("CSSDCD_CycleCount")
		s LocId = Result.Data("LocId")
		s UseFlag = Result.Data("CSSDCD_NotUseFlag")
		continue:((gLocId'="")&&(gLocId'=CreateLocId))
		s Ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CodeDict",RowId,PHospId)
		continue:Ret="N"
		continue:((PPkgId'="")&&(PPkgId'=PkgId))
		s SterTypeId=$lg(^User.CSSDPackageD(PkgId),21)
		continue:((PSteTypeId'="")&&(PSteTypeId'=SterTypeId))
		s SterTypeDesc=""
		s:SterTypeId'="" SterTypeDesc=$lg(^User.CSSDSterTypeD(SterTypeId),3)
		s TmpCodeDictDesc=CodedictCode_""_CodedictDesc
		continue:((PCodedictDesc'="")&&(TmpCodeDictDesc'[PCodedictDesc))
		s PkgItemCount=0,PkgItemId=""
		f  s PkgItemId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItemId)) q:PkgItemId=""  d
		.s Qty=$lg(^User.CSSDPackageItemD(PkgItemId),4)
		.s PkgItemCount=PkgItemCount+Qty	//消毒包内部的器械数量
		continue:((OprFlag="Y")&&((AttributeId=3)||(AttributeId=6)))
		s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
		s LocDesc=""
		s:LocId'="" LocDesc = $p($g(^CTLOC(LocId)),"^",2)
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,CodedictCode,PkgDesc,CodedictDesc,AttributeDesc,CycleCount,LocId,LocDesc,SterTypeId,SterTypeDesc,PkgItemCount,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 生成条码
/// d ##class(web.CSSDHUI.PackageInfo.CodeDict).CreateCodeDict()
ClassMethod CreateCodeDict(Params, Others) As web.CSSDHUI.RtnObj
{
	n (Params,Others,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) q RtnObj.Err(-1,"","入参解析失败!")

	s PHospId=OthersObj.%Get("BDPHospital")
	s PPkgId=PJObj.%Get("PkgDesc")
	s PQty=PJObj.%Get("Qty")
	s gLocId=OthersObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")

	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	i PQty<=0 q RtnObj.Err(-2,"","输入数量有误，请重新输入！")
	s PkgCode=$Lg(^User.CSSDPackageD(PPkgId),4)
	s PkgDesc=$Lg(^User.CSSDPackageD(PPkgId),5)
	s AttributeId=$Lg(^User.CSSDPackageD(PPkgId),15)
	s LocId=$Lg(^User.CSSDPackageD(PPkgId),18)
	i AttributeId>=10 d
	.s PkgCode= AttributeId_$tr($j(PkgCode,4)," ","0")
	e  d
	.s PkgCode= AttributeId_$tr($j(PkgCode,5)," ","0")
	s MaxCode =""
	&sql(select (case max($Extract(cssdcd_code,7,9)) when null then 0 else max($Extract(cssdcd_code,7,9)) end) into :MaxCode from cssd_codedict where cssdcd_packdr=:PPkgId)
	ts
	s k=0,CodeStr=""
	while(k<PQty) {
		s MaxCode=MaxCode+1
		s FormatCode=$tr($j(MaxCode,3)," ","0")
		s PPkgCode=PkgCode_FormatCode
		s PPkgDesc=PkgDesc_FormatCode
		continue:..IfRepeatCode(PPkgCode)'=0
		s CodeDictObj=##class(User.CSSDCodeDict).%New()
		s CodeDictObj.CSSDCDCode=PPkgCode
		s CodeDictObj.CSSDCDPackName=PPkgDesc
		s CodeDictObj.CSSDCDCycleCount=0
		d CodeDictObj.CSSDCDPackDRSetObjectId(PPkgId)
		d CodeDictObj.CSSDCDOPRLocIDSetObjectId(LocId)
		d CodeDictObj.CSSDCDHospitalSetObjectId(PHospId)
		d CodeDictObj.CSSDCDCreateLocDrSetObjectId(gLocId)
		s Sc=CodeDictObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-3,"","保存失败!")
		continue:RtnObj.success'=0
		s k=k+1
		s CodeDictId=CodeDictObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_CodeDict",CodeDictId,PHospId)
		i ret'=0 d RtnObj.Err(-4,"","关联院区失败!")
		continue:RtnObj.success'=0
		i CodeStr="" s CodeStr=PPkgCode
		e  s CodeStr=PPkgCode_","_PPkgCode
	}
	i RtnObj.success<0 tro  q RtnObj
	
	s RtnObj.rowid=CodeStr		//用于界面显示新生成的标牌
	tc
	q RtnObj
}

/// 判断标牌编码是否重复
ClassMethod IfRepeatCode(Code) As %Integer
{
	n (Code,%session)
	s ret=0
	s ID=""
	&sql(select Id into :ID from cssd_codedict where cssdcd_code=:Code )
	s:ID'="" ret=1
	q ret
}

/// Return:		RtnObj.Json()
/// Description:用于同步消毒包名称修改了，同步codeDict表
/// Creator:	ban
/// Date:		2020-07-29
/// Table:		CSSD_Package
/// Input:		
/// Output:		RtnObj
/// d ##class(web.CSSDHUI.PackageInfo.CodeDict).UpdateCodeDictDesc("{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod UpdateCodeDictDesc(Others As %String) As %Library.String
{
	n (Others,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i (OthersSc'=0) q RtnObj.Err(-1,"","入参解析失败!").Json()

	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDP_Rowid,CSSDP_Desc,CSSDP_PackTypeDetail FROM CSSD_Package where CSSDP_PackTypeDetail not in (2,7,10)"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s PkgId = Result.Data("CSSDP_Rowid")
		s PkgDesc = Result.Data("CSSDP_Desc")
		s AttributeId = Result.Data("CSSDP_PackTypeDetail")
		s CodeDictId=""
		f  s CodeDictId=$o(^User.CSSDCodeDictI("PACKDR",PkgId,CodeDictId)) q:CodeDictId=""  d
		.s Ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_CodeDict",CodeDictId,PHospId)
		.q:Ret="N"
		.s CodeDictObj = ##class(User.CSSDCodeDict).%OpenId(CodeDictId)
		.d CodeDictObj.%Reload()
		.q:'$IsObject(CodeDictObj)
		.s CodeDictCode = CodeDictObj.CSSDCDCode
		.s CycleCount = CodeDictObj.CSSDCDCycleCount
		.q:CycleCount'=0
		.s CodeLength=$l(CodeDictCode)
		.s CodeDictDesc = PkgDesc_$e(CodeDictCode,CodeLength-2,CodeLength)
		.s CodeDictObj.CSSDCDPackName=CodeDictDesc
		.s CodeDictObj.CSSDCDPackTypeDetail=AttributeId
		.s Sc=CodeDictObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-2,"","同步消毒包名称出错!")
	}
	d Result.Close()
	q RtnObj.Json()
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageInfo.CodeDict","JsExportPkgInfo","")
Query JsExportPkgInfo(Params As %Text, Others As %Text) As web.CSSDHUI.Query(ROWSPEC = "AttributeId:%Integer,AttributeDesc,CodeDictCode,CodeDictDesc,PkgItmId:%Integer,PkgItmDesc,PkgItmSpec,PkgItmQty:%Integer") [ SqlProc ]
{
}

ClassMethod JsExportPkgInfoExecute(ByRef qHandle As %Binary, Params As %Text, Others As %Text) As %Status
{
	n (qHandle,Params,Others,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) q $$$OK

	s PPkgId = PJObj.%Get("PkgDesc")
	s PAttributeId = PJObj.%Get("AttributeDesc")
	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr ="SELECT cc.ID as CodeDictId, cc.CSSDCD_Code as CodeDictCode, cc.CSSDCD_PackName as CodeDictDesc, cc.CSSDCD_PackDR as PkgId, cc.CSSDCD_PackDR->CSSDP_PackTypeDetail as AttributeId,"
			_" cpi.CSSDPI_Itm_DR->CSSDI_Desc as PkgItmDesc,cpi.CSSDPI_Itm_DR->CSSDI_Spec as PkgItmSpec,cpi.CSSDPI_Itm_DR as PkgItmId,cpi.CSSDPI_Qty as PkgItmQty FROM CSSD_CodeDict cc, CSSD_PackageItem cpi"
			_" WHERE cc.CSSDCD_PackDR = cpi.CSSDPI_Package_DR order by AttributeId"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s CodeDictId = Result.Data("CodeDictId")
		s PkgId = Result.Data("PkgId")
		s AttributeId = Result.Data("AttributeId")
		s CodeDictCode = Result.Data("CodeDictCode")
		s CodeDictDesc = Result.Data("CodeDictDesc")
		s PkgItmId = Result.Data("PkgItmId")
		s PkgItmDesc = Result.Data("PkgItmDesc")
		s PkgItmSpec = Result.Data("PkgItmSpec")
		s PkgItmQty = Result.Data("PkgItmQty")
		continue:((AttributeId=3)||(AttributeId=6))
		s AttributeDesc = ##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
		continue:((PPkgId'="")&&(PPkgId'=PkgId))
		continue:((PAttributeId'="")&&(PAttributeId'=AttributeId))
		s ret=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CodeDict",CodeDictId,PHospId)
		continue:ret="N"
		d OutPutRowExport
	}
	d Result.Close()
	Quit $$$OK
OutPutRowExport
	s Data=$lb(AttributeId,AttributeDesc,CodeDictCode,CodeDictDesc,PkgItmId,PkgItmDesc,PkgItmSpec,PkgItmQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 生成标牌条码和老库一致
/// d ##class(web.CSSDHUI.PackageInfo.CodeDict).CreateOldBarcode("{""PackTypeDetail"":"""",""gUserId"":""13320"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""SterType"":"""",""package"":""50"",""Qty"":""1"",""codedictName"":""""}","{""BDPHospital"":""2"",""gUserId"":""13320"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod CreateOldCodeDict(Params, Others) As web.CSSDHUI.RtnObj
{
	n (Params,Others,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) q RtnObj.Err(-1,"","入参解析失败!")

	s PHospId=OthersObj.%Get("BDPHospital")
	s PPkgId=PJObj.%Get("PkgDesc")
	s PQty=PJObj.%Get("Qty")
	s gLocId=OthersObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")

	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	i PQty<=0 q RtnObj.Err(-2,"","输入数量有误，请重新输入！")
	s PkgCode=$List(^User.CSSDPackageD(PPkgId),4)
	s PkgDesc=$Lg(^User.CSSDPackageD(PPkgId),5)
	s packageType=$Lg(^User.CSSDPackageD(PPkgId),15)
	s LocId=$Lg(^User.CSSDPackageD(PPkgId),18)
	s PkgCode="0"_$tr($j(PkgCode,5)," ","0")	///老版本数据库一般是0开头

	s k=0
	s MaxCode=""
	&sql(select (case max($Extract(cssdcd_code,7,9)) when null then 0 else max($Extract(cssdcd_code,7,9)) end ) into :MaxCode from cssd_codedict where cssdcd_packdr=:PPkgId)
	&sql(select count(1) into :Count from cssd_codedict where cssdcd_packdr=:PPkgId)
	ts
	while(k<PQty) {
		s MaxCode=MaxCode+1
		s DicCode=$tr($j(MaxCode,3)," ","0")
		s PPkgCode=PkgCode_DicCode
		continue:..IfRepeatCode(PPkgCode)'=0
		s Count=Count+1
		s DicCount=$tr($j(Count,3)," ","0")
		s PPkgDesc=PkgDesc_DicCount
		s CodeDictObj=##class(User.CSSDCodeDict).%New()
		s CodeDictObj.CSSDCDCode=PPkgCode
		s CodeDictObj.CSSDCDPackName=PPkgDesc
		s CodeDictObj.CSSDCDCycleCount=0
		d CodeDictObj.CSSDCDPackDRSetObjectId(PPkgId)
		d CodeDictObj.CSSDCDOPRLocIDSetObjectId(LocId)
		d CodeDictObj.CSSDCDHospitalSetObjectId(PHospId)
		d CodeDictObj.CSSDCDCreateLocDrSetObjectId(gLocId)
		s Sc=CodeDictObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-3,"","保存失败!")
		continue:RtnObj.success'=0
		s k=k+1
		s CodeDictId=CodeDictObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_CodeDict",CodeDictId,PHospId)
		i ret'=0 d RtnObj.Err(-4,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj

	tc
	q RtnObj
}

/// 删除标牌
/// w ##class(web.CSSDHUI.PackageInfo.CodeDict).jsDelete()
ClassMethod jsDelete(Params) As %String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Delete(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2021.12.23
/// Description:删除生成的标牌
/// Table:
/// Input:Params
/// Output:
/// Return:RtnObj
/// others:
/// d ##class(web.CSSDHUI.PackageInfo.CodeDict).Delete()
ClassMethod Delete(Params) As web.CSSDHUI.RtnObj
{
	n (Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败:")

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s CodedictCode=Obj.%Get("CodedictCode")
		s CycleCount=Obj.%Get("CycleCount")

		i CycleCount'=0 d RtnObj.Err(-2,"","存在业务数据，不能删除该标牌！")
		continue:RtnObj.success'=0
		s CodeDictId=""
		i CodedictCode'="" s CodeDictId=$o(^User.CSSDCleanDetailPacksI("CSSDIndexCDPLabel",CodedictCode,""))
		i CodeDictId'="" d RtnObj.Err(-3,"","存在清洗业务数据，不能删除该标牌!")
		continue:RtnObj.success'=0
		s MachineSterCar=$o(^User.CSSDMachineConfigI("IndexCSSDMCSterCar",RowId,""))
		i MachineSterCar'="" d RtnObj.Err(-4,"","机器设置绑定了该标牌，不能删除!")
		continue:RtnObj.success'=0
		i ((CodeDictId="")&&(CycleCount=0)) d
		.&sql(DELETE FROM CSSD_CodeDict WHERE ID=:RowId)
		.i SQLCODE'=0 d RtnObj.Err(-5,"","删除标牌失败！")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

}
