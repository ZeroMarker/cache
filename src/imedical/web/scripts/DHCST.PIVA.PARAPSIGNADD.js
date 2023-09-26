/// DHCST.PIVA.PARAPSIGNADD
///

function BodyLoadHandler()
{
	SetDisabled();
	var obj=document.getElementById("bOK");
	if (obj) obj.onclick=SavePps;
	websys_sckeys['O']=SavePps;
	var obj=document.getElementById("bCancel");
	if (obj) obj.onclick=Cancel;
	websys_sckeys['C']=Cancel;
	//var obj=document.getElementById("tPhcCat");
	//if (obj) obj.onblur=PhcLostFocus;
	//if (obj) obj.onchange=PhcLostFocus;
	//var obj=document.getElementById("tPhcSubCat");
	//if (obj) obj.onblur=PhscLostFocus;
	//if (obj) obj.onchange=PhscLostFocus;
	//var obj=document.getElementById("tPhcCat");
	//if (obj) obj.onfocus=PhcOnFocus;
	//var obj=document.getElementById("tPhcSubCat");
	//if (obj) obj.onfocus=PhscOnFocus;
	var signobj=document.getElementById("tSign");
	if (signobj) signobj.onfocus=SignOnFocus;
	
	var obj=document.getElementById("Desc"); 
	if (obj) 
	{	
		obj.onkeydown=popDesc;
	 	obj.onblur=DescCheck;
	}
	//��ȡ��־,�����ַ�ͨ��csp��ַ���ݿ��ܲ��ɹ�,yunhaibao20160912
	var phcdescobj=document.getElementById("Desc");
	var obj=document.getElementById("tPPSID");
	var objinci=document.getElementById("incirowid");
	var ppsid=""
	if (obj){
		ppsid=obj.value;
	}
	var newsigninfo=tkMakeServerCall("web.DHCSTPIVAPRINTSIGN","GetSignInfo",ppsid)
	if (newsigninfo!=""){
		signobj.value=newsigninfo.split("^")[0];
		phcdescobj.value=newsigninfo.split("^")[1];
		objinci.value=newsigninfo.split("^")[2];
	}
}

function DescCheck()
{
	var obj=document.getElementById("Desc");
	var obj2=document.getElementById("incirowid");
	if (obj) 
	{if (obj.value=="") obj2.value="";	}
	
}

function popDesc()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   Desc_lookuphandler();
	}
}

function DescLookupSelect(str)
{	
	var inci=str.split("^");
	var obj=document.getElementById("incirowid");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	}

}

function SetDisabled()
{
	var pps;
	var obj=document.getElementById("tPPSID");
	if (obj) pps=obj.value;
	var obj=document.getElementById("tPhcCat");
	if (obj) obj.disabled = false;
	var obj=document.getElementById("tPhcSubCat");
	if (obj) obj.disabled = false;
	var obj=document.getElementById("Desc");
	if (obj) obj.disabled = false;
	if (pps == "") return;
	DisableFieldByID("mGetComponentID","tPhcCat");
	DisableFieldByID("mGetComponentID","tPhcSubCat");
	DisableFieldByID("mGetComponentID","Desc");
}

function Cancel()
{
	window.close();
}

function PhcLostFocus()
{
	var obj=document.getElementById("tPhcCat");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tPhcCatDr");
			if (obj) obj.value=""
			var obj=document.getElementById("tPhcSubCatDr");
			if (obj) obj.value=""
			var obj=document.getElementById("tPhcSubCat");
			if (obj) obj.value=""
		}
	}
}
function PhscLostFocus()
{
	var obj=document.getElementById("tPhcSubCat");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tPhcSubCatDr");
			if (obj) obj.value=""
		}
	}
}
function PhscOnFocus()
{
	var obj=document.getElementById("tPhcSubCat");
	if (obj) obj.select();
}
function PhcOnFocus()
{
	var obj=document.getElementById("tPhcCat");
	if (obj) obj.select()
}
function SignOnFocus()
{
	var obj=document.getElementById("tSign");
	if (obj) obj.select()
}
/// ȡҩѧ����rowid
function PhcCatLookUpSelect(str)
{
	var cat=str.split("^");
	var obj=document.getElementById("tPhcCatDr");
	if (obj)
	{
		if (cat.length>0)   obj.value=cat[1] ;
		else	obj.value="" ;  
	}
	var obj=document.getElementById("tPhcSubCatDr");
	if (obj) obj.value="";
	var obj=document.getElementById("tPhcSubCat");
	if (obj) obj.value="";
}

