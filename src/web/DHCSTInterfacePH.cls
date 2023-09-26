Import SQLUser

/// Creator:周永刚   
/// CreatDate:2011-03-21
/// Description:摆药机相关接口,主要五个方法GetPhMain(住院发药主),GetPhDetail(住院发药明细),GetPhdMain(门诊发药主),GetPhdDetail(门诊发药明细),GetDrugBaseInfo(摆药机药品字典)
/// ***************************已实现接口列表*****************************///
/// 1.住院药房摆药机接口 GetPhMain(),GetPhDetail(),SendOrderToMechine()
/// 2.配液发药机接口GetPIVAMain(),GetPIVADetail(),
/// 3.同步药品字典数据GetDrugBaseInfo(),SendDrugInfo ()
/// 4.从第三方获取门诊处方发药窗口GetMachineWin()
/// 5.传门诊处方信息GetPrescInfoByOrd()
/// 6.门诊开始配药GetPrescInfoByOrd()
/// 7.门诊配药完成,接收第三方信息,完成东华配药过程 RecDataToInsertPHDisp()
/// *********************************************************************///
Class web.DHCSTInterfacePH Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCSTInterfacePH).GetPhMain("35728")
/// Descript：	住院发药主信息
/// Input:		phac-发药主表(DHC_PhaCollected)ID
/// Return:		字符串
ClassMethod GetPhMain(phac As %String) As %String
{
}

/// Author : MaYuqiang
/// Date Created : 20181029
/// Descript：	住院发药明细信息(医嘱改造之后)
/// Input:		phac-发药主表(DHC_PhaCollected)ID
/// Return:		字符串
/// w ##class(web.DHCSTInterfacePH).GetPhDetail(7241)
ClassMethod GetPhDetail(phac As %String) As %String
{
}

/// w ##class(web.DHCSTInterfacePH).GetPhdMain(45842)
/// Descript：	门诊发药主信息
/// Input:		phdID-发药主表(DHC_PHDISPEN)ID
/// Return:		字符串
ClassMethod GetPhdMain(phdID As %String) As %String
{
}

/// Descript：	门诊发药明细信息
/// Input:		phdID-发药主表(DHC_PHDISPEN)ID
/// Return:		字符串
/// Last modified by MaYuqiang 20181030 因医嘱改造修改，需遍历发药孙表获取药品信息
/// w ##class(web.DHCSTInterfacePH).GetPhdDetail(34)
ClassMethod GetPhdDetail(phdID As %String) As %String
{
}

/// Descript：	门诊处方信息
/// Input:		PrescNo-处方号
/// Return:		字符串 :  处方基本信息 || 医嘱信息1 @ 医嘱信息2
/// Creator: LiangQiang 2011-12-29
ClassMethod GetPrescInfoByOrd(PrescNo As %String, prt As %String = "")
{
}

/// Descript:获取摆药机药品字典
/// Input:类别
/// Creator: LiangQiang 2011-11-29
/// w ##class(web.DHCSTInterfacePH).GetDrugBaseInfo("G","01605")
ClassMethod GetDrugBaseInfo(CatDr, Code = "") As %String
{
}

/// Descript：	医嘱明细信息 (应用协和智能药柜)
/// Input:		医嘱Rowid , XFlag - 空: 只传停医嘱时间之前的医嘱  XFlag - 非空:只传停医嘱时间之后的医嘱
/// Return:		字符串
ClassMethod GetOrdItmDetail(OrdItem As %String, XFlag = "") As %String
{
}

/// 保存传送药柜的医嘱日志 (应用协和智能药柜)
/// Input:ATD 医嘱ID
ClassMethod SaveOrdItemForOM(warddr, pano, bedno, oeori, dsp) As %String
{
}

/// 在HIS中执行发药计费(应用于协和药柜)
/// Input:字符串
/// Output:0成功 非0失败
/// s Input="10594747^"50107"^62782^36295^PUSURG"
ClassMethod DispOrdItem(Input As %String) As %String
{
}

