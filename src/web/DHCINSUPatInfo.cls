Import SQLUser

Class web.DHCINSUPatInfo Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 115;

// 通过papatmas的rowid得到病人信息

// DingSH 20200526 增加入参院区

ClassMethod GetPatInfoByPatID(PatID, HospDr) As %String
{
 n (PatID,HospDr)
 q:PatID="" -100
 s OutStr=""
 s OutStr=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospDr)
 i OutStr>0  d
 .s GetPatInfoByPatID="1!"_OutStr
 e     d
 .s GetPatInfoByPatID="-1!"_OutStr
 q GetPatInfoByPatID
}

// 通过paadm的rowid得到病人就诊信息

// 注意：诊断信息和出院情况需要根据项目核实（程序需做相应改动），每个项目代码可能都不一样需要改动

/// modify 
///  修改1 增加费别指针 AdmReasonDR:Pac_AdmReason.Rowid 20230221  DingSH 
///        AdmReasonDR="" 的时候取就诊表上面的费别
ClassMethod GetAdmInfoByAdmID(AdmID, AdmReasonDR As %String = "") As %String
{
 n (AdmID,AdmReasonDR)
 q:AdmID="" -100
 s OutStr=""
 // q AdmID
 s OutStr=$$GetAdmInfoByAdmID^DHCINSUPatInfo(AdmID,AdmReasonDR)
 i OutStr>0  d
 .s GetAdmInfoByAdmID="1!"_OutStr
 e     d
 .s GetAdmInfoByAdmID="-1!"_OutStr
 q GetAdmInfoByAdmID
}

/// 描述： 通过paadm的rowid和扩展串得到病人就诊信息
/// 入参：AdmID:Pa_Adm.Rowid, ExpStr:Pac_AdmReason.Rowid^InsuType
/// 出参：-100,或-1!错误代码,或成功时：1^就诊信息串
/// w ##class(web.DHCINSUPatInfo).GetAdmInfoByAdmIDExp(2195,1)
/// 注意：诊断信息和出院情况需要根据项目核实（程序需做相应改动），每个项目代码可能都不一样需要改动
/// DingSH 20180316
ClassMethod GetAdmInfoByAdmIDExp(AdmID, ExpStr) As %String
{
 n (AdmID,ExpStr)
 q:AdmID="" -100
 s OutStr=""
 // q AdmID
 s OutStr=$$GetAdmInfoByAdmIDAndExp^DHCINSUPatInfo(AdmID,ExpStr)
 i OutStr>0  d
 .s GetAdmInfoByAdmIDExp="1!"_OutStr
 e     d
 .s GetAdmInfoByAdmIDExp="-1!"_OutStr
 q GetAdmInfoByAdmIDExp
}

// 根据登记号获取病人基本信息

// DingSH 20200526 增加入参HospDr

ClassMethod GetPatInfoByPatNO(PatNO, HospDr) As %String
{
 n (PatNO,HospDr)
 q:PatNO="" -100
 s PatID=$$GetPapmiIDByPatNo^DHCINSUPatInfo(PatNO)
 ;q PatID
 q:PatID<0 -100
 s OutStr=""
 s OutStr=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospDr)
 i OutStr>0  d
 .s GetPatInfoByPatNO="1!"_OutStr
 e     d
 .s GetPatInfoByPatNO="-1!"_OutStr
 q GetPatInfoByPatNO
}

// 根据AdmID获取病人基本信息

ClassMethod GetPatInfoByAdm(AdmID) As %String
{
 n (AdmID)
 q:AdmID="" -100
 s PatID=$$GetPatidByAdm^DHCINSUPatInfo(AdmID)
 ;q PatID
 q:PatID<0 -100
 s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmID) //+ DingSH 20200526
 q:+HospDr<=0 -100
 s OutStr=""
 s OutStr=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospDr)
 i OutStr>0  d
 .s GetPatInfoByAdm="1!"_OutStr
 e     d
 .s GetPatInfoByAdm="-1!"_OutStr
 q GetPatInfoByAdm
}

