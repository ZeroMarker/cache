
function InitFPItemExtraWin(FPItemID){
	var obj = new Object();
	obj.FPItemID = FPItemID;
	obj.FPIExtraID = "";
	obj.EItemID = "";
	obj.Ex_txtEItemDesc = Common_TextField("Ex_txtEItemDesc","附加项");
	obj.Ex_txtEItemDesc.setDisabled(true);
	obj.Ex_txtIndex = Common_TextField("Ex_txtIndex","显示顺序");
	obj.Ex_txtInitValue = Common_TextField("Ex_txtInitValue","初始值");
	obj.Ex_chkIsNeed = Common_Checkbox("Ex_chkIsNeed","是否必填");
	obj.Ex_chkIsActive = Common_Checkbox("Ex_chkIsActive","是否有效");
	obj.Ex_txtResume = Common_TextField("Ex_txtResume","备注");
	
	obj.Ex_chkIsViewAll  = Common_Checkbox("Ex_chkIsViewAll","显示全部");
	
	//关联数据项
	obj.Ex_cboDataItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.Ex_cboDataItemStore = new Ext.data.Store({
		proxy: obj.Ex_cboDataItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'ID'}
			,{name: 'DICode', mapping: 'DICode'}
			,{name: 'DIDesc', mapping: 'DIDesc'}
		])
	});

	obj.Ex_cboDataItem = new Ext.form.ComboBox({
		id : 'Ex_cboDataItem'
		,fieldLabel : '数据项'
		,labelSeparator :''
		,width : 100
		,store : obj.Ex_cboDataItemStore
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,triggerAction : 'all'
		,minListWidth:100
		,valueField : 'ID'
		,displayField : 'DIDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		
	});
	
	obj.Ex_gridWFEItemListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.Ex_gridWFEItemListStore = new Ext.data.Store({
		proxy: obj.Ex_gridWFEItemListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EItemID'
		},
		[
			{name: 'EItemID', mapping : 'EItemID'}
			,{name: 'EItemDesc', mapping : 'EItemDesc'}
			,{name: 'EItemTpDesc', mapping : 'EItemTpDesc'}
			,{name: 'EItemDicDesc', mapping: 'EItemDicDesc'}
			,{name: 'WFEItemID', mapping : 'WFEItemID'}
			,{name: 'WFEIIndex', mapping : 'WFEIIndex'}
			,{name: 'WFEIDataID', mapping: 'WFEIDataID'}
			,{name: 'WFEIDataCode', mapping: 'WFEIDataCode'}
			,{name: 'WFEIDataDesc', mapping: 'WFEIDataDesc'}
			,{name: 'WFEIInitVal', mapping: 'WFEIInitVal'}
			,{name: 'WFEIIsNeed', mapping: 'WFEIIsNeed'}
			,{name: 'WFEIIsActive', mapping: 'WFEIIsActive'}
			,{name: 'WFEIResume', mapping: 'WFEIResume'}
		])
	});
	obj.Ex_gridWFEItemList = new Ext.grid.EditorGridPanel({
		id : 'Ex_gridWFEItemList'
		,store : obj.Ex_gridWFEItemListStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '附加项', width: 120, dataIndex: 'EItemDesc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '数据<br>类型', width: 60, dataIndex: 'EItemTpDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '字典', width: 120, dataIndex: 'EItemDicDesc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '标记', width: 50, dataIndex: 'WFEItemID', sortable: true, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					if (v !== '') {
						return "<IMG src='../scripts/dhcwmr/img/update.png'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/remove.png'>";
					}
				}
			}
			,{header: '显示<br>顺序', width: 100, dataIndex: 'WFEIIndex', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '是否<br>必填', width: 50, dataIndex: 'WFEIIsNeed', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '是否<br>有效', width: 50, dataIndex: 'WFEIIsActive', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '数据项<br>(首页)', width: 100, dataIndex: 'WFEIDataDesc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '初始值', width: 100, dataIndex: 'WFEIInitVal', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '备注', width: 200, dataIndex: 'WFEIResume', sortable: true, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.Ex_gridWFEItemListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });

	obj.Ex_btnUpdate = new Ext.Button({
		id : 'Ex_btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '更新'
	});
	
	obj.Ex_btnDelete = new Ext.Button({
		id : 'Ex_btnDelete'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '删除'
	});
	
	obj.winFPItemExtra = new Ext.Window({
		id : 'winFPItemExtra'
		,title : '编目附加项维护'
		,width : 800
		,plain : true
		,height : 560
		,bodyBorder : 'padding:0 0 0 0'
		,modal : true
		,resizable:false
		,layout : 'border'
		,frame  : true
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 70,
						layout : 'form',
						frame : true,
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										width:210
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 50
										,items: [obj.Ex_txtEItemDesc]
									},{
										width:120
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.Ex_txtIndex]
									},{
										width:100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.Ex_chkIsNeed]
									},{
										width:100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.Ex_chkIsActive]
									},{
										width:20
									},{
										width:100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.Ex_chkIsViewAll]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:210
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 50
										,items: [obj.Ex_cboDataItem]
									},{
										width:220
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.Ex_txtInitValue]
									},{
										width:260
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.Ex_txtResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						items : [
							obj.Ex_gridWFEItemList
						]
					}
				],
				bbar : [obj.Ex_btnUpdate,obj.Ex_btnDelete,'->','…']
			}
		]
	});
	
	obj.Ex_gridWFEItemListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.FPService.FPExtraItemSrv"
		param.QueryName = "QryWFEItem"
		param.Arg1 = obj.FPItemID
		param.Arg2 = (Common_GetValue('Ex_chkIsViewAll') ? 1 : 0);
		param.ArgCnt = 2;
	});
	
	//数据项
	obj.Ex_cboDataItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.FPService.DataItemSrv"
		param.QueryName = "QryItemList"
		param.Arg1 = "" //obj.Ex_cboDataItem.getRawValue();
		param.ArgCnt = 1;
	});
	
	InitFPItemExtraWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

