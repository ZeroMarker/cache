
function InitEvalWindow(SubjectID,EpisodeID){
	var obj = new Object();
	obj.SubjectID=SubjectID;
	obj.EpisodeID=EpisodeID;
	obj.EvalLocID=session['LOGON.CTLOCID'];
	obj.EvalUserID=session['LOGON.USERID'];
	obj.EvalDate="";
	obj.EvalTime="";
	obj.EvalID="";
	obj.txtEvalInfo = new Ext.form.TextField({
		id : 'txtEvalInfo'
		,width : 100
		,fieldLabel : '评价'
		,anchor : '99%'
	});
	obj.fpEvalCondChild1 = new Ext.Panel({
		id : 'fpEvalCondChild1'
		,buttonAlign : 'center'
		,columnWidth : .78
		,layout : 'form'
		,items:[
			obj.txtEvalInfo
		]
	});
	obj.chkIsActive = new Ext.form.Checkbox({
		id : 'chkIsActive'
		,checked : true
		,fieldLabel : '是否有效'
	});
	obj.fpEvalCondChild2 = new Ext.Panel({
		id : 'fpEvalCondChild2'
		,buttonAlign : 'center'
		,columnWidth : .12
		,layout : 'form'
		,items:[
			obj.chkIsActive
		]
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,width : 60
		,clearCls : 'icon-update'
		,text : '更新'
		,disabled : false
	});
	obj.fpEvalCondChild3 = new Ext.Panel({
		id : 'fpEvalCondChild3'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
			obj.btnUpdate
		]
	});
	obj.fpEvalCondSub = new Ext.form.FormPanel({
		id : 'fpEvalCondSub'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,frame : true
		,items:[
			obj.fpEvalCondChild1
			,obj.fpEvalCondChild2
			,obj.fpEvalCondChild3
		]
	});
	obj.fpEvalCond = new Ext.Panel({
		id : 'fpEvalCond'
		,height : 40
		,buttonAlign : 'center'
		,region : 'south'
		,layout : 'fit'
		,items:[
			obj.fpEvalCondSub
		]
	});
	
	
	obj.gpEvalRstStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gpEvalRstStore = new Ext.data.Store({
		proxy: obj.gpEvalRstStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EvalID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'EvalID', mapping: 'EvalID'}
			,{name: 'SubjectID', mapping: 'SubjectID'}
			,{name: 'Paadm', mapping: 'Paadm'}
			,{name: 'EvalDate', mapping: 'EvalDate'}
			,{name: 'EvalTime', mapping: 'EvalTime'}
			,{name: 'EvalUserID', mapping: 'EvalUserID'}
			,{name: 'EvalUserDesc', mapping: 'EvalUserDesc'}
			,{name: 'EvalLocID', mapping: 'EvalLocID'}
			,{name: 'EvalLocDesc', mapping: 'EvalLocDesc'}
			,{name: 'EvalInfo', mapping: 'EvalInfo'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'ResumeTxt', mapping: 'ResumeTxt'}
		])
	});
	obj.gpEvalRstCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gpEvalRst = new Ext.grid.GridPanel({
		id : 'gpEvalRst'
		,store : obj.gpEvalRstStore
		,buttonAlign : 'center'
		,loadMask : true
		,viewConfig : {forceFit:true}
		,frame : true
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '评价信息', width: 300, dataIndex: 'EvalInfo', sortable: false}
			,{header: '是否有效', width: 50, dataIndex: 'IsActive', sortable: true}
			,{header: '评价日期', width: 70, dataIndex: 'EvalDate', sortable: true}
			,{header: '评价时间', width: 70, dataIndex: 'EvalTime', sortable: true}
			,{header: '评价人', width: 80, dataIndex: 'EvalUserDesc', sortable: false}
			,{header: '评价科室', width: 120, dataIndex: 'EvalLocDesc', sortable: false}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	obj.EvalWindow = new Ext.Window({
		id : 'EvalWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : '监控评价'
		,layout : 'border'
		,width : 900
		,height : 500
		,modal: true
		,items:[
			obj.fpEvalCond
			,obj.gpEvalRst
		]
	});
	
	obj.gpEvalRstStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Ctrl.Evaluation';
			param.QueryName = 'QryEvaluation';
			param.Arg1 = obj.SubjectID;
			param.Arg2 = obj.EpisodeID;
			param.ArgCnt = 2;
	});
	obj.gpEvalRstStore.load({});
	InitEvalWindowEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

