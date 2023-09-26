//DHCANOPAppSet.js
function BodyLoadHandler()
{
	var objGetAppSet=document.getElementById("GetAppSet");
	//alert(objGetAppSet.value)
	if ((objGetAppSet)&&(objGetAppSet.value!=""))
	{
		var AppSetStr=objGetAppSet.value.split("@");
		var objAppArcim=document.getElementById("AppArcim");
		var objAppArcimId=document.getElementById("AppArcimId");		
		if(AppSetStr[0]!="") {
			if (objAppArcim) objAppArcim.value=AppSetStr[0].split("^")[0];
			if (objAppArcimId) objAppArcimId.value=AppSetStr[0].split("^")[1];
		}
		var objAppTime=document.getElementById("AppTime");
		if((objAppTime)&&(AppSetStr[1]!="")) objAppTime.value=AppSetStr[1];
		var objArcimNote=document.getElementById("arcimNote");
		if((objArcimNote)&&(AppSetStr[2]!="")) objArcimNote.value=AppSetStr[2];
		var objNoteVar=document.getElementById("NoteVar");
		if((objNoteVar)&&(AppSetStr[3]!="")) objNoteVar.value=AppSetStr[3];	
		var objInsertDefRoom=document.getElementById("InsertDefRoom");
		if((objInsertDefRoom)&&(AppSetStr[4]=="Y")) objInsertDefRoom.checked=true;
		var objSendMessage=document.getElementById("SendMessage");
		if((objSendMessage)&&(AppSetStr[5]=="Y")) objSendMessage.checked=true;
		var objInsertLabInfo=document.getElementById("InsertLabInfo");
		if((objInsertLabInfo)&&(AppSetStr[6]=="Y")) objInsertLabInfo.checked=true;
		var objIPDefOpLoc=document.getElementById("IPDefOpLoc");
		var objIPDefOpLocId=document.getElementById("IPDefOpLocId");		
		if(AppSetStr[7]!="") {
			if (objIPDefOpLoc) objIPDefOpLoc.value=AppSetStr[7].split("^")[1];
			if (objIPDefOpLocId) objIPDefOpLocId.value=AppSetStr[7].split("^")[0];
		}
		var objOPDefOpLoc=document.getElementById("OPDefOpLoc");
		var objOPDefOpLocId=document.getElementById("OPDefOpLocId");		
		if(AppSetStr[8]!="") {
			if (objOPDefOpLoc) objOPDefOpLoc.value=AppSetStr[8].split("^")[1];
			if (objOPDefOpLocId) objOPDefOpLocId.value=AppSetStr[8].split("^")[0];
		}
		var objOPDefOpLoc=document.getElementById("DirAuditList");
		if(AppSetStr[9]!="") {
			if (objOPDefOpLoc) initListRow("DirAuditList",AppSetStr[9]);
		}
	}
	var obj=document.getElementById('save');
	if (obj) {obj.onclick = save_click;}
	var obj=document.getElementById('CarPrvTp');
	if (obj) obj.ondblclick = CarPrvTp_Click;
	var obj=document.getElementById('btnSavePrvTpOpCat');
	if (obj) obj.onclick = SavePrvTpOpCat_Click;
	var obj=document.getElementById('AddOpDoc');
	if (obj) obj.onclick =AddOpDoc_Click;
	var obj=document.getElementById('DelOpDoc');
	if (obj) obj.onclick =DelOpDoc_Click;
	var obj=document.getElementById("DirAuditList");
    if (obj) {obj.ondblclick=DirAuditList_Dublclick}
}

