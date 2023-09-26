function BL_InitVolumeLend(){
	var obj = new Object();

	obj.BL_chkSelectAll = Common_Checkbox("BL_chkSelectAll","ȫѡ");
	
	obj.BL_btnSave = new Ext.Button({
		id : 'BL_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : 'ȷ��'
	});
	obj.BL_btnCancel = new Ext.Button({
		id : 'BL_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '�ر�'
	});
	
	obj.BL_GridVolumeLendStore = new Ext.data.Store({
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
			,{name: 'ProblemCode', mapping : 'ProblemCode'}
			,{name: 'ProblemDesc', mapping : 'ProblemDesc'}
		])
		,sortInfo : {field : 'VolID', direction : 'ASC'}
	});
	obj.BL_GridVolumeLend = new Ext.grid.GridPanel({
		id : 'BL_GridVolumeLend'
		,store : obj.BL_GridVolumeLendStore
		,region : 'center'
		,stripeRows : true
		,loadMask : { msg : '���ڲ�ѯ,���Ժ�...'}
		,tbar : ['-',obj.BL_chkSelectAll,"ȫѡ",'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ѡ��', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (rd.get('ProblemCode') != 1){
						return "<IMG src='../scripts/dhcwmr/img/error.png'>";
					} else {
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
			,{header: '�Ա�', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 50, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: MrClass=='O'?'��������':'��������', width: 90, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��Ժ����', width: 90, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��������', width: 90, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: MrClass=='O'?'�������':'�������', width: 100, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'center'}
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
	
	obj.BL_WinVolumeLend = new Ext.Window({
		id : 'BL_WinVolumeLend'
		,height : 500
		,width : 650
		,modal : true
		,title : '���Ĳ������б�'
		,closable : false
		,layout : 'border'
		,buttonAlign : 'center'
		,items:[obj.BL_GridVolumeLend]
		,buttons : [obj.BL_btnSave,obj.BL_btnCancel]
	});
	
	BL_InitVolumeLendEvent(obj);
	obj.BL_LoadEvent(arguments);
	return obj;
}

