// /名称: 常用组件的简单封装
// /描述: 常用组件的简单封装
// /编写者：zhangdongmei
// /编写日期: 2012.12.27

/**
 * 重写Checkbox的setValue方法,返回值为Y时勾选
 * @param {} v
 * @return {}
 */
Ext.form.Checkbox.prototype.setValue = function(v){
	var checked = this.checked ;
	this.checked = (v == 'Y' || v === true || v === 'true' || v == '1' || String(v).toLowerCase() == 'on');
	if(this.rendered){
		this.el.dom.checked = this.checked;
		this.el.dom.defaultChecked = this.checked;
	}
	if(checked != this.checked){
		this.fireEvent('check', this, this.checked);
		if(this.handler){
			this.handler.call(this.scope || this, this, this.checked);
		}
	}
	return this;
}

/**
 * 重写ComboBox的setValue方法,比如 PhaLoc.setValue({RowId:153,Description:'QXKKF-器械科库房'})
 * 		表单赋值时, 后台返回object格式即可
 * @param {} v
 * @return {}
 */
Ext.form.ComboBox.prototype.setValue = function(v){
	var objReg=/^'?\{(.+\:.*)(,.+\:.*)?\}'?$/;		//判断是否对象类型的正则表达式
	if(objReg.test(v)){
		v = eval("("+v+")");
	}
	if(v != null && v['RowId'] != null && v["Description"] != null){
		if(this.mode === 'remote'){
			var store = this.getStore();
			if(store.findExact(this.valueField,v['RowId'])==-1){
		 		eval("var defaultData={"+this.valueField+":'"+v['RowId']+"',"
		 								+this.displayField+":'"+v["Description"]+"'}");
				var tmpRecord = new store.recordType(defaultData);
				store.add(tmpRecord);
			}
			this.setValue(v["RowId"]);
		}else{
			Ext.form.ComboBox.superclass.setValue.call(this, v["Description"]);
			if(this.hiddenField){
				this.hiddenField.value = Ext.value(v["RowId"], '');
			}
			this.value = v["RowId"];
		}
	}else{
		var text = v;
		if(this.valueField){
			var r = this.findRecord(this.valueField, v);
			if(r){
				text = r.data[this.displayField];
			}else if(Ext.isDefined(this.valueNotFoundText)){
				text = this.valueNotFoundText;
			}
		}
		this.lastSelectionText = text;
		if(this.hiddenField){
			this.hiddenField.value = Ext.value(v, '');
		}
		Ext.form.ComboBox.superclass.setValue.call(this, text);
		this.value = v;
	}
	return this;
};

/*
 * 重写Store的applySort,先判断是否为数字列
 */
Ext.data.Store.prototype.applySort = function() {
	if ((this.sortInfo || this.multiSortInfo) && !this.remoteSort) {
		var s = this.sortInfo, f = s.field;
		var isNumberData = true;		//初始化是否为数字列
		var dataLen = this.data.length;
		for(var i = 0; i < dataLen; i++){
			var dataValue = this.data.items[i].data[f];
			if(Number(dataValue) != dataValue){
				isNumberData = false;
				break;
			}
		}
		if(!isNumberData){
			//若不是数字列, 按原来的sortData进行排序
			this.sortData();
		}else{
			var s = this.sortInfo, f = s.field;
			var st = this.fields.get(f).sortType;
			var fn = function(r1, r2) {
				var v1 = st(r1.data[f]), v2 = st(r2.data[f]);
				v1 = parseFloat(v1);
				v2 = parseFloat(v2);
				return v1 > v2 ? 1 : (v1 < v2 ? -1 : 0);
			};
			this.data.sort(s.direction, fn);
			if(this.snapshot && this.snapshot != this.data) {
				this.snapshot.sort(s.direction, fn);
			}
		}
	}
};

Ext.ns("Ext.ux","Ext.ux.grid","Ext.dhcstm");

/**
 * 封装TreeCombo
 * @class Ext.ux.TreeCombo
 * @extends Ext.form.ComboBox
 */
Ext.ux.TreeCombo = Ext.extend(Ext.form.ComboBox, {
	treeCombo : true,			//2016-03-21 添加该属性,用于addComboData时和一般Combo做区分
	valueField : 'RowId',
	displayField : 'Description',
	forceSelection : true,
	tree: null,
	// 隐藏值
	hiddenValue: '',
	url : '',					//例如'dhcstm.mulstkcatgroupaction.csp?actiontype=GetChildNode'
	valueParams : {},			//参数
	constructor: function (cfg) {
		cfg = cfg || {};
		Ext.ux.TreeCombo.superclass.constructor.call(this, Ext.apply({
			minChars : 100,		//2016-03-11 这里暂时设置一个很大的值,否则combo录入后,下拉无数据
			typeAhead : false,	//2016-03-11 设置为false,原因同上
			maxHeight: 300,
			editable: true,
			mode: 'local',
			triggerAction: 'all',
			rootVisible: false,
			selectMode: 'all'	//jiabin rem: 这里有必要扩充几种选择方式
		}, cfg));
	},
	createStore: function(){
		this.store = new Ext.data.SimpleStore({
			fields: [],
			data: [[]]
		});
	},
	// 重写onViewClick，使展开树结点是不关闭下拉框
	onViewClick: function (doFocus) {
		var index = this.view.getSelectedIndexes()[0], s = this.store, r = s.getAt(index);
		if (r) {
			this.onSelect(r, index);
		}
		if (doFocus !== false) {
			this.el.focus();
		}
	},
	/**
	 * 重写clearValue, 添加this.hiddenValue = '';
	 */
	clearValue : function(){
		if(this.hiddenField){
			this.hiddenField.value = '';
		}
		this.setRawValue('');
		this.lastSelectionText = '';
		this.lastSelectionNode = '';
		this.applyEmptyText();
		this.value = '';
		this.hiddenValue = '';		//重写新增
	},
	/**
	 * 参考findRecord写findNode
	 * @param {} prop
	 * @param {} value
	 * @return {}
	 */
	findNode : function(prop, value){
		var findNode;
		var RootNode = this.tree.getRootNode();
		RootNode.cascade(function(node){
			if(node.attributes[prop] == value){
				findNode = node;
				return false;
			}
		},this);
		return findNode;
	},
	setValue : function(v, text){
		var objReg=/^'?\{(.+\:.*)(,.+\:.*)?\}'?$/;		//判断是否对象类型的正则表达式
		if(objReg.test(v)){
			//2016-03-22 components.js上方的代码,曾重写了Combo的setValue方法,为使TreeCombo沿用之前的赋值方式,这里做此改动
			var valueObj = eval("("+v+")");
			if(valueObj && valueObj['RowId'] && valueObj["Description"]){
				v = valueObj['RowId'], text = valueObj['Description'];
			}
		}
		
		var node;
		if(v && text){
			addComboData(null, v, text, this);
		}else if(this.valueField && v && !text){
			node = this.findNode(this.valueField, v);
			if(node){
				text = node.text;
			}else if(Ext.isDefined(this.valueNotFoundText)){
				text = this.valueNotFoundText;
			}
		}
		if(node){
			this.lastSelectionNode = node;
			this.lastSelectionText = text;
		}
		if(this.hiddenField){
			this.hiddenField.value = Ext.value(v, '');
		}
		Ext.form.ComboBox.superclass.setValue.call(this, text);
		this.value = v;
		if(text){
			this.setRawValue(text);
		}
		this.hiddenValue = v;
		this.originalValue = this.getValue();
		return this;
	},
	assertValue  : function(){
		var val = this.getRawValue(),
			node = this.findNode(this.displayField, val);
		if(!node && this.forceSelection){
			if(val.length > 0 && val != this.emptyText && this.lastSelectionNode){
				var code = Ext.value(this.lastSelectionNode.attributes.RowId, ''),
					dispText = Ext.value(this.lastSelectionNode.text, '');
				this.setValue(code, dispText);
				this.applyEmptyText();
			}else{
				this.clearValue();
			}
		}else{
			if(node){
				if (val == node.text && this.value == node.attributes.RowId){
					return;
				}
				val = node.attributes.RowId;
				this.setValue(val, node.text);
			}else{
				this.setValue(val);
			}
		}
	},
	getHiddenValue: function () {
		return this.hiddenValue;
	},
	getValue: function () { //增加适用性，与原来combo组件一样
		return this.hiddenValue;
	},
	initComponent: function () {
		this.createStore();
		var _this = this;
		var tplRandomId = 'TreeCombo_' + this.id;
		this.tpl = "<div style='height:" + this.maxHeight + "px' id='" + tplRandomId + "'></div>";
		this.tree = new Ext.tree.TreePanel({
			border: false,
			enableDD: false,
			enableDrag: false,
			rootVisible: _this.rootVisible || false,
			autoScroll: true,
			trackMouseOver: true,
			height: _this.maxHeight,
			lines: true,
			singleExpand: false,
			root: new Ext.tree.AsyncTreeNode({
				id: _this.rootId,
				text: _this.rootText,
				iconCls: 'ico-root',
				expanded: true,
				leaf: false,
				border: false,
				draggable: false,
				singleClickExpand: false,
				hide: true
			}),
			loader: new Ext.tree.TreeLoader({
				nodeParameter: 'ID',
				requestMethod: 'GET'
			}),
			listeners : {
				beforeload : function(node){
					treeUrl = _this.url;
					treeUrl = treeUrl + '&' + _this.rootParam + '=' + node.id;				//node参数
					for(param in _this.valueParams){
						treeUrl = treeUrl + '&' + param + '=' + _this.valueParams[param];	//其他参数
					}
					this.loader.dataUrl = treeUrl;
				}
			}
		});
		this.tree.on('click', function (node) {
			if ((_this.selectMode == 'leaf' && node.leaf == true) || _this.selectMode == 'all') {
				if (_this.fireEvent('beforeselect', _this, node)) {
					_this.fireEvent('select', _this, node);
				}
			}
		});
		this.on('select', function (obj, node) {
			if(!obj || !node){
				//2016-03-16 add
				return false;
			}
			var dispText = node.text;
			var code = node.id;
			var value = node.attributes.RowId;
			obj.lastSelectionNode = node;
			obj.setValue(value, dispText);
			obj.collapse();
		});
		this.on('expand', function () {
			this.tree.getRootNode().expand(true);		//combo展开时,加载所有的类组
			this.tree.render(tplRandomId);
		});
		Ext.ux.TreeCombo.superclass.initComponent.call(this);
	}
});
Ext.reg("treecombo", Ext.ux.TreeCombo);

