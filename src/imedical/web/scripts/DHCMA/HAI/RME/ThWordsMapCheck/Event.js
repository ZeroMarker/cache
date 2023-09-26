//页面Event
function InitThWordsMapCheckWinEvent(obj){
	
    obj.LoadEvent = function(args){
		//自动同步
		$('#btnAutoMap').on('click', function(){
	     	obj.btnAutoMap_click();
     	});
		//审核通过
     	$('#btnCheck').on('click', function(){
			obj.btnCheck_click();
     	});
		//审核不通过
     	$('#btnUnCheck').on('click', function(){
			obj.btnUnCheck_click();
     	});
		//主题分类触发事件
		$('#cboThemeType').on('select', function(){
			
     	});
     	
     	$('#searchTheme').searchbox({ 
			searcher:function(value,name){
				obj.gridThemeWords.load({
					ClassName:"DHCHAI.RMES.ThWordsMapSrv",
					QueryName:"QryThWordsToCheck",
					aThemeTypeDr:$("#cboThemeType").combobox('getValue'),
					aKeyWord:value
				});
			}
		});
		
		$('#searchThWordsMap').searchbox({ 
			searcher:function(value,name){	
				obj.gridThWordsMap.load({
					ClassName:"DHCHAI.RMES.ThWordsMapSrv",
					QueryName:"QryThWordsMap",
					aThWordsDr:obj.RecRowID1,
					aKeyWord:value
				});
			}
		});
	
    }
	
	//自动同步
	obj.btnAutoMap_click = function(){
		if (obj.RecRowID1 == '') return;
		$.messager.confirm("执行", "是否自动同步关键词对照记录?", function (r) {				
			if (r) {
				var flg = $m({
					ClassName:"DHCHAI.RMES.ThWordsMapSrv",
					MethodName:"ChangeMapping",
					aThemeWordDr:obj.RecRowID1
				},false);
				
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","自动同步数据错误!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '自动同步成功！',type:'success',timeout: 1000});
					obj.gridThemeWordsLoad();  //加载主题词列表
					obj.gridThWordsMapLoad();  //加载归一词对照
				}
			} 
		});
	}
	
	//选择主题词
	obj.gridThemeWords_onSelect = function(rowData){	
		if (rowData["ID"] == obj.RecRowID1) {
			$("#btnCheck").linkbutton("disable");
			$("#btnUnCheck").linkbutton("disable");
			obj.RecRowID1="";
			obj.gridThemeWords.clearSelections();  //清除选中行
		} else {
			obj.RecRowID1 = rowData["ID"];
		}
		obj.gridThWordsMapLoad();  //加载归一词对照
	}
	
	//加载主题词
	obj.gridThWordsMapLoad = function () {
		var aThWordsDr = "";
		if (obj.RecRowID1) {
			aThWordsDr =obj.RecRowID1;
		}
		obj.gridThWordsMap.load({
			ClassName:"DHCHAI.RMES.ThWordsMapSrv",
			QueryName:"QryThWordsMap",
			aThWordsDr:aThWordsDr
		});
	}
	
	//加载归一词对照
	obj.gridThemeWordsLoad = function (ThemeTypeDr) {
		if (!ThemeTypeDr) return;
		obj.gridThemeWords.load({
			ClassName:"DHCHAI.RMES.ThWordsMapSrv",
			QueryName:"QryThWordsToCheck",
			aThemeTypeDr:ThemeTypeDr
		});
	}
	
	//归一词对照-列表选择
    obj.gridThWordsMap_onCheck = function (){
		if (!obj.RecRowID1) return;
		var rowsData = $('#gridThWordsMap').datagrid('getChecked');
		if (rowsData){
			$("#btnCheck").linkbutton("enable");
			$("#btnUnCheck").linkbutton("enable");
		}
	}
	
	//归一词对照-列表选择
    obj.gridThWordsMap_onUnCheck = function (){
		if (!obj.RecRowID1) return;
		var rowsData = $('#gridThWordsMap').datagrid('getChecked');
		if (rowsData.length<1){
			$("#btnCheck").linkbutton("disable");
			$("#btnUnCheck").linkbutton("disable");
		}
	}
	
	//审核通过
	obj.btnCheck_click = function(){
		obj.SaveCheckResult(1);
	}
	
	//审核不通过
	obj.btnUnCheck_click = function(){
		obj.SaveCheckResult(0);
	}
	
	//保存审核结果
	obj.SaveCheckResult = function(StatusCode){
		var errinfo = "";
		var ThWordsMapIDs = '';
		var rowsData = $('#gridThWordsMap').datagrid('getChecked');
		for (var i = 0;i<rowsData.length;i++) {
			var ThWordsMapID=rowsData[i].ID;
			if (!ThWordsMapID) continue;
			if (ThWordsMapIDs == '') {
				ThWordsMapIDs = ThWordsMapID;
			} else {
				ThWordsMapIDs += ',' + ThWordsMapID;
			}
		}
		var CheckUserID="";
		if($.LOGON.USERID) CheckUserID=$.LOGON.USERID;
		
		if (!ThWordsMapIDs) {
			errinfo = errinfo + "未选择需审核记录!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = StatusCode;  //审核通过1、审核未通过0
		inputStr += '^' + CheckUserID;
		inputStr += '^' + ThWordsMapIDs;
		
		var flg = $m({
			ClassName:"DHCHAI.RMES.ThWordsMapSrv",
			MethodName:"CheckThWordsMap",
			aInputStr:inputStr
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		} else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});

			// 取消选中“归一词库”表头的全选框；刷新“归一词库”和“主题词库”数据表格
			$("input[type='checkbox']:first").removeAttr('checked');
			obj.gridThWordsMap.reload(); //刷新“归一词库”数据表格
			
			var currPage=1;
			if (obj.RecRowID1>=0) {
				var options = $('#gridThemeWords').datagrid("getPager").data("pagination").options;
				currPage = options.pageNumber; 
			}		
			obj.gridThemeWords.reload(); //刷新“主题词库”数据表格
		
			$('#gridThemeWords').datagrid({
				pageNumber:currPage
				,onLoadSuccess:function(data) {	
					//获取数据列表中的所有数据
					var rows = data.rows;
					var length = rows.length;
					
					//循环数据找出列表中ID和需要选中数据的ID相等的数据并选中
					for(var i=0;i<length;i++){
						var rowID = rows[i].ID;       						
						if(rowID==obj.RecRowID1){
							var index = $('#gridThemeWords').datagrid("getRowIndex",rows[i]);
							$('#gridThemeWords').datagrid('scrollTo', index); //滚动到指定行
							$('#gridThemeWords').datagrid('selectRow', index); //选中指定行
						}
					}
				}
			});
		}
	}
}