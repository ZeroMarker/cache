var PageLogicObj={
	m_LongStopListTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
});
function InitEvent(){
	$("#BFind").click(LongStopListTabDataGridLoad);
	$("#BStop").click(StopClick);
}
function PageHandle(){
	//LoadLoc();
	LoadReason();
}
function Init(){
	//初始化医院
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		$("#Loc").combobox('select','')
		LoadLoc(HospID);
		$("#Doc").combobox('select','').combobox('loadData',[{}])
		LongStopListTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		var HospID=$HUI.combogrid('#_HospUserList').getValue();
		LoadLoc(HospID);
		$("#Doc").combobox('select','').combobox('loadData',[])
		PageLogicObj.m_LongStopListTabDataGrid=InitLongStopListTabDataGrid();
		LongStopListTabDataGridLoad();
	}
}
function InitLongStopListTabDataGrid(){
	var toolbar=[{
		text:"撤销停诊",
		iconCls: 'icon-cancel-order',
		handler: function(){CancelStopClick("")}
	}]
	var Columns=[[ 
		{field:'TLoc',title:'科室',width:400},
		{field:'TDoc',title:'医生',width:400},
		{field:'TStopReason',title:'停诊原因',width:400},
		{field:'TStartDate',title:'开始日期',width:400},
		{field:'TEndDate',title:'结束日期',width:400},
		{field:'RSVP',title:'执行方式',width:400},
		{field:'UserName',title:'停诊人',width:400}
    ]]
	var LongStopListTabDataGrid=$("#LongStopListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'NARowid',
		columns :Columns,
		toolbar:toolbar,
		onSelect:function(index, row){
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_LongStopListTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_LongStopListTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_LongStopListTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	});
	return LongStopListTabDataGrid;
}

