//GY 20170307
function InitViewScreen(){
	var obj = new Object();
	
 	obj.ctlocdescstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ctlocdescstore = new Ext.data.Store({
		proxy: obj.ctlocdescstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
		     {name: 'ctlocId', mapping: 'ctlocId'}
			,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
			,{name: 'ctlocCode', mapping: 'ctlocCode'}
		])
	});	
	obj.ctlocdesc = new Ext.form.ComboBox({
		id : 'ctlocdesc'
		,store:obj.ctlocdescstore
		,minChars:1	
		,displayField:'ctlocDesc'	
		,fieldLabel : '科室'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	}); 	
	
	obj.ctlocdescstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1=obj.ctlocdesc.getValue();
		param.Arg2="";
		param.Arg3="";
		param.ArgCnt = 3;
	});
	obj.ctlocdescstore.load({});
	  	
   	obj.Paneltemp1 = new Ext.Panel({
		id : 'Paneltemp1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.ctlocdesc	
		]
	});

	obj.tempname = new Ext.form.TextField({
		id : 'tempname'
		,fieldLabel : '模板名称'
		,labelSeparator: ''
		,anchor : '95%'
	});		
	 
	obj.tempid = new Ext.form.TextField({
		id : 'tempid'
		,hidden : true
    });	
    			
	obj.Paneltemp2 = new Ext.Panel({
		id : 'Paneltemp2'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.tempname
			,obj.tempid
		]
	});
		
	obj.addtemp = new Ext.Button({
		id : 'addtemp'
		,width:80
		,iconCls : 'icon-add'
		,text : '增加'
	});				
	obj.Paneltemp3 = new Ext.Panel({
		id : 'Paneltemp3'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.addtemp
		]
	});
	
	obj.updatetemp = new Ext.Button({
		id : 'updatetemp'
		,width:80
		,iconCls : 'icon-updateSmall'
		,text : '修改'
	});	
	obj.Paneltemp4 = new Ext.Panel({
		id : 'Paneltemp4'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.updatetemp	
		]
	});
	obj.deletetemp = new Ext.Button({
		id : 'deletetemp'
		,width:80
		,iconCls : 'icon-delete'
		,text : '删除'
	});	
obj.Paneltemp5 = new Ext.Panel({
		id : 'Paneltemp5'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.deletetemp	
		]
	});
	obj.distemppanel = new Ext.form.FormPanel({
		id : 'distemppanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'north'
		,height : 40
		,layout : 'column'
		,frame : true
		,items:[
			obj.Paneltemp1
			,obj.Paneltemp2
			,obj.Paneltemp3
			,obj.Paneltemp4
			,obj.Paneltemp5
			
		]
	});
	
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TTemplateID'
		}, 
	    [
			{name: 'TTemplateID', mapping : 'TTemplateID'}
			,{name: 'TIcuaID', mapping: 'TIcuaID'}
			,{name: 'TDeptID', mapping: 'TDeptID'}
			,{name: 'TFlag', mapping: 'TFlag'}
			,{name: 'tICUPANCSHDr', mapping: 'tICUPANCSHDr'}
			,{name: 'TType', mapping: 'TType'}
			,{name: 'TTemplateName', mapping: 'TTemplateName'}
			,{name: 'TDeptName', mapping: 'TDeptName'}


		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '模板ID', width: 150, dataIndex: 'TTemplateID', sortable: true}
			,{header: '模板名称', width: 300, dataIndex: 'TTemplateName', sortable: true}
			,{header: '科室名称', width: 300, dataIndex: 'TDeptName', sortable: true}
			,{header: '科室ID', width: 150, dataIndex: 'TDeptID', sortable: true}
		]
		});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUPara';
		param.QueryName = 'FindICUPara';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	obj.distempresult = new Ext.Panel({
		id : 'distempresult'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
			
		]
	});
	obj.ftndistemp = new Ext.Panel({
		id : 'ftndistemp'
		,buttonAlign : 'center'
		,height : 170
		,title : '重症监护显示项属性值'
		,region : 'north'
		,layout : 'border'
		,iconCls : 'icon-manage'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.distemppanel
			,obj.distempresult
		]
	});
	
