var PageLogicObj={
	m_tabAppQtyListDataGrid:"",
	m_ComboJsonCSP:'./dhcdoc.cure.query.combo.easyui.csp',
}

$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function Init(){
	$("#StartDate").datebox("setValue",ServerObj.StartDate); 
	$("#EndDate").datebox("setValue",ServerObj.EndDate); 
	PageLogicObj.m_tabAppQtyListDataGrid=InittabAppQtyList();
	}
function InitEvent(){
	//InitSingleCombo('LocArea','RowId','Desc','','',"");
	//InitSingleCombo('ClinicGroup','CLGRPRowId','CLGRPDesc','','',"",true);
	$("#Find").click(function(){
		PageLogicObj.m_tabAppQtyListDataGrid.datagrid('unselectAll');
		//CopyMulitTabDataGridLoad();
		PageLogicObj.m_tabAppQtyListDataGrid.datagrid("load");
	})
	$("#CopyAll").click(function(){
		CopyAllWinOpen()
	})
	/*$("#Copy_LocArea").click(function (){
		CopyMulitTabClickhanldler("LocArea")
	})
	$("#Copy_StartTime").click(function (){
		CopyMulitTabClickhanldler("StartTime")
	})
	$("#Copy_EndTime").click(function (){
		CopyMulitTabClickhanldler("EndTime")
	})
	$("#Copy_ClinicGroup").click(function (){
		CopyMulitTabClickhanldler("ClinicGroup")
	})
	$("#Copy_PositiveMax").click(function (){
		CopyMulitTabClickhanldler("PositiveMax")
	})
	$("#Copy_ApptMax").click(function (){
		CopyMulitTabClickhanldler("ApptMax")
	})
	$("#Copy_EStartPrefix").click(function (){
		CopyMulitTabClickhanldler("EStartPrefix")
	})
	$("#Copy_AddtionMax").click(function (){
		CopyMulitTabClickhanldler("AddtionMax")
	})
	$("#Copy_AppMethod").click(function (){
		CopyMulitTabClickhanldler("AppMethod")
	})
	$("#Copy_AppASFlag").click(function (){
		CopyMulitTabClickhanldler("AppASFlag")
	})*/
	}
