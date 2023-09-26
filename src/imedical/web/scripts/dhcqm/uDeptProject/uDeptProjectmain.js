var itemGridUrl = '../csp/dhc.qm.uDeptProjectexe.csp';
//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'Rowid',
			'QMSchemCode',
			'QMSchemname',
			'QMSchemArcitem'
			
		]),
	    remoteSort: true
});

//��Ӹ�ѡ��
//var sm = new Ext.grid.CheckboxSelectionModel();
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('Rowid', 'QMSchemname');






var tmpTitle='������Ŀ����';

//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
   
        new Ext.grid.RowNumberer(), 
        {

            id:'Rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Rowid',
            hidden:'true'
           
       }, {
            id:'QMSchemCode',
            header: '��Ŀ����',
            
            allowBlank: false,
            width:100,
           editable:false,
           
            dataIndex: 'QMSchemCode'
            
       }, {
            id:'QMSchemname',
            header: '��Ŀ����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'QMSchemname'
            
       }, {
            id:'QMSchemArcitem',
            header: '����ҽ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'QMSchemArcitem'
          
       }
			    
]);



var itemGrid = new Ext.grid.GridPanel({
			//title: '��Ч��λ��¼',
	        region: 'west',
            width: 400,
	        minSize: 350,
	        maxSize: 450,
	        split: true,
	        collapsible: true,
	        containerScroll: true,
	        xtype: 'grid',
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			viewConfig: {forceFit:true},
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});

itemGrid.on('rowclick',function(grid,rowIndex,e){
	//������Ч��Ԫ��ˢ�ڲ���Ա��¼
	
	if (rowIndex !=='0')
	{ 
	var selectedRow = itemGridDs.data.items[rowIndex];
   
    RowId = selectedRow.data["Rowid"];
  
	personDs.proxy = new Ext.data.HttpProxy({url:personUrl+'?action=list2&Code='+RowId});
	personDs.load({params:{start:0, limit:personPagingToolbar.pageSize}});}
});   

itemGridDs.on("beforeload",function(ds){
	personDs.removeAll();
	RowId = "";

});
	


