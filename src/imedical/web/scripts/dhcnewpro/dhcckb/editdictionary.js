//===========================================================================================
// Author：      qunianpeng
// Date:		 2019-06-28
// Description:	 新版临床知识库-字典维护属性
//===========================================================================================

var editRow = 0;
var subEditRow = 0; 
var valeditRow = 0;
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
var parref = "";					// 具体药品id
var dicParref = "";					// 药品实体id
var EntLinkId="";					// 属性Id
var DataType=""
/// 页面初始化函数
function initPageDefault(){
	
	InitButton();			// 按钮响应事件初始化
	InitCombobox();			// 初始化combobox
	InitDataList();			// 实体DataGrid初始化定义
	InitSubDataList();  	// 属性DataGrid初始化定义
	InitAttrValueList();	// 弹窗属性列表DataGrid初始化定义
	//InitAddgridDataList();	// 弹窗datagrid初始化定义
	InitTextGridList();		// text类型的历史数据表格加载
	InitTree();
	
	$('#showlist').panel('resize', {
        height:$(window).height()-105
    }); 
     if (DataType=="tree"){
		$("#dictree").resizable({
	   		maxHeight : $(window).height()-105
		});
    }else{
		$("#diclist").datagrid('resize', { 
            height : $(window).height()-105
   		});
	}	

}

/// 按钮响应事件初始化
function InitButton(){

	$("#insert").bind("click",InsertRow);	// 增加新行
	
	$("#save").bind("click",SaveRow);		// 保存
	
	$("#delete").bind("click",DeleteRow);	// 删除
	
	//$("#find").bind("click",QueryDicList);	// 查询
	
	$("#reset").bind("click",InitPageInfo);	// 重置	
	
	$("#treereset").bind("click",InitTreeData);	// 重置		
	
	$("#add_btn").bind("click",AddBtn);		// 弹窗中新增
	
	$("#del_btn").bind("click",DelBtn);		// 弹窗中删除
	
	$('#queryCode').searchbox({
		
	    searcher:function(value,name){
		    if (DataType == "tree"){
				$("#dictree").tree("search", value)
			}else{
				QueryDicList();
			}
	    }	   
	});		
	
	$('#treequery').searchbox({
		
	    searcher:function(value,name){
		    if (DataType == "tree"){
				$("#dictree").tree("search", value)
			}
	    }	   
	});	
	
	///树的查找
	$('#myChecktreeDesc').searchbox({
	    searcher:function(value,name){
		    //var desc=$HUI.searchbox("#myChecktreeDesc").getValue();		   
			//$("#mygrid").treegrid("search", desc)	
	   		QueryTreeList();
	    }	   
	});	
	
	///修改归属字典
	$("#updDic").bind("click",UpdAttrDiction);
	$("#updTreeDic").bind("click",UpdAttrDiction);
	
}
function InitComboboxAll(){
		$("#dictree").tree("search", "")
		$('#linkattrlist').datagrid('loadData',[]);	    
	}
/// 初始化combobox
function InitCombobox(){
	
	/// 初始化分类检索框
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       dicParref = option.value;
	       runClassMethod("web.DHCCKBEditDiction","GetDicDataType",{'dicID':dicParref},function(ret){
				DataType=ret;
				},'text',false);
		   if(DataType=="tree")
		   	   {
			   $("#treediv").show();
			   $("#griddiv").hide();
			   $("#toolbartree").show();
			   // 药学分类，停用+排序 //kml 2020-03-09		
			   //var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+dicParref;
			   var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+dicParref+"&hospID="+LgHospID+"&groupID="+LgGroupID+"&locID="+LgCtLocID+"&userID="+LgUserID
			   $('#dictree').tree({url:uniturl}); 
			   //$('#dicTypetree').combobobox('select','106');
			   $("#diclist").datagrid("reload")
			   }
			   else
			   {
			   $("#treediv").hide();
			   $("#toolbartree").hide();	
			   $("#griddiv").show();
	       	   $("#diclist").datagrid("load",{"id":dicParref});
	       	   $("#dictree").tree("reload")
			   }

	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	new ListCombobox("dicType",url,'',option).init(); 
	new ListCombobox("treeType",url,'',option).init();
	
	//字典 sufan 20200212 增加
	$('#dicDesc').combobox({
		url:url,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		editable:false
	})
	
	
}

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

