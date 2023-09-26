function VL_InitVolumeLend(){
	var obj = new Object();
	
	obj.VL_cboLendLoc = Common_ComboToLendLoc("VL_cboLendLoc","借阅科室<font color='red'>*</font>","E","","cboHospital");
	obj.VL_cboLendDoc = Common_ComboToLendUser("VL_cboLendDoc","借阅医生<font color='red'>*</font>","VL_cboLendLoc");
	obj.VL_txtLUserTel = Common_TextField("VL_txtLUserTel","医生电话");
	obj.VL_txtLLocTel = Common_TextField("VL_txtLLocTel","科室电话");
	obj.VL_cbgLPurpose = Common_CheckboxGroupToDic("VL_cbgLPurpose","借阅目的","LendAim",5,"","cboHospital");
	obj.VL_txtLExpBackDate = Common_DateFieldToDate("VL_txtLExpBackDate","预计归还日期");
	obj.VL_txtLNote = Common_TextArea("VL_txtLNote","备注信息",50,500);
	
	obj.VL_chkSelectAll = Common_Checkbox("VL_chkSelectAll","全选");
	
	obj.VL_btnSave = new Ext.Button({
		id : 'VL_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : '确定'
	});
	obj.VL_btnCancel = new Ext.Button({
		id : 'VL_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '关闭'
	});
	
	obj.VL_GridVolumeLendStore = new Ext.data.Store({
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
	obj.VL_GridVolumeLend = new Ext.grid.GridPanel({
		id : 'VL_GridVolumeLend'
		,store : obj.VL_GridVolumeLendStore
		,region : 'center'
		,stripeRows : true
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : ['-',obj.VL_chkSelectAll,"全选",'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
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
			,{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '姓名', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: MrClass=='O'?'初诊日期':'就诊日期', width: 90, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', width: 90, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '回收日期', width: 90, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: MrClass=='O'?'初诊科室':'就诊科室', width: 100, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病历状态', width: 70, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '病案卷号', width: 70, dataIndex: 'VolID', sortable: false, menuDisabled:true, align: 'center'}
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
	
	obj.VL_WinVolumeLend = new Ext.Window({
		id : 'VL_WinVolumeLend'
		,height : 500
		,width : 650
		,modal : true
		,title : '借阅病案卷列表'
		,closable : false
		,layout : 'border'
		,buttonAlign : 'center'
		,items:[
			{
				region: 'center',
				layout : 'border',
				items : [
					{
						region: 'south',
						height: 230,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width:300
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VL_cboLendLoc]
									},{
										width:300
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VL_txtLLocTel]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:300
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VL_cboLendDoc]
									},{
										width:300
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VL_txtLUserTel]
									}
								]
							},{
								width:600
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.VL_cbgLPurpose]
							},{
								width:300
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.VL_txtLExpBackDate]
							},{
								width:600
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.VL_txtLNote]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.VL_GridVolumeLend
						]
					}
				]
			}
		]
		,buttons : [obj.VL_btnSave,obj.VL_btnCancel]
	});
	
	VL_InitVolumeLendEvent(obj);
	obj.VL_LoadEvent(arguments);
	return obj;
}

