        var billinvnoobj,currentinvnoobj,balanceobj,depositlistobj,depositshowobj,depositsumobj;
		var paymodeobj,bankobj,chequeobj,unitobj,accountobj,amounttopayobj;
		var Addobj,Updateobj,Deleteobj,Dischargeobj,Printobj,Abortobj,Closeobj,PrintDetailobj;
		var admobj,billnoobj,payobj
		var SelectedRow="-1",selectrow1;
		var pay,BillNo,Adm,UserLoc,Guser,GuserCode,GuserName,currinvid,Sum
	    var payflag,pbflag
	    var tmpdep="",depositsum
	    var myData1= new Array();
		var myData2 = new Array();
		var myData3 = new Array();
		var myData4 = new Array();
		var myData5 = new Array();
		var myData6 = new Array();
		var catedata = new Array();
		var path,gusercode,today
		var ryyear,rymon,ryday
		var cyyear,cymon,cyday
		var pattypeobj;
        var pattype;
        var ybaddobj;
        var PayModeList;
        var flag;
        var ybgbflag  
        var printinvno  
        var banksubobj
        var yklystr   
       
function BodyLoadHandler() {
	    Guser=session['LOGON.USERID'];
        UserLoc=session['LOGON.CTLOCID'];
        GuserCode=session["LOGON.USERCODE"];
	    GuserName=session["LOGON.USERNAME"];
		admobj=document.getElementById('Adm');
		Adm=admobj.value
		billnoobj=document.getElementById('BillNo');
		BillNo=billnoobj.value
		payobj=document.getElementById('pay');
		pay=payobj.value		
		paymodeobj=document.getElementById('paymode');
		bankobj=document.getElementById('bank');
		banksubobj=document.getElementById('banksub');
		chequeobj=document.getElementById('cheque');
		unitobj=document.getElementById('unit');
		accountobj=document.getElementById('account');
		amounttopayobj=document.getElementById('amounttopay');
		billinvnoobj=document.getElementById('billinvno');
		currentinvnoobj=document.getElementById('currentinvno');
		balanceobj=document.getElementById('balance');
		Addobj=document.getElementById('Add');
		Updateobj=document.getElementById('Update');
		Deleteobj=document.getElementById('Delete');
		Dischargeobj=document.getElementById('Discharge');
		Printobj=document.getElementById('Print');
		Abortobj=document.getElementById('Abort');
		Closeobj=document.getElementById('Close');
		PrintDetailobj=document.getElementById('PrintDetail');
		var payamountobj=document.getElementById('payamount');
		
		depositshowobj=document.getElementById('depositshow');
		depositsumobj=document.getElementById('depositsum');
		alldeposit=depositsumobj.value
		depositshowobj.onclick=depositshow
		depositlistobj=document.getElementById('depositlist');
		//depositlistobj.style.width="0"
		depositlistobj.style.visibility ='hidden'
		//depositlistobj.onclick=list_click;
		depositlistobj.onchange=list_change;
		depositlistobj.className="RowEven"
		//depositlistobj.className="RowOdd"
		
		Addobj.onclick=Add_click;
		Deleteobj.onclick=Delete_click;
		Updateobj.onclick=Update_click;
		Dischargeobj.onclick=Discharge_click;
		Printobj.onclick=Print_click;
		Abortobj.onclick=Abort_click;
		Closeobj.onclick=Close_click;
		payamountobj.onkeyup=change;
		document.body.onunload = BodyunLoadHandler;
    	PrintDetailobj.onclick=LinkBillDetail;
    	//paymodeobj.readOnly=true;    yyx
    	paymodeobj.onclick=paymode_click
    	bankobj.readOnly=true;
		payflag=getpbstatus();
		if (payflag!="B") {billinvnoobj.value=window.opener.Tinvno}
		depositsum=depositsumobj.value
	    listselected();
		getpath();
		gettoday();
		pay=balanceobj.value
		amounttopayobj.value=pay
	    if (pay<0)
	    { 
		 amounttopayobj.style.color="red"
	    }
	    prtsjobj=document.getElementById('printreceipt');
		prtsjobj.onclick=printrcpt_click

		currentinvnoobj.readOnly=true;
		billinvnoobj.readOnly=true;
		balanceobj.readOnly=true;
		depositsumobj.readOnly=true;
		paymodeobj.value=t['21']
		
		if (!getcurrentinvno()){alert(t['01'])}
		//insert by cx 2006.05.23
		pattypeobj=document.getElementById('pattype');
		pattype=pattypeobj.value
		
		getpatinfo()

		if (pattype==t['INSUPatType']||pattype==t['INSUPatType02']||pattype==t['INSUPatType03']||pattype==t['INSUPatType04']||pattype==t['INSUPatType05']||pattype==t['INSUPatType06']||pattype==t['INSUPatType07']){

			ybadd(pattype);			
			
			if (flag<0){
				alert(t['INSUER02']);
				Addobj.disabled=true;
				balanceobj.disabled=true;
		        Updateobj.disabled=true;
		        Deleteobj.disabled=true;
		        Dischargeobj.disabled=true;
		        Printobj.disabled=true;
		        Abortobj.disabled=true;
				return;
				}
		  } 
        //getpatinfo()
		
		DHCWebD_SetStatusTip();  //insert by cx 2007.04.17		
		printzplyobj=document.getElementById('printzply');		
		printzplyobj.onclick=Printykly		
		websys_setfocus('amounttopay');
         //patient info
       
}
function getpatinfo()
{	  
       var infro=document.getElementById('getpatinfo');
		if (infro) {var encmeth=infro.value}else {var encmeth=''};
		var returnvalue=cspRunServerMethod(encmeth,"","",Adm)
		
		var sub = returnvalue.split("^")
		document.getElementById('papno').value=sub[7]
        document.getElementById('name').value=sub[0]
        document.getElementById('admdate').value=sub[1]
        document.getElementById('disdate').value=sub[12]
        document.getElementById('patward').value=sub[3]                
        document.getElementById('patzyno').value=sub[10]
       //document.getElementById('foreignid').value=sub[6]
      //document.getElementById('foreignphone').value=sub[7]      
}

