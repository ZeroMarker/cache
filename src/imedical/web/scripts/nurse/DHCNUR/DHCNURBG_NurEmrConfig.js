function setvalue()
{
	var Type="TJ"
	var AnaesID=tkMakeServerCall("NurMp.DHCNurEmrConfig","GetId",Type);
	
    if(AnaesID!=""){
	var ret=tkMakeServerCall("NurMp.DHCNurEmrConfig","getBindInfo",AnaesID);
	var a=ret.split("^");
	var Item1=Ext.getCmp("Item1");
	Item1.setValue(a[0]);
	var Item2=Ext.getCmp("Item2");
	Item2.setValue(a[1]);
	var Item3=Ext.getCmp("Item3");
	Item3.setValue(a[2]);
	var Item4=Ext.getCmp("Item4");
	Item4.setValue(a[3]);
	  }
}
function setvalueLimit()
{
	var Type="Limit"
	var AnaesID=tkMakeServerCall("NurMp.DHCNurEmrConfig","GetId",Type);
	
    if(AnaesID!=""){
	var ret=tkMakeServerCall("NurMp.DHCNurEmrConfig","getLimitBindInfo",AnaesID);
	var a=ret.split("^");
	var Item6=Ext.getCmp("Item6");
	Item6.setValue(a[0]);
	var Item7=Ext.getCmp("Item7");
	Item7.setValue(a[1]);
	
	  }
}
function BodyLoadHandler(){
	
	var Item5 = Ext.getCmp("Item5");
	Item5.on('click', save);
	var Item8 = Ext.getCmp("Item8");
	Item8.on('click', saveLimit);
	setvalue();
	setvalueLimit();
}
function save()
{

	var Item1=Ext.getCmp("Item1");
	var Item2=Ext.getCmp("Item2");
	var Item3=Ext.getCmp("Item3");
	var Item4=Ext.getCmp("Item4");
	var Type="TJ"
	var AnaesID=tkMakeServerCall("NurMp.DHCNurEmrConfig","GetId",Type);
	
	if(AnaesID!=""){
		var ret=tkMakeServerCall("NurMp.DHCNurEmrConfig","save",Type+"^"+Item1.value+"^"+Item2.getValue()+"^"+Item3.value+"^"+Item4.value,session['LOGON.USERCODE'],AnaesID);
	}
	else{
	var ret=tkMakeServerCall("NurMp.DHCNurEmrConfig","save",Type+"^"+Item1.value+"^"+Item2.getValue()+"^"+Item3.value+"^"+Item4.value,session['LOGON.USERCODE'],"");

	}
	if (ret!="") {alert("保存成功！")}

	//find();
	return;
}
function saveLimit()
{

	var Item6=Ext.getCmp("Item6");
	var Item7=Ext.getCmp("Item7");
	
	var Type="Limit"
	var AnaesID=tkMakeServerCall("NurMp.DHCNurEmrConfig","GetId",Type);
	if (Item6.value=="不限日期"){ Item7.setValue("不限时间");}
	if ((Item6.value!="不允许书写当天之后记录")&&(Item6.value!="不限日期")){ Item7.setValue("不限时间");}
	if(AnaesID!=""){
		var ret=tkMakeServerCall("NurMp.DHCNurEmrConfig","RecLimitsave",Type+"^"+Item6.value+"^"+Item7.value,session['LOGON.USERCODE'],AnaesID);
	}
	else{
	var ret=tkMakeServerCall("NurMp.DHCNurEmrConfig","RecLimitsave",Type+"^"+Item6.value+"^"+Item7.value,session['LOGON.USERCODE'],"");

	}
	if (ret!="") {alert("保存成功！")}

	//find();
	return;
}