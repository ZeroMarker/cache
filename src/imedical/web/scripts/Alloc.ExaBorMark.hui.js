var PageLogicObj={
	m_ExaBoroughMarkTabDataGrid:"",
	m_ExaListTabDataGrid:"",
	m_LocListTabDataGrid:"",
	m_ResListTabDataGrid:"",
	m_ExaMarkRowId:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	ExaBoroughMarkTabDataGridLoad();
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
				},
				onSelect:function(rec){
					//加载科室列表
					if (rec) {
						LoadExaDept(rec["rid"]);
						var cbox = $HUI.lookup("#BordMark");
						cbox.setValue("");
						cbox.setText("");
					}
				},onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#ExaDept");
						cbox.setValue("");
						cbox.setText("");
						var cbox = $HUI.lookup("#BordMark");
						cbox.setValue("");
						cbox.setText("");
						LoadExaDept("");
					}
				}
		 });
	});
	LoadExaDept("");
	LoadExaMark()
}
function LoadExaDept(borid){
	//科室数据加载，此处必须是同步加载，否则会导致第一次选中行时选择不了数据
	var Data=$.cm({
		ClassName:"web.DHCExaBorough",
		QueryName:"Findyndep",
		dataType:"json",
		id:borid,
		depname:"",
		HospID:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false);
	var cbox = $HUI.combobox("#ExaDept", {
			valueField: 'rid',
			textField: 'name', 
			editable:true,
			data: Data["rows"],
			filter: function(q, row){
				return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onSelect:function(rec){
				//加载号别列表
				if (rec) {
					PageLogicObj.m_ExaMarkRowId="";
					$("#BordMark").lookup('setText',"");
					LoadExaMark(rec["rid"]);
				}
			},onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.lookup("#BordMark");
					cbox.setValue("");
					cbox.setText("");
					PageLogicObj.m_ExaMarkRowId="";
					LoadExaMark("");
				}
			}
	 });
}
function LoadExaMark(deptid){
	//号别数据加载，此处必须是同步加载，否则会导致第一次选中行时选择不了数据
	/*var Data=$.cm({
		ClassName:"web.DHCExaBorough",
		QueryName:"Findloc",
		dataType:"json",
		depid:deptid,
		markname:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#BordMark", {
			valueField: 'RowID',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			filter: function(q, row){
				return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			}
	 });*/
	 $("#BordMark").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowID',
        textField:'Desc',
        //Desc:%String,RowID:%String,code
        columns:[[  
			{field:'Desc',title:'科室',width:250},
			//{field:'code',title:'代码'},
			{field:'RowID',title:'号别RowID'},
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:450,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDepMark',QueryName: 'Findloc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{depid:deptid,markname:desc,HospitalID:$HUI.combogrid('#_HospList').getValue()});
	    },
	    onSelect:function(index, rec){
		    if (rec) {
			    PageLogicObj.m_ExaMarkRowId=rec["RowID"];
			}
		    /*setTimeout(function(){
				if (rec!=undefined){
					$("#BordMark").val(rec["Desc"])
					$("#BordMarkID").val(rec["RowID"])
				}
			});*/
		}
    });
}
function InitEvent(){
	$('#Bfind').click(ExaBoroughMarkTabDataGridLoad);
	$("#BSave").click(MulExaBorMarkSave);
	$("#MulExaBorMarkWin").window({
		onClose:function(){
			ExaBoroughMarkTabDataGridLoad();
		}
	})
}
function Init(){
	//初始化医院
	var hospComp = GenHospComp("DHCDepMark");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageHandle();
		ClearData();
		ExaBoroughMarkTabDataGridLoad();
	}
	PageLogicObj.m_ExaBoroughMarkTabDataGrid=InitExaBoroughRoomTabDataGrid();
}
function InitExaBoroughRoomTabDataGrid(){
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
		text:'号别批量对照',
		id:'i-Alladd',
		iconCls: 'icon-add',
		handler: function() { 
			$("#FindExa,#FindLoc,#FindRes").searchbox('setValue',"");
			$('#MulExaBorMarkWin').window('open');
			if (PageLogicObj.m_ExaListTabDataGrid==""){
				PageLogicObj.m_ExaListTabDataGrid=InitExaListTabDataGrid();
			}else{
				PageLogicObj.m_ExaListTabDataGrid.datagrid('options').url=$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaBorough&borname=&HospId="+$HUI.combogrid('#_HospList').getValue();
				PageLogicObj.m_ExaListTabDataGrid.datagrid("reload");
			}
		}
	}/*,'-',{
        text: '挂号授权',
        iconCls: 'icon-batch-cfg',
        handler: function() { RegPowerClickHandle();}
    },{
        text: '排班授权',
        iconCls: 'icon-batch-cfg',
        handler: function() { SchedulePowerClickHandle();}
    }*/];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tborname',title:'分诊区',width:200},
		{field:'Tdepname',title:'科室',width:200},
		{field:'Tmarkname',title:'号别',width:150},
		{field:'TCheckin',title:'是否报到',width:70},
		//{field:'Tst',title:'状态',width:50},
		{field:'Tsi',title:'对照是否有效',width:100,
			styler: function(value,row,index){
 				if (value=="是"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
		   }
		},
		{field:'Tborid',title:'',hidden:true},
		{field:'Tdepid',title:'',hidden:true},
		{field:'Tmarkid',title:'',hidden:true}
    ]]
	var ExaBoroughMarkTabDataGrid=$("#ExaBoroughMarkTab").datagrid({
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
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			PageLogicObj.m_ExaMarkRowId="";
			$("#ExaBord,#ExaDept").combobox("select","");
			$("#BordMark").lookup('setText',"");
			$("#csi,#Checkin").checkbox("setValue",false); //#cst,
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	});
	return ExaBoroughMarkTabDataGrid;
}
function SetSelRowData(row){
	var cbox=$HUI.combobox("#ExaBord"); 
	cbox.select(row["Tborid"]);
	var cbox=$HUI.combobox("#ExaDept"); 
	cbox.select(row["Tdepid"]);
	var cbox=$HUI.lookup("#BordMark")
	cbox.setText(row["Tmarkname"]);
	PageLogicObj.m_ExaMarkRowId=row["Tmarkid"];
	var o=$HUI.checkbox("#Checkin");
	if (row["TCheckin"]=="Y"){
		o.setValue(true);
	}else{
		o.setValue(false);
	}
	/*var o=$HUI.checkbox("#cst");
	if (row["Tst"]=="空值"){
		o.setValue(true);
	}else{
		o.setValue(false);
	}*/
	var o=$HUI.checkbox("#csi");
	if (row["Tsi"]=="是"){
		o.setValue(true);
	}else{
		o.setValue(false);
	}
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#ExaBord"); 
	var borid=cbox.getValue();
	var cbox=$HUI.combobox("#ExaDept"); 
	var depid=cbox.getValue();
	if ($HUI.lookup("#BordMark").getText()=="") PageLogicObj.m_ExaMarkRowId="";
	var markid=PageLogicObj.m_ExaMarkRowId;
	var o=$HUI.checkbox("#csi");
	if (o.getValue()){
		var si="Y";
	}else{
		var si="N";
	}
	/*var o=$HUI.checkbox("#cst");
	if (o.getValue()){
		var st="2";
	}else{
		var st="1";
	}*/
	var st=1;
	var o=$HUI.checkbox("#Checkin");
	if (o.getValue()){
		var Checkin="Y";
	}else{
		var Checkin="N";
	}
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"insertDepMark",
		itmjs:"",
		itmjsex:"",
		RoomDr:borid,
		CompDr:depid,
		MarkDr:markid,
		st:st,
		si:si,
		Checkin:Checkin,
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '增加成功!',type:'success',timeout: 1000});
			ClearData();
			PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('uncheckAll');
			ExaBoroughMarkTabDataGridLoad();
		}else{
			$.messager.alert("提示","增加失败!"+rtn);
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的行!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"delDepMark",
		itmjs:"",
		itmjsex:"",
		rid:row["Tid"]
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
			ClearData();
			PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('uncheckAll');
			ExaBoroughMarkTabDataGridLoad();
		}else{
			$.messager.alert("提示","删除失败!"+rtn);
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要更新的行!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#ExaBord"); 
	var borid=cbox.getValue();
	var cbox=$HUI.combobox("#ExaDept"); 
	var depid=cbox.getValue();
	//var markid=$HUI.lookup("#BordMark").getValue()
	if ($HUI.lookup("#BordMark").getText()=="") PageLogicObj.m_ExaMarkRowId="";
	var markid=PageLogicObj.m_ExaMarkRowId;
	var o=$HUI.checkbox("#csi");
	if (o.getValue()){
		var si="Y";
	}else{
		var si="N";
	}
	/*var o=$HUI.checkbox("#cst");
	if (o.getValue()){
		var st="2";
	}else{
		var st="1";
	}*/
	var st=1;
	var o=$HUI.checkbox("#Checkin");
	if (o.getValue()){
		var Checkin="Y";
	}else{
		var Checkin="N";
	}
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"updateDepMark",
		itmjs:"",
		itmjsex:"",
		RoomDr:borid,
		CompDr:depid,
		MarkDr:markid,
		st:st,
		si:si,
		rowid:row["Tid"],
		Checkin:Checkin,
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '更新成功!',type:'success',timeout: 1000});
			ClearData();
			PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('uncheckAll');
			ExaBoroughMarkTabDataGridLoad();
		}else{
			$.messager.alert("提示","更新失败!"+rtn);
			return false;
		}
	});
	
}
function ClearData(){
	var cbox=$HUI.combobox("#ExaBord"); 
	cbox.select("");
	var cbox=$HUI.combobox("#ExaDept"); 
	cbox.select("");
	PageLogicObj.m_ExaMarkRowId="";
	var cbox=$HUI.lookup("#BordMark"); 
	cbox.setText("");
	/*var o=$HUI.checkbox("#cst"); 
	o.setValue(false);*/
	var o=$HUI.checkbox("#csi"); 
	o.setValue(true);
	var o=$HUI.checkbox("#Checkin"); 
	o.setValue(false);
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
	var cbox=$HUI.combobox("#ExaDept"); 
	var deptdr=cbox.getValue();
	var deptdr=CheckComboxSelData("ExaDept",deptdr);
	if (deptdr==""){
		$.messager.alert("提示","请选择科室!","info",function(){
			$('#ExaDept').next('span').find('input').focus();
		});
		return false;
	}
	if ($HUI.lookup("#BordMark").getText()=="") PageLogicObj.m_ExaMarkRowId="";
	var markdr=PageLogicObj.m_ExaMarkRowId;
	if (markdr==""){
		$.messager.alert("提示","请选择号别!","info",function(){
			$('#BordMark').next('span').find('input').focus();
		});
		return false;
	}
	return true;
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="BordMark"){
			var CombValue=Data[i].RowID;
		 	var CombDesc=Data[i].Desc;
	     }else{
		    var CombValue=Data[i].rid
		 	var CombDesc=Data[i].name
		 }
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function ExaBoroughMarkTabDataGridLoad(){
	var BordBorDr=$("#ExaBord").combobox("getValue");
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var LocID=$HUI.combobox("#ExaDept").getValue()
	//var MarkID=$HUI.lookup("#BordMark").getValue()
	if ($HUI.lookup("#BordMark").getText()=="") PageLogicObj.m_ExaMarkRowId="";
	var MarkID=PageLogicObj.m_ExaMarkRowId;
	var si=""; //$("#csi").checkbox('getValue')?"Y":"";
	var st=""; //$("#cst").checkbox('getValue')?"2":"";
	var Checkin=""; //$("#Checkin").checkbox('getValue')?"Y":"";
	$.q({
	    ClassName : "web.DHCDepMark",
	    QueryName : "QueryDepMark",
	    roomid:BordBorDr,
	    HospId:HospID,LocID:LocID,MarkID:MarkID,
	    SI:si,ST:st,Check:Checkin,
	    Pagerows:PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
/*function RegPowerClickHandle(){
	var LocId="",MarkId="";
	var row=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getSelected');
	if (row) {
		var LocId=row.Tdepid;
		var MarkId=row.Tmarkid;
	}
	websys_showModal({
		url:"opadm.dhcopregpowerconfig.hui.csp?LocId="+LocId+"&MarkId="+MarkId,
		title:'挂号授权',
		width:screen.availWidth-300,height:screen.availHeight-200,
	});
}
function SchedulePowerClickHandle(){
	var LocId="",MarkId="";
	var row=PageLogicObj.m_ExaBoroughMarkTabDataGrid.datagrid('getSelected');
	if (row) {
		var LocId=row.Tdepid;
		var MarkId=row.Tmarkid;
	}
	websys_showModal({
		url:"opadm.dhcopschedulepowerconfig.hui.csp?LocId="+LocId+"&MarkId="+MarkId,
		title:'排班授权',
		width:screen.availWidth-300,height:screen.availHeight-200,
	});
}*/
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
			$("#ExaListTab").datagrid("unselectAll");
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
				PageLogicObj.m_LocListTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
			}
			if (PageLogicObj.m_ResListTabDataGrid!=""){
				PageLogicObj.m_ResListTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
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
function FindResChange(){
	PageLogicObj.m_ResListTabDataGrid.datagrid("reload");
}
var UnCheckAllFlag=0;
function InitLocListTabDataGrid(){
	var Columns=[[ 
		{field:'rid',title:'',checkbox:true},
		{field:'name',title:'科室',width:180}
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
		idField:'rid',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=Findyndep&rows=99999",
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_LocListTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_LocListTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_LocListTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		},
		onBeforeLoad:function(param){
			$("#LocListTab").datagrid("uncheckAll");
			var desc=$("#FindLoc").searchbox('getValue'); 
			var selrow=PageLogicObj.m_ExaListTabDataGrid.datagrid("getSelected")
			if (selrow) exaId=selrow.rid;
			else  exaId="";
			param = $.extend(param,{id:exaId,depname:desc,HospID:$HUI.combogrid('#_HospList').getValue()});
		},
		onSelect:function(){
			if (PageLogicObj.m_ResListTabDataGrid=="") {
				PageLogicObj.m_ResListTabDataGrid=InitResListTabDataGrid();
			}else{
				PageLogicObj.m_ResListTabDataGrid.datagrid("reload");
			}
		},
		onUnselect:function(){
			if ((PageLogicObj.m_ResListTabDataGrid)&&(UnCheckAllFlag==0)) PageLogicObj.m_ResListTabDataGrid.datagrid("reload");
		},onUncheckAll:function(rows){
			setTimeout(function() { 
	        	if (PageLogicObj.m_ResListTabDataGrid!=""){
					PageLogicObj.m_ResListTabDataGrid.datagrid("unselectAll").datagrid('loadData', {"total":0,"rows":[]});
				}
	        });
		},
		onCheckAll:function(){
			if (PageLogicObj.m_ResListTabDataGrid=="") {
				PageLogicObj.m_ResListTabDataGrid=InitResListTabDataGrid();
			}else{
				PageLogicObj.m_ResListTabDataGrid.datagrid("reload");
			}
		},
		onLoadSuccess:function(){
			$("#LocListTab").datagrid("uncheckAll");
		}
	});
	return LocListTabDataGrid;
}
function InitResListTabDataGrid(){
	var Columns=[[ 
		{field:'RowID',title:'',checkbox:true},
		{field:'Desc',title:'医生号别',width:180}		
    ]]
	var ResListTabDataGrid=$("#ResListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'ResRowId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindExaDoc&rows=99999",
		onBeforeLoad:function(param){
			$("#ResListTab").datagrid("uncheckAll");
			var desc=$("#FindRes").searchbox('getValue'); 
			param = $.extend(param,{ExaId:GetSelExaId(),depstr:GetSelDeptStr(),docname:desc});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var PoweredFlag=data.rows[i].PoweredFlag;
				if (PoweredFlag=="Y") {
					PageLogicObj.m_ResListTabDataGrid.datagrid('selectRow',i);
				}
			}
		}
	});
	return ResListTabDataGrid;
}
function GetSelDeptStr(){
	var depstr=""; 
	if (PageLogicObj.m_LocListTabDataGrid=="") return "";
	var locRows=PageLogicObj.m_LocListTabDataGrid.datagrid('getSelections');
	for (var i=0;i<locRows.length;i++){
		if (depstr=="") depstr=locRows[i].rid;
		else  depstr=depstr+"^"+locRows[i].rid;
	}
	return depstr;
}
function GetSelExaId(){
	var SelRow=PageLogicObj.m_ExaListTabDataGrid.datagrid('getSelections');
	if (SelRow.length==0) return "";
	var ExaId=SelRow[0].rid;
	return ExaId;
}
function MulExaBorMarkSave(){
	var ExaId=GetSelExaId();
	if (ExaId=="") {
		$.messager.alert("提示","请选择诊区");
		return false;
	}
	if (PageLogicObj.m_ResListTabDataGrid=="") {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var rows=PageLogicObj.m_ResListTabDataGrid.datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var GridSelectArr=PageLogicObj.m_ResListTabDataGrid.datagrid('getSelections');
	var inPara="",subPara="";
	for (var i=0;i<rows.length;i++){
		var ResRowId=rows[i].ResRowId;
		if ($.hisui.indexOfArray(GridSelectArr,"ResRowId",ResRowId)>=0) {
			if (inPara == "") inPara = ResRowId;
			else  inPara = inPara + "!" + ResRowId;
		}else{
			if (subPara == "") subPara = ResRowId;
			else  subPara = subPara + "!" + ResRowId;
		}
	}
	$.m({
	    ClassName:"web.DHCExaBorough",
	    MethodName:"SaveExaBorMark",
	    ExaId:ExaId,
	    inPara:inPara,
	    subPara:subPara
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
			PageLogicObj.m_LocListTabDataGrid.datagrid("uncheckAll");
		}
	})
}
