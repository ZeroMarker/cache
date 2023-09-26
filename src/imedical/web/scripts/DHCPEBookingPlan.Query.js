/// DHCPEBookingPlan.Query.js
/// 

/// ����ʱ��		2006.03.16
/// ������		xuwm
/// ��Ҫ����		�༭վ�������Ϣ
/// ��Ӧ��		DHC_PE_Station
/// ����޸�ʱ��	
/// ����޸���	
/// ���
function BodyLoadHandler() {
	
	// tree.js
	CreateTreeFromXMLObject(Tree,GList);
	
	SBookingDate=""
	SetDate("BookingDate","ldBookingDate");
	
	var obj;
	obj=document.getElementById("BQuery");
	if (obj) { obj.onclick=BQuery_Click; }	
}

// �����ѯ��ť
function BQuery_Click() {

	var obj;
	var iQType="G";
	
	var iBookingDate="", iBookingName="";

	//obj=document.getElementById("GADM");
	//if (obj && obj.checked) { iQType="G"; }
	
	//obj=document.getElementById("IADM");
	//if (obj && obj.checked) { iQType="I"; }
	//if (""==iQType) { return ; }
	
	// �����ڲ���
	obj=document.getElementById("BookingDate");
	if (obj && ""!=obj.value) {
		iQType='G';
		iBookingDate=obj.value;
	}
	
	// ��ԤԼ�˲���
	obj=document.getElementById("BookingName");
	if (obj && ""!=obj.value) {
		iQType='A';
		iBookingName=obj.value;
	}
	
	if ((''==iBookingDate)&&(''==iBookingName)) { return false; }
	
	BookingPlanQuery(iQType+"^"+iBookingDate+"^"+iBookingName);	

}
// �ӿں���?��ѯԤԼ������/������
function BookingPlanQuery(Condition) {

	var Params=Condition.split("^");
	var SType="";
	
	var SBookingDate='', SBookingName='';
	
	if (Params[0]) { SType=Params[0];} 	
	
	if (Params[1]) { SBookingDate=Params[1];} 
	
	if (Params[2]) { SBookingName=Params[2];} 
	
	// ��ԤԼ���ڲ���?�Ȳ�������
	if ('G'==SType) {
		var Ins=document.getElementById('ClassBox');
    	if (Ins) {var encmeth=Ins.value} 
    	else {var encmeth=''};
    	var ret=cspRunServerMethod(encmeth,SBookingDate);
		GList.innerHTML=ret;
		CreateTreeFromXMLObject(Tree,GList);
	}
	
	// ��ԤԼ�˲���?ֱ�Ӳ���
	if ('A'==SType) {
		showDetail('0', SBookingDate, SBookingName, SType);
		GList.innerHTML='';
		CreateTreeFromXMLObject(Tree,GList);
	}
	
}

// �û�����ĵ�����ͽṹʱ��ִ�к���
function TreeOnClick(entity) {
	var param=entity.URL;
	var iBookingDate='', iBookingName='';
 	
	obj=document.getElementById("BookingDate");
	if (obj && ""!=obj.value) { iBookingDate=obj.value; }
	
	obj=document.getElementById("BookingName");
	if (obj && ""!=obj.value) {iBookingName=obj.value; }
	if (param && ""!=param) {
		params=param.split("^");
		showDetail(params[0], iBookingDate, iBookingName, params[1]);
	}
}

function showDetail(GTId, SBookingDate, SBookingName, SearchType) {
	//alert("GTId:"+GTId+'  SBookingName:'+SBookingName+'  SearchType:'+SearchType);
	if (""==GTId) { return false; };
	if ((""==SBookingDate)&&(''==SBookingName)) { return false; };
	
	var URL="DHCPEBookingPlan.Result.csp?a=a"
			+"&SearchType="+SearchType
			+"&GTId="+GTId
			+"&BookingDate="+SBookingDate
			+"&BookingName="+SBookingName
			;
	
	OpenIFRAMEWindow("dataframe",URL);
}

document.body.onload = BodyLoadHandler;

/// chartbook.operator.js

// /////////////////////////////////////////////////////////

//��Ƕ�׿���� ���µĴ���
function OpenIFRAMEWindow(IfFrameName,lnk) {
	var df=document.getElementById(IfFrameName);
	if (df) { df.src=lnk; }
}

// ��Ƕ�׿���� ˢ�´���
function ReloadIFRAMEWindow(lnk) {

	var df=document.getElementById("dataframe");
	if (df) { df.src=lnk; }

}

// //////////////////////////////////////////////////////////////////////////////
// ���º��� �ο� epr.chartbook.show.csp 
	var offsetWdt = document.body.offsetWidth - document.body.clientWidth;
	var offsetHgt = document.body.offsetHeight - document.body.clientHeight;
	var remainHgt;
	var remainWdt;
	
