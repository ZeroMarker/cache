function��VS_InitVolumeSeal()
{
	var obj = new Object();
	obj.VS_txtClientName 		= Common_TextField("VS_txtClientName","ί��������");
	obj.VS_cboClientRelation 	= Common_ComboToDic("VS_cboClientRelation","�뻼�߹�ϵ","RelationType");
	obj.VS_cboCardType 			= Common_ComboToDic("VS_cboCardType","֤������","Certificate");
	obj.VS_txtPersonalID 		= Common_TextField("VS_txtPersonalID","֤������");
	obj.VS_txtTelephone 		= Common_TextField("VS_txtTelephone","��ϵ�绰");
	obj.VS_txtAddress 			= Common_TextField("VS_txtAddress","��ϵ��ַ");
	obj.VS_cboContent 			= Common_ComboToDic("VS_cboContent","�������","StoreContent");
	obj.VS_cboReason 			= Common_ComboToDic("VS_cboReason","���ԭ��","StoreReason");
	obj.VS_txtCount 			= Common_TextField("VS_txtCount","����");
	obj.VS_cboDoc 				= Common_ComboToLendUser("VS_cboDoc","ҽʦ","","","DOCTOR");
	obj.VS_cboMedUser 			= Common_ComboToLendUser("VS_cboMedUser","ҽ����Ա","");
	obj.VS_txtNote 				= Common_TextField("VL_txtNote","��ע��Ϣ");
	obj.VS_chkSelectAll 		= Common_Checkbox("VS_chkSelectAll","ȫѡ");
	obj.VS_btnSave = new Ext.Button({
		id : 'VS_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : 'ȷ��'
	});
	obj.VS_btnCancel = new Ext.Button({
		id : 'VS_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '�ر�'
	});
	obj.VS_GridVolumeSealStore = new Ext.data.Store({
		autoLoad : false,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VolID'
		},[
			{name: 'IsChecked', mapping : 'IsChecked'}
			,{name: 'VolID', mapping : 'VolID'}
			,{name: 'MainID', mapping : 'MainID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping : 'Age'}
			,{name: 'IdentityCode', mapping : 'IdentityCode'}
			,{name: 'AdmLocDesc', mapping : 'AdmLocDesc'}
			,{name: 'AdmWardDesc', mapping : 'AdmWardDesc'}
			,{name: 'AdmDate', mapping : 'AdmDate'}
			,{name: 'AdmTime', mapping : 'AdmTime'}
			,{name: 'DischDate', mapping : 'DischDate'}
			,{name: 'BackDate', mapping : 'BackDate'}
			,{name: 'StepDesc', mapping : 'StepDesc'}
			,{name: 'StatusDesc', mapping : 'StatusDesc'}
		])
		,sortInfo : {field : 'VolID', direction : 'ASC'}
	});
	obj.VS_GridVolumeSeal = new Ext.grid.GridPanel({
		id : 'VS_GridVolumeSeal'
		,store : obj.VS_GridVolumeSealStore
		,region : 'center'
		,stripeRows : true
		,layout:'fit'
		,loadMask : { msg : '���ڲ�ѯ,���Ժ�...'}
		,tbar : ['-',obj.VS_chkSelectAll,"ȫѡ",'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ѡ��', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '������', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '����', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�Ա�', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 50, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��������', width: 70, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�������', width: 100, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����״̬', width: 70, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�������', width: 70, dataIndex: 'VolID', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			//forceFit : true,
			getRowClass: function(record, index) {
				if (record.get('IsChecked') == '1') {
					return 'x-grid-record-red';
				} else{
					return '';
				}
			}
		}
	});
	
	obj.VS_WinVolumeSeal = new Ext.Window({
		id : 'VS_WinVolumeSeal'
		,height : 500
		,width : 600
		,modal : true
		,title : '��������¼'
		,closable : false
		,layout : 'border'
		,buttonAlign : 'center'
		,items:[
			{
				region:'south'
				,layout:'column'
				,height:180
				,frame:true
				,items:[
					{
						layout : 'form'
						,columnWidth :.5
						,labelAlign : 'right'
						,labelWidth : 90
						,items: [obj.VS_txtClientName,obj.VS_cboCardType,obj.VS_txtTelephone,obj.VS_cboContent,obj.VS_txtCount,obj.VS_cboMedUser]
					},{
						layout : 'form'
						,columnWidth :.5
						,labelAlign : 'right'
						,labelWidth : 90
						,items: [obj.VS_cboClientRelation,obj.VS_txtPersonalID,obj.VS_txtAddress,obj.VS_cboReason,obj.VS_cboDoc,obj.VS_txtNote]
					}
				]
			}
			,obj.VS_GridVolumeSeal
		]
		,buttons : [obj.VS_btnSave,obj.VS_btnCancel]
	});
	VS_InitVolumeSealEvent(obj);
	obj.VS_LoadEvents(arguments);
	return obj;
}