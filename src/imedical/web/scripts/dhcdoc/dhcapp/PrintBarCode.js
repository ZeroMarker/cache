///xml打印方法，需要在csp中加载xml打印的基本方法
function PrintBarCode(OrderID,PisID){
	var MyPara=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "PrintBarCode",
	    dataType:"text",
	    PisID:PisID,
	    Oeori:OrderID
    },false);
    var PrintArr=MyPara.split(String.fromCharCode(1))
    var PrintTemp=PrintArr[0]
    var BaseInfo=PrintArr[1]
    var Specinfo=PrintArr[2]
    if (Specinfo!=""){
	    var SpecinfoArr=Specinfo.split(String.fromCharCode(3))
	    for(var i=0; i<SpecinfoArr.length; i++){
		    var OneSpec=SpecinfoArr[i]
		    var OnePara=BaseInfo+"^"+OneSpec
		    DHCP_GetXMLConfig("InvPrintEncrypt",PrintTemp);
			//var myobj=document.getElementById("ClsBillPrint");
			//DHCP_XMLPrint(myobj,OnePara,"");
			DHC_PrintByLodop(getLodop(),OnePara,"","","");
		    }
	    }
	}