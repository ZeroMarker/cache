//DHCRisAppOrdList.js

var LastGroupDR="";
var gStartBook=""
var bFind=0
var SelCount=0;

function BodyLoadHandler()
{
	//alert("bb");
	
	var objtbl=document.getElementById('tDHCRisAppOrdList');
	var rows=objtbl.rows.length;
    
	var OEorditemID=document.getElementById("OEorditemID").value;
	var Item=OEorditemID.split("@");
	
	var GetSelectType=document.getElementById("GetSelectType").value;
	var SelectType=cspRunServerMethod(GetSelectType);
	document.getElementById("SelectType").value=SelectType;

	var len=Item.length;
	for (i=0;i<len;i++)
	{
		var OEorditemID1=Item[i];
		for (j=1;j<rows;j++)
		{
		 	var CurrOeorditemRowid=document.getElementById("OEordRowIDz"+j).innerText;
		 	var selectedobj=document.getElementById("Selectedz"+j);
		 	
		 	if (CurrOeorditemRowid==OEorditemID1)
		 	{
		    	selectedobj.checked=1; 
	     	}
	     	
	     	var PatientStatusCode=document.getElementById("PatientStatusCodez"+j).value;
	     	if(PatientStatusCode=="RJ")
	     	{
		     	objtbl.rows[j].style.backgroundColor="#99CCFF" //"#FF99FF";
		    }
		 }
		 
	 }
/*	var QueryFeeObj=document.getElementById("Find");
	if (QueryFeeObj)
	{
		QueryFeeObj.onclick=Find_click1;
	}
*/	
	
}
function SelectRowHandler()
{
	var SelectedOrdRowid="",TotalSelectedOrdRowid="",SelectedStatus=""
	var CurrOeorditemRowid="",SelectAppType="",CurRecLocDR="",AppRowid="",GetAppRowid=""
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisAppOrdList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var selectedobj=document.getElementById("Selectedz"+selectrow);
	var SelectType=document.getElementById("SelectType").value;
	SelectedStatus=document.getElementById("Statusz"+selectrow).innerText;
	
    if (SelectType=="2")
    {
	    // more select record
		if (selectedobj.checked)
		{
			SelectedOrdRowid=document.getElementById("OEordRowIDz"+selectrow).innerText;
			TotalSelectedOrdRowid=SelectedOrdRowid;
			SelectAppType=document.getElementById("AppTypez"+selectrow).innerText;
			CurRecLocDR=document.getElementById("RecLocDRz"+selectrow).innerText;
			AppRowid=document.getElementById("RRowidz"+selectrow).innerText;
			CurSGroupDR=document.getElementById("ServiceIDz"+selectrow).value;
			var AppMethodObj=document.getElementById("AppMethodz"+i)
	        var AppMethod=""
    		if (AppMethodObj)
    		{
	    		AppMethod=document.getElementById("AppMethodz"+selectrow).innerText;
	    	}
			
			if (bFind==0)
			{
				var LocBookSetFunction=document.getElementById("LocBookSetFun").value;
	                gStartBook=cspRunServerMethod(LocBookSetFunction,CurRecLocDR);
	                bFind=1   
			}
	
	       
	  		for (i=1;i<rows;i++)
			{
	    		var selectedobj1=document.getElementById("Selectedz"+i);
	    		var SelectedStatus1=document.getElementById("Statusz"+i).innerText;
	    		var SelectedOrdRowid1=document.getElementById("OEordRowIDz"+i).innerText;
	    		var AppType=document.getElementById("AppTypez"+i).innerText; 
	    		//var SelectedStatus1=document.getElementById("Statusz"+i).innerText;
	    		var GetAppRowid=document.getElementById("RRowidz"+i).innerText;
	    		var GetRecLocDR=document.getElementById("RecLocDRz"+i).innerText;
	    		var SGroupDR=document.getElementById("ServiceIDz"+i).value;
	    		
                
                
		    	// Is Same Application Bill
				if ((SelectAppType==AppType)&&(AppRowid==GetAppRowid)&&(CurRecLocDR==GetRecLocDR))
				{
					if (gStartBook=="Y")
					{
					   if((CurSGroupDR==SGroupDR)&&(AppMethod=="自动预约"))
					   {
						    //alert(AppMethod);
				            selectedobj1.checked=true;
						    if (selectrow!=i)
						    {
							   TotalSelectedOrdRowid=TotalSelectedOrdRowid+"@"+SelectedOrdRowid1;
						    } 
					   }
						
					}
					else
					{
					     selectedobj1.checked=true;
						 if (selectrow!=i)
						 {
							TotalSelectedOrdRowid=TotalSelectedOrdRowid+"@"+SelectedOrdRowid1;
						 } 
					}
				}
				else
				{
					selectedobj1.checked=false;
    			}
			     
			} //////////////////

		}
		else
		{
			for (i=1;i<rows;i++)
			{
	    		var selectedobj1=document.getElementById("Selectedz"+i);
	    		if (selectedobj1.checked)
				{
				     	SelectedOrdRowid=document.getElementById("OEordRowIDz"+i).innerText;
				     	if (TotalSelectedOrdRowid=="") TotalSelectedOrdRowid=SelectedOrdRowid;
				     	else TotalSelectedOrdRowid=TotalSelectedOrdRowid+"@"+SelectedOrdRowid;
					
				}
			}
		}
    }
    else
    {
	    //Single Select Record
	    if (selectedobj.checked)
		{
			TotalSelectedOrdRowid=document.getElementById("OEordRowIDz"+selectrow).innerText;
			SelectedOrdRowid=TotalSelectedOrdRowid;
			
			var CurRecLocDR=document.getElementById("RecLocDRz"+selectrow).innerText;
		    var AppMethod=document.getElementById("AppMethodz"+selectrow).innerText;
			var CurSGroupDR=document.getElementById("ServiceIDz"+selectrow).value;
			
			if (bFind==0)
		    {
				var LocBookSetFunction=document.getElementById("LocBookSetFun").value;
		            gStartBook=cspRunServerMethod(LocBookSetFunction,CurRecLocDR);
		            bFind=1   
		    }
			
			for (i=1;i<rows;i++)
			{
				var selectedobj1=document.getElementById("Selectedz"+i);
	    		if (selectrow!=i)
				{
				      selectedobj1.checked=false;  
				}
			}
			
			if ((gStartBook=="Y")&&((CurSGroupDR=="")||(AppMethod=="")))
		    {
			      var Info="您已开启预约平台,请检查项目是否正确配置服务组和预约方式!"
			      alert(Info);
			      return;
			}
		}
		else
		{
			TotalSelectedOrdRowid="";
			
		}
    }
	
	//document.getElementById("OEorditemID").value=TotalSelectedOrdRowid;
	var GetAppShapeFunction=document.getElementById("GetAppType").value;
	var AppInfo=cspRunServerMethod(GetAppShapeFunction,SelectedOrdRowid);
   	var AppItem=AppInfo.split("^");
    var CurrComponentName=AppItem[0];  //"DHCRisApplicationBill"
    var CurrComponentShapeID=AppItem[2];
    
    var Eposide=document.getElementById("EpisodeID").value;
  
    
    var ReasonLink='RejectAppReasonz'+selectrow;
	if(eSrc.id==ReasonLink)
	{
  	  if(SelectedStatus==t['RejectApp'])
  	  {
		  var EpisodeID=document.getElementById("EpisodeIDz"+selectrow).value;
		  var OEOrdItemID=document.getElementById("OEordRowIDz"+selectrow).innerText;
		  window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCRisQueryRejectReason&EpisodeID="+EpisodeID+"&OEOrdItemID="+OEOrdItemID,"","dialogwidth:800px;dialogheight:400px;status:no;center:1;resizable:yes");
		  return false;
  	  }
  	  else
  	  {
		  alert(t['NoRejApp']);
	  	  return false
  	  }
	}
	
	 	 
    var CheckSend=document.getElementById("CheckSend").checked;
   	if (CheckSend)
      CheckSend="on"
    else
      CheckSend="";
      
    var lnk= "dhcrisappbill.csp?WEBSYS.TCOMPONENT="+CurrComponentName+"&EpisodeID="+Eposide+"&OEorditemID="+TotalSelectedOrdRowid+"&RecLocDR="+CurRecLocDR+"&AppRowID="+CurrComponentShapeID+"&ComponentName="+CurrComponentName+"&CheckSend="+CheckSend+"&SelectType="+SelectType;
   	parent.parent.location.href=lnk; 
   	//window.location.reload();
 
}

