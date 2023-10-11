

srmmonographAddFun = function() {
	var NameField = new Ext.form.TextField({
		id: 'Name',
		fieldLabel: '专著名称',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'Name',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	//获取科室名称
	var unitdeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	unitdeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.monographinfoexe.csp'
		                     + '?action=deptList&str='
		                     + encodeURIComponent(Ext.getCmp('unitdeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var unitdeptField = new Ext.form.ComboBox({
			id: 'unitdeptField',
			fieldLabel: '科室名称',
			width:200,
			listWidth : 220,
			allowBlank: false,
			store: unitdeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '请选择科室姓名...',
			name: 'unitdeptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
	});

//作者

	var unituserDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
     });
     
	unituserDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url : 'herp.srm.monographinfoexe.csp'
		         +'?action=userList&str='
		         +encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),
		         method:'POST'
		       });
	});

	var unituserField = new Ext.ux.form.LovCombo({
			id: 'unituserField',
			fieldLabel: '作者',
			width:200,
			listWidth :220,
			//allowBlank: false,
			store: unituserDs,
			valueField: 'rowid',
			hideOnSelect:false,

			displayField: 'name',
			triggerAction: 'all',
			emptyText:'请选择人员姓名...',
			name: 'unituserField',
			minChars: 1,
			pageSize: 10
			//selectOnFocus:true,
			//hideOnSelect:false ,
		//	forceSelection:'true',
		//	editable:false
	});
	
	var TotalNum = new Ext.form.NumberField({
		id: 'TotalNum',
		fieldLabel: '总字数（千字）',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'TotalNum',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
var PressDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])
});


PressDs.on('beforeload', function(ds, o){

	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'herp.srm.monographinfoexe.csp'
	                     + '?action=deptList&str='
	                     + encodeURIComponent(Ext.getCmp('PressField').getRawValue()),
	               method:'POST'
	              });
	});

var PressField = new Ext.form.ComboBox({
		id: 'PressField',
		fieldLabel: '出版社',
		width:200,
		listWidth : 220,
		allowBlank: false,
		store: PressDs,
		displayField: 'name',
		valueField: 'rowid',
		triggerAction: 'all',
		typeAhead : true,
		triggerAction : 'all',
		emptyText : '请选择出版社...',
		name: 'PressField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true
});
	var PubTime = new Ext.form.DateField({
		id : 'PubTime',
		fieldLabel:'出版日期',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});
	
	var ISBN = new Ext.form.TextField({
		id: 'ISBN',
		fieldLabel: 'ISBN号',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'ISBN',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var PublishFreqField = new Ext.form.NumberField({
		id: 'PublishFreq',
		fieldLabel: '出版版次',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'TotalNum',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [NameField,unitdeptField,unituserField,TotalNum,PressField,PubTime,ISBN,PublishFreqField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '添加',
			width : 400,
			height : 420,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '保存',
				handler : function() {
					if (formPanel.form.isValid()) {
						var name = NameField.getValue();
						var deptdr = unitdeptField.getValue();
						var editor = unituserField.getValue();
						var totalnum = TotalNum.getValue();
						var press = PressField.getValue();
						var pubtime = PubTime.getValue();
						var isbn = ISBN.getValue();
						var publishfreq = PublishFreqField.getValue();
						if (pubtime!==""){
							//pubtime=pubtime.format ('Y-m-d');
						}
						
//					if(idnum!=""){
//						if (!/(^\d{18}$)|(^\d{17}(\d|X)$)/.test(idnum)){Ext.Msg.show({title:'错误',msg:'身份证号格式不正确!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
//						}
//					    if(phone!=""){
//						if (!/[0-9]/.test(phone)){Ext.Msg.show({title:'错误',msg:'电话号码只能位数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
//					    }
				Ext.Ajax.request({
					url:'herp.srm.monographinfoexe.csp?action=add&name='+encodeURIComponent(name)+'&deptdr='+encodeURIComponent(deptdr)+'&editor='+encodeURIComponent(editor)+'&totalnum='+encodeURIComponent(totalnum)+'&press='+encodeURIComponent(press)+'&pubtime='+encodeURIComponent(pubtime)+'&isbn='+encodeURIComponent(isbn)+'&publishfreq='+publishfreq+'&subuser='+userdr,
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,userdr:userdr}});
						} 
						else
						{
							var message="重复添加";
							if(jsonData.info=='RepName') message="著作名称重复！";
							if(jsonData.info=='RepISDN') message="ISDN重复！";
							
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '取消',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
