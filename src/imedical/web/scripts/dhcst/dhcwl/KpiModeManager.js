﻿(function(){	Ext.ns("dhcwl.mkpi.KpiModeManager");})();dhcwl.mkpi.KpiModeManager=function(){	var modeCfgPanel=null,rptCfgPanel=null,dimCfgPanel=null,cfgMapPanel=null;	var modeCfgObj=null,rptCfgObj=null,dimCfgObj=null;	//模块配置页面	modeCfgObj=new dhcwl.mkpi.KpiModeCfg();	modeCfgPanel=modeCfgObj.getModeCfgPanel();		//报表配置页面		rptCfgObj=new dhcwl.mkpi.KpiRptCfg();	rptCfgPanel=rptCfgObj.getRptCfgPanel();		//指标配置页面	dimCfgObj=new dhcwl.mkpi.KpiDimCfg();	dimCfgPanel=dimCfgObj.getDimCfgPanel();			var KpiModeManagerPanel=new Ext.Panel({	 		id:"modeManagerPanel",			title:'模块与报表',			layout:'border',		defaults: {		    collapsible: true,		    split: true,		    bodyStyle: 'padding:5px'		},		items: [{			id:"modeCfgPanel",		    title: '模块管理',		    region:'west',		    margins: '5 0 0 0',		    cmargins: '5 5 0 0',		    width: 320,		    minSize: 100,		    maxSize: 500,		    items:modeCfgPanel		},{		    title: '报表及指标',		    collapsible: false,		    region:'center',		    margins: '5 0 0 0',		    cmargins: '5 5 0 0',		    items:[{		    	id:"reportCfgPanel",		    	collapsible: true,			    title: '报表管理',			    minSize: 100,			    height: 300,			    maxSize: 550,			    items:rptCfgPanel			    },{			    id:"KPICfgPanel",			    collapsible: true,			    title: '指标管理',			    height: 300,			    minSize: 100,			    maxSize: 500,			    items:dimCfgPanel		    }]		}]		    });    this.getModeManagerPanel=function(){    	return KpiModeManagerPanel;    }            }