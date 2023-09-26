//几个查询条件 改变时 是否立即查询
var ActionTypeOnChange = function(){
	//$('#FindBtn').click();        //改变消息类型查询条件，立即查找
};
var FromUserOnChange = function(){
	//$('#FindBtn').click();         //发送用户
};
var ToUserOnChange = function(){
	//$('#FindBtn').click();         //接收用户
};
var DExecFlagOnChange = function(){
	//$('#DFindBtn').click();       //Details页面 处理状态
};
var DToUserOnChange = function(){
	//$('#DFindBtn').click();       //Details页面 接收用户
};
//----------几个查询条件 改变时 是否立即查询

//日期格式校验
function CheckDate(str){
	if(str==""){return true;}
	if(dateformat==4){
		var RegStr=/^((((0[1-9]|[12][0-9]|3[01])\/(0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|((0[1-9]|[1][0-9]|2[0-8])\/02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
	}else if(dateformat==1){
		var RegStr=/^((((0[13578]|1[02])\/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)\/(0[1-9]|[12][0-9]|30))|(02\/(0[1-9]|[1][0-9]|2[0-8])))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
	}else{
		var RegStr=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
	}
	if (str.match(RegStr)==null){
		return false;
	}else{
		return true;
	}
}
//去除html标签
var replaceHtml=function(str){
	 return str.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
}
var contentFlag="N";
$(function(){
	$('#DateEnd').datebox('setValue',now);
	$('#DateStart').datebox('setValue',now);
	var findTableHeight=parseInt($("#PageContent>table").css('height'));
	var dheight=500;
	var dsize=15;
	var trheight=27;   //datagrid一行的高度
	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
		var winHeight = document.documentElement.clientHeight;
		var winWidth = document.documentElement.clientWidth;
		dheight=winHeight-findTableHeight-35;
		dsize=parseInt((dheight-35-20)/trheight)-1;
	}
	$('#tDHCMessageContent').datagrid({
		queryParams: { DateStart : "", DateEnd : "", ToUser : "", FromUser : "", PatName : "", ActionType : ""},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageContentMgr&QueryName=FindByDateIndex',
		idField:'ContentId' ,
		height:dheight,
		singleSelect:false,
		pageSize:dsize,
		rownumbers: true,
		pagination: true,
		pageList: [dsize,30,50],  
		striped: true ,			
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'ContentId',title:'消息内容ID',hidden:true} ,
			{field:'CActionTypeDesc',title:'消息类型'} ,
			{field:'CText',title:'消息内容',width:500,formatter: function(value,row,index){
				value=replaceHtml(value);
				return "<span title='"+value+"'>"+value+"</span>";
			}} ,
			{field:'CSendDate',title:'发送时间',formatter: function(value,row,index){
				return value+" "+row['CSendTime'];
			}} ,
			{field:'CFromUserName',title:'发送用户'} ,
			{field:'CExecFlag',title:'处理状态',formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>已处理</span>";
				}else if (value=="O"){
					return "<span>无需处理</span>";
				}else{
					return "<span>未处理</span>";
				}
				
			}},
			{field:'CExecUser',title:'处理人'},
			{field:'CExecDateTime',title:'处理时间'},
			{field:'CStatus',title:'备注',formatter: function(value,row,index){
				if (value=="R") {
					return "独立消息，无需处理";
				}else if (value=="E"){
					return "业务正常处理";
				}else if (value=="D"){
					return "病人出院自动处理";
				}else if (value=="EP"){
					return "消息超期,自动处理";
				}else if (value=="C"){
					return "消息已撤回";
				}else if (value=="F"){
					return "强制处理";
				}else{
					return "";
				}
				
			}},
			{field:'CViewLoc',title:'查看科室',formatter: function(value,row,index){
				return "<span title='当用户登录以下科室才会提示此消息\n"+value+"'>"+value+"</span>";	
			}}			
		]],
		onDblClickRow: function (rowIndex, rowData) {  //双击行打开Details表，同时将在Content的查询条件 处理状态和接收用户 作为第一次打开Details的的查询条件
			var contentInfo=rowData.CActionTypeDesc+"&nbsp;&nbsp;&nbsp;&nbsp;"+rowData.CText.split("<br>")[0].substring(0,15)+""+(rowData.CText.length>15 ? "..." :"") +"&nbsp;&nbsp;&nbsp;&nbsp;  "+rowData.CFromUserName+"于"+rowData.CSendDate+"发送"
			$('#ContentInfo').html(contentInfo);
			$('#mydialog').dialog('open');
			$('#DetailsContentId').val(rowData.ContentId);
			if(rowData.CExecFlag=="Y"){           //Content为处理Details默认查已处理   Content为未处理或无需处理 Details默认查未处理 
				$('#DExecFlag').combobox('setValue',"Y");
				contentFlag=="Y";
			}else{
				$('#DExecFlag').combobox('setValue',"N");
				contentFlag=="N";
			}
			$('#DToUser').combogrid('setValue',$('#ToUser').combogrid('getValue'));
			$('#DToUser').combogrid('setText',$('#ToUser').combogrid('getText'));
			$('#DFindBtn').click();
		}
		
	});
	
	
	$('#FromUser').combogrid({
		width:200,
		disabled:false,		
		delay: 500,
		panelWidth:200,
		mode: 'remote',
		queryParams:{ClassName:'web.SSUser',QueryName: 'LookUpWithInactive',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		onSelect:FromUserOnChange,
		columns: [[{field:'Name',title:'姓名',width:180},{field:'Code',title:'Code',align:'right',hidden:true,width:0},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]]
	});
	$('#ToUser').combogrid({
		width:200,
		disabled:false,		
		delay: 500,
		panelWidth:200,
		mode: 'remote',
		queryParams:{ClassName:'web.SSUser',QueryName: 'LookUpWithInactive',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		onSelect:ToUserOnChange,
		columns: [[{field:'Name',title:'姓名',width:180},{field:'Code',title:'Code',align:'right',hidden:true,width:0},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]]
	});

	$('#FindBtn').click(function(){
		$('#tDHCMessageContent').datagrid('unselectAll');    //查询时取消选择的行
		var datestart=$('#DateStart').datebox('getValue');
		if(!CheckDate(datestart)){
			$.messager.alert('失败','开始日期格式不正确!');
			return false;
		}
		var dateend=$('#DateEnd').datebox('getValue');
		if(!CheckDate(dateend)){
			$.messager.alert('失败','结束日期格式不正确!');
			return false;
		}
		
		if (dateend==""){                                  //结束日期为空，取当天   
			dateend=now;
			$('#DateEnd').datebox('setValue',dateend);
		}
		if(datestart==""||$.fn.datebox.defaults.parser(datestart)>$.fn.datebox.defaults.parser(dateend)){             //开始日期为空，或者开始日期大于结束日期  取结束日期那一天
			datestart=dateend;
			$('#DateStart').datebox('setValue',datestart);
		}
		var touser=$('#ToUser').combogrid('getValue');
		var fromuser=$('#FromUser').combogrid('getValue');
		var actiontype=$('#ActionType').combobox('getValue');
		
		var patname=$('#PatName').val();
		//alert(datestart+"^"+dateend+"^"+touser+"^"+fromuser+"^"+actiontype+"^"+execflag);
		$('#tDHCMessageContent').datagrid('load',{ DateStart : datestart, DateEnd : dateend, ToUser : touser, FromUser : fromuser, PatName : patname, ActionType : actiontype});
		
	});
	//Content页面处理选中的消息（多条），要将Content处理，同时将其关联的Details处理掉
	$('#ExecBtn').click(function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.alert('失败','至少选择一条数据!');
			return false;
		}
		var ContentIds=[];
		for (var i=0;i<rows.length;i++) {
			ContentIds.push(rows[i].ContentId);
		}
		var ContentIdsStr=ContentIds.join("^");
		//alert(ContentIdsStr);
		
		//$('#tDHCMessageContent').datagrid('unselectAll');
		//return false;     //先return 暂时不掉后台
		$.ajaxRunServerMethod({
			ClassName:"websys.DHCMessageInterface",
			MethodName:"ExecAllByContentIds",
			ContentIds:ContentIdsStr
			},
			function(data,textStatus){
				if(data>0){
					$('#FindBtn').click();
					$.messager.alert('成功','处理成功!');
				}else{
					$.messager.alert('成功','处理失败!');
				}
			}
		);
		
	});
	
	$('#ClearBtn').click(function(){
		$('#ToUser').combogrid('clear');
		$('#FromUser').combogrid('clear');
		$('#DateEnd').datebox('setValue',now);
		$('#DateStart').datebox('setValue',now);
		$('#ActionType').combobox('setValue','');
		$('#PatName').val("");
		$('#FindBtn').click();
	})
	
	
	//Details页面 datagrid
	$('#tDHCMessageDetails').datagrid({
		queryParams: { ContentId : "", ToUser : "", ExecFlag : "N"},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageDetailsMgr&QueryName=FindByContent',
		idField:'DetailsId' ,
		height:330,
		fitColumns:true,
		singleSelect:false,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10],  
		striped: true ,		
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'DetailsId',title:'消息DetailsId',hidden:true,width:0} ,
			{field:'UserName',title:'接收用户',width:120} ,
			{field:'DReadFlag',title:'阅读状态',width:80,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>已读</span>";
				}else{
					return "<span>未读</span>";
				}
			}},
			{field:'DReadDateTime',title:'阅读时间',width:120} ,
			{field:'DExecFlag',title:'处理状态',width:80,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>已处理</span>";
				}else{
					return "<span>未处理</span>";
				}
			}},
			{field:'DExecUser',title:'处理用户',width:120},
			{field:'DExecDateTime',title:'处理时间',width:120} ,
			{field:'DTargetRole',title:'角色',width:120,formatter:function(val){
				return '<span title="'+val+'">'+val+'</span>'
			}} 
		]]
	});
	$('#DToUser').combogrid({      //弹窗窗口的用户combobox
		width:200,
		disabled:false,		
		delay: 500,
		panelWidth:200,
		mode: 'remote',
		queryParams:{ClassName:'web.SSUser',QueryName: 'LookUpWithInactive',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		onSelect:DToUserOnChange,
		columns: [[{field:'Name',title:'姓名',width:180},{field:'Code',title:'Code',align:'right',hidden:true,width:0},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]]
	});
	
	$('#DFindBtn').click(function(){
		$('#tDHCMessageDetails').datagrid('unselectAll');    //查询时取消选择的行
		var dtouser=$('#DToUser').combogrid('getValue');
		var dexecflag=$('#DExecFlag').combobox('getValue');
		var contentid=$('#DetailsContentId').val();
		//alert(datestart+"^"+dateend+"^"+touser+"^"+fromuser+"^"+actiontype+"^"+execflag);
		$('#tDHCMessageDetails').datagrid('load',{ ContentId : contentid, ToUser : dtouser, ExecFlag : dexecflag});
		
	});
	
	//Details页面处理选中的消息（多条），只处理选中的Details
	$('#DExecBtn').click(function(){
		var rows=$('#tDHCMessageDetails').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.alert('失败','至少选择一条数据!');
			return false;
		}
		//if(rows[0].DExecFlag=="Y"){            //无论处理状态如何都处理
		//	$.messager.alert('失败','您选择的是已处理数据!');
		//	return false;
		//}
		var DetailsIds=[];
		for (var i=0;i<rows.length;i++) {
			DetailsIds.push(rows[i].DetailsId);
		}
		var DetailsIdsStr=DetailsIds.join("^");
		//alert(DetailsIdsStr);
		//$('#tDHCMessageDetails').datagrid('unselectAll');
		//return false;     //先return 暂时不掉后台
		$.ajaxRunServerMethod({
			ClassName:"websys.DHCMessageInterface",
			MethodName:"ExecOneByDetailsIds",
			DetailsIds:DetailsIdsStr
			},
			function(data,textStatus){
				if(data>0){
					$('#DFindBtn').click();
					$.messager.alert('成功','处理成功!');
				}else{
					$.messager.alert('成功','处理失败!');
				}
			}
		);
		
	});
	
	//Details页面处理所有,直接根据ContentId处理应该即可
	$('#DExecAllBtn').click(function(){
		var contentid=$('#DetailsContentId').val();
		
		//alert(contentid);
		$('#DFindBtn').click();
		$('#tDHCMessageDetails').datagrid('unselectAll');
		//return false;     //先return 暂时不掉后台
		$.ajaxRunServerMethod({
			ClassName:"websys.DHCMessageInterface",
			MethodName:"ExecAllByContentIds",
			ContentIds:contentid
			},
			function(data,textStatus){
				if(data>0){
					$.messager.alert('成功','处理成功!');
					$('#FindBtn').click();//处理成功后刷新Content表
				}else{
					$.messager.alert('成功','处理失败!');
				}
			}
		);
		
	});
	
	$('#DClearBtn').click(function(){
		$('#DExecFlag').combobox('setValue',contentFlag);
		$('#DToUser').combogrid('setValue',"");
		$('#DToUser').combogrid('setText',"");
		//$('#DToUser').combogrid('setValue',$('#ToUser').combogrid('getValue'));
		//$('#DToUser').combogrid('setText',$('#ToUser').combogrid('getText'));
		$('#DFindBtn').click();
	})
})