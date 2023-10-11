//predictner.js
$(function(){
	initPageDefault();
})

var editIndex = undefined,editIndexT =undefined; 

function initPageDefault(){
	
	InitButton();		// ��ť��Ӧ�¼���ʼ��
	initList();
	initTabooList();
	initCombobox();
	
}
/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#submit").bind("click",submit); 
	$("#save").bind("click",saveUsage); 
	$("#submitTaboo").bind("click",submitTaboo); 
	$("#saveTaboo").bind("click",saveTaboo); 

}
function submit(){
	if(editIndex>=0){
		$("#predictList").datagrid('endEdit', editIndex);
		editIndex = undefined;
	}
	text=$("#input").val()
	$('#predictList').datagrid('load',{'text':text,textType:1});
}
function submitTaboo(){
	if(editIndexT>=0){
		$("#tabooList").datagrid('endEdit', editIndexT);
		editIndexT = undefined;
	}
	text=$("#inputTaboo").val()
	$('#tabooList').datagrid('load',{'text':text,textType:2});
}
function saveUsage(){
	if(editIndex>=0){
		$("#predictList").datagrid('endEdit', editIndex);
		editIndex = undefined;
	}

	SaveRuleRow("RuleUsage");
}
function saveTaboo(){
	if(editIndexT>=0){
		$("#tabooList").datagrid('endEdit', editIndexT);
		editIndexT = undefined;
	}
	SaveRuleRow("OtherLib");
}
///ʵ�������б�
function initList()
{
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: false //���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{propId:'',field:'ROW_NUM',title:'������',width:50,hidden:true},
		/*
		{propId:72,field:'Library',title:'Ŀ¼',width:70,
			 formatter:function(value,row){
                            row.Library="�÷�����";
                            return row.Library;
                        }
		},*/
		{propId:91,field:'SPECIAL',title:'��Ⱥ',width:100,editor:textEditor},
		{propId:85,field:'AGE',title:'����',width:70,editor:textEditor},
		{propId:74533,field:'DISEASE',title:'����',width:100,editor:textEditor},
		{propId:82168,field:'ZHDISEASE',title:'����(��)',width:100,editor:textEditor},
		{propId:46,field:'METHOD',title:'��ҩ;��',width:70,editor:textEditor},
		{propId:45,field:'FREQ',title:'Ƶ��',width:70,editor:textEditor},
		{propId:49,field:'ONCE_FORM_UNIT',title:'ÿ������',width:70,editor:textEditor},
		{propId:48,field:'TREATMENT',title:'�Ƴ�',width:70,editor:textEditor},
		{propId:86,field:'WEIGHT',title:'����',width:70,editor:textEditor},
		{propId:52,field:'DAYS_FORM_UNIT',title:'ÿ������',width:70,editor:textEditor},
		{propId:51,field:'MONCE_FORM_UNIT',title:'ÿ�μ���',width:70,editor:textEditor},
		{propId:54,field:'MDAYS_FORM_UNIT',title:'ÿ�ռ���',width:70,editor:textEditor},
		{propId:50,field:'HONCE_FORM_UNIT',title:'ÿ�������',width:70,editor:textEditor},
		{propId:53,field:'HDAYS_FORM_UNIT',title:'ÿ�������',width:70,editor:textEditor},
		{propId:74698,field:'FLAG',title:'��ʾ���',width:50,editor:textEditor,
			 formatter:function(value,row){
                            row.FLAG="Y";
                            return row.FLAG;
                        }
		},
		{propId:82,field:'TEXT',title:'��ʾ',width:200,editor:textEditor}
		//{propId:49,field:'ONCE_FORM',title:'ÿ������',width:70},
		//{propId:'',field:'ONCE_UNIT',title:'��λ',width:50},
		//{propId:52,field:'DAYS_FORM',title:'ÿ������',width:70},
		//{propId:'',field:'DAYS_UNIT',title:'��λ',width:50},	
		//{propId:51,field:'MONCE_FORM',title:'ÿ�μ���',width:70},
		//{propId:'',field:'MONCE_UNIT',title:'��λ',width:50},
		//{propId:54,field:'MDAYS_FORM',title:'ÿ�ռ���',width:70},
		//{propId:'',field:'MDAYS_UNIT',title:'��λ',width:50},	
		//{propId:50,field:'HONCE_FORM',title:'ÿ�������',width:70},
		//{propId:'',field:'HONCE_UNIT',title:'��λ',width:50},
		//{propId:53,field:'HDAYS_FORM',title:'ÿ�������',width:70},
		//{propId:'',field:'HDAYS_UNIT',title:'��λ',width:50},	
	]];
	
	///  ����datagrid
	var option = {
		nowrap:false,
		//fitColumns:true,
		singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//˫��ѡ���б༭
	    onClickRow: function(rowIndex,rowData){
	 	}, 
	 	onClickCell:onClickCell
	};
	
	var uniturl = "dhcapp.broker.csp?ClassName=web.PredictModel&MethodName=WebServicePredict";
	//var uniturl ="http://127.0.0.1:5000/predict?text="
	new ListComponent('predictList', columns, uniturl, option).Init();
}