function gettoday() {
	var gettoday=document.getElementById('gettoday');
	if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'setdate_val','','')=='1'){
				};
	}
function setdate_val(value)
	{
		today=value;
		}
function listselected()
{
	var num=depositlistobj.options.length
	
	for (i=0;i<num;i++){
		depositlistobj.options[i].selected=true;
		}
	}

function list_click()
{
	var row=depositlistobj.selectedIndex
	var selItem=obj.options[depositlistobj.selectedIndex];
	
	}
function list_change()
{
	if (payflag=="P") {return;}
	var Objtbl=document.getElementById('tUDHCJFPAY');
	var Rows=Objtbl.rows.length;
	if (Rows>2) {return;}
	var num=depositlistobj.options.length
	var depamt=0,tmpamt=0
	tmpdep=""
	for (i=0;i<num;i++){
		if (depositlistobj.options[i].selected==true)
		{
			var mydata = new Array();
			var str=depositlistobj.options[i].value
			mydata=str.split("^")
			tmpdep=tmpdep+"^"+mydata[3]
			depamt=eval(depamt)+eval(mydata[0])
			}		
		}
	depositsumobj.value=depamt.toFixed(2)
	tmpamt=eval(depositsum)-eval(depamt)
	pay=eval(tmpamt)+eval(payobj.value)
	pay=pay.toFixed(2)
	balanceobj.value=pay
	
	amounttopayobj.value=balanceobj.value
	//alert(tmpdep)
	}
function depositshow()
	{//var obj=document.getElementById('depositlist');
//	var selItem=obj.options[obj.selectedIndex];
//	selItem.className="RowOdd"
	var Objtbl=document.getElementById('tUDHCJFPAY');
	var Rows=Objtbl.rows.length;
	if (Rows>2) {alert(t['02']);return;}
	if (depositshowobj.checked==false)
	{
	depositlistobj.style.visibility ='hidden'
	}
	else
	{
	depositlistobj.style.visibility ='visible'
	}
		}
