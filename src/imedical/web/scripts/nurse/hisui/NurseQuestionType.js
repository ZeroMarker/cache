/**
* @author songchunli
* HISUI �ֶ��������������js
* NurseQuestionType.js
*/
var PageLogicObj={
	m_SelRowId:"",
	iframeflag:"0", //2758853������ƻ����á�ҵ���������  �Ƿ���iframe ����  1���ǣ� 0����
}
$(function(){
	//2758853������ƻ����á�ҵ���������
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){
		PageLogicObj.iframeflag=iframeflag
		Init();		   			// iframe ����
		InitEvent();  //����3130600
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();  // ��������
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
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
				PageLogicObj.m_SelRowId="";
				ShowQuestionTypeWin();
            }
        },{
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
	            var selected = $("#tabQuestionTypeList").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
					return false;
				}
				PageLogicObj.m_SelRowId=selected.id;
				ShowQuestionTypeWin();
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQuestionTypeList").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
					return false;
				}
				$.messager.confirm('��ʾ','ȷ��Ҫɾ���������������</br><sapn style="opacity:0.65;">���������ɾ�����ֶ����ӻ�������ʱ��������ͨ�������������п���ɸѡ.</sapn>',function(r){   
					if (r){   
						$.m({
							ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
							MethodName:"DeleteQuestionType",
							rowID:selected.id,
							optID:session['LOGON.USERID'],
							HospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
						},function (rtn){
							if(rtn == 0) {
								$.messager.popover({msg:'ɾ���ɹ���',type:'success'});
								$("#tabQuestionTypeList").datagrid("reload");
							} else {
								$.messager.alert('��ʾ','�޸�ʧ�ܣ��������: '+ rtn , "info");
								return false;
							}	
						})
					}   
				});  
            }
        }];
	var Columns=[[    
		{ field: 'desc',title:'�������',width:120}
    ]];
	$('#tabQuestionTypeList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '������..',  
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
		var title="�޸��������";
		iconCls="icon-w-edit";
	}else{
		var title="�����������";
		iconCls="icon-w-add";
	}
    createModalDialog("QuestionTypeDiag",title, 346, 150,iconCls,"ȷ��",Content,"SaveQuestionType()");
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
		$.messager.popover({msg:'������������ƣ�',type:'error'});
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
			$.messager.popover({msg:'����ɹ���',type:'success'});
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
			$.messager.alert('��ʾ','����ʧ�ܣ��������: '+ rtn , "info");
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
	$("body").remove("#"+id); //�Ƴ����ڵ�Dialog
	$("#"+id).dialog('destroy');
}
function initDiagDivHtml(type){
	if(type =="QuestionType"){
		var html="<div id='QuestionTypeWin' class='messager-body'>"
			       html +='<div style="margin-top:10px;">'
			       		html +='<label class="clsRequired r-label">��������</label>'
			       		html +='<input id="QuestionType" class="textbox" style="width:245px;"></input>'
			       html +='</div>'
		    html += "</div>"
	}
	return html;
}
/**
 * ����һ��ģ̬ Dialog
 * @param id divId
 * @param _url Div����
 * @param _title ����
 * @param _width ���
 * @param _height �߶�
 * @param _icon ICONͼ��
 * @param _btntext ȷ����ťtext
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
   //���ȥ���رհ�ť�����û�����������Ͻ�X�ر�ʱ�������޷��ص����������¼�����Ҫ����ƽ̨Э������
   buttons.push({
	   text:$g('ȡ��'),
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
