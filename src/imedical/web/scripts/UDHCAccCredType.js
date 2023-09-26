//DHCOutPhWinCode
var SelectedRow = "-1";
var def,act;
var CredCodeobj;
var CredDescobj;
var CredTypeIDobj;
var CSureFlagobj;
var Activeobj;
var Baddobj;
var Bupdateobj;

function BodyLoadHandler() {
	Baddobj=document.getElementById("Badd");
	if (Baddobj) Baddobj.onclick=Badd_click;
	Bupdateobj=document.getElementById("Bupdate");
	if (Bupdateobj) Bupdateobj.onclick=Bupdate_click;
 	CredCodeobj=document.getElementById("CredCode");
 	CredDescobj=document.getElementById("CredDesc");
 	CredTypeIDobj=document.getElementById("CredTypeID");
 	CSureFlagobj=document.getElementById("CSureFlag");
 	Activeobj=document.getElementById("Active");
 	Activeobj.checked=true
 	DHCWeb_DisBtn(Bupdateobj);
 	
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCAccCredType');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (SelectedRow!=selectrow){
	var SelRowObj=document.getElementById('TCredCodez'+selectrow);
	var SelRowObj1=document.getElementById('TCredDescz'+selectrow);
	var SelRowObj2=document.getElementById('TSureFlagz'+selectrow);
	var SelRowObj3=document.getElementById('TActivez'+selectrow);
    var SelRowObj4=document.getElementById('TCredTypeIDz'+selectrow);
    var SelRowObj5=document.getElementById('TDataFromz'+selectrow);
    var SelRowObj6=document.getElementById('TDateToz'+selectrow);
    
	CredCodeobj.value=SelRowObj.innerText;
	CredDescobj.value=SelRowObj1.innerText;
	if (SelRowObj2.innerText=='Y'){CSureFlagobj.checked=true}
	else
	 {CSureFlagobj.checked=false}
	if (SelRowObj3.innerText=='Y'){Activeobj.checked=true}
	 else
	 {Activeobj.checked=false}
	
    CredTypeIDobj.value=SelRowObj4.value;
	SelectedRow = selectrow;
	DHCWeb_DisBtn(Baddobj);
	DHCC_AvailabilityBtn(Bupdateobj)
	Bupdateobj.onclick=Bupdate_click;
	
		var myobj=document.getElementById("DateFrom");
		if (myobj){
			myobj.value=SelRowObj5.innerText;
		}
		var myobj=document.getElementById("DateTo");
		if (myobj){
			myobj.value=SelRowObj6.innerText;
		}
		
	}
	else
	{
		SelectedRow="-1";
		CredCodeobj.value="";
		CredDescobj.value="";
		CredTypeIDobj.value="";
		CSureFlagobj.checked=false;
		Activeobj.checked=true;
		document.getElementById("DateFrom").value="";
		document.getElementById("DateTo").value="";
		DHCWeb_DisBtn(Bupdateobj);
		
		DHCC_AvailabilityBtn(Baddobj)
		Baddobj.onclick=Badd_click;
		}
}

function Bupdate_click()	
{
	if (CredCodeobj.value=="")
	{
		alert(t['06'])
		return;
		}
	if (CredTypeIDobj.value=="" || SelectedRow=="-1")
	{
		alert(t['05']);
		return;
		}
	DHCWeb_DisBtn(Bupdateobj);
    if (CSureFlagobj.checked){def="Y"}
    else {def="N"}
    if (Activeobj.checked){act="Y"}
    else {act="N"}
  
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	p1=CredCodeobj.value;
	p2=CredDescobj.value;
	p3=def;
	p4=act;
	p5=CredTypeIDobj.value;
	p6="";
	var myobj=document.getElementById("DateFrom");
	if (myobj){
		p6=myobj.value;
	}
	p7="";
	var myobj=document.getElementById("DateTo");
	if (myobj){
		p7=myobj.value;
	}
	
	
	var rtn=cspRunServerMethod(encmeth,p1,p2,p3,p4,p5,p6, p7);
	if (rtn=='0') {
		window.location.reload();
	}else {
		if (rtn=="DateErr"){
		  alert("开始日期不能大于结束日期.")
	    }else if (rtn=='DEF'){
		  alert("已经有默认类型不能再置默认")		
		}else if (rtn=='-316'){
		  alert(t['04'])
		}else {
		  alert(rtn+t['07']);
	    }
	    DHCC_AvailabilityBtn(Bupdateobj)
		Bupdateobj.onclick=Bupdate_click;
		return;
	}
	
	

}
function Badd_click()	
{
	if (CredCodeobj.value=="")
	{
		alert(t['06'])
		return;
		}
	DHCWeb_DisBtn(Baddobj);
    if (CSureFlagobj.checked){def="Y"}
    else {def="N"}
    if (Activeobj.checked){act="Y"}
    else {act="N"}
   
    var pid=document.getElementById('ins');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
	p1=CredCodeobj.value;
	p2=CredDescobj.value;
	p3=def;
	p4=act;
	p6="";
	var myobj=document.getElementById("DateFrom");
	if (myobj){
		p6=myobj.value;
	}
	p7="";
	var myobj=document.getElementById("DateTo");
	if (myobj){
		p7=myobj.value;
	}
	
	var rtn=cspRunServerMethod(encmeth,p1,p2,p3,p4,p6,p7);
	
	if (rtn=="DateErr")
	{
		alert("开始日期不能大于结束日期.")
		return
	}
	if (rtn=='-316')
	{
		alert(t['03'])
		DHCC_AvailabilityBtn(Baddobj)
		Baddobj.onclick=Badd_click;
		return;
		
		}
	if (rtn=='0') {
		window.location.reload();
	}
	else
	{
		alert(rtn+t['07']);
		DHCC_AvailabilityBtn(Baddobj)
		Baddobj.onclick=Badd_click;
		return;
		}

}


document.body.onload = BodyLoadHandler;
