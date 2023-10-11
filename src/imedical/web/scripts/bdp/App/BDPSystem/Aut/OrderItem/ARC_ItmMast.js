// 医嘱项
// 数据授权,不分级菜单
// 2013-10-11 by lisen
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanel_BitMap.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/websys.comm.ext.js"> </script>');
Ext.onReady(function() {
	
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			//选中的类别类型，全局变量
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference')  //选中的类别ID，全局变量
	var AutCode=Ext.BDP.FunLib.getParam('AutCode')    //获取授权页代码
	//// 账单组查询数据
 	var BillGroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillGrp&pClassQuery=GetDataForCmb1";
 	/// 账单子组查询数据
	var BillSubGroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillSub&pClassQuery=GetDataForCmb1";
    ///服务组查询数据
	var resourcegroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCServiceGroup&pClassQuery=GetDataForCmb1";
	///医嘱子类
	var ItemCat_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetDataForCmb1";
	
    var ComboPage=Ext.BDP.FunLib.PageSize.Combo;
	Ext.QuickTips.init();
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.ARCItmMast&pClassMethod=GetTreeJson";
	//多院区医院下拉框
	//var hospComp=GenHospComp(AutCode);
	
	var objstore=new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassQuery=GetHospDataForCombo"+"&tablename="+AutCode+"&SessionStr="+""}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [ 'HOSPRowId', 'HOSPDesc' ])
		})
	var hospComp = new Ext.form.ComboBox({
		id:'_HospList',
		labelSeparator:"",
		DataType:tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",AutCode),  //公有G，私有S，绝对私有A，管控C
		width:100,
		fieldLabel : $g('医院'),
		store : objstore,
		editable:false,
		queryParam : 'desc',
		triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		listWidth :250,
		valueField : 'HOSPRowId',
		displayField : 'HOSPDesc'
	});	
	/*
	objstore.load({
	       callback: function () {
		       var thisHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName",AutCode,session['LOGON.HOSPID'])
		       hospComp.setValue(thisHospId);   //初始赋值为当前登录科室的院区
		       Ext.getCmp('_HospList').fireEvent('select',Ext.getCmp('_HospList'),Ext.getCmp('_HospList').getStore().getById(thisHospId))  //触发select事件
	        },
	        scope: objstore,
	        add: false
	});*/
	//医嘱项筛选条件
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['医院', hospComp,"-",
						'医嘱别名',{  
			             	xtype : "textfield",
			             	width:80,
							id:'alias'
			            } , '-','账单组', {
			             	fieldLabel:'账单组',
							id:'billgroup',
							xtype:'combo',
							allQuery:'',   
							emptyText:'请先选择左侧医院',
							forceSelection: true,
							selectOnFocus:false,
							mode:'remote',
							width:100,
							queryParam:'desc',
							pageSize:ComboPage,
							minChars: 0,
							listWidth:250,
							valueField:'ARCBGRowId',
							displayField:'ARCBGDesc',
							store:new Ext.data.JsonStore({
							   url:BillGroup_ACTION_URL,
							   root: 'data',
							   totalProperty: 'total',
							   idProperty: 'rowid',
							   fields:['ARCBGRowId','ARCBGDesc'],
							   remoteSort: true,
							   sortInfo: {field: 'rowid', direction: 'ASC'}
							}),
                        	listeners:{	
                               'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                    }})
                                
                                }
                        	}			 
      				 	}, '-','账单子组',  {
			               	fieldLabel:'账单子组',
							id:'subbillgroup',
							xtype:'combo',
							width:100,
							emptyText:'请先选择左侧医院',
							forceSelection: true,
							selectOnFocus:true,
							mode:'remote',
							queryParam:'desc',
							pageSize:ComboPage,
							minChars: 0,
							listWidth:250,
							valueField:'ARCSGRowId',
							displayField:'ARCSGDesc',
							store:new Ext.data.JsonStore({
							      url:BillSubGroup_ACTION_URL,
								  root: 'data',
								  totalProperty: 'total',
								  idProperty: 'rowid',
								  fields:['ARCSGRowId','ARCSGDesc'],
								  remoteSort: true,
								  sortInfo: {field: 'rowid', direction: 'ASC'}
							}),
                        	listeners:{	
                               'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            hospid:hospComp.getValue(),
                                            ParRef:Ext.getCmp("billgroup").getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                    }})
                                
                                }
                        	}					
			         	},'医嘱子类', {
		                fieldLabel:'医嘱子类',
						xtype:'combo',
						width:100,
						id:'ordersubsort',
						forceSelection: true,
						selectOnFocus:true,
						mode:'remote',
						emptyText:'请先选择左侧医院',
						queryParam : 'desc',
						pageSize:ComboPage,
						minChars: 0,
						listWidth:250,
						valueField:'ARCICRowId',
						displayField:'ARCICDesc',
						store:new Ext.data.JsonStore({
							url:ItemCat_ACTION_URL,
							root: 'data',
							totalProperty: 'total',
							idProperty: 'rowid',
							fields:['ARCICRowId','ARCICCode','ARCICDesc'],
							remoteSort: true,
							sortInfo: {field: 'rowid', direction: 'ASC'}
						}),
                    	listeners:{	
                           'beforequery': function(e){
                                this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue()
                                };
                                this.store.load({params : {
                                            start : 0,
                                            limit : Ext.BDP.FunLib.PageSize.Combo
                                }})
                            
                            }
                    	}
		         	}
						 
					]
			});	
		
	var myPanel = new Ext.BDP.Component.DataAutPanel({
		        region : "center",
		        dataUrl : Tree_ACTION_URL, //页面初始化时加载数据
		        ObjectType : ObjectType,
				ObjectReference : ObjectReference,
				AutCode :  AutCode,
		        pageSize : Ext.BDP.FunLib.PageSize.Aut, //分页大小,默认为0,为0时不分页
		        AutClass : "web.DHCBL.Authorize.ARCItmMast", //保存授权数据类名称
		        getAutMethod : "GetLimited", //获取授权数据方法
		        saveAutMethod : "SaveAutData", //保存授权数据方法
			    listeners : {
					 'render' : function(){
					 	tb.render(this.tbar);
					 }
			 }
		    });
	
	var viewport = new Ext.Viewport({
		    	layout:'border',
		    	items:[myPanel]
			});
});