/**
 * Ϊ�����½��ڵ�(������������)
 * @param {} Node
 */
function MulStkCatGoupAdd(Node){
	var AddNodeType = Node.id.split('-')[0];
	var AddNodeRowId = Node.id.split('-')[1];
	if(typeof(AddNodeRowId) == 'undefined'){
		AddNodeRowId = '';
	}
	//�п�����Childʱ,ֻ������������; ������Child�򶥼�����(AllSCG),ֻ����������
	var SCGDisabled = (Node.hasChildNodes() && Node.childNodes && Node.childNodes[0].id.indexOf('INCSC') >= 0);
	var INCSCDisabled = (AddNodeType != 'SCG' || (Node.hasChildNodes() && Node.childNodes && Node.childNodes[0].id.indexOf('SCG') >= 0));
	var NodeAddType = new Ext.form.RadioGroup({
		id : 'NodeAddType',
		fieldLabel : '�ڵ�����',
		columns : 2,
		itemCls : 'x-check-group-alt',
		items : [
			{boxLabel:'����',name:'NodeAddType',id:'ADD_SCG',inputValue:'SCG',checked : !SCGDisabled, disabled : SCGDisabled},
			{boxLabel:'������',name:'NodeAddType',id:'ADD_INCSC',inputValue:'INCSC',checked : SCGDisabled, disabled : INCSCDisabled}
		]
	});
	
	var AddCode = new Ext.form.TextField({
		id : 'AddCode',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var AddDesc = new Ext.form.TextField({
		id : 'AddDesc',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var AddConfirmBT = new Ext.ux.Button({
		id : 'AddConfirmBT',
		text : '����',
		iconCls : 'page_save',
		handler : function(){
			var AddType = Ext.getCmp('NodeAddType').getValue().getGroupValue();
			var AddCode = Ext.getCmp('AddCode').getValue();
			var AddDesc = Ext.getCmp('AddDesc').getValue();
			//����������
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
						Msg.info('success', '�����ɹ�!');
					}else{
						Msg.info('error', '����ʧ��!');
						return false;
					}
				}
			}
			
			//������, ���й�����ʱ��, �����������Ϊ��, �򲻴���
			if(AddType == 'INCSC' && !Ext.isEmpty(SelCats) && (AddCode == '' || AddDesc == '')){
				MulStkCatGroupAddWin.close();
				Node.reload();
			}else{
				if(AddCode == ''){
					Msg.info('warning', '���벻��Ϊ��!');
					return false;
				}
				if(AddDesc == ''){
					Msg.info('warning', '���Ʋ���Ϊ��!');
					return false;
				}
				var StrParam = AddType + '^' + AddCode + '^' + AddDesc + '^' + AddNodeRowId;
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'Add', StrParam);
				if(ret === ''){
					Msg.info('success', '����ɹ�!');
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
		text : '�ر�',
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
			title : '�ڵ���Ϣ',
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
					//��������ʱ,������ѡ��
					return false;
				}
			}
		}
	});
	var NoRelationCatGrid = new Ext.grid.GridPanel({
		region : 'center',
		id : 'NoRelationCatGrid',
		title : '�������������б�',
		store : NoRelationCatStore,
		columns : [AddSm,
			{header: 'RowId', sortable: true, dataIndex: 'RowId', width : 50, hidden : true},
			{header: '����', sortable: true, dataIndex: 'Description', width : 150}
		],
		sm : AddSm,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		viewConfig : {forceFit : true}
	});
	
	var MulStkCatGroupAddWin = new Ext.Window({
		title : Node.text + '���ӽڵ�',
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
 * �޸���Ϣ(������������)
 * @param {} Node
 */
function MulStkCatGoupUpdate(Node){
	var UpdateNodeType = Node.id.split('-')[0];
	var UpdateNodeRowId = Node.id.split('-')[1];
	
	var UpdateCode = new Ext.form.TextField({
		id : 'UpdateCode',
		anchor : '90%',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var UpdateDesc = new Ext.form.TextField({
		id : 'UpdateDesc',
		anchor : '90%',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var SCGSetStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['MM', 'ҽ�ò���'], ['MO', '���ڲ���'], ['MR', '�Լ�'], ['MF', '�̶��ʲ�']]
	});
	var UpdateSCGSet = new Ext.form.ComboBox({
		fieldLabel : '���鼯��',
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
		fieldLabel : '�ۼ۱���'
	});
	
	var UpdateConfirmBT = new Ext.ux.Button({
		id : 'UpdateConfirmBT',
		text : '����',
		iconCls : 'page_save',
		handler : function(){
			var UpdateCode = Ext.getCmp('UpdateCode').getValue();
			var UpdateDesc = Ext.getCmp('UpdateDesc').getValue();
			//������, ���й�����ʱ��, �����������Ϊ��, �򲻴���
			if(UpdateCode == ''){
				Msg.info('warning', '���벻��Ϊ��!');
				return false;
			}
			if(UpdateDesc == ''){
				Msg.info('warning', '���Ʋ���Ϊ��!');
				return false;
			}
			var UpdateSCGSet = Ext.getCmp('UpdateSCGSet').getValue();
			var UpdateSpReq = Ext.getCmp('UpdateSpReq').getValue()?'Y':'';
			var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc + '^' + UpdateSCGSet + '^' + UpdateSpReq;
			if(UpdateNodeType == 'SCG'){
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'UpdateStkGrp', StrParam);
			}
			if(ret === ''){
				Msg.info('success', '����ɹ�!');
				MulStkCatGroupUpdateWin.close();
				Node.parentNode.reload(function(){this.expand(true)});
			}else{
				Msg.info('error', ret);
			}
		}
	});
	
	var UpdateCancelBT = new Ext.ux.Button({
		id : 'UpdateCancelBT',
		text : '�ر�',
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
			title : '������Ϣ',
			xtype : 'fieldset',
			items : [UpdateCode, UpdateDesc, UpdateSCGSet, UpdateSpReq]
		}],
		tbar : [UpdateConfirmBT, UpdateCancelBT]
	});
	
	var MulStkCatGroupUpdateWin = new Ext.Window({
		title : Node.text + ' �޸�������Ϣ',
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
 * �޸���Ϣ(������)
 * @param {} Node
 */
function StkCatUpdate(Node){
	var UpdateNodeType = Node.id.split('-')[0];
	var UpdateNodeRowId = Node.id.split('-')[1];
	
	var UpdateCode = new Ext.form.TextField({
		id : 'CatUpdateCode',
		anchor : '90%',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var UpdateDesc = new Ext.form.TextField({
		id : 'CatUpdateDesc',
		anchor : '90%',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var CatUpdateConfirmBT = new Ext.ux.Button({
		id : 'CatUpdateConfirmBT',
		text : '����',
		iconCls : 'page_save',
		handler : function(){
			var UpdateCode = Ext.getCmp('CatUpdateCode').getValue();
			var UpdateDesc = Ext.getCmp('CatUpdateDesc').getValue();
			//������, ���й�����ʱ��, �����������Ϊ��, �򲻴���
			if(UpdateCode == ''){
				Msg.info('warning', '���벻��Ϊ��!');
				return false;
			}
			if(UpdateDesc == ''){
				Msg.info('warning', '���Ʋ���Ϊ��!');
				return false;
			}
			var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc;
			if(UpdateNodeType == 'INCSC'){
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'UpdateStkCat', StrParam);
			}
			if(ret === ''){
				Msg.info('success', '����ɹ�!');
				StkCatUpdateWin.close();
				Node.parentNode.reload();
			}else{
				Msg.info('error', ret);
			}
		}
	});
	
	var CatUpdateCancelBT = new Ext.ux.Button({
		id : 'CatUpdateCancelBT',
		text : '�ر�',
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
			title : '�ڵ���Ϣ',
			xtype : 'fieldset',
			items : [UpdateCode, UpdateDesc]
		}],
		tbar : [CatUpdateConfirmBT, CatUpdateCancelBT]
	});
	
	var StkCatUpdateWin = new Ext.Window({
		title : Node.text + ' �޸Ŀ���������',
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