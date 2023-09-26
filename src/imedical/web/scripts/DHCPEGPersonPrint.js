 //DHCPEGPersonPrint.js
 // create by zhouli
 var SelectedRow="";
 var ComponentRows=0;
 var CurrentRow=0
 var TFORM="DHCPEGPersonPrint"
function BodyLoadHandler()
{	
	var obj

	obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_click;}
	
	obj=document.getElementById("Confirm");
	if (obj) {obj.onclick=Confirm_click;}
	
 	obj=document.getElementById('RegNo');
	if (obj) {obj.onkeydown=RegNo_keydown; }
		
    obj=document.getElementById("GADMDR");
    if (obj) { iGADMDR=obj.value};
    
    obj=document.getElementById("TeamDesc");
	if (obj) {obj.onchange=TeamDesc_Change; }

	obj=document.getElementById("SelectAll");
	if (obj) {obj.onclick=SelectAll;}  
	
	obj=document.getElementById("BDeletePerson");
	if (obj) {obj.onclick=BDeletePerson_click;}
	
	obj=document.getElementById("Save");
	if (obj) {obj.onclick=Save_click;}
	obj=document.getElementById("BPrintReport");
	if (obj) {obj.onclick=BPrintReport_click;}
	
    obj=document.getElementById("BPreView");
	if (obj){ obj.onclick =ShowPreViewWindows; }

   GetListData(iGADMDR)
   InitPage
 
}


function Save_click()
{    
	
	SavePerson("S")
	
}

function ShowPreViewWindows()
{  
  SavePerson("V")


	var IsPrintView=false;
	var ISPrintTitle=false;
	var iGADMDR="";	 	
	var obj;
	
	obj=document.getElementById("GADMDR");
	if (obj) { iGADMDR=obj.value; }

    iFlag="Part"
	
    var obj=document.getElementById("PrintData");
    if (obj){iPreIADMStr=obj.value}
	var HospCode="";
	var obj=document.getElementById("HospCode");
	if (obj) HospCode=obj.value;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
			+',left=0'
			+',top=0'
			+',width='+window.screen.availWidth
			+',height='+window.screen.availHeight
			;
	cspName='dhcpegreport.'
	if (HospCode!="") HospCode=HospCode+".";
	cspName=cspName+HospCode+"csp"
	
	var lnk=cspName+"?GID="+iGADMDR	+"&Flag="+iFlag+"&PreIADMStr="+iPreIADMStr;
	open(lnk,"_blank",nwin);
	

	window.close();


	
	}

function BPrintReport_click()
{    
	
	SavePerson("P")
	var iGADMDR="",iGADMDRName="";	
	obj=document.getElementById("GADMDR");
	if (obj){ iGADMDR=obj.value; }

	obj=document.getElementById("GADMName");
	if (obj){ iGADMDRName=obj.value; }
	
	var obj=document.getElementById("PrintData");
    if (obj){iPreIADMStr=obj.value}
	
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPECallGRpt"
			+"&GADMDR="+iGADMDR
			+"&GADMDRName="+iGADMDRName
			+"&Flag="+"Part"
			+"&PreIADMStr="+iPreIADMStr
			;
			
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=400,height=300,left=100,top=100';

	window.open(lnk,"_blank",nwin)	
	
}


function SaveSelecedData(String)
{    
     
     var encmeth=document.getElementById("SaveSelecedData");
	 var encmeth=encmeth.value
     if (encmeth!="")  
     {
	     var Return=cspRunServerMethod(encmeth,String);
         //alert(Return)
            }   
	}
	
function DeleteSelecedData(String)
{   
    var encmethDelete=document.getElementById("DeleteSelecedData");
    var encmethDelete=encmethDelete.value
    if (encmethDelete!=""){
    var rtn=cspRunServerMethod(encmethDelete,String);
		
		
		}	
	}

function GetListData(GADMDR)
{   
    var encmethGet=document.getElementById("GetData");
    var encmethGet=encmethGet.value
    if (encmethGet!=""){

    var rtn=cspRunServerMethod(encmethGet,"DHCWeb_AddToList","SelectedList",GADMDR,"");
		     
		   }     
	}
	
