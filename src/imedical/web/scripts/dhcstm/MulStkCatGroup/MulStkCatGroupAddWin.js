/**
 * 为类组新建节点(子类组或库存分类)
 * @param {} Node
 */
function MulStkCatGoupAdd(Node){
	var AddNodeType = Node.id.split('-')[0];
	var AddNodeRowId = Node.id.split('-')[1];
	if(typeof(AddNodeRowId) == 'undefined'){
		AddNodeRowId = '';
	}
	//有库存分类Child时,只能新增库存分类; 有类组Child或顶级类组(AllSCG),只能新增类组
	var SCGDisabled = (Node.hasChildNodes() && Node.childNodes && Node.childNodes[0].id.indexOf('INCSC') >= 0);
	var INCSCDisabled = (AddNodeType != 'SCG' || (Node.hasChildNodes() && Node.childNodes && Node.childNodes[0].id.indexOf('SCG') >= 0));
	var NodeAddType = new Ext.form.RadioGroup({
		id : 'NodeAddType',
		fieldLabel : '节点类型',
		columns : 2,
		itemCls : 'x-check-group-alt',
		items : [
			{boxLabel:'类组',name:'NodeAddType',id:'ADD_SCG',inputValue:'SCG',checked : !SCGDisabled, disabled : SCGDisabled},
			{boxLabel:'库存分类',name:'NodeAddType',id:'ADD_INCSC',inputValue:'INCSC',checked : SCGDisabled, disabled : INCSCDisabled}
		]
	});
	
	var AddCode = new Ext.form.TextField({
		id : 'AddCode',
		fieldLabel : '代码',
		allowBlank : false
	});
	
	var AddDesc = new Ext.form.TextField({
		id : 'AddDesc',
		fieldLabel : '名称',
		allowBlank : false
	});
	
	var AddConfirmBT = new Ext.ux.Button({
		id : 'AddConfirmBT',
		text : '保存',
		iconCls : 'page_save',
		handler : function(){
			var AddType = Ext.getCmp('NodeAddType').getValue().getGroupValue();
			var AddCode = Ext.getCmp('AddCode').getValue();
			var AddDesc = Ext.getCmp('AddDesc').getValue();
			//关联库存分类
			if(AddType == 'INCSC'){
				var IncscStr = '';
				var SelCats = NoRelationCatGrid.getSelectionModel().getSelections();
				if(!Ext.isEmpty(SelCats)){
					for(var i = 0, len = SelCats.length; i < len; i++){
						var Incsc = SelCats[i].get('RowId');
						if(IncscStr == ''){
							IncscStr = Incsc;
						}else{
							IncscStr = IncscStr + '^' + Incsc;
						}
					}
					var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'ScgRelaIncsc', AddNodeRowId, IncscStr);
					if(ret == ''){
						Msg.info('success', '关联成功!');
					}else{
						Msg.info('error', '关联失败!');
						return false;
					}
				}
			}
			
			//库存分类, 且有关联的时候, 若代码或名称为空, 则不处理
			if(AddType == 'INCSC' && !Ext.isEmpty(SelCats) && (AddCode == '' || AddDesc == '')){
				MulStkCatGroupAddWin.close();
				Node.reload();
			}else{
				if(AddCode == ''){
					Msg.info('warning', '代码不可为空!');
					return false;
				}
				if(AddDesc == ''){
					Msg.info('warning', '名称不可为空!');
					return false;
				}
				var StrParam = AddType + '^' + AddCode + '^' + AddDesc + '^' + AddNodeRowId;
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'Add', StrParam);
				if(ret === ''){
					Msg.info('success', '保存成功!');
					MulStkCatGroupAddWin.close();
					Node.reload();
				}else{
					Msg.info('error', ret);
				}
			}
		}
	});
	
	var AddCancelBT = new Ext.ux.Button({
		id : 'AddCancelBT',
		text : '关闭',
		iconCls : 'page_close',
		handler : function(){
			MulStkCatGroupAddWin.close();
		}
	});
	
	var AddFormPanel = new Ext.form.FormPanel({
		region : 'north',
		frame : true,
		height : 170,
		labelAlign : 'right',
		items : [{
			title : '节点信息',
			xtype : 'fieldset',
			items : [NodeAddType, AddCode, AddDesc]
		}],
		tbar : [AddConfirmBT, AddCancelBT]
	});
	
	var NoRelationCatStore = new Ext.data.JsonStore({
		url : DictUrl + 'mulstkcatgroupaction.csp?actiontype=NoRelationCat',
		totalProperty : 'results',
		root : 'rows',
		fields : ['RowId', 'Description'],
		autoLoad : true,
		baseParams : {
			start : 0,
			limit : 999
		}
	});
	var AddSm = new Ext.grid.CheckboxSelectionModel({
		header : '',
		listeners : {
			beforerowselect : function(sm, rowIndex, keepExisting, record){
				var AddType = Ext.getCmp('NodeAddType').getValue().getGroupValue();
				if(AddType == 'SCG'){
					//新增类组时,不允许选择
					return false;
				}
			}
		}
	});
	var NoRelationCatGrid = new Ext.grid.GridPanel({
		region : 'center',
		id : 'NoRelationCatGrid',
		title : '待关联库存分类列表',
		store : NoRelationCatStore,
		columns : [AddSm,
			{header: 'RowId', sortable: true, dataIndex: 'RowId', width : 50, hidden : true},
			{header: '名称', sortable: true, dataIndex: 'Description', width : 150}
		],
		sm : AddSm,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		viewConfig : {forceFit : true}
	});
	
	var MulStkCatGroupAddWin = new Ext.Window({
		title : Node.text + '增加节点',
		width : 400,
		height : 400,
		plain : true,
		modal : true,
		layout : 'border',
		labelAlign : 'right',
		items : [AddFormPanel, NoRelationCatGrid]
	});
	
	MulStkCatGroupAddWin.show();
}