function PageHandle(){
	InitWinInfo(ServerObj.ASRowid)
	//CopyMulitTabDataGridLoad();
	PageLogicObj.m_tabAppQtyListDataGrid.datagrid("load");
}
function CopyAllWinOpen(){
var SelRowListRowData=PageLogicObj.m_tabAppQtyListDataGrid.datagrid('getSelections');
	   if (SelRowListRowData.length==0){
		   $.messager.alert("提示","请选择需要同步的排班!");
		   return false;
	   }
	$("#CopyAllWin").dialog("open");
	LoadCopyAllWinData()
}
function LoadCopyAllWinData(){
	InitAppMethodGrid();
	InitTRDataGrid();
	LoadApptabAppMethodInfo();
	LoadtabTRInfo();
}
///新的预约号修改代码
function InitAppMethodGrid()
{
    $('#tabAppMethodInfo').datagrid({
        url:'',
        fit : true,
		border : false,
		striped : true,
		rownumbers:false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true, 
		idField:"ASAMRowid",   
		singleSelect:true,
		pageSize: 15,
		pageList : [15,100,200],
		toolbar :[
			{	
				text: '确认',
	            iconCls: 'icon-add',
	            handler: function() {
		            CopyAllMulit();
		            $("#CopyAllWin").dialog("close");
				}
			}],
        columns:[[
            {field:'ASAMRowid',hidden:true},
            {field:'AppMethodID',hidden:true},
            {field:'AppMethod',title:'预约方式',align:'center',width:100},
            {field:'MaxQty',title:'最大预约数',align:'center',width:100,},
            {field:'ReserveQty',title:'保留数',align:'center',width:55}
        ]],

        onDblClickRow:function(index,row){
        },
        onBeginEdit:function(index, row){
        }
    });
}
function InitTRDataGrid()
{
    $('#tabTRInfo').datagrid({
        url:'',
        singleSelect:true,
        fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,
		pageSize: 15,
		pageList : [15,100,200],
        columns:[[
            {field:'ASTRRowid',hidden:true},
            {field:'SttTime',title:'开始时间',align:'center',width:150},
            {field:'EndTime',title:'结束时间',align:'center',width:150},
            {field:'Load',title:'数量',align:'center',width:100,
                editor:{type:'numberbox',options:{min:1}}
            },
            {field:'tabTRAppMethodInfo',hidden:true},
            {field:'tabTRClinicGroupInfo',hidden:true}
        ]],
        onDblClickRow:function(index,row){
        },
        onBeforeSelect:function(index,row){
        },
        onSelect:function(index,row){
            var tabTRAppMethodInfo=row.tabTRAppMethodInfo;
            if(!tabTRAppMethodInfo) tabTRAppMethodInfo=[];
            if(typeof(tabTRAppMethodInfo)=='string'){
                tabTRAppMethodInfo=JSON.parse(tabTRAppMethodInfo);
            }
            SetElementValue('tabTRAppMethodInfo',tabTRAppMethodInfo);
            var tabTRClinicGroupInfo=row.tabTRClinicGroupInfo;
            if(!tabTRClinicGroupInfo) tabTRClinicGroupInfo=[];
            if(typeof(tabTRClinicGroupInfo)=='string'){
                tabTRClinicGroupInfo=JSON.parse(tabTRClinicGroupInfo);
            }
            SetElementValue('tabTRClinicGroupInfo',tabTRClinicGroupInfo);
        },
        onLoadSuccess:function(data){
        },
        onBeginEdit:function(){
        },
        onAfterEdit:function(index, row, changes){
        }
    }).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	var tabTRAppMethodInfoEditRow=""
    $('#tabTRAppMethodInfo').datagrid({
        url:'',
        fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
        columns:[[
            {field:'TRAMRowid',hidden:true},
            {field:'AppMethodID',hidden:true},
            {field:'AppMethod',title:'预约方式',align:'center',width:100},
            {field:'MaxQty',title:'最大预约数量',align:'center',width:95},
            {field:'ReserveQty',title:'保留数量',align:'center',width:55}
        ]],
        onDblClickRow:function(index,row){
        },
        onLoadSuccess:function(){
        },
        onBeginEdit:function(index, row){
        }
    });
    $('#tabTRClinicGroupInfo').datagrid({
        url:'',
        fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
        columns:[[
            {field:'TRClinicGroupRowid',hidden:true},
            {field:'ClinicGroupMethodID',hidden:true},
            {field:'ClinicGroup',title:'专业组',align:'center',width:100
            },
            {field:'Qty',title:'数量',align:'center',width:55
              } 
        ]],
        onDblClickRow:function(index,row){
        },
        onLoadSuccess:function(){
        },
        onBeginEdit:function(index, row){
        }
    });
}
function LoadApptabAppMethodInfo(){
	var retJson=$.cm({
        ClassName:'DHCDoc.OPAdm.Schedule',
        MethodName:'GetAppMethodsInfo',
        ASRowid:ServerObj.ASRowid,
        dataType:"json"
    },false);
    SetElementValue("tabAppMethodInfo",retJson);
}
function LoadtabTRInfo(){
	var retJson=$.cm({
        ClassName:'DHCDoc.OPAdm.Schedule',
        MethodName:'GetTRInfoNew',
        ASRowid:ServerObj.ASRowid,
        dataType:"json"
    },false);
    SetElementValue("tabTRInfo",retJson);
}
function CopyAllMulit(){
	var SelRowListRowData=PageLogicObj.m_tabAppQtyListDataGrid.datagrid('getSelections');
	   if (SelRowListRowData.length==0){
		   $.messager.alert("提示","请选择需要同步的排班!");
		   return false;
	   }
	   var NeedASRowid="";
	   for (var i=0;i<SelRowListRowData.length;i++){
		   if (SelRowListRowData[i].ASRowId==""){
			   continue;
		   }
		   if (NeedASRowid=="") NeedASRowid=SelRowListRowData[i].ASRowId;
		   else NeedASRowid=NeedASRowid+"^"+SelRowListRowData[i].ASRowId;
	   }
	  var Ret=$.cm({
	    ClassName : "DHCDoc.OPAdm.ScheduleCopyMulit",
	    MethodName : "MulitUpdateAllScheduleInfo",
	    MasterASRowid:ServerObj.ASRowid,
	    NeedASRowidStr:NeedASRowid,
		UserID:session['LOGON.USERID'],
		dataType:"text"
	},false);
	if (Ret==0){
		$.messager.popover({msg: '同步成功!',type:'success',timeout: 1000});
		//CopyMulitTabDataGridLoad();
		PageLogicObj.m_tabAppQtyListDataGrid.datagrid("load");
	}else{
		var retCode=Ret.split("^")[0];
		if (retCode<0) {
			if (retCode=="-202") {
				var ErrMsg="此诊室已经在同一天同一时段被安排过！"+Ret.split("^")[1];
			}else if(retCode=="-201"){
				var ErrMsg="此排班已经在同一天同一时段被安排过！"+Ret.split("^")[1];
			}else{
				var ASRowId=Ret.split("^")[1];
				var index=PageLogicObj.m_tabAppQtyListDataGrid.datagrid('getRowIndex',ASRowId);	
				var data=PageLogicObj.m_tabAppQtyListDataGrid.datagrid('getRows');
				var ASDate=data[index].ASDate;
				var LocDesc=data[index].LocDesc;
				var DocDesc=data[index].DocDesc;
				var ErrMsg="出诊日期："+ASDate+"出诊科室："+LocDesc+"出诊医生："+DocDesc;
				if (retCode=="-203"){ErrMsg += "正号限额不能小于已挂出号数! "};
				if (retCode=="-204"){ErrMsg += "预约限额不能小于已预约数! "};
				if (retCode=="-205"){ErrMsg += "加号限额不能小于已挂出数! "};
			}
			$.messager.alert('提示','同步失败!'+ErrMsg);
		}else{
			$.messager.alert('提示','同步失败!'+Ret);
		}
	}
	}
