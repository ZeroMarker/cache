/*
 * FileName:	dhcinsu.insudicinfo.js
 * Creator:		Chenyq
 * Date:		2021-12-23
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 字典表查询-1901
 */
  var fileData=[];
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
	//setValueById('queryDate',getDefStDate(0));
	InsuDateDefault('queryDate');	
	// 医保类型
	init_dicINSUType();
	//click事件
	init_regClick();
	//初始化字典表查询记录dg	
	init_insudicdg(); 
	// 查询信息下拉框
	init_QueryPanel();
	
});


/**
*初始化click事件
*/		
function init_regClick()
{
	 //导出 + 20220923  LuJH
	 $("#btnExport").click(btnExport_Click);
	 //查询
	 $("#btnDicQry").click(DicQry_Click);
  
}
	
/**
*字典表查询
*/	
function DicQry_Click()
{
	var ExpStr=""  
	//var parentValue=getValueById('parentValue');
	//if(parentValue == "")
	//{
	//	$.messager.alert("温馨提示","父字典键值不能为空!", 'info');
	//	return ;
	//}
	var admdvs=getValueById('admdvs');
	if(admdvs=="")
	{
		$.messager.alert("温馨提示","行政区划不能为空!", 'info');
		return ;
	}
	
	var outPutObj=getDicInfo();
	if(!outPutObj){return ;}
	fileData=outPutObj.list
	if (outPutObj.list.length==0){$.messager.alert("温馨提示","未查询到对应的字典记录!", 'info');return ;}
	loadQryGrid("insudicdg",outPutObj.list);
}

///字典表查询-1901
function getDicInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('dicINSUType')+"^"+"1901"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"type",getValueById('dicType'));
	QryParams=AddQryParam(QryParams,"parentValue",getValueById('parentValue'));
	QryParams=AddQryParam(QryParams,"admdvs",getValueById('admdvs'));
	QryParams=AddQryParam(QryParams,"date",GetInsuDateFormat(getValueById('queryDate')));
	QryParams=AddQryParam(QryParams,"vali_Flag",getValueById('valiFlag'));
	QryParams=AddQryParam(QryParams,"page_num",getValueById('pageNum'));
	QryParams=AddQryParam(QryParams,"page_size",getValueById('pageSize'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",GV.INSUPLCADMDVS);
	ExpStr=ExpStr+"^"+QryParams
	var rtn=InsuServQry(0,GV.USERID,ExpStr); 
	if (!rtn){return ;}
	if (rtn.split("^")[0]!="0") 
	 {
		$.messager.alert("提示","查询失败!rtn="+rtn, 'error');
		return ;
	}
	 var outPutObj=JSON.parse(rtn.split("^")[1]);
	return outPutObj;
}
/*
 * datagrid
 */
function init_insudicdg() {
	var dgColumns = [[
			{field:'sort',title:'序号',width:79},
			{field:'type',title:'字典类型',width:200},
			{field:'label',title:'字典标签',width:200},	
			{field:'value',title:'字典键值',width:100},
			{field:'parent_value',title:'父字典键值',width:100},
			{field:'valiFlag',title:'权限标识',width:150},
			{field:'createUser',title:'创建账户',width:100},
			{field:'create_date',title:'创建时间',width:280,formatter: function(value,row,index){
		     	 return timeCycle(value);     
			}},			
			{field:'version',title:'版本号',width:200},
			
		]];

	// 初始化DataGrid
	$('#insudicdg').datagrid({
		fit:true,
		border:false,
		data:[],
		//striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}

/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */
function init_dicINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('dicINSUType','DLLType',Options); 	
	$('#dicINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('dicINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
 
	})	;
	
}

/* 
 * 初始化查询面板
 */
function init_QueryPanel(){
	// 有效标志
	$('#valiFlag').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '1',
    			"text":"有效",
    			selected:true
    		},{
    			"id" : '0',
    			"text":"无效"	
    		}]	
	});
	
}

/* 
 * 时间格式转换
 */
function timeCycle(time){
		//var time = 1624877371000;
		//var commonTime = unixTimestamp.toLocaleString();
		var unixTimestamp = new Date(time);
		var year=unixTimestamp.getFullYear();
		var month=unixTimestamp.getMonth()+1;
		var date=unixTimestamp.getDate();
		var hour=unixTimestamp.getHours();
		var minute=unixTimestamp.getMinutes();
		var second=unixTimestamp.getSeconds(); 
		if (month<10){month="0"+month}
		if (date<10){date="0"+date}
		if (hour<10){hour="0"+hour}
		if (minute<10){minute="0"+minute}
		if (second<10){second="0"+second}
		var commonTime=year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second;
		return commonTime;
	 }





/**
*导出
*/
function btnExport_Click(){
	
	 if (fileData.length==0){
		$.messager.popover({msg:'请先查询数据再导出!',type:'info'});
		return ;
	 }
	//JSONToCSVConvertor(fileData, getValueById('type')+'字典导出',"权限标识,创建账户,字典标签,序号,创建时间,字典类型,父字典键值,字典键值,版本号")
	jsonToExcel(fileData, "权限标识,创建账户,字典标签,序号,创建时间,字典类型,父字典键值,字典键值,版本号",getValueById('type')+"字典导出")  //dhcinsu.common.js
}