function Add_click()
{
	 if (payflag=="P") {alert(t['03']);return;}
	 if (currentinvnoobj.value==""){alert(t['11']);return;}
	 if (depositshowobj.checked==true) {alert(t['04']);return;}
	 if (balanceobj.value==0||amounttopayobj.value==0||amounttopayobj.value==""||paymodeobj.value=="") return false;
        var fban,fpay
        fban=Math.abs(balanceobj.value);
        fpay=Math.abs(amounttopayobj.value);
        //if (fban<fpay) return false;   yyx
        if (SelectedRow>=0) return false;
		Addtabrow();
		var tmpamt=eval(balanceobj.value)-eval(amounttopayobj.value);  //*
		amounttopayobj.value=tmpamt.toFixed(2);    //*
		balanceobj.value=amounttopayobj.value;
	}
function Addtabrow()
	{
		var objtbl=document.getElementById('tUDHCJFPAY');
		tAddRow(objtbl);
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
		var Row=LastRow
	
		var Tpaymode=document.getElementById("Tpaymodez"+Row);
		var Tbank=document.getElementById("Tbankz"+Row);
		var Tcheque=document.getElementById("Tchequez"+Row);
		var Tunit=document.getElementById("Tunitz"+Row);
		var Taccount=document.getElementById("Taccountz"+Row);
		var Tamounttopay=document.getElementById("Tamounttopayz"+Row);
		var Tbanksub=document.getElementById("Tbanksubz"+Row);
		Tpaymode.innerText=paymodeobj.value;
		Tbank.innerText=bankobj.value;
		Tcheque.innerText=chequeobj.value;
		Tunit.innerText=unitobj.value;
		Taccount.innerText=accountobj.value
		Tamounttopay.innerText=amounttopayobj.value
		Tbanksub.innerText=banksubobj.value
		bankobj.value="";
		chequeobj.value="";
		unitobj.value="";
		accountobj.value="";
		banksubobj.value="";
		}
function tAddRow(objtbl) {
	tk_ResetRowItemst(objtbl);
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	
	//
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowOdd";} else {objnewrow.className="RowEven";}}
}
function Delete_click()
{
	var objtbl=document.getElementById('tUDHCJFPAY');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	if (SelectedRow=="-1") return;
	//if (!selectrow) return;
	if (lastrowindex==SelectedRow) return;
	var selectrow0=eval(SelectedRow)+1
	//insert by cx 2006.5.26/////////////////////////////////////////////////
	var SelRowObj=document.getElementById('Tpaymodez'+selectrow0);
	var pmname=SelRowObj.innerText;
	if (pmname==t['INSUPM05']){
		alert(t['INSUER03']);
		return;}
    if (pmname==t['INSUPM06']){
		alert(t['INSUER03']);
		return;}
	if (pmname==t['INSUPM07']){
		alert(t['INSUER03']);
		return;}
	if (pmname==t['INSUPM08']){
		alert(t['INSUER03']);
		return;}
	///////////////////////////////////////////////////////////////////////
	var SelRowObj=document.getElementById('Tamounttopayz'+selectrow0);
	var tmpamt=eval(balanceobj.value)+eval(SelRowObj.innerText);
    balanceobj.value=tmpamt.toFixed(2)
	objtbl.deleteRow(SelectedRow);
	tk_ResetRowItemst(objtbl);
	unselected();
	}
