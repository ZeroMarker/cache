// /����: ¼��ʵ�����ݣ�ʵ�̷�ʽ�Ľ�����ã�
// /����: ¼��ʵ�����ݣ�ʵ�̷�ʽ�Ľ�����ã�
// /��д�ߣ�wyx
// /��д����: 2013.11.28

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
					fieldLabel : $g('ҩƷ����'),
					id : 'InciDesc',
					name : 'InciDesc',
					anchor : '90%',
					width : 240,
					emptyText : $g('����...'),
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
			;
			Ext.getCmp("InciDesc").setValue(inciDesc);
			
			//Ext.getCmp('InciDr').setValue(inciDr);	
			var Params=gGroupId+'^'+gLocId+'^'+gUserId;	
			//ȡ����ҩƷ��Ϣ
			var url = DictUrl
				+ "ingdrecaction.csp?actiontype=GetItmInfo&IncId="
				+ gIncId+"&Params="+Params;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : $g('��ѯ��...'),
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
			
		// ��λ
		var CTUom = new Ext.form.ComboBox({
					fieldLabel : $g('��λ'),
					id : 'CTUom',
					name : 'CTUom',
					anchor : '90%',
					width : 240,
					store : ItmUomStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : $g('��λ...'),
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 10,
					listWidth : 250,
					valueNotFoundText : ''
				});

		
		/**
		 * ��λչ���¼�
		 */
		CTUom.on('expand', function(combo) {
					ItmUomStore.removeAll();
					ItmUomStore.load({params:{ItmRowid:gInciRowid,LocId:gLocId}});
					
				})
//����Ч��
     var BatExDate = new Ext.form.ComboBox({
		fieldLabel : $g('����Ч��'),
		id : 'BatExDate',
		name : 'BatExDate',
		anchor : '90%',
		width : 240,
		store : BatExDateStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : false,
		triggerAction : 'all',
		emptyText : $g('����Ч��...'),
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
 
//��λ
     var StkBinQ = new Ext.form.ComboBox({
            fieldLabel : $g('��λ'),
            id : 'StkBinQ',
            name : 'StkBinQ',
            anchor : '90%',
            width : 240,
            store : LocStkBinQStore,
            valueField : 'RowId',
            displayField : 'Description',
            allowBlank : true,
            triggerAction : 'all',
            emptyText : $g('��λ...'),
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
        fieldLabel:$g('����'),
        anchor:'90%',
        emptyText : $g('����...'),
        width:240
    });
    var InStkVen=new Ext.form.TextField({
        id : 'InStkVen',
        name : 'InStkVen',
        fieldLabel:$g('������ҵ'),
        anchor:'90%',
        emptyText : $g('������ҵ...'),
        width:240,
        disabled:true
    });

	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
				text : $g('����'),
				tooltip : $g('�������ҩƷ��Ϣ'),
				iconCls : 'page_save',
				handler : function() {
				    if (CheckDataBeforeSave()==true){	 
					saveData();}
				}
			});
function CheckDataBeforeSave(){
  var InciDescId = Ext.getCmp("InciDesc").getValue();
			
  if((InciDescId==null || InciDescId=="")){
    Msg.info("warning", $g("ҩƷ���Ʋ���Ϊ��!"));
    InciDesc.focus(true,true);
    return false;
  }	
  var BatExDateId = Ext.getCmp("BatExDate").getValue();
			
 if((BatExDateId==null || BatExDateId=="")){
    Msg.info("warning", $g("���β���Ϊ��!"));
    BatExDate.focus(true,true);
    return false;
  }
  var StkBinQId = Ext.getCmp("StkBinQ").getValue();
			
 if((StkBinQId==null || StkBinQId=="")){
    Msg.info("warning", $g("��λ����Ϊ��!"));
    StkBinQ.focus(true,true);
    return false;
  }
  var InStkQtyId = Ext.getCmp("InStkQty").getValue();
			
  if((InStkQtyId==null || InStkQtyId=="")){
    Msg.info("warning", $g("��������Ϊ��!"));
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
   Msg.info("warning", $g("û�����ݣ�"));  }
 window.close();
	}

			
	// ȡ����ť
	var cancelBT = new Ext.Toolbar.Button({
				text : $g('ȡ��'),
				tooltip : $g('���ȡ��'),
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
				title : $g('¼��ʵ��'),
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