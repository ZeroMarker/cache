/**
 * 模块:		药库
 * 子模块:		药品信息维护(分级)
 * createdate:	2017-06-20
 * creator:		yunhaibao
 */
var mtUrl = "dhcst.easyui.drugmaintain.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
$(function(){
	InitSearchBox();
	InitPHCCatTreeGrid();
	InitPHCChemicalGrid();
	InitPHCGenericGrid();
	InitARCItmGrid();
	InitINCItmGrid();
	DHCSTEASYUI.Authorize();
	document.onkeypress = DHCSTEASYUI.BanBackspace;
	document.onkeydown = DHCSTEASYUI.BanBackspace;
});

/// 初始化药学分类树
function InitPHCCatTreeGrid(){
	var treeColumns=[[  
		{field:'phcCatDesc',title:'药学分类',width:250}, 
		{field:'phcCatLevel',title:'级别',width:20,align:'center',hidden:false},
		{field:'phcCatCode',title:'代码',width:80,hidden:true},
		{field:'phcCatRowId',title:'phcCatRowId',hidden:true},
		{field:'_parentId',title:'parentId',hidden:true}
	]];
	$('#phcCatTreeGrid').treegrid({  
		toolbar:'#barPhcCat',
		animate:true,
		border:false,
		fit:true,
		nowrap:true,
		fitColumns:true,
		singleSelect:true,
		idField:'phcCatRowId', 
		treeField:'phcCatDesc',
		striped: true, 
		//pagination:true,
		rownumbers:false,//行号 
		//pageSize:150,
		//pageList:[150,300],
		columns:treeColumns,
		url:mtUrl,
		queryParams: {
			action:'QueryPhcCatTree'
		},
		onDblClickRow:function(rowData){
			var selTabObj=$("#detail-tabs").tabs("getSelected");
			var selTabTitle=selTabObj.panel('options').title;
			// 双击药学分类清除所有条件与选中
			$('#searArcItm,#searChemical,#searGeneric,#searIncItm').searchbox('clear');
			switch (selTabTitle){
				case "化学通用名":
					QueryPHCChemicalGrid(1);
					break;
				case "处方通用名":
					QueryPHCGenericGrid(1);
					break;
				case "医嘱项":
					QueryARCItmGrid(1);
					break;
				case "库存项":
					QueryINCItmGrid(1);
					break;
				default:
					break;
				
			}
			
		},         
		onBeforeExpand:function(row){  
 
        },
        onExpand : function(row){ 
        },
        onLoadSuccess : function(row, data	){
	       //$(this).treegrid('collapseAll')
	    },
		onContextMenu: function(e, row) { //右键时触发事件
	  		if ($("#easyui-rightmenu").html()==undefined){
		  		return;
		  	}
		  	var _treegrid_id=$(this).attr("id");
	        e.preventDefault(); //阻止浏览器捕获右键事件
	        $("#easyui-rightmenu #menu-export").unbind().bind("click",function(){
		    	ExportPhcCatToExcel(_treegrid_id);  
		    })
	        $('#easyui-rightmenu').menu('show', {
	            left: e.pageX,
	            top: e.pageY
	        });
	      }
	  });
}
function ReloadPhcCatTreeById(phcCatId){
	if ((phcCatId!=undefined)&&(phcCatId!="")){
		var parentObj=$('#phcCatTreeGrid').treegrid('getParent',phcCatId);
		if (parentObj==null){
			$('#phcCatTreeGrid').treegrid('reload');
		}else{
			needLoadId=parentObj.phcCatRowId;
			if (needLoadId){
				$('#phcCatTreeGrid').treegrid('reload',needLoadId);
			}	
		}
		return;
	}
	var selectNode = $("#phcCatTreeGrid").treegrid('getSelected');
	if(selectNode==null){
		$('#phcCatTreeGrid').treegrid('reload');
		return;
	}
	var selectId=selectNode.phcCatRowId;
	var needLoadId=selectId;
	var childLen=$('#phcCatTreeGrid').treegrid('getChildren',selectId).length;
	if (childLen==0){
		needLoadId=$('#phcCatTreeGrid').treegrid('getParent',selectId).phcCatRowId;
	}
	$('#phcCatTreeGrid').treegrid('reload',needLoadId);
}

