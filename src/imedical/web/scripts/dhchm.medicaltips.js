/**
 * 健康评估  dhchm.medicaltips.js
 * @Author   wangguoying
 * @DateTime 2019-05-04
 */
var EditorObj="";

var MTDataGrid = $HUI.datagrid("#OQMTList",{
		url:$URL,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.OEvaluationRecord",
			QueryName:"MedicalTips",
			questionID:$("#EQID").val()
		},	
		columns:[[
			{field:'QMTID',hidden:true,sortable:true},
			{field:'QMTCMedicalTipsDR',hidden:true,},
			{field:'QMTCMedicalTipsDesc',width:80,title:'结论'},
			{field:'QMTDesc',width:80,title:'描述'},
			{field:'QMTType',hidden:true, title:'类型'}
		]],
		onSelect:function(rowIndex,rowData){
			$("#OMTID").val(rowData.QMTID);
			$("#MTDR").combogrid("setValue",rowData.QMTCMedicalTipsDR);
			$("#MTDR").combogrid("disable");
			$("#PMTDesc").val(rowData.QMTDesc);
			EditorObj.setData(rowData.QMTDetail);
		},
		toolbar:[
			{
			iconCls:'icon-cancel',
			text:'删除',
			handler:function(){
				var rows = MTDataGrid.getSelections();
				if (rows.length>1){
					$.messager.alert("提示","不可批量删除","info");
				}else if (rows.length==1){
					$.messager.confirm("删除", "确定删除该记录?", function (r) {
						if (r) {
							var deleteRet=tkMakeServerCall("web.DHCHM.OEvaluationRecord","DeleteTipsByID",rows[0].QMTID);
							var deleteArr=deleteRet.split("^");
							if(deleteArr[0]=="0"){
								$.messager.alert("提示","删除成功","info");
								Clear_onclick();
								MTDataGrid.reload();
							}else{
								$.messager.alert("提示","删除失败:"+deleteArr[1],"error");
							}
						} 
					});
					
				}else{
					$.messager.alert("提示","请选择要删除的数据","info");
				}
			}
		}],
		fitColumns:true,
		fit:true
	});

var init=function(){
	var parHeight=$("#TipPanel").height();
	
	EditorObj=CKEDITOR.replace('PMTDetail',{
			height:parHeight- 198,
			toolbar:[
			['Save','Preview'],
			['Cut','Copy','Paste','PasteText','PasteFromWord'],
			['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
			['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'], 
			['Link','Unlink'],
			['TextColor','BGColor'],
			['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
			['Styles','Format','Font','FontSize'],						
			['HorizontalRule','Smiley','SpecialChar','-','Outdent','Indent'],
			['Maximize']       		
			]
	});
	$("#OQMTList").datagrid("resize");
}
/**
 * 判断结论是否存在
 * @param    {[String]}    ID [提示ID]
 * @return   {Boolean}      []
 * @Author   wangguoying
 * @DateTime 2019-05-04
 */
function isExist(ID)
{
	var ret=false;
	$("div.datagrid-cell-c1-QMTCMedicalTipsDR").each(function(){
		var curData=$(this).html();
		if(curData==ID) ret= true;
	});
	return ret;
}

/**
 * 清屏
 * @Author   wangguoying
 * @DateTime 2019-05-04
 */
function Clear_onclick()
{
	$("#MTDR").combogrid('setValue', "");
	$("#MTDR").combogrid("enable");
	$("#PMTDesc").val("");
	$("#OMTID").val("");
	EditorObj.setData("");
} 
/**
 * 保存
 * @Author   wangguoying
 * @DateTime 2019-05-04
 */
function Save_onclick(){
	var OMTID=$("#OMTID").val();

	var MTID=$("#MTDR").combogrid('getValue');
	if(MTID==""){
		$.messager.alert('提示','结论不能为空','info');
		return;
	}
	var MTDesc=$("#PMTDesc").val();
	if(MTDesc==""){
		$.messager.alert('提示','描述不能为空','info');
		return;
	}
	var MTDetail=EditorObj.document.getBody().getHtml();
	if(MTDetail==""){
		$.messager.alert('提示','内容不能为空','info');
		return;
	}
	var EQID=$("#EQID").val();
	if(EQID==""){
		$.messager.alert('提示','父项不能为空','info');
		return;
	}
	var Char2 = String.fromCharCode(2);
	var resultStr=OMTID+Char2+MTID+Char2+MTDesc+Char2+MTDetail+Char2+'B'+Char2+""+Char2+EQID;
	var User = session['LOGON.USERID'];
	var saveRet=tkMakeServerCall("web.DHCHM.OEvaluationRecord","UpdateResult","T",resultStr,User);
	if(saveRet==""){
		$.messager.alert("提示","保存成功","success");
		Clear_onclick();
		MTDataGrid.reload();
	}else{
		$.messager.alert("提示","保存失败:"+saveRet,"error");
	}
}

$(init);