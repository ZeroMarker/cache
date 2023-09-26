Import sqluser

Class web.HRPInterface.DHCWL.GetWlDetail Extends %RegisteredObject
{

/// ********************************************************************************************************************
/// 目录：
/// 科室字典: select * from web_HRPInterface_DHCWL.DICT_HIS_DEPT_VIEW
/// 收费类别: 
///         核算：select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW
///         门诊子类+住院子类：select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW2
///         会计子类：select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW3
///         会计大类：select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW4
///         病案分类：select * from web_HRPInterface_DHCWL.DICT_CHARGE_KIND_VIEW5
/// 
/// 收费项目：select * from web_HRPInterface_DHCWL.DICT_CHARGE_DETAIL_VIEW
/// 支付方式: select * from web_HRPInterface_DHCWL.DICT_PAY_TYPE_VIEW
/// 患者类别：select * from web_HRPInterface_DHCWL.DICT_PATIENT_TYPE_VIEW
/// 住院收费：
///         HIS: call web_HRPInterface_DHCWL.GetWlDetail_ACCCHARGEIVIEW("2020-04-01","2020-04-01")
///              select * from web_HRPInterface_DHCWL.ACC_CHARGE_I_VIEW
///         MDR: call web_HRPInterface_DHCWL.GetWlDetail_COSTCHARGEIVIEWMDR("2021-06-01","2021-06-02")
///         HIS: call DHCWL_InterManagement_projects.HrpInterface_COSTCHARGEIVIEW("2020-04-01","2020-04-01")
/// 门急诊收费(最新标准已改为计费组提供,此处依然保留原有代码)：
///         MDR: call web_HRPInterface_DHCWL.GetWlDetail_ACCCHARGEOVIEWMDR("2021-06-01","2021-06-02")
///         HIS: call web_HRPInterface_DHCWL.GetWlDetail_ACCCHARGEOVIEW("2021-06-01","2021-06-01")
/// 门诊收费: 
///         MDR: call web_HRPInterface_DHCWL.GetWlDetail_COSTCHARGEOVIEWMDR("2021-06-01","2021-06-02") 
///         HIS: call web_HRPInterface_DHCWL.GetWlDetail_COSTCHARGEOVIEW("2019-01-01","2019-04-01")
/// 住院床日和出院人次: 
///                   MDR: call web_HRPInterface_DHCWL.GetWlDetail_COSTINHOSWORKVIEWMDR("2021-06-01","2021-06-02") 
///                   HIS: call web_HRPInterface_DHCWL.GetWlDetail_COSTINHOSWORKVIEW("2019-01-01","2019-05-01") 
/// 门急诊人次 
///           MDR: call web_HRPInterface_DHCWL.GetWlDetail_COSTCLINICWORKVIEWMDR("2021-06-01","2021-06-02")
///           HIS: call web_HRPInterface_DHCWL.GetWlDetail_COSTCLINICWORKVIEW("2019-01-01","2019-09-01")
/// 科室人员信息 :select * from web_HRPInterface_DHCWL.SS_USER
/// 科室收入数据 ：
///              HIS: call web_HRPInterface_DHCWL.GetWlDetail_DeptInCome("2020-04-01","2020-04-01")
///              MDR: call web_HRPInterface_DHCWL.GetWlDetail_DeptInComeMDR("2020-04-01","2020-04-01")
/// 诊疗医嘱:
/// 			HIS: select * from web_HRPInterface_DHCWL.HTCG_MEDICAL_ADVICE_VIEW
/// 药品医嘱:
/// 			HIS: select * from web_HRPInterface_DHCWL.HTCG_DRUG_ADVICE_VIEW
/// 材料医嘱:
/// 			HIS: select * from web_HRPInterface_DHCWL.HTCG_MATERIAL_ADVICE_VIEW
/// *********************************************************************************************************************
/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  3.10.6.科室人员信息
/// Table：         SS_USER
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.SS_USER
Query SSUSER() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = SS_USER ]
{
SELECT 
CAST(ssus.SSUSR_Initials AS VARCHAR(30)) as APHI_PERSON_NO, 
CAST(ssus.SSUSR_Name AS VARCHAR(30)) as APHI_PERSON_NAME, 
CAST(ssus.SSUSR_DefaultDept_DR AS VARCHAR(50)) AS APHI_MANAGE_DEPT, --默认科室
'' AS APHI_WORK_DEPT,
CAST(ssus.SSUSR_Group ->SSGRP_Desc AS VARCHAR(50)) AS APHI_POST_NAME,
CAST(cttp.CTCPT_Desc AS VARCHAR(50)) AS APHI_DUTY_NAME,
'' AS APHI_EDU_NAME,
'' AS APHI_WORK_YERA,
'' AS APHI_TECH_LEVEL,
CAST(
CASE 
    WHEN ssus.SSUSR_Group ->SSGRP_Desc LIKE '%医%' AND ssus.SSUSR_Group ->SSGRP_Desc  NOT LIKE '%医保%' THEN '医'
    WHEN ssus.SSUSR_Group ->SSGRP_Desc LIKE '%护%' THEN '护'
    WHEN ssus.SSUSR_Group ->SSGRP_Desc LIKE '%技%' THEN '技'
ELSE '行'
END AS VARCHAR(50)) AS APHI_PERSON_TYPE
FROM sqluser.SS_User AS ssus
LEFT JOIN  sqluser.CT_CarPrvTp AS cttp ON ssus.SSUSR_CareProv_DR = cttp.CTCPT_RowId
}

/// Creator：       ET
/// CreatDate：     2020-02-27
/// Description:：  住院收费(ACC_CHARGE_I_VIEW)
/// Table：         ACC_CHARGE_I_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.ACC_CHARGE_I_VIEW WHERE CHARGE_DATE = '2019-01-31'
Query ACCCHARGEI() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = ACC_CHARGE_I_VIEW ]
{
SELECT 
CAST (WorkLoad_OrdDate as date) as CHARGE_DATE,
CAST (WorkLoad_ResDep_DR AS VARCHAR(50)) as DEPT_CODE,
CAST (WorkLoad_TarIC_Dr -> TARIC_TARTIC_DR AS VARCHAR(20)) as CHARGE_KIND_CODE,
--CAST (WorkLoad_AdmReason_DR AS VARCHAR(20)) as PATIENT_TYPE_CODE,
CAST ('I' AS VARCHAR(20)) as PATIENT_TYPE_CODE,
CAST (sum(WorkLoad_TotalPrice) as  NUMERIC(18,2)) CHARGE_MONEY,
'' as CHARGE_CODE,
'' as CHARGE_NAME,
CAST (
CASE 
 when sum(WorkLoad_TotalPrice) >= 0 THEN '0' 
 ELSE '1' 
END as  NUMERIC(4,0)) AS IS_BACK ,
CAST (WorkLoad_ResDep_DR -> CTLOC_Hospital_DR AS VARCHAR(50)) as HOS_DISTRICT_CODE 
FROM sqluser.dhc_workload 
WHERE WorkLoad_Type = 'I'
group by WorkLoad_OrdDate,WorkLoad_ResDep_DR,WorkLoad_TarIC_Dr -> TARIC_TARTIC_DR,WorkLoad_AdmReason_DR
}

/// Creator：       PuGaila
/// CreatDate：     2020-02-27
/// Description:：  门急诊人次(COST_CLINIC_WORK_VIEW)
/// Table：         COST_CLINIC_WORK_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.COST_CLINIC_WORK_VIEW WHERE ACC_YEAR ='2019' AND ACC_MONTH ='01'
Query COSTCLINIC() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = COST_CLINIC_WORK_VIEW ]
{
SELECT
CAST (YEAR(WR_ADMDate) AS CHAR(4)) as  ACC_YEAR,
CAST (to_char(WR_ADMDate,'MM') AS CHAR(2)) as ACC_MONTH,
CAST (WR_ADMDEP_DR  AS CHAR(50)) as DEPT_CODE,
CAST (WR_PAADM_DR -> PAADM_Type  AS CHAR(20)) as PATIENT_TYPE_CODE,
CAST (WR_NumberFlag  AS NUMERIC(18,0)) as CLINIC_NUM
FROM sqluser.DHCWorkRegReport
group by YEAR(WR_ADMDate),MONTH(WR_ADMDate),WR_ADMDEP_DR,WR_PAADM_DR -> PAADM_Type
}

/// Creator：       PuGaila
/// CreatDate：     2020-02-27
/// Description:：  3.4.2. 住院床日和出院人次(COST_INHOS_WORK_VIEW)
/// Table：         COST_INHOS_WORK_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.COST_INHOS_WORK_VIEW WHERE ACC_YEAR ='2019' AND ACC_MONTH ='01'
Query INHOSWORK() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = COST_INHOS_WORK_VIEW ]
{
SELECT 
CAST (YEAR(MRIP_date) AS CHAR(4)) as  ACC_YEAR,
CAST (to_char(MRIP_date,'MM') AS CHAR(2)) as ACC_MONTH,
CAST (MRIP_loc_dr  AS CHAR(50)) as DEPT_CODE,
CAST ('I'   AS CHAR(20)) as PATIENT_TYPE_CODE,
CAST (MRIP_ryrs  AS NUMERIC(18,0)) as IN_HOS_NUM,
CAST (MRIP_crrs  AS NUMERIC(18,0)) as OUT_HOS_NUM,
CAST (web_HRPInterface_DHCWL.GetWlDetail_BedNum(MRIP_date,"Loc",MRIP_loc_dr)  AS NUMERIC(18,0)) as SET_BED_NUM,
CAST (sum(web_HRPInterface_DHCWL.GetWlDetail_BedNum(MRIP_date,"Loc",MRIP_loc_dr))  AS NUMERIC(18,0)) as OPEN_BED_NUM,
CAST (SUM (MRIP_XYRS)/sum(MRIP_bednum) AS NUMERIC(18,2)) as BED_USE_RATE,
CAST (SUM (MRIP_XYRS) AS NUMERIC(18,0)) as BED_USE_DAY_NUM
FROM SQLUser.dhcmripday where MRIP_loc_dr is not NULL 
GROUP BY YEAR(MRIP_date),to_char(MRIP_date,'MM'),MRIP_loc_dr
}

/// Creator：       PuGaila
/// CreatDate：     2020-02-27
/// Description:：  3.4.4. 门诊收费(COST_CHARGE_O_VIEW)
/// Table：         COST_CHARGE_O_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.COST_CHARGE_O_VIEW WHERE ACC_YEAR ='2019' AND ACC_MONTH ='01'
Query COSTCHARGEO() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = COST_CHARGE_O_VIEW ]
{
	SELECT 
CAST (YEAR(WorkLoad_OrdDate) AS CHAR(4)) as  ACC_YEAR,
CAST (to_char(WorkLoad_OrdDate,'MM') AS CHAR(2)) as ACC_MONTH,
CAST (WorkLoad_PatDep_DR AS VARCHAR(50)) as DEPT_CODE,
CAST (WorkLoad_RecDep_DR AS VARCHAR(50)) as PERFORM_BY,
CAST (WorkLoad_TarOut_Dr -> TAROC_TARTOC_DR AS VARCHAR(20)) as CHARGE_KIND_CODE,
CAST (WorkLoad_TarItem_DR AS VARCHAR(50)) as CHARGE_DETAIL_CODE,
CAST (sum(WorkLoad_Quantity) as  NUMERIC(18,2)) as WORKLOAD,
CAST (WorkLoad_UnitPrice as  NUMERIC(18,2)) as PRICE,
CAST (WorkLoad_Type AS VARCHAR(50)) as ATIENT_TYPE_CODE,
CAST (sum(WorkLoad_TotalPrice) as  NUMERIC(18,2)) CHARGE_MONEY,
CAST (
CASE 
 when sum(WorkLoad_TotalPrice) >= 0 THEN '0' 
 ELSE '1' 
END as  NUMERIC(4,0)) AS IS_BACK 
FROM sqluser.dhc_workload 
WHERE WorkLoad_Type <> 'I' and  WorkLoad_Type <> 'H'
group by YEAR(WorkLoad_OrdDate),to_char(WorkLoad_OrdDate,'MM'),WorkLoad_PatDep_DR,WorkLoad_RecDep_DR,WorkLoad_TarOut_Dr -> TAROC_TARTOC_DR,WorkLoad_TarItem_DR,WorkLoad_UnitPrice,WorkLoad_Type
}

/// Creator：       PuGaila
/// CreatDate：     2020-02-27
/// Description:：  3.4.5. 住院收费(COST_CHARGE_I_VIEW)
/// Table：         COST_CHARGE_O_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.COST_CHARGE_I_VIEW WHERE ACC_YEAR ='2019' AND ACC_MONTH ='01'
Query COSTCHARGEI() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = COST_CHARGE_I_VIEW ]
{
SELECT 
CAST (YEAR(WorkLoad_OrdDate) AS CHAR(4)) as  ACC_YEAR,
CAST (to_char(WorkLoad_OrdDate,'MM') AS CHAR(2)) as ACC_MONTH,
CAST (WorkLoad_PatDep_DR AS VARCHAR(50)) as DEPT_CODE,
CAST (WorkLoad_RecDep_DR AS VARCHAR(50)) as PERFORM_BY,
CAST (WorkLoad_TarOut_Dr -> TAROC_TARTOC_DR AS VARCHAR(20)) as CHARGE_KIND_CODE,
CAST (WorkLoad_TarItem_DR AS VARCHAR(50)) as CHARGE_DETAIL_CODE,
CAST (sum(WorkLoad_Quantity) as  NUMERIC(18,2)) as WORKLOAD,
CAST (WorkLoad_UnitPrice as  NUMERIC(18,2)) as PRICE,
CAST (WorkLoad_Type AS VARCHAR(50)) as ATIENT_TYPE_CODE,
CAST (sum(WorkLoad_TotalPrice) as  NUMERIC(18,2)) CHARGE_MONEY,
CAST (
CASE 
 when sum(WorkLoad_TotalPrice) >= 0 THEN '0' 
 ELSE '1' 
END as  NUMERIC(4,0)) AS IS_BACK 
FROM sqluser.dhc_workload 
WHERE WorkLoad_Type = 'I' 
group by YEAR(WorkLoad_OrdDate),to_char(WorkLoad_OrdDate,'MM'),WorkLoad_PatDep_DR,WorkLoad_RecDep_DR,WorkLoad_TarOut_Dr -> TAROC_TARTOC_DR,WorkLoad_TarItem_DR,WorkLoad_UnitPrice,WorkLoad_Type
}

