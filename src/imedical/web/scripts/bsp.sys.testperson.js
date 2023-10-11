var init = function(){
	$("#grid").mgrid({
		width:500,
		fitColumns:false,
		fit:true,
		editGrid:true,
		codeField:"PatientName",
		className:"CF.BSP.SYS.SRV.TestPerson",
		columns:[[
			{field:'ID',title:'ID',width:'30',hidden:true},
			{field:'PatientId',title:'病人ID',width:'100',editor:{type:'text'},hidden:true},//,hidden:true
			{field:'PatientName',title:'病人姓名',width:'150',
				editor:{
					type:'lookup',
					options:{
						panelWidth:500,
						url:$URL,
						queryParams:{ClassName:"CF.BSP.SYS.SRV.TestPerson",QueryName:"FindPatientByName"},
						mode:'remote',
						idField:'HIDDEN',
						textField:'PatientName',
						columns:[[  
							//{field:'ID',title:'ID',width:'30',hidden:true},
							{field:'PatientId',title:'病人ID',width:'100',hidden:true},//,hidden:true
							{field:'PatientName',title:'病人姓名',width:'100'},
							{field:'Sex',title:'性别',width:'100',editor:{type:'text'}},
							{field:'Age',title:'年龄',width:'100',editor:{type:'text'}},
							{field:'PatientNo',title:'登记号',width:'100',editor:{type:'text'}}
						]],
						pagination:true,
						onSelect:function(i,rowData){
							console.log("index="+index+",rowData=",rowData);
							var row = $("#grid").datagrid("getSelected");
							var index = $("#grid").datagrid("getRowIndex",row);
							var edSex = $("#grid").datagrid('getEditor', {'index': index, field: "Sex"});
							$(edSex.target).val(rowData.Sex);
							var edAge = $("#grid").datagrid('getEditor', {'index': index, field: "Age"});
							$(edAge.target).val(rowData.Age);
							var edPNo = $("#grid").datagrid('getEditor', {'index': index, field: "PatientNo"});
							$(edPNo.target).val(rowData.PatientNo);
							var edPId = $("#grid").datagrid('getEditor', {'index': index, field: "PatientId"});
							$(edPId.target).val(rowData.PatientId);
						}
					}	
				}
			},
			{field:'Sex',title:'性别',width:'100',editor:{type:'text'}},
			{field:'Age',title:'年龄',width:'100',editor:{type:'text'}},
			{field:'PatientNo',title:'登记号',width:'100',editor:{type:'text'}},
			{field:'StDate',title:'开始日期',width:'150',editor:{type:'datebox'},
				formatter:function(value,row,index){
					return value;
				}
			},
			{field:'EndDate',title:'结束日期',width:'150',editor:{type:'datebox'},
				formatter:function(value,row,index){
					return value;
				}
			}
		]],
		onBeginEdit: function(index,row){
			var edSex = $("#grid").datagrid('getEditor', {'index': index, field: "Sex"});
			$(edSex.target).attr("disabled", true);
			var edAge = $("#grid").datagrid('getEditor', {'index': index, field: "Age"});
			$(edAge.target).attr("disabled", true);
			var edPNo = $("#grid").datagrid('getEditor', {'index': index, field: "PatientNo"});
			$(edPNo.target).attr("disabled", true);
			var edPId = $("#grid").datagrid('getEditor', {'index': index, field: "PatientId"});
			$(edPId.target).attr("disabled", true);
		},
		delHandler:function(row){
			var _t=this;
			$.messager.confirm("删除","该操作会删除记录，确定删除【"+row.PatientName+"】记录吗?", function(r){
				if(r){
					$.extend(_t.delReq,{"dto.testperson.id":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		},
		insOrUpdHandler:function(row){
			var param;
			var _t = this;
			if(row.ID==""){
				if(row.PatientName==""){
					$.messager.popover({msg:"病人名字不能为空!",type:"info"});
					return;
				}
				param = _t.insReq;
			}else{
				param = $.extend(_t.updReq,{"dto.testperson.id":row.ID});
			}
			if(!compareDate(row.StDate,row.EndDate)){
				$.messager.popover({msg:"结束日期不能小于开始日期!",type:"alert"});
				//$("#search").trigger("click");
				return;
			}
			$.extend(param,{"dto.testperson.PatientId":row.PatientId,"dto.testperson.StDate":row.StDate,"dto.testperson.EndDate":row.EndDate});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {ID:"",PatientName:"",StDate:"",EndDate:""};	
		}
	});
	$("#search").click(function(){
		var patientNo=$("#patientNo").val();
		if (patientNo!='') {
			if (patientNo.length<10) {
				for (var i=(10-patientNo.length-1); i>=0; i--) {
					patientNo="0"+patientNo;
				}
			}
		}
		$("#patientNo").val(patientNo);
		var patientName = $("#patientName").val();
		$("#grid").datagrid("load",{
			ClassName:"CF.BSP.SYS.SRV.TestPerson",
			QueryName:"Find",
			PPatientName:patientName,
			PPatientNo:patientNo
		});
	});
	
	///回车触发查询
	var debounce_search=function(){
		$("#search").click();
	}
	if (typeof $.hisui.debounce=="function") {
		debounce_search=$.hisui.debounce(debounce_search,200);
	}
	$('#patientNo,#patientName').on('keyup',function(event) {
        if (event.keyCode == "13") {
        	debounce_search();
        }
	})
	
}
function compareDate(StDate,EndDate){
	if (StDate!="" && EndDate!=""){
		var stArr = StDate.split("-");
		var endArr = EndDate.split("-");
		if(stArr[0]<endArr[0]){
			return true;
		}else if(stArr[0]==endArr[0]){
			if(stArr[1]<endArr[1]){
				return true;
			}else if(stArr[1]==endArr[1]){
				if(stArr[2]<endArr[2]){
					return true;
				}
			}
		}
		return false;
	}else{
		return true;
	}
	
}
$(init);