var ctlocId="",inActiveValue="",ifDoctorValue="",typeValue="",clcpRowId="",inActiveCode="",ifDoctorCode="",typeCode="";
var preRowInd=0;
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj=document.getElementById("Insert");
	if(obj) {obj.onclick=InsertClick;}
	var obj=document.getElementById("Update");
	if(obj) {obj.onclick=UpdateClick;}
	
    var btnDelete = document.getElementById("delete");
    if(btnDelete)
    {
        btnDelete.onclick = deleteCareProv;
    }
	var btnFind = document.getElementById("Find");
    if(btnFind)
    {
        btnFind.onclick = FindCareProv;
    }
	var hospital = document.getElementById("hospital");
	if(hospital)
	{
	   hospital.onblur = function(){
            if(!hospital.value)
            {
                hospital.idVal = "";
            }
       }
    }
}
function FindCareProv()
{
	var ctloc=document.getElementById("ctloc").value;
	var desc=document.getElementById("desc").value;
	var alias=document.getElementById("alias").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLCareProv&descV="+desc+"&aliasV="+alias+"&ctlocId="+ctlocId;
	location.href=lnk; 

}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCCLCareProv');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    objtbl.selectrow = selectrow;

	var ctloc=document.getElementById("ctloc");
	var desc=document.getElementById("desc");
	var alias=document.getElementById("alias");
	var type=document.getElementById("type");
	var inActive=document.getElementById("inActive");
	var ifDoctor=document.getElementById("ifDoctor");
	var fromDate=document.getElementById("fromDate");
	var toDate=document.getElementById("toDate");
	//ctlocId=document.getElementById("ctlocId").value;

	var tctloc=document.getElementById("tctlocdescz"+selectrow).innerText.trimEnd();
	var tdesc=document.getElementById("tdescz"+selectrow).innerText.trimEnd();
	var talias=document.getElementById("taliasz"+selectrow).innerText.trimEnd();
	var ttype=document.getElementById("tTypeDesz"+selectrow).innerText.trimEnd();
	var tinActive=document.getElementById("tInActiveDesz"+selectrow).innerText.trimEnd();
	var tifDoctor=document.getElementById("tIfDocDesz"+selectrow).innerText.trimEnd();
	var tfromDate=document.getElementById("tfdatez"+selectrow).innerText.trimEnd();
	var ttoDate=document.getElementById("ttdatez"+selectrow).innerText.trimEnd();
	var tctlocdr=document.getElementById("tctlocdrz"+selectrow).innerText.trimEnd();
	clcpRowId=document.getElementById("tclcpRowIdz"+selectrow).innerText;
	ctloc.value=tctloc;
	desc.value=tdesc;
	alias.value=talias;
	type.value=ttype;
	inActive.value=tinActive;
	ifDoctor.value=tifDoctor;
	fromDate.value=tfromDate;
	toDate.value=ttoDate;
	document.getElementById("ctlocId").value=tctlocdr;
    var hospital = document.getElementById("hospital");
    var tHospital = document.getElementById("tHospitalz"+selectrow);
    var hospitalDr = document.getElementById("tHospitalDrz"+selectrow);
	if(hospital && tHospital && hospitalDr)
    {
        hospital.value = tHospital.innerText.trimEnd();
        hospital.idVal = hospitalDr.value.trimEnd();
    }
    var tTypeCode=document.getElementById("ttypez"+selectrow)
    if(tTypeCode)
    {typeCode=tTypeCode.value.trimEnd()}
    var tInActiveCode=document.getElementById("tinActivez"+selectrow)
    if(tInActiveCode)
    {inActiveCode=tInActiveCode.value.trimEnd()}
    var tIfDoctorCode=document.getElementById("tifDocz"+selectrow)
    if(tIfDoctorCode)
    {ifDoctorCode=tIfDoctorCode.value.trimEnd()}
    if (preRowInd==selectrow){
	   ctloc.value="";
	desc.value="";
	alias.value="";
	type.value="";
	inActive.value="";
	ifDoctor.value="";
	fromDate.value="";
	toDate.value="";
	hospital.value="";
   		preRowInd=0;
    }
    else
    {
	    preRowInd=selectrow;
    }
   	
}
function InsertClick()
{
	ctlocId=document.getElementById("ctlocId").value;
	if(ctlocId=="") ctlocId=session['LOGON.CTLOCID'];
	var desc=document.getElementById("desc").value;
	var alias=document.getElementById("alias").value;
	var inActive=document.getElementById("inActive").value;
	if(inActive=="")inActiveCode=""
	var ifDoctor=document.getElementById("ifDoctor").value;
	if(ifDoctor=="")ifDoctorCode=""
	var type=document.getElementById("type").value;
	if(type=="")typeCode=""
	var fromDate=document.getElementById("fromDate").value;
	var toDate=document.getElementById("toDate").value;
	var InsertObj=document.getElementById("InsertCareProv");
	var hospitalId = "";
	var hospital = document.getElementById("hospital");
	if(hospital)
	    hospitalId = hospital.idVal ? hospital.idVal : "";
	if(InsertObj)
	{
		var InsertCareProv=InsertObj.value;
		var ret=cspRunServerMethod(InsertCareProv,ctlocId,desc,alias,fromDate,toDate,inActiveCode,ifDoctorCode,typeCode,hospitalId)
		if(ret!="0")
		{
			alert(ret);
			return;
		}
	}
	self.location.reload();

}
function UpdateClick()
{
	if (clcpRowId=="") {alert("请选择一行要修改的数据！");retrun;}
	ctlocId=document.getElementById("ctlocId").value;
	if(ctlocId=="") ctlocId=session['LOGON.CTLOCID'];
	var desc=document.getElementById("desc").value;
	var alias=document.getElementById("alias").value;
	var inActive=document.getElementById("inActive").value;
	if(inActive=="")inActiveCode=""
	var ifDoctor=document.getElementById("ifDoctor").value;
	if(ifDoctor=="")ifDoctorCode=""
	var type=document.getElementById("type").value;
	if(type=="")typeCode=""
	var fromDate=document.getElementById("fromDate").value;
	var toDate=document.getElementById("toDate").value;
	var UpdateObj=document.getElementById("UpdateCareProv");
	var hospitalId = "";
	var hospital = document.getElementById("hospital");
	if(hospital)
	    hospitalId = hospital.idVal ? hospital.idVal : "";
	if(UpdateObj)
	{
		var UpdateCareProv=UpdateObj.value;
		var ret=cspRunServerMethod(UpdateCareProv,clcpRowId,ctlocId,desc,alias,fromDate,toDate,inActiveCode,ifDoctorCode,typeCode,hospitalId)
		if(ret!="0")
		{
			alert(ret);
			return;
		}
	}
  self.location.reload();

}

