//DHCRisApplicationBill.js
var gPrintTemp; 
var gHtmlTemp;
var list1=new Array();list2=new Array();list3=new Array();ListInfo="";ListInfo="";ListInfo1="";

function BodyLoadHandler()
{	
    //if selected more orditem ,use first order rowid as master order
    //alert("1")
    var OEorditemID=document.getElementById("OEorditemID").value;
    
    var orditem=OEorditemID.split("^");
    var FirstOrderItem=orditem[0];

    GetPrintTemp(FirstOrderItem); 
 
    var EpisodeID=document.getElementById("EpisodeID").value;
 
    var HopeDateObj=document.getElementById("HopeDate");
    if (HopeDateObj.value=="")
    	HopeDateObj.value=DateDemo(); 
    
    
    var SaveStatusobj=document.getElementById("SaveStatus");
	if (SaveStatusobj)
	{
	 	SaveStatusobj.onclick=SaveStatusClick;
	}
    var SaveGlobalObj=document.getElementById("SaveGlobal");
	if (SaveGlobalObj)
	{
		SaveGlobalObj.onclick=SaveGlobalClick;
	}
  	var todayObj=document.getElementById("today");
	if (todayObj)
	{
		todayObj.onclick=todayclick;
	}
   
	var btnsendobj=document.getElementById("SentBiil");
	if (btnsendobj)
	{
		btnsendobj.onclick=sendclick;
	}
	var btnprintobj=document.getElementById("PrintBill");
	if (btnprintobj)
	{
	   btnprintobj.onclick=printClick;
	}
	
	var Cancelobj=document.getElementById("CancelSend");
	if (Cancelobj)
	{
	   Cancelobj.onclick=CancelClick;
	}
	
	var Tempobj=document.getElementById("Template");
	if (Tempobj)
	{
	   Tempobj.onclick=TempClick;
	}

	var Saveobj=document.getElementById("Save");
	if (Saveobj)
	{
	   Saveobj.onclick=SaveClick;
	}
	///////////////////////////////////////////////////////////
    //ret=LoadXMLData(FirstOrderItem) ///  append line   yjy 2008.6.12
    //////////////////////////////////////////////////////////
   ret=0 //yjy 2008.6.12
   
    if (ret==0)     //It doesn't write application bill
	{
		//get default application information
		var GetPaadmInfoFun=document.getElementById("GetAdmInfo").value;
  		var value=cspRunServerMethod(GetPaadmInfoFun,EpisodeID)
    	if (value!="")
		{   
			var item=value.split("^");
			document.getElementById("RegNo").value=item[0];
			document.getElementById("Name").value=item[1];
			document.getElementById("DOB").value=item[2];
			document.getElementById("Age").value=item[3];
			document.getElementById("Sex").value=item[4];
			document.getElementById("Ward").value=item[9];
			document.getElementById("BedNo").value=item[10];
			document.getElementById("PHeight").value=item[19];
			document.getElementById("PWeight").value=item[20];
			document.getElementById("InPatientNo").value=item[8];
			document.getElementById("TelNo").value=item[18];
			document.getElementById("address").value=item[21];
			document.getElementById("InLoc").value=item[7];
			document.getElementById("AppDoc").value=session['LOGON.USERNAME'];
			document.getElementById("MedicareNo").value=item[32];
			document.getElementById("InsuranceNo").value=item[33];
			// InsuranceNo:医疗保险号
			// MedicareNo?病历号
		}
		var GetOrdItemInfoFun=document.getElementById("GetOrdItemInfo").value;
		
  		var OeordInfo=FirstOrderItem.split("||");
  		var value=cspRunServerMethod(GetOrdItemInfoFun,OeordInfo[0],OeordInfo[1]);
  		
     	if (value!="")
		{   
			var item=value.split("^");
			document.getElementById("AppDate").value=item[1];
			document.getElementById("RecLoc").value=item[20];
    		document.getElementById("price").value=item[11];

		}
		
		// get patient main diagonse 
		var GetMainDiagoseFunction=document.getElementById("GetMainDiagose").value;
  		var value=cspRunServerMethod(GetMainDiagoseFunction,EpisodeID)
    	document.getElementById("MainDiagose").value=value;
    	
    	// get patient default current status 
    	var GetCurrentStatusFunction=document.getElementById("GetCurrentStatusFunction").value;
  		var value=cspRunServerMethod(GetCurrentStatusFunction,EpisodeID)
    	document.getElementById("PatientNow").value=value;
     	
    	// get exam default gloal 
        var Info1=GetBlobal(OEorditemID);
        //alert(Info1)
     
    	document.getElementById("purpose").value=Info1;
    	
    	GetOrdName(OEorditemID);

    }
    //DHCP_GetXMLConfig("XMLObject","DHCRisApplicationBillCT");
	
 }

 function GetBlobal(OEorditemID)
 {
	 var orditem=OEorditemID.split("^");
     var len=orditem.length;
     var Info=""
	 for (i=0;i<len;i++)
	 {    	
  	       var GetGlobalFunction=document.getElementById("GetGlobalFunction").value;
  		   var value=cspRunServerMethod(GetGlobalFunction,orditem[i])
  		   Info=Info+" "+value;
	  }
	  return Info;
 }
 
 function GetOrdName(OEorditemID)
 {
	 var orditem=OEorditemID.split("^");
     var len=orditem.length;
     var Info=""
     var GetGlobalFunction=document.getElementById("GetOrdNameFunction").value;
	 var value=cspRunServerMethod(GetGlobalFunction,orditem[0]);
	 document.getElementById("OrdName").value=value
 }
 
 function GetPrintTemp(OEorditemID)
 {
	var GetPrintTempFun=document.getElementById("GetAppPrintTemp").value;
  	var value=cspRunServerMethod(GetPrintTempFun,OEorditemID)
  	var Item=value.split("^");
   	if (Item[1]!="")
  	{
	   gPrintTemp=Item[1];
	   gHtmlTemp=Item[3];
  	   //DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemp);
  	   DHCP_GetXMLConfig("XMLObject",gPrintTemp);

  	}
 }
 //Cancel Click 
 function CancelClick()
 {
	 var Ans=confirm(t['DeleteSend'])
	 if (Ans==false)
	 {
		 return;
     }
	 var OEorditemID=document.getElementById("OEorditemID").value;
     var CancelSendFunction=document.getElementById("CancelSendFunction").value;
     var value=cspRunServerMethod(CancelSendFunction,OEorditemID)
     if (value=="100")
     {
	     alert(t["StatusNotCorrect"]);
	 }
     else if (value=="0")
     {
	     alert(t["DeleteSucessFul"]);
  
     }
     else
     {
	     alert(t["DeleteFailure"]+"SQLCODE:"+value);
     }
     Refresh();
    
 }
 
 function sendclick()
 {
	  //SendXMLString(SendXMLFunctionOBJ,OeorditemID,XDate,UserID)
	var OEorditemID=document.getElementById("OEorditemID").value;
	var XDate=document.getElementById("HopeDate").value;
	var UserID=session["LOGON.USERID"];

    var Info1=GetBlobal(OEorditemID);
   	var Info2=document.getElementById("purpose").value;
   	if (Info1!=Info2)
   	{
	  var Ans=confirm(t['IsSend'])
	  if (Ans==false)
	  {
		 return;
      }
   	}

      var EpisodeID=document.getElementById("EpisodeID").value;
      var StatusDesc=document.getElementById("PatientNow").value;
      if (StatusDesc=="")
      {
	      //alert(t['NOTNULL']);
	      //return;
      }
      if (StatusDesc.length>256)
      {
	    alert("输入病人的当前情况不能大于256个字符");
	    return ;
	  }    

      var SaveFun=document.getElementById("SaveStatusFunction").value;
      var ret=cspRunServerMethod(SaveFun,OEorditemID,EpisodeID,StatusDesc)
      if (ret=="0")
      {
	      //alert(t['SaveSuccess']);
	  }
      else
      {
	      
	      alert(t['SaveFailure']);
      }
	
	///////////////////////////////////////////////////////////////
	var ret=SendXMLString(OEorditemID,XDate,UserID,gHtmlTemp);////append line
	
	
	if (ret=="0")
	{
		alert(t['SendSuccess']);
				
		printClick();
		
		//refresh orditem status 
		Refresh();
	    
	}
	else
	{
		alert(t['SendFailure']);
	}
	//////////////////////////////////////////////////////////
 }
 function Refresh()
 {
	 	var Eposide=document.getElementById("EpisodeID").value;
	    var ComponentName=document.getElementById("ComponentName").value;  //"DHCRisApplicationBill"
        var AppRowID=document.getElementById("AppRowID").value;
        var RecLocDR=document.getElementById("RecLocDR").value;
        var AppOrdListDoc=parent.frames["RisOrdItemList"].document;
        //var Selectid=AppOrdListDoc.getElementById("SelectedID").value;
        var OEorditemID=document.getElementById("OEorditemID").value;
         
        var lnk= "dhcrisappbill.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+Eposide+"&OEorditemID="+OEorditemID+"&RecLocDR="+RecLocDR+"&AppRowID="+AppRowID+"&ComponentName="+ComponentName;
        parent.location.href=lnk; 

	 
 }
 
 function SaveStatusClick()
 {
 	// SaveCurrentStatus(Oeorditemrowid,paadmdr,CurrentStatus)
	  var OEorditemID=document.getElementById("OEorditemID").value;
      var EpisodeID=document.getElementById("EpisodeID").value;
      var StatusDesc=document.getElementById("PatientNow").value;
      if (StatusDesc=="")
      {
	      alert(t['NOTNULL']);
	      return;
      }
      /*var SaveFun=document.getElementById("SaveStatusFunction").value;
      var ret=cspRunServerMethod(SaveFun,OEorditemID,EpisodeID,StatusDesc)
      if (ret=="0")
      {
	      alert(t['SaveSuccess']);
	  }
      else
      {
	      
	      alert(t['SaveFailure']);
      }
      */
	      
      //Save Status Template 
      var Desc=document.getElementById("MainDiagose").value;
  	  var SaveFun=document.getElementById("SaveStatusTemplate").value;
  	  var Status="Status";
  	  var CTLOCID=session['LOGON.CTLOCID'];
  	 
      var UserID=session['LOGON.USERID'];
  	  if (document.getElementById("PerTempl").checked)
  	  {
	  	  var UserID="";
  	  }
  	 
  	  var FieldTag="Status"
  	  
  	  //(Desc,Content,UsrID,LocID,FieldTag)
  	  var ret=cspRunServerMethod(SaveFun,Desc,StatusDesc,UserID,CTLOCID,FieldTag)
      if (ret=="0")
      {
	      alert(t['SaveSuccess']);
	  }
      else
      {
	      
	      alert(t['SaveFailure']);
      }

      //
      
  	
	 
 }
 function todayclick()
 {
	 
 }
 function printClick()
 {
	  ////////////////////////////////////////
	var PrintParam=GetPrintParam(); ////appline
	//alert(PrintParam);
	/////////////////////////////////////////////
    InvPrintNew(PrintParam,"");
   /*var  Name,RegNo,Age,Sex,HopeDate="";
   
   var Name=document.getElementById("Name").value;
   var RegNo=document.getElementById("RegNo").value;
   var Age=document.getElementById("Age").value;
   var Sex=document.getElementById("Sex").value;
   var HopeDate=document.getElementById("HopeDate").value;

   
   
   var MyPara="";
       MyPara=MyPara+"Name"+String.fromCharCode(2)+Name;
       MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+RegNo;
       MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
       MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
       MyPara=MyPara+"^HopeDate"+String.fromCharCode(2)+HopeDate;
       alert(MyPara);
   var MyList="";
   var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,PrintParam,MyList);*/
	
    
 }
 
  
 function InvPrintNew(TxtInfo,ListInfo)
 {
	var myobj=document.getElementById("ClsBillPrint");
 	var OEorditemIDvalue=document.getElementById("OEorditemID").value;
	if (gPrintTemp=="DHCRisBill_BwUltrasonic")
	{
	    var list="";
 	    for (var j=0;j<document.all.length;j++)
 	    {
 	    	if (document.all(j).type=="checkbox")
		    {
		       	var myname=document.all(j).name;
		       	var myval=DHCWebD_GetObjValue(myname);
		        if (myval==true)
		   	    {
			    	n=myname.split("_")[1];
			    	list=list+(document.getElementById('Fieldz'+n).innerText)+"^";
		   	    } 
		     }
		 }
 		 var saveUltrasonic=document.getElementById('saveUltrasonic');
	     if (saveUltrasonic)
	     {
		     var encmeth=saveUltrasonic.value;
		 }
		 else 
		 {
		     var encmeth=''
		 };
	     cspRunServerMethod(encmeth,OEorditemIDvalue,list);
 	     var flag=0;list1[0]="";list1[1]="";list1[2]="";list1[3]=""
 	     for(i=0;i<list.split("^").length;i++)
 	     {
	 	    	list1[flag]=list.split("^")[i];
	 	    	flag=flag+1;
	 	    	if(flag==4){ListInfo=ListInfo+String.fromCharCode(2)+list1[0]+"^"+list1[1]+"^"+list1[2]+"^"+list1[3];
	 	    	flag=0;
	 	    	list1[0]="";list1[1]="";list1[2]="";list1[3]="";
	 	  }
	 	    	
	 	}
	 	if (list1[0]!="")
	 	{
		 	ListInfo=ListInfo+String.fromCharCode(2)+list1[0]+"^"+list1[1]+"^"+list1[2]+"^"+list1[3]
		}
 	 }
 	 if (gPrintTemp=="DHCRisBill_CT")
 	 {
 	 	var list="";str="Content";num=0;list1="";
 	    for (var j=0;j<document.all.length;j++)
 	    {
 	       if (document.all(j).type=="text")
 	       {
 	    	   var myname=document.all(j).name;
 	    	   if(myname.search(str)==0)
 	    	   {
	 	    	   var num=myname.split("_")[1]
	 	       };
 	    	 	   
 	    	 }
 	     }
 	     for (var j=0;j<document.all.length;j++)
 	     {
 	        if (document.all(j).type=="checkbox")
		    {
		       	var myname=document.all(j).name;
		        var myval=DHCWebD_GetObjValue(myname);
		        if (myval==true)
		   	    {
			    	
			    	n=myname.split("_")[1];
			     	if(parseInt(n)< parseInt(num)){list=list+(document.getElementById('Fieldz'+n).innerText)+"^";}
			    	if(parseInt(n)> parseInt(num)){list1=list1+(document.getElementById('Fieldz'+n).innerText)+"^";}
     	   	    }
     	    }
 	      }	
 	      var savect=document.getElementById('savect');
	      if (savect) {var encmeth=savect.value;} else {var encmeth=''};
	      cspRunServerMethod(encmeth,OEorditemIDvalue,list1);
	      
 	    	var flag=0;list2[0]="";list2[1]="";list2[2]="";list2[3]=""
 	    	for(i=0;i<list1.split("^").length;i++){
	 	    	list2[flag]=list1.split("^")[i];
	 	    	flag=flag+1;
	 	    	if(flag==4){ListInfo=ListInfo+String.fromCharCode(2)+list2[0]+"^"+list2[1]+"^"+list2[2]+"^"+list2[3];
	 	    	flag=0;
	 	    	list2[0]="";list2[1]="";list2[2]="";list2[3]="";
	 	    	}
	 	    	
	 	   }
	 	   if (list2[0]!=""){ListInfo=ListInfo+String.fromCharCode(2)+list2[0]+"^"+list2[1]+"^"+list2[2]+"^"+list2[3]};
	 	   
	 	   /*var flag=0;list3[0]="";list3[1]="";list3[2]="";list3[3]=""
 	    	for(i=0;i<list1.split("^").length;i++){
	 	    	list3[flag]=list1.split("^")[i];
	 	    	flag=flag+1;
	 	    	if(flag==4){ListInfo1=ListInfo1+String.fromCharCode(2)+list3[0]+"^"+list3[1]+"^"+list3[2]+"^"+list3[3];
	 	    	flag=0;
	 	    	list3[0]="";list3[1]="";list3[2]="";list3[3]="";
	 	    	}
	 	    	
	 	   }
	 	   if (list3[0]!=""){ListInfo1=ListInfo1+String.fromCharCode(2)+list3[0]+"^"+list3[1]+"^"+list3[2]+"^"+list3[3]}*/
 	 	}
	
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	//call xml print from zhaochangzhong
 } 

 function SaveGlobalClick()
 {
	 // SaveGlobal(Oeorditemrowid, GlobalDesc)
	  var OEorditemID=document.getElementById("OEorditemID").value;
      //var EpisodeID=document.getElementById("EpisodeID").value;
      var GlobalDesc=document.getElementById("purpose").value;
       if (GlobalDesc=="")
      {
	      alert(t['NOTNULL']);
	      return;
      }
      var SaveFun=document.getElementById("SaveGlobalFunction").value;
      var ret=cspRunServerMethod(SaveFun,OEorditemID,GlobalDesc)
      if (ret=="0")
      {
	      alert(t['SaveSuccess']);
	     
	  }
      else
      {
	      alert(t['SaveFailure']);
	  }
	 
 }

