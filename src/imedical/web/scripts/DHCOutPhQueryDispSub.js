var tblobj=document.getElementById('tDHCOutPhQueryDispSub');
function BodyLoadHandler() {
	InitForm()
}
//ҽ��Ϊֹͣ��־ʱ����Ϊ��ɫ
function InitForm()   
{
	if (tblobj)
	{ 
	     var cnt=tblobj.rows.length-1;
	     for (var i=1;i<=cnt; i++) 
	          {		     
		           var objNostk=document.getElementById("TStatus"+"z"+i).innerText
		           if  (objNostk=="ֹͣ"){
			           var eSrc=tblobj.rows[i];
     				   var RowObj=getRow(eSrc);
					   RowObj.className="RedColor";}					
	          } 
    }
}  

document.body.onload = BodyLoadHandler;