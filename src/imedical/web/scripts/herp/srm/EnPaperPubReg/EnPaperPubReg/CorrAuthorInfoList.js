
 CorrAuthorInfoList = function(title,corrauthorinfo){

var corrauthorinfotitle=title+'--通讯作者排名信息';
	var CorrAuthorInfoGrid = new dhc.herp.CorrAuthorGrid({
				//title : "通讯作者排名信息",
				width : 400,
				region : 'center',                          
        url : 'herp.srm.SRMEnPaperPubRegexe.csp',
				fields : [
              //new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'rowid',
							header : 'rowid',
							dataIndex : 'rowid',
							width : 60,
							hidden:true,
							align : 'center',
							editable:false
						}, {
							id : 'name',
							header : '作者名称',
							dataIndex : 'name',
							width : 120,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'range',
							header : '作者位次',
							dataIndex : 'range',
							width : 120,
              editable:false,
							align : 'center',
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   if (value=='第二'){
						   var value='并列';
						   };       
						  return '<span >'+value+'</span>';}
							
						}, {
							id : 'isthehos',
							header : '是否本院',
							dataIndex : 'isthehos',
							width : 120,
              editable:false,
							align : 'center'
						}]    
			});
		CorrAuthorInfoGrid.btnAddHide();  //隐藏增加按钮
   	CorrAuthorInfoGrid.btnSaveHide();  //隐藏保存按钮
    CorrAuthorInfoGrid.btnResetHide();  //隐藏重置按钮
    CorrAuthorInfoGrid.btnDeleteHide(); //隐藏删除按钮
    CorrAuthorInfoGrid.btnPrintHide();  //隐藏打印按钮
    
	CorrAuthorInfoGrid.load({params:{start:0,limit:15,IDs:corrauthorinfo}})
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
				text : '关闭'
			});

	// 定义取消按钮的响应函数
	cancelHandler = function() {
		window.close();
	}

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [CorrAuthorInfoGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : corrauthorinfotitle,
				plain : true,
				width : 500,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}