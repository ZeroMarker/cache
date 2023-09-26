// 名称:注册证号
// 编写日期:2019-08-27
function RegNoInfo(No,fn,Incid,manf) {

	var MRCNo = new Ext.form.TextField({
			id:'MRCNo',
			fieldLabel: '注册证号',
			allowBlank: false,
			anchor: '90%',
			value:No,
			selectOnFocus: true
		});

	var CategoryStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [["I", 'I'], ["II", 'II'],["III",'III']]
		});

	var MRCCategory = new Ext.form.ComboBox({
			id:'MRCCategory',
			fieldLabel: '注册证类型',
			allowBlank: true,
			store: CategoryStore,
			valueField: 'key',
			displayField: 'keyValue',
			triggerAction: 'all',
			anchor: '90%',
			selectOnFocus: true,
			forceSelection: true,
			mode: 'local'
		});

	var MRCRegName = new Ext.form.TextField({
			id:'MRCRegName',
			fieldLabel: '注册人名称',
			anchor: '90%',
			selectOnFocus: true
		});

	var MRCRegPerAddress = new Ext.form.TextField({
			id:'MRCRegPerAddress',
			fieldLabel: '注册人住所',
			anchor: '90%',
			maxLength: 20
		});

	var MRCRegAgent = new Ext.form.TextField({
			id:'MRCRegAgent',
			fieldLabel: '代理人名称.',
			anchor: '90%',
			allowBlank: true
		});
	var MRCAgentAddress = new Ext.form.TextField({
			id:'MRCAgentAddress',
			fieldLabel: '代理人住所',
			anchor: '90%',
			selectOnFocus: true
		});
		
	var MRCInciDesc = new Ext.form.TextField({
			id:'MRCInciDesc',
			anchor: '90%',
			fieldLabel: '产品名称',
			allowBlank: true
		});

	var MRCSpecForm = new Ext.form.TextField({
			id:'MRCSpecForm',
			anchor: '90%',
			fieldLabel: '规格型号',
			allowBlank: true
		});
	var MRCStructure = new Ext.form.TextField({
			id:'MRCStructure',
			anchor: '90%',
			fieldLabel: '结构及组成',
			allowBlank: true
		});

	var MRCAppliedRange = new Ext.form.TextField({
			id:'MRCAppliedRange',
			anchor: '90%',
			fieldLabel: '适用范围',
			allowBlank: true
		});

	var MRCRemark = new Ext.form.TextField({
			id:'MRCRemark',
			fieldLabel: '备注',
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});
	var MRCApprovalDate = new Ext.ux.DateField({
			id:'MRCApprovalDate',
			fieldLabel: '批准日期',
			allowBlank: true,
			disabled: false,
			anchor: '90%'
		});
	var MRCValidUntil = new Ext.ux.DateField({
			id: 'MRCValidUntil',
			fieldLabel: '有效期至',
			allowBlank: true,
			anchor: '90%'
		});


	var saveButton = new Ext.Toolbar.Button({
			text: '保存',
			iconCls: 'page_save',
			handler: function () {
			var RegData=getRegDataStr();
			UpdRegNoInfo(RegData);
			}
		});

	var cancelButton = new Ext.Toolbar.Button({
			text: '关闭',
			iconCls: 'page_close',
			handler: function () {
				win.close();
			}
		});
	var Panel = new Ext.form.FormPanel({
			labelWidth: 90,
			labelAlign: 'right',
			frame: true,
			autoScroll: true,
			bodyStyle: 'padding:5px;',
			items: [{
					xtype: 'fieldset',
					title: '注册证信息',
					autoHeight: true,
					items: [{
							layout: 'column',
							items: [{
									columnWidth: .5,
									layout: 'form',
									items: [MRCNo]
								}, {
									columnWidth: .5,
									layout: 'form',
									items: [MRCCategory]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .5,
									layout: 'form',
									items: [MRCRegName]
								}, {
									columnWidth: .5,
									layout: 'form',
									items: [MRCRegPerAddress]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .5,
									layout: 'form',
									items: [MRCRegAgent]
								}, {
									columnWidth: .5,
									layout: 'form',
									items: [MRCAgentAddress]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .5,
									layout: 'form',
									items: [MRCInciDesc]
								},{
									columnWidth: .5,
									layout: 'form',
									items: [MRCSpecForm]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: 1,
									layout: 'form',
									items: [MRCStructure]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: 1,
									layout: 'form',
									items: [MRCAppliedRange]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: 1,
									layout: 'form',
									items: [MRCRemark]
								}
							]
						}, {
							layout: 'column',
							items: [{
									columnWidth: .5,
									layout: 'form',
									items: [MRCApprovalDate]
								},{
									columnWidth: .5,
									layout: 'form',
									items: [MRCValidUntil]
								}
							]
						}
					]
				}
			]
		});

	//初始化窗口
	var win = new Ext.Window({
			title: '注册证信息维护',
			width: gWinWidth,
			height: gWinHeight,
			layout: 'fit',
			plain: true,
			modal: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'right',
			items: Panel,
			buttons: [saveButton, cancelButton],
			listeners: {
				'show': function () {
					SetRegNoInfo(No);
				}
			}
		});

	win.show();

	function SetRegNoInfo(No) {
		Ext.Ajax.request({
			url: 'dhcstm.druginfomaintainaction.csp?actiontype=getByRegNo',
			params: {
				No:No
			},
			failure: function (result, request) {
				Msg.info('error', '失败！');
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var value = jsonData.info;
					if(Ext.isEmpty(value)){
						return;
					}
					var arr = value.split("^");
					//Ext.getCmp('MRCNo').setValue(arr[0]);
					Ext.getCmp('MRCNo').setValue(arr[1]);
					Ext.getCmp('MRCInciDesc').setValue(arr[2]);
					Ext.getCmp('MRCApprovalDate').setRawValue(arr[3]);
					Ext.getCmp('MRCValidUntil').setValue(arr[4]);
					Ext.getCmp('MRCCategory').setValue(arr[5]);
					Ext.getCmp('MRCRegName').setValue(arr[6]);
					Ext.getCmp('MRCRegPerAddress').setValue(arr[7]);
					Ext.getCmp('MRCSpecForm').setValue(arr[8]);
					Ext.getCmp('MRCStructure').setValue(arr[9]);
					Ext.getCmp('MRCAppliedRange').setValue(arr[10]);
					Ext.getCmp('MRCRemark').setValue(arr[11]);
					Ext.getCmp('MRCRegAgent').setValue(arr[12]);
					Ext.getCmp('MRCAgentAddress').setValue(arr[12]);
				}
			},
			scope: this
		});
	}

	function getRegDataStr() {
		var MRCNo = Ext.getCmp("MRCNo").getValue();
		var MRCCategory =Ext.getCmp("MRCCategory").getValue();
		var MRCRegName =Ext.getCmp("MRCRegName").getValue();
		var MRCRegPerAddress =Ext.getCmp("MRCRegPerAddress").getValue();
		var MRCRegAgent =Ext.getCmp("MRCRegAgent").getValue();
		var MRCAgentAddress =Ext.getCmp("MRCAgentAddress").getValue();
		var MRCInciDesc =Ext.getCmp("MRCInciDesc").getValue();
		var MRCSpecForm =Ext.getCmp("MRCSpecForm").getValue();
		var MRCStructure =Ext.getCmp("MRCStructure").getValue();
		var MRCAppliedRange =Ext.getCmp("MRCAppliedRange").getValue();
		var MRCRemark =Ext.getCmp("MRCRemark").getValue();
		var MRCApprovalDate = Ext.getCmp('MRCApprovalDate').getValue();
		if (!Ext.isEmpty(MRCApprovalDate)) {
			MRCApprovalDate = MRCApprovalDate.format(ARG_DATEFORMAT);
		}
		var MRCValidUntil = Ext.getCmp('MRCValidUntil').getValue();
		if (!Ext.isEmpty(MRCValidUntil)) {
			MRCValidUntil = MRCValidUntil.format(ARG_DATEFORMAT);
		}
		//拼data字符串
		var data = "" + "^" + MRCNo + "^" + MRCCategory +"^"+MRCRegName+ "^" + MRCRegPerAddress + "^" + MRCRegAgent + "^" + MRCAgentAddress
			+ "^" + MRCInciDesc + "^" + MRCSpecForm + "^" + MRCStructure + "^" + MRCAppliedRange + "^" + MRCRemark
			+ "^" + MRCApprovalDate + "^" + MRCValidUntil+ "^" +Incid+ "^" +manf;
		return data;
	}


	function UpdRegNoInfo(data) {
		var mask = ShowLoadMask(win.body, "处理中请稍候...");
		Ext.Ajax.request({
			url:'dhcstm.druginfomaintainaction.csp?actiontype=saveRegInfo', //&data='+data,
			params: {
				data: data
			},
			waitMsg: '更新中...',
			failure: function (result, request) {
				Msg.info("error", "请检查网络连接!");
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success", "更新成功!");
					var infoArr=jsonData.info.split("^");
					var regRowId=infoArr[0];
					var regNo=infoArr[1];
					fn(regNo);
					win.close();
				} else {
					Msg.info("error", "更新错误:" + jsonData.info);
				}
			},
			scope: this
		});
	}
}