function deleteCareProv()
{
    var objtbl=document.getElementById('tDHCCLCareProv');
    
    if(!objtbl.selectrow)
    {
        alert(t["selectRow"]);
        return;
    }
    
    var deleteCareProv = document.getElementById("deleteCareProv");
    if(deleteCareProv)
    {
        var tclcpRowId = document.getElementById("tclcpRowIdz"+objtbl.selectrow).innerText;
            
        var result = cspRunServerMethod(deleteCareProv.value,tclcpRowId);
            
        if(result != "0")
        {
            alert(result);
            return;
        }
            
        self.location.reload()
    }
    
}
 
function getloc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("ctlocId")
	if (obj) obj.value=loc[0];
	obj=document.getElementById("ctloc");
	if (obj) obj.value=loc[1];
}

function getInActive(str)
{
	var inActive=str.split("^");
	var obj=document.getElementById("inActive")
	if (obj) 
	{
		inActiveCode=inActive[0];
		obj.value=inActive[1];
	}
}


function getIfDoctor(str)
{
	var ifDoctor=str.split("^");
	var obj=document.getElementById("ifDoctor")
	if (obj) 
	{
		ifDoctorCode=ifDoctor[0];
		obj.value=ifDoctor[1];
	}
}

function getType(str)
{
	var type=str.split("^");
	var obj=document.getElementById("type")
	if (obj) 
	{
		typeCode=type[0];
		obj.value=type[1];
	}
}

function getHospital(str)
{
    var hospitalStr=str.split("^");
	var obj=document.getElementById("hospital")
	if (obj) 
	{
		obj.idVal=hospitalStr[0];
		obj.value=hospitalStr[1];
	}
}

String.prototype.trimEnd = function(){
    var re = /\s+$/g;
    return function(){ return this.replace(re, ""); };
}();

