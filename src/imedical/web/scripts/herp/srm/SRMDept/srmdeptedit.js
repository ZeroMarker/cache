

srmdeptuserEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var code =rowObj[0].get("code");
		var name =rowObj[0].get("name");
		var type =rowObj[0].get("type");
        var DeptClassID =rowObj[0].get("DeptClassID");
		var SuperDeptID =rowObj[0].get("SuperDeptID");
	}
	

	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '科室编码',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uNameField = new Ext.form.TextField({
		id: 'uNameField',
		fieldLabel: '科室名称',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uTypeDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	uTypeDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caltypename&str='
		                     + encodeURIComponent(Ext.getCmp('uTypeField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var uTypeField = new Ext.form.ComboBox({
			id: 'uTypeField',
			fieldLabel: '科室类型',
			width:200,
			listWidth : 225,
			allowBlank: true,
			store: uTypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//暂时为空
			disabled:true,
			//emptyText : '',
			name: 'uTypeField',
			pageSize: 10,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
/////////////////////是否有效/////////////////////////////
var eIsdriectField = new Ext.form.Checkbox({
                        id:'eIsdriectField',
						name:'eIsdriectField',
						fieldLabel : '是否有效',
						labelSeparator:'',
						renderer : function(v, p, record){
        	               p.css += ' x-grid3-check-col-td'; 
        	               return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
					});
/////////////////////科室级别/////////////////////////////					
var ueDeptClassDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '一级科室'], ['2', '二级科室'], ['3', '三级科室'],['4','四级科室']]
	});
	var ueDeptClassField = new Ext.form.ComboBox({
	    id : 'ueDeptClassField',
		fieldLabel : '科室级别',
		width : 200,
		listWidth : 200,
		store : ueDeptClassDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		value:DeptClassID,
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});	
/////////////////////上级科室/////////////////////////////					
	var ueSuperDeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });

	ueSuperDeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caldeptname&str='
		                     + encodeURIComponent(Ext.getCmp('ueSuperDeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var ueSuperDeptField = new Ext.form.ComboBox({
			id: 'ueSuperDeptField',
			fieldLabel: '上级科室',
			width:200,
			listWidth : 250,
			allowBlank: true,
			store: ueSuperDeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//emptyText : '',
			name: 'ueSuperDeptField',
			//暂时为空
			//disabled:true,
			pageSize: 10,
			value:SuperDeptID,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign: 'right',
			items : [uCodeField, uNameField,ueDeptClassField,ueSuperDeptField,eIsdriectField]
		});
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                             
			this.getForm().loadRecord(rowObj[0]);
			uCodeField.setValue(rowObj[0].get("Code"));	
			uNameField.setValue(rowObj[0].get("Name"));	
			//uTypeField.setValue(rowObj[0].get("Type"));
			
			if(rowObj[0].get("IsValid")=="Y"){eIsdriectField.setValue(true);}
			ueDeptClassField.setRawValue(rowObj[0].get("DeptClass"));	
			ueSuperDeptField.setRawValue(rowObj[0].get("SuperDept"));	
    });   
    
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存',
				iconCls: 'save'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");          
				var code = uCodeField.getValue();
				var name = uNameField.getValue(); 
				var deptclass = ueDeptClassField.getValue(); 
				var superdept = ueSuperDeptField.getValue(); 
				//var type = uTypeField.getValue(); 
				var type=""
				//alert(deptclass);
				var IsValid = "";
			    if (Ext.getCmp('eIsdriectField').checked) {IsValid="Y";}
			    else { IsValid="N";}
                
				/*
				var Code=rowObj[0].get("Code")
				var Name=rowObj[0].get("Name")
				var isvalid=rowObj[0].get("IsValid")
				var DeptClass=rowObj[0].get("DeptClass")
				var SuperDept=rowObj[0].get("SuperDept")
				//alert(DeptClass);
				
				if(Code==code){code="";}
				if(Name==name){name="";}
				if(IsValid==isvalid){IsValid="";}
				//if(DeptClass==deptclass){deptclass="";}
				if(SuperDept==superdept){superdept="";}
				if(deptclass=="四级科室"){deptclass=4;}
				if(deptclass=="三级科室"){deptclass=3;}
				if(deptclass=="二级科室"){deptclass=2;}
				if(deptclass=="一级科室"){deptclass=1;}
				//alert(deptclass);
				*/
				if(code=="")
				{
					Ext.Msg.show({title:'错误',msg:'科室代码不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				if(name=="")
				{
					Ext.Msg.show({title:'错误',msg:'科室名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				if(IsValid=="")
				{
					Ext.Msg.show({title:'错误',msg:'请选择数据是否有效',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				};
				
                Ext.Ajax.request({
				url:'herp.srm.srmdeptexe.csp?action=edit&rowid='+rowid+'&code='+encodeURIComponent(code)
				+'&name='+encodeURIComponent(name)+'&type='+type+'&IsValid='+IsValid+'&deptclass='+deptclass+'&superdept='+superdept,
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:25}});		
				}
				else
					{
					var message=jsonData.info;
					if(jsonData.info=='RecordExist') message="记录重复";
					if(jsonData.info=='RepCode') message="编号重复！";
					if(jsonData.info=='RepName') message="名称重复！";
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				};
			},
				scope: this
			});
			editwin.close();
		};
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'关闭',
			iconCls : 'cancel'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title : '修改科室信息',
			iconCls: 'pencil',
			width : 350,
			height : 210,    
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		//窗口显示
		editwin.show();
	};
