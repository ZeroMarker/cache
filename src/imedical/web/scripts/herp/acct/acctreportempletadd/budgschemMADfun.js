
MADFun = function(sName,SchemDR, MAitemGrid,schName){

	var MADtitle = '��ǰԤ�������� ��'+schName ;

///////////////////////�������///////////////////////////
var deptTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	    deptTypeDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschemmadexe.csp?action=deptTypeist',method:'POST'});
		
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
		listWidth : 110,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

/////////////////��/////////////////////////////////
var YearDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	YearDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschemmadexe.csp?action=Yaerlist',method:'POST'});		
	});
		
	var YearCombo = new Ext.form.ComboBox({
		fieldLabel:'���',
		store: YearDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'ѡ��...',
		width: 100,
		listWidth : 100,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

/////////////////////��������/////////////////////////////
var DeptNamefield = new Ext.form.TextField({
		id: 'DeptNamefield',
		fieldLabel: '��������',
		allowBlank: true,
		emptyText:'����д...',
		width:100,
	    listWidth : 100
	});



		

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){
       
        var year=YearCombo.getValue();   
        
        //alert(year);
		var dtype=deptTypeCombo.getValue();
		var dname=DeptNamefield.getValue();
		MADitemGrid.load({params:{start:0, limit:25,sName:sName,year:year,dtype:dtype,dname:dname}});
	}
});	


// ���ڱ�����ϸ����grid
var MADitemGrid = new dhc.herp.Grid({
				title : MADtitle,
				width : 400,
				region : 'center',
				url : 'herp.budg.budgschemmadexe.csp',
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // �����������õ�Ԫ�����༭�Ƿ���� 
		                  //alert(columnIndex);
		                  //alert(record.get('rowid'));
		                    if ((record.get('rowid') =="")&& ((columnIndex == 9)||(columnIndex == 10))) {
		                         return false;
		                     } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// Ԥ����Ŀ��ʽ�༭
						if ((record.get('rowid') =="") && ((columnIndex == 9)||(columnIndex == 10))) {						
							return false;
						} else {
							return true;
						}
					}},
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'DeptDR',
							header : '����dr',
							dataIndex : 'DeptDR',
							update : true,
							width : 50,
							//align : 'center',
							editable:false,
							hidden : true

						},{
							id : 'ItemCode',
							header : 'Ԥ�������',
							dataIndex : 'ItemCode',
							update : true,
							width : 70,
							//align : 'center',
							editable:false,
							hidden : true

						},{
							id : 'Year',
							header : '���',
							dataIndex : 'Year',
							update : true,
							width : 40,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'DName',
							header : '��������',
							dataIndex : 'DName',
							width : 80,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'Class',
							header : '����������',
							dataIndex : 'Class',
							width : 50,
							//align : 'center',
							editable:false,
							hidden : true

						},{
							id : 'TName',
							header : '�������',
							dataIndex : 'TName',
							width : 80,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'SName',
							header : 'Ԥ��������',
							dataIndex : 'SName',
							width : 50,
							//align : 'center',
							editable:false,
							hidden : true
						},{
							id : 'CalcValue',
							header : 'ȫԺ�´�',
							width : 120,
							editable:true,
							align : 'right',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							  	cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							  	return '<span style="color:blue;cursor:hand;backgroundColor:blue">'+value+'</span>';
							},
							dataIndex : 'CalcValue'

						},{
							id : 'PlanValue',
							header : '����Ԥ��',
							//update : true,
							dataIndex : 'PlanValue',
							width : 120,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:blue;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							align : 'right',
							editable:true,
							hidden : false

						},{
							id : 'disSm',
							header : '���',
							dataIndex : 'disSm',
							width : 120,
							align : 'right',
							editable:false,
							hidden : false

						},{
							id : 'ratioSm',
							header : '������(%)',
							dataIndex : 'ratioSm',
							width : 100,
							align : 'right',
							editable:false,
							hidden : false

						},{
							id : 'RealValueLast',
							header : '����ִ��',
							dataIndex : 'RealValueLast',
							width : 120,
							align : 'right',
							editable:false,
							hidden : false

						},{
							id : 'disSmNL',
							header : '���',
							dataIndex : 'disSmNL',
							width : 120,
							align : 'right',
							editable:false,
							hidden : false
							
						},{
							id : 'ratioSmNL',
							header : '������(%)',
							dataIndex : 'ratioSmNL',
							width : 100,
							align : 'right',
							editable:false,
							hidden : false
							
						},{
							id : 'EditMeth',
							header : '���Ʒ���',
							dataIndex : 'EditMeth',
							width : 80,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'EditMod',
							header : '����ģʽ',
							dataIndex : 'EditMod',
							width : 80,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'ChkDesc',
							header : '������',
							dataIndex : 'ChkDesc',
							width : 60,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'PlanValueModiMid',
							header : '�޸��м���',
							dataIndex : 'PlanValueModiMid',
							update : true,
							width : 50,
							//align : 'center',
							editable:false,
							hidden : true

						},{
							id : 'PlanValueModi',
							header : '�ϴ��޸�',
							dataIndex : 'PlanValueModi',
							update : true,
							width : 50,
							//align : 'center',
							editable:false,
							hidden : true

						}],
				tbar:['���:',YearCombo,'-','���ҷ���:',deptTypeCombo,'-','��������:',DeptNamefield,'-',findButton]

			});
	

	    MADitemGrid.btnAddHide();  //�������Ӱ�ť
	    //MADitemGrid.btnSaveHide()  //���ر��水ť
	    MADitemGrid.btnResetHide(); //�������ð�ť
	    MADitemGrid.btnDeleteHide(); //����ɾ����ť
	    MADitemGrid.btnPrintHide(); //���ش�ӡ��ť

    
	MADitemGrid.load({params:{start:0,limit:15,sName:sName,SchemDR:SchemDR}});
	
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){ 
	  MAitemGrid.load({params:{start:0,limit:15,SchemDR:SchemDR}});
	  window.close();
	};

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [MADitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '�������Ԥ��ά��',
				plain : true,
				width : 1200,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};