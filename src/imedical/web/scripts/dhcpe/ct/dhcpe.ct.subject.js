/*
 * Description: �ʾ�����ά��
 * FileName: dhcpe.ct.subject.js
 * Author: wangguoying
 * Date: 2021-08-12
 */
 
 
//	���������¼�б༭��¼
var _SDLEditRows=new Array();  
/**��������ɾ������**/
Array.prototype.remove = function(val) { 
	var index = this.indexOf(val); 
	if (index > -1) { 
	this.splice(index, 1); 
	} 
};

$.extend($.fn.validatebox.defaults.rules, {
	checkQDCodeExist:{
		validator: function(value){
			var url=$URL;  
			var data={ClassName:'web.DHCHM.QuestionDetailSet',MethodName:'CheckQDCodeExist',Code:value};
			var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
			return rtn==0;
		},
		message: '�����Ѵ���'
	}
});


/**
 * [��ʼ�������б� ]
 * @Author   wangguoying
 * @DateTime 2021-08-12
 */
function initSubjectDatagrid() {
	$HUI.datagrid("#SubjectDG", {
		singleSelect: true,
		url: $URL,
		queryParams: {
			ClassName: "web.DHCPE.CT.HM.CommonData",
			QueryName: "QuerySubject"
		},
		onSelect: function(rowIndex, rowData) {
			initSubjectCatDatagrid();
		},
		onDblClickRow: function(index, row) {
			open_subjectWin("UPDATE");
		},
		idField: 'TID',
		columns: [
			[{
				field: 'TID',
				hidden: true
			}, {
				field: 'TCode',
				width: 80,
				title: '����'
			}, {
				field: 'TDesc',
				width: 150,
				title: '����'
			}, {
				field: 'TActive',
				width: 50,
				title: '����',
				align: "center",
				formatter: function(value, row, index) {
					var checked = value == "Y" ? "checked" : "";
					return "<input type='checkbox' disabled class='hisui-checkbox' " + checked + " >";
				}
			}, {
				field: 'TRemark',
				width: 200,
				title: '��ע'
			}, ]
		],
		toolbar: [{
			iconCls: 'icon-add',
			text: '����',
			handler: function() {open_subjectWin("ADD");}
		}, {
			iconCls: 'icon-write-order',
			text: '�༭',
			handler: function() {open_subjectWin("UPDATE");}
		}],
		fitColumns: false,
		pagination: false,
		pageSize: 20,
		fit: true
	});
	initSubjectCatDatagrid();
	initSDLinkDatagrid();
}


/**
 * [��ʼ��������������б� ]
 * @Author   zhufei
 * @DateTime 2021-12-22
 */
function initSubjectCatDatagrid() {
	var parRef = "";
	var row = $("#SubjectDG").datagrid("getSelected");
	if(row != null) {
		parRef = row.TID;
	}
	$HUI.datagrid("#SubjectCat", {
		singleSelect: true,
		url: $URL,
		queryParams: {
			ClassName: "web.DHCPE.CT.HM.CommonData",
			QueryName: "QuerySubjectCat",
			ParRef : parRef
		},
		onSelect: function(rowIndex, rowData) {
			initSDLinkDatagrid();
		},
		onDblClickRow: function(index, row) {
			open_subjectcatWin("UPDATE");
		},
        onLoadSuccess: function (data) {
			$("#SubjectCat").datagrid("clearSelections");
        },
		idField: 'ID',
		columns: [
			[{
				field: 'ID',
				hidden: true
			}, {
				field: 'Code',
				width: 40,
				title: '����'
			}, {
				field: 'Desc',
				width: 110,
				title: '����'
			}, {
				field: 'Number',
				width: 40,
				title: '��ʾ<br>���'
			}, {
				field: 'Sort',
				width: 50,
				title: '˳���'
			}, {
				field: 'Active',
				width: 40,
				title: '����',
				align: "center",
				formatter: function(value, row, index) {
					var checked = value == "Y" ? "checked" : "";
					return "<input type='checkbox' disabled class='hisui-checkbox' " + checked + " >";
				}
			}]
		],
		toolbar: [{
			iconCls: 'icon-add',
			text: '����',
			handler: function() {open_subjectcatWin("ADD");}
		}, {
			iconCls: 'icon-write-order',
			text: '�༭',
			handler: function() {open_subjectcatWin("UPDATE");}
		}],
		fitColumns: false,
		pagination: false,
		pageSize: 20,
		fit: true
	});
	initSDLinkDatagrid();
}


