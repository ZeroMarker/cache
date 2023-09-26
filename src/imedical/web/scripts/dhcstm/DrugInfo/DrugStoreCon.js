
function GetStoreCon(){
	var url = 'dhcstm.druginfomaintainaction.csp?actiontype=GetStoreCon&IncRowid=' + drugRowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var s = result.responseText;
			//s = s.replace("\r\n", "");// 这才是正确的！
			//s=s.replace(/\r/g,"&nbsp;")
			//s=s.replace(/\n/g,"<br />") 
			var jsonData = Ext.util.JSON.decode(s);
			
			if (jsonData.success == 'true') {
				//if(jsonData.info!=""){
				var list = jsonData.info.split("^");
				
				Ext.getCmp("RoomTemperature").setValue(list[1]=='Y'?true:false); //常温
				Ext.getCmp("Dry").setValue(list[2]=='Y'?true:false); //干燥
				Ext.getCmp("Airtight").setValue(list[3]=='Y'?true:false); //密闭
				Ext.getCmp("Dark").setValue(list[4]=='Y'?true:false); //避光
				Ext.getCmp("Ventilation").setValue(list[5]=='Y'?true:false); //通风
				Ext.getCmp("Radiation").setValue(list[6]=='Y'?true:false); //防辐射
				Ext.getCmp("MeltSeal").setValue(list[7]=='Y'?true:false); //熔封
				Ext.getCmp("Cool").setValue(list[8]=='Y'?true:false); //阴凉
				Ext.getCmp("ColdDark").setValue(list[9]=='Y'?true:false); //凉暗
				Ext.getCmp("Seal").setValue(list[10]=='Y'?true:false); //密封
				Ext.getCmp("Refrigeration").setValue(list[11]=='Y'?true:false); //冷藏
				Ext.getCmp("LowestTemperature").setValue(list[12]); //最低温
				Ext.getCmp("MaximumTemperature").setValue(list[13]); //最高温
				Ext.getCmp("LowHumidity").setValue(list[14]); //最低湿度
				Ext.getCmp("HighHumidity").setValue(list[15]); //最高湿度
				Ext.getCmp("Freeze").setValue(list[16]=='Y'?true:false); //冷冻
				Ext.getCmp("DampProof").setValue(list[17]=='Y'?true:false); //防潮
				//}				
			} 
		},
		scope : this
	});
}

//返回存储条件字符串
function getStoreConStr(drugRowid){
	var conStr="";
	var url = 'dhcstm.druginfomaintainaction.csp?actiontype=GetStoreCon&IncRowid=' + drugRowid;					
	var result=ExecuteDBSynAccess(url);
	var con=Ext.util.JSON.decode(result);
	if(con.info==""){
		return "";
	}
	var conArr=con.info.split("^");
	if(conArr[1]=='Y'){conStr=conStr+"常温 ";}
	if(conArr[2]=='Y'){conStr=conStr+"干燥 ";}
	if(conArr[3]=='Y'){conStr=conStr+"密闭 ";}
	if(conArr[4]=='Y'){conStr=conStr+"避光 ";}
	if(conArr[5]=='Y'){conStr=conStr+"通风 ";}
	if(conArr[6]=='Y'){conStr=conStr+"防辐射 ";}
	if(conArr[7]=='Y'){conStr=conStr+"熔封 ";}
	if(conArr[8]=='Y'){conStr=conStr+"阴凉 ";}
	if(conArr[9]=='Y'){conStr=conStr+"凉暗 ";}
	if(conArr[10]=='Y'){conStr=conStr+"密封 ";}
	if(conArr[11]=='Y'){conStr=conStr+"冷藏 ";}
	if(conArr[16]=='Y'){conStr=conStr+"冷冻 ";}
	if(conArr[17]=='Y'){conStr=conStr+"防潮 ";}
	if(conArr[12]!=''){conStr=conStr+"最低温:"+conArr[12]+" ";}
	if(conArr[13]!=''){conStr=conStr+"最高温:"+conArr[13]+" ";}
	if(conArr[14]!=''){conStr=conStr+"最低湿度:"+conArr[14]+" ";}
	if(conArr[15]!=''){conStr=conStr+"最高湿度:"+conArr[15];}

	return conStr;
}

	var INFOISCDR = new Ext.form.TextField({
				fieldLabel : '存储条件',
				tabIndex:420,
				disabled:true,
				id : 'INFOISCDR',
				name : 'INFOISCDR',
				anchor : '90%',
				width : 370,
				valueNotFoundText : ''
			});

