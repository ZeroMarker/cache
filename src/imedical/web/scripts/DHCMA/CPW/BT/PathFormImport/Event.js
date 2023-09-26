//页面Event
function InitHISUIWinEvent(obj){
	//CheckSpecificKey();

	obj.ImportFileData = function(wb,fileName)
	{ 	
		var col=10;
		var formCode="",SaveTempFormErr="";
		
		var arrSheetList=wb.SheetNames;
		if (arrSheetList){
			for (var i=0;i<arrSheetList.length;i++){
				var	Sheet=wb.Sheets[arrSheetList[i]]
				
				var row=1,rowNull=0;			
				while (rowNull<5){
					var rowInfo="",colNull=0;
					for (var j=1;j<=col;j++){
						var p=String.fromCharCode(j+64)+row.toString();
						
						var cell=Sheet[p];
						var cellInfo=cell?cell.v:"";
						rowInfo = rowInfo + cellInfo + String.fromCharCode(9);
						if (cellInfo=='') colNull++;
					}
					if (colNull==col){
						rowNull++;
					}else{
						rowNull=0;
						var ret = $m({ClassName:"DHCMA.CPW.BTS.ImportPathWay",MethodName:"SaveTempFormNew",argCode:formCode,argRowInfo:rowInfo},false);   //objImport.SaveTempForm(formCode,rowInfo);
						if(parseFloat(ret)<0) {
							SaveTempFormErr="Row=" + row + ",ErrCode=" + ret + "!" + String.fromCharCode(13) + String.fromCharCode(10);
							break;
						}else{
							formCode=ret;
						}
					}
					row++;
				}				
			}
			if (formCode) {
					if (SaveTempFormErr){
						SaveTempFormErr="保存临床路径表单初始数据错误!File="+fileName+",Sheet="+arrSheetList[i] + "!" + String.fromCharCode(13) + String.fromCharCode(10) + SaveTempFormErr;
						$.messager.alert("错误提示", SaveTempFormErr, "error");
					}else{
						$.messager.popover({msg: "导入成功!File="+fileName+"!",type:'success',timeout: 3000});
					}
				}
		}
	   obj.admitList.load({
			ClassName:"DHCMA.CPW.BTS.ImportPathWay",
			QueryName:"QryTempFormData"
		});
	};
	//事件绑定
	obj.LoadEvents = function(arguments){
		$("#btnClear").on('click',function(){
			$('#file').filebox('clear');
			$("#btnSaveTmp").linkbutton("disable");
		});
		$("#btnSaveTmp").on('click',function(){
			var files=$('#file').filebox('files');
			for(var i=0,len=files.length;i<len;i++){
				getWorkBook(files[i],obj.ImportFileData)
			}
			
			
		});	
		$("#btnDelTmp").on('click',function(){			
			var ckData = $('#admitList').datagrid('getChecked');
			if(ckData==""){
				$.messager.alert("错误提示", "请选中要删除的临时表单！" , 'info');
				return
			}
			$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
				if (r) {
					for(var i = 0;i<ckData.length;i++)
					{
						var formCode=ckData[i].Code;
						var flg = $m({ClassName:"DHCMA.CPW.BTS.ImportPathWay",MethodName:"DeleteTempForm",argCode:formCode},false); 
						if (parseInt(flg)<0){
							alert("删除临时表单失败!Code="+formCode);
						}
					}
					obj.admitList.load({
						ClassName:"DHCMA.CPW.BTS.ImportPathWay",
						QueryName:"QryTempFormData"
					}); 	
				}
			});
		});	
		
		$("#btnSave").on('click',function(){
			//保存
			var ckData = $('#admitList').datagrid('getChecked');
			if(ckData==""){
				$.messager.alert("提示", "请选中要保存的临时表单！" , 'info');
				return
			}
			for(var i = 0;i<ckData.length;i++)
			{
				var formCode=ckData[i].Code;
				var CPWName=ckData[i].Desc;
				var flg = $m({ClassName:"DHCMA.CPW.BTS.ImportPathWay",MethodName:"SaveForm",argID:"",argCode:formCode},false); 
				if (parseFloat(flg)<0){
					$.messager.alert("错误提示", "保存正式表单失败!Code="+formCode+"Error:"+flg, "error");
				}else{
					$.messager.popover({msg: "保存正式表单成功!路径="+CPWName+"!",type:'success',timeout: 3000});
					//window.parent.RefreshLeftTree();  //add by zf 20120408
				}
			}
			obj.admitList.load({
				ClassName:"DHCMA.CPW.BTS.ImportPathWay",
				QueryName:"QryTempFormData"
			}); 
		});	
	};
}

