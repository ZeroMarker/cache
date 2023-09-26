var PageLogicObj={
	m_ExaBoroughDepTabDataGrid:"",
	m_ExaListTabDataGrid:"",
	m_LocListTabDataGrid:""
}
$(function(){
	Init();
	InitEvent();
	PageHandle();
	ExaBoroughDepTabDataGridLoad();
});
function PageHandle(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	//初始化诊区
	$.cm({
		ClassName:"web.DHCExaBorough",
		QueryName:"FindExaBorough",
		dataType:"json",
		borname:"",
		HospId:HospID,
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ExaBord", {
				valueField: 'rid',
				textField: 'name', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					var opts = $(this).combobox('options');
					return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
				}
		 });
	});
    //初始化科室
    $.cm({
		ClassName:"DHCDoc.DHCDocConfig.CommonFunction",
		QueryName:"QueryLoc",
		dataType:"json",
		depname:"",
		UserID:"",
		LogHospId:HospID,
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#BordDep", {
				valueField: 'id',
				textField: 'name', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return ((row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["ContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
				}
		 });
	});
}
function InitEvent(){
	$('#Bfind').click(ExaBoroughDepTabDataGridLoad);
	$("#BSave").click(MulExaBorDepSave);
	$("#MulExaBorDepWin").window({
		onClose:function(){
			ExaBoroughDepTabDataGridLoad();
		}
	})
}
function Init(){
	
	//初始化医院
	var hospComp = GenHospComp("DHCExaBorDep");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageHandle();
		ExaBoroughDepTabDataGridLoad();
	}
	
	PageLogicObj.m_ExaBoroughDepTabDataGrid=InitExaBoroughDepTabDataGrid();
}
function InitExaBoroughDepTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    },{
		text:'科室批量对照',
		id:'i-Alladd',
		iconCls: 'icon-add',
		handler: function() {
			$("#FindExa,#FindLoc").searchbox('setValue',""); 
			$('#MulExaBorDepWin').window('open');
			if (PageLogicObj.m_ExaListTabDataGrid==""){
				PageLogicObj.m_ExaListTabDataGrid=InitExaListTabDataGrid();
			}else{
				PageLogicObj.m_ExaListTabDataGrid.datagrid('options').url=$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaBorough&borname=&HospId="+$HUI.combogrid('#_HospList').getValue();
				PageLogicObj.m_ExaListTabDataGrid.datagrid("reload");
			}
		}
	}];
	var Columns=[[ 
		{field:'TID',hidden:true,title:''},
		{field:'TBordBordesc',title:'分诊区',width:300},
		{field:'TBordDepdesc',title:'科室',width:300},
		{field:'TBordMemo',title:'备注',width:300},
		{field:'TBordDepDr',title:'',hidden:true},
		{field:'TBordBorDr',title:'',hidden:true}
    ]]
	var ExaBoroughDepTabDataGrid=$("#ExaBoroughDepTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'TID',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			$("#ExaBord,#BordDep").combobox("select","");
			$("#BordMemo").val("");
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return ExaBoroughDepTabDataGrid;
}
function SetSelRowData(row){
	var cbox=$HUI.combobox("#ExaBord"); 
	var BordBorDr=cbox.select(row["TBordBorDr"]);
	var cbox=$HUI.combobox("#BordDep"); 
	var ExaRoomDr=cbox.select(row["TBordDepDr"]);
	$("#BordMemo").val(row["TBordMemo"]);
}
function AddClickHandle(){ 
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#ExaBord"); 
	var BordBorDr=cbox.getValue();
	var cbox=$HUI.combobox("#BordDep"); 
	var BordDepDr=cbox.getValue();
	var BordMemo=$("#BordMemo").val();
	$.cm({
		ClassName:"web.DHCExaBorDep",
		MethodName:"insertBorDep",
		itmjs:"",
		itmjsex:"",
		BordBorDr:BordBorDr,
		BordDepDr:BordDepDr,
		BordMemo:BordMemo
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("提示","增加成功!");
			ClearData();
			PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('uncheckAll');
			ExaBoroughDepTabDataGridLoad();
		}else{
			$.messager.alert("提示","增加失败!记录重复!");
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的行!");
		return false;
	}
	var rtn=$.cm({
		ClassName:"web.DHCExaBorDep",
		MethodName:"CheckDepMark",
		Bordr:row["TBordBorDr"], Deptdr:row["TBordDepDr"]
	},false);
	if (rtn=="1"){
		$.messager.confirm('确认对话框', row["TBordBordesc"]+"和"+row["TBordDepdesc"]+'的对照关系在分诊区号别对照界面已有维护数据,若继续则会删除分诊区号别对照数据,是否继续?', function(r){
			if (r){
			   Del();
			}
		});
	}else{
		Del();
	}
	function Del(){
		$.cm({
			ClassName:"web.DHCExaBorDep",
			MethodName:"DeleteBorDep",
			itmjs:"",
			itmjsex:"",
			id:row["TID"]
		},function(rtn){
			if (rtn=="0"){
				$.messager.alert("提示","删除成功!");
				ClearData();
				PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('uncheckAll');
				ExaBoroughDepTabDataGridLoad();
			}else{
				$.messager.alert("提示","删除失败!"+rtn);
				return false;
			}
		});
	}
}
function Del(id){
	
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要更新的行!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#ExaBord"); 
	var BordBorDr=cbox.getValue();
	var cbox=$HUI.combobox("#BordDep"); 
	var BordDepDr=cbox.getValue();
	var BordMemo=$("#BordMemo").val();
	if (BordDepDr==row["TBordDepDr"]){
		update();
	}else{
		var rtn=$.cm({
			ClassName:"web.DHCExaBorDep",
			MethodName:"CheckDepMark",
			Bordr:row["TBordBorDr"], Deptdr:row["TBordDepDr"]
		},false);
		if (rtn=="1"){
			$.messager.confirm('确认对话框', row["TBordBordesc"]+"和"+row["TBordDepdesc"]+'的对照关系在分诊区号别对照界面已有维护数据,若继续则会删除分诊区号别对照数据,是否继续?', function(r){
				if (r){
				   update();
				}
			});
		}else{
			update();
		}
	}
	
	function update(){
		$.cm({
			ClassName:"web.DHCExaBorDep",
			MethodName:"updateBorDep",
			itmjs:"",
			itmjsex:"",
			BordBorDr:BordBorDr,
			BordDepDr:BordDepDr,
			BordMemo:BordMemo,
			id:row["TID"]
		},function(rtn){
			if (rtn=="0"){
				$.messager.popover({msg: '更新成功!',type:'info',timeout: 2000,showType: 'show'});
				ClearData();
				PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('uncheckAll');
				ExaBoroughDepTabDataGridLoad();
			}else{
				$.messager.alert("提示","更新失败!记录重复!");
				return false;
			}
		});
	}
}

function ClearData(){
	var cbox=$HUI.combobox("#ExaBord"); 
	cbox.select("");
	var cbox=$HUI.combobox("#BordDep"); 
	cbox.select("");
	$("#BordMemo").val("");
}
function CheckDataValid(){
	var cbox=$HUI.combobox("#ExaBord"); 
	var ExaBord=cbox.getValue();
	var ExaBord=CheckComboxSelData("ExaBord",ExaBord);
	if (ExaBord==""){
		$.messager.alert("提示","请选择分诊区!","info",function(){
			$('#ExaBord').next('span').find('input').focus();
		});
		return false;
	}
	var cbox=$HUI.combobox("#BordDep"); 
	var BordDepDr=cbox.getValue();
	var BordDepDr=CheckComboxSelData("BordDep",BordDepDr);
	if (BordDepDr==""){
		$.messager.alert("提示","请选择科室!","info",function(){
			$('#BordDep').next('span').find('input').focus();
		});
		return false;
	}
	return true;
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="BordDep"){
		 	var CombValue=Data[i].id;
		 }else{
			 var CombValue=Data[i].rid;
		 }
		 var CombDesc=Data[i].name;
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function ExaBoroughDepTabDataGridLoad(){
	var BordBorDr=$("#ExaBord").combobox("getValue");
	var BordDepDr=$("#BordDep").combobox("getValue");
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
	    ClassName : "web.DHCExaBorough",
	    QueryName : "UFindExaBorDep",
	    BordBorDr:BordBorDr,
	    BordDepDr:BordDepDr,
	    HospId:HospID,
	    Pagerows:PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitExaListTabDataGrid(){
	var Columns=[[ 
		{field:'name',title:'分诊区',width:180},
		{field:'rid',title:'ID',width:80}
    ]]
	var ExaListTabDataGrid=$("#ExaListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'rid',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaBorough&borname=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		onBeforeLoad:function(param){
			$("#ExaListTab").datagrid("uncheckAll");
			var desc=$("#FindExa").searchbox('getValue'); 
			param = $.extend(param,{borname:desc});
		},
		onSelect:function(){
			if (PageLogicObj.m_LocListTabDataGrid=="") {
				PageLogicObj.m_LocListTabDataGrid=InitLocListTabDataGrid();
			}else{
				PageLogicObj.m_LocListTabDataGrid.datagrid("reload");
			}
		},
		onUncheckAll:function(rows){
			if (PageLogicObj.m_LocListTabDataGrid!="") {
				PageLogicObj.m_LocListTabDataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
		}
	});
	return ExaListTabDataGrid;
}
function FindExaChange(){
	PageLogicObj.m_ExaListTabDataGrid.datagrid("reload");
}
function FindLocChange(){
	PageLogicObj.m_LocListTabDataGrid.datagrid("reload");
}
function InitLocListTabDataGrid(){
	var Columns=[[ 
		{field:'LocId',title:'',checkbox:true},
		{field:'CTDesc',title:'科室',width:180}
    ]]
	var LocListTabDataGrid=$("#LocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'LocId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorDep&QueryName=FindExaLoc&rows=99999",
		onBeforeLoad:function(param){
			$("#LocListTab").datagrid("uncheckAll");
			var desc=$("#FindLoc").searchbox('getValue'); 
			var selrow=PageLogicObj.m_ExaListTabDataGrid.datagrid("getSelected")
			if (selrow) exaId=selrow.rid;
			else  exaId="";
			param = $.extend(param,{ExaId:exaId,desc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var PoweredFlag=data.rows[i].PoweredFlag;
				if (PoweredFlag=="Y") {
					PageLogicObj.m_LocListTabDataGrid.datagrid('selectRow',i);
				}
			}
		}
	});
	return LocListTabDataGrid;
}
function GetSelExaId(){
	var SelRow=PageLogicObj.m_ExaListTabDataGrid.datagrid('getSelections');
	if (SelRow.length==0) return "";
	var ExaId=SelRow[0].rid;
	return ExaId;
}
function MulExaBorDepSave(){
	var ExaId=GetSelExaId();
	if (ExaId=="") {
		$.messager.alert("提示","请选择诊区");
		return false;
	}
	if (PageLogicObj.m_LocListTabDataGrid=="") {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var rows=PageLogicObj.m_LocListTabDataGrid.datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var GridSelectArr=PageLogicObj.m_LocListTabDataGrid.datagrid('getSelections');
	var inPara="",subPara="";
	for (var i=0;i<rows.length;i++){
		var LocId=rows[i].LocId;
		if ($.hisui.indexOfArray(GridSelectArr,"LocId",LocId)>=0) {
			if (inPara == "") inPara = LocId;
			else  inPara = inPara + "!" + LocId;
		}else{
			if (subPara == "") subPara = LocId;
			else  subPara = subPara + "!" + LocId;
		}
	}
	$.m({
	    ClassName:"web.DHCExaBorDep",
	    MethodName:"SaveExaBorDep",
	    ExaId:ExaId,
	    inPara:inPara,
	    subPara:subPara
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
			//PageLogicObj.m_LocListTabDataGrid.datagrid("uncheckAll");
		}
	})
}
