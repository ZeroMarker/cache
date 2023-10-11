/**
 * FileName: dhcinsu.rptdetailinfo.js
 * Anchor: LuJH
 * Date: 2022-07-12
 * Description: 报告明细信息查询-5402
 */
$(function() {
	 init_insufiledg(),
	 init_wdg(),
	 init_edg(),
	 init_fileClick()
	 init_INSUType()
	 var Rq = INSUGetRequest();
	 var psn_no=""
	 var rpotc_no=""
	 var fixmedins_code=""
	 psn_no=Rq["psn_no"];
	 rpotc_no=Rq["rpotc_no"];
	 fixmedins_code=Rq["fixmedins_code"];
	 setValueById('psn_no',psn_no);
	 setValueById('rpotc_no',rpotc_no);
	 setValueById('fixmedins_code',fixmedins_code);
	 if(((psn_no)!=undefined)&((rpotc_no)!="undefined")&((fixmedins_code)!="undefined"))
		{
			fileQry_Click();
			}
	  })
	 

/**
*初始化click事件
*/		
function init_fileClick()
{
	 //查询
	 $("#btnFind").click(fileQry_Click);
	

	 
  
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
*报告明细信息查询-5402
*/	
var fileData=[];
function fileQry_Click(){
	fileData=[];
	var ExpStr=""  
	var psnNo=getValueById('psn_no');
	var rpotcNo=getValueById('rpotc_no');
	var fixmedinsCode=getValueById('fixmedins_code');
	if(psnNo == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	if(rpotcNo == "")
	{
		$.messager.alert("温馨提示","报告单号不能为空!", 'info');
		return ;
	}
	if(fixmedinsCode == "")
	{
		$.messager.alert("温馨提示","机构编号不能为空!", 'info');
		return ;
	}
	fileData=getfileInfo();
	//返回数据没有具体节点
	if(!fileData){return ;}
	if (fileData.length==0){$.messager.alert("温馨提示","未查询到对应的费用明细!", 'info');return ;}
	loadQryGrid("insufiledg",fileData.checkReportDetails);
	}



///报告明细信息查询-5402
function getfileInfo(expStr)
{
	$("#dg").datagrid({data:[]});
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('INSUType')+"^"+"5402"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('psn_no'));
	QryParams=AddQryParam(QryParams,"rpotc_no",getValueById('rpotc_no'));
	QryParams=AddQryParam(QryParams,"fixmedins_code",getValueById('fixmedins_code'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",getValueById('fileInsuplc_admdvs'));
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
*初始化检查报告明细信息表格
*/
function init_insufiledg() {
		if(psn_no!=""){$('#psn_no').html(psn_no);}
		if(rpotc_no!=""){$('#rpotc_no').html(rpotc_no);}
		if(fixmedins_code!=""){$('#fixmedins_code').html(fixmedins_code);}
	
	var columns=[[
			{field:'psn_no',title:'人员编号',width:120},
			{field:'rpotc_no',title:'报告单号',width:120},
			{field:'rpt_date',title:'报告日期',width:120},
			{field:'rpotc_type_code',title:'报告单类',width:120},
			{field:'exam_rpotc_name',title:'检查报告单名称',width:120},
			{field:'exam_rslt_poit_flag',title:'检查结果阳性标志',width:120},
			{field:'exam_rslt_abn',title:'检查异常标志',width:120},
			{field:'exam_ccls',title:'检查结论',width:120},
			{field:'bilgDrName',title:'报告医师',width:120}
	]]
	$("#dg").datagrid({
		fit:true,
		border:false,
		data:[],
		singleSelect:true,
		pagination:true,
		rownumbers:false,
		pageNumbers:1,
		pageSize:20,
		pageList:[20,30,40,50],
		columns:columns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		},
		
		onSelect : function(rowIndex, rowData) {
	        ChangeButtonByPublishStatus();
	        
			Load_wdg_DataGrid();
        },
		})
	}

/*
*初始化检验报告信息表格
*/
function init_wdg() { 
	var wColumns=[[
			{field:'psn_no',title:'人员编号',width:120},
			{field:'rpotc_no',title:'报告单号',width:80},
			{field:'exam_item_code',title:'检验-项目代码',width:100},
			{field:'exam_item_name',title:'检验-项目名称',width:100},
			{field:'rpt_date',title:'报告日期',width:80},
			{field:'rpot_doc',title:'报告医师',width:80}
	
	]]
	$("#wdg").datagrid({
		fit:true,
		border:false,
		data:[],
		toolbar: [],
		singleSelect:true,
		pagination:true,
		rownumbers:false,
		columns:wColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		},
		onSelect : function(rowIndex, rowData) {
	        ChangeButtonByPublishStatus();
			Load_edg_DataGrid();
        }
		})
}

function Load_dg_DataGrid(){
	INSUMIClearGrid('wdg');
	INSUMIClearGrid('edg');
	}

function Load_wdg_DataGrid(){
	INSUMIClearGrid('edg');
	var dgSelect = $('#dg').datagrid('getSelected');
	if(!dgSelect){
		$.messager.alert('提示', '请先选择报告','error');
        return ;	
	}
	if(dgSelect.ROWID==""){
		return;
	}
	fileData=getfileInfo();
	//var data=[dgSelect];
	$("#wdg").datagrid('loadData',fileData.inspectionReportInformation);

	
}

/*
*初始化检验明细信息表格
*/
function init_edg() { 
	var eColumns=[[
			{field:'rpotc_no',title:'报告单号',width:80},
			{field:'exam_mtd',title:'检验方法',width:80},
			{field:'ref_val',title:'参考值',width:80},
			{field:'exam_unt',title:'检验-计量单位',width:100},
			{field:'exam_rslt_val',title:'检验-结果(数值)',width:120},
			{field:'exam_rslt_qual',title:'检验 - 结果(定性)',width:120},
			{field:'exam_item_detl_code',title:'检验 - 项目明细代码',width:150},
			{field:'exam_item_detl_name',title:'检验 - 项目明细名称',width:150},
			{field:'exam_rslt_qual',title:'检验 - 结果(定性)',width:150},
			{field:'exam_rslt_abn',title:'检查 / 检验结果异常标识',width:180}
			
	
	]]
	$("#edg").datagrid({
		fit:true,
		border:false,
		data:[],
		toolbar: [],
		singleSelect:true,
		pagination:true,
		rownumbers:false,
		columns:eColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
		})
}


function Load_edg_DataGrid(){
	var wdgSelect = $('#wdg').datagrid('getSelected');
	if(!wdgSelect){
		$.messager.alert('提示', '请先选择报告','error');
        return ;	
	}
	if(wdgSelect.ROWID==""){
		return;
	}
	fileData=getfileInfo();
	//var data=[wdgSelect];
	$("#edg").datagrid('loadgrid',fileData.inspectionDetails);
}




