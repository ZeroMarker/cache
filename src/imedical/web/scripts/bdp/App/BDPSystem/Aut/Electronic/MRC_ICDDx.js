/// 名称: ICD诊断代码
// 数据授权,不分级菜单
// 2013-10-11 by lisen
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanel_BitMap.js"> </script>');

Ext.onReady(function() {
	
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			//选中的类别类型，全局变量
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference')  //选中的类别ID，全局变量
	var AutCode=Ext.BDP.FunLib.getParam('AutCode')    //获取授权页代码
    Ext.QuickTips.init();
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.MRCICDDx&pClassMethod=GetTreeJson";
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
		width:150,
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
	//ICD筛选条件
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['医院', hospComp,'-']
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
	var myPanel = new Ext.BDP.Component.DataAutPanel({
		        region : "center",
		        dataUrl : Tree_ACTION_URL, //页面初始化时加载数据
		        ObjectType : ObjectType,
				ObjectReference : ObjectReference,
				AutCode :  AutCode,
		        pageSize : Ext.BDP.FunLib.PageSize.Aut, //分页大小,默认为0,为0时不分页
		        AutClass : 'web.DHCBL.Authorize.MRCICDDx', //保存授权数据类名称
		        getAutMethod : "GetLimited", //获取授权数据方法
				saveAutMethod : 'SaveAutData' //保存授权数据方法
				,listeners : {
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
