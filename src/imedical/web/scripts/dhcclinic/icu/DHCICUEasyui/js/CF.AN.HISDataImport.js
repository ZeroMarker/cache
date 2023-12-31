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
			title:"预览",
			fit:true,
			iconCls:"icon-paper",
			rownumbers:true,
			singleSelect:true,
			toolbar:"#surgeonTool",
			headerCls:"panel-header-gray",
			url:ANCSP.DataQuery,
			onBeforeLoad:function(param){
				param.ClassName=CLCLS.BLL.Admission;
				param.QueryName="FindCareProvByLoc";
				param.Arg1="";
				param.Arg2="";
				param.ArgCnt=2;
			},
			columns:[[
				{field:"UserInitials",title:"工号",width:80},
				{field:"Description",title:"姓名",width:90}
			]],
			onSelect:function(rowIndex,rowData){
			}
		});
	},

	initOperActions:function(){
		$("#selFile").filebox({
			width: 400,
			prompt: '请选择导入文件',
			buttonText: '选择',
			buttonAlign: 'left',
			plain: true,
			onChange:function(newValue,oldValue){
				var files=$("#selFile").filebox("files")
                if(files.length == 0) return;
                var f = files[0];
                if(!/\.xlsx$/g.test(f.name)) {
                    alert('仅支持读取xlsx格式！');
                    return;
                }
			}
		});
        
		$("#btnExportDataTemplate").linkbutton({
			onClick:function(){
				var $form = $('<form method="GET"></form>');
            	$form.attr('action', '../service/dhcanop/doc/手术资质导入.xlsx');
            	$form.appendTo($('body'));
            	$form.submit();
			}
		});
        
		$("#btnImportHISData").linkbutton({
			onClick:function(){
				var files=$("#selFile").filebox("files");
                if(files.length == 0){
					alert('请先选择文件再进行导入！')
					return;
				}
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
        
		$("#btnExportHISData").linkbutton({
			onClick:function(){
				count = 1;
			    var ExportDataName=$("#ExportDataName").val();
				if(ExportDataName=="") {
                    alert('请输入需要导出的数据表名称!');
                    return;
                }
				var aoa = []; // array of array
				var dataPara=dhccl.runServerMethod(ANCLS.BLL.OperQualificationManager,"FindHisData",ExportDataName);
				for (var fieldInd = 0; fieldInd < dataPara.length; fieldInd++) {
					var fieldArray = [];
					var columnField = dataPara[fieldInd];
					for(var key in columnField){
						fieldArray.push(columnField[key]);
					}
					aoa.push(fieldArray);
				}
				if (aoa.length > 0 && window.excelmgr) { 
					window.excelmgr.aoa2excel(aoa, "手术列表.xlsx");
				}
                //change();
			}
		});
	}
}
var count = 1;
var screewidth = document.body.clientWidth;
function change(){
    var nercon = document.getElementById("ner_con");
    var context = document.getElementById("context");
    var text_context = document.getElementById("text_context");
    //context.style.width = "100px";
	if(count!==Number(100)){
		//nercon.style.width=count+"px";
		count++;
		text_context.textContent=(parseFloat(count/100)*100).toFixed(2)+"px";
    }else{
		text_context.textContent="";
		return false;
	}
	setTimeout("change()",100);
}

function readWorkbookFromLocalFile(file, callback) {
	var reader = new FileReader();
	reader.onload = function(e) {
		var data = e.target.result;
		var workbook = XLSX.read(data, {type: 'binary'});
		workbook.SheetNames.forEach(function (sheetName) {
			var data = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName], { header: 1 });
			var operList = [];
			var errlog=""
            for (var i = 1; i < data.length; i++) {
				var ImportItem = data[i];
                if(ImportItem[0]==""){
					var count=i+1;
					errlog=InsertErrorLog(count,"表名称不能为空！！",errlog);
					continue;
				}
				var res=dhccl.runServerMethodNormal(ANCLS.BLL.OperQualificationManager,"ImportHisData",ImportItem);
				if(res.indexOf("S^")===0){
                }else{
					errlog=InsertErrorLog(i+1,res,errlog);
				}
			}
			if(errlog!=""){
                alert(errlog);
            }else{
                alert("导入完成")
            }
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