/**
* @author songchunli
* HISUI 手动新增问题分类主js
* NurseQuestionType.js
*/
var PageLogicObj={
	m_SelRowId:"",
	iframeflag:"0", //2758853【护理计划配置】业务界面整合  是否是iframe 界面  1：是； 0：否
}
$(function(){
	//2758853【护理计划配置】业务界面整合
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){
		PageLogicObj.iframeflag=iframeflag
		Init();		   			// iframe 界面
		InitEvent();  //需求3130600
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();  // 正常界面
		InitEvent();			
	}

});
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabQuestionTypeList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabQuestionTypeList").datagrid("reload");
		}
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_QuestionType");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$("#tabQuestionTypeList").datagrid("load");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitQuestionTypeListDataGrid();
}
function InitQuestionTypeListDataGrid(){
	var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
				PageLogicObj.m_SelRowId="";
				ShowQuestionTypeWin();
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
	            var selected = $("#tabQuestionTypeList").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
					return false;
				}
				PageLogicObj.m_SelRowId=selected.id;
				ShowQuestionTypeWin();
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQuestionTypeList").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
					return false;
				}
				$.messager.confirm('提示','确定要删除此条问题分类吗？</br><sapn style="opacity:0.65;">此问题分类删除后，手动增加护理问题时，将不能通过此问题分类进行快速筛选.</sapn>',function(r){   
					if (r){   
						$.m({
							ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
							MethodName:"DeleteQuestionType",
							rowID:selected.id,
							optID:session['LOGON.USERID'],
							HospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
						},function (rtn){
							if(rtn == 0) {
								$.messager.popover({msg:'删除成功！',type:'success'});
								$("#tabQuestionTypeList").datagrid("reload");
							} else {
								$.messager.alert('提示','修改失败！错误代码: '+ rtn , "info");
								return false;
							}	
						})
					}   
				});  
            }
        }];
	var Columns=[[    
		{ field: 'desc',title:'问题分类',width:120}
    ]];
	$('#tabQuestionTypeList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"id",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestionType",
		onBeforeLoad:function(param){
			PageLogicObj.m_SelRowId="";
			$('#tabQuestionTypeList').datagrid("unselectAll");
			//param = $.extend(param,{name:$("#SearchDesc").val(),hospitalID:$HUI.combogrid('#_HospList').getValue()});
			param = $.extend(param,{name:$("#SearchDesc").val(),hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		}
	})
}
function ShowQuestionTypeWin(){
	destroyDialog("QuestionTypeDiag");
	var Content=initDiagDivHtml("QuestionType");
    var iconCls="";
	if (PageLogicObj.m_SelRowId) {
		var title="修改问题分类";
		iconCls="icon-w-edit";
	}else{
		var title="新增问题分类";
		iconCls="icon-w-add";
	}
    createModalDialog("QuestionTypeDiag",title, 346, 150,iconCls,"确定",Content,"SaveQuestionType()");
	if (PageLogicObj.m_SelRowId) {
		var selected = $("#tabQuestionTypeList").datagrid("getSelected");
		$("#QuestionType").val(selected.desc);
	}
	$("#QuestionType").focus();
	$("#QuestionType").keydown(QuestionTypeOnKeyDown);
}
function SaveQuestionType(){
	var QuestionType=$("#QuestionType").val();
	if (!QuestionType) {
		$.messager.popover({msg:'请输入分类名称！',type:'error'});
		$("#QuestionType").focus();
		return false;
	}
	$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName:"SaveQuestionType",
		rowID:PageLogicObj.m_SelRowId,
		NQTTypeDesc:QuestionType,
		LocDR:session['LOGON.LOCID'],
		NQTOperateUserDR:session['LOGON.USERID'],
		//NQTHospitalDR:$HUI.combogrid('#_HospList').getValue()
		NQTHospitalDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},function (rtn){
		if(rtn == 0) {
			$.messager.popover({msg:'保存成功！',type:'success'});
			destroyDialog("QuestionTypeDiag");
			if (PageLogicObj.m_SelRowId) {
				var index=$("#tabQuestionTypeList").datagrid("getRowIndex",PageLogicObj.m_SelRowId);
				$('#tabQuestionTypeList').datagrid('updateRow',{
					index: index,
					row: {
						desc: QuestionType
					}
				});				
			}else{
				$("#tabQuestionTypeList").datagrid("reload");
			}
		} else {
			$.messager.alert('提示','保存失败！错误代码: '+ rtn , "info");
			return false;
		}	
	})
}
function QuestionTypeOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		SaveQuestionType();
	}
}
function destroyDialog(id){
	$("body").remove("#"+id); //移除存在的Dialog
	$("#"+id).dialog('destroy');
}
function initDiagDivHtml(type){
	if(type =="QuestionType"){
		var html="<div id='QuestionTypeWin' class='messager-body'>"
			       html +='<div style="margin-top:10px;">'
			       		html +='<label class="clsRequired r-label">分类名称</label>'
			       		html +='<input id="QuestionType" class="textbox" style="width:245px;"></input>'
			       html +='</div>'
		    html += "</div>"
	}
	return html;
}
/**
 * 创建一个模态 Dialog
 * @param id divId
 * @param _url Div链接
 * @param _title 标题
 * @param _width 宽度
 * @param _height 高度
 * @param _icon ICON图标
 * @param _btntext 确定按钮text
*/
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
   if(_btntext==""){
	   var buttons=[];
   }else{
	   var buttons=[{
			text:_btntext,
			//iconCls:_icon,
			handler:function(){
				if(_event!="") eval(_event);
			}
		}]
   }
   //如果去掉关闭按钮，当用户点击窗体右上角X关闭时，窗体无法回调界面销毁事件，需要基础平台协助处理
   buttons.push({
	   text:$g('取消'),
		handler:function(){
			destroyDialog(id);
		}
   });
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;

    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: false,
        content:_content,
        buttons:buttons
    });
}
