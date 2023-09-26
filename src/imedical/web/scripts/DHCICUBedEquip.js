var SelectedRow = 0;
var EquipRowidold=0,preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('ADD')
	if(obj) obj.onclick=ADD_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=UPDATE_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=DELETE_click;
	
	var obj=document.getElementById('setBtn')
	if(obj) obj.onclick=SetConfirmedTime;
	
	if(session['LOGON.GROUPDESC']!='Demo Group'){
	var obj=document.getElementById('Bed');
	if(obj) obj.disabled  ='disabled';
	/*
	var obj=document.getElementById('DELETE');
	if(obj) obj.disabled  ='disabled';
	var obj=document.getElementById('SetDefaultBtn');
	if(obj) obj.disabled  ='disabled';
	*/
	
	hide("DELETE");
	hide("SetDefaultBtn");
	hide("setBtn");
    hide("confirmedTime");
    hide("cconfirmedTime");
    hide("UPDATE");
    hide("ADD");
	}
	var obj=document.getElementById('SetDefaultBtn')
	if(obj) obj.onclick=SetDefault_click;
	var obj=document.getElementById('RecoveryDefaultBtn')
	if(obj){
		 obj.onclick=RecoveryDefault_click;
		 hide('RecoveryDefaultBtn');
	}
	
	var obj=document.getElementById('GetQueryStr');
	var GetQueryStr=obj.value;
	var obj=document.getElementById('bedRowId');
	var bedRowId="";
	if(obj) bedRowId=obj.value;
	var retStr=cspRunServerMethod(GetQueryStr,"web.DHCANCCollectType","FindDHCANCCollectType","1","3","",bedRowId,"I");
	var portStr=cspRunServerMethod(GetQueryStr,"web.DHCANCCollectType","FindDevPort","1","2","",bedRowId);
	var obj=document.getElementById('GetConfirmedTime');
	var GetConfirmedTime=obj.value;
	var min=cspRunServerMethod(GetConfirmedTime)
	var obj=document.getElementById('confirmedTime');
	obj.value = min;
	
    InitComBox("InterfaceProgram",retStr);
    //InitComBox("Port",portStr);

	var obj=document.getElementById('mStatbtn')
	if(obj) obj.onclick=SetMStatBtn_click;
	if(mStatBtn) hide('mStatbtn');
}
function SetMStatBtn_click(){
	if (preRowInd == -1) return;
	var bedRowid =document.getElementById("TRowidz"+preRowInd).innerText;
	var sStat=document.getElementById("TStatz"+preRowInd).innerText;

	// alert(selrow);
	var icuaId=request("icuaId");
	sStat=sStat.replace(" ","");
	icuaId=icuaId.replace("#","");
	var obj=document.getElementById('SetStat');
	if (obj){
		encmeth=obj.value;
		if (sStat != "N" ){
			// 修改状态为N,并停止设备任务
			var resStr=cspRunServerMethod(encmeth,bedRowid,icuaId,"N");
			if(!resStr){
				alert("停止失败:"+resStr);
			}
			else
			alert("停止成功");
		}
		else {
			// 修改状态为"",并启动设备任务
			var resStr=cspRunServerMethod(encmeth,bedRowid,icuaId,"Y");
			if(!resStr){
				alert("启动失败:"+resStr);
			}
			else
			alert("启动成功");
		}	
	}
	window.location.reload();
}

