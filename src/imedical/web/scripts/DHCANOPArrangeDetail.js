document.body.onload = BodyLoadHandler;
var obj=""
var value=""	
var SelectedRow = 0;
var ancvcCodeold=0;
var tformName=document.getElementById("TFORM").value;
var getComponentIdByName=document.getElementById("GetComponentIdByName").value;
var componentId;
componentId=cspRunServerMethod(getComponentIdByName,tformName);
var Tbl=document.getElementById("tDHCANOPArrangeDetail");
function BodyLoadHandler()
{
	//alert(String.fromCharCode(1));
	var opdateObj=document.getElementById("stdate");
	if(opdateObj) var opdate=opdateObj.value;
	else var opdate="";
	var obj=document.getElementById("ctcpAnDocO");
	if (obj) {obj.ondblclick=anaDoc_Dublclick}
	var obj=document.getElementById("ctcpAnDocJ");
	if (obj) {obj.ondblclick=anaDocJ_Dublclick}
	var obj=document.getElementById("anNur1");
	if (obj) {obj.ondblclick=anNur_Dublclick}
	var obj=document.getElementById("ctcpDevNur");
	if (obj) {obj.ondblclick=devNur_Dublclick}
	var obj=document.getElementById("ctcpDevNurJ");
	if (obj) {obj.ondblclick=devNurJ_Dublclick}
	var obj=document.getElementById("ctcpTourNur");
	if (obj) {obj.ondblclick=tourNur_Dublclick}
	var obj=document.getElementById("ctcpTourNurJ");
	if (obj) {obj.ondblclick=tourNurJ_Dublclick}
	var obj=document.getElementById("anNur1");
	if (obj) {obj.ondblclick=anNur_Dublclick}
	var obj=document.getElementById("anDoc");
	if (obj) {obj.onkeydown=AnDocKeyDown;}
	var obj=document.getElementById("ansupervisor");  //麻醉指导医生 ck 1202
	if (obj) {obj.onkeydown=AnsupervisorKeyDown;}     //麻醉指导医生 ck 1202
	var obj=document.getElementById("anNur");
	if (obj) {obj.onkeydown=AnNurKeyDown;}
	var obj=document.getElementById("anDocO");
	if (obj) {obj.onkeydown=AnDocOKeyDown;}
	var obj=document.getElementById("anDocJ");
	if (obj) {obj.onkeydown=AnDocJKeyDown;}
	var obj=document.getElementById("devNur");
	if (obj) {obj.onkeydown=DevNurKeyDown;}
	var obj=document.getElementById("devNurJ");
	if (obj) {obj.onkeydown=DevNurJKeyDown;}
	var obj=document.getElementById("tourNur");
	if (obj) {obj.onkeydown=TourNurKeyDown;}
	var obj=document.getElementById("tourNurJ");
	if (obj) {obj.onkeydown=TourNurJKeyDown;}
	var obj=document.getElementById("btSave");
	if (obj) {obj.onclick=Save_Click};
	var obj=document.getElementById("roomId");
	if(obj)
	{
		var roomId=obj.value;
		if(roomId!="")
		{
			var anOpArrObj=document.getElementById("GetAnOpArr");
			if(anOpArrObj)
			{
				anOpArr=anOpArrObj.value
				var retStr=cspRunServerMethod(anOpArr,roomId,opdate)
				if(retStr!="") alert(retStr)
			}
		}
	}
	var obj=document.getElementById("SetPermissions");
	if(obj)
	{
		var SetPermissions=obj.value
		var retStr=cspRunServerMethod(SetPermissions)
	}
			
	///ck091130
	var objtbl=document.getElementById('tDHCANOPArrangeDetail');
	for (i=1;i<objtbl.rows.length;i++)
	{
	    var eSrc=objtbl.rows[i];
	    ObjIfUseCombox=document.getElementById("ifUseCombox");
	    if (ObjIfUseCombox.value=="Y")
	    {
		    var opsttimeObj=document.getElementById("topsttimez"+i);
		    if(opsttimeObj)
		    {
			    //opsttimeObj.onblur=OpsttimeOnKeyDown;
			    opsttimeObj.onchange=OpsttimeOnKeyDown;
			}
		}
	}
}
function Save_Click()
{
	var roomId=document.getElementById("roomId").value;
	if(roomId=="") return

	var opdateObj=document.getElementById("stdate");
	if(opdateObj) var opdate=opdateObj.value;
	else var opdate="";

	var opId=""
	var andocid=document.getElementById("anDocId").value;
	var anDocObj=document.getElementById("anDoc");
	//if(anDocObj) var ctcpAnDoc=anDocObj.value;
	if(anDocObj) var anDoc=anDocObj.value;
	else var anDoc=""
	//if(ctcpAnDoc=="") andocid=""
	if(anDoc=="") andocid=""

	
	var ansupervisid=document.getElementById("ansupervisid").value;   //麻醉医生ID ck 091202
	//alert(ansupervisid);
	var ansupervisorObj=document.getElementById("ansupervisor");
	//alert(ansupervisorObj);
	if(ansupervisorObj) var ansupervisor=ansupervisorObj.value;
	else var ansupervisor=""
	if(ansupervisor=="") ansupervisid=""
	//alert(ansupervisor);
	
	var anNur=getListData("anNur1");
	
	//var anaNurseId=document.getElementById("anNurId").value;
	//var anNurObj=document.getElementById("anNur");
	//if(anNurObj) var ctcpAnNur=anNurObj.value;
	//else var ctcpAnNur=""
	//if(ctcpAnNur=="") anaNurseId=""
	var ctcpAnDocO=getListData("ctcpAnDocO");
	var ctcpAnDocJ=getListData("ctcpAnDocJ");
	var ctcpDevNur=getListData("ctcpDevNur");
	var ctcpDevNurJ=getListData("ctcpDevNurJ");
	//var ctcpDevNurJ="";
	var ctcpTourNur=getListData("ctcpTourNur");
	var ctcpTourNurJ=getListData("ctcpTourNurJ");
	
	//var ctcpTourNurJ="";
	var obj=document.getElementById("anDocNote");
	if(obj) var anDocNote=obj.value;
	else var anDocNote="";
	
	///ck 091126
	//var eSrc=window.event.srcElement;
	//alert(eSrc);
	var rows=Tbl.rows.length;
	//var lastrowindex=rows - 1;
	//var rowObj=getRow(eSrc);
	//alert(rowObj);
	//var selectrow=rowObj.rowIndex;
    for(var i=1;i<rows;i++)
    {
	    var SelRowOpId=document.getElementById("topaIdz"+i);
	    var opaId=SelRowOpId.innerText;
		opId=opId+"^"+opaId;
	}

	var UpdateANArrObj=document.getElementById("UpdateANArr");
	if(UpdateANArrObj)
	{
		var UpdateANArr=UpdateANArrObj.value;
		//alert(roomId+"{}"+opId+"{}"+andocid+"{}"+ctcpAnDocO+"{}"+ctcpAnDocJ+"{}"+anNur+"{}"+ctcpDevNur+"{}"+ctcpDevNurJ+"{}"+ctcpTourNur+"{}"+ctcpTourNurJ+"{}"+anDocNote+"{}"+opdate);
		//var retStr=cspRunServerMethod(UpdateANArr,roomId,opId,andocid,ctcpAnDocO,ctcpAnDocJ,anNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,anDocNote,opdate);
		var retStr=cspRunServerMethod(UpdateANArr,roomId,opId,andocid,ctcpAnDocO,ctcpAnDocJ,ansupervisid,anNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,anDocNote,opdate);
		//var retStr="";
		//alert(retStr);
		if(retStr!="") alert(retStr)
		else 
		{
			var UpdateAllArrObj=document.getElementById("UpdateAllOpArr");
			if(UpdateAllArrObj)
			{
				var UpdateAllOpArr=UpdateAllArrObj.value;
				var retStr=cspRunServerMethod(UpdateAllOpArr,roomId,opdate);
				if(retStr!="") alert(retStr)
				self.location.reload();
			}
		}
	}	
}
function getAnDoc(value)
{
	var strValue=value.split("^");
	var obj=document.getElementById("anDoc");
	if(obj){
		var checkFlag=CheckAnDoc("anDoc",strValue[1])
		if(checkFlag)
		{
			obj.value=strValue[0];
			var anDocIdObj=document.getElementById("anDocId");
			if(anDocIdObj) anDocIdObj.value=strValue[1];
		}
		else 
		{
			obj.value=""
		}
	}
}
function getAnsupervisor(value)
{
	var strValue=value.split("^");
	//alert(strValue);
	var obj=document.getElementById("ansupervisor");
	if(obj){
		var checkFlag=CheckAnDoc("ansupervisor",strValue[1])
		if(checkFlag)
		{
			obj.value=strValue[0];
			var anDocIdObj=document.getElementById("ansupervisid");
			if(anDocIdObj) anDocIdObj.value=strValue[1];
		}
		else 
		{
			obj.value=""
		}
	}
}
function getAnNur(value){
	///ck 090929
	var strValue=value.split("^");
	var obj=document.getElementById("anNur");
	if(obj)
	{
		var checkFlag=CheckNurse("anNur",strValue[1])
		if(checkFlag)
		{
			var listObj=document.getElementById("anNur1");
			if(listObj.options.length==0)
			{
				addListRow("anNur1",strValue);
				obj.value=""
				websys_setfocus("anNur");
			}
			else
			{
				alert("只能选择一个麻醉助手!");
				obj.value="";
				return;
				}
		}
		else  
		{
			obj.value=""
			websys_setfocus("anNur");
		}
	}
}
function getAnDocO(value)	{
	var strValue=value.split("^");
	var obj=document.getElementById("anDocO");
	if(obj){
		var checkFlag=CheckAnDoc("anDocO",strValue[1])
		if(checkFlag)
		{
			addListRow("ctcpAnDocO",strValue);
			obj.value=""
			websys_setfocus("anDocO");
		}
		else  
		{
			obj.value=""
			websys_setfocus("anDocO");
		}
	}
}
function getAnDocJ(value)	{
	var strValue=value.split("^");
	var obj=document.getElementById("anDocJ");
	if(obj){
		var checkFlag=CheckAnDoc("anDocJ",strValue[1]);
		if(checkFlag)
		{
			addListRow("ctcpAnDocJ",strValue);
			websys_setfocus("anDocJ");
			obj.value=""
		}
		else
		{
			websys_setfocus("anDocJ");
			obj.value=""
		}
	}
}
function getDevNur(value)	{
	var strValue=value.split("^");
	var obj=document.getElementById("devNur");
	if(obj){
		var checkFlag=CheckNurse(strValue[1]);
		if(checkFlag)
		{
			addListRow("ctcpDevNur",strValue);
			websys_setfocus("devNur");
			obj.value=""
		}
		else
		{
			websys_setfocus("devNur");
			obj.value=""
		}
	}
}
function getDevNurJ(value)	{
	var strValue=value.split("^");
	var obj=document.getElementById("devNurJ");
	if(obj){
		var checkFlag=CheckNurse(strValue[1]);
		if(checkFlag)
		{
			addListRow("ctcpDevNurJ",strValue);
			websys_setfocus("devNurJ");
			obj.value=""
		}
		else
		{
			websys_setfocus("devNurJ");
			obj.value=""
		}
	}
}
function getTourNur(value)	{
	var strValue=value.split("^");
	var obj=document.getElementById("tourNur");
	if(obj){
		var checkFlag=CheckNurse(strValue[1]);
		if(checkFlag)
		{
			addListRow("ctcpTourNur",strValue);
			websys_setfocus("tourNur");
			obj.value=""
		}
		else
		{
			websys_setfocus("tourNur");
			obj.value=""
		}
	}
}
function getTourNurJ(value)	{
	var strValue=value.split("^");
	var obj=document.getElementById("tourNurJ");
	if(obj){
		var checkFlag=CheckNurse(strValue[1]);
		if(checkFlag)
		{
			addListRow("ctcpTourNurJ",strValue);
			websys_setfocus("tourNurJ");
			obj.value=""
		}
		else
		{
			websys_setfocus("tourNurJ");
			obj.value=""
		}
	}
}
function anaDoc_Dublclick()
{
	list_Dublclick("ctcpAnDocO");
}
function anaDocJ_Dublclick()
{
	list_Dublclick("ctcpAnDocJ");
}
function devNur_Dublclick()
{
	list_Dublclick("ctcpDevNur");
}
function devNurJ_Dublclick()
{
	list_Dublclick("ctcpDevNurJ");
}
function tourNur_Dublclick()
{
	list_Dublclick("ctcpTourNur");
}
function tourNurJ_Dublclick()
{
	list_Dublclick("ctcpTourNurJ");
}
function anNur_Dublclick()
{
	list_Dublclick("anNur1");
}
function list_Dublclick(elementName)
{
	//alert(elementName);
  	var listObj=document.getElementById(elementName);
  	var objSelected=listObj.selectedIndex;
  	listObj.remove(objSelected);
}
function addListRow(elementName,dataValue)
{
	var itemValue=dataValue;
    var objSelected = new Option(itemValue[0], itemValue[1]);
	var listObj=document.getElementById(elementName);
	listObj.options[listObj.options.length]=objSelected;
}
function InitList(elementName,dataValue)
{
	var listData=dataValue.split("^");
	var listObj=document.getElementById(elementName);
	if(listObj){
		var listLen=listObj.options.length
		for(var i=0;i<listLen;i++)
		{
			listObj.remove(0)
		}
		for (var i=0;i<listData.length;i++)
	   	{
		   if (listData[i]!="")
		   {
			    var listRowItem=listData[i].split("!");
				var sel=new Option(listRowItem[0],listRowItem[1]);
				listObj.options[listObj.options.length]=sel;
		   }
		}
	}
}
function SetElementValue(elementName1,elementName2,dataValue)
{
   var obj=document.getElementById(elementName1);
   var obj1=document.getElementById(elementName2);
   var tem=dataValue.split("!");
   if(obj){
	   if (tem[0]) obj.value=tem[0];
   }
   if(obj1){
	   if (tem[1]) obj1.value=tem[1];
   }
}
function getListData(elementName)
{
	var retString
	retString=""
	var listObj=document.getElementById(elementName);
	if(listObj){
	for (var i=0;i<listObj.options.length;i++)
   	{
	   if (listObj.options[i].value!="")
	   {
		   if(retString==""){
			   retString=listObj.options[i].value
		   }else{
			   retString=retString+"^"+listObj.options[i].value
		   }
	   }
	}
	}
	return retString
}
function CheckAnDoc(elementName,anDocId)
{
	if(elementName=="anDoc")
	{
		var ctcpAnDocO=getListData("ctcpAnDocO")
		var ctcpAnDocJ=getListData("ctcpAnDocJ")
		var anDocIdStr=ctcpAnDocO+"^"+ctcpAnDocJ
		if (anDocIdStr.indexOf(anDocId)!=-1)
		{
			return false
		}
		else return true
	}
	if((elementName=="anDocO")||(elementName=="anDocJ"))
	{
		var anDocIdObj=document.getElementById("anDocId");
		if(anDocIdObj) var anDocIdStr=anDocIdObj.value;
		else  var anDocIdStr=""
		var ctcpAnDocO=getListData("ctcpAnDocO")
		var ctcpAnDocJ=getListData("ctcpAnDocJ")
		if(anDocIdStr=="") var anDocIdStr=ctcpAnDocO+"^"+ctcpAnDocJ
		else anDocIdStr=anDocIdStr+"^"+ctcpAnDocO+"^"+ctcpAnDocJ
		if (anDocIdStr.indexOf(anDocId)!=-1)
		{
			return false
		}
		else return true
	}
	if(elementName=="ansupervisor")
	{
		var anDocIdObj=document.getElementById("ansupervisid");
		if(anDocIdObj) var anDocIdStr=anDocIdObj.value;
		else var anDocIdStr=""
		if (anDocIdStr.indexOf(anDocId)!=-1)
		{
			return false
		}
		else return true
	}
}
function CheckNurse(nurseId)
{
	var anNur=getListData("anNur1")
	var ctcpDevNur=getListData("ctcpDevNur")
	var ctcpDevNurJ=getListData("ctcpDevNurJ")
	var ctcpTourNur=getListData("ctcpTourNur")
	var ctcpTourNurJ=getListData("ctcpTourNurJ")
	var nurIdStr=anNur+"^"+ctcpDevNur+"^"+ctcpDevNurJ+"^"+ctcpTourNur+"^"+ctcpTourNurJ
	if (nurIdStr.indexOf(nurseId)!=-1)
	{
		return false
	}
	else return true
}
function AnDocKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		anDoc_lookuphandler();
	}
}
function AnsupervisorKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		ansupervisor_lookuphandler();
	}
}
function AnNurKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		anNur_lookuphandler();
	}
}
function AnDocOKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		anDocO_lookuphandler();
	}
}
function AnDocJKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		anDocJ_lookuphandler();
	}
}
function DevNurKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		devNur_lookuphandler();
	}
}
function DevNurJKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		devNurJ_lookuphandler();
	}
}
function TourNurKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		tourNur_lookuphandler();
	}
}
function TourNurJKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		tourNurJ_lookuphandler();
	}
}
function getanNur()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaNur_lookuphandler();
	}
}
function DisableById(componentId,id)
{
	var obj=document.getElementById(id);
	if (obj) obj.disabled=true;
	if (componentId>0)
	{
		obj=document.getElementById("ld"+componentId+"i"+id);
		if (obj) obj.style.display ="none";
	}
}
function initListRow(elementName,dataValue)
{
	var listData=dataValue.split("^");
	var listObj=document.getElementById(elementName);
	if(listObj){
	for (var i=0;i<listData.length;i++)
   	{
	   if (listData[i]!="")
	   {
		var listRowItem=listData[i].split("!");
		var sel=new Option(listRowItem[0],listRowItem[1]);
		listObj.options[listObj.options.length]=sel;
	   }
	}
	}
}
function SelectRowHandler()	
{
		/*	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANOPArrangeDetail');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	var tandoc=document.getElementById("anDoc"); //麻醉指导医师
	//var tctcpAnDocO="";
	//var tctcpAnDocO=document.getElementById("ctcpAnDocO"); //麻醉主治医师
	var tanNur=document.getElementById("anNur1"); //麻醉助手
	var tscrubnurse=document.getElementById("devNur"); //器械护士
	var tcirculnurse=document.getElementById("tourNur"); //巡回护士
	var topdatestr=document.getElementById("topdatestr");

	var SelRowandoc=document.getElementById("tandocz"+selectrow);
	//var SelRowtctcpAnDocO=document.getElementById("tctcpAnDocOz"+selectrow);
	var SelRowanNurse=document.getElementById("tctcpAnNurz"+selectrow);
	var SelRowDevNur=document.getElementById("tscrubnursez"+selectrow);
	var SelRowTourNur=document.getElementById("tcirculnursez"+selectrow);
	var SelRowopdatestr=document.getElementById("topdatestrz"+selectrow);
	*/
}
function getAnDocO1(value){
	///ck 090929
	var obj=document.getElementById("ctcpAnDocO");
	obj.options.length=0;
	var strValue=value.split("^");
	addListRow("ctcpAnDocO",strValue);
	websys_setfocus("ctcpAnDocO");
	
	//var objSelected = new Option(user[0], user[1]);
    //var obj=document.getElementById('ctcpAnDocO');
    //obj.options[obj.options.length]=objSelected;

}
function getAnNur1(value){
	///ck 090929
	var obj=document.getElementById("anNur1");
	//obj.length=0;
	obj.options.length=0;
	var strValue=value.split("^");
	addListRow("anNur1",strValue);
	websys_setfocus("anNur");
	//var objSelected = new Option(user[0], user[1]);
    //var obj=document.getElementById('anNur1');
    //obj.options[obj.options.length]=objSelected;
}
function getDevNur1(value)	{
	var obj=document.getElementById("ctcpDevNur");
	//obj.length=0;
	obj.options.length=0;
	var strValue=value.split("^");
	addListRow("ctcpDevNur",strValue);
	websys_setfocus("devNur");

}
function getTourNur1(value)	{
	var obj=document.getElementById("ctcpTourNur");
	//obj.length=0;
	obj.options.length=0;
	var strValue=value.split("^");
	addListRow("ctcpTourNur",strValue);
	websys_setfocus("tourNur");
}
///ck091130
function OpsttimeOnKeyDown()
{
	if(event.keyCode==0)
	{
		var eSrc=window.event.srcElement;
    	var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		var opsttimeStr=eSrc.value;
		var opsttimeS=opsttimeStr.split(":");
		var opsttimeLen=opsttimeS.length;
		if(opsttimeLen>3)
		{
			alert("时间格式错误,请重新输入");
		}
		if(opsttimeLen==1)
		{
			opsttimeText=opsttimeS[0]+":"+"00"+":"+"00";
		}
		if(opsttimeLen==2)
		{
			opsttimeText=opsttimeS[0]+":"+opsttimeS[1]+":"+"00";
		}
		if(opsttimeLen==3)
		{
			opsttimeText=opsttimeS[0]+":"+opsttimeS[1]+":"+opsttimeS[2];
		}
		var opsttimeVlaue=opsttimeText;
		var flag=true;
		var opsttimeList=opsttimeVlaue.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})$/);     
        if(opsttimeList==null)
        {
	        alert("时间格式错误!");
	        flag=false;
	    }
        if(opsttimeList[1]>24||opsttimeList[3]>60||opsttimeList[4]>60)
       	{
	        alert("时间格式错误!");
	        flag=false;
	    }
	    if(flag==true)
	    {
		    var opsttime=opsttimeList[1]+opsttimeList[2]+opsttimeList[3];
			var opaIdObj=document.getElementById("topaIdz"+selectrow);
			if(opaIdObj)
			{
				var opaId=opaIdObj.innerText;
			}
			else var opaId="";
			var UpdateOpsttimeObj=document.getElementById("UpdateOpsttime");
			if(UpdateOpsttimeObj)
			{
				var UpdateOpsttime=UpdateOpsttimeObj.value;
				var resStr=cspRunServerMethod(UpdateOpsttime,opaId,opsttime);
				if(resStr!="")
		   		{
			   		alert(resStr);
			   		eSrc.value="";
		   		}
		   		self.location.reload();
			}
	    }
	}
}///ck091130