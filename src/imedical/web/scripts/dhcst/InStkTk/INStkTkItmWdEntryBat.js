// /名称: 录入实盘数据（实盘方式四界面调用）
// /描述: 录入实盘数据（实盘方式四界面调用）
// /编写者：wyx
// /编写日期: 2013.11.28

function EntryBatQuery(Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	gStrParam="";
       gInciRowid=""
       var RowId="-1"
       var Qty="0"
       var RetValue="-1^0^"
       var gLocId=session['LOGON.CTLOCID']
       var gGroupId=session['LOGON.GROUPID']
       var gUserId = session['LOGON.USERID'];
		var InciDesc = new Ext.form.TextField({
					fieldLabel : $g('药品名称'),
					id : 'InciDesc',
					name : 'InciDesc',
					anchor : '90%',
					width : 240,
					emptyText : $g('别名...'),
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
			;
			Ext.getCmp("InciDesc").setValue(inciDesc);
			
			//Ext.getCmp('InciDr').setValue(inciDr);	
			var Params=gGroupId+'^'+gLocId+'^'+gUserId;	
			//取其它药品信息
			var url = DictUrl
				+ "ingdrecaction.csp?actiontype=GetItmInfo&IncId="
				+ gIncId+"&Params="+Params;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : $g('查询中...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								var data=jsonData.info.split("^");
								addComboData(ItmUomStore,data[2],data[3]);
								CTUom.setValue(data[2]);
								Ext.getCmp("InStkVen").setValue(data[1]);
							    }
			
							}
					})
		}
			
		// 单位
		var CTUom = new Ext.form.ComboBox({
					fieldLabel : $g('单位'),
					id : 'CTUom',
					name : 'CTUom',
					anchor : '90%',
					width : 240,
					store : ItmUomStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : $g('单位...'),
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 10,
					listWidth : 250,
					valueNotFoundText : ''
				});

		
		/**
		 * 单位展开事件
		 */
		CTUom.on('expand', function(combo) {
					ItmUomStore.removeAll();
					ItmUomStore.load({params:{ItmRowid:gInciRowid,LocId:gLocId}});
					
				})
//批号效期
     var BatExDate = new Ext.form.ComboBox({
		fieldLabel : $g('批号效期'),
		id : 'BatExDate',
		name : 'BatExDate',
		anchor : '90%',
		width : 240,
		store : BatExDateStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : false,
		triggerAction : 'all',
		emptyText : $g('批号效期...'),
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 10,
		listWidth : 250,
		valueNotFoundText : '',
              enableKeyEvents : true,
              listeners : {
                'beforequery' : function(e) {
                	this.store.removeAll();
                    this.store.setBaseParam('ItmRowid',gInciRowid);
                    this.store.setBaseParam('LocId',gLocId);
                    this.store.setBaseParam('Desc',this.getRawValue());
                    this.store.load({params:{start:0,limit:20}});
                }
            }
        }); 	
 
//货位
     var StkBinQ = new Ext.form.ComboBox({
            fieldLabel : $g('货位'),
            id : 'StkBinQ',
            name : 'StkBinQ',
            anchor : '90%',
            width : 240,
            store : LocStkBinQStore,
            valueField : 'RowId',
            displayField : 'Description',
            allowBlank : true,
            triggerAction : 'all',
            emptyText : $g('货位...'),
            selectOnFocus : true,
            forceSelection : true,
            minChars : 1,
            pageSize : 20,
            listWidth : 250,
            valueNotFoundText : '',
            enableKeyEvents : true,
            listeners : {
                'beforequery' : function(e) {
                	this.store.removeAll();
                	//this.store.setBaseParam('ItmBatRowid',Ext.getCmp('BatExDate').getValue());
                     this.store.setBaseParam('ItmRowid',gInciRowid);
                    this.store.setBaseParam('LocId',gLocId);
                    this.store.setBaseParam('Desc',this.getRawValue());
                    this.store.load({params:{start:0,limit:20}});
                }
            }
        }); 
        
    var InStkQty=new Ext.form.NumberField({
        id : 'InStkQty',
        name : 'InStkQty',
        fieldLabel:$g('数量'),
        anchor:'90%',
        emptyText : $g('数量...'),
        width:240
    });
    var InStkVen=new Ext.form.TextField({
        id : 'InStkVen',
        name : 'InStkVen',
        fieldLabel:$g('生产企业'),
        anchor:'90%',
        emptyText : $g('生产企业...'),
        width:240,
        disabled:true
    });

	// 保存按钮
	var SaveBT = new Ext.Toolbar.Button({
				text : $g('保存'),
				tooltip : $g('点击保存药品信息'),
				iconCls : 'page_save',
				handler : function() {
				    if (CheckDataBeforeSave()==true){	 
					saveData();}
				}
			});
function CheckDataBeforeSave(){
  var InciDescId = Ext.getCmp("InciDesc").getValue();
			
  if((InciDescId==null || InciDescId=="")){
    Msg.info("warning", $g("药品名称不能为空!"));
    InciDesc.focus(true,true);
    return false;
  }	
  var BatExDateId = Ext.getCmp("BatExDate").getValue();
			
 if((BatExDateId==null || BatExDateId=="")){
    Msg.info("warning", $g("批次不能为空!"));
    BatExDate.focus(true,true);
    return false;
  }
  var StkBinQId = Ext.getCmp("StkBinQ").getValue();
			
 if((StkBinQId==null || StkBinQId=="")){
    Msg.info("warning", $g("货位不能为空!"));
    StkBinQ.focus(true,true);
    return false;
  }
  var InStkQtyId = Ext.getCmp("InStkQty").getValue();
			
  if((InStkQtyId==null || InStkQtyId=="")){
    Msg.info("warning", $g("数量不能为空!"));
    InStkQty.focus(true,true);
    return false;
   }	
return true;	
}

function saveData(){
 	
 var inclobbtdr=Ext.getCmp('BatExDate').getValue()
 if (inclobbtdr!=""){
   RowId=inclobbtdr;
   Qty=Ext.getCmp('InStkQty').getValue();
   InputUom=Ext.getCmp('CTUom').getValue();
   RetValue=RowId+"^"+Qty+"^"+InputUom
   }
 else{
   Msg.info("warning", $g("没有数据！"));  }
 window.close();
	}

			
	// 取消按钮
	var cancelBT = new Ext.Toolbar.Button({
				text : $g('取消'),
				tooltip : $g('点击取消'),
				iconCls : 'page_gear',
				handler : function() {
					window.close();
				}
			});			
							
	var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'center',
			height : 140,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 1px 1px 5px;',
			bbar : [SaveBT,cancelBT],	
			layout : 'table',	
			layoutConfig: {columns:1},
		    items:[{
		    		xtype:'fieldset',
		    		border:false,
		    		items:[InciDesc,CTUom,BatExDate,StkBinQ,InStkQty,InStkVen]		    		
		    	  }
		    ]	
		});

	var window = new Ext.Window({
				title : $g('录入实盘'),
				width : 400,
				height : 300,
				modal:true,
				layout:'border',
				items : [HisListTab]
			});
	window.show();
	InciDesc.focus(true,true);
	window.on('close', function(panel) {
             Fn(RetValue);
			});
	
}