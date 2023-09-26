/////udhcOPCashExpCal.JS
/////

function BodyLoadHandler(){
	///	window.close();
	var obj=document.getElementById("Return");
	if (obj){
		obj.onclick=Return_OnClick;
	}
	var obj=document.getElementById("GetCash");
	if (obj){
		obj.onkeypress=GetCash_KeyPress;
	}
	
	var obj=document.getElementById("Expression");
	if (obj){
		obj.onkeypress=Expression_OnKeyPress;
		obj.onchange=Expression_OnChange;
	}
	
	var obj=document.getElementById("OperFootSum");
	if (obj){
		var myvalue=obj.value;
		if (myvalue==""){
			obj.style.display="none";
			var obj=document.getElementById("cOperFootSum");
			if (obj){
				obj.style.display="none";
			}
		}
	}
	var obj=document.getElementById("PutCash");
	if (obj){
		obj.readOnly=true;
	}
	
	var obj=document.getElementById("TotalCash");
	if (obj){
		obj.readOnly=true;
	}
	websys_setfocus("Expression");
	
}

function Expression_OnChange(){
	
}

function Expression_OnKeyPress(){
	var mykey=event.keyCode;
	if (mykey==13){
		var mysum=ExpCalculate();
		///alert(mysum);
		var obj=document.getElementById("TotalCash");
		if (obj){
			obj.value=mysum;
		}
		websys_setfocus("GetCash");
		return;
	}
	
	if ((mykey>57)||(mykey<42)||(mykey==44)){
		event.keyCode=0;
		return;
	}
	///
	var obj=document.getElementById("Expression");
	if (obj){
		var myExp=obj.value;
		var myLen=myExp.length;
		if (myLen>0){
			var laststr=myExp.substring(myLen-1);
			var newstr=String.fromCharCode(mykey);
			var myopflag=CheckChr(laststr,newstr,myExp);
			if (myopflag){
				event.keyCode=0;
				return;
			}
		}
	}
	
}

function CheckChr(lstr,nstr,Expression){
	var lflag=0;
	var nflag=0;
	var multpoint=0;
	
	lflag=ReturnFlag(lstr);
	nflag=ReturnFlag(nstr);	
	
	///
	if (nstr=="."){
		var curstr="";
		var mylen=Expression.length;
		for (var i=mylen;i>0;--i){
			curstr=Expression.substring(i-1,i);
			///alert(""+curstr+"mylen"+mylen+"i"+i+Expression);
			if (curstr=="."){
				///
				multpoint=1;
				break;
			}else{
				///
				var operflag=ReturnFlag(curstr);
				if (operflag==1){
					///
					break;
				}
			}
		}
	}
	
	return (((nflag==1)&&(lflag==1))||(multpoint==1));
}

function ReturnFlag(nstr){
	var nflag=0;
	
	switch (nstr){
		case ".":
			nflag=1;
			break;
		case "+":
			nflag=1;
			break;
		case "-":
			nflag=1;
			break;
		case "*":
			nflag=1;
			break;
		case "/":
			nflag=1;	
	}
	return nflag;	
}

function GetCash_KeyPress(){
	var key=event.keyCode;
	if (key==13){
		var obj=document.getElementById("GetCash");
		var objb=document.getElementById("TotalCash");
		var Resobj=document.getElementById("PutCash");
		DHCWeb_Calobj(obj,objb,Resobj,"-");
		websys_setfocus("Return");
	}
	DHCWeb_SetLimitFloat();

}