/// 初始化化学通用名列表
function InitPHCChemicalGrid(){
	var gridColumns=[[  
		{field:'chemicalDesc',title:'化学通用名称',width:300,sortable:true,
            styler: function(value, row, index) {
	            if (row.phcCatId==""){
		        	return 'color:#0085FF;font-weight:bold;';
		        }
            }
        }, 
		{field:'chemicalCode',title:'化学通用代码',width:150,sortable:true},
		{field:'phcCatDesc',title:'药学分类',width:250,sortable:true},
		{field:'phcCatId',title:'药学分类ID',width:80,hidden:true},
		{field:'chemicalId',title:'chemicalId',hidden:true}
	]];
	var options={
		ClassName:'web.DHCST.PHCChemical',
		QueryName:'Query',
		queryParams:{
			StrParams:'needNull' 
		},
	    toolbar:'#barChemical',
        columns:gridColumns,
        onDblClickRow:function(rowIndex,rowData){
	        $('#searGeneric').searchbox('clear');
			QueryPHCGenericGrid();
			$("#detail-tabs").tabs("select","处方通用名");
			$("#span-chemicalDesc").text(rowData.chemicalDesc);
			$("#span-chemicalId").text(rowData.chemicalId);
		},
		onClickRow:function(rowIndex,rowData){
			/*
			if (rowData){
				$("#span-chemicalDesc").text(rowData.chemicalDesc);
				$("#span-chemicalId").text(rowData.chemicalId);
			}*/
		},
		onLoadSuccess:function(data){
			$("#span-chemicalDesc").text("全部");
			$("#span-chemicalId").text("");
		} 
	}
	$('#phcChemicalGrid').dhcstgrideu(options);
}

/// 初始化处方通用名列表
function InitPHCGenericGrid(){
	var gridColumns=[[  
		{field:'genericDesc',title:'处方通用名称',width:300,sortable:true,
            styler: function(value, row, index) {
	            if (row.chemicalId==""){
		        	return 'color:#0085FF;font-weight:bold;';
		        }
            }
        },
		{field:'genericCode',title:'处方通用代码',width:150,sortable:true},
		{field:'genericStDate',title:'开始日期',width:150,hidden:true},
		{field:'genericEdDate',title:'结束日期',width:150,hidden:true},
		{field:'genericId',title:'genericId',width:80,hidden:true},
		{field:'chemicalId',title:'chemicalId',width:150,hidden:true},
		{field:'chemicalDesc',title:'化学通用名',width:150,hidden:false,sortable:true},
		{field:'formDesc',title:'剂型',width:150,hidden:false,sortable:true}
	]];
	var options={
		ClassName:'web.DHCST.PHCGeneric',
		QueryName:'Query',
		queryParams:{
			StrParams:'needNull' 
		},
	    toolbar:'#barGeneric',
        columns:gridColumns,
		onDblClickRow:function(rowIndex,rowData){
			$('#searArcItm').searchbox('clear');
		    QueryARCItmGrid();
		    $("#detail-tabs").tabs("select","医嘱项");
			$("#span-genericDesc").text(rowData.genericDesc);
			$("#span-genericId").text(rowData.genericId);
		},
		onClickRow:function(rowIndex,rowData){
			/*
			if (rowData){
				$("#span-genericDesc").text(rowData.genericDesc);
				$("#span-genericId").text(rowData.genericId);
			}*/
		},
		onLoadSuccess:function(data){
			$("#span-genericDesc").text("全部");
			$("#span-genericId").text("");
		}   
	}
	$('#phcGenericGrid').dhcstgrideu(options);
}

