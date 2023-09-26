function InitfrmPathWayDicEdit(){
	var obj = new Object();
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'TypeID', mapping: 'TypeID'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'CurrVersion', mapping: 'CurrVersion'}
			,{name: 'IsOpCPW', mapping: 'IsOpCPW'}
		])
	});
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����', width: 60, dataIndex: 'Code', sortable: false}
			,{header: '����', width: 80, dataIndex: 'Desc', sortable: false}
			,{header: '·������', width: 80, dataIndex: 'TypeDesc', sortable: false}
			,{header: '�Ƿ���Ч', width: 50, dataIndex: 'IsActive', sortable: false}
			,{header: '��Ч����', width: 80, dataIndex: 'DateFrom', sortable: false}
			,{header: '��ֹ����', width: 80, dataIndex: 'DateTo', sortable: false}
			,{header: '��ǰ�汾', width: 80, dataIndex: 'CurrVersion', sortable: false}
			,{header: '����·��', width: 80, dataIndex: 'IsOpCPW', sortable: false,hidden :true}
		]
		/*,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.gridResultStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})*/
		,stripeRows : true
                ,autoExpandColumn : 'Desc'
                ,bodyStyle : 'width:100%'
                ,autoWidth : true
                ,autoScroll : true
                ,viewConfig : {
                    forceFit : true
                }
	});
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,fieldLabel : '����'
		,width : 100
		,anchor : '99%'
	});
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		,fieldLabel : '����'
		,width : 100
		,anchor : '99%'
	});
	obj.chkIsActive = new Ext.form.Checkbox({
		id : 'chkIsActive'
		,columnWidth : 0.3
		,boxLabel : '��Ч'
	});
	obj.chkIsOpCPW = new Ext.form.Checkbox({
		id : 'chkIsOpCPW'
		,columnWidth : 0.3
		,hidden : true
		,boxLabel : '����'
	});
	obj.cboPathTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboPathTypeStore = new Ext.data.Store({
		proxy: obj.cboPathTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.cboPathType = new Ext.form.ComboBox({
		id : 'cboPathType'
		,width : 100
		,anchor : '99%'
		,store : obj.cboPathTypeStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '·������'
		,valueField : 'Rowid'
		,editable : true //Modified By LiYang 2011-03-05 ���Ӱ��չؼ��ֲ�ѯ�Ĺ���
		,triggerAction : 'all'
	});
	obj.dtFrom = new Ext.form.DateField({
		id : 'dtFrom'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 100
		,fieldLabel : '��Ч����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,value : new Date()
	});
	obj.dtTo = new Ext.form.DateField({
		id : 'dtTo'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 100
		,fieldLabel : '��ֹ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,value : new Date()
	});
	obj.pnLeft = new Ext.Panel({
		id : 'pnLeft'
		,buttonAlign : 'center'
		,columnWidth : 0.1
		,layout : 'form'
		,items:[]
	});
	obj.pnCenter = new Ext.Panel({
		id : 'pnCenter'
		,buttonAlign : 'center'
		,columnWidth : 0.5
		,layout : 'form'
		,items:[
			obj.txtCode
			,obj.txtDesc
			,obj.cboPathType
		]
	});
	obj.pnBlank = new Ext.Panel({
		id : 'pnBlank'
		,columnWidth : 0.3
		,items:[
		]
	});
	obj.pnCheck = new Ext.Panel({
		id : 'pnCheck'
		,buttonAlign : 'center'
		,columnWidth : 0.3
		,layout : 'column'
		,items:[
			obj.pnBlank
			,obj.chkIsActive
			,obj.chkIsOpCPW
		]
	});
	obj.pnRight = new Ext.Panel({
		id : 'pnRight'
		,buttonAlign : 'center'
		,columnWidth : 0.3
		,layout : 'form'
		,items:[
			//obj.chkIsActive
			obj.pnCheck
			,obj.dtFrom
			,obj.dtTo
		]
	});
	
	/*
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,text : '�½�'
	});*/
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.btnLocList = new Ext.Button({
		id : 'btnLocList'
		,text : '���ÿ���'
	});
	obj.frmInfo = new Ext.form.FormPanel({
		id : 'frmInfo'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,height : 135
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.pnLeft
			,obj.pnCenter
			,obj.pnRight
		]				
		,buttons:[
			//obj.btnAdd,
			obj.btnSave
			,obj.btnLocList
		]	
	});

	obj.frmPathWayDicEdit = new Ext.Viewport({
		id : 'frmPathWayDicEdit'
		,height : 472
		,buttonAlign : 'center'
		,width : 634
		,title : '�ٴ�·���ֵ�ά��'
		,layout : 'border'
		,modal : true
		,items:[
			obj.gridResult
			,obj.frmInfo
		]
	});
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysDicSrv';
			param.QueryName = 'QryClinPathWayDic';
			param.ArgCnt = 0;
	});
	obj.gridResultStore.load({
		//params : {
		//		start : 0,
		//		limit : 20
		//	}
		});
	obj.cboPathTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWayType';
			param.QueryName = 'GetPathWayType';
			param.Arg1 = obj.cboPathType.getRawValue();//Modified By LiYang 2011-03-05 ���Ӱ��չؼ��ֲ�ѯ�Ĺ���
			param.ArgCnt = 1;
	});
	obj.cboPathTypeStore.load({});
	
	InitfrmPathWayDicEditEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}