function SelectRowHandler1()
{
	var SelectedStatus="",PreStatus="";
	var PreRecLocDR="",CurRecLocDR="";
	var CurrComponentName="",CurrComponentShapeID="",PreComponentShapeID="";
	var PreOeorditemRowid="",CurrOeorditemRowid="",SelectedOrdRowid="";
	
	
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisAppOrdList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var SelectAppType=document.getElementById("AppTypez"+selectrow).innerText;
  	for (i=1;i<rows;i++)
	{
	    var selectedobj=document.getElementById("Selectedz"+i);
	    SelectedStatus=document.getElementById("Statusz"+i).innerText;
	    CurrOeorditemRowid=document.getElementById("OEordRowIDz"+i).innerText;
	    //////////////////////////////////can't select more one line 
	    //////////////////////////////////
	    if (selectrow!=i)
	    {
		    selectedobj.checked=false;
	    }
	     
	    if (selectedobj.checked)
	    {
		    //can't selected different status orditem 
		    if (PreStatus=="")
		    {
			    PreStatus=SelectedStatus;
			}
			else
			{
				if (PreStatus!=SelectedStatus)
				{
					alert(t["StatusNotSame"]);
					UnCheckAllOrd();
					return;
				}
			}
	    	
	    	//can not selected different execute location 
		    CurRecLocDR=document.getElementById("RecLocDRz"+i).innerText;
		    if (PreRecLocDR=="")
		    {
			    PreRecLocDR=CurRecLocDR;
		    }
		    else
		    {
			    if (PreRecLocDR!=CurRecLocDR)
			    {
				    alert(t["LocNotSame"]);
				    UnCheckAllOrd();
				    return;
				    
			    }
		    }
		    
		    // can not selected different application type
			var GetAppShapeFunction=document.getElementById("GetAppType").value;
		    var AppInfo=cspRunServerMethod(GetAppShapeFunction,CurrOeorditemRowid);
   		    
    	    var AppItem=AppInfo.split("^");
        	CurrComponentName=AppItem[0];  //"DHCRisApplicationBill"
        	CurrComponentShapeID=AppItem[2];
        	if (PreComponentShapeID=="")
        	{
	        	PreComponentShapeID=CurrComponentShapeID;
        	}
        	else
        	{
	        	
	        	if (PreComponentShapeID!=CurrComponentShapeID)
	        	{
		        	alert(t["AppNotSame"]);
		        	UnCheckAllOrd();
		        	return;
	        	}
	        	
        	}
        
            //selected oeorditem rowid 
    		if (SelectedOrdRowid=="")
		       SelectedOrdRowid=CurrOeorditemRowid;
		    else 
		       SelectedOrdRowid=SelectedOrdRowid+"@"+CurrOeorditemRowid;
		   
		}
    
	}
	
	
	//if  Same Application 
	if ((SelectedStatus!="")&&(SelectedOrdRowid!=""))
	{
		var sameappFunction=document.getElementById("sameappFunction").value;
  		var value=cspRunServerMethod(sameappFunction,SelectedOrdRowid)
    	if (value=="0")
    	{
	    	alert(t["NotSameApplication"]);
	    	UnCheckAllOrd();
	    	return;
	    	
    	}
	}

    //if (SelectedOrdRowid!="")
    {
    	var Eposide=document.getElementById("EpisodeID").value;
      	var CheckSend=document.getElementById("CheckSend").checked;
    	if (CheckSend)
    	  CheckSend="on"
    	else
    	  CheckSend="";
    	var SelectType=document.getElementById("SelectType").value;
    	var lnk= "dhcrisappbill.csp?WEBSYS.TCOMPONENT="+CurrComponentName+"&EpisodeID="+Eposide+"&OEorditemID="+SelectedOrdRowid+"&RecLocDR="+CurRecLocDR+"&AppRowID="+CurrComponentShapeID+"&ComponentName="+CurrComponentName+"&CheckSend="+CheckSend+"&SelectType="+SelectType;
    	//alert(lnk);   	 
      	parent.location.href=lnk; 
    }
    /*else 
    {
	    document.getElementById("OEorditemID").value="";
    }
    */
    
   	 
     //var frm = document.forms["fEPRMENU"];
    //frm.EpisodeID.value=Eposide;

    //oeorditemdr=document.getElementById("OEOrdItemIDz"+selectrow).value;
	///Location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppointment&ResourceID="+"&OEOrdItemID="+oeorditemdr+"&LocID="+"&AppStDate="+"&mode=1";
}

