/*
 * FileName:	dhcinsu.insuopspdiseqry.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 人员慢特病备案信息查询-5301
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 	//setValueById('opspINSUType',GV.INSUTYPE);
 	//setValueById('opspINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('regSDate',getDefStDate(0));
	//setValueById('regEDate',getDefStDate(1));	
	//setValueById('opsppsn_no',GV.PSNNO);
	// 医保类型
	init_opspINSUType();
	//click事件
	init_opspClick();
	//初始化人员慢特病备案信息查询记录dg	
	init_insuopspdg(); 
	
});


/**
*初始化click事件
*/		
function init_opspClick()
{
	 //查询
	 $("#btnopspQry").click(opspQry_Click);
  
}
	
/**
*人员慢特病备案信息查询
*/	
function opspQry_Click()
{
	var ExpStr=""  
	var regpsnno=getValueById('opsppsn_no');
	if(regpsnno == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	
	var outPutObj=getopspInfo();
	
	if(!outPutObj){return ;}
	if (outPutObj.feedetail.length==0){$.messager.alert("温馨提示","未查询到对应的人员慢特病备案记录!", 'info');return ;}
	loadQryGrid("insuopspdg",outPutObj.feedetail);
}

///人员慢特病备案信息查询-5301
function getopspInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('opspINSUType')+"^"+"5301"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('opsppsn_no'));
	//QryParams=AddQryParam(QryParams,"begntime",getValueById('regSDate'));
	//QryParams=AddQryParam(QryParams,"endtime",getValueById('regEDate'));
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
function init_insuopspdg() {
	var dgColumns = [[
			{field:'opsp_dise_code',title:'门慢特病种代码',width:150},
			{field:'opsp_dise_name',title:'门慢特病种名称',width:150},
			{field:'begndate',title:'开始日期',width:100},
			{field:'enddate',title:'结束日期',width:100}
		]];

	// 初始化DataGrid
	$('#insuopspdg').datagrid({
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
			
		}
	});
}

/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */
function init_opspINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('opspINSUType','DLLType',Options); 	
	$('#opspINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('opspINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
	     
		}
	})	;
	
}





