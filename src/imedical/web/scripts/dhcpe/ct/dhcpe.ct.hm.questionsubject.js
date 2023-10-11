/*
 * Description: 调查问卷主题维护
 * FileName: dhcpe.ct.hm.questionsubject.js
 * Author: wangguoying
 * Date: 2021-08-15
 */

//	性别下拉数据
var _SexComboData = [{
		id: 'M',
		text: '男'
	}, {
		id: 'F',
		text: '女'
	}, {
		id: 'N',
		text: '不限'
	}
];
 
//	问题关联记录行编辑记录
var _SDLEditRows=new Array(); 
var _OptionEditRows=new Array(); 
/**定义数组删除函数**/
Array.prototype.remove = function(val) { 
	var index = this.indexOf(val); 
	if (index > -1) { 
	this.splice(index, 1); 
	} 
};
var SubjectDataGrid = $HUI.datagrid("#SubjectList",{
		url:$URL,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.QuestionnaireSet",
			QueryName:"FindQSubject",
			ParRef:$("#QuestionDR").val()
		},
		onSelect:function(rowIndex,rowData){
			$("#SubjectDR").val(rowData.QSID);
			$("#SCode").val(rowData.QSCode);
			$("#SDesc").val(rowData.QSDesc);
			$("#SSex").combobox("setValue",rowData.QSSex);
			$("#SRemark").val(rowData.QSRemark);
			$("#SOrder").val(rowData.QSOrder);
			$("#MinAge").val(rowData.QSMinAge);
			$("#MaxAge").val(rowData.QSMaxAge);
			if(rowData.QSActive=="true"){
				$("#SActive").checkbox("check");			
			}else{
				$("#SActive").checkbox("uncheck");
			}
			if(rowData.QSDocFlag=="Y"){
				$("#DocFlag").checkbox("check");			
			}else{
				$("#DocFlag").checkbox("uncheck");
			}
			initQDLinkDatagrid();
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'QSID',hidden:true,sortable:'true'},
			{field:'QSCode',width:30,title:'编码'},
			{field:'QSDesc',width:150,title:'描述'},
			{field:'QSOrder',width:40,title:'顺序'},
			{field:'QSSex',width:40,title:'性别',
				formatter:function(value,row,index){
					var ret="不限";
					switch (value){
						case "M":
							ret="男";
							break;
						case "F":
							ret="女";
							break;
						default:
							break;
					}
					return ret
				}
			},
			{field:'QSAgeRange',width:80,title:'年龄段',align:"center",
				formatter:function(value,row,index){
					return row.QSMinAge+"-"+row.QSMaxAge;
				}
			},
			{field:'QSActive',width:30,title:'激活',align:"center",
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QSDocFlag',width:60,title:'护士填写',align:"center",
				formatter:function(value,row,index){
					var checked=value=="Y"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QSRemark',width:80,title:'备注'}
		]],
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});
	

var QDetailDataGrid = $HUI.datagrid("#QDetailList",{
		url:$URL,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.QuestionnaireSet",
			QueryName:"FindCSDLink",
			ParRef:$("#SubjectDR").val()
		},
		onSelect:function(rowIndex,rowData){
			$("#SDLDR").val(rowData.SDLID);
			$("#QDOrder").val(rowData.SDLOrder);
			if(rowData.SDLActive=="true"){
				$("#QDActive").checkbox("check");
			}else{
				$("#QDActive").checkbox("uncheck");
			}
			initQuestionCombogrid(rowData.QDDesc);
			$("#QDetailDR").combogrid("setValue",rowData.SDLQuestionsDetailDR);
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'SDLID',hidden:true,sortable:'true'},
			{field:'SDLQuestionsDetailDR',hidden:true,sortable:'true'},
			{field:'QDDesc',width:200,title:'问卷内容'},
			{field:'SDLOrder',width:80,title:'显示顺序'},
			{field:'SDLActive',width:50,title:'激活',align:"center",
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});
	