function request(paras){ 
		
        var url = location.href; 
        var paraString = url.substring(url.indexOf("?")+1,url.length).split("&"); 
        var paraObj = {} 
        for (i=0; j=paraString[i]; i++){ 
        paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length); 
        } 
        var returnValue = paraObj[paras.toLowerCase()]; 
        if(typeof(returnValue)=="undefined"){ 
        return ""; 
        }else{ 
        return returnValue; 
        } 
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCICUBedEquip');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('BedRowid');
	var obj1=document.getElementById('Bed');
    //var obj2=document.getElementById('EquipRowid');
	var obj3=document.getElementById('Equip');
	var obj4=document.getElementById('Port');
	var obj5=document.getElementById('TcpipAddress');
	var obj6=document.getElementById('InterfaceProgram');
	var obj7=document.getElementById('DefaultInterval');
	var obj8=document.getElementById('Rowid');
	var obj9=document.getElementById('EditTcpipAddress');
	var obj10=document.getElementById("InterfaceProgramID");
	
	var SelRowObj=document.getElementById('TBedRowidz'+selectrow);
	var SelRowObj1=document.getElementById('TBedz'+selectrow);
	//var SelRowObj2=document.getElementById('TEquipRowidz'+selectrow);
	var SelRowObj3=document.getElementById('TEquipz'+selectrow);
	var SelRowObj4=document.getElementById('TPortz'+selectrow);
	var SelRowObj5=document.getElementById('TTcpipAddressz'+selectrow);
	var SelRowObj6=document.getElementById('TInterfaceProgramz'+selectrow);
	var SelRowObj7=document.getElementById('TDefaultIntervalz'+selectrow);
	var SelRowObj8=document.getElementById('TRowidz'+selectrow);
	var SelRowObj9=document.getElementById('TEditTcpipAddressz'+selectrow);
	
	var SelRowObj10=document.getElementById('TWardDescz'+selectrow);
	var SelRowObj11=document.getElementById('TRowidz'+selectrow);
	var SelRowObj12=document.getElementById('TEquipCodez'+selectrow);
	var SelRowObj13=document.getElementById('TInterfaceProgramIDz'+selectrow);
	var stat=document.getElementById("TStatz"+selectrow).innerText;
	var wardText=document.getElementById('WardDesc');
	var wardIdObj=document.getElementById('wardId');

	var selectedEquipCodeObj=document.getElementById('SelectedEquipCode');
	show('MStatBtn');
	if(stat)stat=stat.replace(" ","");
	var mStatBtn=document.getElementById('MStatBtn');
	if (stat == null || stat=="" || stat == "Y"){
		
		mStatBtn.innerHTML = "停止";
	}
	else {
		mStatBtn.innerHTML = "启动";
	}
    if (preRowInd==selectrow){
	obj.value="";
	obj1.value="";
	//obj2.value="";
	obj3.value="";
	obj4.value="";
	obj5.value="";
	obj6.value="";
	obj7.value="";
	obj8.value="";
	obj9.value="";
	selectedEquipCodeObj.value="";
   		preRowInd=0;
    }
   else{
	if(obj)obj.value=SelRowObj.innerText;
	if(obj1)obj1.value=SelRowObj1.innerText;
	//obj2.value=SelRowObj2.innerText;
	if(obj3 && SelRowObj3)obj3.value=SelRowObj3.innerText;
	if(obj4)obj4.value=SelRowObj4.innerText;
	if(obj5)obj5.value=SelRowObj5.innerText;
	if(obj6)obj6.value=SelRowObj6.innerText; // 采集代码
	if(obj7)obj7.value=SelRowObj7.innerText;
	if(obj8)obj8.value=SelRowObj8.innerText;
	if(obj9 && SelRowObj9)obj9.value=SelRowObj9.innerText;
	if(obj10)obj10.value=SelRowObj13.innerText; // 采集代码ID
	if(wardText)wardText.value=SelRowObj10.innerText;

	try	{
		wardIdObj.value=obj.value.split("||")[0];
	}
	catch(err){}
	
	//selectedEquipCodeObj.value=SelRowObj12.innerText;
	preRowInd=selectrow;
    }
	//EquipRowidold=SelRowObj2.innerText;
	if(session['LOGON.WARDID']==''){
	//SelectedRow=selectrow;
	//ADD MFC 20121121屏蔽
	parent.frames['RPBottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCCollectTypeItem&MDIRowid="+obj10.value; 
	}
	return;
}

function ADD_click(){
	var obj=document.getElementById('EquipRowid');
	if(obj) EquipRowid=obj.value;
	/*if(EquipRowid==""){
		alert(t['01']) 
		return;
		}*/
    var obj=document.getElementById('BedRowid');
    if(obj) BedRowid=obj.value;
    if(BedRowid==""){
		alert(t['02']) 
		return;
		}
	/*
	var obj=document.getElementById('RepBedEquip')
	if(obj) Rerencmeth=obj.value;
	
    var repflag=cspRunServerMethod(Rerencmeth,EquipRowid)
    if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	*/
	var obj=document.getElementById('TcpipAddress');
    if(obj) TcpipAddress=obj.value; 
	var obj=document.getElementById('Port');
	if(obj) Port=obj.value;
	var obj=document.getElementById('InterfaceProgramID');
	if(obj) InterfaceProgram=obj.value;
	var obj=document.getElementById('DefaultInterval');
	if(obj) DefaultInterval=obj.value;
	var obj=document.getElementById('EditTcpipAddress');
	if(obj) EditTcpipAddress=obj.value;
	var obj=document.getElementById('InsertBedEquip')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,BedRowid,EquipRowid,TcpipAddress,Port,InterfaceProgram,DefaultInterval,EditTcpipAddress);
	    if (resStr==100) {alert(t['04'])
		 return}
	    if (resStr!='0'){
			alert(t['baulk']+":"+resStr);
			return;
			}	
		try {
        alert(t['succeed']);	    
		} catch(e) {};
		}
		//window.location.reload();
}
function UPDATE_click(){
	if (preRowInd<1) return;
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['05']) 
		return;
		}
	/*var obj=document.getElementById('EquipRowid');
	if(obj) EquipRowid=obj.value;
	if(EquipRowid==""){
		alert(t['01']) 
		return;
		}
		*/
    var obj=document.getElementById('BedRowid');
    if(obj) BedRowid=obj.value;
    if(BedRowid==""){
		alert(t['02']) 
		return;
		}
	var EquipRowid=document.getElementById('EquipRowid').value	
	if(EquipRowidold!=EquipRowid) {
    var obj=document.getElementById('RepBedEquip')
	if(obj) Rerencmeth=obj.value;
    var repflag=cspRunServerMethod(Rerencmeth,EquipRowid)
    if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	}
	var obj=document.getElementById('TcpipAddress');
    if(obj) TcpipAddress=obj.value; 
	var obj=document.getElementById('Port');
	if(obj) Port=obj.value;
	var obj=document.getElementById('InterfaceProgramID');
	if(obj) InterfaceProgramID=obj.value;
	var obj=document.getElementById('InterfaceProgram');
	if(obj) InterfaceProgram=obj.value;
	var obj=document.getElementById('DefaultInterval');
	if(obj) DefaultInterval=obj.value;
	var obj=document.getElementById('EditTcpipAddress');
	if(obj) EditTcpipAddress=obj.value;
	var obj=document.getElementById('UpdateBedEquip')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,Rowid,BedRowid,EquipRowid,TcpipAddress,Port,InterfaceProgramID,DefaultInterval,EditTcpipAddress);
	    if (resStr==100) {alert(t['04'])
		 return}
	    if (resStr!='0'){
			alert(t['baulk']+":"+resStr);
			return;
			}	
		try {
        alert(t['succeed']);
	    window.location.reload();
	    window.parent.frames['RPBottom'].location.reload();
		} catch(e) {};
		}
}
function DELETE_click(){
	if (preRowInd<1) return;
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['05']) 
		return;
		}
	var obj=document.getElementById('DeleteBedEquip')
	if(obj) var encmeth=obj.value;
	var resStr=cspRunServerMethod(encmeth,Rowid)
	if (resStr!='0')
		{alert(t['baulk']);
		return;}	
	try {
        alert(t['succeed']);
	    window.location.reload();
	    //window.parent.frames['RPBottom'].location.reload();
		} catch(e) {};
}
function addok(value)
	{if (value==0) {
		var findobj=document.getElementById('Find');
		if (findobj) findobj.click();
	//	window.location.reload();
		}}