function tk_ResetRowItemst(objtbl) {
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+":"+j+":"+rowitems[j].id);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split("z");
				//if (arrId[arrId.length-1]==i+1) break; //break out of j loop
				arrId[arrId.length-1]=i+1;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			}
		}
	}
}
function Update_click()
{
	var objtbl=document.getElementById('tUDHCJFPAY');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	if (lastrowindex==SelectedRow) return;
	if (SelectedRow=="-1") return;
	var selectrow=eval(SelectedRow)+1
    var SelRowObj=document.getElementById('Tamounttopayz'+selectrow);
    var amtabs=Math.abs(amounttopayobj.value)
    var selrowabs=Math.abs(SelRowObj.innerText)
    var banabs=Math.abs(balanceobj.value)
	if (eval(amtabs)-eval(selrowabs)>banabs) return false; 
		var tmpamt=eval(balanceobj.value)+eval(SelRowObj.innerText)-eval(amounttopayobj.value);
		balanceobj.value=tmpamt.toFixed(2)
	SelRowObj=document.getElementById('Tpaymodez'+selectrow);
	SelRowObj.innerText=paymodeobj.value;
	SelRowObj=document.getElementById('Tbankz'+selectrow);
	SelRowObj.innerText=bankobj.value;
	SelRowObj=document.getElementById('Tchequez'+selectrow);
	SelRowObj.innerText=chequeobj.value;
	SelRowObj=document.getElementById('Tunitz'+selectrow);
	SelRowObj.innerText=unitobj.value;
	SelRowObj=document.getElementById('Taccountz'+selectrow);
	SelRowObj.innerText=accountobj.value;
	SelRowObj=document.getElementById('Tamounttopayz'+selectrow);
	SelRowObj.innerText=amounttopayobj.value;	
	}
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCJFPAY');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var RowObj=getRow(eSrc);
	var selectrow=RowObj.rowIndex;
	if (lastrowindex==selectrow){unselected();return;}
	if (selectrow!=SelectedRow) {
	var selectrow0=eval(selectrow)+1
	var SelRowObj=document.getElementById('Tpaymodez'+selectrow0);
	paymodeobj.value=SelRowObj.innerText;
	SelRowObj=document.getElementById('Tbankz'+selectrow0);
	bankobj.value=SelRowObj.innerText
	SelRowObj=document.getElementById('Tchequez'+selectrow0);
	chequeobj.value=SelRowObj.innerText
	SelRowObj=document.getElementById('Tunitz'+selectrow0);
	unitobj.value=SelRowObj.innerText
	SelRowObj=document.getElementById('Taccountz'+selectrow0);
	accountobj.value=SelRowObj.innerText;
	SelRowObj=document.getElementById('Tamounttopayz'+selectrow0);
	amounttopayobj.value=SelRowObj.innerText;
	//alert(selectrow0)
	//alert(SelRowObj.innerText)
	SelectedRow = selectrow;
	}
	else
	{
		unselected();
		}
}
function unselected()
{
	paymodeobj.value=t['21'];
		bankobj.value="";
		chequeobj.value="";
		unitobj.value="";
		accountobj.value="";
		amounttopayobj.value=balanceobj.value;
		SelectedRow="-1";
	
	}
function Discharge_click()
{  
	if (payflag=="P") {alert(t['05']);return;}
	if (currentinvnoobj.value==""){alert(t['11']);return;}
	var pbflag=getpbstatus();
	if (pbflag!="B"){alert(t['05']);return;}
	if (balanceobj.value!="0.00") {alert(t['06']);return;}
	var tmpstr=GetSum();
	//update by cx 2006.05.26
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	var computername=WshNetwork.ComputerName;
	if (depositsum!=depositsumobj.value)
	 {  var selecttrue=window.confirm(t['jst03'])
	    if (!selecttrue)
	    {   return  }
	    var depflag="0"
	   }
	 else
	 {var depflag="1"
	 tmpdep=""}
	//yyx
	 var count=0
	 var qfstr=tmpstr.split("&")
	 for (i=2;i<qfstr.length;i++)
	 {     
		 var qf=qfstr[i].split("^")
		 if (qf[0]==t['jst02']) { count=count+1 }
	 }
	if (count>=1)
	{var truthBeTold = window.confirm(t['jst01']);
     if (!truthBeTold) {return  }
    } 
    //yyx2007-03-09
	p1=BillNo+"&"+Guser+"&"+UserLoc+"&"+tmpdep+"&"+depflag+"&"+pay+"&"+Adm+"&"+computername
	p2=tmpstr
	var getpaybillobj=document.getElementById('getpaybill');
			if (getpaybillobj) {var encmeth=getpaybillobj.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,'','',p1,p2)
			if (ren>0)
	{ 
        payflag="P"        
        if (pattype==t['INSUPatType']){ybgbflag="0" }  
        alert(t['08']);       
      
       }
     else
     {
		    alert(t['09']);
		    return false;
		    }
    var truthBeTold = window.confirm(t['jst07']);
    if (!truthBeTold) {return  }
    Print_click()
	}
