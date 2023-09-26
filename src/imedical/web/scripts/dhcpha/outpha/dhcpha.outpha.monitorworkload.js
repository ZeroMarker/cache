/// Creator: bianshuai
/// CreateDate: 2014-06-22
/// 门诊审方工作量统计js

var url="dhcpha.clinical.action.csp";
var TypeArray = [{ "val": "P", "text": "通过" }, { "val": "R", "text": "拒绝" }, { "val": "N", "text": "未审" }];
$(function(){
	//默认显示横向滚动条
	function initScroll(){
		var opts=$('#dgUser').datagrid('options');    
		var text='{';    
		for(var i=0;i<opts.columns.length;i++)
		{    
			var inner_len=opts.columns[i].length;    
			for(var j=0;j<inner_len;j++)
			{    
				if((typeof opts.columns[i][j].field)=='undefined')break;    
				text+="'"+opts.columns[i][j].field+"':''";    
				if(j!=inner_len-1){
					text+=",";    
				}    
			}    
		}    
		text+="}";    
		text=eval("("+text+")");    
		var data={"total":1,"rows":[text]};    
		$('#dgUser').datagrid('loadData',data);  
		$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
	}
	
	initScroll();//初始化显示横向滚动条
	
	$("#stdate").datebox("setValue", formatDate(-1));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	/*
	//科室
	$('#Dept').combobox({
		onShowPanel:function(){
			$('#Dept').combobox('reload',url+'?actiontype=SelAllLoc&loctype=D');
		}
	}); 
	*/
	//用户
	$('#User').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID']
	});  
	
	//类型
	$('#Type').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:TypeArray
	});
	$('#Type').combobox('setValue',"P"); //设置combobox默认值
})

/// 格式化日期
function formatDate(t)
{
	var curr_time = new Date();  
	var Year = curr_time.getFullYear();
	var Month = curr_time.getMonth()+1;
	var Day = curr_time.getDate()+parseInt(t);
	return Month+"/"+Day+"/"+Year;
}

//查询
function Query()
{
	var tab = $('#tab').tabs('getSelected');  // 获取选择的面板
	var tbId = tab.attr("id");  //选择面板的ID
	var StDate=$('#stdate').datebox('getValue'); //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID="";  //$('#Dept').combobox('getValue'); //科室ID
	var UserID=$('#User').combobox('getValue');       //UserID
	var Type=$('#Type').combobox('getValue');         //状态
	
	if((StDate=="")||(StDate=="")){
		$.messager.alert("提示:","起始日期或截止日期不能为空！");
		return;
	}

	if(Type==""){
		$.messager.alert("提示:","类型不能为空！");
		return;
	}
		
	var dgID="";
	var params=StDate+"^"+EndDate+"^"+session['LOGON.CTLOCID']+"^"+UserID+"^"+Type+"^"+tbId;
	if(tbId=="tabUser"){
		dgID='#dgUser';
	}else{
		dgID='#dgDept';
	}
	
	//$(dgID).datagrid('load',{params:params});  

	$(dgID).datagrid({
		url:url+'?actiontype=MonitoWorkLoad',
		queryParams:{
			params:params}
	});
}

//设置连接 formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.TPid+","+rowData.TLocDr+")'>"+value+"</a>";
}

///显示窗口 formatter="SetCellUrl"
function showWin(pid,LocID)
{
	$('#win').append('<div id="dg"></div>');
	$('#win').window({
		title:'明细列表',
		collapsible:true,
		border:true,
		closed:"true",
		width:900,
		height:550,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		toolbar:[{text: '取消'}]
	});
	$('#dg').datagrid({
		rownumbers:'true',
		pagination:'true',
		url:url+'?actiontype=QueryLocDetail',
		fit:'true',
		pageList:[30,60],
		pageSize:30,
		singleSelect:'true',
		columns: [[
			{field:"TPatNo",title:'登记号',width:'100'},
			{field:"TPatName",title:'病人姓名',width:'100'},
			{field:"TPrescNo",title:'处方号',width:'100'}
		]],
		queryParams:{
			LocID:LocID,
			pid:pid
		}
	})
	$('#win').window('open');   

}
