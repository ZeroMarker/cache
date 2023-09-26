var objScreen = new Object();
function InitSpeQuery(){
	var obj = objScreen;
	obj.InputObj = new Object();
	obj.SelectRow = new Object();
	obj.SelectRow.SepID = '';
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"SPE");
	obj.cboLoc = Common_ComboToLoc("cboLoc","责任科室","E","","","cboSSHosp");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	
	var arrayStatus = new Array();
	var objPatientSrv = ExtTool.StaticServerObject("DHCMed.SPEService.PatientsSrv");
	var listStatus = objPatientSrv.GetDicForCheckGroup("SPEStatus","1");
	listStatus = listStatus.split(",");
	for (var i=0; i<listStatus.length; i++) {
		var tmpStatus = listStatus[i].split("^");
		var tmpItem = { boxLabel : tmpStatus[1], name : tmpStatus[0], checked : tmpStatus[0]==1 }
		arrayStatus[arrayStatus.length] = tmpItem;
	}
	obj.chkStatus = new Ext.form.CheckboxGroup({
		id : 'chkStatus'
		,xtype : 'checkboxgroup'
		,fieldLabel : '状态'
		,columns : 4
		,items : arrayStatus
		,anchor : '99%'
	});
	
   obj.GetSelStatus = function() {
		var chkStatus = obj.chkStatus.getValue(), selStatus = "";
		for (var i=0; i<chkStatus.length; i++) {
			selStatus = selStatus + chkStatus[i].getName() + ",";
		}
		if (selStatus!="") { selStatus = selStatus.substring(0, selStatus.length-1); }
		return selStatus;
	}
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'	
		,iconCls : 'icon-find'
		,width : 60
		,text : '查询'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 60
		,text : '导出'
	});
	obj.cboPatTypeSubStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboPatTypeSubStore = new Ext.data.Store({
		proxy: obj.cboPatTypeSubStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PTSID'
		}, 
		[
			{name: 'PTSID', mapping: 'PTSID'}
			,{name: 'PTSDesc', mapping: 'PTSDesc'}
			
		])
	});
    obj.cboPatTypeSub = new Ext.form.ComboBox({
		id : 'cboPatTypeSub'
		,minChars : 1
		,valueField:'PTSID'
		,displayField : 'PTSDesc'
		,fieldLabel : '患者类型'
		,emptyText: '请选择'
		,store : obj.cboPatTypeSubStore
		,triggerAction : 'all'
		,width : 10
		,anchor : '98%'
		,editable : true
		,mode: 'local'
	});
	
	
	//病人列表
	obj.gridSpeListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridSpeListStore = new Ext.data.Store({
		proxy: obj.gridSpeListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SpeID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'SpeID', mapping : 'SpeID'}
			,{name: 'PatTypeID', mapping : 'PatTypeID'}
			,{name: 'PatTypeDesc', mapping : 'PatTypeDesc'}
			,{name: 'StatusCode', mapping : 'StatusCode'}
			,{name: 'StatusDesc', mapping : 'StatusDesc'}
			,{name: 'DutyUserID', mapping : 'DutyUserID'}
			,{name: 'DutyUserDesc', mapping : 'DutyUserDesc'}
			,{name: 'DutyDeptID', mapping : 'DutyDeptID'}
			,{name: 'DutyDeptDesc', mapping : 'DutyDeptDesc'}
			,{name: 'MarkDate', mapping : 'MarkDate'}
			,{name: 'MarkTime', mapping : 'MarkTime'}
			,{name: 'Note', mapping : 'Note'}
			,{name: 'Opinion', mapping : 'Opinion'}
			,{name: 'CheckDate', mapping : 'CheckDate'}
			,{name: 'CheckTime', mapping : 'CheckTime'}
			,{name: 'CheckOpinion', mapping : 'CheckOpinion'}
			,{name: 'ReadStatus', mapping : 'ReadStatus'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'RegNo', mapping : 'RegNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'PatientAge', mapping : 'PatientAge'}
			,{name: 'AdmDate', mapping : 'AdmDate'}
			,{name: 'AdmTime', mapping : 'AdmTime'}
			,{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping : 'LocDesc'}
			,{name: 'WardID', mapping : 'WardID'}
			,{name: 'WardDesc', mapping : 'WardDesc'}
			,{name: 'Bed', mapping : 'Bed'}
			,{name: 'DoctorID', mapping : 'DoctorID'}
			,{name: 'DoctorName', mapping : 'DoctorName'}
		])
	});
	obj.gridSpeList = new Ext.grid.GridPanel({
		id : 'gridSpeList'
		,store : obj.gridSpeListStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : { msg : '正在读取数据,请稍后...'}
		,tbar : ['->','-',obj.btnQuery,'-',obj.btnExport]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 80, dataIndex: 'RegNo', sortable: true}
			,{header: '患者姓名', width: 70, dataIndex: 'PatName', sortable: true}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: true}
			,{header: '年龄', width: 50, dataIndex: 'PatientAge', sortable: true}
			,{header: '入院日期', width: 70, dataIndex: 'AdmDate', sortable: true}
			,{header: '患者类型', width: 80, dataIndex: 'PatTypeDesc', sortable: true}
			,{header: '状态', width: 50, dataIndex: 'StatusDesc', sortable: true
			,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var retStr = "", tmpStatusCode = record.get("StatusCode");
					if (tmpStatusCode==1) {
						retStr = "<div style='color:red'>" + value + "</div>";
					} else if (tmpStatusCode==2) {
						retStr = "<div style='color:green'>" + value + "</div>";
					}else if (tmpStatusCode==3) {
						retStr = "<div style='color:blue'>" + value + "</div>";
					} else if (tmpStatusCode==0) {
						retStr = "<div style='color:black'>" + value + "</div>";
					} 
					return retStr;
				}
			}
			,{header: '消息', width: 70, dataIndex: 'ReadStatus', sortable: true}
			,{header: '情况说明', width: 150, dataIndex: 'Note', sortable: true}
			,{header: '标记日期', width: 70, dataIndex: 'MarkDate', sortable: true}
			,{header: '审核意见', width: 150, dataIndex: 'CheckOpinion', sortable: true}
			,{header: '审核日期', width: 70, dataIndex: 'CheckDate', sortable: true}
			,{header: '就诊科室', width: 120, dataIndex: 'LocDesc', sortable: true}
			,{header: '病区', width: 120, dataIndex: 'WardDesc', sortable: true}
			,{header: '床号', width: 60, dataIndex: 'Bed', sortable: true}
			,{header: '主管医生', width: 70, dataIndex: 'DoctorName', sortable: true}
			,{header: '就诊号', width: 50, dataIndex: 'EpisodeID', sortable: true}
		]
		,plugins: obj.RowExpander
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
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridSpeListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	});
	
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.gridSpeList
			,{
				layout : 'form'
				,region : 'north'
				,height : 75
				,frame : true
				,items :[
					{
						layout : 'column'
						,items : [
							{
								width:240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtDateFrom]
							},{
								width:240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtDateTo]
							},{
								width : 200
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboPatTypeSub]
							},{
								width: 400
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.chkStatus]
							}
						]
					},{
						layout : 'column'
						,items : [
							
							{
								width: 240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboSSHosp]
							},{
								width : 240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboLoc]
							}
						]
					}
				]
			}
		]
	});
	
	obj.gridSpeListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCMed.SPEService.PatientsQry"
		param.QueryName = "QrySpeList"
		param.Arg1 = Common_GetValue("txtDateFrom");
		param.Arg2 = Common_GetValue("txtDateTo");
		param.Arg3 = Common_GetValue("cboPatTypeSub");
		param.Arg4 = obj.GetSelStatus();
		param.Arg5 = Common_GetValue("cboLoc");
		param.Arg6 = Common_GetValue("cboSSHosp");
		param.ArgCnt =6;
	});
	
	obj.cboPatTypeSubStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SPEService.PatTypeSub';
		param.QueryName = 'QryAllPatTypeSub';
		param.ArgCnt = 0;
	});
	
	InitSpeQueryEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}