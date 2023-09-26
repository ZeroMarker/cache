
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=Query_click;}
	var obj=document.getElementById('cmdDel');
	if (obj){ obj.onclick=Delete_click;}
	iniForm();
}
function iniForm()
{
	var objMrType=document.getElementById("cboType");
	if (objMrType){
		objMrType.size=1;
		objMrType.multiple=false;
		
		var obj=document.getElementById("cIndex");
		if (obj){
			if (obj.value!="") {
				var i=obj.value;
				objMrType.selectedIndex=i;
			}else{
				objMrType.selectedIndex=0;
			}
		}
		
		var cType="";
		var Idx=objMrType.options.selectedIndex;
		if (Idx>-1){
			cType=objMrType.options[Idx].value;
		}
		var obj=document.getElementById("MethodGetMaxNoByMrType");
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,cType);
	   	var obj=document.getElementById("CurrMaxNo");
	   	if (obj){obj.value=ret;}
	}
}
function Query_click()
{
	var cType="",cIndex="",cFlag="",cLoc="",cDep="",cEvaDate="",cNoFrom="",cNoTo="",cCurrMaxNo=""
	var obj=document.getElementById("cboType");
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx>-1){
			cType=obj.options[Idx].value;
			cIndex=Idx;
		}
	}
	
	var obj=document.getElementById("txtDep");
	if (obj){
		if (Trim(obj.value)!=""){
			cDep=Trim(obj.value);
			var obj=document.getElementById("txtDepId");
			if (obj){
				cLoc=Trim(obj.value);
			}
		}else{
			cLoc="";
		}
	}
	
	var obj=document.getElementById("chkUse");
	if (obj){
		if (obj.checked==true){
			cFlag="Y";
		}else{
			cFlag="N";
		}
	}
	
	var obj=document.getElementById("txtNoFrom");
	if (obj){var cNoFrom=Trim(obj.value);}
	var obj=document.getElementById("txtNoTo");
	if (obj){var cNoTo=Trim(obj.value);}
	/*
	if (cNoFrom!=""){
		cNoFrom=parseInt(cNoFrom);
		if (isNaN(cNoFrom)) {
			return;
		}
	}
	if (cNoTo!=""){
		cNoTo=parseInt(cNoTo);
		if (isNaN(cNoTo)) {
			cNoTo=""
			return;
		}
	}
	if ((cNoFrom!="")&&(cNoTo!="")){
		if (cNoFrom>cNoTo){
			alert(t['NoFromNoToFalse'])
			return;
		}
	}
	*/
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.No.List" + "&Type=" +cType+"&Loc="+cLoc+"&Flag="+cFlag+"&NoFrom="+cNoFrom+"&NoTo="+cNoTo+"&Dep="+cDep+"&CurrMaxNo="+cCurrMaxNo+"&cIndex="+cIndex;
    location.href=lnk;
}

function LookUpDep(str)
{
	var objDepId=document.getElementById('txtDepId');
	var objDep=document.getElementById('txtDep');
	var tem=str.split("^");
	objDepId.value=tem[0];
	objDep.value=tem[1];
}

function Delete_click()
{
	var objtbl=document.getElementById("tDHC_WMR_No_List");
	var objchk=document.getElementById("SelectAll");
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var Rowid="";
		if(objchk){
			if (objchk.checked==true){
				Rowid=document.getElementById("Rowidz"+i).value;
			}
		}else{
			var obj=document.getElementById("Deletez"+i)
		   	if (obj){
			   	if (obj.checked==true){
				   	Rowid=document.getElementById("Rowidz"+i).value;
				}
		   	}
		}
		if (Rowid!=""){
    		var obj=document.getElementById("ClsDel");
			if (obj) {var encmeth=obj.value} else {var encmeth=''}
			var Flg=cspRunServerMethod(encmeth,Rowid);
    		if (Flg<0){
	    		alert(t['DeleteDataFalse']+"--"+Rowid);
    		}
		}
	}
	
	window.Query_click();
}

function SelectRowHandler()	{
	var txtRowid=""
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow){return};
	var SelRowObj=document.getElementById('Rowidz'+selectrow);
	if (SelRowObj){txtRowid=SelRowObj.innerText;}
	else{txtRowid="";}
}

document.body.onload = BodyLoadHandler;



	//javascript remove space
	function LTrim(str){ //remove leading space
		var i;
		for(i=0;i < str.length; i ++)
		{
			 if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(i,str.length);
		return str;
	}
	
	function RTrim(str){
		var i;
		for(i = str.length - 1; i>=0; i--)
		{
			if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(0,i+1);
		return str;
	}
	
	function Trim(str){
		return LTrim(RTrim(str));
	} 