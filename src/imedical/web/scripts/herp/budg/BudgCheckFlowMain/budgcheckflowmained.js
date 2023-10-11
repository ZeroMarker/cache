var itemGridUrl = '../csp/herp.budg.budgcheckflowmainexe.csp';
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var hospid = session['LOGON.HOSPID'];
//配件数据源

var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid','CompDR','CompName','code','name','sysno','sysid'
	]),
    remoteSort: true
});

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 15,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');

var sysStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['2','预算编制'],['1','项目支出'],['3','一般支出']]
});
var syscomb = new Ext.form.ComboBox({
	id: 'sysno',
	fieldLabel: '应用系统',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: sysStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});

//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
	    id:'rowid',
    	header: 'id',
        dataIndex: 'rowid',
        width: 150,		  
        hidden: true,
        sortable: true
	    
    },{ 
        id:'code',
    	header: '编码',
        dataIndex: 'code',
        width: 50,		  
        sortable: true
    },{ 
        id:'CompDR',
    	header: '医疗ID',
        dataIndex: 'CompDR',
        width: 50,
        hidden: true,		  
        sortable: true
    },{ 
        id:'CompName',
    	header: '医疗单位',
        dataIndex: 'CompName',
        width: 150,		  
        sortable: true
    },{
        id:'name',
    	header: '名称',
        dataIndex: 'name',
        width: 150,
        sortable: true
    },{           
         id:'sysn0',
         header: '审批流应用系统',
         allowBlank: false,
         width:150,
         dataIndex: 'sysno',
         type: syscomb
    
    },{           
         id:'sysid',
         header: '审批流',
         allowBlank: true,
         width:50,
         dataIndex:'sysid',
         hidden:true
    
    }
    
]);



//初始化默认排序功能
itemGridCm.defaultSortable = true;


