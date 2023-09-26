var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.QryFlg = "";
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","ҽԺ",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","��������",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","��ʼ����");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","��");
	
	//������
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboLocGroupStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboLocGroupStore = new Ext.data.Store({
		proxy: obj.cboLocGroupStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'GroupID'
		},[
			{name: 'GroupID', mapping : 'GroupID'}
			,{name: 'GroupCode', mapping: 'GroupCode'}
			,{name: 'GroupDesc', mapping: 'GroupDesc'}
		])
	});
	obj.cboLocGroup = new Ext.form.ComboBox({
		id : 'cboLocGroup'
		,fieldLabel : '����Ա'
		,store : obj.cboLocGroupStore
		,minChars : 1
		,valueField : 'GroupID'
		,displayField : 'GroupDesc'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	
	//����
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocID'
		},[
			{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,fieldLabel : '����'
		,store : obj.cboLocStore
		,minChars : 1
		,valueField : 'LocID'
		,displayField : 'LocDesc'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	
	obj.btnCodQry = new Ext.Button({
		id : 'btnCodQry'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '��Ŀ��ѯ'
	});
	
	obj.btnNotCodQry = new Ext.Button({
		id : 'btnNotCodQry'
		,iconCls : 'icon-cancel'
		,width : 70
		,anchor : '100%'
		,text : 'δ���ѯ'
	});
	
	obj.btnRepQry = new Ext.Button({
		id : 'btnRepQry'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '�����ѯ'
	});
	
	obj.gridPathologRepProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridPathologRep = new Ext.data.Store({
		proxy: obj.gridPathologRepProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PathRepID'
		},[
			{name: 'PathRepID', mapping : 'PathRepID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping : 'Age'}
			,{name: 'AdmitDept', mapping : 'AdmitDept'}
			,{name: 'AdmitDate', mapping : 'AdmitDate'}
			,{name: 'AdmitDeptDesc', mapping : 'AdmitDeptDesc'}
			,{name: 'EstimDischDate', mapping : 'EstimDischDate'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'Number', mapping : 'Number'}
			,{name: 'RepDate', mapping : 'RepDate'}
			,{name: 'RepTime', mapping : 'RepTime'}
			,{name: 'RepUser', mapping : 'RepUser'}
			,{name: 'RepUserDesc', mapping : 'RepUserDesc'}
			,{name: 'Diagnos', mapping : 'Diagnos'}
			,{name: 'IsCoding', mapping : 'IsCoding'}
			,{name: 'CodDate', mapping : 'CodDate'}
			,{name: 'CodTime', mapping : 'CodTime'}
			,{name: 'CodUser', mapping : 'CodUser'}
			,{name: 'CodUserDesc', mapping : 'CodUserDesc'}
			,{name: 'VolID', mapping : 'VolID'}
			,{name: 'FrontPageID', mapping : 'FrontPageID'}
		])
	});
	obj.gridPathologRep = new Ext.grid.GridPanel({
		id : 'gridPathologRep'
		,store : obj.gridPathologRep
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [
			{id:'msggridPathologRep',text:'�����ѯ�б�',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->',{text:'',width:50,xtype:'label'},'-',obj.btnNotCodQry,'-',obj.btnCodQry,'-',obj.btnRepQry,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '�ǼǺ�', width: 70, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '������', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '�Ա�', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��Ŀ״̬', width: 50, dataIndex: 'IsCoding', sortable: true, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var IsCoding = rd.get("IsCoding");
					var FrontPageID = rd.get("FrontPageID");
					var VolID = rd.get("VolID");
					
					var PathRepID = rd.get("PathRepID");
					if (IsCoding==1){
						var ret = "<a href='#' onclick='objScreen.ViewFrontPageEdit(\"" + FrontPageID + "\",\"" + VolID + "\",\"" + PathRepID + "\")'><font size='2'>" + '�ѱ�Ŀ' + "</font></a>";
					}else{
						if (FrontPageID != ''){
							var ret = "<a href='#' onclick='objScreen.ViewFrontPageEdit(\"" + FrontPageID + "\",\"\",\"" + PathRepID + "\")'><font size='2'>" + 'δ��Ŀ' + "</font></a>";
						}else{
							var ret = "<a href='#' onclick='objScreen.ViewFrontPageEdit(\"\",\"" + VolID + "\",\"" + PathRepID + "\")'><font size='2'>" + 'δ��Ŀ' + "</font></a>";
						}
					}
					return ret;
				}
			}
			,{header: '��������', width: 60, dataIndex: 'RepDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '������', width: 60, dataIndex: 'RepUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�������', width: 100, dataIndex: 'Diagnos', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��Ŀ����', width: 60, dataIndex: 'CodDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��Ŀ��', width: 60, dataIndex: 'CodUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�������', width: 120, dataIndex: 'AdmitDeptDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '��������', width: 80, dataIndex: 'AdmitDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��Ժ����', width: 60, dataIndex: 'EstimDischDate', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridPathologRep,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'north',
				height: 35,
				layout : 'column',
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
				items : [
					{
						width:220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboHospital]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboMrType]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.dfDateFrom]
					},{
						width:130
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.dfDateTo]
					},{
						width:120
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 50
						,items: [obj.cboLocGroup]
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboLoc]
					}
				]
			}
			,obj.gridPathologRep
		]
	});
	
	obj.cboLocGroupStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocGroup';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = obj.cboLocGroup.getRawValue();
		param.ArgCnt = 2;
	});
	
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocList';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = Common_GetValue('cboLocGroup');
		param.Arg3 = obj.cboLoc.getRawValue();
		param.ArgCnt = 3;
	});
	
	obj.gridPathologRepProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.PathologRepSrv';
		param.QueryName = 'QryPathologRep';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("dfDateFrom");
		param.Arg4 = Common_GetValue("dfDateTo");
		param.Arg5 = Common_GetValue("cboLocGroup");
		param.Arg6 = Common_GetValue("cboLoc");
		param.Arg7 = obj.QryFlg;
		param.ArgCnt =7;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}