var ArcimListDataGrid;
var ArcimRowId="";
$(function(){
   InitHospList(); 
   InitEvent();
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_ArcimExt");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#Text_InputStr").val("");
		$("#Check_StopAfterLongOrder,#Check_NotAutoStop").checkbox('uncheck');
		ArcimListDataGrid.datagrid('loadData',{total:0,rows:[]})
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitArcimList();
		InitTip();
		InitCache();
	}
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitEvent() {
	$("#Text_InputStr").bind("keydown",InputStrKeydownHandle);
	$HUI.checkbox("#Check_StopAfterLongOrder",{
        onChecked:function(e,value){
            CheckBoxClickHandler();
            if(ArcimRowId!=""){
	            var index=$('#tabArcimList').datagrid('getRowIndex',ArcimRowId);
	            var rows=$('#tabArcimList').datagrid('getRows');
	            if (rows[index].DischargeOrdFlag==0) {
	            	$("#Check_AllowLongOrder").checkbox('setDisable',false);
	            }
	        }
        },
        onUnchecked:function(e,value){
	        $("#Check_AllowLongOrder").checkbox('uncheck');
			$("#Check_AllowLongOrder").checkbox('setDisable',true);
	    }
    });
    $HUI.checkbox("#Check_NotAutoStop",{
        onChecked:function(e,value){
            CheckBoxClickHandler();
        }
    });
    $("#BFind").click(LoadArcimListDataGrid);
    $("#BSave").click(SaveARCIMExt);
    $("#DefSttDateDay").keyup(DefSttDateDayKeyup);
}
function InputStrKeydownHandle(e) {
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
	if (keycode==13) {
		LoadArcimListDataGrid();
	}
}
function CheckBoxClickHandler(e) {
	$("#Text_InputStr").val("");
}
function SaveARCIMExt(){
	if(ArcimRowId!=""){
		var StopAfterLongOrder=$("#Check_StopAfterLongOrder").checkbox("getValue")?1:0;
		var NotAutoStop=$("#Check_NotAutoStop").checkbox("getValue")?1:0;
		var DefSttDateDay=$.trim($("#DefSttDateDay").val());
		if ((DefSttDateDay!="")&&(!isInteger(DefSttDateDay))) {
			$.messager.alert("提示","默认开始日期数量必须是正整数!","info",function(){
		         $("#DefSttDateDay").focus();
		    });
			return false;
		}
		var DefSttTime=$("#DefSttTime").timespinner('getValue');
		if (DefSttTime=="00:00:00") {
			$.messager.alert("提示", "默认开始时间应大于00:00:00!","info",function(){
			    $("#DefSttTime").focus();
			});
			return false;
		}
		var time= /^([0-1]?[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/;
		if ((DefSttTime!="")&&(time.test(DefSttTime) != true)) {
		    $.messager.alert("提示", "默认开始时间格式不正确!","info",function(){
			    $("#DefSttTime").focus();
			});
			return false;
		}
		var AllowLongOrder=$("#Check_AllowLongOrder").checkbox("getValue")?1:0;
		var val=0+"^"+NotAutoStop+"^"+StopAfterLongOrder+"^"+DefSttDateDay+"^"+DefSttTime+"^"+AllowLongOrder;
		$.cm({
			ClassName:"DHCDoc.DHCDocConfig.ARCIMExt",
			MethodName:"saveARCIMConfig",
			dataType:"text",
			ArcimRowId:ArcimRowId,
			val:val
		},function(rtn){
			$.messager.popover({msg: '保存成功',type:'success'});
		});
	}else{
		$.messager.alert("提示","请选择医嘱项!");
	}
}
function InitArcimList(){
	ArcimListColumns=[[    
		{ field: 'ArcimDesc', title:'医嘱项名称', width: 200, align: 'center'},
		{ field: 'ArcimRowID', title: '医嘱项ID', width: 50, align: 'center'}	
	 ]];
	ArcimListDataGrid=$('#tabArcimList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : './dhcdoc.cure.query.grid.easyui.csp',
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ArcimRowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ArcimListColumns,
		onClickRow:function(rowIndex, rowData){
			var DischargeOrdFlag=rowData.DischargeOrdFlag;
			ArcimRowId=rowData.ArcimRowID;
			$.cm({
				ClassName:"DHCDoc.DHCDocConfig.ARCIMExt",
				MethodName:"getARCIMConfig",
				dataType:"text",
				ArcimRowId:ArcimRowId
			},function(rtn){
				$("#Check_NotAutoStop,#Check_StopAfterLongOrder,#Check_AllowLongOrder").checkbox('uncheck');
				$("#Check_AllowLongOrder").checkbox('setDisable',true);
				var arrayStr=rtn.split("^");
				 if (arrayStr[1]==1){
					$("#Check_NotAutoStop").checkbox('check');
			     }
				 if(arrayStr[2]==1){
					 $("#Check_StopAfterLongOrder").checkbox('check');
					 if (DischargeOrdFlag ==0) {
						$("#Check_AllowLongOrder").checkbox('setDisable',false);
					 }
				 }
				 $("#DefSttDateDay").val(arrayStr[3]);
				 $("#DefSttTime").timespinner('setValue',arrayStr[4]);
				 if(arrayStr[5]==1){
					 $("#Check_AllowLongOrder").checkbox('check');
				 }
				 DefSttDateDayKeyup();
			});
		},
		onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			ArcimRowId="";
		}
	});
};
function LoadArcimListDataGrid()
{
	var StopAfterLongOrder=0;
	if ($("#Check_StopAfterLongOrder").checkbox("getValue")) {
	  StopAfterLongOrder=1;
	};
	var NotAutoStop=0;
	if ($("#Check_NotAutoStop").checkbox("getValue")){
		NotAutoStop=1;
	};
	var input=$("#Text_InputStr").val();
	if ((input=="")&&(StopAfterLongOrder==0)&&(NotAutoStop==0)){
		$.messager.alert("提示","请输入医嘱别名或勾选右侧配置进行查询!");
		return false;
	}
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.ArcItemConfig';
	queryParams.QueryName ='FindAllItem';
	queryParams.Alias =input;
	queryParams.StopAfterLongOrder =StopAfterLongOrder;
	queryParams.NotAutoStop =NotAutoStop;
	queryParams.GroupID =session['LOGON.GROUPID'];
	queryParams.HospId=$HUI.combogrid('#_HospList').getValue()
	var opts = ArcimListDataGrid.datagrid("options");
	//opts.url = './dhcdoc.cure.query.grid.easyui.csp';
	opts.url = $URL;
	ArcimListDataGrid.datagrid('load', queryParams);
};
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>医嘱项扩展设定(自动停医嘱)页面使用说明</li>" + 
		"<li>1、本页面可以通过输入医嘱别名或勾选右侧进行查询。</li>" +
		"<li>2、页面中today代表本日，设置默认日期后在医嘱录入时自动带入默认数据到医嘱开始日期列。</li>" +
		"<li>3、默认日期输入框应大于等于0,为空业务代码按照0处理。默认时间填写时应大于00:00:00。</li>"
	$("#tip").popover({
		trigger:'hover',
		content:_content
	});
}
function isInteger(objStr) {
    var reg = /^\+?[0-9]*[0-9][0-9]*$/;
    var ret = objStr.match(reg);
    if (ret == null) { return false } else { return true }
}
function DefSttDateDayKeyup(){
	var DefSttDateDay=$.trim($("#DefSttDateDay").val());
	if (+DefSttDateDay > 0) {
		$("#DefSttTime").timespinner('enable');
	}else{
		$("#DefSttTime").timespinner('setValue',"").timespinner('disable');
	}
}