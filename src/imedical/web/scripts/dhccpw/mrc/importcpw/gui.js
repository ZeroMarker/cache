
function InitWinImportClinPathWay(){
	var obj = new Object();
	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,region : 'west'
		,width:'10'
		,layout : 'form'
		,items:[
		]
	});
	
	obj.lsFileListStore = new Ext.data.Store({
		reader: new Ext.data.ArrayReader({id:0},
		[
			{name: 'ID', mapping: 0}
			,{name: 'FileName', mapping: 1}
		])
	});
	obj.lsFileList = new Ext.list.ListView({
		id : 'lsFileList'
        ,store: obj.lsFileListStore
        ,multiSelect: false
        ,reserveScrollOffset: true
        ,hideLabel: false
        ,hideHeaders: false
        ,height : 200
        ,anchor : '98%'
        ,fieldLabel : '文件列表'
        ,columnSort : false
        ,columns: [
        {
        	header: '选择',
        	width: .1,
        	tpl:'<input type="checkbox" id="chkFileLV{ID}"></input>'
       	}
        ,{
            header: '文件名',
            width:.9,
            dataIndex: 'FileName'
        }
        ]
    });
    obj.lsFileListStore.loadData([]);
	
	obj.txtFilePath = new Ext.form.TextField({
		id : 'txtFilePath'
		,width : 300
		,fieldLabel : '文件路径'
		,anchor : '98%'
		,disabled : true
	});
	
	obj.lsTempFormStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.lsTempFormStore = new Ext.data.Store({
		proxy: obj.lsTempFormStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Code'
		}, 
		[
			{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'RowCount', mapping: 'RowCount'}
			,{name: 'Reminder', mapping: 'Reminder'}
		])
	});
	obj.lsTempForm = new Ext.list.ListView({
		id : 'lsTempForm'
        ,store: obj.lsTempFormStore
        ,multiSelect: false
        ,reserveScrollOffset: true
        ,hideLabel: false
        ,hideHeaders: false
        ,height : 300
        ,anchor : '98%'
        ,fieldLabel : '临时表单'
        ,columnSort : false
        ,columns: [
	        { header: '选择', width: .05, tpl:'<input type="checkbox" id="chkTempFormLV{Code}"></input>' }
	        ,{ header: '代码', width:.15, dataIndex: 'Code' }
	        ,{ header: '描述', width:.30, dataIndex: 'Desc' }
	        ,{ header: '行数', width:.10, dataIndex: 'RowCount' }
	        ,{ header: '温馨提示', width:.40, dataIndex: 'Reminder' }
        ]
    });
    obj.lsTempFormStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ImportPathWay';
			param.QueryName = 'QryTempFormData';
			param.ArgCnt = 0;
	});
	obj.lsTempFormStore.load({});

	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,region:'center'
		,layout : 'border'
		,items:[{
				region:'north'
				,height: 30
				,layout:'form'
				,items:[obj.txtFilePath]
			},{
				region:'center'
				,height: 300
				,layout: 'form'
				,items:[obj.lsFileList]
			},{
				region:'south'
				,height: 320
				,layout:'form'
				,items:[obj.lsTempForm]
			}
		]
	});
	
	obj.btnSelect = new Ext.Button({
		id : 'btnSelect'
		,itemCls : 'icon-save'
		,text : '选择'
		,anchor : '98%'
	});
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,region : 'east'
		,width:'80'
		,layout : 'form'
		,items:[
			obj.btnSelect
		]
	});
	
	obj.btnImportFileNew = new Ext.Button({
		id : 'btnImportFileNew'
		,iconCls : 'icon-new'
		,text : '导入新版表单文件'
	});
	obj.btnImportFile = new Ext.Button({
		id : 'btnImportFile'
		,iconCls : 'icon-new'
		,text : '导入表单文件'
	});
	obj.btnImportForm = new Ext.Button({
		id : 'btnImportForm'
		,iconCls : 'icon-add'
		,text : '导入正式表单'
	});
	obj.btnDeleteForm = new Ext.Button({
		id : 'btnDeleteForm'
		,iconCls : 'icon-delete'
		,text : '删除临时表单'
	});
	obj.btnClose = new Ext.Button({
		id : 'btnClose'
		,iconCls : 'icon-cancel'
		,text : '关闭'
		,listeners: {
	        click: function() {
	        	obj.WinImportClinPathWay.close();
	        }
	    }
	});
	
	obj.MainPanel = new Ext.form.FormPanel({
		id : 'MainPanel'
		,height:180
		,buttonAlign : 'center'
		,layout : 'border'
		,labelAlign : 'right'
		,frame:true
		,region : 'center'
		,labelWidth : 60
		,items:[
			obj.SubPanel1
			,obj.SubPanel2
			,obj.SubPanel3
		]
		,buttons:[
			obj.btnImportFileNew,
			obj.btnImportFile
			,obj.btnImportForm
			,obj.btnDeleteForm
			//,obj.btnClose     //removed by wuqk 2011-07-26 for bug 86
		]
	});
		
	obj.WinImportClinPathWay = new Ext.Viewport({
		id : 'WinImportClinPathWay'
		,height : 460
		,buttonAlign : 'center'
		,width : 600
		,title : '导临床路径表单数据'
		,layout : 'border'
		,modal : true
		,items:[
			obj.MainPanel
		]
	});
	
	InitWinImportClinPathWayEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

