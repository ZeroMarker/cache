//===========================================================================================
// Author：      Sunhuiyong
// Date:		 2020-07-28
// Description:	 新版临床知识库-外部代码表
//===========================================================================================
var Type=""  //选择字典类型	
var editRow = 0,editsubRow=0;
var parref = "";   //字典id  sufan add 2020-12-01
var drugType ="";
/// 页面初始化函数
function initPageDefault(){
	
	InitParams();
	InitButton();		// 按钮响应事件初始化
	InitCombobox();		// 初始化combobox
	InitDataList();		// 页面DataGrid初始化定义
	InitSubDataList()	// 字典表
	MsgTips();
	if(HISUIStyleCode==="lite"){
  		$('.no-data').css("background","url(../images/no_data_lite.png) center center no-repeat");
	}
}

/// 药品类型
function InitParams(){
	
	drugType = getParam("DrugType");	

}

/// 页面DataGrid初始定义通用名
function InitDataList(){
						
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns
	var columns=[[   
			{field:'dicID',title:'dicID',width:80,align:'left',hidden:true},	 
			{field:'EDCode',title:'代码',width:200,align:'left',editor:texteditor},
			{field:'EDDesc',title:'描述',width:300,align:'left',editor:texteditor},
			{field:'EDType',title:'类型',width:300,align:'left',hidden:true},
			{field:'EDHospID',title:'医院',width:300,align:'left',hidden:true},
			{field:'DataType',title:"数据类型",width:200,align:'left',hidden:true}
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
		    Type = rowData.EDType;
		    parref = rowData.dicID;
		    switchMainSrc(parref)
		    var hops=$HUI.combobox("#HospId").getValue();
		   	 	
		   	if(rowData.DataType=="tree"){
			   $(".no-data").hide();
			   $("#treediv").show();
			   $("#griddiv").hide();
			  
			   var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref;
			   $('#dictree').tree('options').url = uniturl;
			   $('#dictree').tree('reload');
		   }else{
			   $("#treediv").hide();
			   $("#griddiv").show();
			   $("#subdiclist").datagrid("load",{"HospID":hops,"Type":Type,"params":""});
			   MsgTips();
		   }		   
		  
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
          
        },
        onLoadSuccess:function(data){
          $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
          $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({
              });
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetExtDicList&HospID="+LgHospID+""+"&params="+"&drugType="+drugType;
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}


/// 按钮响应事件初始化
function InitButton(){
	
	$("#insert").bind("click",InsertRow);	        // 增加新行
	
	$("#savedata").bind("click",SaveRow);		    // 保存
	
	$("#insertsub").bind("click",InsertsubRow);	    // 增加新行-sub
	
	$("#savesubdata").bind("click",SavesubRow);		// 保存-sub
	
	$("#updTreeDic").bind("click",updTreeDic); //修改归属字典
	
	$("#detsub").bind("click",DeletesubRow);	    // 删除数据 ld 2022-8-17
	
	$('#queryCode').searchbox({
		    searcher:function(value,name){
		   		QueryDicList();
		    }	   
		});	
		
	$('#subQueryCode').searchbox({
	    searcher:function(value,name){
	   		SubQueryDicList();
	    }	   
	});	
	
	/// tabs 选项卡
	$("#tabs").tabs({
		onSelect:function(title){
			
		   	LoadattrList(title);
		}
	});
	
	///查询分类
    $('#FindTreeText').searchbox({
	    searcher:function(value,name){
		   reloadTree();
	    }	   
	});	
}

/// 初始化combobox
function InitCombobox(){
	//医院
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#HospId",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote',
		onSelect:function(ret){
			var params = $HUI.searchbox("#subQueryCode").getValue();
			$('#subdiclist').datagrid('load',{
				HospID:ret.value,
				Type:Type
			}); 
		}
	  })	
	   
    var arr = new Array();
    var params = $HUI.searchbox("#subQueryCode").getValue();
	   runClassMethod("web.DHCCKBExtDictionary","GetExtDicList",{"HospID":"", "params":params},function(jsonString){
		var arr=new Array();
		for (i = 0; i< jsonString.rows.length; i++) {
		   var obj=new Object();
		   obj.id=jsonString.rows[i].EDType;
		   obj.text=jsonString.rows[i].EDDesc;
		   arr.push(obj);
		}
	    $('#dicDesc').combobox({
			data:arr,
			valueField: 'id',
			textField: 'text',
			blurValidValue:true,
			editable:false
		})
	  	},'json');
	  
}