/// Creator：       PuGaila
/// CreatDate：     2020-02-27
/// Description:：  3.10.1.3. 科室收入数据(Dept_InCome)
/// Table：         COST_CHARGE_O_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.Dept_InCome WHERE APHI_YEAR_MONTH ='201901'
Query DeptInComeSql() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = Dept_InCome ]
{
SELECT 
CAST (YEAR(WorkLoad_OrdDate) || to_char(WorkLoad_OrdDate,'MM') AS VARCHAR(20)) as  APHI_YEAR_MONTH,
CAST (WorkLoad_PatDep_DR AS VARCHAR(20)) as APHI_MK_DEPT_CODE,
CAST (WorkLoad_PatDep_DR -> CTLOC_Desc AS VARCHAR(50)) as APHI_MK_DEPT_NAME,
CAST (WorkLoad_ResDep_DR AS VARCHAR(20)) as APHI_DEPT_CODE,
CAST (WorkLoad_ResDep_DR -> CTLOC_Desc AS VARCHAR(50)) as APHI_DEPT_NAME,
CAST (WorkLoad_RecDep_DR AS VARCHAR(20)) as APHI_EXC_DEPT_CODE,
CAST (WorkLoad_RecDep_DR -> CTLOC_Desc AS VARCHAR(50)) as APHI_EXC_DEPT_NAME,
CAST (WorkLoad_Type AS VARCHAR(50)) as APHI_DATA_TYPE,
CAST (WorkLoad_TarItem_DR AS VARCHAR(50)) as APHI_ITEM_CODE,
CAST (WorkLoad_TarItem_DR ->TARI_Desc AS VARCHAR(50)) as APHI_ITEM_NAME,
CAST (WorkLoad_TarEC_Dr AS VARCHAR(50)) as APHI_TarEMCName,
CAST (WorkLoad_ResDoc_DR AS VARCHAR(50)) as APHI_MK_DOCTOR,
CAST (sum(WorkLoad_Quantity) as  NUMERIC(18,2)) as APHI_ITEM_NUM,
CAST (sum(WorkLoad_TotalPrice) as  NUMERIC(18,2)) APHI_ITEM_SUM
FROM sqluser.dhc_workload 
WHERE WorkLoad_Type = 'I' 
GROUP BY YEAR(WorkLoad_OrdDate) || to_char(WorkLoad_OrdDate,'MM'),WorkLoad_PatDep_DR,WorkLoad_ResDep_DR,WorkLoad_RecDep_DR,WorkLoad_TarItem_DR,WorkLoad_TarEC_Dr,WorkLoad_ResDoc_DR

union all 

SELECT 
CAST (YEAR(WorkLoad_FlagDate) || to_char(WorkLoad_FlagDate,'MM') AS VARCHAR(20)) as  APHI_YEAR_MONTH,
CAST (WorkLoad_PatDep_DR AS VARCHAR(20)) as APHI_MK_DEPT_CODE,
CAST (WorkLoad_PatDep_DR -> CTLOC_Desc AS VARCHAR(50)) as APHI_MK_DEPT_NAME,
CAST (WorkLoad_ResDep_DR AS VARCHAR(20)) as APHI_DEPT_CODE,
CAST (WorkLoad_ResDep_DR -> CTLOC_Desc AS VARCHAR(50)) as APHI_DEPT_NAME,
CAST (WorkLoad_RecDep_DR AS VARCHAR(20)) as APHI_EXC_DEPT_CODE,
CAST (WorkLoad_RecDep_DR -> CTLOC_Desc AS VARCHAR(50)) as APHI_EXC_DEPT_NAME,
CAST (WorkLoad_Type AS VARCHAR(50)) as APHI_DATA_TYPE,
CAST (WorkLoad_TarItem_DR AS VARCHAR(50)) as APHI_ITEM_CODE,
CAST (WorkLoad_TarItem_DR ->TARI_Desc AS VARCHAR(50)) as APHI_ITEM_NAME,
CAST (WorkLoad_TarEC_Dr AS VARCHAR(50)) as APHI_TarEMCName,
CAST (WorkLoad_ResDoc_DR AS VARCHAR(50)) as APHI_MK_DOCTOR,
CAST (sum(WorkLoad_Quantity) as  NUMERIC(18,2)) as APHI_ITEM_NUM,
CAST (sum(WorkLoad_TotalPrice) as  NUMERIC(18,2)) APHI_ITEM_SUM
FROM sqluser.dhc_workload 
WHERE WorkLoad_Type <> 'I' and  WorkLoad_Type <> 'H'
GROUP BY YEAR(WorkLoad_OrdDate) || to_char(WorkLoad_OrdDate,'MM'),WorkLoad_PatDep_DR,WorkLoad_ResDep_DR,WorkLoad_RecDep_DR,WorkLoad_TarItem_DR,WorkLoad_TarEC_Dr,WorkLoad_ResDoc_DR
}

/// ---------------------------------------------------------------------------------------------------------------------------
Query COSTCHARGEOVIEWMDR(startDate As %String, endDate As %String) As %Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,DEPT_CODE,PERFORM_BY,CHARGE_KIND_CODE,CHARGE_DETAIL_CODE,PATIENT_TYPE_CODE,WORKLOAD,PRICE,CHARGE_MONEY,IS_BACK") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    3.4.4.门诊收费(COST_CHARGE_O_VIEW)
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","COSTCHARGEOVIEWMDR","2021-06-01","2021-06-02")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTCHARGEOVIEWMDR("2021-06-01","2021-06-02")
/// 为页面提供科室子组query
ClassMethod COSTCHARGEOVIEWMDRExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 s sql="select * from web_HRPInterface_DHCWL.COST_CHARGE_O_VIEW WHERE orddate  BETWEEN "_"'"_startDate_"'"_" AND "_"'"_endDate_"'"
 d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("HisToMdr",sql)
 
 s all=""  f  s all=$o(^TMPDHCWL($j,"CS",all))  q:all=""  d
 .s list=$g(^TMPDHCWL($j,"CS",all))
 .s ACCYEAR=$p(list,"^",2)
 .s ACCMONTH=$p(list,"^",3)
 .s DEPTCODE=$p(list,"^",4)
 .s PERFORMBY=$p(list,"^",5)
 .s CHARGEKINDCODE=$p(list,"^",6)
 .s CHARGEDETAILCODE=$p(list,"^",7)
 .s PATIENTTYPECODE=$p(list,"^",8)
 .s WORKLOAD=$p(list,"^",9)
 .s PRICE=$p(list,"^",10)
 .s CHARGEMONEY=$p(list,"^",11)
 .s ISBACK=$p(list,"^",12)
 .q:(WORKLOAD=0)&&(CHARGEMONEY=0)
 .d OutputRow
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(ACCYEAR,ACCMONTH,DEPTCODE,PERFORMBY,CHARGEKINDCODE,CHARGEDETAILCODE,PATIENTTYPECODE,WORKLOAD,PRICE,CHARGEMONEY,ISBACK)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod COSTCHARGEOVIEWMDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COSTCHARGEOVIEWMDRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COSTCHARGEOVIEWMDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COSTCHARGEOVIEWMDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query COSTCHARGEOVIEW(startDate As %String, endDate As %String) As %Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,DEPT_CODE,PERFORM_BY,CHARGE_KIND_CODE,CHARGE_DETAIL_CODE,WORKLOAD,PRICE,PATIENT_TYPE_CODE,CHARGE_MONEY,IS_BACK") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    3.4.4.门诊收费(COST_CHARGE_O_VIEW)
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","COSTCHARGEOVIEW","2019-01-01","2019-04-01")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTCHARGEOVIEW("2019-01-01","2019-04-01")
/// 为页面提供科室子组query
ClassMethod COSTCHARGEOVIEWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:startDate="" $$$OK
 q:endDate="" $$$OK 
 k ^||TMPDHCWL($j)
 s stdate=$zdh(startDate,3)
 s endate=$zdh(endDate,3)
 f date=stdate:1:endate d
 .s wLRowid=0 f  s wLRowid=$o(^DHCWorkLoad(0,"FlagDate",date,wLRowid)) q:wLRowid=""  d
 ..s type=$p($g(^DHCWorkLoad(wLRowid)),"^",4)  ;费用类型
 ..q:(type'="O")&&(type'="E")
 ..s days=$zd(date,3)
 ..s mdate=$p(days,"-",1)_"-"_$p(days,"-",2)
 ..s patDept=$p($g(^DHCWorkLoad(wLRowid)),"^",23) 
 ..s recDept=$p($g(^DHCWorkLoad(wLRowid)),"^",1)
 ..s tar=$p($g(^DHCWorkLoad(wLRowid)),"^",40)
 ..s tarItem=$p($g(^DHCWorkLoad(wLRowid)),"^",22)
 ..s qty=$p($g(^DHCWorkLoad(wLRowid)),"^",15)
 ..s unit=$p($g(^DHCWorkLoad(wLRowid)),"^",14)
 ..s reaId=$p($g(^DHCWorkLoad(wLRowid)),"^",52)
 ..s total=$p($g(^DHCWorkLoad(wLRowid)),"^",16)
 ..s ^||TMPDHCWL($j,"COST",mdate,patDept,recDept,tar,tarItem,unit)=$g(^||TMPDHCWL($j,"COST",mdate,patDept,recDept,tar,tarItem,unit))+total
 
 
 /*
  .s hisDr="" f  s hisDr=$o(^DHCOPInsFootI(0,"INSFDate",date,hisDr))  q:(hisDr="")  d 
 ..q:'$d(^DHCOPInsFoot(hisDr))
 ..s ReportType=$p($g(^DHCOPInsFoot(hisDr)),"^",60)
 ..q:(ReportType="S")   ;2014-02-24  自主结算不算在里面  yhb
 ..s Auditid=$p($g(^DHCOPInsFoot(hisDr)),"^",67)
 ..s invdr=0
 ..f  s invdr=$o(^DHCINVPRT(0,"Report",hisDr,invdr))  q:invdr=""  d
 ...s usr=$p(^DHCINVPRT(invdr),"^",21)
 ...s flag=$p(^DHCINVPRT(invdr),"^",8)
 ...s initinv=$p(^DHCINVPRT(invdr),"^",13)
 ...s instype=$p(^DHCINVPRT(invdr),"^",9)
 ...s fairtype=$p(^DHCINVPRT(invdr),"^",34)
 ...s status=0
 ...i (flag="S")&(initinv'="")  s status=1
 ...i (flag="A")&(initinv="")   s status=3
 ...q:(flag="A")&(initinv'="")
 ...s paysub=0
 ...s BCIRowid=0 f  s BCIRowid=$o(^DHCBCI(0,"INV",invdr,BCIRowid)) q:BCIRowid=""  d         
 ....s arpbl=$p(^DHCBCI(BCIRowid),"^",2)
 ....s wLRowid=0 f  s wLRowid=$o(^DHCWorkLoad(0,"ARPBL",arpbl,wLRowid)) q:wLRowid=""  d
 .....s type=$p($g(^DHCWorkLoad(wLRowid)),"^",4)  ;费用类型
 .....s days=$zd(date,3)
 .....s mdate=$p(days,"-",1)_"-"_$p(days,"-",2)
 .....s patDept=$p($g(^DHCWorkLoad(wLRowid)),"^",23) 
 .....s recDept=$p($g(^DHCWorkLoad(wLRowid)),"^",1)
 .....s tar=$p($g(^DHCWorkLoad(wLRowid)),"^",40)
 .....s tarItem=$p($g(^DHCWorkLoad(wLRowid)),"^",22)
 .....s qty=$p($g(^DHCWorkLoad(wLRowid)),"^",15)
 .....s unit=$p($g(^DHCWorkLoad(wLRowid)),"^",14)
 .....s reaId=$p($g(^DHCWorkLoad(wLRowid)),"^",52)
 .....s total=$p($g(^DHCWorkLoad(wLRowid)),"^",16)
 .....i total>0 d
 ......s back=0 
 .....e  d
 ......s back=1 
 .....s ^||TMPDHCWL($j,mdate,patDept,recDept,tar,tarItem,unit)=$g(^||TMPDHCWL($j,mdate,patDept,recDept,tar,tarItem,unit))+total

 */
 
 s mDATE="" f  s mDATE=$o(^||TMPDHCWL($j,"COST",mDATE)) q:mDATE=""  d
 .s ACCYEAR=$p(mDATE,"-",1)
 .s ACCMONTH=$p(mDATE,"-",2)
 .s DEPTCODE="" f  s DEPTCODE=$o(^||TMPDHCWL($j,"COST",mDATE,DEPTCODE)) q:DEPTCODE=""  d
 ..s APPLDEPTCODE=$p(^CTLOC(DEPTCODE),"^",1)
 ..s APPLDEPTNAME=$p(^CTLOC(DEPTCODE),"^",2)
 ..s RECDEPT="" f  s RECDEPT=$o(^||TMPDHCWL($j,"COST",mDATE,DEPTCODE,RECDEPT)) q:RECDEPT=""  d
 ...s EXECDEPTCODE=$p(^CTLOC(RECDEPT),"^",1)
 ...s EXECDEPTNAME=$p(^CTLOC(RECDEPT),"^",2)
 ...s KINDID="" f  s KINDID=$o(^||TMPDHCWL($j,"COST",mDATE,DEPTCODE,RECDEPT,KINDID)) q:KINDID=""  d
 ....s CHARGEKINDCODE=$p(^DHCTarC("AC",KINDID),"^",1)
 ....s CHARGEKINDNAME=$p(^DHCTarC("AC",KINDID),"^",2)
 ....s DETAILID="" f  s DETAILID=$o(^||TMPDHCWL($j,"COST",mDATE,DEPTCODE,RECDEPT,KINDID,DETAILID)) q:DETAILID=""  d
 .....s CHARGEITEMCODE=$p(^DHCTARI(DETAILID),"^",1)
 .....s CHARGEITEMNAME=$p(^DHCTARI(DETAILID),"^",2)
 .....s PRICE="" f  s PRICE=$o(^||TMPDHCWL($j,"COST",mDATE,DEPTCODE,RECDEPT,KINDID,DETAILID,PRICE)) q:PRICE=""  d
 ......q:PRICE=0
 ......s MONEY=$g(^||TMPDHCWL($j,"COST",mDATE,DEPTCODE,RECDEPT,KINDID,DETAILID,PRICE))
 ......s NUM=+MONEY / PRICE
 ......s NUM=$fn(NUM,".",2)
 ......s NUM=$justify(NUM,1,2)
 ......s totalCost=$justify(PRICE,1,2)
 ......i NUM < 0 d
 .......s ISBACK = 1
 ......e  d
 .......s ISBACK = 0
 ......s BUSIDATASOURCECODE=01 
 ......s CREATUSER=""
 ......s CREATDATE=$zd(+$H,3)
 ......d OutputRow
 k ^||TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
  


