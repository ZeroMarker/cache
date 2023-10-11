//var userid = session['LOGON.USERID'];
//var acctbookid =IsExistAcctBook();

//------------------------------------------查询条件---------------------------------------------//
/**********会计账套*********/
var AcctBookStore = new Ext.data.Store({
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['AcctBookID', 'AcctBookName'])
	});
AcctBookStore.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			mothed: 'POST',
			url: 'herp.acct.acctvouchintertempexe.csp?action=AcctBook&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctBookField').getRawValue())
		})
});
var AcctBookField = new Ext.form.ComboBox({
		id: 'AcctBookField',
		fieldLabel: '会计账套',
		width: 150,
		listWidth: 220,
		minChars: 1,
		pageSize: 10,
		store: AcctBookStore,
		displayField: 'AcctBookName',
		valueField: 'AcctBookID',
		triggerAction: 'all',
		emptyText: '会计账套名称',
		selectOnFocus: true,
		forceSelection: true,
		typeAhead: true,
		editable: true

	});

//单位帐套下拉列表框
var AcctBookDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		},
			['rowid', 'name'])
	});

AcctBookDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctvouchintertempexe.csp' + '?action=caldept',
			method: 'POST'
		});
});

var rows;
var AcctBookCom = new Ext.form.ComboBox({
		id: 'AcctBookCom',
		fieldLabel: '单位账套ID',
		width: 200,
		listWidth: 200,
		allowBlank: false,
		store: AcctBookDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '请选择单位账套ID...',
		name: 'AcctBookCom',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		listeners: {
			select: function () {
				var currow = itemGrid.getSelectionModel().getSelections();
				rows = currow[0].data["rowid"];
				var BookID = AcctBookCom.getValue();
				//alert(BookID);
				if (BookID != "") {
					AcctSubjDs.removeAll();
					//AcctSubjCom.setValue();
					currow[0].data["AcctSubjName"] = "";
					AcctSubjDs.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'POST',
								url: 'herp.acct.acctvouchintertempexe.csp?action=GetSubjList&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctSubjCom').getRawValue()) + '&AcctBookID=' + BookID
							})
					});
					AcctSubjDs.load();
				}
			}
		}
	});

////////////////// 表格中会计科目 ///////////////////

var AcctSubjDs = new Ext.data.Store({
		autoLoad: false,
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		},
			['AcctSubjCode', 'AcctSubjName', 'IsCashFlow'])
	});

var AcctSubjCom = new Ext.form.ComboBox({
		id: 'AcctSubjCom',
		fieldLabel: '会计科目',
		width: 150,
		listWidth: 250,
		queryModel: 'local',
		lazyRender: true, //选择时加载
		minChars: 1,
		pageSize: 10,
		store: AcctSubjDs,
		displayField: 'AcctSubjName',
		valueField: 'AcctSubjCode',
		triggerAction: 'all',
		selectOnFocus: true,
		//typeAhead : true,
		forceSelection: true,
		editable: true,

		listeners: {
			focus: function () {
				var record = itemGrid.getSelectionModel().getSelections();
				var BookName = record[0].data["AcctBookName"];
				//var BookID=AcctBookCom.getValue();
				//alert(BookName);
				if (BookName == "") {

					Ext.Msg.show({
						title: '注意',
						msg: '请先选择单位账套！ ',
						icon: Ext.Msg.INFO,
						buttons: Ext.Msg.OK
					});
					return;
				}
				//alert(rows+"&"+record[0].data["rowid"]);
				if (rows != record[0].data["rowid"]) {

					AcctSubjDs.removeAll();
					// AcctSubjCom.setValue();

					AcctSubjDs.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'GET',
								url: 'herp.acct.acctvouchintertempexe.csp?action=GetSubjList&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctSubjCom').getRawValue()) + '&BookName=' + encodeURIComponent(BookName)
							})

					});

					AcctSubjDs.load();
				}
			}
		}
	});

