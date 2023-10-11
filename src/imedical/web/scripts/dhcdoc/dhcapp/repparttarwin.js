//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2016-12-22
// 描述:	   检查申请部位选择界面
//===========================================================================================

var oeori = "";
var refRepPart=""

/// 页面初始化函数
function initPageDefault() {
	
	InitParam();     ///  初始化参数信息
	InitItemList();  ///  页面DataGrid检查分类列表
	InitBlButton();  ///  页面Button绑定事件
	
	InitLoadData();  ///  加载医嘱对应部位
}

/// 初始化加载病人就诊ID
function InitParam(){
	oeori = getParam("oeori");
	refRepPart = getParam("refRepPart");
}

/// 页面DataGrid初始定义检查分类列表
function InitItemList(){

	///  定义columns
	var columns=[[
		{field:"checkbox",checkbox:true},
		{field:'PartDesc',title:'部位',width:280},
		{field:'ItemPrice',title:'价格',width:130},
		{field:'ItemStat',title:'状态',width:130,formatter:SetCellFontColor},
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'PartID',title:'PartID',width:100,hidden:true},
		{field:'TarFlag',title:'TarFlag',width:100,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		bodyCls: 'panel-header-gray',
		rownumbers: true,
		singleSelect: false,
		pagination: false,
		rowStyler:function(index,rowData){   
	        if (rowData.ItemStat == "停止"){
	            return 'background-color:Pink;'; 
	        }
	    },
	    onCheckAll:function (){
 			var rowsData = $("#dmPartList").datagrid("getRows");
    		for (var i = 0; i < rowsData.length; i++) {
      			if ((rowsData[i].ItemStat == "停止")||(rowsData[i].PartID == "")||((rowsData[i].ItemStat == "执行")&&(ServiceObj.TreatItmReqMode ==0))){
					$("input[type='checkbox']")[i + 1].checked=false
				}
	   
    		}
		   	SetCheckclick()
		    },
	    onCheck:function(rowIndex,rowData){
			if (rowData.ItemStat == "停止"){
				$(this).datagrid('unselectRow', rowIndex);
				$.messager.alert("提示:","当前记录已停止，不能再次撤销！");
				return;
			}
			if ((rowData.ItemStat == "执行")&(rowData.PartID != "")&(ServiceObj.TreatItmReqMode ==0)){
				$(this).datagrid('unselectRow', rowIndex);
				$.messager.alert("提示:","当前记录已执行，不能撤销！");
				return;
			}
			if (rowData.TarFlag == "N"){
	            var rowsData = $("#dmPartList").datagrid("getRows");
                for (var i = 0; i < rowsData.length; i++) {
                    $("#dmPartList").datagrid('checkAll');
                }
			}
			SetCheckclick()
		},
		onUncheck:function(rowIndex,rowData){
		   
			if (rowData.TarFlag == "N"){
	            var rowsData = $("#dmPartList").datagrid("getRows");
                for (var i = 0; i < rowsData.length; i++) {
                    $("#dmPartList").datagrid('uncheckAll');
                }
			}
			SetCheckclick()
		},
	    onClickRow:function(rowIndex, rowData){
		    
		    $(this).datagrid('unselectRow', rowIndex);
		},
		onLoadSuccess: function(data){
			/// 隐藏标题行checkbox
			/// $("#dmPartList").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
            /// 循环设置停止项目checkbox 不可选
            if (data.rows.length > 0) {
                for (var i = 0; i < data.rows.length; i++) {
                    if ((data.rows[i].ItemStat == "停止")||(data.rows[i].PartID == "")||((data.rows[i].ItemStat == "执行")&&(ServiceObj.TreatItmReqMode ==0))) {
                        $("input[type='checkbox']")[i + 1].disabled = true;
                    }
                }
            }
            if (refRepPart!=""){
	            var rowsData = $("#dmPartList").datagrid("getRows");
	            var refRepPartArry=refRepPart.split("!!")
			    for (var i = 0; i < rowsData.length; i++) {
			       //if ((rowsData[i].ItemStat == "停止")||((rowsData[i].ItemStat == "执行"))){
					 if (rowsData[i].ItemStat == "停止"){
						continue;
					}
					for (var j = 0; j < refRepPartArry.length; j++) {
						if (refRepPartArry[j]==rowsData[i].ItemID ){
							$("input[type='checkbox']")[i + 1].checked=true
							$(this).datagrid('selectRow', i );
							}
					}
			    }
	            refRepPart=""
	            }
        }
	};
	
	var params = "";
	var uniturl = "";
	new ListComponent('dmPartList', columns, uniturl, option).Init(); 
}

/// 页面 Button 绑定事件
function InitBlButton(){
	
	///  取消
	$('#Cancel').bind("click",cancel);
		
	///  确定
	$('#BSave').bind("click",retExaReqItm);

}

/// 初始化加载部位数据
function InitLoadData(){
	
	/// 部位分类列表
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPartItmList&oeori="+oeori;
	$('#dmPartList').datagrid({url:uniturl});
}

/// 退费申请确定，获取执行选中项目
function retExaReqItm(){

	var rowsData=$("#dmPartList").datagrid('getRows'); /// 获取选中行
	if (rowsData.length == 0){
		$.messager.alert("提示:","请先选择待退费记录！");
		return;
	}
	var mItmListData = [];
	$.each(rowsData, function(index, rowData){
		var arReqItmID = rowData.ItemID;  /// 项目ID
		var PartID = rowData.PartID;      /// 部位ID
		var PartDesc = rowData.PartDesc;  /// 部位描述
		//if ((rowData.ItemStat == "停止")||(rowData.PartID == "")||((rowData.ItemStat == "执行")&&(ServiceObj.TreatItmReqMode ==0))) {
		if ($("input[type='checkbox']")[index + 1].checked==false){	
		}else{
			var ListData = arReqItmID +"^"+ PartDesc;
			mItmListData.push(ListData);
		}
	});
	websys_showModal("options").callBackFunc(mItmListData.join("!!"));
	websys_showModal("close");
}
function SetCheckclick(){
	var NeedFlag=1
	var rowsData = $("#dmPartList").datagrid("getRows");
    for (var i = 0; i < rowsData.length; i++) {
       if ((rowsData[i].ItemStat == "停止")||(rowsData[i].PartID == "")||((rowsData[i].ItemStat == "执行"))){
			continue;
		}
	   if ($("input[type='checkbox']")[i + 1].checked){}else{
		   NeedFlag=0
		   }
    }
    if (NeedFlag==0){
	    for (var i = 0; i < rowsData.length; i++) {
		 if ((rowsData[i].PartID == "")&&(rowsData[i].ItemStat != "停止")&&(rowsData[i].ItemStat != "执行")){
			 $("input[type='checkbox']")[i + 1].checked=false
			 }		
	    
	    }
	}else{
		for (var i = 0; i < rowsData.length; i++) {
		 if ((rowsData[i].PartID == "")&&(rowsData[i].ItemStat != "停止")&&(rowsData[i].ItemStat != "执行")){
			 $("input[type='checkbox']")[i + 1].checked=true
			 }		
	    
	    }
	} 
}
/// 关闭窗体
function cancel(){
	websys_showModal("options").callBackFunc("");
	websys_showModal("close");
}

/// 设置字体显示颜色
function SetCellFontColor(value, rowData, rowIndex){
	
	var htmlstr = value;
	if (rowData.ItemStat == "执行"){
		htmlstr = "<span style='color:red; font-weight:bold'>"+value+"</span>"
	}else{
		htmlstr = "<span style='color:green; font-weight:bold'>"+value+"</span>"
	}
	return htmlstr;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
