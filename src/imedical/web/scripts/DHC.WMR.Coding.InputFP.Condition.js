
var dicVol = new ActiveXObject("Scripting.Dictionary");

function InitCondition()
{
    document.getElementById("txtMrNo").onkeydown = txtMrNoOnKeyDown;
    document.getElementById("cboVolume").onkeydown = cboVolumeOnKeyDown;
    document.getElementById("txtBarCode").onkeydown = txtBarCodeOnKeyDown;
    
    //window.parent.frames[1].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Coding.InputFP&MrType="
}

function txtBarCodeOnKeyDown()
{
    if(window.event.keyCode != 13)
        return;
    var objBarCode = null;
    try{
    	objBarCode = DHCWMRBarCode(getElementValue("txtBarCode"));
    	if(objBarCode.Type != "02")
    	{
    		window.alert(t["BarCodeError"]);
    	}
    	else
    	{
    		DisplayInfo(objBarCode.ID);
    	}   
    }
    catch(e)
    {
    	window.alert("Error:" + e.description);
    }
    window.event.returnValue = false;
}



function cboVolumeOnKeyDown()
{
    if(window.event.keyCode != 13)
        return;
    var strVolID = getElementValue("cboVolume");
    if(strVolID == "")
    	return;
    //window.parent.frames[1].document.DisplayInfo(strVolID);
    document.DisplayInfo(strVolID);
}

function txtMrNoOnKeyDown()
{
    if(window.event.keyCode != 13)
        return;
    FormatInputMrNo("MrType","txtMrNo");
    DisplayVolumeList();

}

function DisplayVolumeList()
{
   var strMrNo = "";
   /////////// add by liuxuefeng 2010-09-03 /////////
   if(LeadingFactor=="V") {
			//卷主导
			var VolNo=getElementValue("txtMrNo");	//"病案号"框录入为卷号
			strMrNo=tkMakeServerCall("web.DHCWMRVolumeQry" , "GetMrNoByVolNo" , strMrType , VolNo);
	 }else{
	 		strMrNo = getElementValue("txtMrNo");
	 }
	 ///////////////////// End ////////////////////////

   var objMain = null;
   var objArry = null;
   var objVol = null;
   var objAdm = null;
   ClearListBox("cboVolume");
   dicVol.RemoveAll();
   if(strMrNo != "")
   {
        objMain = GetDHCWMRMainByMrNo("MethodGetDHCWMRMainByMrNo", strMrType, strMrNo, "Y");
        if(objMain == null)
        {
            window.alert("未找到此病案号,请重新输入!");
            window.event.returnValue = false;
            return;
        }
        objArry = GetDHCWMRMainVolumeArryByMainID("MethodGetDHCWMRMainVolumeArryByMainID", objMain.RowID);
        for(var i = 0; i < objArry.length; i ++)
        {
            objVol = objArry[i];
            if(objVol.Paadm_Dr != "")
            {
            	objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", objVol.Paadm_Dr);
            	//****************************************************************************
            	//update by zf 20091201
            	//AddListItem("cboVolume",objAdm.VisitStatus + "     " + objAdm.AdmDate + "     " + GetDesc(objAdm.LocDesc, "/") + "     " + objAdm.DischgDate, objVol.RowID);
            	if (objAdm.VisitStatus=t["Discharge"])
            	{
            		AddListItem("cboVolume",objAdm.VisitStatus + "     " + objAdm.AdmDate + "     " + GetDesc(objAdm.LocDesc, "/") + "     " + objAdm.DischgDate, objVol.RowID);
            	}
            	//****************************************************************************
            }
            else
            {
            	objAdm = GetDHCWMRHistoryAdmByID("MethodGetDHCWMRHistoryAdmByID", objVol.HistroyAdm_Dr);
            	AddListItem("cboVolume", objAdm.AdmitDate + "    " + objAdm.DischargeDep + "     " + objAdm.DischargeDate, objVol.RowID);
            }
            objVol.Adm = objAdm;
            dicVol.Add(objVol.RowID, objVol);
         }
         document.getElementById("cboVolume").focus();
   }
}

//window.onload = Init;