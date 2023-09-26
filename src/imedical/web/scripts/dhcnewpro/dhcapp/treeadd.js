/// 检查分类树维护js 
///sufan 2016年7月14
var flag=0;     ///修改 2016/07/26
var rowIndexflag=""; ///修改 2016/09/07
/// 页面初始化函数
function initPageDefault(){
	
	initSymptomLevTree();    /// 初始化检查分类树
	initDataGrid();          /// 页面DataGrid初始定义
	initBlButton();          /// 页面 Button 绑定事件
    initCombobox();          /// 页面Combobox初始定义  
    LoadPageBaseInfo();   ///  初始化加载基本数据  
}
function initSymptomLevTree(){

	var url = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=CheckClassifyTree';
	
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	        var isLeaf = $("itemCat").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        var TraItmID = node.id; 		/// 检查分类ID
				$("#itemlist").datagrid("load",{"TraItmID":TraItmID});
	        }
	    }
	};
	new CusTreeUX("itemCat", '', option).Init();
}

///  初始化加载基本数据
function LoadPageBaseInfo(){
	/// 初始化加载数
	var url = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=jsonCheckCatByNodeID&id=0';
	$('#itemCat').tree('options').url =url; 
	$('#itemCat').tree('reload');

} 

/// 页面DataGrid初始定义
function initDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'ItemCode',title:'代码',width:100},
		{field:'ItemDesc',title:'医嘱项',width:300},
		{field:'ItemID',title:'ItemID',width:100},
		{field:'TraItmID',title:'TraItmID',width:100}
	]];
	
	///  定义datagrid
	var option = {
		//title:'医嘱项列表',
		rownumbers : false,
		singleSelect : true,
		showPageList : false
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTreeAdd&MethodName=QueryCheckItemList";
	new ListComponent('itemlist', columns, uniturl, option).Init();
	///修改 2016/09/07
	$('#itemlist').datagrid({
		onClickRow: function (rowIndex, rowData) {//单击选择行编辑
            rowIndexflag=rowIndex;
        }
    });
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	///	 增加
	$('a:contains("增加")').bind("click",showTraWin);
		
	///  删除
	$('#subtoolbar a:contains("删除")').bind("click",deleteRow);
	 ///  向上
    $('#subtoolbar a:contains("向上")').bind("click",moveUp);
    
    ///  向下
    $('#subtoolbar a:contains("向下")').bind("click",moveDown);	
    
	///  更新
    $('a:contains("更新")').bind("click",UpdateTraWin);
    
    ///  向上
    $('#itmcattoolbar a:contains("向上")').bind("click",MoveOrdNumUp);
    
    ///  向下
    $('#itmcattoolbar a:contains("向下")').bind("click",MoveOrdNumDown);	
    
	///  保存增加
	$('#addWin a:contains("保存")').bind("click",saveadd);
	
	///  取消增加
	$('#addWin a:contains("取消")').bind("click",cancelWinadd);
	
	///  保存更新
	$('#updateWin a:contains("保存")').bind("click",saveupd);
	
	///  取消更新
	$('#updateWin a:contains("取消")').bind("click",cancelWinupd);
	
	///  删除
	$('#itmcattoolbar a:contains("删除")').bind("click",deleteItmCat);
    
    ///回车事件
	$('#itmdesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var input = $('#itmdesc').val();
			new UIDivWindow($('#itmdesc'), input, "500px", "" ,setCurrEditRowCellVal).init();
		}
	});
}

///医嘱项响应函数
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#itmdesc').focus().select();  ///设置焦点 并选中内容
		return;
	}
	$('#itmdesc').val(rowObj.itmDesc);  /// 医嘱项
	$('#itmmast').val(rowObj.itmID);    /// 医嘱项ID
	
}