// add by wuqk 2011-11-17 for ·�����ÿ���
function InitWinLocList(dicID,dicDesc){
	var obj = new Object();
	
	var objCPWDep = ExtTool.StaticServerObject("web.DHCCPW.MRC.DeptPahtWay");
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});
		obj.MainGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MainGridPanelStore = new Ext.data.Store({
		proxy: obj.MainGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'CTLocId', mapping: 'CTLocId'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
			,{name: 'checked', mapping: 'checked'}
		])
	});
	obj.MainGridPanelCheckCol = new Ext.grid.CheckColumn({header:'ѡ��', dataIndex: 'checked', sortable: false});
	obj.MainGridPanel = new Ext.grid.GridPanel({
		id : 'MainGridPanel'
		,store : obj.MainGridPanelStore
		,region : 'center'
		,viewConfig: {forceFit: true}
		,buttonAlign : 'center'
		,plugins : [obj.MainGridPanelCheckCol]
		,columns: [
			//{header: '����',  dataIndex: 'CategDesc', sortable: true}
			obj.MainGridPanelCheckCol
			//,{header: '����',  dataIndex: 'Code', sortable: false}
			,{header: '����',  dataIndex: 'CTLocDesc', sortable: false}
			
		]
	});
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 500
		,buttonAlign : 'center'
		,width : 380
		,layout : 'fit'
		,modal : true
		,title : '['+dicDesc+']�ĳ��ÿ���'
		,items:obj.MainGridPanel
		,buttons:[obj.btnSave]
	});
	
	obj.MainGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.DeptPahtWay';
			param.QueryName = 'QueryDepByCPW';
			param.Arg1 = dicID;
			param.Arg2 = 'E';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.MainGridPanelStore.load();
	saveCPWLoc = function(){
		//var help = Ext.getCmp("fieldHelp").getValue();
		
		var locList="";
		var locStore=obj.MainGridPanel.getStore();
		var locColumnModel=obj.MainGridPanel.getColumnModel();
		for (var rowIndex=0;rowIndex<locStore.getCount();rowIndex++){
			var objRec = locStore.getAt(rowIndex);
			var Rowid=objRec.get("Rowid");
			var CTLocId=objRec.get("CTLocId");
			var ichecked=objRec.get("checked");
			if (Rowid==""){
				if (ichecked==1){
					locList=locList+"|"+CTLocId+"^";
				}
			}
			else{
				if (ichecked!=1){
					locList=locList+Rowid+"|"+CTLocId+"^";
				}
			}
		}
		if (locList==""){
			ExtTool.alert("��ʾ", "��ѡ���ÿ���");
			return;
		}
		//alert(locList);
		var ret=objCPWDep.SaveDepCPW(dicID,locList);
		if (eval(ret)<1){
			ExtTool.alert("��ʾ", "����ʧ��,errCode="+ret);
		}
		else{
				obj.winScreen.close();
		}
	}
	obj.btnSave.on("click", saveCPWLoc);
	return obj;
}
