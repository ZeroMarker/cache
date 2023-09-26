var SelectedRow=0
var SelectPaymode
var papnoobj
function BodyLoadHandler() 
{    Guser=session['LOGON.USERCODE']     
     var obj=document.getElementById("rcptno")
     if (obj) obj.onkeydown=getrcpt
	 var obj=document.getElementById("user")
	 if (obj) {
		 obj.value=Guser
		 obj.readOnly=true}
     var obj=document.getElementById("amt")
     if (obj) obj.readOnly=true
     var obj=document.getElementById("update");
     obj.onclick = update_click;
     //rcptinfo()
	 //insert 2008-06-19 增加读卡功能////////////////////////////////
	var readcard=document.getElementById('readcard');
    if (readcard) readcard.onclick=readcard_click; 
    var obj=document.getElementById('OPCardType');
    if (obj){
	   obj.size=1
	   obj.multiple=false;
	   loadCardType()
	   obj.onchange=OPCardType_OnChange;
	}
    var obj=document.getElementById('opcardno');
    if (obj) obj.onkeydown = CardNoKeydownHandler;
	//////////////////////////////////////////////////////
	//insert by 2008-06-19  增加通过登记号取患者发票的功能
	papnoobj=document.getElementById("Regno")
	if (papnoobj) papnoobj.onkeydown=getpatinfo
	/////////////////////////////////////////////////////
	websys_setfocus('rcptno')
}
function SelectRowHandler()	
{   var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc)
	Objtbl=document.getElementById('tUDHCJFuppaymode');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) {  return }
	//var obj=document.getElementById('Adm');
	if (selectrow!=SelectedRow) {
	   var SelRowObj=document.getElementById('Tpaymodez'+selectrow);
	   var  mode=SelRowObj.innerText;
	   var obj=document.getElementById("paymode")
	       obj.value=mode
	   SelectPaymode=mode
	       
	   var SelRowObj=document.getElementById('Tmodeidz'+selectrow);
	   var modeid=SelRowObj.value;
	     obj=document.getElementById("modeid")
	     obj.value=modeid
	     
	   var SelRowObj=document.getElementById('Trowidz'+selectrow);
	   var rowid=SelRowObj.value;
	      obj=document.getElementById("rowid")
	      obj.value=rowid      
	   var SelRowObj=document.getElementById('Tamtz'+selectrow);
	    obj=document.getElementById('amt')
	    obj.value=SelRowObj.innerText;
	    SelectedRow=selectrow   
	}
}

function getrcpt(){
	var key=websys_getKey(e);
	if (key==13) {
		rcptinfo()	
	}
}
	
function rcptinfo(){	
        
        var rcptno=document.getElementById('rcptno').value
		if (rcptno!=""){
			p1=rcptno
			var getinfo=document.getElementById('getinfo');

			if (getinfo) {var encmeth=getinfo.value} else {var encmeth=''};
				var str=(cspRunServerMethod(encmeth,p1))
			str=str.split("^")
			document.getElementById('name').value=str[0];
			document.getElementById('fee').value=str[1];
			document.getElementById('yjamt').value=str[2];
			document.getElementById('InvprtRowid').value=str[3];
			document.getElementById('Admrowid').value=str[4];			
     }
}
function upmodeid(value){
	var str=value.split("^")
	var obj=document.getElementById("modeid")
	obj.value=str[1]
	
	
	}
function update_click(){
	
	var admobj=document.getElementById('Admrowid')
	var p1=admobj.value
	
	var getqfamountobj=document.getElementById("getqfamount");
	if (getqfamountobj)  {var encmeth=getqfamountobj.value} else {var encmeth=''};      
    qfamount=cspRunServerMethod(encmeth,p1)     
	qfamount=eval(qfamount).toFixed(2).toString(10)
	
	if (eval(qfamount)!=0.00){
	   alert(t['QF01']);
	   return;   
	}
	if (SelectPaymode==t['03']){
	   alert(t['QF02']);
	   return;
	}
	if (SelectPaymode==t['02'])
	{  
	    var DebtAmt=document.getElementById("amt").value	
	    var Rowid=document.getElementById("Trowidz"+1).value
   	    var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFUpdDebtPaymode&DebtAmt='+DebtAmt+'&Balance='+DebtAmt+'&Rowid='+Rowid
        window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=500,left=0,top=0')
	}
	else
	{
	    var retval 
	    var rcptno=document.getElementById("rcptno").value
	    var amt=document.getElementById("amt").value
	    var pmode=document.getElementById("modeid").value
	    var userid=session['LOGON.USERID']
	    var rowid=document.getElementById("rowid").value
	    var val=pmode+"^"+amt+"^"+userid
	    var update=document.getElementById('getupd');
        if (update) {var encmeth=update.value} else {var encmeth=''};      
        retval=cspRunServerMethod(encmeth,rowid,val)    
        location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFuppaymode&rcptno="+rcptno
	}
 	 
 }
function getpatinfo()
{
   var key=websys_getKey(e);
   if (key==13) {
      getpatinfo1()
   }	    
}
function getpatinfo1()
{
   var papno=papnoobj.value
   if (papno==""){
      return;
   }
   var getreginfoobj=document.getElementById('getreginfo');
   if (getreginfoobj) {var encmeth=getreginfoobj.value} else {var encmeth=''};      
   var reginfo=cspRunServerMethod(encmeth,papno)
   
   if (reginfo!=""){
      var reginfo1=reginfo.split("^");
      papnoobj.value=reginfo1[0]
      var nameobj=document.getElementById('name');
      nameobj.value=reginfo1[1]
      var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvprtInfo&Regno='+reginfo1[0]+'&name='+reginfo1[1]
      window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=850,height=500,left=50,top=100')
   }  
}
document.body.onload = BodyLoadHandler;