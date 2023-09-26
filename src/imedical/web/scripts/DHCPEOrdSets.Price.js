// DHCPEOrdSets.Price.js
// cread by zhongricheng
var ARCOSAmount;
function BodyLoadHandler() {
	var obj;

	obj = document.getElementById("BUpd");
	if (obj) { obj.onclick=BUpd_click; }
	
	obj = document.getElementById("BDel");
	if (obj) { obj.onclick=BDel_click; }
	
	obj = document.getElementById("Price");
	if (obj) { obj.onchange=Price_change; }
	
	obj = document.getElementById("Discount");
	if (obj) { obj.onchange=Discount_change; }
	
	obj = document.getElementById("ARCOSAmount");
	if (obj) { ARCOSAmount=obj.value; } 
	
}
function Price_change() {
	
	var Price="";
	userId=session['LOGON.USERID'];
	var priceObj = document.getElementById("Price");
	if (priceObj.value != "") { Price=priceObj.value; }
	
	var Discount = (Price / ARCOSAmount * 100).toFixed(2);
	
	var Dflag=UserDiscount(userId,Discount);
	if (Dflag=0) return false;
	
	var discountObj = document.getElementById("Discount");
	if (discountObj) { discountObj.value = Discount; }
}

function BUpd_click() {
	var obj,DateBegin="",DateEnd="",Price="",ARCOSRowid="";
	
	obj = document.getElementById("Date");
	if (obj) { Date=obj.value; }
		
	Price_change();
	
	obj = document.getElementById("Price");
	if (obj) { Price=obj.value; } 
		
	var MoneyF = /(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/;
	if (!MoneyF.test(Price)) {
		alert("请输入正确金额.");
		return false;
	}
	
	obj = document.getElementById("ARCOSRowid");
	if (obj) { ARCOSRowid=obj.value; }
	
	if (ARCOSRowid=="") return false;
		
	var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,Date,Date,Price,"");
	if (rtn==0) {
		alert("更新成功！");
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.Price&ARCOSRowid="+ARCOSRowid+"&ARCOSAmount="+ARCOSAmount;
		location.href=lnk;
		window.opener.location.reload();
	} else {
		alert("更新失败！"+rtn);
	}
}

function BDel_click() {
	var obj = document.getElementById("ARCOSRowid");
	if (obj) { ARCOSRowid=obj.value; }
	
	var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,"","","","");
	if (rtn==0) {
		alert("还原成功！");
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEOrdSets.Price&ARCOSRowid="+ARCOSRowid+"&ARCOSAmount="+ARCOSAmount;
		location.href=lnk;
		window.opener.location.reload();
	} else {
		alert("还原失败！"+rtn);
	}
}


function Discount_change() {
	var Discount="";
	userId=session['LOGON.USERID'];	
	var discountObj = document.getElementById("Discount");
	if (discountObj.value != "") { Discount=discountObj.value; }
	
	var Dflag=UserDiscount(userId,Discount);
	if (Dflag==0) return false;
		
	var Price = (Discount / 100 * ARCOSAmount ).toFixed(2)
	
	var priceObj = document.getElementById("Price");
	if (priceObj) { priceObj.value = Price; }
}

function UserDiscount(userId,Discount) {
	DFLimit=tkMakeServerCall("web.DHCPE.ChargeLimit","DFLimit",userId);   // 取UserId的最大折扣率
	
	if (DFLimit==0) {
		clear();
		alert("没有打折权限");
	    return 0;
	}
	if(+DFLimit>+Discount) {
		clear();
		alert("权限不足,您的折扣权限为:"+DFLimit+"%");
		return 0;
	}
	return 1;
}

function clear() {
	var priceObj = document.getElementById("Price");
	if (priceObj) { priceObj.value = ""; }
	var discountObj = document.getElementById("Discount");
	if (discountObj) { discountObj.value = ""; }
}

document.body.onload = BodyLoadHandler;