/// 实体DataGrid初始定义通用名
function InitDataList(){
	
	// 定义columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'描述',width:300,align:'left',editor:texteditor},
			{field:'CDParref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDParrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"数据类型",width:200,align:'left',hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true}
			/* {field:'Operating',title:'操作',width:380,align:'left',formatter:SetCellOperation} */			
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
 		onClickRow:function(rowIndex,rowData){ 	   
 			parref=rowData.ID;  
		   	SubQueryDicList();		 
		}, 
		onDblClickRow: function (rowIndex, rowData) { }
		  
	}
	var params = ""
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+parref+"&parrefFlag=0&parDesc="+params;
	
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

/// 属性DataGrid初始定义通用名
function InitSubDataList(){
	
	// 定义columns	
	var columns=[[   
			{field:'attrID',title:'属性id',width:60,align:'left',hidden:true},
			{field:'attrCode',title:'属性代码',width:180,align:'left'},
			{field:'attrDesc',title:'属性',width:180,align:'left'},
			{field:'dataType',title:'数据类型',width:80,align:'left',hidden:true},
			{field:'AttrValue',title:'属性值',width:310,align:'left',hidden:false},
			{field:'Operating',title:'操作',width:50,align:'center',formatter:SetCellOperation,hidden:true}
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
 		onClickRow:function(rowIndex,rowData){   
 			EntLinkId=rowData.attrID;
		}, 	
		onDblClickRow:function(rowIndex,rowData)
		{  
 			setcelLink(rowIndex,rowData)
 			var editors = $('#linkattrlist').datagrid('getEditors', rowIndex);                   
            for (var i = 0; i < editors.length; i++)
            {  
                  /* if((e.field == "AttrValue")&&(e.type=="textarea"||e.type=="text")) {  
                   	$(e.target).bind("blur",function(){  
                        if($.trim($(this).val())!="") {
	          				$("#linkattrlist").datagrid('endEdit', rowIndex); 
	                        var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ $(this).val() +"^"+ "" +"^"+ "";
	                        saveTypeData(ListData,e.type)
	                    }
                    });  
                   }*/  
                  var e = editors[i];      // wxj ie上 textarea 保存不好使 2021-05-21
                  if((e.field == "AttrValue")&&(e.type=="text")) 
                  {  		
                   	$(e.target).bind("blur",function(){  
	          				$("#linkattrlist").datagrid('endEdit', rowIndex); 
	          				var selItem=$("#linkattrlist").datagrid('getRows')[rowIndex];
	                        var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ selItem.AttrValue.replace(/\^/g,"") +"^"+ "" +"^"+ "";
	                        saveTypeData(ListData,e.type)
                    });  
                  }  
                 if((e.field == "AttrValue")&&(e.type=="textarea")) 
                  {
	               dataGridBindEnterEvent(rowIndex);
	              }  
              
            }  
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
	var params = "";
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;

	new ListComponent('linkattrlist', columns, uniturl, option).Init();			
}
/// 字典分类树
function InitTree(){
	var url = "" //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		multiple: true,
		lines:true,
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	        parref=node.id;        //设置ID  
		   	SubQueryDicList();	
	       
	    },
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
			if (node == null){
				$.messager.alert("提示","请选中节点后重试!"); 
				return;
			}
				
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#dictree").tree('getChildren',node.target)[0];  /// 当前节点的子节点
	        var isLeaf = $("#dictree").tree('isLeaf',childNode.target);        /// 是否是叶子节点
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("dictree", url, option).Init(); 	
}
/// 弹窗属性值treeGrid初始定义
function InitAttrValueList(){
						
	// 定义columns
	var columns=[[     
			{field:'id',title:'id',width:80,sortable:true,hidden:true},
			{field:'code',title:'代码',width:80,sortable:true,hidden:true},
			{field:'desc',title:'属性',width:360,sortable:true,hidden:false},
			{field:'_parentId',title:'parentId',width:80,sortable:true,hidden:true}				
		 ]]

	var option={	
		height:$(window).height()-105,
		idField: 'id',
		treeField:'desc',
		checkbox:true,
		fitColumns:true,	//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		lines:true,		
		showHeader:false,
		pagination:false,
		rownumbers:false,
		onDblClickRow: function (rowIndex, rowData) {	//双击选择行编辑
        },
        onLoadSuccess:function(rowIndex, rowData){
	        var AttrIdList=serverCall("web.DHCCKBDicLinkAttr","QueryEntyLinkAttr",{"EntyId":parref,"AttrCode":EntLinkId})
	        var AttrArray=AttrIdList.split(",");
	        for (var i=0;i<AttrArray.length;i++){
		         if($("#mygrid").treegrid('find',AttrArray[i])==null){continue;}
		         $("#mygrid").treegrid('checkNode',AttrArray[i]);
		    } 
	    }		  
	}
	
	var params = ""
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonNew&attrID=99&input=" //$URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibItemDs";
	new ListTreeGrid('mygrid', columns, uniturl, option).Init();	
}


/// 弹窗DataGrid初始定义
function InitAddgridDataList(attrCode,attrID,htmlType){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns	
	var columns=[];
	var Array=[],dgObj={};
	
	runClassMethod("web.DHCCKBDicLinkAttr","GetColumnsByDicCode",{"AttrId":"","DicCode":attrCode},function(jsonString){
		if(jsonString==""){ return;}
		var jsonObj=jsonString;
		for(var i=0;i<jsonObj.total;i++){
			dgObj={};
			dgObj.field=jsonObj.rows[i].Code;
			dgObj.title=jsonObj.rows[i].Desc;
			dgObj.align="center";
			dgObj.width=60;
			if((jsonObj.rows[i].Code.indexOf("Id")>=0)||(jsonObj.rows[i].Code=="dicGroupFlag"))
			{
				dgObj.hidden=true;
			}
			if(jsonObj.rows[i].edtstr==""){
				dgObj.editor=textEditor;
			}else{
				var tempeditor=jsonObj.rows[i].edtstr;
				var tempObj={};
				optionobj={};
				tempObj.type=tempeditor.split("@")[0];
				optionobj.valueField=tempeditor.split("@")[1];
				optionobj.textField=tempeditor.split("@")[2];
				optionobj.editable=tempeditor.split("@")[3];
				optionobj.url=$URL+"?"+tempeditor.split("@")[5];
				optionobj.panelHeight=tempeditor.split("@")[4];
				optionobj.mode="remote";
				tempObj.options=valueobj;
				dgObj.editor=tempObj;
			}
			Array.push(dgObj);
	 	}
		columns.push(Array);
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
	 		onClickRow:function(rowIndex,rowData){}, 	
	 		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	 			var fileds=$('#addgrid').datagrid('getColumnFields');
				var params=fileds.join("&&");
	 				runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params},function(jsonString){
					
					for(var j=0;j<jsonString.length;j++)
					{
						if(jsonString[j].editors=="combobox"){
							var e = $("#addgrid").datagrid('getColumnOption',jsonString[j].Filed);
							e.editor = {
								type:'combobox',
							  	options:{
								valueField:'value',
								textField:'text',
								mode:'remote',
								url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed,
								onSelect:function(option) {
									var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed});
									$(ed.target).combobox('setValue', option.text);
									var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed+"Id"});
									$(ed.target).val(option.value); 
								} 
							 }
						  }
						}	
					}
					if (subEditRow != ""||subEditRow == 0) { 
	                	$("#addgrid").datagrid('endEdit', subEditRow); 
	           		} 
		            $("#addgrid").datagrid('beginEdit', rowIndex); 
		            
		            subEditRow = rowIndex;
				})
	            
	        }
			  
		}
		var params = parref +"^"+ attrID;
		var uniturl = $URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType;

		new ListComponent('addgrid', columns, uniturl, option).Init();
			
	},'json','false')	
}
///此处列需要动态赋值
function InitTextGridList()
{
	// 定义columns	
	var columns=[[   
			{field:'id',title:'属性id',width:60,align:'left',editor:texteditor,hidden:true},
			{field:'Result',title:'内容',width:60,align:'left',editor:texteditor},
			{field:'dicGroupFlag',title:'dicGroupFlag',width:300,align:'left',hidden:true},
			{field:'Operating',title:'操作',width:50,align:'center',formatter:SetCellUrl}	
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
 		onClickRow:function(rowIndex,rowData){
	 		$("#myarea").val(rowData.Result);
	 	}
	}
	var params = "";	
	var uniturl = $URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params;

	new ListComponent('linklist', columns, uniturl, option).Init();		
}
/// 实体datagrid插入新行
function InsertRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);		//结束编辑，传入之前编辑的行
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editRow=0;
}

