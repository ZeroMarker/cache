Import sqluser

Class web.HRPInterface.DHCWL.DictionariesForHRP Extends %RegisteredObject
{

/// Creator：       PuGaila
/// CreatDate：     2021-09-26
/// Description:：  3.10.1.1. 收入分类字典
/// Table：         Income_classification_dictionary
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.Income_classification_dictionary
Query Incomeclassificationdictionary() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = Income_classification_dictionary ]
{
select 
cast(TAREC_TARTEC_DR  AS VARCHAR(20)) as APHI_TarEC_CODE,
cast(TAREC_TARTEC_DR ->TARTEC_Desc AS VARCHAR(100)) as APHI_TarEC_Name,
cast(TAREC_RowId  AS VARCHAR(20)) as APHI_TarEMC_CODE,
cast(TAREC_Desc  AS VARCHAR(100)) as APHI_TarEMC_Name,
'' as IS_Valid
from SQLUser.DHC_TarEMCCate
}

/// Creator：       ET
/// CreatDate：     2021-06-09
/// Description:：  科室字典
/// Table：         DICT_HIS_DEPT_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.DICT_HIS_DEPT_VIEW
Query deptView() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_HIS_DEPT_VIEW ]
{
SELECT
CAST(CTLOC_RowID AS VARCHAR(50)) AS DEPT_CODE ,    
--CAST(CTLOC_Code AS VARCHAR(50)) AS DEPT_CODE ,   
CAST(CTLOC_Desc AS VARCHAR(50)) as DEPT_NAME
FROM sqluser.CT_Loc
}

/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  收费类别-核算子分类
/// Table：         DICT_CHARGE_KIND_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW
Query itemView() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_CHARGE_KIND_VIEW ]
{
SELECT 
CAST(TAREC_RowId AS VARCHAR(20)) AS CHARGE_KIND_CODE,
--CAST(TAREC_Code AS VARCHAR(20)) AS CHARGE_KIND_CODE,
CAST(TAREC_Desc AS VARCHAR(40)) AS CHARGE_KIND_NAME,
CAST(
CASE 
WHEN TAREC_Desc LIKE '%药%' and TAREC_Desc <> '煎药' THEN  '02' 
WHEN TAREC_Desc LIKE '%材%'  THEN  '03' 
ELSE '01'
END 
AS VARCHAR(20)) as CHARGE_FLAG
FROM sqluser.DHC_TarEMCCate
}

/// Others：       select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW2
///                O门诊子类、I住院子类
Query itemView2() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_CHARGE_KIND_VIEW2 ]
{
SELECT 
CAST(  'O' ||TAROC_RowId AS VARCHAR(20)) AS CHARGE_KIND_CODE,
CAST(  'O' ||TAROC_Desc AS VARCHAR(50)) AS CHARGE_KIND_NAME,
CAST(
CASE 
WHEN TAROC_Desc LIKE '%药%' and TAROC_Desc <> '煎药' THEN  '02'
WHEN TAROC_Desc LIKE '%材%'  THEN  '03'   
ELSE '01'
END 
AS VARCHAR(20)) as CHARGE_FLAG
FROM sqluser.DHC_TarOutpatCate

UNION ALL

SELECT 
CAST( 'I' ||TARIC_RowId AS VARCHAR(20)) AS CHARGE_KIND_CODE,
CAST( 'I' ||TARIC_Desc AS VARCHAR(50)) AS CHARGE_KIND_NAME,
CAST(
CASE 
WHEN TARIC_Desc LIKE '%药%' and TARIC_Desc <> '煎药' THEN  '02'  
WHEN TARIC_Desc LIKE '%材%'  THEN  '03'
ELSE '01'
END 
AS VARCHAR(20)) as CHARGE_FLAG
FROM sqluser.DHC_TarInpatCate
}

/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  收费类别-会计子分类
/// Table：         DICT_CHARGE_KIND_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW3
Query itemView3() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_CHARGE_KIND_VIEW3 ]
{
SELECT 
CAST(TARAC_RowId AS VARCHAR(20)) AS CHARGE_KIND_CODE,
--CAST(TAREC_Code AS VARCHAR(20)) AS CHARGE_KIND_CODE,
CAST(TARAC_Desc AS VARCHAR(40)) AS CHARGE_KIND_NAME,
CAST(
CASE 
WHEN TARAC_Desc LIKE '%药%' and TARAC_Desc <> '煎药' THEN  '02' 
WHEN TARAC_Desc LIKE '%材%'  THEN  '03' 
ELSE '01'
END 
AS VARCHAR(20)) as CHARGE_FLAG
FROM sqluser.DHC_TarAcctCate
}

/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  收费类别-会计大类
/// Table：         DICT_CHARGE_KIND_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW4
Query itemView4() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_CHARGE_KIND_VIEW4 ]
{
SELECT 
CAST(TARTAC_RowId AS VARCHAR(20)) AS CHARGE_KIND_CODE,
--CAST(TARTAC_Code AS VARCHAR(20)) AS CHARGE_KIND_CODE,
CAST(TARTAC_Desc AS VARCHAR(40)) AS CHARGE_KIND_NAME,
CAST(
CASE 
WHEN TARTAC_Desc LIKE '%药%' and TARTAC_Desc <> '煎药' THEN  '02' 
WHEN TARTAC_Desc LIKE '%材%'  THEN  '03' 
ELSE '01'
END 
AS VARCHAR(20)) as CHARGE_FLAG
FROM sqluser.DHC_TarAC
}

