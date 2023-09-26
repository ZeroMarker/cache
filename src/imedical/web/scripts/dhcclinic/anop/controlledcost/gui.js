function InitViewScreen(){
	var _DHCANOPControlledCost=ExtTool.StaticServerObject('web.DHCANOPControlledCost');
    var obj=new Object();
    //病人姓名
    obj.txtPatname=new Ext.form.TextField({
	    id:'txtPatname'
	    ,fieldLabel:'姓名'
	    ,labelSeparator: ''
	    ,anchor:'98%'
    });
    //性别
    obj.txtPatSex=new Ext.form.TextField({
	    id:'txtPatSex'
	    ,fieldLabel:'性别'
	     ,labelSeparator: ''
	    ,anchor:'98%'
    });
    //年龄
    obj.txtPatAge=new Ext.form.TextField({
	    id:'txtPatAge'
	    ,fieldLabel:'年龄'
	     ,labelSeparator: ''
	    ,anchor:'90%'
    });
    //病区
    obj.txtPatWard=new Ext.form.TextField({
	    id:'txtPatWard'
	    ,fieldLabel:'病区'
	     ,labelSeparator: ''
	    ,anchor:'95%'
    });
    //床号
    obj.txtPatBedNo=new Ext.form.TextField({
	    id:'txtPatBedNo'
	    ,fieldLabel:'床号'
	     ,labelSeparator: ''
	    ,anchor:'95%'
    });
    //住院号
    obj.txtMedCareNo=new Ext.form.TextField({
	    id:'txtMedCareNo'
	    ,fieldLabel:'住院号'
	    ,labelSeparator: ''
	    ,anchor:'95%'
    });
    obj.Panel11=new Ext.Panel({
	    id:'Panel11'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:40
	    ,columnWidth:.12
	    ,layout:'form'
	    ,items:[
	        obj.txtPatname
	    ]
    });
    obj.Panel12=new Ext.Panel({
	    id:'Panel12'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:40
	    ,columnWidth:.07
	    ,layout:'form'
	    ,items:[
	        obj.txtPatSex
	    ]
    });
    obj.Panel13=new Ext.Panel({
	    id:'Panel13'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:40
	    ,columnWidth:.1
	    ,layout:'form'
	    ,items:[
	        obj.txtPatAge
	    ]
    });
    obj.Panel14=new Ext.Panel({
	    id:'Panel14'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:50
	    ,columnWidth:.2
	    ,layout:'form'
	    ,items:[
	        obj.txtPatWard
	    ]
    });
    obj.Panel15=new Ext.Panel({
	    id:'Panel15'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:40
	    ,columnWidth:.1
	    ,layout:'form'
	    ,items:[
	        obj.txtPatBedNo
	    ]
    });
	obj.Panel16=new Ext.Panel({
		id:'Panel16'
		,buttonAlign:'center'
		,labelAlign:'right'
		,labelWidth:60
		,columnWidth:.15
		,layout:'form'
		,items:[
		    obj. txtMedCareNo
		]
	});
	//手术名称
	obj.patOpNameStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url:ExtToolSetting.RunQueryPageURL
	}));
	obj.patOpNameStore=new Ext.data.Store({
		proxy:obj.patOpNameStoreProxy
		,reader:new Ext.data.JsonReader({
			root:'record'
			,totalProperty:'total'
			,idProperty:'rowid'
		},
		[
		     {name:'OPTypeDes',mapping:'OPTypeDes'}
			,{name:'rowid',mapping:'rowid'}
			,{name:'OPCategory',mapping:'OPCategory'}
		])
	});
	obj.patOpName=new Ext.form.ComboBox({
		id:'patOpName'
		,store:obj.patOpNameStore
		,minChars:1
		,value:''
		,displayField:'OPTypeDes'
		,fieldLabel:'<span style="color:red;">*</span>手术名称'
		,labelSeparator: ''
		,valueField:'rowid'
		,triggerAction:'all'
		,anchor:'98%'
	});
	obj.patOpNameStoreProxy.on('beforeload',function(objProxy,param){
		param.ClassName='web.UDHCANOPArrange';
		param.QueryName='FindOrcOperation';
		param.Arg1=obj.patOpName.getRawValue();
		param.Arg2=obj.opDoc.getValue;
		param.ArgCnt=2;
	});
	
	obj.Panel107=new Ext.Panel({
	    id:'Panel107'
	    ,buttonAlign:'center'
	    ,labelWidth:80
	    ,columnWidth:.25
	    ,layout:'form'
	    ,items:[
	        obj.patOpName
	    ]
    });
    
	obj.admInfPanel=new Ext.form.FormPanel({
		id:'admInfPanel'
		,buttonAlign:'center'
		,labelWidth:80
		,title:'<span style=\'font-size:14px;\'>手术可控成本管理</span>'
		,iconCls:'icon-costcontrol'
		,labelAlign:'center'
		,collapsible:true
		,region:'north'
		,layout:'column'
		,height:65
		,frame:true
		,items:[
		     obj.Panel11
		    ,obj.Panel12
		    ,obj.Panel13
		    ,obj.Panel14
		    ,obj.Panel15
		    ,obj.Panel16
		     ,obj.Panel107
		 ]
	});
	
	obj.articleStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.articleStore = new Ext.data.Store({
	    proxy : obj.articleStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'inclb'
		},
		[
		    {name:'incidesc',mapping:'incidesc'}
			,{name:'inclb',mapping:'inclb'}
		])
	
	});
	obj.article = new Ext.form.ComboBox({
	    id : 'article'
		,store : obj.articleStore
		,minChars : 1
		,value : ''
		,displayField : 'incidesc'
		,fieldLabel : '<span style="color:red;">*</span>物品'
		,labelSeparator: ''
		,valueField : 'inclb'
		,triggerAction : 'all'
		,anchor : '80%'
	});
	obj.articleStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPControlledCost';
		    param.QueryName = 'QueryInci';
		    param.Arg1 = obj.article.getRawValue();
		    param.Arg2 = session['LOGON.CTLOCID'];
	    	param.ArgCnt = 2;
	    });
	
	obj.univalent = new Ext.form.TextField({
	    id : 'univalent'
		,fieldLabel : '<span style="color:red;">*</span>单价'
		,labelSeparator: ''
		,anchor : '70%'
		,listeners: {  
                            'blur': function(f){ 
                            if ((f.getValue()!="")&(obj.amount.getValue()!=""))
                            { 
                                if(obj.unit.getValue()!="")
                                {
                                    obj.total.setValue(_DHCANOPControlledCost.GetTotalCost(obj.unit.getValue(),obj.amount.getValue(), f.getValue()));
                                }
                                else
                                {
	                                obj.total.setValue(_DHCANOPControlledCost.GetTotalCost(1,obj.amount.getValue(), f.getValue()));
                                }
                            } 
                         } 
                         ,specialkey: function(field,e){    
                        if (e.getKey()==Ext.EventObject.ENTER){    
                            obj.total.setValue(_DHCANOPControlledCost.GetTotalCost(1,obj.amount.getValue(), field.getValue())); 
                        }   
                         }
                     }
	});

	 obj.Panel17=new Ext.Panel({
	    id:'Panel17'
	    ,buttonAlign:'center'
	    ,columnWidth:.15
	    ,layout:'form'
	    ,items:[
	    obj.article
	    ]
    });
	obj.Panel18=new Ext.Panel({
		id:'Panel18'
		,buttonAlign:'center'
		,labelAlign:'right'
		,columnWidth:.1
		,layout:'form'
		,items:[
		    obj.univalent
		]
	});
	
	obj.unit = new Ext.form.TextField({
	    id : 'unit'
		,fieldLabel : '<span style="color:red;">*</span>单位'
		,labelSeparator: ''
		,anchor : '70%'
		,listeners: {  
                            'blur': function(f){ 
                            if ((obj.univalent.getValue()!="")&(obj.amount.getValue()!=""))
                            { 
                                if(f.getValue()!="")
                                {
                                    obj.total.setValue(_DHCANOPControlledCost.GetTotalCost(f.getValue(),obj.amount.getValue(), obj.univalent.getValue()));
                                }
                                else
                                {
	                                 obj.total.setValue(_DHCANOPControlledCost.GetTotalCost(1,obj.amount.getValue(), obj.univalent.getValue())); 
                                }
                            } 
                         }  
                     }
	});
	 obj.Panel19=new Ext.Panel({
	    id:'Panel19'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,columnWidth:.1
	    ,layout:'form'
	    ,items:[
	    obj.unit
	    ]
    });
    obj.amount = new Ext.form.TextField({
	    id : 'amount'
		,fieldLabel : '数量'
		,labelSeparator: ''
		,anchor :'70%'
		,listeners: {  
                            'blur': function(f){ 
                            if ((f.getValue()!="")&(obj.univalent.getValue()!=""))
                            { 
                                if(obj.unit.getValue()!="")
                                {
                                    obj.total.setValue(_DHCANOPControlledCost.GetTotalCost(obj.unit.getValue(),f.getValue(), obj.univalent.getValue()));
                                }
                                else
                                {
	                                obj.total.setValue(_DHCANOPControlledCost.GetTotalCost(1,f.getValue(), obj.univalent.getValue()));
                                }
                            } 
                         }  
                         ,specialkey: function(field,e){    
                        if (e.getKey()==Ext.EventObject.ENTER){    
                            obj.total.setValue(_DHCANOPControlledCost.GetTotalCost(1,field.getValue(), obj.univalent.getValue())); 
                        }  
                    }  
		}
                    
	});
	obj.Panel20 = new Ext.Panel({
	    id : 'Panel20'
		,buttonAlign : 'center'
		,labelAlign:'right'
		,columnWidth : .1
		,layout : 'form'
		,items : [
			obj.amount
		]
	});
	
	obj.total = new Ext.form.TextField({
	    id : 'total'
		,fieldLabel : '总计'
		,labelSeparator: ''
		,anchor :'80%'
	});
	obj.Panel21 = new Ext.Panel({
	    id : 'Panel21'
		,buttonAlign : 'center'
		,labelAlign:'right'
		,columnWidth : .1
		,layout : 'form'
		,items : [
			obj.total
		]
	});
	
	obj.btnAdd = new Ext.Button({
	    id : 'btnAdd'
		,text : '增加'
		,width:65
		,iconCls : 'icon-add'
		,anchor :'95%'
	});
	obj.btnUpdate = new Ext.Button({
	    id : 'btnUpdate'
		,text : '修改'
		,width:65
		,iconCls : 'icon-updateSmall'
		,anchor :'95%'
	});
	obj.btnDelete = new Ext.Button({
	    id : 'btnDelete'
		,text : '删除'
		,width:65
		,iconCls : 'icon-delete'
		,anchor :'95%'
	});
	obj.Panel217 = new Ext.Panel({
	    id : 'Panel217'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,style:'margin-left:10px'
		,items : [
			obj.btnAdd
		]
	});
	obj.Panel218 = new Ext.Panel({
	    id : 'Panel218'
		,buttonAlign : 'center'
		,columnWidth : .1
		,style:'margin-left:10px'
		,layout : 'form'
		,items : [
			obj.btnUpdate
		]
	});
	obj.Panel219 = new Ext.Panel({
	    id : 'Panel219'
		,buttonAlign : 'center'
		,columnWidth : .1
		,style:'margin-left:10px'
		,layout : 'form'
		,items : [
			obj.btnDelete
		]
	});
	
	
	
		obj.fPanel1=new Ext.Panel({
		id:'fPanel1'
		,buttonAlign:'center'
		,labelAlign:'right'
		,labelWidth:40
		,layout:'column'
		,items:[
		    obj.Panel17
		    ,obj.Panel18
		    ,obj.Panel19
		    ,obj.Panel20
		    ,obj.Panel21
		    ,obj.Panel217
			,obj.Panel218
			,obj.Panel219
		]
	});

	obj.OpaId = new Ext.form.TextField({
		id : 'OpaId'
	});
	obj.preOPPanel=new Ext.form.FormPanel({
		id:'preOPPanel'
		,buttonAlign:'center'
		,labelWidth:80
		,title:'<span style=\'font-size:14px;\'>可控成本管理——编辑</span>'
		,iconCls:'icon-costcontroledit'
		,labelAlign:'center'
		,region:'center'
		,collapsible:true
		//,height:60
		,frame:true
		,items:[
		     obj.fPanel1
		 ]
	});
	
	obj.gdarticleStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gdarticleStore = new Ext.data.Store({
		proxy: obj.gdarticleStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'inclb'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'inclb', mapping: 'inclb'}
			,{name: 'incidesc', mapping: 'incidesc'}
		])
	});
	
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'articleId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'articleId', mapping: 'articleId'}
			,{name: 'tArticle', mapping: 'tArticle'}
			,{name: 'tUnivalent', mapping: 'tUnivalent'}
			,{name: 'tUnit',mapping: 'tUnit'} //wwl
			,{name: 'tAmount',mapping: 'tAmount'}     //wwl
			,{name: 'tTotal', mapping: 'tTotal'}
			,{name: 'opaId', mapping: 'opaId'}
			
		])
	});
	obj.retGridPanelCheckCol = new Ext.grid.CheckColumn({
		header:'选择', 
		dataIndex: 'checked', 
		width: 40
	});
	
	obj.csm=new Ext.grid.CheckboxSelectionModel({
	 header:''
	 })
	 
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,obj.csm
			
		,{header: '物品'
		, width: 210
		, dataIndex: 'tArticle'
		, sortable: true
		}
		,{header: '单价'
		, width: 110
		, dataIndex: 'tUnivalent'
		, sortable: true
		}
		,{header: '单位'
		, width: 110
		, dataIndex: 'tUnit'
		, sortable: true
		}
		,{header: '数量'
		, width: 110
		, dataIndex: 'tAmount'
		, sortable: true
		
		}
		,{header: '总计'
		, width: 110
		, dataIndex: 'tTotal'
		, sortable: true
		}
		,{header: 'opaId'
		, width: 110
		, dataIndex: 'opaId'
		, sortable: true
		,hidden:true
		}
		]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,height:400
		,cm:cm
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,plugins : obj.retGridPanelCheckCol
	});
		obj.resultPanel=new Ext.form.FormPanel({
		id:'resultPanel'
		,buttonAlign:'center'
		,labelWidth:80
		,title:'<span style=\'font-size:14px;\'>可控成本管理——耗材列表</span>'
		,iconCls:'icon-costControlList'
		,collapsible:true
		,labelAlign:'center'
		,region:'south'
		,height:450
		,frame:true
		,items:[
		    obj.retGridPanel
		 ]
	});
	obj.ArticleId = new Ext.form.TextField({
		id : 'ArticleId'
	});   
	
	
	obj.ViewScreen=new Ext.Viewport({
		id:'ViewScreen'
		,autoScroll:true
		,layout:'border'
		,items:[
		    obj.admInfPanel
		    ,obj.preOPPanel
		    ,obj.resultPanel
		]
	});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPControlledCost';
		    param.QueryName = 'FindArticleInfoList';
			param.Arg1 =opaId;
	    	param.ArgCnt = 1;
	    });
	obj.retGridPanelStore.load({});
	obj.gdarticleStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPControlledCost';
		param.QueryName = 'QueryInci';
		param.Arg1 = '';
		param.Arg2 = 136;
		
		param.ArgCnt = 2;
	});
	obj.gdarticleStore.load();
	
	InitViewScreenEvent(obj);

	obj.article.on('select',obj.article_select,obj);
	obj.amount.on('keypress',obj.amount_enter,obj);
	obj.btnAdd.on('click',obj.btnAdd_click,obj);
	obj.btnUpdate.on('click',obj.btnUpdate_click,obj);
	obj.retGridPanel.on('rowclick',obj.retGridPanel_rowclick, obj)
	obj.btnDelete.on('click',obj.btnDelete_click,obj);
	
	//obj.retGridPanel.on("beforeedit",obj.retGridPanel_beforeedit,obj);
	//obj.retGridPanel.on("validateedit",obj.retGridPanel_validateedit,obj);
	//obj.retGridPanel.on("afteredit",obj.retGridPanel_afteredit,obj);
	
	//obj.btnSave.on('click',obj.btnSave_click,obj)
	//obj.btnClose.on('click',obj.btnClose_click,obj)
	//obj.btnPrint.on('click',obj.btnPrint_click,obj)
	obj.LoadEvent(arguments);
	return obj;
}