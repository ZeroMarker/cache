/// Author:      guozizhu
/// CreateDate:  2019-09-30
/// Descript:    �ٴ�֪ʶ����His�����ݶ��մ洢
/// CSP:         dhcckb.datacontrastandstorage.csp
/// JS:          datacontrastandstorage.js

var dicID="";									// �ֵ�id
var dicCode="";							// �ֵ����
var libCode="";
var hisCode="";
var libDesc="";							//֪ʶ������ sufan2020-07-10 ������������code���ظ����������������code˫�ع���
var stopFlag=""     		//ͣ�ñ��-����ӳ���ѯ��
var redictext=""						//�ض���text
var comparedata=""  		//��������id
var selHospId = "";			//Ժ��  sufan 2020-07-16
var hisID="";
$(function(){
	//��ʼ������Ĭ����Ϣ
	initDefault();
	
	//�¼���ʼ��
	initEvent();
	
	//��ʼ��������ʽ
	initPageStyle();
})

/// ҩƷ����
function InitParams(){
	
	var drugType = getParam("DrugType");	
	return drugType;

}

/// ��ʼ������Ĭ����Ϣ
function initDefault(){
	//��ʼ��LookUp
	initLookUp();
	
	//��ʼ��DataGrid
	initDataGrid();
}

/// �¼���ʼ��
function initEvent(){
	//����¼���
	$('#genSearch').bind("click",QueryLibList);
    $('#genRefresh').bind("click",clearGen);
	$('#hisSearch').bind("click",QueryHisList);
    $('#hisRefresh').bind("click",clearHis);
    $('#resetCompare').bind("click",resetCompare);
    $('#openDataType').bind("click",openDataType);
    $('#condata').bind("click",condata);			//�������ݶ���  sufan2020-12-24
	$('#deleteAllContrast').bind("click",deleteAllContrast);  		//xww 2021-07-06 ɾ������ѡ�е�
	//�س��¼���
	$('#genDesc').bind("keyup",function(event){
		if(event.keyCode == "13"){
			QueryLibList();
		}
	});
	$('#hisDesc').bind("keyup",function(event){
		if(event.keyCode == "13"){
			QueryHisList();
		}
	});
	
	///�Ƿ�ƥ��
	$('.hisui-radio').radio({onCheckChange:function(){
			var matchval = $(this).attr("value");
			if (dicCode == ""){
				return;
			}	
			setTimeout("QueryHisList()",600);  //yuliping ���˶ԡ�δ�˶��л�Ԥ��ʱ��
			
	}})
	///���ƺ˶ԡ�δ�˶�ֻ��ѡ��һ��
	$("input[name='hischeck']").bind('click', function() {
			var id = $("input[name='hischeck']").not(this).attr("id")
            $('#'+id).checkbox('uncheck')
      });
           	
	///�Ƿ�ƥ�� xww 2021-08-26
	$('#genMatch').checkbox({onCheckChange:function(){
		if (dicID == ""){
			return;
		}
		QueryLibList()
	}})

}


//�����ٴ�֪ʶ������
function clearGen(){
	$('#genType').val("");
	$('#genDesc').val("");
	$('#genGrid').datagrid('loadData',{total:0,rows:[]});  // �ÿ��������datagrid
	$('#genGrid').datagrid('unselectAll');  // ����б�ѡ������ 
	$('#HospId').combobox('clear');
	dicID="";
	dicCode="";
	$HUI.checkbox("#stopFlag").uncheck();
	$HUI.checkbox("#genMatch").uncheck();
}

//����His����
function clearHis(){
	$('#hisDesc').val("");
	$('#hisGrid').datagrid('load',{total:0,rows:[]}); 
	$HUI.checkbox("#hismatch").uncheck();
	$HUI.checkbox("#hischeck").uncheck();
	$HUI.checkbox("#hischeckno").uncheck();
	//QueryHisList();
}