function subject_clean(){
	$("#SubjectDR").val("");
	$("#SCode").val("");
	$("#SDesc").val("");
	$("#SRemark").val("");
	$("#SOrder").val("");
	$("#MinAge").val("");
	$("#MaxAge").val("");
	$("#SActive").checkbox("check");
	$("#DocFlag").checkbox("uncheck");
	$("#SSex").combobox("setValue","N");
}


function suject_save(){
	var ID=$("#SubjectDR").val();
	var Code=$("#SCode").val();
	var Desc=$("#SDesc").val();
	var Sex=$("#SSex").combobox("getValue");
	var Remark=$("#SRemark").val();
	var Order=$("#SOrder").val();
	var MinAge=$("#MinAge").val();
	var MaxAge=$("#MaxAge").val();
	var QuesDr=$("#QuestionDR").val();
	var Active="N";
	if($("#SActive").checkbox("getValue")){
		Active="Y";
	}
	var DocFlag="N";
	if($("#DocFlag").checkbox("getValue")){
		DocFlag="Y";
	}
	if(Code==""){
		$.messager.alert("提示","编码不能为空","info");
		return false;
	}
	if(Desc==""){
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	var property = 'QSActive^QSCode^QSDesc^QSOrder^QSParRef^QSRemark^QSSex^QSDocFlag^QSMinAge^QSMaxAge';
	var valList=Active+"^"+Code+"^"+Desc+"^"+Order+"^"+QuesDr+"^"+Remark+"^"+Sex+"^"+DocFlag+"^"+MinAge+"^"+MaxAge;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionnaireSet","QSSave",ID,valList,property);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("错误","保存失败"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");     
        	subject_clean();	
            SubjectDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindQSubject",ParRef:QuesDr});
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}
	
function QDetail_clean()
{
	$("#SDLDR").val("");
	$("#QDOrder").val("");
	$("#QDActive").checkbox("check");
	$("#QDetailDR").combogrid("setValue","");
	
	initQuestionCombogrid("");
}	
	
function QDetail_save(){
	var ID=$("#SDLDR").val();
	var Order=$("#QDOrder").val();
	if(Order==""){
		$.messager.alert("提示","显示顺序不能为空","info");
		return false;
	}
	var Active="N";
	if($("#QDActive").checkbox("getValue")){
		Active="Y";
	}
	var ParRef=$("#SubjectDR").val();	
	if(ParRef==""){
		$.messager.alert("提示","未选择主题","info");
		return false;
	}
	var DetailDr=$("#QDetailDR").combogrid("getValue");
	if(DetailDr==""||DetailDr=="undefined"){
		$.messager.alert("提示","问卷内容不能为空","info");
		return false;
	}
	var property = 'SDLActive^SDLOrder^SDLParRef^SDLQuestionsDetailDR';
	var valList=Active+"^"+Order+"^"+ParRef+"^"+DetailDr;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionnaireSet","SDLSave",ID,valList,property,ParRef,DetailDr);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("错误","保存失败"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");     
        	QDetail_clean();	
            QDetailDataGrid.load({ClassName:"web.DHCHM.QuestionnaireSet",QueryName:"FindCSDLink",ParRef:ParRef});
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}
function initQuestionCombogrid(Desc){
	var QuestionCombogrid=$("#QDetailDR").combogrid({
		panelWidth: 350,
        idField: 'SDLQuestionsDetailDR',
        textField: 'QDDesc',
        method: 'get',
        url:$URL+'?ClassName=web.DHCHM.QuestionnaireSet&QueryName=FindQD',
        onBeforeLoad:function(param){
        	if(Desc!==""){
        		param.Desc = Desc;
        	}else{
        		param.Desc=param.q;
        	}
			
		},
		mode:'remote',
		delay:200,
        columns: [[           				            			
			{field:'QDCode',title:'编码',width:80},
			{field:'QDDesc',title:'描述',width:200},
			{field:'SDLQuestionsDetailDR',title:'ID',width:80}
		]],
        onLoadSuccess: function () {
            					
       },
       fitColumns:true,
	   pagination:true,
	   pageSize:50,
	   displayMsg:""       	
	});
}
	
function init(){
	initQuestionCombogrid("");
	setGridHeight();
}

/**
 * [初始化主题与问题关联列表 ]
 * @Author   wangguoying
 * @DateTime 2021-08-13
 */
