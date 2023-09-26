Import sqluser

/// creator:    yunhaibao
/// createdate: 2017-06-26
/// description:与web.DHCST.Util.DrugUtil对应,建立相应query,仅返回数据集
/// others:		ext\easyui等需要的数据格式有所区别
Class web.DHCST.Util.DrugUtilQuery Extends %RegisteredObject [ ProcedureBlock ]
{

/// deccription:费用大类
/// table:      User.ARCBillGrp
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetArcBillGrp")
Query GetArcBillGrp() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetArcBillGrpExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select ARCBG_RowId AS RowId, ARCBG_DESC AS Description from ARC_BillGrp ORDER BY ARCBG_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:费用子类
/// table:      User.ARCBillSub
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetArcBillSub",52)
Query GetArcBillSub(ARCBGRowId = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetArcBillSubExecute(ByRef qHandle As %Binary, ARCBGRowId = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	///q:ARCBGRowId="" $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr="select ARCSG_RowId AS RowId, ARCSG_DESC AS Description from ARC_BillSub "
    i ARCBGRowId'="" s sqlStr=sqlStr_"WHERE ARCSG_ARCBG_ParRef = "_ARCBGRowId_" "
    s sqlStr=sqlStr_"ORDER BY ARCSG_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:医嘱大类
/// table:      User.ARCItemCat
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetOrderCategory")
Query GetOrderCategory() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetOrderCategoryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr="select distinct arcic_ordcat_dr->orcat_rowid as RowId,arcic_ordcat_dr->orcat_desc as Description from ARC_ItemCat  where arcic_ordertype="_"'"_"R"_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:医嘱子类
/// table:      User.ARCItemCat
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetArcItemCat","")
Query GetArcItemCat(OrdCat = "", Desc = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetArcItemCatExecute(ByRef qHandle As %Binary, OrdCat = "", Desc = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    i OrdCat'="" d
    .s sqlStr = "SELECT ARCIC_RowId as RowId, ARCIC_Desc as Description FROM ARC_ItemCat where  ARCIC_OrdCat_DR="_OrdCat_" and ARCIC_Desc like'%"_Desc_"%' ORDER BY Description"
    e  d
    .s sqlStr = "SELECT ARCIC_RowId as RowId, ARCIC_Desc as Description FROM ARC_ItemCat where ARCIC_OrderType='R' and ARCIC_Desc like'%"_Desc_"%' ORDER BY Description"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:医嘱优先级
/// table:      User.OECPriority
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetOECPriority")
Query GetOECPriority() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetOECPriorityExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select OECPR_RowId as RowId, OECPR_Desc as Description from OEC_Priority ORDER BY OECPR_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:单位
/// table:      User.CTUOM
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetCTUom")
Query GetCTUom(CTUomDesc = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetCTUomExecute(ByRef qHandle As %Binary, CTUomDesc = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select CTUOM_RowID AS RowId, CTUOM_DESC AS Description from CT_UOM where CTUOM_DESC like '%"_CTUomDesc_"%' order by CTUOM_RowID"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:剂型
/// table:      User.PHCForm
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPhcForm","",1)
Query GetPhcForm(PHCFDesc = "", FormId = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPhcFormExecute(ByRef qHandle As %Binary, PHCFDesc = "", FormId = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    i FormId="" d
    .s sqlStr = "select PHCF_RowId AS RowId , PHCF_DESC AS Description from PHC_Form WHERE PHCF_DESC LIKE '%"_PHCFDesc_"%' order by PHCF_RowId "
    e  d
    .s sqlStr = "select PHCF_RowId AS RowId , PHCF_DESC AS Description from PHC_Form WHERE PHCF_RowId="_FormId
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:用法
/// table:      User.PHCInstruc
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPHCInstruc")
Query GetPHCInstruc(PHCInDesc = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPHCInstrucExecute(ByRef qHandle As %Binary, PHCInDesc = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PHCIN_RowId AS RowId, PHCIN_DESC1 AS Description from PHC_Instruc WHERE PHCIN_DESC1 like '%"_PHCInDesc_"%' order by PHCIN_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:频次
/// table:      User.PHCFreq
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPHCFreq")
Query GetPHCFreq(PhcFrDesc = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPHCFreqExecute(ByRef qHandle As %Binary, PhcFrDesc = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT phcfr_RowId AS RowId, phcfr_desc1 AS Description  FROM  phc_freq where phcfr_desc1 like '%"_PhcFrDesc_"%' order by phcfr_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:疗程
/// table:      User.PHCDuration
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPhcDuration")
Query GetPhcDuration(PhcDuDesc = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPhcDurationExecute(ByRef qHandle As %Binary, PhcDuDesc = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PHCDU_RowId AS RowId, PHCDU_DESC1 AS Description from Phc_Duration WHERE PHCDU_DESC1 like '%"_PhcDuDesc_"%' order by PHCDU_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:管制分类
/// table:      User.PHCPoison
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPhcPoison")
Query GetPhcPoison() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPhcPoisonExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select PHCPO_RowId AS RowId, PHCPO_DESC AS Description from phc_poison ORDER BY PHCPO_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:医保类别
/// table:      User.DHCItmInsuCategory
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetInsuCat")
Query GetInsuCat() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetInsuCatExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s sqlStr = "SELECT IC_Rowid as RowId, IC_Desc as Description FROM DHC_ItmInsuCategory"_
    "  where IC_DateFrom<="_date_" and IC_DateTo>="_date_" order by RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:草药备注
/// global:     ^DHCDocConfig("CNMedItemPhSpecInstr")
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPHCSpecInc")
Query GetPHCSpecInc() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPHCSpecIncExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    i $d(^DHCDocConfig("CNMedItemPhSpecInstr")) D
    .S list = ^DHCDocConfig("CNMedItemPhSpecInstr")
    .s list = $tr(list,$c(1),"-")
    .s i = 1
    .f  s id=$P(list, "^", i) q:id=""  d
    ..s Description=$p(id,"-",2)
    ..s RowId=$p(id,"-",1)
    ..s i = i+1  
    ..d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:高危级别
/// table:      
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetHighRiskLevel")
Query GetHighRiskLevel() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetHighRiskLevelExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s list="H-普通高危^S-特殊高危"
    s i = 1
    f  s id=$P(list, "^", i) q:id=""  d
    .s Description=$p(id,"-",2)
    .s RowId=$p(id,"-",1)
    .s i = i+1  
    .d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:药品配液分类
/// table:      User.DHCPHCPivaCat
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPHCPivaCat")
Query GetPHCPivaCat() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPHCPivaCatExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s pivaCatId=0
    f  s pivaCatId=$o(^PHCPIVACAT(pivaCatId)) q:pivaCatId=""  d
    .q:'$d(^PHCPIVACAT(pivaCatId))
    .s PivaCatDesc=$p(^PHCPIVACAT(pivaCatId),"^",2)
    .d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(pivaCatId,PivaCatDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:库存分类
/// table:      User.INCStkCat
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetINCSCStkGrp")
Query GetINCSCStkGrp() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetINCSCStkGrpExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s incsc=0
	f  s incsc=$o(^INC("SC",incsc)) q:+incsc'>0  d 
	.q:'$d(^DHCSCG("STKCAT",incsc))
	.s scg=$o(^DHCSCG("STKCAT",incsc,"")) 
	.q:scg=""
	.s tmpstktype=$p(^DHCSCG(scg),"^",3)
	.q:tmpstktype'="G"
	.s incscdesc=$p(^INC("SC",incsc),"^",2)
    .d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(incsc,incscdesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:医保类别-G,批准文号-Gp,处方类别-Gpp,招标级别-Gpbl,质量层次-Gzl 的下拉数据集合
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetOfficeCode","Gp")
Query GetOfficeCode(type) As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetOfficeCodeExecute(ByRef qHandle As %Binary, type) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    i $d(^DHCSTOFFICODE(type)) D
    .S list = ^DHCSTOFFICODE(type)
    .s i = 1
    .f  s id=$P(list, "^", i) q:id=""  d
    ..s i = i+1  
    ..d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(id,id)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:账簿分类
/// table:      User.DHCSTBookCat
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetBookCat")
Query GetBookCat() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetBookCatExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT BC_RowId as RowId, BC_Desc as Description FROM DHCST_BookCat order by BC_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:定价类型
/// table:      User.DHCMarkType
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetMarkType")
Query GetMarkType() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetMarkTypeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT MT_RowId as RowId,  MT_Desc as Description FROM DHC_MarkType where MT_UseFlag='Y' and MT_Type='G' ORDER BY MT_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:招标名称
/// table:      User.DHCPublicBiddingList
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPublicBiddingList")
Query GetPublicBiddingList() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPublicBiddingListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT DHCPBL_RowId as RowId, DHCPBL_Desc as Description , DHCPBL_Desc as Description,DHCPBL_ActiveFlag as ActiveFlag,DHCPBL_EfficDateFrom as EfficStartDate,DHCPBL_EfficDateTo as EfficEndDate FROM DHC_PublicBiddingList where DHCPBL_Desc is not null and DHCPBL_Type='G' order by DHCPBL_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        s ActiveFlag=result.Data("ActiveFlag") 
        continue:ActiveFlag'="Y"
        s EfficStartDate=result.Data("EfficStartDate") 
        s EfficEndDate=result.Data("EfficEndDate") 
        continue:(EfficEndDate'="")&&(EfficEndDate<$h)
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:招标级别
/// table:      User.DHCItmPBLevel
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPBLevel")
Query GetPBLevel() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPBLevelExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s sqlStr = "SELECT PBL_Rowid as RowId, PBL_Desc as Description FROM DHC_ItmPBLevel"_
    "  where PBL_DateFrom<="_date_" and PBL_DateTo>="_date_" order by RowId"    
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:进口标志
/// table:      
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetImportFlag")
Query GetImportFlag() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetImportFlagExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s list="国产-国产^进口-进口"
    s i = 1
    f  s id=$P(list, "^", i) q:id=""  d
    .s Description=$p(id,"-",2)
    .s RowId=$p(id,"-",1)
    .s i = i+1  
    .d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:质量层次
/// table:      User.DHCItmPBLevel
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetQualityLevel")
Query GetQualityLevel() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetQualityLevelExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s sqlStr = "SELECT QL_Rowid as RowId, QL_Desc as Description FROM DHC_ItmQualityLevel"_
    "  where QL_DateFrom<="_date_" and QL_DateTo>="_date_" order by RowId" 
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:不可用原因
/// table:      User.DHCItmNotUseReason
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetItmNotUseReason")
Query GetItmNotUseReason() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetItmNotUseReasonExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DIUR_Rowid as RowId, DIUR_Desc as Description FROM DHC_ItmNotUseReason"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:根据医嘱项ID获取WhoDDD单位的列表
/// table:      
/// input:		strParams(医嘱项ID)
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","PHCDFWhoDDDUom","858||1")
Query PHCDFWhoDDDUom(strParams) As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PHCDFWhoDDDUomExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s arcItmId=$p(strParams,"^",1)
	q:arcItmId="" $$$OK
	s phcdfRowId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcItmId)
	s phcdId=+phcdfRowId
	s dfId=+$p(phcdfRowId,"||",2)
	q:((phcdId=0)||(dfId=0)) $$$OK	
	k PHCDFWhoDDDUomArr
	s bUomId=$p(^PHCD(phcdId,"DF",dfId,2),"^",4)
	i bUomId'="" s PHCDFWhoDDDUomArr(bUomId)=""
	s eqSub="0"
	f  s eqSub=$o(^PHCD(phcdId,"DF",dfId,"EQ",eqSub)) q:eqSub=""  d
	.s eqStr=^PHCD(phcdId,"DF",dfId,"EQ",eqSub)
	.s uomId=$p(eqStr,"^",1)
	.q:uomId=""
	.s PHCDFWhoDDDUomArr(uomId)=""
	s uomId=""
	f  s uomId=$o(PHCDFWhoDDDUomArr(uomId)) q:uomId=""  d
	.s uomDesc=$p($g(^CT("UOM",uomId)),"^",2)
	.q:uomDesc=""
	.d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(uomId,uomDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:WhoNet码
/// input:		StrParams(前台录入数据,模糊检索)
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetWhonetInfo","TR")
Query GetWhonetInfo(StrParams = "") As websys.Query(ROWSPEC = "antCode:%String,antName:%String,antEName:%String")
{
}

ClassMethod GetWhonetInfoExecute(ByRef qHandle As %Binary, StrParams = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s inputText=$p(StrParams,"^",1)
	s inputText=$$ALPHAUP^SSUTIL4($tr(inputText,$c(13,10),""))
	i $d(^DHCLISBSVersion(1)) d //BS-LIS
	.s LabData="dhc-lisdata"
	.s wCode="" f  s wCode=$o(^[LabData]dbo.BTAntibioticsI("IndexWCode",wCode)) q:wCode=""  d
	..s AntibioticsDR=$o(^[LabData]dbo.BTAntibioticsI("IndexWCode",wCode,""))
	..i '$l(AntibioticsDR) q
	..s AntibioticsData=$g(^[LabData]dbo.BTAntibioticsD(AntibioticsDR))
	..s antCode=$lg(AntibioticsData,6)
	..s antName=$lg(AntibioticsData,3)
	..s antEName=$lg(AntibioticsData,4)
    ..s antCode1=$$ALPHAUP^SSUTIL4($tr(antCode,$c(13,10),""))
    ..i inputText'="" Q:antCode1'[inputText
	..d outputRow
	e  d //LabTrak
    .s LabData="labdata"
    .s wCode="" f  s wCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode)) q:wCode=""  d
    ..s antCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode,"")) q:antCode=""
    ..s antCode1=$$ALPHAUP^SSUTIL4($tr(antCode,$c(13,10),""))
    ..i inputText'="" Q:antCode1'[inputText
    ..s antName=$p(^[LabData]TTAB("ANT",antCode),"\",1) q:antName=""
    ..s antName=$tr(antName,$c(13,10),"")
    ..s antName=$Replace(antName,"'","-")
    ..s antEName=$p(^[LabData]DHCANTIBIOTICS(antCode),"\",1)
    ..s antEName=$tr(antEName,$c(13,10),"")
	..d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(antCode,antName,antEName)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:子分类
/// table:      User.DHCTarSubCate
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetTarSubCate")
Query GetTarSubCate() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetTarSubCateExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TARSC_RowId as RowId,TARSC_Desc as Description from DHC_TarSubCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:会计子分类
/// table:      User.DHCTarAcctCate
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetTarAcctCate")
Query GetTarAcctCate() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetTarAcctCateExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TARAC_RowId as RowId,TARAC_Desc as Description from DHC_TarAcctCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:住院子分类
/// table:      User.DHCTarInpatCate
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetTarInpatCate")
Query GetTarInpatCate() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetTarInpatCateExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TARIC_RowId as RowId,TARIC_Desc as Description from DHC_TarInpatCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:门诊子分类
/// table:      User.DHCTarOutpatCate
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetTarOutpatCate")
Query GetTarOutpatCate() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetTarOutpatCateExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TAROC_RowId as RowId,TAROC_Desc as Description from DHC_TarOutpatCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:病案首页分类
/// table:      User.DHCTarMRCate
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetTarMRCate")
Query GetTarMRCate() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetTarMRCateExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TARMC_RowId as RowId,TARMC_Desc as Description from DHC_TarMRCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:核算子分类
/// table:      User.DHCTarEMCCate
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetTarEMCCate")
Query GetTarEMCCate() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetTarEMCCateExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select TAREC_RowId as RowId,TAREC_Desc as Description from DHC_TarEMCCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:新病案首页
/// table:      
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetTarNewMRCate")
Query GetTarNewMRCate() As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetTarNewMRCateExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	S rowID=0
	F  S rowID=$o(^DHCTarC("MCNew",rowID)) Q:(rowID="")  D
	.S mcDesc=$p(^DHCTarC("MCNew",rowID),"^",2)
	.q:mcDesc=""
	.d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(rowID,mcDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:化学通用名
/// table:      
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetChemical","","")
Query GetChemical(InputStr = "", ChemId = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetChemicalExecute(ByRef qHandle As %Binary, InputStr = "", ChemId = "") As %Status
{
	s ind=1
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	q:(InputStr="")&&(ChemId="") $$$OK
	s ComboText=$p(InputStr,"^",1)
	s ComboText=$$ALPHAUP^SSUTIL4(ComboText)
	i ChemId'="" d
	.s chemicalId=ChemId
	.d GetChemicalData
	e  d
	.s chemicalId=""
	.f  s chemicalId=$o(^DHCPHCM(chemicalId)) q:chemicalId=""  d
	..d GetChemicalData
	q:'$d(GetChemicalDataArr) $$$OK
	s sortIndex=""
	f  s sortIndex=$o(GetChemicalDataArr(sortIndex)) q:sortIndex=""  d
	.s chemicalId=""
	.f  s chemicalId=$o(GetChemicalDataArr(sortIndex,chemicalId)) q:chemicalId=""  d
	..s chemData=GetChemicalDataArr(sortIndex,chemicalId)
	..s ^CacheTemp(repid,ind)=$lfs(chemData,"^")    
	..s ind=ind+1
	Quit $$$OK
GetChemicalData
	q:+chemicalId=0
	s chemicalDesc=$p(^DHCPHCM(chemicalId),"^",2)
	s chemicalDescPY=""
	i ComboText'="" s chemicalDescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(chemicalDesc)
	q:(ComboText'="")&&(chemicalDescPY'[ComboText)&&(chemicalDesc'[ComboText)
	s sortIndex=chemicalDesc
	s GetChemicalDataArr(sortIndex,chemicalId)=chemicalId_"^"_chemicalDesc
	q
}

/// deccription:处方通用名
/// table:      
/// d ##class(%ResultSet).RunQuery("web.DHCST.Util.DrugUtilQuery","GetPhcGeneric","","","251||1")
Query GetPhcGeneric(ComboText = "", GenericId = "", ArcItmId = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetPhcGenericExecute(ByRef qHandle As %Binary, ComboText = "", GenericId = "", ArcItmId = "") As %Status
{
	s ind=1
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	q:(ComboText="")&&(GenericId="")&&(ArcItmId="") $$$OK
	s ComboText=$$ALPHAUP^SSUTIL4(ComboText)
	i GenericId'="" d
	.s genericId=GenericId
	.d GetPhcGenericData
	e  i ArcItmId'="" d
	.s phcdId=$p(^ARCIM(+ArcItmId,1,1),"^",12)
	.q:+phcdId=0
	.s genericId=$p($g(^PHCD(+phcdId,4)),"^",1)
	.q:genericId=""
	.d GetPhcGenericData
	e  d
	.s genericId=""
	.f  s genericId=$o(^PHCGE("GE",genericId)) q:genericId=""  d
	..q:+genericId=0 
	..s genericData=^PHCGE("GE",genericId)
	..// 根据别名时判断起止日期
	..s dateFrom=$p(genericData,"^",5)
	..s dateTo=$p(genericData,"^",6)
	..q:(dateFrom'="")&&(dateFrom>+$h)
	..q:(dateTo'="")&&(dateTo<=+$h)
	..d GetPhcGenericData
	q:'$d(GetPhcGenericDataArr) $$$OK
	s sortIndex=""
	f  s sortIndex=$o(GetPhcGenericDataArr(sortIndex)) q:sortIndex=""  d
	.s geneId=""
	.f  s geneId=$o(GetPhcGenericDataArr(sortIndex,geneId)) q:geneId=""  d
	..s geneData=GetPhcGenericDataArr(sortIndex,geneId)
	..s ^CacheTemp(repid,ind)=$lfs(geneData,"^")    
	..s ind=ind+1
	k GetPhcGenericDataArr
	Quit $$$OK
GetPhcGenericData
	s geneData=^PHCGE("GE",genericId)
	s genericDesc=$p(geneData,"^",2)
	s genericDescPY=""
	i ComboText'="" s genericDescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(genericDesc)
	q:(ComboText'="")&&(genericDescPY'[ComboText)&&(genericDesc'[ComboText)
	s sortIndex=genericDesc
	s GetPhcGenericDataArr(genericDesc,genericId)=genericId_"^"_genericDesc
	q
}

}