/// ��ʼ��LookUp
function initLookUp(){
	// ��ʼ�����Ϳ�
	var genType = $("#genType").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'CDRowID',
        textField:'CDDesc',
        columns:[[
        	{field:'CDRowID',title:'CDRowID',hidden:true},
            {field:'CDCode',title:'����',width:190},
			{field:'CDDesc',title:'����',width:190}
        ]], 
        pagination:true,
        panelWidth:420,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:false,
        //queryParams:{ClassName: 'web.DHCCKBGenItem',QueryName: 'GetTypeList'},
        queryParams:{ClassName: 'web.DHCCKBComContrast',QueryName: 'QueryDictionList',drugType:InitParams()},	// �滻Ϊ���� qunianpeng 2020/3/27
	    onSelect:function(index, rec){
		    if (rec["CDCode"] == "DiseaseData") {
			   var linkurl = "dhcckb.diagconstants.csp";
			   linkurl += ("undefined"!==typeof websys_getMWToken)?"?MWToken="+websys_getMWToken():""; 
			   window.open (linkurl, 'newwindow','width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+ ',top=0,left=0,resizable=yes,status=yes,menubar=no,scrollbars=no');
			}
			else{
				setTimeout(function(){
				    dicID = rec["CDRowID"];
			    	dicCode = rec["CDCode"];
				  	QueryLibList();
				  	QueryHisList();
				  	hisCode="";
				  	QueryContrastList();
				});
			}		   
		}
    });
    
    ///����Ժ��sufan 2020-07-15
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#HospId",{
	     url:uniturl,
	     valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
								QueryHisList();
								QueryContrastList();
						}
	   })
}

///��ʼ��DataGrid
function initDataGrid(){
	//��ʼ��֪ʶ���
	
	// ����֪ʶ���ֵ���� start qunianpeng 2020/3/29
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
		//singleSelect:true,  //xww 2021-08-13	
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
 			hisCode="";
    		QueryContrastList();
        },		
        onLoadSuccess:function(data){
           $(this).prev().find('div.datagrid-body').prop('scrollTop',0);              
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+dicID+"&parrefFlag=0&parDesc="+""+"&loginInfo="+LoginInfo+"&dataMirFlag="+stopFlag;
	new ListComponent('genGrid', columns, uniturl, option).Init();
	//end qunianpeng 2020/3/29
	
	//��ʼ��HIS��
	/**
	 * ����HIS���columns
	 */
	var hiscolumns=[[
		{field:'check',title:'sel',checkbox:true},
		{field:'HisRowID',title:'RowID',width:150,hidden:true},
	  	{field:'HisCode',title:'����',width:150},
	  	{field:'HisDesc',title:'����',width:250},
	  	{field:'ConstrastFlag',title:'���',width:100,
	  		formatter:function(value,row,index){
		  		return 	value=="1"?"����":"δ����"
		  	}
		},	  	
	  	{field:'opt',title:'����',width:50,align:'center',hidden:true,
			formatter:function(){
				var btn =  '<img class="contrast mytooltip" title="����" onclick="conMethod()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn;  
			}  
      	}
	]];
	
	/**
	 * ����HIS���datagrid
	 */
	var hisGrid = $HUI.datagrid("#hisGrid",{
        url:$URL,
        queryParams:{
	        ClassName:"web.DHCCKBComContrast", 	// qunianpeng �滻�� 2020/3/29
            QueryName:"QueryHisDataList",
            hospital:LgHospDesc,
            type:dicCode,
            queryCode:""
	    },
        columns: hiscolumns,  //����Ϣ
        pagination: true,   //pagination	boolean	����Ϊ true��������������datagrid���ײ���ʾ��ҳ��������
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        rownumbers:true,    //����Ϊ true������ʾ�����кŵ��С�
        fitColumns:true, //����Ϊ true������Զ��������С�еĳߴ�����Ӧ����Ŀ�Ȳ��ҷ�ֹˮƽ����
        onClickRow:function(index,row) {    
 			hisCode = row.HisCode;
 			libCode="";
    		QueryContrastList();
        },	
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
        }
    });
    $('#hisGrid').datagrid('loadData',{total:0,rows:[]});  // �ÿ��������datagrid
    
    //��ʼ�����չ�ϵ��
	/**
	 * ������չ�ϵ���columns
	 */
	var contrastcolumns=[[
		{field:'CCRowID',title:'id',width:100,hidden:true,sortable:true},
		{field:'check',title:'sel',checkbox:true},   //xww 2021-07-06
        {field:'CCLibCode',title:'֪ʶ�����',width:100,sortable:true},
        {field:'CCLibDesc',title:'֪ʶ������',width:100,sortable:true,formatter:function(value,rowdata){ 
        	if(rowdata.confirmConsFlag==1)
        	{
				var res =  '<span style="color:red;">'+rowdata.CCLibDesc+'</span>'
				return res;  
			}else
			{
				return rowdata.CCLibDesc;
			}}
			},
        {field:'CCHisCode',title:'His����',width:100,sortable:true},
        {field:'CCHisDesc',title:'His����',width:100,sortable:true},
        {field:'hospDesc',title:'ҽԺ',width:100,sortable:true},
        {field:'CCDicTypeDesc',title:'ʵ������',width:100,sortable:true,hidden:true},
        {field:'opt',title:'����',width:50,align:'center',hidden:true,
			formatter:function(){ 
				var btn =  '<img class="contrast" onclick="delContrast()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
				return btn;  
			}  
        }
	]];
	
	/**
	 * ������չ�ϵ���datagrid
	 */
	var congrid = $HUI.datagrid("#contrastGrid",{
		toolbar:'#resetToolbar',
        url:$URL,
        queryParams:{
	        ClassName:"web.DHCCKBComContrast",
			QueryName:"QueryContrastList",
			type:dicID,
			queryLibCode:"",
			queryHisCode:"",
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
        }
    });
     $('#contrastGrid').datagrid('loadData',{total:0,rows:[]});  // �ÿ��������datagrid
}

