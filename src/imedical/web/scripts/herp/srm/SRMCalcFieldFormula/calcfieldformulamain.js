var CalcFieldFormulaURL='herp.srm.calcfieldformulaexe.csp';
var FieldCoefficientUrl='herp.srm.fieldcoefficientexe.csp';
var formu="";
var addButton = new Ext.Toolbar.Button({
					text : '新增',
					iconCls: 'edit_add',
					handler : function() {
						AddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					//tooltip : '修改',
					iconCls : 'pencil',
					handler : function() {
						EditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			//tooltip : '删除',
			iconCls : 'edit_remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					tmpRowid = rowObj[0].get("rowid");
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : CalcFieldFormulaURL + '?action=del&rowid=' + tmpRowid,
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										itemGrid.load({
													params : {
														start : 0,
														limit : 25
													}
												});
									} else {
										Ext.Msg.show({
													title : '错误',
													msg : '错误',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					})
				}
			}
});
//复制按钮
var CopyButton = new Ext.Toolbar.Button({
	text: '复制',
    tooltip:'复制上年数据到本年度',       
    id:'CopyButton', 
    iconCls:'copy',
	handler:function(){
		function handler(id){
			if(id=="yes"){
					Ext.Ajax.request({
						url:CalcFieldFormulaURL+'?action=copy',
						waitMsg:'复制中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'复制成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25}});
							}else{
							    var err=jsonData.info;
								Ext.Msg.show({title:'错误',msg:err,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{return;}
		}
		Ext.MessageBox.confirm('提示','确实要复制上年数据到本年度吗?',handler);
	}
});
var itemGrid = new dhc.herp.Grid({
        title: '科研绩效公式列表',
		iconCls: 'list',
        width: 400,
		edit:false,
        readerModel:'remote',
        region: 'center',
        url: CalcFieldFormulaURL,	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'Year',
            header: '年度',
			allowBlank: false,
			width:80,
			edit:false,
            dataIndex: 'Year'
        },{
            id:'SysNO',
            header: '系统模块',
			allowBlank: false,
			width:150,
			edit:false,
            dataIndex: 'SysNO'
        },{
            id:'Formula',
            header: '计算公式',
			allowBlank: false,
			edit:false,
			width:400,
			edit:false,
            dataIndex: 'Formula'
        },{
            id:'CodeFormula',
            header: '公式描述',
			allowBlank: false,
			edit:false,
			hidden:true,
			width:400,
			edit:false,
            dataIndex: 'CodeFormula'
        }],
		tbar:[addButton,'-',editButton,'-',delButton,'-',CopyButton] 
});

   itemGrid.btnResetHide();  //隐藏重置按钮
   itemGrid.btnPrintHide();  //隐藏打印按钮
   itemGrid.btnAddHide();  //隐藏增加按钮
   itemGrid.btnDeleteHide();  //隐藏删除按钮
   itemGrid.btnSaveHide();  //隐藏修改按钮
    