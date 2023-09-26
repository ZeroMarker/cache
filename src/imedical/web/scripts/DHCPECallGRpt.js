/// DHCPECallGRpt.js
/// ������		xwm
/// ����ʱ��		2006.05.24
/// ����޸�ʱ��	
/// ����޸���	
/// ���			

function BodyLoadHandler() {
	var obj;
	
	obj=document.getElementById("BClose");
	if (obj) { obj.onclick=Close_click; }
	
	obj=document.getElementById("PrintReport");
	if (obj) { 
		obj.onclick=PrintReport_click; 
		obj.disabled=true; 
	}

	var Ins=iniForm();
	if (Ins) { obj.disabled=false; }
	else{ Close_click(); }
}

function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function iniForm() {
	var obj=document.getElementById("GADMDR");
	if (obj) { var iGADMDR=obj.value; }

	var Instring=trim(iGADMDR)+"^";
	var Ins=document.getElementById('GetGReportInfor');	
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	if ('Err 04'==flag) {
		//alert(("��Ч GAdm");
		alert(t['Err 04']);
		return false;
	}

	if ('Err 05'==flag) {
		//alert(("δ�ҵ�������Ϣ");
		alert(t['Err 05']);
		return false;
	}
	
	if ('Err 06'==flag) {
		//alert(("δ�ҵ�������Ϣ");
		alert(t['Err 06']);
		return false;
	}

	if ('Err 07'==flag) {
		//alert(("��Ч����״̬");
		alert(t['Err 07']);
		return false;
	}
		
 	var Date=flag.split("^");

 	//���� RowId
 	obj=document.getElementById("RowId");
	if (obj) { 
		obj.value=Date[0];
		obj.disabled=true; 
	}
	 	
	//��λ
	obj=document.getElementById("GADMDRName");
	if (obj) { 
		obj.value=Date[1];
		obj.disabled=true; 		
	}
	 	
	//��ӡ��ʽ
	obj=document.getElementById("PrintFormat");
	if (obj) { 
		obj.value=Date[2];
		obj.disabled=true; 
	}

	 //��ӡ��ʽ
	obj=document.getElementById("Status");
	if (obj) { 
		obj.value=Date[3];
		obj.disabled=true; 
		if ('δ���'==obj.value) {  
			//alert(("����δ���,���ܱ���");
			//alert(t['Err 02']); 
			//return false;
		}
	}
	
	return true;
}

function Close_click() {
	close();
}

function PrintReport_click() {
	var IsPrintView=false;
	var ISPrintTitle=false;
	var iGADMDR="";	 	
	var obj;
	
	obj=document.getElementById("GADMDR");
	if (obj) { iGADMDR=obj.value; }
	 	
	//obj=document.getElementById("cbIsPrintView");
	//if (obj.checked){ IsPrintView=true; }
	//else{ IsPrintView=false; }
	
	//obj=document.getElementById("cbPrintTitle");
	//if (obj.checked){ ISPrintTitle=true; }
	//else{ ISPrintTitle=false; }  
	obj=document.getElementById("Flag");       //add by zhouli
	if (obj) { iFlag=obj.value; }             //add by zhouli
	
	obj=document.getElementById("PreIADMStr");        //add by zhouli
	if (obj) { iPreIADMStr=obj.value; }                //add by zhouli
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
	
	var lnk=cspName+"?GID="+iGADMDR	+"&Flag="+iFlag+"&PreIADMStr="+iPreIADMStr;    //modify by zhouli
	open(lnk,"_blank",nwin);
	
	//var ReportDll = new ActiveXObject("DHCPEReportPrintDll.CPrint");
	//ReportDll.printreport(iEpisodeID,IsPrintView,1,ISPrintTitle);
	//if (IsPrintView) {}
	//else { Update_click(); }
	window.close();

}

// *****************************************************
// ����״̬���� 
function Update_click() {
	var iGADMDR=""
	var iUserUpdateDR="", iDateUpdate="",iStatus="";
	var obj;	
	
	//�һ�״̬?�˳�
	var eSrc=window.event.srcElement;
	
	if (eSrc.disabled) { return false; }
	
	//�������	
	obj=document.getElementById("GADMDR");
	if (obj) { iGADMDR=obj.value; }

	//�û�����	ȡ��ҳ�ϵ�(�Ự session )�û����� 
	iUserUpdateDR=session['LOGON.USERID'];
  	
  	//ȡ������ʱ��
  	iDateUpdate="";
  	
	obj=document.getElementById("Status");
	if (obj) { iStatus=obj.value; }

	var Instring=trim(iGADMDR)+"^"+trim(iUserUpdateDR)+"^"+trim(iDateUpdate)+"^"+iStatus;
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);

 	if ('0'==flag) {}
	else{
		//alert("Insert error.ErrNo="+flag)
		alert(t['Err 01']+flag);
	}

}
document.body.onload = BodyLoadHandler;

