Import sqluser

Class web.DHCSTMHUI.DHCHvMapArc Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// w ##class(web.DHCSTMHUI.DHCHvMapArc).GetItem("Y")
ClassMethod GetItem(HvFlag As %String, Params As %String) As %Library.String
{
	n (HvFlag,Params,%session)
	q:HvFlag="" ""
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	//s HMARowId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",HvFlag,"DHC_HvMapArc",gHospId)
	s HMARowId=""
	&sql(select %ID into :HMARowId from DHC_HvMapArc where HMA_Hosp_DR=:gHospId and HMA_HvFlag=:HvFlag)
	q:HMARowId="" ""
	s ItemCatDR=$p(^DHCHVMAPARC(HMARowId),"^",2)
	s ARCBillSubDR=$p(^DHCHVMAPARC(HMARowId),"^",3)
	s TarSubCatDR=$p(^DHCHVMAPARC(HMARowId),"^",4)
	s TarInpatDR=$p(^DHCHVMAPARC(HMARowId),"^",5)
	s TarOutDR=$p(^DHCHVMAPARC(HMARowId),"^",6)
	s TarEMCDR=$p(^DHCHVMAPARC(HMARowId),"^",7)
	s TarMRDR=$p(^DHCHVMAPARC(HMARowId),"^",8)
	s TarNMRDR=$p(^DHCHVMAPARC(HMARowId),"^",9)
	s TarAcctDR=$p(^DHCHVMAPARC(HMARowId),"^",10)

	s (ArcSubCat,OrdCatId,OrdCat,BillSubCat,BillCat,TarSubCatDesc,TarAcctDesc,TarMRDesc,TarInpatDesc,TarOutDesc,TarEMCDesc,TarNMRDesc)=""
	i ItemCatDR'="" s ArcSubCat=$p(^ARC("IC",ItemCatDR),"^",2) ;医嘱子类
	i ItemCatDR'="" s OrdCatId=$p(^ARC("IC",ItemCatDR),"^",8)
	i OrdCatId'="" s OrdCat=$p(^OEC("ORCAT",OrdCatId),"^",2)    ;医嘱大类
	i ARCBillSubDR'="" s BillSubCat=$p(^ARCBG(+ARCBillSubDR,"SG",$p(ARCBillSubDR,"||",2)),"^",2)    ;收费子类
	i ARCBillSubDR'="" s BillCat=$p(^ARCBG(+ARCBillSubDR),"^",2)    ;收费大类
	i TarSubCatDR'="" s TarSubCatDesc=$p(^DHCTarC("SC",TarSubCatDR),"^",2)
	i TarAcctDR'="" s TarAcctDesc=$p(^DHCTarC("AC",TarAcctDR),"^",2)
	i TarMRDR'="" s TarMRDesc=$p(^DHCTarC("MC",TarMRDR),"^",2)
	i TarInpatDR'="" s TarInpatDesc=$p(^DHCTarC("IC",TarInpatDR),"^",2)
	i TarOutDR'="" s TarOutDesc=$p(^DHCTarC("OC",TarOutDR),"^",2)
	i TarEMCDR'="" s TarEMCDesc=$p(^DHCTarC("EC",TarEMCDR),"^",2)
	i TarNMRDR'="" s TarNMRDesc=$p(^DHCTarC("MCNew",TarNMRDR),"^",2)

	s Data=OrdCatId_"^"_OrdCat_"^"_ItemCatDR_"^"_ArcSubCat_"^"_BillCat
		_"^"_ARCBillSubDR_"^"_BillSubCat_"^"_TarSubCatDR_"^"_TarSubCatDesc_"^"_TarInpatDR
		_"^"_TarInpatDesc_"^"_TarAcctDR_"^"_TarAcctDesc_"^"_TarMRDR_"^"_TarMRDesc
		_"^"_TarEMCDR_"^"_TarEMCDesc_"^"_TarOutDR_"^"_TarOutDesc_"^"_TarNMRDR_"^"_TarNMRDesc
	q Data
}

