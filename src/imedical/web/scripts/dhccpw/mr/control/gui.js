function InitviewScreen(){
	var obj = new Object();
		obj.dtFromDate = new Ext.form.DateField({
		id : 'dtFromDate'
		,value : new Date()
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,fieldLabel : '��ʼ����'
		,width : 100
		,anchor : '99%'
	});
	obj.cboPathWayDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboPathWayDicStore = new Ext.data.Store({
		proxy: obj.cboPathWayDicStoreProxy,
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
		])
	});
	obj.cboPathWayDic = new Ext.form.ComboBox({
		id : 'cboPathWayDic'
		,minChars : 1
		,store : obj.cboPathWayDicStore
		,valueField : 'ID'
		,fieldLabel : '�ٴ�·���ֵ�'
		,displayField : 'Desc'
		,triggerAction : 'all'
		,width : 100
		,anchor : '99%'
	});
	
	obj.dtToDate = new Ext.form.DateField({
		id : 'dtToDate'
		,value : new Date()
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,fieldLabel : '��������'
		,width : 100
		,anchor : '99%'
	});
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,minChars : 1
		,store : obj.cboLocStore
		,valueField : 'CTLocID'
		,fieldLabel : '����'
		,displayField : 'CTLocDesc'
		,triggerAction : 'all'
		,width : 100
		,anchor : '99%'
	});
	
	obj.pnCol1 = new Ext.Panel({
		id : 'pnCol1'
		,buttonAlign : 'center'
		,columnWidth : 0.20
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 70
		,items:[
			obj.dtFromDate
		]
	});
	
	obj.pnCol2 = new Ext.Panel({
		id : 'pnCol2'
		,buttonAlign : 'center'
		,columnWidth : 0.20
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 70
		,items:[
			obj.dtToDate
		]
	});
	
	obj.pnCol3 = new Ext.Panel({
		id : 'pnCol3'
		,buttonAlign : 'center'
		,columnWidth : 0.25
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 90
		,items:[
			obj.cboPathWayDic
		]
	});
	
	obj.pnCol4 = new Ext.Panel({
		id : 'pnCol4'
		,buttonAlign : 'center'
		,columnWidth : 0.25
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 50
		,items:[
			obj.cboLoc
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,itemCls : 'icon-find'
		,text : '��ѯ'
		,width : 60
	});
	obj.pnCol5 = new Ext.Panel({
		id : 'pnCol5'
		,buttonAlign : 'center'
		,columnWidth : 0.10
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 50
		,items:[
			obj.btnQuery
		]
	});
	
	obj.pnCpwCondition = new Ext.Panel({
		id : 'pnCpwCondition'
		,region : "north"
		,buttonAlign : 'center'
		,height : 40
		,frame : true
		,layout : 'column'
		,items:[
			obj.pnCol1
			,obj.pnCol2
			,obj.pnCol3
			,obj.pnCol4
			,obj.pnCol5
		]
	});
	
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL,
			timeout:180000      //Add By Niucaicai 2011-08-10  ���س�ʱ����3����
		}));
		
	var expander = new Ext.ux.grid.RowExpander({
		lazyRender : true,
		enableCaching : true,
      	tpl : new Ext.Template(
            '<iframe border=0 src="./dhccpw.mr.controldetail.csp?Adm={Paadm}&VersionID={PathWayVerID}&PathWayID={PathWayID}" height=400 width="100%"/>'
        )
        //html:'<iframe border=0 src="./dhccpw.mr.controldetail.csp?Adm={Paadm}&VersionID={PathWayVerID}&PathWayID={PathWayID}" height=400 width="100%"/>'
    });
		
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PathWayID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'Paadm', mapping: 'Paadm'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'Loc', mapping: 'Loc'}
			,{name: 'Ward', mapping: 'Ward'}
			,{name: 'Days', mapping: 'Days'}
			,{name: 'InPathDate', mapping: 'InPathDate'}
			,{name: 'PathName', mapping: 'PathName'}
			,{name: 'InDays', mapping: 'InDays'}
			,{name: 'CurrStatus', mapping: 'CurrStatus'}
			,{name: 'OutDate', mapping: 'OutDate'}
			,{name: 'Reason', mapping: 'Reason'}
			,{name: 'PathWayVerID', mapping: 'PathWayVerID'}
			,{name: 'repid', mapping: 'repid'}
			,{name: 'PathWayID', mapping: 'PathWayID'}
			,{name: 'CurrentFee', CurrentFee: 'CurrentFee'}
			,{name: 'CurrentFeePercent', CurrentFee: 'CurrentFeePercent'}
			,{name: 'FiredItem', CurrentFee: 'FiredItem'}
		])
	});
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		//,plugins: expander
		,loadMask : {msg : '���ڶ�ȡ�У����Ժ�...'}
		,columns: [
			//expander,
			new Ext.grid.RowNumberer()
			,{header: '��������', width : 80, dataIndex : 'FiredItem', renderer:
				function(value)
				{
					var strRet = "";
					if(value.indexOf("ҽ��") > -1)
						strRet += "<img src='../images/webemr/orders.gif' alt='ҽ����ش���'/>";
					if(value.indexOf("����") > -1)
						strRet += "<img src='../images/webemr/owe.gif' alt='���ó���'/>";
					if(value.indexOf("סԺ��") > -1)
						strRet += "<img src='../images/webemr/Warning Time.gif' alt='סԺ�ճ���'/>";
					return strRet;
				}
			}
			,{header: '�ǼǺ�', width: 80, dataIndex: 'RegNo', sortable: true}
			,{header: '����', width: 80, dataIndex: 'PatientName', sortable: true}
			,{header: '�Ա�', width: 50, dataIndex: 'Sex', sortable: true}
			,{header: '����', width: 50, dataIndex: 'Age', sortable: true}
			,{header: 'סԺ����', width: 80, dataIndex: 'AdmitDate', sortable: true}
			,{header: '��Ժ����', width: 80, dataIndex: 'DisDate', sortable: true}
			,{header: '����', width: 80, dataIndex: 'Loc', sortable: true}
			,{header: '����', width: 80, dataIndex: 'Ward', sortable: true}
			,{header: 'סԺ����', width: 60, dataIndex: 'Days', sortable: true}
			,{header: '�뾶����', width: 80, dataIndex: 'InPathDate', sortable: true}
			,{header: '·������', width: 80, dataIndex: 'PathName', sortable: true}
			,{header: '�뾶����', width: 60, dataIndex: 'InDays', sortable: true}
			,{header: '��ǰ״̬', width: 60, dataIndex: 'CurrStatus', sortable: true}
			,{header: '��������', width: 80, dataIndex: 'OutDate', sortable: true}
			,{header: '����ԭ��', width: 80, dataIndex: 'Reason', sortable: true}
			,{header: '��ǰ����', width: 80, dataIndex: 'CurrentFee', sortable: true}
			,{header: '��ǰ���ѱȣ�ռ���Ʒ��ã�', width: 80, dataIndex: 'CurrentFeePercent', sortable: true}
		]});
	obj.pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,region : "center"
		,buttonAlign : 'center'
		,frame : true
		,layout : 'fit'
		,items:[
			obj.gridResult
		]
	});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			obj.pnCpwCondition,
			obj.pnScreen
		]
	});

	obj.cboPathWayDicStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysDicSrv';
			param.QueryName = 'QryClinPathWayDic';
			param.Arg1 = 'N';
			param.Arg2 = 'Y';
			param.ArgCnt = 2;      //add by wuqk 2011-11-19 ������Ч·�������˲���֢
	});
	obj.cboPathWayDicStore.load();
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = '';
			param.Arg2 = 'E';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.cboLocStore.load();

	InitviewScreenEvent(obj);
	//�¼��������
	obj.gridResult.on("rowdblclick", obj.gridResult_rowdblclick, obj);
	obj.LoadEvent(arguments);
	return obj;
}

