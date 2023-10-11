//var userid = session['LOGON.USERID'];
//var acctbookid =IsExistAcctBook();

//------------------------------------------��ѯ����---------------------------------------------//
/**********�������*********/
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
		fieldLabel: '�������',
		width: 150,
		listWidth: 220,
		minChars: 1,
		pageSize: 10,
		store: AcctBookStore,
		displayField: 'AcctBookName',
		valueField: 'AcctBookID',
		triggerAction: 'all',
		emptyText: '�����������',
		selectOnFocus: true,
		forceSelection: true,
		typeAhead: true,
		editable: true

	});

//��λ���������б��
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
		fieldLabel: '��λ����ID',
		width: 200,
		listWidth: 200,
		allowBlank: false,
		store: AcctBookDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '��ѡ��λ����ID...',
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

////////////////// ����л�ƿ�Ŀ ///////////////////

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
		fieldLabel: '��ƿ�Ŀ',
		width: 150,
		listWidth: 250,
		queryModel: 'local',
		lazyRender: true, //ѡ��ʱ����
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
						title: 'ע��',
						msg: '����ѡ��λ���ף� ',
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
//��ƿ�Ŀ������
var colAcctSubjDs = new Ext.data.Store({
autoLoad:false,
proxy : '',
reader : new Ext.data.JsonReader({
totalProperty : 'results',root : 'rows'},
['AcctSubjCode','AcctSubjName','IsCashFlow'])
});

var AcctSubj = new Ext.form.ComboBox({
id : 'AcctSubj',
fieldLabel : '��ƿ�Ŀ',
width : 150,
listWidth : 250,
lazyRender : true, //ѡ��ʱ����
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
title:'ע��',
msg:'����ѡ��λ���ף� ',
icon:Ext.Msg.INFO,
buttons:Ext.Msg.OK
});
return;
}
// alert(rows+"&"+records[0].data["AcctBusiDeptMapID"])
if(rows!=records[0].data["ID"]){ //�ж�ѡ�����ǲ��ǵ�λ���׸ı���
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
////////////////// ��ѯ����ϵͳҵ��ģ�� ///////////////////
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
		fieldLabel:'ҵ��ģ��',
		store: BusiModuleNameDs,
		displayField: 'name',
		valueField: 'code',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ҵ��ģ������',
		width: 180,
		listWidth: 200,
		pageSize: 10,
		minChars: 1,
		columnWidth: .1,
		selectOnFocus: true
	});

////////////////// ��ѯ�������� ///////////////////
var ParamValueCom1 = new Ext.form.ComboBox({
		id: 'ParamValueCom1',
		fieldLabel: '����',
		width: 60,
		listWidth: 60,
		anchor: '95%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '�跽'], ['-1', '����']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '����',
		selectOnFocus: 'true'
	});

///////////// ��ѯ������Ŀ //////////////////////
var ProjText = new Ext.form.TextField({
		id: 'ProjText',
		fieldLabel: '��Ŀ����',
		width: 180,
		emptyText: '��Ŀ���������',
		selectOnFocus: 'true'
	});

///////////// ��ѯ������Ŀ //////////////////////
var SubjText = new Ext.form.TextField({
		fieldLabel: '��Ŀ',
		width: 100,
		emptyText: '��Ŀ���������',
		selectOnFocus: 'true'
	});

//----------------------------------------����е�������---------------------------------------------//
////////////////// �����ϵͳҵ��ģ�� ///////////////////
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
		fieldLabel:'ϵͳҵ��ģ��',
		store: BusiModuleNameDs,
		displayField: 'name',
		valueField: 'code',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ϵͳҵ��ģ������',
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

////////////////// �����ִ�в��ŷ��� ///////////////////

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
emptyText : '��Ʋ��ŷ���',
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
		data: [['01', '�ٴ�����'],
			['02', '�������'],
			['90', 'ͨ�ÿ���']]
	});
var AcctDeptTypeNameCom = new Ext.form.ComboBox({
		id: 'AcctDeptTypeNameCom',
		fieldLabel: '������Ŀ',
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
		emptyText: 'ѡ��ִ�в���...',
		mode: 'local', //����ģʽ
		editable: false,
		// pageSize: 10,
		// minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

////////////////// �����Ԥ���Ŀ ///////////////////
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
		emptyText: 'Ԥ���Ŀ',
		width: 200,
		listWidth: 200,
		pageSize: 10,
		minChars: 1,
		columnWidth: .1,
		selectOnFocus: true
	});

////////////////// ���� ///////////////////
var ParamValueCom = new Ext.form.ComboBox({
		id: 'ParamValueCom',
		fieldLabel: '����',
		width: 80,
		listWidth: 80,
		anchor: '95%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '�跽'], ['-1', '����']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true'
	});
////////////////// �Զ�����ƾ֤�����ֶ����� ///////////////////
var IsAutoCom = new Ext.form.ComboBox({
		fieldLabel: '�Ƿ��Զ�',
		width: 80,
		listWidth: 80,
		anchor: '95%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '�Զ�'], ['2', '�ֶ�']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true'
	});
