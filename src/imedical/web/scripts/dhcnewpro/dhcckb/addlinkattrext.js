/**
  *sufan 
  *2019-06-18
  *��������ά��
  *
 **/
 
var editRow = 0; 
var CatId = getParam("parref");     //ʵ��ID
var RangeId=CatId;
var extraAttr = "KnowType";			// ��������-֪ʶ����
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
/// ҳ���ʼ������
function initPageDefault(){

	initDataGrid();      /// ҳ��DataGrid��ʼ����
}

/// ҳ��DataGrid��ʼ����
function initDataGrid(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	var Attreditor={  
		type: 'combobox',	//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#addattrextlist").datagrid('getEditor',{index:editRow,field:'AttrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#addattrextlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDr'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				
				var ed=$("#addattrextlist").datagrid('getEditor',{index:editRow,field:'DLAAttrCode'});
				var AddAttrID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#addattrextlist").datagrid('getEditor',{index:editRow,field:'AttrDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAttrValue&AddAttrID="+ AddAttrID;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}

	///  ����columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult"
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'ʵ��ID',width:100,hidden:true},
		{field:'DLAAttrCode',title:'����id',width:150,hidden:true},
		{field:'DLAAttrCodeDesc',title:'��������',width:200},	
		{field:'DLAAttrDr',title:'����ֵid',width:80,editor:textEditor,hidden:true},	
		/* {field:'DLAAttrDesc',title:'����ֵ����',width:200,editor:Attreditor},	 */	
		{field:'DLAAttrDesc',title:'����ֵ����',width:300,editor:textEditor},
		{field:'DLAResult',title:'��ע',width:200,editor:textEditor,hidden:true},
		{field:'DLAAttr',title:'DLAAttr',width:200,hidden:false}
		
	]];
	
	///  ����datagrid
	var option = {
		singleSelect : true,
	    onClickRow: function (rowIndex, rowData) {		//������ѡ���б༭
           //CommonRowClick(rowIndex,rowData,"#addattrlist");
           //editRow=rowIndex;
           //dataGridBindEnterEvent(rowIndex);
        },
        onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
        
           //����Դ
           var DataSource = serverCall("web.DHCCKBDicExtLinkAttr","GetAddAttrSource",{"queryDicID":rowData.DLAAttrCode,"AttrLinkCode":"DataSource","AttrId":CatId});		//����Դ
           //��������
           var DataType = serverCall("web.DHCCKBDicExtLinkAttr","GetAddAttrCode",{"queryDicID":rowData.DLAAttrCode,"AttrLinkCode":rowData.DLAAttr,"AttrId":CatId});		//ȡ��������
           var e = $("#addattrextlist").datagrid('getColumnOption', 'DLAAttrDesc');
           var multiplevalue=false;
           if(rowData.DLAAttr =="DataSource"){multiplevalue=true;}
           
           if((DataType == "combobox")){
	            e.editor = {type:'combobox',
						  options:{
							valueField:'value',
							textField:'text',
							multiple:multiplevalue,
							onSelect:function(option) {
								
							
							}, 
						  	onShowPanel:function(){
								var ed=$("#addattrextlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
								
								var unitUrl = $URL+'?ClassName=web.DHCCKBRangeCat&MethodName=GetDataCombo&DataSource='+DataSource+'&dicCode='+rowData.DLAAttr
							
								$(ed.target).combobox('reload',unitUrl);
						    }	  
						}
				 }
				if (editRow != ""||editRow === 0) { 
            		$("#addattrextlist").datagrid('endEdit', editRow); 
        		} 
           		$("#addattrextlist").datagrid('beginEdit', rowIndex); 
	       }else if(rowData.DLAAttr=="OrderNum"){ 
	       		 e.editor = {type:'text'}
		         if (editRow != ""||editRow === 0) { 
                	 $("#addattrextlist").datagrid('endEdit', editRow); 
            	 } 
            	 $("#addattrextlist").datagrid('beginEdit', rowIndex); 
		        
		   }else if(DataType=="textarea"){ 
	       		 e.editor = {type:'text'}
		         if (editRow != ""||editRow === 0) { 
                	 $("#addattrextlist").datagrid('endEdit', editRow); 
            	 } 
            	 $("#addattrextlist").datagrid('beginEdit', rowIndex); 
		        
		   }
		   editRow=rowIndex;
        }
	};
	
	var params=CatId +"^"+ extraAttr +"^"+"ExtraProp";
	var uniturl = $URL+"?ClassName=web.DHCCKBDicExtLinkAttr&MethodName=QueryAddLinkAttr&params="+params;
	new ListComponent('addattrextlist', columns, uniturl, option).Init();
}

