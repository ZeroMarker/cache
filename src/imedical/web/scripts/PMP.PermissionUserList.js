//权限明细管理
//张枕平
//2014-11-23
var SelectedRow = 0;
var CurrentSel = 0;
var tables = document.getElementsByTagName("table");
var admdepobj=document.getElementById('XQKSLX');
if (admdepobj) admdepobj.onkeydown=getadmdep1;
var admdepobj=document.getElementById('XQQXYH');
if (admdepobj) admdepobj.onkeydown=getadmdep2;
function BodyLoadHandler(){
	NotShow();
	obj=document.getElementById("New") ;
	if (obj) obj.onclick=newAdd_Click;
	obj=document.getElementById("Delete") ;
	if (obj) obj.onclick=Delete_Click;
	obj=document.getElementById("Update") ;
	if (obj) obj.onclick=Update_Click;
	}
function newAdd_Click(){
	var XQRowid=document.getElementById("Rowid").value
	var XQQXYHvalue=document.getElementById('XQuserid').value;
	if(XQRowid==""){
		alert(t["1001"]);
		return;
		}
	else {
		if(XQQXYHvalue==""){
			alert(t["1002"]);
			return;
			}
		else {
	        var XQKSLXvalue=document.getElementById('XQkslxid').value;
	        var input=XQRowid+"^"+XQQXYHvalue+"^"+XQKSLXvalue;
	        var addstr=tkMakeServerCall("web.PMP.ImproventFindShenhe","insertPermisBusiness",input);
	        if(addstr=="1005"){
		        alert(t[addstr]);
		        var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMP.PermissionUserList&Rowid="+XQRowid;
 		        window.location.href=lnk;
		        }
		     else {
			     alert(t[addstr]);
			     return;
			     }
		}
	}
}
function Delete_Click(){
	var XQRowid=document.getElementById("Rowid").value
	var XQQXYHvalue=document.getElementById('XQuserid').value;
	var XQKSLXvalue=document.getElementById('XQkslxid').value;
	var input=XQRowid+"^"+XQQXYHvalue+"^"+XQKSLXvalue;
	if(XQRowid==""){
		alert(t["1001"]);
		return;
		}
	else {
		if(XQQXYHvalue==""){
			alert(t["1002"]);
			return;
			}
		else {
			if(XQKSLXvalue==""){
				var myrtn=window.confirm(t["1010"]);
                 if (myrtn){
	            var deletestr=tkMakeServerCall("web.PMP.ImproventFindShenhe","DeletePermisBusiness",input,"ok");
	             if(deletestr=="1007"){
		             alert(t[deletestr]);
		             return;
		             }
		          else {
                      alert(t[deletestr]);
                      lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMP.PermissionUserList&Rowid="+XQRowid;
	                  location.href=lnk;
		          }
                 }
	             if (!myrtn){
		        return myrtn;
	        	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMP.PermissionUserList&Rowid="+XQRowid;
	            location.href=lnk;
	        }
		  }
		 else{
			 var input=XQRowid+"^"+XQQXYHvalue+"^"+XQKSLXvalue;
	         var deletestr=tkMakeServerCall("web.PMP.ImproventFindShenhe","DeletePermisBusiness",input,"no");
	         if(deletestr=="1007"){
		         alert(t[deletestr]);
		         return;
		         }
		     else {
                alert(t[deletestr]);
                lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMP.PermissionUserList&Rowid="+XQRowid;
	            location.href=lnk;
		          }
			 }
		}
	
	}
}
function Update_Click(){
	var XQRowid=document.getElementById("Rowid").value
	var XQQXYHvalue=document.getElementById('XQuserid').value;
	var XQKSLXvalue=document.getElementById('XQkslxid').value;
	var ycysvalue=document.getElementById('ycys').value;
	var input=XQRowid+"^"+XQQXYHvalue+"^"+XQKSLXvalue+"^"+ycysvalue;
	if(XQRowid==""){
		alert(t["1001"]);
		return;
		}
	else {
		if(XQQXYHvalue==""){
			alert(t["1002"]);
			return;
			}
		else{
			var updatestr=tkMakeServerCall("web.PMP.ImproventFindShenhe","UpdatePermisBusiness",input);
	        if(deletestr=="1011"){
		        alert(t[updatestr]);
		        return;
		        }
		    else {
                alert(t[updatestr]);
                lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMP.PermissionUserList&Rowid="+XQRowid;
	            location.href=lnk;
	            }
			}
	}
}
function Show(){
	trRep = tables[2];
	trRep.style.display = '';
	var obj=document.getElementById('XQQXJB');
	obj.style.display = '';
	obj.disabled=true;
	var obj=document.getElementById('XQQXMS');
	obj.style.display = '';
	obj.disabled=true;
	var obj=document.getElementById('XQQXYH');
	obj.style.display = '';
	var obj=document.getElementById('XQKSLX');
	obj.style.display = '';
	}
function NotShow(){
	trRep = tables[2];
	trRep.style.display = 'none';
	}
function SelectXQKSLX(str){
	 var info=str.split("^");
    document.getElementById("XQKSLX").value=info[0];
    document.getElementById('XQkslxid').value = info[1];
    getMaxLevel();
	}
function SelectXQQXYH(str){
	var info=str.split("^");
    document.getElementById("XQQXYH").value=info[0];
    document.getElementById('XQuserid').value = info[2];
	}
function getadmdep1()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  XQKSLX_lookuphandler();
		}
	}
function getadmdep2()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  XQQXYH_lookuphandler();
		}
	}
function SelectRowHandler()	{
	 var eSrc=window.event.srcElement;
	 objtbl=document.getElementById('tPMP.PermissionUserList');
	 var rowObj=getRow(eSrc);
     selectrow=rowObj.rowIndex;
     if (!selectrow) return;
     var SelRowObj
     var obj	
     if (selectrow==CurrentSel){	
       CurrentSel=0;
       NotShow();
       document.getElementById('XQQXJB').value="";
	   document.getElementById('XQQXMS').value="";
	   document.getElementById('XQQXYH').value="";
	   document.getElementById('XQKSLX').value="";
	   document.getElementById('ycys').value=""; 
       return;
	 }
	 Show();
	 CurrentSel=selectrow;
     var row=selectrow;
	var SelRowObj=document.getElementById('QXJBz'+row);
	var SelRowObj1=document.getElementById('QXMSz'+row);
	var SelRowObj2=document.getElementById('QXYHz'+row);
	var SelRowObj3=document.getElementById('QXGXRQz'+row);
    var SelRowObj4=document.getElementById('QXGXSJz'+row);
    var SelRowObj5=document.getElementById('LocLXz'+row);
    var SelRowObj6=document.getElementById('idz'+row);
	document.getElementById('XQQXJB').value=SelRowObj.innerText;
	document.getElementById('XQQXMS').value=SelRowObj1.innerText;
	document.getElementById('XQQXYH').value=SelRowObj2.innerText;
	document.getElementById('XQKSLX').value=SelRowObj5.innerText;
	document.getElementById('ycys').value=SelRowObj6.value; 
}
document.body.onload=BodyLoadHandler;