//===========================================================================================
// Author：      qunianpeng
// Date:		 2019-01-04
// Description:	 新版临床知识库-字典数据
//===========================================================================================

var editRow = 0,editsubRow=0;
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
var parref="";
var IP=ClientIPAdd;
var ChkValue=""
var indexFlag=""
var CDCode=""						//ld 2022-9-20 术语规则判断
/// 页面初始化函数
function initPageDefault(){
	InitParams();
	InitButton();		// 按钮响应事件初始化
	InitCombobox();		// 初始化combobox
	InitDataList();		// 页面DataGrid初始化定义
	InitTree();     	// 初始分类树
	InitSubDataList()	// 字典表
	//initaddattrGrid();	// 附加属性
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
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left',editor:texteditor,hidden:false},
			{field:'CDDesc',title:'描述',width:300,align:'left',editor:texteditor},
			{field:'Parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"知识类型",width:200,align:'left',hidden:true},
			{field:'DataType',title:"数据类型",width:200,align:'left',hidden:true}
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
		pageSize:50,
		pageList:[50,100,150],		
 		onClickRow:function(rowIndex,rowData){ 	     
		   //SubQueryDicList(rowData.ID)
		   parref = rowData.ID;	
		   hiddenColumn(rowData);
		   CDCode=rowData.CDCode; //ld 2022-9-20 术语规则判断用
		   //var params=parref +"^"+ extraAttr +"^"+ "ExtraProp";
		   //$("#addattrlist").datagrid("load",{"params":params});
		   switchMainSrc(parref)
		   if(rowData.DataType=="tree"){
			   $("#treediv").show();
			   $("#griddiv").hide();
			  
			   //kml 2020-03-05 药学分类加排序
			   /* var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+parref; */
			   //ld 2022-9-21 根据字典类型加载tree  术语规则字典
			   if (CDCode=="DefinitionRuleData"){
				var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref;
				}else{
				var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+parref;	
				}
			   $('#dictree').tree('options').url = uniturl;
			   $('#dictree').tree('reload');
		   }else{
			   $("#treediv").hide();
			   $("#griddiv").show();
			   $("#subdiclist").datagrid("load",{"id":parref});
		   }
		  ShowIgnore(rowData.CDCode);
		   
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#diclist").datagrid('endEdit', editRow); 
            } 
            $("#diclist").datagrid('beginEdit', rowIndex); 
            var editors = $('#diclist').datagrid('getEditors', rowIndex);                   
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i]; 
              	$(e.target).bind("blur",function()
              	  {  
                   $("#diclist").datagrid('endEdit', rowIndex); 
                  });   
            } 
            editRow = rowIndex; 
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
        },
        loadFilter: function (data) {	     
        	var loadData = [];                       
          	if (drugType =="Herbal"){	 // 临时屏蔽字典 2021/10/12 qnp      	
	        	for (i=0; i<data.rows.length-1; i++){		        	
			    	if ((data.rows[i].CDDesc == "给药途径字典")||(data.rows[i].CDDesc =="用药频率字典")||(data.rows[i].CDDesc =="处方应付字典")||(data.rows[i].CDDesc =="中药饮片字典")||(data.rows[i].CDDesc =="中药方剂字典")||(data.rows[i].CDDesc =="药嘱信息字典")){
			        	loadData.push(data.rows[i]);
			       	} 
		        }
		        var loadObj = {}
		        loadObj.total = loadData.length;
		        loadObj.rows = loadData;
				return loadObj;		
	        }else{
		       	return data;
		    }
		}		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params="+"&drugType="+InitDrugType();
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}


/// 按钮响应事件初始化
function InitButton(){

	$("#insert").bind("click",InsertRow);	// 增加新行
	
	$("#save").bind("click",SaveRow);		// 保存
	
	$("#delete").bind("click",DeleteRow);	// 删除
	
	$("#find").bind("click",QueryDicList);	// 查询
	
	$("#reset").bind("click",InitPageInfo);	// 重置
	
	/// 代码.描述查询
	//$("#code,#desc").bind("keypress",QueryDicList);	
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
	
	$("#subinsert").bind("click",SubInsertRow);	// 增加新行
	
	$("#subsave").bind("click",SubSaveRow);		// 保存
	
	$("#subdel").bind("click",SubDelRow);	// 删除
	//$("#acdataflag").bind("click",AcDataFlag1);	// 核实
	
	$("#acdataflag").bind("click",function(){       //wangxuejian 2021-05-19
       AcDataFlag("confirm")    //传递核实
     });
     
    $("#cancelAcflag").bind("click",function(){
       AcDataFlag("unconfirm")    //传递取消核实
     });
	
	$("#grantauth").bind("click",GrantAuth);	// 医院授权
	
	$("#businessauth").bind("click",businessAuth);	// 医院授权
	
	$("#grantauthB").bind("click",GrantAuth);	// 医院授权
	
	$("#businessauthB").bind("click",businessAuth);	// 医院授权
	
	$("#setparref").bind("click",ResetParref);	// 重置字典指向
	
	$("#settreeparref").bind("click",ResettreeParref);	// 重置字典指向-tree
	
	//$("#subfind").bind("click",SubQueryDicList);	// 查询
	
	$("#resetsub").bind("click",InitSubPageInfo);	// 重置
	
	/// tabs 选项卡
	$("#tabs").tabs({
		onSelect:function(title){
			
		   	LoadattrList(title);
		}
	});
	
	///属性检索
	$('#attrtreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			findattrTree(searcode);
		}
	});
	
	///属性检索
	$('#dictreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			finddicTree(searcode);
		}
	});
	
	///实体
	$('#entityCode').searchbox({
	    searcher:function(value,name){
	   		QueryWinDicList();
	    }	   
	});
	
	$("#resetwin").bind("click",InitPageInfoWin);	// 重置
	
	$('#myChecktreeDesc').searchbox({
	    searcher:function(value,name){
		    finddgList(value);
	    }	   
	});	
	
	$HUI.radio("[name='FilterCK']",{
        onChecked:function(e,value){
	        $HUI.combotree("#drugcattree").setValue("");
	        ChkValue=this.value;
	       	var seavalue=$HUI.searchbox("#myChecktreeDesc").getValue();
	       	finddgList(seavalue);
        }
     });
     
     ///查询分类
     $('#FindTreeText').searchbox({
	    searcher:function(value,name){
		   reloadTree();
	    }	   
	});	
	
	$("#reviewMan").bind("click",ReviewManage);	// 重置
	
	
	///批量关联
	$("#selmulitm").bind("click",selItmMulSelRow);	
	
	///批量移除
	$("#remomulitm").bind("click",revItmMulSelRow);	
	
	$("#acalldataflag").bind("click",function(){       // xww 2021-08-23 批量核实
       AcAllDataFlag("confirm")    //传递核实
     })
     
    $('input[name="drugIngrType"]').hide();
    $("input:radio[name=drugIngrType]").hide();
    $(".radio hischeckbox_square-blue").hide();
    
    //$HUI.radio("[name='drugIngrType']").hide();
    
}

