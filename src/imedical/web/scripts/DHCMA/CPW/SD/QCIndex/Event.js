//页面Event
function InitWinEvent(obj){
	obj.RecRowID="";
    obj.LoadEvent = function(args){  
	 	//保存指标项
	 	$('#btnSave').on('click', function(){
			obj.btnSave_click()
	 	});
     }
	obj.gridQCIndex_onSelect = function (rd){
		if (obj.RecRowID!=rd.RowID){
			Common_SetValue('BTCode',rd.BTCode);
			Common_SetValue('BTDesc',rd.BTDesc);
			Common_SetValue('BTCalculate',rd.BTCalculate);
			Common_SetValue('IndexCat',rd.IndexCat);
			Common_SetValue('RaqName',rd.RaqName);
			Common_SetValue('IsActive',(rd.IsActive=="是"?1:0));
			obj.RecRowID=rd.RowID
		}else{
			obj.gridQCIndex.clearSelections();
			obj.ClearForms();			
		}
	}
	obj.ClearForms=function(){
		obj.RecRowID="";
		Common_SetValue('BTCode','');
		Common_SetValue('BTDesc','');
		Common_SetValue('BTCalculate','');
		Common_SetValue('IsActive','');
		Common_SetValue('IndexCat','');
		Common_SetValue('RaqName','');
		}
	//保存分类
	obj.btnSave_click = function(flg){
		var BTCode=$("#BTCode").val();
		var BTDesc=$("#BTDesc").val();
		var IsActive=Common_GetValue('IsActive')
		var BTIndexCat=$("#IndexCat").val();
		var RaqName=$("#RaqName").val();
		var IndNo=""
		var rd=$('#gridQCIndex').datagrid('getSelected');
		if (rd) {var RowID=rd.RowID ,IndNo=rd.IndNo}
		else { var RowID=""}
		if (obj.QCEntityID=="") {
			$.messager.alert("错误提示", "未获取到病种ID", 'info');
			return;
			}
		var inputStr	=obj.QCEntityID;
		var inputStr	=inputStr+"^"+RowID;
		var inputStr	=inputStr+"^"+BTCode;
		var inputStr	=inputStr+"^"+BTDesc;
		var inputStr	=inputStr+"^"+BTIndexCat;
		var inputStr	=inputStr+"^"+RaqName;
		var inputStr	=inputStr+"^"+IndNo;
		var inputStr	=inputStr+"^"+(IsActive?1:0);
		var flg= $m({
			ClassName:"DHCMA.CPW.SD.QCIndex",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg)>0) {
				$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000})
				$('#gridQCIndex').datagrid('reload');
				obj.ClearForms();				
		}else{
				$.messager.alert("错误提示", "数据保存错误!", 'info');				
			}	
	}

}