/** Descript  : FTP地址表维护
 *  Creator   : sufan
 *  CreatDate : 2017-08-21
 */
var editRow = ""; 
$.extend($.fn.datagrid.defaults.editors,{ //huaxiaoying 2018-02-06 st 密码编辑时的加密
      password: {//datetimebox就是你要自定义editor的名称
         init: function(container, options){
             var input = $('<input style="border:none;width:100%" type="password">').appendTo(container);
             return input
         },
         getValue: function(target){
             return $(target).val();
        },
         setValue: function(target, value){
             $(target).val(value);
         },
         resize: function(target, width){
         }
     }
});  //hxy ed
/// 页面初始化函数
function initPageDefault(){
	
	initFTPlist();          /// 初始页面DataGrid
	initButton();           /// 页面Button绑定事件	
}

///申请状态列表 
function initFTPlist(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 定义columns
	var columns=[[
		{field:"FTPCode",title:'代码',width:100,align:'center',editor:textEditor},
		{field:"FTPDesc",title:'描述',width:100,align:'center',editor:textEditor},
		{field:"FTPAddressIP",title:'IP地址',width:160,align:'center',editor:textEditor},
		{field:"FTPPort",title:'端口',width:100,align:'center',editor:textEditor},
		{field:"FTPUserName",title:'用户名',width:100,align:'center',editor:textEditor},
		{field:"FTPPassWord",title:'密码',width:100,align:'center',editor:"password", //huaxiaoying 2018-02-06 st
			formatter: function(value,row,index){ return "***";} //ed
        },
		{field:"FTPRowID",title:'ID',width:20,align:'center',hidden:'true'}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0){ 
                $("#ftplist").datagrid('endEdit', editRow); 
            } 
            $("#ftplist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCPHFTPConfig&MethodName=QueryFTPConfig';
	new ListComponent('ftplist', columns, uniturl, option).Init(); 
}

/// 页面 Button 绑定事件
function initButton(){
	
	///  增加
	$('#insert').bind("click",insertFTPRow);
	
	///  保存
	$('#save').bind("click",saveFTPRow);
	
	///  删除
	$('#delete').bind("click",deleteFTPRow);
	
	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findStatuslist(); //调用查询
        }
    });
    
     // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findftplist(); //调用查询
    });
    
     //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findftplist(); //调用查询
    }); 
}

/// 插入申请状态
function insertFTPRow(){

	if(editRow>="0"){
		$("#ftplist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#ftplist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {FTPRowID:'',FTPCode:'',FTPDesc:'',FTPAddressIP:'',FTPUserName:'',FTPPassWord:'',FTPPort:''}
	});
    
	$("#ftplist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
///保存申请状态
function saveFTPRow(){
	
	if(editRow>="0"){
		$("#ftplist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#ftplist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].FTPCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行代码为空！"); 
			return false;
		}
		if(rowsData[i].FTPDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行描述为空！"); 
			return false;
		}
		if(rowsData[i].FTPAddressIP==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行IP地址为空！"); 
			return false;
		}
		if(rowsData[i].FTPUserName==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行用户名为空！"); 
			return false;
		}
		if(rowsData[i].FTPPassWord==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行密码为空！"); 
			return false;
		}
		if(rowsData[i].FTPPort==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行端口为空！"); 
			return false;
		}
		if(isValidIP(rowsData[i].FTPAddressIP)==false){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行IP格式不对，请重新输入！"); 
			return false;
		}
		var tmp=rowsData[i].FTPRowID +"^"+ rowsData[i].FTPCode +"^"+ rowsData[i].FTPDesc +"^"+ rowsData[i].FTPAddressIP +"^"+ rowsData[i].FTPUserName +"^"+ rowsData[i].FTPPassWord +"^"+ rowsData[i].FTPPort;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCPHFTPConfig","SaveFTPConfig",{"params":params},function(jsonString){
		if ((jsonString == "-1")||(jsonString == "-2")){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}
		$('#ftplist').datagrid('reload'); //重新加载
	});
}
///判断是否是ip类型
function isValidIP(ip) {
    var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
    return reg.test(ip);
} 
/// 删除
function deleteFTPRow(){
	
	var rowsData = $("#ftplist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCPHFTPConfig","DeleteFTPConfig",{"FTPRowID":rowsData.FTPRowID},function(jsonString){
					$('#ftplist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
// 查询
function findftplist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#ftplist').datagrid('load',{params:params}); 
}	 
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
