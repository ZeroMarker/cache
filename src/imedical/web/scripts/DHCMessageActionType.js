var actobj=document.getElementById('Active');
if (actobj){
	actobj.setAttribute('checked','checked');
}
//����ȫ��jquery����
var CodeJObj ,DescJObj,ActionIdJObj,ReceiveTypeDescJObj,LevelTypeJObj,SendModeJObj,cls = "websys.DHCMessageActionTypeMgr",ExecLinkJObj;
var ToolItemsJObj,ReadCallbackJObj;
var DelJObj;
var delClick = function(){
	if ($(this).hasClass("l-btn-disabled")){
		return false;
	}
	if (ActionIdJObj.val()==""){
		$.messager.alert('����','����ѡ���м�¼,��ɾ��!',"warning"); return false;
	}
	$.messager.confirm('ɾ��' , 'ȷ��ɾ��?', function(r){
		if(r){
			$.ajaxRunServerMethod({ClassName:cls,MethodName:"Delete",Id:ActionIdJObj.val()},
				function(data,textStatus){
					if ("undefined" == typeof data.err){
						if (data>0){
							//$.messager.alert('�ɹ�','ɾ���������ͳɹ�!');
							$("#Clear").click();
							$("#Find").click();
						}else{
							$.messager.alert('ʧ��','ɾ����������ʧ��!<br/><br/>�������:'+data,"error");  
						}
					}else{
						$.messager.alert('ʧ��','ɾ����������ʧ��!'+data.err);  
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
//var SendModeJson = [{id:"I",text:"��Ϣϵͳ"},{id:"S",text:"�ֻ�����"},{id:"E",text:"��������"},{id:"ENS",text:"����ƽ̨"},{id:"BKRS",text:"��������"}];
var LevelTypeJson = [{Code:"G",Desc:"һ����Ϣ"},{Code:"I",Desc:"��Ҫ��Ϣ"},{Code:"V",Desc:"�ǳ���Ҫ"},{Code:"D",Desc:"������Ϣ"}];
//var TeamExecJson = [{Code:"N",Desc:"��Ϣ�໥����,�����Լ���Ϣ����ʾ"},{Code:"Y",Desc:"��һ�˴���,��Ϣȫ����ʧ"},{Code:"A",Desc:"ȫԱ����,��Ϣ���㴦��"}];
var TeamExecJson = [{Code:"N",Desc:"��Ϣ�໥����,�����Լ���Ϣ����ʾ"},{Code:"Y",Desc:"��Ҫ����"}];
var ToolItemsJson = [{id:"E",text:"ִ�а�ť"}]; //,{id:"R",text:"�ظ���ť"}

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
				desc:'��(��1000��80%)'
			},{
				key:'dialogHeight',
				desc:'��(��500��80%)'
			},{
				key:'target',
				desc:'_blank�´���<br>����HISUIģ̬'
			},{
				key:'level',
				desc:'H�����ø���OtherInfoJson'
			},{
				key:'noDetailsId',
				desc:'Ϊ1��ƴ����Ϣ��ϸ��¼ID����'
			},{
				key:'execMsgOnOpen',
				desc:'����ʱֱ�Ӵ�����Ϣ��<br>All����ȫ��,One�����Լ�'
			},{
				key:'clientPath',
				desc:'�ͻ������·�������ڵ��������ͻ���'
			},{
				key:'autoOpen',
				desc:'Ϊ1ʱչʾ��Ϣ����ʱ�Զ���ҵ��������ҵ������鿴����'
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
		opts.columns[0].push({field:'ReceiveCfg',title:'�߼����ն�������',formatter:function(val,row,ind){
			if (row.THasAdvancedCfg && row.THasAdvancedCfg=="1") {
				return '<a href="javascript:void(0);" data-key="'+row.TCode+'" data-desc="'+row.TDesc+'" class="rec-cfg-btn">'+row.TCode+'</a>'
			}else{
				return '<a href="javascript:void(0);" data-key="'+row.TCode+'" data-desc="'+row.TDesc+'" class="rec-cfg-btn">��������</a>'
			}
		},width:100})
	}
	opts.onLoadSuccess=function(){
		$('.rec-cfg-btn').off('click.msg').on('click.msg',function(){
			var key=$(this).data('key'),desc=$(this).data('desc');
			easyModal('��'+desc+'���ĸ߼����ն�������','dhcmessage.receivecfg.csp?BizModel='+key+'','90%','90%');
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
	//ExecMethodJObj = $("#ExecMethod");     //ע��ԭ������Ϣִ������жϷ���
	ExecLinkJObj = $("#ExecLink");
	ToolItemsJObj = $("#ToolbarItems");
	EffectiveDaysJObj = $("#EffectiveDays");
	DelJObj = $("#Del");
	DelJObj.linkbutton('disable');
	NoteJObj = $("#Note");
	ReadCallbackMethodJObj=$('#ReadCallbackMethod')    //��������ص�����
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
			$.messager.alert('����','���벻��Ϊ��!');return false;
		}
		if (DescJObj.val()==""){
			$.messager.alert('����','��������Ϊ��!'); return false;
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
			ExecMethod:"",     //ExecMethodJObj.val(),   //��Ϊ�ռ���
			ExecLink:ExecLinkJObj.val(),
			OnlySameLocFlag:OnlySameLocFlag,
			EffectiveDays:EffectiveDaysJObj.val(),
			Note:NoteJObj.val(),
			ReadCallbackMethod:ReadCallbackMethodJObj.val(),    //��������ص�
			DischAutoExec:DischAutoExec     //��Ժ�Զ�����
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
						//$.messager.alert('�ɹ�','����������ͳɹ�!');
						$("#Clear").click();
						$("#Find").click();
					}else{
						$.messager.alert('ʧ��','�����������ʧ��!'+data);  
					}
				}else{
					$.messager.alert('ʧ��','�����������ʧ��!'+data.err);  
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
		//ExecMethodJObj.val("");   //����Ҫ��
		ExecLinkJObj.val("");
		$("#OnlySameLocFlag").attr("checked",false);
		$("#Active").attr("checked","checked");
		$("#DischAutoExec").attr("checked","checked");
		NoteJObj.val("");
		ReadCallbackMethodJObj.val("");   //��������ص�
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
			title:"������Ա",
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
