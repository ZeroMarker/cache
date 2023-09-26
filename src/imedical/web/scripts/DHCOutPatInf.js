document.write("<object ID='ClsDHCPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:2759E092-B26D-4A60-B353-4F7402A4BC95' CODEBASE='../addins/client/DHCRegPring.CAB#version=1,0,0,0' VIEWASTEXT>");
document.write("</object>");
function DocumentLoadHandler() {
	var RegNoObj=document.getElementById('prt');
	if (RegNoObj) RegNoObj.onclick = prt_click;
	var RegNoObj=document.getElementById('ID');
	if (RegNoObj) RegNoObj.onkeydown = RegNoObj_keydown;
	var NameObj=document.getElementById('Name');
	if (NameObj) NameObj.onchange = NameObj_onchange;
	if (NameObj) NameObj.onkeydown = nextfocus;
	var Obj=document.getElementById('Birth');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('Sex');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('PatType');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('InMedicare');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('OpMedicare');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('TelNo');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('IDCardNo1');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('Vocation');
	if (Obj) Obj.onkeydown = nextfocus;
	var Obj=document.getElementById('Company');
	if (Obj) Obj.onkeydown = nextfocus;
	var AddressObj=document.getElementById('Address');
	if (AddressObj) AddressObj.onkeydown = AddressObj_keydown;
	var IDCardNo1Obj=document.getElementById('IDCardNo1');
	if (IDCardNo1Obj) IDCardNo1Obj.onchange = IDCardNo1Obj_onchange;
 	var Obj=document.getElementById('Find');
	if (Obj) Obj.onclick = Find_click;
	var Obj=document.getElementById('Quit');
	if (Obj) Obj.onclick = Quit_click;
	var Obj=document.getElementById('ReadCard');
	if (Obj) Obj.onclick = ReadCard_click;
	var Obj=document.getElementById('Save');
	if (Obj) Obj.onclick = Save_click;
	var Obj=document.getElementById('PatInfoFind');
	if (Obj) Obj.onclick = PatInfoFind_click;
	var Obj=document.getElementById('Clear');
	if (Obj) Obj.onclick = Clear_click;
}
function prt_click()
{
	 
 var id=document.getElementById('ID').value;
 var name=document.getElementById('Name').value;
 
  if (id==""){
	 alert(t['01']);
	 websys_setfocus('ID');
 }
  if ((id!="")&&(name=="")){
	 alert(t['02']);
	 websys_setfocus('ID');
 }
 
 if ((id!="")&&(name!="")) {
 //alert(id+"!"+name);
 ClsDHCPrint.push_tm(id); 
 
  }
}
function PatInfoFind_click()
{
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPPatInfoFind";
	win=open(lnk,"PatInfoFind","status=1,scrollbars=1,top=100,left=100,width=760,height=420");
}
function Quit_click()
{
  //alert("sdsds")
  window.close()
}

function Save_click(){
	SavePatInfo()
}

function Clear_click()
{
  			var tmp=document.getElementById('ID');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Name');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Sex');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Birth');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('TelNo');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('OpMedicare');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('InMedicare');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('PatType');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('IDCardNo1');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Vocation');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Company');
			if (tmp) tmp.value = "";
			var tmp=document.getElementById('Address');
			if (tmp) tmp.value = "";
			websys_setfocus('ID')
}

function ReadCard_click()
{
  var RegNoObj=document.getElementById('ID');
	if (RegNoObj) {
		//RegNoObj.value="MR000100";
		var count
	    var fs, f1; 
	    var Temptxt
	    var TempArr
	    count = 0
	    ReplyFile="d:\\aabb.txt"
	    alert(ReplyFile)
	    fs = new ActiveXObject("Scripting.FileSystemObject");
        if (fs.FileExists(ReplyFile)){
	        f1=fs.OpenTextFile(ReplyFile,"1");
	        do {
        	    Str = f1.ReadLine(); 
			    //alert(Str)
			    //return
            	count=count+1  
            	var GetDetail=document.getElementById('InsertPatInfo');
				if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'InsetPatInfo_Event','',count,Str)=='0') {
				}
			
            } while  (! f1.AtEndOfStream)
            f1.Close();
             alert(count)

	    }
	
	}


}
function InsetPatInfo_Event(value){
	try {
		if (value!=0){
			if (!confirm(value + " Errors Occur,Continue?")) {
      			return
   			}
		}
	} catch(e) {};
}
//
function nextfocus() {
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

//Duplicate name
function NameObj_onchange(e) {
	if (evtName=='Name') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
		var obj=document.getElementById('Name');
		
		if (obj.value!='') {
			var tmp=document.getElementById('Name');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			var GetDetail=document.getElementById('GetName');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'GetDupName_count','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('Name');	
			return websys_cancel();
			}
		obj.className='';
	}
}


