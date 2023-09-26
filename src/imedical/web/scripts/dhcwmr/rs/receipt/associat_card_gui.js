function VS_InitAssociatCard(){
	var obj = new Object();
	obj.VS_Argument = new Object();
	obj.VS_Argument.HospID = arguments[0];
	obj.VS_Argument.MrTypeID = arguments[1];
	obj.VS_Argument.ToPapmiNo = arguments[2];
	obj.VS_Argument.EpisodeID = arguments[3];


	obj.txtMrNoTo = Common_TextField("txtMrNoTo","������");
	obj.txtPapmiNoTo = Common_TextField("txtPapmiNoTo","�ǼǺ�");
	obj.txtPatNameTo = Common_TextField("txtPatNameTo","����");
	obj.txtSexTo = Common_TextField("txtSexTo","�Ա�");
	obj.txtAgeTo = Common_TextField("txtAgeTo","����");
	obj.txtIdentityCodeTo = Common_TextField("txtIdentityCodeTo","���֤��");

	obj.txtHNameTo = Common_TextField("txtHNameTo","�з�����");
	obj.txtMarkerTo = Common_TextField("txtMarkerTo","���");
	obj.txtFileNoTo = Common_TextField("txtFileNoTo","�ϼܺ�");

	obj.btnAssociat = new Ext.Button({
		id : 'btnAssociat'
		,iconCls : 'icon-wmr'
		,anchor : '100%'
		,text : '����'
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
			,{header: '����', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 70, dataIndex: 'AdmLoc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����״̬', width: 80 , align : 'center'
				,renderer : function(v, m, rd, r, c, s){
					var VolumeID  = rd.get("VolumeID");
					if (VolumeID == ''){
						return "";
					} else {
						return "�ѽ���";
					}
				}
			}
			,{header: '��������', width: 70, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
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
		,title : '���˻�������'
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