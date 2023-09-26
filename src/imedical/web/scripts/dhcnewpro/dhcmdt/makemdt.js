///QQA
///2019-04-17
var isEditFlag = 0;     /// 页面是否可编辑
var editSelRow = -1;
var LType = "CONSULT";  /// 会诊科室代码
var MarFlag=""          /// 是否开启亚专业
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
$(function() {
	
	initParams();  
	
	initShowPage();
    
    initCalenDar();
    
    if(!ShowPay){
		initTable();
	}
});

function initShowPage(){
	if(ShowPay){
		$('#mainLayout').layout('hidden','east');
	}	
}

function initParams(){
	var curDate = new Date();
    var curMonth = curDate.getMonth() + 1;
    todayDate = curDate.getFullYear() + "-" + (curMonth < 10 ? "0" + curMonth : curMonth) + "-" + ((curDate.getDate() < 10) ? ("0" + curDate.getDate()) : curDate.getDate());	
	selObj={};
	
}

function initCalenDar() {
    $('#makeTmpCalendar').fullCalendar({
        header: {
            left: 'prev,next',
            center: 'title',
            right: 'month,basicWeek,basicDay', //agendaWeek,agendaDay 精确时间段的视图
        },
        defaultDate: todayDate,
        editable: false, // 不可拖动
        lang: "zh-cn",
        monthNames: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
        monthNamesShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
        dayNames: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
        dayNamesShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
        today: ["今天"],
        eventColor: "#40a2de",
        eventBorderColor: "white",
        height: 500, // 整体高度
        //contentHeight: 50, // 有数据的行高
        buttonText: {
            today: '|',
            prev: '<',
            next: '>',
            month: '月视图',
            basicWeek: '周视图',
            basicDay: '日视图'
        },
        // 动态查询
        events: function(start, end, timezone, callback) {
			runClassMethod("web.DHCMDTConsultQuery","GetMarkInfo",{CstID:CstID,DisGrpID:MdtDisGrp},function(jsonString){
	           	events = formatData(jsonString);
	            callback(events);
	            return;
			})
	        
            
        },
        eventClick: function(calEvent, jsEvent, view) {
	        var date = calEvent.start.format("YYYY-MM-DD");
	        var title = calEvent.title;
	        var appSclID = calEvent.appSclID
	        var trDesc = calEvent.trDesc;
	        var allNum = calEvent.allNum;
	        if(allNum==0){
		    	$.messager.alert("提示","没有可预约的资源！");
		    	return;
		    }
	        var isSelStatus = $(this).hasClass("selMark");
			if(isSelStatus){
				$(this).removeClass("selMark");	
				selObj={};
			}else{
				$(".selMark").removeClass("selMark");
				$(this).addClass("selMark");
				selObj.date=date;
				selObj.title=title;
				selObj.appSclID=appSclID;
				selObj.trDesc = trDesc;
			}
			
			selItmFun();
			return;
    	}

    });
}

function formatData(datas){
	var retArr=[];
	for (i in datas){
		var backColor = "blue";
		var allNum = datas[i].AllNum;
		if(allNum==0) backColor ="#ccc"
		var obj={};
		obj.title = datas[i].TRDesc;
		obj.start = datas[i].ASDate;
		obj.color= backColor;
		obj.appSclID = datas[i].ASRowId
		obj.trDesc = datas[i].TRDesc;
		obj.allNum = allNum;
		retArr.push(obj);	
	}
	
	
   	return retArr;	
}

function selItmFun(){
	if(selObj.date!=undefined){
		var date = selObj.date;
		var title = selObj.title;
		var appSclID = selObj.appSclID;
		var trDesc = selObj.trDesc;
		if(ShowPay==1){
			window.parent.$("#mdtPreTime").val(date);
			window.parent.$("#mdtPreTimeRange").val(trDesc);
			window.parent.AppSclID = appSclID;
			window.parent.$("#mdtWin").window("close");
		}
	}else{
		
	}	
}

/// 页面DataGrid初始定义已选列表
function initTable(){
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var HosTypeArr = [{"value":"I","text":'本院'}, {"value":"O","text":'外院'}];
	//设置其为可编辑
	var HosEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: HosTypeArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	// 职称编辑格
	var PrvTpEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //设置容器高度自动增长
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///设置级联指针
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	// 科室编辑格
	var LocEditor={
		type: 'combobox',//设置编辑格式
		options:{
			valueField: "value", 
			textField: "text",
			mode:'remote',
			enterNullValueClear:false,
			//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
			url: '',
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);

				///设置级联指针
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// 联系方式
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
			},
			onShowPanel:function(){
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	// 亚专业编辑格
	var MarEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val(option.value);
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				GetMarIndDiv(option.value, LocID); 	/// 取科室亚专业指征
			},
			onShowPanel:function(){
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///设置级联指针
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ LocID;
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
		
	// 医师编辑格
	var DocEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// 联系方式
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetCareProvPhone(option.value));
				
				$m({
					ClassName:"web.DHCEMConsultCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///设置级联指针
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType=DOCTOR&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID;
				$(ed.target).combobox('reload',unitUrl);
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'PrvTpID',title:'职称ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'职称',width:160,editor:PrvTpEditor,align:'center',hidden:false},
		{field:'HosID',title:'HosID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'HosType',title:'院内院外',width:110,editor:HosEditor,align:'center'},
		{field:'LocID',title:'科室ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'科室',width:200,editor:LocEditor,align:'center'},
		{field:'MarID',title:'亚专业ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'MarDesc',title:'亚专业',width:200,editor:MarEditor,align:'center'},
		{field:'UserID',title:'医生ID',width:110,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'医生',width:120,editor:DocEditor,align:'center'},
		{field:'TelPhone',title:'联系方式',width:130,editor:texteditor,align:'center'},
		{field:'operation',title:"操作",width:100,align:'center',formatter:SetCellUrl}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (isEditFlag == 1) return;
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#docTable").datagrid('endEdit', editSelRow); 
            }
            $("#docTable").datagrid('beginEdit', rowIndex); 
            
            /// 联系方式
			var ed=$("#docTable").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
            editSelRow = rowIndex;
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
            $("a[name='AddRow']").not("#"+(data.rows.length - 1)).hide();
            /// 是否启用会诊亚专业
            if (MarFlag != 1){
				$("#docTable").datagrid('hideColumn','MarDesc');
            }
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID;
	new ListComponent('docTable', columns, uniturl, option).Init();
}

function getParams(){
	
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	var html = "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
	    html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
	return html;
}

/// 删除行
function delRow(rowIndex){
	
	if (isEditFlag == 1) return;
	/// 行对象
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'', HosType:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	
	var rows = $('#docTable').datagrid('getRows');
	if(rows.length>2){
		 $('#docTable').datagrid('deleteRow',rowIndex);
	}else{
		$('#docTable').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// 删除后,重新排序
	//$('#docTable').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
	
	GetMarIndDiv("", ""); 	/// 取科室亚专业指征
}

/// 插入空行
function insRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'I', HosType:'本院', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#docTable").datagrid('appendRow',rowObj);
}


/// 取科室电话
function GetLocTelPhone(LocID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetLocTelPhone",{"LocID":LocID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// 取医生电话
function GetCareProvPhone(CareProvID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetCareProvPhone",{"CareProvID":CareProvID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}