
function InitWinImportClinPathWay(){
	var obj = new Object();
	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,columnWidth : .01
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
        ,width : 300
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
	
	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,columnWidth : .89
		,layout : 'form'
		,items:[
			obj.txtFilePath
			,obj.lsFileList
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
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.btnSelect
		]
	});
	
	obj.btnImportFile = new Ext.Button({
		id : 'btnImportFile'
		,iconCls : 'icon-new'
		,text : '导入表单文件'
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
		,layout : 'column'
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
			obj.btnImportFile
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