/// ɾ��
function DelLinkAttr(){

	//removeCom("User.DHCCKBDicLinkAttr","#addattrlist")
	var rowsData = $("#addattrextlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDicExtLinkAttr","CancelAddAttr",{"EntyId":CatId,"AddAttrList":rowsData.DLAAttrCode},function(jsonString){
					if(jsonString!=0){
						$.messager.alert('��ʾ',"ErrMsg:"+jsonString)
					}else{
						
					}
					$('#addattrextlist').datagrid('reload'); 
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}


///���渽�����Կɱ༭���� 2019-11-27
function SaveLinkAttr(Param,flag)
{
	if(editRow>="0"){
		$("#addattrextlist").datagrid('endEdit', editRow);
	}
	var dataList = [];
	if(Param=="0"){
		
		var rowsData = $("#addattrextlist").datagrid('getChanges');
		if(rowsData.length<=0){
			$.messager.alert("��ʾ","û�д���������!");
			return;
		}
		for(var i=0;i<rowsData.length;i++){
		
			if(rowsData[i].DLAAttrDesc==""){
				$.messager.alert("��ʾ","�ɱ༭���ݲ���Ϊ�գ�"); 
				return false;
			}
			var IdList=serverCall("web.DHCCKBRangeCat","GetAttrIdList",{"ItmList":rowsData[i].DLAAttrDesc,'AddAttr':$g(rowsData[i].DLAAttrCode)});		
			var dataId=IdList.split("^")[0];
			var datatext=IdList.split("^")[1];
			var IdArray=dataId.split(",")
			
			if(dataId==""){
				var tmp=RangeId +"^"+ $g(rowsData[i].DLAAttrCode) +"^"+ dataId +"^"+ datatext+"^"+ $g(rowsData[i].DLAAttr);
				dataList.push(tmp);
			}else{
				if(IdArray.length>1){
					for(var j=0;j<IdArray.length;j++){
						var tmp=RangeId +"^"+ $g(rowsData[i].DLAAttrCode) +"^"+ $g(IdArray[j]) +"^"+ $g(IdArray[j]) +"^"+ $g(rowsData[i].DLAAttr);
						dataList.push(tmp);
					}
				}else{
					var tmp=RangeId +"^"+ $g(rowsData[i].DLAAttrCode) +"^"+ $g(dataId) +"^"+ $g(rowsData[i].DLAAttrDesc) +"^"+ $g(rowsData[i].DLAAttr);
					dataList.push(tmp);
				}
			}	
		} 
	}else{
		var rowsData=$("#addattrextlist").datagrid('getRows')[editRow];
		var ParamArray = Param.split("$");
		for(var i=0;i<ParamArray.length;i++)
		{
			var tmp=RangeId +"^"+ $g(rowsData.DLAAttrCode) +"^"+ $g(ParamArray[i]) +"^"+ "" +"^"+ $g(rowsData.DLAAttr);
			dataList.push(tmp);
		}
	}
	
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCCKBDicExtLinkAttr","SaveUpdate",{"params":params,"flag":flag},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�ErrCode:'+jsonString,'warning');
			$('#addattrextlist').datagrid('reload'); 
			return;	
		}else{
			$.messager.alert('��ʾ','����ɹ���','info');
			$('#addattrextlist').datagrid('reload'); 
			return;
		}
	});
}

function ReloadData(){
	var params = CatId +"^"+ extraAttr +"^"+"ExtraProp";
	$("#addattrextlist").datagrid("load",{"params":params});
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
