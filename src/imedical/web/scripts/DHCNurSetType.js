var selectRow="";
function BodyLoadHandler()
{
    
	//var obj=document.getElementById('tDHCNURRPLIST');
	//if (obj) obj.ondblclick = tDHCNURRPLIST_DblClick;
	//exedateobj.value=j;
	var obj=document.getElementById('search');
	if (obj) obj.onclick=sch_click;
}
function addlistoption(selobj,resStr)
{
    var resList=new Array();
    var tmpList=new Array();
    selobj.options.length=0;
    resList=resStr.split("!")
   // alert (selobj.length);
    for (i=1;i<resList.length;i++)
    {
	    tmpList=resList[i].split("^")
	    selobj.add(new Option(tmpList[1],tmpList[0]));
	}
}
 function SelectRowHandler()
 {
    var selrow=document.getElementById("selrow");
    var resList=new Array();
    selrow.value=DHCWeb_GetRowIdx(window);
    var code=document.getElementById("codez"+selrow.value).innerText;
    var name=document.getElementById("namez"+selrow.value).innerText;
    var filename=document.getElementById("filenamez"+selrow.value).innerText;
    var byadm=document.getElementById("byadmz"+selrow.value).innerText;
    var prnframe=document.getElementById("prnframez"+selrow.value).innerText;
    var prechkdays=document.getElementById("prechkdaysz"+selrow.value).innerText;
    var HospitalName=document.getElementById("tHospitalNamez"+selrow.value).innerText;
    var HospitalRowId=document.getElementById("tHospitalRowIdz"+selrow.value).value;
    
   
    var txtcode=parent.frames["RPbottom"].document.getElementById("txtcode");
    var txtname=parent.frames["RPbottom"].document.getElementById("txtname");
    var txtfilename=parent.frames["RPbottom"].document.getElementById("txtfilename");
    var txtbyadm=parent.frames["RPbottom"].document.getElementById("txtbyadm");
    var txtprnframe=parent.frames["RPbottom"].document.getElementById("txtprnframe");
    var txtprechkdays=parent.frames["RPbottom"].document.getElementById("txtprechkdays");
    var txtHospitalName=parent.frames["RPbottom"].document.getElementById("txtHospitalName");
    var txtHospitalRowId=parent.frames["RPbottom"].document.getElementById("HospitalRowId");
     if(selectRow==selrow.value){
    	code="";
    	name="";
    	filename="";
    	byadm="";
    	prnframe="";
    	prechkdays="";
    	HospitalName="";
    	HospitalRowId="";
    }
    
    txtcode.value=code;
    txtname.value=name;
    txtfilename.value=filename;
    txtbyadm.value=byadm;
    txtprnframe.value=prnframe;
    txtprechkdays.value=prechkdays;
    txtHospitalName.value=HospitalName;
    txtHospitalRowId.value=HospitalRowId;  
    if(selectRow==selrow.value){
    	return;
    }
    selectRow=selrow.value;
    //alert(code);
    // var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNURDISPLSET&code="+code;
    //alert( parent.frames.length);
    //parent.parent.frames['RPRight'].location.href=lnk;
    var GetCodeVar=document.getElementById("GetCodeVar").value;
    var str=cspRunServerMethod(GetCodeVar,HospitalRowId,code);
    //alert(str+"="+code);
    var selbox=parent.parent.frames['RPRight'].document.getElementById("displayitem");
    addlistoption(selbox,str);
    var GetQueryPara=document.getElementById("GetQueryPara").value;
    str=cspRunServerMethod(GetQueryPara,HospitalRowId,code);
    resList=str.split("!");
    //alert(parent.parent.parent.frames[1].name);
    var treatstatus=parent.parent.parent.frames["NurseSet"].document.getElementById("treatstatus");  
    var ordcat=parent.parent.parent.frames["NurseSet"].document.getElementById("ordcat");  
    var priority=parent.parent.parent.frames["NurseSet"].document.getElementById("priority");  
    var ordstatus=parent.parent.parent.frames["NurseSet"].document.getElementById("ordstatus");  
    var method=parent.parent.parent.frames["NurseSet"].document.getElementById("method");
    //alert(parent.parent.frames['RPRight'].document.getElementById("displayall").name);
    var displayall=parent.parent.frames['RPRight'].document.getElementById("displayall");  
    var specCode=parent.parent.parent.frames["NurseSet"].document.getElementById("specCode");  
    var recLoc=parent.parent.parent.frames["NurseSet"].document.getElementById("recLoc");  
    SelectedSet(treatstatus,resList[0],"^");
	SelectedSet(ordcat,resList[1],"^");
	SelectedSet(priority,resList[2],"^");
	SelectedSet(ordstatus,resList[3],"^");
	SelectedSet(method,resList[4],"^");
	//alert(displayall.options.length);
	SelectedSet(specCode,resList[5],"^");
	SelectedSet(recLoc,resList[6],"^");
	SelectedSet(displayall,resList[7],"^");

 }
  function SelectedSet(selObj,indStr,delim) 
    {//查询条件设置
	    var tmpList=new Array();
	    for(i=0;i<selObj.options.length;i++)
	    {
		    selObj.options[i].selected=false;
	    }
	    tmpList=indStr.split(delim)
	    for(j=0;j<tmpList.length;j++)
	    {
		    for(i=0;i<selObj.options.length;i++)
		    {  // if (selObj.name=="displayall")
		        //{
			      //alert(selObj.options[i].value+"|"+tmpList[j]); 
			    //}
		        if (selObj.options[i].value==tmpList[j])
		        {
			        selObj.options[i].selected=true;break
		        }
		    }
	    }
	    
    }
