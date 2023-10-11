var tb,EHLMTableID,proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
var common={};
var tableName="Ens_HISLookUpMDMTab";
var GV={}
var  initSearchbox=function() { //工具条
	$("#ehlmSearch").appendTo(".datagrid-toolbar table tbody tr")
}
function getValInfo(value){// 是否包含 SQLUser.BDPTableList表中的className
	$.ajaxSettings.async = false;  
    var rtn="";  
	$.post(proxy,{action:"HISTableFlag",input: value},function(rs){
  		rtn=rs;
	})
	$.ajaxSettings.async = true;  
	return rtn;
}
$.extend($.fn.validatebox.defaults.rules, {//设置验证规则
	HISTable: {
          validator: function(value){//value 为输入框的值		           
			            var rs=getValInfo(value);
						if (rs== "1") {
		                    return true;
		                } 
		                else {
		                   return false;
		                }				
		            },
          message: 'BDPTableList表中没有对应数据'
     }

}) 
///files 文件列表对象
///多个文件会有多次回调
///cfg {allSheet:true , callbackOnce:true} //allSheet 读取所有sheet,默认只读第一个  callbackOnce是否一起回调 默认一个文件读取完成回调一个
///fn 回调函数 经测试 读取好像是异步的
///fn (json){} name 文件名 json {"文件名":[[{},{},{}],[{},{},{}],[{},{},{}]], "文件名":[[{},{},{}],[{},{},{}],[{},{},{}]]} //每个sheet返回一个数组 多个sheet的数组在放到同一数组
///bug 日期格式转的不对 表格中是1940-4-1 转出来是4/1/49  
//方案1 自己对转出的4/1/49日期再进行处理（49只能自己判断是1949还是2049了） 
// 方案2 可将xlsx.core中 e[14] = "m/d/yy"; 改为 e[14] = "YYYY-MM-DD"; （有没有其他影响不清楚） 
common.transExcelData=function(files,cfg,fn){
	var wb,rABS = false;
	if (typeof cfg=="function") {
		fn=cfg;
		cfg={}
	}
	cfg = cfg || {};
	function setup_reader(file) {
	 var filename = file.name;
	 var reader = new FileReader();
	 ///因为IE浏览器不识别readAsBinaryString函数，所以重新书写readAsBinaryString函数
	 if (!FileReader.prototype.readAsBinaryString) {
	     FileReader.prototype.readAsBinaryString = function (f) {
	         var binary = "";
	         var pt = this;
	         var reader = new FileReader();
	         reader.onload = function (e) {
	             var bytes = new Uint8Array(reader.result);
	             var length = bytes.byteLength;
	             for (var i = 0; i < length; i++) {
	                 binary += String.fromCharCode(bytes[i]);
	             }
	             pt.content = binary;
	             $(pt).trigger('onload');
	         };
	         reader.readAsArrayBuffer(f);
	     }
	 }

	 reader.onload = function (e) {
	     //alert("onload");
	     if (reader.result) reader.content = reader.result;
	     data = reader.content;
	     if (rABS) {
	         wb = XLSX.read(btoa(fixdata(data)), { //手动转化
	             type: 'base64'
	         });
	     } else {
	         wb = XLSX.read(data, {
	             type: 'binary'
	         });
	     }
	     var sheetArr=[];
	     if (cfg.allSheet){
		     for (var j=0,len=wb.SheetNames.length;j<len;j++){
			     var sheetItem=XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[j]]);
			     sheetArr.push(sheetItem);
			 }
		 }else{
			 var sheetItem=XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
			 sheetArr.push(sheetItem);
		 }
		 if (cfg.callbackOnce){
			 AllJson[filename]=sheetArr;
			 completedCount++;
			 if (length==completedCount && typeof fn=="function") fn(AllJson);
		 }else{
			 if (typeof fn=="function"){
				 var json={};
				 json[filename]=sheetArr;
				 fn(json);
			 }
		 }

	    
	 };

	 if (rABS) {
	     reader.readAsArrayBuffer(file);
	 } else {
	     reader.readAsBinaryString(file);
	 }

	 function fixdata(data) { //文件流转BinaryString
	     var o = "",
	         l = 0,
	         w = 10240;
	     for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
	     o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
	     return o;
	 }
	}
	var AllJson={};
	var length=files.length,completedCount=0
	for(var i=0;i<length;i++){
		setup_reader(files[i]);
	}
}
common.exportExcelWithName=(function(){
	
	function transrow(row,columns,ind,showHidden){
		var newrow={};
	    for (var i = 0; i < columns.length; i++) {
	        var cols = columns[i];
	        for (var j = 0; j < cols.length; j++) {
	            var col = cols[j];	    
	            if ((col.hidden && ! showHidden )|| !col.field) {
	                continue;
	            }else{
		            var key=col.title||col.field;
	                if (typeof col.formatter=="function"){
	                	if(col.editor){
	                		newrow[key]=row[col.field]||"";
	                	}else{
		                    var content= col.formatter(row[col.field]||"",row,ind);
							newrow[key]=content;	                		
	                	}
	                }else{
	                    newrow[key]=row[col.field]||"";
	                }
	            }
	        }
	    }
	    return newrow;
	}
	return function(rows, columns,cfg){
		cfg=cfg||{};
		cfg.sheetname=cfg.sheetname || "sheet1";
		cfg.filename=cfg.filename || "字典对照表";
		cfg.showHidden=!!cfg.showHidden;
		var newrows=[];
		for (var i=0,len=rows.length;i<len;i++){
			newrows.push(transrow(rows[i],columns,i,cfg.showHidden))
		}
		var wb = XLSX.utils.book_new();
		var sheet=XLSX.utils.json_to_sheet(newrows);
		XLSX.utils.book_append_sheet(wb, sheet, cfg.sheetname);		
		XLSX.writeFile(wb, cfg.filename+'.xlsx');

	}
})()

