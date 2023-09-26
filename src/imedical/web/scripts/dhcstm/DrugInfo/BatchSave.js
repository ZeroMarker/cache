
function BatchSaveWin(InciIdStr,DrugInfoStore){
	var gLocId = session['LOGON.CTLOCID'];
	var gUserId = session['LOGON.USERID'];
	
	var BatchSaveBT = new Ext.Button({
		id:'BatchSaveBT',
		name:'BatchSaveBT',
		text:'保存',
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
				Msg.info("error", "没有要修改的数据!");
				return;
			}
			var DataStr=IFVendor+"^"+Vendor+"^"+IFBrand+"^"+Brand+"^"+IFNotUseFlag+"^"+NotUseFlag
			+"^"+IFHighPrice+"^"+HighPrice
			var loadMask = ShowLoadMask(document.body, "保存中...");
			var url = "dhcstm.druginfomaintainaction.csp?actiontype=BatchSaveData";
			Ext.Ajax.request({
				url: url,
				params: {
					InciIdStr: InciIdStr,
					DataStr: DataStr
				},
				method: 'POST',
				waitMsg: '保存中...',
				failure: function (result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
				},
				success: function (result, request){
					loadMask.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true'){
						Msg.info("success", "批量保存成功!");
						DrugInfoStore.reload();
						findWin.close();
					} else {
						if (jsonData.info==-1){
							Msg.info("error", "没有要修改的数据!");
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
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '清空',
		tooltip : '点击清空',
		height: 30,
		width: 70,
		iconCls : 'page_clearscreen',
		handler : function() {
			ClearData();
		}
	});
	// 关闭按钮
	var CloseBT = new Ext.Toolbar.Button({
		id : "CloseBT",
		text : '关闭',
		tooltip : '关闭界面',
		height:30,
		width:70,
		iconCls : 'page_delete',
		handler : function() {
			findWin.close();
		}
	});
	
	var IfVendor = new Ext.form.Checkbox({
		fieldLabel: '是否修改',
		id: 'IfVendor',
		name: 'IfVendor',
		anchor: '90%',
		checked: false
	});
	var INFOPbVendor = new Ext.ux.VendorComboBox({ 
		fieldLabel: '招标供应商',
		id: 'INFOPbVendor',
		anchor: '90%',
		width: 150,
		name: 'INFOPbVendor'
	});
	var IfBrand = new Ext.form.Checkbox({
		fieldLabel: '是否修改',
		id: 'IfBrand',
		name: 'IfBrand',
		anchor: '90%',
		checked: false
	});
	var INFOBrand = new Ext.form.TextField({
		fieldLabel: '品牌',
		id: 'INFOBrand',
		name: 'INFOBrand',
		anchor: '90%'
	});
	var IfNotUseFlag = new Ext.form.Checkbox({
		fieldLabel: '是否修改',
		id: 'IfNotUseFlag',
		name: 'IfNotUseFlag',
		anchor: '90%',
		checked: false
	});
	var INCINotUseFlag = new Ext.form.Checkbox({
		fieldLabel: '不可用',
		id: 'INCINotUseFlag',
		name: 'INCINotUseFlag',
		anchor: '90%',
		checked: false
	});
	var IfHighPrice = new Ext.form.Checkbox({
		fieldLabel: '是否修改',
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
							Msg.info('warning', '所选中的物资存在未使用完成的高值条码, 不可变更高值标记!');
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
		fieldLabel: '高值类标志',
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
			title:'修改内容',
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
		title : '批量修改',
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