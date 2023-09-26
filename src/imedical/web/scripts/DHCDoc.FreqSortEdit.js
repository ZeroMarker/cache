document.body.onload = BodyLoadHandlerFreq;
//DHCDoc.FreqSortEdit

function BodyLoadHandlerFreq()
{   
	
	var objtbl=document.getElementById('tDHCDoc_FreqSortEdit');   
	var rows=objtbl.rows.length;   
	var lastrowindex=rows-1;
	for(var i=1;i<=lastrowindex;i++)
	{   var AdmType=document.getElementById('AdmTypez'+i);
		var Obj=document.getElementById('TPHCFRADMTypez'+i);
	 if (Obj){Obj.size=1;
		Obj.multiple=false;
		var varItem = new Option("","");
		Obj.options.add(varItem);
		var varItem = new Option("住院","I");
		Obj.options.add(varItem);
		var varItem = new Option("门诊","O");
		Obj.options.add(varItem);
		var varItem = new Option("急诊","E");
		Obj.options.add(varItem);
	
		}
	var AdmType=document.getElementById('AdmTypez'+i).value;
	if (AdmType!="") {var TPHCFRADMType=document.getElementById('TPHCFRADMTypez'+i).value=AdmType;}
	
	}
	
	
	
}

 function balance_OnChange()
{	var Obj=document.getElementById('TPHCFRADMTypez'+i);
	
	var index=Obj.options.selectedIndex
	Obj.options[index].selected = true;
	
}
 function SelectRowHandler()
 {      
     var eSrc=window.event.srcElement;
        
	var objtbl=document.getElementById('tDHCDoc_FreqSortEdit');
       
	var rows=objtbl.rows.length;
       
	var lastrowindex=rows-1;
       
	var rowObj=getRow(eSrc);
       
	var selectrow=rowObj.rowIndex;
	
	
	
	
	if (!selectrow){return;};
	var Obj=document.getElementById('Savez'+selectrow);
    if (Obj)
    {var TPHCFRRowId=document.getElementById('TPHCFRRowIdz'+selectrow).value;
     Obj.onclick=Update;
    }
     
 }
 function Update()
 {
	 var eSrc=window.event.srcElement;
	 var rowObj=getRow(eSrc);
	 var selectrow=rowObj.rowIndex;
	 var TPHCFRRowId=document.getElementById('TPHCFRRowIdz'+selectrow).value;
	 var TPHCFRMarkNO=document.getElementById('TPHCFRMarkNOz'+selectrow).value;
	 var TPHCFRADMType=document.getElementById('TPHCFRADMTypez'+selectrow).value;
	 if (TPHCFRMarkNO!=""){
	 				var Testvalue=TestNO(TPHCFRMarkNO);
					 if (Testvalue==0)
	 				{alert("请在频次序列中输入整数!");return;}
	 			var MarchTPHCFRMarkNO=MarchTPHCFRMark(TPHCFRRowId,TPHCFRMarkNO)
	 			 if (MarchTPHCFRMarkNO!=0)
	 			 {
		 		var Str=MarchTPHCFRMarkNO.split("^")
	     		 var NO=Str[0];
	     		 var PHCFRRowId=Str[1];
	     		 var PHCFRMarkNO=Str[2];
		  		var vaild = window.confirm("所附序列值与第"+NO+"行值重复,确定后"+NO+"行将置空!");
		  		if(vaild)
		  		{TPHCFRUpDate(PHCFRRowId,"",TPHCFRADMType); 
		  		var obk=document.getElementById('TPHCFRMarkNOz'+NO).innerText="";
		  		var obkk=document.getElementById('AdmTypez'+NO).value=TPHCFRADMType;
		  		
		  		
		  		}
		  		
				else{return;}
				}
	}

	TPHCFRUpDate(TPHCFRRowId,TPHCFRMarkNO,TPHCFRADMType);
	var TPHCFRADMType=document.getElementById('AdmTypez'+selectrow).value=TPHCFRADMType;
	
	//var obkk=document.getElementById('AdmTypez'+NO).innerText=TPHCFRADMType;
	 
 }	
function TestNO(TPHCFRMarkNO)
{
	
for(i=0;i<TPHCFRMarkNO.length;i++) 
{ 
	if(TPHCFRMarkNO.charAt(i)<"0"||TPHCFRMarkNO.charAt(i)>"9")
		{
		return 0;
		}
}
return 1;
}

function MarchTPHCFRMark(TPHCFRRowId,TPHCFRMarkNO)
{
	 var Obj=document.getElementById('MarchTPHCFRMarkNO');
 	 if(Obj) {var encmeth=Obj.value} else {var encmeth=''};
 	 if (encmeth!="")
 	 {
		var ReturnValue=cspRunServerMethod(encmeth,TPHCFRRowId,TPHCFRMarkNO);
		
	}
	return ReturnValue;
}
function TPHCFRUpDate(TPHCFRRowId,TPHCFRMarkNO,TPHCFRADMType)
{ 
	 var Obj=document.getElementById('UpData');
 	 if(Obj) {var encmeth=Obj.value} else {var encmeth=''};
 	 if (encmeth!="")
 	 {
		var ReturnValue=cspRunServerMethod(encmeth,TPHCFRRowId,TPHCFRMarkNO,TPHCFRADMType);
		
		if (ReturnValue==0)
		{
			alert("更新成功.");
			
		
		}
		else
		{
			alert("更新失败.");
		}
 	 }
 	else{return;}
	
	
	}


	