function getpbstatus() {	   
		    p1=BillNo
			var getpbstatusobj=document.getElementById('getpbstatus');
			if (getpbstatusobj) {var encmeth=getpbstatusobj.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,'','',p1)
			return ren;
	}
function GetSum()
{   
	var tempstr1,tempstr=""
	var payamt
	Sum=0;
    Objtbl=document.getElementById('tUDHCJFPAY');
	Rows=Objtbl.rows.length-1;
    
	for (i=2;i<=Rows;i++)
	{	   
	   	var Tpaymode=document.getElementById("Tpaymodez"+i);
	
		var Tbank=document.getElementById("Tbankz"+i);
		var Tbanksub=document.getElementById("Tbanksubz"+i);
		var Tcheque=document.getElementById("Tchequez"+i);
		var Tunit=document.getElementById("Tunitz"+i);
		var Taccount=document.getElementById("Taccountz"+i);
		
		var Tamounttopay=document.getElementById("Tamounttopayz"+i);

	   payamt=Tamounttopay.innerText;
	  
	   Sum=eval(Sum)+eval(payamt);
	   tempstr1=Tpaymode.innerText+"^"+Tbank.innerText+"@"+Tbanksub.innerText+"^"+Tcheque.innerText+"^"+Tunit.innerText+"^"+Taccount.innerText+"^"+Tamounttopay.innerText
	   tempstr=tempstr+"&"+tempstr1;
	   
	}
	Sum=Sum.toFixed(2)
	tempstr="&"+pay+tempstr;
	return tempstr;
}
function Print_click()
{   var getyklyobj 
    if (payflag!="P") {alert(t['10']);return;}
	if (currentinvnoobj.value==""){alert(t['11']);return;}
	pbflag=getpbflag();
	if (pbflag=="Y"){alert(t['12']);return;}
			//////////////////
			p1=currentinvnoobj.value+"^"+Guser+"^"+BillNo+"^"+t['23']+"^"+currinvid+"^"+"Y"+"^"+Adm
			printinvno=currentinvnoobj.value
			var getsavetoinvprt=document.getElementById('getsavetoinvprt');
			if (getsavetoinvprt) {var encmeth=getsavetoinvprt.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,'','',p1)
			if (!ren) {alert(t['13']);return;}
			if (ren=="INV") {alert(t['18']);return;}
			var val=ren.split("^")
			if (val[0]==""){
				billinvnoobj.value=currentinvnoobj.value;
				currentinvnoobj.value="";
				printinvno=billinvnoobj.value
				currinvid="";
				alert(t['16']);
				}
			else{
				billinvnoobj.value=currentinvnoobj.value
				printinvno=billinvnoobj.value
				currentinvnoobj.value=val[0];
				currinvid=val[1];
			
			}
			/////////////////////
			p1=BillNo
			var getdeposit=document.getElementById('getdeposit');
			if (getdeposit) {var encmeth=getdeposit.value} else {var encmeth=''};
			var ret=cspRunServerMethod(encmeth,'','',p1);
		
			myData3=ret.split("^"); 
			
            var rystr=myData3[8].split("-")
			ryyear=rystr[0]
            rymon=rystr[1]
            ryday=rystr[2]
            var cystr=myData3[9].split("-")
            cyyear=cystr[0]
            cymon=cystr[1]
            cyday=cystr[2]

			p1=BillNo
			//alert(BillNo)
			var getinpatcate=document.getElementById('getinpatcate');
			if (getinpatcate) {var encmeth=getinpatcate.value} else {var encmeth=''};
			ret=cspRunServerMethod(encmeth,'getdata','',p1);
			//alert(ret);
			p1=ret
			var getpay=document.getElementById('getpay');
			if (getpay) {var encmeth=getpay.value} else {var encmeth=''};
			ret=cspRunServerMethod(encmeth,'','',p1);
		    myData2=ret.split("^");   
			gusercode=GuserCode
			//var selectflag=window.confirm(t['jst04'])
			//if (selectflag)
		    //{  
		     PrintSJ() 
		     selectflag=window.confirm(t['jst05'])
		     if (selectflag)
		     {  PrintFP();}
		     
		     if (BillNo=="") {alert("BillNo is Null");return;}
             getyklyobj=document.getElementById('getykly')
             if (getyklyobj) {var encmeth=getyklyobj.value}else {var encmeth=''};
             var returnvalue=cspRunServerMethod(encmeth,BillNo)
             yklystr=returnvalue.split("@");
             if (eval(yklystr[0])>0){
		     selectflag=window.confirm(t['jst08'])
		     if (selectflag)
		     {  Printykly1();}}
		     
		   // }
}
function PrintSJ()
{ 	var xlApp,obook,osheet,xlsheet,xlBook
	Template=path+"JF_PrintFp.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var amt,amtdx
	if (pattype==t['INSUPatType']||pattype==t['INSUPatType06']||pattype==t['INSUPatType02']||pattype==t['INSUPatType03']||pattype==t['INSUPatType04']||pattype==t['INSUPatType05']||pattype==t['INSUPatType07'])
	{   amt=PayModeList[2]
	    var getamtdx=document.getElementById('getamtdx');
		if (getamtdx) {var encmeth=getamtdx.value} else {var encmeth=''};
		amtdx=cspRunServerMethod(encmeth,'','',amt);   
	}
	else
	{   amt=myData2[2]
	    amtdx=myData2[3]
	}
	
	xlsheet.cells(2,1).value=myData3[18]         //zyno
	xlsheet.cells(3,2).value=myData3[5]         //NAME
	//xlsheet.cells(3,4).value=myData3[11]        //zhuyuanhao
	xlsheet.cells(3,4).value=myData3[18]        //zhuyuanhao modify by cx  2007.04.17
	xlsheet.cells(6,4).value=myData3[16]        //CURdate
	xlsheet.cells(4,2).value=myData3[8]  //RYDATE
	xlsheet.cells(4,4).value=myData3[9]    //CYDATE
	xlsheet.cells(5,2).value=amtdx  //myData2[3]//DAXIE
	xlsheet.cells(5,4).value=amt    //myData2[2]  //XIAOXIE
	xlsheet.cells(6,2).value=gusercode

	xlsheet.printout
	xlBook.Close (savechanges=false)
	xlApp=null;
	xlsheet=null
}
function printrcpt_click()
{ 	p1=BillNo
	var getdeposit=document.getElementById('getdeposit');
	if (getdeposit) {var encmeth=getdeposit.value} else {var encmeth=''};
	var ret=cspRunServerMethod(encmeth,'','',p1);	
	myData3=ret.split("^"); 		
    var rystr=myData3[8].split("-")
	ryyear=rystr[0]
    rymon=rystr[1]
    ryday=rystr[2]
    var cystr=myData3[9].split("-")
    cyyear=cystr[0]
    cymon=cystr[1]
    cyday=cystr[2]

	p1=BillNo
	var getinpatcate=document.getElementById('getinpatcate');
	if (getinpatcate) {var encmeth=getinpatcate.value} else {var encmeth=''};
	ret=cspRunServerMethod(encmeth,'getdata','',p1);
	p1=ret
	var getpay=document.getElementById('getpay');
	if (getpay) {var encmeth=getpay.value} else {var encmeth=''};
	ret=cspRunServerMethod(encmeth,'','',p1);
	myData2=ret.split("^");   
	gusercode=GuserCode
	//printinvno=window.opener.Tinvno
    printinvno=billinvnoobj.value    
    PrintFP();
}
function getdata(value)
{
	//modify 2006.2.28 by cx
	catedata=value.split("###");  
    var mydata=catedata[0].split("&");
	for (i=1;i<mydata.length;i++){
		var tmpstrs=mydata[i];
		//alert(tmpstrs);
		myData1=tmpstrs.split("^"); 
		myData5[i-1]=myData1;		
	}
	if (catedata[1]!="")  {
		var inpatdata=catedata[1].split("&");
		for (j=1;j<inpatdata.length;j++){
			var tmpstrs1=inpatdata[j];
			var tmpstrs2=tmpstrs1.split("^");
			myData6[j-1]=tmpstrs2;			
			}
	}
}
function getpath() {
		   
			var getpath=document.getElementById('getpath');
			if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
		
			path=cspRunServerMethod(encmeth,'','')
			
	}
