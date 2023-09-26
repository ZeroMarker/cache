(function(){
	Ext.ns("dhcwl.RptMgmt.Compare");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.RptMgmt.Compare=function(pObj){
	var serviceUrl="dhcwl/rptmgmt/addwin.csp";
	var outThis=this;
	var searchInx=0;
	
	var compareForm1= new Ext.FormPanel({
		labelWidth: 80, // label settings here cascade unless overridden
		labelAlign : 'right',
        frame:true,
        //layout:'column',  
		border:false,

        items:[  
			{  
				//columnWidth:.5, 

					//margins:{top:15, right:15, bottom:15, left:15},
					layout:'form',  
					xtype:'fieldset',  
					////autoHeight:true,  
					defaults: {               // defaults are applied to items, not the container
						xtype:'textfield',
						autoScroll:true,
						readOnly :true,
						anchor: '98%'						
					},	

					title:'智能报表描述1',  
					items:[  
						{
							fieldLabel:'菜单名称',
							name:'MenuName'
						},{						
							fieldLabel:'当前页面(标题)名称',
							name:'AuxiliaryMenuName'
						},{						
							fieldLabel:'raq名称',
							name:'RaqName'
						},
						{
							fieldLabel:'CSP名称',
							name:'CSPName'
						},{						
							fieldLabel:'主程序query',
							name:'QueryName'
						},{
							fieldLabel:'数据条件',
							name:'Filter'
						},{						
							fieldLabel:'显示条件',
							name:'RowColShow'
						},{
							fieldLabel:'统计口径',
							name:'Spec'
						},{						
							fieldLabel:'业务表',
							name:'HisTableName'
						},{						
							fieldLabel:'指标',
							name:'KPIName'
						},{
							fieldLabel:'高级客户',
							name:'AdvUser'
						},{						
							fieldLabel:'项目工程师',
							name:'ProMaintainer'
						},{						
							fieldLabel:'开发工程师',
							name:'DepMaintainer'
						},{						
							fieldLabel:'使用（科室）部门',
							name:'UsedByDep'
						},{
							fieldLabel:'逻辑说明',
							name:'ProgramLogic',
							xtype: 'textarea'
						},{
							fieldLabel:'其他备注',
							name:'Demo',
							xtype: 'htmleditor'
						}  
					]  
			}
		],
		tbar:new Ext.Toolbar({
        	layout: 'hbox',
        	items : [{
				text: '<span style="line-Height:1">打开</span>',
				icon   : '../images/uiimages/read.png',
				xtype:'button',
				handler:OnSearch1
			}				
				
			]
		})
			
    });	

	var compareForm2= new Ext.FormPanel({
        labelWidth: 80, // label settings here cascade unless overridden
		labelAlign : 'right',
        frame:true,
        //layout:'column',  
		border:false,
        items:[  
			{  
				//columnWidth:.5, 
					layout:'form',  
					xtype:'fieldset',   
					//defaultType:'textfield',  
					
					defaults: {               // defaults are applied to items, not the container
						xtype:'textfield',
						autoScroll:true,
						readOnly :true,
						anchor: '98%'						
					},					
					title:'智能报表描述2',  
					items:[  
						{
							fieldLabel:'菜单名称',
							name:'MenuName'
						},{						
							fieldLabel:'当前页面(标题)名称',
							name:'AuxiliaryMenuName'
						},{						
							fieldLabel:'raq名称',
							name:'RaqName'
						},
						{
							fieldLabel:'CSP名称',
							name:'CSPName'
						},{						
							fieldLabel:'主程序query',
							name:'QueryName'
						},{
							fieldLabel:'数据条件',
							name:'Filter'
						},{						
							fieldLabel:'显示条件',
							name:'RowColShow'
						},{
							fieldLabel:'统计口径',
							name:'Spec'
						},{						
							fieldLabel:'业务表',
							name:'HisTableName'
						},{						
							fieldLabel:'指标',
							name:'KPIName'
						},{
							fieldLabel:'高级客户',
							name:'AdvUser'
						},{						
							fieldLabel:'项目工程师',
							name:'ProMaintainer'
						},{						
							fieldLabel:'开发工程师',
							name:'DepMaintainer'
						},{						
							fieldLabel:'使用（科室）部门',
							name:'UsedByDep'
						},{
							fieldLabel:'逻辑说明',
							name:'ProgramLogic',
							xtype: 'textarea'
						},{
							fieldLabel:'其他备注',
							name:'Demo',
							xtype: 'htmleditor'
						}  
					]  
			}
		],
		tbar:new Ext.Toolbar({
        	layout: 'hbox',
        	items : [{
				text: '<span style="line-Height:1">打开</span>',
				icon   : '../images/uiimages/read.png',
				xtype:'button',
				handler:OnSearch2
			}				
				
			]
		})
			
    });	
	
	var compareWin = new Ext.Window({
        width:900,
		height:620,
		resizable:false,
		closable : false,
		title:'对比',
		modal:true,
		//items:[saveAsForm,rptGrid],
		//items:compareForm ,		
		//layout:'fit',
		//autoHeight :true,
		autoScroll :true,
		items:[{
			layout:'column',  
			//autoHeight :true,
			items:[{
				
				border:false,
				items:compareForm1,
				columnWidth:.5
				
			},{
				border:false,
				items:compareForm2,
				columnWidth:.5			
			}]
		}],			
		buttons: [
		{
			text: '<span style="line-Height:1">关闭</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: CloseWins
		}]
	});	
	
	function OnSearch1() {

		searchInx=1;
		OnSearch();
	}
	function OnSearch2() {

		searchInx=2;
		OnSearch();
	}	
	
	function OnSearch() {
		var searchRptObj=new dhcwl.RptMgmt.SearchRptCfg();
		searchRptObj.OnRptCfgCallback=OnRptCfgCallback;
		searchRptObj.show();
	}
	
	function OnRptCfgCallback(rec) {
		if (searchInx==1) {
			compareForm1.getForm().loadRecord(rec)
		}else if  (searchInx==2) {
			compareForm2.getForm().loadRecord(rec)
		}
		
		
		var cnt=compareForm2.get(0).items.getCount();
		for(i=0;i<cnt;i++) {
			value1=compareForm1.get(0).items.itemAt(i).getValue();
			value2=compareForm2.get(0).items.itemAt(i).getValue();
			if (value1!=value2) {
				compareForm2.get(0).items.itemAt(i).addClass('x-form-samed');
			}else{
				compareForm2.get(0).items.itemAt(i).removeClass('x-form-samed');
			}
			
		}

		return;
	}

	
	function OnLoad() {
		if(outThis.onLoadCallback)
		{
		}
				
	}
	function CloseWins() {
			compareWin.close();
	}
 

	
	
	
	this.getCompareWin=function() {
		return compareWin;
	}
	
	this.show=function() {
		compareWin.show();
	}

}

