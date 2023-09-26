
function StepItemSubCat(){
	var obj = new Object();
	obj.ItemSubCatRowid=""
	obj.ItemRowid=""
	obj.StepItemSubCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.StepItemSubCatStore = new Ext.data.Store({
		proxy: obj.StepItemSubCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'ItemRowid', mapping: 'ItemRowid'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'SubCatPower', mapping: 'SubCatPower'}
			,{name: 'SubCatPowerDesc', mapping: 'SubCatPowerDesc'}
		])
	});
	//obj.GridPanel3CheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.StepItemSubCatGrid = new Ext.grid.GridPanel({
		id : 'StepItemSubCatGrid'
		,height : 280
		,store : obj.StepItemSubCatStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			{header: '����', width: 60, dataIndex: 'Code', sortable: true}
			,{header: '����', width: 100, dataIndex: 'Desc', sortable: true}
			,{header: '��ʼ����', width: 80, dataIndex: 'DateFrom', sortable: true}
			,{header: '��������', width: 80, dataIndex: 'DateTo', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'ItemDesc', sortable: true}
			,{header: 'Ȩ�޷���', width: 100, dataIndex: 'SubCatPowerDesc', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 10,
			store : obj.StepItemSubCatStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,stripeRows : true
                ,autoExpandColumn : 'Desc'
                ,bodyStyle : 'width:100%'
                ,autoWidth : true
                ,autoScroll : true
                ,viewConfig : {
                    forceFit : true
                }
	});
	obj.PanelSub6 = new Ext.Panel({
		id : 'PanelSub6'
		,buttonAlign : 'center'
		,width : 100
		,columnWidth : .2
		,items:[
		]
	});
	obj.ItemSubCatComStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ItemSubCatComStore = new Ext.data.Store({
		proxy: obj.ItemSubCatComStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
		])
	});
	obj.ItemSubCatCom = new Ext.form.ComboBox({
		id : 'ItemSubCatCom'
		,width : 150
		,anchor : '95%'
		,store : obj.ItemSubCatComStore
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '��������'
		,allowBlank:false
		,valueField : 'Rowid'
		,triggerAction : 'all',
		validateOnBlur:false,
		blankText:'�������಻��Ϊ��',
		editable:false
});
	obj.ItemSubCatCode = new Ext.form.TextField({
		id : 'ItemSubCatCode'
		,width : 150
		,anchor : '95%'
		,allowBlank:false
		,fieldLabel : '����',
		blankText:'���벻��Ϊ��',
		validateOnBlur:false
});
	obj.ItemSubCatDesc = new Ext.form.TextField({
		id : 'ItemSubCatDesc'
		,width : 150
		,anchor : '95%'
		,allowBlank:false
		,fieldLabel : '����',
		validateOnBlur:false,
		blankText:'��������Ϊ��'
});
	obj.ItemSubCatDateFrom = new Ext.form.DateField({
		id : 'ItemSubCatDateFrom'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 150
		,anchor : '95%'
		,allowBlank:false
		,fieldLabel : '��ʼ����',
		validateOnBlur:false,
		blankText:'��ʼ���ڲ���Ϊ��'
});
	obj.ItemSubCatDateTo = new Ext.form.DateField({
		id : 'ItemSubCatDateTo'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 150
		,anchor : '95%'
		,fieldLabel : '��������'
});
	
	obj.cboItemSubCatPowerStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboItemSubCatPowerStore = new Ext.data.Store({
		proxy: obj.cboItemSubCatPowerStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.cboItemSubCatPower = new Ext.form.ComboBox({
		id : 'cboItemSubCatPower'
		,width : 150
		,store : obj.cboItemSubCatPowerStore
		,displayField : 'DicDesc'
		,fieldLabel : 'Ȩ�����'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'DicCode'
	});
	obj.cboItemSubCatPowerStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseConfig';
			param.QueryName = 'QryBaseDic';
			param.Arg1 = "ItemSubCatPower";
			param.ArgCnt = 1;
	});
	obj.cboItemSubCatPowerStore.load({});
	
	obj.PanelSub7 = new Ext.Panel({
		id : 'PanelSub7'
		,buttonAlign : 'center'
		,width : 100
		,columnWidth : .3
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 70
		,items:[
			obj.ItemSubCatCom
			,obj.ItemSubCatCode
			,obj.ItemSubCatDesc
		]
	});
	obj.PanelSub8 = new Ext.Panel({
		id : 'PanelSub8'
		,buttonAlign : 'center'
		,width : 100
		,columnWidth : .3
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 70
		,items:[
			obj.cboItemSubCatPower
			,obj.ItemSubCatDateFrom
			,obj.ItemSubCatDateTo
		]
	});
	obj.ItemSubCatAdd = new Ext.Button({
		id : 'ItemSubCatAdd'
		,iconCls : 'icon-add'
		,text : '���'
});
	obj.ItemSubCatUpdate = new Ext.Button({
		id : 'ItemSubCatUpdate'
		,iconCls : 'icon-save'
		,text : '����'
});
	obj.ItemSubCatDelete = new Ext.Button({
		id : 'ItemSubCatDelete'
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
});
	obj.ItemSubCatClear = new Ext.Button({
		id : 'ItemSubCatClear'
		,iconCls : 'icon-cancel'
		,text : '���'
		
});
	obj.PanelSub5 = new Ext.form.FormPanel({
		id : 'PanelSub5'
		,height : 135
		,buttonAlign : 'center'
		,frame : true
		,region : 'south'
		,layout : 'column'
		,labelAlign : 'right'
		,labelWidth : 80
		,items:[
			obj.PanelSub6
			,obj.PanelSub7
			,obj.PanelSub8
		]		
		,	buttons:[
			//obj.ItemSubCatAdd
			//,
			obj.ItemSubCatUpdate
			,obj.ItemSubCatDelete
			//,obj.ItemSubCatClear
		]
	});
	obj.StepItemSubCatWindow = new Ext.Viewport({
		id : 'StepItemSubCatWindow',
		title:'�ٴ�·����Ŀ����'
		,height : 506
		,width : 600
		,layout : 'border'
		,closeAction: 'hide'
		,buttonAlign : 'center',
		resizable:false
		,closable:true
		,modal: true
		,items:[
			obj.StepItemSubCatGrid
			,obj.PanelSub5
		]

	});
	obj.StepItemSubCatStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.StepItemSubCategory';
			param.QueryName = 'GetStepItemSubCat';
			//alert(param.Arg1)
			param.Arg1=param.Arg1;
			param.Arg2=param.Arg2
			param.Arg3=param.Arg3
			param.Arg4=param.Arg4
			param.Arg5=param.Arg5
			param.ArgCnt = 5;
			//param.ArgCnt = 0
	});
	obj.StepItemSubCatStore.load({
			params:{Arg1:"",Arg2:"",Arg3:"",Arg4:"",Arg5:"",ArgCnt:5,start:0,limit:10} //update  by zf 20120408
		});
	
	obj.ItemSubCatComStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.StepItemCategory';
			param.QueryName = 'GetStepItemCat';
			param.Arg1 = 1;		// Add by zhaoyu 2013-05-02 ��Ŀ���࣬��ʼ���ڲ������� 249
			param.ArgCnt = 1;
	});
	obj.ItemSubCatComStore.load({});
	StepItemSubCatEvent(obj);
	//obj.ItemSubCatAdd.on('click',obj.AddItemSub)
	//obj.ItemSubCatClear.on('click',obj.ClearItemSubCat)
	obj.StepItemSubCatGrid.on('rowclick',obj.ItemSubCatSelect)
	
	//obj.ItemSubCatUpdate.on('click',obj.UpdateItemSub)
	obj.ItemSubCatUpdate.on('click',obj.btnSaveOnclick)
	obj.ItemSubCatDelete.on('click',obj.DeleteItemSu)
	//�¼��������
  obj.LoadEvent();
  
  return obj;
}

