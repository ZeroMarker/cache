// DHCCPM_RunQianComm

// ��Ǭ��ӡ
function DHCCPM_RQPrint(parameter) {
	//use window.open so we can close this window, without closing everything
	//format reportname(reportarg1=value;reportarg2=value)
	if (parameter==""){
		alert("�����뱨�����ƺͱ������");
		return;
	}
	///parameter="{"+ parameter + "}";
	var url="dhccpmrunqianprint.csp?reportName="+parameter;
	
	//url=escape(url);
	// 
	websys_createWindow(url,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
}

// ��Ǭ����
function DHCCPM_RQReport(){
	
}
