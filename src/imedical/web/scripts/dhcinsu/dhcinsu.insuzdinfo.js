/*
 * FileName:	dhcinsu.insuzdinfo.js
 * User:		sxq
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 诊断信息查询
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 	//setValueById('zdINSUType',GV.INSUTYPE);
 	//setValueById('zdINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('mtSDate',getDefStDate(0));
	//setValueById('mtEDate',getDefStDate(1));	
	//setValueById('zdpsn_no',GV.PSNNO);
	//setValueById('zdmdtrt_id',GV.MDTRTID);
	// 医保类型
	init_zdINSUType();
	//click事件
	init_zdClick();
	//初始化人员慢特病用药记录dg	
	init_insuzddg(); 
	
});

/**
*初始化click事件
*/		
function init_zdClick()
{
	 //查询
	 $("#btnZdQry").click(ZdQry_Click);
  
}
	
/**
*查询待遇检查享受信息
*/	
function ZdQry_Click()
{
	var ExpStr=""  
	var trt=getValueById('zdpsn_no');
	if(trt == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	var mdtrt_id=getValueById('zdmdtrt_id');
	if(mdtrt_id=="")
	{
		$.messager.alert("温馨提示","就诊ID不能为空!", 'info');
		return ;
	}
	
	var outPutObj=getZdInfo();
	if(!outPutObj){return ;}
	if (outPutObj.diseinfo.length==0){$.messager.alert("温馨提示","未查询到对应就诊信息!", 'info');return ;}
	loadQryGrid("insuzddg",outPutObj.diseinfo);
}

///【5202】就诊信息查询
function getZdInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('zdINSUType')+"^"+"5202"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('zdpsn_no'));
	QryParams=AddQryParam(QryParams,"mdtrt_id",getValueById('zdmdtrt_id'));
	//QryParams=AddQryParam(QryParams,"begntime",getValueById('mtSDate'));
	//QryParams=AddQryParam(QryParams,"endtime",getValueById('mtEDate'));
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
function init_insuzddg() {
	var dgColumns = [[
			{field:'diag_info_id',title:'诊断信息 ID',width:160},
			{field:'mdtrt_id',title:'就诊 ID',width:150},	
			{field:'psn_no',title:'人员编号',width:150},
			{field:'inout_diag_type',title:'出入院诊断类别',width:140,formatter: function(value,row,index){
				var DicType="inout_diag_type"+getValueById('zdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'diag_type',title:'诊断类别',width:140,formatter: function(value,row,index){
				var DicType="diag_type"+getValueById('zdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'maindiag_flag',title:'主诊断标志',width:140,formatter: function(value,row,index){
				var DicType="maindiag_flag"+getValueById('zdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'diag_srt_no',title:'诊断排序号',width:120},
			{field:'diag_code',title:'诊断代码',width:120},
			{field:'diag_name',title:'诊断名称',width:220},
			{field:'adm_cond',title:'入院病情',width:220},
			{field:'diag_dept',title:'诊断科室',width:150},
			{field:'dise_dor_no',title:'诊断医生编码',width:150},
			{field:'dise_dor_name',title:'诊断医生姓名',width:150},
			{field:'diag_time',title:'诊断时间',width:180},
			{field:'opter_id',title:'经办人 ID',width:150},
			{field:'opter_name',title:'经办人姓名',width:150},
			{field:'opt_time',title:'经办时间',width:180}
			
		]];

	// 初始化DataGrid
	$('#insuzddg').datagrid({
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
function init_zdINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('zdINSUType','DLLType',Options); 	
	$('#zdINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('zdINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
	     
		}
	})	;
	
}