/**
 * [��ʼ����������������б� ]
 * @Author   wangguoying
 * @DateTime 2021-08-13
 */
function initSDLinkDatagrid() {
	var parRef = "";
	var row = $("#SubjectDG").datagrid("getSelected");
	if(row != null) {
		parRef = row.TID;
		$("#DetailPanel").panel("setTitle","<label style='color:blue;font-weight:700;'>"+row.TDesc+"</label>---��������ά��");
		$("#H_Subject").val(row.TID);
	}else{
		$("#DetailPanel").panel("setTitle","��������ά��");
		$("#H_Subject").val("");
	}
	
	var CatDr = "";
	var row = $("#SubjectCat").datagrid("getSelected");
	if(row != null) {
		CatDr = row.ID;
	}
	
	$HUI.datagrid("#SDLinkDG", {
		singleSelect: true,
		url: $URL,
		queryParams: {
			ClassName: "web.DHCPE.CT.HM.CommonData",
			QueryName: "QuerySubjectDetailLink",
			ParRef : parRef,
			aCatID : CatDr
		},
		onSelect: function(rowIndex, rowData) {
			optionClear();
			if((rowData.TType=="M")||(rowData.TType=="S")){
				$("#LockDiv").hide();
				$("#OpParf").val(rowData.TDetailID);
				$("#OpParfType").val(rowData.TType);
				init_optionlist();
			} else{
				$("#LockDiv").show();
			}  
		},
		onDblClickRow: function(index, row) {
			
		},
        onLoadSuccess: function (data) {
			$("#SDLinkDG").datagrid("clearSelections");
        },
		idField: 'TID',
		columns: [
			[{
				field: 'TID',
				hidden: true
			},{
				field: 'TDetailID',
				hidden: true
			}, {
				field: 'TCatDesc',
				width: 100,
				title: '����'
			}, {
				field: 'TDetailDesc',
				width: 180,
				title: '����',
				formatter: function(value, row, index) {
					return "<a href='#' onclick='open_detailWin("+row.TDetailID+")' >" + value + "</a>";
				}
			}, {
				field: 'TNumber',
				width: 50,
				title: '��ʾ<br>���'
			}, {
				field: 'TSort',
				width: 50,
				title: '˳���',
				editor:{type:'numberbox',options:{min:0}}
			}, {
				field: 'TActive',
				width: 50,
				title: '����',
				align: "center",
				formatter: function(value, row, index) {
					var checked = value == "Y" ? "checked" : "";
					return "<input type='checkbox' disabled class='hisui-checkbox' " + checked + " >";
				},
				editor:{type:'checkbox',options: {
					on:'Y',
					off:'N'
				}}
			} ,{
				field:'TOperate',title:'����',width:40,align: "center",
				formatter:function(value,row,index){
					return "<a href='#' onclick='edit_sdlink_row(\""+index+"\",this)'>\
					<img style='padding-top:4px;' title='�޸ļ�¼' alt='�޸ļ�¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png' border=0/>\
					</a>";
				}
			},]
		],
		fitColumns: false,
		pagination: true,
		pageSize: 20,
		fit: true
	});
}

