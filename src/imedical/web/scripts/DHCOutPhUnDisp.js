//DHCOutPhUnDisp
var SelectedRow = 0;
var tbl=document.getElementById('tDHCOutPhUnDisp');
var fy=document.getElementById("CFyFlag");
var BReturn=document.getElementById("BReturn");
   fy.checked=true
    BReturn.style.visibility = "hidden";

function BodyLoadHandler() {
	var baddobj=document.getElementById("BAdd");
	if (baddobj) baddobj.onclick=Badd_click;
	var obj=document.getElementById("BModify");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	var obj=document.getElementById("BExit");
	if (obj) obj.onclick=BExit_click;
	var obj=document.getElementById("BReset");
	if (obj) obj.onclick=BReset_click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	var obj=document.getElementById("BReturn");
	//if (obj) obj.onclick=BReturn_click;
	if (obj) obj.onclick=function ()
	{
		BDisp_click("Z");
		
	}
	var obj=document.getElementById("BDispen");
	if (obj) obj.onclick=function ()
	{
		BDisp_click("S");
		
	}
	var obj=document.getElementById("CPhQty");
     document.onkeydown=OnKeyDownHandler;
    var obj=document.getElementById("CFyFlag");
	if (obj) obj.onclick=GetChFy;
	var obj=document.getElementById("CRetFlag");
	if (obj) obj.onclick=GetChRet; 
}

