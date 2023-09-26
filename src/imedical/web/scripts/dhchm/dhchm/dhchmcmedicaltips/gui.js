function InitViewport1(){
	var obj = new Object();
	
obj.ID = new Ext.form.TextField({
		id : 'ID'
		,hidden : true
});
	
	obj.MTCode = new Ext.form.TextField({
		id : 'MTCode'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank:false
});
	obj.MTActive = new Ext.form.Checkbox({
		id : 'MTActive'
		,fieldLabel : '����'
		,checked:true
});
	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
	  ,defaults:{anchor:"90%"},labelWidth:55
		,items:[
		   obj.MTCode
			,obj.MTActive
			,obj.ID
		]
	});
	obj.MTDesc = new Ext.form.TextField({
		id : 'MTDesc'
		,region : 'west'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank:false
});
	obj.MTAlias = new Ext.form.TextField({
		id : 'MTAlias'
		,fieldLabel : '����'
});
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,defaults:{anchor:"90%"},labelWidth:55
		,items:[
			obj.MTDesc
			,obj.MTAlias
		]
	});
	obj.Panel80 = new Ext.Panel({
		id : 'Panel80'
		,buttonAlign : 'center'
		,region : 'column'
		,layout : 'column'
		,items:[
			obj.Panel7
			,obj.Panel8
		]
	});
	obj.MTDetail = new Ext.form.HtmlEditor({
		id : 'MTDetail'
		,width : 400
                ,region : 'center'
		,fieldLabel : '����'
});
	obj.MTRemark = new Ext.form.TextArea({
		id : 'MTRemark'
		,width : 350
		,height:50
		,fieldLabel : '��ע'
});
	
	obj.btSave = new Ext.Button({
		id : 'btSave'
		,iconCls : 'icon-save'
		,text :  '����'
});
	obj.btCancel = new Ext.Button({
		id : 'btCancel'
		,iconCls : 'icon-new'
		,text : '  ���'
});
	obj.btFind = new Ext.Button({
		id : 'btFind'
		,iconCls : 'icon-find'
		,text : '����'
});


	
	obj.ItemListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ItemListStore = new Ext.data.Store({
		proxy: obj.ItemListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			
			{name: 'ID', mapping: 'ID'}
			,{name: 'MTCode', mapping: 'MTCode'}
			,{name: 'MTDesc', mapping: 'MTDesc'}
			,{name: 'MTActive', mapping: 'MTActive'}
			,{name: 'MTDetail', mapping: 'MTDetail'}
			,{name: 'MTRemark', mapping: 'MTRemark'}
			,{name: 'MTAlias', mapping: 'MTAlias'}
		])
	});
	obj.ItemListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ItemList = new Ext.grid.GridPanel({
		id : 'ItemList'
		,buttonAlign : 'center'
		,region : 'center'
		,loadMask:true
	
		,store : obj.ItemListStore
		,columns: [
 			{header: '����', width: 100, dataIndex: 'MTCode', sortable: true}
			,{header: '����', width: 100, dataIndex: 'MTDesc', sortable: true}
      ,{header: '����', width: 50, dataIndex: 'MTActive', sortable: true, sortable: true,renderer:ShowCheckStatus}
      			
			,{header: '��ע', width: 100, dataIndex: 'MTRemark', sortable: true}
			,{header: '����', width: 100, dataIndex: 'MTAlias', sortable: true}
			,{header: '�༭���ʽ', width: 150, dataIndex: 'EditExpression',renderer: function(v,c,record,row){
            return "<input type='button' value='���ʽά��'>" ;
       }}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 15,
			store : obj.ItemListStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})


		});

ExtTool.SetTabIndex("MTCode$1^MTDesc$2^MTActive$3^MTAlias$4^MTDetail$5^MTRemark$6");

obj.Panel888 = new Ext.Panel({
	id : 'Panel888'
		,buttonAlign : 'center'
		
,height:160
	,layout : 'form'

,region : 'north'
		
		,items:[
			obj.Panel80
			,obj.MTRemark
			
		]
		,buttons:[
			
			obj.btSave
			,obj.btCancel
			
		]
		});

obj.Panel9 = new Ext.Panel({
		id : 'Panel9'
		,buttonAlign : 'center'
		,width : 450
		
		,region : 'east'
,layout : 'border'
		
		,items:[
                  obj.Panel888,
	          obj.MTDetail
	          
			
		]
		,buttons:[
			
		]
	});

	obj.SSCode = new Ext.form.TextField({
		id : 'SSCode'
		,fieldLabel : '����'
//,width:90
		
});
	obj.SSDesc = new Ext.form.TextField({
		id : 'SSDesc'
		,fieldLabel : '����'
//,width:90
		
});
obj.Panel001 = new Ext.Panel({defaults:{anchor:"100%"},labelWidth:55,id : 'Panel001',layout : 'form',columnWidth : .5,labelAlign : 'right',items:[obj.SSCode]});
obj.Panel002 = new Ext.Panel({defaults:{anchor:"100%"},labelWidth:55,id : 'Panel002',layout : 'form',columnWidth : .5,labelAlign : 'right',items:[obj.SSDesc]});
obj.Panel003 = new Ext.Panel({defaults:{anchor:"100%"},labelWidth:55,id : 'Panel003',layout : 'border',width:40,frame:false,html:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'});

obj.Panel000 = new Ext.Panel({
		id : 'Panel000'
		,buttonAlign : 'center'
		,region : 'north'
		,height:40
		,layout : 'column'
		,items:[obj.Panel001,obj.Panel002,obj.Panel003,obj.btFind]
                
	});



obj.Panel999 = new Ext.Panel({
		id : 'Panel999'
		,buttonAlign : 'center'
		,width : 1800

	,region : 'center'
,layout : 'border'
		,frame : true
,title : '������ʾά��'
		,items:[
		  obj.Panel000 
                  ,obj.ItemList 
			
		]
		
	});	
	
	obj.FormPanel3 = new Ext.form.FormPanel({
		id : 'FormPanel3'
		,region : 'east'
		,height : 250
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,labelWidth : 80
		,title : '�༭'
		,layout : 'border'
,width:450
    ,frame : true
    
		,items:[
                  obj.Panel888,
	          obj.MTDetail


		]
	
	});


	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.Panel999
,obj.FormPanel3

		

		]
	});
	obj.ItemListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.BaseDataSet';
			param.QueryName = 'GetCMedicalTips';
			param.Arg1 = obj.SSCode.getValue();
			param.Arg2 = obj.SSDesc.getValue();
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = '';
			param.ArgCnt = 6;
		
	});
	obj.ItemListStore.load({
	params : {
		start:0
		,limit:15
	}});

	InitViewport1Event(obj);
	//�¼��������
	obj.btSave.on("click", obj.btSave_click, obj);
	obj.btCancel.on("click", obj.btCancel_click, obj);
	obj.btFind.on("click", obj.btFind_click, obj);
	obj.ItemList.on("rowclick", obj.ItemList_rowclick, obj);
	obj.ItemList.on("cellclick", obj.GridPanelED_cellclick, obj);
  obj.LoadEvent(arguments);
  
  function ShowCheckStatus(v, p, record){
  
 
  	p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
           (v == 'true' ? '-on' : '')+
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
  }
    obj.MTCode.focus(true,3);
  return obj;
}