function init_optionlist(){
	$HUI.datagrid("#OptionDG",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCHM.QuestionDetailSet",
			QueryName:"FindQDOption",
			ParRef: $("#OpParf").val()
		},
		onSelect:function(rowIndex,rowData){
			$("#OpID").val(rowData.QDOID);
			$("#OpDesc").val(rowData.QDODesc);
			$("#OpSeq").val(rowData.QDOOrder);
			$("#OpSex").combobox("setValue",rowData.QDOSex);
			if(rowData.QDODefault=="true"){
				$("#OpDefault").checkbox("check");
			}else{
				$("#OpDefault").checkbox("uncheck");
			}
			if(rowData.QDONote=="true"){
				$("#OpNote").checkbox("check");
			}else{
				$("#OpNote").checkbox("uncheck");
			}
			if(rowData.QDOActive=="true"){
				$("#OpActive").checkbox("check");
			}else{
				$("#OpActive").checkbox("uncheck");
			}
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'QDOID',hidden:true,sortable:'true'},
			{field:'QDOOperation',width:'40',title:'����',
				formatter:function(value,row,index){
					return "<a href='#' onclick='openDOLinkDWin(\""+row.QDOID+"\")'>\
					<img   title='��������ά��' alt='��������ά��' style='margin-left:8px;padding-top:4px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/adm_add.png' border=0/>\
					</a>"
				}
			},
			{field:'QDODesc',width:'140',title:'����'},
			{field:'QDOSex',width:'60',title:'�Ա�',
				formatter:function(value,row,index){
					var dispalyTxt="";
					if (value == 'M') {
                    	dispalyTxt='��';
               		}
                	if (value == 'F') {
                    	dispalyTxt='Ů';
               		}
               		if (value == 'N') {
                    	dispalyTxt='����';
                	}
                	return dispalyTxt;
				}
			},
			{field:'QDOOrder',width:'60',title:'���'},
			{field:'QDODefault',width:'60',title:'Ĭ��',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDONote',width:'80',title:'����ע',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'QDOActive',width:'60',title:'����',align:'center',
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
		displayMsg:""
	});
}
/**
 * ѡ���
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function save_option()
{
	var QDOParRef=$("#OpParf").val();
	var OpParfType=$("#OpParfType").val();
	var OpID=$("#OpID").val();
	if(QDOParRef==""){
		$.messager.alert("��ʾ","����ѡ��Ҫ�����������","info");
		return false;
	}
	var QDODesc=$("#OpDesc").val();
	if(QDODesc==""){
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	var QDOOrder=$("#OpSeq").val();
	if (QDOOrder!=""){
		
		   if((!(isInteger(QDOOrder)))||(QDOOrder<=0)) 
		   {
			   $.messager.alert("��ʾ","˳��ֻ����������","info");
			    return false; 
		   }

	}

	var QDOSex=$("#OpSex").combobox("getValue")
	var QDODefault="N";
	if($("#OpDefault").checkbox("getValue")){
		QDODefault="Y";
	}
	var QDONote="N";
	if($("#OpNote").checkbox("getValue")){
		QDONote="Y";
	}
	var QDOActive="N";
	if($("#OpActive").checkbox("getValue")){
		QDOActive="Y";
	}
	var property = 'QDOActive^QDODefault^QDODesc^QDOOrder^QDOParRef^QDOSex^QDONote';
	var valList=QDOActive+"^"+QDODefault+"^"+QDODesc+"^"+QDOOrder+"^"+QDOParRef+"^"+QDOSex+"^"+QDONote;
	try{
		var ret=tkMakeServerCall("web.DHCHM.QuestionDetailSet","QDOSave",OpID,valList,property,OpParfType,QDODefault,QDOParRef);
		if (ret.split("^")[0] == -1) {
            $.messager.alert("����","����ʧ�ܣ�"+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.popover({msg:"����ɹ�",type:"success"});
        	optionClear();
            $("#OptionDG").datagrid("reload");
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}


/**
 * ���������ά������
 * @param    {[String]}    OID [ѡ��ID]
 * @Author   wangguoying
 * @DateTime 2019-04-01
 */
function openDOLinkDWin(OID){
	var lnk = "dhchm.dolinkdetail.edit.csp?OID='+OID+'";
	$HUI.window("#DOLinkDetailWin",{
		title:"��������ά��",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:500,
		height:400,
		content:'<iframe src= "' + PEURLAddToken(lnk) + '"width="100%" height="100%" frameborder="0" ></iframe>'
	}).center();
};


function isInteger(num) {
   if (!isNaN(num) && num % 1 === 0) {
        return true;
    } else {
        return false;
    }
}
/**
 * ѡ��ά�����
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function optionClear(){
	//$("#OpParf").val("");
	$("#OpParfType").val("");
	$("#OpID").val("");
	$("#OpDesc").val("");
	$("#OpSeq").val("");
	$("#OpSex").combobox("setValue","");
	$("#OpDefault").checkbox("uncheck");
	$("#OpNote").checkbox("uncheck");
	$("#OpActive").checkbox("uncheck");
}



/**
 * [������¼�޸�]
 * @param    {[int]}    index [������]
 * @param    {[object]}    t     [��ť����]
 * @Author   wangguoying
 * @DateTime 2021-08-14
 */