//���գ�1��1
function conMethod()
{
	setTimeout(function(){
		var CDType = $("#genTypeID").val();
		var record=$('#genGrid').datagrid('getSelected');
		var hisRecord=$('#hisGrid').datagrid('getSelected');

		if(!record)
		{
			$.messager.alert('������ʾ','����ѡ��һ���ٴ�֪ʶ�������ٽ��ж��գ�',"error");
			return;
		}
		var ids=record.CDCode+'^'+record.CDDesc+'^'+hisRecord.HisCode+'^'+hisRecord.HisDesc+'^'+dicID;
		var Hospt = $HUI.combobox("#HospId").getValue();
		runClassMethod("web.DHCCKBComContrast","SaveContrastData",{"listdata":ids,"loginInfo":LoginInfo,"clientIP":ClientIPAdd,"selHospId":Hospt},function(jsonString){
			//var jsonString=eval('('+jsonString+')'); 
			if (jsonString == '0') {
				$.messager.popover({msg: '���ճɹ���',type:'success',timeout: 1000});
			}
			else{
				var errorMsg ="����ʧ�ܣ�"
				/*if (jsonString.info) {
					errorMsg =errorMsg+ '<br/>' + jsonString.info;
				}*/
				$.messager.alert('������ʾ',errorMsg+"�������:"+jsonString,"error");				
			}
			QueryHisList();
			QueryContrastList();
		},'text',false);
		
	},100);
}	

