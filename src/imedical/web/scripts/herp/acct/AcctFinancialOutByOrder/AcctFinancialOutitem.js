
//var acctbookid=GetAcctBookID();
  //��ȡ��Ļ�ֱ���
var screenHeight=Ext.getBody().getHeight();
//alert(screenHeight);
var gridHeight=screenHeight-71-20
//(2*gridHeight)/5,
   var itemGridf = new dhc.herp.Gridff({
    title: '������ϸ��',
	iconCls:'list',
	region: 'south',
    layout:"fit",
    split : true,
    collapsible : true,
    xtype : 'grid',
    trackMouseOver : true,
    stripeRows : true,
    loadMask : true,
    height : (3*gridHeight)/5,
    trackMouseOver: true,
    stripeRows: true,
	//style:'text-align:center;',
	//viewConfig:{forceFit:true},
    //atLoad : true, // �Ƿ��Զ�ˢ��
    url: 'herp.acct.acctfinancialoutdetailByOrderexe.csp',
    fields: [
                   {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, 
					{
						id : 'AcceptDepCode',
						header : '<div style="text-align:center">���տ��ұ���</div>',
						dataIndex : 'AcceptDepCode',
						width :150,
						editable:false,
						hidden : true

					},{
						id : 'AcceptDep',
						header : '<div style="text-align:center">���տ���</div>',
						width : 280,
						editable:false,
						align : 'left',
						hidden : false,
						dataIndex : 'AcceptDep'

				},
					/*
					{
						id : 'EquipName',
						header : '<div style="text-align:center">�豸����</div>',
						dataIndex : 'EquipName',
						width :150,
						//editable:true,
						hidden : false

					}, */
					{
						id : 'EquipTypeDR',
						header : '<div style="text-align:center">�����������</div>',
						dataIndex : 'EquipTypeDR',
						width : 180,
						editable:false,
						
						//allowBlank:true,
						hidden : false

					},
					{
						id : 'EquipType',
						header : '<div style="text-align:center">������������</div>',
						dataIndex : 'EquipType',
						width : 180,
						editable:false,
						//allowBlank:true,
						renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},
						hidden : false

					}, /*{
						id : 'StatCat',
						header : '<div style="text-align:center">�豸����</div>',
						width : 150,
						//editable:true,
						//allowBlank : true,
						dataIndex : 'StatCat'

				}, */
				 {
						id : 'Amount',
						header : '<div style="text-align:center">�����</div>',
						width : 150,
						editable:false,
						hidden : false,
						align : 'right',
						
						dataIndex : 'Amount'
					}  ]
    
				
					
});
/*
 itemGridf.on('cellclick',function(g, rowIndex, columnIndex, e){
	if(columnIndex=='5'){
		 var mainSelect=itemGrid.getSelectionModel().getSelections(); 
		 var detailScore=itemGridf.getSelectionModel().getSelections(); 
		 
		 var mainid=mainSelect[0].get("rowid");
		 var typeID=detailScore[0].get("EquipTypeDR");
		 var code=detailScore[0].get("Code");
		 var name=detailScore[0].get("Loc");
		 code=code+"-"+name;
	     window.open("herp.acct.acctfinancialstoragedetail.csp?mainid="+mainid+"&typeID="+typeID+"&code="+code);  
		 
	}
 });*/