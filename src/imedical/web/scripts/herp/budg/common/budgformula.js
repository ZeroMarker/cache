// 编辑公式	
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';

budgformula = function(type, year, object) {
	// type=1:表示添加操作
	// type=2:表示修改操作
	if(type==2){
		var records = object.getSelectionModel().getSelections();
	}
	var gFormulaSet="" 	 //预算项目公式表达式
	var gFormulaDesc=""  //预算项目公式描述
	var checkStr="";
	
	if (type == 1) {
		// 公式表达式
		gFormulaSet = "";
		// 公式描述
		gFormulaDesc = "";
		//
		checkStr = "";
	}

	var area = new Ext.form.TextArea({
				id : 'area',
				width : 500,
				height : 100,
				labelWidth : 20,
				fieldLabel : '计算公式',
				readOnly : true
			});

	//预算科目
	var formulaItemDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name'])
			});
	formulaItemDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : commonboxURL+'?action=item'
				+'&flag=1&year='+year
				+'&type='+ fitemTypeComb.getValue()
				+'&str='+ encodeURIComponent(Ext.getCmp('formulaItemComb').getRawValue()),
			method : 'POST'
		})
	});
	var formulaItemComb = new Ext.form.ComboBox({
				id :'formulaItemComb',
				fieldLabel : '预算项目',
				width : 250,
				listWidth: 285,
				allowBlank : true,
				store : formulaItemDs,
				valueField : 'code',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	formulaItemComb.on("select", function(cmb, rec, id) {
				if(gFormulaSet==""){
					showValue(cmb.getRawValue(), cmb.getValue());
				}else{
					showValue(cmb.getRawValue(), "," + cmb.getValue());
				}
				formulaItemComb.setValue("");
				// alert(rec.get('rowid'));
				checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
			});
	
	//预算类别
	var fitemTypeDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name'])
			});
	fitemTypeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : commonboxURL+'?action=itemtype&flag=1',
			method : 'POST'
		})
	});
	var fitemTypeComb = new Ext.form.ComboBox({
				fieldLabel : '预算类别',
				width : 100,
				listWidth: 285,
				allowBlank : true,
				store : fitemTypeDs,
				valueField : 'code',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	// 方案和核算单元联动
	fitemTypeComb.on("select", function(cmb, rec, id) {
				searchFun(cmb.getValue());
				formulaItemDs.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});
			
		function showValue(name, code) {
			gFormulaDesc = gFormulaDesc + name;
			if (gFormulaSet == "") {
				gFormulaSet = code;
			} else {
				gFormulaSet = gFormulaSet + code;
			}
			area.setValue(gFormulaDesc);
		};

		function searchFun(SetCfgDr) {
			formulaItemDs.proxy = new Ext.data.HttpProxy({
					url : commonboxURL+'?action=item'
						+'&flag=1'
						+'&year='+year
						+'&type='+ SetCfgDr.toString(),
					method : 'POST'
			});
			formulaItemDs.load({
						params : {
							start : 0,
							limit : 10
						}
					});
		};

	var formSet = new Ext.form.FormPanel({
				// title: '公式编辑区域',
				listWidth : 10,
				frame : true,
				fileUpload : true,
				bodyStyle : 'padding:5 5 5 5',
				region : 'north',
				height : 185,
				labelSeparator : ':',
				width : 510,
				items : [
					area,
					{
						xtype : 'panel',
						layout : "table",
						isFormField : true,
						layoutConfig : {
							columns : 4
						},
						items : [
							{
								xtype : 'label',
								text : '预算类别：'
							}, fitemTypeComb, {
								xtype : 'label',
								text : '预算项目：'
							}, formulaItemComb
						]
					}
				]
			});


	var autohisoutmedvouchForm = new Ext.form.FormPanel({
		listWidth : 20,
		// title: '公式编辑符号',
		region : 'center',
		frame : true,
		height : 25,
		bodyStyle : 'padding:5 5 5 5',
		labelSeparator : ':',
		width : 550,
		items : [{
					xtype : 'panel',
					layout : "column",
					hideLabel : true,
					isFormField : true,
					items : [{
								columnWidth : .05,
								xtype : 'button',
								text : '9',
								tooltip : '9',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									//checkStr = checkStr + ' '+ rec.get('rowid');
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '8',
								tooltip : '8',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '7',
								tooltip : '7',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '6',
								tooltip : '6',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '5',
								tooltip : '5',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '4',
								tooltip : '4',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '3',
								tooltip : '3',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '2',
								tooltip : '2',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '1',
								tooltip : '1',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '0',
								tooltip : '0',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '.',
								tooltip : '点',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '{',
								tooltip : '左大括弧',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '}',
								tooltip : '右大括弧',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '[',
								tooltip : '左中括弧',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : ']',
								tooltip : '右中括弧',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '(',
								tooltip : '左小括弧',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : ')',
								tooltip : '右小括弧',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '+',
								tooltip : '加号',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," +this.text;
									}
									checkStr = checkStr + ' ' + 'a' + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '-',
								tooltip : '减号',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '*',
								tooltip : '乘号',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '/',
								tooltip : '除号',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '^',
								tooltip : '指数',
								handler : function(b) {
									gFormulaDesc = gFormulaDesc + this.text;
									if(gFormulaSet==""){
										gFormulaSet=this.text;
									}else{
										gFormulaSet = gFormulaSet + "," + this.text;
									}
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .135,
								xtype : 'button',
								text : 'C',
								tooltip : '清空',
								handler : function(b) {
									gFormulaDesc = "";
									gFormulaSet = "";
									checkStr = "";
									area.setValue(gFormulaDesc);
								}
							}]
				}]
	});

	var OkButton = new Ext.Toolbar.Button({
		text : '确定',
		handler : function() {
			if(type==1){
				var rtn=gFormulaDesc+"="+gFormulaSet
				object.setValue(rtn)
			}
			if(type==2){
				var records = object.getSelectionModel().getSelections();
				records[0].set("formulaset",gFormulaSet)
				records[0].set("formuladesc",gFormulaDesc)
			}
			win.close();
		}
	});

	var cancelButton = new Ext.Toolbar.Button({
				text : '取消'
			});

	// 定义取消修改按钮的响应函数
	cancelHandler = function() {
		win.close();
	}

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);

	win = new Ext.Window({
				title : '公式设计器',
				width : 715,
				height : 320,
				minWidth : 715,
				minHeight : 320,
				layout : 'border',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : [formSet, autohisoutmedvouchForm],
				buttons : [OkButton, cancelButton]
			});
	// 窗口显示
	win.show();
}