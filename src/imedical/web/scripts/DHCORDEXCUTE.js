var row; //line no DHCORDEXCUTE
var queryTypeCode=opener.document.getElementById("vartyp").value;
function BodyLoadHandler()
{    
	var obj=document.getElementById('butexcute');
	if (obj) {obj.onclick=ok_click;}
	//var exedateobj=document.getElementById("exedate");
	var exetime=document.getElementById("exetime");
	var exedate=document.getElementById("exedate");
	//exedate.value=DateDemo()    //WKZ 071015
	//exetime.readOnly=true;   
	//exedate.readOnly=true;
	var stat=document.getElementById("ordstat");
	if (stat.options.length>0) stat.selectedIndex=0;
	//exedateobj.value=j;
}
function DateDemo(){
   var d, s="";
   d = new Date();
   s += d.getDate() + "/";
   s += (d.getMonth() + 1) + "/";
   s += d.getFullYear();
   return(s);
}
function ok_click()
{
	var obj=document.getElementById("butexcute");
	/*if (obj)
	{	obj.disabled=true;
		obj.onclick=function(){return false;}
	}*/
	var arr=new Array();
	var item=new Array();
	var updateOrdGroup=document.getElementById("UpdateOrdGroup").value;
	var userId=session['LOGON.USERID'];
	var stat=document.getElementById("ordstat");
	var index=stat.selectedIndex;
	if (index==-1){alert(t['alert:selOrdExecStat']);return false;}
	var curExecStatDesc=stat.options[index].text;
	var data=document.getElementById("txtdata").value;
	var objtbl=opener.document.getElementById('tDHCNURSEXCUTE');
	if(!objtbl) var objtbl=opener.document.getElementById('tDHCNurIPExec');
	var rowid,disposeStatCode;
	rowid="";
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var item=opener.document.getElementById("seleitemz"+i);
	   if (item.checked==true)
       {
	   	   	var arcimDesc=opener.document.getElementById("arcimDescz"+i).innerText; //ypz 070126
			if (arcimDesc.indexOf("____")>-1) continue;	
           	var oeoriId=opener.document.getElementById("oeoriIdz"+i).innerText;
           	
           	disposeStatCode=opener.document.getElementById("disposeStatCodez"+i).innerText;
           	rowid=rowid+"^"+oeoriId+"!"+disposeStatCode+"!"+i;  //rowid+"^"+basedose+"!"+oeoriId+"!"+arcicId+"!"+i;
	   }
	}
	if (rowid=="") //return;
	{
		self.close();
		return false;
	}
	data=rowid;


	arr=data.split("^");
	var OrdNote=document.getElementById("OrdNote").value;
	var not=document.getElementById("gmm").value;
	var successFlag = true;
	for (var i=1;i<arr.length;i++)
	{
		item=arr[i].split("!");
		var oeoriId=item[0];
		disposeStatCode=item[1]
		row=item[2];    
      if ((disposeStatCode!="LackOfFee")&&(disposeStatCode!="Immediate")&&(disposeStatCode!="LongNew")&&(disposeStatCode!="Temp")&&(disposeStatCode!="TempTest")&&(disposeStatCode!="Discontinue")&&(disposeStatCode!="Needless")&&(disposeStatCode!="SkinTest")&&(disposeStatCode!="SkinTestNorm")&&(disposeStatCode!="PreDiscon")&&(disposeStatCode!="LongUnnew"))
      {
          // {alert("no need to process!");return false}
      }
      else
      {
		//var ordstat=opener.document.getElementById("ordStatDescz"+row).innerText;
		if (disposeStatCode=="Discontinue")
		{
			var SetDisconOrder=document.getElementById("SetDisconOrder").value;
	       var resStr=cspRunServerMethod(SetDisconOrder,oeoriId,userId);
		}
		else
		{	var ctlocId=session["LOGON.CTLOCID"];
	        var exedate="";
	        var objExecDate= document.getElementById("exedate"); //WKZ 071015 S
	        if (!IsValidDate(document.getElementById('exedate'))){
				alert(t['alert:wrongDate'])
				return;
			}

	        if (objExecDate) exedate=objExecDate.value
        	var exetime=""
        	objExecTime=document.getElementById("exetime");
			if (!IsValidTime(document.getElementById('exetime'))){
				alert(t['alert:wrongTime'])
				return;
			}

        	if (objExecTime) {
        		exetime=objExecTime.value;
        	}
		  	var flag=1;
		  var execStatusCode="F";
		  var changeReasonDr="";
		  var skinTestFlag=""
		  //alert(skinTestFlag+"@"+oeoriId+"@"+execStatusCode+"@"+userId+"@"+ctlocId+"@"+queryTypeCode+"@"+exedate+"@"+changeReasonDr)
		  resStr=cspRunServerMethod(updateOrdGroup,skinTestFlag,oeoriId,execStatusCode,userId,ctlocId,queryTypeCode,exedate,exetime,changeReasonDr);
		  if(resStr!="0")
		  {
			  if(resStr!="-303") {
				  alert(resStr);
			  }
			  successFlag=false;
			  continue;
			  self.close();
			  opener.location.reload();
			  return false;
		
		 }
		  var OrdNote=document.getElementById("OrdNote").value;
		  var not=document.getElementById("gmm").value;
		  if (not!="")
		  {
		     resStr=cspRunServerMethod(OrdNote,oeoriId,not);
		  }
		   if (resStr=='0') {
		   }
		   else
		   {
			    alert(resStr)
			    successFlag=false;
			    continue;
		    	self.close();
		    	opener.location.reload();
				return false;
		   }
		}

	 }	
	}
	if(successFlag){
    	alert(t['alert:success']);
    	self.close();
    	opener.location.reload();
	}
}
function updaterow(ret) //refresh parent window
{
	var dispose=document.getElementById("dispose").value;
	var userCode=session["LOGON.USERNAME"];
	if (ret==0)
	{
		var obj=opener.document.getElementById("tDHCNURSEXCUTE");
		var str;
		var starr=new Array();
		var execCtcpDesc=opener.document.getElementById("execCtcpDescz"+row);
		execCtcpDesc.innerText=userCode;
		var disposeStatCode=opener.document.getElementById("disposeStatCodez"+row);
		disposeStatCode.innerText="Exec";
		var dispdesc=opener.document.getElementById("disposeStatDescz"+row);
		str=cspRunServerMethod(dispose,"Exec")
		starr=str.split("|");
		dispdesc.innerText=starr[0];
		var exdate=opener.document.getElementById("execDateTimez"+row);
		exdate.innerText=starr[1];
		var selcheck=opener.document.getElementById("seleitemz"+row);
        selcheck.checked=false;
        var eSrc=obj.rows[row];
        var RowObj=getRow(eSrc);
        RowObj.className="Exec"; //ypz
	}
	//  var eSrc=objtbl.rows[i];
	//  var RowObj=getRow(eSrc);
}
function savecatdr(str)
{
	var obj=document.getElementById('catid');
	var tem=str.split("^");
	obj.value=tem[1];
}
document.body.onload = BodyLoadHandler;
