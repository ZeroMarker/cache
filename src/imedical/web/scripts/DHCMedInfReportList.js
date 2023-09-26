var iSeldRow=0
function BodyLoadHandler() {
	 //iniForm();
	 SetColor();
	}
function iniForm() {
	//var objCurr=document.getElementById("cStatus");
	//if (objCurr){alert(objCurr.value)}
	//alert("cjb");	 
	}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCMedInfReportList');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
     
    //alert(selectrow+"/"+rows)
    
	if (!selectrow) return;
	//alert("iSeldRow="+iSeldRow+"   selectrow="+selectrow);
	//if (iSeldRow==selectrow){

	//	return;
	//	}
	//iSeldRow=selectrow;
	var SelRowObj
	var obj
	
	//SelRowObj=document.getElementById('MEARowidz'+selectrow);
	//if (SelRowObj){alert(SelRowObj.value)}
	
}	
function SetColor(){
	var objtbl=document.getElementById('tDHCMedInfReportList');
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++){
		var SelRowObj=document.getElementById('RepStatusDescz'+i);
		if (SelRowObj){
			var txt=SelRowObj.innerText;
			var objTD=SelRowObj.parentElement;

			if (objTD){
			    if (txt==t['Return'])  objTD.bgColor="#CF0070";
				}
			}
		}
	}


document.body.onload = BodyLoadHandler;