EditFun = function(itemGrid){

var username = session['LOGON.USERNAME'];
var userId	= session['LOGON.USERID'];
Username=userId+'_'+username;
var billcode = "";
var statetitle = name +"֧������";

var selectedRow = itemGrid.getSelectionModel().getSelections();
var rowidm=selectedRow[0].data['rowid'];
var yearmonth=selectedRow[0].data['checkyearmonth'];
var billcode=selectedRow[0].data['billcode'];
var dname=selectedRow[0].data['dname'];
var uname=selectedRow[0].data['applyer'];
var mdesc=selectedRow[0].data['applydecl'];
var deptdr=selectedRow[0].data['deprdr'];
var applycode=selectedRow[0].data['applycode'];
dname=deptdr+'_'+dname;
var billstate=selectedRow[0].data['billstate'];
var audeprdr=selectedRow[0].data['audeprdr'];
var audname=selectedRow[0].data['audname'];
var audname=audeprdr+'_'+audname;
var CheckDR=selectedRow[0].data['CheckDR'];
var FundSour=selectedRow[0].data['FundSour'];

/////////////////////��������/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:billcode,
			disabled: true,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.Ajax.request({
					url: '../csp/herp.budg.expenseaccountdetailexe.csp?action=getclaimcode',				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcode = jsonData.info;
							applyNo.setValue(bcode);
						}else{
							var message="";
							if(jsonData.info=='RepCode') message='���ݺ��Ѿ����ڣ���س��������ɣ�';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							applyNo.focus();
						}
					},
					scope: this
					});
					appuName.focus();
						
						}
					}}

		});
/////////////////////������/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: uname,
			disabled: true,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(appuName.getValue()!==""){
						Descfield.focus();
					}else{
					Handler = function(){appuName.focus();};
					Ext.Msg.show({title:'����',msg:'�����˲���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}

		});
/////////////////////����˵��/////////////////////////
 Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : mdesc,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(Descfield.getValue()!==""){
						timeCombo.focus();
					}else{
					Handler = function(){Descfield.focus();};
					Ext.Msg.show({title:'����',msg:'����˵������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}

		});
/////////////////////Ԥ����/////////////////////////
 var timeDs = new Ext.data.Store({
 	proxy : "",
 	reader : new Ext.data.JsonReader({
 				totalProperty : "results",
 				root : 'rows'
 			}, ['yearmonth', 'yearmonth'])
 });

 timeDs.on('beforeload', function(ds, o) {

 	ds.proxy = new Ext.data.HttpProxy({
 				url : 'herp.budg.expenseaccountdetailexe.csp?action=timelist',
 				method : 'POST'
 			});
 });

  timeCombo = new Ext.form.ComboBox({
 	fieldLabel : 'Ԥ����',
 	store : timeDs,
 	displayField : 'yearmonth',
 	valueField : 'yearmonth',
 	disabled:false,
 	typeAhead : true,
 	forceSelection : true,
			triggerAction : 'all',
			value : yearmonth,
			emptyText : '��ѡ��...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(timeCombo.getValue()!==""){
						dnamefield.focus();
					}else{
					Handler = function(){yearmonField.focus();};
					Ext.Msg.show({title:'����',msg:'Ԥ���ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});
	
/////////////////////��������/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : dname,
			emptyText : '�س����ɿ���...',
			disabled: true,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.Ajax.request({
					url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getdept&userID='+userId,				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var dept = jsonData.info;
							dnamefield.setValue(dept);
							applyCombo.focus();
						}else{
							var message="";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							dnamefield.focus();
						}
					},
					scope: this
					});
						
						}
					}}

		});	
///////////////////////�ʽ����뵥��/////////////////////
var applyDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'applycode'])
});

applyDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.expenseaccountdetailexe.csp?action=applycode&&userdr='+userId,
				method : 'POST'
			});
});

 applyCombo = new Ext.form.ComboBox({
	fieldLabel : '�ʽ����뵥��',
	store : applyDs,
	displayField : 'applycode',
	valueField : 'rowid',
	disabled:true,
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 90,
	value:applycode,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true,
		listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(applyCombo.getValue()!==""){
						audnamefield.focus();
					}else{
					Handler = function(){applyCombo.focus();};
					Ext.Msg.show({title:'����',msg:'�ʽ����뵥�Ų���Ϊ��!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
});
applyCombo.on('focus', function(f){
				AddReqFun(applyCombo);
			});	

///////////////��ڿ���////////////////////////
var audnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

audnameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgctrlfundbillmngexe.csp?action=deptlist&flag=1',
						method : 'POST'
					});
		});

