var userID=session['LOGON.GROUPID']
var id="",iSeldRow=0,TarId="",InsuId="",InsuCode="",InsuDesc="",INTIMExpiryDate=""

function BodyLoadHandler() {	
	var obj=document.getElementById("Contrast");
	if (obj){ obj.onclick=Updat_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}

	var obj=document.getElementById("UpdateExpiryDate");
	if (obj){ obj.onclick=UpdateExpiryDate_click;}
	
	ini()
	}
function ini() {
	
	
	var obj=document.getElementById("Delete");
	if (obj){ obj.disabled=true;}
	
	var obj=document.getElementById("TarId");
	if (obj) {TarId=obj.value}
	if (TarId=="") {alert("TarIdΪ�գ�");return;}
	var VerStr=tkMakeServerCall("web.INSUTarContrastListCom","GetTariInfo",TarId);
	var Arr=VerStr.split("^")
	var obj=document.getElementById("HisCode");
	if (obj) {obj.value=Arr[1]}
	var obj=document.getElementById("HisDesc");
	if (obj) {obj.value=Arr[2]}
	var obj=document.getElementById("DW");
	if (obj) {obj.value=Arr[3]}
	var obj=document.getElementById("Cate");
	if (obj) {obj.value=Arr[4]}
	var obj=document.getElementById("SubCate");
	if (obj) {obj.value=Arr[5]}
	var obj=document.getElementById("Price");
	if (obj) {obj.value=Arr[6]}
	
	}	

function Updat_click(){
	var obj
	if (InsuId=="") {alert("��ѡ��ҽ����Ŀ");return;}
    var obj=document.getElementById("HisCode");
	if (obj) {var HisCode=obj.value}
	var obj=document.getElementById("HisDesc");
	if (obj) {var HisDesc=obj.value}
    obj=document.getElementById('iActDate');
    if (obj){
	    if (obj.value==""){var INTCTActiveDate="" }
	    else {var INTCTActiveDate=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0] }
	    }
    obj=document.getElementById('ExpiryDate');
    if (obj){
	    if (obj.value==""){var INTCTExpiryDate="" }
	    else {var INTCTExpiryDate=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0] }
	    }
    var obj=document.getElementById("Type");
	if (obj) {var InsuType=obj.value}
	
	//�ж�ҽ��Ŀ¼��ЧʧЧʱ���ҽ��������ЧʧЧʱ��
	if ((INTIMExpiryDate!="")&&(INTIMExpiryDate!=" ")){  
		if (INTCTExpiryDate=="")
		{
			alert("ҽ����Ŀ��ʧЧ������ "+INTIMExpiryDate+" ������д�ڸ�����֮ǰ�Ķ���ʧЧ����");
			return;
		}
		else
		{
			if (INTCTExpiryDate>INTIMExpiryDate){alert("ҽ����Ŀ��ʧЧ������ "+INTIMExpiryDate+" ������д�ڸ�����֮ǰ�Ķ���ʧЧ����");return;}
		}      
	}
	if (confirm("ȷ���� "+HisCode+"-"+HisDesc+" ����Ϊ "+InsuDesc+" ?")){
		var Qty="1"
    	var UpdateStr="^"+TarId+"^"+HisCode+"^"+HisDesc+"^"+InsuId+"^"+InsuCode+"^"+InsuDesc+"^"+"^"+"^"+"^"+Qty+"^"+"^"+INTCTActiveDate+"^"+"^"+InsuType+"^"+userID+"^"+"TEST^TEST"+"^"+INTCTExpiryDate+"^"+"^"+"^"+"^"+"^"+"^" 
        alert(UpdateStr)
        var Ins=document.getElementById('ClasstxtUpdate');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',UpdateStr)
        alert(flag)
        if (+flag>0) {
	        alert("���ճɹ���")
	        self.location.reload();
	        }
        else{alert("����ʧ�ܣ�ErrNo="+flag)}
		}
	}
function Delete_click(){	

	var obj=document.getElementById("Delete");
	if (obj){ if(obj.disabled==true){return;}}
	
	if (id==""){alert("��ѡ��һ���������ݣ�");return false}		
    if (confirm("ȷ��Ҫɾ��ѡ���Ķ��չ�ϵ��?")){
		var Ins=document.getElementById('ClasstxtDelete');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',id)
        if (flag=='0') {
	        alert("ɾ���ɹ���")
	        self.location.reload()
	        }
        else{alert("ɾ��ʧ�ܣ�ErrNo="+flag)}
		}
	}

function UpdateExpiryDate_click() {
	var ExpiryDate=""
	var obj=document.getElementById("ExpiryDate");
	if (obj) { 
		if (obj.value==""){ExpiryDate=""}
		else {ExpiryDate=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0]}
		}
	if (id==""){alert("��ѡ��һ���������ݣ�");return;}	
	if (ExpiryDate=="") {var TmpExpiryDate="��"}
	else {var TmpExpiryDate=ExpiryDate}
	if (confirm("Ҫ����ʧЧ���ڸĳ� "+TmpExpiryDate+" �� ?")){
			var VerStr=tkMakeServerCall("web.INSUTarContrastListCom","UpdateExpiryDate",id,ExpiryDate);
			if (+VerStr<0) {alert("�޸�ʧЧ����ʧ�ܣ�SQLCODE="+VerStr)}
			else {alert("�޸�ʧЧ���ڳɹ���");self.location.reload()}
		}
	}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUTarContrastListCom');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;	
	
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		iSeldRow=0
		id=""
		return;
		}
	iSeldRow=selectrow;
	var SelRowObj
	var obj
	SelRowObj=document.getElementById('ConIdz'+selectrow);	
	if (SelRowObj){id=SelRowObj.value;}
	else{id=""}
}

function SetInsuString(value) {
	var Arr=value.split("^")
	InsuId=Arr[1]
	InsuCode=Arr[4]
	var obj=document.getElementById("InsuQuery");
	if (obj) {obj.value=Arr[5]}
	InsuDesc=Arr[5]
	INTIMExpiryDate=Arr[47]
	
	}


	
document.body.onload = BodyLoadHandler;
