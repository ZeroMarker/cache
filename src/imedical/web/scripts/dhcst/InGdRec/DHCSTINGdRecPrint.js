// /����: ��ⵥ��ӡ
// /����: ��ⵥ��ӡ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.13

/*
 * creator:zhangdongmei,2012-11-23
 * description:��ӡ������ⵥ����Ǭ��
 * params: ingr:�������id
 * return:
 * */
function PrintRec(ingr,printtype){
	if(ingr==null || ingr==''){
		return;
	}
	
	var mainData=GetMainData(ingr);	
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var vendorIO=mainArr[1];
	var vendor=mainArr[2];
	var ingrNo=mainArr[0];
	var ingrDate=mainArr[12];
	var ingrLocIO=mainArr[10];
	var ingrLoc=mainArr[11];
	var CreateUserIO=mainArr[14]
	var CreateUser=mainArr[15]
	var PurUserIO=mainArr[19]
	var PurUser=mainArr[20]
	var RQDTFormat=App_StkRQDateFormat  //+" "+App_StkRQTimeFormat;
	if (printtype==1) {
		//ֱ�Ӵ�ӡ
		fileName="{DHCST_StockRec_Common.rpx(Parref="+ingr+";VendorIO="+vendorIO+";IngrNo="+ingrNo+";IngrDate="+ingrDate+";IngrLocIO="+ingrLocIO+";CreateUserIO="+CreateUserIO+";PurUserIO="+PurUserIO+ ";HospDescIO="+session['LOGON.HOSPID']+";RQDTFormat="+RQDTFormat+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
	else {
		//Ԥ����ӡ	
		fileName="DHCST_StockRec_Common.rpx&Parref="+ingr+"&VendorIO="+vendorIO+"&IngrNo="+ingrNo+"&IngrDate="+ingrDate+"&IngrLocIO="+ingrLocIO+"&CreateUserIO="+CreateUserIO+"&PurUserIO="+PurUserIO+"&HospDescIO="+session['LOGON.HOSPID']+"&RQDTFormat="+RQDTFormat;
		DHCCPM_RQPrint(fileName)	
	}
}
/*
 * creator:wyx,2013-11-20
 * description:��ӡ��ⵥ���յ�����Ǭ��
 * params: ingr:�������id
 * return:
 * */
function PrintRecCheck(ingr,printtype){
	if(ingr==null || ingr==''){
		return;
	}
	
	var mainData=GetMainData(ingr);	
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var vendorIO=mainArr[1];
	var vendor=mainArr[2];
	var ingrNo=mainArr[0];
	var ingrDate=mainArr[12];
	var ingrLocIO=mainArr[10];
	var ingrLoc=mainArr[11];
	var CreateUserIO=mainArr[14]
	var CreateUser=mainArr[15]
	var PurUserIO=mainArr[19]
	var PurUser=mainArr[20]
	var AcceptUserIO=mainArr[22];
	var AcceptUser=mainArr[23];
	var RQDTFormat=App_StkRQDateFormat;
	if (printtype==1) {
		//ֱ�Ӵ�ӡ
	    fileName="{DHCST_StockRecCheck_Common.raq(Parref="+ingr+";VendorIO="+vendorIO+";IngrNo="+ingrNo+";IngrDate="+ingrDate+";IngrLocIO="+ingrLocIO+";CreateUserIO="+CreateUserIO+";AcceptUserIO="+AcceptUserIO+";PurUserIO="+PurUserIO+";HospDescIO="+session['LOGON.HOSPID']+";RQDTFormat="+RQDTFormat+";PurUserIO="+PurUserIO+")}";
	    DHCCPM_RQDirectPrint(fileName);	
	}
	else {
		//Ԥ����ӡ		
	    fileName="DHCST_StockRecCheck_Common.raq&Parref="+ingr+"&VendorIO="+vendorIO+"&IngrNo="+ingrNo+"&IngrDate="+ingrDate+"&IngrLocIO="+ingrLocIO+"&CreateUserIO="+CreateUserIO+"&AcceptUserIO="+AcceptUserIO+"&PurUserIO="+PurUserIO+"&HospDescIO="+session['LOGON.HOSPID']+"&RQDTFormat="+RQDTFormat+"&PurUserIO="+PurUserIO
	    DHCCPM_RQPrint(fileName)
	}
}
/*
 * creator:zhangdongmei,2012-11-13
 * description:��ӡ������ⵥ
 * params: ingr:�������id
 * return:
 * */
function PrintRecBill(ingr){
	
	if(ingr==null || ingr==''){
		return;
	}
	
	var mainData=GetMainData(ingr);	
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var vendor=mainArr[2];
	var ingrNo=mainArr[0];
	var ingrDate=mainArr[12];
	var MyPara='Vendor'+String.fromCharCode(2)+vendor;
	MyPara=MyPara+'^IngrNo'+String.fromCharCode(2)+ingrNo;
	MyPara=MyPara+'^IngrDate'+String.fromCharCode(2)+ingrDate;
	
	var myList="";
	var detailArr=GetDetailData(ingr);
	for(i=0;i<detailArr.length;i++){
		var detailObj=detailArr[i];
		var inciCode=detailObj.IncCode;
		var inciDesc=detailObj.IncDesc;
		var spec="";
		var ingrUom=detailObj.IngrUom;
		var batNo=detailObj.BatchNo;
		var manf=detailObj.Manf;
		var qty=detailObj.RecQty;
		var rp=detailObj.Rp;
		var rpAmt=detailObj.RpAmt;
		var sp=detailObj.Sp;
		var spAmt=detailObj.SpAmt;
		var marAmt=spAmt-rpAmt;
		
		var firstdesc=inciCode+" "+inciDesc +" "+spec+" "+ingrUom+" "+batNo+" "+manf+" "+qty+" "+rp+" "+rpAmt+" "+sp+" "+spAmt+" "+marAmt;
		     
       	if (myList=='') {
         	myList = firstdesc;
       	}else{
        	myList = myList + String.fromCharCode(2)+firstdesc;
	    }            
	}
	
	DHCP_GetXMLConfig("DHCSTGdRecPrt");
	DHCP_PrintFun(MyPara,myList);
}

/*
 * creator:zhangdongmei,2012-11-13
 * description:ȡ�����ϸ��Ϣ
 * params: ingr:�������id
 * return:
 * */
function GetDetailData(ingr){
	
	if(ingr==null || ingr==''){
		return;
	}
	
	var url='dhcst.ingdrecaction.csp?actiontype=QueryDetail&Parref='+ingr+'&start=0&limit=999';
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);	
	var detailData=jsonData.rows;
	
	return detailData;
}

/*
 * creator:zhangdongmei,2012-11-13
 * description:ȡ���������Ϣ
 * params: ingr:�������id
 * return:
 * */
function GetMainData(ingr){
	var mainData="";
	if(ingr==null || ingr==''){
		return;
	}
	
	var url='dhcst.ingdrecaction.csp?actiontype=Select&IngrRowid='+ingr;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
}
