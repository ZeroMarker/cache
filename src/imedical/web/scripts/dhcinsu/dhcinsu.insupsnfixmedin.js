/*
 * FileName:	dhcinsu.insupsnfixmedin.js
 * User:		DingSH
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 人员定点信息查询
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 	//setValueById('fixINSUType',GV.INSUTYPE);
 	//setValueById('fixINSUTypeDesc',GV.INSUTYPEDESC);
    //setValueById('fixbizappytype',getDefStDate(0));
	//setValueById('fixpsn_no',GV.PSNNO);
	INSULoadDicData('fixbizappytype','biz_appy_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR});
	// 医保类型
	init_fixINSUType();
	//click事件
	init_fixClick();
	//初始化人员定点记录dg	
	init_insufixmeddg(); 
	
});

/**
*初始化click事件
*/		
function init_fixClick()
{
	 //查询
	 $("#btnFixQry").click(FixQry_Click);
  
}
	
/**
*查询人员定点信息
*/	
function FixQry_Click()
{
	var ExpStr=""  
	var trtPsnNo=getValueById('fixpsn_no');
	if(trtPsnNo == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	var fixbizappytype=getValueById('fixbizappytype');
	if(fixbizappytype=="")
	{
		$.messager.alert("温馨提示","业务申请类型不能为空!", 'info');
		return ;
	}
	var outPutObj=getFixInfo();
	if(!outPutObj){return ;}
	if (outPutObj.psnfixmedin.length==0){$.messager.alert("温馨提示","未查询到对应的记录!", 'info');return ;}
	loadQryGrid("insufixmeddg",outPutObj.psnfixmedin);
}

///【5302】人员定点信息查询
function getFixInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('fixINSUType')+"^"+"5302"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('fixpsn_no'));
	QryParams=AddQryParam(QryParams,"biz_appy_type",getValueById('fixbizappytype'));
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
function init_insufixmeddg() {
	var dgColumns = [[
			{field:'psn_no',title:'人员编号',width:180},
			{field:'insutype',title:'险种类型',width:150,formatter: function(value,row,index){
				var NewValue=""
				var DicType="insutype"+getValueById('fixINSUType');
		     	NewValue= GetDicDescByCode(DicType,value); 
		     	return NewValue=="" ? value:NewValue
			}},	
			{field:'fix_srt_no',title:'定点排序号',width:100},
			{field:'fixmedins_code',title:'点医药机构编号',width:180},
			{field:'fixmedins_name',title:'定点医药机构名称',width:240},
			{field:'begndate',title:'开始日期',width:140 },
			{field:'enddate',title:'结束日期',width:140},
			{field:'memo',title:'备注',width:200}
		]];

	// 初始化DataGrid
	$('#insufixmeddg').datagrid({
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
*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */function init_fixINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('fixINSUType','DLLType',Options); 	
	$('#fixINSUType').combobox({
		onSelect:function(rec){
			INSULoadDicData('fixbizappytype','biz_appy_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR});
			GV.INSUTYPE=getValueById('fixINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
	})	;
	
}





