var itemGridUrl = '../csp/herp.srm.rewardlevelinfoexe.csp';

//配件数据源

var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'stype',
		'slevel', 
		'stypename',
		'slevelname',
        'IsValid'
	]),
    remoteSort: true
});
var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 18,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,
});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');

//初始化添加按钮
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
	    id:'rowid',
    	header: 'id',
        dataIndex: 'rowid',
        width: 180,		  
        hidden: true,
        sortable: true
	    
    },
    {
	    id:'stype',
	    header:'奖励类别rowid:',
	    dataIndex:'stype',
	    width: 180,
	    hidden: true
	    //sortable:true
	    
	    
	},
	{
	    id:'slevel',
	    header:'奖励项目rowid:',
	    dataIndex:'slevel',
	    width: 100,
	    hidden: true
	    //sortable:true
	    
	    
	},
    {
        id:'stypename',
    	header: '奖励级别',
        dataIndex: 'stypename',
        width: 100
        //sortable: true
    },
    {
        id:'slevelname',
    	header: '奖励项目',
        dataIndex: 'slevelname',
        width: 240
        //sortable: true
    }
   
]);
//初始化默认排序功能
itemGridCm.defaultSortable = true;
var addButton = new Ext.Toolbar.Button({
	text: '新增',
    //tooltip:'增加',        
    iconCls: 'edit_add',
	handler:function(){

      var ClassDs1 = new Ext.data.Store({
	                //autoLoad:true,
	                  proxy:"",
	                  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
                      });


           ClassDs1.on('beforeload', function(ds, o){
	          ds.proxy=new Ext.data.HttpProxy({
	          url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetClass&str='+encodeURIComponent(Ext.getCmp('ClassField1').getRawValue()),method:'POST'});
              });

var ClassField1 = new Ext.form.ComboBox({
	id: 'ClassField1',
	fieldLabel: '奖励类型',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:ClassDs1,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择奖励类型...',
	name: 'ClassField1',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

var PerionDs1 = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});


PerionDs1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('PerionField1').getRawValue()),method:'POST'});
});

var PerionField1 = new Ext.form.ComboBox({
	id: 'PerionField1',
	fieldLabel: '奖励项目',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:PerionDs1,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择奖励项目...',
	name: 'PerionField1',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			labelAlign:'right',
			items: [                              
                                ClassField1,
                                PerionField1			
				//aField
			]
		});
		//aField.setDisabled(true);   
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'保存',
			iconCls: 'save'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
            
			var Class = ClassField1.getValue();
			var Perion = PerionField1.getValue();      
			if(Class==""){
				Ext.Msg.show({title:'错误',msg:'奖励类型不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			
			if(Perion ==""){
		
				Ext.Msg.show({title:'错误',msg:'奖励项目不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}			
			//encodeURI
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.rewardlevelinfoexe.csp?action=add&Class='+Class+'&Perion='+Perion),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){ClassField1.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){ClassField1.focus();};
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						itemGridDs.load({params:{start:0, limit:25}});
						
						//addwin.close();
					}
					else
							{
								var message="重复添加";
								message = "SQLErr: " + jsonData.info;
								if(jsonData.info=='RecordExist') message="输入的记录已经存在!";
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			addwin.close();
		};
	
		//添加保存按钮的监听事件
		addButton.addListener('click',addHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'关闭',
			iconCls : 'cancel'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			addwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		addwin = new Ext.Window({
			title: '新增奖项分类信息',
			iconCls: 'edit_add',
			width: 350,
			height:150,
			minWidth: 350, 
			minHeight: 200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//窗口显示
		addwin.show();
	}	
});



//修改按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls: 'pencil',
	handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
                
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		    var tmpClass=rowObj[0].get("stype");
		    var tmpPerion=rowObj[0].get("slevel");
		}	
		var ClassDs2 = new Ext.data.Store({
	        proxy:"",
	        reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
        });


        ClassDs2.on('beforeload', function(ds, o){
	    ds.proxy=new Ext.data.HttpProxy({
	    url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetClass&str='+encodeURIComponent(Ext.getCmp('ClassField2').getRawValue()),method:'POST'});
        });

         var ClassField2 = new Ext.form.ComboBox({
	     id: 'ClassField2',
	     fieldLabel: '奖励类型',
	     width:200,
	     listWidth : 250,
		//allowBlank: false,
	     store:ClassDs2,
	     valueField: 'code',
	     displayField: 'name',
	     triggerAction: 'all',
	     value:tmpClass,
	     name: 'ClassField2',
	     minChars: 1,
	     pageSize: 10,
	     selectOnFocus:true,
	     forceSelection:'true',
	     editable:true,
	     labelSeparator:''
         });
        ClassField2.on('select',function(combo, record, index){
		    tmpClass = combo.getValue();
		    
		});
		var PerionDs2 = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
		});
		PerionDs2.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
			url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('PerionField2').getRawValue()),method:'POST'});
		});
		
		
		var PerionField2 = new Ext.form.ComboBox({
			id: 'PerionField2',
			fieldLabel: '奖励项目',
			width:200,
			listWidth : 250,
			allowBlank: false,
			store:PerionDs2,
			valueField: 'code',
			displayField: 'name',
			triggerAction: 'all',
		    value:tmpPerion,
			name: 'PerionField2',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:'true',
			forceSelection:'true',
			editable:true,
			labelSeparator:''
		});
		
		PerionField2.on('select',function(combo, record, index){
		    tmpPerion = combo.getValue();
		    //alert(tmpPerion);
			});	

		

		//初始化面板
		formPanel2 = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			labelAlign:'right',
			items: [
                               
                                ClassField2,
                                PerionField2
				               
			]
		});
	
		//面板加载
             
		formPanel2.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
		
			ClassField2.setRawValue(rowObj[0].get("stypename"));	
			PerionField2.setRawValue(rowObj[0].get("slevelname"));
		
		});
		