/// 更新药柜发药单条目数
ClassMethod UpdPhaCollectCnt(phacdr) As %String
{
}

/// 包药机同步药品基础数据
/// LiangQiang
ClassMethod SendDrugInfo() As %String
{
}

/// 发送医嘱信息至包药机
/// LiangQiang
ClassMethod SendOrderToMechine(phac) As %String
{
}

/// 维护哪些药品为药柜管理
/// LiangQiang
/// 03130^PUTEST^Y
ClassMethod SaveOmnicellItm(input) As %String
{
}

/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// ///////////////////上面为接口方法,下面为过程函数,请按此规则/////////////////////////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// Descript:取病人信息
/// Input:	PapmiID-病人ID
ClassMethod GetPatInfo(PapmiID As %String) As %String
{
}

/// Descript:根据就诊ID取病人ID
/// Input:	AdmID-就诊ID
ClassMethod GetPatID(AdmID As %String) As %String
{
}

/// Descript:取用户代码
ClassMethod GetUserCode(UserDr As %String) As %String
{
}

/// Descript:取用户名称
ClassMethod GetUserName(UserDr As %String) As %String
{
}

/// Descript:取科室名称
ClassMethod GetLocDesc(LocDr As %String) As %String
{
}

/// Descript:取病区名称
ClassMethod GetWardDesc(WardDr As %String) As %String
{
}

/// Descript:定义日期格式
ClassMethod SetDateFmt(DateH As %String) As %String
{
}

/// Descript:定义时间格式
ClassMethod SetTimeFmt(TimeH As %String) As %String
{
}

/// Descript:取年龄
ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
}

/// Descript:格式年龄
ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
}

/// Descript:取单位描述
ClassMethod GetUomDesc(UomDr As %String) As %String
{
}

/// Descript:根据医嘱项取计价单位
ClassMethod GetBillUom(arcim As %String) As %String
{
}

/// Descript:根据医嘱项取库存项
ClassMethod GetINCI(arcim As %String) As %String
{
}

/// Descript:根据库存项ID取库存项信息
ClassMethod GetINCIInfo(INCIID As %String) As %String
{
}

/// Descript:根据医嘱项取库存项信息
ClassMethod GetINCIByArcim(arcim As %String) As %String
{
}

/// Descript:频次时间信息(例如bid医嘱，返回"8:00,16:00")
ClassMethod GetFreqTime(freqDr As %String) As %String
{
}

ClassMethod Pid() As %String
{
}

/// Descript:取用药次数和用药时间
/// Input:	dodis-dhc_oedispensing
ClassMethod GetDspTimes(dodis As %String) As %String
{
}

/// Descript:取批号
ClassMethod GetBatNo(Inclb As %String) As %String
{
}

/// ---
/// Descript:取发票信息
ClassMethod GetPrtInv(PrtID As %String) As %String
{
}

/// Descript:取用户代码
ClassMethod GetUserCodeByPHP(PhpDr As %String) As %String
{
}

/// Descript:取用户名称
ClassMethod GetUserNameByPHP(PhpDr As %String) As %String
{
}

/// Descript:取科室名称
ClassMethod GetLocDescByPHL(PhlID As %String) As %String
{
}

/// 获得中草药信息 PA_Que1 
ClassMethod Getpaque(prescno As %String) As %String
{
}

/// Descript:获取库存项类组
/// Input:库存项ID
ClassMethod CatGrpType(inci) As %String
{
}

/// 剂量转成基本单位等效数量
/// LiangQiang
ClassMethod GetBuomDosage(oeori As %String) As %String
{
}

/// 发了几个频率的药
/// LiangQiang
ClassMethod GetPhDspDoTimeStr(phac, oeori) As %String
{
}

/// Creator:Liang Qiang
/// CreatDate:2009-06-30
/// Description:根据医嘱明细表rowid取开医嘱时的患者所在病
ClassMethod getOrdWard(OrdItmRowid) As %String
{
}

/// 取医嘱备注
/// LiangQiang
ClassMethod GetOrdNote(ord, itm)
{
}