/// 页面Combobox初始定义
function initCombobox(){

	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=";
	/// 医院
	var url = uniturl+"GetHospDs";
	new ListCombobox("HospID",url,'').init();
	$("#HospID").combobox("setValue",LgHospID);
	///子部位
	$('#Part').combotree({			
			url : 'dhcapp.broker.csp?ClassName=web.DHCAPPTreeAdd&MethodName=getTreeCombo',
			state:closed,
			editable:true,
			onSelect:function(node) {
				var t = $("#Part").combotree('tree');
				var node=t.tree("getSelected");
				var parentNode=t.tree('getParent',node.target);
				$("#addDesc").val(parentNode.text);
				}
	
		});
}

///保存增加的的内容
function saveadd(){
	var TraID = $("#addCatID").val();
	var ItemCatDesc = $("#addDesc").val();
	if (ItemCatDesc == ""){
		$.messager.alert('提示',"检查分类不能为空！") 
		return;
	}
	var ItmmastID = $("#itmmast").val();                    /// 医嘱项   
	var PartID = $('#Part').combotree('getValues')          /// 子部位
	if((PartID!="")&&(ItmmastID == "")){
		$.messager.alert('提示',"医嘱项不能为空！") 
		return
	}
	var StartDate = $("#startDate").datebox("getValue");    /// 开始日期
	var EndDate = $("#endDate").datebox("getValue");        /// 截止日期
	var LastLevID = $("#LastLevID").val();       /// 上级节点ID
	var TraAlias=$("#addalias").val();     //分类别名
	var TraLinkID = "";
	///	ListData  检查代码^检查分类^上级id^医院id^分隔符^子表id^子部位id^医嘱项id^开始日期^截止日期
	var ListData = ItemCatDesc +"^"+ ItemCatDesc +"^"+ LastLevID +"^"+ LgHospID +"^"+TraAlias+"$$"+TraLinkID +"^"+ PartID +"^"+ ItmmastID +"^"+ StartDate+"^"+ EndDate;
	/// 保存数据
	runClassMethod("web.DHCAPPTreeAdd","Save",{"TraID":TraID, "ListData":ListData},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("提示","保存成功!");
			$('#itmdesc').val("");    /// 医嘱项
			$('#itmmast').val("");    /// 医嘱项ID
			$("#itemCat").tree('reload');
			$("#itemlist").datagrid('reload');
			
		}
		if(jsonString == "-1"){
		     $.messager.alert("提示","分类名称已存在!");
		}
		if(jsonString == "-2"){
			$.messager.alert("提示","已存在子部位，不能添加新的分类!");
		}
		if(jsonString == "-4"){
			$.messager.alert("提示","医嘱项存在，不能添加子部位!");
		}
		if(jsonString == "-5"){
			$.messager.alert("提示","子部位为空，不能添加医嘱项!");
		}
		if(jsonString == "-9"){
			$.messager.alert("提示","医嘱项不能重复保存!");
		}
	},'',false);
	     //$('#updateWin').window('close');   // 2016-07-2
	     
}
///保存更新时的内容
function saveupd(){
	var ItemCatDesc = $("#updateDesc").val();
	if (ItemCatDesc == ""){
		$.messager.alert('提示',"请输入检查分类！") 
		return;
	}
	var TraID = $("#updateCatID").val();
	var TraAlias=$("#updalias").val();
	var ListData =ItemCatDesc +"^"+ ItemCatDesc+"^"+ ""+"^"+ ""+"^"+ TraAlias ; 
	/// 保存数据
	runClassMethod("web.DHCAPPTreeAdd","SaveType",{"TraID":TraID, "ListData":ListData},function(jsonString){
		if (jsonString == 0){
		   
			$.messager.alert("提示","保存成功!");
			$('#updateWin').window('close');
			$("#itemCat").tree('reload');
			} 
			if(jsonString == "-2"){
			     $.messager.alert("提示","分类名称已存在!");
			  }

	     },'',false)
}

