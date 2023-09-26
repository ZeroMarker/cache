/// 名称: DHCWMR.Base.MRAdm
/// 描述: 就诊病历表(Mr_Adm)的业务封装，定义常用属性和方法
/// 编写者：liyi
/// 编写日期: 2014-09-05
Class DHCWMR.Base.MRAdm Extends (%Persistent, DHCWMR.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 就诊病例Id  MRADM_RowId
Property Rowid As %Integer;

/// 就诊指针 MRADM_ADM_DR
Property AdmDr As %Integer;

/// 出院状态指针 MRADM_ConditAtDisch_DR 指向PAC_DischCondit
Property ConditAtDischDr As %Integer;

/// 出院状态代码 DISCON_Code
Property DISCONCode As %String(TRUNCATE = 1);

/// 出院状态描述 DISCON_Desc
Property DISCONDesc As %String(TRUNCATE = 1);

/// 出院状态开始日期 DISCON_DateFrom
Property DISCONDateFrom As %String(TRUNCATE = 1);

/// 病人状态指针 MRADM_PatCond_DR 指向MRC_PatientCondition
Property PatCondDr As %Integer;

/// 病人状态代码 COND_Code
Property CONDCode As %String(TRUNCATE = 1);

/// 病人状态描述 COND_Desc
Property CONDDesc As %String(TRUNCATE = 1);

/// 病人状态有效开始日期 COND_DateFrom
Property CONDDateFrom As %String(TRUNCATE = 1);

/// 体重 MRADM_Weight
Property Weight As %String(TRUNCATE = 1);

/// 身高 MRADM_Height
Property Height As %String(TRUNCATE = 1);

/// 病人去向 MRADM_DischDestin_DR 指向PAC_DischargeDestination
Property DischDestinDr As %Integer;

/// 治疗情况 MRADM_DischType_DR 指向CT_Disposit
Property DischTypeDr As %Integer;

/// 慢病标志 MRADM_GPConsent Y:是
Property GPConsent As %Boolean;

/// 就诊发病日期 MRADM_OnsetDate
Property OnsetDate As %Library.Date;

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  将对象格式化为字符串
/// Table：       Mr_Adm
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:AdmDr 3:ConditAtDischDr 4:PatCondDr 5:Weight 6:Height 7:DischDestinDr 
/// 			  8:DischTypeDr 9:GPConsent 10:OnsetDate 11:DISCONCode 12:DISCONDesc 13:DISCONDateFrom
/// 				  14:CONDCode 15:CONDDesc 16:CONDDateFrom
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..AdmDr_separete_..ConditAtDischDr_separete_..PatCondDr_separete_..Weight
	set return=return_separete_..Height_separete_..DischDestinDr
	set return=return_separete_..DischTypeDr_separete_..GPConsent_separete_..OnsetDate
	set return=return_separete_..DISCONCode_separete_..DISCONDesc_separete_..DISCONDateFrom
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  根据Mr_Adm.MRADM_RowId取就诊病历信息
/// Table：       Mr_Adm
/// Input：       MrAdmId:   Mr_Adm.MRADM_RowId
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(MrAdmId As %String) As DHCWMR.Base.MRAdm
{
	new (MrAdmId)
	set return=""
	quit:MrAdmId="" return
	quit:'$d(^MR(+MrAdmId)) return
	set obj=##Class(DHCWMR.Base.MRAdm).%New()
	set obj.Rowid=+MrAdmId
	set obj.AdmDr=$p($g(^MR(+MrAdmId,"PRO",1)),"^",9)	 	 		// 就诊指针 MRADM_ADM_DR
	set obj.ConditAtDischDr=$p($g(^MR(+MrAdmId,"PRO",10)),"^",2)   	 // 出院状态指针 MRADM_ConditAtDisch_DR
	set obj.DISCONCode=$p($g(^PAC("DISCON",+obj.ConditAtDischDr)),"^",1)   	 // 出院状态代码 DISCON_Code
	set obj.DISCONDesc=$p($g(^PAC("DISCON",+obj.ConditAtDischDr)),"^",2)   	 // 出院状态描述 DISCON_Desc
	set obj.DISCONDateFrom=$p($g(^PAC("DISCON",+obj.ConditAtDischDr)),"^",4)   	 // 出院状态开始日期 DISCON_DateFrom
	set obj.PatCondDr=$p($g(^MR(+MrAdmId,"PRO",1)),"^",40)   // 病人状态指针 MRADM_PatCond_DR
	set obj.Weight=$p($g(^MR(+MrAdmId,"PRO",1)),"^",27)	 	 // 体重 MRADM_Weight
	set obj.Height=$p($g(^MR(+MrAdmId,"PRO",1)),"^",20)   	 // 身高 MRADM_Height
	set obj.DischDestinDr=$p($g(^MR(+MrAdmId,"PRO",1)),"^",51)   // 病人去向 MRADM_DischDestin_DR
	set obj.DischTypeDr=$p($g(^MR(+MrAdmId,"PRO",1)),"^",11)	 	 // 治疗情况 MRADM_DischType_DR
	set obj.GPConsent=$p($g(^MR(+MrAdmId,"PRO",1)),"^",82)   	 // 慢病标志 MRADM_GPConsent
	set obj.OnsetDate=$p($g(^MR(+MrAdmId,"PRO",1)),"^",68)   // 就诊发病日期 MRADM_OnsetDate
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  根据Mr_Adm.MRADM_RowId取就诊病历信息
/// Table：       Mr_Adm
/// Input：       MrAdmId    Mr_Adm.MRADM_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCWMR.Base.MRAdm).GetStringById(1)
ClassMethod GetStringById(MrAdmId As %String, separete As %String) As %String
{
	new (MrAdmId,separete)
	set return=""
	set obj=..GetObjById(MrAdmId)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  根据paadm取就诊病历信息
/// Table：       Mr_Adm、PA_Adm
/// Input：       paadm    PA_Adm.PAADM_RowID  
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCWMR.Base.MRAdm).GetByPaadm(1)
ClassMethod GetByPaadm(paadm) As %String
{
	new (paadm)
	set return=""
	quit:+paadm="" return
	quit:'$d(^PAADM(+paadm)) return
	set PAADMMainMRADMDR=$p(^PAADM(+paadm),"^",61)
	set return=..GetStringById(PAADMMainMRADMDR,"")
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  根据paadm取就诊病历信息
/// Table：       Mr_Adm、PA_Adm
/// Input：       paadm    PA_Adm.PAADM_RowID  
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCWMR.Base.MRAdm).GeObjtByPaadm(1)
ClassMethod GeObjtByPaadm(paadm) As %String
{
	new (paadm)
	set return=""
	quit:+paadm="" return
	quit:'$d(^PAADM(+paadm)) return
	set PAADMMainMRADMDR=$p(^PAADM(+paadm),"^",61)
	set return=..GetObjById(PAADMMainMRADMDR)
	quit return
}

}
