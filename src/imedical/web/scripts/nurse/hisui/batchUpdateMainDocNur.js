/*
 * @Author: piwenping
 * @Discription: 
 * @Date: 2023-02-07
 */

$(function() {
	var editIndex = undefined;
	var GV = {
		ClassName: "Nur.HISUI.batchUpdateMainDocNur",
		PatSheetMethodName:"GetWardBed",
		LogDetailMethodName:"GetSearchLog"
	}
	function initUI() {
		initForm();
		initGridPatSheet();
	}
	
	function initForm() {
		$('#searchBtn').click(search);
		$("#updateBtn").click(barchUpdateMainDocNur);
		$HUI.combobox('#mainDoc', {
			multiple:ServerObj.MainDocMulti=="Y"?true:false,
			rowStyle:"checkbox",
			editable:true,
			valueField: 'ID',
			textField: 'name',
			url:$URL+'?ClassName=Nur.NIS.Service.Base.Ward'+'&MethodName=GetMainDoctorByWardID'+'&wardID='+session['LOGON.WARDID'],
			defaultFilter:6,
			onSelect:function(rec){
				if (ServerObj.MainDocMulti=="Y"){
					var selValArr=$('#mainDoc').combobox("getValues");
					if (selValArr.length>=3){
						$('#mainDoc').combobox("setValues",selValArr.slice(1,3))
					}
				}
			},
			onLoadSuccess:function(){
				if (ServerObj.MainDocMulti=="Y"){
					$('#mainDoc').combobox("setValues","");
				}
			}
		});
		$HUI.combobox('#mainNur', {
			multiple:ServerObj.MainNurseMulti=="Y"?true:false,
			rowStyle:"checkbox",
			editable:true,
			valueField: 'ID',
			textField: 'name',
			url:$URL+'?ClassName=Nur.NIS.Service.Base.Ward'+'&MethodName=GetMainNursesByWardID'+'&wardID='+session['LOGON.WARDID'],
			defaultFilter:6,
			onSelect:function(rec){
				if (ServerObj.MainNurseMulti=="Y"){
					var selValArr=$('#mainNur').combobox("getValues");
					if (selValArr.length>=3){
						$('#mainNur').combobox("setValues",selValArr.slice(1,3))
					}
				}
			},
			onLoadSuccess:function(){
				if (ServerObj.MainNurseMulti=="Y"){
					$('#mainNur').combobox("setValues","");
				}
			}
		});
	}

	function initGridPatSheet() {
		var columns = [[
		   {field:'Adm',title:'就诊号',align:'center',width:50,hidden:true},
		   {field:'BedCode',title:'床号',align:'center',width:50},
		   {field:'PatName',title:'姓名',align:'left',width:150},
		   {field:'MedicareNo',title:'住院号',align:'left',width:100},
		   {field:'DoctorName',title:'主管医生',width:150,align:'center',hidden:true},
		   {field:'NurseName',title:'主管护士',width:150,align:'center',hidden:true},
		   {field:'Doctor',title:'主管医生',width:150,align:'center',
			formatter: function(value,row,index){
				return row.DoctorName;
			},
			editor: {
				type: 'combobox',
				options: {
					multiple:ServerObj.MainDocMulti=="Y"?true:false,
					rowStyle:"checkbox",
					valueField: 'ID',textField: 'name',editable:true,
					//url:$URL+'?ClassName=Nur.NIS.Service.Base.Ward'+'&MethodName=GetMainDoctorByWardID'+'&wardID='+session['LOGON.WARDID'],
					url:$URL+'?ClassName=Nur.NIS.Service.Base.Ward'+'&MethodName=GetMainDoctors',
					defaultFilter:6,
					onSelect:function(rec){
						if (ServerObj.MainDocMulti=="Y"){
							var selValArr=$(this).combobox("getValues");
							if (selValArr.length>=3){
								$(this).combobox("setValues",selValArr.slice(1,3))
							}
						}
						var docNames=$(this).combobox("getText");
						var tr = $(this).closest("tr.datagrid-row");
						var index = tr.attr("datagrid-row-index");
						var rows=$('#patSheetGrid').datagrid("getRows");
						rows[index].DoctorName=docNames;
					},
					onBeforeLoad: function(param){
						var tr = $(this).closest("tr.datagrid-row");
						var index = tr.attr("datagrid-row-index");
						var rows=$('#patSheetGrid').datagrid("getRows");
						param = $.extend(param,{locID:rows[index].locID});
					}
				}
			}
		   },
		   {field:'Nurse',title:'主管护士',width:200,align:'center',
			formatter: function(value,row,index){
				return row.NurseName;
			},
			editor: {
				type: 'combobox',
				options: {
					multiple:ServerObj.MainNurseMulti=="Y"?true:false,
					rowStyle:"checkbox",
					valueField: 'ID',textField: 'name',editable:true,
					url:$URL+'?ClassName=Nur.NIS.Service.Base.Ward'+'&MethodName=GetMainNursesByWardID'+'&wardID='+session['LOGON.WARDID'],
					defaultFilter:6,
					onSelect:function(rec){
						if (ServerObj.MainNurseMulti=="Y"){
							var selValArr=$(this).combobox("getValues");
							if (selValArr.length>=3){
								$(this).combobox("setValues",selValArr.slice(1,3))
							}
						}
						var nurNames=$(this).combobox("getText");
						var tr = $(this).closest("tr.datagrid-row");
						var index = tr.attr("datagrid-row-index");
						var rows=$('#patSheetGrid').datagrid("getRows");
						rows[index].NurseName=nurNames;
					}
				}
			}
		   },
		]];
		$('#patSheetGrid').datagrid({
				toolbar:[],
				pagination:true,		     //分页
				pageSize: 100,
				pageList : [100,150,200,250],
				fit: true,
				url: 'dhc.nurse.ip.common.getdata.csp?className=' + GV.ClassName + '&methodName=' + GV.PatSheetMethodName,
				fitColumns: false,
				nowrap:false,
				singleSelect:false,
				headerCls: 'panel-header-gray',		
				rownumbers: true,
				frozenColumns: [[
					{ field: 'ck', checkbox: true }
				]],
				idField:"Adm",
				columns:columns,
				onAfterEdit:afterEdit,
				onDblClickRow: onDblClickRow,  //双击编辑行
				onCheck: onClickRow, //单击
				onUncheck:onUnClickRow, //取消单击
				onBeforeLoad: function(param) {
					editIndex = undefined;
					$('#patSheetGrid').datagrid('unselectAll');
					var page = param.page;
					var rows = param.rows;
					param.parameter1 = session['LOGON.WARDID'];
					param.parameter2 = $HUI.combobox('#mainDoc').getText();
					param.parameter3 = $HUI.combobox('#mainNur').getText();
					param.parameter4 = page;
					param.parameter5 = rows;
				},
				loadFilter: function(data){
					for (var i =0;i<data.rows.length;i++){
						var Doctor=data.rows[i].Doctor;
						var Nurse=data.rows[i].Nurse;
						data.rows[i].Doctor=Doctor.toString();
						data.rows[i].Nurse=Nurse.toString();
					}
					return data;
				}
			});
	}
	
	function initLogGrid(Adm,type){
		var columns = [[
		   {field:'NewName',title:'新值',align:'left',width:150},
		   {field:'OldName',title:'旧值',align:'left',width:150},
		   {field:'UpdateUserName',title:'操作人',align:'left',width:100},
		   {field:'UpdateDate',title:'操作日期',align:'left',width:100},
		   {field:'UpdateTime',title:'操作时间',width:100,align:'left'}
		]]
		var grid = "#nurLogGrid";
		if (type == "Doctor") grid = "#docLogGrid";
		$(grid).datagrid({
				toolbar:[],
				pagination:true,		     //分页
				pageSize: 5,
				pageList : [5,10,15,25],
				fit: true,
				url: 'dhc.nurse.ip.common.getdata.csp?className=' + GV.ClassName + '&methodName=' + GV.LogDetailMethodName,
				fitColumns: false,
				nowrap:false,
				headerCls: 'panel-header-gray',		
				rownumbers: true,
				columns:columns,
				onBeforeLoad: function(param) {
					var page = param.page;
					var rows = param.rows;
					param.parameter1 = Adm;
					param.parameter2 = type;
					param.parameter3 = page;
					param.parameter4 = rows;
				}
			});
	}
	
	function endEditing() {
		if (editIndex == undefined) { return true }
		if ($('#patSheetGrid').datagrid('validateRow', editIndex)) {
			$('#patSheetGrid').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	
	function onDblClickRow(index) {
		if (editIndex != index) {
			if (endEditing()) {
				$('#patSheetGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
				editIndex = index;
				setTimeout(function(){
					var data=$('#patSheetGrid').datagrid('getRows');
					var ed = $('#patSheetGrid').datagrid('getEditor', {index:index,field:'Doctor'});
					if (ServerObj.MainDocMulti=="Y"){
						ed.target.combobox("setValues",data[index].Doctor.toString().split(","))
					}else{
						ed.target.combobox('setValue',data[index].Doctor.toString().split(",")[0]);
					}
					
					var ed = $('#patSheetGrid').datagrid('getEditor', {index:index,field:'Nurse'});
					if (ServerObj.MainNurseMulti=="Y"){
						ed.target.combobox("setValues",data[index].Nurse.toString().split(","))
					}else{
						ed.target.combobox('setValue',data[index].Nurse.toString().split(",")[0]);
					}
				})
				
			} else {
				$('#patSheetGrid').datagrid('selectRow', editIndex);
			}
		}
	}
	
	function onClickRow(index, row){
		var carryTitle = $g("修改日志")+ '<span style="font-weight:bold;color:red;margin-left:10px;">' + row.BedCode + $g("床") +"<span style='margin-left:10px;'>" + row.PatName + '</span></span>';
		$('#panelLogDetail').panel('setTitle', carryTitle);
		initLogGrid(row.Adm,"Nurse");
		initLogGrid(row.Adm,"Doctor");
	}
	function onUnClickRow(index, row){
		var sels=$('#patSheetGrid').datagrid("getSelections");
		if (sels.length>0){
			onClickRow(sels.length-1,sels[sels.length-1]);
		}else{
			$('#panelLogDetail').panel('setTitle', $g("修改日志"));
			initLogGrid("","Nurse");
			initLogGrid("","Doctor");
		}
	}
	function afterEdit(index, row, changes){
		var changeObj={};
		var Adm = row.Adm;
		for(var key in changes) {
			if(key != "") {
				var value = changes[key];
				var ret = tkMakeServerCall(GV.ClassName, "UpdateMainDocNur", key ,Adm , value , session['LOGON.USERID']);
				if(ret == "0"){
					 $.messager.popover({msg:'保存成功',type:'success'});
					 changeObj[key]=value;
					 changeObj[key+"Name"]=row[key+"Name"];
				 }else{
					 $.messager.popover({msg:'保存失败,失败原因:' + ret,type:'error'});
				 }
			}				
		}
		if (!$.isEmptyObject(changeObj)){
			var index=$('#patSheetGrid').datagrid("getRowIndex",Adm);
			$('#patSheetGrid').datagrid('updateRow',{
				index: index,
				row: changeObj
			});
		}
		
		//search();
	}
	
	function search(){
		$('#patSheetGrid').datagrid('reload');
		initLogGrid("","Nurse");
		initLogGrid("","Doctor");
	}
	
	function barchUpdateMainDocNur(){
		var mainDocId = $HUI.combobox('#mainDoc').getValues().join(",");
		var mainNurId = $HUI.combobox('#mainNur').getValues().join(",");
		if ((mainDocId =="")&&(mainNurId == "")){
			$.messager.popover({msg:'批量修改功能，必须选择主管医生或护士',type:'error'});
			return
		}
		var rows = $("#patSheetGrid").datagrid('getSelections');
		var errInfo = [];
		if (rows.length > 0) {
			rows.forEach(function(row){
				var ret = "0";
				/*if (mainDocId != "") ret = tkMakeServerCall(GV.ClassName, "UpdateMainDocNur", "Doctor" ,row.Adm , mainDocId[0] , session['LOGON.USERID']);
				if(ret != "0"){
					var err = row.PatName + ",修改主管医生失败,失败原因为:" + ret;
					errInfo.push(err)
				} 
				if (mainNurId != "") ret = tkMakeServerCall(GV.ClassName, "UpdateMainDocNur", "Nurse" ,row.Adm , mainNurId[0] , session['LOGON.USERID']);
				if(ret != "0"){
					var err = row.PatName + ",修改主管护士失败,失败原因为:" + ret;
					errInfo.push(err)
				} */
				var data=$.cm({
					ClassName:"Nur.NIS.Service.Base.Patient",
					MethodName:"UpdateMainDocNur",
					episodeID:row.Adm,
					mainDocIDArray:mainDocId,
					mainNurIDArray:mainNurId,
					userID:session['LOGON.USERID'],
					data:"text"
				},false)
				if (data.status != 0) {
					errInfo.push(row.PatName + ",修改失败,失败原因为:" + data.status);
				}
			})
		}else{
			$.messager.popover({msg:'请选择一条数据',type:'error'});
			return
		}
		if (errInfo.length > 0){
			var err = errInfo.join("<br>");
			$.messager.alert("修改失败", err, 'error');
		}else{
			 $.messager.popover({msg:'保存成功',type:'success'});
		}
		if (ServerObj.MainNurseMulti=="Y"){
			$HUI.combobox('#mainNur').setValues("");
		}else{
			$HUI.combobox('#mainNur').setValue("");
		}
		if (ServerObj.MainDocMulti=="Y"){
			$HUI.combobox('#mainDoc').setValues("");
		}else{
			$HUI.combobox('#mainDoc').setValue("");
		}
		search();
	}
	initUI();
})


