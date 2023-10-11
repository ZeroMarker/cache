var hisCode="";
var hisDesc="";
var libCode="";
var libDesc="";				// ֪ʶ������ sufan2020-07-10 ������������code���ظ����������������code˫�ع���
var selHospId = "";			
var contrastEditRow = 0;		// 
var witchFlag = ""	// ������ ���his��flag��1 ���ϵͳ����Ϊ2

/// ҳ���ʼ������
function InitPageDefault(){
	
	//InitParams();	// ��ʼ������
	InitDataGrid();	// ��ʼ��datagrid
	InitTree();		// ��ʼ����
	InitButton();	// ��ʼ��button
	InitCombobox();	// ��ʼ��combobox
	
}

/// ��ʼ������
function InitParams(){}

/// ��ʼ��button
function InitButton(){
	
	///��ѯ����
     $('#FindTreeText').searchbox({
	    searcher:function(value,name){
		   ReloadTree();
	    }	   
	});	

	// ����¼���
	$('#sysSearch').bind("click",QueryLibList);
	
	// �س��¼���
	$('#sysDesc').bind("keyup",function(event){
		if(event.keyCode == "13"){
			QueryLibList();
		}
	});
	
	///�Ƿ�ƥ�� 
	$('#match').radio({onCheckChange:function(){
		QueryLibList();
	}})
	
	///�Ƿ�ƥ��(his���)
	$('#hismatch').radio({onCheckChange:function(){
		ReloadTree();
	}})

}

/// ��ʼ��combobox
function InitCombobox(){
	
	/// ��ʼ����֢��ϵ������
	var option = {
		panelHeight:"auto",
		mode:"remote",		
		valueField: "id", 
		textField: "text"       
	}; 
	var url = "" //$URL +"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+symptomRelId��
	new ListCombobox("symList",url,'',option).init(); 
	
		/// ��ʼ���ο����ݼ�����
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'id',
		textField:'text',
		multiple:true       
	}; 
	var url = "" //$URL + "?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+referenceId;
	new ListCombobox("refList",url,'',option).init(); 	
}

