var TheWindowsobj; 
var TheMainobj; 
var SendType=0;


//������
function InitViewport1(){
	var obj = new Object();
	

obj.typeradio= new Ext.form.RadioGroup({
	 
	    fieldLabel: 'ѡ�����״̬',
    items: 
    [
    {
        boxLabel: '����',
        name: 'cb-auto',
        inputValue: ' N',
        checked: true
    },
    {
        boxLabel: 'ʧ��',
        name: 'cb-auto',
        inputValue: ' F'
    },
    {
        boxLabel: '�ɹ�',
        name: 'cb-auto',
        inputValue: ' S'
    }
    ]
});

	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
		obj.typeradio
		
		]
	});


 	obj.cellno = new  Ext.form.Label({
		id : 'cellno'
		,style: 'color:#FF0000;font-family:����;font-size: 12pt'
});
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.cellno
			
		]
	});
	obj.Panel80 = new Ext.Panel({
		id : 'Panel80'
		,buttonAlign : 'center'
		,width : 600
		,region : 'north'

		,columnWidth : .5
		,layout : 'column'
		,items:[
			obj.Panel7
			,obj.Panel8
		]
	});
	

	obj.btSend= new Ext.Button({
		id : 'btSend'
		,iconCls : 'icon-find'
		,text : '���ŷ���'
});
	obj.btRecord= new Ext.Button({
		id : 'btRecord'
		,iconCls : 'icon-find'
		,text : '���ͼ�¼'
});
	obj.btClear= new Ext.Button({
		id : 'btClear'
		,iconCls : 'icon-find'
		,text : '�б����'
});


obj.btNew = new Ext.Button({
		id : 'btNew'
		,iconCls : 'icon-find'
		,text : '�����Զ�����'
});

obj.Panel90 = new Ext.Panel({
		id : 'Panel90'
		,buttonAlign : 'center'
		,width : 600

		,layout : 'form'
    ,region : 'column'
		,items:[
			obj.Panel80
 
		]
		,buttons:[
		
	        obj.btNew,obj.btRecord,obj.btClear,obj.btSend
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
		,title : '�������ŷ���'
		,items:[
					obj.Panel90
		]
	
	});
	
	//===========================================================
	 obj.GridPanelMSStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.GridPanelMSStore = new Ext.data.Store({
        proxy: obj.GridPanelMSStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'OQEId'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'OQEId',
            mapping: 'OQEId'
        }, {
            name: 'vBIPAPMINo',
            mapping: 'vBIPAPMINo'
        }, {
            name: 'vName',
            mapping: 'vName'
        }, {
            name: 'SexDesc',
            mapping: 'SexDesc'
        }, {
            name: 'Date',
            mapping: 'Date'
        }, {
            name: 'EducationDesc',
            mapping: 'EducationDesc'
        }, {
            name: 'MaritalDesc',
            mapping: 'MaritalDesc'
        },
        {
            name: 'vMobilePhone',
            mapping: 'vMobilePhone'
      
        }
        
        ,{
            name: 'vResult',
            mapping: 'vResult'
      
        }
        ,{
            name: 'vMessage',
            mapping: 'vMessage'
      
        }
        ])
    });
   
     var sm=new Ext.grid.CheckboxSelectionModel;
    obj.GridPanelMS = new Ext.grid.EditorGridPanel({
        id: 'GridPanelMS',
        store: obj.GridPanelMSStore,
        region: 'center',
        buttonAlign: 'center',
        clicksToEdit:1,
        columns: [
        //obj.GridPanelMSCheckCol,
        sm,
        /*
        {
            header: 'ID',
            width: 100,
            dataIndex: 'OQEId',
            sortable: true
        },
        */
        {
            header: '�ǼǺ�',
            width: 100,
            dataIndex: 'vBIPAPMINo',
            sortable: true
        }, {
            header: '����',
            width: 100,
            dataIndex: 'vName',
            sortable: true
        }, {
            header: '�Ա�',
            width: 100,
            dataIndex: 'SexDesc',
            sortable: true
        }, 
        {
            header: '�ֻ�',
            width: 100,
            dataIndex: 'vMobilePhone',
             editor:new Ext.form.TextField({allowBlank:false}),
            sortable: true
        },{
            header: '����',
            width: 100,
            dataIndex: 'Date',
            sortable: true
        }, {
            header: 'ѧ��',
            width: 100,
            dataIndex: 'EducationDesc',
            sortable: true
        }, {
            header: '����',
            width: 100,
            dataIndex: 'MaritalDesc',
            sortable: true
        }
        
        , {
            header: '���',
            width: 200,
            dataIndex: 'vResult',
            sortable: true
        }
        , {
            header: '����',
            width: 200,
            dataIndex: 'vMessage',
            sortable: true
        }
        ]
	,bbar: new Ext.PagingToolbar({
			pageSize : 25,
			store : obj.GridPanelMSStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,sm:sm
		//,plugins : obj.GridPanelMSCheckCol
    });
  
   /* 
    obj.GridPanelMSStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.EvaluationStatistic';
        param.QueryName = 'FindBaseInfoByType';
        param.Arg1 = obj.DateFieldS.getValue();
        param.Arg2 = obj.DateFieldE.getValue();
        param.Arg3 = obj.ComboBoxHCI.getValue();
        param.ArgCnt = 3;
    });
    */
  //---------------------- 
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.FormPanel3
			,obj.GridPanelMS
		]
	});


	InitViewport1Event(obj);
	//�¼��������

TheMainobj=obj;
	
	obj.btSend.on("click", obj.btSend_click, obj);
  obj.btNew.on("click", obj.btNew_click, obj);
  obj.btRecord.on("click", obj.btRecord_click, obj);
  obj.btClear.on("click", obj.btClear_click, obj);
//	obj.ItemList.on("rowdblclick", obj.ItemList_rowclick, obj);
//	obj.ItemList.on("cellclick", obj.GridPanelED_cellclick, obj);
  obj.LoadEvent(arguments);
  
   function ShowCheckStatus(v, p, record){
  
 
  	p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
           (v == 'true' ? '-on' : '')+
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
  }
   return obj;
}


