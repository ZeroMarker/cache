var PageLogicObj={
	m_AdmListTabDataGrid:""
}
$(function(){
	//初始化
	Init();
})
function Init(){
	PageLogicObj.m_AdmListTabDataGrid=InitAdmListTabDataGrid();
	AdmListTabDataGridLoad();
}
function InitAdmListTabDataGrid(){
	var Columns=[[ 
		{field:'EpisodeID',hidden:true,align:'center'},
		{field:'PatientID',hidden:true,title:''},
		{field:'mradm',hidden:true,title:''},
		{field:'PAPMINO',title:'登记号',width:100},
		{field:'PAPMIName',title:'姓名',width:80},
		{field:'PAPMIDOB',title:'出生日期',width:100},
		{field:'PAPMISex',title:'性别',width:70},
		{field:'PAAdmReason',title:'患者类型',width:70},
		{field:'PAAdmDate',title:'就诊日期',width:100,order:'asc'},
		{field:'PAAdmTime',title:'就诊时间',width:110},
		{field:'IconProfile',title:'图标菜单',width:110},
		{field:'Ord',title:'医嘱',width:70,align:'center',
			formatter: function(value,row,index){
				if (HISUIStyleCode=="blue"){
					var btn = '<span class="icon-write-order" style="padding-left: 20px;" onclick="BAdmOrdInfo(\'' + row["Ord"] + '\')"></span>';
					return btn;
				}else{
					var btn = '<span class="icon-write-order" onclick="BAdmOrdInfo(\'' + row["Ord"] + '\')"></span>';
					return btn;
				}
			}
		},
		{field:'PAAdmDepCodeDR',title:'就诊科室',width:120},
		{field:'PAAdmDocCodeDR',title:'医生',width:110},
		{field:'PAAdmNo',title:'就诊号',width:120},
		{field:'PAAdmType',title:'就诊类型',width:80}, 
		{field:'PAAdmStatus',title:'患者状态',width:80},
		{field:'Hospital',title:'医院',width:190}, 
		{field:'PAAdmWard',title:'病房',width:130}, 
		{field:'PAAdmBed',title:'床位号',width:70},
        {field:'DischargeDate',title:'出院日期',width:100},
		{field:'Diagnosis',title:'诊断',width:120},
		{field:'TPoliticalLevel',title:'患者级别',width:80},
		{field:'TSecretLevel',title:'患者密级',width:100,align:'center'}
    ]]
	var AdmListTabDataGrid=$("#AdmListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'EpisodeID',
		columns :Columns,
		onDblClickRow:function(index, row){
			var AdmLocDr=row["TAdmLocDr"];
			if (AdmLocDr==session['LOGON.CTLOCID']){
				if (row["EpisodeID"]){
					$.messager.confirm('确认对话框', '是否将当前就诊切换为选中行的就诊?', function(r){
						if (r){
							if (typeof parent.switchPatient =="function"){
								parent.switchPatient(row["PatientID"],row["EpisodeID"],row["mradm"]);
							}else{
								parent.setEprMenuForm(row["EpisodeID"],row["PatientID"],row["mradm"]);
								parent.refreshBar();
							}
						}
					});
				}
			}
		},onLoadSuccess:function(data){
			if (data.rows.length>0){
				StartLoading(0);
			}
			function StartLoading(StartRow) {
				function LoadingIconRow(RowIndex) {
					if (RowIndex<data.rows.length) {
						if (data.rows[RowIndex].EpisodeID!=""){
							$.cm({
								ClassName:"web.DHCDocMain",
								MethodName:"ShowIcon",
							    code:"MAP",
							    val:(data.rows[RowIndex].EpisodeID+"^^^"+data.rows[RowIndex].PatientID),
							    context:session['CONTEXT'],
								dataType:"text"
							},function(data){
								$('#AdmListTab').datagrid('updateRow',{
									index: RowIndex,
									row: {
										IconProfile:data
									}
								});
							});
						}
						setTimeout(function () {
							LoadingIconRow(RowIndex+1)
						}, 0);
					}
				}
				setTimeout(function () {
					LoadingIconRow(StartRow);
				}, 0);
			}
		},onClickRow:function(rowIndex, rowData){
			ShowSecondeWin("onOpenDHCEMRbrowse",rowData)
		}
	});
	return AdmListTabDataGrid;
}
function AdmListTabDataGridLoad(){
	$.cm({
	    ClassName : "web.DHCAdmOrderTree",
	    QueryName : "FindDocCurrentAdm",
	    PatientID:ServerObj.PatientID,
	    PatientNo:"",
	    Pagerows:PageLogicObj.m_AdmListTabDataGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.m_AdmListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function BAdmOrdInfo(Ord){
	if (HISUIStyleCode=="lite"){
		var $code='<div style="border:1px solid #E3E3E3;margin:10px;border-radius:4px;"><table id="OrderListGrid"></table></div>'
	}else{
		var $code='<div style="border:1px solid #ccc;margin:10px;border-radius:4px;"><table id="OrderListGrid"></table></div>'
	}
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
		{field:'Status',title:'状态',width:80,},
		/*{field:'Paid',title:'药品状态',width:80,
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
	$.q({
	    ClassName:"web.EPVisitNumber",
	    QueryName:"ProfileList",
	    TSRTITM:"", TSRTORD:"", par:Ord, dfrom:"", dto:"", categ:"", stat:"", result:"", vis:"", dsfrom:"", dsto:"", cptype:"",
	    hospitallist:"", EpisodeAll:0, OrderSubcategories:"", ExcludeCurrentEpisode:0,
	    rows:99999
	},function(GridData){
		$HUI.datagrid('#OrderListGrid',{
		    data:GridData,
		    idField:'ID',
		    fit : false,
		    width:1070,
		    height:460,
		    border: false,
		    columns:Columns,
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
	});
}

/// 展示第二副屏
function ShowSecondeWin(Flag,rowData){
	//展示信息总览
    if (websys_getAppScreenIndex()==0){
	    var currentChartTitle=(rowData.PAAdmType!="住院")?"医嘱浏览":"";
	    var Obj={PatientID:rowData.PatientID,EpisodeID:rowData.EpisodeID,mradm:rowData.mradm,patListCollapse:1,currentChartTitle:currentChartTitle};
	    if (Flag=="onOpenIPTab"){
		    //信息总览
		}
		if (Flag=="onOpenDHCEMRbrowse"){
			var JsonStr=$.m({
				ClassName:"DHCDoc.Util.Base",
				MethodName:"GetMenuInfoByName",
				MenuCode:"DHC.Seconde.DHCEMRbrowse"		//使用最新统一维护的菜单
			},false)
			if (JsonStr=="{}") return false;
			var JsonObj=JSON.parse(JsonStr);
			$.extend(Obj,JsonObj);
		}
		websys_emit(Flag,Obj);
	}
}
