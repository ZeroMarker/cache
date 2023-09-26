function BVC_InitVolumeCopy(){
	var obj = new Object();
	
	obj.BVC_btnSave = new Ext.Button({
		id : 'BVC_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : 'ȷ��'
	});
	obj.BVC_btnCancel = new Ext.Button({
		id : 'BVC_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '�ر�'
	});
	
	obj.BVC_GridVolumeCopyStore = new Ext.data.Store({
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
	obj.BVC_GridVolumeCopy = new Ext.grid.GridPanel({
		id : 'BVC_GridVolumeCopy'
		,store : obj.BVC_GridVolumeCopyStore
		,region : 'center'
		,stripeRows : true
		,loadMask : { msg : '���ڲ�ѯ,���Ժ�...'}
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
			//,{header: '�������', width: 70, dataIndex: 'VolID', sortable: false, menuDisabled:true, align: 'center'}
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
	
	obj.BVC_WinVolumeCopy = new Ext.Window({
		id : 'BVC_WinVolumeCopy'
		,height : 500
		,width : 650
		,modal : true
		,title : '��ӡ�������б�'
		,closable : false
		,layout : 'border'
		,buttonAlign : 'center'
		,items:[obj.BVC_GridVolumeCopy]
		,buttons : [obj.BVC_btnSave,obj.BVC_btnCancel]
	});
	
	BVC_InitVolumeCopyEvent(obj);
	obj.BVC_LoadEvent(arguments);
	return obj;
}

