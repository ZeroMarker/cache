
function InitForm()
{
	var obj=document.getElementById("cmdImportData");
	if (obj){obj.onclick=cmdImportData_Click;}
}

function cmdImportData_Click()
{
	var obj=document.getElementById("MethodGetPatBaseData");
    if (obj) {var encmeth1=obj.value} else {var encmeth1=''}
    
	var obj=document.getElementById("MethodLoadPatMrData");
    if (obj) {var encmeth2=obj.value} else {var encmeth2=''}
    	
	var PatientId=0,ret1="",ret2="",Papmi="",NameSpell="";
	
	do
	{
	    ret1=cspRunServerMethod(encmeth1,PatientId);
	    if (ret1){
		    var tmpList=ret1.split("^");
		    
		    var Papmi=tmpList[0];
		    var NameSpell=GetPinYin(tmpList[1]);
		    if (NameSpell==""){NameSpell=tmpList[1];}
		    var ret2=cspRunServerMethod(encmeth2,Papmi,NameSpell);
		    if (ret2!=="0"){
				   var objtmp=document.getElementById("txtImportResult");
				   objtmp.value=objtmp.value+ret2+String.fromCharCode(13)+String.fromCharCode(10);
				}
				PatientId=Papmi;
			}else{
				PatientId="";
			}
		
	}while(PatientId!=="")
}


InitForm();