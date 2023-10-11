/*
 * FileName:	dhcinsu.medstff.js
 * Creator:		HanZH
 * Date:		2022-05-25
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 医执人员信息查询-5102
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
	// 医保类型
	init_medINSUType();
	//click事件
	init_regClick();
	//初始化人员证件类型
	init_psnCertType(); 
	//初始化执业人员分类
	init_pracPsnType()
	//医执人员信息查询记录dg	
	init_medstffdg();
	
});

/**
*初始化click事件
*/		
function init_regClick()
{
	 //查询
	 $("#btnMedQry").click(MedQry_Click);
}
	
/**
*医执人员信息查询
*/	
function MedQry_Click()
{
	var ExpStr=""  
	var pracPsnType=getValueById('pracPsnType');
	if(pracPsnType=="")
	{
		$.messager.alert("温馨提示","执业人员分类不能为空!", 'info');
		return ;
	}
	var SaveFlag="0"
    if (getValueById('SaveFlag')){ SaveFlag="1" }
    
	var outPutObj=getMedStffInfo();
	if(!outPutObj){return ;}
	if (outPutObj.feedetail.length==0){$.messager.alert("温馨提示","未查询医执人员信息记录!", 'info');return ;}
	loadQryGrid("medstffdg",outPutObj.feedetail);
}

///医执人员信息查询-5102
function getMedStffInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('medINSUType')+"^"+"5102"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"prac_psn_type",getValueById('pracPsnType'));	
	QryParams=AddQryParam(QryParams,"psn_cert_type",getValueById('psn_cert_type'));
	QryParams=AddQryParam(QryParams,"certno",getValueById('certno'));
	QryParams=AddQryParam(QryParams,"prac_psn_name",getValueById('pracPsnName'));
	QryParams=AddQryParam(QryParams,"prac_psn_code",getValueById('pracPsnCod'));
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
function init_medstffdg() {
	var dgColumns = [[
			{field:'psn_cert_type',title:'人员证件类型',width:180,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('medINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'certno',title:'证件号码',width:160},
			{field:'prac_psn_no',title:'执业人员自编号',width:320},	
			{field:'prac_psn_code',title:'执业人员代码',width:160},
			{field:'prac_psn_name',title:'执业人员姓名',width:120},
			{field:'prac_psn_type',title:'执业人员分类',width:180,formatter: function(value,row,index){
				var DicType="medins_psn_type"+getValueById('medINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'prac_psn_cert',title:'执业人员资格证书编码',width:160},
			{field:'prac_cert_no',title:'执业证书编号',width:120},
			{field:'hi_dr_flag',title:'医保医师标志',width:120},
			{field:'begntime',title:'开始时间',width:120},
			{field:'endtime',title:'结束时间',width:120},
			{field:'chg_rea',title:'变更原因',width:120}
		]];

	// 初始化DataGrid
	$('#medstffdg').datagrid({
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
function init_medINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('medINSUType','DLLType',Options); 	
	$('#medINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('medINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
			INSULoadDicData('psnCertType','psn_cert_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); // 人员证件类型
			INSULoadDicData('pracPsnType','medins_psn_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); // 执业人员分类
		}
 
	})	;
	
}

/*
 * 人员证件类型
 */
function init_psnCertType(){
	$HUI.combobox(('#psnCertType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('medINSUType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}
/*
 * 执业人员分类
 */
function init_pracPsnType(){
	$HUI.combobox(('#pracPsnType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'medins_psn_type' + getValueById('medINSUType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}


