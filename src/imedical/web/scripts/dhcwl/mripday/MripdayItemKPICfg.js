(function(){
	Ext.ns("dhcwl.mripday.MripdayItemKPICfg");
})();
///描述: 		KPI统计项配置页面
///编写者：		WZ
///编写日期: 		2014-11
dhcwl.mripday.MripdayItemKPICfg=function(){
	var OPTLItemDR=null;
	var KPIDR=null;
	var serviceUrl="dhcwl/mripday/mripdayItemCfg.csp";
	
	var quickMenu=new Ext.menu.Menu({
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'删除',
    			handler:function(){
			 		
			 		var isSel=itemKPICfgGrid.getSelectionModel().getSelected();
					if (!isSel) {
						Ext.MessageBox.alert("提示","请先选择统计项！");
						return;
					}  
					var rowID=isSel.get('RowID');
			    	var OPTLItemDR=isSel.get('OPTLItemDR');
			    	var itemType=isSel.get('ItemType');
			        paraValues='OPTLItemDR='+OPTLItemDR+'&ItemType='+itemType+'&RowID='+rowID;
			        var url=serviceUrl+'?action=delKPIItem&'+paraValues
					dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
							if(jsonData.success==true && jsonData.tip=="ok"){
								if(jsonData.rptName){
									Ext.MessageBox.alert("提示","下面的报表使用了这个统计项配置："+jsonData.rptName+"!请先删除这些报表！");
									return;
								}
								else{
									refresh();
									Ext.Msg.alert("提示","操作成功！");
								}
							}else{
								Ext.Msg.alert("提示","操作失败！");
								}
								
							},this);			    	
     			}
    		}]
	});	
		
	
	
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'RowID',sortable:true, width: 30, sortable: true,menuDisabled : true
        },{header:'统计项ID',dataIndex:'OPTLItemDR',sortable:true, width: 80, sortable: true,menuDisabled : true
        },{header:'指标编码',dataIndex:'KPICode', width: 160, sortable: true,menuDisabled : true
        },{header:'维度编码',dataIndex:'DimCode',sortable:true, width: 80, sortable: true,menuDisabled : true
        },{header:'类型',dataIndex:'ItemType', width: 160, sortable: true,menuDisabled : true        
        },{header:'出入转类别',dataIndex:'DetailType',sortable:true, width: 80, sortable: true,menuDisabled : true
        },{header:'日期区间',dataIndex:'DateSec', width: 160, sortable: true,menuDisabled : true}
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=searchKPIItem&OPTLItemDR='+OPTLItemDR+'&start=0&limit=20&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'RowID'},
            	{name: 'OPTLItemDR'},
            	{name: 'KPIDR'},
        		{name: 'KPICode'},
            	{name: 'ItemType'},
            	{name: 'DimCode'},
            	{name: 'DetailType'},
            	{name: 'DateSec'}
       		]
    	})
    });
    var Record = Ext.data.Record.create([
    	{name: 'RowID',type:'string'},
    	{name: 'OPTLItemDR', type: 'string'},
        {name: 'KPIDR', type: 'string'},
    	{name: 'KPICode',type:'string'},
    	{name: 'ItemType', type: 'string'},
        {name: 'DimCode', type: 'string'},
    	{name: 'DetailType',type:'string'},
    	{name: 'DateSec', type: 'string'}
    ]);
    var itemKPICfgGrid = new Ext.grid.GridPanel({
        height:150,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	/*
            	rowselect: function(sm, row, rec) {
            		var id=rec.get("ID");
            		var form=itemKPICfgForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({ID:id});
             	}
             	*/
            }
        }),
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	}
        },
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        })
    });

    detailTypeCbo = new Ext.form.ComboBox({ 
            xtype: 'combo',
            width:222,
            mode:           'local',
            displayField:   'typeDesc',
            triggerAction:  'all',
            forceSelection: true,
            editable:       false,
            name:           'detailType',
            hiddenName:     'detailType',
            displayField:   'typeDesc',
            valueField:     'typevalue',
            store: new Ext.data.JsonStore({
		        fields : ['typevalue','typeDesc' ],
		        data   : [
 	    			{typevalue:'RYRS', typeDesc:'入院'}, 
 	    			{typevalue:'ZYRS', typeDesc:'在院'}, 
 	    			{typevalue:'ZRKS', typeDesc:'转入'},  	    			
	    		 	{typevalue:'ZCKS', typeDesc:'转出'}, 
 	    			{typevalue:'CYRS', typeDesc:'出院'},
 	    			{typevalue:'SWRS', typeDesc:'死亡'},
 	    			{typevalue:'TYRS', typeDesc:'退院'}, 	    		 	
 	    			{typevalue:'BZRS', typeDesc:'病重'},
 	    			{typevalue:'BWRS', typeDesc:'病危'},
 	    			{typevalue:'BEDRS', typeDesc:'在床'}, 	    			
	    		 	{typevalue:'OTHER', typeDesc:'其他'}
		        ]
		    }),
            emptyText : '请选择', 
            name: 'itemType'
	});	

	dateSecCbo = new Ext.form.ComboBox({ 
            xtype: 'combo',
            width:222,
            mode:           'local',
            displayField:   'typeDesc',
            triggerAction:  'all',
            forceSelection: true,
            editable:       false,
            name:           'dateSec',
            hiddenName:     'dateSec',
            displayField:   'typeDesc',
            valueField:     'typevalue',
            store: new Ext.data.JsonStore({
		        fields : ['typevalue','typeDesc' ],
		        data   : [
 	    			{typevalue:'begin', typeDesc:'开始'}, 
	    		 	{typevalue:'end', typeDesc:'结束'}, 
	    		 	{typevalue:'all', typeDesc:'所有'}	
	    		 	]
		    }),
            emptyText : '请选择', 
            name: 'itemType'
	});	
	
	
    var itemKPICfgForm = new Ext.FormPanel({
        frame: true,
        height: 100,
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        labelAlign : 'right',
		labelWidth : 75,
		//bodyStyle : 'padding:5px',
		layout : 'column',
		items:[
		{
			columnWidth : .45,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
							fieldLabel : '指标代码',
				            xtype:'compositefield',
				            items:[{
				            	width:195,
					            xtype:'textfield',
					            name: 'KPICode',
					            disabled:true
					            //flex:1
					        	},{
						        //width:30,
					            name: 'showKPIWin',
					            id: 'showKPIWin',
					            xtype:'button',
					            icon: '../images/uiimages/search.png',
					            handler:OnShowKPIWin        	
				
				            }],
				            anchor:'100%'
											
					},{
							fieldLabel : '出入转类别',
				            xtype:'compositefield',
				            items:[detailTypeCbo],
				            anchor:'100%'
					},{
							fieldLabel : '类型',
				            xtype:'textfield',
				            name: 'ItemType',
				            disabled:true,
				            anchor:'100%'
						}]
			},{
			columnWidth : .45,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
							fieldLabel : '维度',
				            xtype:'textfield',
				            disabled:true,
				            name: 'KPIDim',
				            id: 'KPIDim',
				            //width:162,
				            anchor:'100%'			
						},{
						fieldLabel : '日期区间',
						xtype:'compositefield',
						//width:203,
						//flex:1,
				        items:[dateSecCbo],
				        anchor:'100%'
				            //disabled:true				
					}]
		}
		]
        /*
        layout: 'table',
        defaultConfig:{width:140},
        layoutConfig: {columns:6},
        items:[
		{
        	html: '指标代码：'
        },{
            xtype: 'compositefield',
            defaults: {
            	//flex: 1
            },
            items: [{
	            xtype:'textfield',
	            name: 'KPICode',
	            disabled:true
	            //flex:1
	        	},{
		        width:30,
	            name: 'showKPIWin',
	            id: 'showKPIWin',
	            xtype:'button',
	            icon: '../images/uiimages/search.png',
	            handler:OnShowKPIWin        	

            }]        	
        },{
        	html: '维度：'
        },{
            xtype:'textfield',
            disabled:true,
            name: 'KPIDim',
            id: 'KPIDim',
            width:162
        },{
            html:'类型：'
        }, 
        {
            xtype:'textfield',
            name: 'ItemType',
            disabled:true
            //flex:1
        }
         ,{
            html:'出入转类别：'
        }, detailTypeCbo
		,{
            html:'日期区间：'
        }, dateSecCbo        
        ]
        */
    });
    //store.load({params:{start:0,limit:21}});	
	

	var kpiWin = new Ext.Window({
		id:'kpiWin',
		title:'指标类统计项配置',
        width:700,
		height:300,
		resizable:false,
		closeAction:'hide',
		layout:'border',
		modal:true,
		items:[{
			region:'north',
			height:130,
			layout:'fit',
			items:itemKPICfgForm
		},{
			region:'center',
			items:itemKPICfgGrid
		}],
        buttons: [{
            text: '<span style="line-Height:1">保存</span>',		
            icon: '../images/uiimages/filesave.png',
            handler:OnConfirm
        },{
            text: '<span style="line-Height:1">关闭</span>',
            icon: '../images/uiimages/cancel.png',
            handler: OnCancel
        }],		
		listeners:{
			'close':function(){
				this.hide();
			}
		}
	});

	this.showWin=function(){
		kpiWin.show();
		clearForm();
		
    	refresh();		
	}
	
	this.setSubWinParam=function(itemDR,itemDesc){
		OPTLItemDR=itemDR;
		
	}
	function clearForm(){
    	var form=itemKPICfgForm.getForm();
    	form.setValues({KPICode:'',KPIDim:'',detailType:'',ItemType:'',dateSec:''});
    }
    
    function OnConfirm() {

    	var form=itemKPICfgForm.getForm();

        //1、判断是否有重复类型的数据。不能有重复类型的数据
        var formItemType=form.findField('ItemType').getValue(); 
        var store=itemKPICfgGrid.getStore();
        var count=store.getCount();
        
        for(i=0;i<=count-1;i++){
        	var gridItemType=store.getAt(i).get('ItemType');
        	if(gridItemType==formItemType){
	       		Ext.MessageBox.alert("提示","该类型统计项已存在，不能重复配置！");
	       		return;        		
        	}
        }
       
        var kpiCode=form.findField('KPICode').getValue();
        var dimCode=form.findField('KPIDim').getValue();
        var detailType=form.findField('detailType').getValue();
        var dateSec=form.findField('dateSec').getValue();
        
        if(!kpiCode||!dimCode||!detailType||!dateSec){
	       		Ext.MessageBox.alert("提示","统计项数据填写不完整！");
	       		return;                	       	
        }
		
        //3、写后台数据
 
        paraValues='OPTLItemDR='+OPTLItemDR+'&KPIDR='+KPIDR+'&KPICode='+kpiCode+'&ItemType='+formItemType+'&DimCode='+dimCode+'&DetailType='+detailType+'&DateSec='+dateSec;

        var url=serviceUrl+'?action=addKpiItem&'+paraValues
		dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					//刷新grid
					refresh();
					Ext.MessageBox.alert("提示","操作成功！");

				}else{
					Ext.Msg.alert("提示","操作失败！");
					}
					
				},this);	
    }
    
    function OnCancel() {
    	kpiWin.hide();
    }
	
	function OnShowKPIWin() {
		selectKpiWin.show();
		storeKpi.load();
	}
    function refresh(){
		itemKPICfgGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=searchKPIItem&OPTLItemDR='+OPTLItemDR+'&start=0&limit=21&onePage=1'));
		itemKPICfgGrid.getStore().load();
	    itemKPICfgGrid.show();      	
    }

		/*****************************************指标选取窗口***************************************************/
	var columnModelKpi = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{header:'ID',dataIndex:'ID', width: 30, sortable: true ,menuDisabled : true
        },{header:'编码',dataIndex:'kpiCode', width: 70, sortable: true ,menuDisabled : true
        },{header:'指标名称',dataIndex:'kpiName', width: 80, sortable: true ,menuDisabled : true
        },{header:'类型',dataIndex:'category',resizable:'true',width:88,menuDisabled : true
        },{header:'维度',dataIndex:'kpiDimCode',resizable:'true',width:88,menuDisabled : true
        },{header:'报表类型',dataIndex:'dimCode',resizable:'true',width:88    ,menuDisabled : true    
        },{header:'区间',dataIndex:'section',resizable:'true',width:88,menuDisabled : true
        }
    ]);
	//定义指标的存储模型
    var storeKpi = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/mripday/mripdayItemCfg.csp?action=selectKpis&start=0&pageSize=15'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name: 'ID'},
            	{name: 'kpiCode'},
            	{name: 'kpiName'},
            	{name: 'category'},
            	{name: 'kpiDimCode'},            	
            	{name: 'dimCode'},
            	{name: 'section'}
       		]
    	})
    });
    
	//定义指标的显示表格。
	var kpiList = new Ext.grid.GridPanel({
		id:"KPISelectkpiTables",
        height:370,
        resizeAble:true,
        enableColumnResize :true,
        store: storeKpi,
        cm: columnModelKpi,
		viewConfig:{
			forceFit: true
		},
        bbar:new Ext.PagingToolbar({
            pageSize: 15,
            store: storeKpi,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到第 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
	        	'beforechange':function(pt,page){
					var kpiListKpiCode = Ext.getCmp('kpiList-kpiCode').getValue();
	        		storeKpi.proxy.setUrl(encodeURI('dhcwl/mripday/mripdayItemCfg.csp?action=selectKpis&kpiCode='+kpiListKpiCode));
	        	}
            }
        }),
        listeners :{
        	'rowdblclick':function(ele,event){
				var sm = kpiList.getSelectionModel();
				if(!sm) return;
				var record = sm.getSelected();
        		if(!record) return;
				var kpiCode = record.get("kpiCode");
				var dimCode = record.get("dimCode");
				var kpiDimCode=record.get("kpiDimCode");
				KPIDR=record.get('ID');
				//	回填
               	itemKPICfgForm.getForm().findField('KPICode').setValue(kpiCode);
               	itemKPICfgForm.getForm().findField('KPIDim').setValue(kpiDimCode);
                
                itemKPICfgForm.getForm().findField('ItemType').setValue(dimCode);    
				Ext.getCmp('selectKpiWin').hide();
			}
		}
    });
	
	//	定义指标选取窗口参数面板
	var kpiListArgsPanel = new Ext.Panel({
		monitorResize:true,
		layout:'table',
		frame:true,
		layoutConfig:{columns:3},
		items:[{
			html:'指标编码:'
		},{
			xtype:'textfield',
			id:'kpiList-kpiCode'
		},{
			xtype:'button',
			//text:'查询',
			icon: '../images/uiimages/search.png',
			listeners:{
				'click':function(){
					storeKpi.removeAll();
					var kpiListKpiCode = Ext.getCmp('kpiList-kpiCode').getValue();
					storeKpi.proxy.setUrl(encodeURI('dhcwl/mripday/mripdayItemCfg.csp?action=selectKpis&kpiCode='+kpiListKpiCode+'&start=0&pageSize=15'));
					storeKpi.load();
				}
			}
		}]
	});
	
	//	定义指标选取窗口
	var selectKpiWin = new Ext.Window({
		id:'selectKpiWin',
		title:'指标选取',
        width:800,
		height:450,
		resizable:true,
		closeAction:'hide',
		layout:'border',
		modal:true,
		items:[{
			region:'north',
			height:70,
			layout:'fit',
			items:kpiListArgsPanel
		},{
			region:'center',
			items:kpiList
		}],
		listeners:{
			'close':function(){
				this.hide();
			}
		}
	});

}