//定义并初始化保存修改按钮
   var editButton = new Ext.Toolbar.Button({
			text:'保存',
			iconCls: 'save'

		});
	
		//定义修改按钮响应函数
		editHandler = function(){

            var rowObj=itemGrid.getSelectionModel().getSelections();
            var rowid = rowObj[0].get("rowid"); 
            //alert("rowid");
         
			var Class     = ClassField2.getValue();
			var Perion     = PerionField2.getValue();
			
           

		
			if(Class==""){
				Ext.Msg.show({title:'错误',msg:'奖励类型不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(Perion ==""){
				Ext.Msg.show({title:'错误',msg:'奖励项目不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
          
			Ext.Ajax.request({
				url:encodeURI('../csp/herp.srm.rewardlevelinfoexe.csp?action=editd&rowid='+rowid+'&Class='+Class+'&Perion='+Perion),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){activeFlag.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				
				},
				
				success: function(result, request){
				   	var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){ClassField2.focus();};
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
						itemGridDs.load({params:{start:0, limit:25}});
						
					}
					else
						{
							var message="输入的记录已经存在";
							//message = "SQLErr: " + jsonData.info;
							//if(jsonData.info=='RecordExist') message="输入的记录已经存在!";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
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
			title: '修改奖项分类信息',
			iconCls: 'pencil',
			width: 350,
			height:150,
			minWidth: 350, 
			minHeight: 200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel2,
			buttons: [
				editButton,
				cancelButton
			]
		});
	
		//窗口显示
		editwin.show();
	}
});		
//修改按钮

var delButton = new Ext.Toolbar.Button({
	text: '删除',
   // tooltip:'删除',       
    id:'delButton', 
    iconCls: 'edit_remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			//alert(rowid);
		}
		function handler(id){
			if(id=="yes"){
			
				  Ext.each(rowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  itemGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'herp.srm.rewardlevelinfoexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:25}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});


//获取项目奖励 

var PerionDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});


PerionDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('PerionField').getRawValue()),method:'POST'});
});

var PerionField = new Ext.form.ComboBox({
	id: 'PerionField',
	fieldLabel: '奖励项目',
	width:180,
	listWidth : 250,
	//allowBlank: false,
	store:PerionDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择奖励项目...',
	name: 'deptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
//期刊类别
var ClassDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});


ClassDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetClass&str='+encodeURIComponent(Ext.getCmp('ClassField').getRawValue()),method:'POST'});
});

var ClassField = new Ext.form.ComboBox({
	id: 'ClassField',
	fieldLabel: '奖励类型',
	width:180,
	listWidth : 250,
	//allowBlank: false,
	store:ClassDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择奖励类型...',
	name: 'sfasdfafd',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});





var SearchButton = new Ext.Toolbar.Button({
        text: '查询', 
        tooltip:'查询',        
        iconCls: 'search',
	handler:function(){	
        var stype = ClassField.getValue();
        var slevel = PerionField.getValue();
      
    

	itemGridDs.load(({params:{start:0,limit:18,stype:stype,slevel:slevel}}));

	
	}
});
var itemGrid = new Ext.grid.GridPanel({
	title: '奖项分类信息维护',
	iconCls: 'list',
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'local',
    url: 'herp.srm.rewardlevelinfoexe.csp',
    atLoad : true, // 是否自动刷新
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['','奖励类别','',ClassField,'','奖励项目','',PerionField,'-',SearchButton,'-',addButton,'-',editButton,'-',delButton],
	bbar:itemGridPagingToolbar
});
itemGridDs.load({params:{start:0, limit:25}});