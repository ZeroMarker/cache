 /// 名称:系统配置 - 安全组系统配置-地理信息
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');


Ext.onReady(function() {	
   	var SMCFProvinceDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTProvince&pClassQuery=GetDataForCmb1";
	var SMCFCityDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassQuery=GetDataForCmb2";
	var SMCFHCADR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTZip&pClassQuery=GetHCADR";
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  
   var CityStore=new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : SMCFCityDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'CTCITRowId',mapping:'CTCITRowId'},
							{name:'CTCITDesc',mapping:'CTCITDesc'} ])
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
		labelWidth : 140,
		reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'SMCFProvinceDR',mapping:'SMCFProvinceDR'},
                                        {name: 'SMCFCityDR',mapping:'SMCFCityDR'},
                                        {name: 'SMCFHCADR',mapping:'SMCFHCADR'},
                                        {name: 'PATCFZipCodesSetup',mapping:'PATCFZipCodesSetup'},
                                        {name: 'PATCFHospLinkedThrBedDepAlloc',mapping:'PATCFHospLinkedThrBedDepAlloc'},
                                        {name: 'PATCFDefaultZipDescIntoAddress',mapping:'PATCFDefaultZipDescIntoAddress'}
                                 ]),
		
		items:[
			
				{
				xtype : 'combo',
				//emptyText:'请选择',
				fieldLabel : '默认省份',
				id:'comboSMCFProvinceDR',
				hiddenName : 'SMCFProvinceDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFProvinceDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFProvinceDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'PROVDesc',
				valueField : 'PROVRowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : SMCFProvinceDR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'PROVRowId',mapping:'PROVRowId'},
							{name:'PROVDesc',mapping:'PROVDesc'} ])
					}),
			listeners:{
			
				'select':function(combo,record,index){
					Ext.getCmp('comboSMCFCityDR').reset();
       	 			CityStore.proxy= new Ext.data.HttpProxy({url: SMCFCityDR_QUERY_ACTION_URL+'&provincedr=' + combo.getValue()});  
        			CityStore.load(); 
        		}
			
		}
			},{
				xtype : 'combo',
				//emptyText:'请选择',
				fieldLabel : '默认城市',
				id:'comboSMCFCityDR',
				hiddenName : 'SMCFCityDR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFCityDR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFCityDR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'CTCITDesc',
				valueField : 'CTCITRowId',
				store : CityStore
			},{
				xtype : 'bdpcombo',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '健康监护区域',
				hiddenName : 'SMCFHCADR',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SMCFHCADR'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SMCFHCADR')),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'HCADesc',
				valueField : 'HCARowId',
				store : new Ext.data.Store({
							autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : SMCFHCADR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'HCARowId',mapping:'HCARowId'},
							{name:'HCADesc',mapping:'HCADesc'} ])
					})
			},{
				xtype : "combo",
				emptyText:'请选择',
				fieldLabel : 'Zip Codes Setup',
				hiddenName : 'PATCFZipCodesSetup',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFZipCodesSetup'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFZipCodesSetup')),
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
								name : 'Description of City',
								value : 'D'
							}, {
								name : 'Reference to City',
								value : 'R'
							}, {
								name : 'Reference to City w/o Zip Code',
								value : 'W'
							}]
				})	
			},{
				boxLabel:'Hospital Linked Through Department Bed Allocation',
				xtype : 'checkbox',
				name : 'PATCFHospLinkedThrBedDepAlloc',
				id:'PATCFHospLinkedThrBedDepAlloc',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFHospLinkedThrBedDepAlloc'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFHospLinkedThrBedDepAlloc')),
				inputValue : true?'Y':'N',
				checked:false
			},{
				boxLabel:'place Zip Descrption Into Address field',
				xtype : 'checkbox',
				name : 'PATCFDefaultZipDescIntoAddress',
				id:'PATCFDefaultZipDescIntoAddress',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('PATCFDefaultZipDescIntoAddress'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PATCFDefaultZipDescIntoAddress')),
				inputValue : true?'Y':'N',
				checked:false
			
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
	var SystemParameter_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=SaveEntitygeographic&pEntityName=web.Entity.CT.SystemParameter";
	
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