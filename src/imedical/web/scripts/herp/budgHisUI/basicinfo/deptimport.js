addimportFun = function () {
	///////////////////配置项编码///////////////////////
	var hospid = session['LOGON.HOSPID'];
	var userid = session['LOGON.USERID'];
	var $importwin;
    $importwin = $('#importwin').window({
        title: 'Excel导入',
        width: 480,
        height: 250,
        top: ($(window).height() - 250) * 0.5,
        left: ($(window).width() - 480) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-w-import',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose:function(){ //关闭关闭窗口后触发
        	$('#excelpath').filebox("clear");
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $importwin.window('open');
 	$("#importSave").click(function(){
 		var filelist=$('#excelpath').filebox("files");
		if(filelist.length==0){
			$.messager.popover({
                msg: '请选择要导入的Excel!',
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
			return 
		}
		// showMask();
		var file = filelist[0];
  		var reader = new FileReader();
  		reader.readAsBinaryString(file);
        reader.onload = function(e) {
            if (reader.result){reader.content = reader.result;}
			//In IE browser event object is null
			var data = e ? e.target.result : reader.content;
            wb = XLSX.read(data, {
                    type: 'binary'
                });
            var json=to_json(wb)
//          console.log(json);
            if(json.total<2){
            	$.messager.popover({
	                msg: '要导入的Excel没有数据!',
	                type:'info',
	                showType:'show',
	                style:{
	                    "position":"absolute", 
	                    "z-index":"9999",
	                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
	                    top:10
	                }               
	            });
				return
            }else{
	            var errormsg="",data="",dataStr="";            	
            	for(i=1;i<=json.total-1;i++){
		            var tmp=""
		            var Code    = json.rows[i].BDEPT_Code==undefined?tmp:json.rows[i].BDEPT_Code;
		            var Name    = json.rows[i].BDEPT_Name==undefined?tmp:json.rows[i].BDEPT_Name;
		            var Class   = json.rows[i].BDEPT_Class==undefined?tmp:json.rows[i].BDEPT_Class;  //类别
		            var DirectDR= json.rows[i].BDEPT_DirectDR==undefined?tmp:json.rows[i].BDEPT_DirectDR;
		            var Level   = json.rows[i].BDEPT_Level==undefined?tmp:json.rows[i].BDEPT_Level;
		            var SupDeptID=json.rows[i].BDEPT_SupDeptID==undefined?tmp:json.rows[i].BDEPT_SupDeptID;
		            var IOFlag  = json.rows[i].BDEPT_IOFlag==undefined?tmp:json.rows[i].BDEPT_IOFlag; //门诊住院
		            var IsBudg  = json.rows[i].BDEPT_IsBudg==undefined?tmp:json.rows[i].BDEPT_IsBudg;  //是否归口科室
		            var State   = json.rows[i].BDEPT_State==undefined?tmp:json.rows[i].BDEPT_State;
		            var IsItem  = json.rows[i].BDEPT_IsItem==undefined?tmp:json.rows[i].BDEPT_IsItem;
		            var Pym     = json.rows[i].BDEPT_Pym==undefined?tmp:json.rows[i].BDEPT_Pym;
		            if(Pym==""){Pym=makePy(Name);}
		            var IsLast  = json.rows[i].BDEPT_IsLast==undefined?tmp:json.rows[i].BDEPT_IsLast;
		            var count="";
	            	count=i+2;
		            if(Code==""||Name==""||Class==""||Level==""||State==""||IsLast==""){
		            	if(errormsg==""){
		            		errormsg=count;
		            	}else{
		            		errormsg=errormsg+"、"+count;
		            	}
		            }else{
		            	dataStr=Code + "^" + Name+ "^" + Class + "^" + DirectDR + "^" + Level+ "^" + SupDeptID + "^" + IOFlag + "^" + IsBudg + "^" + State+ "^" + IsItem + "^" + Pym + "^" + IsLast+ "^" +count
		            	if(data==""){
		            		data = dataStr;
		            	}else{
		            		data = data + "|" + dataStr;
		            	}
		            }
            	}
            	if(errormsg!=""){
            		$.messager.popover({
		                msg: '第'+errormsg+'行数据不完整',
		                type:'error',
		                showType:'show',
		                style:{
		                    "position":"absolute", 
		                    "z-index":"9999",
		                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
		                    top:10
		                }               
		            });
					return
            	}else{
            		// console.log(data);
            		$.m({
			            ClassName:'herp.budg.hisui.udata.uBudgDeptSet',MethodName:'ExcelImport',data:data,hospid:hospid},
			                function(Data){
			                    if(Data==0){
			                    	$.messager.popover({
						                msg: '导入成功！',
						                type:'success',
						                showType:'show',
						                style:{
						                    "position":"absolute", 
						                    "z-index":"9999",
						                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
						                    top:10
						                }               
						            });
			                        $.messager.popover({msg: '导入成功！',type:'success'});
			                    }else{
			                        $.messager.popover({
						                msg: Data,
						                type:'error',
						                showType:'show',
						                style:{
						                    "position":"absolute", 
						                    "z-index":"9999",
						                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
						                    top:10
						                }               
						            });
			                    }
			                }
			        ); 
            	}
            }
            // hideMask();
            }
    	
        
        function to_json(workbook) {
			//取 第一个sheet 数据
		    var jsonData={};
			var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);
			jsonData.rows=result;
			jsonData.total=result.length
			return jsonData//JSON.stringify(jsonData);
		};
    
	});
	//关闭 
    $("#importClose").unbind('click').click(function(){
        $importwin.window('close');
    });

};
