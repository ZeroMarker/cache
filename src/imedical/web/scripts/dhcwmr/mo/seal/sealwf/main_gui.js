var objScreen = new Object();
function InitViewport()
{
	var obj = objScreen;
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","ҽԺ",SSHospCode);
	obj.cboMrType 	= Common_ComboToMrType("cboMrType","��������",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","��ѯ����");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","��");
	
	obj.cboQryType = new Ext.form.ComboBox({
		id : 'cboQryType'
		,name :'cboQryType'
		,fieldLabel : '����״̬'
		,mode : 'local'
		,valueField : 'svalue'
		,displayField : 'stext'
		,triggerAction : 'all'
		,value : 'S'
		,anchor : '100%'
		,store: new Ext.data.ArrayStore({
			fields:['svalue','stext'],
			data:[["S","���"],["F","���"]]
		})
	});

	obj.txtMrNo = new Ext.form.TextField({
		id : "txtMrNo"
		,fieldLabel : "������"
		,emptyText : ''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 180
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 60
		,anchor : '100%'
		,text : '��ѯ'
	});
	
	obj.btnSeal = new Ext.Button({
		id : 'btnSeal'
		,iconCls : 'icon-edit'
		,width : 80
		,anchor : '100%'
		,text : '���'
	});
	
	obj.btnFree = new Ext.Button({
		id : 'btnFree'
		,iconCls : 'icon-edit'
		,width : 60
		,anchor : '100%'
		,text : '���'
	});
		
	obj.gridSealRecordStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridSealRecordStore = new Ext.data.Store({
		proxy: obj.gridSealRecordStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RecordID'
		},[
			{name: 'RecordID', mapping : 'RecordID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PapmiNo' , mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping :'Age'}
			,{name: 'Status', mapping :'Status'}
			,{name: 'StatusDesc', mapping :'StatusDesc'}
			,{name: 'SealDate', mapping :'SealDate'}
			,{name: 'SealTime', mapping :'SealTime'}
			,{name: 'SealUser', mapping :'SealUser'}
			,{name: 'FreeDate', mapping :'FreeDate'}
			,{name: 'FreeTime', mapping :'FreeTime'}
			,{name: 'FreeUser', mapping :'FreeUser'}
		])
	});
	
	obj.gridSealRecord = new Ext.grid.GridPanel({
		id : 'gridSealRecord'
		,store : obj.gridSealRecordStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : [{id:'msggridSealRecord',text:'����ѯ�б�',style:'font-weight:bold;font-size:17px;',xtype:'label'},
		'->',{text:'�����ţ�',style:'font-weight:bold;font-size:17px;',xtype:'label'},obj.txtMrNo,'-',obj.btnFree]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ѡ��', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					var StatusCode = rd.get("StatusCode");
					if (StatusCode=="U"){
						return "<IMG src='../scripts/dhcwmr/img/error.png'>";
					}else{
						if (IsChecked == '1') {
							return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
						} else {
							return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
						}
					}
				}
			}
			,{header: '������', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '����', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�Ա�', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '״̬', width: 40, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�������', width: 40, dataIndex: 'SealDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '���ʱ��', width: 40, dataIndex: 'SealTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�����', width: 40, dataIndex: 'SealUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�������', width: 40, dataIndex: 'FreeDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '���ʱ��', width: 40, dataIndex: 'FreeTime,', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�����', width: 40, dataIndex: 'FreeUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�ǼǺ�', width: 70, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true,
			getRowClass: function(record, index) {
				if (record.get('IsChecked') == '1') {
					return 'x-grid-record-red';
				} else{
					return '';
				}
			}
		}
    });

	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout: 'border'
		,items:[
			{
				region:'north'
				,layout:'column'
				,height: 40
				,frame: true
				,items:[
					{
						width:220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items:[obj.cboHospital]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.cboMrType]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.dfDateFrom]
					},{
						width:130
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items:[obj.dfDateTo]
					},{
						width:130
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.cboQryType]
					},{
						width:5
						,layout:'form'
					},{
						width:70
						,layout:'form'
						,items:[obj.btnQuery]
					}
				]
			},obj.gridSealRecord
		]
	});
	
	obj.gridSealRecordStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MOService.SealRecordSrv';
		param.QueryName = 'QrySealRecord';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("dfDateFrom");
		param.Arg4 = Common_GetValue("dfDateTo");
		param.Arg5 = Common_GetValue("txtMrNo");
		param.Arg6 = Common_GetValue("cboQryType");
		param.ArgCnt = 6;
	});
	InitViewportEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}