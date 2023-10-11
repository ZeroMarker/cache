/*
 * FileName:	dhcinsu.insureginfo.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 在院信息查询-5303
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 	//setValueById('regINSUType',GV.INSUTYPE);
 	//setValueById('regINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('regSDate',getDefStDate(0));
	//setValueById('regEDate',getDefStDate(1));	
	InsuDateDefault('regSDate');	
	InsuDateDefault('regEDate',+1);	
	//setValueById('regpsn_no',GV.PSNNO);
	// 医保类型
	init_regINSUType();
	//click事件
	init_regClick();
	//初始化在院信息查询记录dg	
	init_insuregdg(); 
	
});


/**
*初始化click事件
*/		
function init_regClick()
{
	 //查询
	 $("#btnRegQry").click(RegQry_Click);
  
}
	
/**
*在院信息查询
*/	
function RegQry_Click()
{
	var ExpStr=""  
	var regpsnno=getValueById('regpsn_no');
	if(regpsnno == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	var mtSDate=getValueById('regSDate');
	if(mtSDate=="")
	{
		$.messager.alert("温馨提示","开始时间不能为空!", 'info');
		return ;
	}
	
	var outPutObj=getRegInfo();
	
	if(!outPutObj){return ;}
	if (outPutObj.data.length==0){$.messager.alert("温馨提示","未查询到对应的在院记录!", 'info');return ;}
	loadQryGrid("insuregdg",outPutObj.data);
}

///在院信息查询-5303
function getRegInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('regINSUType')+"^"+"5303"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('regpsn_no'));
	QryParams=AddQryParam(QryParams,"begntime",GetInsuDateFormat(getValueById('regSDate')));
	QryParams=AddQryParam(QryParams,"endtime",GetInsuDateFormat(getValueById('regEDate')));
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
function init_insuregdg() {
	var dgColumns = [[
			{field:'mdtrt_id',title:'就诊ID',width:120},
			{field:'psn_no',title:'人员编号',width:180},	
			{field:'psn_cert_type',title:'人员证件类型',width:150,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('regINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'certno',title:'证件号码',width:180},
			{field:'psn_name',title:'人员姓名',width:100},
			{field:'gend',title:'性别',width:100,formatter: function(value,row,index){
				var DicType="gend"+getValueById('regINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'brdy',title:'出生日期',width:100},
			{field:'age',title:'年龄',width:80},
			{field:'insutype',title:'险种类型',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('regINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'begndate',title:'开始日期',width:100},
			{field:'med_type',title:'医疗类别',width:100,formatter: function(value,row,index){
				var DicType="med_type"+getValueById('regINSUType');
		     	return GetDicDescByCode(DicType,value);     
			}},	
			{field:'ipt_otp_no',title:'住院/门诊号',width:100},
			{field:'out_flag',title:'异地标志',width:100}
		]];

	// 初始化DataGrid
	$('#insuregdg').datagrid({
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
function init_regINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('regINSUType','DLLType',Options); 	
	$('#regINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('regINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
 
	})	;
	
}