function renderAsIcon(value,row,index){
	if (value=="Y"){
		return '<img src="../scripts/dhcpha/img/ok.png" border=0/>';
	}else{
    	return '';
    }
}
/// 初始化医嘱项列表
function InitARCItmGrid(){
	var gridColumns=[[  
		{field:'arcItmRowId',title:'医嘱项ID',width:100,hidden:true}, 
		{field:'arcItmDesc',title:'医嘱项名称',width:300,sortable:true,
            styler: function(value, row, index) {
	            if (row.genericId==""){
		        	return 'color:#0085FF;font-weight:bold;';
		        }
            }
        },
		{field:'arcItmCode',title:'医嘱项代码',width:150,sortable:true},
		{field:'billUom',title:'计价单位',width:80,sortable:true,hidden:true},
		{field:'ordCategory',title:'医嘱大类',width:100,sortable:true},
		{field:'arcItmCat',title:'医嘱子类',width:150,sortable:true},
		{field:'phcForm',title:'剂型',width:100,sortable:true},
		{field:'phcInstu',title:'用法',width:100,sortable:true},
		{field:'phcDura',title:'疗程',width:100,sortable:true},
		{field:'phcFreq',title:'频次',width:100,sortable:true},
		{field:'phcManf',title:'厂商',width:200,sortable:true},
		{field:'phcPoison',title:'管制分类',width:150,sortable:true},
		{field:'phcBasicDrug',title:'基本药物',width:65,align:'center',formatter:renderAsIcon,sortable:true},
		{field:'genericDesc',title:'处方通用名',width:150,sortable:true},
		{field:'genericId',title:'处方通用名ID',width:150,hidden:true},
		{field:'arcItmStopDate',title:'截止日期',align:'center',width:85,sortable:true},
	]];
	var options={
		ClassName:'web.DHCST.ARCITMMAST',
		QueryName:'QueryArcItmMast',
	    toolbar:'#barArcItm',
		queryParams:{
			StrParams:'needNull' 
		},
        columns:gridColumns,
		onDblClickRow:function(rowIndex,rowData){
			$('#searIncItm').searchbox('clear');
		    QueryINCItmGrid();
		    $("#detail-tabs").tabs("select","库存项");
			$("#span-arcDesc").text(rowData.arcItmDesc);
			$("#span-arcId").text(rowData.arcItmRowId);
		},
		onClickRow:function(rowIndex,rowData){
			/*
			if (rowData){
				$("#span-arcDesc").text(rowData.arcItmDesc);
				$("#span-arcId").text(rowData.arcItmRowId);
			}*/
		},
		onLoadSuccess:function(data){
			$("#span-arcDesc").text("全部");
			$("#span-arcId").text("");
		}    
	}
	$('#arcItmGrid').dhcstgrideu(options);

}

/// 初始化库存项列表
function InitINCItmGrid(){
	var gridColumns=[[  
		{field:'incRowId',title:'ID',width:80,hidden:true},
		{field:'arcItmDesc',title:'医嘱项名称',width:200,hidden:false,sortable:true,
			formatter: function(value,row,index){
        		return '<a style="text-decoration: underline" onclick=\'EditArcFromInc("'+row.arcItmRowId+'")\'>'+value+'</a>';
     		}
		},
		{field:'incDesc',title:'库存项名称',width:200,sortable:true,
            styler: function(value, row, index) {
	            if (row.arcItmRowId==""){
		        	return 'color:#0085FF;font-weight:bold;';
		        }
            }
        }, 
		{field:'incCode',title:'库存项代码',width:150,sortable:true},
		{field:'incSpec',title:'规格',width:100,sortable:true},
		{field:'incBUom',title:'基本单位',width:100,sortable:true},
		{field:'incRp',title:'进价',align:'right',width:100,sortable:true},
		{field:'incSp',title:'售价',align:'right',width:100,sortable:true},
		{field:'incRemark',title:'批准文号',width:100,sortable:true},
		{field:'incStkCat',title:'库存分类',width:150,hidden:false,sortable:true},
		{field:'incNotUse',title:'不可用',align:'center',width:50,formatter:renderAsIcon,sortable:true},
		{field:'arcItmRowId',title:'医嘱项ID',hidden:true},
		{field:'genericDesc',title:'处方通用名',width:150,sortable:true},
		{field:'chemicalDesc',title:'化学通用名',width:150,sortable:true}
	]];
	var options={
		ClassName:'web.DHCST.INCITM',
		QueryName:'QueryIncItm',
		queryParams:{
			StrParams:'needNull' 
		},
	    toolbar:'#barIncItm',
        columns:gridColumns,
		onDblClickRow:function(rowIndex,rowData){
		    //QueryINCItmGrid();
		}  
	}
	$('#incItmGrid').dhcstgrideu(options);
}

