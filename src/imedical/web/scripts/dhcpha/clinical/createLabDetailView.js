
/// Creator:    bianshuai
/// CreateDate: 2015-05-05
/// Descript:   检验明细视图

function createLabDetailView(callBack)
{
	var LabIndex="";
	if($('#LabWin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="LabWin"></div>');
	$('#LabWin').append('<div id="Lab"></div>');

	///定义columns
	var columns=[[
		{field:"oneReportDR",title:$g('报告ID')},
		{field:"OrdRowIds",title:'OrdRowIds',hidden:true},
		{field:"LabTestSetRow",title:'LabTestSetRow',hidden:true},
		{field:'LabEpisode',title:$g('检验号')},
		{field:'OrdNames',title:$g('医嘱名称')},
		{field:'SpecName',title:$g('样本类型')},
		{field:'ReqDateTime',title:$g('申请日期')},
		{field:'AuthDateTime',title:$g('报告日期')}
	]];
	
	$('#Lab').datagrid({
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){
			$('#Lab').window('close');
		},
		view: detailview,
		detailFormatter: function(rowIndex, rowData){
			return '<div style="padding:2px;border:2px solid #95B8E7;"><div id="ddv-' + rowIndex + '" style="height:150px;border-bottom:1px solid #95B8E7;"></div></div>';
		},
		onExpandRow:function(index,rowData){
			///折叠行
			if(LabIndex!=""){
				$('#Lab').datagrid('collapseRow',LabIndex);
			}
			LabIndex = index;
			var LabDate=rowData.AuthDateTime;
			///定义columns
			var columns=[[
				{field:"TestCodeCode",title:$g('项目编号')},
				{field:"TestCodeName",title:$g('项目名称')},
				{field:'Result',title:$g('结果'),formatter:SetCellColor},
				{field:'Units',title:$g('单位')},
				{field:'RefRanges',title:$g('参考范围')},
				{field:'AbFlag',title:$g('异常提示')},
				{field:'AddSign',title:$g('添加标志'),align:'center'}
			]];

			$('#ddv-'+index).datagrid({
				//title:'检验值',    
				url:'',
				border:false,
				rownumbers:true,
				columns:columns,
			    singleSelect:true,
				loadMsg: $g('正在加载信息...'),
			    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			    var text=LabDate+" "+rowData.TestCodeName+":"+rowData.Result+" "+rowData.Units+"["+rowData.RefRanges+"]"+";  ";
			            callBack(text);
		            $("tr[datagrid-row-index="+rowIndex+"]"+" "+"td[field=AddSign]"+" "+"div").html("<img src='../scripts/dhcpha/images/accept.png' border=0/>");
		        },
				rowStyler:function(rowIndex,rowData){
					if (rowData.AbFlag!="N"){
						return 'color:red;font-weight:bold;';
					}
				}
			});
			///自动加载
			$('#ddv-'+index).datagrid({
				url:'dhcapp.broker.csp',
		        queryParams:{
	     		    ClassName: 'PHA.CPW.Com.OutInterfance',
	     			MethodName: 'LabItmsValue',
					oneReportDR:rowData.oneReportDR,
		        }
			});
		}
	});

	//initScroll();//初始化显示横向滚动条

	$('#LabWin').window({
		title:'检验列表',    
		collapsible:true,
		border:true,
		closed:"true",
		width:800,
		height:450,
		minimizable:false,						/// 隐藏最小化按钮(qunianpeng 2018/3/15)
		//maximized:true,						/// 最大化
		//modal:true,
		onClose:function(){
			$('#LabWin').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 
	$('#LabWin').window('open');
	
	///自动加载
	$('#Lab').datagrid({
		url:'dhcapp.broker.csp',
		queryParams:{
	     		ClassName: 'PHA.CPW.Com.OutInterfance',
	     		MethodName: 'GetPatLabList',
				EpisodeID: AdmDr
			},
	});
	//initScroll("#Lab");  liyarong 2016-09-21
	$('#Lab').datagrid('loadData', {total:0,rows:[]});  //sufan 2016/09/21
}

//设置列颜色  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if(rowData.AbFlag=="N"){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

/// 历次检验结果
/*function  frameHisResult(value,rowData,rowIndex){
   // return "<a href='#' mce_href='#' onclick='showHisResultWin("+rowIndex+");'>历次结果</a>";  
}

function showHisResultWin(rowIndex)
{
	var oeori=$("tr[datagrid-row-index="+rowIndex+"] "+"td[field=oeori]").text();
	window.open("dhclabviewoldresult.csp?PatientBanner=1&OrderID="+oeori+"&StartDate=",'','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=1250,height=670,left=80,top=10');
}*/