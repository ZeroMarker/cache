var ssTarId="",ssHisCode="",ssHisDesc="",ssConId="",ssInsuId="",ssInsuCode="",ssInsuDesc="",ssINTIMExpiryDate
var iSeldRow=0
var userID,userCode,userName=""
	//Lou 2010-08-26
var IPAddress
function BodyLoadHandler() {
	
	userID=session['LOGON.USERID'];
	userCode=session['LOGON.USERCODE'];
	userName=session['LOGON.USERNAME'];
	IPAddress=GetLocalIPAddress()

	//SetScrollForTable("INSUTarContrast2","","","","180","") �����JS,���ڹ�����
		
	var obj=document.getElementById("Alias");
	if (obj) {obj.onkeydown=AliasKeyDown; }
	var obj=document.getElementById("Code");
	if (obj) {obj.onkeydown=CodeKeyDown; }
	var obj=document.getElementById("Desc");
	if (obj) {obj.onkeydown=DescKeyDown; }
	var obj=document.getElementById("Query");
	if(obj){obj.onclick=Query_onclick;}
	var obj=document.getElementById("Contrast");
	if (obj){ obj.onclick=Updat_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}	
	var obj=document.getElementById("tINSUTarContrast2");
	if (obj){ obj.ondblclick=Updat_click;  //˫��ʵ��Ŀ¼����
	          obj.onkeydown=FrameEnterkeyCode;
	} 
	ini()
	
	GetContrastInsuID();
	
    //SepPage('fINSUTarItemsCom','tINSUTarItemsCom',50);  //����DHCCPMSepPage.js
 }
function ini(){
	var obj=document.getElementById("Alias");
	if (obj.value!="") {
		obj.focus();
		}
	var obj=document.getElementById("Code");
	if (obj.value!="") {
		obj.focus();		
		}
	var obj=document.getElementById("Desc");
	if (obj.value!="") {
		obj.focus();
		}	
}

function AliasKeyDown(){
	if (window.event.keyCode==13){
		//��ƴ��,����,��������ѯ,ֻ������һ
		var obj=document.getElementById("Code");
		if (obj){obj.value=""}
		var obj=document.getElementById("Desc");
		if (obj){obj.value=""}
		Query_onclick();
		}
 }
function CodeKeyDown(){
	if (window.event.keyCode==13){
		var obj=document.getElementById("Alias");
		if (obj){obj.value=""}
		var obj=document.getElementById("Desc");
		if (obj){obj.value=""}
		Query_onclick();
		}
 }
function DescKeyDown(){
	if (window.event.keyCode==13){
		var obj=document.getElementById("Code");
		if (obj){obj.value=""}
		var obj=document.getElementById("Alias");
		if (obj){obj.value=""}
		Query_onclick();
		}
 }

function Query_onclick(){
	var Alias,Code,Desc
	var txt=""
	var Class="0"
	var Type=""
	var obj=document.getElementById("Alias");
	if (obj) {Alias=obj.value; }
	var obj=document.getElementById("Code");
	if (obj) {Code=obj.value; }
	var obj=document.getElementById("Desc");
	if (obj) {Desc=obj.value; }
	if (Alias!=""){
		txt=Alias;
		Class="1";
	}
	if (Code!=""){
		txt=Code;
		Class="2";
	}
	if (Desc!=""){
		txt=Desc;
		Class="3";
	}
	
	Type=parent.frames["INSUTarContrast1"].document.getElementById("Type").value;
	    
    var obj=document.getElementById("txt");
    if (obj){obj.value=txt;}
    var obj=document.getElementById("Class");
    if (obj){obj.value=Class;}
    var obj=document.getElementById("Type");
    if (obj){obj.value=Type;}
    
    Query_click();

}