function delContrast(){
	setTimeout(function(){
		var contrastrecord=$('#contrastGrid').datagrid('getSelected');
		if(contrastrecord){
			var record=$('#genGrid').datagrid('getSelected');
			$.messager.confirm('��ʾ', 'ȷ��Ҫɾ����ѡ��������?', function(r){
				if (r){
					var rowid = contrastrecord.CCRowID;
					runClassMethod("web.DHCCKBComContrast","DeleteContrastData",{"rowid":rowid},function(jsonString){
						var jsonString=eval('('+jsonString+')'); 
						if (jsonString.success == 'true') {
							$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});												
						}
						else { 
							var errorMsg ="ɾ��ʧ�ܣ�"
							if (jsonString.info) {
								errorMsg =errorMsg+ '<br/>' + jsonString.info;
							}
							$.messager.alert('������ʾ',errorMsg,"error");
						} 
						QueryHisList();
						QueryContrastList();
					},"text",false);
				}
			})
		}	
	},100)
}

/// qunianpeng 2020/3/29
/// ��ѯ֪ʶ���ֵ�����
function QueryLibList()
{
	stopFlag = $HUI.checkbox("#stopFlag").getValue(); //ѡ��ͣ�ñ�־ sunhuiyong 2020-04-09
	if(dicID==""){
		$.messager.alert('������ʾ',"��ѡ��һ������","info");
		return;
	}
	var genDesc = $('#genDesc').val();  // �ٴ�֪ʶ������
	var genMatch = $HUI.checkbox("#genMatch").getValue(); //xww δƥ���� 2021-08-26
	$('#genGrid').datagrid('load',{
		id:dicID,
		parrefFlag:0,
		parDesc:genDesc,
		loginInfo:LoginInfo,
		dataMirFlag:stopFlag,
		genMatchFlag:genMatch  //xww 2021-08-26 ��ȫ��ҩ��δƥ���־
	}); 
	$('#genGrid').datagrid('unselectAll');  // ����б�ѡ������ 	
}

/// qunianpeng 2020/3/29
/// ��ѯhis�ֵ�����
function QueryHisList()
{
	if(dicCode==""){
		$.messager.alert('������ʾ',"��ѡ��һ������","info");
		return;
	}
	
	var hisDesc = $('#hisDesc').val();  // His����
	var selHospId = $HUI.combobox("#HospId").getValue();			//ȡҽԺId  sufan 2020-07-16
	if(selHospId == ""){
			selHospId = LgHospID;
	}
	var matchtype = $HUI.checkbox("#hismatch").getValue();
	var hischeck =""
	$("input[name='hischeck']:checked").each(function(i){
		hischeck=$(this).val()
	})
	$('#hisGrid').datagrid('reload',{
		ClassName:"web.DHCCKBComContrast",
		QueryName:"QueryHisDataList",
		hospital:selHospId,	//LgHospDesc
		type:dicCode,
		queryCode:hisDesc,
		matchtype:matchtype,
		hischeck:hischeck
	}); 

	$('#hisGrid').datagrid('unselectAll');  // ����б�ѡ������ 	
}

/// qunianpeng 2020/3/29
/// ��ѯ��������
function QueryContrastList()
{
	var selHospDesc = $HUI.combobox("#HospId").getText();			//ȡҽԺ����  wangxin 2020-10-23
	$('#contrastGrid').datagrid('load',  {
		ClassName:"web.DHCCKBComContrast",
		QueryName:"QueryContrastList",		
		 type:dicID, 
		 queryLibCode:libCode,
		 queryHisCode:hisCode,
		 loginInfo:LoginInfo,
		 selHospDesc:selHospDesc, //wangxin 2020-10-12 ����desc����
		 queryLibDesc:libDesc			//sufan 2020-7-10 ����desc����
    });
    
    $('#contrastGrid').datagrid('unselectAll');  // ����б�ѡ������ 	
}
/// Sunhuiyong 2020-04-09
/// ���������ض���
function resetCompare()
{
	var rowsData = $("#contrastGrid").datagrid('getSelected'); //ѡ��Ҫ�޸ĵ���
	if (rowsData != null) {	
		comparedata = rowsData.CCRowID;
		$HUI.dialog("#resetcompare").open();
	/// ��ʼ��combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'id',
		textField:'text',		
        onSelect:function(option){
        redictext = option.text;  //ѡ��ָ���ֵ�id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+dicID+"&parrefFlag=0";
	new ListCombobox("newcomparedata",url,'',option).init(); 

	
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵĶ������ݣ�','warning');
		 return;		
}	
}
///����ָ���ֵ�-����
function SaveReCompareData()
{
	
	if(redictext==""){
		$.messager.alert("��ʾ","��ѡ���ض�ָ�����ݣ�",'info');
		return;
	}
	runClassMethod("web.DHCCKBDiction","ResetCompareData",{"CompareDataID":comparedata,"ResetData":redictext},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
	            	$("#contrastGrid").datagrid('reload');
	            	$HUI.dialog("#resetcompare").close();
	            	return false;
	           	}else{
				       $.messager.popover({msg: '�ƶ��޸�ʧ�ܣ�',type:'success',timeout: 1000});
				       $HUI.dialog("#resetcompare").close();
	            	   return false;
		       		 }
	 })
		
}