/**
 * 修改信息(子类组或库存分类)
 * @param {} Node
 */
function MulStkCatGoupUpdate(Node){
	var UpdateNodeType = Node.id.split('-')[0];
	var UpdateNodeRowId = Node.id.split('-')[1];
	
	var UpdateCode = new Ext.form.TextField({
		id : 'UpdateCode',
		anchor : '90%',
		fieldLabel : '代码',
		allowBlank : false
	});
	
	var UpdateDesc = new Ext.form.TextField({
		id : 'UpdateDesc',
		anchor : '90%',
		fieldLabel : '名称',
		allowBlank : false
	});
	
	var SCGSetStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['MM', '医用材料'], ['MO', '后勤材料'], ['MR', '试剂'], ['MF', '固定资产']]
	});
	var UpdateSCGSet = new Ext.form.ComboBox({
		fieldLabel : '类组集合',
		anchor : '90%',
		id : 'UpdateSCGSet',
		store : SCGSetStore,
		mode : 'local',
		triggerAction : 'all',
		valueField : 'RowId',
		displayField : 'Description',
		valueNotFoundText : ''
	});

	var UpdateSpReq = new Ext.form.Checkbox({
		id : 'UpdateSpReq',
		anchor : '90%',
		fieldLabel : '售价必填'
	});
	
	var UpdateConfirmBT = new Ext.ux.Button({
		id : 'UpdateConfirmBT',
		text : '保存',
		iconCls : 'page_save',
		handler : function(){
			var UpdateCode = Ext.getCmp('UpdateCode').getValue();
			var UpdateDesc = Ext.getCmp('UpdateDesc').getValue();
			//库存分类, 且有关联的时候, 若代码或名称为空, 则不处理
			if(UpdateCode == ''){
				Msg.info('warning', '代码不可为空!');
				return false;
			}
			if(UpdateDesc == ''){
				Msg.info('warning', '名称不可为空!');
				return false;
			}
			var UpdateSCGSet = Ext.getCmp('UpdateSCGSet').getValue();
			var UpdateSpReq = Ext.getCmp('UpdateSpReq').getValue()?'Y':'';
			var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc + '^' + UpdateSCGSet + '^' + UpdateSpReq;
			if(UpdateNodeType == 'SCG'){
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'UpdateStkGrp', StrParam);
			}
			if(ret === ''){
				Msg.info('success', '保存成功!');
				MulStkCatGroupUpdateWin.close();
				Node.parentNode.reload(function(){this.expand(true)});
			}else{
				Msg.info('error', ret);
			}
		}
	});
	
	var UpdateCancelBT = new Ext.ux.Button({
		id : 'UpdateCancelBT',
		text : '关闭',
		iconCls : 'page_close',
		handler : function(){
			MulStkCatGroupUpdateWin.close();
		}
	});
	
	var UpdateFormPanel = new Ext.form.FormPanel({
		region : 'center',
		frame : true,
		autoHeight : true,
		labelAlign : 'right',
		items : [{
			title : '类组信息',
			xtype : 'fieldset',
			items : [UpdateCode, UpdateDesc, UpdateSCGSet, UpdateSpReq]
		}],
		tbar : [UpdateConfirmBT, UpdateCancelBT]
	});
	
	var MulStkCatGroupUpdateWin = new Ext.Window({
		title : Node.text + ' 修改类组信息',
		width : 300,
		autoHeight : true,
		plain : true,
		modal : true,
		layout : 'form',
		labelAlign : 'right',
		items : [UpdateFormPanel],
		listeners : {
			show : function(){
				if(UpdateNodeType == 'SCG'){
					var Info = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'GetStkGrpInfo', UpdateNodeRowId);
				}
				var InfoArr = Info.split('^');
				var Code = InfoArr[0], Desc = InfoArr[1], ScgSet = InfoArr[3], SpReq = InfoArr[4];
				Ext.getCmp('UpdateCode').setValue(Code);
				Ext.getCmp('UpdateDesc').setValue(Desc);
				Ext.getCmp('UpdateSCGSet').setValue(ScgSet);
				Ext.getCmp('UpdateSpReq').setValue(SpReq);
			}
		}
	});
	
	MulStkCatGroupUpdateWin.show();
}

