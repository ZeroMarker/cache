var tb,EHLMTableID,proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
var common={};
var tableName="Ens_HISLookUpMDMTab";
var GV={}
var  initSearchbox=function() { //������
	$("#ehlmSearch").appendTo(".datagrid-toolbar table tbody tr")
}
function getValInfo(value){// �Ƿ���� SQLUser.BDPTableList���е�className
	$.ajaxSettings.async = false;  
    var rtn="";  
	$.post(proxy,{action:"HISTableFlag",input: value},function(rs){
  		rtn=rs;
	})
	$.ajaxSettings.async = true;  
	return rtn;
}
$.extend($.fn.validatebox.defaults.rules, {//������֤����
	HISTable: {
          validator: function(value){//value Ϊ������ֵ		           
			            var rs=getValInfo(value);
						if (rs== "1") {
		                    return true;
		                } 
		                else {
		                   return false;
		                }				
		            },
          message: 'BDPTableList����û�ж�Ӧ����'
     }

}) 
///files �ļ��б����
///����ļ����ж�λص�
///cfg {allSheet:true , callbackOnce:true} //allSheet ��ȡ����sheet,Ĭ��ֻ����һ��  callbackOnce�Ƿ�һ��ص� Ĭ��һ���ļ���ȡ��ɻص�һ��
///fn �ص����� ������ ��ȡ�������첽��
///fn (json){} name �ļ��� json {"�ļ���":[[{},{},{}],[{},{},{}],[{},{},{}]], "�ļ���":[[{},{},{}],[{},{},{}],[{},{},{}]]} //ÿ��sheet����һ������ ���sheet�������ڷŵ�ͬһ����
///bug ���ڸ�ʽת�Ĳ��� �������1940-4-1 ת������4/1/49  
//����1 �Լ���ת����4/1/49�����ٽ��д���49ֻ���Լ��ж���1949����2049�ˣ� 
// ����2 �ɽ�xlsx.core�� e[14] = "m/d/yy"; ��Ϊ e[14] = "YYYY-MM-DD"; ����û������Ӱ�첻����� 
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
	 ///��ΪIE�������ʶ��readAsBinaryString����������������дreadAsBinaryString����
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
	         wb = XLSX.read(btoa(fixdata(data)), { //�ֶ�ת��
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

	 function fixdata(data) { //�ļ���תBinaryString
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
		cfg.filename=cfg.filename || "�ֵ���ձ�";
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

/**-----��ѯ��-----**/
function searcherFun(value) {
   var queryvalue=value;
   $("#ehlmTable").datagrid("load",{input:value});
   $(initSearchbox());
}

/**-----���ر������-----**/
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
        afterPageText: 'ҳ,��{pages}ҳ', beforePageText: '��', displayMsg: '��ʾ{from}��{to}������{total}��',
        fitColumns: true,
        url: proxy +"action=GetEHLMTableInfo&Input=",        
        columns: [[
            {field: 'EHLMTableID', title: '��ID',hidden:true },
            {field: 'EHLMMDMTableCode', title: 'MDM�ֵ�����'},
            {field: 'EHLMHISTableCode', title: 'HIS�ֵ�����'},
            {field: 'EHLMDescription', title: '����'},
            {field: 'EHLMRemarks', title: '��ע'},            
            {field: 'EHLMCreatDateTime', title: '��������ʱ��'},
            {field: 'EHLMUpdateDateTime', title: '����������ʱ��'},
        ]],
        toolbar: [{
            iconCls: 'icon-add', text: '����', handler: function () {
	            $("#EHLMMDMTableCode").validatebox({required:true});
                $('#ehlmModal').dialog({
                    iconCls: 'icon-w-add',
                    title: '����',
                }).dialog('open');
                 $("input[name='EHLMMDMTableCode']").removeAttr('readonly').css("background-color", "#fff");
                 $("#ehlmForm")[0].reset();
            	}
        	},
            {
            	iconCls: 'icon-edit', text: '�༭', handler: function () {
	            	//$('#EHLMMDMTableCode').validatebox('remove'); 
	            	$("#EHLMMDMTableCode").validatebox({required:false});
	                var row = GV.tb.getSelected();
	                
	                if (row) {
		                EHLMTableID=row.EHLMTableID;//��ID
		                
	                    $('#ehlmModal').dialog({
	                        iconCls: 'icon-w-edit',
	                        title: '�޸�',
	                    }).dialog('open');               
	                    $("input[name='EHLMMDMTableCode']").attr('readonly', 'readonly').css("background-color", "gainsboro");
	                    $("input[name='EHLMMDMTableCode']").val(row.EHLMMDMTableCode);
	                    $("input[name='EHLMHISTableCode']").val(row.EHLMHISTableCode);
	                    $("input[name='EHLMDescription']").val(row.EHLMDescription);
	                    $("input[name='EHLMRemarks']").val(row.EHLMRemarks);                
	                   
	                } else {
	                    $.messager.alert("����", "��ѡ����");
	                }
	            }
            },{
                iconCls: 'icon-remove', text: 'ɾ��', handler: function () {
                var row = GV.tb.getSelected();
                if (row) {
                    $.messager.confirm("��ʾ", "ȷ��ɾ����", function (r) {
                        var input = row.EHLMTableID;
                        $.post(proxy,{action:"EHLMTableDelete",input: input},function(rs){
							if (rs.data == "1") {
	                            $.messager.alert("�ɹ�", "ɾ���ɹ�");
	                            GV.tb.reload();
	                        } else {
	                            $.messager.alert("�ɹ�", "ɾ��ʧ��<br>" + (rtn));
	                        }
				         },"json")
                    })
                } else {
                    $.messager.alert("����", "��ѡ����");
                }
             }
            },
            {
                iconCls: 'icon-reload', text: 'ˢ��', handler: function () {
                    GV.tb.reload();
                 }
            },{
                iconCls: 'icon-unload-cloud', text: '����', handler: function () {                   
					$('#fileArea').empty();//���File��
					$('<input id="file" class="hisui-filebox" name="file"/>').appendTo('#fileArea');
					$('#file').filebox({
						width:400,
						buttonText:'',
						buttonIcon:'icon-white-plus',
						prompt:'��ѡ��excel�ļ�',
						accept:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,text/csv',
						onChange:function(fileName){
							$("#confirm").linkbutton('enable');
						}
					}); 
					$("#confirm").linkbutton('disable');
					$('#importDig').dialog({
	                        iconCls: 'icon-unload-cloud',
	                        title: '����',
	                 }).dialog('open');   
					//$('#importDig').dialog('open');
                 }
            },{
                iconCls: 'icon-upload-cloud', text: '����', handler: function () {
				    GV.tb.unselectAll();
					var currentURL=GV.tb.options().url;
					var queryObj=GV.tb.options().queryParams;
					queryObj.page="1";
					queryObj.rows="40000";
					$.post(currentURL,queryObj,null,"json").done(function(rtn){
						var columns=GV.tb.options().columns;
						console.info('columns',columns,rtn);
						console.info('rtn.rows',rtn.rows);
						common.exportExcelWithName(rtn.rows,columns,{filename:tableName+'(��������)',showHidden:true});
						
					});
					
                 }
            }
        ], 
    });
     $(initSearchbox());	
}
/**-----��ʼ��ģ̬��-----**/
function modalInit() {
    $('#ehlmModal').dialog({
        buttons: [{
	        id:'saved',
            text: '����',
            handler: function () {
	            var title=$(".window-header .panel-title").text();
                if (title.indexOf("����") != -1 ) {
                    var input =JSON.stringify( $("#ehlmForm").serializeArray()) 
                    $.post(proxy,{action:"EHLMTableInsert",input: input},function(rs){
							if (rs.data == "1") {
		                        $('#ehlmModal').dialog('close');
		                     	GV.tb.reload();

		                    } else {
		                        $.messager.alert("����",rs.data);
		                    }
				     },"json")  
				         					
                    
                } else if(title.indexOf("�޸�") != -1){	                
                    var input = JSON.stringify( $("#ehlmForm").serializeArray())
                    input=EHLMTableID+"^"+input;
                    $.post(proxy,{action:"EHLMTableUpdate",input: input},function(rs){
							if (rs.data == "1") {
		                        $('#ehlmModal').dialog('close');

		                     	GV.tb.reload()

		                    } else {
		                        $.messager.alert("����",rs.data);
		                    } 
				     },"json")                      
                }
            }
        }, {
	        id:'closed',
            text: '�ر�',
            handler: function () {
                $('#ehlmModal').dialog('close');
            }
        }]
    });

}
//���-���루�������ݣ�excel��
GV.import=function(json){
	function submitRows(allrows,start,limit){// �������Ľ�����浽��̨�����ú�̨����(���е�json�������飬��ʼλ�ã�ÿ�α��������)
		var data='',cnt=0,dataArr=[];
		for (var i= start,len=allrows.length; i<len && i<start+limit; i++ ){
			dataArr[cnt]=allrows[i];
			cnt++;
		}
		data=JSON.stringify(dataArr);
		// [{"MDM�ֵ����":"CTDept","HIS�ֵ����":"CTDept","����":"�����ֵ��","��ע":"����һ��"},{"MDM�ֵ����":"CTDeptClass","HIS�ֵ����":"CTDeptClass","����":"��������ֵ��","��ע":"����һ��"}]
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
	function showImportResult(result){	//��ʾ������
		var html="<div>��������:&nbsp;"+result.total+"&nbsp;&nbsp;&nbsp;&nbsp;�ɹ�:&nbsp;"+(result.total-result.fail)+"&nbsp;&nbsp;&nbsp;&nbsp;ʧ��:&nbsp;"+result.fail+"</div>"
		html+="<table style='width:100%;'><tr><td>���</td><td>�������</td><td>����ԭ��</td></tr>",
			success=true,
			cnt=0;
		if(result.fail==0){
			//ȫ���ɹ�
			$.messager.alert('�ɹ�','ȫ������ɹ�','info');
			GV.tb.reload();
		}else{
			success=false;
			//���ֳɹ�����ȫ��ʧ��
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
				title:'��������б�',
				//width:1000,
				//height:400,
				fit:true,
				content:html
			}).dialog('open');
		}
	}
	
	var allrows=[],result={};
	result.info=[],result.total=0,result.fail=0;
	// ������jsonת��������
	for (var i in json){  //ѭ���ļ� 
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
			allrows.push(newsheetrow[j] );// ��������ÿһ��ת���ɶ�����ɵ�����
		
		}
	}
	$('#pBar').progressbar('setValue',10);
	// ÿһ��������һ�κ�̨�������б���
	submitRows(allrows,0,5);
}
$(function () {
   loadTable();//���ر������
   modalInit();//��ʼ��ģ̬��   
   $("#importDig").dialog({//��ʼ������ģ̬��
		buttons:[{
			id:'confirm',
			text:'ȷ��',
			handler:function(){
				var files=$('#file').filebox('files');
				if(files && files.length>0){
					$('#pBar').parent().show();
					$('#pBar').progressbar({value:0});
					$('#pBar').progressbar('setValue',0);	
					$('#confirm').linkbutton('disable');
				}else{
					$.messager.alert("����", "������ѡ��һ���ļ�");
				}
				common.transExcelData(files,GV.import);
			}
			
		},{
			id:'cancel',
			text:'ȡ��',
			handler:function(){$HUI.dialog('#importDig').close();}
			
		 }]
   })	
})