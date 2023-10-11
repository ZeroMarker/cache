//===========================================================================================
// Author：      qunianpeng
// Date:		 2019-06-28
// Description:	 新版临床知识库-实体维护属性
//===========================================================================================

var editRow = 0;
var subEditRow = 0; 
var valeditRow = 0;
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
var parref = getParam("parref");	// 具体药品id
var dicParref = getParam("dicParref");	// 药品实体id
var EntLinkId="";					// 属性Id
var property="" ;  //选择属性
/// 页面初始化函数
function initPageDefault(){
	InitButton();			// 按钮响应事件初始化
	InitCombobox();			// 初始化combobox
	InitDataList();			// 实体DataGrid初始化定义
	InitSubDataList();  	// 属性DataGrid初始化定义
	InitAttrValueList();	// 弹窗属性列表DataGrid初始化定义
	//InitAddgridDataList();	// 弹窗datagrid初始化定义
	InitTextGridList();		// text类型的历史数据表格加载

}

/// 按钮响应事件初始化
function InitButton(){

	$("#InsertComOrigin").bind("click",InsertComDrug);	// 增加新行
	$("#insert").bind("click",InsertRow);	// 增加新行
	
	$("#save").bind("click",SaveRow);		// 保存
	
	$("#delete").bind("click",DeleteRow);	// 删除
	
	//$("#find").bind("click",QueryDicList);	// 查询
	
	$("#reset").bind("click",InitPageInfo);	// 重置	
	
	$("#add_btn").bind("click",AddBtn);		// 弹窗中新增
	
	$("#del_btn").bind("click",DelBtn);		// 弹窗中删除
	
	/// 代码.描述查询
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
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
	
	$HUI.radio("[name='FilterCK']",{
        onChecked:function(e,value){
	       var param=LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
           var url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+EntLinkId+"&EntyId="+parref+"&chkFlag="+this.value+"&param="+param;
		   $("#mygrid").tree('options').url =encodeURI(url);
		   $('#mygrid').tree('reload');
        }
     });
	
}

/// 初始化combobox
function InitCombobox(){
		
	/// 初始化分类检索框
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        dicParref = option.value;
	 		if((option.text=="西药")||(option.text=="中成药")){
		    	$("#InsertComOrigin").show();  
		    }else
		    {
			    $("#InsertComOrigin").hide();   
			}
	       	QueryDicList();
	    },
	    loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "中药方剂" && data[i].text != "中药饮片"){
                        data.splice(i,1);
                        //由于splice函数将data中的某个序号的值删掉了，因此整体数组的顺序会依次向前，如果不-1,会导致部分数据未经过筛选
                        i--;
                    }
                }
                return data;
        }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	new ListCombobox("dicType",url,'',option).init(); 	
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
			{field:'dicID',title:'rowid',hidden:true},
			{field:'dicCode',title:'代码',width:200,align:'left',editor:texteditor},
			{field:'dicDesc',title:'描述',width:300,align:'left',editor:texteditor},
			{field:'parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'parrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true}
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
 			parref=rowData.dicID;  
		   	SubQueryDicList();		 
			setTimeout(InitComboboxSub,500);
		}, 
		onDblClickRow: function (rowIndex, rowData) { }
		  
	}
	var params = ""
	var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params+"&drugType="+InitDrugType();
	
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

