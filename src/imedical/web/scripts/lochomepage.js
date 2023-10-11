var componentArray = {"31":"EM.G.Queue.MaintRequest"};
jQuery(document).ready(function()
{
	defindTitleStyle();
	initEchartsObjMap();
	initMaintDetailDataGrid();
	var ChartsNameStr="EQNumAmount^EQOverNumAmount^DPPreMonthDepre^MAPreMonthMaint^BYPreMonthAdd^EQEquipTypeAmount^EQEquipTypeNumPercent^MPCurMonthWorkLoad^EQEndOriginalNet";
	initChartsDefine(ChartsNameStr,"1");
	initChartsDefine("EQOriginNumPercent","2,2");
	if ((typeof(HISUIStyleCode)!="undefined")&&(HISUIStyleCode=="lite"))
	{
		// eq_main_card
		$("#EQNumAmount").css({color:"#05A489",background:"#E6FFFB"});
		$("#EQOverNumAmount").css({color:"#AC5919",background:"#FFF3E1"});
		$("#DPPreMonthDepre").css({color:"#8C07BB",background:"#F4E5F9"});
		$("#MAPreMonthMaint").css({color:"#0052A7",background:"#E8F3FF"});
		$("#BYPreMonthAdd").css({color:"#000000",background:"#ECECEC"});
	}
});
function initEchartsObjMap()
{
	EchartsObjMap["EQEquipTypeAmount"]="LocEquipNumAmount"
	EchartsObjMap["EQEquipTypeNumPercent"]="EquipTypePercent"
	EchartsObjMap["EQOriginNumPercent"]="FaOriginAnaly"

	EchartsObjMap["EQEndOriginalNet"]="EndControl"
	EchartsObjMap["EQLastYearInStock"]="YearControl"
}
function initMaintDetailDataGrid()
{
	ObjTabsInfo=new editTabsInfo("","31");
	var Columns=ObjTabsInfo.columns
	var QueryParams=ObjTabsInfo.queryParams
	var Toolbar=ObjTabsInfo.toolbar
	$HUI.datagrid("#tMaintDetail",{
		url:$URL,
		queryParams:QueryParams,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true则显示一个行号列
	    columns:Columns,
	    toolbar:Toolbar,
		pagination:true,
		pageSize:7,
		pageNumber:1,
		pageList:[7,14,21,28,35],
		onLoadSuccess:function(){
			$("#tMaintDetail").datagrid("hideColumn", "TDetail");
		}
	});
}
function editTabsInfo(title,busscode)
{
	this.title=title;
	this.busscode=busscode;
	this.tableID="table"+busscode;
	/*var queryParams={
	    	ClassName:"web.DHCEQ.Plat.LIBMessages",
        	QueryName:"GetBussDataByCode",
			BussType:busscode,
			GroupID:'',
			UserID:'',
			CurLocDR:'',
			EquipDR:''
	    };*/
	var queryParams={
	    	ClassName:"web.DHCEQM.DHCEQMMaintRequest",
        	QueryName:"GetMaintRequestDetail",
			vData:'^vStatus=2^PreviousMonthFlag=1',
			InvalidFlag:'N'
	    };
	this.queryParams=queryParams; //根据不同的业务定义不同的query
	this.columns=getCurColumnsInfo(componentArray[busscode],"","",""); ///动态成一个columns信息
	this.toolbar=""
}