// 查询
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();
	$('#diclist').datagrid('load',{
		HospID:LgHospID,
		params:params
	}); 
	Type = "";
	parref = "";
	var hops=$HUI.combobox("#HospId").getValue();
	var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref;
	$('#dictree').tree('options').url = uniturl;
	$('#dictree').tree('reload');
	$("#subdiclist").datagrid("load",{"HospID":hops,"Type":Type,"params":""});
	
	if ($("#tabscont")[0].contentWindow){
		$("#tabscont")[0].contentWindow.CatId = "";
		$("#tabscont")[0].contentWindow.ReloadData();
	}

}

// 重置 
function InitPageInfo(){
	
	

}
// 插入新行
function InsertRow(){
	debugger;
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);		//结束编辑，传入之前编辑的行
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editRow=0;
}
/// 保存编辑行
function SaveRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].EDCode=="")||(rowsData[i].EDDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].EDCode) +"^"+ $g(rowsData[i].EDDesc);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//保存数据	 
	runClassMethod("web.DHCCKBExtDictionary","InsertExtDics",{"params":params,"Type":Type,"HospID":LgHospID},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		
		$('#diclist').datagrid('reload'); //重新加载
	});
}
// 插入新行-sub
function InsertsubRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);		//结束编辑，传入之前编辑的行
	}
	$("#subdiclist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#subdiclist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editsubRow=0;
}
/// 保存编辑行-sub
function SavesubRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#subdiclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].EDCode=="")||(rowsData[i].EDDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].EDRowID)+"^"+ $g(rowsData[i].EDCode) +"^"+ $g(rowsData[i].EDDesc);	// qnp 2021/4/23 增加id
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
 	var hospID=$HUI.combobox("#HospId").getValue();
 	hospID = (hospID=="")?LgHospID:hospID;
	//保存数据	 
	///runClassMethod("web.DHCCKBExtDictionary","InsertExtsubDics",{"params":params,"Type":Type,"HospID":hospID},function(jsonString){
	runClassMethod("web.DHCCKBExtDictionary","SaveUpdateExtDics",{"params":params,"Type":Type,"HospID":hospID,"Parref":parref},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		
		$('#subdiclist').datagrid('reload'); //重新加载
	});
}

//修改归属字典
function updTreeDic(){
	var rowsData = $("#subdiclist").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("提示","没有要修改的数据!");
		return;
	}
	$("#UpdDicWin").show();
	$HUI.combobox("#dicDesc").setValue("");	
	var option = {
		modal:true,
		iconCls:'icon-w-save',
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "字典归属修改";		
	new WindowUX(title, 'UpdDicWin', '360', '125', option).Init();
}
/// 删除数据  ld  2022-8-17
function DeletesubRow(){
	var rowsData = $("#subdiclist").datagrid('getSelected'); //选中要删除的行
	var dicType = Type;
	if (rowsData != null) {
		var param=$g(rowsData.EDRowID)+"^"+ $g(rowsData.EDCode) +"^"+ $g(rowsData.EDDesc) +"^"+ dicType;
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	// 提示是否删除
			if (res){
				runClassMethod("web.DHCCKBExtDictionary","DeleteDic",{"ListData":param},function(jsonString){
						if (jsonString >= 0){
							$.messager.alert('提示','删除成功！','info');
						}else{
							$.messager.alert('提示','删除失败！','warning');
							}
					$('#subdiclist').datagrid('reload'); //重新加载		
							  })
					}
						});		
			}else{
				$.messager.alert('提示','请选择要删除的项','warning');
		 		return;
				 }		

}
function saveDiction()
{
	var rowsData = $("#subdiclist").datagrid('getSelected');
	var dictionId=$HUI.combobox("#dicDesc").getValue();
	if(dictionId==""){
		$.messager.alert("提示","请选择字典！","info");
		return;
	}
 var rowid= rowsData.EDRowID;                              
	runClassMethod("web.DHCCKBExtDictionary","UdpDiction",{"RowId":rowid,"DictionId":dictionId},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
	            	closeDicWin();
	            	InitSubDataList();
	            	return false;
	           	}else{
				           $.messager.popover({msg: '修改失败！',type:'success',timeout: 1000});
	            		return false;
				        }
				        
	 })
}

