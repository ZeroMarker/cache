//
//UDHCJFOP.HandinReg11


var Guser,GuserCode,GuserName;
var FootInfo="",PrintInfo="",PrintListInfo="";



function BodyLoadHandler()
{
   Guser=session['LOGON.USERID'];
   GuserCode=session['LOGON.USERCODE'];
   GuserName=session['LOGON.USERNAME'];
   InitDoc();
   GetRegHandinHis();
   var myPrtXMLName="UDHCRegHandinRpt"
   DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);
   document.onkeydown = DHCWeb_EStopSpaceKey;
}


function InitDoc()
{
	
	var obj=document.getElementById("Find");
   	if (obj) obj.onclick=Find_Click; 
   	var obj=document.getElementById("Foot");
   	if(obj)DHCWeb_DisBtn(obj);
   	var obj=document.getElementById("Print");
   	if(obj)obj.onclick=Print_Click; 
   	DHCWeb_DisBtn(obj);  //081009
	var frm=document.forms["fUDHCJFOP_HandinReg11"];
	for (var i=0;i<frm.elements.length;i++)
	{
		var e = frm.elements[i];
		if (e.type=="text"){
			e.value="";
			e.disabled=true;
			//e.readOnly=true;
			
			}
		
	}
		
	
}
function GetRegHandinHis()
{
	var obj=document.getElementById("RepID");
	if (!obj) return;
	var RepID=obj.value;
	if (RepID=="") return;
	
   	
   	var obj=document.getElementById("Foot");
   	DHCWeb_DisBtn(obj);
   	var obj=document.getElementById("Find");
   	DHCWeb_DisBtn(obj);
   	
   	var encmeth=''
	var obj=document.getElementById("getRegHisDetail");
	if (obj) {
		encmeth=obj.value
	}
	if (encmeth=="") return;
	
	
	var rtn=cspRunServerMethod(encmeth,RepID);
   	
	SetHandsum(rtn);
	
	var obj=document.getElementById("Print");
   	if (obj) {
		DHCC_AvailabilityBtn(obj)
	   	obj.onclick=Print_Click; 
   	    
   	}
	}
function Find_Click()
{
	InitDoc();
	DHCWeb_DisBtnA("Find");
	DHCWeb_DisBtnA("Print");  //081009
	DHCWeb_DisBtnA("Foot");   //081009
	FootInfo=""
	var encmeth=''
	var obj=document.getElementById("FindClass");
	if (obj) {
		encmeth=obj.value
	}
	if (encmeth!=""){
		
		var rtn=(cspRunServerMethod(encmeth,'SetHandsum','',Guser)) 
   		var obj=document.getElementById("Foot");
		if (rtn==0){
   			
   			if (obj){
	   			DHCC_AvailabilityBtn(obj)
	   			//obj.disabled=true;
	   			obj.onclick=Foot_Click;
	   			///
   				var Pobj=document.getElementById("Print");
   				if (Pobj){ 
   					DHCC_AvailabilityBtn(Pobj)
   					Pobj.onclick=Print_Click;
   				}
	   		} 
		}else{
   			DHCWeb_DisBtn(obj);  //081009
   			var Pobj=document.getElementById("Print");
   			DHCWeb_DisBtn(Pobj); //081009
		}
	}
   
   var obj=document.getElementById("Find");
   if (obj) {
	   obj.disabled=false;
	   obj.onclick=Find_Click; 
   }
	
	}
