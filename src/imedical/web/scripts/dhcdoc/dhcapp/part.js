var curnode=0
var curselect=0
var partItmUrl='dhcapp.broker.csp?ClassName=web.DHCAPPPartItm&MethodName=list';
var partUrl='dhcapp.broker.csp?ClassName=web.DHCAPPPart&MethodName=list';
var editRow="",PartID="";
$(function(){ 
	//左边部位树的显示
	$('#partTree').tree({    
    	//url: LINK_CSP+"?ClassName=web.DHCAPPPart&MethodName=getTreeCombo",
    	//url: LINK_CSP+"?ClassName=web.DHCAPPPart&MethodName=jsonCheckPartByNodeID&id=0",  ///逐级加载 bianshuai 2016-09-09
    	url: LINK_CSP+"?ClassName=web.DHCAPPPart&MethodName=jsonCheckPartByOrdnum&id=0",  ///按顺序号逐级加载 sufan 2017-02-04
    	lines:true,
    	onClick: function(node){
			$("#datagrid").datagrid(
			{
				url:partUrl+"&parentId="+node.id	
			})
			$("#subdatagrid").datagrid('loadData',{total:0,rows:[]});
			curnode=node.id;
		},
		onContextMenu: function(e, node){
			e.preventDefault();
			// 查找节点
			$('#partTree').tree('select', node.target);
			//$("#datagrid").datagrid('load',{'parentId':node.id});
			curnode=node.id;
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}

	});
	
	/*$("input[name='root']").bind("click", function () {
		alert($('input[name="root"]:checked').val())
		$("#datagrid").datagrid(
		{
			url:partUrl,
			queryParams:{rootflag:$('input[name="root"]:checked').val()}	
		})
	});*/
	$HUI.checkbox("input[name='root']",{
		onCheckChange:function(e,value){
			$("#datagrid").datagrid(
			{
				url:partUrl,
				queryParams:{rootflag:$('input[name="root"]:checked').val()}	
			})
		}	
	});
	
	InitWidListener();  /// 绑定事件 bianshuai 2016-08-10
});
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGrid("web.DHCAPPPart","save","#datagrid",function(data){
		//修改
		if(data==0){
			$.messager.alert('提示','保存成功','success')
		}else if(data==-10){
			$.messager.alert('提示','保存失败，失败原因：部位代码或名称重复','warning');
			return;
		}else{
			$.messager.alert('提示','保存失败','warning')
			return;
		}
		$("#datagrid").datagrid('reload'); $('#partTree').tree('reload'); 
	});	
}


function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'APActiveFlag':'Y','APParPDr':curnode}})
}

function addCurRow(){
	 runClassMethod(
	 				"web.DHCAPPPart",
	 				"find",
	 				{'Id':curnode},
	 				function(data){
	 					commonAddRow({'datagrid':'#datagrid',value:{'APActiveFlag':'Y','APParPDr':data}}) 
	 				})
}


function selectRow(index,row){
	curselect=row.ID;	
	$("#subdatagrid").datagrid({
		url:partItmUrl,
		queryParams:{partId:row.ID}	
	});	
}
function addRowSub(){
	if(curselect==0){
		$.messager.alert("提示","先选择部位!");
		return;
	}
	commonAddRow({'datagrid':'#subdatagrid',value:{ParRefDr:curselect}})
}
function saveSub(){
	saveByDataGrid("web.DHCAPPPartItm","save","#subdatagrid",function(data){
		//修改
		if(data==0){
			$.messager.alert('提示','保存成功')
		}else if(data==-10){
			$.messager.alert('提示', '组合关联部位重复记录');
		}else{
			$.messager.alert('提示','保存失败')
		}
		$("#subdatagrid").datagrid('reload'); 
	});	
}

function onClickRowSub(index,row){
	CommonRowClick(index,row,"#subdatagrid");
}

function selectPart(p){
	if(p.id==curselect){
		$.messager.alert('提示','不能和自己关联')
		return;
	}	
}

function deleteSub(){
	
	var row=$("#subdatagrid").datagrid('getSelected')
	if (row){
		$.messager.confirm('提示', '你确定要删除吗?', function(r){
				if (r){
					runClassMethod(
	 				"web.DHCAPPPart",
	 				"remove",
	 				{'Id':row.ID},
	 				function(data){
	 					$("#subdatagrid").datagrid('reload')
	 				})
				}
		});
		
	}else{
		$.messager.alert('提示','请先选择')
	}
	
}

function move(isUp,index) {

		var rows=$('#datagrid').datagrid('getData')

		if((isUp)&&(index==0)){
			return;
		}
		if(!(isUp)&&(index==rows.length)){
			return;
		}
		var nextId;
		if(isUp){
			nextId=rows.rows[index-1].ID
		}else{
			nextId=rows.rows[index+1].ID
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
	 				"web.DHCAPPPart",
	 				"move",
	 				{'Id':rows.rows[index].ID,isUp:isUp,nextId:nextId},
	 				function(data){
   						$("#datagrid").datagrid('reload');
   						$("#partTree").tree('reload');   ///sufan 2017-02-04  刷新部位树 
	 	            })

}
function moveUp(index){move(true,index)}
function moveDown(index){move(false,index)}
function cellStyler(value,row,index){
	if(value==undefined){   //2016-07-18 qunianpeng
		value="" ;
	}	
	html="<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveUp("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-up l-btn-icon-left'>上移</span></span>"
	html=html+"</a>"
	html=html+"<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveDown("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-down l-btn-icon-left'>下移</span></span>"
	html=html+"</a>"
	html=html+"<span style='display:none;'>"+value+"</span>"   //sufan 2017-1-24  隐藏value 值
	return html;
}

