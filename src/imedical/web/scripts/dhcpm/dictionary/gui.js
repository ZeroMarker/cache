/*  Desc: 改造原组件界面【字典管理】组件名称：PMP.Dictionary3 
  Author：liubaoshi 
    Date: 2015-04-02
*/
function InitViewport(){
	var obj = new Object();	
	obj.bodyType=new Ext.form.ComboBox({
				id:'bodyType',
				fieldLabel:"字典分类",
				allowBlank:false,
				mode:'local',
				valueNotFoundText : '',
		        editable : true,
				store:new Ext.data.ArrayStore({    //本地数组,不单独解析JsonReader
						fields:['code','desc'],
						data:[['Status','模块状态']
							  ,['Product','产品组']
							  ,['Profession','职称']
							  ,['Emergency','紧急程度']
							  ,['Improvement','需求状态']
							  ,['Type','需求类型']
							  ,['Degree','严重程度']
							  ,['IPMDFlag','审核类型']
							  ,['Communication','沟通方式']
							  ,['CompanyType','公司类型']
							  ,['ProductType','产品分类']
							  ,['Unit','单位']
							  ,['ContractGroup','合同分组']
							  ,['ContractType','合同分类']
							  ,['Currency','币种']
							  ,['ModeExecution','合同履行方式']
							  ,['ConcludeMode','订立方式']
							  ,['Source','合同采购来源']
							  ,['ContractStatus','合同状态']
							  ,['MODEGROUP','模块分组']
							  ,['Level','合同标题级别']
							  ,['Aging','合同分期']
							  ,['AgingStatus','工期状态']
							  ,['DocumentGroup','文档分组']
							  ,['DocumentLevel','文档级别']
							  ,['DocumentStatus','文档状态']
							  ,['PlanType','任务计划类组']
							  ,['PlanStatus','任务计划状态']
							  ,['TreeType','级别树分类']
							  ]
				}),
				displayField:'desc',
				valueField:'code',
				editable:false,
				anchor : '95%',
				triggerAction : 'all'
				//和原有组件效果保持一致,暂时注释监听
				/*
				,listeners:{
					select:function(x,y,curindex){
						var SSObject=Ext.getCmp('gridList');
						SSObject.store.load({params : {start:0,limit:20}});
					}
				}
				*/
					
	});
	obj.bodyCode = new Ext.form.TextField({		
		id : 'bodyCode'
		,allowBlank : false
		,emptyText:'请填写代码...'
		,fieldLabel : "字典编码"         
		,anchor : '95%'
	});
	obj.bodyDesc = new Ext.form.TextField({		
		id : 'bodyDesc'
		,allowBlank : false
		,emptyText:'请填写描述...'
		,fieldLabel : "字典描述"      
		,anchor : '95%'
	});
	obj.bodyNote = new Ext.form.TextField({		
		id : 'bodyNote'
		,allowBlank : true
		,emptyText:'请填写备注...'
		,fieldLabel : "字典备注"     
		,anchor : '95%'   
	});
	obj.btnSave = new Ext.Button({				
		id : 'btnSave'
		,tooltip:'添加新的字典数据'
		,iconCls : 'add'
		,anchor : '30%'
		,text : '添加'
	});
	obj.btnSave1 = new Ext.Button({				
		id : 'btnSave1'
		,tooltip:'添加新的字典数据'
		,iconCls : 'add'
		,anchor : '30%'
		,text : '添加'
	});
	obj.btnDel = new Ext.Button({			
		id : 'btnDel'
		,tooltip:'删除选定的字典数据'
		,iconCls : 'remove'
		,anchor : '30%'
		,text : '删除'
	});
	//右键删除(直接调用原btn,不重新写了)
	/*
	obj.RightbtnDel = new Ext.Button({				
		id : 'RightbtnDel'
		,iconCls : 'remove'
		,anchor : '30%'
		,text : '删除'
	});
	*/
	obj.btnInput = new Ext.Button({				
		id : 'btnInput'
		,tooltip:'导入Excel数据'
		,iconCls : 'accordion'
		,anchor : '30%'
		,text : '导入'
	});
	obj.btnSch = new Ext.Button({				
		id : 'btnSch'
		,tooltip:'查询数据'
		,iconCls : 'option'
		,anchor : '30%'
		,text : '查询'
	});
	obj.btnClear = new Ext.Button({				
		id : 'btnClear'
		,tooltip:'清空查询条件'
		,iconCls : 'option'
		,anchor : '30%'
		,text : '清空'
	});
	obj.btnUpdate = new Ext.Button({				
		id : 'btnUpdate'
		,tooltip:'更新选中的数据'
		,iconCls : 'option'
		,anchor : '30%'
		,text : '更新'
	});
	//更新1
	obj.btnUpdate1 = new Ext.Button({				
		id : 'btnUpdate1'
		,tooltip:'更新选中的数据'
		,iconCls : 'option'
		,anchor : '30%'
		,text : '更新'
	});
	//右键
	obj.RightMenu = new  Ext.menu.Menu({
		items : [

			{
				id : 'Update'
				,iconCls : 'add'
				,text :'更新'
				,handler: function(){obj.btnUpdate1_click();}
			},

			{
				id : 'RightbtnDel'
				,iconCls : 'remove'
				,handler: function(){obj.btnDel_click();}   
				,text :'删除'
					
			}
		]
	});
	//panel-1
	obj.headpanel = new Ext.Panel({				
		id : 'headpanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
							                  
			 obj.bodyCode
			,obj.bodyType
		]
	});
	//panel-2
	obj.Panel2 = new Ext.Panel({			  
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.bodyDesc
		],buttons:[						
			//obj.btnSave,
			//obj.btnDel,
			//obj.btnInput,
			//obj.btnSch
		]
	});
	//panel-3
	obj.Panel3 = new Ext.Panel({			
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.bodyNote
		],buttons:[
		    //obj.btnClear
		]
	});

	obj.fPanel = new Ext.form.FormPanel({	
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,title : '字典维护'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,height : 100
		,collapsible : true               
		,items:[
			obj.headpanel,
			obj.Panel2,
			obj.Panel3
		]
	});
	
	obj.gridListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.gridListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.PMPDictionary';
			param.QueryName = 'SelectDictionary';
			param.Arg1 = Ext.getCmp('bodyType').getValue();
			param.Arg2 = Ext.getCmp('bodyCode').getValue();
			param.Arg3 = Ext.getCmp('bodyDesc').getValue();
			param.Arg4 = Ext.getCmp('bodyNote').getValue();
			param.ArgCnt = 4;
	});
	obj.gridListStore = new Ext.data.Store({
		proxy: obj.gridListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			fields:[
			{
			name: 'DTYCode', 
			mapping: 'DTYCode'
			},
			{
			name: 'DTYDesc', 
			mapping: 'DTYDesc'
			},
			{
			name: 'DTYFlag',
			mapping: 'DTYFlag'
			},
			{
			name: 'DTYRemark', 
			mapping: 'DTYRemark'
			},
			{
			name: 'RowID',
			mapping: 'RowID'
			}
			]
		})
	});
	
	obj.gridListStore.load({params : {start:0,limit:20}});   

	obj.gridList = new Ext.grid.GridPanel({		
		id : 'gridList'
		,buttonAlign : 'center'
		,store : obj.gridListStore
		,loadMask : true
		,region : 'center'
		,viewConfig:{        
			forceFit: true
		}
		,columns: [
			 new Ext.grid.RowNumberer(),
			 {
			 header: '字典编码', 
			 dataIndex: 'DTYCode', 
			 width: 100, 
			 align: 'left',
			 sortable: true
			 },
			 {
			 header: '字典描述',
			 dataIndex: 'DTYDesc', 			 
			 width: 250, 
			 align: 'left',
			 sortable: true
			 },
			 {
			 header: '字典标志',
			 dataIndex:'DTYFlag',
			 width: 100, 
			 align: 'left',
			 sortable: true
			 },
			 {
			 header:'字典备注',
			 dataIndex:'DTYRemark',
			 width: 300,
			 align: 'left',
			 sortable: true
			 },
			 {
			 header:'字典ID',
			 dataIndex:'RowID',
			 width: 150,
			 align: 'left',
			 sortable: true
			 }
		]
		,tbar: [obj.btnSave1,'-',obj.btnUpdate1,'-',obj.btnDel,'-',obj.btnInput,'-',obj.btnSch,'-',obj.btnClear]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.gridListStore,
			displayMsg: '显示记录:{0}-{1},合计:{2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

	});

	obj.Viewport = new Ext.Viewport({	
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.fPanel
			,obj.gridList
		]
	});
	
	InitViewportEvent(obj);	
	obj.btnSave.on("click", obj.btnSave_click, obj);	
	obj.btnDel.on("click", obj.btnDel_click, obj);
	//obj.RightbtnDel.on("click", obj.RightbtnDel_click, obj);
	obj.btnUpdate.on("click", obj.btnUpdate_click, obj)
	obj.btnInput.on("click", obj.btnInput_click, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnClear.on("click", obj.btnClear_click, obj);
	obj.gridList.on("rowcontextmenu", obj.rightClickFn_click, obj);   
	obj.gridList.on("rowdblclick", obj.gridList_rowclick,obj) 
	obj.btnSave1.on("click", obj.btnSave1_click, obj);       
	obj.btnUpdate1.on("click", obj.btnUpdate1_click, obj);  
	obj.bodyCode.on("specialkey", obj.bodyCode_specialkey,obj)  //编码回车事件
	obj.bodyDesc.on("specialkey", obj.bodyDesc_specialkey,obj)  //描述回车事件
	obj.bodyNote.on("specialkey", obj.bodyNote_specialkey,obj)  //备注回车事件
	obj.bodyType.on("specialkey", obj.bodyType_specialkey,obj)  //分类回车事件
	obj.LoadEvent(arguments);
	
  	return obj;
}

