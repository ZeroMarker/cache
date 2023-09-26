
function InitMonitorViewport(){
	var obj = new Object();
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��ʼ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.dfDateFrom
		]
	});
	obj.dfDateTo = new Ext.form.DateField({
		id : 'dfDateTo'
		,width : 100
		,fieldLabel : '��������'
		,altFormats : 'Y-m-d|d/m/Y'
		,format : 'Y-m-d'
		,anchor : '99%'
		,value : new Date()
	});
	obj.pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.dfDateTo
		]
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
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'
		,columnWidth : .30
		,layout : 'form'
		,items:[
			obj.cboLoc
		]
	});
	
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,width : 80
		,clearCls : 'icon-find'
		,text : '��ѯ'
		,disabled : false
	});
	obj.pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
			obj.btnQuery
		]
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
	    	,text: '����EXCEL'
	});
	obj.pConditionChild5 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
			obj.btnExport
		]
	});
	obj.ConditionSubPanel = new Ext.form.FormPanel({
		id : 'ConditionSubPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,frame : true
		,items:[
			obj.pConditionChild1
			,obj.pConditionChild2
			,obj.pConditionChild3
			,obj.pConditionChild4
			,obj.pConditionChild5
		]
	});
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 70
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'fit'
		,title : '�ٴ�·��ͳ��'
		,items:[
			obj.ConditionSubPanel
		]
	});
	obj.ResultGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL,
			timeout:180000      //Add By Niucaicai 2011-08-10  ���س�ʱ����3����
		}));
	obj.ResultGridPanelStore = new Ext.data.Store({
		proxy: obj.ResultGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocDesc'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'CPWDesc', mapping: 'CPWDesc'}
			,{name: 'DischNum', mapping: 'DischNum'}
			,{name: 'CPWDischNum', mapping: 'CPWDischNum'}
			,{name: 'InCPWNum', mapping: 'InCPWNum'}
			,{name: 'CloseCPWNum', mapping: 'CloseCPWNum'}
			,{name: 'OutCPWNum', mapping: 'OutCPWNum'}
			,{name: 'InDays', mapping: 'InDays'}
			,{name: 'OutDays', mapping: 'OutDays'}
			,{name: 'CloseDays', mapping: 'CloseDays'}
			,{name: 'CPWRatio', mapping: 'CPWRatio'}
			,{name: 'InRatio', mapping: 'InRatio'}
			,{name: 'OutRatio', mapping: 'OutRatio'}
			,{name: 'InCost', mapping: 'InCost'}
			,{name: 'InDrugRatio', mapping: 'InDrugRatio'}
			,{name: 'CloseCost', mapping: 'CloseCost'}
			,{name: 'CloseDrugRatio', mapping: 'CloseDrugRatio'}
			,{name: 'OutCost', mapping: 'OutCost'}
			,{name: 'OutDrugRatio', mapping: 'OutDrugRatio'}
		])
	});
	obj.ResultGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ResultGridPanel = new Ext.grid.GridPanel({
		id : 'ResultGridPanel'
		,loadMask : true
		,store : obj.ResultGridPanelStore
		,region : 'center'
		,frame : true
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			//,{header: '����', width: 120, dataIndex: 'LocDesc', sortable: true}
			,{header: 'ʵʩ��������', width: 200, dataIndex: 'CPWDesc', sortable: false}
			//,{header: '���ڳ�Ժ<br>��������', width: 60, dataIndex: 'DischNum', sortable: false}
			,{header: '���ֳ�Ժ<br>����', width: 60, dataIndex: 'CPWDischNum', sortable: false}
			,{header: '�����뾶<br>�������', width: 60, dataIndex: 'InCPWNum', sortable: false}
			,{header: '�������<br>·������', width: 60, dataIndex: 'CloseCPWNum', sortable: false}
			,{header: '���ڳ���<br>�������', width: 60, dataIndex: 'OutCPWNum', sortable: false}
			,{header: '�뾶����<br>ƽ��סԺ<br>��', width: 60, dataIndex: 'InDays', sortable: false}
			,{header: '��������<br>ƽ��סԺ<br>��', width: 60, dataIndex: 'OutDays', sortable: false}
			,{header: '���·��<br>����ƽ��<br>סԺ��', width: 60, dataIndex: 'CloseDays', sortable: false}
			//,{header: '������%', width: 60, dataIndex: 'CPWRatio', sortable: false}
			,{header: '�뾶��%', width: 60, dataIndex: 'InRatio', sortable: false}
			,{header: '������%', width: 60, dataIndex: 'OutRatio', sortable: false}
			,{header: '�뾶����<br>�ξ�����', width: 60, dataIndex: 'InCost', sortable: false}
			,{header: '�뾶����<br>ҩƷ����<br>��ռ����<br>(%)', width: 60, dataIndex: 'InDrugRatio', sortable: false}
			,{header: '���·��<br>���˴ξ�<br>����', width: 60, dataIndex: 'CloseCost', sortable: false}
			,{header: '���·��<br>����ҩƷ<br>������ռ<br>����(%)', width: 60, dataIndex: 'CloseDrugRatio', sortable: false}
			,{header: '��������<br>�ξ�����', width: 60, dataIndex: 'OutCost', sortable: false}
			,{header: '��������<br>ҩƷ����<br>��ռ����<br>(%)', width: 60, dataIndex: 'OutDrugRatio', sortable: false}
		]
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	obj.MonitorViewport = new Ext.Viewport({
		id : 'MonitorViewport'
		,region : document.body
		,layout : 'border'
		,items:[
			obj.ConditionPanel
			,obj.ResultGridPanel
		]
	});
	
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	//obj.cboLocStore.load({});
	
	obj.ResultGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWaysAnalysis';
			param.QueryName = 'QryCPWDischStat';
			param.Arg1 = obj.dfDateFrom.getRawValue();
			param.Arg2 = obj.dfDateTo.getRawValue();
			param.Arg3 = obj.cboLoc.getValue();
			param.ArgCnt = 3;
	});
	InitMonitorViewportEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

