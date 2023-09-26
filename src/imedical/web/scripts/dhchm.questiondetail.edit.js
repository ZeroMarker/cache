/**
 * �����ʾ��������ά��  dhchm.questiondetail.edit.js
 * @Author   wangguoying
 * @DateTime 2019-03-29
 */
 
 
$.extend($.fn.validatebox.defaults.rules, {
	checkQDCodeExist:{
		validator: function(value){
			var url=$URL;  
			var data={ClassName:'web.DHCHM.QuestionDetailSet',MethodName:'CheckQDCodeExist',Code:value};
			var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
			return rtn==0;
		},
		message: '�����Ѵ���'
	}
});
 
 
var detailDataGrid;
var optionDataGrid;
var init = function(){

	$("#PCode").keydown(function(e){
 		 var Key=websys_getKey(e);
		if ((13==Key)) {
			findBtn_onclick();
		}
	});
	$("#PDesc").keydown(function(e){
 		 var Key=websys_getKey(e);
		if ((13==Key)) {
			findBtn_onclick();
		}
	});

	detailDataGrid = $HUI.datagrid("#DetailList",{
		url:$URL,
		title:"",
		bodyCls:'panel-body-gray',
		queryParams:{
			ClassName:"web.DHCHM.QuestionDetailSet",
			QueryName:"FindQDetail",
		},
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1){
				optionClear();
				var p = detailDataGrid.getPanel();
				p.find("#editIcon").linkbutton("enable",false);
				optionDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"FindQDOption",ParRef:rowData.QDID});
				if((rowData.QDType=="M")||(rowData.QDType=="S")){
					$("#LockDiv").hide();
					$("#OpParf").val(rowData.QDID);
					$("#OpParfType").val(rowData.QDType);
				} else{
					$("#LockDiv").show();
				}  
			}
		},
		onDblClickRow:function(index,row){
			detailEdit(row);														
		},	
		columns:[[
			{field:'QDID',hidden:true,sortable:'true'},
			{field:'QDOperation',width:50,title:'����',align:'center',
				formatter:function(value,row,index){
					return "<a href='#' onclick='openDSetsWin(\""+row.QDID+"\",\""+row.QDType+"\")'>\
					<img style='padding-top:4px;' title='�ײ͹�����ά��' alt='�ײ͹�����ά��' src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_link_pen.png' border=0/>\
					</a>";

				}
                        
			},
			{field:'QDCode',width:100,title:'����'},
			{field:'QDDesc',width:200,title:'����'},
			{field:'QDType',width:80,title:'����',
				formatter:function(value,row,index){
					var dispalyTxt="";
					switch (value){
						case "T":
							dispalyTxt="˵����";
							break;
						case "N":
							dispalyTxt="��ֵ��";
							break;
						case "D":
							dispalyTxt="������";
							break;
						case "S":
							dispalyTxt="��ѡ��";
							break;
						case "M":
							dispalyTxt="��ѡ��";
							break;
					}
					return dispalyTxt;
				}
			},
			{field:'QDUnit',width:60,title:'��λ'},
			{field:'QDSex',width:60,title:'�Ա�',
				formatter:function(value,row,index){
					var dispalyTxt="";
					if (value == 'M') {
                    	dispalyTxt='��';
               		}
                	if (value == 'F') {
                    	dispalyTxt='Ů';
               		}
               		if (value == 'N') {
                    	dispalyTxt='����';
                	}
                	return dispalyTxt;
				}
			},
			{field:'QDLinkCode',width:60,title:'������'},
			{field:'QDElementNum',width:50,title:'����'},
			{field:'QDActive',width:50,title:'����',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDRequired',width:50,title:'����',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDRemark',width:100,title:'��ע'},
			{field:'QDNote',hidden:true,width:80,title:'��ʾ'}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true,
		toolbar:[
		{
			iconCls:'icon-add',
			text:'����',
			handler:function(){
				detailClear();
				$("#DetailEditWin").window("open");
			}
		},{
			iconCls:'icon-edit',
			text:'�༭',
			disabled:true,
			id:'editIcon',
			handler:function(){
				var rows = detailDataGrid.getSelections();
				if (rows.length>1){
					$.messager.alert("��ʾ","�༭ģʽ���ɶ�ѡ","info");
				}else if (rows.length==1){
					detailEdit(rows[0]);
				}else{
					$.messager.alert("��ʾ","��ѡ��Ҫ�༭������","info");
				}
			}
		}]
	});
	optionDataGrid = $HUI.datagrid("#OptionList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCHM.QuestionDetailSet",
			QueryName:"FindQDOption",
		},
		onSelect:function(rowIndex,rowData){
			$("#OpID").val(rowData.QDOID);
			$("#OpDesc").val(rowData.QDODesc);
			$("#OpSeq").val(rowData.QDOOrder);
			$("#OpSex").combobox("setValue",rowData.QDOSex);
			if(rowData.QDODefault=="true"){
				$("#OpDefault").checkbox("check");
			}else{
				$("#OpDefault").checkbox("uncheck");
			}
			if(rowData.QDONote=="true"){
				$("#OpNote").checkbox("check");
			}else{
				$("#OpNote").checkbox("uncheck");
			}
			if(rowData.QDOActive=="true"){
				$("#OpActive").checkbox("check");
			}else{
				$("#OpActive").checkbox("uncheck");
			}
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'QDOID',hidden:true,sortable:'true'},
			{field:'QDOOperation',width:'80',title:'����',
				formatter:function(value,row,index){
					return "<a href='#' onclick='openDOLinkDWin(\""+row.QDOID+"\")'>\
					<img   title='��������ά��' alt='��������ά��' style='margin-left:8px;padding-top:4px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/adm_add.png' border=0/>\
					</a>\
					<a href='#' onclick='openDOSetsWin(\""+row.QDOID+"\")'>\
					<img   title='�ײ͹�����ά��' alt='�ײ͹�����ά��' style='margin-left:8px;padding-top:4px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_link_pen.png' border=0/>\
					</a>";

				}
			},
			{field:'QDODesc',width:'140',title:'����'},
			{field:'QDOSex',width:'60',title:'�Ա�',
				formatter:function(value,row,index){
					var dispalyTxt="";
					if (value == 'M') {
                    	dispalyTxt='��';
               		}
                	if (value == 'F') {
                    	dispalyTxt='Ů';
               		}
               		if (value == 'N') {
                    	dispalyTxt='����';
                	}
                	return dispalyTxt;
				}
			},
			{field:'QDOOrder',width:'60',title:'���'},
			{field:'QDODefault',width:'60',title:'Ĭ��',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDONote',width:'80',title:'����ע',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDOActive',width:'60',title:'����',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			}
		]],
		pagination:true,
		pageSize:20,
		fit:true,
		displayMsg:"",
		rownumbers:true
	});
	setGridHeight();
}