///�ʽ�����
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
		emptyText: '�ʽ�����',
		width: 200,
		listWidth: 250,
		pageSize: 10,
		minChars: 1,
		columnWidth: .1,
		selectOnFocus: true
	});

////////////////// ��λ���� ///////////////////

//////////////////// ��ѯ��ť //////////////////////
var findButton = new Ext.Toolbar.Button({
		id: 'findbutton',
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		handler: function () {
			var ParamValueCon = ParamValueCom1.getValue();
			var BusiModuleNameCon = BusiModuleNameCom.getValue();
			var ProjCodeName = ProjText.getValue();
			var SubjCodeName = SubjText.getValue();
			var BookID = AcctBookField.getValue();

			//��Ӧ�̲���Ҫִ�в���
			if (BusiModuleNameCon == 'Dura01') {
				itemGrid.getColumnModel().setHidden(6, true); //ִ�в���
			} else {
				itemGrid.getColumnModel().setHidden(6, false); //ִ�в���
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
text : '�޸�',
tooltip : '�޸�',
iconCls : 'option',
handler :function() {
var recs=itemGrid.getStore().getModifiedRecords();//�����¼���ᱻ���ֵ�store�´�load֮ǰ
alert("���޸ļ�¼�ĸ���"+recs.length)

//��̨�õ�������¼
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
waitMsg:'������...',
failure: function(result, request){
Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
},
success: function(result, request){
var jsonData = Ext.util.JSON.decode( result.responseText );
if (jsonData.success=='true'){
Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});

//itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
}
else{
Ext.Msg.show({title:'����',msg:'�޸�ʧ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
}

}
});
}

}}
});
var printButton = new Ext.Toolbar.Button({
text : '��ӡ',
tooltip : '�����ӡ',
width : 70,
height : 30,
iconCls : 'option',
handler : function() {
var syscode=BusiModuleNameCom.getValue();
if(syscode==""){
Ext.Msg.show({title : 'ע��',msg : '����ѡ��ҵ��ģ������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
return ;
}
var fileName="{herp.acct.inter.VouchInterfaceMap.raq(code="+syscode+")}";
DHCCPM_RQDirectPrint(fileName);

}
});
 */
/**********���Ӱ�ť*********/
var addButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'add',
		handler: function () {
			itemGrid.add()
		}
	});
/**********���水ť*********/
var saveButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'save',
		handler: function () {
			itemGrid.save()
		}
	});
/**********ɾ����ť*********/
var delButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'remove',
		handler: function () {
			itemGrid.del()
		}
	});

	
// ['������ף�', AcctBookField, '-', 'ҵ��ģ�飺', BusiModuleNameCom, '-', 
// '��Ŀ���ƣ�', ProjText, '-','����',ParamValueCom1, '-', findButton]
var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //��ǩ���뷽ʽ
			labelSeparator: ' ', //�ָ���
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
		// title: 'ƾ֤�ӿ�����',
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
				header: '��λ����',
				allowBlank: true,
				width: 130,
				dataIndex: 'AcctBookName',
				type: AcctBookCom
			}, {
				id: 'BusiModuleName',
				header: 'ҵ��ģ��',
				allowBlank: false,
				width: 120,
				dataIndex: 'BusiModuleName',
				type: BusiModuleNameCom1
			}, {
				id: 'ItemCode',
				header: '��Ŀ����',
				allowBlank: false,
				width: 100,
				dataIndex: 'ItemCode'
			}, {
				id: 'ItemName',
				header: '��Ŀ����',
				allowBlank: false,
				width: 180,
				dataIndex: 'ItemName'
			}, {
				id: 'AcctDeptTypeName',
				header: 'ִ�в���',
				allowBlank: true,
				width: 90,
				dataIndex: 'AcctDeptTypeName',
				type: AcctDeptTypeNameCom
			}, {
				id: 'AcctSubjName',
				header: '��ƿ�Ŀ',
				width: 250,
				dataIndex: 'AcctSubjName',
				allowBlank: false,
				type: AcctSubjCom
			}, {
				id: 'AcctSummary',
				header: '���ժҪ',
				allowBlank: false,
				width: 180,
				dataIndex: 'AcctSummary'
			}, {
				id: 'AcctDirection',
				header: '����',
				allowBlank: false,
				width: 80,
				dataIndex: 'AcctDirection',
				type: ParamValueCom
			}, {
				id: 'ZjlxID',
				header: '�ʽ�����',
				allowBlank: true,
				width: 250,
				dataIndex: 'ZjlxID',
				hidden: true,
				type: CashFlowCom
			}, {
				id: 'IsAuto',
				header: '�Ƿ��Զ�',
				allowBlank: true,
				width: 80,
				dataIndex: 'IsAuto',
				hidden: true,
				type: IsAutoCom
			}, {
				id: 'MoneySource',
				header: '�ʽ���Դ',
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