/// ��ʼ��datagrid
function InitDataGrid(){
	
	//��ʼ��֪ʶ���	
	// ����columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'check',title:'sel',checkbox:true},  //xww 2021-08-13
			{field:'CDCode',title:'����',width:100,sortable:true,align:'left'},
			{field:'CDDesc',title:'����',width:100,align:'left'},
			{field:'Parref',title:'���ڵ�id',width:100,align:'left',hidden:true},
			{field:'ParrefDesc',title:'���ڵ�',width:100,align:'left',hidden:true},
			{field:'CDLinkDr',title:'����',width:100,align:'left',hidden:true},
			{field:'CDLinkDesc',title:'��������',width:100,align:'left',hidden:true},
			{field:'KnowType',title:"��������",width:100,align:'left',hidden:true}					
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		remoteSort:false,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(index,row) {    
 			libCode = row.CDCode;
 			libDesc = row.CDDesc;		//sufan 2020-07-10 ����ȡdesc��code˫�ع��ˣ�code�����ظ����
  			witchFlag = 2;
  			QueryContrastList();
        },		
        onLoadSuccess:function(data){
           $(this).prev().find('div.datagrid-body').prop('scrollTop',0);              
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+diseaseId+"&parrefFlag=0&parDesc="+""+"&loginInfo="+LoginInfo+"&dataMirFlag=";
	new ListComponent('sysgrid', columns, uniturl, option).Init();
	
			
	var symEditor={  //������Ϊ�ɱ༭
		// ��֢��ϵ
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+symptomRelId,
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#constgrid").datagrid('getEditor',{index:editRow,field:'CCSymRelat'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#constgrid").datagrid('getEditor',{index:editRow,field:'CCSymRelatDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	
	var refEditor={  //������Ϊ�ɱ༭
		// �ο�����
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+referenceId,
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#constgrid").datagrid('getEditor',{index:editRow,field:'CCReference'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#constgrid").datagrid('getEditor',{index:editRow,field:'CCReferenceDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	//��ʼ�����չ�ϵ��
	/**
	 * ������չ�ϵ���columns
	 */
	var contrastcolumns=[[
		{field:'CCRowID',title:'id',width:100,hidden:true,sortable:true},
		{field:'check',title:'sel',checkbox:true},   //xww 2021-07-06
        {field:'CCLibCode',title:'֪ʶ�����',width:100,sortable:true,hidden:true},
        {field:'CCLibDesc',title:'֪ʶ������',width:100,sortable:true},
        {field:'CCHisCode',title:'His����',width:100,sortable:true},
        {field:'CCHisDesc',title:'His����',width:100,sortable:true},
        {field:'CCSymRelatDr',title:'��֢��ϵDr',width:100,hidden:true},
        {field:'CCSymRelat',title:'��֢��ϵ',width:100},  //editor:symEditor
        {field:'CCReferenceDr',title:'�ο�����Dr',width:100,hidden:true},
        {field:'CCReference',title:'�ο�����',width:100}, //editor:refEditor
        {field:'CCUser',title:'������',width:60},
        {field:'hospDesc',title:'ҽԺ',width:100,sortable:true,hidden:true},
        {field:'CCDicTypeDesc',title:'ʵ������',width:100,sortable:true,hidden:true},
        {field:'Source',title:'���״̬',width:80,
        	formatter:function(value,row,index){ 
					 if(value=='confirm'){
						 return "�����";
					 }
					 else if(value=='sourcecdss'){
						 return "�����";
					 }
					 else if(value=='sourcebgdata01'){
						 return "�����";
					 }
					 else if(value=='sourcebgdata02'){
						 return "�����";
					 }
					 else{
						  return value;
					 }
			} 
        },
        {field:'AuditSta',title:'��Դ',width:80,
        	formatter:function(value,row,index){ 
			
					 if(value=='confirm'){
						 return "";		//����
					 }
					 else if(value=='sourcecdss'){
						 return "CDSS";
					 }
					 else if(value=='sourcebgdata01'){
						 return "cdss�����ݺϼ�";
					 }
					 else if(value=='sourcebgdata02'){
						 return "cdss";
					 }
					 else{
						  return value;
					 }
	
			} 
        },
        {field:'opt',title:'����',width:100,align:'center',
			formatter:function(value,row,index){ 
				var btn =  '<img class="contrast" onclick="DeleteConstSym('+row.CCRowID+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
				return btn;  
			}  
        }
	]];
	
	/**
	 * ������չ�ϵ���datagrid
	 */
	var congrid = $HUI.datagrid("#constgrid",{
	    url:$URL,
        queryParams:{
	        ClassName:"web.DHCCKBDiagconstants",
			QueryName:"QueryContrastList",
			rowID:"",
			type:diseaseId,		
			loginInfo:LoginInfo
	    },
        columns: contrastcolumns,  //����Ϣ
        pagination: true,   //pagination	boolean	����Ϊ true��������������datagrid���ײ���ʾ��ҳ��������
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //singleSelect:true,
        idField:'CCRowID',
        rownumbers:true,    //����Ϊ true������ʾ�����кŵ��С�
        //toolbar:[],//��ͷ������֮��ķ�϶
        fitColumns:true, //����Ϊ true������Զ��������С�еĳߴ�����Ӧ����Ŀ�Ȳ��ҷ�ֹˮƽ����  
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
        },
        onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (contrastEditRow != ""||contrastEditRow == 0) { 
                $("#constgrid").datagrid('endEdit', contrastEditRow); 
            } 
            $("#constgrid").datagrid('beginEdit', rowIndex);                
            contrastEditRow = rowIndex; 
        }        
        
    	});
     $('#constgrid').datagrid('loadData',{total:0,rows:[]});  // �ÿ��������datagrid
}


/// ��ʼ��tree
function InitTree(){

	$('#diagtree').tree({
    	//url:LINK_CSP+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+extDiagId,
    	url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+ICDDiagDataId,
    	lines:true,
		animate:true,
		dnd:true,
		checkbox:true,
		onSelect: function(node){
	     	//��state�����յ�ǰ����ڵ��ѡ��״̬��true����ѡ�У�false����δѡ��
			var state = node.checked;
			//alert(node.checked);
			if(state==true){
			    //ѡ��������Ϊδѡ��
			 $("#diagtree").tree('uncheck',node.target);
			}else if(state==false){
			   //δѡ��������Ϊѡ��
			 $("#diagtree").tree('check',node.target);
			}
			hisCode = node.code;
			hisDesc = node.text;
			witchFlag = 1;
			QueryContrastList();
	     },
		
		onContextMenu: function(e, node){			
			e.preventDefault();
			$('#ruleTree').tree('select', node.target);
			// ��ʾ��ݲ˵�
			$('#treeMenu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onClick:function(node, checked){
		
	    },
	    onBeforeDrag:function(data){
		   /// ��קǰ�¼�������false�������ƶ��˽ڵ�
		   var node=$(this).tree('getSelected');
		   if (node === null){return;} 
		   var isLeaf=$(this).tree('isLeaf',node.target);
		   if(isLeaf==false){return false;}
		},
	    onBeforeDrop:function(target,source){       
�������� 	
        },
        onDrop:function(target,source,operate){        	
            
        },
        onLoadSuccess:function(node,data){	      
	    }
	});
}
/// ������
function ReloadTree(){
	//var desc=$.trim($("#FindTreeText").val());
	//$("#dictree").tree("search", desc)
	//$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //ȡ�����Ľڵ�ѡ��
	var matchFlag = $HUI.checkbox("#hismatch").getValue();
	matchFlag = matchFlag==true?"N":"";
	var Input=$.trim($HUI.searchbox("#FindTreeText").getValue());
	//var url = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+extDiagId +"&Input="+Input +"&matchFlag="+matchFlag;
	//var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+ICDDiagDataId +"&Input="+Input;
	if(Input==""){
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+ICDDiagDataId+"&Input=";
	}else{
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+ICDDiagDataId+"&Input="+Input;
	}
	
	$('#diagtree').tree('options').url =encodeURI(url);
	$('#diagtree').tree('reload');

}

///������������ǰ����֤
function CheckCondata(){
	
	/* his ��� */
	var nodes = $('#diagtree').tree('getChecked');
	if (nodes.length==0){
		$.messager.alert('��ʾ','������ѡ��һ����ϣ�','info');
		return;
	} 

	/* ��ȫ��ҩ������ */
  	var libData = $('#sysgrid').datagrid('getSelections');		
	if(libData.length==0){
		$.messager.alert('��ʾ','��ѡ��ϵͳ�����ٽ��ж��գ�','info');
		return;
	}
	
	var dataList = []; 
	for(var i=0;i<nodes.length;i++)
	{	
		//ֻ��Ҫ�������һ��
		if (nodes[i].children != undefined){
		 	continue;
		}
		for(var j=0;j<libData.length;j++)
		{
			var tmp = libData[j].CDCode +"^"+ libData[j].CDDesc +"^"+ nodes[i].code +"^"+ nodes[i].text +"^"+ diseaseId +"^"+ nodes[i].id; // diseaseId ��ҽ�����ֵ�id
			dataList.push(tmp);
		}
	}
	var params=dataList.join("&&");
	var hospId = "";
	OpenSymWin(1,params,hospId);
	
}

/// ���ݶ���
function Condata(params,hospId,symData){	
	runClassMethod("web.DHCCKBComContrast","saveConDataBat",{"params":params,"loginInfo":LoginInfo,"clientIP":ClientIPAdd,"selHospId":hospId,"symData":symData},function(jsonString){
		if (jsonString == '0') {
			$.messager.popover({msg: '���ճɹ���',type:'success',timeout: 1000});
		}else{
			var errorMsg ="����ʧ�ܣ�"
			$.messager.alert('������ʾ',errorMsg+"������룺"+jsonString,"error");				
		}			
		QueryContrastList();
	},'text',false);	
	
}

/// ��ѯ֪ʶ���ֵ�����
function QueryLibList(){
	if(diseaseId==""){
		$.messager.alert('������ʾ',"��ѡ��һ������","info");
		return;
	}
	var genDesc = $('#sysDesc').val();  // �ٴ�֪ʶ������
	var genMatch = $HUI.checkbox("#match").getValue(); //xww δƥ���� 2021-08-26
	$('#sysgrid').datagrid('load',{
		id:diseaseId,
		parrefFlag:0,
		parDesc:genDesc,
		loginInfo:LoginInfo,
		dataMirFlag:"",
		genMatchFlag:genMatch  //xww 2021-08-26 ��ȫ��ҩ��δƥ���־
	}); 
	$('#sysgrid').datagrid('unselectAll');  // ����б�ѡ������ 	
}

/// ��ѯ��������
function QueryContrastList()
{
	var selHospDesc = "";
	var constrID = "";
	$('#constgrid').datagrid('load',  {
		ClassName:"web.DHCCKBDiagconstants",
		QueryName:"QueryContrastList",
		 rowID:constrID,			
		 type:diseaseId, 
		 queryLibCode:(witchFlag==2)?libCode:"",
		 queryLibDesc:(witchFlag==2)?libDesc:"",
		 queryHisCode:(witchFlag==1)?hisCode:"",
		 queryHisDesc:(witchFlag==1)?hisDesc:"",
		 loginInfo:LoginInfo,
		 selHospDesc:selHospDesc		
    });
    
    $('#constgrid').datagrid('unselectAll');  // ����б�ѡ������ 	
}

/// �����޸Ĳ�֢��ϵ�Ͳο�����
function CheckUpdateDiagnosRel(){
	
	/* �Ѷ������� */
  	var constData = $('#constgrid').datagrid('getSelections');		
	if(constData.length==0){
		$.messager.alert('��ʾ','��ѡ�����ݺ��ٽ����޸ģ�','info');
		return;
	}
	
	OpenSymWin(2,"","");
}
/// �����޸Ĳ�֢��ϵ�Ͳο�����
function BatchUpdateDiagnosRel(symData,refData){

	if ((symData == "")&&(refData=="")){
		$.messager.alert('��ʾ','��ѡ�����ݺ��ٽ����޸ģ�','info');
		return;
	}
	/* �Ѷ������� */
  	var constData = $('#constgrid').datagrid('getSelections');		
	var constArr= [];
	var refArr = [];
	var symId = "";
	for(var i=0;i<constData.length;i++)	{
		constArr.push(constData[i].CCRowID);
		//refArr.push(constData[i].CCReferenceDr);
		//symId = constData[i].CCSymRelatDr;
	}

	var constStr = constArr.join("^");	
	UpdateDiagnosRel(constStr,symData,refData);
}

/// �޸Ĳ�֢��ϵ�Ͳο�����
function UpdateDiagnosRel(constStr,symId,refStr){
	
	runClassMethod("web.DHCCKBDiagconstants","UpdateDiagnosRel",{"constStr":constStr,"symId":symId,"refStr":refStr},function(jsonString){
		
		if (jsonString == '0') {
			$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
		}else{
			var errorMsg ="�޸�ʧ�ܣ�"
			$.messager.alert('������ʾ',errorMsg+"������룺"+jsonString,"error");				
		}			
		QueryContrastList();
	},'text',false);
}


/// �������ݶ���ʱ,���Ӽ�����ϵѡ��
function OpenSymWin(flag,params,hospId) {
	
	CleanCombobox();
	$("#symWin").show(); 
	var url = $URL +"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+symptomRelId;
	$('#symList').combobox('reload',url); 
	
	var url = $URL + "?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+referenceId;
	$('#refList').combobox('reload',url);
	
	var myWin = $HUI.dialog("#symWin",{
		iconCls:'icon-w-save',
		resizable:true,
		title:'��֢��ϵ',
		modal:true,
		//height:$(window).height()-70,
		buttons:[{
			text:'����',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){				
				var symArr= $("#symList").combobox('getValues');
				var refArr  = $("#refList").combobox('getValues');
				var symData = symArr.join("^") + "&&" + refArr.join("^");
				if (flag ==1){	// ���ݶ��ձ��淽��
					Condata(params,hospId,symData);
				}
				else{	// ֱ���޸Ĳ�֢��ϵ����
					BatchUpdateDiagnosRel(symArr.join("^"),refArr.join("^"));
				}
				myWin.close();
			}
		},{
			text:'�ر�',
			//iconCls:'icon-cancel',
			handler:function(){
				myWin.close();
			}
		}]
	});
}
	
/// ɾ�����չ�ϵ
function DeleteConstSym(constId){
	
	runClassMethod("web.DHCCKBDiagconstants","DeleteConstSym",{"constId":constId},function(jsonString){		
		if (jsonString == '0') {
			$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
		}else{
			$.messager.popover({msg: 'ɾ��ʧ�ܣ�',type:'success',timeout: 1000});				
		}			
		QueryContrastList();
	},'text',false);
}


/// ���������Ĭ������
function CleanCombobox(){
	
	$('#symList').combobox('clear'); 	
	$('#refList').combobox('clear');
}

/// ϵͳ�б�����
function ClearLibData(){
	$('#sysgrid').datagrid('clearChecked'); 
	$('#sysgrid').datagrid('clearSelections'); 
	libCode="";
	libDesc="";	
	$("#sysDesc").val("");
}

/// his�б�����
function ClearHisData(){
	$('#FindTreeText').searchbox('setValue','');
	InitTree();
	hisCode="";
	hisDesc="";

}

///��ʵ--sufan 2022-06-01
function sureoprat(comflag)
{
	var confirmDate=SetDateTime("date");
	var confirmTime=SetDateTime("time");
	var setFlag="confirm";        //��ʵ���ݱ��
	if(comflag==1){
		var setFlag="confirm";        //��ʵ���ݱ��
	}else{
		var setFlag="cancelconfirm";        //��ʵ���ݱ��

	}
	var dicName="DHC_CKBComContrast";
	var operator=LgUserID
	var conArr = [];
	var selItems = $('#constgrid').datagrid('getSelections');
	for(var i=0;i<selItems.length;i++){
		var conId = selItems[i].CCRowID;
		var source = selItems[i].Source;
		if((comflag == 1)&&(source==1)){continue;}
		if((comflag == -1)&&(source!=1)){continue;}
		conArr.push(conId);
		
	}
	var params = conArr.join("&&");
	runClassMethod("web.DHCCKBWriteLog","InsertAllDicLog",{"DicDr":dicName,"params":params,"Function":setFlag,"Operator":operator,"OperateDate":confirmDate,"OperateTime":confirmTime,"Scope":"","ScopeValue":"","ClientIPAddress":'',"Type":"log"},function(getString){
		if (getString == 0){
			Result = "�����ɹ���";
		}else{
			Result = "����ʧ�ܣ�";	
		}
	},'text',false);
	$.messager.popover({msg: Result,type:'success',timeout: 1000});
	$('#constgrid').datagrid('reload');
	
	
}

function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}

/// JQuery ��ʼ��ҳ��
$(function(){ InitPageDefault(); })