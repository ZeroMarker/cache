//DHCOutPhYFCode
//打印标签用法维护
var SelectedRow = 0;
function BodyLoadHandler() {
	var baddobj=document.getElementById("BAdd");
	if (baddobj) baddobj.onclick=BAdd_click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	var obj=document.getElementById("CYFDesc"); 
	if (obj) {	
		obj.onkeydown=CYFDesc_lookuphandler;
	} 	
}
function popCYFDesc()
{ 
	if (window.event.keyCode==13){
		if (event.preventDefault()){event.preventDefault()} //yunhaibao20160201,弹出界面的回车需屏蔽keydown事件
		window.event.keyCode=117;
	  	//tItmDesc_lookuphandler();
	  	window.event.isLookup=true;	
	  	CYFDesc_lookuphandler(window.event);
	}
}
function CYFDesc_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50093iCYFDesc';
		url += '&CONTEXT=Kweb.DHCOutPhCode:QueryYPYF';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=getyfid';
		var obj=document.getElementById('CYFDesc');
		if (obj) url += '&P1=' + websys_escape(obj.value);
		//websys_lu(url,1,'');
		websys_lu(url,1,'top=300,left=500,width=370,height=230');
		return websys_cancel();
	}
}


function getyfid(value) {

var obj=document.getElementById('YFID');
var tem=value.split("^");
//alert(tem[1]);
obj.value=tem[1];

}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOutPhYFCode');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('CYFDesc');
	var obj1=document.getElementById('YFID');
	var obj2=document.getElementById('CodeID');
	var SelRowObj=document.getElementById('TYFDescz'+selectrow);
	var SelRowObj1=document.getElementById('TYFIDz'+selectrow);
	var SelRowObj2=document.getElementById('yfcodeidz'+selectrow);
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.value;
	SelectedRow = selectrow;
}

function BDelete_click()	
{
	selectrow=SelectedRow;
    var codeid=document.getElementById('yfcodeidz'+selectrow).value
    var ctloc=document.getElementById('ctloc').value;
    var up=document.getElementById('del');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	var retval=cspRunServerMethod(encmeth,ctloc,codeid)
    if (retval=="0") { alert(t['delok']);
	    window.location.reload();}
	else
	{
		 alert(t['delfail']);
	   
		
		}
 
 
}
function BAdd_click()	
{
	selectrow=SelectedRow;
    var yfdesc=document.getElementById('CYFDesc').value;
    var yfid=document.getElementById('YFID').value;
    if(yfid==""){
	    alert("用法不能为空")
	    return;
	    }
    var ctloc=document.getElementById('ctloc').value;
    var pid=document.getElementById('ins');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,ctloc,yfid,yfdesc)
    if (retval=="0"){
	     alert(t['insok']);
	    window.location.reload();
    }
    else
    {
	     alert(t['insfail']);
	  
    }
	
	
	

}
function CleartDHCOPAdm()
{
	var objtbl=document.getElementById('tDHCOPReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex+1;j++) {
		objtbl.deleteRow(1);
	//alert(j);
	}
}

function GetValue(name){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {
			return obj.innerText;
		} else {
			if (obj.type=="select-one"){
				var Rowid="";
				var Desc="";
				if (obj.selectedIndex!=-1){
					Rowid=obj.value;
					Desc=obj.options[obj.selectedIndex].text;
				}
				return Rowid+String.fromCharCode(1)+Desc;
			}else{
				return obj.value
			}
		}
	}
	return "";
}
function SetValue(name,value){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {obj.innerText=value;} else {obj.value=value}
	}
}

function GetListSelectText(ListName){
	var Val="";
	var obj=document.getElementById(ListName);
	if (obj) {
		if (obj.selectedIndex!=-1){Val=obj.options[obj.selectedIndex].text};
	}
	return Val;
}

function GetListSelectVal(ListName){
	var Val="";
	var obj=document.getElementById(ListName);
	if (obj) {
		if (obj.selectedIndex!=-1){Val=obj.options[obj.selectedIndex].value};
	}
	return Val;
}


document.body.onload = BodyLoadHandler;