//封装的combox控件
Ext.ux.ComboBox = Ext.extend(Ext.form.ComboBox,{
	valueField : 'RowId',
	displayField : 'Description',
	anchor : '90%',
	selectOnFocus : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	typeAhead:false,
	valueNotFoundText : '',
	forceSelection : true,
	emptyText : '',
	filterName : '',		//store定义的根据录入内容过滤数据的参数名称
	params : {},			//其它参数{参数名称:提供参数值的控件id}
	valueParams : {},		//参数{参数名称:参数值}
	childCombo : "",		//关联combo的Id或id数组: 关联combo,取值受此combo影响, 比如科室--类组
	initComponent : function(){
		this.childCombo = Ext.isEmpty(this.childCombo)?[]:[].concat(this.childCombo);
		//增加事件监听：根据录入的内容装载store
		this.on('beforequery',function(e){
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			var filter=this.getRawValue();
			if(this.filterName!=""){
				this.store.setBaseParam(this.filterName,filter);				
			}
			for(param in this.params){
				var value=Ext.getCmp(this.params[param]).getValue();
				this.store.setBaseParam(param,value);
			}
			for(param in this.valueParams){
				this.store.setBaseParam(param,this.valueParams[param]);
			}
			this.store.load({params:{start:0,limit:this.pageSize}});
		});
		this.on('select',function(){
			for(var i=0,len=this.childCombo.length;i<len;i++){
				var child = Ext.getCmp(this.childCombo[i]);
				if(!Ext.isEmpty(child) && !child.disabled){
					child.clearValue();
					child.fireEvent('beforequery');
					if(!Ext.isEmpty(child.childCombo)){
						child.fireEvent('select');
					}
				}
			}
		});
		this.on('keyup',function(field, e){
			//中文输入法回车上屏时doQuery
			if(e.getKey() == Ext.EventObject.ENTER){
				this.doQuery();
			}
		});
		Ext.ux.ComboBox.superclass.initComponent.call(this);
	}
});
Ext.reg('uxcombo',Ext.ux.ComboBox);
//封装的localcombox控件
Ext.ux.LocalComboBox = Ext.extend(Ext.form.ComboBox,{
		anchor:'90%',
		valueField:'RowId',
		displayField:'Description',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		mode:'local',
		initComponent : function(){
		Ext.ux.LocalComboBox.superclass.initComponent.call(this);
	}
});

//供应商
//2014-11-28 修改为继承ux.Combo, 便于设置LocId,ScgId进行类组授权取值
Ext.ux.VendorComboBox = Ext.extend(Ext.ux.ComboBox,{
	fieldLabel : '供应商',
	emptyText : '供应商...',
	filterName : 'filter',
	//科室rowid,类组rowid, 通过params : {LocId: ***, ScgId: ***}方式传入
	valueParams : {UserId : session['LOGON.USERID']},
	selectOnFocus : true,
	typeAhead : false,
	forceSelection : true,
	rcFlag:false,
	initComponent : function(){
		this.createStore();
		Ext.ux.VendorComboBox.superclass.initComponent.call(this);
	},
	createStore : function(){
		var rc=this.rcFlag;
		this.store = new Ext.data.JsonStore({
			autoDestroy:true,
			url:DictUrl+ 'orgutil.csp?actiontype=APCVendor',
			storeId:'VendorStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams : {
				APCType : App_StkTypeCode,
				rcFlag:rc
			}
		});
	}
});
Ext.reg('vendorcombo',Ext.ux.VendorComboBox);

//供应商应用中的供应商
Ext.ux.UsrVendorComboBox=Ext.extend(Ext.form.ComboBox,{
	fieldLabel : '供应商',
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : '供应商...',
	selectOnFocus : true,
	minChars : 3,
	typeAhead:false,
	pageSize : 20,
	listWidth : 250,
	valueNotFoundText : '',
	forceSelection : true,
	userId :null,    //新增属性，登录人员id
	//editable : false,
	initComponent:function(){
		var myUrl=""
		if (this.userId!=null && this.userId!=""){
			myUrl=DictUrl+ 'orgutil.csp?actiontype=VendorbyUsr&APCType='+App_StkTypeCode+'&VUser='+this.userId;
		}
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,			
			url:myUrl,		
			storeId:'UsrVendorStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams:{
				filter:''
			}
		});
		this.on('beforequery',function(e){
			var filter=this.getRawValue();
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			this.store.setBaseParam("filter",filter);
			this.store.load({params:{start:0,limit:this.pageSize}});
			
		});
		var me=this;
		this.store.on('load', function(store,records,opt){ 
			if(records.length==1){
					var rowid= records[0].get('RowId');
					var desc=records[0].get('Description');
					me.setValue(rowid);
			}
		}); 
		
		Ext.ux.UsrVendorComboBox.superclass.initComponent.call(this);
		this.store.load();
	}
});
Ext.reg('usrvendorcombo',Ext.ux.UsrVendorComboBox);

//科室：如果设置了groupId属性，装载安全组能访问的科室，否则装载所有科室
Ext.ux.LocComboBox = Ext.extend(Ext.ux.ComboBox,{
	fieldLabel : '科室',
	anchor : '90%',
	valueField : 'RowId',
	displayField : 'Description',
	forceSelection : true,// 值为true时将限定选中的值为列表中的值，值为false则允许用户将任意文本设置到字段（默认为 false）。
	emptyText : '科室...',
	selectOnFocus : true,
	minChars : 3,
	pageSize : 20,
	listWidth : 250,
	typeAhead:false,
	defLoc:''	,	///Y--用户的可以登录科室以及当前登录科室的支配科室
	valueNotFoundText : '',
	groupId:null,		//新增属性，安全组id
	defaultLoc:null,	//新增属性，默认科室,"",不设置默认科室;{RowId:ctloc_rowid,Description:ctloc_desc}设置默认科室为指定值，如果默认科室为登陆科室，不需设置该属性
	filterName : 'locDesc',
	stkGrpId : "",		//类组combo的id
	listeners : {
		select : function(){
			var stkGrpId = this.stkGrpId;
			if(!Ext.isEmpty(stkGrpId)){
				var stkGrpCombo =  Ext.getCmp(stkGrpId);
				if(!Ext.isEmpty(stkGrpCombo) && !stkGrpCombo.disabled){
					stkGrpCombo.setFilterByLoc(this.getValue());
					stkGrpCombo.fireEvent('select');
				}
			}
			if (this.groupId!=''){
				sssSetStockLoc(this.getValue());
			}
			
		}
	},
	initComponent:function(){
		var myUrl="";
		if (this.groupId==null || this.groupId==""){
			myUrl=DictUrl+ 'orgutil.csp?actiontype=DeptLoc';
		}else{
			myUrl=DictUrl+ 'orgutil.csp?actiontype=GetGroupDept';
			//GetDeptByUserGrp:获取当前登录人员在当前登录安全组下有登录权限的科室
			//myUrl=DictUrl+ 'orgutil.csp?actiontype=GetDeptByUserGrp';
		}
		if(this.defLoc=="Y"){
			myUrl=DictUrl+ 'orgutil.csp?actiontype=GetDeptDef';
		}
		//指定store
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'LocStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description'],
			baseParams:{
				groupId:this.groupId,
				locDesc:''
			}
		});
		
		//设置默认值
		var defaultData=this.defaultLoc;
		if(this.defaultLoc==null){
			// 设置当前登录科室为默认值
			var rowId = session['LOGON.CTLOCID'];
			defaultData = {
				RowId : rowId,
				Description : App_LogonLocDesc
			};
		}
		if(defaultData!=""){
			var record = new this.store.recordType(defaultData);
			var rowId=record.get('RowId');
			this.store.add(record);
			this.setValue(rowId);
		}
		Ext.ux.LocComboBox.superclass.initComponent.call(this);
	}
});
Ext.reg('loccombo',Ext.ux.LocComboBox);

// 消息管理
Msg = {};
// 显示消息
Msg.show = function(type, msg) {
	var title, icon;
	switch (type) {
		case 'error' :
			title = "错误信息";
			icon = Ext.MessageBox.ERROR;
			break;
		case 'warn' :
			title = "警告信息";
			icon = Ext.MessageBox.WARNING;
			break;
		default :
			title = '提示信息';
			icon = Ext.MessageBox.INFO;
	}
	Ext.Msg.show({
				title : title,
				msg : msg,
				buttons : Ext.Msg.OK,
				icon : icon
			});
};
// 显示消息
Msg.flashshow = function(type,msg) {
	Ext.ux.Msg.flash({
		 msg: msg,
		time: 1,
		type: type
		});
};
// 错误信息显示
Msg.error = function(message) {
	Msg.show('error', message);
};