OutputRow
	set Data=$lb(ACCYEAR,ACCMONTH,DEPTCODE,RECDEPT,KINDID,DETAILID,NUM,totalCost,"",MONEY,ISBACK)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod COSTCHARGEOVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COSTCHARGEOVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COSTCHARGEOVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COSTCHARGEOVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query COSTCLINICWORKVIEWMDR(startDate As %String, endDate As %String) As %Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,DEPT_CODE,PATIENT_TYPE_CODE,CLINIC_NUM") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    3.4.1.门急诊人次(COST_CLINIC_WORK_VIEW)
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","COSTCLINICWORKVIEWMDR","2021-05-01","2021-05-30")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTCLINICWORKVIEWMDR("2021-06-01","2021-06-02")
/// 为页面提供科室子组query
ClassMethod COSTCLINICWORKVIEWMDRExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 s sql="select * from web_HRPInterface_DHCWL.COST_CLINIC_WORK_VIEW WHERE querydate  BETWEEN "_"'"_startDate_"'"_" AND "_"'"_endDate_"'"
 d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("HisToMdr",sql)
 
 s all=""  f  s all=$o(^TMPDHCWL($j,"CS",all))  q:all=""  d
 .s list=$g(^TMPDHCWL($j,"CS",all))
 .s ACCYEAR=$p(list,"^",2)
 .s ACCMONTH=$p(list,"^",3)
 .s DEPTCODE=$p(list,"^",4)
 .s PATIENTTYPECODE=$p(list,"^",5)
 .s CLINICNUM=$p(list,"^",6)
 .d OutputRow
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(ACCYEAR,ACCMONTH,DEPTCODE,PATIENTTYPECODE,CLINICNUM)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod COSTCLINICWORKVIEWMDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COSTINHOSWORKVIEWMDRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COSTCLINICWORKVIEWMDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COSTINHOSWORKVIEWMDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Query COSTCLINICWORKVIEW(startDate As %String, endDate As %String) As %Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,DEPT_CODE,PATIENT_TYPE_CODE,CLINIC_NUM") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    3.4.1.门急诊人次(COST_CLINIC_WORK_VIEW)
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","COSTCLINICWORKVIEW","2021-06-01","2021-06-02")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTCLINICWORKVIEW("2021-06-01","2021-06-02")
/// 为页面提供科室子组query
ClassMethod COSTCLINICWORKVIEWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:startDate="" $$$OK
 q:endDate="" $$$OK
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 s stDate=$zdh(startDate,3)
 s edDate=$zdh(endDate,3)
 f date=stDate:1:edDate d
 .s regId=0 f  s regId=$o(^DHCWorkRegReport(0,"ADMDATE",date,regId)) q:regId=""  d
 ..s count=$p(^DHCWorkRegReport(regId),"^",29)
 ..s patLoc=$p(^DHCWorkRegReport(regId),"^",5)
 ..s admId=$p(^DHCWorkRegReport(regId),"^",15)
 ..s patType=$p(^PAADM(admId),"^",2)
 ..s ^TMPDHCWL($j,"CS",patLoc,patType,date)=$g(^TMPDHCWL($j,"CS",patLoc,patType,date))+count	
 
 s mLoc=""  f  s mLoc=$o(^TMPDHCWL($j,"CS",mLoc))  q:mLoc=""  d
 .s mType=""  f  s mType=$o(^TMPDHCWL($j,"CS",mLoc,mType))  q:mType=""  d
 ..s mdate=""  f  s mdate=$o(^TMPDHCWL($j,"CS",mLoc,mType,mdate))  q:mdate=""  d
 ...s ACCYEAR=$p($zd(mdate,3),"-",1)
 ...s ACCMONTH=$p($zd(mdate,3),"-",2)
 ...s DEPTCODE=mLoc
 ...s PATIENTTYPECODE=mType
 ...s CLINICNUM=$g(^TMPDHCWL($j,"CS",mLoc,mType,mdate))
 ...d OutputRow
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(ACCYEAR,ACCMONTH,DEPTCODE,PATIENTTYPECODE,CLINICNUM)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod COSTCLINICWORKVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COSTINHOSWORKVIEWMDRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COSTCLINICWORKVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COSTINHOSWORKVIEWMDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query COSTINHOSWORKVIEWMDR(startDate As %String, endDate As %String) As %Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,DEPT_CODE,PATIENT_TYPE_CODE,IN_HOS_NUM,OUT_HOS_NUM,SET_BED_NUM,OPEN_BED_NUM,BED_USE_RATE,BED_USE_DAY_NUM") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    3.4.2.住院床日和出院人次(COST_INHOS_WORK_VIEW) 
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","COSTINHOSWORKVIEWMDR","2021-06-01","2021-06-02")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTINHOSWORKVIEWMDR("2021-06-01","2021-06-02")
ClassMethod COSTINHOSWORKVIEWMDRExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 s sql="select * from web_HRPInterface_DHCWL.COST_INHOS_WORK_VIEW WHERE querydate  BETWEEN "_"'"_startDate_"'"_" AND "_"'"_endDate_"'"
 d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("HisToMdr",sql)
 
 s all=""  f  s all=$o(^TMPDHCWL($j,"CS",all))  q:all=""  d
 .s list=$g(^TMPDHCWL($j,"CS",all))
 .s ACCYEAR=$p(list,"^",2)
 .s ACCMONTH=$p(list,"^",3)
 .s DEPTCODE=$p(list,"^",4)
 .s PATIENTTYPECODE=$p(list,"^",5)
 .s INHOSNUM=$p(list,"^",6)
 .s OUTHOSNUM=$p(list,"^",7)
 .s SETBEDNUM=$p(list,"^",8) 
 .s OPENBEDNUM=$p(list,"^",9)
 .s BEDUSEDAYNUM=$p(list,"^",11)
 .;w BEDUSEDAYNUM_"@"_OPENBEDNUM,!
 .s BEDUSERATE=0
 .i (BEDUSEDAYNUM'=0)&&(SETBEDNUM'=0) d
 ..;w BEDUSEDAYNUM_"@"_SETBEDNUM,!
 ..s BEDUSERATE=BEDUSEDAYNUM/SETBEDNUM/($zdh(endDate,3) - $zdh(startDate,3))
 ..s BEDUSERATE=$fn(BEDUSERATE,".",2)
 ..;s BEDUSERATE=$justify(BEDUSERATE,"",2)
 .d OutputRow
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(ACCYEAR,ACCMONTH,DEPTCODE,PATIENTTYPECODE,INHOSNUM,OUTHOSNUM,SETBEDNUM,OPENBEDNUM,BEDUSERATE,BEDUSEDAYNUM)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod COSTINHOSWORKVIEWMDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COSTINHOSWORKVIEWMDRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COSTINHOSWORKVIEWMDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COSTINHOSWORKVIEWMDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","COSTINHOSWORKVIEW","2019-01-01","2019-05-01")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTINHOSWORKVIEW_COSTINHOSWORKVIEW("2019-01-01","2019-05-01")
Query COSTINHOSWORKVIEW(startDate As %String, endDate As %String) As %Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,DEPT_CODE,PATIENT_TYPE_CODE,IN_HOS_NUM,OUT_HOS_NUM,SET_BED_NUM,OPEN_BED_NUM,BED_USE_RATE,BED_USE_DAY_NUM") [ SqlProc ]
{
}

ClassMethod COSTINHOSWORKVIEWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 q:startDate="" $$$OK
 q:endDate="" $$$OK  
 Set ind=1
 k ^TMPDHCWL($j) 
 s stdate=$zdh(startDate,3)
 s endate=$zdh(endDate,3)
 f date=stdate:1:endate  d
 .s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",date,mrId)) q:mrId=""  d
 ..s loc=$p(^MRIPdaily(mrId),"^",7) //科室
 ..q:loc=""
 ..s rowid="" f  s rowid=$o(^DHCMRIPDetail(0,"IPType",mrId,"RYRS",rowid)) q:rowid=""  d
 ...s admid=$p(^DHCMRIPDetail(rowid),"^",1)
 ...s insuId=$p(^PAADM(admid,1),"^",7)
 ...i insuId="" s insuId="1"
 ...s pacAdm=$p($g(^PAC("ADMREA",insuId)),"^",2) 
 ...s ^TMPDHCWL($j,"LOC",date,loc,pacAdm)="" 
 ...s ^TMPDHCWL($j,"RYRS",date,loc,pacAdm)=$g(^TMPDHCWL($j,"RYRS",date,loc,pacAdm))+1
  
 ..s rowid="" f  s rowid=$o(^DHCMRIPDetail(0,"IPType",mrId,"CYRS",rowid)) q:rowid=""  d
 ...s admid=$p(^DHCMRIPDetail(rowid),"^",1)
 ...s insuId=$p(^PAADM(admid,1),"^",7)
 ...i insuId="" s insuId="1"
 ...s pacAdm=$p($g(^PAC("ADMREA",insuId)),"^",2)
 ...s ^TMPDHCWL($j,"LOC",date,loc,pacAdm)=""   
 ...s ^TMPDHCWL($j,"CYRS",date,loc,pacAdm)=$g(^TMPDHCWL($j,"CYRS",date,loc,pacAdm))+1
   
 ..s rowid="" f  s rowid=$o(^DHCMRIPDetail(0,"IPType",mrId,"ZYRS",rowid)) q:rowid=""  d
 ...s admid=$p(^DHCMRIPDetail(rowid),"^",1)  
 ...s insuId=$p(^PAADM(admid,1),"^",7)
 ...i insuId="" s insuId="1"
 ...s pacAdm=$p($g(^PAC("ADMREA",insuId)),"^",2)
 ...s ^TMPDHCWL($j,"LOC",date,loc,pacAdm)="" 
 ...s ^TMPDHCWL($j,"ZYRS",date,loc,pacAdm)=$g(^TMPDHCWL($j,"ZYRS",date,loc,pacAdm))+1 

 
 s mdate="" f  s mdate=$o(^TMPDHCWL($j,"LOC",mdate)) q:mdate=""  d
 .s dept="" f  s dept=$o(^TMPDHCWL($j,"LOC",mdate,dept)) q:dept=""  d
 ..s pac="" f  s pac=$o(^TMPDHCWL($j,"LOC",mdate,dept,pac)) q:pac=""  d
 ...s bedStr=$$BedNum(date,"Loc",dept)
 ...s gdc=$p(bedStr,"^",1)
 ...s syc=$p(bedStr,"^",2) 
 ...s xyrs=$g(^TMPDHCWL($j,"ZYRS",mdate,dept,pac))
 ...s ryrs=$g(^TMPDHCWL($j,"RYRS",mdate,dept,pac))
 ...s cyrs=$g(^TMPDHCWL($j,"CYRS",mdate,dept,pac))
 ...s ACCYEAR=$p($zd(mdate,3),"-",1)
 ...s ACCMONTH=$p($zd(mdate,3),"-",2)
 ...s DEPTCODE=$p(^CTLOC(dept),"^",1)
 ...s PATIENTTYPECODE=$p($g(^PAC("ADMREA",pac)),"^",1) 
 ...s INHOSNUM=ryrs
 ...s OUTHOSNUM=cyrs
 ...s SETBEDNUM=gdc
 ...s OPENBEDNUM=syc
 ...i (syc= 0)||(xyrs=0) d
 ....s BEDUSERATE=0
 ...e  d
 ....s BEDUSERATE=xyrs / syc * 100
 ....s BEDUSERATE=$MVFMTS(BEDUSERATE,2)
 ...s BEDUSEDAYNUM=xyrs
 ...d OutputRow
 k ^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
  
OutputRow
	set Data=$lb(ACCYEAR,ACCMONTH,DEPTCODE,PATIENTTYPECODE,INHOSNUM,OUTHOSNUM,SETBEDNUM,OPENBEDNUM,BEDUSERATE,BEDUSEDAYNUM)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	 
BedNum(Date,LocOrWardFlag,LocOrWardId)
 ;w $$BedNum^DHCMRIPday("61354","Ward","1") 
 s MRRowId=""
 s Return=0_"^"_0_"^"_0
 i $d(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId))  d
 .s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One
 e  d
 .s Date=$o(^DHCMRBed(0,LocOrWardFlag,LocOrWardId,"Date",Date),-1)
 .i Date'="" s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One Or No Exist
 q:MRRowId="" Return
 s MRGDNum=$p(^DHCMRBed(MRRowId),"^",3)
 s MRSYNum=$p(^DHCMRBed(MRRowId),"^",4)
 s MRBZNum=$p(^DHCMRBed(MRRowId),"^",5)
 s Return=MRGDNum_"^"_MRSYNum_"^"_MRBZNum
 q Return
}

ClassMethod COSTINHOSWORKVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COSTINHOSWORKVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COSTINHOSWORKVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COSTINHOSWORKVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// MDR门诊收入(为了与计费保持一致，默认门诊发票表交账日期包含如有体检数据则包含体检金额不过滤)
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","ACCCHARGEOVIEWMDR","2021-06-01","2021-06-02")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_ACCCHARGEOVIEWMDR("2020-04-01","2020-04-01")
/// 为页面提供科室子组query
Query ACCCHARGEOVIEWMDR(startDate As %String, endDate As %String) As %Query(ROWSPEC = "REP_NO,CHARGE_DATE,DEPT_CODE,PERFORM_BY,CHARGE_KIND_CODE,CHARGE_DETAIL_CODE,WORKLOAD,PRICE,PATIENT_TYPE_CODE,CHARGE_MONEY,CHECK_NO,PATIENT_NAME,CHARGE_CODE,CHARGE_NAME,BEGIN_NO,END_NO,IS_BACK") [ SqlProc ]
{
}