///liangqiang 
function GetChFy()
{
   var fy=document.getElementById("CFyFlag");
   var ret=document.getElementById("CRetFlag");
   var BDisp=document.getElementById("BDispen");
   var BReturn=document.getElementById("BReturn");	
   //if ((fy.checked==true)&(ret.checked==true)){fy.checked=false;}
   //fy.checked=!(fy.checked)
   ret.checked=!(ret.checked)
    if (fy.checked==true){BReturn.style.visibility = "hidden";
      BDisp.style.visibility = "visible";};
      
       if (ret.checked==true){BDisp.style.visibility = "hidden";
      BReturn.style.visibility = "visible";};
}
function GetChRet()
{
   var fy=document.getElementById("CFyFlag");
   var ret=document.getElementById("CRetFlag");
   var BDisp=document.getElementById("BDispen");
   //if ((ret.checked==true)&(fy.checked==true)){ret.checked=false;}
   
   fy.checked=!(fy.checked)
   //ret.checked=!(ret.checked)
   if (ret.checked==true){BDisp.style.visibility = "hidden";
      BReturn.style.visibility = "visible";};
      
        if (fy.checked==true){BReturn.style.visibility = "hidden";
      BDisp.style.visibility = "visible";};
	 
}
function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;
	var row=selectrow+1;
	
	var PhDesc=document.getElementById("TPhDescz"+row);
	var PhInci=document.getElementById("TPhInciz"+row);
    if (!(PhInci))return;
    if (!(parseFloat(PhInci.value)>0)) return;  //LiangQiang 20120421
	var PhUomDesc=document.getElementById("TPhUomDescz"+row);
	var PhUom=document.getElementById("TPhUomz"+row);
	var PhPrice=document.getElementById("TPhPricez"+row);
	var PhQty=document.getElementById("TPhQtyz"+row);
	var PhMoney=document.getElementById("TPhMoneyz"+row);
    var phdesc=document.getElementById('CPhDesc')
    var phinci=document.getElementById('CPhInci')
    var phuomdesc=document.getElementById('CPhUomDesc')
    var phuom=document.getElementById('CPhUom')
    var phqty=document.getElementById('CPhQty')
    var phprice=document.getElementById('CPhPrice')
    var phmoney=document.getElementById('CPhMoney')
  
    phdesc.value=PhDesc.innerText
    phuomdesc.value=PhUomDesc.innerText
    phinci.value=PhInci.value
    phuom.value=PhUom.value
    phqty.value=PhQty.innerText
    phmoney.value=PhMoney.innerText
    phprice.value=PhPrice.innerText

}
function BReset_click()
{
  var kc=document.getElementById('CPhKC');
  var phqty=document.getElementById('CPhQty');
  var phmoney=document.getElementById('CPhMoney');
  var price=document.getElementById('CPhPrice');
  var phdesc=document.getElementById('CPhDesc');
  var inci=document.getElementById('CPhInci');
  var unit=document.getElementById('CPhUom');
  var uomdesc=document.getElementById('CPhUomDesc');
  uomdesc.value="";
  kc.value="";
  phqty.value="";
  phmoney.value="";
  phdesc.value="";
  inci.value="";
  unit.value="";
  price.value="";
  DHCMZYF_setfocus('CPhDesc');
  
  	
}
function BReturn_click()
{
 var objtbl=document.getElementById('tDHCOutPhUnDisp');
 var tblrows=objtbl.rows.length;	
 var l=0
 var i
     for (i=2;i<=tblrows-1;i++)
     {
	   var qty=document.getElementById('TPhQtyz'+i).innerText
	   var money=document.getElementById('TPhMoneyz'+i).innerText
	   var price=document.getElementById('TPhPricez'+i).innerText
		   var totsum=parseFloat(qty)*parseFloat(price)
		   if (totsum.toFixed(2)!=parseFloat(money))
		   {
			l=l+1;   
		   }
     }
    if(l>0){alert(t['20']);return;}
    
 var personrow=insertperson();
     if (personrow==0) {alert(t['01']);return ;}
     if (personrow==-1) {alert(t['02']);return ;}
  var  ctloc=document.getElementById('ctloc').value;
  var  userid=document.getElementById('userid').value;
  var reasid=document.getElementById('CReasID').value;
  var poscode=document.getElementById('CWinPosCode').value;
  var getmethod=document.getElementById('ret');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  var retval=cspRunServerMethod(encmeth,ctloc,userid,personrow,poscode,reasid)	
  if (retval==''){alert(t['03']);return ;}
 
  var rows=objtbl.rows.length;
  var adjrow=retval.split("^");
  var unretrow=adjrow[0];
  var adj=adjrow[1];
  var dhcadj=adjrow[2];
  var lastrowindex=rows-1;
  
  
  
  var xsub=""	
	//allrow, inci, uom, qty, price, money, sub, xsub
 for (var j=2;j<rows;j++) {
	var inci=document.getElementById('TPhInciz'+j).value;
	var uom=document.getElementById('TPhUomz'+j).value;
	var qty=document.getElementById('TPhQtyz'+j).innerText;
	var price=document.getElementById('TPhPricez'+j).innerText;
	var money=document.getElementById('TPhMoneyz'+j).innerText;
	var getmethod=document.getElementById('retitm');
    if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
    var val=cspRunServerMethod(encmeth,ctloc,retval,inci,uom,qty,price,money,j-1)	
    if (val=='-1'){alert(t['04']);return;}
    xsub=val
	}
	var getmethod=document.getElementById('balret');
    if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
    var gval=cspRunServerMethod(encmeth,dhcadj,ctloc,unretrow);	
     alert(t['05']);
     BClear_click();	
	
}
function BDisp_clickOLD()
{
 var objtbl=document.getElementById('tDHCOutPhUnDisp');
 var tblrows=objtbl.rows.length;	
 var l=0
 var i
     for (i=2;i<=tblrows-1;i++)
     {
	   var qty=document.getElementById('TPhQtyz'+i).innerText
	   var money=document.getElementById('TPhMoneyz'+i).innerText
	   var price=document.getElementById('TPhPricez'+i).innerText
		   var totsum=parseFloat(qty)*parseFloat(price)
		   if (totsum.toFixed(2)!=parseFloat(money))
		   {
			l=l+1;   
		   }
     }
    if(l>0){alert(t['20']);return;}
    	
  var personrow=insertperson(); 
  
     if (personrow==0) {alert(t['06']);return ;}
     //if (personrow==-1) {alert(t['07']);return ;}
     
  var  ctloc=document.getElementById('ctloc').value;
  var reasid=document.getElementById('CReasID').value;
  var poscode=document.getElementById('CWinPosCode').value;
  var  userid=document.getElementById('userid').value;
  
   var dispen=ctloc+"^"+userid+"^"+personrow+"^"+poscode+"^"+reasid
  
  
  /*
  var getmethod=document.getElementById('disp');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  var retval=cspRunServerMethod(encmeth,ctloc,userid,personrow,poscode,reasid)	
  if (retval==''){alert(t['08']);return ;}
  var rows=objtbl.rows.length;
  var lastrowindex=rows-1;
  var adjrow=retval.split("^");
  var undisprow=adjrow[0];
  var adj=adjrow[1];
  var dhcadj=adjrow[2];
	
  
  */
    var xsub=""
    var dispitm=""
	//allrow, inci, uom, qty, price, money, sub, xsub
 for (var j=2;j<rows;j++) {
			var inci=document.getElementById('TPhInciz'+j).value;
			var uom=document.getElementById('TPhUomz'+j).value;
			var qty=document.getElementById('TPhQtyz'+j).innerText;
			var price=document.getElementById('TPhPricez'+j).innerText;
			var money=document.getElementById('TPhMoneyz'+j).innerText;
			
			//var getmethod=document.getElementById('dispitm');
		    //if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
		    //var val=cspRunServerMethod(encmeth,ctloc,retval,inci,uom,qty,price,money,j-1,xsub)
		    
		    var incistring=ctloc+"^"+retval+"^"+inci+"^"+uom+"^"+qty+"^"+price+"^"+money+"^"+j-1+"^"+xsub
		    if (dispitm=="")
		    {
			    var dispitm=incistring
		    }
		    else
		    {
			    var dispitm=dispitm+"%"+incistring
		    }
		    
		    
		    //if (val=="-1"){alert(t['09']);return;}
		    xsub=val;
	}
   
   var insertSting=personrow+"||"+dispen+"!!"+dispitm
   
   
   var getmethod=document.getElementById('baldisp');
   //if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
   //var gval=cspRunServerMethod(encmeth,dhcadj,ctloc,undisprow);
   
   alert(insertSting)
   //var getmethod=document.getElementById('dispensing');
   //if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
   //var gval=cspRunServerMethod(encmeth,insertSting);
   
   alert(t['10']);
   BClear_click();	
  
}

