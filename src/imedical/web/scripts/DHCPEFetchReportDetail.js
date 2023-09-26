//js: DHCPEFetchReportDetail.js

var CurrentSel=0;

function BodyLoadHandler(){
	var obj; 
	obj=document.getElementById("BSave");
	if (obj){ obj.onclick=BSave_click; } 

}

function BSave_click()
{
	
	 var obj;
	 var iName="",iTel="",iIDCard="";
	 
	 obj=document.getElementById("ReportStatus");
	if (obj) { var iReportStatus=obj.value; }
	if(iReportStatus.indexOf("��ȡ")<0){
		alert("���滹δ��ȡ,���ܱ�����ȡ����Ϣ");
		return false;
		}
	 //��ȡ������
	obj=document.getElementById("Name");
	if (obj) { iName=obj.value; }
	if(iName==""){
		obj=document.getElementById("Name")
		if(obj){
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("��������Ϊ��");
		return false;
	}
	//��ȡ���ֻ�����
	obj=document.getElementById("Tel");
	if (obj) { iTel=obj.value; }
	if(iTel==""){
		obj=document.getElementById("Tel")
		if(obj){
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("�ֻ����벻��Ϊ��");
		return false;
	}
	iTel=trim(iTel);
	if (!isMoveTel(iTel))
	{
		websys_setfocus(obj.id);
		return ;
	}
	
	//��ȡ�����֤��
	obj=document.getElementById("IDCard");
	if (obj) { iIDCard=obj.value; }
	if(iIDCard==""){
		obj=document.getElementById("IDCard")
		if(obj){
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("���֤�Ų���Ϊ��");
		return false;
	}
	/*
	if(!isIdCardNo(iIDCard))
	{
		websys_setfocus(obj.id);
		return false;;
	}
	*/
	
	
	
	//����ID
	obj=document.getElementById("ReportID");
	if (obj) { iReportID=obj.value; }
	var Instring=iReportID
	            +"^"+trim(iName)	
				+"^"+trim(iTel)			
				+"^"+trim(iIDCard)			
				;	
	var flag=tkMakeServerCall("web.DHCPE.FetchReport","UpdateFetchReportInfo",Instring,"1");	
    if(flag=="0") {
	    alert("�����ɹ�");
	   location.reload(); 
    }
}

///�ж����֤��
function isIdCardNo(regIdNo) {
var regIdNo = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/; 
if(!regIdNo.test(regIdNo)){ 
  alert("���֤����д����"); 
  return false; 
}	
}

///�ж��ƶ��绰
function isMoveTel(elem){
	
	if (elem=="") return true;
	//var pattern=/^0{0,1}13|15|18|14|17[0-9]{9}$/;
	var pattern=/^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/;
	if(pattern.test(elem)){

	//	PIBI_Tel1	�绰����1	6
	obj=document.getElementById("Tel1");
	if (obj&&obj.value=="") { obj.value=elem; }	
		
	return true;
	}else{
	
  	alert("�ƶ��绰���벻��ȷ");
	return false;
 	}
}
function trim(s) {
	if (""==s) { return "";}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}
function ShowCurRecord(selectrow) {
	
	var Tobj=document.getElementById("TReportIDz"+selectrow);
	var obj=document.getElementById("ReportID");
	if(Tobj&&obj){  obj.value=Tobj.value;}
	
	var Tobj=document.getElementById("TNamez"+selectrow);
	var obj=document.getElementById("Name");
	if(Tobj&&obj){  obj.value=Tobj.innerText;}
	
	var Tobj=document.getElementById("TTelz"+selectrow);
	var obj=document.getElementById("Tel");
	if(Tobj&&obj){  obj.value=Tobj.innerText;}
	
	var Tobj=document.getElementById("TIDCardz"+selectrow);
	var obj=document.getElementById("IDCard");
	if(Tobj&&obj){  obj.value=Tobj.innerText;}
	
	
	
}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEFetchReportDetail');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;
