/**
 * �ײ͹���ά��  dhchm.ordsetslink.js
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


var sexObj=$HUI.combobox("#SexDR",{
	url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
	valueField:'id',
	textField:'sex'
});
var maritalObj=$HUI.combobox("#MaritalDR",{
	url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
	valueField:'id',
	textField:'married'
});
var ordsetsListObj=$HUI.datagrid("#OrdSetsList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.OrdSetsLink",
		QueryName:"QueryLinkOrdSets",
		LocID: session["LOGON.CTLOCID"]
	},
	onSelect:function(rowIndex,rowData){
		if(rowIndex>-1){
			linkordsets_clean();
			$("#linkid-hidden").val(rowData.TID);
			initOrdSetsDR(rowData.TOrdSetsDesc);
			$("#OrdSetsDR").combogrid("setValue",rowData.TOrdSetsId);
			$("#OrdSetsDR").combogrid("disable");
			$("#SexDR").combobox("setValue",rowData.TSexId);
			$("#MaritalDR").combobox("setValue",rowData.TMaritalId);
			$("#MinAge").val(rowData.TMinAge);
			$("#MaxAge").val(rowData.TMaxAge);
			if(rowData.TOrdSetsType=="A"){
				$("#add_ordsets").radio("check");
			}else{
				$("#main_ordsets").radio("check");
			}
			qdetail_clean();
			qdetail_find();	
			doption_clean();
			optionListObj.load({
				ClassName:"web.DHCPE.HM.OrdSetsLink",
				QueryName:"QueryQDOption",
				LinkDetailDR:""
			});	
		}
	},
	onDblClickRow:function(index,row){
														
	},	
	columns:[[
		{field:'TID',hidden:true,sortable:'true'},
		{field:'TOrdSetsId',hidden:true,sortable:'true'},
		{field:'TSexId',hidden:true,sortable:'true'},
		{field:'TMinAge',hidden:true,sortable:'true'},
		{field:'TMaxAge',hidden:true,sortable:'true'},
		{field:'TMaritalId',hidden:true,sortable:'true'},
		{field:'TOperation',width:60,title:'����',align:'center',
			formatter:function(value,row,index){
				return "<a href='#' onclick='linkordsets_delete(\""+row.TID+"\")'>\
				<img style='padding-top:4px;' title='ɾ����¼' alt='ɾ����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
				</a>";
			}
                    
		},
		{field:'TOrdSetsDesc',width:180,title:'�ײ�����'},
		{field:'TSexDesc',width:60,title:'�Ա�'},
		{field:'TAgeRange',width:80,title:'���䷶Χ',align:'center',
			formatter:function(value,row,index){
				if((row.TMinAge=="")&&(row.TMaxAge=="")){
					return "";
				}else{
					return row.TMinAge+"-"+row.TMaxAge;
				}
			}                   
		},
		{field:'TMaritalDesc',width:80,title:'����״��'},
		{field:'TOrdSetsType',width:80,title:'����',
			formatter:function(value,row,index){
				var dispalyTxt="";
				if (value == 'M') {
                	dispalyTxt='���ײ�';
           		}
            	if (value == 'A') {
                	dispalyTxt='�����';
           		}
            	return dispalyTxt;
			}
		}
	]],
	fitColumns: true,
	singleSelect:true,
	pagination:true,
	pageSize:20,
	fit:true
});

var qdetailListObj=$HUI.datagrid("#QDetailList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.OrdSetsLink",
		QueryName:"QueryQDetail",
		LinkDR:$("#linkid-hidden").val()
	},
	onSelect:function(rowIndex,rowData){
		if(rowIndex>-1){
			$("#detailid-hidden").val(rowData.TOQDID);
			initQDetailDR(rowData.TDetailDesc);	
			$("#QDetailDR").combogrid("setValue",rowData.TDetailId);
			$("#QDetailDR").combogrid("disable");
			$("#detailtype-hidden").val(rowData.TDetailType);
			$("#Relevance").val(rowData.TRelevance);
			$("#Expression").val(rowData.TExpression);
			initOptionDR(rowData.TDetailId);
			optionListObj.load({
				ClassName:"web.DHCPE.HM.OrdSetsLink",
				QueryName:"QueryQDOption",
				LinkDetailDR:rowData.TOQDID
			});		
			doption_clean();
		}
	},
	onDblClickRow:function(index,row){
														
	},	
	columns:[[
		{field:'TOQDID',hidden:true,sortable:'true'},
		{field:'TDetailId',hidden:true,sortable:'true'},
		{field:'TOperation',width:60,title:'����',align:'center',
			formatter:function(value,row,index){
				return "<a href='#' onclick='qdetail_delete(\""+row.TOQDID+"\")'>\
				<img style='padding-top:4px;' title='ɾ����¼' alt='ɾ����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
				</a>";
			}
                    
		},
		{field:'TDetailDesc',width:180,title:'��������'},
		{field:'TRelevance',width:60,title:'������'},
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
	fitColumns: true,
	singleSelect:true,
	pagination:true,
	pageSize:20,
	fit:true
});

var optionListObj=$HUI.datagrid("#OptionList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCPE.HM.OrdSetsLink",
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
				<img style='padding-top:4px;' title='ɾ����¼' alt='ɾ����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
				</a>";
			}
		},
		{field:'TOptionDesc',width:200,title:'����'},
		{field:'TOptionRelevance',width:80,title:'������'},
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
 * [�����ײͲ�ѯ]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function linkordsets_find(){
	var ordsetsid=$("#OrdSetsDR").combogrid("getValue");
	var sexid=$("#SexDR").combobox("getValue");
	var maritalid= $("#MaritalDR").combobox("getValue");
	var minage=$("#MinAge").val();
	var maxAge=$("#MaxAge").val();
	ordsetsListObj.load({ClassName:"web.DHCPE.HM.OrdSetsLink",QueryName:"QueryLinkOrdSets",OrdSetsDR:ordsetsid,SexDR:sexid,MaritalDR:maritalid,LocID: session["LOGON.CTLOCID"]});
}

/**
 * [�ʾ�������ݲ�ѯ]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_find(){
	var linkid=$("#linkid-hidden").val();
	var detailid=$("#QDetailDR").combogrid("getValue");
	qdetailListObj.load({ClassName:"web.DHCPE.HM.OrdSetsLink",QueryName:"QueryQDetail",LinkDR:linkid,DetailDR:detailid});
}

/**
 * [�����ײͱ���]
 * @Author   wangguoying
 * @DateTime 2020-04-22
 */
