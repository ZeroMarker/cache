Class web.DHCPE.Statistic.HISUICommon Extends %RegisteredObject
{

/// Creator：    ln 
/// CreatDate：  20220909
/// Description: 根据url串获取菜单名称
/// Input:       URL
/// Return：     菜单名称
/// debug:   w ##class(web.DHCPE.Statistic.HISUICommon).GetMenuDescByUrl()
ClassMethod GetMenuDescByUrl(URL)
{
	q:URL="" ""
	q:URL'["TMENU" ""
	s Str=$p(URL,"TMENU=",2)
	s MenuID=$p(Str,"&",1)
	q:MenuID="" ""
	s menuobj=##class(websys.Menu).%OpenId(MenuID)
	s Desc=menuobj.Caption
	q Desc
}

/// Creator：    ln 
/// CreatDate：  20220909
/// Description: 根据url串获取统计报表的统计说明(备注)
/// Input:       URL
/// Return：     统计说明(备注)
/// debug:   w ##class(web.DHCPE.Statistic.HISUICommon).GetRemarkByMenuDesc("体检中心工作量统计")
ClassMethod GetRemarkByMenuDesc(MenuDesc)
{
	q:MenuDesc="" ""
	s ret=##class(web.DHCPE.Settings.Param).GetParamCode("PEStatistic",MenuDesc)
	q:ret="" ""
	s ret=$tr(ret,$C(10),"")
	s rule=$p(ret,"统计规则:",2)
	s condition=$p($p(ret,"统计规则:",1),"查询条件:",2)
	
	q condition_"^"_rule
}

/// Description：添加体检统计维护数据 
/// Input:   	
/// Return:		
/// Creator:	ln
/// CreateDate:	2022-10-21
/// Debug: w ##class(web.DHCPE.Statistic.HISUICommon).AddPEStatistic()
ClassMethod AddPEStatistic()
{
	Quit:$DATA(^DHCPESettingsApp(0,"Code","PEStatistic")) "-1^配置信息已存在"
	Set $ZTRAP = "AddPEStatisticErr"
	Tstart
	Write "/*************生成APP*************/",!
	Set appId = ##class(web.DHCPE.Settings.App).AddApp("PEStatistic","体检统计说明维护")
	If +appId<=0  Trollback  Quit appId
	Write "/*************生成Param*************/",!
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.ReceptionWorkStatistic","体检中心工作量统计","","查询条件:各操作日期  统计规则:每个人每种类型在统计时间段内算一遍，不同安全组显示列不同")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPESingleItemQuery","医嘱数量查询","","查询条件:到达项目日期(按医嘱查询) 操作日期中的到达日期(按套餐查询)  统计规则:数量=预约+加项=核实+执行+停止；放弃是本时间段内插入医嘱中放弃的数量；最后本时间内停止医嘱是插入的负记录，包括删除医嘱，取消体检和取消到达插入的负记录")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.AnnualReports","体检中心年度报表","","查询条件:到达日期(体检中心业务概况，到达人数)，结算日期(收入及结构，结算费用)  统计规则:体检中心业务概况，统计各VIP等级的到达人数；收入及结构，统计结算的各金额区间的人数及平均费用等")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.RepQuery.PreStatistics","体检结果分析","","查询条件:总检日期  统计规则:每日任务自动生成每天总检完人员的指标；新增或修改指标时，点保存并更新，可以生成以前人员的指标数据")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.CardStatistic","体检卡汇总报表","","查询条件:金额变动日期  统计规则:查询日期内，有金额变动的卡都统计，剩余金额可以点开查看每张卡的金额变动明细")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.DoctorWork.HISUI","医生工作量统计","","查询条件:体检结果表的日期  统计规则:体检医生安全组只能查看自己的工作量；按人统计就是以人为单位，不论几条医嘱都算一个人次")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.CallVoice","排队叫号统计","","查询条件:操作日期中的到达日期  统计规则:体检总时间，从到达到收表的时间；按医生查询，是每个医生检查每位患者的时间及平均时间")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.RepQuery.StationWorkAmountNew","科室工作量统计","","查询条件:体检结果表的日期  统计规则:检查检验的回传了结果才可以统计，如果平台推送结果就是跟出报告时间是同步的")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.GroupFeeStatistic","团体费用统计","","查询条件:团体登记/到达时间  统计规则:登记或到达团体的人数及费用情况")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.ChargedReport","收费员统计报表","","查询条件:结算日期  统计规则:各收费员的收款张数金额、退款张数金额，未打发票指发票号包含“DHCSSP”或“DHCDZP”，并且没有在集中打印处打印发票")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.ItemExecutionStatus","体检已检未检弃检查询","","查询条件:人员到达日期  统计规则:统计每个到达的人的检查情况，及每条医嘱的人员检查情况；项目是按医生权限维护界面默认站点的医嘱显示的")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.StationIncomeStatistic","科室收入统计","","查询条件:结算日期  统计规则:结算人员的各接收科室的数量费用等")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.IncomStatic","体检收入统计","","查询条件:结算日期  统计规则:结算团体及全部个人的人数及费用情况；结算人员的各会计子分类的金额")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPEMenu.illnessStatisticEdit","疾病统计","","查询条件:总检日期  统计规则:总检提交界面展示的疾病，包括建议和疾病对照的疾病及医生手工选择的疾病；分母为总检总人数")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.FeeStatis","体检费用统计","","查询条件:到达项目表时间(按医嘱查询) 人员到达时间(按人员查询)  统计规则:统计到达产生的费用，按医嘱查询金额固定；按人员查询，后期加项删项及取消体检取消到达会造成金额变动")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPE.CallVoice1","质量上报统计","","查询条件:质量上报的日期  统计规则:按责任人和上报人分别统计上报的错误类型，比率等")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPEAsChargedStatistic","视同收费未交费统计","","查询条件:人员到达日期  统计规则:只统计个人到达的，未付费、部分付费、挂账和定额卡支付的人员明细及视同收费的操作人等")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPEOneDayPreItemStatistic","体检每日预约情况","","查询条件:人员登记或到达日期  统计规则:每天登记或到达的各VIP等级的人员情况，预约项目可点开详细查看具体预约的项目；一般用于护士提前查看体检中心的预约情况，方便分配材料医生等")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPEUnNormalResult","体检异常结果统计","","查询条件:人员到达日期  统计规则:结果表中异常结果的人员明细，及结果明细")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"DHCPEPreAsCharged","定额卡统计","","查询条件:定额卡操作的日期  统计规则:操作定额卡的个人及团体名称、金额及操作人的信息等")
	If +paramCSS<=0  Trollback  Quit paramCSS
	
	Tcommit
	Write "/*************SUCCESS*************/",!
	Quit 0
AddPEStatisticErr
	Set $ZTRAP = ""
	Trollback
	Quit "-100^"_$ZERROR
}

}
