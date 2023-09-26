var SelectedRow = 0;
var SimilarDepDr = ""
var SimilarMarkDr = ""
var QueID = ""
function BodyLoadHandler() {
	var obj=document.getElementById("Commit");
	if (obj) obj.onclick=Commit_click;
	
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOPQueueChangeDep');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    
	if (!selectrow) return;
	
	var SimilarDepDrObj=document.getElementById('SimilarDepCodez'+selectrow);
	var QueIDObj=document.getElementById('QueueDrz'+selectrow);
	var SimilarMarkDrObj=document.getElementById('SimilarMarkCodez'+selectrow);
	
	SimilarDepDr=SimilarDepDrObj.value;	
	QueID=QueIDObj.value;
	SimilarMarkDr=SimilarMarkDrObj.value
	//alert(SimilarDepDr+","+QueID+","+SimilarMarkDr)
	

	SelectedRow = selectrow;
}
function Commit_click() {
	 if (QueID==0) {
		//«Î—°‘Ò≤°»À
	        alert(t['1'])    
		    return
		}
       
  		var GetDetail=document.getElementById('GetMethodChange');
		if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
		var RetCode=cspRunServerMethod(encmeth,SimilarDepDr,QueID,SimilarMarkDr)
		//alert(RetCode)
		if(RetCode==0){
			alert(t["Success"])
			var Parobj=window.opener
			if (Parobj) Parobj.Clearclick();
			window.close()
		}else{
			alert(t["Error"])
			return
		}
}
document.body.onload = BodyLoadHandler;