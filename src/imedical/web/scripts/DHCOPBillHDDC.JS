///DHCOPBillHDDC.js
var id="",myary=""
var m_SelectedRow="-1";
var m_HDDCRowID="";
function BodyLoadHandler() {
	
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GroupID=session['LOGON.GROUPID'];
	/*var cookieHosp=DHCBILL.getCookie("HosDistrictselectIdx");
	HosDistrictobj=document.getElementById('HosDistrict');
	HosDistrictobj.options.add(new Option("东院","3"));
	HosDistrictobj.options.add(new Option("西院","2"));
	HosDistrictobj.onkeydown = nextfocus;
	HosDistrictobj.onchange=HosDistrict_onchange
	HosDistrictobj.size=1;
	HosDistrictobj.multiple=false;
	var hisdr=document.getElementById('HosDisDR')
	if(cookieHosp!=""){
		HosDistrictobj.options[cookieHosp].selected=true;
		hisdr.value=HosDistrictobj.options[cookieHosp].value;
	}
	else {
		HosDistrictobj.options[0].selected=true;
		hisdr.value=3;
	}
	*/

    var ADDobj=document.getElementById('ADD');
	if (ADDobj) ADDobj.onclick = ADD_Click
	var Modfiyobj=document.getElementById('Modfiy');
	if (Modfiyobj) Modfiyobj.onclick = Modfiy_Click;
	var deleteobj=document.getElementById('delete');
	if (deleteobj) deleteobj.onclick = delete_Click;
	var obj=websys_$("BtnLocSorting");
	if(obj){
		obj.onclick=BtnLocSorting_OnClick;
	}
	var obj=websys_$("BtnLocSortingDefine");
	if(obj){
		obj.onclick=BtnLocSortingDefine_OnClick;
	}
	var cookieOrderType=DHCBILL.getCookie("DHCOPBillHDDCOrderTypeSelectIdx");
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
	DHCBILL.setCookie("DHCOPBillHDDCOrderTypeSelectIdx",this.selectedIndex,30);
}
///科室分类维护
function BtnLocSorting_OnClick(){
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillLocSorting";
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=650,left=0,top=0')
}
///科室分类定义
function BtnLocSortingDefine_OnClick(){
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillLocSortingDefine";
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=650,left=0,top=0')
}
function HosDistrict_onchange(){
	var HosDistrictobj=document.getElementById('HosDistrict');
	var myIdx=HosDistrictobj.options.selectedIndex;
	if (myIdx==-1){return;}
	//var cookieHosp=DHCBILL.getCookie("HosDistrictselectIdx");
	//if(cookieHosp!=""){myary=HosDistrictobj.options[cookieHosp].value;}
	myary=HosDistrictobj.options[myIdx].value;
    var hisdr=document.getElementById('HosDisDR');
	if(hisdr){hisdr.value=myary;}
	DHCBILL.setCookie("HosDistrictselectIdx",myIdx,30);
	//var CTLOCobj=document.getElementById('CTLOC');
	
	
   //var hisdr=DHCWebD_GetObjValue("HosDisDR");

}
function CTLOC_onchange()
{var CTLOC=document.getElementById('CTLOC');
	var myIdx=CTLOC.options.selectedIndex;
	if (myIdx==-1){return;}
	var myary=CTLOC.options[myIdx].value;
    var LOCDR=document.getElementById('LOCDR');
	if(LOCDR){LOCDR.value=myary;}
}
function ADD_Click(){
	var LocSorting=$V("LocSorting");
    var LocSortingDRObj=document.getElementById('LocSortingDR');
    var LocSortingDR=LocSortingDRObj.value
	if((DHCWeb_Trim(LocSortingDR)=="")||(DHCWeb_Trim(LocSorting)=="")){
		return;
	}
    var place=document.getElementById('BloodDis');
    var BloodDis=place.value
    if(place==""){alert("采血地点必填");websys_setfocus('BloodDis');return;}
	var truthBeTold = window.confirm("是否确认添加?");
   	if (!truthBeTold){return;}
    var myrtn=tkMakeServerCall("web.DHCOPBillHDDC","AddHDDCDetail",LocSortingDR,BloodDis);
    var rtn=myrtn.split("^")[0];
	if(rtn==0){
		LocSortingDRObj.value="";
		place.value="";
		Find_click();
		alert("添加成功");
		websys_setfocus('HosDistrict')
	}else if(rtn=="-1005"){
		alert("该科室分类已维护采血地点.");
		return;
	}else{
		alert("添加失败");
		return;
	}	
}
function Modfiy_Click()
{   
	var LocSorting=$V("LocSorting");
    var LocSortingDRObj=document.getElementById('LocSortingDR');
    var LocSortingDR=LocSortingDRObj.value
	if((DHCWeb_Trim(LocSortingDR)=="")||(DHCWeb_Trim(LocSorting)=="")){
		return;
	}
	var id=m_HDDCRowID;
	if(id==""){
		alert("请选择记录.");
		return;
	}
	var place=document.getElementById('BloodDis').value;
    if(place==""){alert("采血地点必填");websys_setfocus('BloodDis');return;}
	var truthBeTold = window.confirm("是否确认修改?");
   	if (!truthBeTold){return;}
    var rtn=tkMakeServerCall("web.DHCOPBillHDDC","ModFiyHDDCDetail",LocSortingDR,place,id);
	if(rtn==0){
		alert("修改成功");
		Find_click();
	}else{
		alert("修改失败");
	}
  }

