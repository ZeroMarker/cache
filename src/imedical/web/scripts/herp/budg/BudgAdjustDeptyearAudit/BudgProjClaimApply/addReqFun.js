AddReqFun = function(applyCombo){

/////////////////////���뵥��/////////////////////////////
var ReqNofield = new Ext.form.TextField({
		id: 'ReqNofield',
		fieldLabel: '���뵥��',
		allowBlank: true,
		emptyText:'����д...',
		width:100,
	    listWidth : 100
	});
///////////////�������////////////////////////
var dnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
			totalProperty : "results",root : 'rows'}, ['rowid', 'name'])});
dnameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
			url : 'herp.budg.budgschemaselfexe.csp?action=deptNList',method : 'POST'});
		});

var dnamefield = new Ext.form.ComboBox({
			fieldLabel : '�������',
			store : dnameDs,
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
////////////Ԥ����//////////////////////
var timeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['yearmonth', 'yearmonth'])
		});

timeDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({url :'herp.budg.expenseaccountdetailexe.csp?action=timelist' ,method : 'POST'});});

var timeCombo = new Ext.form.ComboBox({
			fieldLabel : 'Ԥ����',
			store : timeDs,
			displayField : 'yearmonth',
			valueField : 'yearmonth',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ��...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
///////////////������////////////////////////
var appuDs = new Ext.data.Store({
	proxy : "",reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
});

appuDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : 'herp.budg.expenseaccountdetailexe.csp?action=userlist',method : 'POST'});
});

var appuName = new Ext.form.ComboBox({
			fieldLabel : '������',
			store : appuDs,
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
//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){
		var billcode=ReqNofield.getValue();
		var deptdr=dnamefield.getValue();
		var yearmonth=timeCombo.getValue();
		var applyer=appuName.getValue(); 
		//billcode deptdr yearmonth applyer   dnamefield timeCombo appuName
		AddReqGrid.load(({params:{start:0,limit:25,billcode:billcode,deptdr:deptdr,yearmonth:yearmonth,applyer:applyer}}));
	}
});		

//ȷ�ϰ�ť
var addButton = new Ext.Toolbar.Button({
	text: 'ȷ��',
    tooltip:'ȷ��',        
    iconCls:'add'});


	// ��������grid
var AddReqGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgprojclaimapplydetailreqexe.csp',
				atLoad:true,
				fields : [
				//new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'BillCode',
							header : '���뵥��',
							dataIndex : 'BillCode',
							width : 120,
							editable:false
						},{
							id : 'YearMonth',
							header : 'Ԥ���ڼ�',
							dataIndex : 'YearMonth',
							width : 100,
							editable:false
						},{
							id : 'DeptDR',
							header : '�������',
							dataIndex : 'DeptDR',
							width : 120,
							hidden:true

						}, {
							id : 'UserDR',
							header : '������',
							dataIndex : 'UserDR',
							width : 120,
							editable:false
						},{
							id : 'ReqPay',
							header : '������',
							dataIndex : 'ReqPay',
							width : 200,
							editable:false
						}, {
							id : 'Desc',
							header : '����˵��',
							dataIndex : 'Desc',
							width : 80,
							editable:false
						}],
				tbar:['���뵥��:',ReqNofield,'-','�������:',dnamefield,'-','�ڼ�:',timeCombo,'-','������:',appuName,'-',findButton]
			});
	
//������Ӱ�ť��Ӧ����
addHandler = function(){
        var rowObj=AddReqGrid.getSelectionModel().getSelections();
	    var len = rowObj.length;
	    if(len < 1){
		    Ext.Msg.show({title:'ע��',msg:'��ѡ��һ����¼��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
	    var str="";
	    for(var i = 0; i < len; i++){
	    	var rowid = rowObj[i].get("rowid");
	    	var billcode = rowObj[i].get("BillCode");
			str=rowid+"_"+billcode;
			applyCombo.setValue(str);
			}	 
		  window.close();
		  
		};
	
	addButton.addListener('click',addHandler,false);
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function() { window.close(); };

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [AddReqGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '���뵥ѡ��',
				plain : true,
				width : 900,
				height : 450,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [addButton,cancelButton]

			});
			
	window.show();
    AddReqGrid.btnAddHide();  //�������Ӱ�ť
    AddReqGrid.btnSaveHide();  //���ر��水ť
    AddReqGrid.btnResetHide();  //�������ð�ť
    AddReqGrid.btnDeleteHide(); //����ɾ����ť
    AddReqGrid.btnPrintHide();  //���ش�ӡ��ť
};