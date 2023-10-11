/*规则授权*/
var currEditRow="";currEditID="";currPointer="";
var currLibDr="";	/// 知识库类别标记
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
var selectEle="";

function initPageDefault(){
	
	//InitPageComponent();	/// 初始化界面控件
	InitPageDataGrid();		/// 初始化界面Datagrid
	InitButton();			/// 初始化界面界面按钮响应

}
// 初始化界面控件
function InitPageComponent()
{
	/// 知识库类型
	var option = {
		panelHeight:"auto",       
	    onLoadSuccess: function () { //数据加载完毕事件
	    	$("#libcombo").combobox('setValue',5)
        },
        onSelect:function(option){
	        currLibDr = option.value;
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("libcombo",url,'',option).init();
}
// 初始化界面DataGrid
function InitPageDataGrid(){

	/// 医院
	///  定义columns
	var hospcolumns=[[
	
		{field:'desc',title:'医院',width:300}, 
		{field:'activeflag',title:'启用',width:60,align:'left',formatter:SetCellUrl,hidden:true}, 
		{field:'permisflag',title:'授权',width:60,align:'left',formatter:PermisCellUrl}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	
	///  定义datagrid
	var hospoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		toolbar:[],	
		pagination: false,
	    onClickRow: function (rowIndex, rowData) {
		    // if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"D";
		   		selectEle = currLibDr +"^"+ "D" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('错误提示','知识库不能为空!',"error");
				//return;			
			//}           
        }
	    
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryHospList&rows=100&page=1";
	new ListComponent('hospgrid', hospcolumns, uniturl, hospoption).Init();
	
	
	///职称
	var ctpcolumns=[[  
		{field:'desc',title:'职称',width:300},
		{field:'activeflag',title:'启用',width:60,align:'left',formatter:SetCellUrl,hidden:true},
		{field:'permisflag',title:'授权',width:60,align:'left',formatter:PermisCellUrl}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	var ctpoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar: [],
		onClickRow: function (rowIndex, rowData) {
		    //if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"C";
		   		selectEle = currLibDr +"^"+ "C" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('错误提示','知识库不能为空!',"error");
				//return;			
			//}           
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryCtCptList";
	new ListComponent('cptgrid', ctpcolumns, uniturl, ctpoption).Init();
	
	
	///医生科室
	var docloccolumns=[[  
		{field:'code',title:'科室',width:200,hidden:true},
		{field:'desc',title:'科室',align:'left',width:300}, //qunianpeng 2017/10/9
		{field:'activeflag',title:'启用',width:60,align:'left',formatter:SetCellUrl,hidden:true},
		{field:'permisflag',title:'授权',width:60,align:'left',formatter:PermisCellUrl}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];	
	var doclocoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar:'#doclocbar',
		onClickRow: function (rowIndex, rowData) {
		    //if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"L";
		   		selectEle = currLibDr +"^"+ "L" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('错误提示','知识库不能为空!',"error");
				//return;			
			//}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryDocLocList&Input=&HospId="+LgHospID;
	new ListComponent('doclocgrid', docloccolumns, uniturl, doclocoption).Init();

	///医生
	var doccolumns=[[  
		{field:'desc',title:'医生',width:150,align:'left',},
		{field:'code',title:'工号',width:150,align:'left',},
		{field:'activeflag',title:'启用',width:60,align:'left',formatter:SetCellUrl,hidden:true},
		{field:'permisflag',title:'授权',width:60,align:'left',formatter:PermisCellUrl}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	var docoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar:'#doctorbar',
		onClickRow: function (rowIndex, rowData) {
		    //if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"U";
		   		selectEle = currLibDr +"^"+ "U" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('错误提示','知识库不能为空!',"error");
				//return;			
			//}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryAccDocList&rows=100&page=1&input=";
	new ListComponent('docgrid',doccolumns, uniturl, docoption).Init();
	
	
	/// 权限列表
	var accitmclumns=[[ 
		{field:'desc',title:'描述',width:580}, 
		{field:'libdr',title:'libdr',hidden:true}, 
		{field:'lib',title:'知识库',width:80,hidden:true}, 
		{field:'ralation',title:'关系',hidden:true},   
		{field:'rowid',title:'rowid',hidden:true},
		{field:'id',title:'id',hidden:true},
		{field:'_parentId',title:'parentId',hidden:true},
		{field:'contrl',title:'控制',hidden:true},
		{field:'chk',title:'选择',hidden:true},
		{field:'dataType',title:'字典表类型',hidden:true}
	]];	
	var accoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		//fit : false,
		toolbar:'#btntoolbar',
		pageSize : [800],
		pageList : [800,1600,2400,3200,4000,4800],
		pagination: true,
		onLoadSuccess: function (index,data) { //数据加载完毕事件
           $.each(data.rows,function(tmpindex,obj){
	           if (obj._parentId == ""){
		       		return true;		// 退出本次循环
		       }
		       if(obj.chk == "Y"){
			   		$HUI.treegrid("#accitmgrid").checkNode(obj.id);	
			   }
	       })
        },
        uncheckNode:function(){
	        
	        
	    }	
			   
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryLibAccMenu";
	new ListTreeGrid('accitmgrid', accitmclumns, uniturl, accoption).Init();
}
/// 查询授权项目
function QueryAccitm(input){
	
	currPointer = input;
	$('#accitmgrid').treegrid('load',{
		Input:input
	
	}); 
}
/// 初始化界面按钮响应
function InitButton(){

	// 科室回车事件
	$('#doclocbarid').bind('keydown',function(event){
		 if(event.keyCode == "13"){			 
			var Input=$.trim($("#doclocbarid").val());
			$('#doclocgrid').datagrid('load',  {  
				Input:Input	
			});
		 }
	});
	
	// 医生回车事件
	$('#doctorno').bind('keydown',function(event){
		 if(event.keyCode == "13") {			 
			 var input=$.trim($("#doctorno").val());  			
			$('#docgrid').datagrid('load',  {  
				input:input	
			});
		 }
　 });

	$("#btnSave").click(function(){
	   	SaveAcc();
    })
}

//保存授权
function SaveAcc()
{
	/*
	if (currPointer == ""){
		$.messager.alert("提示","请选择知识库和授权对象!","info");
		return ;
	}
	*/
	
	var input="";
    var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	/* if ((allCheck == "")||(allCheck == null)){
		$.messager.alert("提示","请选择需要授权的项目后进行保存!","info");
	    return;
	  
	} */
	var exitFlag = 0;
	if ((allCheck == "")||(allCheck == null)){
		$.messager.confirm('提示', '【不选择项目保存时，会清除掉当前用户的授权！】<br/>确定清除吗?', function(r){
			if (r){					
				SaveTemp();  				
			}
			else{
				return;
			}
		});	
	}else{
		SaveTemp();
	}		
    
 }

/// 保存前组织保存数据
function SaveTemp(){
	
	var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	var tmpPar = "",ParArr=[],ParInfo ="",checkInfoArr = [];							
	for (var i=0; i<allCheck.length; i++){
		if (allCheck[i]._parentId == ""){	// 上层节点			
			continue;
		}
		else{			
			var checkInfo = allCheck[i].id +":"+allCheck[i].dataType ;	// 勾选的子节点;
			var parRowID = allCheck[i]._parentId;	// 父节点			
			if (ParArr.indexOf(parRowID)==-1){	// 父节点已经存储过
				ParArr.push(parRowID);
				if (ParInfo == ""){
					ParInfo = parRowID+":DHC_CKBCommonDiction" +"^"+ checkInfo;		
				}else{
					ParInfo = ParInfo +"!"+ parRowID+":DHC_CKBCommonDiction" +"^"+ checkInfo;	
				}
				checkInfoArr.push(allCheck[i].id);				
			}
			else{
				if (checkInfoArr.indexOf(allCheck[i].id)!=-1){
					continue;
				}			
				ParInfo = ParInfo +"^"+ checkInfo;	
				checkInfoArr.push(allCheck[i].id);				
			}			
		}
	}
	//		selectEle(知识库类型+"^"+作用域+"^"+作用域值)   +"^"+ 操作用户 +"^"+ 客户端ip    +"@"+ 项目id:字典类型^项目id:字典类型!项目id:字典类型
 	input = selectEle +"^"+ LgUserID +"^"+ ClientIPAdd +"@"+ ParInfo; 
	
	Save(input); 

}
 
function Save(ListData){
					
	runClassMethod("web.DHCCKBGrantAuth","SaveAccItm",{"ListData":ListData},function(jsonString){
		if(jsonString != 0){
			$.messager.alert("提示","保存失败:"+jsonString,"error");
		}else{
			$.messager.alert("提示","保存成功","info");
			ReloadData();
		}
	},'text',false)
}

/// 全选 全销
function trsCheck(isCheckFlag){

	var data = $HUI.treegrid('#accitmgrid').getRoots();
	$.each(data, function(index, obj){
		if (isCheckFlag){
			$HUI.treegrid("#accitmgrid").checkNode(obj.id);
		}else{
			$HUI.treegrid("#accitmgrid").uncheckNode(obj.id);
		}
	})
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){
	
	var Type = rowData.type;
	var ID = rowData.rowid;
	var UseFlag = "";
	var html = "";
	if (value == "Y"){
		UseFlag = "N";
		html = "<a href='#' onclick=\"modFlag('"+ Type +"','"+ ID +"','"+ UseFlag +"')\"><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png'/></a>";
	}else{
		UseFlag = "Y";
		html += "<a href='#' onclick=\"modFlag('"+ Type +"','"+ ID +"','"+ UseFlag +"')\"><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png'/></a>";
	
	}
	return html;
}

/// 修改
function modFlag(Type, PointDr, UseFlag){
	
	runClassMethod("web.DHCCKBGrantAuth","InsUse",{"PointType":Type, "PointDr":PointDr, "IsUseFlag":UseFlag},function(jsonString){
		
		if(jsonString != 0){
			$.messager.alert("提示","修改失败:"+jsonString,"error");
		}else{
			$.messager.alert("提示","修改成功","info");
			var ID = "";
			if (Type == "D") ID = "hospgrid";
			if (Type == "L") ID = "doclocgrid";
			if (Type == "C") ID = "cptgrid";
			if (Type == "U") ID = "docgrid";
			$HUI.datagrid("#"+ ID).reload();
		}
	},'text',false)
}

/// 是否有授权
function PermisCellUrl(value, rowData, rowIndex){
	
	var Type = rowData.type;
	var ID = rowData.rowid;
	var UseFlag = "";
	var html = "";
	value = (value=="Y")?"是":"否";
	if (value == "是"){	
		html = "<span style='color:green'>"+ value +"</span>";
	}else{	
		html += "<span style='color:red'>"+ value +"</span>";
	
	}
	return html;
}

function ReloadData(){
	//	$('#attrlist').datagrid('reload'); //重新加载
	$("#hospgrid").datagrid("reload");
	$("#cptgrid").datagrid("reload");
	$("#doclocgrid").datagrid("reload");
	$("#docgrid").datagrid("reload");
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
