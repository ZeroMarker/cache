editLocFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var rowid = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	rowid=rowObj[0].get("id");
	
	var hospProxy = new Ext.data.HttpProxy({url:'dhc.ca.locsexe.csp?action=listhosp'});

	var hospDs = new Ext.data.Store({
			proxy: hospProxy,
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['Name','Rowid'])	
	});

	var hospSelecter = new Ext.form.ComboBox({
		id: 'myHospSelecter',
		anchor: '90%',
		listWidth: 260,
		valueNotFoundText:rowObj[0].get("hospName"),
		fieldLabel: '所属医院',
		store: hospDs,
		valueField: 'Rowid',
		displayField: 'Name',
		typeAhead: false,
		pageSize: 5,
		minChars: 1,
		triggerAction: 'all',
		emptyText: '请选择...',
		selectOnFocus: true,
		forceSelection: true,
		readOnly: true
	});
	
	var assLocDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['Rowid','Code','Name','Phone','Addr','Remark','Start','End','Active','Desc','Hosp'])
	});
	var assLoc = new Ext.form.ComboBox({
		id: 'assLoc',
		fieldLabel: '部门',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: assLocDs,
		valueNotFoundText:rowObj[0].get("name"),
		valueField: 'Rowid',
		displayField: 'Desc',
		triggerAction: 'all',
		emptyText:'选择部门...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	assLocDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.deptlevelsetsexe.csp?action=listloc&recname='+Ext.getCmp('assLoc').getRawValue()+'&id='+hospSelecter.getValue(),method:'GET'});
	});
	
	var activeFlag = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '分摊标记:',
		allowBlank: false,
		checked: (rowObj[0].data['recCost'])=='Y'?true:false,
		listeners :{
            specialKey :function(field,e){
                if (e.getKey() == Ext.EventObject.ENTER){
					Ext.getCmp("saveButton").focus();
				}
            }
        }
	});
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
		fieldLabel: '顺序',
		selectOnFocus:true,
		allowBlank: false,
		name:'order',
		emptyText:'顺序...',
		anchor: '90%'
	});
	
	// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
				hospSelecter,
				assLoc,
				orderField,
				activeFlag
			]
	});
    
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		hospSelecter.setValue(rowObj[0].get("hospDr"));
		assLoc.setValue(rowObj[0].get("locDr"));
	});
	
	var window = new Ext.Window({
		title: '添加部门分层',
		width: 400,
		height:200,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存', 
			id:"saveButton",
			handler: function() {
				// check form value
				if (formPanel.form.isValid()) {
					var active=(activeFlag.getValue()==true)?'Y':'N';
						Ext.Ajax.request({
							url: deptLevelSetsUrl+'?action=editloc&locDr='+assLoc.getValue()+'&active='+active+'&id='+rowid+"&subjdr="+repdr+'&order='+orderField.getValue(),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
								Ext.getCmp('detailReport').getNodeById(repdr).reload();
								window.close();
								}
								else
								{
									var message=jsonData.info;
									if(message=="roo")  message="部门不能添加此节点下!"
									else message="该部门已经在"+jsonData.info+"下添加!";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
				}
				else{
					Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}             
			}
		},
		{
			text: '取消',
			handler: function(){window.close();}
		}]
	});
    window.show();
	hospSelecter.on("select",function(cmb,rec,id ){
		assLocDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
	});
};