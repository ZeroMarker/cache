/* ======================================================================
JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1
NAME: DHC.WMR.XOneItmTimeSlot.List
AUTHOR: ZF , Microsoft
DATE  : 2007-7
========================================================================= */
function btnMainOnClick()
{
  var strID = window.event.srcElement.id.replace("btnMainz", "");
  var VolId = getElementValue("VolIdz" +strID ) ;
  var MainId = getElementValue("MainIdz" +strID ); 
  var strUrl1 = "";
  if(VolId== "")
  {
    strUrl1 = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainByEntry.List&MainId=" + MainId+"&VolId=" + VolId;
  }
  else
  {
    strUrl1 = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainByEntry.List&MainId=" + MainId+"&VolId=" + VolId;
  }
  window.open(strUrl1, "_blank", "height=300,width=800,left=200,top=200,status=yes,toolbar=no,menubar=no,location=no"); 
}

function btnStatusOnClick()
{
  var strID = window.event.srcElement.id.replace("btnStatusz", "");
  var VolId = getElementValue("VolIdz" +strID ) ;
  var MainId = getElementValue("MainIdz" +strID ); 
  var strUrl1 = "";
  if(VolId== "")
  {
    strUrl1 = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainStatus.List&MainId=" + MainId;
  }
  else
  {
    strUrl1 = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.VolStatus.List&VolId=" + VolId;
  }
  window.open(strUrl1, "_blank", "height=300,width=550,left=200,top=200,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes"); 
}

function btnDetailOnClick()
{
  var strControlID = window.event.srcElement.id.replace("btnDetailz", "");
  var Flag = getElementValue("VolIdz" +strControlID ) ;
  var StatusID = getElementValue("MainVolStaIdz" +strControlID ); 
  var strUrl = "";
  if(Flag == "")
  {
    strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainStatusDtl.List&MainStatusId=" + StatusID;
  }
  else
  {
    strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.VolStatusDtl.List&VolStaId=" + StatusID;
  }
  window.open(strUrl, "_blank", "height=300,width=550,left=200,top=200,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes"); 
}

function InitForm()
{
}


function InitEvent()
{
   var objTable = document.getElementById("tDHC_WMR_XOneItmTimeSlot_List");
   var objButton = null; 
   for(var i = 1; i < objTable.rows.length; i ++)
   {
        objButton0 = document.getElementById("btnDetailz" + i);
        objButton0.onclick = btnDetailOnClick;
        objButton1 = document.getElementById("btnStatusz" + i);
        objButton1.onclick = btnStatusOnClick;
        objButton3 = document.getElementById("btnMainz" + i);
        objButton3.onclick = btnMainOnClick;
   }
}

InitForm();
InitEvent();