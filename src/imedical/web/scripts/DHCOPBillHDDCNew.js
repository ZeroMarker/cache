///DHCOPBillHDDCNew.js
var id="",myary=""
var m_SelectedRow="-1";
var m_HDDCRowID="";
function BodyLoadHandler() {
	
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GroupID=session['LOGON.GROUPID'];
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
	var obj=websys_$("Clear");
	if(obj){
		obj.onclick=Clear_OnClick;
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
		//obj.selectedIndex=0;
		//alert(obj.value+"^"+obj.options[obj.selectedIndex].text);
	}
	var obj=document.getElementById("Locgroupflag");
	if(obj){
	   obj.size=1;//ֻ��ʾһ��
	   obj.multiple=false//����ѡȡ���ֵ
	   obj.selectedIndex=0; 
	}
	var varItem=new Option("","")
	obj.options.add(varItem)
	var varItem=new Option("����","L")
	obj.options.add(varItem)
	var varItem= new Option("������","G")
	obj.options.add(varItem)
}
function Locgroupflag_OnChange(){
	var obj=document.getElementById("Locgroupflag");
	var index=obj.options.selectedIndex
	obj.options[index].selected = true;
	document.getElementById("LocgroupflagID").value=obj.options[index].value;
	alert(document.getElementById("LocgroupflagID").value)
}
function OrdType_OnChange(){
	DHCBILL.setCookie("DHCOPBillHDDCOrderTypeSelectIdx",this.selectedIndex,30);
}
function HosDistrict_onchange(){
	var HosDistrictobj=document.getElementById('HosDistrict');
	var myIdx=HosDistrictobj.options.selectedIndex;
	if (myIdx==-1){return;}
	myary=HosDistrictobj.options[myIdx].value;
    var hisdr=document.getElementById('HosDisDR');
	if(hisdr){hisdr.value=myary;}
	DHCBILL.setCookie("HosDistrictselectIdx",myIdx,30);
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
	var Loc=websys_$V("CTLOC");
    var LOCDRObj=document.getElementById('LOCDR');
    var LOCDR=LOCDRObj.value
	var Locgroupflag=document.getElementById("Locgroupflag").value
    var OrdType=document.getElementById("OrdType").value
	if((DHCWeb_Trim(LOCDR)=="")||(DHCWeb_Trim(Loc)=="")||(DHCWeb_Trim(OrdType)=="")||(DHCWeb_Trim(Locgroupflag)=="")){
		if(DHCWeb_Trim(OrdType)=="")
		{
			alert("��ѡ��걾")
			}
		if(DHCWeb_Trim(Locgroupflag)=="")
		{
			alert("��ѡ��������")
			}
		return;
	}
	
    var place=document.getElementById('BloodDis');
    var BloodDis=place.value;
    if(BloodDis==""){alert("��Ѫ�ص����");websys_setfocus('BloodDis');return;}
	var truthBeTold = window.confirm("�Ƿ�ȷ�����?");
   	if (!truthBeTold){return;}
   	var ReCTLOC=websys_$V("ReCTLOC");
    var ReCTLOCIDObj=document.getElementById('ReCTLOCID');
    var ReCTLOCID=ReCTLOCIDObj.value
    if(DHCWeb_Trim(LOCDR)=="")
    {
	    ReCTLOCID=""
	}
	var ORDReLoc=websys_$V("ORDReLoc");
    var ORDReLocIDObj=document.getElementById('ORDReLocID');
    var ORDReLocID=ORDReLocIDObj.value
    if(DHCWeb_Trim(ORDReLoc)=="")
    {
	    ORDReLocID=""
	}
    var CheckFlag=document.getElementById("CheckMR").checked;
    var rtnstr=tkMakeServerCall("web.DHCOPBillHDDC","checkLOCBloodDis",OrdType,LOCDR,CheckFlag,ORDReLocID);
    if(rtnstr==1){
	    alert("�Ѵ���Ĭ��ֵ��");
	    return;
    }
    var myrtn=tkMakeServerCall("web.DHCOPBillHDDC","AddHDDCDetailNew",LOCDR,OrdType,BloodDis,ReCTLOCID,CheckFlag,Locgroupflag,ORDReLocID);
    var rtn=myrtn.split("^")[0];
	if(rtn==0){
		LOCDRObj.value="";
		place.value="";
		Find_click();
		alert("��ӳɹ�");
		websys_setfocus('HosDistrict')
	}else if(rtn=="-1005"){
		alert("�Ŀ��ҷ�����ά����Ѫ�ص�.");
		return;
	}else{
		alert("���ʧ��");
		return;
	}	
}
function Modfiy_Click()
{ 
     
	var Loc=websys_$V("CTLOC");
    var LOCDRObj=document.getElementById('LOCDR');
    var LOCDR=LOCDRObj.value
    var OrdType=document.getElementById("OrdType").value
	if((DHCWeb_Trim(LOCDR)=="")||(DHCWeb_Trim(OrdType)=="")){
		if(DHCWeb_Trim(OrdType)=="")
		{
			alert("��ѡ��걾")
			}
		return;
	}
	var id=m_HDDCRowID;
	if(id==""){
		alert("��ѡ���¼.");
		return;
	}
	var place=document.getElementById('BloodDis').value;
    if(place==""){alert("��Ѫ�ص����");websys_setfocus('BloodDis');return;}
	var truthBeTold = window.confirm("�Ƿ�ȷ���޸�?");
   	if (!truthBeTold){return;}
   	var ReCTLOC=websys_$V("ReCTLOC");
    var ReCTLOCIDObj=document.getElementById('ReCTLOCID');
    var ReCTLOCID=ReCTLOCIDObj.value
    if(DHCWeb_Trim(ReCTLOC)=="")
    {
	    ReCTLOCID=""
	}
	var ORDReLoc=websys_$V("ORDReLoc");
    var ORDReLocIDObj=document.getElementById('ORDReLocID');
    var ORDReLocID=ORDReLocIDObj.value
    if(DHCWeb_Trim(ORDReLoc)=="")
    {
	    ORDReLocID=""
	}
    var CheckFlag=document.getElementById("CheckMR").checked;
    //alert(OrdType+","+LOCDR+","+CheckFlag+","+ORDReLocID);
    var rtnstr=tkMakeServerCall("web.DHCOPBillHDDC","checkLOCBloodDis",OrdType,LOCDR,CheckFlag,ORDReLocID);
    if(rtnstr==1){
	    alert("�Ѵ���Ĭ��ֵ��");
	    return;
    }
    //alert(LOCDR+","+OrdType+","+place+","+id+","+ReCTLOCID+","+CheckFlag+","+ORDReLocID);
    var rtn=tkMakeServerCall("web.DHCOPBillHDDC","ModFiyHDDCDetailNew",LOCDR,OrdType,place,id,ReCTLOCID,CheckFlag,ORDReLocID);
	if(rtn==0){
		alert("�޸ĳɹ�");
		Find_click();
	}else{
		alert("�޸�ʧ��");
	}
  }

