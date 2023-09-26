var idobj,cipobj,cmacobj,cnameobj,usernameobj,useridobj,activeobj;
var addobj,updateobj,deleteobj,clearobj,importDataObj;
document.body.onload=function(){
	idobj=document.getElementById("DHCCLRRowId");
	cipobj=document.getElementById("ComputerIp");
	cmacobj=document.getElementById("ComputerMac");
	cnameobj=document.getElementById("ComputerName");
	usernameobj=document.getElementById("UserName");
	useridobj=document.getElementById("UserId");
	activeobj=document.getElementById("Active");
	activeobj.checked=true;
	
	addobj=document.getElementById("Add");
	updateobj=document.getElementById("Update");
	deleteobj=document.getElementById("Delete");
	clearobj=document.getElementById("Clear");
	importDataObj= document.getElementById("ImportData");
	
	
	if (addobj) addobj.onclick=add_click;
	if (updateobj) updateobj.onclick=update_click;
	if (deleteobj) deleteobj.onclick=delete_click;
	if (clearobj) clearobj.onclick=clear_click;
	if (importDataObj) importDataObj.onclick = importDataClick;
	
}



//   Save(Id, UserId, ComputerIp, ComputerName, ComputerMac, Active)
function add_click(){
	
	var id="";
	var userid=useridobj.value;
	if(userid==""){alert("��ѡ���û���");return false;}
	var cip=cipobj.value;
	var cname=cnameobj.value;
	var cmac=cmacobj.value;
	var act="N";
	if(activeobj.checked){
		act="Y";
	}
	var encobj=document.getElementById("save");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,id,userid,cip,cname,cmac,act);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("���ӳɹ�");
		Find_click();
	}else{
		alert("ʧ��");
	}
}
function update_click(){
	var id=idobj.value;
	if(id=="") {alert("��ѡ��Ҫ�޸ĵ���");return false;}
	var userid=useridobj.value;
	if(userid==""){alert("��ѡ���û���");return false;}
	var cip=cipobj.value;
	var cname=cnameobj.value;
	var cmac=cmacobj.value;
	var act="N";
	if(activeobj.checked){
		act="Y";
	}
	var encobj=document.getElementById("save");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,id,userid,cip,cname,cmac,act);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("���³ɹ�");
		Find_click();
	}else{
		alert("ʧ��");
	}
}
function clear_click(){
	cipobj.value="";
	cnameobj.value="";
	cmacobj.value="";
	usernameobj.value="";
	activeobj.checked=true;
	useridobj.value="";
	idobj.value="";
	Find_click();
}
function delete_click(){
	var id=idobj.value;
	if(id=="") {alert("��ѡ��Ҫɾ������");return false;}
	var encobj=document.getElementById("del");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,id);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("ɾ���ɹ�");
		clear_click();
	}else{
		alert("ʧ��");
	}
}

function UserNameLookUp(str){
	var arr=str.split("^");
	//alert(str);
	useridobj.value=arr[2];
	usernameobj.value=arr[1];

}
function importDataClick(){
	var xlsArr = websys_ReadExcel("D:\\UserIPMAC.xlsx",0);
	if (xlsArr=="") return ;
	var str = "";
	var ImportExeclEncObj = document.getElementById("ImportExeclEnc");
    var ImportExeclEnc="";
    if (ImportExeclEncObj){
    	ImportExeclEnc = ImportExeclEncObj.value;
    }
	for (var i=1;i<xlsArr.length;i++){
		var arr = xlsArr[i];
		if (str=="") {str = arr.join('^');}
		else{ str+="!"+arr.join('^');}
    	if (str.length > 20000){
    		var rtn=cspRunServerMethod(ImportExeclEnc,str);
    		str="";
    		if (rtn==0){alert("����ɹ���");}
  			else{alert("����ʧ��!"+rtn);}
    	}
	}
	if (str!=""){
	   var rtn=cspRunServerMethod(ImportExeclEnc,str);
	   if (rtn==0){alert("����ɹ���");}
	   else{alert("����ʧ��!"+rtn);}
	}
	return ;
	
	
	var xlsExcel = new ActiveXObject("Excel.Application");
   	try{
	   	var wb = xlsExcel.Workbooks;
    	var xlsBook = wb.Open("D:\\UserIPMAC.xlsx")
   	}catch(e){
	   		wb = null;
   			//xlsExcel.Quit();
    		xlsExcel = null;
    		//+e.message
	    	alert("��D��δ�ҵ�UserIPMAC.xlsx. ");
	    	return ;
    	
   	}
    var xlsSheet = xlsBook.Worksheets(1);
    var hasValue = true;
    var rowind=2;
    var userCode="",ip="",compname="",mac="",active="";
    var str="";
    var ImportExeclEncObj = document.getElementById("ImportExeclEnc");
    var ImportExeclEnc="";
    if (ImportExeclEncObj){
    	ImportExeclEnc = ImportExeclEncObj.value;
    }
    while(hasValue && rowind<20000){
    	userCode =  xlsSheet.cells(rowind,1).value||"";
    	if ((typeof userCode=="undefined")||((userCode)=="")){
    		hasValue=false;
    	}else{
	    	ip = xlsSheet.cells(rowind,2).value||"";
	    	compname = xlsSheet.cells(rowind,3).value||"";
	    	mac = xlsSheet.cells(rowind,4).value||"";
	    	active = xlsSheet.cells(rowind,5).value||"";
	    	str = str+"!"+userCode+"^"+ip+"^"+compname+"^"+mac+"^"+active
	    	if (str.length > 20000){
	    		var rtn=cspRunServerMethod(ImportExeclEnc,str);
	    		str="";
	    		if (rtn==0){alert("����ɹ���");}
	  			else{alert("����ʧ��!"+rtn);}
	    	}
	    	rowind++;
    	}
    }
    if (str!=""){
	   // alert("ImportExeclEnc="+ImportExeclEnc+"-"+str);
	   var rtn=cspRunServerMethod(ImportExeclEnc,str);
	   if (rtn==0){alert("����ɹ���");}
	   else{alert("����ʧ��!"+rtn);}
	}
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
}
var SelectRowHandler = function(){
	if(selectedRowObj.rowIndex>0){
		var cip = document.getElementById("TComputerIpz"+selectedRowObj.rowIndex).innerText;
		var cname = document.getElementById("TComputerNamez"+selectedRowObj.rowIndex).innerText;
		var cmac = document.getElementById("TComputerMacz"+selectedRowObj.rowIndex).innerText;
		var username = document.getElementById("TUserNamez"+selectedRowObj.rowIndex).innerText;
		var act = document.getElementById("TActivez"+selectedRowObj.rowIndex).innerText;
		
		var id = document.getElementById("TDHCCLRRowIdz"+selectedRowObj.rowIndex).value;
		var userid = document.getElementById("TUserIdz"+selectedRowObj.rowIndex).value;
		
		cipobj.value=cip;
		cnameobj.value=cname;
		cmacobj.value=cmac;
		usernameobj.value=username;
		if(act=="Y"){
			activeobj.checked=true;
		}else{
			activeobj.checked=false;
		}
		useridobj.value=userid;
		idobj.value=id;
	}else{
		cipobj.value="";
		cnameobj.value="";
		cmacobj.value="";
		usernameobj.value="";
		activeobj.checked=true;
		useridobj.value="";
		idobj.value="";
	}
	
}