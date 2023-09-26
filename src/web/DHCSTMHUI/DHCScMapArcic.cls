Import sqluser

Class web.DHCSTMHUI.DHCScMapArcic Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   保存
/// CreateDate: 2015-8-12
/// Table:INC_StkCat
/// Input:数据串
/// Output:     
/// Return：0 : 成功,其他：失败
/// w ##class(web.DHCSTMHUI.DHCScMapArcic).Save(^tmpxu)
ClassMethod Save(Params As %String, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	s RtnObj=##class(RtnObj).%New()

	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s MpRowId=Obj.%Get("RowId")
		s ScRowId=Obj.%Get("ScRowId")
		s ArRowId=Obj.%Get("ArRowId")
		s BiRowId=Obj.%Get("BiRowId")
		s SubTRowId=Obj.%Get("SubTRowId")
		s InSubTRowId=Obj.%Get("InSubTRowId")
		s OutSubTRowId=Obj.%Get("OutSubTRowId")
		s ASubTRowId=Obj.%Get("ASubTRowId")
		s MedRowId=Obj.%Get("MedRowId")
		s NewMedRowId=Obj.%Get("NewMedRowId")
		s ASTRowId=Obj.%Get("ASTRowId")
		s EffDateFlag=Obj.%Get("EffDateFlag")
		s PriorityRowId=Obj.%Get("PriorityRowId")
		s OwnFlag=Obj.%Get("OwnFlag")
		i (ScRowId="")  d RtnObj.Err(-2,"","请选择库存分类!","",0)  
		q:RtnObj.success'=0

		s stkcatdesc=$p(^INC("SC",ScRowId),"^",2)
		s mprowid=$O(^DHCMapScArcic(0,"SC",ScRowId,""))
		i ((mprowid'="")&&(MpRowId'=mprowid))  d RtnObj.Err(-3,"","库存分类"_stkcatdesc_"已存在!","",0)
		q:RtnObj.success'=0

		i MpRowId="" d
		.s obj=##class(User.DHCScMapArcic).%New()
		e  d
		.s obj=##class(User.DHCScMapArcic).%OpenId(MpRowId)
		.d obj.%Reload()
		d obj.MPINCSCDRSetObjectId(ScRowId)
		d obj.MPItemCatDRSetObjectId(ArRowId)
		d obj.MPARCBillSubDRSetObjectId(BiRowId)
		d obj.MPTarAcctDRSetObjectId(ASTRowId)
		d obj.MPTarEMCDRSetObjectId(ASubTRowId)
		d obj.MPTarInpatDRSetObjectId(InSubTRowId)
		d obj.MPTarMRDRSetObjectId(MedRowId)
		d obj.MPTarSubCatDRSetObjectId(SubTRowId)
		d obj.MPTarOutDRSetObjectId(OutSubTRowId)
		s obj.MPTarNMRDR=NewMedRowId
		s obj.MPEffDateFlag=EffDateFlag
		d obj.MPPriorityDRSetObjectId(PriorityRowId)
		s obj.MPOwnFlag=OwnFlag	
		s sc=obj.%Save()
		i $$$ISERR(sc) d RtnObj.Err(-1,"","保存失败!")
		q:RtnObj.success'=0
		s RowId=obj.%Id()
	}
	i RtnObj.success=0  d
	.tc 
	e  d
	.tro
	q RtnObj.Json()
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCHvMapArc","Query")
Query Query(Params As %String) As Query(ROWSPEC = "RowId,ScRowId,ScDescription,ArRowId,ArDescription,BiRowId,BiDescription,SubTRowId,SubTDescription,InSubTRowId,InSubTDescription,ASTRowId,ASTDescription,MedRowId,MedDescription,ASubTRowId,ASubTDescription,OutSubTRowId,OutSubTDescription,NewMedRowId,NewMedDescription,EffDateFlag,PriorityRowId,PriorityDescription,OwnFlag") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s StrSql="select MP_RowId,MP_INCSC_DR,MP_INCSC_DR->INCSC_Desc,MP_ItemCat_DR,MP_ItemCat_DR->ARCIC_Desc,"_
		"MP_ARCBillSub_DR,MP_ARCBillSub_DR->ARCSG_Desc,MP_TarSubCat_DR,MP_TarSubCat_DR->TARSC_Desc,"_
		"MP_TarInpat_DR,MP_TarInpat_DR->TARIC_Desc,MP_TarAcct_DR,MP_TarAcct_DR->TARAC_Desc,MP_TarMR_DR,MP_TarMR_DR->TARMC_Desc,"_
		"MP_TarEMC_DR,MP_TarEMC_DR->TAREC_Desc,MP_TarOut_DR,MP_TarOut_DR->TAROC_Desc,MP_TarNMR_DR,MP_EffDateFlag,"_
		"MP_Priority_DR,MP_Priority_DR->OECPR_Desc,MP_OwnFlag "_
		" from DHC_ScMapArcic"	
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	d result.Execute()
	While(result.Next())
	{
		s RowId=result.Data("MP_RowId")
		s ScRowId=result.Data("MP_INCSC_DR")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_StkCat",ScRowId,gHospId)
		continue:ShowDataFlag="N"
		s ScDescription=result.Data("INCSC_Desc")
		s ArRowId=result.Data("MP_ItemCat_DR")
		s ArDescription=result.Data("ARCIC_Desc")
		s BiRowId=result.Data("MP_ARCBillSub_DR")
		s BiDescription=result.Data("ARCSG_Desc")
		s SubTRowId=result.Data("MP_TarSubCat_DR")
		s SubTDescription=result.Data("TARSC_Desc")
		s InSubTRowId=result.Data("MP_TarInpat_DR")
		s InSubTDescription=result.Data("TARIC_Desc")
		s ASTRowId=result.Data("MP_TarAcct_DR")
		s ASTDescription=result.Data("TARAC_Desc")
		s MedRowId=result.Data("MP_TarMR_DR")
		s MedDescription=result.Data("TARMC_Desc")
		s ASubTRowId=result.Data("MP_TarEMC_DR")
		s ASubTDescription=result.Data("TAREC_Desc")
		s OutSubTRowId=result.Data("MP_TarOut_DR")
		s OutSubTDescription=result.Data("TAROC_Desc")
		s NewMedRowId=result.Data("MP_TarNMR_DR")
		s NewMedDescription=""
		s:NewMedRowId'="" NewMedDescription=$p(^DHCTarC("MCNew",NewMedRowId),"^",2)
		s EffDateFlag=result.Data("MP_EffDateFlag")
		s PriorityRowId=result.Data("MP_Priority_DR")
		s PriorityDescription=result.Data("OECPR_Desc")
		s OwnFlag=result.Data("MP_OwnFlag")
		d OutPutRow
	}
	d result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ScRowId,ScDescription,ArRowId,ArDescription,BiRowId,BiDescription,SubTRowId,SubTDescription,InSubTRowId,
	InSubTDescription,ASTRowId,ASTDescription,MedRowId,MedDescription,ASubTRowId,ASubTDescription,OutSubTRowId,OutSubTDescription,NewMedRowId,
	NewMedDescription,EffDateFlag,PriorityRowId,PriorityDescription,OwnFlag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)  
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj="" 
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		continue:RtnObj.success<0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

