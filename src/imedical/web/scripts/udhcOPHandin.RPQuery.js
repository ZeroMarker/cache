////udhcOPHandin.RPQuery.JS

function BodyLoadHandler(){
	var obj=document.getElementById("RepEncmeth");
	if (obj){
		var encmeth=obj.value;
	}
	var obj=document.getElementById("RepID");
	if (obj){
		var RepID=obj.value;
	}
	var prtobj=document.getElementById("BPrint");
	if (prtobj){
		prtobj.onclick=BPrint_Click;
	}
	
	if (encmeth!=""){
		var rtnvalue=(cspRunServerMethod(encmeth,RepID)) 
	}
	var rtnary=rtnvalue.split("^");
	if (rtnary.length<23){
		DHCWeb_DisBtn(prtobj);
	}else{
		WrtDoc(rtnary);
	}
	
}

function BPrint_Click(){
	PrintClickHandler();	
}

function WrtDoc(rtnary){
	//write Document object
	var obj=document.getElementById("sUser");
	if (obj){
		obj.value=rtnary[0];
	}
	
	///StartDate
	var obj=document.getElementById("StartDate");
	if (obj){
		obj.value=rtnary[4];
	}

	var obj=document.getElementById("StartTime");
	if (obj){
		obj.value=rtnary[5];
	}

	var obj=document.getElementById("EndDate");
	if (obj){
		obj.value=rtnary[6];
	}

	var obj=document.getElementById("EndTime");
	if (obj){
		obj.value=rtnary[7];
	}
	
	//
	var obj=document.getElementById("TotalFee");
	if (obj){
		obj.value=(rtnary[8]);
	}

	var obj=document.getElementById("INVNOinfo");
	if (obj){
		obj.value=rtnary[11];
	}

	var obj=document.getElementById("HandSum");
	if (obj){
		obj.value=rtnary[17];
	}

	var obj=document.getElementById("CashNUM");
	if (obj){
		obj.value=rtnary[18];
	}

	var obj=document.getElementById("CashSUM");
	if (obj){
		obj.value=rtnary[19];
	}

	var obj=document.getElementById("CheckNUM");
	if (obj){
		obj.value=rtnary[20];
	}

	var obj=document.getElementById("CheckSUM");
	if (obj){
		obj.value=rtnary[21];
	}

	var obj=document.getElementById("RefundNUM");
	if (obj){
		obj.value=rtnary[22];
	}

	var obj=document.getElementById("RefundSUM");
	if (obj){
		obj.value=rtnary[23];
	}

	var obj=document.getElementById("CancelNUM");
	if (obj){
		obj.value=rtnary[24];
	}

	var obj=document.getElementById("CancelSUM");
	if (obj){
		obj.value=rtnary[25];
	}

	var obj=document.getElementById("ParkINV");
	if (obj){
		obj.value=rtnary[26];
	}

	var obj=document.getElementById("RefundINV");
	if (obj){
		obj.value=rtnary[27];
	}
	
	///
	if (isNaN(rtnary[8])){
		var paysum=0;
	}else{
		var paysum=parseFloat(rtnary[8]);
	}
	////
	if (!isNaN(rtnary[17])){
		paysum=paysum-parseFloat(rtnary[17]);
	}
	
	var mypaysum=paysum.toFixed(2);
	
	var obj=document.getElementById("PayorTotal");
	if (obj){
		obj.value=mypaysum;
	}

}

function PrintDoc(){
	///
	
	
}

document.body.onload=BodyLoadHandler;