/// Sunhuiyong 2020-04-09
/// ���������ض���
function openDataType()
{
	hisID="";
	var rowsData = $("#hisGrid").datagrid('getSelected'); //ѡ��Ҫ�޸ĵ���
	if (rowsData != null) {	
		hisID = rowsData.HisRowID;
		$HUI.dialog("#DataTypeDialog").open();
	/// ��ʼ��combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        redictext = option.text;  //ѡ��ָ���ֵ�id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr=KnowType&extraAttrValue=DictionFlag";
	new ListCombobox("ExtDateType",url,'',option).init(); 

	
	}else{
		 $.messager.alert('��ʾ','��ѡ��HIS���ݣ�','warning');
		 return;		
}	
}
///����ָ���ֵ�-����
function updateDataType()
{
	
	var dataTypeID=$("#ExtDateType").combobox('getValue');
	if(dataTypeID==""){
		$.messager.alert("��ʾ","��ѡ���ֵ����ͣ�","info");
		return;
	}
	//alert(dataTypeID+" "+hisID);
	//return;
	runClassMethod("web.DHCCKBComContrast","UpdateDataType",{"DataTypeID":dataTypeID,"HisID":hisID},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
	            	$("#hisGrid").datagrid('reload');
	            	$HUI.dialog("#DataTypeDialog").close();
	            	return false;
	           	}else{
				       $.messager.popover({msg: '�ƶ��޸�ʧ�ܣ�',type:'success',timeout: 1000});
				       $HUI.dialog("#DataTypeDialog").close();
	            	   return false;
		       		 }
	 })
		
}

