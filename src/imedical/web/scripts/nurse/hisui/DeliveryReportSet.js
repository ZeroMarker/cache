/**
* @author songchunli
* HISUI  ��������js
*/
$(window).load(function() {
	$("#loading").hide();
})
$(function(){
	Init();
});
function HospChange(){
	loadOtherSet();
	$('#tabReportColumnSet').datagrid("rejectChanges").datagrid("reload");
}
function Init(){
	iniTabReportColumnSet();
	loadOtherSet();
	$("#BSaveSet").click(saveSetHandle);
}
function iniTabReportColumnSet(){
	var ToolBar = [
		{
		text: '����',
		iconCls: 'icon-add',
		handler: function() {
			var maxRow=$("#tabReportColumnSet").datagrid("getRows");
			var newObj={
				Index:maxRow.length
			};
			$("#tabReportColumnSet").datagrid("appendRow", newObj);
            $("#tabReportColumnSet").datagrid("beginEdit", maxRow.length-1);
		}
    },{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var rows = $("#tabReportColumnSet").datagrid("getSelections");
			if (rows.length > 0) {
				$.messager.confirm("��ʾ", "ȷ��Ҫɾ����?",
	                function(r) {
	                    if (r) {
		                    var delDataArr=[],delIndexArr=[];;
		                    for (var i = 0; i < rows.length; i++) {
			                    if (rows[i].id){
				                    delDataArr.push(rows[i].id);
				                }
				                delIndexArr.push($("#tabReportColumnSet").datagrid("getRowIndex",rows[i].Index));
			                }
			                 var value=$.m({ 
								ClassName:"Nur.NIS.Service.Delivery.RecordConfig", 
								MethodName:"delReportColumnSet",
								dataArr:JSON.stringify(delDataArr)
							},false);
					        if(value=="0"){
						        for (var i = delIndexArr.length-1; i >=0; i--) {
							       $("#tabReportColumnSet").datagrid("deleteRow",delIndexArr[i]);
							    }
	   					       $.messager.popover({msg: 'ɾ���ɹ�!',type: 'success'});
					        }else{
						       $.messager.popover({msg: 'ɾ��ʧ��:'+value,type: 'error'});
					        }
		                }
	            })
			}else{
				$.messager.popover({msg: '��ѡ��Ҫɾ������!',type: 'error'});
			}
		}
    }];	
    var Columns=[[
    	{ field: 'DRCItemDesc', title: '�ֶ�����',width:100, editor : 
			{type : 'text',options : {required:true}}
     	},
     	{ field: 'DRCBasicItemDr', title: '����������Ŀ',width:180,editor :{
				type:'combobox',  
				options:{
					mode:"local",
					multiple:false,
					defaultFilter:6,
					url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetNurseBasicDataList&filter=1&rows=99999",
					valueField:'RowID',
					textField:'NBDName',
					loadFilter: function(data){
						return data['rows'];
					},
					onBeforeLoad:function(param){
						$.extend(param, {
							searchType:5,
							searchName:param["q"]
						});
					}
				}
			},
			formatter: function(value,row,index){
				return row.DRCBasicItemDesc;
			}
		},
		{ field: 'DRCColWidth', title: '�п�',width:60, editor : 
			{type : 'numberbox',options : {required:true}}
     	},
     	{ field: 'DRCHidden', title: '�Ƿ�����',width:80, align:'center',editor : 
			{
				type : 'icheckbox',options:{on:'Y',off:'N'}
			},
			formatter: function(value,row,index){
				return row.DRCHiddenDesc;
			}
		},
     	{ field: 'ID', title: '����', width: 90, formatter: function(val, row, index){
                var sortUpBtn = '<a href="#this" class="sortUpcls" onclick="ordSortUp(\'' + (row.id) + '\')"></a>';
                var sortDownBtn = '<a href="#this" class="sortDowncls" onclick="ordSortDown(\'' + (row.id) + '\')"></a>';
                return sortUpBtn + " " + sortDownBtn;
        	} 
		}
    ]];	
	$('#tabReportColumnSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : true,
		idField:"Index",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
		url:$URL+"?ClassName=Nur.NIS.Service.Delivery.RecordConfig&QueryName=GetReportColList",
		onDblClickRow:function(rowIndex, rowData){ 
			$('#tabReportColumnSet').datagrid("beginEdit", rowIndex);
			/*var ed = $('#tabReportColumnSet').datagrid('getEditor', {index:rowIndex,field:'DRIItemDefaultValues'});
			ed.target.combobox('setValues',rowData.DRIItemDefaultValues?rowData.DRIItemDefaultValues.split("$"):"");
			
			var ed = $('#tabReportColumnSet').datagrid('getEditor', {index:rowIndex,field:'DRIDeliveryMethods'});
			ed.target.combobox('setValues',rowData.DRIDeliveryMethods?rowData.DRIDeliveryMethods.split("$"):"");*/
        },
        onBeforeLoad:function(param){
	        $.extend(param, {
				hospID:window.parent.GetHospId()
			});
	    },
	    onLoadSuccess: function (data) {
		    $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	        $('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
		}
	})
}
var reportOtherSetId="";
function loadOtherSet(){
	$.cm({
		ClassName:"Nur.NIS.Service.Delivery.RecordConfig",
		MethodName:"getReportOtherConfig",
		hospID:window.parent.GetHospId()
	},function(data){
		for (item in data){
			if (item=="reportOtherSetId"){
				reportOtherSetId=data[item];
				if (reportOtherSetId==""){
					$("#DRSVaccinRegister,#DRSHearingScreening,#DRSDiseaseScreening").switchbox("setValue",false);
				}
			}else{
				if ($("#"+item).length>0){
					$("#"+item).switchbox("setValue",data[item]=="Y"?true:false);
				}
			}
		}
	})
}
function saveSetHandle(){
	var saveDataArr=[];
	//1.��ȡCF.NUR.Delivery.ReportSet��������
	var DRSVaccinRegister=$("#DRSVaccinRegister").switchbox("getValue")?"Y":"N";
	var DRSHearingScreening=$("#DRSHearingScreening").switchbox("getValue")?"Y":"N";
	var DRSDiseaseScreening=$("#DRSDiseaseScreening").switchbox("getValue")?"Y":"N";
	saveDataArr.push({
		tableClass:"CF.NUR.Delivery.ReportSet",
		tableName:"CF_NUR_Delivery.ReportSet",
		tableData:[
			[{"field":"id","fieldValue":reportOtherSetId},
			{"field":"DRSVaccinRegister","fieldValue":DRSVaccinRegister},
			{"field":"DRSHearingScreening","fieldValue":DRSHearingScreening},
			{"field":"DRSDiseaseScreening","fieldValue":DRSDiseaseScreening},
			{"field":"DRSHospDr","fieldValue":window.parent.GetHospId()}]
		]
	});
	//ȡ��ѯ�����ñ�������
	var allTableDataArr=[];
	var NullValColumnArr=[],repeatRowArr=[];
	saveDataArr.push({
		tableClass:"CF.NUR.Delivery.ReportColSet",
		tableName:"CF_NUR_Delivery.ReportColSet",
		tableData:[]
	});
	var rows=$("#tabReportColumnSet").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var editors=$('#tabReportColumnSet').datagrid('getEditors',i);
		if (editors.length>0){
			var rowNullValColumnArr=[];
			var DRCItemDesc=editors[0].target.val();
			if (!DRCItemDesc){
				rowNullValColumnArr.push("���ֶ�����");
			}
			var DRCBasicItemDr=editors[1].target.combobox('getValue');
			if (!DRCBasicItemDr){
				rowNullValColumnArr.push("����������");
			}
			if (JSON.stringify(allTableDataArr).indexOf(JSON.stringify([{"field":"DRCBasicItemDr","fieldValue":DRCBasicItemDr}]))>=0) {
				repeatRowArr.push("��"+(i+1)+"��");
			}
			allTableDataArr.push([{"field":"DRCBasicItemDr","fieldValue":DRCBasicItemDr}]); 
			var rowDataArr=[];
			for (var k=0;k<editors.length;k++){
				var field=editors[k].field;
				var fieldType=editors[k].type;
				if (fieldType =="combobox"){
					var value=editors[k].target.combobox('getValue');
				}else if(fieldType =="icheckbox"){
					var value=editors[k].target.checkbox('getValue')?"Y":"N";
				}else if(fieldType =="numberbox"){
					var value=editors[k].target.numberbox('getValue');
				}else {
					var value=editors[k].target.val();
				}
				value=$.trim(value);
				var fieldOpts = $('#tabReportColumnSet').datagrid('getColumnOption',field);
				// ������֤
				if (fieldOpts.editor.options){
					if ((fieldOpts.editor.options.required)&&(!value)){
						rowNullValColumnArr.push(fieldOpts.title);
					}
				}
				rowDataArr.push({"field":field,"fieldValue":value});
			}
			rowDataArr.push(
				//{"field":"DRCItemDesc","fieldValue":DRCItemDesc},
				//{"field":"DRCBasicItemDr","fieldValue":DRCBasicItemDr},
				{"field":"DRCHospDr","fieldValue":window.parent.GetHospId()},
				{"field":"id","fieldValue":rows[i].id},
				{"field":"DRCSortNo","fieldValue":(i+1)}
			);
			saveDataArr[1].tableData.push(rowDataArr);
			if (rowNullValColumnArr.length>0){
				NullValColumnArr.push("��"+(i+1)+"��"+rowNullValColumnArr.join("��"));
			}
		}else{
			rowDataArr=[
				{"field":"id","fieldValue":rows[i].id},
				{"field":"DRCSortNo","fieldValue":(i+1)}
			];
			saveDataArr[1].tableData.push(rowDataArr);
			allTableDataArr.push([{"field":"DRCBasicItemDr","fieldValue":rows[i].DRCBasicItemDr}]);
		}
	}
	var ErrMsgArr=[];
	if (NullValColumnArr.length>0){
		ErrMsgArr.push(NullValColumnArr.join("</br>")+"����Ϊ�գ�")
	}
	if (repeatRowArr.length>0){
		ErrMsgArr.push(repeatRowArr.join("</br>")+"�����ظ���")
	}
	if (ErrMsgArr.length>0){
		$.messager.alert("��ʾ","��ѯ������ "+ErrMsgArr.join("</br>"));
		return false;
	}
	$.cm({
		ClassName:"Nur.NIS.Service.Delivery.RecordConfig",
		MethodName:"saveDeliverySet",
		event:"SAVE",
		dataArr:JSON.stringify(saveDataArr)
	},function(rtn){
		if (rtn ==0) {
			loadOtherSet();
			$('#tabReportColumnSet').datagrid("reload");
			$.messager.popover({msg: '����ɹ���',type: 'success'});
		}else{
			$.messager.popover({msg: '����ʧ�ܣ�',type: 'error'});
		}
	})
}
function ordSortUp(sortSetId){
	if (!sortSetId){
		$.messager.popover({ msg: '���ȱ�����ٵ���˳��!', type: 'error'});
		return false;
	}
	var rows=$("#tabReportColumnSet").datagrid("getRows"); 
	var index=$.hisui.indexOfArray(rows,"id",sortSetId);
	if (index==0) return false;
	var preRow=rows[index-1];
	var curRow=rows[index];
	$('#tabReportColumnSet').datagrid('getData').rows[index] = preRow;
    $('#tabReportColumnSet').datagrid('getData').rows[index - 1] = curRow;
    $('#tabReportColumnSet').datagrid('refreshRow', index);
    $('#tabReportColumnSet').datagrid('refreshRow', index - 1).datagrid('selectRow', index - 1);
    $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	$('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
}
function ordSortDown(sortSetId){
	if (!sortSetId){
		$.messager.popover({ msg: '���ȱ�����ٵ���˳��!'+txtData, type: 'error'});
		return false;
	}
	var rows=$("#tabReportColumnSet").datagrid("getRows"); 
	var index=$.hisui.indexOfArray(rows,"id",sortSetId);
	if (index==(rows.length-1)) return;
	var nextRow=rows[index+1];
	var curRow=rows[index];
	$('#tabReportColumnSet').datagrid('getData').rows[index] = nextRow;
    $('#tabReportColumnSet').datagrid('getData').rows[index + 1] = curRow;
    $('#tabReportColumnSet').datagrid('refreshRow', index);
    $('#tabReportColumnSet').datagrid('refreshRow', index + 1).datagrid('selectRow', index + 1);
    $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	$('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
}