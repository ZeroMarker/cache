//DHCOutPhDispSub
var bottomFrame;
var topFrame;
var tblobj=document.getElementById('tDHCOutPhDispSub');
function BodyLoadHandler() {
    InitForm()
    if (tblobj.rows.length==1) {return 0;}
    for (var i=1;i<=tblobj.rows.length-1;i++)
    { 
	 var  manflag=document.getElementById("TSkinTestz"+i).value
     if (manflag=='Y'){
	 var eSrc=tblobj.rows[i];
     var RowObj=getRow(eSrc);
	 RowObj.className="Green";}
    }
    document.onkeydown=KeyDownHandler
}
//ҽ��Ϊֹͣ��־ʱ����Ϊ��ɫ
function InitForm()   
{
	if (tblobj)
	{ 
	     var cnt=tblobj.rows.length-1;
	     for (var i=1;i<=cnt; i++) 
	          {		     
		           var objNostk=document.getElementById("TOrdStatus"+"z"+i).innerText
		           if  (objNostk=="ֹͣ"){
			           var eSrc=tblobj.rows[i];
     				   var RowObj=getRow(eSrc);
					   RowObj.className="RedColor";
					}
				   var objKCFlag=document.getElementById("TKCFlag"+"z"+i).innerText
		           if  (objKCFlag=="����"){
			           var eSrc=tblobj.rows[i];
     				   var RowObj=getRow(eSrc);
					   RowObj.className="Blue";
					}
										
	          } 
    }
}
function KeyDownHandler()
{
	if (window.event.keyCode==13){
		event.preventDefault(); //����keydown�¼�
		return;
		
	}
}

document.body.onload = BodyLoadHandler;