function initQDLinkDatagrid() {
	var parRef = $("#SubjectDR").val();
	$HUI.datagrid("#QDLinkDG", {
		singleSelect: true,
		url: $URL,
		queryParams: {
			ClassName: "web.DHCHM.QuestionnaireSet",
			QueryName: "FindCSDLink",
			ParRef : parRef
		},
		onSelect: function(rowIndex, rowData) {
			if(rowData.QDType == "S" || rowData.QDType == "M") {
				$("#H_DetailID").val(rowData.SDLQuestionsDetailDR);
				$("#H_DetailType").val(rowData.QDType);
				$("#LockDiv").fadeOut();
				init_optionlist();
			}else{
				$("#LockDiv").fadeIn();
			} 
		},
		onLoadSuccess: function(data){
			$("#LockDiv").fadeIn();
			$("#H_DetailID").val("");
			init_optionlist();
		},
		onDblClickRow: function(index, row) {
			
		},
		idField: 'SDLID',
		columns: [
			[{
				field: 'SDLID',
				hidden: true
			},{
				field: 'SDLQuestionsDetailDR',
				hidden: true
			}, {
				field: 'QDDesc',
				width: 100,
				title: '问题',
				formatter: function(value, row, index) {
					return "<a href='#' onclick='open_detailWin("+row.SDLQuestionsDetailDR+")' >" + value + "</a>";
				}
			}, {
				field: 'SDLOrder',
				width: 40,
				title: '序号',
				editor:{type:'numberbox',options:{min:0}}
			}, {
				field: 'SDLActive',
				width: 40,
				title: '激活',
				align: "center",
				editor:{type:'checkbox',options: {
					on:'Y',
					off:'N'
				}},
				formatter: function(value, row, index) {
					var checked = value == "Y" ? "checked" : "";
					return "<input type='checkbox' disabled class='hisui-checkbox' " + checked + " >";
				}
			} ,{field:'TOperate',title:'操作',width:20,align: "center",
				formatter:function(value,row,index){
					return "<a href='#' onclick='edit_sdlink_row(\""+index+"\",this)'>\
					<img style='padding-top:4px;' title='修改记录' alt='修改记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png' border=0/>\
					</a>";
				}
			},]
		],
		fitColumns: true,
		pagination: true,
		pageSize: 20,
		fit: true
	});
}


/**
 * [问题 编辑]
 * @param    {[int]}    id [问题ID  为空时新增]
 * @Author   wangguoying
 * @DateTime 2021-08-12
 */
function open_detailWin(id){
	var QSubject = $("#SubjectDR").val();
	if(QSubject == ""){
		$.messager.popover({type:"alert",msg:"请选择所属主题"});
		return false;
	}
	if ($("#WD_ParRef").attr("class") == undefined)	//只在第一次加载
	{
		init_detail_combotree();
	}
	DetailWin_clean();
	if(id != ""){	
		set_detailWin(id);
	}
	$("#DetailEditWin").dialog("open");
}
function set_detailWin(id){
	var jsonString = tkMakeServerCall("web.DHCPE.CT.HM.CommonData","GetDetailJSON",id)
	var obj = JSON.parse(jsonString);
	$("#WD_ID").val(id);
	$("#WD_ParRef").combotree("setValue",obj.QDParentDR);
	$("#WD_Code").val(obj.QDCode);
	$("#WD_Desc").val(obj.QDDesc);
	var active = obj.QDActive == "Y" ? true : false; 
	$("#WD_Active").checkbox("setValue",active);
	$("#WD_Type").combobox("setValue",obj.QDType);
	$("#WD_ColNum").val(obj.QDElementNum);
	$("#WD_MaxVal").val(obj.QDMaxValue);
	$("#WD_MinVal").val(obj.QDMinValue);
	$("#WD_RangeMin").val(obj.QDRangeMax);
	$("#WD_RangeMax").val(obj.QDRangeMin);
	$("#WD_Sex").combobox("setValue",obj.QDSex);
	$("#WD_LinkCode").val(obj.QDLinkCode);
	$("#WD_Unit").val(obj.QDUnit);
	$("#WD_LinkDesc").val(obj.QDLinkDesc);
	$("#WD_LinkUnit").val(obj.QDLinkUnit);
	$("#WD_LinkBreak").val(obj.QDLinkBreak);
	$("#WD_Remark").val(obj.QDRemark);
}


