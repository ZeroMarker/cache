Import SQLUser

/// Creator:	周永刚   
/// CreatDate:	2014-04-08
/// Description:与集成平台的接口,非业务性接口
/// ***************************已实现接口列表*****************************///
/// 1.用药监测相关接口
/// *********************************************************************///
Class web.DHCSTInterfacePH2 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:zdm
/// CreatDate:2009-07-10
/// Description:取摆药单相关信息
/// Input:开始日期，截止日期
/// Table:dhc_phacollected,dhc_phacollectitm,oe_orditem
/// OutPut:
/// Return:进程号
/// UpdateDate:20100706 zhouyg
ClassMethod CollectPhacInfo(startDate, endDate) As %String
{
}

/// Creator:zdm
/// CreatDate:2009-07-10
/// Description:取门诊处方相关信息
/// Input:开始日期，截止日期
/// Table:
/// OutPut:
/// Return:进程号
/// UpdateDate:20100706 zhouyg
ClassMethod CollectPhdInfo(startDate, endDate)
{
}

/// Creator:zhouyg
/// CreatDate:20100702
/// Description:取入库及库存信息(药物临床应用监测子系统信息项（中成药）)
/// Input:开始日期，截止日期,类组描述
/// Table:
/// OutPut:
/// Return:进程号
ClassMethod CollectIngrInfoZY(startDate, endDate, CatGrp)
{
}

/// Creator:zhouyg
/// CreatDate:20100702
/// Description:取入库及库存信息(药物临床应用监测子系统信息项（西药）)
/// Input:开始日期，截止日期,类组描述
/// Table:
/// OutPut:
/// Return:进程号
ClassMethod CollectIngrInfoXY(startDate, endDate, CatGrp)
{
}

/// Creater:	xiaohe
/// CreateDate:	2016-03-24
/// 参数：病人登记号 开始日期 截止日期 
/// 返回：处方号 处方明细 处方明细中要包含疗程信息 
/// w ##class(web.DHCSTInterfacePH2).GetPrescInfoByPerno("0003246767","2016-03-19","2016-03-20")
ClassMethod GetPrescInfoByPerno(perno As %String, StartDate As %String, EndDate As %String)
{
}

/// Creator:zdm
/// CreatDate:2009-07-10
/// Description:取库存项相关信息
/// Input:库存项rowid
/// Table:
/// OutPut:
/// Return:通用名^剂型^产地^给药途径（用法）
ClassMethod getInciInfo(inci)
{
}

/// Creator:zdm
/// CreatDate:2009-07-10
/// Description:计算所有科室的库存量
/// Input:库存项rowid
/// Table:
/// OutPut:
/// Return:库存量（基本单位）
ClassMethod getStockQty(inci, dateend)
{
}

ClassMethod getBarcode(inci)
{
}

ClassMethod UOMFac(fr, to)
{
}

ClassMethod ReturnedQty(phaci)
{
}

/// 从字符串ToStr按sDELIM分隔，查找是否包含FindStr
/// Return:1-包含,0-不包含
ClassMethod ChkList(FindStr, FromStr, sDELIM)
{
}

ClassMethod GetPatInfo(papmidr)
{
}

/// Creator:Zhouyg
/// CreatDate:2010-07-09
/// Description:取ICD
/// Table:PA_Adm,MR_Diagnos,MRC_ICDDx
/// Input:PA_Adm的rowid
/// Return:ICDCode1^ICDDesc1!ICDCode2^ICDDesc2……
/// w ##class(web.DHCSTInterfacePH2).GetMRDiagnos(2109)
ClassMethod GetMRDiagnos(admdr)
{
}

ClassMethod LastINGRI(inclb)
{
}

ClassMethod GetLastVendor(inclb)
{
}

/// Creator:Zhouyg
/// CreatDate:2010-05-28
/// Description:获得库存项的类组信息
/// Table:INC_Itm，DHC_StkCatGrpRelations
/// Input:库存项rowid
/// Return:类组描述
ClassMethod GetIncStkCatGrp(inci)
{
}

/// Creator:Zhouyg
/// CreatDate:2010-07-02
/// Description:取住院次数
/// Table:Pa_adm,PA_PatMas
/// Input:PA_PatMas的rowid
/// Return:RetNums-住院次数
ClassMethod GetInHospNums(PAPMIID)
{
}

/// Creator:Zhouyg
/// CreatDate:2010-07-02
/// Description:取医嘱的执行时间
/// Table:OE_OrdExec
/// Input:OE_OrdItem的rowid
/// Return:医嘱执行日期^医嘱执行时间^医嘱的执行天数
ClassMethod GetOrdInfo(Oeori)
{
}

/// Creator:Zhouyg
/// CreatDate:2010-07-02
/// Description:取药品的规格
/// Table:PHC_DrgForm,PHC_FormDoseEquiv,ARC_ItmMast
/// Input:ARC_ItmMast的rowid
/// Return:规格
ClassMethod GetPhSpec(Arcim)
{
}

/// Creator:Zhouyg
/// CreatDate:2010-07-02
/// Description:取医生的职称
/// Table:CT_CareProv,CT_CarPrvTp
/// Input:CT_CareProv的rowid
/// Return:医生工号^职称描述
ClassMethod GetCarPrvTp(CareProvID)
{
}

/// Description:去括号
ClassMethod GetDesc(PStr)
{
}

/// Description:获取医嘱状态,判断是否可以配药,药房,配液通用,适用于新版医嘱规则
/// Input:医嘱执行表ID
/// Output:0 不可配  1 可配
/// CreatDate:2012-02-23
/// Creator:LiangQiang
ClassMethod GetOrdState(OrdExeRowid)
{
}

/// 取医嘱执行天数(从开医嘱到现在的执行天数)
ClassMethod GetExDays(dspID)
{
}

}
