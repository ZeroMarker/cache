Import SQLUser

Class web.DHCBL.CT.itmmast Extends %RegisteredObject [ ProcedureBlock ]
{

/// 用于GetList()结果排序,返回sql语句
ClassMethod GetListSort(strSql As %String, sort As %String, dir As %String) As %String
{
	s strSort=""
	s sortField=""
	
	i sort'="" d
	.i sort="rowid" s sortField="ARCIM_RowId"
	.i sort="code" s sortField="ARCIM_Code"
	.i sort="desc" s sortField="ARCIM_Desc"
	
	i sortField'="" d
	.s dir=$ZCONVERT(dir,"U")
	.i (dir="DESC") || (dir="ASC") s strSort=" ORDER BY "_sortField_" "_dir
	.e  s strSort=" ORDER BY "_sortField_" DESC"
	e  d
	.s strSort=" ORDER BY %ID DESC"
	s strSql=strSql_strSort
	
	q strSql
}

/// 用于GetList(),执行sql并返回结果JSON串
ClassMethod GetListStrResult(strSql As %String, start As %String, limit As %String, callback As %String) As %String
{
	s result=""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	
	s count=0
	s strResult=""
	s end=start+limit
	
	While(result.Next())
	{
		Set tmprowid=result.Data("ARCIM_RowId")
		If (tmprowid'="") {
			s ord=$p(tmprowid,"||",1)
			s OrdSub=$p(tmprowid,"||",2)
			s rowid=$Piece(result.Data("ARCIM_RowId"),"||",1)
			s code=##class(ext.util.String).EvalJSON(result.Data("ARCIM_Code"))
			s desc=##class(ext.util.String).EvalJSON(result.Data("ARCIM_Desc"))
			s phcdName=##class(ext.util.String).EvalJSON(result.Data("PHCD_Name"))
			s phcdCode=##class(ext.util.String).EvalJSON(result.Data("PHCD_Code"))
			s billGroup=##class(ext.util.String).EvalJSON(result.Data("ARCBG_Code"))
			s billSub=##class(ext.util.String).EvalJSON(result.Data("ARCSG_Code"))
			s itemCat=##class(ext.util.String).EvalJSON(result.Data("ARCIC_Desc"))
			s ServMaterial=##class(ext.util.String).EvalJSON(result.Data("ARCIM_ServMaterial"))
			s billUnit=##class(ext.util.String).EvalJSON(result.Data("CTUOM_Desc"))
			s priority=##class(ext.util.String).EvalJSON(result.Data("OECPR_Desc"))
			s serviceGroup=##class(ext.util.String).EvalJSON(result.Data("SG_Desc"))
			s orderAbbrev=##class(ext.util.String).EvalJSON(result.Data("ARCIM_Abbrev"))
			
			s OrderOnItsOwn=##class(ext.util.String).EvalJSON(result.Data("ARCIM_OrderOnItsOwn"))
			s AllowStockCheck=##class(ext.util.String).EvalJSON(result.Data("ARCIM_AllowOrderWOStockCheck"))
			s EffDate=##class(ext.util.String).EvalJSON(result.Data("ARCIM_EffDate"))
			i EffDate'="" s EffDate=$zd(EffDate,3)
			s EffDateTo=##class(ext.util.String).EvalJSON(result.Data("ARCIM_EffDateTo"))
			i EffDateTo'="" s EffDateTo=$zd(EffDateTo,3)
			s rowid=##class(ext.util.String).EvalJSON(result.Data("ARCIM_RowId"))
			s ItemCatRowId=##class(ext.util.String).EvalJSON(result.Data("ARCIC_RowId"))
			s priorityRowId=##class(ext.util.String).EvalJSON(result.Data("OECPR_RowId"))
			s BillGroupRowid=##class(ext.util.String).EvalJSON(result.Data("ARCBG_RowId"))
			s billSubRowid=##class(ext.util.String).EvalJSON(result.Data("ARCSG_RowId"))
			s billunitRowid=##class(ext.util.String).EvalJSON(result.Data("CTUOM_RowId"))
			s serviceGroupRowid=##class(ext.util.String).EvalJSON(result.Data("SG_RowId"))
			
			Set OEMessag=""   //取医嘱备注
			For rnum=1:1:$G(^ARCIM(ord,OrdSub,"OEM",0))  Do
	    	.If OEMessag=""  Do
	    	..Set OEMessag=OEMessag_$G(^ARCIM(ord,OrdSub,"OEM",rnum))
	    	.Else  Do
	    	..;;Set OEMessag=OEMessag_"_$c(13,10)_"_$G(^ARCIM(ord,OrdSub,"OEM",rnum))
	    	..Set OEMessag=OEMessag_$G(^ARCIM(ord,OrdSub,"OEM",rnum))
			s OEMessage=##class(ext.util.String).EvalJSON(OEMessag)
			
			//去掉双引号
			//2013-5-16 by lisen
			s OEMessage=##class(web.BDP.util.String).Replace(OEMessage,$c(34), "")
		
			;If ServMaterial="S" Set ServMaterial="Service"
			;If ServMaterial="M" Set ServMaterial="Material"
			s count=count+1
			i (count>start) & (count<=end) d
		 	.i strResult'="" d
		 	..s strResult=strResult_",{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_""",""phcdName"":"""_phcdName_""",""phcdCode"":"""_phcdCode_""",""billGroup"":"""_billGroup_""",""billSub"":"""_billSub_""",""itemCat"":"""_itemCat_""",""serviceGroup"":"""_serviceGroup_""",""billUnit"":"""_billUnit_""",""priority"":"""_priority_""",""ServMaterial"":"""_ServMaterial_""",""orderAbbrev"":"""_orderAbbrev_""",""rowid"":"""_rowid_""",""OrderOnItsOwn"":"""_OrderOnItsOwn_""",""AllowStockCheck"":"""_AllowStockCheck_""",""EffDate"":"""_EffDate_""",""EffDateTo"":"""_EffDateTo_""",""OEMessage"":"""_OEMessage_""",""ItemCatRowId"":"""_ItemCatRowId_""",""priorityRowId"":"""_priorityRowId_""",""BillGroupRowid"":"""_BillGroupRowid_""",""billSubRowid"":"""_billSubRowid_""",""billunitRowid"":"""_billunitRowid_""",""serviceGroupRowid"":"""_serviceGroupRowid_"""}"
		 	.e  d
		 	..s strResult="{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_""",""phcdName"":"""_phcdName_""",""phcdCode"":"""_phcdCode_""",""billGroup"":"""_billGroup_""",""billSub"":"""_billSub_""",""itemCat"":"""_itemCat_""",""serviceGroup"":"""_serviceGroup_""",""billUnit"":"""_billUnit_""",""priority"":"""_priority_""",""ServMaterial"":"""_ServMaterial_""",""orderAbbrev"":"""_orderAbbrev_""",""rowid"":"""_rowid_""",""OrderOnItsOwn"":"""_OrderOnItsOwn_""",""AllowStockCheck"":"""_AllowStockCheck_""",""EffDate"":"""_EffDate_""",""EffDateTo"":"""_EffDateTo_""",""OEMessage"":"""_OEMessage_""",""ItemCatRowId"":"""_ItemCatRowId_""",""priorityRowId"":"""_priorityRowId_""",""BillGroupRowid"":"""_BillGroupRowid_""",""billSubRowid"":"""_billSubRowid_""",""billunitRowid"":"""_billunitRowid_""",""serviceGroupRowid"":"""_serviceGroupRowid_"""}"
		}
	}
	d result.Close()
	
	i callback'="" d
	.s strResult=callback_"({""totalCount"":"""_count_""",""results"":["_strResult_"]});"
	e  d
	.s strResult="{""totalCount"":"""_count_""",""results"":["_strResult_"]}"
	
	q strResult
}

/// 获取医嘱项数据
/// 单条件查询
/// w ##class(web.DHCBL.CT.itmmast).GetList(0,2,"code","ASC","","bl","","","","","","","")
/// 2013-5-22 modified by lisen
ClassMethod GetList(start, limit, sort, dir, callback, ID, P1, P2, P3, P4, P5, P6, P7, P8) As %String
{
	Set FindUserGroupDR=%session.Get("LOGON.GROUPID") //查询人所在安全组Dr0730
	
	If P1'="" Do  //代码P1
	.Set P1=$$ALPHAUP^SSUTIL4(P1)
	.Set ConExp="'%"_P1_"%'"
	.Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_ServiceGroup_DR->SG_RowId,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId  FROM ARC_ItmMast where (arcim_code like "_"  "_ConExp_")"
	
	If P2'="" Do  //描述P2
	.;;Set P2=$$ALPHAUP^SSUTIL4(P2)
	.Set ConExp="'%"_P2_"%'"
	.Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_ServiceGroup_DR->SG_RowId,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId  FROM ARC_ItmMast where (ARCIM_Desc like "_"  "_ConExp_")"	
	
	If P3'="" Do  //药物P3
	.Set P3=$$ALPHAUP^SSUTIL4(P3)
	.Set ConExp="'%"_P3_"%'"
	.Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_ServiceGroup_DR->SG_RowId,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId  FROM ARC_ItmMast where (ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code like "_"  "_ConExp_")"
	
	If P4'="" Do  //别名P4
	.Set P4=$$ALPHAUP^SSUTIL4(P4)
	.Set ConExp="'%"_P4_"%'"
    .Set strSql="SELECT ALIAS_ARCIM_DR->ARCIM_RowId,ALIAS_ARCIM_DR->ARCIM_Code,ALIAS_ARCIM_DR->ARCIM_Desc,ALIAS_ARCIM_DR->ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ALIAS_ARCIM_DR->ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ALIAS_ARCIM_DR->ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ALIAS_ARCIM_DR->ARCIM_BillSub_DR->ARCSG_Code,ALIAS_ARCIM_DR->ARCIM_ItemCat_DR->ARCIC_Desc,ALIAS_ARCIM_DR->ARCIM_BillingUOM_DR->CTUOM_RowId,ALIAS_ARCIM_DR->ARCIM_ServMaterial,ALIAS_ARCIM_DR->ARCIM_BillingUOM_DR->CTUOM_Desc,ALIAS_ARCIM_DR->ARCIM_ServiceGroup_DR->SG_RowId,ALIAS_ARCIM_DR->ARCIM_DefPriority_DR->OECPR_Desc,ALIAS_ARCIM_DR->ARCIM_DefPriority_DR->OECPR_RowId,ALIAS_ARCIM_DR->ARCIM_ServiceGroup_DR->SG_Desc,ALIAS_ARCIM_DR->ARCIM_Abbrev,ALIAS_ARCIM_DR->ARCIM_OrderOnItsOwn,ALIAS_ARCIM_DR->ARCIM_AllowOrderWOStockCheck,ALIAS_ARCIM_DR->ARCIM_OEMessage,ALIAS_ARCIM_DR->ARCIM_EffDate,ALIAS_ARCIM_DR->ARCIM_EffDateTo,ALIAS_ARCIM_DR->ARCIM_ItemCat_DR->ARCIC_RowId,ALIAS_ARCIM_DR->ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ALIAS_ARCIM_DR->ARCIM_BillSub_DR->ARCSG_RowId  FROM ARC_Alias  where ("_" (ALIAS_Text like"_"  "_ConExp_")"_"or"_" (UPPER(ALIAS_Text) like"_"  "_ConExp_")"_")"
    
	If P5'="" Do  //记账组P5与记账子组P6
	.If P6'="" Do
	..Set ConExp=P6
	..Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_ServiceGroup_DR->SG_RowId  FROM ARC_ItmMast where (ARCIM_BillSub_DR="_""_ConExp_")"		
	.Else  Do
	.Set ConExp=P5
	.Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_ServiceGroup_DR->SG_RowId   FROM ARC_ItmMast where (ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef="_""_ConExp_")"		
	
	If P7'="" Do  //医嘱子类P7
	.Set ConExp=P7
	.Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_ServiceGroup_DR->SG_RowId   FROM ARC_ItmMast where (ARCIM_ItemCat_DR="_""_ConExp_")"
	
	If P8'="" Do  //服务组P8
	.Set ConExp=P8
	.Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_ServiceGroup_DR->SG_RowId   FROM ARC_ItmMast where (ARCIM_ServiceGroup_DR="_""_ConExp_")"
	
	If (P1="")&(P2="")&(P3="")&(P4="")&(P5="")&(P6="")&(P7="")&(P8="") {
		if (FindUserGroupDR=1) {
			Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_ServiceGroup_DR->SG_RowId  FROM ARC_ItmMast"
		}
		else {
			Set ConExp="("_"("_"ARCIM_ItemCat_DR in (select SSORD_OrdSubCategory from SS_GroupOrderCategory where SSORD_ParRef="_FindUserGroupDR_")) or "_"("_"ARCIM_ItemCat_DR->ARCIC_OrdCat_DR in (select SSORD_OrdCat_DR from SS_GroupOrderCategory where SSORD_ParRef="_FindUserGroupDR_"))"_")"
			Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_ServiceGroup_DR->SG_RowId  FROM ARC_ItmMast  where  "_ConExp	
		}
	}
	else {
		if (FindUserGroupDR=1) {
		}
		else {
			Set ConExp2="("_"("_"ARCIM_ItemCat_DR in (select SSORD_OrdSubCategory from SS_GroupOrderCategory where SSORD_ParRef="_FindUserGroupDR_")) or "_"("_"ARCIM_ItemCat_DR->ARCIC_OrdCat_DR in (select SSORD_OrdCat_DR from SS_GroupOrderCategory where SSORD_ParRef="_FindUserGroupDR_"))"_")"
			Set strSql=strSql_" and "_ConExp2
		}
	}
	
	IF ID'="" Do
	.Set strSql="SELECT ARCIM_RowId,ARCIM_Code,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Name,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Code,ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_RowId,ARCIM_BillSub_DR->ARCSG_Code,ARCIM_BillSub_DR->ARCSG_RowId,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_ServMaterial,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_BillingUOM_DR->CTUOM_RowId,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_DefPriority_DR->OECPR_RowId,ARCIM_ServiceGroup_DR->SG_Desc,ARCIM_ServiceGroup_DR->SG_RowId,ARCIM_Abbrev,ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_OEMessage,ARCIM_EffDate,ARCIM_EffDateTo,ARCIM_ItemCat_DR->ARCIC_RowId  FROM ARC_ItmMast where (ARCIM_RowId='"_ID_"')"
	
	//调用排序,返回sql语句
	s strSql=..GetListSort(strSql,sort,dir)
	
	//执行sql并返回查询结果
	s strResult=..GetListStrResult(strSql,start,limit,callback)
	
	q strResult
}

/// 删除时验证数据是否被引用
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="0^未被引用可删除!"
	
	s ITMARCIMDR=$p(id,"||",1)
 	s ITMChildsub=$p(id,"||",2)
 	
	//1 是否被"安全组-医嘱子类明细"引用
	s found1=0
 	s sub1="" f  s sub1=$o(^SSU("SSGRP",sub1)) q:sub1=""  q:found1  d
 	.s sub2="" f  s sub2=$o(^SSU("SSGRP",sub1,"SSORD",sub2)) q:sub2=""  q:found1  d
 	..i ($d(^SSU("SSGRP",sub1,"SSORD",sub2,"ITM",0,"ARCIM",id))) s found1=1
 	i (found1) s return="1^在(安全组-医嘱子类明细)表里被引用,不能删除!"
 	
	//2 是否被"科室/部门/病区-床位类型"引用
	s found2=0
 	s sub1="" f  s sub1=$o(^PAC("BEDTP",sub1)) q:sub1=""  q:found2  d
 	.i ($p($g(^PAC("BEDTP",sub1)),"^",4)=id) s found2=1
 	i (found2) s return="1^在(科室/部门/病区-床位类型)表里被引用,不能删除!"
 	
	//3 是否被"科室/部门/病区-房间类型"引用
	s found3=0
 	s sub1="" f  s sub1=$o(^PAC("ROOMT",sub1)) q:sub1=""  q:found3  d
 	.i ($p($g(^PAC("ROOMT",sub1)),"^",3)=id) s found3=1
 	i (found3) s return="1^在(科室/部门/病区-房间类型)表里被引用,不能删除!"
 	
	//4 是否被"库存项"引用
	s found4=0
 	s sub1="" f  s sub1=$o(^INCI(sub1)) q:sub1=""  q:found4  d
 	.i ($p($g(^INCI(sub1,1)),"^",3)=id) s found4=1
 	i (found4) s return="1^在(库存项)表里被引用,不能删除!"
 	
	//5 是否被"麻醉剂"引用
	s found5=0
 	s sub1="" f  s sub1=$o(^ORC("ANAGN",sub1)) q:sub1=""  q:found5  d
 	.i ($p($g(^ORC("ANAGN",sub1)),"^",3)=id) s found5=1
 	i (found5) s return="1^在(麻醉剂)表里被引用,不能删除!"
 	
	//6 是否被"手术/过程"或"手术关联医嘱项"引用
	i ($d(^ORC("OPER",0,"ARCIM",id)))  s return="1^在(手术/过程)或(手术关联医嘱项)表里被引用,不能删除!"
	
	//7 是否被"医嘱项收费项关联"引用
	s found7=0
 	s sub1="" f  s sub1=$o(^DHCOLT(sub1)) q:sub1=""  q:found7  d
 	.i ($p($g(^DHCOLT(sub1)),"^",1)=id) s found7=1
 	i (found7) s return="1^在(医嘱项收费项关联)表里被引用,不能删除!"
 	
	//8 是否被"医嘱项-别名"引用
	i ($d(^ARC("ALIAS",0,"ARCIM",id)))  s return="1^在(医嘱项-别名)表里被引用,不能删除!"
	
 	q return
}

/// 删除医嘱项
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	//验证是否被引用
 	s re=..GetRefFlag(id)
	if ($p(re,"^",1)){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		s eobj = ##class(web.Entity.CT.ARCItmMast).%New()
		s eobj.ARCIMRowId = id
		s pre=$p(id,"||",1)
		s sub=$p(id,"||",2)
		s eobj.ARCIMCode=$p($g(^ARCIM(pre,sub,1)),"^",1)
		s eobj.ARCIMDesc=$p($g(^ARCIM(pre,sub,1)),"^",2)
		
		s sc=##class(User.ARCItmMast).%DeleteId(id)
		if $$$ISOK(sc)
		{
			s result= "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmMast","User.ARCItmMast","医嘱项",id,eobj.ARCIMDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	}
	q result
}

/// 药物查找
/// 2013-8-22 by lisen
Query GetDrugList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCDRowId:%String,PHCDCode:%String,PHCDName:%String")
{
}

ClassMethod GetDrugListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCDRowId=rowid
		s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
		s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s PHCDRowId=0
		f  s PHCDRowId=$o(^PHCD(PHCDRowId)) q:(PHCDRowId="")||(PHCDRowId="DF_Form")  d
		.s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
		.s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)
		.i ($ZCONVERT(PHCDCode,"U")[code)&($ZCONVERT(PHCDName,"U")[desc) d
		..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCDRowId,PHCDCode,PHCDName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDrugListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDrugListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 别名 ARC_Alias
/// 2013-8-27 by lisen
Query FindOrderAliasList(ParRef As %String) As %Query(ROWSPEC = "ALIASRowId:%String,ALIASText:%String,ALIASDateFrom:%String,ALIASDateTo:%String")
{
}

ClassMethod FindOrderAliasListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ALIASRowId=0
	f  s ALIASRowId=$o(^ARC("ALIAS",ALIASRowId)) q:ALIASRowId=""  d
	.s ALIASARCIMDR=$p($g(^ARC("ALIAS",ALIASRowId)),"^",1)
	.s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
	.s ALIASDateFrom=$p($g(^ARC("ALIAS",ALIASRowId)),"^",12)
	.s ALIASDateTo=$p($g(^ARC("ALIAS",ALIASRowId)),"^",13)
	.s:ALIASDateFrom'="" ALIASDateFrom=$zd(ALIASDateFrom,1) //转换日期格式
	.s:ALIASDateTo'="" ALIASDateTo=$zd(ALIASDateTo,1) //转换日期格式
	.i (ParRef=ALIASARCIMDR) d
	..d OutputRow
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ALIASRowId,ALIASText,ALIASDateFrom,ALIASDateTo)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindOrderAliasListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderAliasListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrderAliasListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderAliasListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 检验外码关联 ARC_ItemExternalCodes
/// 2013-8-27 by lisen
Query FindExternalCodeList(ParRef As %String) As %Query(ROWSPEC = "EXTRowId,EXTCode,EXTDesc,ctlocdesc,DefaultReceive,DEfaultSend,EXTDateFrom,EXTDateTo,EXTCTLOCDR")
{
}

ClassMethod FindExternalCodeListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s parref=$p(ParRef,"||",1)
	s version=$p(ParRef,"||",2)
	s rowid=0
	f  s rowid=$o(^ARCIM(parref,version,"EXT",rowid)) q:rowid=""  d
	.s EXTRowId=parref_"||"_version_"||"_rowid
	.s EXTCode=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",4)
	.s EXTDesc=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",6)
	.s EXTCTLOCDR=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",8)
	.s ctlocdesc=""
	.s:EXTCTLOCDR'="" ctlocdesc=$p($g(^CTLOC(EXTCTLOCDR)),"^",2) //获取科室描述
	.s DefaultReceive=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",10)
	.s DEfaultSend=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",9)
	.s EXTDateFrom=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",1)
	.s EXTDateTo=$p($g(^ARCIM(parref,version,"EXT",rowid)),"^",2)
	.s:EXTDateFrom'="" EXTDateFrom=$zd(EXTDateFrom,1) //转换日期格式
	.s:EXTDateTo'="" EXTDateTo=$zd(EXTDateTo,1) //转换日期格式
	.d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(EXTRowId,EXTCode,EXTDesc,ctlocdesc,DefaultReceive,DEfaultSend,EXTDateFrom,EXTDateTo,EXTCTLOCDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindExternalCodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExternalCodeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindExternalCodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExternalCodeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*
Query FindOrderRecLocList(query As %String) As %SQLQuery(CONTAINID = 1)
{
select ARCRL_RowId as ARCRLRowId ,ARCRL_OrdLoc_DR->ctloc_desc as ARCRLOrdLocDesc,ARCRL_RecLoc_DR->ctloc_desc as ARCRLRecLocDesc,
ARCRL_OrderPriority_DR->OECPR_Desc as ARCRLOrderPriorityDesc,ARCRL_DefaultFlag as ARCRLDefaultFlag,
  TO_CHAR(ARCRL_DateFrom,'MM/DD/YYYY') as ARCRLDateFrom,TO_CHAR(ARCRL_DateTo,'MM/DD/YYYY') as ARCRLDateTo,
  TO_CHAR({fn CONVERT(ARCRL_TimeFrom,SQL_TIMESTAMP)},'HH24:MI:SS') as ARCRLTimeFrom,TO_CHAR({fn CONVERT(ARCRL_TimeTo,SQL_TIMESTAMP)},'HH24:MI:SS') as ARCRLTimeTo,
  ARCRL_OrdLoc_DR as ARCRLOrdLocDR,ARCRL_RecLoc_DR as ARCRLRecLocDR,ARCRL_OrderPriority_DR as ARCRLOrderPriorityDR 
  from  ARC_ItmRecLoc  where ARCRL_ARCIM_DR=:query
}*/
/// 医嘱项接收科室 ARC_ItmRecLoc
/// 2013-8-27 by lisen
Query FindOrderRecLocList(ParRef As %String) As %Query(ROWSPEC = "ARCRLRowId,ARCRLOrdLocDR,ARCRLOrdLocDesc,ARCRLRecLocDR,ARCRLRecLocDesc,ARCRLOrderPriorityDR,ARCRLOrderPriorityDesc,ARCRLDefaultFlag,ARCRLDateFrom,ARCRLDateTo,ARCRLTimeFrom,ARCRLTimeTo")
{
}

ClassMethod FindOrderRecLocListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s parref=$p(ParRef,"||",1)
	s version=$p(ParRef,"||",2)
	s rowid=0
	f  s rowid=$o(^ARCRL(parref,rowid)) q:rowid=""  d
	.s ARCRLRowId=parref_"||"_rowid
	.s ARCRLOrdLocDR=$p($g(^ARCRL(parref,rowid)),"^",1)
	.s ARCRLOrdLocDesc=""
	.s:ARCRLOrdLocDR'="" ARCRLOrdLocDesc=$p($g(^CTLOC(ARCRLOrdLocDR)),"^",2) //获取科室描述
	.s ARCRLRecLocDR=$p($g(^ARCRL(parref,rowid)),"^",2)
	.s ARCRLRecLocDesc=""
	.s:ARCRLRecLocDR'="" ARCRLRecLocDesc=$p($g(^CTLOC(ARCRLRecLocDR)),"^",2) //获取科室描述
	.s ARCRLOrderPriorityDR=$p($g(^ARCRL(parref,rowid)),"^",10)
	.s ARCRLOrderPriorityDesc=""
	.s:ARCRLOrderPriorityDR'="" ARCRLOrderPriorityDesc=$p($g(^OECPR(ARCRLOrderPriorityDR)),"^",2) //系统医嘱优先级描述
	.s ARCRLDefaultFlag=$p($g(^ARCRL(parref,rowid)),"^",4)
	.s ARCRLDateFrom=$p($g(^ARCRL(parref,rowid)),"^",8)
	.s ARCRLDateTo=$p($g(^ARCRL(parref,rowid)),"^",9)
	.s:ARCRLDateFrom'="" ARCRLDateFrom=$zd(ARCRLDateFrom,1) //转换日期格式
	.s:ARCRLDateTo'="" ARCRLDateTo=$zd(ARCRLDateTo,1) //转换日期格式
	.s ARCRLTimeFrom=$p($g(^ARCRL(parref,rowid)),"^",5)
	.s ARCRLTimeTo=$p($g(^ARCRL(parref,rowid)),"^",6)
	.s:ARCRLTimeFrom'="" ARCRLTimeFrom=$zt(ARCRLTimeFrom,1)  //转换时间
	.s:ARCRLTimeTo'="" ARCRLTimeTo=$zt(ARCRLTimeTo,1)      //转换时间
	.d OutputRow
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ARCRLRowId,ARCRLOrdLocDR,ARCRLOrdLocDesc,ARCRLRecLocDR,ARCRLRecLocDesc,ARCRLOrderPriorityDR,ARCRLOrderPriorityDesc,ARCRLDefaultFlag,ARCRLDateFrom,ARCRLDateTo,ARCRLTimeFrom,ARCRLTimeTo)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindOrderRecLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderRecLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrderRecLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderRecLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 用于 医嘱优先级 放大镜
Query priorlist(opcprdesc As %String) As %Query(ROWSPEC = "priordr:%String:行号,priordesc:%String:医嘱优先级")
{
}

ClassMethod priorlistExecute(ByRef qHandle As %Binary, opcprdesc As %String = "") As %Status
{
   	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	/*
	&sql(DECLARE priortmp CURSOR FOR 
         select OECPR_RowId,OECPR_Desc into :OECPRRowId,:OECPRDesc
	     from  OEC_Priority  
	     where  OECPR_Desc  like '%'_:opcprdesc_'%' or :opcprdesc is null)
	&sql(OPEN priortmp)
    for  &SQL(FETCH priortmp) QUIT:SQLCODE  do
	.Do OutputRow
	&sql(CLOSE priortmp)
	*/
	s:opcprdesc'="" opcprdesc=$ZCONVERT(opcprdesc,"U") //转换成大写
	s OECPRRowId=0
	f  s OECPRRowId=$o(^OECPR(OECPRRowId)) q:OECPRRowId=""  d
	.s OECPRDesc = $p($g(^OECPR(OECPRRowId)),"^",2)
	.i ($ZCONVERT(OECPRDesc,"U")[opcprdesc) d
	..d OutputRow
	
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
	set Data=$lb(OECPRRowId,OECPRDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod priorlistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = priorlistExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	
	    // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod priorlistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = priorlistExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 其他明细中的药物combox
ClassMethod drugmast(start, limit, sort, dir, callback, drugdesc) As %String
{
	//查询语句
	//s strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCD_ParRef->PHCD_Code,PHCDF_PHCD_ParRef->PHCD_Name,PHCDF_PHCF_DR,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm"
	//s ^TEMP("cwg","drugmast")=start_"^"_limit_"^"_sort_"^"_dir_"^"_callback_"^"_drugdesc
	//s start="0",limit="30",sort="rowid",dir="ASC",drugdesc="消旋山莨菪碱片",callback=""

	If $g(drugdesc)'="" Do
	.Set ConExp="'%"_drugdesc_"%'"
	.Set strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCD_ParRef->PHCD_Code,PHCDF_PHCD_ParRef->PHCD_Name,PHCDF_PHCF_DR,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm where PHCDF_PHCD_ParRef->PHCD_Name like"_"  "_ConExp
	Else  Do
	.Set strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCD_ParRef->PHCD_Code,PHCDF_PHCD_ParRef->PHCD_Name,PHCDF_PHCF_DR,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm"
	
	
	//排序
	s strSort=""
	s sortField=""
	
	i sort'="" d
	.i sort="rowid" s sortField="PHCDF_PHCD_ParRef"
	.i sort="code"  s sortField="PHCD_Code"
	.i sort="desc"  s sortField="PHCD_Name"
	
	i sortField'="" d
	.s dir=$ZCONVERT(dir,"U")
	.i (dir="DESC") || (dir="ASC") s strSort=" ORDER BY "_sortField_" "_dir
	.e  s strSort=" ORDER BY "_sortField_" DESC"
	e  d
	.s strSort=" ORDER BY %ID DESC"
	s strSql=strSql_strSort
	
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(strSql)
	d result.Execute()
	
	
	s count=0
	s strResult=""
	s drgform="[,'']"
	s end=start+limit
	
	While(result.Next())
	{
		s rowid=result.Data("PHCDF_PHCD_ParRef")
		s code=##class(ext.util.String).EvalJSON(result.Data("PHCD_Code"))
		s desc=##class(ext.util.String).EvalJSON(result.Data("PHCD_Name"))

		s count=count+1
		
		i (count>start) & (count<=end) d
		 .i strResult'="" d
		 ..s strResult=strResult_",{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
		 .e  d
		 ..s strResult="{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
	}
	
	d result.Close()
	
	i callback'="" d
	.s strResult=callback_"({""totalCount"":"""_count_""",""results"":["_strResult_"]});"
	e  d
	.s strResult="{""totalCount"":"""_count_""",""results"":["_strResult_"]}"
	
	q strResult
}

/// 其他明细中的药物形态combox
ClassMethod drugform(start, limit, sort, dir, callback, drugformselect) As %String
{
	//查询语句
	//s ^TEMP("cwg","drugform")=start_"^"_limit_"^"_sort_"^"_dir_"^"_callback_"^"_drugformselect
	
	s strSql="select PHCDF_PHCD_ParRef,PHCDF_PHCF_DR->PHCF_Code,PHCDF_PHCF_DR->PHCF_Desc  from  PHC_DrgForm  where  PHCDF_PHCD_ParRef="_""_drugformselect
	//排序
	s strSort=""
	s sortField=""
	
	i sort'="" d
	.i sort="rowid" s sortField="PHCDF_PHCD_ParRef"
	.i sort="code"  s sortField="PHCF_Code"
	.i sort="desc"  s sortField="PHCF_Desc"
	
	i sortField'="" d
	.s dir=$ZCONVERT(dir,"U")
	.i (dir="DESC") || (dir="ASC") s strSort=" ORDER BY "_sortField_" "_dir
	.e  s strSort=" ORDER BY "_sortField_" DESC"
	e  d
	.s strSort=" ORDER BY %ID DESC"
	s strSql=strSql_strSort
	
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(strSql)
	d result.Execute()
	
	s count=0
	s strResult=""
	s end=start+limit
	
	While(result.Next())
	{
		s rowid=result.Data("PHCDF_PHCD_ParRef")
		s code=##class(ext.util.String).EvalJSON(result.Data("PHCF_Code"))
		s desc=##class(ext.util.String).EvalJSON(result.Data("PHCF_Desc"))
		
		s count=count+1
		
		i (count>start) & (count<=end) d
		 .i strResult'="" d
		 ..s strResult=strResult_",{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
		 .e  d
		 ..s strResult="{""rowid"":"""_rowid_""",""code"":"""_code_""",""desc"":"""_desc_"""}"
	}
	
	d result.Close()
	
	i callback'="" d
	.s strResult=callback_"({""totalCount"":"""_count_""",""results"":["_strResult_"]});"
	e  d
	.s strResult="{""totalCount"":"""_count_""",""results"":["_strResult_"]}"
	
	q strResult
}

//********关联零收费项********以下********* ///

/// 收费子分类combox
/// 2013-8-22 by lisen
Query chargesubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARSCRowId:%String,TARSCCode:%String,TARSCDesc:%String")
{
}

ClassMethod chargesubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TARSCRowId=rowid
		s TARSCCode=$p($g(^DHCTarC("SC",TARSCRowId)),"^",1)
		s TARSCDesc=$p($g(^DHCTarC("SC",TARSCRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s TARSCRowId=0
		f  s TARSCRowId=$o(^DHCTarC("SC",TARSCRowId)) q:TARSCRowId=""  d
		.s TARSCCode=$p($g(^DHCTarC("SC",TARSCRowId)),"^",1)
		.s TARSCDesc=$p($g(^DHCTarC("SC",TARSCRowId)),"^",2)
		.i ($$ALPHAUP^SSUTIL4(TARSCCode)[code)&($$ALPHAUP^SSUTIL4(TARSCDesc)[desc) d
		..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TARSCRowId,TARSCCode,TARSCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod chargesubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = chargesubcatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod chargesubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = chargesubcatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 住院子分类combox
/// 2013-8-22 by lisen
Query inpatsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARICRowId:%String,TARICCode:%String,TARICDesc:%String")
{
}

ClassMethod inpatsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TARICRowId=rowid
		s TARICCode=$p($g(^DHCTarC("IC",TARICRowId)),"^",1)
		s TARICDesc=$p($g(^DHCTarC("IC",TARICRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s TARICRowId=0
		f  s TARICRowId=$o(^DHCTarC("IC",TARICRowId)) q:TARICRowId=""  d
		.s TARICCode=$p($g(^DHCTarC("IC",TARICRowId)),"^",1)
		.s TARICDesc=$p($g(^DHCTarC("IC",TARICRowId)),"^",2)
		.i ($$ALPHAUP^SSUTIL4(TARICCode)[code)&($$ALPHAUP^SSUTIL4(TARICDesc)[desc) d
		..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TARICRowId,TARICCode,TARICDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod inpatsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = inpatsubcatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod inpatsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = inpatsubcatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 门诊子分类combox
/// 2013-8-22 by lisen
Query outpatsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TAROCRowId:%String,TAROCCode:%String,TAROCDesc:%String")
{
}

ClassMethod outpatsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TAROCRowId=rowid
		s TAROCCode=$p($g(^DHCTarC("OC",TAROCRowId)),"^",1)
		s TAROCDesc=$p($g(^DHCTarC("OC",TAROCRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s TAROCRowId=0
		f  s TAROCRowId=$o(^DHCTarC("OC",TAROCRowId)) q:TAROCRowId=""  d
		.s TAROCCode=$p($g(^DHCTarC("OC",TAROCRowId)),"^",1)
		.s TAROCDesc=$p($g(^DHCTarC("OC",TAROCRowId)),"^",2)
		.i ($$ALPHAUP^SSUTIL4(TAROCCode)[code)&($$ALPHAUP^SSUTIL4(TAROCDesc)[desc) d
		..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TAROCRowId,TAROCCode,TAROCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod outpatsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = outpatsubcatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod outpatsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = outpatsubcatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 病案首页子分类combox
/// 2013-8-22 by lisen
Query mrsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARMCRowId:%String,TARMCCode:%String,TARMCDesc:%String")
{
}

ClassMethod mrsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TARMCRowId=rowid
		s TARMCCode=$p($g(^DHCTarC("MC",TARMCRowId)),"^",1)
		s TARMCDesc=$p($g(^DHCTarC("MC",TARMCRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s TARMCRowId=0
		f  s TARMCRowId=$o(^DHCTarC("MC",TARMCRowId)) q:TARMCRowId=""  d
		.s TARMCCode=$p($g(^DHCTarC("MC",TARMCRowId)),"^",1)
		.s TARMCDesc=$p($g(^DHCTarC("MC",TARMCRowId)),"^",2)
		.i ($$ALPHAUP^SSUTIL4(TARMCCode)[code)&($$ALPHAUP^SSUTIL4(TARMCDesc)[desc) d
		..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TARMCRowId,TARMCCode,TARMCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod mrsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = mrsubcatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod mrsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = mrsubcatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 会计子分类combox
/// 2013-8-22 by lisen
Query acctsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARACRowId:%String,TARACCode:%String,TARACDesc:%String")
{
}

ClassMethod acctsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TARACRowId=rowid
		s TARACCode=$p($g(^DHCTarC("AC",TARACRowId)),"^",1)
		s TARACDesc=$p($g(^DHCTarC("AC",TARACRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s TARACRowId=0
		f  s TARACRowId=$o(^DHCTarC("AC",TARACRowId)) q:TARACRowId=""  d
		.s TARACCode=$p($g(^DHCTarC("AC",TARACRowId)),"^",1)
		.s TARACDesc=$p($g(^DHCTarC("AC",TARACRowId)),"^",2)
		.i ($$ALPHAUP^SSUTIL4(TARACCode)[code)&($$ALPHAUP^SSUTIL4(TARACDesc)[desc) d
		..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TARACRowId,TARACCode,TARACDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod acctsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = acctsubcatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod acctsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = acctsubcatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 核算子分类combox
/// 2013-8-22 by lisen
Query emcsubcat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARECRowId:%String,TARECCode:%String,TARECDesc:%String")
{
}

ClassMethod emcsubcatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TARECRowId=rowid
		s TARECCode=$p($g(^DHCTarC("EC",TARECRowId)),"^",1)
		s TARECDesc=$p($g(^DHCTarC("EC",TARECRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s TARECRowId=0
		f  s TARECRowId=$o(^DHCTarC("EC",TARECRowId)) q:TARECRowId=""  d
		.s TARECCode=$p($g(^DHCTarC("EC",TARECRowId)),"^",1)
		.s TARECDesc=$p($g(^DHCTarC("EC",TARECRowId)),"^",2)
		.i ($$ALPHAUP^SSUTIL4(TARECCode)[code)&($$ALPHAUP^SSUTIL4(TARECDesc)[desc) d
		..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TARECRowId,TARECCode,TARECDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod emcsubcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = emcsubcatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod emcsubcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = emcsubcatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

//********关联零收费项********以上*********//

/// 用于 收费项 放大镜
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.itmmast","TaritemList","","","")
Query TaritemList(tarcode As %String, itemalias As %String, alinamchk As %String) As %Query(ROWSPEC = "tarirowid:%String:收费项目ID, taricode:%String:收费项目代码, taridesc:%String:收费项目名称, ItmPrice:%String:价格(元)")
{
}

ClassMethod TaritemListExecute(ByRef qHandle As %Binary, tarcode As %String = "", itemalias As %String = "", alinamchk As %String = "") As %Status
{
   	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	;If (tarcode="")&(itemalias="") Quit ""
	
	If alinamchk="true" Do
    .Set alias=$$ALPHAUP^SSUTIL4(itemalias)
	Else  Do
	.Set descname=itemalias 
		
	If tarcode'="" Do      //收费项'代码'非空
	.s tarcode=$ZCONVERT(tarcode,"U") //20130527LISEN
	.&sql(DECLARE TARCursor CURSOR FOR 
         select TARI_RowId,TARI_Code,TARI_Desc into :trowid,:tcode,:tdesc
	     from  dhc_taritem  where  TARI_ActiveFlag='Y' and   TARI_EndDate  is  null and TARI_Code like '%'_:tarcode_'%')
	.&sql(OPEN TARCursor)
    .for  &SQL(FETCH TARCursor) QUIT:SQLCODE  do
	..Set ItmPrice=##class(web.UDHCJFPRICE).GetItmPrice(trowid,$h,"","","","","")
    ..Set ItmPrice=$p(ItmPrice,"^",1)
	..Do OutputRow
	.&sql(CLOSE TARCursor)
    Else  Do
	.If alinamchk="true" Do   //按收费项'别名'检索收费项目
	..Set tiarowid=0
    ..For  Set tiarowid=$o(^DHCTARAL(tiarowid)) Quit:tiarowid=""  Do
    ...Quit:tiarowid="A"
	...Set talias=$P(^DHCTARAL(tiarowid),"^",3)
	...If talias[alias Do
	....;b ;;0720-alias(1)
    ....Set trowid=$P(^DHCTARAL(tiarowid),"^",1)
    ....Set:trowid'="" tcode=$P($g(^DHCTARI(trowid)),"^",1)  //20130527LISEN
    ....Set:trowid'="" tdesc=$P($g(^DHCTARI(trowid)),"^",2)  //20130527LISEN
    ....Set:trowid'="" ItmPrice=##class(web.UDHCJFPRICE).GetItmPrice(trowid,$h,"","","","","")  //20130527LISEN
    ....Set ItmPrice=$p(ItmPrice,"^",1)
    ....;b ;;0720-alias(2)
    ....Do OutputRow
	.Else  Do   //按收费项'描述'检索收费项目
	..Set trowid=0
	..For  Set trowid=$o(^DHCTARI(trowid)) Quit:trowid=""  Do
	...Set tcode=$P($g(^DHCTARI(trowid)),"^",1)  //20130527LISEN
	...Set tdesc=$P($g(^DHCTARI(trowid)),"^",2)  //20130527LISEN
	...If $ZCONVERT(tdesc,"U")[$ZCONVERT(descname,"U") Do
	....Set:trowid'="" ItmPrice=##class(web.UDHCJFPRICE).GetItmPrice(trowid,$h,"","","","","")  //20130527LISEN
    ....Set ItmPrice=$p(ItmPrice,"^",1)
	....Do OutputRow
	
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

ResetVariables
	Set (trowid,tcode,tdesc,ItmPrice)=""
	Quit

OutputRow
	;;Do ResetVariables
	set Data=$lb(trowid,tcode,tdesc,ItmPrice)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod TaritemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TaritemListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	
	    // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod TaritemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TaritemListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取 医嘱项与收费项目关联 grid数据
ClassMethod OrderLinkTar(start, limit, sort, dir, callback, arcimrowid) As %String
{
	//查询语句
	//Set ^TEMP("cwg","0823")=start_"#"_limit_"#"_sort_"#"_dir_"#"_callback_"#"_arcimrowid
	
	If arcimrowid="" Quit "" 
	Set strSql="select OLT_RowId,OLT_Tariff_DR,OLT_Tariff_DR->TARI_Code,OLT_Tariff_DR->TARI_Desc,OLT_Qty,OLT_StartDate,OLT_EndDate,OLT_Tariff_DR   from  DHC_OrderLinkTar  where  OLT_ARCIM_DR="_"'"_arcimrowid_"'"

	//排序
	Set strSort=""
	Set sortField=""
	
	If sort'="" Do
	.If sort="rowid" Set sortField="OLT_RowId"
	.If sort="code"  Set sortField="TARI_Code"
	.If sort="desc"  Set sortField="TARI_Desc"
	
	If sortField'="" Do
	.SEt dir=$ZCONVERT(dir,"U")
	.If (dir="DESC") || (dir="ASC") Set strSort=" ORDER BY "_sortField_" "_dir
	.Else  Set strSort=" ORDER BY "_sortField_" DESC"
	Else  Do
	.Set strSort=" ORDER BY %ID DESC"
	Set strSql=strSql_strSort
   
	Set result=##class(%Library.ResultSet).%New()
	
	Do result.Prepare(strSql)
	Do result.Execute()
	
	Set count=0
	Set strResult=""
	Set end=start+limit
	
	While(result.Next())
	{
		Set associaterowid=##class(ext.util.String).EvalJSON(result.Data("OLT_RowId"))
		Set olttariffdr=##class(ext.util.String).EvalJSON(result.Data("OLT_Tariff_DR"))
		Set tarcode=##class(ext.util.String).EvalJSON(result.Data("TARI_Code"))
		Set tardesc=##class(ext.util.String).EvalJSON(result.Data("TARI_Desc"))
		Set tarnum=##class(ext.util.String).EvalJSON(result.Data("OLT_Qty"))
		Set tarDate=##class(ext.util.String).EvalJSON($zd(result.Data("OLT_StartDate"),3))
        Set TARIRowId=##class(ext.util.String).EvalJSON(result.Data("OLT_Tariff_DR"))  //在表dhc_taritem中的TARI_RowId
        
		Set tarDateTo=##class(ext.util.String).EvalJSON($zd(result.Data("OLT_EndDate"),3))
		If tarDate="1840-12-31"   Set tarDate=""
        If tarDateTo="1840-12-31" Set tarDateTo=""

		//Set priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimrowid, +$h, "", "", "", "")	  //取医嘱项目价格0823
		Set priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(TARIRowId, +$h, "", "", "", "","")             //取收费项目价格（收费项目单价）0823
        Set price=$p(priceinfo,"^",1)
        Set tarprice=##class(ext.util.String).EvalJSON(price)
		Set count=count+1
		If (count>start) Do
		 .If strResult'="" Do
		 ..Set strResult=strResult_",{""olttariffdr"":"""_olttariffdr_""",""associaterowid"":"""_associaterowid_""",""tarcode"":"""_tarcode_""",""tardesc"":"""_tardesc_""",""tarnum"":"""_tarnum_""",""tarDate"":"""_tarDate_""",""tarDateTo"":"""_tarDateTo_""",""tarprice"":"""_tarprice_"""}"
		 .Else  Do
		 ..Set strResult="{""olttariffdr"":"""_olttariffdr_""",""associaterowid"":"""_associaterowid_""",""tarcode"":"""_tarcode_""",""tardesc"":"""_tardesc_""",""tarnum"":"""_tarnum_""",""tarDate"":"""_tarDate_""",""tarDateTo"":"""_tarDateTo_""",""tarprice"":"""_tarprice_"""}"
	}
	
	Do result.Close()
	
	If callback'="" Do
	.Set strResult=callback_"({""totalCount"":"""_count_""",""results"":["_strResult_"]});"
	Else  Do
	.Set strResult="{""totalCount"":"""_count_""",""results"":["_strResult_"]}"
		
	Quit strResult
}

/// 用于“医嘱项接收科室” 中 “病人科室” 和 “接收科室” 放大镜
Query ctloclist(externaldesc As %String) As %Query(ROWSPEC = "locrowid:%String:行号,locdesc:%String:科室名称")
{
}

ClassMethod ctloclistExecute(ByRef qHandle As %Binary, externaldesc As %String = "") As %Status
{
   	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	&sql(DECLARE ctloctmp CURSOR FOR 
         select CTLOC_RowID,CTLOC_Desc into :ctrowid,:ctdesc
	     from  ct_loc  
	     where  (CTLOC_Desc  like '%'_:externaldesc_'%' or :externaldesc is null) and (CTLOC_Type<>"OR")
	     )
	&sql(OPEN ctloctmp)
    for  &SQL(FETCH ctloctmp) QUIT:SQLCODE  do
	.Do OutputRow
	&sql(CLOSE ctloctmp)

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
	set Data=$lb(ctrowid,ctdesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ctloclistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclistExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	
	    // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ctloclistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclistExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 保存医嘱项
/// w ##class(web.DHCBL.CT.itmmast).Save("bb^bb^^204^59^59||1^16^1^false^false^^^^^^","")
/// 2013-5-15 modified by lisen
ClassMethod Save(ArcItmMastStr As %String, ZeroFeeStr As %String, AddOrdLinkTar As %String) As %String
{
    //Set ^TEMP("cwg","Save")=ArcItmMastStr_"###"_ZeroFeeStr
    //Set UpdateUserDR="1"
    //Set ArcItmMastStr="yyy^yyy^yyy^206^47^47||1^166^3^true^false^2012/05/31^^^1^0"
    //If ordercode=""  Quit "{success:'false',info:'医嘱代码不能为空!'}"   
    Set arcim=""
	Set UpdateUserDR=%session.Get("LOGON.USERID") //修改人
    Set UpdateDate=$p($h,",",1)                   //修改日期
    Set UpdateTime=$p($h,",",2)                   //修改时间
	Set ordercode=$$ALPHAUP^SSUTIL4($p(ArcItmMastStr,"^",1))         //代码
	If ordercode'=""  s arcim=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ordercode),""))
	If arcim'="" Quit "{success:'false',info:'医嘱代码已经存在, 不能重复增加!'}"
	
	Set orderdesc=$p(ArcItmMastStr,"^",2)         //描述
	If orderdesc'="" s arcim=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(orderdesc),""))
	If arcim'="" Quit "{success:'false',info:'医嘱名称已经存在, 不能重复增加!'}"
	
	Set orderabbrev=$p(ArcItmMastStr,"^",3)       //缩写
	If orderabbrev="" Do
	.Set orderabbrev=orderdesc
	Set arcitemcatdr=$p(ArcItmMastStr,"^",4)      //医嘱子分类
	Set billgroupdr=$p(ArcItmMastStr,"^",5)       //帐单组
	Set subbillgroupdr=$p(ArcItmMastStr,"^",6)    //帐单子组
	Set billunitdr=$p(ArcItmMastStr,"^",7)        //计帐单位
	Set defaultprioritydr=$p(ArcItmMastStr,"^",8) //默认优先级
	
	Set Tindependentchk=$p(ArcItmMastStr,"^",9)   //独立医嘱 true/false
	If Tindependentchk="true" Do
	.Set independentchk="Y"
	Else  Do
	.Set independentchk="N"
	
	Set Tnostockchk=$p(ArcItmMastStr,"^",10)      //无库存医嘱 true/false
	If Tnostockchk="true" Do
	.Set nostockchk="Y"
	Else  Do
	.Set nostockchk="N"

	Set fromdate=$p(ArcItmMastStr,"^",11)         //有效开始日期
	Set todate=$p(ArcItmMastStr,"^",12)           //有效截止日期
	Set orderadvice=$p(ArcItmMastStr,"^",13)      //医嘱提示框
	Set resourcegroupdr=$p(ArcItmMastStr,"^",14)  //服务资源组
	
	Set Tservicematerial=$p(ArcItmMastStr,"^",15) //服务/材料 1/2
	Set orderalias=$p(ArcItmMastStr,"^",16)       //医嘱项别名0822
	
	Set servicematerial=""
	If Tservicematerial="1" Do
	.Set servicematerial="S"
	
	If Tservicematerial="2" Do
	.Set servicematerial="M"

	Set obj=##class(User.ARCItmMast).%New()
    Set obj.ARCIMCode=ordercode                               //医嘱代码  ARCIM_Code
    Set obj.ARCIMDesc=orderdesc                               //医嘱描述  ARCIM_Desc
    Set obj.ARCIMAbbrev=orderabbrev                           //缩写      ARCIM_Abbrev
    Do obj.ARCIMItemCatDRSetObjectId(arcitemcatdr)            //医嘱子分类 ARCIM_ItemCat_DR
    Do obj.ARCIMBillSubDRSetObjectId(subbillgroupdr)          //帐单子组  ARCIM_BillSub_DR
    Do obj.ARCIMBillingUOMDRSetObjectId(billunitdr)           //计帐单位 ARCIM_BillingUOM_DR
    Do obj.ARCIMDefPriorityDRSetObjectId(defaultprioritydr)   //默认优先级 ARCIM_DefPriority_DR
    Set obj.ARCIMOrderOnItsOwn=independentchk                 //独立医嘱  ARCIM_OrderOnItsOwn
    Set obj.ARCIMAllowOrderWOStockCheck=nostockchk            //无库存医嘱 ARCIM_AllowOrderWOStockCheck

	//医嘱提示框 ARCIM_OEMessage
    //Set obj.ARCIMOEMessage=orderadvice 
    //Set Rowid=obj.%Id()
    If orderadvice'="" Do
    .Set OEMessagLen=$LENGTH(orderadvice,""_$c(13,10)_"")
	.For i=1:1:OEMessagLen Do
	..Set DataString=$P(orderadvice,""_$c(13,10)_"",i)
	..Do obj.ARCIMOEMessage.Insert(DataString)         //插入医嘱提示

    Do obj.ARCIMServiceGroupDRSetObjectId(resourcegroupdr)    //服务资源组 ARCIM_ServiceGroup_DR
    
    If servicematerial'="" Set obj.ARCIMServMaterial=servicematerial      //服务/材料 ARCIM_ServMaterial
    
    Do obj.ARCIMUpdateUserSetObjectId(UpdateUserDR)           //修改人 ARCIM_UpdateUser
    Set obj.ARCIMUpdateDate=UpdateDate                        //修改日期 ARCIM_UpdateDate
    Set obj.ARCIMUpdateTime=UpdateTime                        //修改时间 ARCIM_UpdateTime
	
	Set obj.ARCIMChgPostFlg="O"  //ARCIM_ChgPostFlg  查找必须赋值，才能增加的原因?
	
	If fromdate'="" Do
	.Set fromdate=$zdh(fromdate,5)                                    
	.Set obj.ARCIMEffDate=fromdate                 //有效开始日期  ARCIM_EffDate
	If todate'="" Do
	.Set todate=$zdh(todate,5)
	.Set obj.ARCIMEffDateTo=todate                 //有效截止日期  ARCIM_EffDateTo
	
	//增加医嘱项事务-01
	Tstart   
	Set sc=obj.%Save()
	Set arcim=obj.%Id() //增加医嘱项的arcim_owid
	If $$$ISERR(sc){
	    Trollback
	    Quit "{success:'false',info:'医嘱项增加失败, 请重新操作!'}"
	}
	Tc
	
	//增加零收费项目、并做医嘱项与零收费项目关联事务-02
	If ZeroFeeStr'="" {
		Tstart
		Set tarcats=""  //收费项目费用分类串  
		Set tarcode=ordercode   //收费项目代码
		Set tarname=orderdesc   //收费项目名称
		Set tarunitDr=billunitdr                //收费单位
		Set chargesubcat=$p(ZeroFeeStr,"^",1)   //收费子分类
		Set emcsubcat=$p(ZeroFeeStr,"^",2)      //核算子分类
		Set acctsubcat=$p(ZeroFeeStr,"^",3)     //会计子分类
		Set inpatsubcat=$p(ZeroFeeStr,"^",4)    //住院子分类
		Set outpatsubcat=$p(ZeroFeeStr,"^",5)   //门诊子分类
		Set mrsubcat=$p(ZeroFeeStr,"^",6)       //病案首页子分类
	
		Set tarcats=chargesubcat_"#"_inpatsubcat_"#"_outpatsubcat_"#"_emcsubcat_"#"_mrsubcat_"#"_acctsubcat
		Set CurrentNS=$ZNSPACE  //保留当前NameSpace
		ZN "DHC-DATA"	//"MEDDATA"
		Set err1=$$AddTarItem^DHCSTJFTARITEM(arcim,tarcats,"")   //INSERT INTO DHC_TARITEM、DHC_OrderLinkTar
		If err1=0{
	   		Set err2=$$InsertARCPrice^DHCSTJFTARITEM(arcim,"0",UpdateUserDR)  //维护收费项目价格
	   	}
		ZN CurrentNS
		
    	Tc
		If err1'=0 {
	   		Quit "{success:'false',info:'医嘱项增加成功! 零收费项目增加失败, 医嘱项与零收费项目关联失败, 请重新增加零收费项目,并关联!'}"		
		}
		If err2'=0 {
	   		Quit "{success:'false',info:'收费项目零费用价格, 维护失败,请重新维护零费用价格 !'}"		
		}
	}
	
	//增加收费项目、并关联医嘱项事务-03
	if (AddOrdLinkTar'="") {
		Tstart
		s arcimdr=arcim //医嘱项rowid
		s tarlength=$length(AddOrdLinkTar,"*")
		for i=1:1:tarlength {
			s StrAddOrdLinkTar=$p(AddOrdLinkTar,"*",i)
 			s olttariffdr=$p(StrAddOrdLinkTar,"^",1) //收费项目id
 			s oltqty=$p(StrAddOrdLinkTar,"^",2) //收费数量
 			s oltstart=$p(StrAddOrdLinkTar,"^",3)
 			s:oltstart'="" oltstart=$zdh(oltstart,5) //开始日期
 			s oltend=$p(StrAddOrdLinkTar,"^",4)
			s:oltend'="" oltend=$zdh(oltend,5) //截止日期
 			//If $zdh(oltstart,5)<$h Quit "{success:'false',info:'关联收费项目的开始日期早于当天日期, 增加失败!'}"
 			&SQL(insert into DHC_OrderLinkTar (OLT_ARCIM_DR,OLT_Tariff_DR,OLT_Qty,OLT_StartDate,OLT_EndDate) values(:arcimdr,:olttariffdr,:oltqty,:oltstart,:oltend))
 		}
		If SQLCODE=100{
			Trollback
	 		Quit "{success:'false',info:'医嘱项增加成功! 收费项目增加失败, 医嘱项与收费项目关联失败, 请重新增加收费项目,并关联!'}"
 		}
 		Tc
	}
	
	//增加医嘱项别名,事务-04
	Tstart       
	Set SQLCODE=100
	Set ALIASDateFrom=+$h
	If orderalias'="" Do
    .Set orderaliasLen=$LENGTH(orderalias,"/")
	.For i=1:1:orderaliasLen Do
	..Set alias=$P(orderalias,"/",i)
	..If alias'="" Do
	...Set alias=$$ALPHAUP^SSUTIL4(alias)
	...&SQL(insert into ARC_Alias (ALIAS_ARCIM_DR,ALIAS_Text,ALIAS_Desc,ALIAS_OrderSubCat_DR,ALIAS_Type,ALIAS_OrderOnItsOwn,ALIAS_DateFrom) values(:arcim,:alias,:orderdesc,:arcitemcatdr,"ARCIM","Y",:ALIASDateFrom))	
	...
	Tc
	
	If SQLCODE'=0 {
	   Quit "{success:'false',info:'医嘱项别名增加失败, 请通过<医嘱别名>按钮增加!'}"		
	}
	Else {
	   Quit "{success:'true',id:'"_obj.%Id()_"'}"
	}
}

/// 修改医嘱项
ClassMethod update(ArcItmMastStr As %String, ZeroFeeStr As %String) As %String
{
    //Set ^TEMP("cwg","Update0822")=ArcItmMastStr_"##"_ZeroFeeStr
    //Set UpdateUserDR="1"
    //Set ArcItmMastStr="002^神药^神药aa^227^48^48||1^238^5^true^false^2012/04/05^^^^^13358||1"
    
    Set tmpflagdr1="itemcatdr"
	Set arcitemcatdr=$p(ArcItmMastStr,"^",4)      //医嘱子分类Dr
	If '$d(^ARC("IC",arcitemcatdr)) Do            //判断医嘱子分类Dr是否存在?
	.Set tmpflagdr1=""
	If tmpflagdr1="" Quit "{success:'false',info:'医嘱子分类不存在, 请重新选择!'}"
    Set tmpflagdr2="prioritydr"
	Set defaultprioritydr=$p(ArcItmMastStr,"^",8) //默认优先级Dr
	If '$d(^OECPR(defaultprioritydr)) Do          //判断默认优先级是否存在?
	.Set tmpflagdr2=""
	If tmpflagdr2="" Quit "{success:'false',info:'默认优先级不存在, 请重新选择!'}"
    Set tmpflagdr3="billgroupdr"
	Set billgroupdr=$p(ArcItmMastStr,"^",5)       //帐单组Dr
	If '$d(^ARCBG(billgroupdr)) Do    //判断帐单组是否存在?
	.Set tmpflagdr3=""
	If tmpflagdr3="" Quit "{success:'false',info:'帐单组不存在, 请重新选择!'}"
	Set tmpflagdr4="subbillgroupdr"
	Set subbillgroupdr=$p(ArcItmMastStr,"^",6)    //帐单子组Dr
	Set ChildSub=$p(subbillgroupdr,"||",2)
	If '$d(^ARCBG(billgroupdr,"SG",ChildSub)) Do    //判断帐单子组是否存在?
	.Set tmpflagdr4=""
	If tmpflagdr4="" Quit "{success:'false',info:'帐单子组不存在, 请重新选择!'}"
	Set tmpflagdr5="billunitdr"
	Set billunitdr=$p(ArcItmMastStr,"^",7)        //计帐单位Dr
	If '$d(^CT("UOM",billunitdr)) Do    //判断计帐单位是否存在?
    .Set tmpflagdr5=""
	If tmpflagdr5="" Quit "{success:'false',info:'计帐单位不存在, 请重新选择!'}"
    Set tmpflagdr6="resourcegroupdr"
	Set resourcegroupdr=$p(ArcItmMastStr,"^",14)  //服务资源组Dr
	If resourcegroupdr'="" Do
	.If '$d(^RBC("SG",resourcegroupdr)) Do    //判断服务资源组是否存在?
	..Set tmpsgroupdr=$o(^RBC("SG",0,"Desc",resourcegroupdr,""))
	..If tmpsgroupdr'="" Do
	...Set resourcegroupdr=tmpsgroupdr  //传入参数:服务资源组 为描述,需要转换为SG_RowId(表RBC_ServiceGroup)
    ..Else  Do
    ...Set tmpflagdr6=""
	If tmpflagdr6="" Quit "{success:'false',info:'服务资源组不存在, 请重新选择!'}"

    Set arcim=""
	Set UpdateUserDR=%session.Get("LOGON.USERID") //修改人20120704
	
    Set UpdateDate=$p($h,",",1)                   //修改日期
    Set UpdateTime=$p($h,",",2)                   //修改时间
    Set Rowid=$p(ArcItmMastStr,"^",16)    //被修改医嘱项的Rowid
    Set OldARCimCode=$p(^ARCIM($p(Rowid,"||",1),$p(Rowid,"||",2),1),"^",1)  //被修改医嘱项的原代码
    Set OldARCimDesc=$p(^ARCIM($p(Rowid,"||",1),$p(Rowid,"||",2),1),"^",2)  //被修改医嘱项的原名称
	Set ordercode=$$ALPHAUP^SSUTIL4($p(ArcItmMastStr,"^",1)) //修改代码,医嘱代码转换为大写
	If (ordercode'="")&(ordercode'=OldARCimCode)  s arcim=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ordercode),""))
	If arcim'="" Quit "{success:'false',info:'医嘱代码已经存在, 不能重复增加!'}"
	Set orderdesc=$p(ArcItmMastStr,"^",2)         //描述
	If (orderdesc'="")&(orderdesc'=OldARCimDesc) s arcim=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(orderdesc),""))
	If arcim'="" Quit "{success:'false',info:'医嘱名称已经存在, 不能重复增加!'}"

	Set orderabbrev=$p(ArcItmMastStr,"^",3)       //缩写

	Set Tindependentchk=$p(ArcItmMastStr,"^",9)   //独立医嘱 true/false
	If Tindependentchk="true" Do
	.Set independentchk="Y"
	Else  Do
	.Set independentchk="N"
	
	Set Tnostockchk=$p(ArcItmMastStr,"^",10)      //无库存医嘱 true/false
	If Tnostockchk="true" Do
	.Set nostockchk="Y"
	Else  Do
	.Set nostockchk="N"

	Set fromdate=$p(ArcItmMastStr,"^",11)         //有效开始日期
	Set todate=$p(ArcItmMastStr,"^",12)           //有效截止日期
	Set orderadvice=$p(ArcItmMastStr,"^",13)      //医嘱提示框
	
	Set Tservicematerial=$p(ArcItmMastStr,"^",15) //服务/材料 1/2
	
	Set servicematerial=""
	If Tservicematerial="1" Do
	.Set servicematerial="S"
	
	If Tservicematerial="2" Do
	.Set servicematerial="M"
	
 
	Set obj=##class(User.ARCItmMast).%OpenId(Rowid)
    If (OldARCimCode'=ordercode)  Set obj.ARCIMCode=ordercode   //医嘱代码  ARCIM_Code
    If (OldARCimDesc'=orderdesc)  Set obj.ARCIMDesc=orderdesc   //医嘱描述  ARCIM_Desc
    Set obj.ARCIMAbbrev=orderabbrev                           //缩写      ARCIM_Abbrev
    Do obj.ARCIMItemCatDRSetObjectId(arcitemcatdr)            //医嘱子分类 ARCIM_ItemCat_DR
    Do obj.ARCIMBillSubDRSetObjectId(subbillgroupdr)          //帐单子组  ARCIM_BillSub_DR
    Do obj.ARCIMBillingUOMDRSetObjectId(billunitdr)           //计帐单位 ARCIM_BillingUOM_DR
    Do obj.ARCIMDefPriorityDRSetObjectId(defaultprioritydr)   //默认优先级 ARCIM_DefPriority_DR
    Set obj.ARCIMOrderOnItsOwn=independentchk                 //独立医嘱  ARCIM_OrderOnItsOwn
    Set obj.ARCIMAllowOrderWOStockCheck=nostockchk            //无库存医嘱 ARCIM_AllowOrderWOStockCheck
    Do obj.ARCIMServiceGroupDRSetObjectId(resourcegroupdr)    //服务资源组 ARCIM_ServiceGroup_DR
    If servicematerial'="" Set obj.ARCIMServMaterial=servicematerial      //服务/材料 ARCIM_ServMaterial
    Do obj.ARCIMUpdateUserSetObjectId(UpdateUserDR)           //修改人 ARCIM_UpdateUser
    Set obj.ARCIMUpdateDate=UpdateDate                        //修改日期 ARCIM_UpdateDate
    Set obj.ARCIMUpdateTime=UpdateTime                        //修改时间 ARCIM_UpdateTime
	
	Set obj.ARCIMChgPostFlg="O"  //ARCIM_ChgPostFlg  必须赋值
	
	If fromdate'="" Do
	.Set fromdate=$zdh(fromdate,5)                                    
	.Set obj.ARCIMEffDate=fromdate                 //有效开始日期  ARCIM_EffDate
	If todate'="" Do
	.Set todate=$zdh(todate,5)
	.Set obj.ARCIMEffDateTo=todate                 //有效截止日期  ARCIM_EffDateTo
	Else  Do
	.Set obj.ARCIMEffDateTo=""

    //医嘱提示框 ARCIM_OEMessage  为List类型
	Set ord=$p(Rowid,"||",1)
	Set OrdSub=$p(Rowid,"||",2)
	Set OEMessagLen=$LENGTH(orderadvice,""_$c(13,10)_"")
	
	If $d(^ARCIM(ord,OrdSub,"OEM",0)){
	Set OEMNum=^ARCIM(ord,OrdSub,"OEM",0)
	For i=1:1:OEMNum Do
	.Kill ^ARCIM(ord,OrdSub,"OEM",i)
	Set ^ARCIM(ord,OrdSub,"OEM",0)=OEMessagLen
	For i=1:1:OEMessagLen Do
	.Set DataString=$P(orderadvice,""_$c(13,10)_"",i)
	.Do obj.ARCIMOEMessage.SetAt(DataString,i)         //修改List类型语法
	}
	    
	Tstart  //修改医嘱项事务
	Set sc=obj.%Save()
	If $$$ISERR(sc){
	   Trollback
	   Quit "{success:'false',info:'医嘱项修改失败, 请重新操作!'}"
	}
	Tc
    /*20120822
	If ZeroFeeStr'="" {
	Set tarcats=""  //收费项目费用分类串
	Set tarcode=ordercode   //收费项目代码
	Set tarname=orderdesc   //收费项目名称
	Set tarunitDr=billunitdr                //收费单位
	Set chargesubcat=$p(ZeroFeeStr,"^",1)   //收费子分类
	Set emcsubcat=$p(ZeroFeeStr,"^",2)      //核算子分类
	Set acctsubcat=$p(ZeroFeeStr,"^",3)     //会计子分类
	Set inpatsubcat=$p(ZeroFeeStr,"^",4)    //住院子分类
	Set outpatsubcat=$p(ZeroFeeStr,"^",5)   //门诊子分类
	Set mrsubcat=$p(ZeroFeeStr,"^",6)       //病案首页子分类
	
	Set tarcats=chargesubcat_"#"_inpatsubcat_"#"_outpatsubcat_"#"_emcsubcat_"#"_mrsubcat_"#"_acctsubcat
	Set CurrentNS=$ZNSPACE  //保留当前NameSpace
	ZN "DHC-DATA"	//"MEDDATA"
	Set err1=$$AddTarItem^DHCSTJFTARITEM(Rowid,tarcats)   //INSERT INTO DHC_TARITEM、DHC_OrderLinkTar
	If err1=0{
	   Set err2=$$InsertARCPrice^DHCSTJFTARITEM(arcim,"0",UpdateUserDR)  //维护收费项目价格
	}
	ZN CurrentNS
	If err1'=0 {
	   Trollback
	   Quit "{success:'true',info:'收费项目增加失败, 医嘱项与收费项目关联失败, 请重新增加零收费项目并关联!'}"	
	   }
    Tc
	}
	*/	

	Quit "{success:'true',id:'"_obj.%Id()_"'}"
}

/// 修改医嘱项与收费项目关联
ClassMethod UpdateOrdLinkTar(rowid As %String, enddate As %String, oltarcimdr As %String) As %String
{
 
 //Set ^TEMP("cwg","LinkTarUp")=rowid_"##"_enddate_"##"_oltarcimdr
 
 Set:enddate'="" OLTEndDate=$zdh(enddate,5)
 If OLTEndDate<$h Quit "{success:'false',info:'截止日期不能早于今天, 修改失败!'}"

 Tstart
 &SQL(update DHC_OrderLinkTar set OLT_EndDate=:OLTEndDate  where  OLT_RowId=:rowid  and  OLT_ARCIM_DR=:oltarcimdr)
 If SQLCODE=100{
	Trollback
	Quit "{success:'false',info:'修改失败, 请重新操作!'}"
 }
 Tc
 Quit "{success:'true',info:'收费项目的截止日期修改成功!'}"
}

/// 删除医嘱项与收费项目关联
ClassMethod DelOrderLinkTar(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s eobj = ##class(web.Entity.CT.DHCOrderLinkTar).%New()
	s eobj.OLTRowId = id
	s eobj.OLTARCIMDR=$p($g(^DHCOLT(id)),"^",1)
	s eobj.OLTTariffDR=$p($g(^DHCOLT(id)),"^",2)
	s eobj.OLTQty=$p($g(^DHCOLT(id)),"^",3)
	s eobj.OLTStartDate=$p($g(^DHCOLT(id)),"^",4)
	s eobj.OLTEndDate=$p($g(^DHCOLT(id)),"^",5)
	
	s sc=##class(User.DHCOrderLinkTar).%DeleteId(id)
	if $$$ISOK(sc)
	{
		s result = "{success:'true',info:'删除收费项目关联成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_OrderLinkTar","User.DHCOrderLinkTar","医嘱项与收费项关联",id,eobj.OLTARCIMDR_"--"_eobj.OLTTariffDR,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

/// 增加医嘱项与收费项目关联
ClassMethod AddOrdLinkTar(addlinktar As %String) As %String
{
 New (olttariffdr,oltqty,oltstart,oltend,arcimdr)
 If addlinktar="" Quit "{success:'false',info:'未选择关联的收费项目, 增加失败!'}"
 Set arcimdr=$p(addlinktar,"^",1)
 Set olttariffdr=$p(addlinktar,"^",2)
 Set oltqty=$p(addlinktar,"^",3)
 Set oltstart=$p(addlinktar,"^",4)
 Set:oltstart'="" oltstart=$zdh(oltstart,5) //开始日期
 Set oltend=$p(addlinktar,"^",5)
 Set:oltend'="" oltend=$zdh(oltend,5) //截止日期
 
 //If $zdh(oltstart,5)<$h Quit "{success:'false',info:'关联收费项目的开始日期早于当天日期, 增加失败!'}"
 &SQL(select * from DHC_OrderLinkTar where OLT_ARCIM_DR=:arcimdr and OLT_Tariff_DR=:olttariffdr)
 if (SQLCODE=0) Quit "{success:'false',info:'该收费项目已经关联!'}"
 Tstart
 &SQL(insert into DHC_OrderLinkTar (OLT_ARCIM_DR,OLT_Tariff_DR,OLT_Qty,OLT_StartDate,OLT_EndDate) values(:arcimdr,:olttariffdr,:oltqty,:oltstart,:oltend))
 If SQLCODE=100{
	 Trollback
	 Quit "{success:'false',info:'增加失败, 请重新操作!'}"
 }
 Tc
 Quit "{success:'true',info:'关联收费项目,增加成功!'}"
}

/// 新增别名
/// w ##class(web.DHCBL.CT.itmmast).AddOrderAlias("13374||1^a^2013/05/16")
/// 2013-5-16 modified by lisen
ClassMethod AddOrderAlias(addorderalias As %String) As %String
{
 Set arcimrowid=$p(addorderalias,"^",1)
 Set alias=$p(addorderalias,"^",2)
 Set alias=$$ALPHAUP^SSUTIL4(alias)  //将医嘱别名转换为大写
 
 If $p(addorderalias,"^",3)'=""{
 	Set ALIASDateFrom=$zdh($p(addorderalias,"^",3),5)
 }
 Else{
 	Set ALIASDateFrom=""
 }
 If $p(addorderalias,"^",4)'=""{
 	Set ALIASDateTo=$zdh($p(addorderalias,"^",4),5)
 }
 Else{
 	Set ALIASDateTo=""
 }
 Set ALIASDesc=$p(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),1),"^",2)  //医嘱项描述
 Set ItemCatDr=$p(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),1),"^",10) //医嘱子类Dr
 
 //验证重复
 s flag=""
 s:ALIASDesc'="" ALIASDescI=$ZCONVERT(ALIASDesc,"U")
 s flag=$d(^ARC("ALIAS",0,"Desc",alias,ALIASDescI))
 if (flag>0) Quit "{success:'false',info:'医嘱项别名已经存在!'}"
 
 Tstart
 &SQL(insert into ARC_Alias (ALIAS_ARCIM_DR,ALIAS_Text,ALIAS_Desc,ALIAS_OrderSubCat_DR,ALIAS_Type,ALIAS_OrderOnItsOwn,ALIAS_DateFrom,ALIAS_DateTo) 
 values(:arcimrowid,:alias,:ALIASDesc,:ItemCatDr,"ARCIM","Y",:ALIASDateFrom,:ALIASDateTo))
 If SQLCODE=0{
 	Tc
 	Quit "{success:'true',info:'医嘱项别名,增加成功!'}"
 }else{
	Trollback
	Quit "{success:'false',info:'医嘱项别名增加失败, 请重新操作!'}"
 }
}

/// 新增检验外码关联
/// 2013-5-22 modified by lisen
ClassMethod AddOrderExtCode(addorderextcode As %String) As %String
{
 Set arcimrowid=$p(addorderextcode,"^",1)
 Set extcode=$p(addorderextcode,"^",2)
 Set extdesc=$p(addorderextcode,"^",3)
 Set extreclocdr=$p(addorderextcode,"^",4)
 
 If $p(addorderextcode,"^",5)'="" Do 
 .Set extdatefrom=$zdh($p(addorderextcode,"^",5),5)
 Else  Do
 .Set extdatefrom=$h
 
 If $p(addorderextcode,"^",6)'="" Do 
 .Set extdateto=$zdh($p(addorderextcode,"^",6),5)
 Else  Do
 .Set extdateto="" 
 
 If $p(addorderextcode,"^",7)="true" Do 
 .Set DefaultReceive="Y"
 Else  Do
 .Set DefaultReceive="N" 
 
 If $p(addorderextcode,"^",8)="true" Do 
 .Set DEfaultSend="Y"
 Else  Do
 .Set DEfaultSend="N" 
 
 //数据验证
 s flag=""
 s:extcode'="" extcodeI=$ZCONVERT(extcode,"U")
 s:arcimrowid'="" arcimrowid1=$p(arcimrowid,"||",1)
 s:arcimrowid'="" arcimrowid2=$p(arcimrowid,"||",2)
 s flag=$d(^ARCIM(0,"ExtCode",extcodeI,arcimrowid1,arcimrowid2))
 if (flag>0) Quit "{success:'false',info:'医嘱项外部代码已经存在!'}"
 
 Tstart
 &SQL(insert into ARC_ItemExternalCodes
 (EXT_ParRef,EXT_Code,EXT_Desc,EXT_CTLOC_DR,EXT_DateFrom,EXT_DateTo,EXT_DefaultReceive,EXT_DEfaultSend) 
 values(:arcimrowid,:extcode,:extdesc,:extreclocdr,:extdatefrom,:extdateto,:DefaultReceive,:DEfaultSend))
 If SQLCODE=100{
	Trollback
	Quit "{success:'false',info:'医嘱项外部代码增加失败, 请重新操作!'}"
 }
 Tc
 Quit "{success:'true',info:'外部代码,增加成功!'}"
}

/// 新增医嘱项接收科室
/// 2013-5-22 modified by lisen
ClassMethod AddReceiveLoc(recloc As %String) As %String
{
 //Set ^TEMP("cwg","AddReceiveLoc")=recloc
  
 Set Subscript=""
 Set arcimrowid=$p(recloc,"^",1)
 Set ARCIMSub=$p(arcimrowid,"||",1)
 Set Subscript=$o(^ARCRL(ARCIMSub,Subscript),-1)
 set Subscript=Subscript+1   //ARCRL_Subscript
 Set patlocdr=$p(recloc,"^",2)
 Set reclocdr=$p(recloc,"^",3)
 Set priordr=$p(recloc,"^",4)
 
 If $p(recloc,"^",5)'="" Do 
 .Set datefrom=$zdh($p(recloc,"^",5),5)
 Else  Do
 .Set datefrom=$h
 
 If $p(recloc,"^",6)'="" Do 
 .Set dateto=$zdh($p(recloc,"^",6),5)
 Else  Do
 .Set dateto="" 
 
 If $p(recloc,"^",7)'="" Do 
 .Set timefrom=$zth($p(recloc,"^",7),3)
 Else  Do
 .Set timefrom=""
 
 If $p(recloc,"^",8)'="" Do 
 .Set timeto=$zth($p(recloc,"^",8),3)
 Else  Do
 .Set timeto="" 
 
 If $p(recloc,"^",9)="true" Do 
 .Set DefaultFlag="Y"
 Else  Do
 .Set DefaultFlag="N" 
 ;b ;;0803-1
 &SQL(select ARCRL_RowId from ARC_ItmRecLoc where ARCRL_ARCIMSub=:ARCIMSub and ARCRL_OrdLoc_DR=:patlocdr and ARCRL_RecLoc_DR=:reclocdr)
 if (SQLCODE=0) Quit "{success:'false',info:'医嘱项接收科室已经存在!'}"
 
 Tstart
 &SQL(insert into ARC_ItmRecLoc
 (ARCRL_Function,ARCRL_ARCIMSub,ARCRL_Subscript,ARCRL_OrdLoc_DR,ARCRL_RecLoc_DR,ARCRL_ARCIM_DR,ARCRL_OrderPriority_DR,ARCRL_DefaultFlag,ARCRL_DateFrom,ARCRL_DateTo,ARCRL_TimeFrom,ARCRL_TimeTo)
 values("Execute",:ARCIMSub,:Subscript,:patlocdr,:reclocdr,:arcimrowid,:priordr,:DefaultFlag,:datefrom,:dateto,:timefrom,:timeto))
 If SQLCODE=100{
	Trollback
	Quit "{success:'false',info:'医嘱项接收科室,增加失败, 请重新操作!'}"
 }
 Tc
 Quit "{success:'true',info:'接收科室,增加成功!'}"
}

/// 修改检验外码关联
/// 2013-5-22 modified by lisen
ClassMethod UpdateOrderExtCode(editorderextcode As %String) As %String
{
 Set extrowid=$p(editorderextcode,"^",1)
 Set extcode=$p(editorderextcode,"^",2)
 Set extdesc=$p(editorderextcode,"^",3)
 Set extreclocdr=$p(editorderextcode,"^",4)
 
 If $p(editorderextcode,"^",5)'="" Do 
 .Set extdatefrom=$zdh($p(editorderextcode,"^",5),5)
 Else  Do
 .Set extdatefrom=$h
 
 If $p(editorderextcode,"^",6)'="" Do 
 .Set extdateto=$zdh($p(editorderextcode,"^",6),5)
 Else  Do
 .Set extdateto="" 
 
 If $p(editorderextcode,"^",7)="true" Do 
 .Set DefaultReceive="Y"
 Else  Do
 .Set DefaultReceive="N" 
 
 If $p(editorderextcode,"^",8)="true" Do 
 .Set DEfaultSend="Y"
 Else  Do
 .Set DEfaultSend="N" 
 
 //数据验证
 s flag=""
 s:extrowid'="" id1=$p(extrowid,"||",1)
 s:extrowid'="" id2=$p(extrowid,"||",2)
 s:extcode'="" extcodeI=$ZCONVERT(extcode,"U")
 s id=$o(^ARCIM(0,"ExtCode",extcodeI,id1,id2,""))
 s flag=$d(^ARCIM(0,"ExtCode",extcodeI,id1,id2))
 if (id'=$p(extrowid,"||",3))&(flag>0) Quit "{success:'false',info:'医嘱项外部代码已经存在!'}"
 
 Tstart
 &SQL(update ARC_ItemExternalCodes set EXT_Code=:extcode,EXT_Desc=:extdesc,
     EXT_CTLOC_DR=:extreclocdr,EXT_DateFrom=:extdatefrom,
     EXT_DateTo=:extdateto,EXT_DefaultReceive=:DefaultReceive,EXT_DEfaultSend=:DEfaultSend
     where EXT_RowId=:extrowid)
 
 If SQLCODE=100{
	Trollback
	Quit "{success:'false',info:'医嘱项外部代码修改失败, 请重新操作!'}"
 }
 Tc
 Quit "{success:'true',info:'外部代码,修改成功!'}"
}

/// 修改医嘱项接收科室
/// 2013-5-22 modified by lisen
ClassMethod UpdateRecLoc(editordrecloc As %String) As %String
{
 //Set ^TEMP("cwg","UpdateRecLoc")=editordrecloc
 //set editordrecloc="12125||1^22^90^^08/03/2012^^^^true"
 
 Set ARCRLRowId=$p(editordrecloc,"^",1)
 Set patlocdr=$p(editordrecloc,"^",2)
 Set reclocdr=$p(editordrecloc,"^",3)
 Set priordr=$p(editordrecloc,"^",4)
 
 If $p(editordrecloc,"^",5)'="" Do 
 .Set datefrom=$zdh($p(editordrecloc,"^",5),5)
 Else  Do
 .Set datefrom=$h
 
 If $p(editordrecloc,"^",6)'="" Do 
 .Set dateto=$zdh($p(editordrecloc,"^",6),5)
 Else  Do
 .Set dateto="" 
 
 If $p(editordrecloc,"^",7)'="" Do 
 .Set timefrom=$zth($p(editordrecloc,"^",7),3)
 Else  Do
 .Set timefrom=""
 
 If $p(editordrecloc,"^",8)'="" Do 
 .Set timeto=$zth($p(editordrecloc,"^",8),3)
 Else  Do
 .Set timeto="" 
 
 If $p(editordrecloc,"^",9)="true" Do 
 .Set DefaultFlag="Y"
 Else  Do
 .Set DefaultFlag="N" 
 
 s:ARCRLRowId'="" ARCIMSub=$p(ARCRLRowId,"||",1)
 &SQL(select ARCRL_RowId from ARC_ItmRecLoc where ARCRL_RowId<>:ARCRLRowId and ARCRL_ARCIMSub=:ARCIMSub and ARCRL_OrdLoc_DR=:patlocdr and ARCRL_RecLoc_DR=:reclocdr)
 if (SQLCODE=0) Quit "{success:'false',info:'医嘱项接收科室已经存在!'}"
 
 Tstart
 &SQL(update ARC_ItmRecLoc set ARCRL_OrdLoc_DR=:patlocdr,ARCRL_RecLoc_DR=:reclocdr,
      ARCRL_OrderPriority_DR=:priordr,ARCRL_DateFrom=:datefrom,ARCRL_DateTo=:dateto,
      ARCRL_TimeFrom=:timefrom,ARCRL_TimeTo=:timeto,ARCRL_DefaultFlag=:DefaultFlag
      where ARCRL_RowId=:ARCRLRowId)
 
 If SQLCODE=100{
	Trollback
	Quit "{success:'false',info:'医嘱项接收科室,修改失败!'}"
 }
 Tc
 Quit "{success:'true',info:'接收科室,修改成功!'}"
}

/// 修改别名
/// 2013-5-22 modified by lisen
ClassMethod UpdateOrderAlias(editorderalias As %String) As %String
{
 Set aliasrowid=$p(editorderalias,"^",1)
 Set alias=$p(editorderalias,"^",2)
 If $p(editorderalias,"^",3)'="" Do
 .Set ALIASDateFrom=$zdh($p(editorderalias,"^",3),5)
 Else  Do
 .Set ALIASDateFrom=""
 If $p(editorderalias,"^",4)'="" Do
 .Set ALIASDateTo=$zdh($p(editorderalias,"^",4),5)
 Else  Do
 .Set ALIASDateTo=""
 Set arcimrowid=$p(editorderalias,"^",5)

 Set ALIASDesc=$p(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),1),"^",2)  //医嘱项描述
 Set ItemCatDr=$p(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),1),"^",10) //医嘱子类Dr
 
 //验证重复
 s flag=""
 s:ALIASDesc'="" ALIASDescI=$ZCONVERT(ALIASDesc,"U")
 s rowid=$o(^ARC("ALIAS",0,"Desc",alias,ALIASDescI,""))
 s flag=$d(^ARC("ALIAS",0,"Desc",alias,ALIASDescI))
 if (rowid'=aliasrowid)&(flag>0) Quit "{success:'false',info:'医嘱项别名已经存在!'}"
 
 Tstart
 &SQL(update ARC_Alias set ALIAS_Text=:alias,ALIAS_Desc=:ALIASDesc,ALIAS_OrderSubCat_DR=:ItemCatDr,ALIAS_DateFrom=:ALIASDateFrom,ALIAS_DateTo=:ALIASDateTo
   where ALIAS_RowId=:aliasrowid)
 If SQLCODE=100{
	Trollback
	Quit "{success:'false',info:'医嘱项别名更新失败, 请重新操作!'}"
 }
 Tc
 Quit "{success:'true',info:'医嘱项别名,更新成功!'}"
}

/// 删除别名
ClassMethod DeleteOrderAlias(deletealiasrowid As %String) As %String
{
 Quit:deletealiasrowid="" "{success:'false',info:'未选择医嘱项别名,不能删除!'}"
 Tstart
 &SQL(delete  from ARC_Alias  where ALIAS_RowId=:deletealiasrowid)
 
 If SQLCODE=100{
	Trollback
	Quit "{success:'false',info:'医嘱项别名删除失败, 请重新操作!'}"
 }
 Tc
 Quit "{success:'true',info:'医嘱项别名,删除成功!'}"
}

/// 删除医嘱项接收科室
ClassMethod DeleteReceiveLoc(delrowid As %String) As %String
{
 Quit:delrowid="" "{success:'false',info:'未选择医嘱项接收科室,不能删除!'}"
 Tstart
 &SQL(delete  from ARC_ItmRecLoc   where ARCRL_RowId=:delrowid)
 
 If SQLCODE=100{
	Trollback
	Quit "{success:'false',info:'医嘱项接收科室,删除失败!'}"
 }
 Tc
 Quit "{success:'true',info:'医嘱项接收科室,删除成功!'}"
}

/// 删除检验外码关联
ClassMethod DeleteOrderExtCode(extrowid As %String) As %String
{
 Quit:extrowid="" "{success:'false',info:'未选择医嘱项外部代码,不能删除!'}"
 Tstart
 &SQL(delete  from ARC_ItemExternalCodes  where EXT_RowId=:extrowid)
 
 If SQLCODE=100{
	Trollback
	Quit "{success:'false',info:'医嘱项外部代码删除失败, 请重新操作!'}"
 }
 Tc
 Quit "{success:'true',info:'医嘱项外部代码,删除成功!'}"
}

/// 增加零收费项目
ClassMethod AddZeroTarToLink(ZeroFeeStr As %String) As %String
{
	//Set ^TEMP("cwg","AddZeroTarToLink")=ZeroFeeStr
	//Set ZeroFeeStr="29^29^29^21^17^32^13363||1^AS^as"
	//Set UpdateUserDR="1"
	
	Quit:ZeroFeeStr="" "{success:'false',info:'传入参数为空,不能增加零收费项目,并做医嘱项关联!'}"
	Set tarcats=""  //收费项目费用分类串
	Set arcimrowid=$p(ZeroFeeStr,"^",7)  //在ARC_ItmMast表中arcim_rowid
	Set tarcode=$p(ZeroFeeStr,"^",8)   //收费项目代码
	Set tarname=$p(ZeroFeeStr,"^",9)   //收费项目名称
	Set chargesubcat=$p(ZeroFeeStr,"^",1)   //收费子分类
	Set emcsubcat=$p(ZeroFeeStr,"^",2)      //核算子分类
	Set acctsubcat=$p(ZeroFeeStr,"^",3)     //会计子分类
	Set inpatsubcat=$p(ZeroFeeStr,"^",4)    //住院子分类
	Set outpatsubcat=$p(ZeroFeeStr,"^",5)   //门诊子分类
	Set mrsubcat=$p(ZeroFeeStr,"^",6)       //病案首页子分类
	
	Set UpdateUserDR=%session.Get("LOGON.USERID") //增加人
	Ts
	&SQL(select count(*) into :count from  DHC_OrderLinkTar  where  OLT_ARCIM_DR=:arcimrowid)
	If count'=0 Quit "{success:'false',info:'该医嘱项, 已经存在收费项目对照关系, 不能做该项操作!'}"
	Set tarcats=chargesubcat_"#"_inpatsubcat_"#"_outpatsubcat_"#"_emcsubcat_"#"_mrsubcat_"#"_acctsubcat
	Set CurrentNS=$ZNSPACE  //保留当前NameSpace
	ZN "DHC-DATA"	//"MEDDATA"
	Set err1=$$AddTarItem^DHCSTJFTARITEM(arcimrowid,tarcats,"")   //INSERT INTO DHC_TARITEM、DHC_OrderLinkTar
	If err1=0{
	   Set err2=$$InsertARCPrice^DHCSTJFTARITEM(arcimrowid,"0",UpdateUserDR)  //维护收费项目价格
	}
	ZN CurrentNS
	
	If err1'=0 {
		Trollback
	   	Quit "{success:'false',info:'收费项目增加失败, 医嘱项与收费项目关联失败, 请重新增加收费项目,并关联!'}"		
	}
	If err2'=0 {
		Trollback
	   	Quit "{success:'false',info:'收费项目零费用价格, 维护失败,请重新维护零费用价格 !'}"		
	}
	Tc
	Quit "{success:'true',info:''}"
}

/// 医嘱复制
/// 2013-5-15 modified by lisen
ClassMethod SaveAsAddOrder(ArcItmMastStr As %String, ZeroFeeStr As %String, AddOrdLinkTar As %String) As %String
{
    //Set ^TEMP("cwg","Save")=ArcItmMastStr_"###"_ZeroFeeStr
    //Set UpdateUserDR="1"
    //Set ArcItmMastStr="HL0017CZXYK76^二级护理76(中西医科)(日)^1^217^58^58||1^167^3^true^false^2012/07/11^^二级护理76(中西医科)(日)^^^13444||1^ejhl/ejhlzxyjhyk/zxyjhyk/"
    //Set ZeroFeeStr="29^29^29^21^17^32"
    //If ordercode=""  Quit "{success:'false',info:'医嘱代码不能为空!'}"
    //Set UpdateUserDR="1"
    
    Set arcim=""
	Set UpdateUserDR=%session.Get("LOGON.USERID") //增加人

    Set UpdateDate=$p($h,",",1)                   //增加日期
    Set UpdateTime=$p($h,",",2)                   //增加时间
	Set ordercode=$$ALPHAUP^SSUTIL4($p(ArcItmMastStr,"^",1))         //代码
	If ordercode'=""  s arcim=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ordercode),""))
	If arcim'="" Quit "{success:'false',info:'医嘱代码已经存在, 不能重复增加!'}"
	
	Set orderdesc=$p(ArcItmMastStr,"^",2)         //描述
	If orderdesc'="" s arcim=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(orderdesc),""))
	If arcim'="" Quit "{success:'false',info:'医嘱名称已经存在, 不能重复增加!'}"
	
	Set orderabbrev=$p(ArcItmMastStr,"^",3)       //缩写
	If orderabbrev="" Do
	.Set orderabbrev=orderdesc
	Set arcitemcatdr=$p(ArcItmMastStr,"^",4)      //医嘱子分类
	Set billgroupdr=$p(ArcItmMastStr,"^",5)       //帐单组
	Set subbillgroupdr=$p(ArcItmMastStr,"^",6)    //帐单子组
	Set billunitdr=$p(ArcItmMastStr,"^",7)        //计帐单位
	Set defaultprioritydr=$p(ArcItmMastStr,"^",8) //默认优先级
	
	Set Tindependentchk=$p(ArcItmMastStr,"^",9)   //独立医嘱 true/false
	If Tindependentchk="true" Do
	.Set independentchk="Y"
	Else  Do
	.Set independentchk="N"
	
	Set Tnostockchk=$p(ArcItmMastStr,"^",10)      //无库存医嘱 true/false
	If Tnostockchk="true" Do
	.Set nostockchk="Y"
	Else  Do
	.Set nostockchk="N"

	Set fromdate=$p(ArcItmMastStr,"^",11)         //有效开始日期
	Set todate=$p(ArcItmMastStr,"^",12)           //有效截止日期
	Set orderadvice=$p(ArcItmMastStr,"^",13)      //医嘱提示框
	Set resourcegroupdr=$p(ArcItmMastStr,"^",14)  //服务资源组
	
	Set Tservicematerial=$p(ArcItmMastStr,"^",15) //服务/材料 1/2
	Set orderalias=$p(ArcItmMastStr,"^",17)       //医嘱项别名

	Set servicematerial=""
	If Tservicematerial="1" Do
	.Set servicematerial="S"
	
	If Tservicematerial="2" Do
	.Set servicematerial="M"

	Set obj=##class(User.ARCItmMast).%New()
    Set obj.ARCIMCode=ordercode                               //医嘱代码  ARCIM_Code
    Set obj.ARCIMDesc=orderdesc                               //医嘱描述  ARCIM_Desc
    Set obj.ARCIMAbbrev=orderabbrev                           //缩写      ARCIM_Abbrev
    Do obj.ARCIMItemCatDRSetObjectId(arcitemcatdr)            //医嘱子分类 ARCIM_ItemCat_DR
    Do obj.ARCIMBillSubDRSetObjectId(subbillgroupdr)          //帐单子组  ARCIM_BillSub_DR
    Do obj.ARCIMBillingUOMDRSetObjectId(billunitdr)           //计帐单位 ARCIM_BillingUOM_DR
    Do obj.ARCIMDefPriorityDRSetObjectId(defaultprioritydr)   //默认优先级 ARCIM_DefPriority_DR
    Set obj.ARCIMOrderOnItsOwn=independentchk                 //独立医嘱  ARCIM_OrderOnItsOwn
    Set obj.ARCIMAllowOrderWOStockCheck=nostockchk            //无库存医嘱 ARCIM_AllowOrderWOStockCheck

    If orderadvice'="" Do
    .Set OEMessagLen=$LENGTH(orderadvice,""_$c(13,10)_"")
	.For i=1:1:OEMessagLen Do
	..Set DataString=$P(orderadvice,""_$c(13,10)_"",i)
	..Do obj.ARCIMOEMessage.Insert(DataString)         //插入医嘱提示框内容

    Do obj.ARCIMServiceGroupDRSetObjectId(resourcegroupdr)    //服务资源组 ARCIM_ServiceGroup_DR
    
    If servicematerial'="" Set obj.ARCIMServMaterial=servicematerial      //服务/材料 ARCIM_ServMaterial
    
    Do obj.ARCIMUpdateUserSetObjectId(UpdateUserDR)           //增加人 ARCIM_UpdateUser
    Set obj.ARCIMUpdateDate=UpdateDate                        //增加日期 ARCIM_UpdateDate
    Set obj.ARCIMUpdateTime=UpdateTime                        //增加时间 ARCIM_UpdateTime
	
	Set obj.ARCIMChgPostFlg="O"  //ARCIM_ChgPostFlg  查找必须赋值，才能增加的原因?
	
	If fromdate'="" Do
	.Set fromdate=$zdh(fromdate,5)                                    
	.Set obj.ARCIMEffDate=fromdate                 //有效开始日期  ARCIM_EffDate
	If todate'="" Do
	.Set todate=$zdh(todate,5)
	.Set obj.ARCIMEffDateTo=todate                 //有效截止日期  ARCIM_EffDateTo
	Set arcim=""    //增加医嘱项的arcim_owid
	
	//增加医嘱项事务-01
	Tstart   
	Set sc=obj.%Save()
	Set arcim=obj.%Id() //增加医嘱项的arcim_owid
		If $$$ISERR(sc){
	    Trollback
	    Quit "{success:'false',info:'医嘱项增加失败, 请重新操作!'}"
	}
	Tc
	
	//增加收费项目,及医嘱项与收费项目的关联,事务-02
	If ZeroFeeStr'="" {
		Tstart
		Set err1=100
		Set tarcats=""  //收费项目费用分类串
		Set tarcode=ordercode   //收费项目代码
		Set tarname=orderdesc   //收费项目名称
		Set tarunitDr=billunitdr                //收费单位
		Set chargesubcat=$p(ZeroFeeStr,"^",1)   //收费子分类
		Set emcsubcat=$p(ZeroFeeStr,"^",2)      //核算子分类
		Set acctsubcat=$p(ZeroFeeStr,"^",3)     //会计子分类
		Set inpatsubcat=$p(ZeroFeeStr,"^",4)    //住院子分类
		Set outpatsubcat=$p(ZeroFeeStr,"^",5)   //门诊子分类
		Set mrsubcat=$p(ZeroFeeStr,"^",6)       //病案首页子分类
	
		Set tarcats=chargesubcat_"#"_inpatsubcat_"#"_outpatsubcat_"#"_emcsubcat_"#"_mrsubcat_"#"_acctsubcat
		Set CurrentNS=$ZNSPACE  //保留当前NameSpace
		ZN "DHC-DATA"	//"MEDDATA"
		Set err1=$$AddTarItem^DHCSTJFTARITEM(arcim,tarcats,"")   //INSERT INTO DHC_TARITEM、DHC_OrderLinkTar
		If err1=0{
	   		Set err2=$$InsertARCPrice^DHCSTJFTARITEM(arcim,"0",UpdateUserDR)  //维护收费项目价格
		}
		ZN CurrentNS
	
		Tc	
		If err1'=0 {
	   		Quit "{success:'false',info:'零收费项目增加失败, 医嘱项与零收费项目关联失败, 请重新增加零收费项目,并关联!'}"		
		}
		If err2'=0 {
	   		Quit "{success:'false',info:'收费项目零费用价格, 维护失败,请重新维护零费用价格 !'}"		
		}
	}
	
	//增加收费项目、并关联医嘱项事务-03
	if (AddOrdLinkTar'="") {
		Tstart
		s arcimdr=arcim //医嘱项rowid
		s tarlength=$length(AddOrdLinkTar,"*")
		for i=1:1:tarlength {
			s StrAddOrdLinkTar=$p(AddOrdLinkTar,"*",i)
 			s olttariffdr=$p(StrAddOrdLinkTar,"^",1) //收费项目id
 			s oltqty=$p(StrAddOrdLinkTar,"^",2) //收费数量
 			s oltstart=$p(StrAddOrdLinkTar,"^",3)
 			s:oltstart'="" oltstart=$zdh(oltstart,5) //开始日期
 			s oltend=$p(StrAddOrdLinkTar,"^",4)
			s:oltend'="" oltend=$zdh(oltend,5) //截止日期
 			//If $zdh(oltstart,5)<$h Quit "{success:'false',info:'关联收费项目的开始日期早于当天日期, 增加失败!'}"
 			&SQL(insert into DHC_OrderLinkTar (OLT_ARCIM_DR,OLT_Tariff_DR,OLT_Qty,OLT_StartDate,OLT_EndDate) values(:arcimdr,:olttariffdr,:oltqty,:oltstart,:oltend))
 		}
		If SQLCODE=100{
			Trollback
	 		Quit "{success:'false',info:'医嘱项增加成功! 收费项目增加失败, 医嘱项与收费项目关联失败, 请重新增加收费项目,并关联!'}"
 		}
 		Tc
	}
	
	//增加医嘱项别名,事务-04
	Tstart       
	Set SQLCODE=100
	Set ALIASDateFrom=+$h
	If orderalias'="" Do
    .Set orderaliasLen=$LENGTH(orderalias,"/")
	.For i=1:1:orderaliasLen Do
	..Set alias=$P(orderalias,"/",i)
	..If alias'="" Do
	...Set alias=$$ALPHAUP^SSUTIL4(alias)
	...&SQL(insert into ARC_Alias (ALIAS_ARCIM_DR,ALIAS_Text,ALIAS_Desc,ALIAS_OrderSubCat_DR,ALIAS_Type,ALIAS_OrderOnItsOwn,ALIAS_DateFrom) values(:arcim,:alias,:orderdesc,:arcitemcatdr,"ARCIM","Y",:ALIASDateFrom))	
	...
	Tc

	If SQLCODE'=0 {
	   Quit "{success:'false',info:'医嘱项别名增加失败, 请通过<医嘱别名>按钮增加!'}"		
	}
	Else {
	   Quit "{success:'true',id:'"_obj.%Id()_"'}"	
	}
}

Storage Default
{
<Data name="itmmastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBL.CT.itmmastD</DataLocation>
<DefaultData>itmmastDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBL.CT.itmmastD</IdLocation>
<IndexLocation>^web.DHCBL.CT.itmmastI</IndexLocation>
<StreamLocation>^web.DHCBL.CT.itmmastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