function save_click() 
{
	var AppArcimId="",AppTime="",arcimNote="",NoteVar="",InsertDefRoom="N",SendMessage="N",InsertLabInfo="N",IPDefOpLocId="",OPDefOpLocId="",DirAuditList="";
	var SaveAppSet=document.getElementById("SaveAppSet").value;
	var objAppArcim=document.getElementById("AppArcim");
	var objAppArcimId=document.getElementById("AppArcimId");
	if 	(objAppArcimId) AppArcimId=objAppArcimId.value;
	if ((objAppArcim)&&(objAppArcim.value=="")) AppArcimId="";
	var objAppTime=document.getElementById("AppTime");
	if 	(objAppTime) AppTime=objAppTime.value;
	var objArcimNote=document.getElementById("arcimNote");
	if 	(objArcimNote) arcimNote=objArcimNote.value;
	var objNoteVar=document.getElementById("NoteVar");
	if 	(objNoteVar) NoteVar=objNoteVar.value;	
	var objInsertDefRoom=document.getElementById("InsertDefRoom");
	if 	((objInsertDefRoom)&&(objInsertDefRoom.checked==true)) InsertDefRoom="Y";
	var objSendMessage=document.getElementById("SendMessage");
	if 	((objSendMessage)&&(objSendMessage.checked==true)) SendMessage="Y";
	var objInsertLabInfo=document.getElementById("InsertLabInfo");
	if 	((objInsertLabInfo)&&(objInsertLabInfo.checked==true)) InsertLabInfo="Y";
	var objIPDefOpLoc=document.getElementById("IPDefOpLoc");
	var objIPDefOpLocId=document.getElementById("IPDefOpLocId");
	if 	(objIPDefOpLocId) IPDefOpLocId=objIPDefOpLocId.value;
	if ((objIPDefOpLoc)&&(objIPDefOpLoc.value=="")) IPDefOpLocId="";
	var objOPDefOpLoc=document.getElementById("OPDefOpLoc");
	var objOPDefOpLocId=document.getElementById("OPDefOpLocId");
	if 	(objOPDefOpLocId) OPDefOpLocId=objOPDefOpLocId.value;
	if ((objOPDefOpLoc)&&(objOPDefOpLoc.value=="")) OPDefOpLocId="";
	var objDirAuditList=document.getElementById("DirAuditList");
   	if (objDirAuditList) DirAuditList=getListData("DirAuditList")
	//alert(AppArcimId+"@"+AppTime+"@"+arcimNote+"@"+NoteVar+"@"+InsertDefRoom+"@"+SendMessage+"@"+InsertLabInfo+"@"+IPDefOpLocId+"@"+OPDefOpLocId+"@"+DirAuditList);
  	var res=cspRunServerMethod(SaveAppSet,AppArcimId+"@"+AppTime+"@"+arcimNote+"@"+NoteVar+"@"+InsertDefRoom+"@"+SendMessage+"@"+InsertLabInfo+"@"+IPDefOpLocId+"@"+OPDefOpLocId+"@"+DirAuditList);
  	if (res==0){
	    alert(t['alert:success']);
	    self.location.reload();
  	}
  	else
  	{
		alert(t['alert:error']);
		return;
  	}
}
function GetAppArcimId(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("AppArcim");
	if (obj) obj.value=strValue[0];
	var obj=document.getElementById("AppArcimId");
	if (obj) obj.value=strValue[1];
}

function CarPrvTp_Click()
{
	var objCarPrvTp=document.getElementById('CarPrvTp');
	var objOpCategory=document.getElementById('OpCategory');	
   	if (objCarPrvTp) var index=objCarPrvTp.selectedIndex;
   	else var index=-1;
   	if (index<0) return;
	var GetPrvTpOpCat=document.getElementById('GetPrvTpOpCat');
	if (GetPrvTpOpCat){
		var Str=cspRunServerMethod(GetPrvTpOpCat.value,objCarPrvTp.options[index].value);
		if (Str!="") SelectedSet(objOpCategory,Str,"^");
		else {
			for(var i=0;i<objOpCategory.options.length;i++){
				objOpCategory.options[i].selected=false;
			}	
		}
	}
	self.location.reload;
}

function SelectedSet(selObj,indStr,delim) 
{
	var tmpList=new Array();
	if (!selObj) return;
	for(var i=0;i<selObj.options.length;i++)
	{
		selObj.options[i].selected=false;
	}
	tmpList=indStr.split(delim)
	for(var j=0;j<tmpList.length;j++)
	{
		for(var i=0;i<selObj.options.length;i++)
		{
			if (selObj.options[i].value==tmpList[j])
			{
				selObj.options[i].selected=true;break
			}
		}
	}    
}