function getpbflag() {
		   
		    p1=BillNo
			var getpbflagobj=document.getElementById('getpbflag');
			if (getpbflagobj) {var encmeth=getpbflagobj.value} else {var encmeth=''};
			var ren=cspRunServerMethod(encmeth,'','',p1)
			return ren;
	}
function Abort_click()
{
	var curinvno=billinvnoobj.value
    var curno=currentinvnoobj.value
    var abortflag,abourtflag1
    abortflag="0"
    abortflag1="0"
    if((curinvno=="")||(curinvno==" ")){abortflag="1"}
    if((curno=="")||(curno==" ")){abortflag1="1"}
	if ((abortflag=="0")&&(abortflag1=="0"))
		{ 	//abortnum=#server(web.DHCJFINVMAG.Abort(form1.textfield1.value,form1.textfield3.value,bill,user))#;
			p1=billinvnoobj.value+"^"+currentinvnoobj.value+"^"+BillNo+"^"+Guser
			var getabort=document.getElementById('getabort');
			if (getabort) {var encmeth=getabort.value} else {var encmeth=''};
			var abortnum=cspRunServerMethod(encmeth,'','',p1)
			if (abortnum=="1")
			{alert(t['17']);return;}
			if (abortnum=="2")
			{alert(t['24']);return;}
			if (abortnum=="0")
			{
				billinvnoobj.value="";
				alert(t['14'])}
		     else
		     {alert(t['15'])}			
			
			
		}
	}
