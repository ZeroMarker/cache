//����	DHCPESpecList.hisui.js
//����  �걾�ɼ�һ��
//����	2019.06.25
//������  xy
$(function(){
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
 	});
})

//��ѯ
function BFind_click() {
	var Month = $("#Month").datebox('getValue');
	if(Month == "") {
		$.messager.alert("��ʾ", "����ѡ�����ڣ�", "info");
		return false;
	}
	
	//lnk = "dhcpespeclist.hisui.csp" + "?Month=" + Month + "&CTLOCID=" + "";
	//window.location.href=lnk
	
	var TabInfo = $.m({ClassName:"web.DHCPE.BarPrintFind", MethodName:"OutMainHISUI", Month:Month, OutFlag:"Return"}, false);
	
	$("#SpecListyDiv").empty();
	$("#SpecListyDiv").append(TabInfo);  
}

function ShowSpecList(e) {
	var DateStr = e.id;
	var lnk = "dhcpespecdetail.hisui.csp?BeginDate=" + DateStr + "&EndDate=" + DateStr + "&Type=Item";
	//alert(lnk)
	websys_lu(lnk,false,'width=1100,height=700,hisui=true,title = �걾�ɼ���Ϣ')
}