//INSUGROPDivResInfo
var Type,UserId
var UserId,idTmr=""
var myData = new Array();
var path,starday,endday,rangeday,company,type,num,job,TjType,title,title1;
var TempList=""
function BodyLoadHandler() 
{
	UserId=session['LOGON.USERID'];
	var obj=document.getElementById("Print");
	if (obj){ obj.onclick=Print_click;}	
	ini();
}
function ini()
{
	alert(1)
	/*
	var obj=document.getElementById("Type");
	if (obj)
	{
		obj.size=1;
		obj.multiple=false;
		obj.options[0]=new Option(t['CCType0'],"");		
	   	obj.options[1]=new Option(t['CCType1'],"CCA");
	   	obj.options[2]=new Option(t['CCType2'],"CCB");
	   	obj.options[3]=new Option(t['CCType3'],"ALL");
      	var n=obj.length
      	for (var i =0;i<n;i++)
      	{
	      	var Typeobj=document.getElementById("Typesave");
		  	if(obj.options[i].value==Typeobj.value)
		  	{
			  	obj.options[i].selected=true
			}
	    }
	}
	*/
		
}
function Print_click(){
	var i;	
	getpath();
	GetNum();
	CreatFoldr();
		
	var obj=document.getElementById("StartDate");
	if (obj){starday=obj.value};
    var Data=starday.split("/");
    starday=Data[2]+"-"+Data[1]+"-"+Data[0];
        
    var obj=document.getElementById("EndDate");
	if (obj){endday=obj.value};
    var Data=endday.split("/");
    endday=Data[2]+"-"+Data[1]+"-"+Data[0];
    rangeday=starday+" жа "+endday;    
 
	if (Type.value=="CCA") {title=t['titleCCA']}	
	if (Type.value=="CCB") {title=t['titleCCB']}
	if (Type.value=="ALL") {title=t['titleALL']}
	printDetail();
}