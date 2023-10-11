EditFun = function(itemGrid){

var userCode = session['LOGON.USERCODE'];
var Username = session['LOGON.USERNAME'];
var userId	= session['LOGON.USERID'];
Username=userId+'_'+Username;
var Billcode = "";
var statetitle = name +"֧������";

var selectedRow = itemGrid.getSelectionModel().getSelections();
var rowidm=selectedRow[0].data['rowid'];
var yearmonth=selectedRow[0].data['YearMonth'];
var billcode=selectedRow[0].data['BillCode'];
var dname=selectedRow[0].data['dName'];
var uname=selectedRow[0].data['uName'];
var desc=selectedRow[0].data['Desc'];
var deptID=selectedRow[0].data['deptID'];
dname=deptID+'_'+dname;
var billstate=selectedRow[0].data['BillState'];
var chkFlow=selectedRow[0].data['CheckDR'];
var tmpCheckid=selectedRow[0].data['Checkid'];
var audeprdr=selectedRow[0].data['audeprdr'];
var audname=selectedRow[0].data['audname'];
audname=audeprdr+'_'+audname;

/////////////////////���뵥��/////////////////////////
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
					url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getbcode',				
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
					dnamefield.focus();
						
						}
					}}

		});

/////////////////////��Ŀ����/////////////////////////
var projnameDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
});

projnameDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=projname&&userdr='+ userid+ '&rowId=' + projDr,
				method : 'POST'
			});
});

var projnameCombo = new Ext.form.ComboBox({
	fieldLabel : '��Ŀ����',
	store : projnameDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	disabled:true,
	allowBlank:false,
	width : 90,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
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
			value : desc,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(Descfield.getValue()!==""){
						yearmonField.focus();
					}else{
					Handler = function(){Descfield.focus();};
					Ext.Msg.show({title:'����',msg:'����˵������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}

		});		
// ////////////��������////////////////////////
var dnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

dnameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgctrlfundbillmngexe.csp?action=deptlist&flag=2',
						method : 'POST'
					});
		});

var dnamefield = new Ext.form.ComboBox({
			fieldLabel : '��������',
			store : dnameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			value : dname,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			disabled: true,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(dnamefield.getValue()!==""){
							appuName.focus();
						}else{
							Handler = function(){dnamefield.focus();};
							Ext.Msg.show({title:'����',msg:'�������Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						}
					}}
		});
///////////////��ڿ���////////////////////////
var audnameDs = new Ext.data.Store({
	proxy : "",reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
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
			typeAhead : true,
			value : audname,
			disabled:true,
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

/*
/////////////////////�������/////////////////////////
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
							appuName.focus();
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

		});*/
////////////Ԥ����//////////////////////
var yearmonDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['yearmonth', 'yearmonth'])
		});

yearmonDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({url : projUrl+'?action=yearmonthlist',method : 'POST'});});

var yearmonField = new Ext.form.ComboBox({
			fieldLabel : 'Ԥ����',
			store : yearmonDs,
			displayField : 'yearmonth',
			valueField : 'yearmonth',
			typeAhead : true,
			//disabled: true,
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
					if(yearmonField.getValue()!==""){
						checkflowField.focus();
					}else{
					Handler = function(){yearmonField.focus();};
					Ext.Msg.show({title:'����',msg:'Ԥ���ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
			value : chkFlow,
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
						checkflowField.focus();
					}else{
					Handler = function(){checkflowField.focus();};
					Ext.Msg.show({title:'����',msg:'����������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});
checkflowField.on('select',function(combo, record, index){
			tmpCheckid = combo.getValue();
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
					value : '���뵥��:',
					columnWidth : .12
				}, applyNo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '�������:',
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
					value : '���˵��:',
					columnWidth : .12
				}, Descfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : 'Ԥ����:',
					columnWidth : .12
				},yearmonField,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '������:',
					columnWidth : .12
				}, checkflowField

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
				}, audnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}

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
						url : 'herp.budg.budgctrlfundbillmngexe.csp?action=itemcodelist&year='+ yearmonField.getValue().substr(0,4),
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

//��ǰԤ�����
var budgbalanceDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['name', 'name'])
});

budgbalanceDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp'+'?action=budgbalance&&itemcode='+ codeCombo.getValue(),
				method : 'POST'
			});
});

var budgbalanceCombo = new Ext.form.ComboBox({
	fieldLabel : '��ǰԤ�����',
	store : budgbalanceDs,
	displayField : 'name',
	valueField : 'name',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 70,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
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
				var rowObj = editmainGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({title : 'ע��',msg : '��ѡ����Ҫ�ύ�ļ�¼!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return;
				}
				var ReqPay = rowObj[0].get("ReqPay");
				var itemcode = rowObj[0].get("ItemCode");
				var State = rowObj[0].get("State");
				if((State=="�ύ")||(State=="���")){
					Ext.Msg.show({
								title : '����',
								msg : '��¼�Ѿ��ύ,�����ظ��ύ!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				}
				
				var yearmonth = yearmonField.getValue();
				var deptdr = dnamefield.getValue();
				var audeptdr = audnamefield.getValue();
				var arr = deptdr.split("_");deptdr=arr[0];
				var arr1 = audeptdr.split("_");audeptdr=arr1[0];
				
				Ext.Ajax.request({
					url : 'herp.budg.budgctrlfundbillmngexe.csp?action=submit&ReqPay='+ReqPay+'&itemcode='+itemcode+'&yearmonth='+yearmonth+'&deptdr='+deptdr+'&audeptdr='+audeptdr,
					failure : function(result, request) {
						Ext.Msg.show({title : '����',msg : '������������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({title : 'ע��',msg : '�ύ�ɹ�!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
							editmainGrid.load({params:{start:0, limit:25,BillCode:billcode}});
						} else {
							var message="SQLErr: "+ jsonData.info;
							if(jsonData.info=='Empty') message='�ü�¼δ����Ԥ���';
							Ext.Msg.show({title : '����',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
					},
					scope : this
				});
			}
		});

var editmainGrid = new dhc.herp.Grid({
				width : 600,
				region : 'center',
				url : 'herp.budg.budgctrlfundbillmngexe.csp',
				tbar:addButton,
				forms : [],
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // �����������õ�Ԫ�����༭�Ƿ����
		                  //alert(columnIndex);
		                  if ((record.get('ItemName')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+audeprdr+'&yearmonth='+yearmonth+'&itemcode='+record.get('ItemName')+'&state=""&rowidd=""',				
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
		                    if (((record.get('rowid') != "")&& (columnIndex == 4))||((record.get('State') !== "�½�")&& (columnIndex == 6))) {
		                         return false;
		                     } else {return true;}
		                    
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						if ((record.get('ItemName')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+audeprdr+'&yearmonth='+yearmonth+'&itemcode='+record.get('ItemName')+'&state=""&rowidd=""',				
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
						if (((record.get('rowid')!="")&&(columnIndex == 4))||((record.get('State') !== "�½�")&& (columnIndex == 6))){
							return false;
						} else {
							return true;
						}
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
							id : 'BillDR',
							header : '��������ID',
							dataIndex : 'BillDR',
							width : 120,
							hidden:true
						},{
							id : 'ItemCode',
							header : 'Ԥ�������',
							dataIndex : 'ItemCode',
							hidden:true,
							width : 120
						},{
							id : 'ItemName',
							header : 'Ԥ����',
							dataIndex : 'ItemName',
							width : 120,
							type:codeCombo
						},{
							id : 'Balance',
							header : 'ĿǰԤ�����',
							dataIndex : 'Balance',
							align:'right',
							xtype:'numbercolumn',
							width : 120,
							editable:false
						},{
							id : 'ReqPay',
							header : '������',
							dataIndex : 'ReqPay',
							align:'right',
							xtype:'numbercolumn',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width : 120
						},{
							id : 'ActPay',
							header : '�������',
							dataIndex : 'ActPay',
							xtype:'numbercolumn',
							align:'right',
							editable:false,
							width : 120
						},{
							id : 'Balance1',
							header : '������Ԥ�����',
							dataIndex : 'Balance1',
							xtype:'numbercolumn',
							editable:false,
							align:'right',
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
							header : '����״̬',
							dataIndex : 'State',
							editable:false,
							width : 120
						}],
						viewConfig : {forceFit : true}
			}
);
	Add1Fun=function() {
		var records=editmainGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = editmainGrid.dateFields;
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
			for (var i = 0; i < editmainGrid.fields.length; i++) {
				var indx = editmainGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = editmainGrid.getColumnModel().getColumnById(indx)
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
			var FundBillDR = r.data['BillDR'];
			var ItemCode = r.data['ItemCode'];
			//alert(ItemCode);
			if(ItemCode==""){
			//alert("aa");
			var ItemCode = r.data['ItemName'];
			}
			var ReqPay = r.data['ReqPay'];
			var ActPay = r.data['ActPay'];
			var BudgBalance = r.data['Balance'];
			var State = r.data['State'];
			//BillDR ItemName Balance ReqPay ActPay Balance1
			//FundBillDR ItemCode ReqPay ActPay Desc BudgBalance
			var datad = FundBillDR+"|"+ItemCode+"|"+ReqPay+"|"+ActPay+"|"+BudgBalance+"|"+State;
			} else {
				Ext.Msg.show({
							title : '����',
							msg : '�뽫�����������������!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}
			
			var BillCode = applyNo.getValue();
			var YearMonth = yearmonField.getValue();
			var DeptDR = dnamefield.getValue();
			var arr = DeptDR.split("_");DeptDR=arr[0];
			var UserDR = appuName.getValue();
			var arr1 = UserDR.split("_"); UserDR=arr1[0];
			var Desc = Descfield.getValue();
			var chkflow = tmpCheckid; //checkflowField.getValue();
			var audeptdr = audnamefield.getValue();
			var arr2 = audeptdr.split("_"); audeptdr=arr2[0];
			var datam = BillCode+"|"+YearMonth+"|"+DeptDR+"|"+UserDR+"|"+Desc+"|"+chkflow+"|"+audeptdr;
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
			} else {
				recordType = "edit";
			}
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = editmainGrid.url + '?action=' + recordType + tmpstro.toString() +"&rowidm="+rowidm+"&datad="+encodeURIComponent(datad)+"&datam="+encodeURIComponent(datam)
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
						editmainGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							editmainGrid.store.load({
								params : {
									start : Ext
											.isEmpty(editmainGrid.getTopToolbar().cursor)
											? 0
											: editmainGrid.getTopToolbar().cursor,
									limit : editmainGrid.pageSize,
									BillCode:BillCode
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							editmainGrid.store.load({
								params : {
									start : Ext
											.isEmpty(editmainGrid.getTopToolbar().cursor)
											? 0
											: editmainGrid.getTopToolbar().cursor,
									limit : editmainGrid.pageSize,
									BillCode:BillCode
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
						editmainGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
	}
editmainGrid.load({params:{start:0, limit:25,BillCode:billcode}});
editmainGrid.addButton(SubButton);
//editmainGrid.btnAddHide();
editmainGrid.btnSaveHide();
editmainGrid.btnResetHide();
//editmainGrid.btnDeleteHide();
editmainGrid.btnPrintHide();

if(billstate!=='���') {
	var tbar = editmainGrid.getTopToolbar();
	var addbutton = tbar.get('herpAddId');
	var deletebutton = tbar.get('herpDeleteId');
	addbutton.disable();
	addButton.disable();
	deletebutton.disable();
	SubButton.disable();
}
// ����gird�ĵ�Ԫ���¼�
editmainGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

		var records = editmainGrid.getSelectionModel().getSelections();
		var State   = records[0].get("State");
		var tbar = editmainGrid.getTopToolbar();
		var tbutton = tbar.get('herpDeleteId');
		
		if(State!=="�½�"){
		tbutton.disable();
		}

		
});

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
				items : [queryPanel,editmainGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,editmainGrid]                                 //���Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : '������',
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