/**
 * �ʾ����ݲ�ѯ��ť����¼�
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function findBtn_onclick(){
	var PCode=$("#PCode").val();
	var PDesc=$("#PDesc").val();
	var PActive=$("#PActive").checkbox("getValue");
	detailDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"FindQDetail",Code:PCode,Desc:PDesc,Active:PActive});
}
/**
 * �ʾ�����������ť����¼�
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function clearBtn_onclick(){
	$("#PCode").val("");
	$("#PDesc").val("");
}

/**
 * �༭�ļ����������
 * @param    {[object]}    rowObj [ѡ��������]
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function detailEdit(rowObj){
	$("#DID").val(rowObj.QDID);
	$("#DDesc").val(rowObj.QDDesc);
	$("#DCode").val(rowObj.QDCode);
	$("#DType").combobox("setValue",rowObj.QDType);
	$("#DUnit").val(rowObj.QDUnit);
	$("#DSex").combobox("setValue",rowObj.QDSex);
	$("#DLinkCode").val(rowObj.QDLinkCode);
	$("#DColNum").val(rowObj.QDElementNum);
	if(rowObj.QDActive=="true"){
		$("#DActive").checkbox("check");
	}else{
		$("#DActive").checkbox("uncheck");
	}
	if(rowObj.QDRequired=="true"){
		$("#DRequired").checkbox("check");
	}else{
		$("#DRequired").checkbox("uncheck");
	}
	$("#DRemark").val(rowObj.QDRemark);
	$("#DetailEditWin").window("open");
}

/**
 * �ʾ����ݱ��水ť����¼�
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function detailSave(){
	var QDID=$("#DID").val();
	var QDDesc=$("#DDesc").val();
	var QDCode=$("#DCode").val();
	var QDType=$("#DType").combobox("getValue");
	var QDUnit=$("#DUnit").val();
	var QDSex=$("#DSex").combobox("getValue");
	var QDLinkCode=$("#DLinkCode").val();
	var QDColNum=$("#DColNum").val();
	var QDActive="N";
	var QDRequired="N";
	if($("#DActive").checkbox("getValue")){
		QDActive="Y";
	}
	if($("#DRequired").checkbox("getValue")){
		QDRequired="Y";
	}
	var QDRemark=$("#DRemark").val();
	if(QDCode==""){
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	if((QDID=="")&&(!$("#DCode").validatebox("isValid"))){
		$.messager.alert("��ʾ","�����Ѵ���","info");
		return false;
	}
	if(QDDesc==""){
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	var property = 'QDCode^QDDesc^QDType^QDUnit^QDSex^QDLinkCode^QDElementNum^QDActive^QDRequired^QDRemark';
	var valList = QDCode+"^"+QDDesc+"^"+QDType+"^"+QDUnit+"^"+QDSex+"^"+QDLinkCode+"^"+QDColNum+"^"+QDActive+"^"+QDRequired+"^"+QDRemark;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDSave",QDID,valList,property);
		if (ret.split("^")[0] == -1) {
            $.messager.alert("����","����ʧ�ܣ�"+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");
        	detailClear();
            $("#DetailEditWin").window("close");
            detailDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"FindQDetail",Code:QDCode});
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}
/**
 * ѡ���
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function optionSave()
{
	var QDOParRef=$("#OpParf").val();
	var OpParfType=$("#OpParfType").val();
	var OpID=$("#OpID").val();
	if((QDOParRef=="")||(OpID=="")){
		$.messager.alert("��ʾ","����ѡ��Ҫ�����������","info");
		return false;
	}
	var QDODesc=$("#OpDesc").val();
	if(QDODesc==""){
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	var QDOOrder=$("#OpSeq").val();
	var QDOSex=$("#OpSex").combobox("getValue")
	var QDODefault="N";
	if($("#OpDefault").checkbox("getValue")){
		QDODefault="Y";
	}
	var QDONote="N";
	if($("#OpNote").checkbox("getValue")){
		QDONote="Y";
	}
	var QDOActive="N";
	if($("#OpActive").checkbox("getValue")){
		QDOActive="Y";
	}
	var property = 'QDOActive^QDODefault^QDODesc^QDOOrder^QDOParRef^QDOSex^QDONote';
	var valList=QDOActive+"^"+QDODefault+"^"+QDODesc+"^"+QDOOrder+"^"+QDOParRef+"^"+QDOSex+"^"+QDONote;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDOSave",OpID,valList,property,OpParfType,QDODefault,QDOParRef);
		if (ret.split("^")[0] == -1) {
            $.messager.alert("����","����ʧ�ܣ�"+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");
        	optionClear();
            optionDataGrid.load({ClassName:"web.DHCHM.QuestionDetailSet",QueryName:"FindQDOption",ParRef:QDOParRef});
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}

/**
 * �ʾ����ݴ������
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function detailClear(){
	$("#OpParf").val("");
	$("#DID").val("");
	$("#DDesc").val("");
	$("#DCode").val("");
	$("#DType").combobox("setValue","T");
	$("#DUnit").val("");
	$("#DSex").combobox("setValue","N");
	$("#DLinkCode").val("");
	$("#DColNum").val("");
	$("#DActive").checkbox("setValue",false);
	$("#DRequired").checkbox("setValue",false);
	$("#DRemark").val("");
}

/**
 * ѡ��ά�����
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function optionClear(){
	//$("#OpParf").val("");
	//$("#OpParfType").val("");
	$("#OpID").val("");
	$("#OpDesc").val("");
	$("#OpSeq").val("");
	$("#OpSex").combobox("setValue","");
	$("#OpDefault").checkbox("uncheck");
	$("#OpNote").checkbox("uncheck");
	$("#OpActive").checkbox("uncheck");
}

/**
 * ����DataGrid�߶�
 * @Author   wangguoying
 * @DateTime 2019-03-29
 */
