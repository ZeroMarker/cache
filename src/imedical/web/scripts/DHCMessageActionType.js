var actobj=document.getElementById('Active');
if (actobj){
	actobj.setAttribute('checked','checked');
}
//定义全局jquery对象
var CodeJObj ,DescJObj,ActionIdJObj,ReceiveTypeDescJObj,LevelTypeJObj,SendModeJObj,cls = "websys.DHCMessageActionTypeMgr",ExecLinkJObj;
var ToolItemsJObj,ReadCallbackJObj;
var DelJObj;
var delClick = function(){
	if ($(this).hasClass("l-btn-disabled")){
		return false;
	}
	if (ActionIdJObj.val()==""){
		$.messager.alert('警告','请先选择行记录,再删除!',"warning"); return false;
	}
	$.messager.confirm('删除' , '确认删除?', function(r){
		if(r){
			$.ajaxRunServerMethod({ClassName:cls,MethodName:"Delete",Id:ActionIdJObj.val()},
				function(data,textStatus){
					if ("undefined" == typeof data.err){
						if (data>0){
							//$.messager.alert('成功','删除接收类型成功!');
							$("#Clear").click();
							$("#Find").click();
						}else{
							$.messager.alert('失败','删除接收类型失败!<br/><br/>错误代码:'+data,"error");  
						}
					}else{
						$.messager.alert('失败','删除接收类型失败!'+data.err);  
					}
				}
			);
		}
	})
}
var ReceiveTypeSelectHandler = function(index,rowData){
	if (index>-1){
		ReceiveTypeDescJObj.combogrid('setValue', rowData["DHCReceiveDesc"]);
	}
}
var SendModeJson=$.cm({ClassName:'websys.DHCMessageActionTypeMgr',MethodName:'OutSendModeJSON'},false)
//var SendModeJson = [{id:"I",text:"信息系统"},{id:"S",text:"手机短信"},{id:"E",text:"电子邮箱"},{id:"ENS",text:"集成平台"},{id:"BKRS",text:"北科瑞声"}];
var LevelTypeJson = [{Code:"G",Desc:"一般消息"},{Code:"I",Desc:"重要消息"},{Code:"V",Desc:"非常重要"},{Code:"D",Desc:"紧急消息"}];
//var TeamExecJson = [{Code:"N",Desc:"消息相互独立,读后自己消息不显示"},{Code:"Y",Desc:"有一人处理,消息全部消失"},{Code:"A",Desc:"全员处理,消息才算处理"}];
var TeamExecJson = [{Code:"N",Desc:"消息相互独立,读后自己消息不显示"},{Code:"Y",Desc:"需要处理"}];
var ToolItemsJson = [{id:"E",text:"执行按钮"}]; //,{id:"R",text:"回复按钮"}

function initDialogStyle(){
	var target=$('#DialogStyle')[0];
	initKeyValueBox(target,{
		panelWidth:650,
		panelHeight:250,
		parseValue:parseValue,
		formatValue:formatValue
	});
	function formatValue(o){
		var arr=[];
		$.each(o,function(){
			console.log(this);
			if(this.key!=""&&this.value!=""){
				arr.push(this.key+"="+this.value)	;
			} 
		})
		return arr.join(',');
	}
	function parseShowInNewWindow(str){
		var arr=str.split(",");
		var o={};
		$.each(arr,function(){
			if (this.indexOf("=")>-1){
				var key=this.split("=")[0];
				var value=this.split("=")[1];
				if(key!="" && value!="") o[key]=value;
			}
		})
		return o;
	}
	function parseValue(str){
		var DialogStyleDIC=[
			{
				key:'dialogWidth',
				desc:'宽(如1000或80%)'
			},{
				key:'dialogHeight',
				desc:'高(如500或80%)'
			},{
				key:'target',
				desc:'_blank新窗口<br>其它HISUI模态'
			},{
				key:'level',
				desc:'H此配置高于OtherInfoJson'
			},{
				key:'noDetailsId',
				desc:'为1不拼接消息明细记录ID参数'
			},{
				key:'execMsgOnOpen',
				desc:'弹窗时直接处理消息：<br>All处理全部,One处理自己'
			},{
				key:'clientPath',
				desc:'客户程序端路径，用于调用其它客户端'
			},{
				key:'autoOpen',
				desc:'为1时展示消息详情时自动打开业务处理界面或业务详情查看界面'
			}

		]
		var o=parseShowInNewWindow(str);
		var all=[];
		if(DialogStyleDIC){
			$.each(DialogStyleDIC,function(){
				var key=this.key;
				if (typeof o[key]=="string"){
					all.push({key:key,value:o[key],desc:this.desc})
					delete o[key];
				}else{
					all.push({key:key,value:'',desc:this.desc})
				}
				
			})
		}
		$.each(o,function(i,v){
			all.push({key:i,value:v,custom:true,desc:''})
		})
		all.push({key:'',value:'',desc:'',custom:true});
		return all;
	}
}
function easyModal(title,url,width,height){
	var maxWidth=$(window).width(),maxHeight=$(window).height();
	width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
	height=''+height||'80%',height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
	var $easyModal=$('#easyModal');
	if ($easyModal.length==0){
		$easyModal=$('<div id="easyModal" style="overflow:hidden;" ><iframe name="easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe></div>').appendTo('body');
	}
	$easyModal.find('iframe').attr('src',url);
	$easyModal.dialog({
		iconCls:'icon-w-paper',
		modal:true,
		title:title,
		width:width,
		height:height
	}).dialog('open').dialog('center');
	
}

