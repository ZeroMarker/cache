/**
* @author songchunli
* HISUI ������������������js
* QLRelateFactor.js
*/
var PageLogicObj={
	m_tabQLRelateFactorEdit:"",
	m_Index:0,
	m_SelQLRowIdStr:"",
	iframeflag:"0", //2758853������ƻ����á�ҵ���������  �Ƿ���iframe ����  1���ǣ� 0����
	selectQueRowID:""
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
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();			// ��������
	}
	InitEvent();
});
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabQLRelateFactorList").datagrid("reload");
	});
 	$("#BAddQLRelateFactor").click(AddQLRelateFactorClick);
 	$("#BSaveQLRelateFactor").click(SaveQLRelateFactorClick);
 	$("#SearchDesc").keydown(SearchDescOnKeyDown);
 	$("#QLRelateFactorDesc").keydown(QLRelateFactorDescOnKeyDown);
 	$("#BCancel").click(function(){
	 	$("#QLRelateFactorEditWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_QLRelateFactor");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$("#tabQLRelateFactorList").datagrid("reload");
		InitQuestion();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitQLRelateFactorListDataGrid();
	InitTip();
}
function InitTip(){
	var _content = "����������û�����,���Զ���Դ��������������ҽ�������";
	$("#tip_Btn").popover({
		trigger:'hover',
		content:_content,
		style:'inverse',
		width:'300',
	});
}
function ReloadQLRelateFactorListDataGrid(rowID){
	$("#QLRelateFactorEditWin").window('close');
	$('#tabQLRelateFactorList').datagrid('reload',{KeyWord:"",SearchQuestionDR:rowID,HospID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())})	
	PageLogicObj.selectQueRowID=rowID

}