function Updat_click(){	
	var UpdateStr,ssiActDate,ssExpiryDate
	var obj=document.getElementById("UpdateStr");
	if (obj){var UpdateStr=obj.value}
	
	alert("UpdateStr="+UpdateStr)
	//ssConId^ssTarId^ssHisCode^ssHisDesc^ssInsuId^ssInsuCode^ssInsuDesc
	var tmp
	tmp=UpdateStr.split("^")
	//����ֱ�Ӳ���insu_tarcontrast����  lilizhi 2013-03-27 ע��
	//if (tmp[0]>0){
	//	alert("�Ѿ����ڶ��չ�ϵ,����ɾ����ϵ�����½�����");
	//	return;
	//	}

	//Add By wuqk 2006-03-10 ������Ч����
	var obj=document.getElementById("ActDate");
	if (obj){ssiActDate=obj.value}
    if (ssiActDate!=""){
	    var Data=ssiActDate.split("/")
    	ssiActDate=Data[2]+"-"+Data[1]+"-"+Data[0]
    }
    //add by lilizhi 2013-03-27 ���Ӷ���ʧЧ����
	var obj=document.getElementById("ExpiryDate");
	if (obj){ssExpiryDate=obj.value}
    if (ssExpiryDate!=""){
	    var Data=ssExpiryDate.split("/")
    	ssExpiryDate=Data[2]+"-"+Data[1]+"-"+Data[0]
    }
    
	if (tmp[1]==""){
		alert("��ѡ��Ҫ���յļƷ���!");
		return;
		}
	if (ssInsuId==""){
		alert("��ѡ��Ҫ���յ�ҽ����!");
		return;
		}
	
	//�ж�ҽ��Ŀ¼��ЧʧЧʱ���ҽ��������ЧʧЧʱ��
	if ((ssINTIMExpiryDate!="")&&(ssINTIMExpiryDate!=" ")){  
		if (ssExpiryDate=="")
		{
			alert("ҽ����Ŀ��ʧЧ������ "+ssINTIMExpiryDate+" ������д�ڸ�����֮ǰ�Ķ���ʧЧ����");
			return;
		}
		else
		{
			if (ssExpiryDate>ssINTIMExpiryDate){alert("ҽ����Ŀ��ʧЧ������ "+ssINTIMExpiryDate+" ������д�ڸ�����֮ǰ�Ķ���ʧЧ����");return;}
		}      
	}
	
		
	ssTarId=tmp[1]
	ssHisCode=tmp[2]
	ssHisDesc=tmp[3]
	
	if ((ssInsuId=="")||(ssTarId=="")||(ssiActDate=="")){return false}
	
	if (confirm(t['01']+ssHisCode+"-"+ssHisDesc+t['02']+ssInsuDesc+" ?")){
			
		var Qty=1,InsuType="",ElsString=""
		var obj
		obj=parent.frames["INSUTarContrast1"].document.getElementById("Type");
        if (obj) {InsuType=obj.value};
		obj=parent.frames["INSUTarContrast1"].document.getElementById('iQty');
        if (obj) {Qty=obj.value};
        var UpdateStr="^"+ssTarId+"^"+ssHisCode+"^"+ssHisDesc+"^"+ssInsuId+"^"+ssInsuCode+"^"+ssInsuDesc+"^"+"^"+"^"+"^"+Qty+"^"+"^"+ssiActDate+"^"+"^"+InsuType+"^"+userID+"^"+IPAddress+"^"+"TEST"+"^"+ssExpiryDate+"^"+"^"+"^"+"^"+"^"+"^" 

		var Ins=document.getElementById('ClassTxtUpdate');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',UpdateStr)
        if (flag>=0){	        
	        //�������,����Ƶ���һ��
	        var selectrow=parent.frames["INSUTarContrast1"].InsuRow;
	        parent.frames["INSUTarContrast1"].DHCC_SetColumnData("ConId",selectrow,flag)
	        parent.frames["INSUTarContrast1"].DHCC_SetColumnData("TInsuId",selectrow,ssInsuId)
	        parent.frames["INSUTarContrast1"].DHCC_SetColumnData("InsuCode",selectrow,ssInsuCode)
	        parent.frames["INSUTarContrast1"].DHCC_SetColumnData("InsuDesc",selectrow,ssInsuDesc)
			var objtbl=parent.frames["INSUTarContrast1"].document.getElementById('tINSUTarContrast1');
			var objrow=objtbl.rows[selectrow+1];
			if (objrow==undefined){return;}
			else{objrow.click();}
	        //alert('ok');
	        //parent.frames["INSUTarContrast1"].reload();        //��ˢ����ô���˨A
	        }
	    else{
	        //alert('Error ! ErrNo='+flag);
	        alert(t['03']+flag);
		    }		
		}	   
	}