function Close_click()
{	
	window.close();
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFCASHIER";
	}
function BodyunLoadHandler()
	{
		//alert("bye!")
		window.opener.Find.click();
		
		}
function change()
 		{
	 		var payamountobj=document.getElementById('payamount');
	 		var changeobj=document.getElementById('change');
	 		var num=payamountobj.value;
	 		if (num=="") 
	 		{   changeobj.value="";
		 		return;    }
	 		else
	 		{  
	 		var tmpamt=eval(num)-eval(pay);
	 		changeobj.value=tmpamt.toFixed(2);
	 		}
	 		ddd(num)
         }
function getpaymodeid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('paymodeid');
	obj.value=val[1];

}
function getbankid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('bankid');
	obj.value=val[1];
	}
function getcurrentinvno() {
		   
		    p1=Guser
			var getcurrinvobj=document.getElementById('getcurrinv');
			if (getcurrinvobj) {var encmeth=getcurrinvobj.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setinvno_val','',p1)=='1'){
				return true;}
				else
				{return false;}
	}
function setinvno_val(value)
	{
		var val=value.split("^")
		currentinvnoobj.value=val[0];
		currinvid=val[1];
		}
function LinkBillDetail()
{
	if (BillNo=="") {alert("BillNo is Null");return;}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo='+BillNo
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
	}


function ybadd(pattype)
{  
    flag=IPRevFoot(BillNo,pattype)	
	if (flag<0) {
		ybgbflag="0"
		return false ;}
	//Flag|DivdieRowid|selfpay|BillRowID|tc|da e zhifu |bing zhong cha jia|yi bao cha jia
	PayModeList=flag.split("|");	
	//var num=PayModeList.length
	if (eval(PayModeList[0])==0)
	{ybgbflag="1"}
	else{
		ybgbflag="0"
		}
	for (i=1;i<9;i++)
	{
	  if(PayModeList[i]=="") {PayModeList[i]="0.00";}
    }

        //yi bao ji jin zhi fu
	if (PayModeList[4]!="0.00")
	{
		//clear
		amounttopayobj.value="";
		paymodeobj.value="";
		paymodeobj.value=t['INSUPM09'];
		amounttopayobj.value=PayModeList[4];
		Addtabrow();
	}
	
    //gong shang zhi fu 
	if (PayModeList[5]!="0.00")
	{
		amounttopayobj.value="";
		paymodeobj.value="";
		paymodeobj.value=t['INSUPM13'];
		amounttopayobj.value=PayModeList[5];
		Addtabrow();
	}
	    //gong liao zhi fu	   	   
	if (PayModeList[6]!="0.00")
	{
		amounttopayobj.value="";
		paymodeobj.value="";
		paymodeobj.value=t['INSUPM14'];
		amounttopayobj.value=PayModeList[6];
		Addtabrow();
	}	

    amounttopayobj.value=eval(PayModeList[2])-eval(depositsumobj.value)
	amounttopayobj.value=eval(amounttopayobj.value).toFixed(2).toString(10)
	balanceobj.value=amounttopayobj.value;
	paymodeobj.value=t['21'];
	pay=balanceobj.value
	amounttopayobj.value=pay
	if (pay>0)
	   { balanceobj.style.color="red"; }	
	}