function InitQLRelateFactorListDataGrid(){
	var ToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
	            //2758853������ƻ����á�ҵ���������
	            $('#Question').combobox('reload');
	            if (PageLogicObj.iframeflag=="1"){		            
		           	var qrow =$(window.parent.$("#iframeQuestion"))[0].contentWindow.$("#tabQuestionList").datagrid("getSelected");
					if (!qrow){
						$.messager.popover({msg:'��ѡ��һ���������⣡',type:'error'});
						return false;
					}
					if (!PageLogicObj.m_tabQLRelateFactorEdit) {
						InitEditWindow();
						InitQLRelateFactorEditWin();
					}
					$('#Question').combobox("select",qrow.rowID);
					$("#QuestionType").val(qrow.careTypeT);
					$("#QuestionCode").val(qrow.queCode);
					/*
					var row = $("#tabQLRelateFactorList").datagrid('getRows')[0];					
					if(row){
						SetQLRelateFactorRowData(row);						
					}else{
						$('#Question').combobox("select",qrow.rowID);
					}
					*/
					ResetQLRelateFactorEditWin();
					$("#QLRelateFactorEditWin").window('open');
					$("#QLRelateFactorDesc").focus();	            
		        }
	            else{            
		            if (!PageLogicObj.m_tabQLRelateFactorEdit) {
			            InitEditWindow();
			            InitQLRelateFactorEditWin();
			        }		        
		            $("#QLRelateFactorEditWin").window('open');
		            $("#Question").next('span').find('input').focus();
	            }
            }
        },{
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
	            InitQuestion();
	            var selected = $("#tabQLRelateFactorList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵļ�¼��");
					return false;
				}
				if (!PageLogicObj.m_tabQLRelateFactorEdit) {
					InitEditWindow();
					InitQLRelateFactorEditWin();
				}
				SetQLRelateFactorRowData(selected);
				ResetQLRelateFactorEditWin();
				$("#QLRelateFactorEditWin").window('open');
				$("#QLRelateFactorDesc").focus();
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQLRelateFactorList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("��ʾ","��ѡ��һ����¼��");
					return false;
				}
				$.messager.confirm('��ʾ','ȷ��ɾ���÷��������������',function(r){   
					if (r){   
						$.m({
							ClassName:"CF.NUR.NIS.QLRelateFactor",
							MethodName:"Delete",
							QLRowIDStr:selected.QLRowIDStr,
							user:session['LOGON.USERID']
						},function (rtn){
							if(rtn == 0) {
								$.messager.popover({msg:'ɾ���ɹ���',type:'success'});
								$("#tabQLRelateFactorList").datagrid("reload");
							} else {
								$.messager.alert('��ʾ','�޸�ʧ�ܣ��������: '+ rtn , "info");
								return false;
							}	
						})
					}   
				});  
            }
        },'-',{
	        id:'QLRelateFactorCopy',
	        text: '����',
			iconCls: 'icon-copy',
			handler: function(){
				var selected = $("#tabQLRelateFactorList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("��ʾ","��ѡ����Ҫ���Ƶļ�¼��");
					return false;
				}
				if (!PageLogicObj.m_tabQLRelateFactorEdit) {
					InitEditWindow();
					InitQLRelateFactorEditWin();
				}
				SetQLRelateFactorRowData(selected);
				PageLogicObj.m_SelQLRowIdStr="";
				$("#QLRelateFactorEditWin").window('open');
				$("#QLRelateFactorDesc").focus();
			}
	}];
	var Columns=[[    
		{ field: 'QuestionCode',title:'�������',width:120},
		{ field: 'Question', title: '��������',width:250,					
		  styler: function(value,row,index){
			  if (row.haveStopQue ==1){
				  return 'background-color:#F16E57;color:#FFFFFF;';
			  }
		}},
		{ field: 'RelateFactorDisPlay', title: '�������������',width:250}
    ]];
	$('#tabQLRelateFactorList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"QuestionDR",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuetionRelateFactor&QueryName=GetQLRelateFactorList",
		onBeforeLoad:function(param){
			try{
				var qRowId=window.parent.window.iframeQuestion.PageLogicObj.m_SelRowId;
			}catch(err){
				qRowId=""
			}
			$('#tabQLRelateFactorList').datagrid("unselectAll");
			//param = $.extend(param,{KeyWord:$("#SearchDesc").val(),HospID:$HUI.combogrid('#_HospList').getValue()});
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{KeyWord:$("#SearchDesc").val(),SearchQuestionDR:qRowId,HospID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onLoadSuccess:function(){
			//2758853������ƻ����á�ҵ���������
			$("#QLRelateFactorCopy").hide();
		}
	})
}
function InitQLRelateFactorEditWin(){
	InitQuestion();
	InittabQLRelateFactorEdit();
}
function InitQuestion(){
	$('#Question').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestion&rows=99999&ResultSetType=array",
		valueField:'rowID',
		textField:'shortName',
		mode: "remote",
		onSelect:function(rec){
			if (rec) {
				$("#QuestionType").val(rec.careTypeT);
				$("#QuestionCode").val(rec.queCode);
				$("#QLRelateFactorDesc").focus();
			}
		},
		onBeforeLoad:function(param){
             //param = $.extend(param,{keyword:param["q"],hospitalID:$HUI.combogrid('#_HospList').getValue(),statusIn:1});
             //2758853������ƻ����á�ҵ���������
             param = $.extend(param,{keyword:param["q"],hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),statusIn:1});
        },
        onChange:function(newValue, oldValue){
	        if (!newValue) {
		        $("#QuestionType,#QuestionCode").val("");
		    }
	    },
	    loadFilter:function(data){
		    for (var i=0;i<data.length;i++){
			    var parentID=data[i].parentID;
			    if (parentID !="-1"){
				    var parentIndex=$.hisui.indexOfArray(data,"rowID",parentID);
				    if (parentIndex >=0) {
					     data.splice(parentIndex,1);
					}
				}
			}
			data = data.sort(compare("rowID"));
		    return data;
		}
	});
}
function compare(property) {
	return function(firstobj, secondobj){
		var  firstValue = firstobj[property];
	    var  secondValue = secondobj[property];
	    if ((firstValue)&&(secondValue)) {
		    return firstValue - secondValue ; //����
	    }else{
		    return true;
	    }
	}
}
function InittabQLRelateFactorEdit(){
	var Columns=[[    
		{ field: 'RelateFactor', title: '�������������',width:390},
		{ field: 'Index', title: '����',width:45,
			formatter:function(value,row,index){
				var d = "<a href='#' onclick='DeleteRow(this)'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
				return d;
			}
		}
    ]];
	$('#tabQLRelateFactorEdit').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, 
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : true, 
		idField:"Index",
		columns :Columns
	})
}
function DeleteRow(target){
	var tr = $(target).closest('tr.datagrid-row');
	var index=parseInt(tr.attr('datagrid-row-index'));
	var rows=$('#tabQLRelateFactorEdit').datagrid('getRows');
	var QLRowID=rows[index].QLRowID;
	if (QLRowID) {
		$.m({
			ClassName:"CF.NUR.NIS.QLRelateFactor",
			MethodName:"Delete",
			QLRowIDStr:QLRowID,
			user:session['LOGON.USERID']
		},false)
		var selected = $("#tabQLRelateFactorList").datagrid("getSelected");
		var QLRowIDStr=selected.QLRowIDStr;
		var NewQLRowIDArr=new Array();
		for (var i=0;i<QLRowIDStr.split("^").length;i++){
			if (QLRowIDStr.split("^")[i] ==QLRowID) continue;
			NewQLRowIDArr.push(QLRowIDStr.split("^")[i]);
		}
		$('#tabQLRelateFactorList').datagrid('updateRow',{
			index: $("#tabQLRelateFactorList").datagrid("getRowIndex",selected),
			row: {
				QLRowIDStr: NewQLRowIDArr.join("^")
			}
		});
	}
	$('#tabQLRelateFactorEdit').datagrid('deleteRow', index);
}
function AddQLRelateFactorClick(){
	var QLRelateFactorDesc=$.trim($("#QLRelateFactorDesc").val());
	if (!QLRelateFactorDesc) {
		$.messager.alert("��ʾ","�����������������أ�","info",function(){
			$("#QLRelateFactorDesc").focus();
		})
		return false;
	}
	$('#tabQLRelateFactorEdit').datagrid('appendRow',{
		RelateFactor: QLRelateFactorDesc,
		Index:PageLogicObj.m_Index++
	});
	$("#QLRelateFactorDesc").val("").focus();
}
function InitEditWindow(){
    $("#QLRelateFactorEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
		   ClearQLRelateFactorWinData();
	   }
	});
}
function SaveQLRelateFactorClick(){
	var QuestionDr=$("#Question").combobox('getValue');
	var index=$.hisui.indexOfArray($('#Question').combobox("getData"),"rowID",QuestionDr);
	if (index < 0) {
		$.messager.alert('��ʾ','��ѡ�������⣡'); 
		return false;
	}
	var rows=$('#tabQLRelateFactorEdit').datagrid('getRows');
	if (rows.length ==0) {
		$.messager.alert('��ʾ','����ά��������������أ�'); 
		return false;
	}
	var RelateFactorArr=new Array();
	for (var i=0; i<rows.length; i++){
		var QLRowID=rows[i].QLRowID;
		if ((QLRowID)&&(PageLogicObj.m_SelQLRowIdStr)) continue;
		var RelateFactor=rows[i].RelateFactor;
		RelateFactorArr.push(RelateFactor);
	}
	$.m({
		ClassName:"CF.NUR.NIS.QLRelateFactor",
		MethodName:"SaveQLRelateFactor",
		QLRowIdStr:PageLogicObj.m_SelQLRowIdStr,
		QuestionDr:QuestionDr,
		RelateFactorStr:RelateFactorArr.join(String.fromCharCode(13)),
		user:session['LOGON.USERID'],
		//HospDr:$HUI.combogrid('#_HospList').getValue()
		//2758853������ƻ����á�ҵ���������
		HospDr:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},function (rtn){
		if(rtn == 0) {
			$.messager.popover({msg:'����ɹ���',type:'success'});
			if (PageLogicObj.m_SelQLRowIdStr) {
				$("#QLRelateFactorEditWin").window('close');
			}else{
				ClearQLRelateFactorWinData();
				$("#Question").next('span').find('input').focus();
				//�������3144009
				$("#QLRelateFactorEditWin").window('close');
			}
			$("#tabQLRelateFactorList").datagrid("reload");
		} else {
			$.messager.alert('��ʾ','����ʧ�ܣ��������: '+ rtn , "info");
			return false;
		}	
	})
}
function ClearQLRelateFactorWinData(){
	$('#Question').combobox('select','');
	$("#QLRelateFactorDesc").val("");
	$HUI.datagrid("#tabQLRelateFactorEdit").loadData([]);
	PageLogicObj.m_SelQLRowIdStr="";
	PageLogicObj.m_Index=0;
}
function SearchDescOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		$("#tabQLRelateFactorList").datagrid("reload");
	}
}
function QLRelateFactorDescOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		AddQLRelateFactorClick();
	}
}
function SetQLRelateFactorRowData(row){

	PageLogicObj.m_SelQLRowIdStr=row.QLRowIDStr;
	$('#Question').combobox("setValue",row.QuestionDR);
	$("#QuestionType").val(row.QuestionCareTypeT);
	$("#QuestionCode").val(row.QuestionCode);
	var RelateFactorStr=row.RelateFactorStr;
	var QLRowIDStr=row.QLRowIDStr;
	for (var i=0;i<RelateFactorStr.split(String.fromCharCode(13)).length;i++){
		$('#tabQLRelateFactorEdit').datagrid('appendRow',{
			RelateFactor: RelateFactorStr.split(String.fromCharCode(13))[i],
			Index:PageLogicObj.m_Index++,
			QLRowID:QLRowIDStr.split("^")[i]
		});
	}

}
//2758853������ƻ����á�ҵ���������
function ResetQLRelateFactorEditWin(){
	var innerHeight = window.innerHeight;
	var innerWidth= window.innerWidth;
	if (PageLogicObj.iframeflag=="1"){
		$("#QLRelateFactorEditWin").css({
			width:innerWidth,
			height:innerHeight-38
			
		});
    }
}