/// ȡҩѧ�ӷ���rowid
function PhcSubCatLookUpSelect(str)
{
	var cat=str.split("^");
	var obj=document.getElementById("tPhcSubCatDr");
	if (obj)
	{
		if (cat.length>0)   obj.value=cat[1] ;
		else	obj.value="" ;  
	}
}
function SavePps()
{
	var obj;
	var phsubcat;
	var sign;
	var ret;
	var pps;
	obj=document.getElementById("tPhcSubCatDr");
	if (obj) phsubcat =obj.value;
	
	objDesc=document.getElementById("Desc");
	if (objDesc) incidesc =trim(objDesc.value);
	var objinci=document.getElementById("incirowid");
	var inci=objinci.value;
	if ((trim(phsubcat)=="")&&(inci==""))	//�Ϸ����ж�
	{
		//alert(t['mPscEmpty']);
		
		alert("������ҩѧ�����ҩƷ���ƺ�������...");
		
		obj=document.getElementById("tPhcSubCat");
		if (obj){
			if (obj.disabled=false) obj.focus();
		}
		return;
	}
	
	obj=document.getElementById("tSign");
	if (obj) sign =obj.value;
	if (trim(sign)=="")
	{
		alert(t['mSignEmpty']);
		obj.focus();
		return;
	}
	if (sign.indexOf("^")>=0){
		alert("�����ַ����ܴ��� ^ ");
		return;
	}
	obj=document.getElementById("tPPSID");
	if (obj) pps=obj.value;
	if (pps==""){
		//�ж��Ƿ��Ѿ�����ҩѧ����
		ret=cspRunExistPps(phsubcat);
		if (ret==1)
		{
			alert(t['mPhscExist']);
			var obj=document.getElementById("tPhcSubCat");
			if (obj){
				if (obj.disabled=false) obj.focus();
			}
	    	return;
		}
	
		//��������
		ret=cspRunInsPps(phsubcat,sign,inci);
		if (ret<0) 
		{
			var retmsg=ret
			if(ret==-99997){var retmsg="��ҩѧ�����Ѿ�����"}
			if(ret==-99998){var retmsg="��ҩƷ�Ѿ�����"}
			alert("����ʧ��,"+retmsg);
	  	  	return;
		}
		alert(t['mInsPpsOk']);
		obj=document.getElementById("tPhcSubCat");
		if (obj) obj.value="";
		obj=document.getElementById("tPhcSubCatDr");
		if (obj) obj.value="";
		obj=document.getElementById("tSign")
		if (obj) obj.value=""
		obj=document.getElementById("tPhcCat");
		if (obj) obj.value="";
		obj=document.getElementById("tPhcCatDr");
		if (obj) obj.value="";
		obj=document.getElementById("Desc");
		if (obj) obj.value="";
		obj=document.getElementById("incirowid");
		if (obj) obj.value="";
		
		//location.reload();
		//location.replace(location.href)
	}
	else {
		//��������
		ret=cspRunUpdPps(pps,sign,inci);
		if (ret!=0) 
		{
			alert(t['mInsPpsErr']+ret);
	  	  	return;
		}
		alert(t['mInsPpsOk']);
		window.close();
	}
}
function cspRunInsPps(phsc,sign,inci)
{
	var obj=document.getElementById("mInsPps");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,phsc,sign,inci);
	return result;
}
function cspRunUpdPps(ppsdr,sign,inci)
{
	var obj=document.getElementById("mUpdPps");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,ppsdr,sign,inci);
	return result;
}
function cspRunExistPps(phsc)
{
	var obj=document.getElementById("mExist");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,phsc);
	return result;
}

function RefreshPar()
{
	opener.location.reload();
}
document.body.onload=BodyLoadHandler
document.body.onbeforeunload=RefreshPar