///������������
function condata()
{
	
/*	setTimeout(function(){
		var CDType = $("#genTypeID").val();
		var record=$('#genGrid').datagrid('getSelected');
		var hisRecord=$('#hisGrid').datagrid('getSelected');

		if(!record)
		{
			$.messager.alert('������ʾ','����ѡ��һ���ٴ�֪ʶ�������ٽ��ж��գ�',"error");
			return;
		}
		var ids=record.CDCode+'^'+record.CDDesc+'^'+hisRecord.HisCode+'^'+hisRecord.HisDesc+'^'+dicID;
		
		runClassMethod("web.DHCCKBComContrast","SaveContrastData",{"listdata":ids,"loginInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
			var jsonString=eval('('+jsonString+')'); 
			if (jsonString.success == 'true') {
				$.messager.popover({msg: '���ճɹ���',type:'success',timeout: 1000});
			}
			else{
				var errorMsg ="����ʧ�ܣ�"
				if (jsonString.info) {
					errorMsg =errorMsg+ '<br/>' + jsonString.info;
				}
				$.messager.alert('������ʾ',errorMsg,"error");				
			}
			QueryHisList();
			QueryContrastList();
		},'text',false);
		
	},100);*/
	var selItems = $("#hisGrid").datagrid('getSelections');
	if(selItems.length==0)
	{
		$.messager.alert('��ʾ',"��ѡ��Ҫ���յ���Ŀ��","info");
		return false;
	}
	
	var type = $("#genTypeID").val();							//����
	var libData = $('#genGrid').datagrid('getSelections');		//֪ʶ����Ŀ  xww 2021-08-13 ��ѡ
	if(libData.length==0)
		{
			$.messager.alert('��ʾ','��ѡ��һ����ȫ��ҩ�ֵ����ݽ��ж��գ�',"info");
			return;
		}
	if((libData.length>1)&&((dicCode=="DrugData")||(dicCode=="ChineseDrugData")||(dicCode=="ChineseHerbalMedicineData"))){
		$.messager.alert('��ʾ','��ȫ��ҩ��ֻ��ѡ��һ��ҩƷ���ݣ�',"info");
		return;
	}
	var dataList = []
	/*for(var i=0;i<selItems.length;i++)
	{
		var tmp = libData.CDCode +"^"+ libData.CDDesc +"^"+ selItems[i].HisCode +"^"+ selItems[i].HisDesc +"^"+ dicID;
		dataList.push(tmp);
	}*/
	for(var i=0;i<selItems.length;i++)
	{
		for(var j=0;j<libData.length;j++)
		{
			var tmp = libData[j].CDCode +"^"+ libData[j].CDDesc +"^"+ selItems[i].HisCode +"^"+ selItems[i].HisDesc +"^"+ dicID;
			dataList.push(tmp);
		}
	}
	var params=dataList.join("&&");
	var Hospt = $HUI.combobox("#HospId").getValue();
	runClassMethod("web.DHCCKBComContrast","saveConDataBat",{"params":params,"loginInfo":LoginInfo,"clientIP":ClientIPAdd,"selHospId":Hospt},function(jsonString){
			
			if (jsonString == '0') {
				$.messager.popover({msg: '���ճɹ���',type:'success',timeout: 1000});
			}else{
				var errorMsg ="����ʧ�ܣ�"
				$.messager.alert('������ʾ',errorMsg+"������룺"+jsonString,"error");				
			}
			QueryHisList();
			QueryContrastList();
	},'text',false);
}


//xww 2021-07-06 ����ɾ���Ѷ�����Ŀ
function deleteAllContrast(){	
	setTimeout(function(){
		$.messager.confirm('��ʾ', 'ȷ��Ҫɾ����ѡ��������?', function(r){
			var contrastselItems = $("#contrastGrid").datagrid('getSelections');
			if(contrastselItems.length==0)
			{
				$.messager.alert('��ʾ',"��ѡ���Ѷ��յ���Ŀ��","info");
				return false;
			}
			var dataList = []
			for(var i=0;i<contrastselItems.length;i++)
			{
				var tmp = contrastselItems[i].CCRowID;
				dataList.push(tmp);
			}
			var params=dataList.join("&&");
			if (params === undefined){return} ;
			if (r){
				runClassMethod("web.DHCCKBComContrast","DeleteAllContrastData",{"params":params},function(jsonString){
					var jsonString=eval('('+jsonString+')'); 
					if (jsonString.success == 'true') {
						$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});												
					}
					else { 
						var errorMsg ="ɾ��ʧ�ܣ�"
						if (jsonString.info) {
							errorMsg =errorMsg+ '<br/>' + jsonString.info;
						}
						$.messager.alert('������ʾ',errorMsg,"error");
					} 
					//QueryHisList();
					QueryContrastList();
				},"text",false);
			}
		})	
	},100)
}

function initPageStyle() {
	$('body .layout-panel-west .layout-panel-center').css("background-color", "#fff");
	if ((typeof HISUIStyleCode == "string") && (HISUIStyleCode == "lite")) {
  		$('body .layout-panel-west .layout-panel-center').css("background-color", "#F4F4F4");
	}
}
