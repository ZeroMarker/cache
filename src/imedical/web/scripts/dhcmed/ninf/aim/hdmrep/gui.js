var EpisodeID="";
var PatientID="";
function InitVpInfPatientAdm(SubjectID,HDMFlag){
	var obj = new Object();
	
	obj.selLocDr = "";
	obj.selWardDr = "";
	obj.SubjectID = SubjectID;
	obj.aCtrls="";
	
	/* update by zf 2012-11-01
	Ext.apply(Ext.form.VTypes, {
        daterange : function(val, field) {
			var date = field.parseDate(val);
			if(!date){
				return false;
			}
			
			if (field.startDateField && (!this.dateRangeMax || (date.getTime() != this.dateRangeMax.getTime()))) {
				var start = Ext.getCmp(field.startDateField);
				start.setMaxValue(date);
				start.validate();
				this.dateRangeMax = date;
			} else if (field.endDateField && (!this.dateRangeMin || (date.getTime() != this.dateRangeMin.getTime()))) {
				var end = Ext.getCmp(field.endDateField);
				end.setMinValue(date);
				end.validate();
				this.dateRangeMin = date;
			}
			
			return true;
		},
		
		password : function(val, field) {
			if (field.initialPassField) {
				var pwd = Ext.getCmp(field.initialPassField);
				return (val == pwd.getValue());
			}
			return true;
		},
		passwordText : 'Passwords do not match'
    });
 	*/
	
	obj.expCtrlDetail = new Ext.ux.grid.RowExpander({
        tpl : new Ext.Template(
            '<p>{DataDetail}</p><br>'
        )
    });

	
	obj.BtnExport = new Ext.Toolbar.Button({
		id : 'BtnExport'
		,iconCls: 'icon-export'
		,width : 80
		,text:'导出登记表'
	});
	
	obj.grdPatAdmListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
		,timeout: 300000
		,method:'POST'
	}));
	obj.grdPatAdmListStore = new Ext.data.Store({
		proxy: obj.grdPatAdmListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Paadm'
		},  
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Paadm', mapping: 'Paadm'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'Room', mapping: 'Room'}
			,{name: 'Bed', mapping: 'Bed'}
			,{name: 'DoctorName', mapping: 'DoctorName'}
			,{name: 'Paadm', mapping: 'Paadm'}
			,{name: 'Department', mapping: 'Department'}
			,{name: 'Ward', mapping: 'Ward'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'RepInfo',mapping: 'RepInfo'}
			,{name: 'DepartmentID',mapping: 'DepartmentID'}
			,{name: 'WardID',mapping: 'WardID'}
			,{name: 'DataDetail',mapping:'DataDetail'}
		])
	});
	obj.grdPatAdmListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.grdPatAdmList = new Ext.grid.GridPanel({
		id : 'grdPatAdmList'
		,loadMask : true
		,store : obj.grdPatAdmListStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			{header: '登记号', width: 80, dataIndex: 'RegNo', sortable: true}
			,{header: '姓名', width: 80, dataIndex: 'PatientName', sortable: true}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: true}
			,{header: '性<br>别', width: 30, dataIndex: 'Sex', sortable: true}
			,{header: '主管医生', width: 60, dataIndex: 'DoctorName', sortable: true}
			,{header: '科室', width: 100, dataIndex: 'Department', sortable: true}
			,{header: '病区', width: 100, dataIndex: 'Ward', sortable: true}
			,{header: '病床', width: 40, dataIndex: 'Bed', sortable: true}
			,{header: '入院日期', width: 80, dataIndex: 'AdmitDate', sortable: true}
			,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: true}
			,{header: '报告信息', width:100, dataIndex:'RepInfo'}
		]
		,tbar : ["<b><font color='blue'>横断面床旁登记表</font><b>","-",obj.BtnExport,"-"]
		,bbar: new Ext.PagingToolbar({
			pageSize : 500,
			store : obj.grdPatAdmListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,plugins: obj.expCtrlDetail
		,iconCls: 'icon-grid'
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
			,getRowClass : function(record,rowIndex,rowParams,store){
				if (record.data.Points=="1") {
					return 'x-grid-record-green';
				} else if (record.data.ErrFlag=="2") {
					return 'x-grid-record-red';
				} else {
					return '';
				}
			}
		}
	});
	
	obj.grdPatAdmRepListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.grdPatAdmRepListStore = new Ext.data.Store({
		proxy: obj.grdPatAdmRepListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		},  
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'InstanceID', mapping: 'InstanceID'}
			,{name: 'RepStatus', mapping: 'RepStatus'}
			,{name: 'RepDoc', mapping: 'RepDoc'}
			,{name: 'RepCtloc', mapping: 'RepCtloc'}
			,{name: 'RepDate', mapping: 'RepDate'}
			,{name: 'CheckDate', mapping: 'CheckDate'}
			,{name: 'CheckUser', mapping: 'CheckUser'}
			,{name: 'PrintDocID', mapping: 'PrintDocID'}
			,{name: 'TemplateDocID', mapping: 'TemplateDocID'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	obj.grdPatAdmRepListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.grdPatAdmRepList = new Ext.grid.GridPanel({
		id : 'grdPatAdmRepList'
		,store : obj.grdPatAdmRepListStore
		,buttonAlign : 'center'
		,region : 'south'
		,height : 150
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '报告类型', width: 100, dataIndex: 'Description', sortable: true}
			,{header: '报告状态', width: 100, dataIndex: 'RepStatus', sortable: true}
			,{header: '报告人', width: 100, dataIndex: 'RepDoc', sortable: true}
			,{header: '报告科室', width: 120, dataIndex: 'RepCtloc', sortable: true}
			,{header: '报告日期', width: 100, dataIndex: 'RepDate', sortable: true}
			,{header: '审核日期', width: 100, dataIndex: 'CheckDate', sortable: true}
			,{header: '审核人', width: 100, dataIndex: 'CheckUser', sortable: true}
		]
		,tbar : ["<b><font color='blue'>横断面个案登记表</font><b>"]
		,viewConfig : {
            		forceFit : true
        	}
	});
	obj.PanCenterPad = new Ext.Panel({
		id : 'PanCenterPad'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,layout : 'border'
		,items:[
			obj.grdPatAdmRepList
			,obj.grdPatAdmList
		]
	});
	
	obj.InHospital = new Ext.form.Checkbox({
		id : 'InHospital'
		,checked : true
		,fieldLabel : '在院'
		,anchor : '98%'
	});

	obj.IsReport = new Ext.form.Checkbox({
		id : 'IsReport'
		,checked : true
		,fieldLabel : '过滤已报'
		,anchor : '98%'
	});
	
	obj.MrNo = new Ext.form.TextField({
		id : 'MrNo'
		,fieldLabel : '病案号'
		,anchor : '98%'
	});
	obj.RegNo = new Ext.form.TextField({
		id : 'RegNo'
		,fieldLabel : '登记号'
		,anchor : '98%'
	});
	obj.DateFrom = new Ext.form.DateField({
		id : 'DateFrom'
		,fieldLabel : '开始日期'
		,anchor : '98%'
		,format: 'Y-m-d'
	});
	obj.DateTo = new Ext.form.DateField({
		id : 'DateTo'
		,fieldLabel : '结束日期'
		,anchor : '98%'
		,format: 'Y-m-d'
	});
	obj.LocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.LocStore = new Ext.data.Store({
		proxy: obj.LocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.Loc = new Ext.form.ComboBox({
		id : 'Loc'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '科室'
		,mode : 'local'
		,store : obj.LocStore
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '98%'
		,valueField : 'Rowid'
	});
	obj.WardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.WardStore = new Ext.data.Store({
		proxy: obj.WardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.Ward = new Ext.form.ComboBox({
		id : 'Ward'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '病区'
		,store : obj.WardStore
		//,mode : 'local'  remote
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '98%'
		,valueField : 'Rowid'
	});
	obj.PatName = new Ext.form.TextField({
		id : 'PatName'
		,fieldLabel : '姓名'
		,anchor : '98%'
	});
	
	obj.BtnFind = new Ext.Button({
		id : 'BtnFind'
		,iconCls : 'icon-find'
		,width : 80
		,text : '查询'
	});
	
	obj.PanColCenterPad1 = new Ext.Panel({
		id : 'PanColCenterPad1'
		,buttonAlign : 'center'
		,width : 1
		,layout : 'form'
		,items:[]
	});
	obj.PanColCenterPad2 = new Ext.Panel({
		id : 'PanColCenterPad2'
		,buttonAlign : 'center'
		,columnWidth : 1
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 60
		,items:[
			//obj.InHospital
			obj.RegNo
			,obj.MrNo
			,obj.PatName
			,obj.Loc
			,obj.Ward
			,obj.DateFrom
			,obj.DateTo
			,obj.IsReport
		]
		,buttons:[
			obj.BtnFind
		]
	});
	obj.PanColCenterPad3 = new Ext.Panel({
		id : 'PanColCenterPad3'
		,buttonAlign : 'center'
		,width : 1
		,layout : 'form'
		,items:[]
	});
	
	obj.ConditionPanel = new Ext.Panel({
		id: 'ConditionPanel'
		,title: '患者查询'
		,collapsible : true
		,split:true
		,border:true
		,width:240
		,minSize: 240
		,maxSize: 240
		,layoutConfig: {animate: true}
		,region: 'west'
		,layout: 'column'
		,frame : true
		,items:[
			obj.PanColCenterPad1
			,obj.PanColCenterPad2
			,obj.PanColCenterPad3
		]
	});
	
	obj.VpInfPatientAdm = new Ext.Viewport({
		id : 'VpInfPatientAdm'
		,layout : 'border'
		,items:[
			obj.PanCenterPad
			,obj.ConditionPanel
		]
	});
	
	
	obj.LocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Aim.BasePatInfoQuery';
		param.QueryName = 'QueryCtloc';
		param.Arg1 = 'E';
		param.ArgCnt = 1;
	});
	obj.LocStore.load({});
	obj.WardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Aim.BasePatInfoQuery';
			param.QueryName = 'QueryAllWard';
			param.Arg1 = obj.Ward.getValue();
			param.Arg2 = obj.Loc.getValue();
			param.ArgCnt = 2;
	});
	obj.WardStore.load({});
	obj.grdPatAdmListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Aim.ICUSrv';
		param.QueryName = 'QueryPatientInfo';
		param.Arg1 = (obj.InHospital.getValue()? "A":"D");		//是否在院
		param.Arg2 = obj.MrNo.getValue();
		param.Arg3 = obj.RegNo.getValue();
		param.Arg4 = obj.DateFrom.getValue();
		param.Arg5 = obj.DateTo.getValue();
		param.Arg6 = obj.Loc.getValue();
		param.Arg7 = obj.Ward.getValue();
		param.Arg8 = obj.PatName.getValue();
		param.Arg9 = "";
		param.Arg10 = "I";		// 住院类型 I/O/E  以"/"分割
		param.Arg11 = "";
		param.Arg12 = "";
		param.Arg13 = "1";
		param.Arg14 = (obj.IsReport.getValue()?"Y":"N");	//横断面是否已上报
		param.ArgCnt = 14;
	});
	obj.grdPatAdmRepListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Aim.ICUSrv';
		param.QueryName = 'QueryEPRByEpisodeID';
		param.Arg1 = EpisodeID;
		param.ArgCnt = 1;
	});
	
	InitVpInfPatientAdmEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