function del_click()  //delete
{//	    resStr=#server(web.udhcclnurseexec.TypeDel(form1.txtCode.value))#;

}
function savecatdr(str)
{
	var obj=document.getElementById('catid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
document.body.onload = BodyLoadHandler;
function MoveIN(surlist,dlist)
	{
	   if (surlist.selectedIndex==-1){
	   return;
	   }
	//var nIndex=surlist.selectedIndex;
	//alert (surlist.options[nIndex].text);
	//var Index =dlist.options.length ;
	var objSelected ;// new Option(surlist[nIndex].text, surlist[nIndex].value);
	//dlist.options[Index]=objSelected;
	//surlist.options[nIndex]=null;
	for (i=0;i<surlist.options.length;i++){
		if (surlist.options[i].selected){
		  var objSelected = new Option(surlist[i].text, surlist[i].value);
	      dlist.options[dlist.options.length]=objSelected;
	      surlist.options[i]=null;
	      i=i-1;
       	 }
		}
	return;
	}
function Movedel(surlist,dlist)
	{
   if (surlist.selectedIndex==-1){
	   return;
	   }
	var nIndex=surlist.selectedIndex;
	//alert (surlist.options[nIndex].text);
	var Index =dlist.options.length ;
	var objSelected = new Option(surlist[nIndex].text, surlist[nIndex].value);
	dlist.options[Index]=objSelected;
	surlist.options[nIndex]=null;
	//form1.dismeth.options[2].selected=true;
	return;
	}
	
function sch_click()
{
    var objTypeCode=document.getElementById("TypeCode");
    if (objTypeCode) var TypeCode=objTypeCode.value;
    else var TypeCode="";
    var objHospitalRowId=document.getElementById("HospitalRowId");
    if (objHospitalRowId) var HospitalRowId=objHospitalRowId.value;
    else var HospitalRowId="";
    var objHospitalName=document.getElementById("HospitalName");
    if (objHospitalName) var HospitalName=objHospitalName.value;
    else var HospitalName="";
    if (HospitalName=="")
    {
	    HospitalRowId="";
	}
	//alert(HospitalRowId+" "+TypeCode)
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetType&HospitalRowId="+HospitalRowId+"&TypeCode="+TypeCode;
    window.location.href=lnk; 
}
function GetHospital(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	
}