ClassMethod ACCCHARGEOVIEWMDRExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:startDate="" $$$OK
 q:endDate="" $$$OK 
 k ^||TMPDHCWL($j)
 s stdate=$zdh(startDate,3)
 s endate=$zdh(endDate,3)
 f date=stdate:1:endate d
 .s InvRowid=0 f  s InvRowid=$o(^DHCINVPRT(0,"HandDate",date,InvRowid)) q:InvRowid=""  d
 ..s BCIRowid=0 f  s BCIRowid=$o(^DHCBCI(0,"INV",InvRowid,BCIRowid)) q:BCIRowid=""  d         
 ...s pbId=$p(^DHCBCI(BCIRowid),"^",2)     
 ...s paidFlag=$p(^DHCPB(pbId),"^",16)
 ...q:paidFlag'="P"
 ...s invprtId=$o(^DHCBCI(0,"Bill",pbId,""))
 ...s prtUsr=$p($g(^DHCINVPRT(+invprtId)),"^",21)
 ...i prtUsr="" s prtUsr="999999"
 ...s admId=$P($G(^DHCPB(pbId)),"^",1) 
 ...s reaId=$p(^DHCPB(pbId),"^",4)
 ...i reaId="" s reaId=$p(^PAADM(admId),"^",56)
 ...i reaId="" s reaId=1
 ...s paidTime=$p(^DHCPB(pbId),"^",20)
 ...s papmi=$P($G(^PAADM(admId)),"^",1)
 ...s admType=$P($G(^PAADM(admId)),"^",2)
 ...;q:(admType'="O")&&(admType'="E")
 ...s admRea=$P($G(^PAADM(admId,1)),"^",7)
 ...s ordStatus="P"
 ...s pbo=0
 ...f  s pbo=$o(^DHCPB(pbId,"O",pbo)) q:pbo=""  d
 ....q:$d(^DHCPB(pbId,"O",pbo))=10
 ....s oeori=$P($G(^DHCPB(pbId,"O",pbo)),"^",4) 
 ....s ord=+oeori
 ....s ordSub=$p(oeori,"||",2)
 ....s recDep=$P($G(^OEORD(ord,"I",ordSub,3)),"^",6)	;接收科室
 ....s resDep=$P($G(^OEORD(ord,"I",ordSub,7)),"^",2)	;下医嘱科室   OEORI_UserDepartment_DR
 ....s resUser=$P($G(^OEORD(ord,"I",ordSub,7)),"^",1)
 ....i resUser'="" s resDoc=$p($g(^SSU("SSUSR",+resUser)),"^",14)	
 ....e  s resDoc=""
 ....s ordDate=$P($G(^OEORD(ord,"I",ordSub,3)),"^",7)  ;下医嘱日期
 ....s ordTime=$P($G(^OEORD(ord,"I",ordSub,1)),"^",17)	;下医嘱时间
 ....s arcim=$P($G(^DHCPB(pbId,"O",pbo)),"^",3) 	;医嘱项    
 ....s arcSub=+arcim
 ....s arcVer=$p(arcim,"||",2) 
 ....s itemCat=$P($G(^ARCIM(arcSub,arcVer,1)),"^",10) ;医嘱子类
 ....s billSub=$P($G(^ARCIM(arcSub,arcVer,1)),"^",9)	;账单子类
 ....s billGrp=$P(billSub,"||",1)	;账单大类
 ....s billGrpSub=$P(billSub,"||",2)
 ....s patDep=$P($G(^PAADM(admId)),"^",4)	;病人科室
 ....s patDoc=$P($G(^PAADM(admId)),"^",9)	;病人医生
 ....s patWard=$P($G(^PAADM(admId)),"^",70)   ;病人病区
 ....i patWard'="" s patWard=$p($g(^PAWARD(patWard)),"^",5)
 ....i resDoc=""  s resDoc=patDoc	//如果下医嘱医生为空,修改为病人医生
 ....i resDep="" s resDep=patDep	//如果下医嘱科室为空,修改为病人科室
 ....s pbd=0
 ....f  s pbd=$O(^DHCPB(pbId,"O",pbo,"D",pbd)) q:pbd=""    d  ;新记费
 .....s pbdId=pbId_"||"_pbo_"||"_pbd
 .....s unitPrice=$P(^DHCPB(pbId,"O",pbo,"D",pbd),"^",4) ;新记费
 .....s lineTotal=$P(^DHCPB(pbId,"O",pbo,"D",pbd),"^",7)
 .....s qty=$P(^DHCPB(pbId,"O",pbo,"D",pbd),"^",5)
 .....s billDate=$P(^DHCPB(pbId,"O",pbo,"D",pbd),"^",11)   ;计费点
 .....s billTime=$P(^DHCPB(pbId,"O",pbo,"D",pbd),"^",12)  ;恢复
 .....s tari=$P(^DHCPB(pbId,"O",pbo,"D",pbd),"^",3)
 .....s tarAC=$p($g(^DHCTARI(+tari)),"^",5)    ;DHC_TarAcctCate
 .....s tarSC=$p($g(^DHCTARI(+tari)),"^",4)    ;DHC_TarSubCate
 .....s tarOC=$p($g(^DHCTARI(+tari)),"^",15)    ;DHC_TarOutpatCate 
 .....s tarEMC=$p($g(^DHCTARI(+tari)),"^",16)    ;DHC_TarEMCCate         
 .....s tarMC=$p($g(^DHCTARI(+tari)),"^",6)    ;DHC_TarMRCate                  
 .....s tarIC=$p($g(^DHCTARI(+tari)),"^",14)    ;DHC_TarInpatCate  
 .....s tarNMC=$p($g(^DHCTARI(+tari)),"^",30)    ;子类?^DHCTarC("MCNew",rowid) 大类?^DHCTarC("TMCNew",rowid)
 .....s discfee=$P($g(^DHCPB(pbId,"O",pbo,"D",pbd)),"^",8)	///	折扣费用
 .....s allfee=$P($g(^DHCPB(pbId,"O",pbo,"D",pbd)),"^",7)
 .....s zffee=$G(lineTotal)-$G(discfee)
 .....s back=0
 .....i zffee<0 s back=1
 .....s ^||TMPDHCWL($j,date,resDep,recDep,tarAC,tari,admType,reaId,prtUsr,patDep,back,"qty")=$g(^||TMPDHCWL($j,date,resDep,recDep,tarAC,tari,admType,reaId,prtUsr,patDep,back,"qty"))+qty
 .....s ^||TMPDHCWL($j,date,resDep,recDep,tarAC,tari,admType,reaId,prtUsr,patDep,back,"Cost")=$g(^||TMPDHCWL($j,date,resDep,recDep,tarAC,tari,admType,reaId,prtUsr,patDep,back,"Cost"))+lineTotal 
  
 
 s mDate=""  f  s mDate=$o(^||TMPDHCWL($j,mDate))  q:mDate=""  d
 .s mPatLoc=""  f  s mPatLoc=$o(^||TMPDHCWL($j,mDate,mPatLoc))  q:mPatLoc=""  d
 ..s mRecLoc=""  f  s mRecLoc=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc))  q:mRecLoc=""  d
 ...s ecId=""  f  s ecId=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,ecId))  q:ecId=""  d
 ....s itemId=""  f  s itemId=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,ecId,itemId))  q:itemId=""  d
 .....s type=""  f  s type=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,ecId,itemId,type))  q:type=""  d 
 ......s patRea=""  f  s patRea=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,ecId,itemId,type,patRea))  q:patRea=""  d
 .......s user=""  f  s user=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,ecId,itemId,type,patRea,user))  q:user=""  d
 ........s dept=""  f  s dept=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,ecId,itemId,type,patRea,user,dept))  q:dept=""  d
 .........s isback=""  f  s isback=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,ecId,itemId,type,patRea,user,dept,isback))  q:isback=""  d
 ..........s CHARGEDATE=$zd(mDate,3)
 ..........s DEPTCODE=mPatLoc
 ..........s PERFORMBY=mRecLoc
 ..........s CHARGEKINDCODE=ecId
 ..........s CHARGEDETAILCODE=itemId
 ..........;w mDate_"!"_mPatLoc_"!"_mRecLoc_"!"_ecId_"!"_itemId_"!"_patRea_"!"_user_"!"_dept_"!"_isback,!
 ..........s WORKLOAD=$g(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,ecId,itemId,type,patRea,user,dept,isback,"qty"))
 ..........s PATIENTTYPECODE=$ZCONVERT(type,"U")
 ..........s CHARGEMONEY=$g(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,ecId,itemId,type,patRea,user,dept,isback,"Cost"))
 ..........s PRICE=0
 ..........q:(CHARGEMONEY=0)||(WORKLOAD=0)  
 ..........s PRICE=$fn(CHARGEMONEY/WORKLOAD,".",2)
 ..........s CHECKNO=""
 ..........s CHARGECODE= $p($g(^SSU("SSUSR",user)),"^",1) 									;收款员编码
 ..........s CHARGENAME= $p($g(^SSU("SSUSR",user)),"^",2) 									;收款员姓名
 ..........s BEGINNO=""
 ..........s ENDNO=""
 ..........s ISBACK=isback
 ..........s PATIENTNAME=""
 ..........s REPNO = $tr(CHARGEDATE,"-")_CHARGECODE	
 ..........d OutputRow
 k ^||TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
   


OutputRow
	set Data=$lb(REPNO,CHARGEDATE,DEPTCODE,PERFORMBY,CHARGEKINDCODE,CHARGEDETAILCODE,WORKLOAD,PRICE,PATIENTTYPECODE,CHARGEMONEY,CHECKNO,PATIENTNAME,CHARGECODE,CHARGENAME,BEGINNO,ENDNO,ISBACK)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ACCCHARGEOVIEWMDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ACCCHARGEOVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ACCCHARGEOVIEWMDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ACCCHARGEOVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query COSTCHARGEIVIEWMDR(startDate As %String, endDate As %String) As %Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,DEPT_CODE,PERFORM_BY,CHARGE_KIND_CODE,CHARGE_DETAIL_CODE,PATIENT_TYPE_CODE,WORKLOAD,PRICE,CHARGE_MONEY,IS_BACK") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    3.4.5.住院收费(COST_CHARGE_I_VIEW) 
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","COSTCHARGEIVIEWMDR","2021-06-01","2021-06-02")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTCHARGEIVIEWMDR("2021-06-01","2021-06-02")
/// 为页面提供科室子组query
ClassMethod COSTCHARGEIVIEWMDRExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 s sql="select * from web_HRPInterface_DHCWL.COST_CHARGE_I_VIEW WHERE orddate  BETWEEN "_"'"_startDate_"'"_" AND "_"'"_endDate_"'"
 d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("HisToMdr",sql)
 
 s all=""  f  s all=$o(^TMPDHCWL($j,"CS",all))  q:all=""  d
 .s list=$g(^TMPDHCWL($j,"CS",all))
 .s ACCYEAR=$p(list,"^",2)
 .s ACCMONTH=$p(list,"^",3)
 .s DEPTCODE=$p(list,"^",4)
 .s PERFORMBY=$p(list,"^",5)
 .s CHARGEKINDCODE=$p(list,"^",6)
 .s CHARGEDETAILCODE=$p(list,"^",7)
 .s PATIENTTYPECODE=$p(list,"^",8)
 .s WORKLOAD=$p(list,"^",9)
 .s PRICE=$p(list,"^",10)
 .s CHARGEMONEY=$p(list,"^",11)
 .s ISBACK=$p(list,"^",12)
 .q:(WORKLOAD=0)&&(CHARGEMONEY=0)
 .d OutputRow
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(ACCYEAR,ACCMONTH,DEPTCODE,PERFORMBY,CHARGEKINDCODE,CHARGEDETAILCODE,PATIENTTYPECODE,WORKLOAD,PRICE,CHARGEMONEY,ISBACK)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod COSTCHARGEIVIEWMDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COSTCHARGEIVIEWMDRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COSTCHARGEIVIEWMDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COSTCHARGEIVIEWMDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query COSTCHARGEIVIEW(startDate As %String, endDate As %String) As %Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,APPL_DEPT_CODE,APPL_DEPT_NAME,EXEC_DEPT_CODE,EXEC_DEPT_NAME,CHARGE_KIND_CODE,CHARGE_KIND_NAME,CHARGE_ITEM_CODE,CHARGE_ITEM_NAME,PRICE,NUM,MONEY,BUSI_DATA_SOURCE_CODE,CREAT_USER,CREAT_DATE") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    HIS收入接口-财务部分V8.4-住院收费
/// Table：         
/// Input：         计费日期      
/// Output：        收费日期,开单科室编码,执行科室编码,收费类别编码,收费项目编码,数量,单价,患者类别编码,收费金额,是否退费    
/// Return：        CHARGE_DATE,DEPT_CODE,PERFORM_BY,CHARGE_KIND_CODE,CHARGE_DETAIL_CODE,WORKLOAD,PRICE,PATIENT_TYPE_CODE,CHARGE_MONEY,IS_BACK
/// 
/// *d ##class(%ResultSet).RunQuery("DHCWL.InterManagement.projects.HrpInterface","COSTCHARGEIVIEW","2019-01-01","2019-05-01")  */
/// call DHCWL_InterManagement_projects.HrpInterface_COSTCHARGEIVIEW("2020-04-01","2020-04-01")
ClassMethod COSTCHARGEIVIEWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:startDate="" $$$OK
 q:endDate="" $$$OK 
 k ^||TMPDHCWL($j)
 s stdate=$zdh(startDate,3)
 s endate=$zdh(endDate,3)
 f date=stdate:1:endate d
 .s wLRowid=0 f  s wLRowid=$o(^DHCWorkLoad(0,"FlagDate",date,wLRowid)) q:wLRowid=""  d 
 ..s type=$p($g(^DHCWorkLoad(wLRowid)),"^",4)  ;费用类型
 ..q:(type'="I")   ;&&(type'="H")
 ..s days=$zd(date,3)
 ..s mdate=$p(days,"-",1)_"-"_$p(days,"-",2)
 ..s patDept=$p($g(^DHCWorkLoad(wLRowid)),"^",23) 
 ..s recDept=$p($g(^DHCWorkLoad(wLRowid)),"^",1)
 ..s tar=$p($g(^DHCWorkLoad(wLRowid)),"^",40)
 ..s tarItem=$p($g(^DHCWorkLoad(wLRowid)),"^",22)
 ..s qty=$p($g(^DHCWorkLoad(wLRowid)),"^",15)
 ..s unit=$p($g(^DHCWorkLoad(wLRowid)),"^",14)
 ..s reaId=$p($g(^DHCWorkLoad(wLRowid)),"^",52)
 ..s total=$p($g(^DHCWorkLoad(wLRowid)),"^",16)
 ..i total>0 d
 ...s back=0 
 ..e  d
 ...s back=1 
 ..s ^||TMPDHCWL($j,mdate,patDept,recDept,tar,tarItem,unit)=$g(^||TMPDHCWL($j,mdate,patDept,recDept,tar,tarItem,unit))+total
 
 s mDATE="" f  s mDATE=$o(^||TMPDHCWL($j,mDATE)) q:mDATE=""  d
 .s ACCYEAR=$p(mDATE,"-",1)
 .s ACCMONTH=$p(mDATE,"-",2)
 .s DEPTCODE="" f  s DEPTCODE=$o(^||TMPDHCWL($j,mDATE,DEPTCODE)) q:DEPTCODE=""  d
 ..s APPLDEPTCODE=$p(^CTLOC(DEPTCODE),"^",1)
 ..s APPLDEPTNAME=$p(^CTLOC(DEPTCODE),"^",2)
 ..s RECDEPT="" f  s RECDEPT=$o(^||TMPDHCWL($j,mDATE,DEPTCODE,RECDEPT)) q:RECDEPT=""  d
 ...s EXECDEPTCODE=$p(^CTLOC(RECDEPT),"^",1)
 ...s EXECDEPTNAME=$p(^CTLOC(RECDEPT),"^",2)
 ...s KINDID="" f  s KINDID=$o(^||TMPDHCWL($j,mDATE,DEPTCODE,RECDEPT,KINDID)) q:KINDID=""  d
 ....s CHARGEKINDCODE=$p(^DHCTarC("AC",KINDID),"^",1)
 ....s CHARGEKINDNAME=$p(^DHCTarC("AC",KINDID),"^",2)
 ....s DETAILID="" f  s DETAILID=$o(^||TMPDHCWL($j,mDATE,DEPTCODE,RECDEPT,KINDID,DETAILID)) q:DETAILID=""  d
 .....s CHARGEITEMCODE=$p(^DHCTARI(DETAILID),"^",1)
 .....s CHARGEITEMNAME=$p(^DHCTARI(DETAILID),"^",2)
 .....s PRICE="" f  s PRICE=$o(^||TMPDHCWL($j,mDATE,DEPTCODE,RECDEPT,KINDID,DETAILID,PRICE)) q:PRICE=""  d
 ......q:PRICE=0
 ......s MONEY=$g(^||TMPDHCWL($j,mDATE,DEPTCODE,RECDEPT,KINDID,DETAILID,PRICE))
 ......s NUM=+MONEY / PRICE
 ......s BUSIDATASOURCECODE=01 
 ......s CREATUSER=""
 ......s CREATDATE=$zd(+$H,3)
 ......d OutputRow
 k ^||TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
   


