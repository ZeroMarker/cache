// /����: �������ѯ��ʵ��¼��ͽ�����ã�
// /����: �������ѯ��ʵ��¼��ͽ�����ã�
// /��д�ߣ�wyx
// /��д����: 2013.11.18
// /GridInput  ���ý����grid
// /CodeInput  ���ý���Ŀ����code��dataIndex
// /RowIndex ���ý��淽����������ڷ�����ý������
function ScanItmQuery (Fn){

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gInciRowid=""
	var RowId="-1"
		var InciDesc = new Ext.form.TextField({
					fieldLabel : 'ҩƷ����',
					id : 'InciDesc',
					name : 'InciDesc',
					width : 200,
					emptyText : '����...',
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
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * ���ط���
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
	
	
	// ��ѯ��ť
	var findBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				id:'findBT',
				tooltip : '�����ѯҩƷλ��',
				iconCls : 'page_find',
				handler:function(){
					searchData();  //ext����ִ��handler,��ִ��listeners
				}
			});	
function searchData(){

 if (gInciRowid!=""){
   RowId=gInciRowid;}
 else{
   Msg.info("warning", "û�����ݣ�");  }
 window.close();

}

	// ȡ����ť
	var cancelBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '���ȡ������ҩƷλ��',
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
				title : '������',
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