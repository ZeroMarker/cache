/**
 * 模块:门诊药房
 * 子模块:住院药房-首页-侧菜单-门诊药房维护
 * createdate:2016-07-07
 * creator: yunhaibao
 */
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.phcode.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gridChkIcon='<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>'
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
}
$(function(){
	InitPhaLoc();
	InitPhaLocGrid();		
	$('#btnAdd').on('click',function(){
		$('#phcodewin').window({'title':"门诊发药科室维护增加"});
		$('#phcodewin').window('open');
		$("input[type=checkbox][name=chkcondition]").prop('checked',false);
		$("input[name=txtconditon]").val("");
		$("#phaLoc").combobox("setValue","");
		phLocRowId="";
		$("#phaLoc").combobox('enable');
		$("#dispMath").combobox("setValue",1);
	});
	$('#btnUpdate').on('click', btnUpdateHandler);//点击修改
	$('#btnSave').on('click',btnSaveHandler);
	$('#btnCancel').on('click',function(){
		$('#phcodewin').window('close');
	});
	$('#phlocgrid').datagrid("reload") 
});
function InitPhaLoc(){
	var options={
		url:commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId
	}
	$('#phaLoc').dhcphaEasyUICombo(options);
}
//初始化发药科室列表
function InitPhaLocGrid(){
	//定义columns
	var columns=[[
	    {field:'Tphlid',title:'Tphlid',width:50,hidden:true},
        {field:'Tyfid',title:'Tyfid',width:100,hidden:true},
        {field:'Tdesc',title:'药房名称',width:150},
        {field:'Tyfsf',title:'取药算法',width:100},
        {field:'TCyFlag',title:'中草药',width:50,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
		        	return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TAuditFlag',title:'处方审核',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'Tbyfs',title:'提前摆药',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'Tpysure',title:'配药确认',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TAutoPyFlag',title:'自动打印</br>配　　药',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'Tpy',title:'配药',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'Tfy',title:'发药',width:55,align:'center',hidden:true,
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TOthLocRet',title:'跨科室退药',width:65,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TDispMachine',title:'发药机',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TSendFlag',title:'发送数据',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TPrintFlag',title:'分配打印机',width:65,align:'center',hidden:true,
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TWinTypeFlag',title:'窗口分类',width:55,align:'center',hidden:true,
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TScreenFlag',title:'显示屏',width:50,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="是"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TScreenPath',title:'显示路径',width:100}
	]];  
	
   //定义datagrid	
   $('#phlocgrid').datagrid({    
        url:url+'?action=QueryPhLocCode',
	    border:false,
	    toolbar:'#btnbar1',
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
	    singleSelect:true,
	    fitColumns:true,
	    striped:true,
	    loadMsg: '正在加载信息...',
	    onSelect:function(rowIndex,rowData){
		},
		onLoadSuccess: function(){       	
	    },
	    onLoadError:function(data){
			$.messager.alert("错误","加载数据失败,请查看错误日志!","warning")
			$('#phlocgrid').datagrid('loadData',{total:0,rows:[]});
			$('#phlocgrid').datagrid('options').queryParams.params = ""; 
		}  
   });
}


