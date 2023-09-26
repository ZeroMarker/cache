var comb_loc;
var comb_SessionType;
var comb_ClinicGroup;
var combo_MarkCode;
var AllDocStr;
var isLocChange=false;
var isDocChange=false;

document.body.onload = BodyLoadHandler;
var e=event;
function BodyLoadHandler() {
	
	if (websys_$('MarkCode')){
	combo_MarkCode=dhtmlXComboFromSelect("MarkCode","");
	combo_MarkCode.enableFilteringMode(true);
	combo_MarkCode.attachEvent("onChange",function(){
	try {
 	var docID=combo_MarkCode.getSelectedValue();
 	comb_loc.setComboText("");
 	SetResLocList(docID);
	isDocChange= true;
	isLocChange= false;
	
	
	}catch(e){
		alert(e.message);
   }
		});
	
	var encmeth=DHCC_GetElementData('GetResDocEncrypt');
	AllDocStr=cspRunServerMethod(encmeth,"");
	if (AllDocStr!=""){
		var Arr=DHCC_StrToArray(AllDocStr);
		if (combo_MarkCode) combo_MarkCode.addOption(Arr);
	}
 }
	
	var TimeRangeStr=DHCC_GetElementData('TimeRangeStr');
	PutTimeRange=dhtmlXComboFromStr("TimeRange",TimeRangeStr);
	PutTimeRange.enableFilteringMode(true);
	PutTimeRange.selectHandle=PutTimeRangeselectHandle;
	
	quickK.f9=websys_$('BtnUpdate').onclick;
  quickK.addMethod();
	
document.onkeydown=nextfocus1;	
websys_$('Docter').multiple=false
websys_$('Docter').onchange = function(){
var encmeth =websys_$V('GetResourcMeth');
if(encmeth!='') {
	  var tmp=websys_$("Docter").value.split(String.fromCharCode(2))
	  if(isDocChange){
	  
	 	comb_loc.setComboValue(tmp[1]);
	 	setClinicGroup();
	  }
	  if(isLocChange){
	 
    combo_MarkCode.setComboValue(tmp[1]);
	  }
	  	  
 	  var retDetail=cspRunServerMethod(encmeth,tmp[0]);
 	  var clinicGroupDR = retDetail.split("^")[0];
 	  var sessionType = retDetail.split("^")[1];
 	  websys_$("RESLoad").value = retDetail.split("^")[2];
 	  websys_$("RESAppLoad").value = retDetail.split("^")[3];
 	  websys_$("RESAppStartNum").value = retDetail.split("^")[4];
 	  websys_$("RESAddLoad").value = retDetail.split("^")[5];
 	  var RESEPMarkFlag=(retDetail.split("^")[9]=='Y')?true:false;
 	  DHCC_SetElementData("RESEPMarkFlag",RESEPMarkFlag);
 	  var RESAllowGetSeqNoFlag=(retDetail.split("^")[13]=='Y')?true:false;
 	  DHCC_SetElementData("RESAllowGetSeqNoFlag",RESAllowGetSeqNoFlag);
 	  if(clinicGroupDR.Trim()!="")
 	  comb_ClinicGroup.setComboValue (clinicGroupDR);
    else comb_ClinicGroup.setComboText("");
 	  if(sessionType.Trim()!="")
 	  comb_SessionType.setComboValue(sessionType);
 	  else comb_SessionType.setComboText("");
 	 
 }
 PutTimeRangeselectHandle();
}
    websys_$("updateNew").onclick = function(){
	    if(websys_$("Docter").value=="") {alert(t['5']);return ;}
	    if(!checkNew()) return ;
	    var id=websys_$("Docter").value.split(String.fromCharCode(2))[0];
	    var TimeRangeRowId=PutTimeRange.getSelectedValue();
	    var ASLoad=websys_$V("ResLoadNew").Trim();
	    var AppLoad=websys_$V("ResAppLoadNew").Trim();
	    var AppStartNum=websys_$V("ResAppStartNew").Trim();
	    var AutoLoad="" //websys_$V("AutoLoadNew").Trim();
	    var ExtLoad="" //websys_$V("ExtLoadNew").Trim();
        var para=id+"^"+TimeRangeRowId+"^"+ASLoad+"^"+AppLoad+"^"+AppStartNum+"^"+AutoLoad+"^"+ExtLoad;
        var rtn=tkMakeServerCall('web.DHCRBResource','TRRBResourceServerSave',para);
        if (rtn>0){
	        alert("更新成功!")
	    }else{
		    alert("更新失败!")
		}
	}
websys_$("BtnUpdate").onclick = function(){
if(websys_$("Docter").value=="") {alert(t['5']);return ;}
if(!check()) return ;
if (document.getElementById('RESEPMarkFlag').checked==true){RESEPMarkFlag='Y'} else{RESEPMarkFlag='N'} ;
var RESAllowGetSeqNoFlag=DHCC_GetElementData("RESAllowGetSeqNoFlag");
RESAllowGetSeqNoFlag=(RESAllowGetSeqNoFlag==true)?'Y':'N'
var entityInfo=["ID="+websys_$("Docter").value.split(String.fromCharCode(2))[0],
								"RESClinicGroupDR="+comb_ClinicGroup.getSelectedValue(),
								"RESSessionTypeDR="+comb_SessionType.getSelectedValue(),
								"RESLoad="+websys_$V("RESLoad").Trim(), 
 								"RESAppLoad="+websys_$V("RESAppLoad").Trim(), 
								"RESAppStartNum="+websys_$V("RESAppStartNum").Trim(),
								"RESAddLoad="+websys_$V("RESAddLoad").Trim(),
								"RESEPMarkFlag="+RESEPMarkFlag,
								"RESAllowGetSeqNoFlag="+RESAllowGetSeqNoFlag
                ];
                
var resource=Card_GetEntityClassInfoToXML(entityInfo);

var encmeth=websys_$V('BtnUpdateClass');

if(encmeth!=''){
	var returnvalue=cspRunServerMethod(encmeth,resource);
  if(returnvalue=="0")alert(t['3']);
  else alert(t['4'])
 }
}
comb_loc=dhtmlXComboFromSelect("RESCTLOCDR");
comb_loc.enableFilteringMode(true);
comb_SessionType=dhtmlXComboFromSelect("RESSessionTypeDR");
comb_SessionType.enableFilteringMode(true);
comb_ClinicGroup=dhtmlXComboFromSelect("RESClinicGroupDR");
comb_ClinicGroup.enableFilteringMode(true);
comb_loc.attachEvent("onChange",function(event){ 
 try {
 	var LocID=comb_loc.getSelectedValue();
 	combo_MarkCode.setComboText("");
	SetResDocList(LocID);
	setClinicGroup();
	isLocChange=true;
	isDocChange=false;
	
	}catch(e){
		alert(e.message);
   }
  }) 
	quickK.f9=websys_$("BtnUpdate").onclick;
  quickK.addMethod();
}
function MarkCodeNewLookUp(Value){
	var docID=Value.split("^")[1];
	SetResLocList(docID);
	isDocChange= true;
	isLocChange= false;
}
function SetResDocList(LocID){
	
	var obj=websys_$('GetResDocMethod');
  if (obj) {
	var encmeth=obj.value;
	//alert("encmeth:"+encmeth);

		if (encmeth!=''){
				var obj=websys_$('Docter');
				ClearAllList(obj);
				if(LocID.Trim()=="") return ;
				
			var retDetail=cspRunServerMethod(encmeth,"AddToResDocList",LocID);
			if (retDetail==1) return true;
		}
	}	
}

