/**
* @Title: 基础数据平台-his语音功能 按照科室开启
 * @Author: CHENYING
 * @Description: -his语音功能 按照科室开启
 * @Created on 2020-01-20
 */

/**----------------------------------调用元素授权控件JS--------------------------------------**/	 
	document.write('<script type="text/javascript" src="'+'../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Ext.ux.Multiselect.js'+'"></script>');
	document.write('<script type="text/javascript" src="'+'../scripts/bdp/App/BDPSystem/BDPItemAuthorize/DDView.js'+'"></script>');
    document.write('<script type="text/javascript" src="'+'../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Ext.form.MultiSelect.js'+'"></script>');
    document.write('<link rel="stylesheet" type="text/css" href="'+'../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Multiselect.css'+'"></script>');

Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	
	var ABLE_ITEM_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfig&pClassMethod=GetBDPHISASRLocData";
	var DISABLE_ITEM_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfig&pClassMethod=GetNonBDPHISASRLocData";
	var BDPHISASRLocData_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfig&pClassMethod=SaveConfigValue";

	var BDPHISASRLocDatads1 = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : ABLE_ITEM_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name :'Name',
									mapping :'Name',
									type : 'string'
								}
						])
			});
	var BDPHISASRLocDatads2 = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : DISABLE_ITEM_ACTION_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'ID',
							mapping : 'ID',
							type : 'string'
						}, {
							name :'Name',
							mapping :'Name',
							type : 'string'
						}
				])
	});
	var BDPHISASRLocDataPanel = new Ext.Panel({
		//width : 500,
		//height: 600,
		region:'center',
		frame:true,
		//bodyStyle : 'padding: 1px;',
		items : [{
			xtype : "itemselector",
			id    : "_multiselect3",
			fieldLabel : "ItemSelector",
			dataFields : ["ID", "Name"],
			fromStore   : BDPHISASRLocDatads2,
			toStore     : BDPHISASRLocDatads1,
			toSortField : true,
			msWidth    : 250,
			msHeight   : 480,
			valueField   : "ID",
			displayField : "Name",
			toLegend     : "开启语音功能",
			fromLegend   : "关闭语音功能"
		}],
		tbar : [{ 	text:'保存',
					icon:Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
					handler:function() {
						var str="";
						var f=function(record){
							var RowID = record.get("ID");
							if(RowID) {
								str=str+"^"+RowID
							}
						}
						BDPHISASRLocDatads1.each(f);
						
						Ext.Ajax.request({
							url:BDPHISASRLocData_SAVE_ACTION_URL,
							params: {code:'BDPHISASRLocData',Value:str},
							success: function(resp,option){
								var rtn = resp.responseText.replace(/\r\n/g,"");
								try{var obj = Ext.decode(rtn);}catch(e){alert("操作失败!");return ;}
								if (obj.success == "true") {
									Ext.Msg.show({
										title : '提示',
										msg : '保存成功!',
										minWidth : 150,
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK
									});
									
								}else {
									Ext.Msg.show({
										title : '提示',
										msg : obj.erroinfo,
										minWidth : 150,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
							},
							failure: function(response, opts) {
										console.log('server-side failure with status code ' + response.status);
									},
							scope : this
						});
					}
				},'-',{
					text:"清空开启语音功能",
					icon:Ext.BDP.FunLib.Path.URL_Icon+'bckdelete.gif',
					handler:function(){
						var i = Ext.getCmp("_multiselect3");
						i.reset.call(i);
					}
				}]
	});
	
	/** 布局 */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[BDPHISASRLocDataPanel],
        	 listeners:{
			
					'afterlayout':function(){
						Ext.getCmp("_multiselect3").toStore.load();	
						Ext.getCmp("_multiselect3").fromStore.load();	
						
					}
					
					}
    	});
    	
});