/// 初始化combobox
function InitCombobox(){
	
	
	
	
}

// 插入新行
function InsertRow(){
	
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

/// 删除行
function DeleteRow(){
	var rowsData = $("#diclist").datagrid('getSelected'); 						// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要停用这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				var StopDate=SetDateTime("date");
				var StopTime=SetDateTime("time");
				SetFlag="stop"        //停用数据标记
				DicName="DHC_CKBCommonDiction"
				dataid=rowsData.ID
				Operator=LgUserID
	  			runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":'log'},function(getString){
					if (getString == 0){
						Result = "操作成功！";
					}else if(getString == -1){
						Result = "当前数据存在引用值,不允许停用";
					}else{
						Result = "操作失败！";	
					}
				},'text',false);
				$.messager.popover({msg: Result,type:'success',timeout: 1000});
				reloadDatagrid();
			}
		}); 
	}else{
		 $.messager.alert('提示','请选择要停用的项','warning');
		 return;
}
	
	 /*UsedDic
	var rowsData = $("#diclist").datagrid('getSelected'); 						// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						$('#diclist').datagrid('reload'); //重新加载
					}else if (jsonString == "-1"){
						 $.messager.alert('提示','该数据已被引用,不能直接删除！','warning');
					}
					else{
						 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
					}				
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
	*/
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
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = extraAttr +"^"+ extraAttrValue;

	//保存数据	 2020-03-27 kml SaveUpdate 改成 SaveUpdateNew
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else if(jsonString == -98){
			$.messager.alert('提示','保存失败,代码重复！','warning');
		}else if(jsonString == -99){
			$.messager.alert('提示','保存失败,描述重复！','warning');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		InitPageInfo();
		
		//$('#diclist').datagrid('reload'); //重新加载
	});
}

// 查询
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();
	
	$('#diclist').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:extraAttrValue,
		params:params,
		drugType:InitDrugType()
	}); 
}