function setGridHeight()
{
	$("#GridDiv").height($("#ContentDiv").height()-51);
	$("#DetailList").datagrid("resize");
	$("#OpGridDiv").height($("#OptionDiv").height()-171);	
	$("#OptionList").datagrid("resize");
}

/**
 * ���������ά������
 * @param    {[String]}    OID [ѡ��ID]
 * @Author   wangguoying
 * @DateTime 2019-04-01
 */
var openDOLinkDWin = function(OID){
	if($("#OpParfType").val()=="M"){
		$.messager.alert("��ʾ","�ǵ�ѡ�����ⲻ��ά��������ϵ","info");
		return false;
	}
	//window.open("dhchm.dolinkdetail.edit.csp?OID="+OID);
	$HUI.window("#DOLinkDetailWin",{
		title:"��������ά��",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:500,
		height:400,
		content:'<iframe src="dhchm.dolinkdetail.edit.csp?OID='+OID+'" width="100%" height="100%" frameborder="0" ></iframe>'
	}).center();
};
/**
 * ����������ײ�ά������
 * @param    {[String]}    DID [����ID]
 *  * @param    {[String]}    DType [��������]
 * @Author   wangguoying
 * @DateTime 2019-04-01
 */
var openDSetsWin = function(DID,DType){
	if((DType=="M")||(DType=="S")){
		$.messager.alert("��ʾ","ѡ�������������Ҳ�ѡ��ҳ��ά��","info");
		return false;
	}
	$HUI.window("#DLOrdSetsWin",{
		title:"�����ײ�ά��",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:600,
		height:500,
		content:'<iframe src="dhchm.queslinkordersets.csp?DID='+DID+'" width="100%" height="100%" frameborder="0"></iframe>'
	});
};
/**
 * ��ѡ������ײ�ά������
 * @param    {[String]}    OID [ѡ��ID]
 * @Author   wangguoying
 * @DateTime 2019-04-01
 */
var openDOSetsWin = function(OID){
	$HUI.window("#DLOrdSetsWin",{
		title:"�����ײ�ά��",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:600,
		height:500,
		content:'<iframe src="dhchm.optionlinkordersets.csp?OID='+OID+'" width="100%" height="100%" frameborder="0"></iframe>'
	});
};

$(init);