(function(){
	Ext.ns("dhcwl.mkpi.ModuleKpiShow");
})();
dhcwl.mkpi.ModuleKpiShow=function(){
	
	var outThis=this;
	
	var setForm=new Ext.form.FormPanel({
    	frame: true,
        height: 310,
        //width:300,
        labelAlign: 'left',
        bodyStyle:'padding:15px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        layoutConfig: {columns:2},
        buttonAlign: 'center',
        buttons:[{
        	//text:'关闭',
        	text: '<span style="line-Height:1">关闭</span>',
        	icon: '../images/uiimages/cancel.png',
        	handler:function(){
        		win.hide(); 
        	}
        }],
        items:[{
        	html:'指标：'
        },{
        	 xtype: "textarea",
             //fieldLabel: "备注",
             id: "kpiCodes",
             //labelSepartor: "：",
             //labelWidth: 60,
             width: 530,
             height:200
        }]
	})
	
	var win=new Ext.Window({
		title:'任务指标展示',
		closable:true,
		modal : true,
		width : 600,
		resizable : false,
		plain : true,
		layout : 'form',
		items : [setForm],
		listeners:{
			'close':function(){
			}
    	}
	});
	this.show=function(modNodeIDs,rptNodeIDs,setNodeIDs,sign){
		//alert(modNodeIDs+":"+rptNodeIDs+":"+setNodeIDs+":"+sign);
		//return;
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',{
			action:'showDataTaskKpi',
			modNodeIDs:modNodeIDs,
			rptNodeIDs:rptNodeIDs,
			setNodeIDs:setNodeIDs,
			sign:sign
		},  
		function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				Ext.getCmp('kpiCodes').setValue(jsonData.kpiCodes); 
			}else{
				Ext.Msg.alert("提示","操作失败！");
			}			

		}
		,outThis);
		win.show(this);
	}
}