/*
 * FileName:	dhcinsu/dhcinsu.insufileinfo.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 费用明细查询-5204
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 	//setValueById('fileINSUType',GV.INSUTYPE);
 	//setValueById('fileINSUTypeDesc',GV.INSUTYPEDESC);
 	//setValueById('fileInsuplc_admdvs',GV.INSUPLCADMDVS);
	//setValueById('regSDate',getDefStDate(0));
	//setValueById('regEDate',getDefStDate(1));	
	//setValueById('filepsn_no',GV.PSNNO);
	// 医保类型
	init_fileINSUType();
	//click事件
	init_fileClick();
	//初始化在院信息查询记录dg	
	init_insufiledg(); 
	
	//add Hanzh 20211125 登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	// 就诊记录
	//initInsuAdmList();
	initAdmList();
	
});

/**
*初始化click事件
*/		
function init_fileClick()
{
	 //查询
	 $("#btnfileQry").click(fileQry_Click);
	 //清屏
	 $("#btnfileClear").click(fileClear_Click);
	 //导出
	 $("#btnfileExport").click(fileExport_Click);
	 $("#tarDesc").keydown(function(e) 
	  { 
	     if (e.keyCode==13)
	        {
	           GetInsufileFilter();
	        }
	   }); 
  
}

/**
*导出
*/
function fileExport_Click(){
	
var Header={
	    mdtrt_id:'就诊ID',
        setl_id:'结算ID',
		det_item_fee_sumamt:'总金额',
		pric:'单价',
		cnt:'数量',
		fulamt_ownpay_amt:'全自费金额',
		preselfpay_amt:'先行自付金额',
		chrgitm_lv:'收费项目等级',
		selfpay_prop:'自付比例',
		lmt_used_flag:'限制使用标志',
		med_chrgitm_type:'医疗收费项目类别',
		hilist_name:'医保目录名称',
	    hilist_code:'医保目录编码',
		med_list_codg:'医疗目录编码',
	    medins_list_codg:'医药机构目录编码',
		medins_list_name:'医药机构目录名称',
		feedetl_sn:'费用明细流水号',
		fee_ocur_time:'费用发生时间',
		inscp_scp_amt:'符合政策范围金额',
	    pric_uplmt_amt:'定价上限金额',
		overlmt_amt:'超限价金额',
		bilg_dept_codg:'开单科室编码',
		bilg_dept_name:'开单科室名称',
		bilg_dr_codg:'开单医生编码',
		bilg_dr_name:'开单医师姓名',
		orders_dr_code:'受单医生编码',
		orders_dr_name:'受单医生姓名',
		acord_dept_codg:'接收科室编码',
		acord_dept_name:'接收科室名称',
		hosp_appr_flag:'医院审批标志',
		chld_medc_flag:'儿童用药标志',
	     bas_medn_flag:'基本药物标志',
		dscg_tkdrug_flag:'出院带药标志',
		list_type:'目录类别',
		rx_drord_no:'处方/医嘱号',
		hi_nego_drug_flag:'医保谈判药品标志',
		dosform_name:'剂型名称',
		prodname:'未知',
		prd_days:'周期天数',
		etip_hosp_code:'外检医院编码',
		opter_name:'经办人姓名',
		etip_flag:'外检标志',
		opt_time:'经办时间',
		used_frqu_dscr:'使用频次描述',
		spec:'规格',
		sin_dos_dscr:'单次剂量描述',
		tcmdrug_used_way:'中药使用方式',
		prodplac_type:'生产地类别',
		list_sp_item_flag:'目录特项标志',
		matn_fee_flag:'生育费用标志',
		drt_reim_flag:'直报标志',
		hosp_prep_flag:'医院制剂标志',
		medc_way_dscr:'用药途径描述',
		memo:'备注',
		opter_id:'经办人ID',
		psn_name:'人员姓名'
		}
    //var data=[{"title":"宋江","url":"梁山","createTime":"1655"},{"title":"美猴王","url":"花果山","createTime":"1000"},{"title":"猪八戒","url":"高老庄","createTime":"1000"}]
	var ExcelTool=new INSUExcelTool();
	var rtn=ExcelTool.ExcelExportOfArrData(fileData,Header,"5204明细导出");

	}

/**
*清屏
*/
function fileClear_Click(){
	 $("#fileInfo").form("clear");
	 $("#insufiledg").datagrid({data:[]});
	}
	