/// 默认获取当前时间
function GetDateStr(dd,AddDayCount) 
{ 
	dd.setDate(dd.getDate()+AddDayCount);// 获取AddDayCount天后的日期 
	var y = dd.getFullYear();
	var m = dd.getMonth()+1;             // 获取当前月份的日期 
	var d = dd.getDate(); 
	return y+"-"+m+"-"+d; 
} 
/// 获取当前时间的前一天
function DefDate() { 
	$('#startDate').datebox('setValue', GetDateStr(new Date(),-1));   //当前时间的前一天
	var tranodes = $("#itemCat").tree('getSelected');       /// 上级节点ID
	var LastLevID = "0";
	if (tranodes != null){
		LastLevID = tranodes.id;
	}
	$("#LastLevID").val(LastLevID);
	
}

/// 增加窗口
function showTraWin(){
	
	clearPanel();       /// 清空面板
	setPartLeafNote();  /// 增加部位叶子节点赋值
	DefDate();
	createNewWin();     /// 创建窗口

	
}

/// 创建增加窗口
function createNewWin(){
	
	if($('#addWin').is(":hidden")){
	   $('#addWin').window('open');
		return;
		}           ///窗体处在打开状态,退出	
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	flag="add";
	new WindowUX('增加', 'addWin', '400', '350', option).Init();
	
}


//创建更新窗口
function createUpdateWin(){	
	if($('updateWin').is(":hidden")){
	   $('updateWin').window('open');
		return;
		}           ///窗体处在打开状态,退出	
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	flag="update";
	new WindowUX('更新', 'updateWin', '400', '200', option).Init();


}
///  更新窗口
function UpdateTraWin(){
	
	clearPanel();            /// 清空面板
	var ret=setUpdateWin();  /// 增加部位叶子节点赋值
	if(ret==false){return;}
	//DefDate();             /// 2016-07-26
	createUpdateWin();       /// 创建窗口
}
/// 更新窗口
function setUpdateWin(){
	
	var tranodes = $("#itemCat").tree('getSelected');      /// 已选中节点
	if (tranodes == null){return false;}
	var leafnodeID = tranodes.id;	                   /// 叶子节点ID
	if (leafnodeID.indexOf("^") != "-1"){return false;}	
	$("#updateCatID").val(tranodes.id);                    /// 分类名称ID   2016-07-27
	$("#updateDesc").val(tranodes.text);                   /// 2016-07-26
	runClassMethod("web.DHCAPPTreeAdd","FindAlias",{"TraID":leafnodeID},function(data){
		$('#updalias').val(data);		
	},'',false)
	return true;

}
/// 增加部位叶子节点赋值
function setPartLeafNote(){

	var tranodes = $("#itemCat").tree('getSelected');    /// 已选中节点
	if (tranodes == null){return;}
	var leafnodeID = tranodes.id;
	$("#addDesc").val(tranodes.text)	                 /// 叶子节点ID
	var PartID="",TraItmID="";
	if (leafnodeID.indexOf("^") != "-1"){
		TraItmID = leafnodeID.split("^")[0];             ///子表ID
		PartID = leafnodeID.split("^")[1];
		$("#Part").combotree("setValue",PartID);         /// 部位
		$("#itemCatSubID").val(TraItmID);			     /// 分类子表ID
		var ParentNode=$("#itemCat").tree('getParent',tranodes.target);
		$("#addCatID").val(ParentNode.id);		/// 分类名称ID
		$("#addDesc").val(ParentNode.text);    		    /// 分类名称   2016-07-2
		runClassMethod("web.DHCAPPTreeAdd","FindAlias",{"TraID":ParentNode.id},function(data){
		$('#addalias').val(data);		
			},'',false)	}	
}
///  取消   2016/07/26
function cancelWinadd(){  
	if(flag=="add"){
		$('#addWin').window('close');
	}
}
function cancelWinupd(){  
	if(flag=="update"){
		$('#updateWin').window('close');
	}
}