///执行发药,统一后台处理,Liangqiang,2011-03-15

function BDisp_click(Type)
{
     var objtbl=document.getElementById('tDHCOutPhUnDisp');
     var tblrows=objtbl.rows.length;	
     var l=0
     var i
  
     if (document.getElementById('TPhInciz'+2).value==""){  //1->2 add by myq 20150915 
	     alert("没有增加药品明细,不能操作!")
	     return;
     }
     
     for (i=2;i<=tblrows-1;i++)
     {
	   var qty=document.getElementById('TPhQtyz'+i).innerText
	   var money=document.getElementById('TPhMoneyz'+i).innerText
	   var price=document.getElementById('TPhPricez'+i).innerText
		   var totsum=parseFloat(qty)*parseFloat(price)
		   if (totsum.toFixed(2)!=parseFloat(money))
		   {
			l=l+1;   
		   }
     }
     if(l>0){alert(t['20']);return;}
    	
     var personrow=insertperson(); 
  
     if (personrow==0) {alert(t['06']);return ;}

     var  ctloc=document.getElementById('ctloc').value;
     var reasid=document.getElementById('CReasID').value;
     var poscode=document.getElementById('CWinPosCode').value;
     var  userid=document.getElementById('userid').value;
  
     var dispen=personrow+"^"+ctloc+"^"+userid+"^"+poscode+"^"+reasid

     var xsub=""
     var dispitm=""

     for (var j=2;j<tblrows;j++) 
     {
			var inci=document.getElementById('TPhInciz'+j).value;
			var uom=document.getElementById('TPhUomz'+j).value;
			var qty=document.getElementById('TPhQtyz'+j).innerText;
			var price=document.getElementById('TPhPricez'+j).innerText;
			var money=document.getElementById('TPhMoneyz'+j).innerText;

		    var incistring=inci+"^"+uom+"^"+qty+"^"+price+"^"+money
		  
		    if (dispitm=="")
		    {
			    var dispitm=incistring
		    }
		    else
		    {
			    var dispitm=dispitm+"%"+incistring
		    }
             
		    xsub=j-1;
	  }
   
     var insertSting=dispen+"!!"+dispitm
     
     
     if (Type=="S")
     {
	   var getmethod=document.getElementById('undisp');
	   if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
	   var gval=cspRunServerMethod(encmeth,insertSting);
     }
     
          
     if (Type=="Z")
     {
	   var getmethod=document.getElementById('unreturn');
	   if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
	   var gval=cspRunServerMethod(encmeth,insertSting);
     }
     
     if (gval>0) {alert("执行成功")}  else {alert("处理失败 错误信息:"+gval)} ;
     
     BClear_click();	
  
}


