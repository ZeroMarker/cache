/// 名称：科室病区扩展信息维护
/// 描述:包含增删改查功能
/// 编写者:基础数据-likefan
/// 编写日期:2020-12-24
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function() {
	
	var CTLOCRowID=Ext.BDP.FunLib.getParam('selectrow')
	var CTLOCE_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocExtend&pClassMethod=OpenData";
	var CTLOCE_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocExtend&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocExtend"; 
	
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	var WinFormExt = new Ext.FormPanel({
		id : 'form-saveExt',
		title : '',
		region : 'center',
		labelAlign : 'right',
		labelWidth : 150,
		split : true,
		frame : true,
		waitMsgTarget : true,
		buttonAlign : 'center',
		reader: new Ext.data.JsonReader({root:'list'},
				[
				 {name: 'CTLOCERowID',mapping:'CTLOCERowID',type : 'string'},
				 {name: 'CTLOCEItro',mapping:'CTLOCEItro',type : 'string'},
				 {name: 'CTLOCEDeptType',mapping:'CTLOCEDeptType',type : 'string'},
				 {name: 'CTLOCEAprvBedCnt',mapping:'CTLOCEAprvBedCnt',type : 'string'},
				 {name: 'CTLOCEHiCrtfBedCnt',mapping:'CTLOCEHiCrtfBedCnt',type : 'string'},
				 {name: 'CTLOCEPoolareaNo',mapping:'CTLOCEPoolareaNo',type : 'string'},
				 {name: 'CTLOCEDrPsncnt',mapping:'CTLOCEDrPsncnt',type : 'string'},
				 {name: 'CTLOCEPharPsncnt',mapping:'CTLOCEPharPsncnt',type : 'string'},
				 {name: 'CTLOCENursPsncnt',mapping:'CTLOCENursPsncnt',type : 'string'},
				 {name: 'CTLOCETecnPsncnt',mapping:'CTLOCETecnPsncnt',type : 'string'},
				 {name: 'CTLOCEStandardCode',mapping:'CTLOCEStandardCode',type : 'string'},
				 {name: 'CTLOCEStandardDesc',mapping:'CTLOCEStandardDesc',type : 'string'},
				 {name: 'CTLOCEMedtechFlag',mapping:'CTLOCEMedtechFlag',type : 'string'},
				 {name: 'CTLOCEDeptMedServScp',mapping:'CTLOCEDeptMedServScp',type : 'string'},
				 {name: 'CTLOCEMedservType',mapping:'CTLOCEMedservType',type : 'string'},
				 {name: 'CTLOCEMemo',mapping:'CTLOCEMemo',type : 'string'}
				]),
		items : [{
				xtype:'fieldset',
				title:'科室扩展信息维护',
				labelWidth: 90,
				autoHeight:true,
				items :[{
					baseCls : 'x-plain',
					layout:'column',
					border:false,
					items:[{
						baseCls : 'x-plain',
						columnWidth:'.5',
						layout: 'form',
						labelWidth: 120,
						labelPad:1,//默认5
						border:false,
						defaults: {anchor:'96%',msgTarget:'under'},
						items: [{
							xtype:'textarea',
							fieldLabel: "科室简介",
							name: 'CTLOCEItro',
							id:'CTLOCEItro',
					        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEItro')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEItro'),
							dataIndex:'CTLOCEItro'
						},{
							xtype: 'textfield',
							fieldLabel: "诊疗科目类别",
							name: 'CTLOCEDeptType',
							id:'CTLOCEDeptType',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEDeptType')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEDeptType'),
							dataIndex:'CTLOCEDeptType'
						},{
							xtype: 'textfield',
							fieldLabel: "统筹区编号",
							name: 'CTLOCEPoolareaNo',
							id:'CTLOCEPoolareaNo',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEPoolareaNo')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEPoolareaNo'),
							dataIndex:'CTLOCEPoolareaNo'
						},{
							xtype: 'textfield',
							fieldLabel: "标准编码",
							name: 'CTLOCEStandardCode',
							id:'CTLOCEStandardCode',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEStandardCode')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEStandardCode'),
							dataIndex:'CTLOCEStandardCode'
						},{
							xtype: 'textfield',
							fieldLabel: "标准名称",
							name: 'CTLOCEStandardDesc',
							id:'CTLOCEStandardDesc',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEStandardDesc')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEStandardDesc'),
							dataIndex:'CTLOCEStandardDesc'
						},{
							xtype: 'textfield',
							fieldLabel: "科室医疗服务范围",
							name: 'CTLOCEDeptMedServScp',
							id:'CTLOCEDeptMedServScp',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEDeptMedServScp')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEDeptMedServScp'),
							dataIndex:'CTLOCEDeptMedServScp'
						},{
							xtype: 'textfield',
							fieldLabel: "医疗服务类型",
							name: 'CTLOCEMedservType',
							id:'CTLOCEMedservType',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEMedservType')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEMedservType'),
							dataIndex:'CTLOCEMedservType'
						},{
							
							xtype:'textfield',
							fieldLabel: "CTLOCERowID",
							name: 'CTLOCERowID',
							id:'CTLOCERowID',
							hideLabel : 'True',
							hidden : true
						}]					
					},{
						baseCls : 'x-plain',
						columnWidth:'.5',
						layout: 'form',
						labelWidth: 100,
						labelPad:1,
						border:false,
						defaults: {anchor:'96%',xtype: 'textfield',msgTarget:'under'},
						items: [{
								xtype: 'numberfield',
								fieldLabel: "医保认可床位数",
								name: 'CTLOCEHiCrtfBedCnt',
								id:'CTLOCEHiCrtfBedCnt',
								style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEHiCrtfBedCnt')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEHiCrtfBedCnt'),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								dataIndex:'CTLOCEHiCrtfBedCnt'
							},{
								xtype: 'numberfield',
								fieldLabel: "批准床位数量",
								name: 'CTLOCEAprvBedCnt',
								id:'CTLOCEAprvBedCnt',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEAprvBedCnt')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEAprvBedCnt'),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								dataIndex:'CTLOCEAprvBedCnt'
							},{
								xtype: 'numberfield',
								fieldLabel: "医师人数",
								name: 'CTLOCEDrPsncnt',
								id:'CTLOCEDrPsncnt',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEDrPsncnt')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEDrPsncnt'),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								dataIndex:'CTLOCEDrPsncnt'
							},{
								xtype: 'numberfield',
								fieldLabel: "药师人数",
								name: 'CTLOCEPharPsncnt',
								id:'CTLOCEPharPsncnt',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEPharPsncnt')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEPharPsncnt'),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								dataIndex:'CTLOCEPharPsncnt'
							},{
								xtype: 'numberfield',
								fieldLabel: "护士人数",
								name: 'CTLOCENursPsncnt',
								id:'CTLOCENursPsncnt',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCENursPsncnt')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCENursPsncnt'),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								dataIndex:'CTLOCENursPsncnt'
							},{
								xtype: 'numberfield',
								fieldLabel: "技师人数",
								name: 'CTLOCETecnPsncnt',
								id:'CTLOCETecnPsncnt',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCETecnPsncnt')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCETecnPsncnt'),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								dataIndex:'CTLOCETecnPsncnt'
							},{
								xtype: 'textfield',
								fieldLabel: "备注",
								name: 'CTLOCEMemo',
								id:'CTLOCEMemo',
								style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEMemo')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEMemo'),
								dataIndex:'CTLOCEMemo'
							},{
								xtype : 'checkbox',
								fieldLabel: '是否医技科室',
								name: 'CTLOCEMedtechFlag',
								id:'CTLOCEMedtechFlag',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCEMedtechFlag'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCEMedtechFlag')),
								inputValue : 'Y'
							}]						
					}]
				}]
			}],
		buttons:[{
			text : '保存',
			iconCls : 'icon-save',
			handler : function() {
				WinFormExt.form.submit({
					clientValidation : true, // 进行客户端验证
					waitMsg : '正在提交数据请稍后...',
					waitTitle : '提示',
					url : CTLOCE_SAVE_ACTION_URL,
					method : 'POST',
					success : function(form, action) {
						if (action.result.success == 'true') {
							var myrowid = action.result.id;
							// var myrowid = jsonData.id;
							Ext.Msg.show({
										title : '提示',
										msg : '保存成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											parent.HideParentWin(); 
										}
							});
						} else {
							var errorMsg = '';
							if (action.result.errorinfo) {
								errorMsg = '<br/>错误信息:' + action.result.errorinfo
							}
							Ext.Msg.show({
										title : '提示',
										msg : '保存失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
						}

					},
					failure : function(form, action) {
						Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
					}
				})
			}
		},{
			text : '新增上传',
			iconCls : 'icon-add',
			hidden : true,
			tooltip: '广东医保API数据上报-新增',
			handler : function() {
				var ReServer = tkMakeServerCall("web.DHCBL.BDP.UploadGuangZhouAPIData","LocInterface",Ext.getCmp("CTLOCERowID").getValue(),"A");
				//alert(ReServer);
				if (ReServer==0)
				{
					Ext.Msg.show({
						title : '提示',
						msg : '上传成功!',
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK,
						fn : function(btn) {
						}
					});
				}
				else
				{
					Ext.Msg.show({
						title : '提示',
						msg : '上传失败!',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
				}
			}
		},{
			text : '修改上传',
			iconCls : 'icon-update',
			hidden : true,
			tooltip: '广东医保API数据上报-修改',
			handler : function() {
				var ReServer = tkMakeServerCall("web.DHCBL.BDP.UploadGuangZhouAPIData","LocInterface",Ext.getCmp("CTLOCERowID").getValue(),"U");
				//alert(ReServer);
				if (ReServer==0)
				{
					Ext.Msg.show({
						title : '提示',
						msg : '上传成功!',
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK,
						fn : function(btn) {
						}
					});
				}
				else
				{
					Ext.Msg.show({
						title : '提示',
						msg : '上传失败!',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
				}
			}
		},{
			text : '撤销上传',
			iconCls : 'icon-delete',
			hidden : true,
			tooltip: '广东医保API数据上报-撤销',
			handler : function() {
				var ReServer = tkMakeServerCall("web.DHCBL.BDP.UploadGuangZhouAPIData","LocInterface",Ext.getCmp("CTLOCERowID").getValue(),"D");
				//alert(ReServer);
				if (ReServer==0)
				{
					Ext.Msg.show({
						title : '提示',
						msg : '撤销成功!',
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK,
						fn : function(btn) {
						}
					});
				}
				else
				{
					Ext.Msg.show({
						title : '提示',
						msg : '撤销失败!',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
				}
			}
		}, {
				text : '关闭',
				iconCls : 'icon-close',
				handler : function() {
					parent.HideParentWin(); 
				}
		}]
	})

   // 载入被选择的数据行的表单数据
    var loadFormData = function() {
        WinFormExt.form.load( {
            url : CTLOCE_OPEN_ACTION_URL + '&id='+ CTLOCRowID,
            //waitMsg : '正在载入数据...',
            success : function(form,action) {
            	
            },
            failure : function(form,action) {
            	Ext.Msg.alert('编辑','载入失败！');
            }
        });
    };
    loadFormData()
    
	//创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [WinFormExt]
	});

});