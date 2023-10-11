/*
 * FileName:	dhcinsu.opspbalqury.js
 * Creator:		LuJH
 * Date:		2022-10-21
 * Description: 门慢门特限额剩余额度查询-2597
*/
$(function () { 
 	init_INSUType();
	//click事件
	init_fileClick();
	//初始化在院信息查询记录dg	
	init_insufiledg(); 
	
	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
});

/**
*清屏
*/
function fileClear_Click(){
	 $("#fileInfo").form("clear");
	 $("#insufiledg").datagrid({data:[]});
	}
/**
*初始化click事件
*/		
function init_fileClick()
{
	 //查询
	 $("#btnfileQry").click(fileQry_Click);
	 //清屏
	 $("#btnfileClear").click(fileClear_Click);
	 
  
}

/**
* 登记号回车事件
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo=$("#patientNo").val();
		if (patientNo!='') {
			if (patientNo.length<10) {
				for (var i=(10-patientNo.length-1); i>=0; i--) {
					patientNo="0"+patientNo;
				}
			}
		}
		$("#patientNo").val(patientNo);
		getPatInfo();
	}
}

/*
*根据登记号查找人员编号
*/
function getPatInfo() {
		var patientNo = getValueById("patientNo");
		if (patientNo) {
			var expStr = "";
			$.m({
				ClassName: "DHCINSU.ServQry.Manager",
				MethodName: "GetInsuIdByPapmiNo",
				papmiNo: patientNo,
				
			}, function(data) {
				
				$("#psn_no").val(data);
				
				
			});
		}
	}
/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('INSUType','DLLType',Options); 	
	$('#INSUType').combobox({
		onSelect:function(rec){
			//init_PsnCertType();
			GV.INSUTYPE=getValueById('INSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		},
 
	})	;
	
}


/**
*门慢门特限额剩余额度查询-2597
*/	
var fileData=[];
function fileQry_Click(){
	fileData=[];
	var ExpStr=""  
	var psnno=getValueById('psn_no');
	if(psnno == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	fileData=getfileInfo();
	
	if(!fileData){return ;}
	if (fileData.length==0){$.messager.alert("温馨提示","未查询到对应的费用明细!", 'info');return ;}
	loadQryGrid("insufiledg",fileData);
	}



///门慢门特限额剩余额度查询-2597
function getfileInfo()
{
	$("#insufiledg").datagrid({data:[]});
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('INSUType')+"^"+"2597"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('psn_no'));
	QryParams=AddQryParam(QryParams,"year",getValueById('year'));
	QryParams=AddQryParam(QryParams,"page_num","1");
	QryParams=AddQryParam(QryParams,"page_size","100");
	
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

function init_insufiledg() {
	var dgColumns = [[
		    {field:'code',title:'状态码',width:100},
		    {field:'type',title:'状态类型',width:100},
			{field:'message',title:'提示信息',width:100 },
			{field:'insutype',title:'险种',width:120},
			{field:'year',title:'年度',width:100},
			{field:'psn_no',title:'人员编号',width:120},			
			{field:'cum_type_code',title:'累计代码类型',width:130},
			{field:'cum',title:'限额累计值',width:100},
			{field:'cum_type_name',title:'累计代码类型名称',width:160},
			{field:'total',title:'总限额',width:100},
			{field:'left',title:'剩余限额额度',width:100},
			{field:'qfx',title:'起付线',width:100},
		]];

	// 初始化DataGrid
	$('#insufiledg').datagrid({
	
		fit:true,
		border:false,
		data:[],
		//striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false, 
        pageNumber:1,        
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		},
		onSelect : function(rowIndex, rowData) {
		}
		
	});
	


	
}
