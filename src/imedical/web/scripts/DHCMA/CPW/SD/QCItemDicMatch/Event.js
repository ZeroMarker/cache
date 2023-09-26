//页面Event
function InitWinEvent(obj){
	obj.RecRowID="",obj.optionID=""
    obj.LoadEvent = function(args){ 
    
		//添加
     	$('#btnAdd').on('click', function(){
			obj.addNewMatchRecord();
     	});
     	//保存
     	$('#btnSave').on('click', function(){
			obj.btnSave_click()
     	});
     	//保存抗菌药物
     	$('#btnSaveAnti').on('click', function(){
			obj.btnSaveAnti_click()
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     }
     obj.addNewMatchRecord=function(){
	     		if (obj.endEditing()) {
				  $('#gridQCItemDicMatch').datagrid('appendRow', 
					{OMCategory: "", OMPHCGeneric: "", OMArcimDesc: "", OMArcimID: "", OMType: "1", OMTypeDesc: "按医嘱", OptionDr: obj.optionID, RowID: ""});
		          	editIndex = $('#gridQCItemDicMatch').datagrid('getRows').length - 1;
		            $('#gridQCItemDicMatch').datagrid('selectRow', editIndex)
		             .datagrid('beginEdit', editIndex);
	     		}
		}
     obj.refreshNode = function(node)
		{
			//替换初始化子节点后，不再重新加载子节点，50为病种数
			if ((node.id.indexOf("||")<0)&&(node.children.length<50)) {
				//加载子节点数据				
				var subNodes = [];	
				$(node.target)
				.next().children().children("div.tree-node").each(function(){   
					var tmp = $('#ItemOptions').tree('getNode',this);
					subNodes.push(tmp);
				});
				for(var i=0;i<subNodes.length;i++)
				{
					$('#ItemOptions').tree('remove',subNodes[i].target);
				}
				$cm({
					ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
					QueryName:"QryQCItemTree",
					EntityID :node.id,
					aActive:1,
					ResultSetType:"array", 
					page:1,    
					rows:9999
				},function(rs){  		
					$('#ItemOptions').tree('append', {
							parent: node.target,
							data: rs
					});
				});	
			}else {

				}
		};
	obj.gridQCItemDic_onSelect = function (rd){
		obj.gridQCItemDicMatch.load({
			ClassName:"DHCMA.CPW.SDS.QCOptionMatchSrv",
			QueryName:"QryQCItemOptionMatch",
			aOptionDr:rd["BTID"]
			});
		editIndex=undefined;
		obj.optionID=rd["BTID"]
		var checked=$('#AntiChecked').checkbox('getValue');
		obj.LoadAntiTree('',checked)
		$("#btnAdd").linkbutton('enable');
		$("#btnSave").linkbutton('enable');
		$("#btnDelete").linkbutton('enable');
	}
	obj.btnSaveAnti_click= function(){
		var rootNode = $("#AntiTree").tree('getRoot'); 
		var nodes=$('#AntiTree').tree('getChecked')
		var checkedStr=""
		for (var i=0;i<nodes.length;i++) //遍历根节点下第一层
			{
				var node=nodes[i]
				if (node.id.length<7) continue;
				var checkedStr=checkedStr+"^"+node.id
			}
		if (checkedStr=="") {
			$.messager.alert("错误提示", "未选择有效标准抗菌药物", 'info');
			return;
		}
		$m({
				ClassName:"DHCMA.CPW.SDS.QCOptionMatchAntiSrv",
				MethodName:"SaveAntiStr",
				aOptionDr:obj.optionID,
				aInputStr:checkedStr
			},function(flg){
				if (parseInt(flg)<0) {
					$.messager.alert("错误提示", "数据保存错误!Error=" + Err, 'info');	
				}
				else{
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					}
				})
	}
	//保存
	obj.btnSave_click = function(flg){
		obj.endEditing();  //保存时先结束编辑
		editIndex=undefined;
		var Err = "";
		///获取更新字典信息
		var rows=$('#gridQCItemDicMatch').datagrid('getChanges')
		for (var i=0;i<rows.length;i++) {
				var tmprow=rows[i]
				var OptionDr=tmprow.OptionDr
				var RowID=tmprow.RowID
				var OMType=tmprow.OMType
				var OMArcimID=tmprow.OMArcimID
				var OMArcimDesc=tmprow.OMArcimDesc
				var OMPHCGeneric=tmprow.OMPHCGeneric
				var OMCategory=tmprow.OMCategory
				var InputStr=OptionDr+"^"+RowID+"^"+OMType+"^"+OMArcimID+"^"+OMArcimDesc+"^"+OMPHCGeneric+"^"+OMCategory;
				$m({
					ClassName:"DHCMA.CPW.SD.QCOptionMatch",
					MethodName:"Update",
					aInputStr:InputStr
					},function(flg){
						if (flg<0) {
							Err=Err+"第"+(i+1)+"行数据保存错误.<br>"
							}
					}
					)
		}	
		if (Err!="") {
				$.messager.alert("错误提示", "数据保存错误!Error=" + Err, 'info');
		}else{
				obj.gridQCItemDicMatch.reload();
				$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000})
				
				
			}	
	}
	//删除对照内容
	obj.btnDelete_click = function(){
		var rowData = obj.gridQCItemDicMatch.getSelected();
		var index=editIndex
		editIndex=undefined;
		if (index==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {	
			if (r) {			
					if (rowData.RowID) {								
						var flg = $m({
							ClassName:"DHCMA.CPW.SD.QCOptionMatch",
							MethodName:"DeleteById",
							aId:rowData.RowID
						},false);
						if (parseInt(flg) < 0) {
							$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
						} else {
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						}
					}else {
							$('#gridQCItemDicMatch').datagrid('deleteRow',index)
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						}
					obj.gridQCItemDicMatch.reload();
			}
		}
		);
	}	
	obj.clearAll=function() {
			obj.gridQCItemDic.clearSelections();
			obj.initParamByRec();
			obj.RecRowID="";
		}

	obj.initOrderMsg=function(Arcrd) {
		var retData = $cm({ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",MethodName:"GetArcimInfoById",aArcimID:Arcrd.ArcimID,dataType:'text'},false);
		var retArr = retData.split("^");	
		var PHCGeneDesc=retArr[15]
		var PHCCatDesc=retArr[16]
		Common_SetValue('OMPHCGeneric',PHCGeneDesc)
		Common_SetValue('OMCategory',PHCCatDesc)
		}
	obj.LoadAntiTree=function(key,checked){
		/*标准抗菌药对照*/
		var jsonstr = $m({
			ClassName:"DHCMA.CPW.SDMatchSrv.AntiCatSrv",
			MethodName:"GetItemJsonTree",
			aQCItemDicId:obj.optionID,
			aChecked:checked,
			aKey:key
		},false);
		if (jsonstr=="") return;
		var jsonData=eval('(' + jsonstr + ')');
		$('#AntiTree').tree({
			data: [jsonData],
	        checkbox : true,
			formatter:function(node){
					return node.id+"  "+node.text;
			},
			onCheck: function (node, checked) {
				
			},
			loadFilter:function(data,parent){
				return data;
			}
		})
		/*标准抗菌药对照End*/
	}
}