function closeDicWin()
{
	$("#UpdDicWin").window('close');
}


//==================================================外部代码表数据维护部分============================================================//
/// 页面DataGrid初始定义通用名
function InitSubDataList(){
						
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns   
	var columns=[[   	 
			{field:'EDRowID',title:'ID',hidden:true},
			{field:'EDCode',title:'代码',width:100,editor:texteditor},
			{field:'EDDesc',title:'描述',width:100,align:'left',editor:texteditor},
			{field:'EDType',title:'类型',width:250,align:'left',hidden:true},
			{field:'EDHospID',title:'医院',width:200,align:'left'}
			
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
	 		
	 	}, 
		onDblClickRow: function (rowIndex, rowData) {
             if (editsubRow != ""||editsubRow == 0) { 
                $("#subdiclist").datagrid('endEdit', editsubRow); 
            } 
            $("#subdiclist").datagrid('beginEdit', rowIndex); 
            
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
	var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetExtDicListData&HospID="+LgHospID+"&Type=&params="+"";
	new ListComponent('subdiclist', columns, uniturl, option).Init();
	
}
/// sub插入新行
function SubInsertRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);		//结束编辑，传入之前编辑的行
	}
	$("#subdiclist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#subdiclist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editsubRow=0;
}

/// sub保存
function SubSaveRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#subdiclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params = $HUI.searchbox("#subQueryCode").getValue();
	var attrData = "";

	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LgUserID":LgUserID,"LgHospID":LgHospID},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else if(jsonString == -98){
			$.messager.alert('提示','保存失败,代码重复！','warning');
			
		}else if(jsonString == -99){
			$.messager.alert('提示','保存失败,描述重复！','warning');

		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		SubQueryDicList(parref);		
		//$('#diclist').datagrid('reload'); //重新加载
	});
}

/// sub删除    sunhuiyong 2020-02-03 删除插入表中不真正删除 
function SubDelRow(){
	var rowsData = $("#subdiclist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要停用这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","UsedDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						SetFlag="STDATA"        //停用数据标记
						DicName="DHC_CKBCommonDiction"
						dataid=rowsData.ID
						Operator=LgUserID
						//$HUI.dialog("#diclog").open();
						var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid+"&ClientIP="+IP;
						link += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
						window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
					}else if (jsonString == "-1"){
						 $.messager.alert('提示','该数据已被引用,不能直接停用！','warning');
					}		
				})
			}
		});		
	}else{
		 $.messager.alert('提示','请选择要停用的项','warning');
		 return;
	}		

}
function reloadDatagrid(){
	$("#diclist").datagrid("reload");
	$("#subdiclist").datagrid("reload");
}

/// sub 查询
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	var Hos = $HUI.combobox("#HospId").getValue();
	$('#subdiclist').datagrid('load',{
		HospID:Hos,
		Type:Type,
		params:params
	}); 
}

function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}

///刷新datagrid
function reloadPagedg()
{
	$("#diclist").datagrid("reload");    
}

function LoadattrList(title)
{  
	if (title == "附加属性"){ 
		 switchMainSrc(parref)
	}else{
		 InitSubDataList(); 
	}
}
/// 列表和树形切换
function switchMainSrc(parref){
	
	var linkUrl=""
	linkUrl = "dhcckb.addlinkattrext.csp?parref="+parref+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""); // 附加属性

	$("#tabscont").attr("src", linkUrl);	

}


//点击添加子节点按钮
function AddDataTree() {
	RefreshData();
	var options={};	
	options.url=$URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"");
	$('#parref').combotree(options);
	$('#parref').combotree('reload')
	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-addlittle',
		resizable:true,
		title:'添加',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree(1)
			}
		},{
			text:'继续添加',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TAddDicTree(2)
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	
	var record =$("#dictree").tree('getSelected');
	
	if (record){
		$('#parref').combotree('setValue', $g(record.id));
	}
}

