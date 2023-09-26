/// author:    yangzongyi
/// date:      2020-04-11
/// descript:  短消息字典维护

var editRow = ""; editDRow = "";
/// 页面初始化函数
function initPageDefault(){
	
	//初始化咨询信息列表
	InitMainList();
	
	//初始化界面按钮事件
	InitWidListener();
	
	setTimeout(function(){  //hxy 2020-05-06 st
	    var DescH=$("#NoteP").height()-40;
		$("#itemTempDesc").css("height",DescH+"px"); 
	}, 500); //ed
}

/// 界面元素监听事件
function InitWidListener(){
	/**
	 * 注意事项模板字典
	 */
	$("div#tb a:contains('新增')").bind("click",insertRow);
	$("div#tb a:contains('删除')").bind("click",deleteRow);
	$("div#tb a:contains('保存')").bind("click",saveRow);
	
	/**
	 * 注意事项明细
	 */
	$("div#dtb a:contains('保存')").bind("click",saveItmTmpNotes);
	$("div#dtb a:contains('清空')").bind("click",clearItmTmpNotes);
	$("div#dtb a:contains('删除')").bind("click",delItmTmpNotes);
	
	$($(".keyLi")).on('click',function(){ //hxy 2020-05-06 st
		if($(this).hasClass('selected')){
			$(this).removeClass('selected')	
		}else{
			$($(".keyLi")).not(this).removeClass('selected')
			$(this).addClass('selected');
		}
	}) //ed
	
}

///初始化病人列表
function InitMainList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var ActFlagArr = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
	//设置其为可编辑
	var activeEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	/// 医院
	var HospEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'left'}, //hxy 2020-05-06 左对齐
		{field:'Code',title:'代码',width:100,editor:textEditor,align:'left'},
		{field:'Desc',title:'描述',width:150,editor:textEditor,align:'left'},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'ActDesc',title:'是否可用',width:80,editor:activeEditor,align:'left'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'left'},
		{field:'HospDesc',title:'医院',width:200,editor:HospEditor,align:'left'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'MDT短信息配置',
		headerCls:'panel-header-gray', //hxy 2020-05-06 st
		border:true,
		iconCls:'icon-paper',//ed
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
			$('#itemTempDesc').val("");
			GetItemTempNotes(rowData.ID);
			
			//$("#item").datagrid('reload',{mID:rowData.ID});
	    },
		onLoadSuccess:function(data){
			var rows = $("#dgMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#dgMainList').datagrid('selectRow',0);
				var rowData = $('#dgMainList').datagrid('getSelected');
				GetItemTempNotes(rowData.ID);
			}
		}
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTSMSTemp&MethodName=QryConsultGroup";
	new ListComponent('dgMainList', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTSMSTemp","Save",{"mListData":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#dgMainList').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#dgMainList").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'是', HospID:'', HospDesc:''}
	});
	$("#dgMainList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#dgMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTSMSTemp","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('提示','此项已和医嘱项绑定,不能删除！','warning');
					}
					$('#dgMainList').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 保存编辑行
function saveItmTmpNotes(){
	
	var rowsMData = $("#dgMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsMData == null){
		$.messager.alert("提示", "请先选中模板字典，然后点击添加！");
		return;
	}
    var dataList = [];
	var itemTempId = $("#itemTempId").val();   		///子表ID
	var itemTempDesc = $("#itemTempDesc").val(); 	///注意事项文字描述
	if(itemTempDesc==""){
		$.messager.alert("提示", "请维护短信明细");
		return;
		}
	var tmp=itemTempId +"^"+ rowsMData.ID +"^"+ itemTempDesc;
	 dataList.push(tmp);
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTSMSTemp","SaveItem",{"mListData":mListData},function(jsonString){
       if (jsonString == 0){
			$.messager.alert("提示", "保存成功！");
			GetItemTempNotes(rowsMData.ID);
		}else{
			$.messager.alert("提示", "保存失败！");
		}
	})
}

function delItmTmpNotes(){
	
	var rowsMData = $("#dgMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsMData == null){
		$.messager.alert("提示", "请先选中模板字典，然后点击添加！");
		return;
	}
	
	var itemTempId = $("#itemTempId").val();   		///子表ID
	if (itemTempId == ""){
		$.messager.alert("提示", "删除失败,失败原因:数据为空！");
		return;
	}
	$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
		if (res) {
			runClassMethod("web.DHCMDTSMSTemp","deleteItem",{"ID":itemTempId},function(jsonString){
				if (jsonString == 0){
					$.messager.alert("提示", "删除成功！");
					GetItemTempNotes(rowsMData.ID);
				}else{
					$.messager.alert("提示", "删除失败！");
				}
			})
		}
	});
}



/// 取模板字典描述
function GetItemTempNotes(ID){
	
	$("#itemTempId").val("");     ///子表ID
	$('#itemTempDesc').val("");  ///清空

	/// 查询数据
	runClassMethod("web.DHCMDTSMSTemp","GetItemTempNotes",{"ID":ID},function(jsonString){

		if (jsonString != null){
			var jsonObj = jsonString;
			$('#itemTempId').val(jsonObj.itemTempId);  ///注意事项ID
			$('#itemTempDesc').val(jsonObj.itemTempDesc.replace(new RegExp("<br>","g"),"\r\n"));  ///注意事项    ///sufan  2017-02-16  修改IE8回车不起作用
		}
	})
}

/// 清空
function clearItmTmpNotes(){

	$("#itemTempDesc").val('');
}

 /* $(".btn-danger").on("click", function() {
	        alert("ggm")
	        var pos=getFieldPos();
            //$("#itemTempDesc").insertAtCaret($(this).attr("data-param"));
            insertPos(pos,"商家")
        }); */

function win1(){
	        //var value=$("#btn1").val(); //hxy 2020-05-06 st
	        var value=$("#btn1").attr("data"); //ed
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}
  
  function win2(){
	        //var value=$("#btn2").val();
	        var value=$("#btn2").attr("data");
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}      
       
function win3(){
	        //var value=$("#btn3").val();
	        var value=$("#btn3").attr("data");
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}

function win4(){
	        //var value=$("#btn4").val();
	        var value=$("#btn4").attr("data");
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}

function win5(){
	        //var value=$("#btn5").val();
	        var value=$("#btn5").attr("data");
	        var pos=$("#itemTempDesc").getFieldPos();
            $("#itemTempDesc").insertPos(pos,value)
	}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })