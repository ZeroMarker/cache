var qm={
	init:function(){
		if (!FileReader.prototype.readAsBinaryString) {
			FileReader.prototype.readAsBinaryString = function (fileData) {
			   var binary = "";
			   var pt = this;
			   var reader = new FileReader();      
			   reader.onload = function (e) {
				   var bytes = new Uint8Array(reader.result);
				   var length = bytes.byteLength;
				   for (var i = 0; i < length; i++) {
					   binary += String.fromCharCode(bytes[i]);
				   }
		
				//pt.result  - readonly so assign binary
		
				// pt.content = binary;
		
				// $(pt).trigger('onload');
				var e={target:{result:binary}};
				pt.onload(e)
		
			}
		
			reader.readAsArrayBuffer(fileData);
		
			}
		
		}
		qm.initCareProvBox();
		qm.initCareProvOperBox();
		qm.initOperBox();
		qm.initOperActions();
	},

	initCareProvBox:function(){
		
		$("#importBox").datagrid({
			title:"导入",
			fit:true,
			iconCls:"icon-paper",
			toolbar:"#importTool",
			headerCls:"panel-header-gray",
		});
		
		$("#surgeonBox").datagrid({
			title:"手术医生",
			fit:true,
			// pagination:true,
			iconCls:"icon-paper",
			rownumbers:true,
			
			singleSelect:true,
			// pageSize:20,
			toolbar:"#surgeonTool",
			headerCls:"panel-header-gray",
			url:ANCSP.DataQuery,
			onBeforeLoad:function(param){
				var deptId=$("#surgeonDept").combobox("getValue");
				if(!deptId){
					return false;
				}
				param.ClassName=CLCLS.BLL.Admission;
				param.QueryName="FindCareProvByLoc";
				param.Arg1=$("#surgeonName").val();
				param.Arg2=deptId;
				param.ArgCnt=2;
			},
			columns:[[
				{field:"UserInitials",title:"工号",width:80},
				{field:"Description",title:"姓名",width:90}
			]],
			onSelect:function(rowIndex,rowData){
				$("#surgeonOperBox").datagrid("reload");
			}
		});

		$("#surgeonDept").combobox({
			valueField:"RowId",
			textField:"Description",
			mode:"remote",
			url:ANCSP.DataQuery,
			onBeforeLoad:function(param){
				param.ClassName=CLCLS.BLL.Admission;
				param.QueryName="FindLocationOld";
				param.Arg1=param.q?param.q:"";
				param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
				param.ArgCnt=2;
			},
			onSelect:function(record){
				$("#surgeonBox").datagrid("reload");
			}
		});
	},

	initCareProvOperBox:function(){
		$("#surgeonOperBox").datagrid({
			title:"授权的手术",
			fit:true,
			headerCls:"panel-header-gray",
			iconCls:"icon-paper",
			toolbar:"#surgeonOperTool",
			// pagination:true,
			rownumbers:true,
			// singleSelect:true,
			// pageSize:20,
			url:ANCSP.DataQuery,
			onBeforeLoad:function(param){
				var selectedCareProv=$("#surgeonBox").datagrid("getSelected");
				if(!selectedCareProv){
					return false;
				}
				var deptId=$("#surgeonDept").combobox("getValue");
				if(!deptId){
					return false;
				}
				param.ClassName=ANCLS.BLL.OperQualificationManager;
				param.QueryName="FindSurgeonOperations";
				param.Arg1=selectedCareProv.RowId;
				param.Arg2=deptId;
				param.Arg3=$("#filterOrderDesc").val();
				param.Arg4=$("#filterOrderOperClass").combobox("getValue");
				param.ArgCnt=4;
			},
			columns:[[
				{field:"CheckStatus",title:"选择",checkbox:true},
				{field:"OperationDesc",title:"手术名称",width:240},
				{field:"OperClassDesc",title:"分级",width:68},
				{field:"ICD10Desc",title:"ICD10",width:100} 
			]]
		});
	},

	initOperBox:function(){
		$("#operBox").datagrid({
			title:"手术字典",
			fit:true,
			pagination:true,
			rownumbers:true,
			headerCls:"panel-header-gray",
			iconCls:"icon-paper",
			toolbar:"#operTool",
			pageSize:20,
			url:ANCSP.DataQuery,
			onBeforeLoad:function(param){
				param.ClassName=ANCLS.BLL.CodeQueries;
				param.QueryName="FindOperation";
				param.Arg1=$("#filterDesc").val();
				param.Arg2=$("#filterOperClass").combobox("getValue");
				param.ArgCnt=2;
			},
			columns:[[
				{field:"CheckStatus",title:"选择",checkbox:true},
				{field:"Description",title:"手术名称",width:240},
				{field:"OperClassDesc",title:"分级",width:68},
				{field:"ICD10Desc",title:"ICD10",width:100}
			]]
		});

		$("#filterOperClass,#filterOrderOperClass").combobox({
			valueField:"RowId",
			textField:"Description",
			url:ANCSP.DataQuery,
			onBeforeLoad:function(param){
				param.ClassName=ANCLS.BLL.CodeQueries;
				param.QueryName="FindOperClass";
				param.ArgCnt=0;
			}
		});
	},

	initOperActions:function(){
		$("#btnFindSurgeon").linkbutton({
			onClick:function(){
				var deptId=$("#surgeonDept").combobox("getValue");
				if(!deptId){
					$.messager.alert("提示","请先选择科室，再查询手术医生。","warning");
					return;
				}
				$("#surgeonBox").datagrid("reload");
			}
		});

		$("#btnFindSurgeonOper").linkbutton({
			onClick:function(){
				$("#surgeonOperBox").datagrid("reload");
			}
		});

		$("#btnFindOperation").linkbutton({
			onClick:function(){
				$("#operBox").datagrid("reload");
			}
		});

		$("#btnAddClassOperation").linkbutton({
			onClick:function(){
				var selectedCareProv=$("#surgeonBox").datagrid("getSelected");
				var deptId=$("#surgeonDept").combobox("getValue");
				var OperClassId=$("#filterOperClass").combobox("getValue");
				if(!selectedCareProv){
					$.messager.alert("提示","还未选择手术医生，请选择后再操作。","warning");
					return;
				}
				if(OperClassId==""){
					$.messager.alert("提示","还未选择授权的手术级别，请选择后再操作。","warning");
					return;
				}
				var res=dhccl.runServerMethodNormal(ANCLS.BLL.OperQualificationManager,"SaveClassOperation",selectedCareProv.RowId,OperClassId,deptId);
				if(res===""){
					$.messager.popover({msg:"关联手术成功。",type:'success',timeout:1500});
					$("#operBox").datagrid("clearChecked");
					$("#surgeonOperBox").datagrid("reload");
				}else{
					$.messager.alert("提示","关联手术失败，原因："+res,"warning");
				}
			}
		});

		$("#btnImportSurgeonOperation").linkbutton({
			onClick:function(){
				var $form = $('<form method="GET"></form>');
            	$form.attr('action', '../service/dhcanop/doc/手术资质导入.xlsx');
            	$form.appendTo($('body'));
            	$form.submit();
			}
		});

		$("#btnAddSurgeonOperation").linkbutton({
			onClick:function(){
				var selectedOperRows=$("#operBox").datagrid("getChecked");
				var selectedCareProv=$("#surgeonBox").datagrid("getSelected");
				var deptId=$("#surgeonDept").combobox("getValue");
				if(!selectedCareProv){
					$.messager.alert("提示","还未选择手术医生，请选择后再操作。","warning");
					return;
				}
				if(!selectedOperRows || !selectedOperRows.length || selectedOperRows.length===0){
					$.messager.alert("提示","还未选择要关联的手术，请选择后再操作。","warning");
					return;
				}

				var linkOperArr=[],valueChar=String.fromCharCode(1),dataChar=String.fromCharCode(2);
				for(var i=0;i<selectedOperRows.length;i++){
					linkOperArr.push([
						selectedCareProv.RowId,
						selectedOperRows[i].RowId,
						deptId
					].join(valueChar));
				}

				var jsonDataStr=linkOperArr.join(dataChar);
				var res=dhccl.runServerMethodNormal(ANCLS.BLL.OperQualificationManager,"SaveSurgeonOperations",jsonDataStr);
				if(res.indexOf("S^")===0){
					$.messager.popover({msg:"关联手术成功。",type:'success',timeout:1500});
					$("#operBox").datagrid("clearChecked");
					$("#surgeonOperBox").datagrid("reload");
				}else{
					$.messager.alert("提示","关联手术失败，原因："+res,"warning");
				}
			}
		});
		

		$("#btnDelSurgeonOperation").linkbutton({
			onClick:function(){
				var selectedSurgeonOpers=$("#surgeonOperBox").datagrid("getChecked");
				if(!selectedSurgeonOpers || !selectedSurgeonOpers.length || selectedSurgeonOpers.length<1){
					$.messager.alert("提示","请勾选要取消授权的手术，再进行操作。","warning");
					return;
				}

				$.messager.confirm("提示","是否将勾选的手术取消授权？",function(r){
					if(r){
						var surgeonOperIdArr=[];
						for(var i=0;i<selectedSurgeonOpers.length;i++){
							surgeonOperIdArr.push(selectedSurgeonOpers[i].RowId);
						}

						var idStr=surgeonOperIdArr.join(String.fromCharCode(1));
						var res=dhccl.runServerMethodNormal(ANCLS.BLL.OperQualificationManager,"DeleteSurgeonOperation",idStr);
						if(res.indexOf("S^")===0){
							$.messager.popover({msg:"手术取消授权成功",type:"success",timeout:1500});
							$("#surgeonOperBox").datagrid("clearChecked");
							$("#surgeonOperBox").datagrid("reload");
						}else{
							$.messager.alert("提示","手术取消授权失败，原因："+res,"error");
						}
					}
				});
				
			}
		});
		$("#selFile").filebox({
			width: 400,
			prompt: '请选择文件',
			buttonText: '选择',
			buttonAlign: 'left',
			plain: true,
			onChange:function(newValue,oldValue){
				var files=$("#selFile").filebox("files")
				
					
					//var files = e.target.files;
					if(files.length == 0) return;
					var f = files[0];
					if(!/\.xlsx$/g.test(f.name)) {
						alert('仅支持读取xlsx格式！');
						return;
					}
					readWorkbookFromLocalFile(f, function(workbook) {
						readWorkbook(workbook);
					});
			}
		});
	}
}
/*
function onClickButton()
{

}
$(function() {
	document.getElementById('selFile').addEventListener('change', function(e) {
		var files = e.target.files;
		if(files.length == 0) return;
		var f = files[0];
		if(!/\.xlsx$/g.test(f.name)) {
			alert('仅支持读取xlsx格式！');
			return;
		}
		readWorkbookFromLocalFile(f, function(workbook) {
			readWorkbook(workbook);
		});
	});
});*/