/// 增加右键菜单 bianshuai 2016-08-10
function showRowContextMenu(e, rowIndex, rowData){
	e.preventDefault();
	$("#datagrid").datagrid("selectRow",rowIndex);
	$('#menu').menu('show', {    
	    left: e.pageX,
	    top: e.pageY
	}); 
}

/// 显示部位别名窗口
function showPartWin(){
	
	var rowsData = $("#datagrid").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		PartID = rowsData.ID;
		initPartWin();	
		initPartList();	
	}
}

/// Window 定义
function initPartWin(){
	
	/// 部位别名窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('别名窗体', 'PartWin', '600', '300', option).Init();
}

/// DataGrid 定义
function initPartList(){
	
	///  文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'ItemLabel',title:'别名',width:320,editor:textEditor}
		
	]];
	
	///  定义datagrid
	var option = {
		rownumbers : true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgPartList").datagrid('endEdit', editRow); 
            } 
            $("#dgPartList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};

	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPPart&MethodName=QueryPartAlias&PartID="+PartID;;
	new ListComponent('dgPartList', columns, uniturl, option).Init(); 
}

/// 界面元素监听事件
function InitWidListener(){

	$("div#tb a:contains('添加')").bind("click",insertRow);
	$("div#tb a:contains('删除')").bind("click",deleteRow);
	$("div#tb a:contains('保存')").bind("click",saveRow);
	
	///  拼音码
	//$("#ExaCatCode").bind("keyup",findPartItemTree);
	
	$('#ExaCatCode').searchbox({
		searcher : function (value, name) {
			var PyCode=$.trim(value);
			findPartItemTree(PyCode);
		}
	});
}

/// 插入新行
function insertRow(){

	if(editRow>="0"){
		$("#dgPartList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#dgPartList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ItemLabel:''}
	});
	$("#dgPartList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){

	var rowsData = $("#dgPartList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		var rowIndex = $("#dgPartList").datagrid('getRowIndex',rowsData);
		/// 删除行
		$("#dgPartList").datagrid('deleteRow',rowIndex);
			
		var selItems=$("#dgPartList").datagrid('getRows');
		$.each(selItems, function(index, selItem){
			$('#dgPartList').datagrid('refreshRow', index); /// 刷新当行
		})
		updateAlias();  //sufan  2017-05-23
	}
}
/// 删除别名后，更新表中数据 sufan  2017-05-23
function updateAlias(){

	var rowsData = $("#dgPartList").datagrid('getRows');
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if($.trim(rowsData[i].ItemLabel) == "") continue;
		dataList.push(rowsData[i].ItemLabel.toUpperCase());
	} 
	var params=dataList.join("/");
	//保存数据
	runClassMethod("web.DHCAPPPart","UpdPartAlias",{"PartID":PartID,"PartAlias":params},function(jsonString){

		if (jsonString != 0){
			return;	
		}
		$("#datagrid").datagrid(
			{
				url:partUrl+"&parentId="+PartID	
			});//sufan  2017-05-23  保存后，加载保存后的别名数据
	})
}
/// 保存
function saveRow(){

	if(editRow>="0"){
		$("#dgPartList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgPartList").datagrid('getRows');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if($.trim(rowsData[i].ItemLabel) == "") continue;
		dataList.push(rowsData[i].ItemLabel.toUpperCase());
	} 
	var params=dataList.join("/");

	//保存数据
	runClassMethod("web.DHCAPPPart","SavePartAlias",{"PartID":PartID,"PartAlias":params},function(jsonString){

		if (jsonString != 0){
			$.messager.alert('提示','保存失败！','warning');
			return;	
		}
		$("#datagrid").datagrid(
			{
				url:partUrl+"&parentId="+PartID	
			});    //sufan  2017-05-23  保存后，加载保存后的别名数据
	})
}

/// 检索检查部位项目
function findPartItemTree(PyCode){

	if (PyCode == ""){
		var url = LINK_CSP+'?ClassName=web.DHCAPPPart&MethodName=jsonCheckPartByNodeID&id=0';
	}else{
		var url = LINK_CSP+'?ClassName=web.DHCAPPPart&MethodName=jsonCheckPartByPyCode&PyCode='+PyCode;
	}
	
	$('#partTree').tree('options').url =encodeURI(url);
	$('#partTree').tree('reload');
}


//清空文件上传的路径 
function clearFiles (){
     var file = $("#filepath");
      file.after(file.clone().val(""));      
      file.remove();   
	
	}