function LongStopListTabDataGridLoad(){
	var Loc=$('#Loc').combobox('getValue');
	if (Loc==undefined) Loc="";
	var Doc=$('#Doc').combobox('getValue');
	if (Doc==undefined) Doc="";
	var Reason=$('#Reason').combobox('getValue');
	if (Reason==undefined) Reason="";
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.q({
	    ClassName : "web.DHCOPRegHolidayAdjust",
	    QueryName : "FindStopResult",
	    StartDate:$("#StartDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'),
	    Loc:Loc,Doc:Doc,paraReasonDr:Reason,HospID:HospID,
	    Pagerows:PageLogicObj.m_LongStopListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_LongStopListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}
function StopClick(){
	var StartDate=$('#StartDate').datebox('getValue');
	if(StartDate==""){
		$.messager.alert("提示","开始日期不能为空!","info",function(){
			$('#StartDate').next('span').find('input').focus();
		});
	    return false;
	}
	var EndDate=$('#EndDate').datebox('getValue');
	if(EndDate==""){
		$.messager.alert("提示","结束日期不能为空!","info",function(){
			$('#EndDate').next('span').find('input').focus();
		});
	    return false;
	}
	var ComDateFlag=CompareDate(StartDate,EndDate)
	if (!ComDateFlag){
		  $.messager.alert("提示","请选择有效的日期时段!")
		  return false;
	}
	var Loc=$('#Loc').combobox('getValue');
	if (Loc==undefined) Loc="";
	if(Loc==""){
		$.messager.alert("提示","科室不能为空!","info",function(){
			$('#Loc').next('span').find('input').focus();
		});
	    return false;
	}
	var Doc=$('#Doc').combobox('getValue');
	if (Doc==undefined) Doc="";
	if(Doc==""){
		$.messager.alert("提示","医生不能为空!","info",function(){
			$('#Doc').next('span').find('input').focus();
		});
	    return false;
	} 
	//判断是否有生成排班或预约记录
	var retValue=$.cm({
	    ClassName : "web.DHCOPRegHolidayAdjust",
	    MethodName : "CheckResData",
	    StartDate:StartDate, EndDate:EndDate, DepId:Loc, DocId:Doc,
	    dataType:"text"
	},false)
	var StrArr=retValue.split("^");
	if((StrArr[0]=="-200")&&(StrArr[1]=="")){
		$.messager.confirm("确认对话框", "此医生在此范围有排班记录,是否继续?", function (r) {
			if (r) {
				Stop();
			}
		});
		return;
	}
	else if((StrArr[0]=="")&&(StrArr[1]=="-201")){
		$.messager.confirm("确认对话框", "此医生已经有预约记录,是否继续?", function (r) {
			if (r) {
				Stop();
			}
		});
		return;
	}
	else if((StrArr[0]=="-200")&&(StrArr[1]=="-201")){

		$.messager.confirm("确认对话框", "此医生在此范围有排班记录,并且已经有预约记录,是否继续?", function (r) {
			if (r) {
				Stop();
			}
		});
		return;
	}
	Stop();
	function Stop(){
		var Reason=$('#Reason').combobox('getValue');
		if (Reason==undefined) Reason="";
		var Notes="";
		var UserID=session['LOGON.USERID']; 
	 	var ret=$.cm({
	    	ClassName : "web.DHCOPRegHolidayAdjust",
	    	MethodName : "BatchStop",
	    	StartDate:StartDate, EndDate:EndDate, DepId:Loc, DocId:Doc,
	    	Reason:Reason, Notes:Notes, UserID:UserID, StopMethod:"S",
	    	GroupId:session['LOGON.GROUPID'],
	    	dataType:"text"
		},false)
		var retArr=ret.split("^");
	  	if(retArr[0]=="0"){
		  	if (retArr[1]>0) {
			  	var IsAudit=tkMakeServerCall("web.DHCOPRegHolidayAdjust","CheckBatchStopRequestFlag",Loc,"S",session['LOGON.GROUPID'],session['LOGON.HOSPID']);
			  	if (IsAudit ==1 ){
				  	$.messager.popover({msg: $('#Loc').combobox('getText')+" "+$('#Doc').combobox('getText')+ ' 长时段停诊申请成功！请等待相关人员审核后生效！',type:'info',timeout: 2000,showType: 'show'});
				}else{
					$.messager.popover({msg: '停诊操作成功!',type:'info',timeout: 2000,showType: 'show'});
				}
			}else{
				$.messager.popover({msg: '停诊操作成功!',type:'info',timeout: 2000,showType: 'show'});
			}
		  	$("#StartDate,#EndDate").datebox('setValue','');
		  	$("#Loc,#Doc,#Reason").combobox('select','');
		  	LongStopListTabDataGridLoad();
		}else if(ret=="-202"){
			$.messager.alert("提示","插入表失败!");
		}else if(ret=="Repeat"){
			$.messager.alert("提示","该记录已存在或此日期内不存在有效的排班记录或存在待审核排班记录!");
		}else {
			$.messager.alert("提示","操作失败!");
		}
	}
	
}
function CancelStopClick(){
	var row=PageLogicObj.m_LongStopListTabDataGrid.datagrid("getSelected");
	if (!row){
		$.messager.alert("提示","请选择行!");
		return false;
	}
    var NARowId=row['NARowid'];
    var NAFlag=row['NAFlag'];
    if (NAFlag=="N"){
	    $.messager.alert("提示","该记录已经为撤销状态不需撤销!");
	    return false;
	}
	var ret=$.cm({
    	ClassName : "web.DHCOPRegHolidayAdjust",
    	MethodName : "UpdateNotAvail",
    	Rowid:NARowId, UserID:session['LOGON.USERID'], StopMethod:"",	//StopMethod为空，在后端查找应该回转的状态
    	GroupId:session['LOGON.GROUPID'],
    	dataType:"text"
	},false)
	var retArr=ret.split("^");
    if(retArr[0]=="0"){
	    if (retArr[1]>0) {
		    var IsAudit=tkMakeServerCall("web.DHCOPRegHolidayAdjust","CheckBatchStopRequestFlag",row.DepID,"N",session['LOGON.GROUPID'],session['LOGON.HOSPID']);
		  	if (IsAudit ==1 ){
			  	$.messager.popover({msg: row.TLoc+" "+row.TDoc+' 撤销长时段停诊申请成功！请等待相关人员审核后生效！',type:'info',timeout: 2000,showType: 'show'});
			}else{
		    	$.messager.popover({msg: '撤销长时段停诊成功！',type:'info',timeout: 2000,showType: 'show'});
		    }
		}else{
			$.messager.popover({msg: '撤销长时段停诊成功！',type:'info',timeout: 2000,showType: 'show'});
		}
	    LongStopListTabDataGridLoad();
	    return false;
	}else if(ret=="-203"){
		$.messager.alert("提示","请选择行!");
	}else if(ret=="Repeat"){
		$.messager.alert("提示","该记录已经为撤销状态或存在待审核排班记录,不能撤销!");
	}else{
		$.messager.alert("提示","操作失败!");
	}
}
function LoadLoc(hospitalid){
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindLoc",
		Loc:"",
		UserID:session['LOGON.USERID'],
		HospitalDr:hospitalid,
		rows:100000
	},function(Data){
		var cbox = $HUI.combobox("#Loc", {
				valueField: 'Hidden',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Alias"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(rec){
					if (rec){
						LoadDoc(rec['Hidden']);
					}
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						$("#Doc").combobox('select','');
						$("#Doc").combobox('loadData',[]);
					}
				}
		 });
	});
}
function LoadDoc(DepRowId){
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindResDoc",
		DepID:DepRowId,
		HospID:$HUI.combogrid('#_HospUserList').getValue(),
		rows:100000
	},function(Data){
		var cbox = $HUI.combobox("#Doc", {
				valueField: 'Hidden1',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Hidden2"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(){
				}
		 });
	});
}
function LoadReason(){
	$.cm({
		ClassName:"web.DHCRBCReasonNotAvail",
		MethodName:"GetStopReasonStr",
		dataType:"text"
	},function(Data){
		var arr=new Array();
		for (var i=0;i<Data.split("^").length;i++){
			var id=Data.split("^")[i].split(String.fromCharCode(1))[0];
			var text=Data.split("^")[i].split(String.fromCharCode(1))[1];
			arr.push({"id":id,"text":text});
		}
		var cbox = $HUI.combobox("#Reason", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				data: arr
		 });
	});
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