/**
*费用明细查询-5204
*/	
var fileData=[];
function fileQry_Click()
{
	fileData=[];
	var ExpStr=""  
	var filepsnno=getValueById('filepsn_no');
	if(filepsnno == "")
	{
		$.messager.alert("温馨提示","人员编号不能为空!", 'info');
		return ;
	}
	/*var filesetlid=getValueById('filesetl_id');
	if(filesetlid=="")
	{
		$.messager.alert("温馨提示","结算ID不能为空!", 'info');
		return ;
	}*/
	var filemdtrtid=getValueById('filemdtrt_id');
	if(filemdtrtid=="")
	{
		$.messager.alert("温馨提示","就诊ID不能为空!", 'info');
		return ;
	}
	fileData=getfileInfo();
	//返回数据没有具体节点
	if(!fileData){return ;}
	if (fileData.length==0){$.messager.alert("温馨提示","未查询到对应的费用明细!", 'info');return ;}
	loadQryGrid("insufiledg",fileData);
}




///费用明细查询-5204
function getfileInfo()
{
	$("#insufiledg").datagrid({data:[]});
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('fileINSUType')+"^"+"5204"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('filepsn_no'));
	QryParams=AddQryParam(QryParams,"setl_id",getValueById('filesetl_id'));
	QryParams=AddQryParam(QryParams,"mdtrt_id",getValueById('filemdtrt_id'));
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
 * 过滤查找数据
 */
function GetInsufileFilter()
{
	if (fileData.length==0){
		$.messager.popover({msg:'请先查询数据!',type:'info'});
		return ;
	}
	var newData=fileData;
	if (getValueById("tarDesc")!=""){
	    newData = fileData.filter(function(item,index,array){
		       return item.medins_list_name.indexOf(getValueById("tarDesc"))>=0;
		   })
	}
	$("#insufiledg").datagrid({data:[]});
	loadQryGrid("insufiledg",newData);

}

/*
 * datagrid
 */