// 警告信息显示
Msg.warn = function(message) {
	Msg.show('warn', message);
};

// 信息显示
Msg.info = function(type,message) {
	//Msg.show('info', message);
	Msg.flashshow(type,message);
};

//ComboBox in an Editor Grid: create reusable renderer
//适用于渲染时combobox中数据已装载的情况
Ext.util.Format.comboRenderer = function(combo){
    return function(value){    	
        var record = combo.findRecord(combo.valueField, value);
        return record ? record.get(combo.displayField) : combo.valueNotFoundText;
    }
}

/*
 2012-09-06,zhangdongmei,渲染grid中combox,适用于渲染时下拉框中没有数据的情况
 combo：下拉框
 valuefield:record中对应的下拉框的rowid字段名,
 displaytext:record中对应的下拉框的displayText字段名,
 displaytext2:record中对应的下拉框的displayText字段名(用于displayText是由record中两个字段组成的情况),
 */
Ext.util.Format.comboRenderer2 = function(combo,valuefield,displaytext,displaytext2){
	return function(value, metaData, record, rowIndex, colIndex, store){
		
		if(value==null|| value==""){
			return combo.valueNotFoundText;
		}
		var text="";
		var rowid="";
		if(record){
			rowid=record.get(valuefield);
			text=record.get(displaytext);
			if(displaytext2!=null & displaytext2!=""){
				var text2=record.get(displaytext2);
				text=text+"~"+text2;
			}
		}
		if(combo.treeCombo === true){
			//2016-03-23 对于TreeCombo,渲染时特殊处理
			addComboData(null,rowid,text,combo);
			var findNode = combo.findNode(combo.valueField, value);
			if(findNode){
				if(typeof(displaytext2) == 'undefined'){
					record.set(displaytext, findNode.attributes[combo.displayField]);
				}else{
					var tmpDisplayArr = findNode.attributes[combo.displayField].split('~');
					record.set(displaytext, tmpDisplayArr[0]);
					record.set(displaytext2, tmpDisplayArr[1]);
				}
			}else{
				record.set(displaytext, '');
			}
			return findNode ? findNode.attributes[combo.displayField] : combo.valueNotFoundText;
		}else{
			//普通Combo渲染处理
			var find = combo.findRecord(combo.valueField, value);
			if((find==null)&(text!="")){
				var comboxstore=combo.getStore();
				addComboData(comboxstore,rowid,text,combo);
				find = combo.findRecord(combo.valueField, value);
			}
			//2013-12-05 add:给displaytext列赋值,否则界面取不到grid中combo列的描述
			//2014-05-09 修改赋值方式(displaytext2)
			if(find!=null){
				if(typeof(displaytext2)=='undefined'){
					record.set(displaytext,find.get(combo.displayField));
				}else{
					var tmpDisplayArr=find.get(combo.displayField).split('~');
					record.set(displaytext,tmpDisplayArr[0]);
					record.set(displaytext2,tmpDisplayArr[1]);
				}
			}else{
				record.set(displaytext,"");
			}
			return find ? find.get(combo.displayField) : combo.valueNotFoundText;
		}
	}
}

/**
 * 显示库存项图片的Resizable
 */
var gCustom = new Ext.Resizable('gCustom', {
	wrap:true,
	pinned:true,
	minWidth:50,
	minHeight: 50,
	preserveRatio: true,
	handles: 'all',
	draggable:true,
	dynamic:true
});
var gCustomEl = gCustom.getEl();
// move to the body to prevent overlap
document.body.insertBefore(gCustomEl.dom, document.body.firstChild);
gCustomEl.on('dblclick', function(){
	gCustomEl.hide(true);
});
gCustomEl.hide();
/**
 * 显示库存项图片的function,供Ext.util.Format.InciPicRenderer调用
 * @param {String} picSrc:图片预览路径
 */
function ShowInciMasterPic(picSrc){
	if(picSrc.indexOf('.jpg')==-1){
		return;
	}
	Ext.get("gCustom").dom.src = picSrc;
	var tmpImage = new Image();
	tmpImage.src = picSrc;
	var height,width;
	if(tmpImage.height >= tmpImage.width){
		height = 500;
		width = height * tmpImage.width / tmpImage.height;
	}else{
		width = 500;
		height = width * tmpImage.height / tmpImage.width;
	}
	gCustom.resizeTo(width, height);
	gCustomEl.center();
	gCustomEl.show(true);
}
/**
 * 显示库存项的function,供Ext.util.Format.InciPicRenderer调用
 * @param {String} picSrc:图片预览路径
 * @param {String} Inciinfo
 */
function ShowInciInfo(inci){
	var userId = session['LOGON.USERID'];
	var groupId = session['LOGON.GROUPID'];
	var locId = session['LOGON.CTLOCID'];
	(function GetParam(){
	var url = 'dhcstm.ftpcommon.csp?actiontype=GetParamProp&GroupId=' + groupId
			+ '&LocId=' + locId + '&UserId=' + userId;
	var response = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(response);
	if (jsonData.success == 'true') {
		var info = jsonData.info;
		if (info != null || info != '') {
			gParam = info.split('^');
		}
	}

	return;
})()
var ftpsrc = "http://" + gParam[5];
	var picSrc="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"
	var info = tkMakeServerCall("web.DHCSTM.DicGroup","GetDicGroupInfo",inci,groupId,locId,1);
	var PicUrl = 'dhcstm.orgutil.csp?actiontype=GetDicGroupInfo';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : PicUrl,
				method : "POST"
				});
			// 指定列参数
	var fields = ["picsrc","type"];
			// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				fields : fields
				});
	// 数据集
	var PicStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
					});
	PicStore.load({params:{'inci':inci,'groupId':groupId,'locId':locId}});
	var picTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div style="padding:5px; height:230px; width:210px; float:left;" class="select_pic" >',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:210; width:210;"position: relative;>',
		'<p><font color=blue size="4">{type}</font></p>',		
		'</div>', '</tpl>');

	var picView = new Ext.DataView({
		store : PicStore,
		tpl : picTpl,
		frame : true,
		singleSelect : true,
		autoScroll:true,
		trackOver : true,
		selectedClass : 'selected-pic',
		overClass : 'over-pic',
		itemSelector : 'div.select_pic',
		emptyText : '请选择要显示的资质图片',
		listeners : {
			'dblclick' : function(v, r) {
			var src = PicStore.getAt(r).get('picsrc')
			var type=PicStore.getAt(r).get('type')
			var allsrc = ftpsrc + src;
			var image = new Image();
			image.src = ftpsrc + src;
			//document.body.appendChild(image); //加载图片
            var OpenWindow=window.open(allsrc,"",'height='+(image.height+30)+',width='+(image.width+30)+',resizable=yes,scrollbars=yes,status =yes')
      		}
		}

	})
		
	
	var detailPanel = new Ext.Panel({
		region:'east',
		items : picView,
		width:(0.4*gWinWidth),
		autoScroll : true
	});
	var InfoPanel=new Ext.Panel({
		region:'center',
		autoScroll : true,
		html:'<font color=blue size="5">'+info+'</font>'
		
	});
 
		var InciInfoWin = new Ext.Window({
			title : '物资信息',
			width:gWinWidth,
			height: gWinHeight,
			maximizable:true,
			modal : true,
			layout : 'border',
			items : [InfoPanel,detailPanel]
		});	
	InciInfoWin.show();
}

/**
 * 渲染显示库存项图片的超链接InciPicRenderer
 * @param {String} inciDataIndex: 库存项相关的dataIndex, 可以是inci,也可以是incil或者inclb
 * @return {} 调用显示productmaster图片的超链接
 */
Ext.util.Format.InciPicRenderer = function(inciDataIndex){
	return function(value, metaData, record, rowIndex, colIndex, store){
		var inci = record.get(inciDataIndex).split('||')[0];
		var str = "<a href='javaScript:void(0)' onclick='ShowInciInfo(\""+inci+"\")' >"+value+"</a>";
		return str;
	}
}
InciPicRenderer = Ext.util.Format.InciPicRenderer;

/**
 * 日期控件,可实现t+1功能,xtype:uxdatefield
 * @class Ext.ux.DateField
 * @extends Ext.form.DateField
 * 2016-03-08 重写parseDate,处理6位数字形式
 */