// 重置
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	

}
//==================================================字典维护部分============================================================//
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
			{field:'ID',title:'rowid',hidden:true},
			{field:'ck',title:'操作',checkbox:'true',width:80,align:'left'},  // xww 2021-08-23 用于批量核实检验项数据
			{field:'Operating',title:'操作',width:60,align:'center',formatter:SetCellOper}, 
			{field:'CDCode',title:'代码',width:300,align:'left',editor:'',formatter:tomodify,hidden:false},		//
			{field:'CDDesc',title:'描述',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'Parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"数据类型",width:200,align:'left',hidden:true},
			{field:'ConfirmFlag',title:'审核状态',width:50,align:'left',hidden:true},	// wangxuejian 2021-05-19 增加核实列
			{field:'ConfirmPerson',title:'审核人',width:120,align:'left',hidden:true}	// sunhuiyong 2021-07-30 增加核实人
			//{field:'SetDisabled',title:'不可用',width:200,align:'center',formatter:SetDisabled},
			//{field:'Operating',title:'操作',width:200,align:'center',formatter:SetCellOper} 
			
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		//singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90,10000],		
 		onClickRow:function(rowIndex,rowData){indexFlag=rowIndex;
 		  if (editsubRow != ""||editsubRow == 0) {    //wangxuejian 2021-05-21  关闭编辑行 
                $("#subdiclist").datagrid('endEdit', editsubRow); 
            } 
 		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editsubRow != ""||editsubRow == 0) { 
                $("#subdiclist").datagrid('endEdit', editsubRow); 
            } 
            $("#subdiclist").datagrid('beginEdit', rowIndex); 
            //var dbrowIndex=rowIndex
           var editors = $('#subdiclist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 失去焦点关闭编辑行                
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i];
                var beginrowIndex=""
              	$(e.target).bind("blur",function()
              	  { 
              	  
                    $("#subdiclist").datagrid('endEdit', rowIndex);
              	    
                  });  
                   
                  /*e.target.mousedown(function(e){
	                  	
	                  $("#subdiclist").datagrid('endEdit', rowIndex); 	
	                  	 
                  	})*/
            } 
            
            editsubRow = rowIndex; 
        },
        onLoadSuccess:function(data){
	        var rowdata=$("#diclist").datagrid('getSelected');
	        if((rowdata)&&(rowdata.CDDesc=="西医疾病字典")){
	        	$('#subdiclist').datagrid('showColumn', 'ConfirmPerson'); 
	        }else
	        {
		    	$('#subdiclist').datagrid('hideColumn', 'ConfirmPerson');   
		    }
            $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({});
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByIDWhitinStop&id="+parref+"&parrefFlag=0&hospID="+LgHospID+"&groupID="+LgGroupID+"&locID="+LgCtLocID+"&userID="+LgUserID+"&parDesc=";
	new ListComponent('subdiclist', columns, uniturl, option).Init();
	
}
/// sub插入新行
function SubInsertRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);		//结束编辑，传入之前编辑的行
	}
	
	if(parref == ""){
		$.messager.alert("提示","请先选择一个左侧字典!","info");
		return;
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
	if(parref == ""){
		$.messager.alert("提示","请选择一个左侧字典!","info");
		return;
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
		
		var tmp=$g(rowsData[i].ID) +"^"+ modify($g(rowsData[i].CDCode)) +"^"+ modify($g(rowsData[i].CDDesc)) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";
	
	//保存数据  2020-03-27 kml SaveUpdate 改成 SaveUpdateNew
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		
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
					var StopDate=SetDateTime("date");
					var StopTime=SetDateTime("time");
				//	var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+rowsData.ID+"&ClientIP="+IP;
				//	window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
				//return ;
				runClassMethod("web.DHCCKBDiction","UsedDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						SetFlag="stop"        //停用数据标记
						DicName="DHC_CKBCommonDiction"
						dataid=rowsData.ID
						Operator=LgUserID
						//$HUI.dialog("#diclog").open();
						//var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid+"&ClientIP="+IP;
						//window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
					runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,'Type':'log'},function(getString){
							if (getString == 0){
								Result = "操作成功！";
							}else
							{
								Result = "操作失败！";	
							}
						},'text',false); 
						$.messager.popover({msg: Result,type:'success',timeout: 1000});
						//reloadDatagrid();
						$('#subdiclist').datagrid('deleteRow',indexFlag);   
						indexFlag="" 	
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
/*var rowsData = $("#subdiclist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){					
					if (jsonString==0){
						$('#subdiclist').datagrid('reload'); //重新加载
					}else if (jsonString == "-1"){
						 $.messager.alert('提示','该数据已被引用,不能直接删除！','warning');
					}
					else{
						 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
					}
					
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
*/
}
function reloadDatagrid(){
	$("#diclist").datagrid("reload");
	$("#subdiclist").datagrid("reload");
}
function reloadTree(){
	var Input=$.trim($HUI.searchbox("#FindTreeText").getValue());
	if(Input==""){
		/* var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+parref+"&Input="; */
		if (CDCode=="DefinitionRuleData"){
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref+"&Input=";
		}else{
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref+"&Input=";	
		}
	}else{
		/* var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref+"&Input="+Input; */
		if (CDCode=="DefinitionRuleData"){
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref+"&Input="+Input;
		}else{
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref+"&Input="+Input; 
		//var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref+"&Input=";	
		}
	}
	$('#dictree').tree('options').url = encodeURI(url);	
	$('#dictree').tree('reload');
}
///核实 Sunhuiyong 2020-02-20
function AcDataFlag(conType){
	
	var rowsData = $("#subdiclist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		var ACDate=SetDateTime("date");
		var ACTime=SetDateTime("time");
		//SetFlag="confirm"        //核实数据标记  wangxuejian 2021-05-19
		SetFlag=conType
		DicName="DHC_CKBCommonDiction"
		dataid=rowsData.ID
		Operator=LgUserID
		var confirmFlag=rowsData.ConfirmFlag
		if(((confirmFlag=="Y")||(confirmFlag=="已审核"))&&(conType=="confirm"))
		{
		  $.messager.alert('提示','已经是核实状态不能重复核实','warning');
		   return;
		}
		if(((confirmFlag=="N")||(confirmFlag=="未审核"))&&(conType=="unconfirm"))
		{
		  $.messager.alert('提示','已经是取消核实状态不能重复取消核实','warning');
		   return;
		}
		runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":ACDate,"OperateTime":ACTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":"log"},function(getString){
			if(conType=="confirm")
			{
				Result="核实"
			}
			else if(conType=="unconfirm")
			{
				Result="取消核实"
			}
			if (getString == 0){
				Results =Result+"成功！";
			}else
			{
				Results = Result+"失败！";	
			}
		},'text',false);
		$.messager.popover({msg: Results,type:'success',timeout: 1000});
			reloadDatagrid();
		}
	else{
		 $.messager.alert('提示','请选择要核实的项','warning');
		 return;
	}
		
}
//授权 shy 2020-07-28
function GrantAuth(){

	var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	if((selecItm==null)&&(node==null))
	{
		$.messager.alert('提示',"请选择要授权的项目！","info")
		return;	
	}
	var dicdataId=selecItm==null?node.id:selecItm.ID;
	if( dicdataId == null ){
		$.messager.alert('提示',"请选择要授权的项目！","info")
		return;
	}
	var hideFlag=1;								//按钮隐藏标识
	var setFlag = "grantAuth";					//授权标识
	var tableName = "DHC_CKBCommonDiction";		//授权表
	var dataId = dicdataId;					    //数据Id
	
	if($('#win').is(":visible")){return;}  			//窗体处在打开状态,退出
	
	var linkurl = 'dhcckb.diclog.csp?HideFlag='+hideFlag+'&DicName='+tableName+'&TableName='+tableName+'&dataid='+dataId+'&SetFlag='+setFlag+'&ClientIP='+ClientIPAdd+'&CloseFlag=1&Operator='+LgUserID+'&type=acc' 
	if ("undefined"!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken(); 
	}
	
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-w-save',
        title:'授权',
        modal:true,
        width:700,
        height:460,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+linkurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                GrantAuthItemThis();                    
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }]
    });
	$('#win').dialog('center');
}
//授权 shy 2020-07-28
function businessAuth(){
	
	var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	if((selecItm==null)&&(node==null))
	{
		$.messager.alert('提示',"请选择要授权的项目！","info")
		return;	
	}
	var dicdataId=selecItm==null?node.id:selecItm.ID;
	if( dicdataId == null ){
		$.messager.alert('提示',"请选择要授权的项目！","info")
		return;
	}
	var hideFlag=1;								//按钮隐藏标识
	var setFlag = "businessAuth";					//授权标识
	var tableName = "DHC_CKBCommonDiction";		//授权表
	var dataId = dicdataId;					    //数据Id
	
	if($('#win').is(":visible")){return;}  			//窗体处在打开状态,退出
	
	var linkurl = "dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&TableName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&CloseFlag=1"+"&Operator="+LgUserID+"&type=acc";
	if ("undefined"!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken(); 
	}
	
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-w-save',
        title:'业务授权',
        modal:true,
        width:700,
        height:460,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+linkurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                GrantAuthItemThis();                    
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }]
    });
	$('#win').dialog('center');
}
///项目授权
function GrantAuthItemThis(){

	var flag = $("#otherdiclog")[0].contentWindow.SaveManyDatas();	// 子页面日志
	if (flag){ // false
		$.messager.popover({msg: '授权成功！',type:'success',timeout: 1000});
		$HUI.dialog('#win').close();
	}else{
		//$.messager.popover({msg: '请核对必填项！',type:'warn',timeout: 1000});
	}
	
}
/// sub 查询
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	
	$('#subdiclist').datagrid('load',{
		id:parref,
		parrefFlag:0,
		parDesc:params
	}); 
}

// 重置
function InitSubPageInfo(){

	$HUI.searchbox('#subQueryCode').setValue("");
	SubQueryDicList();	

}