//========================存储条件系列控件=================================
	var RoomTemperature = new Ext.form.Checkbox({
				boxLabel : '常温',
				id : 'RoomTemperature',
				name : 'RoomTemperature',
				anchor : '90%',
				checked : false
			});
			
	var Dry = new Ext.form.Checkbox({
				boxLabel : '干燥',
				id : 'Dry',
				name : 'Dry',
				anchor : '90%',
				checked : false
			});
			
	var Airtight = new Ext.form.Checkbox({
				boxLabel : '密闭',
				id : 'Airtight',
				name : 'Airtight',
				anchor : '90%',
				checked : false
			});
			
	var Dark = new Ext.form.Checkbox({
				boxLabel : '避光',
				id : 'Dark',
				name : 'Dark',
				anchor : '90%',
				checked : false
			});
			
	var Ventilation = new Ext.form.Checkbox({
				boxLabel : '通风',
				id : 'Ventilation',
				name : 'Ventilation',
				anchor : '90%',
				checked : false
			});
			
	var Radiation = new Ext.form.Checkbox({
				boxLabel : '防辐射',
				id : 'Radiation',
				name : 'Radiation',
				anchor : '90%',
				checked : false
			});
			
	var MeltSeal = new Ext.form.Checkbox({
				boxLabel : '熔封',
				id : 'MeltSeal',
				name : 'MeltSeal',
				anchor : '90%',
				checked : false
			});
			
	var Cool = new Ext.form.Checkbox({
				boxLabel : '阴凉',
				id : 'Cool',
				name : 'Cool',
				anchor : '90%',
				checked : false
			});
			
	var ColdDark = new Ext.form.Checkbox({
				boxLabel : '凉暗',
				id : 'ColdDark',
				name : 'ColdDark',
				anchor : '90%',
				checked : false
			});
			
	var Seal = new Ext.form.Checkbox({
				boxLabel : '密封',
				id : 'Seal',
				name : 'Seal',
				anchor : '90%',
				checked : false
			});
			
	var Refrigeration = new Ext.form.Checkbox({
				boxLabel : '冷藏',
				id : 'Refrigeration',
				name : 'Refrigeration',
				anchor : '90%',
				checked : false
			});
	var Freeze = new Ext.form.Checkbox({
				boxLabel : '冷冻',
				id : 'Freeze',
				name : 'Freeze',
				anchor : '90%',
				checked : false
			});
	var DampProof = new Ext.form.Checkbox({
				boxLabel : '防潮',
				id : 'DampProof',
				name : 'DampProof',
				anchor : '90%',
				checked : false
			});
	var LowestTemperature = new Ext.form.NumberField({
				fieldLabel : '最低温',
				id : 'LowestTemperature',
				name : 'LowestTemperature',
				anchor : '90%'
			});
			
	var MaximumTemperature = new Ext.form.NumberField({
				fieldLabel : '最高温',
				id : 'MaximumTemperature',
				name : 'MaximumTemperature',
				anchor : '90%'
			});
			
	var LowHumidity = new Ext.form.NumberField({
				fieldLabel : '最低湿度',
				id : 'LowHumidity',
				name : 'LowHumidity',
				anchor : '90%'
			});
			
	var HighHumidity = new Ext.form.NumberField({
				fieldLabel : '最高湿度',
				id : 'HighHumidity',
				name : 'HighHumidity',
				anchor : '90%'
			});
	//========================存储条件系列控件=================================
	var iscButton = new Ext.Button({
		text : '维护',
		tabIndex:430,
		width : 30,
		handler : function() {
			if (drugRowid==""){
				Msg.info("warning","请选择需要维护存储条件的库存项！");
				return;
			}
			var StoreConFormPanel = new Ext.form.FormPanel({
				labelWidth : 60,
				labelAlign : 'right',
				frame : true,
				items : [{
					layout : 'column',
					xtype:'fieldset',
					defaults:{border:false},
					items : [{
						columnWidth : .5,
						xtype:'fieldset',
						labelWidth : 70,
						items : [RoomTemperature,Airtight,Ventilation,MeltSeal,ColdDark,Refrigeration,DampProof,LowHumidity,HighHumidity]
					}, {
						columnWidth : .5,
						xtype:'fieldset',
						labelWidth : 70,
						items : [Dry,Dark,Radiation,Cool,Seal,Freeze,LowestTemperature,MaximumTemperature]
					}]
				}]
			});
			
			var win = new Ext.Window({
				title: '存储条件',
				width: 380,
				height:400,
				minWidth: 380,
				minHeight: 350,
				layout: 'fit',
				plain:true,
				modal:true,
				closeAction:'hide',
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items:StoreConFormPanel,
				buttons:[{
					text:'确定',
					handler: function() {
						var showStr = "";
						var storeStr = "";
											
						var roomTValue = (RoomTemperature.getValue()==true?'Y':'N');
						var dryValue = (Dry.getValue()==true?'Y':'N');
						var airtightValue = (Airtight.getValue()==true?'Y':'N');
						var darkValue = (Dark.getValue()==true?'Y':'N');
						var venTValue = (Ventilation.getValue()==true?'Y':'N');
						var radiationValue = (Radiation.getValue()==true?'Y':'N');
						var meltSealValue = (MeltSeal.getValue()==true?'Y':'N');
						var coolValue = (Cool.getValue()==true?'Y':'N');
						var coldDarkValue = (ColdDark.getValue()==true?'Y':'N');
						var sealValue = (Seal.getValue()==true?'Y':'N');
						var refrigerationValue = (Refrigeration.getValue()==true?'Y':'N');
						var lowestTemperatureValue = LowestTemperature.getValue();
						var lowHumidityValue = LowHumidity.getValue();
						var maxValue = MaximumTemperature.getValue();
						var highHumidityValue = HighHumidity.getValue();
						var FreezeValue = (Freeze.getValue()==true?'Y':'N');
						var DampProofValue = (DampProof.getValue()==true?'Y':'N');
						//格式：常温+"^"+干燥+"^"+密闭+"^"+避光+"^"+通风+"^"+防辐射+"^"+熔封+"^"+阴凉+"^"+凉暗+"^"+密封+"^"+冷藏+"^"+最低温+"^"+最高温+"^"+最低湿度+"^"+最高湿度+"^"+冷冻+"^"+防潮
						storeStr = roomTValue+"^"+dryValue+"^"+airtightValue+"^"+darkValue+"^"+venTValue+"^"+radiationValue+"^"+meltSealValue+"^"+coolValue+"^"+coldDarkValue+"^"+sealValue+"^"+refrigerationValue+"^"+lowestTemperatureValue+"^"+maxValue+"^"+lowHumidityValue+"^"+highHumidityValue+"^"+FreezeValue+"^"+DampProofValue;
						//存储条件保存成功后,在库存项附加表中保留dr(若之前没有)
						Ext.Ajax.request({
							url: 'dhcstm.druginfomaintainaction.csp?actiontype=saveStoreCon&storeStr='+storeStr+'&rowid='+storeConRowId+'&IncRowid=' + drugRowid,
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText);
								if (jsonData.success=='true') {
									Msg.info("success", "存储条件维护成功!");
									storeConRowId = jsonData.info;
									INFOISCDR.setValue(getStoreConStr(drugRowid));
									win.hide();
								}else{
									Msg.info("error","存储条件维护失败:"+jsonData.info);									
								}
							},
							scope: this
						});
					}
				}]
			});
			win.show();
			
			GetStoreCon();
		}
	});