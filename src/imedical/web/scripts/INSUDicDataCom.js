//INSUDicDataCom.js
var CurrentSel=0,TypeIndex
function BodyLoadHandler() {	
	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Updat_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}
	
	var obj=document.getElementById("Type");
	if (obj){ obj.onchange=OnChange;}
	
	var obj=document.getElementById("Query");
	if (obj){ obj.onclick=Query_click;}

	iniForm();
	
}
	
function iniForm(){
	var obj=document.getElementById("Type");
	if (obj){
		obj.size=1; 
	 	obj.multiple=false;
	 	var i=0;
	 	var Ins=document.getElementById('ClassGetSys');
     	if (Ins) {var encmeth=Ins.value;} else {var encmeth='';}
     	var flag=cspRunServerMethod(encmeth,'','','SYS');
     	     	
     	var Temp1=flag.split("!");
     	for (var i=1;i<Temp1.length;i++){
			Temp2=Temp1[i].split("^");
			obj.options[i]=new Option(Temp2[3],Temp2[2]);
		}
	 	obj.options[i]=new Option("ÏµÍ³",'SYS');	 	
	 	//å¾???ref???°å??

        var svalue = window.location.search.match( new RegExp( "[\?\&]" + "Type" + "=([^\&]*)(\&?)", "i" ) ); 
        svalue=svalue?svalue[1]:svalue;

        for (var j=0;j<obj.options.length;j++)
        {
	        if (obj.options[j].value==svalue)
	        {
		        
		        obj.selectedIndex=j;
		        }
	      
	        }
	}
}

function Updat_click(){
  var id="",DicType="",DicCode="",DicDesc="",DicDemo="",DicBill1="",DicBill2=""
  var obj=document.getElementById("Rowid");
  if (obj){id=obj.value}  
  var obj=document.getElementById("Type");
  if (obj){DicType=obj.value}  
  var obj=document.getElementById("Code");
  if (obj){DicCode=obj.value}  
  var obj=document.getElementById("Desc");
  if (obj){DicDesc=obj.value}  
  var obj=document.getElementById("Demo");
  if (obj){DicDemo=obj.value}
  var obj=document.getElementById("Bill1");
  if (obj){DicBill1=obj.value}
  var obj=document.getElementById("Bill2");
  if (obj){DicBill2=obj.value}
  
  if (DicType==""||DicCode==""||DicDesc==""){
	  alert(t['mess1']);
	  return false;
  }
  var Instring=id+"^"+DicType+"^"+DicCode+"^"+DicDesc+"^"+DicBill1+"^"+DicBill2+"^"+DicDemo;  
  var Ins=document.getElementById('ClassTxtUpdate');
  if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
  var flag=cspRunServerMethod(encmeth,'','',Instring)
  
  if (flag==""){
	  
	  alert("Insert error.ErrNo="+flag);
	  
	  }
  else{
	  
	  if (flag>=0)
	  {
		  
		  }
	  else
	  {
		  if(flag==-3)
		  {
			  alert(t['mess4']);
			  }
		  else
		  {
			  alert("Insert error.ErrNo="+flag);
			  
			  }
		  }

	  }
 
  location.reload();	
}

function Delete_click(){
  var iRowid=""
  var obj=document.getElementById("Rowid");
  if (obj){iRowid=obj.value}
  if (iRowid==""){
	  
	  alert(t['mess2']);
	  return false;
	  
  } 	  
  if (confirm(t['mess3'])){
	  var Ins=document.getElementById('ClassTxtDelete');
      if (Ins) {var encmeth=Ins.value} else {var encmeth=''};     
      var flag=cspRunServerMethod(encmeth,'','',iRowid)      
      if (flag==""){
	                alert("Delete error.ErrNo="+flag);
		  }
	  else{
		  
		  if (flag>=0)
		  {
			  
			  }
		  else
		  {
			  if(flag==-3)
			  {
				  alert(t['mess4']);
				  
				  }
			  else
			  {
				  alert("Delete error.ErrNo="+flag);
				  
				  }
			  }

	  }
      location.reload();
  }
}

function  Query_click()
{
	
	var obj=document.getElementById("Type");
	if (obj)
	{
		
		var Type=obj.value;
		var TypeIndex=obj.selectedIndex;

	}
	var obj=document.getElementById("Code");
	if (obj){Code=obj.value;}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=INSUDicDataCom&Type="+Type+"&Code="+Code+"&TypeIndex="+TypeIndex;
	location.href=lnk;
	
	}

function OnChange()
{	
	obj=document.getElementById("Rowid");
	if (obj){obj.value="";}
	
	obj=document.getElementById("Code");
	if (obj){obj.value="";}
	
	obj=document.getElementById("Desc");
	if (obj){obj.value="";}
	
	obj=document.getElementById("Demo");
	if (obj){obj.value="";}
	
	obj=document.getElementById("Bill1");
	if (obj){obj.value="";}
	
	obj=document.getElementById("Bill2");
	if (obj){obj.value="";}
	
	CurrentSel=0;
	Query_click();
	return;
	
	}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUDicDataCom');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    
	if (!selectrow) return;
	var SelRowObj
	var obj	
	if (selectrow==CurrentSel){		
        obj=document.getElementById("Rowid");
        if (obj){obj.value=""}        
        obj=document.getElementById("Type");
        if (obj){obj.value=""}
        obj=document.getElementById("Code");
        if (obj){obj.value=""}
        obj=document.getElementById("Desc");
        if (obj){obj.value=""}
        obj=document.getElementById("Demo");
        if (obj){obj.value=""}
        obj=document.getElementById("Bill1");
        if (obj){obj.value=""}
        obj=document.getElementById("Bill2");
        if (obj){obj.value=""}	
	    CurrentSel=0;
	    return;
	}			
	CurrentSel=selectrow;		
	SelRowObj=document.getElementById('cidz'+selectrow);
	obj=document.getElementById("Rowid");
	obj.value=SelRowObj.value;
	SelRowObj=document.getElementById('cTypez'+selectrow);
	obj=document.getElementById("Type");
	for (var i=0;i<obj.options.length;i++){
		if (SelRowObj.innerText==obj.options[i].value){
		   obj.selectedIndex=i;
		}
	}
	
	SelRowObj=document.getElementById('cCodez'+selectrow);
	obj=document.getElementById("Code");
	obj.value=delTrim(SelRowObj.innerText);
	
	SelRowObj=document.getElementById('cDescz'+selectrow);
	obj=document.getElementById("Desc");
	obj.value=delTrim(SelRowObj.innerText);
	
	SelRowObj=document.getElementById('cDemoz'+selectrow);
	obj=document.getElementById("Demo");
	obj.value=delTrim(SelRowObj.innerText);
	
	SelRowObj=document.getElementById('cBill1z'+selectrow);
	obj=document.getElementById("Bill1");
	obj.value=delTrim(SelRowObj.innerText);
	
	SelRowObj=document.getElementById('cBill2z'+selectrow);
	obj=document.getElementById("Bill2");
	obj.value=delTrim(SelRowObj.innerText);
}


function delTrim(str)
{
	//return str.replace(/[ ]/g,""); 
	if (str==" "){str=""}
	return str

}

document.body.onload = BodyLoadHandler;