/// 字典分类树
function InitTree(){
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+parref+"&Input=";
	var option = {
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		multiple: true,
		lines:true,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//是否级联检查。默认true  菜单特殊，不级联操作
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	        var isLeaf = $("#dictree").tree('isLeaf',node.target);   /// 是否是叶子节点
	        var Flag=node.flag  //1:引用的数据  0：正常数据 ld 2022-9-20判断是否为引用数据
	        if (Flag==1){
		       $("#treetoolbar").hide(); 							   
	        }else{
		        $("#treetoolbar").show();
		    	//$("#attrtree").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    }
	    },
	    onCheck:function(node,checked)
	    {
		    $(this).tree('select', node.target);
		    var Flag=node.flag  //1:引用的数据  0：正常数据
	        if (Flag==1){
		      $("#treetoolbar").hide();
			}else{
		    	$("#treetoolbar").show();
		    	//$("#attrtree").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    }
		},
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
			if (node == null){
				$.messager.alert("提示","请选中节点后重试!","info"); 
				return;
			}
				
			// 显示快捷菜单
			/* $('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			}); */
			if(CDCode=="DefinitionRuleData"){
				var isLeaf = $("#dictree").tree('isLeaf',node.target);   /// 是否是叶子节点
	        	var Flag=node.flag  //1:引用的数据  0：正常数据
	        	
	        	if (Flag==1){
		    	// 显示快捷菜单
				$('#rightTermDelete').menu('show',{
				left: e.pageX,
				top: e.pageY
				});
					}
				else
					{
		    	// 显示快捷菜单
				$('#rightTerm').menu('show', {
				left: e.pageX,
				top: e.pageY
				});
		    		}
			}else{
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
				}
		},
		onExpand:function(node, checked){
			var childNode = $("#dictree").tree('getChildren',node.target)[0];  /// 当前节点的子节点
			
	        var isLeaf = $("#dictree").tree('isLeaf',childNode.target);        /// 是否是叶子节点
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("dictree", url, option).Init();
	//$('#CheckPart').tree('options').url = uniturl;
	//$('#CheckPart').tree('reload');		
}
/// 查询方法
function SearchData(){
	//var desc=$.trim($("#FindTreeText").val());
	//$("#dictree").tree("search", desc)
	//$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //取消树的节点选中
	reloadTree();
}
/// 重置方法
function ClearData(){
	
	$HUI.searchbox("#FindTreeText").setValue("");
	//$('#dictree').tree('reload')
	//$('#dictree').tree('uncheckAll');
	//$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //取消树的节点选中
	reloadTree();
}
//点击添加子节点按钮
function AddDataTree() {
	RefreshData();
	if (CDCode == "ICDDiagData"){	// icd字典允许修改自定义编码 qnp 20230510
		$("#treeCode").attr("disabled",false)
	}else{
		$("#treeCode").attr("disabled",true)
	}
	
	var options={};
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref;
	$('#parref').combotree(options);
	$('#parref').combotree('reload')
	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-w-save',
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
		//$("#treeID").val(record.id);
		//var parentNode=$("#dictree").tree("getParent",record.target)	
		//if (parentNode){	
		//alert(record.id)	
			$('#parref').combotree('setValue', $g(record.id));
		//}
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
//点击修改按钮
function UpdateDataTree() {
	
	RefreshData();
	
	if (CDCode == "ICDDiagData"){	// icd字典允许修改自定义编码 qnp 20230510
		$("#treeCode").attr("disabled",false)
	}else{
		$("#treeCode").attr("disabled",true)
	}
	
	$('#parref').combotree('reload',$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref)
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
		iconCls:'icon-w-save',
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
///停用tree类型-孙慧勇
function DelDataTree(){
	
	var dataList=[];
	var nodeArr=$('#dictree').tree('getChecked');			//批量停用 sufan20200313
	for (var i=0;i<nodeArr.length;i++){
		var nodeId=nodeArr[i].id;
		dataList.push(nodeId);
	}
	var params=dataList.join("^");
	if (nodeArr.length != 0) {
		$.messager.confirm("提示", "您确定要停用这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				var StopDate=SetDateTime("date");
				var StopTime=SetDateTime("time");
				runClassMethod("web.DHCCKBDiction","IsDicUsed",{"DicIdList":params},function(jsonString){
					if (jsonString == 0){
						SetFlag="stop"        //停用数据标记
						DicName="DHC_CKBCommonDiction"
						dataid=params;
						Operator=LgUserID
						runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":"log"},function(getString){
							if (getString == 0){
								Result = "操作成功！";
							}else
							{
								Result = "操作失败！";	
							}
						},'text',false);
						$.messager.popover({msg: Result,type:'success',timeout: 1000});
						reloadTree();
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
   /*
	var record = $("#dictree").tree("getSelected"); 
	if (!(record))
	{	$.messager.alert('错误提示','请先选择一条记录!',"error");
		return;
	}
	//var childrenNodes = $("#dictree").tree('getChildren',record.target);
	var isLeaf = $("#dictree").tree('isLeaf',record.target);   /// 是否是叶子节点
	if (isLeaf){
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){			
					//保存数据
					runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":record.id},function(jsonString){
						if (jsonString != 0){
							$.messager.alert('提示','删除失败！','warning');
							$('#dictree').tree('reload'); //重新加载
							return;	
						}else{
							//$.messager.alert('提示','保存成功！','info');
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#dictree').tree('reload'); //重新加载
							return;
						}	
						
					});
				}
			});	
	}else{
		$.messager.confirm('提示', '【<font color=red>当前分类下有子分类，删除分类时会同时删除所有的子分类</font>】<br/>确定要删除所选的数据吗?', function(r){
				if (r){			
					//保存数据
					runClassMethod("web.DHCCKBDiction","DeleteAllDic",{"dicID":record.id},function(jsonString){
						if (jsonString != 0){
							$.messager.alert('提示','删除失败！','warning');
							$('#dictree').tree('reload'); //重新加载
							return;	
						}else{
							//$.messager.alert('提示','保存成功！','info');
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#dictree').tree('reload'); //重新加载
							return;
						}	
						
					});
				}
			});
		
	}

	*/
}
function TermRuleTree(){
	
	var node=$("#dictree").tree('getSelected');
	var id=node.id
	var Parref=parref
	var Info=LoginInfo
	var IP=ClientIPAdd
	if($('#win').is(":visible")){return;}  			//窗体处在打开状态,退出
	$('body').append('<div id="win"></div>');
	
	var linkurl = "dhcckb.definitionrule.csp"+"?Parref="+parref+"&NodeId="+id+"&LoginInfo="+LoginInfo+"&ClientIPAdd="+ClientIPAdd;
	if ("undefined"!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken(); 
	}
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-w-save',
        title:'添加术语字典',
        modal:true,
        width:700,
        height:500,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+linkurl+"' style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
			text:'保存',
			iconCls:'icon-save',
			id:'save_btn',
			handler:function(){				
				SaveTermRuleTree();
			}
		},{
			text:'关闭',
			iconCls:'icon-close',
			handler:function(){
				CloseTreeWin();
			}
		}]
    });
	$('#win').dialog('center');
}
function CloseTreeWin(){
	$HUI.dialog("#win").close();
	uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref;
	$('#dictree').tree('options').url = uniturl;
	$('#dictree').tree('reload');
};

function SaveTermRuleTree(){
	$("#otherdiclog")[0].contentWindow.SaveTermRule();	
	
	}
function DelTermRuleTree(){
	var node=$("#dictree").tree('getSelected');
	var id=node.id
	var parentNode=$("#dictree").tree("getParent",node.target)
	var parentId=parentNode.id
	$.messager.confirm('提示', '【<font color=red>删除时会同步删除规则标记</font>】<br/>确定要删除所选的数据吗?',function(r){
				if (r){			
					runClassMethod("web.DHCCKBDefinitionRule","DeleteTermRule",{"ID":id,"parentID":parentId},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！ErrCode'+jsonString,'warning');		
						return;	
					}else{
						$.messager.popover({msg: '删除成功！！',type:'success',timeout: 1000});
						uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref;
						$('#dictree').tree('options').url = uniturl;
						$('#dictree').tree('reload');
					}		
					});
				}
			});
	
	}
///新增、更新
function SaveDicTree(flag){
			
	var treeID=$("#treeID").val();	
	var treeCode=$.trim($("#treeCode").val());
	if ((treeCode=="")&&(CDCode == "ICDDiagData")){
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

	var attrData = "";

	//保存数据  2020-03-27 kml SaveUpdate 改成 SaveUpdateNew
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString >= 0){
			//$.messager.alert('提示','保存成功！','info');
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
		if (CDCode=="DefinitionRuleData"){
		var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref;
			}else{
		var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref;	
			}
		$('#dictree').tree('options').url = uniturl;
		$('#dictree').tree('reload');
		
	});	
	
	//$('#mygrid').treegrid('reload');  // 重新载入当前页面数据 
	//$('#myWin').dialog('close'); // close a dialog

	//$.messager.alert('操作提示',errorMsg,"error");

}
function CloseWin(){

	$HUI.dialog("#myWin").close();
};
///继续添加
function TAddDicTree(flag){	
	SaveDicTree(flag);
}
//点击添加同级节点按钮
function AddSameDataTree() {
	
	RefreshData();
	if (CDCode == "ICDDiagData"){	// icd字典允许修改自定义编码 qnp 20230510
		$("#treeCode").attr("disabled",false)
	}else{
		$("#treeCode").attr("disabled",true)
	}
	
	var options={};
	
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref
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
				SaveDicTree(1);
			}
		},{
			text:'继续添加',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TAddDicTree(2);
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
		var parentNode=$("#dictree").tree("getParent",record.target)			
		$('#parref').combotree('setValue', $g(parentNode.id));
	}
}

