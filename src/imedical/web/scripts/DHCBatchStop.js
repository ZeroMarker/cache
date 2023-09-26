//DHCOPTepChange.js
document.body.onload = BodyLoadHandler;

var mDoctorId="";
var mDepRowId="";
var mReasonRowId="";
var SelectedRow=0;
function BodyLoadHandler(){
	var obj=document.getElementById("Stop");
	if(obj)obj.onclick=Stop_Click;
	var obj=document.getElementById("Update");
	if(obj)obj.onclick=Update_Click;
	
	var Loc=DHCC_GetElementData('Loc');
	if (document.getElementById('Loc')){
			var DepStr=DHCC_GetElementData('DepStr');
			combo_ERepLoc=dhtmlXComboFromStr("Loc",DepStr);
			combo_ERepLoc.enableFilteringMode(true);
			combo_ERepLoc.selectHandle=combo_ERepLocKeydownhandler;
			
			combo_ERepLoc.setComboText(Loc);
		}
	if (document.getElementById('Doc')){
			combo_ERepDoctor=dhtmlXComboFromStr("Doc",'');
			combo_ERepDoctor.enableFilteringMode(true);
			combo_ERepDoctor.selectHandle=combo_ERepDoctorKeydownhandler;
		}
	if (document.getElementById('Reason')){
			var ReasonStr=DHCC_GetElementData('ReasonStr');
			combo_EStopReason=dhtmlXComboFromStr("Reason",ReasonStr);
			combo_EStopReason.enableFilteringMode(true);
			combo_EStopReason.selectHandle=combo_EStopReasonKeydownhandler;
		}		
}
function SetRepDocDetail(DepRowId,DocRowId){
	if ((DocRowId=="")||(DepRowId=="")){
		return;
	}
	var encmeth=DHCC_GetElementData('GetResDocDetailMethod');
	if (encmeth!=''){
		var retDetail=cspRunServerMethod(encmeth,DepRowId,DocRowId);
		var Arr=retDetail.split('^');
		var ResClinicGroupRowId=Arr[0];
		var ResSessionTypeRowId=Arr[1];
		if (ResSessionTypeRowId!=""){
			combo_ERepSessionType.setComboValue(ResSessionTypeRowId);
		}else{
			combo_ERepSessionType.setComboText('');
		}
	}	
}
function combo_ERepDoctorKeydownhandler(e){
	var DepRowId=DHCC_GetElementData('DepId')
	var DocRowId=DHCC_GetComboValue(combo_ERepDoctor);
	mDoctorId=DocRowId;
	SetRepDocDetail(DepRowId,DocRowId);
	websys_nexttab(combo_ERepDoctor.tabIndex);
	
}

function combo_ERepLocKeydownhandler(e){
	var DepRowId=combo_ERepLoc.getActualValue();
	mDepRowId=DepRowId
	DHCC_SetElementData('DepId',DepRowId);
	if (combo_ERepDoctor){
		combo_ERepDoctor.clearAll();
		combo_ERepDoctor.setComboText("");
		var encmeth=DHCC_GetElementData('GetResDocEncrypt');
		if ((encmeth!="")&&(DepRowId!="")){
			combo_ERepDoctor.addOption('');
			var DocStr=cspRunServerMethod(encmeth,DepRowId,"","","",1);
			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				combo_ERepDoctor.addOption(Arr);
			}
		}
	}	
	websys_nexttab(combo_ERepLoc.tabIndex);
}

function combo_EStopReasonKeydownhandler(e){
	var ReasonRowId=combo_EStopReason.getActualValue();      //by shp  20120507
	mReasonRowId=ReasonRowId
	websys_nexttab(combo_EStopReason.tabIndex);
}

function Stop_Click()
{
  var StartDate=DHCC_GetElementData('StartDate');
  var EndDate=DHCC_GetElementData('EndDate');
  var Loc=DHCC_GetElementData('Loc');
  var Doc=DHCC_GetElementData('Doc');  

  if(StartDate==""){alert("开始日期不能为空!");
  return;
  }
  if(EndDate==""){alert("结束日期不能为空!");
  return;
  }
  if(Loc==""){alert("科室不能为空!");
  return;
  }
  if(Doc==""){alert("医生不能为空!");
  return;
  }
  var ComDateFlag=CompareDate(StartDate,EndDate)
  if (!ComDateFlag){
	  alert("请选择有效的日期时段!")
	  return;
  }
  
  //判断是否有生成排班或预约记录
  var encmethCheck=DHCC_GetElementData('CheckResData');
  if(encmethCheck!=""){
	var retValue=cspRunServerMethod(encmethCheck,StartDate,EndDate,mDepRowId,mDoctorId);
	var StrArr=retValue.split("^");
	if((StrArr[0]=="-200")&&(StrArr[1]=="")){
		var rtn=confirm("此医生在此范围有排班记录?");
		if (!rtn){return}
	}
	else if((StrArr[0]=="")&&(StrArr[1]=="-201")){
		var rtn=confirm("此医生已经有预约记录?");
		if (!rtn){return}
	}
	else if((StrArr[0]=="-200")&&(StrArr[1]=="-201")){
		var rtn=confirm("此医生在此范围有排班记录,并且已经有预约记录?");
		if (!rtn){return}
	}
	else{}
  }
  var Reason=DHCC_GetElementData('Reason');
  var Notes=DHCC_GetElementData('Notes');
  var UserID=session['LOGON.USERID'];   
  var encmeth=DHCC_GetElementData('StopEncrypt');
  if(encmeth!="")
  {
      var ret=cspRunServerMethod(encmeth,StartDate,EndDate,mDepRowId,mDoctorId,mReasonRowId,Notes,UserID,"S");
      if(ret=="0")alert("操作成功!");
      else if(ret=="-202")alert("插入表失败!");
      else if(ret=="Repeat")alert("该记录已存在或此日期内不存在有效的排班记录!");
      else alert("操作失败!");
      
  }
  var ref="websys.default.csp?WEBSYS.TCOMPONENT=DHCBatchStop";
  location.href=ref;	
}
function Update_Click()
{
	var StartDate=DHCC_GetElementData('StartDate');
    var EndDate=DHCC_GetElementData('EndDate');
    if(SelectedRow==0){
	    alert("请选择行!");
	    return;
	    }
    var NARowId=DHCC_GetColumnData("NARowid",SelectedRow)
 
    var UserID=session['LOGON.USERID'];
    var encmeth=DHCC_GetElementData('UpdateEncrypt');
    if(encmeth!="")
    {
	  var NAFlag=DHCC_GetColumnData("NAFlag",SelectedRow)
      if (NAFlag=="N"){alert("该记录已经为撤销状态不需撤销!");return}
	  var ret=cspRunServerMethod(encmeth,NARowId,UserID,"N");
      if(ret=="0")alert("操作成功!");
      else if(ret=="-203")alert("请选择行!");
      else if(ret=="Repeat")alert("该记录已存在撤销状态记录,无需再撤销!");
      else alert("操作失败!");
	}
	var ref="websys.default.csp?WEBSYS.TCOMPONENT=DHCBatchStop";
    location.href=ref;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCBatchStop');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		SelectedRow = selectrow;
	}else{
		SelectedRow=0
	}
}
function Clear_Click()
{
	DHCC_SetElementData("ERepLoc","")
	DHCC_SetElementData("ERepSessionType","")
	DHCC_SetElementData("ETimeRange","")
	DHCC_SetElementData("NewAdmDoc","")	
	DHCC_SetElementData("OldAdmDoc","")	

}