function VB_InitVolumeBack(){
	var obj = new Object();
	
	obj.VB_chkSelectAll = Common_Checkbox("VB_chkSelectAll","全选");
	
	obj.VB_btnSave = new Ext.Button({
		id : 'VB_btnSave'
		,iconCls : 'icon-confirm'
		,width: 60
		,text : '确定'
	});
	obj.VB_btnCancel = new Ext.Button({
		id : 'VB_btnCancel'
		,iconCls : 'icon-close'
		,width: 60
		,text : '关闭'
	});
	
	obj.VB_GridVolumeBackStore = new Ext.data.Store({
		autoLoad : false,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RecordID'
		},[
			{name: 'IsChecked', mapping : 'IsChecked'}
			,{name: 'RecordID', mapping : 'RecordID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PapmiNo' , mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping :'Age'}
			,{name: 'MainID', mapping : 'MainID'}
			,{name: 'StatusCode', mapping : 'StatusCode'}
			,{name: 'StatusDesc', mapping : 'StatusDesc'}
			,{name: 'LendDate', mapping : 'LendDate'}
			,{name: 'LendTime', mapping : 'LendTime'}
			,{name: 'LendUser', mapping : 'LendUser'}
			,{name: 'LLocCode', mapping : 'LLocCode'}
			,{name: 'LLocDesc', mapping : 'LLocDesc'}
			,{name: 'LLocTel', mapping : 'LLocTel'}
			,{name: 'LUserCode', mapping : 'LUserCode'}
			,{name: 'LUserDesc', mapping : 'LUserDesc'}
			,{name: 'LUserTel', mapping : 'LUserTel'}
			,{name: 'PurposeDescs', mapping : 'PurposeDescs'}
			,{name: 'PrintFlag', mapping : 'PrintFlag'}
			,{name: 'ExpBackDate', mapping : 'ExpBackDate'}
		])
		,sortInfo : {field : 'RecordID', direction : 'ASC'}
	});
	obj.VB_GridVolumeBack = new Ext.grid.GridPanel({
		id : 'VB_GridVolumeBack'
		,store : obj.VB_GridVolumeBackStore
		,region : 'center'
		,stripeRows : true
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : ['-',obj.VB_chkSelectAll,"全选",'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					var StatusCode = rd.get("StatusCode");
					if ((StatusCode=="U")||(StatusCode=="B")){
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
			,{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '姓名', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '状态', width: 40, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出库日期', width: 70, dataIndex: 'LendDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出库人', width: 70, dataIndex: 'LendUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅科室', width: 100, dataIndex: 'LLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科室电话', width: 80, dataIndex: 'LLocTel', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅人', width: 70, dataIndex: 'LUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅人电话', width: 80, dataIndex: 'LUserTel', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅目的', width: 80, dataIndex: 'PurposeDescs', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '预计归还日期', width: 70, dataIndex: 'ExpBackDate', sortable: false, menuDisabled:true, align: 'center'}
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
	
	obj.VB_WinVolumeBack = new Ext.Window({
		id : 'VB_WinVolumeBack'
		,height : 300
		,width : 650
		,modal : true
		,title : '病案出库记录'
		,closable : false
		,layout : 'fit'
		,buttonAlign : 'center'
		,items:[
			obj.VB_GridVolumeBack
		]
		,buttons : [obj.VB_btnSave,obj.VB_btnCancel]
	});
	
	VB_InitVolumeBackEvent(obj);
	obj.VB_LoadEvent(arguments);
	return obj;
}