//////////////////////////////////////////////////////	
	obj.number = new Ext.form.TextField({
		id : 'number'
		,fieldLabel : '序号'
		,labelSeparator: ''
		,anchor : '95%'
	});	

 	obj.viewcatstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.viewcatstore = new Ext.data.Store({
		proxy: obj.viewcatstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
		     {name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});	
	obj.viewcat = new Ext.form.ComboBox({
		id : 'viewcat'
		,store:obj.viewcatstore
		,listeners:{
		    select:function(combo,record,index){
			    try{
                    obj.itemcomordstore.removeAll();
                    
                    obj.itemcomordstore.reload();

		           }
		        catch(ex)
		        {
			         Ext.MessageBox.alert("错误","数据加载失败。");

		        }
		}
		}
		,minChars:1	
		,displayField:'Desc'	
		,fieldLabel : '显示分类'
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	}); 	
	
	obj.viewcatstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUPara';
		param.QueryName = 'FindANCEViewCat';
		param.Arg1=obj.viewcat.getValue();
		param.ArgCnt = 1;
	});
	obj.viewcatstore.load({});
			
   	obj.itempanel1 = new Ext.Panel({
		id : 'itempanel1'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth : 30
		,layout : 'form'
		,items:[
			obj.number
			//,obj.viewcat
		]
	});
		
	obj.itemcode = new Ext.form.TextField({
		id : 'itemcode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	});			
		
 	obj.itemcomordstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
    function selcomord(v, record) { 
         return record.Desc+" || "+record.ID; 
    } 
	obj.itemcomordstore = new Ext.data.Store({
		proxy: obj.itemcomordstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
		     {name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		    ,{ name: 'selecttext', convert: selcomord}
		])
	});	
	obj.itemcomord = new Ext.form.ComboBox({
		id : 'itemcomord'
		,store:obj.itemcomordstore
		,minChars:1	
		//,displayField:'Desc'	
		,displayField:'selecttext'
		,fieldLabel : '常用医嘱'
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	}); 	
	
	obj.itemcomordstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUPara';
		param.QueryName = 'FindANCComOrd';
		param.Arg1=obj.viewcat.getValue();
		param.Arg2=obj.itemcomord.getRawValue();
		param.Arg3="Y";
		param.ArgCnt = 3;
	});
	obj.itemcomordstore.load({});
	
	obj.itemid = new Ext.form.TextField({
		id : 'itemid'
		,hidden : true
    });	
    		
	obj.itempanel2 = new Ext.Panel({
		id : 'itempanel2'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth : 30
		,layout : 'form'
		,items:[
			obj.itemcode
			//,obj.itemcomord
			//,obj.itemid
		]
	});
		
	obj.itemname = new Ext.form.TextField({
		id : 'itemname'
		,fieldLabel : '名称'		
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.additem = new Ext.Button({
		id : 'additem'
		,iconCls : 'icon-add'
		,style:'margin-left :15px;'
		,width : 86
		,text : '增加'
	});	
	
	obj.updateitem = new Ext.Button({
		id : 'updateitem'
		,iconCls : 'icon-updateSmall'
		,style:'margin-left :15px;'
		,width : 86
		,text : '修改'
	});
	
	obj.deleteitem = new Ext.Button({
		id : 'deleteitem'
		,iconCls : 'icon-delete'
		,style:'margin-left :15px;'
		,width : 86
		,text : '删除'
	});		
     obj.finditem = new Ext.Button({
		id : 'finditem'
		,iconCls : 'icon-find'
		,style:'margin-left :15px;'
		,width : 86
		,text : '查询'
	});			
	obj.itempanel3 = new Ext.Panel({
		id : 'itempanel3'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth : 30
		,layout : 'form'
		,items:[
			obj.itemname
		]
		//,buttons:[
		   //obj.finditem
		  // ,obj.additem
		   //,obj.updateitem
		   //,obj.deleteitem
	//	]
	});
	obj.itempanel4 = new Ext.Panel({
		id : 'itempanel4'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.viewcat
		]
	});
	obj.itempanel5 = new Ext.Panel({
		id : 'itempanel5'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.itemcomord
		]
	});
	obj.itempanel6 = new Ext.Panel({
		id : 'itempanel6'
		,buttonAlign : 'center'
		,columnWidth : .09
		,layout : 'form'
		,items:[
			obj.finditem
		]
	});
	obj.itempanel7 = new Ext.Panel({
		id : 'itempanel7'
		,buttonAlign : 'center'
		,columnWidth : .09
		,layout : 'form'
		,items:[
			obj.additem
		]
	});
	obj.itempanel8 = new Ext.Panel({
		id : 'itempanel8'
		,buttonAlign : 'center'
		,columnWidth : .09
		,layout : 'form'
		,items:[
			obj.updateitem
		]
	});
		obj.itempanel9 = new Ext.Panel({
		id : 'itempanel9'
		,buttonAlign : 'center'
		,columnWidth : .09
		,layout : 'form'
		,items:[
			obj.deleteitem
		]
	});	
	obj.distempitempanel = new Ext.form.FormPanel({
		id : 'distempitempanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,labelWidth : 80
		,region : 'north'
		,height : 40
		,layout : 'column'
		,frame : true
		,items:[
			obj.itempanel1
			,obj.itempanel2
			,obj.itempanel3	
			,obj.itempanel4	
			,obj.itempanel5
			,obj.itempanel6 
			,obj.itempanel7	
			,obj.itempanel8
			,obj.itempanel9
		]
	});
	obj.retGridPanelitemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelitemStore = new Ext.data.Store({
		proxy: obj.retGridPanelitemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TID'
		}, 
	    [
			{name: 'TID', mapping : 'TID'}
			,{name: 'TTemplateID', mapping: 'TTemplateID'}
			,{name: 'TComOrdID', mapping: 'TComOrdID'}
			,{name: 'TSeqNo', mapping: 'TSeqNo'}
			,{name: 'TViewCatID', mapping: 'TViewCatID'}
			,{name: 'TItemCode', mapping: 'TItemCode'}
			,{name: 'TItemDesc', mapping: 'TItemDesc'}
			,{name: 'TComOrdDesc', mapping: 'TComOrdDesc'}
			,{name: 'TViewCatDesc', mapping: 'TViewCatDesc'}
			,{name: 'TComOrdCode', mapping: 'TComOrdCode'}

		])
	});

    obj.retGridPanelitem = new Ext.grid.EditorGridPanel({
		id : 'retGridPanelitem'
		,store : obj.retGridPanelitemStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ID', width: 50, dataIndex: 'TID', sortable: true}
			,{header: '代码', width: 100, dataIndex: 'TItemCode', sortable: true}
			,{header: '名称', width: 100, dataIndex: 'TItemDesc', sortable: true}
			,{header: '序号', width: 100, dataIndex: 'TSeqNo', sortable: true}
			,{header: '常用医嘱', width: 150, dataIndex: 'TComOrdDesc', sortable: true}
			,{header: '显示分类', width: 150, dataIndex: 'TViewCatDesc', sortable: true}
			,{header: '常用医嘱ID', width: 100, dataIndex: 'TComOrdID', sortable: true}
			,{header: '显示分类ID', width: 100, dataIndex: 'TViewCatID', sortable: true}
			,{header: '模板ID', width: 50, dataIndex: 'TTemplateID', sortable: true}
			,{header: '常用医嘱代码', width: 150, dataIndex: 'TComOrdCode', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.retGridPanelitemStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
		});

	obj.distempitemresult = new Ext.Panel({
		id : 'distempitemresult'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,height:170
		,frame : true
		,items:[
		    obj.retGridPanelitem
			
		]
	});
		
	obj.ftndistempitems = new Ext.Panel({
		id : 'ftndistempitems'
		,buttonAlign : 'center'
		,title:'重症监护显示模板项'
		,region : 'center'
		,layout : 'border'
		,iconCls : 'icon-manage'
		,frame : true
		,animate:true
		,items:[
			obj.distempitempanel
			,obj.distempitemresult
		]
	});
////////////////////////////////////////////////////////

 	obj.proitemsstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
    function selitem(v, record) { 
         return record.tICUCPDesc+" || "+record.tICUCPRowID; 
    }    
	obj.proitemsstore = new Ext.data.Store({
		proxy: obj.proitemsstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tICUCPRowID'
		}, 
		[
		     {name: 'tICUCPRowID', mapping: 'tICUCPRowID'}
			,{name: 'tICUCPCode', mapping: 'tICUCPCode'}
			,{name: 'tICUCPDesc', mapping: 'tICUCPDesc'}
			,{name: 'tICUCPDefaultValue', mapping: 'tICUCPDefaultValue'}
			,{name: 'selectitem', convert:selitem}
		])
	});	
	obj.proitems = new Ext.form.ComboBox({
		id : 'proitems'
		,store:obj.proitemsstore
		,minChars:1	
		//,displayField:'tICUCPDesc' 
		,displayField:'selectitem'	
		,fieldLabel : '属性项'
		,valueField : 'tICUCPRowID'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	}); 	
	
	obj.proitemsstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCProperty';
		param.QueryName = 'FindICUCProperty';
		param.ArgCnt = 0;
	});
	obj.proitemsstore.load({});	
			
   	obj.propanel1 = new Ext.Panel({
		id : 'propanel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.proitems
		]
	});
		
	obj.provalue = new Ext.form.TextField({
		id : 'provalue'
		,fieldLabel : '属性值'
		,labelSeparator: ''
		,anchor : '95%'
	});		
		
	obj.propanel2 = new Ext.Panel({
		id : 'propanel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.provalue
		]
	});
		
	obj.viewitem = new Ext.form.TextField({
		id : 'viewitem'
		,fieldLabel : '显示项'
		,anchor : '95%'
		,labelSeparator: ''
		,disabled:true
	});
	
 	obj.propertyid = new Ext.form.TextField({
		id : 'propertyid'
		,hidden : true
    });	
     		
	obj.propanel3 = new Ext.Panel({
		id : 'propanel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.viewitem
			,obj.propertyid
		]
	});
	
	obj.addpro = new Ext.Button({
		id : 'addpro'
		,width:80
		,iconCls : 'icon-add'
		,text : '增加'
	});	
	
	obj.updatepro = new Ext.Button({
		id : 'updatepro'
		,width:80
		,iconCls : 'icon-updateSmall'
		,text : '修改'
	});
	
	obj.deletepro = new Ext.Button({
		id : 'deletepro'
		,width:80
		,iconCls : 'icon-delete'
		,text : '删除'
	});		
	obj.propanel4 = new Ext.Panel({
		id : 'propanel4'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.addpro
		]
		/*,buttons:[
		   obj.addpro
		   ,obj.updatepro
		   ,obj.deletepro
		]*/
	});
	obj.propanel5 = new Ext.Panel({
		id : 'propanel5'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.updatepro
		]
	});
	obj.propanel6 = new Ext.Panel({
		id : 'propanel6'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.deletepro
		]
	});
	obj.disproperpanel = new Ext.form.FormPanel({
		id : 'disproperpanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'north'
		,height : 40
		,layout : 'column'
		,frame : true
		,items:[
			obj.propanel1
			,obj.propanel2
			,obj.propanel3	
			,obj.propanel4	
			,obj.propanel5
			,obj.propanel6
		]
	});

	obj.retGridPanelproStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelproStore = new Ext.data.Store({
		proxy: obj.retGridPanelproStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TPropertyValueID'
		}, 
	    [
			{name: 'TDisplayItemID', mapping : 'TDisplayItemID'}
			,{name: 'TTemplateID', mapping: 'TTemplateID'}
			,{name: 'TPropertyValueID', mapping: 'TPropertyValueID'}
			,{name: 'TPropertyItemID', mapping: 'TPropertyItemID'}
			,{name: 'TPropertyValue', mapping: 'TPropertyValue'}
			,{name: 'TPropertyItemDesc', mapping: 'TPropertyItemDesc'}
			,{name: 'TDisplayItemDesc', mapping: 'TDisplayItemDesc'}
		])
	});

    obj.retGridPanelpro = new Ext.grid.EditorGridPanel({
		id : 'retGridPanelpro'
		,store : obj.retGridPanelproStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		//,autoHeight:true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '属性值ID', width: 150, dataIndex: 'TPropertyValueID', sortable: true}
			,{header: '显示项', width: 200, dataIndex: 'TDisplayItemDesc', sortable: true}
			,{header: '属性项', width: 200, dataIndex: 'TPropertyItemDesc', sortable: true}
			,{header: '属性值', width: 200, dataIndex: 'TPropertyValue', sortable: true}
			,{header: '显示项ID', width: 150, dataIndex: 'TDisplayItemID', sortable: true}
			,{header: '属性项ID', width: 150, dataIndex: 'TPropertyItemID', sortable: true}
		]
		});
	
	obj.Panelpro23 = new Ext.Panel({
		id : 'Panelpro23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panelpro25 = new Ext.Panel({
		id : 'Panelpro25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});	
	obj.disproperresult = new Ext.Panel({
		id : 'disproperresult'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panelpro23
			,obj.Panelpro25
		    ,obj.retGridPanelpro
			
		]
	});
	obj.ftndisproperties = new Ext.Panel({
		id : 'ftndisproperties'
		,buttonAlign : 'center'
		,height : 150
		,title : '模板项属性'
		,iconCls : 'icon-manage'
		,region : 'south'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.disproperpanel
			,obj.disproperresult
		]
	});