/// 实体datagrid删除选中行
function DeleteRow(){
	 
	var rowsData = $("#diclist").datagrid('getSelected'); 						// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						$('#diclist').datagrid('reload'); //重新加载
					}else{
						 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
					}					
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 实体datagrid保存编辑行
function SaveRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = extraAttr +"^"+ extraAttrValue;

	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！','warning');
			InitPageInfo();
			return;	
		}else{
			//$.messager.alert('提示','保存成功！','info');
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			InitPageInfo();
			return;
		}
		
		//$('#diclist').datagrid('reload'); //重新加载
	});
}

/// 实体datagrid查询
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();

	$('#diclist').datagrid('load',{
		extraAttr:"DataSource",
		id:dicParref,
		parDesc:params
	}); 
}

/// 实体datagrid重置
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	SubQueryDicList();
}
function InitTreeData()
{
	$HUI.searchbox('#treequery').setValue("");
	$("#dictree").tree("search", "")
}
/// 查询属性子页面
function SubQueryDicList(){

	var params=dicParref+"^"+parref;
	var options={}
	//alert(params)
	options.url=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;

	$('#linkattrlist').datagrid(options);
	$('#linkattrlist').datagrid('reload');
}

///属性值链接
function setcelLink(rowIndex, rowData)
{
	
	 var e = $("#linkattrlist").datagrid('getColumnOption', 'AttrValue');
	 var DataSource = serverCall("web.DHCCKBRangeCat","GetAddAttrSource",{"queryDicID":rowData.attrID,"AttrLinkCode":"DataSource","AttrId":"","queryDicCode":""});		//数据源
	 if(rowData.dataType=="textarea"){
		 e.editor = {type:'textarea'}
	 }else if(rowData.dataType=="combobox"){
		 e.editor = {type:'combobox',
				  	 options:{
						valueField:'value',
						textField:'text',
						mode:'remote',
						url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+DataSource,
						onSelect:function(option) {
							var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ option.value +"^"+ "" +"^"+ "" +"^"+ "";
	                        saveTypeData(ListData,e.type)
						},
				  		onShowPanel:function(){
							
				    	}	  
					}
		 }
	 }else if((rowData.dataType=="datagrid")||(rowData.dataType=="tree")){
		 e.editor = {type:''}
		 AddAttrValue(rowData.attrID,rowData.dataType,rowData.attrCode);
	 }else{
		 e.editor = {type:'text'}
	 }
	
	 if (valeditRow != ""||valeditRow === 0) { 
            $("#linkattrlist").datagrid('endEdit', valeditRow); 
      } 
     $("#linkattrlist").datagrid('beginEdit', rowIndex); 
     valeditRow=rowIndex;
}

