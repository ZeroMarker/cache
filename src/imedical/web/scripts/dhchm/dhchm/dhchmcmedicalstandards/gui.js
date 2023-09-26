var TheWindowsobj; 
var TheMainobj; 

function InitViewport1(){
	var obj = new Object();
	

	
	obj.SCode = new Ext.form.TextField({
		id : 'SCode'
		,fieldLabel : '����'
		
});

	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.SCode
			
		]
	});
	obj.SDesc = new Ext.form.TextField({
		id : 'SDesc'
		,region : 'west'
		,fieldLabel : '����'
		
});
	
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.SDesc
		
		]
	});
		obj.Panel80 = new Ext.Panel({
		id : 'Panel80'
		,buttonAlign : 'center'
		,width : 700
		,defaults:{width:200}
		,region : 'column'

		,columnWidth : .5
		,layout : 'column'
		,items:[
			obj.Panel7
			,obj.Panel8
		]
	});
	

	obj.btFind = new Ext.Button({
		id : 'btFind'
		,iconCls : 'icon-find'
		,text : '����'
});
obj.btNew = new Ext.Button({
		id : 'btNew'
		,iconCls : 'icon-find'
		,text : '�½�'
});
obj.Panel9222 = new Ext.Panel({
		id : 'Panel9222'
		,buttonAlign : 'center'
		,width : 600
	
		,layout : 'form'
		,items:[
			
		]
		,	buttons:[
			
			obj.btFind
                       ,obj.btNew
		]
	});
	obj.FormPanel3 = new Ext.form.FormPanel({
		id : 'FormPanel3'
		,region : 'north'
		,height : 120
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,labelWidth : 80
		,title : 'ҽѧ�б��׼ά��'
		,layout : 'form'
		,frame : true
		,items:[
			obj.Panel80
			,obj.Panel9222
		]
	
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
			,{name: 'MSCode', mapping: 'MSCode'}
			,{name: 'MSDesc', mapping: 'MSDesc'}
			,{name: 'MSNatureValue', mapping: 'MSNatureValue'}
			,{name: 'MSActive', mapping: 'MSActive'}
			,{name: 'MSRemark', mapping: 'MSRemark'}
		])
	});

	obj.ItemList = new Ext.grid.GridPanel({
		id : 'ItemList'
		,buttonAlign : 'center'

		,store : obj.ItemListStore
		,height : 290
		,region : 'center'
		,columns: [

			
			{header: '����', width: 100, dataIndex: 'MSCode', sortable: true}
			,{header: '����', width: 100, dataIndex: 'MSDesc', sortable: true}
			
			,{header: '����ֵ', width: 100, dataIndex: 'MSNatureValue', sortable: true,renderer:ShowCheckStatus}
			,{header: '����', width: 100, dataIndex: 'MSActive', sortable: true,renderer:ShowCheckStatus}
			,{header: '��ע', width: 100, dataIndex: 'MSRemark', sortable: true}
			,{header: '�༭���ʽ', width: 150, dataIndex: 'EditExpression',
renderer: function(v,c,record,row){

return "<input type='button' value='���ʽά��'>" ;

}}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.ItemListStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})


		});

ExtTool.SetTabIndex("MSCode$1^MSDesc$2^MSActive$3^MSNatureValue$4^MSRemark$5");
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.FormPanel3
			,obj.ItemList
		]
	});
	obj.ItemListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.BaseDataSet';
			param.QueryName = 'GetCMedicalStandards';
			param.Arg1 = obj.SCode.getValue();
			param.Arg2 = obj.SDesc.getValue();
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = '';
			param.ArgCnt = 5;
	});
	obj.ItemListStore.load({
	params : {
		start:0
		,limit:20
	}});

TheMainobj=obj;
	InitViewport1Event(obj);
	//�¼��������
	
	obj.btFind.on("click", obj.btFind_click, obj);
        obj.btNew.on("click", obj.btNew_click, obj);
	obj.ItemList.on("rowdblclick", obj.ItemList_rowclick, obj);
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
  //obj.MSCode.focus(true,3); 
  return obj;
}
/////////////////////////////////////////////////////////////////////////////////////////////

function InitWindow8(){
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	
	var obj = new Object();
	
	
	
	obj.ID = new Ext.form.TextField({
		id : 'ID'
		,hidden : true
});

	
	obj.MSCode = new Ext.form.TextField({
		id : 'MSCode'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank:false
});
	obj.MSActive = new Ext.form.Checkbox({
		id : 'MSActive'
		,fieldLabel : '����'
		,checked:true
});
	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.MSCode
			,obj.MSActive
		]
	});
	obj.MSDesc = new Ext.form.TextField({
		id : 'MSDesc'
		,region : 'west'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank:false
});
	obj.MSNatureValue = new Ext.form.Checkbox({
		id : 'MSNatureValue'
		,fieldLabel : '����ֵ'
		,checked:true
});
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.MSDesc
			,obj.MSNatureValue
		]
	});
		obj.Panel80 = new Ext.Panel({
		id : 'Panel80'
		,buttonAlign : 'center'
		,width : 700
		,defaults:{width:200}
		,region : 'column'

		,columnWidth : .5
		,layout : 'column'
		,items:[
			obj.Panel7
			,obj.Panel8
		]
	});
	
	obj.MSRemark = new Ext.form.TextArea({
		id : 'MSRemark'
		,width : 400
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
	
obj.Panel9222 = new Ext.Panel({
		id : 'Panel9222'
		,buttonAlign : 'center'
		,width : 600
	
		,layout : 'form'
		,items:[
			obj.MSRemark
			,obj.ID
		]
		,	buttons:[
			obj.btSave
			,obj.btCancel
		
		]
	});
	obj.FormPanel3 = new Ext.form.FormPanel({
		id : 'FormPanel3'
		,region : 'north'
		,height : 220
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,labelWidth : 80
	
		,layout : 'form'
		,frame : true
		,items:[
			obj.Panel80
			,obj.Panel9222
		]
	
	});
obj.Window8 = new Ext.Window({
		id : 'Window8'
		,height : 240
,closeAction :'hide'
		,buttonAlign : 'center'
		,width : 540
		,region : 'center'
	,title : 'ҽѧ�б��׼ά��'
,modal:true
		,layout : 'fit'
		,items:[
			obj.FormPanel3
		]
		,constrain:true
	});

	TheWindowsobj=obj;

	
	InitWindow8Event(obj);
        obj.btSave.on("click", obj.btSave_click, obj);
	obj.btCancel.on("click", obj.btCancel_click, obj);
//	obj.Window8.on("show",obj.Window8_show,obj);
	
        obj.LoadEvent(arguments);
  return obj;
}