function DateDemo()
{
   var d, s="";          
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();			
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;	
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getYear();	
   s = sDay + "/" + sMonth + "/" + sYear;            
   return(s); 
}
function TempClick()
{
    var locid=session['LOGON.CTLOCID'];
    var UserID=session['LOGON.USERID'];
    //var UserID=""
    
    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppTemplList"+"&UserID="+UserID+"&LocID="+locid+"&FieldTag=Status";    
    var mynewlink=open(link,"DHCRisAppTemplList","scrollbars=yes,resizable=yes,top=50,left=200,width=500,height=600");

}
function SaveClick()
{
	var OEorditemID=document.getElementById("OEorditemID").value;
	var XDate=document.getElementById("HopeDate").value;
	var UserID=session["LOGON.USERID"];
	
	
    var Info1=GetBlobal(OEorditemID);
   	var Info2=document.getElementById("purpose").value;
   	if (Info1!=Info2)
   	{
	  var Ans=confirm(t['IsSend'])
	  if (Ans==false)
	  {
		 return;
      }
   	}
    // SaveCurrentStatus(Oeorditemrowid,paadmdr,CurrentStatus)
	var EpisodeID=document.getElementById("EpisodeID").value;
    var StatusDesc=document.getElementById("PatientNow").value;
    if (StatusDesc=="")
    {
	    alert(t['NOTNULL']);
	    return;
    }
    var SaveFun=document.getElementById("SaveStatusFunction").value;
    var ret=cspRunServerMethod(SaveFun,"",EpisodeID,StatusDesc)
    if (ret=="0")
    {
	    //alert(t['SaveSuccess']);
	}
    else
    {
	    alert(t['SaveFailure']);
    }
	///////////////////////////////////////////////////////////////
	var ret=SendXMLString(OEorditemID,XDate,UserID,gHtmlTemp);////append line
	if (ret=="0")
	{
		alert(t['SaveSuccess']);
		//SaveHtmlFile(OEorditemID);
		Refresh();
	    
	}
	else
	{
		alert(t['SaveFailure']);
	}
	
}

function PrintFun(PObj,inpara,inlist){
	
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;   
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
				
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
		
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

document.body.onload = BodyLoadHandler;