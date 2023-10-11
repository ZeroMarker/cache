/**
 * �������ݹ��� dhchm.evaluationlink.js
 * @Author   wangguoying
 * @DateTime 2020-04-21
 */


$.extend($.fn.validatebox.defaults.rules, {
	checkOrdSetsExist:{
		validator: function(value){
			var url=$URL;  
			var data={ClassName:'web.DHCPE.HM.OrdSetsLink',MethodName:'CheckOrdSetsExist',OrdSetsDR:$("#OrdSetsDR").combogrid("getValue"),ID:$("#linkid-hidden").val()};
			var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
			return rtn==0;
		},
		message: '�ײ��Ѵ���'
	}
});



var qdetailListObj=$HUI.datagrid("#QDetailList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.Evaluation",
		QueryName:"QueryQDetail",
		EvaluationDR:$("#H_EvaluationDetail").val()
	},
	onSelect:function(rowIndex,rowData){
		if(rowIndex>-1){
			$("#detailid-hidden").val(rowData.TRowID);
			initQDetailDR(rowData.TDetailDesc);	
			$("#QDetailDR").combogrid("setValue",rowData.TDetailId);
			$("#QDetailDR").combogrid("disable");
			$("#detailtype-hidden").val(rowData.TDetailType);
			$("#Relevance").val(rowData.TScore);
			$("#Expression").val(rowData.TExpression);
			initOptionDR(rowData.TDetailId);
			optionListObj.load({
				ClassName:"web.DHCPE.HM.Evaluation",
				QueryName:"QueryQDOption",
				LinkDetailDR:rowData.TRowID
			});		
			doption_clean();
		}
	},
	onDblClickRow:function(index,row){
														
	},	
	columns:[[
		{field:'TRowID',hidden:true,sortable:'true'},
		{field:'TDetailId',hidden:true,sortable:'true'},
		{field:'TOperation',width:60,title:'����',align:'center',
			formatter:function(value,row,index){
				return "<a href='#' onclick='qdetail_delete(\""+row.TRowID+"\")'>\
				<img style='padding-top:4px;' title='ɾ����¼' alt='ɾ����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
				</a>";
			}
                    
		},
		{field:'TDetailDesc',width:180,title:'��������'},
		{field:'TScore',width:60,title:'�÷�'},
		{field:'TExpression',width:120,title:'���ʽ'},
		{field:'TDetailType',width:60,title:'����',
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
		{field:'TDetailSex',width:60,title:'�Ա�',
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
		{field:'TDetailUnit',width:60,title:'��λ'},
		{field:'TDetailRemark',width:100,title:'��ע'}
	]],
	onLoadSuccess : function(data){
		initOptionDR("");
	},	
	fitColumns: true,
	singleSelect:true,
	pagination:true,
	pageSize:20,
	fit:true
});

var optionListObj=$HUI.datagrid("#OptionList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.Evaluation",
		QueryName:"QueryQDOption",
		LinkDetailDR:$("#detailid-hidden").val()
	},
	onSelect:function(rowIndex,rowData){
		$("#optionid-hidden").val(rowData.TOPTID);
		$("#DOptionDR").combogrid("setValue",rowData.TOptionId);
		$("#DOptionDR").combogrid("disable");
		$("#OptionRelevance").val(rowData.TOptionRelevance);	
	},	
	columns:[[
		{field:'TOPTID',hidden:true,sortable:'true'},
		{field:'TOptionId',hidden:true,sortable:'true'},
		{field:'QDOOperation',width:60,title:'����',align:"center",
			formatter:function(value,row,index){
				return "<a href='#' onclick='doption_delete(\""+row.TOPTID+"\")'>\
				<img style='padding-top:4px;' title='ɾ����¼' alt='ɾ����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
				</a>";
			}
		},
		{field:'TOptionDesc',width:200,title:'����'},
		{field:'TOptionRelevance',width:80,title:'�÷�'},
		{field:'TOptionSex',width:60,title:'�Ա�',
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
		}
	]],
	fitColumns:true,
	pagination:true,
	pageSize:20,
	fit:true,
	displayMsg:""
});



