/// Creator: bianshuai
/// CreateDate: 2014-06-22
//  Descript: 临床路径

var url="dhcpha.clinical.action.csp";

var statArray = [{ "val": "I", "text": "入径" }, { "val": "O", "text": "出径" }, { "val": "C", "text": "完成" }];
var typeArray = [{ "val": "QryCPWByInDate", "text": "入径时间" }, { "val": "QryCPWByOutDate", "text": "出径时间" },
	{ "val": "QryCPWByAdmDate", "text": "入院时间" }, { "val": "QryCPWByDischDate", "text": "出院时间" }]

$(function(){
	//默认显示横向滚动条
	function initScroll(){
		var opts=$('#dg').datagrid('options');    
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
		$('#dg').datagrid('loadData',data);  
		$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
	}
	
	initScroll();//初始化显示横向滚动条

	$('#dg').datagrid('loadData',{total:0,rows:[]});  //初始化数据表格 qunianpeng  2016-09-08
	
	$("#stdate").datebox("setValue", formatDate(-1));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//科室
	$('#dept').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc')
		}
		//panelHeight:"auto",  //设置容器高度自动增长
		//url:url+'?actiontype=SelAllLoc' 
	}); 

	//病区
	$('#ward').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion')
			//$('#ward').combobox('reload',url+'?action=SelAllLoc&loctype=W')
			//$('#ward').combobox('reload',url+'?action=SelAllWard') //qunianpeng 2016/10/17
		}
		//panelHeight:"auto",  //设置容器高度自动增长
		//url:url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID'] 
	});

	//状态
	$('#status').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statArray 
	});
	$('#status').combobox('setValue',"I"); //设置combobox默认值
	
	//类型
	$('#type').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:typeArray
	});
	$('#type').combobox('setValue',"QryCPWByInDate"); //设置combobox默认值
	
	//临床路径字典
	$('#cpwdic').combobox({
		onShowPanel:function(){
			$('#cpwdic').combobox('reload',url+'?action=ClinPathWayDic')
		}
	});
	
})

//查询
function Query()
{
	//1、清空datagrid 
	$('#dg').datagrid('loadData',{total:0,rows:[]});  //qunianpeng  2016-09-08 
	
	var StDate=$('#stdate').datebox('getValue'); //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue'); //科室ID
	var WardID=$('#ward').combobox('getValue'); //病区ID
	var Status=$('#status').combobox('getValue'); //状态
	var PathWaysQuery=$('#type').combobox('getValue'); //类型
	var Select="N"; //$('#type').combobox('getValue'); //是否筛选
	var cpyicID=$('#cpwdic').combobox('getValue'); //临床路径字典
	if (LocID== undefined){LocID="";}
	if (WardID== undefined){WardID="";}
	if (cpyicID== undefined){cpyicID="";}
	if (Status== undefined){Status="";}
	if (PathWaysQuery== undefined){PathWaysQuery="QryCPWByInDate";}
	var params=StDate+"^"+EndDate+"^"+Status+"^"+LocID+"^"+WardID+"^"+Select+"^"+cpyicID+"^"+PathWaysQuery;
	$('#dg').datagrid({
		url:url+'?action=CliPathWay',	
		queryParams:{
			params:params}
	});
	//$('#dg').datagrid('load',{params:params}); 
}

//设置列颜色  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if(((value.indexOf("-")=="-1")&(value!="↓"))||(value=="↑")){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

//登记号设置连接 formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.Paadm+")'>"+value+"</a>";
}

///显示窗口 formatter="SetCellUrl"
function showWin(AdmDr)
{
	createPatInfoWin(AdmDr); //调用窗体 createPatInfoWin.js
}