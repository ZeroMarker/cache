/*
模块:门诊药房
子模块:门诊药房-首页-侧菜单-配药窗口定义
createdate:2016-07-07
creator:dinghongying
*/
var HospId=session['LOGON.HOSPID'];
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
	InitHospCombo();
	InitPYWinCodeList();	
	var LocDescCombo=new ListCombobox("LocDesc",commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId+'&HospId='+HospId,'',combooption);
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
     	queryParams:{
			HospId:HospId
		},
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
		return;
	}
	if(WinDesc==""){
		$.messager.alert('提示',"请输入窗口名称!","info");
		return;
	}
	var retValue= tkMakeServerCall("PHA.OP.CfPyWin.OperTab","Insert",LocRowId,WinDesc,BoxNum,SendCode);
	var retCode = retValue.split("^")[0];
	var retMessage = retValue.split("^")[1];
	if (retCode != 0) {
		$.messager.alert('提示', retMessage, "warning");
		return;
	} else {
		$.messager.alert('提示',"增加成功!","info");
		$('#PYWinCodedg').datagrid('reload');
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
	var RowId=selected.TPhPyWin;
	var ctLocId=selected.TLocId;
	var LocRowId=$("#LocDesc").combobox("getValue");
	if (ctLocId != LocRowId) {
		$.messager.alert('提示', "不允许修改药房!", "warning");
		return;
	}
	var WinDesc=$("#WinDesc").val();
    var BoxNum=$("#BoxNum").val();
    var SendCode=$("#SendCode").val();
	var retValue=tkMakeServerCall("PHA.OP.CfPyWin.OperTab","Update",RowId,WinDesc,BoxNum,SendCode);
	var retCode = retValue.split("^")[0];
	var retMessage = retValue.split("^")[1];
	if (retCode != 0) {
		$.messager.alert('提示', retMessage, "warning");
		return;
	} else {
		$.messager.alert('提示', "修改成功!", "info");
		$('#PYWinCodedg').datagrid('reload');
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
				var retValue=tkMakeServerCall("PHA.OP.CfPyWin.OperTab","Delete",RowId);
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
	var LocId=$("#LocDesc").combobox("getValue")
	var WinDesc=$("#WinDesc").val();
	var params=LocId+"^"+WinDesc;
	$('#PYWinCodedg').datagrid('options').queryParams.params = params;//传递值  
    $("#PYWinCodedg").datagrid('reload');//重新加载table  
}

function Clear(){
	$("#LocDesc").combobox("setValue","");
	$("#WinDesc").val("");
	$("#BoxNum").val("");
	$("#SendCode").val("");
	$('#PYWinCodedg').datagrid('options').queryParams.params = "";
	$('#PYWinCodedg').datagrid('options').queryParams.HospId = HospId;
    $("#PYWinCodedg").datagrid('reload');	
}

function InitHospCombo(){
	var genHospObj =DHCSTEASYUI.GenHospComp({tableName:'PHA-OP-PreWindow'}); //加载医院
	if (typeof genHospObj === 'object') {
		//增加选择事件
		$('#_HospList').combogrid("options").onSelect=function(index,record){
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
				$('#LocDesc').combobox('loadData',[]);
				$('#LocDesc').combobox('options').url=commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+session['LOGON.USERID']+'&HospId='+HospId;
				$('#LocDesc').combobox('reload');	
				Clear();	
			}
		};
	}
}