function TSelect_click(CurrentSel,Flag)
{    
     var eSrc=window.event.srcElement;
     var obj=document.getElementById("GADMDR")
	 if(obj){var GADMDR=obj.value}
	 //alert("1")
     if (-1<eSrc.id.indexOf('TSelect'))
      {
	
	 var obj=document.getElementById('TPreIADM'+'z'+CurrentSel);
	 if (obj){var PreIADM=obj.value}
     var obj=document.getElementById('TName'+'z'+CurrentSel);
     if (obj){var Name=obj.innerText}
     var obj=document.getElementById('TRegNo'+'z'+CurrentSel);
     if (obj){var RegNo=obj.innerText}
	 var String=GADMDR+"^"+PreIADM+"^"+Name+"^"+RegNo
	  //alert( String)
	  //alert(Flag)
	 if (Flag=="Y")
	 {SaveSelecedData(String) }
	 else {	DeleteSelecedData(String) }
     DHCWebD_ClearAllList("SelectedList")
     GetListData(GADMDR)
}
}

function SavePerson(Flag)
{   
   
	var selectedIndex=-1;
	var PreIADMStr=""
	var frm=parent.frames[0];
	var obj=frm.document.getElementById("Num");
	if(obj){var SelNum=obj.value}
	var obj=document.getElementById("GADMDR")
	if(obj){var GADMDR=obj.value}
	var obj=document.getElementById("SelectedList");
    if (obj){
	var Length=obj.options.length-1
    for (var i=Length; i>=0; i--) {
	    var PreIADM=obj.options[i].value ;
	    var PreIADMStr=PreIADMStr+"^"+PreIADM
	   
    }
    }
    var obj=document.getElementById("PrintData");
    if (obj){obj.value=PreIADMStr}
    var encmeth=document.getElementById("SaveBox");
    var encmeth=encmeth.value
    if (encmeth!=""){
    var rtn=cspRunServerMethod(encmeth,GADMDR,PreIADMStr,Flag,SelNum);
     }
}
function SelectAll() {
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var rows=tbl.rows.length;
    var obj=document.getElementById("GADMDR")
	if(obj){var GADMDR=obj.value}
	var CurrentSel=0;
	var Standards='', StandardDescs='';
	var StandardDesc='';
	var eSrc=window.event.srcElement;
    DHCWebD_ClearAllList("SelectedList")
	for (iLoop=1;iLoop<=rows-1;iLoop++) {

		CurrentSel=iLoop;
		SelRowObj=document.getElementById('TSelect'+'z'+CurrentSel);

		if (SelRowObj) { SelRowObj.checked=eSrc.checked; }
	  
		var obj=document.getElementById('TPreIADM'+'z'+CurrentSel);
	    if (obj){var PreIADM=obj.value}
        var obj=document.getElementById('TName'+'z'+CurrentSel);
        if (obj){var Name=obj.innerText}
        var obj=document.getElementById('TRegNo'+'z'+CurrentSel);
        if (obj){var RegNo=obj.innerText}
	    var String=GADMDR+"^"+PreIADM+"^"+Name+"^"+RegNo 
	    if (SelRowObj.checked==true) 
	    { 
	     SaveSelecedData(String) }
	     
	     else {DeleteSelecedData(String) }
         DHCWebD_ClearAllList("SelectedList")
         GetListData(GADMDR)
	    
     
   
		   	
   
	}

}




function Confirm_click()
{   
    var Data=GetSelectId("TPreIADM^");
	DHCWebD_ClearAllList("SelectedList");
    var obj=document.getElementById("GADMDR")
	if(obj){var GADMDR=obj.value}
    var encmeth=document.getElementById("GetData");
    var encmeth=encmeth.value
    if (encmeth!=""){
    var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToList","SelectedList",GADMDR,"");

	
	}


}


function GetSelectId(FiledName,PreIADM) 
{   
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var row=tbl.rows.length;

	var vals="";
	var val=""
	var FNames=FiledName.split('^');
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj && obj.checked) 
		 {      
	 
	           for (var iFLoop=0;iFLoop<FNames.length-1;iFLoop++){			
				obj=document.getElementById(FNames[iFLoop]+'z'+iLLoop);
				if (obj) { 
				if(obj.value==PreIADM){
				document.getElementById('TSelect'+'z'+iLLoop).checked=false}
			}
				
			}
		
			

		}
	
}
}

function GetTeamID(value){

	var temp=value.split("^")
	if(""==value){return false}
	else{
		var obj=document.getElementById('TeamID')
		 obj.value=temp[1]
	
		var obj=document.getElementById('TeamDesc')
    	 obj.value=temp[0]}
	} 


 function RegNo_keydown(e) {
	var key=websys_getKey(e);
	if (13==key) {
		var ComponentObj=document.getElementById("ComponentID");
		if (ComponentObj){var ComponentID=ComponentObj.value
		var obj=document.getElementById("ld"+ComponentID+"PatRegNo");
		if (obj) obj.click();}
	}
}	
	