function GetDupName_count(value) {
	try {
		Name_obj=document.getElementById('Name');
		PatName=Name_obj.value
		if (value>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind&FID="+""+"&NAME="+PatName+"&IDCardNo="+""+"&TelNo="+""+"&InMedicare="+"";
			win=open(lnk,"FindPatBase","width=760,height=400");
		}
		
	} catch(e) {};
}

//Duplicate IDCardNo
function IDCardNo1Obj_onchange(e) {
	if (evtName=='IDCardNo1') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
		var obj=document.getElementById('IDCardNo1');
		if (obj.value!='') {	
			var tmp=document.getElementById('IDCardNo1');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			var GetDetail=document.getElementById('GetIDCardNo');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'GetDupIDCardNo1_count','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('Sex');	
			return websys_cancel();
			}
		obj.className='';
	}
}


function GetDupIDCardNo1_count(value) {
	try {
		IDCardNo1_obj=document.getElementById('IDCardNo1');
		IDCardNo1Name=IDCardNo1_obj.value
		if (value>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind&FID="+""+"&NAME="+""+"&IDCardNo="+IDCardNo1Name+"&TelNo="+""+"&InMedicare="+"";
			win=open(lnk,"NewWin","width=760,height=400");
		}
		
		//websys_nexttab('6');
	} catch(e) {};
}

//Commit from Address

function AddressObj_keydown(e) {
	//alert(self.name)
	if (evtName=='Address') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}

	var key=websys_getKey(e);
	if (key==13 ) {
		    //ID,Name,Sex,Birth,TelNo,OpMedicare,InMedicare,PatType,Vocation,Company,Address
			//var tmp=document.getElementById('Address');
			//if (tmp) {var p1=tmp.value } else {var p1=''};
			SavePatInfo()		
			
	
	}
}


function SavePatInfo(){
			
			var PatDetailPar=""
			var tmp=document.getElementById('ID');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=p1
			var tmp=document.getElementById('Name');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('Sex');
			if (tmp) {var p1=tmp.value;} else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('Birth');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('TelNo');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('OpMedicare');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('InMedicare');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('PatType');
			if (tmp) {
				var p1=tmp.value
				if (p1==""){
					alert(t["03"])
					return
				} 
			} else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('IDCardNo1');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1

			var tmp=document.getElementById('Vocation');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			
			var tmp=document.getElementById('Company');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1
			var tmp=document.getElementById('Address');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			PatDetailPar=PatDetailPar+"^"+p1

			
			
			var GetDetail=document.getElementById('CommitPatDetail');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'Commit_PatDetail','',PatDetailPar)=='0') {
			//obj.className='clsInvalid';
			//websys_setfocus('Name');	
			return websys_cancel();
		
		}
		obj.className='';
}

function Commit_PatDetail(value) {
	try {
		if (value!=0) {
		 alert("Update Patient Detail failed,Please check every Item!")			
		}
		Clear_click()
		//websys_setfocus('ID')
	} catch(e) {};
}



//Input Patient RegNo
function RegNoObj_keydown(e) {
	//
	if (evtName=='ID') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		FindPatDetail()
	}
}

function FindPatDetail(){
		var obj=document.getElementById('ID');
		if (obj.value!='') {	
			if (obj.value.length<8) {
				for (var i=(8-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
			}}
		
			var tmp=document.getElementById('ID');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			var GetDetail=document.getElementById('GetDetail');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',p1)=='0') {
			obj.className='clsInvalid';
			return websys_cancel();
			}
		}
		
		obj.className='';
}