function CopyMulitTabClickhanldler(Type){
	 var SelRowListRowData=PageLogicObj.m_tabAppQtyListDataGrid.datagrid('getSelections');
	   if (SelRowListRowData.length==0){
		   $.messager.alert("提示","请选择需要同步的排班!");
		   return false;
	   }
	   var NeedASRowid="";
	   for (var i=0;i<SelRowListRowData.length;i++){
		   if (SelRowListRowData[i].ASRowId==""){
			   continue;
		   }
		   if (NeedASRowid=="") NeedASRowid=SelRowListRowData[i].ASRowId;
		   else NeedASRowid=NeedASRowid+"^"+SelRowListRowData[i].ASRowId;
	   }
	   var Info="";
	   if ((Type!="AppASFlag")||(Type!="AppMethod")){
			Info=getValue(Type) //根据不同的类型取值
	   }
	   ///如果是分时段则需要验证分时的正号数和开始时间结束时间是否一致
	   ///如果不一致则需提醒
	   var SelectFlag=""
	   if (Type=="AppASFlag"){
			var MasterStartTime=getValue("StartTime")
			var MasterEndTime=getValue("EndTime")
			var MasterPositiveMax=getValue("PositiveMax")
			for (var i=0;i<SelRowListRowData.length;i++){
				if ((SelRowListRowData[i].ASSessStartTime!=MasterStartTime)||(SelRowListRowData[i].ASSessionEndTime!=MasterEndTime)||(SelRowListRowData[i].ASLoad!=MasterPositiveMax)){
					if (SelectFlag==""){
						SelectFlag=SelRowListRowData[i].ASDate
					}else{
						SelectFlag=SelectFlag+","+SelRowListRowData[i].ASDate
					}
				}
			}
	   }
	   if (SelectFlag!=""){
			$.messager.alert('提示',SelectFlag+'的排班与主排班的正号限额或开始时间或结束时间不相同!不能同步分时段');
			return false;
	   }
	  var Ret=$.cm({
	    ClassName : "DHCDoc.OPAdm.ScheduleCopyMulit",
	    MethodName : "MulitUpdateScheduleInfo",
	    MasterASRowid:ServerObj.ASRowid,
	    NeedASRowidStr:NeedASRowid,
	    Type:Type,
	    Info:Info,
		UserID:session['LOGON.USERID'],
		dataType:"text"
	},false);
	if (Ret==0){
		$.messager.popover({msg: '同步成功!',type:'success',timeout: 1000});
		//CopyMulitTabDataGridLoad();
		PageLogicObj.m_tabAppQtyListDataGrid.datagrid("load");
	}else{
		var retCode=Ret.split("^")[0];
		if (retCode<0) {
			var ASRowId=Ret.split("^")[1];
			var index=PageLogicObj.m_tabAppQtyListDataGrid.datagrid('getRowIndex',ASRowId);	
			var data=PageLogicObj.m_tabAppQtyListDataGrid.datagrid('getRows');
			var ASDate=data[index].ASDate;
			var LocDesc=data[index].LocDesc;
			var DocDesc=data[index].DocDesc;
			var ErrMsg="出诊日期："+ASDate+"出诊科室："+LocDesc+"出诊医生："+DocDesc;
			if (retCode=="-203"){ErrMsg += "正号限额不能小于已挂出号数! "};
			if (retCode=="-204"){ErrMsg += "预约限额不能小于已预约数! "};
			if (retCode=="-205"){ErrMsg += "加号限额不能小于已挂出数! "};
			$.messager.alert('提示','同步失败!'+ErrMsg);
		}else{
			$.messager.alert('提示','同步失败!'+Ret);
		}
	}
}
function InitWinInfo(ASRowId){
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCRBApptSchedule';
	queryParams.QueryName ='ApptScheduleListQuery';
	queryParams.Arg1 ="";
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.Arg5 =ASRowId;
	queryParams.Arg6 ="";
	queryParams.ArgCnt = 6;
    queryParams.MWToken=('undefined'!==typeof websys_getMWToken)?websys_getMWToken():"";
	$.ajax({
	   type: 'POST',
	   url: "./dhcdoc.cure.query.grid.easyui.csp",
	   data: queryParams,
	   dataType: 'json',
	   async: true,
	   success: function(data, textStatus, jqXHR){
		    $("#AdmLoc").html(data.rows[0].LocationName)
		    $("#AdmDoc").html(data.rows[0].DoctorName)
		    $("#TimeRange").html(data.rows[0].SessionTimeName)
		    $("#DocSession").html(data.rows[0].SessionTypeDesc)
			$("#LocArea").html( data.rows[0].RoomName);
			$("#ClinicGroup").html(data.rows[0].SessionClinicGroupDescStr);
			if (data.rows[0].ScheduleDate!=""){
				var AdmDate=formatdate(data.rows[0].ScheduleDate); 
				$("#AdmDate").html(AdmDate);
			}
			$('#StartTime').html(data.rows[0].SessionStartTime);
			$('#EndTime').html(data.rows[0].SessEndTime);
			$('#PositiveMax').html(data.rows[0].TotalNum);
			$('#ApptMax').html(data.rows[0].BookNum);
			$('#AddtionMax').html(data.rows[0].OverBookNum);
			$("#EStartPrefix").html(data.rows[0].AppStartNo);
	   },
	   error: function(XMLHttpRequest, textStatus, errorThrown){
			alert(textStatus+"("+errorThrown+")");
	   }
	}); 
 }
