/*
 * FileName:	dhcinsu.insusetlinfo.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 结算信息查询-5203
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 	//setValueById('setlINSUType',GV.INSUTYPE);
 	//setValueById('setlINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('regSDate',getDefStDate(0));
	//setValueById('regEDate',getDefStDate(1));	
	//setValueById('setlpsn_no',GV.PSNNO);
	//setValueById('setlInsuplc_admdvs',GV.INSUPLCADMDVS);
	// 医保类型
	init_setlINSUType();
	//click事件
	init_setlClick();
	//初始化在院信息查询记录dg	
	init_insusetldg(); 
	
});

/**
*初始化click事件
*/		
function init_setlClick()
{
	 //查询
	 $("#btnSetlQry").click(setlQry_Click);
  
}
	
/**
*结算信息查询-5203
*/	
function setlQry_Click()
{
	var ExpStr=""  
	var setlpsn_no=getValueById('setlpsn_no');
	if(setlpsn_no == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	/*var setlsetlid=getValueById('setlsetl_id');
	if(setlsetlid=="")
	{
		$.messager.alert("温馨提示","结算ID不能为空!", 'info');
		return ;
	}*/
	var setlmdtrtid=getValueById('setlmdtrt_id');
	if(setlmdtrtid=="")
	{
		$.messager.alert("温馨提示","就诊ID不能为空!", 'info');
		return ;
	}
	
	var outPutObj=getsetlInfo();
	
	var setlinfoData = JSON.stringify(outPutObj.setlinfo);
	
	var setinfoObj=JSON.parse("["+setlinfoData+"]");
	
	if(!outPutObj){return ;}
	if (setinfoObj.length==0){$.messager.alert("温馨提示","未查询到对应的结算信息查询!", 'info');return ;}
	loadQryGrid("insusetldg",setinfoObj);
	
}

///结算信息查询-5203
function getsetlInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('setlINSUType')+"^"+"5203"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('setlpsn_no'));
	QryParams=AddQryParam(QryParams,"setl_id",getValueById('setlsetl_id'));
	QryParams=AddQryParam(QryParams,"mdtrt_id",getValueById('setlmdtrt_id'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",getValueById('setlInsuplc_admdvs'));
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
function init_insusetldg() {
	var dgColumns = [[
			{field:'setl_id',title:'结算ID',width:120},
			{field:'mdtrt_id',title:'就诊ID',width:120},	
			{field:'psn_no',title:'人员编号',width:150},
			{field:'psn_name',title:'人员姓名',width:100},
			{field:'psn_cert_type',title:'人员证件类型',width:160,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'certno',title:'证件号码',width:180},
			{field:'gend',title:'性别',width:100,formatter: function(value,row,index){
				var DicType="gend"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'naty',title:'民族',width:100,formatter: function(value,row,index){
				var DicType="naty"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'brdy',title:'出生日期',width:120},
			{field:'age',title:'年龄',width:100},
			{field:'insutype',title:'险种类型',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'psn_type',title:'人员类别',width:150,formatter: function(value,row,index){
				var DicType="psn_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'cvlserv_flag',title:'公务员标志',width:100,formatter: function(value,row,index){
				var DicType="cvlserv_flag"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'flxempe_flag',title:'灵活就业标志',width:150,formatter: function(value,row,index){
				var DicType="flxempe_flag"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'ipt_otp_no',title:'住院/门诊号',width:150},
			{field:'nwb_flag',title:'新生儿标志',width:150,formatter: function(value,row,index){
				var DicType="nwb_flag"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'insu_optins',title:'参保机构医保区划',width:150},
			{field:'emp_name',title:'单位名称',width:150},
			{field:'pay_loc',title:'支付地点类别',width:150,formatter: function(value,row,index){
				var DicType="pay_loc"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'fixmedins_code',title:'定点医药机构编号',width:150},
			{field:'fixmedins_name',title:'定点医药机构名称',width:180},
			{field:'hosp_lv',title:'医院等级',width:100,formatter: function(value,row,index){
				var DicType="hosp_lv"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'fixmedins_poolarea',title:'定点归属机构',width:150},
			{field:'lmtpric_hosp_lv',title:'限价医院等级',width:150,formatter: function(value,row,index){
				var DicType="lmtpric_hosp_lv"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'dedc_hosp_lv',title:'起付线医院等级',width:150,formatter: function(value,row,index){
				var DicType="dedc_hosp_lv"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'begndate',title:'开始日期',width:120},
			{field:'enddate',title:'结束日期',width:120},
			{field:'setl_time',title:'结算时间',width:160},
			{field:'mdtrt_cert_type',title:'就诊凭证类型',width:150,formatter: function(value,row,index){
				var DicType="mdtrt_cert_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'med_type',title:'医疗类别',width:150,formatter: function(value,row,index){
				var DicType="med_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'clr_type',title:'清算类别',width:100,formatter: function(value,row,index){
				var DicType="clr_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'clr_way',title:'清算方式',width:130,formatter: function(value,row,index){
				var DicType="clr_way"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'clr_optins',title:'清算经办机构',width:150},
			{field:'medfee_sumamt',title:'医疗费总额',width:150,align:'right'},
			{field:'fulamt_ownpay_amt',title:'全自费金额',width:150,align:'right'},
			{field:'overlmt_selfpay',title:'超限价自费费用',width:150,align:'right'},
			{field:'preselfpay_amt',title:'先行自付金额',width:150,align:'right'},
			{field:'inscp_scp_amt',title:'符合政策范围金额',width:150,align:'right'},
			{field:'act_pay_dedc',title:'实际支付起付线',width:150,align:'right'},
			{field:'hifp_pay',title:'基本医疗保险统筹基金支出',width:220,align:'right'},
			{field:'pool_prop_selfpay',title:'基本医疗保险统筹基金支付比例',width:220},
			{field:'cvlserv_pay',title:'公务员医疗补助资金支出',width:200,align:'right'},
			{field:'hifes_pay',title:'企业补充医疗保险基金支出',width:200,align:'right'},
			{field:'hifmi_pay',title:'居民大病保险资金支出',width:200,align:'right'},
			{field:'hifob_pay',title:'职工大额医疗费用补助基金支出',width:220,align:'right'},
			{field:'maf_pay',title:'医疗救助基金支出',width:150,align:'right'},
			{field:'oth_pay',title:'其他支出',width:150,align:'right'},
			{field:'fund_pay_sumamt',title:'基金支付总额',width:150,align:'right'},
			{field:'psn_pay',title:'个人支付金额',width:150,align:'right'},
			{field:'acct_pay',title:'个人账户支出',width:150,align:'right'},
			{field:'cash_payamt',title:'现金支付金额',width:150,align:'right'},
			{field:'balc',title:'余额',width:150,align:'right'},
			{field:'acct_mulaid_pay',title:'个人账户共济支付金额',width:150,align:'right'},
			{field:'medins_setl_id',title:'医药机构结算ID',width:150},
			{field:'refd_setl_flag',title:'退费结算标志',width:150,formatter: function(value,row,index){
				var DicType="refd_setl_flag"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'year',title:'年度',width:120},
			{field:'dise_codg',title:'病种编码',width:150},
			{field:'dise_name',title:'病种名称',width:150},
			{field:'invono',title:'发票号',width:150},
			{field:'opter_id',title:'经办人ID',width:150},
			{field:'opter_name',title:'经办人姓名',width:150},
			{field:'opt_time',title:'经办时间',width:150}
		]];

	// 初始化DataGrid
	$('#insusetldg').datagrid({
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
function init_setlINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('setlINSUType','DLLType',Options); 	
	$('#setlINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('setlINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		
		}
 
	})	;
	
}