Ext.ux.DateField=Ext.extend(Ext.form.DateField,{
	anchor : '100%',
	format:'Y-m-d',
	altFormats:'j|d|md|ymd|Ymd'+'|Y-m|Y-n|y-m|y-n'+'|Y-m-d|Y-m-j|Y-n-d|Y-n-j|y-m-d|y-m-j|y-n-d|y-n-j',
	invalidClass:'',
	invalidText:'',
	regex:/^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{4}\-\d{2}\-\d{2}))$/,
	regexText:'请输入正确的日期格式!',
	initComponent:function(){
		this.on('blur',function(e){
			var str=this.getRawValue();
			str=str.replace(/\s/g,"").toLowerCase();
			if(str=="t"){
				this.setValue(new Date());
			}
			else if(str.indexOf("t+")==0 || str.indexOf("t-")==0){
				var addDayNum=parseInt(str.substring(2));
				if(isNaN(addDayNum)){
					this.setValue('');
				}else{
					if(addDayNum=="") {addDayNum=0;}
					if(str.substring(1,2)=="-"){
						addDayNum=-addDayNum;
					}
					this.setValue(new Date().add(Date.DAY, parseInt(addDayNum)));
				}
			}else{
				this.setValue(this.getValue());
			}
		});
		this.on('specialkey',function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				this.fireEvent('blur');
			}
		});
		Ext.ux.DateField.superclass.initComponent.call(this);
	},
	/*
	 * 重写DateField的parseDate方法,对于6位数字格式化进行特殊处理
	 */
	parseDate : function(value) {
		if(!value || Ext.isDate(value)){
			return value;
		}
		var v = this.safeParse(value, this.format),
			af = this.altFormats,
			afa = this.altFormatsArray;
		if (!v && af) {
			afa = afa || af.split("|");
			for (var i = 0, len = afa.length; i < len && !v; i++) {
				if(afa[i] == 'ymd' && Ext.isString(value) && (Number(value) == value) && value.length == 6 && value.substring(2,4) > 12){
					//该if内为特殊处理部分, 形如201609(第3,4为>12)取该月最后一天,即20160930
					var firstDay = Date.parseDate(value + '01', 'Ymd');
					v = firstDay.getLastDateOfMonth();
				}else{
					v = this.safeParse(value, afa[i]);
				}
			}
		}
		return v;
	}
});
Ext.reg('uxdatefield',Ext.ux.DateField);

/**
 * 时间显示控件,xtype:uxtimefield
 * @class Ext.ux.TimeField
 * @extends Ext.form.TextField
 */
Ext.ux.TimeField = Ext.extend(Ext.form.TextField,{
	anchor : '90%',
	regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
	regexText:'时间格式错误，正确格式hh:mm:ss'
});
Ext.reg('uxtimefield',Ext.ux.TimeField);

/**
 * NumberField控件扩展,控制小数位数(decimalPrecision)
 * xtype : uxnumberfield
 * @class Ext.ux.NumberField
 * @extends Ext.form.NumberField
 */
Ext.ux.NumberField = Ext.extend(Ext.form.NumberField,{
	anchor : '90%',
	formatType : null,
	initComponent : function() {
		var myUrl = "";
		if(this.formatType != null){
			myUrl = DictUrl + 'extux.csp?actiontype=DecimalPresion&formatType=' + this.formatType;
			decimalLen = ExecuteDBSynAccess(myUrl);
			this.decimalPrecision = parseInt(decimalLen);
		}
		Ext.ux.NumberField.superclass.initComponent.call(this);
	}
});
Ext.reg('uxnumberfield',Ext.ux.NumberField);

/**
 * 重写CellSelectionModel的onEditorKey, UP,DOWN,RIGHT,LEFT监听控制光标跳转
 * @class Ext.ux.CellSelectionModel
 * @extends Ext.grid.CellSelectionModel
 */
Ext.ux.CellSelectionModel = Ext.extend(Ext.grid.CellSelectionModel,{
	keyUp : true,
	keyDown : true,
	keyLeft : true,
	keyRight : true,
	onEditorKey : function(field, e){
		if(e.getKey() == e.TAB || (e.getKey() == e.UP && this.keyUp) || (e.getKey() == e.DOWN && this.keyDown)
		|| (e.getKey() == e.RIGHT && this.keyRight) || (e.getKey() == e.LEFT && this.keyLeft)){
			this.handleKeyDown(e);
		}
	},
	initComponent:function(){
		Ext.ux.CellSelectionModel.superclass.initComponent.call(this);
	}
});

///封装GridPanel和EditorGridpanel, 实现列设置功能
Ext.ux.GridPanel = Ext.extend(Ext.grid.GridPanel,{
	loadMask:true,
	stripeRows:true,
	
	initComponent:function(){
		this.createHeadMenu();
		Ext.ux.GridPanel.superclass.initComponent.call(this);
	},
	listeners:{
		headercontextmenu : function(grid,columnIndex,e){
			e.preventDefault();
			this.HeadRightClickMenu.showAt(e.getXY());
		},
		beforerender : function(grid){
			if(typeof(gAppName)=='undefined'){
				//return;
				var gAppName="DHCSTCOMMONM";
			}
			RefreshGridColSet(grid,gAppName);
		}
	},
	createHeadMenu : function(){
		function CommonColGridSet(){
			if(this.getId().indexOf('ext-comp')>=0){
				Msg.info("warning","请联系开发人员维护ID后再试!");
				return;
			}
			if(typeof(gAppName)=='undefined'){
				//Msg.info("warning","请联系开发人员维护AppName后再试!");
				//return;
				var gAppName="DHCSTCOMMONM";
			}
			GridColSet(this,gAppName);
		}
		var HeadRightClickMenu = new Ext.menu.Menu({
			id : 'HeadRightClickMenu',
			items : [
				{text:'导出当前页',scope:this,handler:function(b,e){gridSaveAsExcel(this);}},
				{text:'导出所有',scope:this,handler:function(b,e){ExportAllToExcel(this);}},
				{text:'列设置',scope:this,handler:CommonColGridSet}
			]
		});
		this.HeadRightClickMenu = HeadRightClickMenu;
	}
});

Ext.ux.EditorGridPanel = Ext.extend(Ext.grid.EditorGridPanel,{
	loadMask:true,
	stripeRows:true,
	clicksToEdit:1,
	initComponent:function(){
		this.createHeadMenu();
		Ext.ux.EditorGridPanel.superclass.initComponent.call(this);
	},
	listeners:{
		headercontextmenu : function(grid,columnIndex,e){
			e.preventDefault();
			this.HeadRightClickMenu.showAt(e.getXY());
		},
		beforerender : function(grid){
			if(typeof(gAppName)=='undefined'){
				//return;
				var gAppName="DHCSTCOMMONM";
			}
			RefreshGridColSet(grid,gAppName);
		}
	},
	createHeadMenu : function(){
		function CommonColGridSet(){
			if(this.getId().indexOf('ext-comp')>=0){
				Msg.info("warning","请联系开发人员维护ID后再试!");
				return;
			}
			if(typeof(gAppName)=='undefined'){
				//Msg.info("warning","请联系开发人员维护AppName后再试!");
				//return;
				var gAppName="DHCSTCOMMONM";
			}
			GridColSet(this,gAppName);
		}
		var HeadRightClickMenu = new Ext.menu.Menu({
			id : 'HeadRightClickMenu',
			items : [
				{text:'导出当前页',scope:this,handler:function(b,e){gridSaveAsExcel(this);}},
				{text:'导出所有',scope:this,handler:function(b,e){ExportAllToExcel(this);}},
				{text:'列设置',scope:this,handler:CommonColGridSet}
			]
		});
		this.HeadRightClickMenu = HeadRightClickMenu;
	},
	/**
	 * 光标跳转到当前行指定位置
	 * @param {colIndex or DataIndex} colDataIndex
	 */
	startEditCol : function(colIndex){
		try{
			var rowIndex = this.getSelectionModel().getSelectedCell()[0];
		}catch(e){
			return;
		}
		if(!Ext.isNumber(colIndex)){
			colIndex = GetColIndex(this, colIndex);
		}
		this.startEditing(rowIndex, colIndex);
	}
});

//按钮封装
Ext.ux.Button = Ext.extend(Ext.Button,{
	width : 70,
	height : 30,
	key:'',
	ctrl:true,
	alt:false,
	state:0,   ///按钮操作期间是否有按钮状态变化 如有变化  取消对按钮的延时处理
	map:null,
	seconds:1,   ///默认无效时间数  防止多次点击重复保存问题
	initComponent:function(){
		this.map=new Ext.KeyMap(Ext.getBody(),{
			key: this.key,
			ctrl:this.ctrl,
			alt:this.alt,
			stopEvent:true, 
			fn:this.keyhandler,
			scope: this    ///需要把button传入
		});
		if(this.key!=""){
			this.setText(this.getText()+'('+this.key+')');
		}
		this.getDelayedTask();
		Ext.ux.Button.superclass.initComponent.call(this);
	},
	keyhandler:function(){
		if(!this.disabled)
			{
			this.handler();
			this.fireEvent('click',this);
			}
	},
	 onClickButton: function() {
        this.setDisabled(true);
        this.state=0            ///初始化状态值
        this.task.delay(this.seconds * 1000);
        return true;
    },
    setButtonEnabled: function() {
    	if(this.state!==0) {return}
    	try{
        this.setDisabled(false);    ////如果窗口销毁  会找不到  
    	}
    	catch(err){
    		return
    	}
    },
    getDelayedTask: function() {
        this.task = new Ext.util.DelayedTask(this.setButtonEnabled, this);
    },
	listeners :{
		'disable':function(btn){this.state++},
		'enable':function(btn){this.state++},
		'destroy':function(){delete this.map},    ////window隐藏时无法disable的问题 在window中处理
		'click':function(){this.onClickButton()}
	}
});
Ext.reg('uxbutton',Ext.ux.Button);
//window 封装 结合uxbutton使用    处理按钮keymap 销毁问题
Ext.ux.Window = Ext.extend(Ext.Window,{
	width : gWinWidth,
	height : gWinHeight,
	modal : true,
	initComponent:function(){
		Ext.ux.Window.superclass.initComponent.call(this);
	},
	setButtonDisabled:function(flag){
		AllbtnArray=[]  ////全局数组,清空数组  里面是uxbutton 在DTHealthCommon中
		findAllUxBtn(this)  ///获取uxbutton
		for (i=0;i<AllbtnArray.length;i++)
			{	
				if(AllbtnArray[i].map)
					{	
						AllbtnArray[i].map.setDisabled(flag)
					}
			}
	},
	listeners :{
		'hide':function(){this.setButtonDisabled(true)},
		'show':function(){this.setButtonDisabled(false)}
	}
});