/// 新版本程序
/// Descript:	保存/更新信息
/// Creater:	zx
/// CreateDate:	2018-08-27
/// Table:		DHC_HvMapArc
/// Input:		数据Json串
/// Return：	RtnObj Json
/// w ##class(web.DHCSTMHUI.DHCHvMapArc).Save("[{""HvRowId"":""Y"",""ArRowId"":""77"",""BiRowId"":""2||1"",""SubTRowId"":""4"",""InSubTRowId"":""4"",""OutSubTRowId"":"""",""ASubTRowId"":"""",""MedRowId"":"""",""NewMedRowId"":"""",""ASTRowId"":""""}]")
ClassMethod Save(Params, Main As %String) As %Library.String
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
		s RowId=Obj.%Get("RowId")
		s HvRowId=Obj.%Get("HvRowId")
		s ArRowId=Obj.%Get("ArRowId")
		s BiRowId=Obj.%Get("BiRowId")
		s SubTRowId=Obj.%Get("SubTRowId")
		s InSubTRowId=Obj.%Get("InSubTRowId")
		s OutSubTRowId=Obj.%Get("OutSubTRowId")
		s ASubTRowId=Obj.%Get("ASubTRowId")
		s MedRowId=Obj.%Get("MedRowId")
		s NewMedRowId=Obj.%Get("NewMedRowId")
		s ASTRowId=Obj.%Get("ASTRowId")
		i (HvRowId="")  d RtnObj.Err(-2,"","必填项不能为空!","",0)  
		q:RtnObj.success'=0
		
		;s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",HvRowId,"DHC_HvMapArc",gHospId,RowId)
		s tmpRowid=""
		&sql(select %ID into :tmpRowid from DHC_HvMapArc
		where HMA_HvFlag=:HvRowId and HMA_RowID<>nvl(:RowId,'') and HMA_Hosp_DR=:gHospId)
		i tmpRowid'="" d RtnObj.Err(-2,RowId," 高值标志重复!","",0)
		continue:RtnObj.success<0
		
		i RowId'=""  d
		.s RtnObj=..Update(RowId,HvRowId,ArRowId,BiRowId,SubTRowId,InSubTRowId,OutSubTRowId,ASubTRowId,MedRowId,NewMedRowId,ASTRowId)
		e  d
		.s RtnObj=..Insert(HvRowId,ArRowId,BiRowId,SubTRowId,InSubTRowId,OutSubTRowId,ASubTRowId,MedRowId,NewMedRowId,ASTRowId,gHospId)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	插入高值关联医嘱收费信息