function UnCheckAllOrd()
{
	var objtbl=document.getElementById('tDHCRisAppOrdList');

	var rows=objtbl.rows.length;
    for (j=1;j<rows;j++)
	{
		 	var CurrOeorditemRowid=document.getElementById("OEordRowIDz"+j).innerText;
		 	var selectedobj=document.getElementById("Selectedz"+j);
		 	selectedobj.checked=0; 
	}
	var Eposide=document.getElementById("EpisodeID").value;
  	var lnk= "dhcrisappbill.csp?WEBSYS.TCOMPONENT="+"&EpisodeID="+Eposide+"&OEorditemID="+"&RecLocDR="+"&AppRowID="+"&ComponentName="+"&CheckSend=";
  	parent.location.href=lnk; 
  	
       
  }

function GetSert(LastGroupDR,SGroupDR)
{
	 var c=[];
	 var a=LastGroupDR.split(",");
	 var b=SGroupDR.split(",");
     c=a.intersect(b)
     return c
}
Array.prototype.intersect = function(b) 
{   var flip = {};   
    var res = [];   
    for(var i=0; i< b.length; i++)  flip[b[i]] = i;
    for(i=0; i<this.length; i++)     
    if(flip[this[i]] != undefined) res.push(this[i]);   
    return res; 
}   
/*function Find_click1()
{
	var  UserIDOBJ=document.getElementById("UserID");
	  var CheckOBj=document.getElementById("PersonTemp");
	  alert(CheckObj);
	  
  	  if (CheckOBj.checked)
  	  {
	  	  UserIDOBJ.value=session['LOGON.USERID'];
	  	  //alert(UserIDOBJ.value);
  	  }
  	  
	return Find_click();
	
	
	
}
*/

document.body.onload = BodyLoadHandler;