function SetResLocList(docID){

	var obj=websys_$('GetLocListMethed');
	if (obj) {
	
  var encmeth=obj.value;

	if (encmeth!=''){
	var obj=websys_$('Docter');
	ClearAllList(obj);
	if(docID.Trim()=="") return ;
	
   var retDetail=cspRunServerMethod(encmeth,"AddToResDocList",docID);
	if (retDetail==1) return true;
		}
	}	
}


function AddToResDocList(val){

	var obj=websys_$('Docter');
	ClearAllList(obj)
	var DocArray=val.split("^");
	for (var i=0;i<DocArray.length;i++) {
		var DocData=DocArray[i].split(String.fromCharCode(1));
		obj.options[obj.length] = new Option(DocData[1],DocData[0]);
	}
}
function ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}

function setClinicGroup(){
var encmeth=websys_$V("GetClinicListMeth");
var retDetail=cspRunServerMethod(encmeth, comb_loc.getSelectedValue());
var x=new Array();
 var Arr=retDetail.split('^');
 for(var i=0;i<Arr.length;i++){
 	var Arr1=Arr[i].split(String.fromCharCode(1));
	var label=Arr1[1];
	var val=Arr1[0];
	if((typeof(val)=="undefined")||(val===null))val=label;
	x[i]=[val,label];
 }

comb_ClinicGroup.clearAll();
comb_ClinicGroup.addOption(x);


}