function SetHandsum(value)
{
	FootInfo=value;
	PrintInfo="",PrintListInfo="";
	if (value=="") return;
	
	var myMInfo=value.split("^");
	DHCWebD_SetObjValueB("StartDate",myMInfo[0]);
	DHCWebD_SetObjValueB("StartTime",myMInfo[1]);
	DHCWebD_SetObjValueB("EndDate",myMInfo[2]);
	DHCWebD_SetObjValueB("EndTime",myMInfo[3]);
	DHCWebD_SetObjValueB("AmtSum",myMInfo[4]);
	DHCWebD_SetObjValueB("CashAmt",myMInfo[5]);
	DHCWebD_SetObjValueB("OtherAmt",myMInfo[6]);
	DHCWebD_SetObjValueB("Pamt",myMInfo[7]);
	DHCWebD_SetObjValueB("Ramt",myMInfo[8]);
	DHCWebD_SetObjValueB("ReceiptsNum",myMInfo[9]);
	DHCWebD_SetObjValueB("RefundNum",myMInfo[10]);
	DHCWebD_SetObjValueB("ReceiptsField",myMInfo[11]);
	DHCWebD_SetObjValueB("FirstAdmTot",myMInfo[12]);
	DHCWebD_SetObjValueB("FurtherAdmTot",myMInfo[13]);
	DHCWebD_SetObjValueB("DrugAdmTot",myMInfo[14]);
	DHCWebD_SetObjValueB("AdmTot",myMInfo[15]);
	DHCWebD_SetObjValueB("RefundAdmTot",myMInfo[16]);
	DHCWebD_SetObjValueB("AdmAmtSum",myMInfo[17]);
	DHCWebD_SetObjValueB("RefundNo",myMInfo[20]);
	
	var c2=String.fromCharCode(2);
	var obj=document.getElementById("ToDay");
	var Today=obj.value;
	PrintInfo="UserName"+c2+GuserName;
	PrintInfo=PrintInfo+"^"+"Today"+c2+myMInfo[18];
	PrintInfo=PrintInfo+"^"+"StartDate"+c2+myMInfo[0];
	PrintInfo=PrintInfo+"^"+"StartTime"+c2+myMInfo[1];
	PrintInfo=PrintInfo+"^"+"EndDate"+c2+myMInfo[2];
	PrintInfo=PrintInfo+"^"+"EndTime"+c2+myMInfo[3];
	PrintInfo=PrintInfo+"^"+"AmtSum"+c2+myMInfo[4];
	PrintInfo=PrintInfo+"^"+"CashAmt"+c2+myMInfo[5];
	PrintInfo=PrintInfo+"^"+"OtherAmt"+c2+myMInfo[6];
	PrintInfo=PrintInfo+"^"+"Pamt"+c2+myMInfo[7];
	PrintInfo=PrintInfo+"^"+"Ramt"+c2+myMInfo[8];
	PrintInfo=PrintInfo+"^"+"ReceiptsNum"+c2+myMInfo[9];
	PrintInfo=PrintInfo+"^"+"RefundNum"+c2+myMInfo[10];
	PrintInfo=PrintInfo+"^"+"ReceiptsField"+c2+myMInfo[11];
	PrintInfo=PrintInfo+"^"+"FirstAdmTot"+c2+myMInfo[12];
	PrintInfo=PrintInfo+"^"+"FurtherAdmTot"+c2+myMInfo[13];
	PrintInfo=PrintInfo+"^"+"DrugAdmTot"+c2+myMInfo[14];
	PrintInfo=PrintInfo+"^"+"AdmTot"+c2+myMInfo[15];
	PrintInfo=PrintInfo+"^"+"RefundAdmTot"+c2+myMInfo[16];
	PrintInfo=PrintInfo+"^"+"AdmAmtSum"+c2+myMInfo[17];
	
	if (myMInfo[20]!="")
	{
		var tmpDEl="^"
		var myInfo=myMInfo[20].split(",");
		var n=myInfo.length%3
		for (var i=0;i<myInfo.length;i++){
			if ((i%3)==0){
				tmpDEl=c2
				}
			else
			{
				tmpDEl="^"
				}
			if (PrintListInfo=="")
			{
				PrintListInfo=myInfo[i];
				}
			else
			{
				PrintListInfo=PrintListInfo+tmpDEl+myInfo[i];
			}
			}
		if (n!=0)
		{
			n=3-n
			for (var m=0;m<n;m++)
			{
				PrintListInfo=PrintListInfo+"^";
				}
			}	
		
		}
		
	}
function Foot_Click()
{
	Find_Click();
		
	var myrtn=confirm(t['tishi']);
	if (myrtn==false){return;}

	var handencobj=document.getElementById("FootClass");
	if (handencobj) {var encmeth=handencobj.value} else {var encmeth=''};
	
	if (encmeth==""){return;}
	var rtn=(cspRunServerMethod(encmeth,Guser,FootInfo)) 
	//alert(rtn);
	var mytmpary=rtn.split("^");
	if (mytmpary[0]=="0") {
		alert(t["01"]);
		var obj=document.getElementById("Foot");
		DHCWeb_DisBtn(obj);
		
   		var Pobj=document.getElementById("Print");
   		if (Pobj){ 
   			DHCC_AvailabilityBtn(Pobj)
   			Pobj.onclick=Print_Click;
   		}
   		
		
	}else{
		//alert(t["02"]);	  ///
		if(mytmpary[1]==""){
			alert(t["02"]+",插入结算主表错误!");
		}else{
			alert(t["02"]+",更新票据流水表错误");
		}
	}
	
	}
function Print_Click()
{
	if (PrintInfo!="")
	{
		XMLPrint(PrintInfo,PrintListInfo);
	}
	
	}
function XMLPrint(TxtInfo,ListInfo)
{
	
	//alert(TxtInfo)
	//alert(ListInfo)
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
	
}

function UnloadHandler(){
	///
	
}

document.body.onload = BodyLoadHandler;

document.body.onunload =UnloadHandler;