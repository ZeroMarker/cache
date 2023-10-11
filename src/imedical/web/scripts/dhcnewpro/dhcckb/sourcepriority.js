//===========================================================================================
// Author：      lidong
// Date:		 2022-11-15
// Description:	 知识来源管理
//===========================================================================================
var editaddRow="";
var CatId = getParam("catalogueid");
var nodeArr=[];	
function initPageDefault(){
	InitButton();			// 按钮响应事件初始化
	InitDataList();			// 实体DataGrid初始化定义
	
}

/// 按钮响应事件初始化
function InitButton(){

	/* $("#insert").bind("click",insertRow);	// 增加新行 */
	
	$("#save").bind("click",saveRow);		// 保存
	
	/* $("#delete").bind("click",DeleteRow);	// 删除 */
	$("#find").bind("click",QueryKnowList);	// 查询
	
	$("#reset").bind("click",InitPageInfo);	// 重置
	
	/// 代码.描述查询
	$('#queryName').searchbox({
	    searcher:function(value,name){
	   		QueryKnowList();
	    }	   
	});	
	
}
/// 实体DataGrid初始定义通用名
function InitDataList(){
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	/* // 知识来源
	var KnowSourceeditor={
					type:'combobox',
				  	 options:{
					  	valueField:'value',
						textField:'text',
						mode:'remote',
						enterNullValueClear:false,
						blurValidValue:true,
						onSelect:function(option){
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'KnowSource'});
							$(ed.target).combobox('setValue', option.text);
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'KnowSourceId'});
							$(ed.target).val(option.value);
						},
				  		onShowPanel:function(){
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'KnowSource'});
							var unitUrl=$URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=GetKnowSourceComboxData&q="+'';
							$(ed.target).combobox('reload',unitUrl);	
				    			}	  
							
				  	 	}
				  	 
				 } */
	// 是否启用
	/* var IsEnableeditor={
					type:'switchbox',
				  	 options:{
					  	onText:'开',
        				offText:'关',
        				onClass:'primary',
        				offClass:'gray',
        				animated:'true',
        				size:'small',
        				onSwitchChange:function(e,obj){
            				console.log(e);
            				console.log(obj);
        					}	  
							
				  	 	}
		 } */
		 
	// 逻辑关系
	var Relationeditor={type:'combobox',
				  	 options:{
					  	valueField:'value',
						textField:'text',
						mode:'remote',
						enterNullValueClear:false,
						blurValidValue:true,
						onSelect:function(option){
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'Relation'});
							$(ed.target).combobox('setValue', option.text);
						},
				  		onShowPanel:function(){
							var data=[{"value":"and","text":"and"},{"value":"or","text":"or"}];
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'Relation'});
							$(ed.target).combobox('loadData',data);	
				    			}	  
							
				  	 	}
		 }
	// 定义columns
	var columns=[[   	 
			{field:'RowID',title:'RowID',hidden:true},
			{field:'KnowSourceId',title:'知识来源ID',align:'center',hidden:true},
			{field:'KnowSource',title:'知识来源',width:100,align:'left',hidden:false},
			{field:'IsEnableId',title:'是否启用ID',align:'center',editor:textEditor,hidden:true},
			{field:'IsEnable',title:'是否启用',width:100,align:'center',
			formatter:function(value,row,index){
				 if (value === 'Y') {//生效
                            return "<div id='" + row.KnowSourceId + "' class='hisui-switchbox switchBtn1' RowID='" + row.RowID + "' Relation='" + row.Relation + "' Num='" + row.Num + "' ></div>"
                        } else if (value === 'N') {//不生效
                            return "<div id='" + row.KnowSourceId + "' class='hisui-switchbox switchBtn2' RowID='" + row.RowID + "' Relation='" + row.Relation + "' Num='" + row.Num + "' ></div>"
                        }
				}
			,hidden:false},
			{field:'Relation',title:'逻辑关系',width:100,align:'center',editor:Relationeditor,hidden:false},
			{field:'Num',title:'顺序级序号',width:100,align:'center',editor:textEditor,hidden:false},
			{field:'pri',title:'优先级',width:100,align:'center',
			formatter:function(value,rec,index){
			var a = '<a href="#" mce_href="#" onclick="upclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/up.png"/>'+'</a> ';
			var b = '<a href="#" mce_href="#" onclick="downclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/down.png"/>'+'</a> ';
			return a+b;  
        		}  
			,hidden:false},
						
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onLoadSuccess: function (data) {
			 $(".switchBtn1").switchbox({
				 	onText:'是',
        			offText:'否',
        			onClass:'primary',
        			offClass:'gray',
        			animated:'true',
        			size:'small',
        			checked:true,
        			onSwitchChange:function(e,obj){
	        			/* var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'IsEnableId'}); 
            			$(ed.target).val(obj.value); */
						console.log(e);
            			console.log(obj);
            			if((CatId=="")||(CatId==undefined)){
	            		var CheckVal=obj.value;
	            		var RowId= $(this).attr("RowID");
            			var CataLogId="";
            			var KnowSourceId=$(this).attr("id");
            			var Relation=$(this).attr("Relation");
            			if (CheckVal==false){
	            			var Active="N";
	            		};
	            		if(CheckVal==true){
		            		var Active="Y";
		            	};
		            	var Num=$(this).attr("Num");
		            	var Type="Global";
		            	var TypeDr="";
		            	var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+Active+"^"+Num+"^"+Type+"^"+TypeDr;
	            		SaveNew(tmp);
	            		}else{
		            	var CheckVal=obj.value;
		            	var RowId= $(this).attr("RowID");
            			var CataLogId=CatId;
            			var KnowSourceId=$(this).attr("id");
            			var Relation=$(this).attr("Relation");
            			if (CheckVal==false){
	            			var Active="N";
	            		};
	            		if(CheckVal==true){
		            		var Active="Y";
		            	};
		            	var Num=$(this).attr("Num");
		            	var Type="Lib";
		            	var TypeDr="";
		            	var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+Active+"^"+Num+"^"+Type+"^"+TypeDr;	
		            	SaveNew(tmp);
		            		}
            			
            			}
				 }),
			$(".switchBtn2").switchbox({
				 	onText:'是',
        			offText:'否',
        			onClass:'primary',
        			offClass:'gray',
        			animated:'true',
        			size:'small',
        			checked:false,
        			onSwitchChange:function(e,obj){
            			/* var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'IsEnableId'}); 
            			$(ed.target).val(obj.value); */
						console.log(e);
            			console.log(obj);
            			
            			if((CatId=="")||(CatId==undefined)){
	            		var CheckVal=obj.value;
	            		var RowId= $(this).attr("RowID");
            			var CataLogId="";
            			var KnowSourceId=$(this).attr("id");
            			var Relation=$(this).attr("Relation");
            			if (CheckVal==false){
	            			var Active="N";
	            		};
	            		if(CheckVal==true){
		            		var Active="Y";
		            	};
		            	var Num=$(this).attr("Num");
		            	var Type="Global";
		            	var TypeDr="";
		            	var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+Active+"^"+Num+"^"+Type+"^"+TypeDr;
	            		SaveNew(tmp);
	            		}else{
		            	var CheckVal=obj.value;
		            	var RowId= $(this).attr("RowID");
            			var CataLogId=CatId;
            			var KnowSourceId=$(this).attr("id");
            			var Relation=$(this).attr("Relation");
            			if (CheckVal==false){
	            			var Active="N";
	            		};
	            		if(CheckVal==true){
		            		var Active="Y";
		            	};
		            	var Num=$(this).attr("Num");
		            	var Type="Lib";
		            	var TypeDr="";
		            	var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+Active+"^"+Num+"^"+Type+"^"+TypeDr;	
		            	SaveNew(tmp);
		            		}
            			
            			}
				 })
			},		
 		onClickRow:function(rowIndex,rowData){
	 		editaddRow=rowIndex; 	
 		 }, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			editaddRow=rowIndex;
			if (editaddRow != ""||editaddRow == 0) { 
                $("#KnowList").datagrid('endEdit', editaddRow); 
            } 
            $("#KnowList").datagrid('beginEdit', rowIndex); 
             var editors = $('#KnowList').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 失去焦点关闭编辑行                
            /*for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i];
                 
              	$(e.target).bind("blur",function()
              	  {  
                    $("#KnowList").datagrid('endEdit', rowIndex);
                  });   
                  
            }  */
             
        }
		  
	}
	/* var uniturl = $URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=GetKnowListByKnow&KnowSource=&CatalogueID="+CatId; */
	 if((CatId=="")||CatId==undefined){
	var uniturl = $URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=GetKnowListByKnow&KnowSource=&CatalogueID="+CatId;
	}
	if(CatId!=""){
		var uniturl = $URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=GetKnowListByKnownew&KnowSource=&CatalogueID="+CatId;
		} 
	new ListComponent('KnowList', columns, uniturl, option).Init();
	
}
/// 实体datagrid查询
function QueryKnowList()
{
	var params = $HUI.searchbox("#queryName").getValue();
	$('#KnowList').datagrid('load',{
		CatalogueID:CatId,
		KnowSource:params
	})
	
}

