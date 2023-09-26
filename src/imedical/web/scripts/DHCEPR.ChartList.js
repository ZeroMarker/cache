// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 29736 - AI - 18-12-2003 : File created for new Profile.


function PrintClickHandler(strPrint) {
    
	var frm=document.forms['fDHCEPR_ChartList'];
	
	if (frm) {

		if (frm.length) {
          
			var printLink = window.event.srcElement;
			for (i = 0; i < frm.length ; i++) {							

				if (printLink == frm(i).all["Print"]) {
					frm = frm(i);					
					break;
				}
			}
		}
	}
	
	
	var objUCPrint =	frm.elements("UCPrint");
	
	if (objUCPrint) {		

		var i = 1;
		var strInstances = "";
   	while (true)
   {
   		var objNeedPrint =frm.elements['NeedPrintz' + i];
			if (objNeedPrint) {
					if (objNeedPrint.checked) {			
						var objInstanceID = frm.elements['IDz' + i];
						if (objInstanceID) { 
							strInstances += objInstanceID.value + ",";
						}
					}			
			}
				
			else{
				break;				
			}			
			
			i++;
   
   }
   
   
   if (!(strInstances == "")) {
   	
   	 var strResult = strInstances.substr(0, strInstances.length - 1);	
   	
   	var PatientID
   	PatientID=document.getElementById("PatientID").value
   	var EpisodeID
   	EpisodeID=document.getElementById("EpisodeID").value
   	objUCPrint.PrintMultiple(PatientID, EpisodeID, strResult, session['LOGON.USERID'], '');
   	
   	//打印完成后刷新页面---added on 2008-07-14 by houj
    document.location.reload();
   	
   } else {
   	
   alert("请选择需要打印的条目!");	
   
  	}
  
	}
		
	
	
}

function UnSelectClickHandler()
{
	var frm=document.forms['fDHCEPR_ChartList'];		
	if (frm) {
		if (frm.length) {
			var UnSelectAllAllLink = window.event.srcElement;
			for (i = 0; i < frm.length ; i++) {							
				if (UnSelectAllAllLink == frm(i).all["UnSelectAll"]) {
					frm = frm(i);					
					break;
				}
			}
		}
	}
	
	var i = 1;
   	while (true)
   {
   		var objNeedPrint =frm.elements['NeedPrintz' + i];
			if (objNeedPrint) 
			{
			   objNeedPrint.checked=false;
			}
				
			else{
				break;				
			}			
			i++;
   }
	}

function SelectAllClickHandler() 
{
    //alert(document.body.scrollTop);
    var intscrollTop=document.body.scrollTop;
    
	var frm=document.forms['fDHCEPR_ChartList'];		
	if (frm) {
		if (frm.length) {
			var SelectAllLink = window.event.srcElement;
			for (i = 0; i < frm.length ; i++) {							
				if (SelectAllLink == frm(i).all["SelectAll"]) {
					frm = frm(i);					
					break;
				}
			}
		}
	}
	
	var i = 1;
   	while (true)
   {
   		var objNeedPrint =frm.elements['NeedPrintz' + i];
			if (objNeedPrint) 
			{
			   objNeedPrint.checked=true;
			}
				
			else{
				break;				
			}			
			i++;
   }
   //alert(intscrollTop);
   document.body.scrollTop=intscrollTop;
   //alert("after:"+document.body.scrollTop);
   
}
	


function NewClickHandler(patientid, episodeid, categoryid, categorytype, chartitemid, profileid) 
{
	var result;
	result = window.showModalDialog("dhcepr.selecttemplate.csp?categoryid=" + categoryid + "&EpisodeID=" + episodeid,null, "dialogHeight:400px;dialogWidth:325px" );
	if (result != null) {
		if (result != "") {
			var categoryid = result.split(",")[0];
			var templatename = result.split(",")[1];
			var templateid = result.split(",")[2];
			result = window.showModalDialog("dhcepr.chartlistedit.csp?PatientID=" + patientid + "&EpisodeID=" + episodeid + "&TemplateID=" + templateid + "&ChartItemID=" + chartitemid + "&ProfileID=" + profileid + "&CategoryID=" + categoryid + "&CategoryType=" + categorytype, null, "dialogHeight:768px;dialogWidth:1024px;resizable:1" );
			//if (result == "OK")
			//{
				document.location.reload();
			//}
			
							
		}
	}
}
