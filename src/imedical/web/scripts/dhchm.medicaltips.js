/**
 * ��������  dhchm.medicaltips.js
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
			{field:'QMTCMedicalTipsDesc',width:80,title:'����'},
			{field:'QMTDesc',width:80,title:'����'},
			{field:'QMTType',hidden:true, title:'����'}
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
			text:'ɾ��',
			handler:function(){
				var rows = MTDataGrid.getSelections();
				if (rows.length>1){
					$.messager.alert("��ʾ","��������ɾ��","info");
				}else if (rows.length==1){
					$.messager.confirm("ɾ��", "ȷ��ɾ���ü�¼?", function (r) {
						if (r) {
							var deleteRet=tkMakeServerCall("web.DHCHM.OEvaluationRecord","DeleteTipsByID",rows[0].QMTID);
							var deleteArr=deleteRet.split("^");
							if(deleteArr[0]=="0"){
								$.messager.alert("��ʾ","ɾ���ɹ�","info");
								Clear_onclick();
								MTDataGrid.reload();
							}else{
								$.messager.alert("��ʾ","ɾ��ʧ��:"+deleteArr[1],"error");
							}
						} 
					});
					
				}else{
					$.messager.alert("��ʾ","��ѡ��Ҫɾ��������","info");
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
 * �жϽ����Ƿ����
 * @param    {[String]}    ID [��ʾID]
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
 * ����
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
 * ����
 * @Author   wangguoying
 * @DateTime 2019-05-04
 */
function Save_onclick(){
	var OMTID=$("#OMTID").val();

	var MTID=$("#MTDR").combogrid('getValue');
	if(MTID==""){
		$.messager.alert('��ʾ','���۲���Ϊ��','info');
		return;
	}
	var MTDesc=$("#PMTDesc").val();
	if(MTDesc==""){
		$.messager.alert('��ʾ','��������Ϊ��','info');
		return;
	}
	var MTDetail=EditorObj.document.getBody().getHtml();
	if(MTDetail==""){
		$.messager.alert('��ʾ','���ݲ���Ϊ��','info');
		return;
	}
	var EQID=$("#EQID").val();
	if(EQID==""){
		$.messager.alert('��ʾ','�����Ϊ��','info');
		return;
	}
	var Char2 = String.fromCharCode(2);
	var resultStr=OMTID+Char2+MTID+Char2+MTDesc+Char2+MTDetail+Char2+'B'+Char2+""+Char2+EQID;
	var User = session['LOGON.USERID'];
	var saveRet=tkMakeServerCall("web.DHCHM.OEvaluationRecord","UpdateResult","T",resultStr,User);
	if(saveRet==""){
		$.messager.alert("��ʾ","����ɹ�","success");
		Clear_onclick();
		MTDataGrid.reload();
	}else{
		$.messager.alert("��ʾ","����ʧ��:"+saveRet,"error");
	}
}

$(init);