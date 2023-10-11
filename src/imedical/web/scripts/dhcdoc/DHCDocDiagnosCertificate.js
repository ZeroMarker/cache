var PageLogicObj={
	m_DocDiagnosCertificateListGrid:"",
	m_editRow:undefined
}
$(function(){
	Init();
});
function Init(){
	PageLogicObj.m_DocDiagnosCertificateListGrid=InitDocDiagnosCertificateListGrid();
}
function InitDocDiagnosCertificateListGrid(){
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
        handler: function() { SaveClickHandle();}
    },{
		text:'取消编辑',
		iconCls: 'icon-redo',
		handler: function() {
			PageLogicObj.m_editRow = undefined;
            PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("rejectChanges").datagrid("unselectAll");
		}
	}];
	// DDCRowId,DDCDiagnosIDStr,DiagnosDescStr,DDCDiagConfirmDate,DDCDaysOff,DDCDocNotes,DDCStatus,DDCStatusDesc
	var Columns=[[ 
		{field:'DDCDiagnosIDStr',title:'诊断',width:300,
			editor :{  
				type:'combobox',  
				options:{
					valueField:'DiagnosRowId',
					textField:'DiagnosDesc',
					required:false,
					multiple:true,
				    rowStyle:'checkbox',
				    data:eval("(" + ServerObj.DiagListJson + ")"),
				    onSelect:function(rec){
					    var DiagnosRowId=rec.DiagnosRowId;
					    var DiagSubRowIdStr=rec.DiagSubRowIdStr;
					    if (DiagSubRowIdStr!="") {
						    for (var i=0;i<DiagSubRowIdStr.split(String.fromCharCode(1)).length;i++){
							    //$(this).combobox('select',DiagSubRowIdStr.split(String.fromCharCode(1))[i]);
							}
						}else{
							var data=eval("(" + ServerObj.DiagListJson + ")");
							for (var i=0;i<data.length;i++){
								var tmpDiagSubRowIdStr=data[i].DiagSubRowIdStr;
								if ((tmpDiagSubRowIdStr!="")&&((String.fromCharCode(1)+tmpDiagSubRowIdStr+String.fromCharCode(1)).indexOf(String.fromCharCode(1)+DiagnosRowId+String.fromCharCode(1))>=0)) {
									$(this).combobox('select',data[i].DiagnosRowId);
									break;
								}
							}
						}
					},
					onUnselect:function(rec){
						var DiagnosRowId=rec.DiagnosRowId;
					    var DiagSubRowIdStr=rec.DiagSubRowIdStr;
					    if (DiagSubRowIdStr!="") {
						    for (var i=0;i<DiagSubRowIdStr.split(String.fromCharCode(1)).length;i++){
							    //$(this).combobox('unselect',DiagSubRowIdStr.split(String.fromCharCode(1))[i]);
							}
						}else{
							var data=eval("(" + ServerObj.DiagListJson + ")");
							for (var i=0;i<data.length;i++){
								var tmpDiagSubRowIdStr=data[i].DiagSubRowIdStr;
								if ((tmpDiagSubRowIdStr!="")&&((String.fromCharCode(1)+tmpDiagSubRowIdStr+String.fromCharCode(1)).indexOf(String.fromCharCode(1)+DiagnosRowId+String.fromCharCode(1))>=0)) {
									$(this).combobox('unselect',data[i].DiagnosRowId);
									break;
								}
							}
						}
					}
				}
			 },
			 formatter:function(BillTypeRowid,record){
				  return record.DiagnosDescStr;
			 }
		},
		{field:'DDCDiagConfirmDate',title:'确诊日期',width:115,
			editor :{  
				type:'datebox'
			}
		},
		{field:'DDCDaysOff',title:'建议休假天数',width:100,
			editor:{type:'numberbox',options:{min:1,
                    onChange:function(val,oldVal){
                        
                    }
                }
			}
		},
		{field:'DDCDocNotes',title:'建议',width:300,
			editor :{  
				type:'text'
			}
		},
		{field:'DDCStatusDesc',title:'当前状态',width:130}
    ]]
	var DocDiagnosCertificateListGrid=$("#DocDiagnosCertificateList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 10,
		pageList : [10,100,200],
		idField:'DDCRowId',
		columns :Columns,
		toolbar:toobar,
		url:$URL+"?ClassName=web.DHCDocDiagnosCertificate&QueryName=GetDiagnosCertificateList&EpisodeID="+ServerObj.EpisodeID,
		onDblClickRow:function(rowIndex, rowData){
			if (rowData.DDCStatus == "P") {
				$.messager.alert('提示',"该诊断证明已打印,不可修改！");
				return false;
			}
			if ((PageLogicObj.m_editRow!=undefined)&&(PageLogicObj.m_editRow!=rowIndex)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return;
			}
			PageLogicObj.m_editRow=rowIndex;
			PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("beginEdit", rowIndex);
		}
	}); 
	if (ServerObj.DiagCertificateMaxDaysOff!="") {
		$('.datagrid-toolbar tr').append("<td><span style='color:red;'>"+$g("本科最大休假天数为 ")+ServerObj.DiagCertificateMaxDaysOff+$g(" 天")+"</span></td>");
	}
	return DocDiagnosCertificateListGrid;
}
function AddClickHandle(){
	PageLogicObj.m_editRow = undefined;
    PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("rejectChanges").datagrid("unselectAll");
    PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("insertRow", {
        index: 0,
        row: {}
    });
    PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("beginEdit", 0);
    PageLogicObj.m_editRow = 0;
}
function DelClickHandle(){
	var rows = PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("getSelections");
	var rows = PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("getSelections");
	for(var i=0;i<rows.length;i++){
		if(rows[i].DDCStatus=='P'){
			$.messager.alert('提示',"已打印记录不能删除");
			return;
		}
	}
    if (rows.length > 0) {
        $.messager.confirm("提示", "您确定要删除吗?",
        function(r) {
            if (r) {
                var rows=PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("getSelected");  
                var DDCRowId=rows.DDCRowId;
                if (!DDCRowId){
                    PageLogicObj.m_editRow = undefined;
	                PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                return false;
                }
                var value=$.m({
					ClassName:"web.DHCDocDiagnosCertificate",
					MethodName:"DeleteDiagnosCertificate",
				   	DDCRowId:DDCRowId
				},false);
				if(value=="0"){
					PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid('unselectAll').datagrid('load');
					$.messager.popover({msg: '删除成功!',type:'success'});
				}else{
					$.messager.alert('提示',"删除失败:"+value);
				}
			    PageLogicObj.m_editRow = undefined;
            }
        });
    } else {
        $.messager.alert("提示", "请选择要删除的行", "error");
    }
}
function SaveClickHandle(){
	if (PageLogicObj.m_editRow == undefined) return;
	var editors = PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid('getEditors', PageLogicObj.m_editRow);
	var rows = PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid("selectRow",PageLogicObj.m_editRow).datagrid("getSelected");
    if(rows.DDCRowId){
        var DDCRowId=rows.DDCRowId
    }else{
        var DDCRowId="";
    }
   // var DiagnosIDStr=editors[0].target.combobox('getValues').join(',');
    var DiagnosIDStr=editors[0].target.combobox('getValues').sort(function(a,b){
		return a.split("||")[1]-b.split("||")[1];
	}).join(',');
	if (!DiagnosIDStr) {
		$.messager.alert('提示',"请选择诊断！");
		return false;
	}
	var DiagConfirmDate=editors[1].target.datebox('getValue')
	if (!DiagConfirmDate) {
		$.messager.alert('提示',"请选择确诊日期！");
		return false;
	}
	if (ServerObj.SYSDateFormat=="4"){
	    var tmpdate=DiagConfirmDate.split("/")[2]+"-"+DiagConfirmDate.split("/")[1]+"-"+DiagConfirmDate.split("/")[0]
	    var tmpdate = new Date(tmpdate.replace("-", "/").replace("-", "/"));
	}else{
		var tmpdate = new Date(DiagConfirmDate.replace("-", "/").replace("-", "/"));
	}
	var CurDate=new Date();
	var end=new Date(CurDate.getFullYear()+"/"+(CurDate.getMonth()+1)+'/'+ CurDate.getDate());
	if (tmpdate > end){
		$.messager.alert('提示',"确诊日期不能大于当天！");
		return false;
	}
	var DaysOff=$.trim(editors[2].target.val());
	if (!DaysOff) {
		$.messager.alert('提示',"请填写休假天数！");
		return false;
	}
	if (!isInteger(DaysOff)) {
		$.messager.alert('提示',"休假天数应为正整数！");
		return false;
	}
	if ((ServerObj.DiagCertificateMaxDaysOff!="")&&(parseInt(DaysOff)>parseInt(ServerObj.DiagCertificateMaxDaysOff))){
		$.messager.alert('提示',$g("最大休假天数不能大于 ")+ServerObj.DiagCertificateMaxDaysOff+$g("天！"));
		return false;
	}
	var DocNotes=editors[3].target.val();
	var value=$.m({ 
		ClassName:"web.DHCDocDiagnosCertificate", 
		MethodName:"SaveDiagnosCertificate",
		DDCRowId:DDCRowId,
		DiagnosIDStr:DiagnosIDStr,
		DiagConfirmDate:DiagConfirmDate,
		DaysOff:DaysOff,
		DocNotes:DocNotes,
		ExpStr:ServerObj.EpisodeID+"^"+session['LOGON.USERID']
	},false);
	if (value=="repeat") {
		$.messager.alert('提示',"保存失败！记录重复!");
        return false;
	}else if(+value=="0"){
	   PageLogicObj.m_editRow = undefined;
       PageLogicObj.m_DocDiagnosCertificateListGrid.datagrid('unselectAll').datagrid('load');
       $.messager.popover({msg: '保存成功！',type:'success'});
    }else{
       $.messager.alert('提示',"保存失败:"+value);
       return false;
    }
}
function isInteger(objStr) {
    var reg = /^\+?[0-9]*[0-9][0-9]*$/;
    var ret = objStr.match(reg);
    if (ret == null) { return false } else { return true }
}