//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){

		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '编号',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'编号...',
			anchor: '90%',
			selectOnFocus:'true',
			
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!==""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();};
							Ext.Msg.show({title:'错误',msg:'编号不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'名称...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nField.getValue()!==""){
							aField.focus();
						}else{
							Handler = function(){nField.focus();};
							Ext.Msg.show({title:'错误',msg:'名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
	var aFieldStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['2','预算编制'],['1','项目支出'],['3','一般支出']]
	});
	var aField = new Ext.form.ComboBox({
		id: 'aField',
		fieldLabel: '应用系统',
		//listWidth : 130,
		selectOnFocus: true,
		allowBlank: false,
		store: aFieldStore,
		anchor: '90%',
		value:1, //默认值
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'系统...',
		mode: 'local', //本地模式
		editable:false,
		selectOnFocus: true,
		forceSelection: true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
	});
	
	var AddCompDRDs = new Ext.data.Store({
						proxy : "",
						url : commonboxURL+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

	AddCompDRDs.on('load', function() {

						var Num=AddCompDRDs.getCount();
    					if (Num!=0){
						var id=AddCompDRDs.getAt(0).get('rowid');
						AddCompDRCombo.setValue(id);  
    					} 
					});
	var AddCompDRCombo = new Ext.form.ComboBox({
		id : 'AddCompDRCombo',
		name : 'AddCompDRCombo',
		fieldLabel : '医疗单位',
		store : AddCompDRDs,
		displayField : 'name',
		valueField : 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		emptyText : '',
		width : 70,
		listWidth : 300,
		pageSize : 10,
		minChars : 1,
		anchor: '90%',
		selectOnFocus : true
		});			

		//初始化面板
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				cField,
				AddCompDRCombo,
				nField,
				aField
			]
		});
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
            //alert("wwww")
			var code = cField.getValue();
			var CompDR = AddCompDRCombo.getValue()
			var name = nField.getValue();
			var sysno = aField.getValue();

			if(code==""){
				Ext.Msg.show({title:'错误',msg:'编码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(CompDR==""){
      			Ext.Msg.show({title:'错误',msg:'医疗单位为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			//alert(sysno);
			if(sysno==""){
			//alert(sysno);
				Ext.Msg.show({title:'错误',msg:'系统为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			
			//alert(CompDR)
			//encodeURI
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.budg.budgcheckflowmainexe.csp?action=add&code='+code+'&CompDR='+CompDR+'&name='+name+'&sysno='+sysno),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){aField.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){aField.focus();};
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						//addwin.close();
					}
					else
							{
								var message="";

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
			width: 400,
			height:200,
			minWidth: 400, 
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
    iconCls: 'option',
	handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		var CompDR=rowObj[0].get("CompDR");
		var CompName=rowObj[0].get("CompName");
		//alert(CompDR)
		//alert(CompName)
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var sysid = rowObj[0].get("sysid");
		}
	
	
		var c1Field = new Ext.form.TextField({
			id:'c1Field',
			fieldLabel: '编码',
			allowBlank: false,
			width:180,
			listWidth : 180,
			valueNotFoundText:rowObj[0].get("code"),
			emptyText:'编码...',
			anchor: '90%',
			selectOnFocus:'true',
			
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(c1Field.getValue()!==""){
							n1Field.focus();
						}else{
							Handler = function(){c1Field.focus();};
							Ext.Msg.show({title:'错误',msg:'编码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var n1Field = new Ext.form.TextField({
			id:'n1Field',
			fieldLabel: '名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			valueNotFoundText:rowObj[0].get("name"),
			emptyText:'名称...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(n1Field.getValue()!==""){
							a1Field.focus();
						}else{
							Handler = function(){n1Field.focus();};
							Ext.Msg.show({title:'错误',msg:'名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
	var a1FieldStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['2','预算编制'],['1','项目支出'],['3','一般支出']]
	});
	var a1Field = new Ext.form.ComboBox({
		id: 'aField',
		fieldLabel: '应用系统',
		//listWidth : 130,
		selectOnFocus: true,
		allowBlank: false,
		store: a1FieldStore,
		anchor: '90%',
		value:sysid, //默认值
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'系统...',
		mode: 'local', //本地模式
		editable:false,
		selectOnFocus: true,
		forceSelection: true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
	});
	
	var EditCompDRDs = new Ext.data.Store({
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			EditCompDRDs.on('beforeload', function(ds, o) {

						ds.proxy = new Ext.data.HttpProxy({
									url : commonboxURL+'?action=hospital&rowid='+hospid+'',
									method : 'POST'
								});
					});

			var EditCompDRCombo = new Ext.form.ComboBox({
						fieldLabel : '医疗单位',
						store : EditCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						valueNotFoundText:CompName,
						width : 70,
						listWidth : 300,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});	
		EditCompDRCombo.setValue(CompDR);		

				
		//定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				c1Field,
				EditCompDRCombo,
				n1Field,
				a1Field
			]
		});
	
		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			c1Field.setValue(rowObj[0].get("code"));
			n1Field.setValue(rowObj[0].get("name"));	
			//a1Field.setValue(rowObj[0].get("sysno"));
			//alert(sysno);
		});
		
//定义并初始化保存修改按钮
   var editButton = new Ext.Toolbar.Button({
			text:'保存修改'

		});
	
		//定义修改按钮响应函数
		editHandler = function(){

            var rowObj=itemGrid.getSelectionModel().getSelections();
            var rowid = rowObj[0].get("rowid");
            var compdr= EditCompDRCombo.getValue();          
			var code = c1Field.getValue();
			var name = n1Field.getValue();
			var sysno = a1Field.getValue();
			//alert(sysno);
			if(code===""){
				Ext.Msg.show({title:'错误',msg:'编码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(compdr==""){
      			Ext.Msg.show({title:'错误',msg:'医疗单位为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(name===""){
				Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(sysno===""){
				Ext.Msg.show({title:'错误',msg:'系统为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.budg.budgcheckflowmainexe.csp?action=editd&rowid='+rowid+'&CompDR='+compdr+'&code='+code+'&name='+name+'&sysno='+sysno),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){activeFlag.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				
				},
				
				success: function(result, request){
				   	var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){a1Field.focus();};
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						
					}
					else
						{
							var message="";
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
			text:'取消修改'
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
			width: 400,
			height:250,
			minWidth: 400, 
			minHeight: 250,
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
	}
});


///删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',
   // tooltip:'删除',       
    id:'delButton', 
    iconCls:'remove',
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
						url:'herp.budg.budgcheckflowmainexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								detailGrid.load({params:{start:0, limit:20,checkmainid:rowid}});
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


//表格
var itemGrid = new Ext.grid.GridPanel({
	title: '审批流',
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'local',
    url: 'herp.budg.budgcheckflowmainexe.csp',
    atLoad : true, // 是否自动刷新
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:itemGridPagingToolbar
});
//itemGridDs.load({params:{start:0, limit:25}});



  itemGridDs.load({	
	params:{start:0, limit:itemGridPagingToolbar.pageSize},
    callback:function(record,options,success ){
	itemGrid.fireEvent('rowclick',this,0);
	}
});
	
itemGrid.on('rowclick',function(grid,rowIndex,e){
	
	//var object = itemGrid.getSelectionModel().getSelections();
	//var rowid = object[0].get("rowid");
	
	var selectedRow = itemGridDs.data.items[rowIndex];

	rowid=selectedRow.data['rowid'];
	
      // alert(rowid);
	detailGrid.load({params:{start:0,limit:12,checkmainid:rowid}});
	
});

	

