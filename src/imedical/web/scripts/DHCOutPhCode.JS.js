//DHCOutPhCode
var SelectedRow = 0;
function BodyLoadHandler() {
	var baddobj=document.getElementById("Badd");
	if (baddobj) baddobj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var userid=document.getElementById("userid").value;
	var Str="";
	combo_DeptList=dhtmlXComboFromStr("Desc","");
	combo_DeptList.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getloc');
	var DeptStr=cspRunServerMethod(encmeth,userid)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_DeptList.addOption(Arr);
	
	
	combo_math=dhtmlXComboFromStr("math","");
	combo_math.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getmath');
	var DeptStr=cspRunServerMethod(encmeth)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_math.addOption(Arr);
	
	
	
	
}
function deplook(str) {

var obj=document.getElementById('depid');
var tem=str.split("^");
//alert(tem[1]);
obj.value=tem[1];

}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOutPhCode');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('Desc');
	var obj1=document.getElementById('math');
	var objmathdesc=document.getElementById('mathdesc');
	var obj2=document.getElementById('pyflag');
	var obj3=document.getElementById('fyflag');
	var obj4=document.getElementById('Phlid');
	var obj5=document.getElementById('byfs');
	var obj6=document.getElementById('CCyFlag');
	var obj7=document.getElementById('SendFlag');
	var obj8=document.getElementById('CPrintFlag');
	var obj9=document.getElementById('CWinTypeFlag');
	var obj10=document.getElementById('CDispMachine');
	var obj11=document.getElementById('CScreenFlag');
	var obj12=document.getElementById('CScreenPath');
	
	
	var SelRowObj=document.getElementById('Tdescz'+selectrow);
	var SelRowObj1=document.getElementById('Tyfsfz'+selectrow);
	var SelRowObj2=document.getElementById('Tpyz'+selectrow);
	var SelRowObj3=document.getElementById('Tfyz'+selectrow);
    var SelRowObj4=document.getElementById('Tphlidz'+selectrow);
    var SelRowObj5=document.getElementById('Tbyfsz'+selectrow);
    var SelRowObj6=document.getElementById('TCyFlagz'+selectrow);
    var SelRowObj7=document.getElementById('TSendFlagz'+selectrow);
    var SelRowObj8=document.getElementById('TPrintFlagz'+selectrow);
    var SelRowObj9=document.getElementById('TWinTypeFlagz'+selectrow);
    var SelRowObj10=document.getElementById('TDispMachinez'+selectrow);
    var SelRowObj11=document.getElementById('TScreenFlagz'+selectrow);
    var SelRowObj12=document.getElementById('TScreenPathz'+selectrow);
    var SelRowObjPySure=document.getElementById('Tpysurez'+selectrow);
    var SelRowObjAutoPy=document.getElementById('TAutoPyFlagz'+selectrow);
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	objmathdesc.value=SelRowObj1.innerText;
	if (SelRowObj2.innerText==t['01']){obj2.checked=true} else {obj2.checked=false}
	if (SelRowObj3.innerText==t['01']){obj3.checked=true} else {obj3.checked=false}
	if (SelRowObj5.innerText==t['01']){obj5.checked=true} else {obj5.checked=false}
	if (SelRowObj6.innerText==t['01']){obj6.checked=true} else {obj6.checked=false}
	if (SelRowObj7.innerText==t['01']){obj7.checked=true} else {obj7.checked=false}
	if (SelRowObj8.innerText==t['01']){obj8.checked=true} else {obj8.checked=false}
    if (SelRowObj9.innerText==t['01']){obj9.checked=true} else {obj9.checked=false}
    if (SelRowObj10.innerText==t['01']){obj10.checked=true} else {obj10.checked=false}
    if (SelRowObj11.innerText==t['01']){obj11.checked=true} else {obj11.checked=false}
    var ObjPySure=document.getElementById('pysure');
    if (ObjPySure){
   	 if (SelRowObjPySure){
	   	 if (SelRowObjPySure.innerText=="是"){ObjPySure.checked=true} else {ObjPySure.checked=false}
   	       }
    }

    var ObjAutoPy=document.getElementById('AutoPyFlag');
    if (ObjAutoPy){
	    if (SelRowObjAutoPy){
   	  if (SelRowObjAutoPy.innerText=="是"){ObjAutoPy.checked=true} else {ObjAutoPy.checked=false}
	    }
    }
    obj12.value=SelRowObj12.innerText
    obj4.value=SelRowObj4.value;
	SelectedRow = selectrow;
}

