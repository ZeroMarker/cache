///�ͻ��˿������ȼ��������
///Creator:hulihua
///CreatDate:2014-07-21

var CurrentRow

function BodyLoadHandler()
{
	
	var obj=document.getElementById("PhaLoc");  
	if (obj) 
	{obj.onkeydown=popDispLoc;
	 obj.onblur=DispLocCheck;
	}
	
	var obj=document.getElementById("save");  
	if (obj) obj.onclick=function ()
	{
		saveData(0);
		
	}
	
	var obj=document.getElementById("update");  
	if (obj) obj.onclick=function ()
	{
		saveData(1);
		
	}
	var obj=document.getElementById("Delete");  
	if (obj) obj.onclick=DeleDate;
	
	var obj=document.getElementById("Find");  
	if (obj) obj.onclick=function ()
	{
	 	bFindClick();
	}

	var PriList=document.getElementById("priority");
	if (PriList) {PriList.ondblclick=Priclick;}
	//
	var CatList=document.getElementById("savepri");
	if (CatList) {CatList.onclick=savepriclick;}
	
	var CatList=document.getElementById("deletepri");
	if (CatList) {CatList.onclick=deletepriclick;}
	
	var CatList=document.getElementById("dispcat");
	if (CatList) {CatList.ondblclick=Catdblclick;}
	
	setIncCatList() ;
	setIncPriList();
	
}
function bFindClick()
{
	var locID="";
	var objrowid=document.getElementById("displocrowid") ;
	if (objrowid) var locID=objrowid.value;
	if (locID=="")
	{
		alert("����ѡ����ң�")
		return;
	}
	Find_click();
}

///�鿴�����ȼ��¹��������
function Priclick()
{
	//CurrentRow=selectedRow(window);
	//alert(CurrentRow)
	if (typeof(CurrentRow)=='undefined')  {alert("����ѡ��ͻ��˼�¼");return;}
	var objrowid=document.getElementById("Tplc"+"z"+CurrentRow) ;
	var rowid=objrowid.value;
	setIncCatList() ;
	var pri=""
	var prilist=document.getElementById("priority");
	if (prilist)
	{
	    if (prilist.selectedIndex==-1){
	    return;
	    }
		var index=prilist.selectedIndex;
		var pri=prilist[index].value;
	}

	var obj=document.getElementById("mGetPhaLocConfig") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var retval=cspRunServerMethod(encmeth,rowid,pri) ;
	
	var tmparr=retval.split("^")
	var plclocdr=tmparr[0]
	var plcloc=tmparr[1]
	var plcdesc=tmparr[2]
	var plcmac=tmparr[3]
	var plccat=tmparr[4]
	var plcuser=tmparr[7]
	
	var tmpcatarr=plccat.split("||")		
	var tmpcatarrlength=tmpcatarr.length
  
	for (i=0;i<tmpcatarrlength;i++)
	{
		cat=tmpcatarr[i]
		
		var objlist=document.getElementById("dispcat");
		
		if(objlist)
		{
			
			for (h=0;h<objlist.length;h++)
			{
				//alert(objlist[h].value+"^"+cat)
				if (objlist[h].value==cat)
				{
					objlist.options[h].selected=true
					break;
				}

			}
		}
		

	}
	
	
	
}

///���������ȼ��¹��������
///
function Catdblclick()
{
	var catlist=document.getElementById("dispcat");
	var catlen=catlist.options.length
	if (catlen==0) {return;}
	if (catlist.selectedIndex==-1){
	    return;
	    }
	var index=catlist.selectedIndex;
	var index=catlist[index].value;
	saveLocDispCat(index)
}

///���淢ҩ���
function saveLocDispCat(index)
{
	if (typeof(CurrentRow)=='undefined')  {alert("����ѡ���¼");return;}
	
	var objrowid=document.getElementById("Tplc"+"z"+CurrentRow) ;
	rowid=objrowid.value;
	
	var pri=""
	
	var objlist=document.getElementById("priority");
	
	if(objlist)
	{
		var flag=0
		for (i=0;i<objlist.length;i++)
		{
			if (objlist.options[i].selected==true)
			{
				
				{	pri=objlist[i].value; flag=flag+1; }			
			}
		}
	}
	
	
	if (flag!=1)
	{alert("��ѡ��һ�����ȼ�");return;}
	
	var objGetCat=document.getElementById("mSavePri");
	if (objGetCat) {var encmeth=objGetCat.value;}
	else {var encmeth=''};
	var result=cspRunServerMethod(encmeth,rowid,pri,"1")
	if (result==0)
	{
	    alert("���ȼ�������,����ά��,����ά�����ȼ�")
	    return;
	}
	
	var objGetCat=document.getElementById("mSaveDispCat");
	if (objGetCat) {var encmeth=objGetCat.value;}
	else {var encmeth=''};
	var result=cspRunServerMethod(encmeth,rowid,pri,index,"1")
	var ret="" ;
	if (result!=0)
	{
		var ret=confirm("�Ѵ����Ƿ����?")
		if (ret==true) {
			var result=cspRunServerMethod(encmeth,rowid,pri,index,"3")
		}
		else{
			return;
		}
	}
	else
	{
		var result=cspRunServerMethod(encmeth,rowid,pri,index,"2")
		
	}
	Priclick();
	if (result!=0){
		alert("����ʧ��");
		return;
	}
	alert("���óɹ�!");
}

