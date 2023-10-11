// BSP.Lic.BizModelPage.js
var html = '<div style="width:100%;height:600px;">\
	<div class="hisui-layout" data-options="fit:true,border:false">\
		<div data-options="region:\'north\',split:true,bodyCls:\'panel-body-gray\',border:false" style="height:100px">\
			find\
		</div>\
		<div data-options="region:\'center\',bodyCls:\'panel-body-gray\',border:false">\
			<table id="bizModelPageGrid">\
			</table>\
		</div>\
	</div>\
</div>';
selectedTimeLineInd = 0;
$.extend($.fn.datagrid.defaults.view,{
	onAfterRender:function(target){
		var h = $(window).height();
		var offset = $(target).closest('.i-tableborder').offset();
		$(target).datagrid('resize',{height:parseInt(h-offset.top-18)});
	}
});
var init = function(){
	//$(html).appendTo("body");
	//$.parser.parse();
	$("#Find").click(function(){
		$("#bizModelPageGrid").datagrid("load");
	});
	$("#ImportLic").filebox({
			width:116,
			buttonText:"导入许可",
			buttonIcon:'icon-w-line-key',
			//accept:"text/plain,text/*",
			onChange:function(newVal,oldVal){
				if (newVal!=""){
					dhcsys_createMask();
					var file = $(this).filebox('files')[0];
					var reader = new FileReader();
					reader.onload = function(evt){
						var fileStr = evt.target.result;
						debugger
						$cm({
							ClassName:"BSP.Lic.BL.BizModelPage",MethodName:"ImportLic","dto.Plaintext":fileStr
						},function(rtn){
							dhcsys_closeMask();
							if (rtn.success==1){
								$("#bizModelPageGrid").datagrid("load");
								
							}
							$.messager.alert("提示",rtn.msg);
						})
					}
					reader.readAsText(file,"UTF-8");
				}
			}
	});
	$("#PageContent table .listtitle").closest("table").find(".i-tableborder").append("<table id='bizModelPageGrid'/>");
	var editflag = document.getElementById("editGridFlag").value;
	if (editflag=="true"){ editflag=true;}else {editflag=false}
	$("#bizModelPageGrid").mgrid({
		className:'BSP.Lic.BL.BizModelPage',
		title:'', //'模块界面列表',
		editGrid:editflag,
		fit:false,
		height:400,
		activeColName:"Access",
		columns:[[
			{field:'ID',hidden:true},
			{field:"Sort",title:"序号",width:60,editor:{type:"text"}},
			{field:'ProTeam',title:'产品组',width:100,editor:{type:'text'}},
			{field:'Note',title:'备注',width:100,editor:{type:'text'}},
			{field:'ProLineCode',title:'产品线代码',width:150,editor:{type:'text'}},
			{field:'ProLineName',title:'产品线名称',width:150,editor:{type:'text'}},
			{field:'ModelCode',title:'模块代码',width:150,editor:{type:'text'}},
			{field:'ModelName',title:'模块名称',width:150,editor:{type:'text'}},
			{field:'PageName',title:'CSP名',editor:{type:'text'}},
			{field:'CompName',title:'组件名',width:200,editor:{type:'text'}},
			{field:'Access',title:'授权',width:100},
			{field:'AddUser',title:'增加用户',width:110},
			{field:'AddDate',title:'增加日期',width:110},
			{field:'AddTime',title:'增加时间',width:80}
		]],
		onBeforeLoad:function(param){
			param.ProLineCode = $('#ProLineCode').val();
			param.ModelCode = $('#BizModelCode').val();
			param.CSPName = $('#CSPName').val();
			param.CompName = $('#CompName').val();
			param.ProTeam = $('#ProTeam').val();
		},
		insOrUpdHandler:function(row){
			var param ;
			if (!row.PageName){
				$.messager.popover({msg:"CSP名不能为空！",type:'info'});
				return ;
			}
			if (!row.ProLineCode){
				$.messager.popover({msg:"产品线代码不能为空！",type:'info'});
				return ;
			}
			if (row.ID==""){
				param = $.extend(this.insReq,{"dto.bizModelPage.id":""});
			}else{
				param = $.extend(this.updReq,{"dto.bizModelPage.id":row.ID});
			}
			$.extend(param,{
				"dto.bizModelPage.ProLineCode":row.ProLineCode,
				"dto.bizModelPage.ProLineName":row.ProLineName,
				"dto.bizModelPage.ModelCode":row.ModelCode,
				"dto.bizModelPage.ModelName":row.ModelName,
				"dto.bizModelPage.PageName":row.PageName,
				"dto.bizModelPage.CompName":row.CompName,
				"dto.bizModelPage.Sort":row.Sort,
				"dto.bizModelPage.ProTeam":row.ProTeam,
				"dto.bizModelPage.Note":row.Note
			});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {ID:"",Sort:"",ProLineCode:"",ProLineName:"",ModelCode:"",ModelName:"",PageName:"",CompName:"",Access:"0",AddUser:session['LOGON.USERNAME'],AddDate:"",AddTime:"",ProTeam:"",Note:""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "确定移除【"+row.ProLineName+"-"+row.ModelName+"-"+row.PageName+"】界面?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.bizModelPage.id":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
}
$(init);