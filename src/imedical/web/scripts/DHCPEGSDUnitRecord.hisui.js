//名称	DHCPEGSDUnitRecord.hisui.js
//功能	撤销合并
//创建	2020.05.09
//创建人  xy
$(function(){
	//分辨率
     if((screen.width=="1440")&&(screen.height=="900"))
     {
	     Height="340";
     }
	InitGSDUnitRecordGrid();  
         
})

//撤销
function CancelUnitRecord(UnitRecordID)
{
	
	var ret=tkMakeServerCall("web.DHCPE.GSDUnitRecord","CancelUnit",UnitRecordID)
	var Arr=ret.split("^");
	
	if (Arr[0]==0) {  
	  if (parent){
		parent.$('#UnitRecordWin').window('close');   
		parent.location.reload();
		}
	}
	
}
var Height="400"
function InitGSDUnitRecordGrid(){
	$HUI.datagrid("#GSDUnitRecordGrid",{
		url: $URL,
		height: Height,
		striped: true, //是否显示斑马线效果
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		nowrap:false,
		loadMsg: 'Loading...',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageSize: 10,
		pageList: [10, 20, 40, 40],
		queryParams:{
			ClassName:"web.DHCPE.GSDUnitRecord",
			QueryName:"FindUnitRecord",
            GSID:GSID,
		},
		columns:[[
			{field:'TURID',title:'URID',hidden: true},
			{field:'THoldJL',width:130,title:'结论'},
			{field:'TUnitDate',width:100,title:'日期'},
			{field:'TUnitTime',width:100,title:'时间'},
			{field:'CancelUnit',title:'撤销',width:'80',align:'center',
				formatter:function(value,rowData,rowIndex){
					if(rowData.TURID!=""){
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"  title="撤销" border="0" onclick="CancelUnitRecord('+rowData.TURID+')"></a>';
					
					}
				}},
				
			
		]],
			
	});
}