function insertperson()
{
 var patname=document.getElementById('CPatName').value;
 if (patname==''){return 0;}
 var patsex=document.getElementById('CPatSexId').value;
 var pattype=document.getElementById('CPatTypeId').value;
 var patage=document.getElementById('CPatAge').value;
 var patpmi=document.getElementById('CPatPmiNo').value;
 var patbz=document.getElementById('CPatDemo').value;
 //var getmethod=document.getElementById('insperinf');
 //if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 //var retval=cspRunServerMethod(encmeth,patname,patsex,patage,pattype,patpmi,patbz)
 
 var retval=patname+"^"+patsex+"^"+patage+"^"+pattype+"^"+patpmi+"^"+patbz
  
 return retval;
	
}

function BClear_click(){
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhUnDisp";
  document.location.href=lnk;
}
function OnKeyDownHandler(e){
  var key=websys_getKey(e);
  var rows=tbl.rows.length;
  var kc=document.getElementById('CPhKC').value;
  var phdesc=document.getElementById('CPhDesc');
  var phqty=document.getElementById('CPhQty');
  var phmoney=document.getElementById('CPhMoney');
  var phprice=document.getElementById('CPhPrice').value;
  var patname=document.getElementById('CPatName');
  var sex=document.getElementById('CPatSex');
  var age=document.getElementById('CPatAge');
  var pertype=document.getElementById('CPatType');
  var pmi=document.getElementById('CPatPmiNo');
  var bz=document.getElementById('CPatDemo');
  var add=document.getElementById('BAdd');
  var mod=document.getElementById('BModify');
  var reset=document.getElementById('BReset');
  var del=document.getElementById('BDelete');
  var clear=document.getElementById('BClear');
  var disp=document.getElementById('BDispen');
  var ret=document.getElementById('BReturn');
  var lprint=document.getElementById('BPrint');
  var fy=document.getElementById('CFyFlag')
  var ty=document.getElementById('CRetFlag')
  var reas=document.getElementById('CReasDesc')
  switch (key) {
	case 13:
	    var eSrc=websys_getSrcElement(e);
	    if (eSrc==patname) {DHCMZYF_setfocus('CPatSex');}
		if (eSrc==sex) {sex_lookup();} 
		if (eSrc==age) {DHCMZYF_setfocus('CPatType');} 
		if (eSrc==pmi) {GetPmino();}
		if (eSrc==pertype) {ptype_lookuphandler();} 
		if (eSrc==reas) {GCReasDesc_lookuphandler();} 
		if (eSrc==bz) {DHCMZYF_setfocus('CPhDesc');} 
		if (eSrc==phdesc){
			if (phdesc.value==''){
				if ((fy.checked==true)&(rows>2)){var retval=confirm(t['11']);if (retval==true){DHCMZYF_setfocus('BDispen');} else {return;}}
				if ((ty.checked==true)&(rows>2)){var retval=confirm(t['12']);if (retval==true){DHCMZYF_setfocus('BReturn');} else {return;}}
			}
			else {CPh_lookuphandler();}
		}
	    if (eSrc==phqty) {
		    if (phdesc.value==''){phqty.value="";return;}
		
		    var inci=document.getElementById('CPhInci').value;
		    var ctlocdr=document.getElementById('ctloc').value;
		    var chk = tkMakeServerCall("web.DHCOutPhAdd", "ChkDrugStockQty",inci,ctlocdr,phqty.value);

		    if (chk==0){alert(t['13']);phqty.value="";phmoney.value="";return;}
		    if  (phqty.value==''){phqty.value="";phmoney.value="";return ;}
		    if (phqty.value<=0) {alert(t['14']);phqty.value="";phmoney.value="";return;}
		    if (parseFloat(phqty.value)!=parseInt(parseFloat(phqty.value))) {alert(t['15']);phqty.value="";phmoney.value="";return;}
		       var sum=(phqty.value)*(phprice)
	           phmoney.value=sum.toFixed(2)
	           DHCMZYF_setfocus('BAdd');}
	        break;
case 37:
	      var eSrc=websys_getSrcElement(e);
	      if (eSrc==add) {DHCMZYF_setfocus('BReset');} 
	      if (eSrc==mod) {DHCMZYF_setfocus('BAdd');} 
	      if (eSrc==del) {DHCMZYF_setfocus('BModify');}
	      if (eSrc==clear) {DHCMZYF_setfocus('BDelete');}
	      if (eSrc==disp) {DHCMZYF_setfocus('BClear');}
		  if (eSrc==ret) {DHCMZYF_setfocus('BClear');}
	      if (eSrc==lprint) {
		      if (fy.checked==true){ DHCMZYF_setfocus('BDispen');}
		      if (ty.checked==true){ DHCMZYF_setfocus('BReturn');}}  
	     
	      break;
case 39:
	      var eSrc=websys_getSrcElement(e);
	      if (eSrc==add) {DHCMZYF_setfocus('BModify');} 
	      if (eSrc==reset) {DHCMZYF_setfocus('BAdd');}
	      if (eSrc==mod) {DHCMZYF_setfocus('BDelete');}
	      if (eSrc==del) {DHCMZYF_setfocus('BClear');}
	      if (eSrc==clear) {
		      if (fy.checked==true){ DHCMZYF_setfocus('BDispen');}
		      if (ty.checked==true){ DHCMZYF_setfocus('BReturn');}}  
	      if (eSrc==disp) {DHCMZYF_setfocus('BPrint');}
		  if (eSrc==ret) {DHCMZYF_setfocus('BPrint');}
	      break; 
	     
}
}

