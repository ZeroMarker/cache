/*
 * FileName:	dhcinsu.insumdtrtinfo.js
 * User:		sxq
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 就诊信息查询
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 	//setValueById('mdINSUType',GV.INSUTYPE);
 	//setValueById('mdINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('mdSDate',getDefStDate(0));
	//setValueById('mdEDate',getDefStDate(1));
	InsuDateDefault('mdSDate');	
	InsuDateDefault('mdEDate',+1);		
	//setValueById('mdpsn_no',GV.PSNNO);
	//setValueById('med_type',GV.MEDTYPE);
	//医保类型
	init_mdINSUType();
	//click事件
	init_mdClick();
	//就诊信息dg	
	init_insumddg(); 
	
});

/**
*初始化click事件
*/		
function init_mdClick()
{
	 //查询
	 $("#btnMdQry").click(MdQry_Click);
  
}
	
/**
*查询待遇检查享受信息
*/	
function MdQry_Click()
{
	var ExpStr=""  
	var trt=getValueById('mdpsn_no');
	if(trt == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	var mdSDate=getValueById('mdSDate');
	if(mdSDate=="")
	{
		$.messager.alert("温馨提示","开始时间不能为空!", 'info');
		return ;
	}
	/*var mdID=getValueById('mdtrt_id')
	if(mdID==""){
		$.messager.alert("温馨提示","就诊ID不能为空!", 'info');
		return ;
		}*/
	var outPutObj=getMdInfo();
	if(!outPutObj){return ;}
	if (outPutObj.mdtrtinfo.length==0){$.messager.alert("温馨提示","未查询就诊信息!", 'info');return ;}
	loadQryGrid("insumddg",outPutObj.mdtrtinfo);
}

///【5201】就诊记录查询
function getMdInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('mdINSUType')+"^"+"5201"+"^^output^"+connURL;
	var QryParams=""
	
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('mdpsn_no'));
	QryParams=AddQryParam(QryParams,"begntime",GetInsuDateFormat(getValueById('mdSDate')));
	QryParams=AddQryParam(QryParams,"endtime",GetInsuDateFormat(getValueById('mdEDate')));
	QryParams=AddQryParam(QryParams,"med_type",getValueById('mdmed_type'));
	QryParams=AddQryParam(QryParams,"mdtrt_id",getValueById('mdtrt_id'));
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
function init_insumddg() {
	var dgColumns = [[
			{field:'mdtrt_id',title:'就诊ID',width:120},
			{field:'psn_no',title:'人员编号',width:150},	
			{field:'psn_cert_type',title:'人员证件类型',width:160,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'certno',title:'证件号码',width:180},
			//{field:'psn_no',title:'开始日期',width:140},
			{field:'psn_name',title:'人员姓名',width:140 },
			{field:'gend',title:'性别',width:100,formatter: function(value,row,index){
				var DicType="gend"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'naty',title:'民族',width:100,formatter: function(value,row,index){
				var DicType="naty"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'brdy',title:'出生日期',width:120},
			{field:'age',title:'年龄',width:100},
			{field:'coner_name',title:'联系人姓名',width:140},
			{field:'tel',title:'联系电话',width:140},
			{field:'insutype',title:'险种类型',width:200,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'psn_type',title:'人员类别',width:120,formatter: function(value,row,index){
				var DicType="psn_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'maf_psn_flag',title:'医疗救助对象标志',width:140,formatter: function(value,row,index){
				var DicType="maf_psn_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'cvlserv_flag',title:'公务员标志',width:120,formatter: function(value,row,index){
				var DicType="cvlserv_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'flxempe_flag',title:'灵活就业标志',width:120,formatter: function(value,row,index){
				var DicType="flxempe_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'nwb_flag',title:'新生儿标志',width:120,formatter: function(value,row,index){
				var DicType="nwb_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'insu_optins',title:'参保机构医保区划',width:140,formatter: function(value,row,index){
				var DicType="insu_optins"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'emp_name',title:'单位名称',width:220},
			{field:'begntime',title:'开始时间',width:160},
			{field:'endtime',title:'结束时间',width:160},
			{field:'mdtrt_cert_type',title:'就诊凭证类型',width:140,formatter: function(value,row,index){
				var DicType="mdtrt_cert_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'med_type',title:'医疗类别',width:120,formatter: function(value,row,index){
				var DicType="med_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'ars_year_ipt_flag',title:'跨年度住院标志',width:150,formatter: function(value,row,index){
				var DicType="ars_year_ipt_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'pre_pay_flag',title:'先行支付标志',width:140,formatter: function(value,row,index){
				var DicType="pre_pay_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'ipt_otp_no',title:'住院/门诊号',width:120},
			{field:'medrcdno',title:'病历号',width:80},
			{field:'atddr_no',title:'主治医生编码',width:120},
			{field:'chfpdr_name',title:'主诊医师姓名',width:120},
			{field:'adm_dept_codg',title:'入院科室编码',width:120},
			{field:'adm_dept_name',title:'入院科室名称',width:120},
			{field:'adm_bed',title:'入院床位',width:120},
			{field:'dscg_maindiag_code',title:'住院主诊断代码',width:120},
			{field:'dscg_maindiag_name',title:'住院主诊断名称',width:120},
			{field:'dscg_dept_codg',title:'出院科室编码',width:120},
			{field:'dscg_dept_name',title:'出院科室名称',width:120},
			{field:'dscg_bed',title:'出院床位',width:120},
			{field:'dscg_way',title:'离院方式',width:120,formatter: function(value,row,index){
				var DicType="dscg_way"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'main_cond_dscr',title:'主要病情描述',width:120},
			{field:'dise_codg',title:'病种编码',width:120},
			{field:'dise_name',title:'病种名称',width:120},
			{field:'oprn_oprt_code',title:'手术操作代码',width:120},
			{field:'oprn_oprt_name',title:'手术操作名称',width:120},
			{field:'otp_diag_info',title:'门诊诊断信息',width:120},
			{field:'inhosp_stas',title:'在院状态',width:120,formatter: function(value,row,index){
				var DicType="inhosp_stas"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'die_date',title:'死亡日期',width:120},
			{field:'ipt_days',title:'住院天数',width:120},
			{field:'fpsc_no',title:'计划生育服务证号',width:140},
			{field:'matn_type',title:'生育类别',width:120,formatter: function(value,row,index){
				var DicType="matn_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'birctrl_type',title:'计划生育手术类别',width:140,formatter: function(value,row,index){
				var DicType="birctrl_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'latechb_flag',title:'晚育标志',width:120,formatter: function(value,row,index){
				var DicType="latechb_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'geso_val',title:'孕周数',width:120},
			{field:'fetts',title:'胎次',width:120},
			{field:'fetus_cnt',title:'胎儿数',width:120},
			{field:'pret_flag',title:'早产标志',width:120,formatter: function(value,row,index){
				var DicType="pret_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'birctrl_matn_date',title:'计划生育手术或生育日期',width:180},
			{field:'cop_flag',title:'伴有并发症标志',width:120,formatter: function(value,row,index){
				var DicType="cop_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'opter_id',title:'经办人 ID',width:120},
			{field:'opter_name',title:'经办人姓名',width:120},
			{field:'opt_time',title:'经办时间',width:160},
			{field:'memo',title:'备注',width:120}
		]];

	// 初始化DataGrid
	$('#insumddg').datagrid({
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
function init_mdINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('mdINSUType','DLLType',Options); 	
	$('#mdINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('mdINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
	        INSULoadDicData('mdmed_type','med_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR});  	// 医疗类别
		
		},
 
	})	;
	
}