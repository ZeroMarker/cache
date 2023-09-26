function VC_InitVolumeCopy()
{
	var obj = new Object();

	obj.VC_ClientName 			= Common_TextField("VC_ClientName","委托人<font color='red'>*</font>");
	obj.VC_cboClientRelation 	= Common_ComboToDic("VC_cboClientRelation","与患者关系<font color='red'>*</font>","RelationType");
	obj.VC_cboCardType 			= Common_ComboToDic("VC_cboCardType","证明材料<font color='red'>*</font>","Certificate");
	obj.VC_txtPersonalID 		= Common_TextField("VC_txtPersonalID","证件号码<font color='red'>*</font>");
	obj.VC_txtTelephone 		= Common_TextField("VC_txtTelephone","联系电话<font color='red'>*</font>");
	obj.VC_txtAddress 			= Common_TextField("VC_txtAddress","联系地址");
	obj.VC_cbgPurpose 			= Common_CheckboxGroupToDC("VC_cbgPurpose","复印目的<font color='red'>*</font>","CopyAim",5,"cboHospital");
	obj.VC_cbgContent 			= Common_CheckboxGroupToDC("VC_cbgContent","复印内容","MrCopyInfo",5,"cboHospital");
	obj.VC_txtResume 			= Common_TextField("VC_txtResume","备注信息");
	obj.VC_chkSelectAll 		= Common_Checkbox("VC_chkSelectAll","全选");
	
	obj.VC_txtPaperNumber = new Ext.form.NumberField({
		id:'VC_txtPaperNumber'
		,width:100
		,anchor : '100%'
		,fieldLabel:"复印张数<font color='red'>*</font>"
	});

	obj.VC_btnSave = new Ext.Button({
		id : 'VC_btnSave'
		,iconCls : 'icon-save'
		,width : 80
		,anchor : '100%'
		,text : '登记'
	});
	
	obj.VC_GridVolumeCopyStore = new Ext.data.Store({
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
	obj.VC_GridVolumeCopy = new Ext.grid.GridPanel({
		id : 'VC_GridVolumeCopy'
		,store : obj.VC_GridVolumeCopyStore
		,region : 'center'
		,stripeRows : true
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : ['-',obj.VC_chkSelectAll,"全选",'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '姓名', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '初诊日期', width: 70, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '初诊科室', width: 100, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'center'}
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
	
	
	obj.VC_WinVolumeCopy = new Ext.Window({
		id: 'VC_WinVolumeCopy'
		,height : 550
		,width : 750
		,modal : true
		,title : '复印信息录入'
		,closable : true
		,layout : 'border'
		,buttonAlign:'center'
		,items:[
			{
				region:'center'
				,layout:'border'
				,items:[
					{
						region:'south'
						,layout:'form'
						,height: 300
						,frame: true
						,items:[
							{
								layout : 'column',
								items : [
									{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VC_ClientName]
									},{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VC_txtPersonalID]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VC_cboClientRelation]
									},{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VC_txtTelephone]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VC_cboCardType]
									},{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VC_txtAddress]
									}
								]
							},{
								width:700
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.VC_cbgPurpose]
							},{
								width:700
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.VC_cbgContent]
							},{
								layout : 'column',
								items : [
									{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VC_txtPaperNumber]
									},{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.VC_txtResume]
									}
								]
							}
						]
					},
					{
						region:'center'
						,layout:'fit'
						,items:[obj.VC_GridVolumeCopy]
					}
				]
			}
		]
		,buttons:[obj.VC_btnSave]
	});
	
	VC_InitVolumeCopyEvents(obj);
	obj.VC_LoadEvents(arguments);
	return obj;
}