/**-----查询框-----**/
function searcherFun(value) {
   var queryvalue=value;
   $("#ehlmTable").datagrid("load",{input:value});
   $(initSearchbox());
}

/**-----加载表格数据-----**/
function loadTable() {
    GV.tb = $HUI.datagrid('#ehlmTable', {
	    fit:true,
	    //rownumbers:true,
        headerCls: 'panel-header-gray',
        singleSelect: true,
        pagination: true,
        fixRowNumber: true,
        idField: 'id',
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100],
        afterPageText: '页,共{pages}页', beforePageText: '第', displayMsg: '显示{from}到{to}条，共{total}条',
        fitColumns: true,
        url: proxy +"action=GetEHLMTableInfo&Input=",        
        columns: [[
            {field: 'EHLMTableID', title: '表ID',hidden:true },
            {field: 'EHLMMDMTableCode', title: 'MDM字典表代码'},
            {field: 'EHLMHISTableCode', title: 'HIS字典表代码'},
            {field: 'EHLMDescription', title: '描述'},
            {field: 'EHLMRemarks', title: '备注'},            
            {field: 'EHLMCreatDateTime', title: '创建日期时间'},
            {field: 'EHLMUpdateDateTime', title: '最后更新日期时间'},
        ]],
        toolbar: [{
            iconCls: 'icon-add', text: '新增', handler: function () {
	            $("#EHLMMDMTableCode").validatebox({required:true});
                $('#ehlmModal').dialog({
                    iconCls: 'icon-w-add',
                    title: '新增',
                }).dialog('open');
                 $("input[name='EHLMMDMTableCode']").removeAttr('readonly').css("background-color", "#fff");
                 $("#ehlmForm")[0].reset();
            	}
        	},
            {
            	iconCls: 'icon-edit', text: '编辑', handler: function () {
	            	//$('#EHLMMDMTableCode').validatebox('remove'); 
	            	$("#EHLMMDMTableCode").validatebox({required:false});
	                var row = GV.tb.getSelected();
	                
	                if (row) {
		                EHLMTableID=row.EHLMTableID;//表ID
		                
	                    $('#ehlmModal').dialog({
	                        iconCls: 'icon-w-edit',
	                        title: '修改',
	                    }).dialog('open');               
	                    $("input[name='EHLMMDMTableCode']").attr('readonly', 'readonly').css("background-color", "gainsboro");
	                    $("input[name='EHLMMDMTableCode']").val(row.EHLMMDMTableCode);
	                    $("input[name='EHLMHISTableCode']").val(row.EHLMHISTableCode);
	                    $("input[name='EHLMDescription']").val(row.EHLMDescription);
	                    $("input[name='EHLMRemarks']").val(row.EHLMRemarks);                
	                   
	                } else {
	                    $.messager.alert("错误", "请选择行");
	                }
	            }
            },{
                iconCls: 'icon-remove', text: '删除', handler: function () {
                var row = GV.tb.getSelected();
                if (row) {
                    $.messager.confirm("提示", "确认删除？", function (r) {
                        var input = row.EHLMTableID;
                        $.post(proxy,{action:"EHLMTableDelete",input: input},function(rs){
							if (rs.data == "1") {
	                            $.messager.alert("成功", "删除成功");
	                            GV.tb.reload();
	                        } else {
	                            $.messager.alert("成功", "删除失败<br>" + (rtn));
	                        }
				         },"json")
                    })
                } else {
                    $.messager.alert("错误", "请选择行");
                }
             }
            },
            {
                iconCls: 'icon-reload', text: '刷新', handler: function () {
                    GV.tb.reload();
                 }
            },{
                iconCls: 'icon-unload-cloud', text: '导入', handler: function () {                   
					$('#fileArea').empty();//清空File域
					$('<input id="file" class="hisui-filebox" name="file"/>').appendTo('#fileArea');
					$('#file').filebox({
						width:400,
						buttonText:'',
						buttonIcon:'icon-white-plus',
						prompt:'请选择excel文件',
						accept:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,text/csv',
						onChange:function(fileName){
							$("#confirm").linkbutton('enable');
						}
					}); 
					$("#confirm").linkbutton('disable');
					$('#importDig').dialog({
	                        iconCls: 'icon-unload-cloud',
	                        title: '导入',
	                 }).dialog('open');   
					//$('#importDig').dialog('open');
                 }
            },{
                iconCls: 'icon-upload-cloud', text: '导出', handler: function () {
				    GV.tb.unselectAll();
					var currentURL=GV.tb.options().url;
					var queryObj=GV.tb.options().queryParams;
					queryObj.page="1";
					queryObj.rows="40000";
					$.post(currentURL,queryObj,null,"json").done(function(rtn){
						var columns=GV.tb.options().columns;
						console.info('columns',columns,rtn);
						console.info('rtn.rows',rtn.rows);
						common.exportExcelWithName(rtn.rows,columns,{filename:tableName+'(所有数据)',showHidden:true});
						
					});
					
                 }
            }
        ], 
    });
     $(initSearchbox());	
}
/**-----初始化模态框-----**/
function modalInit() {
    $('#ehlmModal').dialog({
        buttons: [{
	        id:'saved',
            text: '保存',
            handler: function () {
	            var title=$(".window-header .panel-title").text();
                if (title.indexOf("新增") != -1 ) {
                    var input =JSON.stringify( $("#ehlmForm").serializeArray()) 
                    $.post(proxy,{action:"EHLMTableInsert",input: input},function(rs){
							if (rs.data == "1") {
		                        $('#ehlmModal').dialog('close');
		                     	GV.tb.reload();

		                    } else {
		                        $.messager.alert("错误",rs.data);
		                    }
				     },"json")  
				         					
                    
                } else if(title.indexOf("修改") != -1){	                
                    var input = JSON.stringify( $("#ehlmForm").serializeArray())
                    input=EHLMTableID+"^"+input;
                    $.post(proxy,{action:"EHLMTableUpdate",input: input},function(rs){
							if (rs.data == "1") {
		                        $('#ehlmModal').dialog('close');

		                     	GV.tb.reload()

		                    } else {
		                        $.messager.alert("错误",rs.data);
		                    } 
				     },"json")                      
                }
            }
        }, {
	        id:'closed',
            text: '关闭',
            handler: function () {
                $('#ehlmModal').dialog('close');
            }
        }]
    });

}
//表格-导入（导入数据（excel）
GV.import=function(json){
	function submitRows(allrows,start,limit){// 将读到的结果保存到后台，调用后台方法(所有的json对象数组，起始位置，每次保存的数量)
		var data='',cnt=0,dataArr=[];
		for (var i= start,len=allrows.length; i<len && i<start+limit; i++ ){
			dataArr[cnt]=allrows[i];
			cnt++;
		}
		data=JSON.stringify(dataArr);
		// [{"MDM字典代码":"CTDept","HIS字典代码":"CTDept","描述":"科室字典表","备注":"代码一致"},{"MDM字典代码":"CTDeptClass","HIS字典代码":"CTDeptClass","描述":"科室类别字典表","备注":"代码一致"}]
        var input=start+"&"+data;
		if (cnt>0){
             $.post(proxy,{action:"ExcelImportTable",input: input},function(rtn){
	            for(var i=0;i<rtn.info.length;i++){
					result.info.push(rtn.info[i]);
		         }
			    result.fail+=rtn.fail;
				result.total+=rtn.total;
				submitRows(allrows,start+cnt,limit);
				var percent=10+Math.floor(90*(start+cnt)/allrows.length);
				$('#pBar').progressbar('setValue',percent);	
	         },"json")
           
		}else{
			showImportResult(result);
		}
	}
	function showImportResult(result){	//显示导入结果
		var html="<div>导入总数:&nbsp;"+result.total+"&nbsp;&nbsp;&nbsp;&nbsp;成功:&nbsp;"+(result.total-result.fail)+"&nbsp;&nbsp;&nbsp;&nbsp;失败:&nbsp;"+result.fail+"</div>"
		html+="<table style='width:100%;'><tr><td>序号</td><td>错误代码</td><td>错误原因</td></tr>",
			success=true,
			cnt=0;
		if(result.fail==0){
			//全部成功
			$.messager.alert('成功','全部导入成功','info');
			GV.tb.reload();
		}else{
			success=false;
			//部分成功或者全部失败
			for(var i=0;i<result.fail;i++){
				cnt++;
				var tr="<tr><td>"+cnt+"</td><td>"+result.info[i].code+"</td><td>"+result.info[i].desc+"</td></tr>";
				html+=tr;
			}
			html+="</table>";
		}	
		$('#importDig').dialog('close');
		$('#pBar').parent().hide();
		$('#pBar').progressbar('setValue',0);	
		$("#importDig").find(".dialog-button .l-btn").eq(0).linkbutton('enable');		
		if (!success){
			GV.tb.reload();
			if($('#importResultWin').length==0) $('<div id="importResultWin"></div>').appendTo('body');
			$('#importResultWin').dialog({
				title:'导入错误列表',
				//width:1000,
				//height:400,
				fit:true,
				content:html
			}).dialog('open');
		}
	}
	
	var allrows=[],result={};
	result.info=[],result.total=0,result.fail=0;
	// 将多层的json转换成数组
	for (var i in json){  //循环文件 
		var sheetrows=json[i][0];
		var newsheetrow=[];
		var len=sheetrows.length;
		for (var j=0;j<len;j++){
			newsheetrow[j]={};
			for(var item in sheetrows[j]){
				var value=sheetrows[j][item].replace(/(^\s*)|(\s*$)/g, "");
				var newItem=item.replace(/(^\s*)|(\s*$)/g, "");
 				
				newsheetrow[j][newItem]=value;
			}
			allrows.push(newsheetrow[j] );// 将读到的每一行转换成对象组成的数组
		
		}
	}
	$('#pBar').progressbar('setValue',10);
	// 每一百条调用一次后台方法进行保存
	submitRows(allrows,0,5);
}
$(function () {
   loadTable();//加载表格数据
   modalInit();//初始化模态框   
   $("#importDig").dialog({//初始化导入模态框
		buttons:[{
			id:'confirm',
			text:'确定',
			handler:function(){
				var files=$('#file').filebox('files');
				if(files && files.length>0){
					$('#pBar').parent().show();
					$('#pBar').progressbar({value:0});
					$('#pBar').progressbar('setValue',0);	
					$('#confirm').linkbutton('disable');
				}else{
					$.messager.alert("错误", "请至少选择一个文件");
				}
				common.transExcelData(files,GV.import);
			}
			
		},{
			id:'cancel',
			text:'取消',
			handler:function(){$HUI.dialog('#importDig').close();}
			
		 }]
   })	
})