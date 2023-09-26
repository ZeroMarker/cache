///DHCOPBillLocSorting.js
///Lid
///2012-07-11
///科室分类维护

function BodyLoadHandler() {
	InitDoc();
}
function InitDoc(){
	var obj=websys_$("CTLOC");
	if(obj){
		obj.onkeydown=CTLoc_OnKeyUp;
		//obj.onblur=CTLoc_OnBlur;
	}
	var obj=websys_$("LocSorting");
	if(obj){
		obj.onkeydown=LocSorting_OnKeyUp;
	}
	var obj=websys_$("BtnSaveLocSorting");
	if(obj){
		obj.onclick=BtnSaveLocSorting_OnClick;
	}
	var obj=websys_$("BtnAdd");
	if(obj){
		obj.onclick=BtnAdd_OnClick;
	}
	var obj=websys_$("BtnDel");
	if(obj){
		obj.onclick=BtnDel_OnClick;
	}
	var obj=websys_$("ClearCTLocList");
	if(obj){
		obj.onclick=ClearCTLocList_OnClick;
	}
	var obj=websys_$("ClearLinkLocList");
	if(obj){
		obj.onclick=ClearLinkLocList_OnClick;
	}
	var cookieOrderType=DHCBILL.getCookie("DHCOPBillLocSortingOrderTypeSelectIdx");
	var obj=document.getElementById("OrdType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=OrdType_OnChange;
		if(cookieOrderType!=""){
			obj.selectedIndex=cookieOrderType;
		}else{
			obj.selectedIndex=0;
		}
		//alert(obj.value+"^"+obj.options[obj.selectedIndex].text);
	}
}
function OrdType_OnChange(){
	DHCBILL.setCookie("DHCOPBillLocSortingOrderTypeSelectIdx",this.selectedIndex,30);
}
function ClearCTLocList_OnClick(){
	DHCWebD_SetObjValueB("CTLoc","");
	DHCWebD_ClearAllListA("CTLocList");
}
function ClearLinkLocList_OnClick(){
	DHCWebD_SetObjValueB("LocSorting","");
	DHCWebD_SetObjValueB("LocSortingDR","");
	DHCWebD_ClearAllListA("LocSortingLinkLocList");
}
function BtnSaveLocSorting_OnClick(){
	var LocStr=BulidLocSortingLinkLocStr();
	///alert(LocStr);
	var LocSortingDR=websys_$V("LocSortingDR");
	var Guser=session['LOGON.USERID'];
	if(LocSortingDR==""){
		alert("请选择科室类别.");
		return;
	}
	var truthBeTold = window.confirm("是否确保保存关联?");
   	if (!truthBeTold){return;}
	//
	var OrdType="";
	var OrdTypeObj=document.getElementById("OrdType");
	if (OrdTypeObj){
		OrdType=OrdTypeObj.value;
	}
	var myrtn=tkMakeServerCall("web.DHCOPBillHDDC","SaveLocSortingLinkLoc",LocSortingDR,Guser,LocStr,OrdType);
	if(myrtn==0){
		alert(myrtn+":保存成功.");
	}else{
		alert(myrtn+":保存失败.");
	}
}
function BtnAdd_OnClick(){
	TransSelectListData("CTLocList","LocSortingLinkLocList");
}
function BtnDel_OnClick(){
	TransSelectListData("LocSortingLinkLocList","CTLocList");
}
function BulidLocSortingLinkLocStr(){
	var myRecStr="";
	var obj=document.getElementById("LocSortingLinkLocList");
	if (obj){
		var nCount=obj.options.length;
		for (var i=0;i<nCount;i++){
			var tmpValue=obj.options[i].value.split("^")[0];
			if (myRecStr==""){
				myRecStr= tmpValue;
			}else{
				myRecStr=myRecStr +String.fromCharCode(2)+ tmpValue;
			}
		}
	}
	return myRecStr;
}
function TransListData(SName,TName){
	var sobj=document.getElementById(SName);
	var tobj=document.getElementById(TName);
	var myIdx=sobj.options.selectedIndex;
	if (myIdx>=0){
		var myoptobj=sobj.options[myIdx];
		var myListIdx=tobj.length;
		tobj.options[myListIdx]=new Option(myoptobj.text, myoptobj.value);
		sobj.options[myIdx]= null;
		/*if ((myIdx+1)<sobj.options.length){
			sobj.options[myIdx].selected=true;
		}else{
			sobj.options[myIdx-1].selected=true;
		}*/
	}
}
function TransSelectListData(SName,TName){
	var sobj=document.getElementById(SName);
	var tobj=document.getElementById(TName);
	var listnum=sobj.options.length;
	var SelIdxStr="";
	for (var myIdx=0;myIdx<listnum;myIdx++){
		if (sobj.options[myIdx].selected==true){
			var myoptobj=sobj.options[myIdx];
			var myListIdx=tobj.length;
			tobj.options[myListIdx]=new Option(myoptobj.text, myoptobj.value);
			SelIdxStr=SelIdxStr+"^"+myIdx;
			//sobj.options[myIdx]= null;
		}
	}
	var SelIdxNum=SelIdxStr.split("^").length;
	for(var i=SelIdxNum-1;i>=0;i--){
		var SelIdx=SelIdxStr.split("^")[i];
		if(SelIdx==="")continue;
		sobj.options[SelIdx]= null;
	}
}

function CTLoc_OnKeyUp(){
	var key=websys_getKey(e);
	if (key==13) {
		var LocSortingDR=websys_$V("LocSortingDR");
		var OrdType="";
		var OrdTypeObj=document.getElementById("OrdType");
		if (OrdTypeObj){
			OrdType=OrdTypeObj.value;
		}
		LoadCTLocList(this.value,LocSortingDR,OrdType);
	}
}
function CTLoc_OnBlur(){
	alert(this.value);
}
function LocSorting_OnKeyUp(){
	var key=websys_getKey(e);
	if (key==13) {
		window.event.keyCode=117;
		LocSorting_lookuphandler();
		//DHCWeb_Nextfocus();	
	}
}
function SelectLocSortingHandler(value){
	var tmpAry=value.split("^");
	var obj=websys_$("LocSortingDR");
	if(obj){
		obj.value=tmpAry[2];
		var OrdType="";
		var OrdTypeObj=document.getElementById("OrdType");
		if (OrdTypeObj){
			OrdType=OrdTypeObj.value;
		}
		LoadSortingLocList(tmpAry[2],OrdType);
	}
}
///加载科室列表
function LoadCTLocList(Condition,LocSortingDR,OrderType){
	DHCWebD_ClearAllListA("CTLocList");
	//var myGRRowID=DHCWebD_GetObjValue("OPGSRowID");
	///Load CT_Loc LIST
	var encmeth=DHCWebD_GetObjValue("ReadRecListEncrypt");
	if (encmeth!=""){
		alert(Condition+","+LocSortingDR+","+OrderType);
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CTLocList",Condition,LocSortingDR,OrderType);
	}
}
///加载科室分类对应的科室列表
function LoadSortingLocList(LocSortingDR,OrderType){
	DHCWebD_ClearAllListA("LocSortingLinkLocList");
	//var myGRRowID=DHCWebD_GetObjValue("OPGSRowID");
	///Load CT_Loc LIST
	var encmeth=DHCWebD_GetObjValue("ReadLocSortingLinkListEncrypt");
	if (encmeth!=""){
		//alert(LocSortingDR);
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","LocSortingLinkLocList",LocSortingDR,OrderType);
	}
}
document.body.onload = BodyLoadHandler;