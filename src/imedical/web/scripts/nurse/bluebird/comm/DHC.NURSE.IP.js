
//CreateComboBox('arcimDr','ArcimDesc','ArcimDR','医嘱项',"",90,'web.DHCNurCom','FindMasterItem',"ARCIMDesc"),

function CreateComboBoxQ(id,displayField,valueField,fieldLabel,value,width,className,methodName,queryParam,x,y){
	//var aa=tkMakeServerCall("web.DHCNUREMR","GenerateComBoxMeta",displayField+"^"+valueField,className,methodName);
	var combox=new Ext.form.ComboBox({
		store:eval("("+cspRunServerMethod(GenerateComBoxMeta,displayField+"^"+valueField,className,methodName)+")"),//
		displayField:displayField,
		valueField:valueField,
		fieldLabel:fieldLabel,
//		layout:'absolute',
		id:id,
		x:x,
		y:y,
		value:value,
		width:width,
		hideTrigger:false,
		queryParam:queryParam,
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		typeAhead:true,
		typeAheadDelay:1000,
		loadingText:'Searching...'
	})
	
	return combox;
}

function CreateStore(className,methodName){
	var store=new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader(
				eval("("+tkMakeServerCall("Nur.QueryBroker","GenerateMetaData",className,methodName)+")")
			),
			baseParams:{
				className:className,
				methodName:methodName,
				type:'Query'
			}
	});
	return store;
}

function CreateComboBox(id,displayField,valueField,fieldLabel,value,width,className,methodName,queryParam,x,y){
		

	var combox=new Ext.form.ComboBox({
		store:CreateStore(className,methodName),
		displayField:displayField,
		valueField:valueField,
		fieldLabel:fieldLabel,
//		layout:'absolute',
		id:id,
		x:x,
		y:y,
		value:value,
		width:width,
		hideTrigger:false,
		queryParam:queryParam,
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		typeAhead:true,
		typeAheadDelay:1000,
		loadingText:'Searching...'
	})
	combox.on("expand",function(comboBox){
		comboBox.list.setWidth('auto');
		comboBox.innerList.setWidth('auto');
	},this,{ single: true }) 
	return combox;
}