function delete_Click(){
	var id=m_HDDCRowID;
	if(id==""){
		alert("没有选择需要删除的行.");
		return;
	}
	var truthBeTold = window.confirm("是否确认删除?");
   	if (!truthBeTold){return;}
	var rtn=tkMakeServerCall("web.DHCOPBillHDDC","DelHDDCDetail",id);
	if(rtn==0){
		alert("删除成功");
		Find_click();
	}else {
		alert("删除失败");
	}

}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc);
	Objtbl=document.getElementById('tDHCOPBillHDDC');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=m_SelectedRow) {
		var SelRowObj=document.getElementById('TLocSortingz'+selectrow);
		var LocSortingDesc=SelRowObj.innerText;
		DHCWebD_SetObjValueB("LocSorting",LocSortingDesc);
		var SelRowObj=document.getElementById('TLocSortingDRz'+selectrow);
		var LocSortingDR=SelRowObj.innerText;
		DHCWebD_SetObjValueB("LocSortingDR",LocSortingDR);
		var SelRowObj=document.getElementById('TBloodDisz'+selectrow);
		var BloodDis=SelRowObj.innerText;
		DHCWebD_SetObjValueB("BloodDis",BloodDis);
		var SelRowObj=document.getElementById('RowIDz'+selectrow);
		m_HDDCRowID=SelRowObj.value; 
		LoadStayDepList(m_HDDCRowID,LocSortingDR);
		///
		m_SelectedRow = selectrow;
	}else{
		var SelRowObj=document.getElementById('RowIDz'+selectrow);
		m_HDDCRowID=SelRowObj.value; 
		var SelRowObj=document.getElementById('TLocSortingDRz'+selectrow);
		var LocSortingDR=SelRowObj.innerText;
		
		LoadStayDepList(m_HDDCRowID,LocSortingDR);
	}
}
function LocSortingSelHandler(value){
	var obj=document.getElementById('LocSortingDR');
	obj.value=value.split("^")[2];
}
///加载特殊采血地点
function LoadStayDepList(HDDCRowID,LocSortingDR){
	
	parent.frames['DHCOPBillHDDCArcim'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillHDDCArcim&HDDCRowID="+HDDCRowID+"&LocSortingDR="+LocSortingDR;
}

function DHCWeb_Trim(str){   
	 return str.replace(/(^\s*)|(\s*$)/g, "");  
}  
//删除左边的空格
function DHCWeb_LTrim(str){   
	return str.replace(/(^\s*)/g,"");  
}  
//删除右边的空格
function DHCWeb_RTrim(str){   
	return str.replace(/(\s*$)/g,"");  
}  
document.body.onload = BodyLoadHandler;

