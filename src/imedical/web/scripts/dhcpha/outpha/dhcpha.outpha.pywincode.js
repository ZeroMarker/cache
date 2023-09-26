/*
模块:门诊药房
子模块:门诊药房-首页-侧菜单-配药窗口定义
createdate:2016-07-07
creator:dinghongying
*/

var commonOutPhaUrl ="DHCST.OUTPHA.ACTION.csp";
var thisurl = "dhcpha.outpha.pywincode.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitPYWinCodeList();	
	var LocDescCombo=new ListCombobox("LocDesc",commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId+'','',combooption);
	LocDescCombo.init(); //初始化药房名称	
	$('#Badd').on('click', Add);//点击增加
	$('#Bupdate').on('click', Update);//点击修改
	$('#BDelete').on('click', Delete);//点击删除
	$('#BDelete').hide();
	$('#Bfind').on('click',Query);//隐藏删除按钮
	$("#BClear").on('click',Clear)
});

//初始化配药窗口定义列表
function InitPYWinCodeList(){
	//定义columns
	var columns=[[
	    {field:'TLocId',title:'TLocId',width:200,hidden:true},
	    {field:'TPhPyWin',title:'TPhPyWin',width:200,hidden:true},
	    {field:'TPhlid',title:'TPhlid',width:200,hidden:true},
	    {field:'TLocDesc',title:'药房名称',width:200,align:'left'},
	    {field:'TWinDesc',title:'窗口名称',width:200,align:'left'},
	    {field:'TBoxNum',title:'药框数',width:200,align:'right'},
	    {field:'TSendCode',title:'传入端口号',width:200,align:'right'}
	]];  
   //定义datagrid	
   $('#PYWinCodedg').datagrid({    
        url:thisurl+'?action=GetPYWinCodeList',
        fit:true,
	    border:false,
	    striped:true,
	    toolbar:'#btnbar',
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:30,  // 每页显示的记录条数
	    pageList:[30,50,100],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onSelect:function(rowIndex,rowData){
			if (rowData){
				var RowId=rowData['TRowId'];
				var locdesc=rowData['TLocDesc'];
				var locid=rowData['TLocId'];
				var windesc=rowData['TWinDesc'];
				var boxnum=rowData['TBoxNum'];
				var sendcode=rowData['TSendCode'];
				$("#LocDesc").combobox('setValue',locid);
				$("#LocDesc").combobox('setText',locdesc);
				$("#WinDesc").val(windesc);
				$("#BoxNum").val(boxnum);
				$("#SendCode").val(sendcode);
				//$("#LocDesc").combobox('disable')
			}
		} 
   });
}
///配药窗口增加
function Add()
{
	var LocRowId=$("#LocDesc").combobox("getValue");
	var WinDesc=$("#WinDesc").val();
	var BoxNum=$("#BoxNum").val();
	var SendCode=$("#SendCode").val();
	if((LocRowId=="")||(LocRowId==undefined)){
		$.messager.alert('提示',"请选择药房名称!","info");
	}
	if(WinDesc==""){
		$.messager.alert('提示',"请输入窗口名称!","info");
	}
	else{
		var retValue= tkMakeServerCall("web.DHCOutPhCode","insertPhPyWin",LocRowId,WinDesc,BoxNum,SendCode);
		if(retValue==0){
			$.messager.alert('提示',"增加成功!","info");
			$('#PYWinCodedg').datagrid('reload');
		}else if(retValue==-2){
			$.messager.alert('提示',"该配药窗口已定义，请重新进行添加!","warning");
		}else if(retValue==-4){
			$.messager.alert('提示',"请先在门诊药房科室维护中增加该药房!","warning");
		}else{
			$.messager.alert('提示',"添加失败,错误代码:"+retValue,"warning");
		}
	}
}
///配药窗口修改
function Update()
{
	var selected = $("#PYWinCodedg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('提示',"请先选中需要修改的数据!","info");
		return;
	}
	else{
		var RowId=selected.TPhPyWin;
		var WinDesc=$("#WinDesc").val();
	    var BoxNum=$("#BoxNum").val();
	    var SendCode=$("#SendCode").val();
		var retValue=tkMakeServerCall("web.DHCOutPhCode","UpdatePhPyWin",RowId,WinDesc,BoxNum,SendCode);
		if(retValue==0){
			$.messager.alert('提示',"修改成功!");
			$('#PYWinCodedg').datagrid('reload');
		}else if (retValue=="-1"){
			$.messager.alert('提示',"修改后窗口名称已存在!","info");
		}
		else {
			$.messager.alert('提示',"修改失败,错误代码:"+retValue);
		}
	}
}
///配药窗口删除
function Delete(){
	var selected = $("#PYWinCodedg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('提示',"请先选中需要删除的数据!","info");
		return;
	}
	else{
		var RowId=selected.PhPyWin
		$.messager.confirm('提示',"确认删除吗？",function(r){
			if(r){
				var retValue=tkMakeServerCall("web.DHCOutPhCode","DeletePhPyWin",RowId);
				if(retValue==0){
					$.messager.alert('提示',"删除成功!");
					$('#PYWinCodedg').datagrid('reload');
				}
				else{
					$.messager.alert('提示',"删除失败,错误代码:"+retValue,"warning");
				}
			}
		});
	}
}
///配药窗口列表查询
function Query(){
	var params=$("#LocDesc").combobox("getValue");
	$('#PYWinCodedg').datagrid('options').queryParams.params = params;//传递值  
    $("#PYWinCodedg").datagrid('reload');//重新加载table  
}

function Clear(){
	$("#LocDesc").combobox("setValue","");
	$("#WinDesc").val("");
	$("#BoxNum").val("");
	$("#SendCode").val("");
	$('#PYWinCodedg').datagrid('options').queryParams.params = "";
    $("#PYWinCodedg").datagrid('reload');	
}