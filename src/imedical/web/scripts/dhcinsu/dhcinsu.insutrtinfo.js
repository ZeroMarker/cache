/*
 * FileName:	dhcinsu.insutrtinfo.js
 * User:		DingSH
 * Date:		2021-01-11
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 待遇审核享受
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
	//setValueById('trtSDate',getDefStDate(0));
	//setValueById('trtEDate',getDefStDate(1));
	InsuDateDefault('trtSDate');	
	InsuDateDefault('trtEDate',+1);		
	//setValueById('Trtpsn_no',GV.PSNNO);
	//setValueById('TrtINSUType',GV.INSUTYPE);
	//setValueById('TrtINSUTypeDesc',GV.INSUTYPEDESC);
	// 医保类型
	init_trtINSUType();
	//click事件
	init_TrtClick();
	//初始化待遇检查享受信息dg	
	init_iinsutrtdg(); 
	// 险种类型
	INSULoadDicData('trtInsuType','insutype' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); 
	// 医疗类别
	INSULoadDicData('trtMedType','med_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); 
});

/**
*初始化click事件
*/		
function init_TrtClick()
{
	 //查询
	 $("#btnTrtQry").click(TrtQry_Click);
  
}
	
/**
*查询待遇检查享受信息
*/	
function TrtQry_Click()
{
	var ExpStr=""  
	var trtPsnNo=getValueById('Trtpsn_no');
	if(trtPsnNo == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	var trtInsuType=getValueById('trtInsuType');
	if(trtInsuType=="")
	{
		$.messager.alert("温馨提示","险种类型不能为空!", 'info');
		return ;
	}
	var trtMedType=getValueById('trtMedType');
	if(trtMedType=="")
	{
		$.messager.alert("温馨提示","医疗类别不能为空!", 'info');
		return ;
	}
	var trtSDate=getValueById('trtSDate');
	if(trtSDate=="")
	{
		$.messager.alert("温馨提示","开始时间不能为空!", 'info');
		return ;
	}
	
	
	var outPutObj=getTrtInfo();
	if(!outPutObj){return ;}
	if (outPutObj.trtinfo.length==0){$.messager.alert("温馨提示","未查询到对应的记录!", 'info');return ;}
	loadQryGrid("insutrtdg",outPutObj.trtinfo)
	
}

///2001 人员待遇检查信息获取
function getTrtInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('TrtINSUType')+"^"+"2001"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('Trtpsn_no'));
	QryParams=AddQryParam(QryParams,"insutype",getValueById('trtInsuType'));
	QryParams=AddQryParam(QryParams,"fixmedins_code","H44020300006");
	QryParams=AddQryParam(QryParams,"med_type",getValueById('trtMedType'));
	QryParams=AddQryParam(QryParams,"begntime",GetInsuDateFormat(getValueById('trtSDate')));
	QryParams=AddQryParam(QryParams,"endtime",GetInsuDateFormat(getValueById('trtEDate')));
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
function init_iinsutrtdg() {
	var dgColumns = [[
			{field:'psn_no',title:'人员编号',width:160},
			{field:'trt_chk_type',title:'待遇检查类型',width:150,formatter: function(value,row,index){
				var NewValue=""
				var DicType="trt_chk_type"+getValueById('TrtINSUType');
		     	NewValue= GetDicDescByCode(DicType,value);  
		     	return NewValue=="" ? value:NewValue
		     	    
			}},	
			
			{field:'fund_pay_type',title:'基金支付类型',width:150,formatter: function(value,row,index){
				var NewValue=""
				var DicType="fund_pay_type"+getValueById('TrtINSUType');
		     	NewValue= GetDicDescByCode(DicType,value); 
		     	return NewValue=="" ? value:NewValue
			}},
			{field:'trt_enjymnt_flag',title:'基金待遇享受标志',width:150 ,formatter: function(value,row,index){
				return value=="1" ? "享受":"不享受" ;
				}},
			{field:'begndate',title:'开始日期',width:160},
			{field:'enddate',title:'结束日期',width:160 },
			{field:'trt_chk_rslt',title:'待遇检查结果',width:220}
			
		]];

	// 初始化DataGrid
	$('#insutrtdg').datagrid({
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
function init_trtINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('TrtINSUType','DLLType',Options); 	
	$('#TrtINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('TrtINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
			INSULoadDicData('trtInsuType','insutype' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); // 险种类型
	        INSULoadDicData('trtMedType','med_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR});  	// 医疗类别
		
		}
 
	})	;
	
}