Ext.reg('uxwindow',Ext.ux.Window);
//formpanel简单封装
Ext.ux.FormPanel = Ext.extend(Ext.form.FormPanel,{
	labelWidth : 100,
	labelAlign : 'right',
	frame : true,
	bodyStyle : 'padding:5px;',   
	initComponent:function(){	
		Ext.ux.FormPanel.superclass.initComponent.call(this);
	}
});
Ext.reg('uxform',Ext.ux.FormPanel);
//TextField简单封装
Ext.ux.TextField = Ext.extend(Ext.form.TextField,{
	autoScroll:false,
	anchor:'90%',
	selectOnFocus:true,
	initComponent:function(){	
		Ext.ux.TextField.superclass.initComponent.call(this);
	}
});
Ext.reg('uxtextfield',Ext.ux.TextField);

/**
 * 用于columnModel定义中调用
 * @class Ext.ux.grid.ComboColumn
 * @extends Ext.grid.Column
 */
Ext.ux.grid.ComboColumn = Ext.extend(Ext.grid.Column, {
	valueField: undefined,
	displayField: undefined,
	displayField2: undefined,
	constructor: function(cfg){
		Ext.ux.grid.ComboColumn.superclass.constructor.call(this, cfg);
		this.renderer = Ext.util.Format.comboRenderer2(this.editor,this.valueField,this.displayField,this.displayField2);
	}
});
Ext.grid.Column.types['combocolumn'] = Ext.ux.grid.ComboColumn;
Ext.grid.ComboColumn = Ext.ux.grid.ComboColumn;

/**
 * 封装EditorGridPanel
 * @class Ext.dhcstm.EditorGridPanel
 * @extends Ext.grid.EditorGridPanel
 * 
 *为了简化开发过程中的代码量,以及columnModel和store,newReocrd等地方出现无谓的重复,封装了一下EditrGridPanel, 下面做简要说明
 *1. 定义从columnModel开始, 不同的是, 使用封装时, 不再直接定义cm, 而且仅需要定义cm中的column部分到一个指定数组中(见contentColumns),事先不写入RowNumberer,SelectionModel
	为了不再重复store的定义, 我们在contentColumns定义数组时,在数组元素中加入Ext.data.Field的部分属性,如mapping,dateFormat,convert,defaultValue, 属性值格式不变. 
	这里最需要注意的是column的xtype属性: "gridcolumn","datecolumn","numbercolumn","checkcolumn","combocolumn"等.
	CheckColumn.js中,添加了isPlugin属性(缺省为true), 在editable:true时,会自动生成插件数组,不必重复定义. 对于不需要设置为插件的,修改isPlugin:false属性.
	对于combo作为editor的column, 修改了之前已有的combocolumn(新的封装放置在components.js内). 在column定义中,如下处理代码
	{
		xtype :'combocolumn',		//必填
		header : "单位",
		//dataIndex : 'UomId',		//可省略,若无定义,按valueField处理
		valueField : "UomId",		//对应combo的valueField
		displayField : "Uom",		//对应combo的displayField
		//displayField2 : undefined,//根据需要添加,目前我们的程序内用到的比较少
		editor : Uom				//Uom为ComboBox
	}
 *2. 通过editable属性控制界面是否可编辑, editable:false可用于GridPanel
	firstFocusCell属性, 用于控制新增一行的startEditing的初始位置, 为空则以第一个可编辑column为准
 *3. 对于selectionModel, 缺省使用cell, 修改sm时, 只需修改smType参数(取值row,checkbox,cell),
	同时可配置singleSelect,checkOnly参数.
	对于选择行后触发的事件,通过smRowSelFn属性传入
 *4. 对于store, 对应reader的fields通过遍历contentColumns生成,这时mapping,dateFormat,convert,defaultValue等属性会影响store的定义,有需要改动的直接添加即可
	actionUrl	表示我们程序中action型csp名称
	queryAction	表示store查询时的actiontype
	idProperty	表示reader中的id属性, 也在后面提到的删除一行时做rowid取值用
	checkProperty增加一行时判断record是否为空时使用, 比如入库制单界面的IncId, 此属性在组织明细数据串的getModifiedInfo方法中也有使用,同样的含义
  compParams,valueParams,paramsFn这三个属性分别用来组织store的url参数,类似于ux.ComboBox
	compParams	界面控件参数{参数名称:控件id}
	valueParams	直接赋值参数{参数名称:参数值}
	paramsFn		取参数值方法,返回值格式object, 根据目前的使用经验, 这个属性使用最多
 *5. 删除一行的url和query用同一个csp, delRowAction和delRowParam分别表示actiontype和rowid参数名称
 *6. 新增一行,删除一行, 这两个按钮放在tbar内, 如需添加,设置showTBar:true,即可.
	分别通过grid.AddNewRowButton, grid.DelRowButton, grid.ResetStoreButton获取并控制其使用.
	新增一行时,对于record如有缺省值,通过js方法组织对象型数据,在beforeAddFn属性传入, 
	有控制要求且界面不符合时(比如类组为空)返回false, 否则返回object型缺省值(没有缺省值时返回一个空对象{}就好了,返回空或是不返回也没关系)
 *7. 对于需要添加工具条的, 设置paging:true(缺省), pageSize默认30
 *8. 保存数据前, 可通过调用grid.getModifiedInfo()方法简化代码
	对于需要在保存时组织的数据, 需要将contentColumns中对象的saveColIndex进行设置,
	从0开始,按需要保存顺序排列, 有部分取不到的数据, 序号可以跳跃, 但必须保证一致.
	对于需要判断的字段, 比如入库制单的入库数量等, 需要将contentColumns中对象的allowBlank设置为false
	若grid.getModifiedInfo()返回值为false, 说明有字段为空, 组织数据失败, 使用===false判断
 *9. 若需实现store自动加载, 设置属性autoLoadStore:true,即可
	代码中需要加载grid数据时, 仅需调用grid.load({参数1:参数值1,...})即可.
	这里的参数,仅是通过上面提到的3个方法取不到时的一个补充, 若参数均可直接取到, 执行grid.load()即可.
 *10. grid表头右键菜单封装了列设置和导出excel功能,不需再添加button.
	另外, 简单封装了grid.getModifiedRecords(), grid.getCell(row,colName), grid.reload()等方法, 不再赘述
示例:
var MasterGrid = new Ext.dhcstm.EditorGridPanel({
	editable : true,
	contentColumns : [],
	smType : "cell",
	singleSelect : true,
	smRowSelFn : function(){},
	autoLoadStore : false,
	actionUrl : "",
	queryAction : "",
	idProperty : "",
	checkProperty : "",
	compParams : null,
	valueParams : null,
	paramsFn : function(){},
	remoteSort : false,
	delRowAction : "",
	delRowParam : "",
	showTBar : true,
	paging : true,
	beforeAddFn : function(){},
	afterAddFn : function(){},
	isCheck : false
});
 */
