var MrTypeID=document.getElementById("MrTypeID").value;
function initForm()
{
	var CurrNo=tkMakeServerCall("web.DHCWMRNoTypeCtl","GetCurrNoByMrType",MrTypeID);
	document.getElementById("CurrNo").value=CurrNo;
}

function initEvent()
{

	document.getElementById("cmdSave").onclick = cmdSave_click;
	document.getElementById("cmdCancel").onclick = cmdCancel_click;
}

function cmdSave_click()
{
	var NewCurrNo=document.getElementById("NewCurrNo").value;
	if (isNaN(NewCurrNo)) alert("����������!");
	var flg =tkMakeServerCall("web.DHCWMRNoTypeCtl","SetCurrNoByMrType", MrTypeID, NewCurrNo);
	if (flg<0) {
		alert("����ʧ��!�������:"+flg);
	}else {
		alert("����ɹ�!");
	}
	window.location.reload();
}

function cmdCancel_click()
{
	window.close();
	window.parent.location.reload();
}


initForm();
initEvent();