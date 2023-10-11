var itemGridUrl = '../csp/herp.srm.approvstreamdefinmain.csp';

var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '是否'
});

var itemGrid = new dhc.herp.Grid({
            title:'审批流定义',
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
				header : '审批流编码',
				width : 150,
				editable:true,
				hidden:false,
				dataIndex : 'code'
			},{
				id : 'name',
				header : '审批流名称',
				width : 200,
				editable:true,
				hidden:false,
				dataIndex : 'name'
			},{
               id:'IsValid',
               header: '是否有效',
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

  /* itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮 */
   
    /* itemGrid.btnResetHide();   //隐藏重置按钮
    itemGrid.btnPrintHide();   //隐藏打印按钮
	
	itemGrid.hiddenButton(4);
    itemGrid.hiddenButton(5); */
	
itemGrid.load({params:{start:0,limit:25}});      
	
itemGrid.on('rowclick',function(grid,rowIndex,columnIndex,e){
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].get("rowid");	
	detailGrid.load({params:{start:0,limit:12,checkmainid:rowid}});	
});