function Delete_click(){
	var obj=document.getElementById("UpdateStr");
	if (obj){var UpdateStr=obj.value}
	//ssConId^ssTarId^ssHisCode^ssHisDesc^ssInsuId^ssInsuCode^ssInsuDesc
	var tmp
	tmp=UpdateStr.split("^")
	ssConId=tmp[0]
		
	if (ssConId=="") {		
		alert(t['04']);
		return false;
		}
	
	if (confirm(t['05'])){		
		var Ins=document.getElementById('ClassTxtDelete');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',ssConId)
        
        if (flag=="0"){
	        var selectrow=parent.frames["INSUTarContrast1"].InsuRow;
	        parent.frames["INSUTarContrast1"].DHCC_SetColumnData("ConId",selectrow,"")
	        parent.frames["INSUTarContrast1"].DHCC_SetColumnData("TInsuId",selectrow,"")
	        parent.frames["INSUTarContrast1"].DHCC_SetColumnData("InsuCode",selectrow,"")
	        parent.frames["INSUTarContrast1"].DHCC_SetColumnData("InsuDesc",selectrow,"")
	        //alert('ok');
	        //parent.frames["INSUTarContrast1"].reload();
	        }
	    else{
	        //alert('Error ! ErrNo='+flag);
	        alert(t['03']+flag);
		    }		
		}
	
	}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUTarContrast2');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		iSeldRow=0
		ssTarId="";
		ssHisCode="";
		ssHisDesc="";
		ssConId="";
		ssInsuId="";
		ssInsuCode="";
		ssInsuDesc="";
		return;
		}
	iSeldRow=selectrow;
	var SelRowObj
	var obj
	
	SelRowObj=document.getElementById('TRowidz'+selectrow);	
	if (SelRowObj){ssInsuId=SelRowObj.value}
	else{ssInsuId=""}
	
	SelRowObj=document.getElementById('TINTIMxmbmz'+selectrow);	
	if (SelRowObj){ssInsuCode=SelRowObj.innerText}
	else{ssInsuCode=""}
	
	SelRowObj=document.getElementById('TINTIMxmmcz'+selectrow);		
	if (SelRowObj){ssInsuDesc=SelRowObj.innerText}
	else{ssInsuDesc=""}
	
	SelRowObj=document.getElementById('INTIMExpiryDatez'+selectrow);		
	if (SelRowObj){ssINTIMExpiryDate=SelRowObj.innerText}
	else{ssINTIMExpiryDate=""}
}

function FrameEnterkeyCode()
{
	var e=window.event;
	switch (e.keyCode){
	case 38:
        //var Tselectrow=parent.frames["tINSUTarContrast2"].selectrow;
		var objtbl=window.document.getElementById('tINSUTarContrast2');
		if (iSeldRow==1) {break;}
		var objrow=objtbl.rows[iSeldRow-1];
		objrow.click();
		break;
	case 40:
        //var Tselectrow=parent.frames["tINSUTarContrast2"].selectrow;
		var objtbl=window.document.getElementById('tINSUTarContrast2');
		var rows=objtbl.rows.length-1;
		if (iSeldRow==rows) {break;}
		var objrow=objtbl.rows[iSeldRow+1];
		objrow.click();
		break;
	case 13:
		Updat_click();
		break;
	}
}

//ѭ�����ҵ����յ�ҽ����,���ѽ�����ڴ�����
function GetContrastInsuID()
{
	var UpdateStr="",InsuIDConst=""
	var obj=document.getElementById("UpdateStr");
	if (obj){UpdateStr=obj.value}
	var tmp=UpdateStr.split("^")
	if (UpdateStr!=""){InsuIDConst=tmp[4]}
	if (InsuIDConst==""){
		var objtbl=document.getElementById('tINSUTarContrast2');
		if (objtbl.rows.length>1){
			var objrow=objtbl.rows[1];
			objrow.click();
			return;
			}
		}
	var objtbl=document.getElementById('tINSUTarContrast2');
	for (i=1;i<objtbl.rows.length;i++){
		var tmpInsuId=document.getElementById('TRowidz'+i).value;
		//alert(tmpInsuId+"^"+InsuIDConst)
		if (tmpInsuId==InsuIDConst){
			var objrow=objtbl.rows[i];
			objrow.click();
			}
		}
}
	
document.body.onload = BodyLoadHandler;