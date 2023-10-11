/*
 * FileName:	dhcinsu.insumtfeedetail.js
 * User:		DingSH
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 人员慢特病用药记录查询
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 	//setValueById('mtINSUType',GV.INSUTYPE);
 	//setValueById('mtINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('mtSDate',getDefStDate(0));
	//setValueById('mtEDate',getDefStDate(1));
	InsuDateDefault('mtSDate');	
	InsuDateDefault('mtEDate',+1);		
	//setValueById('mtpsn_no',GV.PSNNO);
	// 医保类型
	init_mtINSUType();
	//click事件
	init_mtClick();
	//初始化人员慢特病用药记录dg	
	init_insumtdg(); 
	
});

/**
*初始化click事件
*/		
function init_mtClick()
{
	 //查询
	 $("#btnMtQry").click(MtQry_Click);
  
}
	
/**
*查询待遇检查享受信息
*/	
function MtQry_Click()
{
	var ExpStr=""  
	var trtPsnNo=getValueById('mtpsn_no');
	if(trtPsnNo == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	var mtSDate=getValueById('mtSDate');
	if(mtSDate=="")
	{
		$.messager.alert("温馨提示","开始时间不能为空!", 'info');
		return ;
	}
	var outPutObj=getMtInfo();
	if(!outPutObj){return ;}
	if (outPutObj.feedetail.length==0){$.messager.alert("温馨提示","未查询到对应的用药记录!", 'info');return ;}
	loadQryGrid("insumtdg",outPutObj.feedetail);
}

///【5205】人员慢特病用药记录查询
function getMtInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('mtINSUType')+"^"+"5205"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('mtpsn_no'));
	QryParams=AddQryParam(QryParams,"begntime",GetInsuDateFormat(getValueById('mtSDate')));
	QryParams=AddQryParam(QryParams,"endtime",GetInsuDateFormat(getValueById('mtEDate')));
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
function init_insumtdg() {
	var dgColumns = [[
			{field:'psn_no',title:'人员编号',width:150},
			{field:'rx_drord_no',title:'处方/医嘱号',width:150},	
			{field:'fixmedins_code',title:'定点医药机构编号',width:150},
			{field:'fixmedins_name',title:'定点医药机构名称',width:150},
			{field:'psn_no',title:'开始日期',width:120},
			{field:'med_type',title:'结束日期',width:120 },
			{field:'fee_ocur_time',title:'费用发生时间',width:160},
			{field:'cnt',title:'数量',width:150},
			{field:'pric',title:'单价',width:150,align:'right'},
			{field:'chrgitm_lv',title:'收费项目等级',width:150,formatter: function(value,row,index){
				var DicType="chrgitm_lv"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hilist_code',title:'医保目录编码',width:160},
			{field:'hilist_name',title:'医保目录名称',width:160},
			{field:'list_type',title:'目录类别',width:150,formatter: function(value,row,index){
				var DicType="list_type"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'med_list_codg',title:'医疗目录编码',width:150},
			{field:'medins_list_codg',title:'医药机构目录编码',width:180},
			{field:'medins_list_name',title:'医药机构目录名称',width:180},
			{field:'med_chrgitm_type',title:'医疗收费项目类别',width:180,formatter: function(value,row,index){
				var DicType="med_chrgitm_type"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'prodname',title:'商品名',width:150},
			{field:'spec',title:'规格',width:100},
			{field:'dosform_name',title:'剂型名称',width:120},
			{field:'lmt_used_flag',title:'限制使用标志',width:120,formatter: function(value,row,index){
				var DicType="lmt_used_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hosp_prep_flag',title:'医院制剂标志',width:120,formatter: function(value,row,index){
				var DicType="hosp_prep_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hosp_appr_flag',title:'医院审批标志',width:120,formatter: function(value,row,index){
				var DicType="hosp_appr_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'tcmdrug_used_way',title:'中药使用方式',width:120},
			{field:'prodplac_type',title:'生产地类别',width:120,formatter: function(value,row,index){
				var DicType="prodplac_type"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'bas_medn_flag',title:'基本药物标志',width:120,formatter: function(value,row,index){
				var DicType="bas_medn_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hi_nego_drug_flag',title:'医保谈判药品标志',width:160,formatter: function(value,row,index){
		     	return value=="1" ? "是":"否" ;          
			}},
			{field:'chld_medc_flag',title:'儿童用药标志',width:120,formatter: function(value,row,index){
				var DicType="chld_medc_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'etip_flag',title:'外检标志',width:80,formatter: function(value,row,index){
				var DicType="etip_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'etip_hosp_code',title:'外检医院编码',width:120},
			{field:'dscg_tkdrug_flag',title:'出院带药标志',width:120,formatter: function(value,row,index){
				var DicType="dscg_tkdrug_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'list_sp_item_flag',title:'目录特项标志',width:120,formatter: function(value,row,index){
				var DicType="list_sp_item_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'matn_fee_flag',title:'生育费用标志',width:120,formatter: function(value,row,index){
				var DicType="matn_fee_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}}
		]];

	// 初始化DataGrid
	$('#insumtdg').datagrid({
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
function init_mtINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('mtINSUType','DLLType',Options); 	
	$('#mtINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('mtINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
	})	;
	
}