///属性子界面设置操作明细连接
function SetCellOperation(value, rowData, rowIndex){

	var btn = "<img class='mytooltip' title='附加属性' onclick=\"AddAttrValue('"+rowData.attrID+"','"+rowData.dataType+"','"+rowData.attrCode+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  
}

///	编辑属性值弹窗 
function AddAttrValue(attrID,htmlType,attrCode){

	var $width="500";
	var $height="400";
	$(".div-common").hide();		
	$("#myWin").show();

	/// 根据类型加载对应的数据	
	if (htmlType == "textarea"){			
		$("#linkID").val("");
		$("#myarea").val("");
		var params = parref +"^"+attrID;
		var options={};
		options.url=$URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType;
		$('#linklist').datagrid(options);
		$('#linklist').datagrid('reload');
			
	}else if (htmlType == "tree"){
		var options={}
		options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+attrID+"&input=" 
		$('#mygrid').treegrid(options);
		$('#mygrid').treegrid('reload');
		
	}else if(htmlType == "treegrid"){
	

	}else  if(htmlType == "datagrid"){
		InitAddgridDataList(attrCode,attrID,htmlType);		
		var options={}
		var params = parref +"^"+attrID;
		options.url=$URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType;
		$('#addgrid').datagrid(options);
		$('#addgrid').datagrid('reload');
		
	}else if(htmlType == "checkbox"){
	
		
	}else{
		htmlType = "textarea";
		$("#myarea").val("");
		var params = parref +"^"+attrID;
		var options={};
		options.url=$URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType;
		$('#linklist').datagrid(options);
		$('#linklist').datagrid('reload');
	}	
	
	/// 展示维护界面
	$("#my"+htmlType).show();	
	
	/// 初始化已经维护的属性值
	InitEditValue(attrID,htmlType);
	
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-write-order',
		resizable:true,
		title:'添加',
		modal:true,
		//width:500,
		//height:480,
		width:$width,
		height:$height,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			iconCls:'icon-save',
			id:'save_btn',
			handler:function(){				
				SaveAttrValue();
			}
		},{
			text:'关闭',
			iconCls:'icon-close',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	
}

