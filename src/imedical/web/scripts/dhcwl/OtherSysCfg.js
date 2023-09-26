dhcwl.mkpi.OtherSysCfg = function(){
	
	//*************************************************************其他系统配置*********************************************************//
	var serviceUrl='dhcwl/kpi/othersyscfg.csp';
	//		定义Form表单
	var OtherSysCfgForm = new Ext.FormPanel({
		//title:'任务全局配置',
		id:'otherSysCfgForm',
		width:1000,
		layout:'table',
		columnLines: true,
		viewConfig:{forceFit: true},
		layoutConfig:{columns:10},
		items:[{
			html:' ',
			height:20,
			colspan:10
		},{
			html:'为所有维度添加属性“统计大组”和“统计子组”',
			colspan:8
		},{
			xtype:'button',
			
			id:'btnAddGrpAndSubgrp',
			colspan:4,
			//text:'执行',
			text: '<span style="line-Height:1">执行</span>',
			icon: '../images/uiimages/ok.png',
			handler:OnAddGrpAndSubgrp
		}]
	});
	
	var OtherSysCfgPanel = new Ext.Panel({
		id:'otherSysCfgPanel',
		monitorResize:true,
		layout:'table',
		layoutConfig:{columns:3},
		items:[{
			height:550,
			items:OtherSysCfgForm,
			colspan:3
		}]
	});
	
	this.GetOtherSysCfgPanel = function(){
		return OtherSysCfgPanel;
	}
	
	function OnAddGrpAndSubgrp(){
        		var url=serviceUrl+'?action=addGrpAndSubgrp'
				dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok"){
							Ext.Msg.alert("提示","操作完成！");
							//刷新grid  
							//refresh();

						}else{
							Ext.Msg.alert("提示","操作失败！");
							}
							
						},this);
				
	}

}