function delete_Click(){
	var id=m_HDDCRowID;
	if(id==""){
		alert("û��ѡ����Ҫɾ������.");
		return;
	}
	var truthBeTold = window.confirm("�Ƿ�ȷ��ɾ��?");
   	if (!truthBeTold){return;}
	var rtn=tkMakeServerCall("web.DHCOPBillHDDC","DelHDDCDetail",id);
	if(rtn==0){
		alert("ɾ���ɹ�");
		Find_click();
	}else {
		alert("ɾ��ʧ��");
	}

}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc);
	Objtbl=document.getElementById('tDHCOPBillHDDCNew');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=m_SelectedRow) {
		var SelRowObj=document.getElementById('TLocSortingz'+selectrow);
		var LocSortingDesc=SelRowObj.innerText;
		DHCWebD_SetObjValueB("CTLOC",LocSortingDesc);
		var SelRowObj=document.getElementById('TLocSortingDRz'+selectrow);
		var LocSortingDR=SelRowObj.value;
		DHCWebD_SetObjValueB("LOCDR",LocSortingDR);
		var SelRowObj=document.getElementById('TReCTLOCz'+selectrow);
		var TReCTLOC=SelRowObj.innerText;
		DHCWebD_SetObjValueB("ReCTLOC",TReCTLOC);
		var SelRowObj=document.getElementById('TReCTLOCIDz'+selectrow);
		var TReCTLOCID=SelRowObj.value;
		DHCWebD_SetObjValueB("ReCTLOCID",TReCTLOCID);
		
		var SelRowObj=document.getElementById('TORDReLocz'+selectrow);
		var TReCTLOC=SelRowObj.innerText;
		DHCWebD_SetObjValueB("ORDReLoc",TReCTLOC);
		var SelRowObj=document.getElementById('TORDReLocIDz'+selectrow);
		var TReCTLOCID=SelRowObj.value;
		DHCWebD_SetObjValueB("ORDReLocID",TReCTLOCID);
		
		var SelRowObj=document.getElementById('TBloodDisz'+selectrow);
		var BloodDis=SelRowObj.innerText;
		DHCWebD_SetObjValueB("BloodDis",BloodDis);
		var SelRowObj=document.getElementById('RowIDz'+selectrow);
		m_HDDCRowID=SelRowObj.value; 
		var SelRowObj=document.getElementById('myOrderTypez'+selectrow);
		var myOrderType=SelRowObj.value; 
		var OrdTypeobj=document.getElementById("OrdType")
		for ( var i=0;i<OrdTypeobj.options.length; i++ )
        	{
            		if (OrdTypeobj.options[i].value==myOrderType)
            		{
                	OrdTypeobj.selectedIndex = i ;
                	break;
              		}
         	}
		var SelRowObj=document.getElementById('TLocgroupflagIDz'+selectrow);
		var LocgroupflagID=SelRowObj.value; 
		
		var Locgroupflagobj=document.getElementById("Locgroupflag")
		for ( var i=0;i<Locgroupflagobj.options.length; i++ )
        	{
            		if (Locgroupflagobj.options[i].value==LocgroupflagID)
            		{
                	Locgroupflagobj.selectedIndex = i ;
                	break;
              		}
         	}
         	var SelRowObj=document.getElementById('TCheckMRz'+selectrow);
		var TCheckMR=SelRowObj.innerText;
		if(TCheckMR=="Ĭ��")
		{
         		document.getElementById("CheckMR").checked=true
		}
		else
		{
			document.getElementById("CheckMR").checked=false
		}
		var Locgroupflagobj=document.getElementById("Locgroupflag");
		var Myobj=websys_$('Myid');
  		if (Myobj){
   		var imgname="ld"+Myobj.value+"i"+"Locgroupflag";
   		var Locgroupflagobj1=document.getElementById(imgname);
  		}
	
		Locgroupflagobj.disabled=true
	 	Locgroupflagobj1.style.display="none";
	
		m_SelectedRow = selectrow;
	}else{
		var SelRowObj=document.getElementById('RowIDz'+selectrow);
		m_HDDCRowID=SelRowObj.value; 
		var SelRowObj=document.getElementById('TLocSortingDRz'+selectrow);
		var LocSortingDR=SelRowObj.innerText;
		DHCWebD_SetObjValueB("CTLOC","");
		DHCWebD_SetObjValueB("LOCDR","");
		DHCWebD_SetObjValueB("ReCTLOC","");
		DHCWebD_SetObjValueB("ReCTLOCID","");
		DHCWebD_SetObjValueB("BloodDis","");
		DHCWebD_SetObjValueB("ORDReLoc","");
		DHCWebD_SetObjValueB("ORDReLocID","");
		document.getElementById("CheckMR").checked=false;
		document.getElementById("Locgroupflag").selectedIndex = 0;
		document.getElementById("OrdType").selectedIndex = 0;
		m_SelectedRow="-1";
		//LoadStayDepList(m_HDDCRowID,LocSortingDR);
	}
}
function getLOCDR(value){
	var obj=document.getElementById('LOCDR');
	obj.value=value.split("^")[1];
	//alert(obj.value)
}
function getReLOCDR(value){
	var obj=document.getElementById('ReCTLOCID');
	obj.value=value.split("^")[1];
	//alert(obj.value)
}
function getORDReLOCDR(value){
	var obj=document.getElementById('ORDReLocID');
	obj.value=value.split("^")[1];
	//alert(obj.value)
}
function DHCWeb_Trim(str){   
	 return str.replace(/(^\s*)|(\s*$)/g, "");  
}  
//ɾ����ߵĿո�
function DHCWeb_LTrim(str){   
	return str.replace(/(^\s*)/g,"");  
}  
//ɾ���ұߵĿո�
function DHCWeb_RTrim(str){   
	return str.replace(/(\s*$)/g,"");  
}  
function Clear_OnClick(){
	/*
    document.getElementById('LOCDR')="";
    document.getElementById('Locgroupflag')="";
    document.getElementById('OrdType')="";
    document.getElementById('BloodDis')="";
    document.getElementById('ReCTLOC')="";
    document.getElementById('ReCTLOCID')="";
    document.getElementById('LOCDR')="";
    document.getElementById('Locgroupflag')="";
    document.getElementById('OrdType')="";
    document.getElementById('BloodDis')="";
    document.getElementById('ReCTLOC')="";
    document.getElementById('ReCTLOCID')="";*/
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillHDDCNew";
	window.location.href=lnk;
	
}

document.body.onload = BodyLoadHandler;