/**
 * [�ʾ�������ݲ�ѯ]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_find(){
	var linkid=$("#H_EvaluationDetail").val();
	var detailid=$("#QDetailDR").combogrid("getValue");
	qdetailListObj.load({ClassName:"web.DHCPE.HM.Evaluation",QueryName:"QueryQDetail",EvaluationDR:linkid,DetailDR:detailid});
}

/**
 * [�ʾ�������ݱ���]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_save(){
	var parrefId=$("#H_EvaluationDetail").val();
	if(parrefId==""){
		$.messager.alert("��ʾ","�������ݲ���Ϊ�գ�","info");
		return false;
	}
	var id=$("#detailid-hidden").val();
	var detailid=$("#QDetailDR").combogrid("getValue");
	if(detailid==""|| detailid=="undefined"){
		$.messager.alert("��ʾ","�ʾ�������ݲ���Ϊ�գ�","info");
		return false;
	}
	var detailtype=$("#detailtype-hidden").val();
	var relevance=$("#Relevance").val();
	var expression=$("#Expression").val();
	if(detailtype=="T" || detailtype=="N" || detailtype=="D"){
		if (relevance=="") {
			$.messager.alert("��ʾ","�÷ֱ�¼��","info");
			return false;
		}
		if(expression==""){
			$.messager.alert("��ʾ","���ʽ����Ϊ�գ�","info");
			return false;
		}else{
			var IsVaild=tkMakeServerCall("web.DHCHM.QuestionDetailSet","IsValidExpression",expression)
			if(IsVaild=="0"){
				$.messager.alert("��ʾ","��Ч�ı��ʽ","info");
				return;
			}
		}
	}else{
		if (relevance!="") {
			$.messager.alert("��ʾ","ѡ�������������Ҳ�ά���÷֣�","info");
			return false;
		}
		if(expression!=""){
			$.messager.alert("��ʾ","ѡ�������ⲻ��Ҫ¼����ʽ��","info");
			return false;
		}
	}
	//ELDEvaluationDR^ELDQustionDetailDR^ELDScore^ELDExpression^ELDUpdateUserDR
	var valueStr=parrefId+"^"+detailid+"^"+relevance+"^"+expression+"^"+session["LOGON.USERID"];
	var ret=tkMakeServerCall("web.DHCPE.HM.Evaluation","UpdateQDetail",id,valueStr);
	ret=ret.split("^");
	if(ret[0]=="-1"){
		$.messager.alert("��ʾ","����ʧ�ܣ�"+ret[1],"info");
		return false;
	}else{
		$.messager.alert("��ʾ","����ɹ�","success");
		qdetail_clean();
		qdetailListObj.reload();
	}
}

/**
 * [ѡ�� ����]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function doption_save(){
	var parref=$("#detailid-hidden").val();
	if(parref==""){
		$.messager.alert("��ʾ","����ѡ���м�Ĺ������⣡","info");
		return false;
	}
	var detailType=$("#detailtype-hidden").val();
	if(detailType!="M" && detailType!="S"){
		$.messager.alert("��ʾ","��ѡ�����ⲻ��Ҫά��ѡ�","info");
		return false;
	}
	var id=$("#optionid-hidden").val();
	var optionId=$("#DOptionDR").combogrid("getValue");
	if(optionId==""|| optionId=="undefined"){
		$.messager.alert("��ʾ","ѡ���Ϊ�գ�","info");
		return false;
	}
	var relevance=$("#OptionRelevance").val();
	if(relevance==""){
		$.messager.alert("��ʾ","�÷ֱ�¼��","info");
		return false;
	}
	//OQDOParRef^OQDOOptionDR^OQDORelevance^OQDOUpdateUserDR
	var valueStr=parref+"^"+optionId+"^"+relevance+"^"+session["LOGON.USERID"];
	var ret=tkMakeServerCall("web.DHCPE.HM.Evaluation","UpdateQDOption",id,valueStr);
	ret=ret.split("^");
	if(ret[0]=="-1"){
		$.messager.alert("��ʾ","����ʧ�ܣ�"+ret[1],"info");
		return false;
	}else{
		$.messager.alert("��ʾ","����ɹ�","success");
		doption_clean();
		optionListObj.reload();
	}
}


/**
 * [ɾ���ʾ��������]
 * @param    {[int]}    id [��������ID]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_delete(id){
	$.messager.confirm("����","ɾ����ǰ��¼��",function(r){
		if(r){
			var ret=tkMakeServerCall("web.DHCPE.HM.Evaluation","DeleteQDetail",id);
			ret=ret.split("^");
			if(ret[0]=="-1"){
				$.messager.alert("��ʾ","ɾ��ʧ�ܣ�"+ret[1],"info");
				return false;
			}else{
				$.messager.alert("��ʾ","ɾ���ɹ�","success");
				qdetailListObj.reload();
				qdetail_clean();
			}
		}	
	})
}

/**
 * [ѡ�� ɾ��]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function doption_delete(id){
	$.messager.confirm("����","ɾ����ǰ��¼��",function(r){
		if(r){
			var ret=tkMakeServerCall("web.DHCPE.HM.Evaluation","DeleteQDOption",id);
			ret=ret.split("^");
			if(ret[0]=="-1"){
				$.messager.alert("��ʾ","ɾ��ʧ�ܣ�"+ret[1],"info");
				return false;
			}else{
				$.messager.alert("��ʾ","ɾ���ɹ�","success");
				optionListObj.reload();
				doption_clean();
			}
		}	
	});
}

/**
 * [�ʾ������������]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_clean(){
	$("#detailid-hidden").val("");
	$("#QDetailDR").combogrid("setValue","");
	$("#detailtype-hidden").val("");
	$("#Relevance").val("");
	$("#Expression").val("");
	initQDetailDR("");
	//qdetailListObj.reload();
	$("#QDetailList").datagrid('load',{
			ClassName:"web.DHCPE.HM.Evaluation",
			QueryName:"QueryQDetail",
			EvaluationDR:$("#H_EvaluationDetail").val(),
			DetailDR:""
			})
}

/**
 * [ѡ������]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function doption_clean(){
	$("#optionid-hidden").val("");
	$("#DOptionDR").combogrid("setValue","");
	$("#DOptionDR").combogrid("enable");
	$("#OptionRelevance").val("");
	optionListObj.reload();
}


function initQDetailDR(detailDesc)
{
	var setsObj=$HUI.combogrid("#QDetailDR",{
		panelWidth: 380,
		idField: 'SDLQuestionsDetailDR',
        textField: 'QDDesc',
        method: 'get',
        url:$URL+'?ClassName=web.DHCHM.QuestionnaireSet&QueryName=FindQD',
        onBeforeLoad:function(param){
        	if(detailDesc!==""){
        		param.Desc = detailDesc;
        	}else{
        		param.Desc=param.q;
        	}
			
		},
		mode:'remote',
		delay:200,
        columns: [[           				            			
			{field:'QDCode',title:'����',width:80},
			{field:'QDDesc',title:'����',width:200},
			{field:'QDType',title:'����',width:60,
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
			}},
			{field:'SDLQuestionsDetailDR',title:'ID',hidden:true}
		]],
        onSelect: function (rowIndex,rowData) {
        	if(rowIndex>-1){
        		$("#detailtype-hidden").val(rowData.QDType);
        	}    					
       	},
		fitColumns: true,
		pagination:true,
		pageSize:50,
		displayMsg:''
	});
	$("#QDetailDR").combogrid("enable");
} 
function initOptionDR(detailId)
{
	var optionObj=$HUI.combogrid("#DOptionDR",{
		panelWidth: 200,
		idField: 'QDOID',
        textField: 'QDODesc',
        method: 'get',
		url:$URL+'?ClassName=web.DHCHM.QuestionDetailSet&QueryName=FindQDOption&Active=Y',
        onBeforeLoad:function(param){
        	param.ParRef=detailId;		
		},
		onSelect:function(rowIndex,rowData){
			
		},
		mode:'remote',
		delay:200,
		columns:[[
			{field:'QDOID',hidden:true,sortable:'true'},
			{field:'QDODesc',width:'140',title:'����'},
			{field:'QDODefault',width:'40',title:'Ĭ��',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			}
		]],
		pageSize:50,
		fit:true,
		displayMsg:""
	});
	$("#DOptionDR").combogrid("enable");
}

/**
 * [����ҳ�沼����ʽ]
 * @Author   wangguoying
 * @DateTime 2020-04-22
 */
function setGridHeight()
{
	$(".panel-header.panel-header-gray").css("border-radius","4px 4px 0 0");//����Բ��
	$(".panel-header").css("padding","4px 5px");  //����panel  �Ͳ��� ����߶����

	$("#QDetailListDiv").height($("#CenterPanel").height()-186);
	qdetailListObj.resize();
	$("#OptionListDiv").height($("#EastPanel").height()-141);
	$("#OptionList").datagrid("resize");
}
function init(){
	setGridHeight();
	initQDetailDR("");
}
$(init);