function init_detail_combotree(){
	$HUI.combotree('#WD_ParRef',{
		url:$URL+"?ClassName=web.DHCPE.CT.HM.CommonData&MethodName=GetDetailTree&ResultSetType=array",
		valueField:'id',
		textField:'text',
		editable:false,
		onBeforeSelect: function(node){
			if(node.type == "Subject") return false;
		}
	});
}


function close_detailWin(){
	$("#DetailEditWin").dialog("close");
}

/**
 * [问题窗口清屏]
 * @Author   wangguoying
 * @DateTime 2021-08-13
 */
function DetailWin_clean(){
	$("#WD_ID").val("");
	$("#WD_ParRef").combotree("setValue","");
	$("#WD_Code").val("");
	$("#WD_Desc").val("");
	$("#WDesc").val("");
	$("#WD_Active").checkbox("setValue",false);
	$("#DRequired").checkbox("setValue",false);
	$("#WD_Type").combobox("setValue","");
	$("#WD_ColNum").val("");
	$("#WD_MaxVal").val("");
	$("#WD_MinVal").val("");
	$("#WD_RangeMin").val("");
	$("#WD_RangeMax").val("");
	$("#WD_Sex").combobox("setValue","");
	$("#WD_LinkCode").val("");
	$("#WD_Unit").val("");
	$("#WD_LinkDesc").val("");
	$("#WD_LinkUnit").val("");
	$("#WD_LinkBreak").val("");
	$("#WD_Remark").val("");
}


/**
 * [从已存在的问题列表中选择]
 * @Author   wangguoying
 * @DateTime 2021-08-13
 */
function select_detail(){
	var QSubject = $("#SubjectDR").val();
	if(QSubject == ""){
		$.messager.popover({type:"alert",msg:"请选择所属主题"});
		return false;
	}
	var lnk = "dhcpe.ct.hm.detailselect.csp?CQuesSubjectDR="+QSubject
	$('#DetailSelectWin').dialog({
	    title: '从已存在的问题列表中选择',
	    iconCls: 'icon-all-select',
	    width: 600,
	    height: 600,
	    closed: false,
	    cache: false,
	    modal: true,
	    buttons:[{
				text:'确定',
				iconCls:'icon-w-ok',
				handler:save_exist_detail
			},{
				text:'关闭',
				iconCls:'icon-w-close',
				handler:function(){$("#DetailSelectWin").dialog("close");}
		}],
	    content:'<iframe id="DetailSelectFrame" src="'+PEURLAddToken(lnk)+'" width="100%" height="100%" frameborder="0"></iframe>'
	});
}

/**
 * [保存已选问题]
 * @Author   wangguoying
 * @DateTime 2021-08-13
 */
function save_exist_detail(){
	var QSubject = $("#SubjectDR").val();
	if(QSubject == ""){
		$.messager.popover({type:"alert",msg:"请选择所属主题"});
		return false;
	}
	var dTree = window.frames["DetailSelectFrame"].contentWindow.$("#DetailTree");
	var nodes = dTree.tree('getChecked');
	var inString = "";
	var char0 = String.fromCharCode(0);
	nodes.forEach( function(element, index) {
		if(element.type != "Subject" && element.sysDefault  == 0 ){
			var info = "^"+element.id+"^Y^20";	//默认序号20
			inString = inString == "" ? info : inString + char0 + info;
		}
	});
	var ret = tkMakeServerCall("web.DHCPE.CT.HM.CommonData","SaveQuesSDLink",QSubject,inString,session["LOGON.USERID"]);
	if(parseInt(ret.split("^")[0])!=0){
		$.messager.alert("提示",ret.split("^")[1],"error");
		return false;
	}else{
		$("#DetailSelectWin").dialog("close");
		$.messager.popover({type:"success",msg:"已添加"});
		$("#QDLinkDG").datagrid("reload");
	}
}
/**
 * 问卷内容保存
 * @Author   wangguoying
 * @DateTime 2021-08-14
 */
