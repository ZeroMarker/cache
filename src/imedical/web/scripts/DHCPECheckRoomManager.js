
var CurRow=0
function BodyLoadHandler() {
  
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) {obj.onclick=BUpdate_click;}
	obj=document.getElementById("BDelete");
	if (obj) {obj.onclick=BDelete_click;}
	
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}    
function BUpdate_click(){
	Update(0);
}
function BDelete_click(){
	Update(1);
}
function Update(Type){
	var ID="",RoomDesc="",RoomAddress="",RoomSort="",Method="",ActiveFlag="0";  
    var obj=document.getElementById("ID");
	if (obj) ID=obj.value;
    var obj=document.getElementById("RoomDesc");
	if (obj) RoomDesc=obj.value;
	if (RoomDesc==""){
		alert("�������Ʋ���Ϊ��");
		websys_setfocus("RoomDesc");
		return false;
	}
	var obj=document.getElementById("RoomAddress");
	if (obj) RoomAddress=obj.value;
	var obj=document.getElementById("RoomSort");
	if (obj) RoomSort=obj.value;
	var obj=document.getElementById("ActiveFlag");
	if (obj&&obj.checked) ActiveFlag=1;
	
	var obj=document.getElementById("Method");
	if (obj) Method=obj.value;
	if (Method==""){
		alert("û���������ݲ����ķ���");
		return false;
	}
	var ret=cspRunServerMethod(Method,ID,RoomDesc,RoomAddress,RoomSort,ActiveFlag,Type);
	location.reload();
}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var objtbl=document.getElementById("tDHCPECheckRoomManager");
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurRow)
	{	    
	    CurRow=0;
	}else{

		CurRow=selectrow;
	}
	ShowCurRecord(CurRow);
	
}
function ShowCurRecord(CurRecord) {
	
	var selectrow=CurRecord;
	//վ����� ��ʾ
	FromTableToItem("ID","TID",selectrow);  


	//վ������(����) ��ʾ
	FromTableToItem("RoomDesc","TRoomDesc",selectrow);  

	//վ������λ�� ��ʾ
	FromTableToItem("RoomAddress","TRoomAddress",selectrow);  

	//˳�� ��ʾ
	FromTableToItem("RoomSort","TRoomSort",selectrow);  

	//���� ��ʾ ��ѡ��
	FromTableToItem("ActiveFlag","TActiveFlag",selectrow);

}
function FromTableToItem(Dobj,Sobj,selectrow) {
	var SelRowObj;
	var obj;
	var LabelValue="";
	obj=document.getElementById(Dobj);
    if (!(obj)) { return null; }
	if (selectrow==0) obj.value="";
	SelRowObj=document.getElementById(Sobj+'z'+selectrow);
	
   	if (!(SelRowObj)) { 
   	return null; }
	LabelValue=SelRowObj.tagName.toUpperCase();
   	
   	
   	if ("LABEL"==LabelValue) {		
		obj.value=trim(SelRowObj.innerText);
		return obj;
	}
	
	if ("INPUT"==LabelValue) {
		LabelValue=SelRowObj.type.toUpperCase();
		
		if ("CHECKBOX"==LabelValue) {
			obj.checked=SelRowObj.checked;
			return obj;
		}
		
		if ("HIDDEN"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}
		
		if ("TEXT"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}

		obj.value=SelRowObj.type+trim(SelRowObj.value);
		return obj;
	}

}
document.body.onload = BodyLoadHandler;

