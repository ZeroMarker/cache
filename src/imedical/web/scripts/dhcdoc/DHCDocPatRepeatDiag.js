var PageLogicObj={
	m_PatAllDiagTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//表格数据初始化
	LoadPatRepeatDiagTabDataGrid();
});
function Init(){
	InitdiagCatkw();
	PageLogicObj.m_PatRepeatDiagTabDataGrid=InitPatRepeatDiagTabDataGrid();
	InitPageItemEvent();
}
function InitPageItemEvent(){
	$("#BFind").click(LoadPatRepeatDiagTabDataGrid);
	$HUI.radio(".hisui-radio",{
        onChecked:function(e,value){
            LoadPatRepeatDiagTabDataGrid();
        }
    });
}
function InitSearchType(){
	$HUI.combobox("#searchType", {
		width:120,
		valueField: 'id',
		textField: 'text',
		editable:false,
		data: [
			{"id":"ALL","text":$g("全部"),"selected":true},
			{"id":"DiagDesc","text":$g("诊断描述")},
			{"id":"DiagType","text":$g("诊断类型")},
			{"id":"DiagLoc","text":$g("下诊断科室")}
		],
		onSelect:function(record){
			$("#searchDesc").val("").focus();
		}
	})
}
function InitdiagCatkw(){
	$("#diagCatkw").keywords({
	    singleSelect:false,
	    labelCls:'red',
	    items:[
	        {text:$g('西医'),id:0,selected:true},
	        {text:$g('中医'),id:1,selected:true}
	    ],
	    onUnselect:function(v){LoadPatRepeatDiagTabDataGrid();},
	    onSelect:function(v){LoadPatRepeatDiagTabDataGrid();}
	})
}
function InitPatRepeatDiagTabDataGrid(){
	/*
	MRDIARowId,PAAdmRowId,PAAdmType,MRDIAMainDiagFlag,
	DiagStat,MRDiagDate,SSUseName,CTCPTType,DiagLoc,PAAdmDate,PAAdmLoc,PAAdmHosp
	*/
	var Columns=[[ 
		{field:'PAAdmDate',title:'就诊日期',width:95},
		{field:'PAAdmLoc',title:'就诊科室',width:100},
		{field:'PAAdmType',title:'就诊类型',width:70},
		{field:'MRDiagDate',title:'诊断日期',width:95},
		{field:'DiagStat',title:'诊断状态',width:70},
		{field:'MRDIAMainDiagFlag',title:'主诊断',width:60},
		{field:'SSUseName',title:'诊断人',width:90},
		{field:'CTCPTType',title:'诊断人类型',width:90},
		{field:'DiagLoc',title:'诊断科室',width:100},
		{field:'Ord',title:'医嘱',width:70,align:'center',
			formatter: function(value,row,index){
				if (row["Ord"]!="") {
					var btn = '<a class="editcls" onclick="BAdmOrdInfo(\'' + row["Ord"] + '\')"><img src="../images/websys/update.gif"></a>';
					return btn;
				}
			}
		},
		{field:'HasEMRRecord',title:'病历',width:70,align:'center',
			formatter: function(value,row,index){
				if (row["HasEMRRecord"]=="1") {
					var btn = '<a class="editcls" onclick="BAdmEMRInfo(\'' + row["PAAdmRowId"] + '\')">病历记录</a>';
					return btn;
				}else{
					return "无";
				}
			}
		},
		{field:'PAAdmHosp',title:'就诊医院',width:200},
    ]]
	var PatRepeatDiagTabDataGrid=$("#PatRepeatDiagTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'MRDIARowId',
		columns :Columns,
		onCheck:function(index, row){
		}
	});
	return PatRepeatDiagTabDataGrid;
}
function LoadPatRepeatDiagTabDataGrid(){
	var AdmTypeStr=$("input[name='AdmType']:checked")[0].value;
	var kwSel=$("#diagCatkw").keywords("getSelected");
	var diagCat="";
	for (var i=0;i<kwSel.length;i++) {
		if (diagCat==="") diagCat=kwSel[i].id;
		else diagCat=diagCat+"^"+kwSel[i].id;
	}
	$.q({
	    ClassName : "web.DHCDocPatAllDiagnos",
	    QueryName : "GetPatRepeatDiag",
	    PatientID:ServerObj.PatientID,
	    diagCat:diagCat,
	    AdmTypeStr:AdmTypeStr,
	    paraGroupICDRowIDStr:ServerObj.GroupICDRowIDStr,
	    Pagerows:PageLogicObj.m_PatRepeatDiagTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_PatRepeatDiagTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function BAdmOrdInfo(Ord){
	var $code='<div style="border:1px solid #ccc;margin:10px;border-radius:4px;"><table id="OrderListGrid"></table></div>'
	createModalDialog("Grid","医嘱明细", 1100, 520,"icon-w-list","",$code,"LoadOrderListGrid('"+Ord+"')");
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    },
	    onBeforeOpen:function(){
		    if (_event!="") eval(_event);
		    return true;
		}
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function LoadOrderListGrid(Ord){
	var Columns=[[    
		{field:'ID',title:'',hidden:true,width:50},
		{field:'OrderName',title:'医嘱名称',width:280,}, 
		{field:'GenDrugDetails',title:'通用名',width:200},
		//{field:'ARCOSItemUOM',title:'药品浓度',width:80},
		{field:'DrugForm',title:'药品剂型',width:70},
		{field:'Frequency',title:'频次',width:80},
		{field:'Instruction',title:'用法',width:50},  
		{field:'Duration',title:'疗程',width:60},   
		{field:'StartDate',title:'开始日期',width:100},
		{field:'StartTime',title:'开始时间',width:100},
		{field:'Priority',title:'优先级',width:100},
		{field:'PrescriptionNo',title:'处方号',width:120},
		{field:'Quantity',title:'执行数量',width:100},
		{field:'OrderDoc',title:'审核医生',width:80},
		{field:'Status',title:'状态',width:80},
		/*{field:'Paid',title:'账单状态',width:80,
			formatter: function(value,row,index){
				if (value=="TB"){
					return "未发";
				}
				if (value=="P"){
					return "已发";
				}
			}
		},*/
		{field:'LUUser',title:'最后更新用户',width:80}
    ]];
    $HUI.datagrid('#OrderListGrid',{
	    idField:'ID',
	    fit : false,
	    width:1070,
	    height:460,
	    border: false,
	    columns:Columns,
	    pagination:true,
	    pageSize:20,
	    pageList:[20,30,40,100],
	    onLoadSuccess:function(data){
			if (data.rows.length>0){
				StartFormatDate(0);
			}
			function StartFormatDate(StartRow) {
				function formateDate(RowIndex) {
					if (RowIndex<data.rows.length) {
						if (data.rows[RowIndex].StartDate!=""){
							$.cm({
								ClassName:"websys.Conversions",
								MethodName:"DateLogicalToHtml",
							    h:data.rows[RowIndex].StartDate,
								dataType:"text"
							},function(data){
								$('#OrderListGrid').datagrid('updateRow',{
									index: RowIndex,
									row: {
										StartDate:data
									}
								});
							});
						}
						if (data.rows[RowIndex].StartDate!=""){
							$.cm({
								ClassName:"websys.Conversions",
								MethodName:"TimeLogicalToHtml",
							    h:data.rows[RowIndex].StartTime,
								dataType:"text"
							},function(data){
								$('#OrderListGrid').datagrid('updateRow',{
									index: RowIndex,
									row: {
										StartTime:data
									}
								});
							});
						}
						setTimeout(function () {
							formateDate(RowIndex+1)
						}, 0);
					}
				}
				setTimeout(function () {
					formateDate(StartRow);
				}, 0);
			}
		}
	});
	$.q({
	    ClassName:"web.EPVisitNumber",
	    QueryName:"ProfileList",
	    TSRTITM:"", TSRTORD:"", par:Ord, dfrom:"", dto:"", categ:"", stat:"", result:"", vis:"", dsfrom:"", dsto:"", cptype:"",
	    hospitallist:"", EpisodeAll:0, OrderSubcategories:"", ExcludeCurrentEpisode:0,
	    Pagerows:$("#OrderListGrid").datagrid("options").pageSize,rows:99999,
	},function(GridData){
		$("#OrderListGrid").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function BAdmEMRInfo(EpisodeID){
	websys_showModal({
			url:"emr.browse.csp?EpisodeID=" + EpisodeID,
			title:"病历记录",
			width:'93%',height:'93%'
	 });
}
