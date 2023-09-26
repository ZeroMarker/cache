var TheWindowsobj; 

//弹出窗口

function InitWindow8()
{
	var obj = new Object();

   obj.ComboBoxHCStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.ComboBoxHCStore = new Ext.data.Store({
        proxy: obj.ComboBoxHCStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'id'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'id',
            mapping: 'id'
        }, {
            name: 'text',
            mapping: 'text'
        }, {
            name: 'leaf',
            mapping: 'leaf'
        }, {
            name: 'checked',
            mapping: 'checked'
        }])
    });
    obj.ComboBoxHC = new Ext.form.ComboBox({
        id: 'ComboBoxHC',
        store: obj.ComboBoxHCStore,
        minChars: 1,
        displayField: 'text',
        fieldLabel: '分类级别',
        valueField: 'id',
        triggerAction: 'all'
    });
    obj.ComboBoxHCIStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    obj.ComboBoxHCIStore = new Ext.data.Store({
        proxy: obj.ComboBoxHCIStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'ID'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'ID',
            mapping: 'ID'
        }, {
            name: 'HCActive',
            mapping: 'HCActive'
        }, {
            name: 'HCCode',
            mapping: 'HCCode'
        }, {
            name: 'HCDesc',
            mapping: 'HCDesc'
        }, {
            name: 'HCExpandCode',
            mapping: 'HCExpandCode'
        }, {
            name: 'HCMonths',
            mapping: 'HCMonths'
        }, {
            name: 'HCRemark',
            mapping: 'HCRemark'
        }, {
            name: 'HCType',
            mapping: 'HCType'
        }])
    });
    obj.ComboBoxHCI = new Ext.form.ComboBox({
        id: 'ComboBoxHCI',
        minChars: 1,
        store: obj.ComboBoxHCIStore,
        fieldLabel: '人员类型',
        displayField: 'HCDesc',
        valueField: 'ID',
        triggerAction: 'all'
    });
    obj.DateFieldS = new Ext.form.DateField({
        id: 'DateFieldS',
        fieldLabel: '开始日期'
    });
    obj.DateFieldE = new Ext.form.DateField({
        id: 'DateFieldE',
        fieldLabel: '结束日期'
    });
    obj.ButtonES = new Ext.Button({
        id: 'ButtonES',
        iconCls: 'icon-find',
        text: '查询'
    });
    
    obj.PanelQ1 = new Ext.Panel({
        id: 'PanelQ1',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.ComboBoxHC, obj.DateFieldS]
    });
    
    obj.PanelQ2 = new Ext.Panel({
        id: 'PanelQ2',
        defaults: {
            width: 200
        },
        buttonAlign: 'center',
        columnWidth: .5,
        layout: 'form',
        items: [obj.ComboBoxHCI, obj.DateFieldE]
    });
    
    obj.FormPanelES = new Ext.form.FormPanel({
        id: 'FormPanelES',
        buttonAlign: 'center',
        labelAlign: 'right',
        labelWidth: 80,
        defaults: {
            width: 200
        },
        height: 120,
        title: '用户检索',
        region: 'north',
        layout: 'column',
        frame: true,
        items: [obj.PanelQ1, obj.PanelQ2],
        buttons: [obj.ButtonES]
    });
//###########################################
    obj.GridPanelESStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
   
    obj.GridPanelESStore = new Ext.data.Store({
        proxy: obj.GridPanelESStoreProxy,
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
            //mapping: 'ID'
        }, {
            name: 'vBIPAPMINo',
            mapping: 'vBIPAPMINo'
            //mapping: 'BIPAPMINo'
        }, {
            name: 'vName',
            mapping: 'vName'
            //mapping: 'BIName'
        }, {
            name: 'SexDesc',
            mapping: 'SexDesc'
            //mapping: 'BICSexDR'
        }, {
            name: 'Date',
            mapping: 'Date'
            //mapping: 'BIRemark'
        }, {
            name: 'EducationDesc',
            mapping: 'EducationDesc'
            //mapping: 'BICEducationDR'
        }, {
            name: 'MaritalDesc',
            mapping: 'MaritalDesc'
            //mapping: 'BIRemark'
        },
        {
            name: 'vMobilePhone',
            mapping: 'vMobilePhone'
      
        }
        ])
    });
    /*
    obj.GridPanelESCheckCol = new Ext.grid.CheckColumn({
        header: '选择',
        dataIndex: 'checked',
        width: 50
    });
    */
     var sm=new Ext.grid.CheckboxSelectionModel;
    obj.GridPanelES = new Ext.grid.GridPanel({
        id: 'GridPanelES',
        store: obj.GridPanelESStore,
        region: 'center',
        buttonAlign: 'center',
        columns: [
        //obj.GridPanelESCheckCol
        sm
        /*
        ,{
            header: 'ID',
            width: 100,
            dataIndex: 'OQEId',
            sortable: true
        }
        */
        ,{
            header: '登记号',
            width: 100,
            dataIndex: 'vBIPAPMINo',
            sortable: true
        }, {
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
            sortable: true
        },
        {
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
			store : obj.GridPanelESStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,sm:sm
		//,plugins : obj.GridPanelESCheckCol
    });
  
    obj.ComboBoxHCStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.EvaluationStatistic';
        param.QueryName = 'FindTblTree';
        param.Arg1 = 1004;
        param.ArgCnt = 1;
    });
       obj.GridPanelESStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.MessageSend';
        param.QueryName = 'FindBaseInfoByType';
        param.Arg1 = obj.DateFieldS.getValue();
        param.Arg2 = obj.DateFieldE.getValue();
        param.Arg3 = obj.ComboBoxHCI.getValue();
        param.ArgCnt = 3;
    });
//#################################################
    
    obj.ComboBoxHCStore.load({});
    obj.ComboBoxHCIStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.HMCodeConfig';
        param.QueryName = 'FindHumClass';
        param.Arg1 = obj.ComboBoxHC.getValue();
        param.ArgCnt = 1;
    });
 
    
    obj.GridPanelESStore.load({});
    
    	obj.btClose= new Ext.Button({
		id : 'btClose'
		,iconCls : 'icon-find'
		,text : '关闭'
});

obj.btAdd = new Ext.Button({
		id : 'btAdd'
		,iconCls : 'icon-find'
		,text : '添加用户'
});
    obj.Window8 = new Ext.Window({
		id : 'Window8'
	//,closeAction :'hide'
		,height : 420
		,buttonAlign : 'center'
		,width : 900
		,region : 'center'
   	,closable:false
	 	,layout : 'border'
,modal:true
		,items:[
			obj.FormPanelES, 
			obj.GridPanelES
		]
		,buttons:[
		obj.btAdd,
		obj.btClose
		]
		,constrain:true
	});
	TheWindowsobj=obj;

	
	InitWindow8Event(obj);
     
    //事件处理代码
    obj.ComboBoxHC.on("select", obj.ComboBoxHC_select, obj);
    
    obj.ButtonES.on("click", obj.ButtonES_click, obj);
    obj.btAdd.on("click", obj.btAdd_click, obj);
    
    obj.btClose.on("click",obj.btClose_click,obj);
    obj.LoadEvent(arguments);
    return obj;
}
