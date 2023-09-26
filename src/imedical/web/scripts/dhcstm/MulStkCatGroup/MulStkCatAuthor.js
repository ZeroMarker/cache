// 名称:多级类组授权

var PageSize = 20;
var DEFA_CLS = 'page_family';		//缺省类组标记cls

/**
 * 判断treepanel是否全部展开
 * @param {} treepanel
 * @return {bool}
 */
function IsTreeLoaded(treepanel){
	var TREE_LOADED = true;
	treepanel.getRootNode().cascade(function(node) {
		if(TREE_LOADED === true && !node.isExpanded()){
			TREE_LOADED = false;
			return false;
		}
	});
	return TREE_LOADED;
}

//>>>>>>树级联设置>>>>>>
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
		node.cascadeFellows();		//2016-03-14 add 同一类组下的库存分类,必须同时授权
		node.cascadeParent();
		node.cascadeChildren();
	}),
	onNodeDblClick: Ext.emptyFn		//2016-03-15 双击事件置空
});
//<<<<<<树级联设置<<<<<<

var SaveBT = new Ext.ux.Button({
	id : 'SaveBT',
	text : '授权',
	iconCls : 'page_save',
	handler : function(){
		Save();
	}
});

function Save(){
	var SelRec = LocGrid.getSelectionModel().getSelected();
	if(Ext.isEmpty(SelRec)){
		Msg.info('warning', '请选择需要授权的对象!');
		return false;
	}else{
		var LocId = SelRec.get('RowId');
	}
	var AuthorPar = LocId;
	
	var Str = "";
	var f = function(node) {
		var NodeType = node.id.split('-')[0];
		var NodeRowId = node.id.split('-')[1];
		var NodeChecked = this.attributes.checked;
		//2016-03-14 这里根据类组授权(只取底层类组)
		if(NodeChecked && NodeType == 'SCG' && node.hasChildNodes() && node.childNodes && node.childNodes[0].id.indexOf('INCSC') >= 0){
			if (Str == '') Str = NodeRowId;
			else Str = Str + ',' + NodeRowId;
		}
	}
	Ext.getCmp('MulCatGroupPanel').getRootNode().cascade(f);
	var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'SaveAuthorData', Str, AuthorPar);
	if(ret != ''){
		Msg.info('error', '授权失败:' + ret);
	}else{
		Msg.info('success', '授权成功!');
		var SelRec = LocGrid.getSelectionModel().getSelected();
		LocGrid.getSelectionModel().fireEvent('rowselect', LocGrid.getSelectionModel(), LocGrid.getStore().indexOf(SelRec), SelRec);
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
		text : '分类',
		draggable : false,
		id: 'AllSCG',
		expanded : true
	},
	tbar : [SaveBT, '-', '<font color=blue>"房子"标记的为科室的默认显示类组(仅按最底层类组通过右键菜单设置)</font>'],
	contextMenu: new Ext.menu.Menu({
		items: [{
			id: 'SetDefaultMenu',
			text : '设置默认显示类组'
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
				//不是底层类组的,不使用菜单
				return false;
			}
			var c = node.getOwnerTree().contextMenu;
			c.contextNode = node;
			c.showAt(e.getXY());
		},
		beforeload : function(node){
			var StrParam = 'Y^';
			this.loader.dataUrl = 'dhcstm.mulstkcatgroupaction.csp?actiontype=GetChildNode'
				+'&id=' + node.id + '&StrParam=' + StrParam;
		}
	}
});

/**
 * 设置缺省类组
 * @param {} Node
 */
function SetDefaultScg(Node){
	var LocRowData = LocGrid.getSelectionModel().getSelected();
	if(Ext.isEmpty(LocRowData)){
		Msg.info('warning', '请选择科室!');
		return false;
	}
	var LocId = LocRowData.get('RowId');
	var NodeType = Node.id.split('-')[0];
	if(!Node.attributes.checked || Node.id.split('-')[0] != 'SCG'
	|| (Node.hasChildNodes() && Node.childNodes && Node.childNodes[0].id.indexOf('INCSC') == -1)){
		//不是底层类组的,不使用菜单
		Msg.info('warning', '该节点不可进行缺省设置!');
		return false;
	}
	var ScgId = Node.id.split('-')[1];
	var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'SetLocDefaScg', LocId, ScgId);
	if(ret != ''){
		Msg.info('error', '设置失败:' + ret);
	}else{
		Msg.info('success', '设置成功!');
		var SelRec = LocGrid.getSelectionModel().getSelected();
		LocGrid.getSelectionModel().fireEvent('rowselect', LocGrid.getSelectionModel(), LocGrid.getStore().indexOf(SelRec), SelRec);
	}
}

var LocStore = new Ext.data.JsonStore({
	url : DictUrl+ 'orgutil.csp?actiontype=DeptLoc',
	totalProperty : 'results',
	root : 'rows',
	fields : ['RowId', 'Description'],
	autoLoad : true,
	baseParams : {
		hospId : session['LOGON.HOSPID'],
		start : 0,
		limit : PageSize
	}
});

var LocPaging = new Ext.PagingToolbar({
	store : LocStore,
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
			var LocId = r.get('RowId');
			
			//先去掉勾选
			MulCatGroupPanel.getRootNode().cascade(function(node) {
				node.getUI().toggleCheck(false);
				node.getUI().removeClass(DEFA_CLS);
			});
			var UserId = '';
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
			
			//缺省类组特别标记
			var StrParam = LocId + '^^';
			var DefaInfo = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'GetDefaScg', StrParam);
			var ScgId = DefaInfo.split('^')[0], ScgDesc = DefaInfo.split('^')[1];
			if(ScgId && ScgDesc){
				var Node = MulCatGroupPanel.getNodeById('SCG-' + ScgId);
				Node.getUI().addClass(DEFA_CLS);
			}
		},
		rowdeselect : function(sm, rowIndex, record){
			MulCatGroupPanel.getRootNode().cascade(function(node) {
				node.getUI().toggleCheck(false);
				node.getUI().removeClass(DEFA_CLS);
			});
		}
	}
});

var LocText = new Ext.form.TextField({
	id : 'LocText',
	title:'科室',
	enableKeyEvents : true,
	width:100,
	listeners : {
		'keyup' : function(field, e){
			LocStore.setBaseParam('locDesc', this.getValue());
			LocStore.load();
		}
	}
});

var LocFilterBT = new Ext.Button({
	id : 'LocFilterBT',
	text : '过滤',
	iconCls : 'page_find',
	handler : function(){
		LocStore.setBaseParam('locDesc', LocText.getValue());
		LocStore.load();
	}
});

var LocGrid = new Ext.grid.GridPanel({
	id : 'LocGrid',
	title : '科室',
	store : LocStore,
	columns : [sm,
		{header: '科室ID',sortable: true, dataIndex: 'RowId',width : 50, hidden:true},
		{header: '科室名称',sortable: true, dataIndex: 'Description', width : 150}
	],
	sm : sm,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	tbar : [LocText, LocFilterBT],
	bbar : LocPaging,
	viewConfig : {forceFit : true}
});

var HisListTab = new Ext.Panel({
	id : 'HisListTab',
	region : 'west',
	title : '科室类组授权',
	border : true,
	split : true,
	width : 300,
	minSize : 220,
	maxSize : 300,
	layout : 'fit',
	items : [LocGrid]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		title : '多级类组维护',
		items : [HisListTab, MulCatGroupPanel],
		renderTo : 'mainPanel'
	});
	MulCatGroupPanel.getRootNode().expand(true);
});