function edit_sdlink_row(index,t){
	var parRefRow = $("#SubjectCat").datagrid("getSelected");
	if(parRefRow == null){
		$.messager.popover({type:"alert",msg:"��ѡ����������"});
		return false;
	}
	if(_SDLEditRows.indexOf(index)>-1){
		t.children[0].alt="�޸ļ�¼";
		t.children[0].title="�޸ļ�¼";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png";
		$("#SDLinkDG").datagrid("endEdit",index);
		var data = $("#SDLinkDG").datagrid("getRows");
		var row = data[index];
		var inString = row.TID + "^" +row.TDetailID + "^" + row.TActive + "^" + row.TSort;
		var ret = tkMakeServerCall("web.DHCPE.CT.HM.CommonData","SaveSDLink",parRefRow.ID,inString,session["LOGON.USERID"]);
		if(parseInt(ret.split("^")[0])!=0){
			$("#SDLinkDG").datagrid("reload");
			$.messager.alert("��ʾ",ret.split("^")[1],"error");
			return false;
		}else{
			$.messager.popover({type:"success",msg:"����ɹ�"});
			_SDLEditRows.remove(index);
		}
		
	}else{
		if(_SDLEditRows.length>0){
			$.messager.popover({type:"alert",msg:"����δ��������ݣ��뱣������"});
			return false;
		}
		t.children[0].alt="�����¼";
		t.children[0].title="�����¼";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/save.png";
		$("#SDLinkDG").datagrid("beginEdit",index);
		_SDLEditRows.push(index);
	}
}

function search_subject(value,name){
	$("#SubjectDG").datagrid("load",{
		ClassName: "web.DHCPE.CT.HM.CommonData",
		QueryName: "QuerySubject",
		Param: value
	});
}

/**
 * [���� ���������]
 * @param    {[String]}    type [ADD������ UPDATE������]
 * @Author   wangguoying
 * @DateTime 2021-08-12
 */
function open_subjectWin(type){
	if(type == "ADD"){	
		SubjectWin_clean();
	}else{
		var row = $("#SubjectDG").datagrid("getSelected");
		if(row == null){
			$.messager.popover({type:"alert",msg:"��ѡ����Ҫ�༭�ļ�¼",style:{left:80,top:180}});
			return false;
		}
		$("#WID").val(row.TID);
		$("#WCode").val(row.TCode);
		$("#WDesc").val(row.TDesc);
		$("#WRemark").val(row.TRemark);
		if(row.TActive == "Y"){
			$("#WActive").checkbox("setValue",true);
		}else{
			$("#WActive").checkbox("setValue",false);
		}
	}
	$("#SubjectWin").dialog("open");
}

/**
 * [���� ���������]
 * @param    {[String]}    type [ADD������ UPDATE������]
 * @Author   zhufei
 * @DateTime 2021-12-22
 */
function open_subjectcatWin(type){
	if(type == "ADD"){
		SubjectCatWin_clean();
	}else{
		var row = $("#SubjectCat").datagrid("getSelected");
		if(row == null){
			$.messager.popover({type:"alert",msg:"��ѡ����Ҫ�༭�ļ�¼",style:{left:80,top:180}});
			return false;
		}
		$("#SCID").val(row.ID);
		$("#SCCode").val(row.Code);
		$("#SCDesc").val(row.Desc);
		$("#SCNumber").val(row.Number);
		$("#SCSort").val(row.Sort);
		if(row.Active == "Y"){
			$("#SCActive").checkbox("setValue",true);
		}else{
			$("#SCActive").checkbox("setValue",false);
		}
	}
	$("#SubjectCatWin").dialog("open");
}

/**
 * [��������]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2021-08-12
 */
function save_subject(){
	var id = $("#WID").val();
	var code = $("#WCode").val();
	var desc = $("#WDesc").val();
	var remark = $("#WRemark").val();
	var active = $("#WActive").checkbox("getValue") ? "Y" : "N";
	if(code == ""){
		$.messager.popover({type:"alert",msg:"���벻��Ϊ��"});
		return false;
	}
	if(desc == ""){
		$.messager.popover({type:"alert",msg:"��������Ϊ��"});
		return false;
	}
	var properties = "QDSCode^QDSDesc^QDSActive^QDSRemark";
	var valStr = code + "^" + desc + "^" + active + "^" + remark;
	var ret = tkMakeServerCall("web.DHCPE.CT.HM.CommonData","SaveSubject",id,properties,valStr,session["LOGON.USERID"]);
	if(parseInt(ret.split("^")[0]) < 0){
		$.messager.popover({type:"error",msg:ret.split("^")[1]});
		return false;
	}else{
		$.messager.popover({type:"success",msg:"����ɹ�"});
		close_subjectWin();
		$("#SubjectDG").datagrid("reload");
	}
}


