//名称	DHCPESpecList.hisui.js
//功能  标本采集一览
//创建	2019.06.25
//创建人  xy
$(function(){
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
 	});
})

//查询
function BFind_click() {
	var Month = $("#Month").datebox('getValue');
	if(Month == "") {
		$.messager.alert("提示", "请先选择日期！", "info");
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
	websys_lu(lnk,false,'width=1100,height=700,hisui=true,title = 标本采集信息')
}