Ext.dhcstm.EditorGridPanel = Ext.extend(Ext.grid.EditorGridPanel,{
	//EditorGridPanel相关
	editable : true,		//若为GridPanel,置为false
	clicksToEdit : 1,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	childGrid : "",			//关联grid的id或id数组,加载此grid之前,清空数组内的内容
	//cm选项
	/* contentColumns的数组,与cm的columns内定义类似,为封装需要,添加mapping,dateFormat,convert,defaultValue等
	 *   Ext.data.Field要到的部分属性,规则与Ext.data.Field一致
	 * contentColumn数组的column中,对于数字\时间列尽量维护xtype属性,比如'numbercolumn'\'datecolumn'
	 * 维护saveColIndex属性,保存时组织数据使用(仅根据saveColIndex>=0的记录组织数据)
	 */
	contentColumns : [],	//不包括RowNumberer,SelectionModel等,仅以显示内容的对象组织数组
	rowNumberer : true,		//是否显示RowNumberer
	firstFocusCell : "",	//缺省跳转cell(为空的情况下,在afterRenderer中获取)
	//sm相关
	smType : "cell",		//"row"\"checkbox"\"cell",缺省cell
	singleSelect : true,
	checkOnly : true,
	smRowSelFn : function(){},	//选择行(cell)时触发的方法: rowselect(grid,rowIndex,r), cellselect(sm,rowIndex,colIndex)
	selectFirst : true,
	//store相关
	autoLoadStore : false,	//是否自动load
	actionUrl : "",
	queryAction : "",		//load数据的actionType
	idProperty : "",		//必填. store中id,区分record的标志. 增加\删除record时用到
	checkProperty : "",		//getModifiedInfo方法组织数据时,控制record是否组织数据的column-dataIndex(比如入库制单的IncId)
	compParams : null,		//界面控件参数{参数名称:控件id}
	valueParams : null,		//直接赋值参数{参数名称:参数值}
	paramsFn : function(){},//取参数值方法,返回值格式object, 若返回值===false,return false
	remoteSort : false,
	delRowAction : "",		//删除明细的actionType
	delRowParam : "",		//删除明细传递的参数名称(有必要的话可改成方法,通过函数返回对象)
	//pagingToolbar相关
	paging : true,			//是否添加工具条
	pageSize : 30,
	//tbar相关
	showTBar : true,		//是否显示tbar,结合editable使用
	beforeAddFn : function(){},	//新增一行前,判断是否符合条件(返回值===false则不新增行).
								//否则,获取新增行缺省值,返回值格式:object
	afterAddFn : function(){},	//新增一行后,如需调用某方法控制界面控件等,可通过此参数设置
	//用于自我检查的参数,编辑js时可设置为true
	isCheck : false,
	initComponent : function(config){
		if(this.paging){
			this.createPagingToolBar();
		}
		if(!!this.editable && !!this.showTBar){
			this.createTbar();
		}
		Ext.dhcstm.EditorGridPanel.superclass.initComponent.call(this, config);
		this.createSm();		//创建sm
		this.createCm();		//创建cm,fields
		this.createStore();		//创建store
		this.createHeadMenu();	//创建HeadRightClickMenu
	},
	listeners : {
		afterrender : function(grid){this.onAfterRender(grid)},
		beforeedit : function(e){return this.onBeforeEdit(e);},
		beforerender : function(grid){this.onBeforeRender(grid);},
		headercontextmenu : function(grid,columnIndex,e){this.onHeaderContextMenu(grid,columnIndex,e)},
		viewready : function(grid){this.onViewReady(grid);}
	},
	onAfterRender : function(grid){
		if(this.smType=="cell" && this.firstFocusCell==""){
			this.getFirstFocusCell();	//获取第一个可编辑的cell
		}
	},
	onBeforeEdit : function(e){
		if(!this.editable){return false;}
	},
	onBeforeRender : function(grid){
		if(typeof(gAppName)=='undefined'){
			return;		//var gAppName="DHCSTCOMMONM";
		}
		RefreshGridColSet(grid,gAppName);
	},
	onHeaderContextMenu : function(grid,columnIndex,e){
		e.preventDefault();
		this.HeadRightClickMenu.showAt(e.getXY());
	},
	onViewReady : function(grid){
		if(this.isCheck && !this.showCheckInfo()){return false;}	//创建grid时,用于自我检查
		if(this.autoLoadStore){this.load()};
	},
	/**
	*@return {Ext.data.Record} the first selected record
	*/
	getSelected : function() {
		return this.getSelectionModel().getSelected();
	},
	/**
	*@return {Ext.data.Record[]} the selected records
	*/
	getSelections : function() {
		return this.getSelectionModel().getSelections();
	},
	/**
	*@return {Number} total number of the selected records 
	*/
	getSelectionsCount : function() {
		return this.getSelectionModel().getCount();
	},
	/**
	*@param {Number} index
	*@return {Ext.data.Record} the Record at the specified index.
	*/
	getAt : function(index) {
		return this.getStore().getAt(index);
	},
	/**
	*@return {Number} the count of the store record
	*/
	getCount : function() {
		return this.getStore().getCount();
	},
	/**
	 * @return {Array} An array containing the row and column indexes of the selected cell,
	 * or null if none selected.
	 */
	getSelectedCell : function(){
		return this.getSelectionModel().getSelectedCell();
	},
	/**
	*@param {Number} rowNo 行号
	*@param {String/Number} colName col->dataIndex/列号 建议使用store的列名
	*@return {Object} the value of the grid'cell
	*/
	getCell : function(rowNo, colName) {
		if (typeof colName === 'number') {
			colName = this.getStore().fields.keys[colName];
		}
		return this.getAt(rowNo).get(colName);
	},
	/**
	*@return {Array[Ext.data.Record]} An array of {@link Ext.data.Record Records} containing outstanding
	* modifications.
	*/
	getModifiedRecords : function() {
		return this.getStore().getModifiedRecords();
	},
	removeAll : function(){
		this.store.removeAll();
	},
	add : function(record){
		this.store.add(record);
	},
	remove : function(record){
		this.store.remove(record);
	},
	/**
	 * EditorGridPanel加载数据的方法
	 * @param {object} gridParams 和store.load()使用相同格式的参数
	 */
	load : function(gridParams) {
		var tmpParams = {}, tmpScope, tmpAdd=false;
		var tmpCallBack = function(r,options,success){
				if(!success){Msg.info("error","查询有误, 请查看日志!");}
			}
		if(!Ext.isEmpty(gridParams)){
			tmpParams= gridParams.params || tmpParams;
			tmpCallBack = Ext.isFunction(gridParams.callback)?gridParams.callback:tmpCallBack;
			tmpScope = gridParams.tmpScope || null,
			tmpAdd = Boolean(gridParams.add);
		}
		var paramsNow = this.getParams(tmpParams);
		if(paramsNow===false){return;}
		this.getStore().baseParams = paramsNow;
		this.getStore().load({
			params : paramsNow,
			callback : tmpCallBack,
			scope : tmpScope,
			add : tmpAdd
		});
	},
	getParams : function(tmpParams) {
		var params = tmpParams||{};
		var paramNames = this.store.paramNames;
		params[paramNames.start] = 0;
		params[paramNames.limit] = this.paging?this.pageSize:9999;
		//界面控件参数
		for(param in this.compParams){
			params[param] = Ext.getCmp(this.compParams[param]).getValue();
		}
		//直接赋值参数
		Ext.applyIf(params,this.valueParams);
		//取值方法返回的参数值对象处理
		if(this.paramsFn != null){
			var excuteFunction = eval(this.paramsFn);
			if(Ext.isFunction(excuteFunction)){
				var FnParams = excuteFunction.call();
				if(FnParams===false){return false;}		//若组织数据有问题,return false
				Ext.applyIf(params,FnParams);
			}
		}
		return params;
	},
	reload : function(){
		this.store.reload();
	},
	createPagingToolBar : function(){
		this.bbar = new Ext.ux.PagingToolbar({
			pageSize : this.pageSize,
			displayInfo : true,
			listeners : {
				beforechange : function(toolbar,params){
					var records = this.store.getModifiedRecords();
					if(records.length>0){
						Msg.info("warning","当前页数据已经发生变化，请进行保存或刷新！");
						return false;
					}
					return true;
				}
			}
		});
	},
	createSm : function(){
		var sm;
		if(this.smType=='row'){
			sm = new Ext.grid.RowSelectionModel({
				singleSelect : this.singleSelect,
				listeners : {rowselect : this.smRowSelFn}
			});
		}else if(this.smType=='checkbox'){
			sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : this.singleSelect,
				checkOnly : this.checkOnly,
				listeners : {rowselect : this.smRowSelFn}
			});
		}else{
			sm = new Ext.grid.CellSelectionModel({
				listeners : {cellselect : this.smRowSelFn}
			});
		}
		this.selModel = sm;
	},
	createCm : function(){
		//生成fields
		var tmpFields = [];
		var tmpPlugins = Ext.isArray(this.plugins)?this.plugins:!Ext.isEmpty(this.plugins)?[this.plugins]:[];
		var saveColArray = [];		//索引saveColIndex, 值:column Object
		Ext.each(this.contentColumns,function(col,index,allCols){
			var colXType = typeof(col.xtype)=="undefined"?'gridcolumn':col.xtype;
			if(colXType=='combocolumn' && !col.dataIndex){
				col.dataIndex = col.valueField;
			}
			var tmpField = {
				name : col.dataIndex,
				mapping : col.mapping||col.dataIndex,
				type : this.GetTypeByColumn(col),
				dateFormat : col.dateFormat||null,
				convert : col.convert||null,
				defaultValue : col.defaultValue||""
			};
			tmpFields.push(tmpField);
			//对于combocolumn,numbercolumn,checkcolumn等格式的特殊处理
			if(colXType=='combocolumn'){
				var tmpField = {
					name : col.displayField,		//combo的displayField
					mapping : col.displayMapping||col.displayField
				};
				tmpFields.push(tmpField);
				if(col.displayField2){
					var tmpField = {
						name : col.displayField2,	//可能存在的//combo的displayField2
						mapping : col.display2Mapping||col.displayField2
					};
					tmpFields.push(tmpField);
				}
			}else if(colXType=='numbercolumn' && !col.align){
				col.align='right';			//数字列缺省右对齐
			}else if(colXType=='checkcolumn'){
				if(!(col instanceof Ext.grid.CheckColumn)){
					col = new Ext.grid.CheckColumn(col);
				}
				if(this.editable && col.isPlugin){
					allCols[index]=col;
					tmpPlugins.push(col);
				}
				if(!col.align){
					col.align='center';		//CheckColumn居中对齐
				}
			}
			var saveColIndex = Ext.isNumber(col.saveColIndex)?parseInt(col.saveColIndex):-1;
			if(saveColIndex>=0){
				saveColArray[saveColIndex]=col;		//准备getModifiedInfo需要的数组
			}
		},this);
		this.fields = tmpFields;				//获取fields
		this.plugins = tmpPlugins;
		this.saveColArray = saveColArray;		//需要保存的cols,注意稀疏数组
		//生成colModel
		var allColumns = this.contentColumns.concat();
		if(this.smType == 'checkbox'){
			allColumns.unshift(this.getSelectionModel());
		}
		if(this.rowNumberer === true){
			allColumns.unshift(new Ext.grid.RowNumberer());
		}
		this.colModel = new Ext.grid.ColumnModel({
			columns : allColumns,
			defaults : {xtype:'gridcolumn',sortable:true,width:100,allowBlank:true}
		});
	},
	/**
	 * 根据column的xtype获取要生成的field的type
	 * @param {object\column} column
	 * @return {string} 用于Field的type属性
	 * rem: checkcolumn暂不需特别处理, 可以考虑把ComboColumn加进来
	 */
	GetTypeByColumn : function(col){
		var colXType = col.xtype;
		colXType = typeof(colXType)=='undefined'?'gridcolumn':colXType;
		if(colXType=='booleancolumn'){
			type='boolean';
		}else if(colXType=='numbercolumn'){
			type='float';
		}else if(colXType=='datecolumn'){
			col.format = 'Y-m-d';
			col.dateFormat ='Y-m-d';	//datecolumn对应store定义用到
			type='date';
		}else{
			type='string';
		}
		return type;
	},
	createStore : function(){
		this.childGrid = Ext.isEmpty(this.childGrid)?[]:[].concat(this.childGrid);
		var grid = this;
		//生成store
		this.store = new Ext.data.JsonStore({
			autoDestroy : true,
			pruneModifiedRecords : true,
			url : this.actionUrl+"?actiontype="+this.queryAction,
			fields : this.fields,
			remoteSort : this.remoteSort,
			root : 'rows',
			totalProperty : "results",
			idProperty : this.idProperty||"",
			listeners : {
				beforeload : function(store,options){
					for(var i=0,len=grid.childGrid.length;i<len;i++){
						var tmpGrid = Ext.getCmp(grid.childGrid[i]);
						if(!Ext.isEmpty(tmpGrid)){
							tmpGrid.removeAll();
						}
					}
					if(!(options && options.add)){
						store.removeAll();
					}
				},
				load : function(store,records,options){
					if(grid.selectFirst){
						if(grid.smType!='cell' && records.length>0){
							grid.getSelectionModel().selectFirstRow();
							grid.getView().focusRow(0);
						}
						if(grid.smType=='cell' && records.length>0){
							grid.getSelectionModel().select(0,1);
						}
					}
				}
			}
		});
		if(this.paging){
			this.bottomToolbar.bind(this.store);
		}
	},
	createTbar : function(){
		var buttons = [];
		if(!Ext.isEmpty(this.tbar)){buttons.push(this.tbar,'-');}
		this.AddNewRowButton = new Ext.Button({
			height:30,width:70,text:'增加一行',iconCls:'page_add',scope:this,handler:this.addNewRow
		});
		this.DelRowButton = new Ext.Button({
			height:30,width:70,text:'删除一条',iconCls:'page_delete',scope:this,handler:this.deleteRow
		});
		buttons.push(this.AddNewRowButton,'-',this.DelRowButton);
		this.tbar = buttons;
	},
	/**
	 * 新增record
	 */
	addNewRow : function(){
		var colIndex = GetColIndex(this,this.firstFocusCell);
		var rowCount = this.getCount();
		if(rowCount>0){
			var rowData = this.getAt(rowCount - 1);
			var data = rowData.get(this.checkProperty);
			if(Ext.isEmpty(data)){
				this.startEditing(rowCount - 1, colIndex);
				return;
			}
		}
		var defaultValues = {};
		//获取record默认值
		if(Ext.isFunction(this.beforeAddFn)){
			defaultValues = eval(this.beforeAddFn).call();
			if(defaultValues===false){return;}
		}
		var RecordObject = this.store.fields;
		var NewRecord = CreateRecordInstance(RecordObject,defaultValues);
		this.add(NewRecord);
		this.startEditing(rowCount, colIndex);
		if(Ext.isFunction(this.afterAddFn)){
			this.afterAddFn.call();		//新增一行后的方法调用
		}
	},
	deleteRow : function(){
		var cell = this.getSelectedCell();
		if(cell==null){
			Msg.info("warning","没有选中的行!");
			return;
		}else{
			var record = this.getAt(cell[0]);
			if(Ext.isEmpty(record.get(this.idProperty))){
				this.remove(record);
				this.getView().refresh();
				return;
			}else{
				if(Ext.isEmpty(this.delRowAction)){
					return;
				}
				Ext.MessageBox.confirm('提示', '确定要删除选定的行吗?', function(btn) {
					if(btn == 'yes'){
						eval("var delParam = {"+this.delRowParam+":'"+record.get(this.idProperty)+"'}");
						Ext.Ajax.request({
							url : this.actionUrl + '?actiontype='+this.delRowAction,
							params : delParam,
							waitMsg : '删除中...',
							failure : function(result, request) {
								Msg.info("error","请检查网络连接!");
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if(jsonData.success == 'true'){
									Msg.info("success",'删除完成');
									this.reload();
								}else{
									Msg.info("error","删除失败:"+jsonData.info);
								}
							},
							scope : this
						});
					}
				}, this);
			}
		}	
	},
	/**
	 * 创建header右键菜单
	 */
	createHeadMenu : function(){
		function CommonColGridSet(){
			if(this.getId().indexOf('ext-comp')>=0){
				Msg.info("warning","请联系开发人员维护ID后再试!");
				return;
			}
			if(typeof(gAppName)=='undefined'){
				//Msg.info("warning","请联系开发人员维护AppName后再试!");
				//return;		
				var gAppName="DHCSTCOMMONM";
			}
			GridColSet(this,gAppName);
		}
		var HeadRightClickMenu = new Ext.menu.Menu({
			id : 'HeadRightClickMenu',
			items : [
				{text:'导出当前页',scope:this,handler:function(b,e){gridSaveAsExcel(this);}},
				{text:'导出所有',scope:this,handler:function(b,e){ExportAllToExcel(this);}},
				{text:'列设置',scope:this,handler:CommonColGridSet}
			]
		});
		this.HeadRightClickMenu = HeadRightClickMenu;
	},
	/**
	 * firstFocusCell定义为空时,结合界面渲染结果返回第一个可编辑column的dataIndex
	 */
	getFirstFocusCell : function(){
		var firstFocusCell = this.firstFocusCell;
		Ext.each(this.contentColumns,function(col,index,allCols){
			if(firstFocusCell=="" && col.editor && !col.hidden){
				firstFocusCell = col.dataIndex;
				return false;
			}
		});
		this.firstFocusCell = firstFocusCell;	//设置startEditing的第一个位置dataIndex
	},
	/**
	 * 根据column的saveCol和saveColMsg属性,获取需要保存的信息
	 * @return {String} record内数据用^隔开,不同record间数据$c(1)隔开
	 *   若有不符合条件的column, 则返回false, 可通过grid.getModifiedInfo()===false进行判断
	 */
	getModifiedInfo : function(){
		if(this.activeEditor!=null){this.activeEditor.completeEdit();}
		var ModifiedInfo = "", checkProperty = this.checkProperty;
		var mr = this.getModifiedRecords();
		for(var i=0,mrLen=mr.length; i<mrLen; i++){
			var record = mr[i], recordInfo = "";
			if(checkProperty && record.get(checkProperty)==""){
				continue;	//控制字段为空(比如inci==""),此行不整理数据
			}
			var rowIndex = this.store.indexOf(record);
			for(var j=0,arrLen=this.saveColArray.length; j<arrLen; j++){
				if(this.saveColArray[j]){
					var col = this.saveColArray[j];
					var saveColValue = record.get(col.dataIndex);
					if(saveColValue!="" && col.xtype=='datecolumn'){
						saveColValue = Ext.util.Format.date(saveColValue,col.format);
					}
					if(!col.allowBlank && saveColValue==""){
						Msg.info("warning","第"+(rowIndex+1)+"行"+col.header+"不可为空!");
						return false;
					}
				}else{
					saveColValue = "";	//对于可能存在的稀疏数组元素,按空处理
				}
				recordInfo = recordInfo + "^" + saveColValue;	//不可用if(recordInfo=="")判断,切记
			}
			recordInfo = recordInfo.slice(1);
			if(ModifiedInfo==""){ModifiedInfo = recordInfo;}
			else{ModifiedInfo = ModifiedInfo + xRowDelim() + recordInfo;}
		}
		return ModifiedInfo;
	},
	/**
	 * 自我检查方法,结合isCheck属性使用
	 * @return {Boolean} false:设置有问题, true:设置ok
	 */
	showCheckInfo : function(){
		var gridId = this.getId();
		if(gridId.indexOf('ext-comp')>=0){
			Msg.info("warning","亲,请设置gridId ^_^");
		}else if(this.idProperty==""){
			Msg.info("warning","亲,请设置"+gridId+"的idProperty属性 ^_^");
		}else if(this.editable && this.checkProperty==""){
			Msg.info("warning","亲,请设置"+gridId+"的checkProperty属性 ^_^");
		}else if(this.showTBar && (!this.delRowAction || !this.delRowParam)){
			Msg.info("warning","亲,请设置"+gridId+"的delRowAction,delRowParam属性 ^_^");
		}else if(!Ext.isFunction(this.smRowSelFn)){
			Msg.info("warning","亲,"+gridId+"的smRowSelFn不是函数 ^_^");
		}else if(!Ext.isFunction(this.paramsFn)){
			Msg.info("warning","亲,"+gridId+"的paramsFn不是函数 ^_^");
		}else if(!Ext.isFunction(this.beforeAddFn)){
			Msg.info("warning","亲,"+gridId+"的beforeAddFn不是函数 ^_^");
		}else{
			return true;
		}
		return false;
	}
});
Ext.reg('meditorgrid',Ext.dhcstm.EditorGridPanel);

