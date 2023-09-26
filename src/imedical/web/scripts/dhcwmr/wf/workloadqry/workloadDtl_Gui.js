function InitWorkDtlWin(aParam,aUserID,aWFItemID,winTitle){
	var obj = new Object();
	
	obj.WorkDtlGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.WorkDtlGridPanelStore = new Ext.data.Store({
		proxy: obj.WorkDtlGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RecordID'
		},[
			{name : 'RecordID', mapping : 'RecordID'}
			,{name : 'VolumeID', mapping : 'VolumeID'}
			,{name : 'EpisodeID', mapping : 'EpisodeID'}
			,{name : 'PatName', mapping : 'PatName'}
			,{name : 'PapmiNo', mapping : 'PapmiNo'}
			,{name : 'MrNo', mapping : 'MrNo'}
			,{name : 'Sex', mapping : 'Sex'}
			,{name : 'Age', mapping : 'Age'}
			,{name : 'IDCode', mapping : 'IDCode'}
			,{name : 'AdmitDate', mapping : 'AdmitDate'}
			,{name : 'DischDate', mapping : 'DischDate'}
			,{name : 'BackDate', mapping : 'BackDate'}
			,{name : 'OperDate', mapping : 'OperDate'}
			,{name : 'OperTime', mapping : 'OperTime'}
			,{name : 'AdmitDeptDesc', mapping : 'AdmitDeptDesc'}
			,{name : 'AdmitWardDesc', mapping : 'AdmitWardDesc'}
			,{name : 'VPAdmitDiagnos', mapping : 'VPAdmitDiagnos'}
		])
	});
	obj.WorkDtlGridPanel = new Ext.grid.GridPanel({
		id : 'WorkDtlGridPanel'
		,store : obj.WorkDtlGridPanelStore
		,region : 'center'
		,loadMask : true
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 100, dataIndex: 'PapmiNo', sortable: true}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: true}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: true}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: true}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: true}
			//,{header: '身份证号', width: 150, dataIndex: 'IDCode', sortable: true}
			,{header: '入院日期', width: 90, dataIndex: 'AdmitDate', sortable: true}
			,{header: '出院日期', width: 90, dataIndex: 'DischDate', sortable: true}
			,{header: '回收日期', width: 90, dataIndex: 'BackDate', sortable: true}
			,{header: '科室', width: 150, dataIndex: 'AdmitDeptDesc', sortable: true}
			,{header: '病区', width: 150, dataIndex: 'AdmitWardDesc', sortable: true}
			,{header: '操作日期', width: 90, dataIndex: 'OperDate', sortable: true}
			,{header: '操作时间', width: 90, dataIndex: 'OperTime', sortable: true}
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
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 80
		,anchor : '100%'
		,text : '导出Excel'
	});
	obj.WorkDtlWin = new Ext.Window({
		id : 'WorkDtlWin'
		,plain : true
		//,maximized : true
		,resizable : false
		//,title : winTitle
		,layout : 'fit'
		,width : 1000
		,height : 500
		,modal: true
		,tbar : [
			{text:winTitle,style:'color:blue;font-size:14px;',xtype:'label'},
			'->','-',obj.btnExport,'-'
		]
		,items:[
			obj.WorkDtlGridPanel
		]
	});
	obj.WorkDtlGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.WorkloadSrv';
		param.QueryName = 'StatWorkloadDtl';
		param.Arg1 = aParam.Hospital;
		param.Arg2 = aParam.MrType;
		param.Arg3 = aParam.DateFrom;
		param.Arg4 = aParam.DateTo;
		param.Arg5 = aWFItemID;
		param.Arg6 = aUserID;
		param.ArgCnt = 6;
	});
	
	InitWorkDtlWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}