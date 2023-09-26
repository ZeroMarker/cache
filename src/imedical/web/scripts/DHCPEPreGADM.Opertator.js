/// DHCPEPreGADM.Opertator.js

var selected="";

function BodyLoadHandler() {

	iniForm();
	
}

function iniForm() {
	var obj;
	var iID="", iName="", GBookDate="", GBookTime="";
	var iOperType="";
	
	obj=document.getElementById("ID");
	if (obj) { iID=obj.value; }
	
	obj=document.getElementById("Name");
	if (obj) { iName=obj.value; }
	
	obj=document.getElementById("GBookDate");
	if (obj) { GBookDate=obj.value; }

	obj=document.getElementById("GBookTime");
	if (obj) { GBookTime=obj.value; }
	
	var obj=document.getElementById("charttabs");
	var arrDiv = obj.getElementsByTagName("DIV");
	
	obj=document.getElementById("OperType");
	if (obj && ""!=obj.value) { iOperType=obj.value; }

	// 查询
	if ('Q'==iOperType) {
		//if (arrDiv.length) { SelectChart(arrDiv[0]); }
		SetChartItemDisabled('Q');
	}
	
	// 编辑
	if ('E'==iOperType) {
		//if (""!=iID) { SetGADM(iID+"^"+iName+"^"+GBookDate+"^"+GBookTime); }
		//if (arrDiv.length) { SelectChart(arrDiv[0]); }
		SetChartItemDisabled('E');
	}
	
	// 中间加项
	if ('T'==iOperType) {
		//if (arrDiv.length) { SelectChart(arrDiv[2]); }
		SetChartItemDisabled('T');
	}
	
	// 新建
	if ('N'==iOperType) {
		//if (arrDiv.length) { SelectChart(arrDiv[0]); }
		SetChartItemDisabled('N');
	}

}

// ///////////////////////////////////////////////////////////////////////////////

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function ClearSelected() {
	if (selected!="") {
		var obj=document.getElementById(selected);
		if (obj) { obj.className="chartitem"; }
	}
	selected="";
}

function SelectChart(eSrc) {
	
	if (eSrc.disabled) { return false; }
	
	// 清楚选择的图表(显示效果)
	ClearSelected();
	
	selected=eSrc.id;
	eSrc.className="chartitemSel";

	var lnk=""
	var obj;
	
	var iRowId="",iName="";
	var iOperType="";
	obj=document.getElementById("ID");
	if (obj) { iRowId=obj.value; }
	obj=document.getElementById("Name");
	if (obj) { iName=obj.value; }
	
	obj=document.getElementById("OperType");
	if (obj && ""!=obj.value) { iOperType=obj.value; }
	
	//团体查询 OperType="Q"
	if ("DHCPEPreGADM.Find" == eSrc.id) {
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGADM.Find"
			;
		OpenIFRAMEWindow("dataframe",lnk);
		return true;
	}
	
	//团体预约 OperType="N"
	if ("DHCPEPreGADM.Edit" == eSrc.id) {	
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGADM.Edit"
			"&OperType="+iOperType;
		if (""!=iRowId) { lnk=lnk+"&ID="+iRowId}
		OpenIFRAMEWindow("dataframe",lnk);
		return true;
	}
	
	var iGBookDate="",iGBookTime=""
	obj=document.getElementById("GBookDate");
	if (obj) { iGBookDate=obj.value; }
	
	obj=document.getElementById("GBookTime");
	if (obj) { iGBookTime=obj.value; }

	//团体预约
	if ("DHCPEPreGTeam.List" == eSrc.id) {
		
		//lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGTeam.List"
		lnk="dhcpepregadm.team.csp"
			+"?ParRef="+iRowId
			+"&ParRefName="+iName
			
			+"&GBookDate="+iGBookDate
			+"&GBookTime="+iGBookTime
			
			+"&OperType="+iOperType //操作类型 新建
			
			;
		OpenIFRAMEWindow("dataframe",lnk); //chartbook.operator.js
		return true;
	}

	//团体预约
	if ("DHCPEPreGTeamTest.Team" == eSrc.id) {
		
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreGTeam.List"
			+"&ParRef="+iRowId
			+"&ParRefName="+iName
			
			+"&GBookDate="+iGBookDate
			+"&GBookTime="+iGBookTime
			
			+"&OperType="+iOperType //操作类型 新建
			
			;
		OpenIFRAMEWindow("dataframe",lnk); //chartbook.operator.js
		return true;
	}


	//人员预约
	if ("DHCPEPreIADM.Team" == eSrc.id) {
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIADM.Team"
			+"&ParRef="+iRowId
			+"&ParRefName="+iName
			
			+"&OperType="+iOperType //操作类型 新建
			
			;
		
		OpenIFRAMEWindow("dataframe",lnk); //chartbook.operator.js
		return true;
	}
	
     //批量加项
    	if ("DHCPEGroupAllPersonFind" == eSrc.id) {
		lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGroupAllPersonFind"
			;
		if (""!=iRowId) { lnk=lnk+"&ID="+iRowId}
		OpenIFRAMEWindow("dataframe",lnk);
		return true;
	}	
	

}

