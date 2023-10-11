var PageLogicObj={
	m_RBCClinicGroupTabDataGrid:"",
	m_ReHospitalDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		$("#code,#name").val("");
		$("#StartDate,#EndDate").datebox('setValue','');
		RBCClinicGroupTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		RBCClinicGroupTabDataGridLoad();
	}
});
function Init(){
	PageLogicObj.m_RBCClinicGroupTabDataGrid=InitRBCClinicGroupTabDataGrid();
}
function InitRBCClinicGroupTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }, {
        text: '医院授权',
        iconCls: 'icon-house',
        handler: function() { ReHospitalHandle();}
    }, {
        text: '挂号限制条件维护',
        iconCls: 'icon-edit',
        handler: function() { CliniclimitHandle();}
    }/*,{
        text: '翻译',
        iconCls: 'icon-translate-word',
        handler: function() {
         		var SelectedRow = PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
				if (!SelectedRow){
				$.messager.alert("提示","请选择需要翻译的行!","info");
				return false;
				}
				CreatTranLate("User.RBCClinicGroup","CLGRPDesc",SelectedRow["CLGRPDesc"])
				        }
     }*/
	 ];
    var Columns=[[ 
    	{field:'ID',hidden:true,title:''},
		{field:'CLGRPCode',title:'代码',width:300},
		{field:'CLGRPDesc',title:'名称',width:300},
		{field:'CLGRPDateFrom',title:'开始日期',width:300},
		{field:'CLGRPDateTo',title:'结束日期',width:300}
    ]];
    var RBCClinicGroupTabDataGrid=$("#RBCClinicGroupTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true, 
		idField:'ID', 
		pageSize: 20,
		pageList : [20,100,200],
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			clear();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return RBCClinicGroupTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["CLGRPCode"]);
	$("#name").val(row["CLGRPDesc"]); 
	$HUI.datebox("#StartDate").setValue(row["CLGRPDateFrom"]);
	$HUI.datebox("#EndDate").setValue(row["CLGRPDateTo"]);
}
function InitEvent(){
	$('#Bfind').click(RBCClinicGroupTabDataGridLoad);
	$('#SaveLimit').click(SaveLimitHandler);
}
function RBCClinicGroupTabDataGridLoad(){
	var CLGRPCode=$("#code").val();
	var CLGRPDesc=$("#name").val();
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.q({
	    ClassName : "web.DHCRBCClinicGroup",
	    QueryName : "GetAllClinicGroupNew",
	    CLGRPCode:CLGRPCode,
	    CLGRPDesc:CLGRPDesc,
	    HospId:HospID,
		AllFlag:1,
	    Pagerows:PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('unselectAll').datagrid('loadData',GridData);
	});
}
function AddClickHandle(){
	if(!CheckData()) return false;
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.cm({
		ClassName:"web.DHCRBCClinicGroup",
		MethodName:"InsertClinicGroup",
		code:Code,
		name:Name,
		begindate:StDate,
		enddate:EndDate,
		HospID:HospID
	},function(rtn){
		if(rtn=="1"){
			$.messager.alert("提示","增加成功!")
			clear()
			RBCClinicGroupTabDataGridLoad()
		}else if(rtn=="2"){
			$.messager.alert("提示","专业组代码重复!")
			return false
		}else{
			$.messager.alert("提示","增加失败!")
			return false
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	if(!CheckData()) return false;
	var ID=row["ID"]
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	var EndDate=$HUI.datebox("#EndDate").getValue()
	$.cm({
		ClassName:"web.DHCRBCClinicGroup",
		MethodName:"UpdateClinicGroup",
		id:ID,
		code:Code,
		name:Name,
		begindate:StDate,
		enddate:EndDate
	},function(rtn){
		if(rtn=="1"){
			$.messager.alert("提示","更新成功!")
			PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid("getRowIndex",row),
				row: {
					CLGRPCode:Code,
					CLGRPDesc:Name,
					CLGRPDateFrom:StDate,
					CLGRPDateTo:EndDate
				}
			});
		}else if(rtn=="2"){
			$.messager.alert("提示","专业组代码重复!")
			return false
		}else{
			$.messager.alert("提示","更新失败!")
			return false
		}
	});
	
}
function CheckData(){
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	if(Code==""){$.messager.alert("提示","请输入代码!");return false;}
	if(Name==""){$.messager.alert("提示","请输入名称!");return false;}
	if(StDate==""){$.messager.alert("提示","请输入开始日期!");return false;}
	return true;
}
function clear(){
	$("#code").val("")
	$("#name").val("")
	$HUI.datebox("#StartDate").setValue("")
	$HUI.datebox("#EndDate").setValue("")
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function ReHospitalHandle(){
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	GenHospWin("RBC_ClinicGroup",row.ID,function(){
	});
	/*$("#ReHospital-dialog").dialog("open");
	$.cm({
			ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
			QueryName:"GetHos",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#Hosp", {
				editable:false,
				valueField: 'HOSPRowId',
				textField: 'HOSPDesc', 
				data: GridData["rows"],
				onLoadSuccess:function(){
					$("#Hosp").combobox('select','');
				}
			 });
	});
	PageLogicObj.m_ReHospitalDataGrid=ReHospitalDataGrid();
	LoadReHospitalDataGrid();*/
}
function ReHospitalDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {ReHospitaladdClickHandle();}
    }, {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {ReHospitaldelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:'Rowid'},
		{field:'HospID',hidden:true,title:'HospID'},
		{field:'HospDesc',title:'医院',width:100}
    ]]
	var ReHospitalDataGrid=$("#ReHospitalTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'Rowid',
		columns :Columns,
		toolbar:toobar,
		onClickCell:function(rowIndex, field, value){
			},
		onCheck:function(index, row){
		},
		onUnselect:function(index, row){
		},
		onBeforeSelect:function(index, row){

		},onLoadSuccess:function(data){
		}
	}); 
	return ReHospitalDataGrid;
}
function LoadReHospitalDataGrid(){
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["ID"]
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "FindHopital",
	    BDPMPHTableName:"RBC_ClinicGroup",
	    BDPMPHDataReference:ID,
	    Pagerows:PageLogicObj.m_ReHospitalDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ReHospitalDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	}