///����ĳ�ͻ��˹��������ȼ�
function savepriclick()
{

	
	var pri=""
	
	var prilist=document.getElementById("priority");
	if(prilist)
	{
		var flag=0
		for (ii=0;ii<prilist.length;ii++)
		{
			if (prilist.options[ii].selected==true)
			{
					var index=prilist.options[ii].value;
	                saveLocPriority(index);
	                flag=1
	                
	                //break;			
			}
		}
		WriteValueToText();
		if (flag==0) {alert("����ѡ�����ȼ�")}
	}
	
	
	
	
}

///������ȼ�
function deletepriclick()
{
	var pri=""
	
	var prilist=document.getElementById("priority");
	
	if(prilist)
	{
		var flag=0
		for (i=0;i<prilist.length;i++)
		{
			if (prilist.options[i].selected==true)
			{
				
					var index=prilist.options[i].value;
					
	                deleteLocPriority(index)
	                
	                flag=1
	                
	                break;			
			}
		}
		
		if (flag==0) {alert("����ѡ�����ȼ�")}
	}
	
}
///ά�����ȼ�
function saveLocPriority(index)
{
	
	
	if (typeof(CurrentRow)=='undefined')  {alert("����ѡ���¼");return;}
	
	var objrowid=document.getElementById("Tplc"+"z"+CurrentRow) ;
	rowid=objrowid.value;
	
	var objGetCat=document.getElementById("mSavePri");
	if (objGetCat) {var encmeth=objGetCat.value;}
	else {var encmeth=''};
	var result=cspRunServerMethod(encmeth,rowid,index,"1")
	var ret=""
	if (result!=0)
	{
	    alert("�Ѵ���,�����ظ�����")
	    return;
	}
	else
	{
		var result=cspRunServerMethod(encmeth,rowid,index,"2")
	}
	if (ret="false") {return;}
	if (result!=0) {alert("����ʧ��");}  
	
}

///ɾ�����ȼ�
function deleteLocPriority(index)
{
	
	if (typeof(CurrentRow)=='undefined')  {alert("����ѡ���¼");return;}
	
	var objrowid=document.getElementById("Tplc"+"z"+CurrentRow) ;
	rowid=objrowid.value;
	
	var objGetCat=document.getElementById("mSavePri");
	if (objGetCat) {var encmeth=objGetCat.value;}
	else {var encmeth=''};
	var result=cspRunServerMethod(encmeth,rowid,index,"1")
	var ret=""
	if (result!=0)
	{
		var ret=confirm("�Ƿ����?");
		if (ret==true)
		{
			var result=cspRunServerMethod(encmeth,rowid,index,"3")
		}
	}
	

	
	WriteValueToText();
	if (ret="false") {return;}
	if (result!=0) {alert("����ʧ��");}  
	
}

///��ʼ����ҩ���
function setIncCatList()
{   
    var displocdr=""
	var objdisploc=document.getElementById("displocrowid");
	if (objdisploc) 
	{
		displocdr=objdisploc.value;
	}
	if (displocdr=="") return;
	var objGetCat=document.getElementById("mGetDispCat");
	if (objGetCat) {var encmeth=objGetCat.value;}
	else {var encmeth=''};
	var result=cspRunServerMethod(encmeth,displocdr)  ;
	
	var catstr=result.split("^")
	var cnt=catstr.length
	
	var objStkCat=document.getElementById("dispcat") 
	if (objStkCat)
	{
		objStkCat.options.length=0;
		
		for (i=0;i<cnt;i++) 
		{
			var tmpcat=catstr[i].split("@");
			var rowid=tmpcat[0];
			var desc=tmpcat[1];
		
			objStkCat.options[i]=new Option (desc,rowid) ;
		}
	}
}

