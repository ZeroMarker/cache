var TheWindowsobj; 
var TheMainobj; 
//主界面
function InitViewport1()
{	
	var obj = new Object();

	obj.param1 = new ExtTool.CreateCombo('param1','健康杂志',false,'web.DHCHM.GetComboxInfo','GetMagazine','');
 
	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
		obj.param1
		]
	});
	obj.SDesc = new Ext.form.TextField({
		id : 'SDesc'
		,region : 'west'
		,fieldLabel : '备注'
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
		id : 'btFind'
		,iconCls : 'icon-find'
		,text : '杂志发送'
});

obj.btNew = new Ext.Button({
		id : 'btNew'
		,iconCls : 'icon-find'
		,text : '添加用户'
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
		,	buttons:[
		
	        obj.btNew,obj.btSend
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
		,title : '健康杂志发送'
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
            totalProperty: 'total'
            ,idProperty: 'OQEId'
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
        }
        ,
        {
            name: 'vMobilePhone',
            mapping: 'vMobilePhone'
      
        }
        ])
    });
    obj.GridPanelMSCheckCol = new Ext.grid.CheckColumn({
        header: '',
        dataIndex: 'checked',
        width: 50
    });
    
    var sm=new Ext.grid.CheckboxSelectionModel;
    obj.GridPanelMS = new Ext.grid.EditorGridPanel({
        id: 'GridPanelMS',
        store: obj.GridPanelMSStore,
        region: 'center',
        clicksToEdit:1,
        buttonAlign: 'center',
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
            header: '登记号',
            width: 100,
            dataIndex: 'vBIPAPMINo',
            sortable: true
        }, 
        
        {
            header: '姓名',
            width: 100,
            dataIndex: 'vName',
            sortable: true
        }, {
            header: '性别',
            width: 100,
            dataIndex: 'SexDesc',
            sortable: true
        }, 
        {
            header: '手机',
            width: 100,
            dataIndex: 'vMobilePhone',
            editor:new Ext.form.TextField({allowBlank:false}),
            sortable: true
        }, {
            header: '日期',
            width: 100,
            dataIndex: 'Date',
            sortable: true
        }, {
            header: '学历',
            width: 100,
            dataIndex: 'EducationDesc',
            sortable: true
        }, {
            header: '婚姻',
            width: 100,
            dataIndex: 'MaritalDesc',
            sortable: true
        }]
	,bbar: new Ext.PagingToolbar({
			pageSize : 25,
			store : obj.GridPanelMSStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
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
  //================================================ 

	
	obj.Viewport1 = new Ext.Viewport
	({
		 id : 'Viewport1'
		,layout : 'border'
		,items:
		[
			 obj.FormPanel3
			,obj.GridPanelMS
		]
	});
		TheMainobj=obj;
		
  	InitViewport1Event(obj);
	
	//事件处理代码
	obj.btSend.on("click", obj.btSend_click, obj);
  obj.btNew.on("click", obj.btNew_click, obj);
	
	//obj.ItemList.on("rowdblclick", obj.ItemList_rowclick, obj);
	//obj.ItemList.on("cellclick", obj.GridPanelED_cellclick, obj);
  obj.LoadEvent(arguments);
   return obj;
}
//弹出窗口

