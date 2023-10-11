//页面Event
function InitHISUIWinEvent(obj){
	//CheckSpecificKey();
	obj.ImportFileData = function(wb,fileName)
	{ 	
		var col=31;
		var formCode="",SaveTempFormErr="";
		//var formCode=fileName.split("-")[0];	//取文件上的*-路径名的*
		var arrSheetList=wb.SheetNames;
		if (!wb.Sheets[arrSheetList[0]][String.fromCharCode(2+64)+"1".toString()]){
			$.messager.alert("错误提示", "发布年份为空，请补充" , 'info');
			return
		}
		var Year=wb.Sheets[arrSheetList[0]][String.fromCharCode(2+64)+"1".toString()].v
		var aCode=Year+"^"+fileName.split("-")[0];  //取文件上的*-路径名的*
		if (arrSheetList){
			for (var i=0;i<arrSheetList.length;i++){
				var	Sheet=wb.Sheets[arrSheetList[i]]
				
				var row=1,rowNull=0;			
				while (rowNull<5){
					var rowInfo="",colNull=0;
					for (var j=1;j<=col;j++){
						var code=String.fromCharCode(j+64);
						switch(j+64) {
							case 91:
								code="AA";
								break;
							case 92:
								code="AB";
								break;
							case 93:
								code="AC";
								break;
							case 94:
								code="AD";
								break;
							case 95:
								code="AE";
								break;
							default:
								code	
						}
						var p=code+row.toString();
						
						var cell=Sheet[p];
						var cellInfo=cell?cell.v:"";
						rowInfo = rowInfo + cellInfo + String.fromCharCode(9);
						if (cellInfo=='') colNull++;
					}
					if (colNull==col){
						rowNull++;
					}else{
						rowNull=0;
						var ret = $m({ClassName:"DHCMA.CPW.KBS.ImportPathWay",MethodName:"SaveTempFormNew",argCode:aCode,argRowInfo:rowInfo,aHospID:obj.DefHospOID},false);   //objImport.SaveTempForm(formCode,rowInfo);
						if(parseFloat(ret)<0) {
							SaveTempFormErr="Row=" + row + ",ErrCode=" + ret + "!" + String.fromCharCode(13) + String.fromCharCode(10);
							break;
						}else{
							formCode=ret;
							aCode=ret;
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
			ClassName:"DHCMA.CPW.KBS.ImportPathWay",
			QueryName:"QryTempFormData",
			argHospID:obj.DefHospOID
		});
	};
	//事件绑定
	obj.LoadEvents = function(arguments){
		$('#btnImport').on('click',function () {
			$HUI.dialog('#winImportPath').open()
		})
		
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
						var flg = $m({ClassName:"DHCMA.CPW.KBS.ImportPathWay",MethodName:"DeleteTempForm",argCode:formCode},false); 
						if (parseInt(flg)<0){
							alert("删除临时表单失败!Code="+formCode);
						}
					}
					obj.admitList.load({
						ClassName:"DHCMA.CPW.KBS.ImportPathWay",
						QueryName:"QryTempFormData",
						argHospID:obj.DefHospOID
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
				var flg = $m({ClassName:"DHCMA.CPW.KBS.ImportPathWay",MethodName:"SaveForm",argCode:formCode,argHospID:obj.DefHospOID},false); 
				if (parseFloat(flg)<0){
					$.messager.alert("错误提示", "保存正式表单失败!Code="+formCode+"Error:"+flg, "error");
				}else{
					$.messager.popover({msg: "保存正式表单成功!路径="+CPWName+"!",type:'success',timeout: 3000});
					//window.parent.RefreshLeftTree();  //add by zf 20120408
				}
			}
			obj.admitList.load({
				ClassName:"DHCMA.CPW.KBS.ImportPathWay",
				QueryName:"QryTempFormData",
				argHospID:obj.DefHospOID
			}); 
		});	
	};
	obj.OpenPdf = function(argDir){
		websys_showModal({
			url:'../../med/Results/Template/MA/CPW/KBDoc/'+argDir,		//'../../med/Results/Template/MA/CPW/KBDoc/2016000100-小儿气管(支气管)异物.pdf'
			title:'路径文档',
			iconCls:'icon-w-paper',     
			width:1200,
			height:window.screen.availHeight-100
		});
	}
}