/// Creater:	zx
/// CreateDate:	2018-08-27
/// Table:		DHC_HvMapArc
/// Input:		
/// Output:		
/// Return：	RtnObj
ClassMethod Insert(HvRowId As %String, ArRowId As %String, BiRowId As %String, SubTRowId As %String, InSubTRowId As %String, OutSubTRowId As %String, ASubTRowId As %String, MedRowId As %String, NewMedRowId As %String, ASTRowId As %String, gHospId) As RtnObj [ Private ]
{
	n (HvRowId,ArRowId,BiRowId,SubTRowId,InSubTRowId,OutSubTRowId,ASubTRowId,MedRowId,NewMedRowId,ASTRowId,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()	
	s JsonStr=HvRowId_","_ArRowId_","_BiRowId_","_SubTRowId_","_InSubTRowId_","_OutSubTRowId_","_ASubTRowId_","_MedRowId_","_NewMedRowId_","_ASTRowId
	&sql(INSERT INTO DHC_HvMapArc (HMA_HvFlag, HMA_ItemCat_DR, HMA_ARCBillSub_DR, HMA_TarSubCat_DR,
	HMA_TarInpat_DR,HMA_TarOut_DR,HMA_TarEMC_DR,HMA_TarMR_DR,HMA_TarNMR_DR,HMA_TarAcct_DR,HMA_Hosp_DR) 
	VALUES(:HvRowId,:ArRowId,:BiRowId,:SubTRowId,
	:InSubTRowId,:OutSubTRowId,:ASubTRowId,:MedRowId,:NewMedRowId,:ASTRowId,:gHospId))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.//保存医院关联
	.;s RowId=%ROWID
	.;s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_HvMapArc",RowId,gHospId)
	.;i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	.;q:RtnObj.success'=0
	.s RtnObj=##class(Log).SaveLog("DHC_HvMapArc","User.DHCHvMapArc","高值关联医嘱收费信息",$SYSTEM.SQL.GetROWID(),"","A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新信息
/// Creater:	zx
/// CreateDate:	2018-08-27
/// Table:		DHC_HvMapArc
/// Input:		
/// Return：	RtnObj
ClassMethod Update(RowId As %String, HvRowId As %String, ArRowId As %String, BiRowId As %String, SubTRowId As %String, InSubTRowId As %String, OutSubTRowId As %String, ASubTRowId As %String, MedRowId As %String, NewMedRowId As %String, ASTRowId As %String) As RtnObj [ Private ]
{
	n (RowId,HvRowId,ArRowId,BiRowId,SubTRowId,InSubTRowId,OutSubTRowId,ASubTRowId,MedRowId,NewMedRowId,ASTRowId,%session)
	s RtnObj=##class(RtnObj).%New()
	&sql(SELECT HMA_HvFlag,HMA_ItemCat_DR,HMA_ItemCat_DR,HMA_ARCBillSub_DR,HMA_TarSubCat_DR
		HMA_TarInpat_DR,HMA_TarOut_DR,HMA_TarEMC_DR,HMA_TarMR_DR,HMA_TarNMR_DR,HMA_TarAcct_DR
		into :OldHvRowId,:OldArRowId,:OldBiRowId,:OldSubTRowId,:OldInSubTRowId,
		:OldOutSubTRowId,:OldASubTRowId,:OldMedRowId,:OldNewMedRowId,:OldASTRowId FROM DHC_HvMapArc WHERE HMA_RowId=:RowId)
	s OldJsonStr=OldHvRowId_","_OldArRowId_","_OldBiRowId_","_OldSubTRowId_","_OldInSubTRowId_","_OldOutSubTRowId_","_OldASubTRowId_","_OldMedRowId_","_OldNewMedRowId_","_OldASTRowId
	s JsonStr=HvRowId_","_ArRowId_","_BiRowId_","_SubTRowId_","_InSubTRowId_","_OutSubTRowId_","_ASubTRowId_","_MedRowId_","_NewMedRowId_","_ASTRowId

	&sql(UPDATE DHC_HvMapArc SET HMA_HvFlag=:HvRowId,HMA_ItemCat_DR=:ArRowId,HMA_ARCBillSub_DR=:BiRowId,HMA_TarSubCat_DR=:SubTRowId,
		HMA_TarInpat_DR=:InSubTRowId,HMA_TarOut_DR=:OutSubTRowId,HMA_TarEMC_DR=:ASubTRowId,
		HMA_TarMR_DR=:MedRowId,HMA_TarNMR_DR=:NewMedRowId,HMA_TarAcct_DR=:ASTRowId WHERE HMA_RowId=:RowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-5,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_HvMapArc","User.DHCHvMapArc","高值关联医嘱收费信息",RowId,"","U",JsonStr,OldJsonStr)
	q:RtnObj.success'=0 RtnObj

	q RtnObj
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
	&sql(DELETE from DHC_HvMapArc WHERE HMA_RowId=:RowId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-3,RowId,MethodName_":删除数据失败","{RowId:"_RowId_"}")
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCHvMapArc","Query")
Query Query(Params As %String) As Query(ROWSPEC = "RowId,HvRowId,HvDescription,ArRowId,ArDescription,BiRowId,BiDescription,SubTRowId,SubTDescription,InSubTRowId,InSubTDescription,ASTRowId,ASTDescription,MedRowId,MedDescription,ASubTRowId,ASubTDescription,OutSubTRowId,OutSubTDescription,NewMedRowId,NewMedDescription") [ SqlProc ]
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
	
	s StrSql="select HMA_RowId,HMA_HvFlag,(CASE HMA_HvFlag WHEN 'Y' THEN '是' WHEN 'N' THEN '否' end) as HvFlagDesc,HMA_ItemCat_DR,HMA_ItemCat_DR->ARCIC_Desc,"_
		"HMA_ARCBillSub_DR,HMA_ARCBillSub_DR->ARCSG_Desc,HMA_TarSubCat_DR,HMA_TarSubCat_DR->TARSC_Desc,"_
		"HMA_TarInpat_DR,HMA_TarInpat_DR->TARIC_Desc,HMA_TarAcct_DR,HMA_TarAcct_DR->TARAC_Desc,HMA_TarMR_DR,HMA_TarMR_DR->TARMC_Desc,"_
		"HMA_TarEMC_DR,HMA_TarEMC_DR->TAREC_Desc,HMA_TarOut_DR,HMA_TarOut_DR->TAROC_Desc,HMA_TarNMR_DR,HMA_Hosp_DR from DHC_HvMapArc"	
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	d result.Execute()
	While(result.Next())
	{
		s HMARowId=result.Data("HMA_RowId")
		//判断医院权限
		;s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_HvMapArc",HMARowId,gHospId)
		;continue:ShowDataFlag="N"
		s HvHospId=result.Data("HMA_Hosp_DR")
		continue:HvHospId'=gHospId
		s HvRowId=result.Data("HMA_HvFlag")
		s HvDescription=result.Data("HvFlagDesc")
		s ArRowId=result.Data("HMA_ItemCat_DR")
		s ArDescription=result.Data("ARCIC_Desc")
		s BiRowId=result.Data("HMA_ARCBillSub_DR")
		s BiDescription=result.Data("ARCSG_Desc")
		s SubTRowId=result.Data("HMA_TarSubCat_DR")
		s SubTDescription=result.Data("TARSC_Desc")
		s InSubTRowId=result.Data("HMA_TarInpat_DR")
		s InSubTDescription=result.Data("TARIC_Desc")
		s ASTRowId=result.Data("HMA_TarAcct_DR")
		s ASTDescription=result.Data("TARAC_Desc")
		s MedRowId=result.Data("HMA_TarMR_DR")
		s MedDescription=result.Data("TARMC_Desc")
		s ASubTRowId=result.Data("HMA_TarEMC_DR")
		s ASubTDescription=result.Data("TAREC_Desc")
		s OutSubTRowId=result.Data("HMA_TarOut_DR")
		s OutSubTDescription=result.Data("TAROC_Desc")
		s NewMedRowId=result.Data("HMA_TarNMR_DR")
		s NewMedDescription=""
		s:NewMedRowId'="" NewMedDescription=$p(^DHCTarC("MCNew",NewMedRowId),"^",2)
		d OutPutRow
	}
	d result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(HMARowId,HvRowId,HvDescription,ArRowId,ArDescription,BiRowId,BiDescription,SubTRowId,SubTDescription,InSubTRowId,InSubTDescription,ASTRowId,ASTDescription,MedRowId,MedDescription,ASubTRowId,ASubTDescription,OutSubTRowId,OutSubTDescription,NewMedRowId,NewMedDescription)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