function close_subjectWin(){
	$("#SubjectWin").dialog("close");
}

/**
 * [���ⴰ������]
 * @Author   wangguoying
 * @DateTime 2021-08-12
 */
function SubjectWin_clean(){
	$("#WID").val("");
	$("#WCode").val("");
	$("#WDesc").val("");
	$("#WRemark").val("");
	$("#WActive").checkbox("setValue",true);
}

/**
 * [��������]
 * @return   {[type]}    [description]
 * @Author   zhufei
 * @DateTime 2021-12-22
 */
function save_subjectcat(){
	var parRef = $("#H_Subject").val();
	var id = $("#SCID").val();
	var code = $("#SCCode").val();
	var desc = $("#SCDesc").val();
	var number = $("#SCNumber").val();
	var sort = $("#SCSort").val();
	var active = $("#SCActive").checkbox("getValue") ? "Y" : "N";
	if(code == ""){
		$.messager.popover({type:"alert",msg:"���벻��Ϊ��"});
		return false;
	}
	if(desc == ""){
		$.messager.popover({type:"alert",msg:"��������Ϊ��"});
		return false;
	}
	var properties = "QDSCParRef^QDSCCode^QDSCDesc^QDSCNumber^QDSCSort^QDSCActive";
	var valStr = parRef + "^" + code + "^" + desc + "^" + number + "^" + sort + "^" + active;
	var ret = tkMakeServerCall("web.DHCPE.CT.HM.CommonData","SaveSubjectCat",id,properties,valStr,session["LOGON.USERID"]);
	if(parseInt(ret.split("^")[0]) < 0){
		$.messager.popover({type:"error",msg:ret.split("^")[1]});
		return false;
	}else{
		$.messager.popover({type:"success",msg:"����ɹ�"});
		close_subjectcatWin();
		$("#SubjectCat").datagrid("reload");
	}
}

function close_subjectcatWin(){
	$("#SubjectCatWin").dialog("close");
}

/**
 * [���ⴰ������]
 * @Author   zhufei
 * @DateTime 2021-12-22
 */
function SubjectCatWin_clean(){
	$("#SCID").val("");
	$("#SCCode").val("");
	$("#SCDesc").val("");
	$("#SCNumber").val("");
	$("#SCSort").val("");
	$("#SCActive").checkbox("setValue",true);
}

/**
 * [���� �༭]
 * @param    {[int]}    id [����ID  Ϊ��ʱ����]
 * @Author   wangguoying
 * @DateTime 2021-08-12
 */
