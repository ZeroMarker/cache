 var treeid = ""; 
 var TREE_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBPReportItem&pClassMethod=GetReportTreeList"; 
 
 var init = function(){ 
 var list="";
 var datasourse="";
 var columns=new Array();
 
 	 ///查询
	 $("#btnSearch").click(function(){ 
	 	 SearchData();
	 });
	 ///  右侧 新增
	 $("#data_addbtn").click(function(){ 
	 	 AddData();
	 });
	 /// 右侧 修改
	 $("#data_updatebtn").click(function(){
	 	 UpdateData(); 
	 });
	 /// 右侧 删除 
	 $("#data_delbtn").click(function(){
	 	 DelData();
	 }); 
	 
	 /// 下载数据模板
	 $("#import_template_btn").click(function(){
	 	DownloadTemplate();
	 });
	 /// 数据导入
	 $("#data_importbtn").click(function(){
	 	ImportData();
	 });
	 
	/// 左侧 搜索框响应 
	$('#TextTypeDesc').searchbox({ 
		searcher:SearchTypeFun
	});
	/// 父表菜单搜索
	function SearchTypeFun(){
	var SearchContent = $("#TextTypeDesc").searchbox('getValue');
	$("#Tree").treegrid('search', SearchContent); 
	}
	/// 左侧 清屏按钮
	$("#btnTypeRefresh").click(function (e) { 
		$('#TextTypeDesc').searchbox('setValue',''); 
		$("#Tree").treegrid('reload');  
	 }) 
 }
 
init();

///加载树形目录
var TreeColumns =[[  
	  {field:'text',title:'描述',width:290,sortable:true},
	  {field:'id',title:'ID',width:80,sortable:true,hidden:true}
]];
///定义右侧Grid列	
var colObjArr=[[
		    { field: 'RItemRowId', title: 'ID', width:5 ,hidden:true },
		    { field: 'RItemBPRIItemDesc', title: '项目名称', width: 120 },
		    { field: 'RItemBPRIBloodDialysisCode', title: '血液净化项目', width: 100 },
		    { field: 'RItemBPRIDiagnosisCode', title: '诊断项目', width: 100 },
		    { field: 'RItemBPRITestCode', title: '检验项目', width: 100 },
		    { field: 'RItemBPRIOrdCode', title: '医嘱项目', width: 100 },
		    { field: 'RItemBPRICheckCode', title: '检查项目', width: 100 },
		    { field: 'RItemBPRIStartDate', title: '开始日期', width: 120 },
		    { field: 'RItemBPRIEndDate', title: '结束日期', width: 120 },
		    { field: 'RItemBPRIMethod', title: '获取方式', width: 100 },
		    { field: 'RItemBPRIFrequency', title: '频次', width: 100 },
		    { field: 'RItemBPRIDefaultValue', title: '默认值', width: 100 }
		]]
	/// 定义 左侧树形列表			  
	var mygrid = $HUI.treegrid("#Tree",{
		url: TREE_ACTION_URL,  
		columns: TreeColumns,  
		height: 'auto',
		fit:true,
		idField: 'id',
		treeField:'text',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
		animate:false,    
		onContextMenu: function(e, row){ 
				e.preventDefault();
        	 	$(this).treegrid('select', row.id);
			    $('#TreeMenu').menu('show',{
                    left: e.pageX,
                    top: e.pageY,
                    noline: true
               });
          },
		onSelect:function(rowIndex,rowData){  
    		treeid = rowIndex;
            //$('#DataGrid').datagrid('options').queryParams.ReportDr = treeid;
            $('#DataGrid').datagrid('load',{
	            ClassName:"web.DHCBPReportItem",
				QueryName:"GetList",
				rowid:"", 
				ReportDr:treeid, 
				code:"",
				desc:""
	            }            
            ); 
        } 
	});
 
     // 详细列表   
  	$('#DataGrid').datagrid({
                width: 'auto',
                height: 'auto',
                nowrap: false,
                striped: true,
                border: true,
                collapsible: false,//是否可折叠的
                autoScroll:true,
                fit: true,//自动大小
                url: $URL,
				queryParams:{
					ClassName:"web.DHCBPReportItem",
					QueryName:"GetList"
				}, 
				idField: 'RItemRowId',
                checkOnSelect: false,
                selectOnCheck: false,
                singleSelect: true,//是否单选
                pagination: true,//分页控件
                rownumbers: true,//行号
                columns:colObjArr,
				rownumbers:true,//行号
				pagination:true,//分页工具条
				pageSize:20,
				pageList:[20,40,60],
            });
   
 //属性查询方法
