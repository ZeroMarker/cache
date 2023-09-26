/*
* Creator   : wk 
* CreatDate : 2018-11-01
* Desc      : 产品信息列表
*/
 var productTabObj = {};
 
 
 /*--指标系统--*/
 productTabObj['KPIDefineTab'] = {};
 productTabObj['KPIDefineTab'].title = "指标定义";
 productTabObj['KPIDefineTab'].url = "dhcwl/v1/kpi/kpi/createkpiwin.csp";
 
 productTabObj['KPITab'] = {};
 productTabObj['KPITab'].title = "指标";
 productTabObj['KPITab'].url = "dhcwl/v1/kpi/kpi/configkpiwin.csp";
 
 productTabObj['baseDimTab'] = {};
 productTabObj['baseDimTab'].title = "基础维度";
 productTabObj['baseDimTab'].url = "dhcwl/v1/kpi/dim/dimcreate.csp";
 
 productTabObj['baseDimTab'] = {};
 productTabObj['baseDimTab'].title = "基础维度";
 productTabObj['baseDimTab'].url = "dhcwl/v1/kpi/dim/dimcreate.csp";
 
 productTabObj['dimRowTab'] = {};
 productTabObj['dimRowTab'].title = "维度角色";
 productTabObj['dimRowTab'].url = "dhcwl/v1/kpi/dimrole/dimrole.csp";
 
 productTabObj['sectionDimTab'] = {};
 productTabObj['sectionDimTab'].title = "区间维度";
 productTabObj['sectionDimTab'].url = "dhcwl/v1/kpi/kpisection/kpisection.csp";
 
 productTabObj['KPITypeTab'] = {};
 productTabObj['KPITypeTab'].title = "指标类型";
 productTabObj['KPITypeTab'].url = "dhcwl/v1/kpi/kpitype/kpitype.csp";
 
 productTabObj['dateSectionTab'] = {};
 productTabObj['dateSectionTab'].title = "日期区间";
 productTabObj['dateSectionTab'].url = "dhcwl/v1/kpi/kpimonth/kpimonth.csp";
 
 productTabObj['KPIGroupTab'] = {};
 productTabObj['KPIGroupTab'].title = "任务组配置";
 productTabObj['KPIGroupTab'].url = "dhcwl/v1/kpi/kpigroup/kpigroup.csp";
 
 productTabObj['KPILogTab'] = {};
 productTabObj['KPILogTab'].title = "指标日志";
 productTabObj['KPILogTab'].url = "dhcwl/v1/kpi/kpilog/kpilog.csp";
 
 productTabObj['KPIModuleCfgTab'] = {};
 productTabObj['KPIModuleCfgTab'].title = "模块与报表";
 productTabObj['KPIModuleCfgTab'].url = "dhcwl/v1/kpi/kpimodule/kpimodule.csp";
 
 productTabObj['KPIOtherCfgTab'] = {};
 productTabObj['KPIOtherCfgTab'].title = "系统配置";
 productTabObj['KPIOtherCfgTab'].url = "dhcwl/v1/kpi/kpiconfig/kpiconfig.csp";
 
 
  /*--标准化管理--*/
 productTabObj['standMeasurecfgTab'] = {};
 productTabObj['standMeasurecfgTab'].title = "度量维护";
 productTabObj['standMeasurecfgTab'].url = "dhcwl/v1/standcfg/measurecfg.csp";
 
 productTabObj['standDataSourceTab'] = {};
 productTabObj['standDataSourceTab'].title = "数据源管理";
 productTabObj['standDataSourceTab'].url = "dhcwl/v1/standcfg/dscfg.csp";
 
 /*--BS代码维护--*/
 productTabObj['BSGrpTab'] = {};
 productTabObj['BSGrpTab'].title = "统计大组";
 productTabObj['BSGrpTab'].url = "dhcwl/v1/codecfg/codecfgsubgroup.csp";
 
 productTabObj['BSSubGrpTab'] = {};
 productTabObj['BSSubGrpTab'].title = "统计子组";
 productTabObj['BSSubGrpTab'].url = "dhcwl/v1/codecfg/codecfggroup.csp";
 
  /*--出入转统计维护--*/
 productTabObj['mripdayrptcfgTab'] = {};
 productTabObj['mripdayrptcfgTab'].title = "报表项配置";
 productTabObj['mripdayrptcfgTab'].url = "dhcwl/v1/mripday/mripdayrptcfg.csp";
 
 productTabObj['mripdayrptcolcfgTab'] = {};
 productTabObj['mripdayrptcolcfgTab'].title = "报表列配置";
 productTabObj['mripdayrptcolcfgTab'].url = "dhcwl/v1/mripday/mripdayrptcolcfg.csp";
  
 productTabObj['mripdayrptcoldetailTab'] = {};
 productTabObj['mripdayrptcoldetailTab'].title = "明细报表列配置";
 productTabObj['mripdayrptcoldetailTab'].url = "dhcwl/v1/mripday/mripdayrptcoldetail.csp";
  
 productTabObj['mripdaytaskcfgTab'] = {};
 productTabObj['mripdaytaskcfgTab'].title = "出入转任务配置";
 productTabObj['mripdaytaskcfgTab'].url = "dhcwl/v1/mripday/mripdaytaskcfg.csp";
 
   /*--收入报表配置--*/
 productTabObj['rptconfigTab'] = {};
 productTabObj['rptconfigTab'].title = "报表配置";
 productTabObj['rptconfigTab'].url = "dhcwl/v1/complexrpt/rptconfig.csp";
 
 productTabObj['rptstatmodeTab'] = {};
 productTabObj['rptstatmodeTab'].title = "统计模式配置";
 productTabObj['rptstatmodeTab'].url = "dhcwl/v1/complexrpt/rptstatmode.csp";
  
 productTabObj['rptstatitemTab'] = {};
 productTabObj['rptstatitemTab'].title = "统计项配置";
 productTabObj['rptstatitemTab'].url = "dhcwl/v1/complexrpt/rptstatitem.csp";
  
 productTabObj['rptmkpipool'] = {};
 productTabObj['rptmkpipool'].title = "指标池";
 productTabObj['rptmkpipool'].url = "dhcwl/v1/complexrpt/rptmkpipool.csp";
 