function ReHospitaladdClickHandle(){
	var HospID=$("#Hosp").combobox("getValue")
	if (HospID==""){
		$.messager.alert("提示","请选择医院","info");
		return false;
		}
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["ID"]
	$.cm({
		ClassName:"DHCDoc.Common.Hospital",
		MethodName:"SaveHOSP",
		BDPMPHTableName:"RBC_ClinicGroup",
		BDPMPHDataReference:ID,
		BDPMPHHospital:HospID,
		dataType:"text",
	},function(data){
		if (data=="1"){
			$.messager.alert("提示","增加重复","info");
		}else{
		$.messager.alert("提示",data.split("^")[1],"info");
		LoadReHospitalDataGrid();}
	})
	}
function ReHospitaldelectClickHandle(){
	var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
	if (SelectedRow==null){
		$.messager.alert("提示","请选择一行","info");
		return false;
	}
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["ID"]
	$.cm({
		ClassName:"DHCDoc.Common.Hospital",
		MethodName:"DeleteHospital",
		BDPMPHTableName:"RBC_ClinicGroup",
		BDPMPHDataReference:ID,
		BDPMPHHospital:SelectedRow.HospID,
		dataType:"text",
	},function(data){
			$.messager.alert("提示","删除成功","info");
			LoadReHospitalDataGrid();
	})
	
	}
function CliniclimitHandle(){
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["ID"]
	LoadSex();
	$("#Cliniclimit-dialog").dialog("open");
	$.cm({
		ClassName:"web.DHCRBCClinicGroup",
		MethodName:"ShowLimit",
		HospId:$HUI.combogrid('#_HospUserList').getValue(),
		ClinicGroupID:ID,
		dataType:"text"
	},function(ret){
		var rtnArr=ret.split(String.fromCharCode(1))
		for (i=0;i<rtnArr[0].split(",").length;i++){
				var sbox = $HUI.combobox("#NotSex");
				if (rtnArr[0].split(",")[i]!="")  sbox.select(rtnArr[0].split(",")[i]);
			}
		$("#SamllAge").val(rtnArr[1])
		$("#BigAge").val(rtnArr[2])
	})
	}
function LoadSex(){
	$.cm({
		ClassName:"web.DHCRBCClinicGroup",
		MethodName:"ReadSex",
		JSFunName:"GetSexToHUIJson",
		ListName:"",
		HospId:$HUI.combogrid('#_HospUserList').getValue(),
		dataType:"text"
	},function(ret){
		//alert(ret)
		var cbox = $HUI.combobox("#NotSex", {
			valueField: 'id',
			textField: 'text', 
			blurValidValue:true,
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			data: JSON.parse(ret)
		})
	})
	}
function SaveLimitHandler(){
	
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var ID=row["ID"]
	var NotSex=$("#NotSex").combobox("getValues")
	var AgeSamll=$("#SamllAge").numberbox('getValue');
	var AgeBig=$("#BigAge").numberbox('getValue');
	if ((AgeSamll !="")&&(AgeBig !="")&&(+AgeBig < +AgeSamll)) {
		$.messager.alert("提示","开始年龄不能大于结束年龄!","info",function(){
			$("#AgeSamll").focus();
		});
		return;
	}
	if ((isNaN(AgeSamll))||(AgeSamll <0)) {
		$.messager.alert("提示","开始年龄只能是大于等于0的数字!","info",function(){
			$("#AgeSamll").focus();
		});
		return;
	}
	if ((isNaN(AgeBig))||(AgeBig <0)) {
		$.messager.alert("提示","结束年龄只能是大于等于0的数字!","info",function(){
			$("#AgeBig").focus();
		});
		return;
	}
	var Coninfo="NotSex"+"!"+NotSex+"^"+"SamllAge"+"!"+AgeSamll+"^"+"BigAge"+"!"+AgeBig
	$.cm({
		ClassName:"web.DHCRBCClinicGroup",
		MethodName:"SaveLimit",
		HospId:$HUI.combogrid('#_HospUserList').getValue(),
		ClinicGroupID:ID,
		Coninfo:Coninfo,
		dataType:"text"
	},function(ret){
		$.messager.alert("提示","保存成功！")
		$("#Cliniclimit-dialog").dialog("close");
	})
	}