//yyx2007-3-26
function paymode_click()
{ 
  if ((paymodeobj.value==t['24'])||(paymodeobj.value==t['jstzply']))
   {   var infro=document.getElementById('getzpinfo');
	   if (infro) {var encmeth=infro.value}else {var encmeth=''};
	   var returnvalue=cspRunServerMethod(encmeth,Adm)	   
	   var sub=returnvalue.split("^")
	   //bank_"^"_bankid_"^"_cardno_"^"_company_"^"_authno
	   bankobj.value=sub[0]
	   chequeobj.value=sub[2];
	   unitobj.value=sub[3]
	   accountobj.value=sub[4]
	   document.getElementById('bankid').value=sub[1]
	   document.getElementById('banksub').value=sub[5]
	   //document.getElementById('cheque').value=sub[2]
	   //document.getElementById('unit').value=sub[3]
	   //document.getElementById('account').value=sub[4]

	  }
}
function Printykly(){
   var getyklyobj   
    
   if (BillNo=="") {alert("BillNo is Null");return;}
   getyklyobj=document.getElementById('getykly')
   if (getyklyobj) {var encmeth=getyklyobj.value}else {var encmeth=''};
   var returnvalue=cspRunServerMethod(encmeth,BillNo)
   yklystr=returnvalue.split("@");
   if (eval(yklystr[0])>0){
      Printykly1()
   }
   else{
    alert(t['jst09']);
    return;	   }
}
function  Printykly1(){
   var xlApp,obook,osheet,xlsheet,xlBook   
   var yklystr1,yklystr2
   var prtdate
   var i  
	Template=path+"JF_yklytzd.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	
	prtdate=yklystr[1]
	yklystr1=yklystr[2].split("&");
	for (i=0;i<=yklystr1.length-1;i++){
	   yklystr2=yklystr1[i].split("^");
	   xlsheet.cells(5,3).value=yklystr2[0]   //papno
	   xlsheet.cells(5,6).value=yklystr2[1]   //name
	   xlsheet.cells(7,3).value=yklystr2[2]   //zhuyuanhao
	   xlsheet.cells(7,6).value=yklystr2[5]   //name
	   xlsheet.cells(5,8).value=yklystr2[4]   //keshi
	   xlsheet.cells(7,8).value=yklystr2[3]   //bingqu
	   xlsheet.cells(9,4).value=yklystr2[6]   //daxie
	   xlsheet.cells(9,8).value=yklystr2[7]   //xiaoxie
	   xlsheet.cells(11,4).value=yklystr2[8]   //danwei
	   xlsheet.cells(11,8).value=yklystr2[9]   //paymode
	   xlsheet.cells(13,3).value=yklystr2[10]   //bank
	   xlsheet.cells(13,8).value=yklystr2[11]   //zhipiaohao
	   xlsheet.cells(15,3).value=yklystr2[12]   //zhanghao
	   xlsheet.cells(17,4).value=GuserCode
	   xlsheet.cells(17,8).value=prtdate
	   xlsheet.printout
	}	
	xlBook.Close (savechanges=false)
	xlApp=null;
	xlsheet=null
}
document.body.onload = BodyLoadHandler;
