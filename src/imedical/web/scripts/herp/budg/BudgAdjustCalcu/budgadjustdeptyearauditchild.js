ChildFun = function(mainID)
{	
	
var projUrl='herp.budg.budgadjustdeptyearauditchildexe.csp';
	
///////////////// 方案名称 ///////////////////////
var bsmNameDs  = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader(
		{totalProperty:'results',root:'rows'},
		['rowid','name'])
});

bsmNameDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
	
			url:projUrl+'?action=bsmname',method:'POST'});
			});

var bsmNameComBox = new Ext.form.ComboBox({
		id: 'bsmName',
		fieldLabel: '方案名称',
		width:120,
		listWidth : 225,
		store: bsmNameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择方案...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
});
	
	/////////////////保存按钮////////////////////////////
var saveButton = new Ext.Toolbar.Button({
	text: '保存',
    tooltip:'添加',        
    iconCls: 'save',
	handler:function(){
	AddFun1();			
		}
	
});
	
		
		
	var childGrid = new dhc.herp.Grid({
	    title: '前置方案列表 ',
	    width: 400,
	    region: 'center',
	    url:projUrl ,

	    fields: [
	    {
	        id:'rowid',
	        header: 'ID',
	        dataIndex: 'rowid',			
	        editable:false,
	        hidden: true
	    },{
	        id:'bsmcode',
	        header: '方案编号',
	        dataIndex: 'bsmcode',
	        width:150,
			editable:false
	    },{
	        id:'bsmname',
	        header: '方案名称',
	        dataIndex: 'bsmname',
	        width:250,
	        update:true,
			hidden: false,
			type:bsmNameComBox
	    },{ 
	        id:'bsmorderby',
	        header: '编制顺序',
	        dataIndex: 'bsmorderby',
	        width:105,
			editable:false,
			hidden: false
	    }]

	});
	childGrid.load(({params:{start:0,limit:25,mainID:mainID}}));
	
	childGrid.addButton(saveButton)
	
	childGrid.btnSaveHide();  //隐藏保存按钮
	childGrid.btnResetHide();  //隐藏重置按钮
	childGrid.btnPrintHide();  //隐藏打印按钮
	
	
	
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
				items : [childGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				plain : true,
				width : 550,
				height : 450,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
	
	AddFun1=function() {
		var records=childGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = childGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var rtn = 0;
	    var datad="";
		Ext.each(records, function(r) {
			var o = {};
			var tmpstro = "&rowid=" + r.data['rowid'];
			var deleteFlag = r.data['delFlag'];// 删除标识，1：是该记录已经删除，0：未删除。

			// 数据完整性验证Beging
			for (var i = 0; i < childGrid.fields.length; i++) {
				var indx = childGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = childGrid.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// 列增加update属性，true：该列数据没有变化也向后台提交数据，false：则不会强制提交数据
					var reValue = r.data[indx];
					if ((typeof(reValue) != "undefined") && (tmobj.update)) {
						tmpstro += "&" + indx + "=" + r.data[indx].toString();
					}
					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")|| (parseInt(r.data[indx].toString()) == 0)) {
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
			
			var rowid = r.data['rowid'];
			var uperID = r.data['bsmname']; // 新增数据的ID			
		
			var datad = mainID+"|"+uperID+"|"+rowid;
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
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = childGrid.url + '?action=' + recordType + tmpstro.toString()+"&datad="+datad+Ext.urlEncode(this.urlParam);
			
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
						childGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							childGrid.store.load({
								params : {
									start : Ext
											.isEmpty(childGrid.getTopToolbar().cursor)
											? 0
											: childGrid.getTopToolbar().cursor,
									limit : childGrid.pageSize
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							childGrid.store.load({
								params : {
									start : Ext
											.isEmpty(childGrid.getTopToolbar().cursor)
											? 0
											: childGrid.getTopToolbar().cursor,
									limit : childGrid.pageSize
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
						childGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		
		childGrid.load(({params:{start:0,limit:25,mainID:mainID}}));

		return rtn;
	}
	
	
};