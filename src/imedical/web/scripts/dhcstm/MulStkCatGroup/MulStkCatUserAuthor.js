// ����:�༶������Ȩ

var gGroupId = session['LOGON.GROUPID'];
var PageSize = 20;
var DEFA_SCG = '';				//ȱʡ����
var DEFA_CLS = 'page_family';	//ȱʡ������cls

/**
 * �ж�treepanel�Ƿ�ȫ��չ��
 * @param {} treepanel
 * @return {bool}
 */
function IsTreeLoaded(treepanel){
	var TREE_LOADED = true;
	treepanel.getRootNode().cascade(function(node){
		if(TREE_LOADED === true && !node.isExpanded()){
			TREE_LOADED = false;
			return false;
		}
	});
	return TREE_LOADED;
}

//>>>>>>����������>>>>>>
function cascadeParent(){
	var pn = this.parentNode;
	if (!pn || !Ext.isBoolean(this.attributes.checked)) return;
	if (this.attributes.checked) {
		pn.getUI().toggleCheck(true);
	}else {
		var b = true;
		Ext.each(pn.childNodes, function(n){
			if (n.getUI().isChecked()){
				return b = false;
			}
			return true;
		});
		if (b) pn.getUI().toggleCheck(false);
	}
	pn.cascadeParent();
}
function cascadeChildren(){
	var ch = this.attributes.checked;
	if (!Ext.isBoolean(ch)) return;
	Ext.each(this.childNodes, function(n){
		n.getUI().toggleCheck(ch);
		n.cascadeChildren();
	});
}
function cascadeFellows(){
	var ch = this.attributes.checked;
	if (!Ext.isBoolean(ch)) return;
	if(this.id.split('-')[0] == 'INCSC'){
		var fellows = this.parentNode.childNodes;
		for(var i = 0, fellowsNum = fellows.length; i < fellowsNum; i++){
			fellow = fellows[i];
			if(fellow.id.split('-')[0] == 'INCSC' && fellow.attributes.checked != ch){
				fellow.getUI().toggleCheck(ch);
			}
		}
	}
}
Ext.apply(Ext.tree.TreeNode.prototype, {
	cascadeFellows: cascadeFellows,
	cascadeParent: cascadeParent,
	cascadeChildren: cascadeChildren
});
Ext.override(Ext.tree.TreeEventModel, {
	onCheckboxClick: Ext.tree.TreeEventModel.prototype.onCheckboxClick.createSequence(function(e, node){
		node.cascadeFellows();		//2016-03-14 add ͬһ�����µĿ�����,����ͬʱ��Ȩ
		node.cascadeParent();
		node.cascadeChildren();
	}),
	onNodeDblClick: Ext.emptyFn		//2016-03-15 ˫���¼��ÿ�
});
//<<<<<<����������<<<<<<

var SaveBT = new Ext.ux.Button({
	id : 'SaveBT',
	text : '��Ȩ',
	iconCls : 'page_save',
	handler : function(){
		Save();
	}
});

function Save(){
	var SelRec = UserGrid.getSelectionModel().getSelected();
	if(Ext.isEmpty(SelRec)){
		Msg.info('warning', '��ѡ����Ҫ��Ȩ�Ķ���!');
		return false;
	}else{
		var UserId = SelRec.get('RowId');
	}
	var LocId = Ext.getCmp('UserLoc').getValue();
	if(Ext.isEmpty(LocId)){
		Msg.info('warning', '���Ҳ���Ϊ��!');
		return false;
	}
	var AuthorPar = LocId + '^' + UserId;
	
	var Str = '';
	var f = function(node) {
		var NodeType = node.id.split('-')[0];
		var NodeRowId = node.id.split('-')[1];
		var NodeChecked = this.attributes.checked;
		if(NodeChecked && NodeType == 'SCG' && node.hasChildNodes() && node.childNodes && node.childNodes[0].id.indexOf('INCSC') >= 0){
			if (Str == '') Str = NodeRowId;
			else Str = Str + ',' + NodeRowId;
		}
	}
	Ext.getCmp('MulCatGroupPanel').getRootNode().cascade(f);
	var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'SaveUserAuthorData', Str, AuthorPar);
	if(ret != ''){
		Msg.info('error', '��Ȩʧ��:' + ret);
	}else{
		Msg.info('success', '��Ȩ�ɹ�!');
		var SelRec = UserGrid.getSelectionModel().getSelected();
		UserGrid.getSelectionModel().fireEvent('rowselect', UserGrid.getSelectionModel(), UserGrid.getStore().indexOf(SelRec), SelRec);
	}
}