$(function(){
	LoadCombo2Css(24);
	initDialogStyle();
	var dheight=500;
	var dsize=15;
	dheight=parseInt($(window).height()-$("#PageContent table").eq(0).height()-10);
	dsize=parseInt((dheight-30)/27)-1;
	//console.log(dheight);  
	var opts=$('#tDHCMessageActionType').datagrid('options');
	
	if (!(window.navigator.userAgent.indexOf("MSIE")>-1)) {    
		$.extend(opts,{
			height:dheight,
			pageSize:dsize,
			pageList: [dsize],
			fitColumns:false
		})
	}
	if (opts.columns && opts.columns[0]) {
		opts.columns[0].push({field:'ReceiveCfg',title:'高级接收对象配置',formatter:function(val,row,ind){
			if (row.THasAdvancedCfg && row.THasAdvancedCfg=="1") {
				return '<a href="javascript:void(0);" data-key="'+row.TCode+'" data-desc="'+row.TDesc+'" class="rec-cfg-btn">'+row.TCode+'</a>'
			}else{
				return '<a href="javascript:void(0);" data-key="'+row.TCode+'" data-desc="'+row.TDesc+'" class="rec-cfg-btn">增加配置</a>'
			}
		},width:100})
	}
	opts.onLoadSuccess=function(){
		$('.rec-cfg-btn').off('click.msg').on('click.msg',function(){
			var key=$(this).data('key'),desc=$(this).data('desc');
			easyModal('【'+desc+'】的高级接收对象配置','dhcmessage.receivecfg.csp?BizModel='+key+'','90%','90%');
		})
	}
	$('#tDHCMessageActionType').datagrid(opts);	

	
	CodeJObj = $("#Code");
	DescJObj = $("#Desc");
	ActionIdJObj = $("#ActionId");
	ReceiveTypeDescJObj = $("#ReceiveTypeDesc");
	LevelTypeJObj = $("#LevelType");
	SendModeJObj = $("#SendMode");
	TeamExecJObj = $("#TeamExec");
	//ExecMethodJObj = $("#ExecMethod");     //注释原来的消息执行完成判断方法
	ExecLinkJObj = $("#ExecLink");
	ToolItemsJObj = $("#ToolbarItems");
	EffectiveDaysJObj = $("#EffectiveDays");
	DelJObj = $("#Del");
	DelJObj.linkbutton('disable');
	NoteJObj = $("#Note");
	ReadCallbackMethodJObj=$('#ReadCallbackMethod')    //新增读后回调配置
	SendModeJObj.combotree({
		delay: 1000,
		panelWidth:350,
		mode: 'local',
		multiple:true,
		data:[{
			"state":"open",
			"children":SendModeJson
		}]
	});	
	ToolItemsJObj.combotree({
		delay: 1000,
		panelWidth:350,
		mode: 'local',
		multiple:true,
		data:[{
			"state":"open",
			"children":ToolItemsJson
		}]
	});
	LevelTypeJObj.combobox({ data:LevelTypeJson, valueField:'Code', textField:"Desc"});
	TeamExecJObj.combobox({ data:TeamExecJson, valueField:'Code', textField:"Desc"});
	$('#Save').click(function(){
		if (CodeJObj.val()==""){
			$.messager.alert('警告','代码不能为空!');return false;
		}
		if (DescJObj.val()==""){
			$.messager.alert('警告','描述不能为空!'); return false;
		}
		var active = "N";
		if($("#Active").attr("checked")){
			active = "Y";	
		}
		
		var OnlySameLocFlag = "N";
		if($("#OnlySameLocFlag").attr("checked")){
			OnlySameLocFlag = "Y";	
		}
		
		var DischAutoExec = "N";
		if($("#DischAutoExec").attr("checked")){
			DischAutoExec = "Y";	
		}
		
		var HideSendUser = "N";
		if($("#HideSendUser").attr("checked")){
			HideSendUser = "Y";	
		}
		
		var HideReceiveUser = "N";
		if($("#HideReceiveUser").attr("checked")){
			HideReceiveUser = "Y";	
		}
		
		var PopupInterval=$('#PopupInterval').val();
		var AudioName=$('#AudioName').val();
		var DialogStyle=$('#DialogStyle').val();
		
		var MarqueeShow='N';
		if($("#MarqueeShow").attr("checked")){
			MarqueeShow = "Y";	
		}
		var AllowReply='N';
		if($("#AllowReply").attr("checked")){
			AllowReply = "Y";	
		}
		var HideExp='N';
		if($("#HideExp").attr("checked")){
			HideExp = "Y";	
		}
		
		var AudioContent=$('#AudioContent').val();
		var BizExecMethod=$('#BizExecMethod').val();
		
		$.ajaxRunServerMethod({
			ClassName:cls,MethodName:"Save",
			Code:CodeJObj.val(),
			Desc:DescJObj.val(),
			Id:ActionIdJObj.val(),
			ReceiveTypeDesc:ReceiveTypeDescJObj.combogrid("getValue"),
			LevelType: LevelTypeJObj.combobox("getValue"),
			SendMode: SendModeJObj.combotree("getValues").join(","),
			ToolbarItems: ToolItemsJObj.combotree("getValues").join(","),
			Active:active,
			TeamExec:TeamExecJObj.combobox("getValue"),
			ExecMethod:"",     //ExecMethodJObj.val(),   //改为空即可
			ExecLink:ExecLinkJObj.val(),
			OnlySameLocFlag:OnlySameLocFlag,
			EffectiveDays:EffectiveDaysJObj.val(),
			Note:NoteJObj.val(),
			ReadCallbackMethod:ReadCallbackMethodJObj.val(),    //新增读后回调
			DischAutoExec:DischAutoExec     //出院自动处理
			,HideSendUser:HideSendUser
			,HideReceiveUser:HideReceiveUser
			,PopupInterval:PopupInterval
			,AudioName:AudioName
			,DialogStyle:DialogStyle
			,MarqueeShow:MarqueeShow
			,AllowReply:AllowReply
			,HideExp:HideExp
			,AudioContent:AudioContent
			,BizExecMethod:BizExecMethod
			,Sequence:$('#Sequence').val()
			},
			function(data,textStatus){
				if ("undefined" == typeof data.err){
					if (data>0){
						//$.messager.alert('成功','保存接收类型成功!');
						$("#Clear").click();
						$("#Find").click();
					}else{
						$.messager.alert('失败','保存接收类型失败!'+data);  
					}
				}else{
					$.messager.alert('失败','保存接收类型失败!'+data.err);  
				}
			}
		);
	})
	DelJObj.bind("click",delClick);
	$("#Clear").click(function(){
		ActionIdJObj.val("");
		CodeJObj.val("");
		DescJObj.val("");
		ReceiveTypeDescJObj.combogrid("setValue","");
		LevelTypeJObj.combobox("setValue","");
		SendModeJObj.combotree("setValues","");
		ToolItemsJObj.combotree("setValues","");
		TeamExecJObj.combobox("setValue","");
		//ExecMethodJObj.val("");   //不需要了
		ExecLinkJObj.val("");
		$("#OnlySameLocFlag").attr("checked",false);
		$("#Active").attr("checked","checked");
		$("#DischAutoExec").attr("checked","checked");
		NoteJObj.val("");
		ReadCallbackMethodJObj.val("");   //新增读后回调
		DelJObj.linkbutton('disable'); //.unbind("click",delClick);
		EffectiveDaysJObj.val("");
		$("#HideSendUser").attr("checked",false);
		$("#HideReceiveUser").attr("checked",false);
		$('#PopupInterval').val('');
		$('#AudioName').val('');
		$('#DialogStyle').val('');
		$('#MarqueeShow').attr('checked',false);
		$('#AllowReply').attr('checked','checked');
		$('#HideExp').attr('checked',false);
		$('#AudioContent').val('');
		$('#BizExecMethod').val('');
		$('#Sequence').val('');
		
		//$("#tDHCMessageActionType").datagrid("getPager").pagination("select");
	});
	//$("#tDHCMessageActionType").data("datagrid").options["onClickRow"]
	$("#tDHCMessageActionType").datagrid("options").onClickRow = function(index,rowData){
		if (index>-1){
			ActionIdJObj.val(rowData["TActionId"]);
			CodeJObj.val(rowData["TCode"]);
			DescJObj.val(rowData["TDesc"]);
			//ExecMethodJObj.val(rowData["TExecMethod"]);
			ReadCallbackMethodJObj.val(rowData["TReadCallbackMethod"]);
			NoteJObj.val(rowData["TNote"]);
			ExecLinkJObj.val(rowData["TExecLink"]);
			ReceiveTypeDescJObj.combogrid("setValue",rowData["TReceiveTypeDesc"]);
			$.each(LevelTypeJson,function(i,item){
				if (item.Desc==rowData["TLevelType"]) {LevelTypeJObj.combobox("setValue",item.Code);}
			});
			TeamExecJObj.combobox("setValue",rowData["TTeamExec"]);
			SendModeJObj.combotree("setValues",rowData["TSendModeCode"].split(","));
			ToolItemsJObj.combotree("setValues",rowData["TToolbarItems"].split(","));
			if (rowData["TActive"]=="Y"){
				$("#Active").attr("checked",true);
			}else{
				$("#Active").attr("checked",false);
			}
			
			if (rowData["TOnlySameLocFlag"]=="Y"){
				$("#OnlySameLocFlag").attr("checked",true);
			}else{
				$("#OnlySameLocFlag").attr("checked",false);
			}
			
			if (rowData["TDischAutoExec"]=="Y"){
				$("#DischAutoExec").attr("checked",true);
			}else{
				$("#DischAutoExec").attr("checked",false);
			}			
			
			$("#HideSendUser").attr("checked",rowData["THideSendUser"]=="Y");
			$("#HideReceiveUser").attr("checked",rowData["THideReceiveUser"]=="Y");
			
			$('#PopupInterval').val(rowData["TPopupInterval"]);
			$('#AudioName').val(rowData["TAudioName"]);
			$('#DialogStyle').val(rowData["TDialogStyle"]);
			
			$('#MarqueeShow').attr("checked",rowData["TMarqueeShow"]=="Y");
			
			$('#AllowReply').attr('checked',rowData["TAllowReply"]!="N");
			
			$('#HideExp').attr('checked',rowData["THideExp"]=="Y");
			
			$('#AudioContent').val(rowData['TAudioContent']);
			$('#BizExecMethod').val(rowData['TBizExecMethod']);
			
			EffectiveDaysJObj.val(rowData["TEffectiveDays"]);
			$('#Sequence').val(rowData["TSequence"]);
			DelJObj.linkbutton('enable');
		}
	}
	$("#tDHCMessageActionType").datagrid("options").onDblClickRow = function(rowIndex,rowData){
		if (document.getElementById('#ccwin')){
		}else{
			$(document.body).append("<div id='ccwin'></div>");
		}
		$('#ccwin').window({
			title:"抄送人员",
			href:"dhcmessageucc.csp?TCCRowIds="+rowData["TCCRowIds"]+"&ActionId="+rowData["TActionId"],  
		    cache:true,
		    width:500,  
		    height:400,  
		    modal:true
		})
	}
	$("#OnlySameLocFlag").attr("checked",false);
	$("#Active").attr("checked","checked");
	$("#DischAutoExec").attr("checked","checked");
	$("#HideSendUser").attr("checked",false);
	$("#HideReceiveUser").attr("checked",false);
	$("#MarqueeShow").attr("checked",false);
	$('#AllowReply').attr('checked','checked');
	$("#HideExp").attr("checked",false);
	$("#Find").click();	
	$("#Note").css("width","550").css("height",55).css("padding",5);
})