/*
//会计科目数据列
var colAcctSubjDs = new Ext.data.Store({
autoLoad:false,
proxy : '',
reader : new Ext.data.JsonReader({
totalProperty : 'results',root : 'rows'},
['AcctSubjCode','AcctSubjName','IsCashFlow'])
});

var AcctSubj = new Ext.form.ComboBox({
id : 'AcctSubj',
fieldLabel : '会计科目',
width : 150,
listWidth : 250,
lazyRender : true, //选择时加载
minChars : 1,
pageSize : 10,
// queryModel : 'local',
store : colAcctSubjDs,
displayField :' AcctSubjName',
valueField : 'AcctSubjCode',
triggerAction : 'all',
typeAhead : true,
forceSelection : 'true',
editable : true,
listeners:{
focus:function(){
//alert(Ext.getCmp('AcctBook').getRawValue())
var records=itemGrid.getSelectionModel().getSelections();
var AcctBookName=records[0].data["AcctBookName"];
// var AcctBookID=records[0].data["AcctBookID"];
// alert(BookName)
if(AcctBookName==""){
Ext.Msg.show({
title:'注意',
msg:'请先选择单位账套！ ',
icon:Ext.Msg.INFO,
buttons:Ext.Msg.OK
});
return;
}
// alert(rows+"&"+records[0].data["AcctBusiDeptMapID"])
if(rows!=records[0].data["ID"]){ //判断选择行是不是单位账套改变行
colAcctSubjDs.removeAll();
AcctSubj.setValue();
colAcctSubjDs.on('beforeload', function (ds, o) {
ds.proxy = new Ext.data.HttpProxy({
method : 'POST',
//url:'herp.acct.acctvouchinterfacemapexe.csp?action=acctsubjlist',method:'POST'})
url : 'herp.acct.acctvouchintertempexe.csp?action=GetSubjList&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctSubjCom').getRawValue())+'&AcctBookName='+encodeURIComponent(AcctBookName)
})
});
colAcctSubjDs.load();
}
}

}

});

 */
////////////////// 查询条件系统业务模块 ///////////////////
var BusiModuleNameDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['code', 'name'])
	});

BusiModuleNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctvouchintertempexe.csp?action=busimodulenamelist',
			method: 'POST'
		});
});

var BusiModuleNameCom = new Ext.form.ComboBox({
		id: 'busimodulename',
		fieldLabel:'业务模块',
		store: BusiModuleNameDs,
		displayField: 'name',
		valueField: 'code',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '业务模块名称',
		width: 180,
		listWidth: 200,
		pageSize: 10,
		minChars: 1,
		columnWidth: .1,
		selectOnFocus: true
	});

////////////////// 查询条件余额方向 ///////////////////
var ParamValueCom1 = new Ext.form.ComboBox({
		id: 'ParamValueCom1',
		fieldLabel: '余额方向',
		width: 60,
		listWidth: 60,
		anchor: '95%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '借方'], ['-1', '贷方']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '余额方向',
		selectOnFocus: 'true'
	});

///////////// 查询条件项目 //////////////////////
var ProjText = new Ext.form.TextField({
		id: 'ProjText',
		fieldLabel: '项目名称',
		width: 180,
		emptyText: '项目编码或名称',
		selectOnFocus: 'true'
	});

///////////// 查询条件科目 //////////////////////
var SubjText = new Ext.form.TextField({
		fieldLabel: '科目',
		width: 100,
		emptyText: '科目编码或名称',
		selectOnFocus: 'true'
	});

//----------------------------------------表格中的下拉框---------------------------------------------//
////////////////// 表格中系统业务模块 ///////////////////
var BusiModuleNameDs1 = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['code', 'name'])
	});

BusiModuleNameDs1.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctvouchintertempexe.csp?action=busimodulenamelist',
			method: 'POST'
		});
	//url : 'herp.acct.acctvouchinterfacemapexe.csp?action=busimodulenamelist'&str='+encodeURIComponent(Ext.getCmp('BusiModuleNameCom1').getRawValue()),method:'POST'});

});

