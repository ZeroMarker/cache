function InitWorkItemEdit(objWorkFlow){
	var obj = new Object();
	obj.WFlowID = objWorkFlow.get('ID');
	obj.WFItemID = '';
	
	obj.txtItemDesc = Common_TextField("txtItemDesc","操作项目");
	obj.txtItemAlias = Common_TextField("txtItemAlias","别名");
	obj.cboItemType = Common_ComboToDic("cboItemType","项目类型","WorkType");
	obj.cboSubFlow = Common_ComboToDic("cboSubFlow","操作流程","WorkSubFlow");
	obj.cbgPostStep = Common_RadioGroupToDC("cbgPostStep","操作步骤","WorkFlowStep",3);
	obj.cboSysOpera = Common_ComboToDic("cboSysOpera","系统操作","SysOperation",'^-');
	obj.cbgPreStep = Common_RadioGroupToDC("cbgPreStep","前提步骤","WorkFlowStep",3);
	obj.chkCheckUser = Common_Checkbox("chkCheckUser","校验用户");
	obj.chkBeRequest = Common_Checkbox("chkBeRequest","需要申请");
	obj.chkBatchOper = Common_Checkbox("chkBatchOper","批次操作");
	obj.cbgMRCategory = Common_RadioGroupToDC("cbgMRCategory","病历类型","MRCategory",2);
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	//前置操作项目列表
	obj.GridPreItemsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridPreItemsStore = new Ext.data.Store({
		proxy: obj.GridPreItemsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItemID'
		},
		[
			{name: 'IsChecked', mapping : 'IsChecked'}
			,{name: 'ItemID', mapping: 'ItemID'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
		])
	});
	obj.GridPreItems = new Ext.grid.GridPanel({
		id : 'GridPreItems'
		,store : obj.GridPreItemsStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,height : 140
		//,loadMask : true
		,hideHeaders : true
		,columns: [
			{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '操作项目', width: 150, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.btnMoveUp = new Ext.Button({
		id : 'btnMoveUp'
		,iconCls : 'icon-moveup'
		,text : '<span>上移</span>'
		,width : 80
	});
	obj.btnMoveDown = new Ext.Button({
		id : 'btnMoveDown'
		,iconCls : 'icon-movedown'
		,text : '<span>下移</span>'
		,width : 80
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 80
		,text : '保存'
	});
	
	//工作流项目列表
	obj.gridWFItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridWFItemStore = new Ext.data.Store({
		proxy: obj.gridWFItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItemID'
		},
		[
			{name: 'ItemID', mapping: 'ItemID'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'ItemIndex', mapping: 'ItemIndex'}
			,{name: 'ItemAlias', mapping: 'ItemAlias'}
			,{name: 'WFItemID', mapping: 'WFItemID'}
			,{name: 'TypeID', mapping: 'TypeID'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'PreStepCode', mapping: 'PreStepCode'}
			,{name: 'PreStepDesc', mapping: 'PreStepDesc'}
			,{name: 'PostStepCode', mapping: 'PostStepCode'}
			,{name: 'PostStepDesc', mapping: 'PostStepDesc'}
			,{name: 'SysOperaID', mapping: 'SysOperaID'}
			,{name: 'SysOperaDesc', mapping: 'SysOperaDesc'}
			,{name: 'CheckUser', mapping: 'CheckUser'}
			,{name: 'CheckUserDesc', mapping: 'CheckUserDesc'}
			,{name: 'BeRequest', mapping: 'BeRequest'}
			,{name: 'BeRequestDesc', mapping: 'BeRequestDesc'}
			,{name: 'BatchOper', mapping: 'BatchOper'}
			,{name: 'BatchOperDesc', mapping: 'BatchOperDesc'}
			,{name: 'MRCategory', mapping: 'MRCategory'}
			,{name: 'MRCategoryDesc', mapping: 'MRCategoryDesc'}
			,{name: 'SubFlowID', mapping: 'SubFlowID'}
			,{name: 'SubFlowDesc', mapping: 'SubFlowDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.gridWFItem = new Ext.grid.GridPanel({
		id : 'gridWFItem'
		,store : obj.gridWFItemStore
		,columnLines:true
		,region : 'center'
		,viewConfig: {forceFit: true}
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '操作项目', width: 100, dataIndex: 'ItemDesc', align: 'left'
				,renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					var ItemDesc = rd.get("ItemDesc");
					var ItemIndex = rd.get("ItemIndex");
					var ItemAlias = rd.get("ItemAlias");
					if (ItemIndex != '') {
						return ItemDesc + '(' + ItemIndex + ')';
					} else {
						return ItemDesc;
					}
				}
			}
			,{header: '项目类型', width: 80, dataIndex: 'TypeDesc', align: 'center'}
			,{header: '操作<br>流程', width: 80, dataIndex: 'SubFlowDesc', align: 'center'}
			,{header: '前提步骤', width: 80, dataIndex: 'PreStepDesc', align: 'center'}
			,{header: '当前<br>步骤', width: 50, dataIndex: 'PostStepDesc', align: 'center'}
			,{header: '系统操作', width: 80, dataIndex: 'SysOperaDesc', align: 'center'}
			,{header: '是否<br>有效', width: 50, dataIndex: 'IsActiveDesc', align: 'center'}
			,{header: '允许<br>批次<br>操作', width: 50, dataIndex: 'BatchOperDesc', align: 'center'}
			,{header: '是否<br>校验<br>用户', width: 50, dataIndex: 'CheckUserDesc', align: 'center'}
			,{header: '是否<br>申请', width: 50, dataIndex: 'BeRequestDesc', align: 'center'}
		]
		,bbar : [obj.btnMoveUp,obj.btnMoveDown,'->',obj.btnSave]
		,viewConfig : {
			forceFit : true
		}
	});
	
	obj.inputWFItem = new Ext.Panel({
		id :'inputWFItem'
		,width : 240
		,layout : 'form'
		,frame : true
		,region : 'east'
		,labelAlign : 'right'
		,labelWidth : 60
		,items:[
			obj.txtItemDesc
			,obj.txtItemAlias
			,obj.cboItemType
			,obj.cboSubFlow
			,obj.cboSysOpera
			,obj.cbgPreStep
			,obj.cbgPostStep
			,{
				layout : 'column'
				,items: [
					{
						width : 68
						,html : '<div style="width=100%;text-align:right;font-size:14px;">前提操作&nbsp;&nbsp;</div>'
					},{
						columnWidth : 1
						,layout : 'fit'
						,buttonAlign : 'left'
						,items: [obj.GridPreItems]
					}
				]
			}
			,obj.chkIsActive
			,obj.chkCheckUser
			,obj.chkBeRequest
			,obj.chkBatchOper
			,obj.cbgMRCategory
			,obj.txtResume
		]
	});
	
	obj.WorkItemEditWin = new Ext.Window({
		id : 'WorkItemEditWin'
		,title : '工作流项目配置'
		,width : 800
		,plain : true
		,height : 560
		,bodyBorder : 'padding:0 0 0 0'
		,modal : true
		,resizable:false
		,layout : 'border'
		,frame  : true
		,items:[
			obj.gridWFItem
			,obj.inputWFItem
		]
	});
	
	obj.gridWFItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.WorkFlowSrv';
		param.QueryName = 'QryWFCfgItem';
		param.Arg1 = obj.WFlowID;
		param.ArgCnt = 1;
	});	
	obj.gridWFItemStore.load({});
	
	obj.GridPreItemsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.WorkFlowSrv';
		param.QueryName = 'QryWFCfgPreItem';
		param.Arg1 = obj.WFItemID;
		param.ArgCnt = 1;
	});
	obj.GridPreItemsStore.load({});
	
	InitWorkItemEditEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}