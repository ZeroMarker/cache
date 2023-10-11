var UserID = session['LOGON.USERID'];
var AcctBookID=IsExistAcctBook();
/*
var TempNoField= new Ext.form.TextField({
		//id:'addTempNoField',
        fieldLabel: 'ģ�����',
       // width:180, 
		allowBlank:false,
		maxLength:50,
		minLength:6,
		emptyText:'������ģ�����',
        selectOnFocus:'true'
    });
*/

//---------ȡƾ֤����--------//
 var VouchTypeDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:"results"
		},['rowid','name'])
});
	VouchTypeDs.on('beforeload',function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
				url:'herp.acct.vouchtempvinexe.csp?action=VouchTypeList',
				method :'POST'
		});
	});
var VouchTypeField = new Ext.form.ComboBox({
		fieldLabel: 'ƾ֤���',
		store: VouchTypeDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		emptyText : '',
		width : 120,
		listWidth : 230,
		pageSize : 10,
		minChars : 1
}); 
//----------�Ƿ�˽��-----------
var IsShelfStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','��'],['1','��']]
});

var IsShelfField=new Ext.form.ComboBox({
		id: 'IsShelfField',
		name: 'IsShelfField',
		fieldLabel: '�Ƿ�˽��',
		store: IsShelfStore,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: true,
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		mode: 'local', // ����ģʽ
		emptyText:'��ѡ��...',
		minChars: 15,
		pageSize: 10,
		forceSelection:true,
		editable:true
});	

var buttons=new Ext.Toolbar(['˵���������999��ͷ��Ϊ��֧��תƾ֤ģ�壻��998��ͷ��Ϊ��ĩ����ģ�塣']);	

var itemMain = new dhc.herp.Grid({
		title: 'ģ������ά��',
		iconCls:'maintain',
		region : 'west',
		reload:true,
		// height:250,
		width: 480,
		url: 'herp.acct.vouchtempvinexe.csp',
		split : true,
		// collapsible : true,	//��������
		containerScroll :true,
		xtype : 'grid',
		trackMouseOver : true,
		stripeRows : true,//������
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		loadMask : true,
		listeners:{
			'render':function(){
				buttons.render(itemMain.tbar);
				}
		},

		fields: [
			 //new Ext.grid.CheckboxSelectionModel({editable:false}), 
		{
			id:'rowid',
			header:'AcctTempletID',
			width:100,
			editable:false,
			dataIndex: 'rowid',
			hidden: true
		},{ 
			id:'TempNo',
			header: '<div style="text-align:center">ģ�����</div>',
			dataIndex: 'TempNo',
			width:100,
			//type:TempNoField,
			allowBlank: false,
			editable:true
		}, {
			id:'TempName',
			header: '<div style="text-align:center">ģ������</div>',
			width:180,
			editable:true,
			allowBlank:false,
			dataIndex: 'TempName'
			
		}, {
			id:'VouchType',
			header: '<div style="text-align:center">ƾ֤����</div>',
			width:70,
			dataIndex: 'VouchType',
			allowBlank: false,
			align: 'center',
			type:VouchTypeField,
			editable:true
			
		},{
			id:'IsShelf',
			header: '<div style="text-align:center">�Ƿ�˽��</div>',
			width:65,
			dataIndex: 'IsShelf',
			allowBlank: true,
			align: 'center',
			type:IsShelfField,
			editable:true
			
		},{
			id:'Tempdesc',
			header: '<div style="text-align:center">ģ��˵��</div>',
			width:120,
			dataIndex: 'Tempdesc',
			allowBlank: true,
			editable:true,
             hidden:true			
			
		},{
			id:'UserID',
			header: '<div style="text-align:center">������ID</div>',
			width:100,
			hidden:true,
			dataIndex: 'UserID',
			allowBlank: true,
			editable:true	
			
		},{
			id:'UserName',
			header: '<div style="text-align:center">������</div>',
			width:100,
			hidden:true,
			dataIndex: 'UserName',
			allowBlank: true,
			editable:true	
			
		}]
	


});

	// itemMain.btnAddHide();    //�������Ӱ�ť
	// itemMain.btnSaveHide();   //���ر��水ť
	// itemMain.btnDeleteHide(); //����ɾ����ť
	// itemMain.btnResetHide();  //�������ð�ť
	// itemMain.btnPrintHide();  //���ش�ӡ��ť
	// itemMain.hiddenButton(1);//���صڼ�����ť
	
	
itemMain.load({
	params:{
		start:0, 
		limit:25,
		UserID:UserID,
		AcctBookID:AcctBookID
	}
});

// �б༭
 itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	var selectedRow = itemMain.getSelectionModel().getSelections();
	var acctempID = selectedRow[0].data['rowid'];
	var templetNO=selectedRow[0].data['TempNo'];
	//��99��ͷ��ģ�岻�ܱ༭��ɾ��
	var title=templetNO.substr(0,2);
	if(title!='99'){
		document.getElementById("herpDeleteId").getElementsByTagName('button')[0].hidden=false;
		return true;
	}else{
		document.getElementById("herpDeleteId").getElementsByTagName('button')[0].hidden=true;
		return false;	//���ɱ༭
		
	}
 });
 
// ��ϸ��ѯ 
itemMain.on('rowclick', function () {


	var selectedRow = itemMain.getSelectionModel().getSelections();
	var acctempID = selectedRow[0].get('rowid');
	var templetNO = selectedRow[0].get('TempNo');
    //alert(templetNO);


	var title = templetNO.substr(0, 3);
	var selfTemp=templetNO.substr(0, 2);
	if (title != '999') {
		itemDetail.getColumnModel().setColumnHeader(6, "<div style=text-align:center>�Է���Ŀ</div>");

	} else {
		itemDetail.getColumnModel().setColumnHeader(6, "<div style=text-align:center>��ת��Ŀ</div>");

	}
	//���ط��򡢻�����ϸ���Է���Ŀ��
	if(selfTemp!=="99"){
		itemDetail.getColumnModel().setHidden(4,true)
		itemDetail.getColumnModel().setHidden(5,true)
		itemDetail.getColumnModel().setHidden(6,true)
	}else{
		itemDetail.getColumnModel().setHidden(4,false)
		itemDetail.getColumnModel().setHidden(5,false)
		itemDetail.getColumnModel().setHidden(6,false)
	}
	
	itemDetail.load({
		params: {
			start: 0,
			limit: 25,
			acctempID: acctempID,
			AcctBookID:AcctBookID
		}
	});

})