function linkordsets_save(){
	var id=$("#linkid-hidden").val();
	var ordsetsid=$("#OrdSetsDR").combogrid("getValue");
	if(ordsetsid==""|| ordsetsid=="undefined"){
		$.messager.alert("��ʾ","�ײͲ���Ϊ�գ�","info");
		return false;
	}
	if(!$("#OrdSetsDR").combogrid("isValid")){
		$.messager.alert("��ʾ","�ײ��Ѵ���","info");
		return false;
	}
	var sexid=$("#SexDR").combobox("getValue");
	var maritalid= $("#MaritalDR").combobox("getValue");
	var minage=$("#MinAge").val();
	var maxAge=$("#MaxAge").val();
	if(minage>maxAge){
		$.messager.alert("��ʾ","���䷶Χ����","info");
		return false;
	}

	var setsTypeObj = $("input[name='OrdSetsType']:checked");
	var setsType=setsTypeObj.val();
	if(setsType==""){
		$.messager.alert("��ʾ","�ײ����Ͳ���Ϊ��","info");
		return false;
	}

	//"OLOrdSetsDR^OLSexDR^OLMinAge^OLMaxAge^OLMaritalDR^OLOrdSetsType^OLUpdateUserDR^OLTUpdateDate^OLUpdateTime"
	var valueStr=ordsetsid+"^"+sexid+"^"+minage+"^"+maxAge+"^"+maritalid+"^"+setsType+"^"+session["LOGON.USERID"];
	var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","UpdateLinkOrdSets",id,valueStr,session["LOGON.CTLOCID"]);
	ret=ret.split("^");
	if(parseInt(ret[0])<0){
		$.messager.alert("��ʾ","����ʧ�ܣ�"+ret[1],"info");
		return false;
	}else{
		$.messager.alert("��ʾ","����ɹ�","success");
		linkordsets_clean();
		ordsetsListObj.reload();
	}
	
}

/**
 * [�ʾ�������ݱ���]
 * @Author   wangguoying
 * @DateTime 2020-04-23
 */