// 根据帐单ID获取病人基本信息

ClassMethod GetPatInfoByBill(Bill) As %String
{
 
 n (Bill)
 s AdmID=""
 s AdmID=$$GetAdmByBill^DHCINSUPatInfo(Bill)
 q:AdmID="" -100
 s PatID=$$GetPatidByAdm^DHCINSUPatInfo(AdmID)
 ;q PatID
 q:PatID<0 -100
 s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmID) //+ DingSH 20200526
 q:+HospDr<=0 -100
 s OutStr=""
 s OutStr=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospDr)
 i OutStr>0  d
 .s GetPatInfoByAdm="1!"_OutStr
 e     d
 .s GetPatInfoByAdm="-1!"_OutStr
 q GetPatInfoByAdm
}

// 根据INVPRT表ID获取病人基本信息

ClassMethod GetPatInfoByInvprt(InvprtDr) As %String
{
	
 n (InvprtDr)
 q:InvprtDr="" -100
 s Bill=$$GetBillDrByPRTINVDR^DHCINSUFacade(InvprtDr)
 q:Bill="" -100
 s AdmID=$$GetAdmByBill^DHCINSUPatInfo(Bill)
 q:AdmID="" -100
 s PatID=$$GetPatidByAdm^DHCINSUPatInfo(AdmID)
 q:PatID<0 -100
 s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmID) //+ DingSH 20200526
 q:+HospDr<=0 -100
 s OutStr=""
 s OutStr=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospDr)
 i OutStr>0  d
 .s GetPatInfoByAdm="1!"_OutStr
 e     d
 .s GetPatInfoByAdm="-1!"_OutStr
 q GetPatInfoByAdm
}

// 根据账单ID获取病人本次就诊信息

ClassMethod GetAdmInfoByBill(Bill) As %String
{
 n (Bill)
 q:Bill="" -100
 s AdmID=$$GetAdmByBill^DHCINSUPatInfo(Bill)
 ;q AdmID
 q:AdmID<0 -100
 s OutStr=""
 s OutStr=$$GetAdmInfoByAdmID^DHCINSUPatInfo(AdmID)
 i OutStr>0  d
 .s GetAdmInfoByBill="1!"_OutStr
 e     d
 .s GetAdmInfoByBill="-1!"_OutStr
 q GetAdmInfoByBill
}

// 根据AdmID获取病人账单串

ClassMethod GetBillListByAdm(AdmID) As %String
{
 n (AdmID)
 q:AdmID="" -100
 s OutStr=""
 s OutStr=$$GetBillListByAdm^DHCINSUPatInfo(AdmID)
 i OutStr>0  d
 .s GetBillListByAdm="1!"_OutStr
 e     d
 .s GetBillListByAdm="-1!"_OutStr
 q GetBillListByAdm
}

// 根据Pa_Patmas表的Rowid获取病人就诊信息集合

ClassMethod GetAdmInfoByPatNO(PatId, Type, StrDate) As %String
{
 n (PatId,Type,StrDate)
 q:PatId="" -100
 s OutStr=""
 s OutStr=$$GetAdmInfoByPatNO^DHCINSUPatInfo(PatId,Type,StrDate)
 ;i OutStr>0  d
 ;.s GetBillListByAdm="1!"_OutStr
 ;e     d
 ;.s GetBillListByAdm="-1!"_OutStr
 q OutStr
}

// 根据进程号，和序号去病人就诊信息

ClassMethod GetAdmInfoCacheTmpInsu(ID, i) As %String
{
 s OutStr=$$GetAdmInfoByTmp^DHCINSUPatInfo(ID, i)
 q OutStr
}