var MulCatGroupPanel = new Ext.tree.TreePanel({
	region : 'center',
	id : 'MulCatGroupPanel',
	autoScroll : true,
	enableDD : false,
	split : true,
	containerScroll : true,
	border : false,
	loader : null,
	lines : true,
	root : {
		nodeType : 'async',
		text : '����',
		draggable : false,
		id: 'AllSCG',
		expanded : true
	},
	tbar : [SaveBT, '-', '<font color=blue>"����"��ǵ�ΪĬ����ʾ����(������ײ�����ͨ���Ҽ��˵�����,δ��ѡ��Աʱ��ʾ���ǿ���Ĭ��ֵ)</font>'],
	contextMenu: new Ext.menu.Menu({
		items: [{
			id: 'SetDefaultMenu',
			text : '����Ĭ����ʾ����'
		}],
		listeners: {
			itemclick : function(item) {
				var n = item.parentMenu.contextNode;
				switch (item.id) {
					case 'SetDefaultMenu' :
						SetDefaultScg(n);
						break;
				}
			}
		}
	}),
	listeners : {
		contextmenu : function(node, e) {
			node.select();
			if(!node.attributes.checked || node.id.split('-')[0] != 'SCG'
			|| (node.hasChildNodes() && node.childNodes && node.childNodes[0].id.indexOf('INCSC') == -1)){
				//���ǵײ������,��ʹ�ò˵�
				return false;
			}
			var c = node.getOwnerTree().contextMenu;
			c.contextNode = node;
			c.showAt(e.getXY());
		},
		beforeload : function(node){
			var LocId = Ext.getCmp('UserLoc').getValue();
			if(Ext.isEmpty(LocId)){
				Msg.info('warning', '��ѡ�����!');
				return false;
			}
			var StrParam = 'Y^' + LocId;
			this.loader.dataUrl = 'dhcstm.mulstkcatgroupaction.csp?actiontype=GetChildNode'
				+'&id=' + node.id + '&StrParam=' + StrParam;
		},
		load : function(obj, node, response){
			//load��ѡ����ȱʡֵ
			var DefaNode = this.getNodeById('SCG-' + DEFA_SCG);
			if(DefaNode){
				DefaNode.getUI()['addClass'](DEFA_CLS);
			}
		}
	}
});

/**
 * ����ȱʡ����
 * @param {} Node
 */
function SetDefaultScg(Node){
	var LocId = Ext.getCmp('UserLoc').getValue();
	if(Ext.isEmpty(LocId)){
		Msg.info('warning', '��ѡ�����!');
		return false;
	}
	var RowData = UserGrid.getSelectionModel().getSelected();
	if(Ext.isEmpty(RowData)){
		Msg.info('warning', '��ѡ����Ա!');
		return false;
	}
	var UserId = RowData.get('RowId');
	var NodeType = Node.id.split('-')[0];
	if(!Node.attributes.checked || Node.id.split('-')[0] != 'SCG'
	|| (Node.hasChildNodes() && Node.childNodes && Node.childNodes[0].id.indexOf('INCSC') == -1)){
		//���ǵײ������,��ʹ�ò˵�
		Msg.info('warning', '�ýڵ㲻�ɽ���ȱʡ����!');
		return false;
	}
	var ScgId = Node.id.split('-')[1];
	var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'SetLocUserDefaScg', LocId, UserId, ScgId);
	if(ret != ''){
		Msg.info('error', '����ʧ��:' + ret);
	}else{
		Msg.info('success', '���óɹ�!');
		var SelRec = UserGrid.getSelectionModel().getSelected();
		UserGrid.getSelectionModel().fireEvent('rowselect', UserGrid.getSelectionModel(), UserGrid.getStore().indexOf(SelRec), SelRec);
	}
}

var UserStore = new Ext.data.JsonStore({
	url : DictUrl+ 'orgutil.csp?actiontype=StkLocUserCatGrp',
	totalProperty : 'results',
	root : 'rows',
	fields : ['RowId', 'Description'],
	autoLoad : true,
	baseParams : {
		start : 0,
		limit : PageSize
	},
	listeners : {
		beforeload : function(store, options){
			var LocId = Ext.getCmp('UserLoc').getValue();
			this.setBaseParam('locId', LocId);
		}
	}
});

var UserPaging = new Ext.PagingToolbar({
	store : UserStore,
	pageSize : PageSize,
	displayInfo : true
});

