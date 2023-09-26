/// DHCPE.Station.ResultEdit.js
var obj;
function InitMe() {
	var SummaryForm=document.forms['fDHCPE_Station_ResultEdit'];
	if (SummaryForm){
		var obj=SummaryForm.document.getElementById("ComponentID");
		if (obj){var ComponentID=obj.value;}
		
		var obj=SummaryForm.document.getElementById("IsLabStation");
		var IsLabStation=0;
		if (obj) IsLabStation=obj.value;

		var j=0,k=1;
		var i=SummaryForm.all.length
		for (j=0;j<i;j++)
		{
			var Name=SummaryForm.all[j].id;
			//alert(Name)
			var ItemName="r"+ComponentID+"iSelectz"+k;
			var ItemLength=ItemName.length;
			if (Name.substr(Name.length-ItemLength,ItemLength)==ItemName)
			{
				//if (IsLabStation==0)
				//{
					k=k+1
					websys_component(SummaryForm.all[j],SummaryForm.all[j].id);
					var obj=SummaryForm.document.getElementById("ItemSelz1");
					if (obj) websys_setfocus("ItemSelz1");
				//}

			}
		}
	}
	var SummaryForm=document.getElementById("tDHCPE_Station_ResultEdit");
	var i=SummaryForm.rows.length;
	for (var j=0;j<=i;j++)
	{
		var obj=document.getElementById("PhyExamOrderz"+j);
		if (obj)
		{
			obj.onclick=PhyExamOrder_Click;
			obj.name=obj.name+"^"+j
		}
	}
	var permision=PermissonSetting();
	if (permision=="W"){
	}
}

function PhyExamOrder_Click()
{
	var obj=window.event.srcElement;
	var LastRow=obj.name.split("^")[1];
	
	var obj=document.getElementById("ComponentID");
	if (obj){var ComponentID=obj.value;}
	var ItemName="r"+ComponentID+"iSelectz"
	var ItemName=ItemName+LastRow
	
	var ItemLength=ItemName.length
	var SummaryForm=document.forms['fDHCPE_Station_ResultEdit'];
	var j=0
	var i=SummaryForm.all.length
	for (j=0;j<i;j++)
	{
		var Name=SummaryForm.all[j].id;
		if (Name.substr(Name.length-ItemLength,ItemLength)==ItemName)
		{
			websys_component(SummaryForm.all[j],SummaryForm.all[j].id);
			var obj=SummaryForm.document.getElementById("ItemSelz"+LastRow);
			if (obj) websys_setfocus("ItemSelz"+LastRow);
		}
	}
	return false;
}
//return: "R"-Read, "W"-write.
function PermissonSetting(){
	var UserId, PAAdmId, ChartId, SvrMethod
	UserId=session['LOGON.USERID'];
	PAAdmId=GetCtlValueById("EpisodeID", 0)
	ChartId=GetCtlValueById("ChartID", 1)
	SvrMethod=GetCtlValueById("methodResultPermission", 1)
	var MyPermission=cspRunServerMethod(SvrMethod,UserId, PAAdmId, 0, ChartId)
	if (MyPermission=="R"){
		DisabledCtls("A",true);
		DisabledCtls("input",true);
	    DisabledCtls("select",true);
		return "R";
	}
	return "W";
	
}
