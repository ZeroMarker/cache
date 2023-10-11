supSchemeFun = function(curSchemeDr, curSchemeName, Code, OrderBy) {
	var deptyearURL='herp.budg.adjustdeptyearexe.csp';
	var deptyearexeuperURL='herp.budg.adjustdeptyearexeuper.csp';
	var cschemeName = '当前预算方案：' + curSchemeName;

	// herp.budg.superschemexe.csp
	var bschemeDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

/*********************
	bschemeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.adjustdeptyearexe.csp'
									+ '?action=SupSchList&start=0&limit=25&orderby='
									+ OrderBy + '&Code=' + Code,
							method : 'POST'
						});
			});
**********************/
	bschemeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : deptyearURL
									+ '?action=SupSchList&start=0&limit=25',
							method : 'POST'
						});
			});
	var bschemebox = new Ext.form.ComboBox({
				id : 'bschemebox',
				fieldLabel : '预算方案',
				width : 280,
				listWidth : 280,
				allowBlank : false,
				store : bschemeDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'bschemebox',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

//////保存按钮                                                                     
var save = new Ext.Toolbar.Button({
	text: '保存',
	tooltip: '保存',
	iconCls: 'option',
	handler: function() {
		var forms = supSchemeGrid.forms;
		var flag = Ext.each(forms, function(i) {
					if (i.getXType() === 'form') {
						return i.getForm().isValid();
					}
				});
		if (!flag && forms.length > 0) {
			Ext.Msg.show({
						title : '错误',
						msg : '请将数据添加完整后再试!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return -1;
		}
		this.focus();

		var tmpDate = supSchemeGrid.dateFields;
		var records = supSchemeGrid.store.getModifiedRecords();
		var tmpStore = supSchemeGrid.store;
		var topbar = supSchemeGrid.getTopToolbar().items;
		var stro = "";
		Ext.each(topbar.items, function(i) {
					if (i.getXType() === 'combo') {
						stro += "&" + i.getId() + "=" + i.getValue();
					}
				})
		if (!records.length) {
			return;
		}
		var data = [];
		var p;
		var rtn = 0
		Ext.each(records, function(r) {

			var o = {};
			var tmpstro = "&rowids=" + r.data['rowid']+"&curSchemeDr="+curSchemeDr;
			var deleteFlag = r.data['delFlag'];// 删除标识，1：是该记录已经删除，0：未删除。

			// 数据完整性验证Beging
			for (var i = 0; i < supSchemeGrid.fields.length; i++) {

				var indx = supSchemeGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = supSchemeGrid.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// 列增加update属性，true：该列数据没有变化也向后台提交数据，false：则不会强制提交数据
					var reValue = r.data[indx];
					if ((typeof(reValue) != "undefined") && (tmobj.update)) {
						tmpstro += "&" + indx + "=" + r.data[indx].toString();
					}

					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")
								|| (parseInt(r.data[indx].toString()) == 0)) {

							var info = "[" + title + "]列为必填项，不能为空或零！"
							Ext.Msg.show({
										title : '错误',
										msg : info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							rtn = -1;
							return -1;

						}
					}
				}

			}
			// 数据完整性验证END

			if (r.isValid()) {
				if (deleteFlag == "-1") {
					return;
				}

				for (var f in r.getChanges()) {

					o[f] = r.data[f];
					if (r.data[f] != null) {
						if (tmpDate.indexOf(f) >= 0) { // field.type=='date'
							if (r.data[f].toString() == "") {
								tmpstro += "&" + f + "=" + r.data[f].toString();
							} else {
								tmpstro += "&"
										+ f
										+ "="
										+ new Date(r.data[f]).format('Y-m-d')
												.toString();
							}
						} else if (f != null) {
							var chk = r.data[f];
							if (chk === true)
								chk = 'Y';
							else if (chk === false)
								chk = 'N';

							tmpstro += "&" + f + "=" + encodeURIComponent(chk);
						}
					}
				}
				// alert(tmpstro)
			} else {
				Ext.Msg.show({
							title : '错误',
							msg : '请将数据添加完整后再试!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}

			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
			} else {
				recordType = "edit";
			}
			o[supSchemeGrid.idName] = r.get(supSchemeGrid.idName);
			data.push(o);
			var saveUrl = this.url + '?action=' + recordType + stro.toString()
					+ "&" + tmpstro.toString() + "&"
					+ Ext.urlEncode(supSchemeGrid.urlParam);
			// alert(saveUrl)
			p = {
				url : saveUrl,
				method : 'GET',
				waitMsg : '保存中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {

						var message = "";
						message = recordType == 'add' ? '添加成功!' : '保存成功!'
						Ext.Msg.show({
									title : '注意',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						tmpStore.commitChanges();
						if (jsonData.refresh == 'true') {
							tmpStore.load({
								params : {
									start : Ext
											.isEmpty(this.getTopToolbar().cursor)
											? 0
											: this.getTopToolbar().cursor,
									limit : this.pageSize
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							tmpStore.load({
								params : {
									start : Ext
											.isEmpty(this.getTopToolbar().cursor)
											? 0
											: this.getTopToolbar().cursor,
									limit : this.pageSize
								}
							});
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '输入的名称为空!';
						if (jsonData.info == 'EmptyOrder')
							message = '输入的序号为空!';
						if (jsonData.info == 'RepCode')
							message = '输入的编码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的名称已经存在!';
						if (jsonData.info == 'RepOrder')
							message = '输入的序号已经存在!';
						if (jsonData.info == 'RecordExist')
							message = '输入的记录已经存在!';
						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						this.store.rejectChanges();
					}
				},
				scope : supSchemeGrid
			};
			Ext.Ajax.request(p);
		}, supSchemeGrid);
		return rtn;
	}
});

	// 前置方案设置grid
	var supSchemeGrid = new dhc.herp.Grid({
				title : cschemeName,
				width : 400,
				region : 'center',
				url : deptyearexeuperURL,
				fields : [
                        new Ext.grid.CheckboxSelectionModel({editable:false}),
                        {
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'Code',
							header : '方案编号',
							dataIndex : 'Code',
							width : 65,
							align : 'center',
							editable:false
							//type : bschemebox,
						}, {
							id : 'Name',
							header : '方案名称',
							dataIndex : 'Name',
							width : 280,
							align : 'left',
							// editable:false,
							type : bschemebox,
                            values:Code,
							hidden : false

						}, {
							id : 'OrderBy',
							header : '编制顺序',
							dataIndex : 'OrderBy',
							width : 60,
                            editable:false,
							align : 'center'
						}],
                       tbar:[save,'-']
                 

			});
        ///addmainGrid.btnAddHide();  //隐藏增加按钮
   	supSchemeGrid.btnSaveHide();  //隐藏保存按钮
    supSchemeGrid.btnResetHide();  //隐藏重置按钮
    ///addmainGrid.btnDeleteHide(); //隐藏删除按钮
    supSchemeGrid.btnPrintHide();  //隐藏打印按钮
	supSchemeGrid.load({params:{start:0,limit:15,rowid:curSchemeDr}})
	
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
				items : [supSchemeGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '预算前置方案列设置',
				plain : true,
				width : 468,
				height : 300,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}