var sm = new Ext.grid.CheckboxSelectionModel({
	header : '',
	singleSelect : true,
	checkOnly : false,
	listeners : {
		beforerowselect : function(sm, rowIndex, keepExisting, record){
			if(!IsTreeLoaded(MulCatGroupPanel)){
				return false;
			}
		},
		rowselect : function(sm, rowIndex, r){
			var UserId = r.get('RowId');
			
			//��ȥ����ѡ
			MulCatGroupPanel.getRootNode().cascade(function(node) {
				node.getUI().toggleCheck(false);
				node.getUI().removeClass(DEFA_CLS);
			});
			
			var LocId = Ext.getCmp('UserLoc').getValue();
			var StrParam = LocId + '^' + UserId;
			var AuthorStr = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'GetAuthorLeafScg', StrParam);
			var AuthorArr = AuthorStr.split('^');
			for(var i = 0; i < AuthorArr.length; i++){
				Author = AuthorArr[i];
				var Node = MulCatGroupPanel.getNodeById('SCG-' + Author);
				if(Node){
					Node.getUI().toggleCheck(true);
					Node.cascadeParent();
					Node.cascadeChildren();
				}
			}
			
			//ȱʡ�����ر���
			var StrParam = LocId + '^' + UserId + '^';
			var DefaInfo = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'GetDefaScg', StrParam);
			var ScgId = DefaInfo.split('^')[0], ScgDesc = DefaInfo.split('^')[1];
			if(ScgId && ScgDesc){
				var Node = MulCatGroupPanel.getNodeById('SCG-' + ScgId);
				Node.getUI()['addClass']('page_family');
			}
		},
		rowdeselect : function(sm, rowIndex, record){
			MulCatGroupPanel.getRootNode().cascade(function(node) {
				node.getUI().toggleCheck(false);
				node.getUI().removeClass(DEFA_CLS);
			});
			//������Ĭ���������ñ�־
			GetDefaultScg();
			var DefaNode = MulCatGroupPanel.getNodeById('SCG-' + DEFA_SCG);
			if(DefaNode){
				DefaNode.getUI().addClass(DEFA_CLS);
			}
		}
	}
});

var UserGrid = new Ext.grid.GridPanel({
	region : 'center',
	id : 'UserGrid',
	title : '������Ա',
	store : UserStore,
	columns : [sm,
		{header: '��ԱID', sortable: true, dataIndex: 'RowId', width : 50, hidden : true},
		{header: '����', sortable: true, dataIndex: 'Description', width : 150}
	],
	sm : sm,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar : UserPaging,
	viewConfig : {forceFit : true}
});

var UserLoc = new Ext.ux.LocComboBox({
	fieldLabel : '����',
	id : 'UserLoc',
	anchor : '100%',
	emptyText : '����...',
	groupId : gGroupId,
	listeners : {
		select : function(combo, record, rowIdex){
			GetDefaultScg();		//�л�����ʱ,��ȡȱʡ����
			UserStore.load();
			var RootNode = MulCatGroupPanel.getRootNode();
			RootNode.removeAll(true);
			RootNode.reload();
			RootNode.expand(true);
		}
	}
});

var SearchInfoPanel = new Ext.form.FormPanel({
	region : 'north',
	id : 'SearchInfoPanel',
	autoHeight : true,
	layout : 'anchor',
	items : [UserLoc]
});

var HisListTab = new Ext.Panel({
	id : 'HisListTab',
	region : 'west',
	title : '������Ա������Ȩ',
	border : true,
	width : 220,
	minSize : 220,
	maxSize : 300,
	layout : 'border',
	items : [SearchInfoPanel, UserGrid]
});

/**
 * ������,��Ա, ��ȡȱʡ����
 * @return {Boolean}
 */
function GetDefaultScg(){
	var LocId = Ext.getCmp('UserLoc').getValue();
	var UserId = '';
	var RowData = UserGrid.getSelectionModel().getSelected();
	if(RowData){
		UserId = RowData.get('RowId');
	}
	if(Ext.isEmpty(LocId)){
		return false;
	}
	var StrParam = LocId + '^^';
	var DefaInfo = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'GetDefaScg', StrParam);
	DEFA_SCG = DefaInfo.split('^')[0];
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		title : '�༶���������Ա��Ȩ',
		items : [HisListTab, MulCatGroupPanel],
		renderTo : 'mainPanel'
	});
	GetDefaultScg();		//��ȡ����ȱʡ����
	MulCatGroupPanel.getRootNode().expand(true);
});