function InitComboData(ComboID,queryParams){
	var jQueryComboObj = $(ComboID);
	var url=PageLogicObj.m_ComboJsonCSP;
	for ( var oe in queryParams) {
		if (url.indexOf("?")>=0){
			url=url+"&"+oe+"="+queryParams[oe];
		}else{
			url=url+"?"+oe+"="+queryParams[oe];
		}
	}
	jQueryComboObj.combobox('reload',url);
}
function InitSingleCombo(id,valueField,textField,ClassName,Query,exp,multipleField){
	if((typeof(multipleField)=="undefined")||(multipleField=="")){
		multipleField=false
	}
	if (ClassName!=""){
		var url=PageLogicObj.m_ComboJsonCSP+'?ClassName='+ClassName+'&QueryName='+Query+exp;
	}else{
		var url=PageLogicObj.m_ComboJsonCSP;
	}
	var ComboObj={
		editable:true,
		panelHeight:200,
		multiple:multipleField,
		mode:"local",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:valueField,   
	  	textField:textField,
	  	url:url,
	  	filter: function(q, row){
			var opts = $(this).combobox('options');
			if (row['code']){
				return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row['code'].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			}else{
				return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			}
		}
	};
	if(id=="ClinicGroup"){
		$.extend(ComboObj,{
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			editable:false,
		});
	}
	$("#"+id).combobox(ComboObj);
}
function InittabAppQtyList(){
	var Columns=[[
			{field:'check',title:'',width:120,align:'center',checkbox:true},
			{field:'ASRowId',title:'ASRowId',width:10,hidden:true},
			{field:'ASDate',title:'出诊日期',width:150,sortable:true},
			{field:'ASWeek',title:'星期',width:80,sortable:true},
			{field:'LocDesc',title:'出诊科室',width:150,sortable:true},
			{field:'DocDesc',title:'出诊医生',width:100,sortable:true,  },
            {field:'ASRoom',title:'诊室名称',width:120,sortable:true},
			{field:'ASSessionType',title:'职称',width:100,sortable:true},
			{field:'TimeRange',title:'午别',width:60,sortable:true},
			{field:'ASSessStartTime',title:'开始时间',width:70},
			{field:'ASSessionEndTime',title:'结束时间',width:70},
			{field:'NoLimitLoadFlag',title:'便捷排班',width:70},
			{field:'ASLoad',title:'挂号限额',width:70},
			{field:'ASAppLoad',title:'预约限额',width:70},
			{field:'AppStartSeqNo',title:'预约起始号',width:80},
			{field:'ASAddLoad',title:'加号限额',width:70},
			{field:'ClinicGroupStr',title:'专业组',width:80,sortable:true
			},
			{field:'AppMethodStr',title:'预约方式',width:280},
			{field:'AppTRInfoStr',title:'分时段',width:480},
			{field:'IrregularFlag',title:'异常',width:130}
		]]
	var CopyMulitTabDataGrid=$("#CopyMulitTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'ASRowId',
		columns :Columns,
		url : $URL+"?ClassName=DHCDoc.OPAdm.ScheduleCopyMulit&QueryName=GetApptScheduleCopy",
		onBeforeLoad:function(param){
				var StartDate=$("#StartDate").datebox("getValue"); 
				var EndDate=$("#EndDate").datebox("getValue"); 
				param = $.extend(param,{  MasterASRowID:ServerObj.ASRowid,StDate:StartDate,EnDate:EndDate});
		},
		onLoadSuccess:function(data){
				//editRow=undefined;
				PageLogicObj.m_tabAppQtyListDataGrid.datagrid('unselectAll')
			},
		onDblClickRow:function(index, row){
		}
	});
	return CopyMulitTabDataGrid;
}
function CopyMulitTabDataGridLoad(){
	var StartDate=$("#StartDate").datebox("getValue"); 
	var EndDate=$("#EndDate").datebox("getValue"); 
	$.q({
	    ClassName : "DHCDoc.OPAdm.ScheduleCopyMulit",
	    QueryName : "GetApptScheduleCopy",
	    MasterASRowID:ServerObj.ASRowid,
	    StDate:StartDate,
	    EnDate:EndDate,
	    Pagerows:PageLogicObj.m_tabAppQtyListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_tabAppQtyListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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
function formatdate(Date){
	return tkMakeServerCall("web.DHCBatchStopNew","FormatStringToDate",Date,ServerObj.sysDateFormat);
}
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var optobj=$("#"+id).combobox("options");
		var mulval=optobj.multiple;
		if(mulval){
			var tmpval=new Array();
			var val=$("#"+id).combobox("getValues");
			for(var i=0;i<val.length;i++){
				if(val[i]!=""){
					tmpval.push(val[i])
				}
			}
			val=tmpval.join(",");
		}else{
			var val=$("#"+id).combobox("getValue");
		}
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
function SetElementValue(target,value)
{
    if(typeof(target)=='string') target='#'+target;
    if(!$(target).size()) return false;
    var className=$(target).attr('class');
    if(!className) className="";
    var childClassName=$(target).children().attr('class');
    if(!childClassName) childClassName="";
    if(className.indexOf('combobox-f')>-1){
        $(target).combobox('select',value);
    }else if(className.indexOf('numberbox-f')>-1){
        $(target).numberbox('setValue',value);
    }else if(className.indexOf('hisui-switchbox')>-1){
        if((value==true)||(value=='Y')) value=true;
        else value=false;
        $(target).switchbox('setValue',value);
    }else if(className.indexOf('timespinner-f')>-1){
        $(target).timespinner('setValue',value);
    }else if(className.indexOf('datagrid-f')>-1){
        $(target).datagrid('loadData',value);
    }else if(className.indexOf('datebox-f')>-1){
        $(target).datebox('setValue',value);
    }else if(childClassName.indexOf('kw-section-list')>-1){
        $(target).keywords('select',value);
    }else if($(target).prop("tagName")=="INPUT"){
        $(target).val(value);
    }else{
        $(target).text(value);
    }
    return true;
}