var BusiModuleNameCom1 = new Ext.form.ComboBox({
		id: 'BusiModuleNameCom1',
		fieldLabel:'系统业务模块',
		store: BusiModuleNameDs,
		displayField: 'name',
		valueField: 'code',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '系统业务模块名称',
		width: 200,
		listWidth: 200,
		pageSize: 10,
		minChars: 1,
		columnWidth: .1,
		selectOnFocus: true
		/*
		listeners:{
		"select":function(combo,record,index){
		AcctSubjDs.removeAll();
		AcctSubjCom.setValue('');
		AcctSubjDs.proxy=new Ext.data.HttpProxy({
		url:'herp.acct.acctvouchintertempexe.csp?action=GetSubjList&str='+encodeURIComponent(Ext.getCmp('AcctSubjCom').getRawValue())+'&code='+combo.value+'&acctbookid='+acctbookid,method:'POST'})
		AcctSubjDs.load({params:{start:0,limit:10}});
		}

		}*/

	});

////////////////// 表格中执行部门分类 ///////////////////

/*var AcctDeptTypeNameDs = new Ext.data.Store({
proxy : "",
reader : new Ext.data.JsonReader({
totalProperty : "results",
root : 'rows'
}, ['rowid', 'name'])
});

AcctDeptTypeNameDs.on('beforeload', function(ds, o) {
ds.proxy = new Ext.data.HttpProxy({
url : 'herp.acct.acctvouchinterfacemapexe.csp?action=acctdepttypelist',
method : 'POST'
});
});

var AcctDeptTypeNameCom = new Ext.form.ComboBox({
id:'AcctDeptTypeNameCom',
store : driectStoreCoCode,
displayField : 'name',
valueField : 'rowid',
typeAhead : true,
forceSelection : true,
triggerAction : 'all',
emptyText : '会计部门分类',
width : 200,
listWidth : 200,
pageSize : 10,
minChars : 1,
columnWidth : .1,
selectOnFocus : true

});
 */
var driectStoreCoCode = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['01', '临床科室'],
			['02', '管理科室'],
			['90', '通用科室']]
	});
var AcctDeptTypeNameCom = new Ext.form.ComboBox({
		id: 'AcctDeptTypeNameCom',
		fieldLabel: '数据项目',
		width: 100,
		listWidth: 100,
		selectOnFocus: true,
		allowBlank: false,
		store: driectStoreCoCode,
		//anchor: '90%',
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText: '选择执行部门...',
		mode: 'local', //本地模式
		editable: false,
		// pageSize: 10,
		// minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

////////////////// 表格中预算科目 ///////////////////
var budgSubjDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['code', 'name'])
	});

budgSubjDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctvouchintertempexe.csp?action=budgsubjlist',
			method: 'POST'
		});
});

var BudgSubjCom = new Ext.form.ComboBox({
		id: 'BudgSubjCom',
		store: budgSubjDs,
		displayField: 'name',
		valueField: 'code',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '预算科目',
		width: 200,
		listWidth: 200,
		pageSize: 10,
		minChars: 1,
		columnWidth: .1,
		selectOnFocus: true
	});

////////////////// 余额方向 ///////////////////
var ParamValueCom = new Ext.form.ComboBox({
		id: 'ParamValueCom',
		fieldLabel: '余额方向',
		width: 80,
		listWidth: 80,
		anchor: '95%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '借方'], ['-1', '贷方']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '选择...',
		selectOnFocus: 'true'
	});
////////////////// 自动生成凭证或者手动生成 ///////////////////
var IsAutoCom = new Ext.form.ComboBox({
		fieldLabel: '是否自动',
		width: 80,
		listWidth: 80,
		anchor: '95%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '自动'], ['2', '手动']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '选择...',
		selectOnFocus: 'true'
	});
///资金流向
var CashFlowDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['code', 'name'])
	});

CashFlowDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctvouchintertempexe.csp?action=CashFlowlist',
			method: 'POST'
		});

});

