
BudgDetailFun = function(SpltMainDR1,SplitLayer){

	var cschemeName = '��ǰ��Ӧ���ң�' ;


///////////////////////�������///////////////////////////
var deptTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	deptTypeDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschsplitaccdeptdetailexe.csp?action=deptTypeist',method:'POST'});
		
	});
		
	var deptTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'�������',
		store: deptTypeDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'ѡ��...',
		width: 110,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

/////////////////////���ұ���/////////////////////////////
var DeptCodefield = new Ext.form.TextField({
		id: 'DeptCodefield',
		fieldLabel: '���ұ���',
		allowBlank: true,
		emptyText:'����д...',
		width:100,
	    listWidth : 100
	});

/////////////////////��������/////////////////////////////
var DeptNamefield = new Ext.form.TextField({
		id: 'DeptNamefield',
		fieldLabel: '���ұ���',
		allowBlank: true,
		emptyText:'����д...',
		width:100,
	    listWidth : 100
	});


		
/////////////////////////�Ƿ��������////////////////////////////			
var isAlCompStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['0', '��']]
		});
var isAlCompbox = new Ext.form.ComboBox({
			id : 'isAlCompbox',
			fieldLabel : '�Ƿ��������',
			width : 200,
			//listWidth : 200,
			selectOnFocus : true,
			allowBlank : false,
			store : isAlCompStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});		
		

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){
//rowid, DeptType, DeptCode, DeptName,

		var DeptType=deptTypeCombo.getValue();
		var DeptCode=DeptCodefield.getValue();
		var DeptName=DeptNamefield.getValue();

		budgDetailGrid.load(({params:{start:0, limit:25,SpltMainDR1:SpltMainDR1,DeptType:DeptType,DeptCode:DeptCode,DeptName:DeptName}}));
	}
});		

///////////////////////�����޸�/////////////////////////
//�������÷ֽⷽ����ť
var editRateButton = new Ext.Toolbar.Button({
	text: '�����޸�',
	tooltip: '��ѡ�еĿ���������ͬ�ı���',
	iconCls: 'add',
	handler: function(){
	
	/*var rowObj=budgDetailGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���޸ĵĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var rowid = rowObj[0].get("rowid");
		var isAlComp=rowObj[0].get("isAlComp");
		
	}*/	
		//EditRateFun(rowid,isAlComp,len,budgDetailGrid);
		EditRateFun(budgDetailGrid);
		}
});


///////////////////////�������/////////////////////////
//�������÷ֽⷽ����ť
var addDeptButton = new Ext.Toolbar.Button({
	text: '�������',
	tooltip: 'ѡ��������',
	iconCls: 'add',
	handler: function(){
		addDeptFun(SpltMainDR1,budgDetailGrid);
		}
});

var bssdrateField = new Ext.form.NumberField({
		id: 'bssdrateField',
		width:215,
		listWidth : 215,
		name: 'bssdrateField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});


	// ���ڱ�����ϸ����grid
var budgDetailGrid = new dhc.herp.Grid({
				title : cschemeName,
				width : 400,
				region : 'center',
				url : 'herp.budg.budgschsplitaccdeptdetailexe.csp',
				fields : [
				new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'code',
							header : '�������',
							dataIndex : 'code',
							width : 230,
							align : 'center',
							editable:false,
							hidden : true

						}, {
							id : 'dname',
							header : '��������',
							dataIndex : 'dname',
							width : 230,
							align : 'left',
							editable:false,
							hidden : false

						},{
							id : 'SpltMainDR',
							header : '����id',
							dataIndex : 'SpltMainDR',
							width : 230,
							align : 'center',
							editable:false,
							hidden : true

						},
						 {
							id : 'isAlComp',
							header : '�Ƿ��������',
							dataIndex : 'isAlComp',
							width : 230,
							align : 'left',
							editable:true,
							type : isAlCompbox,
							hidden : false

						}, {
							id : 'rate',
							header : '���ڱ���',
							dataIndex : 'rate',
							width : 230,
							align : 'right',
							editable:true,
							hidden : false,
							type:bssdrateField

						}],
				tbar:['�������:',deptTypeCombo,'-','���ұ���:',DeptCodefield,'-','��������:',DeptNamefield,'-',findButton,'-',editRateButton,'-',addDeptButton]

			});
			
	
	
	budgDetailGrid.btnAddHide();  //�������Ӱ�ť
    //budgDetailGrid.btnSaveHide();  //���ر��水ť
    budgDetailGrid.btnResetHide();  //�������ð�ť
    budgDetailGrid.btnDeleteHide(); //����ɾ����ť
    budgDetailGrid.btnPrintHide();  //���ش�ӡ��ť
	//budgDetailGrid.hiddenButton(15);
    
	budgDetailGrid.load({params:{start:0,limit:15,SpltMainDR:SpltMainDR1}});
	
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
				items : [budgDetailGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '�ֽ�ϵ��ά������',
				plain : true,
				width : 800,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}