/// 取厂家
/// LiangQiang
ClassMethod GetManfNameByInci(itmid As %String) As %String
{
}

/// 取频率时间串
/// LiangQiang
ClassMethod GetFreqTimeStr(freqdr)
{
}

/// 规格
ClassMethod getBarcode(inci) As %String
{
}

/// 取通用名
ClassMethod getGeneric(inci) As %String
{
}

/// 剂型
ClassMethod GetForm(inci As %String) As %String
{
}

/// 单位转换系统
ClassMethod UOMFac(fr As %String, to As %String) As %String
{
}

/// 取医嘱诊断
ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String) As %String
{
}

/// Description:取患者体重
ClassMethod GetPatWeight(paadm) As %String
{
}

ClassMethod GetOrdDoc(presc As %String, locdr) As %String
{
}

/// 获取处方收费日期
ClassMethod GetOrdPayDate(prt As %String) As %String
{
}

/// 处方发票配药记录ID
ClassMethod GetPhdrow(PrescNo, prt As %String) As %String
{
}

/// 处方发票配药记录
ClassMethod GetPhwin(PrescNo, prt As %String) As %String
{
}

/// 取发票中医嘱单价与金额
ClassMethod GetBasPriceByInv(prt, oeori)
{
}

/// 取处方接收科室
ClassMethod GetPrescNoRecloc(prescno)
{
}

/// 检查要求皮试的医嘱,是否进行了皮试并且皮试为阴性 >=0  皮试正常,< 0 皮试不正常 
ClassMethod SkinTest(oeori As %String) As %String
{
}

/// 转换门诊发药数量(计价单位)
ClassMethod getPackQty(arcimid, qty) As %String
{
}

/// Description:获取医嘱用药时间  此方法为模式2  模式1:状态 模式2:停止时间点 
/// Input:医嘱Rowid ,XFlag - 空: 停医嘱时间点之前的医嘱   1: 停医嘱时间点之后的医嘱
/// Output:用药时间串,用 "^" 间隔
/// Creator:LiangQiang 
/// CreatDate:2012-01-10
/// w ##class(web.DHCSTInterfacePH).GetDspStrByOrd("医生站给的医嘱ID","1")
ClassMethod GetDspStrByOrd(orditm As %String, XFlag As %String = "") As %String
{
}

/// Description:获取医嘱用药时间串
ClassMethod GetDspDoTimeStrByOrd(orditm As %String, XFlag As %String) As %String
{
}

/// 判断医嘱有效状态
/// 1 有效 0 无效
/// Creator:LiangQiang
ClassMethod GetOrdItmStatus(orditm As %String) As %String
{
}

/// 保存发药主表
ClassMethod SavePhaDisp(dsp, user, opdate, optime) As %String
{
}

/// 获取主药主表单号
ClassMethod GetDispNo(phaloc As %String) As %String
{
}

/// 保存发药子表
ClassMethod SavePhaDispItm(main, dsp, oploc, opuser) As %String
{
}

/// 取发药类别代码
ClassMethod GetCat(CATCODE As %String) As %String
{
}

/// ;取管制分类
ClassMethod getPoisonByInci(inci) As %String
{
}

/// 判断药品是否上架 0：下架  1:上架
/// 规则:非出院带药,非长嘱口服,非特殊科室发药,在药柜中上架
ClassMethod GetItmLoadFlagByArc(orditm) As %String
{
}

/// 根据医嘱取药品是否上架 0：下架  1:上架
ClassMethod GetLocItmLoadFlagByArc(orditm) As %String
{
}

/// 根据库存项取药品是否上架 0：下架  1:上架
ClassMethod GetItmLoadFlag(inci, recloc) As %String
{
}

/// 获取该病区当天已产生的药柜发药单ID
ClassMethod GetOMDispMainID(phaloc, warddr, phactype) As %String
{
}

/// Description:取主科室下面的支配科室
/// Creator:LiangQiang
ClassMethod GetLeadLocdr(sublocdr As %String) As %String
{
}

