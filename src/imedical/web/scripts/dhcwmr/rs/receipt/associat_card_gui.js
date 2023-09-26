function VS_InitAssociatCard(){
	var obj = new Object();
	obj.VS_Argument = new Object();
	obj.VS_Argument.HospID = arguments[0];
	obj.VS_Argument.MrTypeID = arguments[1];
	obj.VS_Argument.ToPapmiNo = arguments[2];
	obj.VS_Argument.EpisodeID = arguments[3];


	obj.txtMrNoTo = Common_TextField("txtMrNoTo","病案号");
	obj.txtPapmiNoTo = Common_TextField("txtPapmiNoTo","登记号");
	obj.txtPatNameTo = Common_TextField("txtPatNameTo","姓名");
	obj.txtSexTo = Common_TextField("txtSexTo","性别");
	obj.txtAgeTo = Common_TextField("txtAgeTo","年龄");
	obj.txtIdentityCodeTo = Common_TextField("txtIdentityCodeTo","身份证号");

	obj.txtHNameTo = Common_TextField("txtHNameTo","男方姓名");
	obj.txtMarkerTo = Common_TextField("txtMarkerTo","标记");
	obj.txtFileNoTo = Common_TextField("txtFileNoTo","上架号");

	obj.btnAssociat = new Ext.Button({
		id : 'btnAssociat'
		,iconCls : 'icon-wmr'
		,anchor : '100%'
		,text : '关联'
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
		 store : obj.AdmListStore
		,columnLines : true
		,region : 'center'
		,layout: 'fit'
		,buttonAlign:'center'
		,buttonAlign:'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科室', width: 70, dataIndex: 'AdmLoc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '建档状态', width: 80 , align : 'center'
				,renderer : function(v, m, rd, r, c, s){
					var VolumeID  = rd.get("VolumeID");
					if (VolumeID == ''){
						return "";
					} else {
						return "已建档";
					}
				}
			}
			,{header: '就诊日期', width: 70, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,buttons:[obj.btnAssociat]
    });

	obj.VS_WinAssociatCard = new Ext.Window({
		id : 'VS_WinAssociatCard'
		,height : 350
		,width : 600
		,modal : true
		,title : '病人换卡关联'
		,closable : false
		,layout : 'border'
		,closable : true
		,buttonAlign : 'center'
		,items:[
			{
				region: 'north'
				,height :90
				,layout: 'column'
				,frame : true
				,items:[
					{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,columnWidth : .3
						,items:[obj.txtMrNoTo,obj.txtPatNameTo,obj.txtHNameTo]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,columnWidth : .33
						,items:[obj.txtPapmiNoTo,obj.txtSexTo,obj.txtMarkerTo]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,columnWidth : .37
						,items:[obj.txtIdentityCodeTo,obj.txtAgeTo,obj.txtFileNoTo]
					}
				]
			},
			obj.AdmList
		]
	});
	
	obj.AdmListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.ReceiptQry';
			param.QueryName = 'QuryReceiptByDate';
			param.Arg1 = obj.VS_Argument.HospID;
			param.Arg2 = "O";
			param.Arg3 = "";
			param.Arg4 = "";
			param.Arg5 = "";
			param.Arg6 = obj.VS_Argument.ToPapmiNo;
			param.ArgCnt = 6;
	});

	

	VS_InitAssociatCardEvent(obj);
	obj.VS_LoadEvent(arguments);
	return obj;
}