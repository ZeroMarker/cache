// /名称: 查找项查询（实盘录入就界面调用）
// /描述: 查找项查询（实盘录入就界面调用）
// /编写者：wyx
// /编写日期: 2013.11.18
// /GridInput  调用界面的grid
// /CodeInput  调用界面的库存项code的dataIndex
// /RowIndex 调用界面方法句柄，用于反射调用界面参数
function ScanItmQuery (Fn){

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gInciRowid=""
	var RowId="-1"
		var InciDesc = new Ext.form.TextField({
					fieldLabel : '药品名称',
					id : 'InciDesc',
					name : 'InciDesc',
					width : 200,
					emptyText : '别名...',
					selectOnfocus: true,
					listeners : {
						specialkey : function(field, e) {
							var keyCode=e.getKey();
							if ( keyCode== Ext.EventObject.ENTER) {
								var stkgrp=Ext.getCmp("StkGrpType").getValue();
								GetPhaOrderInfo(field.getValue(),stkgrp);
							}
						}
					}
				});


				/**
		 * 调用药品窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var gIncId = record.get("InciDr");
			var inciCode=record.get("InciCode");
			gInciRowid=gIncId
			var inciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(inciDesc);
			Ext.getCmp("findBT").focus();		
		}	
	
	
	// 查询按钮
	var findBT = new Ext.Toolbar.Button({
				text : '查询',
				id:'findBT',
				tooltip : '点击查询药品位置',
				iconCls : 'page_find',
				handler:function(){
					searchData();  //ext会先执行handler,再执行listeners
				}
			});	
function searchData(){

 if (gInciRowid!=""){
   RowId=gInciRowid;}
 else{
   Msg.info("warning", "没有数据！");  }
 window.close();

}

	// 取消按钮
	var cancelBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '点击取消查找药品位置',
				iconCls : 'page_delete',
				handler : function() {
					window.close();
				}
			});	
	
	
	
	var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'center',
			height : 160,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 1px 1px 5px;',
			bbar : [findBT,cancelBT],	
			layout : 'table',	
			layoutConfig: {columns:1},
		    items:[{
		    		xtype:'fieldset',
		    		border:false,
		    		items:[InciDesc]		    		
		    	  }
		    ]	
		});

	var window = new Ext.Window({
				title : '查找项',
				width : 400,
				height : 150,
				layout:'border',
				items : [ HisListTab]
			});
	window.show();
    InciDesc.focus(true,true);
	window.on('close', function(panel) {
		     if (RowId!=-1)
		     {
				 Fn(RowId);
		     }
             
			});
}