var audnamefield = new Ext.form.ComboBox({
			fieldLabel : '��ڿ���',
			store : audnameDs,
			displayField : 'name',
			valueField : 'rowid',
			value : audname,
			typeAhead : true,
			disabled: true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(audnamefield.getValue()!==""){
							checkflowField.focus();
						}else{
							Handler = function(){audnamefield.focus();};
							Ext.Msg.show({title:'����',msg:'��ڿ��Ҳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						}
					}}
		});
////////////������//////////////////////
var checkflowDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
		});

checkflowDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({
url :'../csp/herp.budg.budgctrlfundbillmngexe.csp?action=checkflowlist',method : 'POST'});});

var checkflowField = new Ext.form.ComboBox({
			fieldLabel : '������',
			store : checkflowDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			value:CheckDR,
			disabled: true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ��...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(checkflowField.getValue()!==""){
						fundsourceField.focus();
					}else{
					Handler = function(){checkflowField.focus();};
					Ext.Msg.show({title:'����',msg:'����������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});
/////////////////////�ʽ���Դ////////////////////////////
var fundsourceStore = new Ext.data.SimpleStore({
						fields:['key','keyValue'],
						data:[['1','�ֽ�'],['2','����']]
					});
var fundsourceField = new Ext.form.ComboBox({
						id: 'fundsourceField',
						fieldLabel: '�ʽ���Դ',
						width:120,
						allowBlank: false,
						store: fundsourceStore,
						value:FundSour,
						anchor: '90%',
						displayField: 'keyValue',
						valueField: 'key',
						triggerAction: 'all',
						emptyText:'ѡ��...',
						mode: 'local', // ����ģʽ
						pageSize: 10,
						minChars: 15,
						columnWidth : .15,
						selectOnFocus:true,
						forceSelection:true,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(fundsourceField.getValue()!==""){
									fundsourceField.focus();
									}else{
									Handler = function(){fundsourceField.focus();};
									Ext.Msg.show({title:'����',msg:'�ʽ���Դ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
									}
								}
							}
						}
					});


var queryPanel = new Ext.FormPanel({
	height : 120,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '��������:',
					columnWidth : .12
				}, applyNo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '��������:',
					columnWidth : .12
				},dnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '������:',
					columnWidth : .12
				}, appuName

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '����˵��:',
					columnWidth : .12
				}, Descfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : 'Ԥ����:',
					columnWidth : .12
				},timeCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '�ʽ����뵥��:',
					columnWidth : .12
				}, applyCombo

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '��ڿ���:',
					columnWidth : .12
				},audnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '������:',
					columnWidth : .12
				},checkflowField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '�ʽ���Դ:',
					columnWidth : .12
				}, fundsourceField
		]
	}]
});

// ////////////Ԥ��������////////////////////////
var codeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

codeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgctrlfundbillmngexe.csp?action=itemcodelist&year='+ timeCombo.getValue().substr(0,4),
						method : 'POST'
					});
		});

var codeCombo = new Ext.form.ComboBox({
			fieldLabel : 'Ԥ����',
			store : codeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});

//����¼��
var valueField = new Ext.form.TextField({
	id: 'valueField',
	width:215,
	listWidth : 215,
	name: 'valueField',
	regex : /^(-?\d+)(\.\d+)?$/,
	regexText : "ֻ����������",
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////��Ӱ�ť////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '����',
    tooltip:'����',        
    iconCls: 'save',
	handler:function(){
	Add1Fun();			//�������뵥�ݹ������
	}
	
});