/// 初始化弹出窗已经维护的属性值
function InitEditValue(attrID,htmlType){

	var parrefObj = $("#diclist").datagrid('getSelected');	// 实例
	var dicID="";
	if(parrefObj!=null){
		dicID = $g(parrefObj.ID);
	}
	var node=$("#dictree").tree('getSelected');
	if(node!=null){
		dicID=node.id;
	}
	
	
	
	runClassMethod("web.DHCCKBDicLinkAttr","GetAttrValueJson",{"dicID":dicID,"attrID":attrID,"htmlType":htmlType},function(jsonString){

		var obj=jsonString; //jQuery.parseJSON(jsonString);		
		if ($g(obj) != ""){
			
			if (htmlType == "textarea"){
				
				var rowsArr = $g(obj.rows);
				var result = "";
				var linkID = "";
				$.each(rowsArr,function(index,itmObj){
					
					result = result + $g(itmObj.result);
					linkID = $g(itmObj.linkID);		// 文本输入只有一条记录，如果有多条记录，修改时，保存到最后一条记录中
				})	
				$("#myarea").val(result);
				$("#linkID").val(linkID);
			}	
		}else{
			 $.messager.alert('提示','获取数据失败。'+jsonString,'warning');
		}					
	},"json",false)
}

/// 弹出窗保存属性值
function SaveAttrValue(){

	// 获取实例
	var parrefObj = $("#diclist").datagrid('getSelected');	// 实例
	
	var tmpparref="";
	
	if(parrefObj!=null){
		tmpparref = $g(parrefObj.ID);
	}
	var node=$("#dictree").tree('getSelected');
	if(node!=null){
		tmpparref=node.id;
	}
	if(tmpparref == 0){
		 $.messager.alert('提示','请选择一个药品名称','warning');
		 return;
	}
	
	// 获取属性
	var attrObj=$("#linkattrlist").datagrid('getSelected');	// 属性
	var attrID=$g(attrObj.attrID); 
	var htmlType=$g(attrObj.dataType);						// 属性的展现形式
	var DicCode=attrObj.attrCode;
	if(attrID == 0){
		 $.messager.alert('提示','请选择一个属性','warning');
		 return;
	}
	
	var linkRowID=""	// 
	var linkAttrDr="";
	switch ($g(htmlType)) {
		
		case "textarea":
			linkAttrValue=$("#myarea").val();
			if ($g(linkAttrValue) == ""){
				 $.messager.alert('提示','请填写内容！','info');
				 return;
			}
			linkRowID = $("#linkID").val();				
			break;
			
		case "tree":	
			var attrArr=$('#mygrid').treegrid('getCheckedNodes','checked');
			if(($g(attrArr.length) == 0)||($g(attrArr.length) == "")){
				 $.messager.alert('提示','请选择一个分类','warning');
				 return;
			}
			linkAttrDr = attrArr[0].id;
			break;
		case "datagrid":
			linkRowID = $("#linkID").val();						//实例ID
			break;	
		default:
			linkAttrValue=$("#myarea").val();
			if ($g(linkAttrValue) == ""){
				 $.messager.alert('提示','请填写内容！','info');
				 return;
			}
			linkRowID = $("#linkID").val();				
			break;

	}
	SaveDataWithType(htmlType,attrID,tmpparref,DicCode);   	//调用保存函数  sufan 2019-11-18		

	return;
}

