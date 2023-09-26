var EpisodeID = ""
var PatientID = "";
		
function InitVpInfPatientAdm(CRPrjCode){
	var obj = new Object();

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
    
    var nav = new Ext.KeyNav(document, 
    {  	
        "enter" : function(e){
        	obj.BtnFind_click();
        	}, 
        scope : obj});
    //////add by date time end//////////
    
     
	obj.cboInfTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboInfTypeStore = new Ext.data.Store({
		proxy: obj.cboInfTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	
	obj.cboInfTypeColumn = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.cboInfType = new Ext.grid.GridPanel({
		height : 290
		,hideHeaders:true
		,store : obj.cboInfTypeStore
		,anchor : "95%"
		,fieldLabel : '报告类型'
		,columns: [
			obj.cboInfTypeColumn
			,{header: '状态', width: 210, dataIndex: 'Description', sortable: true}
		]	
		,plugins:obj.cboInfTypeColumn});
        
	obj.EPRReportListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.EPRReportListStore = new Ext.data.Store({
		proxy: obj.EPRReportListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ReportID', mapping: 'ReportID'}
			,{name: 'InstanceID', mapping: 'InstanceID'}
			,{name: 'ProjectID', mapping: 'ProjectID'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'ReportNo', mapping: 'ReportNo'}
			,{name: 'ReportStatus', mapping: 'ReportStatus'}
			,{name: 'RepUser', mapping: 'RepUser'}
			,{name: 'RepDate', mapping: 'RepDate'}
			,{name: 'RepTime',mapping:'RepTime'}
			,{name: 'CheckUser', mapping: 'CheckUser'}
			,{name: 'CheckDate', mapping: 'CheckDate'}
			,{name: 'CheckTime', mapping: 'CheckTime'}
			,{name: 'ReturnRes', mapping: 'ReturnRes'}
			,{name: 'Text1', mapping: 'Text1'}
			,{name: 'Text2', mapping: 'Text2'}
			,{name: 'Resume', mapping: 'Resume'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'ProjectDesc', mapping: 'ProjectDesc'}
			,{name: 'TemplateCatID', mapping: 'TemplateCatID'}
			,{name: 'PrtTemplateID', mapping: 'PrtTemplateID'}
		])
	});
	
	//obj.EPRReportListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.EPRReportList = new Ext.grid.GridPanel({
		id : 'EPRReportList'
		,store : obj.EPRReportListStore
		,buttonAlign : 'center'
		,region : 'center'
		,columnLines: true
		,columns: [
			 {header: '报告类型', width: 120, dataIndex: 'ProjectDesc', sortable: true}
			,{header: '报告日期', width: 100, dataIndex: 'RepDate', sortable: true}
			,{header: '报告人', width: 100, dataIndex: 'RepUser', sortable: true}
			,{header: '患者姓名', width:80,dataIndex: 'PatName',sortable:true}
			,{header: '登记号', width:80,dataIndex: 'RegNo',sortable:true}
			,{header: '报告状态', width:80,dataIndex: 'ReportStatus',sortable:true}
			,{header: '审核人', width:80,dataIndex: 'CheckUser',sortable:true}
			,{header: '审核日期', width:80,dataIndex: 'CheckDate',sortable:true}
		]
	});
	obj.PanLeftPad = new Ext.Panel({
		id : 'PanLeftPad'
		,buttonAlign : 'center'
		,columnWidth : .01
		,items:[
		]
	});
	obj.dtReportSD = new Ext.form.DateField({
		id:'dtReportSD'
		,value : new Date()
		,format:'Y-m-d'
		,fieldLabel : '开始日期'
		//,vtype: 'daterange'
		//,endDateField: 'dtReportED'
		,anchor : '95%'
	});
	obj.dtReportED = new Ext.form.DateField({
		id:'dtReportED'
		,value : new Date()
		,format:'Y-m-d'
		,fieldLabel : '结束日期'
		,anchor : '95%'
		//,vtype: 'daterange'
		//,startDateField: 'dtReportSD'
	});
	obj.cboCtlocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboCtlocStore = new Ext.data.Store({
		proxy: obj.cboCtlocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'depid'
		}, 
		[
			{name: 'depid', mapping: 'depid'}
			,{name: 'dep', mapping: 'dep'}
		])
	});
	obj.cboCtloc = new Ext.form.ComboBox({
		minChars : 1
		,displayField : 'dep'
		,fieldLabel : '科室'
		,store : obj.cboCtlocStore
		,triggerAction : 'all'
		,valueField : 'depid'
		,anchor:'95%'
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

	obj.gridStatusStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridStatusStore = new Ext.data.Store({
		proxy: obj.gridStatusStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			 {name: 'checked', mapping : 'checked'}
      ,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	obj.objStatusColumn = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridStatus = new Ext.grid.GridPanel({
		height : 80
		,hideHeaders:true
		,store : obj.gridStatusStore
		,anchor : "95%"
		,fieldLabel : '报告状态'
		,columns: [
			obj.objStatusColumn
			,{header: '状态', width: 128, dataIndex: 'Description', sortable: true}
			]	
		,plugins:obj.objStatusColumn
	});
	obj.txtRegNoM = new Ext.form.TextField({
		id : 'txtRegNoM'
		,fieldLabel : '病人ID'
		,anchor : '95%'
        });
	obj.PanColCenterPad = new Ext.Panel({
		id : 'PanColCenterPad'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
				
		]
	});
	obj.PanColCenterPad1 = new Ext.Panel({
		id : 'PanColCenterPad1'
		,buttonAlign : 'center'
		,columnWidth : .98
		,layout : 'form'
		,items:[
			obj.dtReportSD
			,obj.dtReportED
			,obj.cboCtloc
			,obj.Ward
			,obj.cboInfType		
			,obj.gridStatus
			
		]
	});
	obj.PanColRightPad = new Ext.Panel({
		id : 'PanColRightPad'
		,buttonAlign : 'center'
		,columnWidth : .01
		,items:[
		]
	});
	obj.BtnFind = new Ext.Button({
		id : 'BtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.QueryPanel = new Ext.Panel({
		id : 'QueryPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,title : '查询条件'
		,region: 'center'
		,layout : 'column'
		,height : 300
		,frame : true
		,items:[
			obj.PanLeftPad
			//,obj.PanColCenterPad
			,obj.PanColCenterPad1
			,obj.PanColRightPad
		]
		,buttons:[
			obj.BtnFind
		]
	});
	
	obj.FPanSouthPad = new Ext.form.FormPanel({
		id : 'FPanSouthPad'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,width : 380
		,region : 'east'
		,layout : 'border'
		,frame : true
		,items:[
			obj.QueryPanel
			]
		});
	obj.VpInfPatientAdm = new Ext.Viewport({
		id : 'VpInfPatientAdm'
		,layout : 'border'
		,items:[
			obj.EPRReportList
			,obj.FPanSouthPad
		]
	});
	obj.cboCtlocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Aim.InfBaseSrv';
		param.QueryName = 'admdeplookup';
		param.Arg1 = obj.cboCtloc.getRawValue();
		param.ArgCnt = 1;
	});
	obj.cboCtlocStore.load({});
	
	obj.WardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Aim.BasePatInfoQuery';
			param.QueryName = 'QueryAllWard';
			param.Arg1 = obj.Ward.getValue();
			param.Arg2 = obj.cboCtloc.getValue();
			param.ArgCnt = 2;
	});
	obj.WardStore.load({});
	
	obj.gridStatusStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = "CRepAuditResult";
		param.ArgCnt = 1;
	});
	obj.gridStatusStore.load({
		callback:function()
		{
			var store = obj.gridStatus.getStore();
        for(var i = 0, lens = store.getCount(); i < lens; i++) 
        {
        	 var rc=store.getAt(i);
           if(rc.get("Description")=="待审")
           {
           	 rc.set("checked",true);
           }
        }
		}
		});
	obj.cboInfTypeStoreProxy.on('beforeload',function(objProxy,param){
	  param.ClassName = 'DHCMed.NINFService.Aim.EPRReprotSrv';
		param.QueryName = 'QryProject';
		param.Arg1 = CRPrjCode;
		param.ArgCnt = 1;
	});
	obj.cboInfTypeStore.load({});
	obj.EPRReportListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Aim.EPRReprotSrv';
		param.QueryName = 'QueryCRReport';
		param.Arg1 = obj.dtReportSD.getRawValue();
		param.Arg2 = obj.dtReportED.getRawValue();
		param.Arg3 = obj.cboCtloc.getValue();
		param.Arg4 = obj.hiddenRepTypeList();
		param.Arg5 = obj.hiddenStatusList();
		param.Arg6 = obj.Ward.getValue();
		param.ArgCnt = 6;
	});
	InitVpInfPatientAdmEvent(obj);
	//事件处理代码
	obj.BtnFind.on("click", obj.BtnFind_click, obj);
	obj.EPRReportList.on("rowcontextmenu" , obj.EPRReportList_rowcontextmenu , obj);
	obj.EPRReportList.on("rowdblclick",obj.EPRReportList_rowdblclick, obj);
	obj.LoadEvent(arguments);
	return obj;
}
