var userCode = session['LOGON.USERCODE'];
var StartDateField = new Ext.form.DateField({
		id : 'StartDateField',
		format : 'Y-m-d',
		fieldLabel:'��ʼ����',
		width : 120,
		editable:true,
		emptyText : '��ѡ��ʼ����...'
	});
	var EndDateField = new Ext.form.DateField({
		id : 'EndDateField',
		format : 'Y-m-d',
		fieldLabel:'��������',
		width : 120,
		editable:true,
		emptyText : '��ѡ���������...'
	});
	
/////////////////////��ѯ���///////////////
var queryPanel = new Ext.FormPanel({
	height : 35,
	region : 'north',
	frame : true,
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '�޸�����:',
				columnWidth : .07
				},StartDateField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '��',
				columnWidth : .013
				},{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},EndDateField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.01
				},{
				columnWidth:0.05,
				xtype:'button',
				text: '��ѯ',
				handler:function(b){SearchFun();},
				iconCls: 'find'
				}]
	}]
	
});


var itemGrid = new dhc.herp.Grid({
        //width: 400,
        //editable:true,                   //�Ƿ�ɱ༭
        //readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.unitbonusdetaileditlogexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		//loadmask:true,
        fields: [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
		{
            header: 'ID',
            dataIndex: 'RowID',
			editable:false,
            hidden: true
        },{
            id:'ModiDate',
            header: '�޸�����',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ModiDate'
        },{
           id:'ModiPerson',
            header: '�޸���',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ModiPerson'   
        },{
            id:'TableName',
            header: '���޸ĵı���',
			allowBlank: false,
			editable:false,
			width:185,
            dataIndex: 'TableName'
        },{
            id:'ItemCode',
            header: '�޸������',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ItemCode'
        },{
            id:'ItemName',
            header: '�޸�������',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ItemName'
        },{
            id:'OldValue',
            header: 'ԭֵ',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'OldValue'
        },{
            id:'NewValue',
            header: '��ֵ',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'NewValue'
        },{
            id:'ReMark',
            header: '��ʶ',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ReMark'
        }]
});
	
	
	/*
	itemGrid.hiddenButton(0);
	itemGrid.hiddenButton(1);
	itemGrid.hiddenButton(2);
    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);*/
	itemGrid.btnAddHide();     //�������Ӱ�ť
    itemGrid.btnSaveHide();    //���ر��水ť
    itemGrid.btnResetHide();   //�������ð�ť
    itemGrid.btnDeleteHide();  //����ɾ����ť
    itemGrid.btnPrintHide();   //���ش�ӡ��ť
	
/////////////////��ѯ��ť��Ӧ����//////////////
function SearchFun()
{			
	var StartDate= StartDateField.getValue()
	var EndDate=EndDateField.getValue();
	
	//alert(sYear+"   "+sPeriod+"  "+BonusScheme+"   "+BonusUnit+"  "+SchemeItem);	
	itemGrid.load({params:{start:0,limit:25,StartDate:StartDate,EndDate:EndDate}});	
}

	
	
