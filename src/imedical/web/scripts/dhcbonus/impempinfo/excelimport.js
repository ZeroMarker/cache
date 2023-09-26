/**
 * name:tab of database author:wang ying Date:2011-1-7 绩效考核在系统指标数据excel文件上传功能
 */
var importExcel = function() {
	var data2 = "";
	var freStore = "";

	var data = "";
	var StratagemTabUrl = '../csp/dhc.bonus.deptbonuscalcexe.csp';
	var cycleDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty:'results',
							root:'rows'
						}, ['rowid','BonusYear'])
			});

	cycleDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : StratagemTabUrl
									+ '?action=yearlist&topCount=5&orderby=Desc',
							method : 'POST'
						})
			});

	var cycle = new Ext.form.ComboBox({
		id : 'cycle',
		fieldLabel : '核算年度',
		allowBlank : false,
		store : cycleDs,
		valueField : 'BonusYear',
		displayField : 'BonusYear',
		triggerAction : 'all',
		emptyText : '请选择核算年度...',
		// name : 'cycleField',
		mode : 'local', // 本地模式
		minChars : 1,
		anchor : '90%',
		pageSize : 10,
		selectOnFocus : true,
		forceSelection : true
			// editable : true
		});

	var pTypeStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['M', 'M-月'], ['Q', 'Q-季'], ['H', 'H-半年'], ['Y', 'Y-年']]
			});
	var periodType = new Ext.form.ComboBox({
				id : 'periodType',
				fieldLabel : '期间类型',
				// width:180,
				// listWidth : 180,
				selectOnFocus : true,
				allowBlank : false,
				store : pTypeStore,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '选择期间类型...',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	periodType.on("select", function(cmb, rec, id) {
				if (cmb.getValue() == "M") {
					data2 = [['M01', '01月'], ['M02', '02月'], ['M03', '03月'],
							['M04', '04月'], ['M05', '05月'], ['M06', '06月'],
							['M07', '07月'], ['M08', '08月'], ['M09', '09月'],
							['M10', '10月'], ['M11', '11月'], ['M12', '12月']];
				}
				if (cmb.getValue() == "Q") {
					data2 = [['Q01', '01季度'], ['Q02', '02季度'], ['Q03', '03季度'],
							['Q04', '04季度']];
				}
				if (cmb.getValue() == "H") {
					data2 = [['H01', '上半年'], ['H02', '下半年']];
				}
				if (cmb.getValue() == "Y") {
					data2 = [['Y00', '全年']];
				}
				pStore.loadData(data2);
			});
	pStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue']
			});

	var period = new Ext.form.ComboBox({
				id : 'period',
				fieldLabel : '期间值',
				// width:180,
				// listWidth : 180,
				selectOnFocus : true,
				allowBlank : false,
				store : pStore,
				anchor : '90%',
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '请选择期间值...',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});


			
	var fileTypeDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
 
	fileTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.bonus.bonustargetcollectexe.csp?action=fileType&modeType=2&userCode='+session['LOGON.USERCODE'],method:'POST'})
	});

	var fileType = new Ext.form.ComboBox({
		id: 'fileType',
		fieldLabel:'文件类别',
		allowBlank: false,
		store: fileTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择文件类别...',
		name:'fileType',
		minChars:1,
		anchor : '90%',
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
			
	var ImpTileNameField = new Ext.form.TextField({
				id : 'ImpTileNameField',
				name : 'ImpTileNameField',
				fieldLabel : '文件标题',
				allowBlank : false,
				emptyText : '必填',
				anchor : '100%'
			});			
	var excelUpload = new Ext.form.TextField({
				id : 'excelUpload',
				name : 'Excel',
				anchor : '90%',
				height : 20,
				inputType : 'file',
				fieldLabel : '数据文件'
			});

	// 文件选择
	var upLoadFieldSet = new Ext.form.FieldSet({
				title : '文件选择',
				height : 75,
				labelSeparator : '：',
				items : [fileType,excelUpload]
			});

	// 多文本域
	var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 370,
				fieldLabel : '备注说明',
				//readOnly : false,
				//disabled : true, 
				//anchor : '100%',
				emptyText : '不能超过100个字！'
			});

	// 导入说明多文本域
	var exampleFieldSet = new Ext.form.FieldSet({
				title : '数据导入友情提示',
				height : 110,
				labelSeparator : '：',
				items : textArea
			});
	// 公共条件选择
	var publicFieldSet = new Ext.form.FieldSet({
				title : '导入说明',
				height : 130,
				labelSeparator : '：',
				items : [ImpTileNameField, textArea]
			});
	//
	
			
	var formPanel = new Ext.form.FormPanel({
		labelWidth : 80,
		bodyStyle : 'padding:5 5 5 5',
		height : 450,
		width : 515,
		frame : true,
		fileUpload : true,
		items : [publicFieldSet,upLoadFieldSet]
		});
	// , exampleFieldSet
	// 定义按钮
	var importB = new Ext.Toolbar.Button({
		text : '数据导入'
	});

	// 数据导入功能
	var handler = function(bt) {
		if (bt == "yes") {
			function callback(id) {
				if (id == "yes") {
					var bYear = Ext.getCmp('cycle').getValue();
					var bPeriod = Ext.getCmp('period').getValue();
					
					var stitle =Ext.getCmp('ImpTileNameField').getValue();
					var sremark =Ext.getCmp('textArea').getValue();
					var fileTypeID =Ext.getCmp('fileType').getValue();
					
					//var configFile=Ext.getCmp('fileType').getRawValue().split("-")[0];
					
					// 判断是否已选择好所要上传的excel文件
					var excelName = Ext.getCmp('excelUpload').getRawValue();// 上传文件名称的路径
					if (excelName == "") {
						Ext.Msg.show({
							title:'提示',
							msg:'请选择Excel文件!',
							buttons:Ext.Msg.OK,
							icon:Ext.MessageBox.INFOR
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

						//alert(configFile);
						var uploadUrl = "http://127.0.0.1:8080/dhchxbonus/impempinfo";
						//bonusIssuedExcel
	
						var upUrl = uploadUrl+"?Title="+stitle+"&Remark="+sremark+"&fileTypeID="+fileTypeID+"&userCode="+session['LOGON.USERCODE'];
						
						formPanel.getForm().submit({
							url : upUrl,
							//url:'http://127.0.0.1:8080/dhchxbonus/abc', userCode
							method : 'POST',
							waitMsg : '数据导入中, 请稍等...',
							success : function(form, action, o) {
								Ext.MessageBox.alert("提示信息", "数据成功导入!");
								// Ext.MessageBox.alert("Information",action.result.mess);
							},
							failure : function(form, action) {
								Ext.MessageBox
										.alert("提示信息", action.result.mess);
							}
						});
					}
				} else {
					return;
				}
			}
			Ext.MessageBox.confirm('提示', '确定要导入该文件中的数据吗?', callback);
		}
		Ext.MessageBox.confirm('提示', '确定要导入excel数据吗?', callback);
	}
	
	// 下载数据功能
	var handler1 = function(bt) {
		if (bt == "yes") {
			function callback(id) {
				if (id == "yes") {
					// 判断是否已选择好所要上传的excel文件
					var excelName = Ext.getCmp('excelUpload').getRawValue();// 上传文件名称的路径
					if (excelName == "") {
						Ext.Msg.show({
							title:'提示',
							msg:'请选择Excel文件!',
							buttons:Ext.Msg.OK,
							icon:Ext.MessageBox.INFOR
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

						var uploadUrl = "http://localhost:8080/dhchxbonus/targetCalculateRateServlet";
						var uploadUrl2 = "http://localhost:8080/dhchxbonus/targetCollect";
						var uploadUrl3 = "http://localhost:8080/dhchxbonus/targetJCJ";
						var upUrl = uploadUrl3;
						
						formPanel.getForm().submit({
							url:uploadUrl3,
							method:'POST',
							waitMsg:'数据导入中, 请稍等...',
							success:function(form, action) {
								Ext.MessageBox.alert("提示信息", "数据成功导入!");
							},
							failure : function(form, action) {
								//Ext.MessageBox.alert("提示信息", action.result.mess);
								alert("提交失败");
							}
						});
					}
				} else {
					return;
				}
			}
			Ext.MessageBox.confirm('提示', '确定要导入该文件中的数据吗?', callback);
		}
		Ext.MessageBox.confirm('提示', '确定要导入excel数据吗?', callback);
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
				title : '导入基本指标数据',
				width : 530,
				height : 400,
				minWidth : 530,
				minHeight : 400,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [importB, cancelButton]
			});
	window.show();
}