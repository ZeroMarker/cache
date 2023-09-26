var TheWindowsobj; 
var TheMainobj; 

function InitViewport1(){
	var obj = new Object();
	
	 obj.combo = new Ext.form.ComboBox({    
       fieldLabel: "��Ա����",        
       store: new Ext.data.SimpleStore({
          fields: ['type','typename3'],        
          data:  [['����ҽ��', '����ҽ��'], ['��������ʦ', '��������ʦ']]                    
          }), 
       mode: 'local',
       triggerAction: 'all',
       valueField: 'type',
       displayField: 'typename3'
       //width:100
        });
	
	//-----------------------------------------------------

   
    obj.ComboBoxHCIStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
   
    obj.ComboBoxHCIStore = new Ext.data.Store({
        proxy: obj.ComboBoxHCIStoreProxy,
        reader: new Ext.data.JsonReader(
        {
            root: 'record',
            totalProperty: 'total',
            idProperty: 'ID'
        }, 
        [
          {name: 'ID',mapping: 'ID'}, 
          {name: 'CName',mapping: 'CName'}
        ]
        )
    });
    obj.ComboBoxHCIStore.load({});
   
    obj.param5 = new Ext.form.ComboBox({
        id: 'param5',
        minChars: 1,
        store: obj.ComboBoxHCIStore,
        fieldLabel: 'ѡ��',
        displayField: 'CName',
        valueField: 'ID',
        triggerAction: 'all'
    });

      obj.ComboBoxHCIStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.BaseDataSet';
        param.QueryName = 'GetUserBy';
        
        param.Arg1 = obj.param5.getRawValue();
        //param.Arg1 ="��";
        param.ArgCnt = 1;
    });
  
//-----------------------------------------------------
	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,columnWidth : .3
		,defaults:{anchor:"90%"},labelWidth:55
		,layout : 'form'
		,items:[
			obj.param5
			
		]
	});
	obj.SDesc = new Ext.form.TextField({
		id : 'SDesc'
		,region : 'west'
		,fieldLabel : '��������ʦ'
	
});

	obj.DActive = new Ext.form.Checkbox({
		id : 'DActive'
		,fieldLabel : '����'
		,checked:true
});
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'center'
		,defaults:{anchor:"90%"},labelWidth:55
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.combo
	
			//obj.SDesc
			
		]
	});
	obj.Panel9 = new Ext.Panel({
		id : 'Panel9'
		,buttonAlign : 'center'
		,columnWidth : .3
		,defaults:{anchor:"90%"},labelWidth:55
		,layout : 'form'
		,items:[
	
			obj.DActive
			//obj.SDesc
			
		]
	});
	obj.Panel80 = new Ext.Panel({
		id : 'Panel80'
		,buttonAlign : 'center'

		,width : "100%"
		,region : 'north'


		,layout : 'column'
		,items:[
			obj.Panel7
			,obj.Panel8
				,obj.Panel9
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
		,text : '���'
});

obj.Panel90 = new Ext.Panel({
		id : 'Panel90'
		,buttonAlign : 'center'
		,width : "100%"

		,layout : 'form'
,region : 'column'
		,items:[
			obj.Panel80

		]
		,	buttons:[
		
	obj.btNew		
		]
	});
	obj.FormPanel3 = new Ext.form.FormPanel({
		id : 'FormPanel3'
		,region : 'north'
		,height : 100
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,labelWidth : 80
		
		,layout : 'form'
		,frame : true
		,title : '��������ʦά��'
		,items:[
			
			obj.Panel90

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
			,{name: 'DCode', mapping: 'DCode'}
			,{name: 'DShort', mapping: 'DShort'}
			,{name: 'DDesc', mapping: 'DDesc'}
		  ,{name: 'Dtype', mapping: 'Dtype'}
		  ,{name: 'DActive', mapping: 'DActive'}
		])
	});

	obj.ItemList = new Ext.grid.GridPanel({
		id : 'ItemList'
		,buttonAlign : 'center'
		,columnWidth : .9
		,store : obj.ItemListStore
		,height : 290
		,region : 'center'
		,columns: [
			{header: '��Ⱥ����', width: 100, dataIndex: 'DCode', sortable: true}
			,{header: '�û���', width: 100, dataIndex: 'DShort', sortable: true}
			,{header: '��������ʦ����', width: 100, dataIndex: 'DDesc', sortable: true}
			,{header: '��Ա����', width: 100, dataIndex: 'Dtype', sortable: true}
			,{header: '����', width: 100, dataIndex: 'DActive', sortable: true,renderer:ShowCheckStatus}
			
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.ItemListStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})


		});
	
        ExtTool.SetTabIndex("MCode$1^MDesc$2^MAlias$3^MPeriodical$4^MPublishDate$5^MLink$6^MActive$7^MSummary$9^MRemark$10");
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
			param.QueryName = 'GetDoctor';
			param.ArgCnt = 0;
				
	});
	obj.ItemListStore.load({
	params : {
		start:0
		,limit:20
	}});



	InitViewport1Event(obj);
	//�¼��������

TheMainobj=obj;
	
	obj.btFind.on("click", obj.btFind_click, obj);
	obj.param5.on("expand", obj.expand_click, obj);
	 
  obj.btNew.on("click", obj.btNew_click, obj);
//	obj.ItemList.on("rowdblclick", obj.ItemList_rowclick, obj);
	//obj.ItemList.on("cellclick", obj.GridPanelED_cellclick, obj);
  obj.LoadEvent(arguments);
  
   function ShowCheckStatus(v, p, record){
  
 
  	p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
           (v == 'Y' ? '-on' : '')+
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
  }
  

  return obj;
}