/// 实体datagrid重置
function InitPageInfo(){	

	$HUI.searchbox('#queryName').setValue("");
	QueryKnowList();	

}


/// 保存编辑行
function saveRow(){
	var CatId = getParam("catalogueid");
	if(editaddRow>="0"){
		$("#KnowList").datagrid('endEdit', editaddRow);
	}
	var rowsData = $("#KnowList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	} 
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((CatId=="")||(CatId==undefined)){
		var RowId=$g(rowsData[i].RowID);
		var CataLogId="";
		var KnowSourceId=$g(rowsData[i].KnowSourceId);
		var Relation=$g(rowsData[i].Relation);
		var IsEnableId=$g(rowsData[i].IsEnableId);
		if(IsEnableId=="false"){
			var IsEnable="N"
		}else{
			var IsEnable="Y"
			};
		var Num=$g(rowsData[i].Num);
		var Type="Global"
		var TypeDr=""
		var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+IsEnable+"^"+Num+"^"+Type+"^"+TypeDr;
		dataList.push(tmp);
		}else{
		var RowId=$g(rowsData[i].RowID);
		var CataLogId=CatId;
		var KnowSourceId=$g(rowsData[i].KnowSourceId);
		var Relation=$g(rowsData[i].Relation);
		var IsEnableId=$g(rowsData[i].IsEnableId);
		if(IsEnableId=="false"){
			var IsEnable="N"
		}else{
			var IsEnable="Y"
			};
		var Num=$g(rowsData[i].Num);
		var Type="Lib"
		var TypeDr=""
		var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+IsEnable+"^"+Num+"^"+Type+"^"+TypeDr;
		dataList.push(tmp);
			}
	} 
	var params=dataList.join("&&");
	
	//保存数据
	runClassMethod("web.DHCCKBSourcePriority","SaveUpdate",{"params":params},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else if(jsonString == -100){
			$.messager.alert('提示','保存失败,已存在该条数据！','warning');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		InitPageInfo();		
		
	});
}
function SaveNew(tmp){
	runClassMethod("web.DHCCKBSourcePriority","SaveUpdate",{"params":tmp},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		InitPageInfo();		
	});
}

//上移 lidong
function upclick(index)
{
	var newrow=parseInt(index)-1     
	var curr=$("#KnowList").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.Num;
	var up =$("#KnowList").datagrid('getData').rows[newrow];
	var uprowid=up.RowID;
	var upordnum=up.Num;

	var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'up', 'KnowList');
	
}
//下移  lidong
function downclick(index)
{
	
	
	var newrow=parseInt(index)+1 ;
	var curr=$("#KnowList").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.Num;
	var down =$("#KnowList").datagrid('getData').rows[newrow];
	var downrowid=down.RowID;
	var downordnum=down.Num;

	var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'down', 'KnowList');
}
// lidong
function SaveUp(input,datas)
{
	runClassMethod("web.DHCCKBSourcePriority","UpdExpFieldNum",{"input":input},
	function(ret){
		$('#KnowList').datagrid('reload'); //重新加载 
	},'text');
	 
}
// lidong
function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