/*--病案维护--*/
 productTabObj['mrbaseBedconfigTab'] = {};
 productTabObj['mrbaseBedconfigTab'].title = "床位维护";
 productTabObj['mrbaseBedconfigTab'].url = "dhcwl/v1/mrbase/bedconfig.csp";
 
 productTabObj['mrbaseIcdconfigTab'] = {};
 productTabObj['mrbaseIcdconfigTab'].title = "ICD维护";
 productTabObj['mrbaseIcdconfigTab'].url = "dhcwl/v1/mrbase/icdconfig.csp";
 
 
/*--医生应用配置--*/
 productTabObj['dockpicfgTab'] = {};
 productTabObj['dockpicfgTab'].title = "医生应用配置";
 productTabObj['dockpicfgTab'].url = "dhcwl/v1/docappcfg/dockpicfg.csp";

/*--医技工作量--*/ 
 productTabObj['wlcfgTab'] = {};
 productTabObj['wlcfgTab'].title = "医技工作量";
 productTabObj['wlcfgTab'].url = "dhcwl/v1/wl/wlcfg.csp";
 
 /*--标准值维护--*/
 productTabObj['checkFunMaincfgTab'] = {};
 productTabObj['checkFunMaincfgTab'].title = "考核方案维护";
 productTabObj['checkFunMaincfgTab'].url = "dhcwl/v1/checkfun/maincfg.csp";
 
 productTabObj['checkFunkpicfgTab'] = {};
 productTabObj['checkFunkpicfgTab'].title = "考核指标维护";
 productTabObj['checkFunkpicfgTab'].url = "dhcwl/v1/checkfun/kpicfg.csp";
 
 /*--院长查询--*/ 
 productTabObj['deanviewTab'] = {};
 productTabObj['deanviewTab'].title = "院区配置";
 productTabObj['deanviewTab'].url = "dhcwl/v1/deanview/deanview.csp";
 
 /*--版本管理--*/ 
 productTabObj['vermanagementTab'] = {};
 productTabObj['vermanagementTab'].title = "版本管理";
 productTabObj['vermanagementTab'].url = "dhcwl/v1/vermanagement/vermanagement.csp";
 
  /*--报表展示--*/ 
 productTabObj['rptlistmain'] = {};
 productTabObj['rptlistmain'].title = "报表展示";
 productTabObj['rptlistmain'].url = "dhcwl/v1/bkcdataquery/rptlistmain.csp";
 
  /*--权限管理--*/ 
 productTabObj['permisframe'] = {};
 productTabObj['permisframe'].title = "权限管理";
 productTabObj['permisframe'].url = "dhcwl/v1/bkcdataquery/permisframe.csp";
 
  /*--通用简单查询配置--*/ 
 productTabObj['cdqbrowserpt'] = {};
 productTabObj['cdqbrowserpt'].title = "通用简单查询配置";
 productTabObj['cdqbrowserpt'].url = "dhcwl/v1/bkcdataquery/cdqbrowserpt.csp";
 
  /*--基础数据查询配置--*/ 
 productTabObj['basedataframe'] = {};
 productTabObj['basedataframe'].title = "基础数据查询配置";
 productTabObj['basedataframe'].url = "dhcwl/v1/bkcdataquery/basedataframe.csp";
 
  /*--报表管理--*/ 
 productTabObj['rptmgmt'] = {};
 productTabObj['rptmgmt'].title = "报表管理";
 productTabObj['rptmgmt'].url = "dhcwl/v1/rptmgmt/rptmgmt.csp";