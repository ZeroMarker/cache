

srmMonographEditFun = function(IsSigDept,MonTra) {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
    var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
    if(rowObj[0].get("DataStatus")=="提交")
	 {
		      Ext.Msg.show({title:'注意',msg:'已提交记录无法修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{			
		var tmpEditorDr =rowObj[0].get("EditorName");
		var tmpDeptDr="";		
		var PressDr="";
	}
	

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
			selectOnFocus:true

	});
	unitdeptField.on('select',function(combo, record, index){
	       tmpDeptDr = combo.getValue();
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
	
	var TotalNum = new Ext.form.TextField({
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
PressField.on('select',function(combo, record, index){

	//console.log("this is combo "+combo.displayField);
	PressDr = combo.getValue();
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
	});			                                                                                            //
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
    	 var rowObj=itemGrid.getSelectionModel().getSelections();    
    	 ////'rowid','Name','DeptDr','IsSigDept','Editor','MonTra','TotalNum','WriteWords','Press','PubTime','PriTime','ISBN','SubUser','SubDate','DataStatus','SysNo','ChkResult'
			this.getForm().loadRecord(rowObj[0]);
			NameField.setValue(rowObj[0].get("Name"));
			unitdeptField.setValue(rowObj[0].get("DeptName"));
			unituserField.setRawValue(rowObj[0].get("EditorName"));
            TotalNum.setValue(rowObj[0].get("TotalNum"));
			PressField.setValue(rowObj[0].get("PressName"));
			PubTime.setValue(rowObj[0].get("PubTime"));
			ISBN.setValue(rowObj[0].get("ISBN"));
			PublishFreqField.setValue(rowObj[0].get("PublishFreq"));
   });   

	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
			    	var rowObj=itemGrid.getSelectionModel().getSelections();
					//定义并初始化行对象长度变量
					
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");     

		        var name = NameField.getValue();
				var deptdr = tmpDeptDr;
				var editor = unituserField.getValue();
				var totalnum = TotalNum.getValue();
				var press = PressDr;
				var pubtime = PubTime.getValue();
				var isbn = ISBN.getValue();
				var publishfreq=PublishFreqField.getValue();
				if (pubtime!==""){
					//pubtime=pubtime.format ('Y-m-d');
				}
                Ext.Ajax.request({
				url:'herp.srm.monographinfoexe.csp?action=edit&rowid='+rowid+'&name='+encodeURIComponent(name)+'&deptdr='+encodeURIComponent(deptdr)+'&editor='+encodeURIComponent(editor)+'&totalnum='+encodeURIComponent(totalnum)+'&press='+encodeURIComponent(press)+'&pubtime='+encodeURIComponent(pubtime)+'&isbn='+encodeURIComponent(isbn)+'&publishfreq='+encodeURIComponent(publishfreq),
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,userdr:userdr}});		
				}
				else
					{
					var message="重复添加";
					if(jsonData.info=='RepISBN') message="ISBN号重复！";
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
			text:'取消'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改记录',
			width : 400,
			height : 420,    
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
		
		//MontraField.focus();
		
		
	//	unituserField.statesave();
		
//		var unituserDs = new Ext.data.Store({
//			autoLoad : true,
//			proxy : "",
//			reader : new Ext.data.JsonReader({
//			           totalProperty:'results',
//			           root:'rows'
//			       },['rowid','name'])
//     });
		
//		for(p in unituserDs.reader.root){
//			
//			console.log("unituserDs"+p);
//		}
//		
//		console.log("expand"+unituserField.expand());
	};
