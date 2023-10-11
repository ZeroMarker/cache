/*
 * FileName:	dhcinsu.insureferralInfoqry.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 转院信息查询-5304
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 	//setValueById('referINSUType',GV.INSUTYPE);
 	//setValueById('referINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('referSDate',getDefStDate(0));
	//setValueById('referEDate',getDefStDate(1));
	InsuDateDefault('referSDate');	
	InsuDateDefault('referEDate',+1);		
	//setValueById('referpsn_no',GV.PSNNO);
	// 医保类型
	init_referINSUType();
	//click事件
	init_referClick();
	//初始化转院信息查询记录dg	
	init_insureferdg(); 
	
});


/**
*初始化click事件
*/		
function init_referClick()
{
	 //查询
	 $("#btnreferQry").click(referQry_Click);
  
}
	
/**
*转院信息查询
*/	
function referQry_Click()
{
	var ExpStr=""  
	var regpsnno=getValueById('referpsn_no');
	if(regpsnno == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	var mtSDate=getValueById('referSDate');
	if(mtSDate=="")
	{
		$.messager.alert("温馨提示","开始时间不能为空!", 'info');
		return ;
	}
	
	var outPutObj=getreferInfo();
	
	if(!outPutObj){return ;}
	if (outPutObj.refmedin.length==0){$.messager.alert("温馨提示","未查询到对应的转院备案记录!", 'info');return ;}
	loadQryGrid("insureferdg",outPutObj.refmedin);
}

///转院信息查询-5304
function getreferInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('referINSUType')+"^"+"5304"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('referpsn_no'));
	QryParams=AddQryParam(QryParams,"begntime",getValueById('referSDate'));
	QryParams=AddQryParam(QryParams,"endtime",getValueById('referEDate'));
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
function init_insureferdg() {
	var dgColumns = [[
			{field:'insutype',title:'险种类型',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'dcla_souc',title:'申报来源',width:100,formatter: function(value,row,index){
				var DicType="dcla_souc"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'psn_no',title:'人员编号',width:180},
			{field:'psn_cert_type',title:'人员证件类型',width:150,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'certno',title:'证件号码',width:180},
			{field:'psn_name',title:'人员姓名',width:100},
			{field:'gend',title:'性别',width:100},
			{field:'brdy',title:'出生日期',width:100},
			{field:'tel',title:'联系电话',width:100},
			{field:'addr',title:'联系地址',width:180},
			{field:'insu_optins',title:'参保区划',width:100},
			{field:'emp_name',title:'单位名称',width:180},
			{field:'diag_code',title:'诊断代码',width:100},
			{field:'diag_name',title:'诊断名称',width:120},
			{field:'dise_cond_dscr',title:'病情',width:100},
			{field:'reflin_medins_no',title:'转往医院编码',width:120},
			{field:'reflin_medins_name',title:'转往医院名称',width:180},
			{field:'out_flag',title:'异地标志',width:100,formatter: function(value,row,index){
				var DicType="out_flag"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'refl_date',title:'转院日期',width:120},
			{field:'refl_rea',title:'转院原因',width:100},
			{field:'begndate',title:'开始日期',width:120},
			{field:'enddate',title:'结束日期',width:120},
			{field:'hosp_agre_refl_flag',title:'医院同意转院标志',width:140,formatter: function(value,row,index){
				var DicType="hosp_agre_refl_flag"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'opter_id',title:'经办人ID',width:80},
			{field:'opter_name',title:'经办人姓名',width:100},
			{field:'opt_time',title:'经办时间',width:100}
			
		]];

	// 初始化DataGrid
	$('#insureferdg').datagrid({
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
function init_referINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('referINSUType','DLLType',Options); 	
	$('#referINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('referINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
	     
		}
	})	;
	
}




