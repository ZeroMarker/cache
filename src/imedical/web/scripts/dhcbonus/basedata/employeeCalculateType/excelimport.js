/**
 * name:tab of database author:wang ying Date:2011-1-7 绩效考核在系统指标数据excel文件上传功能
 */
var importExcel = function() {
	var excelUpload = new Ext.form.TextField({
				id : 'excelUpload',
				name : 'Excel',
				anchor : '90%',
				height : 20,
				inputType : 'file',
				fieldLabel : '文件选择'
			});

	// 文件选择
	var upLoadFieldSet = new Ext.form.FieldSet({
				title : '文件选择',
				height : 50,
				labelSeparator : '：',
				items : [excelUpload]
			});

	// 多文本域
	var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 325,
				fieldLabel : '友好提示',
				readOnly : true,
				disabled : true,
				emptyText : '请仔细核对要导入数据的格式以及数据的有效性！'
			});

	// 导入说明多文本域
	var exampleFieldSet = new Ext.form.FieldSet({
				title : '数据导入友情提示',
				height : 90,
				labelSeparator : '：',
				items : textArea
			});

	var formPanel = new Ext.form.FormPanel({
		labelWidth : 80,
		bodyStyle : 'padding:5 5 5 5',
		height : 360,
		width : 515,
		frame : true,
		fileUpload : true,
		items : [upLoadFieldSet, exampleFieldSet]
		});

	// 定义按钮
	var importB = new Ext.Toolbar.Button({
				text : '数据导入'
			});

	// 下载数据功能
	var handler = function(bt) {
		if (bt == "yes") {
			function callback(id) {
				if (id == "yes") {

					var bYear = Ext.getCmp('cycle').getValue();
					var bPeriod = Ext.getCmp('period').getValue();

					// 判断是否已选择好所要上传的excel文件
					var excelName = Ext.getCmp('excelUpload').getRawValue();// 上传文件名称的路径
					if (excelName == "") {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择Excel文件!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFOR
								});
						return;
					} else {
						var array = new Array();
						array = excelName.split("\\");
						var fileName = "";
						var i = 0;
						for (i = 0; i < array.length; i++) {
							if (fileName == "") {
								fileName = array[i];
							} else {
								fileName = fileName + "/" + array[i];
							}
						}

						var uploadUrl ="http://127.0.0.1:8080/dhchxbonus/importRyxx";
						
						formPanel.getForm().submit({
							url : uploadUrl,
							method : 'POST',
							waitMsg : '数据导入中, 请稍等...',
							success : function(form, action, o) {
								Ext.MessageBox.alert("提示信息", "数据成功导入!");
							},
							failure : function(form, action) {
								Ext.messageBox.alert("提示信息", action.result.mess);
							}
						});
					}
				} else {
					return;
				}
			}
			//Ext.MessageBox.confirm('提示', '确定要导入该文件中的数据吗?', callback);
			Ext.MessageBox.confirm('xxx', 'dddd', callback);
		}
		//Ext.MessageBox.confirm('提示', '确定要导入excel数据吗?', callback);
		Ext.MessageBox.confirm('xxx', 'dddd', callback);
	}

	// 添加按钮的响应事件
	importB.addListener('click', handler, false);

	// 定义关闭按钮
	var cancelButton = new Ext.Toolbar.Button({
				text : '关闭导入'
			});

	// 定义关闭按钮响应函数
	cancelHandler = function() {
		window.close();
	}

	// 添加关闭按钮监听事件
	cancelButton.addListener('click', cancelHandler, false);

	var window = new Ext.Window({
				title:'导入人员信息数据',
				width:530,
				height:270,
				minWidth:530,
				minHeight:270,
				layout:'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items:formPanel,
				buttons:[importB,cancelButton]
			});
	window.show();
}