function SearchData(){
	var Row =$('#Tree').treegrid('getSelected');
	var desc=$.trim($("#TextDesc").val());
	if (treeid=="" || treeid.indexOf("Main")>0){
 		$.messager.alert('错误提示','请先选中左侧列表的子目录!',"error");
        return false;
 	}
	$('#DataGrid').datagrid('load',  { 
		ClassName:"web.DHCBPReportItem",
		QueryName:"SearchList",
		ReportDr:Row.id,
		desc:desc
	});
} 
/// 新增 字典数据
function AddData() { 
 	if (treeid=="" || treeid.indexOf("Main")>0){
 		$.messager.alert('错误提示','请先选中左侧列表的子目录!',"error");
        return false;
 	} 	
 	var Row =$('#Tree').treegrid('getSelected');
 	$("#dlgAdd").show(); 	
    $("#RIRowID").val("");
    $("#RIName").val(Row.text);
    $("#RIBloodDialysisCode").val("");
    $("#RIDiagnosisCode").combobox('setValue','');
    $("#RITestCode").val("");
    $("#RIOrdCode").combobox('setValue','');
    $("#RICheckCode").val("");
    $('#RIStartDate').datebox('setValue', '');	
    $('#RIEndDate').datebox('setValue', '');
    $("#RIMethod").combobox('setValue','');
    $("#RIFrequency").combobox('setValue','');
    $("#RIFrequency").combobox('setValue','');  
    $("RIDefaultValue").val("");	
    var myDlgAdd =$('#dlgAdd').dialog({
        iconCls:'icon-w-add',
        resizable:true,
        title:'新增',
        modal:true,
        width:400,
        height:500,
        buttonAlign : 'center',
        buttons:[{
            text:'保存', 
            id:'save_btn',
            handler:function(){	              
                SaveSelfFunLib();
				$('#DataGrid').datagrid('reload');
            }
        },{
            text:'关闭', 
            handler:function(){
                $HUI.dialog('#dlgAdd').close();
            }
        }] 
    });

} 
///新增、更新 字典里的数据
function SaveSelfFunLib()
{  	        
    
 	var Row =$('#Tree').treegrid('getSelected');
    var RowID =$.trim($("#RIRowID").val());
    var Name =$.trim($("#RIName").val());
    var BloodDialysisCode =$.trim($("#RIBloodDialysisCode").val());
    var DiagnosisCode =$.trim($("#RIDiagnosisCode").combobox('getValue'));
    var TestCode =$.trim($("#RITestCode").val());
    var OrdCode =$.trim($("#RIOrdCode").combobox('getValue'));
    var CheckCode =$.trim($("#RICheckCode").val());
    var StartDate =$.trim($('#RIStartDate').datebox('getValue'));	
    var EndDate =$.trim($('#RIEndDate').datebox('getValue'));
    var Method =$.trim($("#RIMethod").combobox('getValue'));
    var Frequency =$.trim($("#RIFrequency").combobox('getValue'));
    var DefaultValue =$.trim($("#RIDefaultValue").val());
	var SaveString=RowID+"^"+Name+"^"+BloodDialysisCode+"^"+DiagnosisCode+"^"+TestCode+"^"+OrdCode+"^"+CheckCode+"^"+StartDate+"^"+EndDate+"^"+Method+"^"+Frequency+"^"+DefaultValue;
    if (Name=="")
    {
        $.messager.alert('错误提示','名称不能为空!',"error");
        return false;
    } 
	if (StartDate != "" && EndDate != "") {
		var dateflag= tkMakeServerCall("web.DHCBPReportItem","CompareDate",StartDate,EndDate) 
		if(dateflag==1){ 
			$.messager.alert('错误提示','开始日期不能大于结束日期!',"error");
			return false;
		}
	}
	
	$m({
		ClassName:"web.DHCBPReportItem",
		MethodName:"SaveData",
		str:SaveString,
		TreeId:Row.id
		},function (textData){
		if(textData.indexOf("success")>0)
		{	
			$.messager.show({
			timeout:1000,
			title:"提示",
			msg:"添加成功",
			showType:'slide',
			});
			$HUI.dialog('#dlgAdd').close();
		}else{
			var errorMsg ="更新失败！"
	        if (textData) {
	            errorMsg =errorMsg+ '<br/>错误信息:' + textData
	        }
	         $.messager.alert('操作提示',errorMsg,"error");
		} 
 	});	
}

  ///修改数据
