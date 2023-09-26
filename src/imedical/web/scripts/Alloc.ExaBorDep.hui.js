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
	//��ʼ������
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
    //��ʼ������
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
	
	//��ʼ��ҽԺ
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
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    },{
		text:'������������',
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
		{field:'TBordBordesc',title:'������',width:300},
		{field:'TBordDepdesc',title:'����',width:300},
		{field:'TBordMemo',title:'��ע',width:300},
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
			$.messager.alert("��ʾ","���ӳɹ�!");
			ClearData();
			PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('uncheckAll');
			ExaBoroughDepTabDataGridLoad();
		}else{
			$.messager.alert("��ʾ","����ʧ��!��¼�ظ�!");
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ������!");
		return false;
	}
	var rtn=$.cm({
		ClassName:"web.DHCExaBorDep",
		MethodName:"CheckDepMark",
		Bordr:row["TBordBorDr"], Deptdr:row["TBordDepDr"]
	},false);
	if (rtn=="1"){
		$.messager.confirm('ȷ�϶Ի���', row["TBordBordesc"]+"��"+row["TBordDepdesc"]+'�Ķ��չ�ϵ�ڷ������ű���ս�������ά������,���������ɾ���������ű��������,�Ƿ����?', function(r){
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
				$.messager.alert("��ʾ","ɾ���ɹ�!");
				ClearData();
				PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('uncheckAll');
				ExaBoroughDepTabDataGridLoad();
			}else{
				$.messager.alert("��ʾ","ɾ��ʧ��!"+rtn);
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
		$.messager.alert("��ʾ","��ѡ����Ҫ���µ���!");
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
			$.messager.confirm('ȷ�϶Ի���', row["TBordBordesc"]+"��"+row["TBordDepdesc"]+'�Ķ��չ�ϵ�ڷ������ű���ս�������ά������,���������ɾ���������ű��������,�Ƿ����?', function(r){
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
				$.messager.popover({msg: '���³ɹ�!',type:'info',timeout: 2000,showType: 'show'});
				ClearData();
				PageLogicObj.m_ExaBoroughDepTabDataGrid.datagrid('uncheckAll');
				ExaBoroughDepTabDataGridLoad();
			}else{
				$.messager.alert("��ʾ","����ʧ��!��¼�ظ�!");
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
		$.messager.alert("��ʾ","��ѡ�������!","info",function(){
			$('#ExaBord').next('span').find('input').focus();
		});
		return false;
	}
	var cbox=$HUI.combobox("#BordDep"); 
	var BordDepDr=cbox.getValue();
	var BordDepDr=CheckComboxSelData("BordDep",BordDepDr);
	if (BordDepDr==""){
		$.messager.alert("��ʾ","��ѡ�����!","info",function(){
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
		{field:'name',title:'������',width:180},
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
		{field:'CTDesc',title:'����',width:180}
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
		$.messager.alert("��ʾ","��ѡ������");
		return false;
	}
	if (PageLogicObj.m_LocListTabDataGrid=="") {
		$.messager.alert("��ʾ","û����Ҫ���������!");
		return false;
	}
	var rows=PageLogicObj.m_LocListTabDataGrid.datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("��ʾ","û����Ҫ���������!");
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
			$.messager.popover({msg:'����ɹ�',type:'success',timeout:1000});
			//PageLogicObj.m_LocListTabDataGrid.datagrid("uncheckAll");
		}
	})
}