/// 初始化所有searchBox
function InitSearchBox(){
	var searchSelHtml=
	'<div data-options='+"name:'alias',iconCls:''"+'>'+'别名'+'</div>'+
	'<div name="code" data-options='+"name:'code',iconCls:''"+'>'+'代码'+'</div>'+
	'<div name="desc" data-options='+"name:'desc',iconCls:''"+'>'+'名称'+'</div>';
	$(".dhcphaSearchBox").append(searchSelHtml);
	$('#searPhcCat').searchbox({
	    searcher:function(value,name){
		    QueryPHCCatTreeGrid();
	    },
	    menu:'#mPhcCat',
	    width:'340',
	    prompt:'药学分类...'
	});
	$('#searChemical').searchbox({
	    searcher:function(value,name){
			QueryPHCChemicalGrid(2);
	    },
	    menu:"#mChemical",
	    width:'340',
	    prompt:'化学通用名...'
	});
	//$('#searChemical').searchbox('selectName','desc');
	$('#searGeneric').searchbox({
	    searcher:function(value,name){
			QueryPHCGenericGrid(2);
	    },
	    menu:'#mGeneric',
	    width:'340',
	    prompt:'处方通用名...'
	});
	$('#searArcItm').searchbox({
	    searcher:function(value,name){
			QueryARCItmGrid(2);
	    },
	    menu:'#mArcItm',
	    width:'340',
	    prompt:'医嘱项...'
	});
	$('#searIncItm').searchbox({
	    searcher:function(value,name){
			QueryINCItmGrid(2);
	    },
	    menu:'#mIncItm',
	    width:'340',
	    prompt:'库存项...'
	});
	$('#searTarItm').searchbox({
	    searcher:function(value,name){
			QueryTARItmGrid();
	    },
	    menu:'#mTarItm',
	    width:'340',
	    prompt:'收费项...'
	});
}
/// 查询药学分类树
function QueryPHCCatTreeGrid(){
	var params=GetSearchBoxParams("searPhcCat");
	$('#phcCatTreeGrid').treegrid('load',  {  
			action: 'QueryPhcCatTree',
			strParams: params					
	});
}
/// 查询化学通用名列表
function QueryPHCChemicalGrid(queryType){
	if(queryType==undefined){
		queryType="";
	}
	var params=GetSearchBoxParams("searChemical");
	var selected=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatId="";
	if (selected){
		phcCatId=selected.phcCatRowId;
	}
	if (queryType=="2"){
		phcCatId="";
	}
	params=phcCatId+"^"+params;
	$('#phcChemicalGrid').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

/// 查询处方通用名列表
function QueryPHCGenericGrid(queryType){
	if(queryType==undefined){
		queryType="";
	}
	if (queryType!=""){
		$('#phcChemicalGrid').datagrid('clearSelections');
	}
	var params=GetSearchBoxParams("searGeneric");
	var selected=$('#phcChemicalGrid').datagrid('getSelected');
	var chemicalId="";
	if (selected){
		chemicalId=selected.chemicalId;
	}
	var selectedPhcCat=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatId="";
	if (selectedPhcCat){
		phcCatId=selectedPhcCat.phcCatRowId;
	}
	if (queryType=="1"){
		chemicalId="";
		$("#span-chemicalDesc").text("全部");
		$("#span-chemicalId").text("");
	}
	if (queryType=="2"){
		chemicalId="";
		phcCatId="";
		$("#span-chemicalDesc").text("全部");
		$("#span-chemicalId").text("");
	}
	if (chemicalId!=""){
		phcCatId="";
	}
	params=chemicalId+"^"+params+"^"+phcCatId;
	$('#phcGenericGrid').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

/// 查询医嘱项列表 
function QueryARCItmGrid(queryType){
	if(queryType==undefined){
		queryType="";
	}
	if (queryType=="1"){
		$('#phcGenericGrid').datagrid('clearSelections');
	}
	var params=GetSearchBoxParams("searArcItm");
	var selected=$('#phcGenericGrid').datagrid('getSelected');
	var genericId="";
	if (selected){
		genericId=selected.genericId;
	}
	var selectedPhcCat=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatId="";
	if (selectedPhcCat){
		phcCatId=selectedPhcCat.phcCatRowId;
	}
	if (queryType=="1"){
		genericId="";
		$("#span-genericDesc").text("全部");
		$("#span-genericId").text("");
	}
	if (queryType=="2"){
		genericId="";
		phcCatId="";
		$("#span-genericDesc").text("全部");
		$("#span-genericId").text("");
	}
	if (genericId!=""){
		phcCatId="";
	}
	params=genericId+"^"+params+"^"+phcCatId;
	$('#arcItmGrid').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

/// 查询库存项列表 
function QueryINCItmGrid(queryType){
	if(queryType==undefined){
		queryType="";
	}
	if (queryType=="1"){
		$('#arcItmGrid').datagrid('clearSelections');
	}
	var params=GetSearchBoxParams("searIncItm");
	var selected=$('#arcItmGrid').datagrid('getSelected');
	var arcItmId="";
	if (selected){
		arcItmId=selected.arcItmRowId;
	}
	var selectedPhcCat=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatId="";
	if (selectedPhcCat){
		phcCatId=selectedPhcCat.phcCatRowId;
	}
	if (queryType=="1"){
		arcItmId="";
		$("#span-arcDesc").text("全部");
		$("#span-arcId").text("");

	}
	if (queryType=="2"){
		phcCatId="";
		arcItmId="";
		$("#span-arcDesc").text("全部");
		$("#span-arcId").text("");
	}
	if (arcItmId!=""){
		phcCatId="";
	}
	params=arcItmId+"^"+params+"^"+phcCatId;
	$('#incItmGrid').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

/// 查询收费项列表 
function QueryTARItmGrid(){
}
/// 验证是否为function
function CheckIfFunction(funName){
	try{
		if (typeof(eval(funName)=="function")){
			return true;
		}
		return false;
	}catch(e){
		return false;
	}
}
/// 获取searchbox拼串后的返回值
function GetSearchBoxParams(searId){
	var name=$('#'+searId).searchbox("getName")
	var value=$('#'+searId).searchbox("getValue")
	var code="",desc="",alias="";
	if (name=="code"){
		code=value;
	}
	if (name=="desc"){
		desc=value;
	}
	if (name=="alias"){
		alias=value;
	}
	return code+"^"+desc+"^"+alias;
}

/// 导出药学分类
function ExportPhcCatToExcel(treeGridId){
	try{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e){
		$.messager.alert("提示","必须安装excel，同时浏览器允许执行ActiveX控件","warning");
		return "";
	}
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);
    var treeRoots=$('#'+treeGridId).treegrid('getRoots');
    var children=$('#'+treeGridId).treegrid('getChildren',treeRoots.target);
    var row=1;tmpLevel="",maxCol=0
    for(j=0;j<children.length;j++){
	    var childData=children[j];
		var phcCatLevel=childData.phcCatLevel;
		var phcCatDesc=childData.phcCatDesc;
		var phcCatRowId=childData.phcCatRowId;
		var levelNum=parseInt(phcCatLevel);
		var tmpChild=$('#'+treeGridId).treegrid('getChildren',phcCatRowId);
		tmpLevel=phcCatLevel;
		xlSheet.Cells(row,levelNum).value =phcCatDesc;
		if(tmpChild==""){
			if (row>1){
				for (var ni=1;ni<levelNum;ni++){			
					var xlSheetVal=xlSheet.Cells(row,ni).value || '';
					if (xlSheetVal==""){
						xlSheet.Cells(row,ni).value=xlSheet.Cells(row-1,ni).value;	
					}
				}
			}
			row++;
		}
		if (levelNum>maxCol){
			maxCol=levelNum;
		}
		
    }	 
	try{
		var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
 		var ss = xlBook.SaveAs(fileName);  
	 	if (ss==false){
			$.messager.alert('错误提示','另存失败！','warning') ;
		}		
	}
	catch(e){
		 $.messager.alert('错误提示','另存失败！','warning') ;
	}		
	xlSheet=null;
    xlBook.Close (savechanges=false);
    xlBook=null;
    xlApp.Quit();
    xlApp=null;
}