OutputRow
	set Data=$lb(ACCYEAR,ACCMONTH,APPLDEPTCODE,APPLDEPTNAME,EXECDEPTCODE,EXECDEPTNAME,CHARGEKINDCODE,CHARGEKINDNAME,CHARGEITEMCODE,CHARGEITEMNAME,PRICE,NUM,MONEY,BUSIDATASOURCECODE,CREATUSER,CREATDATE)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod COSTCHARGEIVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COSTCHARGEIVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COSTCHARGEIVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COSTCHARGEIVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query WorkloadVIEW(yearMonth As %String) As %Query(ROWSPEC = "GROUP_ID,GROUP_NAME,HOS_ID,HOS_NAME,COPY_CODE,COPY_NAME,ACC_YEAR,ACC_MONTH,TARGET_CODE,TARGET_NAME,TARGET_VALUE:%Float") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    HIS收入接口-财务部分V8.4-医疗费用-工作绩效
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","WorkloadVIEW","2020-04")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_WorkloadVIEW("2020-04")
/// 为页面提供科室子组query
ClassMethod WorkloadVIEWExecute(ByRef qHandle As %Binary, yearMonth As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j),^TEMPDHCWL($j)
 k endDate,startDate
 s startDate=yearMonth_"-"_"01"
 s lastdate=$p(yearMonth,"-",1)_"-"_($p(yearMonth,"-",2)+1)_"-"_"01"
 i $p(lastdate,"-",2)="13" d
 .s endDate=$p(lastdate,"-",1)_"-"_12_"-"_31
 e  d
 .s endDate=$zdh(lastdate,3)-1
 .s endDate=$zd(endDate,3)
 d GetPresc(startDate,endDate)  
 d GetMRIPData(startDate,endDate)
 d GetDocRegNum(startDate,endDate)
 d GetDocOpNum(startDate,endDate)
 
 s cfO=$g(^TEMPDHCWL($j,"O","PrescAmount"))
 s cfI=$g(^TEMPDHCWL($j,"I","PrescAmount"))
 s cyrs=$g(^TEMPDHCWL($j,"DISPAT"))
 s cyys=$g(^TEMPDHCWL($j,"DOCNUM")) 
 s ghrs=$g(^TEMPDHCWL($j,"REGNUM"))
 s ghys=$g(^TEMPDHCWL($j,"REGDOC"))
 s ssrs=$g(^TEMPDHCWL($j,"OPDOCNUM"))
 s ssyc=$g(^TEMPDHCWL($j,"OPTIME"))  
 s cyhzzy=$g(^TEMPDHCWL($j,"CYZYCR"))
 s sjkfc=$g(^TEMPDHCWL($j,"SJKF"))
 s sjzy=$g(^TEMPDHCWL($j,"SJZY"))

 s ^||TMPDHCWL($j,"Sort","A01")=cfO
 s ^||TMPDHCWL($j,"Sort","A02")=cfI
 
 s ^||TMPDHCWL($j,"Sort","B01")=cyrs
 s ^||TMPDHCWL($j,"Sort","B02")=cyys
 s ^||TMPDHCWL($j,"Sort","B03")=ghrs
 s ^||TMPDHCWL($j,"Sort","B04")=ghys
 s ^||TMPDHCWL($j,"Sort","B05")=ssrs
 s ^||TMPDHCWL($j,"Sort","B06")=ssyc
 s ^||TMPDHCWL($j,"Sort","B07")=cyhzzy
 s ^||TMPDHCWL($j,"Sort","B08")=sjkfc
 s ^||TMPDHCWL($j,"Sort","B09")=sjzy
 ;w cfO_"!"_cfI_"!"_sjkfc_"!"_sjzy_"!"_cyrs_"!"_zyr_"!"_ghys_"!"_ghrc_"!"_ssys_"!"_ssyc,!
 
 s sort="" f  s sort=$o(^||TMPDHCWL($j,"Sort",sort)) q:sort=""  d
 .s GROUPID=18
 .s GROUPNAME="天津中医药大学附属第一医院"
 .s HOSID="20"
 .s HOSNAME="天津中医药大学附属第一医院"
 .s COPYCODE=1
 .s COPYNAME="天津中医药大学附属第一医院"
 .s ACCYEAR=$p(yearMonth,"-",1)
 .s ACCMONTH=$p(yearMonth,"-",2)
 .s TARGETCODE=sort
 .s TARGETNAME=$case(sort,"A01":"门急诊处方量","A02":"住院处方量","B01":"出院人数","B02":"出院病人医生数","B03":"挂号人数","B04":"挂号病人医生数","B05":"手术人数","B06":"主刀医生数量","B07":"出院患者占用总床日","B08":"实际开放总床日","B09":"实际占用总床日")
 .s TARGETVALUE=$g(^||TMPDHCWL($j,"Sort",sort))
 .d OutputRow
 k ^||TMPDHCWL($j),^TEMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(GROUPID,GROUPNAME,HOSID,HOSNAME,COPYCODE,COPYNAME,ACCYEAR,ACCMONTH,TARGETCODE,TARGETNAME,TARGETVALUE)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 	
 	
GetDocRegNum(startDate,endDate)
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s num=0
	f date=startDate:1:endDate d
	.s regId=0 f  s regId=$o(^DHCWorkRegReport(0,"ADMDATE",date,regId)) q:regId=""  d
	..s count=$p(^DHCWorkRegReport(regId),"^",29)
	..s patDoc=$p(^DHCWorkRegReport(regId),"^",6)
    ..s ^TEMPDHCWL($j,"REGNUM")=$g(^TEMPDHCWL($j,"REGNUM"))+count 
    ..s ^TEMPDHCWL($j,"REGDOC",patDoc)="" 
    
    s doc="" f  s doc=$o(^TEMPDHCWL($j,"REGDOC",doc)) q:doc=""  d
    .s num=$g(num)+1
    .s ^TEMPDHCWL($j,"REGDOC")=num
    q 1
    
	
GetDocOpNum(StartDay,EndDay)
 s StartDay=$zdh(StartDay,3)
 s EndDay=$zdh(EndDay,3)
 f day=StartDay:1:EndDay d
 .s OPArowid="" f  s OPArowid=$o(^DHCANOPArrange(0,"SDate",day,OPArowid)) q:OPArowid=""  d
 ..s OPAStatus=$p(^DHCANOPArrange(OPArowid),"^",27)
 ..q:OPAStatus=""
 ..q:OPAStatus'="F"                                                  
 ..s Anaestdr=$p(^DHCANOPArrange(OPArowid),"^",2)
 ..s AnPaadmDr=$p(Anaestdr,"||",1)
 ..s AnSubDr=$p(Anaestdr,"||",2)
 ..s ANAOPChildsubM=0 s ANAOPChildsubM=$o(^OR(AnPaadmDr,"ANA",AnSubDr,"OP",ANAOPChildsubM)) q:ANAOPChildsubM="" 
 ..s SurgeonDRM=+$p(^OR(AnPaadmDr,"ANA",AnSubDr,"OP",ANAOPChildsubM),"^",8)      ;主刀医生 
 ..s ^TEMPDHCWL($j,"OPDOCNUM",SurgeonDRM)=$g(^TEMPDHCWL($j,"OPDOCNUM",SurgeonDRM))+1  
 ..s ^TEMPDHCWL($j,"OPTIME")=$g(^TEMPDHCWL($j,"OPTIME"))+1 
     
 s doc="" f  s doc=$o(^TEMPDHCWL($j,"OPDOCNUM",doc)) q:doc=""  d
 .s num=$g(num)+1
 .s ^TEMPDHCWL($j,"OPDOCNUM")=num
 q 1
 
 
 	
	
GetPresc(dayfrom,dayto)      
  s dayfrom=$ZDH(dayfrom,3)
  s dayto=$ZDH(dayto,3)
  f ORdDate=dayfrom:1:dayto d
  .s WorkLoadRowid=0 
  .f  s WorkLoadRowid=$o(^DHCWorkLoad(0,"ORDDATE",ORdDate,WorkLoadRowid)) q:WorkLoadRowid=""  d
  ..s cPatType=$p(^DHCWorkLoad(WorkLoadRowid),"^",4)
  ..i cPatType="E" s cPatType="O"
  ..s cOEORIDR=$P($G(^DHCWorkLoad(WorkLoadRowid)),"^",21)
  ..q:cOEORIDR="0"        
  ..s OEORDid=$p(cOEORIDR,"||",1),OEORIChildsub=$p(cOEORIDR,"||",2)
  ..s PrescNo=$p($g(^OEORD(OEORDid,"I",OEORIChildsub,1)),"^",14) q:PrescNo=""       ;根据处方号查出处方数量
  ..s ^TEMPDHCWL($j,PrescNo,"cfAmount")=$g(^TEMPDHCWL($j,PrescNo,"cfAmount"))+1
  ..s count2=$g(^TEMPDHCWL($j,PrescNo,"cfAmount"))
  ..s cfAmount=$case(count2,1:1,2:0,:0) 
  ..s ^TEMPDHCWL($j,cPatType,"PrescAmount")=$g(^TEMPDHCWL($j,cPatType,"PrescAmount"))+cfAmount
  q 1
  
GetMRIPData(startDate,endDate)
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	f date=startDate:1:endDate d
	.s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",date,mrId)) q:mrId=""  d
	..s loc=$p(^MRIPdaily(mrId),"^",7) //科室
    ..q:loc=""
	..s cyrs=$p(^MRIPdaily(mrId),"^",5)  //出院人数MRIP_crrs
    ..s xyrs=$p(^MRIPdaily(mrId),"^",18)  //现有人数	MRIP_XYRS
	..s sybednum=$p($$BedNum^DHCMRIPday(date,"Loc",loc),"^",2)
	..s ^TEMPDHCWL($j,"SJKF")=$g(^TEMPDHCWL($j,"SJKF"))+sybednum
	..s ^TEMPDHCWL($j,"SJZY")=$g(^TEMPDHCWL($j,"SJZY"))+xyrs 
	..s ^TEMPDHCWL($j,"DISPAT")=$g(^TEMPDHCWL($j,"DISPAT"))+cyrs
	..s rowid="" f  s rowid=$o(^DHCMRIPDetail(0,"IPType",mrId,"CYRS",rowid)) q:rowid=""  d
 	...s admid=$p(^DHCMRIPDetail(rowid),"^",1)
 	...s doc=$P(^PAADM(admid),"^",9)
 	...i doc="" s doc="999999"
 	...s ^TEMPDHCWL($j,"DOCNUM",doc)=""
 	...s paadmDate=$P(^PAADM(admid),"^",6)
	...s paadmDisDate=$P(^PAADM(admid),"^",17)		;以最终结算时间为准
	...;s paadmDisDate=$P(^PAADM(admid),"^",59)		;以医疗结算时间为准
	...i $g(paadmDisDate)="" s paadmDisDate=+$h
	...s zyts=paadmDisDate-paadmDate
	...i zyts<=0 s zyts=1
	...s cyzyzcs=$g(cyzyzcs)+zyts       	;出院者占用总床日数
	...s ^TEMPDHCWL($j,"CYZYCR")=$g(^TEMPDHCWL($j,"CYZYCR"))+zyts
	
	s doc="" f  s doc=$o(^TEMPDHCWL($j,"DOCNUM",doc)) q:doc=""  d
    .s num=$g(num)+1
    .s ^TEMPDHCWL($j,"DOCNUM")=num
	q 1
}

