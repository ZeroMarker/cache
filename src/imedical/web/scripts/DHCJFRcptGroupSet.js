 var GroupRowid
 function BodyLoadHandler(){
	var obj=document.getElementById("Add");
	if(obj) obj.onclick=Add_click;
	var obj=document.getElementById("Del")
	if(obj) obj.onclick=Del_click
	var obj=document.getElementById("clear")
	if(obj) obj.onclick=clear_click;
	var obj=document.getElementById("UserType");
	if (obj){
		obj.options[0]=new Option("������Ա",1) ;
		obj.options[1]=new Option("�շѴ�����Ա",2) ;
		obj.options[2]=new Option("�շѴ��շ�Ա",3) ;
		obj.options[3]=new Option("",0)
		obj.size=1;
		obj.multiple=false;
		obj.onchange=UserType_OnChange;
		//alert(document.getElementById("currentPDDFlag"))
		if(document.getElementById("currentUserType")){
			//alert(document.getElementById("currentUserType").value)
			if (websys_$("currentUserType").value) {
				obj.selectedIndex=websys_$("currentUserType").value;
			}else{
				obj.selectedIndex=3
			}
		}

	}
	 GetUserType()
	}
function Add_click()
{   var RcptTypeval=document.getElementById("RcptTypeval").value;
    var RcptType=document.getElementById("RcptType").value;
    var UserGroup=document.getElementById("RcptType").value;
    var groupid=document.getElementById("groupid").value;
    var User=document.getElementById("groupid").value;
    var userid=document.getElementById("userid").value;
    var UserType=document.getElementById("UserType").value
    
    if ((UserType==0)||(UserType==""))
    {
	    alert("��ѡ����Ա����.")
	    return
    }
	     	if((RcptTypeval=="")||(RcptType=="")){
		 	alert("Ʊ�����Ͳ���Ϊ��");
		 	return;
	     	}	
	     	if((groupid=="")||(UserGroup=="")) {
		 	alert("��ȫ�鲻��Ϊ��")
		 	return
	     	}
	       if((userid=="")||(User=="")) {
		 	alert("��ѡ���û�")
		 	return
	     	}
	        var InsObj=document.getElementById('ins');
	        if (InsObj) {var encmeth=InsObj.value} else {var encmeth=''}
            var ReturnValue=cspRunServerMethod(encmeth,RcptTypeval,groupid,userid,3) //��������̨��ת����1
            if(ReturnValue==0){
	            alert("����ɹ�")
	            clear_click();
	            Find_click();
	            //window.location.reload();
	        }
	        else{alert("����ʧ��"+ReturnValue);return;}
   }
function Del_click(){
	if(GroupRowid==""){alert("ѡ��ɾ������");return}
	else{
		
	  var InsObj=document.getElementById('delect');
	  if (InsObj) {var encmeth=InsObj.value} else {var encmeth=''}
      var ReturnValue=cspRunServerMethod(encmeth,GroupRowid)
       if(ReturnValue==0){
	    alert("ɾ���ɹ�")
	   clear_click();
	    Find_click(); //���²���=���¼���ҳ��
	  
	    }
	   else{
		    alert("��¼���ܲ����ڻ��ѱ�ɾ����ɾ��ʧ�ܣ�")
		    
	        clear_click();
		    
	   }
	        
	}
}

function SelectRowHandler()
{
   var eSrc = window.event.srcElement
   var rowObj=getRow(eSrc)
   var selectrow=rowObj.rowIndex
   var SelRowObj=document.getElementById('TRowidz'+selectrow)
    GroupRowid=SelRowObj.innerText
   
   
   
	}
function clear_click()
{
	//document.getElementById("RcptTypeval").value="";
    //document.getElementById("RcptType").value="";
    //document.getElementById("RcptType").value="";
    //document.getElementById("groupid").value="";
    //document.getElementById("groupid").value="";
    document.getElementById("userid").value="";
}
function UP_click()
{
	if(TconRowid==""){alert("ѡ����µ�����")}
	var admconcode=document.getElementById("admconcode").value
    var admcondesc=document.getElementById("admcondesc").value
    var admconval=document.getElementById("admconval").value
	     	if(admconcode==""){
		 	alert("���������");
		 	return;
	     	}	
	     	if(admcondesc=="") {
		 	alert("����������")
		 	return
	     	}
	       if(admconval=="") {
		 	alert("������ֵ")
		 	return
	     	}
	  var InsObj=document.getElementById('update');
	  if (InsObj) {var encmeth=InsObj.value} else {var encmeth=''}
      var ReturnValue=cspRunServerMethod(encmeth,admconcode,admcondesc,admconval,TconRowid)
       if(ReturnValue==0){
	
	alert("���³ɹ�")
	 clear_click();
	    Find_click(); //���²���=���¼���ҳ��
       }
	}
	
	
function getgroupid(value)	{
	var valstr=value.split("^");
	var obj=document.getElementById('groupid');
	document.getElementById('userid').value="";
	document.getElementById('User').value="";
	obj.value=valstr[1];
}
function getuserid(value)	{
	var user=value.split("^");
	var obj=document.getElementById('userid');
	obj.value=user[1];
}
function getRcptType(value)	{
	var type=value.split("^");
	var obj=document.getElementById('RcptType');
	var obj1=document.getElementById('RcptTypeval');
	obj.value=type[1];
	obj1.value=type[0];
	Find_click();
	//alert(document.getElementById('RcptTypeval').value)
}
function GetUserType()
{
	UserTypeobj=document.getElementById('UserType');
	//alert(UserTypeobj.value)
	var Myobj=document.getElementById('Myid')
	if (Myobj){
	   var imgname="ld"+Myobj.value+"i"+"RcptType"
	   var RcptTypeobj1=document.getElementById(imgname);
	  // var imgname="ld"+Myobj.value+"i"+"UserGroup"
	  //var UserGroupobj1=document.getElementById(imgname);
  } 
	if((UserTypeobj.value==3))
	{
		document.getElementById("RcptType").readOnly=false;
		RcptTypeobj1.style.display=""
	}else if((UserTypeobj.value==1))
	{
		document.getElementById("RcptType").readOnly=true;
		RcptTypeobj1.style.display="none";
		document.getElementById("RcptTypeval").value="A";
        document.getElementById("RcptType").value="������Ա";
        //Find_click();
		
		
	}else
	{
		
	}
	
	}
	
	
function UserType_OnChange()
{
	
	websys_$("currentUserType").value=websys_$("UserType").selectedIndex
	//alert($("UserType").value)
	
	document.getElementById("RcptTypeval").value="";
    document.getElementById("RcptType").value="";
    GetUserType();
	
	
	}
document.body.onload = BodyLoadHandler;