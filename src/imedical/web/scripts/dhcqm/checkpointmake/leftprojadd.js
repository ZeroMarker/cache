
addProjFun = function(dataStore,grid) {
	

	var uCodeField = new Ext.form.TextField({
		id: 'CodeField',
		fieldLabel: '项目编码',
		width:325,
		allowBlank:false,
		//listWidth : 295,
		triggerAction: 'all',
		emptyText:'',
		name: 'CodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var uNameField = new Ext.form.TextField({
		id: 'NameField',
		fieldLabel: '项目名称',
		width:325,
		allowBlank:false,
		//listWidth : 295,
		triggerAction: 'all',
		emptyText:'',
		name: 'NameField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var nameDs = new Ext.data.Store({   //解析数据源
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'	
		},['Rowid','name']),
		//remoteSort: true	
		autoLoad:true
		
	});
	nameDs.on('beforeload',function(ds,o){  //数据源监听函数调用后台类方法查询数据
		ds.proxy = new Ext.data.HttpProxy({
			url:'dhc.qm.checkpointmakeexe.csp'+'?action=listcheckproj&fuzzyquery='+encodeURIComponent(Ext.getCmp('linkerField').getRawValue()),method:'POST'
		});
	});

	var linkerField = new Ext.form.ComboBox({
		id: 'linkerField',
		fieldLabel: '选择关联医嘱',
		width:305,
		listWidth : 305,
		resizable:true,
		//allowBlank: false,
		store: nameDs,
		valueField: 'Rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择医嘱...',
		name: 'linkerField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		//showSelectAll :true,
		editable:true
	});


	
	var aChkUserGrid = new Ext.grid.GridPanel({
		id:'aChkUserGrid',
		store: new Ext.data.Store({
			proxy: new Ext.data.MemoryProxy(),
			reader: new Ext.data.ArrayReader({}, [  
				 {name: 'Rowid'},  
				 {name: 'name'}
			 ])  
		}),
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				width:50,
				sortable: true
			},
			columns: [
				{id: 'Rowid', header: '医嘱ID', width: 18, sortable: true, dataIndex: 'Rowid',hidden:true},
				{header: '医嘱列表', dataIndex: 'name',align:'center',width: 350}
			]
		}),
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		width: 408,
		height: 130
	});