var CashFlowCom = new Ext.form.ComboBox({
		id: 'CashFlowCom',
		store: CashFlowDs,
		displayField: 'name',
		valueField: 'code',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '资金流向',
		width: 200,
		listWidth: 250,
		pageSize: 10,
		minChars: 1,
		columnWidth: .1,
		selectOnFocus: true
	});

////////////////// 单位帐套 ///////////////////

//////////////////// 查询按钮 //////////////////////
var findButton = new Ext.Toolbar.Button({
		id: 'findbutton',
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		handler: function () {
			var ParamValueCon = ParamValueCom1.getValue();
			var BusiModuleNameCon = BusiModuleNameCom.getValue();
			var ProjCodeName = ProjText.getValue();
			var SubjCodeName = SubjText.getValue();
			var BookID = AcctBookField.getValue();

			//供应商不需要执行部门
			if (BusiModuleNameCon == 'Dura01') {
				itemGrid.getColumnModel().setHidden(6, true); //执行部门
			} else {
				itemGrid.getColumnModel().setHidden(6, false); //执行部门
			}
			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					ParamValueCon: ParamValueCon,
					BusiModuleNameCon: BusiModuleNameCon,
					ProjCodeName: ProjCodeName,
					SubjCodeName: SubjCodeName,
					acctbookid: BookID
				}
			});
		}
	});
/*
var saveButton = new Ext.Toolbar.Button({
text : '修改',
tooltip : '修改',
iconCls : 'option',
handler :function() {
var recs=itemGrid.getStore().getModifiedRecords();//这个记录数会被保持到store下次load之前
alert("被修改记录的个数"+recs.length)

//后台得到整条记录
if(recs.length==0){
return
}else{
for(var i=0;i<recs.length;i++){
var rowid = recs[i].get("1601");
var BusiModuleName = recs[i].get("2");
var ItemCode = recs[i].get("3");
var ItemName = recs[i].get("4");
var AcctDeptTypeName = recs[i].get("5");
var AcctSubjName = recs[i].get("6|12");
var AcctSummary = recs[i].get("7");
var AcctDirection = recs[i].get("8");
var ZjlxID = recs[i].get("9:12");
var IsAuto = recs[i].get("1");
var AcctBookName = recs[i].get("1");
var moneySource = recs[i].get("1");
alert("AcctBookName");
Ext.Ajax.request({
url:'../csp/herp.acct.acctvouchintertempexe.csp?action=edit&rowid='+rowid+'&BusiModuleName='+encodeURIComponent(BusiModuleName)+'&ItemCode='+encodeURIComponent(ItemCode)+'&ItemName='+encodeURIComponent(ItemName)+'&AcctDeptTypeName='+encodeURIComponent(AcctDeptTypeName)+'&AcctSubjName='+encodeURIComponent(AcctSubjName)+'&AcctSummary='+encodeURIComponent(AcctSummary)+'&AcctDirection='+encodeURIComponent(AcctDirection)+'&ZjlxID='+encodeURIComponent(ZjlxID)+'&IsAuto='+encodeURIComponent(IsAuto)+'&AcctBookName='+encodeURIComponent(AcctBookName)+'&moneySource='+encodeURIComponent(moneySource),
waitMsg:'保存中...',
failure: function(result, request){
Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
},
success: function(result, request){
var jsonData = Ext.util.JSON.decode( result.responseText );
if (jsonData.success=='true'){
Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});

//itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
}
else{
Ext.Msg.show({title:'错误',msg:'修改失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
}

}
});
}

}}
});
var printButton = new Ext.Toolbar.Button({
text : '打印',
tooltip : '点击打印',
width : 70,
height : 30,
iconCls : 'option',
handler : function() {
var syscode=BusiModuleNameCom.getValue();
if(syscode==""){
Ext.Msg.show({title : '注意',msg : '请先选择业务模块名称!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
return ;
}
var fileName="{herp.acct.inter.VouchInterfaceMap.raq(code="+syscode+")}";
DHCCPM_RQDirectPrint(fileName);

}
});
 */