function endEditing(){
    if (editIndex == undefined){return true}
    if ($('#predictList').datagrid('validateRow', editIndex)){
        $('#predictList').datagrid('endEdit', editIndex);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function onClickCell(index, field){
    if (editIndex != index){
        if (endEditing()){
            $('#predictList').datagrid('selectRow', index)
                    .datagrid('beginEdit', index);
            var ed = $('#predictList').datagrid('getEditor', {index:index,field:field});
            if (ed){
                ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
            }
            editIndex = index;
        } else {
            setTimeout(function(){
                $('#predictList').datagrid('selectRow', editIndex);
            },0);
        }
    }
}

function initTabooList()
{
	/// �ı��༭��
	var textEditor={
		type: 'textarea',//���ñ༭��ʽ	
		options: {
			required: false //���ñ༭��������	
		}
	}
	
	///  ����columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{propId:'',field:'ROW_NUM',title:'������',width:50,rowspan:2,hidden:true},
		/*
		{propId:72,field:'Library',title:'Ŀ¼',width:70,rowspan:2,
			 formatter:function(value,row){
                            row.Library="����֢";
                            return row.Library;
                        }
		},*/
		{propId:91,field:'SPECIAL',title:'��Ⱥ',width:100,editor:textEditor}, 
		{propId:93,field:'PROF',title:'ְҵ',width:100,editor:textEditor},
		{propId:85,field:'AGE',title:'����',width:70,editor:textEditor},
		{propId:89,field:'SEX',title:'�Ա�',width:50,editor:textEditor},
		{propId:74533,field:'DISEASE',title:'����',width:100,editor:textEditor},
		{propId:82168,field:'ZHDISEASE',title:'����(��)',width:100,editor:textEditor},
		
		//{title:'����',width:50,colspan:4},		
	//],[
		{propId:'74532',field:'DRUG',title:'ҩƷ',width:100,editor:textEditor},
		{propId:'42',field:'GENER',title:'ͨ����',width:100,editor:textEditor},
		{propId:'39',field:'INGR',title:'�ɷ�',width:100,editor:textEditor},
		{propId:'259671',field:'CAT',title:'����',width:100,editor:textEditor},
		{propId:'',field:'ENV',title:'����',width:100,editor:textEditor},
		{propId:'74959',field:'LABITEM',title:'����ָ��',width:100,editor:textEditor},
		{propId:'',field:'FREQ',title:'���鷶Χֵ',width:70,editor:textEditor},
		{propId:'',field:'ONCE_FORM',title:'������',width:70,editor:textEditor},
		{propId:'74698',field:'FLAG',title:'��ʾ���',width:50,editor:textEditor,
			 formatter:function(value,row){
                            row.FLAG="Y";
                            return row.FLAG;
                        }
		},
		{propId:82,field:'TEXT',title:'��ʾ',width:200,editor:textEditor},
		{propId:83,field:'CONLEVEL',title:'��������',width:70,editor:textEditor},
		{propId:81,field:'LEVELFLAG',title:'������',width:70,editor:textEditor},
		]
		];
	
	///  ����datagrid
	var option = {
		nowrap:false,
		//fitColumns:true,
		singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//˫��ѡ���б༭
	    onClickRow: function(rowIndex,rowData){
	 	}, 
	 	onClickCell:onClickCellT
	};
	
	//var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryDicAttr&params="+params;
	//var uniturl ="http://127.0.0.1:5000/predict?text="
	var uniturl = "dhcapp.broker.csp?ClassName=web.PredictModel&MethodName=WebServicePredict";
	new ListComponent('tabooList', columns, uniturl, option).Init();
}

function endEditingT(){
    if (editIndexT == undefined){return true}
    if ($('#tabooList').datagrid('validateRow', editIndexT)){
        $('#tabooList').datagrid('endEdit', editIndexT);
        editIndexT = undefined;
        return true;
    } else {
        return false;
    }
}
function onClickCellT(index, field){
    if (editIndexT != index){
        if (endEditingT()){
            $('#tabooList').datagrid('selectRow', index)
                    .datagrid('beginEdit', index);
            var ed = $('#tabooList').datagrid('getEditor', {index:index,field:field});
            
            if (ed){
                ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
            }
            editIndexT = index;
        } else {
            setTimeout(function(){
                $('#tabooList').datagrid('selectRow', editIndexT);
            },0);
        }
    }
}