/// Descriprtion:判断是否医特殊科室
/// Input:phaloc -药房科室, doctorloc -医生科室
/// Output: 1:拒绝的医生科室 0:非拒绝的医生科室
/// Table:CT_LocLinkLocation
/// Creator:Liang Qiang
ClassMethod DoctorLocRefuse(phaloc, doctorloc) As %String
{
}

/// Descriprtion:从第三方获取处方发药窗口
/// Input:phaloc -药房科室, prescno -处方号
/// Output: win -  发药窗口
/// Creator:Liang Qiang
/// 如果中间表有此处方则不再调接口,如果没有打勾发药机不调接口,如果没有打勾发送数据,则返回综合窗口
ClassMethod GetMachineWin(phl, prescno) As %String
{
}

/// Descriprtion:接收第三方信息,完成东华配药过程
/// Input:  action: 301配药; 302取消配药 ;303重新加入对列; 窗口,
///         input: 处方号1$c(28)医嘱ID $c(2)药品代码 $c(2) 实配数量 ### 医嘱ID2 $c(2 )药品代码 $c(2) 实配数量2 ^ 处方号2 , 
///         usercode:人员工号
///         phwidow:窗口
/// Output: 0 成功, <0失败
/// Creator:Liang Qiang
/// 301,"O181129000015_'$c(28)'_1134||2_'$c(2)'_XKF000624_'$c(2)'_60","yf01",42
/// w ##Class(web.DHCSTInterfacePH).RecDataToInsertPHDisp(301,"O181129000015_'$c(28)'_1134||2_'$c(2)'_XKF000624_'$c(2)'_60","yf01",42)
/// w ##Class(web.DHCSTInterfacePH).RecDataToInsertPHDisp(action,input,usercode, phwindow)
ClassMethod RecDataToInsertPHDisp(action, input, usercode, phwindow) As %String
{
}

/// Input:prescno:处方号,pydr:配药人, ordstr: 是否需要欠药+"&&"+是否全部欠药+"&&"+获到每个医嘱ID+"^"+实发数量+"^"+医嘱数量+"^"+单位ID!!医嘱ID2..._"&&"_欠药单ID , action: 301配药, 302取消配药
/// Output:0 成功 , 非0 不成功
ClassMethod InsertPHDisp(action, prescno, pydr, phwindow, ordstr) As %String
{
}

/// 欠药单配药
ClassMethod InsertPHOweDisp(prescno, pydr, ordstr) As %String
{
}

/// Descriprtion:取科室药品库存和货位
/// Creator:Liang Qiang
ClassMethod GetLocDrugData() As %String
{
}

/// 统计库存科室
ClassMethod GetLocStr() As %String
{
}

/// 获取货位
ClassMethod GetStkBin(inclb As %String) As %String
{
}

/// Descriprtion:取科室药品库存和货位
/// Creator:Liang Qiang
ClassMethod GetPHLocWinData() As %String
{
}

/// 获取处方列表 (触摸屏按日期查询处方列表)
/// w ##Class(web.DHCSTInterfacePH).GetPHPrescList(stdate, enddate, patID)
/// w ##Class(web.DHCSTInterfacePH).GetPHPrescList("2013-01-04", "2013-02-04", "19062592")
ClassMethod GetPHPrescList(stdate, enddate, patID) As %String
{
}

/// 接收发药消息,更新窗口号
ClassMethod UpdPhWindow(phl, pharowid, phwindow) As %String
{
}

/// Descript：	配液中心发药主信息
/// Input:		phac-发药主表(DHC_PhaCollected)ID
/// Return:		字符串
ClassMethod GetPIVAMain(phac As %String) As %String
{
}

/// Author : MaYuqiang
/// Date Created : 20181030
/// Description : 获取配液中心发药明细信息(苏州科技城版本)
/// Input:		phac^prtlabelFlag^gMainDodis		(发药主表^打印标识^主打包表id)
/// Return:		字符串
/// w ##class(web.DHCSTInterfacePH).GetPIVADetail("60^N^862")
ClassMethod GetPIVADetail(input As %String) As %String
{
}