function GetPmino() {
	var pmiobj=document.getElementById('CPatPmiNo');
	var patname=document.getElementById('CPatName');
	var patage=document.getElementById('CPatAge');
	var patsex=document.getElementById('CPatSex');
	var patsexdr=document.getElementById('CPatSexId');
	var pattype=document.getElementById('CPatType');
	var pattypedr=document.getElementById('CPatTypeId');
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){DHCMZYF_setfocus('CPatName'); return ;}
 	//if (plen>8){alert(t['16']);DHCMZYF_setfocus('CPatName');return;}
	 for (i=1;i<=10-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	var getmethod=document.getElementById('getperinf');
    if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
    var val=cspRunServerMethod(encmeth,lspmino)	
    if (val==''){alert(t['17']);return;}
    var sstr=val.split("^")
    //patname_"^"_sex_"^"_sexdr_"^"_age_"^"_pertype_"^"_typedr
    patname.value=sstr[0];
    patsex.value=sstr[1];
    patsexdr.value=sstr[2];
    patage.value=sstr[3];
    pattype.value=sstr[4];
    pattypedr.value=sstr[5];
    DHCMZYF_setfocus('CPatDemo');
}
function GetWinPosCode(value)
{
  if (value=="") return;
  var BStr=value.split("^");
  var winposcode=document.getElementById("CWinPosCode");
  winposcode.value=BStr[1];
}

