function VS_InitVolumeSelect(){
	var obj = new Object();
	obj.VS_Argument = new Object();
	obj.VS_Argument.MrTypeID = '';
	obj.VS_Argument.WFItemOBJ = new Object();
	obj.VS_Argument.MrNo = '';
	
	obj.VS_chkSelectAll = Common_Checkbox("VS_chkSelectAll","全选");
	
	obj.VS_btnSave = new Ext.Button({
		id : 'VS_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : '确定'
	});
	obj.VS_btnCancel = new Ext.Button({
		id : 'VS_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '关闭'
	});
	
	obj.VS_txtMrNo = new Ext.form.TextField({
		id : "VS_txtMrNo"
		,fieldLabel : "病案号"
		,emptyText : '病案号/条码号/批次号'
		,regex : /^[A-Za-z0-9]+$/
		,anchor : '100%'
	});
	
	obj.VS_GridVolumeSelectStore = new Ext.data.Store({
		autoLoad : false,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RecordID'
		},
		[
			{name: 'RecordID', mapping: 'RecordID'}
			,{name: 'ProblemCode', mapping: 'ProblemCode'}
			,{name: 'ProblemDesc', mapping: 'ProblemDesc'}
			,{name: 'HappenDate', mapping: 'HappenDate'}
			,{name: 'HappenTime', mapping: 'HappenTime'}
			,{name: 'HappenUser', mapping: 'HappenUser'}
			,{name: 'HappenUserDesc', mapping: 'HappenUserDesc'}
			,{name: 'RequestDate', mapping: 'RequestDate'}
			,{name: 'RequestTime', mapping: 'RequestTime'}
			,{name: 'RequestUser', mapping: 'RequestUser'}
			,{name: 'RequestUserDesc', mapping: 'RequestUserDesc'}
			,{name: 'VolID', mapping : 'VolID'}
			,{name: 'MainID', mapping : 'MainID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmLocDesc', mapping: 'AdmLocDesc'}
			,{name: 'AdmWardDesc', mapping: 'AdmWardDesc'}
			,{name: 'AdmDate', mapping: 'AdmDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'BackDate', mapping: 'BackDate'}
			,{name: 'StepDesc', mapping: 'StepDesc'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'IsChecked', mapping : 'IsChecked'}
		])
		,sortInfo : {field : 'MainID', direction : 'ASC'}
	});
	obj.VS_GridVolumeSelect = new Ext.grid.GridPanel({
		id : 'VS_GridVolumeSelect'
		,store : obj.VS_GridVolumeSelectStore
		,region : 'center'
		,stripeRows : true
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : [
			'-',obj.VS_chkSelectAll,"全选",'->','-','病案号：',obj.VS_txtMrNo,'-',obj.VS_btnSave,'-',obj.VS_btnCancel,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '标记', width: 50, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
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
			,{header: '病历情况', width: 120, dataIndex: 'ProblemDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记号', width: 90, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '姓名', width: 60, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 60, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '性<br>别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年<br>龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前<br>步骤', width: 50, dataIndex: 'StepDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 80, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}	  //add by niepeng 20141217
			,{header: '科室', width: 120, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', width: 80, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请日期', width: 80, dataIndex: 'RequestDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记日期', width: 80, dataIndex: 'HappenDate', sortable: false, menuDisabled:true, align: 'center'}
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
	
	obj.VS_WinVolumeSelect = new Ext.Window({
		id : 'VS_WinVolumeSelect'
		,height : 450
		,width : 800
		,modal : true
		,title : '病案卷查询'
		,closable : false
		,layout : 'border'
		,buttonAlign : 'center'
		,items:[
			obj.VS_GridVolumeSelect
		]
	});
	
	VS_InitVolumeSelectEvent(obj);
	obj.VS_LoadEvent(arguments);
	return obj;
}