/// Author : MaYuqiang
/// Date Created : 20181030
/// Description : 静配排药机获取待发药信息(深圳宝安-艾隆)
/// Input : phac - 住院发药主表id
/// w ##class(web.DHCSTInterfacePH).SendPIVAInfoToMachine(60)
ClassMethod SendPIVAInfoToMachine(phac)
{
}

/// Author : MaYuqiang
/// Date Created : 20181031
/// Description : 门诊药房电子药架发药前后亮、灭灯(参照南方医院版本)
/// return: 	Input-处方号串^  Status-1 发药前，2-发药结束  phw-窗口id  UserCode-发药人代码
/// w ##class(web.DHCSTInterfacePH).SendMessToMedShelves("O15060100001",1,"","pharmacy")
ClassMethod SendMessToMedShelves(Input, Status, phw, UserCode)
{
}

/// Descript：	按科室取批次信息
/// Creater:	zhouyg
/// CreateDate:	2014-01-26
/// Input:		locID-科室ID
/// Output：	临时Global
/// Return:		返回记录数,<0异常错误，其它-记录数
ClassMethod GetLocBatList(LocID As %String) As %String
{
}

/// Author : MaYuqiang
/// CreateDate : 20181019
/// Description : 给叫号系统传消息
/// Input : PatNo - 患者登记号 , PatName - 患者姓名 , ServerIP - 本地ip地址 , PhwId - 发药窗口号
/// Output : 
/// Other :0000346554,刘继荣,192.168.82.36,55,67
/// w ##class(web.DHCSTInterfacePH).SendMessToVoice(":0000346554","刘继荣","192.168.82.36",55,67)
ClassMethod SendMessToVoice(PatNo, PatName, ServerIP, PhwID, FYUserID) As %String
{
}

/// Author : MaYuqiang
/// CreateDate : 20181019
/// Description : 给大屏发送待发药人列表
/// Input : GPhl - 发药科室, GPhw - 发药窗口 , GDate - 查询日期(可为空,为空时默认为当天)
/// Output : PatName1^PatName2^PatName3^...
/// Other :
/// w ##class(web.DHCSTInterfacePH).GetToDispPatList(20,51,"2017-12-31")
ClassMethod GetToDispPatList(GPhl, GPhw, GDate = "") As %String
{
}

/// Author : MaYuqiang
/// Date Created : 20181030
/// Description : 根据医嘱id获取医嘱信息(医嘱改造之后不能根据医嘱id确定唯一库存项，所以重新编写此方法，仅输出医嘱信息)
/// Input:	OeoriID-医嘱ID ， Inclb - 科室库存批次id
/// w ##class(web.DHCSTInterfacePH).GetOrditmInfoStr("181||1","4552||1||2")
ClassMethod GetOeoriInfo(OeoriID As %String, Inclb As %String = "") As %String
{
}

ClassMethod GetBirthDay(Papmi)
{
}

/// add by MaYuqiang 20181129
/// 医嘱结构改造后根据打包主表id获取待发药的药品信息
/// 转换门诊发药数量( 门诊最小发药单位INC_itm 中的 INCI_CTUOM_OutPat_DR)
ClassMethod getPackQtyByDsp(dspid) As %String
{
}

/// Author : MaYuqiang
/// CreatDate : 20151019
/// Description : 获取有发药权限的人员数据
/// d ##class(web.DHCSTInterfacePH).GetPHDispPer()
ClassMethod GetPHDispPer(flag = "")
{
}

/// Creator 	zhaozhiduan
/// CreatDate	2020.04.15
/// Description	门诊发药查询和发药时发送数据到摆药机
/// Input		sendCode-平台组的接口指令
/// 			prescNo-处方号
/// 	w ##class(web.DHCSTInterfacePH).SendOPInfoToMachine(202,"O200403000031")
ClassMethod SendOPInfoToMachine(sendCode, prescNo)
{
}

}