function sex_lookup()
{
	var url='websys.lookup.csp';
	url += "?ID=d50203iCPatSex";
	url += "&CONTEXT=Kweb.DHCPhQueryTotal:QuerySex";
	url += "&TLUJSF=GetSexID";
	//websys_lu(url,1,'');
	websys_lu(url,1,'top=100,left=200,width=200,height=150');
	
	return websys_cancel();
}
	
function CPh_lookuphandler(e) {
	if (evtName=='CPhDesc') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var desc=document.getElementById('CPhDesc')
	if (desc.value=='') {return ;}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url='websys.lookup.csp';
		url += "?ID=d50203iCPhDesc";
		url += "&CONTEXT=Kweb.DHCOutPhAdd:QueryPhDesc";
		url += "&TLUJSF=GetPhUnitPrice";
		var obj=document.getElementById('ctloc');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('CPhDesc');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		//websys_lu(url,1,'');
		websys_lu(url,1,'top=300,left=300,width=400,height=230');
		return websys_cancel();
	}
}
	//var obj=document.getElementById('CPhDesc');
	//if (obj) obj.onkeydown=CPh_lookuphandler;
function ptype_lookuphandler(e) {
		var url='websys.lookup.csp';
		url += "?ID=d50203iCPatType";
		url += "&CONTEXT=Kweb.DHCPhQueryTotal:QueryPerType";
		url += "&TLUJSF=GetTypeID";
		//websys_lu(url,1,'');
		websys_lu(url,1,'top=100,left=700,width=200,height=180');
		return websys_cancel();
      }
function GCReasDesc_lookuphandler(e) {
		var url='websys.lookup.csp';
		url += "?ID=d50203iCReasDesc";
		url += "&CONTEXT=Kweb.DHCOutPhCode:QueryPhUnReas";
		url += "&TLUJSF=GReasID";
		websys_lu(url,1,'top=100,left=700,width=200,height=180');
		return websys_cancel();

}

function Bupdate_click()	
{  
	if (SelectedRow==0) return;
    var qty=document.getElementById('CPhQty').value;
    var money=document.getElementById('CPhMoney').value;
    if (qty=='') return;
    var inc=document.getElementById('CPhDesc').value;
    if (inc=='') return; 
    var row=SelectedRow+1    
    var tableqty=document.getElementById("TPhQtyz"+row);
    var tablemoney=document.getElementById("TPhMoneyz"+row);
    var ymoney=tablemoney.innerText;
        tableqty.innerText=qty;
        tablemoney.innerText=money;
    var cmoney=document.getElementById('CTotal');
    var newtotal=parseFloat(cmoney.value)+parseFloat(money)-parseFloat(ymoney);
        cmoney.value=newtotal.toFixed(2);
 
    BReset_click();
		

}
function Badd_click()	
{  
var patname= document.getElementById('CPatName')
if (patname.value==''){alert(t['06']);BReset_click();DHCMZYF_setfocus('CPatName');return;}
var qty=document.getElementById('CPhQty').value;
    if (qty<1){return;}
var money=document.getElementById('CPhMoney').value;
 if(money==""){return ;}

var inc=document.getElementById('CPhInci').value;
    if (inc==''){return;}
    Addtabrow();
    BReset_click();
   // DHCMZYF_setfocus('CPhDesc');
}
function GetSexID(value)
{
  if (value=="") {return;}
  var sstr=value.split("^")
  var sexid=document.getElementById("CPatSexId")
     sexid.value=sstr[1]
    DHCMZYF_setfocus('CPatAge');
}

