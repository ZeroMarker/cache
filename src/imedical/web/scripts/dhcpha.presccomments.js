function BodyLoadHandler()
{	

	setDefaultDate();

	var obj=document.getElementById("save")
	if (obj) obj.onclick=save;		

		var obj=document.getElementById("saveNo")
	if (obj) obj.onclick=saveNo;
	
	//人笑纳 增加医嘱别名
	var obj=document.getElementById("Alias"); //
	if (obj) 
	{obj.onkeydown=popAlias;
	 obj.onblur=AliasCheck;
	} //
	
	//隐藏 同样处方号的选择打钩
	var tmpPrescno="0"
 	var prescNo;
	var obj=document.getElementById("t"+"DHCPHA_PRESCCOMMENTS")
	var cnt=getRowcount(obj)
 	var i;
	for (i=1;i<=cnt;i++)
 	{
			var objx=document.getElementById("Tprescno"+"z"+i);
			if (objx) prescNo=objx.innerText //.value ;
			//alert("prescNo="+i+","+prescNo)
			if( tmpPrescno==prescNo)
			{
				document.getElementById("Tprescno"+"z"+i).innerText=""
				document.getElementById("Tipno"+"z"+i).innerText=""
				document.getElementById("Tpaname"+"z"+i).innerText=""
				document.getElementById("Tpasex"+"z"+i).innerText=""
				document.getElementById("Tpaage"+"z"+i).innerText=""
				document.getElementById("Tdiagnose"+"z"+i).innerText=""
				document.getElementById("Tdoctor"+"z"+i).innerText=""
				
				document.getElementById("select"+"z"+i).style.display="none";

				tmpPrescno=prescNo
				prescNo=""
				
			}
			else
			{
				tmpPrescno=prescNo
			}
			
			/*			
			if(prescNo=="")
			{
				alert("near success!")
				//var obj=document.getElementById("select"+"z"+i);
				//obj.invisiable
				document.getElementById("select"+"z"+i).style.display="none";
			}*/
 	}
	
}


function setDefaultDate()
{
	var t=today();
	
	var obj=document.getElementById("StartDate") ;
	if (obj) {
		if(obj.value=="") obj.value=t;
	}
	
	var obj=document.getElementById("EndDate") ;
	if (obj) {
		if(obj.value=="") obj.value=t;
	}
}

function save()
{
 	if (!confirm("是否审核合格?")) {return;}
 	var exe;
 	//var oectype="";
 	//var obj=document.getElementById("tOecType");
 	//if (obj) var oectype=obj.value;
 	var obj=document.getElementById("mSetYes");
 	if (obj) exe=obj.value;
 	else exe="";
 	//var oeori;
 	var prescNo;
	var obj=document.getElementById("t"+"DHCPHA_PRESCCOMMENTS")
	var cnt=getRowcount(obj)
 	var i;
	for (i=1;i<=cnt;i++)
 	{
		var obj=document.getElementById("select"+"z"+i);
		if (obj.checked)
		{
			//var objx=document.getElementById("oeori"+"z"+i);
			//if (objx) oeori=objx.value ;
			var objx=document.getElementById("Tprescno"+"z"+i);
			if (objx) prescNo=objx.innerText //.value ;
    		var ret=cspRunServerMethod(exe,prescNo,session['LOGON.USERID'],"1","")
   		}
 	}
 	find_click();
}

function saveNo()
{
 	if (!confirm("是否审核不合格?")) {return;}
	var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.refusereason&opType=P','','dialogHeight:380px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:no')
	if (resondr=="") 
	{
		alert("错误提示:选择审核不合格原因后重试...")
		return;
	}

 	
 	
 	
 	var exe;
 	//var oectype="";
 	//var obj=document.getElementById("tOecType");
 	//if (obj) var oectype=obj.value;
 	var obj=document.getElementById("mSetYes");
 	if (obj) exe=obj.value;
 	else exe="";
 	//var oeori;
 	var prescNo;
	var obj=document.getElementById("t"+"DHCPHA_PRESCCOMMENTS")
	var cnt=getRowcount(obj)
 	var i;
	for (i=1;i<=cnt;i++)
 	{
		var obj=document.getElementById("select"+"z"+i);
		if (obj.checked)
		{
			//var objx=document.getElementById("oeori"+"z"+i);
			//if (objx) oeori=objx.value ;
			var objx=document.getElementById("Tprescno"+"z"+i);
			if (objx) prescNo=objx.innerText //.value ;
    		var ret=cspRunServerMethod(exe,prescNo,session['LOGON.USERID'],"0",resondr)
   		}
 	}
 	find_click();
}

	 function popAlias()
	 {if (window.event.keyCode==13) 
		{  //	window.event.keyCode=117;
		 // Alias_lookuphandler();
		 var alias="";
		  var obj=document.getElementById("Alias");
		  if (obj)
		   { alias=obj.value;
		     if(alias!=""){
			  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.IncItmByAlias&InciAlias="+alias		  
			  showModalDialog(lnk,window);	
		     }	   		  
   		   }
		}
	 }	
  function AliasCheck()
	 {var obj=document.getElementById("Alias");
		var obj2=document.getElementById("incirowid");
		if (obj) 
		{if (obj.value=="") obj2.value=""		}
	 }

function AliasLookupSelect(str)
{	var inci=str.split("^");
	//var obj=document.getElementById("incirowid");
	var objDesc=document.getElementById("Alias");
	//if (obj)
	{if (inci.length>0)  { 
	// alert(inci[2]);
	//obj.value=inci[2];
	objDesc.innerText=inci[0]
	} 
		else { //obj.value="" ;
		objDesc.innerText=""  }
	 }

}

document.body.onload=BodyLoadHandler;