/// 属性DataGrid初始定义通用名
function InitSubDataList(){
	
	// 定义columns	
	var columns=[[   
			{field:'attrID',title:'属性id',width:60,align:'left',hidden:false},
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
		onDblClickRow:function(rowIndex,rowData){  
 			setcelLink(rowIndex,rowData)
 			var editors = $('#linkattrlist').datagrid('getEditors', rowIndex);                   
            for (var i = 0; i < editors.length; i++){  
                var e = editors[i];  
               
                if((e.field == "AttrValue")&&(e.type=="text")) {  		//e.type=="textarea"||
                   	$(e.target).bind("blur",function(){  
	          				$("#linkattrlist").datagrid('endEdit', rowIndex); 
	          				var selItem=$("#linkattrlist").datagrid('getRows')[rowIndex];
	          				
	                        var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ selItem.AttrValue.replace(/\^/g,"") +"^"+ "" +"^"+ "";
	                      
	                        saveTypeData(ListData,e.type)
                    });  
               }  
               if((e.field == "AttrValue")&&(e.type=="textarea")) {
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

/// 弹窗属性值treeGrid初始定义
function InitAttrValueList(){
						
	/* // 定义columns
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
		         if($("#mygrid").tree('find',AttrArray[i])==null){continue;}
		         $("#mygrid").tree('checkNode',AttrArray[i]);
		    } 
	    }		  
	}
	
	var params = ""
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonNew&attrID=99&input=" //$URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibItemDs";
	new ListTreeGrid('mygrid', columns, uniturl, option).Init();	 */
	var url = ""  //$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		multiple: true,
		lines:true,
		fitColumns:true,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//是否级联检查。默认true  菜单特殊，不级联操作
		animate:true,
        onClick:function(node, checked){
	      
	    },
	    onLoadSuccess: function(node, data){
			
			var AttrIdList=serverCall("web.DHCCKBDicLinkAttr","QueryEntyLinkAttr",{"EntyId":parref,"AttrCode":EntLinkId})
	        var AttrArray=AttrIdList.split(",");
	        for (var i=0;i<AttrArray.length;i++){
		         if($("#mygrid").tree('find',AttrArray[i])==null){continue;}
		         var n=$("#mygrid").tree('find',AttrArray[i])
		         $("#mygrid").tree('check',n.target);
		    } 
		}
	};
	new CusTreeUX("mygrid", url, option).Init();
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
			dgObj.width=200;
			if((jsonObj.rows[i].Code.indexOf("Id")>=0)||(jsonObj.rows[i].Code=="dicGroupFlag"))
			{
				dgObj.hidden=true;
			} 
			if(jsonObj.rows[i].edtstr==""){ //默认格式
				dgObj.editor=textEditor;
			}else{		//维护的格式
				var tempeditor=jsonObj.rows[i].edtstr;		//后台格式串
				var tempObj={};								//编辑格式对象
				optionobj={};								//option 对象
				tempObj.type=tempeditor.split("@")[0];		//编辑格式
				optionobj.valueField=tempeditor.split("@")[1];
				optionobj.textField=tempeditor.split("@")[2];
				optionobj.editable=tempeditor.split("@")[3];
				optionobj.url=$URL+"?"+tempeditor.split("@")[5];
				optionobj.panelHeight=200;
				optionobj.mode="remote";
				tempObj.options=optionobj;
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
		var params = parref +"^"+ attrID	;
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
			$.messager.alert('提示','保存成功！','info');
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
		parref:dicParref,
		params:params
	}); 
}

/// 实体datagrid重置
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	SubQueryDicList();
}

/// 查询属性子页面
function SubQueryDicList(){

	var params=dicParref+"^"+parref+"^"+property;

	var options={}
	options.url=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params+"&drugType="+InitDrugType();

	$('#linkattrlist').datagrid(options);
	$('#linkattrlist').datagrid('load',params);
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

	var $width="780";
	var $height="500";
	$(".div-common").hide();
	$("#dsou").val("");		
	$("#myWin").show();
	$HUI.searchbox("#myChecktreeDesc").setValue("");
	$("input[name='FilterCK'][type='radio']").radio('setValue',false);
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
		var param=LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
		var options={}
		options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+attrID+"&input="+"&param="+param;
		$('#mygrid').tree(options);
		$('#mygrid').tree('reload');
		
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
	var dicID ="";
	if((parrefObj==null)&&(parref!="")){
		dicID=parref;
	}else{
		dicID = $g(parrefObj.dicID);
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
	var tmpparref ="";
	if((parrefObj==null)&&(parref!="")){
		tmpparref=parref;
	}else{
		tmpparref = $g(parrefObj.dicID)
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
			var attrArr=$('#mygrid').tree('getChecked');
			if(($g(attrArr.length) != 0)&&($g(attrArr.length) != "")){
				linkAttrDr = attrArr[0].id;
			}
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
		var attrArr=$('#mygrid').tree('getChecked');
		if(attrArr.length==0){
			var params= "" +"^"+ tmpparref +"^"+ linkRowID +"^"+""+"^"+ "";
		}else{
			for (var i=0;i<attrArr.length;i++){
				var nodeId=attrArr[i].id;
				var node=$('#mygrid').tree('find',nodeId)
				var isLeaf = $("#dictree").tree('isLeaf',node.target);
				//if(!isLeaf){continue;}
				var tmp= "" +"^"+ tmpparref +"^"+ linkRowID +"^"+ nodeId +"^"+ "";
				dataList.push(tmp);
				
			}
			var params=dataList.join("&&");
		}
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
				var e = $("#addgrid").datagrid('getColumnOption',fileds[j]);
				//var dicDataType=serverCall("web.DHCCKBDicLinkAttr","GetAddAttrCode",{"queryCode":fileds[j],"queryDicID":"","AttrLinkCode":"DataTypeProp"})
				if(e.editor.type=="combobox"){continue;}		//下拉框数据不存储
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
			$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
			if(flag==1){
				$HUI.dialog("#myWin").close();
			}
			 
			//SubQueryDicList();   //保存后不刷新
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
	var desc=$HUI.searchbox("#myChecktreeDesc").getValue();
	$("#mygrid").tree("search", desc)
	/* var input = 
	var param=LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
	var url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+EntLinkId+"&input="+input+"&param="+param
	$("#mygrid").tree('options').url =encodeURI(url);
	$('#mygrid').tree('reload');  */
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
///上传
function initUploadPic(){
	var fileName="";
	var d = new Date();
	var curr_date = d.getDate();
    var curr_month = d.getMonth() + 1; 
    var curr_year = d.getFullYear();
    var curdate = curr_year+""+curr_month+""+curr_date;
	$("#uploadify").uploadify({
		//buttonClass:"uploadify-button-a",
		buttonText:"上传图片"
		//fileObjName:"FileStream",
		//formData:{"fileName":fileName},
		//removeCompleted:true,
		//'uploader': "dhcckb.upload.csp?dirname=\\dhcnewpro\\dhcckb\\picture\\"+curdate+"\\", //'websys.file.utf8.csp',
	    ///'swf': '../scripts/dhcnewpro/dhcckb/util/uploadify/uploadify.swf',
	    //'fileTypeExts':'*.gif; *.jpg; *.png',
	    //height:30,   
	    //width:100,
	    //auto:true,
	    //'onUploadComplete' : function(file) {           //在每个文件上传完成时触发，无论成功还是出错。如果你想知道上传成功还是出错，请使用 onUploadSuccess和onUploadError 事件。
	       
	    //},
	    /*'onUploadSuccess' : function(file, data, response) {
			var imgUrl = $.parseJSON(data).fileFullName;
			var ip = $.parseJSON(data).ip;
			var params = recordId+"^"+imgUrl+"^"+UserId;
		},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			//alert('The file ' + file.name + ' could not be uploaded: ' + errorString);
		},
		onComplete: function (evt, queueID, fileObj, response, data) {
				//alert(response);
		},
	    'multi': true  */                               //默认值true，是否允许多文件上传。
    });
}
///新增数据源
function InsertDsource(flag)
{
	var datacode=""
	if(flag==1){
		datacode=$.trim($HUI.searchbox("#myChecktreeDesc").getValue());
	}else{
		datacode=$.trim($("#dsou").val());
	}
	
	var ListData="" +"^"+ datacode +"^"+ datacode +"^"+ EntLinkId;
	runClassMethod("web.DHCCKBRuleMaintain","saveOrUpdateData",{"params":ListData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString == 0){
			$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
		}else{
			 $.messager.alert('提示','保存失败，失败代码'+jsonString,'warning');
		}					
	})
}
function InitComboboxSub()
{
	//属性
    var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrComboxData"  
    $HUI.combobox("#propertyComBox",{
	     				url:uniturl,
	     				valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
							var param=dicParref+"^"+parref+"^"+ret.value;
							$('#linkattrlist').datagrid('load',{
							params:param
							}); 
						}
	   })		
}
// 新增同源药品
// shy
function InsertComDrug()
{
//url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed,
    var uniturl = $URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource=127&filed=EqToUnitProp"  
    $HUI.combobox("#dicEqunitA",{
	     				url:uniturl,
	     				valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
						}
	   })			 
    $HUI.combobox("#dicEqunitB",{
	     				url:uniturl,
	     				valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
						}
	   })		
	
	var rowsData = $("#diclist").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("提示","没有选中同源药品!");
		return;
	}
	$("#InsertComDicWin").show();
	$HUI.combobox("#dicDesc").setValue("");	
	var option = {
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "添加同源药品";		
	new WindowUX(title, 'InsertComDicWin', '680', '260', option).Init();	
}
function closeDicWin()
{
	$("#InsertComDicWin").window('close');
}
function saveComDrug()
{	debugger;
	var rowsData = $("#diclist").datagrid('getSelected');
	var paref = rowsData.parref;
	var dicID = rowsData.dicID;
	var comDrugName = $("#dicName").val();
	var comDrugSpec = $("#dicSpec").val();
	var comDrugAppNum = $("#dicAppNum").val();
	var comDrugEqunitNum = $("#dicEqunitNum").val();
	var comDrugEqunitA = $("#dicEqunitA").combobox('getValue');
	var comDrugEqunitB = $("#dicEqunitB").combobox('getValue');
	if((comDrugName=="")||(comDrugSpec=="")||(comDrugAppNum=="")||(comDrugEqunitNum=="")||(comDrugEqunitA=="")||(comDrugEqunitB==""))
	{
		$.messager.alert("提示","请完善药品信息！");
		return;
	}
	debugger;
	var params="^"+comDrugName+"^"+comDrugName+"^"+paref; 
	var property=comDrugSpec+"^"+comDrugAppNum+"^"+comDrugEqunitNum+"^"+comDrugEqunitA+"^"+comDrugEqunitB;   //规格、批准文号、等效单位                 
	runClassMethod("web.DHCCKBDiction","InsertComDrug",{"params":params,"property":property,"dicID":dicID,"LgUserID":LgUserID,"LgHospID":LgHospID,"ClientIPAddress":ClientIPAdd,"paref":paref},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
	            	closeDicWin();
	            	return false;
	           	}else{
				           $.messager.popover({msg: '修改失败！',type:'success',timeout: 1000});
	            		return false;
				        }
				        
	 })
}
///界面加载完成之后
window.onload = function(){
	if(parref!=""){
		$("#mainPanel").layout("hidden","west");
		SubQueryDicList();
		
	}
}

/// 药品类型
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })

