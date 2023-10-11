var itemGridUrl = '../csp/herp.srm.approvstreamdefinmain.csp';

var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '�Ƿ�'
});

var itemGrid = new dhc.herp.Grid({
            title:'����������',
            iconCls: 'list',
			region : 'center',
			url : itemGridUrl,	
			//atLoad:true,        
			fields : [
			//new Ext.grid.CheckboxSelectionModel({hidden : true,editable:false}),
			{
				header : 'ID',
				dataIndex : 'rowid',
				hidden : true
			},{
				id : 'code',
				header : '����������',
				width : 150,
				editable:true,
				hidden:false,
				dataIndex : 'code'
			},{
				id : 'name',
				header : '����������',
				width : 200,
				editable:true,
				hidden:false,
				dataIndex : 'name'
			},{
               id:'IsValid',
               header: '�Ƿ���Ч',
			   //allowBlank: false,
			   editable:true,
			   width:80,
               dataIndex: 'IsValid',
               type : IsdriectField,
               renderer : function(v, p, record){
        	   //p.css += ' x-grid3-check-col-td'; 
        	   return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}

        }]
})

  /* itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť */
   
    /* itemGrid.btnResetHide();   //�������ð�ť
    itemGrid.btnPrintHide();   //���ش�ӡ��ť
	
	itemGrid.hiddenButton(4);
    itemGrid.hiddenButton(5); */
	
itemGrid.load({params:{start:0,limit:25}});      
	
itemGrid.on('rowclick',function(grid,rowIndex,columnIndex,e){
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].get("rowid");	
	detailGrid.load({params:{start:0,limit:12,checkmainid:rowid}});	
});