function UpdateData(){
		if (treeid==""){
	 		$.messager.alert('错误提示','请先选中左侧列表的子目录!',"error");
	        return false;
	 	}
        var record = $("#DataGrid").datagrid("getSelected");
        
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.RItemRowId;
            $("#dlgAdd").show(); 
	        $("#RIRowID").val(record.RItemRowId);
		    $("#RIName").val(record.RItemBPRIItemDesc);
		    $("#RIBloodDialysisCode").val(record.RItemBPRIBloodDialysisCode);
		    $("#RIDiagnosisCode").combobox('setValue',record.RItemBPRIDiagnosisCode);
		    $("#RITestCode").val(record.RItemBPRITestCode);
		    $("#RIOrdCode").combobox('setValue',record.RItemBPRIOrdCode);
		    $("#RICheckCode").val(record.RItemBPRICheckCode);
		    $('#RIStartDate').datebox('setValue', record.RItemBPRIStartDate);	
		    $('#RIEndDate').datebox('setValue', record.RItemBPRIEndDate);
		    $("#RIMethod").combobox('setValue',record.RItemBPRIMethod);
		    $("#RIFrequency").combobox('setValue',record.RItemBPRIFrequency);
		    $("RIDefaultValue").val(record.RItemBPRIDefaultValue);
            var myDlgUpd =$('#dlgAdd').dialog({
                iconCls:'icon-w-edit',
                resizable:true,
                title:'修改',
                modal:true,
                buttons:[{
                    text:'保存', 
                    id:'save_btn',
                    handler:function(){
                    	SaveSelfFunLib(id);
						$('#DataGrid').datagrid('reload');
                    }
                },{
                    text:'关闭', 
                    handler:function(){
						$HUI.dialog('#dlgAdd').close();
                    }
                }]
            });
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
}
  ///删除数据
function DelData(){
    var row = $("#DataGrid").datagrid("getSelected"); 
    if (!(row))
    {   $.messager.alert('错误提示','请先选择一条记录!',"error");
        return false;
    }
	$.messager.confirm("提示", "确定删除数据?", function (r) {
		if(r) { 		
			var rowid=row.RItemRowId;
			$m({
					ClassName:"web.DHCBPReportItem",
					MethodName:"DeleteData",
					id:rowid,
					},function (textData){
					if(textData.indexOf("S^")!=-1)
					{	
						$.messager.show({
						timeout:1000,
						title:"提示",
						msg:"已删除",
						showType:'slide'
						});						
						$('#DataGrid').datagrid('reload');
					}else{
						alert(textData);	
					}
				});
			 
		} else {
			$('#DataGrid').datagrid('reload');  // 重新载入当前页面数据  
			$('#DataGrid').datagrid('unselectAll');
		}
	}); 
} 

/// 导入操作
function ImportData(){
	$("#importExcel").dialog({
		iconCls:'icon-w-import',
		resizable:true, 
		height:390,
		modal:true  , 
		buttons:[{
            text:'导入',
			style:'marginTop:10px;',					
            id:'importdata_btn',
            handler:function(){  
            	uploadExcel() 
            }
        },{
            text:'取消', 
			style:'marginTop:10px;',
            id:'importdata_btn',
            handler:function(){  
				$("#importExcel").dialog("close");
            }
        }]
	});  
}
//}	

///combobox下拉框提示
function OnHidePanel2(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
		$(item).combobox("clear");	    
	    $(item).combobox("reload");
	    $(item).combobox('setValue',"");
	    $.messager.alert("提示","请从下拉框选择","error");
	    return;
	}
}
//诊断项目		
$HUI.combobox("#RIDiagnosisCode",{
        url:$URL+"?ClassName=web.DHCBPCom&QueryName=LookUpMrcDiagnosis&ResultSetType=array",        
        textField:"Description",
        valueField:"Id",
        onBeforeLoad:function(param){
            param.mrcidAlias=param.q;
        },
        onHidePanel: function () {	        
        	OnHidePanel2($(this));
        },
        mode: "remote"
    });
