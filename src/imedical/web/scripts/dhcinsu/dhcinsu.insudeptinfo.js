/*
 * FileName:	dhcinsu.insudeptinfo.js
 * Creator:		HanZH
 * Date:		2022-05-25
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 科室信息查询-5101
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
	// 医保类型
	init_deptINSUType();
	//click事件
	init_regClick();
	//初始化科室信息查询记录dg	
	init_insudeptdg();
	
});

/**
*初始化click事件
*/		
function init_regClick()
{
	 //查询
	 $("#btnDeptQry").click(DeptQry_Click);
  
}
	
/**
*查询
*/	
function DeptQry_Click()
{
	var ExpStr=""
	var SaveFlag="0"
    if (getValueById('SaveFlag')){ SaveFlag="1" }
    
	var outPutObj=getDeptInfo();
	if(!outPutObj){return ;}
	//if (outPutObj.medinsinfo.length==0){$.messager.alert("温馨提示","未查询到对应的科室信息记录!", 'info');return ;}
	if (outPutObj.feedetail.length==0){$.messager.alert("温馨提示","未查询到对应的科室信息记录!", 'info');return ;}	//upt 20221209 HanZH
	loadQryGrid("insudeptdg",outPutObj.feedetail);
}

///医药机构查询-1201
function getDeptInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('deptINSUType')+"^"+"5101"+"^^output^"+connURL;
	var QryParams=""
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
function init_insudeptdg() {
	var dgColumns = [[
			{field:'hosp_dept_codg',title:'医院科室编码',width:100},		
			{field:'hosp_dept_name',title:'医院科室名称',width:150},
			{field:'begntime',title:'开始时间',width:120},	
			{field:'endtime',title:'结束时间',width:120},
			{field:'itro',title:'简介',width:120},
			{field:'dept_resper_na me',title:'科室负责人姓名',width:120},
			{field:'dept_resper_te l',title:'科室负责人电话',width:120},
			{field:'dept_med_serv_ scp',title:'科室医疗服务范围',width:130},
			{field:'caty',title:'科别',width:120},
			{field:'dept_estbdat',title:'科室成立日期',width:120},
			{field:'aprv_bed_cnt',title:'批准床位数量',width:120},
			{field:'hi_crtf_bed_cn t',title:'医保认可床位数',width:120},
			{field:'poolarea_no',title:'统筹区编号',width:120},
			{field:'dr_psncnt',title:'医师人数',width:120},
			{field:'phar_psncnt',title:'药师人数',width:120},
			{field:'nurs_psncnt',title:'护士人数',width:120},
			{field:'tecn_psncnt',title:'技师人数',width:120},
			{field:'memo',title:'备注',width:120}	
		]];

	// 初始化DataGrid
	$('#insudeptdg').datagrid({
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
function init_deptINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('deptINSUType','DLLType',Options); 	
	$('#deptINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('deptINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
 
	})	;
	
}






