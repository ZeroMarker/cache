$.extend($.fn.datagrid.methods, {
  getEditingRowIndexs: function(jq) {
    var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
    var indexs = [];
    rows.each(function(i, row) {
      var index = row.sectionRowIndex;
      if (indexs.indexOf(index) == -1) {
          indexs.push(index);
      }
    });
    return indexs;
  }
});
// -----------------------------------------------------
var hospID=session['LOGON.HOSPID'],docAdvicesObj={};
var saveFlag=true;
var page=1, pageSize=20;
var successFunction,errorFunction;
var docAdviceloader = function(param,success,error){
	successFunction=success;
	errorFunction=error;
	var q = param.q || '';
	var delimiter = String.fromCharCode(12);
	var key=q;
	if (''===key) key=delimiter;
	if (!docAdvicesObj[key]) {
	  var docAdvices=$cm({
	    ClassName: 'Nur.NIS.Service.Base.Ward',
	    QueryName: 'GetallWardNew',
	    rows: 50,
	    desc: q,
			hospid:hospID,
			bizTable:'Nur_IP_Education2ResultConfig'
	  }, false);
	  docAdvicesObj[key]=docAdvices.rows;
	}
	success(docAdvicesObj[key]);
}
$(function() {
	hospComp = GenHospComp("Nur_IP_EduResultConfig",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		hospID=d.HOSPRowId;
		docAdvicesObj={};
		init();
	}
	$('#_HospList').combogrid('disable');
	init();
})
function init() {
	getBWTableData();
	$("#validWard").combobox({  
		defaultFilter:6,
		valueField:'wardid',
		textField:'warddesc',
		mode:'remote',
		loader: docAdviceloader
	}); 
}
function getBWTableData() {
	saveFlag=false;
	timeouter=setTimeout(function(){
		saveFlag=true;
	},3000);
	// 获取血糖预警配置
  $cm({
    ClassName: 'Nur.NIS.Service.Education2.ResultConfig',
    QueryName: 'GetEduResultConfigList',
    page: page,
    rows: pageSize,
    keyword: $('#keyword').val(),
    hospDR: hospID
  }, function (res) {
  	console.log(res);
  	if ((res.total>0)&&!res.rows.length&&(page>1)) {
  		page=1
  		getBWTableData();
  		return;
  	}
		$('#bloodWarn').datagrid('loadData',res).datagrid("getPager").pagination({
	    onSelectPage:function(p,size){
				page=p;
				pageSize=size;
				if (saveFlag) {
					console.log(p,size);
					getBWTableData();
				}else{
					saveFlag=true;
				}
	    },
	    onRefresh:function(p,size){
	    	console.log(p,size);
				page=p;
				pageSize=size;
				getBWTableData();
	    },
	    onChangePageSize:function(size){
	    	console.log(size);
				page=1;
				pageSize=size;
				getBWTableData();
	    }
		}).pagination('select', page);
		selectBWIndex=undefined;
  });
}
function addBWRow() {
  var offsetLeft=(window.innerWidth-$('#bloodWarnModal').parent().width())/2;
  var offsetTop=(window.innerHeight-$('#bloodWarnModal').parent().height())/2;
  $('#bloodWarnModal').dialog({
    left: offsetLeft,
    top: offsetTop
  }).dialog("open");
  $HUI.dialog('#bloodWarnModal').setTitle($g('新增宣教结果配置'));
  console.log($('#bwForm'));
  console.log($('#bwForm').form);
	$('#bwForm').form('reset')
	$("#id").val('');
	$('#bwForm').form('disableValidation')
}
//删除一行
function deleteBWRow(id) {
	var bwObj = $('#bloodWarn');
	$.messager.confirm($g("删除"), $g("确定要删除此条宣教结果配置吗？<br>此宣教结果配置删除后，执行宣教将不会带出该结果元素及其选项！"), function (r) {
		if (r) {
	    $cm({
        ClassName: 'CF.NUR.NIS.EduResultConfig',
        MethodName: 'DeleteEducation2ResultConfig',
        ID:id
	    }, function (data) {
	    	console.log(data);
	    	if (0==data) {
	    		$.messager.popover({msg: $g('删除成功！'),type:'success'});
					getBWTableData();
	    	} else {
	    		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
	    	}
	    });
		}
	});
}
// 选中数据引入表格
function selectBWRow(curInd) {
	selectBWIndex=curInd;
	$('#bloodWarn').datagrid('selectRow',curInd);
}
// 编辑数据引入表格
function editBWRow(curInd,row) {
	console.log(row);
	if (!row) {
		var bwObj = $('#bloodWarn');
		row=bwObj.datagrid('getSelected');
		if (!row) return $.messager.popover({msg: $g('请先选择行！'),type:'alert'});
	}
	// $HUI.dialog('#bloodWarnModal').open();
	addBWRow();
  $HUI.dialog('#bloodWarnModal').setTitle($g('修改宣教结果配置'));
	$("#id").val(row.id);
	$("#resultElement").val(row.resultElement);
	$("#entryType").combobox('setValue',row.entryType)
	$("#options").val(row.options);
	$("#blankFlag").checkbox('setValue',row.blankFlag?true:false);
	if (row.wardId) {
		docAdviceloader({q:row.wardDesc},successFunction,errorFunction);
		$("#validWard").combobox('setValue',row.wardId)
	}
	$('#bwForm').form('validate')
}
// 保存数据引入表格
function saveBWRow() {
	console.log($('#bwForm').form('validate'));
	$('#bwForm').form('enableValidation')
	if ($('#bwForm').form('validate')) {
		var options=$("#options").val().split('/');
    if (options.indexOf('')>-1) {
			return	$.messager.popover({msg: $g("备选项中的选项不能为空！"),type:'alert'});
    }
    var repeatObj={};
    for (var i = 0; i < options.length; i++) {
    	if (repeatObj[options[i]]) {
				return	$.messager.popover({msg: $g("备选项中的选项不能重复！"),type:'alert'});
    	} else {
    		repeatObj[options[i]]=1;
    	}
    }
		var obj={
			id:$("#id").val(),
			resultElement:$("#resultElement").val(),
			entryType:$("#entryType").combobox('getValue'),
			options:$("#options").val(),
			blankFlag:$("#blankFlag").checkbox('getValue')?1:"",
			validWard:$("#validWard").combobox('getValue'),
			userID:session['LOGON.USERID'],
			locID:session['LOGON.CTLOCID'],
			wardID:session['LOGON.WARDID'],
			hospID:hospID
		}
    $cm({
      ClassName: 'CF.NUR.NIS.EduResultConfig',
      MethodName: 'AddOrUpdateEducation2ResultConfig',
      dataType: "text",
      data:JSON.stringify(obj)
    }, function (data) {
    	console.log(data);
    	if (0==data) {
				$.messager.popover({msg: $g("数据保存成功！"),type:'success'});
    		$HUI.dialog('#bloodWarnModal').close();
    		getBWTableData();
    	} else {
				$.messager.popover({msg: data,type:'alert'});
    	}
    });
		return true;
	}
}
function resizeTableHeight() {
	var innerHeight=window.innerHeight;
	console.log(innerHeight);
  $('#bloodWarn').datagrid('resize',{
    height:innerHeight-90
	});
  $('#eduResPanel').panel('resize',{
    height:innerHeight-8
	});
}
setTimeout(resizeTableHeight,100);
window.addEventListener("resize",resizeTableHeight);