function save_detail(){
	var Subject = $("#SubjectDR").val();
	var QDID=$("#WD_ID").val();
	var QDDesc=$("#WD_Desc").val();
	var QDCode=$("#WD_Code").val();
	var QDType=$("#WD_Type").combobox("getValue");
	var QDUnit=$("#WD_Unit").val();
	var QDSex=$("#WD_Sex").combobox("getValue");
	var QDLinkCode=$("#WD_LinkCode").val();
	var QDColNum=$("#WD_ColNum").val();
	var QDLinkDesc = $("#WD_LinkDesc").val();
	var QDLinkUnit = $("#WD_LinkUnit").val();
	var QDLinkBreak = $("#WD_LinkBreak").val();	
	var QDMaxVal=$("#WD_MaxVal").val();
	var QDMinVal = $("#WD_MinVal").val();
	var QDRangeMin = $("#WD_RangeMin").val();
	var QDRangeMax = $("#WD_RangeMax").val();
	var QDParRef = $("#WD_ParRef").combo("getValue");
	
	if(QDID != "" && QDID == QDParRef){
		$.messager.alert("提示","父记录不能是自己","info");
		return false;
	}
		
	if(QDMaxVal!=""&& QDMinVal!="" && parseFloat(QDMinVal)>parseFloat(QDMaxVal)){
		$.messager.alert("提示","上限不能小于下限","info");
		return false;
	}
	
	if(QDRangeMin!=""&& QDRangeMax!="" && parseFloat(QDRangeMin)>parseFloat(QDRangeMax)){
		$.messager.alert("提示","参考范围有误","info");
		return false;
	}
	
	var QDActive="N";
	var QDRequired="N";
	if($("#WD_Active").checkbox("getValue")){
		QDActive="Y";
	}
	if($("#WD_Required").checkbox("getValue")){
		QDRequired="Y";
	}
	var QDRemark=$("#WD_Remark").val();
	if(QDCode==""){
		$.messager.alert("提示","编码不能为空","info");
		return false;
	}
	if((QDID=="")&&(!$("#WD_Code").validatebox("isValid"))){
		$.messager.alert("提示","编码已存在","info");
		return false;
	}
	if(QDDesc==""){
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	var property = 'QDCode^QDDesc^QDType^QDUnit^QDSex^QDLinkCode^QDElementNum^QDActive^QDRequired^QDRemark^QDLinkDesc^QDLinkUnit^QDLinkBreak^QDMaxValue^QDMinValue^QDRangeMax^QDRangeMin^QDParentDR';
	var valList = QDCode+"^"+QDDesc+"^"+QDType+"^"+QDUnit+"^"+QDSex+"^"+QDLinkCode+"^"+QDColNum+"^"+QDActive+"^"+QDRequired+"^"+QDRemark+"^"+QDLinkDesc+"^"+QDLinkUnit+"^"+QDLinkBreak+"^"+QDMaxVal+"^"+QDMinVal+"^"+QDRangeMax+"^"+QDRangeMin+"^"+QDParRef;
	try{
		var ret=tkMakeServerCall("web.DHCPE.CT.HM.CommonData","SaveDetail",QDID,property,valList,Subject,session["LOGON.USERID"],"QS");
		if (ret.split("^")[0] != 0) {
            $.messager.alert("错误","保存失败："+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.popover({msg:"保存成功",type:"success"});
            $("#DetailEditWin").dialog("close");
            $("#QDLinkDG").datagrid("reload");
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}

/**
 * [关联记录修改]
 * @param    {[int]}    index [行索引]
 * @param    {[object]}    t     [按钮对象]
 * @Author   wangguoying
 * @DateTime 2021-08-14
 */
function edit_sdlink_row(index,t){
	if(_SDLEditRows.indexOf(index)>-1){
		t.children[0].alt="修改记录";
		t.children[0].title="修改记录";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png";
		$("#QDLinkDG").datagrid("endEdit",index);
		var data = $("#QDLinkDG").datagrid("getRows");
		var row = data[index];
		var inString = row.SDLID + "^" +row.SDLQuestionsDetailDR + "^" + row.SDLActive + "^" + row.SDLOrder;
		var ret = tkMakeServerCall("web.DHCPE.CT.HM.CommonData","SaveQuesSDLink",$("#SubjectDR").val(),inString,session["LOGON.USERID"]);
		if(parseInt(ret.split("^")[0])!=0){
			$("#QDLinkDG").datagrid("reload");
			$.messager.alert("提示",ret.split("^")[1],"error");
			return false;
		}else{
			$.messager.popover({type:"success",msg:"保存成功"});
			_SDLEditRows.remove(index);
		}
		
	}else{
		if(_SDLEditRows.length>0){
			$.messager.popover({type:"alert",msg:"存在未保存的数据，请保存后操作"});
			return false;
		}
		t.children[0].alt="保存记录";
		t.children[0].title="保存记录";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/save.png";
		$("#QDLinkDG").datagrid("beginEdit",index);
		_SDLEditRows.push(index);
	}
}

function setGridHeight()
{

}


function init_optionlist(){
	$HUI.datagrid("#QDOptionDG",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCHM.QuestionDetailSet",
			QueryName:"FindQDOption",
			ParRef: $("#H_DetailID").val()
		},
		onSelect:function(rowIndex,rowData){
			
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'QDOID',hidden:true,sortable:'true'},
			{field:'QDOOperation',width:'40',title:'操作',
				formatter:function(value,row,index){
					return "<a href='#' onclick='openDOLinkDWin(\""+row.QDOID+"\")'>\
					<img   title='关联问题维护' alt='关联问题维护' style='margin-left:8px;padding-top:4px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/adm_add.png' border=0/>\
					</a>"
				}
			},
			{field:'QDODesc',width:'140',title:'描述',editor: {type: 'validatebox'}},
			{field:'QDOSex',width:'60',title:'性别',editor: {type:'combobox',options: {valueField: 'id',textField: 'text',data: _SexComboData}},
				formatter:function(value,row,index){
					var dispalyTxt="";
					if (value == 'M') {
                    	dispalyTxt='男';
               		}
                	if (value == 'F') {
                    	dispalyTxt='女';
               		}
               		if (value == 'N') {
                    	dispalyTxt='不限';
                	}
                	return dispalyTxt;
				}
			},
			{field:'QDOOrder',width:'60',title:'序号',editor: {type: 'numberbox',options: {min:0}}},
			{field:'QDODefault',width:'60',title:'默认',align:'center',editor: {type: 'checkbox',options: {on:'true',off:'false'}},
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDONote',width:'80',title:'允许备注',align:'center',editor: {type: 'checkbox',options: {on:'true',off:'false'}},
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDOActive',width:'60',title:'激活',align:'center',editor: {type: 'checkbox',options: {on:'true',off:'false'}},
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			}
		]],
		singleSelect: true,
		pagination:true,
		pageSize:20,
		fit:true,
		toolbar:[{
			iconCls: 'icon-add',
			text: '新增',
			handler: add_option
		}, {
			iconCls: 'icon-write-order',
			text: '编辑',
			handler: update_option
		}, {
			iconCls: 'icon-save',
			text: '保存',
			handler: save_option
		}]
	});
}



