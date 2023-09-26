
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
        ,fieldLabel : '�ļ��б�'
        ,columnSort : false
        ,columns: [
        {
        	header: 'ѡ��',
        	width: .1,
        	tpl:'<input type="checkbox" id="chkFileLV{ID}"></input>'
       	}
        ,{
            header: '�ļ���',
            width:.9,
            dataIndex: 'FileName'
        }
        ]
    });
    obj.lsFileListStore.loadData([]);
	
	obj.txtFilePath = new Ext.form.TextField({
		id : 'txtFilePath'
		,width : 300
		,fieldLabel : '�ļ�·��'
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
        ,fieldLabel : '��ʱ��'
        ,columnSort : false
        ,columns: [
	        { header: 'ѡ��', width: .05, tpl:'<input type="checkbox" id="chkTempFormLV{Code}"></input>' }
	        ,{ header: '����', width:.15, dataIndex: 'Code' }
	        ,{ header: '����', width:.30, dataIndex: 'Desc' }
	        ,{ header: '����', width:.10, dataIndex: 'RowCount' }
	        ,{ header: '��ܰ��ʾ', width:.40, dataIndex: 'Reminder' }
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
		,text : 'ѡ��'
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
		,text : '�����°���ļ�'
	});
	obj.btnImportFile = new Ext.Button({
		id : 'btnImportFile'
		,iconCls : 'icon-new'
		,text : '������ļ�'
	});
	obj.btnImportForm = new Ext.Button({
		id : 'btnImportForm'
		,iconCls : 'icon-add'
		,text : '������ʽ��'
	});
	obj.btnDeleteForm = new Ext.Button({
		id : 'btnDeleteForm'
		,iconCls : 'icon-delete'
		,text : 'ɾ����ʱ��'
	});
	obj.btnClose = new Ext.Button({
		id : 'btnClose'
		,iconCls : 'icon-cancel'
		,text : '�ر�'
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
		,title : '���ٴ�·��������'
		,layout : 'border'
		,modal : true
		,items:[
			obj.MainPanel
		]
	});
	
	InitWinImportClinPathWayEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