function ExpCalculate(){
	var myAddAry=new Array();
	var myDecAry=new Array();
	var myMulAry=new Array();
	var myDivAry=new Array();
	var mySum=0;
	
	var Expression="";
	var obj=document.getElementById("Expression");
	if (obj){
		Expression=obj.value;
	}
	try{
		////Expression="12+23*2+15-29+26/2-18";
		///
		myAddAry=Expression.split("+");
		
		////-
		for (var i=0;i<myAddAry.length;i++){
			///alert("myAddAry[i]="+myAddAry[i]);
			myDecAry[i]=new Array();
			myMulAry[i]=new Array();
			myDivAry[i]=new Array();
			
			myDecAry[i]=myAddAry[i].split("-");
			
			//////*
			for (var j=0;j<myDecAry[i].length;j++){
				//alert("myDecAry[i][j]="+myDecAry[i][j]);
				
				myDivAry[i][j]=new Array();
				myMulAry[i][j]=new Array();
				
				myMulAry[i][j]=myDecAry[i][j].split("*");
				/////
				for (var k=0;k<myMulAry[i][j].length;k++){
					///alert("myMulAry[i][j]="+myMulAry[i][j][k]);
					myDivAry[i][j][k]=new Array();
					myDivAry[i][j][k]=myMulAry[i][j][k].split("/");
				}
			}	
		}
		var myAddSum=0;
		var myDecSum=0;
		var myMulSum=0;
		var myDivSum=0;
		for (var i=0;i<myDivAry.length;i++){
			///alert("i="+i);
			myDecSum=0;
			for (var j=0;j<myDivAry[i].length;j++){
				myMulSum=1;
				for (var k=0;k<myDivAry[i][j].length;k++){
					myDivSum=0;
					for (var m=0;m<myDivAry[i][j][k].length;m++){
						if (m==0){
							myDivSum=myDivAry[i][j][k][m];
						}else{
							if ((myDivAry[i][j][k][m]=="")||(myDivAry[i][j][k][m]==0))
							{myDivAry[i][j][k][m]=1;}
							myDivSum=myDivSum/myDivAry[i][j][k][m];
							///alert("myDivSum=:::"+myDivSum);
						}
					}	////Expression="12+23*2+15-29+26/2-18";
					///alert("myDivSum="+myDivSum);
					myMulAry[i][j][k]=myDivSum;
					myMulSum=myMulSum*myMulAry[i][j][k];
					///alert(myMulSum+"Multi"+myMulAry[i][j][k]);
				}
				///alert("myMulSum="+myMulSum);
				myDecAry[i][j]=myMulSum;
				if (j==0){
					myDecSum=myDecAry[i][j];
				}else{
					myDecSum-=myDecAry[i][j];
				}
			}
			///alert("myDecSum="+myDecSum);
			myAddAry[i]=myDecSum;
			myAddSum+=myAddAry[i];
			
		}
		///alert(myAddSum);
	}catch(e){
		alert(e.message);
	}	
	
	for (var i=0;i<myAddAry.length;i++){
		if ((isNaN(myAddAry[i]))||(myAddAry[i]=="")){myAddAry[i]=0;}
		mySum+=parseFloat(myAddAry[i]);
	}
	
	return mySum;
}

function Num (Num) {
	if (FlagNewNum) {
		FKeyPad.ReadOut.value = Num;
		FlagNewNum = false;
	}
	else {
		if (FKeyPad.ReadOut.value == "0")
			FKeyPad.ReadOut.value = Num;
		else
			{FKeyPad.ReadOut.value += Num;}
	}
}


function Operation (Op) {
	var Readout = FKeyPad.ReadOut.value;
	if (FlagNewNum && PendingOp != "=");
	else
	{
		FlagNewNum = true;
		if ( '+' == PendingOp )
			Accum += parseFloat(Readout);
		else if ( '-' == PendingOp )
			Accum -= parseFloat(Readout);
		else if ( '/' == PendingOp )
			Accum /= parseFloat(Readout);
		else if ( '*' == PendingOp )
			Accum *= parseFloat(Readout);
		else
			Accum = parseFloat(Readout);
			FKeyPad.ReadOut.value = Accum;
			PendingOp = Op;
	}
}


function Return_OnClick(){
	window.close();
}
document.body.onload = BodyLoadHandler;