/**
 * 打开问题关联维护窗口
 * @param    {[String]}    OID [选项ID]
 * @Author   wangguoying
 * @DateTime 2019-04-01
 */
function openDOLinkDWin(OID){
	if(OID == null || OID == undefined || OID == "" ){
		$.messager.alert("提升","选项未保存","info");
		return false;
	}
	var lnk = "dhchm.dolinkdetail.edit.csp?OID="+OID;
	$HUI.window("#DOLinkDetailWin",{
		title:"关联问题维护",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:500,
		height:400,
		content:'<iframe src="'+PEURLAddToken(lnk)+'" width="100%" height="100%" frameborder="0" ></iframe>'
	}).center();
};


/**
 * 新增选项
 * @Author   wangguoying
 * @DateTime 2021-08-16
 */
function add_option(){
	if ((_OptionEditRows.length > 0)) {
		$.messager.popover({msg:"一次只能修改一条记录",type:'error'});
		return;
	}
	$('#QDOptionDG').datagrid('appendRow', {
		QDOID: '',
		QDODesc: '',
		QDOSex: '',
		QDOOrder:'',
		QDODefault:'',
		QDONote:'',
		QDOActive:''	
	});
	var lastIndex = $('#QDOptionDG').datagrid('getRows').length - 1;
	$('#QDOptionDG').datagrid('selectRow', lastIndex);
	$('#QDOptionDG').datagrid('beginEdit', lastIndex);
	_OptionEditRows.push(lastIndex);
} 
/**
 * 删除选项
 * @Author   wangguoying
 * @DateTime 2021-08-16
 */