function GetTypeID(value)
{
 if (value=="") {return;}
  var sstr=value.split("^")
  var sexid=document.getElementById("CPatTypeId")
     sexid.value=sstr[1]
    DHCMZYF_setfocus('CReasDesc');
}
function GReasID(value)
{ if (value=="") {return;}
  var sstr=value.split("^")
  var reasid=document.getElementById("CReasID")
     reasid.value=sstr[1]
    DHCMZYF_setfocus('CPatDemo');
	
}

function GetPhUnitPrice(value) 
{ 
  if (value=="") {return;}
  var sstr=value.split("^")
  var phinci=document.getElementById("CPhInci")
     phinci.value=sstr[1]
  var phuomdesc=document.getElementById("CPhUomDesc")
     phuomdesc.value=sstr[2]
  var phuom=document.getElementById("CPhUom")
     phuom.value=sstr[3]
  var phprice=document.getElementById("CPhPrice")
     phprice.value=sstr[4]  
  var phprice=document.getElementById("CPhKC")
     phprice.value=sstr[5]   
     DHCMZYF_setfocus('CPhQty');
}


function Addtabrow()
	{
		var objtbl=document.getElementById('tDHCOutPhUnDisp');
		var i=0;
		var pp=0;
		var inci=document.getElementById('CPhInci').value;
		
		var total=0
		var cmoney=document.getElementById('CTotal');
		if (cmoney.value<=0){total=0;}
		else {total=parseFloat(cmoney.value);}
		var rows=objtbl.rows.length;
			for (i=2;i<rows;i++) { //i=1->i=2
		    var tinci=document.getElementById("TPhInciz"+i).value;
		    if (inci==tinci){pp=pp+1;}
		   }
		if (pp>0){alert(t['18']);return;}

		tAddRow(objtbl);
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
		var Row=LastRow
		var PhDesc=document.getElementById("TPhDescz"+Row);
		var PhInci=document.getElementById("TPhInciz"+Row);
		var PhUomDesc=document.getElementById("TPhUomDescz"+Row);
		var PhUom=document.getElementById("TPhUomz"+Row);
		var PhPrice=document.getElementById("TPhPricez"+Row);
		var PhQty=document.getElementById("TPhQtyz"+Row);
		var PhMoney=document.getElementById("TPhMoneyz"+Row);
       var phdesc=document.getElementById('CPhDesc')
       var phinci=document.getElementById('CPhInci')
       var phuomdesc=document.getElementById('CPhUomDesc')
       var phuom=document.getElementById('CPhUom')
       var phqty=document.getElementById('CPhQty')
       var phprice=document.getElementById('CPhPrice')
       var phmoney=document.getElementById('CPhMoney')
       PhDesc.innerText=phdesc.value;
       PhUomDesc.innerText=phuomdesc.value;
       PhPrice.innerText=phprice.value;
       PhQty.innerText=phqty.value;
       PhMoney.innerText=phmoney.value;
       PhUom.value=phuom.value;
       PhInci.value=phinci.value;
       
       cmoney.value=(total+parseFloat(phmoney.value)).toFixed(2);   
    
	}
function tAddRow(objtbl) {
	tk_ResetRowItemst(objtbl);
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
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
function BDelete_click()
{
	
	//var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOutPhUnDisp');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	if (SelectedRow=="-1") return;
	//if (!selectrow) return;
	if (SelectedRow==0) return;
	if (lastrowindex==SelectedRow) return;
	var selectrow0=eval(SelectedRow)+1
   

	objtbl.deleteRow(SelectedRow);
	tk_ResetRowItemst(objtbl);
	BReset_click();
//	unselected();
		
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
function DHCMZYF_setfocus(objName) {
	window.setTimeout('DHCMZYF_setfocus2(\''+objName+'\')',300);
}

function DHCMZYF_setfocus2(objName) {
	var obj=document.getElementById(objName);
	if (obj) {
		try {obj.focus();obj.select();	} catch(e) {}  }
    }


document.body.onload = BodyLoadHandler;