function LookUpBed(value){
	var temp
 	temp=value.split("^")
 	BedRowid=temp[1]
 	document.getElementById('BedRowid').value=BedRowid
	}
function LookUpWard(value){
	var temp
 	temp=value.split("^")
 	document.getElementById('wardId').value=temp[1]
	}
function LookUpEquip(value){
	var temp
 	temp=value.split("^")
 	EquipRowid=temp[1]
	document.getElementById('EquipRowid').value=EquipRowid
	}
function LookUpInterfaceProgram(value){
    var temp=value.split("^")
    document.getElementById("InterfaceProgram").value = temp[2]
    document.getElementById("InterfaceProgramID").value=temp[0];
    }
function LookUpPort(value){
	
    var temp=value.split("^")
    document.getElementById("PortDesc").value = temp[1]
    document.getElementById("Port").value=temp[0];
    }
function SetDefault_click(){
	var Bedobj=document.getElementById('Bed');
	var wardObj = document.getElementById('WardDesc');
	var bedRowIdObj = document.getElementById('BedRowId');
	var tipStr="确认设为默认？\n"+"病区："+wardObj.value+"\n床位："+Bedobj.value;
	if(!confirm(tipStr))return;
	var obj=document.getElementById('SetDefault')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,bedRowIdObj.value);
	}
	}
function RecoveryDefault_click(){
	var Bedobj=document.getElementById('Bed');
	var wardObj = document.getElementById('WardDesc');
	var bedRowIdObj = document.getElementById('BedRowId');
	var tipStr="确认恢复默认？\n"+"病区："+wardObj.value+"\n床位："+Bedobj.value;
	if(!confirm(tipStr))return;
	var obj=document.getElementById('RecoveryDefault')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,bedRowIdObj.value);
	    window.location.reload();
	}
	}
	var comboList=new Array();;
function InitComBox(name,items){
	var obj=dhtmlXComboFromSelect(name);
    obj.addOptionStr(items);
    obj.selectHandle=Selecthandler;
    comboList[name]=obj;
	}

function Selecthandler(){
	var obj=window.event.srcElement;
	var name=obj.name;
	name = "InterfaceProgram";
	if (!name)return;
	var DocRowId=comboList[name].getActualValue();
	var DocDesc=comboList[name].getSelectedText();
	obj.value=DocDesc;
	var idName=name+"ID";
	var idObj=document.getElementById(idName);
	if(idObj)idObj.value=DocRowId;
}
function SetConfirmedTime(){
	var obj=document.getElementById('confirmedTime');
	var min = obj.value;
	var obj=document.getElementById('SetConfirmedTime');
	var SetConfirmedTime=obj.value;

	var min=cspRunServerMethod(SetConfirmedTime,min)
	alert(t['succeed']);
}
function hide(id){
        document.getElementById(id).style.visibility="hidden";//隐藏
    }
function show(id){
        document.getElementById(id).style.visibility="visible";//隐藏
    }
document.body.onload = BodyLoadHandler;