function readWorkbookFromLocalFile(file, callback) {
	var reader = new FileReader();
	reader.onload = function(e) {
		var data = e.target.result;
		var workbook = XLSX.read(data, {type: 'binary'});
		workbook.SheetNames.forEach(function (sheetName) {
			var data = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName], { header: 1 });
			var operList = [];
            function getIndex(firstRow, name) {
                for (var i = 0; i < firstRow.length; i++) {
                    if (firstRow[i] == name) {
                         return i;
                    }
                }
                return -1;
			}
			var errlog=""
			for (var i = 1; i < data.length; i++) {
				var item = data[i];
				if(item[0]=="") 
				{
					var count=i+1;
					errlog=InsertErrorLog(count,"科室不能为空！！",errlog);
					continue;
				}
				if(item[1]=="") 
				{
					var count=i+1;
					errlog=InsertErrorLog(count,"医生工号不能为空！！",errlog);
					continue;
				}
				if(item[2]=="")
				{
					var count=i+1;
					errlog=InsertErrorLog(count,"手术不能为空！！",errlog);
					continue;
				}
				var res=dhccl.runServerMethodNormal(ANCLS.BLL.OperQualificationManager,"ImportDeptOperation",item[0],item[1],item[2]);
				if(res.indexOf("S^")===0)
				{}
				else
				{
					errlog=InsertErrorLog(i+1,res,errlog);
				}
			}
			if(errlog!="") alert(errlog);
		})
	};
	reader.readAsBinaryString(file);
}

