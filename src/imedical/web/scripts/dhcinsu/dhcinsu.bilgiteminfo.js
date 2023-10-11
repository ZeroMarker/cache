
  //FileName dhcinsu.bilgiteminfo.js
//  Anchor LuJH
//  Date 2022-07-12
//  Description 项目互认信息查询-5401
 
$(function () { 
 	init_INSUType();
	//click事件
	init_fileClick();
	//初始化在院信息查询记录dg	
	init_insufiledg(); 
	
	//登记号回车查询事件
	$('#patientNo').keydown(function (e) {
		patientNoKeydown(e);
	});
	
	
});


//清屏

function fileClear_Click(){
	 $('#fileInfo').form(clear);
	 $('#insufiledg').datagrid({data:[]});
	}

//初始化click事件
		
function init_fileClick()
{
	 //查询
	 $('#btnfileQry').click(fileQry_Click);
	 //清屏
	 $('#btnfileClear').click(fileClear_Click);
	 
  
}


 //登记号回车事件

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo=$('#patientNo').val();
		if (patientNo!='') {
			if (patientNo.length10) {
				for (var i=(10-patientNo.length-1); i=0; i--) {
					patientNo=0+patientNo;
				}
			}
		}
		$('#patientNo').val(patientNo);
		getPatInfo();
	}
}


//根据登记号查找人员编号

function getPatInfo() {
		var patientNo = getValueById(patientNo);
		if (patientNo) {
			var expStr ="" ;
			$.m({
				ClassName: DHCINSU.ServQry.Manager,
				MethodName: GetInsuIdByPapmiNo,
				papmiNo :patientNo,
				
			}, function(data) {
				
				$('#psn_no').val(data);
				
				
			});
		}
	}

 // 医保类型 和医保类型有关的 下拉框需要在这重新加载
 
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



//项目互认信息查询-5401
	
var fileData=[];
function fileQry_Click(){
	fileData=[];
	var ExpStr= ""
	var psnNo=getValueById('psn_no');
	if(psnNo == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	fileData=getfileInfo();
	//返回数据没有具体节点
	if(!fileData){return ;}
	if (fileData.length==0){$.messager.alert('温馨提示,未查询到对应的费用明细!', 'info');return ;}
	loadQryGrid(insufiledg,fileData);
	}



//项目互认信息查询-5401
function getfileInfo()
{
	$('#insufiledg').datagrid({data:[]});
	//数据库连接串
	var connURL=""
	//ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN
	var ExpStr=getValueById('INSUType')+"^"+5401+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,psn_no,getValueById('psn_no'));
	QryParams=AddQryParam(QryParams,"exam_org_code",getValueById('filesetl_id'));
	QryParams=AddQryParam(QryParams,"exam_org_name",getValueById('exam_org_name'));
	QryParams=AddQryParam(QryParams,"exam_item_code",getValueById('exam_item_code'));
	QryParams=AddQryParam(QryParams,"exam_item_name",getValueById('exam_item_name'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",getValueById('fileInsuplc_admdvs'));
	ExpStr=ExpStr+"^"+QryParams
	var rtn=InsuServQry(0,GV.USERID,ExpStr); 
	if (!rtn){return ;}
	if (rtn.split("^")[0]!=0) 
	 {
		$.messager.alert("提示,查询失败!rtn="+rtn, 'error');
		return ;
	}
	var outPutObj=JSON.parse(rtn.split("^")[1]);
	return outPutObj;
}


//初始化表格

function init_insufiledg() {
	var dgColumns = [[
		    {field:'psn_no',title:'人员编号',width:100},
		    {field:'rpotc_no',title:'报告单号',width:100},
			{field:'rpt_date',title:'报告日期',width:100 },
			{field:'rpotc_type_code',title:'报告单类别代码',width:120},
			{field:'fixmedins_code',title:'机构编号',width:100},
			{field:'exam_rpotc_name',title:'检查报告单名称',width:120},
			
			{field:'exam_rslt_poit_flag',title:'检查结果阳性标志',width:130},
			{field:'exam_rslt_abn',title:'检查检验结果异常标志',width:160},
			{field:'examCcls',title:'检查结论',width:100},
			
		]];
	var psn_no=getValueById('psn_no');
	var rpotc_no=getValueById('rpotc_no');
	var fixmedins_code=getValueById('fixmedins_code');
	 //初始化DataGrid
	$('#insufiledg').datagrid({
	
		fit:true,
		border:false,
		data:[],
		striped: true,
		singleSelect :true,
		pagination: true,
		rownumbers: false, 
        pageNumber:1,        
		pageSize :20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		onDblClickRow :function(index,rowData){
			//FindReportInfo();	
		},
		onSelect  :function(rowIndex, rowData) {
			var psn_no=rowData.psn_no;
			var rpotc_no=rowData.rpotc_no;
			var fixmedins_code=rowData.fixmedins_code;
	      	var url = "dhcinsu.rptdetailinfo.csp?&classname="+""+"&methodname="+"&psn_no="+psn_no+"&rpotc_no="+rpotc_no+"&fixmedins_code="+fixmedins_code; 
	
	websys_showModal({
		url: url,
		title: "报告信息查询",
		iconCls: "icon-w-edit",
		
		
	});
        },
		
	});
	
loadQryGrid('insufiledg',[{psn_no:1,rpotc_no:1,fixmedins_code:1}]);

	
}