/**
 * 修改信息(库存分类)
 * @param {} Node
 */
function StkCatUpdate(Node){
	var UpdateNodeType = Node.id.split('-')[0];
	var UpdateNodeRowId = Node.id.split('-')[1];
	
	var UpdateCode = new Ext.form.TextField({
		id : 'CatUpdateCode',
		anchor : '90%',
		fieldLabel : '代码',
		allowBlank : false
	});
	
	var UpdateDesc = new Ext.form.TextField({
		id : 'CatUpdateDesc',
		anchor : '90%',
		fieldLabel : '名称',
		allowBlank : false
	});
	
	var CatUpdateConfirmBT = new Ext.ux.Button({
		id : 'CatUpdateConfirmBT',
		text : '保存',
		iconCls : 'page_save',
		handler : function(){
			var UpdateCode = Ext.getCmp('CatUpdateCode').getValue();
			var UpdateDesc = Ext.getCmp('CatUpdateDesc').getValue();
			//库存分类, 且有关联的时候, 若代码或名称为空, 则不处理
			if(UpdateCode == ''){
				Msg.info('warning', '代码不可为空!');
				return false;
			}
			if(UpdateDesc == ''){
				Msg.info('warning', '名称不可为空!');
				return false;
			}
			var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc;
			if(UpdateNodeType == 'INCSC'){
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'UpdateStkCat', StrParam);
			}
			if(ret === ''){
				Msg.info('success', '保存成功!');
				StkCatUpdateWin.close();
				Node.parentNode.reload();
			}else{
				Msg.info('error', ret);
			}
		}
	});
	
	var CatUpdateCancelBT = new Ext.ux.Button({
		id : 'CatUpdateCancelBT',
		text : '关闭',
		iconCls : 'page_close',
		handler : function(){
			StkCatUpdateWin.close();
		}
	});
	
	var UpdateFormPanel = new Ext.form.FormPanel({
		region : 'center',
		frame : true,
		autoHeight : true,
		labelAlign : 'right',
		items : [{
			title : '节点信息',
			xtype : 'fieldset',
			items : [UpdateCode, UpdateDesc]
		}],
		tbar : [CatUpdateConfirmBT, CatUpdateCancelBT]
	});
	
	var StkCatUpdateWin = new Ext.Window({
		title : Node.text + ' 修改库存分类名称',
		width : 300,
		autoHeight : true,
		plain : true,
		modal : true,
		layout : 'form',
		labelAlign : 'right',
		items : [UpdateFormPanel],
		listeners : {
			show : function(){
				if(UpdateNodeType == 'INCSC'){
					var Info = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'GetStkCatInfo', UpdateNodeRowId);
				}
				var Code = Info.split('^')[0], Desc = Info.split('^')[1];
				Ext.getCmp('CatUpdateCode').setValue(Code);
				Ext.getCmp('CatUpdateDesc').setValue(Desc);
			}
		}
	});
	
	StkCatUpdateWin.show();
}