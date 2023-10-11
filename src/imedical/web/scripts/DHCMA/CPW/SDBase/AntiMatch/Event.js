//页面Event
function InitviewScreenEvent(obj){
	obj.AntiItemDr=""
    obj.LoadEvent = function(args){ 
    
		//添加
     	$('#btnAdd').on('click', function(){
			obj.addNewMatchRecord();
     	});
     	//保存
     	$('#btnSave').on('click', function(){
			obj.btnSave_click()
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     }
     obj.addNewMatchRecord=function(){
	     		if (obj.endEditing()) {
				  $('#gridAntiItemDicMatch').datagrid('appendRow', 
					{OMCategory: "", OMPHCGeneric: "", OMArcimDesc: "", OMArcimID: "", OMType: "1", OMTypeDesc: "按医嘱", AntiItemDr: obj.AntiItemDr, RowID: ""});
		          	editIndex = $('#gridAntiItemDicMatch').datagrid('getRows').length - 1;
		            $('#gridAntiItemDicMatch').datagrid('selectRow', editIndex)
		             .datagrid('beginEdit', editIndex);
	     		}
		}
	obj.gridAntiItem_onSelect = function (rd){
		obj.gridAntiItemDicMatch.load({
			ClassName:"DHCMA.CPW.SDMatchSrv.AntiItemMatchSrv",
			QueryName:"QryAntiItemMatch",
			aAntiItemDr:rd["BTID"],
			aHospID:session['DHCMA.HOSPID']
			});
		editIndex=undefined;
		obj.AntiItemDr=rd["BTID"];
		$("#btnAdd").linkbutton('enable');
		$("#btnSave").linkbutton('enable');
		$("#btnDelete").linkbutton('enable');
	}
	//保存分类
	obj.btnSave_click = function(flg){
		obj.endEditing();  //保存时先结束编辑
		editIndex=undefined;
		var Err = "",RecCount=0;
		///获取更新字典信息
		var rows=$('#gridAntiItemDicMatch').datagrid('getChanges')
		if(!rows.length){
			$.messager.alert("错误提示", "没有需保存数据", 'info');
			obj.gridAntiItemDicMatch.clearSelections();
			return
			}
		for (var i=0;i<rows.length;i++) {
				var tmprow=rows[i]
				var AntiItemDr=tmprow.AntiItemDr
				var RowID=tmprow.RowID
				var OMType=tmprow.OMType
				var OMArcimID=tmprow.OMArcimID
				var OMArcimDesc=tmprow.OMArcimDesc
				var OMPHCGeneric=tmprow.OMPHCGeneric
				if (OMArcimDesc=="") continue;
				var InputStr=AntiItemDr+"^"+RowID+"^"+OMType+"^"+OMArcimID+"^"+OMArcimDesc+"^"+OMPHCGeneric;
				$m({
					ClassName:"DHCMA.CPW.SDMatch.AntiItemMatch",
					MethodName:"Update",
					aInputStr:InputStr
					},function(flg){
						if (flg<0) {
							Err=Err+"第"+(i+1)+"行数据保存错误.<br>"
						}else{
							RecCount=RecCount+1	
						}
					})		
		}
		setTimeout(function() {
			if (RecCount<1) {
				$.messager.alert("错误提示", "没有要保存的数据！", 'info');
			}else if (Err!="") {
					$.messager.alert("错误提示", "数据保存错误!Error=" + Err, 'info');
			}else{
					$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000})	
				}
			obj.gridAntiItemDicMatch.reload();	
			obj.gridAntiItemDicMatch.clearSelections();
			},300)
			
	}
	//删除对照内容
	obj.btnDelete_click = function(){
		var rowData = obj.gridAntiItemDicMatch.getSelected();
		var index=editIndex
		editIndex=undefined;
		if (index==undefined){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return
			
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {	
			if (r) {			
					if (rowData.RowID) {								
						var flg = $m({
							ClassName:"DHCMA.CPW.SDMatch.AntiItemMatch",
							MethodName:"DeleteById",
							aId:rowData.RowID
						},false);
						if (parseInt(flg) < 0) {
							$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						}
					}else {
							$('#gridAntiItemDicMatch').datagrid('deleteRow',index)
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						}
					obj.gridAntiItemDicMatch.reload();
			}
		}
		);
	}	
}