///��ʼ�����ȼ�
function setIncPriList()
{   

	var objGetCat=document.getElementById("mGetPriority");
	if (objGetCat) {var encmeth=objGetCat.value;}
	else {var encmeth=''};
	var result=cspRunServerMethod(encmeth)  ;
	var catstr=result.split("^")
	var cnt=catstr.length
	
	var objStkCat=document.getElementById("priority") 
	
	if (objStkCat)
	{
		objStkCat.options.length=0;
		
		for (i=0;i<cnt;i++) 
		{
			var tmpcat=catstr[i].split("@");
			var rowid=tmpcat[1];
			var desc=tmpcat[0];
			objStkCat.options[i]=new Option (desc,rowid) ;
		}
	}
}



function popDispLoc()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  PhaLoc_lookuphandler();
		}
}

function DispLocCheck()
{

	var obj=document.getElementById("PhaLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}

function PhaLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("displocrowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
	setIncCatList() ;
	setIncPriList();

}

///����ͻ�����Ϣ
function saveData(updflag)
{
	
	var rowid="" ;
	if (updflag==1)
	{
		var objtbl=document.getElementById("t"+"dhcpha_phamacconfig")
		if (objtbl)
		{ 
		     var cnt=objtbl.rows.length-1;
		     if (cnt==0)
		     {
			     alert("û�м�¼���ܽ��и��²�����")
			     return;
		     }
		}
		if (typeof(CurrentRow)=='undefined')
		{
			alert("��ѡ��Ҫ���µļ�¼��")
			return;
		}
		var objrowid=document.getElementById("Tplc"+"z"+CurrentRow) ;
		var rowid=objrowid.value;
		if (rowid=="")
		{
			alert("ѡ��ļ�¼ID�����ڣ����ܸ��£�")
			return
		}
	}
	var objdisploc=document.getElementById("displocrowid");
	if (objdisploc)
	{
		var disploc=objdisploc.value;
	}
    if (disploc=="") 
    {
	    alert("����ѡ��ҩ����")
	    return;
    }
	var objdispcat=document.getElementById("dispcatcode");
	if (objdispcat)
	{   
	    DispCatListRowidChanged();
		var dispcat=objdispcat.value;
		//alert(objdispcat.value)
	}
	var objpri=document.getElementById("prioritycode");
	if (objpri)
	{  
	    OecPriListRowidChanged();
		var pri=objpri.value;
		//alert(objpri.value)
	}
	var mac="";
	var objmac=document.getElementById("MacAddr");
	if (objmac)
	{
		var mac=objmac.value;
	}
	
	/**if (mac=="") 
    {
	    alert("����¼��MAC��ַ")
	    return;
    }**/
    
    var usercode="";
	var objuser=document.getElementById("UserCode");
	if (objuser)
	{
		var usercode=objuser.value;
	}
    if ((usercode=="")&&(mac=="" )) 
    {
	    alert("MAC��ַ���û���������ѡ��һ����")
	    return;
    }
    if ((usercode!="")&&(mac!="" )) 
    {
	    alert("MAC��ַ���û�����ֻ��ѡ��һ����")
	    return;
    }
    
	var objdesc=document.getElementById("Desc");
	if (objdesc)
	{
		var desc=objdesc.value;
	}
	
	var configstring=disploc+"^"+mac+"^"+desc+"^"+usercode;
	
	
	
	var obj=document.getElementById("insert") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var retval=cspRunServerMethod(encmeth,configstring,updflag,rowid) ;
	if (retval==-2) {alert("�����ظ�����");return;}
	else if (retval==0) {alert("����ɹ�")}
	else if (retval==-3) {alert("��Ч���û�����");return;}
	else {alert("����ʧ��")}
	
	if (objmac)
	{
		objmac.value="";
	}
	if (objuser)
	{
		objuser.value="";
	}
    var obj=document.getElementById("Find") ;
    if (obj) {obj.click()}
}
function DeleDate()
{
	var objtbl=document.getElementById("t"+"dhcpha_phamacconfig")
	if (objtbl)
	{ 
		var cnt=objtbl.rows.length-1;
		if (cnt==0)
		{
			alert("û�м�¼���ܽ���ɾ��������")
			return;
		}
	}
	if (typeof(CurrentRow)=='undefined')
	{
		alert("��ѡ��Ҫɾ���ļ�¼��")
		return;
	}
	if (confirm("ȷ��ɾ��?")==true)
	{
		var objrowid=document.getElementById("Tplc"+"z"+CurrentRow) ;
		var plcrowid=objrowid.value;
		if (plcrowid=="")
		{
			alert("ѡ��ļ�¼ID�����ڣ����ܸ��£�")
			return
		}
		var obj=document.getElementById("mDelete") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var retval=cspRunServerMethod(encmeth,plcrowid) ;
		if (retval!=0)
		{
			alert("ɾ����¼����!"+retval)
			return;
		}
		alert("ɾ���ɹ���")
	}
	else
	{
		alert("ɾ��ʧ�ܣ�")
		return;
	}
		
	
	
	var objmac=document.getElementById("MacAddr");
	if (objmac)
	{
		objmac.value="";
	}  
	var objuser=document.getElementById("UserCode");
	if (objuser)
	{
		objuser.value="";
	}
	bFindClick();
}

//�л����list��ѡ��ֵ
function DispCatListRowidChanged()
{	
	var objlist=document.getElementById("dispcat");
	var obj=document.getElementById("dispcatcode");
	
	if (obj)obj.value=''
	else return;
	
	if(objlist)
	{
		for (i=0;i<objlist.length;i++)
		{
			if (objlist.options[i].selected==true)
			{
				if (obj.value=="")
				{	obj.value=objlist[i].value;}
				else
				{	obj.value=obj.value+"||"+objlist[i].value;}				
			}
		}
	}
}

//�л����ȼ�list��ѡ��ֵ
function OecPriListRowidChanged()
{	
	var objlist=document.getElementById("priority");
	var obj=document.getElementById("prioritycode");
	
	if (obj)obj.value=''
	else return;
	
	if(objlist)
	{
		for (i=0;i<objlist.length;i++)
		{
			if (objlist.options[i].selected==true)
			{
				if (obj.value=="")
				{	obj.value=objlist[i].value;}
				else
				{	obj.value=obj.value+"||"+objlist[i].value;}				
			}
		}
	}
}

///�����¼�
function SelectRowHandler()
{
	CurrentRow=selectedRow(window);
	WriteValueToText(); 

   
}

///д���������ֵ
function WriteValueToText()
{
      
	var objrowid=document.getElementById("Tplc"+"z"+CurrentRow) ;
	var rowid=objrowid.value;
	var obj=document.getElementById("mGetPhaLocConfig") ;
       var inpri=""
     	var objlist=document.getElementById("priority");
	/*	
		if(objlist)
		{
			
                    for (h=0;h<objlist.length;h++)
			{	 	
				if (objlist.options[h].selected==true)
				{
					var inpri=objlist[h].value
					
					break;
					
				}

			}
			
		}
       */
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var retval=cspRunServerMethod(encmeth,rowid) ;
	
	var tmparr=retval.split("^")
	var plclocdr=tmparr[0]
	var plcloc=tmparr[1]
	var plcdesc=tmparr[2]
	var plcmac=tmparr[3]
	var plccat=tmparr[4]
	var plcpri=tmparr[5]
	var plcuser=tmparr[7]
	
	var objloc=document.getElementById("PhaLoc");
	if(objloc) {objloc.value=plcloc}
	var objlocdr=document.getElementById("displocrowid");
	if(objlocdr){objlocdr.value=plclocdr}
	
	setIncCatList() ;
	setIncPriList();
	
	var objdesc=document.getElementById("Desc");
	if(objdesc) objdesc.value=plcdesc
	var objmac=document.getElementById("MacAddr");
	if(objmac) objmac.value=plcmac
	var objuser=document.getElementById("UserCode");
	if(objuser) objuser.value=plcuser
	var tmpcatarr=plccat.split("||")		
	var tmpcatarrlength=tmpcatarr.length
	for (i=0;i<tmpcatarrlength;i++)
	{
		cat=tmpcatarr[i]
		
		var objlist=document.getElementById("dispcat");
		
		if(objlist)
		{
			
			for (h=0;h<objlist.length;h++)
			{
				if (objlist[h].value==cat)
				{
					objlist.options[h].selected=true
					break;
				}

			}
		}
		

	}
	
	
	var tmppriarr=plcpri.split("||")		
	var tmppriarrlength=tmppriarr.length
	var objlist=document.getElementById("priority");		
	if(objlist)
	{
		for (h=0;h<objlist.length;h++)
		{	
			objlist.options[h].selected=false;
			var i=0;
			for (i=0;i<tmppriarrlength;i++)
			{
				pri=tmppriarr[i]		
 		
				if (objlist[h].value==pri)
				{
					objlist.options[h].selected=true;							
				}
			}
		}
	
	}

}

document.body.onload=BodyLoadHandler;