
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
		{field:"EpisodeID",title:'EpisodeID',width:90,hidden:true},
		{field:"oeori",title:'oeori',width:90,hidden:true},
		{field:"LabTestSetRow",title:'LabTestSetRow',width:90,hidden:true},
		{field:'arcitmcode',title:'代码',width:100},
		{field:'arcitmdesc',title:'名称',width:300},
		{field:'SpecName',title:'样本类型',width:200},
		{field:'recdate',title:'接收日期',width:100},
		{field:'rectime',title:'接收时间',width:100},
		//{field:'HisResult',title:'历次结果',width:80,formatter:frameHisResult}
	]];
	
	$('#Lab').datagrid({
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
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
			var LabDate=rowData.recdate;
			///定义columns
			var columns=[[
				{field:"itmcode",title:'项目编号',width:80},
				{field:"itmname",title:'项目名称',width:200},
				{field:'units',title:'单位',width:70},
				{field:'itmval',title:'检验值',width:80,formatter:SetCellColor},
				{field:'ItmRange',title:'参考范围',width:100},
				{field:'AbnorFlag',title:'异常标记',width:90,hidden:true},
				{field:'ItemRes',title:'检验结果',width:220,hidden:true},
				{field:'AddSign',title:'添加标志',width:80,align:'center'}
			]];

			$('#ddv-'+index).datagrid({
				//title:'检验值',    
				url:'',
				border:false,
				rownumbers:true,
				columns:columns,
			    singleSelect:true,
				loadMsg: '正在加载信息...',
			    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			    var text=LabDate+" "+rowData.itmname+":"+rowData.itmval+" "+rowData.units+"["+rowData.ItmRange+"]";
			            callBack(text);
		            $("tr[datagrid-row-index="+rowIndex+"]"+" "+"td[field=AddSign]"+" "+"div").html("<img src='../scripts/dhcpha/images/accept.png' border=0/>");
		        },
				rowStyler:function(rowIndex,rowData){
					if (rowData.AbnorFlag!="N"){
						return 'color:red;font-weight:bold;';
					}
				}
			});
			///自动加载
			$('#ddv-'+index).datagrid({
				url:url+'?action=LabItmsValue',
				queryParams:{
					LabTestSetRow:rowData.LabTestSetRow,
					rows:"100",
					page:'1'
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
		width:870,
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
		url:url+'?action=GetPatLabList',
		queryParams:{
			EpisodeID:AdmDr,
			param:""
		}
	});
	//initScroll("#Lab");  liyarong 2016-09-21
	$('#Lab').datagrid('loadData', {total:0,rows:[]});  //sufan 2016/09/21
}

//设置列颜色  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if(rowData.AbnorFlag=="N"){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

/// 历次检验结果
function  frameHisResult(value,rowData,rowIndex){
   // return "<a href='#' mce_href='#' onclick='showHisResultWin("+rowIndex+");'>历次结果</a>";  
}

function showHisResultWin(rowIndex)
{
	var oeori=$("tr[datagrid-row-index="+rowIndex+"] "+"td[field=oeori]").text();
	window.open("dhclabviewoldresult.csp?PatientBanner=1&OrderID="+oeori+"&StartDate=",'','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=1250,height=670,left=80,top=10');
}