function initCombobox(){
	///ģ������
	$('#drug').combobox({
    	url:LINK_CSP+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource=105&filed:DrugData',
    	lines:true,
		animate:true,
	});	
}
///�������
function SaveRuleRowOld()
{
	var TempId=75369;
	var rowsData = $("#predictList").datagrid('getSelected');
	if(rowsData.length<=0||rowsData==null){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataListAll = [];
	var dataList = [];
	var desc="",value="",tmp="";
	value=81224 //ҩƷ����
	desc=$('#drug').combobox("getText");
	if(value==""){
		$.messager.alert("��ʾ","��ѡ��ҩƷ!");
		return;
	}
	tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
	dataList.push(tmp);
	var opts = $('#predictList').datagrid('getColumnFields');
	for(var i=0;i<opts.length;i++){
		var colOpt=$('#predictList').datagrid('getColumnOption',opts[i]);
		if(colOpt.propId==''){continue;};
		value=colOpt.propId;
		desc=rowsData[colOpt.field];
		tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
		dataList.push(tmp);
		/*
		if(colOpt.field.search("FORM")>0){
			var unit=colOpt.field.replace('FORM','UNIT');
			value=colOpt.propId;
			desc=rowsData[colOpt.field]+rowsData[unit];
			tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
			dataList.push(tmp);
		}else{
			value=colOpt.propId;
			desc=rowsData[colOpt.field];
			tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
			dataList.push(tmp);
		}
		*/
	}
	var mListData=dataList.join("$$");
	dataListAll.push(mListData);
	var mListDataAll=dataListAll.join("@@");
	//alert(mListDataAll);
	//��������
	//return;
	runClassMethod("web.DHCCKBRuleMaintain","saveAll",{"params":mListDataAll},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		$('#ruleList').datagrid('reload'); //���¼���			
	});	
}

///�������
function SaveRuleRow(libName)
{
	//debugger
	//var TempId=75369; Ŀ¼id
	var rowData={}
	var obj="predictList"
	if(libName=="RuleUsage"){
		obj="predictList"
	}
	if(libName=="OtherLib"){
		obj="tabooList"
	}
	rowsData = $("#"+obj).datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataListAll = [];
	var dataList = [];
	var desc="",value="",tmp="";
	value=81224 //ҩƷ����
	desc=DrugDesc
	tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ; //ҩƷ�ֶ�
	dataList.push(tmp);
	
	var DrugLibaryID=serverCall("web.DHCCKBRuleText","DrugLibaryDataID",{"dicId":TempId});  		//��ȡģ��󶨵�Ŀ¼��ID������
	var array=DrugLibaryID.split("^")
	value=array[0];		//Ŀ¼ID��73��
	desc=array[1];	//Ŀ¼��������Ӧ֢��
	tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ; //Ŀ¼ģ������ �÷���������Ӧ֢����
	dataList.push(tmp);
	
	var opts = $("#"+obj).datagrid('getColumnFields');
	for(var i=0;i<opts.length;i++){
		var colOpt=$("#"+obj).datagrid('getColumnOption',opts[i]);
		if(colOpt.propId==''){continue;};
		value=colOpt.propId;
		desc=rowsData[colOpt.field];
		if(desc==""){continue;};
		tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
		dataList.push(tmp);
	}
	var mListData=dataList.join("$$");
	dataListAll.push(mListData);
	var mListDataAll=dataListAll.join("@@");
	//alert(mListDataAll);
	//��������
	runClassMethod("web.DHCCKBRuleText","saveAll",{"params":mListDataAll},function(jsonString){
		if (jsonString == 0){
			if(libName=="RuleUsage"){
				subRuleRow();
			}
			if(libName=="OtherLib"){
				subTabooRow(array[1]);
			}
			//$.messager.alert('��ʾ','����ɹ���','info');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		//$('#ruleList').datagrid('reload'); //���¼���			
	});	
}
///�������
function subTabooRow(libName)
{
	//debugger
	//alert(TempId+" "+DrugDesc);
	var rowsData = $("#tabooList").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var retData={};
	
	var opts = $('#tabooList').datagrid('getColumnFields');
	for(var i=0;i<opts.length;i++){
		var colOpt=$('#tabooList').datagrid('getColumnOption',opts[i]);
		if(colOpt.propId==''){continue;};
		var value=colOpt.propId;
		var desc=rowsData[colOpt.field];
		retData[value]=desc
	}
	if(libName=="ҩ�����" || libName=="�������"){
		if(retData['83']==""){
			retData['83']="����";
			retData['81']="��ֹ";
		}
	}else{
		if(retData['83']==""){
			retData['83']="����";
			retData['81']="����";  //ԭ��ʾ xww 2021-08-17 ��������
		}
	}
	window.parent.addPredictRow(retData);
}
///�������
function subRuleRow()
{
	//debugger
	var rowsData = $("#predictList").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var retData={};
	
	var opts = $('#predictList').datagrid('getColumnFields');
	for(var i=0;i<opts.length;i++){
		var colOpt=$('#predictList').datagrid('getColumnOption',opts[i]);
		if(colOpt.propId==''){continue;};
		var value=colOpt.propId;
		var desc=rowsData[colOpt.field];
		retData[value]=desc

	}
	window.parent.addPredictRow(retData);
}