function InitLateDtlWin(aParam,winTitle){
	var obj = new Object();
	obj.winTitle=winTitle;
	
	obj.LateDtlGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.LateDtlGridPanelStore = new Ext.data.Store({
		proxy: obj.LateDtlGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VolumeID'
		},[
			{name : 'VolumeID', mapping : 'VolumeID'}
			,{name : 'EpisodeID', mapping : 'EpisodeID'}
			,{name : 'PatientID', mapping : 'EpisodeID'}
			,{name : 'PatName', mapping : 'PatName'}
			,{name : 'PapmiNo', mapping : 'PapmiNo'}
			,{name : 'MrNo', mapping : 'MrNo'}
			,{name : 'Sex', mapping : 'Sex'}
			,{name : 'Age', mapping : 'Age'}
			,{name : 'IDCode', mapping : 'IDCode'}
			,{name : 'AdmitDate', mapping : 'AdmitDate'}
			,{name : 'AdmitTime', mapping : 'AdmitTime'}
			,{name : 'DischDate', mapping : 'DischDate'}
			,{name : 'DischTime', mapping : 'DischTime'}
			,{name : 'BackDate', mapping : 'BackDate'}
			,{name : 'DeptDesc', mapping : 'DeptDesc'}
			,{name : 'WardDesc', mapping : 'WardDesc'}
			,{name : 'DoctorName', mapping : 'DoctorName'}
			,{name : 'DeathDate', mapping : 'DeathDate'}
			,{name : 'LateDays', mapping : 'LateDays'}
		])
	});
	obj.LateDtlGridPanel = new Ext.grid.GridPanel({
		id : 'LateDtlGridPanel'
		,store : obj.LateDtlGridPanelStore
		,region : 'center'
		,loadMask : true
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer({width:30})
			,{header: '登记号', width: 100, dataIndex: 'PapmiNo', sortable: true}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: true}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: true}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: true}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: true}
			//,{header: '身份证号', width: 150, dataIndex: 'IDCode', sortable: true}
			,{header: '入院日期', width: 90, dataIndex: 'AdmitDate', sortable: true}
			,{header: '出院日期', width: 90, dataIndex: 'DischDate', sortable: true}
			,{header: '回收日期', width: 90, dataIndex: 'BackDate', sortable: true}
			,{header: '科室', width: 150, dataIndex: 'DeptDesc', sortable: true}
			,{header: '病区', width: 150, dataIndex: 'WardDesc', sortable: true}
			,{header: '主管医生', width: 150, dataIndex: 'DoctorName', sortable: true}
			,{header: '死亡日期', width: 150, dataIndex: 'DeathDate', sortable: true}
			,{header: '迟归天数', width: 150, dataIndex: 'LateDays', sortable: true}
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
	obj.LateDtlWin = new Ext.Window({
		id : 'LateDtlWin'
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
			obj.LateDtlGridPanel
		]
	});
	obj.LateDtlGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.VolLateQry';
		param.QueryName = 'QryVolLateStatDtl';
		param.Arg1 = aParam.Hospital;
		param.Arg2 = aParam.MrType;
		param.Arg3 = aParam.DateFrom;
		param.Arg4 = aParam.DateTo;
		param.Arg5 = aParam.LocGroup;
		param.Arg6 = aParam.LocID;
		param.Arg7 = aParam.LateDay;
		param.ArgCnt = 7;
	});
	
	InitLateDtlWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}