ClassMethod WorkloadVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WorkloadVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod WorkloadVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WorkloadVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ---------------------------------------------------------------------------------------------------------------------------
Query ACCCHARGEOVIEW(startDate As %String, endDate As %String) As %Query(ROWSPEC = "REP_NO,CHARGE_DATE,PATI_CODE,DEPT_CODE,PERFORM_BY,CHARGE_KIND_CODE,CHARGE_DETAIL_CODE,WORKLOAD,PRICE,PATIENT_TYPE_CODE,CHARGE_MONEY,CHECK_NO,PATIENT_NAME,CHARGE_CODE,CHARGE_NAME,BEGIN_NO,END_NO,IS_BACK") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    HIS收入接口-财务部分V8.4-门诊收入
/// Table：         
/// Input：         打发票日期      
/// Output：        日报序号,收费日期,开单科室编码,执行科室编码,收费类别编码（核算子分类）,收费金额,收款员编码,收款员姓名,是否退费     
/// Return：        REP_NO,CHARGE_DATE,DEPT_CODE,PERFORM_BY,CHARGE_KIND_CODE,CHARGE_MONEY,CHARGE_CODE,CHARGE_NAME,IS_BACK
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","ACCCHARGEOVIEW","2020-07-01","2020-07-03")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_ACCCHARGEOVIEW("2020-04-01","2020-04-01")
/// call web_HRPInterface_DHCWL.GetWlDetail_WorkloadVIEW("2020-04")
/// 为页面提供科室子组query
ClassMethod ACCCHARGEOVIEWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:startDate="" $$$OK
 q:endDate="" $$$OK 
 k ^||TMPDHCWL($j)
 s stdate=$zdh(startDate,3)
 s endate=$zdh(endDate,3)
 f date=stdate:1:endate d
 .s wLRowid=0 f  s wLRowid=$o(^DHCWorkLoad(0,"ORDDATE",date,wLRowid)) q:wLRowid=""  d 
 ..s type=$p($g(^DHCWorkLoad(wLRowid)),"^",4)  ;费用类型
 ..q:(type="I")
 ..s arpbl=$p($g(^DHCWorkLoad(wLRowid)),"^",20)
 ..s invprtId=$o(^DHCBCI(0,"Bill",arpbl,""))
 ..s prtUsr=$p($g(^DHCINVPRT(+invprtId)),"^",21)
 ..i prtUsr="" s prtUsr="999999"
 ..s patDept=$p($g(^DHCWorkLoad(wLRowid)),"^",23)
 ..s resDept=$p($g(^DHCWorkLoad(wLRowid)),"^",3) 
 ..s recDept=$p($g(^DHCWorkLoad(wLRowid)),"^",1)
 ..s acId=$p($g(^DHCWorkLoad(wLRowid)),"^",40)
 ..s total=$p($g(^DHCWorkLoad(wLRowid)),"^",16)
 ..s reaId=$p($g(^DHCWorkLoad(wLRowid)),"^",52)
 ..s admRea=$p(^PAC("ADMREA",reaId),"^",1)
 ..i total>0 d
 ...s back=0 
 ..e  d
 ...s back=1
 ..s ^||TMPDHCWL($j,date,patDept,recDept,resDept,acId,prtUsr,back,reaId)=$g(^||TMPDHCWL($j,date,patDept,recDept,resDept,acId,prtUsr,back,reaId))+total
 
 
 s mDate=""  f  s mDate=$o(^||TMPDHCWL($j,mDate))  q:mDate=""  d
 .s mPatLoc=""  f  s mPatLoc=$o(^||TMPDHCWL($j,mDate,mPatLoc))  q:mPatLoc=""  d
 ..s mRecLoc=""  f  s mRecLoc=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc))  q:mRecLoc=""  d
 ...s mResLoc=""  f  s mResLoc=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,mResLoc))  q:mResLoc=""  d
 ....s acId=""  f  s acId=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,mResLoc,acId))  q:acId=""  d
 .....s userId=""  f  s userId=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,mResLoc,acId,userId))  q:userId=""  d
 ......s backflag=""  f  s backflag=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,mResLoc,acId,userId,backflag))  q:backflag=""  d
 .......s patRea=""  f  s patRea=$o(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,mResLoc,acId,userId,backflag,patRea))  q:patRea=""  d												;收费日期
 ........s DEPTCODE = $p(^CTLOC(mPatLoc),"^",1)
 ........s PERFORMBY = $p(^CTLOC(mRecLoc),"^",1)
 ........s PATICODE = $p(^CTLOC(mResLoc),"^",1)
 ........;s DEPTCODE = mPatLoc ;$p(^CTLOC(mPatLoc),"^",1) 												;开单科室编码
 ........;s PERFORMBY = mRecLoc ;$p(^CTLOC(mRecLoc),"^",1) 												;执行科室编码
 ........;s PATICODE = mResLoc ;$p(^CTLOC(mRecLoc),"^",1) 												;病人科室编码
 ........;s tid = $p(^DHCTarC("OC",ocId),"^",3) ;$p(^DHCTarC("EC",ecId),"^",1) 									;收费类别编码（核算子分类）
 ........s CHARGEKINDCODE = acId ;$p(^DHCTarC("AC",acId),"^",1)
 ........s CHARGEMONEY= $g(^||TMPDHCWL($j,mDate,mPatLoc,mRecLoc,mResLoc,acId,userId,backflag,patRea)) 		;收费金额
 ........k CHARGECODE,CHARGENAME
 ........s CHARGECODE= $p($g(^SSU("SSUSR",userId)),"^",1) 									;收款员编码
 ........s CHARGENAME= $p($g(^SSU("SSUSR",userId)),"^",2) 									;收款员姓名
 ........s ISBACK = backflag 																	;是否退费
 ........s CHARGEDATE = $zd(mDate,3)            ;_$p($g(^SSU("SSUSR",userId)),"^",1)   ;_"-"_0
 ........s mFlag=0
 ........s REPNO = $tr(CHARGEDATE,"-")_CHARGECODE												;日报序号
 ........s PATIENTTYPECODE=patRea
 ........;s hospId=$p(^CTLOC(mPatLoc),"^",22)
 ........;s HOSDISTRICT=$case(hospId,2:"1",5:"0",:"999999")
 ........d OutputRow
 k ^||TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
   


OutputRow
	set Data=$lb(REPNO,CHARGEDATE,PATICODE,DEPTCODE,PERFORMBY,CHARGEKINDCODE,CHARGEDETAILCODE,WORKLOAD,PRICE,PATIENTTYPECODE,CHARGEMONEY,CHECKNO,PATIENTNAME,CHARGECODE,CHARGENAME,BEGINNO,ENDNO,ISBACK)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ACCCHARGEOVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ACCCHARGEOVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ACCCHARGEOVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ACCCHARGEOVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ---------------------------------------------------------------------------------------------------------------------------------