/// 列表和树形切换
function switchMainSrc(parref){
	
	var linkUrl=""
	linkUrl = "dhcckb.addlinkattr.csp?parref="+parref;	// 附加属性
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += "&MWToken="+websys_getMWToken(); 
	}
		
	$("#tabscont").attr("src", linkUrl);	

}


///设置操作明细连接
function SetCellOper(value, rowData, rowIndex){
	
	var btn = "<a href='#' title='附加属性' class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\"></a>";
	//var btn = "<img class='mytooltip' title='附加属性' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 

 return btn;  

}

/// 属性编辑框
function OpenEditWin(ID,model,dataType){

	var linkUrl="",title=""
	if (model == "list"){
		
		linkUrl = "dhcckb.addlist.csp"
		title = "字典维护"
		
	}else if (model =="prop"){
		
		linkUrl = "dhcckb.addattr.csp";
		title = "属性列表";
		
	}else if (model == "linkprop"){
		
		linkUrl = "dhcckb.addlinkattr.csp";
		title ="附加属性维护";
		
	}else {
		linkUrl = "dhcckb.addlist.csp"
		title = "字典维护"
	}	
	linkUrl += '?parref='+ID;
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += "&MWToken="+websys_getMWToken(); 
	}
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';

	if($('#winmodel').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		maximized:true,
		maximizable:true,
		width:800,
		height:500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}