///////////////添加多个审批人按钮////////////////
	var addParticipants  = new Ext.Button({
		text: '添加关联医嘱',
		handler: function(){
			var ChkUserId;
			var id = Ext.getCmp('linkerField').getValue();
			var ChkName = Ext.getCmp('linkerField').getRawValue();

			var ptotal = aChkUserGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = aChkUserGrid.getStore().getAt(i).get('Rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了相同项!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    ChkUserId=id;
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的医嘱!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择要添加的医嘱!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						ChkUserId=id;	
				}	
			}
			var data = new Ext.data.Record({'Rowid':ChkUserId,'name':ChkName});
			aChkUserGrid.stopEditing(); 
			aChkUserGrid.getStore().insert(0,data);
		}
	});	
	var delParticipants = new Ext.Button({
		text:'删除关联医嘱',
		style:'margin-left:5px;padding:0 5px 0 5px;',
		handler: function() {  
			var rows = aChkUserGrid.getSelectionModel().getSelections();
			var length = rows.length;
			
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的医嘱!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = aChkUserGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				aChkUserGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}		
		}
	});
	
	//=====================2016-04-11 添加=====================//
	var activeRadioGroup=new Ext.form.RadioGroup({
		name:'activeRadio',
		fieldLabel:'项目是否启用',
		columns: 4,
		items:[{
			boxLabel:'启用',
			inputValue:'Y',
			name:'activeRadio',
			style:'height:14px;',
			checked:true
		},{
			boxLabel:'禁用',
			inputValue:'N',
			style:'height:14px;',
			name:'activeRadio'
		}]
	});
	var schemeTypeRadioGroup=new Ext.form.RadioGroup({
		name:'schemeTypeRadio',
		fieldLabel:'项目周期类型',
		columns: 4,
		items:[{
			boxLabel:'月份',
			inputValue:'M',
			name:'schemeTypeRadio',
			style:'height:14px;',
			checked:true
		},{
			boxLabel:'季度',
			inputValue:'Q',
			style:'height:14px;',
			name:'schemeTypeRadio'
		},{
			boxLabel:'半年',
			inputValue:'H',
			style:'height:14px;',
			name:'schemeTypeRadio'
			
		},{
			boxLabel:'全年',
			inputValue:'Y',
			style:'height:14px;',
			name:'schemeTypeRadio'
		}]
	});
	var importTypeRadioGroup=new Ext.form.RadioGroup({
		name:'importTypeRadio',
		fieldLabel:'数据来源类型',
		columns: 4,
		items:[{
			boxLabel:'电脑端',
			inputValue:'2',
			name:'importTypeRadio',
			style:'height:14px;',
			checked:true
		},{
			boxLabel:'移动端',
			inputValue:'1',
			style:'height:14px;',
			name:'importTypeRadio'
		}]
	});
	var checkTypeRadioGroup=new Ext.form.RadioGroup({
		name:'checkTypeRadio',
		fieldLabel:'项目记录类型',
		columns: 4,
		style:"maginTop:0px;",
		 
		items:[{
			boxLabel:'不合格记录',
			inputValue:'1',
			name:'checkTypeRadio',
			style:'height:14px;',
			checked:true
		},{
			boxLabel:'全部记录',
			inputValue:'2',
			style:'height:14px;',
			name:'checkTypeRadio'
		},{
			boxLabel:'特殊检查点',
			inputValue:'3',
			style:'height:14px;',
			name:'checkTypeRadio'
		}]
	});
	var checkTypeBZ=new Ext.form.DisplayField({
		value:'<span style="color:red;"></span><span style="color:red;">“不合格记录”</span><span style="color:;">表示：一条记录中有一个为否，则整条记录不合格；'+
						'</br><span style="color:red;">“全部记录”&nbsp;&nbsp;&nbsp;</span>表示：导入的数据，均为不合格记录;</br><span style="color:red;">“特殊检查点”</span>表示：记录中满足特殊检查点条件时，为不合格记录。'
	});
	//========================================================//
	
	var colItems =[
			uCodeField,
			uNameField,
			activeRadioGroup,
			importTypeRadioGroup,
			schemeTypeRadioGroup,
			checkTypeRadioGroup,
			{columnWidth : .9,
			xtype: 'fieldset',
			layout : "column",
			title:'提示',
			items : [
				checkTypeBZ
			]},
			{//关联医嘱
			columnWidth:.9,
			xtype:'fieldset',
			title:'关联医嘱',
			items:[
				linkerField,
				{
				columnWidth : 1,
				xtype : 'panel',
				layout : "column",
				items : [
					addParticipants,
					delParticipants
				]
				},
				aChkUserGrid
			]	
			}
		]

	var formPanel = new Ext.form.FormPanel({
		labelWidth:90,
		frame: true,
		items:colItems
	});
			
	//初始化添加按钮
	add1Button = new Ext.Toolbar.Button({
		text:'添 加'
	});
	
	var auser="";
	//定义添加按钮响应函数
	add1Handler = function(){
	
		var adesc = uNameField.getValue();
		//var auint = aunitField.getValue();
		var auint="";
		var chknamecount = aChkUserGrid.getStore().getCount();
		  if(chknamecount>0){
			var id = aChkUserGrid.getStore().getAt(0).get('Rowid');
			auser = id;
			for(var i=1;i<chknamecount;i++){
			  var tmpid = aChkUserGrid.getStore().getAt(i).get('Rowid');
			  auser = auser+","+tmpid;
			   };
		   }
		var code = uCodeField.getValue();
		//var uisStop = linkerField.getValue();     		
		Cname = adesc.trim();
		Code = code.trim();
		//获得单选按钮选中的值
		var schemeTypeRadio=formPanel.getForm().findField('schemeTypeRadio').getValue().inputValue;
		var importTypeRadio=formPanel.getForm().findField('importTypeRadio').getValue().inputValue;
		var checkTypeRadio=formPanel.getForm().findField('checkTypeRadio').getValue().inputValue;
		var activeRadio=formPanel.getForm().findField('activeRadio').getValue().inputValue;
		//console.log(schemeTypeRadio+"^"+importTypeRadio+"^"+checkTypeRadio+"^"+activeRadio);
			
		var data =encodeURIComponent(Code)+'^'+encodeURIComponent(Cname)+'^'+encodeURIComponent(auser)+'^'+schemeTypeRadio+"^"+importTypeRadio+"^"+checkTypeRadio+"^"+activeRadio;
			
		if (formPanel.form.isValid()) {
			Ext.Ajax.request({
				url: projUrl+'?action=addleft&data='+data,
				failure: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					console.log(jsonData);
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						//itemGridDs.load({params:{start:0}});
						itemGridDs.load({params:{start:0, limit:25}});		
						//window.close();
					}else{
						/*添加编码重复和名称重复 20160517 cyl add
						jsonData=RefSchemCode^RefSchemName
						*/
						var message = "";
						//先分解jsonData
						var jsonInfo=jsonData.info;
						var errorObj=jsonInfo.split("^");
						for(var i=0;i<errorObj.length;i++){
							var errorStr=errorObj[i];
							if(errorStr=="RefSchemCode"){
								message = message+"项目编码重复！<br/>";
							}else if(errorStr=="RefSchemName"){
								message = message+"项目名称重复！";
							}
							
						}
						if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
						if(jsonData.info=='RepKPI') message='重复!';
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
        }else{
			Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	},
    	
    {
		text: '取消',
        handler: function(){window.close();}
    }

	//添加保存按钮的监听事件
	add1Button.addListener('click',add1Handler,false);

	//初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});

	//定义取消按钮的响应函数
	cancelHandler = function(){
		addwin.close();
	};

	//添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler,false);

	//初始化窗口
	addwin = new Ext.Window({
		title: '添加记录',
		width: 470,
		height:555,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		resizable:false,
		buttons: [
			add1Button,
			cancelButton
		]
	});

	//窗口显示
	addwin.show();
	
};