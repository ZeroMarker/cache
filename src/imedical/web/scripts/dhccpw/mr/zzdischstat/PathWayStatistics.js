function PathWayStatistics(){
	var obj = new Object();
	obj.dtDateFrom = new Ext.form.DateField({
		id : 'dtDateFrom'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 100
		,fieldLabel : '��ʼ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	
	obj.dtDateTo = new Ext.form.DateField({
		id : 'dtDateTo'
		,width : 100
		,fieldLabel : '��������'
		,altFormats : 'Y-m-d|d/m/Y'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,anchor : '99%'
		,value : new Date()
	});
	
	obj.btnFind  = new Ext.Button({
		id : 'btnFind',
		text: '��ѯ',
		width : 80,
		iconCls : 'icon-find'
		,handler : function() { obj.gridDischStatStore.load(); }
	});
	
	obj.btnExport  = new Ext.Toolbar.Button({
		id : 'btnExport',
		text: '<b>����EXCEL<b>',
		iconCls : 'icon-export'
	});
	
	obj.gridDischStatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridDischStatStore = new Ext.data.Store({
		proxy: obj.gridDischStatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CtRowid'
		},
		[
			{name:'CtRowid',mapping:'CtRowid'},
			{name:'CtDesc',mapping:'CtDesc'},
			{name:'CTLOCNum',mapping:'CTLOCNum'},
			{name:'pathWayPerson',mapping:'pathWayPerson'},
			{name:'pathWayCtlocPercent',mapping:'pathWayCtlocPercent'},
			{name:'CTLOPercent',mapping:'CTLOPercent'},
			{name:'pathWayPercent',mapping:'pathWayPercent'},
			{name:'pathWayNum',mapping:'pathWayNum'},
			{name:'CTLOCDayAverage',mapping:'CTLOCDayAverage'},
			{name:'CTLOCConstAverage',mapping:'CTLOCConstAverage'},
			{name:'pathDayAverage',mapping:'pathDayAverage'},
			{name:'pathConstAverage',mapping:'pathConstAverage'}
		])
	});
	obj.gridDischStat = new Ext.grid.GridPanel({
		id : 'gridDischStat'
		,store : obj.gridDischStatStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,frame : true
		,bbar : ['��Ժͳ���б�����',obj.btnExport]
		,columns: [
			{header:'��������', width: 152,dataIndex:'CtDesc',sortable:true, align: 'center'},
			{header:'��Ժ����', width: 80,dataIndex:'CTLOCNum',sortable:true, align: 'center'},
			{header:'�뾶����', width: 80,dataIndex:'pathWayPerson',sortable:true, align: 'center'},
			{header:'�뾶��', width: 80,dataIndex:'pathWayCtlocPercent',sortable:true, align: 'center'},
			{header:'��Ժ������', width: 80,dataIndex:'CTLOPercent',sortable:true, align: 'center'},
			{header:'�뾶������', width: 80,dataIndex:'pathWayPercent',sortable:true, align: 'center'},
			{header:'·����', width: 60,dataIndex:'pathWayNum',sortable:true, align: 'center'},
			{header:'ƽ��סԺ��', width: 60,dataIndex:'CTLOCDayAverage',sortable:true, align: 'center'},
			{header:'ƽ������', width: 80,dataIndex:'CTLOCConstAverage',sortable:true, align: 'center'},
			{header:'�뾶ƽ��סԺ��', width: 100,dataIndex:'pathDayAverage',sortable:true, align: 'center'},
			{header:'�뾶ƽ������', width: 100,dataIndex:'pathConstAverage',sortable:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
			,getRowClass : function(record,rowIndex,rowParams,store){
				if(record.get('pathWayPerson')){
					if(record.get('pathWayPerson')!=0){
                   		return 'x-grid-record'
					}
                }
			}
		}
    });
	
	obj.StaViewMain = new Ext.Viewport({
		id : 'StaViewMain'
		,layout : 'border'
		,items:[
			obj.gridDischStat
			,{
				region: 'north',
				height: 35,
				layout : 'form',
				frame : true,
				items : [
					{
						layout : 'column',
						items : [
							{
								width : 200
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.dtDateFrom]
							},{
								width : 200
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.dtDateTo]
							},{
								width : 80
								,layout : 'form'
								,items: [obj.btnFind]
							}
						]
					}
				]
			}
		]
	});
	
	obj.gridDischStatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.ClinPathWaysStat';
		param.QueryName = 'QryDischStat';
		param.Arg1 = obj.dtDateFrom.getRawValue();
		param.Arg2 = obj.dtDateTo.getRawValue();
		param.ArgCnt = 2;
	});
	
	PathWayStatisticsEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function InitviewSubWindow(DateFrom,DateTo,CTLocID,Title){
	var obj = new Object();
	
	obj.btnDtlExport  = new Ext.Toolbar.Button({
		id : 'btnDtlExport',
		text: '<b>����EXCEL<b>',
		iconCls : 'icon-export'
	});
	
	obj.gridDischStatDtlStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridDischStatDtlStore = new Ext.data.GroupingStore({
		proxy: obj.gridDischStatDtlStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'admId'
		},
		[
			{name:'CtRowid',mapping:'CtRowid'},
			{name:'admId',mapping:'admId'},
			{name:'cpwRowid',mapping:'cpwRowid'},
			{name:'pathRowid',mapping:'pathRowid'},
			{name:'PatientId',mapping:'PatientId'},
			{name:'PAPMIName',mapping:'PAPMIName'},
			{name:'sex',mapping:'sex'},
			{name:'PAPMIAge',mapping:'PAPMIAge'},
			{name:'PAAdmDocCodeDR',mapping:'PAAdmDocCodeDR'},
			{name:'admDate',mapping:'admDate'},
			{name:'DischgDate',mapping:'DischgDate'},
			{name:'cpwInDate',mapping:'cpwInDate'},
			{name:'cpwOutDate',mapping:'cpwOutDate'},
			{name:'days',mapping:'days'},
			{name:'const1',mapping:'const1'},
			{name:'ImplItemRatio',mapping:'ImplItemRatio'},
			{name:'CheckVar',mapping:'CheckVar'},
			{name:'pathStr',mapping:'pathStr'},
			{name:'DrugRatio',mapping:'DrugRatio'}
		])
		,sortInfo:{field: 'cpwRowid', direction: "ASC"}
		,groupField:'pathStr'
	});
	
	obj.gridDischStatDtl = new Ext.grid.GridPanel({
		id : 'gridDischStatDtl'
		,store : obj.gridDischStatDtlStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,frame : true
		,view: new Ext.grid.GroupingView({
			groupTextTpl:'{[values.rs[0].get("pathStr")]}',
			groupByText:'�����з���'
		})
		,bbar : ['��Ժ����-���뾶��ϸ�б�����',obj.btnDtlExport]
		,columns: [
			{header:'��������',width:80,dataIndex:'PAPMIName',sortable:true, align: 'center'},
			{header:'�Ա�',width:50,dataIndex:'sex',sortable:true, align: 'center'},
			{header:'����',width:50,dataIndex:'PAPMIAge',sortable:true, align: 'center'},
			{header:'ҽ��',width:80,dataIndex:'PAAdmDocCodeDR',sortable:true, align: 'center'},
			{header:'סԺ����',width:80,dataIndex:'admDate',sortable:true, align: 'center'},
			{header:'��Ժ����',width:80,dataIndex:'DischgDate',sortable:true, align: 'center'},
			{header:'�뾶����',width:80,dataIndex:'cpwInDate',sortable:true, align: 'center'},
			{header:'��������',width:80,dataIndex:'cpwOutDate',sortable:true, align: 'center'},
			{header:'סԺ��',width:60,dataIndex:'days',sortable:true, align: 'center'},
			{header:'סԺ����',width:80,dataIndex:'const1',sortable:true, align: 'center'},
			{header:'ҩ�ѱ���',width:80,dataIndex:'DrugRatio',sortable:true, align: 'center'},
			{header:'��ִ����Ŀ����',width:100,dataIndex:'ImplItemRatio',sortable:true, align: 'center'},
			{header:'�Ƿ����',width:80,dataIndex:'CheckVar',sortable:true, align: 'center'},
			{header:'�ٴ�·��',width:80,dataIndex:'pathRowid',sortable:true,hidden:true, align: 'center'},
			{header:'������Ϣ',width:80,dataIndex:'pathStr',sortable:true,hidden:true, align: 'center'}
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
	
	obj.DtlSubWindow = new Ext.Window({
		id : 'DtlSubWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : true
		,resizable : false
		,title : '��Ժ����-���뾶��ϸ�б�' + '[' + Title + ']'
		,layout : 'fit'
		,modal: true
		,items:[
			obj.gridDischStatDtl
		]
	});
	
	obj.gridDischStatDtlStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.ClinPathWaysStat';
		param.QueryName = 'QryDischStatDetail';
		param.Arg1 = DateFrom;
		param.Arg2 = DateTo;
		param.Arg3 = CTLocID;
		param.ArgCnt = 3;
	});
	
	InitviewSubWindowEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

