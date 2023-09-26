/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.XTowItmTimeSlot.List

AUTHOR: ZF , Microsoft
DATE  : 2007-7


========================================================================= */
function btnDetailOnClick()
{
  var strControlID = window.event.srcElement.id.replace("btnDetailz", "");
  var strVolID =document.getElementById("VolIdz"+strControlID).value;
  var strUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainByEntry.List" + "&MainId="+"&VolId="+strVolID;
  window.open(strUrl, "_blank", "height=300,width=800,left=200,top=200,status=yes,toolbar=no,menubar=no,location=no"); 
}

function InitForm()
{
}


function InitEvent()
{
   var objTable = document.getElementById("tDHC_WMR_XTowItmTimeSlot_List");
   var objButton = null; 
   for(var i = 1; i < objTable.rows.length; i ++)
   {
        //objButton = document.getElementById("btnDetailz" + i);
        //objButton.onclick = btnDetailOnClick;
   }  
}

InitForm();
InitEvent();