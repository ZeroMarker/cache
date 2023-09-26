var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.txtMrNo = Common_TextField("txtMrNo","病案号");
	obj.txtPapmiNo = Common_TextField("txtPapmiNo","登记号");
	obj.txtPatName = Common_TextField("txtPatName","姓名");
	obj.txtSex = Common_TextField("txtSex","性别");
	obj.txtAge = Common_TextField("txtAge","年龄");
	obj.txtIdentityCode = Common_TextField("txtIdentityCode","身份证号");

	obj.chkMBarCode = Common_Checkbox("chkMBarCode","打印病案条码");
	obj.chkVBarCode = Common_Checkbox("chkVBarCode","打印卷条码");
	obj.txtHName = Common_TextField("txtHName","男方姓名");
	obj.txtMarker = Common_TextField("txtMarker","标记");
	obj.txtFileNo = Common_TextField("txtFileNo","上架号");

	obj.btnModify = new Ext.Button({
		id : 'btnModify'
		,iconCls : 'icon-Edit'
		,width : 80
		,anchor : '100%'
		,text : '修改信息'
	});
	obj.btnBatchPrintBar = new Ext.Button({
		id : 'btnBatchPrintBar'
		,iconCls : 'icon-print'
		,width : 80
		,anchor : '100%'
		,text : '打印条码'
	});

	obj.AdmListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.AdmListStore = new Ext.data.Store({
		proxy: obj.AdmListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EpisodeID'
		},[
			{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'AdmType', mapping: 'AdmType'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'MrNo', mapping: 'MrNo'}
			,{name: 'AdmLocID', mapping: 'AdmLocID'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmDate', mapping: 'AdmDate'}
			,{name: 'AdmTime', mapping: 'AdmTime'}
			,{name: 'VolumeID', mapping : 'VolumeID'}
			,{name: 'MrTypeID', mapping: 'MrTypeID'}
			,{name: 'MrNo', mapping: 'MrNo'}
			,{name: 'MrClass', mapping: 'MrClass'}
			,{name: 'ReceiptType', mapping: 'ReceiptType'}
			,{name: 'MainID', mapping: 'MainID'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
		])
	});
	obj.AdmList = new Ext.grid.GridPanel({
		id : 'AdmList'
		,store : obj.AdmListStore
		,columnLines : true
		,region : 'center'
		,layout: 'fit'
		,buttonAlign:'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '操作', width: 80 , align : 'center'
				,renderer : function(v, m, rd, r, c, s){
					var PatientID = rd.get("PatientID");
					var VolumeID  = rd.get("VolumeID");
					var EpisodeID = rd.get("EpisodeID");
					var MrNo      = rd.get("MrNo");
					var MrClass   = rd.get("MrClass");
					var ReceiptType = rd.get("ReceiptType");
					var MainID    = rd.get("MainID");
					var PapmiNo   = rd.get("PapmiNo");
					var MrTypeID   = rd.get("MrTypeID");
					if (VolumeID == ''){
						if ((MrClass == 'O')&&(ReceiptType == 'M')&&(MainID != '')){
							return "";
						} else {
							return "<a href='#' onclick='objScreen.ReceiptClick(\"" + PatientID + "\",\"" + EpisodeID + "\",\"" + MrNo + "\",\"" + PapmiNo + "\",\"" + MrTypeID + "\");'><b>建档</b></a>";
						}
					} else {
						return "<a href='#' onclick='objScreen.GroupUnReceipt(\"" + EpisodeID + "\");'>取消建档</a>";
					}
				}
			}
			,{header: '性别', width: 80, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 70, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科室', width: 70, dataIndex: 'AdmLoc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '就诊日期', width: 70, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar :['-','打印卷条码：','-',obj.chkVBarCode,'-','病案条码：','-',obj.chkMBarCode,'-',obj.btnBatchPrintBar,'-','->','-','相关操作：','-',obj.btnModify,'-']
    });
	
	obj.Viewport = new Ext.Viewport({
		id: 'Viewport'
		,layout: 'border'
		,frame: true
		,items:[
			{
			region: 'north'
			,height: 100
			,frame: true
			,layout: 'column'
			,items:[
				{
					width: 200
					,layout : 'form'
					,labelAlign : 'right'
					,labelWidth : 70
					,items:[obj.cboHospital,obj.txtPatName,obj.txtHName]
				},{
					width: 200
					,layout : 'form'
					,labelAlign : 'right'
					,labelWidth : 70
					,items:[obj.cboMrType,obj.txtSex,obj.txtMarker]
				},{
					width: 200
					,layout : 'form'
					,labelAlign : 'right'
					,labelWidth : 70
					,items:[obj.txtMrNo,obj.txtAge,obj.txtFileNo]
				},{
					width: 220
					,layout : 'form'
					,labelAlign : 'right'
					,labelWidth : 70
					,items:[obj.txtPapmiNo,obj.txtIdentityCode]
				}
			]
		},
		obj.AdmList
		]
	});
	
	obj.AdmListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.ReceiptQry';
			param.QueryName = 'QuryReceiptByDate';
			param.Arg1 = Common_GetValue("cboHospital");
			param.Arg2 = "O";
			param.Arg3 = "";
			param.Arg4 = "";
			param.Arg5 = "";
			param.Arg6 = Common_GetValue("txtPapmiNo");
			param.ArgCnt = 6;
	});

	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}