//DHCOutPhQuery
var SelectedRow = 0;
var tbl=document.getElementById('tDHCOutPhQuery');
function BodyLoadHandler() {
	var baddobj=document.getElementById("BAdd");
	if (baddobj) baddobj.onclick=Badd_click;
	var obj=document.getElementById("BModify");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	var obj=document.getElementById("BReset");
	if (obj) obj.onclick=BReset_click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	var obj=document.getElementById("CPhQty");
     document.onkeydown=OnKeyDownHandler;
     websys_setfocus('CPhDesc');
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
    phinci.value=PhInci.innerText
    phuom.value=PhUom.innerText
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
  websys_setfocus('CPhDesc');
  
  	
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

function BClear_click(){
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQuery";
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
  var add=document.getElementById('BAdd');
  var mod=document.getElementById('BModify');
  var reset=document.getElementById('BReset');
  var del=document.getElementById('BDelete');
  var clear=document.getElementById('BClear');
  switch (key) {
	case 13:
	    var eSrc=websys_getSrcElement(e);
		if (eSrc==phdesc){
			if (phdesc.value==''){}
			else {CPh_lookuphandler();}}
	    if (eSrc==phqty) {
		    if (phdesc.value==''){phqty.value="";return;}

		   // if (parseFloat(phqty.value)>parseFloat(kc)){alert(t['01']);phqty.value="";phmoney.value="";return;}
		    if  (phqty.value==''){phqty.value="";phmoney.value="";return ;}
		    if (phqty.value<=0) {alert(t['02']);phqty.value="";phmoney.value="";return;}
		    if (parseFloat(phqty.value)!=parseInt(parseFloat(phqty.value))) {alert(t['03']);phqty.value="";phmoney.value="";return;}
		       var sum=(phqty.value)*(phprice)
	           phmoney.value=sum.toFixed(2)
	           websys_setfocus('BAdd');}
	        break;
}
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
		url += "?ID=d50217iCPhDesc";
		url += "&CONTEXT=Kweb.DHCOutPhAdd:QueryPhName";
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

function Badd_click()	
{  
var qty=document.getElementById('CPhQty').value;

    if (qty<1){return;}
var money=document.getElementById('CPhMoney').value;
 if(money==""){return ;}
var inc=document.getElementById('CPhInci').value;
    //if (inc==''){return;}
    Addtabrow();
    BReset_click();
   // websys_setfocus('CPhDesc');
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
     websys_setfocus('CPhQty');
}


function Addtabrow()
	{
		var objtbl=document.getElementById('tDHCOutPhQuery');
		var i=0;
		var pp=0;
		var inci=document.getElementById('CPhDesc').value;
		var total=0
		var cmoney=document.getElementById('CTotal');
		if (cmoney.value<=0){total=0;}
		else {total=parseFloat(cmoney.value);}
		var rows=objtbl.rows.length;
	
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
       PhUom.innerText=phuom.value;
       PhInci.innerText=phinci.value;
       total=total+parseFloat(phmoney.value);
       cmoney.value=total.toFixed(2)
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


document.body.onload = BodyLoadHandler;
