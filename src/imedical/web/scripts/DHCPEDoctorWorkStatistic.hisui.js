//名称	DHCPEDoctorWorkStatistic.hisui.js
//功能	医生工作量统计
//创建	2019.10.30
//创建人  ln

$(function(){
			
	InitCombobox();
	
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
})


//清屏
function BClear_click(){
	$("#DocNo").val("");
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	//$(".hisui-combogrid").combogrid('setValue',"");
	$("#DocName").combogrid('setValue',"");
	$("#GroupName").combogrid('setValue',"");
	$("#StationName").combogrid('setValue',"");
	$("#OEItemDesc").combogrid('setValue',"");
	
	$("#ShowFlag").combobox('setValue',"Item");
	InitCombobox();
	BFind_click();
}


//查询
function BFind_click(){
	var BeginDate="",EndDate="",DocNo="",DocDR="",GroupDR="",StationDR="",OEItem="",reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');

	var DocNo=$("#DocNo").val();
	var DocDR=$("#DocName").combogrid("getValue");
	if (DocDR == undefined || DocDR == "undefined") { var DocDR = ""; }
	
	var GroupDR=$("#GroupName").combogrid("getValue");
	if (GroupDR == undefined || GroupDR == "undefined") { var GroupDR = ""; }
	
	var StationDR=$("#StationName").combogrid("getValue");
	if (StationDR == undefined || StationDR == "undefined") { var StationDR = ""; }
	
	var OEItem=$("#OEItemDesc").combogrid("getValue");
	if (OEItem == undefined || OEItem == "undefined") { var OEItem = ""; }
	
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (VIPLevel==undefined) {var VIPLevel="";}
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "Item") reportName = "DHCPEDoctorWorkStatistic.raq";
	else if (ShowFlag == "Person") reportName = "DHCPEDocPerWorkStatistic.raq";
	else { alert("请选择查询类型！"); return false;}
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&DocNo=" + DocNo
			+ "&DocDR=" + DocDR
			+ "&GroupDR=" + GroupDR
			+ "&StationDR=" + StationDR
			+ "&OEItem=" + OEItem
			+ "&VIPLevel=" + VIPLevel
			+ "&ShowFlag=" + ShowFlag
			;
	
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
	
}

function InitCombobox(){
	
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			param.ShowPersonGroup="1";
		},
		columns:[[
			{field:'TRowId',title:'团体ID',width:80},
			{field:'TGDesc',title:'团体名称',width:140},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'日期',width:100}		
		]]
	})
	
	//站点名称
	var StationNameObj = $HUI.combogrid("#StationName",{
		panelWidth:440,
		panelHeight:245,
		url:$URL+"?ClassName=web.DHCPE.Station&QueryName=FromDescToStation",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'ST_RowId',
		textField:'ST_Desc',
        onBeforeLoad:function(param){
			param.StationDesc = param.q;
		},
         onChange:function(newValue, oldValue)
		{
			var ItemID = $("#OEItemDesc").combogrid("getValue");
			var Flag=tkMakeServerCall("web.DHCPE.HISUICommon","GetStationFlag",newValue,ItemID);
			if (Flag==0) {
			    $("#OEItemDesc").combogrid('setValue',"");
			}
			
		},			
		columns:[[
			{field:'ST_Desc',title:'站点名称',width:80},
			{field:'ST_RowId',title:'站点ID',width:140},
			{field:'ST_Code',title:'站点编码',width:100}		
		]]
	})
	
	//体检项目
	var OEItemDescObj = $HUI.combogrid("#OEItemDesc",{
		panelWidth:450,
		panelHeight:245,
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'id',
		textField:'desc',	
        onBeforeLoad:function(param){
			param.Desc = param.q;
			var StationId=$("#StationName").combogrid("getValue");
			param.Station = StationId;
		},
        onShowPanel:function()
		{
			$('#OEItemDesc').combogrid('grid').datagrid('reload');
		},		
		columns:[[
			{field:'Code',title:'编码',width:80},
			{field:'desc',title:'名称',width:180},
			{field:'id',title:'ID',width:80}         		
		]]
	})
	
	//医生姓名
	var DocNameObj = $HUI.combogrid("#DocName",{
		panelWidth:400,
		panelHeight:240,
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindDocUser",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'UserID',
		textField:'UserName',	
        onBeforeLoad:function(param){
			param.Desc = param.q;
		},		
		columns:[[
			{field:'UserCode',title:'用户ID',width:80},
			{field:'UserName',title:'姓名',width:160},
			{field:'UserID',title:'ID',width:80}		
		]]
	});
	
	// 查询类型
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Item',text:'按医嘱查询',selected:true},
			{id:'Person',text:'按人查询'}
		]
	});
}