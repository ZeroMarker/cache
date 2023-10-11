

var url="dhcpha.clinical.action.csp";
if ("undefined"!==typeof(websys_getMWToken)){
	url += "?MWToken="+websys_getMWToken()
	}
var	PatientID="";
var	EpisodeID="";
var flag="";
$(function(){
	
	PatientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	InitPatMedGrid();					/// 初始化列表
	LoadPatMedInfo("");					/// 加载数据
});

function InitPatMedGrid()
{
	//定义columns
	var columns=[[
		
		{field:"ck",checkbox:true,width:20,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:"moeori",title:'moeori',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:$g('优先级'),width:80,align:'center'},
		{field:'StartDate',title:$g('开始日期'),width:80,align:'center'},
		{field:'startTime',title:$g('开始时间'),width:80,align:'center'},
		{field:'incidesc',title:$g('医嘱'),width:280},		
		{field:'instru',title:$g('用法'),width:80,align:'center'},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'dosage',title:$g('剂量'),width:40,align:'center'},
		//{field:'unitDR',title:'单位',width:40,align:'center'},
		{field:'freq',title:$g('频次'),width:60,align:'center'},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'EndDate',title:$g('停止日期'),width:80,align:'center'},
		{field:'endTime',title:$g('停止时间'),width:80,align:'center'},
		{field:'doctor',title:$g('医生'),width:80,align:'center'},		
		{field:'OeFlag',title:'OeFlag',width:80,hidden:true},
		{field:'oeDesc',title:$g('状态'),width:80,align:'center'},		
		{field:'execStat',title:$g('是否执行'),width:80,align:'center'},
		{field:'sendStat',title:$g('是否发药'),width:80,align:'center'},
		{field:'orderbak',title:$g('医嘱备注'),width:80,align:'center'},
		{field:'groupFlag',title:$g('成组符号'),width:80,align:'center'}			
	]];

 	$('#medInfo').datagrid({   
		title:$g('医嘱信息'),
		url:url+'&action=GetPatOEInfo',
		fit:true,
		fitColumns:true,		/// 列自适应
		rownumbers:true,
		columns:columns,
		nowrap: false,		
		pageSize:20, 			/// 每页显示的记录条数
		pageList:[20,40,60],   	/// 可以设置每页记录条数的列表
		pagination:true,
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		striped : true, 		/// 是否显示斑马线效果		
		queryParams:{
			EpisodeID:EpisodeID
		},	   
		onClickRow:function(rowIndex, rowData){
			
			///一组医嘱同时选择
			var items = $('#medInfo').datagrid('getRows');
			$.each(items, function(index, item){ 										/// qunianpeng 2017/2/8
				var mainGroupOrd=(rowData.moeori=="")&&(item.moeori==rowData.orditm); 	/// 选中行是主医嘱，同时选中成组医嘱
				var otherGroupOrd=(rowData.moeori!="")&&((item.moeori=="")&&(rowData.moeori==item.orditm)||(rowData.moeori==item.moeori)); //选中行不是主医嘱，但是成组医嘱中的一个，同时选中成组医嘱
				if(mainGroupOrd||otherGroupOrd){
					$("[datagrid-row-index='" + index + "']").css({ "background-color": "#ccffee" });
				}
				else{
					$("[datagrid-row-index='" + index + "']").css({ "background-color":"" });
				}
			});		
		},
		onDblClickRow:function(rowIndex, rowData){
				if(rowData.moeori==""){
					window.parent.medadvises(rowData.orditm)		
				}
				else{
				   window.parent.medadvises(rowData.moeori)	
				}
               
            }
					
	}); 
	
}

//查询长嘱/临医嘱
function LoadPatMedInfo(priCode)
{
	$('#medInfo').datagrid({
		url:url+'&action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID,
			PriCode:priCode
			}
	});
	initScroll("#medInfo");		//初始化显示横向滚动条
}