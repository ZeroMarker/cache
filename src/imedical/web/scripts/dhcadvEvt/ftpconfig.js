var dgrow=0;
var HospDr="";
$(function(){ 
    //初始化医院 多院区改造 cy 2021-04-09
    InitHosp(); 
	//初始化界面默认信息
	InitDefault();
	
});
function InitDefault(){ 
	$.extend($.fn.datagrid.defaults.editors,{ //huaxiaoying 2018-02-06 st 密码编辑时的加密
	      password: {//datetimebox就是你要自定义editor的名称
	         init: function(container, options){
	             var input = $('<input style="border:none;width:100%" type="password">').appendTo(container);
	             //options:{valueField:'value',textField:'text',editable:true}}
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
	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}
	
	$(":radio").click(function(){
   		commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
  	});
	findftplist();    ///调用查询
}
// 初始化医院 多院区改造 cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvFTPConfig"); 
	HospDr=hospComp.getValue();
	//hospComp.setValue("全部"); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///选中事件
 		HospDr=hospComp.getValue();
 		findftplist();    ///调用查询
	}
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
	dgrow=index;
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{hospDr:HospDr,hospDrID:HospDr}}) //hxy 2019-07-03 LgHospID
}

function save(){
	if(!endEditing("#datagrid")){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		if(rowsData[i].FTPRowID==undefined)
		{
		  rowsData[i].FTPRowID=""
		}
		var index = $("#datagrid").datagrid("getRowIndex",rowsData[i]) +1;
		if(isValidIP(rowsData[i].FTPAddressIP)==false){
			$.messager.alert("提示","第"+index+"行IP格式不对，请重新输入！"); 
			return false;
		}
		if(rowsData[i].FTPPassWord==""){
			$.messager.alert("提示","第"+index+"行密码为空，请输入密码！"); 
			return false;
		}
		var tmp=rowsData[i].FTPRowID +"^"+ rowsData[i].FTPCode +"^"+ rowsData[i].FTPDesc +"^"+ rowsData[i].FTPAddressIP +"^"+ rowsData[i].FTPPort +"^"+ rowsData[i].FTPUserName +"^"+ rowsData[i].FTPPassWord+"^"+ rowsData[i].hospDrID;
		dataList.push(tmp);
	} 
	    var params=dataList.join("$$");
       runClassMethod("web.DHCADVFTPConfig","SaveFTPConfig",{"params":params},function(jsonString){
		if ((jsonString == "-1")||(jsonString == "-2")){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}
		if(jsonString==0)
		{
			$.messager.alert('提示',"保存成功")
		}
		$('#datagrid').datagrid('reload'); //重新加载
	});
}

/// 删除
function delRow(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择数据!");
		return;	
	}
	
	$.messager.confirm("操作提示", "确认要删除数据吗？", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVFTPConfig",
				    "DeleteFTPConfig",
					{
		 				'FTPRowID':rowsData.FTPRowID
		 			},
		 			function(data){
			 			//修改
						if(data==0){
							$.messager.alert('提示','删除成功');
							$("#datagrid").datagrid('reload'); 
						}else{
						     $.messager.alert('提示','删除失败:'+data)	
						     }
					},"text");
            } 
    }); 
}
///判断是否是ip类型
function isValidIP(ip) {
    var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
    return reg.test(ip);
} 
// 查询
function findftplist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#datagrid').datagrid('load',{params:params,HospID:HospDr}); 	
}	 