function SavePrvTpOpCat_Click()
{
	var objCarPrvTp=document.getElementById('CarPrvTp');
	var objOpCategory=document.getElementById('OpCategory');	
   	if (objCarPrvTp) var index=objCarPrvTp.selectedIndex;
   	else var index=-1;
   	if (index<0) return;
   	var OpCategory="";
   	if (objOpCategory){
   		for(var i=0;i<objOpCategory.options.length;i++)
		{
			if (objOpCategory.options[i].selected==true) {
				if (OpCategory=="") OpCategory=objOpCategory.options[i].value;
				else OpCategory=OpCategory+"^"+objOpCategory.options[i].value;
			}
		}
   	}
	var SavePrvTpOpCat=document.getElementById('SavePrvTpOpCat');
	if (SavePrvTpOpCat){
		var ret=cspRunServerMethod(SavePrvTpOpCat.value,objCarPrvTp.options[index].value,OpCategory);
  		if (ret==0){
	   		alert(t['alert:success']);
	    	self.location.reload();
  		}
  		else {
			alert(t['alert:error']);
			return;
  		}
	}
}
function AddOpDoc_Click()
{
	var surlist=document.getElementById("CarPrvTp");
	var dlist=document.getElementById("OpDocType");
	movein(surlist,dlist);
	savevar(dlist);
}
function DelOpDoc_Click()
{ 
	var dlist=document.getElementById("CarPrvTp");
	var surlist=document.getElementById("OpDocType");
	moveout(surlist,dlist);
	savevar(surlist);	
}
function movein(surlist,dlist)
{
    if (surlist.selectedIndex==-1){
	   return;
	}
	var i;
	var objSelected ;
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{

		  if (ifexist(surlist[i].value,dlist)==false)
		 {
		    
		    var objSelected = new Option(surlist[i].text, surlist[i].value);
	        dlist.options[dlist.options.length]=objSelected;
	        i=i-1;
		 }
       	}
	}
	return;
}
function ifexist(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			return true;
		}
	}
	return false;
}
function moveout(surlist,dlist)
{
    if (surlist.selectedIndex==-1){
	   return;
	   }
	var i;
	var objSelected ;
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{
	        surlist.options[i]=null;
	        i=i-1;
       	}
	}
	return;
}
function savevar(dlist)
{
	var tmpList="";
	if (dlist){
        for ( var i=0;i<dlist.options.length;i++)
		{   
			if (tmpList=="") tmpList=dlist.options[i].value;
			else  tmpList=tmpList+"^"+dlist.options[i].value;

		}
	}
  	var SaveOpDocType=document.getElementById("SaveOpDocType");
  	if (SaveOpDocType) {
		var ret=cspRunServerMethod(SaveOpDocType.value,tmpList);
  		if (ret==0){
	   		//alert(t['alert:success']);
	    	self.location.reload();
  		}
  		else {
			//alert(t['alert:error']);
			return;
  		}
  	}
}
function GetIPDefOpLoc(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("IPDefOpLoc");
	if (obj) obj.value=strValue[1];
	var obj=document.getElementById("IPDefOpLocId");
	if (obj) obj.value=strValue[0];
}
function GetOPDefOpLoc(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("OPDefOpLoc");
	if (obj) obj.value=strValue[1];
	var obj=document.getElementById("OPDefOpLocId");
	if (obj) obj.value=strValue[0];
}
function GetDirAudit(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("DirAudit");
	if(obj){
		addListRow("DirAuditList",strValue);
		obj.value=""
	}
}
function addListRow(elementName,dataValue)
{
	var itemValue=dataValue;
    var objSelected = new Option(itemValue[0], itemValue[1]);
	var listObj=document.getElementById(elementName);
	if (listObj){
		listObj.options[listObj.options.length]=objSelected;
	}
}
function DirAuditList_Dublclick()
{
	list_Dublclick("DirAuditList");
}
function list_Dublclick(elementName)
{
  var listObj=document.getElementById(elementName);
  var objSelected=listObj.selectedIndex;
  if(listObj) listObj.remove(objSelected) ;
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
function initListRow(elementName,dataValue)
{
	var listData=dataValue.split("^");
	var listObj=document.getElementById(elementName);
	if(listObj){
		for (var i=0;i<listData.length;i++){
	   		if (listData[i]!="") {
				var listRowItem=listData[i].split("!");
				var sel=new Option(listRowItem[0],listRowItem[1]);
				listObj.options[listObj.options.length]=sel;
	   		}
		}
	}
}
document.body.onload = BodyLoadHandler;