// 
function  SetGADM(Data) {
	
	var obj;
	var Datas=Data.split("^");
	var ID=Datas[0];
	
	if (""==ID) { return false;}
	obj=document.getElementById("ID");
	if (obj) { obj.value=ID; }
	
	var Name=Datas[1];
	obj=document.getElementById("Name");
	if (obj) { obj.value=Name; }
	
	var GBookDate=Datas[2];
	obj=document.getElementById("GBookDate");
	if (obj) { obj.value=GBookDate; }
	
	var GBookTime=Datas[3];
	obj=document.getElementById("GBookTime");
	if (obj) { obj.value=GBookTime; }
	
	var iOperType=Datas[4];
	//alert("SetGADM OperType:"+iOperType)
	obj=document.getElementById("OperType");
	if (obj) { obj.value=iOperType; }
	
	SetChartItemDisabled(iOperType);

}

// 设置图表是否可用

function SetChartItemDisabled(OperType) {
	// 新建预约
	if ('N'==OperType) {
		//图表 团体预约
		obj=document.getElementById("DHCPEPreGADM.Edit");
		if (obj){ obj.disabled=false; }

		//图表 团体分组
		obj=document.getElementById("DHCPEPreGTeam.List");
		if (obj){ obj.disabled=true; }

		//图表 人员分组
		obj=document.getElementById("DHCPEPreIADM.Team");
		if (obj){ obj.disabled=true; }
		
				//图表 批量加减项
		obj=document.getElementById("DHCPEGroupAllPersonFind");
		if (obj){ obj.disabled=false; }
			
		return true;
	}
	
	// 编辑预约
	if ('E'==OperType) {
		//图表 团体预约
		obj=document.getElementById("DHCPEPreGADM.Edit");
		if (obj){ obj.disabled=false; }

		//图表 团体分组
		obj=document.getElementById("DHCPEPreGTeam.List");
		if (obj){ obj.disabled=false; }
		
		//图表 人员分组
		obj=document.getElementById("DHCPEPreIADM.Team");
		if (obj){ obj.disabled=false; }
		
	   //图表 批量加减项
		obj=document.getElementById("DHCPEGroupAllPersonFind");
		if (obj){ obj.disabled=false; }
		
		return true;
	}
	
	// 中间加项
	if ('T'==OperType) {
		//图表 团体预约
		obj=document.getElementById("DHCPEPreGADM.Edit");
		if (obj){ obj.disabled=true; }

		//图表 团体分组
		obj=document.getElementById("DHCPEPreGTeam.List");
		if (obj){ obj.disabled=true; }

		//图表 人员分组
		obj=document.getElementById("DHCPEPreIADM.Team");
		if (obj){ obj.disabled=false; }	
		
				//图表 批量加减项
		obj=document.getElementById("DHCPEGroupAllPersonFind");
		if (obj){ obj.disabled=false; }	
		return true;
	}

	// 新建预约
	if ('Q'==OperType) {
		//图表 团体预约查询
		obj=document.getElementById("DHCPEPreGADM.Find");
		if (obj){ obj.disabled=false; }

		//图表 团体分组
		obj=document.getElementById("DHCPEPreGTeam.List");
		if (obj){ obj.disabled=false; }
		
		//图表 人员分组
		obj=document.getElementById("DHCPEPreIADM.Team");
		if (obj){ obj.disabled=false; }
	
		//图表 团体分组
		obj=document.getElementById("DHCPEPreGTeamTest.Team");
		if (obj){ obj.disabled=false; }
		
			//图表 团体分组
		obj=document.getElementById("DHCPEPreGTeamTest.Team");
		if (obj){ obj.disabled=false; }
		
			//图表 批量加减项
		obj=document.getElementById("DHCPEGroupAllPersonFind");
		if (obj){ obj.disabled=false; }
		
		return true;
	}
	
}

document.body.onload = BodyLoadHandler;