///根据不同类型来保存数据
function SaveDataWithType(htmlType,linkRowID,tmpparref,DicCode)
{
	var dataList=[];
	// 获取维护的属性值
	if (($g(htmlType) == "textarea")||($g(htmlType) == "")){			//保存textarea数据
		var selItem=$("#linklist").datagrid('getSelected');
		var AttrLink="";
		if(selItem){
			AttrLink=selItem.id;
		}
		linkAttrValue=$("#myarea").val();
		var params=AttrLink +"^"+ tmpparref +"^"+ linkRowID +"^"+ "" +"^"+linkAttrValue;
			
	}else if (htmlType == "tree"){	
		var attrArr=$('#mygrid').treegrid('getCheckedNodes','checked');
		for (var i=0;i<attrArr.length;i++){
			var nodeId=attrArr[i].id
			var nodes=$('#mygrid').treegrid('getChildren',nodeId);
			if(nodes.length){continue;}
			var tmp= "" +"^"+ tmpparref +"^"+ linkRowID +"^"+ nodeId +"^"+ "";
			dataList.push(tmp);
		}
		var params=dataList.join("&&");
	}else if ((htmlType == "datagridinput")||(htmlType == "input")){
			
	}else if(htmlType == "datagrid"){			//保存datagrid 
	
		if(subEditRow>="0"){
			$("#addgrid").datagrid('endEdit', subEditRow);
		}
		var rowsData = $("#addgrid").datagrid('getChanges');
		if(rowsData.length<=0){
			$.messager.alert("提示","没有待保存数据!");
			return;
		}
		///取维护的列
		var fileds=$('#addgrid').datagrid('getColumnFields');
		var ListStr="0" +"^"+ tmpparref +"^"+ linkRowID +"^"+ "" +"^"+ ""
		dataList.push(ListStr);
		for(var i=0;i<rowsData.length;i++){
			var GroupNum=rowsData[i].dicGroupFlag;
			for (var j=1;j<fileds.length;j++){
				var ItmId=rowsData[i].Id==undefined?0:rowsData[i].Id
				//var dicDataType=serverCall("web.DHCCKBDicLinkAttr","GetAddAttrCode",{"queryCode":fileds[j],"queryDicID":"","AttrLinkCode":"DataTypeProp"})
				var e = $("#addgrid").datagrid('getColumnOption',fileds[j]);
				if(e.editor.type=="combobox"){continue;}	//下拉框数据不存储	
			    if(fileds[j]=="dicGroupFlag"){continue;}	//组标识不存储
				var ListData = ItmId +"^"+ tmpparref +"^"+ linkRowID +"^"+ rowsData[i][fileds[j]] +"^"+ fileds[j] +"^"+ i +"^"+ GroupNum;
				dataList.push(ListData);
			}
			
		} 
		var params=dataList.join("&&");
	
		
	}else if(htmlType == "checkbox"){
			
	}else{
		
	}
	
	//保存数据
	saveTypeData(params,htmlType,1)
	
}
function saveTypeData(params,htmlType,flag)
{
	
	runClassMethod("web.DHCCKBDicLinkAttr","saveDicAttrByType",{"ListData":params,"Type":htmlType,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！ErrCode'+jsonString,'warning');		
			return;	
		}else{
			//$.messager.alert('提示','保存成功！','info');
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			if(flag==1){
				$HUI.dialog("#myWin").close();
			}
			 
			SubQueryDicList();
			return;
		}		
	});
}
/// 弹窗中新增
function AddBtn(){
		var fileds=$('#addgrid').datagrid('getColumnFields');
	var params=fileds.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params},function(jsonString){
		
		for(var j=0;j<jsonString.length;j++)
		{
			if(jsonString[j].editors=="combobox"){
				var e = $("#addgrid").datagrid('getColumnOption',jsonString[j].Filed);
				e.editor = {
					type:'combobox',
				  	options:{
					valueField:'value',
					textField:'text',
					mode:'remote',
					url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed,
					onSelect:function(option) {
						var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed});
						$(ed.target).combobox('setValue', option.text);
						var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed+"Id"});
						$(ed.target).val(option.value); 
					} 
				 }
			  }
			}	
		}
		
		if(subEditRow>="0"){
			$("#addgrid").datagrid('endEdit', subEditRow);		//结束编辑，传入之前编辑的行
		}
		$("#addgrid").datagrid('insertRow', {
			index: 0, // 行数从0开始计算
			row: {}
		});
		
		$("#addgrid").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
		subEditRow=0;
	})
}


