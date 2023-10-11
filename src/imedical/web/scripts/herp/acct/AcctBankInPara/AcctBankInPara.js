var UserId = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
var bookID = IsExistAcctBook();
var AcctBookID = bookID

//----------------- ��ƿ�Ŀ--------------//
	//������Ŀstore
	var bankStore = new Ext.data.Store({
		//autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['subjId','subjCode','subjName', 'subjCodeName'])
	});
	bankStore.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'herp.acct.AcctBankInParaexe.csp?action=GetCashSubj&AcctBookID='+AcctBookID,method:'POST'});
	});
    //������ĿComboBox
    var acctbankCombo = new Ext.form.ComboBox({
		id : 'acctbank',
		fieldLabel : '��ƿ�Ŀ',
		store: bankStore,
		emptyText:'',
		valueField : 'subjId',
		displayField : 'subjName',
		width:200,
		listWidth : 250,
		//allowBlank: false,
		//anchor: '90%',
		//value:'', //Ĭ��ֵ
		//valueNotFoundText:'',
		triggerAction: 'all',
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true',
		resizable:true
    });
	
	
 ///���п�Ŀ
//ĩ�����п�Ŀ
var bankDs = new Ext.data.Store({
			//autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",root : 'rows'
					}, ['subjId','subjCode','subjName', 'subjCodeName'])
		});
bankDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.AcctBankInParaexe.csp?action=GetCashSubj&AcctBookID='+AcctBookID,method:'POST'
					});
		});
var deptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '���п�Ŀ',
			store : bankDs,
			displayField : 'subjCodeName',
			valueField : 'subjId',
			//typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��Ŀ�ֵ���ĩ�����п�Ŀ',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});	

 ///��λ����ID
var bookIdDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid','name'])
		});
bookIdDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.AcctBankInParaexe.csp?action=GetBookID&AcctBookID='+AcctBookID,method:'POST'
					});
		});
var bookIdCombo = new Ext.form.ComboBox({
			fieldLabel : '��λ����',
			store : bookIdDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			allowBlank: false,
			selectOnFocus : true
		});		
		
//�ļ�����
var FileTypeStore = new Ext.data.SimpleStore({
			fields : ['rowid', 'method'],
			data : [['0', 'excel'], ['1', 'txt']]
		});
var FileTypeCombo = new Ext.form.ComboBox({
	        id:'FileTypeCombo',
			fieldLabel : '��ʾ��ʽ',
			width : 150,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : FileTypeStore,
			//anchor : '90%',
			value : 1, //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false	
});

//�зָ���
var SeparatorStore = new Ext.data.SimpleStore({
			fields : ['rowid', 'method'],
			data : [['0', ','], ['1', ';']]
		});
var SeparatorCombo = new Ext.form.ComboBox({
	        id:'SeparatorCombo',
			fieldLabel : '��ʾ��ʽ',
			width : 150,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : SeparatorStore,
			anchor : '90%',
			value : 1, //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false	
});

//�Ƿ���ͬ��
var IsDCTColStore = new Ext.data.SimpleStore({
			fields : ['rowid', 'method'],
			data : [['1', '��ͬ'], ['0', '����ͬ']]
		});
var IsDCTColCombo = new Ext.form.ComboBox({
	        id:'IsDCTColCombo',
			fieldLabel : '��ʾ��ʽ',
			width : 150,
			listWidth : 120,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsDCTColStore,
			anchor : '90%',
			value : 1, //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false	
});

//���ڸ�ʽ
var DateFormateStore = new Ext.data.SimpleStore({
			fields : ['rowid', 'method'],
			data : [['1', 'YYYY-MM-DD'], ['2', 'YYYYMMDD'], ['3','YYYY��MM��DD��']]
		});