//==================================================附加属性============================================================//
///tabs
function LoadattrList(title)
{  
	if (title == "附加属性"){ 
		 switchMainSrc(parref)
	}else{
		 InitSubDataList(); 
	}
}
///附加属性
function initaddattrGrid()
{
	
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
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'AttrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrDr'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrCode'});
				var AddAttrID = $(ed.target).val();
				///设置级联指针
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'AttrDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAttrValue&AddAttrID="+ AddAttrID;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}
	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult"
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'实体ID',width:100,editor:textEditor,hidden:true},
		{field:'DLAAttrCode',title:'属性id',width:150,editor:textEditor,hidden:true},
		{field:'DLAAttrCodeDesc',title:'附加属性',width:200,editor:textEditor},	
		{field:'DLAAttrDr',title:'属性值id',width:80,editor:textEditor,hidden:true},	
		/* {field:'DLAAttrDesc',title:'属性值描述',width:200,editor:Attreditor},	 */	
		{field:'DLAAttrDesc',title:'属性值描述',width:300,editor:textEditor},
		{field:'DLAResult',title:'备注',width:200,editor:textEditor,hidden:true}
	]];
	///  定义datagrid
	var option = {
		singleSelect : true,
	    onClickRow: function (rowIndex, rowData) {		//单机击选择行编辑
           editaddRow=rowIndex;
        },
        onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
           editaddRow=rowIndex;
           ShowAllData();
        }
	};
	
	var params=parref +"^"+ extraAttr ;
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAddLinkAttr&params="+params;
	new ListComponent('addattrlist', columns, uniturl, option).Init();
}
/// 数据集合（全集）
function ShowAllData(){

	var attrrow = $('#addattrlist').datagrid('getSelected');	// 获取选中的行  
	if ($g(attrrow) == ""){
		$.messager.alert('提示','请选择一个附件属性进行维护！','info');
		return;
	}
	$("#AttrWin").show();
	
	SetTabsInit();
      
    var myWin = $HUI.dialog("#AttrWin",{
        iconCls:'icon-write-order',
        resizable:true,
        title:'添加',
        modal:true,
        //left:400,
        //top:150,
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                SaveFunLib();                    
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        }
    });
	$('#AttrWin').dialog('center');
	$('#tabOther').tabs('select',0);  
	
	var AddextraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;
	$("#attrtree").tree('options').url =(uniturl);
	$("#attrtree").tree('reload');
	
	
	$('#tabOther').tabs({
		onSelect:function(title){
			if (title == "属性"){
				var AddextraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;

				$("#attrtree").tree('options').url =(uniturl);
				$("#attrtree").tree('reload');
				
			}else if(title == "字典"){
				var AddextraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;

				$("#dicextratree").tree('options').url =(uniturl);
				$("#dicextratree").tree('reload');
				$("#entitygrid").datagrid("unselectAll");
				
			}else if (title == "实体"){			  	
				var AddextraAttrValue = "ModelFlag" 	// 字典标记(附加属性值)
				var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue+"&params=";

				$("#entitygrid").datagrid('options').url =(uniturl);
				$("#entitygrid").datagrid('reload');
				$("#dicgrid").datagrid("unselectAll");	
				$("#attrtree").tree("unselectAll");	     
			}
		}
	});
}
/// 初始化tabs中的数据表格
function SetTabsInit(){

	var AddextraAttrValue = "AttrFlag" 	// knowledge-属性
	// 属性
	var myAttrTree = $HUI.tree("#attrtree",{
		url:"", //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue,
   		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		//checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false     	//是否树展开折叠的动画效果		
	});
	
	var AddextraAttrValue = "DictionFlag" 	// knowledge-属性
	// 属性
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;
	var DicTree = $HUI.tree("#dicextratree",{
		url:uniturl, 
   		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		//checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,    			//是否树展开折叠的动画效果
		onClick:function(node, checked){
	    	
	    },
	    onLoadSuccess: function(node, data){
			if (node != null){
					$('#dicextratree').tree('expand', node.target);
			}
		}
			
	}); 
	
	// 字典
	var diccolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left'},
			{field:'CDDesc',title:'描述',width:300,align:'left'}			
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
		pageList:[30,60,90]	
		  
	}
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('dicgrid', diccolumns, uniturl, option).Init();
  
    // 实体
	var entitycolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left'},
			{field:'CDDesc',title:'描述',width:300,align:'left'}			
		 ]]
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('entitygrid', entitycolumns, uniturl, option).Init();

}
/// 保存
function SaveFunLib(){

	var currTab = $('#tabOther').tabs('getSelected');
	var currTabTitle = currTab.panel('options').title;
	var selectID=""
	var selectDesc=""
	
	
	if (currTabTitle.indexOf("属性")!=-1){					// 选择属性
		var attrrow = $('#attrtree').tree('getSelected');	// 获取选中的行  
		selectID = $g(attrrow)==""?"":attrrow.id;
		selectDesc =  $g(attrrow)==""?"":attrrow.code;
		
	}else if(currTabTitle.indexOf("字典") != -1){				// 选择字典
	
		var dicrow =$('#dicextratree').tree('getSelected');	// 获取选中的行
		selectID = $g(dicrow)==""?"":dicrow.id;
		selectDesc =  $g(dicrow)==""?"":dicrow.code;
		
	}else if(currTabTitle.indexOf("实体") != -1){				// 选择实体
	
		var entityrow =$('#entitygrid').datagrid('getSelected'); // 获取选中的行  
		selectID = $g(entityrow)==""?"":entityrow.ID;
		selectDesc =  $g(entityrow)==""?"":entityrow.CDDesc;
	}

	if ($g(selectID) == ""){	
		 $.messager.alert('提示','请选择一个属性或字典或实体！','info');
		 return;	
	} 
	
	/// 附加属性界面赋值
	$('#addattrlist').datagrid('beginEdit', editaddRow);	
	//var attrDescObj=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
	//$(attrDescObj.target).val(selectDesc);
	var attrDrObj=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrDr'});
	$(attrDrObj.target).val(selectID);
	$('#addattrlist').datagrid('endEdit', editaddRow);
	saveRowAddAttr();

	//$HUI.dialog("#myWin").close();
}
///保存
function saveRowAddAttr()
{
	// 使用此方法保存时，需要datagrid的列名和表字段名称相同，修改时ID默认固定
	comSaveByDataGrid("User.DHCCKBDicLinkAttr","#addattrlist",function(ret){
			if(ret=="0")
			{
				$('#AttrWin').dialog('close');
				$("#addattrlist").datagrid('reload');
				QueryDicList();
			}
					
		}
	)	
}
//属性树的刷新
function AttrRefreshData()
{
	$HUI.searchbox("#attrtreecode").setValue("");
	var searcode=$HUI.searchbox("#attrtreecode").getValue();
	var AddextraAttrValue = "AttrFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///检索属性树
function findattrTree(searcode)
{
	var extraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///检索字典树
function finddicTree(searcode)
{
	var AddextraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
	if(searcode==""){
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;
	}else{
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;
	}
	$("#dicextratree").tree('options').url =encodeURI(uniturl);
	$("#dicextratree").tree('reload');
}
///属性清屏
function Refreshdic()
{
	$HUI.searchbox("#dictreecode").setValue("");
	var AddextraAttrValue = "DictionFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;
	$("#dicextratree").tree('options').url =encodeURI(uniturl);
	$("#dicextratree").tree('reload');
}
// 实体查询
function QueryWinDicList()
{
	var params = $HUI.searchbox("#entityCode").getValue();
	var AddextraAttrValue="ModelFlag";
	$('#entitygrid').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:AddextraAttrValue,
		params:params
	}); 
}
function InitPageInfoWin()
{
	$HUI.searchbox("#entityCode").setValue("");
	QueryWinDicList();
}
/// 删除
function DelLinkAttr(){

	removeCom("User.DHCCKBDicLinkAttr","#addattrlist")
}
///刷新datagrid
function reloadPagedg()
{
	$("#diclist").datagrid("reload");    
}
//重置字典指向按钮-tree
function ResettreeParref()
{
var node=$("#dictree").tree('getSelected');//选中要修改的行
	if (node != null) {
		$HUI.dialog("#resetparref").open();
	/// 初始化combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        dicParref = option.value;  //选择指向字典id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("newparrefid",url,'',option).init(); 
	}else{
		 $.messager.alert('提示','请选择要修改的元素！','warning');
		 return;		
}		
}
///重置字典指向按钮-datagrid
function ResetParref()
{
var rowsData = $("#subdiclist").datagrid('getSelected'); //选中要修改的行
	if (rowsData != null) {
		$HUI.dialog("#resetparref").open();
	/// 初始化combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        dicParref = option.value;  //选择指向字典id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("newparrefid",url,'',option).init(); 
	}else{
		 $.messager.alert('提示','请选择要修改的元素！','warning');
		 return;		
}
}
///重置指向字典-保存
function SaveParrefData()
{
	/*var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	var dicId=selecItm==null?node.id:selecItm.ID;
	*/
	var selecItmStr=$("#subdiclist").datagrid('getChecked');
	var j = '';
	    for (var k = 0; k < selecItmStr.length; k++) {
	        if (j != '')
	            j += '^';
	        j += selecItmStr[k].ID;
	    }
	var selecItm=$("#subdiclist").datagrid('getSelected');
	var dicId = "";
	
	if(selecItm!=null){
		if(k)
		{
			dicId=j;	
		}else
		{
			dicId=	selecItm.ID;
		}
	}else{
	var nodes = $('#ruleTree').tree('getChecked');
    var s = '';
	    for (var i = 0; i < nodes.length; i++) {
	        if (s != '')
	            s += '^';
	        s += nodes[i].id;
	    }
    var node = $("#ruleTree").tree('getSelected');
	    if(s)
	    {
			dicId=s;	    
		}else
		{
			dicId=node.id;	
		}
	}
	if(dicParref==""){
		$.messager.alert("提示","请选择字典！","info");
		return;
	}
	
	runClassMethod("web.DHCCKBDiction","UdpDictionStr",{"DicIdStr":dicId,"DictionId":dicParref},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
	            	$("#subdiclist").datagrid('reload');
	            	$HUI.dialog("#resetparref").close();
	            	return false;
	           	}else{
		           	if(data==-1){
			           	$.messager.popover({msg: '转移字典不存在实体！',type:'success',timeout: 1000});
			           $HUI.dialog("#resetparref").close();
	            		return false;
			        }else{
				        $.messager.popover({msg: '移动修改失败！',type:'success',timeout: 1000});
				       $HUI.dialog("#resetparref").close();
	            		return false;
				    }
		        }
	 })
		
}
///重置指向字典-保存
function SaveParrefDataOld()
{
	var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	var dicId=selecItm==null?node.id:selecItm.ID;
	if(dicParref==""){
		$.messager.alert("提示","请选择字典！","info");
		return;
	}
	runClassMethod("web.DHCCKBDiction","UdpDiction",{"DicId":dicId,"DictionId":dicParref},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
	            	$("#subdiclist").datagrid('reload');
	            	$HUI.dialog("#resetparref").close();
	            	return false;
	           	}else{
		           	if(data==-1){
			           	$.messager.popover({msg: '此数据在规则中已引用！',type:'success',timeout: 1000});
			           $HUI.dialog("#resetparref").close();
	            		return false;
			        }else{
				        $.messager.popover({msg: '移动修改失败！',type:'success',timeout: 1000});
				       $HUI.dialog("#resetparref").close();
	            		return false;
				    }
		        }
	 })
		
}
///分类药品关联  sufan 20200316
function BatchData()
{
	
	var node = $("#dictree").tree("getSelected");
	if(node==null){
		$.messager.alert('提示',"请先选择药学分类！","info");
		return;
	}
	$('#myChecktreeWin').window({
		title:'分类药品关联',   
	    width:900,    
	    height:560,    
	    modal:true,
	    collapsible:false,
	    minimizable:false,
	    maximizable:false
	 
	}); 
	
	InitCatdrugList();
	$HUI.combotree("#drugcattree",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref,
		editable:true,
		onSelect:function(node){
			var selnode = $("#dictree").tree("getSelected");
			var drugdesc=$HUI.searchbox("#myChecktreeDesc").getValue();
			var params = selnode.id +"^"+ drugdesc +"^"+ ChkValue +"^"+ node.id;
			$("#myChecktree").datagrid('load',{"params":params});
		}
	})	
	
}
///加载分类药品关联列表
function InitCatdrugList()
{
	///  定义columns
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'操作',formatter:SetLinkOp},
		{field:'Code',title:'药品代码',width:100,align:'center'},
		{field:'Desc',title:'药品描述',width:150,align:'center'},
		{field:'CatDesc',title:'关联的分类',width:150,align:'center'},
	]];
	
	///  定义datagrid
	var option = {
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
          
        }
	};
	var node = $("#dictree").tree("getSelected");
	var params = node.id;
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryCatLinkDrug&params="+params;
	new ListComponent('myChecktree', columns, uniturl, option).Init(); 
}
function finddgList(drugdesc)
{
	var node = $("#dictree").tree("getSelected");
	var params = node.id +"^"+ drugdesc +"^"+ ChkValue;
	$("#myChecktree").datagrid('load',{"params":params});
}
function SetLinkOp(value, rowData, rowIndex)
{
	
	if (rowData.Link == "0"){
		var html = "<a href='#' class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' onclick='selItmSelRow("+rowIndex+")'>关联</a>";
	}else{
		var html = "<a href='#' class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' onclick='revItmSelRow("+rowIndex+")'>移除</a>";
	}
    return html;
}

