// 2015-01-14,10/15/90
var LogIds="";
$(function(){
	var docHeight = $(document).height();
	var formHeight = 400;
	var tDHCEventLogJObj = $("#tDHCEventLog");
	tDHCEventLogJObj.height(docHeight-formHeight);
	/*$.fn.combogrid.defaults.keyHandler = $.extend($.fn.combogrid.defaults.keyHandler,{
		query:function(q){
			$(this).combogrid("grid").datagrid("load",$.extend(queryParams,{desc:q})
			
			);
		}
	});*/
	$.ajaxRunServerMethod({ClassName:"web.DHCEventModel",MethodName:"GetTypeJson"},
		function(data,textStatus){
			if(""!==data){
				$("#Type").combobox({ data: $.parseJSON(data), valueField:'Code', textField:"Desc",value:"L"});
			}
		}
	);
	$("#AuditFlag").combobox({ data: [{Code:"Y",Desc:"已审核"},{Code:"N",Desc:"未审核"}], valueField:'Code', textField:"Desc",value:"N"});
	$('#User').combogrid({		
		delay: 500,
		panelWidth:350,
		mode: 'remote',
		queryParams:{ClassName:'web.SSUser',QueryName: 'FindByAll',desc:"a"},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'UserName',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'UserName',title:'名字',align:'right',width:100},{field:'UserCode',title:'工号',width:100},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:100}]]
	});
	$('#AuditStatus').combogrid({
		delay: 500,
		width:200,
		panelWidth:200,
		panelHeight:150,
		mode: 'remote',
		queryParams:{ClassName: 'web.DHCAuditStatus',QueryName: 'Find',Code:""},
		url: 'jquery.easyui.querydatatrans.csp',
		onBeforeLoad:function(param){
			param = $.extend(param,{Code:param.q});
			return true;
		},
		idField: 'StatusRowId',
		textField: 'StatusDesc',
		columns: [[{field:'StatusCode',title:'代码',width:90},{field:'StatusDesc',title:'描述',width:100},{field:'StatusRowId',title:'StatusRowId',align:'right',width:100,hidden:true}]]
	});
	$("#SaveAudit").click(function(){
		var StatusDr = $("#AuditStatus").combogrid("getValue");
		if (StatusDr>0){
			$.ajaxRunServerMethod({ClassName:"web.DHCEventLog",MethodName:"AuditLog",LogIds:LogIds,StatusDr:StatusDr,UserDr:session['LOGON.USERID'],Note:$("#AuditNote").val()},
				function(data,textStatus){
					if(0==data){
						$('#win').window("close"); 
						$('#Find').click();
						$("#AuditStatus").combogrid("setValue","");
						$("#AuditNote").val("");
					}
				}
			);
		}else{
			$.messager.alert('警告',"请选择审核结果类型!","warning");
		}
	});
	$("#CancelAudit").click(function(){
		$('#win').window("close"); 
	});
	
	$("#StDate").datebox("setValue",now);
	$("#EndDate").datebox("setValue",now);
	$('#Model').combogrid({
		delay: 500,
		panelWidth:350,
		mode: 'remote',
		queryParams:{ClassName: 'web.DHCEventModel',QueryName: 'Find',Code:""},
		url: 'jquery.easyui.querydatatrans.csp',
		onBeforeLoad:function(param){
			param = $.extend(param,{Code:param.q});
			return true;
		},
		idField: 'ModelRowId',
		textField: 'ModelDesc',
		columns: [[{field:'ModelCode',title:'ModelCode',align:'right',width:100},{field:'ModelDesc',title:'ModelDesc',align:'right',width:100},{field:'ModelRowId',title:'ModelRowId',align:'right',width:100,hidden:true},{field:'ModelActive',title:'ModelActive',align:'right',width:100},{field:'ModelFiledSet',title:'ModelFiledSet',align:'right',width:100},{field:'ModelNote',title:'ModelNote',align:'right',width:100},{field:'ModelType',title:'ModelType',align:'right',width:100}]]
	});
	$('#Find').click(function(){
		tDHCEventLogJObj.datagrid('load',{ 
			ClassName:"web.DHCEventLog",
			QueryName:"Find",
			StDate:$('#StDate').datebox("getValue"),
			EndDate:$('#EndDate').datebox("getValue"),
			User:$('#User').combogrid("getValue"),
			AuditFlag:$('#AuditFlag').combobox("getValue"),
			Model:$('#Model').combogrid("getValue"),
			Type:$('#Type').combobox("getValue")
			}
		);
	});
	$("#Export").click(function(){
		location.href = tkMakeServerCall("websys.Query","ToExcel","DHCEventLog","web.DHCEventLogDetails","FindParAndDet",$('#StDate').datebox("getValue"),$('#EndDate').datebox("getValue"),$('#User').combogrid("getValue"),$('#AuditFlag').combobox("getValue"),$('#Model').combogrid("getValue"),$('#Type').combobox("getValue"));
	});
	$('#Audit').click(function(){
		LogIds = ""
		var rs = tDHCEventLogJObj.datagrid("getChecked");
		if (rs.length>0){
			for(var i=0;i<rs.length;i++){
				if (rs[i]["LogAuditFlag"]=="N"){
					if (LogIds=="") {
						LogIds = rs[i]["LogRowId"];
					}else{
						LogIds += "^"+rs[i]["LogRowId"];
					}
				}
			}
		}
		if (LogIds==""){
			$.messager.alert('警告',"请勾中未审核日志记录再进行审核!","warning"); 
			return false;
		}else{
			$('#win').window("open"); 
		}
	});
	tDHCEventLogJObj.datagrid({
		//rownumbers: true,
		height:$(window).height()-tDHCEventLogJObj.offset().top-10,
		pageSize:100,
		pagination: true,
		striped:true,
		singleSelect:false,
		pageList: [50, 100],
		queryParams: { ClassName:"web.DHCEventLog",QueryName:"Find"},
		url:'jquery.easyui.querydatatrans.csp',
		columns:[[{title:'日志',colspan:10}, {title:'审核',colspan:4}],
		[
		{field:'LogRowId',title:'LogRowId',width:100,align:'right',hidden:true},
		{field:'LogCheck',title:'选择',width:50,align:'right',checkbox:true},
		{field:'LogStDate',title:'开始日期',width:90,align:'right',hidden:false},
		{field:'LogStTime',title:'开始时间',width:65,align:'right',hidden:false},
		{field:'LogEndDate',title:'结束日期',width:90,align:'right',hidden:false},
		{field:'LogEndTime',title:'结束时间',width:65,align:'right',hidden:false},
		{field:'LogSuccess',title:'成功与否',width:60,align:'right',formatter: function(value,row,index){
				if (row.LogSuccess=="N"){
					return "失败";
				} else {
					return "成功";
				}
			}},
		{field:'LogTimes',title:'操作次数',width:60,align:'right',hidden:false},
		{field:'LogUserDr',title:'LogUserDr',width:100,align:'right',hidden:true},
		{field:'LogUserName',title:'操作人',width:100,align:'right',hidden:false},
		{field:'LogModelDr',title:'LogModelDr',width:100,align:'right',hidden:true},
		{field:'LogModelDesc',title:'模块名',width:80,align:'right',hidden:false},
		
		{field:'LogDetails',title:'明细',width:50,align:'right',formatter: function(value,row,index){
					return "<a href='dhceventlogdetails.csp?DetLogParref="+row.LogRowId+"&MWToken="+websys_getMWToken()+"' target='_blank'>查看</a>"
					return "<a href='websys.default.jquery.csp?WEBSYS.TCOMPONENT=DHCEventLogDetails&DetLogParref="+row.LogRowId+"&MWToken="+websys_getMWToken()+"' target='_blank'>查看</a>"
			}},
		{field:'LogAuditDr',title:'LogAuditDr',width:100,align:'right',hidden:true},
		{field:'LogAuditStatusDesc',title:'审核结果',width:100,align:'right'},	
		{field:'LogAuditUserName',title:'审核人',width:100,align:'right',hidden:false},
		{field:'LogAuditFlag',title:'审核与否',width:100,align:'right',formatter: function(value,row,index){
				if (row.LogAuditFlag=="Y"){
					return "已审核";
				} else {
					return "未审核";
				}
			}}
		,{field:'LogAuditNote',title:'审核备注',width:100,align:'right'}]],
		rowStyler:function(index,row){   
	        if (row.LogTimes>1){   
	            return 'background-color:red;';   
	        }   
	    }
	});
})