function init_insufiledg() {
	var dgColumns = [[
		    {field:'mdtrt_id',title:'就诊ID',width:120},
		    {field:'setl_id',title:'结算ID',width:120},
			{field:'med_type',title:'医疗类别',width:120,formatter: function(value,row,index){
				var DicType="med_type"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'det_item_fee_sumamt',title:'总金额',width:120,align:'right'},
			{field:'pric',title:'单价',width:100,align:'right'},
			{field:'cnt',title:'数量',width:100},
			{field:'fulamt_ownpay_amt',title:'全自费金额',width:120,align:'right'},
			{field:'preselfpay_amt',title:'先行自付金额',width:130,align:'right'},
			{field:'chrgitm_lv',title:'收费项目等级',width:130,formatter: function(value,row,index){
				var DicType="chrgitm_lv"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'selfpay_prop',title:'自付比例',width:130},
			{field:'lmt_used_flag',title:'限制使用标志',width:120,formatter: function(value,row,index){
				var DicType="lmt_used_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'med_chrgitm_type',title:'医疗收费项目类别',width:150,formatter: function(value,row,index){
				var DicType="med_chrgitm_type"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hilist_name',title:'医保目录名称',width:150},
			{field:'hilist_code',title:'医保目录编码',width:150},
			{field:'med_list_codg',title:'医疗目录编码',width:150},
			{field:'medins_list_codg',title:'医药机构目录编码',width:150},
			{field:'medins_list_name',title:'医药机构目录名称',width:150},
			{field:'feedetl_sn',title:'费用明细流水号',width:150},
			{field:'fee_ocur_time',title:'费用发生时间',width:160},
			{field:'inscp_scp_amt',title:'符合政策范围金额',width:150,align:'right'},
			{field:'pric_uplmt_amt',title:'定价上限金额',width:150,align:'right'},
			{field:'overlmt_amt',title:'超限价金额',width:150,align:'right'},
			{field:'bilg_dept_codg',title:'开单科室编码',width:150},
			{field:'bilg_dept_name',title:'开单科室名称',width:150},
			{field:'bilg_dr_codg',title:'开单医生编码',width:150},
			{field:'bilg_dr_name',title:'开单医师姓名',width:150},
			{field:'orders_dr_code',title:'受单医生编码',width:150},
			{field:'orders_dr_name',title:'受单医生姓名',width:150},
			{field:'acord_dept_codg',title:'接收科室编码',width:150},
			{field:'acord_dept_name',title:'接收科室名称',width:150},
			{field:'hosp_appr_flag',title:'医院审批标志',width:150,formatter: function(value,row,index){
				var DicType="hosp_appr_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'chld_medc_flag',title:'儿童用药标志 ',width:150,formatter: function(value,row,index){
				var DicType="chld_medc_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'bas_medn_flag',title:'基本药物标志',width:150,formatter: function(value,row,index){
				var DicType="bas_medn_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'dscg_tkdrug_flag',title:'出院带药标志',width:150,formatter: function(value,row,index){
				var DicType="dscg_tkdrug_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'list_type',title:'目录类别',width:150,formatter: function(value,row,index){
				var DicType="list_type"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'rx_drord_no',title:'处方/医嘱号',width:150},
			{field:'hi_nego_drug_flag',title:'医保谈判药品标志',width:150,formatter: function(value,row,index){
				return value=="1" ? "是":"否" ;     
			}},
			{field:'dosform_name',title:'剂型名称',width:150},
			{field:'prodname',title:'商品名',width:150},
			{field:'prd_days',title:'周期天数',width:150},
			{field:'etip_hosp_code',title:'外检医院编码',width:150},
			{field:'payLoc',title:'支付地点类别',width:150,formatter: function(value,row,index){
				var DicType="pay_loc"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'opter_name',title:'经办人姓名',width:150},
			{field:'etip_flag',title:'外检标志',width:150,formatter: function(value,row,index){
				var DicType="etip_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'opt_time',title:'经办时间',width:150},
			{field:'used_frqu_dscr',title:'使用频次描述',width:150},
			{field:'spec',title:'规格',width:150},
			{field:'sin_dos_dscr',title:'单次剂量描述',width:150},
			{field:'tcmdrug_used_way',title:'中药使用方式',width:150},
			{field:'prodplac_type',title:'生产地类别',width:150,formatter: function(value,row,index){
				var DicType="prodplac_type"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'list_sp_item_flag',title:'目录特项标志',width:150,formatter: function(value,row,index){
				var DicType="list_sp_item_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'matn_fee_flag',title:'生育费用标志',width:150,formatter: function(value,row,index){
				var DicType="matn_fee_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'drt_reim_flag',title:'直报标志',width:150,formatter: function(value,row,index){
				var DicType="drt_reim_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hosp_prep_flag',title:'医院制剂标志',width:150,formatter: function(value,row,index){
				var DicType="hosp_prep_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'medc_way_dscr',title:'用药途径描述',width:150},
			{field:'memo',title:'备注',width:150},
			{field:'opter_id',title:'经办人ID',width:150},
			{field:'psn_name',title:'人员姓名',width:150},
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
		}
	});
}

/**
* add 20211125 Hanzh
* 登记号回车事件
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}
function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
				return;
			}
			var admStr = "";
			loadInsuAdmList(papmi);
		});
	}
}
/**
* add 20211125 Hanzh
* 初始化医保就诊记录
*/
function initAdmList() {
	$HUI.combogrid("#InsuAdmList", {
		panelWidth: 560,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		method: 'GET',
		idField: 'inadmId',
		textField: 'admStatus',
		columns: [[{field: 'inadmId', title: "就诊ID", width: 120},
					{field: 'admStatus', title: '就诊类型', width: 80},
					{field: 'admDate', title: '就诊日期', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
					}
					},
					{field: 'mdtrtId', title: '医保就诊ID', width: 100},
					{field: 'admdvs', title: '参保地区', width: 80},
					{field: 'psnNo', title: '医保号', width: 120},
					{field: 'regNo', title: '登记号', width: 80,hidden:true}
					
			]],
		onLoadSuccess: function (data) {
			    var admIndexEd=data.total;
                if (admIndexEd>0)
                {
	                var admdg = $('#InsuAdmList').combogrid('grid');	
                    admdg.datagrid('selectRow',0);
	              }
		},
		onLoadError:function(e){
		},
		onSelect: function (index, row) { 
			setValueById("patientNo",row.regNo)         		//登记号
			setValueById("filemdtrt_id", row.mdtrtId);         	//就诊ID 
			setValueById("filepsn_no", row.psnNo);              //医保号
            setValueById("fileInsuplc_admdvs",row.admdvs)       //参保地区       
		}
	});
}
// 加载医保就诊列表 add 20211125 Hanzh
function loadInsuAdmList(myPapmiId) {
	$('#InsuAdmList').combobox('clear');
	
	var queryParams = {
		ClassName: "DHCINSU.ServQry.Manager",
		QueryName: "FindInsuAdmList",
		type: "GET",
		papmi: myPapmiId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		HisType:""
	}
	loadComboGridStore("InsuAdmList", queryParams);
}



/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */
function init_fileINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('fileINSUType','DLLType',Options); 	
	$('#fileINSUType').combobox({
		onSelect:function(rec){
			//init_PsnCertType();
			GV.INSUTYPE=getValueById('fileINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		},
 
	})	;
	
}