function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}
///关联
function selItmSelRow(rowIndex)
{
	var node = $("#dictree").tree("getSelected");
	var rowData=$("#myChecktree").datagrid('getData').rows[rowIndex];
	var DrugId=rowData.Id;
	var DrugCatAttrId=rowData.DrugCatAttrId;
	
	var ListData="" +"^"+ DrugId +"^"+ DrugCatAttrId +"^"+ node.id +"^"+ "";
	
	runClassMethod("web.DHCCKBDicLinkAttr","InsText",{"ListData":ListData},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '关联成功！',type:'success',timeout: 1000});
            	
           	}
           	$("#myChecktree").datagrid('reload');
 	})
}
///批量关联sufan 2021-04-06
function selItmMulSelRow()
{
	var node = $("#dictree").tree("getSelected");
	var rowData = $("#myChecktree").datagrid('getSelections');
	if(rowData.length==0){
		$.messager.alert('提示',"请选择需要关联的药品!","info");
		return false;
	}
	var dataList = [];
	for(var i=0; i<rowData.length; i++){
		var DrugId = rowData[i].Id;
		var DrugCatAttrId = rowData[i].DrugCatAttrId;
		var tempList = "" +"^"+ DrugId +"^"+ DrugCatAttrId +"^"+ node.id +"^"+ "";
		dataList.push(tempList);
	}
	var listData = dataList.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","InsMulPhacla",{"listData":listData},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '关联成功！',type:'success',timeout: 1000});
            	
           	}
           	$("#myChecktree").datagrid('reload');
 	})
}
///移除
function revItmSelRow(rowIndex)
{
	var node = $("#dictree").tree("getSelected");
	var rowData=$("#myChecktree").datagrid('getData').rows[rowIndex];
	var DrugId=rowData.Id;
	var DrugCatAttrId=rowData.DrugCatAttrId;
	var ListData=DrugId +"^"+ DrugCatAttrId +"^"+ node.id
	
	runClassMethod("web.DHCCKBDiction","revRelation",{"ListData":ListData},
	function(data){
    	if(data==0){
        	$.messager.popover({msg: '移除成功！',type:'success',timeout: 1000});
       	}
       	$("#myChecktree").datagrid('reload');
	})
}
///批量移除sufan 2021-04-06
function revItmMulSelRow()
{
	var node = $("#dictree").tree("getSelected");
	var rowData = $("#myChecktree").datagrid('getSelections');
	if(rowData.length==0){
		$.messager.alert('提示',"请选择需要关联的药品!","info");
		return false;
	}
	var dataList = [];
	for(var i=0; i<rowData.length; i++){
		
		var DrugId = rowData[i].Id;
		var DrugCatAttrId = rowData[i].DrugCatAttrId;
		var tempList = DrugId +"^"+ DrugCatAttrId +"^"+ node.id
		dataList.push(tempList);
	}
	var listData = dataList.join("&&");
	runClassMethod("web.DHCCKBDiction","revMulRelation",{"listData":listData},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '移除成功！',type:'success',timeout: 1000});
            	
           	}
           	$("#myChecktree").datagrid('reload');
 	})
}