//医嘱项目
$HUI.combobox("#RIOrdCode",{
			url:$URL+"?ClassName=web.DHCBPOrder&QueryName=GetArcimList&ResultSetType=array",
			valueField:"Id",
			textField:"Desc",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {
               OnHidePanel2("#RIOrdCode");
        	},				
			onBeforeLoad:function(param)
        	{            	
            	param.needItemCatId="";
            	param.needArcimDesc=param.q;
            	param.arcimIdStr=""

        	},
        	mode:"remote"        			
		});

/// 下载数据模板
function DownloadTemplate(){
		var rtn = tkMakeServerCall("web.DHCBPReportItem","ProductTemplate","DHCBPReportItemTemplate"); 
		location.href = rtn;
}
//上传Excel		
function uploadExcel() { 
		var efilepath = $("#ExcelImportPath").filebox('getValue');
		//var efilepath=$('#ExcelImportPath').val();  //要导入的模板
		var efilepath="\\temp\\excel\\DHCBPReportItemTemplate.csv"
 		if (efilepath){
			if(efilepath.indexOf("fakepath")>0 ) {
				$.messager.alert('错误提示', '请在IE下执行导入！',"error");   
				return;
			}
			if((efilepath.indexOf(".xls")<=0) &&(efilepath.indexOf(".csv")<=0)) { 
				$.messager.alert('错误提示', '文件类型不正确,请选择.xls文件！',"error");  
				return;
			} 
			else{  
				var kbclassname=""  //类名
				var sheet_id =1;
				var file=efilepath.split("\\");
				var filename=file[file.length-1];  
				try{ 
					var oXL = new ActiveXObject("Excel.application"); 
					var oWB = oXL.Workbooks.open(efilepath);  	
				}		
				catch(e){
					var emsg="请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
					$.messager.alert('提示',emsg,"error"); 
					return;
				}
				
				$('#importload').dialog({ 
					resizable:true, 
					modal:true  
				});  
				$('#importload').dialog('open'); //显示进度条 
			
				var errorRow="";//没有插入的行
				var errorMsg="";//错误信息
				oWB.worksheets(sheet_id).select(); 
				var oSheet = oWB.ActiveSheet; 
				var rowcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count ; /// 行数
				var colcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count ; ///列数
				var ProgressText='';
				for (row=2;row<=rowcount;row++){ 
					var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
					var i=row
					
					for (var j=1;j<=colcount;j++){
						var cellValue=""
						if(typeof(oSheet.Cells(i,j).value)=="undefined"){
							cellValue=""
						}	
						else{
							cellValue=oSheet.Cells(i,j).value
						}
						tempStr+=(cellValue+"#")
						if (typeof(cellValue) == "date"){
							cellValue=(new Date(cellValue)).getFullYear() + '/' + ((new Date(cellValue)).getMonth() + 1) + '/' + (new Date(cellValue)).getDate();
						}
					}	 
					var kbclassname ="web.DHCBPReportItem";
					var Flag =tkMakeServerCall(kbclassname,"ImportExcel",tempStr); 
					if (Flag.indexOf("true")>0){
						errorRow=errorRow
					}
					else{
						if(errorRow!=""){
							errorRow=errorRow+","+i
						}else{
							errorRow=i
						}
					}
					tempStr="";  
					progressText = "正在导入"+oSheet.name+"表的第"+row+"条记录,总共"+rowcount+"条记录!";  
					setInterval(function(){  
					 	$('#pro').progressbar('setValue',row/rowcount*100);  
					  	$('#pro').attr('text',progressText); 
					}, 1000);  
					if(row==rowcount) //当到达最后一行退出
				  	{ 
				  		if(errorRow!=""){
							errorMsg=oSheet.name+"表导入完成，第"+errorRow+"行插入失败!" ;			
						}else{
							errorMsg=oSheet.name+"表导入完成!"
						}
					 	$('#pro').progressbar('setValue', 100); 
					 	progressText = "正在导入"+oSheet.name+"表的记录,总共"+rowcount+"条记录!";  
					 	$('#pro').attr('text', progressText);   
  
						oWB.Close(); 
						oXL.Quit(); 
						oXL=null;
						oSheet=null; 
						if (errorRow!=""){
							$.messager.alert('错误提示',errorMsg,"error"); 
						}else{
							$.messager.alert('提示',errorMsg,"success"); 
						}
					    $('#importload').window('close'); 
				  	}  
				  $('#importExcel').window('close'); 
				} 
		  	}
		}
		else{
			$.messager.alert('错误提示', '请选择将要上传的文件!',"error");    
		}
	}