var Currow;
function BodyLoadHandler()
{
	var obj=document.getElementById("Ward");
	if (obj) 
	{obj.onkeydown=popWard;
	 obj.onblur=wardCheck;
	} 
	
	var obj=document.getElementById("prescno");
	if (obj) 
	{obj.onkeydown=selPrescno;} 
	
	
	var obj=document.getElementById("Aduit");
	if (obj) 
	{obj.onclick=Aduit;} 
	
	var obj=document.getElementById("Find");
	if (obj) 
	{obj.onclick=Find;}
	
	
	var obj=document.getElementById("qty");
	if (obj) 
	{obj.onkeydown=selqty;}  
	

	intForm();
	
	
}


function GetUserWard()
{
	///description:��ȡ�û����ڲ���
    var loc=session['LOGON.CTLOCID'];	
    var xx=document.getElementById("getuserward");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var str=cspRunServerMethod(encmeth,loc) ;
	var tem=str.split("^");
	var objWard=document.getElementById("Ward");
	objWard.value=tem[0];
	var objwardrowid=document.getElementById("wardrowid");
	objwardrowid.value=tem[1];
	
}

function Find()
{
	var obj=document.getElementById("Find");
	Find_click();


	
}
function popWard()     
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
		}
}
function wardCheck()
{
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("wardrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

}
function WardLookUpSelect(str)
{
	var ward=str.split("^");
	var obj=document.getElementById("wardrowid");
	if (obj)
	{if (ward.length>0)   obj.value=ward[1] ;
		else  obj.value="" ;  
	 }	
}

function selPrescno()     
{ 
  ///description: ѡ����ɨ������Ϣ
  var i;


  if (window.event.keyCode==13) 
  {  

       var objPrescno=document.getElementById("prescno");
       var prescno=objPrescno.value;
       ss = prescno.substr(1, prescno.length-1); 
       var prescno="I"+ss  //ת������Ϊ������
       
       var objtbl=document.getElementById("t"+"dhcpha_checkque");
       if (objtbl) var cnt=getRowcount(objtbl) ;
       
       var objType=document.getElementById("ReciveType");
       var objEatType=document.getElementById("EatType");
 
        for (i=1;i<=cnt;i++){
	        var objTprescno=document.getElementById("Tprescnoz"+i)
	        var Tprescno=objTprescno.innerText;
	        if (Tprescno==prescno){
		    
		    var objTsmqty=document.getElementById("Tsmqtyz"+i)	      
		    if (objTsmqty.innerText==" "){objTsmqty.innerText=0}   
		    objTsmqty.innerText=parseFloat(objTsmqty.innerText)+1
            
			if ( (objType.value==2)&&(objEatType.value==objTsmqty.innerText) )	
			    {   //�����ɨ���� =  ���÷�ʽ(1��2) ,�Ż�ѡ�и�����Ϣ     
			      var objTselect=document.getElementById("Tselectz"+i)
			      objTselect.checked=true;  } 

		    
		    objtbl.rows(i).click();
		    
		    if (objType.value==1){ //������շ�ʽ��һ����,��ʵ������Ϊ���� ,ɨһ�ξ�ѡ�и�����Ϣ  
			var objorderqty=document.getElementById("Tfacotorz"+i)
		    var js=objorderqty.innerText*objEatType.value ;  //���� * ���÷�ʽ(1��2) = ����
		    objTsmqty.innerText= js
		    
		    var objTselect=document.getElementById("Tselectz"+i)
			objTselect.checked=true; 
		   
			WriteSqty(js) }

		   // var objAuditNum=document.getElementById("AuditNum")
		   // objAuditNum.value=h;     
		          }
                     }
             
       getfocus();

  }
}


function Aduit()
{
	 ///description:���
	 //
	   var objtbl=document.getElementById("t"+"dhcpha_checkque");
       if (objtbl) var cnt=getRowcount(objtbl) ;
       
       if (cnt==0){return;}
       
       var userid = session['LOGON.USERID']
    
       //var objAuditNum=document.getElementById("AuditNum");
       //if (objAuditNum) var num=objAuditNum.value ;
       
       //if (cnt!=num){
	   //    var ret=confirm("��ɨ�������Ͳ�ѯ������һ��,�Ƿ�������?");
	   //   if (ret==false) {return;} }
       
       
       for (i=1;i<=cnt;i++){
	   var objTselect=document.getElementById("Tselectz"+i)
	     
	     
	     if (objTselect.checked==true)
	     {

		    var objTRowid=document.getElementById("TRowidz"+i)
		    var rowid=objTRowid.innerText;  
		    
		    var objTsqty=document.getElementById("Tsqtyz"+i)
		    var sqty=objTsqty.innerText;
		    
		    var objEatType=document.getElementById("EatType");
		    var eattype=objEatType.value;

		    var xx=document.getElementById("mAudit");
	        if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	        var result=cspRunServerMethod(encmeth,rowid,userid,sqty,eattype) ;
	        if (result==-1){alert(i+"  ��"+"��˸���ʧ��");}
    
	     }
	     
       }
	  alert("������")
	  //
	  Find_click();
}
function WriteSqty(qnum)
{
	var objqty=document.getElementById("Tsqtyz"+Currow)
	objqty.innerText=qnum;

}


function selqty()
{
	if (window.event.keyCode==13)
	 
	{
		var objtbl=document.getElementById("t"+"dhcpha_checkque");
		
		var objEatType=document.getElementById("EatType");
		
	    
		var obj=document.getElementById("qty")
		
		var tmpnum=obj.value
		
		if ((tmpnum%2!=0)&&(objEatType.value==2)){alert("�����ʵ����������,����ƽ��һ������");
		return;}
		
		if (obj){
			var objqty=document.getElementById("Tsqtyz"+Currow)
			 objqty.innerText=obj.value;
		}
		
		if (obj.value>objEatType.value){ ///���ʵ���������ڷ��÷�ʽ(1��2)��Ҳѡ�и���Ϣ
		    var objTselect=document.getElementById("Tselectz"+Currow)
			objTselect.checked=true;}
		
	
		getfocus();
	}
	
}



function SelectRowHandler()
 {

	var row=selectedRow(window);
    Currow=row;
		
 }
function getfocus()
{
	             
       var objPrescno=document.getElementById("prescno");
       var objqty=document.getElementById("qty");
       if (objPrescno)
       {
	    objqty.value="";
        objPrescno.value="";
        objPrescno.focus();}
}
function intForm()
{
	GetUserWard();
	
	var obj=document.getElementById("ReciveType");
	if (obj){
		obj.size=1; 
	 	obj.multiple=false;
	 	obj.options[0]=new Option('һ����',"1");
	 	obj.options[1]=new Option('������',"2");
	}
	
	
	var obj=document.getElementById("EatType");
	if (obj){
		obj.size=1; 
	 	obj.multiple=false;
	 	obj.options[0]=new Option('һ�������η�',"2");
	 	obj.options[1]=new Option('һ��һ�η�',"1");
	}
	
}


















document.body.onload=BodyLoadHandler;