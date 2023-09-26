document.body.onload=BodyLoadHandler
var selectedRow=0
function  BodyLoadHandler()
{
	var obj=document.getElementById("ADD");
	if (obj){ obj.onclick=updateClickHandler;}
	var obj=document.getElementById("UPDATE")
	if (obj){ obj.onclick=updateClickHandler;}
    var obj=document.getElementById("SSDL");
    obj.size=1;
    obj.multiple=false;
    var verstr=""
    var ssdlobj=document.getElementById("Category");
    if(ssdlobj) verstr=cspRunServerMethod(ssdlobj.value);
    var verArr1=verstr.split("!");
    for(var i=0;i<verArr1.length;i++){
		var ssdlStr=verArr1[i]
		var ssdlStrArr=ssdlStr.split("^")
		obj.options[obj.length]=new Option(ssdlStrArr[1],ssdlStrArr[0])
	}
   
    var vertxt=new Array(verArr1.length);
    
    

}
function updateClickHandler()
{
 var code,desc,active,ssdl,input
 var rowid=document.getElementById("ROWID").value;
 var codeobj=document.getElementById("CODE");
 if(codeobj){code=codeobj.value;}
 if(code=="")
 {alert("代码不能为空！")
 return;}
 var descobj=document.getElementById("DESC")
 if(descobj){desc=descobj.value;}
 if(desc=="")
 {alert("描述不能为空！")
 return;}
 var activeobj=document.getElementById("ACTIVE")
 if(activeobj){active=activeobj.checked;}
 var obj=document.getElementById("SSDL");
 if(obj){ssdl=obj.value;}
 if(ssdl=="")
 {alert("所属大类不能为空！")
 return;}
 
 var input=rowid+"^"+code+"^"+desc+"^"+active+"^"+ssdl
 var Updatemethodobj=document.getElementById("updatemethod");
 if(Updatemethodobj){var encmeth=Updatemethodobj.value;}else{var encmeth="";}
 if(encmeth!="")
 {var ret=cspRunServerMethod(encmeth,input);}
 //if(ret==100) alert("代码重复!");
 if(ret!=-1)
  {
	  alert("更新成功！")
  location.reload()
  return
  }
  else{
	  alert("更新失败！")
	  }
  	}
function SelectRowHandler()
{
	var esrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCCTAntUseReasonItem');
	var rows=objtbl.rows.length;
	var rowObj=getRow(esrc);
	var selectrow=rowObj.rowIndex;
	if(!selectrow) return;
	if (selectrow!=selectedRow)
	{
		var code=document.getElementById("CODE");
		var desc=document.getElementById("DESC");
		var Active=document.getElementById("ACTIVE");
	    var rowid=document.getElementById("ROWID");
	    var ssdl=document.getElementById("SSDL");
	    ssdl.disabled=true;
	    var IPCODE=document.getElementById('IPCODEz'+selectrow);
	    var IPDESC=document.getElementById('IPDESCz'+selectrow);
	    var IPACTIVE=document.getElementById('IPACTIVEz'+selectrow);
	    //var ssdl=document.getElementById('SSDLz'+selectrow);
	    var IPROWID=document.getElementById('TROWIDz'+selectrow);
	    var drray=IPROWID.value.split("||");
	     ssdl.value=drray[0];
	     code.value=IPCODE.innerText;
	     desc.value=IPDESC.innerText;
	    var active=IPACTIVE.innerText;
	    if(active=="是")
	    {
		    Active.checked=1;
	       }
	    else
	    {
		    Active.checked=0;
		   }
	    rowid.value=IPROWID.value;
	    selectedRow=selectrow;
	    return;
	    }
	    else
	    {
	    	var ssdl=document.getElementById("SSDL");
	    ssdl.disabled=false;
		    selectedRow=0;
	     	clearNULL();
		 }
}
function clearNULL()
{	
	var obj=document.getElementById("ROWID");
	if(obj){obj.value="";}
	var obj=document.getElementById("CODE");
	if(obj){obj.value="";}
	var obj=document.getElementById("DESC");
	if(obj){obj.value="";}
	var obj=document.getElementById("ACTIVE");
	if(obj){obj.checked=0;}
	var obj=document.getElementById("SSDL");
	if(obj){obj.value="";}
	}









	