function InitwinScreen()
{
	var obj = new Object();
		obj.winbodyType=new Ext.form.ComboBox({
				id:'winbodyType',
				fieldLabel : '<font color="red">字典分类</font>',
				allowBlank:false,
				mode:'local',
				valueNotFoundText : '',
		        editable : true,
				store:new Ext.data.ArrayStore({    //本地数组,不单独解析JsonReader
						fields:['code','desc'],
						data:[['Status','模块状态']
							  ,['Product','产品组']
							  ,['Profession','职称']
							  ,['Emergency','紧急程度']
							  ,['Improvement','需求状态']
							  ,['Type','需求类型']
							  ,['Degree','严重程度']
							  ,['IPMDFlag','审核类型']
							  ,['Communication','沟通方式']
							  ,['CompanyType','公司类型']
							  ,['ProductType','产品分类']
							  ,['Unit','单位']
							  ,['ContractGroup','合同分组']
							  ,['ContractType','合同分类']
							  ,['Currency','币种']
							  ,['ModeExecution','合同履行方式']
							  ,['ConcludeMode','订立方式']
							  ,['Source','合同采购来源']
							  ,['ContractStatus','合同状态']
							  ,['MODEGROUP','模块分组']
							  ,['Level','合同标题级别']
							  ,['Aging','合同分期']
							  ,['AgingStatus','工期状态']
							  ,['DocumentGroup','文档分组']
							  ,['DocumentLevel','文档级别']
							  ,['DocumentStatus','文档状态']
							  ,['PlanType','任务计划类组']
							  ,['PlanStatus','任务计划状态']
							  ,['TreeType','级别树分类']
							  ]
				}),
				displayField:'desc',
				valueField:'code',
				editable:false,
				anchor : '95%',
				triggerAction : 'all'
				//和原有组件效果保持一致,暂时注释监听
				/*
				,listeners:{
					select:function(x,y,curindex){
						var SSObject=Ext.getCmp('gridList');
						SSObject.store.load({params : {start:0,limit:20}});
					}
				}
				*/
					
	});
	obj.winRowid= new Ext.form.TextField({
		id : 'winRowid'
		,width : 40
		,minChars : 1
		,displayField : 'Rowid'
		,fieldLabel : 'Rowid'
		,disabled:true
		//,editable : true
		//,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.winbodyCode = new Ext.form.TextField({		
		id : 'winbodyCode'
		,allowBlank : false
		,emptyText:'请填写代码...'
		,fieldLabel : '<font color="red">字典编码</font>'
		,anchor : '95%'
	});
	obj.winbodyDesc = new Ext.form.TextField({		
		id : 'winbodyDesc'
		,allowBlank : false
		,emptyText:'请填写描述...'
		,fieldLabel : '<font color="red">字典描述</font>'
		,anchor : '95%'
	});
	obj.winbodyNote = new Ext.form.TextField({		
		id : 'winbodyNote'
		,allowBlank : true
		,emptyText:'请填写备注...'
		,fieldLabel : '<font color="red">字典备注</font>'
		,anchor : '95%'
	});	
	obj.winSave = new Ext.Button({
		id : 'winSave'
		,iconCls : 'add'
		,text : '保存'
	});
	obj.winCancel = new Ext.Button({
		id : 'winCancel'
		,iconCls : 'remove'
		,text : '取消'
	});
	obj.windictionarypanel = new Ext.Panel({
		id : 'windictionarypanel'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		//,margins : '{3,0,0,0}'
		//,height:'80%'
		//,title : '字典'
		,layout : 'form'
		,region : 'center'
		,labelWidth:80
		,frame : true
		,items:[
			obj.winRowid
		    ,obj.winbodyType
			,obj.winbodyCode
			,obj.winbodyDesc 
			,obj.winbodyNote 
		]
	});
	obj.windictionary = new Ext.Window({
		id : 'windictionary'
		,height : 300
		,buttonAlign : 'center'
		,width : 350
		,modal : true
		,title : '字典数据维护'
		,layout : 'border'
		,border:true
		,items:[
			   obj.windictionarypanel
		]
		,buttons:[
			   obj.winSave
			  ,obj.winCancel
		]
	});

	//事件处理
	InitwinScreenEvent(obj);
	obj.winSave.on("click",obj.winSave_click,obj);
	obj.winCancel.on("click",obj.winCancel_click,obj);
	obj.LoadEvent(arguments);
    
	return obj;

}
