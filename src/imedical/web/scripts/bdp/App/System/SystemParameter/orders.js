 /// 名称:系统配置 - 安全组系统配置-医嘱与结果
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
    
    var OECFPriorityDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECPriority&pClassQuery=GetDataForCmb1";
	var OECFPatLeaveOrderAdmStatusDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderAdminStatus&pClassQuery=GetDataForCmb1";
	var OECFCMVTestDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetDataForCmb1";
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  
	var formSearch = new Ext.form.FormPanel({
		frame:true,
		autoScroll:true,///滚动条
		border:false,
		region: 'center',
		width:500,
		iconCls:'icon-find',
		///collapsible:true,
		split: true,
		//bodyStyle:'padding:5px 5px 0',
		//baseCls:'x-plain',
		buttonAlign:'center',
		labelAlign : 'right',
		labelWidth : 140,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'OECFPriorityDR',mapping:'OECFPriorityDR'},
                                        {name: 'OECFDefaultOrderGroup',mapping:'OECFDefaultOrderGroup'},
                                        {name: 'OECFDiagWarning',mapping:'OECFDiagWarning'},
                                        {name: 'OECFCheckPrice',mapping:'OECFCheckPrice'},
                                        {name: 'OECFPatLeaveOrderAdmStatusDR',mapping:'OECFPatLeaveOrderAdmStatusDR'},
                                        {name: 'OECFOrdersToRecLoc',mapping:'OECFOrdersToRecLoc'},
                                        {name: 'OECFShowInstructionAs',mapping:'OECFShowInstructionAs'},
                                        {name: 'OECFUseRepeatsOrEndDate',mapping:'OECFUseRepeatsOrEndDate'},
                                        {name: 'OECFCMVTestDR',mapping:'OECFCMVTestDR'},
                                        {name: 'OECFNumberOfOrdersAllowedSameGr',mapping:'OECFNumberOfOrdersAllowedSameGr'},
                                        {name: 'OECFAgeFrom',mapping:'OECFAgeFrom'},
                                        {name: 'OECFAgeTo',mapping:'OECFAgeTo'}
                                 ]),
		
		items:[
			
				{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				width:200,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '医嘱优先级',
				hiddenName : 'OECFPriorityDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFPriorityDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFPriorityDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'OECPRDesc',
				valueField : 'OECPRRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : OECFPriorityDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'OECPRRowId',mapping:'OECPRRowId'},
							{name:'OECPRDesc',mapping:'OECPRDesc'} ])
					})
			},{
				fieldLabel : 'Default Order Group',
				xtype:'textfield',
				width:200,
				maxLength:10,
				id:'OECFDefaultOrderGroup',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDefaultOrderGroup'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDefaultOrderGroup')),
				name : 'OECFDefaultOrderGroup'
			},{
				xtype : "combo",
				///emptyText:'请选择',
				width:200,
				fieldLabel : 'Diagnosis Warning message logic',
				hiddenName : 'OECFDiagWarning',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFDiagWarning'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFDiagWarning')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'name',
				valueField : 'value',
				store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
								name : 'No Warning',
								value : 'N'
							}, {
								name : 'Warning for Out Patients',
								value : 'O'
							}, {
								name : 'Warning for In Patients',
								value : 'I'
							}, {
								name : 'Warning for all Patients',
								value : 'A'
							}, {
								name : 'Auto Add Diagnosis',
								value : 'K'
							}]
				})	
			},{
				xtype : "combo",
				//emptyText:'请选择',
				width:200,
				fieldLabel : 'logic for no price defined',
				hiddenName : 'OECFCheckPrice',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFCheckPrice'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFCheckPrice')),
				mode : 'local',
				shadow:false,
				//queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'name',
				valueField : 'value',
				store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
								name : 'No Warning',
								value : 'N'
							}, {
								name : 'Warning Only',
								value : 'W'
							}, {
								name : 'Warning and Disable Updates',
								value : 'D'
							}]
				})	
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '医嘱执行状态',
				hiddenName : 'OECFPatLeaveOrderAdmStatusDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFPatLeaveOrderAdmStatusDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFPatLeaveOrderAdmStatusDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'STATDesc',
				valueField : 'STATRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : OECFPatLeaveOrderAdmStatusDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'STATRowId',mapping:'STATRowId'},
							{name:'STATDesc',mapping:'STATDesc'} ])
					})
			},{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : 'send orders to receiving location',
				hiddenName : 'OECFOrdersToRecLoc',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFOrdersToRecLoc'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFOrdersToRecLoc')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'name',
				valueField : 'value',
				store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
								name : 'On patient payment',
								value : 'P'
							}, {
								name : 'On order entry',
								value : 'O'
							
							}]
				})	
			},{
				xtype : "combo",
				width:200,
				//emptyText:'请选择',
				fieldLabel : 'Show Instruction field As',
				hiddenName : 'OECFShowInstructionAs',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFShowInstructionAs'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFShowInstructionAs')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'name',
				valueField : 'value',
				store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
								name : 'Code',
								value : 'C'
							}, {
								name : 'Description',
								value : 'D'
							
							}]
				})	
			},{
				xtype : "combo",
				width:200,
				///emptyText:'请选择',
				fieldLabel : 'show Repeats No Or End Date/time in OE medication panel',
				hiddenName : 'OECFUseRepeatsOrEndDate',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFUseRepeatsOrEndDate'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFUseRepeatsOrEndDate')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'name',
				valueField : 'value',
				store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
								name : 'Repeats',
								value : 'R'
							}, {
								name : 'End Date',
								value : 'E'
							
							}]
				})	
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'CMV Test order item',
				hiddenName : 'OECFCMVTestDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFCMVTestDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFCMVTestDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'ARCIMDesc',
				valueField : 'ARCIMRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : OECFCMVTestDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'ARCIMRowId',mapping:'ARCIMRowId'},
							{name:'ARCIMDesc',mapping:'ARCIMDesc'} ])
					})
			},{
				fieldLabel : 'oder Number in group warning',
				xtype:'numberfield',
				width:200,
				id:'OECFNumberOfOrdersAllowedSameGr',
				minValue : 0,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFNumberOfOrdersAllowedSameGr'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFNumberOfOrdersAllowedSameGr')),
				name : 'OECFNumberOfOrdersAllowedSameGr'
			/*},{
				fieldLabel : 'age range for pregnancy',
				id:'Agerange',
				name : 'Agerange'*/
			},{
				fieldLabel : 'Age From',
				xtype:'numberfield',
				id:'OECFAgeFrom',
				width:200,
				minValue : 0,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFAgeFrom'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFAgeFrom')),
				name : 'OECFAgeFrom'
			},{
				fieldLabel : 'Age To',
				xtype:'numberfield',
				width:200,
				id:'OECFAgeTo',
				minValue : 0,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECFAgeTo'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECFAgeTo')),
				name : 'OECFAgeTo'
			
			}
			
		]
	
		,
		buttons: [{
			text: '保存',
			iconCls : 'icon-save',
			width: 100,
			id:'savepanel',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('savepanel'),
      		handler: function (){ 
      			///alert("ss");
				formSearch.form.submit({
						url : SystemParameter_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST', 
						success : function(form, action) {
							if (action.result.success == 'true') {
								
								Ext.Msg.show({
											title : '提示',
											msg : '设置成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '设置失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '设置失败！');
						}
					})
      			
      			
      			
      	} 
		}]
	});
	
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=GetSysPara";
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntityorders&pEntityName=web.Entity.CT.SystemParameter";
	
	// 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
      
            formSearch.form.load( {
                url : OPEN_ACTION_URL ,///+'id=',
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	///alert("sssssss");
                },
                failure : function(form,action) {
                	Ext.Msg.alert('提示','载入失败！');
                }
            });
         
    };	
    loadFormData();
    
    
	
	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [formSearch]
    });
	
	});