function qdetail_save(){
	var linkId=$("#linkid-hidden").val();
	if(linkId==""){
		$.messager.alert("��ʾ","����ѡ���������ײͣ�","info");
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
			$.messager.alert("��ʾ","�����ȱ�¼��","info");
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
			$.messager.alert("��ʾ","ѡ�������������Ҳ�ά�������ȣ�","info");
			return false;
		}
		if(expression!=""){
			$.messager.alert("��ʾ","ѡ�������ⲻ��Ҫ¼����ʽ��","info");
			return false;
		}
	}
	//OQDParRef^OQDDeatilDR^OQDRelevance^OQDExpression^OQDUpdateUserDR
	var valueStr=linkId+"^"+detailid+"^"+relevance+"^"+expression+"^"+session["LOGON.USERID"];
	//alert(valueStr);
	var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","UpdateQDetail",id,valueStr);
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
		$.messager.alert("��ʾ","�����ȱ�¼��","info");
		return false;
	}
	//OQDOParRef^OQDOOptionDR^OQDORelevance^OQDOUpdateUserDR
	var valueStr=parref+"^"+optionId+"^"+relevance+"^"+session["LOGON.USERID"];
	var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","UpdateQDOption",id,valueStr);
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
 * [�����ײ�ɾ��]
 * @param    {[int]}    id [����ID]
 * @Author   wangguoying
 * @DateTime 2020-04-22
 */
function linkordsets_delete(id){
	$.messager.confirm("����","ɾ����ǰ�����ײͣ�",function(r){
		if(r){
			var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","DeleteLinkOrdSets",id);
			ret=ret.split("^");
			if(ret[0]=="-1"){
				$.messager.alert("��ʾ","ɾ��ʧ�ܣ�"+ret[1],"info");
				return false;
			}else{
				$.messager.alert("��ʾ","ɾ���ɹ�","success");
				ordsetsListObj.reload();
			}
		}	
	});
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
			var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","DeleteQDetail",id);
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
			var ret=tkMakeServerCall("web.DHCPE.HM.OrdSetsLink","DeleteQDOption",id);
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
 * [�����ײ�����]
 * @Author   wangguoying
 * @DateTime 2020-04-22
 */
function linkordsets_clean(){
	$("#OrdSetsDR").combogrid("setValue","");
	$("#SexDR").combobox("setValue","");
	$("#MaritalDR").combobox("setValue","");
	$("#MinAge").val("");
	$("#MaxAge").val("");
	$("#linkid-hidden").val("");
	var setsTypeObj = $("input[name='OrdSetsType']:checked");
	setsTypeObj.radio("uncheck");
	$("#main_ordsets").radio("check");
	initOrdSetsDR("");
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

}

/**
 * [��ʼ���ײ��������]
 * @param    {[string]}    desc [�ײ�����]
 * @Author   wangguoying
 * @DateTime 2020-04-21
 */
function initOrdSetsDR(desc)
{
	var setsObj=$HUI.combogrid("#OrdSetsDR",{
		panelWidth: 380,
		idField: 'OrderSetId',
		textField: 'OrderSetDesc',
		method: 'get',
		url:$URL+'?ClassName=web.DHCPE.HandlerOrdSetsEx&QueryName=queryOrdSet',
		onBeforeLoad:function(param){
    		param.Type='ItemSet';
			param.BType="B";
            param.LocID=session['LOGON.CTLOCID'];
            param.hospId=session['LOGON.HOSPID'];
            param.UserID=session['LOGON.USERID'];
    		if(desc!="") param.OrdSetSDesc=desc;
			else param.OrdSetSDesc = param.q;
		},
		mode:'remote',
		delay:200,
		columns: [[           				            			
			{field:'OrderSetDesc',title:'�ײ�����',width:200},
			{field:'OrderSetPrice',title:'���',align:'right',width:70},
			{field:'OrderSetId',title:'ID',width:80}
		]],
		fitColumns: true,
		pagination:true,
		pageSize:50,
		displayMsg:''
	});
	$("#OrdSetsDR").combogrid("enable");
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
		url:$URL+'?ClassName=web.DHCHM.QuestionDetailSet&QueryName=FindQDOption',
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
	$("#OrdSetsListDiv").height($("#WestPanel").height()-211);
	$("#OrdSetsList").datagrid("resize");
	$("#QDetailListDiv").height($("#CenterPanel").height()-186);
	qdetailListObj.resize();
	$("#OptionListDiv").height($("#EastPanel").height()-141);
	$("#OptionList").datagrid("resize");
}
function init(){
	setGridHeight();
	initOrdSetsDR("");
	initQDetailDR("");
}
$(init);