/**********增加按钮*********/
var addButton = new Ext.Toolbar.Button({
		text: '增加',
		tooltip: '增加',
		iconCls: 'add',
		handler: function () {
			itemGrid.add()
		}
	});
/**********保存按钮*********/
var saveButton = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存',
		iconCls: 'save',
		handler: function () {
			itemGrid.save()
		}
	});
/**********删除按钮*********/
var delButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'remove',
		handler: function () {
			itemGrid.del()
		}
	});

	
// ['会计账套：', AcctBookField, '-', '业务模块：', BusiModuleNameCom, '-', 
// '项目名称：', ProjText, '-','余额方向：',ParamValueCom1, '-', findButton]
var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //标签对齐方式
			labelSeparator: ' ', //分隔符
			labelWidth: 60,
			border: false,
			bodyStyle: 'padding:5px;'
		},
		width: 1200,
		layout: 'column',
		items: [{
				xtype: 'fieldset',
				width: 260,
				items: AcctBookField
			}, {
				xtype: 'fieldset',
				width: 290,
				items: BusiModuleNameCom
			},{
				xtype: 'fieldset',
				width: 290,
				items: ProjText
			},{
				xtype: 'fieldset',
				width: 200,
				items: ParamValueCom1
			}, {
				xtype: 'fieldset',
				width:100,
				items: findButton
			}
		]

	});



var itemGrid = new dhc.herp.Grid({
		// title: '凭证接口配置',
		width: 400,
		region: 'center',
		url: 'herp.acct.acctvouchintertempexe.csp',
		atLoad: false,
		// tbar: [addButton, '-', saveButton, '-', delButton],
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		fields: [{
				header: 'ID',
				id: 'rowid',
				dataIndex: 'rowid',
				edit: false,
				hidden: true
			}, {
				id: 'AcctBookName',
				header: '单位帐套',
				allowBlank: true,
				width: 130,
				dataIndex: 'AcctBookName',
				type: AcctBookCom
			}, {
				id: 'BusiModuleName',
				header: '业务模块',
				allowBlank: false,
				width: 120,
				dataIndex: 'BusiModuleName',
				type: BusiModuleNameCom1
			}, {
				id: 'ItemCode',
				header: '项目编码',
				allowBlank: false,
				width: 100,
				dataIndex: 'ItemCode'
			}, {
				id: 'ItemName',
				header: '项目名称',
				allowBlank: false,
				width: 180,
				dataIndex: 'ItemName'
			}, {
				id: 'AcctDeptTypeName',
				header: '执行部门',
				allowBlank: true,
				width: 90,
				dataIndex: 'AcctDeptTypeName',
				type: AcctDeptTypeNameCom
			}, {
				id: 'AcctSubjName',
				header: '会计科目',
				width: 250,
				dataIndex: 'AcctSubjName',
				allowBlank: false,
				type: AcctSubjCom
			}, {
				id: 'AcctSummary',
				header: '会计摘要',
				allowBlank: false,
				width: 180,
				dataIndex: 'AcctSummary'
			}, {
				id: 'AcctDirection',
				header: '余额方向',
				allowBlank: false,
				width: 80,
				dataIndex: 'AcctDirection',
				type: ParamValueCom
			}, {
				id: 'ZjlxID',
				header: '资金流向',
				allowBlank: true,
				width: 250,
				dataIndex: 'ZjlxID',
				hidden: true,
				type: CashFlowCom
			}, {
				id: 'IsAuto',
				header: '是否自动',
				allowBlank: true,
				width: 80,
				dataIndex: 'IsAuto',
				hidden: true,
				type: IsAutoCom
			}, {
				id: 'MoneySource',
				header: '资金来源',
				allowBlank: true,
				width: 80,
				hidden: true,
				dataIndex: 'MoneySource'
			}
		]

	});

itemGrid.btnPrintHide();
itemGrid.btnResetHide();
//itemGrid.addButton(printButton);
//itemGrid.addButton(saveButton);