///替换特殊字符的方法 sufan 20200513
function modify(str)
{
	var str=str.replace("^","′")   //替换为搜狗，特殊符号，数学符号里的 "′";
	return str;
}
function tomodify(value, rowData, rowIndex)
{
	//var value=value.replace("′","^")   //替换为搜狗，特殊符号，数学符号里的 "′";
	return value;
	var dgvalue=rowData.CDCode;
	return dgvalue.replace('′',"^")  ;
}

/// 管理配置
function ReviewManage()
{
	var selectDataType = $("#diclist").datagrid('getSelected').CDCode; // 选择的字典类型
	var selectItem = "";	// 选择的字典数据
	var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	if((selecItm==null)&&(node==null))
	{
		$.messager.alert('提示',"请选择一条数据！","info")
		return;	
	}
	var selectItem=selecItm==null?node.id:selecItm.ID;
	OpenReviewWin(selectDataType,selectItem);
}

///分类药品关联  qunianpeng 2021/5/13
function BatchDataTab()
{
	
	var node = $("#dictree").tree("getSelected");
	if(node==null){
		$.messager.alert('提示',"请先选择药学分类！","info");
		return;
	}
	var rowsData = $("#diclist").datagrid('getSelected'); 	
	var selDataID = rowsData.ID||"";
	if($('#batchDataTab').is(":visible")){return;}  			//窗体处在打开状态,退出
	
	var linkrul = "dhcckb.addcatlinkdrug.csp"+"?selDataID="+selDataID+"&selCatID="+node.id;
	if ("undefined"!==typeof websys_getMWToken){
		linkrul += "&MWToken="+websys_getMWToken(); 
	}	
	$('body').append('<div id="batchDataTab"></div>');
	var myWin = $HUI.dialog("#batchDataTab",{
        iconCls:'icon-w-save',
        title:'分类关联',
        modal:true,
        width:1200,
        height:650,
        content:"<iframe id='batchDataTabframe' scrolling='auto' frameborder='0' src='"+linkrul+"' " +"style='width:100%; height:99%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[
        	/*{
            text:'保存',
            id:'save_btn',
           	 	handler:function(){
                	GrantAuthItem();                    
            	}
       		},*/
       		{
            text:'关闭',
            	handler:function(){                              
                	myWin.close(); 
            	}
        	}
        ]
    });
	$('#batchDataTab').dialog('center');
}

/// 药品类型
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}

/// xww 2021-08-23 批量核实检验项字典数据
function AcAllDataFlag(conType){
	var rowsData = $('#subdiclist').datagrid('getSelections');		//知识库项目
	if(rowsData.length==0)
	{
		$.messager.alert('提示','请选择要核实的项','warning');
		return;
	}
	var ACDate=SetDateTime("date");
	var ACTime=SetDateTime("time");
	SetFlag=conType
	DicName="DHC_CKBCommonDiction"
	Operator=LgUserID
	var confirmFlag=rowsData.ConfirmFlag;
	var dataList = []
	for(var i=0;i<rowsData.length;i++)
	{
		var tmp = rowsData[i].ID;
		dataList.push(tmp);
	}
	var params=dataList.join("&&");
	

	/*if((confirmFlag=="Y")&&(conType=="confirm"))
	{
	  $.messager.alert('提示','已经是核实状态不能重复核实','warning');
	   return;
	}
	if((confirmFlag=="N")&&(conType=="unconfirm"))
	{
	  $.messager.alert('提示','已经是取消核实状态不能重复取消核实','warning');
	   return;
		}*/
	runClassMethod("web.DHCCKBWriteLog","InsertAllDicLog",{"DicDr":DicName,"params":params,"Function":SetFlag,"Operator":LgUserID,"OperateDate":ACDate,"OperateTime":ACTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":"log"},function(getString){
		if(conType=="confirm")
		{
			Result="核实"
		}
		else if(conType=="unconfirm")
		{
			Result="取消核实"
		}
		if (getString == 0){
			Results =Result+"成功！";
		}else
		{
			Results = Result+"失败！";	
		}
	},'text',false);
	$.messager.popover({msg: Results,type:'success',timeout: 1000});
	reloadDatagrid();
		
}

/// 根据字典隐藏列
function  hiddenColumn(rowData){
	
	if (rowData.CDDesc.indexOf("成分字典")!=-1){
		//$('#subdiclist').datagrid('hideColumn', 'Operating');
	}
 	
}

/// 根据字典代码显示忽略配置
function ShowIgnore(code){
	
	var codeArr = ["DrugData","ChineseDrugData","ChineseHerbalMedicineData","GeneralData","PrescriptionCopeData","GeneralFromData"];
	codeArr.push("DrugProNameData");
	codeArr.push("DrugCategoryData");
	codeArr.push("ingredientData");
	codeArr.push("ExcipientData");
	codeArr.push("DrugPreMetData");
	codeArr.push("DrugFreqData");
	codeArr.push("FormData");
	
	if (codeArr.indexOf(code) > -1){
		$("#reviewMan").show();
		$("#catIgnoreBtn").show();	
	}
	else{
		$("#reviewMan").hide();
		$("#catIgnoreBtn").hide();

	}
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