//保存发药科室配置
function btnSaveHandler(){
	var phLocRowId="";
	var winTitle=$("#phcodewin").panel('options').title;
	if (winTitle.indexOf("修改")>=0){
		var phalocselect = $("#phlocgrid").datagrid("getSelected");
		if (phalocselect==null){
			$.messager.alert('提示',"请先选中需修改的行!","info");
			return;
		}
		phLocRowId=phalocselect.Tphlid;
	}else if (winTitle.indexOf("增加")>=0){
		phLocRowId="";
	}else{
		return;
	}
	var locRowId=$("#phaLoc").combobox("getValue");
	if (($.trim($("#phaLoc").combobox("getValue"))=="")||(locRowId==undefined)){
		locRowId="";
		$.messager.alert('提示',"发药科室必填!","info");
		return;
	}
	var dispmath=$("#dispMath").combobox("getValue");
	if ((dispmath=="")||(dispmath==undefined)){
		$.messager.alert('提示',"取药算法必填!","info");
		return;
	}
	var screenpath=$("#screenPath").val();
	var chkpy="0"
	if ($("#chkPY").is(':checked')){
		chkpy="1";
	}
	var chkfy="0"
	if ($("#chkFY").is(':checked')){
		chkfy="1";
	}
	var chktq="0"
	if ($("#chkTQ").is(':checked')){
		chktq="1";
	}
	var chkzcy="0"
	if ($("#chkZCY").is(':checked')){
		chkzcy="1";
	}
	var chksend="0"
	if ($("#chkSend").is(':checked')){
		chksend="1";
	}
	var chkprint="0"
	if ($("#chkPrint").is(':checked')){
		chkprint="1";
	}
	var chkwintype="0"
	if ($("#chkWinType").is(':checked')){
		chkwintype="1";
	}
	var chkmachine="0"
	if ($("#chkMachine").is(':checked')){
		chkmachine="1";
	}
	var chkscreen="0"
	if ($("#chkScreen").is(':checked')){
		chkscreen="1";
	}
	var chksure="0"
	if ($("#chkSure").is(':checked')){
		chksure="1";
	}
	var chkautopy="0"
	if ($("#chkAutoPY").is(':checked')){
		chkautopy="1";
	}
	var chkaudit="N"
	if ($("#chkAudit").is(':checked')){
		chkaudit="Y";
	}
	var chkotherlocret="N"
	if ($("#chkOtherLocRet").is(':checked')){
		chkotherlocret="Y";
	}
	var params=phLocRowId+"^"+locRowId+"^"+chkpy+"^"+chkfy+"^"+dispmath+"^"+chktq
			   +"^"+chkzcy+"^"+gUserId+"^"+chksend+"^"+chkprint+"^"+chkwintype
			   +"^"+chkmachine+"^"+chkscreen+"^"+screenpath+"^"+chksure+"^"+chkautopy
			   +"^"+chkaudit+"^"+chkotherlocret	  
	var saveret=tkMakeServerCall("web.DHCOUTPHA.PhCode","SavePhLocCode",params)
	if (saveret=="0"){
		$.messager.alert('提示',"保存成功!","info");
		$('#phcodewin').window('close');
		$('#phlocgrid').datagrid('reload');
	}else if (saveret==""){
		$.messager.alert('提示',"当前用户非本药房用户,请先在药房人员维护中添加,再进行相关操作!","info");
	}else if (saveret==1){
		$.messager.alert('提示',"该发药科室已存在，不允许重复添加!","warning");
	}else{
		$.messager.alert('错误提示',"保存失败,错误代码:"+saveret,"warning");
	}
}
//修改发药类别
function btnUpdateHandler(){
	var phalocselect = $("#phlocgrid").datagrid("getSelected");
	if (phalocselect==null){
		$.messager.alert('提示',"请先选中需修改的行!","info");
		return;
	}
	$('#phcodewin').window({'title':"门诊发药科室维护修改"});
	$('#phcodewin').window('open');
	$("input[type=checkbox][name=chkcondition]").prop('checked',false);
	$("input[name=txtconditon]").val("");	
	if (phalocselect["Tpy"]=="是"){
		$('#chkPY').prop('checked',true);
	}
	if (phalocselect["Tfy"]=="是"){
		$('#chkFY').prop('checked',true);
	}
	if (phalocselect["Tbyfs"]=="是"){
		$('#chkTQ').prop('checked',true);
	}
	if (phalocselect["TCyFlag"]=="是"){
		$('#chkZCY').prop('checked',true);
	}
	if (phalocselect["TSendFlag"]=="是"){
		$('#chkSend').prop('checked',true);
	}
	if (phalocselect["TPrintFlag"]=="是"){
		$('#chkPrint').prop('checked',true);
	}
	if (phalocselect["TWinTypeFlag"]=="是"){
		$('#chkWinType').prop('checked',true);
	}
	if (phalocselect["TDispMachine"]=="是"){
		$('#chkMachine').prop('checked',true);
	}
	if (phalocselect["TScreenFlag"]=="是"){
		$('#chkScreen').prop('checked',true);
	}
	if (phalocselect["Tpysure"]=="是"){
		$('#chkSure').prop('checked',true);
	}
	if (phalocselect["TAutoPyFlag"]=="是"){
		$('#chkAutoPY').prop('checked',true);
	}
	if (phalocselect["TAuditFlag"]=="是"){
		$('#chkAudit').prop('checked',true);
	}
	if (phalocselect["TOthLocRet"]=="是"){
		$('#chkOtherLocRet').prop('checked',true);
	}
	$("#screenPath").val(phalocselect["TScreenPath"]);
	$("#phaLoc").combobox("setValue",phalocselect["Tyfid"]);
	$("#phaLoc").combobox("setText",phalocselect["Tdesc"]);
	var dispmath=phalocselect["Tyfsf"];
	$("#dispMath").combobox("setText",phalocselect["Tyfsf"]);
	if (dispmath=="按照次序"){
		$("#dispMath").combobox("setValue",1);
	}else if(dispmath=="按照工作量"){
		$("#dispMath").combobox("setValue",2);
	}
	$("#phaLoc").combobox('disable')
}