ClassMethod GetAdmInfoByRegFeeDr(strRegFeeDr) As %String
{
 ;n (strRegFeeDr)
 q:strRegFeeDr="" -100
 &sql(SELECT RegfeeAdmDr into :RegfeeAdmDr FROM DHCRegistrationfee WHERE ID=:strRegFeeDr)
 s AdmID=RegfeeAdmDr
 ;q AdmID
 q:AdmID<0 -100
 s OutStr=""
 s OutStr=$$GetAdmInfoByAdmID^DHCINSUPatInfo(AdmID)
 i OutStr>0  d
 .s GetAdmInfoByBill="1!"_OutStr
 e     d
 .s GetAdmInfoByBill="-1!"_OutStr
 q GetAdmInfoByBill
}

ClassMethod GetAdmInfoByInvprtDr(strInvPrtDr) As %String
{
 n (strInvPrtDr)
 q:strInvPrtDr="" -100
 s Bill=$$GetBillDrByPRTINVDR^DHCINSUFacade(strInvPrtDr)
 s AdmID=$$GetAdmByBill^DHCINSUPatInfo(Bill)
 ;q AdmID
 q:AdmID<0 -100
 s OutStr=""
 s OutStr=$$GetAdmInfoByAdmID^DHCINSUPatInfo(AdmID)
 i OutStr>0  d
 .s GetAdmInfoByBill="1!"_OutStr
 e     d
 .s GetAdmInfoByBill="-1!"_OutStr
 q GetAdmInfoByBill
}

/// Creator: 	  yangjianzhang 
/// CreatDate：	  2009-09-30
/// Description:  通过AdmNo得到病人人员类别
/// Table:		  PA_ADM
/// Input:		  AdmNo-就诊号
/// Output:		  
/// Return:		  人员类别
/// Others:		  No
/// w ##class(web.DHCINSUPatInfo).GetAdmReasonById(10)
ClassMethod GetAdmReasonById(ReaID) As %String
{
	n (ReaID)
	s OutStr="-1"
	q:(ReaID="") OutStr
	q:'$d(^PAC("ADMREA",ReaID)) OutStr
	s ReaInfo=$g(^PAC("ADMREA",ReaID))
	s ReaCode=$p(ReaInfo,"^",1)
	if $l(ReaCode)>4  d
	.s ReaCode=$e(ReaCode,5,6)
	s ReaDesc=$p(ReaInfo,"^",2)
	s ReaNationalCode=$p(ReaInfo,"^",5)
	s ReaAdmSource=$p(ReaInfo,"^",9)
	s OutStr="1"_"!"_ReaID_"^"_ReaCode_"^"_ReaDesc_"^"_ReaNationalCode_"^"_ReaAdmSource
	q OutStr
}

/// 通过papatmas的rowid得到病人信息
/// 医保报表类用(web.DHCINSUReport.cls)
/// ShwTypes 格:是否取病案|是否取年龄
/// DingSH  20200526 增加入参HospDr
ClassMethod GetPatInfoByPatIDRep(PatID, ShwTypes, HospDr) As %String
{
 n (PatID,ShwTypes,HospDr)
 q:PatID="" -100
 s OutStr=""
 s OutStr=$$GetPatInfoByPatIDRep^DHCINSUPatInfo(PatID,ShwTypes,HospDr)
 i OutStr>0  d
 .s GetPatInfoByPatIDRep="1!"_OutStr
 e     d
 .s GetPatInfoByPatIDRep="-1!"_OutStr
 q GetPatInfoByPatIDRep
}

/// 通过paadm的rowid得到病人就诊信息
/// 医保报表类用(web.DHCINSUZZRep.cls)
/// ShwTypes 格式:是否就诊时间|是否取出院时间|是否取诊断集合
ClassMethod GetAdmInfoByAdmIDRep(AdmID, ShwTypes) As %String
{
 n (AdmID,ShwTypes)
 q:AdmID="" -100
 s OutStr=""
 // q AdmID
 s OutStr=$$GetAdmInfoByAdmIDRep^DHCINSUPatInfo(AdmID,ShwTypes)
 i OutStr>0  d
 .s GetAdmInfoByAdmIDRep="1!"_OutStr
 e     d
 .s GetAdmInfoByAdmIDRep="-1!"_OutStr
 q GetAdmInfoByAdmIDRep
}

}
