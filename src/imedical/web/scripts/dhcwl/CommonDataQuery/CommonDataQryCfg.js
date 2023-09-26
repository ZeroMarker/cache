(function(){
	Ext.ns("dhcwl.CDQ.CommonDataQryCfg");
})();
///描述: 		报表配置页面
///编写者：		WZ
///编写日期: 		2014-11
dhcwl.CDQ.CommonDataQryCfg=function(){
	var serviceUrl="dhcwl/commondataquery/commondataqry.csp";
	var outThis=this;
	var rptCfgID="";

    Ext.QuickTips.init();
    // turn on validation errors beside the field globally
    Ext.form.Field.prototype.msgTarget = 'side';	
	
    var commonCfgForm = new Ext.FormPanel({
    	//bodyStyle:'padding:5px',
		labelAlign : 'right',
    	frame:true,
    	//height: 120,
		//layout:'fit',
		labelWidth : 85,
		layout : 'column',

		items:[
		{
			columnWidth : .3,
			layout : 'form',
			defaultType : 'textfield',
			defaults: {
					allowBlank : false
			},
			items : [{
							fieldLabel : '查询名称',
							xtype:'textfield',
            				name: 'qryName',
            				anchor:'85%'
											
					},{
							fieldLabel : 'Function',
            				xtype:'textfield',
            				name: 'fun',
            				anchor:'85%'			
					},{
							fieldLabel : '统计开始日期',
							xtype: 'datefield',
							name : 'startDate',
							format:GetWebsysDateFormat(),
            				anchor:'85%'	,
							allowBlank : true
					}	]
		},{
			columnWidth : .3,
			layout : 'form',
			defaultType : 'textfield',
			defaults: {
					allowBlank : false
			},			
			items : [{
							fieldLabel : 'NameSpace',
							xtype:'combo',
            				name: 'nameSpace',
            				anchor:'85%',
							displayField:   'description',
							valueField:     'value',
							store:          new Ext.data.JsonStore({
								fields : ['description', 'value'],
								data   : [
									{description : 'dhc-app',   value: 'dhc-app'}
								   ,{description : 'dhc-data',   value: 'dhc-data'}
								]
							}),	
							mode:           'local',
							triggerAction:  'all',
							typeAhead: true							
					},{
							fieldLabel : '其他参数',
            				xtype:'textfield',
            				name: 'otherParam',
            				anchor:'85%',
							allowBlank : true							
					},{
							fieldLabel : '统计结束日期',
							xtype: 'datefield',
							name : 'endDate',
							format:GetWebsysDateFormat(),
            				anchor:'85%',
							allowBlank : true							
					}		
			]
		},{
			columnWidth : .3,
			layout : 'form',
			defaultType : 'textfield',
			defaults: {
					allowBlank : false
			},			
			items : [{
							fieldLabel : 'Routine',
							xtype:'textfield',
            				name: 'routine',
            				anchor:'85%'
											
					},{
							fieldLabel : '报表标题',
							xtype:'textfield',
            				name: 'rptTitle',
            				anchor:'85%'
											
					}				
			]
		}],
		buttons: [
		{
			text: '<span style="line-Height:1">查询</span>',				
			icon   : '../images/uiimages/search.png',	
			handler:OnQuery			
		}]
	});

    var commonCfgPanel =new Ext.Panel({
		closable:true,
    	title:'通用数据查询',
    	layout:'border',
        items: [{
        	region: 'north',
            height: 125,
			layout:'fit',
            //autoScroll:true,
            items:commonCfgForm
        },{
			region:'center',
			layout:'fit',
			items:[{
				title: '查询结果',  
				frameName: 'runqianRpt',	
				html: '<iframe width=100% height=100% src="dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-commonDataQry.raq"></iframe>'	
				,autoScroll: true	
			}]
			
		
    	}],
		tbar:new Ext.Toolbar({
						layout: 'hbox',
						items : [
						{
							name:'saveCfg',
							text: '<span style="line-Height:1">保存</span>',				
							icon   : '../images/uiimages/filesave.png',
							xtype:'button',
							handler:OnSaveCfg
						},"-",{
							name:'searchRptData',
							text: '<span style="line-Height:1">加载</span>',
							icon   : '../images/uiimages/read.png',
							xtype:'button',
							handler:OnLoadCfg
						}
					]})		
		
		
		
    });

	function OnQuery() {
		var baseForm=commonCfgForm.getForm();

		//var fields=commonCfgForm.isValid() ;
		if (!baseForm.isValid()) {
			Ext.Msg.alert("提示","数据录入不完整！");
			return;		
		}
		
		var Values=baseForm.getFieldValues();

		if (!Values.startDate || !Values.endDate) {
			Ext.Msg.alert("提示","请录入统计开始日期和结束日期！");
			return;		
		}		
		
		//var startDate = new Date(Values.startDate);
		//var startDate=startDate.format('Y-m-d');
		//var endDate=new Date(Values.endDate);
		//var endDate=endDate.format('Y-m-d');	
		if (Values.startDate>Values.endDate) {
			Ext.Msg.alert("提示","统计开始日期不能大于结束日期！");
			return;				
			
		}
		var startDate=Values.startDate.format('Y-m-d');
		var endDate=Values.endDate.format('Y-m-d');

		var routineName=Values.routine;
		var functionName=Values.fun;
		var nameSpaceName=Values.nameSpace;
		var params=Values.otherParam;
		var rptTitle=Values.rptTitle;
		
		var gridContainer=commonCfgPanel.items.itemAt(1);
		var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		
		iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-commonDataQry.raq'+'&startDate='+startDate+'&endDate='+endDate+'&routineName='+routineName+'&functionName='+functionName+'&nameSpaceName='+nameSpaceName+'&params='+params+'&rptTitle='+rptTitle;
		
		/*
		iframe.src = "dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-commonDataQry.raq&startDate=2017-07-01&endDate=2017-07-02&routineName=DHCWLSinQuery&functionName=Test&nameSpaceName=dhc-app&params=&rptTitle="
		*/
		gridContainer.doLayout(); 		
	}
	
	function OnSaveCfg() {
		//rptCfgID
		
		var baseForm=commonCfgForm.getForm();
		
		//var fields=commonCfgForm.isValid() ;
		if (!baseForm.isValid()) {
			Ext.Msg.alert("提示","数据录入不完整！");
			return;		
		}		
		
		
		var Values=baseForm.getFieldValues();
		/*
		var startDate = new Date(Values.startDate);
		var startDate=startDate.format('Y-m-d');
		var endDate=new Date(Values.endDate);
		var endDate=endDate.format('Y-m-d');	
		*/
		var routineName=Values.routine;
		var functionName=Values.fun;
		var nameSpaceName=Values.nameSpace;
		var params=Values.otherParam;
		var rptTitle=Values.rptTitle;	
		var qryName=Values.qryName;
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:"saveRpt",
			routine:routineName,
			fun:functionName,
			nameSpace:nameSpaceName,
			OtherParam:params,
			rptTitle:rptTitle,
			qryName:qryName,
			rptCfgID:rptCfgID
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				Ext.Msg.alert("提示","操作成功！");
				rptCfgID=jsonData.rptID;
			}else if(jsonData.success==true && jsonData.tip=="false"){
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);			
		
	}
	
	
	function OnLoadCfg() {
		var loadWin=new dhcwl.CDQ.SaveAsWin();
		loadWin.onLoadCallback=loadData;
		loadWin.show();
		
	}
	
	function loadData(param) {
		var baseForm=commonCfgForm.getForm().setValues(param);
		rptCfgID=param.rptID;
		return;
	}
	
	
	this.getQryPanel=function() {
		return commonCfgPanel;
		
	}
}