//////////////////�ύ/////////////////////
var SubButton = new Ext.Toolbar.Button({
			text : '�ύ',
			tooltip : '�ύ',
			iconCls:'add',
			handler : function() {
				var rowObj = editGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({title : 'ע��',msg : '��ѡ����Ҫ�ύ�ļ�¼!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return;
				}
				var rowid = rowObj[0].get("rowid");
				var idm = rowObj[0].get("billdr");
				var reqpay = rowObj[0].get("reqpay");
				var itemcode = rowObj[0].get("itemcode");
				var State = rowObj[0].get("State");
				if(State=="�ύ"){
					Ext.Msg.show({
								title : '����',
								msg : '��¼�Ѿ��ύ,�����ظ��ύ!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				}
				var yearmonth = timeCombo.getValue();
				var deptdr = dnamefield.getValue();
				var audeptdr = audnamefield.getValue();
				var arr = deptdr.split("_");deptdr=arr[0];
				Ext.Ajax.request({
					url : 'herp.budg.expenseaccountdetailexe.csp?action=submit&rowid='+rowid+'&idm='+idm+'&reqpay='+reqpay+'&itemcode='+itemcode+'&yearmonth='+yearmonth+'&deptdr='+deptdr+'&audeptdr='+audeptdr+'&billcode='+billcode,
					failure : function(result, request) {
						Ext.Msg.show({title : '����',msg : '������������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({title : 'ע��',msg : '�ύ�ɹ�!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
							editGrid.load({params:{start:0, limit:25,billcode:billcode}});
						} else {
							var message="SQLErr: "+ jsonData.info;
							Ext.Msg.show({title : '����',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
					},
					scope : this
				});
			}
		});
///////��ӡ��ť
/*var printButton = new Ext.Toolbar.Button({
	text: '��ӡ',
    tooltip:'��ӡ',        
    iconCls:'add',
	handler:function(){
	
	url : 'dhccpmrunqianreport.csp?reportName=herp.budg.report.budgctrlpaybillprint.raq&billcode='+billcode;

	}
});*/
///////��ӡ��ť
var printButton = new Ext.Toolbar.Button({
    text : '��ӡ',
	tooltip : '�����ӡ������',
	width : 70,
	height : 30,
	iconCls : 'print',
	handler : function() {
	
	//alert(billcode);
	fileName="{herp.budg.report.budgctrlpaybillprint.raq(billcode1="+billcode+")}";
	DHCCPM_RQDirectPrint(fileName);

    }
});
                
var editGrid = new dhc.herp.Grid({
				width : 600,
				height : 150,
				region : 'center',
				url : 'herp.budg.expenseaccountdetailexe.csp',
				tbar:addButton,
				forms : [],
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // �����������õ�Ԫ�����༭�Ƿ����
		                  //alert(columnIndex);
		                  if ((record.get('ItemName')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+audeprdr+'&yearmonth='+yearmonth+'&itemcode='+record.get('ItemName'),				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.Balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}  
		                    if (((record.get('rowid') != "")&& (columnIndex == 4))||((record.get('State') == "�ύ")&& (columnIndex == 6))) {
		                         return false;
		                     } else {return true;}
		                    
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						if ((record.get('ItemName')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+audeprdr+'&yearmonth='+yearmonth+'&itemcode='+record.get('ItemName'),				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.Balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}
						if (((record.get('rowid') != "")&& (columnIndex == 4))||((record.get('State') == "�ύ")&& (columnIndex == 6))) {
		                         return false;
		                     } else {return true;}
					}
	            },
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'billdr',
							header : '��������ID',
							dataIndex : 'billdr',
							width : 120,
							hidden:true
						},{
							id : 'itemcode',
							header : 'Ԥ�������',
							dataIndex : 'itemcode',
							hidden:true,
							width : 120
						},{
							id : 'itemname',
							header : 'Ԥ����',
							dataIndex : 'itemname',
							width : 120,
							type:codeCombo
						},{
							id : 'balance',
							header : '��ǰԤ�����',
							dataIndex : 'balance',
							align:'right',
							xtype:'numbercolumn',
							width : 120,
							editable:false
						},{
							id : 'reqpay',
							header : '���α�������',
							dataIndex : 'reqpay',
							align:'right',
							xtype:'numbercolumn',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width : 120
						},{
							id : 'actpay',
							header : '����֧��',
							align:'right',
							xtype:'numbercolumn',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							dataIndex : 'actpay',
							editable:true,
							width : 120
						},{
							id : 'balance1',
							header : '������Ԥ�����',
							dataIndex : 'balance1',
							align:'right',
							xtype:'numbercolumn',
							editable:false,
							width : 120

						},{
							id : 'budgcotrol',
							header : 'Ԥ�����',
							dataIndex : 'budgcotrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcotrol']
							if (sf == "��Ԥ��") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false
						},{
							id : 'State',
							header : '״̬',
							dataIndex : 'State',
							editable:false,
							width : 80
						}],
						viewConfig : {forceFit : true}
			});
 
 		
Add1Fun=function() {
		var records=editGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = editGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var rtn = 0;
	    var datad="";
		Ext.each(records, function(r) {
			var o = {};
			var tmpstro = "&rowid=" + r.data['rowid'];
			var deleteFlag = r.data['delFlag'];// ɾ����ʶ��1���Ǹü�¼�Ѿ�ɾ����0��δɾ����

			// ������������֤Beging
			for (var i = 0; i < editGrid.fields.length; i++) {
				var indx = editGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = editGrid.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// ������update���ԣ�true����������û�б仯Ҳ���̨�ύ���ݣ�false���򲻻�ǿ���ύ����
					var reValue = r.data[indx];
					if ((typeof(reValue) != "undefined") && (tmobj.update)) {
						tmpstro += "&" + indx + "=" + r.data[indx].toString();
					}
					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")|| (parseInt(r.data[indx].toString()) == 0)) {
							var info = "[" + title + "]��Ϊ���������Ϊ�ջ��㣡"
							Ext.Msg.show({
										title : '����',
										msg : info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							rtn = -1;
							return -1;

						}
					}
				}

			}
			// ������������֤END

			if (r.isValid()) {
				if (deleteFlag == "-1") {
					return;
				}
			var paybilldr = r.data['billdr'];
			var itemcode = r.data['itemcode'];
			if(itemcode==""){
			var itemcode = r.data['itemname'];
			}
			var reqpay = r.data['reqpay'];
			var actpay = r.data['actpay'];
			var budgbalance = r.data['balance'];
			//BillDR ItemName Balance ReqPay ActPay Balance1
			//FundBillDR ItemCode ReqPay ActPay Desc BudgBalance
			var datad = paybilldr+"|"+itemcode+"|"+reqpay+"|"+actpay+"|"+budgbalance;
			} else {
				Ext.Msg.show({
							title : '����',
							msg : '�뽫�����������������!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}
			
			var billcode = applyNo.getValue();
			var yearmonth = timeCombo.getValue();
			var deptdr = dnamefield.getValue();
			var arr = deptdr.split("_");deptdr=arr[0];
			var userdr = appuName.getValue();
			var arr1 = userdr.split("_"); userdr=arr1[0];
			var mdesc = Descfield.getValue();
			var applycode = applyCombo.getValue();
			var fundsource = fundsourceField.getValue();
			var audeptdr = audnamefield.getValue();
			var arr2 = audeptdr.split("_"); audeptdr=arr2[0];
			var checkdr = checkflowField.getValue();
			var datam = billcode+"|"+yearmonth+"|"+deptdr+"|"+userdr+"|"+mdesc+"|"+applycode+"|"+checkdr+"|"+audeptdr+"|"+fundsource;
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
			} else {
				recordType = "edit";
			}
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = editGrid.url + '?action=' + recordType + tmpstro.toString() +"&rowidm="+rowidm+"&datad="+encodeURIComponent(datad)+"&datam="+encodeURIComponent(datam)
					+ Ext.urlEncode(this.urlParam);
			p = {
				url : saveUrl,
				method : 'GET',
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {

						var message = "";
						message = recordType == 'add' ? '��ӳɹ�!' : '����ɹ�!'
						Ext.Msg.show({
									title : 'ע��',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						editGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							editGrid.store.load({
								params : {
									start : Ext
											.isEmpty(editGrid.getTopToolbar().cursor)
											? 0
											: editGrid.getTopToolbar().cursor,
									limit : editGrid.pageSize,
									billcode:billcode
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							editGrid.store.load({
								params : {
									start : Ext
											.isEmpty(editGrid.getTopToolbar().cursor)
											? 0
											: editGrid.getTopToolbar().cursor,
									limit : editGrid.pageSize,
									billcode:billcode
								}
							});
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '���������Ϊ��!';
						if (jsonData.info == 'EmptyOrder')
							message = '��������Ϊ��!';
						if (jsonData.info == 'RepCode')
							message = '����ı����Ѿ�����!';
						if (jsonData.info == 'RepName')
							message = '����������Ѿ�����!';
						if (jsonData.info == 'RepOrder')
							message = '���������Ѿ�����!';
						if (jsonData.info == 'RecordExist')
							message = '����ļ�¼�Ѿ�����!';
						Ext.Msg.show({
									title : '����',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						editGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
	}
editGrid.load({params:{start:0, limit:25,billcode:billcode}});
editGrid.addButton(SubButton);
editGrid.addButton(printButton);
//editGrid.btnAddHide();
editGrid.btnSaveHide();
editGrid.btnResetHide();
//editGrid.btnDeleteHide();
editGrid.btnPrintHide();

if(billstate=='�ύ') {
	var tbar = editGrid.getTopToolbar();
	var addbutton = tbar.get('herpAddId');
	var deletebutton = tbar.get('herpDeleteId');
	addbutton.disable();
	addButton.disable();
	deletebutton.disable();
	SubButton.disable();
}


	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){
		itemGrid.load({params:{start:0, limit:12, userdr:userId}});
	  	window.close();
	};

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [queryPanel,editGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,editGrid]                                 //���Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : '��������',
				plain : true,
				width : 950,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	
	window.show();	
	//window.on('beforeclose',del);
	
};