Query ACCCHARGEIVIEW(startDate As %String, endDate As %String) As %Query(ROWSPEC = "CHARGE_DATE,DEPT_CODE,CHARGE_KIND_CODE,PATIENT_TYPE_CODE,CHARGE_MONEY,CHARGE_CODE,CHARGE_NAME,IS_BACK,HOS_DISTRICT_CODE") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    HIS收入接口-财务部分
/// Table：         
/// Input：         打发票日期      
/// Output：        收费日期,开单科室编码,收费类别编码（核算子分类）,收费金额,是否退费,标识     
/// Return：        CHARGE_DATE,DEPT_CODE,CHARGE_KIND_CODE,CHARGE_MONEY,CHARGE_CODE,CHARGE_NAME,IS_BACK,HIS_TYPE
/// call web_HRPInterface_DHCWL.GetWlDetail_ACCCHARGEIVIEW("2020-04-01","2020-04-01")
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","ACCCHARGEIVIEW","2019-01-01","2019-03-01")  */
/// 为页面提供科室子组query
ClassMethod ACCCHARGEIVIEWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:startDate="" $$$OK
 q:endDate="" $$$OK 
 k ^||TMPDHCWL($j)
 s stdate=$zdh(startDate,3)
 s endate=$zdh(endDate,3)
 f date=stdate:1:endate d
 .s wLRowid=0 f  s wLRowid=$o(^DHCWorkLoad(0,"ORDDATE",date,wLRowid)) q:wLRowid=""  d 
 ..s type=$p($g(^DHCWorkLoad(wLRowid)),"^",4)  ;费用类型
 ..q:(type'="I")
 ..s arpbl=$p($g(^DHCWorkLoad(wLRowid)),"^",20)
 ..s invprtId=$o(^DHCINVPRTZY(0,"AR",arpbl,""))
 ..s prtUsr=$p($g(^DHCINVPRTZY(+invprtId)),"^",7)
 ..i prtUsr="" s prtUsr="999999"
 ..s patDept=$p($g(^DHCWorkLoad(wLRowid)),"^",23)
 ..i patDept="" s patDept="999999"
 ..s resDept=$p($g(^DHCWorkLoad(wLRowid)),"^",3)
 ..i resDept="" s resDept="999999"
 ..s recDept=$p($g(^DHCWorkLoad(wLRowid)),"^",1)
 ..i recDept="" s recDept="999999"
 ..s acId=$p($g(^DHCWorkLoad(wLRowid)),"^",41)
 ..i acId="" s acId="999999"
 ..s total=$p($g(^DHCWorkLoad(wLRowid)),"^",16)
 ..i total>0 d
 ...s back=0 
 ..e  d
 ...s back=1
 ..s reaId=$p($g(^DHCWorkLoad(wLRowid)),"^",52)
 ..s admRea=$p(^PAC("ADMREA",reaId),"^",1)
 ..s ^||TMPDHCWL($j,date,patDept,resDept,acId,back,admRea,recDept)=$g(^||TMPDHCWL($j,date,patDept,resDept,acId,back,admRea,recDept))+total
 
 s mDate=""  f  s mDate=$o(^||TMPDHCWL($j,mDate))  q:mDate=""  d
 .s mPatLoc=""  f  s mPatLoc=$o(^||TMPDHCWL($j,mDate,mPatLoc))  q:mPatLoc=""  d
 ..s mResDept=""  f  s mResDept=$o(^||TMPDHCWL($j,mDate,mPatLoc,mResDept))  q:mResDept=""  d
 ...s acId=""  f  s acId=$o(^||TMPDHCWL($j,mDate,mPatLoc,mResDept,acId))  q:acId=""  d
 ....s backflag=""  f  s backflag=$o(^||TMPDHCWL($j,mDate,mPatLoc,mResDept,acId,backflag))  q:backflag=""  d
 .....s patRea=""  f  s patRea=$o(^||TMPDHCWL($j,mDate,mPatLoc,mResDept,acId,backflag,patRea))  q:patRea=""  d 
 ......s rec=""  f  s rec=$o(^||TMPDHCWL($j,mDate,mPatLoc,mResDept,acId,backflag,patRea,rec))  q:rec=""  d
 .......s CHARGEDATE = $zd(mDate,3) ;收费日期						
 .......s DEPTCODE = mPatLoc ;$p(^CTLOC(mPatLoc),"^",1) 										;开单科室编码
 .......s CHARGEKINDCODE = acId ;$p(^DHCTarC("AC",acId),"^",1)
 .......s CHARGEMONEY= $g(^||TMPDHCWL($j,mDate,mPatLoc,mResDept,acId,backflag,patRea,rec)) 			;收费金额
 .......s CHARGEMONEY=$JUSTIFY(CHARGEMONEY,1,2)
 .......s ISBACK = backflag 															;是否退费
 .......s HISTYPE=1
 .......;s hospId=$p(^CTLOC(mPatLoc),"^",22)
 .......;s HOSDISTRICT=$case(hospId,2:"1",5:"0",:"999999")
 .......s CHARGECODE=""
 .......s CHARGENAME=""
 .......s PATIENTTYPECODE=patRea
 .......d OutputRow
 k ^||TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
 
 
 
OutputRow
	set Data=$lb(CHARGEDATE,DEPTCODE,CHARGEKINDCODE,PATIENTTYPECODE,CHARGEMONEY,CHARGECODE,CHARGENAME,ISBACK,HISTYPE)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ACCCHARGEIVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ACCCHARGEIVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ACCCHARGEIVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ACCCHARGEIVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query DeptInCome(startDate As %String, endDate As %String) As %Query(ROWSPEC = "APHI_YEAR_MONTH,APHI_MK_DEPT_CODE,APHI_MK_DEPT_NAME,APHI_DEPT_CODE,APHI_DEPT_NAME,APHI_EXC_DEPT_CODE,APHI_EXC_DEPT_NAME,APHI_DATA_TYPE,APHI_ITEM_CODE,APHI_ITEM_NAME,APHI_TarEMCName,APHI_MK_DOCTOR,APHI_ITEM_NUM,APHI_ITEM_SUM") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2021-07-06
/// Description:    3.10.1.3.科室收入数据
/// Table：         
/// Input：              
/// Output：             
/// Return：        
/// call web_HRPInterface_DHCWL.GetWlDetail_DeptInCome("2020-04-01","2020-04-01")
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","DeptInCome","2020-04-01","2020-04-01")  */
/// 为页面提供科室子组query
ClassMethod DeptInComeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:startDate="" $$$OK
 q:endDate="" $$$OK 
 k ^||TMPDHCWL($j)
 s stdate=$zdh(startDate,3)
 s endate=$zdh(endDate,3)
 f date=stdate:1:endate d
 .s wLRowid=0 f  s wLRowid=$o(^DHCWorkLoad(0,"FlagDate",date,wLRowid)) q:wLRowid=""  d 
 ..s type=$p($g(^DHCWorkLoad(wLRowid)),"^",4)  ;费用类型
 ..q:(type="I")
 ..s patDept=$p($g(^DHCWorkLoad(wLRowid)),"^",23)
 ..s resDept=$p($g(^DHCWorkLoad(wLRowid)),"^",3)
 ..s recDept=$p($g(^DHCWorkLoad(wLRowid)),"^",1)
 ..s item=$p($g(^DHCWorkLoad(wLRowid)),"^",22)
 ..s tarEc=$p($g(^DHCWorkLoad(wLRowid)),"^",41)
 ..s doc=$p($g(^DHCWorkLoad(wLRowid)),"^",19)
 ..s yearMonth=$p($zd(date,3),"-",1)_$p($zd(date,3),"-",2)
 ..s qty=$p(^DHCWorkLoad(wLRowid),"^",15)
 ..s total=$p(^DHCWorkLoad(wLRowid),"^",16)
 ..s ^||TMPDHCWL($j,"QTY",yearMonth,patDept,resDept,recDept,type,item,tarEc,doc)=$g(^||TMPDHCWL($j,"QTY",yearMonth,patDept,resDept,recDept,type,item,tarEc,doc))+qty
 ..s ^||TMPDHCWL($j,"TOT",yearMonth,patDept,resDept,recDept,type,item,tarEc,doc)=$g(^||TMPDHCWL($j,"TOT",yearMonth,patDept,resDept,recDept,type,item,tarEc,doc))+total
 
 
 .s wLRowid=0 f  s wLRowid=$o(^DHCWorkLoad(0,"ORDDATE",date,wLRowid)) q:wLRowid=""  d 
 ..s type=$p($g(^DHCWorkLoad(wLRowid)),"^",4)  ;费用类型
 ..q:(type'="I")
 ..s patDept=$p($g(^DHCWorkLoad(wLRowid)),"^",23)
 ..s resDept=$p($g(^DHCWorkLoad(wLRowid)),"^",3)
 ..s recDept=$p($g(^DHCWorkLoad(wLRowid)),"^",1)
 ..s item=$p($g(^DHCWorkLoad(wLRowid)),"^",22)
 ..s tarEc=$p($g(^DHCWorkLoad(wLRowid)),"^",41)
 ..s doc=$p($g(^DHCWorkLoad(wLRowid)),"^",19)
 ..s yearMonth=$p($zd(date,3),"-",1)_$p($zd(date,3),"-",2)
 ..s qty=$p(^DHCWorkLoad(wLRowid),"^",15)
 ..s total=$p(^DHCWorkLoad(wLRowid),"^",16)
 ..s ^||TMPDHCWL($j,"QTY",yearMonth,patDept,resDept,recDept,type,item,tarEc,doc)=$g(^||TMPDHCWL($j,"QTY",yearMonth,patDept,resDept,recDept,type,item,tarEc,doc))+qty
 ..s ^||TMPDHCWL($j,"TOT",yearMonth,patDept,resDept,recDept,type,item,tarEc,doc)=$g(^||TMPDHCWL($j,"TOT",yearMonth,patDept,resDept,recDept,type,item,tarEc,doc))+total
 
 
 s mDate=""  f  s mDate=$o(^||TMPDHCWL($j,"QTY",mDate)) q:mDate=""  d
 .s pDept=""  f  s pDept=$o(^||TMPDHCWL($j,"QTY",mDate,pDept)) q:pDept=""  d
 ..s sDept=""  f  s sDept=$o(^||TMPDHCWL($j,"QTY",mDate,pDept,sDept)) q:sDept=""  d
 ...s cDept=""  f  s cDept=$o(^||TMPDHCWL($j,"QTY",mDate,pDept,sDept,cDept)) q:cDept=""  d
 ....s mType=""  f  s mType=$o(^||TMPDHCWL($j,"QTY",mDate,pDept,sDept,cDept,mType)) q:mType=""  d
 .....s mItem=""  f  s mItem=$o(^||TMPDHCWL($j,"QTY",mDate,pDept,sDept,cDept,mType,mItem)) q:mItem=""  d
 ......s ecId=""  f  s ecId=$o(^||TMPDHCWL($j,"QTY",mDate,pDept,sDept,cDept,mType,mItem,ecId)) q:ecId=""  d
 .......s mDoc=""  f  s mDoc=$o(^||TMPDHCWL($j,"QTY",mDate,pDept,sDept,cDept,mType,mItem,ecId,mDoc)) q:mDoc=""  d
 ........s APHIYEARMONTH=mDate
 ........s APHIMKDEPTCODE=pDept
 ........s APHIMKDEPTNAME=$p(^CTLOC(pDept),"^",2)
 ........s APHIDEPTCODE=sDept
 ........s APHIDEPTNAME=$p(^CTLOC(sDept),"^",2)
 ........s APHIEXCDEPTCODE=cDept
 ........s APHIEXCDEPTNAME=$p(^CTLOC(cDept),"^",2)
 ........s APHIDATATYPE=$case(mType,"O":"门诊","E":"急诊","H":"体检","I":"住院",:"门诊")
 ........s APHIITEMCODE=mItem
 ........s APHIITEMNAME=$p(^DHCTARI(mItem),"^",2)
 ........s APHITarEMCName=$p(^DHCTarC("EC",ecId),"^",2)
 ........s APHIMKDOCTOR=$$GetPatDoc^DHCWLCommon(mDoc)
 ........s APHIITEMNUM=$g(^||TMPDHCWL($j,"QTY",mDate,pDept,sDept,cDept,mType,mItem,ecId,mDoc))
 ........s APHIITEMSUM=$g(^||TMPDHCWL($j,"TOT",mDate,pDept,sDept,cDept,mType,mItem,ecId,mDoc))
 ........q:+APHIITEMSUM=0
 ........d OutputRow
 k ^||TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
 
 
 
OutputRow
	set Data=$lb(APHIYEARMONTH,APHIMKDEPTCODE,APHIMKDEPTNAME,APHIDEPTCODE,APHIDEPTNAME,APHIEXCDEPTCODE,APHIEXCDEPTNAME,APHIDATATYPE,APHIITEMCODE,APHIITEMNAME,APHITarEMCName,APHIMKDOCTOR,APHIITEMNUM,$justify(APHIITEMSUM,1,2))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DeptInComeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptInComeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DeptInComeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptInComeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query DeptInComeMDR(startDate As %String, endDate As %String) As %Query(ROWSPEC = "APHI_YEAR_MONTH,APHI_MK_DEPT_CODE,APHI_MK_DEPT_NAME,APHI_DEPT_CODE,APHI_DEPT_NAME,APHI_EXC_DEPT_CODE,APHI_EXC_DEPT_NAME,APHI_DATA_TYPE,APHI_ITEM_CODE,APHI_ITEM_NAME,APHI_TarEMCName,APHI_MK_DOCTOR,APHI_ITEM_NUM,APHI_ITEM_SUM") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2021-07-07
/// Description:    3.10.1.3.科室收入数据
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","DeptInComeMDR","2021-06-01","2021-06-02")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_DeptInComeMDR("2021-06-01","2021-06-02")
ClassMethod DeptInComeMDRExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 s sql="select * from web_HRPInterface_DHCWL.Dept_Acc_VIEW WHERE  querydate  BETWEEN "_"'"_startDate_"'"_" AND "_"'"_endDate_"'"
 d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("HisToMdr",sql)
 
 s all=""  f  s all=$o(^TMPDHCWL($j,"CS",all))  q:all=""  d
 .s list=$g(^TMPDHCWL($j,"CS",all))
 .s APHIYEARMONTH=$p(list,"^",2)
 .s APHIMKDEPTCODE=$p(list,"^",3)
 .s APHIMKDEPTNAME=$p(list,"^",4)
 .s APHIDEPTCODE=$p(list,"^",5)
 .s APHIDEPTNAME=$p(list,"^",6)
 .s APHIEXCDEPTCODE=$p(list,"^",7)
 .s APHIEXCDEPTNAME=$p(list,"^",8)
 .s APHIDATATYPE=$p(list,"^",9)
 .s APHIITEMCODE=$p(list,"^",10)
 .s APHIITEMNAME=$p(list,"^",11)
 .s APHITarEMCName=$p(list,"^",12)
 .s APHIMKDOCTOR=$p(list,"^",13)
 .s APHIITEMNUM=$p(list,"^",14)
 .s APHIITEMSUM=$p(list,"^",15)
 .d OutputRow
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(APHIYEARMONTH,APHIMKDEPTCODE,APHIMKDEPTNAME,APHIDEPTCODE,APHIDEPTNAME,APHIEXCDEPTCODE,APHIEXCDEPTNAME,APHIDATATYPE,APHIITEMCODE,APHIITEMNAME,APHITarEMCName,APHIMKDOCTOR,APHIITEMNUM,APHIITEMSUM)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DeptInComeMDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptInComeMDRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DeptInComeMDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptInComeMDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  3.9.1.9 诊疗医嘱
/// Table：         HTCG_MEDICAL_ADVICE_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.HTCG_MEDICAL_ADVICE_VIEW
Query MEDICALView() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = HTCG_MEDICAL_ADVICE_VIEW ]
{
SELECT
CAST(web_HRPInterface_DHCWL.GetWlDetail_GetPapmiMedtare(WorkLoad_PAPMI_DR) AS VARCHAR(20) ) AS MR_NO,
CAST(WorkLoad_PAADM_DR AS VARCHAR(20) ) AS IN_HOS_NO,
CAST(WorkLoad_OrdDate AS CHAR(10)) AS ADVICE_DATE, 
CAST(WorkLoad_PatDep_DR AS VARCHAR(20) ) AS ORDER_BY_CODE,
CAST(WorkLoad_RecDep_DR AS VARCHAR(20) ) AS PERFORM_BY_CODE,
CAST(WorkLoad_TarItem_DR AS VARCHAR(20) )AS CHARGE_ITEM_CODE,
CAST(sum(WorkLoad_Quantity) AS NUMERIC(30,8)) AS AMOUNT,
CAST(WorkLoad_UnitPrice AS NUMERIC(30,8)) AS PRICE,
CAST(sum(WorkLoad_TotalPrice) AS NUMERIC(30,8)) AS INCOME_MONEY,
CAST(WorkLoad_OEORI_DR -> OEORI_Priority_DR -> OECPR_Desc AS VARCHAR(20) ) AS RECIPE_TYPE_CODE,
CAST(
	CASE 
		WHEN EXISTS(SELECT * FROM sqluser.PA_Adm WHERE PAADM_DischgDate IS NOT NULL AND PAADM_RowID = WorkLoad_PAADM_DR) THEN WorkLoad_PAADM_DR-> PAADM_DepCode_DR -> CTLOC_Desc
		ELSE 'Null'
	END
AS VARCHAR(20) ) AS PLACE,
CAST(WorkLoad_PatDep_DR -> CTLOC_Hospital_DR AS VARCHAR(20) ) AS Hosp_Code
FROM sqluser.DHC_WorkLoad
WHERE WorkLoad_Type = 'I' AND web_HRPInterface_DHCWL.GetWlDetail_GetImType(WorkLoad_ItemOrd_DR) = 'treatment'
GROUP BY WorkLoad_PAADM_DR,WorkLoad_OrdDate,WorkLoad_PatDep_DR,WorkLoad_RecDep_DR,WorkLoad_TarItem_DR,WorkLoad_OEORI_DR -> OEORI_Priority_DR -> OECPR_Desc
}

/// Creator：       ET
/// CreatDate：     2020-02-22
/// Description:：  3.9.1.11. 材料医嘱
/// Table：         HTCG_MATERIAL_ADVICE_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.HTCG_MATERIAL_ADVICE_VIEW
Query MATERIALView() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = HTCG_MATERIAL_ADVICE_VIEW ]
{
SELECT
CAST(web_HRPInterface_DHCWL.GetWlDetail_GetPapmiMedtare(WorkLoad_PAPMI_DR) AS VARCHAR(20) ) AS MR_NO,
CAST(WorkLoad_PAADM_DR AS VARCHAR(20) ) AS IN_HOS_NO,
CAST(WorkLoad_OrdDate AS CHAR(10)) AS ADVICE_DATE, 
CAST(WorkLoad_PatDep_DR AS VARCHAR(20) ) AS ORDER_BY_CODE,
CAST(WorkLoad_RecDep_DR AS VARCHAR(20) ) AS PERFORM_BY_CODE,
CAST(WorkLoad_TarItem_DR AS VARCHAR(20) )AS CHARGE_ITEM_CODE,
CAST(sum(WorkLoad_Quantity) AS NUMERIC(30,8)) AS AMOUNT,
CAST(WorkLoad_UnitPrice AS NUMERIC(30,8)) AS PRICE,
CAST(sum(WorkLoad_TotalPrice) AS NUMERIC(30,8)) AS INCOME_MONEY,
CAST(WorkLoad_OEORI_DR -> OEORI_Priority_DR -> OECPR_Desc AS VARCHAR(20) ) AS RECIPE_TYPE_CODE,
CAST(
	CASE 
		WHEN EXISTS(SELECT * FROM sqluser.PA_Adm WHERE PAADM_DischgDate IS NOT NULL AND PAADM_RowID = WorkLoad_PAADM_DR) THEN WorkLoad_PAADM_DR-> PAADM_DepCode_DR -> CTLOC_Desc
		ELSE 'Null'
	END
AS VARCHAR(20) ) AS PLACE,
CAST(WorkLoad_PatDep_DR -> CTLOC_Hospital_DR AS VARCHAR(20) ) AS Hosp_Code
FROM sqluser.DHC_WorkLoad
WHERE WorkLoad_Type = 'I' AND web_HRPInterface_DHCWL.GetWlDetail_GetImType(WorkLoad_ItemOrd_DR) = 'Material'
GROUP BY WorkLoad_PAADM_DR,WorkLoad_OrdDate,WorkLoad_PatDep_DR,WorkLoad_RecDep_DR,WorkLoad_TarItem_DR,WorkLoad_OEORI_DR -> OEORI_Priority_DR -> OECPR_Desc
}

/// Creator：       ET
/// CreatDate：     2021-07-27
/// Description:：  3.9.1.10. 药品医嘱
/// Table：         HTCG_DRUG_ADVICE_VIEW
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.HTCG_DRUG_ADVICE_VIEW
Query DRUGView() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = HTCG_DRUG_ADVICE_VIEW ]
{
SELECT
CAST(web_HRPInterface_DHCWL.GetWlDetail_GetPapmiMedtare(WorkLoad_PAPMI_DR) AS VARCHAR(20) ) AS MR_NO,
CAST(WorkLoad_PAADM_DR AS VARCHAR(20) ) AS IN_HOS_NO,
CAST(WorkLoad_OrdDate AS CHAR(10)) AS ADVICE_DATE, 
CAST(WorkLoad_PatDep_DR AS VARCHAR(20) ) AS ORDER_BY_CODE,
CAST(WorkLoad_RecDep_DR AS VARCHAR(20) ) AS PERFORM_BY_CODE,
CAST(WorkLoad_TarItem_DR AS VARCHAR(20) )AS CHARGE_ITEM_CODE,
CAST(sum(WorkLoad_Quantity) AS NUMERIC(30,8)) AS AMOUNT,
CAST(WorkLoad_UnitPrice AS NUMERIC(30,8)) AS PRICE,
CAST(sum(WorkLoad_TotalPrice) AS NUMERIC(30,8)) AS INCOME_MONEY,
CAST(WorkLoad_OEORI_DR -> OEORI_Priority_DR -> OECPR_Desc AS VARCHAR(20) ) AS RECIPE_TYPE_CODE,
CAST(
	CASE 
		WHEN EXISTS(SELECT * FROM sqluser.PA_Adm WHERE PAADM_DischgDate IS NOT NULL AND PAADM_RowID = WorkLoad_PAADM_DR) THEN WorkLoad_PAADM_DR-> PAADM_DepCode_DR -> CTLOC_Desc
		ELSE 'Null'
	END
AS VARCHAR(20) ) AS PLACE,
CAST(WorkLoad_PatDep_DR -> CTLOC_Hospital_DR AS VARCHAR(20) ) AS Hosp_Code
FROM sqluser.DHC_WorkLoad
WHERE WorkLoad_Type = 'I' AND web_HRPInterface_DHCWL.GetWlDetail_GetImType(WorkLoad_ItemOrd_DR) = 'Drug'
GROUP BY WorkLoad_PAADM_DR,WorkLoad_OrdDate,WorkLoad_PatDep_DR,WorkLoad_RecDep_DR,WorkLoad_TarItem_DR,WorkLoad_OEORI_DR -> OEORI_Priority_DR -> OECPR_Desc
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  通过PA_ADM ADM_ROWID得到病人住院号(病案号)
/// Table：         PA_PATMAS PA_ADM
/// Input：         ADM_ROWID
/// Output：        住院号(病案号)
/// Return：        
/// Others：         web_HRPInterface_DHCWL.GetWlDetail_GetPapmiMedtare()
ClassMethod GetPapmiMedtare(admId As %String) As %String [ SqlProc ]
{
 q:$g(admId)="" "Null"
 q:'$d(^PAADM(admId)) "Null"
 s iPatNo=$p(^PAADM(admId),"^",1)	
 q:$g(iPatNo)="" "Null"
 q:'$d(^PAPER(iPatNo,"PAT",1)) "Null"
 s oMdtrNo=$p($g(^PAPER(iPatNo,"PAT",1)),"^",22)
 i (oMdtrNo="")||(oMdtrNo="0") s oMdtrNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId)
 q:oMdtrNo="" "Null"
 q $g(oMdtrNo)
}

/// Creator：       PL
/// CreatDate：     2018-05-10
/// Description:：  
/// Table：         
/// Input：         
/// Output：        
/// Return：  
/// web_HRPInterface_DHCWL.GetWlDetail_GetImType()
ClassMethod GetImType(arcimid) As %Library.String [ SqlProc ]
{
 s desc=""	
 q:'$d(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1))) "treatment"	
 s inci="" f  s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),inci) ) q:(inci="")||(desc'="")  d
 .s desc=..GetIncStkCatGrp(inci)
 q $g(desc)
}

