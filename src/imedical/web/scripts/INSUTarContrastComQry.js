//INSUTarContrastComQry.js
function BodyLoadHandler() 
{
	var obj=document.getElementById("Cate");
	if (obj){ obj.onchange=CateList_click;}
	var obj=document.getElementById("Type");
	if (obj){ obj.onchange=InsuTypeList_click;}
	var obj=document.getElementById("Query");
	if (obj){ obj.onclick=queryclick1;}	
	var obj=document.getElementById("sKeyWord")
	FillCombList();	
	GetRowCnt();
}
	
function queryclick1()
{
    var obj=document.getElementById("sKeyWord")
    //sKeyWord As %String, Class As %String, Type As %String, ConType As %String, TarCate As %String, ActDate As %String
    sKeyWord1=document.getElementById("sKeyWord").value;
    Class1=document.getElementById("Class").value;
    Type1=document.getElementById("Type").value;
    ConType1=document.getElementById("ConType").value;
    TarCate1=document.getElementById("TarCateList").value;
    ActDate1=document.getElementById("ActDate").value;
    StopFlag1=document.getElementById("StopFlagCate").value; 
    Cate1=document.getElementById("Cate").value;  
    InsuType1=document.getElementById("Type").value;
    //location.href="websys.default.csp?WEBSYS.TCOMPONENT=INSUTarContrastCom&sKeyWord="+sKeyWord1+"&Class="+Class1+"&Type="+Type1+"&ConType="+ConType1+"&TarCate="+TarCate1+"&ActDate="+ActDate1
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=INSUTarContrastCom&sKeyWord="+sKeyWord1+"&Class="+Class1+"&Type="+Type1+"&ConType="+ConType1+"&TarCate="+TarCate1+"&ActDate="+ActDate1+"&StopFlag="+StopFlag1+"&Cate="+Cate1+"&InsuType="+InsuType1
    parent.frames[1].location.href=lnk
}
function FillCombList()
{
	var obj=document.getElementById("Cate");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option(t['Cate01'],"0");
	  obj.options[1]=new Option(t['Cate02'],"1")
	  //obj.options[2]=new Option(t['Cate03'],"2");
	  }
		
	var obj=document.getElementById("StopFlagCate");
	if (obj){	
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option(t['StopCate03'],"3");
	  obj.options[1]=new Option(t['StopCate01'],"0")
	  obj.options[2]=new Option(t['StopCate02'],"1");
		}		
	var	obj=document.getElementById("TarCateList")
	if (obj){	
		obj.size=1; 
		obj.multiple=false;
		obj.options[0]=new Option(t['TarCate25'],"");
		obj.options[1]=new Option(t['TarCate01'],"1");
		obj.options[2]=new Option(t['TarCate02'],"2");
		obj.options[3]=new Option(t['TarCate03'],"3");		
	}	

	var obj=document.getElementById("Type");
	if (obj)
	{
	 	obj.size=1; 
	 	obj.multiple=false;
	 	//obj.options[0]=new Option(t['msType03'],"NBB");
	 	//obj.options[1]=new Option(t['msType04'],"NBA");
	 	obj.options[0]=new Option(t['msType05'],"BJ");
	}
	
	var obj=document.getElementById("Class");
	if (obj){	
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option(t['msClass1'],"1");
	  obj.options[1]=new Option(t['msClass2'],"2");
	  obj.options[2]=new Option(t['msClass3'],"3");
		}
		
	var obj=document.getElementById("ConType");
	if (obj){	
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option(t['msConType1'],"A");
	  obj.options[1]=new Option(t['msConType2'],"Y");
	  obj.options[2]=new Option(t['msConType3'],"N");
		}
			
}

function InsuTypeList_click()
{
	var obj=document.getElementById("InsuType");
	//?»ä?ç±»å??
	obj=parent.frames[1].document.getElementById('InsuType');
	obj.value=parent.frames[0].document.getElementById("Type").value;
	alert(obj.value);
	}

function CateList_click()
{	
	var obj=document.getElementById("Cate");
	//????
	if (obj[obj.selectedIndex].value=="0")
	{
		ReMoveItems();
		obj=document.getElementById("TarCateList")
		obj.size=1; 
		obj.multiple=false;
		obj.options[0]=new Option(t['TarCate25'],"");
		obj.options[1]=new Option(t['TarCate01'],"20");
		obj.options[2]=new Option(t['TarCate02'],"2");
		obj.options[3]=new Option(t['TarCate03'],"3");	
	}	
	
	//????   
	if (obj[obj.selectedIndex].value=="2")
	{
		ReMoveItems();
		obj=document.getElementById("TarCateList")
		obj.size=1; 
		obj.multiple=false;
		obj.options[0]=new Option(t['TarCate22'],"27");
	}	
	
	//è¯???é¡¹ç???????¨N?¾æ??
	if (obj[obj.selectedIndex].value=="1")
	{
		ReMoveItems();
		obj=document.getElementById("TarCateList")
		obj.size=1; 
		obj.multiple=false;
		obj.options[0]=new Option(t['TarCate14'],"");
		obj.options[1]=new Option(t['TarCate04'],"4");
		obj.options[2]=new Option(t['TarCate05'],"5");
		obj.options[3]=new Option(t['TarCate06'],"9");
		obj.options[4]=new Option(t['TarCate07'],"21");
		obj.options[5]=new Option(t['TarCate08'],"22");
		obj.options[6]=new Option(t['TarCate09'],"23");
		obj.options[7]=new Option(t['TarCate10'],"24");
		obj.options[8]=new Option(t['TarCate11'],"25");
		obj.options[9]=new Option(t['TarCate12'],"26");
		obj.options[10]=new Option(t['TarCate13'],"27");
	}	
}

function ReMoveItems()
{
	obj=document.getElementById("TarCateList")
	//alert(obj.length)
	while ((k=obj.length-1)>=0)
	{
		obj.options.remove(k);
	}	
}	
document.body.onload = BodyLoadHandler;
