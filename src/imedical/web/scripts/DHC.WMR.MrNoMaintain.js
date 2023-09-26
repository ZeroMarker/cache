var objMrType = null;

var objDicOld  = new ActiveXObject("Scripting.Dictionary");
var objDicNew  = new ActiveXObject("Scripting.Dictionary");
 
function GetPatientVolumeList(MrType, MrNo)
{
    if(Trim(getElementValue("txtOldMrNo")) == "")
        return;
    var objMain = GetDHCWMRMainByMrNo("MethodGetDHCWMRMainByMrNo", MrType, MrNo, "Y");
   if(objMain == null)
        return null;  
   var arryVolume = GetDHCWMRMainVolumeArryByMainID("MethodGetDHCWMRMainVolumeArryByMainID", objMain.RowID);
   var objVolume = null; 
   var objAdm = null; 
    for(var i = 0; i < arryVolume.length; i ++)
   {
            objVolume = arryVolume[i];
            if(objVolume.Paadm_Dr != "")
            {
                objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", objVolume.Paadm_Dr);
            }
            else
            {
                objAdm = GetPatientAdmitInfo("MethodGetDHCWMRHistoryAdm", objVolume.HistroyAdm_Dr);
            }  
            objVolume.Adm = objAdm;
   }  
}

function DisplayOldMrVolList(arryVol)
{
   var strContents = "";
   var objVolume = null;
   for (var i = 0; i < ArryVol.length; i ++)
   {
         objVolume = ArryVol[i];
   } 
}

function DisplayTargetMrVolList(arryVol)
{
}



function txtOldMrNoOnChange()
{
}

function cmdTransferOnClick()
{
}

function cmdBackOnClick()
{
}

function cmdSaveOnClick()
{
}

function cmdCancelOnClick()
{
}

function initForm()
{
    var strType = GetParam(window, "MrType");
    if( strType == "")
    {
        window.alert("Mr Type Setting is Missing!");
       return;  
     }
     objMrType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", strType);
     if(objMrType != null)
     {
        setElementValue("txtMrType", objMrType.Description);
     }
     else
     {
        window.alert("Mr Type Setting is Missing!");
       return;
     }
     document.getElementById("txtMrType").readOnly = true;
}

function initEvents()
{
	var obj=document.getElementById("txtOldMrNo");
	if (obj){
		
	}
}

initForm();
initEvents();