function delete_option(){
	var row = $('#QDOptionDG').datagrid('getSelected');
	if(row == null){
		$.messager.popover({type:"error",msg:"请选择待删除的记录"});
		return false;
	}
	if(row.QDOID != ""){
		$.messager.alert("提升","不允许物理删除数据，如需取消该选项，直接取消激活即可","info");
		return false;
	}
	var index = $('#QDOptionDG').datagrid('getRowIndex',row);
	$('#QDOptionDG').datagrid('deleteRow',index);
	_OptionEditRows.remove(index);
}
/**
 * 更新选项
 * @Author   wangguoying
 * @DateTime 2021-08-16
 */
function update_option(){
	if ((_OptionEditRows.length > 0)) {
		$.messager.popover({msg:"一次只能修改一条记录",type:'error'});
		return;
	}
	var row = $('#QDOptionDG').datagrid('getSelected');
	if(row == null){
		$.messager.popover({type:"error",msg:"请选择待编辑的记录"});
		return false;
	}
	var index = $('#QDOptionDG').datagrid('getRowIndex',row);
	$('#QDOptionDG').datagrid('beginEdit', index);
	_OptionEditRows.push(index);
}
/**
 * 选项保存
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function save_option()
{
	if ((_OptionEditRows.length == 0)) {
		$.messager.popover({msg:"没有需要保存的记录",type:'error'});
		return;
	}
	$('#QDOptionDG').datagrid("endEdit",_OptionEditRows[0]);
	var row = $('#QDOptionDG').datagrid('getRows')[_OptionEditRows[0]];
	_OptionEditRows.remove(_OptionEditRows[0]);
	var QDOParRef=$("#H_DetailID").val();
	var OpParfType = $("#H_DetailType").val();
	if(QDOParRef==""){
		$.messager.alert("提示","负记录为空","info");
		return false;
	}
	if(row.QDODesc==""){
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	var QDOOrder = row.QDOOrder;
	if (QDOOrder!=""){
		
		   if((!(isInteger(QDOOrder)))||(QDOOrder<=0)) 
		   {
			   $.messager.alert("提示","顺序只能是正整数","info");
			    return false; 
		   }

	}else{
		$.messager.alert("提示","顺序不能为空","info");
		return false;
	}

	var QDOSex=row.QDOSex;
	var QDODefault="N";
	if(row.QDODefault == "true"){
		QDODefault="Y";
	}
	var QDONote="N";
	if(row.QDONote == "true"){
		QDONote="Y";
	}
	var QDOActive="N";
	if(row.QDOActive == "true"){
		QDOActive="Y";
	}
	var property = 'QDOActive^QDODefault^QDODesc^QDOOrder^QDOParRef^QDOSex^QDONote';
	var valList=QDOActive+"^"+QDODefault+"^"+row.QDODesc+"^"+QDOOrder+"^"+QDOParRef+"^"+QDOSex+"^"+QDONote;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDOSave",row.QDOID,valList,property,OpParfType,QDODefault,QDOParRef);
		if (ret.split("^")[0] == -1) {
            $.messager.alert("错误","保存失败："+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.popover({msg:"保存成功",type:"success"});
            $("#QDOptionDG").datagrid("reload");
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}
function isInteger(num) {
   if (!isNaN(num) && num % 1 === 0) {
        return true;
    } else {
        return false;
    }
}

$(init);