/** 
 * 右下角的小贴士窗口
 * @author tipx.javaeye.com
 * @params conf 参考Ext.Window
 *         conf中添加autoHide配置项, 默认3秒自动隐藏, 设置自动隐藏的时间(单位:秒), 不需要自动隐藏时设置为false
 * @注: 使用独立的window管理组(manager:new Ext.WindowGroup()), 达到总是显示在最前的效果
 */

Ext.ux.TipsWindow = Ext.extend(Ext.Window,
    {
        width: 200,
        height: 100,
        layout: 'fit',
        modal: false,
        plain: true,
        shadow: false,
        //去除阴影
        draggable: false,
        //默认不可拖拽
        resizable: false,
        closable: true,
        closeAction: 'hide',
        //默认关闭为隐藏
        autoHide: 3,
        count:1,//设置显示的是第几个tipwindow
        //n秒后自动隐藏，为false时,不自动隐藏
        manager: new Ext.WindowGroup({
        	zseed:99999
        	}),
        //设置window所属的组
        constructor: function(conf)
        {
            Ext.ux.TipsWindow.superclass.constructor.call(this, conf);
            this.initPosition(true);
        },
        initEvents: function()
        {
           Ext.ux.TipsWindow.superclass.initEvents.call(this);
            //自动隐藏
            if (false !== this.autoHide)
            {
                var task = new Ext.util.DelayedTask(this.hide, this),
                second = (parseInt(this.autoHide) || 3) * 1000;
                this.on('beforeshow',
                function(self)
                {
                    task.delay(second);
                });
            }
            this.on('beforeshow', this.showTips);
            this.on('beforehide', this.hideTips);

            Ext.EventManager.onWindowResize(this.initPosition, this); //window大小改变时，重新设置坐标
            Ext.EventManager.on(window, 'scroll', this.initPosition, this); //window移动滚动条时，重新设置坐标
        },
        //参数: flag - true时强制更新位置
        initPosition: function(flag)
        {
            if (true !== flag && this.hidden)
            { //不可见时，不调整坐标
                return false;
            }
            var doc = document,
            bd = (doc.body || doc.documentElement);
            //ext取可视范围宽高(与上面方法取的值相同), 加上滚动坐标
            var left = bd.scrollLeft + Ext.lib.Dom.getViewWidth() - 4 - this.width;
            var top = bd.scrollTop + Ext.lib.Dom.getViewHeight() - 4 - this.height*this.count;
            this.setPosition(left, top);
        },
        showTips: function()
        {
            var self = this;
            if (!self.hidden)
            {
                return false;
            }

            self.initPosition(true); //初始化坐标
            self.el.slideIn('b',
            {
                callback: function()
                {
                    //显示完成后,手动触发show事件,并将hidden属性设置false,否则将不能触发hide事件
                    self.fireEvent('show', self);
                    self.hidden = false;
                }
            });
            return false; //不执行默认的show
        },
        hideTips: function()
        {
            var self = this;
            if (self.hidden)
            {
                return false;
            }

            self.el.slideOut('b',
            {
                callback: function()
                {
                    //渐隐动作执行完成时,手动触发hide事件,并将hidden属性设置true
                    self.fireEvent('hide', self);
                    self.hidden = true;
                }
            });
            return false; //不执行默认的hide
        }
    });