var DateFormateCombo = new Ext.form.ComboBox({
	        id:'DateFormateCombo',
			fieldLabel : '��ʾ��ʽ',
			width : 150,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : DateFormateStore,
			anchor : '90%',
			value : 1, //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false	
});
//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip:'��ѯ', 
		iconCls: 'find',	       //����ť��ͼ��
		handler:function(){
	
			//��ѯ����List()��JS�ļ�
					var AcctSubj  = deptCombo.getValue();
					 itemGrid.load({
						 params:{						 
						        //start : 0,
								//limit : 25,
								AcctSubj:AcctSubj,
								AcctBookID:AcctBookID
								}});
					}
});
//���水ť
var saveButton = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'�������',
	iconCls: 'save',
	handler:function(){
		var records=itemGrid.getSelectionModel().getSelections();
		var AcctBookID = records[0].get("AcctBookID");
		var AcctSubjID = records[0].get("AcctSubjID");		
		//alert(AcctBookID)
		if(AcctBookID==""){
			Ext.Msg.show({title:'ע��',msg:'��λ���ײ���Ϊ��',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		   return;
		}
		if(AcctSubjID==""){
			Ext.Msg.show({title:'ע��',msg:'��ƿ�Ŀ����Ϊ��',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		    return;
		}
		//���ñ��溯��
		itemGrid.save();		
	}
});

var itemGrid = new dhc.herp.Grid({
		    //title: '���ж��˵�������������ά��',
		    region : 'center',
			//iconCls:'maintain',
		    url: 'herp.acct.AcctBankInParaexe.csp',
		    //atLoad : true, // �Ƿ��Զ�ˢ��
		    tbar:["���п�Ŀ",deptCombo,'-',findButton,'-',saveButton,'-'],
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'AcctBookID',
						header: '<div style="text-align:center">��λ����</div>',
						width : 150,
						type:bookIdCombo,						
						dataIndex : 'AcctBookID'
					},{
						id : 'AcctSubjID',
						header: '<div style="text-align:center">��ƿ�Ŀ</div>',						
						width : 180,
						type: acctbankCombo,
						dataIndex : 'AcctSubjID'
						
					},{
						id : 'AcctSubjCode',
						header: '<div style="text-align:center">��Ŀ����</div>',
						width : 150,
						allowBlank:false,
						dataIndex : 'AcctSubjCode'
					},{
						id : 'FileType',
						header: '<div style="text-align:center">�ļ�����</div>',
						align:'center',
						width : 80,
						hidden:true,
						type: FileTypeCombo,
						dataIndex : 'FileType'
					},{
						id : 'BeginRow',
						header: '<div style="text-align:center">���ݿ�ʼ��</div>',
						align:'center',
						width : 80,
						//type:'numberField',
						allowBlank:false,
						
						dataIndex : 'BeginRow'
					}, {
						id : 'OccurDate',
						header: '<div style="text-align:center">����������</div>',
						align:'center',
						width : 80,
						allowBlank:false,
						//align: 'right',
						dataIndex : 'OccurDate'
					}, {
						id : 'CheqTypeCol',
						header: '<div style="text-align:center">Ʊ��������</div>',
						align:'center',
						width : 80,
						allowBlank:false,
						//align: 'right',
						dataIndex : 'CheqTypeCol'
					},{
						id : 'CheqNoCol',
						header: '<div style="text-align:center">֧Ʊ����</div>',
						align:'center',
						width : 80,
						allowBlank:false,
						//align: 'right',
						dataIndex : 'CheqNoCol'
					},{
						id : 'summary',
						header: '<div style="text-align:center">ժҪ��</div>',
						width : 80,
						align: 'center',
						dataIndex : 'summary'
					},{
						id : 'AmtDebitCol',
						header: '<div style="text-align:center">�跽�����</div>',
						width : 80,
						align: 'center',
						allowBlank:false,
						dataIndex : 'AmtDebitCol'
					},{
						id : 'AmtCrediCol',
						header: '<div style="text-align:center">���������</div>',
						width : 80,
						align: 'center',
						allowBlank:false,
						dataIndex : 'AmtCrediCol'
					},{
						id : 'Separator',
						header: '<div style="text-align:center">�зָ���</div>',
						width : 80,
						align: 'center',
						hidden:true,
						type: SeparatorCombo,
						dataIndex : 'Separator'
					},{
						id : 'Position',
						header: '<div style="text-align:center">�ָ���λ��</div>',
						width : 80,
						align: 'center',
						hidden:true,
						allowBlank:true,
						dataIndex : 'Position'
					},{
						id : 'IsDCTCol',
						header: '<div style="text-align:center">�Ƿ���ͬ��</div>',
						width : 90,
						align: 'center',
						allowBlank:false,
						type: IsDCTColCombo,
						dataIndex : 'IsDCTCol'
					},{
						id : 'DateFormate',
						header: '<div style="text-align:center">���ڸ�ʽ</div>',
						width : 120,
						align: 'center',
						type: DateFormateCombo,
						dataIndex : 'DateFormate'
					}]					
		});
	itemGrid.load({params:{start:0, limit:12,AcctBookID:AcctBookID}});
	
itemGrid.on('afteredit',function(afterEdit, e){		
	var records=itemGrid.getSelectionModel().getSelections();
	var AcctSubjID = records[0].get("AcctSubjID");
	
	Ext.Ajax.request({
		url:'herp.acct.AcctBankInParaexe.csp?action=GetSubjCode&AcctSubjID='+AcctSubjID,method:'POST',
		failure: function (result, request) {
			Ext.Msg.show({
				title: '����',
				msg: '������������!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			//if (jsonData.success == 'true') {
				records[0].set("AcctSubjCode",jsonData.info);
			//}
		},
		scope: this
	});	 
});
/* 
 	itemGrid.btnAddHide()     //�������Ӱ�ť 
    itemGrid.btnDeleteHide()  //����ɾ����ť */
	itemGrid.btnSaveHide()    //���ر��水ť
    itemGrid.btnResetHide()     //�������ð�ť
    itemGrid.btnPrintHide()     //���ش�ӡ��ť