/// Creator:	zhouyonggang
/// CreatDate:	2011-03-16
/// Description:获得库存项的类组信息
/// Table:		INC_Itm，DHC_StkCatGrpRelations
/// Input:		库存项ID
/// Return:		类组代码^类组描述^类组类型
ClassMethod GetIncStkCatGrp(inci) As %Library.String [ SqlProc ]
{
	Q:inci="" ""
	Q:'$d(^INCI(inci,2)) ""
	s inccat=$p(^INCI(inci,2),"^",2)
	q:inccat="" ""
	s scg=$o(^DHCSCG("STKCAT",inccat,""))
	q:scg="" ""
	s scgdesc=$p(^DHCSCG(scg),"^",2)
	s scgcode=$p(^DHCSCG(scg),"^",1)
	s scgtype=$p(^DHCSCG(scg),"^",3)
	S scgtypeDesc=""
	S scgtypeDesc=..stktypeDesc(scgtype)
	s scgset=$p(^DHCSCG(scg),"^",5)
	s scgstrumodeflag=$p(^DHCSCG(scg),"^",7)
	q $g(scgtypeDesc)
}

/// 库存类型名称
/// Author:zhwh
/// Date:2013-04-27
/// Argu: 
///  type - 库存类型代码值
/// Return:
///   库存类型名称
ClassMethod stktypeDesc(scgtype As %String) As %String [ SqlProc ]
{
 I scgtype="G" q "Drug"
 I scgtype="M" q "Material"
 q "Other"
}

/// --------------------------------------------------------成本核算接口-----------------------------------------------------
/// Creator：       ET
/// CreatDate：     2021-07-20
/// Description:：  自费病人住院证数量(医生自费病人表)
/// Table：         treat_patients
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.treat_patients
Query treatpatients() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = treat_patients ]
{
SELECT 
CAST(book.CreateDate AS CHAR(10)) AS date1,
count(book.IsActive) AS treat_num,
loc.CTLOC_RowID AS DeptCode,
loc.CTLOC_Desc AS DeptName,
ss.SSUSR_CareProv_DR  AS doctor_code,
ss.SSUSR_CareProv_DR -> CTPCP_Desc AS doctor_Name
--book.EpisodeIDTo AS admTo,
--book.EpisodeIDFrom AS admForm,
--(SELECT TOP 1 subrea.REA_Desc 
--FROM DHC_PatientBill AS bill 
--LEFT JOIN PAC_AdmReason AS subrea ON bill.PB_PatInsType_DR = subrea.REA_RowId 
--WHERE bill.PB_Adm_Dr = book.EpisodeIDTo 
--ORDER BY bill.PB_RowId DESC),
FROM sqluser.DHCDocIPBooking AS book
LEFT JOIN sqluser.SS_User AS ss ON book.CreateDocID = ss.SSUSR_RowId
LEFT JOIN sqluser.CT_Loc AS loc ON book.Text3 = loc.CTLOC_RowID
WHERE IsActive='Y' AND book.EpisodeIDTo IS NOT NULL 
AND (SELECT TOP 1 subrea.REA_Desc 
FROM sqluser.DHC_PatientBill AS bill 
LEFT JOIN sqluser.PAC_AdmReason AS subrea ON bill.PB_PatInsType_DR = subrea.REA_RowId 
WHERE bill.PB_Adm_Dr = book.EpisodeIDTo 
ORDER BY bill.PB_RowId DESC) LIKE  '%自费%'
GROUP BY CreateDate,ss.SSUSR_CareProv_DR,loc.CTLOC_RowID
}

/// Creator：       ET
/// CreatDate：     2021-07-20
/// Description:：  住院工作量（科室）
/// Table：         Inpatient_workload
/// Input：         
/// Output：       
/// Return：        
/// Others：       select * from web_HRPInterface_DHCWL.Inpatient_workload
Query inoroutworkload() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = Inpatient_workload ]
{
SELECT 
CAST(YEAR(MRIP_date) || to_char(MRIP_date,'MM')  AS VARCHAR(20)) AS APHI_YEAR_MONTH,
CAST(MRIP_loc_dr AS VARCHAR(8)) AS APHI_DEPT_CODE,
CAST(MRIP_loc_dr -> CTLOC_Desc  AS VARCHAR(200)) AS APHI_DEPT_NAME,
(
SELECT
cast (sum(DATEDIFF('d',IPDE_PAADM_Dr-> PAADM_AdmDate,IPDE_PAADM_Dr-> PAADM_DischgDate)) / count(IPDE_Type) as NUMERIC(18,2))
from sqluser.DHC_MRIPDetail where IPDE_Type = 'CYRS' and IPDE_MRIPDay_Dr = MRIP_rowid 
) as APHI_AVG_IN_DAY,
CAST (
case 
WHEN SUM (web_HRPInterface_DHCWL.GetWlDetail_BedNum(MRIP_date,"Loc",MRIP_loc_dr)) <> 0   THEN sum(MRIP_XYRS)/ SUM (web_HRPInterface_DHCWL.GetWlDetail_BedNum(MRIP_date,"Loc",MRIP_loc_dr))
ELSE 0 
END 
as NUMERIC(18,2))  as APHI_BED_USE_RATE
FROM  sqluser.DHCMRIPDay  where MRIP_loc_dr is NOT NULL 
GROUP BY MRIP_loc_dr,YEAR(MRIP_date) || to_char(MRIP_date,'MM')
}

/// web_HRPInterface_DHCWL.GetWlDetail_BedNum("65064","Loc","96")
ClassMethod BedNum(Date, LocOrWardFlag, LocOrWardId) As %String [ SqlProc ]
{
 s MRRowId=""
 s Return=0
 i $d(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId))  d
 .s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One
 e  d
 .s Date=$o(^DHCMRBed(0,LocOrWardFlag,LocOrWardId,"Date",Date),-1)
 .i Date'="" s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One Or No Exist
 q:MRRowId="" Return
 s MRGDNum=$p(^DHCMRBed(MRRowId),"^",3)
 s MRSYNum=$p(^DHCMRBed(MRRowId),"^",4)
 s MRBZNum=$p(^DHCMRBed(MRRowId),"^",5)
 s Return=MRGDNum  ;_"^"_MRSYNum_"^"_MRBZNum
 q Return
}

/// d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("select * from web_HRPInterface_DHCWL.COST_CHARGE_I_VIEW WHERE orddate  BETWEEN '2021-06-01' AND '2021-06-02'")
/// d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("MDR","select * from ct_loc")
ClassMethod jdbcGetDate(jdbcGatewayCode, sql)
{
	k ^TMPDHCWL($j)
	#dim %JDBCGateway as %Net.Remote.Java.JDBCGateway
   	s gc=$$GetJConnection^%apiGTW(jdbcGatewayCode)
    i gc="" QUIT "-1^"_$$$ERROR($$$GTWCConnectionError)
    s stat=%JDBCGateway.prepareStatement(gc,sql)
    if (stat < 0) {
    	q "-1^"_%JDBCGateway.getErrorText()
  	}
    s sqlerr=%JDBCGateway.execQuery(stat)
    if sqlerr<0{
    	q "-1^"_%JDBCGateway.getErrorText()
    }
    s colCount=%JDBCGateway.getColumnCount(stat)
	s nextFlag=%JDBCGateway.next(stat)
	s num=0
	while nextFlag = 1 {
		for i=1:1:colCount {
	    	s columnName=%JDBCGateway.getColumnName(stat,i)
	    	s fieldValue=%JDBCGateway.getString(stat,i)
	    	i $g(^TMPDHCWL($j,"CS",num))=""  d
	    	.s ^TMPDHCWL($j,"CS",num)=fieldValue
	    	e  d
	    	.s ^TMPDHCWL($j,"CS",num)=$g(^TMPDHCWL($j,"CS",num))_"^"_fieldValue
	    	;w columnName_"="_fieldValue_"  ",!
	    }
	    s num=$g(num)+1
	    s nextFlag=%JDBCGateway.next(stat)
	    ;w !
	}
	;k ^TMPDHCWL($j)
}

/// ----------------------------------------------------------------------------------------------------------------------------------------------------------------
Query HTCGDRUGADVICEVIEW(startDate As %String, endDate As %String) As %Query(ROWSPEC = "MR_NO,IN_HOS_NO,ADVICE_DATE,ORDER_BY_CODE,PERFORM_BY_CODE,CHARGE_ITEM_CODE,AMOUNT,PRICE,INCOME_MONEY,RECIPE_TYPE_CODE,PLACE") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    3.9.1.10药品医嘱(HTCG_DRUG_ADVICE_VIEW) 
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","HTCGDRUGADVICEVIEW","2021-07-30","2021-07-30")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTINHOSWORKVIEWMDR("2021-06-01","2021-06-02")
ClassMethod HTCGDRUGADVICEVIEWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 s sql="select * from web_HRPInterface_DHCWL.HTCG_DRUG_ADVICE_VIEW WHERE querydate  BETWEEN "_"'"_startDate_"'"_" AND "_"'"_endDate_"'"
 d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("HisToMdr",sql)
 
 s all=""  f  s all=$o(^TMPDHCWL($j,"CS",all))  q:all=""  d
 .s list=$g(^TMPDHCWL($j,"CS",all))
 .s str1=$p(list,"^",1)
 .s str2=$p(list,"^",2)
 .s str3=$p(list,"^",3)
 .s str4=$p(list,"^",4)
 .s str5=$p(list,"^",5)
 .s str6=$p(list,"^",6)
 .s str7=$p(list,"^",7) 
 .s str8=$p(list,"^",8)
 .s str9=$p(list,"^",9)
 .s str10=$p(list,"^",10)
 .&sql(SELECT  OEORI_Priority_DR -> OECPR_Desc into :str10  FROM OE_OrdItem where OEORI_RowId = :str10)
 .s str11=$p(list,"^",11)
 .d OutputRow
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(str1,str2,str3,str4,str5,str6,str7,str8,str9,str10,str11)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod HTCGDRUGADVICEVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HTCGDRUGADVICEVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod HTCGDRUGADVICEVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HTCGDRUGADVICEVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query HTCGMATERIALADVICEVIEW(startDate As %String, endDate As %String) As %Query(ROWSPEC = "MR_NO,IN_HOS_NO,ADVICE_DATE,ORDER_BY_CODE,PERFORM_BY_CODE,CHARGE_ITEM_CODE,AMOUNT,PRICE,INCOME_MONEY,RECIPE_TYPE_CODE,PLACE") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    3.9.1.11材料医嘱(HTCG_MATERIAL_ADVICE_VIEW)
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","HTCGDRUGADVICEVIEW","2021-07-30","2021-07-30")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTINHOSWORKVIEWMDR("2021-06-01","2021-06-02")
ClassMethod HTCGMATERIALADVICEVIEWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 s sql="select * from web_HRPInterface_DHCWL.HTCG_MATERIAL_ADVICE_VIEW WHERE querydate  BETWEEN "_"'"_startDate_"'"_" AND "_"'"_endDate_"'"
 d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("HisToMdr",sql)
 
 s all=""  f  s all=$o(^TMPDHCWL($j,"CS",all))  q:all=""  d
 .s list=$g(^TMPDHCWL($j,"CS",all))
 .s str1=$p(list,"^",1)
 .s str2=$p(list,"^",2)
 .s str3=$p(list,"^",3)
 .s str4=$p(list,"^",4)
 .s str5=$p(list,"^",5)
 .s str6=$p(list,"^",6)
 .s str7=$p(list,"^",7) 
 .s str8=$p(list,"^",8)
 .s str9=$p(list,"^",9)
 .s str10=$p(list,"^",10)
 .&sql(SELECT  OEORI_Priority_DR -> OECPR_Desc into :str10  FROM OE_OrdItem where OEORI_RowId = :str10)
 .s str11=$p(list,"^",11)
 .d OutputRow
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(str1,str2,str3,str4,str5,str6,str7,str8,str9,str10,str11)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod HTCGMATERIALADVICEVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HTCGMATERIALADVICEVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod HTCGMATERIALADVICEVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HTCGMATERIALADVICEVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query HTCGMEDICALADVICEVIEW(startDate As %String, endDate As %String) As %Query(ROWSPEC = "MR_NO,IN_HOS_NO,ADVICE_DATE,ORDER_BY_CODE,PERFORM_BY_CODE,CHARGE_ITEM_CODE,AMOUNT,PRICE,INCOME_MONEY,RECIPE_TYPE_CODE,PLACE") [ SqlProc ]
{
}

/// Creator：       ET
/// CreatDate：     2019-11-21
/// Description:    3.9.1.9诊疗医嘱(HTCG_MEDICAL_ADVICE_VIEW)
/// Table：         
/// Input：               
/// Output：            
/// Return：        
/// 
/// *d ##class(%ResultSet).RunQuery("web.HRPInterface.DHCWL.GetWlDetail","HTCGMEDICALADVICEVIEW","2021-07-30","2021-07-30")  */
/// call web_HRPInterface_DHCWL.GetWlDetail_COSTINHOSWORKVIEWMDR("2021-06-01","2021-06-02")
ClassMethod HTCGMEDICALADVICEVIEWExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 s sql="select * from web_HRPInterface_DHCWL.HTCG_MEDICAL_ADVICE_VIEW WHERE querydate  BETWEEN "_"'"_startDate_"'"_" AND "_"'"_endDate_"'"
 d ##class(web.HRPInterface.DHCWL.GetWlDetail).jdbcGetDate("HisToMdr",sql)
 
 s all=""  f  s all=$o(^TMPDHCWL($j,"CS",all))  q:all=""  d
 .s list=$g(^TMPDHCWL($j,"CS",all))
 .s str1=$p(list,"^",1)
 .s str2=$p(list,"^",2)
 .s str3=$p(list,"^",3)
 .s str4=$p(list,"^",4)
 .s str5=$p(list,"^",5)
 .s str6=$p(list,"^",6)
 .s str7=$p(list,"^",7) 
 .s str8=$p(list,"^",8)
 .s str9=$p(list,"^",9)
 .s str10=$p(list,"^",10)
 .&sql(SELECT  OEORI_Priority_DR -> OECPR_Desc into :str10  FROM OE_OrdItem where OEORI_RowId = :str10)
 .s str11=$p(list,"^",11)
 .d OutputRow
 k ^||TMPDHCWL($j),^TMPDHCWL($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
	set Data=$lb(str1,str2,str3,str4,str5,str6,str7,str8,str9,str10,str11)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod HTCGMEDICALADVICEVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HTCGMATERIALADVICEVIEWExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod HTCGMEDICALADVICEVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HTCGMATERIALADVICEVIEWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
