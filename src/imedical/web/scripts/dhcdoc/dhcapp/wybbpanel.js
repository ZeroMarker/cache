var WYBBPanel=(function(){
	var editSelRow = -1;    /// 当前编辑行
	var isPageEditFlag = 1; /// 页面是否允许编辑
	function Init(){
		InitPageDataGrid();	
		//LoadOtherInfo();
		}
	/// 页面DataGrid初始定义已选列表
	function InitPageDataGrid(){
		
		/// 编辑格
		var texteditor = {
			type: 'text',//设置编辑格式
			options: {
				required: true //设置编辑规则属性
			}
		}
		
		/// 数字编辑格
		var numberboxeditor = {
			type: 'numberbox',//设置编辑格式
			options: {
				//required: true //设置编辑规则属性
			}
		}
			
		// 标本编辑格
		var SpliTypeEditor={  //设置其为可编辑
			type: 'combobox',//设置编辑格式
			options: {
				url: LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=JsonGetSpecType&HospID="+LgHospID,
				//url: LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=JsonGetPisDicTypeNew&Desc=标本玻片类型&Name=&HospID="+LgHospID,
				valueField: "value", 
				textField: "text",
				editable:false,
				//panelHeight:"auto",  //设置容器高度自动增长
				onSelect:function(option){
					var ed=$("#PisSpecList").datagrid('getEditor',{index:editSelRow,field:'SliType'});
					$(ed.target).combobox('setValue', option.text);
				}
			}

		}
		
		var TitLnk = '<a href="#" onclick="insRow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';
		///  定义columns
		var columns=[[
			{field:'No',title:'标本序号',width:80,align:'center'},
			//{field:'ID',title:'标本标识',width:80,editor:texteditor},
			{field:'Name',title:'标本名称',width:300,editor:texteditor},
			{field:'Part',title:'标本部位',width:120,editor:texteditor,hidden:true},
			{field:'Qty',title:'标本数量',width:80,editor:numberboxeditor},
			{field:'SliType',title:'玻片/蜡块',width:140,editor:SpliTypeEditor},
			{field:'PisNo',title:'原病理号',width:140,editor:texteditor},
			//{field:'operation',title:TitLnk,width:40,align:'center',formatter:SetCellUrl}
		]];
		
		///  定义datagrid
		var option = {
			//showHeader:false,
			fitColumn:false,
			headerCls:'panel-header-gray',
			rownumbers : false,
			singleSelect : true,
			pagination: false,
		    onDblClickRow: function (rowIndex, rowData) {
				
				if (isPageEditFlag == 0) return;
	            if ((editSelRow != -1)||(editSelRow == 0)) { 
	                $("#PisSpecList").datagrid('endEdit', editSelRow); 
	            } 
	            $("#PisSpecList").datagrid('beginEdit', rowIndex); 

	            editSelRow = rowIndex; 
	        },onLoadSuccess:function(data){
		        var OtherInfo=""
				if (itemReqJsonStr!=""){
					for (var i = 0; i < itemReqJsonStr.length; i++) {
						var OneReqJson=itemReqJsonStr[i]
						var ID=OneReqJson.ID
						var Val=OneReqJson.Val
						if (ID=="OtherInfo") OtherInfo=Val
					}
				}
				if (OtherInfo!=""){
					OtherObj=$.parseJSON(OtherInfo); 
					PisSpec=$.parseJSON(OtherObj["PisSpec"])
					for (var i = 0; i < PisSpec.length; i++) {
						var PisArry=PisSpec[i]
						var PisArryStr=PisArry.split("^")
						var rowObj = {"No":PisArryStr[0],"Name":PisArryStr[2],"Explain":"","Part":PisArryStr[3],"Qty":PisArryStr[4],"SliType":PisArryStr[5],"PisNo":PisArryStr[6]};
						var Index= parseFloat(PisArryStr[0])-1
						$('#PisSpecList').datagrid('updateRow',{index: Index, row:rowObj});
						
					} 
					}
		        }
		};
		/// 就诊类型
		var uniturl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=JsonQryPisSpecByOut&PisID=";
		new ListComponent('PisSpecList', columns, uniturl, option).Init();
	}

	/// 链接
	function SetCellUrl(value, rowData, rowIndex){	
		return "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
	}

	/// 删除行
	function delRow(rowIndex){
		
		if (isPageEditFlag == 0) return;
		var rows = $('#PisSpecList').datagrid('getRows');
		//删除前结束所有的编辑行
		$.each(rows,function(index,data){
			 if ((editSelRow != -1)||(editSelRow == 0)) { 
	                $("#PisSpecList").datagrid('endEdit', editSelRow); 
	            }
		});
		/// 行对象
	    var rowObj={ID:'', Name:'', Part:'', Qty:'', SliType:'', PisNo:''};
		
		/// 当前行数大于4,则删除，否则清空
		if(rowIndex=="-1"){
			$.messager.alert("提示:","请先选择行！");
			return;
		}
		
		if(rows.length>4){
			 $('#PisSpecList').datagrid('deleteRow',rowIndex);
			 rowNo -= 1;
		}else{
			//$('#PisSpecList').datagrid('updateRow',{index:rowIndex, row:rowObj});
			$('#PisSpecList').datagrid('deleteRow',rowIndex);  //小于4时,删除该行后,在新增一个空行 qunianepng 2018/1/29
			 rowNo -= 1;
			 var rowObj = {"No":rowNo+1,"Name":"","Explain":"","Part":"","Qty":"","Remark":"","SliType":"","PisNo":""};
			$("#PisSpecList").datagrid('appendRow',rowObj);
		}
		
		// 删除后,重新排序
		//$('#PisSpecList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
		//删除后,根据标本序号重新排序,并重新编号
		sortTable();
	}

	/// 插入空行
	function insRow(){	

		if (isPageEditFlag == 0) return;
		rowNo += 1;
		var rowObj={"No":rowNo, "ID":"", "Name":"", "Part":"", "Qty":"", "SliType":"", "PisNo":""};
		$("#PisSpecList").datagrid('appendRow',rowObj);
	}
	function LoadOtherInfo(){
		var OtherInfo=""
		if (itemReqJsonStr!=""){
			for (var i = 0; i < itemReqJsonStr.length; i++) {
				var OneReqJson=itemReqJsonStr[i]
				var ID=OneReqJson.ID
				var Val=OneReqJson.Val
				if (ID=="OtherInfo") OtherInfo=Val
			}
		}
		if (OtherInfo!=""){
			OtherObj=$.parseJSON(OtherInfo); 
			PisSpec=$.parseJSON(OtherObj["PisSpec"])
			setTimeout(function(){
				for (var i = 0; i < PisSpec.length; i++) {
					var PisArry=PisSpec[i]
					var PisArryStr=PisArry.split("^")
					var rowObj = {"No":PisArryStr[0],"Name":PisArryStr[2],"Explain":"","Part":PisArryStr[3],"Qty":PisArryStr[4],"SliType":PisArryStr[5],"PisNo":PisArryStr[6]};
					var Index= parseFloat(PisArryStr[0])-1
					$('#PisSpecList').datagrid('updateRow',{index: Index, row:rowObj});
					
				} 
			}, 1000);
			}
	}
	function OtherInfo(){
		/// 病理标本
		var rows = $('#PisSpecList').datagrid('getRows');
		//删除前结束所有的编辑行
		$.each(rows,function(index,data){
	              $("#PisSpecList").datagrid('endEdit', index); 
		});
		var PisSpecArr=[];
		var rowDatas = $('#PisSpecList').datagrid('getRows');
		var PisReqSpec=""
		$.each(rowDatas, function(index, item){
			if((trim(item.Name) != "")&&(item.Qty>0)){
			    var TmpData = item.No +"^"+ item.ID +"^"+ item.Name +"^"+ item.Part +"^"+ item.Qty +"^"+ item.SliType +"^"+ item.PisNo;
			    PisSpecArr.push(TmpData);
			    if (PisReqSpec==""){
					PisReqSpec = item.No+"#"+item.Name +"#"+ item.Qty +"#"+ item.Part +"#"+ item.PisNo+ "#"+ item.SliType;
				}else{
					PisReqSpec = PisReqSpec+"@"+item.No+"#"+item.Name +"#"+ item.Qty +"#"+ item.Part +"#"+ item.PisNo+ "#"+ item.SliType;	
				}
			}
		})
		var PisSpec = JSON.stringify(PisSpecArr);
		var RecLocDesc= $HUI.combobox("#recLoc").getText();
		var rtnObj = {}
		rtnObj["PisSpec"] = PisSpec;
		rtnObj["PisReqSpec"] = PisReqSpec;
		return rtnObj;
		}
		
	function PrintInfo(){
		var PisSpecArr=[];
		var rows = $('#PisSpecList').datagrid('getRows');
		//删除前结束所有的编辑行
		$.each(rows,function(index,data){
	              $("#PisSpecList").datagrid('endEdit', index); 
		});
		var rowDatas = $('#PisSpecList').datagrid('getRows');
		var PisSpec="标本序号"+ "^"+"标本名称"+ "^"+"数量"+ "^"+"玻片/蜡块"+ "^"+"原病理号"
		$.each(rowDatas, function(index, item){
			if((trim(item.Name) != "")&&(item.Qty>0)){
				if (PisSpec==""){
					PisSpec =item.No+ "^"+item.Name+  "^"+item.Qty+ "^"+item.SliType+ "^"+item.PisNo;
					}else{
					PisSpec = PisSpec+"*AABCD*"+item.No+ "^"+item.Name+  "^"+item.Qty+ "^"+item.SliType+ "^"+item.PisNo;
					}
			}
		})
		var rtnObj = {}
		rtnObj["List"] = PisSpec;
		return rtnObj
		}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		}
	   
})();