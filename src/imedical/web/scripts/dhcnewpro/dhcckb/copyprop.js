//===========================================================================================
// Author��      qunianpeng
// Date:		 2020-04-16
// Description:	 ��������
//===========================================================================================


var dicStr=""	// �ֵ�id
var parref = "" // ʵ��id
/// JQuery ��ʼ��ҳ��
$(function(){ 
	
	initPageDefault(); 
})

/// ҳ���ʼ������
function initPageDefault(){
	
	InitParams();			// ��ʼ������
	InitButton();			// ��ť��Ӧ�¼���ʼ��
	InitAttrGrid();			// ��ʼ�������б�
	IniTtempAttrGrid();		// �ѹ���������
}

/// ��ʼ������
function InitParams(){
	
	dicStr = getParam("dicStr");
	parref = getParam("parref");

}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#addProp").bind("click",AddProp); 			//	�������
	$("#removeProp").bind("click",RemoveProp); 		//	�Ƴ����� 	
	
	//������
	$('#queryEnt').searchbox({
	    searcher:function(value,name){
	   		queryEnt();
	    }	   
	});	
	
	$('#queryDic').searchbox({
	    searcher:function(value,name){
	   		queryDic();
	    }	   
	});
		
}

/// ʵ�������б�
function InitAttrGrid()
{
	///  ����columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{field:"ck",checkbox:"true"},
		{field:'ID',title:'ID',width:50,hidden:true},
		{field:'code',title:'����',width:50,hidden:true},
		{field:'desc',title:'����',width:650}
	]];
	
	///  ����datagrid
	var option = {
		fitColumns:true,		
		nowrap: false,
		striped: true, 
		pagination:false,
		rownumbers:false,
		selectOnCheck:true	    
	};
	
	var params=parref +"^"+ "LinkProp"
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryDicAttr&params="+params;
	new ListComponent('attrlist', columns, uniturl, option).Init();
}


/// ʵ�������б�
function IniTtempAttrGrid()
{
	///  ����columns
	var columns=[[
		{field:'propID',title:'ID',width:50,hidden:true},
		{field:'propCode',title:'����',width:50,hidden:true},
		{field:'propDesc',title:'����',width:650}
	]];
	
	///  ����datagrid
	var option = {
		fitColumns:true,		
		nowrap: false,
		striped: true, 
		pagination:false,
		rownumbers:false,
		selectOnCheck:true	    
	};
	
	var params=dicStr;
	var uniturl = $URL+"?ClassName=web.DHCCKBDrugDetail&MethodName=QueryDicLinkProp&dicID="+params;
	new ListComponent('tempElement', columns, uniturl, option).Init();
}

// ��������
function AddProp(){
	
	var node = $("#attrlist").datagrid('getChecked');
    if (node.length==0){
        $.messager.alert("��ʾ","��ѡ������һ�����ԣ�")
        return;
    }
  	var listArr=[]
	
	$.each(node,function(index,item){
		listArr.push(item.ID)
	})
	var listData=listArr.join("^")

	//��������
	runClassMethod("web.DHCCKBDrugDetail","SaveDicLinkProp",{"dicStr":dicStr,"propList":listData},function(jsonString){
		if (jsonString == 0){
			 $.messager.alert("��ʾ","����ʧ�ܣ�","error")
		}
		QueryDicLinkProp();
	},"text",false);
}



/// �����Ƴ�
function RemoveProp(){

	var delPropList=$("#tempElement").datagrid('getSelections');

	if (delPropList.length==0){
		
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
	
	var propArr=[]
	$.each(delPropList,function(index,item){
		propArr.push(item.propID)
	})
	var propList = propArr.join("^");
	
	runClassMethod("web.DHCCKBDrugDetail","DelDicLinkProp",{"dicID":dicStr,"propList":propList},function(jsonString){					
		if (jsonString==1){
			QueryDicLinkProp();
		}
		else{
			 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
		}
		
	},"text",false);
	
	
}

/// ��ѯ�Ѿ��������������
function QueryDicLinkProp(){

	var params=dicStr;
	$('#tempElement').datagrid('load',{'dicID':params}); //���¼���
}


/// ��������ֵ
function CopyPropValue(){	
	
	var ret="";
	//��������
	console.log(dicStr)
	console.log(LoginInfo)
	console.log(ClientIPAdd)
	runClassMethod("web.DHCCKBDrugDetail","CopyPropValue",{"dicStr":dicStr,"userInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
		
		ret = jsonString;
	},"text",false);

	return ret;

}
