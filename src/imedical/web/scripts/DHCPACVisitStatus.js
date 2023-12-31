//DHCPACVisitStatus.js
var SelectedRow = 0;
var preRowInd=0;
var PVSRowId="";
function BodyLoadHandler(){
	var obj=document.getElementById('btnAdd')
	if(obj) obj.onclick=BADD_click;
	var obj=document.getElementById('btnUpdate')
	if(obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById('btnDelete')
	if(obj) obj.onclick=BDelete_click;
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPACVisitStatus');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('PVSCode');
	var obj1=document.getElementById('PVSDesc');
	var obj2=document.getElementById('PVSEpisodeType');
	var obj3=document.getElementById('EpisodeStatus');
	var obj4=document.getElementById('DateFrom');
	var obj5=document.getElementById('DateTo');
	var obj6=document.getElementById('DoctorAccess');
	var obj7=document.getElementById('NurseAccess');
	var obj8=document.getElementById('PreVisitStat');
	var obj9=document.getElementById('PreVisitStatDr');	
	
	var SelRowObj=document.getElementById('tPVSCodez'+selectrow);
	var SelRowObj1=document.getElementById('tPVSDescz'+selectrow);
	var SelRowObj2=document.getElementById('tPVSEpisodeTypez'+selectrow);
	var SelRowObj3=document.getElementById('tEpisodeStatusz'+selectrow);
	var SelRowObj4=document.getElementById('tDateFromz'+selectrow);
	var SelRowObj5=document.getElementById('tDateToz'+selectrow);
	var SelRowObj6=document.getElementById('tDoctorAccessz'+selectrow);
	var SelRowObj7=document.getElementById('tNurseAccessz'+selectrow);
	var SelRowObj8=document.getElementById('tPreVisitStatz'+selectrow);
	var SelRowObj9=document.getElementById('tPreVisitStatIdz'+selectrow);
	var SelRowObj10=document.getElementById('RowIdz'+selectrow);

	if (preRowInd==selectrow){
	   	obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value="";
		obj4.value="";
		obj5.value="";
		obj6.checked=false;
		obj7.checked=false;
		obj8.value="";
		obj9.value="";
		PVSRowId=""
   		preRowInd=0;
    }
   	else{
		if (obj) obj.value=SelRowObj.innerText;
		if (obj1) obj1.value=SelRowObj1.innerText;
		if (obj2) obj2.value=SelRowObj2.innerText;
		var EpisodeStatus=SelRowObj3.innerText;
		EpisodeStatus=EpisodeStatus.replace(" ","");
		if (obj3) obj3.value=EpisodeStatus;
		var DateFrom=SelRowObj4.innerText;
		DateFrom=DateFrom.replace(" ","");
		if (obj4) obj4.value=DateFrom;
		var DateTo=SelRowObj5.innerText;
		DateTo=DateTo.replace(" ","");
		if (obj5) obj5.value=DateTo;
		var DoctorAccess=SelRowObj6.innerText;
		if (obj6)
		{
			if (DoctorAccess=="Y") obj6.checked=true;
			else obj6.checked=false;
		}
		var NurseAccess=SelRowObj7.innerText;
		if (obj7)
		{
			if (NurseAccess=="Y") obj7.checked=true;
			else obj7.checked=false;
		}
		var PreVisitStat=SelRowObj8.innerText;
		PreVisitStat=PreVisitStat.replace(" ","");
		if (obj8) obj8.value=PreVisitStat;
		var PreVisitStatDr=SelRowObj9.innerText;
		PreVisitStatDr=PreVisitStatDr.replace(" ","");
		if (obj9) obj9.value=PreVisitStatDr;
		PVSRowId=SelRowObj10.innerText;
		preRowInd=selectrow;
   }
   return;
}

function Save()
{
	var Code="",Desc="",EpisodeType="",EpisodeStatus="",DateFrom="",DateTo="",DoctorAccess="N",NurseAccess="N",PreVisitStatDr="";
	var obj=document.getElementById('PVSCode')
	if(obj) Code=obj.value;
	if(Code==""){
		alert(t['01']) 
		return;
	}
	obj=document.getElementById('PVSDesc')
	if(obj) Desc=obj.value;
	if(Desc==""){
		alert(t['02']) 
		return;
	}
	obj=document.getElementById('PVSEpisodeType')
	if(obj) EpisodeType=obj.value;
	if(EpisodeType==""){
		alert(t['04']) 
		return;
	}
	obj=document.getElementById('EpisodeStatus')
	if(obj) EpisodeStatus=obj.value;
	obj=document.getElementById('DateFrom')
	if(obj) {
		if(!IsValidDate(obj)){
			alert("请输入正确的开始日期");
			return;
		}
		DateFrom=obj.value;
	}
	if(DateFrom==""){
		alert(t['03']) 
		return;
	} 
	obj=document.getElementById('DateTo')
	if(obj) {
		if(!IsValidDate(obj)){
			alert("请输入正确的结束日期");
			return;
		}
		DateTo=obj.value;
	}
	obj=document.getElementById('DoctorAccess')
	if((obj)&&(obj.checked==true)) DoctorAccess="Y";
	obj=document.getElementById('NurseAccess')
	if((obj)&&(obj.checked==true)) NurseAccess="Y";
	obj=document.getElementById('PreVisitStatDr')
	if(obj) PreVisitStatDr=obj.value;
	obj=document.getElementById('PreVisitStat')
	if((obj)&&(obj.value=="")) PreVisitStatDr="";
	
	var parr=PVSRowId+"^"+Code+"^"+Desc+"^"+EpisodeType+"^"+EpisodeStatus+"^"+DateFrom+"^"+DateTo+"^"+DoctorAccess+"^"+NurseAccess+"^"+PreVisitStatDr;
	//alert(parr);
	var obj=document.getElementById('Save')
	if(obj) {
		var ret=cspRunServerMethod(obj.value,parr);
    	if (ret=='0')
		{
			alert(t['success']);
			//return;
			//btnSearch_click();
			self.location.reload();
		}
		else
		{
			if (ret=='1')
			{
				alert(t['repeat']);
				return;
			}
			else
			{
				alert(t['error']);
				return;	
			}
		}
	}
}	
function BADD_click()
{
	PVSRowId="";
	Save();	
}
function BUpdate_click()
{
	if(PVSRowId==""){
		alert("请选中要修改的记录!");
		return;
	}
	Save();	
}
function BDelete_click() {

	if (preRowInd < 1)
		return;
	if (PVSRowId == "")
		return;
	var msg = "您真的确定要删除吗？\n\n请确认！";
	if (confirm(msg) == false) {
		return;
	} else {
		var obj = document.getElementById('Delete')
			if (obj) {
				var ret = cspRunServerMethod(obj.value, PVSRowId);
				if (ret == '0') {
					alert(t['success']);
					//return;
					//btnSearch_click();
					self.location.reload();
				} else {
					alert(t['error']);
					return;
				}
			}
	}
}
function GetPreVisitStat(str)
{
	var tmpstr=str.split("^");
	var obj=document.getElementById("PreVisitStat")
	if (obj) obj.value=tmpstr[1];
	obj=document.getElementById("PreVisitStatDr")
	if (obj) obj.value=tmpstr[10];
}
document.body.onload=BodyLoadHandler;