var objScreen = new Object();
function InitSpeQuery(){
	var obj = objScreen;
	obj.InputObj = new Object();
	obj.SelectRow = new Object();
	obj.SelectRow.SepID = '';
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","ҽԺ",SSHospCode,"SPE");
	obj.cboLoc = Common_ComboToLoc("cboLoc","���ο���","E","","","cboSSHosp");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","��ʼ����");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","��������");
	
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
		,fieldLabel : '״̬'
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
		,text : '��ѯ'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 60
		,text : '����'
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
		,fieldLabel : '��������'
		,emptyText: '��ѡ��'
		,store : obj.cboPatTypeSubStore
		,triggerAction : 'all'
		,width : 10
		,anchor : '98%'
		,editable : true
		,mode: 'local'
	});
	
	
	//�����б�
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
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}
		,tbar : ['->','-',obj.btnQuery,'-',obj.btnExport]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '�ǼǺ�', width: 80, dataIndex: 'RegNo', sortable: true}
			,{header: '��������', width: 70, dataIndex: 'PatName', sortable: true}
			,{header: '�Ա�', width: 50, dataIndex: 'Sex', sortable: true}
			,{header: '����', width: 50, dataIndex: 'PatientAge', sortable: true}
			,{header: '��Ժ����', width: 70, dataIndex: 'AdmDate', sortable: true}
			,{header: '��������', width: 80, dataIndex: 'PatTypeDesc', sortable: true}
			,{header: '״̬', width: 50, dataIndex: 'StatusDesc', sortable: true
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
			,{header: '��Ϣ', width: 70, dataIndex: 'ReadStatus', sortable: true}
			,{header: '���˵��', width: 150, dataIndex: 'Note', sortable: true}
			,{header: '�������', width: 70, dataIndex: 'MarkDate', sortable: true}
			,{header: '������', width: 150, dataIndex: 'CheckOpinion', sortable: true}
			,{header: '�������', width: 70, dataIndex: 'CheckDate', sortable: true}
			,{header: '�������', width: 120, dataIndex: 'LocDesc', sortable: true}
			,{header: '����', width: 120, dataIndex: 'WardDesc', sortable: true}
			,{header: '����', width: 60, dataIndex: 'Bed', sortable: true}
			,{header: '����ҽ��', width: 70, dataIndex: 'DoctorName', sortable: true}
			,{header: '�����', width: 50, dataIndex: 'EpisodeID', sortable: true}
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
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
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