/// 弹窗中删除
function DelBtn()
{
	var rowsData = $("#addgrid").datagrid('getSelected'); //选中要删除的行
	var params = rowsData.Id;
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDicLinkAttr","DelData",{"params":params},function(jsonString){
					if (jsonString!="0")
					{
						$.messager.alert('提示','ErrorCode:'+jsonString,'warning');
					}
					$('#addgrid').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
//查找树的节点
function QueryTreeList()
{
	/*debugger;
	var params = $HUI.searchbox("#myChecktreeDesc").getValue();
	var url=$URL+"?ClassName=web.DHCCKBEditDiction&MethodName=GetTreeJson&parref="+dicParref+"&desc="+params 
	var options={}
	options.url=encodeURI(url);
	new CusTreeUX("dictree", url, options).Init();
	//$("#dictree").treegrid("options").url =encodeURI(url);
	//$('#dictree').treegrid('reload');
	///	var options={}
	/// options.url=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;
	*/
	var desc=$HUI.searchbox("#myChecktreeDesc").getValue();
	$("#dictree").tree("search", desc)
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //取消树的节点选中
}
/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	var html = "<a href='#' onclick='delRow("+ rowData.id +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
	return html;
}

function delRow(ItmId)
{
	if (ItmId != "") {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDicLinkAttr","DelDicAttr",{"linkRowID":ItmId},function(jsonString){
					if(jsonString!=0){
						$.messager.alert('提示',"ErrMsg:"+jsonString)
					}
					$('#linklist').datagrid('reload'); 
				})
			}
		});
	}
}

///修改字典归属
function UpdAttrDiction()
{
	var selecItm=$("#diclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	if((selecItm==null)&&(node==null)){
		$.messager.alert('提示','请选择要修改的字典数据！')
		return;
	}
	if(node!=null){
		var isLeaf=$("#dictree").tree('isLeaf',node.target);
		if(isLeaf==false){
			$.messager.alert('提示','请选择末级节点！')
			return;
		}
	}
	$("#UpdDicWin").show();
	$HUI.combobox("#dicDesc").setValue("");	
	var option = {
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "修改归属字典";		
	new WindowUX(title, 'UpdDicWin', '360', '150', option).Init();
}
function saveDiction()
{
	var selecItm=$("#diclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	var dicId=selecItm==null?node.id:selecItm.ID;
	var dictionId=$HUI.combobox("#dicDesc").getValue();
	if(dictionId==""){
		$.messager.alert("提示","请选择字典！");
		return;
	}
	runClassMethod("web.DHCCKBDiction","UdpDiction",{"DicId":dicId,"DictionId":dictionId},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
	            	$("#diclist").datagrid('reload');
	            	closeDicWin();
	            	return false;
	           	}else{
		           	if(data==-1){
			           	$.messager.popover({msg: '此数据在规则中已引用！',type:'success',timeout: 1000});
			           	closeDicWin();
	            		return false;
			        }else{
				        $.messager.popover({msg: '移动修改失败！',type:'success',timeout: 1000});
				        closeDicWin();
	            		return false;
				    }
		        }
	 })
}
function closeDicWin()
{
	$("#UpdDicWin").window('close');
}
///点击弹出下拉
function dataGridBindEnterEvent(index)
{
	var editors = $('#linkattrlist').datagrid('getEditors',index);
	subEditRow=index;
	for(var i=0;i<editors.length;i++){
		var workEditor = editors[i];
		editors[i].target.attr("field",editors[i].field);
		editors[i].target.mousedown(function(e){
			var field=$(this).attr("field")
			var ed=$("#linkattrlist").datagrid('getEditor',{index:index, field:field});		 
			editdivComponent({
						  tarobj:$(ed.target),
						  filed:field,
						  input:$(this).val(),
						  htmlType:'textarea',
						  height:'260'
						})	
			});	
	}
}