// 导入部位中的数据
function ImportDataPart() {
    var efilepath = $("input[name=filepath]").val();
    //alert(efilepath)
    if (efilepath.indexOf("fakepath") > 0) {alert("请在IE下执行导入！"); return; }
    if (efilepath.indexOf(".xls") <= 0) { alert("请选择excel表格文件！"); return; }
    //var kbclassname = ""  //类名
    var sheetcount = 1  //模板中表的个数
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename != "part.xlsx")&&(filename != "part.xls")) {
	    clearFiles ()
        $.messager.alert('提示', '文件选择的不正确！');
        return;
    }

  try {
        var oXL = new ActiveXObject("Excel.application");
        var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);		
  }catch (e) {
        $.messager.alert('请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');

        return;
  }
    var sheet_id = 1
    var errorRow = "";//没有插入的行
    var errorMsg = "";//错误信息
    oWB.worksheets(sheet_id).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count;
    
    $.messager.progress({   //数据导入提示
		title:'请稍后', 
		msg:'数据正在导入中...' 
	}); 
    
    var inserToDB = function (i) { 
        if (i == rowcount+1) {
            //if (errorRow != "") {
               // errorMsg = oSheet.name + "表导入完成，第" + errorRow + "行插入失败!";
            //} else {
	            clearFiles ()
                errorMsg = oSheet.name + "表导入完成!"
                $.messager.progress('close')//数据导入完成关闭加载框
           // }
            alert(errorMsg)

            oWB.Close(savechanges = false);
            CollectGarbage();
            oXL.Quit();
            oXL = null;
            oSheet = null;
        }else {
			var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
			var row=i
            for (var j = 1; j <= colcount; j++) {
                var cellValue = ""
                if (typeof (oSheet.Cells(i, j).value) == "undefined") {
                    cellValue = ""
                } else {
                    cellValue = oSheet.Cells(i, j).value
                }

                tempStr += (cellValue + "[next]")
               
            }
              runClassMethod(
                    "web.DHCEMImpTools",
                    "SaveData",
                    { "dataStr": tempStr, "sheetid": sheet_id, "row": row, "HospID": LgHospID},
                    function (Flag) {
                             //alert(Flag)
                        if (Flag == true) {  
                            errorRow = errorRow             

                        } else {
                            if (errorRow != "") {
                                errorRow = errorRow + "," + i
                            } else {
                                errorRow = i
                            }
                            
                        }
                           i=i+1;
                           inserToDB(i);    
         
                });

        }
       
    } 
       inserToDB(1);
  
}



/*
// 导入部位中的数据
function  ImportData(){
	
	var pid=0;
	var filePath=$("input[name=filepath]").val();
	var fileName=filePath.substr(filePath.lastIndexOf('\\')+1);

	

    //导入数据
	runClassMethod("web.DHCEMImpTools","ImportLabItems",{"filepath":filePath},function(jsonString){
         
        if (jsonString == "-2"){
			$.messager.alert('提示','文件路径不能为空！');
			return;	
		}
		
		if(fileName!="part.txt"){
	       $.messager.alert('提示','文件路径选择的不正确！');
			return;	
		}
         
		if (jsonString =="-1"){
			clearFiles ()
			$.messager.alert('提示','数据不能重复导入！');
			return;	
		}
		
		
		if (jsonString == "1"){
			clearFiles ()
			$.messager.alert('提示','导入数据成功！');
			//$('#partTree').datagrid('reload'); //重新加载
			$('#partTree').tree('reload'); //重新加载
			return;	
		}
		
		if(jsonString){
			clearFiles ()

		$('#PreSent').window({
			title:'列表信息',
			collapsible:false,
			border:false,
			closed:false,
			width:500,
			height:350
		});
	
	
		var columns=[[
        {field:'PartCode',title:'Code',width:80},
		{field:'PartDesc',title:'描述',width:150},
		{field:'LastRowid',title:'上一级ID',width:100},
		{field:'PartNum',title:'数量',width:50}

	
	]];
	
  // 定义datagrid
	$('#win').datagrid({
		//title:'列表信息',
		url:LINK_CSP+"?ClassName=web.DHCEMImpTools&MethodName=GetImpWarnData&pid="+jsonString,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:5,  // 每页显示的记录条数
		pageList:[30,60],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	
   });
		
  }
		
	$('#dgPartList').datagrid('reload'); //重新加载
})	
}

*/

/// 上移动
function moveup()
{
	runClassMethod("web.DHCAPPPart","MoveUp",{"Id":curnode},function(jsonString){

		if (jsonString == 0){
			
			$('#partTree').tree('reload'); //重新加载
			
			$('#datagrid').datagrid('reload'); //重新加载
			
			$('#subdatagrid').datagrid('reload'); //重新加载
		}
		
	})
}
///下移
function movedown()
{
	runClassMethod("web.DHCAPPPart","MoveDown",{"Id":curnode},function(jsonString){

		if (jsonString == 0){
			
			$('#partTree').tree('reload'); //重新加载
			
			$('#datagrid').datagrid('reload'); //重新加载
			
			$('#subdatagrid').datagrid('reload'); //重新加载
		}
	})
}