//封装的控件
Ext.ux.Viewport = Ext.extend(Ext.Viewport,{
	initComponent : function(){
		this.on('afterrender',function(){
		this.doLayout()  
		});
		Ext.ux.Viewport.superclass.initComponent.call(this);
	}
});
Ext.reg('uxviewport ',Ext.ux.Viewport);

//PagingToolbar简单封装
Ext.ux.PagingToolbar = Ext.extend(Ext.PagingToolbar,{
	pageSize:PageSize,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",  
	initComponent:function(){	
		var pagingToolbar=this
		var ps=[5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500]
		var pageSizeItems = [
			this.combo = new Ext.form.ComboBox({
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            mode: 'local',
            width: 45,
            store:ps,
            value:pagingToolbar.pageSize,
            enableKeyEvents: true,
            editable: true,
            loadPages: function() {
                var rowIndex = 0;
                var gp = pagingToolbar.findParentBy(
                                function(ct, cmp) { return (ct instanceof Ext.grid.GridPanel) ? true : false; }
                              );
                var sm = gp.getSelectionModel();
                if (undefined != sm && sm.hasSelection()) {
                    if (sm instanceof Ext.grid.RowSelectionModel) {
                        rowIndex = gp.store.indexOf(sm.getSelected());
                    } else if (sm instanceof Ext.grid.CellSelectionModel) {
                        rowIndex = sm.getSelectedCell()[0];
                    }
                }
                rowIndex += pagingToolbar.cursor;
                pagingToolbar.doLoad(Math.floor(rowIndex / pagingToolbar.pageSize) * pagingToolbar.pageSize);
            },
            listeners: {
                select: function(c, r, i) {
                    pagingToolbar.pageSize = ps[i];
                    this.loadPages();
                }
            }
        })]; 
    var userItems = this.items || []; 
    this.items = userItems.concat(pageSizeItems); 
    Ext.ux.PagingToolbar.superclass.initComponent.call(this);
    }, 
    onHlPagingKeyDown: function(field, e){ 
        if(field.isValid()){ 
            var k = e.getKey(); 
             if (k == e.RETURN) { 
                    e.stopEvent(); 
                    this.pageSize = field.getValue(); 
                    this.doRefresh(); 
             } 
        } 
    }, 
    onHlPagingBlur: function(field){ 
        if(field.isValid()){ 
            this.pageSize = field.getValue(); 
            this.doRefresh(); 
        } 
    } 
});
Ext.reg('paging',Ext.ux.PagingToolbar);
/**
 * @class Ext.BDP.TabCloseMenu
 * @extends Object 
 * @author 2013-6-6 by 李森
 * Plugin (ptype = 'tabclosemenu') for adding a close context menu to tabs. Note that the menu respects
 * the closable configuration on the tab. As such, commands like remove others and remove all will not
 * remove items that are not closable.
 * 
 * @constructor
 * @param {Object} config The configuration options
 * @ptype tabclosemenu
 */
Ext.ux.TabCloseMenu = Ext.extend(Object, {
    /**
     * @cfg {String} closeTabText
     * The text for closing the current tab. Defaults to <tt>'Close Tab'</tt>.
     */
    closeTabText: '关闭当前窗口',
    closeTabIcon: 'icon-application',

    /**
     * @cfg {String} closeOtherTabsText
     * The text for closing all tabs except the current one. Defaults to <tt>'Close Other Tabs'</tt>.
     */
    closeOtherTabsText: '关闭其他窗口',
    closeOtherTabsIcon: 'icon-applicationcascade',
    
    /**
     * @cfg {Boolean} showCloseAll
     * Indicates whether to show the 'Close All' option. Defaults to <tt>true</tt>. 
     */
    showCloseAll: true,

    /**
     * @cfg {String} closeAllTabsText
     * <p>The text for closing all tabs. Defaults to <tt>'Close All Tabs'</tt>.
     */
    closeAllTabsText: '关闭所有窗口',
    closeAllTabsIcon: 'icon-applicationcascade',
    
    constructor : function(config){
        Ext.apply(this, config || {});
    },

    //public
    init : function(tabs){
        this.tabs = tabs;
        tabs.on({
            scope: this,
            contextmenu: this.onContextMenu,
            destroy: this.destroy
        });
    },
    
    destroy : function(){
        Ext.destroy(this.menu);
        delete this.menu;
        delete this.tabs;
        delete this.active;    
    },

    // private
    onContextMenu : function(tabs, item, e){
        this.active = item;
        var m = this.createMenu(),
            disableAll = true,
            disableOthers = true,
            closeAll = m.getComponent('closeall');
        
        m.getComponent('close').setDisabled(!item.closable);
        tabs.items.each(function(){
            if(this.closable){
                disableAll = false;
                if(this != item){
                    disableOthers = false;
                    return false;
                }
            }
        });
        m.getComponent('closeothers').setDisabled(disableOthers);
        if(closeAll){
            closeAll.setDisabled(disableAll);
        }
        
        e.stopEvent();
        m.showAt(e.getPoint());
    },
    
    createMenu : function(){
        if(!this.menu){
            var items = [{
                itemId: 'close',
                text: this.closeTabText,
                iconCls: this.closeTabIcon,
                scope: this,
                handler: this.onClose
            }];
            if(this.showCloseAll){
                items.push('-');
            }
            items.push({
                itemId: 'closeothers',
                text: this.closeOtherTabsText,
                iconCls: this.closeOtherTabsIcon,
                scope: this,
                handler: this.onCloseOthers
            });
            if(this.showCloseAll){
                items.push({
                    itemId: 'closeall',
                    text: this.closeAllTabsText,
                    iconCls: this.closeAllTabsIcon,
                    scope: this,
                    handler: this.onCloseAll
                });
            }
            this.menu = new Ext.menu.Menu({
                items: items
            });
        }
        return this.menu;
    },
    
    onClose : function(){
        this.tabs.remove(this.active);
    },
    
    onCloseOthers : function(){
        this.doClose(true);
    },
    
    onCloseAll : function(){
        this.doClose(false);
    },
    
    doClose : function(excludeActive){
        var items = [];
        this.tabs.items.each(function(item){
            if(item.closable){
                if(!excludeActive || item != this.active){
                    items.push(item);
                }    
            }
        }, this);
        Ext.each(items, function(item){
            this.tabs.remove(item);
        }, this);
    }
});

Ext.preg('tabclosemenu', Ext.ux.TabCloseMenu);