function editdivComponent(opt,callback){
	
		var option={
			width: 445,
			height: 120,
			emrType:'review',
			htmlType:'radio',
			foetus:1
		}
		
		$.extend(option,opt);

		if ($("#win").length > 0){
			$("#win").remove();
		}
		var retobj={};	// 返回对象
			
		///创建弹出窗体
		var btnPos=option.tarobj.offset().top+ option.height;
		var btnLeft=option.tarobj.offset().left - tleft;
		
		if(option.foetus>1){
			option.height=option.height+32*(option.foetus-1)
		}
		$(document.body).append('<div id="win" style="width:'+ option.width +';height:'+option.height+';border:1px solid #E6F1FA;position:fixed;z-index:9999;background-color:#eee;"></div>') 
		var html='<div id="mydiv" class="hisui-layout" fit=true style="background-color:#eee;">'
		html=html+' <div data-options="region:\'center\',title:\'\',border:false,collapsible:false" style="background-color:#eee;height:'+option.height+'">';
		html=html+'<textarea id="divTable" type="text" border="1" class="hisui-validatebox" style="width:92%;height:180px;resize:none;margin:10px;!important" data-options="required:true"></textarea>';
		html=html+'</div>';
		html=html+'<div data-options="region:\'south\',title:\'\',border:false,collapsible:false" style="text-align:center;background-color:#eee;">';
		html=html+'		<a href="#" class="hisui-linkbutton" id="saveDivWinBTN"  style="width:60px" >保存</a>';
		html=html+'		<a href="#" class="hisui-linkbutton"  id="removeDivWinBTN" style="width:60px" >关闭</a>';
		html=html+'</div>';
		html=html+'</div>';
		$("#win").append(html);	
		$("#win").show();
		$.parser.parse($("#win"));
		setTimeout(function(){
			$("#divTable").focus();
		},100)
		
		if($.trim(option.input)!="")
		{
			$("#divTable").val(option.input);
		}
		var tleft = "";
		if((option.tarobj.offset().left+500)>document.body.offsetWidth){
			tleft= 500 - (document.body.offsetWidth - option.tarobj.offset().left);
		}
	
		//$("#win").css("left",option.tarobj.offset().left - tleft);
		//$("#win").css("top",option.tarobj.offset().top+ option.tarobj.outerHeight());
		var $left=option.tarobj.offset().left<option.width?option.tarobj.offset().left:(option.tarobj.offset().left-(document.body.offsetWidth/2-option.width));
		$("#win").css("left",$left);
		var winTop=option.tarobj.offset().top+ option.tarobj.outerHeight();		// win距离顶部的位置
		var winHieght=option.height;											// win本身的宽度
		var $top=($(window).height()-winTop)>winHieght?winTop:winTop-winHieght-30;
		$("#win").css("top",$top);		
		$("#divTable").find("td").children().eq(0).focus();
		$("#divTable").on('keyup',function(e){
			$(option.tarobj).val($("#divTable").val());
		})
		$("#saveDivWinBTN").on('click',function(){
			
			if (option.htmlType == "textarea"){
				$(option.tarobj).val($("#divTable").val());
			}
			var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ $.trim($("#divTable").val()).replace(/\^/g,"") +"^"+ "" +"^"+ "";
	        saveTypeData(ListData,"textarea")	
			$("#win").remove();
		})
		$("#removeDivWinBTN").on('click',function(){
				$("#win").remove();
		});
		$(document).keyup(function(event){
			
			switch(event.keyCode) {
				case 27:
					$("#win").remove();
				case 96:
					$("#win").remove();
			}
		});
		 $("#divTable").bind("blur",function()     //wxj 2021-05-21 失去焦点关闭编辑框 ,并保存数据
	                {
		              if (option.htmlType == "textarea"){
				     $(option.tarobj).val($("#divTable").val());
			            }
			         var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ $.trim($("#divTable").val()).replace(/\^/g,"") +"^"+ "" +"^"+ "";
	                  saveTypeData(ListData,"textarea")	
			          $("#win").remove();
	               })
		
}

/// 药品类型
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })
