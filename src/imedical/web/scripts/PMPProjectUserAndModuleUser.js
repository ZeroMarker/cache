//PMPProjectUserAndModuleUser.js
var objtbl=""
var CurrentSel=""
var admdepobj=document.getElementById('ModuleDR');
if (admdepobj) admdepobj.onkeydown=getadmdep1
function getadmdep1()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ModuleDR_lookuphandler();
		}
}
function BodyLoadHandler()
{
	var obj;
	
	obj=document.getElementById("ModultAdd") ;
	if (obj) obj.onclick=ModultAdd;
	obj=document.getElementById("delModule");
	if (obj) obj.onclick=delModule;
	//alert(obj)
}

function delModule(){
	var TModuleUserid=document.getElementById('TModuleUserid').value;
	//alert(TModuleUserid)
	if (TModuleUserid!="") {
		var delstr=tkMakeServerCall("web.PMPModuleUser","delModuleUser",TModuleUserid);
		if(delstr){alert("已删除!")}
		window.location.reload();
		}else{
			alert("请选择要删除的对象！")
			}
	}
function ModultAdd(){
	var ProjectRowid = document.getElementById('ProjectRowid').value;
	var ModuleDRHidden = document.getElementById('ModuleDRHidden').value;
	var MduStDate = document.getElementById('MduStDate').value;
	var MduStTime = document.getElementById('MduStTime').value;
	var MduEnDate = document.getElementById('MduEnDate').value;
	var MduEnTime = document.getElementById('MduEnTime').value;
	var remark = document.getElementById('remark').value;
	var TModuleUserid=document.getElementById('TModuleUserid').value;
	if(ModuleDRHidden=="")
	{
		alert("模块不能为空！");
		return;
		}
	var insertstr=tkMakeServerCall("web.PMPModuleUser","insertModuleUser",ProjectRowid,ModuleDRHidden,remark,MduStDate,MduEnDate,MduStTime,MduEnTime,TModuleUserid);
    	if(insertstr){
	    	alert("更新成功！")
    		}
		window.location.reload();
	}
function LookUp_Module(value){
	var info=value.split("^");
    document.getElementById("ModuleDRHidden").value=info[1];
    document.getElementById('ModuleDR').value = info[0];
	
	}

function delModule(value){
	var updatestr=tkMakeServerCall("web.PMPProjectUser","updateProjectUser",ProDRHidden,SSUserid,dicid,phone,date1,time1,date2,time2,remark,ProjectId);
	}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tPMPProjectUserAndModuleUser');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var SelRowObj=document.getElementById('TMDURemarkz'+selectrow);
	document.getElementById("remark").value=SelRowObj.innerText
	
	var SelRowObj1=document.getElementById('TMDUStDatez'+selectrow);
	document.getElementById("MduStDate").value=SelRowObj1.innerText
	
	var SelRowObj2=document.getElementById('TMDUEnDatez'+selectrow);
	document.getElementById("MduEnDate").value=SelRowObj2.innerText
	
	var SelRowObj3=document.getElementById('TMDUStTimez'+selectrow);
	document.getElementById("MduStTime").value=SelRowObj3.innerText
	
	var SelRowObj4=document.getElementById('TMDUEnTimez'+selectrow);
	document.getElementById("MduEnTime").value=SelRowObj4.innerText
	
	var SelRowObj5=document.getElementById('TMDUModulez'+selectrow);
	document.getElementById("ModuleDR").value=SelRowObj5.innerText
	
	var SelRowObj5=document.getElementById('TMDUModuleIDz'+selectrow);
	document.getElementById("ModuleDRHidden").value=SelRowObj5.innerText
	
	var SelRowObj6=document.getElementById('TRowidz'+selectrow);
	document.getElementById("TModuleUserid").value=SelRowObj6.innerText
	
	
	var SelRowObj
	var obj	
	if (selectrow==CurrentSel){	
	CurrentSel=0;
	//alert("2")
	//pama="";     //取消选中
	//theTowPama="";
	//RetrieveOrdCat(theTowPama);
	document.getElementById("TModuleUserid").value="";
	document.getElementById("remark").value="";
	document.getElementById("MduStDate").value="";
	document.getElementById("MduEnDate").value="";
	document.getElementById("MduStTime").value="";
	document.getElementById("MduEnTime").value="";
	document.getElementById("ModuleDR").value="";
	document.getElementById("ModuleDRHidden").value="";
	return;
	}	
	
	CurrentSel=selectrow
	SelectedRow = selectrow;
}

document.body.onload=BodyLoadHandler;