/// 名称: 全院床位查询
/// 编写者： 基础数据平台组 、谷雪萍
/// 编写日期: 2015-7-6
/// 最后修改日期: 2015-7-7

Ext.onReady(function() {
    
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CheckCTBed&pClassQuery=GetList";
	var myPACWardRoom_Room_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACRoom&pClassQuery=GetDataForCmb1";
	var BedType_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBedType&pClassQuery=GetDataForCmb1";
	var CTLoc_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CheckCTBed&pClassQuery=GetDataForCmb1";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
   
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},
			[{ name: 'BEDRowID', mapping:'BEDRowID',type: 'string'},
			 { name: 'PAWARDDesc',mapping:'PAWARDDesc', type: 'string' },
           { name: 'BEDCode',mapping:'BEDCode', type: 'string' },
           { name: 'BEDBedTypeDesc',mapping:'BEDBedTypeDesc', type: 'string' },
           { name: 'BEDRoomDesc', mapping:'BEDRoomDesc',type: 'string'},      
           { name: 'IfUsing', mapping:'IfUsing',type: 'string' },
            { name: 'price', mapping:'price',type: 'string' }//列的映射
			]),
		remoteSort: true
    });	
    
	ds.load({
    	params:{start:0, limit:pagesize},
    	callback: function(records, options, success){
		}
	}); //加载数据
	var paging= new Ext.PagingToolbar({
        pageSize: pagesize,
        store: ds,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
		          "change":function (t,p)
		         { 
		             pagesize=this.pageSize;
		         }
        }
    })		
    var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
	
	
    //搜索工具条
	var btnSearch=new Ext.Button({
        id:'btnSearch',
        iconCls:'icon-search',
        text:'搜索',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
        handler:function(){
        	grid.getStore().baseParams={			
				code:Ext.getCmp("TextBedCode").getValue(),
				loc:Ext.getCmp("CTLoc").getValue(),
				type:Ext.getCmp("bedType").getValue(),
				room:Ext.getCmp("room").getValue(),
				using:Ext.getCmp("TextIfUsing").getValue()			
			};
			grid.getStore().load({
				params : {
					start : 0,
					limit : pagesize
				}
			});
        }
    });
    
	//刷新工作条
	var btnRefresh=new Ext.Button({
        id:'btnRefresh',
        iconCls:'icon-refresh',
        text:'重置',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
        handler:function(){  	
			Ext.getCmp("TextBedCode").reset();
			Ext.getCmp("CTLoc").reset();
			Ext.getCmp("bedType").reset();
			Ext.getCmp("room").reset();
			Ext.getCmp("TextIfUsing").reset();
			grid.getStore().baseParams={};
			grid.getStore().load({params:{start:0, limit:pagesize}});
   		}
    });
    
    var myPACWardRoom_ds_Room = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({ url : myPACWardRoom_Room_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'ROOMRowID', 'ROOMDesc' ])
		});
	var tb=new Ext.Toolbar({
        id:'tb',
 		items:['床代码：',
            {
			xtype: 'textfield',
			width:80,
			disabled : Ext.BDP.FunLib.Component.DisableFlag('TextBedCode'),
			id: 'TextBedCode'
			},
			 '-',
			'病区',
            {
						                //fieldLabel: '<font color=red>*</font>床类型',
						                name: 'CTLocDR',
						                id:'CTLoc',
						   				xtype:'combo',
						   				hiddenName : 'CTLocDR',
										mode : 'remote',
										pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 250,
										store : new Ext.data.Store({
													autoLoad : true,
													proxy : new Ext.data.HttpProxy({ url : CTLoc_ACTION_URL }),
													reader : new Ext.data.JsonReader({
																totalProperty : 'total',
																root : 'data',
																successProperty : 'success'
															}, [ 'WARDRowId', 'WARDDesc' ])
												}),
										queryParam : 'desc',
										triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										typeAhead : true,
										minChars : 1,
										valueField : 'WARDRowId',
										displayField : 'WARDDesc'
						            },
            '-',
			'床类型',
            {
						                //fieldLabel: '<font color=red>*</font>床类型',
						                name: 'batchBEDBedTypeDR',
						                id:'bedType',
						   				xtype:'combo',
						   				hiddenName : 'BEDBedTypeDR',
										mode : 'remote',
										pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 250,
										store : new Ext.data.Store({
													autoLoad : true,
													proxy : new Ext.data.HttpProxy({ url : BedType_ACTION_URL }),
													reader : new Ext.data.JsonReader({
																totalProperty : 'total',
																root : 'data',
																successProperty : 'success'
															}, [ 'BEDTPRowId', 'BEDTPDesc' ])
												}),
										queryParam : 'desc',
										triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										typeAhead : true,
										minChars : 1,
										valueField : 'BEDTPRowId',
										displayField : 'BEDTPDesc'
						            },
			'-',
			'房间：',
            {
							xtype : 'combo',
							//fieldLabel : '<font color=red>*</font>房间',
							name : 'ROOMRoomDR',
							id:'room',
							hiddenName : 'ROOMRoomDR',
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							store : myPACWardRoom_ds_Room,
							queryParam : 'desc',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							valueField : 'ROOMRowID',
							displayField : 'ROOMDesc'
			},
			'-',
			'是否在用：',
            {
						xtype : 'combo',
						id : 'TextIfUsing',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('TextIfUsing'),
						width : 80,
						mode : 'local',
						triggerAction : 'all',
						// forceSelection : true,
						// selectOnFocus : false,
						typeAhead : true,
						minChars : 1,
						listWidth : 140,
						shadow : false,
						valueField : 'value',
						displayField : 'name',
						// editable:false,
						store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												value : 'Y',
												name : 'Yes'
											}, {
												value : 'N',
												name : 'No'
											}]
								})
			},
            '-',
            btnSearch,
			'-',
			btnRefresh
        ]
	});
	
	

    var grid = new Ext.grid.GridPanel({
		id:'grid',
		region: 'center',
		width:900,
		height:500,
		closable:true,
	    store: ds,
	    trackMouseOver: true,
	    columns: [
	            sm,
	            { header: 'BEDRowID', width: 160, sortable: true, dataIndex: 'BEDRowID', hidden : true},
	            { header: '病区', width: 120, sortable: true, dataIndex: 'PAWARDDesc' },
	            { header: '床代码', width: 120, sortable: true, dataIndex: 'BEDCode' },
		        { header: '床类型', width: 120, sortable: true, dataIndex: 'BEDBedTypeDesc' },
		        { header: '房间', width: 120, sortable: true, dataIndex: 'BEDRoomDesc' },
	            { header: '是否在用', width: 85, sortable: true, renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon, dataIndex: 'IfUsing' },
	            { header: '目前金额', width: 120, sortable: true, dataIndex: 'price' }
	        ],
	    stripeRows: true,
	   // tools:Ext.BDP.FunLib.Component.HelpMsg,
	    loadMask: { msg: '数据加载中,请稍候...' },
	    title: '全院床位查询',
	    // config options for stateful behavior
	    stateful: true,
	    viewConfig: {
				forceFit: true
			},
		bbar:paging ,
		tbar:tb,			
	    stateId: 'grid'
    });
   
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [grid]
    });

});