ClassMethod Delete(RowId As %String) As RtnObj
{
	n (RowId)
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	i RowId="" q RtnObj.Err(-2,"",MethodName_":参数错误")
	&sql(Delete from DHC_ScMapArcic where MP_RowId=:RowId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-3,"",MethodName_":删除数据失败","{RowId:"_RowId_"}")
	q:RtnObj.success<0 RtnObj

	q RtnObj
}

/// Description:根据库存分类,获取映射的医嘱项,计费项等信息
/// Creator:	wangjiabin 
/// CreateDate:	2017-01-13
/// Input:		库存分类rowid
/// Output:		json
/// w ##class(web.DHCSTMHUI.DHCScMapArcic).GetMapInfo(5)
ClassMethod GetMapInfo(Incsc As %String) As %Library.String
{
	n (Incsc)
	q:Incsc="" ""
	&sql(select MP_RowId,MP_INCSC_DR,MP_INCSC_DR->INCSC_Desc,MP_ItemCat_DR,MP_ItemCat_DR->ARCIC_Desc,
		MP_ARCBillSub_DR,MP_ARCBillSub_DR->ARCSG_Desc,MP_TarSubCat_DR,MP_TarSubCat_DR->TARSC_Desc,
		MP_TarInpat_DR,MP_TarInpat_DR->TARIC_Desc,MP_TarAcct_DR,MP_TarAcct_DR->TARAC_Desc,MP_TarMR_DR,MP_TarMR_DR->TARMC_Desc,
		MP_TarEMC_DR,MP_TarEMC_DR->TAREC_Desc,MP_TarOut_DR,MP_TarOut_DR->TAROC_Desc,MP_TarNMR_DR,
		MP_EffDateFlag,MP_Priority_DR,MP_Priority_DR->OECPR_Desc,MP_OwnFlag 
	into
		MpRowId,ScRowId,ScDescription,ArRowId,ArDescription,
		BiRowId,BiDescription,SubTRowId,SubTDescription,
		InSubTRowId,InSubTDescription,ASTRowId,ASTDescription,MedRowId,MedDescription,
		ASubTRowId,ASubTDescription,OutSubTRowId,OutSubTDescription,NewMedRowId,
		EffDateFlag,PriorityRowId,PriorityDescription,OwnFlag 
	from DHC_ScMapArcic where MP_INCSC_DR=:Incsc)
	q:SQLCODE'=0 ""
	
	s NewMedDescription=$S(NewMedRowId'="":$p(^DHCTarC("MCNew",NewMedRowId),"^",2),1:"")
	s OrdCatId=$s(ArRowId'="":$p(^ARC("IC",ArRowId),"^",8),1:"")
	s OrdCatDescription=$s(OrdCatId'="":$p(^OEC("ORCAT",OrdCatId),"^",2),1:"")	;医嘱大类
	s BillCatId=$p(BiRowId,"||",1)
	s BillCatDescription=$s(BillCatId'="":$p(^ARCBG(BillCatId),"^",2),1:"")		;费用大类
	
	s Data=MpRowId_"^"_ScRowId_"^"_ScDescription_"^"_ArRowId_"^"_ArDescription
		_"^"_BiRowId_"^"_BiDescription_"^"_SubTRowId_"^"_SubTDescription_"^"_InSubTRowId
		_"^"_InSubTDescription_"^"_OutSubTRowId_"^"_OutSubTDescription_"^"_ASubTRowId_"^"_ASubTDescription
		_"^"_MedRowId_"^"_MedDescription_"^"_ASTRowId_"^"_ASTDescription_"^"_NewMedRowId
		_"^"_NewMedDescription_"^"_OrdCatId_"^"_OrdCatDescription_"^"_BillCatId_"^"_BillCatDescription
		_"^"_EffDateFlag_"^"_PriorityRowId_"^"_PriorityDescription_"^"_OwnFlag
	
	s TitleStr="MpRowId^ScRowId^ScDescription^ArRowId^ArDescription"
		_"^BiRowId^BiDescription^SubTRowId^SubTDescription^InSubTRowId"
		_"^InSubTDescription^OutSubTRowId^OutSubTDescription^ASubTRowId^ASubTDescription"
		_"^MedRowId^MedDescription^ASTRowId^ASTDescription^NewMedRowId"
		_"^NewMedDescription^OrdCatId^OrdCatDescription^BillCatId^BillCatDescription"
		_"^EffDateFlag^PriorityRowId^PriorityDescription^OwnFlag"
	s result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,TitleStr)
	q result
}

}
