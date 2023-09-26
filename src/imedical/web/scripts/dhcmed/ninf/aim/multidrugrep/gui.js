var EpisodeID="";
var PatientID="";
function InitVpInfPatientAdm(SubjectID,CRPrjCode){
	var obj = new Object();
	
	obj.selLocDr = "";
  obj.selWardDr = "";
  obj.SubjectID = SubjectID;
  obj.aCtrls="";
  
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
        }
        
        else if (field.endDateField && (!this.dateRangeMin || (date.getTime() != this.dateRangeMin.getTime()))) {
            var end = Ext.getCmp(field.endDateField);
            end.setMinValue(date);
            end.validate();
            this.dateRangeMin = date;
        }
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
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
    
    //////add by date time end//////////
	
	obj.expCtrlDetail = new Ext.ux.grid.RowExpander({
        tpl : new Ext.Template(
            '<p>{DataDetail}</p><br>'
        )
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
			//,{name: 'RepInfo',mapping: 'RepInfo'}
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
		,title : '就诊列表'
		,columns: [
		  obj.expCtrlDetail
			,{header: '病人ID', width: 80, dataIndex: 'RegNo', sortable: true}
			,{header: '患者姓名', width: 100, dataIndex: 'PatientName', sortable: true}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: true}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: true}
			,{header: '主管医生', width: 80, dataIndex: 'DoctorName', sortable: true}
			,{header: '科室', width: 80, dataIndex: 'Department', sortable: true}
			,{header: '病区', width: 120, dataIndex: 'Ward', sortable: true}
			,{header: '病床', width: 80, dataIndex: 'Bed', sortable: true}
			,{header: '住院日期', width: 80, dataIndex: 'AdmitDate', sortable: true}
			,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: true}
			//,{header: '报告信息', width:100, dataIndex:'RepInfo'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 30,
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
		,title : '患者报告列表'
		,height : 200
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
		,bbar: new Ext.PagingToolbar({
			pageSize : 30,
			store : obj.grdPatAdmRepListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

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
		,anchor : '95%'
});

	obj.MrNo = new Ext.form.TextField({
		id : 'MrNo'
		,fieldLabel : '病案号'
		,anchor : '95%'
});
	obj.RegNo = new Ext.form.TextField({
		id : 'RegNo'
		,fieldLabel : '登记号'
		,anchor : '95%'
});
	obj.DateFrom = new Ext.form.DateField({
		id : 'DateFrom'
		,fieldLabel : '开始日期'
		,anchor : '95%'
		,format: 'Y-m-d'
});
	obj.DateTo = new Ext.form.DateField({
		id : 'DateTo'
		,fieldLabel : '结束日期'
		,anchor : '95%'
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
		,anchor : '95%'
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
		,mode : 'local'  //remote
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
});
	obj.PatName = new Ext.form.TextField({
		id : 'PatName'
		,fieldLabel : '姓名'
		,anchor : '95%'
});

obj.BtnFind = new Ext.Button({
		id : 'BtnFind'
		,iconCls : 'icon-find'
		//,anchor : '8%'
		,columnWidth:.2
		,text : '查询'
});

obj.BtnLocManager = new Ext.Button({
		id : 'BtnLocManager'
		,iconCls : 'icon-find'
		//,anchor : '8%'
		,text : '多重耐药重点科室维护'
		,anchor : '30%'
});

obj.BtnCC = new Ext.Button({
		id : 'BtnCC'
		,iconCls : 'icon-update'
		//,anchor : '8%'
		,columnWidth:.2
		,text : '监控'
});

obj.LocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Aim.BasePatInfoQuery';
			param.QueryName = 'QueryAimCtloc';
			param.Arg1 = "MULTIDRUG";
			param.Arg2 = 'E';
			param.ArgCnt = 2;
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
	
	obj.PanColCenterPad1 = new Ext.Panel({
		id : 'PanColCenterPad1'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			
		]
	});
	
	obj.PanColCenterPad2 = new Ext.Panel({
		id : 'PanColCenterPad2'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.InHospital
		  ,obj.RegNo
		  ,obj.MrNo
		  ,obj.PatName
		  ,obj.Loc	
			,obj.Ward
			,obj.DateFrom
			,obj.DateTo
		],buttons:[
			obj.BtnLocManager	
		]
	});
	
	obj.PanColCenterPad3 = new Ext.Panel({
		id : 'PanColCenterPad3'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			
		]
	});
	obj.FPanSouthPad = new Ext.form.FormPanel({
		id : 'FPanSouthPad'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 300
		//,width : 300
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.PanColCenterPad1
			,obj.PanColCenterPad2
			,obj.PanColCenterPad3
		]
		,buttons:[obj.BtnFind,obj.BtnCC]
	});
	
	obj.TreeControlsTreeLoader = new Ext.tree.TreeLoader({
			nodeParameter : 'Arg1',
			dataUrl : "dhcmed.cc.ctrl.itemtree.csp",
			baseParams : {
				SubjectID:obj.SubjectID
                ,Loc : obj.selLocDr
                ,Ward: obj.selWardDr
			}
	});
	obj.TreeControls = new Ext.tree.TreePanel({
		buttonAlign : 'center'
		,region : 'center'
		,width:300
		,rootVisible:false
		,autoScroll:true
		,loader : null  //obj.TreeControlsTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'root',text:'root'})
	});
	obj.ConditionPanel1 = new Ext.form.FormPanel({
		id : 'ConditionPanel1'
		,layout : 'fit'
		,region: 'center'
		,items:[
			obj.TreeControls
		]
	});
	
		obj.ConditionPanel = new Ext.Panel({
		id: 'ConditionPanel'
		,title: '住院患者监控'
		//,autoScroll : true
		,collapsible : true
		,split:true
		,border:true
		,width:300
		,minSize: 300
		,maxSize: 300
		,layoutConfig: {animate: true}
		,region: 'west'
		,layout: 'border'
		,items:[
			obj.FPanSouthPad
			,obj.ConditionPanel1
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
			param.Arg11 = obj.aCtrls;
			param.Arg12 = SubjectID;
			param.Arg13 = "";
			param.ArgCnt = 13;
	});

	obj.grdPatAdmRepListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Aim.ICUSrv';
			param.QueryName = 'QueryEPRByEpisodeID';
			param.Arg1 = EpisodeID;
			param.ArgCnt = 1;
	});
	InitVpInfPatientAdmEvent(obj);
	//事件处理代码
	obj.grdPatAdmList.on("rowcontextmenu" , obj.grdPatAdmList_rowcontextmenu , obj);
	obj.grdPatAdmRepList.on("rowdblclick" , obj.grdPatAdmRepList_rowdblclick , obj);
	obj.RegNo.on("specialkey", obj.txtRegNoM_specialkey, obj);
	obj.grdPatAdmList.on("rowclick",obj.grdPatAdmList_rowclick, obj);
	obj.BtnFind.on("click",obj.BtnFind_click,obj);
	obj.BtnCC.on("click",obj.BtnCC_click,obj);
	obj.BtnLocManager.on("click",obj.BtnLocManager_click,obj);
  obj.LoadEvent(arguments);
  return obj;
}
