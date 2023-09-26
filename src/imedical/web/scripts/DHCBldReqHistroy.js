//DHCBldReqHistroy.JS
//

var SelectedRow = 0;
function BodyLoadHandler() {
   var obj=document.getElementById('btnOK');
   if (obj) obj.onclick=SelectItm;

   var obj=document.getElementById('btnCancel');
   if (obj) obj.onclick=CloseWindow;
   
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCBldReqHistroy');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;
}


function SelectItm(){
	var objHisDebtor=document.getElementById('HisDebtor');
	var Rrow=SelectedRow;
	if (Rrow<1){return 0;}
	var chl=document.getElementById("tHisNoz"+Rrow).innerText;
    if ((objHisDebtor)&&(objHisDebtor.value!="")&&(chl!="")) {
	    var rowId=objHisDebtor.value+"||"+chl;
		
		PrintSXSQD(rowId);
		/*
		var tabObj=parent.opener.document.getElementById('tDHCBldRequest');
		var rowCount=tabObj.rows.length;
		var cellCount = tabObj.rows(0).cells.length;

	    var objOrdItm=document.getElementById('GetHisOrdItm');
		if (objOrdItm) {var encmeth=objOrdItm.value} else {var encmeth=''};
		var OrdItmStr=cspRunServerMethod(encmeth,'','',rowId);
		var pOrdItm=OrdItmStr.split("~");
		for (var i=1;i<pOrdItm.length;i++){
			var newRow = tabObj.insertRow(rowCount++);  
			var tStr=pOrdItm[i]
			OrdItm=tStr.split("^")
		   	newRow.insertCell(0).innerHTML=rowCount-1;
		   	newRow.insertCell(1).innerHTML=OrdItm[1];
		   	newRow.insertCell(2).innerHTML=OrdItm[2];
		   	newRow.insertCell(3).innerHTML='<input type=textbox size=6 value='+OrdItm[3]+'>'
		   	newRow.insertCell(4).innerHTML="";
		   	newRow.insertCell(5).innerHTML='<input type=checkbox checked=true>';
		   	newRow.insertCell(6).innerHTML=OrdItm[0];
		}
		*/
    }
    return;
}



function PrintSXSQD(rowId){	
    var xlApp,obook,osheet,xlsheet,xlBook
	var patname,patno,patdw,paymode,payamt,payamtdx,temp	    	    
	var path,dep,patdep,depname,admdate,admdate1,admdate2
	var sexdesc,telph,maritaldesc,admage,address
	var cardno,workst,depcode
	var sDate,psDate;
	
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','');
	//alert(path);
	var Template=path+"DHCBldRequest.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	 
    var objOrdItm=document.getElementById('GetHisReqInfo');
	if (objOrdItm) {var encmeth=objOrdItm.value} else {var encmeth=''};
	var ReqStr=cspRunServerMethod(encmeth,'','',rowId);
	ReqInfo=ReqStr.split("\\")
	xlsheet.cells(3,2).value=parent.opener.document.getElementById('PatType').value;
	xlsheet.cells(3,9).value=document.getElementById('HisDebtor').value;

	xlsheet.cells(6,3).value=ReqInfo[1];
	xlsheet.cells(6,7).value=t[ReqInfo[2]];
	xlsheet.cells(9,2).value=parent.opener.PatName.value;
	xlsheet.cells(9,4).value=parent.opener.PatSex.value;
	xlsheet.cells(9,6).value=parent.opener.PatApanage.value;
	xlsheet.cells(10,2).value=parent.opener.PatDep.value;
	xlsheet.cells(10,6).value=parent.opener.PatBed.value;
	xlsheet.cells(11,2).value=parent.opener.PatAge1.value;
	xlsheet.cells(11,6).value=parent.opener.PatAge2.value;
	xlsheet.cells(12,2).value=parent.opener.PatCardID.value;
	xlsheet.cells(12,6).value=parent.opener.PatPeople.value;
	xlsheet.cells(13,2).value=parent.opener.PatDiagnose.value;
	xlsheet.cells(13,6).value=parent.opener.PatCountry.value;
    xlsheet.cells(14,2).value=t[ReqInfo[4]];
    xlsheet.cells(14,4).value=ReqInfo[9];
    xlsheet.cells(14,6).value=ReqInfo[8];
    //xlsheet.cells(15,2).value=t[ReqInfo[5]];
    //if (ReqInfo[6]=="Y") {var str=t["Ok"]} else {var str=t["Concel"]};
    //xlsheet.cells(15,6).value=str;
    //xlsheet.cells(16,2).value=t[ReqInfo[7]];
    
    var Intent=ReqInfo[16]
    var pStr=Intent.split(",")
    var st="";
    for (var m=1;m<pStr.length;m++){
	    if (pStr[m]!=''){st=st+t[pStr[m]]+";";}
	}
    xlsheet.cells(15,2).value=st;

    var objOrdItm=document.getElementById('GetHisOrdItm');
	if (objOrdItm) {var encmeth=objOrdItm.value} else {var encmeth=''};
	var OrdItmStr=cspRunServerMethod(encmeth,'','',rowId);
	var pOrdItm=OrdItmStr.split("~");
	for (var i=1;i<pOrdItm.length;i++){
		var tStr=pOrdItm[i]
		OrdItm=tStr.split("^")
		var	tstr="";
		tstr=OrdItm[2]+"   "+OrdItm[3];
		xlsheet.cells(16+i,2).value=tstr;
	}
	if (ReqInfo[10]=="Y") {xlsheet.cells(16,2).value=t["Ok"];} else {xlsheet.cells(16,2).value=t["Concel"];}
	if (ReqInfo[11]=="Y") {xlsheet.cells(16,6).value=t["Ok"];} else {xlsheet.cells(16,6).value=t["Concel"];}
	//if (ReqInfo[12]=="Y") {xlsheet.cells(31,3).value=t["AgreeY"];} else {xlsheet.cells(31,3).value=t["AgreeN"]}
	
	//labInfo
	xlsheet.cells(11,8).value=ReqInfo[17];
	xlsheet.cells(13,8).value=ReqInfo[18];
	//xlsheet.cells(15,8).value=ReqInfo[19];
	xlsheet.cells(15,9).value=ReqInfo[20];
	xlsheet.cells(16,9).value=ReqInfo[21];
	xlsheet.cells(17,9).value=ReqInfo[22];
	xlsheet.cells(18,9).value=ReqInfo[23];
	xlsheet.cells(19,9).value=ReqInfo[24];
	//xlsheet.cells(23,9).value=ReqInfo[25];
	xlsheet.cells(20,9).value=ReqInfo[27];
	//xlsheet.cells(25,9).value=ReqInfo[26];
	//xlsheet.cells(26,9).value=ReqInfo[28];
	//xlsheet.cells(27,9).value=ReqInfo[29];
	xlsheet.cells(21,9).value=ReqInfo[30];
	xlsheet.cells(22,9).value=ReqInfo[31];
	xlsheet.cells(23,9).value=ReqInfo[32];
	
	xlsheet.cells(34,2).value="";  //ReqInfo[13];;
	xlsheet.cells(34,8).value=ReqInfo[14];;
	
    xlApp.Visible=true;
    xlsheet.PrintPreview();
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet=null	
}



function CloseWindow(){
	window.close();
	return;
}


document.body.onload = BodyLoadHandler;
