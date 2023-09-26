function BodyLoadHandler()
{
    var SelHos=DHCC_GetElementData('Hospital');
    if (document.getElementById('Hospital')){
        var SelHosStr=DHCC_GetElementData('GetHosStr');
	    combo_SelHos=dhtmlXComboFromStr("Hospital",SelHosStr);
        combo_SelHos.enableFilteringMode(true);
        combo_SelHos.selectHandle=combo_SelHosKeydownhandler;
        combo_SelHos.setComboText(SelHos);           
	}
	var SelCatSub=DHCC_GetElementData('SelCatSub');
    if (document.getElementById('SelCatSub')){
        var SelCatSubStr=DHCC_GetElementData('GetCatSubStr');
	    combo_SelCatSub=dhtmlXComboFromStr("SelCatSub",SelCatSubStr);
        combo_SelCatSub.enableFilteringMode(true);
        combo_SelCatSub.selectHandle=combo_SelCatSubKeydownhandler;
        combo_SelCatSub.setComboText(SelCatSub);           
	}
	
	var CTOrdCatsub=DHCC_GetElementData('CTOrdCatsub');
    if (document.getElementById('CTOrdCatsub')){
        var CTOrdCatsubStr=DHCC_GetElementData('GetCatSubStr');
	    combo_CTOrdCatsub=dhtmlXComboFromStr("CTOrdCatsub",CTOrdCatsubStr);
        combo_CTOrdCatsub.enableFilteringMode(true);
        combo_CTOrdCatsub.selectHandle=combo_CTOrdCatsubKeydownhandler;
        combo_CTOrdCatsub.setComboText(CTOrdCatsub);           
	}
	
	var obj=document.getElementById('OrdCat');
    if (obj) obj.ondblclick =OrdCat_Click;
	var obj=document.getElementById('OrdCatSub')
    if (obj) obj.ondblclick=OrdCatSub_Click
    
    var obj=document.getElementById('Copy');
    if (obj) obj.onclick =mCopy_Click;
    
    
}

function OrdCatSub_Click()
{
	var HosIdobj=document.getElementById('HosId');
	if (HosIdobj) {var HosId=HosIdobj.value}
	var OrdCatSub=document.getElementById('OrdCatSub');
    if (OrdCatSub.selectedIndex==-1){
	   return;
	   }
	var index=OrdCatSub.selectedIndex;
	var OrdCatSubId=OrdCatSub.options[index].value;
	var CatSubIdobj=document.getElementById('CatSubId')
	if (CatSubIdobj) {CatSubIdobj.value=OrdCatSubId}
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOrdCatSubRecLocAdd&CatSubId="+OrdCatSubId+"&HosId="+HosId  
	parent.frames['DHCOrdCatSubRecLocAdd'].document.location.href=lnk	;
	var HosIdobj=document.getElementById('HosId');
	if (HosIdobj) {var HosId=HosIdobj.value}
	var SelCatSubobj=document.getElementById('SelCatSub');
	if (SelCatSubobj) {SelCatSubobj.value=""}

}

function combo_SelHosKeydownhandler(e){

	var SelHosId=combo_SelHos.getActualValue();
    DHCC_SetElementData('HosId',SelHosId);
	var CatSubIdobj=document.getElementById('CatSubId')
	if (CatSubIdobj) {var CatSubId=CatSubIdobj.value}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOrdCatSubRecLocAdd&CatSubId="+CatSubId+"&HosId="+SelHosId  
	parent.frames['DHCOrdCatSubRecLocAdd'].document.location.href=lnk	;
	 
}

function combo_SelCatSubKeydownhandler(e){

	var SelCatSubId=combo_SelCatSub.getActualValue();
	//mCatSubId=SelCatSubId
    //DHCC_SetElementData('SelCatSubId',SelCatSubId);
    var HosIdobj=document.getElementById('HosId');
	if (HosIdobj) {var HosId=HosIdobj.value}
	
	var CatSubIdobj=document.getElementById('CatSubId')
	if (CatSubIdobj) {CatSubIdobj.value=SelCatSubId	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOrdCatSubRecLocAdd&CatSubId="+SelCatSubId+"&HosId="+HosId  
	parent.frames['DHCOrdCatSubRecLocAdd'].document.location.href=lnk	;
	 
}


function combo_CTOrdCatsubKeydownhandler(e){

	var CTOrdCatsubId=combo_CTOrdCatsub.getActualValue();
	var CTCatSubIdobj=document.getElementById('CTCatSubId')
	if (CTCatSubIdobj) {CTCatSubIdobj.value=CTOrdCatsubId}
	 
}



function OrdCat_Click()
{
	var OrdCat=document.getElementById('OrdCat');
	var ArcCat=document.getElementById('OrdCatSub');
	var GetItemCat=document.getElementById('GetArcItemCat').value;
    if (OrdCat.selectedIndex==-1){
	   return;
	   }
	var index=OrdCat.selectedIndex;
	var Str=cspRunServerMethod(GetItemCat,OrdCat.options[index].value);
	if (Str!="")
	{
		additem(Str,ArcCat);
	}
}


function additem(Str,dlist)

{
    var StrArr=Str.split("^");
	var i;
	dlist.options.length=0;
	for (i=0;i<StrArr.length;i++)
	{
		var item=StrArr[i].split("!");
		var objSelected = new Option(item[1], item[0]);
	    dlist.options[dlist.options.length]=objSelected;
	}
}

///复制接收科室  从 医嘱子类 复制到子类
function mCopy_Click()
{
	var SelCatSubID=document.getElementById('CatSubId').value
	var CTCatSubID=document.getElementById('CTCatSubId').value
	var UserId=session['LOGON.USERID']
	if (SelCatSubID=="")
	{
		alert("请选择“医嘱子类”")
		return;
	}
	if (CTCatSubID=="")
	{
		alert("请选择“复制到医嘱子类”")
		return;
	}
	var MethodCopyCatsubRecLoc=document.getElementById('MethodCopyCatsubRecLoc').value;
    if (MethodCopyCatsubRecLoc) {
	    var ret=cspRunServerMethod(MethodCopyCatsubRecLoc,UserId,SelCatSubID,CTCatSubID)
	    var retstr=ret.split("^")
	    
	    if (retstr[0]=="0") {alert("完成")}
	    else {
	   var job=retstr[1]

       var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCOrdCatSubRecLocJournal&Job='+job
        window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=400,left=100,top=100')
		    
		    }
    }

		
}

document.body.onload = BodyLoadHandler;