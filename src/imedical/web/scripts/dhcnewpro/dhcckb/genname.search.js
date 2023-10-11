//===========================================================================================
// Author��      kemaolin
// Date:		 2020-01-20
// Description:	 �°��ٴ�֪ʶ��-ͨ������ѯ
//===========================================================================================

var tempDataId=serverCall("web.DHCCKBCommon","GetDicIdByCode",{'code':'GeneralData'}); //ͨ�����ֵ�Id
var tempElemId=serverCall("web.DHCCKBCommon","GetDicIdByCode",{'code':'TempElement'}); //ģ��Ԫ��Id
//var extraAttr = "KnowType";			// ֪ʶ����(��������)
//var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
//var extraAttrDic = "DictionFlag"	//�ֵ���
//var propId="" //ʵ������Id
var tempId="" //ģ��Id
var dicID=""; //ʵ��Id	
var editRow=0,editsubRow = 0;	

/// JQuery ��ʼ��ҳ��
$(function(){ 
	
	initPageDefault(); 
})

/// ҳ���ʼ������
function initPageDefault(){
	
	InitButton();			// ��ť��Ӧ�¼���ʼ��
	initTempElemGrid();
	InitSubDataList();
	initSearchbox();
}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#insert").bind("click",SubInsertRow); //ģ��������
	$("#save").bind("click",SubSaveRow); //ģ�屣��
	$("#delete").bind("click",SubDelRow); //ģ��ɾ��
	
	$("#reset").bind("click",InitPageInfo);	// ����

}

// ��ѯ
function QueryDicList()
{
	var parDesc = $HUI.searchbox("#queryCode").getValue();
	
	$('#templist').datagrid('load',{
		id:tempDataId,
		parrefFlag:0,
		parDesc:parDesc
	}); 
}

function initSearchbox(){
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
});
}


// ����
function InitPageInfo(){
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	

}



//=================================ͨ������ѯ�б�=================================================
function initTempElemGrid()
{
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[ 
		{field:'formGenDesc',title:'������ͨ����'},
		{field:'proNameDesc',title:'��Ʒ��',width:200,align:'left',editor:textEditor},
		{field:'manfDesc',title:'��������',width:400,align:'left',editor:textEditor}
	]];
	
	///  ����datagrid
	var option = {
		fitColumns:true,
		singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//˫��ѡ���б༭
	    onClickRow: function(rowIndex,rowData){
	 	}, 
	};
	 //w ##class(web.DHCCKBDicLinkAttr).QueryDicLinkAttr("10","1","4072^2860^5282")
	var GenNameID=tempId;
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryByGeneralNameID&GenNameID="+GenNameID;
	new ListComponent('tempElement', columns, uniturl, option).Init();
}


//==================================================ͨ�����ֵ��б�============================================================//
/// ҳ��DataGrid��ʼ����ͨ����
function InitSubDataList(){				
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'����',width:400,align:'left',editor:texteditor},
			{field:'Parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"��������",width:200,align:'left',hidden:true},
			{field:'Operating',title:'����',width:200,align:'center',formatter:SetCellOperation} 
			
		 ]]

	var option={	
		//bordr:false,
		//fit:true,
		fitColumns:true,
		singleSelect:true,	
		//nowrap: false,
		//striped: true, 
		//pagination:true,
		//rownumbers:true,
		//pageSize:30,
		//pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){
	 		tempId=rowData.ID;
	 		//var params=tempId +"^"+ tempElemCode
	 		var GenNameID=tempId //+"^"+ tempElemId
	 		$("#tempElement").datagrid("load",{"GenNameID":GenNameID});

	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editsubRow != ""||editsubRow == 0) { 
                $("#templist").datagrid('endEdit', editsubRow); 
            } 
            $("#templist").datagrid('beginEdit', rowIndex); 
            var editors = $('#templist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 ʧȥ����رձ༭��  
	             for (var i = 0; i < editors.length; i++)   
                {  
                   var e = editors[i]; 
              	   $(e.target).bind("blur",function()
              	   {  
                      $("#templist").datagrid('endEdit', rowIndex);
                    });   
                  
                  } 
            
            editsubRow = rowIndex; 
        },
        onLoadSuccess:function(data){
            $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({});
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+tempDataId+"&parrefFlag=0&parDesc=";
	new ListComponent('templist', columns, uniturl, option).Init();
	
}

/// sub��������
function SubInsertRow(){
	
	if(editRow>="0"){
		$("#templist").datagrid('endEdit', editRow);		//�����༭������֮ǰ�༭����
	}
	$("#templist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#templist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editRow=0;
}

/// sub����
function SubSaveRow(){
	
	if(editRow>="0"){
		$("#templist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#templist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc) +"^"+ tempDataId;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			return;	
		}else{
			$.messager.alert('��ʾ','����ɹ���','info');
			var params=tempId +"^"+ tempElemId
	 		$("#templist").datagrid("load",{"params":params});
			return;
		}	
	});
}

/// subɾ��
function SubDelRow(){

	var rowsData = $("#templist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){					
					if (jsonString==0){
						var params=tempId +"^"+ tempElemId
	 					$("#templist").datagrid("load",{"params":params});
					}else if (jsonString == "-1"){
						 $.messager.alert('��ʾ','�������ѱ�����,����ֱ��ɾ����','warning');
					}
					else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
					}
					
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
/*
/// sub ��ѯ
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	
	$('#templist').datagrid('load',{
		id:tempDataId,
		parrefFlag:0,
		parDesc:params
	}); 
}

// ����
function InitSubPageInfo(){

	$HUI.searchbox('#subQueryCode').setValue("");
	SubQueryDicList();	

}
*/

//===========================================�������Ե���========================================================

///���ò�����ϸ����
function SetCellOperation(value, rowData, rowIndex){
	var btn = "<img class='mytooltip' title='��������' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  
	
}

/// ����ֵ�༭��
function OpenEditWin(ID,model,dataType){

	var linkUrl="",title=""
	if (model == "list"){
		
		linkUrl = "dhcckb.addlist.csp"
		title = "�ֵ�ά��"
		
	}else if (model =="prop"){
		
		linkUrl = "dhcckb.addattr.csp";
		title = "�����б�";
		
	}else if (model == "linkprop"){
		
		linkUrl = "dhcckb.addlinkattr.csp";
		title ="��������ά��";
		
	}else {
		linkUrl = "dhcckb.addlist.csp"
		title = "�ֵ�ά��"
	}	

	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?parref='+ID+'"></iframe>';

	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		maximizable:true,
		minimizable:false,		
		width:$(window).width()-50, //800,
		height:$(window).height()-50,//500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}