function Bupdate_click()	
{
	selectrow=SelectedRow;
    var userid=document.getElementById('userid').value;
    var tname=document.getElementById('Tdescz'+selectrow).innerText
    var math=combo_math.getSelectedText();
    if (math==""){
    	var math=document.getElementById('mathdesc').value;
    }
   
    if (math=="") {
		alert(t['04']);
		return;}
	 var scpath=document.getElementById('CScreenPath').value
	
    var phlid=document.getElementById('Phlid').value;
    if (phlid=="") {
		alert(t['05']);
		return;}		
    var py=document.getElementById('pyflag').checked;
    var fy=document.getElementById('fyflag').checked;
    var tjfs=document.getElementById('byfs').checked;
    var send=document.getElementById('SendFlag').checked;
    var screenflag=document.getElementById('CScreenFlag').checked;
     if (screenflag==true){var screen="1";}
     else {var screen="";}

    
    var sendflag=""
    if (send==true){sendflag="1";}
    
    var printobjch=document.getElementById('CPrintFlag').checked;
    var printflag=""
    if (printobjch==true){printflag="1";}
    var wintypeobjch=document.getElementById('CWinTypeFlag').checked;
    var wintypeflag=""
    if (wintypeobjch==true){wintypeflag="1";}

    var cyflag=document.getElementById('CCyFlag').checked;
    if (cyflag==true){cyflag="1";}
    else {cyflag="";}
    if (tjfs==true){tjfs="1";}
    else  {tjfs="0";}
    if (py==true){py="1"}
    else {py="0"}
    if (fy==true){fy="1"}
    else {fy="0"}
    if (math==t['06']){math="1"}
    else
    {math="2"}
    var dispmach=document.getElementById('CDispMachine').checked;
    if (dispmach==true) {var machine="1"}
    else {var machine="";}
    
    
    var pysure=0
    var pysureobj =document.getElementById('pysure')
    if (pysureobj)
    {
	    if (pysureobj.checked)
	    {
		    pysure=1
		    
	    }
	    else
	    {
		    pysure=0
	    }
    }
    
    
    var autopy=0
    var autopyobj =document.getElementById('AutoPyFlag')
    if (autopyobj)
    {
	    if (autopyobj.checked)
	    {
		    autopy=1
		    
	    }
	    else
	    {
		    autopy=0
	    }
    }

    var up=document.getElementById('mod');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	//alert(code+"!"+name+"!"+depid+"!"+memo+"!"+encmeth);
	alert("1");
	alert(encmeth);
	//
	//
	//
	//
	if (cspRunServerMethod(encmeth,phlid,py,fy,math,tjfs,cyflag,userid,sendflag,printflag,wintypeflag,machine,screen,scpath,pysure,autopy)!='0') {
		alert("2")
		alert(t['08']);
	return;	}
    try {		   
	    alert(t['09']);
	    window.location.reload();
		} catch(e) {};
}
function Badd_click()	
{
	selectrow=SelectedRow;
	if (combo_DeptList.getSelectedText()==""){alert(t['noloc']);return ;}
    var math=combo_math.getSelectedText();
    
    if (math=="") {	alert(t['04']);	return;}
    var scpath=document.getElementById('CScreenPath').value
    var py=document.getElementById('pyflag').checked;
    var fy=document.getElementById('fyflag').checked;
    var tjfs=document.getElementById('byfs').checked;
    var cyflag=document.getElementById('CCyFlag').checked;
    var screenflag=document.getElementById('CScreenFlag').checked;
     if (screenflag==true){var screen="1";}
    else {var screen="";}

    if (cyflag==true){cyflag="1";}
    
    else {cyflag="";}
    var send=document.getElementById('SendFlag').checked;
   var sendflag=""
    if (send==true){sendflag="1";}
    if (tjfs==true){tjfs="1";}
    else  {tjfs="0";}
      if (py==true){py="1"}
    else {py="0"}
    if (fy==true){fy="1"}
    else {fy="0"}
    if (math==t['06']){math="1"}
    else
    {math="2"}
    var dispmach=document.getElementById('CDispMachine').checked;
    if (dispmach==true) {var machine="1"}
    else {var machine="";}
     var pid=document.getElementById('ins');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
	p1=combo_DeptList.getSelectedValue();
	p2=py;
	p3=fy;
	p4=math;
	p5=tjfs;
	var wintypeobjch=document.getElementById('CWinTypeFlag').checked;
    var wintypeflag=""
    if (wintypeobjch==true){wintypeflag="1";}
    var printobjch=document.getElementById('CPrintFlag').checked;
    var printflag=""
    if (printobjch==true){printflag="1";}	//zhouyg 20120427 bug修改
    var pysure=0
    var pysureobj =document.getElementById('pysure')
    if (pysureobj)
    {
	    if (pysureobj.checked)
	    {
		    pysure=1
		    
	    }
	    else
	    {
		    pysure=0
	    }
    }
    
    
        var autopy=0
    var autopyobj =document.getElementById('AutoPyFlag')
    if (autopyobj)
    {
	    if (autopyobj.checked)
	    {
		    autopy=1
		    
	    }
	    else
	    {
		    autopy=0
	    }
    }
	//zhouyg 20120427 bug修改
	//if (cspRunServerMethod(encmeth,p1,p2,p3,p4,p5,cyflag,sendflag,wintypeflag,machine,screen,scpath,pysure,autopy)!='0') {alert(t['08']);
	if (cspRunServerMethod(encmeth,p1,p2,p3,p4,p5,cyflag,sendflag,printflag,wintypeflag,machine,screen,scpath,pysure,autopy)!='0')
	{
		alert(t['08']);
		return;
	}
	try {		   
	    alert(t['09']);
	    window.location.reload();
		} catch(e) {};
	
	

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
