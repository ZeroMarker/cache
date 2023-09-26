var vPAADM;
var vRoomRecordID="";
var vOrdInfo;
var vCurID;
var vMainDoctor="";
var TreeHeight=0;
var BottomHeight=0;
Ext.onReady(function(){
    Ext.QuickTips.init();
    
	//如果需要检索科室,就是用下面的内容,把Panel渲染到tree上
	var Find=new Ext.Button({
		handler : Find_click,
		text : '检索医嘱信息',
		region : 'north',
		id : 'TreeFind'
	});
	
	var root = new Ext.tree.AsyncTreeNode({  
		id : "0^0",
		text : "医嘱列表"
	});
	var loader = new Ext.tree.TreeLoader({ 
		url : 'dhcpedocpatient.tree.csp'
	});
	loader.on("beforeload", function(loader, node) {
		loader.baseParams.nodeId = node.id;
		loader.baseParams.Paadm=vPAADM;
		loader.baseParams.MainDoctor=vMainDoctor;
	});
	var tree = new Ext.tree.TreePanel({
		//renderTo : "tree",
		region : 'center',
		root : root,
		autoScroll: true,
		loader : loader,
		frame : false,
		//width : 140,
		//autoWidth:true,
		autoHeight : true,
		//height : TreeHeight-5,
		rootVisible : false,
		id : 'Tree'
	});
	tree.getRootNode().expand();
	tree.on("click",tree_click);
	
	var Panel=new Ext.Panel({
		renderTo : "tree",
		items : [tree],
		//width : 155,
		//height : TreeHeight,
		//autoWidth:true,
		autoHeight : true,
		frame : true
	});
})
function combo_select()
{
	var tree=Ext.getCmp('Tree')
	tree.root.reload();
}
function Find_click()
{
	var tree=Ext.getCmp('Tree')
	tree.root.reload();
}
function tree_click(node)
{
	var Str=node.id;
	ShowPage(Str);
}
function ShowPage(Str)
{

	if (Str==""){  //没有医嘱信息
		var lnk= "websys.default.csp";
		frames["result"].location.href=lnk;
		var lnk= "websys.default.csp";
    	frames["diagnosis"].location.href=lnk;
    	return false;
	}
	
	vCurID=Str
	var StrArr=Str.split("^");
	var ID=StrArr[0];
	var Type=StrArr[1];
	var ChartID=StrArr[2];
	if (Type=="1"){ //站点
		var ChartID=StrArr[0];
	//DHCPE.Station.ResultEdit
		var OEORDItemID=ID;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewResult&EpisodeID=" +vPAADM+"&ChartID="+ID+"&StationID="+ID;
    	frames["result"].location.href=lnk;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEStationSDiagnosis&EpisodeID=" +vPAADM+"&ChartID="+ID;
    	//frames("diagnosis").location.href=lnk;
	}
	if (Type=="9"){ //站点
		var ChartID=StrArr[0];
	//DHCPERis.Station.ResultEdit
		var OEORDItemID=ID;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewResult&EpisodeID=" +vPAADM+"&ChartID="+ID+"&StationID="+ID;
    	frames["result"].location.href=lnk;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEStationSDiagnosis&EpisodeID=" +vPAADM+"&ChartID="+ID;
    	//frames("diagnosis").location.href=lnk;
	}
	if (Type=="2"){  //普通检查
		var OEORDItemID=ID;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEResultItemEdit&EpisodeID=" +vPAADM+"&OEORIRowId="+OEORDItemID+"&ChartID="+ChartID ;
    	frames["result"].location.href=lnk;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEStationSDiagnosis&EpisodeID=" +vPAADM+"&ChartID="+ChartID;
    	//frames("diagnosis").location.href=lnk;
	}
	if (Type=="3"){ //Ris等检查
		var OEORDItemID=ID;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPERisResultItemEdit&EpisodeID=" +vPAADM+"&OEORIRowId="+OEORDItemID+"&ChartID="+ChartID ;
    	frames["result"].location.href=lnk;
		lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEStationSDiagnosis&EpisodeID=" +vPAADM+"&ChartID="+ChartID;
    	//var lnk= "websys.default.csp"
    	//frames("diagnosis").location.href=lnk;
	}
	if (Type=="4"){ //总检
		var OEORDItemID=ID;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosis&EpisodeID=" +vPAADM+"&ChartID="+ChartID+"&MainDoctor="+vMainDoctor;
    	//var lnk= "dhcpegeneral.csp?EpisodeID=" +vPAADM+"&ChartID="+ChartID+"&MainDoctor="+vMainDoctor;
		//frames("result").style.width="100%"
    	frames["result"].location.href=lnk;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEGeneralDiagnosis&EpisodeID=" +vPAADM+"&ChartID="+ChartID+"&MainDoctor="+vMainDoctor;
    	//frames("diagnosis").style.width="0"
    	//frames("diagnosis").location.href=lnk;
	}
	if (Type=="5"){ //检验
		var OEORDItemID=ID;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEResultItemEdit&EpisodeID=" +vPAADM+"&OEORIRowId="+OEORDItemID+"&ChartID="+ChartID;
    	frames["result"].location.href=lnk;
		//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEStationSDiagnosis&EpisodeID=" +vPAADM+"&ChartID="+ChartID;
    	var lnk= "websys.default.csp"
    	//frames("diagnosis").location.href=lnk;
	}
	
}
function ShowNextPage()
{
	var i=vOrdInfo.length;
	var ID=""
	for (j=0;j<i;j++)
	{
		var jID=vOrdInfo[j];
		if ((jID==vCurID)&&(j<i-1))
		{
			ID=vOrdInfo[j+1];
			break;
		}
	}
	if (ID!=""){
		ShowPage(ID);}
	else{
		var QueryObj=frames("query");
		var obj=QueryObj.document.getElementById("BComplete");
	
		if (obj) QueryObj.BComplete();
		/*
		var NextRoomDesc=tkMakeServerCall("web.DHCPE.RoomManager","GetAdmCurRoom",vPAADM);
		if (NextRoomDesc!=""){
			alert("请到'"+NextRoomDesc+"'等候")
		}*/
		var obj=frames("query").document.getElementById("RegNo");
		if (obj){
			obj.focus();
			obj.select();
		}
		//websys_setfocus("RegNo");
	}
	return false;
}