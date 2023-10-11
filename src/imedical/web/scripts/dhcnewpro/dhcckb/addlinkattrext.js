/**
  *sufan 
  *2019-06-18
  *附加属性维护
  *
 **/
 
var editRow = 0; 
var CatId = getParam("parref");     //实体ID
var RangeId=CatId;
var extraAttr = "KnowType";			// 附加属性-知识类型
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
/// 页面初始化函数
function initPageDefault(){

	initDataGrid();      /// 页面DataGrid初始定义
}

/// 页面DataGrid初始定义
function initDataGrid(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	var Attreditor={  
		type: 'combobox',	//设置编辑格式
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
				///设置级联指针
				var ed=$("#addattrextlist").datagrid('getEditor',{index:editRow,field:'AttrDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAttrValue&AddAttrID="+ AddAttrID;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}

	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult"
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'实体ID',width:100,hidden:true},
		{field:'DLAAttrCode',title:'属性id',width:150,hidden:true},
		{field:'DLAAttrCodeDesc',title:'附加属性',width:200},	
		{field:'DLAAttrDr',title:'属性值id',width:80,editor:textEditor,hidden:true},	
		/* {field:'DLAAttrDesc',title:'属性值描述',width:200,editor:Attreditor},	 */	
		{field:'DLAAttrDesc',title:'属性值描述',width:300,editor:textEditor},
		{field:'DLAResult',title:'备注',width:200,editor:textEditor,hidden:true},
		{field:'DLAAttr',title:'DLAAttr',width:200,hidden:false}
		
	]];
	
	///  定义datagrid
	var option = {
		singleSelect : true,
	    onClickRow: function (rowIndex, rowData) {		//单机击选择行编辑
           //CommonRowClick(rowIndex,rowData,"#addattrlist");
           //editRow=rowIndex;
           //dataGridBindEnterEvent(rowIndex);
        },
        onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
        
           //数据源
           var DataSource = serverCall("web.DHCCKBDicExtLinkAttr","GetAddAttrSource",{"queryDicID":rowData.DLAAttrCode,"AttrLinkCode":"DataSource","AttrId":CatId});		//数据源
           //数据类型
           var DataType = serverCall("web.DHCCKBDicExtLinkAttr","GetAddAttrCode",{"queryDicID":rowData.DLAAttrCode,"AttrLinkCode":rowData.DLAAttr,"AttrId":CatId});		//取数据类型
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

/// 删除
function DelLinkAttr(){

	//removeCom("User.DHCCKBDicLinkAttr","#addattrlist")
	var rowsData = $("#addattrextlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDicExtLinkAttr","CancelAddAttr",{"EntyId":CatId,"AddAttrList":rowsData.DLAAttrCode},function(jsonString){
					if(jsonString!=0){
						$.messager.alert('提示',"ErrMsg:"+jsonString)
					}else{
						
					}
					$('#addattrextlist').datagrid('reload'); 
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}


///保存附加属性可编辑的行 2019-11-27
function SaveLinkAttr(Param,flag)
{
	if(editRow>="0"){
		$("#addattrextlist").datagrid('endEdit', editRow);
	}
	var dataList = [];
	if(Param=="0"){
		
		var rowsData = $("#addattrextlist").datagrid('getChanges');
		if(rowsData.length<=0){
			$.messager.alert("提示","没有待保存数据!");
			return;
		}
		for(var i=0;i<rowsData.length;i++){
		
			if(rowsData[i].DLAAttrDesc==""){
				$.messager.alert("提示","可编辑数据不能为空！"); 
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
	//保存数据
	runClassMethod("web.DHCCKBDicExtLinkAttr","SaveUpdate",{"params":params,"flag":flag},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！ErrCode:'+jsonString,'warning');
			$('#addattrextlist').datagrid('reload'); 
			return;	
		}else{
			$.messager.alert('提示','保存成功！','info');
			$('#addattrextlist').datagrid('reload'); 
			return;
		}
	});
}

function ReloadData(){
	var params = CatId +"^"+ extraAttr +"^"+"ExtraProp";
	$("#addattrextlist").datagrid("load",{"params":params});
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
