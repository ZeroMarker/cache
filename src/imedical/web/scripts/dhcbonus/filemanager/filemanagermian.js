//正则式规范字符串函数
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

var userId = session['LOGON.USERID'];

var FileManagerTabUrl = '../csp/dhc.bonus.filemanagerexe.csp';
//配件数据源
var FileManagerTabProxy= new Ext.data.HttpProxy({url:FileManagerTabUrl+'?action=list'});
var FileManagerTabDs = new Ext.data.Store({
	proxy: FileManagerTabProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'userId',
		'userName',
		'fileName',
		'date'
	]),
	remoteSort: true
});

//设置默认排序字段和排序方向
FileManagerTabDs.setDefaultSort('rowid', 'name');

//数据库数据模型
var FileManagerTabCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '上传用户',
		dataIndex: 'userName',
		width: 150,		  
		sortable: true,
		align: 'center'
	},{
		header: ' 文件名称',
		dataIndex: 'fileName',
		width: 250,
		sortable: true,
		align: 'center'
	},{
		header: '上传时间',
		dataIndex: 'date',
		width: 250,
		sortable: true,
		align: 'center'
	}
]);

//初始化默认排序功能
FileManagerTabCm.defaultSortable = true;

//分页工具栏
var FileManagerTabPagingToolbar = new Ext.PagingToolbar({
	store: FileManagerTabDs,
	pageSize:25,
	displayInfo: true,
	displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg: "没有记录"
});

var excelUpload = new Ext.form.TextField({   
	id:'excelUpload', 
	anchor:'90%',   
	height:20,
	width:350,	
	inputType:'file',
	fieldLabel:'文件选择'
});
		
var formPanel = new Ext.form.FormPanel({
	labelWidth:80,
	bodyStyle:'padding:5 5 5 5',
	height:515,
	width:515,
	frame:true,
	fileUpload:true,
	items:[excelUpload]
});

var upLoadButton = new Ext.Toolbar.Button({
	text: '文件上传',     
    iconCls:'add',
	handler:function(){
		// 定义按钮
		var upLoadFile = new Ext.Toolbar.Button({
			text:'上传'
		});

		// 下载数据功能
		var up = function(bt) {
			if (bt == "yes") {
				function callback(id) {
					if (id == "yes") {
						var excelName = Ext.getCmp('excelUpload').getRawValue();// 上传文件名称的路径
						if (excelName == ""){
							Ext.Msg.show({title:'提示',msg:'请选择文件!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
							return;
						}else {
							var array = new Array();
							array = excelName.split("\\");
							var length = array.length;
							var fileName = "";
							var i = 0;
							for (i = 0; i < length; i++) {
								if (fileName == "") {
									fileName = array[i];
								} else {
									fileName = fileName + "/" + array[i];
								}
							}
							
							Ext.Ajax.request({
								url: '../csp/dhc.bonus.filemanagerexe.csp?action=add&userId='+userId+'&fileName='+array[length-1],
								waitMsg:'保存中...',
								failure: function(result, request){
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success == 'true'){
										var uploadUrl = "http://127.0.0.1:8080/dhchxbonus/upLoadFiles";
										formPanel.getForm().submit({
											url:uploadUrl,
											method:'POST',
											waitMsg:'数据导入中, 请稍等...',
											success:function(form, action, o) {
												Ext.MessageBox.alert("提示信息",action.result.mess);
												window.close();
												FileManagerTabDs.load({params:{start:0, limit:FileManagerTabPagingToolbar.pageSize}});
											},
											failure : function(form, action) {
												Ext.MessageBox.alert("提示信息", action.result.mess);
												window.close();
												Ext.Ajax.request({
													url: '../csp/dhc.bonus.filemanagerexe.csp?action=del&fileName='+array[length-1],
													waitMsg:'保存中...',
													failure: function(result, request){
													},
													success: function(result, request){
													},
													scope: this
												})
											}
										});
									}else{
										var message="";
										if(jsonData.info == 'RepRec'){
											message = '上传文件已存在!';
										}
										if(jsonData.info == '0'){
											message = '上传失败,请重新上传!';
										}
										Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									}
								},
								scope: this
							})
						}
					} else {
						return;
					}
				}
				Ext.MessageBox.confirm('提示', '确定要上传该文件吗?', callback);
			}
			Ext.MessageBox.confirm('提示', '确定要上传该文件吗?', callback);
		}
			
		// 添加按钮的响应事件
		upLoadFile.addListener('click', up, false);
			
		var window = new Ext.Window({
			title:'上传文件',
			width:500,
			height:200,
			minWidth:500,
			minHeight:200,
			layout:'fit',
			plain:true,
			modal:true,
			closeAction:'hide',
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items:formPanel,
			buttons:[upLoadFile]
		});
		window.show();
	}
});

var downButton = new Ext.Toolbar.Button({
	text: '文件下载',     
    iconCls:'add',
	handler:function(){
	
		//定义并初始化行对象
		var rowObj=FileManagerTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要阅读的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择下载的文件!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var fileName = rowObj[0].get("fileName");
			var checkFileExist="Y";
			var is="Y";
			window.location.href = 'http://127.0.0.1:8080/dhchxbonus/downFiles?fileName='+encodeURI(encodeURI(fileName))+'&checkFileExist='+checkFileExist+'&is='+is;
		}
	}
});

//表格
var FileManagerTab = new Ext.grid.EditorGridPanel({
	title: '文件管理',
	store: FileManagerTabDs,
	cm: FileManagerTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	tbar:[upLoadButton,'-',downButton],
	loadMask: true,
	bbar:FileManagerTabPagingToolbar
});

FileManagerTabDs.load({params:{start:0, limit:FileManagerTabPagingToolbar.pageSize}});