function setDataFrameSize() {

		var posLeft=0;
		
		remainHgt = document.body.offsetHeight -3 -offsetHgt;
		remainWdt = document.body.offsetWidth -3 -offsetWdt;
		
		//set data frame to length and width of remaining page, and widen to fit charttabs
		//var obj=document.getElementById("charttabs");
		//posLeft = obj.offsetWidth;
		//obj.style.width = posLeft;
	
		//var obj=document.getElementById("chartbook");
		//remainHgt -= obj.offsetTop;
		//remainWdt -= obj.offsetLeft;
	
		//posLeft += obj.offsetWidth;
		var obj=document.getElementById("data");
		obj.style.left = posLeft;
		remainWdt -= posLeft;
		
		resizeframe(remainWdt,remainHgt)

}

function resizeframe(remainWdt,remainHgt)
{
	try {
		document.frames["dataframe"].window.resizeTo(remainWdt,remainHgt);
	}
	catch (e) {
		setDataFrameSize();
	}
}

function SetWinsowSize() {
	var  s = "";
	var obj=document.getElementById("WinsowSize");
	var tobj=document.getElementById("TWinsowSize");
	s += "��ҳ�ɼ������(clientWidth):"+ document.body.clientWidth;
	s += "\r\n��ҳ�ɼ������(offsetWidth):"+ document.body.offsetWidth  +" (�������ߺ͹������Ŀ�)";
	s += "\r\n��ҳ����ȫ�Ŀ�(scrollWidth):"+ document.body.scrollWidth;
	s += "\r\n��Ļ���ù��������(availWidth):"+ window.screen.availWidth;
	s += "\r\n��Ļ�ֱ��ʵĿ�(width):"+ window.screen.width;

	s += "\r\n\r\n��ҳ�ɼ������(clientHeight):"+ document.body.clientHeight;
	s += "\r\n��ҳ�ɼ������(offsetHeight):"+ document.body.offsetHeight +" (�������ߵĿ�)";
	s += "\r\n��ҳ����ȫ�ĸ�(scrollHeight):"+ document.body.scrollHeight;
	s += "\r\n��Ļ���ù������߶�(availHeight):"+ window.screen.availHeight;
	s += "\r\n��Ļ�ֱ��ʵĸ�(height):"+ window.screen.height;

	s += "\r\n��ҳ����ȥ�ĸ�(scrollTop):"+ document.body.scrollTop;
	s += "\r\n��ҳ���Ĳ�����(screenTop):"+ window.screenTop;

	s += "\r\n��ҳ����ȥ����(scrollLeft):"+ document.body.scrollLeft;
	s += "\r\n��ҳ���Ĳ�����(screenLeft):"+ window.screenLeft;

	s += "\r\n�����Ļ������ "+ window.screen.colorDepth +" λ��ɫ";
	s += "\r\n�����Ļ���� "+ window.screen.deviceXDPI +" ����/Ӣ��";
	
	s += "\r\n \r\n �ؼ� �ɼ������(clientWidth):"+ obj.clientWidth;
	s += "\r\n �ؼ� �ɼ������(offsetWidth):"+ obj.offsetWidth  +" (�������ߺ͹������Ŀ�)";
	s += "\r\n �ؼ� ����ȫ�Ŀ�(scrollWidth):"+ obj.scrollWidth;

	s += "\r\n �ؼ� �ɼ������(clientHeight):"+ obj.clientHeight;
	s += "\r\n �ؼ� �ɼ������(offsetHeight):"+ obj.offsetHeight +" (�������ߵĿ�)";
	s += "\r\n �ؼ� ����ȫ�ĸ�(scrollHeight):"+ obj.scrollHeight;	
	
	s += "\r\n \r\n DIV �ɼ������(clientWidth):"+ tobj.clientWidth;
	s += "\r\n DIV �ɼ������(offsetWidth):"+ tobj.offsetWidth  +" (�������ߺ͹������Ŀ�)";
	s += "\r\n DIV ����ȫ�Ŀ�(scrollWidth):"+ tobj.scrollWidth;

	s += "\r\n DIV �ɼ������(clientHeight):"+ tobj.clientHeight;
	s += "\r\n DIV �ɼ������(offsetHeight):"+ tobj.offsetHeight +" (�������ߵĿ�)";
	s += "\r\n DIV ����ȫ�ĸ�(scrollHeight):"+ tobj.scrollHeight;

	s += "\r\n DIV ���Ŀհ�(padding):"+ tobj.padding;
	s += "\r\n DIV ���ı߿�(border):"+ tobj.border;
	if (obj) { obj.value=s }
}
//window.onresize=SetWinsowSize;
//window.onresize = setDataFrameSize;
