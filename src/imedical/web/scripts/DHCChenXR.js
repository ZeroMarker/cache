
function BodyLoadHandler() {
	
	var patnoObj=document.getElementById('patno');	
	if (patnoObj) patnoObj.onkeydown=patnoclick;
	//alert("Hello World!6");
}
function patnoclick()
{
	if (window.event.keyCode==13) 
	{
	
		var thepatno=document.getElementById('patno').value;
			
	
		var j2m=document.getElementById('js2m');
        if (j2m) {var mfunc=j2m.value} else {var mfunc=''};
        
        
        var PatInfo=cspRunServerMethod(mfunc,thepatno)
      //  alert("��س��ˡI"+thepatno+mfunc+PatInfo);
          
       
        PatInfo=PatInfo.split("^")
        document.getElementById('patname').value=PatInfo[0]
        document.getElementById('patadmno').value=PatInfo[1]
        document.getElementById('patno').value=PatInfo[2]
        
     }
}

function SelectRowHandler()
{
	//��ȡ��ѡ�е���
	var eSrc=window.event.srcElement;
    var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    //��ȡTable�ļ�¼��
     //alert(selectrow)
    var objtbl=document.getElementById('tDHCChenXR');	
    var rows=objtbl.rows.length;
    //alert(rows)
    //��ȡTable��ĳһ�е�ĳ��Ԫ�ص�ֵ
    var SelRowObj=document.getElementById('Billidz'+selectrow);
    var buyrowid=SelRowObj.innerText;
    alert(buyrowid)
}

document.body.onload = BodyLoadHandler;	