function TeamDesc_Change()
{  
	var obj=document.getElementById("TeamID");
	if (obj) { obj.value=""; }
}	
	
function BFind_click()
{ 
   var iTeamID="",iRegNo="",iGADMDR=""
   var obj
    obj=document.getElementById("TeamID");
    if (obj) { iTeamID=obj.value};

	obj=document.getElementById("RegNo");
    if (obj) { iRegNo=obj.value};
    
    obj=document.getElementById("GADMDR");
    if (obj) { iGADMDR=obj.value};
    
    
    if ((iTeamID=="")&&(iRegNo=="")){
		alert(t['01']);
		return false;	}

       
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGPersonPrint"
			+"&RegNo="+iRegNo
			+"&TeamID="+iTeamID
			+"&GADMDR="+iGADMDR
   	
 
    location.href=lnk; 
    
    objChk=document.getElementById('TSelectz'+i);
		if (objChk)
		{
			objChk.disabled=false;
			objChk.onclick=Chk_Click;
		}	

}	
	
	
	
	
function BDeletePerson_click()
{ 
	var obj;
	var selectedIndex=-1;
    obj=document.getElementById("GADMDR");
    if (obj) { GADMDR=obj.value};
	obj=document.getElementById('SelectedList');
	if (obj && obj.selectedIndex!=-1) {
		selectedIndex=obj.selectedIndex;
	    var PreIADM=obj.options.value
		}

	var String=GADMDR+"^"+PreIADM
    var encmethDel=document.getElementById("DeleteBox");
    var encmeth=encmethDel.value
    if (encmeth!=""){
    var rtn=cspRunServerMethod(encmeth,String);}			
 
     DHCWebD_ClearAllList("SelectedList")
     GetListData(GADMDR)
     GetSelectId("TPreIADM^",PreIADM)
	
}

	
	




	
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var rows=tbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    if (!selectrow) return;
	//ChangeCheckStatus("TSelect");
	//ShowCurRecord(selectrow)

	SelRowObj=document.getElementById('TSelect'+'z'+selectrow);
	if (SelRowObj.checked==true){
    TSelect_click(selectrow,"Y")
            
		}
	SelRowObj=document.getElementById('TSelect'+'z'+selectrow);
	if (SelRowObj.checked==false){
    TSelect_click(selectrow,"N")
            
		}
	
}

function ShowPrintWindows() {
	
	var iPAADMDR='',iPAPMIDR="",iReportID="";
	obj=document.getElementById("PAADMDR");
	if (obj){ iPAADMDR=obj.value; }
	obj=document.getElementById("PAPMIDR");
	if (obj){ iPAPMIDR=obj.value; }	
	obj=document.getElementById("GetIReportStatus");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,iPAPMIDR,"I");
	if (flag!=0)
	{	var eSrc=window.event.srcElement;
		if (eSrc.id!="BPrintView")
		{
			if (!confirm(t[flag])) {
			return false;
			}
		}
	}
		
	obj=document.getElementById("RowId");
	if (obj){ iReportID=obj.value; }
	/*

	


	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPECallRpt"
			+"&PatientID="+iPAPMIDR
			+"&EpisodeID="+iPAADMDR
			+"&ReportID="+iReportID
			;

	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=400,height=300,left=100,top=100';
	window.open(lnk,"_blank",nwin)
	
	
	var IsPrintView=false;
	var ISPrintTitle=false;
	var iEpisodeID="";	 	
	var obj;
	var iReportName="";
	obj=document.getElementById("ReportNameBox");
	if (obj) { iReportName=obj.value; }
	
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	 	
	obj=document.getElementById("cbIsPrintView");
	if (obj.checked){ IsPrintView=true; }
	else{ IsPrintView=false; }
	
	obj=document.getElementById("cbPrintTitle");
	if (obj && obj.checked){ ISPrintTitle=true; }
	else{ ISPrintTitle=false; } */
	 
	obj=document.getElementById("ReportNameBox");
	if (obj) { var iReportName=obj.value; }
	var width=screen.width-60;
	var height=screen.height-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
	var lnk=iReportName+"?PatientID="+iPAADMDR+"&ReportID="+iReportID;
	open(lnk,"_blank",nwin);
	return true;

}
document.body.onload = BodyLoadHandler;

