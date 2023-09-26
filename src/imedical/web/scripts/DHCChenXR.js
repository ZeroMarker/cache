
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
      //  alert("你回车了"+thepatno+mfunc+PatInfo);
          
       
        PatInfo=PatInfo.split("^")
        document.getElementById('patname').value=PatInfo[0]
        document.getElementById('patadmno').value=PatInfo[1]
        document.getElementById('patno').value=PatInfo[2]
        
     }
}

function SelectRowHandler()
{
	//获取到选中的行
	var eSrc=window.event.srcElement;
    var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    //获取Table的记录数
     //alert(selectrow)
    var objtbl=document.getElementById('tDHCChenXR');	
    var rows=objtbl.rows.length;
    //alert(rows)
    //获取Table上某一行的某个元素的值
    var SelRowObj=document.getElementById('Billidz'+selectrow);
    var buyrowid=SelRowObj.innerText;
    alert(buyrowid)
}

document.body.onload = BodyLoadHandler;	