function InsertErrorLog(count,errlog,result)
{
	if(result=="")  result="第"+count+"行导入失败,原因"+errlog
	else result=result+"\r\n"+"第"+count+"行导入失败,原因"+errlog
	return result
}
//上传文件操作
function UploadFile(_obj, file_ctrlname, guid_ctrlname, div_files,value) {
	//var value = $("#" + file_ctrlname).filebox('getValue');
	var files = $("#" + file_ctrlname).next().find('input[type=file]')[0].files;
	//console.log(files);

	//传入this参数，也可以用这个获取文件
	var files = $(_obj).context.ownerDocument.activeElement.files;
	//console.log(files);
	var xApp = new ActiveXObject("Excel.application"); 
	var xBooks = xApp.Workbooks.open(files);   
	var guid = $("#" + guid_ctrlname).val();
	if (value && files[0]) {
		//构建一个FormData存储复杂对象
		var formData = new FormData();
		formData.append("folder", '数据导入文件');
		formData.append("guid", guid);
		formData.append('Filedata', files[0]);//默认的文件数据名为“Filedata”

		$.ajax({
			url: '/FileUpload/Upload', //单文件上传
			type: 'POST',
			processData: false,
			contentType: false,
			data: formData,
			success: function (json) {                        
				//转义JSON为对象
				var data = $.parseJSON(json);

				//提示用户Excel格式是否正常，如果正常加载数据
				ShowUpFiles(guid, div_files);

				$.ajax({
					url: '/BillDetail_Cust/CheckExcelColumns?guid=' + guid,
					type: 'get',
					dataType:'json',
					success: function (data) {
						if (data.Success) {                                
							InitGrid(); //重新刷新表格数据
							showTips("文件已上传，数据加载完毕！");
						}
						else {
							showTips("上传的Excel文件检查不通过。请根据页面右上角的Excel模板格式进行数据录入。");
						}
					}
				});          
			},
			error: function (xhr, status, error) {
				$.messager.alert("提示", "操作失败"); //xhr.responseText
			}
		});
	}
}
$(document).ready(qm.init);