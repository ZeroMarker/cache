
function BatchSaveWin(InciIdStr,DrugInfoStore){
	var gLocId = session['LOGON.CTLOCID'];
	var gUserId = session['LOGON.USERID'];
	
	var BatchSaveBT = new Ext.Button({
		id:'BatchSaveBT',
		name:'BatchSaveBT',
		text:'����',
		iconCls: 'page_save',
		height: 30,
		width: 70,
		handler:function(){
			var IFVendor="N",IFBrand="N",IFNotUseFlag="N",IFHighPrice="N"
			var Vendor="",Brand="",NotUseFlag="",HighPrice=""
			if(IfVendor.checked==true){
				IFVendor="Y";
				Vendor=Ext.getCmp("INFOPbVendor").getValue();
			}
			if(IfBrand.checked==true){
				IFBrand="Y";
				Brand=Ext.getCmp("INFOBrand").getValue();
			}
			if(IfNotUseFlag.checked==true){
				IFNotUseFlag="Y";
				NotUseFlag = (Ext.getCmp("INCINotUseFlag").getValue() == true ? 'Y' : 'N');
			}
			if(IfHighPrice.checked==true){
				IFHighPrice="Y";
				HighPrice = (Ext.getCmp("INFOHighPrice").getValue() == true ? 'Y' : 'N');
			}
			if(IFVendor=="N"&&IFBrand=="N"&&IFNotUseFlag=="N"&&IFHighPrice=="N"){
				Msg.info("error", "û��Ҫ�޸ĵ�����!");
				return;
			}
			var DataStr=IFVendor+"^"+Vendor+"^"+IFBrand+"^"+Brand+"^"+IFNotUseFlag+"^"+NotUseFlag
			+"^"+IFHighPrice+"^"+HighPrice
			var loadMask = ShowLoadMask(document.body, "������...");
			var url = "dhcstm.druginfomaintainaction.csp?actiontype=BatchSaveData";
			Ext.Ajax.request({
				url: url,
				params: {
					InciIdStr: InciIdStr,
					DataStr: DataStr
				},
				method: 'POST',
				waitMsg: '������...',
				failure: function (result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
				},
				success: function (result, request){
					loadMask.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true'){
						Msg.info("success", "��������ɹ�!");
						DrugInfoStore.reload();
						findWin.close();
					} else {
						if (jsonData.info==-1){
							Msg.info("error", "û��Ҫ�޸ĵ�����!");
						}else{
							Msg.info("error", jsonData.info);
						}
						rerurn;
					}
				},
				callback: function () {
					loadMask.hide();
				},
				scope: this
			});
		}
	});
	function ClearData(){
		INFOPbVendor.setValue("");
		IfVendor.setValue(false);
		
		INFOBrand.setValue("");
		IfBrand.setValue(false);
		
		INCINotUseFlag.setValue(false);
		IfNotUseFlag.setValue(false);
		
		INFOHighPrice.setValue(false);
		IfHighPrice.setValue(false);
	}
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '���',
		tooltip : '������',
		height: 30,
		width: 70,
		iconCls : 'page_clearscreen',
		handler : function() {
			ClearData();
		}
	});
	// �رհ�ť
	var CloseBT = new Ext.Toolbar.Button({
		id : "CloseBT",
		text : '�ر�',
		tooltip : '�رս���',
		height:30,
		width:70,
		iconCls : 'page_delete',
		handler : function() {
			findWin.close();
		}
	});
	
	var IfVendor = new Ext.form.Checkbox({
		fieldLabel: '�Ƿ��޸�',
		id: 'IfVendor',
		name: 'IfVendor',
		anchor: '90%',
		checked: false
	});
	var INFOPbVendor = new Ext.ux.VendorComboBox({ 
		fieldLabel: '�б깩Ӧ��',
		id: 'INFOPbVendor',
		anchor: '90%',
		width: 150,
		name: 'INFOPbVendor'
	});
	var IfBrand = new Ext.form.Checkbox({
		fieldLabel: '�Ƿ��޸�',
		id: 'IfBrand',
		name: 'IfBrand',
		anchor: '90%',
		checked: false
	});
	var INFOBrand = new Ext.form.TextField({
		fieldLabel: 'Ʒ��',
		id: 'INFOBrand',
		name: 'INFOBrand',
		anchor: '90%'
	});
	var IfNotUseFlag = new Ext.form.Checkbox({
		fieldLabel: '�Ƿ��޸�',
		id: 'IfNotUseFlag',
		name: 'IfNotUseFlag',
		anchor: '90%',
		checked: false
	});
	var INCINotUseFlag = new Ext.form.Checkbox({
		fieldLabel: '������',
		id: 'INCINotUseFlag',
		name: 'INCINotUseFlag',
		anchor: '90%',
		checked: false
	});
	var IfHighPrice = new Ext.form.Checkbox({
		fieldLabel: '�Ƿ��޸�',
		id: 'IfHighPrice',
		name: 'IfHighPrice',
		anchor: '90%',
		checked: false,
		listeners: {
			'check': function(checkBox, checked) {
				var list = InciIdStr.split("^");
				if(IfHighPrice.checked==true && INFOHighPrice.checked == false){
					for (var i = 0; i < list.length; i++) {
						var InciId=list[i];
						var Ret = tkMakeServerCall('web.DHCSTM.INCITM', 'CheckItmTrack', InciId);
						if(Ret == 'Y'){
							Msg.info('warning', '��ѡ�е����ʴ���δʹ����ɵĸ�ֵ����, ���ɱ����ֵ���!');
							INFOHighPrice.setValue(false);
							IfHighPrice.setValue(false);
							return;
						}
					}
				}
			}
		}
	});
	var INFOHighPrice = new Ext.form.Checkbox({
		fieldLabel: '��ֵ���־',
		id: 'INFOHighPrice',
		name: 'INFOHighPrice',
		anchor: '90%',
		checked: false
	});
	var panel = new Ext.form.FormPanel({
		id:'panel',
		region:'center',
		layout:'form',
		labelWidth:60,
		frame:true,
		labelAlign:'right',
		bodyStyle:'padding:10px;',
		items : [{
			layout: 'column',
			xtype:'fieldset',
			title:'�޸�����',
			style:'padding:5px 0px 0px 0px',
			defaults: {border:false},
			items:[
			{
				columnWidth: 0.3,
				xtype: 'fieldset',
				defaultType: 'textfield',
				items: [IfVendor,IfBrand,IfNotUseFlag,IfHighPrice]
			},{
				columnWidth: 0.7,
				labelWidth:100,
				xtype: 'fieldset',
				items: [INFOPbVendor,INFOBrand,INCINotUseFlag,INFOHighPrice]
			}]
		}]
	});
	
	var findWin = new Ext.Window({
		title : '�����޸�',
		id:'findWin',
		width :500,
		minWidth:400,
		height : 250,
		modal:true,
		layout : 'border',
		bodyStyle:'padding:10px;',
		items : [panel],
		buttons:[BatchSaveBT,ClearBT,CloseBT],
		buttonAlign : 'center'
	});
	
	findWin.show();
}