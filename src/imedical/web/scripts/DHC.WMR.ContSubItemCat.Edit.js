/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.ContSubItemCat.Edit.JS

AUTHOR: ZF , Microsoft
DATE  : 2007-7

COMMENT: DHC.WMR.ContSubItemCat.Edit

========================================================================= */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdAdd");
	if (obj){obj.onclick=Add_click;}
	var obj=document.getElementById("cmdDel");
	if (obj){obj.onclick=Del_click;}
	inform();
}

function inform(){
	var cContSubRowId=""
	var obj=document.getElementById("ContSubRowId");
	if (obj){
		cContSubRowId=obj.value;
	}
	if (cContSubRowId!=""){
		var obj=document.getElementById('MethodGetContSubByRowId');
		if (obj) {var encmeth=obj.value} else {var encmeth=''}
		var ContSubInfo=cspRunServerMethod(encmeth,cContSubRowId);
		if (ContSubInfo=="") {
			return;
		}else{
			Temp=ContSubInfo.split("^");
			var objc=document.getElementById('cContSubDesc');
			if (objc){objc.value=Temp[2];}
		}
	}
}

function Add_click()
{
	var i;
	var cContSubRowId="",cItemCatId="";
	obj=document.getElementById("ContSubRowId");
	if (obj){
		cContSubRowId=obj.value;
	}
	if (cContSubRowId=="") return;
	var objAList=document.getElementById("lstAllItemCat");
	if (objAList.selectedIndex==-1){return;}
	for (i=0;i<objAList.options.length;i++){
		if (objAList.options[i].selected){
			cItemCatId=objAList[i].value;
			if (cItemCatId!=""){
				var Condition=cContSubRowId+"^^"+cItemCatId;
				var obj=document.getElementById('MethodUpdateContSubItemCat');
			    if (obj) {var encmeth=obj.value} else {var encmeth=''}
			    var Id=cspRunServerMethod(encmeth,Condition);
			    Temp=Id.split("||")
			    if (Temp[0]==-3){
					//alert(t['AddFalse01']+"--"+cItemCatId);
				}else{
					if ((Temp[0]<1)&&(Temp[0]!=-3)){
						alert(t['AddFalse02']);
					}
				}
			}
		}
	}
	location.reload()
}

function Del_click()
{
	if(confirm(t['DeleteRecordTrue'])){
		//true
	}else{
		//false
    	return;
    }
	var i;
	var Flag="4";
	
	objSList=document.getElementById("lstSelectItemCat");
	if (objSList.selectedIndex==-1) return;
	for (i=0;i<objSList.options.length;i++){
		if (objSList.options[i].selected){
			var cContSubItemCatId=objSList[i].value;
			if (cContSubItemCatId!=""){
				var Condition=cContSubItemCatId+"^"+Flag;
				var obj=document.getElementById('MethodDeleteContInfo');
			    if (obj) {var encmeth=obj.value} else {var encmeth=''}
			    var Id=cspRunServerMethod(encmeth,Condition);
			    if (Id<0){
				    alert(t['DelFalse']);
				}
			}
		}
	}
	location.reload()
}

document.body.onload = BodyLoadHandler;
