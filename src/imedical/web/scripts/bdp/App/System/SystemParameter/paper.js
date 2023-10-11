 /// 名称:系统配置 - 安全组系统配置-纸质记录追踪
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
   Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  var ReasonRequest_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetRTCReasonRequest";
   var RTCFMainMRTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetRTCMRecordType";
   var RTCFMainMRVolumeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassQuery=GetRTCMRecordTypeVolumes";
   
   
   var VOLStore=new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : RTCFMainMRVolumeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'VOLRowId',mapping:'VOLRowId'},
							{name:'VOLDesc',mapping:'VOLDesc'} ])
					});
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
		labelWidth : 180,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'RTCFRequestReasonAdmDR',mapping:'RTCFRequestReasonAdmDR'},
                                        {name: 'RTCFDefaultReasEDRequest',mapping:'RTCFDefaultReasEDRequest'},
                                        {name: 'RTCFRequestReasonAPPTDR',mapping:'RTCFRequestReasonAPPTDR'},
                                        {name: 'RTCFDefaultReasonWLRequest',mapping:'RTCFDefaultReasonWLRequest'},
                                        {name: 'RTCFMainMRTypeDR',mapping:'RTCFMainMRTypeDR'},
                                        {name: 'RTCFMainMRVolumeDR',mapping:'RTCFMainMRVolumeDR'},
                                        {name: 'RTCFDaysToGetMR',mapping:'RTCFDaysToGetMR'}
                                 ]),
		
		items:[
			
				{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				width:200,
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'default Reason for direct admission Requests',
				hiddenName : 'RTCFRequestReasonAdmDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFRequestReasonAdmDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFRequestReasonAdmDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'READesc',
				valueField : 'REARowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : ReasonRequest_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'REARowId',mapping:'REARowId'},
							{name:'READesc',mapping:'READesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Default Reason for direct ED Request',
				hiddenName : 'RTCFDefaultReasEDRequest',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFDefaultReasEDRequest'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFDefaultReasEDRequest')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'READesc',
				valueField : 'REARowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : ReasonRequest_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'REARowId',mapping:'REARowId'},
							{name:'READesc',mapping:'READesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Default Reason for outpatient Appointment requests',
				hiddenName : 'RTCFRequestReasonAPPTDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFRequestReasonAPPTDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFRequestReasonAPPTDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'READesc',
				valueField : 'REARowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : ReasonRequest_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'REARowId',mapping:'REARowId'},
							{name:'READesc',mapping:'READesc'} ])
					})
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				width:200,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : 'Default Reason for  WL Requests',
				hiddenName : 'RTCFDefaultReasonWLRequest',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFDefaultReasonWLRequest'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFDefaultReasonWLRequest')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'READesc',
				valueField : 'REARowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : ReasonRequest_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'REARowId',mapping:'REARowId'},
							{name:'READesc',mapping:'READesc'} ])
					})
			},{
				xtype : 'combo',
				width:200,
				
				//emptyText:'请选择',
				fieldLabel : 'Main Medical Record Type',
				hiddenName : 'RTCFMainMRTypeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFMainMRTypeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFMainMRTypeDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'TYPDesc',
				valueField : 'TYPRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : RTCFMainMRTypeDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'TYPRowId',mapping:'TYPRowId'},
							{name:'TYPDesc',mapping:'TYPDesc'} ])
					}),
				listeners:{
			
					'select':function(combo,record,index){
						Ext.getCmp('comboRTCFMainMRVolumeDR').reset();
       	 				VOLStore.proxy= new Ext.data.HttpProxy({url: RTCFMainMRVolumeDR_QUERY_ACTION_URL+'&tpyrowid=' + combo.getValue()});  
        				VOLStore.load(); 
        			}
			
				}
			},{
				xtype : 'combo',
				width:200,
				
				//emptyText:'请选择',
				id:'comboRTCFMainMRVolumeDR',
				fieldLabel : 'Main Medical Record volume',
				hiddenName : 'RTCFMainMRVolumeDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFMainMRVolumeDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFMainMRVolumeDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'VOLDesc',
				valueField : 'VOLRowId',
				store : VOLStore
			},{
				fieldLabel : 'number of days to get medical',
				xtype:'numberfield',
				width:200,
				id:'RTCFDaysToGetMR',
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('RTCFDaysToGetMR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RTCFDaysToGetMR')),
				name : 'RTCFDaysToGetMR'
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitypaper&pEntityName=web.Entity.CT.SystemParameter";
	
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