function open_detailWin(id){
	var row = $("#SubjectDG").datagrid("getSelected");
	if(row == null){
		$.messager.popover({type:"alert",msg:"��ѡ����������"});
		return false;
	}
	if ($("#WD_ParRef").attr("class") == undefined)	//ֻ�ڵ�һ�μ���
	{
		init_detail_combotree();
	}
	if(id == ""){	
		DetailWin_clean();
	}else{
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
 * [���ⴰ������]
 * @Author   wangguoying
 * @DateTime 2021-08-13
 */
function DetailWin_clean(){
	$("#WD_ID").val("");
	$("#WD_ParRef").combotree("setValue","");
	$("#WD_Code").val("");
	$("#WD_Desc").val("");
	$("#WDesc").val("");
	$("#WD_Active").checkbox("setValue",true);
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
 * [���Ѵ��ڵ������б���ѡ��]
 * @Author   wangguoying
 * @DateTime 2021-08-13
 */
function select_detail(){
	var row = $("#SubjectDG").datagrid("getSelected");
	if(row == null){
		$.messager.popover({type:"alert",msg:"��ѡ����������"});
		return false;
	}
	var lnk = "dhcpe.ct.hm.detailselect.csp?CQDSubjectDR='+row.TID+'";
	$('#DetailSelectWin').dialog({
	    title: '���Ѵ��ڵ������б���ѡ��',
	    iconCls: 'icon-all-select',
	    width: 600,
	    height: 600,
	    closed: false,
	    cache: false,
	    modal: true,
	    buttons:[{
				text:'ȷ��',
				iconCls:'icon-w-ok',
				handler:save_exist_detail
			},{
				text:'�ر�',
				iconCls:'icon-w-close',
				handler:function(){$("#DetailSelectWin").dialog("close");}
		}],
	    content:'<iframe id="DetailSelectFrame" src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
	});
}

/**
 * [������ѡ����]
 * @Author   wangguoying
 * @DateTime 2021-08-13
 */
function save_exist_detail(){
	var row = $("#SubjectCat").datagrid("getSelected");
	if(row == null){
		$.messager.popover({type:"alert",msg:"��ѡ����������"});
		return false;
	}
	var dTree = websys_isIE ? window.frames["DetailSelectFrame"].$("#DetailTree") : window.frames["DetailSelectFrame"].contentWindow.$("#DetailTree");
	var nodes = dTree.tree('getChecked');
	var inString = "";
	var char0 = String.fromCharCode(0);
	nodes.forEach( function(element, index) {
		if(element.type != "Subject" && element.sysDefault  == 0 ){
			var info = "^"+element.id+"^Y^20";	//Ĭ�����20
			inString = inString == "" ? info : inString + char0 + info;
		}
	});
	if(inString == ""){
		$.messager.popover({type:"alert",msg:"��ѡ����Ҫ��ӵļ�¼"});
		return false;
	}
	var ret = tkMakeServerCall("web.DHCPE.CT.HM.CommonData","SaveSDLink",row.ID,inString,session["LOGON.USERID"]);
	if(parseInt(ret.split("^")[0])!=0){
		$.messager.alert("��ʾ",ret.split("^")[1],"error");
		return false;
	}else{
		$("#DetailSelectWin").dialog("close");
		$.messager.popover({type:"success",msg:"�����"});
		$("#SDLinkDG").datagrid("reload");
	}
}
/**
 * �ʾ����ݱ���
 * @Author   wangguoying
 * @DateTime 2021-08-14
 */
function save_detail(){
	var row = $("#SubjectCat").datagrid("getSelected");
	if(row == null){
		$.messager.popover({type:"alert",msg:"��ѡ����������"});
		return false;
	}
	
	
	var Subject = $("#H_Subject").val();
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
		$.messager.alert("��ʾ","����¼�������Լ�","info");
		return false;
	}
		
	if(QDMaxVal!=""&& QDMinVal!="" && parseFloat(QDMinVal)>parseFloat(QDMaxVal)){
		$.messager.alert("��ʾ","���޲���С������","info");
		return false;
	}
	
	if(QDRangeMin!=""&& QDRangeMax!="" && parseFloat(QDRangeMin)>parseFloat(QDRangeMax)){
		$.messager.alert("��ʾ","�ο���Χ����","info");
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
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	if((QDID=="")&&(!$("#WD_Code").validatebox("isValid"))){
		$.messager.alert("��ʾ","�����Ѵ���","info");
		return false;
	}
	if(QDDesc==""){
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	var property = 'QDCode^QDDesc^QDType^QDUnit^QDSex^QDLinkCode^QDElementNum^QDActive^QDRequired^QDRemark^QDLinkDesc^QDLinkUnit^QDLinkBreak^QDMaxValue^QDMinValue^QDRangeMax^QDRangeMin^QDParentDR';
	var valList = QDCode+"^"+QDDesc+"^"+QDType+"^"+QDUnit+"^"+QDSex+"^"+QDLinkCode+"^"+QDColNum+"^"+QDActive+"^"+QDRequired+"^"+QDRemark+"^"+QDLinkDesc+"^"+QDLinkUnit+"^"+QDLinkBreak+"^"+QDMaxVal+"^"+QDMinVal+"^"+QDRangeMax+"^"+QDRangeMin+"^"+QDParRef;
	try{
		var ret=tkMakeServerCall("web.DHCPE.CT.HM.CommonData","SaveDetail",QDID,property,valList,row.ID,session["LOGON.USERID"]);
		if (ret.split("^")[0] != 0) {
            $.messager.alert("����","����ʧ�ܣ�"+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.popover({msg:"����ɹ�",type:"success"});
            $("#DetailEditWin").dialog("close");
            $("#SDLinkDG").datagrid("reload");
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}

function init() {
	initSubjectDatagrid();
}

$(init);