//点击修改按钮
function UpdateDataTree() {
	
	RefreshData();
	$('#parref').combotree('reload',$URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref)
	var record = $("#dictree").tree("getSelected"); 
	if (!(record))
	{	
		$.messager.alert('错误提示','请先选择一条记录!',"error");
		return;
	}
	var id=record.id;
	if (record){
		$("#treeID").val(record.id);
		var parentNode=$("#dictree").tree("getParent",record.target)	
		if (parentNode){		
			$('#parref').combotree('setValue', $g(parentNode.id));
		}
		$("#treeCode").val(record.code);
		$("#treeDesc").val(record.text);
	}
	$("#myWin").show(); 
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-updatelittle',
		resizable:true,
		title:'修改',
		modal:true,
		//height:$(window).height()-70,
		buttons:[{
			text:'保存',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree(1)
			}
		},{
			text:'关闭',
			//iconCls:'icon-cancel',
			handler:function(){
				RefreshData();
				myWin.close();
			}
		}]
	});
}	

function DelDataTree(){
	
	var dataList=[];
	var nodeArr=$('#dictree').tree('getChecked');			//批量停用 sufan20200313
	for (var i=0;i<nodeArr.length;i++){
		var nodeId=nodeArr[i].id;
		dataList.push(nodeId);
	}
	var params=dataList.join("^");
	if (nodeArr.length != 0) {
		$.messager.confirm("提示", "您确定要删除用这些数据吗？", function (res) {	// 提示是否删除
			if (res) {			
				runClassMethod("web.DHCCKBExtDictionary","DeleteData",{"idStr":DeleteData},function(getString){
					if (getString == 0){
						Result = "操作成功！";
					}else if (getString == -1){
						Result = "数据已对照,不能删除！";	
					}else{
						Result = "操作失败！";	
					}
				},'text',false);
				$.messager.popover({msg: Result,type:'success',timeout: 1000});
				reloadTree();
			}	
		})

	}else{
		 $.messager.alert('提示','请选择要删除的数据','warning');
		 return;
	}	    
}

/// 清空数据
function RefreshData(){
	$("#treeID").hide();
	$("#treeID").val("");
	$("#treeCode").val("");
	$("#treeDesc").val("");
	$('#parref').combotree('setValue','');
};

///继续添加
function TAddDicTree(flag){	
	SaveDicTree(flag);
}
///新增、更新
function SaveDicTree(flag){
			
	var treeID=$("#treeID").val();	
	var treeCode=$.trim($("#treeCode").val());
	if (treeCode==""){
		$.messager.alert('错误提示','代码不能为空!',"error");
		return;
	}
	var treeDesc=$.trim($("#treeDesc").val())
	if (treeDesc==""){
		$.messager.alert('错误提示','描述不能为空!',"error");
		return;
	}
	///上级分类
	if ($('#parref').combotree('getText')==''){
		$('#parref').combotree('setValue','')
	}
	
	var setParref = $('#parref').combotree('getValue')=="" ? parref : $('#parref').combotree('getValue') // 分类为空,则默认挂在分类字典下面
	var params=$g(treeID) +"^"+ $g(treeCode) +"^"+ $g(treeDesc) +"^"+ $g(setParref)

	var hops=$HUI.combobox("#HospId").getValue();		   
	
	runClassMethod("web.DHCCKBExtDictionary","SaveUpdateExtDics",{"params":params,"Type":Type,"HospID":hops,"Parref":$g(setParref)},function(jsonString){
		if (jsonString >= 0){
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			if(flag==1)
			{
				CloseWin();
			}
		}else if(jsonString == -98){
			$.messager.alert('提示','保存失败,代码重复！','warning');
		}else if(jsonString == -99){
			$.messager.alert('提示','保存失败,描述重复！','warning');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		
		var uniturl = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref
		$('#dictree').tree('options').url = uniturl;
		$('#dictree').tree('reload');
		
	});	

}

function reloadTree(){
	var Input=$.trim($HUI.searchbox("#FindTreeText").getValue());
	if(Input==""){ // 
		var url = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref+"&Input=";
	}else{
		var url = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+parref+"&Input="+Input;
	}
	$('#dictree').tree('options').url = encodeURI(url);	
	$('#dictree').tree('reload');
}

function CloseWin(){

	$HUI.dialog("#myWin").close();
};


/// 重置方法
function ClearData(){
	
	$HUI.searchbox("#FindTreeText").setValue("");
	reloadTree();
}

function MsgTips(){
	
	if (parref == ""){
		$("#griddiv").hide();
		//$("#treediv").hide();
		$(".no-data").show();		
	}else{
		
		$("#griddiv").show();
		//$("#treediv").show();
		$(".no-data").hide();	
	}

}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