function SetPatient_Sel(value) {
	try {
		var Split_Value=value.split("^")
		var obj_Name=document.getElementById('Name');
		var obj_Sex=document.getElementById('Sex');
		var obj_Birth=document.getElementById('Birth');
		var obj_TelNo=document.getElementById('TelNo');
		var obj_IDCardNo=document.getElementById('IDCardNo1');
		var obj_InMedicare=document.getElementById('InMedicare');
		var obj_PatType=document.getElementById('PatType');
		var obj_Address=document.getElementById('Address');
		var obj_OpMedicare=document.getElementById('OpMedicare');
		var obj_Company=document.getElementById('Company');

		
		if (obj_Name) {
  			obj_Name.value=unescape(Split_Value[0]);
			obj_Name.className='';
			//websys_nexttab('6');		
		}
		if (obj_Sex) {
  			obj_Sex.value=unescape(Split_Value[2]);
			obj_Sex.className='';
			//websys_nexttab('6');
		}
		if (obj_Birth) {
  			obj_Birth.value=unescape(Split_Value[1]);
			obj_Birth.className='';
			//websys_nexttab('6');
		}
		if (obj_TelNo) {
  			obj_TelNo.value=unescape(Split_Value[4]);
			obj_TelNo.className='';
			//websys_nexttab('6');
			//alert(obj_TelNo.tabIndex);
		}
		if (obj_IDCardNo) {
  			obj_IDCardNo.value=unescape(Split_Value[3]);
			obj_IDCardNo.className='';
			//websys_nexttab('6');
		}
		if (obj_InMedicare) {
  			obj_InMedicare.value=unescape(Split_Value[5]);
			obj_InMedicare.className='';
			//websys_nexttab('6');
		}
		if (obj_PatType) {
  			obj_PatType.value=unescape(Split_Value[6]);
			obj_PatType.className='';
			//websys_nexttab('6');
		}
		if (obj_Address) {
  			obj_Address.value=unescape(Split_Value[7]);
			obj_Address.className='';
			//websys_nexttab('6');
		}
		if (obj_OpMedicare) {
  			obj_OpMedicare.value=unescape(Split_Value[8]);
			obj_OpMedicare.className='';
			//websys_nexttab('6');
		}
		if (obj_Company) {
  			obj_Company.value=unescape(Split_Value[9]);
			obj_Company.className='';
			//websys_nexttab('6');
		}
		if (obj_Name.value!=""){
		websys_setfocus("Name");
		}
	} catch(e) {};
}



//sex
function Sex_lookupsel(value) {
	try {
		var obj=document.getElementById('Sex');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		//websys_nexttab('6');
		}
	} catch(e) {};
}
function Sex_changehandler(encmeth) {
	evtName='Sex';
	if (doneInit) { evtTimer=window.setTimeout("Sex_changehandlerX('"+encmeth+"');",200); }
	else { Sex_changehandlerX(encmeth); evtTimer=""; }
}
function Sex_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=document.getElementById('Sex');
	if (obj.value!='') {
		var tmp=document.getElementById('Sex');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		if (cspRunServerMethod(encmeth,'Sex_lookupsel','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('Sex');
			return websys_cancel();
		}
	}
	obj.className='';
}


//socialstatus
function PatType_lookupsel(value) {
	try {
		var obj=document.getElementById('PatType');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		//websys_nexttab('6');
		}
	} catch(e) {};
}
function PatType_changehandler(encmeth) {
	
	evtName='PatType';
	if (doneInit) { evtTimer=window.setTimeout("PatType_changehandlerX('"+encmeth+"');",200); }
	else { PatType_changehandlerX(encmeth); evtTimer=""; }
}
function PatType_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=document.getElementById('PatType');
	if (obj.value!='') {
		var tmp=document.getElementById('PatType');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		if (cspRunServerMethod(encmeth,'PatType_lookupsel','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('PatType');
			return websys_cancel();
		}
	}
	obj.className='';
}
	
function Find_click()
{
	

	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind";
	win=open(lnk,"NewWin","top=150,left=150,width=760,height=400");
}

document.body.onload = DocumentLoadHandler;