/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  收费类别-病案分类
/// Table：         DICT_CHARGE_KIND_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW5
Query itemView5() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_CHARGE_KIND_VIEW5 ]
{
SELECT 
CAST(TARMC_RowId AS VARCHAR(20)) AS CHARGE_KIND_CODE,
--CAST(TARTAC_Code AS VARCHAR(20)) AS CHARGE_KIND_CODE,
CAST(TARMC_Desc AS VARCHAR(40)) AS CHARGE_KIND_NAME,
CAST(
CASE 
WHEN TARMC_Desc LIKE '%药%' and TARMC_Desc <> '煎药' THEN  '02' 
WHEN TARMC_Desc LIKE '%材%'  THEN  '03' 
ELSE '01'
END 
AS VARCHAR(20)) as CHARGE_FLAG
FROM SQLUser.DHC_TarMRCate
}

/// Creator：       ET
/// CreatDate：     2021-06-09
/// Description:：  收费项目
/// Table：         DICT_CHARGE_DETAIL_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.DICT_CHARGE_DETAIL_VIEW
Query DETAILVIEW() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_CHARGE_DETAIL_VIEW ]
{
SELECT
CAST(TARI_RowId AS VARCHAR(50)) as CHARGE_DETAIL_CODE, 
CAST(TARI_Desc AS VARCHAR(200)) as CHARGE_DETAIL_NAME,
CAST(TARI_OutpatCate->TAROC_TARTOC_DR AS VARCHAR(50)) as CHARGE_KIND_CODE1,
CAST(TARI_InpatCate->TARIC_TARTIC_DR AS VARCHAR(50)) as CHARGE_KIND_CODE2
FROM SQLUser.DHC_TarItem	
--SELECT  
--CAST(tItem.TARI_RowId AS VARCHAR(30)) as APHI_ITEM_CODE, 
--CAST(tItem.TARI_Desc AS VARCHAR(100)) as APHI_ITEM_NAME,
--CAST(tItem.TARI_EMCCate AS VARCHAR(20)) as APHI_TarEMC_CODE,
--CAST(tItem.TARI_EMCCate -> TAREC_Desc AS VARCHAR(30)) as APHI_TarEMC_Name,
--CAST(price.TP_Price  AS VARCHAR(30)) as APHI_ITEM_PRICE,
--CAST(tItem.TARI_UOM ->CTUOM_Desc AS VARCHAR(60)) as APHI_SPECS,
--CAST(
--CASE
 --WHEN  tItem.TARI_ActiveFlag = 'Y'  THEN  '1' 
--ELSE '0'
--END AS CHAR(1)) as IS_VALID
--*
--FROM sqluser.DHC_TarItem AS tItem 
--LEFT JOIN sqluser.DHC_TarItemPrice AS price ON tItem.TARI_RowId = price.TP_TARI_ParRef	
	
--SELECT 
--CAST(TARI_RowId AS VARCHAR(20)) AS CHARGE_DETAIL_CODE,
--CAST(TARI_Code AS VARCHAR(20)) AS CHARGE_DETAIL_CODE,
--CAST(TARI_Desc AS VARCHAR(20)) CHARGE_DETAIL_NAME,
--CAST(TARI_EMCCate AS VARCHAR(20)) CHARGE_KIND_CODE 
--CAST('O' ||TARI_OutpatCate AS VARCHAR(20)) CHARGE_KIND_CODE  
--CAST('I' ||TARI_InpatCate AS VARCHAR(20)) TARI_InpatCate  
--FROM sqluser.DHC_TarItem
}

/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  支付方式
/// Table：         DICT_PAY_TYPE_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.DICT_PAY_TYPE_VIEW
Query payModeView() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_PAY_TYPE_VIEW ]
{
SELECT 
CAST(CTPM_RowId AS VARCHAR(20)) AS PAY_TYPE_CODE,
CAST(CTPM_Desc AS VARCHAR(50)) AS PAY_TYPE_NAME 
FROM sqluser.CT_PayMode
}

/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  患者类别
/// Table：         EF_IF_V_PAYMENT
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.DICT_PATIENT_TYPE_VIEW
Query PATIENTView() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_PATIENT_TYPE_VIEW ]
{
select 
CAST(REA_RowId  AS VARCHAR(20)) as PATIENT_TYPE_CODE,
CAST(REA_Desc  AS VARCHAR(50)) as  PATIENT_TYPE_NAME 
from SQLUser.PAC_AdmReason
}

/*
/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  患者类别
/// Table：         EF_IF_V_PAYMENT
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.DICT_PATIENT_TYPE_VIEW
Query PATIENTView() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = DICT_PATIENT_TYPE_VIEW ]
{
SELECT 'O' AS PATIENT_TYPE_CODE, '门诊' AS PATIENT_TYPE_NAME

UNION ALL 

SELECT 'E' AS PATIENT_TYPE_CODE, '急诊' AS PATIENT_TYPE_NAME

UNION ALL 

SELECT 'I' AS PATIENT_TYPE_CODE, '住院' AS PATIENT_TYPE_NAME

UNION ALL 

SELECT 'H' AS PATIENT_TYPE_CODE, '体检' AS PATIENT_TYPE_NAME
}
*/
}