/// 删除分类
function deleteItmCat(){
	var tranodes = $("#itemCat").tree('getSelected');     /// 已选中节点
	if (tranodes == null){return;}
    var leafnodeID = tranodes.id;		                  /// 叶子节点ID      
	 if ((tranodes != "")){
		$.messager.confirm("提示", "您确定要删除吗？", function (res) {
			if (res) {
				runClassMethod("web.DHCAPPTreeAdd","Delete",{"Id":leafnodeID},function(jsonString){
					if(jsonString==0)
					{
						$.messager.alert("提示", "删除成功！");
					
	    						$("#itemCat").tree('reload');
								$("#itemlist").datagrid('reload');
						
						}
						if(jsonString==-1)
						{
							$.messager.alert("提示", "存在子节点，不能删除！");
							}
							if(jsonString==-2)
							{
								$.messager.alert("提示", "存在子分类，不能删除！");
								}
					
				})
			}
		});
	}else {
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 删除医嘱项
function deleteRow(){
	
	var rowsData = $("#itemlist").datagrid('getSelected'); /// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除吗？", function (res) {
			/// 提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPTreeAdd","DelTreeLink",{"TraItmID":rowsData.TraItmID},function(jsonString){
					$('#itemlist').datagrid('reload');    /// 重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 清空面板
function clearPanel(){
	
	$("#itemCatID").val("");			     /// 检查分类ID
	$("#itemCatDesc").val("");			     /// 检查分类
	$("#addDesc").val("");					 /// 2016-07-26
	$("#updateDesc").val("");	             /// 2016-07-26
	$('#addalias').val("");
	$("#addCatID").val("");
	$("#updateCatID").val("");
	$("#itmmast").val();
	$("#itmdesc").val("");
	$("#Part").combotree("setValue","");     /// 部位
	$("#itemCatSubID").val("");   			 /// 部位ID
	$("#startDate").datebox("setValue","");  /// 开始日期
	$("#endDate").datebox("setValue","");    /// 截止日期 
}

///上移
function MoveOrdNumUp(){
	MoveOrdNum(-1);
}

///下移
function MoveOrdNumDown(){
	MoveOrdNum(1);
}
//移动函数
function MoveOrdNum(move){
	var tranodes = $("#itemCat").tree('getSelected');      // 已选中节点
	var ss= this;
	if (tranodes == null){return}
	var leafnodeID = tranodes.id;
							   // 叶子节点ID	                   
	runClassMethod("web.DHCAPPTreeAdd","Move",{"Id":leafnodeID, "Flag":move},function(jsonString){},'',false)
	$("#itemCat").tree('reload');	
}
function move(isUp,index) {
		var rows=$('#itemlist').datagrid('getData')
		if((isUp)&&(index==0)){
			return;
		}
		if(!(isUp)&&(index==rows.length)){
			return;
		}
		var nextId;
		if(isUp){
			nextId=rows.rows[index-1].TraItmID
		}else{
			nextId=rows.rows[index+1].TraItmID
		}
		var $view = $('div.datagrid-view');
		var $row = $view.find('tr[datagrid-row-index=' + index + ']');		
	    if (isUp) {
	            $row.each(function(){
	                    var prev = $(this).prev();
	                    prev.length && $(this).insertBefore(prev);
	    });
	    } else {
	            $row.each(function(){
	                    var next = $(this).next();
	                   next.length && $(this).insertAfter(next);
	            });
	    }
        runClassMethod(
	 				"web.DHCAPPTreeAdd",
	 				"MoveItmmast",
	 				{'Id':rows.rows[index].TraItmID,isUp:isUp,nextId:nextId},
	 				function(data){
   						$("#itemlist").datagrid('reload')
	 	            })

}
function moveUp(){move(true,rowIndexflag)}
function moveDown(){move(false,rowIndexflag)}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