function nextfocus1() {	
	var eSrc=window.event.srcElement;	
	//var t=eSrc.type;		&& t=='text'
	var key=websys_getKey(e);	
	if (key==13) {	
		websys_nexttab(eSrc.tabIndex);
	}
}

function check(){
//	var f = (websys_$V('RESAppStartNum')==""||websys_$V('RESAppStartNum')=="0")&&(websys_$V('RESAppLoad')==""||websys_$V('RESAppLoad')=="0") ;
	//alert(f);
//	if(f) return true;
	var RESLoad=websys_$V('RESLoad').Trim();
	var RESAppStartNum =websys_$V('RESAppStartNum').Trim();
	var RESAppLoad = websys_$V('RESAppLoad').Trim();
	var RESAddLoad = websys_$V('RESAddLoad').Trim();
	 var filter =  /^\d*$/;

	 if(!(filter.test(RESLoad)&&filter.test(RESAppStartNum)&&filter.test(RESAppLoad)&&filter.test(RESAddLoad))){
	 {
	 alert("只能是数字");
	 return false;
	}
	}
	
	//var t=RESLoad&&RESAppStartNum&&RESAppLoad  ;
	//if(!t){alert("数据不完整");return false;}
	 RESLoad=parseInt(websys_$V('RESLoad'));
	 RESAppStartNum =parseInt(+websys_$V('RESAppStartNum'));
	 RESAppLoad = parseInt(websys_$V('RESAppLoad'));
	 RESAddLoad = parseInt(websys_$V('RESAddLoad'));
	 var f = ((websys_$V('RESAppStartNum')==""&&websys_$V('RESAppLoad')==""&&websys_$V('RESAddLoad')=="")) ;
	 if(f) return true;
	 if(!(RESLoad-RESAppStartNum+1>=RESAppLoad)) {alert('预约起始号加预约限额不能大于正号限额');return false;} 
	 else return true;                                                                                                                                                
}
function checkNew(){
	
    var TimeRangeRowId=PutTimeRange.getSelectedValue();
    if (TimeRangeRowId=="") {
	    alert("请先选择出诊时段!")
	    return false;
	}
    var ASLoad=websys_$V("ResLoadNew").Trim();
    var AppLoad=websys_$V("ResAppLoadNew").Trim();
    var AppStartNum=websys_$V("ResAppStartNew").Trim();
    //var AutoLoad=websys_$V("AutoLoadNew").Trim();
    //var ExtLoad=websys_$V("ExtLoadNew").Trim();
	var filter =  /^\d*$/;
	//if(!(filter.test(ASLoad)&&filter.test(AppLoad)&&filter.test(AppStartNum)&&filter.test(AutoLoad)&&filter.test(ExtLoad))){{
	  if(!(filter.test(ASLoad)&&filter.test(AppLoad)&&filter.test(AppStartNum))){{
		 alert("只能是数字");
		 return false;
	   }
	}
	//var f = ((websys_$V('RESAppStartNum')==""&&websys_$V('RESAppLoad')==""&&websys_$V('RESAddLoad')=="")) ;
	//if(f) return true;
	if(!(ASLoad-AppStartNum+1>=AppLoad)) {
		 alert('预约起始号加预约限额不能大于正号限额');
		 return false;
	} else {
		return true; 
	}                                                                                                                                               
}
function PutTimeRangeselectHandle(){
	var TRRowId=PutTimeRange.getSelectedValue();
	if(TRRowId=="") return false;
	if(websys_$("Docter").value!="") {
		var id=websys_$("Docter").value.split(String.fromCharCode(2))[0];
		var rtn=tkMakeServerCall('web.DHCRBResource','GetTimeRangeResourceById',id,TRRowId);
		if(rtn=="") {
			websys_$("ResLoadNew").value="";
		    websys_$("ResAppLoadNew").value="";
		    websys_$("ResAppStartNew").value="";
		    //websys_$("AutoLoadNew").value="";
		    //websys_$("ExtLoadNew").value="";
		}else{
			websys_$("ResLoadNew").value=rtn.split("^")[2];
		    websys_$("ResAppLoadNew").value=rtn.split("^")[3];
		    websys_$("ResAppStartNew").value=rtn.split("^")[4];
		    //websys_$("AutoLoadNew").value=rtn.split("^")[5];
		    //websys_$("ExtLoadNew").value=rtn.split("^")[6];
		}
	    
	}
}