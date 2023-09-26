
function BodyLoadHandler() 
{
	 SetColor();
}

function SetColor()
{
	var objtbl=document.getElementById('tDHCMedEpdReportList');
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++){
		var SelRowObj=document.getElementById('Statusz'+i);
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