/////////////////////////////////////////////////////////
		
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,defaults: {
            		split: true
        		,collapsible: true
        	}
		,items:[
			obj.ftndistemp
			,obj.ftndistempitems
			,obj.ftndisproperties
		]
	});
	
///////////////////////////////////////////////////////////	
	InitViewScreenEvent(obj);
	
     obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
     obj.addtemp.on("click", obj.addtemp_click, obj);
     obj.updatetemp.on("click", obj.updatetemp_click, obj);
      obj.deletetemp.on("click", obj.deletetemp_click, obj);
    
     obj.retGridPanelitem.on("rowclick", obj.retGridPanelitem_rowclick, obj);
     obj.additem.on("click", obj.additem_click, obj);
     obj.updateitem.on("click", obj.updateitem_click, obj);
     obj.deleteitem.on("click", obj.deleteitem_click, obj);
     obj.finditem.on("click", obj.finditem_click, obj);
     
     obj.retGridPanelpro.on("rowclick", obj.retGridPanelpro_rowclick, obj);
     obj.addpro.on("click", obj.addpro_click, obj);
     obj.updatepro.on("click", obj.updatepro_click, obj);
     obj.deletepro.on("click", obj.deletepro_click, obj);    
          
    obj.LoadEvent(arguments);    
    return obj;	
	
}

