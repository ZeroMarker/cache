
var BudgProAdditionalDetailUrl = '../csp/herp.budg.budgproadditionaldetailexe.csp';

var userid = session['LOGON.USERID'];
var uname = session['LOGON.USERNAME'];



var saveButton = new Ext.Toolbar.Button({
	text: '����',
    tooltip:'����',        
    iconCls:'option',
	handler:function(){
		AddFun1();
		//itemMain.store.on("load",function(){  
        //itemMain.getSelectionModel().selectRow(2,true);  
    	//});
    	//itemGrid.load({params:{start:0, limit:25,userid:userid}})
			}
});

  
var itemDetail = new dhc.herp.Gridlyf({
    title: '����ģ����ϸ��Ϣ',
	iconCls:'list',
    region : 'south',
    url: 'herp.acct.reportempletitemexe.csp',
    fields: [
       //new Ext.grid.CheckboxSelectionModel({editable:false}),
                   {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'RepItemCode1',
						header : '<div style="text-align:center">���������</div>',
						dataIndex : 'RepItemCode1',
						width : 80,
						allowBlank:false,
						editable:true,
						hidden : false

					}, {
						id : 'RepItemName1',
						header : '<div style="text-align:center">����������</div>',
						dataIndex : 'RepItemName1',
						width : 120,
						editable:true,
						allowBlank:true,
						hidden : false

					}, {
						id : 'Formula1',
						header : '<div style="text-align:center">���㹫ʽ</div>',
						width : 300,
						editable:true,
						allowBlank : true,
						dataIndex : 'Formula1'

				}, {
						id : 'Sequence1',
						header : '<div style="text-align:center">������</div>',
						width : 50,
						editable:true,
						align : 'center',
						allowBlank:false,
						hidden : false,
						dataIndex : 'Sequence1'

				}, {
						id : 'RepItemCode2',
						header : '<div style="text-align:center">���������</div>',
						width : 120,
						editable:true,
						hidden : false,
						allowBlank:false,
						dataIndex : 'RepItemCode2'

					}, {
						id : 'RepItemName2',
						header : '<div style="text-align:center">����������</div>',
						width : 140,
						editable:true,
						allowBlank:true,
					/*  overrender: true,
					    renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['t2d']
						if (sf != "") {
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}}, */
						dataIndex : 'RepItemName2'

					}, {
						id : 'Formula2',
						header : '<div style="text-align:center">���㹫ʽ</div>',
						width : 300,
						editable : true,
						allowBlank:true,
						dataIndex : 'Formula2'
						
					},{
						id : 'Sequence2',
						header : '<div style="text-align:center">������</div>',
						width : 50,
						editable:true,
						align : 'center',
						allowBlank:false,
						dataIndex : 'Sequence2'

					},{
						id : 'RowNumber',
						header : '',
						width : 50,
						editable:false,
						align : 'right',
						hidden : true,
						dataIndex : 'RowNumber'

					}],
    
					xtype : 'grid',				
					height : 335
					
});

itemDetail.on("beforeedit",function(editor, selectedRow, selectedRow){
	var rowObj = itemMain.getSelectionModel().getSelections();
	var CheckState=rowObj[0].data['CheckState'];
	if(CheckState=="���"){
		return false;
	}else{
		return true;
	}
	
});